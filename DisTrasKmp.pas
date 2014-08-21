unit DisTrasKmp;
(* Schenk Disomat B+ mit Tras-Protokoll (Einfachst-Protokoll Dietrich Waagenbau)

   TS 10.02.03    erstellen
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

const
  NUL = 0;        {^@}

type
  TDisTrasKmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    LenProtNr: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Loaded; override;
    function Nullstellen: longint; override;
    function HoleStatus: longint; override;
    function ProtGewicht( Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Math, Prots, Err__Kmp;

(*** Initialisierung *********************************************************)

constructor TDisTrasKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LenProtNr := 6;          // Standard
end;

procedure TDisTrasKmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;

  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  if ComPort <> nil then
    Description.Add(Format('T:%d',[ComPort.TimeOut])) else
    Description.Add('T:2000');

  Description.Add('B:');          {->ENQ}
  Description.Add('A:11');       {<-Daten, (mit abschließendem NUL}
  Description.Add('S:^F');        {->ACK}
end;

procedure TDisTrasKmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TDisTrasKmp.Destroy;
begin
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TDisTrasKmp.Init;
begin
  inherited init;
end;

(*** Interne Methoden *******************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

procedure TDisTrasKmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L : integer;
  ATel : TTel;
  Netto : string[5];
begin
  inherited DoAntwort( Sender, Tel_Id);

  FaWaStatus := [];
  ATel := nil;
  L := sizeof(EmpfBuff) - 1;
  try
    ATel := GetTel( Tel_Id);
    GetData( Tel_Id, EmpfBuff, L);
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
          ProtNr := StrToInt(String(StrLPas(EmpfBuff, LenProtNr)));
          Include(FaWaStatus, fwsProtNr);
          Netto := StrLPas(EmpfBuff + LenProtNr, 11 - LenProtNr);
          StrToGewicht(String(Netto), Gewicht);
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
        FOnProtGewicht( Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else
  end;
end;

function TDisTrasKmp.Nullstellen: longint;
{Nullstellen nicht möglich}
begin
  result := -1;
end;

function TDisTrasKmp.ProtGewicht( Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy( Befehl, CHR(5));
  BefLen := StrLen( Befehl);
  ProtGewichtId := Start( Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TDisTrasKmp.HoleStatus: longint;
{HoleStatus nicht möglich}
begin
  Result := -1;
end;

procedure TDisTrasKmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
Var
  Gew : Longint;
  NachK : Integer;
begin
  if ATel.ID <> ProtGewichtId then
    Exit;

  StrCopy(ATel.InData, '');
  // ProtGewicht
  // nnnnnnggggg       wobei nn - lfd. Nr (6 Stellen), gg - Gewicht (5 Stellen)
  Inc(SimProtNr);
  if Nk < 0 then NachK := -Nk
  else NachK := Nk;
  Gew := Round(SimGewicht * Power(10, NachK-1));

  StrFmt(ATel.InData, '%*.*d%*.*d#' + Chr(NUL),
      [LenProtNr, LenProtNr, SimProtNr, 11-LenProtNr, 11-LenProtNr, Gew]);

  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

end.
