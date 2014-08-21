unit Dwt2kmp;
(* Fahrzeugwaage Pfister DWT11 Version Hobo (Standard)
   xx.02.00 RW   Modifiziert für Gambach
*)
interface

uses
  Math,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

const
 SubStr: PAnsiChar = 'GO';

type
  TDwt2Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    procedure StrToGewicht(GewStr: string; var Gewicht: double);
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    Bef : string[2];
    Netto : string[6];
    NettoAnzeige : string[10];
    NachK: integer;

    Antwort: PAnsiChar;
    AntwLen: integer;
    NettoId : Longint;
    NullstellenId : longint;
    ProtZeileId : longint;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure UserFnk(ATel: TTel; FnkName : string); override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function HoleNetto: longint;
    function Nulstellen: longint;
    function ProtokollZeile(Tel_Id: Longint): longint;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    function DruckeBlock(ABlock: TStrings): longint; override;

    function DelSpNr(SpNr: integer): longint; override;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, Err__Kmp, CPor_Kmp;
(*** Initialisierung *********************************************************)

procedure TDwt2Kmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';do not edit');
  Description.Add('S:^B');
  Description.Add('W:^P');
  Description.Add('B:');
  Description.Add('W:^P');
  Description.Add('W:^B');
  Description.Add('S:^P');
  Description.Add('A:255,^P,^C');
  Description.Add('S:^P');
end;

constructor TDwt2Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
  NettoId := -1;
end;

procedure TDwt2Kmp.Loaded;
begin
  inherited Loaded;
end;

destructor TDwt2Kmp.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TDwt2Kmp.Init;
begin
  inherited Init;
end;


(*** Interne Methoden *******************************************************)

procedure TDwt2Kmp.StrToGewicht(GewStr: string; var Gewicht: double);
begin
  if Nk < 0 then
    NachK := -Nk else
    NachK := 0;
  Gewicht := RoundDec(StrToFloatTol(GewStr) * Power(10, Nk), NachK);
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TDwt2Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L, Offset : integer;
  ATel : TTel;
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

    if Tel_Id = StatusId then            {n.b.}
    try
      StatusId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      ProtNr := 0;
      try
        if ATel.Status = cpsOK then
        begin
          Bef := StrLPas(EmpfBuff+0, 2);
          include(FaWaStatus, fwsWaagenstoerung);
          if Bef = 'E1' then EError('%s:Überlast,Testzahl,Meßprogramm',[Bef]);
          if Bef = 'BY' then EError('%s:Negatives Gewicht',[Bef]);
          if Bef = 'E2' then EError('%s:Speicher voll',[Bef]);
          if Bef <> 'G0' then EError('%s:DWT2-Fehler',[Bef]);
          exclude(FaWaStatus, fwsWaagenstoerung);
          Netto := StrLPas(EmpfBuff+3, 6);
          Nk := -StrToInt(String(StrLPas(EmpfBuff+10, 1)));
          ProtNr := StrToInt(String(StrLPas(EmpfBuff+12, 3)));
          DelSpNr(ProtNr);                    {Speichernummer wieder löschen}
          Include(FaWaStatus, fwsGewichtOk);
          StrToGewicht(String(Netto), Gewicht);
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
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    if (Tel_Id = ProtGewichtId) then      (* Gewicht holen und Eichfähig speichern *)
    try
      ProtGewichtId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      ProtNr := 0;
      try
        if ATel.Status = cpsOK then
        begin
          Offset := 0;
          if EmpfBuff[0] = AnsiChar(2) then
            Offset := 1;
          if EmpfBuff[1] = AnsiChar(2) then
            Offset := 2;
          include(FaWaStatus, fwsWaagenstoerung);
          Bef := StrLPas(EmpfBuff+0+Offset, 2);
          if Bef = 'E1' then EError('%s:Überlast,Testzahl,Meßprogramm',[Bef]);
          if Bef = 'BY' then EError('%s:Negatives Gewicht',[Bef]);
          if Bef = 'E2' then EError('%s:Speicher voll',[Bef]);
          if Bef <> 'G0' then EError('%s:DWT2-Fehler',[Bef]);
          exclude(FaWaStatus, fwsWaagenstoerung);
          Netto := StrLPas(EmpfBuff+3+Offset, 6);
          //Nk := -StrToInt(StrLPas(EmpfBuff+10+Offset, 1)); //weg MD 02.05.05
          ProtNr := StrToInt(String(StrLPas(EmpfBuff+12+Offset, 3)));
          ProtokollZeile(ProtNr);              {Protokollzeile}
          DelSpNr(ProtNr);                    {Speichernummer wieder löschen}
          Include(FaWaStatus, fwsGewichtOk);
          StrToGewicht(String(Netto), Gewicht);
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

    if (Tel_Id = NettoId) then      (* Gewicht holen und Eichfähig speichern *)
    try
      NettoId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      ProtNr := 0;
      try
        Offset := 0;
          if EmpfBuff[0] = AnsiChar(2) then
            Offset := 1;
          if EmpfBuff[1] = AnsiChar(2) then
            Offset := 2;
        if ATel.Status = cpsOK then
        begin
          Include(FaWaStatus, fwsGewichtOk);
          NettoAnzeige := StrLPas(EmpfBuff+Offset, 10);
          Display := String(NettoAnzeige);
          Gewicht := StrToFloatTol(String(NettoAnzeige)); //kann in kg sein
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
      if assigned(FOnStatus) then         //zwingend für QuvaSvr
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    if (Tel_Id = DruckId) then     (* Ausdruck Block 12wwff *)
    try
      DruckId := -1;
      try
        if ATel.Status = cpsOK then
        begin
          FaWaStatus := [fwsDruckerStoerung];
          Bef := StrLPas(EmpfBuff+0, 2);
          if Bef = 'E2' then EError('%s:Speichernr falsch',[Bef]);
          if Bef = 'E3' then EError('%s:Druckerstörung',[Bef]);
          if Bef <> 'OK' then EError('%s:DWT11-Fehler',[Bef]);
          exclude(FaWaStatus, fwsDruckerStoerung);
        end else
        begin
          Include(FaWaStatus, fwsTimeout);
        end;
      except on E:Exception do
        begin
          Include(FaWaStatus, fwsTimeout);
          Display := E.Message;
          Prot0('%s(%.*s)',[E.Message, ATel.OutDataLen, ATel.OutData]);
        end;
      end;
    finally
    end else
    
    begin
      (* Speichernummer(n) löschen: Erfolg anzeigen *)
    end;
  end;
end;

function TDwt2Kmp.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy(Befehl, '05'+CRLF+CHR(16) + CHR(3));
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TDwt2Kmp.Nulstellen: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy(Befehl, '43'+CRLF+CHR(16) + CHR(3));
  BefLen := StrLen(Befehl);
  NullstellenId := Start(Befehl, BefLen);
  Result := NullstellenId;
end;

function TDwt2Kmp.ProtokollZeile(Tel_Id: Longint): longint;
var
  BefelString : String;
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  BefelString := '13'+ CRLF + 'Protokollzeile am ';
  BefelString := BefelString + FormatDateTime('dd.mm.yyyy hh:nn', now);
  BefelString := BefelString + 'Speicher = ' + IntToStr(Tel_Id) + ' Gewicht = <';
  if Tel_Id < 100 then
    BefelString := BefelString + '0' + IntToStr(Tel_Id) + '>'+ CRLF + CHR(16) + CHR(3)
  else
    BefelString := BefelString + IntToStr(Tel_Id) + '>'+ CRLF + CHR(16) + CHR(3);
  StrPCopy(Befehl, AnsiString(BefelString));
  BefLen := StrLen(Befehl);
  NettoId := Start(Befehl, BefLen);
  Result := NettoId;
end;

function TDwt2Kmp.HoleNetto: longint;
//statt Status (der erzeugt Protokollwägung)
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy(Befehl, '02'+CRLF+CHR(16) + CHR(3));
  BefLen := StrLen(Befehl);
  NettoId := Start(Befehl, BefLen);
  Result := NettoId;
end;

function TDwt2Kmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy(Befehl, '05'+CRLF+CHR(16) + CHR(3));
  BefLen := StrLen(Befehl);
  StatusId := Start(Befehl, BefLen);
  Result := StatusId;
end;

function TDwt2Kmp.DelSpNr(SpNr: integer): longint;
(* Speichernummern löschen
   SpNr: -1 = alle *)
var
  Befehl : array[0..255] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '12'+CRLF+'%03.3d'+CRLF+CHR(16) + CHR(3), [SpNr]);
  BefLen := StrLen(Befehl);
  Result := Start(Befehl, BefLen);    {geht schneller da im Hintergrund}
end;

function TDwt2Kmp.DruckeBlock(ABlock: TStrings): longint;
var
  Befehl : array[0..250] of AnsiChar;
  I, BefLen: integer;
begin
  Result := -1;
  DruckBlock.Assign(ABlock);
  DruckIndex  := 0;
  for I:= 0 to DruckBlock.Count-1 do
  begin
    StrFmt(Befehl, '13'+CRLF+'%s'+CHR(16) + CHR(3)+CRLF, [DruckBlock.Strings[I]]);
    BefLen := StrLen(Befehl);
    AnsiToOem(Befehl, Befehl);
    DruckId := Start(Befehl, BefLen);
    Result := DruckId;
  end;
  (* Formularvorschub *)
  if FormLen > 1 then
  begin
    StrPCopy(Befehl, '16'+CRLF+CHR(16) + CHR(3));
    BefLen := StrLen(Befehl);
    Start(Befehl, BefLen);
  end;
end;

procedure TDwt2Kmp.UserFnk(ATel: TTel; FnkName : string);
var
  I : integer;
  BccCh : Byte;
begin
  if Uppercase(FnkName) = 'ROWBCC' then
  begin
    if Bcc then
    begin
      BccCh := 0;
      for I:= 0 to ATel.OutDataLen-1 do
        BccCh := BccCh xor ord(ATel.OutData[I]);
      BccCh := BccCh xor DLE;   {^P}
      BccCh := BccCh xor ETX;   {^C}
      ComPort.Write(Addr(BccCh), 1);
    end;
  end else
    inherited UserFnk(ATel, FnkName);
end;

end.
