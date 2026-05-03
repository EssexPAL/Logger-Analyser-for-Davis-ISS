unit EditData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Defs, VirtualTrees, Vcl.StdCtrls,
  Vcl.ExtCtrls, LoggerLib;

type
  TNodeData = record
    Title: String;
    Data: Integer;
  end;

  pNodeData = ^TNodeData;

  TDataEditForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    buSave: TButton;
    vstEdit: TVirtualStringTree;
    Panel3: TPanel;
    DDTLabel: TLabel;
    buCancel: TButton;
    Memo1: TMemo;
    procedure vstEditGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure FormActivate(Sender: TObject);
    procedure buSaveClick(Sender: TObject);
    procedure vstEditEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure vstEditNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: string);
  private
    FData: pWsData;
    FSave: Boolean;
    FTemp: TWSData;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataEditForm: TDataEditForm;


const
  Titles: array [0..9] of String = ('Wind Direction', 'Wind Speed Avr.', 'Wind Speed Pk.', 'Temperature',
                                    'Humidity', 'Rain (Day)', 'Rain (Hour)', 'Rain (Min)', 'Pressure', 'RSSI');

function EditDataRow(var Data: pWsData): Boolean;


implementation

{$R *.dfm}

function EditDataRow(var Data: pWsData): Boolean;
begin
  Application.CreateForm(TDataEditForm, DataEditForm);

  with DataEditForm do
  begin
    FData := Data;
    FSave := False;
    FTemp := Data^; // keep a copy of the data
    DDTLabel.Caption := ATDateTimeToStr(Data.Date, Data.Time);
    ShowModal;
    Result := ModalResult = mrOK;

// if cancelled then restore original data
    if not Result then
    begin
      Data.Dir    := FTemp.Dir;
      Data.AvrSpd := FTemp.AvrSpd;
      Data.PkSpd  := FTemp.PkSpd;
      Data.Temp   := FTemp.Temp;
      Data.Humid  := FTemp.Humid;
      Data.Day    := FTemp.Day;
      Data.Hour   := FTemp.Hour;
      Data.Min    := FTemp.Min;
      Data.Pres   := FTemp.Pres;
      Data.Rssi   := ShortInt(FTemp.Rssi);
    end;

    Release;
  end;
end;

// Move the data back to record form
procedure TDataEditForm.buSaveClick(Sender: TObject);
var
  N: pVirtualNode;
  Nd: pNodeData;
  Idx: Integer;
begin
  N := vstEdit.GetFirst;
  Idx := 0;

  repeat
    Nd := vstEdit.GetNodeData(N);
    case Idx of
    0: FData.Dir    := Nd.Data;
    1: FData.AvrSpd := Nd.Data;
    2: FData.PkSpd  := Nd.Data;
    3: FData.Temp   := Nd.Data;
    4: FData.Humid  := Nd.Data;
    5: FData.Day    := Nd.Data;
    6: FData.Hour   := Nd.Data;
    7: FData.Min    := Nd.Data;
    8: FData.Pres   := Nd.Data;
    9: FData.Rssi   := ShortInt(Nd.Data);
    end;
    Inc(Idx);
    N := vstEdit.GetNext(N);
  until N = nil;
end;

procedure TDataEditForm.FormActivate(Sender: TObject);
var
  Idx: Integer;
  N: pVirtualNode;
  Nd: pNodeData;
begin
  vstEdit.NodeDataSize := sizeof(TWsData);

// Move the data into list form
  Idx := 0;
  while Idx < Length(Titles) do
  begin
    N := vstEdit.AddChild(nil);
    Nd := vstEdit.GetNodeData(N);
    Nd.Title := Titles[Idx];
    case Idx of
    0:  Nd.Data := FData.Dir;
    1:  Nd.Data := FData.AvrSpd;
    2:  Nd.Data := FData.PkSpd;
    3:  Nd.Data := FData.Temp;
    4:  Nd.Data := FData.Humid;
    5:  Nd.Data := FData.Day;
    6:  Nd.Data := FData.Hour;
    7:  Nd.Data := FData.Min;
    8:  Nd.Data := FData.Pres;
    9:  Nd.Data := ShortInt(FData.Rssi);
    end;
    Inc(Idx);
  end;
end;

procedure TDataEditForm.vstEditEdited(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  Nd: pNodeData;
begin
  Nd := Sender.GetNodeData(Node);
  FData.Dir := Nd.Data;
end;

procedure TDataEditForm.vstEditGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Nd: pNodeData;
begin
  Nd := Sender.GetNodeData(Node);
  case Column of
  0:  CellText := Nd.Title;
  1:  CellText := Nd.Data.ToString();
  end;
end;

procedure TDataEditForm.vstEditNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  Nd: pNodeData;
begin
  Nd := Sender.GetNodeData(Node);
  Nd.Data := NewText.ToInteger();
end;

end.
