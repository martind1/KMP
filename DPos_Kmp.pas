unit DPos_Kmp;
(* Stringlisten-Derivate ValueList, DataPos, FltrList

   Autor: Martin Dambach
   Letzte Änderung
   24.09.96     Erstellen
   27.10.97     BuildSql: GNav.TableSynonyms
   16.02.98     PutMasterFields entfällt. Ersetzt durch TLookUpDef.PutSOFields
   25.07.98     PutFieldValues
   26.07.98     Params[] mit Schreibzugriff  (procedure SetParam)
   30.09.98     MergeStrings, Merge
   18.01.00     ValueCount: Anzahl der Werte rechts vom =
   11.02.01     PutRefValues
   17.05.02     IsPos
   31.07.02     AddOpt
   28.01.04     GetParamFieldNames, GetValueFieldNames
   03.05.04     BuildSql:Tablename ..K1=Kunden;.. -> "Kunden" K1, ..
   28.05.04     dpoNext
   28.05.04     GotoNearest: Result geändert (0 ist jetzt exakt gefunden)
   29.05.04     ForceNull
   09.09.04     Bedingte Zuweisung:nur wenn Wert geändert: SetChangedValue
   03.11.04     SetChangedValue ergibt true wenn geändert
   28.08.05     AddTokens mit Trim
   06.02.08     BuildSql: dbo.tbl nicht nach 'from dbo.tbl tbl ..' generieren
   12.12.09     SetParams, SetValues
   19.01.10     BuildSql:Close vor Änderung von Requestlive
   04.03.10     SetFieldComp: überschreibt auch ReadOnly-Felder
   27.04.10     RightestEqual-Kennzeichen: erkennt das am weitesten rechts stehende '='
   09.06.13     AggrInLine nur echte Aggregatfunktionen
   07.04.14     Compare: erkennt neben '<=>' auch Wert1..Wert2
*)

interface

uses
  SysUtils, Classes, DB, Uni, UQue_Kmp, DBAccess, MemDS, Forms;

type
  TDPosOptions = set of (dpoEnableControls,    {Table bleibt auf ControlsEnabled}
                         dpoNoProcessMessages, {keine Erfolgsanzeige mit GMess }
                         dpoAbortDlg,          {Erfolgsanzeige mit AbortDlg    }
                         dpoNext,              {Sucht ab aktueller Position    }
                         dpoPrior,             {Sucht rückwärts ab aktueller Position }
                         dpoIgnoreCase,        // Groß/klein egal
                         dpoDesc,              //Tabelle ist absteigend sortiert
                         dpoCursor);           //Mit crHourGlass

  TValueList = class(TStringList)      {Werteliste in der Form <Param>=<Value>}
  private
    function GetDelimiterText: string;
    procedure SetDelimiterText(const Value: string);
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    function GetParam(const Name: string): string;
    {Lefert Param zur Value = Name}
    procedure SetParam(const Name, Param: string);
  public
    { Public-Deklarationen }
    Delimiter: char;
    RightestEqual: boolean;  //true = Value enthält kein '=' (PosR())
    constructor Create;
    //16.04.11 Idee constructor CreateTokenString(TokenString: string; Trenner: string);

    procedure FreeObjects;
    {Kombiniert das Löschen der Objekte mit der Methode Free}
    procedure ClearObjects;
    {Kombiniert das Löschen der Objekte mit der Methode Clear}
    procedure DeleteObjects(Index: Integer);
    {Kombiniert das Löschen des Objekts mit der Methode Delete}
    function IsEmpty: boolean;
    procedure DeleteParam(AFieldName: string);
    {Zeile löschen anhand des Parameters}
    procedure ClearValues;
    {Inhalt der rechten Seiten wird kompltett gelöscht}
    procedure AddTokens(TokenString: String; Trenner: String; doTrim: boolean = false); overload;
    procedure AddTokens(TokenString: String; TrennerList: array of string; doTrim: boolean = false); overload;
    {a;b;c aus Tokenstring Stringliste}
    function AsTokenString(Trenner: string): string;
    {trennt Zeilen der Stringliste mit Tokens}
    function ParamTokens(Trenner: string): string;
    {ergibt String mit Werten auf der linken Seite, durch <Trenner> getrennt}
    function ValueTokens(Trenner: string): string;
    {ergibt String mit Werten auf der rechten Seite, durch <Trenner> getrennt}
    function Value(Index: Integer): String;
    {Inhalt der rechten Seite bei Index}
    function ValueDflt(Index: Integer): String;
    {Inhalt der rechten Seite bei Index oder gesamte Zeile wenn '=' fehlt}
    function ClearOtherParams(const Params: string): boolean;
    //entfernt Zeilen mit anderen Params
    function SetChangedValue(const Name, Value: string): boolean;
    {Belegt Values[Name] mit Value nur bei geändertem Inhalt}
    function SetValueIfNull(const Name, Value: string): boolean;
    //setzt Value nur wenn es bisher nicht besetzt war
    procedure AssignChanged(Source: TPersistent);
    {Assign erfolgt nur bei geändertem Inhalt}
    function Param(Index: Integer): String;
    {Inhalt der linken Seite bei Index}
    function ValueIndex(const AParam: string; Value: PString): Integer;
    {Value belegen bei Name Rückgabe Index oder -1 bei Fehler}
    function ParamIndex(const AValue: string; Param: PString): Integer;
    {Param belegen bei Name Rückgabe Index oder -1 bei Fehler}
    function ValueCount: integer;
    {Ergibt Anzahl der Werte rechts vom =}
    function AddFmt(const Fmt: string; const Args: array of const): integer;
    {Add mit Formatierung}
    function AddOpt(const AParam, AValue: string): integer;
    {Add AParam=AValue}
    procedure MergeStrings(Strings: TStrings);
    {Vermischt Strings. Bestehende Params werden überschrieben}
    procedure Merge(Source: TPersistent);
    {Vermischt self mit Daten die von Source mit Assign übernommen werden}
    function SameStrings(Strings: TStrings; IgnoreCase: boolean = false): boolean;
    {Ergibt true wenn gleiche Zeilen. Reihenfolge ist egal}
    function GetString(Ident, Default: string): string;
    {liest Values[Ident]}
    function GetBool(Ident: string; Default: boolean): boolean;
    {liest Values[Ident] als boolean}
    function GetInteger(Ident: string; Default: Integer): Integer;
    {liest Values[Ident] als Integer}
    function GetFloat(Ident: string; Default: Double): Double;
    {liest Values[Ident] als Float}
    procedure SetParams(L: TStrings); //übergibt Liste der linken Seiten an L
    procedure SetValues(L: TStrings); //übergibt Liste der rechten Seiten an L
    property Params[const Name: string]: string read GetParam write SetParam;
    {Ergibt Param anhand Value}
    property DelimiterText: string read GetDelimiterText write SetDelimiterText;
    {wie CommaText, aber statt ',' wird Delimiter verwendet (dflt=';')}
  published
    { Published-Deklarationen }
  end;

  (* DataPos *)
  TDataPos = class(TValueList)
  {Nimmt eine Datenmenge in Form Feld-Name=Feld-Wert auf}
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    function Compare(AFieldList: TList; IgnoreCase: boolean): boolean;
    {Vergleicht aktuellen Feldwerte mit Werten in der DataPos}
    function CompareNearest(AFieldList: TList): integer;
    {Vergleicht auch ungefähr Ergibt Länge identischer Teilstrings}
  public
    { Public-Deklarationen }
    InPutReferenceFields: boolean;
    ScrollCntr: longint;             {Anzahl gescrollter Datensätze bei GotoPos}

    {procedure GetKeyFields(ADataSet: TDataSet);
    (* Baut Stringliste auf: Alle Index-Felder mit Feldinhalten von Table*)
    weg, da bei TUQuery nicht funktioniert 160298}
    procedure AddFieldsValue(ADataSet: TDataSet; Fields: string);
    (* Feldnamen in <Fields>, mit ; getrennt mit Werten als FltrList ergänzen *)
    procedure ExtractFields(Fields: string);
    (* Läßt nur Felder (und ihre Werte) in Fields übrig *)
    procedure AddFieldsIsNull(ADataSet: TDataSet; Fields: string);
    (* Feldnamen in <Fields>, mit ; getrennt als Is Null Filter in FltrList ergänzen
   urspr. für  SetReturn bei DetailLookUp, jetzt nicht mehr benutzt *)
    procedure AddFieldListIsNull(AFieldList: TValueList);
    (* Ergänzt FltrList mit Feldern aus AFieldList mit is null *)
    procedure GetMasterFields(ADataSet: TDataSet; IndexFields: string;
                              MasterSource: TDataSource; MasterFields: string);
    (* Baut Stringliste auf. Syntax: <Lookup-Fieldname>=<Master-FieldValue>*)
    {procedure PutMasterFields(ADataSet: TDataSet; IndexFields: string;
                               MasterSource: TDataSource; MasterFields: string);
    (* Feldinhalte in Mastersource von Sekundär-Table kopieren *) n.b. 16.02.98}
    procedure PutReferenceFields(ADataSet: TDataSet; IndexFields: string;
                                  MasterSource: TDataSource; MasterFields: string);
    (* Feldinhalte von IndexFields nach Masterfields kopieren
   * für Return *)
    procedure AddReferenceFields(ADataSet: TDataSet; IndexFields: string;
                                  MasterSource: TDataSource; MasterFields: string);
    {Passende Werte nach Rückkehr von Lookup zuweisen}
    procedure SetReferenceFields(ADataSet: TDataSet; IndexFields: string;
                                  MasterSource: TDataSource; MasterFields: string;
                                  Add: boolean);
    {Passende Werte nach Rückkehr von Lookup zuweisen}
    procedure AssignIndexFields(ADataPos: TDataPos; IndexFields: string); overload;
    procedure AssignIndexFields(ADataPos: TDataPos; IndexFields: string; SetNull: boolean); overload;
    {Aus ADataPos nur Felder aus IndexFields in DataPos kopieren}
    function IsPos(ATable: TDataSet; IgnoreCase: boolean = false): boolean;
    (* Result: true wenn aktuelle Feldwerte den DataPos-Zeilen entsprechen false wenn ungleich *)
    function GotoPos(ATable: TDataSet): boolean;
    {Positionieren in ATable anhand DataPos}
    function GotoPosEx(ATable: TDataSet; Options: TDPosOptions): boolean;
    {Positionieren in ATable anhand DataPos mit Optionen}
    function GotoPosSilent(ATable: TDataSet): boolean;
    // ohne Processmessages
    function GotoPosSilentText(ATable: TDataSet): boolean;
    // ohne Processmessages. Groß/klein egal
    function GotoNearest(ATable: TDataSet; Options: TDPosOptions = []): integer;
    {Positioniert bei besten Übereinstimmung}
    procedure FillFieldText(APrefix: string; ADataSet: TDataSet; NoNullValues: boolean = false);
    {Ergänzt DataPos um Feld-Anzeigewerte in ADataSet.}
    procedure GetValues(ADataSet: TDataSet);
    {bestückt DataPos aus ADataSet}
    procedure GetNNValues(ADataSet: TDataSet);
    {bestückt DataPos aus ADataSet. Nur not null Felder}
    procedure PutValues(ADataSet: TDataSet);
    {schreibt DataPos nach ADataSet}
    procedure PutFieldValues(ADataSet: TDataSet; AMasterSource: TDataSource);
    (* schreibt DataPos nach ADataSet, aber wandelt ':'+Feldname in Wert um *)
    procedure PutRefValues(ADataSet: TDataSet; ARefSource: TDataSource);
    (* schreibt nach ADataSet. Feldnamen von Dataset stehen auf der rechten Seite,
       mit ':' davor. Feldnamen von RefSource stehen auf der linken Seite
       (wie PutFieldValues aber li und re Seiten vertauscht) für LNav.Take *)
    procedure PutValuesNull(ADataSet: TDataSet);
    {setzt alle Felder die in DataPos vorhanden sind bei ADataSet auf NULL}
    procedure SetSQL(ATableName: string; AQuery: TUQuery);
    {Aufbau vom einfachem SQL-Befehl}
    procedure ReadFieldValues(APrefix: string; ADataSet: TDataSet);
    // Liest Feldnamen und Werte von Dataset ein. Hängt Prefix vor Feldnamen. 04.03.10.
    procedure AddFieldValues(APrefix: string; ADataSet: TDataSet);
    // Liest nur Feldwerte mit Inhalt von Dataset ein. Hängt Prefix vor Feldnamen. 04.03.10.
    procedure WriteFieldValues(APrefix: string; ADataSet: TDataSet);
    // Schreibt nach DataSet. Kein fehler wenn feldname auf der linken Seite nicht gefunden wurde  published
  end;

  (* Filter-Liste *)
  TFltrList = class(TDataPos)
  {Datenstruktur für Filter-Liste}
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    procedure AddFltrList(ADataSet: TDataSet; AList: TValueList;
      TblRef: boolean = true; ForceNull: boolean = true);
    (* Ergänzt Filter. Wandelt Parameter inWerte um *)
    procedure SetFltrField(AField: TField);
    {setzt Filter auf den aktuellen Wert des Feldes}
    procedure CopyFltrValues(ADataSet: TDataSet);
    { Kopiert Filter als Feldwerte. Nur Eqal-Filter zur Belegung bei Insert
       :Feldnamen werden anhand Dataset.Datasource in Werte umgewandelt }
    function GetParamFieldNames: string;
    {Untersucht nur Zeilen i.d.F. <ParamFeld>=:<ValueFeld> (vergl. SOList, References, FltrList)
     Ergibt die Feldnamen links vom '=', mit ';' getrennt. }
    function GetValueFieldNames: string;
    {Untersucht nur Zeilen i.d.F. <ParamFeld>=:<ValueFeld> (vergl. SOList, References, FltrList)
     Ergibt die Feldnamen rechts vom '=', mit ';' getrennt. }
    function BuildSql(AQuery: TUQuery; ATblName: string; AKeyFields: string;
          ASqlFieldList: TStrings; var ErrorFieldName: string; aSqlHint: string = ''): boolean;
    {baut ein komplettes SQL_Komando mit order by (AKeyFields), Feldnamen (ASqlFieldList)
     ErrorFieldName - Fehlerausgabe}
    function BuildSqlDelete(AQuery: TUQuery; ATblName: string;
                             var ErrorFieldName: string): boolean;
    {baut kompleten SQL-Befehl für Delete-Anweisung bezogen auf die Filter in DataPos}
  published
    { Published-Deklarationen }
  end;

implementation

uses
  DBConsts, Windows, StrUtils, Controls {crHourGlass},
  UDB__Kmp,
  GNav_Kmp, LuEdiKmp, nstr_Kmp, Asws_Kmp, Prots, Err__Kmp, FldDsKmp, KmpResString;

(* TValueList *)

constructor TValueList.Create;
begin
  inherited Create;
  Delimiter := ';';  //für CSV
end;

procedure TValueList.FreeObjects;
var
  I: integer;
begin
  if not assigned(self) then
    Exit;
  for I := Count - 1 downto 0 do
  try
    Objects[I].Free;
  except on E:Exception do
    EProt(self, E, 'Fehler bei TValueList.FreeObjects', [0]);
  end;
  Free;
end;

procedure TValueList.ClearObjects;
var
  I: integer;
begin
  if not assigned(self) then
    Exit;
  for I := Count - 1 downto 0 do
  try
    try
      Objects[I].Free;
    except on E:Exception do
      EProt(self, E, '%d(%s)', [I, Strings[I]]);
    end;
  finally
    Objects[I] := nil;
  end;
  Clear;
end;

procedure TValueList.DeleteObjects(Index: Integer);
{Kombiniert das Löschen des Objekts mit der Methode Delete}
begin
  Objects[Index].Free;
  Delete(Index);
end;

function TValueList.ValueCount: integer;
{Ergibt Anzahl der Werte rechts vom =}
var
  I: integer;
begin
  result := 0;
  for I := 0 to Count - 1 do
    if Value(I) <> '' then
      result := result + 1;
end;

function TValueList.ValueIndex(const AParam: string; Value: PString): Integer;
(* Ergibt Index und Value von AParam der linken Seite. von VCL Source, dort private *)
var
  P: Integer;
  S: string;
begin
  for Result := 0 to GetCount - 1 do
  begin
    S := Get(Result);
    if RightestEqual then
      P := PosR('=', S) else
      P := Pos('=', S);
    if (P > 0) and (CompareText(Copy(S, 1, P - 1), AParam) = 0) then
    begin
      if Value <> nil then Value^ := Copy(S, P + 1, length(S)-P);
      Exit;
    end else
    if (P = 0) and (CompareText(S, AParam) = 0) then
    begin
      if Value <> nil then Value^ := '';
      exit;
    end;
  end;
  Result := -1;
end;

function TValueList.ParamIndex(const AValue: string; Param: PString): Integer;
(* Ergibt Index und Param von Value der rechten Seite. entspr. ValueIndex *)
var
  P: Integer;
  S: string;
begin
  for Result := 0 to GetCount - 1 do
  begin
    S := Get(Result);
    if RightestEqual then
      P := PosR('=', S) else
      P := Pos('=', S);
    if (P > 0) and (CompareText(Copy(S, P+1, length(S)-P), AValue) = 0) then
    begin
      if Param <> nil then Param^ := Copy(S, 1, P-1);
      Exit;
    end;
  end;
  Result := -1;
end;

function TValueList.GetParam(const Name: string): string;
{Lefert Param zur Value = Name}
begin
  if ParamIndex(Name, @Result) < 0 then Result := '';
end;

function TValueList.GetDelimiterText: string;
// wie Commatext aber mit Trenner in self.Delimiter (dflt=;)
var
  S: string;
  P: PChar;
  I, Count: Integer;
begin
  Count := GetCount;
  if (Count = 1) and (Get(0) = '') then
    Result := '""'
  else
  begin
    Result := '';
    for I := 0 to Count - 1 do
    begin
      S := Get(I);
      P := PChar(S);
      while not CharInSet(P^, [#0..' ','"',Delimiter]) do P := CharNext(P);
      if (P^ <> #0) then S := AnsiQuotedStr(S, '"');
      Result := Result + S + Delimiter;
    end;
    System.Delete(Result, Length(Result), 1);
  end;
end;

procedure TValueList.SetDelimiterText(const Value: string);
// modifizierter SetCommaText. Leerzeichen innerhalb Wort gilt nicht als Trenner.
var
  P, P1: PChar;
  S: string;
begin
  BeginUpdate;
  try
    Clear;
    P := PChar(Value);
    while CharInSet(P^, [#1..' ']) do P := CharNext(P);
    while P^ <> #0 do
    begin
      if P^ = '"' then
        S := AnsiExtractQuotedStr(P, '"')
      else
      begin
        P1 := P;
        //while (P^ > ' ') and (P^ <> Delimiter) do P := CharNext(P);
        while (P^ >= ' ') and (P^ <> Delimiter) do P := CharNext(P);  //md 27.08.09
        SetString(S, P1, P - P1);
      end;
      Add(Trim(S));  //12.11.10 sdbl.STOT - SAP macht trailing blanks 
      while CharInSet(P^, [#1..' ']) do P := CharNext(P);
      if P^ = Delimiter then
      begin
        repeat
          P := CharNext(P);
        until not CharInSet(P^, [#1..' ']);
        if P^ = #0 then  // md 27.08.09
          Add('');       // letztes ; ist ein leeres Feld
      end;
    end;
  finally
    EndUpdate;
  end;
end;

function TValueList.ClearOtherParams(const Params: string): boolean;
//entfernt Zeilen mit anderen Params
var
  I: integer;
begin
  Result := false;
  BeginUpdate;
  try
    for I := Count - 1 downto 0 do
    begin
      if IndexOfToken(StrParam(Strings[I]), Params, ';') < 0 then
      begin
        Delete(I);
        Result := true;
      end;
    end;
  finally
    EndUpdate;
  end;
end;

function TValueList.SetChangedValue(const Name, Value: string): boolean;
begin
  result := Values[Name] <> Value;
  if result then
    Values[Name] := Value;
end;

function TValueList.SetValueIfNull(const Name, Value: string): boolean;
//setzt Value nur wenn es bisher nicht besetzt war
begin
  result := Values[Name] = '';
  if result then
    Values[Name] := Value;
end;

procedure TValueList.AssignChanged(Source: TPersistent);
begin  {Assign erfolgt nur bei geändertem Inhalt oder wenn keine Strings}
  if ((Source is TStrings) and (TStrings(Source).Text <> Text)) or
     not (Source is TStrings) then
    Assign(Source);
end;

procedure TValueList.SetParam(const Name, Param: string);
var
  I: Integer;
  S: string;
begin
  I := ParamIndex(Name, nil);
  if Param <> '' then
  try
    BeginUpdate;
    S := Format('%s=%s', [Param, Name]);
    if I < 0 then
      self.Add(S)
    else
      Put(I, S);  {Strings[I] := Param + '=' + Name;}
  finally
    EndUpdate;
  end else
  begin
    if I >= 0 then Delete(I);
  end;
end;

function TValueList.IsEmpty: boolean;
var
  I: integer;
begin
  result := true;
  for I:= 0 to Count-1 do
  begin
    if Value(I) <> '' then
    begin
      result := false;
      break;
    end;
  end;
end;

procedure TValueList.DeleteParam(AFieldName: string);
(* Zeile eines Feldes löschen (oder alle falls mehrere)
   * für DataPos.DataChange *)
var
  I: Integer;
begin
  for I:= 0 to Count-1 do
  begin
    if Param(I) = AFieldName then
    begin
      Delete(I);
    end;
  end;
end;

procedure TValueList.ClearValues;
(* Alle Werte löschen, Params bleiben
   * für Lookupdef.datachange:bei Null-Index *)
var
  I: Integer;
begin
  for I:= 0 to Count-1 do
  begin
    Strings[I] := Format('%s=',[Param(I)]);
  end;
end;

procedure TValueList.AddTokens(TokenString: String; Trenner: String;
  doTrim: boolean = false);
(* Token in TokenString als Zeilen hinzufügen; kein Clear
   10.04.10 bug wenn Trenner aus mehreren Zeichen besteht
   29.04.10 war kein Bug (qupe.prob, email). Überladene Version ergänzt.
*)
var
  AToken, NextS: String;
begin
  AToken := PStrTok(TokenString, Trenner, NextS, doTrim);
  while AToken <> '' do
  begin
    Add(AToken);
    AToken := PStrTok('', Trenner, NextS, doTrim);
  end;
end;

procedure TValueList.AddTokens(TokenString: String; TrennerList: array of string;
  doTrim: boolean = false);
(* Token in TokenString als Zeilen hinzufügen; kein Clear
   29.04.10 Überladene Version für FLTRFrm (Trenner ist dort '\r')
*)
var
  AToken, NextS: String;
begin
  AToken := PStrTok(TokenString, TrennerList, NextS, doTrim);
  while AToken <> '' do
  begin
    Add(AToken);
    AToken := PStrTok('', TrennerList, NextS, doTrim);
  end;
end;

function TValueList.AsTokenString(Trenner: string): string;
{trennt Zeilen der Stringliste mit Tokens}
var
  I: integer;
begin
  result := '';
  for I := 0 to Count - 1 do
    AppendTok(result, Strings[I], Trenner);
end;

function TValueList.ParamTokens(Trenner: string): string;
{ergibt String mit Werten auf der linken Seite, durch <Trenner> getrennt}
var
  I: integer;
begin
  result := '';
  for I := 0 to Count - 1 do
    AppendTok(result, Param(I), Trenner);
end;

function TValueList.ValueTokens(Trenner: string): string;
{ergibt String mit Werten auf der rechten Seite, durch <Trenner> getrennt}
var
  I: integer;
begin
  result := '';
  for I := 0 to Count - 1 do
    AppendTok(result, Value(I), Trenner);
end;

function TValueList.Value(Index: Integer): String;
(* Wert ab dem ersten '='  (RightestEqual ist standardmäßig false) *)
begin
  if (index < 0) or (index >= Count) then
    result := '' else
    result := StrValue(Strings[Index], RightestEqual);
end;

function TValueList.ValueDflt(Index: Integer): String;
{Inhalt der rechten Seite bei Index oder gesamte Zeile wenn '=' fehlt}
begin
  if (index < 0) or (index >= Count) then
    result := '' else
    result := StrValueDflt(Strings[Index]);
end;

function TValueList.Param(Index: Integer): String;
(* Wert bis zum ersten '='  (RightestEqual ist standardmäßig false) *)
begin
  if (index < 0) or (index >= Count) then
    result := '' else
    result := StrParam(Strings[Index], RightestEqual);
end;

function TValueList.AddFmt(const Fmt: string; const Args: array of const):
 integer; {Add mit Formatierung}
begin
  result := Add(Format(Fmt,Args));
end;

function TValueList.AddOpt(const AParam, AValue: string): integer;
begin     {Add AParam=AValue}
  result := Add(AParam + '=' + AValue);
end;

procedure TValueList.MergeStrings(Strings: TStrings);
{Vermischt Strings. Bestehende Params werden überschrieben}
var
  I: integer;
  S: string;
begin
  for I := 0 to Strings.Count - 1 do
  begin
    //Vergleich vor Zuweisung um Close zu vermeiden 10.02.03 QDispo
    S := Strings.Strings[I];
    if Trim(S) <> '' then
      SetChangedValue(StrParam(S, RightestEqual), StrValue(S, RightestEqual));
  end;
end;

procedure TValueList.Merge(Source: TPersistent);
{Vermischt self mit Daten die von Source mit Assign übernommen werden}
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    AList.Assign(Source);
    MergeStrings(AList);
  finally
    AList.Free;
  end;
end;

function TValueList.SameStrings(Strings: TStrings; IgnoreCase: boolean = false): boolean;
{Ergibt true wenn gleiche Zeilen. Reihenfolge ist egal}
var
  I: integer;
  S1, S2: string;
begin
  Result := false;
  if Count <> Strings.Count then
    Exit;

  Result := true;
  for I := 0 to Count - 1 do
  begin
    S1 := Param(I);
    S2 := Value(I);
    if IgnoreCase then
      Result := SameText(Strings.Values[S1], S2) else
      Result := Strings.Values[S1] = S2;
    if not Result then
      Break;
  end;
end;

function TValueList.GetString(Ident, Default: string): string;
{liest Values[Ident]}
begin
  result := GetStringsString(self, Ident, Default);
end;

function TValueList.GetBool(Ident: string; Default: boolean): boolean;
{liest Values[Ident] als boolean}
begin
  result := GetStringsBool(self, Ident, Default);
end;

function TValueList.GetInteger(Ident: string; Default: Integer): Integer;
{liest Values[Ident] als Integer}
begin
  result := GetStringsInteger(self, Ident, Default);
end;

function TValueList.GetFloat(Ident: string; Default: Double): Double;
{liest Values[Ident] als Float}
begin
  result := GetStringsFloat(self, Ident, Default);
end;

(*** TDataPos *****************************************************************)

procedure TDataPos.SetSQL(ATableName: string; AQuery: TUQuery);
{Aufbau vom SQL-Befehl}
var
  i:integer;
  S1: string;
  Erster: boolean;
begin
  with AQUery do
  begin
    Erster := true;
    SQL.Clear;
    SQL.Add(Format('SELECT * FROM %s', [ATableName]));
    for i := 0 to Count - 1 do
    begin
      if Erster = true then
        S1 := 'WHERE' else
        S1 := 'AND';
      Erster := false;
      SQL.Add(Format('%5s %s', [S1, Strings[i]]));
    end;
    {for i:=0 to SQL.Count-1 do Prot.A('SQL%d(%s)',[i,SQL.Strings[i]]);}
  end;
end;

procedure TDataPos.FillFieldText(APrefix: string; ADataSet: TDataSet;
  NoNullValues: boolean = false);
(* Ergänzt DataPos um Feld-Displaytexte in ADataSet.
   Bestehende Feldnamen werden überschrieben (falls Prefix gleich bzw. fehlt)
   APrefix wird den Parametern vorangestellt, z.B. 'VORF.'
   für MailTemplate
*)
var
  I: Integer;
  S: string;
begin
  // kein Clear!
  with ADataSet do
  begin
    for I := 0 to FieldCount - 1 do
    try                                      // angezeigter Text
      S := GetFieldText(Fields[I]);
      if (S <> '') or not NoNullValues then
        Values[APrefix + Fields[I].FieldName] := S;
    except on E:Exception do
      EProt(ADataSet, E, 'FillValues(%s)', [ADataSet.Fields[I].FieldName]);
    end;
  end;
end;

procedure TDataPos.ReadFieldValues(APrefix: string; ADataSet: TDataSet);
// Liest Feldnamen und Werte von Dataset ein. Hängt Prefix vor Feldnamen. 04.03.10.
var
  I: Integer;
begin
  // kein Clear!
  ADataSet.Open;
  with ADataSet do
  begin
    for I := 0 to FieldCount - 1 do
      Values[APrefix + Fields[I].FieldName] := GetFieldValue(Fields[I]);  //AsString
  end;
end;

procedure TDataPos.AddFieldValues(APrefix: string; ADataSet: TDataSet);
// Liest nur Feldwerte mit Inhalt von Dataset ein. Hängt Prefix vor Feldnamen. 04.03.10.
//Felddwerte ohne ohne Inhalte überschreiben Param nicht.
var
  I: Integer;
  S: string;
begin
  // kein Clear!
  ADataSet.Open;
  with ADataSet do
  begin
    for I := 0 to FieldCount - 1 do
    begin
      S := Trim(GetFieldValue(Fields[I]));
      if S <> '' then
        Values[APrefix + Fields[I].FieldName] := S;  //AsString
    end;
  end;
end;

procedure TDataPos.WriteFieldValues(APrefix: string; ADataSet: TDataSet);
// Schreibt nach DataSet. Kein fehler wenn feldname auf der linken Seite nicht gefunden wurde
// wenn Prefix <> '' dann werden nur Felder mit Prefix geschrieben 04.03.10
var
  I: Integer;
  AFieldName: string;
  AField: TField;
  AValue: string;
begin
  ADataSet.Open;
  with ADataSet do
    for I := 0 to Count - 1 do
    begin
      AFieldName := Param(I);
      if (APrefix <> '') and BeginsWith(AFieldName, APrefix, true) then
        AFieldName := Copy(AFieldName, Length(APrefix) + 1, Maxint);
      AField := FindField(AFieldName);
      if AField = nil then
        continue;                         {z.B. bei CalcFields}
      AValue := Trim(Value(I));
      SetFieldComp(AField, AValue);
    end;
end;

procedure TDataPos.GetValues(ADataSet: TDataSet);
(* Füllt bestehende Felder mit Werten aus Dataset
   * für Return
*)
var
  ALine: string;
  I: Integer;
begin
  Clear;
  with ADataSet do
    for i:= 0 to FieldCount-1 do
    begin
      {if not (Fields[i].DataType in
         [ftBytes, ftVarBytes, ftBlob, ftMemo, ftGraphic]) then}
      try
        {ALine := Fields[i].FieldName + '=' + GetFieldText(Fields[i]);}
        ALine := Format('%s=%s', [Fields[i].FieldName, GetFieldValue(Fields[i])]);
        Add(ALine);
        {protA('getvalue%d(%s)',[i,ALine]);}
      except on E:Exception do           {080400}
        EProt(ADataSet, E, 'GetValues(%s)', [ADataSet.Fields[I].FieldName]);
      end;
    end;
end;

procedure TDataPos.GetNNValues(ADataSet: TDataSet);
(* Füllt bestehende Felder mit Werten aus Dataset die nicht null sind
   * für Return *)
var
  I: Integer;
begin
  Clear;
  with ADataSet do
    for i:= 0 to FieldCount-1 do
      if not Fields[i].IsNull then
      begin
        AddFmt('%s=%s', [Fields[i].FieldName, GetFieldValue(Fields[i])]);
      end;
end;

procedure TDataPos.PutValues(ADataSet: TDataSet);
(* Füllt DataSet bestehende Felder mit Werten aus DataPos
   * für QNav.Exception, LNav.Take
   - Exception wenn Feld nicht gefunden
*)
var
  I: Integer;
  AField: TField;
begin
  with ADataSet do
    for i:= 0 to Count-1 do
    try
      AField := FieldByName(Param(I));
      SetFieldComp(AField, Trim(Value(I)));  //Trim für QDocs.DebMas
    except on E:Exception do
      EProt(ADataset, E, 'DataPos.PutValues', [0]);
    end;
end;

procedure TDataPos.PutFieldValues(ADataSet: TDataSet; AMasterSource: TDataSource);
(* schreibt DataPos nach ADataSet, aber wandelt ':'+Feldname in Wert um *)
var
  I: Integer;
  AField: TField;
  AValue: string;
begin
  with ADataSet do
    for i := 0 to Count - 1 do
    begin
      AField := FindField(Param(I));
      if AField = nil then
        continue;                         {z.B. bei CalcFields}
      AValue := Value(I);
      if char1(AValue) = ':' then
      begin
        if (AMasterSource <> nil) and (AMasterSource.DataSet <> nil) then
          AValue := GetFieldValue(
            AMasterSource.DataSet.FieldByName(copy(AValue, 2, MaxInt)))   //250
        else
          Continue;
      end;
      SetFieldComp(AField, AValue);
    end;
end;

procedure TDataPos.PutRefValues(ADataSet: TDataSet; ARefSource: TDataSource);
(* schreibt nach ADataSet. Feldnamen von Dataset stehen auf der rechten Seite,
   mit ':' davor. Feldnamen von RefSource stehen auf der linken Seite
   (wie PutFieldValues aber li und re Seiten vertauscht) für LNav.Take *)
var
  I: Integer;
  AField: TField;
  AValue, AParam: string;
begin
  with ADataSet do
    for I := 0 to Count - 1 do
    begin
      AValue := Value(I);
      if char1(AValue) = ':' then
      begin
        AField := FindField(copy(AValue, 2, MaxInt));  //250
        if AField = nil then
          continue;                         {z.B. bei CalcFields???}
        AParam := GetFieldValue(ARefSource.DataSet.FieldByName(Param(I)));
        SetFieldComp(AField, AParam);
      end;
    end;
end;

procedure TDataPos.PutValuesNull(ADataSet: TDataSet);
(* Löscht Felder von DataPos
   * DetailTab.Delete
   - Exception wenn Feld nicht gefunden
*)
var
  I: Integer;
  AField: TField;
  OldReadOnly: boolean;
begin
  with ADataSet do
    for i:= 0 to Count-1 do
    begin
      AField := FieldByName(Param(I));
      OldReadOnly := AField.ReadOnly;
      if OldReadOnly then
        AField.ReadOnly := false;
      AField.Clear;
      if OldReadOnly then
        AField.ReadOnly := OldReadOnly;
    end;
end;

function TDataPos.Compare(AFieldList: TList; IgnoreCase: boolean): boolean;
(* Loop über Fields in Datapos
*)
var
  AValue: string;
  AField: TField;
  I: Integer;
  Value1, Value2: string;
  P: integer;
begin
  result := false;
  for I := 0 to Count - 1 do
  begin
    AField := TField(AFieldList.Items[I]);
    AValue := Value(I);
    if AValue = '' then
      result := true else
    if AValue = '=' then                      {Leerwert QDispo 070401}
      result := FieldIsNull(AField) else
    if AValue = '>=' then                      {not null webab 20.05.09}
      result := not FieldIsNull(AField) else
    if BeginsWith(AValue, '>=') then
    begin
      AValue := copy(AValue, 3, Maxint);
      result := CompFieldValue(AField, AValue, IgnoreCase) >= 0;
    end else
    if BeginsWith(AValue, '<>') then
    begin
      AValue := copy(AValue, 3, Maxint);
      result := CompFieldValue(AField, AValue, IgnoreCase) <> 0;
    end else
    if BeginsWith(AValue, '>') then
    begin
      AValue := copy(AValue, 2, Maxint);
      result := CompFieldValue(AField, AValue, IgnoreCase) > 0;
    end else
    if BeginsWith(AValue, '<=') then
    begin
      AValue := copy(AValue, 3, Maxint);
      result := CompFieldValue(AField, AValue, IgnoreCase) <= 0;
    end else
    if BeginsWith(AValue, '<') then
    begin
      AValue := copy(AValue, 2, Maxint);
      result := CompFieldValue(AField, AValue, IgnoreCase) < 0;
    end else
    if Pos('..', AValue) >= 2 then
    begin  //Value1..Value2. Nicht bei "Laden ..."! Translate!
      P := Pos('..', AValue);
      Value1 := copy(AValue, 1, P - 1);
      Value2 := copy(AValue, P + 2, Maxint);
      if IsFloatStr(Value1) and IsFloatStr(Value2) then
        result := (CompFieldValue(AField, Value1, IgnoreCase) >= 0) and
                  (CompFieldValue(AField, Value2, IgnoreCase) <= 0)
      else
        result := CompFieldValue(AField, AValue, IgnoreCase) = 0;
    end else
      result := CompFieldValue(AField, AValue, IgnoreCase) = 0;       {Text 161098}
    if result = false then break;
  end;
end;

function TDataPos.IsPos(ATable: TDataSet; IgnoreCase: boolean = false): boolean;
(* Result: true wenn aktuelle Feldwerte den DataPos-Zeilen entsprechen
           false wenn ungleich
*)
var
  AFieldList: TList;
  HasValue: boolean;
  AFieldName: string;
  AField: TField;
  I: integer;
begin
  result := false;
  with ATable do
  try
    Open;
    AFieldList := TList.Create;
    HasValue := false;
    for I := 0 to Count-1 do
    begin
      AFieldName := OnlyFieldName(Param(I));
      AField := FindField(AFieldName);
      if AField <> nil then
      begin
        AFieldList.Add(AField);
        if Value(I) <> '' then
          HasValue := true;      //wir haben mind. eine nichtleere Zeile
      end;
    end;
    if HasValue then
      result := Compare(AFieldList, IgnoreCase);    {Aktuelle Daten vergleichen}
  except on E:Exception do
    EProt(ATable, E, 'TDataPos.IsPos', [0]);
  end;
end;

function TDataPos.GotoPos(ATable: TDataSet): boolean;
(* Durchsucht Table bis Werte in DataPos erreicht
   Result: true wenn gefunden und Positioniert
           false wenn nicht gefunden
*)
begin
  result := GotoPosEx(ATable, []);   //dpoEnableControls
end;

function TDataPos.GotoPosSilent(ATable: TDataSet): boolean;
// ohne Processmessages
begin
  result := GotoPosEx(ATable, [dpoNoProcessMessages]);
end;

function TDataPos.GotoPosSilentText(ATable: TDataSet): boolean;
// ohne Processmessages. Groß/klein egal
begin
  result := GotoPosEx(ATable, [dpoNoProcessMessages, dpoIgnoreCase]);
end;

function TDataPos.GotoPosEx(ATable: TDataSet; Options: TDPosOptions): boolean;
(* Durchsucht Table bis Werte in DataPos erreicht
   Options: dpoEnableControls: ATable bleibt auf ControlsEnabled
            dpoNoProcessMessages: keine Erfolgsanzeige mit GMess
            dpoAbortDlg: Erfolgsanzeige mit AbortDlg
            dpoNext: Sucht ab aktueller Position
            dpoPrior: Sucht rückwärts ab aktueller Position
            dpoIgnoreCase: Groß/klein egal
   Result: true wenn gefunden und Positioniert
           false wenn nicht gefunden
*)
var
  ABookMark: TBookMark;
  RCount: longint;
  AFieldList: TList;
  AFieldName: string;
  AField: TField;
  I: integer;
  HasValue: boolean;
  function ProcessMsg: boolean;
  begin
    result := not GNavigator.NoProcessMessages and
              not (dpoNoProcessMessages in Options);
  end;
  function IsEof: boolean;
  begin
    if dpoPrior in Options then
      result := ATable.bof else
      result := ATable.eof;
  end;
//  function VarFromFieldValue(F: TField; V: string): Variant;
//  begin
//    result := AField.AsVariant;
//    case TVarData(result).VType of
//    varSmallint, varInteger:           result := StrToInt(V);
//    varSingle, varDouble, varCurrency: result := StrToFloat(V);
//    varDate:                           result := StrToDateY2(V);
//    varBoolean:                        result := V = '1';
//    else                               result := V;
//    end;
//  end;
begin
  if Count = 0 then
  begin  //Liste ist leer
    result := true;
    Exit;
  end;
  ATable.Open;
  if ATable.BOF and ATable.EOF then
  begin
    Result := false;
    Exit;
  end;
  AFieldList := TList.Create;
  //with ATable do
  try
    result := false;
    ScrollCntr := 0;                        {für Aufrufer verwendbar}

    HasValue := false;
    for I:=0 to Count-1 do
    begin
      AFieldName := OnlyFieldName(Param(I));
      AField := ATable.FieldByName(AFieldName);
      AFieldList.Add(AField);
      if Value(I) <> '' then
        HasValue := true;
    end;
    if HasValue then                       {Aktuelle Daten vergleichen 140400}
      result := Compare(AFieldList, dpoIgnoreCase in Options);
    if not result then
    try
      if not (dpoEnableControls in Options) then
        ATable.DisableControls;
      ABookMark := ATable.GetBookMark;
      try
        RCount := 0;
        try
          if dpoNext in Options then
            ATable.Next else
          if dpoPrior in Options then
            ATable.Prior else
            ATable.First;
        except on E:Exception do {Ungültiges Funktions-Handle 39/$2706.6/0}
          begin
            ATable.FreeBookMark(ABookMark);
            ATable.Close;
            ATable.Open;
            ABookMark := ATable.GetBookMark;
          end;
        end;
        if ProcessMsg then
        try
          GMess(0);                    {GNav.Canceled zurücksetzen}
          if SysParam.Standard then     {wichtig! nur bei Paradox OK}
            RCount := ATable.RecordCount;
        except  {Tabelle unterstützt Operation nicht}
        end;
        if Count > 0 then
        begin
          while not IsEof do
          begin
            if ProcessMsg then
            begin
              Inc(ScrollCntr);
              GMessA(ScrollCntr, RCount);             {ok wenn rcount=0   140800}
              {if RCount > 0 then
                GMess(ScrollCntr * 100 div RCount) else
              if ScrollCntr < 10 then
                GMess(ScrollCntr) else
                GMess(Round(9.77 * ln(ScrollCntr) - 12.5));}
              if (GNavigator <> nil) and (SysParam.Delay > 0) then
              begin
                SMess('Goto (%s)', [Text]);
                GNavigator.NoProcessMessages := true;
                Delay(SysParam.Delay);
                GNavigator.NoProcessMessages := false;
                SMess0;
              end;
            end;
            result := Compare(AFieldList, dpoIgnoreCase in Options);
            if result = true then break;
            if dpoPrior in Options then
              ATable.Prior else
              ATable.Next;
            if ProcessMsg then
            begin
              if GNavigator.Canceled then       {mit GNavigator.ProcessMessages;}
                break;
            end;
          end;
        end else
          result := true;
        if result = false then
        begin
          ATable.GotoBookMark(ABookMark);
          ScrollCntr := 0;
        end;
      finally
        ATable.FreeBookMark(ABookMark);
      end;
    finally
      if not (dpoEnableControls in Options) then
      begin
        ATable.EnableControls;
        //neu GNavigator.EnableControls(ATable);  //Mit MuGri Scrollbars update
      end;
    end;
  finally
    AFieldList.Free;
    if ProcessMsg then
      GMess(0);
  end;
end;

function TDataPos.CompareNearest(AFieldList: TList): integer;
(* Loop über Fields in Datapos. ergibt Vergleich Table - DataPos: <0; 0; >0 *)
var
  AValue: string;
  AField: TField;
  I: Integer;
begin
  result := 0;
  for I := 0 to Count-1 do
  begin
    AField := TField(AFieldList.Items[I]);
    AValue := Value(I);
    if AValue <> '' then
      result := ScanFieldValue(AField, AValue) else
      result := 0;
    if result <> 0 then
      break;
  end;
end;

function TDataPos.GotoNearest(ATable: TDataSet; Options: TDPosOptions = []): integer;
(* Durchsucht Table bis größter Wert der kleiner/gleich in DataPos ist erreicht
   (bisher:Result: 1; 0 wenn nicht gefunden)
   Result: 0=exakt gefunden; -1=kleineren gefunden; -2=keinen gefunden; 1=größeren gefunden
   Options: dpoEnableControls: ATable bleibt auf ControlsEnabled
            dpoNoProcessMessages: keine Erfolgsanzeige mit GMess
       n.u. dpoAbortDlg: Erfolgsanzeige mit AbortDlg
            dpoNext: Sucht ab aktueller Position
            dpoPrior: Sucht rückwärts ab aktueller Position    28.08.06
            dpoPrior+dpoNext: Sucht in beide Richtungen        28.08.06
            dpoDesc: Tabelle ist absteigend sortiert
            dpoCursor: Mit HourGlass
   Vor: Tabelle muß nach Feldern in DataPos sortiert sein
*)
  function IsEof: boolean;
  begin
    if dpoPrior in Options then
      result := ATable.bof else
      result := ATable.eof;
  end;
  function ProcessMsg: boolean;
  begin
    result := not GNavigator.NoProcessMessages and
              not (dpoNoProcessMessages in Options);
  end;
var
  Cntr: longint;
  RCount: longint;
  AFieldList: TList;
  AFieldName: string;
  AField: TField;
  I, N: integer;
  DescFaktor: integer;
begin
  if dpoDesc in Options then
    DescFaktor := -1 else
    DescFaktor := 1;
  AFieldList := TList.Create;
  with ATable do
  try
    result := -2;  //eof, keinen gefunden
    if dpoCursor in Options then
      Screen.Cursor := crHourGlass;
    if not (dpoEnableControls in Options) then
      DisableControls;
    if Count = 0 then  //leere DataPos
    begin
      if not (dpoNext in Options) then  //auch hier wg. Komp. mit TLNavigator.SetReturn
        First;
      result := 0;  //Filterlist hat keine Einträge -> alles passt exakt
    end else
    begin
      for I := 0 to Count - 1 do
      begin
        AFieldName := OnlyFieldName(Param(I));
        AField := ATable.FieldByName(AFieldName);
        AFieldList.Add(AField);
      end;
      N := CompareNearest(AFieldList) * DescFaktor;
      if N = 0 then
      begin
        result := 0;
      end else
      if (N > 0) and (dpoNext in Options) and not (dpoPrior in Options) then
      begin
        result := 1;  //größeren gefunden
      end else
      begin
        RCount := 0;
        if N > 0 then
        begin
          if dpoPrior in Options then
            Options := Options - [dpoNext]
          else
            First;
        end else
        begin  // N < 0
          Options := Options - [dpoPrior];
        end;
        Cntr := 0;
        GMess(0);                     {GNav.Canceled zurücksetzen}
        if ProcessMsg then
        try
          if SysParam.Standard then     {wichtig! nur bei Paradox OK}
            RCount := RecordCount else
            SysUtils.Abort;
        except
          RCount := 10000;              {Tabelle unterstützt Operation nicht}
        end;
        while not IsEof do
        begin
          Inc(Cntr);
          if ProcessMsg then
          begin
            if RCount > 0 then
              GMessA(Cntr, RCount) else
            if Cntr < 10 then
              GMess(Cntr) else
              GMess(Round(9.77 * ln(Cntr) - 12.5));
          end;
          N := CompareNearest(AFieldList) * DescFaktor;
          if N > 0 then
          begin
            Prior;
            if not (dpoPrior in Options) then
            begin
              result := Sgn(CompareNearest(AFieldList) * DescFaktor);
              break;
            end;
          end else
          if N = 0 then
          begin
            result := 0;
            break;
          end else
          begin  // N < 0
            Next;
            if dpoPrior in Options then
            begin
              result := Sgn(CompareNearest(AFieldList) * DescFaktor);
              break;
            end;
          end;
          if ProcessMsg then
            if GNavigator.Canceled then       {mit GNavigator.ProcessMessages;}
              break;
        end;
      end;
    end;
  finally
    AFieldList.Free;
    if not (dpoEnableControls in Options) then
      EnableControls;
    if dpoCursor in Options then
      Screen.Cursor := crDefault;
    if ProcessMsg then
      GMess(0);
  end;
end;

procedure TDataPos.PutReferenceFields(ADataSet: TDataSet; IndexFields: string;
  MasterSource: TDataSource; MasterFields: string);
(* Feldinhalte von IndexFields nach Masterfields kopieren
   * für Return *)
begin
  SetReferenceFields(ADataSet, IndexFields, MasterSource, MasterFields, false);
end;

procedure TDataPos.AddReferenceFields(ADataSet: TDataSet; IndexFields: string;
  MasterSource: TDataSource; MasterFields: string);
(* Feldinhalte von IndexFields nach Masterfields hinzufügen (Trenner = ';')
   * für Return + lumSuch *)
begin
  SetReferenceFields(ADataSet, IndexFields, MasterSource, MasterFields, true);
end;

procedure TDataPos.SetReferenceFields(ADataSet: TDataSet; IndexFields: string;
  MasterSource: TDataSource; MasterFields: string; Add: boolean);
(* Feldinhalte von IndexFields nach Masterfields kopieren/hinzufügen (Trenner = ';')
   ! DataPos enthält mindestens alle Felder mit Values aus IndexFields *)
var
  LPos, MPos: TDataPos;
  MSource: TDataSource;
  MTable: TDataSet;
  AField: TField;
  LFieldName, MFieldName: string;
  AValue: string;
  I, P: Integer;
  OldReadOnly: boolean;
begin
  if MasterSource = nil then exit;

  InPutReferenceFields := true;
  LPos := TDataPos.Create;
  LPos.AddTokens(IndexFields,';');
  for I:= 0 to LPos.Count-1 do
  begin
    LFieldName := OnlyFieldName(LPos.Strings[I]);
    LPos.Strings[I] := LFieldName;
  end;
  MPos := TDataPos.Create;
  MPos.AddTokens(MasterFields,';');
  for I:= 0 to MPos.Count-1 do
  begin
    MFieldName := OnlyFieldName(MPos.Strings[I]);
    MPos.Strings[I] := MFieldName;
  end;
  MSource := MasterSource;
  MTable := MSource.DataSet;
  MFieldName := '';
  {MTable.DisableControls;  {lädt ALLES später nach: lädt zu viel}
  try
    for P:= 0 to MPos.Count-1 do    {Reihenfolge der Keysegs! 140298 DPE}
    {for P:= MPos.Count-1 downto 0 do        {Hauptfeld zum Schluß  050797 ROE.Kund}
    try
      LFieldName := LPos.Param(P);
      AValue := Values[LFieldName];
      MFieldName := MPos.Param(P);
      AField := MTable.FieldByName(MFieldName);
      {protA('PutRef%d(%s):=(%s)',[p,MFieldName,AField.Text]);}
      OldReadOnly := AField.ReadOnly;
      AField.ReadOnly := false;
      if Add then
        AddFieldText(AField, AValue) else //Trenner ist ';'
      begin
        SetFieldText(AField, AValue);    {kein Comp!}
      end;
      if OldReadOnly then
        AField.ReadOnly := OldReadOnly;
    except on E:Exception do
      EMess(ADataSet, E, 'SetReferenceFields(%s.%s)', [MTable.Name, MFieldName]);
    end;
  finally
    {MTable.EnableControls;}
    LPos.Free;
    MPos.Free;
    InPutReferenceFields := false;
  end;
end;

procedure TDataPos.AddFieldsValue(ADataSet: TDataSet; Fields: string);
(* Feldnamen in <Fields>, mit ; getrennt mit Werten als FltrList ergänzen *)
var
  AFieldName: string;
  I, I0: integer;
begin
  I0 := Count;
  AddTokens(Fields, ';');
  for I:= I0 to Count-1 do
  begin
    AFieldName := Strings[I];
    Strings[I] := Format('%s=%s', [AFieldName,
      GetFieldValue(ADataSet.FieldByName(AFieldName))]);
     {GetFieldText(ADataSet.FieldByName(AFieldName))}
  end;
end;

procedure TDataPos.ExtractFields(Fields: string);
(* Alle Zeilen in DataPos mit Feldnamen in Fields (mit ; getrennt) löschen *)
var
  TmpList: TValueList;
  I: integer;
begin
  TmpList := TValueList.Create;
  try
    TmpList.AddTokens(Fields, ';');
    for I:= Count-1 downto 0 do
      if TmpList.IndexOf(Param(I)) < 0 then
        Delete(I);
  finally
    TmpList.Free;
  end;
end;

procedure TDataPos.AddFieldsIsNull(ADataSet: TDataSet; Fields: string);
(* Feldnamen in <Fields>, mit ; getrennt als Is Null Filter in FltrList ergänzen
   urspr. für  SetReturn bei DetailLookUp, jetzt nicht mehr benutzt *)
var
  AFieldName: string;
  I, I0: integer;
begin
  I0 := Count;
  AddTokens(Fields, ';');
  for I:= I0 to Count-1 do
  begin
    AFieldName := Strings[I];
    Strings[I] := Format('%s==', [AFieldName]);                    (* is null *)
  end;
end;

procedure TDataPos.AddFieldListIsNull(AFieldList: TValueList);
(* Ergänzt FltrList mit Feldern aus AFieldList mit is null *)
var
  I: integer;
  AFieldName: string;
begin
  for I:= 0 to AFieldList.Count-1 do
  begin
    AFieldName := AFieldList.Param(I);
    Add(Format('%s==',[AFieldName]));
  end;
end;

procedure TDataPos.AssignIndexFields(ADataPos: TDataPos; IndexFields: string);
begin    //kopiert ohne '='
  AssignIndexFields(ADataPos, IndexFields, false);
end;

procedure TDataPos.AssignIndexFields(ADataPos: TDataPos; IndexFields: string;
  SetNull: boolean);
(* Kopiert die Zeilen von ADataPos, deren linke Seite in IndexFields enthalten ist.
   Kopiert alle Zeilen wenn IndexFields leer ist.
   IndexFields enthält Feldnamen mit ';' getrennt.
   SetNull: true=bei leeren Feldern wird '=' (für Filter) eingesetzt
*)
var
  IndexList: TValueList;
  I, iIndex: integer;
begin
  Clear;
  if IndexFields <> '' then
  begin
    IndexList := TValueList.Create;
    try
      IndexList.AddTokens(IndexFields, ';');
      for I:= 0 to ADataPos.Count-1 do
        if IndexList.Find(ADataPos.Param(I), iIndex) then
        begin
          if SetNull then
            Add(ADataPos.Param(I) + '=' + StrDflt(ADataPos.Value(I), '=')) else
            Add(ADataPos.Strings[I]);
        end;
    finally
      IndexList.Free;
    end;
  end else                       {keine IndexFields -> alles kopieren:}
    for I:= 0 to ADataPos.Count-1 do
      if SetNull then
        Add(ADataPos.Param(I) + '=' + StrDflt(ADataPos.Value(I), '=')) else
        Add(ADataPos.Strings[I]);
end;

procedure TDataPos.GetMasterFields(ADataSet: TDataSet; IndexFields: string;
  MasterSource: TDataSource; MasterFields: string);
(* Baut Stringliste auf. Syntax: <Sekundär-Fieldname>=<Value>
   1. Mastersource identifizieren
   2. Loop über Masterfields von ATable:
      - Feldinhalte in Stringliste kopieren
   * Filter der anderen Felder später
   * für lookup Vorbereiten
*)
var
  MSource: TDataSource;
  MTable: TDataSet;
  MPos: TDataPos;
  FieldName, MFieldName: string;
  AField: TField;
  I: integer;
begin
  Clear;
  if MasterSource = nil then
  begin
    // ProtP('%s:Mastersource fehlt',[ADataSet.Name]) else           {geht auch}
    if SysParam.ProtBeforeOpen then
      ProtP(SDPos_Kmp_001, [ADataSet.Name]);           {geht auch}
  end else
  if MasterFields = '' then
  begin
    // ProtP('%s:MasterFields fehlt',[ADataSet.Name]) else           {geht auch}
    if SysParam.ProtBeforeOpen then
      ProtP(SDPos_Kmp_002, [ADataSet.Name]);           {geht auch}
  end else
  begin
    MPos := TDataPos.Create;   {Temporäre Stringliste anlegen}
    MSource := MasterSource;
    MTable := MSource.DataSet;
    MPos.AddTokens(MasterFields,';');  {Aus MasterFields Liste aufbauen}
    AddTokens(IndexFields,';');     {todo: alle Felder, wg. LU-Filter}
    for I := Count-1 downto 0 do
    begin
      MFieldName := Trim(MPos.Strings[i]); {Feldname holen}
      AField := MTable.FieldByName(MFieldName);  {Feld dazu}
      (*
      if AField.IsNull then
      begin
        Delete(I);
        MPos.Delete(I);
      end else
      *)
      begin
        FieldName := Strings[i];  {Feldname aus eigener DataPos}
        {Strings[i] := FieldName + '=' + GetFieldText(AField);}
        Strings[i] := Format('%s=%s', [FieldName, GetFieldValue(AField)]);
                                                        {Wert aus Mastertabelle}
        if Param(I) = '' then
          Delete(I);                               {111098 dpe.vorf.kund lookup}
      end;
    end;
    {for I := Count-1 downto 0 do Prot.A('get%d(%s)',[i,strings[i]]);}
  end;
end;

(* FltrList *)

procedure TFltrList.AddFltrList(ADataSet: TDataSet; AList: TValueList;
  TblRef: boolean = true; ForceNull: boolean = true);
(* Ergänzt Filter um Parameter. Wandelt Parameter in Werte um
   is null - Filter wenn Feldwert in Parameter leer 030399
   TblRef: false = Table-Referenzen werden nicht übernommen (Tbl1.Fld1=Tbl2.Fld2) (140201 GEN)
           true = mit Referencen (für LuGrid)
   für TLNavigator.SetReturn *)
var
  I, P, P1, PK1, PK2: integer;
  AValue, AFieldValue, AFieldName: string;
  AField: TField;
begin
  for I:= 0 to AList.Count-1 do
  begin
    AValue := AList.Value(I);
    P := Pos('.', AValue);
    if not TblRef and (P > 0) and (IsValidIdent(copy(AValue, P+1, 100))) then
      continue;                                        {(Tbl1.Fld1=Tbl2.Fld2)}
    repeat
      P := Pos(':', AValue);
      while P > 0 do
      begin
        P1 := 1;
        AFieldName := '';
        while (P+P1 <= length(AValue)) and IsValidIdent(copy(AValue, P+1, P1)) do
        begin
          AFieldName := copy(AValue, P+1, P1);
          Inc(P1);
        end;
        if not ADataSet.Active then
          ADataSet.Open;
        AField := ADataSet.FindField(AFieldName);
        if AField <> nil then
        begin
          PK1 := Pos('{', AValue);
          PK2 := Pos('}', AValue);
          if PK2 = 0 then
          begin          //16.03.10 - Feld=[dbo.STRIP_KFZ(:FAHR_KNZ)]
            PK1 := Pos('[', AValue);
            PK2 := Pos(']', AValue);
          end;
          AFieldValue := GetFieldValue(AField);
          if (AFieldValue = '') and ForceNull then
            AFieldValue := '='; {force null   030399}
          System.Delete(AValue, P, P1);      {':' u. FieldName entfernen (:F+1)}
          if (Pk1 < P) and (P < Pk2) and not (AField is TNumericField) then
          begin      (* bei {} Klammern Konstanten übernehmen (1+{select ..}) *)
            if AFieldValue = '=' then
              AFieldValue := '''''' else     {da keine is null Umsetzung in Gen SQL}
            if not (AField is TNumericField) then
              AFieldValue := Format('''%s''', [AFieldValue]);
            System.Insert(AFieldValue, AValue, P);
          end else
            System.Insert(AFieldValue, AValue, P);
          //Falls Feldinhalt = ':'+Feldname ist dann infinite loop vermeiden - lawa23.05.08:
          P := P + length(AFieldValue) +
               Pos(':', copy(AValue, P + length(AFieldValue) + 1, MaxInt));
        end else
          P := 0;    {break geht hier nicht!?}
      end;
    until P <= 0;
    Add(Format('%s=%s', [AList.Param(I), AValue]));
  end;
end;

procedure TFltrList.SetFltrField(AField: TField);
{setzt Filter auf den aktuellen Wert des Feldes}
begin
  {Values[AField.FieldName] := GetFieldText(AField);}
  Values[AField.FieldName] := GetFieldValue(AField);
end;

procedure TFltrList.CopyFltrValues(ADataSet: TDataSet);
(* Kopiert Filter als Feldwerte. Nur Eqal-Filter zur Belegung bei Insert
   :Feldnamen werden anhand Dataset.Datasource in Werte umgewandelt *)
var
  I, J, P: integer;
  AValue, AFieldName: string;
  AField: TField;
  OldReadOnly: boolean;
  MDataSet: TDataSet;
  MField: TField;
begin
  for I:= 0 to Count-1 do
  begin
    AValue := TranslateSql(Value(I));  //* -> %  todo: sysdate+1 -> xx.xx.xx
    P := 0;  //P := InStr('=<>~|%_;', AValue);
    for J := 1 to length(AValue) do
    begin
      //wenn diese Zeichen nicht auf der rechten Seite sind ist es ein Equal Filter. 31.05.14:'!'
      if CharInSet(AValue[J], OptTokens + BlockTrenner + BetweenTrenner + ['%', '?', '!']) then
      begin
        P := J;
        Break;
      end;
    end;
    if P = 0 then
    begin
      P := PosI('sysdate', AValue); { TODO -oMD -cKMP : sysdate+n -> xx.xx.xxxx in TranslateSql }
    end;
    if P = 0 then
    try
      AFieldName := OnlyFieldName(Param(I));   {Tablename weg}
      AField := ADataSet.FindField(AFieldName); {muß so wg. QWF.Aufk }
      if AField <> nil then             {wenn vorhanden .SO_WERK_NR         }
      begin
        {if (copy(AValue, 1, 1) = ':') and (ADataSet is TUQuery) then
         AValue := TUQuery(ADataSet).ParamByName(copy(AValue, 2, 250)).Text;}
        if (copy(AValue, 1, 1) = ':') and (ADataSet is TUQuery) and
           (ADataSet.DataSource <> nil) then
        begin
          MDataSet := TUQuery(ADataSet).DataSource.DataSet;
          MField := MDataSet.FieldByName(copy(AValue, 2, MaxInt));
          AValue := MField.AsString;      //Text schlecht bei float-Format
        end;
        OldReadOnly := AField.ReadOnly;
        if AField.ReadOnly then
          AField.ReadOnly := false;
        AField.AsString := AValue;
        if OldReadOnly then
          AField.ReadOnly := true;
      end;
    except on E:Exception do
      EProt(self, E, 'CopyFltrValues[%d]:(%s)',[I, Strings[I]]);
    end;
  end;
end;

function TFltrList.GetParamFieldNames: string;
{Untersucht nur Zeilen i.d.F. <ParamFeld>=:<ValueFeld> (vergl. SOList, References, FltrList)
 Ergibt die Feldnamen links vom '=', mit ';' getrennt. }
var
  I: integer;
  AFieldName, NextS: string;
begin
  result := '';
  for I:= 0 to Count - 1 do
  begin
    AFieldName := PStrTok(Value(I), ';', NextS);
    if Char1(AFieldName) = ':' then
      AppendTok(result, Param(I), ';');
  end;
end;

function TFltrList.GetValueFieldNames: string;
{Untersucht nur Zeilen i.d.F. <ParamFeld>=:<ValueFeld> (vergl. SOList, References, FltrList)
 Ergibt die Feldnamen rechts vom '=', mit ';' getrennt. }
var
  I: integer;
  AFieldName, NextS: string;
begin
  result := '';
  for I:= 0 to Count - 1 do
  begin
    AFieldName := PStrTok(Value(I), ';' + CharSetToStr(BlockTrenner), NextS);
    if Char1(AFieldName) = ':' then
      AppendTok(result, Copy(AFieldName, 2, length(AFieldName)-1), ';');
  end;
end;

function TFltrList.BuildSqlDelete(AQuery: TUQuery; ATblName: string;
                                   var ErrorFieldName: string): boolean;
{baut kompleten SQL-Befehl für Delete-Anweisung bezogen auf die Filter in DataPos}
{ErrorFieldName Fehlerausgabe}
var
  ADatabase: TUDatabase;

  function FName(FN: string): string;              {case sensitiver Feldname}
  var
    AFieldDef: TFieldDef;
    TName: string;
    P1: integer;
  begin
    P1 := Pos('.', FN);
    if P1 > 0 then
      TName := copy(FN, 1, P1) else          {mit '.'}
      TName := '';
    AFieldDef := FldDsc.FieldDef[ADatabase, ATblName, FN];
    if AFieldDef = nil then
      result := FN else
      result := Format('%s%s', [TName, AFieldDef.Name]);
  end;

  function FType(FN: string): TFieldType;              {Feldtyp}
  var
    AFieldDef: TFieldDef;
  begin
    AFieldDef := FldDsc.FieldDef[ADatabase, ATblName, FN];
    if AFieldDef = nil then
      result := ftString else
      result := AFieldDef.DataType;
  end;
var
  I, AswNr: integer;
  S1, ErrLine: string;
  ADataType: TFieldType;
  AFieldName, AFieldValue: string;
  QbeLine, Trenn: string;
  SqlLines: TStringList;
  AReadOnly: boolean;
begin
  result := true;
  QbeLine := '';
  if ATblName = '' then Exit;
  if AQuery = nil then Exit;
  SqlLines := TStringList.Create;
  try
    ADatabase := QueryDatabase(AQuery);
    ATblName := GNavigator.TableSynonym[ATblName];   //neu 24.07.03
    if (Pos('.',ATblName) > 0) and (Pos('"',ATblName) <= 0) and
       (IsLocalQuery(AQuery) or AQuery.RequestLive) then
      Trenn := '"' else
      Trenn := '';
    try
      for I := 0 to Count - 1 do
      begin
        ErrLine := Strings[i];
        AFieldName := Param(I);
        AFieldValue := Value(I);
        if AQuery.FieldCount > 0 then {Datentyp holen}
        begin
          ADataType := AQuery.FieldByName(AFieldName).DataType;
          AswNr := AQuery.FieldByName(AFieldName).Tag;
        end else
        begin
          ADataType := FType(AFieldName);
          AswNr := 0;
        end;
        {z.B. 5~10 wird übersetzt in ((AFieldName >= 5) and (AFieldName <= 10))}
        AReadOnly := true;
        if not GenerateSQL(AFieldValue, FName(AFieldName), ADataType,
                            AReadOnly, AswNr, QBELine) then
          result := false;       {DBErrorFmt(SFieldNotFound, [AFieldName]);   {entspr. raise}
        if not empty(QBELine) then
          SQLLines.Add(QBELine)
      end;
    except
      on E:Exception do
      begin
        // 'BuildSQLDelete:Feld(%s) in Zeile(%s) falsch:%s',
        ErrWarn(SDPos_Kmp_003, [AFieldName,ErrLine, E.Message]);
        ErrorFieldName := AFieldName;
        result := false;
      end;
    end;
    if result = true then
    begin
      with AQuery do
      begin
        SQL.Clear;
        SQL.Add(Format('delete from %s%s%s', [Trenn, UpperCase(ATblName), Trenn]));

        for I:=0 to SqlLines.Count - 1 do
        begin
          if i = 0 then
            S1 := 'where ' else
            S1 := '  and ';
          SQL.Add(Format('%s%s', [S1, SqlLines.Strings[I]]));
        end;
      end;
    end;
  finally
    SqlLines.Free;
  end;
end;

function TFltrList.BuildSql(AQuery: TUQuery; ATblName: string; AKeyFields: string;
          ASqlFieldList: TStrings; var ErrorFieldName: string; aSqlHint: string = ''): boolean;
(* - FieldTyp anhand Fielddefs
   - Geht auch bei geschlossener Datenmenge
   - keine Calcfelder in SQL, dafür :Parameter und OnParam verwenden
   - mit Group by wenn Fkt in FieldList, zb. max()
   > bei Fehler: false und ErrorFieldName  *)
var
  ADatabase: TUDatabase;
  ATblList: TValueList;      {mit Schema-Modifizierer (QUVA.KUNDEN) }
  ATblAliasList: TValueList; {ohne  Schema-Modifizierer (KUND) }
  MultiTable: boolean;       {true = mehrere Tablenames}

  function IsValidIdentSpecial(const Ident: string): Boolean;
  var
    NextS: string;
  begin
    result := IsValidIdent(PStrTok(Ident, '( ', NextS));
  end;

  function FName(FN: string; OnlyName: boolean = false): string;
  var
    AFieldDef: TFieldDef;
    SPrae, SPost, TbName, TbAliasName: string;
    I, PBlank, P1: integer;
  begin                       {case sensitiver Feldname. ggf mit TableName}
    result := FN;
    PBlank := 0;
    SPrae := '';
    SPost := '';
    if Pos('(', FN) = 0 then         {nicht bei Sql Rechenfeldern wie max()}
    begin
      PBlank := Pos(' ', FN);            {order by NR desc}
      if PBlank > 0 then
      begin
        if CompareText(copy(FN, 1, PBlank - 1), 'DISTINCT') = 0 then
        begin
          SPrae := copy(FN, 1, PBlank);   {'DISTINCT '}
          SPost := '';
          result := copy(FN, PBlank+ 1, MaxInt);
        end else
        begin
          SPrae := '';
          SPost := copy(FN, PBlank, MaxInt);     {' desc'}
          result := copy(FN, 1, PBlank- 1);
        end;
      end;
      TbAliasName := '';
      TbName := ATblList.AsTokenString(';');
      if MultiTable then
      begin
        if Pos('.', result) = 0 then
          if (ASqlFieldList <> nil) and (ASqlFieldList.Count > 0) then
            for I := 0 to ASqlFieldList.Count - 1 do
              if CompareText(result, OnlyFieldName(ASqlFieldList[I])) = 0 then
            begin
              if Pos('=', ASqlFieldList[I]) > 0 then
                result := StrValueDflt(ASqlFieldList[I]); //z.B. Datum=DISP.DATUM
                {result := StrValue(ASqlFieldList[I]) else  10.02.03
                result := ASqlFieldList[I];}
              break;
            end;
        if Pos('.', result) > 0 then    //wurde evtl. durch SqlFieldList[] ergänzt
        begin                              //K1.ORT -> KUND.~
          TbAliasName := OnlyTableName(result);
          result := OnlyFieldName(result);
          for I := 0 to ATblList.Count - 1 do
            if CompareText(TbAliasName, ATblAliasList[I]) = 0 then
            begin                          //K1 -> KUND
              TbName := ATblList[I];        //MARA -> QUVA.MARA für GetFieldInfo
              break;
            end;
        end;
      end;  //MultiTable
      FldDsc.GetFieldInfo(ADatabase, TbName, result, AFieldDef); //muß immer aufgerufen werden wg result
      if MultiTable then                 //obige Zeile checkt Groß/Kleinschrift
      begin
        if TbAliasName = '' then
        begin
          for I := 0 to ATblList.Count - 1 do
            if (CompareText(TbName, ATblList[I]) = 0) or
               (CompareText(TbName, GNavigator.TableSynonyms.Values[ATblList[I]]) = 0) then
            begin
              TbAliasName := ATblAliasList[I];   //QUVA.MARA@db1 -> MARA oder M1
              break;
            end;
        end;
        if TbAliasName <> '' then
          result := Format('%s.%s', [TbAliasName, result]);  //Mara -> QUVA.MARA
      end;
    end;
    P1 := Pos(':', result);
    if (P1 > 0) and TFldDsc.IsDataTypeStr(Copy(Result, P1+1, Maxint)) then
      result := copy(result, 1, P1 - 1);  //CNTR:float ->CNTR
    if not OnlyName then
    begin
      if PBlank > 0 then
        result := SPrae + result + SPost;
    end else
      result := OnlyFieldName(result);   //distinct TN.FN -> FN  für orderby
  end; { FName }

  function FType(FN: string): TFieldType;              {Feldtyp}
  var
    AFieldDef: TFieldDef;
  begin
    if Pos('.', FN) > 0 then    //M1.Field -> Field
      FN := OnlyFieldName(FN);  //nach '.'
    AFieldDef := FldDsc.FieldDef[ADatabase, ATblList.AsTokenString(';'), FN];
    if AFieldDef = nil then
      result := ftString else
      result := AFieldDef.DataType;
  end;

  function NoAggrInLine(S: string): boolean;
  begin  //true = weder Aggregat noch Groupby-fähig
    Result := true;
    if BeginsWith(StrValue(S), '''') then
      Result := false;   // LPOS_ID='0123'
  end;

  function AggrInLine(S: string): boolean;
  const  //true = Aggregatfunction in Zeile S
    Aggs: array[1..52] of string = (
      {MSSGL:13}
      'AVG','MIN','CHECKSUM_AGG','SUM','COUNT','STDEV','COUNT_BIG','STDEVP',
      'GROUPING','VAR','GROUPING_ID','VARP','MAX',
      {Oracle:38}
      'AVG','COLLECT','CORR','CORR_*','COUNT','COVAR_POP','COVAR_SAMP','CUME_DIST',
      'DENSE_RANK','FIRST','GROUP_ID','GROUPING','GROUPING_ID','LAST','MAX','MEDIAN',
      'MIN','PERCENTILE_CONT','PERCENTILE_DISC','PERCENT_RANK','RANK','REGR_*',
      'STATS_BINOMIAL_TEST','STATS_CROSSTAB','STATS_F_TEST','STATS_KS_TEST','STATS_MODE',
      'STATS_MW_TEST','STATS_ONE_WAY_ANOVA','STATS_T_TEST_*','STATS_WSR_TEST','STDDEV',
      'STDDEV_POP','STDDEV_SAMP','SUM','VAR_POP','VAR_SAMP','VARIANCE',
      {Firebird:1}
      'LIST'
    );
    Trenner = '()+-/*[]{}. ';
  var
    S1, NextS: string;
    I1: integer;
  begin
    Result := false;
    if (PosI('SELECT', S) > 0) or (Pos('(', S) <=3) then
      Exit;
    S1 := PStrTok(StrValue(S, RightestEqual), Trenner, NextS, True);
    while S1 <> '' do
    begin
      for I1 := low(Aggs) to High(Aggs) do
      begin
        if (EndsWith(Aggs[I1], '*') and
            SameText(S1, copy(Aggs[I1], 1, Length(Aggs[I1])-1))) or
           SameText(S1, Aggs[I1]) then
        begin
          Result := true;
          Break;
        end;
      end;
      S1 := PStrTokNext(Trenner, NextS, True);
    end;
  end;

(* vor 09.06.13
  function AggrInLine(S: string): boolean;
  const
    // 23.09.08 added MSSQL SUBSTRING
    // 09.11.08 added MSSQL CAST und varchar(
    // 23.05.13 added to_char, to_number
    NoList: array[1..9] of string = ('NVL','SUBSTR','DATEPART','SUBSTRING','UPPER',
      'CAST','VARCHAR', 'TO_CHAR', 'TO_NUMBER');
  var
    P, I, L1: integer;
    S1, SFkt: string;
  begin  //ergibt true wenn Aggregat in Zeile so dass group by notwendig wird
    //ja: sum(nvl(X)); count(); usw.
    //nein substr(); X + NVL(Y); ms:datepart(year,date);
    //sofort nein: sub-select;
    result := false;

    P := Pos('(', S);
    if (PosI('SELECT', S) <= 0) and (P > 3) then
    begin
      while P > 3 do
      begin
        result := true;
        for I := low(NoList) to High(NoList) do
        begin  //Wenn Wort vor dem '(' nicht in NoList dann ist es eine Aggr.Fkt
          S1 := NoList[I];
          L1 := length(S1);
          SFkt := UpperCase(copy(S, P - L1, L1));
          if (P > L1) and (SFkt = S1) then
          begin
            result := false;
            break;   //gefunden. Weiter mit nächster '('
          end;
        end;
        if PosI('dbo.', StrValue(S, RightestEqual)) > 0 then
        begin
          Result := false;  //MSSQL: eigene (deterministische!?) Funktion - webab.dbo.get_lpla_nr()
          Break;
        end;
        if result then
          break;     //nicht gefunden. Ende mit true
        S := copy(S, P + 1, MaxInt);
        P := Pos('(', S);
      end;
    end;
//     P := Pos('(', S);
//     result := (P > 3) and
//               ((PosI('nvl(', S) = 0) or (PosI('sum(', S) > 0)) and
//               (PosI('substr(', S) = 0) and
//               (PosI('select', S) = 0) and   //qupp.mara
//               (PosI('datepart', S) = 0));   //zak.kont
  end;
*)

var
  I, I1, I2, N, P, P1, iField, AswNr: integer;
  ErrLine, NextS: string;
  ShortFieldName, AFieldName, AFieldValue: string;
  QbeLine, ALine, Trenn, Prefix, Postfix, S1, S2, S3: string;
  ADataType: TFieldType;
  OldSql: TStrings;
  ATokenList: TValueList;
  HasAggr: boolean;          {hat Aggregat-Feld(er) z.b. max()}
  NoAggrCount: integer;      {Anzahl Nicht-Aggregat-Felder}
  WherePos: integer;
  ParamType: array[0..128] of TFieldType;
  OldParamCount: integer;
  TmpQuery: TUQuery;
  StartTime: longint;
  AFieldDefs: TFieldDefs;
  AField: TField;
  DataTypeDefined: boolean;
  AReadOnly: boolean;
  KlammerAuf: boolean;        {130799}
  DistinctAny, DistinctOnly: boolean;

begin { BuildSql }
  result := true;
  ErrLine := ATblName;
  if ATblName = '' then Exit;
  if AQuery = nil then Exit;
  {if AQuery.DataBase = nil then Exit;}
  ADatabase := QueryDataBase(AQuery);
  if ADatabase = nil then
    Exit;
  TmpQuery := nil;
  Trenn := '';
  OldSql := TStringList.Create;
  ATokenList := TValueList.Create;
  ATblList := TValueList.Create;
  ATblAliasList := TValueList.Create;
  try
    {AQuery.SQL.BeginUpdate;}
    OldSql.Assign(AQuery.Sql);

    Prefix := 'Find Database';
    if (Pos(',',ATblName) > 0) and (Pos('(', ATblName) = 0) then
    begin
      // VORF_SPACE('SQ',999) ist erlaubt in MS SQL
      // Prot0('%s:TableName enthält "," (%s)', [AQuery.Owner.ClassName, AKeyFields]);
      Prot0(SDPos_Kmp_004, [AQuery.Owner.ClassName, AKeyFields]);
    end;
    ATokenList.AddTokens(ATblName,';');
    MultiTable := Pos(';', ATblName) > 0;
    if SysParam.ReadOnly or
       ((ATokenList.Count > 1) and not (csDesigning in AQuery.ComponentState) and
        not AQuery.CachedUpdates and                         //18.01.05 QUPP
        (AQuery.SQLUpdate.Count = 0)) then                   //26.04.12 QUPP, unidac
    begin
      if AQuery.RequestLive then
      begin
        AQuery.Close;
        AQuery.RequestLive := false;
      end;
    end;
    if GNavigator <> nil then
      S1 := GNavigator.TableSynonyms.Values[ATokenList.Param(0)] else
      S1 := '';
    if S1 = '' then
      S1 := ATokenList.Param(0);
    if (Pos('.', S1) > 0) and (Pos('"',S1) <= 0) and
       (IsLocalQuery(AQuery) {or AQuery.RequestLive}) then
        Trenn := '"';

    with AQuery do
    try
      OldParamCount := ParamCount;
      if (DataSource = nil) and (ParamCount > 0) then
        for I := 0 to ParamCount-1 do
          ParamType[I] := Params[I].DataType;
      SQL.Clear;
      if SQL.Count > 0 then
      begin
        Application.ProcessMessages;
        SQL.Clear;
      end;
      if SQL.Count > 0 then
        SysUtils.Abort;                            {170200 HDO}

      //neuer Abschnitt - md03.05.04
      ATblList.Clear;          //lange Tablenames oder Dflt
      ATblAliasList.Clear;     //kurze Tablenames oder Dflt
      for I:= 0 to ATokenList.Count-1 do
      begin                    //K1=Kunden;K2=Kunden;Schema.Sorten
        S1 := ATokenList[I];
        if (Pos('=', S1) = 0) and (GNavigator <> nil) then
          AppendTok(S1, GNavigator.TableSynonyms.Values[ATokenList[I]], '=');
        S2 := PStrTok(OnlyFieldName(StrParam(S1, RightestEqual)), '(', NextS);  //Fkt('SQ') -> Fkt; Schema.Tblname -> Tblname
        ATblAliasList.Add(S2);  //K1;K2;Sorten
        S1 := StrValueDflt(S1);                  //Kunden;Kunden;Schema.Sorten
        if GNavigator <> nil then
          ATblList.Add(StrDflt(GNavigator.TableSynonyms.Values[S1], S1));  //Kunden@dblink
      end;

      HasAggr := false;
      NoAggrCount := 0;
      if aSqlHint <> '' then
        Prefix := 'select ' +aSqlHint + ' '   //'Top 50' oder '/* first rows */'
      else
        Prefix := 'select ';
      if (ASqlFieldList <> nil) and (ASqlFieldList.Count > 0) then
      begin
        for I := 0 to ASqlFieldList.Count - 1 do
        begin
          ALine := Trim(ASqlFieldList.Strings[I]);
          DistinctAny := PosI('distinct', ALine) > 0;   //quva.kuve.kuso 04.09.03
          DistinctOnly := CompareText('distinct', ALine) = 0;
          ErrLine := ALine;
          if ALine = '' then
            continue;
          if Char1(ALine) = ';' then continue;    {Kommentar}
          if Pos('/*', ALine) > 0 then          // Hints in eigener Zeile ohne Komma original übernehmen (/* Hint irgendwas */)
          begin
            Postfix := '';
          end else
          begin
            if AggrInLine(ALine) then     {161200 FrBa}          {if Pos('(', ALine) > 0 then}
              HasAggr := true else
            if NoAggrInLine(ALine) then   //14.06.10
              Inc(NoAggrCount);
            P := Pos('=', ALine);
            if P > 0 then                            {SQL Rechenfelder}
            begin
              if DistinctAny then
                S1 := '%s as %s' else
                S1 := '(%s) as %s';
              //ALine := Format(S1, [copy(ALine, P+1, MaxInt), FName(copy(ALine, 1, P-1))])  bug 28.09.08
              S2 := copy(ALine, 1, P-1);             //X1:integer
              S3 := copy(ALine, P+1, MaxInt);        //sum(FELD1)
              P1 := Pos(':', S2);
              if (P1 > 0) and   // X1:integer=sum(FELD1) -> X1=sum(FELD1):integer
                 TFldDsc.IsDataTypeStr(copy(S2, P1+1, Maxint)) then
              begin
                S3 := S3 + copy(S2, P1, Maxint);
                S2 := copy(S2, 1, P1 - 1);
              end;
              ALine := Format(S1, [FName(S3), S2]);    //(sum(FELD1)) as X1
            end else
            if not DistinctAny then
              ALine := FName(ALine);
            if (I < ASqlFieldList.Count - 1) and not DistinctOnly then
              Postfix := ',' else
              Postfix := '';
          end;
          SQL.Add(Format('%s%s%s', [Prefix, ALine, Postfix]));
          Prefix := '       ';
        end;
        if SQL.Count > 0 then
        begin
          S1 := SQL[SQL.Count - 1];
          if EndsWith(S1, ',') then
          begin
            System.Delete(S1, length(S1), 1);
            SQL[SQL.Count - 1] := S1;
          end;
        end;
      end else
      begin
        SQL.Add(Prefix + '*');
      end;

      Prefix := 'from ';
      for I:= 0 to ATblList.Count-1 do
      begin
        //if ATblList[I] = ATblAliasList[I] then
        if OnlyFieldName(ATblList[I]) = ATblAliasList[I] then  //Test dbo. 06.02.08
          S1 := Format('%s%s%s', [Trenn, ATblList[I], Trenn]) else
          S1 := Format('%s%s%s %s', [Trenn, ATblList[I], Trenn, ATblAliasList[I]]);
        if I < ATblList.Count-1 then
          Postfix := ',' else
          Postfix := '';
        SQL.Add(Format('%s%s%s', [Prefix, S1, Postfix]));
        Prefix := '     ';
      end;

      WherePos := SQL.Count;
      if HasAggr and (NoAggrCount > 0) then
      begin
        Prefix := 'group by ';
        N := 0;
        for I:= 0 to ASqlFieldList.Count - 1 do        {hier nie nil wg HasAggr}
        begin
          if (ASqlFieldList.Strings[I] = '') or (Char1(ASqlFieldList.Strings[I]) = ';') or
             BeginsWith(ASqlFieldList.Strings[I], '/*') then
            continue;
          {if Pos('(', ASqlFieldList.Strings[I]) <= 0 then}
          if not AggrInLine(ASqlFieldList.Strings[I]) and
             NoAggrInLine(ASqlFieldList.Strings[I]) then
          begin
            if N < NoAggrCount - 1 then
              Postfix := ',' else
              Postfix := '';
            AFieldName := StrValue(ASqlFieldList.Strings[I], RightestEqual);
            if AFieldName = '' then         {ohne '='}
              AFieldName := ASqlFieldList.Strings[I];
            AFieldName := StrCgeStrStr(AFieldName, 'distinct ', '', true);
            SQL.Add(Format('%s%s%s', [Prefix, FName(AFieldName), Postfix]));
            Prefix := '         ';
            Inc(N);
          end;
        end;
      end;

      if Count > 0 then
      begin
        KlammerAuf := false;
        Prefix := 'where ';
        for I := 0 to Count - 1 do
        begin
          ErrLine := Strings[I];
          AFieldName := Param(I);
          if Char1(AFieldName) = ';' then continue;    {Kommentar}
          AFieldValue := Value(I);
          AswNr := 0;
          (* keine gute Idee
          if CompareText(AFieldName, '?raw') = 0 then
          begin //insert special raw line
            SQL.Insert(WherePos, AFieldValue);
            Inc(WherePos);
            continue;
          end; *)
          P := Pos('.', AFieldValue);
          if (AFieldValue = '') or
             (AFieldValue = '*') or (AFieldValue = '%') or (AFieldValue = '..') or
              ((P > 0) and
               (ATblAliasList.IndexOf(copy(AFieldValue, 1, P-1)) >= 0) and
               IsValidIdentSpecial(copy(AFieldValue, P+1, 200))) then
             continue;                                 {bereits oben abgehandelt}
          if (Prefix <> 'where ') then
          begin
            if (copy(AFieldValue, 1, 1) = ';') then
            begin
              AFieldValue := copy(AFieldValue, 2, length(AFieldValue)-1);
              if not KlammerAuf then
                if Pos(' ', SQL[WherePos - 1]) > 0 then
                begin
                  KlammerAuf := true;
                  S1 := SQL[WherePos - 1];
                  S1[Pos(' (', SQL[WherePos - 1])] := '(';
                  SQL[WherePos - 1] := S1;
                end;
              Prefix := '   or ';
            end else
              if KlammerAuf then
              begin
                Prefix := ') and ';
                KlammerAuf := false;
              end else
                Prefix := '  and ';
          end;
          ShortFieldName := OnlyFieldName(AFieldName);
          if StrToIntDef(PStrTok(AFieldValue, '<=>', NextS), 0) <> 0 then
            ADataType := ftFloat else        {140899 Integer}
            ADataType := ftString;
          try
            DataTypeDefined := false;
            AswNr := 0;
            if AQuery.FieldCount > 0 then
            try
              AField := AQuery.FindField(ShortFieldName);
              if AField <> nil then
              begin
                ADataType := AField.DataType;
                if AField.Tag > 0 then
                  AswNr := AField.Tag else
                if AField.Tag = -1 then
                  ADataType := ftInteger;
                DataTypeDefined := true;
              end;
            except   {keine Aktion}
            end;
            if not DataTypeDefined then
            begin
              ADataType := FType(AFieldName);
            end;
          except on E:Exception do
            // 'TFltrList.BuildSql: Feld(%s):DataType nicht gefunden'
            EProt(AQuery, E, SDPos_Kmp_005, [AFieldName]);
          end;
          if (ASqlFieldList <> nil) and (ASqlFieldList.Count > 0) and
             (AFieldName = ShortFieldName) then
          begin {SQL Rechenfelder in der where Klausel: können auch bei Oracle }
            for iField := 0 to ASqlFieldList.Count-1 do    {nicht in der where-}
            begin                                          {Klausel auftreten  }
              ALine := ASqlFieldList.Strings[iField];
              if (ALine = '') or (Char1(ALine) = ';') then
                continue;
              //if CompareText(AFieldName, OnlyFieldName(StrParam(ALine))) = 0 then
              if CompareText(AFieldName, FName(StrParam(ALine, RightestEqual), true)) = 0 then
              begin
                if StrValue(ALine, RightestEqual) <> '' then
                begin
                  if BeginsWith(StrValue(ALine, RightestEqual), '''') then
                    AFieldName := Format('(%s)', [StrParam(ALine, RightestEqual)])
                  else
                    AFieldName := Format('(%s)', [StrValue(ALine, RightestEqual)]);
                end else
                  AFieldName := FName(ALine, true);
                break;
              end;
            end;
          end;
          AReadOnly := not AQuery.RequestLive or AQuery.CachedUpdates or
                       (AQuery.SQLUpdate.Count <> 0);
          if not GenerateSQL(AFieldValue, FName(AFieldName), ADataType,
                              AReadOnly, AswNr, QBELine) then
            raise Exception.Create(SDPos_Kmp_006);	// 'Syntaxfehler'
          if AReadOnly and (Trenn = '') and       {Einschr. durch Syntax}
             not (csDesigning in AQuery.ComponentState) and
             not AQuery.CachedUpdates and
             (AQuery.SQLUpdate.Count = 0) then
          begin
            if AQuery.RequestLive then
            begin
              AQuery.Close;
              AQuery.RequestLive := false;
            end;
          end;
          if not empty(QBELine) then
          begin
            SQL.Insert(WherePos, Format('%s%s', [Prefix, QBELine]));
            Inc(WherePos);
            Prefix := '  and ';
          end;
        end;
        for I := 0 to Count - 1 do             {Rerences between Tables}
        begin                                   {14.02.02 jetzt hinter Fltr}
          AFieldName := Param(I);
          if Char1(AFieldName) = ';' then continue;    {Kommentar}
          AFieldValue := Value(I);
          P := Pos('.', AFieldValue);
          if (AFieldValue <> '') and
              (P > 0) and
              (ATblAliasList.IndexOf(copy(AFieldValue, 1, P-1)) >= 0) and
              IsValidIdentSpecial(copy(AFieldValue, P+1, 200)) then
          begin
            SQL.Insert(WherePos, Format('%s(%s=%s)', [Prefix,
              FName(AFieldName), AFieldValue]));
            Inc(WherePos);
            Prefix := '  and ';
          end;
        end;
        if KlammerAuf then
        begin
          SQL.Insert(WherePos, ')');
          {Inc(WherePos);
          KlammerAuf := false;}
        end;
      end; {Count > 0}

      if AKeyFields <> '' then
      begin
        P := Pos(',',AKeyFields);
        if (P > 0) and (Pos('(', AKeyFields) = 0) then
          // '%s:KeyFields enthält "," (%s)'
          // erlaubt ist z.B. 'datepart(year,TAG)' in MS SQL
          Prot0(SDPos_Kmp_007, [AQuery.Owner.ClassName, AKeyFields]);
        ATokenList.Clear;
        ATokenList.AddTokens(AKeyFields,';');
        Prefix := 'order by ';
        for I:= 0 to ATokenList.Count-1 do
        begin
          if I < ATokenList.Count-1 then
            Postfix := ',' else
            Postfix := '';
          AFieldName := FName(ATokenList.Strings[i]);
          AField := AQuery.FindField(AFieldName);
          if (AField <> nil) and (AField is TBlobField) then
          begin
            if Sysparam.MSSQL then
              AFieldName := Format('cast(%s as varchar(255))', [AFieldName]);
          end;
          SQL.Add(Format('%s%s%s', [Prefix, AFieldName, Postfix]));
          Prefix := '         ';
//          11.02.13 wg unidac unnötig:
//          //order by ... substr( ... ist immer readonly - QUVA 20.04.08
//          if (PosI('substr(', AFieldName) > 0) and
//             not AQuery.CachedUpdates and                //18.01.05 QUPP
//             (AQuery.SQLUpdate.Count = 0) then           //26.04.12 QUPP, unidac
//          begin
//            if AQuery.RequestLive then
//            begin
//              AQuery.Close;
//              AQuery.RequestLive := false;
//            end;
//          end;

        end;
      end;
      OldParamCount := IMin(OldParamCount, ParamCount);
      if (DataSource = nil) and (OldParamCount > 0) then
        for I := 0 to OldParamCount-1 do
          Params[I].DataType := ParamType[I];

    except
      on E:EAbort do
      begin
        (* SQL konnte nicht gelöscht werden *)
      end;
      on E:Exception do
      begin
        ErrorFieldName := AFieldName;
        {AQuery.Sql := OldSql;}
        result := false;
        if Prot <> nil then
        begin
          if csDesigning in ComponentState then
            ErrWarn('DP.BuildSQL.%s(%.128s):%s.%s', [Prefix, ErrLine, E.ClassName, E.Message])
          else {QSBT.BarcodeOK 05.08.02}
            EError('DP.BuildSQL.%s(%.128s):%s.%s' , [Prefix, ErrLine, E.ClassName, E.Message])
        end;
        {ErrException(self, E);}
      end;
    end;
  finally
    {AQuery.SQL.EndUpdate;}
    OldSql.Free;
    ATokenList.Free;
    ATblList.Free;
    ATblAliasList.Free;
  end;
end;

(*
       (nvl(AUFP.BESTELLMENGE,0)-nvl(AUFP.VERSANDMENGE,0)) as scfRestMenge,
       (nvl(AUFP.BESTELLMENGE,0)-nvl(AUFP.DISPOMENGE,0)) as scfDispoFehltMenge
from AUFK,
     AUFP
where (AUFK.AUFK_ID=AUFP.AUFP_AUFK_ID)
  and (AUFP.POSITIONSART = 'J')
  and (AUFK.WERK_NR = '0220')
  and (AUFP.STATUS = 'J')
  and ((nvl(AUFP.BESTELLMENGE,0)-nvl(AUFP.DISPOMENGE,0)) > 0)
order by AUFK;AUFP.SCFRESTMENGE desc
*)

procedure TValueList.SetParams(L: TStrings);
var
  I: integer;
begin
  L.Clear;
  for I := 0 to self.Count - 1 do
    L.Add(self.Param(I));
end;

procedure TValueList.SetValues(L: TStrings);
var
  I: integer;
begin
  L.Clear;
  for I := 0 to self.Count - 1 do
    L.Add(self.Value(I));
end;

end.
