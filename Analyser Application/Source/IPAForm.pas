unit IPAForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TIPEditForm = class(TForm)
    Label1: TLabel;
    mIPA: TMemo;
    buCancel: TButton;
    buSave: TButton;
    procedure mIPAKeyPress(Sender: TObject; var Key: Char);
    procedure buSaveClick(Sender: TObject);
    procedure buCancelClick(Sender: TObject);
  private
    Addr: String;
    Validated: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IPEditForm: TIPEditForm;

  function IPAEdit(var AddList: String): Boolean;
  function ValidateAddressLines(s: String): Boolean;

implementation

{$R *.dfm}

function IPAEdit(var AddList: String): Boolean;
begin
  Application.CreateForm(TIPEditForm, IPEditForm);
// Add the source list to the IP list for editing
  IPEditForm.Addr := AddList;
  IPEditForm.mIPA.Text := AddList;

  IPEditForm.ShowModal;

// ensure tha the lines are correctly formatted xxx.xxx.xxx.xxx
  Result := IPEditForm.Validated;

  if Result then
    AddList := IPEditForm.Addr;

  IPEditForm.Release;
end;

// Remove empty lines and validate the format of the addresses
function ValidateAddressLines(s: String): boolean;
var
  Sl: TStringList;
  DigitCount: array [0..6] of Byte; // allow for malformed addresses
  Line, I, OctetCount, OctetIdx, DotCount: Integer;
  AddressIsValid: Boolean;
begin
  Result := True;

  try
    Sl := TStringList.Create;
    Sl.Text := s;

    Line := 0;
    while Line < Sl.Count do
    begin
      if Sl.Strings[Line] = '' then
        Sl.Delete(Line)
      else
      begin
        for I := 0 to 3 do
          DigitCount[I] := 0;

        OctetCount := 0;
        OctetIdx := 0;
        DotCount := 0;

        for I := 1 to Length(Sl.Strings[Line]) do
        begin
          case Sl.Strings[Line][I] of
          '0'..'9': Inc(DigitCount[OctetIdx]);
          '.':      begin
                      Inc(DotCount);
                      Inc(OctetIdx);
                    end;
          end;
        end;

        AddressIsValid := (DotCount = 3) and
                          (DigitCount[0] in [1..3]) and
                          (DigitCount[1] in [1..3]) and
                          (DigitCount[2] in [1..3]) and
                          (DigitCount[3] in [1..3]);

        if not AddressIsValid then
        begin
          Result := AddressIsValid;
          break;
        end;

        Inc(Line);
      end;
    end;
  finally
    Sl.Free;
  end;
end;

procedure TIPEditForm.buCancelClick(Sender: TObject);
begin
  Validated := False;
  Close;
end;

procedure TIPEditForm.buSaveClick(Sender: TObject);
begin
  Validated := ValidateAddressLines(mIPA.Text);
  if not Validated then
    MessageDlg('One or more IP addresses are incorrectly formed!', mtWarning, [mbOK], 0)
  else
  begin
    Addr := mIPA.Text;
    Close;
  end;
end;

procedure TIPEditForm.mIPAKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', '.', #8, #13]) then
    Key := #0;
end;

end.
