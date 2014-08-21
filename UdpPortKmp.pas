unit UdpPortKmp;
(* Serielle Kommunikation mit UDP
10.10.08 MD erstellt
10.12.08 MD Remote (VF Kartenleser: reHost einstellen; Dflt=reClient; wmNoHello)
26.09.09 MD UDP mit Indy. Nur als Client ausgeführt.


*)
interface

uses
  Messages, WinTypes, WinProcs, Classes, Forms, SysUtils,
  CPor_Kmp, WSDdeKmp, IdBaseComponent, IdComponent, IdUDPClient;

type
  TUdpPort = class(TCustomPort)
  private
    fUDPClient: TIdUDPClient;
    InBuff: AnsiString;
    OutBuff: AnsiString;
    FHost: string;
    FProtModus: TWsDdeProtModus;
    FActive: boolean;
    procedure SetHost(const Value: string);
    function GetUDPClient: TIdUDPClient;
  protected
    //Compiler: nicht verwendet
    procedure BuildParams; override;
    procedure SetParams(Value: string); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Open: Boolean; override;
    procedure Close; override;
    function IsActive: boolean; override;
    procedure Reset; override;
    procedure Write(Data: PAnsiChar; Len: Word); override;
    procedure Write2Dle(Data: PAnsiChar; Len: Word); override;
    procedure WriteEcho(Data: PAnsiChar; Len: Word; No2Dle: boolean); override;
    procedure Read(Data: PAnsiChar; Len: Word); override;
    function InCount: integer; override;
    function BusyId: string; override;
    procedure FlushBuff;  //OutBuff senden
    property UDPClient: TIdUDPClient read GetUDPClient;
  published
    property Host: string read FHost write SetHost;
    property ProtModus: TWsDdeProtModus read FProtModus write FProtModus;
    property Port;
    property Version;
    property TimeOut;
    property OnProt;
  end;

implementation

uses
  Prots;

{ TUdpPort }

constructor TUdpPort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProtModus := [wmError, wmWarn, wmConnection];
  InBuff := '';
end;

destructor TUdpPort.Destroy;
begin
  Close;
  FreeAndNil(fUDPClient);
  inherited Destroy;
end;

procedure TUdpPort.BuildParams;
// Params string anhand Host und Port aufbauen
begin
  FParams := Format('%s:%d', [FHost, FPort]);
end;

procedure TUdpPort.FlushBuff;
begin
  if OutBuff <> '' then
  begin
    if IsActive then
    begin
      UDPClient.Send(String(OutBuff));
    end;
    OutBuff := '';
  end;
end;

function TUdpPort.InCount: integer;
begin
  if not IsActive then
  begin
    Result := 0;
    Exit;
  end;
  FlushBuff;
  Result := Length(InBuff);
  if Result = 0 then
  begin
    InBuff := AnsiString(UDPClient.ReceiveString(0));
  end;
end;

function TUdpPort.BusyId: string;
begin
  Result := Host + ':' + IntToStr(FPort);
end;

function TUdpPort.IsActive: boolean;
begin
  Result := FActive;
end;

function TUdpPort.Open: Boolean;
var
  ProtInfo: AnsiString;
begin
  InBuff := '';
  if UDPClient.Active then
    Prot0('%s WARN UDP bereits active', [OwnerDotName(self)]);
  UDPClient.Active := false;
  UDPClient.Port := FPort;
  UDPClient.Host := FHost;
  UDPClient.ReceiveTimeOut := TimeOut;
  UDPClient.Active := true;
  FActive := UDPClient.Active;
  result := FActive;
  ProtInfo := AnsiString(Format('open(%s:%d)', [Host, Port]));
  DoProt(cmOpen, PAnsiChar(ProtInfo), Length(ProtInfo));
end;

procedure TUdpPort.Close;
var
  ProtInfo: AnsiString;
begin
  UDPClient.Active := false;
  FActive := false;
  InBuff := '';
  ProtInfo := AnsiString(Format('close(%s:%d)', [Host, Port]));
  DoProt(cmClose, PAnsiChar(ProtInfo), Length(ProtInfo));
  BusyFlag := false;
end;

procedure TUdpPort.Read(Data: PAnsiChar; Len: Word);
var
  I: integer;
begin
  for I := 0 to Len - 1 do
  begin
    if Length(InBuff) >= 1 then  //warum nicht InCount mit Schreiben? weil in CProt bereits aufgerufen
    begin
      Data[I] := InBuff[1];
      System.Delete(InBuff, 1, 1);
    end;
  end;
  DoProt(cmRead, Data, Len);
end;

procedure TUdpPort.Reset;
begin
  //Close, open?
end;

procedure TUdpPort.SetParams(Value: string);
var
  S1, NextS: string;
begin
  S1 := PStrTok(Value, ':', NextS, true);
  FHost := S1;
  S1 := PStrTok('', ':', NextS, true);
  FPort := StrToIntTol(S1);
  FParams := Value;
end;

procedure TUdpPort.Write(Data: PAnsiChar; Len: Word);
var
  S1: AnsiString;
  I: integer;
begin
  S1 := '';
  for I := 0 to Len - 1 do
  begin
    Bcc := Bcc xor ord(Data[I]);
    S1 := S1 + Data[I];
  end;
  DoProt(cmWrite, Data, Len);
  OutBuff := OutBuff + S1;  //Senden über FlushBuff
end;

procedure TUdpPort.Write2Dle(Data: PAnsiChar; Len: Word);
var
  S1: AnsiString;
  I: integer;
begin
  S1 := '';
  for I := 0 to Len - 1 do
  begin
    Bcc := Bcc xor ord(Data[I]);
    S1 := S1 + Data[I];
    if ord(Data[I]) = DLE then
    begin
      Bcc := Bcc xor ord(Data[I]);
      S1 := S1 + Data[I];
    end;
  end;
  DoProt(cmWrite, Data, Len);
  OutBuff := OutBuff + S1;
end;

procedure TUdpPort.WriteEcho(Data: PAnsiChar; Len: Word; No2Dle: boolean);
// Echo wird nicht unterstützt
begin
  if No2Dle then
    Write(Data, Len) else
    Write2Dle(Data, Len);
end;

procedure TUdpPort.SetHost(const Value: string);
begin
  FHost := Value;
end;

function TUdpPort.GetUDPClient: TIdUDPClient;
begin
  if fUDPClient = nil then
  begin
    fUDPClient := TIdUDPClient.Create(nil);
  end;
  Result := fUDPClient;
end;

end.
