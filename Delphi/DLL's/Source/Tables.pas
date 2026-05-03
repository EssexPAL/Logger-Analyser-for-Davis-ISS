unit Tables;

(* Updated on 09/04/2026 to include RSSI in the fields *)

interface

uses
    Sharemem,
    Defs, System.Classes, System.Types, VirtualTrees, System.SysUtils,
    ATUtils, Average, Vcl.Dialogs, System.DateUtils, Vcl.Clipbrd

  {$IFNDEF USEDLL}
    ,dbisamtb
  {$ENDIF}
  ;

const
  BP_LOWEST_EVER = 870;
  FIELDNAMES: array [0..10] of String = ('wsDate',     'wsTime',    'wsWindDir',
                                        'wsWindAvr',  'wsWindPk',   'wsTemp',
                                        'wsHumidity', 'wsRainDay',  'wsRainHour',
                                        'wsPressure', 'wsRSSI');
  DLLVER = 204;

// USEDLL is defined (or not defined) in Project/Options/Conditional defines


{$IFNDEF USEDLL}
// USE THE LIBRARY
function  GetHighestDate(DBName: String; TableName: String): Integer; stdcall;
function  LoadData(DBName, TableName: String;  Qd: pQd; var Ax: TAxes; Log: TStrings = nil): Integer; stdcall;
procedure CheckTable(DBName: String; TableName: String); stdcall;
procedure EmptyTable(DBName, TableName: String); stdcall;
function  OldImportData(DBName, TableName, FileName: String): String; stdcall;
function  ImportData(DBName, TableName: String; Data: TWsDataList): String; stdcall;
function  LoadMaxMinData(DBName, TableName: String; var Ax: Taxes; var PlotBuffer: TDualPlotBuffer): Integer; stdcall;
procedure LoadRainData(DBName, TableName: String; Qd: pQd; var Ax: Taxes); stdcall;
function  LoadLastDataPeriod(DBName, TableName: String; Qd: pQd; var Ax: Taxes; InfoBuffer: TStringList): Integer; stdcall;
function  LoadPolarData(DBName, TableName: String; Ax: TAxes; var Pi: TPolarInfo): Integer; stdcall;
function  LoadWindData(DBName, TableName: String; Ax: TAxes; var Si: TSegmentInfo; InfoBuffer: TStringList): Integer; stdcall;
procedure AddTableData(DBName, TableName: String; Date: Word; STime, ETime: DWord; List: TVirtualStringTree; Order: Integer = -1); stdcall;
function  GetDataCount(DBName, TableName: String): Integer; stdcall;
function  GetHighestTime(DBName: String; TableName: String; TheDate: Integer): Integer; stdcall;
function  GetRecordCountForDay(DBName: String; TableName: String; TheDate: Integer): Integer; stdcall;
function  GetDLLVer: Integer;
function  SetRecord(DBName, TableName: String; Data: pWsData): Boolean; stdcall;

{$ELSE}

// USE THE DLL
function  GetHighestDate(DBName: String; TableName: String): Integer; stdcall; external 'WsIsam.dll';
function  LoadData(DBName, TableName: String;  Qd: pQd; var Ax: TAxes; Log: TStrings = nil): Integer; stdcall;  external 'WsIsam.dll';
procedure CheckTable(DBName: String; TableName: String); stdcall;  external 'WsIsam.dll';
procedure EmptyTable(DBName, TableName: String); stdcall;  external 'WsIsam.dll';
function  ImportData(DBName, TableName: String; Data: TWsDataList): String; stdcall; external 'WsIsam.dll';
function  LoadMaxMinData(DBName, TableName: String; var Ax: Taxes; var PlotBuffer: TDualPlotBuffer): Integer; stdcall;  external 'WsIsam.dll';
procedure LoadRainData(DBName, TableName: String; Qd: pQd; var Ax: Taxes); stdcall;  external 'WsIsam.dll';
function  LoadRainDataHourly(DBName, TableName: String; Qd: pQd; var Ax: Taxes): Integer; stdcall;  external 'WsIsam.dll';
function  LoadLastDataPeriod(DBName, TableName: String; Qd: pQd; var Ax: Taxes; InfoBuffer: TStringList): Integer; stdcall;  external 'WsIsam.dll';
function  LoadPolarData(DBName, TableName: String; Ax: TAxes; var Pi: TPolarInfo): Integer; stdcall;  external 'WsIsam.dll';
function  LoadWindData(DBName, TableName: String; Ax: TAxes; var Si: TSegmentInfo; InfoBuffer: TStringList): Integer; stdcall; external 'WsIsam.dll';
procedure AddTableData(DBName, TableName: String; Date: Word; STime, ETime: DWord; List: TVirtualStringTree; Order: Integer = -1); stdcall;  external 'WsIsam.dll';
function  GetDataCount(DBName, TableName: String): Integer; stdcall;  external 'WsIsam.dll';
function  Repair_DB_Record(DBName, TableName: String; RecDate: Word): String ; stdcall;  external 'WsIsam.dll';
function  GetRecordCountForDay(DBName: String; TableName: String; TheDate: Integer): Integer; stdcall; external 'WsIsam.dll';
function  GetDLLVer: Integer ; stdcall;  external 'WsIsam.dll';
function  SetRecord(DBName, TableName: String; Data: pWsData): Boolean; stdcall; external 'WsIsam.dll';

{$ENDIF}

implementation

{$IFNDEF USEDLL}

type
  WsRecord = record
  WsDate:     Integer;
  WsTime:     Integer;
  WsWindDir:  Integer;
  WsWindAvr:  Integer;
  WsWindPk:   Integer;
  WsTemp:     Integer;
  WsHumidity: Integer;
  WsRainDay:  Integer;
  WsRainHour: Integer;
  WsRainMin:  Integer;
  WsPressure: Integer;
  end;


function GetDLLVer: Integer;
begin
  Result := DLLVER;
end;

// update a data record using TWsData structure
function SetRecord(DBName, TableName: String; Data: pWsData): Boolean; stdcall;
var
  Query: TDBIsamQuery;
  Idx: Integer;
  Str: String;
const
  FieldName: array [0..11] of String = ('WsDate',     'WsTime',     'WsWindDir',  'WsWindAvr',
                                        'WsWindPk',   'WsTemp',     'WsHumidity', 'WsRainDay',
                                        'WsRainHour', 'WsRainMin',  'WsPressure', 'WsRSSI');
begin
  Result := False;

  Query := TDBIsamQuery.Create(nil);
  try
    Query.DatabaseName := DBName;

    Query.SQL.Add(Format('UPDATE %s', [TableName]));
    Idx := 2;
    Query.SQL.Add('SET');
    while Idx < 12 do
    begin
      case Idx of
       2: Str := Format('%s = %d', [FieldName[Idx], Data.Dir]);
       3: Str := Format('%s = %d', [FieldName[Idx], Data.AvrSpd]);
       4: Str := Format('%s = %d', [FieldName[Idx], Data.PkSpd]);
       5: Str := Format('%s = %d', [FieldName[Idx], Data.Temp]);
       6: Str := Format('%s = %d', [FieldName[Idx], Data.Humid]);
       7: Str := Format('%s = %d', [FieldName[Idx], Data.Day]);
       8: Str := Format('%s = %d', [FieldName[Idx], Data.Hour]);
       9: Str := Format('%s = %d', [FieldName[Idx], Data.Day]);
      10: Str := Format('%s = %d', [FieldName[Idx], Data.Pres]);
      11: Str := Format('%s = %d', [FieldName[Idx], Data.Rssi]);
      end;

      if Idx < 11 then
        Str := Str + ',';
      Query.SQL.Add(Str);
      Inc(Idx);
    end;

    Query.SQL.Add(Format('WHERE %s = %d AND %s = %d', [FieldName[0], Data.Date, FieldName[1], Data.Time]));

    try
      Query.ExecSQL;
      Result := True;
    except
      ;
    end;

  finally
    Query.Free;
  end;
end;

function GetDataCount(DBName, TableName: String): Integer; stdcall;
var
  Query: TDBIsamQuery;
begin
  Query := TDBIsamQuery.Create(nil);
  try
    Query.DatabaseName := DBName;
    Query.SQL.Text := Format('SELECT COUNT(*) FROM %s', [TableName]);
    Query.ExecSQL;
    Result := Query.Fields[0].AsInteger;
  finally
    Query.Free;
  end;
end;

(* add one days worth of data to a VST *.  Indexes are created as needed *)
procedure AddTableData(DBName, TableName: String; Date: Word; STime, ETime: DWord; List: TVirtualStringTree; Order: Integer = -1); stdcall;
var
  N: pVirtualNode;
  ND: pWsData;
  Query: TDBIsamQuery;
begin
  if List.RootNodeCount > 0 then // clear existing list
    repeat
      N := List.GetFirst();
      if (N <> nil) then
        List.DeleteNode(N);
    until (N = nil);

  Query := TDBIsamQuery.Create(nil);
  Query.DatabaseName := DBName;

  try
    Query.SQL.Text := Format('SELECT * FROM %s where WsDate = %d and (WsTime >= %d and WsTime <= %d)',
                                              [ TableName,
                                                Date,
                                                STime,
                                                ETime]);

    if (Order > 0) then
    begin
      Query.SQL.Text := Format('%s ORDER BY %s', [Query.SQL.Text, FIELD_NAMES[Order]]);
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
          ND.Date   := Query.FieldByName('WsDate').AsInteger;
          ND.Time   := Query.FieldByName('WsTime').AsInteger;
          ND.Dir    := Query.FieldByName('WsWindDir').AsInteger;
          ND.AvrSpd := Query.FieldByName('WsWindAvr').AsInteger;
          ND.PkSpd  := Query.FieldByName('WsWindPk').AsInteger;
          ND.Temp   := Query.FieldByName('WsTemp').AsInteger;
          ND.Humid  := Query.FieldByName('WsHumidity').AsInteger;
          ND.Day    := Query.FieldByName('WsRainDay').AsInteger;
          ND.Hour   := Query.FieldByName('WsRainHour').AsInteger;
          ND.Min    := Query.FieldByName('WsRainMin').AsInteger;
          ND.Pres   := Query.FieldByName('WsPressure').AsInteger;
          ND.Rssi   := ShortInt(Query.FieldByName('WsRSSI').AsInteger);
        end;
        Query.Next;
      end;
    end;
  finally
    Query.Free;
  end;
end;

procedure EmptyTable(DBName, TableName: String); stdcall;
var
  Table: TDBIsamTable;
begin
  Table := TDBIsamtable.Create(nil);
  Table.DatabaseName := DBName;
  Table.TableName := TableName;
  try

    Table.Exclusive := True;
    Table.Open;
    Table.EmptyTable;
    Table.Close;

    Table.Exclusive := false;
  finally
    Table.Free;
  end;
end;

// much easier to do this with a table rather than a query
function OldImportData(DBName, TableName, FileName: String): String; stdcall;
var
  LineNo, i, Min: Integer;
  Curdate: Integer;
  Fs: TFieldSet;
  Table: TDBIsamTable;
  ErrorList, List: TStringList;
  Wd: SmallInt;
begin
  Result:= '';;

  List      := TStringList.Create;
  ErrorList := TStringList.Create;
  Table := TDBIsamTable.Create(nil);

  try
    List.LoadFromFile(FileName);
    Result := '';

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

// much easier to do this with a table rather than a query
function ImportData(DBName, TableName: String; Data: TWsDataList): String; stdcall;
var
  DataLen, Idx, EditCount, InsertCount: Integer;
  Table: TDBIsamTable;
  ErrorList: TStringList;
begin
  Result:= '';

  ErrorList := TStringList.Create;
  DataLen := Length(Data);
  Table := TDBIsamTable.Create(nil);

  try
    Table.DatabaseName := DBName;
    Table.TableName := TableName;
    Table.Open;

    if (DataLen > 0) then
    begin
      Idx := 0;
      EditCount := 0;
      InsertCount := 0;

      while (Idx < DataLen) do
      begin
        if Table.FindKey([Data[Idx].Date, Data[Idx].Time]) then
        begin
          Table.Edit;
          Table.Fields[ 0].AsInteger := Data[Idx].Date;   // 0 Date
          Table.Fields[ 1].AsInteger := Data[Idx].Time;   // 1 Time
          Table.Fields[ 2].AsInteger := Data[Idx].Dir;    // 2 Wind Dir
          Table.Fields[ 3].AsInteger := Data[Idx].AvrSpd; // 3 Wind Spd Avr
          Table.Fields[ 4].AsInteger := Data[Idx].PkSpd;  // 4 Wind Sp Pk
          Table.Fields[ 5].AsInteger := Data[Idx].Temp;   // 5 Temp
          Table.Fields[ 6].AsInteger := Data[Idx].Humid;  // 6 Humid
          Table.Fields[ 7].AsInteger := Data[Idx].Day;    // Day Rain
          Table.Fields[ 8].AsInteger := Data[Idx].Hour;   // Hour rain
          Table.Fields[ 9].AsInteger := Data[Idx].Min;    // Min Rain
          Table.Fields[10].AsInteger := Data[Idx].Pres;   // Pressure
          Table.Fields[11].AsInteger := Data[Idx].Rssi;   // RSSI
          Table.Post;
          Inc(EditCount);
        end else
        begin
          Table.InsertRecord([                            // Field No & function
                            Data[Idx].Date,               //  0 Date
                            Data[Idx].Time,               //  1 Time
                            Data[Idx].Dir,                //  2 Wind Dir
                            Data[Idx].AvrSpd,
                            Data[Idx].PkSpd,
                            Data[Idx].Temp,
                            Data[Idx].Humid,
                            Data[Idx].Day,
                            Data[Idx].Hour,
                            Data[Idx].Min,
                            Data[Idx].Pres,
                            Data[Idx].Rssi]);
          Inc(InsertCount);
          end;
        Inc(Idx);
      end;

      ErrorList.Add(Format('%-17s %4d - %-17s %4d - %-17s %4d', ['Rows of data:', DataLen,
                                                                 'Records inserted:', InsertCount,
                                                                 'Records amended', EditCount
                                                                 ]));

// Rows of data:      827 - Records inserted:    1 - Records amended    826

//      ErrorList.Add(Format('%-17s %4d', ['Rows of data:', DataLen]));
//      ErrorList.Add(Format('%-17s %4d', ['Records inserted:', InsertCount]));
//      ErrorList.Add(Format('%-17s %4d', ['Records amended', EditCount]));
//      ErrorList.Add('');
    end;
  finally
    Result := ErrorList.Text;
    Table.Close;
    Table.Free;
    ErrorList.Free;
  end;
end;

(* Check to see if the table exists and create if not. Only the primary index is needed *)
(* 09/04/26 wsRSSI field added *)
procedure CheckTable(DBName: String; TableName: String); stdcall;
var
  Q: TDBIsamQuery;
begin
  Q := TDBIsamQuery.Create(nil);
  try
    Q.DatabaseName := DBName;
    Q.SQL.Text := Format('SELECT Min(WsDate) FROM %s', [TableName]);
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
        Q.SQL.Add('WsRSSI SMALLINT,');
        Q.SQL.Add('PRIMARY KEY (WsDate, WsTime)');
        Q.SQL.Add(')');
        Q.ExecSQL;
      end;
    end;
  finally
    Q.Close;
    FreeandNil(Q);
  end;
end;

(* Get the highest date in the database or return -1 if there are no records *)
function GetHighestDate(DBName: String; TableName: String): Integer; stdcall;
var
  Q: TDBIsamQuery;
begin
  Q := TDBIsamQuery.Create(nil);
  try
    Q.DatabaseName := DBName;
    Q.SQL.Text := Format('SELECT Max(WsDate) FROM %s', [TableName]);
    Q.ExecSQL;
    if Q.RecordCount > 0 then
      Result := Q.Fields[0].AsInteger
    else
      Result := -1;
  finally
    Q.Close;
    Q.Free;
    Q := nil;
  end;
end;

(* Get the highest time for the selected date *)
function GetHighestTime(DBName: String; TableName: String; TheDate: Integer): Integer; stdcall;
var
  Q: TDBIsamQuery;
begin
  Q := TDBIsamQuery.Create(nil);
  try
    Q.DatabaseName := DBName;
    Q.SQL.Text := Format('SELECT Max(WsTime) FROM %s WHERE WsDate = %d', [TableName, TheDate]);
    Q.ExecSQL;
    if Q.RecordCount > 0 then
      Result := Q.Fields[0].AsInteger
    else
      Result := -1;
  finally
    Q.Close;
    Q.Free;
    Q := nil;
  end;
end;

(* Get the record count for the selected date *)
function GetRecordCountForDay(DBName: String; TableName: String; TheDate: Integer): Integer; stdcall;
var
  Q: TDBIsamQuery;
begin
  Q := TDBIsamQuery.Create(nil);
  try
    Q.DatabaseName := DBName;
    Q.SQL.Text := Format('SELECT COUNT(WsTime) FROM %s WHERE WsDate = %d', [TableName, TheDate]);
    Q.ExecSQL;
    if Q.RecordCount > 0 then
      Result := Q.Fields[0].AsInteger
    else
      Result := 0;
  finally
    Q.Close;
    Q.Free;
    Q := nil;
  end;
end;

(*
 * Build an array (mmA) of daily max and min values for each of the days within
 * the range Ax.StartDate to Ax.EndDate inclusive. Once the data is loaded into
 * mmA then stretch it,   where necessary, to fit into the plot buffer.
 *)
function LoadMaxMinData(DBName, TableName: String; var Ax: Taxes; var PlotBuffer: TDualPlotBuffer): Integer; stdcall;
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
  Q := TDBIsamQuery.Create(nil);
  try
    Q.DatabaseName := DBName;

    Idx := 0;
    mmA.Count := 0;

    for Day := Ax.StartDate to Ax.EndDate do
    begin
      Q.SQL.Text := Format('select Max(%s), Min(%s) from %s where WsDate = %d and %s > 0',
                                  [Ax.Field_Name, Ax.Field_Name, TableName, Day, Ax.Field_Name]);
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

//  SampleCount := Ax.Data_Days;
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
  Ax.Max := RoundUpDown(Ax.Max, rdUp, -2);
  Ax.Min := RoundUpDown(Ax.Min, rdDown, -2);
  Ax.DataMax := Ax.Max;
  Ax.DataMin := Ax.Min;
end;

(* Non specialised data load routine.
 * load date, time and selected field (Ax.Field_Name) between dates Ax.StartDate and Ax.Endate
 * All data is loaded so 1440 records per day. Two years (max) is 1,052,640 records.  Takes
 * a pointer to an array of smallint.  This allows for the DLL.
 *)
function LoadData(DBName, TableName: String; Qd: pQd; var Ax: Taxes; Log: TStrings = nil): Integer; stdcall;
var
  Q: TDBIsamQuery;
  Idx, DayIdx, CalcIdx, Day, CurDay, CurMin, Data, ValidReadings, BufferLen: Integer;
const
(*
 * DB_DataMultiplier ix the factor to make all db field values the
 * same scale, 10X the actual value.
 *)
  DB_DataMultiplier: array [1..12] of Integer = (  1, 1, 1, 10, 10,   // 0..4 wind ?
                                                   1,                 // 5    temp - already x10
                                                   1,                 // 6    humidity - already x10
                                                   1, 1,              // 7..8 rain is x1
                                                   1,                 // 9    bp - already x10
                                                   1,                 // 10   rainfall rate v
                                                   1);                // 12   RSSI
begin
  Ax.DataMultiplier := DB_DataMultiplier[Ax.X_Scale_Type];

  Ax.Data_Days := Ax.EndDate - Ax.StartDate + 1;
  Ax.Data_Samples := Ax.Data_Days * SAMPLES_PER_DAY;

  BufferLen := (Ax.Data_Days * SAMPLES_PER_DAY) + 10;
  SetLength(Qd^, BufferLen);

//  ckear the buffer
  for Idx := 0 to BufferLen - 1 do
    Qd^[Idx] := INVALID_DATA;


// get n days data from database
  Q := TDBIsamQuery.Create(nil);
  try
    Q.DatabaseName := DBName;
(*  FIELD Numbers
 *  2 Wind Direction, 3 Wind Speed Average, 4 Wind Speed Peak,  5 Temperature
 *  6 Humidity,       7 Rainfall per day,   8 Rainfall/hour,    9 Rainfall per minute
 * 10 Barometric Pressure 11 RSSI
*)

    Q.SQL.Text := Format('SELECT WsDate, WsTime, %s from %s where WsDate >= %d and WsDate <= %d',
                               [Ax.Field_Name, TableName, Ax.StartDate, Ax.EndDate]);
    Q.ExecSQL;

    ValidReadings := 0;
    Day     := 0;
    Ax.Min  :=  10000;
    Ax.Max  := -10000;

    if Q.RecordCount > 0 then
    begin
      Q.First;
//    skip any missing days
      while ((Ax.StartDate + Day) < Q.Fields[0].AsInteger) and (Day < Ax.Data_Days) do
        Inc(Day);

      repeat // for each day in range
        CalcIdx := 0;

        while CalcIdx < SAMPLES_PER_DAY do
        begin
          CurDay := Q.Fields[0].AsInteger;
          DayIdx := (CurDay - Ax.StartDate) * SAMPLES_PER_DAY;
          CurMin := Q.Fields[1].AsInteger;

          if Ax.Data_Field = 11 then
            Data := ShortInt(Q.Fields[2].AsInteger)
          else
            Data := Q.Fields[2].AsInteger;

//        any bp reading less than 800 is in error
          if (Ax.Data_Field = 10) and (Data < MINBP) then
             Data := INVALID_DATA;

          Idx := CurMin div 60;

          if Idx <> CalcIdx then
          begin // missing reading
            repeat
              Inc(CalcIdx);
            until (CalcIdx = Idx) or (CalcIdx = SAMPLES_PER_DAY);
          end else
          begin
            Qd^[DayIdx + CalcIdx] := Round(Data * Ax.DataMultiplier) + Ax.BPCorrection;
            Inc(ValidReadings);
          end;

          Inc(CalcIdx);
          Q.Next;

          if (Q.Eof) or (CurDay <> Q.Fields[0].AsInteger) then
            Break;
        end;
        Inc(Day);

      until Day = Ax.Data_Days;
    end;
  finally
    Result := ValidReadings;
    Q.Close;
    Q.Free;
    Q := nil;
  end;
end;

(* Load the wind directton data.  The data is organised into 36 bins i.e. 10 degree interva;s *)
function LoadPolarData(DBName, TableName: String; Ax: TAxes; var Pi: TPolarInfo): Integer; stdcall;
var
  Q: TDBIsamQuery;
  DirIdx, Quad, DMax: Integer;
begin
// clear the buffer
  for Quad := 0 to 3 do
  begin
    Pi.Values[Quad].MaxSpeed := 0;
    Pi.Values[Quad].MaxDir := 0;
    for DirIdx := 0 to 35 do
      Pi.Values[Quad].Quad[DirIdx] := 0;

    Pi.MaxSpeed := 0;
  end;

// get n days data from database
  Q := TDBIsamQuery.Create(nil);
  try
    Q.DatabaseName := DBName;

//  get collect the wind direction and speeds
    Q.SQL.Clear;
//                              0       1        2          3          4
    Q.SQL.Add(Format('SELECT WsDate, WsTime, WsWindDir, WsWindAvr, WsWindPk from %s where WsDate between %d and %d',
                               [TableName, Ax.StartDate, Ax.EndDate]));
    Q.ExecSQL;
    Q.First;
    Result := Q.RecordCount;

    Ax.Data_Samples := Q.RecordCount;
    Ax.DataMax := 0;

    while not Q.eof do
    begin
      DirIdx := Q.Fields[2].AsInteger div 10; // make an index from wind angle
      Quad := Q.Fields[1].AsInteger div 21600;// make an index into the appropriate quad

      if Q.Fields[3].AsInteger > 0 then
      begin
        Inc(Pi.Values[Quad].Quad[DirIdx]); // total wind for segment
      end;

      if Pi.MaxSpeed < Pi.Values[Quad].Quad[DirIdx] then
        Pi.MaxSpeed := Pi.Values[Quad].Quad[DirIdx];

      if Pi.Values[Quad].MaxSpeed < Pi.Values[Quad].Quad[DirIdx] then
        Pi.Values[Quad].MaxSpeed := Pi.Values[Quad].Quad[DirIdx];

      Q.Next;
    end;
    Q.Close;
  finally
    Q.Close;
    Q.Free;
  end;

// find the maximum direction for each quadrant
  for Quad := 0 to 3 do
  begin
    DMax := 0;
    for DirIdx := 0 to 35 do
      if DMax < Pi.Values[Quad].Quad[DirIdx] then
      begin
        DMax := Pi.Values[Quad].Quad[DirIdx];
        Pi.Values[Quad].MaxDir := DirIdx;
      end;
  end;
end;



function LoadWindData(DBName, TableName: String; Ax: TAxes; var Si: TSegmentInfo; InfoBuffer: TStringList): Integer; stdcall;
var
  Q: TDBIsamQuery;
  DirIdx, SpdIdx: Integer;
  SpeedMax, IncrementsPerBin, SubTotal: Integer;
  SpeedBuffer, UnitText: String;
  ScaleMultiplier: Single;

const
  Angles: array [0..15] of String= ('348..  9', ' 10.. 32', ' 33.. 54', ' 55.. 77',
                                    ' 78.. 99', '100..122', '123..144', '145..167',
                                    '168..189', '190..212', '213..234', '235..257',
                                    '258..279', '280..302', '303..324', '325..347');


begin
// clear the buffer
  for DirIdx := 0 to ROSE_SEGMENTS - 1 do
  begin
    Si.Data[DirIdx].Direction := 0;
    Si.Data[DirIdx].RawDir := 0;
    for SpdIdx := 0 to 4 do
      Si.Data[DirIdx].Speed[SpdIdx] := 0;
  end;

  InfoBuffer.Clear;

  Si.TotalActiveWind := 0;

// get n days data from database
  Q := TDBIsamQuery.Create(nil);
  try
    Q.DatabaseName := DBName;

//  get the max wind speed for the period and prepare to collect wind speeds
  try
    Q.SQL.Clear;
    Q.SQL.Add(Format('SELECT Max(wsWindAvr) from %s where wsDate between %d and %d', [TableName, Ax.StartDate, Ax.EndDate]));
    Q.ExecSQL;
  except
    on e:exception do
      ShowMessage(e.Message);

  end;

    SpeedMax := Q.Fields[0].AsInteger;
    case SpeedMax of
    0..5:     begin
                SpeedMax := 5;
                IncrementsPerBin := 1;
              end;
    6..10:    SpeedMax := 10;
    11..15:   SpeedMax := 15;
    16..20:   SpeedMax := 20;
    21..50:   SpeedMax := 50;
    51..100:  SpeedMax := 100;
    end;

    Si.SpeedMax := SpeedMax;
    Si.SpeedStep := Si.SpeedMax div 5;

    if SpeedMax > 5 then
      IncrementsPerBin := Trunc((SpeedMax - 5) / 5) + 1;

//  Collect the wind direction and speeds
    Q.SQL.Clear;
//                              0       1        2          3          4
    Q.SQL.Add(Format('SELECT WsDate, WsTime, WsWindDir, WsWindAvr, WsWindPk from %s where WsDate between %d and %d',
                               [TableName, Ax.StartDate, Ax.EndDate]));
    Q.ExecSQL;
    Q.First;
    Result := Q.RecordCount;
    if Result = 0 then
      Exit;


    Ax.Data_Samples := Q.RecordCount;
    Ax.DataMax := 0;
    Si.TotalActiveWind := 0;

    while not Q.eof do
    begin
//    convert the wind angle to an index into a wind direction accumulation array
      DirIdx := (((Q.Fields[2].AsInteger * 100) + 1125) div 2250) mod 16;

//    accumulate the total time the wind has been blowing in each segment
      if Q.Fields[3].AsInteger > 0 then
      begin
        Inc(Si.Data[DirIdx].RawDir); // total wind for segment
        Inc(Si.TotalActiveWind);     // total wind for sample period

//      create an index into the wind speed array
        if SpeedMax <= 5 then
          SpdIdx:= (Q.Fields[3].AsInteger - 1)
        else
        begin
          SpdIdx := Trunc((Q.Fields[3].AsInteger - 1) / IncrementsPerBin);
        end;
        Si.Data[DirIdx].Speed[SpdIdx] := Si.Data[DirIdx].Speed[SpdIdx] + 1;
      end;
      Q.Next;
    end;
    Q.Close;
  finally
      Q.Close;
    Q.Free;
  end;

  Si.ColursInUse := 0;

//  convert the raw direction data to percentage an build the wind speed list
    InfoBuffer.Add('Seg    Wind       Raw     Seg   Speed   Speed   Speed   Speed   Speed   Speed');
    InfoBuffer.Add('Idx -- Dir --    Mins  Length     Max     0       1       2       3       4');

  Si.ColursInUse := 0;

  for DirIdx := 0 to 15 do
  begin
    Si.Data[DirIdx].Direction := ((1 / Ax.Data_Samples) * Si.Data[DirIdx].RawDir) * 100;

    Si.Data[DirIdx].SpeedMax := 0;

    SubTotal := 0;

    for SpdIdx := 0 to 4 do
    begin
      if Si.Data[DirIdx].RawDir > 0 then
      begin
        Si.Data[DirIdx].SpeedMax      := Si.Data[DirIdx].SpeedMax + Round(Si.Data[DirIdx].Speed[SpdIdx]);
        SubTotal                      := SubTotal + Round(Si.Data[DirIdx].Speed[SpdIdx]);
        Si.Data[DirIdx].Speed[SpdIdx] := (Si.Data[DirIdx].Speed[SpdIdx] / Si.Data[DirIdx].RawDir) * 100;

        if SpdIdx > Si.ColursInUse then
          Si.ColursInUse := SpdIdx;

        if SubTotal = Si.Data[DirIdx].RawDir then
          Break;
      end;
    end;

    if Si.Data[DirIdx].SpeedMax > Si.SpeedMax then
      Si.SpeedMax := Si.Data[DirIdx].SpeedMax;

    SpeedBuffer := '';
    for SpdIdx := 0 to 4 do
      SpeedBuffer := Format('%s %5.1f%% ', [SpeedBuffer, Si.Data[DirIdx].Speed[SpdIdx]]);

    InfoBuffer.Add(Format('%2d   %8s  %6d  %5.2f%%  %6d %s', [
                                                          DirIdx,
                                                          Angles[DirIdx],
                                                          Si.Data[DirIdx].RawDir,
                                                          Si.Data[DirIdx].Direction,
                                                          Si.SpeedMax,
                                                          SpeedBuffer
                                                         ]));

  end;
    InfoBuffer.Add('');

    case Si.UnitIndex of
    W_MPS:  begin
              ScaleMultiplier := 0.44704;   // m/sec
              UnitText := 'm/s';
            end;
    W_KPH:  begin
              ScaleMultiplier := 1.60934;   // kph
              UnitText := 'KPH';
            end;
    W_MPH:  begin
              ScaleMultiplier := 1;         // mph
              UnitText := 'MPH';
            end;
    end;

  InfoBuffer.Add('Wind Speeds');
  SpeedBuffer := '';

  for SpdIdx := 0 to Si.ColursInUse do
  begin
    SpeedBuffer := (Format('%s %3.1f to %3.1f', [
                                SpeedBuffer,
                                (Si.SpeedStep * SpdIdx) * ScaleMultiplier,
                                (Si.SpeedStep * SpdIdx + 1) * ScaleMultiplier
                                                 ]));
    if SpdIdx < Si.ColursInUse then
      SpeedBuffer := SpeedBuffer + ', ';

  end;

  SpeedBuffer := SpeedBuffer + ' ' + UnitText;

  InfoBuffer.Add(SpeedBuffer);
  InfoBuffer.Add('');

  InfoBuffer.Add(Format('Start Date: %s (%d) End Date: %s Period: %d Day/s', [
                                DateToStr(Si.pAxes^.StartDate + AT_DATE_OFFSET),
                                Si.pAxes^.StartDate,
                                DateToStr(Si.pAxes^.EndDate + AT_DATE_OFFSET),
                                Si.pAxes^.EndDate - Si.pAxes^.StartDate + 1
                               ]));
  InfoBuffer.Add(Format('Expected Samples: %d Actual Samples: %d', [
                                (Si.pAxes^.EndDate - Si.pAxes^.StartDate + 1) * SAMPLES_PER_DAY,
                                Si.pAxes^.Data_Samples
                               ]));

end;

(*
 * Load the field (Ax.Field_Name) in the final reocrd of each day
 * between the dates specified by Ax.Startdate and Ax.EndDate.
 * Any period > 1 day.  It will not prouduce a result for any
 * day that doesnt have a proper last record (Time >= 86340)
 *)
function LoadLastDataPeriod(DBName, TableName: String; Qd: pQd; var Ax: Taxes; InfoBuffer: TStringList): Integer;
var
  Q: TDBIsamQuery;
  OutIdx, BufferLen: Integer;
begin
  Ax.DataMultiplier := 1;
  Ax.Data_Days := Ax.EndDate - Ax.StartDate + 1;
  BufferLen := Ax.Data_Days;
  SetLength(Qd^, BufferLen);
  InfoBuffer.Clear;

// clear the buffer
  for OutIdx := 0 to BufferLen - 1 do
    Qd^[OutIdx] := 0;

// get n days data from database
  Q := TDBIsamQuery.Create(nil);
  try
    Q.DatabaseName := DBName;

    Q.SQL.Clear;
    Q.SQL.Add(Format('SELECT WsDate, WsTime, %s from %s where WsDate between %d and %d',
                               [Ax.Field_Name, TableName, Ax.StartDate, Ax.EndDate]));
    Q.SQL.Add('and WsTime >= 86340');
    Q.SQL.Add('and wsRainDay > 0');
    Q.ExecSQL;
    Q.First;

    InfoBuffer.Add(Q.SQL.Text);

    Result := Q.RecordCount;
    Ax.Min := 0;
    Ax.Max := 0;

//  place data into the correct spot in the buffer
    while not Q.EOF do
    begin
      OutIdx := Q.Fields[0].AsInteger - Ax.StartDate;
      Qd^[OutIdx] := Q.Fields[2].AsInteger;

      if Qd^[OutIdx] > Ax.Max then
        Ax.Max := Qd^[OutIdx];

      InfoBuffer.Add(Format('%d %d', [OutIdx, Qd^[OutIdx]]));

      Q.Next;
    end;
  finally
    Ax.DataMax := Ax.Max;
    Q.Close;
    Q.Free;
  end;
end;

(*
 * Load final record of each hour between the dates specified
 * by Ax.Startdate and Ax.EndDate.

function LoadRainDataHourly(DBName, TableName: String; Qd: pQd; var Ax: Taxes): Integer;

  This function has been replaced using one which collects the rainfall data
  from the tips per minute field
*)

(*
  Extract the DAILY rain info from the tips per minute field.
  A one day period runs a query recovering 1440 results and building
  24 totals using code.
  Other periods use a SUM query which repeats to give the appropriate
  number data sammples.

     1 day    24 hourly samples
   1/2 week    7 or 14 daily samples
     1 month  28 to 31 daily samples
   3/6 months 13 or 26 weekly samples
   1/2 year   12 or 24 monthly samples
*)
procedure LoadRainData(DBName, TableName: String; Qd: pQd; var Ax: Taxes);
var
  Idx, OutIdx, BufferLen, DailyTotal, StartDate, EndDate, DateIncrement, DateCount: Integer;
  Query: TDBIsamquery;
  S: String;
begin
  Ax.DataMultiplier := 1;

  Ax.Data_Days := Ax.EndDate - Ax.StartDate + 1;
  StartDate := Ax.StartDate;
  EndDate := Ax.EndDate;

  DateIncrement := 1;

  case Ax.Period of
  0:  begin // 1 day
        BufferLen := 24;
        DateCount := 1;
      end;
  1:  begin // 1 week, 7 daily totals
        BufferLen := 7;
        DateCount := 7;
      end;
  2:  begin // 2 weeks, 14 daily totals
        BufferLen := 14;
        DateCount := 14;
      end;
  3:  begin // 1 month, , calculate days
        BufferLen := 31;
        DateCount := System.DateUtils.DaysInMonth(Ax.StartDate + AT_DATE_OFFSET);
      end;
  4:  begin // 3 months, 13 weekly totals
        BufferLen := 13;
        DateIncrement := 7;
        DateCount := 13;
      end;
  5:  begin // six months, 26 weekly totals
        BufferLen := 26;
        DateIncrement := 7;
        DateCount := 26;
      end;
  6:  begin // 12 months, 12 monthly totals
        BufferLen := 12;
        DateCount := 12;
      end;
  7:  begin // 24 months, 24 monthly totals
        BufferLen := 24;
        DateCount := 24;
      end;
  end;

  Ax.Data_Samples := BufferLen;
  SetLength(Qd^, BufferLen);

// clear the buffer
  for OutIdx := 0 to BufferLen - 1 do
    Qd^[OutIdx] := 0;

  Query := TDBIsamQuery.Create(nil);
  SetLength(Ax.DateList, BufferLen);
  DailyTotal := 0;
  s := '';

  try
    Query.DatabaseName := DBName;
    Ax.DataMax := 0;

//  Get the data
    if Ax.Period = 0 then
    begin // data for 1 day
      Idx := 0;
//    for a one day period fill the dates buffer with the day
      while Idx < BufferLen do
      begin
        Ax.DateList[Idx] := StartDate;
        Inc(Idx);
      end;

      Query.SQL.Text := Format('SELECT wsDate, wsTime, wsrainmin FROM %s WHERE wsDate BETWEEN %d AND %d AND wsRainMin > 0',
                            [TableName, StartDate, EndDate]);
      Query.ExecSQL;

      Ax.DataMax := 0;

//    loop through the results adding the tip count to the buffer
      while not Query.Eof do
      begin
        Idx := Query.Fields[1].AsInteger div 3600;
        Inc(Qd^[Idx], Query.Fields[2].AsInteger);
        Inc(DailyTotal, Query.Fields[2].AsInteger);

        if Ax.DataMax < Qd^[Idx] then
          Ax.DataMax := Qd^[Idx];

        Query.Next;
      end;
    end else
    begin // data for all other periods
      Idx := 0;
      S := '';
      while DateCount > 0 do
      begin
        if Ax.Period in [6, 7]  then
          DateIncrement := System.DateUtils.DaysInMonth(StartDate + AT_DATE_OFFSET);

//      keep the start date of each query
        Ax.DateList[Idx] := StartDate;

        Query.SQL.Text := Format('SELECT sum(wsrainmin) FROM %s WHERE wsDate BETWEEN %d AND %d AND wsRainMin > 0',
                            [TableName, StartDate, StartDate + DateIncrement - 1]);

        Query.ExecSQL;

//      add the tip count to the array
        if Query.RecordCount > 0 then
        begin
          Qd^[Idx] := Query.Fields[0].AsInteger;

          if Ax.DataMax < Query.Fields[0].AsInteger then
            Ax.DataMax := Query.Fields[0].AsInteger;
        end;

        S := S + Query.SQL.Text + ' ' + Query.Fields[0].AsString + '    '#10#13;

        Dec(DateCount);
        Inc(StartDate, DateIncrement);
        Inc(Idx);
        Query.Close;
      end;
      Clipboard.AsText := s;
    end;

  finally
    Query.Close;
    Query.Free;
    Ax.Max := Ax.DataMax;
  end;
end;

{$ENDIF}

end.


