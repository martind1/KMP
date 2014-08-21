unit Rechtkmp;
(* Rechte einlesen
   ...
   02.02.98 MD  Maskenrechte (BATA_ID=null) können auch Tabellenrechte
                enthalten (Upd, Del, Ins)   --> QUSY neu
   04.03.98 MD  Anwendungsbezogen: ANWE_ID als Parameter für INIT
                SQLs entspr. erweitert
   16.03.97 MD  Tabellennamen paramtrisierbar
                TblNameRECHTE = QUSY.RECHTE
                dt.             QUSY.FORMS
                                QUSY.USER_GRUPPEN
                                QUSY.GRUPPEN       //fehlte
                                QUSY.USERS
                                QUSY.OBJEKTE
                                QUSY.REPORT_FORMS
                                QUSY.REPORTS REPO
                                QUSY.PROGRAMMARTEN
                Params: enthält Bemerkungsfeld der Gruppen-Datensätze
                        i.d.F. <Param>=<Value>
   07.06.00 MD  GetObjekt ergibt false wenn Objekt nicht vorhanden
   16.10.03 MD  GetObjekt overloaded für IniDbKmp
   30.12.03 MD  prop UserGruppen
   19.01.04 MD  prop UserList
   16.08.05 MD  GetUserLangname
   18.10.05 MD  Demo
   07.02.06 MD  Databasename weg wg. Session
   04.11.07 MD  Mehrere Forms mit gleichen Rechten: FormSynonyms, FSyn() - QuvaR3
   09.01.09 MD  Maske mehrmals über mehrere Gruppen: Weitergehende Rechte gewinnen
   22.01.09 MD  auch bei Objektrechten: die weitergehenderen Rechte verwenden
   07.06.11 md  UNI:
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Uni, DBAccess, MemDS, DB,
  DPos_Kmp, UDB__Kmp, UQue_Kmp;

type
  TRechteKnz = (reUpdate, reInsert, reDelete, reDisplayed, reEnabled);
  {Rechte}
  TRechteSet = set of TRechteKnz;
  {Menge von Rechten}

  TMaskenRechte = class(TObject)
  {Struktur zum Speichern von Maskerechten}
  public
    Objekte: TValueList;
    Reports: TValueList;
    destructor Destroy; override;
  end;

const
  AlleRechte = [reUpdate, reInsert, reDelete, reDisplayed, reEnabled];  

type
  TRechte = class(TComponent)
  {Speichert alle Rechte für eine Applikation}
  private
    { Private-Deklarationen }
    Masken: TValueList;           {Liste der Masken mit ihren Objekten und Rechten}
    Tabellen: TValueList;         {Liste der Datebanktabellen}
    fDatabase: TuDataBase;        {von Init}
    fUserGruppen: TStringList;    {den Gruppen gehört der USER an}
    fUserList: TStringList;       {Benutzerliste der Anwendung}
    fFormSynonyms: TStringList;   {Umsetzungsliste i.d.F. SynForm=BaseForm}
    FTblNameANWE,
    FTblNameRECHTE,
    FTblNameFORMS,
    FTblNameUSER_GRUPPEN,
    FTblNameGRUPPEN,
    FTblNameUSERS,
    FTblNameOBJEKTE,
    FTblNameREPORT_FORMS,
    FTblNameREPORTS,
    FTblNamePROGRAMMARTEN: string;

    function GetKnz(AField: TField): string;
    function GetUserGruppen: TStringList;
    function GetUserList: TStringList;
    function GeTuDataBase: TuDataBase;
    function StrToDbStr(S: string): string;
    function MergeRechteString(S1, S2: string): string;
  protected
    { Protected-Deklarationen }
    DemoFormId: integer;
    MaskenCount: integer;
    LimitList: TStringList;
    NoMatchList: TStringList;
    procedure AddObjekt(Form_ID: string; ObjString: string);
    {Fügt ein Objekt zur Maske hinzu}
    procedure AddReport(Form_ID: string; ReportString: string);
    {Fügt ein Report zur Maske hinzu}
    function FSyn(FrmName: string): string;
  public
    { Public-Deklarationen }
    AllowAll: boolean;
    ApplicationID: longint;
    Params: TValueList;           {Werteliste aus GRUPPEN Bemerkungsfeld}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure InitDemo(aLimitList: TStrings);  //für Logon
    procedure InitMaske(aForm: TForm; aFormName: string);  //für TqForm.SetObjRechte
    {Zur Datenstruktur bestückung, AnweId=Anwendungs-ID}
    procedure InitDirekt(ADataBase: TuDataBase; AnweId: Integer);
    procedure Init(ADataBase: TuDataBase; AnweId: longint); virtual;
    {Unterinitialisierung}
    procedure InitTab(ADataBase: TuDataBase); virtual;
    {Zur Maske mit dem Namen FrmName werden Rechte in Recht(Aufrufen)
    und in RechteKnz (Tabellenbezogen Ändern, Löschen, Erfassen)}
    procedure GetMaske(FrmName: string; var Recht: boolean;
                        var RechteKnz: TRechteSet);
    {Liefert alle Reports zur Maske zurück}
    function GetReports(FrmName: string): TValueList;
    {Liefert die Rechte zum einzelnen Objekt}
    function GetObjekt(FrmName: string; ObjName: string;
                         var RechteKnz: TRechteSet): boolean; overload;
    function GetObjekt(FrmName: string; ObjName: string; ObjTyp: string;
                         var RechteKnz: TRechteSet): boolean; overload;
    function ProtRechte: boolean;
    function RechteToStr(R: TRechteSet): string;
    function RechteToDbStr(R: TRechteSet): string;
    function StrToRechte(S: string): TRechteSet;
    function GetUserLangname(UserKennung: string): string;
    property UserGruppen: TStringList read GetUserGruppen;
    property FormSynonyms: TStringList read fFormSynonyms write fFormSynonyms;
    property UserList: TStringList read GetUserList;
    property Database: TuDataBase read GeTuDataBase;
  published
    { Published-Deklarationen }
    property TblNameANWE: string read FTblNameANWE write FTblNameANWE;
    property TblNameRECHTE: string read FTblNameRECHTE write FTblNameRECHTE;
    property TblNameFORMS: string read FTblNameFORMS write FTblNameFORMS;
    property TblNameUSER_GRUPPEN: string read FTblNameUSER_GRUPPEN write FTblNameUSER_GRUPPEN;
    property TblNameGRUPPEN: string read FTblNameGRUPPEN write FTblNameGRUPPEN;
    property TblNameUSERS: string read FTblNameUSERS write FTblNameUSERS;
    property TblNameOBJEKTE: string read FTblNameOBJEKTE write FTblNameOBJEKTE;
    property TblNameREPORT_FORMS: string read FTblNameREPORT_FORMS write FTblNameREPORT_FORMS;
    property TblNameREPORTS: string read FTblNameREPORTS write FTblNameREPORTS;
    property TblNamePROGRAMMARTEN: string read FTblNamePROGRAMMARTEN write FTblNamePROGRAMMARTEN ;
  end;

var
  KmpRechte: TRechte;

implementation
uses
  Prots, Ini__Kmp, Err__Kmp, GNav_Kmp;

function TRechte.GeTuDataBase: TuDataBase;
begin
  if fDatabase <> nil then
    result := fDatabase else
    result := QueryDatabase('DB1');   //StrDflt(fDatabaseName, 'DB1');
end;

constructor TRechte.Create(AOwner: TComponent);
var
  S1: string;
begin
  inherited Create(AOwner);
  {Anlegen im Hauptspeicher}
  AllowAll := true; //erstmal vorgeben bis ggf. init() aufgerufen wurde.
  Masken := TValueList.Create;
  Tabellen := TValueList.Create;
  Params := TValueList.Create;
  fFormSynonyms := TStringList.Create;
  {in Getter
  fUserGruppen := TStringList.Create;
  fUserList := TStringList.Create;}

  (*  FTblNameANWE         := IniKmp.ReadString(STableSynonyms, 'R_ANWE', 'QUSY.ANWENDUNGEN');
  FTblNameRECHTE       := IniKmp.ReadString(STableSynonyms, 'R_RECH', 'QUSY.RECHTE');
  FTblNameFORMS        := IniKmp.ReadString(STableSynonyms, 'R_FORM', 'QUSY.FORMS');
  FTblNameUSER_GRUPPEN := IniKmp.ReadString(STableSynonyms, 'R_USGR', 'QUSY.USER_GRUPPEN');
  FTblNameGRUPPEN      := IniKmp.ReadString(STableSynonyms, 'R_GRUP', 'QUSY.GRUPPEN');
  FTblNameUSERS        := IniKmp.ReadString(STableSynonyms, 'R_USRS', 'QUSY.USERS');
  FTblNameOBJEKTE      := IniKmp.ReadString(STableSynonyms, 'R_OBJE', 'QUSY.OBJEKTE');
  FTblNameREPORT_FORMS := IniKmp.ReadString(STableSynonyms, 'R_REFO', 'QUSY.REPORT_FORMS');
  FTblNameREPORTS      := IniKmp.ReadString(STableSynonyms, 'R_REPO', 'QUSY.REPORTS');
  FTblNamePROGRAMMARTEN := IniKmp.ReadString(STableSynonyms, 'R_PROG', 'QUSY.PROGRAMMARTEN');*)

  FTblNameANWE         := IniKmp.ReadString(SRechteverwaltung, 'TblANWE', 'QUSY.ANWENDUNGEN');
  FTblNameRECHTE       := IniKmp.ReadString(SRechteverwaltung, 'TblRECHTE', 'QUSY.RECHTE');
  FTblNameFORMS        := IniKmp.ReadString(SRechteverwaltung, 'TblFORMS', 'QUSY.FORMS');
  FTblNameUSER_GRUPPEN := IniKmp.ReadString(SRechteverwaltung, 'TblUSER_GRUPPEN', 'QUSY.USER_GRUPPEN');
  S1 := StringReplace(FTblNameUSER_GRUPPEN, 'USER_GRUPPEN', 'GRUPPEN', [rfReplaceAll, rfIgnoreCase]);
  S1 := StringReplace(S1, 'USGR', 'GRUP', [rfReplaceAll, rfIgnoreCase]);
  FTblNameGRUPPEN      := IniKmp.ReadString(SRechteverwaltung, 'TblGRUPPEN', S1); //nicht in Std-INI
  FTblNameUSERS        := IniKmp.ReadString(SRechteverwaltung, 'TblUSERS', 'QUSY.USERS');
  FTblNameOBJEKTE      := IniKmp.ReadString(SRechteverwaltung, 'TblOBJEKTE', 'QUSY.OBJEKTE');
  FTblNameREPORT_FORMS := IniKmp.ReadString(SRechteverwaltung, 'TblREPORT_FORMS', 'QUSY.REPORT_FORMS');
  FTblNameREPORTS      := IniKmp.ReadString(SRechteverwaltung, 'TblREPORTS', 'QUSY.REPORTS');
  FTblNamePROGRAMMARTEN := IniKmp.ReadString(SRechteverwaltung, 'TblPROGRAMMARTEN', 'QUSY.PROGRAMMARTEN');

  FTblNameANWE         := IniKmp.ReadString(SRechteverwaltung, 'R_ANWE', FTblNameANWE);
  FTblNameRECHTE       := IniKmp.ReadString(SRechteverwaltung, 'R_RECH', FTblNameRECHTE);
  FTblNameFORMS        := IniKmp.ReadString(SRechteverwaltung, 'R_FORM', FTblNameFORMS);
  FTblNameUSER_GRUPPEN := IniKmp.ReadString(SRechteverwaltung, 'R_USGR', FTblNameUSER_GRUPPEN);
  FTblNameGRUPPEN      := IniKmp.ReadString(SRechteverwaltung, 'R_GRUP', FTblNameGRUPPEN);
  FTblNameUSERS        := IniKmp.ReadString(SRechteverwaltung, 'R_USRS', FTblNameUSERS);
  FTblNameOBJEKTE      := IniKmp.ReadString(SRechteverwaltung, 'R_OBJE', FTblNameOBJEKTE);
  FTblNameREPORT_FORMS := IniKmp.ReadString(SRechteverwaltung, 'R_REFO', FTblNameREPORT_FORMS);
  FTblNameREPORTS      := IniKmp.ReadString(SRechteverwaltung, 'R_REPO', FTblNameREPORTS);
  FTblNamePROGRAMMARTEN := IniKmp.ReadString(SRechteverwaltung, 'R_PROG', FTblNamePROGRAMMARTEN);

  FTblNameANWE         := IniKmp.ReadString(STableSynonyms, 'R_ANWE', FTblNameANWE);
  FTblNameRECHTE       := IniKmp.ReadString(STableSynonyms, 'R_RECH', FTblNameRECHTE);
  FTblNameFORMS        := IniKmp.ReadString(STableSynonyms, 'R_FORM', FTblNameFORMS);
  FTblNameUSER_GRUPPEN := IniKmp.ReadString(STableSynonyms, 'R_USGR', FTblNameUSER_GRUPPEN);
  FTblNameGRUPPEN      := IniKmp.ReadString(STableSynonyms, 'R_GRUP', FTblNameGRUPPEN);
  FTblNameUSERS        := IniKmp.ReadString(STableSynonyms, 'R_USRS', FTblNameUSERS);
  FTblNameOBJEKTE      := IniKmp.ReadString(STableSynonyms, 'R_OBJE', FTblNameOBJEKTE);
  FTblNameREPORT_FORMS := IniKmp.ReadString(STableSynonyms, 'R_REFO', FTblNameREPORT_FORMS);
  FTblNameREPORTS      := IniKmp.ReadString(STableSynonyms, 'R_REPO', FTblNameREPORTS);
  FTblNamePROGRAMMARTEN := IniKmp.ReadString(STableSynonyms, 'R_PROG', FTblNamePROGRAMMARTEN);
end;

destructor TRechte.Destroy;
begin
  Masken.FreeObjects; Masken := nil;
  Tabellen.FreeObjects; Tabellen := nil;
  Params.Free;
  FreeAndNil(fUserGruppen);
  FreeAndNil(fFormSynonyms);
  FreeAndNil(fUserList);
  FreeAndNil(LimitList);
  FreeAndNil(NoMatchList);
  inherited Destroy;
end;

procedure TRechte.Clear;
begin
  {Daten zurücksetzen für erneute Anmeldung}
  Masken.ClearObjects;
  Tabellen.ClearObjects;
  FreeAndNil(fUserGruppen);
  FreeAndNil(fUserList);
  //FormSynonyms bleiben
end;

procedure TRechte.GetMaske(FrmName: string; var Recht: boolean;
                             var RechteKnz: TRechteSet);
{Zur Maske mit dem Namen FrmName werden Rechte in Recht(Aufrufen)
    und in RechteKnz (Tabellenbezogen Ändern, Löschen, Erfassen)}
var
  P, I, ITab: integer;
  RechteString: string;
begin
  if (KmpRechte = nil) or AllowAll then {wenn Rechte ausgeschaltet}
  begin
    Recht := true;
    RechteKnz := AlleRechte; //[reUpdate, reInsert, reDelete, reDisplayed, reEnabled];
    Exit;  {Interbase}
  end;
  Recht := false;
  RechteKnz := [];
  for I:= 0 to Masken.Count-1 do {über alle Masken}
  begin
    if CompareText(Masken.Param(I), FSyn(FrmName)) = 0 then {Maskenname gefunden}
    begin
      Recht := true;

      for ITab := 0 to Tabellen.Count-1 do
      begin
        {Form von Tabellen 'WERK=JN JN' (PARAM=VALUE)}
        if CompareText(Tabellen.Param(ITab), FSyn(FrmName)) = 0 then {Tabelle gefunden}
        begin
          RechteString := Tabellen.Strings[ITab]; {einlesen in RechteString}
          P := Pos('=', RechteString);{positionieren bei =}
          if P > 0 then
            RechteString := copy(RechteString, P+1, length(RechteString)-P);
          if length(RechteString) < 5 then
            EError('Rechtestring falsch(%s):%s',
                  [Tabellen.Strings[ITab], RechteString]);
          {Umsetzen in RechteKnz}
          if RechteString[1] = 'J' then RechteKnz := RechteKnz + [reUpdate];
          if RechteString[2] = 'J' then RechteKnz := RechteKnz + [reInsert];
          if RechteString[3] = 'J' then RechteKnz := RechteKnz + [reDelete];
          if RechteString[4] = 'J' then RechteKnz := RechteKnz + [reDisplayed];
          if RechteString[5] = 'J' then RechteKnz := RechteKnz + [reEnabled];
          Exit; // es gibt nur eine und die haben wir gefunden.
        end;
      end;
    end;
  end;
end;

function TRechte.GetReports(FrmName: string): TValueList;
{Liefert alle Reports zur Maske zurück}
var
  I: integer;
begin
  result := nil;
  if (KmpRechte = nil) or AllowAll then
    Exit;
  for I:= 0 to Masken.Count-1 do
  begin
    if CompareText(Masken.Param(I), FSyn(FrmName)) = 0 then
    begin
      if Masken.Objects[I] <> nil then
      begin
        result := TMaskenRechte(Masken.Objects[I]).Reports;
      end;
      Exit;
    end;
  end;
end;

function TRechte.RechteToStr(R: TRechteSet): string;
{Liefert String mit Rechten in R:
 UIDrwx für Update, Insert, Delete, visible, enabled}
var
  S: string;
begin
  S := '';
  if reUpdate in R then S := S + 'U' else S := S + '-';
  if reInsert in R then S := S + 'I' else S := S + '-';
  if reDelete in R then S := S + 'D' else S := S + '-';
  if (reDisplayed in R) or (reEnabled in R) then S := S + 'r' else S := S + '-';
  if reEnabled in R then S := S + 'w' else S := S + '-';
  result := S;
end;

function TRechte.RechteToDbStr(R: TRechteSet): string;
begin
  result := StrToDbStr(RechteToStr(R));
end;

function TRechte.StrToRechte(S: string): TRechteSet;
{Liefert Rechtestruktur anhand Berechtigungszeichen in S (UIDrwx)}
var
  I: integer;
begin
  result := [];
  for I := 1 to length(S) do
    case S[I] of
      'U': result := result + [reUpdate];
      'I': result := result + [reInsert];
      'D': result := result + [reDelete];
      'r': result := result + [reDisplayed];
      'w', 'x': result := result + [reDisplayed, reEnabled];
    end;
end;

function TRechte.StrToDbStr(S: string): string;
{Liefert internen Rechtestring anhand Berechtigungszeichen in S (UIDrwx)}
var
  I: integer;
begin
  result := 'NNNNN';
  for I := 1 to length(S) do
    case S[I] of
      'U': result[1] := 'J';
      'I': result[2] := 'J';
      'D': result[3] := 'J';
      'r': result[4] := 'J';
      'w', 'x': begin result[5] := 'J'; result[4] := 'J'; end;
    end;
end;

function TRechte.GetObjekt(FrmName: string; ObjName: string;
  var RechteKnz: TRechteSet): boolean;
{Liefert die Rechte zum einzelnen Objekt}
begin
  result := GetObjekt(FrmName, ObjName, '*', RechteKnz);
end;

function TRechte.GetObjekt(FrmName, ObjName, ObjTyp: string;
  var RechteKnz: TRechteSet): boolean;
{Liefert die Rechte zum einzelnen Objekt + ObjektTyp
 FrmName, ObjTyp: '*' = beliebige
}
var
  P, I, IObjekt: integer;
  AObjektList: TValueList;
  RechteString, S1: string;
  I1: integer;
  ObjListName, ObjListTyp, NextS: string;
begin
  result := false;
  RechteKnz := AlleRechte;  //[reUpdate, reInsert, reDelete, reDisplayed, reEnabled];
  {alles erlaubt weiterhin eventuell Einschränkung}
  if (KmpRechte = nil) or AllowAll then
  begin
    {if Uppercase(ObjName) = 'SYSTEM' then
      RechteKnz := RechteKnz - [reEnabled]; Test}
    Exit;  {Interbase}
  end;

  for I:= 0 to Masken.Count-1 do
  begin
    if (FSyn(FrmName) = '*') or (CompareText(Masken.Param(I), FSyn(FrmName)) = 0) then
    begin
      if Masken.Objects[I] <> nil then
      begin
        AObjektList := TMaskenRechte(Masken.Objects[I]).Objekte;
        {Liste der Objekte TValueList}
        if AObjektList <> nil then
        begin
          RechteString := 'XXXXX';
          for IObjekt := 0 to AObjektList.Count-1 do
          begin
            ObjListName := PStrTok(AObjektList.Param(IObjekt), ',', NextS);
            ObjListTyp := PStrTok('', ',', NextS);
            if (CompareText(ObjListName, ObjName) = 0) or
               (CompareText(StrToValidIdent(ObjListName), ObjName) = 0) then    //02.12.02 QDispo.DiVo.Rechte
            begin //suchen nach dem Namen
              if (ObjTyp = '*') or (CompareText(ObjListTyp, ObjTyp) = 0) then
              begin  //suchen nach dem Namen+Typ
                result := true;                                         {gefunden}
                S1 := AObjektList.Strings[IObjekt];
                P := Pos('=', S1);
                if P > 0 then
                  S1 := copy(S1, P+1, length(S1));
                if length(S1) < 5 then
                  EError('Rechtestring falsch(%s):%s',
                        [AObjektList.Strings[IObjekt], S1]);
                for I1 := 1 to 5 do
                  if RechteString[I1] <> 'J' then     {einmal J bleibt}
                    if S1[I1] <> 'N' then             {Vorgabe X ersetzen}
                      RechteString[I1] := 'J' else
                      RechteString[I1] := 'N';
              end;
            end;
          end;
          if RechteString[1] = 'N' then RechteKnz := RechteKnz - [reUpdate];    //U
          if RechteString[2] = 'N' then RechteKnz := RechteKnz - [reInsert];    //I
          if RechteString[3] = 'N' then RechteKnz := RechteKnz - [reDelete];    //D
          if RechteString[4] = 'N' then RechteKnz := RechteKnz - [reDisplayed]; //v
          if RechteString[5] = 'N' then RechteKnz := RechteKnz - [reEnabled];   //e
        end;
      end;
    end;
  end;
end;

procedure TRechte.AddObjekt(Form_ID: string; ObjString: string);
{Fügt ein Objekt zur Maske hinzu i.d.F. Objectname=JJJJJ}
var
  I: integer;
  MaskenRechte: TMaskenRechte;
  RechteS: string;
begin
  for I:= 0 to Masken.Count-1 do
  begin
    if Masken.Value(I) = Form_ID then
    begin
      if Masken.Objects[I] = nil then
        Masken.Objects[I] := TMaskenRechte.Create;
      MaskenRechte := Masken.Objects[I] as TMaskenRechte;
      if MaskenRechte.Objekte = nil then
        MaskenRechte.Objekte := TValueList.Create;

      //MaskenRechte.Objekte.Add(ObjString);
      //Blanks erhalten:
      RechteS := StringReplace(ObjString, ' ', '_', [rfReplaceAll]);
      RechteS := StrValue(RechteS);
      RechteS := StringReplace(RechteS, '_', ' ', [rfReplaceAll]);
      //die weitergehenderen Rechte verwenden (ab 22.01.09):
      RechteS := MergeRechteString(RechteS, MaskenRechte.Objekte.Values[StrParam(ObjString)]);
      if MaskenRechte.Objekte.Values[StrParam(ObjString)] <> RechteS then
      begin
        MaskenRechte.Objekte.Values[StrParam(ObjString)] := RechteS;

        if ProtRechte then
          ProtA('AddObjekt[%s.%s]=%s.', [StrParam(Masken[I]), StrParam(ObjString), RechteS]);
        //ProtA('%s.Objekte.Add(%s)',[Masken[I], ObjString]);
      end;  
      break;
    end;
  end;
end;

procedure TRechte.AddReport(Form_ID: string; ReportString: string);
var
  I: integer;
  MaskenRechte: TMaskenRechte;
begin
  for I:= 0 to Masken.Count-1 do
  begin
    if Masken.Value(I) = Form_ID then
    begin
      if Masken.Objects[I] = nil then
        Masken.Objects[I] := TMaskenRechte.Create;
      MaskenRechte := Masken.Objects[I] as TMaskenRechte;
      if MaskenRechte.Reports = nil then
        MaskenRechte.Reports := TValueList.Create;

      MaskenRechte.Reports.Add(ReportString);

      break;
    end;
  end;
end;

function TRechte.ProtRechte: boolean;
begin
  result := ((IniKmp <> nil) and
             IniKmp.ReadBool(SSystem, 'ProtRechte', false)) or
            ((GNavigator <> nil) and
             (GNavigator.ParamList.Values['ProtRechte'] = '1')) or
            (AppParam('ProtRechte') = '1');
end;

function TRechte.GetKnz(AField: TField): string;
begin
  result := AField.AsString;
  if result = '' then
    result := ' ' else
    result := copy(result, 1, 1);
end;

function TRechte.GetUserGruppen: TStringList;
var
  TblGrp: TuQuery;
begin
  if fUserGruppen = nil then
  begin
    fUserGruppen := TStringList.Create;
    TblGrp := TuQuery.Create(Database);
    try
      //create TblGrp.DataBaseName := DatabaseName;
      (* UserGruppen *)
      TblGrp.SQL.Clear;
      TblGrp.SQL.Add('select G.GRUP_NAME,         ');
      TblGrp.SQL.Add('       UG.USGR_ID           ');
      TblGrp.SQL.Add(Format('from %s U, %s UG, %s G', [TblNameUSERS,
        TblNameUSER_GRUPPEN, TblNameGRUPPEN]));
      TblGrp.SQL.Add('where (U.USER_KENNUNG = ''' + SysParam.UserName + ''')');
      TblGrp.SQL.Add('  and (UG.USGR_USER_ID = U.USER_ID)');
      TblGrp.SQL.Add('  and (G.GRUP_ID = UG.USGR_GRUP_ID)');
      TblGrp.SQL.Add('order by UG.USGR_ID                ');  //Reihenfolge wie bei User eingetragen
      if ProtRechte then
        ProtStrings(TblGrp.SQL);
      SMess('Öffne Usergruppen',[0]);
      fUsergruppen.Clear;
      try
        TblGrp.Open;
      except on E:Exception do
        EError('%s:%s', [E.Message, TblGrp.Text]);
      end;
      TblGrp.First;
      while not TblGrp.EOF do
      begin
        SMess('Lade Usergruppen',[0]);
        fUsergruppen.Add(TblGrp.FieldByName('GRUP_NAME').AsString);
        if ProtRechte then
          ProtA('TblGrp(%s)', [TblGrp.FieldByName('GRUP_NAME').AsString]);
        TblGrp.Next;
      end;
      SMess0;
    finally
      TblGrp.Free;
    end;
  end;
  result := fUserGruppen;
end;

function TRechte.GetUserLangname(UserKennung: string): string;
var
  TblUsr: TuQuery;
begin
  result := UserKennung;
  TblUsr := TuQuery.Create(Database);
  try
    //create TblUsr.DataBaseName := DatabaseName;
    TblUsr.SQL.Clear;
    TblUsr.SQL.Add('select U.USER_LANGNAME'          );
    TblUsr.SQL.Add(Format('from %s U', [TblNameUSERS]));
    TblUsr.SQL.Add(Format('where (U.USER_KENNUNG = ''%s'')', [UserKennung]));
    if ProtRechte then
      ProtStrings(TblUsr.SQL);
    try
      TblUsr.Open;
      result := StrDflt(TblUsr.FieldByName('USER_LANGNAME').AsString, result);
    except on E:Exception do
      EError('%s:%s', [E.Message, TblUsr.Text]);
    end;
  finally
    TblUsr.Free;
  end;
end;

function TRechte.GetUserList: TStringList;
//stellt alle User der App zur Verfügung.
var
  TblUsr: TuQuery;
begin
  if fUserList = nil then
  begin
    fUserList := TStringList.Create;
    TblUsr := TuQuery.Create(Database);
    try
      {* UserList *
        select distinct U.USER_KENNUNG
        from QUSY.FORMS F, QUSY.RECHTE R, QUSY.USER_GRUPPEN UG, QUSY.USERS U
        where (F.FORM_ANWE_ID = 38)
          and (R.RECH_FORM_ID = F.FORM_ID)
          and (UG.USGR_GRUP_ID = R.RECH_GRUP_ID)
          and (U.USER_ID = UG.USGR_USER_ID)
        order by U.USER_KENNUNG
      *}
      TblUsr.SQL.Clear;
      TblUsr.SQL.Add('select distinct U.USER_KENNUNG'          );
      TblUsr.SQL.Add(Format('from %s F, %s R, %s UG, %s U',
        [FTblNameFORMS, FTblNameRECHTE, TblNameUSER_GRUPPEN, TblNameUSERS]));
      TblUsr.SQL.Add('where (F.FORM_ANWE_ID = ' + IntToStr(ApplicationId)+')');
      TblUsr.SQL.Add('  and (R.RECH_FORM_ID = F.FORM_ID)'      );
      TblUsr.SQL.Add('  and (UG.USGR_GRUP_ID = R.RECH_GRUP_ID)');
      TblUsr.SQL.Add('  and (U.USER_ID = UG.USGR_USER_ID)'     );
      TblUsr.SQL.Add('order by U.USER_KENNUNG'                 );
      if ProtRechte then
        ProtStrings(TblUsr.SQL);
      SMess('Öffne UserList',[0]);
      fUserList.Clear;
      try
        TblUsr.Open;
        if ProtRechte then
          ProtA('%s', [TblUsr.Text]);
      except on E:Exception do
        EError('%s:%s', [E.Message, TblUsr.Text]);
      end;
      TblUsr.First;
      while not TblUsr.EOF do
      begin
        SMess('Lade UserList',[0]);
        fUserList.Add(TblUsr.FieldByName('USER_KENNUNG').AsString);
        if ProtRechte then
          ProtA('TblUsr(%s)', [TblUsr.FieldByName('USER_KENNUNG').AsString]);
        TblUsr.Next;
      end;
      SMess0;
    finally
      TblUsr.Free;
    end;
  end;
  result := fUserList;
end;

procedure TRechte.InitDirekt(ADataBase: TuDataBase; AnweId: longint);
{Zur Datenstruktur bestückung für LogonDirekt}
begin
  AllowAll := true;
  ApplicationId := AnweId;
  fDatabase := ADataBase;
end;

procedure TRechte.InitDemo(aLimitList: TStrings);
begin
  AllowAll := false;
  LimitList := TStringList.Create;
  LimitList.Assign(aLimitList);
  DemoFormId := 0;
  MaskenCount := 0;
  NoMatchList := TStringList.Create;
end;

procedure TRechte.InitMaske(aForm: TForm; aFormName: string);
//Bestückt DaStru anhand Liste
//Zeile:  Form=RI    oder Form.Objekt=RI
//        R=ReadOnly; I=Invisible
//Wildcards: *=R   oder *.Btn*=I
//  ausschließen von Wildcardsuche: -Menu  -btnno
//Vorgabe ohne '=': Form=Readonly  und Objekt=Invisible

  procedure DoLimit(aLine: string);
  var
    P1: integer;
    Pa, Va: string;
    FormName, MaskenString, TabellenString: string;
    MaskenRechte: TMaskenRechte;
    MaskenIndex: integer;
    IsMaske: boolean;
    ObjName: string;
  begin
    Pa := StrParam(aLine);
    Va := StrValue(aLine);
    P1 := Pos('.', Pa);
    IsMaske := P1 <= 0;
    if P1 > 0 then
      FormName := copy(Pa, 1, P1 - 1) else
      FormName := Pa;
    if not BeginsWith(FormName, 'Frm', true) then
      FormName := 'Frm' + FormName;
    MaskenIndex := Masken.IndexOfName(FormName);
    if MaskenIndex < 0 then
    begin
      if IsMaske and (Pos('-', Va) > 0) then
      begin  //wird eh gleich wieder gelöscht
      end else
      begin
        Inc(DemoFormId);
        MaskenString := Format('%s=D%d', [FormName, DemoFormId]);
        MaskenRechte := TMaskenRechte.Create;
        MaskenRechte.Objekte := TValueList.Create;
        MaskenRechte.Reports := TValueList.Create;
        Masken.AddObject(MaskenString, MaskenRechte);
        TabellenString := 'JJJJJ';  //Upd Ins Del Display Enable
        Tabellen.Values[FormName] := TabellenString;
        MaskenIndex := Masken.IndexOfName(FormName);
        if ProtRechte then
          ProtA('Maske(%s) neu angelegt', [MaskenString]);
        if MaskenIndex < 0 then
        begin
          if ProtRechte then
            Prot0('InitDemo(%s):"%s" nicht gefunden', [aLine, FormName]);
          exit;  //ignorieren
        end;
      end;
    end;
    if IsMaske then
    begin
      if Pos('-', Va) > 0 then
      begin
        if MaskenIndex >= 0 then
        begin
          Masken.Objects[MaskenIndex].Free;
          Masken.Delete(MaskenIndex);
          if ProtRechte then
            ProtA('Maske[%s] delete', [FormName]);
        end;
      end else
      begin
        //TabellenString := 'NNNJJ';
        TabellenString := StrToDbStr(StrDflt(Va, 'r'));   //NNNJN
        if Tabellen.Values[FormName] <> TabellenString then
        begin
          Tabellen.Values[FormName] := TabellenString;
          if ProtRechte then
            ProtA('Tabelle[%s]=%s', [FormName, TabellenString]);
        end;
      end;
    end else
    begin
      ObjName := copy(Pa, P1 + 1, Maxint);
      {if Pos('R', Va) > 0 then                     //Upd Ins Del Display Enable
        TabellenString := 'NNNJN' else
        TabellenString := 'NNNNN';}
      TabellenString := StrToDbStr(StrDflt(Va, '-'));  //rwx
      AddObjekt(StrValue(Masken[MaskenIndex]), ObjName + '=' + TabellenString);
    end;
  end;

  function Match(Msk, S: string): boolean;
  var
    I, M: integer;
    Wildcard: boolean;
    MC: char;
  begin
    result := false;
    if S = '' then
      Exit;
    if NoMatchList.IndexOf(Uppercase(S)) >= 0 then
      Exit;
    if BeginsWith(S, 'Frm', true) and
       not BeginsWith(Msk, 'Frm', true) and not BeginsWith(Msk, '*') then
     Msk := 'Frm' + Msk;   
    result := true;
    Wildcard := false;
    M := 1;
    MC := Msk[1];
    for I := 1 to length(S) do
    begin
      if MC = '*' then
      begin
        Inc(M);
        if M > length(Msk) then
          MC := #0 else
          MC := Msk[M];
        Wildcard := true;
      end;
      if UpCase(S[I]) = UpCase(MC) then
      begin
        Wildcard := false;
        Inc(M);
        if M > length(Msk) then
          MC := #0 else
          MC := Msk[M];
      end else
      if not WildCard then
      begin
        result := false;
        break;
      end;
    end;
    {if ProtRechte then
      if result then
        ProtA('Match(%s,%s):%d', [Msk, S, ord(result)]);}
  end; { match }

var
  I, I1, I2, P1: integer;
  S1, S2, ALine, Pa, Va: string;
  IsMaske: boolean;
  FormName, MaskenString, TabellenString: string;
  MaskenRechte: TMaskenRechte;

begin { InitMaske }
  if LimitList = nil then
    Exit;  //kein DemoModus
  if GNavigator = nil then
    Exit;
  if ProtRechte then
  begin
    Prot0('InitMaske(%s)', [aFormName]);
    if aForm = nil then
      ProtStrings(LimitList);
  end;
  if MaskenCount = 0 then
  begin
    for I := 0 to GNavigator.FormList.Count - 1 do
    begin  //alle bekannten Forms erstmal erlauben
      FormName := Format('Frm%s', [GNavigator.FormList[I]]);
      if Masken.Values[FormName] <> '' then
        continue;  //bereits vorhanden

      Inc(DemoFormId);
      MaskenString := Format('%s=D%d', [FormName, DemoFormId]);

      MaskenRechte := TMaskenRechte.Create;
      MaskenRechte.Objekte := TValueList.Create;
      MaskenRechte.Reports := TValueList.Create;
      Masken.AddObject(MaskenString, MaskenRechte);

      //TabellenString := 'JJJJJ';  //Upd Ins Del Display Enable
      TabellenString := RechteToDbStr([reDisplayed]); //NNNJN
      Tabellen.Values[FormName] := TabellenString;
    end;
  end;
  if aForm = nil then
    Exit;  //Initialaufruf in Main
  {MaskenIndex := Masken.IndexOfName(aFormName);
  if MaskenIndex >= 0 then
  begin
    MaskenRechte := TMaskenRechte(Masken.Objects[MaskenIndex]);
    if MaskenRechte.Objekte.Count > 0 then
      Exit;  //auch schon erledigt
    AddObjekt(StrValue(Masken[MaskenIndex]), '$$belegt$$=JJJJJ'); //Kennzeichen dass belegt
  end; Optimize}
  NoMatchList.Clear; //immer neu einlesen da Position in Limit Liste entscheidend
  for I := 0 to LimitList.Count - 1 do
  begin
    ALine := LimitList[I];
    P1 := Pos(';', ALine);
    if P1 > 0 then
      ALine := Trim(copy(ALine, 1, P1 - 1));
    if ProtRechte then
      ProtA('Line %d(%s)', [I, aLine]);
    if ALine = '' then
    begin   //Kommentar
    end else
    if BeginsWith(ALine, '-') then
    begin
      S1 := Uppercase(copy(ALine, 2, Maxint));
      if NoMatchList.IndexOf(S1) < 0 then
        NoMatchList.Add(S1);
      ProtA('NoMatch(%s)', [S1]);
      if not BeginsWith(S1, 'FRM') then
      begin
        S2 := 'FRM' + S1;
        if NoMatchList.IndexOf(S2) < 0 then
          NoMatchList.Add(S2);
        if ProtRechte then
          ProtA('NoMatch(%s)', [S2]);
      end;
    end else
    if Pos('*', ALine) > 0 then
    begin
      Pa := StrParam(ALine);
      Va := StrValue(ALine);
      P1 := Pos('.', Pa);
      IsMaske := P1 <= 0;
      if IsMaske and (MaskenCount = 0) then
      begin
        for I1 := 0 to GNavigator.FormList.Count - 1 do
        begin
          FormName := Format('Frm%s', [GNavigator.FormList[I1]]);
          if Match(Pa, Formname) then
            DoLimit(FormName + '=' + Va);
        end;
      end;
      FormName := aFormName;
      if not IsMaske and (aForm <> nil) then
      begin
        if Match(copy(Pa, 1, P1 - 1), FormName) then
        begin
          S1 := copy(Pa, P1 + 1, Maxint);  //Objektname
          if Pos('*', S1) <= 0 then
            DoLimit(FormName + '.' + S1 + '=' + Va) else
          for I2 := 0 to aForm.ComponentCount - 1 do
          begin
            if Match(S1, aForm.Components[I2].Name) then
            begin
              S2 := FormName + '.' + aForm.Components[I2].Name;
              if NoMatchList.IndexOf(Uppercase(S2)) < 0 then
                DoLimit(S2 + '=' + Va);
            end;
          end;
        end;
      end;
    end else
    begin
      Pa := StrParam(ALine);
      Va := StrValue(ALine);
      P1 := Pos('.', Pa);
      IsMaske := P1 <= 0;
      if IsMaske or AnsiSameText(copy(Pa, 1, P1 - 1), FormName) or
         AnsiSameText('Frm' + copy(Pa, 1, P1 - 1), FormName) then
        DoLimit(ALine);  //nur bei unser Form
    end;
  end;
  MaskenCount := Masken.Count;  //wenn er bis hierher kommt hat er alle Maskenrechte eingelesen.
end;

function TRechte.MergeRechteString(S1, S2: string): string;
// ergibt die weitergehenden Berechtigungen
  function MergeRechteChar(C1, C2: Char): Char;
  begin
    if not CharInSet(C1, ['J','N']) then
      Result := C2 else
    if not CharInSet(C2, ['J','N']) then
      Result := C1 else
    if (C1 = 'J') or (C2 = 'J') then
      Result := 'J' else
      Result := 'N';
    if not CharInSet(Result, ['J','N']) then
      Result := 'N';
  end;
var
  I: integer;
begin
  Result := '';
  for I := 1 to 5 do
    Result := Result + MergeRechteChar(CharI(S1, I), CharI(S2, I));
end;

procedure TRechte.Init(ADataBase: TuDataBase; AnweId: longint);
{Zur Datenstruktur bestückung}
var
  MaskenString, ObjektString, ReportString: string;
  MaskenRechte : TMaskenRechte;
  Update, Insert, Delete, Displayed, Enabled: string;
  TblMsk, TblObj, TblRep: TuQuery;
  TabellenString: string;
  L, ErrList: TValueList;   {grup.Bemerkung, Params}
  FORM_NAME: string;
  RECH_FORM_ID: integer;
begin
  SMess('Lade Rechte',[0]);
  AllowAll := false;
  ApplicationId := AnweId;
  fDatabase := ADataBase;
  TblMsk := TuQuery.Create(DataBase);  //TblMsk.DataBaseName := DatabaseName;
  TblObj := TuQuery.Create(DataBase);  //TblObj.DataBaseName := DatabaseName;
  TblRep := TuQuery.Create(DataBase);  //TblRep.DataBaseName := DatabaseName;
  L := TValueList.Create;
  ErrList := TValueList.Create;
  try
    (* Masken *)
    TblMsk.SQL.Clear;
    TblMsk.SQL.Add('select R.RECH_FORM_ID,      ');
    TblMsk.SQL.Add('       R.RECH_GRUP_ID,      ');
    TblMsk.SQL.Add('       R.RECH_UPDATE_KNZ,   ');
    TblMsk.SQL.Add('       R.RECH_INSERT_KNZ,   ');
    TblMsk.SQL.Add('       R.RECH_DELETE_KNZ,   ');
    TblMsk.SQL.Add('       R.RECH_DISPLAYED_KNZ,');
    TblMsk.SQL.Add('       R.RECH_ENABLED_KNZ,  ');
    TblMsk.SQL.Add('       F.FORM_NAME,         ');
    TblMsk.SQL.Add('       P.BEMERKUNG          ');
    TblMsk.SQL.Add(Format('from %s R, %s F, %s G, %s P, %s U', [TblNameRECHTE,
      TblNameFORMS, TblNameUSER_GRUPPEN, TblNameGRUPPEN, TblNameUSERS]));
    TblMsk.SQL.Add('where ((R.RECH_OBJE_ID is null) or (R.RECH_OBJE_ID = 0))    ');
    TblMsk.SQL.Add('  and ((R.RECH_REPO_ID is null) or (R.RECH_REPO_ID = 0))    ');
    TblMsk.SQL.Add('  and ((R.RECH_BATA_ID is null) or (R.RECH_BATA_ID = 0))    ');
    TblMsk.SQL.Add('  and (R.RECH_FORM_ID = F.FORM_ID)');
    TblMsk.SQL.Add('  and (F.FORM_ANWE_ID = ' + IntToStr(ApplicationId)+')');
    TblMsk.SQL.Add('  and (P.GRUP_ID = G.USGR_GRUP_ID)');
    TblMsk.SQL.Add('  and (R.RECH_GRUP_ID = G.USGR_GRUP_ID) ');
    TblMsk.SQL.Add('  and (G.USGR_USER_ID = U.USER_ID)');
    TblMsk.SQL.Add(Format(
                   '  and (U.USER_KENNUNG = ''%s'')', [SysParam.UserName]));
    TblMsk.SQL.Add('order by G.USGR_ID');  //Reihenfolge wie bei User eingetragen
    ErrList.Assign(TblMsk.SQL);
    if ProtRechte then
      ProtStrings(TblMsk.SQL);
    SMess('Öffne Masken',[0]);
    Masken.Clear;
    try
      TblMsk.Open;
    except on E:Exception do
      EError('%s:%s', [E.Message, TblMsk.Text]);
    end;
    TblMsk.First;
    while not TblMsk.EOF do
    begin
      FORM_NAME := TblMsk.FieldByName('FORM_NAME').AsString;
      RECH_FORM_ID := TblMsk.FieldByName('RECH_FORM_ID').AsInteger;
      SMess('Lade Maskenrechte %s',[FORM_NAME]);
      MaskenString := Format('%s=%d',[FORM_NAME, RECH_FORM_ID]);
      //ProtA('%s:%s',[TblMsk.FieldByName('FORM_NAME').AsString, MaskenString]);

      MaskenRechte := TMaskenRechte.Create;
      MaskenRechte.Objekte := TValueList.Create;
      MaskenRechte.Reports := TValueList.Create;

      (* Maskenobjekt Schreiben *)
      Masken.AddObject(MaskenString, MaskenRechte);

      (* Tabellenrechte schreiben         hier neu wg qusy 020398 *)
      TabellenString := Format('%s%s%s%s%s',
                       [GetKnz(TblMsk.FieldByName('RECH_UPDATE_KNZ')),
                        GetKnz(TblMsk.FieldByName('RECH_INSERT_KNZ')),
                        GetKnz(TblMsk.FieldByName('RECH_DELETE_KNZ')),
                        GetKnz(TblMsk.FieldByName('RECH_DISPLAYED_KNZ')),
                        GetKnz(TblMsk.FieldByName('RECH_ENABLED_KNZ'))]);
      Tabellen.Values[FORM_NAME] := MergeRechteString(Tabellen.Values[FORM_NAME],
        TabellenString);
      if ProtRechte then
        ProtA('TblMsk(%d:%s=%s)', [RECH_FORM_ID, FORM_NAME, TabellenString]);

      //Bemerkungsfeld der Gruppe: Param=Value für KmpRechte.Params.Values[sLsthGruppe]; QUPE
      L.Clear;
      GetFieldStrings(TblMsk.FieldByName('BEMERKUNG'), L);
      Params.Merge(L);

      TblMsk.Next;
    end;

    (* Objecte *)
    TblObj.SQL.Clear;
    TblObj.SQL.Add('select R.RECH_UPDATE_KNZ,         ');
    TblObj.SQL.Add('       R.RECH_INSERT_KNZ,         ');
    TblObj.SQL.Add('       R.RECH_DELETE_KNZ,         ');
    TblObj.SQL.Add('       R.RECH_DISPLAYED_KNZ,      ');
    TblObj.SQL.Add('       R.RECH_ENABLED_KNZ,        ');
    TblObj.SQL.Add('       R.RECH_FORM_ID,            ');
    TblObj.SQL.Add('       O.OBJE_NAME                ');
    TblObj.SQL.Add(Format('from %s R, %s o, %s G, %s U',[TblNameRECHTE,
                   TblNameOBJEKTE, TblNameUSER_GRUPPEN, TblNameUSERS]));
    TblObj.SQL.Add('where (R.RECH_OBJE_ID = o.oBJE_ID)                ');
    TblObj.SQL.Add('  and (R.RECH_GRUP_ID = G.USGR_GRUP_ID)           ');
    TblObj.SQL.Add('  and (G.USGR_USER_ID = U.USER_ID)                ');
    TblObj.SQL.Add(Format(
                   '  and (U.USER_KENNUNG = ''%s'')', [SysParam.UserName]));
    TblMsk.SQL.Add('order by G.USGR_ID');  //Reihenfolge wie bei User eingetragen
    ErrList.Assign(TblObj.SQL);
(*
select R.RECH_UPDATE_KNZ,
       R.RECH_INSERT_KNZ,
       R.RECH_DELETE_KNZ,
       R.RECH_DISPLAYED_KNZ,
       R.RECH_ENABLED_KNZ,
       R.RECH_FORM_ID,
       O.OBJE_NAME
from RECH R, OBJE o,   USGR G, USRS U
where (R.RECH_OBJE_ID = o.oBJE_ID)
  and (R.RECH_GRUP_ID = G.USGR_GRUP_ID)
  and (G.USGR_USER_ID = U.USER_ID)
  and (U.USER_KENNUNG = 'TESTBENUTZER')
*)
    SMess('Öffne Objekte',[0]);
    if ProtRechte then
      ProtStrings(TblObj.SQL);
    TblObj.Open;
    TblObj.First;
    while not TblObj.EOF do
    begin
      SMess('Lade Objektrechte',[0]);
      (* Objektname = Rechte: JJJJJJ *)
      Update := TblObj.FieldByName('RECH_UPDATE_KNZ').AsString;
      if Update = '' then
        Update := ' ' else
        Update := copy(Update,1,1);
      Insert := TblObj.FieldByName('RECH_INSERT_KNZ').AsString;
      if Insert = '' then
        Insert := ' ' else
        Insert := copy(Insert,1,1);
      Delete := TblObj.FieldByName('RECH_DELETE_KNZ').AsString;
      if Delete = '' then
        Delete := ' ' else
        Delete := copy(Delete,1,1);
      Displayed := TblObj.FieldByName('RECH_DISPLAYED_KNZ').AsString;
      if Displayed = '' then
        Displayed := ' ' else
        Displayed := copy(Displayed,1,1);
      Enabled := TblObj.FieldByName('RECH_ENABLED_KNZ').AsString;
      if Enabled = '' then
        Enabled := ' ' else
        Enabled := copy(Enabled,1,1);
      ObjektString := Format('%s=%s%s%s%s%s',
                       [TblObj.FieldByName('OBJE_NAME').AsString,
                        Update,Insert,Delete,Displayed,Enabled]);
      if ProtRechte then
        ProtA('TblObj(%s,%s)',[TblObj.FieldByName('RECH_FORM_ID').AsString, ObjektString]);
      AddObjekt(TblObj.FieldByName('RECH_FORM_ID').AsString, ObjektString);
      TblObj.Next;
    end;

    (* Reports *)
    {if Prot = nil then Prot := TProt.Create(Application);
    Prot0('Start',[0]);}
    TblRep.SQL.Clear;
    TblRep.SQL.Add('select REPO.REPO_NAME,         ');
    TblRep.SQL.Add('       REPO.REPO_PARALISTE,    ');
    TblRep.SQL.Add('       PROG.PROG_NAME,         ');
    TblRep.SQL.Add('       PROG.PROG_PARALISTE,    ');
    TblRep.SQL.Add('       REFO.REFO_FORM_ID       ');
    TblRep.SQL.Add(Format('from %s REFO, %s REPO, %s PROG',
                   [TblNameREPORT_FORMS,TblNameREPORTS, TblNamePROGRAMMARTEN]));
    TblRep.SQL.Add('where (REFO.REFO_REPO_ID = REPO.REPO_ID)');
    TblRep.SQL.Add('  and (REPO.REPO_PROG_ID = PROG.PROG_ID)');
    ErrList.Assign(TblRep.SQL);
    if ProtRechte then
      ProtSql(TblRep);
    SMess('Öffne Reports',[0]);
    TblRep.Open;
    TblRep.First;
    while not TblRep.EOF do
    begin
      (* Reportname = PROG_NAME PROG_PARALISTE REPO_PARALISTE *)
      SMess('Lade Reportrechte',[0]);
      ReportString := Format('%s=%s %s %s',
                       [TblRep.FieldByName('REPO_NAME').AsString,
                        TblRep.FieldByName('PROG_NAME').AsString,
                        TblRep.FieldByName('PROG_PARALISTE').AsString,
                        TblRep.FieldByName('REPO_PARALISTE').AsString]);
      if ProtRechte then
        ProtA('TblRep(%s)%s',[TblRep.FieldByName('REFO_FORM_ID').AsString,ReportString]);
      AddReport(TblRep.FieldByName('REFO_FORM_ID').AsString, ReportString);
      TblRep.Next;
    end;


    InitTab(ADataBase);
    ErrList.Clear;
  finally
    if ErrList.Count > 0 then
      ProtStrings(ErrList);
    TblMsk.Free;
    TblObj.Free;
    TblRep.Free;
    L.Free;
  end;
end;

procedure TRechte.InitTab(ADataBase: TuDataBase);
{Zusatzinitialisierung}
var
  TabellenString: string;
  TblTab: TuQuery;
begin
  {if Prot = nil then Prot := TProt.Create(Application);
  protA('Start',[0]);}
  SMess('Öffne Tabellen',[0]);
  fDatabase := ADatabase;
  TblTab := TuQuery.Create(DataBase);  //TblTab.DataBaseName := ADataBase.DataBaseName;
  try
    (* Tabellen *)
    TblTab.SQL.Clear;
    TblTab.SQL.Add('select R.RECH_FORM_ID,                            ');
    TblTab.SQL.Add('       R.RECH_GRUP_ID,                            ');
    TblTab.SQL.Add('       R.RECH_UPDATE_KNZ,                         ');
    TblTab.SQL.Add('       R.RECH_INSERT_KNZ,                         ');
    TblTab.SQL.Add('       R.RECH_DELETE_KNZ,                         ');
    TblTab.SQL.Add('       R.RECH_DISPLAYED_KNZ,                      ');
    TblTab.SQL.Add('       R.RECH_ENABLED_KNZ,                        ');
    TblTab.SQL.Add('       F.FORM_NAME                                ');
    TblTab.SQL.Add(Format('from %s R, %s F, %s G, %s U', [TblNameRECHTE,
                   TblNameFORMS, TblNameUSER_GRUPPEN, TblNameUSERS]));
    TblTab.SQL.Add('where (R.RECH_OBJE_ID is null)                    ');
    TblTab.SQL.Add('  and (R.RECH_REPO_ID is null)                    ');
    TblTab.SQL.Add('  and (R.RECH_BATA_ID is not null)                ');
    TblTab.SQL.Add('  and (R.RECH_FORM_ID = F.FORM_ID)                ');
    TblTab.SQL.Add('  and (F.FORM_ANWE_ID = '+IntToStr(ApplicationId)+')');
    TblTab.SQL.Add('  and (R.RECH_GRUP_ID = G.USGR_GRUP_ID)           ');
    TblTab.SQL.Add('  and (G.USGR_USER_ID = U.USER_ID)                ');
    TblTab.SQL.Add(Format(
                   '  and (U.USER_KENNUNG = ''%s'')', [SysParam.UserName]));
    if ProtRechte then
      ProtStrings(TblTab.SQL);
(*
select R.RECH_FORM_ID,
       R.RECH_GRUP_ID,
       R.RECH_UPDATE_KNZ,
       R.RECH_INSERT_KNZ,
       R.RECH_DELETE_KNZ,
       R.RECH_DISPLAYED_KNZ,
       R.RECH_ENABLED_KNZ,
       F.FORM_NAME
from RECH R, FORM F,  USGR G, USRS U
where (R.RECH_OBJE_ID is null)
  and (R.RECH_REPO_ID is null)
  and (R.RECH_BATA_ID is not null)
  and (R.RECH_FORM_ID = F.FORM_ID)
  and (F.FORM_ANWE_ID = 7)
  and (R.RECH_GRUP_ID = G.USGR_GRUP_ID)
  and (G.USGR_USER_ID = U.USER_ID)
  and (U.USER_KENNUNG = 'TESTBENUTZER')
*)
    {Tabellen.Clear; nein wg. Msk}
    TblTab.Open;
    TblTab.First;
    while not TblTab.EOF do
    begin
      SMess('Lade Tabellenrechte',[0]);
      (* Formularname = Rechte: JJJJJJ *)
      TabellenString := Format('%s%s%s%s%s',
                       [GetKnz(TblTab.FieldByName('RECH_UPDATE_KNZ')),
                        GetKnz(TblTab.FieldByName('RECH_INSERT_KNZ')),
                        GetKnz(TblTab.FieldByName('RECH_DELETE_KNZ')),
                        GetKnz(TblTab.FieldByName('RECH_DISPLAYED_KNZ')),
                        GetKnz(TblTab.FieldByName('RECH_ENABLED_KNZ'))]);
      Tabellen.Values[TblTab.FieldByName('FORM_NAME').AsString] :=
        TabellenString;     {Überschreibt Rechte von Maske}
      (*Update := TblTab.FieldByName('RECH_UPDATE_KNZ').AsString;
      if Update = '' then
        Update := ' ' else
        Update := copy(Update,1,1);
      Insert := TblTab.FieldByName('RECH_INSERT_KNZ').AsString;
      if Insert = '' then
        Insert := ' ' else
        Insert := copy(Insert,1,1);
      Delete := TblTab.FieldByName('RECH_DELETE_KNZ').AsString;
      if Delete = '' then
        Delete := ' ' else
        Delete := copy(Delete,1,1);
      Displayed := TblTab.FieldByName('RECH_DISPLAYED_KNZ').AsString;
      if Displayed = '' then
        Displayed := ' ' else
        Displayed := copy(Displayed,1,1);
      Enabled := TblTab.FieldByName('RECH_ENABLED_KNZ').AsString;
      if Enabled = '' then
        Enabled := ' ' else
        Enabled := copy(Enabled,1,1);
      TabellenString := Format('%s=%s%s%s%s%s',
                       [TblTab.FieldByName('FORM_NAME').AsString,
                        Update,Insert,Delete,Displayed,Enabled]);
      Tabellen.Add(TabellenString);*)
      if ProtRechte then
        ProtA('TblTab(%s=%s)', [TblTab.FieldByName('FORM_NAME').AsString, TabellenString]);
      TblTab.Next;
    end;
  finally
    TblTab.Free;
  end;
end;

function TRechte.FSyn(FrmName: string): string;
begin
  result := StrDflt(FormSynonyms.Values[FrmName], FrmName);
end;

{ TMaskenRechte }

destructor TMaskenRechte.Destroy;
begin
  FreeAndNil(Objekte);
  FreeAndNil(Reports);
  inherited;
end;

(*
select R.RECH_FORM_ID,
       R.RECH_GRUP_ID,
       R.RECH_UPDATE_KNZ,
       R.RECH_INSERT_KNZ,
       R.RECH_DELETE_KNZ,
       R.RECH_DISPLAYED_KNZ,
       R.RECH_ENABLED_KNZ,
       F.FORM_NAME
from RECH R, FORM F, USGR G, USRS U
where (R.RECH_OBJE_ID is null)
  and (R.RECH_REPO_ID is null)
  and (R.RECH_BATA_ID is null)
  and (R.RECH_FORM_ID = F.FORM_ID)
  and (F.FORM_ANWE_ID = 7)
  and (R.RECH_GRUP_ID = G.USGR_GRUP_ID)
  and (G.USGR_USER_ID = U.USER_ID)
  and (U.USER_KENNUNG = 'TESTBENUTZER')
*)

end.
