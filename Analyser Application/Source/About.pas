unit About;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, LoggerLib, Tables;

procedure ShowAbout(Bm: TBitMap);

type
  TAboutForm = class(TForm)
    Info: TMemo;
    Img: TImage;
    Panel1: TPanel;
    buClose: TButton;
    procedure buCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

procedure ShowAbout(Bm: TBitMap);
begin
  Application.CreateForm(TAboutForm, AboutForm);
  try
    with AboutForm.Img do
    begin
      Canvas.Draw(10, 10, Bm);
      Canvas.Font.Color := clBlack;
      Canvas.Font.Size := 12;
      Canvas.TextOut(Bm.Width + 50, Bm.Height div 2, 'Data Analyser for Weather Station Logger');
      AboutForm.Info.Lines.Add('');
      AboutForm.Info.Lines.Add(Format(' %s %s',   ['Written by:', 'Peter Lee']));
      AboutForm.Info.Lines.Add('');
      AboutForm.Info.Lines.Add(Format(' %s %s',   ['Application version:', GetFV(Application.ExeName)]));
      AboutForm.Info.Lines.Add(Format(' %s %.2f', ['DLL version:', DLLVer / 100]));
      AboutForm.Info.Lines.Add('');
      AboutForm.Info.Lines.Add(Format(' %s',      ['Davis ISS information courtesy of DeKay']));
      AboutForm.Info.Lines.Add(Format(' %s',      ['https://github.com/dekay/DavisRFM69']));
      AboutForm.Info.Lines.Add('');
      AboutForm.Info.Lines.Add(Format(' %s',      ['DBIsam Database courtesy of Elevate Software']));
    end;
    AboutForm.ShowModal;
  finally
    AboutForm.Release;
  end;
end;

{$R *.dfm}

procedure TAboutForm.buCloseClick(Sender: TObject);
begin
  Close;
end;

end.
