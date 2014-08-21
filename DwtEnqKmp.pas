unit DwtEnqKmp;
(* Pfister DWT2 ENQ Protokoll

   MD  26.09.04    erstellen
                   - Vorauss.: Modul CPro_Kmp.Pas Datum ab 24.09.04
                   - Eintragen in 'Nk': -2: für to
                                         0: für kg
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TDwtEnq = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    procedure Poll(Sender: TObject);
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Loaded; override;
    function Nullstellen: longint; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    function Zeilendruck(Zeile: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Math,
  Prots, Err__Kmp, CPor_Kmp, Poll_Kmp;

(*** Initialisierung *********************************************************)

constructor TDwtEnq.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TDwtEnq.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;

  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  if ComPort <> nil then
    Description.Add(Format('T:%d',[ComPort.TimeOut])) else
    Description.Add('T:5000');

  Description.Add('B:');          {->ENQ}
  Description.Add('A:128,^M');    {<-Daten, (mit abschließendem CR}
  Description.Add('D:');          {<-weitere Empfangszeichen löschen (LF,BCC)}
end;

procedure TDwtEnq.Loaded;
begin
  inherited Loaded;
  BuildDescription;
  if not (csDesigning in ComponentState) then
    PollKmp.Add(Poll, self, 300);
end;

destructor TDwtEnq.Destroy;
begin
  if not (csDesigning in ComponentState) then
    PollKmp.Sub(Poll, self);
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TDwtEnq.Init;
begin
  inherited init;
end;

(*** Interne Methoden *******************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

procedure TDwtEnq.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L : integer;
  ATel : TTel;
  GewStr, GeStr: string;
  I: integer;
begin
  inherited DoAntwort(Sender, Tel_Id);

  FaWaStatus := [];
  ATel := nil;
  L := sizeof(EmpfBuff) - 1;
  try
    ATel := GetTel(Tel_Id);
    GetData(Tel_Id, EmpfBuff, L);
  finally
    EmpfBuff[L] := #0;

    {ProtGewicht}
    if Tel_Id = ProtGewichtId then
    try
      ProtGewichtId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          // lfd. Nr. (6 Stellen)
          //FGerNr := StrToInt(StrLPas(EmpfBuff + 0, 2));
          ProtNr := StrToInt(String(StrLPas(EmpfBuff + 2, 4)));
          //Display := LTrimCh(EmpfBuff + 6, '0');  //führende 0en weg
          for I := 6 to StrLen(EmpfBuff) - 1 do
            if IsAlpha(EmpfBuff[I]) then
              GeStr := GeStr + String(EmpfBuff[I]) else
            if IsNum(EmpfBuff[I]) then
              GewStr := GewStr + String(EmpfBuff[I]);  //Gewicht nur Ziffern interpretieren
          Include(FaWaStatus, fwsProtNr);
          StrToGewicht(GewStr, Gewicht);
          Include(FaWaStatus, fwsGewichtOK);
          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
        end else
        begin
          FaWaStatus := [fwsTimeout];
          Gewicht := 0;
        end;
      except
        FaWaStatus := [fwsTimeout];
        Gewicht := 0;
      end;
    finally
      if assigned(FOnProtGewicht) then
        FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else
    begin
    end;
  end;
end;

procedure TDwtEnq.Poll(Sender: TObject);
var
  TelId: integer;
begin
  if StatusId > 0 then
  begin
    TelId := StatusId;
    StatusId := -1;
    if assigned(FOnStatus) then
      FOnStatus(TelId, 0, [fwsKeinGewicht]);
  end;
  if DruckId > 0 then
  begin
    TelId := DruckId;
    DruckId := -1;
    if assigned(FOnZeilendruck) then
      FOnZeilendruck(TelId, []);
  end;
end;

function TDwtEnq.Nullstellen: longint;
{Nullstellen nicht möglich}
begin
  result := -1;
end;

function TDwtEnq.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy(Befehl, chr(ENQ));
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TDwtEnq.HoleStatus: longint;
{HoleStatus nicht möglich}
begin
  StatusId := NewTelId;  //Ereignis in Poll
  Result := StatusId;
end;

function TDwtEnq.Zeilendruck(Zeile: string): longint;
begin
  DruckId := NewTelId;   //Ereignis in Poll
  Result := DruckId;
end;

procedure TDwtEnq.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
begin
  if ATel.ID <> ProtGewichtId then
    Exit;

  StrCopy(ATel.InData, '');
  // ProtGewicht
  // wwppppgggg,gkg    wobei w=WaageNr, p=ProtNr, g=Gewicht
  Inc(SimProtNr);

  StrFmt(ATel.InData, '01%04.4d%05.5dkg' + CRLF,
      [SimProtNr, SimGewicht]);

  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

end.
