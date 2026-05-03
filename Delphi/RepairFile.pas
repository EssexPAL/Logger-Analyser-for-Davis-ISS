unit RepairFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Defs, ATUtils;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    FileIn: TMemo;
    FileOut: TMemo;
    Button1: TButton;
    OD: TOpenDialog;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Averages: TWsRecord;
  Fs: TFieldSet;
  Idx, RowCnt: Integer;
begin
  if OD.Execute then
  begin
    FileIn.Lines.LoadFromFile(OD.FileName);
    if FileIn.Lines.Count > 1 then
    begin
      Idx := 1;
      RowCnt := 0;
      while Idx < FileIn.Lines.Count do
      begin
        Inc(RowCnt);

        CSVToText(FileIn.Lines[Idx], Fs, ' ');
        Averages.WsWindDir  := Averages.WsWindDir   + StrToInt('$' + Fs.Fields[1]);
        Averages.WsWindAvr  := Averages.WsWindAvr   + StrToInt('$' + Fs.Fields[2]);
        Averages.WsWindPk   := Averages.WsWindPk    + StrToInt('$' + Fs.Fields[3]);
        Averages.WsTemp     := Averages.WsTemp      + StrToInt('$' + Fs.Fields[4]);
        Averages.WsHumidity := Averages.WsHumidity  + StrToInt('$' + Fs.Fields[5]);
        Averages.WsRainDay  := Averages.WsRainDay   + StrToInt('$' + Fs.Fields[6]);
        Averages.WsRainHour := Averages.WsRainHour  + StrToInt('$' + Fs.Fields[7]);
        Averages.WsRainMin  := Averages.WsRainMin   + StrToInt('$' + Fs.Fields[8]);
        Averages.WsPressure := Averages.WsPressure  + StrToInt('$' + Fs.Fields[9]);
        Averages.WsRSSI     := Averages.WsRSSI      + StrToInt('$' + Fs.Fields[10]);

        Inc(Idx);
      end;

      Averages.WsWindDir  := Averages.WsWindDir   div RowCnt;
      Averages.WsWindAvr  := Averages.WsWindAvr   div RowCnt;
      Averages.WsWindPk   := Averages.WsWindPk    div RowCnt;
      Averages.WsTemp     := Averages.WsTemp      div RowCnt;
      Averages.WsHumidity := Averages.WsHumidity  div RowCnt;
      Averages.WsRainDay  := Averages.WsRainDay   div RowCnt;
      Averages.WsRainHour := Averages.WsRainHour  div RowCnt;
      Averages.WsRainMin  := Averages.WsRainMin   div RowCnt;
      Averages.WsPressure := Averages.WsPressure  div RowCnt;
      Averages.WsRSSI     := Averages.WsRSSI      div RowCnt;

//  0003A 000 00 001 01DE 307 0000 000 00 27C9 B9

      FileOut.Text := Format('%03.3X %02.2X %03.3X %04.4X %03.3X %04.4X %03.3X %02.2X %04.4X %02.2X',
                              [
                                Averages.WsWindDir,
                                Averages.WsWindAvr,
                                Averages.WsWindPk,
                                Averages.WsTemp,
                                Averages.WsHumidity,
                                Averages.WsRainDay,
                                Averages.WsRainHour,
                                Averages.WsRainMin,
                                Averages.WsPressure,
                                Averages.WsRSSI
                              ]);

      FileOut.Lines.Add(Format('%03.3X %02.2X %03.3X %04.4X %03.3X %04.4X %03.3X %02.2X %04.4X %02.2X',
                              [
                                Averages.WsWindDir div 100,
                                Averages.WsWindAvr div 100,
                                Averages.WsWindPk div 100,
                                Averages.WsTemp div 100,
                                Averages.WsHumidity div 100,
                                Averages.WsRainDay div 100,
                                Averages.WsRainHour div 100,
                                Averages.WsRainMin div 100,
                                Averages.WsPressure div 100,
                                Averages.WsRSSI div 100
                              ]));
    end;
  end;
end;

end.
