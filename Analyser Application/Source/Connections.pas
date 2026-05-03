unit Connections;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, IdStack, LoggerLib;

type
  TConnectionsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    buCancel: TButton;
    Save: TButton;
    IPList: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConnectionsForm: TConnectionsForm;

function OpenConnections(): DWord;

implementation

{$R *.dfm}

function OpenConnections(): DWord;
begin
  Application.CreateForm(TConnectionsForm, ConnectionsForm);

  with ConnectionsForm do
  begin
    TIdStack.IncUsage;

    GStack.AddLocalAddressesToList(IPList.Items);

    ShowModal;

    case ModalResult of
    mrOK:     if IPList.ItemIndex >= 0 then
                Result := IPTextToIP32(IPLIst.Items[IPList.ItemIndex])
              else
                Result := 0;
    mrCancel: Result := 0;
    end;

    TIdStack.DecUsage;
    Release;
  end;
end;

end.
