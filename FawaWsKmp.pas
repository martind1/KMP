unit FawaWsKmp;
(* FaWa Client der per Winsocket-Komponente (TWSDDE) mit Server kommuniziert (SWE, Qsbt.CaWaaTrm)
   29.09.04 MD  erstellt.
                HoleStatus
                ProtGewicht
                Rückmeldung bei Timeout per Poll wie dwtenq
*)

interface

uses
  Math,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp, WSDDEKmp;

type
  TFaWaWS = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    FWSWaaCli: TWSDDE;
    procedure SetWSWaaCli(const Value: TWSDDE);
    procedure WSWaaCliChange(Sender: TObject);
    procedure Poll(Sender: TObject);
    procedure SetWSWaaText(const Fmt: string; const Args: array of const);
    procedure WarteBisFrei;
  protected
    { Protected-Deklarationen }
    ProtGewichtStart: integer;
    HoleStatusStart: integer;
    ZeilendruckStart: integer;
    NullstellenStart: integer;
    SetzeAusgangStart: integer;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    Wartend: boolean;
    HoleStatusFlag: boolean;
    ZeilendruckFlag: boolean;
    NullstellenFlag: boolean;
    SetzeAusgangFlag: boolean;
    ProtGewichtFlag: boolean;   //Timeout einarbeiten über Poll
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    function Zeilendruck(Zeile: string): longint; override;
    function SetzeAusgang(Ausgang: Integer; Value: Boolean): longint; override;
    function Nullstellen: longint; override;
  published
    { Published-Deklarationen }
    property WSWaaCli: TWSDDE read FWSWaaCli write SetWSWaaCli;
  end;

implementation

uses
  Prots, Poll_Kmp, Err__Kmp;

(*** Initialisierung *********************************************************)

procedure TFaWaWS.SetWSWaaCli(const Value: TWSDDE);
begin
  FWSWaaCli := Value;
  Active := Value <> nil;
  if Value <> nil then
  begin
    Prot0('%s:SetWSWaaCli(%s:%d)', [OwnerDotName(self), Value.Host, Value.Port]);
    FWSWaaCli.OnChange := WSWaaCliChange;
  end;
end;

constructor TFaWaWS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if PollKmp <> nil then
    PollKmp.Add(Poll, self, GlobalTimeout div 10);  //jede sec
end;

procedure TFaWaWS.Loaded;
begin
  inherited Loaded;
end;

destructor TFaWaWS.Destroy;
begin
  if PollKmp <> nil then
    PollKmp.Sub(Poll, self);
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

function TFaWaWS.ProtGewicht(Beizeichen: string): longint;
begin
  Result := -1;
  WarteBisFrei;
  if csDestroying in ComponentState then
    Exit;
  ProtZeile1 := BeiZeichen;
  ProtGewichtId := NewTelId;
  SetWSWaaText('%s=%s', [SProtGewicht, ProtZeile1]);
  ProtGewichtFlag := true;
  TicksReset(ProtGewichtStart);
  result := ProtGewichtId;
end;

function TFaWaWS.HoleStatus: longint;
begin
  Result := -1;
  WarteBisFrei;
  if csDestroying in ComponentState then
    Exit;
  StatusId := NewTelId;
  HoleStatusFlag := true;
  TicksReset(HoleStatusStart);
  SetWSWaaText('%s', [SHoleStatus]);
  result := StatusId;
end;

function TFaWaWS.Zeilendruck(Zeile: string): longint;
begin
  Result := -1;
  WarteBisFrei;
  if csDestroying in ComponentState then
    Exit;
  DruckId := NewTelId;
  SetWSWaaText('%s=%s', [SZeilendruck, Zeile]);
  ZeilendruckFlag := true;
  TicksReset(ZeilendruckStart);
  result := DruckId;
end;

function TFaWaWS.Nullstellen: longint;
begin
  Result := -1;
  WarteBisFrei;
  if csDestroying in ComponentState then
    Exit;
  NullstellenId := NewTelId;
  NullstellenFlag := true;
  TicksReset(NullstellenStart);
  SetWSWaaText('%s', [SNullstellen]);
  result := NullstellenId;
end;

function TFaWaWS.SetzeAusgang(Ausgang: Integer; Value: Boolean): longint;
begin
  Result := -1;
  WarteBisFrei;
  if csDestroying in ComponentState then
    Exit;
  SetzeAusgangId := NewTelId;
  SetWSWaaText('%s=%d.%d', [SSetzeAusgang, Ausgang, Ord(Value)]);
  SetzeAusgangFlag := true;
  TicksReset(SetzeAusgangStart);
  result := SetzeAusgangId;
end;

procedure TFaWaWS.WarteBisFrei;
//WarteBisFrei bis Kommunikation frei (max 1000 ms)
var
  T1: integer;
begin
//Prot0('wartebisfrei start', [0]);
  TicksReset(T1);
  repeat
    Application.ProcessMessages
  until (csDestroying in ComponentState) or not Wartend or (TicksDelayed(T1) > 1000);
//Prot0('wartebisfrei ende', [0]);
end;

procedure TFaWaWS.SetWSWaaText(const Fmt: string; const Args: array of const);
begin
  WSWaaCli.Text := Format(Fmt, Args);
  Wartend := true;
end;

procedure TFaWaWS.WSWaaCliChange(Sender: TObject);
var
  Status: integer;
  //Gewicht: double;
  GewichtStr, Meldung, NextS: string;
  EichNr: integer;
  WSText: string;
begin
  WSText := WSWaaCli.Text;  //notwendig da zB Protgewicht den Cli.Text ändern kann.
  Wartend := false;

  //ProtA('WSWaaCliChange(%s)', [WSWaaCli.Text]);
  if CompareText(StrParam(WSText), SHoleStatus) = 0 then
  begin
    HoleStatusFlag := false;
    Status := StrToIntTol(PStrTok(StrValue(WSText), ';', NextS));
    GewichtStr := PStrTok('', ';', NextS);
    Meldung := PStrTok('', ';', NextS);

    //Gewicht := StrToFloatTol(GewichtStr);
    StrToGewicht(GewichtStr, Gewicht);
    if (Status = 0) or (Status = 1) or (Status = 2) then
    begin
      FaWaStatus := [fwsGewichtOK];
      if Status = 1 then
        FaWaStatus := FaWaStatus + [fwsUnterlast];  //04.08.11 Unterlast
      if Status = 2 then
        FaWaStatus := FaWaStatus + [fwsKeinStillstand];  //22.11.13 IT6000
      //Display := GewichtStr + ' ' + GE;
      Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
    end else
    begin
      FaWaStatus := [fwsKeinGewicht];
      Display := StrDflt(Meldung, 'Fehler');
    end;
    if assigned(FOnStatus) then
      FOnStatus(StatusId, Gewicht, FaWaStatus);
  end;
  if CompareText(StrParam(WSText), SProtGewicht) = 0 then
  begin  //Status;Gewicht;Eichnr;Meldung
    ProtGewichtFlag := false;
    Status := StrToIntTol(PStrTok(StrValue(WSText), ';', NextS));
    GewichtStr := PStrTok('', ';', NextS);
    EichNr := StrToIntTol(PStrTok('', ';', NextS));
    Meldung := PStrTok('', ';', NextS);

    //Gewicht := StrToFloatTol(GewichtStr);
    StrToGewicht(GewichtStr, Gewicht);
    if Status = 0 then  // or (Status = 1) then
    begin
      FaWaStatus := [fwsGewichtOK];
      //GewichtToStr(Gewicht, Display);
      Display := GewichtStr + ' ' + GE;
    end else
    begin
      Display := Meldung;
      if Status = 1 then //MinGew
      begin
        FaWaStatus := [fwsUnterlast];
      end else
      if Status = 2 then //Positionierung
      begin
        FaWaStatus := [fwsPosition];
      end else
      begin
        FaWaStatus := [fwsKeinGewicht];
      end;
    end;
    if assigned(FOnProtGewicht) then
      FOnProtGewicht(ProtGewichtId, Gewicht, EichNr, FaWaStatus);
  end;
  if CompareText(StrParam(WSText), SZeilendruck) = 0 then
  begin  //Status;Meldung
    ZeilenDruckFlag := false;
    Status := StrToIntTol(PStrTok(StrValue(WSText), ';', NextS));
    Meldung := PStrTok('', ';', NextS);

    if Status = 0 then
      FaWaStatus := [] else
      FaWaStatus := [fwsDruckerstoerung];

    if assigned(FOnZeilendruck) then
      FOnZeilendruck(DruckId, FaWaStatus);
  end;
  if CompareText(StrParam(WSText), SNullstellen) = 0 then
  begin  //Status;Meldung
    NullstellenFlag := false;
    Status := StrToIntTol(PStrTok(StrValue(WSText), ';', NextS));
    Meldung := PStrTok('', ';', NextS);

    if Status = 0 then
      FaWaStatus := [fwsNull] else
      FaWaStatus := [fwsNullbereichsfehler];

    if assigned(FOnNullstellen) then
      FOnNullstellen(DruckId, FaWaStatus);
  end;
  if CompareText(StrParam(WSText), SSetzeAusgang) = 0 then
  begin  //Ausgang setzen (Ampel): Ausgang=0 ist OK. 2=Störung
    SetzeAusgangFlag := false;
    Status := StrToIntTol(PStrTok(StrValue(WSText), ';', NextS));
    Meldung := PStrTok('', ';', NextS);

    if Status = 0 then
      FaWaStatus := [] else
      FaWaStatus := [fwsDruckerstoerung];

    if assigned(FOnSetzeAusgang) then
      FOnSetzeAusgang(SetzeAusgangId, FaWaStatus);
  end;
end;

procedure TFaWaWS.Poll(Sender: TObject);
begin
  if HoleStatusFlag and TicksCheck(HoleStatusStart, GlobalTimeout) then
  begin
    HoleStatusFlag := false;
    Display := FaWaStatusStr([fwsTimeOut]);
    {if WSWaaCli <> nil then
      WSWaaCli.Reset;  bringt nix}
    if assigned(FOnStatus) then
      FOnStatus(StatusId, 0, [fwsTimeOut]);
  end;
  if ProtGewichtFlag and TicksCheck(ProtGewichtStart, GlobalTimeout) then
  begin
    ProtGewichtFlag := false;
    Display := FaWaStatusStr([fwsTimeOut]);
    {if WSWaaCli <> nil then
      WSWaaCli.Reset;}
    if assigned(FOnProtGewicht) then
      FOnProtGewicht(ProtGewichtId, 0, 0, [fwsTimeOut]);
  end;
  if ZeilenDruckFlag and TicksCheck(ZeilenDruckStart, GlobalTimeout) then
  begin
    ZeilenDruckFlag := false;
    Display := FaWaStatusStr([fwsTimeOut]);
    {if WSWaaCli <> nil then
      WSWaaCli.Reset;}
    if assigned(FOnZeilenDruck) then
      FOnZeilenDruck(DruckId, [fwsTimeOut]);
  end;
  if NullstellenFlag and TicksCheck(NullstellenStart, GlobalTimeout) then
  begin
    NullstellenFlag := false;
    Display := FaWaStatusStr([fwsTimeOut]);
    {if WSWaaCli <> nil then
      WSWaaCli.Reset;}
    if assigned(FOnNullstellen) then
      FOnNullstellen(DruckId, [fwsTimeOut]);
  end;
  if SetzeAusgangFlag and TicksCheck(SetzeAusgangStart, GlobalTimeout) then
  begin
    SetzeAusgangFlag := false;
    Display := FaWaStatusStr([fwsTimeOut]);
    {if WSWaaCli <> nil then
      WSWaaCli.Reset;}
    if assigned(FOnSetzeAusgang) then
      FOnSetzeAusgang(DruckId, [fwsTimeOut]);
  end;
end;

procedure TFaWaWS.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = WSWaaCli) then
    FWSWaaCli := nil;
  inherited Notification(AComponent, Operation);
end;

end.
