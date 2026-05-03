unit RoseColours;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TRoseForm = class(TForm)
    C1: TPanel;
    C2: TPanel;
    C3: TPanel;
    C4: TPanel;
    C5: TPanel;
    C6: TPanel;
    SelectedColour: TPanel;
    procedure C1Click(Sender: TObject);
  private
    Index: Byte;
    const Colours: array [0..5] of TColor = ($0000FF, $00FF00, $FF0000,
                                             $00FFFF, $FFFF00, $FF00FF);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RoseForm: TRoseForm;

procedure RoseColourDialog(var RoseIndex: Byte);

implementation

{$R *.dfm}

uses Rose;

procedure RoseColourDialog(var RoseIndex: Byte);
begin
  if RoseForm = nil then
  begin
    Application.CreateForm(TRoseForm, RoseForm);
    RoseForm.Index := RoseIndex;
    RoseForm.SelectedColour.Color := RoseForm.Colours[RoseIndex];
    RoseForm.ShowModal;
    RoseIndex := RoseForm.Index;
    RoseForm.Release;
    RoseForm := nil;
  end;
end;


procedure TRoseForm.C1Click(Sender: TObject);
begin
  SelectedColour.Color := Colours[TWinControl(Sender).Tag];
  Index := TWinControl(Sender).Tag;
  Close;
end;

end.
