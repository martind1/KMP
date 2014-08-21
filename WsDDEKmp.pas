unit WSDDEKmp;
(* Winsocket-DDE
   Autor: Martin Dambach
   28.07.02        Erstellt
   22.09.02        OnError
   17.10.03        LineMode (z.B. fir MS TELNET welches das nicht selbst kann)
   23.08.05        Trim Problem (trailing blanks)
   11.12.08        wmNoHello: kein Hello wenn in ProtModus
   12.02.09        LineMode manuell setzen: überträgt ^M^J
   16.06.11        BinaryMode: kein CR/LF hinzufügen (Schenk CKW DWT800)
   02.09.13        SameProtCount als Property (war const 10)
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ScktComp, ComCtrls;

type
  TRemote = (reHost,             {Hostmodus und Lokaler Modus mit Verbindung}
             reClient);          {Clientmodus ohne direkte Verbindung}
  TWsDdeProtModi = (wmError, wmWarn, wmConnection, wmData, wmNoHello);
  TWsDdeProtModus = set of TWsDdeProtModi;

//const
//  SameProtCount: integer = 10;  //Anzahl gleicher Protausgaben die nicht ausgegeben werdne

type
  TWSDDE = class(TComponent)
  private
    { Private-Deklarationen }
    FServerSocket: TServerSocket;
    FClientSocket: TClientSocket;
    FRemote: TRemote;                        {reHost/Lokal oder reClient}
    FHost: string;                           {Client: Name/IP des Host}
    FPort: integer;                          {Port}
    FLines: TStringList;
    FPollIntervall: integer;
    FActive: boolean;
    FSendPending: boolean;
    FOnChange: TNotifyEvent;
    FOnError: TSocketErrorEvent;
    FLineMode: boolean;                      {Host:alle Daten mit CR oder CRLF abschließen}
    FProtModus: TWsDdeProtModus;
    fConnected: boolean;
    FBinaryMode: boolean;
    fEmpfCount: integer;
    fSameProtCount: integer;                    //true=keine zusätzlichen CR/LF senden
    procedure Poll(Sender : TObject);
    procedure SetLines(Value: TStringList);
    function GetText: string;
    procedure SetText(Value: string);
    procedure SetHost(Value: string);
    procedure SetRemote(Value: TRemote);
    procedure LinesChange(Sender: TObject);
    procedure SetPort(const Value: integer);
    procedure SetConnected(const Value: boolean);
    function GetConnected: boolean;
    procedure DoActivate;
    procedure ServerSocketAccept(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketSendText(aClient: string);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketLookup(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure XProt(Level: TWsDdeProtModi; const Fmt: string;
      const Args: array of const);
    procedure ClientSocketSendText;
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    function TextEmpfangen(const AText: string): boolean;
    function TextToSend: string;
    function GetEmpfCount: integer;
  protected
    { Protected-Deklarationen }
    Clients: TStringList;                   {Host: Namen der Clients}
    AktClientIndex: integer;                {Host:Aktueller Client}
    OldLines: TStringList;
    InEmpf: boolean;
    Sending: boolean;                 //Text enthält Sendetext
    LinemodeOK: boolean;              //Cli:true wenn von Server Hello empfangen
    OldProt1, OldProt2: string;
    OldProt: TStringList;
    ClientSendTime: integer;
    procedure HostEmpf(const AText: string);
    procedure HostSend(ClientIndex: integer);
    procedure ClientEmpf(const AText: string);
    procedure ClientSend;
    function EolStr: string;
    procedure Loaded; override;
    procedure DoOnChange;
  public
    { Public-Deklarationen }
    ErrCode: integer;
    destructor Destroy; override;
    procedure Reset;
    procedure SetHostPort(Value: string); {akzeptiert Host:Port, :Port oder Host}
    constructor Create(AOwner: TComponent); override;
    function AktClient: string;           //IP-Adresse des Anforderungs-Clients
    procedure SetClientText(Value, aClient: string);
    property Lines: TStringList read FLines write SetLines;
    property Text: string read GetText write SetText;
    property Active: boolean read FActive;
    property Connected: boolean read GetConnected write SetConnected;
    property EmpfCount: integer read GetEmpfCount write fEmpfCount;
  published
    { Published-Deklarationen }
    property PollIntervall: integer read FPollIntervall write FPollIntervall;
    property Remote: TRemote read FRemote write SetRemote;
    property Host: string read FHost write SetHost;
    property Port: integer read FPort write SetPort;
    property LineMode: boolean read FLineMode write FLineMode;
    property BinaryMode: boolean read FBinaryMode write FBinaryMode;
    property ProtModus: TWsDdeProtModus read FProtModus write FProtModus;
    property SameProtCount: integer read fSameProtCount write fSameProtCount default 10;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnError: TSocketErrorEvent read FOnError write FOnError;
  end;

function ErrorEventStr(ErrorEvent: TErrorEvent): string;

implementation
uses
  Prots, Poll_Kmp, GNav_Kmp, Err__Kmp;

//var
//  fWSDDE: TWSDDE;
//
//procedure SocketError(Sender: TObject; E: Exception; var Done: Boolean);
//begin
//  if (fWSDDE <> nil) and assigned (fWSDDE.FOnError) then
//    fWSDDE.FOnError(Sender, E, Done);
//end;


procedure TWSDDE.XProt(Level: TWsDdeProtModi; const Fmt: string; const Args: array of const);
var
  S: string;
  Modus: integer;
  I: integer;
begin
  if OldProt = nil then
    Exit;
  if Level in FProtModus then
    Modus := 1 else
  begin
    Exit;
  end;
  //if Level in [wmConnection, wmError] then
  //  OldProt.Clear;
  S := Format(Fmt, Args);
  for I := 0 to IMin(SameProtCount, OldProt.Count) - 1 do
    if OldProt[I] = S then
      Exit;
  while (OldProt.Count >= SameProtCount) and  //10 mal gleich nicht ausgeben
        (OldProt.Count > 0) do
    OldProt.Delete(0);
  OldProt.Add(S);

  if Modus = 0 then
    ProtP('%s[%d]:%s', [OwnerDotName(self), Port, S])
  else
    Prot0('%s[%d]:%s', [OwnerDotName(self), Port, S]);
end;

procedure TWSDDE.SetLines(Value: TStringList);
begin
  FLines.Assign(Value);
end;

procedure TWSDDE.LinesChange(Sender: TObject);
begin
  if not InEmpf then
  begin
    Sending := true;
    if FRemote = reClient then
      ClientSend else
      HostSend(AktClientIndex);
  end;
end;

function TWSDDE.GetText: string;
var
  I: integer;
begin
  (*if Lines.Count > 0 then
  begin
    if LineMode then
      result := Trim(Lines[0]) else
      result := RemoveTrailCrlf(Lines.Text);  //letztes CRLF entfernen - 06.01.09
  end else
    result := '';
  *)
  //neu 12.02.09
  //Linemode=true:  nur erste Zeile betrachten: ^M^J --> CR LF
  //Linemode=false: CRLF am ende nur wenn Leerzeile am Ende.
  Result := '';
  if Lines.Count > 0 then
  begin
    for I := 0 to Lines.Count - 1 do
    begin
      if Lines[I] <> '' then
        AddStr(Result, Lines[I]);
      if I < Lines.Count - 1 then
        AddStr(Result, CRLF);  //(letzte) Leerzeile
    end;
  end;
end;

procedure TWSDDE.SetText(Value: string);
begin
  (*SetStringsText(Lines, Value);
  *)
  //neu 12.02.09
  //wenn mit CRLF endet dann weitergeben (leere Zeile anfügen)
  Lines.BeginUpdate;
  try
    if BinaryMode then
    begin
      Lines.Clear;
      Lines.Add(Value);
    end else
    begin
      SetStringsText(Lines, Value);
      if EndsWith(Value, CR) or EndsWith(Value, LF) then
        Lines.Add('');  //Leerzeile
    end;
  finally
    Lines.EndUpdate;
  end;
end;

procedure TWSDDE.SetClientText(Value, aClient: string);
// Text an bestimmten Client (IP Adresse) senden
var
  OldClientIndex: integer;
begin
  OldClientIndex := AktClientIndex;
  try
    AktClientIndex := Clients.IndexOf(aClient);  //ist -1 wenn nicht gefunden -->Broadcast
    if AktClientIndex = -1 then
      Prot0('%s SetClientText(%s): kein gültiger Client', [OwnerDotName(self), aClient]);
    Text := Value;
  finally
    AktClientIndex := OldClientIndex;
  end;
end;

function TWSDDE.AktClient: string;
begin //ergibt IP Adresse des aktuellen Clients (der den Befehl gesendet hat)
  if AktClientIndex >= 0 then
    result := Clients[AktClientIndex] else
    result := '';
end;

procedure TWSDDE.Poll(Sender : TObject);
begin                                                          {Pollingfunktion}
  //Idee: fWSDDE := self;
  if fRemote = reClient then
  try
    if (FClientSocket <> nil) and not FClientSocket.Active and
       (FClientSocket.Port <> 0) and (FClientSocket.Host <> '') then
    begin
      FConnected := false;
      FClientSocket.Open;
    end;
    FActive := (FClientSocket <> nil) and FClientSocket.Active;
    if FActive and FSendPending then
    begin
      FSendPending := false;
      ClientSocketSendText;
    end;
  except on E:Exception do
    XProt(wmError, 'Cli:OpenError %s', [E.Message]);
  end else
  if fRemote = reHost then
  try
    if (FServerSocket <> nil) and not FServerSocket.Active and
       (FServerSocket.Port <> 0) then
    begin
      FConnected := false;
      FServerSocket.Open;
    end;
    FActive := (FServerSocket <> nil) and FServerSocket.Active;
    if FActive and FSendPending then
    begin
      FSendPending := false;
      HostSend(AktClientIndex);
    end;
  except on E:Exception do
    XProt(wmError, 'Svr:OpenError %s', [E.Message]);
  end;
end;

procedure TWSDDE.DoActivate;
begin
//Exit;  //Test 27.11.07
  if not (csDesigning in ComponentState) then
  begin
    if fRemote = reHost then
    begin
      if FClientSocket <> nil then
        FreeAndNil(FClientSocket);
      if FServerSocket = nil then
      begin
        FServerSocket := TServerSocket.Create(self);
        FServerSocket.ServerType := stNonBlocking;  //nicht warten
        FServerSocket.Port := FPort;
        FServerSocket.OnAccept := ServerSocketAccept;
        FServerSocket.OnClientConnect := ServerSocketClientConnect;
        FServerSocket.OnClientDisconnect := ServerSocketClientDisconnect;
        FServerSocket.OnClientError := ServerSocketClientError;
        FServerSocket.OnClientRead := ServerSocketClientRead;
        FServerSocket.OnClientWrite := ServerSocketClientWrite;
        FServerSocket.OnListen := ServerSocketListen;
      end;
    end else {reClient:}
    begin
      if FServerSocket <> nil then
        FreeAndNil(FServerSocket);
      if FClientSocket = nil then
      begin
        FClientSocket := TClientSocket.Create(self);
        FClientSocket.ClientType := ctNonBlocking;  //nicht warten
        FClientSocket.Port := FPort;
        FClientSocket.Host := FHost;
        FClientSocket.OnConnect := ClientSocketConnect;
        FClientSocket.OnConnecting := ClientSocketConnecting;
        FClientSocket.OnDisconnect := ClientSocketDisconnect;
        FClientSocket.OnError := ClientSocketError;
        FClientSocket.OnLookup := ClientSocketLookup;
        FClientSocket.OnRead := ClientSocketRead;
        FClientSocket.OnWrite := ClientSocketWrite;
      end;
    end;
  end;
  if not (csDesigning in ComponentState) then
  begin
    PollKmp.Add(Poll, self, PollIntervall);         {Pollingfunktion anmelden}
  end;
end;

procedure TWSDDE.SetRemote(Value: TRemote);
begin
  fRemote := Value;
  if not (csLoading in ComponentState) then
    DoActivate;
end;

procedure TWSDDE.Reset;
begin
  if FClientSocket <> nil then
  begin
    XProt(wmConnection, 'Cli:Reset', [0]);
    FClientSocket.Close;
    FClientSocket.Port := FPort;
    FClientSocket.Host := FHost;
    PollKmp.Sleep(Poll, self, 1001);         {Pollingfunktion gleich aufrufen}
  end;
  if FServerSocket <> nil then
  begin
    XProt(wmConnection, 'Svr:Reset(%d)', [0]);
    FServerSocket.Close;
    FServerSocket.Port := FPort;
    PollKmp.Sleep(Poll, self, 1001);         {Pollingfunktion gleich aufrufen}
  end;
end;

procedure TWSDDE.SetConnected(const Value: boolean);
begin
  fConnected := Value;
end;

function TWSDDE.GetConnected: boolean;
begin
  Result := FActive and FConnected;
end;

procedure TWSDDE.SetPort(const Value: integer);
begin
  FPort := Value;
  if (FClientSocket <> nil) and (FClientSocket.Port <> FPort) then
  begin
    XProt(wmConnection, 'Cli:SetPort(%d)', [Value]);
    FClientSocket.Close;
    FClientSocket.Port := FPort;
    if FPort <> 0 then
      PollKmp.Sleep(Poll, self, 101);         {Pollingfunktion gleich aufrufen}
  end;
  if (FServerSocket <> nil) and (FServerSocket.Port <> FPort) then
  begin
    XProt(wmConnection, 'Svr:SetPort(%d)', [Value]);
    FServerSocket.Close;
    FServerSocket.Port := FPort;
    if FPort <> 0 then
      PollKmp.Sleep(Poll, self, 101);         {Pollingfunktion gleich aufrufen}
  end;
end;

procedure TWSDDE.SetHost(Value: string);
begin
  FHost := Value;
  if (FClientSocket <> nil) and (FClientSocket.Host <> FHost) then
  begin
    XProt(wmConnection, 'Cli:SetHost(%s)', [Value]);
    FClientSocket.Close;
    FClientSocket.Host := FHost;
    PollKmp.Sleep(Poll, self, 101);         {Pollingfunktion gleich aufrufen}
  end;
end;

procedure TWSDDE.SetHostPort(Value: string);
var           {akzeptiert Host:Port, :Port oder Host}
  P1: integer;
  S1: string;
begin
  P1 := Pos(':', Value);
  if P1 > 0 then
  begin
    if P1 >= 2 then    // :Port setzt keinen Host
      Host := copy(Value, 1, P1 - 1);
    S1 := copy(Value, P1 + 1, 100);
    if S1 <> '' then  //es gibt was hinter ':'
      Port := StrToIntTol(S1);  //Port 0 bei Fehler (disconnect)
  end else
    Host := Value;    // nur Host ohne ':' stzt keinen Port
end;

procedure TWSDDE.DoOnChange;
begin
  if Assigned(fOnChange) then
  try
    fOnChange(self);
  except on E:Exception do
    EProt(self, E, 'OnChange', [0]);
  end;
end;

constructor TWSDDE.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Clients := TStringList.Create;
  FLines := TStringList.Create;
  OldLines := TStringList.Create;
  OldProt := TStringList.Create;
  FProtModus := [wmError, wmWarn, wmConnection];
  FRemote := reHost;
  FPollIntervall := 5000;
  FLines.OnChange := LinesChange;
  AktClientIndex := -1;                      {ab jetzt wieder Broadcast}
  SameProtCount := 10;
end;

procedure TWSDDE.Loaded;
begin
  inherited Loaded;
  DoActivate;  //plus Poll Add
//  if not (csDesigning in ComponentState) then
//  begin
//    PollKmp.Add(Poll, self, PollIntervall);         {Pollingfunktion anmelden}
//  end;
end;

destructor TWSDDE.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    PollKmp.Sub(Poll, self);
    if FClientSocket <> nil then
      FreeAndNil(FClientSocket);
    if FServerSocket <> nil then
      FreeAndNil(FServerSocket);
  end;
  Clients.free; Clients := nil;
  FLines.free; FLines := nil;
  OldLines.free; OldLines := nil;
  OldProt.Free; OldProt := nil;
  inherited Destroy;
end;

function TWSDDE.EolStr: string;
begin
  //if LineMode or not LinemodeOK then
  //weg 11.10.08 WSPortKmp
  if LineMode then
    result := CRLF else         //auch wenn Linemode noch nicht erkannt
    result := '';
end;

procedure TWSDDE.HostEmpf(const AText: string);
begin
  try
    InEmpf := true;
    OldLines.Clear;                     {'' ist Kennzeichen daß Empfangen}
    if Sending then
    begin
      Sending := false;
      Lines.Clear;
    end;
    if TextEmpfangen(AText) then
    begin
      Sending := true;
      InEmpf := false;                 {Sendefreigabe}
      Inc(fEmpfCount);
      DoOnChange;
    end;
  finally
    InEmpf := false;
  end;
end;

procedure TWSDDE.HostSend(ClientIndex: integer);
var
  I: integer;
begin
  I := 0;
  while I < Clients.Count do
  begin
    try
      if (I = ClientIndex) or (ClientIndex < 0) then
      begin
        ServerSocketSendText(Clients[I]);
        {ProtP('%s:HostSend(%.30s)', [Name, Lines.Text]);}
      end;
    except on E:Exception do
      begin
        EProt(self, E, 'HostSend%d(%s)', [ClientIndex, Text]);
        Application.ProcessMessages;
      end;
    end;
    Inc(I);
  end;
end;

procedure TWSDDE.ClientSend;
begin  {Identisches ohne Antwort nur alle 5s senden}
  if (fHost <> '') and 
     ((OldLines.Text <> Lines.Text) or TicksCheck(ClientSendTime, 5000)) then
  begin
    try
      ClientSocketSendText;
      {ProtP('%s:ClientSend(%.30s)', [Name, Lines.Text]);}
      OldLines.Assign(Lines);
    except on E:Exception do
      begin
        EProt(self, E, 'ClientSend(%s)', [Text]);
        Application.ProcessMessages;
      end;
    end;
  end;
end;

procedure TWSDDE.ClientEmpf(const AText: string);
begin
  try
    InEmpf := true;
    OldLines.Clear;                     {'' ist Kennzeichen daß Empfangen}
    if Sending then
    begin
      Sending := false;
      Lines.Clear;
    end;
    if TextEmpfangen(AText) then
    begin
      Sending := true;
      InEmpf := false;                 {Sendefreigabe}
      Inc(fEmpfCount);
      DoOnChange;
    end;
  finally
    InEmpf := false;
  end;
end;

function TWSDDE.TextEmpfangen(const AText: string): boolean;
//Text am Client oder Server empfangen. Ergibt true wenn Empfang beendet.
//Linemode: CRLF am Ende nicht weitergeben. ^M --> CR
var
  S: string;
begin
  Result := not LineMode or (Pos(CR, AText) > 0);
  if LineMode then
  begin
    S := RemoveCRLF(AText);
    S := StringReplace(S, '^M', CR, [rfReplaceAll]);
    S := StringReplace(S, '^J', LF, [rfReplaceAll]);
    Text := Text + S;
  end else
  begin
    Text := AText;
  end;
end;

function TWSDDE.TextToSend: string;
//Text am Client oder Server senden. Ergibt Sendestring.
//Linemode: CRLF nach ^M^J umwandeln
begin
  Result := Text;  //letzte CR bereits von GetText entfernt
  if LineMode then
  begin
    Result := StringReplace(Result, CR, '^M', [rfReplaceAll]);
    Result := StringReplace(Result, LF, '^J', [rfReplaceAll]);
  end;
end;

{ ServerSocket }

procedure TWSDDE.ServerSocketAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  XProt(wmData, 'Svr:Accept[%s]', [Socket.RemoteAddress]);
end;

procedure TWSDDE.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  FConnected := true;
  Clients.Add(Socket.RemoteAddress);
  XProt(wmConnection, 'Svr:ClientConnect%d[%s]', [Clients.Count - 1, Socket.RemoteAddress]);
  {ErrCode := Socket.SendText('HELLO=' + Socket.RemoteAddress + EolStr);
  if ErrCode = 0 then
    ProtMode := wmConnection else
    ProtMode := wmWarn;
  XProt(ProtMode, 'Svr:SendHello[%s]:%d', [Socket.RemoteAddress, ErrCode]);}
end;

procedure TWSDDE.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: integer;
begin
  I := Clients.IndexOf(Socket.RemoteAddress);
  if I >= 0 then
    Clients.Delete(I);
  XProt(wmConnection, 'Svr:ClientDisConnect%d[%s]', [I, Socket.RemoteAddress]);
end;

procedure TWSDDE.ServerSocketListen(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  XProt(wmConnection, 'Svr:Listen', [0]);  {Socket.RemoteAddress in xprot}
end;

procedure TWSDDE.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: integer;
  S: string;
begin        //Svr: Client hat einen Befehl gesendet
  S := String(Socket.ReceiveText);
  for I := 0 to FServerSocket.Socket.ActiveConnections - 1 do
  begin
    if FServerSocket.Socket.Connections[I] = Socket then
    begin
      XProt(wmData, 'Svr:ClientRead[%s](%s)', [Socket.RemoteAddress, RemoveTrailCrlf(S)]);
      try
        AktClientIndex := Clients.IndexOf(Socket.RemoteAddress);
        if AktClientIndex = -1 then
          AktClientIndex := Clients.Add(Socket.RemoteAddress);
        {Antwort (in OnChange) nur an diesen Client}
        HostEmpf(S);
      finally
        AktClientIndex := -1;                      {ab jetzt wieder Broadcast}
      end;
      break;
    end;
  end;
end;

procedure TWSDDE.ServerSocketSendText(aClient: string);
// Server sendet Text an Client mit der IP-Adresse in aClient
var
  //ProtMode: TWsDdeProtModi;
  ASocket: TCustomWinSocket;
  S: string;
  I: integer;
begin
  //crlf bleibt - 11.10.08 WSPortKmp Simul
  (*if LineMode then
    S := Trim(RemoveCRLF(Lines.Text)) else
    S := RemoveTrailCrlf(Lines.Text);  //letztes CRLF entfernen - 06.01.09 *)
  //neu 12.02.09
  S := TextToSend;  //letztes CRLF entfernt siehe GetText

  if (FServerSocket <> nil) and FServerSocket.Active then
  begin
    if S <> '' then  //nur Inhalte übertragen
    begin
      // Clients[I] und Connections[I] haben nicht unbedingt den gleichen Index:
      ASocket := nil;
      for I := 0 to FServerSocket.Socket.ActiveConnections - 1 do
        if FServerSocket.Socket.Connections[I].RemoteAddress = aClient then
        begin
          ASocket := FServerSocket.Socket.Connections[I];
          break;
        end;
      if ASocket <> nil then
      begin
        XProt(wmData, 'Svr:Send[%s](%s)', [ASocket.RemoteAddress, S]);
        ASocket.SendText(AnsiString(S + EolStr));  //ergibt Anzahl gesendeter Bytes
      end else
      begin
        XProt(wmWarn, 'Svr:Send (%s) nicht verbunden', [aClient]);
      end;
    end;
  end else
  begin
    FSendPending := true; //senden warten bis in Poll geöffnet
    XProt(wmData, 'Svr:Send:Pending (%s)', [S]);
  end;
end;

procedure TWSDDE.ServerSocketClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin      //wird bei Connect vom System aufgerufen
  XProt(wmConnection, 'Svr:ClientWrite[%s]', [Socket.RemoteAddress]);
  if not (wmNoHello in FProtModus) then
  begin
    XProt(wmConnection, 'Svr:SendHello[%s]', [Socket.RemoteAddress]);
    Socket.SendText(AnsiString('HELLO=' + OwnerDotName(self) + EolStr));  //ergibt Anzahl gesendeter Bytes
  end;
end;

{ ClientSocket }

procedure TWSDDE.ClientSocketConnecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //LineMode := false;  //weg 11.10.08 WSPortKmp - eigene Zeile 'linemode=1/0' senden
  LinemodeOK := false;
  XProt(wmConnection, 'Cli:Connecting(%s)', [FHost]); //Socket.RemoteAddress]);
end;

procedure TWSDDE.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  FConnected := true;
  XProt(wmData, 'Cli:Connect(%s)', [Socket.RemoteAddress]);
end;

procedure TWSDDE.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  XProt(wmData, 'Cli:Disconnect(%s)', [Socket.RemoteAddress]);
end;

procedure TWSDDE.ClientSocketLookup(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  XProt(wmData, 'Cli:Lookup(%s)', [Socket.RemoteAddress]);
end;

procedure TWSDDE.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  S: string;
begin           //Cli:wird beim Empfang der Antwort vom Server aufgerufen
  LinemodeOK := true;
  S := String(Socket.ReceiveText);
  XProt(wmdata, 'Cli:Read(%s)', [RemoveTrailCrlf(S)]);
  ClientEmpf(S);
end;

procedure TWSDDE.ClientSocketSendText;
var
  //ProtMode: TWsDdeProtModi;
  S: string;
begin
  (*if LineMode then
    S := Trim(RemoveCRLF(Lines.Text)) else
    S := RemoveTrailCrlf(Lines.Text);  //letztes CRLF entfernen - 06.01.09
  *)
  //neu 12.02.09
  S := TextToSend;
  
  if (FClientSocket <> nil) and FClientSocket.Active then
  begin
    if S <> '' then  //nur Inhalte übertragen
    begin
      XProt(wmData, 'Cli:Send(%s)', [S + EolStr]);  //ProtMode - swe 15.05.04
      FClientSocket.Socket.SendText(AnsiString(S + EolStr));  //ergibt Anzahl gesendeter Bytes
    end;
  end else
  begin
    FSendPending := true; //senden warten bis in Poll geöffnet
    XProt(wmData, 'Cli:Send:Pending (%s)', [S]);
  end;
end;

procedure TWSDDE.ClientSocketWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin       //wird bei Connect vom System aufgerufen
  XProt(wmConnection, 'Cli:Write[%s]', [Socket.RemoteAddress]);
  //kein Hello hier senden, da Linemode noch nicht klar
end;

procedure TWSDDE.ClientSocketError; {(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);}
begin
  XProt(wmError, 'Cli:Error(%d)[%s] %s', [ErrorCode, Socket.RemoteAddress, ErrorEventStr(ErrorEvent)]);
  if assigned(FOnError) then
  begin
    FOnError(self, Socket, ErrorEvent, ErrorCode);
    ErrorCode := 0; //keine Exception auslösen
  end;
  ErrorCode := 0; //Exception nie auslösen 30.09.04
end;

procedure TWSDDE.ServerSocketClientError; {(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);}
begin
  XProt(wmError, 'Svr:ClientError(%d)[%s] %s', [ErrorCode, Socket.RemoteAddress, ErrorEventStr(ErrorEvent)]);
  if assigned(FOnError) then
  begin
    FOnError(self, Socket, ErrorEvent, ErrorCode);
    ErrorCode := 0; //keine Exception auslösen
  end;
  ErrorCode := 0; //Exception nie auslösen 30.09.04
end;

function ErrorEventStr; {(ErrorEvent: TErrorEvent): string;}
begin
  (*case ErrorEvent of
    eeGeneral: result := 'Allgemeiner Fehler';
    eeSend: result := 'Beim Schreiben der Socket-Verbindung trat ein Fehler auf.';
    eeReceive: result := 'Beim Lesen der Socket-Verbindung trat ein Fehler auf.';
    eeConnect: result := 'Beim Verbinden der Socket-Verbindung trat ein Fehler auf.';
    {eeConnect: result := 'Bei Client-Sockets bedeutet dieser Wert, daß der Server ' +
      'nicht gefunden wurde oder daß ein Problem auf dem Server das Öffnen der ' +
      'Verbindung verhindert. Bei Server-Sockets bedeutet dieser Wert, daß eine ' +
      'Client-Verbindungsanforderung, die bereits angenommen wurde, nicht beendet werden kann.';}
    eeDisconnect: result := 'Beim Schließen einer Verbindung trat ein Fehler auf.';
    eeAccept: result := 'Beim Übernehmen einer Client-Verbindungsanforderung trat ' +
                        'ein Fehler auf.'; // (nur bei Server-Sockets).';
  end;*)
  case ErrorEvent of
    eeGeneral: result := 'General Error';
    eeSend: result := 'Send Error';
    eeReceive: result := 'Receive Error';
    eeConnect: result := 'Connect Error';
    eeDisconnect: result := 'Disconnect Error';
    eeAccept: result := 'Accept Error';
  end;
end;

function TWSDDE.GetEmpfCount: integer;
begin
  Result := fEmpfCount;
end;

end.

