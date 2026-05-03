unit Log;

interface

// This form displays either the raw data from the logger or the rssi informaton for each sample

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IOUtils, System.Math,
  Vcl.ExtCtrls, LoggerLib, Average, ATUtils;

const
  XBorder = 50;
  YBorder = 50;
  IMG_X_OFFSET: Integer = 10;
  IMG_Y_OFFSET: Integer = 10;
  IMG_WIDTH:    Integer = 150;
  IMG_HEIGHT:   Integer = 22;

  PPU = 4; // pixels per unit (1 dB}

  TITLES: array [0..8] of String = (' ',
                                    'Received signal strength indication',
                                    ' ',
                                    '                          ',
                                    'Total Samples:',
                                    'Valid Samples:',
                                    'Out of Range Samples:',
                                    'Average RSSI (dBm):',
                                    ' ');


type

  Trssi = record
    RSSI: array [0..1460] of ShortInt;
    Time: array [0..1460] of DWord;
    TotalSamples: Integer;
    ValidSamples: Integer;
    OutOfRangeSamples: Integer;
    AverageRSSI: Single;
    Min, Max: SmallInt;
    YMin, YMax: Integer;
  end;

  TLogMode = (lmText, lmGraph);

  TImageBuffer = class
    constructor Create(Width, Height: Integer);
    destructor Destroy;
    procedure SetImage(R: TRect; can: TCanvas);
    procedure GetImage(can: TCanvas);
    procedure Free;
  private
    FBuffer: array of TColor;
    FSize: Integer;
    FInitialised, FHasIMage: Boolean;
    FPixX, FPixY, FPixW, FPixH: Integer;
  end;

  TLogForm = class(TForm)
    Log: TListBox;
    InfoPanel: TPanel;
    Info: TPaintBox;
    procedure LogClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
//    procedure LogData(Control: TWinControl; Index: Integer; var Data: string);
    procedure InfoPaint(Sender: TObject);
    procedure PosChange(var Msg: TWmWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure InfoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Mode: TLogMode;
    rssiResults: Trssi;
    resultsBox: TPanel;
    ImageBuffer: TImageBuffer;
    procedure DrawRSSIGraph(Pb: TPaintBox; var Results: Trssi);
    procedure DrawValueRectangle(R: TRect; Vdx, Vdy, OffT: Integer; PixCol: TColor; Text: String);

    { Private declarations }
  public
    { Public declarations }
  end;


var
  LogForm: TLogForm;

procedure LoadLog(FileName: String; WinName: String; MemoWidth: Integer = 500; LineNo: Boolean = false; Mode: TLogMode = lmText); overload;
procedure LoadLog(FileName: String; WinName: String; MemoWidth: Integer = 500; Data: String = ''); overload;

procedure FreeLog();


implementation

{$R *.dfm}

uses Defs;


constructor TImageBuffer.Create(Width, Height: Integer);
var
  Idx: Integer;
begin
  Inc(Width);
  Inc(Height);
  FSize := Width * Height;
  SetLength(FBuffer, FSize);
  FInitialised := True;
  FHasImage := False;

  for Idx := 0 to FSize - 1 do
    FBuffer[Idx] := clWhite;

end;

destructor TImageBuffer.Destroy;
begin
  SetLength(FBuffer, 0);
end;

procedure TImageBuffer.Free;
begin
  Destroy;
end;

procedure TImageBuffer.SetImage(R: TRect; can: TCanvas);
var
  Idx, xx, yy: Integer;
begin
  if FInitialised then
  begin
//  ms := GetTickCount;
    if FHasImage then
      GetImage(can);

    FHasImage := True;
    FPixX := R.Left;
    FPixY := R.Top;
    FPixW := R.Width;
    FPixH := R.Height;

    Idx := 0;

    for yy := R.Top to R.Top + R.Height - 1 do
      for xx := R.Left to R.Left + R.Width - 1 do
      begin
        if Idx < FSize then
        begin
          FBuffer[Idx] := can.Pixels[xx, yy];
          Inc(Idx);
        end;
      end;
  end;
end;

procedure TImageBuffer.GetImage(can: TCanvas);
var
  Idx, x, y: Integer;
begin
  if FInitialised then
  begin
    Idx := 0;
    if FHasImage then
    begin
      for y := FPixY to FPixY + FPixH - 1 do
        for x := FPixX to FPixX + FPixW - 1 do
        begin
          can.Pixels[x, y] := FBuffer[Idx];
          Inc(Idx);
        end;
    end;
    FHasImage := False;
  end
end;



// keep window on on screen
procedure TLogForm.PosChange(var Msg: TWmWindowPosChanging) ;
begin
//  limit movement to left
  if Msg.WindowPos.x < 10 then
    Msg.WindowPos.x := 10;

//  limit movement to right
  if (Msg.WindowPos.x + LogForm.Width) > (Screen.Width - 10) then
    Msg.WindowPos.x := Screen.Width - 10 - LogForm.Width;

//  limit movement up
  if Msg.WindowPos.y < 10 then
    Msg.WindowPos.y := 10;

//  limit movement to down
  if (Msg.WindowPos.y + LogForm.Height) > (Screen.Height - 75) then
    Msg.WindowPos.y := Screen.Height - 75 - LogForm.Height;

  Msg.Result := 0;
end;

  function MakeYPos(value, PixelsPerValue, offset: Integer): Integer;
  begin
    value := (120 - abs(value));  // 0 - 120
    result := offset - (value * PixelsPerValue);
  end;

procedure ShowLog(LogText: String; WinName: String; Width: Integer = 500);
begin
//  AddToLog(LogText);
  LogForm.Width := width;
  LogForm.Caption := WinName;

  LogForm.ShowModal;
  FreeLog();
end;

procedure LoadLog(FileName: String; WinName: String; MemoWidth: Integer = 500; Data: String = ''); overload;
var
  Sl: TStringList;
  CurLine: String;
  LineNo, i: Integer;
begin
  if Data.Length > 0 then
  begin
    Application.CreateForm(TLogForm, LogForm);
    Sl := TStringList.Create;

    try
      LogForm.Log.Visible := True;
      LogForm.InfoPanel.Width := LogForm.Width - 12;
      LogForm.Info.Width := LogForm.InfoPanel.Width - 8;

      LogForm.Caption := WinName;

      Sl.Text := Data;

      if Sl.Count > 1 then
      begin
//      enter the data into the listbox
        i := 0;
        while i < Sl.Count do
        begin
          CurLine := Format('%s Line: %-4d   %s', [' ', i + 1, Sl.Strings[i]]);
          LogForm.Log.AddItem(CurLine, nil);
          Inc(i);
        end;
      end;

      LogForm.Width := MemoWidth;
      LogForm.ShowModal;
    finally
      Sl.Free;
      LogForm.Release;
    end;
  end;
end;

// Create the form, set up the according to text or graphics and load the data.
procedure LoadLog(FileName: String; WinName: String; MemoWidth: Integer = 500; LineNo: Boolean = false; Mode: TLogMode = lmText); overload;
var
  Sl: TStringList;
  Len, i: Integer;
  Fmt, CurLine: String;
  Fs: TFieldSet;
  NoData: Boolean;
begin
  Sl := nil;

  if TFile.Exists(FileName) then
  begin
    if LogForm = nil then
    begin
      Application.CreateForm(TLogForm, LogForm);

      LogForm.Mode := Mode;

      if Mode = lmGraph then
      begin
//      set up the graphic area
        LogForm.Mode := lmGraph;
        LogForm.Log.Visible := False;
        LogForm.InfoPanel.Align := alClient;
        LogForm.Width := 1440 + (XBorder * 2);
        LogForm.Caption := TITLES[0];

        try
          Sl := TStringList.Create;
          LogForm.Caption := WinName;
          Sl.LoadFromFile(FileName);

//        clear RSSI array
          i := 0;
          while i < Length(LogForm.rssiResults.RSSI) do
          begin
            LogForm.rssiResults.RSSI[i] := 0;
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
            // load the rssi array
            while i < Sl.Count do
            begin
              CSVToText(Sl.Strings[i], Fs, ' ');
              LogForm.rssiResults.Time[i - 1] := StrToInt('$' + Fs.Fields[0]);

              if Fs.Count = 11 then
                LogForm.rssiResults.RSSI[i - 1] := StrToInt('$' + Fs.Fields[10]);

              Inc(i);
            end;
          end;
        finally
          Sl.Free;
        end;

      end else
      begin
//      set up the text area
        LogForm.Log.Visible := True;
        LogForm.InfoPanel.Width := LogForm.Width - 12;
        LogForm.Info.Width := LogForm.InfoPanel.Width - 8;

        NoData := False;

        try
          Sl := TStringList.Create;
          LogForm.Caption := WinName;

          Sl.LoadFromFile(FileName);
          if Sl.Count > 0 then
          begin
            Len := Trunc(Log10(Sl.Count)) + 1;

            if LineNo then
              Fmt := Format('Line %d - %s', [Len, '%s'])
            else
              Fmt := '%s';

//        fill in the listbox
            i := 0;
            if LineNo then
            begin
              Fmt := Format('Line: %%%dd %%s', [Len]);
              while i < Sl.Count do
              begin
                CurLine := Format(Fmt, [i, Sl.Strings[i]]);
                LogForm.Log.AddItem(CurLine, nil);
                Inc(i);
              end;
            end;
          end;

          LogForm.Width := MemoWidth;

//      show the form
        finally
          Sl.Free;
        end;
      end;

      if not NoData then
        LogForm.ShowModal // select the first line in the onactivate event
      else
        MessageDlg('Ther is no RSSI information to display', mtWarning, [mbOK], 0);

      FreeLog();
    end;
  end;
end;

procedure FreeLog();
begin
  if LogForm <> nil then
  begin
    LogForm.Release;
    LogForm := nil;
  end;
end;

procedure TLogForm.FormActivate(Sender: TObject);
begin
  LogForm.Left := (Screen.Width - LogForm.Width) div 2;
end;

procedure TLogForm.DrawRSSIGraph(Pb: TPaintbox; var Results: Trssi);
var
  x, y, th, ypos, yval, ytop, Timewidth, TimeHeight: Integer;
  s, fs: String;
const
  TICKSIZE = 5;
  TTLLEFT = 1000;
  TTLTOP = 50;
begin
(* Converts real value 0 to -120 into a Y value.  PixelsPerValue
   is the number of pixels used to represent one unit of value *)

      Results.TotalSamples := 0;
      Results.ValidSamples := 0;
      Results.OutOfRangeSamples := 0;
      Results.AverageRSSI := 0;

//    Clear graph area
      Pb.Canvas.Brush.Color     := $ffd0d0;
      Pb.Canvas.Brush.Color     := $ffffff;
      Pb.Canvas.FillRect(Bounds(0, 0, Pb.Width, Pb.Height));

//    Draw axes
      Pb.Canvas.Pen.Color := clBlack;

//    -- Draw X Axis -----------------------------------------------------------
      Pb.Canvas.MoveTo(XBorder,         Pb.Height - YBorder);
      Pb.Canvas.LineTo(XBorder + 1440,  Pb.Height - YBorder);

      x := 0;
      y := Pb.Height - YBorder;
      Pb.Canvas.Font.Orientation := 90;
      Pb.Canvas.Pen.Width := 1;
      Pb.Canvas.Font.Orientation := 900;
      TimeWidth   := Pb.Canvas.TextWidth('00:00');
      TimeHeight  := Pb.Canvas.TextHeight('00:00');
      ytop := MakeYPos(0, PPU, Pb.Height - YBorder);

//    draw ticks and text
      while x <= 1440 do
      begin
//      Draw normal ticks
        Pb.Canvas.MoveTo(x + XBorder, Pb.Height - YBorder);
        Pb.Canvas.LineTo(x + XBorder, Pb.Height - YBorder + TICKSIZE);

        if x mod 60 = 0 then
        begin
//        draw hour tick
          Pb.Canvas.Pen.Width := 4;
          Pb.Canvas.MoveTo(x + XBorder + 0, Pb.Height - YBorder);
          Pb.Canvas.LineTo(x + XBorder + 0, Pb.Height - YBorder + TICKSIZE);
          Pb.Canvas.Pen.Width := 1;

//        draw v scale lines
          Pb.Canvas.Pen.Style := psDot;
          Pb.Canvas.MoveTo(XBorder + x,  Pb.Height - YBorder);
          Pb.Canvas.LineTo(XBorder + x,  ytop);
          Pb.Canvas.Pen.Style := pssOLID;

          // draw time
          Pb.Canvas.TextOut(x + XBorder - (TimeHeight div 2), y + TimeWidth + 10, Format('%02.2d:00', [x div 60]));
        end;

        Inc(x, 15);  // 15 minute intervals
      end;

      Pb.Canvas.Font.Orientation := 0;

//    -- Draw Y Axis -----------------------------------------------------------
      Pb.Canvas.MoveTo(XBorder, Pb.Height - YBorder);
      Pb.Canvas.LineTo(XBorder, ytop);
      yval := -120;

      while yval <= 0 do
      begin
        ypos := MakeYPos(yval, PPU, Pb.Height - YBorder);
//      draw y ticks
        Pb.Canvas.MoveTo(XBorder,     ypos);
        Pb.Canvas.LineTo(XBorder - TICKSIZE, ypos);
//      draw y text
        Pb.Canvas.TextOut(XBorder - 40, ypos - (TimeHeight div 2), Format('%03d', [yval]));

//      draw h scale lines
        if yval > -120 then
        begin
          Pb.Canvas.Pen.Style := psDot;
          Pb.Canvas.MoveTo(XBorder,         ypos);
          Pb.Canvas.LineTo(XBorder + 1440,  ypos);
          Pb.Canvas.Pen.Style := psSolid;
        end;

        if yval = -60 then
        begin
          Pb.Canvas.TextOut(XBorder - 42, ypos - 28, 'dBm');
        end;

        Inc(yval, 10);
      end;

//    draw receive threshold line (-90dBm)
      ypos := MakeYPos(-90, PPU, Pb.Height - YBorder);
      Pb.Canvas.Pen.Style := psDash;
      Pb.Canvas.Pen.Color := clRed;
      Pb.Canvas.MoveTo(XBorder, ypos);
      Pb.Canvas.LineTo(XBorder + 1440, ypos);
      Pb.Canvas.Pen.Style := psSolid;
      Pb.Canvas.Pen.Color := clBlack;

      Pb.Canvas.Font.Size := 8;

//    -- Draw graph and collect rssi information -------------------------------

      x := 0;
      Pb.Canvas.Pen.Width := 2;
      Results.Min := 0;
      Results.Max := -120;

      Results.AverageRSSI := Results.RSSI[0];

      while x < 1440 do
      begin
        if Results.RSSI[x] < 0 then
        begin
          Inc(Results.TotalSamples);

          ypos := MakeYPos(Results.RSSI[x], PPU, Pb.Height - YBorder);

          if Results.RSSI[x] < Results.Min then
            Results.Min := Results.RSSI[x];

          if Results.RSSI[x] > Results.Max then
            Results.Max := Results.RSSI[x];

          if Results.RSSI[x] >= -90 then
          begin
            Pb.Canvas.Pen.Color := clGreen;
            Pb.Canvas.Brush.Color := clGreen;
            Inc(Results.ValidSamples);
          end else
          begin
            Pb.Canvas.Pen.Color := clRed;
            Pb.Canvas.Brush.Color := clRed;
            Inc(Results.OutOfRangeSamples);
          end;

          Results.AverageRSSI := (Results.RSSI[x] + Results.AverageRSSI) / 2;
//        draw data points as rectangular dots
          Pb.Canvas.Rectangle(x + XBorder - 2, ypos - 2, x + XBorder + 2, ypos + 2);
        end;
        Inc(x);
      end;

      Results.Min := RoundUpDown(Results.Min, rdDown, 0);
      Results.Max := RoundUpDown(Results.Max, rdUp,   0);
      Results.YMin := MakeYPos(Results.Min, PPU, Pb.Height - YBorder);
      Results.YMax := MakeYPos(Results.Max, PPU, Pb.Height - YBorder);

//    -- Header Info -----------------------------------------------------------

      Pb.Canvas.Font.Name := 'Monospac821 BT';
      Pb.Canvas.Font.Size := 14;
      Pb.Canvas.Brush.Color := $C0C0FF;
      y := 0;
      ypos := TTLTOP;
      s:= ' ';
      fs := ' %35s ';

//    -- Footer Info------------------------------------------------------------

      while y < 9 do
      begin
        th := Pb.Canvas.TextHeight('A');
        case y of
        3: fs := ' %22s %s ';
        4: s := Format('%5d',   [Results.TotalSamples + 1]);
        5: s := Format('%5d',   [Results.ValidSamples + 1]);
        6: s := Format('%5d',   [Results.OutOfRangeSamples]);
        7: s := Format('%3.1f', [Results.AverageRSSI]);
        8: s := '     ';
        end;
        Pb.Canvas.TextOut(TTLLEFT + 25, ypos, Format(fs, [TITLES[y], s]));
        Inc(ypos, th);
        Inc(y);
//      change font size
        if y = 3 then
        begin
          Pb.Canvas.Font.Size := 10;
          Inc(ypos, 10);
        end;
      end;
end;

procedure TLogForm.FormCreate(Sender: TObject);
begin
  ImageBuffer := TImageBuffer.Create(IMG_WIDTH, IMG_HEIGHT);
end;

procedure TLogForm.FormDestroy(Sender: TObject);
begin
  ImageBuffer.Free;
end;

(*
   OnClick scans pixels around the cursor point looking for
   a red or green dot which closely matches the
   calculated and actual rssi values.  When found it displays
   the actual value, draws a box around it and saves the image
   containing the box jst drawn.  When another location is clicked
   on it removes the existing value and box before drawing the new
   one
*)
procedure TLogForm.InfoClick(Sender: TObject);
var
  xx, yy, ydB, ddB, Idx, tw, tp: Integer;
  pcol: TColor;
  found: Boolean;
  R: TRect;
  mp: TPoint;
  Text: String;
const
  WIN = 5;
begin
  mp := Info.ScreenToClient(point(Mouse.CursorPos.X, Mouse.CursorPos.y));

  ydB := -(120 - (((Info.Height - YBorder) - mp.Y) div 4));

  found := false;
  Info.Canvas.Brush.Color := clBlack;
//  scan the area around the click point looking for a red or green dot
  for yy := mp.Y - WIN to mp.Y + WIN do
  begin
    for xx := mp.X - WIN to mp.X + WIN do
    begin
      Idx := xx - XBorder;
      pcol := Info.Canvas.Pixels[xx, yy];
      if (pcol = clRed) or (pcol = clGreen) then
      begin
        ddB := abs(ydB - LogForm.rssiResults.RSSI[Idx]);
        if ddB < 2 then
        begin
          found := true;
          break;
        end;
      end;
    end;
    if found then
      break;
  end;

  if found then
  begin
    mp.X := xx;
    mp.Y := yy;

//    save the image before anything is drawn, used to erase the information
//    ImageBuffer.SetImage(Bounds(mp.X - IMG_X_OFFSET, mp.Y - IMG_Y_OFFSET, IMG_WIDTH, IMG_HEIGHT), Info.Canvas);

// create the data string and find its length
    Info.Canvas.Font.Color := clBlack;
    Info.Canvas.Pen.Color := clBlack;
    Info.Canvas.Brush.Color := clBlack;
    Info.Canvas.Font.Size := 10;

    Text := Format('%4d dB %s', [LogForm.rssiResults.RSSI[Idx], TimeToStr((1 / 86400) * LogForm.rssiResults.Time[Idx])]);

//   draw the frame around the click point
    if Info.Width < (mp.X + IMG_WIDTH) then
    begin
      // --> DOT RIGHT <--
      R := Bounds(mp.X + IMG_X_OFFSET - IMG_WIDTH, mp.Y - IMG_Y_OFFSET, IMG_WIDTH, IMG_HEIGHT);
      ImageBuffer.SetImage(R, Info.Canvas);
      DrawValueRectangle(R, xx, yy, -IMG_WIDTH + 10, pcol, Text);
    end else
    begin
      // --> DOT LEFT <--
      R := Bounds(mp.X - IMG_X_OFFSET, mp.Y - IMG_Y_OFFSET, IMG_WIDTH, IMG_HEIGHT);
      ImageBuffer.SetImage(R, Info.Canvas);
      DrawValueRectangle(R, xx, yy, 0, pcol, Text);
    end;
  end;
end;

procedure TLogForm.DrawValueRectangle(R: TRect; Vdx, Vdy, OffT: Integer; PixCol: TColor; Text: String);
begin

// erase image area
  Info.Canvas.Pen.Width := 1;
  Info.Canvas.Brush.Color := clWhite;
  Info.Canvas.Rectangle(R);

// redraw the value dot
  Info.Canvas.Brush.Color := PixCol;
  Info.Canvas.Rectangle(Bounds(Vdx, Vdy, 5, 5));

// draw border rectangle
  Info.Canvas.Brush.Color := clBlack;
  Info.Canvas.FrameRect(R);

// Draw the rssi level and time text
  Info.Canvas.Brush.Color := clWhite;
  Info.Canvas.TextOut(Vdx + OffT + 5, Vdy - 8, Text);

end;

// paints the paintbox image.  No OnPaint event = no image
// see the help
procedure TLogForm.InfoPaint(Sender: TObject);
begin
  case Mode of
    lmText:   if LogForm.Log.Count > 1 then
              begin
                logForm.Log.ItemIndex := 1;
                LogForm.Log.Selected[1] := True;
                LogForm.LogClick(nil);
              end;
    lmGraph:  DrawRSSIGraph(LogForm.Info, LogForm.rssiResults);
  end;
end;

procedure TLogForm.LogClick(Sender: TObject);
var
  Data: TFieldSet;
  Item, Val, X, Y, TextHeight: Integer;
  s, FieldTitle: String;
  rssi: SmallInt;
const
  Titles: array [0..9] of String = ('Sample Time',
                                    'Average Wind Dir',
                                    'Average Wind Speed',
                                    'Peak Wind Speed',
                                    'Temperature',
                                    'Humidity',
                                    '',
                                    '',
                                    '',
                                    'Barometric Pressure'
                                    );

  Post: array [0..9] of String =   ('',
                                    #176,
                                    'MPH',
                                    'MPH',
                                    #176 + 'F',
                                    '% RH',
                                    '',
                                    '',
                                    '',
                                    'mBar'
                                    );

  MainTitle = 'RAW DATA (Uncorrected)';
  DATAOFFSET = 165;
  LEFTCOL = 10;
  RIGHTCOl = 250;
begin
// Form, panel and graphic sizes are set in the form activate

// Split the fields
  CSVToText(Log.Items[Log.ItemIndex], Data, ' ');

  LogForm.Info.Canvas.Font.Name := 'Times Roman';
  LogForm.Info.Canvas.Font.Size := 10;
  TextHeight := LogForm.Info.Canvas.TextHeight('Y') + 4;

// clear the area
  LogForm.Info.Canvas.Brush.Color := $90E0FF;
  LogForm.Info.Canvas.FillRect(Bounds(0, 0, Info.Width, Info.Height));

// show the title
  Y := 6;
  Info.Canvas.Font.Style := [fsBold];
  Info.Canvas.TextOut((Info.Width - Info.Canvas.TextWidth(MainTitle)) div 2 , Y, MainTitle);
  Info.Canvas.Font.Style := [];

  // output the fields
  Y := 30;
  Item := 2;

  while Item < 12 do
  begin
    Val := StrToInt('$' + Data.Fields[Item]);
    FieldTitle := Titles[Item - 2];

    case Item of
    2:  begin // Time
          s := TimeToString(Val);

        end;
    6, 7, 11:  s := Format('%4.1f', [Val / 10]); // Temp, Humidity & BP all x10
    8, 9, 10:  // rain spoon tips
        begin
          if MeasurementSettings.Spoon = 0 then
            FieldTitle := 'inch Spoon Tips'
          else
            FieldTitle := 'mm Spoon Tips';

          s := IntToStr(Val);
          case Item of
          8: FieldTitle := FieldTitle + ' per Day';
          9: FieldTitle := FieldTitle + ' per Hour';
         10: FieldTitle := FieldTitle + ' per Minute';
          end;
        end;
    else
        begin
          s := IntToStr(Val);
        end;
    end;

//  append the unit info
    s := s + ' ' + Post[Item - 2];

//  is it left or right column
    if Item mod 2 = 0 then
      X := LEFTCOL
    else
      X := RIGHTCOL;

//  Output the title and data text
    Info.Canvas.TextOut(X, Y, FieldTitle);
    Info.Canvas.TextOut(X + DATAOFFSET, Y, s);
    Inc(Item);

    if (Item mod 2 = 0) and (Item > 2) then
      Inc(Y, TextHeight);

  end;

  if Data.Count > 12 then
  begin
    s := Format('RSSI %4.0d dB', [ShortInt(StrToInt('$' + Data.Fields[12]))]);
    X := Info.Width - Info.Canvas.TextWidth(s) - 5;
    Info.Canvas.TextOut(X, 5, s);
  end;

end;


end.
