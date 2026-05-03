unit Rose;

interface

uses

  ShareMem,
  Defs, Vcl.ExtCtrls, Vcl.Graphics, System.Types, LoggerLib, Average,
  System.SysUtils, Vcl.Forms, Log, Windows, Dialogs, System.Classes;

procedure Plot_Rose(Ax: TAxes; Img: TImage; Settings: TMeasurementSettings; Si: TSegmentInfo);
procedure Plot_QuadPolar(Ax: TAxes; Img: TImage; Settings: TMeasurementSettings; Pol: TPolarInfo);
procedure DrawRadialLines(Can: TCanvas; Origin: TPoint; Info: TRadLineInfo);
procedure DrawPieSubSegment(Can: TCanvas; var Si: TSegmentInfo; AngleIdx, SpeedIdx: Integer);
procedure DrawFullSegment(Can: TCanvas; var Si: TSegmentInfo; AngleIndex: Integer);
procedure DrawPieSegment(Can: TCanvas; Origin: TPoint; Info: TSegmentInfo; AngleIdx, Amplitude: Integer);
procedure DispayResultsInfo(Can: TCanvas; Si: TSegmentInfo);
function  ToHrsAndMins(Period: Integer): String;
procedure DrawCompassPoints(Can: TCanvas; Origin: TPoint; Dia: Integer; BG: TColor);
procedure TextAligned(Can: TCanvas; X, Y: Integer; Txt: String; Align: TAlignment);

implementation

procedure DisplayInfo(Can: TCanvas; Pol: TPolarInfo);
  function QtoT(Pol: TPolarInfo): String;
  begin
    case Pol.CurrentQuad of
    0: Result := '00:00 .. 05:59';
    1: Result := '06:00 .. 11:59';
    2: Result := '12:00 .. 17:59';
    3: Result := '18:00 .. 23:59';
    end;
  end;

  function IdxToDeg(Idx: Byte): String;
  begin
    Result := Format('%d to %d', [Idx * 10, ((Idx + 1) * 10) - 1]);
  end;

var
  TempCol: TColor;
  Area: TRect;
const
  MARGIN = 5;
  OFFSET_L = 165;
  OFFSET_T = -15;
  OFFSET_R = 280;
  OFFSET_B = 15;
begin
  Area := Rect( Pol.Origin.X + OFFSET_L - 15,
                Pol.Origin.Y - Pol.Outer_Rad + OFFSET_T,
                Pol.Origin.X + OFFSET_R + 10,
                Pol.Origin.Y + Pol.Outer_Rad + OFFSET_B);

  TempCol := Can.Brush.Color;
  Can.Brush.Color := MeasurementSettings.GraphCol_Txt;
  Can.Font.Name := 'Monospac821 BT';
  Can.Font.Size := 10;
  Can.FillRect(Area);
  Can.Font.Color := clBlack;
  TextAligned(Can, (Area.Width div 2) + Area.Left, Area.Top + 5,  'PERIOD INFO', taCenter);
  TextAligned(Can, (Area.Width div 2) + Area.Left, Area.Top + 30, 'Time', taCenter);
  TextAligned(Can, (Area.Width div 2) + Area.Left, Area.Top + 50,  QtoT(Pol), taCenter);
  TextAligned(Can, (Area.Width div 2) + Area.Left, Area.Top + 70,   'Predominant Dir.', taCenter);
  TextAligned(Can, (Area.Width div 2) + Area.Left, Area.Top + 90,
                      Format('%s deg.', [IdxToDeg(Pol.Values[Pol.CurrentQuad].MaxDir)]),
                      taCenter);

  TextAligned(Can, (Area.Width div 2) + Area.Left, Area.Top + 110,   'Predominant Dur.', taCenter);
  TextAligned(Can, (Area.Width div 2) + Area.Left, Area.Top + 130,
                      Format('%d mins.', [Pol.Values[Pol.CurrentQuad].MaxSpeed]),
                      taCenter);


  //    TextAligned(Img.Canvas, Bi.Centre.X, Bi.TopMargin, 'Period Info', taCenter);


  Can.Brush.Color := TempCol;
end;

procedure Plot_QuadPolar(Ax: TAxes; Img: TImage; Settings: TMeasurementSettings; Pol: TPolarInfo);
var
  X, Y, Ang, Qx, Qy: SmallInt;
  XX, YY, VecScale: Single;
  BGColour: Integer;
const
  DTOR = 1 / (360 / (2 * PI));
  FILLCOLOUR = $404040;
//  BGCOLOUR = $303030;
  XOFFSETS: array [0..3] of SmallInt = (-75, -75, -75, -75);
begin
  if Pol.MaxSpeed = 0 then
  begin
    MessageDlg(Format('There is no wind speed data for %s!', [DateToStr(Ax.StartDate - AT_DATE_OFFSET)]), mtInformation, [mbOK], 0);
    Exit;
  end;

  BGColour := Settings.GraphCol_BG;

  Pol.Origin := Point((Img.Width div 2) - 120, Img.Height div 2);
  __ORIGIN  := Pol.Origin;


// clear graph area
  Img.Canvas.Brush.Color := FillColour;
  Img.Canvas.Pen.Color  := clwhite;
  Img.Canvas.FillRect(Rect(0, 0, Img.Width, Img.Height));

  Img.Canvas.Font.Color := clWhite;
  Img.Canvas.TextOut(Pol.Origin.X + 460, 10, Format('Date: %d', [Ax.StartDate]));

  Qx := Img.Width div 4;
  Qy := Img.Height div 4;

  VecScale := Pol.Outer_Rad / Pol.MaxSpeed;

  Pol.CurrentQuad := 0;
  while Pol.CurrentQuad < 4 do
  begin
//  set drawing parameters and draw area perimeter lines
    Img.Canvas.Pen.Width := 1;
    Img.Canvas.Pen.Color := clWhite;
    Img.Canvas.Brush.Color := BGColour;
    Img.Canvas.Pen.Style := psSolid;
    Pol.Origin := Point(Qx + (((Pol.CurrentQuad and 1) shl 1) * Qx) + XOFFSETS[Pol.CurrentQuad], Qy + ((Pol.CurrentQuad and 2) * Qy));

    DisplayInfo(Img.Canvas, Pol);

    DrawCircle(Img.Canvas, Pol.Origin, Pol.Outer_Rad); // draw filled rose perimeter

    //  draw compass points i.e. N S E W etc
    DrawCompassPoints(Img.Canvas, Pol.Origin, Pol.Outer_Rad + 25, FillColour);

    Img.Canvas.Pen.Width := 3;

    Img.Canvas.Pen.Color := clLime;
    for Ang := 0 to 35 do
    begin
      XX := Sin((Ang * 10) * DTOR);
      YY := Cos((Ang * 10) * DTOR);
      X := Round((XX * Pol.Values[Pol.CurrentQuad].Quad[Ang]) * VecScale);
      Y := Round((YY * Pol.Values[Pol.CurrentQuad].Quad[Ang]) * VecScale);
      Img.Canvas.MoveTo(Pol.Origin.X, Pol.Origin.Y);
      Img.Canvas.LineTo(Pol.Origin.X + X, Pol.Origin.Y - Y);
    end;

    Img.Canvas.Brush.Color := Settings.GraphCol_Txt;// $408080;
    Img.Canvas.Font.Color := clBlack;
    Inc(Pol.CurrentQuad);
  end;
end;


procedure DrawCross(Can: TCanvas; Origin: TPoint; X, Y: Integer; Size: Integer);
begin
  Size := Size div 2;

  Can.MoveTo(Origin.X - X - Size, Origin.Y + Y);  // H
  Can.LineTo(Origin.X + X + Size, Origin.Y + Y);

  Can.MoveTo(Origin.X + X,  Origin.Y - Y - Size);
  Can.LineTo(Origin.X + X,  Origin.Y + Y + Size);
end;

procedure MakeRadialScale(var Si: TSegmentInfo);
var
  Cnt: Integer;
begin
  Cnt := 0;
  Si.DataMax := 0;

// find max direction value
  while Cnt < ROSE_SEGMENTS do
  begin
    if Si.Data[Cnt].Direction > Si.DataMax then
      Si.DataMax := Si.Data[Cnt].Direction;

    Inc(Cnt);
  end;

  Si.ScaleMax := (Trunc((Si.DataMax - 0) / 5) + 1) * 5 ;
  Si.Ticks := 5;
  Si.TickScaleIncrement := Round(Si.ScaleMax / Si.Ticks);
  Si.ScaleMax := Si.Ticks * Si.TickScaleIncrement;
  Si.ScaleFactor := Si.ScaleMax / (Si.Outer_Rad - Si.Inner_Rad);

end;

procedure DrawRadialLines(Can: TCanvas; Origin: TPoint; Info: TRadLineInfo);
var
  Count, Degrees, Increment: Integer;
  X, Y: Single;
begin
  Increment := 3600 div Info.Number;
  Can.Pen.Color := Info.Colour;
  Can.Pen.Style := Info.Style;
  Can.Pen.Width := Info.Width;

  Count := 0;
  Degrees := Info.AngleOffset;

  while Count < Info.Number do
  begin
    X := Sin(((Degrees / 10) * Deg_to_Rad));
    Y := Cos(((Degrees / 10) * Deg_to_Rad));
    Can.MoveTo(Origin.X, Origin.Y);
    Can.LineTo(Origin.X + Round(X * Info.Length), Origin.Y - Round(Y * Info.Length));

    Inc(Degrees, Increment);
    Inc(Count);
  end;
end;

procedure DrawPieSegment(Can: TCanvas; Origin: TPoint; Info: TSegmentInfo; AngleIdx, Amplitude: Integer);
var
  OldPenColour, OldBrushColour: TColor;
  X, Y, X1, Y1, X2, Y2: Integer;
  Angle: Single;
const
  PIEWIDTH = (360 / ROSE_SEGMENTS) / 2;
  DTOR = 1 / (360 / (2 * PI));
  COLOUR_OFFSET: array [0..4] of Byte = (0, 0, 0, 0, 0);
begin
  OldPenColour := Can.Pen.Color;
  OldBrushColour := Can.Brush.Color;

  Angle := (AngleIdx * (360 / ROSE_SEGMENTS)) * 10;

  Can.Brush.Color := Info.BaseColour;
  Can.Pen.Color   := Info.BaseColour;
  Can.Pen.Style   := psSolid;

  Amplitude := Amplitude + Info.Inner_Rad;

// coordinates relative to the origin
  X    := Round(Sin(((Angle / 10)) * DTOR) * Amplitude * 0.9);
  Y    := Round(Cos(((Angle / 10)) * DTOR) * Amplitude * 0.9);
  X1 := Round(Sin(((Angle / 10) - PIEWIDTH) * DTOR) * Amplitude);
  Y1 := Round(Cos(((Angle / 10) - PIEWIDTH) * DTOR) * Amplitude);
  X2 := Round(Sin(((Angle / 10) + PIEWIDTH) * DTOR) * Amplitude);
  Y2 := Round(Cos(((Angle / 10) + PIEWIDTH) * DTOR) * Amplitude);

  Can.Pen.Width := 2;

// draw segment
    Can.MoveTo(Origin.X,      Origin.Y);
    Can.LineTo(Origin.X + X1, Origin.Y - Y1);
    Can.MoveTo(Origin.X,      Origin.Y);
    Can.LineTo(Origin.X + X2, Origin.Y - Y2);

    Can.Pen.Color := clWhite;
    Can.Pen.Width := 1;

  Can.Arc(Origin.X - Amplitude, Origin.Y - Amplitude,  Origin.X + Amplitude, Origin.Y + Amplitude,
                    Origin.X + X2, Origin.Y - Y2, Origin.X + X1, Origin.Y - Y1);

    Can.FloodFill(Origin.X + X, Origin.Y - Y, Info.BaseColour, fsBorder);

  Can.Pen.Color := OldPenColour;
  Can.Brush.Color := OldBrushColour;
end;

procedure DrawFullSegment(Can: TCanvas; var Si: TSegmentInfo; AngleIndex: Integer);
var
  Bin: Integer;
begin
//  Initialise the first segment to the radius of the inner circle
  Si.Segment_Inner := Si.Inner_Rad;

  for Bin := 0 to 4 do
    DrawPieSubSegment(Can, Si, AngleIndex, Bin);
end;

(* This routine draws a single segment.  It uses TSegmentInfo to hold parameters
 * that are not regularly changed.  Dynamic parameters specific to the segment part
 * are supplied as parameters *)
procedure DrawPieSubSegment(Can: TCanvas; var Si: TSegmentInfo; AngleIdx, SpeedIdx: Integer);
var
  OldPenColour, OldBrushColour: TColor;
  FFX, FFY, XLI, YLI, XRI, YRI, XLO, YLO, XRO, YRO, Vector, VectorPlus, FFVector: Integer;
  Angle: Single;
  SegColour: TColor;
const
  PIEWIDTH = (360 / ROSE_SEGMENTS) / 2;
//  COLOURS: array [0..4] of TColor = ($707070, $606060, $404040, $202020, $000000);
  MINVECTOR = 5;
begin
  OldPenColour := Can.Pen.Color;
  OldBrushColour := Can.Brush.Color;


//  SegColour := Si.BaseColour + COLOURS[SpeedIdx];
  SegColour := Si.Colours[SpeedIdx] + Si.BaseColour;

  Angle := (AngleIdx * (360 / ROSE_SEGMENTS)) * 10;

  Can.Brush.Color := SegColour;
  Can.Pen.Color   := SegColour;
  Can.Pen.Style   := psSolid;

// -- coordinates relative to the origin ==

//  adjust the vector size of the segment to include the previous one
  Vector := Round((Si.Data[AngleIdx].Direction * (Si.Data[AngleIdx].Speed[SpeedIdx] / 100)) / Si.ScaleFactor);
  VectorPlus  := Vector + Si.Segment_Inner;                 // vector length plus previous one
  FFVector    := (Vector div 2) + Si.Segment_Inner;         // floodfill vector

  if Vector > 0 then
  begin

// Flood fill point, modwau betweem the inner and outer arcs
    FFX   := Round(Sin(((Angle / 10)) * DTOR) * (FFVector));
    FFY   := Round(Cos(((Angle / 10)) * DTOR) * (FFVector));

// for inner arc and lines
    XLI := Round(Sin(((Angle / 10) - PIEWIDTH) * DTOR) * Si.Segment_Inner); // Inner L
    YLI := Round(Cos(((Angle / 10) - PIEWIDTH) * DTOR) * Si.Segment_Inner);
    XRI := Round(Sin(((Angle / 10) + PIEWIDTH) * DTOR) * Si.Segment_Inner); // Inner R
    YRI := Round(Cos(((Angle / 10) + PIEWIDTH) * DTOR) * Si.Segment_Inner);

// for outer arc and lines
    XLO := Round(Sin(((Angle / 10) - PIEWIDTH) * DTOR) * VectorPlus); // Outer L
    YLO := Round(Cos(((Angle / 10) - PIEWIDTH) * DTOR) * VectorPlus);
    XRO := Round(Sin(((Angle / 10) + PIEWIDTH) * DTOR) * VectorPlus); // Outer R
    YRO := Round(Cos(((Angle / 10) + PIEWIDTH) * DTOR) * VectorPlus);

    if Vector < MINVECTOR then
      Can.Pen.Width := Vector
    else
      Can.Pen.Width := 2;

// draw segment sides
    Can.MoveTo(Si.Origin.X + XLI, Si.Origin.Y - YLI);
    Can.LineTo(Si.Origin.X + XLO, Si.Origin.Y - YLO);
    Can.MoveTo(Si.Origin.X + XRI, Si.Origin.Y - YRI);
    Can.LineTo(Si.Origin.X + XRO, Si.Origin.Y - YRO);

//  draw inner arc
    Can.Arc(Si.Origin.X - Si.Segment_Inner, Si.Origin.Y - Si.Segment_Inner,   Si.Origin.X + Si.Segment_Inner, Si.Origin.Y + Si.Segment_Inner,
            Si.Origin.X + XRI,              Si.Origin.Y - YRI,                Si.Origin.X + XLI,              Si.Origin.Y - YLI);

//  draw outer arc
    Can.Arc(Si.Origin.X - VectorPlus,  Si.Origin.Y - VectorPlus,  Si.Origin.X + VectorPlus,  Si.Origin.Y + VectorPlus,
            Si.Origin.X + XRO,        Si.Origin.Y - YRO,        Si.Origin.X + XLO,        Si.Origin.Y - YLO);

//  fill the segment
    if Vector > MINVECTOR then
      Can.FloodFill(Si.Origin.X + FFX, Si.Origin.Y - FFY, SegColour, fsBorder);

// keep the size of the segment
    Si.Segment_Inner := VectorPlus;
  end;
  Can.Pen.Color := OldPenColour;
  Can.Brush.Color := OldBrushColour;
end;

procedure TextAligned(Can: TCanvas; X, Y: Integer; Txt: String; Align: TAlignment);
var
  W: Integer;
begin
  case Align of
    taLeftJustify:  Can.TextOut(X, Y, Txt);
    taRightJustify: begin
                      W := Can.TextWidth(Txt);
                      X := X - W;
                      Can.TextOut(X, Y, Txt);
                    end;
    taCenter:       begin
                      W := Can.TextWidth(Txt);
                      X := X - (W div 2);
                      Can.TextOut(X, Y, Txt);
                    end;
  end;
end;

procedure DrawCompassPoints(Can: TCanvas; Origin: TPoint; Dia: Integer; BG: TColor);
var
  X, Y, Idx, Deg, OffI, OffO: Integer;
  OldFontName: String;
const
  Points: array [0..15] of String = ('N', 'NNE', 'NE', 'ENE',
                                     'E', 'ESE', 'SE', 'SSE',
                                     'S', 'SSW', 'SW', 'WSW',
                                     'W', 'WNW', 'NW', 'NNW');
  Offset: Integer = 18;
begin
  Deg := 0;
  Idx := 0;
  Can.Brush.Color := BG;
  Can.Font.Color := clWhite;
  OldFontName := Can.Font.Name;
  Can.Font.Name := 'Monospace821 BT';

  case Dia of
  0..49:    Can.Font.Size := 8;
  50..99:   Can.Font.Size := 9;
  100..149: Can.Font.Size := 10;
  else
    Can.Font.Size := 12;
  end;

  OffI := 10;
  while Deg < 3600 do
  begin
    case (Deg mod 900) of // correct the location
    0:    begin  // 0, 90, 180, 270
            if Deg = 0 then
            begin
              OffI := 10;
              OffO := 7;
            end else
            begin
              OffI := 15;
              OffO := 25;
            end;
          end;   // 22.5, 12.5, 202.5, 292.5
    225:  begin
            OffI := 33;
            OffO := 15;
          end;
    450:  begin  // 45, 135, 225, 315
            OffI := 15;
            OffO := 15;
          end;
    675:  begin  // 67.5, 157.5, 247.5, 337.5
            OffI := 33;
            OffO := 37;
          end;
    end;

//  inner scale NSEW etc
    X   := Round(Sin(((Deg - OffI) / 10) * DTOR) * Dia);
    Y   := Round(Cos(((Deg - OffI) / 10) * DTOR) * Dia);
    Can.Font.Orientation := Round(-(Deg div 10) * 10);
    Can.TextOut(Origin.X + X, Origin.Y - Y, Points[Idx]);

//  outer scale degrees
    X   := Round(Sin(((Deg - OffO) / 10) * DTOR) * (Dia + Offset));
    Y   := Round(Cos(((Deg - OffO) / 10) * DTOR) * (Dia + Offset));
    Can.Font.Orientation := Round(-(Deg div 10) * 10);
    Can.TextOut(Origin.X + X, Origin.Y - Y, FloatToStr(Round(Deg / 10)));

    Deg := Deg + 225;
    Inc(Idx);
  end;
  Can.Font.Orientation := 0;
end;

procedure DispayResultsInfo(Can: TCanvas; Si: TSegmentInfo);
var
  Count, Minutes, Line: Integer;
  ScaleIncrement, ScaleMultiplier: Single;
  BG: TColor;
  UnitText: String;
const
  VINCREMENT = 20;
  TOP = 30;
  WTOP = 15;
  WLEFT = 630;
  WBOT = 580;
  WCENTRE = WLEFT + 95;
  WRIGHT = WLEFT + 100;

  function GetY(L: Integer): Integer;
  begin
    Result := TOP + ((L - 1) * VINCREMENT); ;
  end;
begin
    Can.Pen.Color := clWhite;
    Can.Brush.Color := $80C0C0;
    Can.Rectangle(WLEFT - 20, WTOP, WRIGHT + 110, WBOT - 10);

    Can.Font.Size := 11;
    Can.Font.Name := 'Arial';
    Can.Font.Color := clBlack;

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

// ------------------------------------------------------------
    Line := 1;

//  Sample information
    TextAligned(Can, WCENTRE, GetY(Line), 'Sample Information', taCenter);
    Inc(Line, 2);
    TextAligned(Can, WLEFT, GetY(Line), 'Total Samples', taLeftJustify);
    TextAligned(Can, WRIGHT, GetY(Line), IntToStr(Si.pAxes^.Data_Samples), taLeftJustify);
    Inc(Line, 1);
    TextAligned(Can, WLEFT, GetY(Line), 'Start Date:', taLeftJustify);
    TextAligned(Can, WRIGHT, GetY(Line), DateToStr(Si.pAxes^.StartDate + AT_DATE_OFFSET), taLeftJustify);
    Inc(Line, 1);
    TextAligned(Can, WLEFT, GetY(Line), 'End Date:', taLeftJustify);
    TextAligned(Can, WRIGHT, GetY(Line), DateToStr(Si.pAxes^.EndDate + AT_DATE_OFFSET), taLeftJustify);
    Inc(Line, 1);
    TextAligned(Can, WLEFT, GetY(Line), 'Days:', taLeftJustify);
    TextAligned(Can, WRIGHT, GetY(Line), IntToStr(Si.pAxes^.EndDate - Si.pAxes.StartDate + 1), taLeftJustify);

// ------------------------------------------------------------

//  wind amount section (percentage)
    Inc(Line, 2);
    TextAligned(Can, WCENTRE, GetY(Line), 'Wind Amplitude Scale', taCenter);

    ScaleIncrement := (Si.TotalDataSamples * (Si.ScaleMax / 100)) / 5;
    Inc(Line, 2);

    for Count := 1 to 5 do
    begin
      Minutes := Round(ScaleIncrement * Count);
      TextAligned(Can, WLEFT + 45, GetY(Line), IntToStr(Round((Si.ScaleMax / 5)) * Count) + '% = ', taRightJustify);

      if Minutes > SAMPLES_PER_DAY then
      begin
//        TextAligned(Can, 695, GetY(Line), IntToStr(Minutes), taRightJustify);
        TextAligned(Can, WLEFT + 130, GetY(Line), Format('%5.1f Days', [Minutes / SAMPLES_PER_DAY]), taRightJustify);

      end else
      begin
        TextAligned(Can, WLEFT + 80, GetY(Line), IntToStr(Minutes), taRightJustify);
        TextAligned(Can, WRIGHT + 85, GetY(Line), Format('%s', [ToHrsAndMins(Round(ScaleIncrement * Count))]), taRightJustify)
      end;
      Inc(Line);
    end;

    Inc(Line);
    TextAligned(Can, WCENTRE, GetY(Line), 'Total Time:', taCenter);
    Inc(Line);
    TextAligned(Can, WCENTRE, GetY(Line), Format('(%f %%) %d Minutes', [(Si.TotalActiveWind / Si.TotalDataSamples) * 100, Si.TotalActiveWind]), taCenter);

// ------------------------------------------------------------

//  wind speed colour scale
    Inc(Line, 2);
    TextAligned(Can, WCENTRE, GetY(Line), 'Wind Speed', taCenter);

    Can.Pen.Width := 2;
    Inc(Line, 2);
    BG := Can.Brush.Color;
    for Count := 0 to Si.ColursInUse do
    begin
      Can.Brush.Color := Si.Colours[Count] + Si.BaseColour;
      Can.Rectangle(WLEFT + 10, GetY(Line), WLEFT + 30, GetY(Line) + 20);
      Can.Brush.Color := BG;
      TextAligned(Can, WLEFT + 80,  GetY(Line), FloatToStrF(((Si.SpeedStep * Count) * ScaleMultiplier), ffFixed, 4, 1), taRightJustify);
      TextAligned(Can, WLEFT + 92,  GetY(Line), 'to', taCenter);
      TextAligned(Can, WLEFT + 140, GetY(Line), FloatToStrF(((Si.SpeedStep * Count + 1) * ScaleMultiplier), ffFixed, 4, 1), taRightJustify);
      TextAligned(Can, WRIGHT + 80, GetY(Line), UnitText, taRightJustify);
      Inc(Line);
    end;
end;

function ToHrsAndMins(Period: Integer): String;
var
  Hrs, Mins, Days: Word;
begin
  Days := Period div SAMPLES_PER_DAY;
  if Days > 0 then
    Period := Period - (Days * SAMPLES_PER_DAY);

  Hrs := Period div 60;
  Mins := Period - (Hrs * 60);

  if Days > 0 then
    Result := Format('%3d Days + %2.2d:%2.2d Hrs', [Days, Hrs, Mins])
  else
    Result := Format('Minutes (%2.2d:%2.2d)', [Hrs, Mins]);
end;

procedure MakeColours(var Si: TSegmentInfo);
var
  Count: Integer;
  Step, Value: TColor;
const
  START = $70;
begin
  Step := START div (Si.ColursInUse + 1);
  Value := (Si.ColursInUse + 1) * Step;

  for Count := 0 to 4 do
  begin

    if Count <= Si.ColursInUse then
      Si.Colours[Count] := (Value shl 16) or (Value shl 8) or Value shl 0
    else
      Si.Colours[Count] := 0 ;

    Dec(Value, Step);
  end;
end;

procedure Plot_Rose(Ax: TAxes; Img: TImage; Settings: TMeasurementSettings; Si: TSegmentInfo);
var
  Cnt, ScaleMarkingWidth,ScaleMarkingHeight: Integer;
  ScaleMarking: String;
  Rli: TRadLineInfo;
  FillColour, BGColour: TColor;
  Deg: Byte;
const
  DTOR = 1 / (360 / (2 * PI));
begin
  Si.Origin := Point((Img.Width div 2) - 140, Img.Height div 2);
  __ORIGIN            := Si.Origin;

  Si.BaseColour := Settings.GraphCol_ROSE;
  FillColour  := $404040;
  BGColour    := Settings.GraphCol_BG;
  MakeColours(Si);

  Si.UnitIndex        := Settings.Wind; // scale unit multiplier index
  Si.Inner_Rad        := ROSE_INNER_DIA;
  Si.Outer_Rad        := (Img.Height div 2) - 50;
  Si.TotalDataSamples := Ax.Data_Samples;

  MakeRadialScale(Si);

// clear graph area
  Img.Canvas.Brush.Color := FillColour;
  Img.Canvas.Pen.Color  := clwhite;
  Img.Canvas.FillRect(Rect(0, 0, Img.Width, Img.Height));

// set drawing parameters and draw area perimeter lines
  Img.Canvas.Pen.Width := 1;
  Img.Canvas.Pen.Color := clWhite;
  Img.Canvas.Brush.Color := BGColour;
  Img.Canvas.Pen.Style := psSolid;
  DrawCircle(Img.Canvas, __Origin, Si.Outer_Rad); // draw filled rose perimeter
// draw compass points i.e. N S E W etc
  DrawCompassPoints(Img.Canvas, __Origin, Si.Outer_Rad + 25, FillColour);
// Plot the data
  Deg := 0;
  while Deg < ROSE_SEGMENTS do
  begin
    DrawFullSegment(Img.Canvas, Si, Deg);
    Inc(Deg);
  end;

// draw the segment separators
  with Rli do
  begin
    Number      := 16;
    AngleOffset := 112;
    Length      := Si.Outer_Rad - 4;
    Style       := psSolid;
    Width       := 5;
    Colour      := BGColour;
  end;
  DrawRadialLines(Img.Canvas, __Origin, Rli);

// draw the radial graticule lines
  with Rli do
  begin
    AngleOffset := 0;
    Style       := psDot;
    Width       := 1;
    Colour      := BGColour + $606060;
  end;
  DrawRadialLines(Img.Canvas, __Origin, Rli);

  Si.ScaleFactor := (Si.Outer_Rad - Inner_Rad) / Si.ScaleMax;

  Cnt := 0;
  Img.Canvas.Font.Name := 'Arial';
  while Cnt <= Si.ScaleMax do
  begin

    ScaleMarking := Format('%d%%', [Cnt]);
    ScaleMarkingWidth  := Img.Canvas.TextWidth(ScaleMarking);
    ScaleMarkingHeight := Img.Canvas.TextHeight(ScaleMarking);

//  draw scale concentric circles and add text
    if Cnt = 0 then
    begin
      Img.Canvas.Brush.Style := bsSolid;
      Img.Canvas.Font.Size := 12;
      Img.Canvas.Font.Color := clWhite
    end else
    begin
      Img.Canvas.Brush.Style := bsClear;
      Img.Canvas.Font.Size := 9;
      Img.Canvas.Font.Color := clBlack;
    end;

    if Cnt = Si.ScaleMax then
    begin
      Img.Canvas.Pen.Style := psSolid;
      Img.Canvas.Pen.Width := 5;
    end;

    DrawCircle(Img.Canvas, __Origin, Round(Si.Inner_Rad + (Cnt * Si.ScaleFactor)));

    Img.Canvas.Font.Color := clWhite;

    if Cnt = 0 then
    begin
      Img.Canvas.TextOut(__Origin.X - (ScaleMarkingWidth div 2), __Origin.Y - (ScaleMarkingHeight div 2) - 2, ScaleMarking);
    end else
    begin
      Img.Canvas.TextOut(__Origin.X + Round(Si.Inner_Rad + (Cnt * Si.ScaleFactor) - 5) - ScaleMarkingWidth, __Origin.Y - (ScaleMarkingHeight div 2) - 5, ScaleMArking);
    end;
    Inc(Cnt, Si.TickScaleIncrement);
  end;
  Img.Canvas.Brush.Style := bsSolid;

  DispayResultsInfo(Img.Canvas, Si);

end;

end.
