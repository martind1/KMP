unit WoeDatKmp;
(* Wöhwa Dateischnittstelle
   sende wiege.dat; empfange gewicht.dat idF "009257000001"

20.10.13 md  erstellt (FaWaWs)

--
fester Timeout: 20000 (20s)


*)

interface

uses
  Math,
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, SysUtils, FaWa_Kmp;

type
  TWoeDatKmp = class(TFaWaKmp)
  private
    fSendFileName: string;
    fReceFileName: string;
    { Private-Deklarationen }
    procedure Poll(Sender: TObject);
    procedure WarteBisFrei;
  protected
    { Protected-Deklarationen }
    ProtGewichtStart: integer;
    HoleStatusStart: integer;
    SendLines: TStringList;
    ReceLines: TStringList;
    ErrSL: TStringList;
  public
    { Public-Deklarationen }
    Wartend: boolean;
    HoleStatusFlag: boolean;
    ProtGewichtFlag: boolean;   //Timeout einarbeiten über Poll
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
  published
    { Published-Deklarationen }
    property SendFileName: string read fSendFileName write fSendFileName;
    property ReceFileName: string read fReceFileName write fReceFileName;
  end;

implementation

uses
  Prots, Poll_Kmp, Err__Kmp, CPro_kmp;

(*** Initialisierung *********************************************************)

constructor TWoeDatKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SendLines := TStringList.Create;
  ReceLines := TStringList.Create;
  ErrSL := TStringList.Create;
  if PollKmp <> nil then
    PollKmp.Add(Poll, self, 1000);  //jede sec
end;

procedure TWoeDatKmp.Loaded;
begin
  inherited Loaded;
end;

destructor TWoeDatKmp.Destroy;
begin
  if PollKmp <> nil then
    PollKmp.Sub(Poll, self);
  FreeAndNil(SendLines);
  FreeAndNil(ReceLines);
  FreeAndNil(ErrSL);
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

function TWoeDatKmp.ProtGewicht(Beizeichen: string): longint;
begin
  Result := -1;
  WarteBisFrei;
  if csDestroying in ComponentState then
    Exit;
  ProtZeile1 := BeiZeichen;
  ProtGewichtId := NewTelId;
  SendLines.Text := 'ProtGewicht';  //ohne Raute = mit Eichspeicher
  Prot0('%d:%s', [ProtGewichtId, SendLines.Text]);
  Wartend := true;
  ProtGewichtFlag := true;
  HoleStatusFlag := false;
  TicksReset(ProtGewichtStart);
  result := ProtGewichtId;
  PollKmp.Sleep(Poll, self, 100);
end;

function TWoeDatKmp.HoleStatus: longint;
begin
  Result := -1;
  WarteBisFrei;
  if csDestroying in ComponentState then
    Exit;
  StatusId := NewTelId;
  SendLines.Text := 'HoleStatus#';  //Raute=nur Gewicht
  Prot0('%d:%s', [StatusId, SendLines.Text]);
  Wartend := true;
  HoleStatusFlag := true;
  ProtGewichtFlag := false;
  TicksReset(HoleStatusStart);
  result := StatusId;
  PollKmp.Sleep(Poll, self, 100);
end;

procedure TWoeDatKmp.WarteBisFrei;
//WarteBisFrei bis Kommunikation frei (max 1000 ms)
var
  T1: integer;
  W: boolean;
begin
  W := Wartend;
  if W then
    ProtL('%s WARN warte bis frei', [OwnerDotName(self)]);
  TicksReset(T1);
  repeat
    Application.ProcessMessages
  until (csDestroying in ComponentState) or not Wartend or
        (TicksDelayed(T1) > GlobalTimeout);
  if W then
    ProtL('%s WARN Wartend:%d', [OwnerDotName(self), ord(Wartend)]);
end;

procedure TWoeDatKmp.Poll(Sender: TObject);
var
  GewichtStr, S1: string;
begin

  if SendLines.Text <> '' then
  begin
    try
      try
        if not TestModus then
        begin
          DeleteFile(ReceFilename);
        end;
        S1 := RemoveTrailCrlf(SendLines[0]);  //1.Zeile
        Prot0_Unique(3, ErrSL, '%s Send:%s', [OwnerDotName(self), S1]);
        SendLines.SaveToFile(SendFilename);
        PollKmp.Sleep(Poll, self, 100);
      except on E:Exception do begin
          Prot0('%s ERR %s: %s', [OwnerDotName(self), SendLines.Text, E.Message]);
          Wartend := false;
          Display := E.Message;  // ([fwsWaagenstoerung]);
          if HoleStatusFlag then
          begin
            if assigned(FOnStatus) then
              FOnStatus(StatusId, 0, [fwsWaagenstoerung]);
          end;
          if ProtGewichtFlag then
          begin
            if assigned(FOnProtGewicht) then
              FOnProtGewicht(ProtGewichtId, 0, 0, [fwsWaagenstoerung]);
          end;
        end;
      end;
    finally
      SendLines.Clear;
    end;
    Exit;
  end;

  if Wartend then
  begin
    if FileExists(ReceFilename) then
    try
      ReceLines.LoadFromFile(ReceFilename);
      Wartend := false;
      S1 := Copy(ReceLines[0], 1, 12);  //1.Zeile ohne ^Z ($1A)
      Prot0_Unique(3, ErrSL, '%s Receive:%s', [OwnerDotName(self), S1]);
      //Auswertung Inhalt:
      //123456789012
      //SGGGGGNNNNNN
      //009257000001
      FawaStatus := [fwsGewichtOK];
      if S1[1] = '0' then
        FawaStatus := FawaStatus + [fwsKeinStillstand];
      GewichtStr := copy(S1, 2, 5);
      ProtNr := StrToIntTol(copy(S1, 7, 6));

      StrToGewicht(GewichtStr, Gewicht);
      if fwsKeinStillstand in FawaStatus then
        Display := Format('%5.*f %s', [NachK, Gewicht, ''])
      else
        Display := Format('%5.*f %s', [NachK, Gewicht, GE]);

      if HoleStatusFlag then
      begin
        if assigned(FOnStatus) then
          FOnStatus(StatusId, Gewicht, FaWaStatus);
      end;
      if ProtGewichtFlag then
      begin
        if assigned(FOnProtGewicht) then
          FOnProtGewicht(ProtGewichtId, Gewicht, ProtNr, FaWaStatus);
      end;
    except on E:Exception do begin
        Prot0('%s ERR Receive: %s', [OwnerDotName(self), E.Message]);
        Display := E.Message;
        if HoleStatusFlag then
        begin
          if assigned(FOnStatus) then
            FOnStatus(StatusId, 0, [fwsKeinGewicht]);
        end;
        if ProtGewichtFlag then
        begin
          if assigned(FOnProtGewicht) then
            FOnProtGewicht(ProtGewichtId, 0, 0, [fwsKeinGewicht]);
        end;
      end;
    end else
    begin
      if HoleStatusFlag and TicksCheck(HoleStatusStart, GlobalTimeout) then
      begin
        Prot0('%s ERR HoleStatus Timeout', [OwnerDotName(self)]);
        HoleStatusFlag := false;
        Wartend := false;
        Display := FaWaStatusStr([fwsTimeOut]);
        if assigned(FOnStatus) then
          FOnStatus(StatusId, 0, [fwsTimeOut]);
      end;
      if ProtGewichtFlag and TicksCheck(ProtGewichtStart, GlobalTimeout) then
      begin
        Prot0('%s ERR ProtGewicht Timeout', [OwnerDotName(self)]);
        ProtGewichtFlag := false;
        Wartend := false;
        Display := FaWaStatusStr([fwsTimeOut]);
        if assigned(FOnProtGewicht) then
          FOnProtGewicht(ProtGewichtId, 0, 0, [fwsTimeOut]);
      end;
      PollKmp.Sleep(Poll, self, 100);
    end;
  end;  //Wartend
end;

end.
