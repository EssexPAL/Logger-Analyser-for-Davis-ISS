unit Average;

interface

uses
  ShareMem,
  Dialogs, Defs, Math, System.Types, System.SysUtils;


procedure SubSmooth(var InBuffer: array of SmallInt; Points, WinWidth: Word);
procedure SmoothData(var Sdata: array of SmallInt; WinWidth, Points: Integer; var DataMin, DataMax: Integer; ScaleUp: Boolean = false);
function  RoundUpDown(Value: Integer; Dir: TRoundDir; Corr: Integer = 0): Integer; overload;
function  RoundUpDown(Value: Single; Dir: TRoundDir; Corr: Integer = 0): Integer; overload;
function  AverageAngles(Ax: TAxes): Single;

implementation

(* Average ALL the wind direction samples in the buffer and return
 * the average wind direction *)
function AverageAngles(Ax: TAxes): Single;
var
  X, Y: Single;
  i: Integer;
const
  DTOR = 1 / (360 / (2 * PI));
begin
  for i := 0 to (Ax.Data_Days * SAMPLES_PER_DAY) - 1 do
  begin
    X := X + Sin(DTOR * __QueryData[i]);
    Y := Y + Cos(DTOR * __QueryData[i]);
  end;
  X := X / Ax.Data_Samples;
  Y := Y / Ax.Data_Samples;
  Result := ArcTan2(X, Y) / DTOR;
end;

function RoundUpDown(Value: Integer; Dir: TRoundDir; Corr: Integer = 0): Integer;
var
  Mult: Integer;
  isNeg: Boolean;
begin
  if Value mod 10 = 0 then
    exit(Value);

  isNeg := (Value < 0);
  if IsNeg then
  begin
    if Dir = rdDown then
      Dir := rdUp
    else
      Dir := rdDown;
  end;

  Value := Abs(Value);

  Mult := Trunc(Power(10, Trunc(Log10(Value) + Corr)));

  if Mult = 0 then
    Mult := 1;

  case Dir of
    rdDown: Result := (Value div Mult) * Mult;
    rdUp:   Result := ((Value div Mult) + 1) * Mult;
  end;

  if isNeg then
    Result := -Result;
end;

function RoundUpDown(Value: Single; Dir: TRoundDir; Corr: Integer = 0): Integer;
var
  Mult: Integer;
  isNeg: Boolean;
begin
  isNeg := (Value < 0);
  if IsNeg then
  begin
    if Dir = rdDown then
      Dir := rdUp
    else
      Dir := rdDown;
  end;

  Value := Abs(Value);

  Mult := Round(Power(10, Trunc(Log10(Value) + Corr)));

  case Dir of
    rdDown: Result := (Trunc(Value) div Mult) * Mult;
    rdUp:   Result := ((Trunc(Value) div Mult) + 1) * Mult;
  end;

  if isNeg then
    Result := -Result;
end;


// smooth the data using SMA
procedure SmoothData(var Sdata: array of SmallInt; WinWidth, Points: Integer; var DataMin, DataMax: Integer; ScaleUp: Boolean = false);
var
  Idx, I, MaxPoints: Integer;
  Din: array of SmallInt;
  Started: Boolean;
begin
  if (WinWidth < 3) then
  begin
    MessageDlg('The window width minimum is 3!', mtWarning, [mbOK], 0);
    Exit;
  end;

  if (WinWidth and 1 = 0) then
  begin
    MessageDlg('The window width must be an odd number!', mtWarning, [mbOK], 0);
    Exit;
  end;

  DataMin :=  32768;
  Datamax := -32768;

  SetLength(Din, Points);

// find the last valid data samples
  MaxPoints := 760;
  Idx := Points;
  while MaxPoints >= 0 do
  begin
    if SData[MaxPoints] > -255 then
      break;
    Dec(MaxPoints);
  end;

(* scan and copy the data.  Find the number of points of valid datat
 * processed.  Valid is where the value is greater than -255.
 * Imports of data where the day is incomplete (less than 1440 samples)
 * should only process the valed data at the begining.
 ^ If the current byte of data is invalid but the next is valid then
 * copy the next byte.  The data in SData is already averaged so watch
 * out for negative values *)

  Idx := Points;
  Started := False;

  Idx := Points - 1;
  while Idx >= 0 do
  begin
    if not Started then
      if (SData[Idx] > -128) then
      begin
        Started := True;
        MaxPoints := Idx;
      end;

    if Started then
    begin
      if SData[Idx] > -128 then
        Din[Idx] := SData[Idx]
      else
      begin
        if Din[Idx + 1] > -128 then
          Din[Idx] := Din[Idx + 1];
      end;
    end;

    Dec(Idx);
  end;

// smooth the data
  SubSmooth(Din, MaxPoints + 1, winWidth);

  DataMin :=  32768;
  DataMax := -32768;

  Idx := 0;
  while Idx < Points do
  begin
    SData[Idx] := Din[Idx];

    if (SData[Idx] <> -255) then
    begin
      if DataMin > Din[Idx] then
        DataMin := Din[Idx];

      if DataMax < Din[Idx] then
        DataMax := Din[Idx];
    end;

    Inc(Idx);
  end;

  Inc(DataMax, 10);
  Dec(DataMin, 10);

end;

procedure SubSmooth(var InBuffer: array of SmallInt; Points, WinWidth: Word);
var
  Idx, WinMin, WinMax, WinTotal, p, Ww: Integer;
  OutBuffer: array of SmallInt;
begin

  Ww := WinWidth;

  SetLength(OutBuffer, Length(InBuffer));

// smooth the data that properly fits within the sample window
// that is Winwidth div 2 to Points - WinWidht div 2
  WinMin := 0;
  Idx := 0;
  while Idx < (Points - (WinWidth div 2)) do
  begin
    Idx := WinMin + WinWidth div 2;
    WinMax := WinMin + WinWidth;;
    p := WinMin;
    WinTotal := 0;

    while p < WinMax do
    begin
      Inc(WinTotal, InBuffer[p]);
      Inc(p);
    end;

    OutBuffer[Idx] := Round(WinTotal / WinWidth);
    Inc(Idx);
    Inc(WinMin);
  end;

// Smooth the ends of the buffer
// lower end
  while WinWidth > 1 do
  begin
    Dec(WinWidth, 2);
    WinMin := 0;
    WinMax := WinWidth - 1;
    WinTotal := 0;

    while WinMin < WinWidth do
    begin
      Inc(WinTotal, InBuffer[WinMax]);
      Inc(WinMin);
    end;

    OutBuffer[WinWidth div 2] := Round(WinTotal / WinWidth);
  end;

// upper end
  WinWidth := ww;
  while WinWidth > 1 do
  begin
    Dec(WinWidth, 2);
    WinMin := Points - WinWidth;
    WinTotal := 0;
    Idx := Points - 1 - (WinWidth div 2);

    while WinMin < Points do
    begin
      Inc(WinTotal, InBuffer[WinMin]);
      Inc(WinMin, 1);
    end;

    OutBuffer[Idx] := Round(WinTotal / WinWidth);
  end;

// Copy the output buffer back to the input buffer
  for Idx := 0 to Points - 1 do
    InBuffer[Idx] := OutBuffer[Idx];

end;

end.
