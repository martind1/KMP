unit Mci__Kmp;
(* Fahrzeugwaage MCI (Bizerba), ohne Alibidruck
   03.12.02 TS Erstellen *)
interface

uses
{$ifdef WIN32}
  Math,
{$else}
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp, Prots;

type
  TMciKmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    Error : String[1];
  protected
    { Protected-Deklarationen }
    ProtGewVerzId, tempID : Longint;
    DescDirekt, DescVerz: TStringList;
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
    procedure UserFnk(ATel: TTel; FnkName : string); override;
    function HoleStatus: longint; override;
    function ProtGewicht( Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    function Zeilendruck(Zeile: string): longint; override;
    function DruckeBlock( ABlock: TStrings): longint; override;
    function DelSpNr( SpNr: integer): longint; override;
    procedure DoSimul(ATel: TTel); override;
    procedure ErrorToWaStat(Error: integer; var Status: TFaWaStatus);
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Err__Kmp, CPor_Kmp, NStr_kmp;

(*** Initialisierung *********************************************************)
procedure TMciKmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  Description.Add('S:^E');           {-> ENQ}
  Description.Add('W:^F');           {<- ACK}
  Description.Add('S:^A');           {-> SOH}
  Description.Add('S:0');            {-> $30, Wiederholzähler}
  Description.Add('S:0');            {-> $30, Nummer des Registrierprogr.}
  Description.Add('S:8');            {-> $38, Programmkennnummer}
  Description.Add('S:0');            {-> $30, Anlagennummer}
  Description.Add('S:0');            {-> $30, Anlagennummer}
  Description.Add('S:[MCIGERNR]');   {-> $30 + Waagennummer}
  Description.Add('S:^C');           {-> ETX}
  Description.Add('B:');
  Description.Add('S:^W');           {-> ETB - End Transmission Block}
  if BCC then
    Description.Add('S:[MCIBCC]');
  Description.Add('W:^F');           {<- ACK}
  //  Description.Add('S:^D');           {-> EOT, wird nicht gesendet}

  {Antwort}
  Description.Add('W:^E');           {<- ENQ}
  Description.Add('S:^F');           {-> ACK}
  Description.Add('W:^A');           {<- SOH}
  Description.Add('W:255,^C');       {<-Kopfdaten (ignorieren), ETX}
  Description.Add('A:255,^W');       {<- Antwort, ETB}
  if BCC then
    Description.Add('W:1');          {BCC}
  Description.Add('S:^F');           {-> ACK}
  //  Description.Add('W:^D');           {<- EOT, wird nicht gesendet}

  DescDirekt.Assign(Description);    {nur Direkte Antwort erwarten}

  // wenn z.B. Waage nicht in Ruhe, dann schickt Waage das Gewicht später
  Description.Clear;
  Description.Add('T:30000');        {30 Sekunden}
  Description.Add('W:^E');           {<- ENQ}
  Description.Add('S:^F');           {-> ACK}
  Description.Add('W:^A');           {<- SOH}
  Description.Add('W:255,^C');       {<-Kopfdaten (ignorieren), ETX}
  Description.Add('A:255,^W');       {<- Antwort, ETB}
  if BCC then
    Description.Add('W:1');          {BCC}
  Description.Add('S:^F');           {-> ACK}
  DescVerz.Assign(Description);

  Description.Assign(DescDirekt);
end;

constructor TMciKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc( AntwLen);
  DescDirekt := TStringList.Create;
  DescVerz := TStringList.Create;
  ProtGewVerzId := -1;
  tempID := -1;
end;

procedure TMciKmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TMciKmp.Destroy;
begin
  StrDispose( Antwort);
  Antwort := nil;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TMciKmp.Init;
begin
  inherited Init;
end;

(*** Interne Methoden *******************************************************)
procedure TMciKmp.ErrorToWaStat(Error: integer; var Status: TFaWaStatus);
begin
  if BITIS( Error, $1) then
    Exclude( Status, fwsKeinStillstand)
  else Include( Status, fwsKeinStillstand);
  if BITIS( Error, $2) then
    Include( Status, fwsUnterlast);
  if BITIS( Error, $4) then
    Include( Status, fwsUeberlast);
  if BITIS( Error, $10) then
    Include( Status, fwsNull);
  if BITIS( Error, $40) then
    Include( Status, fwsKeinGewicht);

  if Error = 1 then Include(Status, fwsGewichtOK);
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TMciKmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L : integer;
  ATel : TTel;
  Vz : String;
  Gew : String;
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
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

    {Antwort auf Befehl Status}
    if Tel_Id = StatusId then
    try
      StatusId := -1;
      if ATel.Status = cpsOK then
      try
        Bef := StrLPas(EmpfBuff, 1);
        if Bef = '+' then                    // $2B, Kennung Gewicht Brutto
        begin
          Error := StrLPas(Empfbuff+1, 1);
          ErrorToWaStat(Ord(Error[1]), FaWaStatus);
          Vz := String(StrLPas(EmpfBuff+2, 1));
          Gew := String(StrLPas(EmpfBuff+3,8));
          Gewicht := StrToFloatTol(Gew);
          if Vz = '-' then begin
            Gewicht := -Gewicht;
            Include( FaWaStatus, fwsUnterlast);
          end;
          Ge := String(StrLPas(EmpfBuff+11,2));
          Ge := Trim(Ge);
          Display := Format('%5.*f %s', [Nk, Gewicht, GE]);
          Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
        end else
        begin
          Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
          Gewicht := 0;
        end;
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

    {Antwort auf Befehl ProtGewicht, ProtDruck}
    if (Tel_Id = ProtGewichtId) or (Tel_Id = ProtGewVerzId) then
    try
      {Gewicht holen mit Ruhe}
      FaWaStatus := [];
      if Tel_Id = ProtGewichtId then tempID := ProtGewichtId
      else if Tel_Id = ProtGewVerzId then
      begin
        Tel_Id := tempID;       // rufendem Programm die alte ID liefern
        FaWaStatus := [fwsKeinStillstand, fwsTimeout];
        tempID := -1;
      end;
      ProtGewichtId := -1;
      ProtGewVerzId := -1;
      try
        if ATel.Status = cpsOK then
        begin
          FaWaStatus := [];
          Bef := StrLPas(EmpfBuff, 1);
          if Bef = '+' then                    // $2B, Kennung Gewicht Brutto
          begin
            Error := StrLPas(Empfbuff+1, 1);
            ErrorToWaStat(Ord(Error[1]), FaWaStatus);
            Vz := String(StrLPas(EmpfBuff+2, 1));
            Gew := String(StrLPas(EmpfBuff+3,8));
            Gewicht := StrToFloatTol(Gew);
            if Vz = '-' then begin
              Gewicht := -Gewicht;
              Include( FaWaStatus, fwsUnterlast);
            end;
            Ge := String(StrLPas(EmpfBuff+11,2));
            Ge := Trim(Ge);
            Display := Format('%5.*f %s', [Nk, Gewicht, GE]);
            Include(FaWaStatus, fwsGewichtOk);
            GenProtNr;                                          {nächste ProtNr}
          end
          else if Bef = 'w' then begin              // $77, Kennung für Quittung
            if StrLPas(EmpfBuff+1, 1)= '1' then     // $31, Negativ
            begin
              Include(FaWaStatus, fwsWaagenstoerung);
              Gewicht := 0;
              Display := Format('Error', [0]);
            end else
            if StrLPas(EmpfBuff+1, 1)= '5' then     // $35, keine Ruhe, Gewicht
            begin                                   // kommt im nächsten Satz
              // auf nächsten Satz warten
              Description.Assign(DescVerz);
              StrPCopy( Befehl, '');
              BefLen := StrLen( Befehl);
              ProtGewVerzId := Start(Befehl, BefLen);
            end;
          end;
        end else
        begin
          if FaWaStatus = [] then
            FaWaStatus := [fwsTimeout];
          Gewicht := 0;
        end;
      except
        if FaWaStatus = [] then
          FaWaStatus := [fwsTimeout];
        Gewicht := 0;
      end;
    finally
      if (ProtGewVerzId < 0) and assigned(FOnProtGewicht) then
        FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else
  end;
end;

function TMciKmp.ProtGewicht( Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Description.Assign(DescDirekt);
  StrPCopy( Befehl, 'q$');       // $71, $24
  BefLen := StrLen( Befehl);
  ProtGewichtId := Start( Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TMciKmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Description.Assign(DescDirekt);
  StrPCopy( Befehl, 'q%');       // $71, $25
  BefLen := StrLen( Befehl);
  StatusId := Start( Befehl, BefLen);
  Result := StatusId;
end;

function TMciKmp.DelSpNr( SpNr: integer): longint;
begin
  Result := -1;
end;

function TMciKmp.Zeilendruck(Zeile: string): longint;
begin
  Result := -1;
end;

function TMciKmp.DruckeBlock( ABlock: TStrings): longint;
begin
  Result := -1;
end;

procedure TMciKmp.UserFnk(ATel: TTel; FnkName : string);
var
  I : integer;
  c : AnsiChar;
  BccCh : Byte;
  GerNrStr: array[0..2] of AnsiChar;
begin
  if Uppercase(FnkName) = 'MCIGERNR' then
  begin
    c := AnsiChar(Chr($30 + GerNr));
    StrFmt(GerNrStr, '%s', [c]);
    ComPort.Write(GerNrStr, 1);
  end else
  if Uppercase(FnkName) = 'MCIBCC' then
  begin
    if Bcc then
    begin
      BccCh := 0;
      for I:= 0 to ATel.OutDataLen-1 do
        BccCh := BccCh xor ord(ATel.OutData[I]);
      BccCh := BccCh xor ETB;   {^W}
      ComPort.Write(Addr(BccCh), 1);
    end;
  end else
    inherited UserFnk(ATel, FnkName);
end;

procedure TMciKmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
  Gew : Double;
begin
  StrCopy(ATel.InData, '');
  Gew := SimGewicht;
  if SimGewicht < 0 then
    Gew := -SimGewicht;
  if StrLComp(ATel.OutData, 'q$', 2) = 0 then       // $71, $24; Gewicht holen
  begin
    SimError := $20 + 1;                       // Bit1 - In Ruhe, Bit 5 fest = 1
    // StrFmt(ATel.InData, 'w5', []);                     // Waage nicht in Ruhe
    // StrFmt(ATel.InData, '+%s%9.2ft ', [Chr(SimError), Gew]);    // t
    StrFmt(ATel.InData, '+%s%9.0fkg', [Chr(SimError), Gew]);    // kg
  end else
  if StrLComp(ATel.OutData, 'q%', 2) = 0 then       // $71, $25; Gewicht ohne Ruhe holen
  begin
    SimError := $20 + 1;          // Bit1 - In Ruhe, Bit 5 fest = 1
    // StrFmt(ATel.InData, '+%s%9.2ft ', [Chr(SimError), Gew]);    // t
    StrFmt(ATel.InData, '+%s%9.0fkg', [Chr(SimError), Gew]);    // kg
  end;

  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

end.
