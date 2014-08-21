unit WSPortKmp;
(* Serielle Kommunikation mit Winsocket
10.10.08 MD erstellt
10.12.08 MD Remote (VF Kartenleser: reHost einstellen; Dflt=reClient; wmNoHello)
16.06.11 md  BinaryMode -> WSDDE

*)
interface

uses
  Messages, WinTypes, WinProcs, Classes, Forms, SysUtils, scktcomp,
  CPor_Kmp, WSDDEKmp;

type
  TWSPort = class(TCustomPort)
  private
    WSDDE: TWSDDE;
    InBuff: AnsiString;
    OutBuff: AnsiString;
    FHost: string;
    FRemote: TRemote;
    FProtModus: TWsDdeProtModus;
    FActive: boolean;
    FBinaryMode: boolean;
    procedure WSDDEChange(Sender: TObject);
    procedure SetHost(const Value: string);
    procedure SetRemote(const Value: TRemote);
  protected
    //Compiler: nicht verwendet
    procedure WSDDEError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
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
  published
    property Host: string read FHost write SetHost;
    property Remote: TRemote read FRemote write SetRemote;
    property ProtModus: TWsDdeProtModus read FProtModus write FProtModus;
    property BinaryMode: boolean read FBinaryMode write FBinaryMode;
    property Port;
    property Version;
    property TimeOut;
    property OnProt;
  end;

implementation

uses
  Prots;

var
  WsDdeNr: integer;

{ TWSPort }

constructor TWSPort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRemote := reClient;
  FProtModus := [wmError, wmWarn, wmConnection];
  WSDDE := TWSDDE.Create(self);
  Inc(WsDdeNr);
  WSDDE.Name := Format('WSDDE%d', [WsDdeNr]);
  WSDDE.OnChange := WSDDEChange;
  InBuff := '';
end;

destructor TWSPort.Destroy;
begin
  Close;
  FreeAndNil(WSDDE);
  inherited Destroy;
end;

procedure TWSPort.BuildParams;
// Params string anhand Host und Port aufbauen
begin
  FParams := Format('%s:%d', [FHost, FPort]);
end;

procedure TWSPort.FlushBuff;
begin
  if OutBuff <> '' then
  begin
    WSDDE.Text := String(OutBuff);
    OutBuff := '';
  end;
end;

function TWSPort.InCount: integer;
begin
  if SMessProt then
    WSDDE.ProtModus := WSDDE.ProtModus + [wmData] else
    WSDDE.ProtModus := WSDDE.ProtModus - [wmData];
  FlushBuff;
  Result := Length(InBuff);
end;

function TWSPort.BusyId: string;
begin
  Result := Host + ':' + IntToStr(FPort);
end;

function TWSPort.IsActive: boolean;
begin
  Result := FActive;
end;

function TWSPort.Open: Boolean;
var
  ProtInfo: AnsiString;
begin
  InBuff := '';
  WSDDE.ProtModus := FProtModus;
  WSDDE.BinaryMode := BinaryMode;  //16.06.11 dwt800 ckw
  WSDDE.Remote := FRemote;
  WSDDE.Port := FPort;
  WSDDE.Host := FHost;
  FActive := true;
  result := FActive;
  ProtInfo := AnsiString(Format('open(%d)', [Port]));
  DoProt(cmOpen, PAnsiChar(ProtInfo), Length(ProtInfo));
end;

procedure TWSPort.Close;
var
  ProtInfo: AnsiString;
begin
  WSDDE.Port := 0;
  FActive := false;
  InBuff := '';
  ProtInfo := AnsiString(Format('close(%d)', [Port]));
  DoProt(cmClose, PAnsiChar(ProtInfo), Length(ProtInfo));
  BusyFlag := false;
end;

procedure TWSPort.WSDDEError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
var
  S: AnsiString;
begin
  S := AnsiString(ErrorEventStr(ErrorEvent));
  DoProt(cmOpen, PAnsiChar(S), Length(S));
  Close;
end;

procedure TWSPort.WSDDEChange(Sender: TObject);
begin
  InBuff := InBuff + AnsiString(WSDDE.Text);
end;

procedure TWSPort.Read(Data: PAnsiChar; Len: Word);
var
  I: integer;
begin
  if SMessProt then
    WSDDE.ProtModus := WSDDE.ProtModus + [wmData] else
    WSDDE.ProtModus := WSDDE.ProtModus - [wmData];
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

procedure TWSPort.Reset;
begin
  WSDDE.Reset;
end;

procedure TWSPort.SetParams(Value: string);
var
  S1, NextS: string;
begin
  S1 := PStrTok(Value, ':', NextS, true);
  FHost := S1;
  S1 := PStrTok('', ':', NextS, true);
  FPort := StrToIntTol(S1);
  FParams := Value;
end;

procedure TWSPort.Write(Data: PAnsiChar; Len: Word);
var
  S1: AnsiString;
  I: integer;
begin
  if SMessProt then
    WSDDE.ProtModus := WSDDE.ProtModus + [wmData] else
    WSDDE.ProtModus := WSDDE.ProtModus - [wmData];
  S1 := '';
  for I := 0 to Len - 1 do
  begin
    Bcc := Bcc xor ord(Data[I]);
    S1 := S1 + Data[I];
  end;
  DoProt(cmWrite, Data, Len);
  OutBuff := OutBuff + S1;
end;

procedure TWSPort.Write2Dle(Data: PAnsiChar; Len: Word);
var
  S1: AnsiString;
  I: integer;
begin
  if SMessProt then
    WSDDE.ProtModus := WSDDE.ProtModus + [wmData] else
    WSDDE.ProtModus := WSDDE.ProtModus - [wmData];
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

procedure TWSPort.WriteEcho(Data: PAnsiChar; Len: Word; No2Dle: boolean);
// Echo wird nicht unterstützt
begin
  if No2Dle then
    Write(Data, Len) else
    Write2Dle(Data, Len);
end;

procedure TWSPort.SetHost(const Value: string);
begin
  FHost := Value;
end;

procedure TWSPort.SetRemote(const Value: TRemote);
begin
  FRemote := Value;
end;

end.
