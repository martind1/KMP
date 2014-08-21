unit nstr_Kmp;

(* Hilfsfunktionen zur Stringbehandlung
   und SQL Generierung
   24.03.98 MD '_' im Sql kein Platzhalter mehr. Jetzt nur noch '?'
   03.03.99    '{}' ohne select zu Beginn ist komplette SQL-Anweisung
   22.01.00    Access Datum jetzt RequestLive fähig !
   29.05.00    TranslateSql erfolg blockweise: ..abc;..ABC;..Abc  works!
   29.05.00    Rechnen mit Parametern:   (:WERT - 2) * 3 + 2      works!
   05.03.01    (a,b,c) ==> in (a,b,c)    mit Komma trennen und '(',')' verwenden
   20.04.01    DateToSql
   08.05.01    Filter mit '%' erzeugen keine Uper/Lower - Varianten mehr
   15.03.03    Zahlen: am Ende können mehrere '?' stehen. 12??? -> 12000..12999
   28.01.04    todo:Memos nur mit like oder is [not] null
   10.05.04    '^' ergibt upper(Field)=Upper(Value) (ReadOnly wird auf true gesetzt)
   15.10.04    Numerischen Suchwert erzwingen: '#' voranstellen (#123). Auch für Gen_Kmp.
   30.10.04    globales not mit '!': f=!a;b;c -> not (f=a or f=b or f=c)
   18.12.06    'Gmbh & Co' OK (Blank oder Alphanumerisches Zeichen nach '&' trennt nicht)
   23.09.08    MSSQL: SUBSTRING generiert kein 'group by' mehr -> DPos_Kmp.AggrInLine.NoList
   09.11.08    MSSQL: cast() generiert kein 'group by' mehr -> DPos_Kmp.AggrInLine.NoList
   11.12.09    DropFltrChr
   26.12.11    hasfltrchar
   18.02.12    Suche variieren auch nach Umlauten Ü<->UE
   06.06.12    Bug TrimParenthesis wenn Len > 9999    (jetzt bis 999999)
   12.07.12    SysYear

   <>{select ...}   Operator (<>, >, =, ...) verwenden

   { Sysdate-1  geht das?}

   Die speziellen Zeichen :, &und #erlauben es jedem Benutzer, die WHERE-Bedingung zu verändern

*)

interface

uses
  DB, SysUtils,
  Prots;  //CharSet

function Trim0(S: string): string; { return a string with leading '0' removed }
function LTrimCh(S: string; Ch: Char): string; { return a string with leading ch removed }
function LTrim(S: string): string; { return a string with leading spaces removed }
function RTrimCh(S: string; Ch:Char): string; { return a string with trailing ch removed }
function RTrim(S: string): string; { return a string with leading spaces removed }
function TrimCh(S: string; Ch: Char): string; { return a string with leading and trailing ch removed }
function Trim(S: string): string; { return a string with leading and trailing spaces removed }
//mehrere Characters:
function RTrimChs(S: string; Chs: TSysCharSet): string; { return a string with trailing chs removed }
//Ansi:
function LTrimChA(S: AnsiString; Ch: AnsiChar): AnsiString;
function RTrimChA(S: AnsiString; Ch: AnsiChar): AnsiString;
function TrimChA(S: AnsiString; Ch: AnsiChar): AnsiString;
function RTrimA(S: AnsiString): AnsiString;
function LTrimA(S: AnsiString): AnsiString;
function TrimA(S: AnsiString): AnsiString;
function Trim0A(S: AnsiString): AnsiString;
//sonst:
function RPadCh(S: string; Ch: Char; Len: integer): string; { return a string right padded to length len with ch }
function RPad(S: string; Len: integer): string; { return a string right padded to length len with spaces }
function LPadCh(S: string; Ch: Char; Len: integer): string; { return a string left padded to length len with ch }
function LPad(S: string; Len: integer): string; { return a string left padded to length len with spaces }
function CenterCh(S: string; Ch: Char; Width: integer): string; { return a string centered with ch with width }
function Center(S: string; Width: integer): string; { return a string centered in spaces with width }
function EmptyCh(S: string; Ch: Char): Boolean; { return true if only ch in string or null else false }
function Empty(S: string): Boolean; { return true if only space in string or null else false }
function Replicate(Ch: Char; Len: integer): string; { return a string filled with ch to len }
function WhiteSpaceCh(S: string; Ch: Char): integer; { return number of Ch to left of S }
function WhiteSpace(S: string): integer; { return number of spaces to left of S }
function AmpersandToTilde(S: string): string; { replace first &[ch] with ~[ch]~ }
function CharSetToStr(aCharSet: TSysCharSet): string;  //ergibt String mit allen Zeichen in CharSet
function FirstUp(S: string): string; // erstes Zeichen in Großschrift, Rest in Klein

(* word/substring manupilation *)

function WordCount(S: string; Delims: TSysCharSet): Byte; { return number of words in s delimited by delims }
function WordPosition(N: Byte; S: string; Delims: TSysCharSet): Byte; { return position to n th word in s delimited by delims }
function ExtractWord(N: Byte; S: string; Delims: TSysCharSet): string; { return the n th word in s delimited by delims }

(* decimal number conversion *)

function atoi(S: string): Integer; { return integer value of string S }
function itoa(I: Integer): string; { return string of integer I }
function atol(S: string): longint; { return longint value of string S }
function ltoa(L: longint): string; { return string of longint L }
function ator(S: string): Real;    { return real value of string S }
function rtoa(R: Real; W, D: Integer): string; { return string of real R }
function atow(S: string): Word;    { return word value of string S }
function wtoa(W: Word): string;    { return string of word W }

(* SQL generate used by Query-by-example *)

const
  OptTokens : TSysCharSet = ['=', '<', '>', '~'];  {* ? .. nein, wie %}
  BlockTrenner : TSysCharSet = ['|',';','&'];
  BetweenTrenner : TSysCharSet = ['~'];
  SysDates: array[1..3] of string = ('sysdate', 'heute', 'today');

function RestrictSqlLine(const S: string; MaxLen: integer): string; //Splittet Src in mehrere Zeilen die kürzer als MaxLen Zeichen sind
function TrimParenthesis(const S: string): string;
function TranslateSql(const Src: string): string;
function HasFltrChr(const S: string): boolean;
function DropFltrChr(const S: string): string;  // entfernt alle Filterzeichen
function DateToSql(ADate: TDateTime): string;
function TranslateSqlOpn(Opn: string; DataType: TFieldType): string;
// Übersetzt konstante Operanden typbezogen nach SQL (z.B. 3,5 nach 3.5).
//   Exception bei Fehler (z.B. falsches Datum)
function UmlautCase(S: string; Umlaut: boolean): string;
//Wandelt Umlaute um, so dass nach 'Ö' oder 'OE' gesucht werden kann
function GenerateSQL(const Source: string; const ColumnName: string;
                     const ColumnType: TFieldType; var ReadOnly: boolean;
                     AswNr: integer; var SQL: string): boolean;

implementation

uses
  WinProcs, Forms, Classes,
  Asws_Kmp, Err__Kmp;

{                                 }
{ general purpose string routines }
{                                 }

function CharSetToStr(aCharSet: TSysCharSet): string;
//ergibt String mit allen Zeichen in CharSet
var
  ch: AnsiChar;
begin
  result := '';
  for ch := low(AnsiChar) to high(AnsiChar) do  //#0 to #255
    if CharInSet(ch, aCharSet) then
      result := result + String(ch);
end;

function FirstUp(S: string): string; // erstes Zeichen in Großschrift, Rest in Klein
var
  I: integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    if I = 1 then
      Result := AnsiUpperCase(S[I]) else
      Result := Result + AnsiLowerCase(S[I]);
end;

function Trim0(S: string): string;
{ return a string with leading '0' removed }
begin
  Result := LTrimCh(S, '0');
end;

function LTrimCh(S: string; Ch: Char): string;
{ return a string with leading ch removed }
var
  I: integer;
begin
  I:=1;
  while (I <= length(S)) and (S[I] = Ch) do inc(I);
  Result :=Copy(S, I, length(S) - I + 1)
end;

function LTrim(S: string): string;
{ return a string with leading spaces removed }
begin
  Result :=ltrimCh(S, ' ')
end;

function RTrimCh(S: string; Ch:Char): string;
{ return a string with trailing ch removed }
var
  I: integer;
begin
  I:=length(S);
  while (I > 0) and (S[I] =Ch) do
  begin
    Delete(S, I, 1);
    Dec(I);
  end;
  Result :=S
end;

function RTrim(S: string): string;
{ return a string with leading spaces removed }
begin
  Result :=rtrimCh(S, ' ')
end;

function TrimCh(S: string; Ch: Char): string;
{ return a string with leading and trailing ch removed }
begin
  Result :=ltrimCh(rtrimCh(S, Ch), Ch)
end;

function Trim(S: string): string;
{ return a string with leading and trailing spaces removed }
begin
  Result := rtrim(ltrim(S))
end;

{ mehrere Characters }

function RTrimChs(S: string; Chs: TSysCharSet): string; { return a string with trailing chs removed }
var
  I: Integer;
begin  //abgeleitet von SysUtils
  I := Length(S);
  if (I > 0) and not CharInSet(S[I], Chs) then Exit(S);
  while (I > 0) and CharInSet(S[I], Chs) do Dec(I);
  Result := Copy(S, 1, I);
end;

{ Ansi }

function LTrimChA(S: AnsiString; Ch: AnsiChar): AnsiString;
{ return a string with leading ch removed }
var
  I: integer;
begin
  I := 1;
  while (I <= length(S)) and (S[I] = Ch) do
    Inc(I);
  Result := Copy(S, I, length(S) - I + 1);
end;

function RTrimChA(S: AnsiString; Ch: AnsiChar): AnsiString;
{ return a string with trailing ch removed }
var
  I: integer;
begin
  I := length(S);
  while (I > 0) and (S[I] =Ch) do
  begin
    Delete(S, I, 1);
    Dec(I);
  end;
  Result := S;
end;

function TrimChA(S: AnsiString; Ch: AnsiChar): AnsiString;
{ return a string with leading and trailing ch removed }
begin
  Result :=LTrimChA(RTrimChA(S, Ch), Ch)
end;

function RTrimA(S: AnsiString): AnsiString;
{ return a string with leading spaces removed }
begin
  Result :=RTrimChA(S, ' ')
end;

function LTrimA(S: AnsiString): AnsiString;
{ return a string with leading spaces removed }
begin
  Result :=LTrimChA(S, ' ')
end;

function TrimA(S: AnsiString): AnsiString;
{ return a string with leading and trailing spaces removed }
begin
  Result := RTrimA(LTrimA(S))
end;

function Trim0A(S: AnsiString): AnsiString;
{ return a string with leading '0' removed }
begin
  Result := LTrimChA(S, '0');
end;

{ sonst }

function RPadCh(S: string; Ch: Char; Len: integer): string;
{ return a string right padded to length len with ch }
var
  I: integer;
begin
  if Len > Length(S) then
  begin
    result := Format('%s%*s', [S, Len - Length(S), ' ']);
    if Ch <> ' ' then
      for I := Length(S) + 1 to Len do
        result[I] := Ch;
  end else
    Result := S;  //17.05.13
  (*result := S;
  for I:= length(S) to Len do
    result := result + Ch;    Leak*)
end;

function RPad(S: string; Len: integer): string;
{ return a string right padded to length len with spaces }
begin
  Result := rpadCh(S, ' ', Len)
end;

function LPadCh(S: string; Ch: Char; Len: integer): string;
{ return a string left padded to length len with ch }
var
  I: integer;
begin
  if Len > Length(S) then
  begin
    result := Format('%*s%s', [Len - Length(S), ' ', S]);
    if Ch <> ' ' then
      for I := 1 to Len - Length(S) do
        result[I] := Ch;
  end else
    Result := S;  //Bug fehlte bis 17.05.13
  (*result := '';
  for I:= length(S) to Len do
    result := result + ' ';
  result := result + S;*)
end;

function LPad(S: string; Len: integer): string;
{ return a string left padded to length len with spaces }
begin
  Result :=lpadCh(S, ' ', Len)
end;

function CenterCh(S: string; Ch: Char; Width: integer): string;
{ return a string centered in ch with width }
var
  I: integer;
begin
  S:=trim(S);
  if length(S) > Width then
     Result := S else
  begin
    I:=(Width - length(S)) div 2;
    {Result:=replicate(Ch, I) + S + replicate(Ch, Width - (I + length(S)))}
    Result:= Format('%s%s%s', [replicate(Ch, I), S, replicate(Ch, Width - (I + length(S)))]);
  end
end;

function Center(S: string; Width: integer): string;
{ return a string centered in spaces with width }
begin
  Result :=centerCh(S, ' ', Width)
end;

function EmptyCh(S: string; Ch: Char): Boolean;
{ return true if only ch in string else false }
begin
  Result :=length(trimCh(S, Ch)) = 0
end;

function Empty(S: string): Boolean;
{ return true if only spaces in string else false }
begin
  Result :=emptyCh(S, ' ')
end;

function Replicate(Ch: Char; Len: integer): string;
{ return a string filled with ch to len }
var
  I: integer;
begin
  result := Format('%*s', [Len, ' ']);
  if Ch <> ' ' then
    for I:= 1 to Len do
      result[I] := ch;
  (* Leak
  result := '';
  for I:= 1 to Len do
    result := result + Ch;   {' ';}
  *)
end;

function WhiteSpaceCh(S: string; Ch: Char): integer;
{ return number of Ch to left of S }
var
  I, N: integer;
begin
  I:=1;
  N:=0;
  while S[I] = Ch do
  begin
    inc(N);
    inc(I)
  end;
  Result :=N
end;

function WhiteSpace(S: string): integer;
{ return number of spaces to left of S }
begin
  Result :=WhiteSpaceCh(S, ' ')
end;

function AmpersandToTilde(S: string): string;
{ replace first &[ch] with ~[ch]~ }
var
  P: integer;
begin
  Result :=S;
  P:=Pos('&', S);
  if P = 0 then Exit;
  S[P]:='~';
  Insert('~', S, P + 2);
  Result :=S
end;

{                             }
{ word/substring manupilation }
{                             }

function WordCount(S: string; Delims: TSysCharSet): Byte;
{ return number of words in s delimited by delims }
var
  Count: Byte;
  I: integer;
  Len: integer;
begin
  Count:=0;
  Len:=length(S);
  I:=1;
  while I <=Len do
  begin
    while (I <=Len) and CharInSet(S[I], Delims) do Inc(I);
    if I <=Len then Inc(Count);
    while (I <=Len) and not CharInSet(S[I], Delims) do Inc(I)
  end;
  Result :=Count;
end;

function WordPosition(N: Byte; S: string; Delims: TSysCharSet): Byte;
{ return position to n th word in s delimited by delims }
var
  Count: Byte;
  I: integer;
  Len: integer;
begin
  Count:=0;
  Len:=length(S);
  I:=1;
  Result:=0;
  while (I <=Len) and (Count <> N) do
  begin
    while (I <=Len) and CharInSet(S[I], Delims) do Inc(I);
    if I <=Len then Inc(Count);
    if Count <> N then
      while (I <=Len) and not CharInSet(S[I], Delims) do Inc(I)
    else
      Result:=I
  end
end;

function ExtractWord(N: Byte; S: string; Delims: TSysCharSet): string;
{ return the n th word in s delimited by delims }
var
  I1, I2: Byte;
  SLen: integer;
begin
  result := '';
  SLen := length(S);
  I1 := WordPosition(N, S, Delims);
  if I1 <> 0 then
  begin
    I2 := I1;
    while (I2 <= SLen) and not CharInSet(S[I2], Delims) do
    begin
      {result := result + S[I];}
      Inc(I2)
    end;
    result := copy(S, I1, I2 - I1);
  end;
end;
{                           }
{ decimal number conversion }
{                           }

function atoi(S: string): Integer;
{ return integer value of string S }
var
  I, Er: Integer;
begin
  val(trim(S), I, Er);
  if Er <> 0 then I:=0;
  Result:=I
end;

function itoa(I: Integer): string;
{ return string of integer I }
begin
  Result := IntToStr(I);
end;

function atol(S: string): longint;
{ return longint value of string S }
var
  L: longint;
  Er: Integer;
begin
  val(trim(S), L, Er);
  if Er <> 0 then L:=0;
  Result:=L
end;

function ltoa(L: longint): string;
{ return string of longint L }
begin
  //Str(L, Result);
  Result := IntToStr(L);
end;

function ator(S: string): Real;
{ return real value of string S }
var
  R: Real;
  Er: integer;
begin
  val(trim(S), R, Er);
  if Er <> 0 then R:=0;
  Result:=R
end;

function rtoa(R: Real; W, D: Integer): string;
{ return string of real R }
var
  S: String[80];
begin
  str(R:W:D, S);
  Result := String(S);
end;

function atow(S: string): Word;
{ return word value of string S }
var
  I: Word;
  Er: Integer;
begin
  val(trim(S), I, Er);
  if Er <> 0 then I:=0;
  atow:=I
end;

function wtoa(W: Word): string;
{ return string of word W }
begin
//  Str(W, Result);
  Result := IntToStr(W);
end;

function DateToSql(ADate: TDateTime): string;
var
  C1: char;
  DateFmt: string;
begin
  if SysParam.DbSqlDatum <> '' then
    DateFmt := SysParam.DbSqlDatum else      {Y2000 für Oracle}
  if SysParam.SqlDatum <> '' then
    DateFmt := SysParam.SqlDatum else
    DateFmt := FormatSettings.ShortDateFormat;
  C1 := char1(DateFmt);
  if CharInSet(C1, ['''', '"']) then                {Access: ohne '' 280398 !}
    result := Format('%s%s%s', [C1, FormatDateTime(copy(DateFmt, 2,
      length(DateFmt) - 2), ADate), C1]) else
    result := FormatDateTime(DateFmt, ADate);
end;

{                                       }
{ SQL generate used by Query-by-example }
{                                       }

function TrimParenthesis(const S: string): string;
//entfernt unnötige rund Klammern
//Bug wenn Len>9999 (D.Format war 4stellig)
var
  L, K, D: TStringList;
  StackIndex: integer;
  K1A, K1E, K2A, K2E: integer;
  I: integer;
  IsProt: boolean;
  procedure Push(I: integer);
  begin
    StackIndex := L.Add(IntToStr(I));
  end;
  procedure Complete(I: integer);
  begin
    if StackIndex >= 0 then
    begin
      K.Add(L[StackIndex] + '=' + IntToStr(I));
      {if SysParam.ProtBeforeOpen then
        ProtA('K%d(%s)', [K.Count - 1, K[K.Count - 1]]);}
      L.Delete(StackIndex);
    end;
    Dec(StackIndex);
  end;
begin
  result := S;
  IsProt := false;  //SysParam.ProtBeforeOpen;
  //Prot0('TrimParenthesis(%s)', [S]);
  L := TStringList.Create;
  K := TStringList.Create;
  D := TStringList.Create;
  try
    StackIndex := -1;
    for I := 1 to length(S) do
    begin
      if S[I] = '(' then
        Push(I) else
      if S[I] = ')' then
        Complete(I);
    end;
    for I := 0 to K.Count - 2 do
    begin
      K1A := StrToInt(StrParam(K[I]));
      K1E := StrToInt(StrValue(K[I]));
      K2A := StrToInt(StrParam(K[I+1]));
      K2E := StrToInt(StrValue(K[I+1]));
      if (K2A = K1A - 1) and (K2E = K1E + 1) then
      begin
        D.Add(Format('%06.6d', [K2A]));
        if IsProt then
          ProtA('D%d(%s)', [D.Count - 1, D[D.Count - 1]]);
        D.Add(Format('%06.6d', [K2E]));
        if IsProt then
          ProtA('D%d(%s)', [D.Count - 1, D[D.Count - 1]]);
      end;
    end;
    if D.Count > 0 then
    begin
      D.Sort;
      for I := D.Count - 1 downto 0 do
      begin
        if IsProt then
          ProtA('D(%d,1)(%s)', [I, D[I]]);
        Delete(result, StrToInt(D[I]), 1);
      end;
      if IsProt then
        Prot0('TrimParenthesis(%s):%s', [S, Result]);
    end;
  finally
    L.Free;
    K.Free;
    D.Free;
  end;
end;

function RestrictSqlLine(const S: string; MaxLen: integer): string;
(* Splittet S in mehrere Zeilen die kürzer als MaxLen Zeichen sind *)
const
  Toks: array[1..4] of string = (' and ', ' or ', ' when ', ',');

  function MaxPos(S: string): integer;
  var
    I, J: integer;
    //I1: integer;
    Quote1, Quote2: boolean;
  begin
    Result := 0;
    Quote1 := false;
    Quote2 := false;
    for I := 1 to length(S) do
    begin
      case S[I] of
        '''': Quote1 := not Quote1;
        '"':  Quote2 := not Quote2;
      else
        if not Quote1 and not Quote2 then
        begin
          for J := low(Toks) to high(Toks) do
          begin
            if BeginsWith(Copy(S, I, MaxInt), Toks[J], true) then
            begin
              Result := I;
              if Length(Toks[J]) = 1 then
                Result := Result + Length(Toks[J]);
            end;
          end;
        end;
      end;
    end;
    (* vor 30.07.10
    for I := low(Toks) to high(Toks) do
    begin
      I1 := PosRI(Toks[I], S);
      if Length(Toks[I]) = 1 then
        I1 := I1 + Length(Toks[I]);  //',' soll am Zeilenende stehen
      Result := IMax(Result, I1);
    end;
    *)
  end;

var
  S1, NextS: string;
  P1: integer;
  Zugabe: integer;
begin
  result := '';
  S1 := PStrTok(S, CRLF, NextS);
  while S1 <> '' do
  begin
    while length(S1) > MaxLen do
    begin
      {P1 := IMax(PosRI(' and ', copy(S1, 1, MaxLen)),
                 PosRI(' or ', copy(S1, 1, MaxLen))); }
      Zugabe := 0;
      repeat
        P1 := MaxPos(copy(S1, 1, MaxLen));
        Zugabe := Zugabe + 8;
      until (MaxLen + Zugabe >= Length(S1) + 8) or (P1 > 0);
      if P1 = 1 then
      begin   //beginnt genau mit Trenntokens. Nächstes Auftreten positionieren
        Zugabe := 0;
        repeat
          P1 := MaxPos(copy(S1, 2, MaxLen));
          Zugabe := Zugabe + 8;
        until (MaxLen + Zugabe >= Length(S1) + 8) or (P1 > 0);
        if P1 > 0 then
          P1 := P1 + 1;
      end;
      if P1 = 0 then
      begin
        //result := S;   //String zwischen and/or ist zu lang
        //Prot0('Fehler bei RestrictSqlLine(%.240s~):%d', [S, length(S)]);
        //Exit;  //Fehler
        AppendTok(result, S1, CRLF);
        S1 := '';
      end else
      begin
        AppendTok(result, copy(S1, 1, P1 - 1), CRLF);
        S1 := copy(S1, P1, MaxInt);
      end;
    end;
    AppendTok(result, S1, CRLF);
    S1 := PStrTok('', CRLF, NextS);
  end;
end;

function TranslateSql(const Src: string): string;
(* Übersetzt Alternative Metazeichen in originäre *)
var
  P1, P2, Step: integer;

  function TranslateS(S: string): string;
  var
    P, L: integer;
  begin                    {Behandlung eines ;Blocks;}
    result := StringReplace(S, '::', '..', [rfReplaceAll]);  //'::' bringt BDE zum Absturz
    L := length(result);
    P := Pos('..', result);
    while P > 0 do
    begin
      if (P = 1) or                         {<>..a  ->  <>%a%}
         ((P = 3) and (copy(result, 1, 2) = '<>')) then
      begin
        Result[P] := '%';
        if (L >= 5) and (copy(result, L-1, 2) = '..') then
        begin
          result[L-1] := '%';                {..a.. -> %a%}
          System.Delete(result, L, 1);
        end else
        if L >= 3 then
          result := Format('%s%%', [result]);  {result + '%';       {..ab -> %ab%}
      end else
      if P = L - 1 then
      begin
        Result[P] := '%';                    {ab.. -> ab%}
      end else
        Result[P] := '~';                    {a..b -> a~b}
      System.Delete(result, P+1, 1);
      L := length(result);
      P := Pos('..', result);
    end;
    if (Pos(':', result) <= 0) and                   {290500 *=Malzeichen ISA}
       (Pos('{', result) <= 0) and                  {06.08.03 Suchen nach '*' TARA_ART}
       (Pos('[', result) <= 0) then                 {09.02.05 - [MENGE]*0.05}
    begin
      result := StrCgeChar(result, '*', '%');     {*abc, ab*c, abc*}
      result := StrCgeChar(result, '''', '?');    {nach <'> kann BDE nicht suchen}
      {if (Char1(Result) = '=') and (length(result) > 1) then
        result[1] := '?';}
    end;
    {result := StrCgeChar(result, '?', '_');    {ab?c Umsetzung in GenerateSql}
  end; {TranslateS}

begin {TranslateSql}
  result := '';          {TranslateS(Src);   }
  P1 := 1;
  if CharInSet(Char1(Src), ['[','{']) then     //Src kann leer sein!
    Step := 1 else
    Step := 0;
  for P2 := 2 to length(Src) do
  begin
    case Step of
0:    if CharInSet(Src[P2], ['[','{']) then
        Step := 1;
1:    if CharInSet(Src[P2], [']','}']) then
        Step := 0;
    end;
    if Step = 0 then
    begin
      if CharInSet(Src[P2], BlockTrenner) and
           ((Src[P2] <> '&') or           //nach & nur <> usw. für neuen Block; sonst lassen.
           ((P2 < length(Src)) and not IsAlphaNum(Src[P2+1]) and (Src[P2+1] <> ' '))) then
        begin
          result := result + TranslateS(copy(Src, P1, P2 - P1)) + Src[P2];
          P1 := P2 + 1;
        end;
    end;
  end;
  if P1 <= length(Src) then
    result := result + TranslateS(copy(Src, P1, length(Src) - P1 + 1));
end;

function HasFltrChr(const S: string): boolean;
// ergibt true wenn Filter-Symbole im Eingabestring. Für LuDef.GetUserFltr.
// Blocktrenner ergänzt - md 12.09.07
var
  I: integer;
  S1: string;
begin
  result := false;
  S1 := TransLateSql(S);
  if (S1 = '>=') or BeginsWith(S1, '!') or (S1 = '=') then
  begin                     //08.05.10 vorf.query1.beforeopen
    Result := true;
  end else
  for I:= 1 to length(S1) do
  begin
    if CharInSet(S1[I], ['%','?','~', ';', '&', '|']) then

    begin
      result := true;
      exit;
    end;
  end;
end;

function DropFltrChr(const S: string): string;
// entfernt alle Filterzeichen
var
  I: integer;
  S1: string;
begin
  Result := '';
  S1 := TransLateSql(S);
  for I:= 1 to length(S1) do
    if not CharInSet(S1[I], ['%','?','~']) then
      Result := Result + S1[I];
end;

function TranslateSqlOpn(Opn: string; DataType: TFieldType): string;
// Übersetzt konstante Operanden typbezogen nach SQL (z.B. 3,5 nach 3.5).
//   Exception bei Fehler (z.B. falsches Datum)
//   Für externe Verwendung (wird in dieser Unit nicht verwqendet)
var
  //IntOpn: Longint;
  FloatOpn: Extended;
  DateOpn: TDateTime;
  C1: char;
  DateFmt: string;
  EvalI, ErrorIndex: integer;
  IsError: boolean;
begin
  // immer: SysYear = aktuelles Jahr
  Opn := StringReplace(Opn, 'SysYear', IntToStr(ExtractYear(date)),
    [rfReplaceAll, rfIgnoreCase]);

  case DataType of
    ftSmallint, ftInteger, ftAutoInc, ftWord, ftLargeInt:
      ;  //IntOpn :=StrToInt(Opn);
    ftFloat, ftBCD, ftCurrency: begin
      FloatOpn :=StrToFloat(Opn);
      result := FloatToStrIntl(FloatOpn);    {Dez.Punkt, kein Tau.Trenner}
    end;
    ftDate, ftDateTime: begin
      for EvalI := low(SysDates) to high(SysDates) do
      begin
        if PosI(SysDates[EvalI], Opn) > 0 then
        begin
          Opn := StringReplace(Opn, SysDates[EvalI], FloatToStr(date), [rfReplaceAll, rfIgnoreCase]);
          ErrorIndex := EvalI;
          DateOpn := EvalExpression(Opn, IsError, ErrorIndex);
          Opn := DateToStr4(DateOpn);
          break;
        end;
      end;
      DateOpn := StrToDate4(Opn);               { Check ob korrektes Datum }

      {result := DateToSql(DateOpn);             {auch für andere Aufrufe}
      if SysParam.DbSqlDatum <> '' then
        DateFmt := SysParam.DbSqlDatum else      {Y2000 für Oracle}
      if SysParam.SqlDatum <> '' then
        DateFmt := SysParam.SqlDatum else
        DateFmt := '';
      if DateFmt <> '' then
      begin
        C1 := char1(DateFmt);
        if CharInSet(C1, ['''', '"']) then                {Access: ohne '' 280398 !}
          result := Format('%s%s%s', [C1, FormatDateTime(copy(DateFmt, 2,
            length(DateFmt) - 2), DateOpn), C1]) else
          result := FormatDateTime(DateFmt, DateOpn);
      end else
        result := Format('''%s''', [Trim(Opn)]);        { make char Opn quoted }
    end;
  else {ftString,ftWideString,ftMemo:}                                      {assume char}
    begin                     {LTrim statt Trim ab 051198 DPE.Fahr.EditMask}
      result := Format('''%s''', [LTrim(Opn)]);         { make char Opn quoted }
    end;
  end;
end;

function UmlautCase(S: string; Umlaut: boolean): string;
//Wandelt Umlaute um, so dass nach 'Ö' oder 'OE' gesucht werden kann
//Umlaut: true:UE->Ü  false:Ü->UE
var
  I: integer;
  C2: Char;
  IsUp, Skip1: boolean;
  S1: string;
begin
  Result := '';
  IsUp := true;
  Skip1 := false;
  for I := 1 to Length(S) do
  begin
    if Skip1 then
    begin
      Skip1 := false;
      Continue;
    end;
    S1 := S[I];
    if CharInSet(S[I], ['a'..'z', 'ä', 'ö', 'ü']) then
      IsUp := false;
    if I < Length(S) then
      C2 := S[I + 1] else
      C2 := '#';
    case S[I] of
      'ä': if not Umlaut then S1 := 'ae';
      'ö': if not Umlaut then S1 := 'oe';
      'ü': if not Umlaut then S1 := 'ue';
      'Ä': if not Umlaut then S1 := 'AE';
      'Ö': if not Umlaut then S1 := 'OE';
      'Ü': if not Umlaut then S1 := 'UE';
      'ß': if not Umlaut then if IsUp then S1 := 'SS'
                                      else S1 := 'ss';

      'a': if (C2 = 'e') and Umlaut then S1 := 'ä';
      'o': if (C2 = 'e') and Umlaut then S1 := 'ö';
      'u': if (C2 = 'e') and Umlaut then S1 := 'ü';
      's': if (C2 = 's') and Umlaut then S1 := 'ß';
      'A': if CharInSet(C2, ['E', 'e']) and Umlaut then S1 := 'Ä';
      'O': if CharInSet(C2, ['E', 'e']) and Umlaut then S1 := 'Ö';
      'U': if CharInSet(C2, ['E', 'e']) and Umlaut then S1 := 'Ü';
      'S': if CharInSet(C2, ['S', 's']) and Umlaut then S1 := 'ß';
    end;
    Result := Result + S1;
    if (S1 <> S[I]) and Umlaut then
      Skip1 := true;  //nächstes Zeichen überpringen
  end;
end;

function GenerateSQL(const Source: string; const ColumnName: string;
                     const ColumnType: TFieldType; var ReadOnly: boolean;
                     AswNr: integer; var SQL: string): boolean;
{ generiert SQL String where Klausel anhand Suchkriterien }
var
  P, P1, P2, BlockAnz: integer;
  Opn1, Opn2, Opt, OptBlock, OptBlock1: string;
  SrcEq, Done: boolean;
  Src, Col: string;
  IntOpn: int64;  //ab 02.04.13
  FloatOpn: Extended;
  DateOpn: TDateTime;
  AAsw: TAsw;
  NotFlag: boolean;
  FixOpn: boolean;

  function NextBlock: boolean;
  begin
    OptBlock := 'or';
    result := true;
    while (P <= length(Src)) and CharInSet(Src[P], BlockTrenner) do
      Inc(P);
    if (P > length(Src)) then
      result := false else
    begin
      P1 := P;
      while (P <= length(Src)) and not CharInSet(Src[P], BlockTrenner) do
        Inc(P);

      while (P <= length(Src)) and
            (Src[P] = '&') and
            ((P = length(Src)) or              {..AH&}
             (length(Src) = P+1) or            {%&%}
             (Src[P+1] = ' ') or               {Gmbh & Co}
             IsAlpha(Src[P+1])) do          {..DI&A}  //11.07.13 IsAlphaNum. DPE ILV.
      begin
        Inc(P);
        while (P <= length(Src)) and not CharInSet(Src[P], BlockTrenner) do
          Inc(P);
      end;
      if (P <= length(Src)) and (Src[P] = '&') then
        OptBlock := 'and';
      P2 := P - 1;
    end;
  end;

  procedure ParseBlock;
  begin
    Opn1 := ''; Opn2 := ''; Opt := '';
    if (Src[P1] = '=') and (P2 - P1 >= 1) then
    begin      //neu - Suche nach '=test' - GHS 12.04.04
      Opt := '';
      inc(P1);
      while P1 <= P2 do
      begin
        Opn1 := Opn1 + Src[P1];
        inc(P1);
      end;
    end else
    begin
      while (P1 <= P2) and CharInSet(Src[P1], OptTokens) do
      begin
        Opt := Opt + Src[P1];
        inc(P1);
      end;
      if (P1 <= P2) and (Src[P1] = '{') then
      begin
        while (P1 <= P2) and (Src[P1] <> '}') do
        begin
          Opn1 := Opn1 + Src[P1];
          inc(P1);
        end;
        if (P1 <= P2) then
        begin
          Opn1 := Opn1 + Src[P1];
          inc(P1);
        end;
      end;
      while (P1 <= P2) and not CharInSet(Src[P1], BetweenTrenner) do // OptTokens) do - 12.04.04
      begin
        Opn1 := Opn1 + Src[P1];
        inc(P1);
      end;
      if (P1 <= P2) and CharInSet(Src[P1], OptTokens) and (Opt <> '') then
        EError('Falsches Zeichen an P.%d:(%s)',[P1,Src[P1]]);
      while (P1 <= P2) and CharInSet(Src[P1], OptTokens) do
      begin
        Opt := Opt + Src[P1];
        inc(P1);
      end;
      while (P1 <= P2) and not CharInSet(Src[P1], OptTokens) do
      begin
        Opn2 := Opn2 + Src[P1];
        inc(P1);
      end;
    end;
    if (P1 <= P2) then
      EError('Falsches Zeichen (%s)',[Src[P1]]);
  end;

  function CheckOpn(Opn: string): string;
  var
    PktPos, Pos1: integer;
    C1: char;
    ColType: TFieldType;
    DateFmt, RTOpn, RTChar: string;
    EvalB: boolean;
    EvalI, SysDatesIndex: integer;
    NumberPrefix: boolean;
  begin
    PktPos := Pos('.',Opn);
    NumberPrefix := false;
    if Opn = '' then
    begin
      result := '';
    end else
    if (Opn[1] = '{') and (Opn[length(Opn)] = '}') then   {in ...}
    begin
      result := copy(Opn,2,length(Opn)-2);
      if Opt <> '' then
        result := '(' + result + ')' else
      if PosI('SELECT', LTrim(copy(Opn, 2, 100))) = 1 then  {ab Klammer}
        Opt := 'in' else
        Opt := '{}';   {komplette where-Zeile mit Feldnamen}
      if PosI('SELECT', Opn) > 0 then  {nested select - Merkmal bei request live nicht verfügbar}
        ReadOnly := true;
      Pos1 := Pos('(', Opn);  // Funktion idF <>{dbo.MYFUNK(a,b)}
      if (Pos1 > 0) and IsAlphaNum(Opn[Pos1- 1]) then  // aber nicht X='(fehlt)' - 14.06.11
        ReadOnly := true;
    end else
    if (Opn[1] = '[') and (Opn[length(Opn)] = ']') then   {FieldName}
    begin
      FixOpn := true;
      result := copy(Opn,2,length(Opn)-2);
    end else
    {bringt nix. nur 'Merkmal nicht verfügbar' bei Access
    if (Opn[1] = '(') and (Opn[length(Opn)] = ')') then   //'in' Liste
    begin
      Opt := 'in';
      S1 := PStrTok(copy(Opn,2,length(Opn)-2), ',', NextS);
      result := '';
      while S1 <> '' do
      begin
        AppendTok(result, CheckOpn(S1), ',');
        S1 := PStrTok('', ',', NextS);
      end;
    end else}

    //if (Opn[1] = ':') then                                  {:Param}
    //if Pos(':', Opn) > 0 then                               {290500 ISA warum?}
    if Pos(':', Opn) = 1 then                                 {290101}
    begin
      if PktPos <> 1 then
        result := Opn else
        result := copy(Opn, 2, length(Opn)-1);
    end else
    begin
      if (Char1(Opn) = '#') and IsFloatStr(copy(Opn, 2, MaxInt)) then
      begin                       //'#' erzwingt numerisch (TGenerator)
        System.Delete(Opn, 1, 1);
        NumberPrefix := true;
      end;
      result := Opn;
      ColType := ColumnType;
      RTOpn := Opn;
      RTChar := '';
      while CharInSet(CharN(RTOpn), ['%', '?']) and (Length(RTOpn) > 1) do
      begin                 {Datum,Num mit mehreren % am Ende. Einzelnes '%' berücksichtigen 29.11.09}
        RTChar := RTChar + CharN(RTOpn);
        System.Delete(RTOpn, length(RTOpn), 1);
      end;
      if (ColType = ftDateTime) and (Pos(' ', Opn) = 0) then  {keine Uhrzeit im String}
        ColType := ftDate;
      if CharInSet(Char1(RTOpn), ['%', '?']) then
        ColType := ftString;                        {Format 'INT,' zurücknehmen bei LIKE}

      // immer: SysYear = aktuelles Jahr
      RTOpn := StringReplace(RTOpn, 'SysYear', IntToStr(ExtractYear(Date)),
        [rfReplaceAll, rfIgnoreCase]);

      case ColType of
        ftSmallint, ftInteger, ftAutoInc, ftWord, ftLargeInt:
          begin
            //IntOpn := StrToInt(RTOpn);
            // 2012-1 -> 2011
            IntOpn := Round(EvalExpression(RTOpn, EvalB, SysDatesIndex));
            result := IntToStr(IntOpn) + RTChar;    //wg. führender Nullen
          end;
        ftFloat, ftBCD, ftCurrency:
          if Pos(FormatSettings.DecimalSeparator, RTOpn) > 0 then   //Bug bei FloatToStrIntl bei >=14Stellen
          begin
            FloatOpn := StrToFloat(RTOpn);
            result := FloatToStrIntl(FloatOpn) + RTChar;  {Dez.Pkt,kein Tau.Trenn}
          end;
        ftDate, ftDateTime: begin
          if ColType = ftDateTime then
            for EvalI := low(SysDates) to high(SysDates) do
              if PosI(SysDates[EvalI], RTOpn) > 0 then
                ColType := ftDate;  //Exception vermeiden
          if ColType = ftDateTime then
          try
            DateOpn := StrToDateTime4(RTOpn);     {Checkt korrektes Datum+Zeit. KeinExcept wenn Zeit fehlt}
            result := Format('''%s''%s',
              [DateTimeToStr4(DateOpn), RTChar]);     { make char Opn quoted }
          except
            ColType := ftDate;               {korrektes Datum ohne Zeit auch OK}
          end;
          if SysParam.ACCESS then
          begin
            if ColType = ftDate then
              if CompareText(RTOpn, 'SysDate') = 0 then
                DateOpn := date else
                DateOpn := StrToDate(RTOpn); //10.10.02
                //DateOpn := StrToDate4(RTOpn);            {Y2 100500}
            result := FloatToStrIntl(DateOpn) + RTChar;
          end else
          if ColType = ftDate then
          begin
            //if CompareText(RTOpn, 'SysDate') = 0 then
            EvalB := true;
            for EvalI := low(SysDates) to high(SysDates) do
            begin
              if PosI(SysDates[EvalI], RTOpn) > 0 then
              begin
                EvalB := false;
                RTOpn := StringReplace(RTOpn, SysDates[EvalI], FloatToStr(date), [rfReplaceAll, rfIgnoreCase]);
                SysDatesIndex := EvalI;
                DateOpn := EvalExpression(RTOpn, EvalB, SysDatesIndex);
                RTOpn := DateToStr4(DateOpn);
                break;
              end;
            end;
            if EvalB then
            begin
              if IsFloatStr(RTOpn) then
                RTOpn := DateToStr(StrToFloat(RTOpn));
              DateOpn := StrToDate4(RTOpn);          { Check ob korrektes Datum Y2 100500}
            end;
            if SysParam.DbSqlDatum <> '' then
              DateFmt := SysParam.DbSqlDatum else      {Y2000 für Oracle}
            if SysParam.SqlDatum <> '' then
              DateFmt := SysParam.SqlDatum else
              DateFmt := '';
            if DateFmt <> '' then
            begin
              C1 := char1(DateFmt);
              if CharInSet(C1, ['''', '"']) then
              begin
                result := Format('%s%s%s%s', [C1, FormatDateTime(copy(DateFmt, 2,
                  length(DateFmt) - 2), DateOpn), C1, RTChar]);  {RtChar 110501}
              end else
                result := FormatDateTime(DateFmt, DateOpn); {Access: ohne '' 280398 !}
            end else
              result := Format('''%s''%s', [Trim(RTOpn), RTChar]);    { make char Opn quoted }
          end; {ftDate}
        end; {ftDateTime, ftDate}
      else {ftString,ftWideString,ftMemo:}                         {assume char}
        {LTrim statt Trim ab 051198 DPE.Fahr.EditMask}
        if Pos('''', Opn) > 0 then
        begin  { TODO -omd -ckmp : Beispiel fehlt }
          result := Format('"%s"', [LTrim(Opn)]);         { alternate quote }
          ReadOnly := true;         //bei Interbase. wahrsch. auch bei ORA wg. BDE
        end else
        begin
          if NumberPrefix then
            result := Opn else          //'#' erzwingt numerisch (TGenerator)
            result := Format('''%s''', [LTrim(Opn)]);    { make char Opn quoted }
        end;
        if (AswNr > 0) then      {n.b. 100198 DPE.ENTS  jetzt nur noch Test}
        begin
          AAsw := Asws.Asw(AswNr);
          if (AAsw <> nil) then
          begin
            {S := AAsw.FindParam(Opn);
            if S <> '' then
              result := Format('''%s''', [S]);           make char Opn quoted}
            if AAsw.FindValue(Opn) = '' then
              Prot0('Auswahl-Wert(%s) nicht gefunden. %s:%s=%s',
                [Opn, Screen.ActiveForm.Caption, ColumnName, Source]);
          end;
        end;
      end; // case
    end;
  end;

  procedure GenBlock;
  var
    OpnDt2: string;
    NotLikeFlag: boolean;
  begin
    done := false;
    FixOpn := false;
    try        //09.02.05 ">[BESTELLMENGE]*0.05"
      Opn1 := CheckOpn(Trim(Opn1));
    except end;
    try
      Opn2 := CheckOpn(Trim(Opn2));
    except end;
    Col := ColumnName;
    if (Opt = '<>') and ((Pos('%', Opn1) > 0) or (Pos('?', Opn1) > 0)) then
    begin
      NotLikeFlag := true;
      Opt := '';
    end else
      NotLikeFlag := false;
    if Opt = 'in' then
    begin
      Opn1 := Format('(%s)', [Opn1]);
    end else
    if Opt = '' then
    begin
      if not FixOpn and
         ((Pos('%', Opn1) > 0) or (Pos('?', Opn1) > 0)) then
      begin
        //if (ColumnType = ftDateTime) and IsAlphaNum(Char1(Opn1)) then
        if (ColumnType = ftDateTime) and (CharN(Opn1) = '%') then
        begin
          Opn1 := copy(Opn1, 1, Pos('%',Opn1)-1);
          OpnDt2 := CheckOpn(DateTimeToStr(DateOpn + 1));     {einen Tag später}
          SQL := SQL + Format('((%s >= %s) and (%s < %s))',
            [Col, Opn1, Col, OpnDt2]);
          done := true;
        end else
        if (ColumnType in [ftSmallint, ftInteger, ftAutoInc, ftWord, ftLargeInt,
                          ftFloat, ftBCD, ftCurrency]) and IsAlphaNum(Char1(Opn1)) then
        begin                                          {9*** -> 9000..9999}
          Opn2 := StrCgeChar(StrCgeChar(Opn1, '%', '9'), '?', '9');
          Opn1 := StrCgeChar(StrCgeChar(Opn1, '%', '0'), '?', '0');
          SQL := SQL + Format('((%s >= %s) and (%s <= %s))', [Col, Opn1, Col, Opn2]);
          done := true;

          (* 020701
          Opn1 := copy(Opn1, 1, Pos('%',Opn1)-1);
          F1 := StrToInt(Opn1) + 1;                    {9* -> 9 .. <10}
          AddStr(SQL, Format('((%s >= %s) and (%s < %d))',
            [Col, Opn1, Col, F1]));
          done := true;
          *)
        end else
        begin
          if NotLikeFlag then
            Opt := 'NOT LIKE' else
            Opt := 'LIKE';
          Opn1 := StrCgeChar(Opn1, '?', '_');
{$ifdef WIN32}
{$else}
          if SysParam.ACCESS then        {ab Access 97/Win32 unnötig}
            ReadOnly := true;
{$endif}
          if ReadOnly and        {and not SysParam.SqlNoUpper then}
             not SysParam.ACCESS and
             not SysParam.MSSQL and    //MSSQL dflt in CaseInsensitive. ToDo: Schalter
             not SrcEq then            {System-Platzhalter '%'}
          begin
            {Access: Col := 'UCASE(' + ColumnName + ')'   ist unnötig}
            Col := Format('UPPER(%s)', [ColumnName]);
            if SysParam.INTERBASE then
              Opn1 := Uppercase(Opn1) else         {220400 IBase}
              Opn1 := AnsiUppercase(Opn1);         {030399 ansi Umlaute}
          end;
        end;
      end else
      begin
        Opt := '=';
        if (Char1(Opn1) = '^') or (CharI(Opn1, 2) = '^') then
        begin
          ReadOnly := true;
          Col := 'upper(' + Col + ')';
          Opn1 := 'upper(' + StrCgeChar(Opn1, '^', #0) + ')';
        end;
      end;
    end else
    if (Opt = '>=') and (Opn1 = '') then
    begin
      Opt := 'is not null';
    end else
    if (Opt = '=') and (Opn1 = '') then
    begin
      Opt := 'is null';
    end else
    if (Opt = '<>=') and (Opn1 = '') then
    begin
      Opt := 'is not null';
    end else
    if (Opt = '<') or (Opt = '>') or
       (Opt = '<=') or (Opt = '>=') or
       (Opt = '<>') then
    begin
      {OK so}
    end else
    if (Opt = '~') and (Opn1 <> '') and (Opn2 <> '') then
    begin
      SQL := SQL + Format('((%s >= %s) and (%s <= %s))', [Col, Opn1, Col, Opn2]);
      {'((' + Col + ' >= ' + Opn1 + ') and (' + Col + ' <= ' + Opn2 + '))');}
      done := true;
    end else
    if (Opt = '~<') and (Opn1 <> '') and (Opn2 <> '') then
    begin
      SQL := SQL + Format('((%s >= %s) and (%s < %s))', [Col, Opn1, Col, Opn2]);
      {AddStr(SQL, '((' + Col + ' >= ' + Opn1 + ') and (' +
                             Col + ' < ' + Opn2 + '))');}
      done := true;
    end else
    if (Opt = '{}') and (Opn2 = '') then
    begin
      SQL := SQL + Format('(%s)', [Opn1]);
      done := true;
    end else
    begin
      EError('Error GenerateSQL Opt(%s) Opn1(%s) Opn2(%s)', [Opt, Opn1, Opn2]);
    end;
    if not done then
    begin
      SQL := SQL + Format('(%s %s %s)', [Col, Opt, Opn1]);
      {'(' + Col + ' ' + Opt + ' ' + Opn1 + ')');}
    end;
  end;
var
  S1: string;
  SLike: array[1..12] of string;
  I, J: integer;
  Found: boolean;
begin {GenerateSQL}
  result := true;
  P := 1;
  BlockAnz := 0;
//if SQL = 'KSTE' then
//begin
//sql := '';
//for I := 1 to 10000 do
//  sql := sql + inttostr(I) + ',';
//exit;
//end;
  SQL := '';
  S1 := Source;
  NotFlag := (length(S1) >= 2) and (S1[1] = '!');  //31.10.04
  if NotFlag then
  begin
    Src := TranslateSql(copy(S1, 2, MaxInt));
    SrcEq := Src = copy(S1, 2, MaxInt);
  end else
  begin
    Src := TranslateSql(S1);
    SrcEq := Src = S1;      {es wurde nur der Systemplatzhalter '%' verwendet}
  end;
  {QDISPO.Disp 280401: variieren nur bei Benutzereingaben.
   System setzt '%' statt '..' wenn keine Gross/Klein Variierung notwendig}
  if not SrcEq and
     (Char1(Src) = '%') and (CharN(Src) = '%') and (length(Src) > 2) and
     (PosCh(BlockTrenner, Src) <= 0) then
  begin                      {Groß/Kleinschreibung variieren bei LIKE Operator:}
    if SysParam.SqlIsCaseSensitiv and not SysParam.Access and   {alle außer access}
       not ReadOnly then
    begin
  //    S1 := copy(Src, 2, length(Src) - 2);
  //    S2 := AnsiUpperCase(S1);
  //    if S2 <> S1 then
  //      AppendTok(Src, '%' + S2 + '%', ';');
  //    S2 := AnsiLowerCase(S1);
  //    if S2 <> S1 then
  //      AppendTok(Src, '%' + S2 + '%', ';');
  //    S2 := AnsiUpperCase(Char1(S1)) + AnsiLowerCase(copy(S1, 2, 100));
  //    if S2 <> S1 then
  //      AppendTok(Src, '%' + S2 + '%', ';');
      SLike[1] := copy(Src, 2, length(Src) - 2);
      SLike[2] := AnsiUpperCase(SLike[1]);
      SLike[3] := AnsiLowerCase(SLike[1]);
      SLike[4] := AnsiUpperCase(Char1(SLike[1])) + AnsiLowerCase(copy(SLike[1], 2, 100));
      SLike[5] := UmlautCase(SLike[1], true);  //UE -> 'Ü'
      SLike[6] := UmlautCase(SLike[1], false); //Ü -> UE
      SLike[7] := UmlautCase(SLike[2], true);
      SLike[8] := UmlautCase(SLike[2], false);
      SLike[9] := UmlautCase(SLike[3], true);
      SLike[10] := UmlautCase(SLike[3], false);
      SLike[11] := UmlautCase(SLike[4], true);
      SLike[12] := UmlautCase(SLike[4], false);
      for I := 2 to 12 do
      begin
        Found := false;
        for J := 1 to I - 1 do
        begin
          if SLike[J] = SLike[I] then
          begin
            Found := true;
            Break;
          end;
        end;
        if not Found then
          AppendTok(Src, '%' + SLike[I] + '%', ';');
      end;
    end else
    begin
      //Groß/Klein egal: nur Umlaute variieren
      //oder bei ReadOnly
      SLike[1] := copy(Src, 2, length(Src) - 2);
      SLike[2] := UmlautCase(SLike[1], true);  //UE -> 'Ü'
      SLike[3] := UmlautCase(SLike[1], false); //Ü -> UE
      for I := 2 to 3 do
      begin
        Found := false;
        for J := 1 to I - 1 do
        begin
          if SLike[J] = SLike[I] then
          begin
            Found := true;
            Break;
          end;
        end;
        if not Found then
          AppendTok(Src, '%' + SLike[I] + '%', ';');
      end;
    end;
  end;

  while NextBlock do                         {definiert OptBlock}
  begin
    if P2 >= P1 then
    begin
      if BlockAnz > 0 then
      begin
        if OptBlock1 = OptBlock then
          SQL := Format('%s %s ', [SQL, OptBlock1]) else
          SQL := Format('(%s) %s ', [SQL, OptBlock1]);
      end;
      ParseBlock;
      GenBlock;     {mit ()}
      Inc(BlockAnz);
    end;
    OptBlock1 := OptBlock;
  end;
  if BlockAnz > 1 then
  begin
    SQL := Format('(%s)', [SQL]);
  end;
  if NotFlag then
  begin
    SQL := Format('not %s', [SQL]);
  end;
end;

end.
