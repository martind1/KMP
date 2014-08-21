unit Pr1613WsKmp;
(* FaWa Komonente die per Funktionaler Schnittstelle kommuniziert
   PR1613 Winsocket Client
*)
interface

uses
  Math,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp, WSDDEKmp;

const
  SHoleStatus = 'HoleStatus';
  SProtGewicht = 'ProtGewicht';
  SSchranke = 'Schranke';

type
  TDoProtGewichtEvent = procedure(Sender: TObject; var ATelId: longint) of object;
  TDdeEvent = procedure(Sender: TObject; Befehl, Antwort: string) of object;

type
  TPr1613Ws = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    FWSWaaCli: TWSDDE;
    FPollInterval: integer;
    FBereich: integer;
    FDoProtGewicht: TDoProtGewichtEvent;
    FOnDdeEvent: TDdeEvent;
    procedure SetWSWaaCli(const Value: TWSDDE);
    procedure WSWaaCliChange(Sender: TObject);
  protected
    { Protected-Deklarationen }
    ProtGewichtFlag: boolean;
    HoleStatusFlag: boolean;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DdeBefehl(Befehl: string);
  published
    { Published-Deklarationen }
    property Bereich: integer read FBereich write FBereich;
    property PollInterval: integer read FPollInterval write FPollInterval;
    property WSWaaCli: TWSDDE read FWSWaaCli write SetWSWaaCli;
    property DoProtGewicht: TDoProtGewichtEvent read FDoProtGewicht write FDoProtGewicht;
    property OnDdeEvent: TDdeEvent read FOnDdeEvent write FOnDdeEvent;
  end;

implementation

uses
  Prots, Poll_Kmp, Err__Kmp;

(*** Initialisierung *********************************************************)

procedure TPr1613Ws.SetWSWaaCli(const Value: TWSDDE);
begin
  FWSWaaCli := Value;
  Active := Value <> nil;
  if Value <> nil then
  begin
    Prot0('%s:SetWSWaaCli(%s,%d)', [OwnerDotName(self),Value.Host, Value.Port]);
    FWSWaaCli.OnChange := WSWaaCliChange;
  end;
end;

constructor TPr1613Ws.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPollInterval := 200;
  FBereich := 1;
end;

procedure TPr1613Ws.Loaded;
begin
  inherited Loaded;
end;

destructor TPr1613Ws.Destroy;
begin
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

function TPr1613Ws.ProtGewicht(Beizeichen: string): longint;
begin
  ProtZeile1 := BeiZeichen;
  if assigned(FDoProtGewicht) then
    FDoProtGewicht(self, ProtGewichtId);  //ProtZeile1 eintragen
  Inc(ProtGewichtId);
  if not WSWaaCli.Active then
  begin
    FaWaStatus := [fwsTimeOut];
    Gewicht := 0;
  end else
  begin
    ProtGewichtFlag := true;
    WSWaaCli.Text := Format('%s=%s', [SProtGewicht, ProtZeile1]);
  end;
  result := ProtGewichtId;
end;

function TPr1613Ws.HoleStatus: longint;
begin
  Inc(StatusId);
  if not WSWaaCli.Active then
  begin
    FaWaStatus := [fwsTimeOut];
    Gewicht := 0;
    if WSWaaCli.Host = '' then
      Display := 'Host?' else
    if WSWaaCli.Port = 0 then
      Display := 'Port?' else
      Display := 'Remote?';
    if assigned(FOnStatus) then
      FOnStatus(StatusId, Gewicht, FaWaStatus);
  end else
  begin
    HoleStatusFlag := true;
    WSWaaCli.Text := Format('%s', [SHoleStatus]);
  end;
  result := StatusId;
end;

procedure TPr1613Ws.DdeBefehl(Befehl: string);
begin
  WSWaaCli.Text := Format('%s', [Befehl]);
end;

procedure TPr1613Ws.WSWaaCliChange(Sender: TObject);
var
  Status: integer;
  Meldung, NextS: string;
  EichNr: integer;
  Befehl, Antwort: string;
begin
  //ProtA('WSWaaCliChange(%s)', [WSWaaCli.Text]);
  if CompareText(StrParam(WSWaaCli.Text), SHoleStatus) = 0 then
  begin
    Status := StrToIntTol(PStrTok(StrValue(WSWaaCli.Text), ';', NextS));
    Gewicht := StrToFloatTol(PStrTok('', ';', NextS));
    Meldung := PStrTok('', ';', NextS);
    if (Status = 0) or (Status = 1) then
    begin
      FaWaStatus := [fwsGewichtOK];
      GewichtToStr(Gewicht, Display);
    end else
    begin
      FaWaStatus := [fwsKeinGewicht];
      Display := Meldung;
    end;
    if assigned(FOnStatus) then
      FOnStatus(StatusId, Gewicht, FaWaStatus);
  end else
  if CompareText(StrParam(WSWaaCli.Text), SProtGewicht) = 0 then
  begin
    Status := StrToIntTol(PStrTok(StrValue(WSWaaCli.Text), ';', NextS));
    Gewicht := StrToFloatTol(PStrTok('', ';', NextS));
    EichNr := StrToIntTol(PStrTok('', ';', NextS));
    Meldung := PStrTok('', ';', NextS);
    if (Status = 0) or (Status = 1) then
    begin
      FaWaStatus := [fwsGewichtOK];
      GewichtToStr(Gewicht, Display);
    end else
    begin
      FaWaStatus := [fwsKeinGewicht];
      Display := Meldung;
    end;
    if assigned(FOnProtGewicht) then
      FOnProtGewicht(ProtGewichtId, Gewicht, EichNr, FaWaStatus);
  end else
  begin
    Befehl := StrParam(WSWaaCli.Text);
    Antwort := StrValue(WSWaaCli.Text);
    if assigned(FOnDdeEvent) then
      FOnDdeEvent(self, Befehl, Antwort);
  end;
end;

end.
