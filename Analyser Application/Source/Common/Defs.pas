unit Defs;

interface

uses
  ShareMem,
  System.Types, System.Classes, System.SysUtils, Vcl.Graphics;

const
  T_CELCIUS     = 0;
  T_FAHRENHEIT  = 1;
  R_MILLIMETERS = 0;
  R_INCHES      = 1;
  P_MILLIBARS   = 0;
  P_MM_HG       = 1;
  P_IN_HG       = 2;
  W_MPS         = 0;
  W_KPH         = 1;
  W_MPH         = 2;
  INVALID_DATA: SmallInt = -255;

  Deg_to_Rad = 1 / (360 / (2 * PI));

  (*
   * number of days in four years, starting with a Leap Year.  OK until 2400 i.e. Year mod 400 = 0
   * 2000 isnt 2100 is 2200 is 2300 is 2400 isnt
   *)
  FOURYEARS                                 = 1461;
  DAYSINMONTH:      array [0..11] of Byte 	= (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  TICKS_IN_PERIOD:  array [0..7] of Integer = ( 12,   // 1 day
                                                14,   // 7 days
                                                14,   // 14 days
                                                15,   // 1 month
                                                15,   // 3 months
                                                12,   // 6 months
                                                12,   // 12 moths
                                                12);  // 24 months

  YEARDAYS: array [0..3] of Word 	= (366, 365, 365, 365);
  LINESINFILE       = (24 * 60) + 1;
  MAX_SECONDS       = 60 * 60 * 24;
  MAX_DAYS          = 721;
  SAMPLES_PER_HOUR  = 60;
  SAMPLES_PER_DAY   = SAMPLES_PER_HOUR * 24;
  WHOLEDAY          = SAMPLES_PER_DAY;
  TWELVE_HOURS      = MAX_SECONDS div 2;
  SEA_LEVEL         = 1013.2;  { mB}
  PERIOD_WITHOUT_RAIN = 4;


  AT_DATE_OFFSET    = 36526; // Date offset from Delphi date AT Date starts at 01/01/2000 = 0
  PLOT_BUFFER_SIZE  = 760; // 720;
  BIG_BUFFER_SIZE   = SAMPLES_PER_DAY * MAX_DAYS;
  FIELD_NAMES: array [0..11] of String = (  'WsDate',     'WsTime',     'WsWindDir',  'WsWindAvr',
                                            'WsWindPk',   'WsTemp',     'WsHumidity', 'WsRainDay',
                                            'WsRainHour', 'WsRainMin',  'WsPressure', 'WsRSSI');

  UNIT_STRINGS: array [0..3, 0..2] of String = (
                                                  ('m/S',                 'KPH',                  'MPH'),
                                                  (char(0176)+'C',        char(0176)+'F',         ''),
                                                  ('mm',                  'inches',               ''),
                                                  ('mB / hPa',            'mmHg',                 'inHg')
                                               );

  Suffix: array [0..1] of String = ('mm', 'inches');

  INNER_RAD         = 25;
  ROSE_SEGMENTS     = 16;

  STRETCH_SIZE: array [0..7] of Integer   = (720, 105, 52, 24, 8, 4, 2, 1);
  COLOUR_OFFSETS: array [0..4] of TColor  = ($00000000, $202020, $404040, $606060, $808080);
  ROSE_COLOURS: array [0..5] of TColor    = ($000080, $008000, $800000, $008080, $808000, $800080);

  ROSE_INNER_DIA = 25;

  SHIFT_PRESSED = 1;
  CONTROL_PRESSED = 1;
  ALT_PRESSED = 1;

  RAD = 0.0174532;

  DTOR: Single = 1 / (360 / (2 * PI));  // degrees to radians

  // highest and lowest ever recorded BP
  MAXBP: Integer = 10900;
  MINBP: Integer = 8600;

// GRAPH PARAMETERS
// margins
  MARGIN_TOP    = 40;
  MARGIN_BOTTOM = 75;
  MARGIN_LEFT   = 70;
  MARGIN_RIGHT  = 50;

// default graph colours
  GRAPHBG     = $404040;
  GRAPHLINE   = $FFFFFF;
  GRAPHTEXT   = $FFC000;
  MAXMINLINE  = clLime;
  GRATICULE   = $008080;
  DAYLINE     = $FF80FF;
  GRAPHBAR    = $40FFFF;
  GRAPHTXT    = clYellow;
  GRAPHROSE   = $008088;

  UDP_PORT   = 2010;
  UDP_TIMEOUT = 2000;
  UDP_STATUS_TIMEOUT = 10000;

  WIND_DIR_CORR = 1.406;

  REMOTE_PATH = '/Data/';

(*
 * Bucket rain measurement device
 * row 0 = mm units   tips per 0.01" spoon, tips per 2mm Spoon
 * row 1 = inch units tips per 0.01" spoon, tips per 2mm Spoon
 *
 *                                  Spoon units 0.01"  2mm *)
  RAIN_BUCKET: array [0..1, 0..1] of Single = ((3.937,   5),  // mm units
                                               (  100, 127)); // inch units

  RDIR_TRIES = 3;

  TIME_MULT = 1 / 86400;  // conversion to delphi time

  BUTTONTEXTWIDTH = 53; // text width of toolbar buttons

type

  TLiveData = record
    MessageType:  Byte;
    IP:           DWord;
    Time:         DWord;
    WindDir:      Integer;
    WindSpeed:    Integer;
    Temp:         Integer;
    Humidity:     Integer;
    Pressure:     Integer;
    HourlyRain:   Integer;  // tips this hour
    BatteryState: Boolean;
  end;

  TSmoothing = record
    SmoothingState: DWord;
    SmoothingChange: DWord;
    SmoothingFlag: Boolean;
  end;

  TWsRecord = record
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
    WsRSSI:     Integer;
  end;

// not all of these translate into commands to the logger
  TLoggerCmd = (lcNone            = 0,
                lcAck             = 1,
                lcLiveData        = 2,
                lcLoggerStatus    = 3,
                lcGetDirectory    = 4,
                lcGetFile         = 5,
                lcEraseFile       = 6,
                lcEraseAll        = 7,
                lcRestart         = 8,
                lcAppdenData      = 9,
                lcAppendLog       = 10,
                lcGetSysLog       = 11,
                lcAppendLogBuffer = 12,
                lcImportFile      = 13
               );

(* from SdFunction.h in logger code
enum tLoggerCmd {
                  lcNone = 0,
                  lcAck = 1,
                  lcLiveData = 2,
                  lcLoggerStatus = 3,
                  lcGetDirectory = 4,
                  lcGetFile = 5,
                  lcEraseFile = 6,
                  lcEraseAll = 7,
                  lcRestart = 8,
                  lcAppendData = 9,
                  lcAppendLog = 10,
                  lcGetLog = 11,
                  lcAppendLogBuffer = 12
                };
*)

  TRoundDir = (rdDown, rdUp);
  BPCorrectionUnit = (cuFeet, cuMetres);

  TScale = record
    Max:          Single;
    Ticks:        SmallInt;
    PixStep:      Single;
    ScaleFactor:  Single;
    ScaleStep:    Single;
  end;

  TIniMode = (imGet, imPut);

  TGetMode = (gmDir, gmFile);
  TGetInfo = record
    giMode: TGetMode;
    goSize: Integer;
  end;

  TInsertInfo = record
    Inserted: Integer;
    Duplicated: Integer;
    Count: Integer;
    error: String;
  end;

  TVectors = record
    Length: SmallInt;
    Count: SmallInt;
    Visits: Integer;
  end;

  TSettingType = (stIni, stReg);

  TConvertType = (ctNone, ctToCelcius);

  TSampleMode = (smAverage, smMin, smMax, smRainHours);

  TMeasurementSettings = record
    Temperature:    Byte;
    Precipitation:  Byte;
    Pressure:       Byte;
    Wind:           Byte;
    Smooth:         Word;
    GraphCol_BG:    DWord;
    GraphCol_LINE1: DWord;
    GraphCol_LINE2: DWord;
    GraphCol_TEXT:  DWord;
    GraphCol_MAX:   DWord;
    GraphCol_GRAT:  DWord;
    GraphCol_DAY:   DWord;
    GraphCol_BAR:   DWord;
    GraphCol_Txt:   DWord;
    GraphCol_ROSE:  DWord;
    Rose_Index:     Byte;
    Spoon:          Word;
    AltValue:       Integer;
    AltUnit:        Byte;
    Init:           Boolean;
    ServerIP:       DWord;
    SeverIdx:       Integer;
    HostIP:         DWord;
    LoggerList:     String;
    Printer:        String;
    PrinterIndex:   Integer;
    PrintInvert:    Boolean;
    Period:         Integer;
    WindowSize:     Integer;
    Page:           Integer;
    UseMinMax:      Boolean;

    Changed:        Boolean;
  end;

  TTimeRange = record
    start_Time: DWord;
    end_Time: DWord;
  end;

  TDateRange = record
    start_date: Word;
    end_date: Word;
  end;

  TMaxMin = record
    Max: SmallInt;
    Min: SmallInt;
  end;

  TDualPlotBuffer = record
    Max: array [0..PLOT_BUFFER_SIZE] of SmallInt;
    Min: array [0..PLOT_BUFFER_SIZE] of SmallInt;
    Count: Integer;
  end;

  TMaxMinArray = record
    Max: array of SmallInt;
    Min: array of SmallInt;
    Count: Integer;
  end;

  TScaleText = record
    TopStr: String;
    BotStr: String
  end;

  TScaleFactor = record
    Subtract: Single; // looked up offset
    Scale: Single;
  end;

  TRadLineInfo = record
    Number: Integer;
    AngleOffset: Integer;
    Length: Integer;
    Style: TPenStyle;
    Width: Integer;
    Colour: TColor;
  end;

  TWindDataReading = record
    Direction: Single;
    RawDir: Integer;
    Speed:  array[0..4] of Single;
    SpeedMax: Integer;
  end;

  TWindReadings = array [0..ROSE_SEGMENTS - 1] of TWindDataReading;

// axes structure - contails all info related to plotting graphs
  TAxes = record
// data min and max's
    Min:            Integer;
    Max:            Integer;
    DataMin:        Integer;
    DataMax:        Integer;
    Avr:            Integer; // only used for wind dir

// data information
    Data_Samples:   DWord;
    DataMultiplier: Single;
    Data_Field:     Byte;
    Field_Name:     String;
    RecordCount:    DWord;
    BufferSamples:  Word;
    ErrorCount:     Word;
    ErrorIndex: array of Word;
    CallingButton:  Byte;

// data period
    Period:         Byte;
    Data_Days:      Word;
    StartDate:      Word;
    EndDate:        Word;
    UseDays:        Word;
    DateList: array of Word;

// graph display information
    XTitle:         String;
    YTitle:         String;
    X_Scale_Type:   Byte;
    X_ScaleFactor:  Word;
    Y_ScaleFactor:  TScaleFactor;
    ShowMinMax:     Boolean;
    VectorsRotated: Boolean;
    ReadingType:    Byte;
    DayStart:       Word;
    DualLine:       Boolean;
    BPCorrection:   Word;
  end;

  pTAxes = ^TAxes;

  TSegmentInfo = record
    Inner_Rad: Integer;
    Outer_Rad: Integer;
    Segment_Inner: Integer;
    Origin: TPoint;
    BaseColour: TColor;
    ScaleMax: Integer;
    ScaleFactor: Single;
    UnitIndex: Byte;
    TotalDataSamples: Integer;
    TotalActiveWind: Integer;
    Data: TWindReadings;
    DataMax: Single;
    SpeedMax: Integer;
    SpeedStep: Integer;
    Ticks: Integer;
    TickScaleIncrement: Integer;
    PixPerTick: Integer;
    ColursInUse: Integer;
    Colours: array [0..4] of TColor;
    pAxes: pTAxes;
  end;

  TPolarQuad = record
    Quad: array [0..35] of SmallInt;
    MaxSpeed: SmallInt;
    MaxDir: SmallInt;
  end;

  TPolarInfo = record
    Values: array [0..3] of TPolarQuad;
    Origin: TPoint;
    Outer_Rad: SmallInt;
    MaxSpeed: SmallInt;
    CurrentQuad: Byte;
  end;

  TYScaleInfo = record
    UseDP:      Boolean;
    YTicks:     Integer;
    ScaleValue: Single;
    YPixStep:   Single;
    YDataStep:  Integer;
    X, Y:       Integer;
    RVs:        Boolean;
  end;

  TWsData = record
    Date:   SmallInt; { 0}
    Time:   DWord;    { 1}
    Dir:    SmallInt; { 2}
    AvrSpd: SmallInt; { 3}
    PkSpd:  SmallInt; { 4}
    Temp:   SmallInt; { 5}
    Humid:  SmallInt; { 6}
    Day:    SmallInt; { 7}
    Hour:   SmallInt; { 8}
    Min:    SmallInt; { 9}
    Pres:   SmallInt; {10}
    Rssi:   SmallInt; {11}
  end;

  pWsData = ^TWsData;

  TWsDataList = array of TWsData;

  TPrinterInfo = record
    PrinterName: String;
    Invert: Boolean;
  end;

  TQueryData = array of Smallint;
  pQd = ^TQueryData;

  TConfig = record
    RootPath: String;
    RootPathChanged: Boolean;
    DBPath: String;
    TableName: String;
    AU_AtStartup: Boolean;
    AU_EveryHour: Boolean;
    BP_Correction: Integer;
    AU_SaveRaw:   Boolean;
  end;

  TFileInfo = record
    FileType: TLoggerCmd;
    FileName: String;
    CurBlock: DWord;
    PreBlock: DWord;
    LastBlock: Boolean;
    TotalBlocks: Word;
    Data: String;
    DataReady: Boolean;
    Info: String;
    Error: Boolean;
  end;

  TFileCmd = record
    DestIP: String;
    Port: Word;
    Cmd: String;
  end;

  TUdpIp = record
    Host: String;
    Server: String;
    Port: Word;
  end;

  TRawConfig = record
    Path: String;
    Server: String;
    Host: String;
    Port: Word;
  end;

  TVersionInformation = record
    AsInteger: Integer;
    AsString: String;
    AsHex: String;
  end;

// Globals
var
    MeasurementSettings: TMeasurementSettings;
(* __QueryData can be too large (1.03 M samples) to put on stack *)
  __QueryData: TQueryData;
  __ORIGIN: TPoint;
  __KBState: Byte;
  __DebugBuffer: TStringList;
  __WsHandle: THandle;
  __Config: TConfig;
  __FileInfo: TFileInfo;
  __DeleteIndex: Integer;
  __UdpIP: TUdpIp;


  Ax: TAxes; // holds everthing (except the buffers) related to plotting

  // plot positions
  GRAPH_WIDTH:  Word;// = PLOT_BUFFER_SIZE;     // pixel size of graph X axis
  YBOT:         Word;// = 570 - MARGIN_BOTTOM;  // graph Y axis bottom
  YTOP:         Word;// = MARGIN_TOP;           // graph Y axis top
  XLEFT:        Word;// = MARGIN_LEFT;          // graph X axis left
  XRIGHT:       Word;// = XLEFT + GRAPH_WIDTH;  // graph X axis right
  GRAPH_WINDOW_WIDTH: Word;// = MARGIN_LEFT + GRAPH_WIDTH + MARGIN_RIGHT; // graph image width
  GRAPH_HEIGHT: Word;//  = 570;

  const
    InstallStateText: array [false..true] of String = ('IS NOT installed', 'IS installed');
    SETTINGTYPE = stIni;
    REGKEY = 'SOFTWARE\WsLogger\Settings';


implementation

end.
