unit IcmpPing;

interface

function PingHost(const HostName: AnsiString; TimeoutMS: cardinal = 500): boolean;

implementation

uses Windows, SysUtils, WinSock;

function IcmpCreateFile: THandle; stdcall; external 'iphlpapi.dll';
function IcmpCloseHandle(icmpHandle: THandle): boolean; stdcall; external 'iphlpapi.dll';
function IcmpSendEcho(icmpHandle: THandle; DestinationAddress: In_Addr;
            RequestData: Pointer; RequestSize: Smallint; RequestOptions: Pointer;
            ReplyBuffer: Pointer; ReplySize: DWORD; Timeout: DWORD): DWORD; stdcall;
            external 'iphlpapi.dll';

type
  TEchoReply = packed record
    Addr: In_Addr;
    Status: DWORD;
    RoundTripTime: DWORD;
    DataSize: Word;
    Reserved: Word;
    Data: pChar;
//  struct ip_option_information Options;
  end;

  PEchoReply = ^TEchoReply;

var
  WSAData: TWSAData;

function PingHost(const HostName: AnsiString; TimeoutMS: cardinal = 500): Boolean;
const
  rSize = $400;
var
  e: PHostEnt;
  a: PInAddr;
  h: THandle;
  d: string;
  r: array [0 .. rSize - 1] of byte;
  i, wsaOK, First: cardinal;
  s: AnsiString;
begin
  First := Length(HostName);
  while First > 0 do
  begin
    if not (HostName[First] in ['.', '0'..'9']) then
    begin
      s := Copy(HostName, First + 1, Length(HostName) - First);
      Break;
    end;
    Dec(First);
  end;

  wsaOK := WSAStartup($0101, WSAData);

  if wsaOK = 0 then
  begin
// make an integer ip address
    e := gethostbyname(PAnsiChar(s));
    if e <> nil then
    begin

      if e.h_addrtype = AF_INET then
      begin
//      add address to structure
        Pointer(a) := e.h_addr^;
//      make some data
        d := FormatDateTime('yyyymmddhhnnsszzz', Now);
//      get handle
        h := IcmpCreateFile;

//      if handle is valid then go ahead
        if h <> INVALID_HANDLE_VALUE then
        begin
          try
            i := IcmpSendEcho(h, a^, PChar(d), Length(d), nil, @r[0], rSize, TimeoutMS);
//          correct return = at least one reply structure and status = zero
            Result := (i <> 0) and (PEchoReply(@r[0]).Status = 0);
          finally
            IcmpCloseHandle(h);
          end;
        end;
      end;
    end;
    WSACleanup;
  end;
end;


end.
