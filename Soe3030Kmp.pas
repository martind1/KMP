unit Soe3030Kmp;
(* Soehnle 3030 Terminal
   RS232 und Ethernet Protokoll
   16.05.10 md  erstellt
-------------------------------------
todo: GE automatisch erkennen -> BuildDescription
*)
interface

uses
  Math,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TSoe3030Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    Netto : string;
    ProtStr: string;  //'A' Kennung falls nicht numerisch
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
    function Zeilendruck(Zeile: string): longint; override;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, Err__Kmp, CPor_Kmp;
(*** Initialisierung *********************************************************)

constructor TSoe3030Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TSoe3030Kmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add('I:');
  Description.Add('B:');     //'<A>' oder '<B>'
  Description.Add('A:64:1'); //Max:Min:1 Zeichen
end;

procedure TSoe3030Kmp.Loaded;
begin
  inherited Loaded;
end;

destructor TSoe3030Kmp.Destroy;
begin
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TSoe3030Kmp.Init;
begin
  inherited Init;
end;


(*** Interne Methoden *******************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

procedure TSoe3030Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L: integer;
  ATel : TTel;
  S1, S2, S3, S4, NextS: string;
  P: integer;
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

    if Tel_Id = StatusId then  //'<A>' -> '001001N       56,0 kg '
    try                        //          0    5    0    5    0
      StatusId := -1;          //                    1    1    2
      FaWaStatus := [];
      Gewicht := 0;
      ProtNr := 0;
      try
        if ATel.Status = cpsOK then
        begin
          S1 := PStrTok(String(StrLPas(EmpfBuff+0, L)), ' ', NextS);  //001001N
          S2 := PStrTok('', ' ', NextS);                      //56,0
          S3 := PStrTok('', ' ', NextS);                      //kg
          {Hier OK da ShortDesc unabh. von GE:}
          GE := S3;   //t, kg, lb
          Netto := S2;
          P := Pos(',', Netto);
          if P > 0 then
          begin
            Nk := P - length(Netto);  //12,34 -> -2
            Netto := StrCgeChar(Netto, ',', #0);
          end;
          StrToGewicht(Netto, Gewicht);   // bzgl.Nk, setzt NachK
          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
          Include(FaWaStatus, fwsGewichtOk);
        end else
        begin
          Include(FaWaStatus, fwsTimeout);
          Gewicht := 0;
          Display := 'Timeout';
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
      // '<B>' -> 'A0000007 001001N       96,0 kg '

      ProtGewichtId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      ProtNr := 0;
      try
        if ATel.Status = cpsOK then
        begin
          S1 := PStrTok(String(StrLPas(EmpfBuff+0, L)), ' ', NextS);  //A0000007 - Eichnr
          S2 := PStrTok('', ' ', NextS);                      //001001N ?
          S3 := PStrTok('', ' ', NextS);                      //96,0
          S4 := PStrTok('', ' ', NextS);                      //kg

          {Hier OK da ShortDesc unabh. von GE:}
          GE := S4;   //t, kg, lb
          Netto := S3;
          P := Pos(',', Netto);
          if P > 0 then
          begin
            Nk := P - length(Netto);  //12,34 -> -2
            Netto := StrCgeChar(Netto, ',', #0);
          end;
          StrToGewicht(Netto, Gewicht);   // bzgl.Nk, setzt NachK
          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
          Include(FaWaStatus, fwsGewichtOk);

          ProtStr := S1;
          SpeicherNr := Char1(S1);
          if IsAlpha(Char1(SpeicherNr)) then
            ProtStr[1] := Chr(Ord(Char1(SpeicherNr)) - Ord('A') + Ord('1'));  //'A'->'1'
          ProtNr := StrToIntTol(ProtStr);

          Include(FaWaStatus, fwsGewichtOk);
          StrToGewicht(Netto, Gewicht);
          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
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

    {Antwort auf Befehl Zeilendruck}
    if (Tel_Id = DruckId) then
    begin  //nichts zu tun. nur Ereignis auslösen.
      DruckId := -1;
      FaWaStatus := [];
      if assigned(FOnZeilendruck) then
        FOnZeilendruck(Tel_Id, FaWaStatus);
    end else

    begin
      (* Speichernummer(n) löschen: Erfolg anzeigen *)
    end;
  end;
end;

function TSoe3030Kmp.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy(Befehl, '<B>');
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TSoe3030Kmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy(Befehl, '<A>');
  BefLen := StrLen(Befehl);
  StatusId := Start(Befehl, BefLen);
  Result := StatusId;
end;

procedure TSoe3030Kmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
Var
  GewStr, GEStr: AnsiString;
begin
  StrCopy(ATel.InData, '');

  if GE = 't' then
  begin
    GEStr := 't';
    GewStr := AnsiString(Format('%.2f', [SimGewicht / 100]));
  end else
  begin
    GEStr := 'kg';
    GewStr := AnsiString(Format('%d,0', [SimGewicht]));
  end;
  if StrLComp(ATel.OutData, '<B>', 3) = 0 then
  begin  // ProtGewicht
    Inc(SimProtNr);
    StrFmt(ATel.InData, 'A%-7.7d 001001N %8.8s %s', [SimProtNr, GewStr, GEStr]);
  end else
  begin  //Status
    StrFmt(ATel.InData, '001001N %8.8s %s', [GewStr, GEStr]);
  end;

  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TSoe3030Kmp.Zeilendruck(Zeile: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '', [0]);  //keine Kommunikation. Nur OnAntwort.
  BefLen := StrLen(Befehl);
  DruckID := StartFlags(Befehl, BefLen, [cpfPoll, cpfDummy], '', 0);
  Result := DruckID;
end;

end.
