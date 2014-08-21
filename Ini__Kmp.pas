unit Ini__kmp;
(* Komponente zur Verwaltung von .INI Datei
   Mit Druckertypen Unterstützung

   Autor: Martin Dambach, von VCL TIniFile
   Letzte Änderung:
   21.02.97     Erstellen
   28.08.97     EraseIdent(const Section, Ident: string);
                NewSection(const Section: string);
   18.02.98     ReadSections
                FilePath: vollst. Pfad (ist z.B. mit Windows-Dir wenn ohne Angabe)
                ReadStr, WriteStr
                ReadBinary, WriteBinary (not tested)
                ReadStrings, WriteStrings (not tested)
   27.02.99     WriteSectionStrings, ReadSectionStrings
   13.03.99     SDefaultDialog
   11.08.00     THintIni (GEN)
   06.01.01     DeleteKey
   06.02.02     IniKmp.FilePath: Verzeichnis von EXE (AppDir) wenn kein Pfad angegeben
   17.09.02     ReadStrDflt wie Readstring. Verwendet aber Default auch wenn Leerstring in INI
   05.12.02 JP  Druckernamen aus INI lesen und schreiben
   13.01.03 JP  Alternative Druckername / Druckerindex in .INI schreiben
   04.04.03 MD  SetFilePath. Wenn kein Verz. angegeben wird AppDir verwendet (im Unterschied zu SetFileName, was WinDir verwendet)
   16.05.03 MD  HintIni: Filename kann in IniKmp [System] Hints=<Filepath> angegeben werden
   08.08.03 MD  ReadFloatIntl
   23.08.03 MD  Edit.     FilePath liefert WinDir wenn Pfad fehlt.
   04.06.05 MD  ReadMSecs
   26.03.08 MD  IgnoreFileError
   27.03.08 MD  CacheTemp: zur Verhinderung Serverseitiger Lock-Fehler
   26.03.09 MD  IniDruckertypen und Sysparam.Drucker Lazy loading
   23.12.09 MD  WriteStrings/ReadStrings mit Commatext
   10.01.10 MD  ReadDateTime im Länderunabhängigen, eigenen Format
   16.03.13 md  ExistsSection, ReadSectionValuesDflt (Quvae.Silo.Labifilter)

   -------------------------------------
   Filename im Objektinspektor einstellen
   Lesen, Schreiben String, Integer, Bool

   Liste mit Druckerkategorien
*)

interface

uses
  Windows, Classes, Menus, Controls,
  DPos_Kmp, NLnk_Kmp;

type
  TSecTyp = (stVorgabe, stUser, stMaschine, stAnwendung);
const
  SecTypChar: array[TSecTyp] of char = ('V', 'U', 'M', 'A');

type
  TIniKmp = class(TComponent)
  private
    FFileName: PChar;
    FOnInit: TNotifyEvent;
    FDruckerTypen: TStringList;
    FIniDruckerTypen: TStringList;  //lazy loading: Ergänzende Typen und Namen aus der INI
    FUsePrnName: Boolean;    //true=Druckername statt index verwalten  {JP 13.01.2003}
    fDefaultSectionTyp: TSecTyp;
    FIgnoreFileError: boolean;
    FCacheTemp: boolean;  //true=Fehler beim Schreiben erzeugen keine Exceptions

    function GetFileName: string; virtual;
    {bedient Property FileName}
    procedure SetFileName(Value: string); virtual;
    {bedient Property FileName}
    procedure SetDruckerTypen(Value: TStringList);
    procedure FileWriteError(const Fmt: string; const Args: array of const);
    procedure SetFilePath(const Value: string); virtual;
    procedure SetCacheTemp(const Value: boolean);
    function GetDruckerTypen: TStringList;
  protected
    LoadedFilePath: string;   //für CacheTemp
    function GetFilePath: string; virtual;
    {vollständiger FileName}
    function GetSectionTyp(const Section: string): TSecTyp; virtual;
    procedure SetSectionTyp(const Section: string; const Value: TSecTyp); virtual;
  public
    InReadDrucker: boolean;  //für Sysparam.GetDrucker
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;

    function ReadStr(const Section, Ident: string; Default: PChar;
      Buffer: PChar; BuffSize: Cardinal): Cardinal; virtual;
    procedure WriteStr(const Section, Ident: string; Value: PChar); virtual;
    function ReadString(const Section, Ident, Default: string): string; virtual;{lesen }
    function ReadStrDflt(const Section, Ident, Default: string): string; virtual;
    //wie Readstring. Verwendet aber Default auch wenn Leerstring in  INI. 29.08.02 QSBT
    procedure WriteString(const Section, Ident, Value: String); virtual;
    function ReadInteger(const Section, Ident: string; Default: Longint): Longint; virtual;
    procedure WriteInteger(const Section, Ident: string; Value: Longint); virtual;
    function ReadFloat(const Section, Ident: string; Default: Extended): Extended; virtual;
    function ReadFloatIntl(const Section, Ident: string; Default: Extended): Extended; virtual;
    procedure WriteFloat(const Section, Ident: string; Value: Extended); virtual;
    function ReadBool(const Section, Ident: string; Default: Boolean): Boolean; virtual;
    procedure WriteBool(const Section, Ident: string; Value: Boolean); virtual;
    function ReadDateTime(const Section, Ident: string; Default: TDateTime): TDateTime; virtual;
    procedure WriteDateTime(const Section, Ident: string; Value: TDateTime); virtual;
    function ReadMSecs(const Section, Ident, Default: string): integer; virtual;
    { liest Zeitangabe mit Einheit (30s, 5m, 2h, 1000ms) und wandelt in ms um }
    function ReadBinary(const Section, Ident: string): Pointer; virtual;
    (* liest Hexcodierte Binärinformation in dynamisch angelegten Buffer
       nicht implementiert !*)
    procedure WriteBinary(const Section, Ident: string; Buffer: PChar; BuffSize: integer); virtual;
    (* Schreibt Binärinformation in Buffer als Hexcodierung n.t. *)
    procedure ReadStrings(const Section, Ident: string; Value: TStrings); virtual;
    (* Liest Values (als Commatext) *)
    procedure WriteStrings(const Section, Ident: string; Value: TStrings); virtual;
    (* Schreibt TStrings in eine Zeile (als Commatext) *)
    function ReadSection(const Section: string; Strings: TStrings): boolean; virtual;
    {Liest die linke Seite vor '='}
    function ReadSectionValues(const Section: string; Strings: TStrings): boolean; virtual;
    {liest alles komplett links und rechts}
    function ReadSectionValuesUniqueTyp(const Section: string; Strings: TStrings): boolean; virtual;
    {wie ReadSectionValues aber nur einen SectionTyp}
    function ReadSectionValuesDflt(const Section: string; Strings: TStrings): boolean;
    // Liest Section vollständig. Überschreibt Strings nur wenn [Section] existiert (kann auch leer sein)
    function ReadSectionStrings(const Section: string; Strings: TStrings): boolean; virtual;
    (* Liest rechte Seiten einer Section nach Strings *)
    function GetSectionStrings(const Section: string; Strings: TStrings): boolean;
    (* Wenn Daten vorhanden wird Strings vor dem Kopieren gelöscht. *)
    procedure EraseSection(const Section: string); virtual;
    {Löschen einer Sektion}
    procedure WriteSection(const Section: string; Strings: TStrings); virtual;
    {Schreibt eine Sektion}
    procedure ReplaceSection(const Section: string; Strings: TStrings);
    {Ersetzt eine Sektion}
    procedure WriteSectionStrings(const Section: string; Strings: TStrings); virtual;
    {Schreibt eine Sektion mit unstrukturierten Strings (ohne '=', doppelte Keys usw.) }
    procedure ReplaceSectionStrings(const Section: string; Strings: TStrings);
    {Ersetzt eine Sektion mit unstrukturierten Strings}
    procedure PutSectionStrings(const Section: string; Strings: TStrings); virtual;
    {Wie WriteSectionStrings aber löscht alte Einträge}
    procedure EraseIdent(const Section, Ident: string); virtual;
    {Löschen einer Zeile einer Sektion}
    function ExistsSection(const Section: string): boolean;
    //ergibt true wenn Section existiert (auch ohne Einträge)
    procedure NewSection(const Section: string); virtual;
    {nur Section anlegen}
    procedure ReadSections(Strings: TStrings); virtual;
    {Liest alle Sections}
    procedure DeleteKey(const Section, Ident: String); virtual;
    {Löscht eine Zeile}
    procedure RefreshSection(const Section: string); virtual;
    {Section neu einolesen (nur IniDb}

    procedure ReadDrucker; virtual;
    {liest Drucker aus der INI und schreibt in SysParam.Drucker}
    procedure WriteDrucker; virtual;
    {SysParam.Drucker in die INI schreiben }
    function GetDruckerIndex(Name:String) : integer; virtual;                   {JP 05.12.2002}
    {liefert DruckerIndex des DruckerNamen}
    procedure AddHelpMenu(AHelpMenu: TMenuItem); virtual;
    {Erwiter des Hilfe-Menüs um Einträge der INI-Datei}
    procedure HelpMenuClick(Sender: TObject); virtual;
    property FilePath: string read GetFilePath write SetFilePath;
    function INITED: string; virtual;  //ergibt Kürzel für Edit-Aufruf (DB)
    procedure Edit; virtual; //startet Editor mit INI-File
    property SectionTyp[const Section: string]: TSecTyp read GetSectionTyp write SetSectionTyp;
    property DefaultSectionTyp: TSecTyp read fDefaultSectionTyp write fDefaultSectionTyp;
    property CacheTemp: boolean read FCacheTemp write SetCacheTemp;  //md27.03.08 ISA
  published
    property FileName: string read GetFileName write SetFileName;    {Name der INI-Datei}
    property OnInit: TNotifyEvent read FOnInit write FOnInit;
    property DruckerTypen: TStringList read GetDruckerTypen write SetDruckerTypen;
    property UsePrnName: boolean read FUsePrnName write FUsePrnName;            {JP 13.01.2003}
    property IgnoreFileError: boolean read FIgnoreFileError write FIgnoreFileError;  //md26.03.08 ISA
  end;

  THintIni = class(TIniKmp)
  private
  protected
    function GetFilePath: string; override; {vollständiger FileName}
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    destructor Destroy; override;
    procedure ReadHints(AKurz: string; AForm: TComponent);
    procedure WriteHints(AKurz: string; AForm: TComponent);
    procedure WriteHint(AKurz, AName, AHint: string);
    procedure WriteCaption(AKurz, AName, ACaption: string);
    function ReadHint(AKurz, AName: string): string;
    procedure EditHints(AKurz: string);
    procedure EditHint(ANavLink: TNavLink; Sender: TWinControl);
  end;

const
  SDefaultDialog = '___SDefaultDialog';
  SSystem = 'System';
  SUmgebung = 'Umgebung';
  SDefaultPrinter = 'Standarddrucker';
  SHardcopyPrinter = 'Hardcopy Drucker';
  SDrucker = 'Drucker';
var
  IniKmp: TIniKmp;
  HintIni: THintIni;

implementation

uses
  SysUtils, Consts, Forms, Dialogs, ShellApi, Buttons,
  StdCtrls, DbCtrls,
  Printers,
  Err__Kmp, Prots, Ini__Dlg,
  GNav_Kmp, Hint_Dlg, Qwf_Form;

constructor TIniKmp.Create(AOwner: TComponent);
var
  P: integer;
  AFileName: string;
begin
  inherited Create(AOwner);
  {if IniKmp <> nil then
    raise EInit.Create('INI Komponente bereits vorhanden');}
  if (IniKmp = nil) and (self.ClassType = TIniKmp) then                {mehrere INI erlauben}
    IniKmp := self;

  try
    FFileName := StrAlloc(256);
    FDruckerTypen := TStringList.Create;
    FDruckerTypen.Sorted := true;
    FDruckerTypen.Duplicates := dupIgnore;
    FDefaultSectionTyp := stUser;

    if IniKmp = self then
    begin
      AFileName := ExtractFileName(Application.ExeName);
      P := Pos('.',AFileName);
      if P > 0 then
        AFileName := Format('%sINI', [Copy(AFileName, 1, P)]) else
        AFileName := Format('%s.INI', [AFileName]);
      FileName := AFileName;
    end else
      FileName := '';
  except
    on E:Exception do
      MessageFmt('%s', [E.Message], mtError, [mbOK], 0);
  end;
end;

destructor TIniKmp.Destroy;
begin
  StrDispose(FFileName);
  FreeAndNil(FDruckerTypen);
  FreeAndNil(FIniDruckerTypen);
  if IniKmp = self then
    IniKmp := nil;
  inherited Destroy;
end;

procedure TIniKmp.Loaded;
begin
  inherited Loaded;
  if assigned(FOnInit) then
    FOnInit(self);
  if (self = IniKmp) and not (csDesigning in ComponentState) then
    SysParam.ClearDrucker;  // 26.03.09 lazy ReadDrucker; 
end;

function TIniKmp.GetFilePath: string;
{vollständiger FileName}
{var
  WinDir: array[0..250] of char;}
begin
  (*result := FileName;
  if (result <> '') and (Pos(':', result) = 0) and (Pos('\', result) = 0) then
  begin
    GetWindowsDirectory(WinDir, sizeof(WinDir));
    result := Format('%s\%s', [StrPas(WinDir), FileName]);
  end;*)
  result := FileName;
  if result = '' then
    result := OnlyTableName(Application.ExeName) + '.INI';
  if (result <> '') and (Pos(':', result) = 0) and (Pos('\', result) = 0) then
  begin
    //result := AppDir + result;  ist falsch 23.08.03
    result := WinDir + result;    //23.08.03
  end;            {Idee: gleiches Dir wie INI}
end;

procedure TIniKmp.SetFilePath(const Value: string);
{bedient Property FileName mit DfltDir=<AppDir>}
begin
  if (Value <> '') and (Pos(':', Value) = 0) and (Pos('\', Value) <> 1) then   //= 0
  begin
    FileName := AppDir + Value;
  end else
    FileName := Value;
end;

function TIniKmp.GetFileName: string;
{bedient Property FileName}
begin
  if FFileName = nil then
    Result := '' else
    Result := StrPas(FFileName);
end;

procedure TIniKmp.SetFileName(Value: string);
{bedient Property FileName mit DfltDir=<WinDir>}
begin
  if FFileName <> nil then
  begin
    StrPCopy(FFileName, Value);
    if not (csLoading in ComponentState) and not (csDesigning in ComponentState) and
       (self = IniKmp) then
    begin
      // 26.03.09 ReadDrucker;
      Sysparam.ClearDrucker;  //lazy loading. Löscht nur IniDrucker.
    end;
  end;
end;

function TIniKmp.ReadStr(const Section, Ident: string; Default: PChar;
  Buffer: PChar; BuffSize: Cardinal): Cardinal;
var
  CSection: array[0..127] of Char;
  CIdent: array[0..127] of Char;
begin
  Result := GetPrivateProfileString(
    StrPLCopy(CSection, Section, SizeOf(CSection) - 1),
    StrPLCopy(CIdent, Ident, SizeOf(CIdent) - 1),
    Default, Buffer, BuffSize, FFileName);
end;

procedure TIniKmp.WriteStr(const Section, Ident: string; Value: PChar);
var
  CSection: array[0..127] of Char;
  CIdent: array[0..127] of Char;
begin
  if (Section = '') or (Ident = '') then
    Exit;  //keine Info
  if not WritePrivateProfileString(
    StrPLCopy(CSection, Section, SizeOf(CSection) - 1),
    StrPLCopy(CIdent, Ident, SizeOf(CIdent) - 1),
    Value, FFileName) then
      FileWriteError('WriteStr(%s,%s)', [Section, Ident]);
      //raise Exception.Create(Format(SIniFileWriteError, [FileName]));
end;

function TIniKmp.ReadString(const Section, Ident, Default: string): string;
var
  CSection: array[0..127] of Char;
  CIdent: array[0..127] of Char;
  CDefault: array[0..255] of Char;
  CResult: array[0..255] of Char;
begin
  if Default = SDefaultDialog then
    StrPCopy(CDefault, '') else                      {SDefaultDialog}
    StrPCopy(CDefault, Default);
  GetPrivateProfileString(
    StrPLCopy(CSection, Section, SizeOf(CSection) - 1),
    StrPLCopy(CIdent, Ident, SizeOf(CIdent) - 1),
    CDefault,
    CResult, sizeof(CResult), FFileName);
  Result := StrPas(CResult);
  if Default = SDefaultDialog then
    if Result = '' then                            {SDefaultDialog}
      Result := TDlgIni.Execute(self, Section, Ident);
end;

function TIniKmp.ReadStrDflt(const Section, Ident, Default: string): string;
//wie Readstring. Verwendet aber Default auch wenn Leerstring in  INI. 29.08.02 QSBT
begin
  result := ReadString(Section, Ident, Default);
  if result = '' then                   {wenn Leerstring in INI dann Default verwenden}
    result := Default;                  {29.08.02 QSBT}
end;

procedure TIniKmp.FileWriteError(const Fmt: string; const Args: array of const);
var
  S, S1: string;
  N: DWORD;
begin
  S := FormatTol(Fmt, Args);
  S1 := Format(SIniFileWriteError, [FileName]);
  N := GetLastError;
  if IgnoreFileError then
    Prot0('%s:' + CRLF + '%s' + CRLF + '%d:%s', [S, S1, N, SysErrorMessage(N)])
  else
    EError('%s:' + CRLF + '%s' + CRLF + '%d:%s', [S, S1, N, SysErrorMessage(N)])
end;

procedure TIniKmp.WriteString(const Section, Ident, Value: string);
var
  CSection: array[0..127] of Char;
  CIdent: array[0..127] of Char;
  CValue: array[0..255] of Char;
begin
  if (Section = '') or (Ident = '') then
    Exit;  //keine Info
  if not WritePrivateProfileString(
     StrPLCopy(CSection, Section, SizeOf(CSection) - 1),
     StrPLCopy(CIdent, Ident, SizeOf(CIdent) - 1),
     StrPCopy(CValue, Value), FFileName) then
    FileWriteError('WriteString(%s,%s,%s)', [Section, Ident, Value]);
end;

procedure TIniKmp.DeleteKey(const Section, Ident: String);
begin
  WritePrivateProfileString(PChar(Section), PChar(Ident), nil,
     PChar(FFileName));
end;

function TIniKmp.ReadInteger(const Section, Ident: string; Default: Longint): Longint;
var
  IStr: string;
begin
  IStr := ReadString(Section, Ident, '');
  if CompareText(Copy(IStr, 1, 2), '0x') = 0 then
    IStr := '$' + Copy(IStr, 3, 255);
  Result := StrToIntDef(IStr, Default);
end;

procedure TIniKmp.WriteInteger(const Section, Ident: string; Value: Longint);
begin
  WriteString(Section, Ident, IntToStr(Value));
end;

function TIniKmp.ReadFloat(const Section, Ident: string; Default: Extended): Extended;
var
  IStr: string;
begin
  IStr := ReadString(Section, Ident, FloatToStr(Default));
  Result := StrToFloatDef(IStr, Default);
end;

function TIniKmp.ReadFloatIntl(const Section, Ident: string; Default: Extended): Extended;
// akzeptiert internationale Zahlenformat (1,234.56  1.234,56  1 234,56  .5)
var
  IStr: string;
begin
  IStr := ReadString(Section, Ident, FloatToStr(Default));
  try
    Result := StrToFloatIntl(IStr, false);
  except
    Result := Default;
  end;
end;

procedure TIniKmp.WriteFloat(const Section, Ident: string; Value: Extended);
begin
  WriteString(Section, Ident, FloatToStr(Value));
end;

function TIniKmp.ReadBool(const Section, Ident: string;
  Default: Boolean): Boolean;
begin
  Result := ReadInteger(Section, Ident, Ord(Default)) <> 0;
end;

procedure TIniKmp.WriteBool(const Section, Ident: string; Value: Boolean);
const
  Values: array[Boolean] of string = ('0', '1');
begin
  WriteString(Section, Ident, Values[Value]);
end;

function TIniKmp.ReadDateTime(const Section, Ident: string; Default: TDateTime): TDateTime;
// liest Dateum+Zeit in einem unabhängigen Format yyyy-mm-dd-hh-nn-ss.
var
  S: string;
begin
  S := ReadString(Section, Ident, DateTimeToStrIntl(Default));
  try
    Result := StrToDateTimeIntl(S);
  except
    Result := Default;
  end;
end;

procedure TIniKmp.WriteDateTime(const Section, Ident: string; Value: TDateTime);
begin
  WriteString(Section, Ident, DateTimeToStrIntl(Value));
end;

function TIniKmp.ReadMSecs(const Section, Ident, Default: string): integer;
{ liest Zeitangabe mit Einheit (30s, 5m, 2h, 1000ms) und wandelt in ms um }
{ Write via WriteString }
var
  S: string;
begin
  S := ReadString(Section, Ident, '');
  result := StrToMSecs(S, Default);
end;

function TIniKmp.ReadBinary(const Section, Ident: string): Pointer;
(* liest Hexcodierte Binärinformation in dynamisch angelegten Buffer
   nicht implementiert !*)
var
  CSection: array[0..127] of Char;
  CIdent: array[0..127] of Char;
  CDefault: array[0..255] of Char;
  CResult: array[0..255] of Char;
begin
  GetPrivateProfileString(
    StrPLCopy(CSection, Section, SizeOf(CSection) - 1),
    StrPLCopy(CIdent, Ident, SizeOf(CIdent) - 1),
    StrPCopy(CDefault, ''),
    CResult, sizeof(CResult), FFileName);
  Result := StrNew(CResult);
end;

procedure TIniKmp.WriteBinary(const Section, Ident: string; Buffer: PChar;
  BuffSize: integer);
(* Schreibt Binärinformation in Buffer als Hexcodierung *)
var
  CSection: array[0..127] of Char;
  CIdent: array[0..127] of Char;
  Value: PChar;
  S: array[0..2] of char;
  I: integer;
begin
  if (Section = '') or (Ident = '') then
    Exit;  //keine Info
  Value := StrAlloc(BuffSize * 2 + 1);
  for I := 0 to BuffSize-1 do
  begin
    StrFmt(S, '%02.2X', [Byte(Buffer[I])]);
    StrMove(Value + 2*I, S, 2);
  end;
  Value[BuffSize * 2] := #0;
  if not WritePrivateProfileString(
    StrPLCopy(CSection, Section, SizeOf(CSection) - 1),
    StrPLCopy(CIdent, Ident, SizeOf(CIdent) - 1),
    Value, FFileName) then
      FileWriteError('WriteBinary(%s,%s)', [Section, Ident]);

end;

procedure TIniKmp.ReadStrings(const Section, Ident: string; Value: TStrings);
(* Liest Values (als Commatext) an 23.12.09
19.01.10 Commatext verworfen wg 255-Zeichen Begrenzung. Jetzt Zeilenbegrenzung auf 255.
*)
var
  L, L1: TStringList;
  I, N: integer;
begin
  if Value = nil then
    Exit;
  //Value.CommaText := ReadString(Section, Ident, Value.CommaText);
  //Key = Ident + '.' + Zeilennummer
  L := nil; L1 := nil;
  try
    L := TStringList.Create;
    L1 := TStringList.Create;
    ReadSection(Section, L);  //L=0,1,2,5,...
    N := 0;
    for I := L.Count - 1 downto 0 do
    begin
      if not BeginsWith(L[I], Ident + '.', true) then
        L.Delete(I) else  //nicht unsere Einträge
        N := IMax(N, StrToIntTol(Copy(L[I], Length(Ident) + 2, MaxInt)));
    end;
    for I := 0 to N do  //0..N -> N+1 Einträge
      L1.Add('');
    for I := 0 to L.Count - 1 do
    begin
      N := StrToIntTol(Copy(L[I], Length(Ident) + 2, MaxInt));
      L1[N] := ReadString(Section, L[I], '');
    end;
    SetStringsWidth(L1, 0, '\');  //Expandieren
    Value.Assign(L1);
  finally
    L.Free;
    L1.Free;
  end;
end;

procedure TIniKmp.WriteStrings(const Section, Ident: string; Value: TStrings);
(* Schreibt TStrings in eine Zeile (als Commatext) ab 23.12.09
Löscht Inhalt vorher
19.01.10 Commatext verworfen wg 255-Zeichen Begrenzung
         Keine Zeilenbegrenzung von 255; wird mittels '\' Trennern aufgehoben.
*)
var
  L, L1: TStringList;
  I: integer;
begin
  if Value = nil then
    Exit;
  (* WriteString(Section, Ident, Value.CommaText);
  *)
  //1. alle linken Seiten lesen ->L
  //   alle Einträge <> Ident.* löschen
  //2. Rechte Seiten in L mit Value[] belegen.
  //3. alle L[] löschen ohne rechte Seite  (='')
  //4. alle L[] schreiben mit rechter Seite
  L := nil; L1 := nil;
  try
    L := TStringList.Create;
    L1 := TStringList.Create;
    ReadSection(Section, L);  //L=0,1,2,5,...
    //ProtStrings(L, 'Abschnitt 1');
    for I := L.Count - 1 downto 0 do
    begin
      if not BeginsWith(L[I], Ident + '.', true) then
        L.Delete(I) else
        L[I] := L[I] + '=';
    end;
    //ProtStrings(L, 'Abschnitt 2');
    L1.Assign(Value);
    SetStringsWidth(L1, 250, '\');
    for I := 0 to L1.Count - 1 do
    begin
      if Trim(L1[I]) <> '' then  //wichtig: gelesene L[] hier nicht löschen!
        L.Values[Ident + '.' + IntToStr(I)] := Trim(L1[I]);
    end;
    //ProtStrings(L, 'Abschnitt 3');
    for I := 0 to L.Count - 1 do
    begin
      if StrValue(L[I]) = '' then
        DeleteKey(Section, StrParam(L[I])) else  //nur Zeilen mit Inhalt schreiben
        WriteString(Section, StrParam(L[I]), StrValue(L[I]));  //linke Seite=Zeilennummer
    end;
  finally
    L.Free;
    L1.Free;
  end;
end;

function TIniKmp.ReadSection(const Section: string; Strings: TStrings): boolean;
{ Liest linke Seiten einer Section und addiert sie nach Strings.
  ergibt false wenn Buffer oder eine Zeile nicht vollst. gelesen wurden }
const
  BufSize = 8192;
var
  Buffer, P: PChar;
  Count: Integer;
  CSection: array[0..127] of Char;
begin
  result := true;
  {kein strings.clear !   QUERY 270897}
  GetMem(Buffer, BufSize);
  try
    Count := GetPrivateProfileString(StrPLCopy(CSection, Section,
      SizeOf(CSection) - 1), nil, nil, Buffer, BufSize, FFileName);
    if Count > BufSize - 3 then result := false;
    P := Buffer;
    if Count > 0 then
      while (P[0] <> #0) do
      begin
        Strings.Add(StrPas(P));
        Inc(P, StrLen(P) + 1);
        if StrLen(P) > 255 then result := false;
      end;
  finally
    FreeMem(Buffer, BufSize);
  end;
end;

function TIniKmp.ReadSectionValues(const Section: string; Strings: TStrings): boolean;
(* Liest Section vollständig (linke und rechte Seiten)
   ergibt false wenn Buffer oder eine Zeile nicht vollst. gelesen wurden
   Strings wird vorher nicht gelöscht aber gemerged *)
var
  KeyList: TStringList;
  I: Integer;
  AValue: string;
begin
  {kein clear !   QUERY 270897}
  KeyList := TStringList.Create;
  try
    Strings.BeginUpdate;                //01.12.02  QSBT.KKWLokal
    result := ReadSection(Section, KeyList);
    for I := 0 to Keylist.Count - 1 do
    begin    {auch leere Rechte Seiten nehmen ! (TqForm.PutValues) }
      AValue := ReadString(Section, KeyList[I], '');
      if (Strings.Values[KeyList[I]] <> '') then
      begin
        if AValue <> '' then
          Strings.Values[KeyList[I]] := AValue;
      end else
      if AValue <> '' then
        Strings.Add(Format('%s=%s', [KeyList[I], AValue])) else
        Strings.Add(Format('%s=', [KeyList[I]])); {doch immer mit = zurückgeben}
      if length(AValue) + length(KeyList[I]) + 1 > 255 then result := false;
    end;
  finally
    KeyList.Free;
    Strings.EndUpdate;                //01.12.02
  end;
end;

function TIniKmp.ReadSectionValuesUniqueTyp(const Section: string;
  Strings: TStrings): boolean;
begin
  result := ReadSectionValues(Section, Strings);
end;

function TIniKmp.ReadSectionValuesDflt(const Section: string; Strings: TStrings): boolean;
// Liest Section vollständig. Überschreibt Strings nur wenn [Section] existiert (kann auch leer sein)
begin
  Result := ExistsSection(Section);
  if Result then
  begin
    Strings.Clear;
    ReadSectionValues(Section, Strings);
  end;
end;

function TIniKmp.GetSectionStrings(const Section: string; Strings: TStrings): boolean;
(* Liest nur rechte Seiten einer Section nach Strings
   Wenn Daten vorhanden wird Strings vor dem Kopieren gelöscht. *)
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    Result := ReadSectionStrings(Section, L);
    if L.Count > 0 then
      Strings.Assign(L);
  finally
    L.Free;
  end;
end;

function TIniKmp.ReadSectionStrings(const Section: string; Strings: TStrings): boolean;
(* Liest nur rechte Seiten einer Section nach Strings *)
var
  KeyList: TStringList;
  I: Integer;
  AValue: string;
begin
  {kein clear !   QUERY 270897}
  KeyList := TStringList.Create;
  KeyList.Sorted := true;  //neu 01.09.05
  KeyList.Duplicates := dupIgnore;
  try
    result := ReadSection(Section, KeyList);
    for I := 0 to Keylist.Count - 1 do
    begin    {auch leere Rechte Seiten nehmen ! (TqForm.PutValues) }
      AValue := ReadString(Section, KeyList[I], '');
      Strings.Add(AValue);
    end;
  finally
    KeyList.Free;
  end;
end;

procedure TIniKmp.EraseSection(const Section: string);
var
  CSection: array[0..127] of Char;
begin
  if not WritePrivateProfileString(
    StrPLCopy(CSection, Section, SizeOf(CSection) - 1),
    nil, nil, FFileName) then
      FileWriteError('EraseSection(%s)', [Section]);
end;

procedure TIniKmp.WriteSection(const Section: string; Strings: TStrings);
(* Abschnitt mit neuen Einträgen ergänzen/überschreiben *)
var
  I: integer;
begin
  for I:= 0 to Strings.Count-1 do
  begin
    WriteString(Section, StrParam(Strings[I]), StrValue(Strings[I]));
  end;
end;

procedure TIniKmp.ReplaceSection(const Section: string; Strings: TStrings);
(* Abschnitt mit neuen Einträgen ersetzen *)
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    ReadSectionValues(Section, L);
    if L.Text <> Strings.Text then
    begin
      EraseSection(Section);
      WriteSection(Section, Strings);
    end;
  finally
    L.Free;
  end;
end;

procedure TIniKmp.PutSectionStrings(const Section: string; Strings: TStrings);
{Wie WriteSectionStrings aber löscht alte Einträge}
begin
  EraseSection(Section);
  WriteSectionStrings(Section, Strings);
end;

procedure TIniKmp.ReplaceSectionStrings(const Section: string; Strings: TStrings);
// Ersetzt SectionStrings (0=Line1..) nur wenn geändert
var
  L: TStringList;
  I: integer;
begin
  L  := TStringList.Create;
  try
    for I:= 0 to Strings.Count-1 do
    begin
      L.Add(Format('%d=%s', [I, Strings[I]]));
    end;
    ReplaceSection(Section, L);
  finally
    L.Free;
  end;
end;

procedure TIniKmp.WriteSectionStrings(const Section: string; Strings: TStrings);
{Schreibt eine Sektion mit unstrukturierten Strings.
 Löscht alte Einträge nicht.
 (ohne '=', doppelte Keys usw.) i.d.Form:  0=S1   1=S2  ...
 Lesen mit ReadSectionStrings oder GetSectionStrings
}
var
  I: integer;
begin
  (* ohne EraseSection *)
  for I:= 0 to Strings.Count-1 do
  begin
    WriteString(Section, IntToStr(I), Strings[I]);
  end;
end;

procedure TIniKmp.EraseIdent(const Section, Ident: string);
var
  CSection: array[0..127] of Char;
  CIdent: array[0..127] of Char;
begin
  if not WritePrivateProfileString(
    StrPLCopy(CSection, Section, SizeOf(CSection) - 1),
    StrPLCopy(CIdent, Ident, SizeOf(CIdent) - 1),
    nil, FFileName) then
      FileWriteError('EraseIdent(%s,%s)', [Section, Ident]);
end;

procedure TIniKmp.NewSection(const Section: string);
const
  TmpStr = 'paofuisd';
begin
  WriteString(Section, TmpStr, TmpStr);
  EraseIdent(Section, TmpStr);
end;

procedure TIniKmp.ReadSections(Strings: TStrings);
{Liest alle Sections (gibt Bezeichnungen ohne [] zurück) }
var
  AFile: TextFile;
  ALine: string;
begin
  AssignFile(AFile, FilePath);
  Reset(AFile);
  Strings.Clear;
  {$I+}
  try
    while not System.EOF(AFile) do
    begin
      ReadLn(AFile, ALine);
      if copy(ALine, 1, 1) = '[' then
        Strings.Add(copy(ALine, 2, length(ALine) - 2));
    end;
  finally
    CloseFile(AFile);
  end;
end;

function TIniKmp.ExistsSection(const Section: string): boolean;
//ergibt true wenn Section existiert (auch ohne Einträge)
var
  L: TStrings;
begin
  L := TStringList.Create;
  try
    ReadSections(L);
    Result := L.IndexOf(Section) >= 0;  //ignore case
  finally
    L.Free;
  end;
end;


(*** Drucker von .INI ********************************************************)

procedure TIniKmp.SetDruckerTypen(Value: TStringList);
{bedient Property DruckerTypen}
begin
  if Value = nil then
  begin
    FreeAndNil(fIniDruckerTypen);  //Lazy
  end else
    DruckerTypen.Assign(Value); {Kopieren von Value nach FDruckerTypen}
end;

function TIniKmp.GetDruckerTypen: TStringList;
begin
  if (FIniDruckerTypen = nil) and
     not (csLoading in ComponentState) then
  begin
    FIniDruckerTypen := TStringList.Create;
    FIniDruckerTypen.Sorted := true;
    FIniDruckerTypen.Duplicates := dupIgnore;
    ReadDrucker;  //lazy loading
  end;
  Result := FDruckerTypen;
end;

procedure TIniKmp.ReadDrucker;
(* INI -> SysParam *)
var
  I: integer;
  ADruckerIndex: string;
  ADruckerName: string;
  AList: TStringList;
begin
  // Druckertypen um .ini erweitern:
  AList := TStringList.Create;
  InReadDrucker := true;
  try
    ReadSection(SDrucker, AList);
    for I:= 0 to AList.Count - 1 do
    begin
      DruckerTypen.Add(AList.Strings[i]);  //dupIgnore
    end;

    SysParam.Drucker.Clear;
    for I:= 0 to DruckerTypen.Count - 1 do
    begin
      if UsePrnName then
      begin
        ADruckerName := ReadString(SDrucker, DruckerTypen.Strings[i], SDefaultPrinter);
        ADruckerIndex := IntToStr(GetDruckerIndex(ADruckerName));
      end else
      begin
        ADruckerIndex := ReadString(SDrucker, DruckerTypen.Strings[i], '-1');
      end;
      SysParam.Drucker.AddFmt('%s=%s', [DruckerTypen.Strings[i], ADruckerIndex]);
    end;
  finally
    InReadDrucker := false;
    AList.Free;
  end;
end;

procedure TIniKmp.WriteDrucker;
(* SysParam -> INI *)
var
  I: integer;
  ADruckerName: string;
  ADruckerIndex: string;
begin
  SectionTyp[SDrucker] := stMaschine;
  for I:= 0 to SysParam.Drucker.Count-1 do
  begin
    ADruckerIndex := SysParam.Drucker.Value(I);
    if UsePrnName then
    begin
      if ADruckerIndex = '-1' then
      begin
        ADruckerName := SDefaultPrinter;
      end else
      try
        ADruckerName := Printer.Printers.Strings[StrToInt(ADruckerIndex)];
      except
        ADruckerName := SDefaultPrinter;
      end;
      WriteString(SDrucker, SysParam.Drucker.Param(I), ADruckerName);
    end else
    begin
      WriteString(SDrucker, SysParam.Drucker.Param(I), ADruckerIndex);
    end;
  end;
end;

function TIniKmp.GetDruckerIndex(Name: string) : integer;                        {JP 05.12.2002}
var
  I: integer;
begin
  result := StrToIntDef(Name, -1);  //md 04.09.08 wg Kompatibilität
  for I := 0 to printer.printers.Count-1 do
  begin
    if printer.printers[I] = Name then
    begin
      result := I;
      break;
    end;
  end;
end;

procedure TIniKmp.AddHelpMenu(AHelpMenu: TMenuItem);
(* INI -> Hilfemenü *)
{Ergänzen von HelpMenü um Einträge aus der INI}
var
  I: integer;
  AList: TValueList;
  NewItem: TMenuItem;
begin
  if AHelpMenu <> nil then
  begin
    AList := TValueList.Create;
    try
      ReadSectionValues('Hilfe', AList);
      for I:= 0 to AList.Count-1 do
      begin
        if CompareText(AList.Param(I), 'Helpfile') = 0 then
          continue;
        NewItem := TMenuItem.Create(AHelpMenu);
        NewItem.Caption := AList.Param(I);
        NewItem.OnClick := HelpMenuClick;
        AHelpMenu.Add(NewItem);
      end;
    finally
      AList.Free;
    end;
  end;
end;

procedure TIniKmp.HelpMenuClick(Sender: TObject);
{CallBack-Funktion belegen}
var
  //Error: THandle;
  //FileName: PChar;
  FName: string;
begin
  with (Sender as TMenuItem) do
  begin
    FName := ReadString('Hilfe', Caption, '');
    if FName <> '' then
    begin
      SysParam.DisplayWinExecError := true;
      ShellExecAndWait(FName, SW_SHOWNORMAL);
      (* FileName := StrPNew(FName);
      Error := ShellExecute(Application.Handle, nil, FileName, nil, '',
        SW_SHOWNORMAL);
      if Error <= 32 then
        ErrWarn('Fehler(%d:%s) beim Ausführen von (%s)',
          [Error, WinExecErrorStr(Error), FName]);
      StrDispose(FileName); *)
    end;
  end;
end;

procedure TIniKmp.Edit;
begin  //startet Editor mit INI-File
  SysParam.DisplayWinExecError := true;
  ShellExecNoWait(FilePath, SW_SHOWNORMAL);
end;

function TIniKmp.INITED: string;
begin
  result := 'ini';    //Dummy
end;

(*** THintIni *******************************************************************)

function THintIni.GetFilePath: string; {override;}
begin
  result := FileName;
  if result = '' then
    result := Application.ExeName;
  if (result <> '') and (Pos(':', result) = 0) and (Pos('\', result) = 0) then
  begin
    result := AppDir + result;   {wichtig für ISA#GlobalIni}
  end;            {Idee: gleiches Dir wie INI}
end;

constructor THintIni.Create(AOwner: TComponent); {override;}
begin
  inherited Create(AOwner);
  FileName := 'HINT.INI';
  HintIni := self;            {immer die zuletzt angelegte! Rala:2.Hintini in logon}
end;

destructor THintIni.Destroy; {override;}
begin
  HintIni := nil;
  inherited Destroy;
end;

procedure THintIni.Loaded; {override;}
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
  begin
    FileName := FilePath;           {für ReadString usw. damit nicht WinDir}
    // Vorauss.: IniKmp ist auf LogonFrm und HintIni ist auf MainFrm
    //  in anderen Fällen den folgenden Block nach Zuordnung von IniKmp.Filename programmieren
    if IniKmp <> nil then
      FilePath := IniKmp.ReadString('System', 'Hints', FileName);
  end;
end;

type
  TDummyControl = class(TControl);
  TDummyCustomCheckBox = class(TCustomCheckBox);

procedure THintIni.ReadHints(AKurz: string; AForm: TComponent);
(* INI -> Form.Hints *)
var
  I: integer;
  Hints: TValueList;
  AComponent: TComponent;
  function GetComponent(S: string): string;
  var                  {S:Componente.Property}
    P: integer;
  begin
    P := Pos('.', S);
    if P > 0 then
      result := copy(S, 1, P-1) else
      result := S; {kompatibel zur reinen Hint-Version}
  end;
  function GetProperty(S: string): Char;
  var                 {S:Componente.Property; H=Hint; C=Caption}
    P: integer;
  begin
    P := Pos('.', S);
    if P > 0 then
      result := S[P+1] else
      result := 'H'; {kompatibel zur reinen Hint-Version}
  end;
begin
  Hints := TValueList.Create;
  ReadSectionValues(AKurz, Hints);
  try
    //AForm := GNavigator.GetForm(AKurz);
    for I := 0 to Hints.Count - 1 do
    try
      AComponent := AForm.FindComponent(GetComponent(Hints.Param(I)));
      if Hints.Value(I) <> '' then                      {160800}
        if GetProperty(Hints.Param(I)) = 'H' then
          TControl(AComponent).Hint := StrToHint(Hints.Value(I)) else
          TDummyControl(AComponent).Caption := StrToHint(Hints.Value(I));
    except on E:Exception do
      EProt(self, E, '%s (ReadHints)', [Hints[I]]);
    end;
  finally
    Hints.Free;
  end;
end;

procedure THintIni.WriteHints(AKurz: string; AForm: TComponent);
(* Form.Hints -> INI *)
var
  I: integer;
  Hints: TValueList;
  AComponent : TComponent;
begin
  Hints := TValueList.Create;
  try
    //AForm := GNavigator.GetForm(AKurz);
    for I := 0 to AForm.ComponentCount - 1 do
    try
      AComponent := AForm.Components[I];
      if AComponent is TControl then
        Hints.Values[AComponent.Name] := HintToStr(TControl(AComponent).Hint); {nix bei ''}
    except on E:Exception do
      EMess(self, E, '%s (WriteHints)', [Hints[I]]);
    end;
    //EraseSection(AKurz);
    ReplaceSection(AKurz, Hints);
  finally
    Hints.Free;
  end;
end;

procedure THintIni.WriteHint(AKurz, AName, AHint: string);
begin
  if AHint = '' then
    DeleteKey(AKurz, AName + '.Hint') else
    WriteString(AKurz, AName + '.Hint', HintToStr(AHint));
end;

procedure THintIni.WriteCaption(AKurz, AName, ACaption: string);
begin
  if ACaption = '' then
    DeleteKey(AKurz, AName + '.Caption') else
    WriteString(AKurz, AName + '.Caption', ACaption);
end;

function THintIni.ReadHint(AKurz, AName: string): string;
begin
  result := StrToHint(ReadString(AKurz, AName + '.Hint', ''));
end;

procedure THintIni.EditHints(AKurz: string);
begin
end;

procedure THintIni.EditHint(ANavLink: TNavLink; Sender: TWinControl);
var
  I, P: integer;
  S: string;
  ALabel: TControl;
  ADataField, AKurz, ACaption, AAswName: string;
begin
  ALabel := nil;
  ACaption := '';
  ADataField := '';
  AAswName := '';
  if (Sender is TRadioButton) and (Sender.Parent is TDBRadioGroup) then
  begin
    Sender := Sender.Parent;
  end; //kein else
  {if Sender is TCustomCheckBox then
  begin
    ALabel := Sender;
    ACaption := TDummyCustomCheckBox(Sender).Caption;
  end else}
  if (Sender is TCustomCheckBox) or (Sender is TButton) then
  begin
    ALabel := Sender;
    ACaption := TDummyControl(ALabel).Caption;
  end else
  for I := 0 to ANavLink.Form.ComponentCount - 1 do
  begin
    if ANavLink.Form.Components[I] is TLabel then
      with ANavLink.Form.Components[I] as TLabel do
        if FocusControl = Sender then
        begin
          ALabel := ANavLink.Form.Components[I] as TControl;
          ACaption := TDummyControl(ALabel).Caption;
          break;
        end;
  end;
  if Sender is TDBEdit then
    ADataField := TDBEdit(Sender).DataField else
  if Sender is TDBCheckBox then
    ADataField := TDBCheckBox(Sender).DataField else
  if Sender is TDBComboBox then
    ADataField := TDBComboBox(Sender).DataField else
  if Sender is TDBListBox then
    ADataField := TDBListBox(Sender).DataField else
  if Sender is TDBRadioGroup then
    ADataField := TDBRadioGroup(Sender).DataField else
  if (Sender is TRadioButton) and (Sender.Parent is TDBRadioGroup) then
    ADataField := TDBRadioGroup(Sender.Parent).DataField else
  if Sender is TDBMemo then
    ADataField := TDBMemo(Sender).DataField;
  if (ADataField <> '') then
  begin
    S := ANavLink.FormatList.Values[ADataField];
    P := PosI('Asw,', S);
    if P > 0 then
      AAswName := copy(S, P + 4, 200);
  end;
  if ALabel = nil then
    ACaption := sNil;  {'__nil';}
  if TDlgHint.Execute(Sender, ACaption, AAswName) then
  begin
    AKurz := TqForm(ANavLink.Form).Kurz;
    WriteHint(AKurz, Sender.Name, Sender.Hint);
    if ALabel <> nil then
    begin
      TDummyControl(ALabel).Caption := ACaption;
      WriteCaption(AKurz, ALabel.Name, ACaption);
    end;
    if AAswName <> '' then          {gespeichert über AswEdDlg}
      FormCheckAsw(ANavLink.Form);
  end;
end;

{ IniDb Dummy Property }

function TIniKmp.GetSectionTyp(const Section: string): TSecTyp;
begin
  Result := stUser;  //dummy
end;

procedure TIniKmp.SetSectionTyp(const Section: string;
  const Value: TSecTyp);
begin
  //dummy
end;

procedure TIniKmp.RefreshSection(const Section: string);
begin
  //dummy
end;

procedure TIniKmp.SetCacheTemp(const Value: boolean);
// Kopiere INI Datei (auf Netzwerkpfad) nach Temp Pfad
var
  Copied: boolean;
  FnLokal: string;
  DTLokal, DTFile, DTLoaded: TDateTime;
  Err: DWORD;
begin
  if FCacheTemp <> Value then
  begin
    if Value then
    begin
      //von Normal nach Temp kopieren; LoadedFilepath setzen
      //wenn LoadedFilepath neuer als Temp oder temp fehlt dann nach Temp kopieren (vergl QLoader)
      FnLokal := TempDir + ExtractFilename(Filepath);
      FileAge(FnLokal, DTLokal);
      FileAge(Filepath, DTFile);
      Copied := FileExists(FnLokal) and (DTLokal >= DTFile);
      if not Copied then
      begin
        ProtL('Kopiere %s ==> %s', [ExtractFilename(Filepath), FnLokal]);
        Copied := Windows.CopyFile(PChar(Filepath), PChar(FnLokal), false);
        if not Copied then
        begin
          Err := GetLastError;
          ProtL('Fehler %d:%s', [Err, SysErrorMessage(Err)]);
        end;
      end;
      if Copied then
      begin
        LoadedFilePath := FilePath;
        FilePath := FnLokal;
      end;
    end else
    begin
      FileAge(LoadedFilePath, DTLoaded);
      FileAge(Filepath, DTFile);
      //wenn Temp neuer als LoadedFilepath dann nach LoadedFilepath kopieren
      Copied := FileExists(LoadedFilePath) and (DTLoaded >= DTFile);
      if not Copied then
      begin
        ProtL('Kopiere %s ==> %s', [ExtractFilename(Filepath), LoadedFilePath]);
        Copied := Windows.CopyFile(PChar(Filepath), PChar(LoadedFilePath), false);
        if not Copied then
        begin
          Err := GetLastError;
          ProtL('Fehler %d:%s', [Err, SysErrorMessage(Err)]);
        end;
      end;
      if Copied then
      begin
        FilePath := LoadedFilePath;
      end;
    end;
    if Copied then
      FCacheTemp := Value;
  end;
end;

end.
