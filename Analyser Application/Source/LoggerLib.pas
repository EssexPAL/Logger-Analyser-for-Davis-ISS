unit LoggerLib;

interface

uses
  ShareMem,
  System.SysUtils, System.Types, IniFiles, Vcl.Forms, Vcl.ExtCtrls, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Graphics, Vcl.ComCtrls, Vcl.CheckLst, System.Math, IdHTTP, System.Classes,
  Printers, System.DateUtils, IdComponent, Defs, Average, Windows, Tables,
  IdStack, ulkJson, WinSock, System.IOUtils, ATUtils, System.StrUtils, Registry;

// The following all use Ini/Registry
function  DoSettingsExist(St: TSettingType): Boolean;
procedure LoadAllSettings(St: TSettingType; var Ps: TConfig; var Ms: TMeasurementSettings; IPList: TComboBox);
procedure SaveAllSettings(St: TSettingType; Ps: TConfig; Ms: TMeasurementSettings; IPList: TComboBox; Init: Boolean; FirstTime: Boolean = false);
procedure SetIniDefaults(var Ps:  TConfig; var Ms: TMeasurementSettings; IPList: TComboBox);

function  DiskSizeToString(Value: Int64): String;
procedure RestartLogger(Client: TIdHTTP; URL: String);

// data related procedures
procedure DecodeDate(var d, m, y: word; TheDate: word; FourDigitYear: Boolean = true);
procedure DecodeTime(var h, m, s: word; TheTime: Integer);
function  TimeToString(TheTime: Integer): String;
function  EncodeTime(h: Word; m: word; s: word): Integer;
function  GetDateWindow(TheDate: TDate; range: Word): TDateRange;
function  GetTimeWindow(StartIndex: Byte; range: Byte): TTimeRange;

function  MakeYParameters(var Ax: TAxes): Integer;

function  MakeYTitle(Measurement: Integer; Settings: TMeasurementSettings): String;
function  MakeXTitle(Ax: TAxes): String;
procedure InitGraph(Scale: Single);
function  GoBackMonths(SelDate: TDate; BackMonths: Byte): TDate;
procedure DrawArrow(Canvas: TCanvas; Origin: TPoint; Angle, RadiusIn, RadiusOut: Integer);
function  AverageAllAngles(Vectors: array of TVectors): Integer;
procedure DrawCircle(c: TCanvas;  Origin: TPoint; Rad: Word);
procedure SortByYMD(Dir: TStringList);
function  IntToTimeStr(Value: Integer): String;
function  Get_File(Client: TidHTTP; URL, FileName: String; var FileText: String; Log: String): Integer;
function  FindRain(Index: Integer; SampleMax: Integer): Integer;

// plot to TImage
procedure Plot_Bar(Ax: TAxes; Img: TImage; Settings: TMeasurementSettings; D: array of SmallInt);
procedure Plot_Line2(Ax: TAxes; Img: TImage; Settings: TMeasurementSettings; D: TDualPlotBuffer); overload;

procedure Plot_HOURLYRAINtext(Graph: TImage; Ax: TAxes; Top: Integer; Ms: TMeasurementSettings);
procedure Plot_TOTALRAINtext(Graph: TImage; Ax: TAxes; Top: Integer; Ms: TMeasurementSettings);

// resample data
procedure Fill_PlotBufferWithDATA(var PlotBuffer: array of SmallInt; var Ax: TAxes);
procedure Fill_PlotBufferWithHOURLYRAIN(var PlotBuffer: array of SmallInt; var Ax: TAxes);
procedure Fill_PlotBufferWithWIND_SPD_PK(var PlotBuffer: array of SmallInt; var Ax: TAxes);
procedure Fill_PlotBufferWithTOTALRAIN(var PlotBuffer: array of SmallInt; var Ax: TAxes; Fit: boolean = true);
procedure Fill_PlotBufferWithWIND_SPD_PK_BAR(var PlotBuffer: array of SmallInt; var Ax: TAxes);
procedure Fill_PlotBufferWithRoseDATA(var PlotBuffer: array of SmallInt; var Ax: TAxes);
procedure Fill_PlotBufferWithPERIOD_DATA(var PlotBuffer: array of SmallInt; var Ax: TAxes);
procedure Fill_PlotBufferWithWIND_DIR_DATA(var PlotBuffer: array of SmallInt; var Ax: TAxes);
function  Analyse_RFRateDATA(Ax: TAxes): String;
function  CheckForRain(Ax: TAxes): Boolean;

procedure Fill_PlotBufferWithRAIN(var PlotBuffer: array of SmallInt; var Ax: TAxes);

function  MakeXScaleText1(TickNo: Integer; Ax: TAxes): TScaleText;
function  ATDateTimeToStr(Dt: Integer; Tm: Integer): String;
function  ATTimeToStr(Tm: Integer): String;

procedure FindMaxMin(var Ax: TAxes; Buffer: array of SmallInt; BufferSize: Integer);
function  MakeEndDate(var Ax: TAxes): String;

procedure ClearGraph(Graph: TImage);
function  ValidateFile(FileName: String): String;
procedure GetScaleValue(var Ax: TAxes; Ms: TMeasurementSettings);
function  GetBPCorrection(Alt: Integer; cu: BPCorrectionUnit): Single;
function  GetBPOffset(Alt: Integer; cu: BPCorrectionUnit): Single;

function  MakeShortDate(Dt: Integer): String;

procedure ProcessFile(var Info: String; FileName, DBName, TableName: String; var DataList: TWsDataList); overload;
procedure ProcessFile(var Info: String; Data: TStringList; DBName, TableName: String; var DataList: TWsDataList); overload;

function  RepairData(var Data: TWsDataList): String;

procedure Fill_PlotBufferWithTestData(var PlotBuffer: array of SmallInt; var Ax: TAxes; Fit: boolean = true);
function  GetKBState: Byte;

function  GetFV(const FileName: string): string;

function IPTextToIP32(IP: String): DWord;
function IP32ToText(Value: DWord): String;
function GetCurrentlyActiveIPAddress: String;

function GetDewPoint(T, RH: Integer; IsCentigrade: Boolean): Single;

procedure Pad_TB_ButtonWidth(TB: TToolbar);

procedure LoadRSSI(FileName: String;  var Data: TDualPlotBuffer);

procedure BuildDataList(Src: TStringList; var DataList: TWsDataList);


implementation

(*  Get the currently active IP address.  Using DNS is
    toooo slow so get the available adaptor addresses
    and choose from those.  Only addresses in the range
    192.168.0.1 to 192.168.2.255 are valid.  If more
    than one is available then the user will be prompted
    to choose. *)
function GetCurrentlyActiveIPAddress: String;
var
  AList, MList, DList: TStringList;
  i, match, AddVal: Integer;
  WSAData: TWSAData;
  Fs: TFieldset;
  TTl, Prompt, Add: String;
  OK: Boolean;
begin
  Result := '';
  AList := TStringList.Create;
  MList := TStringList.Create;
  DList := TStringList.Create;

  try
    if WSAStartup($0101, WSAData) = 0 then
    begin
      TIdStack.IncUsage;

//    get list of ip addresses for adaptors
      GStack.AddLocalAddressesToList(AList);

      match := 0;
//    find the first adaptor at the bottom of the range
      for i := 0 to AList.Count - 1 do
      begin
        if AList.Strings[i].Length > 0 then
        begin
          CSVToText(AList.Strings[i], Fs, '.');
          if  (Fs.Fields[0] = '192') and
              (Fs.Fields[1] = '168') and
              (Fs.Fields[2].ToInteger < 2) then
          begin
            Inc(match);
            MList.Add(AList.Strings[i]);
          end;
        end;
      end;

      if match = 1 then
        Result := MList.Strings[0]
      else
        OK := False;
        if match > 1 then
        begin
          DList.Add('There is more than one IP address for this computer!');
          DList.Add('Please select the correct one from the list below using its number:');
          for i := 0 to MList.Count - 1 do
            DList.Add(Format('Address %d %s', [i + 1, MList.Strings[i]]));

          ShowMessage(DList.Text);
          TTl := 'Enter address number';
          Prompt := Format('Enter address number between 1 and %d', [match]);
          repeat
            Add := InputBox(TTl, Prompt, '1');
            if Add.Length > 0 then
            begin
              if TryStrToInt(Add, AddVal) then
              begin
                if (AddVal >= 1) and (AddVal <= match) then
                begin
                  Result := MList.Strings[AddVal - 1];
                  OK := True;
                end;
              end;

            end;
          until OK;

        end;

    WSACleanup();
    end else
    begin
      ShowMessage('Winsock is not responding."');
      Exit('');
    end;
  finally
    AList.Free;
    MList.Free;
    DList.Free;
  end;
end;

{$ifdef oldGetCurrentlyActiveIPAddress}
(* Get the currently active IP address.  The routine uses the presence of
   the DNS suffix .lan, there must be a better way of doing this!
   way to do this.  This routine only works if the computer is connected
   to the internet.  If the machine has multiple connected ports then this
   is the only way to determine which is the one currently being used. *)
function GetCurrentlyActiveIPAddress: String;
var
  List: TStringList;
  AnsiStr: AnsiString;
  slen, i, Idx: Integer;
  addr: array [0..20] of AnsiChar;
  phe: pHostEnt;
  WSAData: TWSAData;
  ia: in_addr;
begin
  Result := '';

  if WSAStartup($0101, WSAData) <> 0 then
  begin
    ShowMessage('Winsock is not responding."');
    Exit;
  end;

  TIdStack.IncUsage;

//  get list of ip addresses for adaptors
  List := TStringList.Create;
  GStack.AddLocalAddressesToList(List);

  for Idx := 0 to List.Count - 1 do
  begin
    AnsiStr := List.Strings[Idx];
    slen := Length(List.Strings[Idx]);

    for i := 0 to slen - 1 do
      addr[i] := AnsiStr[i + 1];

    addr[slen] := #0;

    ia.S_addr := inet_addr(@addr);

//  get the host info
    phe := GetHostByAddr(@ia, 4, 0);

//  check the DNS suffix, active address is '.lan'
    if Pos('.lan', phe.h_name) > 0 then
    begin
      Result := List.Strings[Idx];
      break;
    end;
  end;
  List.Free;
  WSACleanup();
end;

{$endif}

(*
  Load the RSSI data.  Make no attempt to mask any missing or erroneous values.
  Once the daily data is in QData then average pairs of values down to give
  a finaal 720 points to display on the graph.
*)
procedure LoadRSSI(FileName: String; var Data: TDualPlotBuffer);
var
  Sl: TStringList;
  Len, i, Idx, NiTmp: Integer;
  Fmt, CurLine: String;
  Fs: TFieldSet;
  NoData: Boolean;
  SiTmp: ShortInt;
  QData: array [0..SAMPLES_PER_DAY] of ShortInt;
begin
  Sl := nil;

  if TFile.Exists(FileName) then
  begin
    try
      Sl := TStringList.Create;
      Sl.LoadFromFile(FileName);

//    clear RSSI array
      i := 0;
      while i < SAMPLES_PER_DAY do
      begin
        QData[i] := -120;
        if i < 720 then
          Data.Max[i]  := -120;
        Inc(i);
      end;

      if Sl.Count > 1 then
      begin
        CSVToText(Sl.Strings[1], Fs, ' ');
        NoData := (Fs.Count < 11);
      end;

      if not NoData then
      begin
        i:= 1; // skip the header

        // load the rssi data
        while (i <= SAMPLES_PER_DAY) do // first line is the date, data starts on line 1
        begin
          if i >= Sl.Count then // if the file is short them stretch the data
            SiTmp := -110//Last
          else
          begin
            CSVToText(Sl.Strings[i], Fs, ' ');
            if Fs.Count = 11 then
            begin
              if TryStrToInt('$' + Fs.Fields[10], NiTmp) then
                SiTmp := NiTmp
              else
                SiTmp := -120;
            end;
          end;

          QData[i - 1] := SiTmp;
          Inc(i);
        end;


//      Average the samples down to 720
        i := 0;
        Idx := 0;
        while i < SAMPLES_PER_DAY do
        begin
          Data.Max[Idx] := (QData[i] + QData[i + 1]) div 2;
          Inc(i, 2);
          Inc(Idx);
        end;

      end else
        MessageDlg('There is no RSSI information to display', mtWarning, [mbOK], 0);
    finally
      Sl.Free;
    end;
  end;
end;


(* The toolbar buttons are autosized so pad their captions be around the
   same width.  The makes the buttons fill the toolbar *)
procedure Pad_TB_ButtonWidth(TB: TToolbar);
var
  Idx, W: Integer;
begin

  Idx := 0;
  while Idx < TB.ButtonCount do
  begin
    W := TB.Canvas.TextWidth(TB.Buttons[Idx].Caption);
    while W < BUTTONTEXTWIDTH do
    begin
      TB.Buttons[Idx].Caption := ' ' + TB.Buttons[Idx].Caption + ' ';
      W := TB.Canvas.TextWidth(TB.Buttons[Idx].Caption);
    end;
    Inc(Idx);
  end;
end;

(*
 * The simple way to evaluate dew point
 * https://journals.ametsoc.org/view/journals/bams/86/2/bams-86-2-225.xml?tab_body=pdf
 * Td = T - ((100 - RH) / 5), T = Degrees C
 * Input: Temperature is Fahrenheit * 10
 *        Humidity is %RH * 10
 * Result: Centigrade or Fahrenheith
*)
function GetDewPoint(T, RH: Integer; IsCentigrade: Boolean): Single;
var
  TC: Single;
begin
// The ISS raw data is in fahrenheit, calculation is in centigrade
  TC := ((T - 320) * 0.55555) / 10; // convert to centigrade

  Result := TC - ((100 - (RH / 10)) / 5);

  if IsCentigrade = False then
    Result := (Result * 1.8) + 32;
end;

function GetFV(const FileName: string): string;
var
    infoSize: DWORD;
    verBuf:   pointer;
    verSize, Wnd:  UINT;
    FixedFileInfo: PVSFixedFileInfo;
begin
  infoSize := GetFileVersioninfoSize(PChar(FileName), wnd);

  result := '';

  if infoSize <> 0 then
  begin
    GetMem(verBuf, infoSize);
    try
      if GetFileVersionInfo(PChar(FileName), wnd, infoSize, verBuf) then
      begin
        VerQueryValue(verBuf, '\', Pointer(FixedFileInfo), verSize);

        result := IntToStr(FixedFileInfo.dwFileVersionMS div $10000) + '.' +
                  IntToStr(FixedFileInfo.dwFileVersionMS and $0FFFF) + '.' +
                  IntToStr(FixedFileInfo.dwFileVersionLS div $10000) + '.' +
                  IntToStr(FixedFileInfo.dwFileVersionLS and $0FFFF);
      end;
    finally
      FreeMem(verBuf);
    end;
  end;
end;

procedure Fill_PlotBufferWithTestData(var PlotBuffer: array of SmallInt; var Ax: TAxes; Fit: boolean = true);
var
  OutIdx, Value: Integer;
  Up: Boolean;                                  begin
  for OutIdx := 0 to PLOT_BUFFER_SIZE - 1 do
    PlotBuffer[OutIdx] := -255;

  OutIdx := 0;
  Value := 0;
  Up := True;

  while OutIdx < 760 do
  begin
    PlotBuffer[OutIdx] := Value;

    if Up then
      Inc(Value, 2)
    else
      Dec(Value, 2);

    if Value = 900 then
      Up := False;

    Inc(OutIdx);
  end;

  FindMaxMin(Ax, PlotBuffer, 720);
  Ax.Data_Samples := OutIdx;
end;

(*
 *  Get the appropriate value to convert between the WS data and the
 *  displayed values. i.e. from mB to mmHG, from Fahrenfeit to Celcius
 *  Raw values
 *  Wind direction - degrees
 *  Wind Speed MPH
 *  Temperature degrees F
 *  Barometric pressure (using Bosch sensor BMP280) mB
 *  Also get the scale multiplier value (1 or 10)
 *  Also get barometric pressure altitude correction
 *)
procedure GetScaleValue(var Ax: TAxes; Ms: TMeasurementSettings);
begin
  Ax.Y_ScaleFactor.Subtract := 0; // only used for deg F to C
  Ax.DataMultiplier := 10;

  case Ax.X_Scale_Type of
  1, 2, 3:
      begin
        Ax.Y_ScaleFactor.Scale := 1; // wind direction in degrees
        Ax.DataMultiplier      := 1;
        Ax.YTitle              := 'Wind Direction';
      end;
  4:  begin
        case Ax.ReadingType of  // Wind speed average
        W_MPS: Ax.Y_ScaleFactor.Scale             := 0.44704;   // m/sec
        W_KPH: Ax.Y_ScaleFactor.Scale             := 1.60934;   // kph
        W_MPH: Ax.Y_ScaleFactor.Scale             := 1;         // mph
        end;
        Ax.YTitle := Format('Maximum Average Wind Speed %s', [UNIT_STRINGS[0, MeasurementSettings.Wind]]);
      end;
  5:  begin
        case Ax.ReadingType of  // Wind speed peak
        W_MPS: Ax.Y_ScaleFactor.Scale             := 0.44704;   // m/sec
        W_KPH: Ax.Y_ScaleFactor.Scale             := 1.60934;   // kph
        W_MPH: Ax.Y_ScaleFactor.Scale             := 1;         // mph
        end;
        Ax.YTitle := Format('Peak Wind Speed %s', [UNIT_STRINGS[0, MeasurementSettings.Wind]]);
      end;
  6:  begin
        case Ax.ReadingType of  // Temperature - db is in fahrenheit
        T_CELCIUS:    begin
                        Ax.Y_ScaleFactor.Scale    := 0.55555; // degrees c
                        Ax.Y_ScaleFactor.Subtract := 320;
                      end;
        T_FAHRENHEIT: Ax.Y_ScaleFactor.Scale      := 1.0;     // degrees F
        end;
        Ax.YTitle := Format('Air Temperature %s', [UNIT_STRINGS[1, MeasurementSettings.Temperature]]);
      end;
  7:  begin
        Ax.Y_ScaleFactor.Scale := 1; // Humidity in percent
        Ax.YTitle := 'Humidity %RH';
      end;
  8, 9, 11:  begin // Rain display as graph
        Ax.DataMultiplier := 1;
        case Ax.ReadingType of // display units
        R_MILLIMETERS:  begin
                          case Ms.Spoon of
          { 0.01" / tip}  0:  begin
                                Ax.Y_ScaleFactor.Scale := 0.254;
                              end;
          {0.2mm  / tip}  1:  begin
                                Ax.Y_ScaleFactor.Scale := 0.2;
                              end;
                          end;
                        end;
        R_INCHES:       begin
                          case Ms.Spoon of
          { 0.01" / tip}  0:  begin
                                Ax.Y_ScaleFactor.Scale := 0.01;
                              end;
          {0.2mm  / tip}  1:  begin
                                Ax.Y_ScaleFactor.Scale := 0.00787;
                              end;
                          end;
                        end;
        end;
        Ax.YTitle := Format('Preciptation %s', [UNIT_STRINGS[2, MeasurementSettings.Precipitation]]);
        Ax.DataMultiplier := 1;
      end;
 10:  begin  (* get the altitude correction value, add the calculated value, this means inverting the value *)
        Ax.Y_ScaleFactor.Subtract   := -Round(GetBPOffset(Ms.AltValue, BPCorrectionUnit(Ms.AltUnit)) * 10);
        Ax.Y_ScaleFactor.Scale := 1;

        case Ax.ReadingType of  // Barometric pressure
        P_MILLIBARS:  Ax.Y_ScaleFactor.Scale  := 1;       // mB/HPa
        P_MM_HG:      Ax.Y_ScaleFactor.Scale  := 0.750062;// mm/Hg
        P_IN_HG:      Ax.Y_ScaleFactor.Scale  := 0.02953; // in/Hg
        end;
//      scale the offset to the selected unit
        Ax.Y_ScaleFactor.Subtract := Round(Ax.Y_ScaleFactor.Subtract * Ax.Y_ScaleFactor.Scale);
        Ax.YTitle := Format('Barometric Pressure %s', [UNIT_STRINGS[3, MeasurementSettings.Pressure]]);
      end;
  12: begin
        Ax.DataMultiplier := 1;
        Ax.YTitle := Format('RSSI %s', [UNIT_STRINGS[3, MeasurementSettings.Pressure]]);
      end;
  end;
end;

(* calculate a correction figure which is added to the
 * BP READING in order to make the reading equivalent to
 * sea level.  The temperature aspect of the calculation
 * is fixed to 20 degrees C as it makes little difference
 * and may not be correct/pertinent to the BMP280 sensor.
 * @100m (328ft) 15-25 deg C only makes 0.4mB difference, more
 * higher up *)

function GetBPOffset(Alt: Integer; cu: BPCorrectionUnit): Single;
var
  Val, _Alt: Single;
const
  Temp = 20;
begin

(* Courtesy if blog.mensor.com
 * P0 = P1 (1 - (0.0065h/ (T + 0.0065h + 273.15))-5.257
 * P0 is the calculated mean sea level value in hPa,
 * P1 is the actual measured pressure (station Pressure)
 * in hectopascal (hPa), T is the temperature in degree
 ^ Celcius (°C), and h is the elevation in meters (m).
 * The result is in mB/hPa to be added to the reading, any other
 * unit will need to be converted
 * BMP280
 * Absolute accuracy +- 1.7 hPa
 *)

  _Alt := Alt;

  if cu = cuFeet then // feet to metres
    _Alt := _Alt * 0.3048;

  Result := (0.0065 * _Alt) / (20 + (0.0065 * _Alt) + 273.15);
  Result := (Power(1 - Result, -5.257) * 1000) - 1000;
 end;

// get the elevation correction value above sea level
function GetBPCorrection(Alt: Integer; cu: BPCorrectionUnit): Single;
const
  SEALEVEL_PRESSURE = 1013.2;
(* The table is for elevation in feet.  It offers a reasonable correction
 * but given all the varability in a proper calculation is more than
 * adequate.  The altitude is rounded to the nearest 50 feet. Each value
 * in the table covers 250 feet. The max altitude in feet is 7299.
 *)
  Correction: array [0..29] of Single = (
{0000-1500}      0,       1.800,    1.800,    1.800,    1.800,    1.800,    1.795,
{1750-3250}      1.792,   1.781,    1.774,    1.766,    1.760,    1.754,    1.748,
{3500-5000}      1.742,   1.736,    1.730,    1.723,    1.717,    1.711,    1.705,
{5250-6750}      1.699,   1.692,    1.686,    1.680,    1.674,    1.667,    1.662,
{7000-7250}      1.655,   1.650);

var
  Mult, Idx: Integer;
begin
    if Abs(Alt) > 7299 then
    begin
      MessageDlg('The maximum altitude values are +-7299 Feet or +-2224 Metres', mtWarning, [mbOK], 0);
      Exit(0);
    end;

    if cu = cuMetres then
      Alt := Round(Alt * 3.2808);

    Mult := (Trunc(Abs(Alt) / 50) * 50) div 50;
    Idx := ((Mult - 1) div 5) + 1;
    Result := Correction[Idx] * Mult;

// if above sealevel then reduce the pressure, if below then increase it
    if Alt >= 0 then
      Result := -Result;
end;

function ValidateFile(FileName: String): String;
var
  Sl, Info: TStringList;
  CalcTime, CurTime, Idx, Offset, MissedCount: Integer;
  Fs: TFieldSet;
  ThisError, InError: Boolean;
begin
  Result := '';

  if FileExists(FileName) then
  begin
    Info := TStringList.Create;
    Sl := TStringList.Create;
    try
      Sl.LoadFromFile(FileName);
      Offset := 1;
      MissedCount := 0;
      InError := False;

      Idx := 1;

      if Sl.Count <> 1441 then
        Info.Add(Format('The file has the wrong numer of lines (%d) should be 1441', [Sl.Count]));

      while Idx < Sl.Count - 1 do
      begin
        CalcTime := (Idx - Offset) * 60;
        CSVToText(Sl.Strings[Idx], Fs, ' ');
        CurTime := StrToInt('$' + Fs.Fields[0]);

        if (Idx = 1) and (CurTime > 86000) then
        begin
          Info.Add(Format('Incorrect first sample time %d (%s)', [CurTime, Fs.Fields[0] ]));
          Inc(Offset);
          Inc(Idx);
          continue;
        end;

        CurTime := ((StrToInt('$' + Fs.Fields[0]) mod 86400) div 60) * 60;

        if Abs(CurTime - CalcTime) > 5 then
        begin
          if not InError then
          begin
            InError := True;
            MissedCount := 0;
          end;

          Dec(Offset);

          Inc(MissedCount);
          ThisError := True;

        end else
          ThisError := False;

          if InError and not ThisError then
          begin
            Info.Add(Format('Missing sample/s (%d) after line %d', [MissedCount, Idx - 1]));
            InError := False;
          end;

        Inc(Idx);
      end;

    finally
      Result := Trim(Info.Text);
      Sl.Free;
      Info.Free;
    end;

  end else
    Info.Add(Format('The file %s does not exist!', [FileName]));
end;

procedure ClearGraph(Graph: TImage);
begin
  Graph.Canvas.Brush.Color := clBlack;
  Graph.Canvas.FillRect(Rect(0, 0, Graph.Width, Graph.Height));
  Graph.Canvas.Pen.Color  := clWhite;
  Graph.Canvas.Font.Color := clLime;
  Graph.Canvas.Font.Name := 'Tahoma';
  Graph.Canvas.Font.Size := 8;
end;

(* Generate data which indicates the number of times that the wind has
 * visited the angle.  The angle is divided by 10 to give 36 segments
 * of 10 degrees. *)
procedure Fill_PlotBufferWithRoseDATA(var PlotBuffer: array of SmallInt; var Ax: TAxes);
var
  Deg, Idx, Angle: Integer;
begin
  for Deg := 0 to PLOT_BUFFER_SIZE - 1 do
    PlotBuffer[Deg] := 0;

  Ax.Min := 0;
  Ax.Max := 0;

  for Idx := 0 to Ax.Data_Samples - 1 do
    if __QueryData[Idx] <> INVALID_DATA then
    begin
      Angle := __QueryData[Idx] div 10; // i.e. angle / 10
      Inc(PlotBuffer[Angle]);
      if Ax.Max < PlotBuffer[Angle] then
        Ax.Max := PlotBuffer[Angle];
    end;
end;

(*
 * WIND DIRECTION RESAMPLING
 * Resample data from database into the plot buffer.
 * The samples will be averaged in groups determined by the AverageCount array.
 * The result of the averaging will be aroud 720 samples in the plotbuffer
 *)
procedure Fill_PlotBufferWithWIND_DIR_DATA(var PlotBuffer: array of SmallInt; var Ax: TAxes);
const
  AverageCount: array [0..7] of word  = (2, 14, 28, 60, 180, 360, 720, 1440);
  DTOR = 1 / (360 / (2 * PI));
var
  Day, Mins, OutIdx, Idx, DayIdx, Samples, DivCount, iAvr, NorthCrossings, LastVal: Integer;
  X, Y, Avr, TotalX, TotalY: Single;
begin
  for Samples := 0 to PLOT_BUFFER_SIZE - 1 do
    PlotBuffer[Samples] := -255;

  Day       := 0;
  OutIdx    := 0;
  TotalX    := 0;
  TotalY    := 0;
  Ax.Max    := 0;
  Ax.Min    := 0;
  Ax.Avr    := 0;
  NorthCrossings := 0;
  Ax.DualLine := False;
  Ax.VectorsRotated := False;
  LastVal   := INVALID_DATA;

  while Day < Ax.Data_Days do
  begin
    DayIdx := Day * SAMPLES_PER_DAY;
    Mins := 0;

    while Mins < SAMPLES_PER_DAY do
    begin
      Samples := AverageCount[Ax.Period];
      DivCount := 0;
      X := 0;
      Y := 0;

      while Samples > 0 do
      begin
        Idx := DayIdx + Mins;

        if __QueryData[Idx] <> INVALID_DATA then
        begin
          X := X + Sin(__QueryData[Idx] * DTOR);
          Y := Y + Cos(__QueryData[Idx] * DTOR);
          TotalX := TotalX + X;
          TotalY := TotalY + Y;
          Inc(DivCount);
        end;

        Dec(Samples);
        Inc(Mins);

        if Idx >= Ax.Data_Samples then
          break;
      end;

(*    average all the rectangular samples,
 *    convert back to polar and place in plot buffer *)
      if DivCount > 0 then
      begin
        X := X / DivCount;
        Y := Y / DivCount;
        Avr := Round(ArcTan2(X, Y) / DTOR);

        if Avr < 0 then
          Avr := Avr + 360;

        iAvr := Round(Avr);

        if iAvr > Ax.Max then
          Ax.Max := iAvr;

        if iAvr < Ax.Min then
          Ax.Min := iAvr;

        PlotBuffer[OutIdx] := iAvr;

//      Detect points where north is crossed in either direction
        if LastVal <> INVALID_DATA then
        begin
          if (iAvr < 45) and (LastVal > 315)  then
            Inc(NorthCrossings)
          else if (iAvr > 315) and (LastVal < 45)  then
              Inc(NorthCrossings);

          LastVal := iAvr;
        end else
          LastVal := iAvr;

        Inc(OutIdx);
      end;
    end;
    Inc(Day);
  end;

// if north is crossed more than 10 times then rotate the vectors by 180 degrees
  if NorthCrossings > 10 then
  begin
    Idx := 0;
    Ax.VectorsRotated := True;
    while Idx < OutIdx do
    begin
      PlotBuffer[Idx] := (PlotBuffer[Idx] + 180) mod 360;
      Inc(Idx);
    end;
  end;

// average of all the samples in the plotbuffer
  X := TotalX / OutIdx;
  Y := TotalY / OutIdx;
  Avr := ArcTan2(X, Y) / DTOR;

  if Avr < 0 then
    Avr := Avr + 360;

  Ax.Avr := Round(avr);
  Ax.Data_Samples := OutIdx;
end;

function CheckForRain(Ax: TAxes): Boolean;
var
  Idx: Integer;
begin
  Result := False;
  Idx := 0;

  while Idx < Ax.Data_Samples do
  begin
    if __QueryData[Idx] > 0 then
    begin
      Result := True;
      break;
    end;
    Inc(Idx);
  end;
end;

(*
 * RAINFALL RATE ANALYSIS
 * Averaging is NOT allowed
 * The information is assembled from the data provided in Ax (TAxes), placed
 * in a stringlist and returned as a single string.
 *)

type
  TRainRateInfo = record
  RainStart: Integer;
  RainEnd: Integer;
  PeriodRain: Integer;
  PeakRate: Integer;
  end;

function Analyse_RFRateDATA(Ax: TAxes): String;
var
  Samples, Idx, LastRain, PeriodRain, PeriodPeak, TotalRain, RainPeriodCount, SubLine: Integer;
  IsRaining: Boolean;
  h, m, s: Word;
  RainData: array of TRainRateInfo;
  Msl: TStringList;

// **************************************************

  function Header(RR: array of TRainRateInfo): String;
  var
    sl: TStringList;
  begin

    sl := TStringList.Create;

    try
      sl.Add(Format('  RAINFALL RATE ANALYSIS FOR %s', [DateToStr(Ax.StartDate + AT_DATE_OFFSET)]));
      sl.Add('');
      sl.Add('  SUMMARY');
      sl.Add('');
      sl.Add(Format('  Total Daily Rainfall %.1f %s  Rainfall Periods %d', [
                                                TotalRain * Ax.Y_ScaleFactor.Scale,
                                                Suffix[Ax.ReadingType],
                                                RainPeriodCount
                                                ]));
      sl.Add('');
      Idx := 0;

      while Idx < Length(RainData) do
      begin
        sl.Add(Format('  Rain Period %2d Time: %s Period Rain: %4.1f %s Duration: %2d minutes', [
                                                Idx + 1,
                                                TimeToStr((RainData[Idx].RainStart * 60) * TIME_MULT),
                                                RainData[Idx].PeriodRain * Ax.Y_ScaleFactor.Scale,
                                                Suffix[Ax.ReadingType],
                                                (RainData[Idx].RainEnd - RainData[Idx].RainStart) - PERIOD_WITHOUT_RAIN, '']));


        Inc(Idx);
      end;
    finally
      sl.Add('');
      sl.Add(' ************ DETAIL ************');
      Result := '  ' + Trim(sl.Text);
      sl.Free();
    end;
  end;

// **************************************************

begin

  Msl := TStringList.Create;

  try

    IsRaining := False;
    LastRain := -100;
    TotalRain := 0;
    RainPeriodCount := 0;
    Msl.BeginUpdate;

    Idx := 0;
    while Idx < Ax.Data_Samples do
    begin
      if __QueryData[Idx] > 0 then
      begin
        if not IsRaining then
        begin // rain has started
          IsRaining := True;
          PeriodRain := __QueryData[Idx];
          PeriodPeak := __QueryData[Idx];
          Inc(RainPeriodCount);
          SetLength(RainData, RainPeriodCount);
          RainData[RainPeriodCount - 1].RainStart := Idx;
          RainData[RainPeriodCount - 1].RainEnd := Idx;
          RainData[RainPeriodCount - 1].PeriodRain := 0;
          RainData[RainPeriodCount - 1].PeakRate := 0;

//        Heading
          SubLine := Msl.Add('HEADING'); // replaced later
          Msl.Add('        Time   Rainfall/min  Tips');

        end else
        begin
          Inc(PeriodRain, __QueryData[Idx]);
          if __QueryData[Idx] > PeriodPeak then
            PeriodPeak := __QueryData[Idx];
        end;

        LastRain := Idx;
      end else
      begin
        if IsRaining then
          if Idx - LastRain > PERIOD_WITHOUT_RAIN then
          begin // rain has stopped, replace detail heading
            Msl.Strings[SubLine] := Format('  %s ---- RAIN PERIOD %2d - Total Rainfall: %.1f %s Peak Rainfall Rate: %.1f %s/min',
              [ #13#10,
                RainPeriodCount,
                PeriodRain * Ax.Y_ScaleFactor.Scale,
                Suffix[Ax.ReadingType],
                PeriodPeak * Ax.Y_ScaleFactor.Scale,
                Suffix[Ax.ReadingType]
              ]);
            IsRaining := False;
            RainData[RainPeriodCount - 1].RainEnd := Idx;
          end;
      end;

      if IsRaining then
      begin
        if __QueryData[Idx] > 0 then
        begin

          Msl.Append(Format('  %10s    %.1f %s       (%2d)', [
                              TimeToStr((Idx * 60) * TIME_MULT),
                              __QueryData[Idx] * Ax.Y_ScaleFactor.Scale,
                              Suffix[Ax.ReadingType],
                              __QueryData[Idx]
                              ]));

          Inc(RainData[RainPeriodCount - 1].PeriodRain, __QueryData[Idx]);
          if __QueryData[Idx] > RainData[RainPeriodCount - 1].PeakRate then
            RainData[RainPeriodCount - 1].PeakRate := __QueryData[Idx];

          Inc(TotalRain, __QueryData[Idx]);
        end;
      end;

      Inc(Idx);
    end;

    Msl.Insert(0, Header(RainData));
    SetLength(RainData, 0);
  finally
    Msl.EndUpdate;
    Result := Msl.Text;
    Msl.Free;
  end;

end;

(*
 * GENERAL RESAMPLING
 * Resample data from database into the plot buffer.
 * Dependant upon sample mode (Ax.SampleMode) and period (Ax.Data_Days) this
 * will entail averaging and stretching of data.
 *)
procedure Fill_PlotBufferWithDATA(var PlotBuffer: array of SmallInt; var Ax: TAxes);
const
  Average: array [0..7] of word  = (2, 14, 28, 60, 180, 360, 720, 1440);
var
  Day, DayIdx, OutIdx, Idx, Samples, Mins, Total, Last, Value, SampleCount: Integer;
  v: Byte;
begin
  for Samples := 0 to PLOT_BUFFER_SIZE - 1 do
    PlotBuffer[Samples] := -255;

  Ax.DualLine := False;
  Ax.VectorsRotated := False;

  Day     := 0;
  OutIdx  := 0;
  Last := -255;

// Attempt to patch any holes in the data
  Idx := Ax.Data_Samples - 1;
  while Idx >= 0 do
  begin
    if __QueryData[Idx] = -255 then
      if Idx < Ax.Data_Samples then
        __QueryData[Idx] := __QueryData[Idx + 1];

    Dec(Idx);
  end;

  while Day < Ax.Data_Days do
  begin
    DayIdx := Day * SAMPLES_PER_DAY;
    Mins := 0;

    while Mins < SAMPLES_PER_DAY do
    begin
//    Average
      Total := 0;
      Samples := Average[Ax.Period];
      SampleCount := 0;

      while Samples > 0 do
      begin
        Idx := DayIdx + Mins;
        Value := __QueryData[Idx];
        v := Value;

//      remove any zeros
        if ((Ax.Data_Field = 10) and (Value < MINBP)) then
          Value := Last;

//      if the sample is invalid then use a previous one
        if Value > -255 then
          Last := Value
        else
          Value := Last;

        Inc(SampleCount);
        Inc(Total, Value);
        Dec(Samples);
        Inc(Mins);
        if Idx >= Ax.Data_Samples then
          break;
      end;

(*
 *      If the last sample occurs part way through the averaging cycle then
 *      ensure that the divisor is the appropriate value
 *)
      Total := Round(Total / SampleCount);

 (*    Scale the data acsording to the selected units.  If the value was invalid (-255) then
  *    add it to the buffer and it will be ignored during plotting.
  *)
      if Total <> -255 then
        PlotBuffer[OutIdx] := Round((Total - Ax.Y_ScaleFactor.Subtract) * Ax.Y_ScaleFactor.Scale)
      else
        PlotBuffer[OutIdx] := Total;

      Inc(OutIdx);
    end;
    Inc(Day);
  end;

  Ax.Data_Samples := OutIdx;
end;

procedure Fill_PlotBufferWithPERIOD_DATA(var PlotBuffer: array of SmallInt; var Ax: TAxes);
var
  InOffset, OutOffset, BufCnt, DayIdx, Max, Idx, OutIdx, InIdx, SegLen, BufferLen: Integer;
begin

  BufferLen := Length(PlotBuffer);
  SegLen := Length(PlotBuffer) div Ax.Data_Days;

  for OutIdx := 0 to BufferLen - 1 do
    PlotBuffer[OutIdx] := 0;

  InOffset := 0;
  OutOffset := 0;
  OutIdx := 0;
  DayIdx := 0;
  BufCnt := 0;
  Ax.DataMax := 0;
  Ax.DataMin := 0;

  while BufCnt < Ax.Data_Samples do
  begin
// scan the whole day for a max
    Max := 0;
    InIdx := 0;
    while InIdx < SAMPLES_PER_DAY do
    begin
      if Max < __QueryData[InOffset + InIdx] then
        Max := __QueryData[InOffset + InIdx];

      Inc(InIdx);
      Inc(BufCnt);
    end;
    Inc(InOffset, SAMPLES_PER_DAY);

//  Stretch the max to fit into the seglen space
    Idx := 0;
    repeat
      PlotBuffer[OutIdx] := Max;
      Inc(OutIdx);
    until OutIdx mod SegLen = 0;

    Max := 0;
  end;

  Ax.DataMax := Ax.Max;
  Ax.Data_Samples := OutIdx;
end;

(*
  A very simple copy of the query data buffer __QueryData into the plot buffer
*)
procedure Fill_PlotBufferWithRAIN(var PlotBuffer: array of SmallInt; var Ax: TAxes);
var
  Idx: Integer;
begin
  Idx := 0;
  while Idx < Ax.Data_Samples do
  begin
    PlotBuffer[Idx] := __QueryData[Idx];
    Inc(Idx);
  end;
end;

(*
 * Fill the plot buffer with total rain per day samples.  This has been retained simply to
 * match the operation of other similar procedures.  All it does is to copy the __QueryData
 * buffer into the Plotbuffer.
 *)
procedure Fill_PlotBufferWithTOTALRAIN(var PlotBuffer: array of SmallInt; var Ax: TAxes; Fit: boolean = true);
var
  Day, OutIdx, BufferLen: Integer;
begin
  BufferLen := Ax.EndDate - Ax.StartDate + 1;

  for OutIdx := 0 to BufferLen - 1 do
    PlotBuffer[OutIdx] := 0;

  Day := 0;
  OutIdx := 0;
  Ax.DataMax := 0;
  Ax.DataMin := 0;

  while Day < Ax.Data_Days do
  begin
    PlotBuffer[OutIdx] := __QueryData[Day];
    if PlotBuffer[OutIdx] > Ax.DataMax then
      Ax.DataMax := PlotBuffer[OutIdx];

    Inc(OutIdx);
    Inc(Day);
  end;

  Ax.Data_Samples := OutIdx;
end;

(*
 * Fill the plot buffer with peak wind speed samples.  These are constant for each
 * 10 minute period
 *)
procedure Fill_PlotBufferWithWIND_SPD_PK(var PlotBuffer: array of SmallInt; var Ax: TAxes);
const
// only the first values are used now
  Average: array [0..7] of Byte     = (10,  2,  4, 6, 18, 36, 72, 144);
  Stretch: array [0..7] of ShortInt = ( 4, -3, -3, 0,  0,  0,  0,   0);
// no of samples in buffer            144
var
  Day, DayIdx, OutIdx, Idx, Samples, Mins, Max, StretchCount, Last, Value: Integer;
begin
  for Samples := 0 to PLOT_BUFFER_SIZE - 1 do
    PlotBuffer[Samples] := -255;

  Day     := 0;
  OutIdx  := 0;

  while Day < Ax.Data_Days do
  begin
    DayIdx := Day * SAMPLES_PER_DAY;
    Mins := 0;
    Last := 0;

    while Mins < SAMPLES_PER_DAY do
    begin
//    find peak
      Value := 0;
      Max := 0;
      Samples := Average[Ax.Period];

//    pick peak values in range
      while Samples > 0 do
      begin
        Idx := DayIdx + Mins;

        Value := __QueryData[Idx];

        if Value > -255 then
          Last := Value
        else
          Value := Last;

        if Value > Max then
          Max := Value;

        Dec(Samples);
        Inc(Mins);
      end;

//    scale to the selected units MPH, KPH, m/s
      Max   := Round((Max   - Ax.Y_ScaleFactor.Subtract) * Ax.Y_ScaleFactor.Scale);
      Value := Round((Value - Ax.Y_ScaleFactor.Subtract) * Ax.Y_ScaleFactor.Scale);

      PlotBuffer[OutIdx] := Max;

      Inc(OutIdx);

      StretchCount := Abs(Stretch[Ax.Period]);
//    Stretch
      if Stretch[Ax.Period] > 0 then
      begin
        while StretchCount > 0 do
        begin
          PlotBuffer[OutIdx] := Max;
          Inc(OutIdx);
          Dec(StretchCount);
        end;
      end else
      begin
//      2 to 3 stretch
        if OutIdx mod StretchCount = 0 then
        begin
          PlotBuffer[OutIdx] := Value;
          Inc(OutIdx);
        end;
      end;
    end;
    Inc(Day);
  end;

  FindMaxMin(Ax, PlotBuffer, PLOT_BUFFER_SIZE);
  Ax.Data_Samples := OutIdx - 0;

end;

(*
 * Fill the plot buffer with six rain samples per hour.  No other processing,
 * 144 samples in total.  Handles only 1 days worth of data
 *)
procedure Fill_PlotBufferWithWIND_SPD_PK_BAR(var PlotBuffer: array of SmallInt; var Ax: TAxes);
var
  OutIdx, InIdx, Last, Value, Max: Integer;
begin
  for OutIdx := 0 to Length(PlotBuffer) - 1 do
    PlotBuffer[OutIdx] := -255;

  InIdx   := 9;
  OutIdx  := 0;
  Max     := 0;
  Last := -255;

  while InIdx < SAMPLES_PER_DAY do
  begin
//    get 10m peak
    Value := __QueryData[InIdx];

    if Value > -255 then
      Last := Value
    else
      Value := Last;

    if Value > Max then
      Max := Value;

    PlotBuffer[OutIdx] := Value;
    Inc(InIdx, 10);
    Inc(OutIdx);
  end;

  FindMaxMin(Ax, PlotBuffer, PLOT_BUFFER_SIZE);
  Ax.Data_Samples := OutIdx;
end;

(*
 * Fill the plot buffer with one rain count per hour.  After considering its use
 * I have decided to allow this function to be used with a single day only , what
 * is the value in seeing hourly rain for more than one day.  The SQL provides
 * the last sample of each hour so a maximum of 24 samples per day. Also get
 * min and max values.
 *)
procedure Fill_PlotBufferWithHOURLYRAIN(var PlotBuffer: array of SmallInt; var Ax: TAxes);
var
  Hour: Integer;
begin
  for Hour := 0 to PLOT_BUFFER_SIZE - 1 do
    PlotBuffer[Hour] := 0;

  Ax.Min := 0;
  Ax.Max := 0;

  Hour := 0;
  while Hour < 24 do
  begin
    PlotBuffer[Hour] := __QueryData[Hour];
    if Ax.Max < __QueryData[Hour] then
      Ax.Max := __QueryData[Hour];

    Inc(Hour);
  end;

  Ax.Data_Samples := 24;
end;

(*
 * Find the last or nearesst to last valid
 * total rain sample
 *)
function FindRain(Index: Integer; SampleMax: Integer): Integer;
var
  Idx: Integer;
begin
  Idx := SampleMax - 1;

  Result := -255;

  if Length(__QueryData) > 0 then
    while Idx > 0 do
    begin
      if __QueryData[Index] > -255 then
      begin
        Result := __QueryData[Index];
        break;
      end;
      Dec(Index);
      Dec(Idx);
    end;
  Exit(Result);
end;

(*
 * Display the total rainfall as text
 * Ax.ReadingType is 0 for mm and 1 for inches
 * This sets the scaling factor for the readings
 * Readings are tips
 * readings come from the main data buffer
 *)
procedure Plot_TOTALRAINtext(Graph: TImage; Ax: TAxes; Top: Integer; Ms: TMeasurementSettings);
var
  Y, Idx, RainVal, TotalRainFall, PeriodRainFall, Day, DaysInMonth, MaxVal: Integer;
  dy, mn, yr: Word;
  DateStr, TimeStr: String;
const
  FIFTY_NINE_MINUTES = 0.040972;
const
  DayNames: array [0..6] of String = ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun');
  PeriodText: array [0..7] of String = ('Hour', 'Day', 'Day', 'Day', 'Week', 'Week', 'Month', 'Month');
  YSPACING: Integer = 16;
  XLEFT: Integer = 225;
begin
  Graph.Canvas.Font.Size := 10;
  Graph.Canvas.Font.Name := 'Monospac821 BT';
  Y := Top;

  MaxVal := Ax.Data_Samples;

// clear the canvas
  Graph.Canvas.Brush.Color := clBlack;
  Graph.Canvas.FillRect(Rect(0, 0, Graph.Width, Graph.Height));
  Graph.Canvas.Pen.Color  := clWhite;

  TotalRainFall := 0;
  PeriodRainfall := 0;
  Day := 0;

  case Ax.Period of
  0:  Graph.Canvas.TextOut(XLEFT - 175, Y, 'RAINFALL PER HOUR');
  1:  Graph.Canvas.TextOut(XLEFT - 175, Y, 'DAILY RAINFALL');
  2:  Graph.Canvas.TextOut(XLEFT - 175, Y, 'DAILY RAINFALL');
  3:  Graph.Canvas.TextOut(XLEFT - 175, Y, 'DAILY RAINFALL');
  4:  Graph.Canvas.TextOut(XLEFT - 175, Y, 'WEEKLY RAINFALL');
  5:  Graph.Canvas.TextOut(XLEFT - 175, Y, 'WEEKLY RAINFALL');
  6:  Graph.Canvas.TextOut(XLEFT - 175, Y, 'MONTHLY RAINFALL');
  7:  Graph.Canvas.TextOut(XLEFT - 175, Y, 'MONTHLY RAINFALL');
  end;

  Idx := 0;

// loop thtrough the data samples
  while Idx < MaxVal do
  begin
    RainVal := __QueryData[Idx];

    Inc(TotalRainFall, RainVal);
    Inc(PeriodRainFall, RainVal);
    Dec(DaysInMonth);
    Inc(Day);

    Graph.Canvas.Font.Color := $808080;

    if PeriodRainfall > 0 then
        Graph.Canvas.Font.Color := Ms.GraphCol_Txt;

    if Ax.Period = 0 then // one day
      Graph.Canvas.TextOut(XLEFT, Y, Format('Rainfall for %s %s to %s: %4.1f %s (%3d) %4d ', [
                                                                            DateToStr(Ax.DateList[Idx] + AT_DATE_OFFSET),
                                                                            TimeToStr(Idx * (1/24)),
                                                                            TimeToStr(Idx * (1/24) + FIFTY_NINE_MINUTES),
                                                                            RainVal * Ax.Y_ScaleFactor.Scale,
                                                                            Suffix[Ax.ReadingType],
                                                                            PeriodRainfall,
                                                                            Ax.DateList[Idx]]))
    else  // all other periods
      Graph.Canvas.TextOut(XLEFT, Y, Format('Rainfall for the %s starting %s: %5.1f %s (%3d) %4d ', [
                                                                            PeriodText[Ax.Period],
                                                                            DateToStr(Ax.DateList[Idx] + AT_DATE_OFFSET),
                                                                            RainVal * Ax.Y_ScaleFactor.Scale,
                                                                            Suffix[Ax.ReadingType],
                                                                            PeriodRainfall,
                                                                            Ax.DateList[Idx]]));


    PeriodRainfall := 0;
    Day := 0;
    Inc(Y, YSPACING);
    Inc(Idx);
  end;

  Inc(Y, YSPACING);
  Graph.Canvas.Font.Color := Ms.GraphCol_Txt;
  Graph.Canvas.TextOut(XLEFT, Y, Format('Total Rainfall for the period: %5.2f %s (%d)',
                                        [TotalRainFall * Ax.Y_ScaleFactor.Scale,
                                         Suffix[Ax.ReadingType],
                                         TotalRainFall]));

end;


(*
 * Display the hourly rainfall as text
 * Ax.ReadingType is 0 for mm and 1 for inches,
 * this set the scaling factor for the reading
 * Readings are tips * 10
 *)
procedure Plot_HOURLYRAINtext(Graph: TImage; Ax: TAxes; Top: Integer; Ms: TMeasurementSettings);
var
  Y, Idx, Cnt, RainVal, DayTotal: Integer;
const
  DayNames: array [0..6] of String = ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun');
  sub: array [0..1] of String = ('mm', 'inches');
  YSPACING: Integer = 16;
  XLEFT: Integer = 225;
begin
  Graph.Canvas.Font.Size := 10;
  Graph.Canvas.Font.Color := $80FFFF;
  Graph.Canvas.Font.Name := 'Monospac821 BT';

  Graph.Canvas.Brush.Color := clBlack;
  Graph.Canvas.FillRect(Rect(0, 0, Graph.Width, Graph.Height));
  Graph.Canvas.Pen.Color  := clWhite;

  Y := TOP;
  Graph.Canvas.TextOut(XLEFT - 175, Y, 'HOURLY RAINFALL');

  DayTotal := 0;
  Cnt := 0;

  while Cnt < 24 do
  begin
    Idx := ((Cnt + 1) * 60) - 1;

    RainVal := FindRain(Idx, 59);
    if RainVal < 0 then
      RainVal := 0;

    if RainVal > 0 then
      Graph.Canvas.Font.Color := Ms.GraphCol_Txt
    else
      Graph.Canvas.Font.Color := $808080;

    Inc(DayTotal, RainVal);

    Graph.Canvas.TextOut(XLEFT, Y, Format('Hourly Rainfall for %s %02.2d:%02.2d %4.1f %s/h (%d)', [
                                            DateToStr(Ax.StartDate + AT_DATE_OFFSET),
                                            Cnt,
                                            59,
                                            RainVal * Ax.Y_ScaleFactor.Scale,
                                            sub[Ax.ReadingType],
                                            RainVal]));
    Inc(Cnt);
    Inc(Y, YSPACING);
  end;

  Inc(Y, YSPACING);
  Graph.Canvas.Font.Color := Ms.GraphCol_Txt;
  Graph.Canvas.TextOut(XLEFT, Y, Format('Total Rainfall for the day: %4.1f %s (%d)',
                                          [DayTotal * Ax.Y_ScaleFactor.Scale,
                                           sub[Ax.ReadingType],
                                           DayTotal]));
end;

// creates and end date
function MakeEndDate(var Ax: TAxes): String;

  function DaysInPeriod(SDate: TDate; nDays: Integer): Integer;
  var
    ADate: TDate;
    Days, TotalDays: Integer;
  begin
    ADate := Ax.StartDate + AT_DATE_OFFSET;
    TotalDays := 0;
    while nDays > 0 do
    begin
      Days := System.DateUtils.DaysInMonth(ADate);
      Inc(TotalDays, Days);
      ADate := ADate + Days;
      Dec(nDays);
    end;
    Exit(TotalDays);
  end;
var
  Days: Word;
begin
  case Ax.Period of
  0:  Days := 1;  // 1 day
  1:  Days := 7;  // 1 week
  2:  Days := 14; // 2 weeks
  3:  Days := DaysInPeriod(Ax.StartDate, 1);
  4:  Days := DaysInPeriod(Ax.StartDate, 3);
  5:  Days := DaysInPeriod(Ax.StartDate, 6);
  6:  Days := DaysInPeriod(Ax.StartDate, 12);
  7:  Days := DaysInPeriod(Ax.StartDate, 24);
  end;

  Ax.EndDate    := Ax.StartDate + Days - 1;
  Ax.Data_Days  := Ax.EndDate - Ax.StartDate + 1;

  Result := DateToStr(Ax.EndDate + AT_DATE_OFFSET);
end;

procedure FindMaxMin(var Ax: TAxes; Buffer: array of SmallInt; BufferSize: Integer);
var
  Idx: Integer;
begin
  Ax.Max        := -32767;
  Ax.Min        :=  32767;

  for Idx := 0 to BufferSize - 1 do
    if Buffer[Idx] > -255 then
    begin
      if Buffer[Idx] > Ax.Max then // find max
        Ax.Max := Buffer[Idx];

      if Buffer[Idx] < Ax.Min then  // find min
        Ax.Min := Buffer[Idx];
    end;

    // check to see if there was any data
  if ((Ax.Min = 32767) or (Ax.Max = -32767)) then
  begin
    Ax.Min := 0;
    Ax.Max := 10;
  end;

// same min and max will cause divide errors
  if Ax.Max = Ax.Min then
  begin
    Inc(ax.Max);
    Dec(Ax.Min);
  end;

  Ax.DataMin := Ax.Min;
  Ax.DataMax := Ax.Max;
end;


function ATDateTimeToStr(Dt: Integer; Tm: Integer): String;
var
  d, t: String;
begin
  d := DateToStr(Dt + AT_DATE_OFFSET);
  t := TimeToStr(Tm / 86400);
  Result := d + ' ' + t;
end;

function ATTimeToStr(Tm: Integer): String;
var
  t: String;
begin
  t := TimeToStr(Tm / 86400);
  Result := t;
end;

(*
 * Plot data as bar graph.  The bar limit is around 190 samples.
 * The data is plotted unprocessed; for rain it is plotted as tips
 * and the scale is fitted to the top tip value along with its unit
 * correction (mm / inches/ spoon size)
 *)
procedure Plot_Bar(Ax: TAxes; Img: TImage; Settings: TMeasurementSettings; D: array of SmallInt);
var
  YTicks, X, Y, Idx, DateIdx: Integer;
  i, w, XTicks, XPixInterval, FontSize, BarStep, BarPadding, BarsPerTick: Integer;
  XPixSize, XX, YY, ScaleValue, BarInterval, YPixStep, DataPixStep: Single;
  Scale: TScale;
  Txt, FormatStr: String;
  day, month, year: Word;
  ShowDate: Boolean;
const
// 8 is a special case for 24 hour rain   1D   1W  2W  1M  3M  6M 12M 24M
  BAR_PADDING:  array [0..7] of Word = (   4,   4,  2,  2,  2,  1,  1,  1);
begin

  __DebugBuffer.Clear;

  BarPadding := BAR_PADDING[Ax.Period];

  InitGraph(1);

// clear graph
  Img.Canvas.Brush.Color := Settings.GraphCol_BG;
  Img.Canvas.FillRect(Rect(0, 0, Img.Width, Img.Height));
  Img.Canvas.Pen.Color  := Settings.GraphCol_GRAT;

// calculate Y parameters
  Scale.Max         := Round(Ax.DataMax * Ax.Y_ScaleFactor.Scale);  // corrected to units in use
  Scale.ScaleFactor := Ax.Y_ScaleFactor.Scale;

(* if the number of tips is not exactly divisible by 10
 * then round up, this value is used to determine the top
 * of the plot and ticks. *)
  case Ax.DataMax of
  1..5: begin
          Ax.DataMax := 5;
          Scale.Ticks := 5;
        end
  else
    begin
      if Ax.DataMax mod 10 <> 0 then
        Ax.DataMax := ((Ax.DataMax div 10) + 1) * 10;

      Scale.Ticks := 10;
    end;
  end;

//  scale settings
  Scale.Max         := Ax.DataMax * Ax.Y_ScaleFactor.Scale; // calculate the scale top corrected to unit in use
  Scale.ScaleStep   := Scale.Max / Scale.Ticks;             // tick value increment ( 5 or 10)
  Scale.PixStep     := (YBOT - YTOP) / Scale.Ticks;         // pixels between each tick

  Ax.Min            := 0;                                   // bar origin - always zero
  YTICKS            := Scale.Ticks;                         // number of Y ticks
  YPixStep          := (YBOT - YTOP) / Ax.DataMax;          // Y tick increment

  Img.Canvas.Font.Color := clWhite;

// draw X & Y axis lines
  Img.Canvas.MoveTo(XLEFT,  YBOT);
  Img.Canvas.LineTo(XRIGHT, YBOT);
  Img.Canvas.MoveTo(XLEFT,  YBOT);
  Img.Canvas.LineTo(XLEFT,  YTOP);

// Y title
  Img.Canvas.Font.Color := Settings.GraphCol_TEXT;
  FontSize := Img.Canvas.Font.Size;
  Img.Canvas.Font.Size := 14;
  Img.Canvas.Font.Orientation := 900;
  Img.Canvas.TextOut(MARGIN_LEFT - 67,
                    (Img.Height div 2) + (Img.Canvas.TextWidth(Ax.YTitle) div 2),
                     Ax.YTitle);
  Img.Canvas.Font.Size := FontSize;
  Img.Canvas.Font.Orientation := 0;

  X := XLEFT;

// precission for y tick text
  if Scale.ScaleStep <= 100 then
    FormatStr := '%.2f'
  else
    FormatStr := '%.0f';

// draw y ticks and text
  YY := YBOT;
  ScaleValue := Ax.Min;
  for i := 0 to YTICKS do
  begin
    Y := Round(YY);
//  draw tick
    Img.Canvas.MoveTo(X, Y);
    Img.Canvas.LineTo(X - 7, Y);

//  draw vertical graticule line
    if (i > 0) then
    begin
      Img.Canvas.Pen.Style := psDot;
      Img.Canvas.MoveTo(X, Y);
      Img.Canvas.LineTo(XRIGHT, Y);
      Img.Canvas.Pen.Style := psSolid;
    end;
// draw Y scale text
    Img.Canvas.TextOut(X - 30, Y - 6, Format(FormatStr, [ScaleValue / (Ax.DataMultiplier)]));
    YY := YY - Scale.PixStep;
    ScaleValue := ScaleValue + Scale.ScaleStep;
  end;

(* calculate of X ticks - Values chosen to give a suitable number of bars per tick *)
  case Ax.Data_Samples of
  12, 24: XTICKS  := 12; // one day, 12 & 24 months
  7:  XTICKS      :=  7; // one week
  14: XTICKS      := 14; // two weeks
  28..31: XTICKS  := 15; // one month
  13, 26: XTICKS  := 13; // 3 & 6 months
  end;

  XPixSize      := (XRIGHT - XLEFT) / PLOT_BUFFER_SIZE;               // pix per buffer cell
  XPixInterval  := Round(((XRIGHT - XLEFT) div XTICKS) * XPixSize);   // pixels between ticks
  BarStep       := Round(((XRIGHT - XLEFT) div Ax.Data_Samples) * XPixSize); // pixels per bar
  BarsPerTick   := Round(Ax.Data_Samples / XTICKS);                   // bars per ticks
  BarInterval   := XPixInterval / BarsPerTick;                        // pix between bara

// draw x ticks and text

// plot title
  FontSize := Img.Canvas.Font.Size;
  Img.Canvas.Font.Size := 14;
  Img.Canvas.TextOut(((Img.Width) div 2) - (Img.Canvas.TextWidth(Ax.XTitle) div 2),
                       YBOT + 45,
                       Ax.XTitle);
  Img.Canvas.Font.Size := FontSize;

// draw the x scale, text and vertical lines
  Y  := YBOT;
  XX  := XLEFT;
  DateIdx := 0;

  for i := 0 to XTICKS do
  begin
    X := Round(XX);

//  draw x tick marks
    Img.Canvas.MoveTo(X, Y);
    Img.Canvas.LineTo(X, Y + 7);

//  draw scale value
    case Ax.Period of
    0:  Txt := Format('%2.2d:%2.2d', [i * 2, 0]);              // time text
    else
      begin
        System.SysUtils.DecodeDate(Ax.DateList[DateIdx] + AT_DATE_OFFSET, year, month, day);
        Txt := Format('%2.2d/%2.2d', [day,month]);              // date text
//      ensure that the displayed dates are correct
        if XTICKS < Ax.Data_Samples then
          Inc(DateIdx, 2)
        else
          Inc(DateIdx, 1)
      end;
    end;

    w   := Img.Canvas.TextWidth(Txt);

//  draw the tick date, only one per tick
    if i < XTICKS then
    begin
      if Ax.Data_Samples = XTICKS then
        Img.Canvas.TextOut(X + ((XPixInterval - w) div 2), Y + 12, Txt)
      else
          Img.Canvas.TextOut(X, Y + 12, Txt)
//      else
    end;

//  draw full height vertical scale line
    Img.Canvas.Pen.Style := psDot;
    Img.Canvas.MoveTo(X, YBOT);
    Img.Canvas.LineTo(X, YTOP);
    Img.Canvas.Pen.Style := psSolid;

    XX := XX + XPixInterval;
  end;

// ************ PLOT THE GRAPH **************

//  bar colour and style
  Img.Canvas.Brush.Style := bsSolid;
  Img.Canvas.Brush.Color := Settings.GraphCol_BAR;

  Idx := 0;
  XX := XLEFT;
  while Idx < Ax.Data_Samples do // loop until the end of the samples
  begin
    X := Round(XX);
    __DebugBuffer.Add(D[Idx].ToString());

(*  Plots unprocessed data, for rainfall it is in tips.
 *  Only plot values > 0 *)
    if D[Idx] > 0 then
    begin
      Y := Round(((D[Idx] / Ax.DataMultiplier) * YPixStep));
      Img.Canvas.FillRect( Rect(X + BarPadding, YBOT, X + BarStep - BarPadding, YBOT - Y) );
    end;

    XX := XX + BarInterval;
    Inc(Idx);
  end;

  __DebugBuffer.Add(Format('StartDate: %s (%d) EndDate: %s Samples: %d Period: %d Day/s', [
                                                          DateToStr(Ax.StartDate + AT_DATE_OFFSET),
                                                          Ax.StartDate,
                                                          DateToStr(Ax.EndDate + AT_DATE_OFFSET),
                                                          Ax.Data_Samples,
                                                          Ax.Data_Days
                                                          ]));

  __DebugBuffer.Add(Format('Maximum: %d  Data Multiplier: %f Scale Factor: %f', [
                                                          Ax.Max,
                                                          Ax.DataMultiplier,
                                                          Ax.Y_ScaleFactor.Scale
                                                          ]));

end;


function Get_File(Client: TidHTTP; URL, FileName: String; var FileText: String; Log: String): Integer;
var
  Text: String;
  Retry: Integer;
begin
    Text := Format('%s/2?fn=%s', [URL, '/Data/' + FileName]);
    Client.Request.ContentType := 'text/plain';

    Retry := 1;

    repeat
      try
        Client.BeginWork(wmRead);
        FileText := Client.Get(Text); // request file
        Log := FileText;
      except
        on e:exception do
        begin
          Log := Format('-> Server did not respond correctly! %s Retry %d', [e.Message, Retry]);
          Dec(Retry);
        end;
      end;
    until ((Retry = 0) or (FileText.Length > 0));

       if (Client.ResponseCode = 200) and (FileText.Length > 0) then
    begin
      FileText := '';
      if (FileText.Length > 0) then
      begin
        FileText := Trim(FileText);
        Exit(FileText.Length);
      end;
    end;
  Exit(-1);
end;

function IntToTimeStr(Value: Integer): String;
begin
  Result := TimeToStr(Value / 86400);
end;

function IsDigit(c: Char): Boolean;
begin
  IsDigit := (c in ['0'..'9']);
end;

// reorder the directory by year, month and day
procedure SortByYMD(Dir: TStringList);
var
  Line: Integer;
  Fs: TFieldSet;
  List: TStringList;
begin
  if Length(Dir.Text) > 0 then
  begin
    List := TStringList.Create;
    try
      Line := 0;
      while Line < Dir.Count do
      begin
        if Pos(__Config.TableName, Dir.Strings[Line]) > 0 then
        begin
          CSVToText(Dir.Strings[Line], Fs, ' ');

          List.Add(Format('WsData%2s%2s%2s.dat %s',
                                              [Copy(Fs.Fields[0], 11, 2),
                                               Copy(Fs.Fields[0],  9, 2),
                                               Copy(Fs.Fields[0],  7, 2),
                                               Fs.Fields[1]
                                              ]));
        end;
        Inc(Line);
      end;
    finally
        List.Sort;
        Dir.Text := List.Text;
      List.Free;
    end;
  end;

end;


procedure DrawCircle(c: TCanvas;  Origin: TPoint; Rad: Word);
begin
  c.Ellipse(Origin.X - Rad, Origin.Y - Rad, Origin.X + Rad, Origin.Y + Rad);
end;

// generate an average based on the number of times the angle was visited
function AverageAllAngles(Vectors: array of TVectors): Integer;
var
  i, MaxVisit, angleSum, angleDiv: Integer;
begin
    MaxVisit := 0;

    for i := 0 to 359 do
      if (MaxVisit < Vectors[i].Visits) then
        MaxVisit := Vectors[i].Visits;

// limit the visits to the top 50%
    MaxVisit := MaxVisit div 2;

    angleSum := 0;
    angleDiv := 0;

    for i := 0 to 359 do
      if (Vectors[i].Visits >= MaxVisit) then
      begin
        Inc(angleSum, i);
        Inc(angleDiv);
    end;

    Result := trunc(angleSum div angleDiv);
end;

procedure DrawArrow(Canvas: TCanvas; Origin: TPoint; Angle, RadiusIn, RadiusOut: Integer);
var
  W, Xout, Xin, Yout, Yin, ArrowDepth: Integer;
begin
    W := Canvas.Pen.Width;
    Canvas.Font.Color := clLime;
    Canvas.Pen.Color := clLime;
    Canvas.Pen.Width := 5;
    ArrowDepth := (RadiusOut - RadiusIn) div 3;

//  centre line
    Xout := Trunc(Cos((Angle - 90) * RAD) * RadiusOut);
    Yout := Trunc(Sin((angle - 90) * RAD) * RadiusOut);

    case Angle of
    0:        Canvas.TextOut(ORIGIN.X + Xout - 2,   ORIGIN.Y + Yout - 25, Angle.ToString());
    1..179:   Canvas.TextOut(ORIGIN.X + Xout + 10,  ORIGIN.Y + Yout - 5, Angle.ToString());
    180:      Canvas.TextOut(ORIGIN.X + Xout - 8,   ORIGIN.Y + Yout + 5, Angle.ToString());
    181..359: Canvas.TextOut(ORIGIN.X + Xout - 30,  ORIGIN.Y + Yout - 5, Angle.ToString());
    end;

    Xin := Trunc(Cos((Angle - 90) * RAD) * RadiusIn);
    Yin := Trunc(Sin((Angle - 90) * RAD) * RadiusIn);

    Canvas.MoveTo(ORIGIN.X + Xout,  ORIGIN.Y + Yout);
    Canvas.LineTo(ORIGIN.X + Xin,   ORIGIN.Y + Yin);

//  top line
    Xout := Trunc(Cos((Angle - 90 - 2) * RAD) * (RadiusIn + ArrowDepth));
    Yout := Trunc(Sin((Angle - 90 - 2) * RAD) * (RadiusIn + ArrowDepth));
    Canvas.MoveTo(ORIGIN.X + Xout,  ORIGIN.Y + Yout);
    Canvas.LineTo(ORIGIN.X + Xin,   ORIGIN.Y + Yin);

//  bottom line
    Xout := Trunc(Cos((Angle - 90 + 2) * RAD) * (RadiusIn + ArrowDepth));
    Yout := Trunc(Sin((Angle - 90 + 2) * RAD) * (RadiusIn + ArrowDepth));
    Canvas.MoveTo(ORIGIN.X + Xout,  ORIGIN.Y + Yout);
    Canvas.LineTo(ORIGIN.X + Xin,   ORIGIN.Y + Yin);

    Canvas.Pen.Width := W;
    Canvas.Font.Color := clWhite;
    Canvas.Pen.Color := clWhite;
end;

// go back to the first monday BackMonths from SelDate
function GoBackMonths(SelDate: TDate; BackMonths: Byte): TDate;
var
  dt: TDate;
  y, m, d: Word;
begin
  System.SysUtils.DecodeDate(SelDate, y, m, d);
  if (m <= BackMonths) then
  begin
    m := 11 + m;
    Dec(y);
  end else
    Dec(m, BackMonths + 1);

    dt := System.SysUtils.EncodeDate(y, m, 1);
    dt := dt - DayOfTheWeek(dt) + 1;
    exit(dt)
end;

function MakeYTitle(Measurement: Integer; Settings: TMeasurementSettings): String;
const
 YTITLES: array [1..10, 0..3] of String = {1}  (('Wind Direction1',           'degrees',          '',                   ''),
                                                ('Wind Direction2',           'degrees',          '',                   ''),
                                                ('Wind Direction3',           'degrees',          '',                   ''),
                                          {4}   ('Average Wind Speed',       'm/S',              'Kph',                'Mph'),
                                          {5}   ('Peak Wind Speed',          'm/S',              'Kph',                'Mph'),

                                          {6}   ('Temperature',              'Degrees Celcius',  'Degrees Fahrenheit', ''),
                                          {7}   ('Humidity',                 '%RH',              '',                   ''),

                                          {8}   ('Rainfall per day',         'Millimeters',      'Inches',             ''),
                                          {9}   ('Rainfall per hour',        'Millimeters',      'Inches',             ''),
                                         {10}   ('Barometric Pressure',      'mB (hPa)',          'mmHg',               'inHg'));
begin
  case Measurement of
  1:  Result  := Format('%s %s', [YTITLES[Measurement, 0], YTITLES[Measurement, Settings.Wind + 1]]);
  2:  Result  := Format('%s %s', [YTITLES[Measurement, 0], YTITLES[Measurement, Settings.Wind + 1]]);

  3:  Result  := Format('%s %s', [YTITLES[Measurement, 0], YTITLES[Measurement, Settings.Wind + 1]]);
  4:  Result  := Format('%s %s', [YTITLES[Measurement, 0], YTITLES[Measurement, Settings.Wind + 1]]);

  6:  Result  := Format('%s %s', [YTITLES[Measurement, 0], YTITLES[Measurement, Settings.Temperature + 1]]);
  7:  Result  := Format('%s %s', [YTITLES[Measurement, 0], YTITLES[Measurement, 1]]);

  8:  Result  := Format('%s %s', [YTITLES[Measurement, 0], YTITLES[Measurement, Settings.Precipitation + 1]]);
  9:  Result  := Format('%s %s', [YTITLES[Measurement, 0], YTITLES[Measurement, Settings.Precipitation + 1]]);
 10:  Result  := Format('%s %s', [YTITLES[Measurement, 0], YTITLES[Measurement, Settings.Pressure + 1]]);
  end;
end;

function MakeXTitle(Ax: TAxes): String;
const
  XTITLES: array [0..8] of String = ( 'One Day @ 1 Hour Intervals',
                                      'Seven Days @ 12 Hour Intervals',
                                      'Fourteen Days @ 1 Day Intervals',
                                      'One Month',
                                      'Three Months',
                                      'Six Months',
                                      'One Year',
                                      'Two Years',
                                      'One Day @ 1 Hour Intervals' );

begin
  if (Ax.Data_Days = 1) then
    Result := Format('%s - %s', [DateToStr(Ax.StartDate + AT_DATE_OFFSET), XTITLES[Ax.Period]])
  else
    Result := Format('%s to %s - %s', [ DateToStr(Ax.StartDate + AT_DATE_OFFSET),
                                        DateToStr(Ax.EndDate + AT_DATE_OFFSET),
                                        XTITLES[Ax.Period]])
end;

(*
 * This is intended to detect single key presses of
 * shift, contol and alt. R Alt also produces control
 * Returns 1 for shift, 2 for conrol and 4 for alt
 *)
function GetKBState: Byte;
var
  RAlt: Byte;
begin

  Result :=           GetKeyState(VK_LSHIFT)    and $80 shr 7;
  Result := Result or GetKeyState(VK_LMENU)     and $80 shr 5;

  Result := Result or GetKeyState(VK_RSHIFT)    and $80 shr 7;

  RAlt := GetKeyState(VK_RMENU) and $80;
  if RAlt = 0 then
  begin
    Result := Result or GetKeyState(VK_RCONTROL)  and $80 shr 6;
    Result := Result or GetKeyState(VK_LCONTROL)  and $80 shr 6;
  end;

  Result := Result or RAlt shr 5;
end;

(* Build a data list ready for the import function *)
procedure BuildDataList(Src: TStringList; var DataList: TWsDataList);
var
  RowNo, FileDate, CurTime, LastTime, ListIdx, WindDir: Integer;
  Fs: TFieldSet;
begin
  RowNo := 0;
  ListIdx := 0;
  SetLength(DataList, Src.Count - 1);
  LastTime := -1;

  while (RowNo < Src.Count) do
  begin

//  get the date of the file data (1st line #date)
    if RowNo = 0 then
    begin
      if Src.Strings[RowNo][1] = '#' then
      begin
        FileDate := StrToInt(Copy(Src.Strings[RowNo], 2, 99));
        Inc(RowNo);
        Continue;
      end;
    end;

//  Detect any lines from the previous day.  Detect current and
//  next times

//  unpack the data into the structure. Makes sure there are fields
//  to extract.
    CSVToText(Src.Strings[RowNo], Fs, ' ');
    if Fs.Count = 0 then
    begin
      Inc(RowNo);
      Continue;
    end;

    CurTime := StrToInt('$' + Fs.Fields[0]);

//  if the data is from the prevous day skip it
    if(LastTime > CurTime) then
    begin
      Inc(RowNo);
      Continue;
    end;

    if Fs.Count < 11 then
    begin
      ShowMessage('Not enough fields in the logger data!');
      Exit;
    end;

//  subtract 5s from time to ensure round down
    CurTime := StrToInt('$' + Fs.Fields[0]);
    CurTime := (((CurTime - 5) div 60) * 60) mod 86400;

//  ensure that direction is 0 - 360 degrees
    WindDir := StrToInt('$' + Fs.Fields[1]);
    if WindDir < 0 then
      WindDir := WindDir + 360;

    DataList[ListIdx].Date    := FileDate;
    DataList[ListIdx].Time    := CurTime;
    DataList[ListIdx].Dir     := WindDir;

    DataList[ListIdx].AvrSpd  := StrToInt('$' + Fs.Fields[2]);
    DataList[ListIdx].PkSpd   := StrToInt('$' + Fs.Fields[3]);
    DataList[ListIdx].Temp    := StrToInt('$' + Fs.Fields[4]);
    DataList[ListIdx].Humid   := StrToInt('$' + Fs.Fields[5]);
    DataList[ListIdx].Day     := StrToInt('$' + Fs.Fields[6]);
    DataList[ListIdx].Hour    := StrToInt('$' + Fs.Fields[7]);
    DataList[ListIdx].Min     := StrToInt('$' + Fs.Fields[8]);
    DataList[ListIdx].Pres    := StrToInt('$' + Fs.Fields[9]);
    DataList[ListIdx].Rssi    := StrToInt('$' + Fs.Fields[10]);

    Inc(ListIdx);
    Inc(RowNo);
    LastTime := CurTime;
end;

end;

procedure ProcessFile(var Info: String; FileName, DBName, TableName: String; var DataList: TWsDataList); overload;
var
  Fs: TFieldSet;
  Line, RowNo, FileCount, CurTime, NextTime, FileDate, Idx, WindDir: Integer;
  Sl: TStringList;
  esl: TStringList;
  LastData: TWsRecord;
begin

    if (FileExists(FileName)) then
    begin
      Sl := TStringList.Create;
      esl := TStringList.Create;

      try
//      get the file
        Sl.LoadFromFile(FileName);

        SetLength(DataList, Sl.Count);
        RowNo := 0;
        Idx := 0;

        try
//        Loop through all the rows of data
          while  (RowNo < Sl.Count) do
          begin

//          get the date of the file data (1st line #date)
            if RowNo = 0 then
            begin
              if Sl.Strings[RowNo][1] = '#' then
              begin
                FileDate := StrToInt(Copy(Sl.Strings[RowNo], 2, 99));
                Inc(RowNo);
              end;
            end;

//          Detect any lines from the previous day.  Detect current and
//          next time

            CSVToText(Sl.Strings[RowNo], Fs, ' ');
            NextTime := StrToInt('$' + Fs.Fields[0]);

//          unpack the data into the structure
            CSVToText(Sl.Strings[RowNo], Fs, ' ');
            CurTime := StrToInt('$' + Fs.Fields[0]);

//          if the data is from the prevous day amend the date
            if(NextTime < CurTime) then
              DataList[Idx].Date := FileDate - 1
            else
              DataList[Idx].Date := FileDate;

//          subtract 5s from time to ensure round down
            CurTime := StrToInt('$' + Fs.Fields[0]);
            CurTime := (((CurTime - 5) div 60) * 60) mod 86400;

//          ensure that direction is 0 - 360 degrees
            WindDir := StrToInt('$' + Fs.Fields[1]);
            if WindDir < 0 then
              WindDir := WindDir + 360;

            DataList[Idx].Time    := CurTime;
            DataList[Idx].Dir     := WindDir;

            DataList[Idx].AvrSpd  := StrToInt('$' + Fs.Fields[2]);
            DataList[Idx].PkSpd   := StrToInt('$' + Fs.Fields[3]);
            DataList[Idx].Temp    := StrToInt('$' + Fs.Fields[4]);
            DataList[Idx].Humid   := StrToInt('$' + Fs.Fields[5]);
            DataList[Idx].Day     := StrToInt('$' + Fs.Fields[6]);
            DataList[Idx].Hour    := StrToInt('$' + Fs.Fields[7]);
            DataList[Idx].Min     := StrToInt('$' + Fs.Fields[8]);
            DataList[Idx].Pres    := StrToInt('$' + Fs.Fields[9]);

            Inc(Idx);
            Inc(RowNo);
          end;
        except
          on e:exception do
          begin
            esl.Add(Format('Error %s at line %d %s', [e.Message, Idx + 1, Sl.Strings[RowNo]]));
          end;
        end;

        if Esl.Count > 0 then
          Info := Esl.Text
        else
          Info := Trim(ImportData(DBName, TableName, DataList));
      finally
        Esl.Free;
        Sl.Free;
      end;
    end;
end;

procedure ProcessFile(var Info: String; Data: TStringList; DBName, TableName: String; var DataList: TWsDataList); overload;
var
  Fs: TFieldSet;
  Line, RowNo, FileCount, CurTime, NextTime, FileDate, Idx, WindDir: Integer;
  Esl: TStringList;
  LastData: TWsRecord;
begin

    Esl := TStringList.Create;

    if Data.Count > 0 then
    begin
      try
        SetLength(DataList, Data.Count);
        RowNo := 0;
        Idx := 0;

        try
//        Loop through all the rows of data
          while  (RowNo < Data.Count) do
          begin

//          get the date of the file data (1st line #date)
            if RowNo = 0 then
            begin
              if Data.Strings[RowNo][1] = '#' then
              begin
                FileDate := StrToInt(Copy(Data.Strings[RowNo], 2, 99));
                Inc(RowNo);
              end;
            end;

//          Detect any lines from the previous day.  Detect current and
//          next time

            CSVToText(Data.Strings[RowNo], Fs, ' ');
            NextTime := StrToInt('$' + Fs.Fields[0]);

//          unpack the data into the structure
            CSVToText(Data.Strings[RowNo], Fs, ' ');
            CurTime := StrToInt('$' + Fs.Fields[0]);

//          if the data is from the prevous day amend the date
            if(NextTime < CurTime) then
              DataList[Idx].Date := FileDate - 1
            else
              DataList[Idx].Date := FileDate;

//          subtract 5s from time to ensure round down
            CurTime := StrToInt('$' + Fs.Fields[0]);
            CurTime := (((CurTime - 5) div 60) * 60) mod 86400;

//          ensure that direction is 0 - 360 degrees
            WindDir := StrToInt('$' + Fs.Fields[1]);
            if WindDir < 0 then
              WindDir := WindDir + 360;

            DataList[Idx].Time    := CurTime;
            DataList[Idx].Dir     := WindDir;

            DataList[Idx].AvrSpd  := StrToInt('$' + Fs.Fields[2]);
            DataList[Idx].PkSpd   := StrToInt('$' + Fs.Fields[3]);
            DataList[Idx].Temp    := StrToInt('$' + Fs.Fields[4]);
            DataList[Idx].Humid   := StrToInt('$' + Fs.Fields[5]);
            DataList[Idx].Day     := StrToInt('$' + Fs.Fields[6]);
            DataList[Idx].Hour    := StrToInt('$' + Fs.Fields[7]);
            DataList[Idx].Min     := StrToInt('$' + Fs.Fields[8]);
            DataList[Idx].Pres    := StrToInt('$' + Fs.Fields[9]);
            DataList[Idx].Rssi    := StrToInt('$' + Fs.Fields[10]);

            Inc(Idx);
            Inc(RowNo);
          end;
        except
          on e:exception do
          begin
            Esl.Add(Format('Error %s at line %d %s', [e.Message, Idx + 1, Data.Strings[RowNo]]));
          end;
        end;

        if Esl.Count > 0 then
          Info := Esl.Text
        else
          Info := Trim(ImportData(DBName, TableName, DataList));
      finally
        Esl.Free;
      end;
    end;
end;

(*
 * Repair a daily data list where field data is incomplete.
 * Replacement data is copied from the previous valid record.
 * Humidity and pressure CANNOT be zero under normal conditons.
 ^ Temperature, humidity and pressure are all 10 times greater
 * than their real value (i.e. a resolution of 0.1 units).
*)

function RepairData(var Data: TWsDataList): String;
var
  LastData: TWsData;
  Idx, Chk, SrcLine: Integer;
  ErrorList: TStringList;

  // copy data (except date and time) from last data to current data
  procedure CopyData(SrcData: TWsData; var DstData: TWsData);
  begin
    DstData.Dir     := SrcData.Dir;
    DstData.AvrSpd  := SrcData.AvrSpd;
    DstData.PkSpd   := SrcData.PkSpd;
    DstData.Temp    := SrcData.Temp;
    DstData.Humid   := SrcData.Humid;
    DstData.Day     := SrcData.Day;
    DstData.Hour    := SrcData.Hour;
    DstData.Min     := SrcData.Min;
    DstData.Pres    := SrcData.Pres;
  end;

  // check to see if there is a missing data error
  function IsError(DataLine: TWsData): Boolean;
  begin
    Result := (DataLine.Temp = 0) or (DataLine.Humid = 0) or (DataLine.Pres = 0);
  end;
begin
  FillChar(LastData, sizeof(TWsData), 0);

  if not IsError(Data[0]) then
    LastData := Data[0]
  else
    exit;

  SrcLIne := 0;

  try
    ErrorList := TstringList.Create;

//  Loop through all values in the list
    Idx := 1;
    while Idx < Length(Data) do
    begin
      if IsError(Data[Idx]) then
      begin // error so get last data
        CopyData(LastData, Data[Idx]);
        ErrorList.Add(Format('Error on line %4d - Data duplicated from line %4d', [Idx, SrcLine]));
      end else
      begin // ok so get new last data
        SrcLine := Idx;
        LastData := Data[Idx];
      end;

      Inc(Idx);
    end;
  finally
    Result := ErrorList.Text;
    ErrorList.Free;
  end;
end;



{$ifdef 0}
procedure ImportSelectedFiles(List: TCheckListBox; Log: TMemo; DataDir, DBName, TableName: String);
var
  Fs: TFieldSet;
  Line, FileCount: Integer;
  Filename: String;
begin

    FileCount := 0;
    for Line := 0 to List.Items.Count - 1 do
    begin
      if (List.Checked[Line]) then
        Inc(FileCount);
    end;

    if (FileCount > 0) then
    begin
      Line := 0;

      while (Line < List.Count) do
      begin
        if (List.Checked[Line]) then
        begin
          CSVToText(List.Items.Strings[Line], Fs, ' ');
          Filename :=  DataDir + '\' + Fs.Fields[0];
          try
(*
 *          Validate the file before inserting it. Failure will not
 *          stop the import process just indicating possible problems.
 *          The missing line at 183 error is normal caused by the clock
 *          time resync on the logger.
 *)
            Log.Lines.Add(Filename);
            Log.Lines.Add('------ FILE VALIDATTION ------');
            Log.Lines.Add( ValidateFile(FileName) );
            Log.Lines.Add('-------- DATA IMPORT --------');
            Log.Lines.Add('----------- DONE ------------');
            Log.Lines.Add('');

          except
            on e:exception do
              Log.Lines.Add(e.Message);
          end;

        end;
        List.Checked[Line] := False;
        Inc(Line);
        Application.ProcessMessages;
      end;
    end;
end;
{$endif}

(*
  Add 1 to data max, subtract 1 from data min
  Find the difference and round up to nearest decade
  Find the difference between the original diff and the rounded diff

  take the Mod of the original min and subtract part of the rounded diff to make a neat min value
  Add the remainder of the rounded diff to the max to give a neat max value
*)
function MakeYParameters(var Ax: TAxes): Integer;
var
  Diff1, Diff2, Diff3, Ticks, Mult, RoundAmount: Integer;
begin
(* For some measurements (wind speed and rainfall) a zero value
 * of max is valid .  This will cause divide by zero errors.
 * Therefore force max and tick values. *)

  if (Ax.Max = 0) then
  begin
    Ax.Max := 1;
    Exit(10);
  end;

// special cases
  case Ax.Data_Field of
  2:  begin   // wind direction 0..360 degrees
        Ax.Min := 0;
        Ax.Max := 360;
        Exit(18);
      end;
  3, 4: Ax.Min := 0; // min wind speed is zero
  6:  begin   // humidity 0..100%
        Ax.Min := 0;
        Ax.Max := 1000;
        Exit(10);
      end;
  end;

  Ax.Min := Ax.DataMin;
  Ax.Max := Ax.DataMax;

// get the data range (Diff1) and round up (Diff2)
  Diff1 := Ax.Max - Ax.Min;
  Mult := Trunc(Power(10, Trunc(Log10(Diff1))));

  RoundAmount := 1;
  repeat
    Diff2 := (Trunc(Diff1 / Mult) + RoundAmount) * Mult;
    Inc(RoundAmount);
  until Ax.Min + Diff2 > Ax.Max + 10;

// diff3 is the difference between rounded and unrounded data range
  Diff3 := Diff2 - Diff1;

// adjust the max and min to fit the new range
// allow for negative values
  Ticks := Abs(Ax.Min) mod 10;
  Ax.Min := Ax.DataMin - Ticks;
  Dec(Diff3, Ticks);
  Ax.Max := Ax.DataMax + Diff3;


// no more than 20 ticks allowed
  Ticks := 20;
  while Ticks > 1 do
  begin
    if Diff2 mod Ticks = 0 then
    begin
      if Ax.Data_Field = 10 then
      begin
//      ensure that bp only has values in 2, 5, 10
        if Diff2 div Ticks in [10, 100] then
          break;
      end else
        break;
    end;

    Dec(Ticks);
  end;

// ticks and Ax.Max are both wrong
  Ticks := 10;
  Exit(Ticks);

end;

function MakeShortDate(Dt: Integer): String;
var
  d, m, y: Word;
begin
  DecodeDate(d, m, y, Dt, true);
  Result := Format('%2.2d/%2.2d', [d, m]);
end;

function MakeXScaleText1(TickNo: Integer; Ax: TAxes): TScaleText;
begin
  case Ax.Period of
  0:  begin // 1 day 7
        Result.TopStr := Format('%2.2d:00', [TickNo * 2]);
        Result.BotStr := MakeShortDate(Ax.StartDate);
      end;
  1:  begin // 1 week 14
        Result.TopStr := Format('%2.2d:00', [((TickNo and 1) * 12)]);
        Result.BotStr := MakeShortDate(Ax.StartDate + (TickNo div 2));
      end;
  2:  begin // 2 weeks 14
        Result.TopStr := '00:00';
        Result.BotStr := MakeShortDate(Ax.StartDate + TickNo);
      end;
  3:  begin // 1 month 15
        Result.TopStr := MakeShortDate(Ax.StartDate + (TickNo * 2));
      end;
  4:  begin // 3 months 15
        Result.TopStr := MakeShortDate(Ax.StartDate + (TickNo * 6));
      end;
  5:  begin // 6 months 12
        Result.TopStr := MakeShortDate(Ax.StartDate + (TickNo * 15));
      end;
  6:  begin // 12 months 12
        Result.TopStr := MakeShortDate(Ax.StartDate + (TickNo * 30));
      end;
  7:  begin // 6 months 12
        Result.TopStr := MakeShortDate(Ax.StartDate + (TickNo * 60));
      end;
  end;
end;

procedure Plot_Line(Ax: TAxes; Img: TImage; Settings: TMeasurementSettings; D: array of SmallInt);
var
  YDataStep, YTicks, Y, X, YMin, YDMin, YMax, YDMax, ScaleVal, YOff: Integer;
  i, w, XTicks, FontSize, XMin, XMax, DayS, DayE, ScaleMax, TextWidth: Integer;
  ScaleValue, XPixInterval, XX, YY, YPixStep: Single;
  St: TScaleText;
  Txt: String;
  StartSet, UseDP: Boolean;
const
  TICKLEN = 7;
  SCALEFORMAT: array [False..True] of String = ('%.0f', '%.1f');
begin
// YBOT, YTOP, XLEFT and XRIGHT are initialised in InitGraph()
  InitGraph(1);

// clear graph
  Img.Canvas.Brush.Color := Settings.GraphCol_BG;
  Img.Canvas.FillRect(Rect(0, 0, Img.Width, Img.Height));
  Img.Canvas.Pen.Color  := Settings.GraphCol_GRAT;

  YTICKS := MakeYParameters(Ax);

// set daytime start and end well out of range
  DayS := 90000;
  DayE := 90000;

// points for start and end of daytime
  if Ax.Data_Days = 1 then
  begin
    DayS := Round(( Ax.DayStart                 / 86400) * Ax.Data_Samples);
    DayE := Round(((Ax.DayStart + TWELVE_HOURS) / 86400) * Ax.Data_Samples);
  end;

// calculate Y parameters
  YPixStep     := (YBOT - YTOP) / YTICKS;
  YDataStep    := (Ax.Max - Ax.Min) div YTICKS;

// calculate X parameters
  XTicks       := TICKS_IN_PERIOD[Ax.Period];
  XPixInterval := Ax.Data_Samples / (XTICKS); // pixeks per tick

// left and right values
  XLEFT := ((Img.Width - Ax.Data_Samples) div 2) + 10;
  XRIGHT := XLEFT + Round(XTICKS * XPixInterval);

// draw axes
// X
  Img.Canvas.MoveTo(XLEFT,  YBOT);
  Img.Canvas.LineTo(XRIGHT, YBOT);

// Y
  Img.Canvas.MoveTo(XLEFT,  YBOT);
  Img.Canvas.LineTo(XLEFT,  YTOP);

// draw y ticks and text
  ScaleVal := Ax.Min;

// Y main title
  Img.Canvas.Font.Color := Settings.GraphCol_TEXT;
  FontSize := Img.Canvas.Font.Size;
  Img.Canvas.Font.Size := 14;
  Img.Canvas.Font.Orientation := 900;
  Img.Canvas.TextOut(XLEFT - 67,
                    (Img.Height div 2) + (Img.Canvas.TextWidth(Ax.YTitle) div 2),
                     Ax.YTitle);
  Img.Canvas.Font.Size := FontSize;
  Img.Canvas.Font.Orientation := 0;

// are decimal points required on y axis points
  UseDP := (YDataStep < 10);

  X := XLEFT;
  YY := YBOT;

// -------------- draw y ticks and text --------------
  for i := 0 to YTICKS do
  begin
    Y := Round(YY);

    Img.Canvas.MoveTo(X, Y);
    Img.Canvas.LineTo(X - TICKLEN, Y);

//  Text for each tick

    YOff := 0;
    Txt := Format(SCALEFORMAT[UseDP], [ScaleVal / Ax.DataMultiplier]);
    TextWidth := Img.Canvas.TextWidth(Txt);
    Img.Canvas.TextOut(X - TextWidth - 10, Y - TICKLEN, Txt);

//  write or overwrite the points of the compass
    if Ax.X_Scale_Type = 0 then
    begin
      case i of
       0: Txt := '    N';
       4: begin
            Txt := 'E';
            YOff := Round(YPixStep / 2);
          end;
       9: Txt := '    S';
      13: begin
            Txt := 'W';
            YOff := Round(YPixStep / 2);
          end;
      18: Txt := '    N';
      end;

      if i in [0, 4, 9, 13, 18] then
      begin
        TextWidth := Img.Canvas.TextWidth(Txt);
        Img.Canvas.TextOut(X - TextWidth - 10, Y - TICKLEN - YOff, Txt);
      end;
    end;

//  draw horizontal graticule lines
    if (i > 0) then
    begin
      Img.Canvas.Pen.Style := psDot;
      Img.Canvas.MoveTo(X, Y);
      Img.Canvas.LineTo(XRIGHT, Y);
      Img.Canvas.Pen.Style := psSolid;
    end;
    YY := YY - YPIxStep;
    Inc(ScaleVal, YDataStep);
  end;

// -------------- draw x ticks and text --------------

  FontSize := Img.Canvas.Font.Size;
  Img.Canvas.Font.Size := 14;
  Img.Canvas.TextOut(((Img.Width) div 2) - (Img.Canvas.TextWidth(Ax.XTitle) div 2),
                       YBOT + 45,
                       Ax.XTitle);

  Img.Canvas.Font.Size := FontSize;

  XX := XLEFT; // the fp value for x
  Y  := YBOT;

  for i := 0 to XTICKS do
  begin
    X := Trunc(XX);

    Img.Canvas.MoveTo(X, Y);
    Img.Canvas.LineTo(X, Y + TICKLEN);

//  draw scale values
    St  :=  MakeXScaleText1(i, Ax);
    w   := Img.Canvas.TextWidth(St.TopStr);
    Img.Canvas.TextOut(X - (w div 2), Y + 12, St.TopStr);
    w   := Img.Canvas.TextWidth(St.BotStr);
    Img.Canvas.TextOut(X - (w div 2), Y + 25, St.BotStr);

//  draw full height vertical scale line
    Img.Canvas.Pen.Style := psDot;
    Img.Canvas.MoveTo(X, YBOT);
    Img.Canvas.LineTo(X, YTOP);

    Img.Canvas.Pen.Style := psSolid;

    XX := XX + XPixInterval; // inc the fp value
  end;

// ************ PLOT THE GRAPH **************


  StartSet := false;

  Img.Canvas.Pen.Color := Settings.GraphCol_LINE1;

  YMin :=   32768;
  YMax :=  -32768;
  YDMin :=  32768;
  YDMax := -32768;

  ScaleValue  := (YBOT - YTOP) / (Ax.Max - Ax.Min);

  i := 0;
  X := XLEFT;

  while i < Ax.Data_Samples do // loop between the left and right points of the X axis
  begin
    if (i = DayS) then
      Img.Canvas.Pen.Color := Settings.GraphCol_DAY;

    if (i = DayE) then
      Img.Canvas.Pen.Color := Settings.GraphCol_LINE1;

    Y := YBOT - Round((D[i] - Ax.Min) * ScaleValue);

    if (D[i] > -255) then // only plot point if it is valid data
    begin
      if not StartSet then
      begin
        Img.Canvas.MoveTo(X, Y);
        StartSet := True;
      end;

      Img.Canvas.LineTo(X, Y);

      if YMax < Y then
      begin
        YMax := Y;
        YDMin := D[i];
        XMax := X;
      end;

      if YMin > Y then
      begin
        YMin := Y;
        YDMax := D[i];
        XMin := X;
      end;
    end;

    Inc(X);
    Inc(i);
  end;

// ************ PLOT THE MAX/MIN LINES **************
  if (Ax.ShowMinMax) then
  begin
    Img.Canvas.Pen.Style := psDot;
    Img.Canvas.Pen.Color := Settings.GraphCol_MAX;
    Img.Canvas.Font.Color := Settings.GraphCol_MAX;

//  -------- MAX LINE --------
//  max text
    Txt := Format(' MAX %3.1f ', [YDMax / Ax.DataMultiplier]);

// max text position
    w := Img.Canvas.TextWidth(Txt);
    if ((XMin - XLEFT) > (XRIGHT - XMin)) then
      Dec(XMin, w + 10)
    else
      Inc(XMin, w + 10);

    Img.Canvas.MoveTo(XLEFT,  YMin);
    Img.Canvas.LineTo(XRIGHT, YMin);
    Img.Canvas.TextOut(XMin, YMin - (Img.Canvas.TextHeight('Z') div 2), Txt);

//  -------- MIN LINE --------
//  min text
    Txt := Format(' MIN %3.1f ', [YDMin / Ax.DataMultiplier]);

// min text position
    w := Img.Canvas.TextWidth(Txt);
    if ((XMax - XLEFT) > (XRIGHT - XMax)) then
      Dec(XMax, w + 10)
    else
      Inc(XMax, w + 10);

    Img.Canvas.MoveTo(XLEFT,  YMax);
    Img.Canvas.LineTo(XRIGHT, YMax);
    Img.Canvas.TextOut(XMax, YMax - (Img.Canvas.TextHeight('Z') div 2), Txt);

    Img.Canvas.Pen.Style := psSolid;
    Img.Canvas.Pen.Color := clBlack;
  end;
end;

procedure DrawYTicks(Img: TImage; Ax: TAxes; Ysi: TYScaleInfo);
const
  TICKLEN = 7;
  SCALEFORMAT: array [False..True] of String = ('%.0f', '%.1f');
var
  i, Y, TextWidth: Integer;
  YY: Single;
  Txt: String;
begin
  YY := Ysi.Y;

  for i := 0 to Ysi.YTicks do
  begin
    Y := Round(YY);

    Img.Canvas.MoveTo(Ysi.X, Y);
    Img.Canvas.LineTo(Ysi.X - TICKLEN, Y);

//  Text and scale line for each tick
    Txt := Format(SCALEFORMAT[Ysi.UseDP], [Ysi.ScaleValue / Ax.DataMultiplier]);
    TextWidth := Img.Canvas.TextWidth(Txt);
    Img.Canvas.TextOut(Ysi.X - TextWidth - 10, Y - TICKLEN, Txt);

    if i > 0 then
    begin
      Img.Canvas.Pen.Style := psDot;
      Img.Canvas.MoveTo(Ysi.X, Y);
      Img.Canvas.LineTo(XRIGHT, Y);
      Img.Canvas.Pen.Style := psSolid;
    end;

    YY := YY - Ysi.YPIxStep;

    Ysi.ScaleValue := Ysi.ScaleValue + Ysi.YDataStep;

    if Ysi.RVs and (Ysi.ScaleValue > 359) then
      Ysi.ScaleValue := 0;

  end;
end;

procedure DrawWindTicks(Img: TImage; Ax: TAxes; Ysi: TYScaleInfo);
const
  TICKLEN = 7;
  SCALEFORMAT: array [False..True] of String = ('%.0f', '%.1f');
var
  i, Y, YOff, TextWidth: Integer;
  YY: Single;
  Txt: String;
begin
  YY := Ysi.Y;

  for i := 0 to Ysi.YTicks do
  begin
    Y := Round(YY);

    Img.Canvas.MoveTo(Ysi.X, Y);
    Img.Canvas.LineTo(Ysi.X - TICKLEN, Y);

//  Text for each tick

    YOff := 0;
    Txt := Format(SCALEFORMAT[Ysi.UseDP], [Ysi.ScaleValue / Ax.DataMultiplier]);
    TextWidth := Img.Canvas.TextWidth(Txt);
    Img.Canvas.TextOut(Ysi.X - TextWidth - 10, Y - TICKLEN, Txt);

//  write the points of the compass
    if Ax.X_Scale_Type in [0, 1, 2] then
    begin
      case i of
       0: Txt := '    N';
       4: begin
            Txt := 'E';
            YOff := Round(Ysi.YPixStep / 2);
          end;
       9: Txt := '    S';
      13: begin
            Txt := 'W';
            YOff := Round(Ysi.YPixStep / 2);
          end;
      18: Txt := '    N';
      end;

      if i in [0, 4, 9, 13, 18] then
      begin
        TextWidth := Img.Canvas.TextWidth(Txt);
        Img.Canvas.TextOut(Ysi.X - TextWidth - 10, Y - TICKLEN - YOff, Txt);
      end;
    end;

    Img.Canvas.Pen.Style := psDot;
    Img.Canvas.MoveTo(Ysi.X, Y);
    Img.Canvas.LineTo(XRIGHT, Y);
    Img.Canvas.Pen.Style := psSolid;

    YY := YY - Ysi.YPIxStep;

    Ysi.ScaleValue := Ysi.ScaleValue + Ysi.YDataStep;

  end;
end;

(*
 * Determine the Y scale range - V2
 * Round the max and min values and choose an appropriate number of ticks.
 * Values between each tick are based on decades of 1, 2 and 5.
 *)
function MakeYParameters2(var Ax: TAxes): Integer;
var
  MinIsNeg, MaxisNeg: Boolean;
  Value, Diff, Count, Ticks, TickRange, Digits: Integer;
const
  Ranges: array [0..9] of Integer = (1, 2, 5, 10, 20, 50, 100, 200, 500, 1000);
begin
// SPECIAL CASES
  case Ax.Data_Field of
  3, 4: Ax.Min := 0;    // make wind min 0;
  6:  begin             // intentionally crude ranging for humidity
        Ax.Max := 1000;

        if Ax.Min >= 750 then Ax.Min := 750
          else if Ax.Min >= 500 then Ax.Min := 500
            else if Ax.Min >= 250 then Ax.Min := 250
              else Ax.Min := 0;
        Exit(10);
      end;
  end;

// Get max/min sign
  MinIsNeg := Ax.Min < 0;
  MaxIsNeg := Ax.Max < 0;

// remove the sign
  Ax.Min := Abs(Ax.Min);
  Ax.Max := Abs(Ax.Max);

//  ------------------------

// ROUND THE MINIMUM DOWN
// dont round min values down if the value is exact
  if Ax.Min mod 10 <> 0 then
  begin
    if MinIsNeg then
      Ax.Min := Trunc(SimpleRoundTo(Ax.Min.ToSingle + 5, 1))
    else
      Ax.Min := Trunc(SimpleRoundTo(Ax.Min.ToSingle - 5, 1));
  end;

  if MinIsNeg then // restore the sign
    Ax.Min := -Ax.Min;

//  ------------------------

// ROUND THE MAXIMUM UP
// always round max values up
  if MaxIsNeg then
    Ax.Max := Trunc(SimpleRoundTo(Ax.Max.ToSingle - 5, 1))
  else
    Ax.Max := Trunc(SimpleRoundTo(Ax.Max.ToSingle + 5, 1));

  if MaxIsNeg then  // restore the sign
    Ax.Max := -Ax.Max;

//  ------------------------

// Max/Min difference
  Diff := Ax.Max - Ax.Min;

  Ticks := 100; // uninitialised
  Count := 0;

// Loop looking for the first number of ticks less than 20
  repeat
    Value := Diff div Ranges[Count];

    if (Value < 20) and (Ticks = 100) then
    begin // found one so break out of the loop
      Ticks := Value;
      TickRange := Diff div Ticks;
      break;
    end;

    Inc(Count);
  until Count = length(Ranges);

// Round the tickrange to multiples of 1, 2 or 5
  if TickRange > 1 then
  begin
    Digits := Log10(TickRange).Exponent + 1;
    TickRange := Trunc(RoundTo(TickRange, Digits));
  end;

// If the tick range is reduced then increase the
// number of ticks to compensate
  if TickRange * Ticks < Diff then
    Inc(Ticks);

  Exit(Ticks);
end;

procedure Plot_Line2(Ax: TAxes; Img: TImage; Settings: TMeasurementSettings; D: TDualPlotBuffer);
var
  YDataStep, YTicks, Y, X, YMin, YDMin, YMax, YDMax, ScaleVal: Integer;
  i, w, XTicks, FontSize, XMin, XMax, DayS, DayE: Integer;
  {ScaleValue, }XPixInterval, XX, YY, YPixStep: Single;
  St: TScaleText;
  Txt: String;
  StartSet{, UseDP}: Boolean;
  Ysi: TYScaleInfo;
const
  TICKLEN = 7;
  SCALEFORMAT: array [False..True] of String = ('%.0f', '%.1f');

// Plot the graph line
  procedure PlotLine(Data: array of SmallInt; LineNo: Integer; LineColour: TColor);
  begin
    StartSet := false;

    Img.Canvas.Pen.Color := LineColour;

    YMin :=   32768;
    YMax :=  -32768;
    YDMin :=  32768;
    YDMax := -32768;

    Ysi.ScaleValue  := (YBOT - YTOP) / (Ax.Max - Ax.Min);


    i := 0;
    X := XLEFT;

    if Ax.VectorsRotated then
      Img.Canvas.Pen.Color := Settings.GraphCol_DAY
    else
      Img.Canvas.Pen.Color := LineColour;

    while i < Ax.Data_Samples do // loop between the left and right points of the X axis
    begin
      if (Data[i] > INVALID_DATA) then // only plot point if it is valid data
      begin
        Y := YBOT - Round((Data[i] - Ax.Min) * Ysi.ScaleValue);

        if not StartSet then
        begin
          if Ax.DualLine then
          begin
            if LineNo = 1 then
              Img.Canvas.TextOut(X + 2, Y - 17, 'Max')
            else
              Img.Canvas.TextOut(X + 2, Y + 5, 'Min');
          end;

          StartSet := True;
          Img.Canvas.MoveTo(X, Y);
        end;

        Img.Canvas.LineTo(X, Y);

        if YMax < Y then
        begin
          YMax := Y;
          YDMin := Data[i];
          XMax := X;
        end;

        if YMin > Y then
        begin
          YMin := Y;
          YDMax := Data[i];
          XMin := X;
        end;
      end;

      Inc(X);
      Inc(i);
    end;
  end;
begin
// ---------------------------------------------------------------
  InitGraph(1); // YBOT, YTOP, XLEFT and XRIGHT are initialised here

// clear graph
  Img.Canvas.Brush.Color := Settings.GraphCol_BG;
  Img.Canvas.FillRect(Rect(0, 0, Img.Width, Img.Height));
  Img.Canvas.Pen.Color  := Settings.GraphCol_GRAT;
  Img.Canvas.Pen.Width := 1;

  YTICKS := MakeYParameters2(Ax);
  Ysi.YTicks := YTICKS;

// set daytime start and end well out of range
  DayS := 90000;
  DayE := 90000;

// points for start and end of daytime
  if Ax.Data_Days = 1 then
  begin
    DayS := Round(( Ax.DayStart                 / 86400) * Ax.Data_Samples);
    DayE := Round(((Ax.DayStart + TWELVE_HOURS) / 86400) * Ax.Data_Samples);
  end;

// calculate Y parameters
  YPixStep     := (YBOT - YTOP) / YTICKS;
  YDataStep    := (Ax.Max - Ax.Min) div YTICKS;
  Ysi.YPixStep := YPixStep;
  Ysi.YDataStep := YDataStep;

// calculate X parameters
  XTicks       := TICKS_IN_PERIOD[Ax.Period];
  XPixInterval := Ax.Data_Samples / (XTICKS); // pixeks per tick

// left and right values
  XLEFT := ((Img.Width - Ax.Data_Samples) div 2) + 10;
  XRIGHT := XLEFT + Round(XTICKS * XPixInterval);

  Img.Canvas.Pen.Style := psSolid;

// draw X axis
  Img.Canvas.MoveTo(XLEFT,  YBOT);
  Img.Canvas.LineTo(XRIGHT, YBOT);

// draw Y axis
  Img.Canvas.MoveTo(XLEFT,  YBOT);
  Img.Canvas.LineTo(XLEFT,  YTOP);

// starting y scale value
  ScaleVal := Ax.Min;

// Y main title
  Img.Canvas.Font.Color := Settings.GraphCol_TEXT;
  FontSize := Img.Canvas.Font.Size;
  Img.Canvas.Font.Size := 14;
  Img.Canvas.Font.Orientation := 900;
  Img.Canvas.TextOut(XLEFT - 75,
                    (Img.Height div 2) + (Img.Canvas.TextWidth(Ax.YTitle) div 2),
                     Ax.YTitle);
  Img.Canvas.Font.Size := FontSize;
  Img.Canvas.Font.Orientation := 0;

// are decimal points required on y axis points
  Ysi.UseDP := (YDataStep < 10);

  X := XLEFT;
  YY := YBOT;

// -------------- draw y ticks and text --------------

  Ysi.X := X;
  Ysi.Y := Round(YY);
  Ysi.RVs := False;
  Ysi.ScaleValue := Ax.Min;

  if Ax.VectorsRotated then
  begin
    Ysi.ScaleValue := Ax.Min + 180;
    Ysi.RVs := True;
  end;

  DrawYTicks(Img, Ax, Ysi);

// -------------- draw x ticks and text --------------

  FontSize := Img.Canvas.Font.Size;
  Img.Canvas.Font.Size := 14;
  Img.Canvas.TextOut(((Img.Width) div 2) - (Img.Canvas.TextWidth(Ax.XTitle) div 2),
                       YBOT + 45,
                       Ax.XTitle);

  Img.Canvas.Font.Size := FontSize;

  XX := XLEFT; // the fp value for x
  Y  := YBOT;

  for i := 0 to XTICKS do
  begin
    X := Trunc(XX);

    Img.Canvas.MoveTo(X, Y);
    Img.Canvas.LineTo(X, Y + TICKLEN);

//  draw scale values
    St  :=  MakeXScaleText1(i, Ax);
    w   := Img.Canvas.TextWidth(St.TopStr);
    Img.Canvas.TextOut(X - (w div 2), Y + 12, St.TopStr);
    w   := Img.Canvas.TextWidth(St.BotStr);
    Img.Canvas.TextOut(X - (w div 2), Y + 25, St.BotStr);

//  draw full height VERTICAL scale lines
    if i > 0 then
    begin
      Img.Canvas.Pen.Style := psDot;
      Img.Canvas.MoveTo(X, YBOT);
      Img.Canvas.LineTo(X, YTOP);
      Img.Canvas.Pen.Style := psSolid;
    end;

    XX := XX + XPixInterval; // inc the fp value
  end;

// ************ PLOT THE MAX/MIN GRAPHS **************
  PlotLine(D.Max, 1, Settings.GraphCol_LINE1);

  if Ax.DualLine then
    PlotLine(D.Min, 2, Settings.GraphCol_LINE2);

// ************ PLOT THE MAX/MIN LINES **************
  if (Ax.ShowMinMax) then
  begin
    Img.Canvas.Pen.Style := psDot;
    Img.Canvas.Pen.Color := Settings.GraphCol_MAX;
    Img.Canvas.Font.Color := Settings.GraphCol_MAX;

//  -------- MAX LINE --------
//  max text
    Txt := Format(' MAX %3.1f ', [YDMax / Ax.DataMultiplier]);

// max text position
    w := Img.Canvas.TextWidth(Txt);
    if ((XMin - XLEFT) > (XRIGHT - XMin)) then
      Dec(XMin, w + 10)
    else
      Inc(XMin, w + 10);

    Img.Canvas.MoveTo(XLEFT,  YMin);
    Img.Canvas.LineTo(XRIGHT, YMin);
    Img.Canvas.TextOut(XMin, YMin - (Img.Canvas.TextHeight('Z') div 2), Txt);

//  -------- MIN LINE --------
//  min text
    Txt := Format(' MIN %3.1f ', [YDMin / Ax.DataMultiplier]);

// min text position
    w := Img.Canvas.TextWidth(Txt);
    if ((XMax - XLEFT) > (XRIGHT - XMax)) then
      Dec(XMax, w + 10)
    else
      Inc(XMax, w + 10);

    Img.Canvas.MoveTo(XLEFT,  YMax);
    Img.Canvas.LineTo(XRIGHT, YMax);
    Img.Canvas.TextOut(XMax, YMax - (Img.Canvas.TextHeight('Z') div 2), Txt);

    Img.Canvas.Pen.Style := psSolid;
    Img.Canvas.Pen.Color := clBlack;
  end;
end;

procedure InitGraph(Scale: Single);
const
  GF_HEIGHT = 570;
begin
  GRAPH_WIDTH         := Round(PLOT_BUFFER_SIZE * Scale); // pixel size of graph X axis
  GRAPH_HEIGHT        := Round(GF_HEIGHT * Scale);

  YBOT                := GRAPH_HEIGHT - Round(MARGIN_BOTTOM * Scale); // graph Y axis bottom
  YTOP                := Round(MARGIN_TOP * Scale);           // graph Y axis top
  XLEFT               := Round(MARGIN_LEFT * Scale);          // graph X axis left
  XRIGHT              := XLEFT + GRAPH_WIDTH;  // graph X axis right
end;

function GetTimeWindow(StartIndex: Byte; range: Byte):  TTimeRange;
begin

  Result.start_Time := 0;
  Result.end_Time := MAX_SECONDS;

  case range of
   0: begin
        Result.start_Time := StartIndex * 3600;
        Result.end_Time := Result.start_Time + ( 60 * 60);     // 1 Hour
      end;
   1: begin
        Result.start_Time := StartIndex * 3600 * 3;
        Result.end_Time := Result.start_time + (180 * 60);    //3 Hours
      end;
   2: begin
        Result.start_Time := StartIndex * 3600 * 6;
        Result.end_Time := Result.start_time + (360 * 60);    //6 Hours
      end;
   3: begin
        Result.start_Time := StartIndex * 3600 * 12;
        Result.end_Time := Result.start_time + (720 * 60);    //12 Hours
      end;
  end;

  Dec(Result.end_Time, 1);
end;

function GetDateWindow(TheDate: TDate; range: Word): TDateRange;
var
  base_date: DWord;
begin
  base_date := Trunc(System.SysUtils.EncodeDate(2000, 1, 1));
  result.start_date := Trunc(TheDate) - base_date;
  result.end_date := result.start_date;

  case range of
   0: result.end_date := result.start_date + 0;           //  1 Day
   1: result.end_date := result.start_date + 6;           //  1 Week
   2: result.end_date := result.start_date + 13;          //  2 weeks
   3: result.end_date := Trunc(IncMonth(TheDate, 1))  - base_date;  //  1 Month
   4: result.end_date := Trunc(IncMonth(TheDate, 2))  - base_date;  //  3 Months
   5: result.end_date := Trunc(IncMonth(TheDate, 6))  - base_date;  //  6 Monhs
   6: result.end_date := Trunc(IncMonth(TheDate, 12)) - base_date; //  12 Months
   7: result.end_date := Trunc(IncMonth(TheDate, 24)) - base_date; //  24 Months
  end;
end;

procedure RestartLogger(Client: TIdHTTP; URL: String);
var
  Reply, Msg: String;
begin
    Msg := Format('%s/6', [URL]);
    Client.Request.ContentType := 'text/plain';
    Reply := Client.Get(Msg);
    MessageDlg('The logger will take up to 60s to become available', mtInformation, [mbOK], 0);
end;


function DiskSizeToString(Value: Int64): String;
var
  i: Integer;
  Scale: DWord;
const
  range: array [0..4] of Int64 = (1, 1024, 1048576, 1073741824, 4294967296);
  post:  array [0..4] of String = ('B', 'KB', 'MB', 'GB', 'TB');
begin

  Scale := 1;

  if (Value > range[4]) then
    Exit(Format('%6.1f%s', [Value / range[3], post[3]]));

  for i := 0 to Length(range) - 2 do
  begin
    if ((Value < range[i + 1]) and (Value >= range[i])) then
    begin
      Exit(Format('%6.1f %s', [Value / Scale, post[i]]));
      break;
    end;

    Scale := Scale * 1024;
  end;
end;

procedure SetIniDefaults(var Ps:  TConfig; var Ms: TMeasurementSettings; IPList: TComboBox);
var
  HIP, LIP, TTl, Prompt, Add, AddVal: String;
  OK: Boolean;
  Tries: Integer;
begin
  HIP := GetCurrentlyActiveIPAddress;

  Ps.RootPath := ExtractFilePath(Application.ExeName);

  ShowMessage('--> ' + Application.ExeName);

  if Ps.RootPath[Length(Ps.RootPath)] = '\' then
    Ps.RootPath := Copy(Ps.RootPath, 1, Length(Ps.RootPath) - 1);

  Ps.DBPath         := '\DB';
  Ps.TableName      := 'WsData';
  Ps.AU_AtStartup   := False;
  Ps.AU_EveryHour   := True;
  Ps.AU_SaveRaw     := False;
  Ps.BP_Correction  := 0;

  Ms.Spoon          := 1;
  Ms.GraphCol_BG    := 0;
  Ms.GraphCol_LINE1 := 16777215;
  Ms.GraphCol_LINE2 := 16777215;
  Ms.GraphCol_TEXT  := 16760832;
  Ms.GraphCol_MAX   := 65280;
  Ms.GraphCol_GRAT  := 8421504;
  Ms.GraphCol_DAY   := 16744703;
  Ms.GraphCol_BAR   := 4259839;
  Ms.GraphCol_Txt   := 65535;
  Ms.GraphCol_ROSE  := 32768;
  Ms.Rose_Index     := 1;
  Ms.HostIP         := IPTextToIP32(HIP);

// Request loggers ip address
  MessageDlg('Please set the IP address of the Logger.  This can be changed later in the settings menu', mtWarning, [MBOK], 0);
  Tries := 3;
  OK := False;
  TTl := 'Enter Logger IP Address';
  Prompt := 'Enter the IP address of the Logger';
  repeat
    AddVal := InputBox(TTl, Prompt, '0.0.0.0');
    OK := (AddVal.Length > 0)
  until OK;

  Ms.LoggerList     := AddVal;
  Ms.ServerIP       := IPTextToIP32(AddVal);
  IPList.Items.Text := AddVal;
  IPList.ItemIndex  := 0;

  Ps.DBPath := Ps.RootPath + '\' + Ps.DBPath;
  if not DirectoryExists(Ps.DBPath) then
    CreateDir(Ps.DBPath);

  CheckTable(Ps.DBPath, Ps.TableName);

  SaveAllSettings(SETTINGTYPE, Ps, Ms, IPList, true);
end;

// Check to see if any settings exist
function DoSettingsExist(St: TSettingType): Boolean;
var
  Reg: TRegistry;
  TimeStr: String;
  Ini: TIniFile;
begin
  case St of
  stIni:  begin
            if FileExists(ChangeFileExt(Application.ExeName, '.Ini')) then
            begin
              Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.Ini'));
              try
                Result := Ini.ReadString('Settings', 'Written', '').Length > 0;
              finally
                Ini.Free;
              end;
            end else
              Result := False;

  end;
  stReg:  begin
            Reg := TRegistry.Create(KEY_READ);

            try
              Result := Reg.OpenKey(REGKEY, False);
              Result := Result and (Reg.ReadString('Written').Length > 0);
            finally
              Reg.Free;
            end;
          end;
  end;
end;

procedure LoadAllSettings(St: TSettingType; var Ps: TConfig; var Ms: TMeasurementSettings; IPList: TComboBox);
var
  Ini: TIniFile;
  Reg: TRegistry;
  IP, IPL: String;
  IPLIdx, HIP: Integer;
begin

  if St = stIni then
  begin
    Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.Ini'));
    try
      Ps.RootPath       := Ini.ReadString('Settings', 'Root', ExtractFilePath(Application.ExeName));

      if Ps.RootPath[Length(Ps.RootPath)] = '\' then
        Ps.RootPath := Copy(Ps.RootPath, 1, Length(Ps.RootPath) - 1);

      Ps.DBPath         := Ps.RootPath + '\' + Ini.ReadString('Settings', 'DB',         'DB');
      Ps.TableName      := Ini.ReadString(  'Settings', 'TableName',    'WsData');
      Ps.AU_AtStartup   := Ini.ReadBool(    'Settings', 'AUStartup',    False);
      Ps.AU_EveryHour   := Ini.ReadBool(    'Settings', 'AUHourly',     False);
      Ps.AU_SaveRaw     := Ini.ReadBool(    'Settings', 'AUSaveRaw',    False);
      Ps.BP_Correction  := Ini.ReadInteger( 'Settings', 'BPCorrection', 0);

      Ms.Temperature    := Ini.ReadInteger('Settings', 'Temperature', 0);
      Ms.Precipitation  := Ini.ReadInteger('Settings', 'Rainfall',    0);
      Ms.Pressure       := Ini.ReadInteger('Settings', 'Pressure',    0);
      Ms.Wind           := Ini.ReadInteger('Settings', 'Wind',        0);
      Ms.GraphCol_BG    := Ini.ReadInteger('Settings', 'GraphCol1',   GRAPHBG);
      Ms.GraphCol_LINE1 := Ini.ReadInteger('Settings', 'GraphCol2a',  GRAPHLINE);
      Ms.GraphCol_LINE2 := Ini.ReadInteger('Settings', 'GraphCol2b',  GRAPHLINE);
      Ms.GraphCol_TEXT  := Ini.ReadInteger('Settings', 'GraphCol3',   GRAPHTEXT);
      Ms.GraphCol_MAX   := Ini.ReadInteger('Settings', 'GraphCol4',   MAXMINLINE);
      Ms.GraphCol_GRAT  := Ini.ReadInteger('Settings', 'GraphCol5',   GRAPHLINE);
      Ms.GraphCol_DAY   := Ini.ReadInteger('Settings', 'GraphCol6',   DAYLINE);
      Ms.GraphCol_BAR   := Ini.ReadInteger('Settings', 'GraphCol7',   GRAPHBAR);
      Ms.GraphCol_Txt   := Ini.ReadInteger('Settings', 'GraphCol8',   GRAPHTXT);
      Ms.Rose_Index     := Ini.ReadInteger('Settings', 'GraphRIdx',   0);
      Ms.GraphCol_ROSE  := ROSE_COLOURS[Ms.Rose_Index];
      Ms.Spoon          := Ini.ReadInteger('Settings', 'Spoon',       1);
      Ms.Smooth         := Ini.ReadInteger('Settings', 'Smooth',      0);
      Ms.AltValue       := Ini.ReadInteger('Settings', 'AltValue',    0);
      Ms.AltUnit        := Ini.ReadInteger('Settings', 'AltUnit',     1);
      Ms.UseMinMax      := Ini.ReadBool(   'Settings', 'UseMinMax', True);
      HIP               := Ini.ReadInteger('Settings', 'HostIP32',    0);
      IPL               := Ini.ReadString( 'Settings', 'IPA',        '');
      IPLIdx            := Ini.ReadInteger('Settings', 'IPAIdx',      -1);
      Ms.Printer        := Ini.ReadString( 'Settings', 'Printer',     '');
      Ms.PrintInvert    := Ini.ReadBool(   'Settings', 'PrintInvert', False);
      Ms.PrinterIndex   := Ini.ReadInteger('Settings', 'PrinterIndex', 0);
      Ms.WindowSize     := Ini.ReadInteger('Settings', 'WindowSize',   4);

    finally
      Ini.Free;
    end
  end else
  if St = stReg then
  begin
    Reg := TRegistry.Create(KEY_READ);

    try
      Reg.OpenKey(REGKEY, True);

      Ps.RootPath       := Reg.ReadString('Root');
      if Ps.RootPath.Length = 0 then
        Ps.RootPath := ExtractFilePath(Application.ExeName);

      if Ps.RootPath[Length(Ps.RootPath)] = '\' then
        Ps.RootPath := Copy(Ps.RootPath, 1, Length(Ps.RootPath) - 1);

      Ps.DBPath         := Ps.RootPath + '\' + Reg.ReadString('DB');
      Ps.TableName      := Reg.ReadString(  'TableName');
      Ps.AU_AtStartup   := Reg.ReadBool(    'AUStartup');
      Ps.AU_EveryHour   := Reg.ReadBool(    'AUHourly');
      Ps.AU_SaveRaw     := Reg.ReadBool(    'AUSaveRaw');
      Ps.BP_Correction  := Reg.ReadInteger( 'BPCorrection');

      Ms.Temperature    := Reg.ReadInteger('Temperature');
      Ms.Precipitation  := Reg.ReadInteger('Rainfall');
      Ms.Pressure       := Reg.ReadInteger('Pressure');
      Ms.Wind           := Reg.ReadInteger('Wind');
      Ms.GraphCol_BG    := Reg.ReadInteger('GraphCol1');
      Ms.GraphCol_LINE1 := Reg.ReadInteger('GraphCol2a');
      Ms.GraphCol_LINE2 := Reg.ReadInteger('GraphCol2b');
      Ms.GraphCol_TEXT  := Reg.ReadInteger('GraphCol3');
      Ms.GraphCol_MAX   := Reg.ReadInteger('GraphCol4');
      Ms.GraphCol_GRAT  := Reg.ReadInteger('GraphCol5');
      Ms.GraphCol_DAY   := Reg.ReadInteger('GraphCol6');
      Ms.GraphCol_BAR   := Reg.ReadInteger('GraphCol7');
      Ms.GraphCol_Txt   := Reg.ReadInteger('GraphCol8');
      Ms.Rose_Index     := Reg.ReadInteger('GraphRIdx');
      Ms.GraphCol_ROSE  := ROSE_COLOURS[Ms.Rose_Index];
      Ms.Spoon          := Reg.ReadInteger('Spoon');
      Ms.Smooth         := Reg.ReadInteger('Smooth');
      Ms.AltValue       := Reg.ReadInteger('AltValue');
      Ms.AltUnit        := Reg.ReadInteger('AltUnit');
      Ms.UseMinMax      := Reg.ReadBool(   'UseMinMax');
      HIP               := Reg.ReadInteger('HostIP32');
      IPL               := Reg.ReadString( 'IPA');
      IPLIdx            := Reg.ReadInteger('IPAIdx');
      Ms.Printer        := Reg.ReadString( 'Printer');
      Ms.PrintInvert    := Reg.ReadBool(   'PrintInvert');
      Ms.PrinterIndex   := Reg.ReadInteger('PrinterIndex');
      Ms.WindowSize     := Reg.ReadInteger('PrinterIndex');
    finally
      Reg.Free;
    end
  end;

// -------------------------------------------------------------------
(*
  Get the hosts current network address - If it fails (not connected to
    the internet) then use the default value from the configuration
*)
  IP := GetCurrentlyActiveIPAddress;
  if Ip.Length > 0 then
    Ms.HostIP         := IPTextToIP32(IP)
  else
    Ms.HostIP         := HIP;

//  Extract the working IP address from the address list
  if IPList <> nil then
  begin
//  convert to CRLF list
    IPL := ReplaceText(IPL, ';', #13#10);
    IPList.Items.Text := IPL;
//  get selected IP index
    IPList.ItemIndex := IPLIdx;
    Ms.ServerIP := IPTextToIP32(IPList.Text);
  end else
  begin
    IPList.Clear;
    IPList.ItemIndex := -1;
  end;
end;

procedure SaveAllSettings(St: TSettingType; Ps: TConfig; Ms: TMeasurementSettings; IPList: TComboBox; Init: Boolean; FirstTime: Boolean = false);
var
  Ini: TIniFile;
  Reg: TRegistry;
  IPL: String;
begin
  if Init then
    Exit;

// convert IPList to a colon separated string
  if IPList <> nil then
  begin
    IPL := Trim(IPList.Items.Text);
    Ms.LoggerList := IPL;
    IPL := ReplaceText(IPL, #13#10, ';');
  end;

  if St = stIni then
  begin
    Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.Ini'));
    try
      Ini.WriteString(  'Settings', 'Root',           Ps.RootPath);
      Ini.WriteString(  'Settings', 'DB',             ExtractFileName(Ps.DBPath));
      Ini.WriteString(  'Settings', 'TableName',      Ps.TableName);
      Ini.WriteBool(    'Settings', 'AUStartup',      Ps.AU_AtStartup);
      Ini.WriteBool(    'Settings', 'AUHourly',       Ps.AU_EveryHour);
      Ini.WriteBool(    'Settings', 'AUSaveRaw',      Ps.AU_SaveRaw);
      Ini.WriteInteger( 'Settings', 'BPCorrection',   Ps.BP_Correction); // saved as mB * 10
      Ini.WriteString(  'Settings', 'IPA',            IPL);
      Ini.WriteInteger( 'Settings', 'IPAIdx',         IPList.ItemIndex);

      Ini.WriteInteger('Settings', 'Temperature', Ms.Temperature);
      Ini.WriteInteger('Settings', 'Rainfall',    Ms.Precipitation);
      Ini.WriteInteger('Settings', 'Pressure',    Ms.Pressure);
      Ini.WriteInteger('Settings', 'Wind',        Ms.Wind);
      Ini.WriteInteger('Settings', 'Smooth',      Ms.Smooth);
      Ini.WriteInteger('Settings', 'Spoon',       Ms.Spoon);
      Ini.WriteInteger('Settings', 'AltValue',    Ms.AltValue);
      Ini.WriteInteger('Settings', 'AltUnit',     Ms.AltUnit);

      Ini.WriteInteger('Settings', 'GraphCol1',   Ms.GraphCol_BG);
      Ini.WriteInteger('Settings', 'GraphCol2a',  Ms.GraphCol_Line1);
      Ini.WriteInteger('Settings', 'GraphCol2b',  Ms.GraphCol_Line2);
      Ini.WriteInteger('Settings', 'GraphCol3',   Ms.GraphCol_Text);
      Ini.WriteInteger('Settings', 'GraphCol4',   Ms.GraphCol_Max);
      Ini.WriteInteger('Settings', 'GraphCol5',   Ms.GraphCol_Grat);
      Ini.WriteInteger('Settings', 'GraphCol6',   Ms.GraphCol_Day );
      Ini.WriteInteger('Settings', 'GraphCol7',   Ms.GraphCol_BAR );
      Ini.WriteInteger('Settings', 'GraphCol8',   Ms.GraphCol_TXT );
      Ini.WriteInteger('Settings', 'GraphCol9',   Ms.GraphCol_ROSE );
      Ini.WriteInteger('Settings', 'GraphRIdx',   Ms.Rose_Index);
      Ini.WriteInteger('Settings', 'HostIP32',    Ms.HostIP);
      Ini.WriteBool(   'Settings', 'UseMinMax',   Ms.UseMinMax);
      Ini.WriteString( 'Settings', 'Printer',     Ms.Printer);
      Ini.WriteBool(   'Settings', 'PrintInvert', Ms.PrintInvert);
      Ini.WriteInteger('Settings', 'PrinterIndex', Ms.PrinterIndex);
      Ini.WriteInteger('Settings', 'WindowSize',  Ms.WindowSize);

      if FirstTime then
      begin
        Ini.WriteInteger('Settings', 'Period',      0);
        Ini.WriteInteger('Settings', 'WindowSize',  4);
        Ini.WriteInteger('Settings', 'Page',        2);
        Ini.WriteBool(   'Settings', 'MinMax',      False);
      end;

      Ini.WriteString(   'Settings', 'Written',    DateTimeToStr(Now));

    finally
      Ini.Free;
    end;
  end else
  if St = stReg then
  begin
    Reg := TRegistry.Create(KEY_ALL_ACCESS);

    try

      Reg.OpenKey(REGKEY, True);

      Reg.WriteString(  'Root',           Ps.RootPath);
      Reg.WriteString(  'DB',             ExtractFileName(Ps.DBPath));
      Reg.WriteString(  'TableName',      Ps.TableName);
      Reg.WriteBool(    'AUStartup',      Ps.AU_AtStartup);
      Reg.WriteBool(    'AUHourly',       Ps.AU_EveryHour);
      Reg.WriteBool(    'AUSaveRaw',      Ps.AU_SaveRaw);
      Reg.WriteInteger( 'BPCorrection',   Ps.BP_Correction); // saved as mB * 10
      Reg.WriteString(  'IPA',            IPL);
      Reg.WriteInteger( 'IPAIdx',         IPList.ItemIndex);

      Reg.WriteInteger('Temperature', Ms.Temperature);
      Reg.WriteInteger('Rainfall',    Ms.Precipitation);
      Reg.WriteInteger('Pressure',    Ms.Pressure);
      Reg.WriteInteger('Wind',        Ms.Wind);
      Reg.WriteInteger('Smooth',      Ms.Smooth);
      Reg.WriteInteger('Spoon',       Ms.Spoon);
      Reg.WriteInteger('AltValue',    Ms.AltValue);
      Reg.WriteInteger('AltUnit',     Ms.AltUnit);

      Reg.WriteInteger('GraphCol1',   Ms.GraphCol_BG);
      Reg.WriteInteger('GraphCol2a',  Ms.GraphCol_Line1);
      Reg.WriteInteger('GraphCol2b',  Ms.GraphCol_Line2);
      Reg.WriteInteger('GraphCol3',   Ms.GraphCol_Text);
      Reg.WriteInteger('GraphCol4',   Ms.GraphCol_Max);
      Reg.WriteInteger('GraphCol5',   Ms.GraphCol_Grat);
      Reg.WriteInteger('GraphCol6',   Ms.GraphCol_Day );
      Reg.WriteInteger('GraphCol7',   Ms.GraphCol_BAR );
      Reg.WriteInteger('GraphCol8',   Ms.GraphCol_TXT );
      Reg.WriteInteger('GraphCol9',   Ms.GraphCol_ROSE );
      Reg.WriteInteger('GraphRIdx',   Ms.Rose_Index);
      Reg.WriteBool(   'UseMinMax',   Ms.UseMinMax);
      Reg.WriteInteger('HostIP32',    Ms.HostIP);
      Reg.WriteString( 'Printer',     Ms.Printer);
      Reg.WriteBool(   'PrintInvert', Ms.PrintInvert);
      Reg.WriteInteger('PrinterIndex', Ms.PrinterIndex);

      if FirstTime then
      begin
        Reg.WriteInteger('Period',      0);
        Reg.WriteInteger('WindowSize',  4);
        Reg.WriteInteger('Page',        2);
        Reg.WriteBool(   'MinMax',      False);
      end;

      Reg.WriteString(    'Written',    DateTimeToStr(Now));

      Reg.CloseKey;
  finally
    Reg.Free;
  end;


  end;
end;

function IPTextToIP32(IP: String): DWord;
var
  Fs: TFieldSet;
begin
  if (IP.Length > 0) then
  begin
    CSVToText(IP, Fs, '.');
    Result :=             StrToInt(Fs.Fields[3]) shl 24;
    Result := Result or ( StrToInt(Fs.Fields[2]) shl 16);
    Result := Result or ( StrToInt(Fs.Fields[1]) shl  8);
    Result := Result or ( StrToInt(Fs.Fields[0]));
  end;
end;

function IP32ToText(Value: DWord): String;
begin
  Result := Format('%u.%u.%u.%u', [ Value         and $FF,
                                   (Value shr  8) and $FF,
                                   (Value shr 16) and $FF,
                                    Value shr 24 ]);
end;

function CheckMeasurementSettingsEx(var Ms: TMeasurementSettings): Boolean;
var
  Cnt: Integer;
begin
    Cnt := 0;

    if Ms.GraphCol_LINE1 = 0 then
    begin
      Ms.GraphCol_LINE1 := GRAPHLINE;
      Inc(Cnt);
    end;

    if Ms.GraphCol_LINE2 = 0 then
    begin
      Ms.GraphCol_LINE2 := GRAPHLINE;
      Inc(Cnt);
    end;

    if Ms.GraphCol_TEXT = 0 then
    begin
      Ms.GraphCol_TEXT := GRAPHTEXT;
      Inc(Cnt);
    end;

    if Ms.GraphCol_MAX = 0 then
    begin
      Ms.GraphCol_MAX := MAXMINLINE;
      Inc(Cnt);
    end;

    if Ms.GraphCol_GRAT = 0 then
    begin
      Ms.GraphCol_GRAT := GRAPHLINE;
      Inc(Cnt);
    end;

    if Ms.GraphCol_DAY = 0 then
    begin
      Ms.GraphCol_DAY := DAYLINE;
      Inc(Cnt);
    end;

    if Ms.GraphCol_BAR = 0 then
    begin
      Ms.GraphCol_BAR := GRAPHBAR;
      Inc(Cnt);
    end;

    if Ms.GraphCol_Txt = 0 then
    begin
      Ms.GraphCol_Txt := GRAPHTXT;
      Inc(Cnt);
    end;

    if Ms.GraphCol_ROSE = 0 then
    begin
      Ms.GraphCol_ROSE := ROSE_COLOURS[Ms.Rose_Index];
      Inc(Cnt);
    end;

    if Ms.Spoon = 0 then
    begin
      Ms.Spoon := 1;
      Inc(Cnt);
    end;

    if Ms.AltUnit = 0 then
    begin
      Ms.AltUnit := 1;
      Inc(Cnt);
    end;

    Result := (Cnt > 0);
end;

function EncodeTime(h: Word; m: word; s: word): Integer;
begin

  h := h mod 24;
	m := m mod 60;
	s := s mod 60;

	Result := ((h * 3600) + (m * 60) + s);
end;

function  TimeToString(TheTime: Integer): String;
var
  h, m, s: word;
begin
  DecodeTime(h, m, s, TheTime);
  Result := Format('%2.2d:%2.2d:%2.2d', [h, m, s]);
end;


procedure DecodeTime(var h, m, s: word; TheTime: Integer);
var
  T: Integer;
begin
  T := TheTime;

  h := Trunc(T / 3600);
  Dec(T, (h * 3600));

  m := Trunc(T / 60);
  Dec(T, (m * 60));

  s := t;
end;

procedure DecodeDate(var d, m, y: word; TheDate: word; FourDigitYear: Boolean = true);
var
  FourYearBlocks: Integer;
  Yr, MonD: Integer;

begin

  FourYearBlocks := Trunc(TheDate / FOURYEARS);
  y := FourYearBlocks * 4;
  d := TheDate - (FourYearBlocks * FOURYEARS) + 1;

  Yr := 0;
  while ((Yr < 4) and (d > YearDays[Yr])) do
  begin
    Dec(d, YEARDAYS[Yr]);
    Inc(y);
    Inc(Yr);
  end;

  if (FourDigitYear) then
    Inc(y, 2000);

  m := 1;

  repeat
    MonD := DaysInMonth[m - 1];
    if ((Yr = 0) and (m = 2)) then
      MonD := 29;

    if (d > MonD) then
    begin
      Dec(d, MonD);
	    Inc(m);
    end else
      break;
  until false;
end;

end.
