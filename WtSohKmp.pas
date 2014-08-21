unit WTSOHKMP;
(* Fahrzeugwaage Widra mit Pfister-Protokoll
   entspricht teilweise Pfister DwtSoh und Essmann
   11.10.02 TS Erstellen *)
interface

uses
{$ifdef WIN32}
  Math,
{$else}
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TWtSohKmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    Bef : string[2];
    Netto : string[6];

    Antwort: PAnsiChar;
    AntwLen: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function ProtGewicht( Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    function Zeilendruck(Zeile: string): longint; override;
    function DruckeBlock( ABlock: TStrings): longint; override;
    function DelSpNr( SpNr: integer): longint; override;
    procedure DoSimul(ATel: TTel); override;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, Err__Kmp, CPor_Kmp;

const
  sCR = #$D;      {HEX 'D' }

(*** Initialisierung *********************************************************)

procedure TWtSohKmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  Description.Add('S:^A');           {-> SOH}
  Description.Add('W:^E');           {<- ENQ}
  Description.Add('B:');
  Description.Add('S:^D');           {-> EOT}
  Description.Add('W:^F');           {<- ACK}
  {Antwort}
  Description.Add('W:^A');           {<- SOH}
  Description.Add('S:^E');           {-> ENQ}
  Description.Add('A:255,^D');       {-> Daten, EOT}
  Description.Add('S:^F');           {-> ACK}
end;

constructor TWtSohKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc( AntwLen);
end;

procedure TWtSohKmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TWtSohKmp.Destroy;
begin
  StrDispose( Antwort);
  Antwort := nil;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TWtSohKmp.Init;
begin
  inherited Init;
end;


(*** Interne Methoden *******************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

procedure TWtSohKmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L: integer;
  ATel : TTel;
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
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

    if (Tel_Id = StatusId) then
    (* 50: Gewicht senden ohne Speichern *)
    try
      StatusId := -1;
      Gewicht := 0;
      FaWaStatus := [];
      if ATel.Status = cpsOK then
      try
        Bef := StrLPas( EmpfBuff+0, 2);
        if Bef = 'E1' then begin
          EError('%s:Überlast,Testzahl,Meßprogramm',[Bef]);
          Include(FaWaStatus, fwsUeberlast);
        end else
        if Bef <> 'G3' then begin
          Include(FaWaStatus, fwsWaagenstoerung);
          EError('%s:Waagen-Fehler',[Bef]);
        end;
        Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
        Netto := StrLPas( EmpfBuff+4, 6);
        StrToGewicht(String(Netto), Gewicht);    {definiert auch NachK}
        Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
      except
        on E:Exception do
        begin
          Display := E.Message;
          Prot0('%s',[E.Message]);
        end;
      end else
        Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
    finally
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    if (Tel_Id = ProtGewichtId) and ProtDruck then
    try
      {05: Gewicht holen und Eichfähig speichern}
      ProtGewichtId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      ProtNr := 0;
      try
        if ATel.Status = cpsOK then
        begin
          {G0Mgggggg_e_sss_dd.mm.yy_hh.mmM}
          Bef := StrLPas( EmpfBuff+0, 2);
          include( FaWaStatus, fwsWaagenstoerung);
          if Bef = 'E1' then begin
            EError('%s:Überlast,Testzahl,Meßprogramm',[Bef]);
            Include(FaWaStatus, fwsUeberlast);
          end else
          if Bef = 'BY' then begin
            EError('%s:Negatives Gewicht',[Bef]);
            Include(FaWaStatus, fwsUnterlast);
          end else
          if Bef = 'E2' then begin
            Include(FaWaStatus, fwsWaagenstoerung);
            EError('%s:Speicher voll',[Bef]);
          end else
          if Bef = 'E3' then begin
            Include(FaWaStatus, fwsDruckerstoerung);
            EError('%s:Druckerstörung',[Bef]);
          end else
          if Bef <> 'G0' then begin
            Include(FaWaStatus, fwsWaagenstoerung);
            EError('%s:Waagen-Fehler',[Bef]);
          end;
          Exclude( FaWaStatus, fwsWaagenstoerung);
          Netto := StrLPas( EmpfBuff+3, 6);
          {Nk := -StrToInt( StrLPas( EmpfBuff+10, 1));  schlecht bei kg-Waage}
          ProtNr := StrToInt(String(StrLPas( EmpfBuff+12, 3)));

          Include( FaWaStatus, fwsGewichtOk);
          StrToGewicht(String(Netto), Gewicht);    {definiert auch NachK}
          Display := Format( '%5.*f %s', [NachK, Gewicht, GE]);
        end else
        begin
          Include( FaWaStatus, fwsTimeout);
          Gewicht := 0;
        end;
      except on E:Exception do
        begin
          Include( FaWaStatus, fwsTimeout);
          Display := E.Message;
          Prot0('%s(%.*s)',[E.Message, ATel.OutDataLen, ATel.OutData]);
          Gewicht := 0;
        end;
      end;
    finally
      if assigned(FOnProtGewicht) then
        FOnProtGewicht( Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else

    if (Tel_Id = ProtGewichtId) and not ProtDruck then
    try
      {18: Gewicht holen und im Alibispeicher speichern}
      ProtGewichtId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      ProtNr := 0;
      try
        if ATel.Status = cpsOK then
        begin
          {G4^Mgggggg_e_nnnnn__dd.mm.yy_hh.mmM}
          Bef := StrLPas( EmpfBuff+0, 2);
          include( FaWaStatus, fwsWaagenstoerung);
          if Bef = 'E1' then begin
            EError('%s:Überlast,Testzahl,Meßprogramm',[Bef]);
            Include(FaWaStatus, fwsUeberlast);
          end else
          if Bef = 'BY' then begin
            EError('%s:Negatives Gewicht',[Bef]);
            Include(FaWaStatus, fwsUnterlast);
          end else
          if Bef = 'E2' then begin
            Include(FaWaStatus, fwsWaagenstoerung);
            EError('%s:Speicher voll',[Bef]);
          end else
          if Bef = 'E3' then begin
            Include(FaWaStatus, fwsDruckerstoerung);
            EError('%s:Druckerstörung',[Bef]);
          end else
          if Bef <> 'G4' then begin
            Include(FaWaStatus, fwsWaagenstoerung);
            EError('%s:Waagen-Fehler',[Bef]);
          end else
          begin
            Exclude( FaWaStatus, fwsWaagenstoerung);
            Netto := StrLPas( EmpfBuff+3, 6);
            // Nk := (Ord(EmpfBuff[10]) - Ord('0')) * (-1);
            Nk := -StrToInt(String(StrLPas( EmpfBuff+10, 1)));

            ProtNr := StrToInt(String(StrLPas( EmpfBuff+12, 5)));
            Include(FaWaStatus, fwsProtNr);
            StrToGewicht(String(Netto), Gewicht);    {definiert auch NachK}
            Display := Format( '%5.*f %s', [NachK, Gewicht, GE]);
            Include( FaWaStatus, fwsGewichtOk);
          end;
        end else
        begin
          Include( FaWaStatus, fwsTimeout);
          Gewicht := 0;
        end;
      except on E:Exception do
        begin
          Include( FaWaStatus, fwsTimeout);
          Display := E.Message;
          Prot0('%s(%.*s)',[E.Message, ATel.OutDataLen, ATel.OutData]);
          Gewicht := 0;
        end;
      end;
    finally
      if assigned(FOnProtGewicht) then
        FOnProtGewicht( Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else

    {Antwort auf Befehl Drucken (Bef 13 oder 17)}
    if (Tel_Id = DruckId) then
    try
      {12: Drucke Zeile bzw. 17: Block}
      DruckId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          Bef := StrLPas(EmpfBuff, 2);
          if Bef = 'E2' then begin
            Include(FaWaStatus, fwsWaagenstoerung);
            EError('%s:Speicher nicht vorhanden',[Bef]);
          end else
          if Bef = 'E3' then begin
            Include(FaWaStatus, fwsDruckerstoerung);
            EError('%s:Druckerstörung',[Bef]);
          end else
          if Bef <> 'OK' then begin
            Include(FaWaStatus, fwsWaagenstoerung);
            EError('%s:Waagen-Fehler',[Bef]);
          end
          else Include(FaWaStatus, fwsGewichtOK);

          if Bef = 'OK' then
            if DruckIndex < DruckBlock.Count then
            begin
              StrFmt(Befehl, '17' +sCR+ '%s' +CRLF, [DruckBlock.Strings[DruckIndex]]);
              BefLen := StrLen(Befehl);
              Inc(DruckIndex);
              SMess('Drucke Zeile %d',[DruckIndex]);
              DruckId := Start(Befehl, BefLen);
            end else
              SMess('',[0]);
        end else
        begin
          if FaWaStatus = [] then
            FaWaStatus := [fwsTimeout];
        end;
      except
        if FaWaStatus = [] then
          FaWaStatus := [fwsTimeout];
      end;
    finally
      if assigned(FOnZeilendruck) then
        FOnZeilendruck(Tel_Id, FaWaStatus);
    end else
    if (Tel_Id = DelSpNrId) then
    begin
      (* Speichernummer(n) löschen: Ende anzeigen *)
      SMess('Löschen Speichernummern beendet',[]);
    end else
    begin
      (* Ausdruck Block 12wwff *)
    end;
  end;
end;

function TWtSohKmp.ProtGewicht( Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  if ProtDruck then
    StrPCopy( Befehl, '05'+sCR)             // mit Drucker
  else
    StrPCopy( Befehl, '18'+sCR);            // mit Alibispeicher
  BefLen := StrLen( Befehl);
  ProtGewichtId := Start( Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TWtSohKmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy( Befehl, '50'+sCR);
  BefLen := StrLen( Befehl);
  StatusId := Start( Befehl, BefLen);
  Result := StatusId;
end;

function TWtSohKmp.DelSpNr( SpNr: integer): longint;
(* Speichernummer löschen *)
var
  Befehl : array[0..255] of AnsiChar;
  i, BefLen: integer;
begin
  if SpNr = -1 then
  begin
    for i := 1 to 99 do
    begin
      StrFmt( Befehl, '12' + CRLF + '%03.3d' + CRLF, [i]);
      BefLen := StrLen( Befehl);
      DelSpNrId := Start(Befehl, BefLen);    {geht schneller da im Hintergrund}
      Result := DelSpNrId;
    end;
    SMess('Lösche Speichernummern, Bitte warten',[]);
  end
  else
  begin
    if ProtDruck then
    begin
      StrFmt( Befehl, '12'+ CRLF + '%03.3d' + CRLF, [SpNr]);
      BefLen := StrLen( Befehl);
      DelSpNrId := Start( Befehl, BefLen);    {geht schneller da im Hintergrund}
      Result := DelSpNrId;
    end
    else Result := -1;  // bei Alibispeicher Speichernr. löschen nicht notwendig
  end;
end;

function TWtSohKmp.Zeilendruck(Zeile: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  if ProtDruck then      // mit Protokolldruck
  begin
    StrFmt(Befehl, '13' +sCR+ '%s', [Zeile]);
    BefLen := StrLen(Befehl);
    AnsiToOem(Befehl, Befehl);
    DruckID := Start(Befehl, BefLen);
    Result := DruckID;
  end
  else Result := -1;
end;

function TWtSohKmp.DruckeBlock( ABlock: TStrings): longint;
var
  Befehl : array[0..250] of AnsiChar;
  I, BefLen: integer;
begin
  Result := -1;
  (* Formularlänge definieren *)
  if FormLen > 0 then
  begin
    StrFmt(Befehl, '15' +sCR + '0%-2.2d', [FormLen]);
    BefLen := StrLen(Befehl);
    Start(Befehl, BefLen);
  end;

  DruckBlock.Assign( ABlock);
  DruckIndex  := 0;
  for I:= DruckBlock.Count-1 downto 1 do with DruckBlock do      {Komprimieren}
  begin
    if (length( Strings[I-1]) + length( Strings[I]) <= 79) and
       (Pos('<', Strings[I-1]) = 0) and (Pos('<', Strings[I]) = 0) then
    begin
      Strings[I-1] := Format('%s'+#$A+'%s', [Strings[I-1], Strings[I]]);
      Delete(I);
    end;
  end;
  for I:= 0 to DruckBlock.Count-1 do
  begin
    StrFmt( Befehl, '17'+sCR+'%s'+CRLF, [DruckBlock.Strings[I]]);
    BefLen := StrLen( Befehl);
    AnsiToOem( Befehl, Befehl);
    Start( Befehl, BefLen);
  end;
  (* Formularvorschub *)
  if FormLen > 1 then
  begin
    StrPCopy( Befehl, '16'+sCR);
    BefLen := StrLen( Befehl);
    Start( Befehl, BefLen);
  end;
end;

procedure TWtSohKmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
  Gew: Longint;
begin
  StrCopy(ATel.InData, '');
  Gew := SimGewicht;
  if SimGewicht < 0 then
    Gew := -SimGewicht;

  if StrLComp(ATel.OutData, '50', 2) = 0 then       // Status
  begin
    StrFmt(ATel.InData, 'G3' +Chr(13)+ ' %06.6d'+Chr(13), [Gew]);
  end else
  if StrLComp(ATel.OutData, '05', 2) = 0 then       // Gewicht holen + speichern
  begin
    Inc(SimSpNr);
    StrFmt(ATel.InData, 'G0' +Chr(13)+ '%06.6d %01d %03.03d %s' +Chr(13),
      [Gew, Nk, SimSpNr, FormatDateTime('dd.mm.yy hh:nn', Date)]);
  end else
  if StrLComp(ATel.OutData, '18', 2) = 0 then       // Gewicht holen + Alibidruck
  begin
    Inc(SimSpNr);
    StrFmt(ATel.InData, 'G4' +Chr(13)+ '%06.6d %01d %03.03d  %s' +Chr(13),
      [Gew, Nk, SimSpNr, FormatDateTime('dd.mm.yy hh:nn', Date)]);
  end else
  if StrLComp(ATel.OutData, '13', 2) = 0 then       // Zeile drucken
  begin
    StrFmt(ATel.InData, 'OK' +Chr(13), [0]);
  end;

  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

end.
