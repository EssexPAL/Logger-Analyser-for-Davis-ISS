unit net_utils;

interface

uses
{$ifdef VER210}
  Windows, SysUtils, Variants, Classes, Dialogs,
  DB, dbisamtb, Messages, Graphics, Controls, Forms,
  StdCtrls, Winsock, StrUtils, WinSvc, Vcl.StdCtrls,
{$else}
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes, Vcl.Dialogs, System.UITypes,
  WinAPi.Winsock, Winapi.WinSvc, System.StrUtils, winTypes,
{$endif}

  IdBaseComponent,
  IdComponent, IdRawBase, IdRawClient, IdIcmpClient, idGlobal, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, IdFTPCommon, IdMessage, IdSMTP, idAttachment, idAttachmentFile,
  IdSSLOpenSSL, at_gen_utils, wininet;

type
  TSunB = packed record
    s_b1, s_b2, s_b3, s_b4: byte;
  end;

  TSunW = packed record
    s_w1, s_w2: word;
  end;

  PIPAddr = ^TIPAddr;
  TIPAddr = record
    case integer of
      0: (S_un_b: TSunB);
      1: (S_un_w: TSunW);
      2: (S_addr: longword);
  end;

 IPAddr = TIPAddr;

  PICMP_ECHO_REPLY = ^ICMP_ECHO_REPLY;
  ICMP_ECHO_REPLY = packed record
    Address : IPAddr;
    Status : ULONG;
    RoundTripTime : ULONG;
    DataSize : WORD;
    Reserved : WORD;
    Data : Pointer;
    DataSpace: array [0..7] of Byte;
  end;

  PIP_OPTION_INFORMATION = ^IP_OPTION_INFORMATION;
  IP_OPTION_INFORMATION = packed record
    Ttl : byte;
    Tos : byte;
    Flags : byte;
    OptionsSize : byte;
    OptionsData : Pointer;
  end;

  PAddrInfoW = ^ADDRINFOW;

  ADDRINFOW = record
    ai_flags        : Integer;      // AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST
    ai_family       : Integer;      // PF_xxx
    ai_socktype     : Integer;      // SOCK_xxx
    ai_protocol     : Integer;      // 0 or IPPROTO_xxx for IPv4 and IPv6
    ai_addrlen      : size_t;        // Length of ai_addr
    ai_canonname    : PWideChar;    // Canonical name for nodename
    ai_addr         : PSOCKADDR;    // Binary address
    ai_next         : PAddrInfoW;   // Next structure in linked list
  end;

  ipHostAddr = array of String;

function  IcmpCreateFile : DWORD; stdcall; external 'icmp.dll';
function  IcmpCloseHandle(const IcmpHandle : DWORD) : longbool; stdcall; external 'icmp.dll';
function  IcmpSendEcho(const IcmpHandle: DWORD; const DestinationAddress: IPAddr ;const RequestData: Pointer;const RequestSize : WORD;const RequestOptions : PIP_OPTION_INFORMATION;const ReplyBuffer : Pointer;const ReplySize : DWORD;const TimeOut : DWORD) : DWORD; stdcall; external 'icmp.dll';
//function  IcmpSendEcho2(const IcmpHandle: DWORD; const DestinationAddress: IPAddr ;const RequestData: Pointer;const RequestSize : WORD;const RequestOptions : PIP_OPTION_INFORMATION;const ReplyBuffer : Pointer;const ReplySize : DWORD;const TimeOut : DWORD) : DWORD; stdcall; external 'icmp.dll';

function  IcmpPing(Addr: Variant; WaitTime: Integer): Boolean;

function  DottedToInt(Input: String): DWord;
function  IntToDotted(Input: DWord): String;
//function  SendSMTPMail(Settings: TEMailConfig; SessionName, DatabaseName: String): Boolean;
//function  CollectMailData(ErrorMsg: String; State: Boolean; MailClient: TidSMTP; Msg: TidMessage): String;
//procedure DumpMailData(SessionName, DatabaseName, TableName, Data: String);
function  GetIPAddress: String;
function  GetAddrInfoW(nodename: PWideChar; servname: PWideChar; hints: PADDRINFOW; var res: PADDRINFOW): Integer; stdcall; external 'ws2_32.dll';
function  FreeAddrInfoW(Data: PADDRINFOW): Integer; stdcall; external 'ws2_32.dll';
function  ServerNameToAddress(ServerName: String): ipHostAddr;
function  SubstituteHostNameforIPAddr(HostPath: String): String;
function  ExtractHostName(Path: String): String;
function  ValidateWebAddress(var url: String; ForceLower: Boolean): Boolean;


implementation

function ValidateWebAddress(var url: String; ForceLower: Boolean): Boolean;
var
  hSession, hfile: hInternet;
  dwindex, dwcodelen: Dword;
  dwcode: array[1..20] of Char;
  res : pchar;
begin
  Result := false;

  if ForceLower then
    url := LowerCase(url);

  if pos('http',lowercase(url)) = 0 then
    url := 'http://' + url;

  if Pos('https:', url) > 0 then
    url := StringReplace(url, 'https:', 'http:', [rfReplaceAll, rfIgnoreCase]);

  hSession := InternetOpen('InetURL:/1.0', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if assigned(hsession) then
  begin
    hfile := InternetOpenUrl(hsession, pchar(url), nil, 0, INTERNET_FLAG_RELOAD, 0);
    dwIndex := 0;
    dwCodeLen := 10;
    HttpQueryInfo(hfile, HTTP_QUERY_STATUS_CODE, @dwcode, dwcodeLen, dwIndex);
    res := pchar(@dwcode);
    Result:= (res = '200') or (res = '302');
    if assigned(hfile) then
      InternetCloseHandle(hfile);

    InternetCloseHandle(hsession);
  end;
end;

function ExtractHostName(Path: String): String;
var
  St, En : Integer;
begin
  Result := Path;

  St := 1;
  En := Length(Path);
  St := Pos('\\', Path);

{$ifdef VER210}
  En := Pos('\', Path[St + 2]) - 1;
{$else}
  En := Pos('\',  Path, St + 2) - 1;
{$endif}

  if St > 0 then
    Inc(St, 2);

  Result := Copy(Path, St, En - St + 1);
end;

function SubstituteHostNameforIPAddr(HostPath: String): String;
var
  St, En : Integer;
  Host: String;
  Address: IpHostAddr;
begin
  Result := HostPath;

  St := 1;
  En := Length(HostPath);
  St := Pos('\\', HostPath);

{$ifdef VER210}
  En := Pos('\',  HostPath[St + 2]) - 1;
{$else}
  En := Pos('\',  HostPath, St + 2) - 1;
{$endif}

  if St > 0 then
    Inc(St, 2);

  Host := Copy(HostPath, St, En - St + 1);

  Address := ServerNameToAddress(Host);
  if Length(Address) > 0 then
    Result := ReplaceStr(HostPath, Host, Address[0]);
end;

function ServerNameToAddress(ServerName: String): ipHostAddr;
var
  SocketHint: AddrInfoW;
  PSocketData, Addr: PAddrInfoW;
  Twsad: TWSAData;
  St: Integer;
begin
  WSAStartup(MakeWord(2, 2), Twsad);

  if Pos('\\', ServerName) > 0 then
    ServerName := ExtractHostName(ServerName);

  ZeroMemory(@SocketHint, SizeOf(SocketHint));
  SocketHint.ai_family    := AF_INET; // IPv4 addresses
  SocketHint.ai_socktype  := SOCK_STREAM;
  SocketHint.ai_protocol  := IPPROTO_TCP;

  St := 1;
  if GetAddrInfoW(PWideChar(ServerName), nil, @SocketHint, PSocketData) = 0 then
  begin
    Addr := PSocketData;
    while Addr <> nil do
    begin
      SetLength(Result, St);
      Result[St - 1] := inet_ntoa(addr^.ai_addr.sin_addr);
      Addr := Addr.ai_next;
      Inc(St);
    end;
  end else
  begin
    SetLength(Result, 1);
    Result[0] := 'UNABLE_TO RESOLVE_HOST_NAME';
  end;

  FreeAddrInfoW(PSocketData);
  WSACleanup;
end;

function IntToDotted(Input: DWord): String;
begin
  Result := '';
  Result := Result + IntToStr((Input and $FF000000) shr  24) + '.';;
  Result := Result + IntToStr((Input and $00FF0000) shr  16) + '.';
  Result := Result + IntToStr((Input and $0000FF00) shr   8) + '.';
  Result := Result + IntToStr((Input and $000000FF) shr   0);
end;

function DottedToInt(Input: String): DWord;
var
  Fs: TFieldSet;
begin
  Result := 0;

  if Input = ''  then
    Exit;

  CSVToText(Input, Fs, '.');

  if Fs.Count <> 4 then
  begin
    MessageDlg('The device address is not properly formed ', mtWarning, [mbOK], 0);
    Exit;
  end;

  Result :=            StrToInt(Fs.Fields[3]) shl  0;
  Result := Result or (StrToInt(Fs.Fields[2]) shl  8);
  Result := Result or (StrToInt(Fs.Fields[1]) shl 16);
  Result := Result or (StrToInt(Fs.Fields[0]) shl 24);

end;

function IcmpPing(Addr: Variant; WaitTime: Integer): Boolean;
var
  hICMP : HWnd;
  dwSize : DWORD;
  DW: DWord;
  IPAddr: TIPAddr;
  EchoReply: ICMP_ECHO_REPLY;

  // big to little endian
  function  DWSwap(Value: DWord): DWord;
  var
    pO: pByte;
    b: Byte;
  begin
    Result := Value;

    pO := @Result;

    b := (pO + 0)^; // Swap bytes 0 and 3
    (pO + 0)^ := (pO + 3)^;
    (pO + 3)^ := b;

    b := pO[2];
    pO[2] := pO[1];
    pO[1] := b;
  end;

begin
  Result := False;
  hICMP := IcmpCreateFile;

  if hICMP <> INVALID_HANDLE_VALUE then
  begin
    try
      dwSize := SizeOf(ICMP_ECHO_REPLY);

      case VarType(Addr) and VarTypeMask of
      varString:    IPAddr.S_addr := DWSwap(DottedToInt(Addr));
      varUString:   IPAddr.S_addr := DWSwap(DottedToInt(Addr));
      varLongWord:  IPAddr.S_addr := DWSwap(Addr);
      varInteger:   IPAddr.S_addr := DWSwap(Addr);
      else
        begin
          ShowMessage('IcmpPing() invalid variant type!');
          Result := False;
          Exit;
        end;
      end;

      DW := IcmpSendEcho(hICMP, IPAddr, nil, 0, nil, @EchoReply, dwSize, WaitTime);

      Result := (EchoReply.Status = 0);
    finally
      IcmpCloseHandle(hICMP);
    end;
  end;
end;

function GetIPAddress():String;
type
  pu_long = ^u_long;
var
  varTWSAData: TWSAData;
  varPHostEnt: PHostEnt;
  varTInAddr:  TInAddr;
  namebuf:    array[0..255] of Ansichar;
begin
  if WSAStartup($101,varTWSAData) <> 0 then
    Result := 'No. IP Address'
  else
  begin
    gethostname(namebuf, sizeof(namebuf));
    varPHostEnt := gethostbyname(namebuf);
    varTInAddr.S_addr := u_long(pu_long(varPHostEnt^.h_addr_list^)^);
    Result := inet_ntoa(varTInAddr);
  end;

  WSACleanup;
end;

end.
