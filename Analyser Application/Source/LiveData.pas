unit LiveData;

interface

uses
   WinApi.Windows, System.SysUtils, Dialogs, Vcl.StdCtrls,
   at_gen_utils, IDGlobal, Defs, LoggerLib, Vcl.ComCtrls, ulkJson;

var
  __LiveData: TLiveData;

const
FieldTitles: array [0..15] of String = (  {0}  '',
                                          {1}  '',
                                          {2}  '',
                                          {3}  '',
                                          {4}  'UV Index',
                                          {5}  '',
                                          {6}  'Solar Irradiation',
                                          {7}  '',
                                          {8}  'Temperature',
                                          {9}  '',
                                          {A}  'Humidity',
                                          {B}  '',
                                          {C}  '',
                                          {D}  '',
                                          {E}  'Bucket Tips',
                                          {F}  '' );
  DEGFTODEGC = 1.406;
  MPHTOKPH   = 1.609;


function UpdateLiveData(js: TlkJSONobject; var Ld: TLiveData): Boolean;
function GetLDString(ms: TMeasurementSettings): String;
procedure LiveDataSetInit();

implementation

procedure LiveDataSetInit();
begin
  __LiveData.WindDir := 0;
  __LiveData.WindSpeed := 0;
  __LiveData.Temp := 320;
  __LiveData.Humidity := 999;
  __LiveData.HourlyRain := 0;
  __LiveData.Pressure := 10000;
end;

function UpdateLiveData(js: TlkJSONobject; var Ld: TLiveData): Boolean;
(* from logger code
  doc["mi"] = rq.Request;
  doc["ip"] = (uint32_t) lip;
  doc["ct"] = (uint16_t) dateInfo.CurTime;
  doc["wd"] = liveData.WindDir;
  doc["ws"] = liveData.WindSpeed;
  doc["tm"] = liveData.Temperature;
  doc["hm"] = liveData.Humidity;
  doc["bp"] = liveData.Pressure;
  doc["tr"] = liveData.HourlyRain;

  {"mi":1,"ip":3439438016,"ct":15371,"wd":131,"ws":1,"tm":631,"hm":0,"bp":10006,"tr":0}
* Wind direction is corrected in the logger
*)
begin
  Ld.MessageType := js.Field['mi'].Value;
  Ld.IP          := js.Field['ip'].Value;
  Ld.Time        := js.Field['ct'].Value;
  Ld.WindDir     := js.Field['wd'].Value;
  Ld.WindSpeed   := js.Field['ws'].Value;
  Ld.Temp        := js.Field['tm'].Value;
  Ld.Humidity    := js.Field['hm'].Value;
  Ld.Pressure    := js.Field['bp'].Value + __Config.BP_Correction ;
  Ld.HourlyRain  := js.Field['tr'].Value;

  Result := MeasurementSettings.ServerIP = Ld.IP;
end;

function GetLDString(ms: TMeasurementSettings): String;
var
  val, precmult, bpCorrection: Single;
begin
  Result := Format('Time: %s  ', [ TimeToString(__LiveData.Time)]);

  Result := Result + Format('Wind Dir: %3d%s  ', [__LiveData.WindDir, char(0176)]);

  case ms.Wind of
  0: val := __LiveData.WindSpeed * 0.447; // M/S
  1: val := __LiveData.WindSpeed * 1.609; // KPH
  2: val := __LiveData.WindSpeed;         // MPH
  end;
  Result := Result + Format(' Wind Speed: %4.1f %s  ', [val, UNIT_STRINGS[0, ms.Wind]]);

  case ms.Temperature of
  0: val := (__LiveData.Temp - 320) * 0.555;  // C
  1: val := __LiveData.Temp;                  // F
  end;
  Result := Result + Format(' Temperature: %4.1f %s  ', [val / 10, UNIT_STRINGS[1, ms.Temperature]]);

  Result := Result + Format(' Humidity: %4.1f %%RH  ',  [__LiveData.Humidity / 10]);

  Result := Result + Format(' Dew Point: %2.1f %s ',  [ GetDewPoint(__LiveData.Temp, __LiveData.Humidity, ms.Temperature = 0),
                                                  UNIT_STRINGS[1, ms.Temperature]]);

  precmult := RAIN_BUCKET[ms.Precipitation, ms.Spoon];
  val := __LiveData.HourlyRain * precmult;
  Result := Result + Format(' Hour Rainfall: %4.1f %s/Hr  ', [val / 10, UNIT_STRINGS[2, ms.Precipitation]]);

  case ms.Pressure of
  0: precmult := 1;
  1: precmult := 0.75;
  2: precmult := 0.0295;
  end;
  bpCorrection := Round((GetBPOffset(Ms.AltValue, BPCorrectionUnit(Ms.AltUnit)) * precmult) * 10);
  Result := Result + Format(' Pressure: %5.1f %s', [((__LiveData.Pressure + bpCorrection) * precmult) / 10, UNIT_STRINGS[3, ms.Pressure]]);
end;

end.
