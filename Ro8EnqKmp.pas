unit Ro8EnqKmp;
(* Rowa8 ENQ Protokoll mit bis zu 6 Waagen pro Datensatz
   07.09.01 MD Erstellt
*)
interface

uses
{$ifdef WIN32}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Math,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;
{$else}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;
{$endif}
const
  Ro8MaxWaagen = 6;

type
  TRo8Enq = class(TFaWaKmp)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    AnzahlWaagen: integer;
    Waage: array[1..Ro8MaxWaagen] of record
                                       Fehlercode: byte;
                                       Statuscode: byte;
                                       Gewicht: double;
                                       Dimension: string;
                                     end;

    Antwort: PAnsiChar;
    AntwLen: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Init; override;
    function HoleStatus: longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;

    procedure ErrorToWaStat(Error: integer; var Status: TFaWaStatus);
    procedure StatusToWaStat(Statuscode: integer; var Status: TFaWaStatus);
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, CPor_Kmp, Err__Kmp;
(*** Initialisierung *********************************************************)

procedure TRo8Enq.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  if ComPort <> nil then
    Description.Add(Format('T:%d',[ComPort.TimeOut])) else
    Description.Add('T:7000');
  Description.Add('S:^E');     {ENQ}
  Description.Add('W:^B');     {STX}
  Description.Add('A:255,^C'); {ETX}
end;

constructor TRo8Enq.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
end;

procedure TRo8Enq.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TRo8Enq.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TRo8Enq.Init;
begin
  inherited Init;
end;


(*** Interne Methoden *******************************************************)

procedure TRo8Enq.ErrorToWaStat(Error: integer; var Status: TFaWaStatus);
begin
  if Error = 0 then
    Include(Status, fwsGewichtOK);
  if Error in [$41, $42, $44, $60] then
    Include(Status, fwsWaagenstoerung);
  (*
  if BITIS(Ord(Tok[0]), $8) then Include(Status, fwsStillstand);
  if BITIS(Ord(Tok[0]), $2) then Include(Status, fwsKeinGewicht);  {Gew.ungültig}
  if BITIS(Ord(Tok[0]), $1) then Include(Status, fwsNull);  {0t}
  *)
end;

procedure TRo8Enq.StatusToWaStat(Statuscode: integer; var Status: TFaWaStatus);
begin
  if Statuscode <> $41 then
    Include(Status, fwsKeinStillstand);
  if Statuscode in [$42, $44] then
    Include(Status, fwsNull);
  if Statuscode <> $41 then
    Exclude(Status, fwsGewichtOK);
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TRo8Enq.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L, I1 : integer;
  ATel : TTel;
  Offs: integer;
  {Vorz: string;}
begin
  inherited DoAntwort(Sender, Tel_Id);

  FaWaStatus := [];
  ATel := nil;
  for I1 := low(EmpfBuff) to high(EmpfBuff) do
    EmpfBuff[I1] := #0;
  L := sizeof(EmpfBuff) - 1;
  try
    ATel := GetTel(Tel_Id);
    GetData(Tel_Id, EmpfBuff, L);
  finally
    EmpfBuff[L] := #0;

    {Antwort auf Befehl Status}
    if Tel_Id = StatusId then
    try
      StatusId := -1;
      for I1 := 1 to Ro8MaxWaagen do
      begin
        Waage[I1].FehlerCode := 97; //nicht dabei
        Waage[I1].StatusCode := 97; //nicht dabei
        Waage[I1].Gewicht := 0;
        Waage[I1].Dimension := '';
      end;
      if ATel.Status = cpsOK then
      try
        AnzahlWaagen := StrToIntTol(StrLPas(EmpfBuff+0, 1));
        Offs := 1;
        Gewicht := 0;
        for I1 := 1 to AnzahlWaagen do
        begin
          Waage[I1].FehlerCode := Ord(EmpfBuff[Offs]);
          Inc(Offs, 1);
          Waage[I1].StatusCode := Ord(EmpfBuff[Offs]);
          Inc(Offs, 1);
          {Vorz := StrLPas(EmpfBuff+ Offs, 1);
          Inc(Offs, 1);}
          Waage[I1].Gewicht := StrToFloatTol(String(StrLPas(EmpfBuff+ Offs, 7)));
          Inc(Offs, 7);
          {if Vorz = '-' then
            Waage[I1].Gewicht := -Waage[I1].Gewicht;}
          Waage[I1].Dimension := String(StrLPas(EmpfBuff+ Offs, 2));
          Inc(Offs, 2);

          Gewicht := Gewicht + Waage[I1].Gewicht;
        end;
        GewichtToStr(Gewicht, Display);
        Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
      except
        on E:Exception do
        begin
          Include(FaWaStatus, fwsTimeOut);
          Include(FaWaStatus, fwsWaagenNr);
          Display := E.Message;
          Prot0('%s',[E.Message]);
        end;
      end else
      begin
        Include(FaWaStatus, fwsWaagenstoerung);
        Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
      end;
    finally
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else
    begin
    end;
  end;
end;

procedure TRo8Enq.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
begin
  StrCopy(ATel.InData, '');
//  StrFmt(ATel.InData, '%d%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI',
//      [6, AnsiChar(ord($40)), AnsiChar(ord($41)), FloatToStr((SimGewicht + 1000) / 1000),
//          AnsiChar(ord($41)), AnsiChar(ord($42)), FloatToStr((SimGewicht + 2000) / 1000),
//          AnsiChar(ord($42)), AnsiChar(ord($44)), FloatToStr((SimGewicht + 3000) / 1000),
//          AnsiChar(ord($44)), AnsiChar(ord($48)), FloatToStr((SimGewicht + 4000) / 1000),
//          AnsiChar(ord($60)), AnsiChar(ord($50)), FloatToStr((SimGewicht + 4000) / 1000),
//          AnsiChar(ord($01)), AnsiChar(ord($01)), FloatToStr((SimGewicht + 4000) / 1000)
//      ]);
  StrFmt(ATel.InData, '%d%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI',
      [6, AnsiChar(ord($40)), AnsiChar(ord($41)), FloatToStr(SimGewicht * 5 / 6000),
          AnsiChar(ord($41)), AnsiChar(ord($42)), FloatToStr(SimGewicht * 9 / 6000),
          AnsiChar(ord($42)), AnsiChar(ord($44)), FloatToStr(SimGewicht *10 / 6000),
          AnsiChar(ord($44)), AnsiChar(ord($48)), FloatToStr(SimGewicht *10 / 6000),
          AnsiChar(ord($60)), AnsiChar(ord($50)), FloatToStr(SimGewicht *11 / 6000),
          AnsiChar(ord($00)), AnsiChar(ord($00)), FloatToStr(SimGewicht *15 / 6000)
      ]);
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TRo8Enq.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, 'egal', [0]);
  BefLen := StrLen(Befehl);
  StatusId := Start(Befehl, BefLen);
  Result := StatusId;
end;

end.
