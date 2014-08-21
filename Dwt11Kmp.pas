unit Dwt11kmp;
(* Fahrzeugwaage Pfister DWT11 Version Hobo (Standard) *)
interface

uses
{$ifdef WIN32}
  Math,
{$else}
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TDwt11Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    ShortDescr: TStringList;
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
    procedure UserFnk( ATel: TTel; FnkName : string); override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function ProtGewicht( Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    function DruckeBlock( ABlock: TStrings): longint; override;

    function DelSpNr( SpNr: integer): longint; override;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, Err__Kmp, CPor_Kmp;
(*** Initialisierung *********************************************************)

constructor TDwt11Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc( AntwLen);
  ShortDescr := TStringList.Create;
end;

procedure TDwt11Kmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add('S:^B');
  Description.Add('W:^P');
  Description.Add('B:');
  Description.Add('S:^P^C');
  Description.Add('W:^P');
  Description.Add('W:^B');
  Description.Add('S:^P');
  Description.Add('A:255,^P,^C');
  Description.Add('S:^P');

  ShortDescr.Clear;
  ShortDescr.Add('B:');
  ShortDescr.Add('A:255');
end;

procedure TDwt11Kmp.Loaded;
begin
  inherited Loaded;
end;

destructor TDwt11Kmp.Destroy;
begin
  StrDispose( Antwort);
  Antwort := nil;
  ShortDescr.Free;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TDwt11Kmp.Init;
begin
  inherited Init;
end;


(*** Interne Methoden *******************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

procedure TDwt11Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
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

    if Tel_Id = StatusId then            {IW -> 1,23 t}
    try
      StatusId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      ProtNr := 0;
      try
        if ATel.Status = cpsOK then
        begin
          Netto := StrLPas( EmpfBuff+0, 6);
          Include( FaWaStatus, fwsGewichtOk);
          StrToGewicht(String(Netto), Gewicht);
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
      if assigned(FOnStatus) then
        FOnStatus( Tel_Id, Gewicht, FaWaStatus);
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
          Bef := StrLPas( EmpfBuff+0, 2);
          include( FaWaStatus, fwsWaagenstoerung);
          if Bef = 'E1' then EError('%s:Überlast,Testzahl,Meßprogramm',[Bef]);
          if Bef = 'BY' then EError('%s:Negatives Gewicht',[Bef]);
          if Bef = 'E2' then EError('%s:Speicher voll',[Bef]);
          if Bef <> 'G0' then EError('%s:DWT11-Fehler',[Bef]);
          exclude( FaWaStatus, fwsWaagenstoerung);
          Netto := StrLPas( EmpfBuff+3, 6);
          Nk := -StrToInt(String(StrLPas( EmpfBuff+10, 1)));
          ProtNr := StrToInt(String(StrLPas( EmpfBuff+12, 3)));

          Include( FaWaStatus, fwsGewichtOk);
          StrToGewicht(String(Netto), Gewicht);
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

    if (Tel_Id = DruckId) then     (* Ausdruck Block 12wwff *)
    try
      DruckId := -1;
      try
        if ATel.Status = cpsOK then
        begin
          FaWaStatus := [fwsDruckerStoerung];
          Bef := StrLPas( EmpfBuff+0, 2);
          if Bef = 'E2' then EError('%s:Speichernr falsch',[Bef]);
          if Bef = 'E3' then EError('%s:Druckerstörung',[Bef]);
          if Bef <> 'OK' then EError('%s:DWT11-Fehler',[Bef]);
          exclude( FaWaStatus, fwsDruckerStoerung);
        end else
        begin
          Include( FaWaStatus, fwsTimeout);
        end;
      except on E:Exception do
        begin
          Include( FaWaStatus, fwsTimeout);
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

function TDwt11Kmp.ProtGewicht( Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy( Befehl, '05'+CRLF);
  BefLen := StrLen( Befehl);
  ProtGewichtId := Start( Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TDwt11Kmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrPCopy( Befehl, 'IW'+CRLF);  //+CRLF
  BefLen := StrLen( Befehl);
  StatusId := Start( Befehl, BefLen);
  //GetTel(StatusId).Description.Assign(ShortDescr);
  Result := StatusId;
end;

function TDwt11Kmp.DelSpNr( SpNr: integer): longint;
(* Speichernummern löschen
   SpNr: -1 = alle *)
var
  Befehl : array[0..255] of AnsiChar;
  BefLen: integer;
begin
  StrFmt( Befehl, '12'+CRLF+'%03.3d'+CRLF, [SpNr]);
  BefLen := StrLen( Befehl);
  Result := Start( Befehl, BefLen);    {geht schneller da im Hintergrund}
end;

function TDwt11Kmp.DruckeBlock( ABlock: TStrings): longint;
var
  Befehl : array[0..250] of AnsiChar;
  I, BefLen: integer;
begin
  Result := -1;
  DruckBlock.Assign( ABlock);
  DruckIndex  := 0;
  for I:= 0 to DruckBlock.Count-1 do
  begin
    StrFmt( Befehl, '13'+CRLF+'%s'+CRLF, [DruckBlock.Strings[I]]);
    BefLen := StrLen( Befehl);
    AnsiToOem( Befehl, Befehl);
    DruckId := Start( Befehl, BefLen);
    Result := DruckId;
  end;
  (* Formularvorschub *)
  if FormLen > 1 then
  begin
    StrPCopy( Befehl, '16'+CRLF);
    BefLen := StrLen( Befehl);
    Start( Befehl, BefLen);
  end;
end;

procedure TDwt11Kmp.UserFnk( ATel: TTel; FnkName : string);
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
