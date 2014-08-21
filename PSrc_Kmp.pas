unit Psrc_kmp;
(* PrintSource: Schnittstelle zu Druckformular in Formular

   Autor: Martin Dambach
   Letzte Änderung:
   03.10.96     Erstellen
   07.08.97     FltrList, KeyFields, OnCopyFltr. DoCopyFltr geändert
                Standarddrucker ohne BeforePrint Hook
   01.02.00     NoPreview
   06.07.00 MD  WinFax globale Funktion
   17.03.02 MD  MuSelect
   22.03.02 MD  TDruckerTypProperty Editor
   02.03.03 MD  Export direkt aufrufen, für GNostice-PrnSrc (psGNostice)
   08.04.03 MD  Hardcopy
   06.03.07 MD  MuSelect
   26.03.07 MD  Hardcopy wird immer angeboten
   14.05.08 MD  Option 'Fähigkeit für Hoch/Querformat': psOrientation
                  Format wird in Bemerkung [Orientation=L/=P] angegeben
   23.05.08 MD  falls Orientation nicht im Bemerkung angegeben (DfltRep)
                  dann letzte Wahl in .INI merken.
   22.06.08 MD  CopyFltr kopiert jetzt auch References
   02.08.08 MD  PrintCount gekapselt; jetzt TPrnSource.PrintCount;
   09.08.08 MD  Export published. plus ExportFilename. für Word u.a.
   10.07.09 MD  OutputBin jetzt direkt vom Druckertreiber
   22.11.11 md  KeepPrinter: (Standard-)Drucker wird außerhalb gesetzt.
   23.12.11 md  OpenAfterGenerate
   03.07.12 md  Ausdruck über LuDef, MuGrid: docopyfltr
   06.02.13 md  LoadedOneRecord
   25.02.13 md  OnPreview =nil gesetzt. Kompatibel zu alten QR Versionen.
   18.04.14 md  PageCount via QR.Prepare. psPagecount Option
                http://stackoverflow.com/questions/3616898/delphi-quick-reports-total-pages
   -------------------------------------
*)

interface

uses
{$ifdef WIN32}
  WinFax,
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Quickrpt, DB,
  DPos_Kmp, DbGrids;

const
  SHardcopyKurz = 'Hardcopy';
  SOrientation = 'Orientation';
  SFontSize = 'FontSize';
  sReportTitle = 'ReportTitle';  //für DfltXRep

type
  TPrnSource = class;

  TBeforePrnEvent = procedure(Sender: TObject; var fertig: boolean) of Object;   {EreignissTyp für das Ereigniss BeforePrn}
  TCopyFltrEvent = procedure(Sender: TPrnSource) of Object; {EreignissTyp für das Ereigniss OnCopyFltr}
  TExportFileEvent = procedure(Sender: TPrnSource; AQuickRep: TQuickRep) of Object;

  TPrnSourceOption = (psMessage,
                      psSetCaption,
                      psSetDisplay,
                      psRaiseError,
                      psOrientation,
                      psFontSize,
                      psUserCaption,
                      psDisableAll,   //'alle' drucken unterbinden - 21.09.12
                      psPageCount);   //Anzahl Seiten via Prepare
  TPrnSourceOptions = set of TPrnSourceOption;
  TFaxApi = (NoFax, WinFaxDde);

  TPrnSource = class(TComponent)
  private
    { Private-Deklarationen }
    FVisible: boolean;      {in Auswahl zeigen}
    FQRepKurz: string; {Kurzbezeichnung voM QuickReport-Formular}
    FPreView: Boolean; {Seitenansicht}
    FNoPreView: Boolean; {keine Seitenansicht}
    FFltrList: TFltrList;
    FKeyFields: string;  {Sortierung}
    FDisplay: string; {Überschrift für Druckauswahl}
    FDruckerTyp: string;         {Druckername für Druckerzuordnung}
    FBemerkung: TValueList;
    FCaption: string;
    {QRep2:}
    FCopyFltr: boolean;          {FltrList kopieren}
    FOneRecord: boolean;         {nur einen Record drucken}
    FKopien: integer;            {Anzahl Kopieen}
    FFaxApi: TFaxApi;            {Faxschnittstelle (Winfax)}
    FFaxNr: string;
    FFaxName: string;
    FOptions: TPrnSourceOptions;
    FMuSelect: TDBGrid;           {Grid für SelectedRows: llPrn}
    FExportFile: boolean;            {Export programmierbar}
    FOnExportFile: TExportFileEvent; {Export programmierbar, psGnostice}

    OldQRepBeforePrint: TQRReportBeforePrintEvent; {Zum Zwischenspeichern des Benutzrereignisses}
    FExportFilename: string;
    FKeepPrinter: boolean;
    FOpenAfterGenerate: boolean;
    FPageCount: integer;
    procedure NewQRepBeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean); {die neue Ereignissroutine von BeforePrint}
    function GetDisplay: string;                          {zum lesenden Zugriff}
    procedure SetFltrList(Value: TFltrList);              {FilterList Schreiben}
    procedure SetQRepKurz(Value: string);                   {Schreibt QRepKurz}
    procedure SetBemerkung(Value: TValueList);
    function GetCaption: string;
    function GetLandscape: boolean;
    procedure SetLandscape(const Value: boolean);
    function GetFontSize: integer;
    procedure SetFontSize(const Value: integer);
    procedure SetCaption(const Value: string);
  protected
    { Protected-Deklarationen }
    FBeforePrn: TBeforePrnEvent; {Ereigniss als Functionpointer}
    FAfterPrn: TNotifyEvent;
    FOnFinished: TNotifyEvent;
    FOnCopyFltr: TCopyFltrEvent;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoPreview(Sender: TObject); virtual;
  public
    { Public-Deklarationen }
    Printing: boolean;   {Flag ob in DoRun}
    BookMark: TBookMark; {Position innerhalb einer Datenmenge}
    LoadedFltrList: TFltrList;
    LoadedOneRecord: boolean;
    DoPrint: boolean;    //true=keine Daten zum Drucken gefunden. Zur Abfrage in AfterPrn/OnFinished
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetupPrn(var HasChanged: boolean); virtual; {Drucker einrichten / Designer}
    procedure SetPrinterAsDefault;
    procedure DoRun; virtual;
    procedure DoRunEvent(Sender: TObject);  //für Mu.Loop()
    {Start des Ausdrucks}
    procedure DoQRepInit(Sender: TCustomQuickRep; var PrintReport: Boolean); virtual;
    {Initialisieren QuickReport}
    procedure DoCopyFltr(OneRecord: boolean; AForm: TForm);
    (* Kopiert Fltr oder Primary Key Fields und KeyList nach PrnSource
       für QRep 2.00 *)
    function IsFiller: boolean;  //ergibt true bei Pseudo-PS, hat '-' als Display

    class function PrintCount: integer;
    class Procedure IncPrintCount(Increment: integer);  //+/-1

    property IsLandscape: boolean read GetLandscape write SetLandscape;
    property FontSize: integer read GetFontSize write SetFontSize;
    property KeepPrinter: boolean read FKeepPrinter write FKeepPrinter;
    property PageCount: integer read FPageCount;
  published
    { Published-Deklarationen }
    property MuSelect: TDBGrid read FMuSelect write FMuSelect;  //markierte in dieser Grid Drucken
    property QRepKurz: string read FQRepKurz write SetQRepKurz;
    property Preview: boolean read FPreview write FPreview;
    property NoPreview: boolean read FNoPreview write FNoPreview;
    property FltrList: TFltrList read FFltrList write SetFltrList;
    property KeyFields: string read FKeyFields write FKeyFields;

    property Visible: boolean read FVisible write FVisible;
    property Display: string read GetDisplay write FDisplay;
    property DruckerTyp: string read FDruckerTyp write FDruckerTyp;
    property Bemerkung: TValueList read FBemerkung write SetBemerkung;
    property Caption: string read GetCaption write SetCaption;

    property CopyFltr: boolean read FCopyFltr write FCopyFltr;
    property OneRecord: boolean read FOneRecord write FOneRecord;
    property Kopien: integer read FKopien write FKopien;
    property FaxApi: TFaxApi read FFaxApi write FFaxApi;
    property FaxNr: string read FFaxNr write FFaxNr;
    property FaxName: string read FFaxName write FFaxName;
    property Options: TPrnSourceOptions read FOptions write FOptions;
    property OpenAfterGenerate: boolean read FOpenAfterGenerate write FOpenAfterGenerate;

    property ExportFile: boolean read FExportFile write FExportFile;
    property ExportFilename: string read FExportFilename write FExportFilename;
    property OnExportFile: TExportFileEvent read FOnExportFile write FOnExportFile;

    property BeforePrn: TBeforePrnEvent read FBeforePrn write FBeforePrn;
    property AfterPrn: TNotifyEvent read FAfterPrn write FAfterPrn;
    property OnCopyFltr: TCopyFltrEvent read FOnCopyFltr write FOnCopyFltr;
    property OnFinished: TNotifyEvent read FOnFinished write FOnFinished;
  end;

implementation

uses
  Printers, QrPrntr, QrPreDlg,  Uni, DBAccess, MemDS,
  GNav_Kmp, Prots, Qwf_Form, QRepForm, Err__Kmp, LNav_Kmp, NLnk_Kmp,
  LuDefKmp, Ini__Kmp, Poll_Kmp, WRep_Kmp, Sql__Dlg, PrnFoDlg,
  Tools, KmpResString;

const
  SHardcopyBmp = 'hardcopy.bmp';

var
  fPrintCount: integer;    //Anzahl laufende Ausdrucke

{ statische Funktionen }

class procedure TPrnSource.IncPrintCount(Increment: integer);
begin
  Inc(fPrintCount, Increment);
end;

class function TPrnSource.PrintCount: integer;
begin
  Result := fPrintCount;
end;

(*** Zugriff auf Properties **************************************************)

function TPrnSource.GetDisplay: string;
{zum lesenden Zugriff}
begin
  if FDisplay = '' then
    result := name else
    result := FDisplay;
end;

procedure TPrnSource.SetFltrList(Value: TFltrList);
{Schreibender Zugriff auf FilterList}
begin
  FFltrList.Assign(Value);
end;

procedure TPrnSource.SetQRepKurz(Value: string);
begin
  FQRepKurz := Value;
end;

procedure TPrnSource.SetBemerkung(Value: TValueList);
begin
  if FBemerkung <> Value then
    FBemerkung.Assign(Value);
  if not (csDesigning in ComponentState) then
  begin
    if FBemerkung.Values[SOrientation] <> '' then
      Options := Options + [psOrientation];
    if FBemerkung.Values[SFontSize] <> '' then
      Options := Options + [psFontSize];
  end;
end;

procedure TPrnSource.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

function TPrnSource.GetCaption: string;
begin
  result := FCaption;
  if (FCaption = '') and (FBemerkung.Count >= 1) then
    if Pos('=', FBemerkung[0]) <= 0 then
      result := FBemerkung[0];
end;

(*** Initialisierung *********************************************************)

constructor TPrnSource.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFltrList := TFltrList.create;
  FBemerkung := TValueList.Create;
  LoadedFltrList := TFltrList.Create;
  Visible := true;
  FKopien := 1;
  Options := [psMessage];
end;

destructor TPrnSource.Destroy;
begin
  FFltrList.Free;       FFltrList := nil;
  FBemerkung.Free;      FBemerkung := nil;
  LoadedFltrList.Free;	LoadedFltrList := nil;
  inherited Destroy;
end;

procedure TPrnSource.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in Owner.ComponentState) then
  begin
    LoadedFltrList.Assign(FltrList);
    LoadedOneRecord := OneRecord;  //06.02.13
    
    if QRepKurz = 'DFLT' then  //Standard Liste hat immer diese Option - 14.05.08
      Options := Options + [psOrientation, psFontSize];
    if QRepKurz = 'DFLTX' then  //Standard Liste X-Direkt hat immer diese Option - 23.05.08
      Options := Options + [psOrientation, psFontSize];
  end;
end;

procedure TPrnSource.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if Operation = opRemove then
  begin
    if AComponent = fMuSelect then
      fMuSelect := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

(*** Hilfsfunktionen *********************************************************)

procedure TPrnSource.DoCopyFltr(OneRecord: boolean; AForm: TForm);
(* Kopiert Fltr oder Primary Key Fields und KeyList nach PrnSource
   für QRep 2.00 *)
var
  SenderForm: TqForm;
  //SenderLNav: TLNavigator;
  SenderNLnk: TNavLink;
  I: integer;
  AFieldName, ATableName, AFieldValue: string;
  TmpList: TFltrList;
  OldBookMark: TBookMark;
  IFld, IRow: integer;
  S1, S2, S3, S4: string;
begin
  try
    SenderForm := Owner as TqForm;
    SenderNLnk := nil;
    if SenderForm.LNavigator <> nil then
      SenderNLnk := SenderForm.LNavigator.NavLink;
    if MuSelect <> nil then
    begin
      if MuSelect.DataSource is TLookUpDef then
        SenderNLnk := TLookUpDef(MuSelect.DataSource).NavLink;
    end;

    ATableName := '';
    if (SenderNLnk.TableList.Count = 0) then
    begin
      //Schema.TN -> TN - DPE.ZAK 31.01.04 wenn Schema=dbo.
      //ATableName := OnlyFieldName(SenderNLnk.NavLink.TableList.Strings[0]) + '.';
    end;
    if (MuSelect <> nil) and (MuSelect.SelectedRows.Count > 0) then
    begin                //korrekt nur bei ID-PKey mit 1 Segment!
      FltrList.Clear;
      OldBookMark := SenderNLnk.DataSet.GetBookMark;
      S1 := SenderNLnk.PrimaryKeyList[0];
      S2 := '';
      for IRow := 0 to pred(MuSelect.SelectedRows.Count) do
      begin
        SenderNLnk.DataSet.Bookmark := MuSelect.SelectedRows[IRow];
        if SenderNLnk.PrimaryKeyList.Count <= 1 then
        begin
          AppendTok(S2, SenderNLnk.DataSet.FieldByName(S1).AsString, ';');
        end else
        begin
          S2 := SenderNLnk.DataSet.FieldByName(S1).AsString;
          if IRow > 0 then
            S2 := ';' + S2;    //für ' or '
          for IFld := 1 to pred(SenderNLnk.PrimaryKeyList.Count) do
          begin
            S3 := SenderNLnk.PrimaryKeyList[IFld];
            S4 := SenderNLnk.DataSet.FieldByName(S3).AsString;
            AppendTok(S2, Format('{%s=''%s''}', [S3, S4]), '&');
          end;
          FltrList.Add(S1 + '=' + S2);    //Zeile S1= kommt pro Datenzeile vor
        end;
      end;
      if SenderNLnk.PrimaryKeyList.Count <= 1 then
      begin
        FltrList.Add(S1 + '=' + S2);    //Zeile S1= kommt pro Datenzeile vor
      end;
      SenderNLnk.DataSet.GotoBookMark(OldBookMark);
      SenderNLnk.DataSet.FreeBookMark(OldBookMark);
      if CopyFltr then
        KeyFields := SenderNLnk.KeyFields;
    end else
    if OneRecord then {nur ein Datensatz}
    begin
      FltrList.Clear;
      for I:= 0 to SenderNLnk.PrimaryKeyList.Count-1 do
      begin
        AFieldName := OnlyFieldName(SenderNLnk.PrimaryKeyList.Strings[I]);
        AFieldValue := SenderNLnk.DataSet.FieldByName(AFieldName).AsString;
        {TableName.FieldName=FieldValue}
        if AFieldValue = '' then
          AFieldValue := '=';       {is null}
        FltrList.Add(Format('%s%s=%s', [ATableName, AFieldName, AFieldValue]));
      end;
    end else
    if CopyFltr then {Aktive Filter werden benutzt}
    begin
      TmpList := TFltrList.Create;
      try
        FltrList.Clear;
        TmpList.Assign(SenderNLnk.FltrList);
        TmpList.AddStrings(SenderNLnk.References);  //neu 22.06.08
        for I:= 0 to TmpList.Count-1 do
        begin
          AFieldName := TmpList.Param(I);
          AFieldValue := TmpList.Value(I);

          {AFieldName := GetLongFieldName(SenderNLnk.SqlFieldList, AFieldName);}
          AFieldName := SenderNLnk.LongFieldName(AFieldName);
          (* wurde ersetzt
          if (AFieldName = OnlyFieldName(AFieldName)) and  {wenn kein TableName. vorn}
             (SenderNLnk.SqlFieldList.Count > 0) then
          begin
            {suchen in der SQLFieldList nach Entsprechung und ggf übernehmen}
            for ISql := 0 to SenderNLnk.SqlFieldList.Count-1 do
            begin
              if CompareText(AFieldName,OnlyFieldName(
                SenderNLnk.SqlFieldList.Strings[ISql])) = 0 then
              begin
                AFieldName := SenderNLnk.SqlFieldList.Strings[ISql];
                break;
              end;
            end;
          end; *)
          if SenderNLnk.SqlFieldList.Values[OnlyFieldName(AFieldName)] <> '' then
          begin                          {computet Sql Fields 'as ...'}
            FltrList.Add(Format('%s=%s', [AFieldName, AFieldValue]))
          end else
          if AFieldName = OnlyFieldName(AFieldName) then
          begin        {Der Feldname hat keinen Tabellennamen voran}
            FltrList.Add(Format('%s%s=%s', [ATableName, AFieldName, AFieldValue]))
          end else
            FltrList.Add(Format('%s=%s', [AFieldName, AFieldValue]))
        end;
      finally
        TmpList.Free;
      end;
      KeyFields := SenderNLnk.KeyFields;
    end else
    begin          {weder CopyFltr noch OneRecord: FlrList direkt übersetzen:}
      TmpList := TFltrList.Create;
      try                                            {:Felder in Werte umsetzen}
        TmpList.Assign(FltrList);
        FltrList.Clear;
        FltrList.AddFltrList(SenderNLnk.DataSet, TmpList, true);
      finally
        TmpList.free;
      end;
    end;
    if assigned(FOnCopyFltr) then  {Benutzerereigniss aufrufen}
      FOnCopyFltr(self);
  except
    on E:Exception do
    begin
      ErrWarn('DoCopyFltr:%s', [E.Message]);
      raise
    end;
  end;
end;

(*** Ereignisse **************************************************************)

procedure TPrnSource.SetupPrn(var HasChanged: boolean);
{Dialog um Druckereinrichten}
var
  aFontSize: integer;
begin
  HasChanged := true;
  if psFontSize in Options then
  begin
    aFontSize := self.FontSize;
    TDlgPrnFont.Execute(DruckerTyp, aFontSize);
    if aFontSize >= 3 then
      self.FontSize := aFontSize;
  end else
    SetupPrinter(DruckerTyp);
end;

procedure TPrnSource.DoQRepInit(Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
  (* Aktionen erst in TAusw *)
end;

procedure TPrnSource.NewQRepBeforePrint(Sender: TCustomQuickRep; var PrintReport: Boolean);
{Rufen des Umgebogenen Ereignisshandlers}
begin
  DoQRepInit(Sender, PrintReport);
  if not PrintReport then
    Exit;
  if assigned(OldQRepBeforePrint) then
    OldQRepBeforePrint(Sender, PrintReport);
  (* Fax Data *)
  if not Preview and (FaxApi = WinFaxDde) then
  begin
{$ifdef WIN32}
    ProtL(SPsrc_Kmp_003,[FaxNr, FaxName]);	// 'Richte DDE-Verbindung zu Winfax ein (%s %s)'
    with DDEWinFax do
    try
      DialAsEntered := false;              {wg Prefix}
      DialPrefix := SysParam.FaxPrefix;
      SendFaxParams.PhoneNumber := FaxNr;
      SendFaxParams.RecipientName := FaxName;
      SendFaxParams.Subject := Display;
      if not Execute then
	// 'Nummer kann nicht zu Winfax übertragen werden (%s %s)'
        EError(SPsrc_Kmp_004,[FaxNr, FaxName]);
    finally
      SMess('',[0]);
    end;
{$else}
{$endif}
  end;
end;

(*** Methoden ****************************************************************)

procedure TestOutputBin(QRep: TQuickRep);
(* HP-Laser 5MP:  Oberer Schacht = Auto               ($11)
                  Unterer Schacht = Upper oder First  ($14)
                  ??? = Manual                        ($12)
 Procedur zum Auslesen des Schachtes mittels des Druckereigenen Treibers
*)
var
  ADevice, ADriver, APort: array[0..80] of Char;
  ADeviceMode: THandle;
  AOutputBin: TQRBin;
  aBin : integer;
{$ifdef win32}
    DevMode : PDeviceMode;
{$else}
    DevMode : PDevMode;
    ExtDeviceMode: TExtDeviceMode;
{$endif}
begin
  Printer.GetPrinter(ADevice, ADriver, APort, ADeviceMode); {Globale Variable Printer auslesen}
  if ADeviceMode = 0 then                     {ADeviceMode Druckerdatenstruktur}
    Printer.GetPrinter(ADevice, ADriver, APort, ADeviceMode);
  if ADeviceMode = 0 then
  begin
    Prot0('DeviceMode = 0', [0]);  //Zugriff nicht möglich
    Exit;
  end;
  DevMode := GlobalLock(ADeviceMode);   {Pointer anhand Handle auf
                                         Druckerdatenstruktur vom Druckertreiber}

  AOutputBin := Auto;                            {Schachtnummer auf Auto setzen}
  if (DevMode^.dmFields and dm_defaultsource) = dm_defaultsource then
  {liefert der Druckertreiber die Informationen über Schacht ?}
  begin
    aBin := DevMode^.dmDefaultSource;                    {Schacht als Konstante}
    (*
    for I := First to Last do  {sucht in der Zuordnungstabelle von QuickRep nach Entsprechung}
    begin
      if cQRBinTranslate[I] = aBin then
      begin
        AOutputBin := I;
        break;
      end
    end  weg 10.07.09*)
    if QRep <> nil then     {setzen von QuickRep auf den voreingestellten Schacht}
    begin
      QRep.PrinterSettings.UseCustomBinCode := true;
      QRep.PrinterSettings.CustomBinCode := aBin;
    end;
  end;
  if QRep <> nil then     {setzen von QuickRep auf den voreingestellten Schacht}
    QRep.PrinterSettings.OutputBin := AOutputBin;

  {DevMode^.dmFields := DevMode^.dmFields and not dm_defaultsource;
  Printer.SetPrinter(ADevice, ADriver, APort, ADeviceMode);}

  GlobalUnlock(ADeviceMode); {Handle wieder freigeben}
end;

procedure TPrnSource.DoPreview(Sender: TObject);
begin
//11.11.12 jetzt per RegisterPreviewClass
//  if DlgQRPreview = nil then
//  begin
//    PollWait;                         {damit Polling nicht blockiert 210200 HDO}
//    TDlgQRPreview.CreatePreview(Application, Sender as TQRPrinter);
//    DlgQRPreview.PrnSource := self;           {Verweis auf Aufrufer aufbauen}
//  end;
//  DlgQRPreview.Show
end;

procedure TPrnSource.DoRunEvent(Sender: TObject);
//Alternativaufruf für Mu.Loop()
begin
  DoRun;
end;

procedure TPrnSource.DoRun;
{Startroutine zum Drucken. Externer aufruf}
var
  Fertig: boolean;
  AQRepForm: TQRepForm;
  CompositeReport: TQRCompositeReport;
  WRep: TWRep;
  QuickReport: TQuickRep;
  I: integer;
  APrinterIndex: integer;                            {Bezug auf Windows-Drucker}
  PrinterFont: string;
  FormImage: TBitmap;
begin
  Fertig := false;
  SMess(SPsrc_Kmp_005,[0]);		// 'Ausdruck läuft ...'
  if assigned(FBeforePrn) then
  try
    FBeforePrn(self, Fertig);
  except on E:Exception do
    begin
      Fertig := true;
      EMess(self, E, 'Error at BeforePrn', [0]); //Fehlermaske nicht 2mal anzeigen 09.06.03 SDBL
      if psRaiseError in Options then
        raise;                                      {wichtig!  HLW.AuFa.PSGrosset}
    end;
  end;
  if not Fertig then
  try
    IncPrintCount(1);
    Printing := true;
    if QRepKurz = '' then
    begin
      ErrWarn(SPsrc_Kmp_010, [0]);	// 'PrnSource:Quickreport ist nicht angegeben'   02.03.03
    end else
    try
      if not KeepPrinter then
      begin
        APrinterIndex := SysParam.GetPrinterIndex(DruckerTyp, PrinterFont);    {N}
        SetDefaultPrinter(APrinterIndex);             {Als Standartdrucker setzen}
      end;
      TestOutputBin(nil);                                     {Schacht belegen}
      if CompareText(QRepKurz, SHardcopyKurz) = 0 then
      begin
        AQRepForm := nil;
        if Preview then
        begin
          FormImage := TCustomForm(Owner).GetFormImage;
          FormImage.SaveToFile(TempDir + SHardcopyBmp);
          SysParam.DisplayWinExecError := true;
          ShellExecNoWait(TempDir + SHardcopyBmp, SW_NORMAL);
        end else
        begin
          TCustomForm(Owner).Print;
        end;
      end else
        AQRepForm := GNavigator.StartQRepForm(self, QRepKurz); {Create von QuicReport}
      if AQRepForm <> nil then {wenn gültig}  {Holen von QuickRep-Form von GNav}
      try
        DoPrint := true;                                             {Soweit OK}
        DoCopyFltr(OneRecord, AQRepForm);           {immer, OnCopyFltr Ereignis}
        if AQRepForm.LNavigator <> nil then                {wenn LNav vorhanden}
        begin    {Filter Liste von PrnSource auf den LNav von QuickRep kopieren}
          AQRepForm.LNavigator.NavLink.NoBuildSql := true;
          AQRepForm.LNavigator.FltrList.Assign(FltrList);
          if KeyFields <> '' then
            AQRepForm.LNavigator.KeyFields := KeyFields;           {analog s.o.}
          FltrList.Assign(LoadedFltrList);  //FltrList wieder herstellen (für nächsten Druck)!DPE.VREG
          AQRepForm.LNavigator.NavLink.NoBuildSql := false;
        end;
        AQRepForm.Init(self);                              {self wichtig!  Open}
        if AQRepForm.LNavigator <> nil then                     {wenn vorhanden}
        begin
          AQRepForm.LNavigator.DoInit;                 {Initialisieren des LNav}
          AQRepForm.LNavigator.DoStart(self);          {Startfunktion von LNav}
          if (AQRepForm.LNavigator.DataSet <> nil) and
             (AQRepForm.LNavigator.DataSet.EOF) and
             (AQRepForm.LNavigator.DataSet.Active) and                  {031099}
             not AQRepForm.PrintIfEmpty then                      {QuickReport.}
          begin
            if psMessage in Options then // 'Keine Datensätze zum Drucken gefunden'
              ErrWarn('%s:'+CRLF+SPsrc_Kmp_006, [Display]) else
              Prot0('%s:'+SPsrc_Kmp_006, [Display]);
            try
              //ProtSql(AQRepForm.LNavigator.Query); {nichts gefunden: Prot}
              if AQRepForm.LNavigator.Query <> nil then
                ProtStrings(AQRepForm.LNavigator.Query.SQL); {nichts gefunden: Prot}
            except
            end;
            //TDlgSql.Execute(Application, TuQuery(AQRepForm.LNavigator.DataSet), false);
            DoPrint := false;
          end else
          if SysParam.ProtPrint then
          try
            Prot0('Start Print(%s) User(%s) Kopien(%d) SQL:', [Display, Sysparam.UserName, Kopien]);
            if AQRepForm.LNavigator.Query <> nil then
              ProtStrings(AQRepForm.LNavigator.Query.SQL);
          except
          end;
        end;
        if DoPrint then                                {wenn bis jetzt alles OK}
        try
          AQRepForm.SetPrinterFonts(PrinterFont);          {Druckerfonts setzen}
          WRep := AQRepForm.WRep;
          CompositeReport := AQRepForm.CompositeReport;
          if WRep <> nil then
          begin   //Ausdruck der Word Report Komponente
            WRep.DisableControls;
            WRep.RewriteTable;
            WRep.FillTable;
            if Preview then   {Bildschirm}
            begin
              WRep.Close;
              WRep.Open;
              WRep.EnableControls;
              AQRepForm.Show;
              GNavigator.PreviewForm := AQRepForm;
              AQRepForm.BringToFront;
              repeat
                Application.ProcessMessages;
              until GNavigator.GetQRepForm(QRepKurz) = nil;
              AQRepForm := nil;
            end else
            begin
              WRep.StartWord;
            end;
          end else
          if CompositeReport <> nil then
          begin     //Ausdruck eines zusammengesetzten Reports
            {if PrinterFont <> '' then             nur bei Quickrep möglich
              CompositeReport.Font.Name := PrinterFont;}
            if Preview then   {Bildschirm}
            begin
              CompositeReport.PrinterSettings.Copies := Kopien;
              try
                GNavigator.PreviewForm := AQRepForm;
                CompositeReport.Preview
              except on E:Exception do                  {hat Macken}
                begin
                  GNavigator.PreviewForm := nil;
                  ErrWarn(SPsrc_Kmp_007,[E.Message]); // 'Fehler bei CompositeReport:%s'
                end;
              end;
              Screen.Cursor := crDefault;
            end else {Drucker}
            begin
              CompositeReport.PrinterSettings.Copies := 1;
              for I:= 1 to Kopien do
              begin
                SMess(SPsrc_Kmp_008,[I,Kopien]); // 'Ausfertigung %d/%d wird gedruckt ...'
                try
                  CompositeReport.Print;
                except on E:Exception do                  {hat Macken}
                    Prot0('CompositeReport.Print:%s',[E.Message]);
                end;
              end;
            end;
          end else
          begin     //Ausdruck Standard
            QuickReport := AQRepForm.QuickReport; {Zuweisung}
            QuickReport.OnPreview := nil;  //25.02.13 DoPreview; vergl. TQRPrinter.Preview "else"
            if psSetCaption in Options then
              QuickReport.ReportTitle := Caption;         {040399 Display;}
            if psSetDisplay in Options then
              QuickReport.ReportTitle := Display;
            TestOutputBin(QuickReport); {Schacht zuweisen}
            {if PrinterFont <> '' then
              QuickReport.Font.Name := PrinterFont;  jetzt SetFont}
            OldQRepBeforePrint := QuickReport.BeforePrint;
            QuickReport.BeforePrint := NewQRepBeforePrint; {PrinterIndex}
            {old = X X = neu Umbiegen des Ereignisses}

            if psPageCount in Options then
            try
              QuickReport.Prepare;
              FPageCount := QuickReport.QRPRinter.PageCount;
            finally
              QuickReport.QRPrinter.Free;
              QuickReport.QRPrinter := nil;
            end;

            if ExportFile then {Export nach Datei - Mode}
            begin
              if assigned(FOnExportFile) then
                FOnExportFile(self, QuickReport) else
                Prot0('WARN %s.OnExportFile = nil', [OwnerDotName(self)]);
            end else
            if PreView then {Preview-Mode}
            begin
              QuickReport.PrinterSettings.Copies := Kopien;
              try
                GNavigator.PreviewForm := AQRepForm;
                QuickReport.Preview
              except on E:Exception do                  {hat Macken}
                begin
                  GNavigator.PreviewForm := nil;
                  {if DelphiRunning then  // 'Fehler bei Quickreport(%s)'
                    EMess(self, E, SPsrc_Kmp_009,[AQRepForm.ClassName]) else}
                    EProt(self, E, SPsrc_Kmp_009,[AQRepForm.ClassName]);
                end;
              end;
              Screen.Cursor := crDefault;
            end else {Drucken}
            begin
{$ifdef WIN32}
              QuickReport.PrinterSettings.Copies := Kopien;
              I:= Kopien;
{$else}
              QuickReport.PrinterSettings.Copies := 1; {auf 1 setzen}
              for I:= 1 to Kopien do    {work around QuickRep bug}
{$endif}
              if Kopien >= 1 then                       // Kopien=0 soll nicht drucken aber AfterPrn auslösen - 02.01.09
              begin
                SMess(SPsrc_Kmp_008,[I,Kopien]);	// 'Ausfertigung %d/%d wird gedruckt ...'
                try
                  QuickReport.Print;
                  {TestOutputBin(QuickReport);}
                except on E:Exception do                  {hat Macken}
                    //ProtM('%s'+CRLF+'Quickreport.Print',[E.Message]);
                    EMess(self, E, 'Quickreport.Print',[0]);  //bearbeitet auch BdeFreeDiskError 
                end;
              end;
            end;
          end;
        finally
          ErrKmp.Ignore := false;
        end;
      finally            {doch geschützt. Damit nach Exc nochmal startbar}
        { nicht geschützt, da bei QR-Abbruch evtl. noch Prieview da ist }
        if AQRepForm <> nil then {WRep}
        begin
          if SysParam.ProtBeforeOpen then
            Prot0('Releasing(%s)', [Display]);
          AQRepForm.Release; {Free für Formulare PostMessage}
          if SysParam.ProtBeforeOpen then
            Prot0('Released(%s)', [Display]);
        end;
        {while GNavigator.QrForms[QRepKurz] <> nil do   (nicht nötig}
        begin                            {wichtig wenn mehrmals hintereinander}
          GNavigator.ProcessMessages;   {das selbe Formular gestartet wird}
          {SMess('Warte bis Ausdruck geschlossen',[0]);}
          if SysParam.ProtBeforeOpen then
            Prot0('Processed(%s)', [Display]);
        end;
      end;
    finally
      if not KeepPrinter then
        SetDefaultPrinter(-1); {Standart Drucker wieder setzen}
      if SysParam.ProtBeforeOpen then
        Prot0('SetDefaultPrinter(%s)', ['OK']);
    end;
    Printing := false;  //auch hier für Ereignis - 15.05.07
    if assigned(FAfterPrn) then
      FAfterPrn(self);            {Aufruf hier nur wenn erfolgreich gedruckt}
  finally
    IncPrintCount(-1);
    SMess('',[0]);
    Printing := false;
    GNavigator.PreviewForm := nil;
    if assigned(FOnFinished) then
      FOnFinished(self);            {Aufruf hier immer wenn not Fertig (von FBeforePrn) }
  end;
end;

function TPrnSource.IsFiller: boolean;
begin
  Result := BeginsWith(Display, '-');
end;

function TPrnSource.GetLandscape: boolean;
var
  S, aKurz: string;
begin  //default = Portrait/ Hochformat
  Result := false;
  if Owner = nil then
    Exit;
  if FormGetLNav(Owner) <> nil then
    aKurz := FormGetLNav(Owner).FormKurz else
    aKurz := Owner.ClassName;
  S := StrDflt(Bemerkung.Values[SOrientation],
    IniKmp.ReadString(aKurz + '.' + self.Name, SOrientation, 'P'));  //Dflt=Hochformat/Portrait
  Result := S = 'L';
end;

procedure TPrnSource.SetLandscape(const Value: boolean);
var
  S, aKurz: string;
begin  //default = Portrait/ Hochformat
  if Value then
    S := 'L' else
    S := 'P';
  Bemerkung.Values[SOrientation] := S;

  if FormGetLNav(Owner) <> nil then
    aKurz := FormGetLNav(Owner).FormKurz else
    aKurz := Owner.ClassName;
  IniKmp.WriteString(aKurz + '.' + self.Name, SOrientation, S);  //für DfltRep u.a.
end;

procedure TPrnSource.SetPrinterAsDefault;
//Standarddrucker anhand Druckertyp setzen. Für externe Aufrufe ohne DoRun
var
  APrinterIndex: integer;                            {Bezug auf Windows-Drucker}
  PrinterFont: string;
begin
  APrinterIndex := SysParam.GetPrinterIndex(DruckerTyp, PrinterFont);    {N}
  SetDefaultPrinter(APrinterIndex);             {Als Standartdrucker setzen}
end;

function TPrnSource.GetFontSize: integer;
var
  aKurz: string;
begin  //default = von Form
  if FormGetLNav(Owner) <> nil then
    aKurz := FormGetLNav(Owner).FormKurz else
    aKurz := Owner.ClassName;
  Result := IntDflt(StrToIntTol(Bemerkung.Values[SFontSize]),
                    IniKmp.ReadInteger(aKurz + '.' + self.Name, SFontSize,
                                       TForm(Owner).Font.Size));    //try except
end;

procedure TPrnSource.SetFontSize(const Value: integer);
var
  aKurz: string;
begin
  Bemerkung.Values[SFontSize] := IntToStr(Value);
  if FormGetLNav(Owner) <> nil then
    aKurz := FormGetLNav(Owner).FormKurz else
    aKurz := Owner.ClassName;
  IniKmp.WriteInteger(aKurz + '.' + self.Name, SFontSize, Value);  //für DfltRep u.a.
end;

end.
