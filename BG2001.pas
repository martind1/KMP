{************************************************************
 *  Allgemeine Routinen
 ************************************************************}

unit BG2001;

{============================================================
 I N T E R F A C E
 ============================================================}
interface

{************************************************************
 *  Uses
 ************************************************************}
uses
  SysUtils,
  Classes,
  WinProcs,
  Graphics,
  Forms,
  LZExpand,
  Controls,
  DB, DBTables,
  Dialogs;

{************************************************************
 *  Konstanten
 ************************************************************}
const
  EmptyDate     = '  .  .    ';
  NullDate      = '01.01.0000';
  Crypt1        = 52845;
  Crypt2        = 22719;
  BGKey         = 'WOECK';

  BackSlash     = '\';
  CR            = #13;
  LF            = #10;
  CRLF          = #13#10;
  TAB           = #9;

  KByte         = Sizeof(Byte) shl 10;
  MByte         = KByte        shl 10;
  GByte         = MByte        shl 10;

  FloatZero: Extended = 0.00000001;

  { Konstanten für die Variable CurrencyFormat }
  cfSignValue       = 0;    { "DM1,00"  }
  cfValueSign       = 1;    { "1,00DM"  }
  cfSignBlankValue  = 2;    { "DM 1,00" }
  cfValueBlankSign  = 3;    { "1,00 DM" }

  {-Euroumrechnung-------------------------------------------}
  RatioDM2Euro      = 1.95583;  { off. Kurs vom 31.12.98 }

  {CRC}
  ciPoly        : integer = $1021;                                                                   {Teilerpolynom nach CCITT V.41}

  ccWildChar         = char ('*');

  {für Encryption}
  StartKey = 983;  	{Start default key  my Prims}
  MultKey = 12689;	{Mult default key}
  AddKey = 35897;	  {Add default key}


{************************************************************
 *  Type-Declarations
 ************************************************************}
type
  { Aufzählungstypen }
  TCryptConvert = (ccNoConvert, ccBeforeCrypt, ccAfterCrypt);
  TSex = (sxMale, sxFemale, sxUnknown);

//  TWindowsVersion = (wvUnknown, wvWindows31, wvWindows95, wvWindows98, wvWindowsNT);

  TCompareDate = (cdDateAndTime, cdDate, cdTime);

  { Wochentage }
  TDayOfWeek = (dowMonday, dowTuesday, dowWednesday, dowThursday,
    dowFriday, dowSaturday, dowSunday);
  TDaysOfWeek = set of TDayOfWeek;

  { Ergebniswerte und Optionen für Stringvergleiche }
  TCompareStringResult = (csDifferent, csExactMatch,
    csFirstContainsSecond, csSecondContainsFirst, csMatchesWildcards);
  TCompareStringOptions = set of (csCaseSensitive, csPartialAnyWhere,
    csPartialFromLeft, csPartialFromRight, csAllowWildcards);

  TCharCase = (ccNormal, ccUpperCase, ccLowerCase);

  TFileAttribute = (fatReadOnly, fatHidden, fatSysFile, fatVolumeID,
    fatDirectory, fatArchive);
  TFileAttributes = set of TFileAttribute;

  TFloatFormat = (ffNormal,ffSlash,ffNone,ffZero);

  TLookUp = array [0..255] of integer;

{************************************************************
 *  Konstanten
 ************************************************************}
const
  dowAll = [dowMonday, dowTuesday, dowWednesday, dowThursday,
    dowFriday, dowSaturday, dowSunday];

{************************************************************
 *  Prototypes
 ************************************************************}

{ Clipper-Syntax-Kompatibilität }
function SubStr(S: String; Index: Integer; Count: Integer): String;
function RTrim(cString: string): string;
function LTrim(cString: string): string;
function AllTrim(cString: string): string;
function TextTrim(cString: string): string;
function PadR(cString: string; nLen: integer): string;
function PadRight(cString: string; nLen: integer): string;
function PadL(cString: string; nLen: integer): string;
function PadLeft(cString: string; nLen: integer): string;
function Replicate(c: char; nLen: integer): string;
function Space(nLen: integer): string;
function Empty(cString: string): boolean;
function LeftStr(cString: string; nLen: integer): string;
function RightStr(cString: string; nLen: integer): string;
function At(SubStr: String; Str: String): Integer;
function RAt(SubStr: String; Str: String): Integer;
function Lower(const S: String): String;
function Upper(const S: String): String;
function StrTran(const S: String; SeekStr, NewStr : string): String;

function FillWithZero (sInput : string; const iNormLen : integer) : string;
function StripZeros   (sInput : string) : string;



{ Nullterminierte Strings }
procedure AddStringToPChar(var Source: PChar; Add: String);
procedure AddPCharToPChar(var Source: PChar; Add: PChar);

{ Stringlisten-Konvertierung }
function TokenToStringList(S: String; Separator: Char; MinItems: Integer): TStringList;
function StringListToToken(S: TStringList; Separator: Char): String;
function CSStoStringList(S: String; MinItems: Integer): TStringList;
function StringListToCSS(S: TStringList): String;

{ String-Konvertierung }
function StringToInteger(Zahl: String; Default: LongInt): LongInt;
function StringToFloat(Zahl: String; Default: Extended): Extended;
function StringToFloatExt(Zahl: String; Default: Extended;
  DecSep: Char): Extended;
function StringToFloatPoints (Zahl: String; sDecimalSep : string; Default  : Double)     : Double;

function StringToBoolean(C: String): Boolean;
procedure ControlCharsToSpaces(var S: String);
function StringToDigitString(C: String): String;

{ Römische Ziffernstrings }
function IntToRoman(Value: Longint): String;
function RomanToInt(const S: String): Longint;

{ Hex-Konvertierung }
function HexToInt(const Hex: String): LongInt;
{procedure BinToHex(Bin, Hex: PChar);
procedure HexToBin(Hex, Bin: PChar);}

{ Boolsche Werte konvertieren }
function BooleanToString(Bool: Boolean): String;
function BooleanToJaNein(Bool: Boolean): String;
function BooleanToYesNo(Bool: Boolean): String;

{ Boolsche Werte Clipper kompatibel konvertieren }
function LogToChar(Bool: Boolean): Char;
function CharToLog(Zeichen: Char): Boolean;

{ Integer-Routinen }
function IntPower(Base,Exponent: Integer): LongInt;
function IntPower10(Exponent: Integer): LongInt;

{ Fließkomma-Routinen }
function FloatRound(P: Extended; Decimals: Integer): Extended;
function EqualsZero(P: Extended): Boolean;
function EqualsZeroFrac(P: Extended; Frac : integer): Boolean;
function CalcExpression(const Expr: String): Extended;
function FloatToCurrencyString(P: Extended): String;
function FloatToString(P: Extended; Decimals: Integer): String;
function FloatToStringSep(P: Extended; Decimals: Integer): String;
function FloatToStringExt(P: Extended; Decimals: Integer;
  FloatFormat : TFloatFormat): String;

function FloatToStringPoints (P: Extended; Decimals  : Integer): String;

{ Integer-Konvertierung }
function IntegerToZeroString(Value: LongInt; Len: Word): String;
function IntegerToSpaceString(Value: LongInt; Len: Word): String;
function IntegerToCurrencyString(Value: LongInt): String;

{ Ansi-Oem-Konvertierung }
function OemStringToAnsiString(Text: String): String;
function AnsiStringToOemString(Text: String): String;

{ Binärzahlen-Konvertierungen }
function BinToByte(S: String): Byte;
function BinToInt(S: String): Integer;
function BinToWord(S: String): Word;
function BinToLongInt(S: String): LongInt;
function ByteToBin(B: Byte): String;
function IntToBin(I: Integer): String;
function WordToBin(W: Word): String;
function LongIntToBin(L: LongInt): String;

{ Datums-/Zeit-Konvertierung }
function ExpandTime(S: String): TDateTime;
function ComprTime(T: TDateTime): String;
function TimeToString(T: TDateTime): String;
function TimeToStrSQL(T: TDateTime): String;
function TimeToHourMin(T: TDateTime): String;
function TimeToStrSec(T: TDateTime): String;
function StringToTime(S: String): TDateTime;
function DateToString(T: TDateTime): String;
function DateToStrSQL(T: TDateTime): String;
function DateToShortString(T: TDateTime): String;
function DateTimeToString(T: TDateTime): String;
function StringToDate(S: String): TDateTime;
function AnsiStringToDate(S: String): TDateTime;
function DateStringToAnsiString(S: String): String;
function DateToAnsiString(T: TDateTime): String;
function IsSameDateTime(Date1, Date2: TDateTime; Compare: TCompareDate): Boolean;
function RoundTime(ATime: TDateTime; Minutes: Word): TDateTime;

{ Typ-Konvertierungen }
function SexToString(Sex: TSex): String;
function StringToSex(Sex: String): TSex;
function ColorNumToColor(Num: LongInt): TColor;
function ColorToColorNum(Color: TColor): LongInt;
function KomplementaerColor(Color: TColor): TColor;

function StringToAlignment(Typ: String): TAlignment;
function AlignmentToString(Typ: TAlignment): String;
function PenModeNumToPenMode(Num: LongInt): TPenMode;
function BrushStyleNumToBrushStyle(Num: LongInt): TBrushStyle;

{ Resourcen-Strings }
function ResString(ID: Word): String;
function ResFmtString(ID: Word; const Args: array of const): String;

{ String-Manipulation }
function StringAdd(String1,String2,Insert: String): String;
function RestStr(Str: String; Pos: Integer): String;
function BriefAnrede(S: String; const Zusaetze: array of String): String;
function GermanUpperCase(Text: String): String;
function GermanLowerCase(Text: String): String;
function GrossKlein(Text: String): String;
function Capitalize(const S: String): String;
function LocalFileName(const FileName: String): String;
function ReplaceMacro(const S, Makro, Replace: String): String;
function ExpandMacroString(Value: String): String;
function SameString(const S1, S2: String): Boolean;
function SameStringAllTrim(const S1, S2: String): Boolean;
function SameStringWithOutSpaces(const S1, S2: String): Boolean;
function CompareStringsOld(S1, S2: String;
  Options: TCompareStringOptions): TCompareStringResult;
function CompareStrings (sSource : string; sDest : string) : boolean;
function DelSpace(const S: String): String;
function DelChars(const S: String; Chr: Char): String;
function StringToDigits(const S: String): String;
function FillRight(cString: String; nLen: Integer; cChar: Char): String;
function FillLeft(cString: String; nLen: Integer; cChar: Char): String;
function CharCount(const S: String; C: Char): Integer;
function TurnString(cString: String): String;
function TurnPlaces(cString: String; Pos1, Pos2 : integer): String;
function AddSigns  (cString: String; iAdd : integer): String;
function StripSign (sInput : string; cSign  : char)     : string;
function ReplaceWildCards(sSource : string; iNo : integer; cArgChar : char) : string;

function BuildLine(s, sDetail, AusR: string; iPos1, iPos2: integer) : string;
function BuildLineExt(sTrans, s, sDetail, AusR: string; iPos1, iPos2: integer) : string;

{ Tokenizing }
function Token(var S: String; Seperator: Char): String;
function TokenStr(var S: String; Seperator: string): String;
function TokenCount(S: String; Seperator: Char): Integer;
function TokenAt(const S: String; Seperator: Char; At: Integer): String;
procedure TokenToStrings(S: String; Seperator: Char; List: TStrings);
function TokenFromStrings(Seperator: Char; List: TStrings): String;
function GetTokenValueFromLine(sLine, sIdent: string): string;
function GetTokenIdentFromLine(sLine, sValue: string): string;
function GetIdent(s: String): string;
function GetValue(s: String): string;
{
procedure TokenToIntArray(S: String; Seperator: Char; List: TIntegerArray);
}

{ Validitierung }
function IsValidDateStr(datum: String): Boolean;
function IsValidNumStr(ziffer: String): Boolean;
function IsValidFloatStr(ziffer: String): Boolean;
function IsValidTimeStr(time: String): Boolean;

{ Verschlüsselung }
function Encrypt(const S: String; Key: Word): String;
function Decrypt(const S: String; Key: Word): String;
function Crypt(const S, Key: String; Ansi2Oem: TCryptConvert): String;
procedure CryptBuff(S: PChar; const Key: String; Ansi2Oem: TCryptConvert; Chars: LongInt);
function StrToHexStr(const InString: string): string; //Umwandlung in lesbaren Hex-Zeichen. Verdoppelt InString-Länge
function HexStrToStr(const InString: string): string;

{ASCII-Verschlüsselung mit einfachem Key}
function EncryptNew(const InString: string): string;
{Verschlüsselung nach Borland}
function DecryptNew(const InString: string): string;
{Entschlüsselung nach Borland}
function EncryptPassw(const InString: string; Len: integer): string;
//Passwort als Hexstring der festen Länge <Len> verschlüsseln.
//Len muss mindestens 2*Länge von Passw haben. Ansonsten erfolgt Exception
function DecryptPassw(const InString: string): string;
//Passwort entschlüsseln. Muss mit EncryptPassw verschlüsselt worden sein.


{ Datums-/Zeit-Routinen }
function IsLeapYear(AYear: Integer): Boolean;
function DaysPerMonth(AYear, AMonth: Integer): Integer;
function BeginOfYear(D: TDateTime): TDateTime;
function EndOfYear(D: TDateTime): TDateTime;
function BeginOfMonth(D: TDateTime): TDateTime;
function EndOfMonth(D: TDateTime): TDateTime;
function BeginOfWeek(D: TDateTime): TDateTime;
function EndOfWeek(D: TDateTime): TDateTime;
function WeekOfYear(D: TDateTime): Integer;
function DayOfYear(D: TDateTime): Word;
function Seconds(Time: TDateTime): LongInt;
function MilliSeconds (dTime : TDateTime) : Word;
procedure SplitDateToStrings(SplitDate: TDateTime; var Year, Month, Day: String);
function CurrentDayStr: String;
function CurrentMonthStr: String;
function CurrentYearStr: String;
function CurrentDay: Word;
function CurrentMonth: Word;
function CurrentYear: Word;
function DayOfDate(D: TDateTime): Word;
function MonthOfDate(D: TDateTime): Word;
function YearOfDate(D: TDateTime): Word;
function EasterSunday(ADate: TDateTime): TDateTime;
function IncMonth(ADate: TDateTime; Months: Integer): TDateTime;
function DecMonth(ADate: TDateTime; Months: Integer): TDateTime;
function IncYear(ADate: TDateTime; Years: Integer): TDateTime;
function DecYear(ADate: TDateTime; Years: Integer): TDateTime;

function DayNumToDow(DayNum: Integer): TDayOfWeek;
function DowToDayNum(Dow: TDayOfWeek): Integer;
function GetDayOfWeek(ADate: TDateTime): TDayOfWeek;

{ Bit-Manipulation }
function IsBit(const Val: Longint; const TheBit: Byte): Boolean;
function SetBit(const Val: Longint; const TheBit: Byte): LongInt;
function ClearBit(const Val: Longint; const TheBit: Byte): LongInt;
function ToggleBit(const Val: Longint; const TheBit: Byte): LongInt;
function StrIsBit(const Val: String; const TheBit: Byte): Boolean;
procedure StrSetBit(var Val: String; const TheBit: Byte);
procedure StrClearBit(var Val: String; const TheBit: Byte);

{ Min-/Max-Funktionen }
function MaxInteger(Val1, Val2: Integer): Integer;
function MinInteger(Val1, Val2: Integer): Integer;
function MaxLongInt(Val1, Val2: LongInt): LongInt;
function MinLongInt(Val1, Val2: LongInt): LongInt;
function MaxWord(Val1, Val2: Word): Word;
function MinWord(Val1, Val2: Word): Word;
function MaxByte(Val1, Val2: Byte): Byte;
function MinByte(Val1, Val2: Byte): Byte;
function MaxReal(Val1, Val2: Real): Real;
function MinReal(Val1, Val2: Real): Real;

{ Datei- und Verzeichnis-Routinen }
function CreateUniqueFileName(Directory, Prefix, Extension: String): String;
procedure NormalizeFileExtension(var Extension: String);
procedure NormalizeDirectory(var Directory: String);
function AppendPath(Path, Filename: String): String;
function AppendExePath(Filename: String): String;
function AppendExtension(Filename,Extension: String): String;
function BGCopyFile(Source, Dest: String; bFailExists, bMelde: Boolean): Boolean;
function GetFileSize(AFilename: String): LongInt;
function GetFileDate(AFilename: String): TDateTime;
function GetFileAttributes(AFilename: String): TFileAttributes;
function WindowsDirectory: String;
function WindowsSystemDirectory: String;
function CheckFolderExists(Folder : string) : boolean;
function ExtractBaseName  (sInput : string) : string;
function ExtractValidFileName (sInput : string) : string;

function ExpandAdresse(s : string) : string;

{
procedure CopyFileExt(const FileName, Destination: TFileName;
  Append, Melde: Boolean);
}
function ExtractBasePath(const Path: String): String;
function CreateBackupFilename(Filename: String): String;
procedure BackupFile(Filename: String);

{ Maß-Einheiten konvertieren }
function CmToInch(Cm: Extended): Extended;
function InchToCm(Inches: Extended): Extended;
function MmToInch(Mm: Extended): Extended;
function InchToMm(Inches: Extended): Extended;

{ Winkel }
function GradToRad(Grad : Extended) : Extended;
function RadToGrad(Rad : Extended) : Extended;

{ Sonstiges }
procedure SleepSec(Secs: Integer);
procedure Pause(MilliSecs: Integer);
function ByteSizeAsString(Value: Longint): String;
function CommandLineSwitch(const Switch: String): Boolean;
function CommandLineOption(const Switch: String; var Option: String): Boolean;
function CommandLineOptionExt(const Switch: String;
  var Option: String; Charcase: TCharCase): Boolean;
function PruefzifferMod10(Zaehlnummer: String): Integer;

{ Eurofunktionen }
function DM2Euro(DM : Extended) : Extended;
function Euro2DM(Euro : Extended) : Extended;

{ Alter Schrott }
function BGStrToInt(zahl: String): Integer;

{ Programer's Help }
function phAscString(S: String): String;

{System}
function GetWindowsVersion : string;
function IsWindowsNT       : boolean;
function WindowsProductID  : string;
function WindowsOwner      : string;
function CollectPCIdentInfos (sSerial : string) : string;
function VolumeID(DriveChar: Char): string;
function GetIpAddress: string;
function GetComputerNetName: string;

{CRC}
function  StrToCRC        (    In_CRC  : string)  : integer;
function  MAKE_CRCSTR     (    In_CRC  : string)  : string;
function  Prepare_CRCSTR  (    In_CRC  : string)  : string;
procedure InitLookUp      (var LookUp  : TLookUp);

{Table}
function DuplicateTableRecord (Table : TTable) : Boolean;
function FieldTypeToStr (DataType: TFieldType) : string;

{Protokoll}
function GetProt0File: string;
function Prot0(s: string): string;

function GetErr0File: string;
function Err0(s: string): string;


{************************************************************
 *  Variablen
 ************************************************************}
var
{  DateSeparator: Char;
  TimeSeparator: Char;}
  DatePicShort: String;
  DatePicLong: String;
  TimePicShort: String;
  TimePicLong: String;
  DateEpochYear: Word;
  DateEpochBase: Word;
//  WindowsVersion: TWindowsVersion;


{============================================================
 I M P L E M E N T A T I O N
 ============================================================}
implementation


{************************************************************
 *  Uses
 ************************************************************}
uses
 registry,
 FileCtrl,
 BG0005,
 Frm_Spy,
 winsock;

function RTrunc(X: Extended): Int64;
// Workaround für fehlerhalte Trunk Implementierung
begin
  Result := Round(X - 0.5);
end;


function phAscString(S: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + IntToStr(Ord(S[i]))+'/';
end;


{************************************************************
 *  Funktionen und Prozeduren
 ************************************************************}

{-WindowsDirectory-------------------------------------------
  Scope:      Public
  Funktion:   Gibt das Windows-Verzeichnis zurück.
  Anmerkung:  Das Verzeichnis endet immer mit einem Backslash.
 ------------------------------------------------------------}
function WindowsDirectory: String;
var
  Buff: Array[0..256] of Char;
begin
  GetWindowsDirectory(Buff,256);
  Result := StrPas(Buff);
  if Result[Length(Result)] <> '\' then Result := Result + '\';
end;

{-WindowsSystemDirectory-------------------------------------
  Scope:      Public
  Funktion:   Gibt das Windows-System-Verzeichnis zurück.
  Anmerkung:  Das Verzeichnis endet immer mit einem Backslash.
 ------------------------------------------------------------}
function WindowsSystemDirectory: String;
var
  Buff: Array[0..256] of Char;
begin
  GetSystemDirectory(Buff,256);
  Result := StrPas(Buff);
  if Result[Length(Result)] <> '\' then Result := Result + '\';
end;


{--------------------------------------------------------------------------------------------------}
function CheckFolderExists(Folder : string) : boolean;
{--------------------------------------------------------------------------------------------------}
// ist der Dateiordner vorhanden
var
 SearchRec : TSearchRec;
 ch        : char;
begin
 Folder := Alltrim(Folder);
 if Length(Folder) = 0 then
  begin
   Result := false;
   exit;
  end;
 ch := Folder[Length(Folder)];
 if ch = '\' then Folder := Folder + '*';
 if FindFirst(Folder,faAnyFile,SearchRec) = 0 then
  Result := true
 else
  Result := false;
 Sysutils.FindClose(SearchRec);
end;

{--------------------------------------------------------------------------------------------------}
function ExtractBaseName (sInput : string) : string;
{--------------------------------------------------------------------------------------------------}
// Separiert aus dem übergebenen String den Filenamen ohne Extension. Fehlt diese, dann wird der
// String auf jeden Fall auf die Länge MaxFileNameChar begrenzt
// umgebaut auf Win95; es sind auch lange File-Namen zulässig
// Der Anwender muß dafür Sorge tragen daß nur der Filename übergeben wird, nicht jedoch der
// komplette Pfad mit übergeben wird. Ansonsten wird nicht nur der File-Name ohne Extension
// übergeben, sondern auch der Pfad bis dahin.
// BSP.: Übergeben : Mask12.tol
//       zurück: Maske12
//       d:\aqsd\data\maske12.tol  zurück: d:\aqsd\data\maske12
const
 ciMaxExtLen = 3;
var
 p, l     : word;
begin
 p := length (sInput);
 l := length (ExtractFileExt (sInput));
 if p > 0 then Result := copy (sInput, 1, (p - l))
          else Result := copy (sInput, 1, ciMaxExtLen);
end;

{--------------------------------------------------------------------------------------------------}
function ExtractValidFileName (sInput : string) : string;
{--------------------------------------------------------------------------------------------------}
// Bildet aus dem übergebenen String gültigen FileName
// File muss ohne Extension und Pfad übergeben werden
var
  s: string;
  i, iCnt: integer;
  sDate, sTime: string;
begin
  s := '';
  iCnt := 0;
  sInput := UpperCase(sInput);
  for i := 1 to Length(sInput) do
  begin
    if sInput[I] in ['0'..'9', 'A'..'Z'] then
    begin
      s := s + sInput[I];
      inc(iCnt);
    end
  end;
  if iCnt = 0 then
  begin
    sDate := DateToStrSQL(Date); //Datum "JJJJMMTT"
    sTime := TimeToStrSQL(Time); //Zeitstring "HHMMSS"
    Result := sDate + '_' + sTime;
  end;
  Result := s;
end;

{-StringToDigits---------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Entfernt alle nicht-numerischen Zeichen aus
              einem String.
 ------------------------------------------------------------}
function StringToDigits(const S: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
   begin
    if i = 0 then
     begin
      if S[I] in ['0'..'9', '-', DecimalSeparator] then Result := Result + S[I];
     end
    else
     begin
      if S[I] in ['0'..'9', DecimalSeparator] then Result := Result + S[I];
     end;
   end;
end;

{-DelSpace---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Entfernt Leerzeichen aus einem String.
 ------------------------------------------------------------}
function DelSpace(const S: String): String;
begin
  Result := DelChars(S, ' ');
end;

{-DelChars---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Entfernt Zeichen aus einem String.
 ------------------------------------------------------------}
function DelChars(const S: String; Chr: Char): String;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do
    begin
      if Result[I] = Chr then Delete(Result, I, 1);
    end;
end;

{-FillRight--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Normiert einen String auf eine bestimmte Länge
              und fügt ggf. Füllzeichen an.
 ------------------------------------------------------------}
function FillRight(cString: String; nLen: Integer; cChar: Char): String;
begin
  if (Length(cString) <> nLen) then
    begin
      if Length(cString) > nLen then
        Result := Copy(cString,1,nLen)
      else
        Result := cString + Replicate(cChar,nLen-Length(cString));
    end
  else
    Result := cString;
end;

{-FillLeft---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Normiert einen String auf eine bestimmte Länge
              und fügt ggf. Füllzeichen an.
 ------------------------------------------------------------}
function FillLeft(cString: String; nLen: Integer; cChar: Char): String;
begin
  if (Length(cString) <> nLen) then
    if Length(cString) > nLen then
      Result := Copy(cString,Length(cString)-nLen,nLen)
    else
      Result := Replicate(cChar,nLen-Length(cString)) + cString
  else
    Result := cString;
end;

{-CharCount--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Ermittelt wie oft ein Zeichen in einem String
              vorkommt.
 ------------------------------------------------------------}
function CharCount(const S: String; C: Char): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    if S[I] = C then Inc(Result);
end;

{-TurnString-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt den String rückwärts wieder aus
 ------------------------------------------------------------}
function TurnString(cString: String): String;
var
 i : integer;
 s : string;
begin
 Result := '';
 if Alltrim(cString) = '' then exit;
 s := '';
 for i := Length(cString) downto 1 do
  begin
   s := s + cString[i];
  end;
 Result := s;
end;

{-TurnPlaces-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   vertauscht 2 Characters im String
 ------------------------------------------------------------}
function TurnPlaces(cString: String; Pos1, Pos2 : integer): String;
var
 i : integer;
 ch1 : Char;
 ch2 : Char;
begin
 Result := cString;
 if Alltrim(cString) = '' then exit;
 if (Pos1 < 0) or (Pos2 < 0) or (Pos1 > Length(cString)) or (Pos2 > Length(cString)) then exit;
 ch1 := cString[Pos1];
 ch2 := cString[Pos2];
 cString[Pos1] := ch2;
 cString[Pos2] := ch1;
 Result := cString;
end;

{-AddSigns-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Addiert i Ascii-Zeichen dazu
 ------------------------------------------------------------}
function AddSigns (cString: String; iAdd : integer): String;
var
 i : integer;
begin
 Result := cString;
 if Alltrim(cString) = '' then exit;
 for i := 1 to Length (cString) do cString[i] := Chr( Ord (cString[i]) + iAdd);
 Result := cString;
end;

{--------------------------------------------------------------------------------------------------}
function StripSign (sInput : string; cSign : char) : string;
{--------------------------------------------------------------------------------------------------}
//Entfernt aus sInput alle Vorkommen von cSign.
var p      : word;
    sDummy : string;
begin
 sDummy := sInput;
 repeat
  p := pos (cSign, sDummy);
  if p > 0 then delete (sDummy, p, 1)
 until p = 0;
 Result := sDummy;
end;

{--------------------------------------------------------------------------------------------------}
function ReplaceWildCards(sSource : string; iNo : integer; cArgChar : char) : string;
{--------------------------------------------------------------------------------------------------}
// übergebene Seriennummer an Platzhalterstelle ### einsetzen
// dabei wird die Länge normiert und die Nummer eventuell links mit Nullen gefüllt
// wir beachten dabei nur das erste Auftreten von ####
var
 iStart, iStop   : integer;
 iWildCardLength : integer;
 i               : integer;
 bHit            : Boolean;
 sNew            : string;
 sLeftPart       : string;
 sRightPart      : string;
begin
 iStart := pos (cArgChar, sSource); iStop := 0;                                                    // der erste #
 if (trim (sSource) <> '') and (iStart > 0)
  then begin                                                                                        // es gibt was zu ersetzen
        sLeftPart := copy (sSource, 1, pred (iStart));
        iStop := iStart; bHit := false;
        while not bHit and (iStop <= length (sSource)) do begin
         if (sSource [iStop] = cArgChar) then inc (iStop)                                          //Das Ende des zu erstzenden Blocks suchen
                                         else bHit := true;
        end;
        sRightPart := copy (sSource, iStop, length (sSource));
        iWildCardLength := iStop - iStart;                                                          // Länge ###
        sNew := FillWithZero (IntToStr (iNo), iWildCardLength);                                     // ### als ersetzter Nummernstring
        Result := sLeftPart + sNew + sRightPart;
       end
  else Result := sSource;                                                                           // kein Platzhalter da
end;

{---------------------------------------------}
function BuildLine(s, sDetail, AusR: string; iPos1, iPos2: integer) : string;
{---------------------------------------------}
//Zeile zusammenbauen
//erlaubte AusR: L=Linksbündig, R=Rechtsbündig, 0=mit Nullen aufgefüllt
var
  s1, s2: string;
  iIns: integer;
begin
  if (iPos1 > 0) and (iPos2 > 0) then
  begin//es sind Spalten angegeben
    if iPos2 >= iPos1 then
    begin
      while Length(s) < iPos2 do
        s := PadRight(s, iPos2); //verlängern bis Stringlänge passt
      iIns := iPos2 - iPos1 + 1;
      AusR := UpperCase(AusR[1]);
      if AusR = 'L' then
        sDetail := PadRight(sDetail, iIns)
      else
        if AusR = 'R' then
          sDetail := PadLeft(sDetail, iIns)
        else
          if AusR = '0' then
            sDetail := FillWithZero(sDetail, iIns)
          else begin
            //todo: Fehler
          end;
      s1 := Copy(s, 1, iPos1-1);
      s2 := Copy(s, iPos2+1, Length(s));
      Result := s1 + sDetail + s2;
    end else
    begin
      //todo: Fehler
    end;
  end else
    Result := s;
end;


{---------------------------------------------}
function BuildLineExt(sTrans, s, sDetail, AusR: string; iPos1, iPos2: integer) : string;
{---------------------------------------------}
//Zeile zusammenbauen
//erlaubte AusR: L=Linksbündig, R=Rechtsbündig, 0=mit Nullen aufgefüllt
var
  s1, s2: string;
  iIns: integer;
begin
  if (iPos1 > 0) and (iPos2 > 0) then
  begin//es sind Spalten angegeben
    if iPos2 >= iPos1 then
    begin
      while Length(s) < iPos2 do
        s := PadRight(s, iPos2); //verlängern bis Stringlänge passt
      iIns := iPos2 - iPos1 + 1;
      AusR := UpperCase(AusR[1]);
      sDetail := GetTokenValueFromLine(sTrans, sDetail); //EditFeld + was soll trnsformiert werden
      if AusR = 'L' then
        sDetail := PadRight(sDetail, iIns)
      else
        if AusR = 'R' then
          sDetail := PadLeft(sDetail, iIns)
        else
          if AusR = '0' then
            sDetail := FillWithZero(sDetail, iIns)
          else begin
            //todo: Fehler
          end;
      s1 := Copy(s, 1, iPos1-1);
      s2 := Copy(s, iPos2+1, Length(s));
      Result := s1 + sDetail + s2;
    end else
    begin
      //todo: Fehler
    end;
  end else
    Result := s;
end;


{-RomanToInt-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert einen römischen Ziffernstring in
              einen Integerwert.
 ------------------------------------------------------------}
function RomanToInt(const S: String): Longint;
const
  RomanChars = ['C','D','I','L','M','V','X'];
  RomanValues: array['C'..'X'] of Word =
    (100,500,0,0,0,0,1,0,0,50,1000,0,0,0,0,0,0,0,0,5,0,10);
var
  Index, Next: Char;
  I: Integer;
  Negative: Boolean;
begin
  Result := 0;
  I := 0;
  Negative := (Length(S) > 0) and (S[1] = '-');
  if Negative then Inc(I);
  while (I < Length(S)) do
    begin
      Inc(I);
      Index := UpCase(S[I]);
      if Index in RomanChars then
        begin
          if Succ(I) <= Length(S) then
            Next := UpCase(S[I + 1])
          else
            Next := #0;
          if (Next in RomanChars) and (RomanValues[Index] < RomanValues[Next]) then
            begin
              Inc(Result, RomanValues[Next]);
              Dec(Result, RomanValues[Index]);
              Inc(I);
            end
          else
            Inc(Result, RomanValues[Index]);
        end
      else
        begin
          Result := 0;
          Exit;
        end;
    end;
  if Negative then Result := -Result;
end;

{-IntToRoman-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert einen Integerwert in einen
              römischen Ziffernstring.
 ------------------------------------------------------------}
function IntToRoman(Value: Longint): String;
Label
  A500, A400, A100, A90, A50, A40, A10, A9, A5, A4, A1;
begin
  Result := '';
{$IFNDEF WIN32}
  if (Value > MaxInt * 2) then Exit;
{$ENDIF}
  while Value >= 1000 do
    begin
      Dec(Value, 1000); Result := Result + 'M';
    end;
  if Value < 900 then
    goto A500
  else
    begin
      Dec(Value, 900); Result := Result + 'CM';
    end;
  goto A90;
A400:
  if Value < 400 then
    goto A100
  else
    begin
      Dec(Value, 400); Result := Result + 'CD';
    end;
  goto A90;
A500:
  if Value < 500 then
    goto A400
  else
    begin
      Dec(Value, 500); Result := Result + 'D';
    end;
A100:
  while Value >= 100 do
    begin
      Dec(Value, 100); Result := Result + 'C';
    end;
A90:
  if Value < 90 then
    goto A50
  else
    begin
      Dec(Value, 90); Result := Result + 'XC';
    end;
  goto A9;
A40:
  if Value < 40 then
    goto A10
  else
    begin
      Dec(Value, 40); Result := Result + 'XL';
    end;
  goto A9;
A50:
  if Value < 50 then
    goto A40
  else
    begin
      Dec(Value, 50); Result := Result + 'L';
    end;
A10:
  while Value >= 10 do
    begin
      Dec(Value, 10); Result := Result + 'X';
    end;
A9:
  if Value < 9 then
    goto A5
  else
    begin
      Result := Result + 'IX';
    end;
  Exit;
A4:
  if Value < 4 then
    goto A1
  else
    begin
      Result := Result + 'IV';
    end;
  Exit;
A5:
  if Value < 5 then
    goto A4
  else
    begin
      Dec(Value, 5); Result := Result + 'V';
    end;
  goto A1;
A1:
  while Value >= 1 do
    begin
      Dec(Value); Result := Result + 'I';
    end;
end;

{-DayNumToDow------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt Integer in TDayOfWeek.
 ------------------------------------------------------------}
function DayNumToDow(DayNum: Integer): TDayOfWeek;
begin
  case DayNum of
    1:  Result := dowSunday;
    2:  Result := dowMonday;
    3:  Result := dowTuesday;
    4:  Result := dowWednesday;
    5:  Result := dowThursday;
    6:  Result := dowFriday;
    7:  Result := dowSaturday;
  end;
end;

{-GetDayOfWeek-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt den Wochentag eines TDateTime-Wertes
              zurück.
 ------------------------------------------------------------}
function GetDayOfWeek(ADate: TDateTime): TDayOfWeek;
begin
  case DayOfWeek(ADate) of
    1:  Result := dowSunday;
    2:  Result := dowMonday;
    3:  Result := dowTuesday;
    4:  Result := dowWednesday;
    5:  Result := dowThursday;
    6:  Result := dowFriday;
    7:  Result := dowSaturday;
  end;
end;

{-DowToDayNum------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt TDayOfWeek in Integer.
 ------------------------------------------------------------}
function DowToDayNum(Dow: TDayOfWeek): Integer;
begin
  case Dow of
    dowMonday:    Result := 2;
    dowTuesday:   Result := 3;
    dowWednesday: Result := 4;
    dowThursday:  Result := 5;
    dowFriday:    Result := 6;
    dowSaturday:  Result := 7;
    dowSunday:    Result := 1;
  end;
end;

{-LocalFileName----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Formatiert einen absoluten Dateinamen mit
              den Macros.
 ------------------------------------------------------------}
function LocalFileName(const FileName: String): String;
var
  S1,S2: String;
begin
  Result := FileName;
  S1 := AnsiUpperCase(FileName);
  S2 := ExtractFilePath(AnsiUpperCase(Application.ExeName));
  if S2[Length(S2)] <> '\' then S2 := S2 + '\';

  if Copy(S1,1,Length(S2)) = S2 then
    Result := '%PROGPATH%'+RestStr(S1,Length(S2))
end;

{-ReplaceMakro-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Ersetzt den Makroplatzhalter durch den
              übergebenen Wert.
 ------------------------------------------------------------}
function ReplaceMacro(const S, Makro, Replace: String): String;
var
  P: Integer;
begin
  Result := S;
  P := Pos(UpperCase(Makro), UpperCase(Result));
  while P > 0 do
    begin
      Result := LeftStr(Result,P-1)+Replace+RestStr(Result,P+Length(Makro));
      P := Pos(UpperCase(Makro), UpperCase(Result));
    end;
end;

{-ExpandMacroString------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Expandiert Macros in einem String.
  Anmerkung:  Es werden folgend Makros expandiert:
                %PROGPATH%    Verzeichnis in dem sich das
                              akt. Programm befindet
                %PROGDRIVE%   Laufwerk auf dem sich das
                              akt. Programm befindet
                %WINPATH%     Windows-Verzeichnis
                %WINSYSPATH%  Windows-System-Verzeichnis
              Außerdem werden alle DOS-Umgebungs-Variablen
              mit ihren Werten ersetzt.
  Hinweis:    Alle o.a. Pfade enthalten keinen abschließenden
              Backslash. Wenn also ein Dateiname aus einem
              Makro für den Pfad gebastelt werden soll, muß
              folgendes Format verwendet werden:
                %PROGPATH%\DUMMY.DAT
              Alternativ kann natürlich auch die Funktion
              AppendPath() verwendet werden.
              Laufwerke bestehen immer aus dem Laufwerksbuch-
              staben und einem Doppelpunkt.
 ------------------------------------------------------------}
function ExpandMacroString(Value: String): String;

  {-CutTrailingBackSlash-------------------------------------
    Parameter:  siehe Deklaration
    Scope:      Inline
    Funktion:   Enfernt abschließende Backslashes.
   ----------------------------------------------------------}
  function CutTrailingBackSlash(S: String): String;
  begin
    if RightStr(S,1) = '\' then
      Result := LeftStr(S,Length(S)-1)
    else
      Result := S;
  end;

const
  BasisVerz         = '%BASEPATH%';     { Übergeordnetes Programm-Verzeichnis }
  Exename           = '%EXENAME%';      { Name der Exedatei (ohne Pfad) }
  Modulename        = '%MODULENAME%';   { Name des Moduls (Exname ohne Ext.) }
  ProgrammVerz      = '%PROGPATH%';     { Programm-Verzeichnis "C:\APP" }
  ProgrammLw        = '%PROGDRIVE%';    { Programm-Laufwerk "C:" }
  WindowsLw         = '%WINDRIVE%';     { Windows-Laufwerk "C:" }
  WindowsVerz       = '%WINPATH%';      { Windows-Verzeichnis "C:\WINDOWS" }
  WindowsSystemVerz = '%WINSYSPATH%';   { Windows-System-Verzeichnis
                                          "C:\WINDOWS\SYSTEM" }
var
  S: String;
  I: Integer;
  Buff: Array[0..256] of Char;
begin
  if Pos('%',Value) > 0 then
    begin
      { %BASE% }
      Value := ReplaceMacro(Value,BasisVerz,
        CutTrailingBackSlash(ExtractBasePath(ExtractFilePath(Application.ExeName))));
      { %PROGPATH% }
      Value := ReplaceMacro(Value,ProgrammVerz,
        CutTrailingBackSlash(ExtractFilePath(Application.ExeName)));
      { %PROGDRIVE% }
      Value := ReplaceMacro(Value,ProgrammLw,LeftStr(ExtractFilePath(Application.ExeName),2));
      { %WINPATH% und %WINDRIVE% }
      GetWindowsDirectory(Buff,256);
      Value := ReplaceMacro(Value,WindowsLw,Buff[0]+':');
      Value := ReplaceMacro(Value,WindowsVerz,CutTrailingBackSlash(StrPas(Buff)));
      { %WINSYSPATH% }
      GetSystemDirectory(Buff,256);
      Value := ReplaceMacro(Value,WindowsSystemVerz,CutTrailingBackSlash(StrPas(Buff)));

      { %EXENAME% }
      Value := ReplaceMacro(Value,Exename,ExtractFileName(Application.ExeName));
      { %MODULENAME% }
      S := ExtractFileName(Application.ExeName);
      S := LeftStr(S,Pos('.',S)-1);
      Value := ReplaceMacro(Value,ModuleName,S);

    end;
  Result := Value;
end;

{-CompareStringsOld---------------------------------------------
  Parameter:  S1, S2: die zu vergleichenden Strings
              Options:
                csCaseSensitive: Groß-/Klein beachten
                csPartialAnyWhere:
                csPartialFromLeft:
                csPartialFromRight:
  Scope:      Public
  Funktion:   Vergleicht zwei Strings.
  Rückgabe:   csDifferent: die Strings unterscheiden sich
              csExactMatch: die Strings sind gleich
              csFirstContainsSecond: der erste String enthält
                mit den zweiten
              csSecondContainsFirst: der zweite String ent-
                hält den ersten
 ------------------------------------------------------------}
function CompareStringsOld(S1, S2: String;
  Options: TCompareStringOptions): TCompareStringResult;
type
  TWildcardType = (wcNoWildcards, wcBeginsWith,
    wcEndsWith, wcContains, wcError);

  function StringContainsJokers(const S: String): Boolean;
  begin
    Result := ((Pos('*',S) > 0) or (Pos('?',S) > 0));
  end;

  function WildcardType(var S: String): TWildcardType;
  var
    P: Integer;
  begin
    P := Pos('*',S);
    if P = 1 then
      begin
        if S[Length(S)] = '*' then
          begin
            Result := wcContains;
            S := Copy(S,2,Length(S)-2);
          end
        else
          begin
            Result := wcEndsWith;
            S := Copy(S,2,Length(S)-1);
          end;
      end
    else if P = Length(S) then
      begin
        Result := wcBeginsWith;
        S := Copy(S,1,Length(S)-1);
      end
    else if P > 0 then
      begin
        { Ein Stern mittendrin ist Scheiße }
        Result := wcError;
      end
    else
      begin
        Result := wcNoWildcards;
      end;
  end;

begin
  Result := csDifferent;

  { Groß-/Kleinschreibung nicht beachten
    -> alles in Großbuchstaben konvertieren }
  if not (csCaseSensitive in Options) then
    begin
      S1 := AnsiUpperCase(S1);
      S2 := AnsiUpperCase(S2);
    end;

  if Length(S1) = Length(S2) then
    begin
      { gleiche Längen }
      if S1 = S2 then Result := csExactMatch
    end
  else if Length(S1) > Length(S2) then
    begin
      { S1 länger als S2 }
      if csPartialFromLeft in Options then
        begin
          if LeftStr(S1,Length(S2)) = S2 then
            Result := csFirstContainsSecond;
        end;
      if csPartialFromRight in Options then
        begin
          if RightStr(S1,Length(S2)) = S2 then
            Result := csFirstContainsSecond;
        end;
      if csPartialAnyWhere in Options then
        begin
          if Pos(S2,S1) > 0 then
            Result := csFirstContainsSecond;
        end;
    end
  else
    begin
      { S2 länger als S1 }
      if csPartialFromLeft in Options then
        begin
          if LeftStr(S2,Length(S1)) = S1 then
            Result := csSecondContainsFirst;
        end;
      if csPartialFromRight in Options then
        begin
          if RightStr(S2,Length(S1)) = S1 then
            Result := csSecondContainsFirst;
        end;
      if csPartialAnyWhere in Options then
        begin
          if Pos(S1,S2) > 0 then
            Result := csSecondContainsFirst;
        end;
    end;
  if (Result = csDifferent) and (csAllowWildcards in Options) then
    begin
      if StringContainsJokers(S1) then
        begin
          case WildcardType(S1) of
            wcBeginsWith:
              if S1 = LeftStr(S2,Length(S1)) then
                Result := csMatchesWildcards;
            wcEndsWith:
              if S1 = RightStr(S2,Length(S1)) then
                Result := csMatchesWildcards;
            wcContains:
              if Pos(S1,S2) > 0 then
                Result := csMatchesWildcards;
            {wcNoWildcards:
            wcError:}
          end;
        end
      else if StringContainsJokers(S2) then
        begin
          case WildcardType(S2) of
            wcBeginsWith:
              if S2 = LeftStr(S1,Length(S2)) then
                Result := csMatchesWildcards;
            wcEndsWith:
              if S2 = RightStr(S1,Length(S2)) then
                Result := csMatchesWildcards;
            wcContains:
              if Pos(S2,S1) > 0 then
                Result := csMatchesWildcards;
            {wcNoWildcards:
            wcError:}
          end;
        end;
    end;
end;


{--------------------------------------------------------------------------------------------------}
function CompareStrings (sSource : string; sDest : string) : boolean;
{--------------------------------------------------------------------------------------------------}
{sSource ist der Teilstring der innerhalb sDest gesucht werden soll. Beispiel:
 ABC  = Beide Strings müssen genau übereinstimmen
 ABC* = Sucht ab dem Beginn von sDest den Teilstring ABC, der Rest ist egal
 *ABC = Sucht den Teilstring ABC am Ende von sDest, die davor liegenden Zeichen sind egal
 *ABC*= Sucht den Teilstring ABC innerhalb von sDest unabhängig von der Position
 **A, *, **  = Ergibt immer true}
var iWildCharCnt : integer;
    i            : integer;
    aWildCharPos : array [1..2] of word;
    sTmpSrc      : string;
begin
 Result := false;
 iWildCharCnt := 0; i := 1; sTmpSrc := '';
 while (iWildCharCnt < 2) and (i <= length (sSource)) do begin
  if sSource [i] = ccWildChar then begin                                                            {Wenn WildCard, dann zählen}
                                    inc (iWildCharCnt);
                                    aWildCharPos [iWildCharCnt] := i;                               {und die Pos im String merken}
                                   end
                              else sTmpSrc := sTmpSrc + sSource [i];                                {Teilstring ohne WildCards aufbauen}
  inc (i);
 end;
 case iWildCharCnt of
//  0 : Result := sTmpSrc = copy (sDest, 1, length (sTmpSrc));                                      {Genau vergleichen}
  0 : Result := sTmpSrc = sDest;                                                                    {Genau vergleichen}
  1 : if sTmpSrc = '' then Result := true                                                           {Falls nur * eingegeben wurde}
                      else if (aWildCharPos [1] = length (sSource))
                            then begin                                                              {Filter ist ABC*}
                                  Result := sTmpSrc = copy (sDest, 1, length (sTmpSrc));
                                 end
                            else begin                                                              {Filter ist *ABC}
                                  Result := sTmpSrc = copy (sDest, length (sDest) - length (sTmpSrc) + 1, length (sTmpSrc));
                                 end;
  2 : if sTmpSrc = '' then Result := true                                                           {Falls nur ** eingegeben wurde}
                      else Result := pos (sTmpSrc, sDest) > 0;                                      {Teilstring irgendwo gefunden}
 end;
end;



{-SameString-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Vergleicht zwei Strings.
 ------------------------------------------------------------}
function SameString(const S1, S2: String): Boolean;
begin
  Result := AnsiUpperCase(Trim(S1)) = AnsiUpperCase(Trim(S2));
end;

{-SameStringAllTrim------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Vergleicht zwei Strings.
 ------------------------------------------------------------}
function SameStringAllTrim(const S1, S2: String): Boolean;
begin
  Result := (AllTrim(S1) = AllTrim(S2));
end;

{-SameStringWithOutSpaces------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Vergleicht zwei Strings ohne Leerzeichen.
 ------------------------------------------------------------}
function SameStringWithOutSpaces(const S1, S2: String): Boolean;
begin
  Result := AnsiUpperCase(DelSpace(S1)) = AnsiUpperCase(DelSpace(S2));
end;

{-ResString--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Lädt einen Resourcen-String.
 ------------------------------------------------------------}
function ResString(ID: Word): String;
var
  Buff: Array[0..256] of Char;
begin
  LoadString(hInstance,ID,Buff,256);
  Result := StrPas(Buff);
end;

{-ResFmtString-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Lädt einen Resourcen-String.
 ------------------------------------------------------------}
function ResFmtString(ID: Word; const Args: array of const): String;
var
  Buff: Array[0..256] of Char;
begin
  LoadString(hInstance,ID,Buff,256);
  Result := Format(StrPas(Buff),Args);
end;


{-AddStringToPChar-------------------------------------------}
procedure AddStringToPChar(var Source: PChar; Add: String);
begin
  Add := Add+#0;
  AddPCharToPChar(Source,@Add[1]);
end;

{-AddPCharToPChar--------------------------------------------}
procedure AddPCharToPChar(var Source: PChar; Add: PChar);
begin
  {
  Source := ReAllocMem(Source, StrLen(Source)+1, StrLen(Source)+StrLen(Add)+1);
  Source := StrCat(Source,Add);
  }
end;

{-StringToAlignment------------------------------------------}
function StringToAlignment(Typ: String): TAlignment;
begin
  Typ := UpperCase(Typ);
  case Typ[1] of
    'L': Result := taLeftJustify;
    'R': Result := taRightJustify;
    'C': Result := taCenter;
  else
    Result := taLeftJustify;
  end;
end;

{-AlignmentToString------------------------------------------}
function AlignmentToString(Typ: TAlignment): String;
begin
  case Typ of
    taLeftJustify:    Result := 'L';
    taRightJustify:   Result := 'R';
    taCenter:         Result := 'C';
  else
    Result := 'L';
  end;
end;

{-Token------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Liefert das erste Token eines Strings.
 ------------------------------------------------------------}
function Token(var S: String; Seperator: Char): String;
var
  I: Word;
begin
  I := Pos(Seperator,S);
  if I <> 0 then
    begin
      Result := System.Copy(S,1,I-1);
      System.Delete(S,1,I);
    end
  else
    begin
      Result := S;
      S := '';
    end;
end;

{-TokenStr------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Liefert das erste Token eines Strings.
 ------------------------------------------------------------}
function TokenStr(var S: String; Seperator: string): String;
var
  I, iLen: Word;
begin
  I := Pos(Seperator,S);
  iLen := Length(Seperator);
  if I <> 0 then
    begin
      Result := System.Copy(S,1,I-1);
      System.Delete(S,1,I+iLen-1);
    end
  else
    begin
      Result := S;
      S := '';
    end;
end;

{-TokenCount-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Zählt die Token eines Strings.
 ------------------------------------------------------------}
function TokenCount(S: String; Seperator: Char): Integer;
begin
  Result := 0;
  while Token(S,Seperator) <> '' do Inc(Result);
end;

{-TokenAt----------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Ermittelt ein bestimmtes Token.
 ------------------------------------------------------------}
function TokenAt(const S: String; Seperator: Char; At: Integer): String;
var
  j,i: Integer;
begin
  Result := '';
  j := 1;
  i := 0;
  while (i <= At) and (j <= Length(S)) do
    begin
      if S[j] = Seperator then
        Inc(i)
      else if i = At then
        Result := Result+S[j];
      Inc(j);
    end;
end;

{-TokenToStrings---------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Token-String in eine Stringliste.
 ------------------------------------------------------------}
procedure TokenToStrings(S: String; Seperator: Char; List: TStrings);
var
  Tok: String;
begin
  List.Clear;
  Tok := Token(S,Seperator);
  while Tok <> '' do
    begin
      List.Add(Tok);
      Tok := Token(S,Seperator);
    end;
end;

{-TokenToIntArray--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen aus Ziffern bestehenden Token-
              String in ein Integer-Array.
 ------------------------------------------------------------}
(*
procedure TokenToIntArray(S: String; Seperator: Char; List: TIntegerArray);
var
  Tok: String;
begin
  List.Clear;
  Tok := AllTrim(Token(S,Seperator));
  while Tok <> '' do
    begin
      List.Add(StringToInteger(Tok,0));
      Tok := AllTrim(Token(S,Seperator));
    end;
end;
*)
{-TokenFromStrings-------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt eine Stringliste in einen Token-String.
 ------------------------------------------------------------}
function TokenFromStrings(Seperator: Char; List: TStrings): String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to List.Count-1 do
    if Result <> '' then
      Result := Result+Seperator+List[i]
    else
      Result := List[i];
end;

{--------------------------------------------------------------------------------------------------}
function GetTokenValueFromLine(sLine, sIdent: string): string;
{--------------------------------------------------------------------------------------------------}
//aus der Liste sIdent1=sValue1;sIdent3=sValue2;sIdent3=sValue3;...
//den Value zu Ident extrahieren
var
  List: TStringList;
  sValueList, sIdentList: string;
  i: integer;
begin
  sLine := Trim(UpperCase(sLine));
  if (sLine <> '') then
  begin
    List := TStringList.Create;
    TokenToStrings(sLine, ';', List);
    if List.Count > 0 then
    begin
      Result := '';
      for i := 0 to List.Count-1 do
      begin
        sIdentList := Trim(UpperCase(GetIdent(List.Strings[i])));
        sValueList := GetValue(List.Strings[i]);
        if sIdentList = sIdent then
        begin
          Result := sValueList;
          break;
        end;
      end;
    end else
      Result := sLine;
    List.Free;
  end else
    Result := '';
end;

{--------------------------------------------------------------------------------------------------}
function GetTokenIdentFromLine(sLine, sValue: string): string;
{--------------------------------------------------------------------------------------------------}
//aus der Liste sIdent1=sValue1;sIdent3=sValue2;sIdent3=sValue3;...
//den Ident zu Value extrahieren
var
  List: TStringList;
  sValueList, sIdentList: string;
  i: integer;
begin
  sLine := Trim(UpperCase(sLine));
  if (sLine <> '') then
  begin
    List := TStringList.Create;
    TokenToStrings(sLine, ';', List);
    if List.Count > 0 then
    begin
      Result := '';
      for i := 0 to List.Count-1 do
      begin
        sIdentList := GetIdent(List.Strings[i]);
        sValueList := Trim(UpperCase(GetValue(List.Strings[i])));
        if sValue = sValueList then
        begin
          Result := sIdentList;
          break;
        end;
      end;
    end else
      Result := sLine;
    List.Free;
  end else
    Result := '';
end;



{-GetIdent-------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   aus Ident=Value then Ident zurückgeben
 ------------------------------------------------------------}
function GetIdent(s: String): string;
var
  iSep: integer;
begin
  iSep := Pos('=', s);
  if iSep > 0 then
    Result := Copy(s, 1, iSep-1)
  else
    Result := s;
end;

 {-GetValue-------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   aus Ident=Value then Value zurückgeben
 ------------------------------------------------------------}
function GetValue(s: String): string;
var
   iSep: integer;
begin
  iSep := Pos('=', s);
  if iSep > 0 then
    Result := Copy(s, iSep+1, Length(s))
  else
    Result := '';
end;


{-IntPower---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Base ^ Exponent.
 ------------------------------------------------------------}
function IntPower(Base,Exponent: Integer): LongInt;
var
  I: Word;
begin
  Result := 1;
  for I := 1 to Exponent do Result := Result*Base;
end;

{-HexToInt---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Hex-String in Longinteger. Umkehrfunktion zu
              IntToHex (Unit SysUtils).
  Anmerkung:  Es werden Hex-Strings bis max. 8 Zeichen
              konvertiert (00000000..FFFFFFFF).
 ------------------------------------------------------------}
function HexToInt(const Hex: String): LongInt;
var
  I: Integer;
begin
  Result := 0;
  if Length(Hex) in [1..8] then
    begin
      for I := 1 to Length(Hex) do
        case Hex[I] of
          '1'..'9':
            begin
              if I = Length(Hex) then
                Result := Result + LongInt(Ord(Hex[I])-48)
              else
                Result := Result +
                  LongInt( LongInt(Ord(Hex[I])-48) shl LongInt(4*(Length(Hex)-I)) );
              end;
            'A'..'F':
              begin
                if I = Length(Hex) then
                  Result := Result + LongInt(Ord(Hex[I])-55)
                else
                  Result := Result +
                    LongInt( LongInt(Ord(Hex[I])-55) shl LongInt(4*(Length(Hex)-I)) );
              end;
            'a'..'f':
              begin
                if I = Length(Hex) then
                  Result := Result + LongInt(Ord(Hex[I])-87)
                else
                  Result := Result +
                    LongInt( LongInt(Ord(Hex[I])-87) shl LongInt(4*(Length(Hex)-I)) );
              end;
        end;
    end;
end;

(*
{-HexToBin---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert einen Hex-Puffer in einen binären
              Puffer.
 ------------------------------------------------------------}
procedure HexToBin(Hex, Bin: PChar);
var
  B1: PByte;
  Count: Byte;
  S: String;
begin
  B1 := @Hex;
  Count := 0;
  while Size > 0 do
    begin
      S := B1^[Count*2]+B1^[Count*2+1];
      Bin[Count] := Char(HexToInt(S));
      Dec(Size);
      Inc(Count);
      Inc(B1);
    end;
end;

{-BinToHex---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert einen binären Puffer in einen Hex-
              Puffer.
 ------------------------------------------------------------}
procedure BinToHex(Bin, Hex: PChar);
const
  HexDigit: String[16] = '0123456789ABCDEF';
var
  B1: PByte;
  Count: Byte;
begin
  B1 := @Bin;
  Count := 0;
  while Size > 0 do
    begin
      Hex[Count*2] := HexDigit[B1^ div 16 + 1];
      Hex[Count*2+1] := HexDigit[B1^ mod 16 + 1];
      Dec(Size);
      Inc(Count);
      Inc(B1);
    end;
end;
*)

{-CmToInch---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Rechnet Centimeter in Inches um.
 ------------------------------------------------------------}
function CmToInch(Cm: Extended): Extended;
begin
  Result := (Cm * 0.3937);
end;

{-InchToCm---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Rechnet Inches in Centimeter um.
 ------------------------------------------------------------}
function InchToCm(Inches: Extended): Extended;
begin
  Result := (Inches * 2.54000508);
end;

{-MmToInch---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Rechnet Millimeter in Inches um.
 ------------------------------------------------------------}
function MmToInch(Mm: Extended): Extended;
begin
  Result := (Mm * 0.03937);
end;

{-InchToMm---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Rechnet Inches in Millimeter um.
 ------------------------------------------------------------}
function InchToMm(Inches: Extended): Extended;
begin
  Result := (Inches * 25.4000508);
end;

{-GradToRad--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Rechnet Altgrad in Rad um.
  // 03.08.2000 BG korrigiert diesen Schwachsinn
 ------------------------------------------------------------}
function GradToRad(Grad : Extended) : Extended;
begin
  //Result := (Grad * 180 / Pi);
  Result := (Grad * Pi / 180);
end;

{-RadToGrad--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Rechnet Rad in Altgrad um.
  // 03.08.2000 BG korrigiert diesen Schwachsinn
 ------------------------------------------------------------}
function RadToGrad(Rad : Extended) : Extended;
begin
  //Result := (Rad * Pi / 180);
  Result := (Rad * 180/ Pi);
end;

{-IntPower10-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   10 ^ Exponent.
 ------------------------------------------------------------}
function IntPower10(Exponent: Integer): LongInt;
begin
  Result := IntPower(10,Exponent);
end;

{-FloatToCurrencyString--------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Fließkommawert in einen Währungs-
              String.
  Anmerkung:  Der Wert wird auf 2 Nachkommastellen gerundet.
 ------------------------------------------------------------}
function FloatToCurrencyString(P: Extended): String;
begin
  case CurrencyFormat of
    cfSignValue:
      Result := CurrencyString+FloatToStrF(FloatRound(P,2),ffFixed,18,2);
    cfValueSign:
      Result := FloatToStrF(FloatRound(P,2),ffFixed,18,2)+CurrencyString;
    cfSignBlankValue:
      Result := CurrencyString+' '+FloatToStrF(FloatRound(P,2),ffFixed,18,2);
    cfValueBlankSign:
      Result := FloatToStrF(FloatRound(P,2),ffFixed,18,2)+' '+CurrencyString;
  end;
end;

{-FloatToString----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Fließkommawert in einen String.
 ------------------------------------------------------------}
function FloatToString(P: Extended; Decimals: Integer): String;
begin
  Result := FloatToStrF(FloatRound(P,Decimals),ffFixed,18,Decimals);
end;

{-FloatToString----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Fließkommawert in einen String.
 ------------------------------------------------------------}
function FloatToStringSep(P: Extended; Decimals: Integer): String;
begin
  Result := FloatToStrF(FloatRound(P,Decimals),ffNumber,18,Decimals);
end;

{-FloatToStringExt-------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Fließkommawert in einen String.
 ------------------------------------------------------------}
function FloatToStringExt(P: Extended; Decimals: Integer;
  FloatFormat : TFloatFormat): String;
begin
  if EqualsZero(P) then
    begin
      case FloatFormat of
        ffSlash : Result := '-';
        ffNone  : Result := '';
        ffZero  : Result := '0';
      else { ffNormal }
        Result := FloatToStrF(FloatRound(P,Decimals),ffFixed,18,Decimals);
      end;
    end
  else
    Result := FloatToStrF(FloatRound(P,Decimals),ffFixed,18,Decimals);
end;

{--------------------------------------------------------------------------------------------------}
function FloatToStringPoints (P: Extended; Decimals: Integer): String;
{--------------------------------------------------------------------------------------------------}
// Wandelt einen Fließkommawert in einen String.
// dabei werden für die Messgeräte bei Bedarf die Kommas durch Punkte ersetzt
var
 I, Code: Integer;
begin
 try
  Result := FloatToStrF(P,ffFixed,18,Decimals);
  if (Decimals > 0) then
   begin
    for I := 1 to Length(Result) do
     begin
      if Result[I] = DecimalSeparator then Result[I] := '.';
     end;
   end;
 except
  Result := '0.0';
 end;
end;



{-FloatRound-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Rundungsfunktion für Fließkommawerte. Rundet
              auf beliebige Nachkommastellen.
 ------------------------------------------------------------}
function FloatRound(P: Extended; Decimals: Integer): Extended;
var
  Factor: LongInt;
  Help: Extended;
begin
  Factor := IntPower10(Decimals);
  if P < 0 then Help := -0.5 else Help := 0.5;
  Result := Int(P*Factor+Help)/Factor;
  if EqualsZero(Result) then Result := 0.00;
end;

{-EqualsZero-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Überprüft ob ein Fließkommawert null ist.
              Hierbei werden auch Werte kleiner als
              0.00000001 als Null bewertet.
 ------------------------------------------------------------}
function EqualsZero(P: Extended): Boolean;
begin
  Result := (P > -FloatZero) and (P < FloatZero);
end;

{-EqualsZeroFrac---------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Überprüft ob ein Fließkommawert null ist.
              die Digits werden übergeben
 ------------------------------------------------------------}
function EqualsZeroFrac(P: Extended; Frac : integer): Boolean;
begin
  if Frac > 0 then
    begin
      Result := (P > (-1/Frac)) and (P < (1/Frac));
    end
  else
    Result := false;
end;

{-CalcExpression---------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Berechnet einen String-Ausdruck. Es kann
              addiert, subtrahiert, multipliziert und
              dividiert werden. Klammern werden unterstützt.
 ------------------------------------------------------------}
function CalcExpression(const Expr: String): Extended;
const
  StackSize = 10;
var
  Stack: Array[0..StackSize] of double;
  oStack: Array[0..StackSize] of char;
  z, n: Double;
  i, j, m: Integer;
  Bracket: Boolean;
begin
  Bracket := False;
  j := 0;
  n := 1;
  z := 0;
  m := 1;
  for i := 1 to Length(Expr) do
    begin
      if not Bracket  then
        case Expr[i] of
          '0' .. '9':
            begin
              z := z*10+ord(Expr[i])-ord('0');
              n := n*m;
            end;
          ',',#46:
            begin
              m := 10;
            end;
          '(':
            begin
              Bracket := True; {hier Klammeranfang merken, Zähler!!}
            end;
          '*','x','X','/','-','+':
            begin
              Stack[j] := z/n;
              oStack[j] := Expr[i];
              Inc(j);
              m := 1;
              z := 0;
              n := 1;
            end;
        end
      else
        Bracket := Expr[i]<> ')'; {hier Rekursiver Aufruf, Zähler !!};
    end;
  Stack[j] := z / n;
  for i := 1 to j do
    case oStack[i-1] of
      '*','x','X' :  Stack[i] := Stack[i-1] * Stack[i];
      '/'         :  Stack[i] := Stack[i-1] / Stack[i];
      '+'         :  Stack[i] := Stack[i-1] + Stack[i];
      '-'         :  Stack[i] := Stack[i-1] - Stack[i];
    end;
  Result := Stack[j];
end;

{-Briefanrede------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt eine Kurz-Anrede in eine lange
              Anrede für Briefe um.
 ------------------------------------------------------------}
function BriefAnrede(S: String; const Zusaetze: array of String): String;
var
  i: Integer;
begin
  S := AnsiUpperCase(S);
  if Pos('HERR',S) > 0 then
    Result := 'Sehr geehrter Herr'
  else if Pos('FRAU',S) > 0 then
    Result := 'Sehr geehrte Frau'
  else if ((Pos('FRL',S) > 0) or (Pos('FRÄULEIN',S) > 0)) then
    Result := 'Sehr geehrtes Fräulein'
  else
    begin
      Result := 'Sehr geehrte Damen und Herren,';
      exit;
    end;
  for i := Low(Zusaetze) to High(Zusaetze) do
    Result := StringAdd(Result, Zusaetze[i], ' ');
  Result := Result + ',';
end;

{-SexToString------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt eine Geschlechtsangabe in einen String
              mit der Anrede.
  Anmerkung:  sxUnknown liefern einen Leerstring.
 ------------------------------------------------------------}
function SexToString(Sex: TSex): String;
begin
  case Sex of
    sxMale:       Result := 'Herrn';
    sxFemale:     Result := 'Frau';
    sxUnknown:    Result := '';
  end;
end;

{-StringToSex------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen String mit der Anrede in eine
              Geschlechtsangabe.
  Anmerkung:  Ist die Umwandlung nicht möglich, dann wird
              sxUnknown zurückgegeben.
 ------------------------------------------------------------}
function StringToSex(Sex: String): TSex;
const
  MaleSexes: Array[0..2] of String = ('HERR','HERRN','HR.');
  FemaleSexes: Array[0..3] of String = ('FRAU','FRÄULEIN','FRL','FR.');
var
  i: Integer;
begin
  Sex := AnsiUpperCase(Sex);
  for i := Low(MaleSexes) to High(MaleSexes) do
    if LeftStr(Sex,Length(MaleSexes[i])) = MaleSexes[i] then
      begin
        Result := sxMale;
        exit;
      end;
  for i := Low(FemaleSexes) to High(FemaleSexes) do
    if LeftStr(Sex,Length(FemaleSexes[i])) = FemaleSexes[i] then
      begin
        Result := sxFemale;
        exit;
      end;
  Result := sxUnknown;
end;

{-RoundTime--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Rundet eine Zeitangabe auf <Minutes> Minuten.
 ------------------------------------------------------------}
function RoundTime(ATime: TDateTime; Minutes: Word): TDateTime;
var
  H, M, S, N, Dif: Word;
begin
  if Minutes <= 0 then
   begin
    Result := ATime;
    exit;
   end;
  DecodeTime(ATime,H,M,S,N);
  S := 0;
  N := 0;
  Dif := M mod Minutes;
  if Dif < 5 then
    begin
      if M < Dif then
        M := 0
      else
        M := M - Dif;
    end
  else
    begin
      M := M + (10 - Dif);
      if M > 59 then
        begin
          H := H + 1;
          M := M - 60;
        end;
    end;
  Result := EncodeTime(H,M,S,N);
end;

{-IsSameDateTime---------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Überprüft zwei Werte des Typs TDateTime ob sie
                 das gleiche Datum oder die gleiche Uhrzeit
                 haben.
 ------------------------------------------------------------}
function IsSameDateTime(Date1, Date2: TDateTime; Compare: TCompareDate): Boolean;
begin
  case Compare of
    cdDateAndTime:
      Result := (Date1 = Date2);
    cdDate:
      Result := (RTrunc(Date1) = RTrunc(Date2));
    cdTime:
      Result := ((Date1 - RTrunc(Date1)) = (Date2 - RTrunc(Date2)));
  end;
end;

{-ExpandTime-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen 2-Byte-String in TDateTime.
  Anmerkung:  Ist die Länge des Strings ungleich 2, wird null
              zurückgegeben.
 ------------------------------------------------------------}
function ExpandTime(S: String): TDateTime;
var
  Std, Min: Word;
begin
  if Length(S) <> 2 then
    Result := 0
  else
    begin
      Std := Ord(S[1]);
      Min := Ord(S[2]);
      try
        Result := EncodeTime(Std, Min, 0, 0);
      except
        Result := 0;
      end;
    end;
end;

{-ComprTime--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt TDateTime in einen 2-Byte-String.
 ------------------------------------------------------------}
function ComprTime(T: TDateTime): String;
var
  Std, Min, Sek, MSek: Word;
begin
  DecodeTime(T, Std, Min, Sek, MSek);
  Result := Chr(Std)+Chr(Min);
end;

{-TimeToString-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt TDateTime in einen Zeitstring "HH:MM".
 ------------------------------------------------------------}
function TimeToString(T: TDateTime): String;
var
  Std, Min, Sek, MSek: Word;
begin
  DecodeTime(T, Std, Min, Sek, MSek);
  if Std < 10 then
    Result := '0'+IntToStr(Std)+':'
  else
    Result := IntToStr(Std)+':';
  if Min < 10 then
    Result := Result+'0'+IntToStr(Min)
  else
    Result := Result+IntToStr(Min);
end;

{-TimeToHourMin----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt TDateTime in einen Zeitstring "HH:MM". Dabei werden die Tage berücksichtigt
 ------------------------------------------------------------}
function TimeToHourMin(T: TDateTime): String;
var
  Std, Min, Sek, MSek : Word;
  Day    : Word;
  iHours              : integer;
begin
  if T >= 1 then Day := RTrunc (T)
            else Day   := 0;
  DecodeTime (T, Std, Min, Sek, MSek);
  iHours := (24 * Day)+ Std;
  if iHours < 10 then Result := '0' + IntToStr (iHours) + ':'
                 else Result := IntToStr (iHours) + ':';
  if Min < 10    then Result := Result + '0' + IntToStr (Min)
                 else Result := Result + IntToStr (Min);
end;

{-TimeToStrSec--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt TDateTime in einen Zeitstring "HH:MM:SS".
 ------------------------------------------------------------}
function TimeToStrSec(T: TDateTime): String;
var
  Std, Min, Sek, MSek: Word;
begin
  DecodeTime(T, Std, Min, Sek, MSek);
  if Std < 10 then
    Result := '0'+IntToStr(Std)+':'
  else
    Result := IntToStr(Std)+':';
  if Min < 10 then
    Result := Result+'0'+IntToStr(Min)+':'
  else
    Result := Result+IntToStr(Min)+':';
  if Sek < 10 then
    Result := Result+'0'+IntToStr(Sek)
  else
    Result := Result+IntToStr(Sek);
end;

{-TimeToStrSQL--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt TDateTime in einen Zeitstring "HHMMSS" für die Speicherung in MySQL.
 ------------------------------------------------------------}
function TimeToStrSQL(T: TDateTime): String;
var
  Std, Min, Sek, MSek: Word;
begin
  DecodeTime(T, Std, Min, Sek, MSek);
  if Std < 10 then Result := '0' + IntToStr (Std)
              else Result := IntToStr (Std);
  if Min < 10 then Result := Result + '0' +IntToStr (Min)
              else Result := Result + IntToStr (Min);
  if Sek < 10 then Result := Result + '0' + IntToStr (Sek)
              else Result := Result + IntToStr (Sek);
end;

{-StringToTime-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Zeitstring "HH:MM" in TDateTime.
 ------------------------------------------------------------}
function StringToTime(S: String): TDateTime;
var
  Std, Min: Word;
  Doppelpunkt: Integer;
begin
  s := Alltrim(s);
  if Length(s) = 8 then s := copy(s,1,5); { weg mit den Sekunden }
  Std := 0;
  Min := 0;
  Doppelpunkt := Pos(TimeSeparator, S);
  if Doppelpunkt = 0 then
    Result := 0
  else
    begin
      Std := StringToInteger(LeftStr(S,Doppelpunkt-1),0);
      Min := StringToInteger(RestStr(S,Doppelpunkt+1),0);
    end;
  Result := EncodeTime(Std, Min, 0, 0);
end;

{-DateToString-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt TDateTime in einen Datumsstring
              "TT.MM.JJJJ".
 ------------------------------------------------------------}
function DateToString(T: TDateTime): String;
var
 Tag, Monat, Jahr: Word;
begin
  if T = 0 then
    Result := ''
  else
   begin
    DecodeDate(T, Jahr,Monat,Tag);
    if Jahr < 1910 then Jahr := Jahr + 100; // dieser böse Schritt war nötig, da Paradox 7.0 offensichtlich Mist macht
//obacht(IntToStr(Tag) + DateSeparator+IntToStr(Monat) + DateSeparator + IntToStr(Jahr));
    Result := FillWithZero (IntToStr(Tag),   2) + DateSeparator +
              FillWithZero (IntToStr(Monat), 2) + DateSeparator +
              FillWithZero (IntToStr(Jahr),  4);

    //Result := FormatDateTime('dd'+DateSeparator+'mm'+DateSeparator+'yyyy',T);
   end;
end;

{-DateToStrSQL-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt TDateTime in einen Datumsstring für MySQL
              "JJJJMMTT"
 ------------------------------------------------------------}
function DateToStrSQL (T: TDateTime): String;
var
 Tag, Monat, Jahr: Word;
begin
  if T = 0 then
    Result := ''
  else
   begin
    DecodeDate(T, Jahr,Monat,Tag);
    Result := FillWithZero (IntToStr(Jahr),  4) +
              FillWithZero (IntToStr(Monat), 2) + 
              FillWithZero (IntToStr(Tag),   2);
   end;
end;

{-DateToShortString------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt TDateTime in einen Datumsstring
              "TT.MM.JJJJ".
 ------------------------------------------------------------}
function DateToShortString(T: TDateTime): String;
var
 Tag, Monat, Jahr: Word;
begin
  if T = 0 then
    Result := ''
  else
   begin
    DecodeDate(T, Jahr,Monat,Tag);
    if Jahr < 1910 then Jahr := Jahr + 100; // dieser böse Schritt war nötig, da Paradox 7.0 offensichtlich Mist macht
    if Jahr > 2000 then Jahr := Jahr - 2000; // Nur kurzes Datum ausgeben
    Result := FillWithZero (IntToStr(Tag),   2) + DateSeparator +
              FillWithZero (IntToStr(Monat), 2) + DateSeparator +
              FillWithZero (IntToStr(Jahr),  2);

   end;
end;

{-DateTimeToString-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt TDateTime in einen Datumsstring
              "TT.MM.JJJJ ".
 ------------------------------------------------------------}
function DateTimeToString(T: TDateTime): String;
var
 Tag, Monat, Jahr: Word;
begin
  if T = 0 then
    Result := ''
  else
   begin
    Result := FormatDateTime('dd'+DateSeparator+'mm'+DateSeparator+'yyyy' + ' ' +
                             'hh'+TimeSeparator+'nn'+TimeSeparator+'ss',T);
   end;
end;

{-DateStringToAnsiString-------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Datumsstring der Form "DD.MM.YYYY"
              in einen Ansi-Datumsstring der Form "YYYYMMDD".
  Anmerkung:  Es erfolgt eine Plausibilitätsprüfung.
 ------------------------------------------------------------}
function DateStringToAnsiString(S: String): String;
begin
  if IsValidDateStr(S) then
    Result := RightStr(S,4)+SubStr(S,4,2)+LeftStr(S,2)
  else
    Result := Space(8);
end;

{-DateToAnsiString-------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Datumswert in einen Ansi-
              Datumsstring der Form "YYYYMMDD".
 ------------------------------------------------------------}
function DateToAnsiString(T: TDateTime): String;
var
  Tag, Monat, Jahr: Word;
begin
  DecodeDate(T, Jahr, Monat, Tag);
  Result := IntegerToZeroString(Jahr,4) + IntegerToZeroString(Monat,2)+ IntegerToZeroString(Tag,2);
end;

{-AnsiStringToDate-------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Ansi-Datumsstring in TDateTime.
  Anmerkung:  Ansi-Format: "YYYYMMDD"
 ------------------------------------------------------------}
function AnsiStringToDate(S: String): TDateTime;
var
  Tag, Monat, Jahr: Word;
begin
  if Pos(S[1],'0123456789') = 0 then
    begin
      Result := 0;
      exit;
    end;
  if Length(S) = 6 then S := '19'+S;
  if Length(S) < 8 then
    begin
      Result := 0;
      exit;
    end;
  Tag := StringToInteger(SubStr(S,7,2),0);
  Monat := StringToInteger(SubStr(S,5,2),0);
  Jahr := StringToInteger(LeftStr(S,4),0);
  Result := EncodeDate(Jahr,Monat,Tag);
end;

{-StringToDate-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Datumsstring in TDateTime.
 ------------------------------------------------------------}
function StringToDate(S: String): TDateTime;
var
  Tag, Monat, Jahr: Word;
  P1, P2: Integer;
begin
  P1 := At(DateSeparator, S);
  P2 := RAt(DateSeparator, S);
  if ( (P1 = P2) or (P1>3) or (P2>6) or ((P1+3)<P2) ) then
    Result := 0
  else
    begin
      Tag := StringToInteger(LeftStr(S,P1-1),0);
      Monat := StringToInteger(SubStr(S,P1+1,P2-P1-1),0);
      Jahr := StringToInteger(RestStr(S,P2+1),0);
      if Jahr < 100 then
        begin
          if Jahr < DateEpochYear then
            Inc(Jahr,((DateEpochBase+1)*100))
          else
            Inc(Jahr,((DateEpochBase)*100))
        end;
      Result := EncodeDate(Jahr,Monat,Tag);
    end;
end;

{-BinToByte--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen String der Länge 1 in Byte.
  Anmerkung:  Ist der String länger als 1 Zeichen, wird null
              zurückgegeben
 ------------------------------------------------------------}
function BinToByte(S: String): Byte;
begin
  if Length(S) <> 1 then
    Result := 0
  else
    Result := Byte(Ord(S[1]));
end;

{-BinToInt---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen String der Länge 2 in Integer.
  Anmerkung:  Ist der String länger als 2 Zeichen, wird null
              zurückgegeben
 ------------------------------------------------------------}
function BinToInt(S: String): Integer;
begin
  if Length(S) <> 2 then
    Result := 0
  else
    Result := (Integer(Ord(S[2])) shl 8) + Ord(S[1]);
end;

{-BinToWord--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen String der Länge 2 in Word
  Anmerkung:  Ist der String länger als 2 Zeichen, wird null
              zurückgegeben
 ------------------------------------------------------------}
function BinToWord(S: String): Word;
begin
  if Length(S) <> 2 then
    Result := 0
  else
    Result := (Word(Ord(S[2])) shl 8) + Word(Ord(S[1]));
end;

{-BinToLongInt-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen String der Länge 4 in LongInteger.
  Anmerkung:  Ist der String länger als 4 Zeichen, wird null
              zurückgegeben
 ------------------------------------------------------------}
function BinToLongInt(S: String): LongInt;
begin
  if Length(S) <> 4 then
    Result := 0
  else
    Result := (LongInt(Ord(S[4])) shl 24) + (LongInt(Ord(S[3])) shl 16) +
      (LongInt(Ord(S[2])) shl 8) + Ord(S[1]);
end;

{-ByteToBin--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt ein Byte in einen String der Länge 1.
 ------------------------------------------------------------}
function ByteToBin(B: Byte): String;
begin
  Result := Chr(B);
end;

{-IntToBin---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Integerwert in einen String der
              Länge 2.
  Anmerkung:  Niederwertige Bytes stehen links.
 ------------------------------------------------------------}
function IntToBin(I: Integer): String;
begin
  Result := Chr(Lo(I))+Chr(Hi(I));
end;

{-WordToBin--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen Wordwert in einen String der
              Länge 2.
  Anmerkung:  Niederwertige Bytes stehen links.
 ------------------------------------------------------------}
function WordToBin(W: Word): String;
begin
  Result := Chr(Lo(W))+Chr(Hi(W));
end;

{-LongIntToBin-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt einen LongIntegerwert in einen String
              der Länge 4.
  Anmerkung:  Niederwertige Bytes stehen links.
 ------------------------------------------------------------}
function LongIntToBin(L: LongInt): String;
var
  LoWord, HiWord: Word;
begin
  LoWord := Word((L shl 16) shr 16);
  HiWord := Word(L shr 16);
  Result := Chr(Lo(LoWord))+Chr(Hi(LoWord))+Chr(Lo(HiWord))+Chr(Hi(HiWord));
end;

{-Crypt------------------------------------------------------
  Parameter:  S: String     Text zum Ver-/Entschlüsseln
              Key: String   Schlüssel
              Ansi2Oem:     TCryptConvert
  Scope:      Public
  Funktion:   Der gute alte Nantucket-Crypt.
 ------------------------------------------------------------}
function Crypt(const S, Key: String; Ansi2Oem: TCryptConvert): String;
{
var
  tmp: Array[0..256] of Char;
begin
  StrPCopy(tmp,S);
  CryptBuff(tmp, Key, Ansi2Oem, Length(S));
  Result := StrPas(tmp);

  StrPCopy(tmp,Result);
  case Ansi2Oem of
    ccNoConvert:    CryptBuff(tmp, Key, ccNoConvert, Length(S));
    ccBeforeCrypt:  CryptBuff(tmp, Key, ccAfterCrypt, Length(S));
    ccAfterCrypt:   CryptBuff(tmp, Key, ccBeforeCrypt, Length(S));
  end;
  if S <> StrPas(tmp) then obacht('Crypt-Fehler');
end;
}
  {-ByteRollR--------------------------------------------------
    Parameter:  siehe Deklaration
    Scope:      Inline
    Funktion:   Bitweises Rollen nach rechts in einem Byte.
   ------------------------------------------------------------}
  procedure ByteRollR(var Value: Byte; roll: Byte);
  var
    i: Byte;
  begin
    for i := 0 to (roll-1) do
      begin
        if Value and 1 <> 0 then {Bit 0 gesetzt}
          Value := (Value shr 1) or 128
        else
          Value := Value shr 1;
      end;
  end;

  {-ByteRollL--------------------------------------------------
    Parameter:  siehe Deklaration
    Scope:      Inline
    Funktion:   Bitweises Rollen nach links in einem Byte.
   ------------------------------------------------------------}
  procedure ByteRollL(var Value: Byte; roll: Byte);
  var
    i: Byte;
  begin
    for i := 7 downto (8-roll) do
      begin
        if Value and 128 <> 0 then
          Value := (Value shl 1) or 1
        else
          Value := Value shl 1;
      end;
  end;

  {-WordRollR--------------------------------------------------
    Parameter:  siehe Deklaration
    Scope:      Inline
    Funktion:   Bitweises Rollen nach rechts in einem Word.
   ------------------------------------------------------------}
  procedure WordRollR(var Value: Word; roll: Byte);
  var
    i: Byte;
  begin
    for i := 0 to (roll-1) do
      begin
        if Value and 1 <> 0 then
          Value := (Value shr 1) or $8000  {32768}
        else
          Value := Value shr 1;
      end;
  end;

  {-WordRollL--------------------------------------------------
    Parameter:  siehe Deklaration
    Scope:      Inline
    Funktion:   Bitweises Rollen nach links in einem Word.
   ------------------------------------------------------------}
  procedure WordRollL(var Value: Word; roll: Byte);
  var
    i: Byte;
  begin
    for i := 15 downto (16-roll) do
      begin
        if Value and $8000 <> 0 then {32768}
          Value := (Value shl 1) or 1
        else
          Value := Value shl 1;
      end;
  end;

var
  al, ax, bx, cx, dx, si, di, len_txt, len_schl, var1, var2: Word;
  dl, dh, cl, ch: Byte;
  loop1, loop2, loop3: Boolean;
  Conv: String;
  Buff: Array[0..256] of Char;
begin
  if Length(Key) < 2 then
    begin
      Result := S;
      exit;
    end;

  if Ansi2Oem = ccBeforeCrypt then
    begin
      StrPCopy(Buff,S);
      CharToOem(Buff,Buff);
      Conv := StrPas(Buff);
    end
  else
    Conv := S;

  if Length(Conv) < 1 then exit; { Greb baut das wegen bumm ein }
  
  { Init }
  var1 := $AAAA;  {43690}

  { Schlüssellänge merken }
  cx := Length(Key);
  Len_schl := cx;

  { Indexvariablen initialisieren }
  si := 1;
  di := 1;
  len_txt := Length(S);

  { Startwert für Variable 2 berechnen }
  ax := (Ord(Key[si+1])*256)+Ord(Key[si]);
  ax := ax xor cx;
  var2 := ax;

  loop1 := true;
  loop2 := true;
  loop3 := true;

  while loop1 do
    begin
      si := 1;
      bx := len_schl;

      while loop2 do
        begin
          al := Ord(key[si]);
          Inc(si);

          al := (al xor Ord(Conv[di])) and 255;
          cx := var2;
          dx := var1;

          cl := Lo(cx);
          ch := Hi(cx);
          cl := (cl xor ch) and 255;
          cx := 256*Word(ch)+Word(cl);

          WordRollR(cx, (cl mod 16));

          cx := cx xor dx;
          Inc(cx,16);
          var2 := cx;
          cx := cx and 30;
          Inc(cx,2);

          while loop3 do
            begin
              Dec(cx);

              WordRollR(dx, (Lo(cx) mod 16));

              dl := Lo(dx);
              dh := Hi(dx);
              dx := 256*Word(dl)+Word(dh);

              dl := Lo(dx);
              dh := Hi(dx);
              dl := ((not dl) and 255);
              dx := 256*Word(dh)+Word(dl);

              if (dx and (1 shl 15)) <> 0 then {Bit 15 gesetzt?}
                dx := (dx shl 1) or 1
              else
                dx := (dx shl 1);

              dx := dx xor $AAAA;    {43690}

              dl := Lo(dx);
              dh := Hi(dx);

              ByteRollL(dl,1);
              dx := 256*Word(dh)+Word(dl);

              Dec(cx);
              if cx <=0 then break;
            end;

          var1 := dx;

          dl := Lo(dx);

          al := (al xor Word(dl)) and 255;

          Conv[di] := Chr(al);
          Inc(di);
          Dec(len_txt);

          if len_txt = 0 then
            begin
              Result := Conv;
              if Ansi2Oem = ccAfterCrypt then
                begin
                  StrPCopy(Buff,Conv);
                  OemToChar(Buff,Buff);
                  Result := StrPas(Buff);
                end;
              exit;
            end;

          Dec(bx);
          if bx = 0 then break;
        end;
    end;

end;

{-CryptBuff--------------------------------------------------
  Parameter:  S: String       Text zum Ver-/Entschlüsseln
              Key: String     Schlüssel
              Ansi2Oem: TCryptConvert
  Scope:      Public
  Funktion:   Der gute alte Nantucket-Crypt.
 ------------------------------------------------------------}
procedure CryptBuff(S: PChar; const Key: String; Ansi2Oem: TCryptConvert; Chars: LongInt);

  {-ByteRollR--------------------------------------------------
    Parameter:  siehe Deklaration
    Scope:      Inline
    Funktion:   Bitweises Rollen nach rechts in einem Byte.
   ------------------------------------------------------------}
  procedure ByteRollR(var Value: Byte; roll: Byte);
  var
    i: Byte;
  begin
    for i := 0 to (roll-1) do
    begin
        if Value and 1 <> 0 then {Bit 0 gesetzt}
          Value := (Value shr 1) or 128
        else
          Value := Value shr 1;
      end;
  end;

  {-ByteRollL--------------------------------------------------
    Parameter:  siehe Deklaration
    Scope:      Inline
    Funktion:   Bitweises Rollen nach links in einem Byte.
   ------------------------------------------------------------}
  procedure ByteRollL(var Value: Byte; roll: Byte);
  var
    i: Byte;
  begin
    for i := 7 downto (8-roll) do
      begin
        if Value and 128 <> 0 then
          Value := (Value shl 1) or 1
        else
          Value := Value shl 1;
      end;
  end;

  {-WordRollR--------------------------------------------------
    Parameter:  siehe Deklaration
    Scope:      Inline
    Funktion:   Bitweises Rollen nach rechts in einem Word.
   ------------------------------------------------------------}
  procedure WordRollR(var Value: Word; roll: Byte);
  var
    i: Byte;
  begin
    for i := 0 to (roll-1) do
      begin
        if Value and 1 <> 0 then
          Value := (Value shr 1) or $8000  {32768}
        else
          Value := Value shr 1;
      end;
  end;

  {-WordRollL--------------------------------------------------
    Parameter:  siehe Deklaration
    Scope:      Inline
    Funktion:   Bitweises Rollen nach links in einem Word.
   ------------------------------------------------------------}
  procedure WordRollL(var Value: Word; roll: Byte);
  var
    i: Byte;
  begin
    for i := 15 downto (16-roll) do
      begin
        if Value and $8000 <> 0 then {32768}
          Value := (Value shl 1) or 1
        else
          Value := Value shl 1;
      end;
  end;

var
  al, ax, bx, cx, dx, si, di, len_txt, len_schl, var1, var2: Word;
  dl, dh, cl, ch: Byte;
  loop1, loop2, loop3: Boolean;
begin
  if Length(Key) < 2 then exit;

  if Ansi2Oem = ccBeforeCrypt then CharToOem(S,S);

  { Init }
  var1 := $AAAA;  {43690}

  { Schlüssellänge merken }
  cx := Length(Key);
  Len_schl := cx;

  { Indexvariablen initialisieren }
  si := 1;
  di := 1;
  len_txt := Chars;

  { Startwert für Variable 2 berechnen }
  ax := (Ord(Key[si+1])*256)+Ord(Key[si]);
  ax := ax xor cx;
  var2 := ax;

  loop1 := true;
  loop2 := true;
  loop3 := true;

  while loop1 do
    begin
      si := 1;
      bx := len_schl;

      while loop2 do
        begin
          al := Ord(key[si]);
          Inc(si);

          al := (al xor Ord(S[di])) and 255;
          cx := var2;
          dx := var1;

          cl := Lo(cx);
          ch := Hi(cx);
          cl := (cl xor ch) and 255;
          cx := 256*Word(ch)+Word(cl);

          WordRollR(cx, (cl mod 16));

          cx := cx xor dx;
          Inc(cx,16);
          var2 := cx;
          cx := cx and 30;
          Inc(cx,2);

          while loop3 do
            begin
              Dec(cx);

              WordRollR(dx, (Lo(cx) mod 16));

              dl := Lo(dx);
              dh := Hi(dx);
              dx := 256*Word(dl)+Word(dh);

              dl := Lo(dx);
              dh := Hi(dx);
              dl := ((not dl) and 255);
              dx := 256*Word(dh)+Word(dl);

              if (dx and (1 shl 15)) <> 0 then {Bit 15 gesetzt?}
                dx := (dx shl 1) or 1
              else
                dx := (dx shl 1);

              dx := dx xor $AAAA;    {43690}

              dl := Lo(dx);
              dh := Hi(dx);

              ByteRollL(dl,1);
              dx := 256*Word(dh)+Word(dl);

              Dec(cx);
              if cx <=0 then break;
            end;

          var1 := dx;

          dl := Lo(dx);

          al := (al xor Word(dl)) and 255;

          S[di] := Chr(al);
          Inc(di);
          Dec(len_txt);

          if len_txt = 0 then
            begin
              if Ansi2Oem = ccAfterCrypt then OemToChar(S,S);
              exit;
            end;

          Dec(bx);
          if bx = 0 then break;
        end;
    end;

end;


{-MinXXXX/MaxXXXX--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Min-/Max-Funktionen für div. numer. Typen
 ------------------------------------------------------------}
function MaxInteger(Val1, Val2: Integer): Integer;
begin
  if Val1 > Val2 then Result := Val1 else Result := Val2;
end;

function MinInteger(Val1, Val2: Integer): Integer;
begin
  if Val1 < Val2 then Result := Val1 else Result := Val2;
end;

function MaxLongInt(Val1, Val2: LongInt): LongInt;
begin
  if Val1 > Val2 then Result := Val1 else Result := Val2;
end;

function MinLongInt(Val1, Val2: LongInt): LongInt;
begin
  if Val1 < Val2 then Result := Val1 else Result := Val2;
end;

function MaxWord(Val1, Val2: Word): Word;
begin
  if Val1 > Val2 then Result := Val1 else Result := Val2;
end;

function MinWord(Val1, Val2: Word): Word;
begin
  if Val1 < Val2 then Result := Val1 else Result := Val2;
end;

function MaxByte(Val1, Val2: Byte): Byte;
begin
  if Val1 > Val2 then Result := Val1 else Result := Val2;
end;

function MinByte(Val1, Val2: Byte): Byte;
begin
  if Val1 < Val2 then Result := Val1 else Result := Val2;
end;

function MaxReal(Val1, Val2: Real): Real;
begin
  if Val1 > Val2 then Result := Val1 else Result := Val2;
end;

function MinReal(Val1, Val2: Real): Real;
begin
  if Val1 < Val2 then Result := Val1 else Result := Val2;
end;

{-StrIsBit---------------------------------------------------
  Parameter:  siehe Deklaration (Clipper-kompatibel)
  Scope:      Public
  Funktion:   Überprüft ob ein bestimmtes Bit in einem String
              gesetzt ist.
  Anmerkung:  Wir gehen davon aus, daß das niedrigste Bit die
              Ordungszahl '1' hat.
 ------------------------------------------------------------}
function StrIsBit(const Val: String; const TheBit: Byte): Boolean;
var
  C: Char;
  N: Integer;
begin
  N := (TheBit div 8)+1;
  if N <= Length(Val) then
    Result := (Ord(Val[N]) and (1 shl ((TheBit-1) mod 8))) <> 0 
  else
    Result := false;
end;

{-StrSetBit--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Setzt bestimmtes Bit in einem String.
  Anmerkung:  Wir gehen davon aus, daß das niedrigste Bit die
              Ordungszahl '1' hat.
 ------------------------------------------------------------}
procedure StrSetBit(var Val: String; const TheBit: Byte);
var
  C: Byte;
  N: Integer;
begin
  N := (TheBit div 8)+1;
  if N <= Length(Val) then
    begin
      C := Byte(Val[N]);
      C := C or Byte(1 shl ((TheBit-1) mod 8));
      Val[N] := Chr(C);
    end;
end;

{-StrClearBit------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Löscht bestimmtes Bit in einem String.
  Anmerkung:  Wir gehen davon aus, daß das niedrigste Bit die
              Ordungszahl '1' hat.
 ------------------------------------------------------------}
procedure StrClearBit(var Val: String; const TheBit: Byte);
var
  C: Byte;
  N: Integer;
begin
  N := (TheBit div 8)+1;
  if N <= Length(Val) then
    begin
      C := Byte(Val[N]);
      C := C and ((1 shl ((TheBit-1) mod 8)) xor $FFFFFFFF);
      Val[N] := Chr(C);
    end;
end;

{-IsBit------------------------------------------------------
  Parameter:  siehe Deklaration (Clipper-kompatibel)
  Scope:      Public
  Funktion:   Überprüft ob ein bestimmtes Bit gesetzt ist.
  Anmerkung:  Wir gehen davon aus, daß das niedrigste Bit die
              Ordungszahl '1' hat.
 ------------------------------------------------------------}
function IsBit(const Val: Longint; const TheBit: Byte): Boolean;
begin
  Result := (Val and (1 shl LongInt(TheBit-1))) <> 0;
end;

{-SetBit-----------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Setzt ein bestimmtes Bit in einem Long-Integer.
  Anmerkung:  Wir gehen davon aus, daß das niedrigste Bit die
              Ordungszahl '1' hat.
 ------------------------------------------------------------}
function SetBit(const Val: Longint; const TheBit: Byte): LongInt;
begin
  Result := Val or (1 shl LongInt(TheBit-1));
end;

{-ClearBit---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Löscht ein bestimmtes Bit in einem Long-Integer.
  Anmerkung:  Wir gehen davon aus, daß das niedrigste Bit die
              Ordungszahl '1' hat.
 ------------------------------------------------------------}
function ClearBit(const Val: Longint; const TheBit: Byte): LongInt;
begin
  Result := Val and ((1 shl LongInt(TheBit-1)) xor $FFFFFFFF);
end;

{-ToggleBit--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Setzt ein gelöschtes bzw. löscht ein gesetzes
              Bit in einem Long-Integer.
  Anmerkung:  Wir gehen davon aus, daß das niedrigste Bit die
              Ordungszahl '1' hat.
 ------------------------------------------------------------}
function ToggleBit(const Val: Longint; const TheBit: Byte): LongInt;
begin
  Result := Val xor (1 shl LongInt(TheBit-1));
end;

{-ColorNumToColor--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt ein Farbzahl in eine Farbe.
  Anmerkung:  Bezieht sich auf die 16 Grundfarben.
 ------------------------------------------------------------}
function ColorNumToColor(Num: LongInt): TColor;
begin
 try
  case Num of
    0: Result := clBlack;
    1: Result := clMaroon;
    2: Result := clGreen;
    3: Result := clOlive;
    4: Result := clNavy;
    5: Result := clPurple;
    6: Result := clTeal;
    7: Result := clSilver;
    8: Result := clGray;
    9: Result := clRed;
    10: Result := clLime;
    11: Result := clYellow;
    12: Result := clBlue;
    13: Result := clFuchsia;
    14: Result := clAqua;
    15: Result := clWhite;
  else
    //if Num > $00FFFFFF then Num := $00FFFFFF;
    Result := TColor(RGB(Num,(Num shr 8),(Num shr 16)));
  end;
 except
    Result := clBlack;
    Result := clWhite;
  end;
end;

{-ColorToColorNum--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt ein Farbe in eine Farbzahl.
  Anmerkung:  Bezieht sich auf die 16 Grundfarben.
 ------------------------------------------------------------}
function ColorToColorNum(Color: TColor): LongInt;
begin
  if Color = clBlack then Result := 0
  else if Color = clMaroon then Result := 1
  else if Color = clGreen then Result := 2
  else if Color = clOlive then Result := 3
  else if Color = clNavy then Result := 4
  else if Color = clPurple then Result := 5
  else if Color = clTeal then Result := 6
  else if Color = clSilver then Result := 7
  else if Color = clGray then Result := 8
  else if Color = clRed then Result := 9
  else if Color = clLime then Result := 10
  else if Color = clYellow then Result := 11
  else if Color = clBlue then Result := 12
  else if Color = clFuchsia then Result := 13
  else if Color = clAqua then Result := 14
  else if Color = clWhite then Result := 15
  else Result := ColorToRGB(Color);
end;

{-KomplementaerColor-----------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   gibt Komlemetaerfarbe zurück
 ------------------------------------------------------------}
function KomplementaerColor(Color: TColor): TColor;
var
  iRGB: integer;
  Red: Byte;
  Blue: Byte;
  Green: Byte;
begin
  try
    iRGB  := ColorToRGB(Color);
    Red   := (255 - GetRValue(iRGB));
    Green := (255 - GetGValue(iRGB));
    Blue  := (255 - GetBValue(iRGB));
    Result := RGB(Red,Green,Blue);
    if (Red = Green) and (Red = Blue) and (Blue = Green) and //wegen Grau in Grau
       (Red > 10) and //wegen Schwarz
       (Red < 245) then //wegen Weiß
      Result := clBlack;
  except
    Result := clBlack;
  end;
end;

{-PenModeNumToPenMode----------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt ein PenModeNummer in einen PenMode.
  Anmerkung:  ---
 ------------------------------------------------------------}
function PenModeNumToPenMode(Num: LongInt): TPenMode;
begin
  case Num of
    0 : Result := pmBlack;
    1 : Result := pmWhite;
    2 : Result := pmNop;
    3 : Result := pmNot;
    4 : Result := pmCopy;
    5 : Result := pmNotCopy;
    6 : Result := pmMergePenNot;
    7 : Result := pmMaskPenNot;
    8 : Result := pmMergeNotPen;
    9 : Result := pmMaskNotPen;
    10 : Result := pmMerge;
    11 : Result := pmNotMerge;
    12 : Result := pmMask;
    13 : Result := pmNotMask;
    14 : Result := pmXor;
    15 : Result := pmNotXor;
  else
    Result := pmCopy;
  end;
end;

{-BrushStyleNumToBrushStyle----------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt ein BrushStyleNummmer in einen BrushStyle.
  Anmerkung:  ---
 ------------------------------------------------------------}
function BrushStyleNumToBrushStyle(Num: LongInt): TBrushStyle;
begin
  case Num of
    0 : Result := bsSolid;
    1 : Result := bsCross;
    2 : Result := bsClear;
    3 : Result := bsDiagCross;
    4 : Result := bsBDiagonal;
    5 : Result := bsHorizontal;
    6 : Result := bsFDiagonal;
    7 : Result := bsVertical;
  else
    Result := bsSolid;
  end;
end;

{-ControlCharsToSpaces---------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Ersetzt Ascii-Zeichen < 32 durch ein Leerzeichen.
 ------------------------------------------------------------}
procedure ControlCharsToSpaces(var S: String);
var
  i: Integer;
begin
  for i := 1 to Length(S) do if Ord(S[i]) < 32 then S[i] := ' ';
end;

{-ControlCharsToSpaces---------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   filtert eine String zu einer Zahlenstring Vorzeichen dürfen auch mit
              als Kommas werden vorerst nur Punkte akzeptiert <-- wegen HPGL-Datei 
 ------------------------------------------------------------}
function StringToDigitString(C: String): String;
var
  i: Integer;
  s : string;
begin
  c := Alltrim(c);
  if Length(c) > 0 then
    begin
      s := '';
      for i := 1 to Length(c) do
        begin
          if c[i] in ['0'..'9','-','+','.'] then S := s + c[i];
        end;
      Result := s;
    end
  else
    Result := '';
end;

{-StringAdd--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Addiert zwei Strings und fügt dazwischen einen
              dritten String ein, wenn der erste nicht leer
              ist.
 ------------------------------------------------------------}
function StringAdd(String1,String2,Insert: String): String;
begin
  if String1 = EmptyStr then
    Result := String2
  else if String2 = EmptyStr then
    Result := String1
  else
    Result := String1+Insert+String2;
end;

{-RestStr----------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt den Rest eines Strings ab der gewünschten
              Position zurück.
  Anmerkung:  Entspricht XBase SubStr(string,pos).
 ------------------------------------------------------------}
function RestStr(Str: String; Pos: Integer): String;
begin
  if Pos <= Length(Str) then
    Result := Copy(Str,Pos,Length(Str)-Pos+1)
  else
    Result := '';
end;

{-IntegerToZeroString----------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Integer in String mit führenden Nullen.
 ------------------------------------------------------------}
function IntegerToZeroString(Value: LongInt; Len: Word): String;
begin
  Result := IntToStr(Value);
  Result := Replicate('0',Len - Length(Result)) + Result;
{  Result := LeftStr(Result,Len);}
end;

{-IntegerToCurrencyString------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Integer in Währungs-String (mit zwei
              Nachkommastellen).
 ------------------------------------------------------------}
function IntegerToCurrencyString(Value: LongInt): String;
begin
  Result := FloatToCurrencyString(Value / 100);
end;

{-IntegerToSpaceString---------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Integer in String mit führenden Leerzeichen.
 ------------------------------------------------------------}
function IntegerToSpaceString(Value: LongInt; Len: Word): String;
begin
  Result := IntToStr(Value);
  Result := Space(Len-Length(Result))+Result;
end;

{-GrossKlein-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Erstes Zeichen Großbuchstaben, restl. Zeichen
              Kleinbuchstaben.
 ------------------------------------------------------------}
function GrossKlein(Text: String): String;
begin
  Result := AnsiUpperCase(Text[1])+AnsiLowerCase(RightStr(Text,Length(Text)-1));
end;

{-Capitalize-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert in einem String alle ersten Buch-
              staben eines Wortes in Großbuchstaben.
 ------------------------------------------------------------}
function Capitalize(const S: String): String;
var
  i: Integer;
  Ch: Char;
  First: Boolean;
begin
  First := True;
  Result := AnsiLowerCase(S);
  for i := 1 to Length(S) do
    begin
      if S[i] in [' ','-','.'] then
        First := True
      else if First then
        begin
          Result[i] := AnsiUpperCase(S[i])[1];
          First := False;
        end;
    end;
end;

{-StringToBoolean--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt versch. String-Werte in Boolsche
              Werte um.
 ------------------------------------------------------------}
function StringToBoolean(C: String): Boolean;
begin
  Result := false;
  C := Alltrim(C);
  if C <> '' then
    begin
      C := UpperCase(C);
      case C[1] of
        '0': Result := false;
        '1': Result := true;
        'F': Result := false;
        'J': Result := true;
        'N': Result := false;
        'T': Result := true;
        'Y': Result := true;
      else
        if ((C = 'JA') or (C = 'YES') or (C = '.T.') or (C = 'TRUE')) then
          Result := true
        else
          Result := false;
      end;
    end;
end;

{-BooleanToString--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt true in '1' und false in '0' um.
 ------------------------------------------------------------}
function BooleanToString(Bool: Boolean): String;
begin
  if Bool then Result := '1' else Result := '0';
end;

{-BooleanToYesNo---------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt true in 'ja' und false in 'nein' um.
 ------------------------------------------------------------}
function BooleanToJaNein(Bool: Boolean): String;
begin
  if Bool then Result := 'ja' else Result := 'nein';
end;

{-BooleanToYesNo---------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt true in 'ja' und false in 'nein' um.
 ------------------------------------------------------------}
function BooleanToYesNo(Bool: Boolean): String;
begin
  if Bool then Result := 'yes' else Result := 'no';
end;

{-LogToChar--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt Boolsche Werte in "J" bzw. "N".
 ------------------------------------------------------------}
function LogToChar(Bool: Boolean): Char;
begin
  if Bool then Result := 'J' else Result := 'N';
end;

{-CharToLog--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt die Zeichen "J" bzw. "N" in Bools.
 ------------------------------------------------------------}
function CharToLog(Zeichen: Char): Boolean;
begin
  if UpperCase(Zeichen) = 'J' then Result := true else Result := false;
end;

{-OemStringToAnsiString--------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert eine Oem-Ascii-String in einen
              Windows-Ansi-String.
 ------------------------------------------------------------}
function OemStringToAnsiString(Text: String): String;
var
  Buff: Array[0..256] of Char;
begin
  StrPCopy(Buff,Text);
  OemToChar(Buff,Buff);
  Result := StrPas(Buff);
end;

{-AnsiStringToOemString--------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert eine Windows-Ansi-String in einen
              Oem-Ascii-String.
 ------------------------------------------------------------}
function AnsiStringToOemString(Text: String): String;
var
  Buff: Array[0..256] of Char;
begin
  StrPCopy(Buff,Text);
  CharToOem(Buff,Buff);
  Result := StrPas(Buff);
end;

{-Encrypt----------------------------------------------------
  Parameter:  S: String     Der zu verschlüsselnde String
              Key: Word     Der zu verwendende Schlüssel
  Scope:      Public
  Funktion:   Verschlüsselt eine String.
  Beispiel:   S := Encrypt(S,12345)
 ------------------------------------------------------------}
function Encrypt(const S: String; Key: Word): String;
var
  I: byte;
begin
  SetLength(Result, Length(S));
  {Result[0] := S[0];}
  for I := 1 to Length(S) do
    begin
      Result[I] := char(byte(S[I]) xor (Key shr 8));
      Key := (byte(Result[I]) + Key) * Crypt1 + Crypt2;
    end;
end;

{-Decrypt----------------------------------------------------
  Parameter:  S: String     Der zu entschlüsselnde String
              Key: Word     Der beim Verschlüsseln verwendet
                            Schlüssel
  Scope:      Public
  Funktion:   Entschlüsselt eine String.
  Beispiel:   S := Decrypt(S,12345)
 ------------------------------------------------------------}
function Decrypt(const S: String; Key: Word): String;
var
  I: byte;
begin
  SetLength(Result, Length(S));
  {Result[0] := S[0];}
  for I := 1 to Length(S) do
    begin
      Result[I] := char(byte(S[I]) xor (Key shr 8));
      Key := (byte(S[I]) + Key) * Crypt1 + Crypt2;
    end;
end;


{$Q-}    //Overflow erlaubt
function EncryptNew(const InString: string): string;
var
  I, Key: integer;
begin
  Result := '';
  Key := StartKey;
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (Key shr 8));
    Key := (Byte(Result[I]) + Key) * MultKey + AddKey;
  end;
end;

function DecryptNew(const InString: string): string;
var
  I, Key: integer;
begin
  Result := '';
  Key := StartKey;
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (Key shr 8));
    Key := (Byte(InString[I]) + Key) * MultKey + AddKey;
  end;
end;

function EncryptPassw(const InString: string; Len: integer): string;
//Passwort als Hexstring der festen Länge <Len> verschlüsseln.
//Len muss mindestens 2*Länge von Passw haben. Ansonsten erfolgt Exception
var
  I: integer;
  S: string;
begin
  //if Len < length(InString) * 2 then
  //  EError('EncryptPassw: Len(%d) < %d', [Len, length(InString) * 2]);
  result := StrToHexStr(EnCryptNew(Format('%-*s', [Len div 2, InString])));
end;

function DecryptPassw(const InString: string): string;
//Passwort entschlüsseln. Muss mit EncryptPassw verschlüsselt worden sein.
begin
  result := Trim(DeCryptNew(HexStrToStr(InString)));
end;

function StrToHexStr(const InString: string): string;
//Umwandlung in lesbare Hex-Zeichen. Verdoppelt InString-Länge
var
  I: integer;
begin
  result := '';
  for I := 1 to Length(InString) do
    result := result + Format('%02.2X', [ord(InString[I])]);
end;

function HexStrToStr(const InString: string): string;
//Umwandlung von Hex- nach lesbaren Zeichen. Halbiert InString-Länge
var
  I, N: integer;
begin
  result := '';
  N := length(InString);
  I := 1;
  while I < N do
  begin
    result := result +
      chr(StrToIntDef('$' + InString[I] + InString[I + 1], ord('*')));
    I := I + 2;
  end;
end;


{-At---------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Erstes Auftreten eines Zeichens in einem
              String.
 ------------------------------------------------------------}
function At(SubStr: String; Str: String): Integer;
begin
  Result := Pos(SubStr, Str);
end;

{-RAt--------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Letztes Auftreten eines Zeichens in einem
              String.
 ------------------------------------------------------------}
function RAt(SubStr: String; Str: String): Integer;
var
  SuchLen, i: Integer;
begin
  SuchLen := Length(SubStr);
  Result := 0;
  for i := Length(Str)-SuchLen+1 downto 1 do
    if Copy(Str,i,SuchLen) = SubStr then
      begin
        Result := i;
        break;
      end;
end;

{************************************************************
 *  String zu Integer konvertieren ohne Exceptions
 ************************************************************}
function BGStrToInt(zahl: String): Integer;
begin
  zahl := AllTrim(zahl);
  if zahl = EmptyStr then
    Result := 0
  else if IsValidNumStr(zahl) then
    Result := StrToInt(zahl)
  else
    Result := 0;
end;

{-StringToFloatExt-------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert einen String in einen Fließkomma-
              wert, wenn der String keine Zahl darstellt,
              wird der Vorgabewert zurückgegeben und keine
              Exception erzeugt.
 ------------------------------------------------------------}
function StringToFloatExt(Zahl: String; Default: Extended;
  DecSep: Char): Extended;
var
  I, Code: Integer;
  Ergebnis: Extended;
begin
  Zahl := AllTrim(Zahl);
  for I := 1 to Length(Zahl) do
    begin
      if Zahl[I] = DecSep then Zahl[I] := '.';
    end;
  Val(Zahl,Ergebnis,Code);
  if Code <> 0 then
    Result := Default
  else
    Result := Ergebnis;
end;

{-StringToFloat----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert einen String in einen Fließkomma-
              wert, wenn der String keine Zahl darstellt,
              wird der Vorgabewert zurückgegeben und keine
              Exception erzeugt.
 ------------------------------------------------------------}
function StringToFloat(Zahl: String; Default: Extended): Extended;
var
  I, Code: Integer;
  Ergebnis: Extended;
begin
  Zahl := AllTrim(Zahl);
  for I := 1 to Length(Zahl) do
    begin
      if Zahl[I] = DecimalSeparator then Zahl[I] := '.';
    end;
  Val(Zahl,Ergebnis,Code);
  if Code <> 0 then
    Result := Default
  else
    Result := Ergebnis;
end;

{--------------------------------------------------------------------------------------------------}
function StringToFloatPoints (Zahl: String; sDecimalSep : string; Default  : Double)     : Double;
{--------------------------------------------------------------------------------------------------}
// Text in String umwandeln, dabei wir der der Decimalseperator ersetzt,
// wichtig wenn in der ein falsche Format / Ländereinstellung steht  
var
 I, Code: Integer;
 Ergebnis: Extended;
begin
 try
  Zahl := Trim(Zahl);
  if Zahl <> '' then
   begin
    for I := 1 to Length(Zahl) do
     begin
      //if Zahl[I] = '.' then Zahl[I] := DecimalSeparator;
      //if Zahl[I] = ',' then Zahl[I] := DecimalSeparator;

      if Zahl[I] = sDecimalSep then Zahl[I] := DecimalSeparator;
     end;
    try
     Result := StrToFloat(Zahl);
    except
     Result := Default;
    end;
   end
  else
   Result := Default;
 except
  Result := Default;
 end;
end;


{-StringToInteger--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert einen String in einen Integer, wenn
              der String keine Zahl darstellt, wird der
              Vorgabewert zurückgegeben und keine Exception
              erzeugt.
 ------------------------------------------------------------}
function StringToInteger(Zahl: String; Default: LongInt): LongInt;
var
  Code: Integer;
  Ergebnis: LongInt;
begin
  Result := Default;
  Val(AllTrim(Zahl),Ergebnis,Code);
  if Code <> 0 then
    Result := Default
  else
    Result := Ergebnis;
end;

{-GermanUpperCase--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt String in Großbuchstaben inkl. dt.
              Umlaute.
 ------------------------------------------------------------}
function GermanUpperCase(Text: String): String;
{
var
  Letter, German: String;
  i: Integer;
}
begin
  Result := AnsiUpperCase(Text);
{
  German := UpperCase(Text);
  for i := 1 to Length(German) do
    begin
      if German[i] = 'ä' then German[i] := 'Ä';
      if German[i] = 'ö' then German[i] := 'Ö';
      if German[i] = 'ü' then German[i] := 'Ü';
    end;
  Result := German;
}
end;

{-GermanLowerCase--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt String in Kleinbuchstaben inkl. dt.
              Umlaute.
 ------------------------------------------------------------}
function GermanLowerCase(Text: String): String;
{
var
  Letter,German: String;
  i: Integer;
}
begin
  Result := AnsiLowerCase(Text);
{
  German := LowerCase(Text);
  for i := 1 to Length(German) do
    begin
      if German[i] = 'Ä' then German[i] := 'ä';
      if German[i] = 'Ö' then German[i] := 'ö';
      if German[i] = 'Ü' then German[i] := 'ü';
    end;
  Result := German;
}
end;

{-TokenToStringList------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt durch ein beliebieges Zeichen getrennte
              Strings in eine String-Liste.
 ------------------------------------------------------------}
function TokenToStringList(S: String; Separator: Char; MinItems: Integer): TStringList;
const
  NonSeparator = '"';
var
  Strings: TStringList;
  Sub: String;
  i: Integer;
  Ausdruck: Boolean;
begin
  S := S+Separator;
  Strings := TStringList.Create;
  Sub := '';
  Ausdruck := false;
  for i := 1 to Length(S) do
    begin
      if S[i] = NonSeparator then
        Ausdruck := not Ausdruck;
      if S[i] = Separator then
        begin
          if Ausdruck then
            Sub := Sub+S[i]
          else
            begin
              Strings.Add(Sub);
              Sub := '';
            end;
        end
      else
        Sub := Sub+S[i];
    end;
  while Strings.Count < MinItems do Strings.Add('');
  Result := Strings;
end;

{-StringListToToken------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt eine String-Liste in einen durch
              beliebige Zeichen getrennten String.
 ------------------------------------------------------------}
function StringListToToken(S: TStringList; Separator: Char): String;
var
  i: Integer;
begin
  Result := '';
  if S.Count = 0 then exit;
  for i := 0 to S.Count-2 do
    Result := Result+S[i]+Separator;
  Result := Result+S[S.Count-1];
end;

{-CSSToStringList--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt durch Kommata getrennte Strings in
              eine String-Liste.
 ------------------------------------------------------------}
function CSStoStringList(S: String; MinItems: Integer): TStringList;
const
  Separator = ',';
  NonSeparator = '"';
var
  Strings: TStringList;
  Sub: String;
  i: Integer;
  Ausdruck: Boolean;
begin
  S := S+Separator;
  Strings := TStringList.Create;
  Sub := '';
  Ausdruck := false;
  for i := 1 to Length(S) do
    begin
      case S[i] of
        NonSeparator:
          Ausdruck := not Ausdruck;
        Separator:
          begin
            if Ausdruck then
              Sub := Sub+S[i]
            else
              begin
                Strings.Add(Sub);
                Sub := '';
              end;
          end;
      else
        Sub := Sub+S[i];
      end;
    end;
  while Strings.Count < MinItems do Strings.Add('');
  Result := Strings;
end;

{-StringListToCSS--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Wandelt eine String-Liste in durch Kommata
              getrennte Strings ("Comma Separated Strings").
 ------------------------------------------------------------}
function StringListToCSS(S: TStringList): String;
const
  Separator = ',';
var
  i: Integer;
begin
  Result := '';
  for i := 0 to S.Count-2 do
    Result := Result+S[i]+Separator;
  Result := Result+S[S.Count-1];
end;

{-SubStr-----------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   wie Copy(), Syntax Clipper-kompatibel.
 ------------------------------------------------------------}
function SubStr(S: String; Index: Integer; Count: Integer): String;
begin
  SubStr := Copy(S,Index,Count)
end;

{-RTrim------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Entfernt schließende Leerzeichen
 ------------------------------------------------------------}
function RTrim(cString: string): string;
begin
  Result := cString;
  if Length(cString) > 0 then
    begin
      while (Ord(Result[1]) > 0) and (Result[Ord(Result[1])] = ' ') do
        Result[1] := Chr(Ord(Result[1]) - 1);
    end;
end;

{-LTrim------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Entfernt schließende Leerzeichen
 ------------------------------------------------------------}
function LTrim(cString: string): string;
var
  startPos, endPos: integer;
begin
  startPos := 1;
  endPos   := Length(cString);
  while (startPos < Length(cString)) and (cString[startPos] = ' ') do
   Inc(startPos);
  if (endPos = startPos) and (cString[endPos] = ' ') then
    Result := ''
  else
    Result := Copy(cString, startPos, endPos-startPos+1);
end;

{-AllTrim----------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Entfernt führende und schließende Leerzeichen
 ------------------------------------------------------------}
function AllTrim(cString: string): string;
{
var
  startPos, endPos: integer;
}
begin
  Result := Trim(cString);
  (*
  startPos := 1;
  endPos   := Length(cString);
  while (startPos < Length(cString)) and (cString[startPos] = ' ') do
    Inc(startPos);
  while (endPos > startPos) and (cString[endPos] = ' ') do
    Dec(endPos);
  if (endPos = startPos) and (cString[endPos] = ' ') then
    Result := ''
  else
    Result := Copy(cString, startPos, endPos-startPos+1);
  *)
end;

{-TextTrim----------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Hängt bei einem nicht-leeren String ein
              Leerzeichen an.
 ------------------------------------------------------------}
function TextTrim(cString: String): String;
begin
{  if (Alltrim(cString)=EmptyStr) then Result:='' else Result:=Alltrim(cString)+' ';}
  if (Trim(cString)=EmptyStr) then
    Result := ''
  else
    Result := Trim(cString)+' ';
end;

{-PadRight---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Normiert einen String auf eine bestimmte Länge
              und fügt ggf. mit Leerzeichen auf.
 ------------------------------------------------------------}
function PadRight(cString: string; nLen: integer): string;
begin
  Result := PadR(cString,nLen);
end;

{-PadR-------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Normiert einen String auf eine bestimmte Länge
              und fügt ggf. mit Leerzeichen auf.
 ------------------------------------------------------------}
function PadR(cString: string; nLen: integer): string;
begin
  if (Length(cString) <> nLen) then
    begin
      if Length(cString) > nLen then
        Result := Copy(cString,1,nLen)
      else
        Result := cString + Space(nLen-Length(cString))
    end
  else
    Result := cString;
end;

{-PadLeft----------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Normiert einen String auf eine bestimmte Länge
              und fügt ggf. mit Leerzeichen auf.
 ------------------------------------------------------------}
function PadLeft(cString: string; nLen: integer): string;
begin
  Result := PadL(cString,nLen);
end;

{-PadL-------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Normiert einen String auf eine bestimmte Länge
              und fügt ggf. mit Leerzeichen auf.
 ------------------------------------------------------------}
function PadL(cString: string; nLen: integer): string;
begin
  if (Length(cString) <> nLen) then
    if Length(cString) > nLen then
      Result := Copy(cString,Length(cString)-nLen,nLen)
    else
      Result := Space(nLen-Length(cString)) + cString
  else
    Result := cString;
end;

{-Lower------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert eine String in Kleinbuchstaben.
  Anmerkung:  Clipper-kompatibel.
              Im Gegensatz zu LowerCase werden auch Umlaute
              konvertiert.
 ------------------------------------------------------------}
function Lower(const S: String): String;
begin
  Result := AnsiLowerCase(S);
end;

{-Upper------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert eine String in Großbuchstaben.
  Anmerkung:  Clipper-kompatibel.
              Im Gegensatz zu UpperCase werden auch Umlaute
              konvertiert.
 ------------------------------------------------------------}
function Upper(const S: String): String;
begin
  Result := AnsiUpperCase(S);
end;

{-Upper------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Ersetzt Teile in einer Zeichenkette durch ein andere
  Anmerkung:  Clipper-kompatibel.
 ------------------------------------------------------------}
function StrTran(const S: String; SeekStr, NewStr : string): String;
var
  Pos1, Pos2 : integer;
  S1, S2 : string;
begin
  if At(SeekStr,S) > 0 then
    begin
      Pos1 := At(SeekStr,S);
      Pos2 := Pos1 + Length(SeekStr);
      if Pos1 > 0 then S1 := LeftStr(S,Pos1-1)
      else S1 := '';
      if Pos2 < Length(S) then S2 := Copy(s,Pos2,Length(S)-Pos2+1)
      else S2 := '';
      Result := S1 + NewStr + S2;
    end
  else
    Result := S;
end;

{-LeftStr----------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt die ersten X Zeichen eines Strings zurück.
 ------------------------------------------------------------}
function LeftStr(cString: string; nLen: integer): string;
begin
  if nLen = 0 then
    Result := ''
  else if (Length(cString) > nLen) then
    Result := Copy(cString,1,nLen)
  else
    Result := cString;
end;

{-RightStr---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt die letzten X Zeichen eines Strings zurück.
 ------------------------------------------------------------}
function RightStr(cString: string; nLen: integer): string;
begin
  if nLen = 0 then
    Result := ''
  else if (Length(cString) > nLen) then
    Result := Copy(cString,Length(cString)-nLen+1, nLen)
  else
    Result := cString;
end;

{-Space------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt die gewünschte Anzahl von Leerzeichen
              zurück.
 ------------------------------------------------------------}
function Space(nLen: integer): string;
begin
  Result := Replicate(' ', nLen);
end;

{-Replicate--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt die gewünschte Anzahl eines Zeichens
              zurück.
 ------------------------------------------------------------}
function Replicate(c: char; nLen: integer): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to nLen do
    Result := Result + c;
end;

{-Empty------------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Überprüft ob ein String ein Leerstring ist.
              Als Leerstring gilt auch ein String, der aus
              Leerzeichen besteht.
 ------------------------------------------------------------}
function Empty(cString: string): boolean;
begin
  if Trim(cString) = '' then
    Result := true
  else
    Result := false;
end;


{--------------------------------------------------------------------------------------------------}
function FillWithZero (sInput : string; const iNormLen : integer) : string;
{--------------------------------------------------------------------------------------------------}
// Eingabestring wird auf die konstante Länge iStdLen gebracht.
// dabei werden dem Eingbenstring zuerst alle Leerzeichen entfernt
begin
 sInput := Trim(sInput);
 if sInput = '' then
   Result := ''
 else
 begin
   while length (sInput) < iNormLen do sInput := '0' + sInput;
   Result := sInput;
 end;
end;


{--------------------------------------------------------------------------------------------------}
function StripZeros   (sInput : string) : string;
{--------------------------------------------------------------------------------------------------}
//Führende Nullen löschen
var
  i: integer;
  bZero: Boolean;
begin
  bZero := true;
  Result := '';
  for i := 1 to Length(sInput) do
  begin
    if (bZero) and (sInput[i] = '0') then
    begin
    end else
    begin
      bZero := false;
      Result := Result + sInput[i];
    end;
  end;
end;


{-IsValidTimeStr---------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Überprüft ob ein String eine gültige Zeit ist.
  Anmerkung:  Eine gültige Zeit hat das Format: HH:MM.
 ------------------------------------------------------------}
function IsValidTimeStr(time: String): Boolean;
var
  std, min: Word;
  tmp: String;
begin
   if time = '' then
    begin
      Result := true;
      exit;
    end;

  if (Length(time) <> 5) and (Length(time) <> 8) then
    begin
      Result := false;
      exit;
    end;
    
  if SubStr(time,3,1) <> TimeSeparator then
    begin
      Result := false;
      exit;
    end;
  tmp := LeftStr(time,2);
  if not IsValidNumStr(tmp) then
    begin
      Result := false;
      exit;
    end;
  std := StrToInt(tmp);

  tmp := SubStr(time,4,2);
  if not IsValidNumStr(tmp) then
    begin
      Result := false;
      exit;
    end;
  min := StrToInt(tmp);

  if ((std < 0) or (std > 23)) then
    begin
      Result := false;
      exit;
    end;

  if ((min < 0) or (min > 59)) then
    begin
      Result := false;
      exit;
    end;
  Result := true;
end;

{-IsValidDateStr---------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Überprüft ob ein String ein gültiges Datum ist.
  Anmerkung:  Ein gültiges Datum hat das Format: TT.MM.JJJJ
              Es wird auch auf Schaltjahre geprüft.
 ------------------------------------------------------------}
function IsValidDateStr(datum: String): Boolean;
var
  tag,monat,jahr: Integer;
  tmp: String;
begin
   if datum = '' then
    begin
      Result := true;
      exit;
    end;
  if Length(datum) <> 10 then
    begin
      Result := false;
      exit;
    end;
  if ((SubStr(datum,3,1) <> DateSeparator) or (SubStr(datum,6,1) <> DateSeparator)) then
    begin
      Result := false;
      exit;
    end;
  tmp := LeftStr(datum,2);
  if not IsValidNumStr(tmp) then
    begin
      Result := false;
      exit;
    end;
  tag := StrToInt(tmp);

  tmp := SubStr(datum,4,2);
  if not IsValidNumStr(tmp) then
    begin
      Result := false;
      exit;
    end;
  monat := StrToInt(tmp);

  tmp := RightStr(datum,4);
  if not IsValidNumStr(tmp) then
    begin
      Result := false;
      exit;
    end;
  jahr := StrToInt(tmp);

  if ((monat < 1) or (monat > 12)) then
    begin
      Result := false;
      exit;
    end;

  if ((tag < 1) or (tag > DaysPerMonth(jahr,monat))) then
    begin
      Result := false;
      exit;
    end;
  Result := true;
end;

{-IsValidNumStr----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Überprüft ob ein String, ob er nur aus Ziffern
              besteht.
 ------------------------------------------------------------}
function IsValidNumStr(ziffer: String): Boolean;
var
  i: Integer;
begin
  Result := true;
  for i := 1 to Length(ziffer) do
    begin
      if not ( ziffer[i] in ['0'..'9'] ) then
        begin
          Result := false;
          exit;
        end;
    end;
end;

{-IsValidFloatStr--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Überprüft ob ein String, ob er nur aus Ziffern
              und einem Dezimalkomma besteht.
 ------------------------------------------------------------}
function IsValidFloatStr(ziffer: String): Boolean;
var
  i: Integer;
begin
  Result := true;
  for i := 1 to Length(ziffer) do
    begin
      if not ( ziffer[i] in ['0'..'9',DecimalSeparator] ) then
        begin
          Result := false;
          exit;
        end;
    end;
  if At(DecimalSeparator,ziffer) <> RAt(DecimalSeparator,ziffer) then
    Result := false; {Es ist mehr als ein Komma im String!}
end;

{-SplitDateToStrings-----------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Dekodiert eine Datumsvariable in Strings für
              Tag, Monat und Jahr. Tag und Monat werden ggf.
              mit führenden Nullen aufgefüllt.
 ------------------------------------------------------------}
procedure SplitDateToStrings(SplitDate: TDateTime; var Year, Month, Day: String);
var
  j,m,t: Word;
begin
  DecodeDate(SplitDate,j,m,t);
  Year := IntToStr(j);
  Month := IntegerToZeroString(m,2);
  Day := IntegerToZeroString(t,2);
end;

{-CurrentDay-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt den aktuellen Tag als String zurück.
 ------------------------------------------------------------}
function CurrentDayStr: String;
var
  Jahr, Monat, Tag: String;
begin
  SplitDateToStrings(Date, Jahr, Monat, Tag);
  Result := Tag;
end;

{-CurrentMonth-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt den aktuellen Monat als String zurück.
 ------------------------------------------------------------}
function CurrentMonthStr: String;
var
  Jahr, Monat, Tag: String;
begin
  SplitDateToStrings(Date, Jahr, Monat, Tag);
  Result := Monat;
end;

{-CurrentYearStr---------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt das aktuelle Jahr als String zurück.
 ------------------------------------------------------------}
function CurrentYearStr: String;
var
  Jahr, Monat, Tag: String;
begin
  SplitDateToStrings(Date, Jahr, Monat, Tag);
  Result := Jahr;
end;

{-CurrentDay-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt den aktuellen Tag als Word zurück.
 ------------------------------------------------------------}
function CurrentDay: Word;
var
  Jahr, Monat, Tag: Word;
begin
  DecodeDate(Date, Jahr, Monat, Tag);
  Result := Tag;
end;

{-CurrentMonth-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt den aktuellen Monat als Word zurück.
 ------------------------------------------------------------}
function CurrentMonth: Word;
var
  Jahr, Monat, Tag: Word;
begin
  DecodeDate(Date, Jahr, Monat, Tag);
  Result := Monat;
end;

{-CurrentYear------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt das aktuelle Jahr als Word zurück.
 ------------------------------------------------------------}
function CurrentYear: Word;
var
  Jahr, Monat, Tag: Word;
begin
  DecodeDate(Date, Jahr, Monat, Tag);
  Result := Jahr;
end;

{-IsLeapYear-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Überprüft ob ein Jahr ein Schaltjahr ist.
 ------------------------------------------------------------}
function IsLeapYear(AYear: Integer): Boolean;
begin
  Result := (AYear mod 4 = 0) and ((AYear mod 100 <> 0) or (AYear mod 400 = 0));
end;

{-YearOfDate-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt das Jahr eines Datums zurück.
 ------------------------------------------------------------}
function YearOfDate(D: TDateTime): Word;
var
  Year, Month, Day: Word;
begin
  DecodeDate(D,Year,Month,Day);
  Result := Year;
end;

{-MonthOfDate------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt den Monat eines Datums zurück.
 ------------------------------------------------------------}
function MonthOfDate(D: TDateTime): Word;
var
  Year, Month, Day: Word;
begin
  DecodeDate(D,Year,Month,Day);
  Result := Month;
end;

{-DayOfDate--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt den Tag eines Datums zurück.
 ------------------------------------------------------------}
function DayOfDate(D: TDateTime): Word;
var
  Year, Month, Day: Word;
begin
  DecodeDate(D,Year,Month,Day);
  Result := Day;
end;

{-DaysPerMonth-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Ermittelt die Tage des Monats x des Jahres y.
 ------------------------------------------------------------}
function DaysPerMonth(AYear, AMonth: Integer): Integer;
const
  DaysInMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := DaysInMonth[AMonth];
  if (AMonth = 2) and IsLeapYear(AYear) then Inc(Result);
end;

{-BeginOfYear------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Erster Tag des Monates.
 ------------------------------------------------------------}
function BeginOfYear(D: TDateTime): TDateTime;
var
  Year, Month, Day : Word;
begin
  DecodeDate(D,Year,Month,Day);
  Result := EncodeDate(Year,1,1);
end;

{-EndOfYear--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Letzter Tag des Jahres.
 ------------------------------------------------------------}
function EndOfYear(D: TDateTime): TDateTime;
var
  Year, Month, Day : Word;
begin
  DecodeDate(D,Year,Month,Day);
  Result := EncodeDate(Year,12,31);
end;

{-BeginOfMonth-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Erster Tag des Monates.
 ------------------------------------------------------------}
function BeginOfMonth(D: TDateTime): TDateTime;
var
  Year, Month, Day : Word;
begin
  DecodeDate(D,Year,Month,Day);
  Result := EncodeDate(Year,Month,1);
end;

{-EndOfMonth-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Letzter Tag des Monates.
 ------------------------------------------------------------}
function EndOfMonth(D: TDateTime): TDateTime;
var
  Year, Month, Day : Word;
begin
  DecodeDate(D,Year,Month,Day);
  if Month=12 then
    begin
      Inc(Year);
      Month := 1;
    end
  else
    Inc(Month);
  Result := EncodeDate(Year,Month,1)-1;
end;

{-BeginOfWeek------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Erster Tag der Woche (Montag).
 ------------------------------------------------------------}
function BeginOfWeek(D: TDateTime): TDateTime;
var
  Day: Word;
begin
  Day := DayOfWeek(D);
  case Day of
    1:  Result := Result - 6;
    2:  Result := D;
  else
    Result := D - (Day - 2);
  end;
end;

{-EndOfWeek--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Letzter Tag der Woche (Sonntag).
 ------------------------------------------------------------}
function EndOfWeek(D: TDateTime): TDateTime;
var
  Day: Word;
begin
  Day := DayOfWeek(D);
  case Day of
    1:  Result := D;
    2:  Result := Result + 6;
  else
    Result := D + (8 - Day);
  end;
end;

{-WeekOfYear-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Ermittelt die lfd. Wochenummer eines Datums.

  BG 10.08.00 baut das um
  Bemerkungen zur Berechnung der Wochennummer nach DIN 1355:
     Der Montag ist der erste Tag der Woche
     Eine Woche gehört zu demjenigen Kalenderjahr, in dem 3 oder mehr Tage der Woche liegen.
     Der Donnerstag einer Woche liegt immer in demjenigen Kalenderjahr, dem die Woche zugerechnet wird.
     Der 4. Januar liegt immer in der ersten Kalenderwoche.
     Der 28. Dezember liegt immer in der letzten Kalenderwoche.
 ------------------------------------------------------------}
function WeekOfYear(D: TDateTime): Integer;
const
  t1: Array[1..7] of ShortInt = ( -1,  0,  1,  2,  3, -3, -2);
  t2: Array[1..7] of ShortInt = ( -4,  2,  1,  0, -1, -2, -3);
  FirstWeekDay  : Integer = 2;  { Wochentag, mit dem die Woche beginnt }
  FirstWeekDate : Integer = 4;  { 1 : Beginnt am ersten Januar
                                   4 : Erste-4 Tage-Woche (nach DIN 1355)
                                   7 : Erste volle Woche }
var
  doy1, doy2: Integer;
  NewYear: TDateTime;
  AYear,AMonth,ADay : Word;
begin
  D:=D-((DayOfWeek(D)-FirstWeekDay+7) mod 7)+ 7-FirstWeekDate;
  DecodeDate(D,AYear,AMonth,ADay);
  Result:=(RTrunc(D-EncodeDate(AYear,1,1)) div 7)+1;
  
  exit;

  NewYear := BeginOfYear(D);
  doy1 := DayOfYear(D) + t1[DayOfWeek(NewYear)];
  doy2 := DayOfYear(D) + t2[DayOfWeek(D)];
  if doy1 <= 0 then
    Result := WeekOfYear(NewYear-1)
  else if (doy2 >= DayOfYear(EndOfYear(NewYear))) then
    Result:= 1
  else
    Result:=(doy1-1) div 7 + 1;
end;

{-DayOfYear--------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Ermittelt die lfd. Nr. eines Tages.
 ------------------------------------------------------------}
function DayOfYear(D: TDateTime): Word;
{var
  i,Year,Month,Day,DoY: Word;}
begin
{
  DecodeDate(D,Year,Month,Day);
  DoY := Day;
  for i := 1 to Month-1 do DoY := DoY+DaysPerMonth(Year,i);
  Result := DoY;
}
  Result := RTrunc(D-BeginOfYear(D))+1;
end;

{-IncMonth---------------------------------------------------
  Scope:      Public
  Funktion:   Addiert <Months> Monate zum Datum <ADate>.
 ------------------------------------------------------------}
function IncMonth(ADate: TDateTime; Months: Integer): TDateTime;
var
  Tag,Monat,Jahr: Word;
  PseudoMonat: LongInt;
begin
  DecodeDate(ADate,Jahr,Monat,Tag);
  PseudoMonat := (Jahr * 12) + Monat + Months - 1;
  Jahr := PseudoMonat div 12;
  Monat := PseudoMonat - (Jahr * 12) + 1;
  if Tag > DaysPerMonth(Jahr,Monat) then Tag := DaysPerMonth(Jahr,Monat);
  Result := EncodeDate(Jahr,Monat,Tag);
end;

{-DecMonth---------------------------------------------------
  Scope:      Public
  Funktion:   Subtrahiert <Months> Monate vom Datum <ADate>.
 ------------------------------------------------------------}
function DecMonth(ADate: TDateTime; Months: Integer): TDateTime;
var
  Tag,Monat,Jahr: Word;
  PseudoMonat: LongInt;
begin
  DecodeDate(ADate,Jahr,Monat,Tag);
  PseudoMonat := (Jahr * 12) + Monat - Months - 1;
  Jahr := PseudoMonat div 12;
  Monat := PseudoMonat - (Jahr * 12) + 1;
  if Tag > DaysPerMonth(Jahr,Monat) then Tag := DaysPerMonth(Jahr,Monat);
  Result := EncodeDate(Jahr,Monat,Tag);
end;

{-IncYear----------------------------------------------------
  Scope:      Public
  Funktion:   Addiert <Years> Jahre zum Datum <ADate>.
 ------------------------------------------------------------}
function IncYear(ADate: TDateTime; Years: Integer): TDateTime;
var
  Tag,Monat,Jahr: Word;
begin
  DecodeDate(ADate,Jahr,Monat,Tag);
  Inc(Jahr,Years);
  try
    Result := EncodeDate(Jahr,Monat,Tag)
  except
    //wenn diese Jahr ein Schaltjahr und im Februar dann knallt's
    if (Monat = 2) and (Tag = 29) then
      Result := EncodeDate(Jahr,Monat,Tag-1) //den 29.02.2005 gibt es nicht!!!
    else
      Result := EncodeDate(Jahr,Monat,1) //abfangen
  end;
end;

{-DecYear----------------------------------------------------
  Scope:      Public
  Funktion:   Subtrahiert <Years> Jahre vom Datum <ADate>.
 ------------------------------------------------------------}
function DecYear(ADate: TDateTime; Years: Integer): TDateTime;
var
  Tag,Monat,Jahr: Word;
begin
  DecodeDate(ADate,Jahr,Monat,Tag);
  Dec(Jahr,Years);
  try
    Result := EncodeDate(Jahr,Monat,Tag);
  except
    //wenn diese Jahr ein Schaltjahr und im Februar dann knallt's
    if (Monat = 2) and (Tag = 29) then
      Result := EncodeDate(Jahr,Monat,Tag-1) //den 29.02.2005 gibt es nicht!!!
    else
      Result := EncodeDate(Jahr,Monat,1) //abfangen
  end;
end;

{-EasterSunday-----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Ermittelt das Datum für den Ostersonntag.
 ------------------------------------------------------------}
function EasterSunday(ADate: TDateTime): TDateTime;
var
  Tag,Monat,Jahr: Word;
  a,b,c,d,e,m,n: Word;
begin
  Result := 0;
  DecodeDate(ADate,Jahr,Monat,Tag);

  if ((Jahr > 1699) and (Jahr < 2200)) then
    begin
      if ((Jahr > 1699) and (Jahr < 1800)) then
        begin
          m := 23;
          n := 3;
        end;
      if ((Jahr > 1799) and (Jahr < 1900)) then
        begin
          m := 23;
          n := 4;
        end;
      if ((Jahr > 1899) and (Jahr < 2100)) then
        begin
          m := 24;
          n := 5;
        end;
      if ((Jahr > 2099) and (Jahr < 2200)) then
        begin
          m := 24;
          n := 6;
        end;
      a := Jahr mod 19;
      b := Jahr mod 4;
      c := Jahr mod 7;
      d := (19*a+m) mod 30;
      e := (2*b+4*c+6*d+n) mod 7;
      Tag := 22+d+e;
      Monat := 3;
      if Tag > 31 then
        begin
          Tag := d+e-9;
          Monat := 4;
          if Tag = 26 then
            Tag := 19
          else
            if ((Tag=25) and (d=28) and (a>10)) then Tag := 18;
        end;
      Result := EncodeDate(Jahr,Monat,Tag);
    end;
end;

{-Seconds----------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Ermittelt die Anzahl der Sekunden seit Mitter-
              nacht.
  Anmerkung:  Clipper-kompatibel.
 ------------------------------------------------------------}
function Seconds(Time: TDateTime): LongInt;
var
  Hour,Min,Sec,MSec: Word;
begin
  DecodeTime(Time,Hour,Min,Sec,MSec);
  Result := LongInt(Sec)+(LongInt(Min)*60)+(LongInt(Hour)*3600);
end;

{-Seconds----------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Gibt die Millisekunden zurück
  Anmerkung:  Clipper-kompatibel.
 ------------------------------------------------------------}
function MilliSeconds (dTime : TDateTime): Word;
var
  Hour,Min,Sec,MSec: Word;
begin
  DecodeTime(dTime,Hour,Min,Sec,MSec);
  Result := MSec;
end;

{-NormalizeDirectory-----------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Stellt sicher, daß eine Verzeichnisangabe
              immer mit "\" endet.
 ------------------------------------------------------------}
procedure NormalizeDirectory(var Directory: String);
begin
  if Directory <> '' then
    begin
      if RightStr(Directory,1) <> BackSlash then
       Directory := Directory+BackSlash;
    end;
end;

{-NormalizeFileExtension-------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Stellt sicher, daß eine Dateierweiterung
              immer mit einem "." beginnt und nur drei
              Zeichen lang ist.
 ------------------------------------------------------------}
procedure NormalizeFileExtension(var Extension: String);
begin
  if Extension[1] <> '.' then
    Extension := '.'+LeftStr(Extension,3)
  else
    Extension := LeftStr(Extension,4);
end;

{-ExtractBasePath--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Ermittelt das Basisverzeichnis eines
              Verzeichnispfades.
 ------------------------------------------------------------}
function ExtractBasePath(const Path: String): String;
var
  I, Start: Integer;
begin
  Result := '';
  if Path[Length(Path)] = BackSlash then
    Start := Length(Path) - 1
  else
    Start := Length(Path);
  for I := Start downto 1 do
    begin
      if Path[I] = BackSlash then
        begin
          Result := LeftStr(Path,I-1);
          Break;
        end;
    end;
end;

{-AppendExePath----------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Erzeugt einen kompletten Dateinamen aus dem
              übergebenen Dateiname und dem Pfad der
              aktuellen Exedatei.
 ------------------------------------------------------------}
function AppendExePath(Filename: String): String;
begin
  Result := AppendPath(ExtractFilePath(Application.Exename),Filename);
end;

{-AppendExtension--------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   ergänzt die Extension, wenn noch nicht da
 ------------------------------------------------------------}
function AppendExtension(Filename,Extension: String): String;
begin
  if Length(Filename) >= Length(Extension) then
    begin
      Extension := PadRight(Extension,3);
      if UpperCase(RightStr(Filename,3)) <> UpperCase(Extension) then
        Result := Filename + '.' + Extension
      else
      Result := Filename;
    end
  else
    Result := Filename + '.' + Extension
end;

{-AppendPath-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Erzeugt aus einem Pfad- und einem Dateinamen
                 einen String
 ------------------------------------------------------------}
function AppendPath(Path, Filename: String): String;
begin
  if Path <> '' then
    begin
      if RightStr(Path,1) = BackSlash then
       Result := Path+Filename
      else
       Result := Path+BackSlash+Filename;
    end
  else
    Result := FileName;
end;

{-CreateBackupFilename---------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Erzeugt einen Dateinamen für eine Sicherheits-
              kopie nach der Regel Dateiname.~Erweiterung.
              "text.stx" -> "text.~st"
 ------------------------------------------------------------}
function CreateBackupFilename(Filename: String): String;
var
  S: String;
begin
  S := ExtractFileExt(Filename);
  case Length(S) of
    1: S := ChangeFileExt(Filename,'.~');
    2: S := ChangeFileExt(Filename,'.~'+S[2]);
  else
    S := ChangeFileExt(Filename,'.~'+S[2]+S[3]);
  end;
  Result := S;
end;

{-BackupFile-------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Erstellt eine Sicherheitskopie einer Datei.
 ------------------------------------------------------------}
procedure BackupFile(Filename: String);
begin
  if FileExists(Filename) then BGCopyFile(Filename,CreateBackupFilename(Filename),false,false);
end;

(*
procedure CopyFileExt(const FileName, Destination: TFileName;
  Append, Melde: Boolean);
var
  Wait: TWaitMessage;
  CopyBuffer: Pointer; { buffer for copying }
  TimeStamp, BytesCopied, Copied, MaxBytes: Longint;
  Multiplier: Real;
  Source, Dest, Progress: Integer; { handles }
  S: String;
const
  ChunkSize: Longint = 8192; { copy in 8K chunks }
begin
  MaxBytes := GetFileSize(Filename);
  Multiplier := 100 / MaxBytes;
  Copied := 0;

  GetMem(CopyBuffer, ChunkSize); { allocate the buffer }
  try
    Source := FileOpen(FileName, fmShareDenyWrite); { open source file }
    if Source < 0 then raise EFOpenError.Create(FmtLoadStr(SFOpenError, [FileName]));
    try
      if FileExists(Destination) and Append then
        begin
          Dest := FileOpen(Destination, fmOpenReadWrite or fmShareExclusive); { open output file }
          if Dest < 0 then raise EFOpenError.Create(FmtLoadStr(SFOpenError, [FileName]));
          FileSeek(Dest,0,2);
        end
      else
        begin
          Dest := FileCreate(Destination); { create output file }
          if Dest < 0 then raise EFCreateError.Create(FmtLoadStr(SFCreateError, [Destination]));
        end;
      try
         Screen.Cursor := crHourGlass;
         if melde then Wait := WaitMessage(Application.Title,
           'Datei wird kopiert.'#10'Bitte warten...');
        repeat
          BytesCopied := FileRead(Source, CopyBuffer^, ChunkSize); { read chunk }
          if BytesCopied > 0 then { if we read anything... }
            FileWrite(Dest, CopyBuffer^, BytesCopied); { ...write chunk }

          Copied := Copied + BytesCopied;

        until BytesCopied < ChunkSize; { until we run out of chunks }
      finally
         if melde then Wait.Free;
         Screen.Cursor := crDefault;
        FileClose(Dest); { close the destination file }
      end;
    finally
      FileClose(Source); { close the source file }
    end;
  finally
    FreeMem(CopyBuffer, ChunkSize); { free the buffer }
  end;
end;
*)

{-GetFileSize------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Größe einer Datei in Bytes ermitteln
 ------------------------------------------------------------}
function GetFileSize(AFilename: String): LongInt;
var
  SearchRec: TSearchRec;
begin
  FindFirst(AFilename,0,SearchRec);
  Result := SearchRec.Size;
  SysUtils.FindClose(SearchRec);
end;

{-GetFileAttributes------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Attribute einer Datei in Bytes ermitteln
 ------------------------------------------------------------}
function GetFileAttributes(AFilename: String): TFileAttributes;
var
  SearchRec: TSearchRec;
begin
  Result := [];
  FindFirst(AFilename,0,SearchRec);
  if SearchRec.Attr and Sysutils.faReadOnly  > 0 then Include(Result,fatReadOnly);
  if SearchRec.Attr and Sysutils.faHidden    > 0 then Include(Result,fatHidden);
  if SearchRec.Attr and Sysutils.faSysFile   > 0 then Include(Result,fatSysFile);
  if SearchRec.Attr and Sysutils.faVolumeID  > 0 then Include(Result,fatVolumeID);
  if SearchRec.Attr and Sysutils.faDirectory > 0 then Include(Result,fatDirectory);
  if SearchRec.Attr and Sysutils.faArchive   > 0 then Include(Result,fatArchive);
  SysUtils.FindClose(SearchRec);
end;

{-GetFileDate------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Datum und Uhrzeit einer Datei ermitteln
 ------------------------------------------------------------}
function GetFileDate(AFilename: String): TDateTime;
var
  SearchRec: TSearchRec;
begin
  FindFirst(AFilename,0,SearchRec);
  Result := FileDateToDateTime(SearchRec.Time);
  SysUtils.FindClose(SearchRec);
end;

{-CopyFile---------------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Was wird eine Dateikopier-Routine schon tun?
 ------------------------------------------------------------}
function BGCopyFile(Source, Dest: String; bFailExists, bMelde: Boolean): Boolean;
var
 PStr1,PStr2 : PChar;
begin
 try
  PStr1 := StrAlloc(250 * SizeOf(Char));
  PStr2 := StrAlloc(250 * SizeOf(Char));
  StrPCopy(PStr1,Source);
  StrPCopy(PStr2,Dest);
  Application.ProcessMessages;
  if bMelde then
   begin
    if not FileExists(Source) then Meldung('Fehler beim Kopieren der Datei! Die Quelldatei "' + Source + '" exisitert nicht!',mtFehler,[mebOk],0);
   end;
  Result := CopyFile(PStr1,PStr2,bFailExists);
  if not Result then
   begin
    if bFailExists and bMelde then Meldung('Fehler beim Kopieren der Datei! Die Zieldatei "' + Dest + '" exisitert bereits!',mtFehler,[mebOk],0);
   end;
  Application.ProcessMessages;
  StrDispose(PStr1);
  StrDispose(PStr2);
 except
  if bMelde then Meldung('Unbekannter Fehler beim Kopieren der Datei!',mtFehler,[mebOk],0);
 end;
end;

{-CreateUniqueFileName---------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Erzeugt einen eindeutigen Dateinamen mit
              einem max. 2 Zeichen langen Präfix.
  Anmerkung:  Es wird nur der Dateiname mit Extension aber
              ohne Verzeichnis zurückgegeben. Wenn kein
              Dateiname ermittelt werden konnte wird
              ein Leerstring zurückgegeben.
 ------------------------------------------------------------}
function CreateUniqueFileName(Directory, Prefix, Extension: String): String;
(*
var
  x, y, max: LongInt;
  i: Integer;
begin
  NormalizeDirectory(Directory);
  NormalizeFileExtension(Extension);
  Prefix := LeftStr(Prefix,3);
  x := Seconds(Time);
  y := x;
  max := 1;
  for i := 2 to (8-Length(Prefix)) do
    max := max * 10;

  while FileExists(Directory+Prefix+IntegerToZeroString(x,8-Length(Prefix))+Extension) do
    begin
      Inc(x);
      if x >= max then x := 0;
      if x = y then
        begin
          { alle Dateinamen belegt! }
          Result := '';
          exit;
        end;
    end;

  Result := Prefix+IntegerToZeroString(x,8-Length(Prefix))+Extension;
end;
*)
const
  Letters: String[36] = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  Y,M,D,H,N,S,MS: Word;
  Abbr: Boolean;
begin
  NormalizeDirectory(Directory);
  NormalizeFileExtension(Extension);
  Prefix := LeftStr(Prefix,2);

  DecodeDate(Date,Y,M,D);
  DecodeTime(Time,H,N,S,MS);
  Result := Prefix+Chr(48+((Y mod 1000) mod 10))+Letters[M]+Letters[D]+
    Letters[H]+Letters[N div 2]+Letters[S div 2]+Extension;

  Abbr := false;
  while FileExists(AppendPath(Directory,Result)) do
    begin
      Inc(S);
      if S > 59 then
        begin
          S := 0;
          Inc(N);
        end;
      if N > 59 then
        begin
          S := 0;
          N := 0;
          Inc(H);
        end;
      if H > 23 then
        begin
          if Abbr then
            begin
              Result := '';
              Break;
            end;
          Abbr := true;
          S := 0;
          N := 0;
          H := 0;
          Inc(D);
        end;
      Result := Prefix+Chr(48+((Y mod 1000) mod 10))+Letters[M]+Letters[D]+
        Letters[H]+Letters[N div 2]+Letters[S div 2]+Extension;
    end;
end;

{-ByteSizeAsString-------------------------------------------
  Parameter:  siehe Deklaration
  Scope:      Public
  Funktion:   Konvertiert eine Byte-Angabe in einen String,
              der je nach Größe die Zahl als Byte, KB, MB
              oder GB darstellt..
 ------------------------------------------------------------}
function ByteSizeAsString(Value: Longint): String;
  function FltToStr(F: Extended): String;
  begin
    Result := FloatToStrF(Round(F),ffNumber,6,0);
  end;
begin
  if Value > GByte then
    Result := FltTostr(Value / GByte)+' GB'
  else if Value > MByte then
    Result := FltToStr(Value / MByte)+' MB'
  else if Value > KByte then
    Result := FltTostr(Value / KByte)+' KB'
  else
    Result := FltTostr(Value) +' Byte';
end;

{-SleepSec---------------------------------------------------
  Parameter:  Secs: Integer   Sekunden
  Scope:      Public
  Funktion:   Legt das Programm für <Secs> Sekunden schlafen.
 ------------------------------------------------------------}
procedure SleepSec(Secs: Integer);
var
  WaitUntil: TDateTime;
begin
  WaitUntil := Now + ( Secs / 86400 );
  while Now < WaitUntil do
    begin
     Application.ProcessMessages;
      {nix außer gar nix};
    end;
end;

{-Pause---------------------------------------------------
  Parameter:  Secs: Integer   MilliSekunden
  Scope:      Public
  Funktion:   Legt das Programm für <MilliSecs> MilliSekunden schlafen.
 ------------------------------------------------------------}
procedure Pause(MilliSecs: Integer);
var
  WaitUntil: TDateTime;
begin
  WaitUntil := Now + ( MilliSecs / (86400 * 1000));
  while Now < WaitUntil do
    begin
     Application.ProcessMessages;
      {nix außer gar nix};
    end;
end;

{-CommandLineOptionExt---------------------------------------
  Parameter:  keine
  Scope:      Public
  Funktion:   Stellt fest ob eine Option als Kommando-
                 zeilenparameter übergeben wurde.
 ------------------------------------------------------------}
function CommandLineOptionExt(const Switch: String;
  var Option: String; Charcase: TCharCase): Boolean;
var
  I: Integer;
begin
  Result := false;
  Option := '';
  for I := 1 to ParamCount do
  begin
    if LeftStr(UpperCase(ParamStr(I)),Length(Switch)) = UpperCase(Switch) then
    begin
      try
        Result := true;
        Break;
        { ???
        if ParamStr(I)[Length(Switch)+1] = ':' then
          Option := RestStr(ParamStr(I),Length(Switch)+2)
        else
          Option := RestStr(ParamStr(I),Length(Switch)+1);
          Result := true;
          Break;
        }
      except
      end;
    end;
  end;
  if Result then
  begin
    case CharCase of
      ccUpperCase:  Option := AnsiUpperCase(Option);
      ccLowerCase:  Option := AnsiLowerCase(Option);
    end;
  end;
end;

{-CommandLineOption------------------------------------------
  Parameter:  keine
  Scope:      Public
  Funktion:   Stellt fest ob eine Option als Kommando-
                 zeilenparameter übergeben wurde.
 ------------------------------------------------------------}
function CommandLineOption(const Switch: String; var Option: String): Boolean;
begin
  Result := CommandLineOptionExt(Switch,Option,ccUpperCase);
end;

{-CommandLineSwitch------------------------------------------
  Parameter:  keine
  Scope:      Public
  Funktion:   Stellt fest ob ein Schalter als Kommando-
                 zeilenparameter übergeben wurde.
 ------------------------------------------------------------}
function CommandLineSwitch(const Switch: String): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 1 to ParamCount do
    if UpperCase(ParamStr(I)) = UpperCase(Switch) then
      begin
        Result := true;
        Exit;
      end;
end;

{-InitConstants----------------------------------------------
  Parameter:  keine
  Scope:      Private
  Funktion:   Setzt globale Variablen.
 ------------------------------------------------------------}
procedure InitConstants;
const
  WF_WINNT = $4000;
var
  Jahr, Monat, Tag: Word;
  Dos, Win: Word;
  Major, Minor: Byte;
begin
  DatePicShort  := '99'+DateSeparator+'99'+DateSeparator+'99';
  DatePicLong   := '99'+DateSeparator+'99'+DateSeparator+'9999';
  TimePicShort  := '99'+TimeSeparator+'99';
  TimePicLong   := '99'+TimeSeparator+'99'+TimeSeparator+'99';
  DateEpochBase := 19;
  DecodeDate(Date, Jahr, Monat, Tag);
  DateEpochYear := Jahr-(DateEpochBase*100)+6;
  if DateEpochYear >= 100 then Dec(DateEpochYear,100);

  { Windows-Version feststellen }
  (*
  if (GetWinFlags and WF_WINNT) > 0 then
    WindowsVersion := wvWindowsNT
  else
    begin
      Win := ((GetVersion shl 16) shr 16);
      Dos := (GetVersion shr 16);
      Major := ((Win shl 8) shr 8);
      Minor := (Win shr 8);
      if Major = 3 then
        case Minor of
          10,11:
            begin
              WindowsVersion := wvWindows31;
            end;
          95:
            begin
              Minor := ((Dos shl 8) shr 8);
              Major := (Dos shr 8);
              case Minor of
                0:  WindowsVersion := wvWindows95;
                10: WindowsVersion := wvWindows98;
              end;
            end;
        else
          WindowsVersion := wvUnknown;
        end
      else
        WindowsVersion := wvUnknown;
    end;
  *)
{
  if (GetVersion and $FF00) >= $5F00 then
    WindowsVersion := wvWindows95
  else if (GetVersion < $80000000) then
    WindowsVersion := wvWindowsNT
  else
    WindowsVersion := wvWindows31;
}
end;


{------------------------------------------------------------------------------}

function PruefzifferMod10(Zaehlnummer: String): Integer;
var
  Produkt: String;
  Quersumme, Addition, i, j: Integer;
begin
  Addition := 0;
  for i := 1 to Length(Zaehlnummer) do
    begin
      Quersumme := 0;
      Produkt := IntToStr(StrToInt(Zaehlnummer[i]) * MaxInteger((i mod  2) * 2, 1));
      for j := 1 to Length(Produkt) do Quersumme := Quersumme + StrToInt(Produkt[j]);
      Addition := Addition + Quersumme;
    end;
  Result := (Addition mod 10);
end;

{------------------------------------------------------------------------------}


{-ExpandAdresse----------------------------------------------------------------}
function ExpandAdresse(s : string) : string;
begin
  Result := s;
  s := UpperCase(Alltrim(s));
  if Length(s) < 3 then
    begin
      if s = 'H' then Result := 'Herrn'
      else
        if s = 'F' then Result := 'Frau'
          else
            if s = 'FA' then Result := 'Firma';
    end;
end;

{-Eurofunktionen---------------------------------------------------------------}
function DM2Euro(DM : Extended) : Extended;
begin
  Result := FloatRound(DM / RatioDM2Euro,2);
end;

function Euro2DM(Euro : Extended) : Extended;
begin
  Result := FloatRound(Euro * RatioDM2Euro,2);
end;


{--------------------------------------------------------------------------------------------------}
function GetWindowsVersion : string;
{--------------------------------------------------------------------------------------------------}
// Windows-Version ermitteln
var
 OsVinfo   : TOSVERSIONINFO;
 HilfStr   : array[0..50] of Char;
begin
 try
  ZeroMemory(@OsVinfo,sizeOf(OsVinfo));
  OsVinfo.dwOSVersionInfoSize := sizeof(TOSVERSIONINFO);
  if GetVersionEx(OsVinfo) then
   begin
    if OsVinfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS then
     begin
      if (OsVinfo.dwMajorVersion = 4) and
         (OsVinfo.dwMinorVersion > 0) then
       begin
        StrFmt (HilfStr, 'Windows 98 - Version %d.%.2d.%d',
               [OsVinfo.dwMajorVersion, OsVinfo.dwMinorVersion,
               OsVinfo.dwBuildNumber AND $FFFF])
       end
      else
       begin
        StrFmt (HilfStr, 'Windows 95 - Version %d.%d Build %d',
               [OsVinfo.dwMajorVersion, OsVinfo.dwMinorVersion,
               OsVinfo.dwBuildNumber AND $FFFF]);
       end;
     end;
    if OsVinfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
     begin
      if (OsVinfo.dwMajorVersion >= 5) and
         (OsVinfo.dwMinorVersion >= 0) then
       begin
        StrFmt (HilfStr, 'Microsoft Windows 2000 Version %d.%.2d.%d',
               [OsVinfo.dwMajorVersion, OsVinfo.dwMinorVersion,
               OsVinfo.dwBuildNumber AND $FFFF]);
       end
      else
       begin
        StrFmt (HilfStr, 'Microsoft Windows NT Version %d.%.2d.%d',
               [OsVinfo.dwMajorVersion, OsVinfo.dwMinorVersion,
               OsVinfo.dwBuildNumber AND $FFFF]);
       end;
     end;
   end
  else StrCopy(HilfStr, 'Fehler bei GetversionEx()!');
  Result := string(HilfStr);
 except
  Result := 'unknown';
 end;
end;

{--------------------------------------------------------------------------------------------------}
function IsWindowsNT : boolean;
{--------------------------------------------------------------------------------------------------}
// scheuen, ob es Win NT oder Win 2000 ist
var
 OsVinfo   : TOSVERSIONINFO;
begin
 ZeroMemory(@OsVinfo,sizeOf(OsVinfo));
 OsVinfo.dwOSVersionInfoSize := sizeof(TOSVERSIONINFO);
 if GetVersionEx(OsVinfo) then Result:= (OsVinfo.dwPlatformId = VER_PLATFORM_WIN32_NT)
                           else Result:=false;
end; 

{--------------------------------------------------------------------------------------------------}
function WindowsProductID : string;
{--------------------------------------------------------------------------------------------------}
// die Registriernummer von Windows
var
 Reg : TRegistry;
 Res : boolean;
begin
 Reg := TRegistry.Create;
 try
  Reg.Rootkey := HKEY_LOCAL_MACHINE;
  if IsWindowsNT then Res := Reg.OpenKey ('SOFTWARE\Microsoft\Windows NT\CurrentVersion', false)
                 else Res := Reg.OpenKey ('SOFTWARE\Microsoft\Windows\CurrentVersion', false);
  if Res then
   begin
    Result := Reg.ReadString ('ProductId');
    Reg.CloseKey;
   end
  else
   Result := '0';                                                                                   // keine Rechte
 finally
  Reg.Free;
 end;
end;

{--------------------------------------------------------------------------------------------------}
function WindowsOwner      : string;
{--------------------------------------------------------------------------------------------------}
// die registrierte Eigentümer von Windows
var
 Reg : TRegistry;
 Res : boolean;
begin
 Reg:=TRegistry.Create;
  try
   Reg.Rootkey := HKEY_LOCAL_MACHINE;
   if IsWindowsNT then Res := Reg.OpenKey ('SOFTWARE\Microsoft\Windows NT\CurrentVersion', false)
                  else Res := Reg.OpenKey ('SOFTWARE\Microsoft\Windows\CurrentVersion', false);
   if Res then
    begin
     Result := Reg.ReadString ('RegisteredOwner');
     Reg.CloseKey;
    end
   else Result:='0';
  finally
   Reg.Free;
  end;
end;

{--------------------------------------------------------------------------------------------------}
function VolumeID(DriveChar: Char): string;
{--------------------------------------------------------------------------------------------------}
//Name des Laufwerks, z.B. "System"
var
  OldErrorMode      : Integer;
  NotUsed, VolFlags : DWORD;
  Buf               : array [0..MAX_PATH] of Char;
begin
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    GetVolumeInformation(PChar(DriveChar + ':\'), Buf,
                         sizeof(Buf), nil, NotUsed, VolFlags,
                         nil, 0);
    Result := Format('[%s]',[Buf]);
  finally
    SetErrorMode(OldErrorMode);
  end;
end;

{--------------------------------------------------------------------------------------------------}
function CollectPCIdentInfos  (sSerial : string): string;
{--------------------------------------------------------------------------------------------------}
const
 csDummy = '0708293349';
//Sucht einige PC-spezifische Informationen zusammen und gibt diese als CRC-String zurück
var
 sIdent : string;
 lpVolNameBuf   : array [0..32] of char;
 lpFileNameBuf  : array [0..32] of char;
 ipVolSerial    : pdWord;
 ipMaxCompLen   : dword;
 ipFileSystFlg  : dWord;
 sWindowsSN     : string;
begin
 GetMem (ipVolSerial, 16);
 if GetVolumeInformation ('c:\', lpVolNameBuf, 30, ipVolSerial, ipMaxCompLen, ipFileSystFlg, lpFileNameBuf, 30) then
  sIdent := IntToStr (ipVolSerial^)
 else
  sIdent := csDummy;                                                                                // Die eigene Telnummer als Ersatz nehmen
 sWindowsSN := WindowsProductID;                                                                    // Die WinSerienummer
 Result     := sIdent + sWindowsSN + sSerial;                                                       // Damit auch bei der Installation zweier Versionen auf der selben Platte Unterschiede gemacht werden können
 FreeMem (ipVolSerial, 16);
end;

{--------------------------------------------------------------------------------------------------}
function GetIpAddress: string;
{--------------------------------------------------------------------------------------------------}
//die eigene IP-Adresse im Netz
var phoste: PHostEnt;
  Buffer: array [0..100] of char;
  WSAData: TWSADATA;
begin
  result := '';
  if WSAStartup($0101, WSAData) <> 0 then
    exit;
  GetHostName(Buffer,Sizeof(Buffer));
  phoste:=GetHostByName(buffer);
  if phoste = nil then
    result:='127.0.0.1'
  else
    result:=StrPas(inet_ntoa(PInAddr(phoste^.h_addr_list^)^));
  WSACleanup;
end;

{--------------------------------------------------------------------------------------------------}
function GetComputerNetName: string;
{--------------------------------------------------------------------------------------------------}
//den eigenen Namen im Netz herausfinden
var
  buffer: array[0..255] of char;
  size: dword;
begin
  size := 256;
  if GetComputerName(buffer, size) then
    Result := buffer
  else
    Result := '';
end;



{--------------------------------------------------------------------------------------------------}
function StrToCRC (In_CRC : string) : integer;
{--------------------------------------------------------------------------------------------------}
{Converts a standard string into a CRC number and returns that value}
var
 CRC  : array [0..1000] of byte;
 Akku : integer;
 i    : word;
 LookUp    : TLookUp;                                                                               // Tabelle für CRC-Summenberechnung
begin
 InitLookUp (LookUp);
 fillchar (CRC, sizeof (CRC), 0);
 for i := 1 to length (In_CRC) do CRC [pred (i)] := ord (In_CRC [i]);
 Akku := LookUp [CRC [0]];
 for i := 0 to pred (length (In_CRC)) do Akku := (Akku shl 8) xor
                                                  LookUp [hi (Akku) xor CRC [succ(i)]];
 Result := Akku;
end;

{----------------------------------------------------------------------------}
function MAKE_CRCSTR (In_CRC : string) : string;
{----------------------------------------------------------------------------}
{ CRC-Summe aus dem übergebenen String berechnen und als fix 5-stellig formatierten String zurückgeben
  25.05.00 BG : - das fix 5-stellig wird wieder abgeschafft
                - es wird jetzt 8-stellig zurückgegeben
}

var iCRC : integer;
    sDummy : string;
begin
 try
  iCRC := StrToCRC (In_CRC);
  sDummy := IntToHex (iCRC, 8);
 except
  sDummy := 'CRCERROR';
 end;
  Result := sDummy;
end;

{----------------------------------------------------------------------------}
function Prepare_CRCSTR (In_CRC : string) : string;
{----------------------------------------------------------------------------}
{ 25.05.00 BG : neu gebaut, um Eingansstrings von Make_CRCSTR gleich zu behandlen
}
begin
 Result := UpperCase(Trim(In_CRC));
end;

{--------------------------------------------------------------------------------------------------}
procedure InitLookUp (var LookUp : TLookUp);
{--------------------------------------------------------------------------------------------------}
{ Tabelle für die CRC-Summe initialisieren }
var
 i    : 0..7;
 j, k : byte;
 r    : integer;

begin
 fillchar (LookUp, sizeof (LookUp), 0);
 LookUp [0] := 0; r := -$8000;
 for i := 0 to 7 do begin
                     k := 1 shl i;
                     if r < 0 then r := (r shl 1) xor ciPoly
                              else r := r shl 1;
                     for j := 0 to pred (k) do
                      LookUp [k + j] := abs (r xor LookUp [j]);
                    end;
end;

{--------------------------------------------------------------------------------------------------}
function DuplicateTableRecord (Table : TuTable) : Boolean;
{--------------------------------------------------------------------------------------------------}
// Datensatz in der übergebenen Table duplizieren
// Das Ergebnis der Funktion beschreibt ob es geklappt hat
const
  max       = 100;                                                                                  // max 100 Felder sind möglich
var
  BufArray : array[0..max] of PChar;
  MS       : array[0..max] of TMemoryStream;
  iCnt       : Integer;
begin
 try
  Screen.Cursor := crHourGlass;
  for iCnt := 0 to max do MS[iCnt] := TMemoryStream.Create;                                         // für alle Stream anlegen
  for iCnt := 0 to Table.FieldCount-1 do
   begin                                                                                            // bisherigen Datensatz kopieren
    GetMem(BufArray[iCnt],Table.Fields[iCnt].DataSize);
    Table.Fields[iCnt].GetData(BufArray[iCnt]);
    if (Table.Fields[iCnt].DataType = ftBlob)     or
       (Table.Fields[iCnt].DataType = ftMemo)     or
       (Table.Fields[iCnt].DataType = ftGraphic)  or
       (Table.Fields[iCnt].DataType = ftFmtMemo)  then
     begin
      TBlobField(Table.Fields[iCnt]).SaveToStream(MS[iCnt]);
     end;
   end;

  Table.Insert;                                                                                     // neuer Datensatz
  for iCnt := 0 to Table.FieldCount-1 do
   begin                                                                                            // in neuen Datensatz einfügen
    if Table.Fields[iCnt].DataType <> ftAutoInc then
     begin
      Table.Fields[iCnt].SetData(BufArray[iCnt]);
      FreeMem(BufArray[iCnt],Table.Fields[iCnt].DataSize);
     end;
    if (Table.Fields[iCnt].DataType = ftBlob)     or
       (Table.Fields[iCnt].DataType = ftMemo)     or
       (Table.Fields[iCnt].DataType = ftGraphic)  or
       (Table.Fields[iCnt].DataType = ftFmtMemo) then
     begin
      TBlobField(Table.Fields[iCnt]).LoadFromStream(MS[iCnt]);
     end;
   end;
 finally
  for iCnt := 0 to max do MS[iCnt].Free;
 end;
 Screen.Cursor := crDefault;
end;


{--------------------------------------------------------------------------------------------------}
function FieldTypeToStr (DataType: TFieldType) : string;
{--------------------------------------------------------------------------------------------------}
// Feldtyp als string zurückgeben
begin
 case DataType of
  ftUnknown	: Result := 'ftUnknown';                                                            //Unbekannt oder nicht festgelegt
  ftString	: Result := 'ftString';                                                             //Zeichen- oder String-Feld
  ftSmallint	: Result := 'ftSmallint';                                                           //16-Bit-Integer-Feld
  ftInteger	: Result := 'ftInteger';                                                            //32-Bit-Integer-Feld
  ftWord	: Result := 'ftWord';                                                               //Vorzeichenloses 16-Bit-Integer-Feld
  ftBoolean	: Result := 'ftBoolean';                                                            //Boolesches Feld
  ftFloat	: Result := 'ftFloat';                                                              //Gleitkommafeld
  ftCurrency	: Result := 'ftCurrency';                                                           //Währungsfeld
  ftBCD	        : Result := 'ftBCD';                                                                //BCD-Feld
  ftDate	: Result := 'ftDate';                                                               //Datumsfeld
  ftTime	: Result := 'ftTime';                                                               //Zeitfeld
  ftDateTime	: Result := 'ftDateTime';                                                           //Datums-/Zeitfeld
  ftBytes	: Result := 'ftBytes';                                                              //Feste Anzahl von Bytes (binäre Speicherung)
  ftVarBytes	: Result := 'ftVarBytes';                                                           //Variable Anzahl von Bytes (binäre Speicherung)
  ftAutoInc	: Result := 'ftAutoInc';                                                            //32-Bit-Integer-Zählerfeld
  ftBlob	: Result := 'ftBlob';                                                               //BLOB-Feld
  ftMemo	: Result := 'ftMemo';                                                               //Memofeld
  ftGraphic	: Result := 'ftGraphic';                                                            //Bitmap-Feld
  ftFmtMemo	: Result := 'ftFmtMemo';                                                            //Formatiertes Memofeld
  ftParadoxOle	: Result := 'ftParadoxOle';                                                         //Paradox-OLE-Feld
  ftDBaseOle	: Result := 'ftDBaseOle';                                                           //dBASE-OLE-Feld
  ftTypedBinary	: Result := 'ftTypedBinary';                                                        //Typisiertes Binärfeld
  ftCursor	: Result := 'ftCursor';                                                             //Ausgabe-Cursor einer gespeicherten Oracle-Prozedur (nur TParam)
  ftFixedChar	: Result := 'ftFixedChar';                                                          //Festes Zeichenfeld
  ftWideString	: Result := 'ftWideString';                                                         //Wide String-Feld
  ftLargeInt	: Result := 'ftLargeInt';                                                           //Large Integer-Feld
  ftADT	        : Result := 'ftADT';                                                                //Abstract Data Type-Feld
  ftArray	: Result := 'ftArray';                                                              //Array-Feld
  ftReference	: Result := 'ftReference';                                                          //REF-Feld
  ftDataSet	: Result := 'ftDataSet';                                                            //DataSet-Feld
  ftOraBlob	: Result := 'ftOraBlob';                                                            //BLOB-Felder in Oracle 8-Tabellen
  ftOraClob	: Result := 'ftOraClob';                                                            //CLOB-Felder in Oracle 8-Tabellen
  ftVariant	: Result := 'ftVariant';                                                            //Daten eines unbekannten oder nicht festgelegten Typs
  ftInterface	: Result := 'ftInterface';                                                          //Referenzen auf Schnittstellen (IUnknown)
  ftIDispatch	: Result := 'ftIDispatch';                                                          //Referenzen auf IDispatch-Schnittstellen
  ftGuid	: Result := 'ftGuid';                                                               //GUID-Werte (Globally Unique Identifier)
 else
  MessageDlg ('Fehler in der Funktion FieldTypeToStr.', mtError, [mbOk], 0);
 end;
end;

{Protokoll}
{--------------------------------------------------------------------------------------------------}
function GetProt0File: string;
{--------------------------------------------------------------------------------------------------}
//aktuelles Protokollfile zurückgeben
const
  csPre = 'LOG';
  csExt = '.LOG';
  csPath = 'Prot\Log\';
var
  sFile, sPath, sDateTime: string;
begin
  sPath := ExtractFilePath(Application.ExeName);
  sPath := AppendPath(sPath, csPath);
  ForceDirectories(sPath);
  sFile := csPre + CurrentDayStr + csExt;
  sFile := AppendPath(sPath, sFile);
  Result := sFile;
end;

{--------------------------------------------------------------------------------------------------}
function Prot0(s: string): string;
{--------------------------------------------------------------------------------------------------}
//in Protokolldatei schreiben
var
  sFile, sDateTime, sText: string;
  F: TextFile;
begin
  try
    sFile := GetProt0File;
    AssignFile(F, sFile);
    if FileExists(sFile) then
    begin
      if Abs(GetFileDate(sFile) - Date) < 2 then
        Append(F) //Datei ist in diesem Monat erstellt
      else
        Rewrite(F); // alte Datei überschreiben
    end else
      Rewrite(F);
    sDateTime := DateToString(Date) + ' ' + TimeToStrSec(Time);
    if Trim(s) <> '' then //BG050504: Neu: Trick um Protokolldatei immer aktuell zu halten
    begin
      sText := sDateTime + ' ' + s;
      Writeln(F, sText);
    end;
    CloseFile(F);
    if wSpy <> nil then
      wSpy.ProtL(sText);
    Result := sText;
  except
  end;
end;

{--------------------------------------------------------------------------------------------------}
function GetErr0File: string;
{--------------------------------------------------------------------------------------------------}
//aktuelles Fehlerfile zurückgeben
const
  csPre = 'ERR';
  csExt = '.LOG';
  csPath = 'Prot\Error\';
var
  sFile, sPath, sDateTime: string;
begin
  sPath := ExtractFilePath(Application.ExeName);
  sPath := AppendPath(sPath, csPath);
  ForceDirectories(sPath);
  sFile := csPre + CurrentDayStr + csExt;
  sFile := AppendPath(sPath, sFile);
  Result := sFile;
end;

{--------------------------------------------------------------------------------------------------}
function Err0(s: string): string;
{--------------------------------------------------------------------------------------------------}
//in Fehlerdatei schreiben
var
  sFile, sDateTime, sText: string;
  F: TextFile;
begin
  try
    sFile := GetErr0File;
    AssignFile(F, sFile);
    if FileExists(sFile) then
    begin
      if Abs(GetFileDate(sFile) - Date) < 2 then
        Append(F) //Datei ist in diesem Monat erstellt
      else
        Rewrite(F); // alte Datei überschreiben
    end else
      Rewrite(F);
    sDateTime := DateToString(Date) + ' ' + TimeToStrSec(Time);
    if Trim(s) <> '' then //BG050504: Neu: Trick um Protokolldatei immer aktuell zu halten
    begin
      sText := sDateTime + ' ' + s;
      Writeln(F, sText);
    end;
    CloseFile(F);
    if wSpy <> nil then
      wSpy.ProtE(sText);
    Result := sText;
  except
  end;
end;

{============================================================
 I N I T I A L I Z A T I O N
 ============================================================}
initialization
  InitConstants;
end.

