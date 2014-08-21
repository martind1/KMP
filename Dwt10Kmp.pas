unit Dwt10Kmp;
(* Fahrzeugwaage Pfister mit SOH-Protokoll und STX/ETX-Protokoll
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
  TDwt10Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    SimNk : Integer;
    FProtokoll: TFaWaProtokoll;
    FVersOVACO: Boolean;
    procedure SetProtokoll(const AProtokoll : TFaWaProtokoll);
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    Bef : string[2];
    Netto : string[6];

    Antwort: PAnsiChar;
    AntwLen: integer;
    StatusPolling: Integer;
    EichKlammer : String;
    AlibiSpeicher : Boolean;

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
    property Protokoll: TFaWaProtokoll read FProtokoll write SetProtokoll;
    property VersOVACO: Boolean read FVersOVACO write FVersOVACO;
  end;

implementation

uses
  Prots, Err__Kmp, CPor_Kmp;

(*** Initialisierung *********************************************************)
procedure TDwt10Kmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');

  if Protokoll = fwpSOH then
  begin
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
  end
  else if Protokoll = fwpSTX then
  begin
    Description.Add('S:^B');           {-> STX}
    Description.Add('W:^P');           {<- DLE}
    Description.Add('B:');
    Description.Add('S:^P^C');         {-> DLE, ETX}
    Description.Add('W:^P');           {<- DLE}
    Description.Add('W:^B');           {<- STX}
    Description.Add('S:^P');           {-> DLE}
    Description.Add('A:255,^P,^C');    {<- DLE, ETX}
    Description.Add('S:^P');           {-> DLE}
  end
  else if Protokoll = fwpSTX_ACK then
  begin
    Description.Add('S:^B');         {-> STX}
    Description.Add('B:');
    Description.Add('S:^C');         {-> ETX}
    Description.Add('W:^F');         {<- ACK}
    {Antwort}
    Description.Add('W:^B');         {<- STX}
    Description.Add('A:255,^C');     {<- ETX}
    Description.Add('S:^F');         {-> ACK}
  end
  else if Protokoll = fwpSTX_ACK2 then   {OVACO}
  begin
    Description.Add('S:^B');         {-> STX}
    Description.Add('B:');
    Description.Add('S:^C');         {-> ETX}
    {Antwort}
    Description.Add('W:255,^B');     {<- STX}
    Description.Add('A:255,^C');     {<- ETX}
  end
  else ErrWarn('Protokoll (%d) nicht unterstütz!', [Ord(Protokoll)]);
end;

constructor TDwt10Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc( AntwLen);
  SimNk := 2;
end;

procedure TDwt10Kmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TDwt10Kmp.Destroy;
begin
  StrDispose( Antwort);
  Antwort := nil;
  inherited Destroy;
end;

procedure TDwt10Kmp.SetProtokoll(const AProtokoll : TFaWaProtokoll);
begin
  FProtokoll := AProtokoll;
  BuildDescription;
end;

(*** Methoden ***************************************************************)

procedure TDwt10Kmp.Init;
begin
  inherited Init;
end;

(*** Interne Methoden *******************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

procedure TDwt10Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
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
    try
      StatusId := -1;
      Gewicht := 0;
      FaWaStatus := [];
      if ATel.Status = cpsOK then
      begin
        (* 50: Gewicht senden ohne Speichern *)
        if StatusPolling = 1 then
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
        end   // try
        else
        (* 05: Gewicht speichern und Speichernummer löschen *)
        if StatusPolling = 2 then
        begin
          try
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
            if Bef <> 'G0' then EError('%s:DWT10-Fehler',[Bef]);

            Netto := StrLPas( EmpfBuff+3, 6);
            Nk := -StrToInt(String(StrLPas( EmpfBuff+10, 1)));
            ProtNr := StrToInt(String(StrLPas( EmpfBuff+12, 3)));
            DelSpNr( ProtNr);                    {Speichernummer wieder löschen}
            Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
            StrToGewicht(String(Netto), Gewicht);
            Display := Format( '%5.*f %s', [NachK, Gewicht, GE]);
          except on E:Exception do
            begin
              Include( FaWaStatus, fwsTimeout);
              DelSpNr( ProtNr);                  {Speichernummer wieder löschen}
              Display := E.Message;
              Prot0('%s(%.*s)',[E.Message, ATel.OutDataLen, ATel.OutData]);
              Gewicht := 0;
            end;
          end;  // try..except
        end  // StatusPolling = 2
      end else  // ATel.Status <> cpsOK
      begin
        Include( FaWaStatus, fwsTimeout);
        Gewicht := 0;
        Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
      end;
    finally
      if assigned(FOnStatus) then
        FOnStatus( Tel_Id, Gewicht, FaWaStatus);
    end else

    if (Tel_Id = ProtGewichtId) then
    (* 05: Gewicht holen und Eichfähig speichern *)
    try
      ProtGewichtId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      ProtNr := 0;
      try
        if ATel.Status = cpsOK then
        begin
          {G0^Mgggggg_e_sss_dd.mm.yy_hh.mmM}
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
          // Exclude( FaWaStatus, fwsWaagenstoerung);
          Netto := StrLPas( EmpfBuff+3, 6);
          {Nk := -StrToInt( StrLPas( EmpfBuff+10, 1));  schlecht bei kg-Waage}
          ProtNr := StrToInt(String(StrLPas( EmpfBuff+12, 3)));
          Nk := (Ord(EmpfBuff[10]) - Ord('0')) * (-1);

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

    {Antwort auf Befehl Drucken (Bef 13 oder 17)}
    if (Tel_Id = DruckId) then
    try
      {13: Drucke Zeile bzw. 17: Block}
      DruckId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          Bef := StrLPas(EmpfBuff, 2);
          if Bef = 'E2' then begin
            Include(FaWaStatus, fwsDruckerstoerung);
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
              StrFmt(Befehl, '17' +CRLF+ '%s' +CRLF, [DruckBlock.Strings[DruckIndex]]);
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
    begin
      (* Speichernummer(n) löschen: Erfolg anzeigen *)
      (* Ausdruck Block 12wwff *)
    end;
  end;
end;

function TDwt10Kmp.ProtGewicht( Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy( Befehl, '05'+CRLF);
  BefLen := StrLen( Befehl);
  ProtGewichtId := Start( Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TDwt10Kmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  if StatusPolling > 0 then begin
    if StatusPolling = 1 then StrPCopy( Befehl, '50'+CRLF)
    else if StatusPolling = 2 then StrPCopy( Befehl, '05'+CRLF);
    BefLen := StrLen( Befehl);
    StatusId := Start( Befehl, BefLen);
  end;
  Result := StatusId;
end;

function TDwt10Kmp.DelSpNr( SpNr: integer): longint;
(* Speichernummern löschen
   SpNr: -1 = alle *)
var
  Befehl : array[0..255] of AnsiChar;
  BefLen, i: integer;
begin
  Result := -1;
  if VersOVACO then      // keine Speichernummern löschen
    Exit;

  if SpNr = -1 then
    for i := 1 to 99 do
    begin
      StrFmt( Befehl, '12' + CRLF + '%03.3d' + CRLF, [i]);
      BefLen := StrLen( Befehl);
      DelSpNrId := Start(Befehl, BefLen);    {geht schneller da im Hintergrund}
      SMess('Lösche Speichernummer %d',[I]);
      Result := DelSpNrId;
    end
  else begin
    StrFmt( Befehl, '12'+ CRLF + '%03.3d' + CRLF, [SpNr]);
    BefLen := StrLen( Befehl);
    DelSpNrId := Start( Befehl, BefLen);    {geht schneller da im Hintergrund}
    Result := DelSpNrId;
  end;
end;

function TDwt10Kmp.Zeilendruck(Zeile: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen, i, j: integer;
  sProt, Zeile2, txt : string;
  Pos1 : Integer;
begin
  if not VersOVACO then
  begin
    // Wenn nicht die Standardeichklammern verwendet werden
    if Eichklammer <> '<>' then
      try
        i := Pos('<', Zeile);
        j := Pos('>', Zeile);
        if (i > 0) and (j > i) and CharInSet(Zeile[i+1], ['0'..'9']) then begin
          Zeile[i] := Eichklammer[1];
          Zeile[j] := Eichklammer[2];
        end;
      except
      end;
    // evtl fehlende CRLF anhängen
    if (Zeile[Length(Zeile)-1] <> Chr(13)) and
       (Zeile[Length(Zeile)] <> Chr(10)) then
      StrFmt(Befehl, '13' +CRLF+ '%s' +Chr(13) +Chr(10), [Zeile])
    else StrFmt(Befehl, '13' +CRLF+ '%s', [Zeile]);

    BefLen := StrLen(Befehl);
    AnsiToOem(Befehl, Befehl);
    DruckID := Start(Befehl, BefLen);
    Result := DruckID;

  end
  else begin
    // OVACO, String nach dem von OVACO erwarteten Format aufbauen
    Pos1 := Pos('<', Zeile);
    if Pos1 <> 0 then       // nur Drucken, wenn Alibiausdruck
    begin
      Zeile2 := Format('%s  ', [FormatDateTime('DD.MM.YY  HH:NN', Now)]);
      // '/' als Trenner zwischen Gerätenr. und Protnr.
      Pos1 := Pos('/', Zeile);
      Zeile := Copy(Zeile, Pos1 + 1, Length(Zeile) - Pos1);
      sProt := Copy(Zeile, 0, Pos(' ', Zeile) -1 );
      if Length(sProt) > 6 then
      begin
        // keine Korrektur ProtNr, da sonst im Progr. andere ProtNr als in Waage
        // Nummernkreis ProtNr im Programm anpassen
        // sProt := Copy(sProt, Length(sProt) - 5, 6);
        txt := Format('OVACO-Waage: Protokollnr. gekürzt: Von (%s) ', [sProt]);
        sProt := Copy(sProt, Length(sProt) - 5, 6);
        Prot0('%s auf (%s)', [txt, sProt]);
      end;
      Zeile2 := Zeile2 + ' ' + sProt + ' <000> L';
      StrFmt(Befehl, '13' +CRLF+ '%s' +Chr(13) +Chr(10), [Zeile2]);

    end;
    
    BefLen := StrLen(Befehl);
    AnsiToOem(Befehl, Befehl);
    DruckID := Start(Befehl, BefLen);
    Result := DruckID;
  end;
end;

function TDwt10Kmp.DruckeBlock( ABlock: TStrings): longint;
var
  Befehl : array[0..250] of AnsiChar;
  I, BefLen: integer;
begin
  Result := -1;
  (* Formularlänge definieren *)
  if FormLen > 0 then
  begin
    StrFmt(Befehl, '15' +CRLF + '0%-2.2d' + CRLF, [FormLen]);
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
    StrFmt( Befehl, '17'+CRLF+'%s'+CRLF, [DruckBlock.Strings[I]]);
    BefLen := StrLen( Befehl);
    AnsiToOem( Befehl, Befehl);
    Start( Befehl, BefLen);
  end;
  (* Formularvorschub *)
  if FormLen > 1 then
  begin
    StrPCopy( Befehl, '16'+CRLF);
    BefLen := StrLen( Befehl);
    Start( Befehl, BefLen);
  end;
end;

procedure TDwt10Kmp.DoSimul(ATel: TTel);
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
  if StrLComp(ATel.OutData, '13', 2) = 0 then       // Zeile drucken
  begin
    StrFmt(ATel.InData, 'OK' +Chr(13), [0]);
  end;

  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

end.
