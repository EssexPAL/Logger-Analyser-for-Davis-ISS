unit LoggerInt;

interface

uses
  ShareMem,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.IOUtils, System.Math, System.Types, vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DateUtils, System.UITypes,
  System.StrUtils, LiveData, Connections, CommCtrl, ATUtils, AutoImportForm, EditData, Registry,

  IdBaseComponent, IdComponent, IdGlobal,

  Vcl.ComCtrls,  Vcl.CheckLst,
  IniFiles, Vcl.Buttons, Vcl.ImgList,  IcmpPing, Vcl.Menus, Vcl.Grids, ClipBrd, Data.DB, {dbisamtb,}
  IdAntiFreezeBase, Vcl.IdAntiFreeze, Vcl.Tabs, Settings,
  LoggerLib, Defs, Vcl.DBCtrls, Log, Vcl.printers, Rose, About, IPAForm,

  Tables, Average, Vcl.Samples.Spin, VirtualTrees, Vcl.Samples.Calendar,
  Vcl.ToolWin, IdSocketHandle, IdUDPBase, ulkJson, UDPMessages,
  IdUDPServer, IdIntercept;

const
  CHANNELCOUNT = 8;
  NAMELENGTH = 16;
  ENABLEDCOLOUR = $0080FF;
  DISABLEDCOLOUR = $C0C0C0;

{$define USEDLL}
{$define CLIENT}

type

  TMainForm = class(TForm)
    SD: TSaveDialog;
    DataSource: TDataSource;
    MainMenu: TMainMenu;
    Database1: TMenuItem;
    EmptyDatabase: TMenuItem;
    MainTitle: TPanel;
    DataPage: TPageControl;
    tsStation: TTabSheet;
    tsData: TTabSheet;
    Panel4: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel11: TPanel;
    buFiles2: TButton;
    buFiles1: TButton;
    Panel6: TPanel;
    Panel3: TPanel;
    buClearLog: TButton;
    Panel10: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    buGetDir: TButton;
    buEraseFile: TButton;
    PB: TProgressBar;
    buLoggerStatus: TButton;
    Panel19: TPanel;
    clbFileList: TCheckListBox;
    HeaderControl1: THeaderControl;
    Settings1: TMenuItem;
    EditSettings1: TMenuItem;
    tsAnalyse: TTabSheet;
    WeatherStation1: TMenuItem;
    RestartLogger: TMenuItem;
    Panel24: TPanel;
    Graph: TImage;
    DataVST: TVirtualStringTree;
    Panel7: TPanel;
    Label5: TLabel;
    dtpDataDate: TDateTimePicker;
    rgTimes: TRadioGroup;
    rgSortOrder: TRadioGroup;
    pmWSmenu: TPopupMenu;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    sbPrevMonth: TSpeedButton;
    sbNextMonth: TSpeedButton;
    lMonth: TLabel;
    gbSmooting: TGroupBox;
    lSampleWindow: TLabel;
    tbSampleWindow: TTrackBar;
    caStartDate: TCalendar;
    rgPeriod: TRadioGroup;
    ShowMinMax: TGroupBox;
    cbShowMinMax: TCheckBox;
    lDateNo: TLabel;
    ToolBar: TToolBar;
    TB1: TToolButton;
    ImageList: TImageList;
    TB2: TToolButton;
    TB5: TToolButton;
    TB6: TToolButton;
    ToolButton5: TToolButton;
    TB4: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    TB7: TToolButton;
    ToolButton10: TToolButton;
    TB8: TToolButton;
    TB9: TToolButton;
    ToolButton13: TToolButton;
    TB10: TToolButton;
    TB3: TToolButton;
    ToolButton1: TToolButton;
    TB11: TToolButton;
    ToolButton2: TToolButton;
    PSD: TPrinterSetupDialog;
    PrinterSetup1: TMenuItem;
    About1: TMenuItem;
    buLoadData: TButton;
    LoggerUnit1: TMenuItem;
    Label3: TLabel;
    buGetSysLog: TButton;
    Bevel1: TBevel;
    IPAddress1: TMenuItem;
    cbLoggerIP: TComboBox;
    LDP: TPanel;
    Timer: TTimer;
    mClearDLDirectory: TMenuItem;
    Panel8: TPanel;
    mCheckDLSelected: TMenuItem;
    mViewFile: TMenuItem;
    mCheckImportSelected: TMenuItem;
    mViewPlotBuffer: TMenuItem;
    Log: TListBox;
    pInfo: TPanel;
    mViewSignalLevel: TMenuItem;
    RFAnalyse: TMemo;
    TB12: TToolButton;
    ToolButton3: TToolButton;
    buToday: TButton;
    Button1: TButton;
    Button2: TButton;
    TB13: TToolButton;
    ImportData1: TMenuItem;
    buAutoImport: TButton;
    buLocalImportSelected: TButton;
    Label4: TLabel;
    mEditRowData: TMenuItem;
    Info: TMemo;
    N1: TMenuItem;
    N2: TMenuItem;
    ImageList16: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbFileListClick(Sender: TObject);
    procedure buClearLogClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure buLoggerStatusClick(Sender: TObject);
    procedure EmptyDatabaseClick(Sender: TObject);
    procedure buFiles1Click(Sender: TObject);
    procedure DataPageChange(Sender: TObject);
    procedure EditSettings1Click(Sender: TObject);
    procedure WsDataCalcFields(DataSet: TDataSet);
    procedure swSmoothingClick(Sender: TObject);
    procedure rgMeasurementOldClick(Sender: TObject);
    procedure tbSampleWindowChange(Sender: TObject);
    procedure DataVSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure dtpDataDateChange(Sender: TObject);
    procedure DataPageChanging(Sender: TObject; var AllowChange: Boolean);
    procedure sbPrevMonthClick(Sender: TObject);
    procedure caStartDateChange(Sender: TObject);
    procedure mViewPlotBufferClick(Sender: TObject);
    procedure TB1Click(Sender: TObject);
    procedure TB11Click(Sender: TObject);
    procedure PrinterSetup1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure buLoadDataClick(Sender: TObject);
    procedure cbLoggerIPChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure mClearDLDirectoryClick(Sender: TObject);
    procedure UDPServerxxxUDPRead(AThread: TIdUDPListenerThread;
      const AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure DoButtons(Sender: TObject);
    procedure RestartLoggerClick(Sender: TObject);
    procedure IPAddress1Click(Sender: TObject);
    procedure mCheckDLSelectedClick(Sender: TObject);
    procedure mViewlFileClick(Sender: TObject);
    procedure LogClick(Sender: TObject);
    procedure buTodayClick(Sender: TObject);
    procedure TB13Click(Sender: TObject);
    procedure ImportData1Click(Sender: TObject);
    procedure buAutoImportClick(Sender: TObject);
    procedure DataVSTColumnClick(Sender: TBaseVirtualTree; Column: TColumnIndex;
      Shift: TShiftState);
    procedure DataVSTMouseEnter(Sender: TObject);
    procedure DataVSTMouseLeave(Sender: TObject);


  private
    { Private declarations }
    ServerInitOK: Boolean;
    GetInfo: TGetInfo;
    CurrentLogFile: String;
    Init: Boolean;
    PlotBuffer: TDualPlotBuffer;
    AppDuration: Integer; // in seconds
    procedure SaveMeasurementSettings(var Ms: TMeasurementSettings);
    procedure SummaryLine(Ax: TAxes);
    procedure Analyse(CallingButton: Integer);
    procedure PrintResults(Ax: TAxes);
    procedure ClearMenuItems;
    procedure ImportSelectedFiles(List: TCheckListBox; Log: TListBox; DataDir, DBName, TableName: String);
    procedure ViewFile(Filename: String; var Data: String; DataDir: String);


  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}
{$DEFINE IS_NOT_DLL}

procedure TMainForm.DoButtons(Sender: TObject);
var
  Lc: TLoggerCmd;
  Fs: TFieldSet;
  Idx, Ref, ok: Integer;
  Data, Info: String;
  List: TStringList;
const
  SysLogFn = 'SysLog.Txt';
begin
// These cover an unconfigured client
  if (cbLoggerIP.Items.Count = 0) then
  begin
    MessageDlg('There are no logger addresses defined', mtWarning, [mbOK], 0);
    Exit;
  end;

  if (cbLoggerIP.ItemIndex = -1) then
  begin
    MessageDlg('There is no logger address selected', mtWarning, [mbOK], 0);
    Exit;
  end;

// ------------------------------------------------------

  Lc := TLoggerCmd(TWinControl(Sender).tag);
  pInfo.Caption := '';

  case Lc of
    lcLiveData:     begin
                    end;
    lcLoggerStatus: begin
                      Log.Clear;
                      Log.Items.Add('Please wait whilst the logger collects the status information');
                      Application.ProcessMessages;
                      UDPGetStatus(Data, Info);
                      Log.Items.Text := Data;
                    end;
    lcGetDirectory: begin
                      UDPGetDir(Data, Info, PB);
                      clbFileList.Items.Text := Data;
                      SendMessage(clbFileList.Handle, WM_VSCROLL, SB_BOTTOM, 0);
                      Log.Items.Add(Info);
                    end;
    lcImportFile:   begin
                      ImportSelectedFiles(clbFileList, Log, '', __Config.DBPath, __Config.TableName);
                      SendMessage(Log.Handle, EM_LINESCROLL, SB_BOTTOM, 0);
                    end;
    lcEraseFile:    begin
                      List := TStringList.Create;

                      try
                        ok := MessageDlg('Delete ALL the selected file Y/N ? - There is NO undelete!', mtWarning, [mbYes, mbNo], 0);

                        Idx := 0;
                        while Idx < clbFileList.Count do
                        begin
                          if clbFileList.Checked[Idx] then
                          begin
                            if ok = mrYes then
                            begin
//                            separate the name and size
                              CSVToText(clbFileList.Items[Idx], Fs, ' ');
                              UDPEraseFile(Fs.Fields[0], '/Data/', Info);
                              List.Add(Fs.Fields[0]);
                              Log.Items.Add(Info);
                            end;
                            clbFileList.Checked[Idx] := False;
                          end;
                          Inc(Idx);
                        end;

//                        locate and erase the deleted files from the directory list
                        clbFileList.Items.NameValueSeparator := ' ';
                        for Idx := 0 to List.Count - 1 do
                        begin
                          Ref := clbFileList.Items.IndexOfName(List.Strings[Idx]);
                          if Ref > 0 then
                            clbFileList.Items.Delete(Ref);
                        end;

                      finally
                        List.Free;
                      end;
                    end;
    lcEraseAll:     ; // not implemented
    lcRestart:      begin
                      if MessageDlg('Restart the logger Y/N ?', mtWarning, [mbYes, mbNo], 0) = mrYes then
                        UDPRemoteRestart();
                    end;
    lcGetSysLog:    begin
                      UDPGetFile(SysLogFn, '/', Data, Info, PB);
                      Log.Items.Text := Data;
                      Log.Items.Add(Info);
                      Log.SetFocus;
                      Log.Perform( WM_VSCROLL, SB_BOTTOM, 0 );
                      Log.Repaint;
                    end;
  end;
end;

// convert the date and time to readable
procedure TMainForm.WsDataCalcFields(DataSet: TDataSet);
var
  vs, vm, vl: Word;
begin
  DecodeDate(vs, vm, vl, DataSet.FieldByName('WsDate').AsInteger);
  DataSet.FieldByName('_Date').AsString := Format('%2.2d/%2.2d/%4d', [vs, vm, vl]);

  DecodeTime(vl, vm, vs, DataSet.FieldByName('WsTime').AsInteger);
  DataSet.FieldByName('_Time').AsString := Format('%2.2d:%2.2d:%2.2d', [vl, vm, vs]);
end;

procedure TMainForm.ImportData1Click(Sender: TObject);
begin
  AutoImportNewData(MainForm.Left, MainForm.Top, True, __Config.AU_SaveRaw);
end;

procedure TMainForm.IPAddress1Click(Sender: TObject);
var
  IPList: String;
  Idx: Integer;
begin

// semicolon seperated list to CRLF list
  IPList := MeasurementSettings.LoggerList;
  IPList := ReplaceText(IPList, ';', #13#10);
  if cbLoggerIP.ItemIndex >= 0 then
    Idx := cbLoggerIP.ItemIndex
  else
    Idx := 0;

  if IPAEdit(IPList) then
  begin
    cbLoggerIP.Items.Text := IPList;
    cbLoggerIP.ItemIndex := Idx;
// CRLF seperated list to semicolon list
    IPList := ReplaceText(IPList, #13#10, ';');
    MeasurementSettings.LoggerList := IPList;
    SaveAllSettings(SETTINGTYPE, __Config, MeasurementSettings, cbLoggerIP);
  end;
end;

procedure TMainForm.About1Click(Sender: TObject);
var
  Bm: TBitMap;
begin
  try
    Bm := TBitMap.Create;
  finally
    ImageList.GetBitmap(3, Bm);
    ShowAbout(Bm);
    Bm.Free;
  end;
end;

procedure TMainForm.Analyse(CallingButton: Integer);
var
  Si: TSegmentInfo;
  p: TPolarInfo;
  MaxDate: Integer;
const
  OneDayMsg = 'This measurement is only valid for a 1 day period!';
  NoRainMsg = 'There was no rain on %s';

  procedure Smooth__Data(DoSmooth: Boolean);
  begin
    if (DoSmooth) then
      SmoothData(PlotBuffer.Max, tbSampleWindow.Tag, PLOT_BUFFER_SIZE, Ax.Min, Ax.Max, false);
  end;

  procedure Show_Error_Message(Msg: String);
  var
    X, Y: Integer;
  begin
    Graph.Canvas.Font.Height := 30;
    Graph.Canvas.Font.Color := clWhite;
    X := Graph.Canvas.TextWidth(Msg);
    X := (Graph.Width - X) div 2;
    Y := Graph.Canvas.TextHeight(Msg);
    Y := (Graph.Height - Y) div 2;
    Graph.Canvas.TextOut(X, Y, Msg);
  end;

begin
  __KBState := GetKBState();

  Graph.Visible     := True;
  RFAnalyse.Visible := False;

  Log.Clear;
  ClearGraph(Graph);

  Ax.ShowMinMax := cbShowMinMax.Checked;
  Ax.Period     := rgPeriod.ItemIndex;
  Ax.CallingButton := CallingButton;

// if the period is one month or mre then start at the first of the month
  if Ax.Period > 2 then
    caStartDate.Day := 1;

  Application.ProcessMessages;

  Ax.StartDate  := Trunc(caStartDate.CalendarDate) - AT_DATE_OFFSET;
  MakeEndDate(Ax);
  Ax.Data_Days  := Ax.EndDate - Ax.StartDate + 1;

// validate the start date.  Dont continue if there is no data
  MaxDate := GetHighestDate(__Config.DBPath, __Config.TableName);
  if MaxDate < 0 then
  begin
    Graph.Canvas.Font.Size := 14;
    Show_Error_Message('THE TABLE IS EMPTY');
    Exit;
  end;

  if MaxDate < Ax.StartDate then
  begin
    Graph.Canvas.Font.Size := 14;
    Show_Error_Message(Format('THERE IS NO DATA FOR %s', [DateToStr(Ax.StartDate + AT_DATE_OFFSET)]));
    Exit;
  end;

// parameters for plotting
  Ax.X_Scale_Type := CallingButton;
  Ax.Data_Samples := Ax.Data_Days * SAMPLES_PER_DAY;
  Ax.BPCorrection := 0;

(*  FIELD Numbers
 *  2 Wind Direction, 3 Wind Speed Average, 4 Wind Speed Peak,  5 Temperature
 *  6 Humidity,       7 Rainfall per day,   8 Rainfall/hour,    9 Rainfall per minute
 * 10 Barometric Pressure 11 RSSI
*)

  case CallingButton of
  1, 2, 3:  begin // wind dir
        Ax.Data_Field   := 2;
        Ax.ReadingType  := MeasurementSettings.Wind;
      end;
  4:  begin // wind speed - avr
        Ax.Data_Field   := 3;
        Ax.ReadingType  := MeasurementSettings.Wind;
      end;
  5:  begin // wind speed - peak
        Ax.Data_Field   := 4;
        Ax.ReadingType  := MeasurementSettings.Wind;
      end;
  6:  begin // Temperature
        Ax.Data_Field   := 5;
        Ax.ReadingType  := MeasurementSettings.Temperature;
      end;
  7:  begin // humidity
        Ax.Data_Field   := 6;
        Ax.ReadingType  := 255;
      end;
  8:  begin // rainfall text
        Ax.Data_Field := 8;  // 24 x tips per hour
        Ax.ReadingType  := MeasurementSettings.Precipitation;
      end;
  9:  begin // rainfall text/graph
        Ax.Data_Field := 7; // total tips per day
        Ax.ReadingType  := MeasurementSettings.Precipitation;
      end;
  10: begin // barometric pressure
        Ax.Data_Field   := 10;
        Ax.ReadingType  := MeasurementSettings.Pressure;
       end;
  11: begin // rainfall rate
        Ax.Data_Field   := 9; // tips per minute
        Ax.ReadingType  := MeasurementSettings.Precipitation;
      end;
  12: begin // recieved signal level
        Ax.Data_Field   := 11; // RSSI
        Ax.ReadingType  := MeasurementSettings.Precipitation;
      end;
  end;

// titles
  Ax.Field_Name := FIELD_NAMES[Ax.Data_Field];
  Ax.YTitle     := MakeYTitle(CallingButton, MeasurementSettings);
  Ax.XTitle     := MakeXTitle(Ax);

  GetScaleValue(Ax, MeasurementSettings); // get measurement scale conversion parameters and multiplier

  case CallingButton of
    1..5: // Wind
        if CallingButton = 1 then
        begin // Wind rose
          Si.pAxes := @Ax;
          Si.UnitIndex := MeasurementSettings.Wind;

          LoadWindData(__Config.DBPath, __Config.TableName, Ax, Si, __DebugBuffer);
          Plot_Rose(Ax, Graph, MeasurementSettings, Si);
        end else
        begin // line graph
          Ax.DataMultiplier := 1;
          LoadData(__Config.DBPath, __Config.TableName, @__QueryData, Ax, TStrings(Log.Items));

          Ax.DualLine := False;

          case CallingButton of
          2: // wind dir graph
              begin
                if Ax.Period = 0 then // 1 day
                begin
                  Fill_PlotBufferWithDATA(PlotBuffer.Max, Ax);
                  Smooth__Data((__KBState and 1 > 0));
                end else // 7 days plus
                begin
                  Fill_PlotBufferWithWIND_DIR_DATA(PlotBuffer.Max, Ax);
                  Smooth__Data((__KBState and 1 > 0));
                end;
              end;
          3:  begin // 1 day quad polar display
//            set date range
                Ax.StartDate  := Trunc(caStartDate.CalendarDate) - AT_DATE_OFFSET;
                MakeEndDate(Ax);
                Ax.Data_Days  := Ax.EndDate - Ax.StartDate + 1;
                Ax.Period     := rgPeriod.ItemIndex;

//              parameters for plotting
                Ax.Data_Samples := Ax.Data_Days * SAMPLES_PER_DAY;
                P.Outer_Rad := 100;
                LoadPolarData(__Config.DBPath, __Config.TableName, Ax, P);
                Plot_QuadPolar(Ax, Graph, MeasurementSettings, P);
                exit;
               end;
          4: // wind speed graph
              begin
                if Ax.Period = 0 then // 1 day
                begin
                  Fill_PlotBufferWithDATA(PlotBuffer.Max, Ax);
                  Smooth__Data((__KBState and 1 > 0));
                end else // 7 days plus
                  Fill_PlotBufferWithPERIOD_DATA(PlotBuffer.Max, Ax);
              end; // peak wind speed
          5:  if Ax.Period = 0 then
                  Fill_PlotBufferWithWIND_SPD_PK(PlotBuffer.Max, Ax)
                else
                begin
                  Show_Error_Message(OneDayMsg);
                  Exit;
                end;
          end;

          FindMaxMin(Ax, PlotBuffer.Max, Ax.Data_Samples);
          GetScaleValue(Ax, MeasurementSettings); // get measurement scale conversion parameters
          Plot_Line2(Ax, Graph, MeasurementSettings, PlotBuffer)
        end;
//  ------------------------------------------------------------------------------------
    8:  begin // Rain - as text

          SetLength(__QueryData, 100);
          LoadRainData(__Config.DBPath, __Config.TableName, @__QueryData, Ax);
          if CheckForRain(Ax) then
            Plot_TOTALRAINtext(Graph, Ax, 50, MeasurementSettings)
          else
            Show_Error_Message(Format(NoRainMsg, [DateToStr(Ax.StartDate + AT_DATE_OFFSET)]));
        end;
//  ------------------------------------------------------------------------------------
    9:  begin // Rain - as graph
          LoadRainData(__Config.DBPath, __Config.TableName, @__QueryData, Ax);

          if Ax.Max > 0 then
          begin
            GetScaleValue(Ax, MeasurementSettings); // get measurement scale conversion parameters
            Fill_PlotBufferWithRAIN(PlotBuffer.Max, Ax);
            Plot_Bar(Ax, Graph, MeasurementSettings, PlotBuffer.Max);
            Graph.Canvas.Font.Size := 9;
          end else
          begin
            Show_Error_Message(Format(NoRainMsg, [DateToStr(Ax.StartDate + AT_DATE_OFFSET)]));
          end;
        end;

    11: begin // rainfall rate
          if Ax.Period = 0 then
          begin
            GetScaleValue(Ax, MeasurementSettings); // get measurement scale conversion parameters
            LoadData(__Config.DBPath, __Config.TableName, @__QueryData, Ax, TStrings(Log.Items));

            if CheckForRain(Ax) then // only call if rain fell on the day
            begin
              Graph.Visible     := False;
              RFAnalyse.Align   := alLeft;
              RFAnalyse.Visible := True;
              RFAnalyse.Text := Analyse_RFRateDATA(Ax);
              RFAnalyse.SetFocus;
            end else
            Show_Error_Message(Format(NoRainMsg, [DateToStr(Ax.StartDate + AT_DATE_OFFSET)]));
          end else
          begin
            Show_Error_Message(OneDayMsg);
            Exit;
          end;
        end;
    6, 7:
        begin // Temperature and humidity
          LoadData(__Config.DBPath, __Config.TableName, @__QueryData, Ax, TStrings(Log.Items));
          Ax.ShowMinMax := False;
          if (rgPeriod.ItemIndex = 0) then
          begin
              Fill_PlotBufferWithDATA(PlotBuffer.Max, Ax);
            Smooth__Data((__KBState and 1 > 0));
            FindMaxMin(Ax, PlotBuffer.Max, Ax.Data_Samples);
          Ax.ShowMinMax := cbShowMinMax.Checked;
        end else
          LoadMaxMinData(__Config.DBPath, __Config.TableName, Ax,  PlotBuffer);

          GetScaleValue(Ax, MeasurementSettings); // get measurement scale conversion parameters
          Plot_Line2(Ax, Graph, MeasurementSettings, PlotBuffer);
          SetLength(__QueryData, 0);
        end;
//  ------------------------------------------------------------------------------------
    10: begin // pressure
          Ax.BPCorrection := __Config.BP_Correction;//Round(__Config.BP_Correction * 10);
          LoadData(__Config.DBPath, __Config.TableName, @__QueryData, Ax, TStrings(Log.Items));
          Ax.ShowMinMax := False;

          Fill_PlotBufferWithDATA(PlotBuffer.Max, Ax);
          Smooth__Data((__KBState and 1 > 0));
          FindMaxMin(Ax, PlotBuffer.Max, Ax.Data_Samples);
          Ax.ShowMinMax := cbShowMinMax.Checked;

          GetScaleValue(Ax, MeasurementSettings); // get measurement scale conversion parameters
          Plot_Line2(Ax, Graph, MeasurementSettings, PlotBuffer);
          SetLength(__QueryData, 0);
        end;
//  ------------------------------------------------------------------------------------
    12: begin // RSSI
        // get the data directly from the file as it is not saved into the DB
          Ax.DataMultiplier := 1;
          Ax.X_Scale_Type := 12;
          LoadData(__Config.DBPath, __Config.TableName, @__QueryData, Ax, TStrings(Log.Items));

          Ax.Y_ScaleFactor.Scale := 1;
          Fill_PlotBufferWithDATA(PlotBuffer.Max, Ax);
          Smooth__Data((__KBState and 1 > 0));

          Ax.Min := -120;
          Ax.Max := 0;
          Ax.DataMin := -120;
          Ax.DataMax := 0;

          Ax.Data_Samples := 720;
          Ax.YTitle := 'Received Signal Strength Indication dBm';
          Plot_Line2(Ax, Graph, MeasurementSettings, PlotBuffer);

        end;
  end;

// skip the post plot message as it messes up the polar display
  if Ax.X_Scale_Type > 1 then
    SummaryLine(Ax);

  Ax.ErrorCount := 0;
  SetLength(Ax.ErrorIndex, 0);

  Graph.Canvas.Brush.Color := clBlack;
  Graph.Canvas.Pen.Color := clYellow;
end;

procedure TMainForm.SummaryLine(Ax: TAxes);
begin
  Graph.Canvas.Font.Size := 9;
  Graph.Canvas.Brush.Color := MeasurementSettings.GraphCol_BG;
  Graph.Canvas.Font.Color := clLime;
  Graph.Canvas.TextOut(10, 10, Format('Start: %s (%d) End: %s  Days: %d  Samples: %d  Max: %.1f  Min: %.1f Mult: %f', [
                                        System.SysUtils.DateToStr(Ax.StartDate + AT_DATE_OFFSET),
                                        Ax.StartDate,
                                        System.SysUtils.DateToStr(Ax.EndDate + AT_DATE_OFFSET),
                                        Ax.Data_Days, Ax.Data_Samples,
                                        Ax.Max / 10, Ax.Min / 10,
                                        Ax.DataMultiplier
                                        ]));
end;



procedure TMainForm.buClearLogClick(Sender: TObject);
begin
  Log.Clear;
end;

procedure TMainForm.buLoggerStatusClick(Sender: TObject);
var
  Data, Info: String;
begin
  if UDPGetStatus(Data, Info) then
    Log.Items.Text := Data
  else
    Log.Items.Add(Info);
end;

procedure TMainForm.buTodayClick(Sender: TObject);
var
  d, m, y, Offset: Word;
begin
  Offset := 0;

  case TWinControl(Sender).Tag of
  2:  Offset := 1;
  3:  Offset := DayOfWeek(Date) - 2;
  end;

  System.SysUtils.DecodeDate(Date - Offset, y, m, d);
  caStartDate.Day   := d;
  caStartDate.Month := m;
  caStartDate.Year  := y;
end;

procedure TMainForm.buAutoImportClick(Sender: TObject);
begin
  AutoImportNewData(MainForm.Left, MainForm.Top, False, __Config.AU_SaveRaw);
end;

procedure TMainForm.PrinterSetup1Click(Sender: TObject);
begin
  if PSD.Execute then
  begin
    MeasurementSettings.Printer := Printer.Printers.Strings[Printer.PrinterIndex];
    MeasurementSettings.PrinterIndex := Printer.PrinterIndex;
  end;
end;

type

  TTextPrinterParams = record
    Title: String;
    PageHeight: Integer;
    PageWidth: Integer;
    LineHeight: Integer;
    MarginLeft: Integer;
    MarginTop: Integer;
    MarginBottom: Integer;
    BarWidth: Integer;
    TextTop: Integer;
    TextBottom: Integer;
  end;

procedure PrintText(Text: TStrings);
const
  PAGEBORDER = 1; // inch
var
  PP: TTextPrinterParams;
  RRIdx, PageY: iNTEGER;

  procedure InitParams(Title: String);
  var
    Pppi: Integer;
  begin
    Pppi := GetDeviceCaps(Printer.Handle, LOGPIXELSX);

    PP.Title        := Title;
    PP.PageHeight   := Printer.PageHeight;
    PP.LineHeight   := Printer.Canvas.TextHeight('Z');
    PP.MarginLeft   := Round(PAGEBORDER * Pppi);
    PP.MarginTop    := Round(PAGEBORDER * PPpi);
    PP.MarginBottom := PP.PageHeight - Round(PAGEBORDER * PPpi);
    PP.PageWidth    := Printer.PageWidth;
    PP.BarWidth     := PP.PageWidth - PP.MarginLeft - PP.MarginLeft;
    PP.TextTop      := PP.MarginTop + PP.LineHeight;
    PP.TextBottom   := PP.MarginBottom - PP.LineHeight - PP.LineHeight;
    Printer.Canvas.Pen.Color := clBlack;

  end;

  procedure DoNewPage(TitleText: String; var YPos: Integer);
  const
    VOFFSET = 50; // pixels
  var
    FontSize: Integer;
  begin
    if YPos > 0 then
      Printer.NewPage;

    YPos := PP.TextTop;

//  Header
    Printer.Canvas.MoveTo(PP.MarginLeft,                PP.MarginTop);
    Printer.Canvas.LineTo(PP.MarginLeft + PP.BarWidth,  PP.MarginTop);

    FontSize := Printer.Canvas.Font.Size;
    Printer.Canvas.Font.Size := 12;
    Printer.Canvas.TextOut(PP.MarginLeft,               PP.MarginTop - PP.LineHeight - PP.LineHeight, PP.Title);
    Printer.Canvas.Font.Size := FontSize;

//  Footer
    Printer.Canvas.MoveTo(PP.MarginLeft,                PP.MarginBottom);
    Printer.Canvas.LineTo(PP.MarginLeft + PP.BarWidth,  PP.MarginBottom);
    Printer.Canvas.TextOut(PP.MarginLeft,               PP.MarginBottom + VOFFSET,
            Format('  Page: %d', [Printer.PageNumber]));

  end;
begin
 // text printing
  Printer.Orientation := poPortrait;
  Printer.Title := Text.Strings[0];// 'aaaa';

  Printer.BeginDoc;

    Printer.Canvas.Font.Name := 'Monospac821 BT';
    Printer.Canvas.Font.Size := 8;
    InitParams(Text.Strings[0]);

    RRIdx := 2; // skip the title and blank line

    PageY := -1; // force an immediate header/footer print
    while RRIdx < Text.Count do
    begin
      if (PageY = -1) or (PageY > PP.TextBottom) then
        DoNewPage(Text[0], PageY);

      Printer.Canvas.TextOut(PP.MarginLeft, PageY, Text[RRIdx]);
      Inc(RRIdx);
      Inc(PageY, PP.LineHeight);
    end;

  Printer.EndDoc;
end;

procedure TMainForm.PrintResults(Ax: TAxes); // prints text and graphics
var
  PaperWidth: Integer;
  DestRect: TRect;
  Ratio: Single;
  PageBorder, ExtraWidth, Pppi: Integer;
const
  BORDER:     Single = 0.75; // of an inch
  TOPOFFSET:  Single = 0.5;
  EXTRA:      Single = 0.25;
  HFTOP:      Single = 0.5;

begin
  Printer.PrinterIndex := MeasurementSettings.PrinterIndex;
  Printer.Orientation := poLandscape;

// Retrieves information about the Printer.
  PaperWidth  := GetDeviceCaps(Printer.Handle, HORZRES);
  Pppi        := GetDeviceCaps(Printer.Handle, LOGPIXELSX);

  ExtraWidth      := Trunc(EXTRA * Pppi);
  PageBorder      := Round(BORDER * Pppi);

// create the rinter destination rectangle according to the printer parameters
  Ratio           := Graph.Height / Graph.Width;
  DestRect.Left   := PageBorder + ExtraWidth;
  DestRect.Right  := PaperWidth - PageBorder - ExtraWidth;
  DestRect.Top    := PageBorder + Round(TOPOFFSET * Pppi);
  DestRect.Height := Trunc(DestRect.Width * Ratio);

  with Printer do
  begin
    if Ax.X_Scale_Type = 11 then
      PrintText(RFAnalyse.Lines) // text printing
    else
    begin
      try
        try
          begin
            BeginDoc;
              Printer.Canvas.Font.Name := 'Monospac821 BT';
              Printer.Canvas.Font.Size := 10;

              Canvas.Font.Size := 16;
              Text := Ax.XTitle;
              Canvas.TextOut((PaperWidth - Canvas.TextWidth(Text)) div 2, PageBorder, Text);

              if MeasurementSettings.PrintInvert then
                Printer.Canvas.CopyMode := cmNotSrcCopy
              else
                Printer.Canvas.CopyMode := cmSrcCopy;

              Canvas.StretchDraw(DestRect, Graph.Picture.Graphic);
          end;
        finally
          EndDoc;
        end;
      except
        MessageDlg('Printing cancelled!', mtWarning, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TMainForm.buLoadDataClick(Sender: TObject);
begin
  dtpDataDateChange(Sender);
end;

procedure TMainForm.caStartDateChange(Sender: TObject);
var
  Y, M, D: Word;
const
  MonthNames: array [0..11] of String = ( 'Jan', 'Feb', 'Mar',
                                          'Apr', 'May', 'Jun',
                                          'Jul', 'Aug', 'Sep',
                                          'Oct', 'Nov', 'Dec');

begin
  System.SysUtils.DecodeDate(caStartDate.CalendarDate, Y, M, D);
  lMonth.Caption := Format('%s %d', [MonthNames[M - 1], Y]);
  lDateNo.Caption := Format('%d  %s', [Trunc(caStartDate.CalendarDate) - AT_DATE_OFFSET, DateToStr(caStartDate.CalendarDate)]);
end;

procedure TMainForm.cbLoggerIPChange(Sender: TObject);
begin
  MeasurementSettings.ServerIP := IPTextToIP32(cbLoggerIP.Text);
  SetIP(IP32ToText(MeasurementSettings.HostIP), cbLoggerIP.Text, UDP_PORT);
  SaveAllSettings(SETTINGTYPE, __Config, MeasurementSettings, cbLoggerIP);
end;

procedure TMainForm.mClearDLDirectoryClick(Sender: TObject);
begin
  clbFileList.Clear;
end;

procedure TMainForm.buFiles1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to clbFileList.Count - 1 do
    clbFileList.Checked[i] := (TWinControl(Sender).Tag = 1);
end;

procedure TMainForm.EditSettings1Click(Sender: TObject);
begin
  if OpenSettings(MeasurementSettings, __Config) then
  begin
    SaveAllSettings(SETTINGTYPE, __Config, MeasurementSettings, cbLoggerIP);

// if table does not exist then create it
    if __Config.RootPathChanged then
      CheckTable(__Config.DBPath, __Config.TableName);
  end;
end;

procedure TMainForm.EmptyDatabaseClick(Sender: TObject);
begin
  if MessageDlg('Empty the data table? Y/N', mtWarning, [mbYes, mbNo], 0) = mrYes then
    if MessageDlg('This is irreversable - Are you sure? Y/N', mtWarning, [mbYes, mbNo], 0) = mrYes then
      EmptyTable(__Config.DBPath, __Config.TableName);
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  Init := False;

  DataPage.ActivePage := tsAnalyse;
  MeasurementSettings.Init := False;
  if __Config.AU_AtStartup then
    AutoImportNewData(MainForm.Left, MainForm.Top, True, __Config.AU_SaveRaw);
  Analyse(TB6.Tag);

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if __DebugBuffer <> nil then
    __DebugBuffer.Free;
end;

procedure TMainForm.DataPageChange(Sender: TObject);
var
  Idx: Integer;
begin
// ID the page by name not index, avoids problems after adding or removing pages
  if DataPage.ActivePage = tsStation then
    Idx := 0
  else
    if DataPage.ActivePage = tsData then
      Idx := 1
    else
      Idx := 2; // tsAnalyse

  DataSource.Enabled  := Idx = 2;
  Timer.Enabled       := Idx = 2;;

  case Idx of
  0:  begin // weather station
        MainTitle.Caption := 'Weather Data Analyser - Weather Station Functions';
        mCheckDLSelected.Visible := True;
        mClearDLDirectory.Visible := True;
        mViewFile.Visible := True;
      end;
  1:  begin // Raw Data
        MainTitle.Caption := 'Weather Data Analyser - Raw Data';
        dtpDataDateChange(nil);
        rgTimes.ItemIndex := 0;
        DataVST.Repaint;
      end;
  2:  begin // analyse
        MainTitle.Caption := 'Weather Data Analyser - Plot Data';
        mViewPlotBuffer.Visible := True;
      end;
  end;
  SaveMeasurementSettings(MeasurementSettings);
  SaveAllSettings(SETTINGTYPE, __Config, MeasurementSettings, cbLoggerIP);
end;

procedure TMainForm.DataPageChanging(Sender: TObject; var AllowChange: Boolean);
begin
  if (DataPage.ActivePage = tsAnalyse) then
    dtpDataDate.Date := caStartDate.CalendarDate;

  ClearMenuItems;
end;

procedure TMainForm.ClearMenuItems;
begin
  mCheckDLSelected.Visible      := False;
  mClearDLDirectory.Visible     := False;
  mViewPlotBuffer.Visible       := False;
  mViewFile.Visible             := False;
  mCheckImportSelected.Visible  := False;
  mViewSignalLevel.Visible      := False;
end;

procedure TMainForm.DataVSTColumnClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
var
  Nd: pWsData;
begin
  if GetKBState() and 2 = 2 then
  begin
    if DataVST.FocusedNode <> nil then
    begin
      Nd := DataVst.GetNodeData(DataVST.FocusedNode);
      if EditDataRow(Nd) then
      begin
        SetRecord(__Config.DBPath, __Config.TableName, Nd);
        DataVST.Refresh;
      end;
    end;
  end;
end;

procedure TMainForm.DataVSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  N: pWsData;
  wmin, wmid, wmax: Word;
begin

  N := Sender.GetNodeData(Node);
  case Column of
  1:  begin
        DecodeDate(wmin, wmid, wmax, N.Date, false);
        CellText := Format('%2.2D/%2.2D/%2.2D', [wmin, wmid, wmax]);
      end;
  2:  begin
        DecodeTime(wmin, wmid, wmax, N.Time);
        CellText := Format('%2.2d:%2.2d:%2.2d', [wmin, wmid, wmax]);
      end;
  3:  CellText := N.Dir.ToString();
  4:  CellText := N.AvrSpd.ToString();
  5:  CellText := N.PkSpd.ToString();
  6:  CellText := N.Temp.ToString();
  7:  CellText := N.Humid.ToString();
  8:  CellText := N.Pres.ToString();
  9:  CellText := N.Hour.ToString();
 10:  CellText := N.Min.ToString();
 11:  CellText := ShortInt(N.Rssi).ToString(); // needs to be an 8 bit int
  end;
end;


procedure TMainForm.DataVSTMouseEnter(Sender: TObject);
begin
  mEditRowData.Enabled := True;
end;

procedure TMainForm.DataVSTMouseLeave(Sender: TObject);
begin
  mEditRowData.Enabled := False;
end;

procedure TMainForm.dtpDataDateChange(Sender: TObject);
var
  s, e: DWord;
const
//                                          N  T WD WA WP  T  H  BP RH RM  RSSI
  FieldAdjust: array [0..10] of Integer = ( 1, 1, 2, 3, 4, 5, 6, 10, 8, 9, 11);
begin
  if (rgTimes.ItemIndex) = 0 then
  begin
    s := 0;
    e := 86400;
  end else
  begin
    s := (rgTimes.ItemIndex - 1) * 7200;
    e := s + 7200;
  end;

  AddTableData( __Config.DBPath,
                __Config.TableName,
                Trunc(dtpDataDate.Date - AT_DATE_OFFSET),
                s,
                e,
                DataVST,
                FieldAdjust[rgSortOrder.ItemIndex]);
end;

procedure TMainForm.rgMeasurementOldClick(Sender: TObject);
begin
  rgPeriod.Enabled := True;
  DataPageChange(DataPage);
  MeasurementSettings.UseMinMax := cbShowMinMax.Checked;// TCheckBox(Sender).Checked;
  SaveAllSettings(SETTINGTYPE, __Config, MeasurementSettings, cbLoggerIP);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Pi: TPrinterInfo;
  SettingsExist: Boolean;
begin
  __WsHandle := LoadLibrary('WsIsam.DLL');

  Mainform.Caption := Format('Weather Station RF Data Logger - %s', [GetFV(Application.ExeName)]);

  Toolbar.ButtonWidth := 90;

//  -------- SETUP --------
// load settings
  SettingsExist := DoSettingsExist(SETTINGTYPE);

  if not SettingsExist then
//  if the settings do not exist then create with defaults
    SetIniDefaults(__Config, MeasurementSettings, cbLoggerIP)
  else
    LoadAllSettings(SETTINGTYPE, __Config, MeasurementSettings, cbLoggerIP);

// check the table
    CheckTable(__Config.DBPath, __Config.TableName);

// init IP settings
  SetIP(IP32ToText(MeasurementSettings.HostIP),
        IP32ToText(MeasurementSettings.ServerIP),
        UDP_PORT);

// init the smoothing window
  tbSampleWindowChange(tbSampleWindow);
// initial starting date
  caStartDate.CalendarDate := Date;

//  -----------------------

  __DebugBuffer := TStringList.Create;
  __Origin := Point(Graph.Width  div 2, Graph.Height div 2);
  Init := True;
  MeasurementSettings.Init := True;
  cbShowMinMax.Checked := MeasurementSettings.UseMinMax;

  // fix graph window size
  GRAPH_WINDOW_WIDTH           := Graph.Width;
  Graph.Constraints.MaxWidth   := GRAPH_WINDOW_WIDTH;
  Graph.Constraints.MinWidth   := GRAPH_WINDOW_WIDTH;
  Graph.Constraints.MaxHeight  := GRAPH_HEIGHT;
  Graph.Constraints.MinHeight  := GRAPH_HEIGHT;

  MainForm.Refresh;

  ServerInitOK    := False;
  CurrentLogFile  := '';

// rawdata page node size config
  DataVST.NodeDataSize := sizeof (TWsData);

  Graph.Canvas.Brush.Color := MeasurementSettings.GraphCol_BG + $202020;
  Graph.Canvas.FillRect(Rect(0, 0, Graph.Width, Graph.Height));

// tags contain the button id for "DoButtons"
  buGetDir.Tag        := Byte(lcGetDirectory);
  buEraseFile.Tag     := Byte(lcEraseFile);
  buLoggerStatus.Tag  := Byte(lcLoggerStatus);
  buGetSysLog.Tag     := Byte(lcGetSysLog);
  RestartLogger.Tag   := Byte(lcRestart);

// multiselect is not available in the property editor
  clbFileList.MultiSelect := True;

  ClearMenuItems;
  DataPageChange(DataPage);

// fix toolbar spacing
  Pad_TB_ButtonWidth(Toolbar);

end;

procedure TMainForm.lbFileListClick(Sender: TObject);
var
  Fs: TFieldSet;
begin
  GetInfo.goSize := StrToInt(Copy(clbFileList.Items[clbFileList.ItemIndex], 23, 99));
  CSVToText(clbFileList.Items[clbFileList.ItemIndex], Fs, ' ');
  buEraseFile.Enabled :=  (CurrentLogFile <> Fs.Fields[0]);
end;

procedure TMainForm.swSmoothingClick(Sender: TObject);
begin
  SaveMeasurementSettings(MeasurementSettings);
  SaveAllSettings(SETTINGTYPE, __Config, MeasurementSettings, cbLoggerIP);
end;

procedure TMainForm.TB11Click(Sender: TObject);
begin
  PrintResults(Ax);
end;

procedure TMainForm.TB1Click(Sender: TObject);
begin
  Analyse(TWinControl(Sender).Tag);
end;

procedure TMainForm.tbSampleWindowChange(Sender: TObject);
begin
  tbSampleWindow.Tag :=(tbSampleWindow.Position shl 1) + 3;
  lSampleWindow.Caption := 'Sample Window (' + IntToStr(tbSampleWindow.Tag) + ')';
  SaveMeasurementSettings(MeasurementSettings);
  SaveAllSettings(SETTINGTYPE, __Config, MeasurementSettings, cbLoggerIP);
end;

procedure TMainForm.TimerTimer(Sender: TObject);
var
  Mn: Integer;
begin
(*  ensure the app has been running for 30s before asking for live data.
    This prevents requests for data download becoming muddled with live data. *)
  if AppDuration >= 30 then
  begin
    if UDPGetRTData(__LiveData) then
    begin
      LDP.Caption := GetLDString(MeasurementSettings);
    end else
    begin
      LDP.Caption := Format('%s The logger did not respond to the live data request',
                      [TimeToStr(Time)]);
    end;
  end;

  Mn  := Round(Time * 86400) mod 3600;
  Inc(AppDuration, (Timer.Interval div 1000));

// trigger auto import if required
  if (Mn >= 0) and (Mn <= 6) then
    if __Config.AU_EveryHour then
      AutoImportNewData(MainForm.Left, MainForm.Top, True, __Config.AU_SaveRaw);
end;

procedure TMainForm.TB13Click(Sender: TObject);
begin
  Analyse(TWinControl(Sender).Tag);
end;

procedure TMainForm.UDPServerxxxUDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
var
  js: TlkJSONobject;
  RxData: String;
  cmd: TLoggerCmd;
  Info: String;
  Block, BlockCount: Integer;
begin
  RxData := BytesToString(AData);
  js := TlkJSON.ParseText(RxData) as TlkJSONobject;
  cmd := js.Field['mi'].Value;

  case cmd of
    lcLiveData: // get live data, 1 block
      begin
        UpdateLiveData(js, __LiveData);
        LDP.Caption := GetLDString(MeasurementSettings);
      end;
    lcLoggerStatus: // get logger status, 1 block
      begin
        UDPProcessStatus(js, RxData, Info);
        Log.Items.Text := RxData;
      end;
    lcGetDirectory: // get directory, 1+ blocks
      begin
        Block := js.Field['bn'].Value;
        if Block = 1 then
        begin
          BlockCount := js.Field['bc'].Value;
          PB.Max := BlockCount;
        end;
        PB.Position := Block;

        Application.ProcessMessages;
        UDPProcessDir(js, __FileInfo);
        if __FileInfo.LastBlock then
        begin
          Log.Items.Add(__FileInfo.Info);
          clbFileList.Items.Text := __FileInfo.Data;
        end;
        SendMessage(clbFileList.Handle, WM_VSCROLL, SB_BOTTOM, 0);
      end;
    lcGetFile: ;
    lcEraseFile: ;
    lcEraseAll: ;
  end;

end;

procedure TMainForm.mViewlFileClick(Sender: TObject);
var
  Fs: TFieldSet;
  Data: String;
begin
    CSVToText(clbFileList.Items[clbFileList.ItemIndex], Fs, ' ');
    ViewFile(Fs.Fields[0], Data, '/Data/');
end;

procedure TMainForm.mCheckDLSelectedClick(Sender: TObject);
var
  Idx: Integer;
begin
  for Idx := 0 to clbFileList.Items.Count - 1 do
    if clbFileList.Selected[Idx] then
      clbFileList.Checked[Idx] := True;
end;

procedure TMainForm.mViewPlotBufferClick(Sender: TObject);
var
  X, Y, YInc, Cnt, DataLeft: Integer;
  s: String;
  Title: string;
begin
  ClearGraph(Graph);
  Graph.Canvas.Font.Color := $80FFFF;
  Graph.Canvas.Font.Name := 'Monospac821 BT';
  Graph.Canvas.Font.Size := 10;
  DataLeft := (Graph.Width - (Graph.Canvas.TextWidth('W') * 87)) div 2;
  Graph.Canvas.Font.Size := 12;


//  case rgMeasurement.ItemIndex of
  case Ax.X_Scale_Type of
  1:  begin
        Title := 'WIND ROSE DATA';
        X := (Graph.Width - Graph.Canvas.TextWidth(Title)) div 2;
        Graph.Canvas.TextOut(X, 20, Title);
        YInc := Graph.Canvas.TextHeight('I') + 1;
        Graph.Canvas.Font.Size := 10;


        Y := 80;
        X := (Graph.Width - Graph.Canvas.TextWidth(__DebugBuffer.Strings[0])) div 2;

        for Cnt := 0 to __DebugBuffer.Count - 1 do
        begin
          Graph.Canvas.TextOut(X, Y, __DebugBuffer.Strings[Cnt]);
          Inc(Y, YInc);
        end;
        Exit;
      end;
  9:  begin
        Title := 'RAINFALL DATA - BAR GRAPH';
        X := (Graph.Width - Graph.Canvas.TextWidth(Title)) div 2;
        Graph.Canvas.TextOut(X, 20, Title);
        Graph.Canvas.Font.Size := 10;
        YInc := Graph.Canvas.TextHeight('I') + 1;

        Y := 80;
        s := '';

        Cnt := 0;
        while Cnt < __DebugBuffer.Count - 2 do // plotbuffer lines
        begin
          s := Format('%s%3.3d:%4s', [s, Cnt, __DebugBuffer.Strings[Cnt]]);

          if (Cnt mod 7 = 6) then // line full so output
          begin
            TextAligned(Graph.Canvas, DataLeft, Y, s, taLeftJustify);
            s := '';
            Inc(Y, YInc);
          end else
            s := s + ',    '; // add to line

          Inc(Cnt);
        end;

        if (s <> '') then // plotbuffer last short line
        begin
          TextAligned(Graph.Canvas, DataLeft, Y, s, taLeftJustify);
          Inc(Y, YInc);
          s := '';
        end;

        Inc(Y, YInc);

        while Cnt < __DebugBuffer.Count do // remaining information lines
        begin
          TextAligned(Graph.Canvas, __Origin.X, Y, __DebugBuffer.Strings[Cnt], taCenter);
          Inc(Y, YInc);
          Inc(Cnt);
        end;

        Exit;

      end;
  end;

// default simple dump of plot buffer
  Title := 'PLOT BUFFER VALUES';
  X := (Graph.Width - Graph.Canvas.TextWidth(Title)) div 2;
  Graph.Canvas.TextOut(X, 20, Title);

  Graph.Canvas.Font.Size := 9;
  Graph.Canvas.Font.Name := 'Monospac821 BT';

  Y := 50;
  Cnt := 0;
  YInc := Graph.Canvas.TextHeight('0') - 2;

  while Cnt < Length(PlotBuffer.Max) do
  begin
    if Cnt mod 100 = 0 then
      s := '>'
    else
      s := ' ';

    X := 0;
    while X < 20 do
    begin
      s := Format('%s %5d', [s, PlotBuffer.Max[Cnt]]);
      Inc(X);
      Inc(Cnt);
    end;
    Graph.Canvas.TextOut(12, Y, s);
    Inc(Y, YInc);
  end;
end;

procedure TMainForm.RestartLoggerClick(Sender: TObject);
begin
  DoButtons(sender);
end;

procedure TMainForm.LogClick(Sender: TObject);
var
  Dt, Tm, Ms: DWord;
  Line, Dts, Tms: String;
begin
  Text := '';

  if Log.ItemIndex >= 0 then
  begin
// 1        0         0         0
//' 8712 10801 (12710116) Hourly rain cleared 03:00'
    Line := Log.Items.Strings[Log.ItemIndex];

    if Line.Length > 22 then
    begin
      if((Line[13] = '(')) and (Line[22] = ')') then
      begin
        Dt := StrToInt(Copy(Line,  1, 5));
        Tm := StrToInt(Copy(Line,  7, 5));
        Ms := StrToInt(Copy(Line, 14, 8));
        Line := Copy(Line, 24, 99);

        if Dt = 0 then
        begin
          Dts := 'NOT SET';
          Tms := Ms.ToString() + ' mS';
        end else
        begin
          Dts := DateToStr(Dt + AT_DATE_OFFSET);
          Tms := TimeToString(Tm)
        end;


        pInfo.Caption := Format('  DATE: %-10s TIME: %-8s INFO: %s', [
                                              Dts,
                                              Tms,
                                              Line]);
      end else
        pInfo.Caption := '';
    end else
      pInfo.Caption := '';
  end;
end;

procedure TMainForm.SaveMeasurementSettings(var Ms: TMeasurementSettings);
begin
  Ms.Period     := rgPeriod.ItemIndex;
  Ms.WindowSize := tbSampleWindow.Position;
  Ms.Page       := DataPage.TabIndex;
  Ms.UseMinMax  := cbShowMinMax.Checked;
end;

procedure TMainForm.sbPrevMonthClick(Sender: TObject);
var
  Y, M, D: WOrd;
begin
  System.SysUtils.DecodeDate(caStartDate.CalendarDate, Y, M, D);
  D := 1;
  case TWinControl(Sender).Tag of
  1:  if M = 1 then
      begin
        M := 12;
        Dec(Y);
      end else
        Dec(M);
  2:  if M = 12 then
      begin
        M := 1;
        Inc(Y);
      end else
        Inc(M);
  end;

  caStartDate.CalendarDate := EncodeDate(Y, M, D);
end;

(* Import all selected data files into the database.  This is a two stage process
 * 1. Load the data file into a string list and then place the contents into
 *    an array of TWsData structures.  It is possible to for the first few lines
 *    of data to be from the previous day.  Detect these lines and add to the
 *    previous days data. Makes small adjustments to time and wind direction.
 * 2. Add the data from the TWsData array into the database.  Insert if no record
 *    exists, overwrite where a record already exists.
 *)
procedure TMainForm.ImportSelectedFiles(List: TCheckListBox; Log: TListBox; DataDir, DBName, TableName: String);
var
  Fs: TFieldSet;
  Count, Line, FileCount: Integer;
  Filename, Info, Data: String;
  DataFile: TStringList;
  DataList: TWsDataList;
  OK: Boolean;
const
  RETRY_COUNT = 3;
begin

  DataFile := TStringList.Create;

  try
    FileCount := 0;
//  count file to be processed
    for Line := 0 to List.Items.Count - 1 do
    begin
      if (List.Checked[Line]) then
        Inc(FileCount);
    end;

    if (FileCount > 0) then
    begin
//    get the data file and place in the stringlist
      Line := 0;
//    itterate through the list
      while (Line < List.Count) do
      begin
        if (List.Checked[Line]) then
        begin
          DataFile.Clear;

//        extract the filename
          CSVToText(List.Items[Line], Fs, ':');
          if Fs.Count = 2 then
            FileName := Fs.Fields[0];

//        collect the data
          Count := RETRY_COUNT;
          repeat
            CSVToText(List.Items[Line], Fs, ' ');
            OK := UDPGetFile(Fs.Fields[0], '/Data/', Data, True);
            Dec(Count);
          until OK or (Count = 0);

          if not OK and (Count = 0) then
          begin
            MessageDlg('Unable to get data from the logger!', mtWarning, [mbOK], 0);
            Exit;
          end;

          if OK then
          begin
            DataFile.Text := Data;
//            convert the data into a sutiable form for importing and import
            ProcessFile(Info, DataFile, DBName, TableName, DataList);
            Log.AddItem(Info, TObject(0));
            List.Checked[Line] := False;
            Application.ProcessMessages;
          end;
        end;
        Inc(Line);
      end;
    end;
  finally
    DataFile.Free;
  end;
end;

procedure TMainForm.ViewFile(FileName: String; var Data: String; DataDir: String);
var
  Count: Integer;
  OK: Boolean;
const
  RETRY_COUNT = 3;
begin

  if Filename.Length > 0 then
  begin
    Data := '';

//  get the data
    Count := RETRY_COUNT;
    repeat
      OK := UDPGetFile(Filename, '/Data/', Data, True);
      Dec(Count);
    until OK or (Count = 0);

    if not OK and (Count = 0) then
    begin
      MessageDlg('Unable to get data from the logger!', mtWarning, [mbOK], 0);
      Exit;
    end else
      LoadLog(FileName, Format('View File %s', [Filename]), 560, Data);
  end;
end;

end.


