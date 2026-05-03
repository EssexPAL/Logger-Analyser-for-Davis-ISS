program WsLogger;

uses
  Sharemem,
  Vcl.Forms,
  LoggerInt in 'LoggerInt.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  Settings in 'Settings.pas' {SettingsForm},
  LoggerLib in 'LoggerLib.pas',
  Log in 'Log.pas' {LogForm},
  Rose in 'Rose.pas',
  RoseColours in 'RoseColours.pas' {RoseForm},
  About in 'About.pas' {AboutForm},
  IPAForm in 'IPAForm.pas' {IPEditForm},
  LiveData in 'LiveData.pas',
  Connections in 'Connections.pas' {ConnectionsForm},
  Average in '..\Common\Average.pas',
  Defs in '..\Common\Defs.pas',
  ATUtils in '..\Common\ATUtils.pas',
  UDPMessages in '..\Common\UDPMessages.pas',
  Tables in '..\DLL\Tables.pas',
  AutoImportForm in 'AutoImportForm.pas' {ImportForm},
  EditData in 'EditData.pas' {DataEditForm};

{$R *.res}

  begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Emerald Light Slate');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
