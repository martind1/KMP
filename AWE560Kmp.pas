unit AWE560Kmp;
(* Wägeelektronik AWE0560
   Nk wird automatisch gesetzt. Umrechnung Waage-Gewicht bzgl. unserer GE
   17.10.07 MD  erstellt
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Math,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TAWE560Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    ShortDescription: TStringList;
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    WaaNr: string;
    Netto: string;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
    function Nullstellen: longint; override;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, CPor_Kmp, Err__Kmp;

(*** Initialisierung *********************************************************)

procedure TAWE560Kmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  Description.Add('S:^B');  //STX
  Description.Add('B:');
  Description.Add('S:^C');  //ETX
  ShortDescription.Assign(Description);

  Description.Add('W:^B');
  Description.Add('A:255,^C');
end;

constructor TAWE560Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ShortDescription := TStringList.Create;
end;

procedure TAWE560Kmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TAWE560Kmp.Destroy;
begin
  ShortDescription.Free;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TAWE560Kmp.Init;
begin
  inherited Init;
end;


(*** Interne Methoden *******************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

procedure TAWE560Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L: integer;
  ATel : TTel;
  S1, S2, S3, AnsiGE: AnsiString;
  G1, G2: AnsiChar;
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
(* Es gilt die Tabelle und nicht das Datenprotokoll-Beispiel.
0000|30/08/200616:25:15|000022|1|___3062|00000000|00000000|kg|132153
0000|30/08/200616:25:15|000022|1|__30.62|00000000|00000000|t |132153
000030/08/200616:25:15000221____30620000000000000000kg132153
000030/08/200616:25:15000221___30.620000000000000000t 132153
*)
    if Tel_Id = StatusId then            {N -> 12.34 t bzw. '   12 kg'}
    try
      StatusId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      ProtNr := 0;
      try
        if ATel.Status = cpsOK then
        begin
          if L <= 60 then
          begin
            S1 := StrLPas(EmpfBuff+22, 5);  //ProtNr
            S2 := StrLPas(EmpfBuff+28, 8);  //Brutto
            S3 := StrLPas(EmpfBuff+52, 2);  //Einheit kg, t_
          end else
          begin  //ProtNr ist größer 99999: wird dann 6stellig (Nico Schröder, 02.11.07)
            S1 := StrLPas(EmpfBuff+22, 6);  //ProtNr
            S2 := StrLPas(EmpfBuff+29, 8);  //Brutto
            S3 := StrLPas(EmpfBuff+53, 2);  //Einheit kg, t_
          end;
          {Hier OK da ShortDesc unabh. von GE:}
          AnsiGE := AnsiString(GE);
          G1 := UpCase(Char1(AnsiGE));   //t -> T, kg -> K
          G2 := UpCase(Char1(S3));   //von Waage
          if G1 = G2 then
            Nk := 0 else
          if G1 = 'T' then           //kg -> t
            Nk := -2 else
          if G1 = 'K' then           //t -> kg
            Nk := 2;
          Netto := String(S2);   //Gewicht von Waage
          StrToGewicht(Netto, Gewicht);   // bzgl.Nk, setzt NachK
          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
          Include(FaWaStatus, fwsGewichtOk);
        end else
        begin
          Include(FaWaStatus, fwsTimeout);
          Gewicht := 0;
        end;
      except on E:Exception do
        begin
          Include(FaWaStatus, fwsTimeout);
          Display := E.Message;
          Prot0('%s(%.*s)',[E.Message, ATel.OutDataLen, ATel.OutData]);
          Gewicht := 0;
        end;
      end;
    finally
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    if (Tel_Id = ProtGewichtId) then      (* Gewicht holen und Eichfähig speichern *)
    try
      ProtGewichtId := -1;               //ist 0 1480  0,0t
      FaWaStatus := [];                  //gew ab 18,8. bis Ende  prot ab 11,7
      Gewicht := 0;                      //ab $MP: 001pppppppgggggggg
      ProtNr := 0;                       // 1   5    0    5    0    5
      try                                // 0    5    0    5    0    5
        if ATel.Status = cpsOK then      // $MPNO STAB-1234,56kgBC
        begin
          if L <= 60 then
          begin
            S1 := StrLPas(EmpfBuff+22, 5);  //ProtNr
            S2 := StrLPas(EmpfBuff+28, 8);  //Brutto
            S3 := StrLPas(EmpfBuff+52, 2);  //Einheit kg, t_
          end else
          begin  //ProtNr ist größer 99999: wird dann 6stellig (Nico Schröder, 02.11.07)
            S1 := StrLPas(EmpfBuff+22, 6);  //ProtNr
            S2 := StrLPas(EmpfBuff+29, 8);  //Brutto
            S3 := StrLPas(EmpfBuff+53, 2);  //Einheit kg, t_
          end;
          {Hier OK da ShortDesc unabh. von GE:}
          AnsiGE := AnsiString(GE);
          G1 := UpCase(Char1(AnsiGE));   //t -> T, kg -> K
          G2 := UpCase(Char1(S3));   //von Waage
          if G1 = G2 then
            Nk := 0 else
          if G1 = 'T' then           //kg -> t
            Nk := -2 else
          if G1 = 'K' then           //t -> kg
            Nk := 2;
          Netto := String(S2);   //Gewicht von Waage
          StrToGewicht(Netto, Gewicht);   // bzgl.Nk, setzt NachK
          ProtNr := StrToIntTol(S1);
          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
          Include(FaWaStatus, fwsGewichtOk);
        end else
        begin
          Include(FaWaStatus, fwsTimeout);
          Gewicht := 0;
        end;
      except on E:Exception do
        begin
          Include(FaWaStatus, fwsTimeout);
          Display := E.Message;
          Prot0('%s(%.*s)',[E.Message, ATel.OutDataLen, ATel.OutData]);
          Gewicht := 0;
        end;
      end;
    finally
      if assigned(FOnProtGewicht) then
        FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else


    begin
      (* Speichernummer(n) löschen: Erfolg anzeigen *)
    end;
  end;
end;

procedure TAWE560Kmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
  Gew: Longint;
begin
  StrCopy(ATel.InData, '');
  Gew := SimGewicht;
  if SimGewicht < 0 then
  begin
    SimError := 30;
    Gew := -SimGewicht;
  end else
  if SimError = 30 then
    SimError := 0;
  if StrLComp(ATel.OutData, 'O', 2) = 0 then        // Nullstellen
  begin
    SimError := 0;                                   // immer 0
    SimGewicht := 0;
    //keine Antwort
  end else
  //if StrLComp(ATel.OutData, 'M', 1) = 0 then   und 'N'
  begin
    StrFmt(ATel.InData, '%-4.4s%-18.18s%05.5d1%-8.8d%-16.16skg132153',
      ['0000', FormatDateTime('dd/mm/yyyyhh:nn:ss', now),
       SimProtNr, Gew, '0']);
    SimProtNr := SimProtNr + 1;
  end;
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TAWE560Kmp.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy(Befehl, 'N');
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  //GetTel(ProtGewichtId).Description.Assign(ShortDescr);  MPP=long
  Result := ProtGewichtId;
end;

function TAWE560Kmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy(Befehl, 'M');
  BefLen := StrLen(Befehl);
  StatusId := StartFlags(Befehl, BefLen, [cpfPoll, cpfCache], '', 0);
  Result := StatusId;
end;

function TAWE560Kmp.Nullstellen: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy(Befehl, 'O');
  BefLen := StrLen(Befehl);
  NullstellenId := Start(Befehl, BefLen);
  GetTel(NullstellenId).Description.Assign(ShortDescription);  //ohne Antwort
  Result := NullstellenId;
end;

end.
