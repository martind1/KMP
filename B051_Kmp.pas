unit B051_KMP;
(* Einfachprotokoll Fahrzeugwaage Widra *)
interface

uses
{$ifdef WIN32}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Math,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;
{$else}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;
{$endif}

type
  TB051Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    FGewichtFirst: boolean;          {Gewicht vor lfd. Nr. in Antwort}
    FWT65Typ: boolean;               {ab 2. Telegramm statt ^B^C^C bei der
                                      Gewichtsanforderung nur noch ^B}
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
//    Bef : string[2];
//    WaaNr : string[2];
//    Error : string[2];
//    Stoer : string[1];
//    Netto : string[5];
//    Brutto :  string[5];
//    Still :  string[1];
//    SpNr :  string[3];

    WaGE: string[3];

    Antwort: PChar;
    AntwLen: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure UserFnk(ATel: TTel; FnkName : string); override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
    function Quittieren: longint; override;
    function DruckeBlock(ABlock: TStrings): longint; override;
    function Zeilendruck(Zeile: string): longint; override;
    function DelSpNr(SpNr: integer): longint; override;
  published
    { Published-Deklarationen }
    property GewichtFirst: boolean read FGewichtFirst write FGewichtFirst;
    property WT65Typ: boolean read FWT65Typ write FWT65Typ;
  end;

implementation

uses
  Prots, CPor_Kmp, Err__Kmp;
(*** Initialisierung *********************************************************)

procedure TB051Kmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');

  if ComPort <> nil then
    Description.Add(Format('T:%d',[ComPort.TimeOut])) else
    Description.Add('T:7000');

  Description.Add('S:^E');
  Description.Add('W:^F');
  Description.Add('S:^B^C^C');
  Description.Add('W:^F');
  Description.Add('S:^D');
  Description.Add('W:^E');
  Description.Add('S:^F');

  {Gewicht}
  Description.Add('W:^B');
  Description.Add('A:255,^C');
  Description.Add('W:1');   {BCC}

  Description.Add('S:^F');
  Description.Add('W:^D');
end;

constructor TB051Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := StrAlloc(AntwLen);
  WaGE := 'kg';
end;

procedure TB051Kmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TB051Kmp.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TB051Kmp.Init;
begin
  inherited Init;
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TB051Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
{Verarbeiten der im Telegramm empfangenen Daten}
var
  Empf: array[0..255] of AnsiChar;
  L, lenLfdNr : integer;        // Antowrtlänge
  S1 : string;                  // temp
  cpStatus: TComProtStatus;

begin
  inherited DoAntwort(Sender, Tel_Id);
  FaWaStatus := [];
  L := sizeof(Empf) - 1;
  cpStatus := GetData(Tel_Id, Empf, L);
  Empf[L] := #0;
  lenLfdNr := L - 5;          // Länge der lfd. Nr kann variieren
			      // Gewicht immer 5-stellig

  if (Tel_Id = ProtGewichtId) then
  try     {Gewicht eichfähig holen und Protokolldruck}
    ProtGewichtId := -1;
    FaWaStatus := [];
    if cpStatus = cpsOK then begin
      try         {Stringumwandlung}
	if GewichtFirst then begin              // Gewicht steht vor lfd. Nr
	  Display := String(StrLPas(Empf, 5));
	  S1 := String(StrLPas(Empf + 5, lenLfdNr));    // lfd. Nr mit n Stellen
	end
	else begin
	  S1 := String(StrLPas(Empf, lenLfdNr));        // lfd. Nr mit n Stellen
	  Display := String(StrLPas(Empf + lenLfdNr, 5));
	end;

        ProtNr := StrToIntTol(S1);
        Gewicht := StrToFloatTol(Display);

        if (Upcase(char1(GE)) = 'T') and (WaGE = 'kg') then
          Gewicht := Gewicht / 1000;

        if FaWaStatus = [] then
          FaWaStatus := [fwsGewichtOK];
        Include(FaWaStatus, fwsProtNr);  // immer, da GenProt
      except
        on E:Exception do
        begin
          Display := E.Message;
          Prot0('%s',[E.Message]);
        end;
      end;
    end
    else begin                   // cpStatus <> cpsOK
      Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
      FaWaStatus := [fwsTimeout];
    end;
  finally        {Gewicht eichfähig holen}
    if assigned(FOnProtGewicht) then
      FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
  end;
end;

procedure TB051Kmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
begin
  inherited DoSimul(ATel);
end;

function TB051Kmp.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);    // Starten und Telegramm-nr. Speichern
  Result := ProtGewichtId;
end;

function TB051Kmp.HoleStatus: longint;
{Status mit B051 nicht möglich}
begin
  StatusId := -1;
  Result := StatusId;
end;

function TB051Kmp.DelSpNr(SpNr: integer): longint;
begin
  Result := -1;
end;

function TB051Kmp.Quittieren: longint;
begin
  Result := -1;
end;

function TB051Kmp.Zeilendruck(Zeile: string): longint;
begin
  DruckId := -1;
  Result := DruckID;
end;

function TB051Kmp.DruckeBlock(ABlock: TStrings): longint;
begin
  DruckId := -1;
  Result := DruckID;
end;

procedure TB051Kmp.UserFnk(ATel: TTel; FnkName : string);
var
  I : integer;
  BccCh : Byte;
  GerNrStr: array[0..2] of AnsiChar;
begin
  if Uppercase(FnkName) = 'ROWGERNR' then
  begin
    if Polling then
    begin
      StrFmt(GerNrStr, '%-02.2d', [GerNr]);
      ComPort.Write(GerNrStr, 2);
    end;
  end else
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
