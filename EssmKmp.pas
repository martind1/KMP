unit Essmkmp;
(* Fahrzeugwaage Eßmann 31.01.99 Erstellung *)
interface

uses
{$ifdef WIN32}
  Math,
{$else}
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TEssmannKmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    procedure StrToGewicht( GewStr: string; var Gewicht: double);
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    Bef : string[2];
    Netto : string[6];
    NachK: integer;

    Antwort: PAnsiChar;
    AntwLen: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure UserFnk( ATel: TTel; FnkName : string); override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function ProtGewicht( Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    function DruckeBlock( ABlock: TStrings): longint; override;
    function Zeilendruck( Zeile: string): longint; override;
    function DelSpNr( SpNr: integer): longint; override;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, Err__Kmp, CPor_Kmp;
(*** Initialisierung *********************************************************)

constructor TEssmannKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc( AntwLen);
  Description.Add('S:^A');
  Description.Add('W:^E');
  Description.Add('B:');
  Description.Add('S:^D');
  Description.Add('W:^F');
  Description.Add('W:^A');
  Description.Add('S:^E');
  Description.Add('A:255,^D');
  Description.Add('S:^F');
end;

procedure TEssmannKmp.Loaded;
begin
  inherited Loaded;
end;

destructor TEssmannKmp.Destroy;
begin
  StrDispose( Antwort);
  Antwort := nil;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TEssmannKmp.Init;
begin
  inherited Init;
end;


(*** Interne Methoden *******************************************************)

procedure TEssmannKmp.StrToGewicht( GewStr: string; var Gewicht: double);
begin
  if Nk < 0 then
    NachK := -Nk else
    NachK := 0;
  Gewicht := RoundDec( StrToFloatTol( GewStr) * Power( 10, Nk), NachK);
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TEssmannKmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L: integer;
  ATel : TTel;
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
          {G0Mgggggg_e_sss_dd.mm.yy_hh.mmM}
          Bef := StrLPas( EmpfBuff+0, 2);
          include( FaWaStatus, fwsWaagenstoerung);
          if Bef = 'E1' then EError('%s:Überlast,Testzahl,Meßprogramm',[Bef]);
          if Bef = 'BY' then EError('%s:Negatives Gewicht',[Bef]);
          if Bef = 'E2' then EError('%s:Speicher voll',[Bef]);
          if Bef = 'E3' then EError('%s:Druckerstörung',[Bef]);
          if Bef <> 'G0' then EError('%s:Fehler',[Bef]);
          exclude( FaWaStatus, fwsWaagenstoerung);
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

    if (Tel_Id = DruckId) then
    (* 13: Gewicht in Alibispeicher schreiben *)
    try
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          {OK}
          include( FaWaStatus, fwsWaagenstoerung);
          if Bef = 'E1' then EError('%s:Überlast,Testzahl,Meßprogramm',[Bef]);
          if Bef = 'BY' then EError('%s:Negatives Gewicht',[Bef]);
          if Bef = 'E2' then EError('%s:Speicher voll',[Bef]);
          if Bef = 'E3' then EError('%s:Druckerstörung',[Bef]);
          if Bef <> 'G0' then EError('%s:Fehler',[Bef]);
          exclude( FaWaStatus, fwsWaagenstoerung);
        end else
        begin
          Include( FaWaStatus, fwsTimeout);
        end;
      except on E:Exception do
        begin
          Include( FaWaStatus, fwsTimeout);
          Display := E.Message;
          Prot0('%s(%.*s)',[E.Message, ATel.OutDataLen, ATel.OutData]);
          If StrLPas( EmpfBuff, 2) <> 'OK' Then EError('%s: Fehler beim Schreiben in Alibi-Speicher',[Bef]);
        end;
      end;
    finally
    end else
    begin
      (* Speichernummer(n) löschen: Erfolg anzeigen *)
      (* Ausdruck Block 12wwff *)
    end;
  end;
end;

function TEssmannKmp.ProtGewicht( Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy( Befehl, '05'+CRLF);
  BefLen := StrLen( Befehl);
  ProtGewichtId := Start( Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TEssmannKmp.HoleStatus: longint;
begin
  Result := -1;
{  StrPCopy( Befehl, '05'+CRLF);
  BefLen := StrLen( Befehl);
  StatusId := Start( Befehl, BefLen);
  Result := StatusId;}
end;

function TEssmannKmp.DelSpNr( SpNr: integer): longint;
(* Speichernummer löschen *)
begin
{  StrFmt( Befehl, 'D 1%03.3d', [SpNr]);
  BefLen := StrLen( Befehl);
  Start( Befehl, BefLen); }   {geht schneller da im Hintergrund}
  Result := -1;
end;

function TEssmannKmp.DruckeBlock( ABlock: TStrings): longint;
var
  Befehl : array[0..250] of AnsiChar;
  I, BefLen: integer;
begin
  Result := -1;
  DruckBlock.Assign( ABlock);
  DruckIndex  := 0;
  for I:= DruckBlock.Count-1 downto 1 do with DruckBlock do      {Komprimieren}
  begin
    if (length( Strings[I-1]) + length( Strings[I]) <= 120) and
       (Pos('<', Strings[I-1]) = 0) and (Pos('<', Strings[I]) = 0) then
    begin
      Strings[I-1] := Format('%s'+#$A+'%s', [Strings[I-1], Strings[I]]);
      Delete(I);
    end;
  end;
  for I:= 0 to DruckBlock.Count-1 do
  begin
    StrFmt( Befehl, '13'+CRLF+'%s'+CRLF, [DruckBlock.Strings[I]]);
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

function TEssmannKmp.Zeilendruck( Zeile: string): longint;
var
  Befehl : array[0..250] of AnsiChar;
  BefLen: integer;
begin
  StrFmt( Befehl, '13'+CRLF+'%s'+CRLF, [Zeile]);
  BefLen := StrLen( Befehl);
  AnsiToOem( Befehl, Befehl);
  DruckId := Start( Befehl, BefLen);
  Result := DruckId;
End;

procedure TEssmannKmp.UserFnk( ATel: TTel; FnkName : string);
var
  I : integer;
  BccCh : Byte;
begin
  if Uppercase( FnkName) = 'ROWBCC' then
  begin
    if Bcc then
    begin
      BccCh := 0;
      for I:= 0 to ATel.OutDataLen-1 do
        BccCh := BccCh xor ord(ATel.OutData[I]);
      BccCh := BccCh xor DLE;   {^P}
      BccCh := BccCh xor ETX;   {^C}
      ComPort.Write( Addr(BccCh), 1);
    end;
  end else
    inherited UserFnk( ATel, FnkName);
end;

end.

