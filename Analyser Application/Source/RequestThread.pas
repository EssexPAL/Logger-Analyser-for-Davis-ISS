unit RequestThread;

interface

uses
  ShareMem,
  WinApi.Windows, System.Classes, At_gen_utils, System.SysUtils, Vcl.Dialogs, Defs,
  Vcl.StdCtrls, Services;

(* This thread is intended to runs the service stop/start code.
 * It starts at on app creation, remains suspended until needed
 ^ and is destroyed on app destruction.
 *)

type

  TStopStartThread = class(TThread)
  private
    FBuf: array [0..255] of WideChar;
    FMn: String;
    FSize: Dword;
    FServiceName: String;
    FStop: Boolean;
  public
    constructor Create;
    procedure ForceStop;
  protected
    procedure Execute; override;
  published
    property ServiceName: String read FServiceName write FServiceName;
  end;

  TLiveDataThread = class(TThread)
  private
    FBuf: array [0..255] of WideChar;
    FMn: String;
    FSize: Dword;
    FServiceName: String;
  public
    constructor Create;
  protected
    procedure Execute; override;
  published
    property ServiceName: String read FServiceName write FServiceName;
  end;


implementation

function GetMachineName(): String;
var
  MnBuf: array [0..255] of WideChar;
  MnSize, Idx: Dword;
begin

  MnSize := 255;
  GetComputerName(@MnBuf, MnSize);

  Result := '\';
  Idx := 0;
  while MnBuf[Idx] <> #0 do
  begin
    Result := Result + MnBuf[Idx];
    Inc(Idx);
  end;
end;

// *************************************

constructor TStopStartThread.Create;
begin
  inherited Create(True);

  FMn := GetMachineName;
  FStop := False;
end;

procedure TStopStartThread.ForceStop;
begin
  Self.Terminate;
  Self.Resume;
end;

procedure TStopStartThread.Execute;
var
  Info: String;
begin
  while not Terminated do
  begin
    ServiceStop(FServiceName, Info);
    ServiceStart(FserviceName, Info);
    Suspend;
  end;
end;

// *************************************

constructor TLiveDataThread.Create;
begin
  inherited Create(True);

  FMn := GetMachineName;
end;

procedure TLiveDataThread.Execute;
begin
  while not Terminated do
  begin

    Suspend;
  end
end;



end.


