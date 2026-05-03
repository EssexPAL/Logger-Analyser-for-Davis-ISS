unit Settings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, LoggerLib, Vcl.FileCtrl,
  {SDL_Colbut,} Vcl.Buttons, Defs, Vcl.ComCtrls, RoseColours, Vcl.CheckLst, Vcl.Printers, Tables,
  connections;

type
  TSettingsForm = class(TForm)
    Panel20: TPanel;
    Panel10: TPanel;
    rgWind: TRadioGroup;
    rgPressure: TRadioGroup;
    rgPrecipitation: TRadioGroup;
    rgAir: TRadioGroup;
    Panel30: TPanel;
    buSave: TButton;
    buClose: TButton;
    gbGraph: TGroupBox;
    CD: TColorDialog;
    buGC1: TPanel;
    buGC3: TPanel;
    buGC4: TPanel;
    buGC5: TPanel;
    buGC2a: TPanel;
    buGC6: TPanel;
    gbAltitude: TGroupBox;
    cbAltUnit: TComboBox;
    Label1: TLabel;
    ebAltitude: TEdit;
    buGC7: TPanel;
    buGC8: TPanel;
    buGC2b: TPanel;
    rgSpoonSize: TRadioGroup;
    buGC9: TPanel;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    lbPrinterList: TListBox;
    Label2: TLabel;
    cbInvert: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    ebDBdir: TEdit;
    Label6: TLabel;
    ebTableName: TEdit;
    Panel2: TPanel;
    ebRootDir: TEdit;
    sbChooseDir: TSpeedButton;
    Panel3: TPanel;
    sbChoseIP: TSpeedButton;
    LocalIP: TEdit;
    Label7: TLabel;
    GroupBox4: TGroupBox;
    cbAtStart: TCheckBox;
    cbHourly: TCheckBox;
    GroupBox2: TGroupBox;
    ebBPCorrection: TEdit;
    cbSaveRaw: TCheckBox;
    procedure buCloseClick(Sender: TObject);
    procedure buGC1Click(Sender: TObject);
    procedure ebAltitudeKeyPress(Sender: TObject; var Key: Char);
    procedure buGC9Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure sbChooseDirClick(Sender: TObject);
    procedure ebRootDirChange(Sender: TObject);
    procedure sbChoseIPClick(Sender: TObject);
  private
    { Private declarations }
    _Ms: TMeasurementSettings;
    _Ps: TConfig;
    _Save: Boolean;
  public
    { Public declarations }
  end;

  function OpenSettings(var Ms: TMeasurementSettings; var Ps: TConfig): Boolean;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

const
  ROSEBUTTON_COLOURS: array [0..5] of TColor = ($0000FF, $00FF00, $FF0000,
                                                $00FFFF, $FFFF00, $FF00FF);

function OpenSettings(var Ms: TMeasurementSettings; var Ps: TConfig): Boolean;

begin
  Application.CreateForm(TSettingsForm, SettingsForm);
  SettingsForm._Save := false;
  SettingsForm._Ms := Ms;
  SettingsForm._Ps := pS;

  with (SettingsForm) do
  begin
    rgAir.ItemIndex           := _Ms.Temperature;
    rgPrecipitation.ItemIndex := _Ms.Precipitation;
    rgWind.ItemIndex          := _Ms.Wind;
    rgPressure.ItemIndex      := _Ms.Pressure;
    buGC1.Color               := _Ms.GraphCol_BG;
    buGC2a.Color              := _Ms.GraphCol_Line1;
    buGC2b.Color              := _Ms.GraphCol_Line2;
    buGC3.Color               := _Ms.GraphCol_Text;
    buGC4.Color               := _Ms.GraphCol_Max;
    buGC5.Color               := _Ms.GraphCol_Grat;
    buGC6.Color               := _Ms.GraphCol_DAY;
    buGC7.Color               := _Ms.GraphCol_BAR;
    buGC8.Color               := _Ms.GraphCol_TXT;
    buGC9.Color               := ROSEBUTTON_COLOURS[_Ms.Rose_Index];
    rgSpoonSize.ItemIndex     := _Ms.Spoon;
    ebAltitude.Text           := _Ms.AltValue.ToString();
    cbAltUnit.ItemIndex       := _Ms.AltUnit;

    ebRootDir.Tag         := 1; // init flag
    ebRootDir.Text        := _Ps.RootPath;
    ebDBDir.Text          := ExtractFileName(_Ps.DBPath);
    _Ps.RootPathChanged   := False;
    ebRootDir.Tag         := 0; // init flag
    LocalIP.Tag           := Ms.HostIP;
    LocalIP.Text          := IP32ToText(Ms.HostIP);
    cbAtStart.Checked     := _Ps.AU_AtStartup;
    cbHourly.Checked      := _Ps.AU_EveryHour;
    cbSaveRaw.Checked     := _Ps.AU_SaveRaw;
    ebBPCorrection.Text   := Format('%.1f', [_Ps.BP_Correction / 10]);
  end;

//  -------------------------------------------------

    SettingsForm.ShowModal;

//  -------------------------------------------------

  Result := SettingsForm._Save;

  if Result then
  begin
    Ps := SettingsForm._Ps;
    Ms := SettingsForm._Ms;
  end;

  SettingsForm.Release;
end;

procedure TSettingsForm.buCloseClick(Sender: TObject);
begin
  if TButton(Sender).Tag = 1 then // save
  begin
    _Ps.RootPathChanged := (_Ps.RootPath <> ebRootDir.Text);

    if _Ps.RootPathChanged then
      _Ps.RootPath := ebRootDir.Text;

    _Ps.DBPath          := _Ps.RootPath + '\' + ebDBDir.Text;
    _Ps.AU_AtStartup    := cbAtStart.Checked;
    _Ps.AU_EveryHour    := cbHourly.Checked;
    _Ps.AU_SaveRaw      := cbSaveRaw.Checked;
    _Ps.BP_Correction   := Round(StrToFloat(ebBPCorrection.Text) * 10);

    if not DirectoryExists(_Ps.DBPath) then
      CreateDir(_Ps.DBPath);

    _Ps.TableName  := ebTableName.Text;

    _Ms.Temperature     := rgAir.ItemIndex;
    _Ms.Precipitation   := rgPrecipitation.ItemIndex;
    _Ms.Pressure        := rgPressure.ItemIndex;
    _Ms.Wind            := rgWind.ItemIndex;
    _Ms.GraphCol_BG     := buGC1.Color;
    _Ms.GraphCol_Line1  := buGC2a.Color;
    _Ms.GraphCol_Line2  := buGC2b.Color;
    _Ms.GraphCol_Text   := buGC3.Color;
    _Ms.GraphCol_Max    := buGC4.Color;
    _Ms.GraphCol_Grat   := buGC5.Color;
    _Ms.GraphCol_DAY    := buGC6.Color;
    _Ms.GraphCol_BAR    := buGC7.Color;
    _Ms.GraphCol_TXT    := buGC8.Color;
//  _Ms.GraphCol_ROSE will be looked up later
//  _Ms.Rose_Index is already set
    _Ms.Spoon           := rgSpoonSize.itemIndex;
    _Ms.AltValue        := StrToInt(ebAltitude.Text);
    _Ms.AltUnit         := cbAltUnit.ItemIndex;
    _Ms.HostIP          := LocalIP.Tag;
    _Save               := True;

    if (lbPrinterList.ItemIndex >= 0) then
    begin
      _Ms.Printer       := lbPrinterList.Items[lbPrinterList.ItemIndex];
      _Ms.PrintInvert   := cbInvert.Checked;
      _Ms.PrinterIndex  := lbPrinterList.ItemIndex;
      _Ms.Changed       := True;
    end;
  end;

  Close;
end;

procedure TSettingsForm.buGC1Click(Sender: TObject);
begin
  CD.Color := TPanel(Sender).Color;
  if CD.Execute then
    TPanel(Sender).Color := CD.Color;
end;

procedure TSettingsForm.buGC9Click(Sender: TObject);
begin
  RoseColourDialog(_Ms.Rose_Index);
  _Ms.GraphCol_ROSE := ROSE_COLOURS[_Ms.Rose_Index];
  buGC9.Color := ROSEBUTTON_COLOURS[_Ms.Rose_Index];
end;

procedure TSettingsForm.ebAltitudeKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [Char(VK_BACK), Char(VK_DELETE), '0'..'9']) then
    Key := #0;

end;

procedure TSettingsForm.ebRootDirChange(Sender: TObject);
begin
  if ebRootDir.Tag = 0 then
    _Ps.RootPathChanged := True;
end;

procedure TSettingsForm.FormActivate(Sender: TObject);
begin
  cbInvert.Checked := _Ms.PrintInvert;
  lbPrinterList.Items.Text  := Printer.Printers.Text;
  lbPrinterList.ItemIndex   := MeasurementSettings.PrinterIndex;

  if MeasurementSettings.Printer <> '' then
    lbPrinterList.ItemIndex := Printer.Printers.IndexOf(MeasurementSettings.Printer);

end;

procedure TSettingsForm.sbChoseIPClick(Sender: TObject);
begin
  LocalIP.Tag := OpenConnections();
  LocalIP.Text := IP32ToText(LocalIP.Tag);
end;

procedure TSettingsForm.sbChooseDirClick(Sender: TObject);
var
  D: String;
begin
  D := ebRootDir.Text;
 if SelectDirectory('Select Logger base directory', '\', D, [sdNewFolder, sdNewUI, sdShowEdit], nil) then
    ebRootDir.Text := D;
end;

end.
