unit Tables;

interface

uses
  Vcl.StdCtrls, Vcl.CheckLst, Vcl.ComCtrls, Vcl.Forms, Vcl.Graphics,
  System.Classes, System.SysUtils, Data.DB, dbisamtb, Winapi.Windows,
  Dialogs, at_gen_utils, System.Types, VirtualTrees, LoggerLib, Defs, Log,
  Average;

const
  BP_LOWEST_EVER = 870;
  FIELDNAMES: array [0..9] of String = ('wsDate',     'wsTime',     'wsWindDir',
                                        'wsWindAvr',  'wsWindPk',   'wsTemp',
                                        'wsHumidity', 'wsRainDay',  'wsRainHour',
                                        'wsPressure');

procedure CheckTable(DBName: String; TableName: String);
procedure EmptyTable(DBName, TableName: String);
function  ImportData(DBName, TableName, FileName: String): String;

function  LoadData(DBName: String; var Ax: TAxes; Log: TStrings = nil): Integer;
function  LoadMaxMinData(DBName: String; var Ax: Taxes; var PlotBuffer: TDualPlotBuffer): Integer;

procedure AddTableData(Date: Word; STime, ETime: DWord; List: TVirtualStringTree; Order: Integer = -1);
function  GetDataCount(DBName: String): Integer;
procedure MakeData(DBName, TableName: String; Date: DWord);
procedure RemoveData(DBName, TableName: String; Date: DWord);
function  GetRowCount(DBName, TableName: String; Date: DWord): Integer;



implementation

(*
Fields
*  Integers
0  Date
1  Time
*  Small ints
2  WindDir
3  WindSpdAvr
4  WindSpdPk
5  Temp
6  Humidity
7  RainDay
8  RainHour
9  RainMin
19 Pressure
*)

function GetDataCount(DBName: String): Integer;
var
  Query: TDBIsamQuery;
begin
  try
    Query := TDBIsamQuery.Create(nil);
    Query.DatabaseName := DBName;
    Query.SQL.Text := 'SELECT COUNT(*) FROM WsData';
    Query.ExecSQL;
    Result := Query.Fields[0].AsInteger;
  finally
    Query.Free;
  end;
end;

procedure AddTableData(Date: Word; STime, ETime: DWord; List: TVirtualStringTree; Order: Integer = -1);
var
  N: pVirtualNode;
  ND: pWsData;
  Query: TDBIsamQuery;
  SRef, ERef: DWord;
begin
  if List.RootNodeCount > 0 then // clear existing list
    repeat
      N := List.GetFirst();
      if (N <> nil) then
        List.DeleteNode(N);
    until (N = nil);

  try
    Query := TDBIsamQuery.Create(nil);
    Query.SQL.Text := Format('SELECT * FROM WsData where WsDate = %d and (WsTime >= %d and WsTime <= %d)',
                                              [Date,
                                               STime,
                                               ETime]);

    if (Order > 0) then
    begin
      Query.SQL.Text := Format('%s ORDER BY %s', [qUERY.SQL.Text, FIELD_NAMES[Order]]);
    end;

    Query.ExecSQL;

    if Query.RecordCount > 0 then
    begin
      Query.First;
      while not Query.EOF do
      begin
        N := List.InsertNode(nil, amInsertAfter);
        ND := List.GetNodeData(N);

        if ND <> nil then
        begin
          ND.Date   := Query.Fields[0].AsInteger;
          ND.Time   := Query.Fields[1].AsInteger;
          ND.Dir    := Query.Fields[2].AsInteger;
          ND.AvrSpd := Query.Fields[3].AsInteger;
          ND.PkSpd  := Query.Fields[4].AsInteger;
          ND.Temp   := Query.Fields[5].AsInteger;
          ND.Humid  := Query.Fields[6].AsInteger;
          ND.Day    := Query.Fields[7].AsInteger;
          ND.Hour   := Query.Fields[8].AsInteger;
          ND.Min    := Query.Fields[9].AsInteger;
          ND.Pres   := Query.Fields[10].AsInteger;
        end;
        Query.Next;
      end;
    end;
  finally
    Query.Free;
  end;
end;


procedure EmptyTable(DBName, TableName: String);
var
  Table: TDBIsamTable;
begin
  try
    Table := TDBIsamtable.Create(nil);

    Table.Exclusive := True;
    Table.Open;
    Table.EmptyTable;
    Table.Close;

    Table.Exclusive := false;
  finally
    Table.Free;
  end;
end;

procedure RemoveData(DBName, TableName: String; Date: DWord);
var
  Query: TDBIsamQuery;
begin
  try
    Query := TDBIsamQuery.Create(nil);
    Query.DatabaseName := DBName;

    Query.SQL.Text := Format('DELETE FROM %s WHERE WsDate = %d', [TableName, Date]);
    Query.ExecSQL;

  finally
    Query.Free;
  end;
end;

procedure MakeData(DBName, TableName: String; Date: DWord);
var
  Table: TDBIsamTable;
  Tm: DWord;
  Temp, Humid: SmallInt;
begin
  try
    Table := TDBIsamtable.Create(nil);
    Table.DatabaseName := DBName;
    Table.TableName := TableName;

    Table.Open;

    Humid := 0;
    Temp := 300;

    Tm := 0;
    while Tm < 86400 do
    begin
      Table.InsertRecord([Date, Tm + 1, 0, 0, 0, Temp, Humid, 0, 0, 0, 0]);
      if ((Tm > 0) and (Tm mod 3600 = 0)) then
      begin
        Inc(Temp, 8);
        Inc(Humid, 4);
      end;
      Inc(Tm, 60);
    end;
    Table.Close;
  finally
    Table.Free;
  end;
end;

// much easier to do this with a table rather than a query
function ImportData(DBName, TableName, FileName: String): String;
var
  LineNo, i, Min: Integer;
  Curdate: Integer;
  Fs: TFieldSet;
  Table: TDBIsamTable;
  ErrorList, List: TStringList;
  Wd: SmallInt;
begin
  Result:= '';;

  try
    List      := TStringList.Create;
    ErrorList := TStringList.Create;

    List.LoadFromFile(FileName);
    Result := '';

    Table := TDBIsamTable.Create(nil);
    Table.DatabaseName := DBName;
    Table.TableName := TableName;
    Table.Open;

    if (List.Count > 0) then
    begin
 //   first line is the date
      Curdate := StrToInt(Copy(List.Strings[0], 2, Length(List.Strings[0])));

//    delete any existing entries for the day
      Table.SetRange([CurDate], [CurDate]);
      ErrorList.Add(Format('Records removed from table: %d', [Table.RecordCount]));

      Table.First;
      while Table.RecordCount > 0 do
        Table.Delete;

      Table.CancelRange;

      LineNo := 1;

      while ((CurDate <> 0) and (LineNo < List.Count)) do
      begin
        CSVToText(List.Strings[LineNo], Fs, ' ');

//      Prepend a dollar to force hex conversion
        for i := 0 to Fs.Count - 1 do
          Fs.Fields[i] := '$' + Fs.Fields[i];

//      subtract 10s from time to ensure round down
        Min := ((Fs.Fields[0].toInteger - 5) div 60) * 60;

//      ensure that direction is 0 - 360 degrees
        Wd := Fs.Fields[1].ToInteger();
        if Wd < 0 then
          Wd := Wd + 360;

        try
          Table.InsertRecord([                          // Field No & function
                          curdate,                      //  0 Date
                          Min,                          //  1 Time
                          Wd,                           //  2 Wind Dir
                          Fs.Fields[2].ToInteger,       //  3 Wind Speed Avr
                          Fs.Fields[3].ToInteger,       //  4 Wind Speed Pk
                          Fs.Fields[4].ToInteger,       //  5 Temp
                          Fs.Fields[5].ToInteger,       //  6 Humid
                          Fs.Fields[6].ToInteger,       //  7 Day Rain
                          Fs.Fields[7].ToInteger,       //  8 Hour Rain
                          Fs.Fields[8].ToInteger,       //  9 Min Rain
                          Fs.Fields[9].ToInteger          // 10 Pressure
                         ]);
        except
          on e:exception do
          begin
            ErrorList.Add(Format('Insert error %s Line: %d %s %d (%X)', [List.Strings[LineNo], LineNo, Fs.Fields[0], Min, Min]));
            ErrorList.Add(e.Message);
            break;
          end;
        end;
        Inc(LineNo);
      end;
      ErrorList.Add(Format('Records inserted: %d', [LineNo - 1]));
    end;
  finally
    Result := Trim(ErrorList.Text);
    Table.Close;
    Table.Free;
    ErrorList.Free;
    List.Free;
  end;
end;

procedure CheckTable(DBName: String; TableName: String);
var
  Q: TDBIsamQuery;
  Txt: String;
begin
  try
    Q := TDBIsamQuery.Create(nil);
    Q.DatabaseName := DBName;
    Q.SQL.Text := Format('SELECT WsDate FROM %s', [TableName]);
    try
      Q.ExecSQL;
    except
      on e:exception do
      begin
        Q.SQL.Clear;
        Q.SQL.Add(Format('CREATE TABLE IF NOT EXISTS %s', [TableName]));
        Q.SQL.Add('(');
        Q.SQL.Add('WsDate INT,');
        Q.SQL.Add('WsTime INT,');
        Q.SQL.Add('WsWindDir SMALLINT,');
        Q.SQL.Add('WsWindAvr SMALLINT,');
        Q.SQL.Add('WsWindPk SMALLINT,');
        Q.SQL.Add('WsTemp SMALLINT,');
        Q.SQL.Add('WsHumidity SMALLINT,');
        Q.SQL.Add('WsRainDay SMALLINT,');
        Q.SQL.Add('WsRainHour SMALLINT,');
        Q.SQL.Add('WsRainMin SMALLINT,');
        Q.SQL.Add('WsPressure SMALLINT,');
        Q.SQL.Add('PRIMARY KEY (WsDate, WsTime)');
        Q.SQL.Add(')');
        Q.ExecSQL;
      end;
    end;
  finally
    Q.Close;
    Q.Free;
  end;
end;

(*
 * Build an array (mmA) of daily max and min values for each of the days within
 * the range Ax.StartDate to Ax.EndDate inclusive. Once the data is loaded into
 * mmA then stretch it,   where necessary, to fit into the plot buffer.
 *)
function LoadMaxMinData(DBName: String; var Ax: Taxes; var PlotBuffer: TDualPlotBuffer): Integer;
var
  Q: TDBIsamQuery;
  Idx, OutIdx, Day, SampleCount: Integer;
  mmA: TMaxMinArray;
begin
  Ax.DualLine := True;

  Ax.Data_Days := Ax.EndDate - Ax.StartDate + 1;
  SetLength(mmA.Max, Ax.Data_Days);
  SetLength(mmA.Min, Ax.Data_Days);
  mmA.Count := Ax.Data_Days;

  for Idx := 0 to mmA.Count - 1 do
  begin
    mmA.Max[Idx] := INVALID_DATA;
    mmA.Min[Idx] := INVALID_DATA;
  end;

// get n days data from database
  try
    Q := TDBIsamQuery.Create(nil);
    Q.DatabaseName := DBName;

    Idx := 0;
    mmA.Count := 0;

    for Day := Ax.StartDate to Ax.EndDate do
    begin
      Q.SQL.Text := Format('select Max(%s), Min(%s) from WsData where WsDate = %d and %s > 0',
                                  [Ax.Field_Name, Ax.Field_Name, Day, Ax.Field_Name]);
      Q.ExecSQL;
      if Q.RecordCount = 1 then
      begin
        if (Q.Fields[0].AsInteger <> 0) and (Q.Fields[1].AsInteger <> 0) then
        begin
          mmA.Max[Idx] := Round((Q.Fields[0].AsInteger - Ax.Y_ScaleFactor.Subtract) * Ax.Y_ScaleFactor.Scale);
          mmA.Min[Idx] := Round((Q.Fields[1].AsInteger  - Ax.Y_ScaleFactor.Subtract) * Ax.Y_ScaleFactor.Scale);
          Q.Close;
        end;
      end;
      Inc(Idx);
      Inc(mmA.Count);
    end;
  finally
    Q.Free;
    Q := nil;
  end;

  case Ax.X_Scale_Type of
   0: Ax.DataMultiplier :=  1; // wind dir
   1: Ax.DataMultiplier :=  1; // wind speed avr
   2: Ax.DataMultiplier :=  1; // wind speed pk
   3: Ax.DataMultiplier := 10; // temp
   4: Ax.DataMultiplier := 10; // humudity
   5: Ax.DataMultiplier :=  1; // rain day
   6: Ax.DataMultiplier :=  1; // rain hour
   7: Ax.DataMultiplier :=  1; // rain min
   8: Ax.DataMultiplier := 10; // pressure
  end;

  Result := mmA.Count;

  for OutIdx := 0 to PLOT_BUFFER_SIZE - 1 do
  begin
    PlotBuffer.Max[OutIdx] := INVALID_DATA;
    PlotBuffer.Min[OutIdx] := INVALID_DATA;
  end;

(* Stretch the max and min samples to fill the required space.
  * The size of the stretch is determined by the STRETCH_SIZE
  * array *)

  SampleCount := Ax.Data_Days;
  Ax.Max := -32678;
  Ax.Min :=  32768;
  Idx := 0;
  OutIdx := 0;

  while Idx < Ax.Data_Days do
  begin
    SampleCount := STRETCH_SIZE[Ax.Period];
    while SampleCount > 0 do
    begin
      if mmA.Max[Idx] <> INVALID_DATA then
      begin
        if mmA.Max[Idx] > Ax.Max then
          Ax.Max := mmA.Max[Idx];

        if mmA.Max[Idx] < Ax.Min then
          Ax.Min := mmA.Max[Idx];

        PlotBuffer.Max[OutIdx] := mmA.Max[Idx];
      end;

      if mmA.Min[Idx] <> INVALID_DATA then
      begin
        if mmA.Min[Idx] > Ax.Max then
          Ax.Max := mmA.Min[Idx];

        if mmA.Min[Idx] < Ax.Min then
          Ax.Min := mmA.Min[Idx];

        PlotBuffer.Min[OutIdx] := mmA.Min[Idx];
      end;

      Inc(OutIdx);
      Dec(SampleCount);
    end;
    Inc(Idx);
  end;
  PlotBuffer.Count := OutIdx;
  Ax.Data_Samples := OutIdx;
  Ax.Max := RoundUpDown(Ax.Max, rdUp);
  Ax.Min := RoundUpDown(Ax.Min, rdDown);
  Ax.DataMax := Ax.Max;
  Ax.DataMin := Ax.Min;
end;

(*
 * load date, time and selected field (Ax.Field_Name) between dates Ax.StartDate and Ax.Endate
 * All data is loaded so 1440 records per day. Two years (max) is 1,052,640 records
 *)
function LoadData(DBName: String; var Ax: Taxes; Log: TStrings = nil): Integer;
var
  Q: TDBIsamQuery;
  Idx, DayIdx, CalcIdx, Day, CurDay, CurMin, Data, ValidReadings, BufferLen: Integer;
const
(*
 * DB_DataMultiplier ix the factor to make all db field values the
 * same scale, 10X the actual value.
 *)
  DB_DataMultiplier: array [0..7] of Integer = (  1, 10, 10,    // wind ?
                                                  1,            // temp - already x10
                                                  1,            // humidity - already x10
                                                  1, 1,         // rain is x1
                                                  1 );          // bp - already x10
begin
  Ax.DataMultiplier := DB_DataMultiplier[Ax.X_Scale_Type];
  Ax.Data_Days := Ax.EndDate - Ax.StartDate + 1;
  BufferLen := (Ax.Data_Days * 1440) + 10;
  SetLength(__QueryData, BufferLen);

// get n days data from database
  try
    Q := TDBIsamQuery.Create(nil);
    Q.DatabaseName := DBName;
(*  FIELD Numbers
 *  2 Wind Direction, 3 Wind Speed Average, 4 Wind Speed Peak,  5 Temperature
 *  6 Humidity,       7 Rainfall per day,   8 Rainfall/hour,    9 Rainfall per minute
 * 10 Barometric Pressure
*)

    Q.SQL.Text := Format('SELECT WsDate, WsTime, %s from WsData where WsDate >= %d and WsDate <= %d',
                               [Ax.Field_Name, Ax.StartDate, Ax.EndDate]);
                          //  0    1    2    3        4        5          6
    Q.ExecSQL;
    Q.First;

    ValidReadings := 0;
    Day := 0;
    Ax.Min :=  10000;
    Ax.Max := -10000;

    if Q.RecordCount > 0 then
    begin
    //  ckear the data area of the buffer
    for Idx := 0 to BufferLen - 1 do
      __QueryData[Idx] := INVALID_DATA;

      Q.First;
//    skip any missing days
      while ((Ax.StartDate + Day) < Q.Fields[0].AsInteger) and (Day < Ax.Data_Days) do
        Inc(Day);

      repeat // for each day in range
        CalcIdx := 0;

        while CalcIdx < 1440 do
        begin
          CurDay := Q.Fields[0].AsInteger;
          DayIdx := (CurDay - Ax.StartDate) * 1440;
          CurMin := Q.Fields[1].AsInteger;
          Data := Q.Fields[2].AsInteger;// * Ax.DataMultiplier;

//        any bp reading less than 800 is in error
          if (Ax.Data_Field = 10) and (Data < MINBP) then
             Data := INVALID_DATA;

          Idx := CurMin div 60;

          if Idx <> CalcIdx then
          begin // missing reading
            repeat
              Inc(CalcIdx);
            until (CalcIdx = Idx) or (CalcIdx = 1440);
          end else
          begin
            __QueryData[DayIdx + CalcIdx] := Round(Data * Ax.DataMultiplier);
            Inc(ValidReadings);
          end;

          Inc(CalcIdx);
          Q.Next;

          if (Q.Eof) or (CurDay <> Q.Fields[0].AsInteger) then
            Break;
        end;
        Inc(Day);

      until Day = Ax.Data_Days;

      Q.Close;
    end;
  finally
    Result := ValidReadings;
    Q.Free;
    Q := nil;
  end;
end;

end.
