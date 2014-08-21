unit Datn_Kmp;
(* Dateien (doc, xls, pdf usw) in Datenbank vorhalten und auf
   lokales Dateisystem abbilden

   Autor: Martin Dambach
   Letzte Änderung:
04.06.08 MD  erstellen
31.07.10 md  sdbl\bild, ImportFile
28.12.11 md  mehrere Queries pro FieldList
30.06.13 md  mischprot
16.11.13 md  mehrere Instanzen erlauben. Nur erste ist Datn. (DatnVer)

*)
{ BaseDir: string  read from Ini [DATN]BaseDir }
{ Property DatabaseName, dflt = 'DB1'  read from [DATN]DatabaseName }
{ Property Tablename, dflt = 'R_DATN'  read from [DATN]TableName }

{ User functions:
  procedure CheckOut(aOrdner: string);                //from DB to lokal
  procedure CheckIn(aOrdner: string);                 //to DB
  function GetLokal(aOrdner, aFilename: string): string;  //ergibt lokalen Filenamen

{ FileList enthält die Filenamen von Lokal und Db }

{geaendert_am original belassen
filetime statt geaendert_am für Vergleiche verwenden }

{ TODO : FileOpenDialog(aOrdner): Filename
  mit Kontrolle ob Verzeichnis nicht geändert wurde - n.b.
}

interface

uses
  WinTypes, Classes, Menus, Controls,  Uni, DBAccess, MemDS, UQue_Kmp,
  DPos_Kmp, NLnk_Kmp;

const  // Bekannte Ordner QW - mit abschließendem '\'!
  DatnLogon =               '\LOGON\';
  DatnSdblFaxSend =         '\SDBL\FAXSEND\';
  DatnSdblCustomerPackage = '\SDBL\CUSTOMERPACKAGE\';
  DatnSdblBild =            '\SDBL\BILD\';
  DatnQupeReports =         '\QUPE\REPORTS\';
  DatnQuppReports =         '\QUPP\REPORTS\';
  DatnQuvaVersandavis =     '\QUVA\VERSANDAVIS\';
  DatnQuvaMischprot =       '\QUVA\MISCHPROT\';
  DatnQuvaLfsLogos  =       '\QUVA\LIEFERSCHEIN\LOGOS\';
  DatnQuvaLfsSiegel =       '\QUVA\LIEFERSCHEIN\SIEGEL\';
  DatnQuvaLfsTexte  =       '\QUVA\LIEFERSCHEIN\TEXTE\';
  DatnQSBT =                '\QSBT\'; //sg_wiegezettel, kein_bild, AKW_Anfahrtsskizze_HR.doc
  DatnQsbtBild =            '\QSBT\BILD\'; //Bilder für Touch
  DatnApps  =               '\APPS\'; //Version Upload 17.11.13
  DatnBdeDatenblatt =       '\BDE\DATENBLATT\';  //Messe 2014
  DatnQuvaWerksattest =     '\QUVA\WERKSATTEST\';  //Polen Werksattest 05.07.14

  DatnPdfImage =               '\PDFIMAGE\';  //für itfPDFImage


const
  Kurz = 'DATN';

type
  TDatnFileInfo = class(TObject)
    Filename: string;
    IsLokal: boolean;
    IsDb: boolean;
    LokalDT: TDateTime;
    DbDT: TDateTime;
    function CompareLokalDT: integer;  //-1:Lokal ist kleiner/älter
  end;

type
  TDatnKmp = class(TComponent)
  private
    XProtAktiv: boolean;
    FBaseDir: string;
    FDatabaseName: string;
    FTablename: string;
    FQuery: TuQuery;
    fOrdnerList: TStringList;
    fLlOrdner: string;
    FQueOrdner: TuQuery;
    FQueInhalt: TuQuery;
    procedure SetDataBaseName(const Value: string);
    procedure SetTablename(const Value: string);
    procedure SetBaseDir(const Value: string);
    function GetOrdnerList: TStringList;
    function GetTablename: string;
    function GetFileList(const aOrdner: string): TStrings;
    function FileListGetObject(L: TStrings; aFileName: string): TDatnFileInfo;
    function GetFileInfo(aOrdner, aFilename: string): TDatnFileInfo;
    procedure CheckInFI(aOrdner: string; FI: TDatnFileInfo);
    procedure CheckOutFI(aOrdner: string; FI: TDatnFileInfo);
    procedure SetLlOrdner(const Value: string);
  protected
    procedure XProt(Modus: char; const Fmt: string; const Args: array of const);
    property Query: TuQuery read FQuery;
    property QueOrdner: TuQuery read FQueOrdner;
    property QueInhalt: TuQuery read FQueInhalt;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    destructor Destroy; override;
    procedure Edit;  //Dialog aufrufen
    function FileDialog(aOrdner: string; var aFilename: string): boolean;
    function GetLokal(aOrdner, aFilename: string): string; overload;
    function GetLokal(aOrdnerFilename: string): string; overload;
    procedure CheckIn(aOrdner: string);                 //to DB
    procedure CheckOut(aOrdner: string);                //from DB
    procedure CheckInFile(aOrdner, aFilename: string);
    procedure CheckOutFile(aOrdner, aFilename: string);
    function StripBaseDir(aDir: string): string;
    procedure CopyOrdnerToLokal(aOrdner: string);
    procedure CopyOrdnerToDb(aOrdner: string);
    procedure CopyFileToLokal(aOrdner, aFilename: string);
    procedure CopyFileToDb(aOrdner, aFilename: string);
    procedure ClearOrdnerList;
    procedure ClearFileList(aOrdner: string);
    procedure ImportFile(aOrdner, aImportFilename: string);
    property OrdnerList: TStringList read GetOrdnerList;
    property FileList[const aOrdner: string]: TStrings read GetFileList;
    property LlOrdner: string read fLlOrdner write SetLlOrdner;  //List&Label Reports Ordner
  published
    property BaseDir: string read FBaseDir write SetBaseDir;
    property DatabaseName: string read FDatabaseName write SetDataBaseName;
    property Tablename: string read fTablename write SetTablename;
  end;

var
  Datn: TDatnKmp;

implementation

uses
  WinProcs, SysUtils, Consts, Forms, Dialogs, ShellApi, Buttons,
  StdCtrls, Db, DbCtrls, ExtCtrls,
  Printers,
  Err__Kmp, Prots, GNav_Kmp, Ini__Kmp, FldDsKmp;

procedure TDatnKmp.XProt(Modus: char; const Fmt: string; const Args: array of const);
begin
  if not XProtAktiv then
  try
    XProtAktiv := true;
    if IniKmp.ReadBool(SSystem, 'ProtDatn', false) then
    begin
      case Modus of
        'A': ProtA(Fmt, Args);
        'L': ProtL(Fmt, Args);
      else   Prot0(Fmt, Args);
      end;
    end else
    begin
      case Modus of
        'L': SMess(Fmt, Args);
      end;
    end;
  finally
    XProtAktiv := false;
  end;
end;

constructor TDatnKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //16.11.13 mehrere Instanzen erlauben (DatnVer)
//  if Datn <> nil then
//    raise EInit.Create('DATN Komponente bereits vorhanden');
  if Datn = nil then
    Datn := self;
  FQuery := TuQuery.Create(nil);
  FQueOrdner := TuQuery.Create(nil);
  FQueInhalt := TuQuery.Create(nil);
  FBaseDir := 'c:\temp\dateien';
  DatabaseName := 'DB1';
  Tablename := 'R_DATN';
end;

destructor TDatnKmp.Destroy;
var
  I: integer;
begin
  if Datn = self then
    Datn := nil;
  if Assigned(fOrdnerList) then
  begin
    for I := 0 to fOrdnerList.Count - 1 do
      ClearFileList(fOrdnerList[I]);
    ClearObjects(fOrdnerList);  //Filelists auch entfernen
    fOrdnerList.Free;
  end;
  FreeAndNil(FQuery);
  FreeAndNil(FQueOrdner);
  FreeAndNil(FQueInhalt);
  inherited;
end;

procedure TDatnKmp.Loaded;
begin
  inherited Loaded;
end;

procedure TDatnKmp.SetDataBaseName(const Value: string);
begin
  FDatabaseName := Value;
  if FQuery.DatabaseName <> Value then
  begin
    FQuery.Close;
    FQueOrdner.Close;
    FQueInhalt.Close;
    FQuery.DatabaseName := Value;
    FQueOrdner.DatabaseName := Value;
    FQueInhalt.DatabaseName := Value;
  end;
end;

function TDatnKmp.GetTablename: string;
// nicht in Property!
begin
  if GNavigator <> nil then
    result := StrDflt(GNavigator.TableSynonyms.Values[fTablename], fTablename) else
    result := fTablename;
end;

procedure TDatnKmp.SetTablename(const Value: string);
begin
  FTablename := Value;
end;

procedure TDatnKmp.SetBaseDir(const Value: string);
var
  S1: string;
begin
  S1 := PartDir(StrDflt(Value, 'C:\basedir'));  //ohne endendes '\'
  if FBaseDir <> S1 then
  begin
    FBaseDir := S1;
    Prot0('%s BaseDir=%s', [Kurz, FBaseDir]);
    ClearOrdnerList;
    //Prot0('X datn basedir', [0]);
  end;
end;

function TDatnKmp.StripBaseDir(aDir: string): string;
// Basedir weg. Ergebnis hat vorne und hinten '\'.
var
 I: integer;
begin
  Result := aDir;
  for I := 1 to length(BaseDir) do
  begin
    if AnsiUpperCase(BaseDir[I]) = AnsiUpperCase(Char1(Result)) then
      Result := copy(Result, 2, MaxInt) else
      break;
  end;
  if CharI(Result, 2) = ':' then           // c:\ -> \
    Result := Copy(Result, 3, MaxInt);
  if Char1(Result) <> '\' then
    Result := '\' + Result;
  if (Length(Result) > 1) and (CharN(Result) <> '\') then
    Result := Result + '\';
end;

function TDatnKmp.GetOrdnerList: TStringList;
// Die Ordnerlist enthält die Vereinigungsmenge von lokalen und DB Ordnern.
// Ein Ordner beginnt und endet mit '\'

  procedure OrdnerAddLokal(aDir: string);
  //rekursiv zum Sammeln der lokalen Ordner. aDir enthält BaseDir.
  var
    SearchRec: TSearchRec;
  begin
    fOrdnerList.Add(StripBaseDir(aDir));
    if SysUtils.FindFirst(ValidDir(aDir) + '*.*', faDirectory, SearchRec) = 0 then
    try
      repeat
        if (Char1(SearchRec.Name) <> '.') and ((SearchRec.Attr and faDirectory) <> 0) then
        begin
          fOrdnerList.Add(StripBaseDir(ValidDir(aDir) + SearchRec.Name));
          OrdnerAddLokal(ValidDir(aDir) + SearchRec.Name);
        end;
      until SysUtils.FindNext(SearchRec) <> 0;
    finally
      SysUtils.FindClose(SearchRec);
    end;
  end;

  procedure OrdnerAddDb;
  var
    S1: string;
  begin
    try
      QueOrdner.Close;
      //25.03.12 weg QueOrdner.RequestLive := false;
      QueOrdner.Sql.Text := Format('select distinct ORDNER from %s', [GetTableName]);
      // Optimierung möglich: 'where not Ordner in fOrdnerList'
      QueOrdner.Open;
      QueOrdner.First;
      while not QueOrdner.EOF do
      begin
        S1 := StripBaseDir(QueOrdner.FieldByName('ORDNER').AsString);
        if fOrdnerList.IndexOf(S1) < 0 then  //nicht zw Groß/Kleinschreibung unterscheiden
          fOrdnerList.Add(S1);  //strip wg '\' am A&E
        QueOrdner.Next;
      end;
      QueOrdner.Close;
    except on E:Exception do begin
        EProt(QueOrdner, E, 'Fehler OrdnerAddDb %s', [GetTableName]);
        raise;
      end;
    end;
  end;

begin { GetOrdnerList }
  if fOrdnerList = nil then
  begin
    fOrdnerList := TStringList.Create;
    fOrdnerList.Sorted := true;
    fOrdnerList.Duplicates := dupIgnore;
    OrdnerAddLokal(BaseDir);
    OrdnerAddDb;
  end;
  Result := fOrdnerList;
end;

procedure TDatnKmp.ClearOrdnerList;
begin
  ClearObjects(fOrdnerList);  //Filelists auch entfernen
  fOrdnerList.Free;
  fOrdnerList := nil;
end;

function TDatnKmp.FileListGetObject(L: TStrings; aFileName: string): TDatnFileInfo;
var
  I: integer;
begin
  I := L.IndexOf(aFileName);
  if I < 0 then
  begin
    I := L.AddObject(aFileName, TDatnFileInfo.Create);
  end;
  Result := TDatnFileInfo(L.Objects[I]);
  Result.Filename := aFilename;
end;

function TDatnKmp.GetFileList(const aOrdner: string): TStrings;
// FileList enthält die lokalen und DB-Einträge in einer TDatnFileInfo Struktur
var
  Ordner1: string;
  FileList1: TStringList;

  procedure FilesAddLokal;
  // lokale Files in <FileListOrdner> zu Filelist hinzufügen
  var
    SearchRec: TSearchRec;
    LokalOrdner: string;
  begin
    LokalOrdner := PartDir(BaseDir) + Ordner1;
    if SysUtils.FindFirst(LokalOrdner + '*.*', faAnyFile, SearchRec) = 0 then
    try
      repeat
        //and ((SearchRec.Attr and faVolumeID) = 0) - veraltet
        if ((SearchRec.Attr and faDirectory) = 0) then
        begin
          //fFileList.AddObject(SearchRec.Name), TDatnFileInfo.Create());
          with FileListGetObject(FileList1, SearchRec.Name) do
          begin
            IsLokal := true;
            //ist nicht identisch mit FileAge! LokalDT := FileDateToDateTime(SearchRec.Time);
            LokalDT := GetFileDateTime(LokalOrdner + SearchRec.Name);
          end;
        end;
      until SysUtils.FindNext(SearchRec) <> 0;
    finally
      SysUtils.FindClose(SearchRec);
    end;
  end;

  procedure FilesAddDb;
  begin
    try
      Query.Close;
      //25.03.12 weg Query.RequestLive := false;
      Query.Sql.Text := Format('select DATN_ID, ORDNER, FILENAME, FILETIME'+ CRLF +
                               'from %s' + CRLF +
                               'where upper(ORDNER) = :ORDNER', [GetTableName]);
      Query.ParamByName('ORDNER').AsString := AnsiUpperCase(Ordner1);
      Query.Open;
      Query.First;
      while not Query.EOF do
      begin
        with FileListGetObject(FileList1, Query.FieldByName('FILENAME').AsString) do
        begin
          IsDB := true;
          DbDT := Query.FieldByName('FILETIME').AsDateTime;
        end;
        Query.Next;
      end;
      Query.Close;
    except on E:Exception do begin
        EProt(Query, E, 'Fehler GetFileList(%s)', [aOrdner]);
        raise;
      end;
    end;
  end;
var
  I: integer;
begin { GetFileList }
  Ordner1 := StripBaseDir(aOrdner);  //strip wg '\' am A&E
  I := OrdnerList.IndexOf(Ordner1);
  if I < 0 then
  begin
    I := OrdnerList.Add(Ordner1);
  end;
  FileList1 := TStringList(OrdnerList.Objects[I]);
  if FileList1 = nil then
  begin
    FileList1 := TStringList.Create;
    OrdnerList.Objects[I] := FileList1;
    FileList1.Sorted := true;
    FileList1.Duplicates := dupIgnore;
    ClearObjects(FileList1);
    FilesAddLokal;
    FilesAddDb;
  end;
  Result := FileList1;
end;

procedure TDatnKmp.ClearFileList(aOrdner: string);
//entfernt Cache, so dass Infos beim nächsten Zugriff neu eingelesen werden.
var
  Ordner1: string;
  I: integer;
  FileList1: TStringList;
begin
  Ordner1 := StripBaseDir(aOrdner);  //strip wg '\' am A&E
  I := OrdnerList.IndexOf(Ordner1);
  if I >= 0 then
  begin
    FileList1 := TStringList(OrdnerList.Objects[I]);
    if FileList1 <> nil then
    begin
      ClearObjects(FileList1);  //TDatnFileInfo Objects
      OrdnerList.Objects[I].Free;
      OrdnerList.Objects[I] := nil;
    end;
  end;
end;

function TDatnKmp.GetFileInfo(aOrdner, aFilename: string): TDatnFileInfo;
begin
  Result := FileListGetObject(FileList[aOrdner], aFileName);
end;

{ User functions }

procedure TDatnKmp.CheckIn(aOrdner: string);
//Datenbank aktualisieren
var
  I: integer;
  L: TStrings;
begin
  L := FileList[aOrdner];
  if GNavigator <> nil then
    GNavigator.Canceled := false;
  for I := 0 to L.Count - 1 do
    if (GNavigator = nil) or (not GNavigator.Canceled) then  //Processmessages
    begin
      GMessA(I + 1, L.Count + 1);
      CheckInFI(aOrdner, TDatnFileInfo(L.Objects[I]));
    end;
  GMess0;
end;

procedure TDatnKmp.CheckOut(aOrdner: string);
//Lokal aktualisieren
var
  I: integer;
  L: TStrings;
begin
  ProtL_Unique(100, UqS('Datn'), 'DATN Checkout %s', [aOrdner]);
  L := FileList[aOrdner];
  Prot0_Unique(100, UqS('Datn'), 'DATN Checkout: %d Files', [L.Count]);
  if GNavigator <> nil then
    GNavigator.Canceled := false;
  for I := 0 to L.Count - 1 do
    if (GNavigator = nil) or (not GNavigator.Canceled) then  //Processmessages
    try
      SMess('Checkout %s', [aOrdner]);
      GMessA(I + 1, L.Count + 1);
      CheckOutFI(aOrdner, TDatnFileInfo(L.Objects[I]));
    except on E:Exception do
      EMess(self, E, 'Fehler bei Checkout(%s.%d)', [aOrdner, I]);
    end;
  GMess0;
  SMess0;
end;

procedure TDatnKmp.CheckInFile(aOrdner, aFilename: string);
//File in Datenbank aktualisieren
begin
  CheckInFI(aOrdner, GetFileInfo(aOrdner, aFilename));
end;

procedure TDatnKmp.CheckOutFile(aOrdner, aFilename: string);
//File Lokal aktualisieren
begin
  CheckOutFI(aOrdner, GetFileInfo(aOrdner, aFilename));
end;

procedure TDatnKmp.CheckInFI(aOrdner: string; FI: TDatnFileInfo);
//File in Datenbank aktualisieren
begin
  if not FI.IsDB or (FI.CompareLokalDT > 0) then
    CopyFileToDb(aOrdner, FI.Filename) else
  if FI.IsDB and (FI.CompareLokalDT < 0) then
  begin
    if not FI.IsLokal then
      Prot0('%s Warnung: Checkin(%s) Db fehlt lokal', [Kurz, aOrdner + FI.Filename])
    else
      Prot0('%s Warnung: Checkin(%s) Db(%s) neuer als lokal(%s)', [Kurz,
        aOrdner + FI.Filename, DateTimeToStr(FI.DbDT), DateTimeToStr(FI.LokalDT)]);
  end;
end;

procedure TDatnKmp.CheckOutFI(aOrdner: string; FI: TDatnFileInfo);
//File Lokal aktualisieren
begin
  if not FI.IsLokal or (FI.CompareLokalDT < 0) then  //DbDT > FI.LokalDT
  begin
    CopyFileToLokal(aOrdner, FI.Filename);
  end else
  if FI.IsLokal and (FI.CompareLokalDT > 0) then  //DbDT < FI.LokalDT
  begin
    if not FI.IsDB then
      Prot0('%s Warnung: Checkout(%s) fehlt in Db', [Kurz, aOrdner + FI.Filename])
    else
      Prot0('%s Warnung: Checkout(%s) lokal(%s) neuer als Db(%s)', [Kurz,
        aOrdner + FI.Filename, DateTimeToStr(FI.LokalDT), DateTimeToStr(FI.DbDT)]);
  end;
end;

procedure TDatnKmp.CopyFileToLokal(aOrdner, aFilename: string);
var
  LokalFilename: string;
  DT: TDateTime;
begin
  Prot0('%s CopyFileToLokal(%s, %s)', [Kurz, aOrdner, aFilename]);
  LokalFilename := BaseDir + aOrdner + aFilename;
  QueInhalt.Close;
  //25.03.12 weg QueInhalt.RequestLive := false;
  QueInhalt.Sql.Text := Format('select DATN_ID, ORDNER, FILENAME, FILETIME, INHALT' + CRLF +
    'from %s' + CRLF +
    'where (upper(ORDNER) = :ORDNER) and (upper(FILENAME) = :FILENAME)', [GetTableName]);
  QueInhalt.ParamByName('ORDNER').AsString := AnsiUpperCase(aOrdner);
  QueInhalt.ParamByName('FILENAME').AsString := AnsiUpperCase(aFilename);

  (* unnötig
  if SysParam.MSSQL then
  begin
    {MSSQL}
    L := TValueList.Create;
    L.AddTokens('ORDNER;FILENAME;FILETIME;INHALT', ';');
    FldDsc.Update(QueInhalt, GetTableName, L);
    L.Free;
    with QueInhalt.FieldDefs do
    begin
      for I := 0 to Count - 1 do
      begin
        AFieldName := Items[I].Name;
        AField := Items[I].CreateField(QueInhalt);
        AField.Name := Format('%s%s', [QueInhalt.Name, StrToValidIdent(AFieldName)]);
      end;
    end;
  end;
  *)
  Screen.Cursor := crHourGlass;
  try
    QueInhalt.Open;
    if QueInhalt.EOF then
      EError('%s CopyFileToLokal "%s" fehlt in DB', [Kurz, aOrdner + aFilename]);
    ForceDirectories(BaseDir + aOrdner);
    TBlobField(QueInhalt.FieldByName('INHALT')).SaveToFile(LokalFilename);
    DT := QueInhalt.FieldByName('FILETIME').AsDateTime;
    SetFileDateTime(LokalFilename, DT);
    QueInhalt.Close;
    with GetFileInfo(aOrdner, aFilename) do
    begin
      IsLokal := true;
      LokalDT := DT;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TDatnKmp.CopyFileToDb(aOrdner, aFilename: string);
var
  LokalFilename: string;
  DatnId: Double;
  DT: TDateTime;
  S1: string;
//  AFieldName, S1: string;
//  AField: TField;
//  L: TValueList;
begin
  Prot0('%s CopyFileToDb(%s, %s)', [Kurz, aOrdner, aFilename]);
  LokalFilename := BaseDir + aOrdner + aFilename;
  if not SysUtils.FileExists(LokalFilename) then
    EError('%s CopyFileToDb "%s" fehlt lokal', [Kurz, LokalFilename]);
  DT := GetFileDateTime(LokalFilename);
  Query.Close;
  Query.Unprepare; //wichtig für mssql - 28.12.11
  //25.03.12 weg Query.RequestLive := false;  //wg upper notwendig
  //09.11.10 Query.Sql.Text := Format('select DATN_ID,ORDNER,FILENAME from %s' + CRLF +
  Query.Sql.Text := Format('select DATN_ID, ORDNER, FILENAME, FILETIME'+ CRLF +
                           'from %s' + CRLF +
    'where (upper(ORDNER) = :ORDNER) and (upper(FILENAME) = :FILENAME)', [GetTableName]);
  Query.ParamByName('ORDNER').AsString := AnsiUpperCase(aOrdner);
  Query.ParamByName('FILENAME').AsString := AnsiUpperCase(aFilename);
  Query.Prepare;  //wichtig für mssql - 28.12.11
  Query.Open;
  DatnId := Query.FieldByName('DATN_ID').AsFloat;
  Query.Close;
  Query.UnPrepare;


  //BDE Query.AutoRefresh := true;
  //25.03.12 weg QueInhalt.RefreshOptions := [roAfterInsert];  //roAfterUpdate, roBeforeEdit  - UniDAC
  QueInhalt.Options.RequiredFields := false; //UniDAC: kein Fehler wenn datn_id is null
  QueInhalt.Close;
  //25.03.12 weg QueInhalt.RequestLive := true;
  QueInhalt.FieldDefs.Clear;
  //QueInhalt.Sql.ChangeCursor := true;
  Screen.Cursor := crHourGlass;
  QueInhalt.Sql.Text := Format('select DATN_ID, ORDNER, FILENAME, FILETIME, INHALT, '+
                               'ERFASST_VON, GEAENDERT_VON' + CRLF +
                               'from %s' + CRLF +
    'where (DATN_ID = :DATN_ID) order by DATN_ID', [GetTableName]);
  QueInhalt.ParamByName('DATN_ID').AsFloat := DatnId;

//  if SysParam.MSSQL then
//  begin
//    {MSSQL}
//    L := TValueList.Create;
//    L.AddTokens('DATN_ID;ORDNER;FILENAME;FILETIME;INHALT', ';');
//    FldDsc.Update(QueInhalt, GetTableName, L);
//    L.Free;
//    with QueInhalt.FieldDefs do
//    begin
//      for I := 0 to Count - 1 do
//      begin
//        AFieldName := Items[I].Name;
//        S1 := Format('%s%s', [QueInhalt.Name, StrToValidIdent(AFieldName)]);
//        if QueInhalt.FindField(S1) = nil then
//        begin
//          AField := Items[I].CreateField(QueInhalt);
//          AField.Name := S1;
//        end;
//      end;
//    end;
//    //QueInhalt.FieldByName('DATN_ID').FieldKind := fkInternalCalc;     nicht wenn geöffnet
//    QueInhalt.FieldByName('DATN_ID').AutoGenerateValue := arAutoInc;
//  end;

  QueInhalt.Prepare;  //wichtig für mssql - 28.12.11
  QueInhalt.Open;

  try
    // Transaction muss sein wg Blob ORA-22990: LOB-Positionsanzeiger auf eine Transaktion beschränkt
    //09.11.10 QueInhaltDatabase(QueInhalt).StartTransaction;
    try
      S1 := Format('%s@%s', [Sysparam.Username, CompName]);
      if QueInhalt.EOF then
      begin
        QueInhalt.Insert;
        QueInhalt.FieldByName('ERFASST_VON').AsString := S1;
      end else
      begin
        QueInhalt.Edit;
        QueInhalt.FieldByName('GEAENDERT_VON').AsString := S1;
      end;
      //beware mssql! QueInhalt.FieldByName('DATN_ID').AsInteger := 0; //UniDAC required
      QueInhalt.FieldByName('ORDNER').AsString := aOrdner;
      QueInhalt.FieldByName('FILENAME').AsString := aFileName;
      QueInhalt.FieldByName('FILETIME').AsDateTime := DT;
      TBlobField(QueInhalt.FieldByName('INHALT')).LoadFromFile(LokalFilename);
      QueInhalt.Post;  //UniDAC: keine zusätzliche Transaktion notwendig
    except on E:Exception do begin
        EProt(QueInhalt, E, 'CopyFileToDb', [0]);
        raise;
      end;
    end;
  finally
    QueInhalt.Close;
    QueInhalt.Unprepare;  //wichtig für mssql - 28.12.11
    QueInhalt.FieldDefs.Clear;
    Screen.Cursor := crDefault;
  end;

  with GetFileInfo(aOrdner, aFilename) do
  begin
    IsDb := true;
    DbDT := DT;
  end;
end;

procedure TDatnKmp.CopyOrdnerToLokal(aOrdner: string);
var
  I: integer;
  L: TStrings;
  FI: TDatnFileInfo;
begin
  L := FileList[aOrdner];
  for I := 0 to L.Count - 1 do
  begin
    FI := TDatnFileInfo(L.Objects[I]);
    if FI.IsDb then
      CopyFileToLokal(aOrdner, FI.Filename);
  end;
end;

procedure TDatnKmp.CopyOrdnerToDb(aOrdner: string);
var
  I: integer;
  L: TStrings;
  FI: TDatnFileInfo;
begin
  L := FileList[aOrdner];
  for I := 0 to L.Count - 1 do
  begin
    FI := TDatnFileInfo(L.Objects[I]);
    if FI.IsLokal then
      CopyFileToDb(aOrdner, FI.Filename);
  end;
end;

procedure TDatnKmp.Edit;
begin
  GNavigator.StartForm(Application, 'DATNED');
end;

function TDatnKmp.FileDialog(aOrdner: string; var aFilename: string): boolean;
// Auswahl eines Files in der Datenbank. Nach Übernahme erfolgt ein Sync nach lokal.
// wenn in Ordner etwas eingetragen ist, kann der Ordner nicht gewechselt werden
// wenn der Ordner mit einer Maske endet ('\sdbl\fax\*.pdf') wird der Filter angewendet
//   ein '\' hinter dem Filterzeichen wird als Ordnerfilter angesehen ('\sdbl\*\*.pdf')
// aFilename enthält Ordner+Name, ohne BaseDir
// ergibt true wenn etwas ausgewählt wurde

// aOrdner wird immer ab root interpretiert (ggf. ein '\' vorangestellt). Es gibt kein 'aktuelles Verzeichnis'
// ein führendes 'c:\' wird ignoriert bzw. nach root umgesetzt. (auch d:\ usw.)
begin
  result := false;
end;

procedure TDatnKmp.ImportFile(aOrdner: string; aImportFilename: string);
//importiert externes File in die lokale Ordnerstruktur, nicht in die DB.
//aktualisiert Datenstruktur: IsLokal, Timestamp
//Exception wenn Import nicht möglich
//es muss noch CheckIn durchgeführt werden!
var
  S1, S2: string;
begin
  ForceDirectories(Datn.BaseDir + aOrdner);
  S1 := aImportFilename;
  S2 := Datn.BaseDir + aOrdner + ExtractFilename(S1);
  if CompareText(S1, S2) = 0 then
    EError('Sie können nicht aus dem gleichen Verzeichnis (%s) importieren', [ExtractFilePath(S1)]);
  CopyFile(S1, S2);  // from,To

  ClearFileList(aOrdner);  //wird dann beim nächsten Zugriff wieder aufgebaut
end;

function TDatnKmp.GetLokal(aOrdnerFilename: string): string;
// ergibt Filenamen im lokalen Filesystem. Checkt ggf aus DB aus.
var
  aOrdner, aFilename: string;
begin
  Result := BaseDir + aOrdnerFilename;
  try
    aOrdner := StrDflt(ExtractFilePath(aOrdnerFilename), '\');
    aFilename := ExtractFileName(aOrdnerFilename);
    Result := BaseDir + aOrdner + aFilename;
    CheckOutFile(aOrdner, aFilename);
  except on E:Exception do
    EProt(self, E, 'GetLokal(%s)', [aOrdnerFilename]);
  end;
end;

function TDatnKmp.GetLokal(aOrdner, aFilename: string): string;
// überladen mit anderen Parametern. Von aFilename wird der Pfad ignoriert.
// für Kompatibilität mit alten Filenamen-Vorgaben
begin
  Result := GetLokal(aOrdner + ExtractFilename(aFilename));
end;

procedure TDatnKmp.SetLlOrdner(const Value: string);
// List&Label Report-Files lokal einblenden
begin
  if fLlOrdner <> Value then
  begin
    fLlOrdner := Value;
    Datn.CheckOut(fLlOrdner);
  end;
end;

{ TDatnFileInfo }

function TDatnFileInfo.CompareLokalDT: integer;
// Vergleicht Lokal - DB Timestamp.
// Ergibt -1 wenn Lokal kleiner/älter DB; 0 wenn gleich.
// Wenn Unterschied genau 1 Stunde dann als gleich interpretieren.
begin
  if Round((LokalDT - DbDT)*10000000) = Round(1 / 24 * 10000000) then
    Result := 0 else
  if LokalDT = DbDT then
    Result := 0 else
  if abs(LokalDT - DbDT) < 2 / SecsPerDay then
    Result := 0 else
  if LokalDT < DbDT then
    Result := -1 else
  //if LokalDT > DbDT then
    Result := 1;
end;

end.
