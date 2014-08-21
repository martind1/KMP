unit Feiertage;
(* Erkennt ob ein Datum ein Feiertag, Wochentag ist
07.06.10 md  erstellt - http://www.swissdelphicenter.ch/de/showcode.php?id=1278
*)

interface

uses
  Windows, SysUtils;

function IsFeiertag(aDate: TDateTime): boolean;

function IsWochenende(aDate: TDateTime): boolean;

implementation

uses
  Classes,
  Prots;

var
  HolydayTable: TStringList;  //Date=Name
  YearTable: TStringList;

// Function to call to get the Holiday Table with all Holidays of a year
// Der Funktionsaufruf, um die Feiertage eines Jahres abzufragen
procedure GetHolidayTable(Year: Word);

  // Function to add a holiday by Day and Month
  // Funktion, um einen Feiertag über seinen Tag\Monat hinzuzufügen
  procedure AddHoliday(DD, MM: Word; HDName: string); overload;
  begin
    HolydayTable.Add(Format('%s=%s', [DateToStr(EncodeDate(Year, MM, DD)), HDName]));
  end;

  //Function to add holiday by date serial
  //Funktion, um den Feiertag über die Datumsseriennummer hinzuzufügen
  procedure AddHoliday(HDDate: TDateTime; HDName: string); overload;
  begin
    HolydayTable.Add(Format('%s=%s', [DateToStr(HDDate), HDName]));
  end;

  // Function to get easter sunday
  // Function zur Berechnung des Ostersonntags
  function GetEasterDate(YYYY: Word): TDateTime;
  var
    A, B, C, D, E, F, G, H, I, K, L, M, N, P: Word;
    DD, MM: Word;
  begin
    a := YYYY mod 19;
    b := YYYY div 100;
    c := YYYY mod 100;
    d := b div 4;
    e := b mod 4;
    f := (b + 8) div 25;
    g := (b - f + 1) div 3;
    h := (19 * a + b - d - g + 15) mod 30;
    i := c div 4;
    k := c mod 4;
    l := (32 + 2 * e + 2 * i - h - k) mod 7;
    m := (a + 11 * h + 22 * l) div 451;
    n := (h + l - 7 * m + 114) div 31;
    p := (h + l - 7 * m + 114) mod 31 + 1;
    DD := p;
    MM := n;
    Result := EncodeDate(YYYY, MM, DD);
  end;

var
  EDate: TDateTime;
begin  { GetHolidayTable }
  // Add fixed holidays
  // Hinzufügen der festen Feiertage
  AddHoliday(1, 1, 'Neujahr');
  AddHoliday(1, 5, 'Tag der Arbeit');
  AddHoliday(3, 10, 'Tag der deutschen Einheit');
  AddHoliday(31, 10, 'Reformationstag');
  // AddHoliday(24, 12, 'Heiligabend');
  AddHoliday(25, 12, '1. Weihnachtsfeiertag');
  AddHoliday(26, 12, '2. Weihnachtsfeiertag');
  // AddHoliday(31, 12, 'Silvester');
  // Add holidays relative to easter sunday
  // Hinzufügen der Feiertage, die von Ostern abhängen
  EDate := GetEasterDate(Year);
  AddHoliday(EDate, 'Ostersonntag');
  AddHoliday(EDate - 2, 'Karfreitag');
  AddHoliday(EDate + 1, 'Ostermontag');
  AddHoliday(EDate + 39, 'Christi Himmelfahrt');
  AddHoliday(EDate + 49, 'Pfingstsonntag');
  AddHoliday(EDate + 50, 'Pfingstmontag');
  // Gets 3rd Wednesday in November
  // Ermittelt den 3. Mitwoch im November
  EDate := EncodeDate(Year, 11, 1);
  EDate := EDate + ((11 - DayOfWeek(EDate)) mod 7) + 14;
  AddHoliday(EDate, 'Buß- und Bettag');
end;

function IsFeiertag(aDate: TDateTime): boolean;
var
  aYear: Word;
begin
  aYear := ExtractYear(aDate);
  if YearTable.Values[IntToStr(aYear)] = '' then
  begin
    YearTable.Values[IntToStr(aYear)] := '1';
    GetHolidayTable(aYear);
  end;
  Result := HolydayTable.Values[DateToStr(aDate)] <> '';
end;

function IsWochenende(aDate: TDateTime): boolean;
var
  dow: integer;
begin
  // DayOfWeek gibt den Wochentag des angegebenen Datums als Integer zwischen 1 und 7 zurück.
  //Hierbei gilt der Sonntag als erster Tag der Woche und der Samstag als der siebte Tag.
  dow := DayOfWeek(aDate);
  Result := (dow = 1) or (dow = 7);
end;

initialization
  HolydayTable := TStringList.Create;
  YearTable := TStringList.Create;
finalization
  HolydayTable.Free;
  YearTable.Free;
end.
