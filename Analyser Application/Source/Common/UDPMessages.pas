unit UDPMessages;

(* This unit provides all the comms to the logger unit.  It uses the Indy 10 UDP
   functionality. Creating and destroying the client ensures that the port is
   held for the minimum time. *)

interface

uses
  ShareMem,
  Winapi.Windows, System.Classes,  System.SysUtils, System.Math, Vcl.ComCtrls,
  Vcl.Forms, Vcl.Dialogs,
  IdComponent, IdUDPBase, IdUDPServer, IdGlobal, IdUDPClient,
  LoggerLib, ulkJson, Defs, LiveData, System.IOUtils, ATUtils;

  procedure SetIp(HostIP: String; ServerIP: String; Port: Word);
// blocking
  function  UDPGetDir(var Data, Info: String; PB: TProgressBar = nil): Boolean;
  function  UDPGetStatus(var Data, Info: String):Boolean;
  function  UDPGetRTData(var Ld: TLiveData): Boolean;
  function  UDPGetFile(FileName, Directory: String; var Data, Info: String; PB: TProgressBar = nil): Boolean; overload;
  function  UDPGetFile(FileName, Directory: String; var Data: String; Silent: Boolean): Boolean; overload;

  function  UDPEraseFile(FileName, Directory: String;  var Info: String): Boolean;
  function  UDPGetRemDir(Data: TStringList; Silent: Boolean): Boolean;

  procedure UDPRemoteRestart();
  function  makeUDPRequest(cmd: TLoggerCmd; IP: DWord; FileName: String): String; overload;
  function  makeUDPRequest(cmd: TLoggerCmd; IP: String; FileName: String): String; overload;

// non-blocking support
  procedure UDPProcessDir(js: TlkJSONobject; var Data: TFileInfo);
  function  UDPProcessStatus(js: TlkJSONobject; var Data, Info: String): boolean;
  procedure ProcessDirData(var Data: String);



implementation

procedure SetIp(HostIP: String; ServerIP: String; Port: Word);
begin
    __UdpIP.Host := HostIP;
  __UdpIP.Server := ServerIP;
  __UdpIP.Port := Port;
end;

function IPTextToIP32(IP: String): DWord;
var
  Fs: TFieldSet;
begin
  CSVToText(IP, Fs, '.');
  Result :=             StrToInt(Fs.Fields[3]) shl 24;
  Result := Result or ( StrToInt(Fs.Fields[2]) shl 16);
  Result := Result or ( StrToInt(Fs.Fields[1]) shl  8);
  Result := Result or ( StrToInt(Fs.Fields[0]));
end;

function makeUDPRequest(cmd: TLoggerCmd; IP: DWord; FileName: String): String;
var
  js: TlkJSONobject;
begin
  js := TlkJSONobject.Create;

  js.Add('rq', byte(cmd));
  js.Add('ip', IP);

  if cmd in [lcEraseFile, lcGetFile] then
    js.Add('fn', FileName);

  Result := TlkJSON.GenerateText(js);
end;

function makeUDPRequest(cmd: TLoggerCmd; IP: String; FileName: String): String;
var
  js: TlkJSONobject;
begin
  js := TlkJSONobject.Create;

  js.Add('rq', byte(cmd));
  js.Add('ip', IP);

  if cmd in [lcEraseFile, lcGetFile] then
    js.Add('fn', FileName);

  Result := TlkJSON.GenerateText(js);
end;
(*
 LOGGER INFORMATION

                    Boot Time:  03/10/2023 03:00:21*
                   Server Time: 10:09:00* (36540)
              WiFi Module RSSI: -69dBm (79uV)
                RF Module RSSI: -68dBm (89uV)
              Packets Received:   9975
                Missed packets:      4
                    CRC Errors:    128
              Files on SD card:    216
            Bytes used SD card:    15.2 MB
    Space remaining on SD card:     1.9 GB
                 Battery State:  OK
                Connected SSID:  PLUSNET-236J
              Firmware Version:  1.13.10_(21/09/23)

  {"mi":2,"bd":8676,"bt":71583,"ct":71711,"is":1,"wr":182,"rr":65468,"pr":48,
   "pm":0,"pc":0,"fc":73,"bu":"1.14.1_(29/09/23)","bl":4001038336,"bs":0,"ss":"PLUSNET-236J"}
*)

function UDPProcessStatus(js: TlkJSONobject; var Data, Info: String): boolean;
  function TouV(Value: Integer): String;
  var
    e: Single;
    sub: String;
  const
    V_ZERODBM = 0.2236; // volts

  begin
    sub := 'mV';
    e := (V_ZERODBM / Power(10, (Abs(Value) / 20))) * 1E3; // to mV

    if (e < 1) then
    begin
      e := e * 1E3; // yo uV
      sub := 'uV';
    end;

    Result := Format('%ddBm (%s%s)', [Value, Round(e).ToString(), sub]);
  end;
var
  s1, s2: String;
  msgno: Integer;
  Output: TStringList;
  SendStr: String;
  TxTxt: TIdBytes;
const
  st: array [0..1] of String = (' ', '*');
  bs: array [0..1] of String = ('OK', 'FAULTY');
begin
  Output := TStringList.Create;

  try
    Output.Text := ' Logger information';
    Output.Add('');

//'{"mi":2,"bd":8691,"bt":21420,"ct":23429,"is":1,"wr":-77,"rr":-65,"pr":712,"pm":33,"pc":0,"fc":2833,"bu":4587520,"bl":4000972800,"bs":0,"ss":"PLUSNET-236J","fv":"1.14.1_(29/09/23)"}'#0

    if Data.Length = 0 then
    begin
      Info := Format('The server %s:%d did not respond or return any data', [__UdpIp.Server, __UdpIp.Port]);
      Exit(False);
    end;

    js := TlkJSON.ParseText(Data) as TlkJSONobject;

    s1 := ATDateTimeToStr(js.Field['bd'].Value, js.Field['bt'].Value);
    s2 := ATTimeToStr(js.Field['ct'].Value);

    Output.Add(Format('%28s %s',             ['Boot Time:',   ATDateTimeToStr(js.Field['bd'].Value, js.Field['bt'].Value)]));
    Output.Add(Format('%28s %s%s  (%d)',     ['Server Time:', ATTimeToStr(js.Field['ct'].Value),
                                                              st[byte(js.Field['is'].Value)],
                                                              integer(js.Field['ct'].Value)
                                             ]));

    Output.Add(Format('%28s %s',             ['WiFi module RSSI:',  TouV(js.Field['wr'].Value)]));
    Output.Add(Format('%28s %s',             ['RFM Module RSSI:',   TouV(js.Field['rr'].Value)]));
    Output.Add(Format('%28s %6s',            ['Packets received:',  js.Field['pr'].Value]));
    Output.Add(Format('%28s %6s',            ['Packets missed:',    js.Field['pm'].Value]));
    Output.Add(Format('%28s %6s',            ['CRC Errors:',        js.Field['pc'].Value]));
    Output.Add(Format('%28s %6d',            ['Files on SD card:',        Int64(js.Field['fc'].Value)]));
    Output.Add(Format('%28s %s',             ['Bytes used on SD card:',   DiskSizeToString(Int64(js.Field['bu'].Value))]));
    Output.Add(Format('%28s %s',             ['Space remaining SD card:', DiskSizeToString(Int64(js.Field['bl'].Value))]));
    Output.Add(Format('%28s %6s',            ['Battery state:',           bs[Byte(js.Field['bs'].Value)]]));
    Output.Add(Format('%28s %6s',            ['Connected SSID:',          js.Field['ss'].Value]));
    Output.Add(Format('%28s %s',             ['Firmware version:',        js.Field['fv'].Value]));

  finally
    Info := Format('Status returned ok - Bytes %d', [Data.Length]);
    Data := Output.Text;
    OutPut.Free;
  end;
end;

function UDPGetStatus(var Data, Info: String): boolean;
  function TouV(Value: Integer): String;
  var
    e: Single;
    sub: String;
  const
    V_ZERODBM = 0.2236; // volts

  begin
    sub := 'mV';
    e := (V_ZERODBM / Power(10, (Abs(Value) / 20))) * 1E3; // to mV

    if (e < 1) then
    begin
      e := e * 1E3; // yo uV
      sub := 'uV';
    end;

    Result := Format('%ddBm (%s%s)', [Value, Round(e).ToString(), sub]);
  end;
var
  s1, s2, RxData: String;
  UDP: TIdUDPClient;
  js: TlkJSONobject;
  msgno: Integer;
  Output: TStringList;
  SendStr: String;
  TxTxt: TIdBytes;
const
  st: array [0..1] of String = (' ', '*');
  bs: array [0..1] of String = ('OK', 'FAULTY');
begin
  Result := True;
  UDP := TIdUDPClient.Create(nil);
  Output := TStringList.Create;

  SendStr := makeUDPRequest(lcLoggerStatus, __UdpIp.Host, '');
  SetLength(TxTxt, SendStr.Length);
  TxTxt := ToBytes(SendStr);

  try
    try
      UDP.BoundIP         := __UdpIp.Host;
      UDP.BoundPort       := __UdpIp.Port;
      UDP.ReceiveTimeout  := UDP_TIMEOUT;
      UDP.SendBuffer(__UdpIp.Server, __UdpIp.Port, TxTxt);

      RxData := UDP.ReceiveString(UDP_STATUS_TIMEOUT);
      Output.Text := ' Logger information';
      Output.Add('');
    except
      on e:exception do
      begin
        Info := Format('Get status error: %s', [e.Message]);
        Exit(False);
      end;
    end;

    if RxData.Length = 0 then
    begin
      Info := Format('The server %s:%d did not respond or return any data', [__UdpIp.Server, __UdpIp.Port]);
      Exit(False);
    end;

    js := TlkJSON.ParseText(RxData) as TlkJSONobject;

    s1 := ATDateTimeToStr(js.Field['bd'].Value, js.Field['bt'].Value);
    s2 := ATTimeToStr(js.Field['ct'].Value);

    Output.Add(Format('%28s %s',             ['Boot Time:',               ATDateTimeToStr(js.Field['bd'].Value, js.Field['bt'].Value)]));
    Output.Add(Format('%28s %s%s  (%d)',     ['Server Time:',             ATTimeToStr(js.Field['ct'].Value),
                                                                          st[byte(js.Field['is'].Value)],
                                                                          integer(js.Field['ct'].Value)
                                             ]));

    Output.Add(Format('%28s %s',             ['WiFi module RSSI:',        TouV(js.Field['wr'].Value)]));
    Output.Add(Format('%28s %s',             ['RFM Module RSSI:',         TouV(js.Field['rr'].Value)]));
    Output.Add(Format('%28s %6s',            ['Packets received:',        js.Field['pr'].Value]));
    Output.Add(Format('%28s %6s',            ['Packets missed:',          js.Field['pm'].Value]));
    Output.Add(Format('%28s %6s',            ['CRC Errors:',              js.Field['pc'].Value]));
    Output.Add(Format('%28s %6d',            ['Files on SD card:',        Int64(js.Field['fc'].Value)]));

//  disk used and left
    Output.Add(Format('%28s %s',             ['Bytes used on SD card:',   js.Field['bu'].Value]));
    Output.Add(Format('%28s %s',             ['Space remaining SD card:', js.Field['bl'].Value]));

    if js.IndexOfName('bs') >= 0 then
      Output.Add(Format('%28s %6s',          ['Battery state:',           bs[Byte(js.Field['bs'].Value)]]));

    Output.Add(Format('%28s %6s',            ['Connected SSID:',          js.Field['ss'].Value]));
    Output.Add(Format('%28s %s',             ['Firmware version:',        js.Field['fv'].Value]));

    Data := Output.Text;

    Info := Format('Status returned ok - Bytes %d', [Data.Length]);
  finally
    UDP.Free;
    OutPut.Free;
  end;
end;

function UDPGetRTData(var Ld: TLiveData): Boolean;
var
  UDP: TIdUDPClient;
  TxTxt: TIdBytes;
  RxData: String;
  js: TlkJSONobject;
begin
  Result := False;
  RxData := '';
  UDP := TIdUDPClient.Create(nil);

  TxTxt := ToBytes(makeUDPRequest(lcLiveData, __UdpIp.Host, ''));

  try
    try
      UDP.BoundIP         := __UdpIp.Host;
      UDP.BoundPort       := __UdpIp.Port;
      UDP.ReceiveTimeout  := UDP_TIMEOUT;

      UDP.SendBuffer(__UdpIp.Server, __UdpIp.Port, TxTxt);

//    dont wait long for reply.  If it is going to come it will be within 250mS
      RxData := UDP.ReceiveString(UDP_TIMEOUT);
    except
      on e:exception do
      begin
        ;
      end;
    end;

    if RxData.Length > 0 then
    begin
      js := TlkJSON.ParseText(RxData) as TlkJSONobject;
      Result := True;
      UpdateLiveData(js, Ld);
    end;
  finally
    UDP.Free;
  end;
end;

procedure UDPRemoteRestart();
var
  UDP: TIdUDPClient;
  TxTxt: TIdBytes;
begin
  UDP := TIdUDPClient.Create(nil);

  TxTxt := ToBytes(makeUDPRequest(lcRestart, IPTextToIP32(__UdpIp.Host), ''));

  try
      UDP.BoundIP         := __UdpIp.Host;
      UDP.BoundPort       := __UdpIp.Port;
      UDP.ReceiveTimeout  := UDP_TIMEOUT;

//    The restart is immediate so no reply
      UDP.SendBuffer(__UdpIp.Server, __UdpIp.Port, TxTxt);
  finally
    UDP.Free;
  end;
end;

function UDPEraseFile(FileName, Directory: String;  var Info: String): Boolean;
var
  Data: String;
  TxTxt: TIdBytes;
  UDP: TIdUDPClient;
  js: TlkJSONobject;
  ak: Integer;
const
  del: array [0..1] of String = (' NOT', '');

begin
  Result := False;
  UDP := TIdUDPClient.Create(nil);

  try
    if FileName.Length = 0 then
      raise Exception.Create('A filename has not been specified!');

    try
      UDP.BoundIP         := __UdpIp.Host;
      UDP.BoundPort       := __UdpIp.Port;
      UDP.ReceiveTimeout  := UDP_TIMEOUT;

      TxTxt := ToBytes(makeUDPRequest(lcEraseFile, __UdpIp.Host, Directory + FileName));

      UDP.SendBuffer(__UdpIp.Server, __UdpIp.Port, TxTxt);

      Data := UDP.ReceiveString(UDP_TIMEOUT);

      if Data.Length = 0 then
        raise Exception.Create(Format('The server %s did not respond', [__UdpIp.Server]));

//    {"mi":5,"ak":1,"fn":"/Data/WsData230724.dat"}
      js := TlkJSON.ParseText(Data) as TlkJSONobject;
      ak := (js.Field['ack'].Value) and 1;
      Result := (ak = 1);
    except
      on e:exception do
      begin
        Info := Format('Error sending message to logger: %s', [e.Message]);
        Exit(False);
      end;
    end;
    Info := Format('Remote file %s%s deleted', [FileName, del[ak]])
  finally
    UDP.Free;
  end;
end;

function UDPGetDir(var Data, Info: String; PB: TProgressBar = nil): Boolean;
var
  DataBlock, SendStr: String;
  TxTxt: TIdBytes;
  UDP: TIdUDPClient;
  js: TlkJSONobject;
  msgno, BlockNo, BlockCount,Blocks: Integer;
  LastBlock: Boolean;
  List: TStringList;
  Idx: Integer;
  DirData: String;
  Fs: TFieldSet;
  Tick: DWord;
begin
  Result := False;
  UDP := TIdUDPClient.Create(nil);
  List := TStringList.Create;
  LastBlock := False;
  Tick := GetTickCount;

  try
    try
      UDP.BoundIP         := __UdpIp.Host;
      UDP.BoundPort       := __UdpIp.Port;
      UDP.ReceiveTimeout  := UDP_TIMEOUT;

//    request directory
      SendStr := makeUDPRequest(lcGetDirectory, __UdpIp.Host, '');
      SetLength(TxTxt, SendStr.Length);
      TxTxt := ToBytes(SendStr);
      DirData := '';

      UDP.SendBuffer(__UdpIp.Server, __UdpIp.Port, TxTxt);

      BlockCount := 0;
      BlockNo    := 0;

      List.Clear;

//    process the returned data block at a time
      while LastBlock = False do
      begin
        Inc(BlockCount);
        DataBlock := UDP.ReceiveString(UDP_TIMEOUT);

        if DataBlock.Length = 0 then
          raise Exception.Create('The server did not respond or return any data');

        js := TlkJSON.ParseText(DataBlock) as TlkJSONobject;
        if js.Field['mi'].Value = lcGetDirectory then
        begin
          LastBlock := js.Field['lb'].Value;
          DataBlock := js.Field['bd'].Value;
          BlockNo   := js.Field['bn'].Value;
          Blocks    := js.Field['bc'].Value;
        end else
          Exit;

        if PB <> nil then
        begin
          if BlockNo = 1 then
            PB.Max := Blocks;

          PB.Position := BlockNo;
          Application.ProcessMessages;
        end;

        if BlockCount <> BlockNo then
        begin
          raise Exception.Create('Packet order error');
          break;
        end;

        DirData := DirData + DataBlock;
      end;
    except
      on e:exception do
      begin
        Info := Format('Get remote directory error: %s', [e.Message]);
        Exit(False);
      end;
    end;

    List.Text := DirData;

    for Idx := 0 to List.Count - 1 do
    begin
      CSVToText(List.Strings[Idx], Fs, ':');
      if Fs.Count = 2 then
        List.Strings[Idx] := Format(' %-18s %6d', [Trim(Fs.Fields[0]), Fs.Fields[1].ToInteger()]);
    end;

    List.Sort;

    Data := List.Text;
    Tick := GetTickCount - Tick;
    Info := Format('%s - Blocks: %d, Bytes: %d, Time: %d mS', ['Get remote directory:', BlockNo, Data.Length, Tick]);

  finally
    Result := LastBlock;
    List.Free;
    UDP.Free;
  end;
end;

function UDPGetRemDir(Data: TStringList; Silent: Boolean): Boolean;
var
  DataBlock, SendStr: String;
  TxTxt: TIdBytes;
  UDP: TIdUDPClient;
  js: TlkJSONobject;
  msgno, BlockNo, BlockCount,Blocks: Integer;
  LastBlock: Boolean;
  Idx: Integer;
  DirData: String;
  Fs: TFieldSet;
begin
  Result := False;
  UDP := TIdUDPClient.Create(nil);
  LastBlock := False;
  Data.Clear;

  try
    try
      UDP.BoundIP         := __UdpIp.Host;
      UDP.BoundPort       := __UdpIp.Port;
      UDP.ReceiveTimeout  := UDP_TIMEOUT;

      SendStr := makeUDPRequest(lcGetDirectory, __UdpIp.Host, '');
      SetLength(TxTxt, SendStr.Length);
      TxTxt := ToBytes(SendStr);
      DirData := '';

      UDP.SendBuffer(__UdpIp.Server, __UdpIp.Port, TxTxt);

      BlockCount := 0;
      BlockNo    := 0;

      while LastBlock = False do
      begin
        Inc(BlockCount);
        DataBlock := UDP.ReceiveString(UDP_TIMEOUT);

        if not Silent and (DataBlock.Length = 0) then
          raise Exception.Create('The server did not respond or return any data');

        if DataBlock.Length > 0 then
        begin
          js := TlkJSON.ParseText(DataBlock) as TlkJSONobject;
//        ensure only getdirectory fields are accessed
          if js.Field['mi'].Value = lcGetDirectory then
          begin
            LastBlock := js.Field['lb'].Value;
            DataBlock := js.Field['bd'].Value;
            BlockNo   := js.Field['bn'].Value;
            Blocks    := js.Field['bc'].Value;
          end else
            Exit(False);
        end;

        if not Silent and (BlockCount <> BlockNo) then
        begin
          raise Exception.Create('Incomplete data/packet order error');
          break;
        end;

        DirData := DirData + DataBlock;
      end;
    except
      on e:exception do
      begin
        Exit(False);
      end;
    end;

    Data.Text := DirData;

(*  Split the directory lines.  Filename goes into
    the strings and the file size goes into the
    objects. *)
    for Idx := 0 to Data.Count - 1 do
    begin
      CSVToText(Data.Strings[Idx], Fs, ':');
      Data.Strings[Idx] := Fs.Fields[0]; // filename
      Data.Objects[Idx] := TObject(StrToInt(Fs.Fields[1])) // file size
    end;

    Data.Sort;

  finally
    Result := LastBlock;
    UDP.Free;
  end;
end;


procedure UDPProcessDir(js: TlkJSONobject; var Data: TFileInfo);
var
  DataBlock: String;
  BlockCount: Integer;
  Slin, Slout: TStringList;
  Idx, PathLen: Integer;
  Fs: TFieldSet;
  HasPath: Boolean;
begin
// sample: {"mi":3,"bc":1015,"bn":1,"nb":0,"lb":false,"bd":"/

  Data.LastBlock := js.Field['lb'].Value;
  DataBlock := js.Field['bd'].Value;
  Data.CurBlock := js.Field['bn'].Value;

  if js.Field['bn'].Value = 1 then
  begin
    Data.CurBlock := 1;
    BlockCount    := 1;
    Data.Info     := '';
    Data.PreBlock := 1;
    Data.Error    := False;
    Data.Data     := '';
  end else
  begin
    Data.CurBlock := js.Field['bn'].Value;
    Inc(Data.PreBlock);
  end;

  if Data.PreBlock <> Data.CurBlock then
  begin
    Data.Info := Format('Sequence error on block %d (%d)', [Data.CurBlock, Data.PreBlock]);
    Data.Error := True;
    raise Exception.Create(Data.Info);;
  end;

  if not Data.Error and (DataBlock.Length > 0) then
    Data.Data := Data.Data + DataBlock;

  if Data.LastBlock then
  begin
    Data.Info := Format('Get remote directory: Blocks: %d Bytes: %d', [Data.CurBlock, Data.Data.Length]);

    Slin  := TSTringList.Create;
    Slout := TSTringList.Create;

    try
      Slin.Text := Data.Data;

      HasPath := (Pos(REMOTE_PATH, Slin.Strings[0])> 0);
      PathLen := Length(REMOTE_PATH);

      for Idx := 0 to Slin.Count - 1 do
      begin
        CSVToText(Slin.Strings[Idx], Fs, ':');
        Fs.Fields[0] := Trim(Fs.Fields[0]);

        if HasPath then
          Fs.Fields[0] := Copy(Fs.Fields[0], PathLen + 1, 99);

        Slout.Add(Format(' %-18s %6d', [Fs.Fields[0], StrToInt(Fs.Fields[1])]));
      end;

    finally
      Slout.Sort;
      Data.Data := Slout.Text;
      Slin.Free;
      Slout.Free;
    end;
  end;
end;

procedure ProcessDirData(var Data: String);
var
  DataBlock: String;
  Sl: TStringList;
  Idx, PathLen: Integer;
  Fs: TFieldSet;
  HasPath: Boolean;
begin
  Sl := TStringList.Create;

  try
    Sl.Text := Data;

    for Idx := 0 to Sl.Count - 1 do
    begin
      CSVToText(Sl.Strings[Idx], Fs, ':');
      Fs.Fields[0] := Trim(Fs.Fields[0]);

      if HasPath then
        Fs.Fields[0] := Copy(Fs.Fields[0], PathLen + 1, 99);
    end;

  finally
    Sl.Sort;
    Data := Sl.Text;
    Sl.Free;
  end;
end;

function UDPGetFile(FileName, Directory: String; var Data: String; Silent: Boolean): Boolean;
var
  DataBlock: String;
  TxTxt: TIdBytes;
  UDP: TIdUDPClient;
  js: TlkJSONobject;
  msgno, BlockNo, BlockCount, Blocks, Idx, ResponseTime, Rt: Integer;
  LastBlock: Boolean;
  Tick, p: DWord;
begin
  UDP := TIdUDPClient.Create(nil);
  LastBlock := False;
  Data := '';
  Tick := GetTickCount;

  if FileName.Length = 0 then
    raise Exception.Create('The filename has not been specified');

  try
    try
      UDP.BoundIP         := __UdpIp.Host;
      UDP.BoundPort       := __UdpIp.Port;
      UDP.ReceiveTimeout  := UDP_TIMEOUT;

      TxTxt := ToBytes(makeUDPRequest(lcGetFile,
                                      __UdpIp.Host,
                                      Directory + FileName));

      UDP.SendBuffer(__UdpIp.Server, __UdpIp.Port, TxTxt);

      BlockCount := 0;
      Blocks := 0;
      ResponseTime := -1;

      while LastBlock = False do
      begin
        Inc(BlockCount);
        Rt := GetTickCount;

        DataBlock := UDP.ReceiveString(UDP_TIMEOUT);

        Rt := GetTickCount - Rt;
        if Rt > ResponseTime then
          ResponseTime := Rt;

        try

        if DataBlock.Length = 0 then
        begin
          if not Silent then
            raise Exception.Create(Format('The server did not respond or return any data (%d mS)', [ResponseTime]));
          break;
        end;

//      {"mi":4,"bc":1024,"bn":1,"nb":48,"lb":false,"bd":"
        js := TlkJSON.ParseText(DataBlock) as TlkJSONobject;

        if (Integer(js.Field['mi'].Value) <> 1) then
        begin
          LastBlock := js.Field['lb'].Value;
          DataBlock := js.Field['bd'].Value;
          BlockNo   := js.Field['bn'].Value;
          Blocks    := js.Field['nb'].Value;
        end;

        if BlockCount <> BlockNo then
        begin
          raise Exception.Create('Packet order error');
          break;
        end;

        except
          on e:exception do
              ShowMessage(Format('%s %s', [Filename, e.message]));
        end;

        Data := Data + DataBlock;
      end;
    except
      on e:exception do
      begin
        Exit(False);
      end;
    end;

  finally
    Result := LastBlock;
    UDP.Free;
  end;
end;

function UDPGetFile(FileName, Directory: String; var Data, Info: String; PB: TProgressBar = nil): Boolean;
var
  DataBlock: String;
  TxTxt: TIdBytes;
  UDP: TIdUDPClient;
  js: TlkJSONobject;
  msgno, BlockNo, BlockCount, Blocks, Idx, ResponseTime, Rt: Integer;
  LastBlock: Boolean;
  Tick, p: DWord;
begin
  UDP := TIdUDPClient.Create(nil);
  LastBlock := False;
  Data := '';
  Tick := GetTickCount;

  if FileName.Length = 0 then
    raise Exception.Create('The filename has not been specified');

  try
    try
      UDP.BoundIP         := __UdpIp.Host;
      UDP.BoundPort       := __UdpIp.Port;
      UDP.ReceiveTimeout  := UDP_TIMEOUT;

      TxTxt := ToBytes(makeUDPRequest(lcGetFile,
                                      __UdpIp.Host,
                                      Directory + FileName));

      UDP.SendBuffer(__UdpIp.Server, __UdpIp.Port, TxTxt);

      BlockCount := 0;
      Blocks := 0;
      ResponseTime := -1;

      while LastBlock = False do
      begin
        Inc(BlockCount);
        Rt := GetTickCount;

        DataBlock := UDP.ReceiveString(UDP_TIMEOUT);

        Rt := GetTickCount - Rt;
        if Rt > ResponseTime then
          ResponseTime := Rt;


        if DataBlock.Length = 0 then
        begin
          raise Exception.Create(Format('The server did not respond or return any data (%d mS)', [ResponseTime]));
          break;
        end;

//      {"mi":4,"bc":1024,"bn":1,"nb":48,"lb":false,"bd":"
        js := TlkJSON.ParseText(DataBlock) as TlkJSONobject;

        LastBlock := js.Field['lb'].Value;
        DataBlock := js.Field['bd'].Value;
        BlockNo   := js.Field['bn'].Value;
        Blocks    := js.Field['nb'].Value;

        if PB <> nil then
        begin
          if BlockNo = 1 then
            PB.Max := js.Field['nb'].Value;
          PB.Position := BlockNo;
          Application.ProcessMessages;
        end;

        if BlockCount <> BlockNo then
        begin
          raise Exception.Create('Packet order error');
          break;
        end;

        Data := Data + DataBlock;
      end;
    except
      on e:exception do
      begin
        Info := Format('Get remote file error: %s', [e.Message]);
        Exit(False);
      end;
    end;

    Tick := GetTickCount - Tick;
    Info := Format('%s %s Blocks: %3d Bytes: %6d - %d mS - Slowest Block %d mS', [' Get remote file:',
                                                                                  FileName,
                                                                                  Blocks,
                                                                                  Data.Length,
                                                                                  Tick,
                                                                                  ResponseTime]);
  finally
    Data := Data;
    Result := LastBlock;
    UDP.Free;
  end;
end;

end.
