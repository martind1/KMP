unit Prots;
(* Protokoll verwalten: Globale Hilfsfunktionen und Konstanten (Hilfeindizes)

   Autor: Martin Dambach
   Letzte Änderung:
08.06.11 md  UNI, Delphi2010
22.12.11 md  AddStr statt AppendStr (AppendStr hat nur AnsiStr)
05.03.12 md  SetFieldValue: TrimRight
28.08.12 md  Unterstützung von Int64/LargeInt: CompFieldValue
03.10.13 md  AdjustFormatSettings
27.11.13 md  SetEdNum mit taRightJustify
   -------------------------------------
   - Protokolldatei error.dat

   Globale Funktionen:
   - MessageFmt
   - SMess
   - ErrWarn

*)

interface

uses
  Classes, Windows, Dialogs, DB,  Uni, DBAccess, MemDS, Forms, StdCtrls, Messages,
  ExtCtrls, Controls, Graphics, Grids, Character, SysUtils, Menus,
  UDB__KMP, UQue_Kmp,
  DPos_Kmp, CPro_Kmp, FaWa_Kmp;

const
  AmpelSpektrum9: array[1..9] of TColor = ($0000FF00,   //1:1
  {von grün bis rot}                       $0000FFC1,   //2:38
                                           $0000FFD5,   //3:42
                                           $0000FFEA,   //4:46
                                           $0000FFFF,   //5:50
                                           $0000EAFF,   //6:54
                                           $0000CBFF,   //7:60
                                           $000097FF,   //8:70
                                           $000000FF);  //9:99
const
  CRLF = #$D#$A; {HEX 'D' HEX 'A'}
  CR = #$D;      {HEX 'D' }
  LF = #$A;      {HEX 'A'}
  TAB = #$9;     {HEX '9' }

  HI_21 = 21;           {LuDefKmp:Wert nicht gefunden}
  HI_22 = 22;           {QNav:Keine Daten gefunden}
  HI_104 = 104;         {Suchkriterien}

const //Sections
  SRechteverwaltung = 'Rechteverwaltung';
  SSortierung = 'Sortierung';

  (* Ports für Winsocket:
  8	     QSBT Waageterminal Server
  10	   QSBT Einfahrtterminal Server
  12	   QSBT WAGO Schrankenserver (akt. am Waageterminal)
  12001  Fahrzeugwaage 1
  12002  Fahrzeugwaage 2
  12003  Fahrzeugwaage 3
  *)

  (* Windows Message Nummern: *)
  MSG_LOADAGAIN = 100001;                   {MsgNr für OnMsg Ereignis}
  MSG_VALUENOTFOUND = 100002;               {Wert nicht gefunden. Tabelle?}
  MSG_CONFIRMDELETE = 100003;               {Datensatz löschen ?}
  MSG_CONFIRMDELMARKED = 100004;            {markierte Datensätze löschen ?}

  CM_APP_PAGECHANGED    = WM_USER + 0;

  BC_BASIS = WM_USER + 100;                 {Broadcast Messages}
  BC_DATACHANGE = BC_BASIS + 0;
  {BC_CLOSE = BC_BASIS + 1;                  {LuDef: Dataset.Close (AutoOpen)  bisher: BEFOREINSERT}
  {BC_OPEN = BC_BASIS + 2;                   {LuDef: Dataset.Open (AutoOpen)  bisher: AFTERINSERT}
  BC_LOOKUPDEF = BC_BASIS + 1;              {LookUpDef: Diverse Funktionen:  bisher BC_CLOSE und BC_OPEN}
    ldOpen = 1;                             {  Open}
    ldCloseAll = 2;                         {  Close}
    ldCloseAuto = 3;                        {  Close nur bei AutoOpen}
    ldCancel = 4;                           {  DoCancel}
    ldDisable = 5;                          {  DisableControls}
    ldEnable = 6;                           {  EnableControls}
    ldDeleteDtl = 7;                        {  Delete Details}
    ldOpenAuto = 8;                         {  Open nur bei AutoOpen}
    ldFillColumnList = 9;                   {  Displayname anhand TLabels.FocusControl }
    ldReOpen = 10;                          {  Refresh (nach Mastersource.Post }
    ldSubRefresh = 11;                      {  Refresh (in AfterReturn }
  BC_STATECHANGE = BC_BASIS + 3;
  BC_CHECKREADONLY = BC_BASIS + 4;          {qForm:Checkreadonly}
  BC_POSTSTART = BC_BASIS + 5;              {LNav.OnPostStart}
  BC_SETPAGEINDEX = BC_BASIS + 6;           {LNav.SetPageIndex}
  BC_WINDOWPOS = BC_BASIS + 7;              {Pos für Waagenfenster}
  BC_LNAVIGATOR = BC_BASIS + 8;             {LNav: Diverse Funktionen:}
    lnavSetTitel = 1;                       {  SetTitel/OnSetTitel}
    lnavStartReturn = 2;                    {  Startreturn}
    lnavGotoDataPos = 3;                    {  DataPos.GotoPos(DataSet)}
    lnavSetTabs = 4;                        {  SetTabs}
  BC_EXPCHANGE = BC_BASIS + 9;              {Exp_Dlg}
  BC_GNAVCLICK = BC_BASIS + 10;             {Click auf Speedbar}
    {qnbQuery, qnbFirst, qnbPrior, qnbNext, qnbLast, qnbReadOnly, qnbInsert,
     qnbDelete, qnbEdit, qnbPost, qnbCancel, qnbRefresh}
    {Bsp: PostMessage(GNavigator.X.Handle, BC_GNAVCLICK, WPARAM(qnbQuery), 0);}
    gnOpen = 901;                           {Intern: nur Öffnen}
    gnEditingChanged = 902;                 {Intern: Qnav Button neu En/Disablen}
    gnProtA = 903;                          {Intern: ProtA ausführen}
  BC_STARTFORM = BC_BASIS + 11;             {GNavigator.Startform als Postmessage}
  BC_NEXTNULLCTL = BC_BASIS + 12;           {qForm:auf nächstes leeres Feld}
  BC_ENABLECONTROLS = BC_BASIS + 13;        {n.b. qForm.LNav.Dataset:EnableControls}
  BC_CANCLOSE = BC_BASIS + 14;              {MultiGrid:WriteColumns}
  BC_PAGECHANGE = BC_BASIS + 15;            {qForm: PageChange: DataSet.Active setzen}
  BC_CREATEWND = BC_BASIS + 16;             {qForm: CreateWnd - PostMessage}
  BC_MULTIGRID = BC_BASIS + 17;             {MultiGrid: allgemein}
     mgLoadKeyList = 1;                     {  Unterfunktion: Sortierung laden}
     mgSaveKeyList = 2;                     {  Unterfunktion: Sortierung speichern}
     mgLoadSelectedField = 3;               {  Unterfunktion: Spalte setzen}
     mgSaveSelectedField = 4;               {  Unterfunktion: Spalte merken}
     mgColorChanged = 5;                    {  Unterfunktion: Farbe geändert}
     mgSetRecCount = 6;                     {  Unterfunktion: Recordcount setzen}
     mgDataChanged = 7;                     {  Unterfunktion: intern}
     mgDisable = 8;                         {  Unterfunktion: Datasource=nil}
     mgEnable = 9;                          {  Unterfunktion: Datasource restaurieren}
     mgDragPoll = 10;                       {  Polling für Drag}
     mgCheckColor = 11;                     {  Unterfunktion: Farbe anpassen}
     mgAddSortList = 12;                    {  Unterfunktion: Liste für Sortierdialog erstellen}
     mgColDefChanged = 13;                  {  Unterfunktion: Spalteninfos neu erstellen}
     mgSaveLayout = 14;                     {  Unterfunktion: Layout speichern}
     mgSelectedRowsChanged = 15;            {  Unterfunktion: Anzahl Markierte Zeilen anzeigen}
     mgPopupClick = 16;                     {  Unterfunktion: Menüfunktion aufrufen}
     mgOptiWidth = 17;                      {  Unterfunktion: Optimale breite setzen}
     mgForceScrollBar = 18;                 {  Unterfunktion: Scrollbars anzeigen erzwingen (Delphi Bug)}
     mgAdjustColWidth = 19;                 {  TitleGrid: Spaltenbreiten anpassen}
  BC_LUGRID = BC_BASIS + 18;                {LuGrid: Einzelsicht}
     lgPageChange = 1;                      {  Unterfunktion: intern auf Single umschalten}
  BC_ZOOMTO100 = BC_BASIS + 19;             {Preview: ZoomTo100%}
     zoZoomTo100 = 1;                       {  Unterfunktion: ZoomTo100}
     zoZoomToFit = 2;                       {  Unterfunktion: ZoomToFit}
     zoZoomToWidth = 3;                     {  Unterfunktion: ZoomToWidth}
  BC_BTNDOWN = BC_BASIS + 20;               {CalcDlg: intern}
  BC_EXTGRIDSCR = BC_BASIS + 21;            {MultiGrid: SlideBar}
     egScrolled = 0;                        {  Unterfunktion: intern}
     egSetRecCount = 1;                     {  Unterfunktion: intern}
     egDataChanged = 2;                     {  Unterfunktion: intern}
     egEof1 = 3;
     egEof2 = 4;
     egEof3 = 5;
     egSetOptions = 6;
     egSetRowSize = 7;                      {Intern: Rowsize in LParam setzen}
     egUpdateScrollbar = 8;                 {Intern Tmb}
  BC_QFORM = BC_BASIS + 22;                 {TqForm: }
     qfCheckNonModal = 0;                   {  Unterfunktion: Nonmodale Fenster zeigen}
     qfCheckVScroll = 1;                    {  Unterfunktion: Fenstergröße}
  BC_REBOOT = BC_BASIS + 23;                {Reboot. Setzt GNavigator.CanReBoot auf false wenn kein Boot möglich}
  BC_INIDB = BC_BASIS + 24;                 {IniDb: }
     idProt = 0;                            {  Threadsicheres protokollieren}
  BC_STME = BC_BASIS + 25;                  {Stoermeldungen, qw\STMEFrm:}
     stmeDblClick = 0;                      {  Doppelklick auf Datensatz. LParam=Text}
  BC_EMAI_TABLE = BC_BASIS + 26;            {qw\EMail EMAI-Table aktivieren - 13.02.14 nicht verwendet}
     emaiOff = 0;                           {  ausschalten (WParam)}
     emaiOn = 1;                            {  einschalten (WParam)}
  BC_STMEDATA = BC_BASIS + 27;              {Stoermeldungen, qw\STMEFrm: alle Daten}
     stmeDetail = 1;                        {  Detail von Datensatz. LParam=TStmeData^}
  BC_STMEPOPUP = BC_BASIS + 28;             {Stoermeldungen, popup SH, WParam=Stme_Id}
  BC_FAWA = BC_BASIS + 29;                  {Rückmeldung Fawa (DwtEnq)}
     fwHoleStatus = 0;
     fwZeilendruck = 1;
  BC_FORMCREATE = BC_BASIS + 30;            {FrmPara.OnFormCreate(TWMBroadcast, aForm) n.b. }
  BC_PREPAREENTER = BC_BASIS + 31;          {für nl.EnterValue/LuEdi }
  BC_ONLYOPENONCE = BC_BASIS + 32;          {Parameter von Aufruf via OnlyOpenOnce }


  BC_USER1 = BC_BASIS + 91;                 {frei für Anwendung}
  BC_USER2 = BC_BASIS + 92;                 {frei für Anwendung}
  BC_USER3 = BC_BASIS + 93;                 {frei für Anwendung}
  BC_USER = BC_BASIS + 100;                 {Start für Anwendungs Messages}

  (* Tag Bits                        Bit Bedeutung              Ort  : für qwf_form.FormResizeStd *)
  TAG_QREP_FONT1 = 1;               {0   QRep Schriftart 1      QREP_FORM}
  TAG_QREP_FONT2 = 2;               {1   QRep Schriftart 2      }
  TAG_QREP_FONT3 = 4;               {2   QRep Schriftart 3      }
  TAG_QREP_FONT4 = 8;               {3   QRep Schriftart 4      }
  TAG_QREP_FONT5 = 16;              {4   QRep Schriftart 5      }
  TAG_RESIZE_WIDTH_8 = 32;          {5   Resize Width 8         SDBL.Para}
  TAG_RESIZE_HEIGHT_8 = 64;         {6   "}
  TAG_RESIZE_WIDTH_20 = 128;        {7   "}
  TAG_RESIZE_HEIGHT_20 = 256;       {8   "}
  TAG_RESIZE_WIDTH_32  = 512;       {9   }
  TAG_RESIZE_BOTTOM    = 1024;      {10  für Panels. Top bleibt. Resize Width&Height}
  TAG_RESIZE_WIDTH_0   = 2048;      {11  Resize Width 0         SDBL.Para}
  TAG_RESIZE_HEIGHT_0  = 4096;      {12  Resize Height 0        LAWA.Frzg}
  TAG_UNUSED_13        = 8112;      {13   }
  TAG_UNUSED_14        = 16384;     {14   }
  TAG_UNUSED_15        = 32768;     {15   }
  TAG_UNUSED_16        = 65536;     {16   }
  TAG_UNUSED_17        = 131072;    {17   }
  TAG_UNUSED_18        = 262144;    {18   }
  TAG_UNUSED_19        = 524288;    {19   }
  TAG_UNUSED_20        = 1048576;   {20   }
  TAG_UNUSED_21        = 2097152;   {21   }
  TAG_UNUSED_22        = 4194304;   {22   }
  TAG_UNUSED_23        = 8388608;   {23   }
  TAG_UNUSED_24        = 16277216;  {24   }
  TAG_UNUSED_25        = 33554432;  {25   }
  TAG_UNUSED_26        = 67108864;  {26   }
  TAG_UNUSED_27        = 134217728; {27   }
  TAG_UNUSED_28        = 268435456; {28   }
  TAG_UNUSED_29        = 536870912; {29   }
  TAG_UNUSED_30        = 1073741824;{30   }
  TAG_UNUSED_31        = 2147483648;{31   }

  (* Tag Bits HEX                    Bit Bedeutung              Ort
  TAG_QREP_FONT1 = 1;               {0   QRep Schriftart 1      QREP_FORM}
  TAG_QREP_FONT2 = 2;               {1   QRep Schriftart 2      }
  TAG_QREP_FONT3 = 4;               {2   QRep Schriftart 3      }
  TAG_QREP_FONT4 = 8;               {3   QRep Schriftart 4      }
  TAG_QREP_FONT5 = $10;              {4   QRep Schriftart 5      }
  TAG_RESIZE_WIDTH_8 = $20;          {5   Resize Width 8         SDBL.Para}
  TAG_RESIZE_HEIGHT_8 = $40;         {6   "}
  TAG_RESIZE_WIDTH_20 = $80;        {7   "}
  TAG_RESIZE_HEIGHT_20 = $100;       {8   "}
  TAG_RESIZE_WIDTH_32  = $200;       {9   }
  TAG_RESIZE_BOTTOM    = $400;      {10  für Panels. Top bleibt. Resize Width&Height}
  TAG_RESIZE_WIDTH_0   = $800;      {11  Resize Width 0         SDBL.Para}
  TAG_UNUSED_12        = $1000;     {12   }
  TAG_UNUSED_13        = $2000;     {13   }
  TAG_UNUSED_14        = $4000;     {14   }
  TAG_UNUSED_15        = $8000;     {15   }
  TAG_UNUSED_16        = $10000;    {16   }
  TAG_UNUSED_17        = $20000;    {17   }
  TAG_UNUSED_18        = $40000;    {18   }
  TAG_UNUSED_19        = $80000;    {19   }
  TAG_UNUSED_20        = $100000;   {20   }
  TAG_UNUSED_21        = $200000;   {21   }
  TAG_UNUSED_22        = $400000;   {22   }
  TAG_UNUSED_23        = $800000;   {23   }
  TAG_UNUSED_24        = $1000000;  {24   }
  TAG_UNUSED_25        = $2000000;  {25   }
  TAG_UNUSED_26        = $4000000;  {26   }
  TAG_UNUSED_27        = $8000000;  {27   }
  TAG_UNUSED_28        = $10000000; {28   }
  TAG_UNUSED_29        = $20000000; {29   }
  TAG_UNUSED_30        = $40000000; {30   }
  TAG_UNUSED_31        = $80000000; {31   nicht als Tag eingebbar da dort signed} *)



type
  TComponentRef = class of TComponent;  {Referenz auf eine Klasse
  Beispiel
  MyCompRef : TComponentRef
  MyCompRef := TPanel;
  Verwendung in Broadcast Message
  }
  PHWND = ^HWND;  {Pointer auf Windows-Handle}
  string20 = string[20];
  TSGN = -1..1;  {ShortInt;             {Typ für SGN (Vorzeichen) Funktion}
  TCompare = (compMinor, compMaior, compEqal, compNull, compNull1, compNull2);
  TCompareSet = set of TCompare;


  TWMBroadcast = record  {Typ für Parameterübergabe an Broadcastmessage}
    Msg: cardinal;	{ Botschafts-ID (TMsgParam) }
    Data: longint;      { wParam (war 'Word' bis 20.07.03) }
    Sender: TComponent; { lParam }
    Result: longint;	{ und schließlich das Ergebnisfeld }
  end;

  TProtModus = (prTrm,         {Ausgabe in ListBox}
                prFile,        {Ausgabe in Protokolldatei}
                prRemain,      {Zeilenwechsel in Listbox unterdrücken}
                prTimeStamp,   {mit Protokolierung von Timestamp}
                prMsg,         {Ausgabe als Dialogbox}
                prList,        {Ausgabe in Listbox}
                prDatabase,    {Ausgabe in DB Tabelle}
                prWarn,        {i.V.m. prMsg: 'Warnung'   (WMess: 'Information'}
                prErr,         {i.V.m. WMessErr: 'Error'}
                prSMess,       {Ausgabe in Statuszeile}
                prNoLbStamp,   {In Listbox kein Timestamp, PC Nr}
                prNoLbFocus);  {In Listbox auch bei Focus auffüllen}
  TProtModusSet = set of TProtModus; {Menge von TProtModus-Elementen}

  TErrorTyp = (erProt,         {erProt = Fehler in Protokolldatei}
               erMsg,          {erMsg = Fehler als Dialogbox}
               erStatus,       {erStatus = Fehler in die Statuszeile}
               erAbort);       {erAbort = Fatalerfehler Programmabbruch}

  (* TSysParam - Systemweite Daten *)
  TSysParam = class(TObject)
  private
    FProtBeforeOpen: boolean;  {Debug protokolierung aktivieren}
    FDrucker: TValueList;      {Liste aller Verfügbaren Druckertypen
                                Name=Index (Drucker in der INI-Datei)}
    procedure SetProtBeforeOpen(const Value: boolean);
    procedure SetBatchMode(const Value: boolean);
    function GetDrucker: TValueList;
  public
    UserName: string; {Eingelogter Bediener}
    PcNr: string;     {PC-Nummer von Enviroment-Variable}
    WerkNr: string;   {Werk-Nummer von Enviroment-Variable}
    Abteilung: string;{Abteilung-Nummer von Enviroment-Variable}
    PassWord: string; {Passwort}
    DbUserName: string;       {in der DB angemeldeter Username}
    DbPassword: string;       {in der DB angemeldeter Username}
    ApplicationName: string;  {Titel des Hauptfensters}    {Wand}
    ApplicationId: longint;   {IdentNummer der Anwendung in Rechteverwaltung}
    Alias: string;            {Datenbankalias}
    ServerName: string;       {BDE Parameter 'SERVER NAME'}
    DatabaseName: string;     {BDE Parameter 'DATABASE NAME', nur MSSQL}
    DB1: TuDatabase;           {Datenbank mit DatabaseName='DB1'}
    Db1Params: TStrings;      {Parameter der Datenbank mit DatabaseName='DB1'}
    UseDuplDb: boolean;       //true=mehrfache DB-Verbindungen verwenden für RecordCount und IniDb um fetch-all zu vermeiden
    NewBeforeOpenCount: integer;
    ErrNr: integer;           {Globale Fehler-Nummer}
    ErrTimeout: integer;      {Wartezeit bis ErrKmp-Fenster automatisch verschwindet}
    DisplayWinExecError: boolean;  {true=Fehler bei WinExec/ShellExec anzeigen}
    ThrowWinExecError: boolean;    {true=bei Fehler Exception auslösen}
    fBatchMode: boolean;        {true = ohne Bedienereingaben}
    ConfirmDelete: boolean;    {true = bei Löschen immer nachfragen auch wenn lokal deaktivierrt}
    AugeAutoEdit: boolean;     {true = 'Auge' im QNav ändert DataSource.AutoEdit. Sonst: RequestLive}
    ReadOnly: boolean;         {Globales ReadOnly auf Datenbank}
    OraUnicodeBug: boolean;    {Oracle Unicode: ergibt 3fache Länge bei CHAR/VARCHAR2}
    TabsBelegung: integer;     //0=Standard 1=OK/Abbruch

    Sprache: string;           {GUI-Sprache. für Übersetzung, Spaltenbez. in INI}
    MonthDateFormat: string;   {Datumformat Monat und Jahr mm/yyyy}
    FirstDayOfMonth: integer;  {1.Tag im Buchungsmonat}
    WE: string;                {Währungseinheit}
    EuroFaktor: double;        {Euro = DM * EuroFaktor}
    NkCheck: boolean;          {true:mit Nachkommat anhand Format anpassen}
    PollIdle: boolean;         {true:Polling während WMess}
    SlideBar: boolean;         {true:dynamische ScrollBars in MultiGrid}
    MuResize: boolean;         {true:Breite letzte Spalte wird angepasste bei MultiGrid}
    SavePosition: boolean;     {true:Fensterposition merken (LNav.lnSavePosition)}
    GridSavePos: boolean;      {true:Fensterposition auch in LuGrid merken}
    SoftDelete: boolean;       {true:DeleteAll nicht mit SQL.
                               {     DeleteDetails=false:Felder statt löschen auf null setzen}
    CRChar: char;              {MuGrid: Ersetzung von CRLF. kann z.B. auf Blank gesetzt werden}
    TakeReturn: boolean;       {true=Schließen nach 'Übernehmen' bei N:M Lookup}
    UseKeyPressKey: boolean;   {IBase/GHS: MuGrid: KeyPress Key senden}
    AllowEditReadOnly: boolean;{true:MultiGrid-Spalte änderbar trotz DbEdit.ReadOnly}
    MuDrawingStyle: TGridDrawingStyle;  //Delphi XE: gdsThemed ist schlecht. Hier:Dflt=gdsClassic (blau)
    LuEdiNoDblClick: boolean;  {true:Doppelklick bewirkt kein LookUp in LookupEditFeldern}  
    UseVersion: boolean;       {true:RC Version statt Timestamp der EXE verwenden}

    AliveTime: longint;         {Zeitintervall [ms] für Alive Meldung (0=kein Alive)}
    AliveFile: string;          {File für Alive Meldung. Dflt = IniKmp.FilePath}
    RecordCount: integer;       //Anzahl verarbeitete Datensätze für Starter

    Informix: boolean;
    Oracle: boolean;
    InterBase: boolean;
    MSSQL: boolean;
    Paradox: boolean;
    Standard: boolean;          {=Paradox Datenbank}
    Odbc: boolean;              {=ODBC Treiber}
    Access: boolean;            {SQL versteht UPPER nicht:UCASE (Access 2.0)}
    NoDB: boolean;              //wenn true werden keine DB-Connects durchgeführt
    SessionId: double;
    SqlDatum: string;          {Formatangabe für SQL Generierung}
    DbSqlDatum: string;        {Festes Datumsformat für SQL, z.B. für Oracle}
    SqlNoLikeLive: boolean;    {SQL: LIKE nicht bei RequestLive}
    SqlIsCaseSensitiv: boolean;{SQL: Datenbank unterscheidet Groß/Klein beim suchen}
    NoDeleteDetails: boolean;  {LuDef.DeleteDetails Flag nicht zum harten Löschen verwenden. Gen.RefIntegr}
    //TblPrefix: string;       {MSSQL:dbo voransetzen um Indexinfos zu erhalten - jetzt in TuDatabase - 25.11.06}
    MaxSqlLine: integer;       {Max.Länge einer SQL Zeile (250)}
    FetchAll: string;          //Unidac.SpecificOptions: ''=DB-Default oder 'False' oder 'True'

    FaxPrefix: string;         {Dial-Prefix für Faxausgabe}
    SetIniChange: boolean;     {true=Message an alle Fenster dass WIN.INI geändert}

    (* Intern *)
    FormsInFrame: boolean;    {Können nicht aus dem Hauptfenste verschoben werden}
    FormsSizeable: boolean;   {Größe kann verändert werden}
    ProtPrint: boolean;       {Ausdrucke protokolieren (dflt=true ab 19.08.10}
    Preview: boolean;         {Zum Test Formulardruck}
    DfltRepFramed: boolean;   {Standard Liste mit Raster drucken}
    DfltRepLined: boolean;    {Standard Liste mit Trennlinien drucken}
    PrintLineNr: boolean;     {true:Zeile als erste Spalte in DfltRep drucken}
    Delay: longint;           {Verzögerung beim Öffnen in ms}
    ComProtDelay: longint;    {Verzögerung bei Kommunikations-Aufzeichnung in ms}
    NoErrWarn: boolean;
    OurLNav: TComponent;       {Debug-Zwecke}
    OurKurz: string;           {Debug-Zwecke}
    OurLookUpEdit: string;     {Debug-Zwecke}
    GotoPosLoaded: boolean;    {Flag}
    FGotoPos: boolean;         {Wert}
    InReplace: boolean;        {true = ReplaceDlg ändert Datensatz (kein Lookup)}
    StartKey, MultKey, AddKey: integer;  {für Encryption}

    constructor Create;        {eigener Konstruktor}
    destructor Destroy; override;
    function GotoPos: boolean;
    function GetPrinterIndex(DruckerTyp: string; var APrinterFont: string): integer;
    {Gibt Druckerindex und Printerfont (wenn vorhanden) anhand vom Druckertyp}
    procedure SetPrinterIndex(DruckerTyp: string; APrinterIndex: integer;
      APrinterFont: string); {Setzt Index zum Druckertyp in .INI}
    procedure ClearDrucker;  //löscht Druckerliste (lazy loading)
    property Drucker: TValueList read GetDrucker;
    property ProtBeforeOpen: boolean read FProtBeforeOpen write SetProtBeforeOpen;
    property BatchMode: boolean read fBatchMode write SetBatchMode;
  end;


  (* TProt - Klasse zum Protokolieren
             Wird geladen über die Form auf der sie plaziert ist *)
  TProt = class(TComponent)
  private
    FFileName: string;   {Name der protokolldatei}
    FListBox: TListBox;  {Verweis auf eine Listbox zum Schreiben}
    FMaxCount: integer;  {Maximale Zeilenzahl}
    FDataSet: TDataSet;  {Zieldatei in Form von Datenbanktabelle}
    InternalLoeschFlag: boolean;  {Internes Flag ob neuer Zyklus beginnt}
    function GetFilePath: string;
    procedure SetListBox(Value: TListBox);
    function GetListBox: TListBox;
    procedure SetFileName(const Value: string);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    ProtFile: TextFile;  {Textdateivariable}
    Remain: boolean;     {Intern Status für Listbox zum Erkennen von Zeilenwechsel}
    LoeschFlag: boolean; {Flag ob Protfile neu anzulegen}
    DbIgnore: boolean;   {Datenbankfehler ignorieren}
    Msg: string;         {aktuelle Ausgabe}
    procedure Edit;      {Logfile editieren}
    procedure EditAll;   {anderes Logfile editieren}
    property FilePath: string read GetFilePath;        {Pfad der protokolldatei}
    {Zugriff auf FFilePath}
    procedure X(modus: TProtModusSet; const Fmt: string; const Args: array of const);
    {Allgemeine Funktion}
    procedure X_Unique(modus: TProtModusSet; N: integer; L: TStrings;
      const Fmt: string; const Args: array of const);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published    {Objectinspektor Schnittstelle}
    property FileName: string read FFileName write SetFileName;
    property ListBox: TListBox read GetListBox write SetListBox;
    property MaxCount: integer read FMaxCount write FMaxCount;
    property DataSet: TDataSet read FDataSet write FDataSet;
  end;

(* globale Typen: *)
type
  TSelection = record                  {von VCL.StdCtrls, dort private}
    StartPos, EndPos: Integer;
  end;

  TPlusMinus = (pmPlus, pmMinus);

  TOpSys = (osWIN, osUNIX, osMAC);    //für ConvertEOL

type
  TExportCsvOption = (ecUtf8, ecBOM);
  TExportCsvOptions = set of TExportCsvOption;

type
  TQueryTextOption = (qtoOneLine, qtoStripFields);
  TQueryTextOptions = set of TQueryTextOption;
const
  qtoShort: TQueryTextOptions = [qtoOneLine, qtoStripFields];

(* globale Protokoll-Prozeduren: *)

procedure Prot0(const Fmt: string; const Args: array of const);
{In Protokolldatei schreiben mit Datum Zeit Angabe}
procedure Prot0_Unique(N: integer; L: TStrings;
  const Fmt: string; const Args: array of const);
{Prot0 aber nur wenn Text <> der letzten N Texte }
procedure Prot0_D(const Fmt: string; const Args: array of const);
procedure ProtLb0(Lb: TListbox; const Fmt: string; const Args: array of const);
{In Listbox schreiben mit Datum Zeit Angabe}
procedure ProtA_D(const Fmt: string; const Args: array of const);
//ProtA nur wenn im Debug-Mode
procedure ProtA(const Fmt: string; const Args: array of const);
{In Protokolldatei schreiben ohne Datum Zeit Angabe}
procedure ProtP(const Fmt: string; const Args: array of const);
{in Listbox ausgeben mit Zeilenvorschub}
procedure ProtP0(const Fmt: string; const Args: array of const);
{in Listbox mit Timestamp ausgeben mit Zeilenvorschub}
procedure ProtDB(const Fmt: string; const Args: array of const);
{In die Datenbank schreiben}
procedure ProtR(const Fmt: string; const Args: array of const);
{in Listbox ausgeben ohne Zeilenvorschub}
procedure ProtM(const Fmt: string; const Args: array of const);
{in Protokolldateischreiben als Messagebox ausgeben}
procedure ProtL(const Fmt: string; const Args: array of const);
{in Protokolldatei schreiben und Statuszeile}
procedure ProtLA(const Fmt: string; const Args: array of const);
{in Protokolldatei ohne Timestamp schreiben und Statuszeile}
procedure ProtLD(const Fmt: string; const Args: array of const);
{in Protokolldatei schreiben und DMess-Statuszeile}
procedure ProtRL(const Fmt: string; const Args: array of const);
{in Listbox und Statuszeile ausgeben ohne Zeilenvorschub}
procedure ProtStrings(Strings: TStrings; aCaption: string = '');
{Protokolliert Strings}
function QueryText(ADataSet: TDataSet; Options: TQueryTextOptions = []): string;
{ergibt AQuery.Text, dabei werden :Parameter in Werte umgewandelt}
procedure ProtSql(AQuery: TDataSet);
{Protokolliert SQL. Dabei werden :Parameter in Werte umgewandelt}
procedure ParamSetNull(AParam: TParam; aDataType: TFieldType = ftString);
{setzt einen SQL Query Parameter auf null und DataType }
function ComponentLogName(AComponent: TComponent): string;
//ergibt eindeutigen Komponenten-Bezeichner
function OwnerDotName(AComponent: TObject): string;
//ergibt Owner.Name der Komponente (für Protokollierung)
function OwnerClassDotName(AComponent: TObject): string;
//ergibt OwnerClass.Name der Komponente (für Gen)
procedure ProtDataSet(ADataSet: TDataSet);
{Protokolliert die Feldinhalte eines DataSet}
procedure ProtStoredProc(AStoredProc: TUniStoredProc);
{Protokolliert die Parameter einer Stored Proc}
procedure StringsFromFile(Strings: TStrings; const AFileName: string);
{wie LoadFromFile aber ohne Memory Leak}
function MessageFmt(const Fmt: string; const Args: array of const;
                     AType: TMsgDlgType; AButtons: TMsgDlgButtons;
                     HelpCtx: Longint): Word;
{Erweiterung von MessageDlg um Formatierung}
procedure SMess(const Fmt: string; const Args: array of const);
{Ausgabe auf Statuszeile}
procedure SMess0;
procedure DMess0;
procedure HMess0;
procedure GMess0;
{keine Ausgabe auf Statuszeile}
procedure Debug(const Fmt: string; const Args: array of const);
procedure Debug0;
procedure SDebg(const Fmt: string; const Args: array of const);
{Protokollieren nur im Debugmode}
procedure DMess(const Fmt: string; const Args: array of const);
{Ausgabe auf Dialogzeile bzw Statuszeile}
procedure DMessT1(const Fmt: string; const Args: array of const);
{Ausgabe auf Dialogzeile wir erst nach 5s von SMess überschrieben}
procedure HMess(const Fmt: string; const Args: array of const);
{Ausgabe auf Hilfezeile bzw Statuszeile}
procedure GMess(AProgress: integer);
{Ansprechen der Gauge vom GNav}
procedure GMessA(Anteil, Gesamt: longint);
{Ansprechen der Gauge vom GNav: Anteil / Gesamt * 100}
procedure WMess(const Fmt: string; const Args: array of const);
{Erweiterung von MessageDlg um Formatierung}
procedure WMessWarn(const Fmt: string; const Args: array of const);
{Erweiterung von MessageDlg:mtWarning um Formatierung}
procedure WMessErr(const Fmt: string; const Args: array of const);
{Erweiterung von MessageDlg:mtError um Formatierung}
function WMessYesNo(const Fmt: string; const Args: array of const): Word;
{Erweiterung von MessageDlg (Yes No Cancel) um Formatierung}
function WMessOkCancel(const Fmt: string; const Args: array of const): Word;  //ergibt mrOK oder mrCancel
function WMessInput(const ACaption, APrompt: string; var Value: string): Boolean;  //Eingabe Aufforderung
function WMessPassword(const ACaption, APrompt: string; var Value: string): Boolean; //Passwort Eingabe Aufforderung
function mrToStr(mr: Word): string;   //MessageResultToString
procedure ErrWarn(const Fmt: string; const Args: array of const);
{Anzeige in einer Dialogbox und Protokollierung des Textes}

(* globale Hilfsfunktionen: *)
function MinValueIdx(const Data: array of Double; var Idx : Integer): Double;
function MaxValueIdx(const Data: array of Double; var Idx : Integer): Double;
function Even(I: longint): boolean;
function Quersumme(I: integer): integer;
function IMin(I1, I2: longint): longint;
function IMax(I1, I2: longint): longint;
function FloatMin(F1, F2: Extended): Extended;
function FloatMax(F1, F2: Extended): Extended;
function FloatDflt(F, Dflt: Extended): Extended; //ergibt Dflt wenn F=0
function IntDflt(F, Dflt: Integer): Integer;     //ergibt Dflt wenn F=0
function Div0(Z, N: Extended): Extended;
(* sicheres Div,/.  Nenner kann 0 sein *)
function DivDef(Z, N, Dflt: Extended): Extended;
(* sicheres Div,/.  Wenn Nenner = 0 dann Result = Dflt *)
function MaxQuotient(Div1, Div2: Extended): Extended;
{ergibt Maximum von Div1/Div2 und Div2/Div1. Also >=1 wenn OK, sonst 0}
function IntDiv0(Z: Int64; N: Integer): Integer;
(* sicheres Integer Div.  Nenner kann 0 sein *)
function IntDivDef(Z: Int64; N, Dflt: Integer): Integer;
(* sicheres Integer Div.  Wenn Nenner = 0 dann Result = Dflt *)
function EvalExpression(Strg: string; var Error: Boolean; var ErrPos: integer): Extended;
//wertet numerische Ausdrücke aus idF 3*(8+2)/4 oder sin(12)
function FillTemplate(SL: TStrings; aFilename: string; SetBlank: boolean = true): string;
// Lädt Templatefile und ersetzt #Platzhalter. Ergibt String mit den Ergebniszeilen.
function GetDetailFieldValues(ADataSet: TDataSet; AFieldName, ATrenner: string;
  aPre: string = ''; aPost: string = ''): string;
// ergibt String der Feldwerte des Felds <ADataSet.AFieldName> mit <>Trenner> getrennt
function GetDetailFieldFkt(ADataSet: TDataSet; AFieldName, AFkt: string): Double;
// ergibt Summe oder AVG der Feldwerte des Felds <ADataSet.AFieldName>
procedure ExportCsv(aNL: TObject; Filename: string; ColNameStr: string; Options: TExportCsvOptions);
//Schreibt CSV Datei mit allen Zeilen von aNL und den Spalten anhand ColNameStr.
function ParseTables(S, S1, S2: string; Tables: array of TDataSet): string;
// ersetzt Text mit Platzhalter durch Feldinhalte in mehreren Tabellen
function CreatePath(APath: string): boolean;
(* entspr. CreateDir aber mit bel. verschachtelten Verzeichnissen (c:\a\b\c) *)
function CreateUniqueFileName(Maske: string): string;
//erzeugt leere Datei mit eindeutigem Namen. ergibt vollst. Dateinamen
//Maske-Platzhalter: #Y,#M,#D,#H,#N,#S = Jahr,Monat,Tag,Stunde,Minute,Sekunde
//                   #C = Counter (wird von 1 bis MaxInt hochgezählt bis Erfolg)
function ValidDir(S: string): string; {ergibt Verzeichnis mit endendem '\'}
function PartDir(S: string): string;  //ergibt Verzeichnis ohne Ende '\'
function EncodeEnvDir(S: string): string;  //Kodiert Pfad mit (längster) Environment-Variablen (%TEMP%, %APPDATA%, usw.) und %APPDIR%
function DecodeEnvDir(S: string): string;  //Dekodiert Environment-Variable (und %APPDIR%) mit tatsächlichem Wert
function WinDir: string; {Pfad von Windows incl. \ }
function WinSysDir: String; {Pfad von Windows\System32 incl. \ }
function IsWindowsNT: boolean; {true=ab WinNT false=Win95}
function IsWindows2000: boolean;  //true=ab Win2k
function CtrlKeyDown: boolean;  // Strg-Taste ist gedrückt
function ShiftKeyDown: boolean;  // Umschalt-Taste ist gedrückt
function ProgDir: string; {Pfad von c:\programme\ }
function TempDir: string; {Pfad von Temporärem Verzeichnis (TMP, TEMP) incl. \ }
function AllUsersDir: string;  //%ALLUSERSPROFILE%
function AppParam(Param: string): string;  // ergibt Wert von Kommandozeile Parameter
function AppDir: string; {Pfad des EXE-Files. Sucht in Kommandozeile nach AppDir=}
function AppDate: TDateTime; {DateTime des EXE-Files}
function AppVersion: string;  // Version des EXE-Files idF 6.23.1.0
function CompareVersion(Ver1, Ver2: string): integer; // Vergleicht 2 Versionsstring. Ergibt -1:Ver1<Ver2 0:Ver2=Ver2 1:Ver1>Ver2
function AppInternalName: string;  // Internal Name des EXE-Files
function ShortVersion(S: string): string; //ergibt verkürzte Versionsdarstellung (0er bei Build und Ausgabe am Ende Weg)
function CompName: string;   {Computer Name}
function CompUserName: string; {Computer User Name}
function GetIPAddress: string;  //eigene IP Adresse (von Windows Sockets DLL)
function GetMACAddress: string; //ergibt die (eindeutige) Nummer der Netzwerkkarte
function CheckUserAccount(Username, Password, Domain: string;
  var Reason: string): boolean;  //true=Windows Passwort OK
function GetEnvStr(VarName : string ) : string; {Umgebungsvariable holen}
function GetEnvStrings: TStrings;  {Alle Umgebungsvariable holen und nach Strings schreiben. Mit Cache. Mit AppDir}
function DiskFreeBde(RootPath: string): Int64;  // ergibt Anzahl freier Bytes aus BDE-Sicht, ist <4GB. RootPath: 'C:\', 'D:\', usw.
procedure FillDiskBde(AFillDir: string);  //Bde Trick
function DirExists(ADir: string): boolean; (* ergibt true wenn Verzeichnis existiert *)
function FileFound(Mask: string; var FileName: string): boolean; //true=FileName wurde gefunden
function GraphicFileFound(aName: string; var FileName: string): boolean;  //Sucht Bilddatei
procedure LoadBitmapFromGraphicStream(aStream: TStream; aBitmap: TBitmap);
function ZoomOutBitmap(aBitmap: TBitmap; var ToWidth, ToHeight: integer): TBitmap; //verkleinert Bitmap (Seitenverhältnis bleibt) auf die angegebene Größe. ergibt neues Bitmap (muss freigegeben werden)
procedure ImageLoadOutZoomed(aImage: TImage; aFilename: string); //Lädt Bitmap so dass verkleinert wird aber das Seitenverhältnis bleibt.
function StrToOem(S: string): string;  (* Ergibt Oem String anhand Ansi-String S *)
function StrToAnsi(S: string): string;  (* Ergibt Ansi String anhand Oem-String S *)
function StrToWideString(const S: AnsiString; const CodecAlias: string): WideString; overload; //UTF8 anhand Ansi
function StrToWideString(const S: AnsiString; const Codepage: integer): WideString; overload;
function StrToHtml(S: string): string;
(* Ergibt Html String mit umgewandelten Umlauten *)
function HtmlToText(const _html: string): string;
//wandelt HTML in Text um
function ConvertEOL(Src: string; OpSys: TOpSys = osWIN): string;
//Konvertiert einen mehrzeiligen string die Zeilentrenner bzgl. Betriebssystem
procedure ReadlnOem(var F: TextFile; var S: string);
(* Liest Zeile, konvertiert von Oem nach Ansi, nach S *)
procedure WriteOem(var F: TextFile; const Fmt: string; const Args: array of const);
(* Schreibt Formatiert auf Textfile mit OEM Zeichen-Umwandlung *)
procedure WriteFmt(var F: TextFile; const Fmt: string; const Args: array of const);
(* Schreibt Formatiert auf Textfile *)
function StmWrite(Stm: TStream; const AString: string): longint;  //Schreibt String nach Stream
function StmWriteLn(Stm: TStream; const AString: string): longint;  //Schreibt String und Zeilenumbruch nach Stream
function StmWriteFmt(Stm: TStream; const Fmt: string; const Args: array of const): longint;  //Schreibt FormatString nach Stream
function StmWriteLnFmt(Stm: TStream; const Fmt: string; const Args: array of const): longint;  //Schreibt FormatString und Zeilenumbruch nach Stream

procedure AddStr(var Dest: string; const S: string);
{wie AppendStr aber ohne Leak}
procedure InsertStr(Source: string; var S: string; Index: Integer);
{besserer Ersatz für System.Insert für index > length}
procedure AppendTok(var Dest: string; const Tok, Trenner: string);
{ergänzt Dest mit Tok, getrennt mit Trenner}
function AppendUniqueTok(var Dest: string; const Tok, Trenner: string;
  IgnoreCase: boolean): boolean; {ergänzt Dest mit Tok. Aber nur wenn Tok nicht vorhanden}
function GetAppendTok(const Dest: string; const Tok, Trenner: string): string;
{wie AppendTok aber ohne Änderung des Quellstrings. Für Properties}
function GetAppendUniqueTok(const Dest: string; const Tok, Trenner: string;
  IgnoreCase: boolean): string; {wie AppendUniqueTok aber ohne Änderung des Quellstrings. Für Properties}
procedure DeleteTok(var Dest: string; const Tok, Trenner: string;
  IgnoreCase: boolean); {löscht Tok in Desk wenn vorhanden}
function PStrTok(S: string; DivToks: array of string; var NextS: string;
  doTrim: boolean = false): string; overload;
{Token holen. Trenner ist beliebiger String in DivToks}
function PStrTok(S: string; DivChars: string; var NextS: string; doTrim: boolean = false): string; overload;
{Token holen. Trenner ist beliebiges Zeichen in DivChars}
function PStrTok(S: string; DivCharSet: TSysCharSet; var NextS: string; doTrim: boolean = false): string; overload;
{Token holen. Trenner sind Zeichen in TSysCharSet}
//Ansi Version
function PStrTok(S: AnsiString; DivChars: AnsiString; var NextS: AnsiString; doTrim: boolean = false): AnsiString; overload;
function PStrTokNext(DivChars: string; var NextS: string; doTrim: boolean = false): string; overload;
function PStrTokNext(DivToks: array of string; var NextS: string; doTrim: boolean = false): string; overload;
function StrTok(S, DivChars: PAnsiChar; var NextStr: PAnsiChar): PAnsiChar; overload;
function StrTok(S, DivChars: PWideChar; var NextStr: PWideChar): PWideChar; overload;
{Token holen bei Delimiter (mit PAnsiChar)}
function IndexOfToken(AToken, S, DivChars: string; IgnoreCase: boolean = false): integer;
// ergibt Index des Tokens <AToken> in String mit mehreren Tokens mit <DivChars> getrennt
function TokenAt(S: string; DivChars: string; AtPos: integer): string;
// Ergibt Token an der Position <AtPos> (ab 1 gezählt) oder ''
function TokenCount(S: string; DivChars: string): integer;
// Ergibt Anzahl der Tokens
procedure StrTokenize(S: string; DivCharSet: TSysCharSet; SL: TStrings;
  IncludeTrenner: boolean; doTrim: boolean = false); //ergänzt SL mit den Tokens in S.
procedure StrDelete(Str: PAnsiChar; Index, Count:Integer); overload;
procedure StrDelete(Str: PWideChar; Index, Count:Integer); overload;
(* wie System.Delete, aber mit PAnsiChar *)
function CompareTextLen(const S1, S2: string; Len: integer): Integer;
(* Textvergleich der ersten <Len> Zeichen *)
function SameText(const S1, S2: string): Boolean;
(* Wie AnsiSameText ohne Ansi *)

procedure FileClearReadOnly(const Filename: string);
//faReadOnly weg
function GetFileCount(Directory, FileMask: string; Recurse: boolean): integer;
// Ergibt Anzahl Files in einem Verzeichnis (ohne Directories).
function DelDir(const DirName: string): boolean;
//löscht Verzeichnisbaum auch wenn er nicht leer ist
function GetFileSize(const FileName: string): longint;
(* ermittelt die Filegröße anhand des Filenamens. Öffnet nicht *)
function GetFileDateTime(const FileName: string): TDateTime;
// ermittelt das Filedatum als TDateTime anhand des Filenamens. Öffnet nicht
function SetFileDateTime(const FileName: string; DateTime: TDateTime): boolean;
// setzt das Filedatum als TDateTime. ergibt false wenn File nicht gefunden oder anderer Fehler.
function DiffFileDateTime(const FileName: string; DateTime: TDateTime): integer;
//ergibt Differenz von File zu DateTime in Sekunden. Ist postiv wenn File neuer.
function CopyFile(const FromName, ToName: string): Boolean;
{Copy von FromName nach ToName}
function CopyFileReplaceWithLink(const FromName, ToName, Description: string): Boolean;
// File kopieren. Danach Quelle löschen ersetzen mit Link zum Ziel.
function MoveFile(const FromName, ToName: string): Boolean;
// File über Shell verschieben. Ergibt true bei Erfolg.

(* Menüfunktionen *)
function FindMenuItem(aMenu: TMenu; aCaption: string): TMenuItem; overload;
function FindMenuItem(aMenu: TMenu; aTag: integer): TMenuItem; overload;

(* Umwandlungsfunktionen: DBFelder, Datum/Zeit, strings, Numerisch *)
function GetFieldText(AField: TField): string;
function GetFieldValue(AField: TField): string;
function GetFieldstring(AField: TField): string;
{Text liefern für MarkAll/Clipboard}
procedure GetFieldStrings(AField: TField; L: TStrings);
(* füllt Stringliste mit Feldinhalt. Feldtyp muß kein BLOB sein. Rechte.Params *)
procedure GetFieldPicture(AField: TField; aPicture: TPicture);
// Schreibt GraphicField Inhalt nach aPicture. BMP und JPG werden unterstützt. Siehe umDBImage.
procedure SetFieldString(AField: TField; AString: string);
{Text setzten für MarkAll/Clipboard}
procedure SetFieldText(AField: TField; AText: string);
{einem TField Text zuweisen. Formatabhängig}
procedure SetFieldStrings(AField: TField; Strings: TStrings);
{Stringliste typabhängig setzten }
procedure SetFieldValue(AField: TField; AValue: string);
{einem TField Text zuweisen. Formatunabhängig}
procedure SetFieldValueRO(AField: TField; AText: string);
{einem TField Text zuweisen auch bei Read-Only Feldern}
procedure SetFieldFloatN0(AField: TField; AFloat: Extended);
{einem TField eine Float-Wert zuweisen. Null wenn 0-Wert}
procedure SetFieldFloatRO(AField: TField; AFloat: Extended);
{einem TField eine Float-Wert zuweisen. Auch bei ReadOnly}
procedure AddFieldText(AField: TField; AText: string);
(* Wert hinzufügen (Trenner ist ';')   * AddFieldText *)
procedure AddFieldLine(AField: TField; ALine: string);
(* Wert hinzufügen (Trenner ist CRLF) *)
procedure InsertFieldLine(AField: TField; APos: integer; ALine: string);
(* Zeile in mehrzeiligem Feld einfügen an Position APos. APos kann beliebig gross sein *)
procedure SetFieldComp(AField: TField; AValue: string);
{bedingte Zuweisung von Text (nur bei Änderung der Daten)}
procedure SetFieldDflt(AField: TField; AValue: string);
(* Belegt Feldwert mit SetFieldValue(AValue) wenn AField.IsNull *)
function CompFieldValue(AField: TField; AValue: string; IgnoreCase: boolean = false): integer;
{<0 Feldinhalt kleiner Text usw}
function ScanFieldValue(AField: TField; AValue: string): integer;
(* Vergleich Feldinhalt mit Text zeichenweise (vergl compfieldText)
   Result: Länge der Übereinstimmung oder 0 wenn keine *)
function CompFields(Field1, Field2: TField): TCompareSet;
(* vergleicht 2 Felder -> Ergebinsmenge *)
function AssignField(DstField, SrcField: TField): boolean;
{Inhalte übertragen. true=Feldwert unterschiedlich}
procedure AssignFieldComp(DstField, SrcField: TField);
(* Feldinhalt beliebiger Feldtypen kopieren: nur wenn ungleich *)
procedure AssignFieldRO(DstField, SrcField: TField);
(* Feldinhalt beliebiger Feldtypen kopieren. Ignoriert Readonly Flag *)
procedure MoveField(DstField, SrcField: TField);
{Inhalte übertragen und danach SrcField löschen}
procedure AssignFieldByName(DstTbl: TDataSet; DstFieldName: string;
                             SrcTbl: TDataSet; SrcFieldName: string);
{Inhalte übertragen mit DataSet und Feldnamen}
procedure AssignFieldByName1(Tbl: TDataSet; DstFieldName: string;
                             SrcFieldName: string);
{Inhalte übertragen mit gleichem DataSet und Feldnamen}
procedure MoveFieldByName1(Tbl: TDataSet; DstFieldName: string;
                             SrcFieldName: string);
{Inhalte bewegen mit gleichem DataSet und Feldname}
procedure LogicalToJaNein(AField: TField);
{Werte von Logical Field (dBase) nach JaNein-Field konvertieren}
function NVL(AField: TField; NullValue: integer): integer; overload;
function NVL(AField: TField; NullValue: double): double; overload;
//double function NVL(AField: TField; NullValue: TDateTime): TDateTime; overload;
function NVL(AField: TField; NullValue: string): string; overload;
function GetFieldIndex(ADataSet: TDataSet; AField: TField): integer;
{liefert den Index vom Feld in TDataSet.Fields}
function IsBlobField(AField: TField): boolean;
{ergibt True wenn das Feld ein Blob Feld ist}
function IsCalcField(AField: TField): boolean;
{ergibt True wenn das Feld ein Calc Feld ist}

//Stored Procedures: Parameter div. Typs als String zuweisen:
procedure ProcAssignFloat(aProc: TUniStoredProc; const AParamName, Value: string);
procedure ProcAssignInt(aProc: TUniStoredProc; const AParamName, Value: string);
procedure ProcAssignDate(aProc: TUniStoredProc; const AParamName, Value: string);
procedure ProcAssignStr(aProc: TUniStoredProc; const AParamName, Value: string);

function GetMemoString(AMemo: TField; Ident, Default: string): string;
{liest Values[Ident] aus ValueList in Memofield}
function GetMemoBool(AMemo: TField; Ident: string; Default: boolean): boolean;
{liest Values[Ident] aus ValueList in Memofield}
function GetMemoInteger(AMemo: TField; Ident: string; Default: Integer): Integer;
{liest Values[Ident] aus ValueList in Memofield}
function GetMemoFloat(AMemo: TField; Ident: string; Default: Double): Double;
{liest Values[Ident] aus ValueList in Memofield}
procedure SetMemoString(AMemo: TField; Ident, Value: string);
{Schreibt Values[Ident]=Value nach Memofield}

function GetStringsString(AList: TStrings; Ident, Default: string): string;
{liest Values[Ident] aus ValueList in Strings}
function GetStringsBool(AList: TStrings; Ident: string; Default: boolean): boolean;
{liest Values[Ident] aus ValueList in AList}
function GetStringsInteger(AList: TStrings; Ident: string; Default: Integer): Integer;
{liest Values[Ident] aus ValueList in AList}
function GetStringsFloat(AList: TStrings; Ident: string; Default: Double): Double;
{liest Values[Ident] aus ValueList in AList}
function GetStringsFloatIntl(AList: TStrings; Ident: string; Default: Double): Double;
{ liest Values[Ident]. Unterstützt verschiedene internationale Formate }
function GetStringsStrings(AList: TStrings; const Section: string;
  Strings: TStrings): boolean;
{liest alle Strings einer [Section] komplett. Groß/Klein egal.
 Leerzeilen und mit ; beginnende Zeilen werden ignoriert
 ergibt true wenn Section gefunden (auch wenn sie leer ist) }
function GetStringsParam(AList: TStrings; Value, Default: string): string;
{liest linke Seite vom '=' bei rechter Seite = Value. Ignoriert Groß/Klein}
procedure SetStringsString(AList: TStrings; Ident, Value: string);
{belegt Values[Ident] mit Value}
procedure SetStringsBool(AList: TStrings; Ident: string; Value: boolean);
{belegt Values[Ident] mit Value}
procedure SetStringsInteger(AList: TStrings; Ident: string; Value: Integer);
{belegt Values[Ident] mit Value}
procedure SetStringsFloat(AList: TStrings; Ident: string; Value: Double);
{belegt Values[Ident] mit Value}
procedure SortStrings(Strings: TStrings; Descending: boolean = false);
(* Sortiert Strings via QuickSort *)
procedure GridToStrings(AGrid: TStringGrid; AList: TStrings; Fixed: boolean);
{schreibt belegte Grid-Cells nach AList i.d.F. <X>,<Y>=<Value>}
procedure StringsToGrid(AList: TStrings; AGrid: TStringGrid; Fixed: boolean);
{belegt Grid-Cells mit Stringsinhalt, Zeilenaufbau: <X>,<Y>=<Value>}

function StrParam(ALine: string; RightestEqual: boolean = false): string;
{Extrahiert die linke Seite vom '='}
function StrValue(ALine: string; RightestEqual: boolean = false): string; {Extrahiert die rechte Seite vom '='}
function StrValueDflt(ALine: string; RightestEqual: boolean = false): string; {Extrahiert die rechte Seite vom '=' Ergibt ALine wenn '=' fehlt}
procedure MergeStringsValues(Strings: TStrings; const Src: TStrings);
function AnsiCompStr(S1, S2: string; IgnoreCase: boolean): boolean;
function CompStr(S1, S2: string; IgnoreCase: boolean): boolean;
function StrIn(const Str, Values: string; IgnoreCase: boolean): boolean;
{ergibt TRUE wenn Str in Values. Tokens mit ; getrennt}
function FieldIsName(AField: TField; AFieldName: string): boolean;
{ergibt TRUE wenn AField.FieldName = AFieldName ist (groß/klein/nil egal)}
function OnlyFieldName(AFieldName: string): string;
{Extrahiert den Feldnamen nach dem Punkt WERK.WERK_NAME}
function OnlyTableName(ATableName: string): string;
{Extrahiert den Namen vor dem Punkt WERK.WERK_NAME --> WERK}
function OnlyFileName(AFilePath: string): string;
//OnlyFileName extrahiert nur den Namen ohne Erweiterung aus einem Dateinamen.
function StripExtension(AFilePath: string): string;
//entfernd die Endung (und Punkt) von Filepfad.
function QueryTableName(ADataSet: TDataSet): string;
{Extrahiert den ersten TableName aus SQL Text}
function ShortCaption(ACaption: string): string;
(* Extrahiert 1.Teil des Titels (vor dem ' - ') *)
function LongCaption(ACaption, Caption2: string): string;
// Baut Titel aus ACaption + ' - ' + Caption2 auf. ACaption wird vor ' -' gekürzt
function BeforeBracketCaption(ACaption, OpenBracket: string): string;
// Extrahiert HauptTeil des Titels vor der öffnenden Klammer bzw vor dem ' - ' - 29.09.08
function GetInnerBracketCaption(ACaption, OpenBracket, CloseBracket: string): string;
// Extrahiert Untertitel des Titels (zwischen OpenBrackect([) und CloseBrracket(]) - 29.09.08
function BracketCaption(ACaption, ASubCaption, OpenBracket, CloseBracket: string): string;
// Baut Titel aus ACaption + <OpenBracket> + SubCaption + <CloseBracket> auf
function MainCaption(ACaption: string): string;
(* Extrahiert HauptTeil des Titels (vor dem '[' bzw. ' - ') *)
function SubCaption(ACaption, ASubCaption: string): string;
(* Baut Titel aus ACaption + '[' + SubCaption + ']' auf
   ACaption wird evtl. vorher mit Main/ShortCaption gekürzt *)
function ExtCaption(ACaption, AExtCaption: string): string;
// Baut Titel aus ACaption + ' *' + ExtCaption auf. ACaption wird vor '*' gekürzt
function GetSubCaption(ACaption: string): string;
(* Extrahiert Untertitel des Titels (zwischen '[' und ']' *)
function FieldAsTime(AField: TField): TDateTime;
{Wandelt Field-Wert (z.B.string) in Zeit um}
procedure FieldSetTime(AField: TField; ATime: TDateTime);
{Setzt Zeitwert. Auch für String und Integer Fields}
function FieldAsDate(AField: TField): TDateTime;
{Wandelt Feldwert in Datum um. Y2 sicher, auch bei Stringfield}
function FieldAsChar(AField: TField): Char;
{das erste Zeichen oder #0 wenn leer}
function FieldAsInt(AField: TField): longint;
{als Integer oder 0 bei Fehler/is null}

{------------------------------------}
procedure TimeInc(var ATime: TDateTime; DHour, DMin, DSec: integer);
{Zeit erhöhen um DHour, DMin, DSec}
function GetTimeInc(ATime: TDateTime; DHour, DMin, DSec: integer): TDateTime;
//Ergibt inkrementierten Zeitwert
procedure DateInc(var ADate: TDateTime; Years, Months, Days: integer);
{Datum erhöhen um Years, Months, Days}
procedure DateIncWorkdays(var ADate: TDateTime; Days: integer);
(* Incrementiert Datumwert. Überspringt Arbeitstage [Sa,So] und Feiertage. *)
function ExtractYear(ADate: TDateTime): integer;
{Ergibt Jahreszahl des Datums 4stellig}
function ExtractMonth(ADate: TDateTime): integer;
{Ergibt Monat des Datums 1..12}
function ExtractYearMonth(ADate: TDateTime): integer;
{Ergibt Jahreszahl|Monat des Datums i.d.F. yyyymm}
function ExtractDay(ADate: TDateTime): integer;
{Ergibt Tag des Datums 1..31}
function ExtractSeconds(ADate: TDateTime): integer;
{Ergibt Anzahl Sekunden}
function ExtractDaysOfMonth(ADate: TDateTime): integer;
{Anzahl Tage eines Monats anhand Date}
function DaysOfMonth(Year, Month: integer): integer;
{Anzahl Tage eines Monats}
function DaysOfYear(Year: integer): integer;
{Anzahl Tage eines Jahrs (366,365)}
function Y2Year(AYear: Word): Word;
{Checkt Jahr 2000 Problematik. Ergibt korrektes Jahr: 1980..1999 2000..2079}
function Y2Date(ADateTime: TDateTime): TDateTime;
{Checkt Jahr 2000 Problematik. Ergibt korrektes Datum: 1980..1999 2000..2079}
function OnlyDate(ADateTime: TDateTime): TDateTime;
{liefert Datumswert. Y2 sicher}
function OnlyTime(ADateTime: TDateTime): TDateTime;
{liefert Zeitwert}
function StrToDate4(const S: string): TDateTime;
(* 4stellige Erweiterung von StrToDate *)
function StrToDateTime4(const S: string): TDateTime;
(* 4stelliges StrToDateTime. Uhrzeit kann fehlen *)
function StrToDateY2(const S: string): TDateTime;
(* Y2000-sicheres StrToDate *)
function StrToDateTol(const S: string): TDateTime;
(* StrToDate: toleriert auch Wochentage vorm Datum. Ergibt bei Fehler date *)
function StrToDateTimeY2(const S: string): TDateTime;
(* Y2000-sicheres StrToDateTime. Uhrzeit kann fehlen *)
function DateToStrY2(ADate: TDateTime): string;
(* Y2000-sicheres DateToStr mit 4st. Jahreszahl *)
function DateToStr4(ADate: TDateTime): string;
(* DateToStr mit 4st. Jahreszahl *)
function DateTimeToStr4(ADateTime: TDateTime): string;
(* DateTimeToStr mit 4st. Jahreszahl *)
function DateTimeToStrY2(ADateTime: TDateTime): string;
(* Y2000-sicheres DateTimeToStr mit 4st. Jahreszahl *)
function TimeToStr2(ATime: TDateTime): string;
// wie TimeToStr aber immer mit 2stelliger Stundenzahl
function StrToDateTimeIntl(const S: string): TDateTime;
// Internationales StrToDateTime yyyy-mm-dd-hh-nn-ss. Uhrzeit kann fehlen
function DateTimeToStrIntl(ADateTime: TDateTime): string;
// Internationales DateTimeToStr yyyy-mm-dd-hh-nn-ss
procedure CheckSql(AQuery: TuQuery);
{Überarbeitung eines SQL-Statements für spezielle Datenbanken}
procedure ReplaceParams(AQuery: TuQuery);
{ersetzt Parameter mit tatsächlichen Werten}
function FieldIsNull(AField: TField): boolean;
{IsNull-Test über Inhalt = ''}
function RequiredPos(ADataSet: TDataSet): integer;
(* Ergibt Index des ersten leeren Required-Feldes oder -1 *)
function RequiredStr(ADataSet: TDataSet): string;
(* Ergibt DisplayName des ersten leeren Required-Feldes oder '' *)
procedure RaiseRequired(AField: TField);
// Exception 'Feld %s darf nicht leer sein' auslösen
procedure CheckRequired(ADataSet: TDataSet);
{Überprüf not NULL Felder ob sie gefüllt sind}
procedure FocusRequired(AForm: TForm; ADataSet: TDataSet);
{Überprüf not NULL Felder ob sie gefüllt sind und Focusiert DBEdit}
procedure FieldRequired(AForm: TForm; AField: TField);
//Wenn AField leer ist wird Exception 'FieldRequired' ausgelöst plus Focus
procedure FocusAndRaise(AForm: TForm; AField: TField);
//setzt Focus und löst dann eine Exception 'FieldRequired' aus
procedure FocusField(AForm: TForm; AField: TField);
{Setzt Focus auf das Grid oder ein Control das mit Field verbunden ist.}
function ForceFocus(aControl: TWinControl): boolean;
{erzwingt den Focus}
function CheckEOF(ADataSet: TDataSet): boolean;
(* Testet ob aktueller Datensatz der letzte ist.
   Setzt ADataSet auf EOF wenn Test positiv *)
function GetName(AComponent: TComponent): string;
(* ergibt Name der Componente oder '(nil)' *)
function FindClassComponent(TheOwner: TComponent; ClassRef: TComponentRef):
  TComponent;
{liefert die erste Componente auf dem Formular die dem Typ entspricht}
function FindTagControl(TheParent: TWinControl; ATag: longint;
  ClassRef: TComponentRef): TComponent;
{liefert das erste Control mit Parent=TheParent deren Tag=ATag ist}
function FindTagComponent(TheOwner: TComponent; ATag: longint;
  ClassRef: TComponentRef): TComponent;
{liefert erste Komponente vom Typ=ClassRef mit Owner=TheOwner deren Tag=ATag ist
 wenn TheOwner=nil dann wird nächste Komponente geliefert}
function IsDescendantOfParent(ADesc: TControl; AParent: TWinControl): boolean;
//ergibt true wenn ADesc ein Nachfolger von AParent ist (ADesc.Parent...Parent=AParent)
procedure GetControlsValues(TheParent: TWinControl; AList: TStrings);
// Liest Eingabewerte der Controls eines Panels und schreibt sie nach AList.
procedure PutControlsValues(TheParent: TWinControl; AList: TStrings);
// Belegt Eingabewerte mit Inhalt von AList
procedure SaveControlsToIni(TheParent: TWinControl; Section: string);
// Speichert Inhalt/Zustand der visuellen Komponenten in einem Panel in der INI.
procedure LoadControlsFromIni(TheParent: TWinControl; Section: string);
//Restauriert Inhalt/Zustand der visuellen Komponenten aus der INI
function DispatchBC(Sender: TComponent; AComponent: TComponent;
  MsgNr: integer; Data: longint): longint;
{TWMBroadcast Message an Componente senden. Vergl. Qwf_form.BroadcastMessage}
procedure CheckBoxChange(aChb: TCustomCheckBox);
{ruft OnClick Ereignis der Checkbox auf}
procedure CheckBoxSetChecked(aChb: TCustomCheckBox; AValue: boolean);  // OnClick immer
procedure SetCheckBoxAndChange(aChb: TCustomCheckBox; AValue: boolean);  //OnClick wenn geändert
procedure ComboBoxChange(aCob: TCustomComboBox);
{ruft OnChange Ereignis der Combobox auf}
procedure ComboBoxSetText(aCob: TCustomComboBox; AText: string);
{setzt Text und ruft OnChange Ereignis der Combobox auf}
procedure ComboBoxSetIndex(aCob: TCustomComboBox; aIndex: integer);
{setzt ItemIndex und ruft OnChange Ereignis der Combobox auf}
function ComboBoxText(aCob: TCustomComboBox): string;
{ergibt Inhalt des aktuellen Items}
procedure ListBoxScrollWidth(aListBox: TListBox; S: string);
//Falls S nicht komplett sichtbar wird horizontale Scrollbar eingefügt
procedure ListBoxScrollWidths(aListBox: TListBox);
//Falls Inhalt horizontal nicht komplett sichtbar wird Scrollbar eingefügt
function XCrypt(s: AnsiString): AnsiString;
{ASCII-Verschlüsselung mit einfachem Key}
function Encrypt(const InString: AnsiString): AnsiString;
{Verschlüsselung nach Borland}
function Decrypt(const InString: AnsiString): AnsiString;
{Entschlüsselung nach Borland}
function EncryptPassw(const InString: AnsiString; Len: integer = 80): AnsiString;
//Passwort als Hexstring der festen Länge <Len> verschlüsseln.
//Len muss mindestens 2*Länge von Passw haben. Ansonsten erfolgt Exception
function DecryptPassw(const InString: AnsiString): AnsiString;
//Passwort entschlüsseln. Muss mit EncryptPassw verschlüsselt worden sein.
// wenn InString nicht mit Hex-Zeichen beginnt dann wird InString unverändert zurückgegeben
function ByteArrToStr(BA: array of Byte): AnsiString;
//kopiert Byte Array nach AnsiString. Unabhängig vom lokalen Gebietsschema.
function StrToHexStr(const InString: AnsiString): AnsiString;
//Umwandlung in lesbaren Hex-Zeichen. Verdoppelt InString-Länge
function HexStrToStr(const InString: AnsiString): AnsiString;
//Umwandlung von Hex- nach lesbaren Zeichen. Halbiert InString-Länge
function HexCharToBinStr(HC: char): string;
//Umwandlung von Hex- nach bitString
function HexByteToBinStr(AByte: Byte): string;
//Umwandlung von Byte nach bitString
function CompareStrings(S1, S2: TStrings): integer;
{vergleicht stringlisten: 0=gleich}
function GetStringsText(Value: TStrings): string;
{wandelt stringliste in string um}
procedure SetStringsText(Strings: TStrings; Text: string);
{wandelt string in stringliste um}
procedure FreeObjects(Strings: TStrings);
{Alle Objekte von Strings und Strings selbst entfernen}
procedure ClearObjects(Strings: TStrings);
{Alle Objekte von Strings entfernen und Strings selbst zurücksetzen}
function CharCount(C: Char; S: string): integer;
{Zählt Anzahl C in S}
procedure SetStringsWidth(L: TStrings; LineWidth: integer; Trenner: string = '\');
{Breite der Zeilen beschränken. Trenner: Zeichen für Fortsetzung in nächster Zeile}
function RemoveCrlf(S: string): string;
{Löscht CrLf aus einem string}
function ReplaceCRLF(S, ReplaceString: string): string;
{Löscht CrLf aus einem string und ersetzt es mit ReplaceString}
function RemoveTrailCrlf(const S: string): string;
{Löscht CR und LF Sequenzen am Ende eines String}
function RemoveAccelChar(S: string): string;
{Löscht '&' aus einem string}
function DuplAccelChar(S: string): string;
{Ersetzt '&' mit '&&', damit '&' angezeigt wird, z.B. für PanSMess. kann mehrmals aufgerufen werden ohne Vervierfachung }
function StrCgeChar(const S: string; chVon, chNach: char): string; overload;
{ersetz ein Zeichen durch ein anderes wenn chNach = #0 dann wird das Zeichen gelöscht}
function StrCgeChar(const S: AnsiString; chVon, chNach: AnsiChar): AnsiString; overload;
// Ansi-Verion
function StrCgeStr(const S: string; chVon: char; SNach: string): string;
{ersetzt ein Zeichen durch einen anderen String}
function StrCgeStrStr(const S, SVon, SNach: string;
  IgnoreCase: boolean): string;
{ersetzt einen String durch einen anderen String}
function StrToValidIdent(const S: string): string;
{wandelt einen string in gültigen Pascalbezeichner}
function StrToValidFilename(const S: string): string;
// ungültige Zeichen als '_' ersetzen. Nicht für Filepfade!
function StrToIntl(const S: string): string;
// Ergibt String ohne Umlaute und ß
function TrimIdent(const S: string): string;
(* Extrahiert gültige Alphanumerische Zeichen und Umlaute *)
function AnsiCopy(S: AnsiString; Index: Integer; Count: Integer): AnsiString;
//wie Copy()
function StrCtrl(const S: AnsiString): AnsiString;
{Wandelt Steuerzeichen in druckbare Zeichenfolge um}
function CtrlStr(const S: AnsiString): AnsiString;
{Wandelt druckbare Zeichenfolge in Steuerzeichen um}
function StrPNew(const Source: AnsiString): PAnsiChar;
{dupliziert einen Pascall-string in einen nullterminierten string
 der mit StrDispose wieder gelöscht werden muß}
function StrLPas(Str: PAnsiChar; Len : integer): AnsiString; overload;
function StrLPas(Str: PWideChar; Len : integer): string; overload;
{wandelt ein Teil eines PAnsiChar in ein Pascal-string um}
function StrIPos(Str1, Str2: PAnsiChar): PAnsiChar;
(* Wie StrPos (Pos von Str2 in Str1) aber nicht Case Sensitiv *)
function PosI(Substr: string; S: string): Integer;
{wie Pos aber nicht Case-Sensitiv}
{function PosStr(S1, S2: string): integer;   020298 ersetzt durch Pos}
(* Position von S1 in S2 oder 0 wenn nicht gefunden *)
function ReverseStr(S: string): string;
(* dreht die Reihenfolge in S um  (aus ABC wird CBA) *)
function PosR(Substr: string; S: string): Integer;
(* wie Pos - findet letztes (am weitesten Rechts) Vorkommen von SubStr in S *)
function PosRI(Substr: string; S: string): Integer;
(* wie PosR - aber nicht Case Sensitiv *)
function PosCh(Chars: TSysCharSet; S: string): Integer;
(* ergibt erste Position EINES Zeichens aus Chars in S oder 0 wenn nicht vorhanden *)
function StrDflt(Src, Dflt: string): string;
(* ergibt <Dflt> wenn S='' sonst S *)
function Char1(S: string): char; overload;
function Char1(S: AnsiString): AnsiChar; overload;
(* Liefert 1.Character von S oder #0 wenn leer *)
function CharI(S: string; I: integer): char;
(* Liefert i.Character von S oder #0 wenn leer *)
function CharN(S: string): char;
(* Liefert letzen Character von S oder #0 wenn leer *)
function BeginsWith(S, Tok: string; IgnoreCase: boolean = false): boolean;
(* ergibt true wenn S mit Tok beginnt *)
function EndsWith(S, Tok: string; IgnoreCase: boolean = false): boolean;
(* ergibt true wenn S mit Tok endet *)
function BoolToStr(B: boolean): string;
(* Liefert 'true' bzw. 'false' *)
function StrToFloatTol(const S: string): Extended;
{Tolerant ohne Exception '0' bei Fehler
 ignoriert führende und folgende nicht numerische Zeichen}
function StrToFloatDef(const S: string; Default: Extended): Extended;
{wie StrToFloat bei Fehler gibt Default zurück}
function StrToFloatTolSep(const S: string): Extended;
(* wie StrToFloatTol, berücksichtigt anderen DecimalSeparator *)
function StrToIntTol(const S: string): longint; overload;
{Tolerant ohne Exception '0' bei Fehler. ignoriert führende und folgende nicht numerische Zeichen}
function StrToIntTol(const S: AnsiString): longint; overload; //Ansi Version
function StrToInt64Tol(const S: AnsiString): int64; overload;
function StrToInt64Tol(const S: string): int64; overload;
function StrToMSecs(const S: string; const dflt: string = '0'): longint;
{ 'String to Milliseconds' - wandelt Zahl mit Einheit nach Millisekunden um }
function StrToFloatIntl(const S: string; tolerant: boolean = true;
  Default: Extended = 0): Extended;
{ String wird in verschiedenen internationalen Formaten korrekt interpretiert }
function FloatToStrIntl(Value: Extended): string;
{Wandelt Float in internationales Format}
function FormatFloatIntl(const Format: string; Value: Extended): string;
{Erzeugt String im internationales Format (Dezimalpunkt)}
function FormatTol(const AFormat: string; const AArgs: array of const): string;
{Fehler im Formatbefehl mit try except abfangen abfangen --> wichtig wegen Übersetzungen}
function RoundDec(X: Extended; NK: integer): Extended;
{Rundet eine Gleitkommazahl auf NK Nachkommastellen}
function RoundCeil(X: Extended; NK: integer): Extended;
{Rundet eine Gleitkommazahl auf NK Nachkommastellen nach oben}
function RoundFloor(X: Extended; NK: integer): Extended;
{Rundet eine Gleitkommazahl auf NK Nachkommastellen nach unten}
function RoundCur(X: Extended; NK: integer): Extended; {Rundet kaufmännisch auf NK }
function RoundEUR(X: Extended): Extended; {Rundet kaufmännisch auf 2 NK }
function IsNum(Ch: Char): boolean; overload;
function IsNum(Ch: AnsiChar): boolean; overload;
function IsAlpha(Ch: Char): boolean; overload;
function IsAlpha(Ch: AnsiChar): boolean; overload;
function IsAlphaUml(Ch:char): boolean;    {Buchstabe incl. dt. Umlauten und ß}
function IsAlphaNum(Ch: Char): boolean; overload;
function IsAlphaNum(Ch: AnsiChar): boolean; overload;
function IsAlphaNumUml(Ch:char): boolean;
function IsHexDec(Ch:char): boolean; overload;
function IsHexDec(Ch: AnsiChar): boolean; overload;
function IsIdentChar(Ch: Char): boolean; overload;
function IsIdentChar(Ch: AnsiChar): boolean; overload;
{Buchstaben, Zahlen und '_'}
function StripAlphaNumUml(S: string): string;
//entfernt alle nicht AlphaNumUml
function IsNumeric(S: string): boolean;
//ergibt true wenn S nur aus Ziffern besteht
function IsFloatStr(S: string): boolean;
//ergibt true wenn S einen numerischen Floatwert darstellt
function IsDateStr(S: string): boolean;
// ergibt true wenn S ein Datum darstellt
function FirstUpper(S: string): string;
//Erster Buchstabe groß; Rest klein.
procedure SetEdText(AEdit: TCustomEdit; AText: string);
//Setzt Text und löst OnChange IMMER aus.
procedure SetEdNum(AEdit: TEdit; AText: string);
(* Edit.Text rechtsbündig zweisen *)
procedure SetEdCenter(AEdit: TEdit; AText: string);
(* Edit.Text zentriert zweisen *)
procedure EdSelAll(AEdit: TCustomEdit);
(* alles markieren als Postmessage *)
function ListCount(AList: TList): integer;
(* Anzahl belegter Elemente einer TList ohne nil-Elemente *)
function BITIS(I, Msk: integer): boolean;
{Binäres und von zwei Zahlen}
function ISBITSET(I, BitNr: integer): boolean;
{Testet ob Bit[BitNr] gesetzt. BitNr in 0..31}
procedure BITSET(var I: integer; BitNr: integer); overload;
procedure BITSET(var I: Word; BitNr: integer); overload;
{Setzt Bit[BitNr] in I. BitNr in 0..31 bzw. in 0..15}
procedure BITCLEAR(var I: integer; BitNr: integer);
{Löscht Bit[BitNr] in I. BitNr in 0..31}
function RectEqual(const R1, R2: TRect): boolean; // ergibt true wenn beide TRect gleich sind
function RectWidth(const R: TRect): integer;
function RectHeight(const R: TRect): integer;
function NextTab(I, Tab: integer): integer;
{ergibt nächsten Tabulator ab I (Tabulator ist Vielfaches von Tab}
function Sgn(I: extended): TSGN;
{-1, 0, +1}
function IPower(X, Y: longint): longint;
procedure ClearPendingExceptions;  //löscht Fehlerflag 
(* Ergibt X hoch Y *)
function RTrunc(X: Extended): Int64;
// Workaround für fehlerhalte Trunk Implementierung
function RCeil(X: Extended): Int64;
// Workaround für fehlerhalte Ceil Implementierung
function RFloor(X: Extended): Int64;
// Workaround für fehlerhalte Ceil Implementierung
function RInt(X: Extended): Extended;
// Workaround für fehlerhalte Int Implementierung
function RFrac(X: Extended): Extended;
// Workaround für fehlerhalte Frac Implementierung
function RPower(Base, Exponent: Extended): Extended;
// Workaround für fehlerhalte Power Implementierung
function FracToInt(X: Extended; MaxNk: integer = 9): Integer;
(* schiebt alle (max.9) Nachkommastellen vor das Komma *)
function FloatToIntTol(X: Extended; MinNk: integer): Integer;
(* Entfernt Komma aus X; wenn Frac(X) = 0, dann werden MinNk angeängt; => 0 wenn Exception *)
function FloatToIntTolNk(X: Extended; MinNk, MaxNk: Integer): Integer;
(* X wird auf MaxNK gerundet, dann Komma entfernt *)
function HiDiv(Z, N: longint): longint;
(* ergibt Divisionsergebnis E, wobei E * N >= Z, d.h. HiDiv(5,3)=2 *)

(* Dialogunterstützung *)

(* BDE, TFields dynamisch anlegen *)
procedure OpenDS(aDataSet: TDataSet);
{Öffnet ein Detail Dataset. Füllt Parameter. DS Kann Disabled sein}
function CreateDataField(Dataset: TDataset; FieldName: string; Display: string): TField;
{dynamisch erzeugen von einem TField bewandt mit DataField}
function CreateCalcField(Dataset: TDataset; FieldName : string; Display: string;
                          FieldType: TFieldType; Size : Word ) : TField;
{dynamisch erzeugen von einem TCalcField bewandt mit CalcField}
function GetFieldType(TypeStr: string): TFieldType;
{Umwandlung von Bezeichnung in FieldTyp}
function IndexInfo(ADatabase: TuDatabase; ATblName: string;
  IndexList: TStrings = nil; OptionsList: TStrings = nil): string;
{Bestimmt Index Infos einer Tabelle}
function UniqueIndexFields(ADatabase: TuDatabase; ATblName: string; UniqueIndexFieldList: TStrings): string;
{Erstell Liste alle Feldnamen die an einem Unique Index beteiligt sind}
function InternalIndexInfo(ADatabase: TuDatabase; ATblName: string;
  IndexList, OptionsList, UniqueIndexFieldList: TStrings): string;
// Ermittelt Indexinfos einer Tabelle.
function GetUniqueValues(AQuery: TuQuery): string;
{ergibt mehrzeiligen String aller Unique-Spalten mit <Feldname>=<Wert>}
function GetKritValue(aTable, aFieldname, KritNames: string;
  KritFields: array of TField; AQue: TuQuery): string; overload;
// ergibt Field.AsString der Spalte mit den Kriterien
function GetKritValue(aTable, aFieldname, KritNames: string;
  KritValues: string; AQue: TuQuery): string; overload;
//Werte als String mit ; getrennt
function IsLocalQuery(AQuery: TuQuery): boolean;
{liefert true wenn AQuery eine lokale Tabelle (Paradox,dBase) ist}
function QueryHasNotnullBlobs(ADataSet: TDataSet): boolean;
//ergibt true wenn mindestens ein nicht leeres BLOB-Field existiert
function QueryPostCommitted(AQuery: TDataSet; WhenBlobs: boolean): integer;
// führt AQuery.Post in einer Transaktion aus.
function QueryExecCommitted(AQuery: TuQuery): integer;
{ führt AQuery.ExecSql aus und Committed danach aus. Zwingend bei NOAUTOCOMMIT}
procedure ProcExecCommitted(AProc: TUniStoredProc);
{ führt AProc.ProcExec aus und Committed danach. Zwingend bei NOAUTOCOMMIT}
function QueryServerName(ADBDataSet: TuQuery): string;
//Ergibt den BDE Parameter SERVER NAME des Dataset
function QueryDatabase(ADataSet: TDataSet): TuDataBase; overload;
{liefert DataBase von AQuery. Sucht in allen Sessions}
function QueryDatabase(ADatabaseName: string): TuDataBase; overload;

(* Betriebssystem, Drucker *)
function FontToStr(F: TFont): string;
{ergibt Fontbeschreibung anhand Font}
procedure StrToFont(const S: string; F: TFont);
{Fontbeschreibung nach Font. Aufbau:[Name, Size, Style, Color].  Style:[NFKUD]}
function StrToColor(const S: string; Dflt: TColor = clBlack): TColor;
function ColorToStr(cl: TColor): string;
function GetAmpelColor(aVal, aMin, aMax: integer): TColor;
//aMin->Grün  aMax->Rot; rot=255,0,0  gelb=255,255,0  grün=0,255,0
procedure SetupPrinter(ADruckerTyp: string);
{Dialog um Druckereinrichten. Ruft TDlgPrnFont.Execute}
procedure SetDefaultPrinter(Index: integer);
{Setze den Standartdrucker auf Drucker 'Index'}
procedure SendChar(AWinControl: TWinControl; Characters: string);
(* Sendet Characters als WM_CHAR Messages an angegebenes Handle *)
procedure PostKeys(AWinControl: TWinControl; Keys: array of Word);
(* Postmessages Keys als WM_KEYDOWN+WM_KEYUP Messages an angegebenes Handle *)
function ClientToClient(const Point: TPoint; SourceControl, TargetControl: TControl): TPoint;
(* Konvertierung zwischen den Koordinatensystemen verschiedener Steuerelente *)
procedure Delay(Value: longint; Silent: boolean = false);
(* Wartet Value [ms] *)
procedure DelayHard(Value: longint; Silent: boolean = false);
(* Wartet Value [ms] - ohne Processmessages! *)
function TicksDelayed(Start: integer): integer;
//Ergibt Zeitdifferenz zwischen jetzt und Start in Millisekunden
//Berücksichtigt negative Werte und Zurückspringen des Systemcounters
function TicksRestTime(Start, Interval: integer): integer;
//Ergibt Restzeit bis Interval abgelaufen ist (CheckDelayedMS true wird)
procedure TicksReset(var Start: integer);
//Setzt StartTicks zurück
function TicksCheck(var Start: integer; Interval: integer): boolean;
//Ergibt true wenn <Interval>ms seit letztem Aufruf verstrichen
//Verwendet <Start> für Speicherung des letzten Aufrufs
function RTicksDelayed(Start: TDateTime): Integer;
//wie TicksDelayed aber mit TDateTime als Start. Unabhängig von Rechnerlaufzeit.
function RTicksRestTime(Start: TDateTime; Interval: integer): Integer;
//wie TicksRestTime aber mit TDateTime als Start. Unabhängig von Rechnerlaufzeit.
procedure RTicksReset(var Start: TDateTime);
//wie TicksReset aber mit TDateTime als Start. Unabhängig von Rechnerlaufzeit.
function RTicksCheck(var Start: TDateTime; Interval: Integer): boolean;
//wie TicksCheck aber mit TDateTime als Start. Unabhängig von Rechnerlaufzeit.
function FileTimeToMSecs(FileTime: TFileTime): integer;
{ ergibt Anzahl MilliSec vergangen seit FILETIME}
function InPort(PortAddr: Word): Byte; {$IFDEF WIN32} assembler; stdcall; {$ENDIF}
(* Lesen IO-Port *)
procedure OutPort(PortAddr: Word; Databyte: Byte); {$IFDEF WIN32} assembler; stdcall; {$ENDIF}
(* Schreiben IO-Port *)
function CreateClassID36: string;  //UUID bzw GUID ohne '{}'
function WinExecErrorStr(ErrorNr: integer): string;
(* ergibt Fehlermeldung im Klartext für Aufrufer von WinExecAnd Wait *)
function WinExecAndWait(FileName:string; Visibility : integer = SW_SHOWNORMAL): DWORD; overload;
function WinExecAndWait(FileName: string; SetCurrDir: boolean; Visibility: integer = SW_SHOWNORMAL): DWORD; overload;
{Ausführen und Warten bis beendet}
function GetAppFromExtension(Ext: string): string;
function JavaExec(JarFileName, JarArgs: string; Wait: boolean; Visibility: integer): DWORD;
function ShellExecAndWait(FileName:string; Visibility : integer = SW_SHOWNORMAL): integer;
{Öffnen  Datei und Warte bis kommt}
function ShellExecNoWait(FileName: string; Visibility: integer = SW_SHOWNORMAL): integer;
{Ausführen und nicht Warten}
function ShellExecOp(FileName: string; Visibility: integer;
  Operation: string; Wait: boolean): integer;
  {Ausführen Operation. Warten bzgl. Wait (n.a.)}
function WinExecNoWait(FileName: string; Visibility: integer = SW_SHOWNORMAL): integer;
{Ausführen. Nicht Warten}
procedure ShutDown(ReBoot: boolean);
//Rechner ausschalten. Reboot: true = neu starten
function NonClientMetrics: TNonClientMetrics;
//ergibt System Abmessungen:
//iBorderWidth: Specifies the thickness, in pixels, of the sizing border.
//iScrollWidth: Specifies the width, in pixels, of a standard vertical scroll bar.
//iScrollHeight: Specifies the height, in pixels, of a standard horizontal scroll bar.
function DelphiRunning: boolean;
function AskDelphiRunning(Meldung: string): boolean;
{bei Shareware}
function CpuMHz: longint;
{angenäherte CPU Geschwindigkeit in MHz}
function PentiumBug: boolean;

function EnumFunc(Wnd: HWND; TargetWindow: PHWND): bool; export;

procedure GotoPreviousInstance;


var
  Prot: TProt;
  StartPrnDevice: PChar;
  SysParam: TSysParam;  {Bedienung durch ParaFrm}
  StdPanelSMess: TPanel;  {smess ohne frmmain und GNavigator}
  InDelay: boolean;
  DebugStr: string;
  CopyFileError: DWORD;  //GetLastError von CopyFile


implementation
uses
  Math, TabNotBk, ComCtrls,
  DBCtrls, DBConsts, DbGrids, Printers, IniFiles, ShellApi, registry,
  IBQuery, {NMftp,} WinSock, {Psock,}      {GetIp}
  JclSysInfo {NB30 MAC}, Xml.Internal.CodecUtilsWin32 {Codec},
  GIFImg, pngimage, JPEG,  {GetFieldPicture}
  ShDocVw, MSHTML, ActiveX, Variants,  {HtmlToText}
  nstr_Kmp, SystemKmp, ShellTools {CopyFile}, ComObj {CreateClassID},
  IOUtils {TPath},
  UTbl_Kmp, UMetaKmp, UDataSetIF, USes_Kmp, NLnk_Kmp, WinTools {Version},
  GNav_Kmp, MuGriKmp, Err__kmp, Ini__Kmp, IniDbKmp, PrnFoDlg, VektorKmp, Tools,
  Qwf_Form, DatumDlg, Poll_Kmp, KmpResString, Feiertage;

type
  TDummyListBox = class(TListBox);
  TDummyControl = class(TControl);
  TDummyCheckBox = class(TCustomCheckBox);
  TDummyCustomComboBox = class(TCustomComboBox);
  TDummyCustomCheckBox = class(TCustomCheckBox);
  TDummyCustomRadioGroup = class(TCustomRadioGroup);
  TDummyCustomEdit = class(TCustomEdit);


var
  EnvStrings: TStringList;
  
(*** TSysParam ***************************************************************)

procedure AdjustFormatSettings;
// Delphi XE Bug: Ändert ShortDateFormat von dd.mm.yyyy nach dd/mm/yyyy
//                wird hier wieder rückgängig gemacht.
// http://qc.embarcadero.com/wc/qcmain.aspx?d=104942
begin
  FormatSettings.ShortDateFormat := StrCgeStrStr(FormatSettings.ShortDateFormat,
    '/', FormatSettings.DateSeparator, false);
  FormatSettings.LongDateFormat := StrCgeStrStr(FormatSettings.LongDateFormat,
    '/', FormatSettings.DateSeparator, false);
end;

constructor TSysParam.Create;
begin
  //26.03.09 lazy loading Drucker := TValueList.Create;
  Db1Params := TStringList.Create;
  FormsInFrame := true;
  MonthDateFormat := 'yyyy-mm';
  WE := 'EUR';
  CRChar := #0;
  EuroFaktor := 0.5112918;
  TakeReturn := true; {beim Übernehmen eines Datensatzes automatisch schließen}
  StartKey := 983;  	{Start default key  my Prims}   {für Encryption}
  MultKey := 12689;	{Mult default key}
  AddKey := 35897;	{Add default key}
  SetIniChange := not IsWindowsNT;  //bei Win95 Meldung senden dass DefaultPrinter/WIN.INI geändert
  MaxSqlLine := 127; //für ORA OK
  OraUnicodeBug := false;
  ProtPrint := true;  //19.08.10
  MuDrawingStyle := gdsClassic;
  AdjustFormatSettings;  //02.10.13
end;

destructor TSysParam.Destroy;
begin
  FreeAndNil(FDrucker);
  FreeAndNil(Db1Params);
  inherited Destroy;
end;

procedure TSysParam.SetProtBeforeOpen(const Value: boolean);
begin
  if FProtBeforeOpen <> Value then
  begin
    FProtBeforeOpen := Value;
    Prot0('ProtBeforeOpen=%d', [ord(Value)]);
  end;
end;

function TSysParam.GotoPos: boolean;
begin
  if not GotoPosLoaded then
    FGotoPos := IniKmp.ReadBool(SSortierung, 'GotoPos', false);
  Result := FGotoPos;
end;

function TSysParam.GetDrucker: TValueList;
begin
  if FDrucker = nil then
  begin
    FDrucker := TValueList.Create;
    if (IniKmp <> nil) and not IniKmp.InReadDrucker then
      IniKmp.ReadDrucker;
  end;
  Result := FDrucker;
end;

procedure TSysParam.ClearDrucker;
begin
  FreeAndNil(FDrucker);
  if IniKmp <> nil then
    IniKmp.DruckerTypen := nil;
end;

function TSysParam.GetPrinterIndex(DruckerTyp: string; var APrinterFont: string): integer;
var
  IndexStr: string;
  P: integer;
begin
  Result := -1;   {Standarddrucker}
  APrinterFont := '';
  if Drucker.ValueIndex(DruckerTyp,@IndexStr) >= 0 then
  try
    P := Pos(',',IndexStr);
    if P > 0 then
    begin
      Result := StrToInt(copy(IndexStr, 1, P-1));
      APrinterFont := copy(IndexStr, P+1, 250);
    end else
      Result := StrToInt(IndexStr);        {Index,PrinterFont}
  except on E:Exception do
      Prot0(SProts_001,		// '%s:"%s" kein gültiger PrinterIndex%s%s'
        [DruckerTyp, IndexStr, CRLF, E.Message]);
  end;
end;

procedure TSysParam.SetPrinterIndex(DruckerTyp: string; APrinterIndex: integer;
  APrinterFont: string);
var
  IndexStr, DruckerLine: string;
  I: integer;
begin
  DruckerLine := Format('%s=%d', [DruckerTyp, APrinterIndex]);
  if APrinterFont <> '' then
    DruckerLine := Format('%s,%s', [DruckerLine, APrinterFont]);
  I := Drucker.ValueIndex(DruckerTyp,@IndexStr);
  if I >= 0 then
    Drucker.strings[I] := DruckerLine else
    Drucker.Add(DruckerLine);
  IniKmp.WriteDrucker;
end;

(*** TProt *******************************************************************)

constructor TProt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LoeschFlag := false;
  FileName := '%U_%M_%A_#D.LOG';  //26.03.09 - 'LOG#D.LOG'; - 'ERROR.DAT';
  Remain := false;
  MaxCount := 65000;  //vor 26.08.09: 255;
  if Prot <> nil then
  begin
    //raise EInit.Create(SProts_002);	// 'Protokollkomponente bereits vorhanden'
    if csDesigning in Prot.ComponentState then
      ErrWarn('Protokollkomponente (%s) bereits vorhanden', [Prot.Name]);
  end else
    Prot := self;
  {Prot0('Start %s',[Application.ExeName]);}
end;

destructor TProt.Destroy;
begin
  inherited Destroy;
  if Prot = self then
    Prot := nil;
end;

procedure TProt.Loaded;
begin
  inherited Loaded;
  if (csdesigning in ComponentState) and
     (CompareText(FileName, 'ERROR.DAT') = 0) then
    FileName := 'LOG#D.LOG';                        {261198 roe}
end;

function TProt.GetListBox: TListBox;
begin
  if assigned(FListBox) then
  try  //falls nicht ordnungsgemäß auf nil gesetzt
    if csDestroying in FListBox.ComponentState then
      FListBox := nil else
      Debug('%d', [FListBox.Items.Count]);
  except on E:Exception do begin
      //EProt(self, E, 'GetListBox', [0]); besser nicht falls Rekusion
      FListBox := nil;
    end;
  end;
  Result := FListBox;
end;

procedure TProt.SetListBox(Value: TListBox);
begin
  FListBox := Value;
end;

procedure TProt.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

function TProt.GetFilePath: string;
var
  S: string;
  AYear, AMonth, ADay, AWDay, AKW: Word;
  AHour, AMin, ASec, AMSec: Word;
  FileDateTime: TDateTime;
  FileYear, FileMonth, FileDay, FileKW: Word;
  FileHour, FileMin, FileSec, FileMSec: Word;
  P, Zyklus: integer;
begin
  if Pos('\', FileName) > 0 then
  begin
    Result := FileName;
  end else
  begin
    if FileName = '' then FileName := 'ERROR.DAT';
    Result := TempDir + FileName;
//    S := GetEnvStr('TEMP');
//    if copy(S, length(S), 1) <> '\' then
//      AddStr(S, '\');
//    Result := Format('%s%s', [ExtractFilePath(S), FileName]);
    if not (csDesigning in ComponentState) then
      FileName := Result;    //wichtig um Memory Leak zu vermeiden
  end;
  //Neu: Namensplatzhalter: %U=User %M=Maschine %A=Anwendung (ohne .exe)
  //wir verwenden CompUserName stat Sysparam.username, weil der konstant bleibt
  if IniDb <> nil then
  begin
    Result := StringReplace(Result, '%U', IniDb.User, [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '%M', IniDb.Maschine, [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '%A', IniDb.Anwendung, [rfReplaceAll, rfIgnoreCase]);
  end else
  begin
    Result := StringReplace(Result, '%U', CompUserName, [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '%M', CompName, [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '%A', OnlyFilename(Application.ExeName), [rfReplaceAll, rfIgnoreCase]);
  end;

  (* Platzhalter umsetzen:    #D -> Tag;   #M -> Monat; #Y -> Jahr
                              #W -> WochenTag   (Mo=00 Di=01 .. So=06)
                              #H -> Stunde  #N = Minute  #S =sekunde *)
  P := Pos('#', Result);
  if P > 0 then
  begin
    DecodeDate(SysUtils.date, AYear, AMonth, ADay);
    DecodeTime(SysUtils.time, AHour, AMin, ASec, AMSec);
    AWDay := TagDerWoche(date);
    Zyklus := 999;
    while (P > 0) and (P < length(Result)) do
    begin
      case UpCase(Result[P+1]) of
        'Y': begin
               S := Format('%02.2d', [AYear]);
               Zyklus := IMin(Zyklus, 0);
             end;
        'M': begin
               S := Format('%02.2d', [AMonth]);
               Zyklus := IMin(Zyklus, 1);
             end;
        'W': begin
               S := Format('%02.2d', [AWDay]);
               Zyklus := IMin(Zyklus, 2);
             end;
        'D': begin
               S := Format('%02.2d', [ADay]);
               Zyklus := IMin(Zyklus, 3);
             end;
        'H': begin
               S := Format('%02.2d', [AHour]);
               Zyklus := IMin(Zyklus, 4);
             end;
        'N': begin
               S := Format('%02.2d', [AMin]);
               Zyklus := IMin(Zyklus, 5);
             end;
        'S': begin
               S := Format('%02.2d', [ASec]);
               Zyklus := IMin(Zyklus, 6);
             end;
      else
        S := Result[P+1] + Result[P+1];
      end;
      Result[P] := S[1];
      Result[P+1] := S[2];
      P := Pos('#', Result);
    end;
    (* Protfile löschen falls vom letzten Zyklus: *)
    if not InternalLoeschFlag then                   {wird in X() wieder zurückgesetzt}
    begin
      //Age := FileAge(Result);
      //if Age > 0 then                        {nur wenn Protfile existiert}
      if FileAge(Result, FileDateTime) then
      begin
        //FileDateTime := FileDateToDateTime(Age);
        DecodeDate(FileDateTime, FileYear, FileMonth, FileDay);
        DecodeTime(FileDateTime, FileHour, FileMin, FileSec, FileMSec);
        FileKW := KwOfDate(FileDateTime);
        AKW := KwOfDate(date);
        case Zyklus of
          1: InternalLoeschFlag := FileYear <> AYear;           {M}
          2: InternalLoeschFlag := FileKw <> AKW;               {W}
          3: InternalLoeschFlag := FileMonth <> AMonth;         {D}
          4: InternalLoeschFlag := FileDay <> ADay;             {H}
          5: InternalLoeschFlag := FileHour <> AHour;
          6: InternalLoeschFlag := FileMin <> AMin;
        end;
      end;
    end;
  end;
end;

procedure TProt.Edit;
begin  //startet Editor mit Logfile
  SysParam.DisplayWinExecError := true;
  SysParam.ThrowWinExecError := false;
  ShellExecNoWait(FilePath, SW_SHOWNORMAL);
end;

procedure TProt.EditAll;
var    //Opendialog mit allen Logfiles
  S: string;
  I, P: integer;
begin
  S := ExtractFileName(FileName);
  S := StringReplace(S, '%U', '*', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '%M', '*', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '%A', OnlyFilename(Application.ExeName), [rfReplaceAll, rfIgnoreCase]);
  P := Pos('#', S);
  if P > 0 then
  begin
    repeat
      S[P] := '?';
      if P + 1 <= length(S) then
        S[P + 1] := '?';
      P := Pos('#', S);
    until P = 0;
  end else
  begin
    S := '*.*';
  end;
  with TOpenDialog.Create(Application) do
  try
    Options := Options + [ofAllowMultiSelect];
    InitialDir := ExtractFilePath(FilePath);
    FileName := ExtractFileName(FilePath);
    Filter := '(' + S + ')|' + S;
    if S <> '*.*' then
      Filter := Filter + '|(*.*)|*.*';
    if Execute then
    begin
      for I := 0 to Files.Count - 1 do
      begin
        SysParam.DisplayWinExecError := true;
        ShellExecNoWait(Files[I], SW_SHOWNORMAL);
      end;
    end;
  finally
    Free;
  end;
end;

procedure TProt.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent = FListBox then
      ListBox := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TProt.X(modus: TProtModusSet; const Fmt: string; const Args: array of const);
{Allgemeine Schreibfunktion}
var
  NowValue: TDateTime;
  NowStr, S, PcNr: string;
  AField: TField;
  P, KeyName, ApplicationName, FileName: string;
  ScrollWidth: integer;
  S1, Nexts: string;
  MsgStr: PChar;
  MsgS: string;
const
  InProt: boolean = false;
begin
  if InProt then
  begin
    Debug0;
    if (GNavigator <> nil) and (GNavigator.X <> nil) then
    begin
      MsgS := FormatTol(Fmt, Args);
      if Char1(MsgS) <> '(' then
        MsgS := Format('(%s) %s', [DateTimeToStr(now), MsgS]);
      MsgStr := StrNew(PChar(MsgS));
//19.04.12      MsgStr := StrNew(PAnsiChar(AnsiString(MsgS)));
//      if Char1(MsgS) = '(' then
//        MsgStr := StrNew(PAnsiChar(MsgS)) else
//        MsgStr := StrNew(PAnsiChar('('+DateTimeToStr(now)+') ' + MsgS));
      PostMessage(GNavigator.X.Handle, BC_GNAVCLICK, gnProtA, LParam(MsgStr));
    end;
  end else
  try
    InProt := true;
    S := FormatTol(Fmt, Args);
  //if AnsiSameText(copy(s,1,6), 'update') then
  //Debug0;
    if (self = nil) or (csDesigning in Application.ComponentState) then
    begin
      //Msg := RemoveCrlf(S);
//      P := StrPNew(RemoveCrlf(S));
//      KeyName := StrPNew(TimeToStr(SysUtils.time));
//      ApplicationName := StrPNew(DateTimeToStr(date));
//      FileName := StrPNew(FormatDateTime('"Delphi-"mm".LOG"', date));
//      WritePrivateProfileString(ApplicationName, KeyName, P, FileName);
//      StrDispose(P);
//      StrDispose(KeyName);
//      StrDispose(FileName);
//      StrDispose(ApplicationName);

      P := RemoveCrlf(S);
      KeyName := TimeToStr(SysUtils.time);
      ApplicationName := DateTimeToStr(date);
      FileName := TempDir + FormatDateTime('"Delphi-"mm".LOG"', date);
      WritePrivateProfileString(PChar(ApplicationName), PChar(KeyName), PChar(P), PChar(FileName));

    end else
    begin
      if SysParam.BatchMode then
      begin
        if prMsg in modus then
          modus := modus + [prFile,prList] - [prMsg];
      end;
      NowValue := Now;
      NowStr := DateTimeToStr(NowValue);
      if (LTrimCh(SysParam.PcNr, '0') = '') then  // '' oder nur 0en
        PcNr := '' else
        PcNr := Format('PC:%s ', [SysParam.PcNr]);
      if prTimestamp in modus then  {wenn mit Zeit}
        Msg := Format('%s%s %s', [PcNr, NowStr, S]) else
        Msg := S; //Format('%s', [S]);
      if prSMess in modus then
      begin
        SMess(Fmt, Args);
      end;
      if {(prDatabase in modus)}(prFile in modus) and (DataSet <> nil) then
      begin
        try
          DataSet.Close;
          DataSet.Open;
          DataSet.Insert;
          AField := DataSet.FindField('PROT_DATUM');
          if AField <> nil then AField.AsDateTime := now;
          AField := DataSet.FindField('PROT_USER');
          if AField <> nil then AField.Asstring := SysParam.UserName;
          AField := DataSet.FindField('PROT_APPLIKATION');
          if AField <> nil then AField.Asstring := ShortCaption(Application.Title);
          AField := DataSet.FindField('PROT_PCNR');
          if AField <> nil then AField.Asstring := SysParam.PcNr;
          AField := DataSet.FindField('PROT_WERKNR');
          if AField <> nil then AField.Asstring := SysParam.WerkNr;
          AField := DataSet.FindField('PROT_ERRNR');
          if AField <> nil then AField.AsInteger := SysParam.ErrNr;
          AField := DataSet.FindField('PROT_TEXT');
          if AField <> nil then AField.Asstring := FormatTol(Fmt, Args);
          DataSet.Post;
        except
          on E:Exception do
            if not DbIgnore then
              if MessageFmt(SProts_003,[DataSet.Name,E.Message],	// 'Prot:Fehler bei Insert(%s): %s'
                mtError, [mbOk,mbIgnore], 0) = mrIgnore then DbIgnore := true;
        end;
      end;
      if prFile in modus then {in die Protokolldatei}
      begin
        try
          InternalLoeschFlag := false;  //falls Fremdaufruf von GetFilepath - 19.07.08
          S1 := GetFilePath;    //nur einmal aufrufen
          AssignFile(ProtFile, S1);                 {open}
          if InternalLoeschFlag then
            LoeschFlag := true;  //kann auch von außen explizit auf true gesetzt werden, z.B. GNavigator.DoOnIdle
          if LoeschFlag or not FileExists(S1) then
          begin
            LoeschFlag := false;
            ForceDirectories(ExtractFilePath(S1));
            Rewrite(ProtFile);
          end else
            Append(ProtFile);
          try
            if not (prRemain in modus) then
              writeln(ProtFile, Msg);
            if (prRemain in modus) and not (prList in modus) then
              write(ProtFile, Msg);
          finally
            try
              CloseFile(ProtFile);
            except
              SMess('can''t close %s', [S1]);
            end;
          end;
        except
          on E:Exception do
            // 'Prot:Fehler bei Öffnen(%s): %s'
            SMess(SProts_004,[S1, E.Message]);
            {MessageFmt('Prot:Fehler bei Öffnen(%s): %s',[S1, E.Message], mtError, [mbOk], 0);}
        end;
      end;
      if (prList in modus) and (ListBox <> nil) then
      try
        {Msg := RemoveCrlf(Msg);}
        if prNoLbStamp in Modus then
          Msg := S;
        if (prNoLbFocus in Modus) or
           not (ListBox.Owner is TForm) or           {Frame!}
           (TForm(ListBox.Owner).ActiveControl <> ListBox) then
        begin
          {if ListBox.Owner is TForm then
            OldControl := TForm(ListBox.Owner).ActiveControl;}
          while ListBox.Items.Count > MaxCount do
          begin
            ListBox.Items.Delete(0);
            //TDummyListBox(ListBox).DeleteString(0);  //02.07.02
          end;
          if Remain and (prRemain in modus) and (ListBox.Items.Count > 0) then
          begin
            {Ausgabe ohne Zeilenwechsel}
            ListBox.Items.strings[ListBox.Items.Count - 1] := Msg;
            ListBox.ItemIndex := ListBox.Items.Count - 1;
          end else
          begin
            {Ausgabe mit Zeilenwechsel}
            //ListBox.Items.Add(Msg);
            S1 := PStrTok(Msg, CRLF, NextS);
            while S1 <> '' do
            begin
              ListBox.Items.Add(S1);
              S1 := PStrTok('', CRLF, NextS);
            end;
            ListBox.ItemIndex := ListBox.Items.Count - 1;
            ListBox.Update;
            ScrollWidth := ListBox.Canvas.TextWidth(Msg);
            if ScrollWidth > SendMessage(ListBox.Handle, LB_GetHorizontalExtent, 0, 0) then
              SendMessage(ListBox.Handle, LB_SetHorizontalExtent, ScrollWidth, 0); {horizontal scrollen}
          end;
          Remain := prRemain in modus;
          (* try    (nein!  LAWA.FrmProt)
            if SysParam.BatchMode and ErrKmp.Aktiv and ListBox.CanFocus then
              ListBox.SetFocus;
          except
          end;*)
        end;
      except
        ListBox := nil;               {war evtl. bereits gelöscht}
      end;
      if prMsg in modus then
      begin
        InProt := false;
        if prWarn in modus then
          MessageFmt(Fmt, Args, mtWarning, [mbOK], 0) else
        if prErr in modus then
          MessageFmt(Fmt, Args, mtError, [mbOK], 0) else
          MessageFmt(Fmt, Args, mtInformation, [mbOK], 0);
      end;
    end; {runtime}
  finally
    InProt := false;
  end;
end;

procedure TProt.X_Unique(modus: TProtModusSet; N: integer; L: TStrings;
  const Fmt: string; const Args: array of const);
{Allgemeine Schreibfunktion: schreibt nur wenn Text <> der letzten N Texte}
var
  S: string;
  I: integer;
  Found: boolean;
begin
  S := Format(Fmt, Args);
  Found := false;
  for I := 0 to L.Count - 1 do
  begin
    if S = L[I] then
      Found := true;
  end;
  if not Found then
  begin
    X(Modus, Fmt, Args);
    while L.Count >= N do
      L.Delete(0);
    L.Add(S);
  end;
end;

(* Globale Protokollfunktionen: *)

procedure Prot0(const Fmt: string; const Args: array of const);
{In Protokolldatei schreiben mit Datum Zeit Angabe}
begin
  if Prot <> nil then   {wenn angelegt}
    Prot.X([prList,prFile,prTimeStamp], Fmt, Args);
end;

procedure Prot0_D(const Fmt: string; const Args: array of const);
//Prot0 nur wenn im Debug-Mode
begin
  if Sysparam.ProtBeforeOpen then
    Prot0(Fmt, Args);
end;

procedure Prot0_Unique(N: integer; L: TStrings;
  const Fmt: string; const Args: array of const);
{Prot0 aber nur wenn Text <> der letzten N Texte }
begin
  if Prot <> nil then   {wenn angelegt}
    Prot.X_Unique([prList,prFile,prTimeStamp], N, L, Fmt, Args);
end;

procedure ProtLb0(Lb: TListbox; const Fmt: string; const Args: array of const);
{In Listbox schreiben mit Datum Zeit Angabe}
var
  OldListbox: TListBox;
begin
  if Prot <> nil then   {wenn angelegt}
  begin
    OldListbox := Prot.ListBox;
    try
      Prot.ListBox := Lb;
      Prot.X([prList,prFile,prTimeStamp], Fmt, Args);
    finally
      Prot.ListBox := OldListbox;
    end;
  end;
end;

procedure ProtA_D(const Fmt: string; const Args: array of const);
//ProtA nur wenn im Debug-Mode
begin
  if Sysparam.ProtBeforeOpen then
    ProtA(Fmt, Args);
end;

procedure ProtA(const Fmt: string; const Args: array of const);
{In Protokolldatei schreiben ohne Datum Zeit Angabe}
begin
  if Prot <> nil then
    Prot.X([prList,prFile], Fmt, Args);
end;

procedure ProtDB(const Fmt: string; const Args: array of const);
{In Protokoll-Tabell schreiben}
begin
  if Prot <> nil then
    Prot.X([prDatabase,prTimeStamp], Fmt, Args);
end;

procedure ProtP(const Fmt: string; const Args: array of const);
{in Listbox ausgeben mit Zeilenvorschub}
begin
  if Prot <> nil then
    Prot.X([prList], Fmt, Args);
end;

procedure ProtP0(const Fmt: string; const Args: array of const);
{in Listbox mit Timestamp ausgeben mit Zeilenvorschub}
begin
  if Prot <> nil then
    Prot.X([prList,prTimeStamp], Fmt, Args);
end;

procedure ProtR(const Fmt: string; const Args: array of const);
{in Listbox ausgeben ohne Zeilenvorschub}
begin
  if Prot <> nil then
    Prot.X([prList,prRemain], Fmt, Args);
end;

procedure ProtRL(const Fmt: string; const Args: array of const);
{in Listbox und Statuszeile ausgeben ohne Zeilenvorschub}
begin
  if Prot <> nil then
    Prot.X([prSMess, prList, prRemain], Fmt, Args);
end;

procedure ProtM(const Fmt: string; const Args: array of const);
{in Protokolldatei schreiben, als Messagebox ausgeben}
begin
  if Prot <> nil then
    Prot.X([prMsg, prList, prFile, prTimeStamp], Fmt, Args);
end;

procedure ProtL(const Fmt: string; const Args: array of const);
{in Protokolldatei schreiben und Statuszeile}
begin
  {SMess(Fmt, Args);}
  if Prot <> nil then
    Prot.X([prSMess, prList, prFile, prTimeStamp], Fmt, Args);
end;

procedure ProtLA(const Fmt: string; const Args: array of const);
{in Protokolldatei ohne Timestamp schreiben und Statuszeile}
begin
  {SMess(Fmt, Args);}
  if Prot <> nil then
    Prot.X([prSMess, prList, prFile], Fmt, Args);
end;

procedure ProtLD(const Fmt: string; const Args: array of const);
{in Protokolldatei schreiben und DMess-Statuszeile}
begin
  DMess(Fmt, Args);
  if Prot <> nil then
    Prot.X([prList, prFile, prTimeStamp], Fmt, Args);
end;

procedure ProtStrings(Strings: TStrings; aCaption: string = '');
{Protokolliert Strings}
var
  I: integer;
begin
  if aCaption <> '' then
    Prot0('%s', [aCaption]);
  for I := 0 to Strings.Count-1 do
    ProtA('%s', [Strings.Strings[I]]);
end;

function QueryText(ADataSet: TDataSet; Options: TQueryTextOptions = []): string;
{ergibt Sql-Text. AQuery.Text, dabei werden :Parameter in Werte umgewandelt}
var
  AValue: string;
  I, N: integer;
  aFieldType: TFieldType;
  AQuery: TuQuery;
  S1: string;
  IsBlank: boolean;
  P1, P2: integer;
  AField: TField;
begin
  AQuery := nil;  //wg Compilerwarnung
  try
    Result := 'QueryText.ADataSet=nil';
    if ADataSet = nil then
      EError('%s', [Result]); //keine Bange, wir fangen die Exception ab
    if ADataSet is TIBQuery then
    begin
      Result := TIBQuery(ADataSet).Text;
      Exit;
    end;
    if ADataSet is TuTable then
    begin
      Result := Format('select from %s', [TuTable(ADataSet).TableName]);
      Exit;
    end;
    if not (ADataSet is TuQuery) then
    begin
      Result := Format('QueryText.ADataSet is %s', [ADataSet.ClassName]);
      Exit;
    end;
    AQuery := TuQuery(ADataSet);
    Result := AQuery.SQL.Text;
    for I := 0 to AQuery.ParamCount - 1 do
    begin
      AValue := AQuery.Params[I].AsString;
      aFieldType := AQuery.Params[I].DataType;
      if (AQuery.DataSource <> nil) and (AValue = '') then
      begin
        { verfälscht Ergebnis? }
        AField := AQuery.DataSource.DataSet.FindField(AQuery.Params[I].Name);
        if AField <> nil then
        begin
          AValue := AField.AsString;
          aFieldType := AField.DataType;
        end; 
      end;
      if aFieldType in [ftString, ftWideString] then
        AValue := '''' + AValue + '''' else
      if AValue = '' then
        AValue := '(null)';
      Result := StringReplace(Result, ':' + AQuery.Params[I].Name, AValue, [rfReplaceAll, rfIgnoreCase]);
    end;

    if qtoOneLine in Options then
    begin
      S1 := RemoveCRLF(Result);
      Result := '';
      IsBlank := false;
      for I := 1 to Length(S1) do  //mehrere Blanks auf ein Blank reduzieren
      begin
        if S1[I] <> ' ' then
          IsBlank := false;
        if not IsBlank then
          Result := Result + S1[I];
        if S1[I] = ' ' then
          IsBlank := true;
      end;
    end;
    if qtoStripFields in Options then
    begin    //select F1, F2 from T1 -> select [] from T1
      P1 := PosI('select', Result);
      P2 := PosI('from', Result);
      if (P1 > 0) and (P2 > P1) and (Result[P1 + 7] <> '*') then
      begin
        N := CharCount(',', Copy(Result, P1, P2 - P1 + 1));
        Result := Format('%s%d %s', [Copy(Result, P1, 7), N, Copy(Result, P2, MaxInt)]);
      end;
    end;
  except on E:Exception do
    EProt(AQuery, E, 'Prots.QueryText(%s)', [OwnerDotName(ADataSet)]);
  end;
end;

procedure ProtSql(AQuery: TDataSet);
{Protokolliert SQL. Dabei werden :Parameter in Werte umgewandelt}
begin
  ProtA('%s', [QueryText(AQuery, [qtoOneLine])]);
end;

procedure ParamSetNull(AParam: TParam; aDataType: TFieldType = ftString);
{setzt einen SQL Query Parameter auf null und DataType }
//http://www.delphigroups.info/2/5/751864.html
begin
  AParam.Clear;
  AParam.Bound := True;
  AParam.DataType := aDataType;
end;

function ComponentLogName(AComponent: TComponent): string;
//ergibt eindeutigen Komponenten-Bezeichner
begin
  if AComponent = nil then
  begin
    Result := 'nil';
  end else
  if AComponent is TqForm then
  begin
    Result := StrDflt(TqForm(AComponent).Kurz, TqForm(AComponent).ClassName);  //es gibt Form ohne Kurz (SHSvr)
  end else
  begin
    Result := AComponent.Name;
    if Result = '' then
    begin
      if AComponent is TControl then
      begin
        Result := TDummyControl(AComponent).Caption;
      end;
      if Result = '' then
      begin
        Result := AComponent.ClassName;
        //if not (AComponent is TCustomForm) then
        //  Prot0('Debug:ComponentLogName(%s) hat keine Caption', [Result]);
      end;
    end;
  end;
end;

function OwnerDotName(AComponent: TObject): string;
//ergibt Owner.Name der Komponente (für Protokollierung)
begin
  try
    if AComponent = nil then
    begin
      Result := 'nil';
    end else
    if not (AComponent is TComponent) then
    begin
      Result := AComponent.ClassName;
    end else
    begin
      Result := '';
      if not (AComponent is TForm) and
         (TComponent(AComponent).Owner <> nil) then  //die Form
      begin
        //Result := ComponentLogName(TComponent(AComponent).Owner);
        Result := OwnerDotName(TComponent(AComponent).Owner);
        if TComponent(AComponent).Owner is TUniUpdateSQL then
          with TComponent(AComponent).Owner as TUniUpdateSQL do
            if AComponent = SQL[ukModify] then
              AppendTok(Result, 'ukModify', '.') else
            if AComponent = SQL[ukInsert] then
              AppendTok(Result, 'ukInsert', '.') else
            if AComponent = SQL[ukDelete] then
              AppendTok(Result, 'ukDelete', '.') else
      end;
      AppendTok(Result, ComponentLogName(TComponent(AComponent)), '.');
    end;
  except on E:Exception do
    Result := E.Message;
  end;
end;

function OwnerClassDotName(AComponent: TObject): string;
//ergibt OwnerClass.Name der Komponente (für Gen)
begin
  try
    if AComponent = nil then
    begin
      Result := 'nil';
    end else
    if not (AComponent is TComponent) then
    begin
      Result := AComponent.ClassName;
    end else
    begin
      Result := '';
      if TComponent(AComponent).Owner <> nil then  //die Form
        Result := TComponent(AComponent).Owner.ClassName;
      AppendTok(Result, ComponentLogName(TComponent(AComponent)), '.');
    end;
  except on E:Exception do
    Result := E.Message;
  end;
end;

procedure ProtDataSet(ADataSet: TDataSet);
{Protokolliert die Feldinhalte eines DataSet}
var
  I: integer;
begin
  {if ADataSet = nil then
    S := 'nil' else
  if ADataSet.Owner <> nil then
    S := ADataSet.Owner.Name + '.' + ADataSet.Name else
    S := ADataSet.Name;
  ProtA('Dataset: %s', [S]);}
  Prot0('Dataset: %s', [OwnerDotName(ADataSet)]);
  for I := 0 to ADataSet.FieldCount - 1 do
  try
    ProtA('%s=%s', [ADataSet.Fields[I].FieldName, ADataSet.Fields[I].AsString]);
  except on E:Exception do
    EProt(ADataSet, E, 'ProtDataSet', [0]);
  end;
end;

procedure ProtStoredProc(AStoredProc: TUniStoredProc);
{Protokolliert die Parameter einer Stored Proc}
var
  I: integer;
begin
  Prot0('%s calls %s()', [OwnerDotName(AStoredProc), AStoredProc.StoredProcName]);
  for I := 0 to AStoredProc.ParamCount - 1 do
    ProtA('  %s=[%s]', [AStoredProc.Params[I].Name,
                        AStoredProc.Params[I].Text]);
end;

procedure StringsFromFile(Strings: TStrings; const AFileName: string);
var                     {wie LoadFromFile aber ohne Memory Leak}
  P: array[0..4097] of char;
  F: THandle;
  N: DWORD;
begin
  F := CreateFile(
         PChar(AFileName),
         GENERIC_READ,
         0,                              {no sharing}
         nil,                            {no Security}
         OPEN_EXISTING,
         FILE_ATTRIBUTE_NORMAL,          {default attributes}
         0);                             {no template}
  if F = INVALID_HANDLE_VALUE then
  begin
    N := GetLastError;
    EError('StringsFromFile:%d(%s)', [N, SysErrorMessage(N)]);
  end;
  try
    N := sizeof(P);
    if not ReadFile(F, P, sizeof(P) - 1, N, nil) then
    begin
      N := GetLastError;
      EError('StringsFromFile:%d(%s)', [N, SysErrorMessage(N)]);
    end;
    P[N] := #0;
    Strings.Text := P;
  finally
    CloseHandle(F);
  end;
end;

//StringsToFile: wie SaveToFile aber ohne Memory Leak - weg 16.10.11

function MessageFmt(const Fmt: string; const Args: array of const;
                     AType: TMsgDlgType; AButtons: TMsgDlgButtons;
                     HelpCtx: Longint): Word;
{Erweiterung von MessageDlg um Formatangaben. Polling geht weiter}
var
  OldIdle: boolean;
  I: integer;
const
  mb: array[1..5] of TMsgDlgBtn = (mbCancel, mbOK, mbNo, mbYes, mbCancel);
  mr: array[1..5] of Word = (mrCancel, mrOK, mrNo, mrYes, mrCancel);
  ms: array[1..5] of string = ('mrCancel', 'mrOK', 'mrNo', 'mrYes', 'mrCancel');
  mi: integer = 0;
begin
  if SysParam.BatchMode then
  begin
    Result := 0;          {jeden Button mal drücken damit's weitergeht 13.10.01}
    for I := low(mb) to high(mb) do
    begin
      mi := (mi mod 5) + 1;
      if mb[mi] in AButtons then
      begin
        Result := mr[mi];
        break;
      end;
    end;
    if Result = 0 then
    begin
      mi := 5;
      Result := mrCancel;
    end;
    Prot0(Fmt + ': ' + ms[mi], Args);
    {if mbCancel in AButtons then
      Result := mrCancel else
    if mbOK in AButtons then
      Result := mrOK else
    if mbNo in AButtons then
      Result := mrNo else
    if mbYes in AButtons then
      Result := mrYes else
      Result := mrCancel;}
  end else
  begin
    OldIdle := false;  //wg Compilerwarnung
    if (PollKmp <> nil) and (SysParam.PollIdle) then
    begin
      OldIdle := PollKmp.Idle;
      PollKmp.Idle := true;
    end;
    Result := MessageDlg(FormatTol(Fmt, Args), AType, AButtons, HelpCtx);
    if (PollKmp <> nil) and (SysParam.PollIdle) then
    begin
      PollKmp.Idle := OldIdle;
    end;
  end;
end;

procedure Debug(const Fmt: string; const Args: array of const);
begin
  // keine Aktion. Überprüft Fmt[Args] auf Korrektheit.
  // Zum Breakpoint setzen oder definierte Exception auslösen.
  DebugStr := FormatTol(Fmt, Args);

  //Protokollausgabe nur wenn im Debugmodus beware ProtBeforeOpen (FldDsc)

  { TODO : ProtMode, pmDebug - 13.02.11}
//  if Sysparam.ProtMode >= pmDebug then
//    Prot0('DEBUG %s', [DebugStr]);
end;

procedure Debug0;
begin
  // keine Aktion. Nur Platz für Breakpoint
end;

procedure SDebg(const Fmt: string; const Args: array of const);
{Protokollieren nur im Debugmode}
begin
  if Sysparam.ProtBeforeOpen then
    ProtL(Fmt, Args) else
    SMess(Fmt, Args);
end;

procedure SMess0;
begin                                            {keine Ausgabe auf Statuszeile}
  SMess('',[0]);
end;

procedure DMess0;
begin
  DMess('',[0]);
end;

procedure HMess0;
begin
  HMess('',[0]);
end;

procedure GMess0;
begin
  GMess(0);
end;

procedure SMess(const Fmt: string; const Args: array of const);
{Ausgabe auf Statuszeile}
begin
  if GNavigator <> nil then with GNavigator do
  try
    if not (csDestroying in ComponentState) and
       not SMessLocked then
    begin
      SMessText := FormatTol(Fmt, Args);
      if Assigned(OnLMess) then
        OnLMess(GNavigator, lmSMess, SMessText);
      if (PanelSMess <> nil) then {wenn Statuszeile existiert}
      begin
        if (SMessText = '') and (PanelDMess = PanelSMess) then
          PanelSMess.Caption := DMessText else
          PanelSMess.Caption := SMessText;
        PanelSMess.Update;
      end;
    end;
  except on E:Exception do
    EProt(GNavigator, E, 'SMess %s', [Fmt]);
  end;  //else 26.03.09
  if StdPanelSMess <> nil then     {Wenn GNavigator noch nicht da ist          }
  try                              {dann auf die Globale-Variable StdPanelSMess}
    StdPanelSMess.Caption := FormatTol(Fmt, Args);
    StdPanelSMess.Update;
  except
    StdPanelSMess.Caption := Fmt;
  end;
end;

procedure DMess(const Fmt: string; const Args: array of const);
{Ausgabe auf Dialogzeile bzw Statuszeile}
begin
  if (GNavigator <> nil) and not (csDestroying in GNavigator.ComponentState) then
    with GNavigator do
    try
      DMessTimer := 0;
      DMessText := FormatTol(Fmt, Args);
      if Assigned(OnLMess) then
        OnLMess(GNavigator, lmDMess, DMessText);
      if PanelDMess <> nil then
      begin
        if (DMessText = '') and (PanelHMess = PanelDMess) then
          PanelDMess.Caption := HMessText else
          PanelDMess.Caption := DMessText;
        PanelDMess.Update;
      end;
    except on E:Exception do
      EProt(GNavigator, E, 'DMess %s', [Fmt]);
    end;
end;

procedure DMessT1(const Fmt: string; const Args: array of const);
{Ausgabe auf Dialogzeile wir erst nach 5s von SMess überschrieben}
begin
  if (GNavigator <> nil) and not (csDestroying in GNavigator.ComponentState) then
    with GNavigator do
    begin
      DMess(Fmt, Args);
      TicksReset(DMessTimer);
    end;  
end;

procedure HMess(const Fmt: string; const Args: array of const);
{Ausgabe auf Hilfezeile bzw Statuszeile}
begin
  if (GNavigator <> nil) and not (csDestroying in GNavigator.ComponentState) then
    with GNavigator do
    try
      HMessText := FormatTol(Fmt, Args);
      if Assigned(OnLMess) then
        OnLMess(GNavigator, lmHMess, HMessText);
      if PanelHMess <> nil then
      begin
        PanelHMess.Caption := HMessText;
        PanelHMess.Update;
      end;
    except on E:Exception do
      EProt(GNavigator, E, 'HMess %s', [Fmt]);
    end;
end;

procedure GMess(AProgress: integer);
(* Fortschrittszeiger 1..100 *)
var
  GMessText: string;
  DoUpdate: boolean;
begin
  if (GNavigator <> nil) and not (csDestroying in GNavigator.ComponentState) then
    with GNavigator do
    begin
      if Assigned(OnLMess) then
      begin
        GMessText := IntToStr(AProgress);
        OnLMess(GNavigator, lmGMess, GMessText);
        AProgress := StrToIntDef(GMessText, AProgress);
      end;
      if GNavigator.Gauge <> nil then with GNavigator.Gauge do
      begin
        DoUpdate := Progress <> AProgress;
        Progress := AProgress;
        ShowText := AProgress <> 0;
        if DoUpdate then
          Update;
      end;
      if AProgress = 0 then
        GNavigator.Canceled := false;               {170198}
    end;
end;

procedure GMessA(Anteil, Gesamt: longint);
{Ansprechen der Gauge vom GNav: Anteil / Gesamt * 100}
begin
  try
    if Gesamt = 0 then
      GMess(Anteil mod 100) else          {mod 100 am 140800}
      GMess(MulDiv(Anteil, 100, Gesamt));  //(Anteil * 100) div Gesamt
    if (Anteil > 0) and (GNavigator <> nil) and (GNavigator.Gauge <> nil) then
      GNavigator.Gauge.ShowText := true;
  except on E:Exception do
    EProt(Application, E, 'GMessA', [0]);
  end;
end;

procedure WMess(const Fmt: string; const Args: array of const);
{Erweiterung von MessageDlg um Formatierung}
begin
  Screen.Cursor := crDefault;
  if Prot <> nil then
    Prot.X([prMsg,prFile,prTimeStamp], Fmt, Args) else
    MessageFmt(Fmt, Args, mtInformation, [mbOK], 0);
end;

procedure WMessWarn(const Fmt: string; const Args: array of const);
{Erweiterung von MessageDlg:mtWarning um Formatierung}
begin
  Screen.Cursor := crDefault;
  if Prot <> nil then
    Prot.X([prMsg,prFile,prTimeStamp,prWarn], Fmt, Args) else
    MessageFmt(Fmt, Args, mtError, [mbOK], 0);
end;

procedure WMessErr(const Fmt: string; const Args: array of const);
{Erweiterung von MessageDlg:mtError um Formatierung}
begin
  Screen.Cursor := crDefault;
  if Prot <> nil then
    Prot.X([prMsg,prFile,prTimeStamp,prErr], Fmt, Args) else
    MessageFmt(Fmt, Args, mtError, [mbOK], 0);
end;

function mrToStr(mr: Word): string;   //MessageResultToString
begin
  case mr of
    mrNone     : Result := 'mrNone';
    mrOk       : Result := 'mrOk';
    mrCancel   : Result := 'mrCancel';
    mrAbort    : Result := 'mrAbort';
    mrRetry    : Result := 'mrRetry';
    mrIgnore   : Result := 'mrIgnore';
    mrYes      : Result := 'mrYes';
    mrNo       : Result := 'mrNo';
    mrAll      : Result := 'mrAll';
    mrNoToAll  : Result := 'mrNoToAll';
    mrYesToAll : Result := 'mrYesToAll';
  else
    Result := Format('mr(%d)', [mr]);
  end;
end;

function WMessYesNo(const Fmt: string; const Args: array of const): Word;
//ergibt mrYes, mrNo oder mrCancel
begin
  Screen.Cursor := crDefault;
  Result := MessageFmt(Fmt, Args, mtConfirmation, mbYesNoCancel, 0);
  if (Prot <> nil) and (Prot.ListBox <> nil) then   {wenn angelegt}
    Prot0('%s --> %s', [FormatTol(Fmt, Args), mrToStr(Result)])  //Nice in ProtFrm
  else
    Prot0('WMessYesNo:''%s''-->%s', [FormatTol(Fmt, Args), mrToStr(Result)]);
end;

function WMessOkCancel(const Fmt: string; const Args: array of const): Word;
//ergibt mrOK oder mrCancel
begin
  Screen.Cursor := crDefault;
  Result := MessageFmt(Fmt, Args, mtConfirmation, mbOKCancel, 0);
  if (Prot <> nil) and (Prot.ListBox <> nil) then   {wenn angelegt}
    Prot0('%s --> %s', [FormatTol(Fmt, Args), mrToStr(Result)])  //Nice in ProtFrm
  else
    Prot0('WMessOkCancel:''%s''-->%s', [FormatTol(Fmt, Args), mrToStr(Result)]);
end;

function WMessInput(const ACaption, APrompt: string; var Value: string): Boolean;
//Eingabe Aufforderung. Ergibt false bei Abbruch oder Leerstring-Eingabe
begin
  Screen.Cursor := crDefault;
  Result := InputQuery(ACaption, APrompt, Value) and (Value <> '');
  if (Prot <> nil) and (Prot.ListBox <> nil) then   {wenn angelegt}
    Prot0('%s,%s:%d %s', [ACaption, APrompt, Ord(Result), Value])  //Nice in ProtFrm
  else
    Prot0('WMessInput(%s,%s):%d %s', [ACaption, APrompt, Ord(Result), Value]);
end;

function WMessPassword(const ACaption, APrompt: string; var Value: string): Boolean;
//Eingabe Aufforderung für Passwort. Ergibt false bei Abbruch oder Leerstring-Eingabe
begin
  Screen.Cursor := crDefault;
  Result := InputPassword(ACaption, APrompt, Value) and (Value <> '');
  if (Prot <> nil) and (Prot.ListBox <> nil) then   {wenn angelegt}
    Prot0('%s,%s:%d %s', [ACaption, APrompt, Ord(Result), '*'])  //Nice in ProtFrm
  else
    Prot0('WMessPassword(%s,%s):%d %s', [ACaption, APrompt, Ord(Result), '*']);
end;

procedure ErrWarn(const Fmt: string; const Args: array of const);
{Anzeige in einer Dialogbox und Protokollierung des Textes}
var
  Done: boolean;
begin
  Done := false;
  Screen.Cursor := crDefault;
  if (GNavigator <> nil) then
    GNavigator.DoErrWarn(Fmt, Args, Done);
  if not Done then
  begin
    if Prot <> nil then
      Prot.X([prMsg,prWarn,prList,prFile,prTimeStamp], Fmt, Args) else
    if not SysParam.BatchMode then
      MessageFmt(Fmt, Args, mtWarning, [mbOK], 0);
  end;
end;

(* Globale Hilfs-Funktionen *)

function MinValueIdx(const Data: array of Double; var Idx : Integer): Double;
(* Erweiterung der Funktion MinValue aus Math.
   Liefert zum Wert den zugehörigen Index mit zurück *)
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  Idx := Low(Data);
  for I := Low(Data) + 1 to High(Data) do
    if Result > Data[I] then begin
      Result := Data[I];
      Idx := I;
    end;
end;

function MaxValueIdx(const Data: array of Double; var Idx : Integer): Double;
(* Erweiterung der Funktion MaxValue aus Math.
   Liefert zum Wert den zugehörigen Index mit zurück *)
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  Idx := Low(Data);
  for I := Low(Data) + 1 to High(Data) do
    if Result < Data[I] then begin
      Result := Data[I];
      Idx := I;
    end;
end;

function Even(I: longint): boolean;
begin
  Result := not Odd(I);
end;

function Quersumme(I: integer): integer;
var
  S: string;
  I1: integer;
begin
  Result := 0;
  S := IntToStr(I);
  for I1 := 1 to Length(S) do
    Result := Result + StrToInt(S[I1]);
end;

function IMin(I1, I2: longint): longint;
begin
  if I1 < I2 then
    Result := I1 else
    Result := I2;
end;

function IMax(I1, I2: longint): longint;
begin
  if I1 > I2 then
    Result := I1 else
    Result := I2;
end;

function FloatMin(F1, F2: Extended): Extended;
begin
  if F1 < F2 then
    Result := F1 else
    Result := F2;
end;

function FloatMax(F1, F2: Extended): Extended;
begin
  if F1 > F2 then
    Result := F1 else
    Result := F2;
end;

function FloatDflt(F, Dflt: Extended): Extended;
begin  //ergibt Dflt wenn F=0
  if F = 0 then
    Result := Dflt else
    Result := F;
end;

function Div0(Z, N: Extended): Extended;
(* sicheres Div,/.  Nenner kann 0 sein *)
begin
  Result := DivDef(Z, N, 0);
end;

function DivDef(Z, N, Dflt: Extended): Extended;
(* sicheres Div,/.  Wenn Nenner = 0 dann Result = Dflt *)
begin
  try
    if N = 0 then
      Result := Dflt else
      Result := Z / N;
  except                  {z.B. bei NAN}
    Result := Dflt;
  end;
end;

function IntDflt(F, Dflt: Integer): Integer;
begin  //ergibt Dflt wenn F=0
  if F = 0 then
    Result := Dflt else
    Result := F;
end;

function IntDiv0(Z: Int64; N: Integer): Integer;
(* sicheres Integer Div.  Nenner kann 0 sein *)
begin
  Result := IntDivDef(Z, N, 0);
end;

function IntDivDef(Z: Int64; N, Dflt: Integer): Integer;
(* sicheres Integer Div.  Wenn Nenner = 0 dann Result = Dflt *)
begin
  if N = 0 then
    Result := Dflt else
    Result := Z div N;
end;

function MaxQuotient(Div1, Div2: Extended): Extended;
{ergibt Maximum von Div1/Div2 und Div2/Div1. Also >=1 wenn OK, sonst 0}
begin
  if (Div1 <> 0) and (Div2 <> 0) then
  try
    Result := Div1 / Div2;
    if Result < 1 then
      Result := Div2 / Div1;
  except
    Result := 0;     {kein Ergebnis, da nur >=1 sinnvoll}
  end else
    Result := 0;
end;

function EvalExpression(Strg: string; var Error: Boolean; var ErrPos: integer): Extended;
//wertet numerische Ausdrücke aus idF 3*(8+2)/4 oder sin(12)
const
  oper: TSysCharSet = ['+','-','*','/','^','.',','];
var
  r: Extended;
  i: Integer;
  NewExpression: string;
  para, parc: integer;

  procedure Eval(var fExpression: string; var Value: Extended; var BreakPoint: Integer);
  const
    Numeri   : TSysCharSet = ['0'..'9','.'];
  var
    p: Integer;
    Ch: Char;

    procedure Nextp;
    begin { NextP }
      p := p + 1;
      if p <= Length(fExpression) then
        Ch := fExpression[p] else
        CH := #13;
      end;  { NextP }

    function Expr: Extended;
    var
      E: Extended;
      Operatore: Char;

      function SmplExpr : Extended;
      var
        S: Extended;
        Operatore : Char;

        function Term: Extended;
        var
          T: Extended;

          function S_Fact: Extended;

            function Fct : Extended;
            var
              start: Integer;
              F: Extended;

              procedure processo_come_numero;
              var
                codice : Integer;
              begin { processo_come_numero }
                Start := p;
                repeat
                   NextP;
                until not CharInSet(Ch, Numeri);
                if Ch = '.' then
                  repeat
                    Nextp;
                  until not CharInSet(Ch, Numeri);
                if Ch = 'E' then
                begin
                  NextP;
                  repeat
                    NextP;
                  until not CharInSet(Ch, Numeri);
                end;
                Val(copy(fExpression,Start,p-Start),F,Codice);
              end; { processo_come_numero }

              procedure Processo_come_nuova_expr;
              begin { Processo_come_nuova_expr }
                NextP;
                F := Expr;
                if Ch = ')' then
                  NextP else
                  BreakPoint := p;
              end; { Processo_come_nuova_expr }

              procedure Processo_come_Funz_Standard;
              var
                r:Extended;
              begin { Processo_come_Funz_Standard }
                if Copy(fExpression, p, 6)= 'ARCTAN' then
                begin
                  p := p + 5;
                  NextP;
                  F := Fct;
                  F := ArcTan(F);
                end else
                if Copy(fExpression, p, 6)= 'ARCSIN' then
                begin
                  p := p + 5;
                  NextP;
                  F := Fct;
                  r := sqr(F);
                  F := ArcTan(F/sqrt(1-r));
                end else
                if Copy(fExpression, p, 6)= 'ARCCOS' then
                begin
                  p := p + 5;
                  NextP;
                  F := Fct;
                  r := sqr(F);
                  F := ArcTan(sqrt(1-r)/F);
                end else
                if Copy(fExpression, p, 4)= 'SQRT' then
                begin
                  p := p + 3;
                  NextP;
                  F := Fct;
                  F := Sqrt(F);
                end else
                if Copy(fExpression, p, 3)= 'SQR' then
                begin
                  p := p + 2;
                  NextP;
                  F := Fct;
                  F := Sqr(F);
                end else
                if Copy(fExpression, p, 3)= 'ABS' then
                begin
                  p := p + 2;
                  NextP;
                  F := Fct;
                  F := Abs(F);
                end else
                if Copy(fExpression, p, 3)= 'EXP' then
                begin
                  p := p + 2;
                  NextP;
                  F := Fct;
                  F := Exp(F);
                end else
                if Copy(fExpression, p, 2)= 'LN' then
                begin
                  p := p + 1;
                  NextP;
                  F := Fct;
                  F := Ln(F);
                end else
                if Copy(fExpression, p, 3)= 'TAN' then
                begin
                  p := p + 2;
                  NextP;
                  F := Fct;
                  r:=sin(F);
                  F := r/cos(F);
                end else
                if Copy(fExpression, p, 3)= 'COS' then
                begin
                  p := p + 2;
                  NextP;
                  F := Fct;
                  F := Cos(F);
                end else
                if Copy(fExpression,p,3) = 'SIN' then
                begin
                  p := p + 2;
                  NextP;
                  F := Fct;
                  F := Sin(F);
                end else
                begin
                  BreakPoint := p;
                end;
              end; { Processo_come_funz_standard }

            begin { Fct }
              if CharInSet(Ch, Numeri) then
                Processo_come_numero else
              if (Ch = '(') then
                Processo_come_nuova_expr else
                Processo_come_Funz_standard;
              Fct := F;
            end; { Fct }

          begin { S_Fact }
            if Ch = '-' then
            begin
              NextP;
              S_Fact := -Fct;
            end else
              S_Fact := Fct;
          end; { S_Fact }

        begin { Term }
          T := S_fact;
          while Ch = '^' do
          begin
            Nextp;
            t := Exp(Ln(t)*S_fact);
          end;
          Term := t;
        end; { Term }

      begin { SmplExpr }
        s := Term;
        while CharInSet(Ch, ['*','/']) do
        begin
          Operatore := Ch;
          NextP;
          case Operatore of
            '*':  s := s * term;
            '/':  s := s / term;
          end;
        end;
        smplexpr:=s;
      end; { SmplExpr }

    begin { Expr }
      E := SmplExpr;
      while CharInSet(Ch, ['+','-']) do
      begin
        Operatore := Ch;
        NextP;
        case Operatore of
          '+': E := E + SmplExpr;
          '-': E := E - SmplExpr;
        end;
      end;
      expr:=E;
    end; { Expr }

  begin { Eval }
    p := 0;
    NextP;
    Value := Expr;
    if Ch = #13 then
      Error := False else
      Error := True;
    BreakPoint := p;
  end; { Eval }

begin { EvalExpression }
  ErrPos := 0;
  Error := false;
  NewExpression := '';
  for i := 1 to Length(Strg) do
  begin
    strg[i] := Upcase(strg[i]);
    if strg[i]=','  then
      strg[i]:='.';
    if (strg[i] <> ' ')  then
      NewExpression:=NewExpression+strg[i];
  end;
  strg:=NewExpression;
  if strg[1] = '.' then
    strg := '0'+strg;
  if strg[1] = '+' then
    Delete (strg,1,1);
  r:=0;
  para:=0;
  parc:=0;
  for i := 1 to (length(strg)-1) do
  begin
    if strg[i]='(' then
      para:=para+1;
    if strg[i]=')' then
      parc:=parc+1;
    if parc > para then
    begin
      Error:=true;
      break;
    end;
    if CharInSet(strg[i], oper) and CharInSet(strg[i+1], oper) then
      Error:=true;
    if CharInSet(strg[i], oper) and (strg[i+1] =')') then
      Error:=true;
  end;
  if strg[length(strg)]=')' then
    parc := parc + 1;
  if para <> parc then
    Error := true;

  if CharInSet(strg[length(strg)], oper) then
    Error := true;
  if strg[length(strg)]='(' then
    Error := true;

  if (not Error) and (length(strg)>0) then
    Eval(strg, r, ErrPos);

  Result := r;
end; { EvalExpression }

function FillTemplate(SL: TStrings; aFilename: string; SetBlank: boolean = true): string;
// Lädt Templatefile und ersetzt #Platzhalter. Ergibt String mit den Ergebniszeilen.
// SetBlank:true=unbekannte Platzhalter werden auf '' gesetzt. false=sie werden ausgegeben

  function FillWord(S: string): string;
  begin
    if SetBlank then
      Result := '' else  //Feldnamen nicht übernehmen
      Result := S;       //Color:#12345 bleibt bestehen
    if SL.Values[S] <> '' then       //wichtig: kann auch Leerzeichen sein!
      Result := SL.Values[S] else
    if CompareText(S, 'USER') = 0 then
      Result := SysParam.UserName else
    if CompareText(S, 'COMP') = 0 then
      Result := Prots.CompName else
    if CompareText(S, 'APP') = 0 then
      Result := ExtractFilename(Application.ExeName);
    if Result = '' then
      Debug0;
  end;

  function FillLine(S: string): string;
  var
    I, Step, P1, P2: integer;
  begin
    Result := '';
    Step := 0; P1 := 0;
    for I := 1 to Length(S) do
    begin
      case Step of
      0: if S[I] = '#' then
         begin
           P1 := I;
           Step := 1;
         end else
           Result := Result + S[I];
      1: if S[I] = '#' then
         begin    //## -> #
           Result := Result + S[I];
           Step := 0;
         end else
         if not IsIdentChar(S[I]) and not CharInSet(S[I], ['.']) then  // if S[I] = ' ' then
         begin  //Komma und '&' gilt als Ende. Punkt nicht.
           P2 := I - 1;
           Result := Result + FillWord(Trim(Copy(S, P1+1, P2 - P1))) + S[I];
           Step := 0;
         end else
         if I = Length(S) then
         begin
           P2 := I;
           Result := Result + FillWord(Trim(Copy(S, P1+1, P2 - P1 + 1)));
           Step := 0;
         end;
      end;
    end;
  end;

var
  L: TStringList;
  I: integer;
begin { FillTemplate }
  Result := '';
  L := TStringList.Create();
  try
    L.LoadFromFile(aFileName);
    for I := 0 to L.Count - 1 do
    begin   //Leerzeilen auch
      AppendTok(Result, StrDflt(FillLine(L[I]), ' '), CRLF);
    end;
  finally
    L.Free;
  end;
end;

function GetDetailFieldValues(ADataSet: TDataSet; AFieldName, ATrenner: string;
  aPre: string = ''; aPost: string = ''): string;
// ergibt String der Feldwerte des Felds <ADataSet.AFieldName> mit <>Trenner> getrennt
// mit Bookmark und disable - ab 13.02.09
var
  OldActive: boolean;
  ABookMark: TBookMark;
begin
  Result := '';
  ABookMark := nil; //Compiler
  OldActive := ADataSet.Active;
  try
    ADataSet.Open;
    ADataSet.DisableControls;  //12.04.14 erst hier damit :Params übernommen werden
    if OldActive then
      ABookMark := ADataSet.GetBookMark;
    ADataSet.First;
    while not ADataSet.EOF do
    begin
      AppendTok(Result, aPre + ADataSet.FieldByName(AFieldName).Text + aPost, ATrenner);
      ADataSet.Next;
    end;
  finally
    try
      ADataSet.Active := OldActive;
      if OldActive then
      begin
        ADataSet.GotoBookMark(ABookMark);
        ADataSet.FreeBookMark(ABookMark);
      end;
    finally
      ADataSet.EnableControls;
    end;
  end;
end;

function GetDetailFieldFkt(ADataSet: TDataSet; AFieldName, AFkt: string): Double;
// ergibt Summe oder AVG der Feldwerte des Felds <ADataSet.AFieldName>
var
  OldActive: boolean;
  ABookMark: TBookMark;
  N: integer;
begin
  Result := 0;
  N := 0;
  ABookMark := nil; //Compiler
  OldActive := ADataSet.Active;
  try
    ADataSet.Open;
    ADataSet.DisableControls;  //12.04.14 erst hier damit :Params übernommen werden
    if OldActive then
      ABookMark := ADataSet.GetBookMark;
    ADataSet.First;
    while not ADataSet.EOF do
    begin
      Result := Result + ADataSet.FieldByName(AFieldName).AsFloat;
      N := N + 1;
      ADataSet.Next;
    end;
  finally
    try
      ADataSet.Active := OldActive;
      if OldActive then
      begin
        ADataSet.GotoBookMark(ABookMark);
        ADataSet.FreeBookMark(ABookMark);
      end;
    finally
      ADataSet.EnableControls;
    end;
  end;
  if SameText(AFkt, 'AVG') then
    Result := Div0(Result, N);
end;

procedure ExportCsv(aNL: TObject; Filename: string; ColNameStr: string; Options: TExportCsvOptions);
//Schreibt CSV Datei mit allen Zeilen von aNL und den Spalten anhand ColNameStr.
//Spalten mit ';' getrennt. Wenn leer dann alle Felder.
//aNL muss vom Typ TNavLink sein!
var
  ColNames: TValueList;
  DSet: TDataSet;
  NRec: integer;
  Disp: string;

  function DSetToCSV: string;
  var
    I: integer;
    S1: string;
  begin
    Result := '';
    for I := 0 to ColNames.Count - 1 do
    begin
      S1 := DSet.FieldByName(ColNames[I]).AsString;
      if Pos(';', S1) > 0 then
      begin
        S1 := StrCgeStrStr(S1, '"', '""', false);
        S1 := '"' + S1 + '"';
      end;
      Result := Result + S1;
      if I < ColNames.Count - 1 then
        Result := Result + ';';
    end;
  end;

var
  SL: TStringList;
  I: integer;
begin
  DSet := TNavLink(aNL).Dataset;
  NRec := TNavLink(aNL).RecordCount;
  Disp := TNavLink(aNL).Display;
  SysUtils.ForceDirectories(ExtractFilePath(Filename));
  Prot0('Exportiere %s %d Zeilen', [Disp, 1 + NRec]);
  SL := TStringList.Create;
  ColNames := TValueList.Create;
  try
    if ColNameStr = '' then
    begin
      for I := 0 to DSet.FieldCount - 1 do
        AppendTok(ColNameStr, DSet.Fields[I].Fieldname, ';');
    end;
    ColNames.Delimiter := ';';  //für CSV, ist auch dflt.
    ColNames.DelimiterText := ColNameStr;
    ProtA('%s', [ColNames.DelimiterText]);
    SL.Add(ColNames.DelimiterText);
    DSet.First;
    while not DSet.EOF do
    begin
      SL.Add(DSetToCSV);
      DSet.Next;
    end;
    Prot0('Schreibe %d Zeilen nach %s', [1 + NRec, Filename]);
    if ecUtf8 in Options then
    begin
      SL.WriteBOM := ecBOM in Options; //false;  //bewar BOM!
      SL.SaveToFile(Filename, TEncoding.UTF8);  // GetUTF7NoBom
    end else
      SL.SaveToFile(Filename);
    Prot0('Schreiben OK', [0]);
  finally
    SL.Free;
    ColNames.Free;
  end;
end;

function ParseTables(S, S1, S2: string; Tables: array of TDataSet): string;
// ersetzt Text mit Platzhalter durch Feldinhalte in mehreren Tabellen
// Platzhalter werden durch <S1>Feldname<S2> getrennt. S2 kann '' sein.
// Bsp: ('EREC_NR', '#', '', [Tblerec]) -> ersetzt #EREC_NR mit Wert aus Feld Tblerec.EREC_NR
  function ParseTok(S: string): string;
  var
    I: integer;
    ATbl: TDataSet;
    AField: TField;
  begin
    Result := '(null)';
    for I := Low(Tables) to High(Tables) do
    begin
      aTbl := Tables[I];
      aField := aTbl.FindField(S);
      if aField <> nil then
      begin
        Result := GetFieldText(aField);
        Break;
      end;
    end;
  end;
var
  I, Step: integer;
  Tok: string;
begin
  Result := '';
  if S = '' then
    Exit;
  if S1 = '' then
    Exit;
  if Length(Tables) = 0 then
  begin
    Result := S;
    Exit;
  end;

  Step := 0;
  I := 1;
  while I <= Length(S) do
  begin
    case Step of
    0: if Pos(S1, copy(S, I, MaxInt)) = 1 then
       begin
         Tok := '';
         I := I + Length(S1);
         if S2 = '' then
           Step := 1 else
           Step := 2;
       end else
       begin
         Result := Result + S[I];
         Inc(I);
       end;
    1: if not (IsIdentChar(S[I])) then   //kein a..z,1..9,_
       begin
         Result := Result + ParseTok(Tok) + S[I];
         Tok := '';  //ab 22.09.11
         I := I + 1;
         Step := 0;
       end else
       begin
         Tok := Tok + S[I];
         Inc(I);
       end;
    2: if Pos(S2, copy(S, I, MaxInt)) = 1 then
       begin
         Result := Result + ParseTok(Tok);
         Tok := '';  //ab 22.09.11
         I := I + Length(S2);
         Step := 0;
       end else
       begin
         Tok := Tok + S[I];
         Inc(I);
       end;
    end; { case }
  end; { while }
  if Tok <> '' then
  begin
    if S2 <> '' then
      Result := Result + Tok else  //Schlusszeichen fehlt: wie normalen string behandeln
      Result := Result + ParseTok(Tok);
  end;
end;

function CreatePath(APath: string): boolean;
(* entspr. CreateDir aber mit bel. verschachtelten Verzeichnissen (c:\a\b\c) *)
var
  P1, P2: integer;
begin
  if CharN(APath) = '\' then
    APath := copy(APath, 1, length(APath) - 1);
  P1 := Pos('\', APath);
  P2 := PosR('\', APath);
  if P2 > P1 then
  begin
    CreatePath(copy(APath, 1, P2 - 1));            {Rekursion!}
  end;
  Result := CreateDir(APath);
end;

function CreateUniqueFileName(Maske: string): string;
//erzeugt leere Datei mit eindeutigem Namen. ergibt vollst. Dateinamen
//Maske-Platzhalter: #Y,#M,#D,#H,#N,#S = Jahr,Monat,Tag,Stunde,Minute,Sekunde
//                   #C = Counter (wird von 1 bis MaxInt hochgezählt bis Erfolg)
//                   #G = GUID (eindeutige Zufallszahl)
var
  aYear, aMonth, aDay, aHour, aMin, aSec, aMSec: Word;
  Year, Month, Day, Hour, Min, Sec: string;
  I, P1: integer;
  S, S1, S2: string;
  FH: DWORD;
begin
  DecodeDate(date, aYear, aMonth, aDay);
  DecodeTime(now, aHour, aMin, aSec, aMSec);
  Year := Format('%02.2d', [aYear mod 100]);
  Month := Format('%02.2d', [aMonth]);
  Day := Format('%02.2d', [aDay]);
  Hour := Format('%02.2d', [aHour]);
  Min := Format('%02.2d', [aMin]);
  Sec := Format('%02.2d', [aSec]);
  S := StringReplace(Maske, '#Y', Year, [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '#M', Month, [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '#D', Day, [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '#H', Hour, [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '#N', Min, [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '#S', Sec, [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '#G', CreateClassID36, [rfReplaceAll, rfIgnoreCase]);  //GUID bzw UUID ohne {}
  P1 := Pos('#C', S);
  if P1 > 0 then
  begin
    S1 := copy(S, 1, P1 - 1);
    S2 := copy(S, P1 + 2, MaxInt);
    for I := 1 to MaxInt do
    begin
      Result := S1 + IntToStr(I) + S2;
      //FH := FileCreate(Result);
      if not FileExists(Result) then               //Vermeidung von Exceptions
      try
        FH := CreateFile(PChar(Result),
                         0,                //dwDesiredAccess
                         0,                //dwShareMode
                         nil,                //lpSecurityAttributes
                         CREATE_NEW,       //Creates a new file. The function fails if the specified file already exists
                         FILE_ATTRIBUTE_NORMAL,  //dwFlagsAndAttributes
                         0);               //hTemplateFile
        if FH <> INVALID_HANDLE_VALUE then
        begin
          //I1 := FileWrite(FH, CRLF, 2);
          //FileClose(FH);
          CloseHandle(FH);
          //if I1 > 0 then
            break;
        end;
      except on E:Exception do
        EProt(Application, E, 'CreateUniqueFileName(%s):%d', [Maske, I]);
      end;
    end;
  end else
    Result := S;
end;

function ValidDir(S: string): string;
var
  S1: string;
begin //ergibt Verzeichnis mit Ende '\'. Leer bleibt leer.
  S1 := Trim(S);
  if (S1 <> '') and (CharN(S1) <> '\') then
    Result := S1 + '\' else
    Result := S1;
end;

function PartDir(S: string): string;
var
  S1: string;
begin //ergibt Verzeichnis ohne Ende '\'
  S1 := Trim(S);
  if CharN(S1) = '\' then
    Result := Trim(copy(S1, 1, length(S1) - 1)) else
    Result := S1;
end;

function DecodeEnvDir(S: string): string;
//ersetzt Environment-Variable (und %APPDIR%) mit tatsächlichem Wert

  function EncodeEnv(S: string): string;
  begin
    Result := GetEnvStrings.Values[S];  //enthält auch Appdir
    if Result = '' then
      Result :=  '%' + S + '%';        //wenn nicht in Env
  end;

var
  I, Step: integer;
  Env: string;
begin { EncodeEnvDir }
  Step := 0;
  Result := '';
  for I := 1 to length(S) do
  begin
    case Step of
0:    if S[I] = '%' then
      begin
        Step := 1;
      end else
        Result := Result + S[I];
1:    if S[I] = '%' then
      begin
        Result := Result + EncodeEnv(Env);
        Step := 0;
      end else
        Env := Env + S[I];
    end;
  end;
end;

function LengthSort(List: TStringList; Index1, Index2: Integer): Integer;
//einen Wert kleiner als 0, wenn sich der in Index1 angegebene String  vor dem in Index2 angegebenen befindet.
//Verglichen wird die Länge des Strings rechts vom '='. Längere zuerst.
begin
  Result := length(StrValue(List[Index2])) - length(StrValue(List[Index1]));
end;

function EncodeEnvDir(S: string): string;
//ersetzt Pfad mit (längster) Environment-Variablen (%TEMP%, %APPDATA%, usw.) und %APPDIR%

var
  I: integer;
  L: TStringList;
begin
  Result := S;
  L := TStringList.Create;
  try
    L.Assign(GetEnvStrings);  //mit AppDir
    L.CustomSort(LengthSort);
    ProtStrings(L, 'DecodeEnvDir');
    for I := 0 to L.Count - 1 do if length(StrValue(L[I])) > 0 then
    begin
      if BeginsWith(S, StrValue(L[I]), true) then
      begin
        Result := '%' + StrParam(L[I]) + '%' +
                  copy(S, 1 + length(StrValue(L[I])), MaxInt);
        break;
      end;
    end;
  finally
    L.Free;
  end;
end;

function WinDir: string;
{Pfad von Windows incl. \ }
var
  Buffer: array[0..250] of char;
begin
  GetWindowsDirectory(Buffer, sizeof(Buffer));
  //Result := Format('%s\', [StrPas(Buffer)]);
  Result := ValidDir(StrPas(Buffer));
end;

function WinSysDir: String;
{Pfad von Windows\System32 incl. \ (BG)}
var
  Buff: Array[0..256] of Char;
begin
  GetSystemDirectory(Buff,256);
  Result := ValidDir(StrPas(Buff));
end;

function IsWindowsNT: boolean;
//true=NT,Win2k,XP,Vista  false=Win95,98,ME
var
 OsVinfo: TOSVERSIONINFO;
begin
 Result :=false;
 ZeroMemory(@OsVinfo,sizeOf(OsVinfo));
 OsVinfo.dwOSVersionInfoSize := sizeof(TOSVERSIONINFO);
 if GetVersionEx(OsVinfo) then
   Result := OsVinfo.dwPlatformId = VER_PLATFORM_WIN32_NT;
end;

function IsWindows2000: boolean;
//true=ab Win2k
var
 OsVinfo: TOSVERSIONINFO;
begin
 Result :=false;
 ZeroMemory(@OsVinfo,sizeOf(OsVinfo));
 OsVinfo.dwOSVersionInfoSize := sizeof(TOSVERSIONINFO);
 if GetVersionEx(OsVinfo) then
   Result := (OsVinfo.dwPlatformId = VER_PLATFORM_WIN32_NT) and
             (OsVinfo.dwMajorVersion >= 5);
end;

function CtrlKeyDown: boolean;
// Strg-Taste ist gedrückt
begin
  Result := (Windows.GetKeyState(VK_CONTROL) and $8000) <> 0;
end;

function ShiftKeyDown: boolean;
// Umschalt-Taste ist gedrückt
begin
  Result := (Windows.GetKeyState(VK_SHIFT) and $8000) <> 0;
end;

function ProgDir: string;
{Pfad von c:\programme. Aus Registry}
var
  Res: boolean;
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create;
  try
    Reg.Rootkey := HKEY_LOCAL_MACHINE;
    Res := Reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion');
    if Res then
    begin
      Result := Reg.ReadString('ProgramFilesDir') + '\';
      Reg.CloseKey;
    end else
      Result := '';
  finally
    Reg.Free;
  end;
end;

function TempDir: string;
{Pfad von Temporärem Verzeichnis (TMP, TEMP) incl. \ }
//var Buffer: array[0..250] of char;
var
  S1: string;
begin
  //GetTempPath(sizeof(Buffer), Buffer); beware sizeof in Unicode!
  //Result := ValidDir(StrPas(Buffer));  if CharN(Result) <> '\' then Result := Result + '\';
  // Problem: Temppath = '...\temp \' <- hat #0 !!!
  S1 := StrCgeChar(TPath.GetTempPath, #0, #0);  // #0 entfernen
  Result := ValidDir(S1);  //'...\temp\'
end;

function AllUsersDir: string;
{ Pfad zu Anwendungsdaten für alle User
  XP: c:\Dokumente und Einstellungen\All Users\
  W7: c:\ProgramData\
}
begin
  Result := ValidDir(GetEnvStr('ALLUSERSPROFILE'));
end;

function AppParam(Param: string): string;
// ergibt Wert von Kommandozeile Parameter. Durchsucht ParamStr nach 'Param=<Result>'
// bei Param ohne Value gilt Result = Param.
var
  I: integer;
  ALine: string;
begin
  for I:= 1 to ParamCount do      // Aufrufparameter i.d.Form Param=Result}
  begin
    ALine := ParamStr(I);
    if CompareText(StrParam(ALine), Param) = 0 then
    begin
      Result := StrDflt(StrValue(ALine), ALine);  // Param -> Param
      Break;
    end;
  end;
end;

function AppDir: string;
{Pfad des EXE-Files. Sucht in Kommandozeile nach AppDir=}
const
  FAppDir: string = '';
var
  I: integer;
  ALine: string;
begin
  if FAppDir = '' then
  begin
    FAppDir := AppParam('AppDir');
    if FAppDir = '' then
      FAppDir := ExtractFilePath(Application.ExeName);
    FAppDir := ValidDir(FAppDir);  // if CharN(FAppDir) <> '\' then FAppDir := FAppDir + '\';
  end;
  Result := FAppDir;
end;

function AppDate: TDateTime;
{DateTime des EXE-Files}
var
  aFileHandle: integer;
  aFileDate: integer;
begin
  aFileHandle := FileOpen(Application.ExeName, fmOpenRead or fmShareDenyNone);
  aFileDate := FileGetDate(aFileHandle);
  Result := FileDateToDateTime(aFileDate);
end;

function AppVersion: string;
// Version des EXE-Files idF 6.23.1.0
// die XE2 GetFileVersion ist fehlerhaft (liefert nur 2 höchste Nummern)
var
  InternalName, Version: string;
begin
  GetFileInfo(InternalName, Version, Application.ExeName);
  Result := Version;
end;

function CompareVersion(Ver1, Ver2: string): integer;
// Vergleicht 2 Versionsstring. Ergibt -1:Ver1<Ver2 0:Ver2=Ver2 1:Ver1>Ver2
var
  I: integer;
begin
  for I := 1 to 4 do
  begin
    Result := CompareStr(TokenAt(Ver1, '.', I), TokenAt(Ver2, '.', I));
    if Result <> 0 then
      Break;
  end;
end;

function AppInternalName: string;
// Internal Name des EXE-Files
var
  InternalName, Version: string;
begin
  GetFileInfo(InternalName, Version, Application.ExeName);
  Result := InternalName;
end;

function ShortVersion(S: string): string;
//ergibt verkürzte Versionsdarstellung (0er bei Build und Ausgabe am Ende Weg)
//// 1.1.0.0 -> 1.1 aber 1.1.10.0 -> 1.1.10
begin
  Result := S;
  while (Length(Result) >= 3) and (Copy(Result, Length(Result) - 1, 2) = '.0') do
    Result := Copy(Result, 1, Length(Result) - 2);
end;

function CompName: string;
var  {Computer Name}
  sCompName: array[0..MAX_COMPUTERNAME_LENGTH + 1] of char;
  lCompName: DWORD;
begin
  lCompName := sizeof(sCompName);
  GetComputerName(sCompName, lCompName);
  Result := sCompName;
end;

function CompUserName: string;
var  {Computer User Name}
  sUserName: array[0..255] of char;
  lUserName: integer;
begin
  lUserName := sizeof(sUserName);
  GetUserName( sUserName, DWORD(lUserName));
  Result := sUserName;
end;

function GetIPAddress: string;
//eigene IP Adresse (von Windows Sockets DLL)
var
  phoste: PHostEnt;
  Buffer: array[0..100] of AnsiChar;
  WSAData: TWSADATA;
begin
  Result:='';
  if WSAStartup($0101, WSAData) <> 0 then
    exit;
  GetHostName(Buffer, Sizeof(Buffer));
  phoste := GetHostByName(buffer);
  if phoste = nil then
  begin
    Result := '127.0.0.1';
  end else
    Result := String(StrPas(inet_ntoa(PInAddr(phoste^.h_addr_list^)^)));
  WSACleanup;
end;

//function GetAdapterInfo(Lana: AnsiChar): String;
//var
//  Adapter: TAdapterStatus;
//  NCB: TNCB;
//begin
//  FillChar(NCB, SizeOf(NCB), 0);
//  NCB.ncb_command := AnsiChar(NCBRESET);
//  NCB.ncb_lana_num := Lana;
//  if Netbios(@NCB) <> AnsiChar(NRC_GOODRET) then
//  begin
//    Result := 'mac not found';
//    Exit;
//  end;
//
//  FillChar(NCB, SizeOf(NCB), 0);
//  NCB.ncb_command := AnsiChar(NCBASTAT);
//  NCB.ncb_lana_num := Lana;
//  NCB.ncb_callname := '*';
//
//  FillChar(Adapter, SizeOf(Adapter), 0);
//  NCB.ncb_buffer := @Adapter;
//  NCB.ncb_length := SizeOf(Adapter);
//  if Netbios(@NCB) <> AnsiChar(NRC_GOODRET) then
//  begin
//    Result := 'mac not found';
//    Exit;
//  end;
//  Result :=
//    IntToHex(Byte(Adapter.adapter_address[0]), 2) + '-' +
//    IntToHex(Byte(Adapter.adapter_address[1]), 2) + '-' +
//    IntToHex(Byte(Adapter.adapter_address[2]), 2) + '-' +
//    IntToHex(Byte(Adapter.adapter_address[3]), 2) + '-' +
//    IntToHex(Byte(Adapter.adapter_address[4]), 2) + '-' +
//    IntToHex(Byte(Adapter.adapter_address[5]), 2);
//end;

function GetMACAddress: string;
//ergibt die (eindeutige) Nummer der Netzwerkkarte
var
//  AdapterList: TLanaEnum;
//  NCB: TNCB;
  L: TStringList;
begin
//  FillChar(NCB, SizeOf(NCB), 0);
//  NCB.ncb_command := AnsiChar(NCBENUM);
//  NCB.ncb_buffer := @AdapterList;
//  NCB.ncb_length := SizeOf(AdapterList);
//  Netbios(@NCB);
//  if Byte(AdapterList.length) > 0 then
//    Result := GetAdapterInfo(AdapterList.lana[0])
//  else
//    Result := 'mac not found';
  L := TStringList.Create;
  try
    GetMacAddresses('', L);
    Result := L.CommaText;
  finally
    L.Free;
  end;
end;

function CheckUserAccount(Username, Password, Domain: string;
  var Reason: string): boolean;
// Check if a username/password exists on a system
// if parameter domain is left blank test is performed on the current domain
// http://www.delphipraxis.net/157854-windows-benutzerverwaltung-mitverwenden-2.html
// ergibt true wenn OK. Schreibt Fehlermeldung nach Reason, zB
// 1331: Anmeldung fehlgeschlagen: Das Konto ist zurzeit deaktiviert
// 1326: Anmeldung fehlgeschlagen: unbekannter Benutzername oder falsches Kennwort)
// 9999: kein Token
// 0: OK
var
  Token: THandle;
  N: DWORD;
begin
  if LogonUser(PChar(Username), PChar(Domain), PChar(Password),
    LOGON32_LOGON_INTERACTIVE, LOGON32_PROVIDER_DEFAULT, Token) then
  begin
    Result := Token <> 0;
    CloseHandle(Token);
    if Result then
      Reason := Format('0: OK. Token = %d.', [Token]) else
      Reason := '9999: kein Token';
  end else
  begin
    Result := False;
    N := GetLastError;
    Reason := Format('%d: %s', [N, SysErrorMessage(N)]);
//    case GetLastError of
//      ERROR_PRIVILEGE_NOT_HELD:
//        raise EJclCreateProcessError.CreateResFmt(@RsCreateProcPrivilegeMissing,
//          [GetPrivilegeDisplayName(SE_TCB_NAME), SE_TCB_NAME]);
//      ERROR_LOGON_FAILURE:
//        raise EJclCreateProcessError.CreateRes(@RsCreateProcLogonUserError);
//      ERROR_ACCESS_DENIED:
//        raise EJclCreateProcessError.CreateRes(@RsCreateProcAccessDenied);
  end;
  Prot0('CheckUserAccount(%s,%s):%s', [Username, Domain, Reason]);
end;

function GetLongPathName(const ShortName: string): string;
var
  P: array[0..MAX_PATH] of Char;
begin
  try
    StrCopy(P, PChar(ShortName));
    Result := StrPas(ToLongPath(P));
  except on E:Exception do
    EProt(Application, E, 'Error in GetLongPathName(%s):%d', [ShortName, MAX_PATH]);
  end;
end;

function GetEnvStr(VarName : string ) : string;
{Umgebungsvariable holen}
(* mit string statt PAnsiChar *)
// var
//   Len     : Word;
//   EnvStz  : PAnsiChar;
//   NameStz : array[ 0..180 ] of Char;
begin
  Result := GetEnvStrings.Values[VarName];
// 
//   StrPCopy(NameStz, VarName );     { Covert VarName to PAnsiChar }
//   Len := StrLen(NameStz );
// {$ifdef WIN32}
//   EnvStz := GetEnvironmentstrings;
// {$else}
//   EnvStz := GetDosEnvironment;      { EnvStz holds entire env}
// {$endif}
// 
//   while EnvStz^ <> #0 do   {#0 '#Konsante vom Typ Charakter mit Wert '0'}
//   begin                  { Pick off Variable Name and Compare }
//     if (StrLIComp(EnvStz, NameStz, Len ) = 0 ) and
//        (EnvStz[ Len ] = '=' ) then
//     begin          { Convert to Pascal string before returing }
//       Result := StrPas(EnvStz + Len + 1 );
//       Exit;
//     end;
//     Inc(EnvStz, StrLen(EnvStz ) + 1 );   { Jump to Next Var }
//   end;
//   Result := '';
end;

function GetEnvStrings: TStrings;
{Alle Umgebungsvariable holen und nach Strings schreiben. Mit Cache. Mit AppDir}
var
  EnvStz  : PChar;
  //NameStz : array[ 0..4096] of Char;
begin
  if EnvStrings = nil then
  try
    EnvStrings := TStringList.Create;
    EnvStrings.Add('APPDIR=' + PartDir(AppDir));
    EnvStrings.Add('PROGDIR=' + GetLongPathName(PartDir(ProgDir)));
    EnvStrings.Add('TEMPDIR=' + GetLongPathName(PartDir(TempDir)));
    ProtStrings(EnvStrings);  //nur unsere 3 listen

    EnvStz := GetEnvironmentstrings;
    //EnvStz := GetDosEnvironment;      //Win16

    while EnvStz^ <> #0 do   {#0 '#Konsante vom Typ Charakter mit Wert '0'}
    begin                  { Pick off Variable Name and Compare }
      EnvStrings.Add(StrPas(EnvStz));
      Inc(EnvStz, StrLen(EnvStz) + 1);   { Jump to Next Var }
    end;
    //ProtStrings(EnvStrings, '--- EnvironmentStrings ---');  //nur unsere 3 listen
  except on E:Exception do
    EProt(Application, E, 'Error in GetEnvString (%s)', [EnvStrings.Text]);
  end;
  Result := EnvStrings;
end;

function DiskFreeBde(RootPath: string): Int64;
// ergibt Anzahl freier Bytes aus BDE-Sicht, ist <4GB. RootPath: 'C:\', 'D:\', usw.
var
  lpSectorsPerCluster, lpBytesPerSector, lpNumberOfFreeClusters, lpTotalNumberOfClusters: DWORD;
begin
{$OVERFLOWCHECKS OFF}
  GetDiskFreeSpace(PChar(RootPath), lpSectorsPerCluster, lpBytesPerSector,
    lpNumberOfFreeClusters, lpTotalNumberOfClusters);
  Result := Int64(lpSectorsPerCluster * lpBytesPerSector * lpNumberOfFreeClusters);
end;

procedure FillDiskBde(AFillDir: string);
// füllt Laufwerk mit einer Datei die größer ist als DiskFreeBde,
// damit Bde unter die 'mod 4GB' kommt
var
  aFile: File;
  Buf: array[0..99] of char;
  S1: string;
  N, I: integer;
  N64: Int64;
  SearchRec: TSearchRec;
begin
  //erstmal die bestehenden Dateien entfernen (vielleicht hilfts):
  if SysUtils.FindFirst(ValidDir(AFillDir) + 'BdeFiller*.dat', faAnyFile, SearchRec) = 0 then
  try
    repeat
      SysUtils.DeleteFile(ValidDir(AFillDir) + SearchRec.Name);
    until SysUtils.FindNext(SearchRec) <> 0;
  finally
    SysUtils.FindClose(SearchRec);
  end;

  N64 := DiskFreeBde(Copy(AFillDir, 1, 2) + '\');  // C:\
  if N64 < 100 * 1024 * 1024 then
  begin  // nur wenn weniger als 100MB frei - 22.12.10
    N := N64 div 100 + 11;  //etwas mehr als 'free' angeben, so dass nächster 4GB Block zählt
    Prot0('FillDiskBde: %d Bytes', [N * sizeof(Buf)]);
    FillChar(Buf, sizeof(Buf), 0);
    StrCopy(@Buf[0], 'FillDiskBde');
    S1 := CreateUniqueFileName(ValidDir(AFillDir) + 'BdeFiller#C.dat');
    AssignFile(aFile, S1);
    Rewrite(aFile, 1);
    try
      for I := 1 to N do
        BlockWrite(aFile, Buf, sizeof(Buf));
    except on E:Exception do
      EProt(Application, E, 'FillDiskBde(%s)', [AFillDir]);
    end;
    CloseFile(aFile);
  end;
end;

function DirExists(ADir: string): boolean;
(* ergibt true wenn Verzeichnis existiert *)
var
  SearchRec: TSearchRec;
begin
  Result := SysUtils.FindFirst(ADir, faDirectory, SearchRec) = 0;
  SysUtils.FindClose(SearchRec);
end;

function FileFound(Mask: string; var FileName: string): boolean;
//true=mind. 1 FileName wurde gefunden welcher Mask entspricht.
var
  sr: TSearchRec;
begin
  Result := false;
  //faVolumeID not used in win32
  if SysUtils.FindFirst(Mask, faAnyFile - faDirectory, sr) = 0 then
  begin
    FileName := ValidDir(ExtractFilePath(Mask)) + sr.Name;
    SysUtils.FindClose(sr);
    Result := true;
  end;
end;

function GraphicFileFound(aName: string; var FileName: string): boolean;
//sucht Bilddatei <aName> in Verzeichnissen Appdir und bmp\Appdir
//und im aktuellen bzw. im in <aName> angegebenenVerzeichnis.
//ergibt true wenn gefunden und liefert dann vollständigen Namen in <FileName
//Extensions: *.gif;*.jpg;*.jpeg;*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf (wie TOpenPictureDialog)
var
  SL: TValueList;
  S: string;
  I: integer;
begin
  Result := false;
  SL := TValueList.Create;
  try
    SL.AddTokens(GraphicFileMask(TGraphic), ';');
    for I := 0 to SL.Count - 1 do
    begin
      S := aName + ExtractFileExt(SL[I]);
      if FileExists(S) then
      begin
        FileName := S;
        Result := true;
        break;
      end;
      S := AppDir + aName + ExtractFileExt(SL[I]);
      if FileExists(S) then
      begin
        FileName := S;
        Result := true;
        break;
      end;
      S := AppDir + 'bmp\' + aName + ExtractFileExt(SL[I]);
      if FileExists(S) then
      begin
        FileName := S;
        Result := true;
        break;
      end;
    end;
  finally
    SL.free;
  end;
end;

procedure LoadBitmapFromGraphicStream(aStream: TStream; aBitmap: TBitmap);
// füllt Bitmap mit Inhalt von Stream. Wandelt jpg, gif, png nach bmp um.
// [http://stackoverflow.com/questions/959160/load-jpg-gif-bitmap-and-convert-to-bitmap]
// Exception bei Fehler
//26.03.12 mit PNG und GIF
var
  FirstBytes: AnsiString;
  Graphic: TGraphic;
begin
  Graphic := nil;
  AStream.Seek(0, soFromBeginning);

  SetLength(FirstBytes, 8);
  AStream.Read(FirstBytes[1], 8);
  if Copy(FirstBytes, 1, 2) = 'BM' then
  begin
    Graphic := TBitmap.Create;
  end else
  // D5 erst installieren: http://www.torry.net/quicksearchd.php?String=png&Title=Yes
  if FirstBytes = #137'PNG'#13#10#26#10 then
  begin
    Graphic := TPngImage.Create;
  end else
  //D2010 immer aktiv - {$IFDEF USEGIF}
  if Copy(FirstBytes, 1, 3) =  'GIF' then
  begin
    Graphic := TGIFImage.Create;
  end else
  //{$ENDIF}
  if Copy(FirstBytes, 1, 2) = #$FF#$D8 then
  begin
    Graphic := TJPEGImage.Create;
  end;
  if Assigned(Graphic) then
  begin
    try
      AStream.Seek(0, soFromBeginning);
      Graphic.LoadFromStream(AStream);
      aBitmap.Assign(Graphic);
    finally
      Graphic.Free;
    end;
  end else
    EError('unbekannter Graphic Typ (%s)', [FirstBytes]);
end;

function ZoomOutBitmap(aBitmap: TBitmap; var ToWidth, ToHeight: integer): TBitmap;
//verkleinert Bitmap (Seitenverhältnis bleibt) auf die angegebene Größe
//ergibt neues Bitmap (muss freigegeben werden). n.b. weil oberer Rand fehlt
var
  FromWidth, FromHeight: integer;
  FromRatio, ToRatio, Zoom: double;
  ToRect: TRect;
begin
  FromWidth := aBitmap.Width;
  FromHeight := aBitmap.Height;
  FromRatio := FromWidth / FromHeight;
  ToRatio := ToWidth / ToHeight;
  Zoom := 1;
  Zoom := FloatMin(Zoom, ToWidth / FromWidth);
  Zoom := FloatMin(Zoom, ToHeight / FromHeight);
  Result := TBitmap.Create;
  Result.Width := ToWidth;    //ganz wichtig!
  Result.Height := ToHeight;
  if Zoom < 1 then  //nur verkleinern
  begin
    if FromRatio >= ToRatio then  //Bild sehr breit. Höhe verkleinern
    begin
      ToHeight := MulDiv(ToWidth, 1000, Round(FromRatio * 1000));
    end else
    begin
      ToWidth := MulDiv(ToHeight, Round(FromRatio * 1000), 1000);
    end;
    ToRect := Rect(0, 0, ToWidth, ToHeight);

    Result.Canvas.StretchDraw(ToRect, ABitmap); //so sollte es sein
  end else
    Result.Canvas.Draw(0, 0, ABitmap); //Bitmap ist kleiner als die Image-Fläche
end;

procedure ImageLoadOutZoomed(aImage: TImage; aFilename: string);
//Lädt Bitmap so dass verkleinert wird aber das Seitenverhältnis bleibt.
var
  CenterX, CenterY: integer;
  MaxWidth, MaxHeight: integer;
  MaxRatio, Ratio, Zoom: double;
begin
  CenterX := aImage.Left + (aImage.Width div 2);
  CenterY := aImage.Top + (aImage.Height div 2);
  //Pic mit Autosize laden. Höhen/Breitenverhältnis auf aImage kopieren. Autosize=false;Stretch=true
  MaxWidth := aImage.Width;
  MaxHeight := aImage.Height;
  MaxRatio := aImage.Width / aImage.Height;
  aImage.Autosize := true;
  aImage.Picture.LoadFromFile(aFilename);
  Ratio := aImage.Width / aImage.Height;
  Zoom := 1;
  Zoom := FloatMin(Zoom, MaxWidth / aImage.Width);
  Zoom := FloatMin(Zoom, MaxHeight / aImage.Height);
  if Zoom < 1 then  //verkleinern
  begin
    aImage.Autosize := false;
    aImage.Stretch := true;
    if Ratio >= MaxRatio then  //Bild sehr breit. Höhe verkleinern
    begin
      aImage.Width := MaxWidth;
      aImage.Height := MulDiv(aImage.Width, 1000, Round(Ratio * 1000));
    end else
    begin
      aImage.Height := MaxHeight;
      aImage.Width := MulDiv(aImage.Height, Round(Ratio * 1000), 1000);
    end;
  end;
  if aImage.Center then
  begin
    aImage.Left := CenterX - (aImage.Width div 2);
    aImage.Top := CenterY - (aImage.Height div 2);
  end;
end;

procedure ReadlnOem(var F: TextFile; var S: string);
(* Liest Zeile, konvertiert von Oem nach Ansi, nach S *)
var
  Str: PAnsiChar;
begin
  Str := nil;  //wg Compilerwarnung
  Readln(F, S);
  if length(S) > 0 then
  try
    Str := StrPNew(AnsiString(S));
    OemToAnsi(Str, Str);
    S := String(StrPas(Str));
  finally
    StrDispose(Str);
  end;
end;

procedure WriteOem(var F: TextFile; const Fmt: string; const Args: array of const);
(* Schreibt Formatiert auf Textfile mit OEM Zeichen-Umwandlung *)
var
  Str: PAnsiChar;
begin
  Str := StrPNew(AnsiString(Format(Fmt, Args)));
  try
    AnsiToOem(Str, Str);
    Write(F, StrPas(Str));
  finally
    StrDispose(Str);
  end;
end;

function StrToOem(S: string): string;
(* Ergibt Oem String anhand Ansi-String S *)
var
  Str: PAnsiChar;
begin
  Str := StrPNew(AnsiString(S));
  try
    AnsiToOem(Str, Str);
    Result := String(StrPas(Str));
  finally
    StrDispose(Str);
  end;
end;

function StrToAnsi(S: string): string;
(* Ergibt Ansi String anhand Oem-String S *)
var
  Str: PAnsiChar;
begin
  Str := StrPNew(AnsiString(S));
  try
    OemToAnsi(Str, Str);
    Result := String(StrPas(Str));
  finally
    StrDispose(Str);
  end;
end;

function StrToWideString(const S: AnsiString; const CodecAlias: string): WideString;
// Ergibt UTF8 String anhand Ansi und Codec-Alias ('ISO-8859-2')
// Windows Codepage: 'windows-1250'
var
  codec: TUnicodeCodec;
begin
  codec := TEncodingRepository.CreateCodecByAlias(CodecAlias);
  codec.DecodeStr(Pointer(S), Length(S), Result);
end;

function StrToWideString(const S: AnsiString; const Codepage: integer): WideString;
// Ergibt UTF8 String anhand Ansi und Windows-Codepage (1250)
var
  CodecAlias: string;
begin
  case Codepage of
    874  : CodecAlias := 'cp874';            // Thai
    932  : CodecAlias := 'cp932';            // Japan
    936  : CodecAlias := 'cp936';            // Chinese (PRC, Singapore)
    949  : CodecAlias := 'cp949';            // Korean
    950  : CodecAlias := 'cp950';            // Chinese (Taiwan, Hong Kong)
    1200 : CodecAlias := 'ISO-10646-UCS-2';  // Unicode (BMP of ISO 10646)
    1250 : CodecAlias := 'windows-1250';     // Windows 3.1 Eastern European
    1251 : CodecAlias := 'windows-1251';     // Windows 3.1 Cyrillic
    1252 : CodecAlias := 'windows-1252';     // Windows 3.1 Latin 1 (US, Western Europe)
    1253 : CodecAlias := 'windows-1253';     // Windows 3.1 Greek
    1254 : CodecAlias := 'windows-1254';     // Windows 3.1 Turkish
    1255 : CodecAlias := 'windows-1255';     // Hebrew
    1256 : CodecAlias := 'windows-1256';     // Arabic
    1257 : CodecAlias := 'windows-1257';     // Baltic
  else
    CodecAlias := 'windows-1252';  //15.12.11 Standard
  end;
  Result := StrToWideString(S, CodecAlias);
end;

function StrToHtml(S: string): string;
(* Ergibt Html String mit umgewandelten Umlauten *)
var
  I, P: integer;
  function CharToHtml(Ch: Char): string;
  begin
    case Ch of
      'ä': Result := '&auml;';
      'ö': Result := '&ouml;';
      'ü': Result := '&uuml;';
      'Ä': Result := '&Auml;';
      'Ö': Result := '&Ouml;';
      'Ü': Result := '&Uuml;';
      'ß': Result := '&szlig;';
      '§': Result := '&sect;';
      '€': Result := '&euro;';
      else Result := Ch;
    end;
  end;
begin
  Result := '';
  P := Pos(CRLF, S);
  if P > 0 then
  begin
    if length(S) > 2 then
      if P = 1 then
        Result := StrToHtml(copy(S, P + 2, length(S))) else
        Result := '<p>' + StrToHtml(copy(S, 1, P - 1)) + '</p>' +
                  StrToHtml(copy(S, P + 2, length(S)) + CRLF);
  end else
  begin
    for I := 1 to length(S) do
      Result := Result + CharToHtml(S[I]);
  end;
end;

function HtmlToText(const _html: string): string;
//wandelt HTML in Text um
var
  WebBrowser: TWebBrowser;
  Document: IHtmlDocument2;
  Doc: OleVariant;
  v: Variant;
  Body: IHTMLBodyElement;
  TextRange: IHTMLTxtRange;
begin
  Result := '';
  WebBrowser := TWebBrowser.Create(nil);
  try
    Doc := 'about:blank';
    WebBrowser.Navigate2(Doc);
    Document := WebBrowser.Document as IHtmlDocument2;
    if (Assigned(Document)) then
    begin
      v := VarArrayCreate([0, 0], varVariant);
      v[0] := _html;
      Document.Write(PSafeArray(TVarData(v).VArray));
      Document.Close;
      Body := Document.body as IHTMLBodyElement;
      TextRange := Body.createTextRange;
      Result := TextRange.text;
    end;
  finally
    WebBrowser.Free;
  end;
end;

function ConvertEOL(Src: string; OpSys: TOpSys = osWIN): string;
//Konvertiert einen mehrzeiligen string die Zeilentrenner bzgl. Betriebssystem
//Siehe dazu projekt ..\query\converteol.dpr
const
  Eols: array[TOpSys] of string = ((#13#10), (#10), (#13));
var
  I, Step, N: integer;
  EndStr: string;
  C: char;
  procedure WriteEol;
  begin
    Result := Result + Eols[OpSys];
    if (EndStr <> #13#10) and (OpSys = osWIN) then Inc(N) else
    if (EndStr <> #10#10) and (EndStr <> #10) and (OpSys = osUNIX) then Inc(N) else
    if (EndStr <> #13#13) and (EndStr <> #13) and (OpSys = osMAC) then Inc(N);
  end;
begin
  Result := '';
  N := 0;
  Step := 1;
  for I := 1 to length(Src) do
  begin
    C := Src[I];
    case Step of
      1: begin
           if CharInSet(C, [#10, #13]) then
           begin
             EndStr := C;
             Step := 2;
           end else
             Result := Result + C;
         end;
      2: begin
           if CharInSet(C, [#10, #13]) then
             EndStr := EndStr + C;
           WriteEol;
           if (EndStr <> #13#10) and (EndStr <> #10#13) and (length(EndStr) = 2) then
             WriteEol;
           if not CharInSet(C, [#10, #13]) then
             Result := Result + C;
           Step := 1;
         end;
    end;
  end;
end;

procedure WriteFmt(var F: TextFile; const Fmt: string; const Args: array of const);
(* Schreibt Formatiert auf Textfile *)
begin
  Write(F, Format(Fmt, Args));
end;

function StmWrite(Stm: TStream; const AString: string): longint;
//Schreibt String nach Stream
var
  LBytes: SysUtils.TBytes;
  AEncoding: TEncoding;
begin
  AEncoding := TEncoding.Default;  //ANSI-Standardcodeseite des Betriebssystems
  LBytes := AEncoding.GetBytes(AString);
  Result := Stm.Write(LBytes[0], Length(LBytes));  //von TStringStream.WriteString

  //D5 - Result := Stm.Write(PChar(AString)^, Length(AString));  //von TStringStream.WriteString
end;

function StmWriteLn(Stm: TStream; const AString: string): longint;
//Schreibt String und Zeilenumbruch nach Stream
begin
  Result := StmWrite(Stm, AString + CRLF);
end;

function StmWriteFmt(Stm: TStream; const Fmt: string; const Args: array of const): longint;
//Schreibt FormatString nach Stream
begin
  Result := StmWrite(Stm, Format(Fmt, Args));
end;

function StmWriteLnFmt(Stm: TStream; const Fmt: string; const Args: array of const): longint;
//Schreibt FormatString und Zeilenumbruch nach Stream
begin
  Result := StmWrite(Stm, Format(Fmt, Args) + CRLF);
end;

procedure InsertStr(Source: string; var S: string; Index: Integer);
begin
  {while Index-1 > length(Source) do
    Source := Source + ' ';   leak}
  if Index-1 > length(Source) then
    Source := Format('%s%*s', [Source, Index-1 - length(Source), ' ']);
  if Index > length(Source) then
    Source := Format('%s%s', [Source, S]) else
    System.Insert(Source, S, Index);
end;

procedure AddStr(var Dest: string; const S: string);
begin        {wie AppendStr aber ohne Leak}
  Dest := Format('%s%s', [Dest, S]);    //hört bei 4107 auf - 06.06.12
end;

function GetAppendTok(const Dest: string; const Tok, Trenner: string): string;
begin  {wie AppendTok aber ohne Änderung des Quellstrings. Für Properties}
  Result := Dest;
  AppendTok(Result, Tok, Trenner);
end;

function GetAppendUniqueTok(const Dest: string; const Tok, Trenner: string;
  IgnoreCase: boolean): string;
begin  {wie AppendUniqueTok aber ohne Änderung des Quellstrings. Für Properties}
  Result := Dest;
  AppendUniqueTok(Result, Tok, Trenner, IgnoreCase);
end;

procedure AppendTok(var Dest: string; const Tok, Trenner: string);
{ergänzt Dest mit Tok, getrennt mit Trenner}
begin
  if Dest = '' then
    Dest := Tok else
  if Tok <> '' then                             {neu 140400 ISA.POSI.REPOSRE}
  begin
    if (length(Dest) >= length(Trenner)) and
       (copy(Dest, length(Dest) - length(Trenner) + 1, length(Trenner)) =
        Trenner) then
    begin
      AddStr(Dest, Tok);
    end else
      AddStr(Dest, Trenner + Tok);
  end;
end;

function AppendUniqueTok(var Dest: string; const Tok, Trenner: string;
  IgnoreCase: boolean): boolean;
{ ergänzt Dest mit Tok. Aber nur wenn Tok nicht vorhanden
  ergibt true wenn ergänzt wurde. }
var
  S, NextS: string;
  function Found: boolean;
  begin
    if IgnoreCase then
      Result := CompareText(S, Tok) = 0 else
      Result := S = Tok;
  end;
begin {AppendUniqueTok}
  Result := false;
  S := PStrTok(Dest, Trenner, NextS);
  while (S <> '') and not Found do
    S := PStrTok('', Trenner, NextS);
  if S = '' then
  begin
    AppendTok(Dest, Tok, Trenner);
    Result := true;
  end;
end;

procedure DeleteTok(var Dest: string; const Tok, Trenner: string;
  IgnoreCase: boolean); {löscht Tok in Desk wenn vorhanden}
var
  P: integer;
begin
  if IgnoreCase then
    P := Posi(Tok, Dest) else
    P := Pos(Tok, Dest);
  if P > 0 then
  begin
    Delete(Dest, P, length(Tok) + length(Trenner));
    if (length(Dest) >= length(Trenner)) and
       (copy(Dest, length(Dest) - length(Trenner) + 1, length(Trenner)) =
        Trenner) then
    begin
      Delete(Dest, length(Dest) - length(Trenner) + 1, length(Trenner));
    end;
  end;
end;

function PStrTok(S: string; DivToks: array of string; var NextS: string;
  doTrim: boolean = false): string;
{Token holen. Trenner ist beliebiger String in DivToks}
var
  P, P1: integer;
  DivS: string;
  DI1, DI: integer;
begin
  Result := '';
  DI := 0;  //wg Compilerwarnung
  if (S <> '') and (S <> NextS) then
    NextS := S;
  if NextS = '' then
    Exit;
  P := 0;
  for DI1 := 0 to length(DivToks) - 1 do
  begin
    DivS := DivToks[DI1];
    if DivS = '' then
      continue;
    while BeginsWith(NextS, DivS) do
      System.Delete(NextS, 1, length(DivS));
    P1 := Pos(DivS, NextS);
    if P = 0 then
    begin
      P := P1;
      DI := DI1;
    end else
    if (P > P1) and (P1 > 0) then
    begin
      P := P1;
      DI := DI1;
    end;
  end;
  if P > 0 then
  begin
    Result := copy(NextS, 1, P - 1);
    NextS := copy(NextS, P + length(DivToks[DI]), MaxInt);
  end else
  begin
    Result := NextS;
    NextS := '';
  end;
  if doTrim then
    Result := Trim(Result);
end;

function PStrTokNext(DivToks: array of string; var NextS: string; doTrim: boolean = false): string;
begin
  Result := PStrTok('', DivToks, NextS);
end;

function PStrTokNext(DivChars: string; var NextS: string; doTrim: boolean = false): string;
begin
  Result := PStrTok('', DivChars, NextS);
end;

function PStrTok(S: AnsiString; DivChars: AnsiString; var NextS: AnsiString; doTrim: boolean = false): AnsiString;
//Ansi Version
var
  WideNextS: string;
begin
  WideNextS := String(NextS);
  Result := AnsiString(PStrTok(String(S), String(DivChars), WideNextS, doTrim));
  NextS := AnsiString(WideNextS);
end;

function PStrTok(S: string; DivCharSet: TSysCharSet; var NextS: string; doTrim: boolean = false): string;
// Trenner sind Zeichen in DivCharSet
begin
  Result := PStrTok(S, CharSetToStr(DivCharSet), NextS, doTrim);
end;

function PStrTok(S: string; DivChars: string; var NextS: string; doTrim: boolean = false): string;
{Token holen. Trenner ist beliebiges Zeichen in DivChars}
var
  I, P, P1: integer;
begin                                  //Bsp: '+23+4#5#', '#+'
  Result := '';
  if (S <> '') and (S <> NextS) then
    NextS := S;
  if NextS = '' then
    Exit;
  if DivChars <> '' then
  begin
    while (length(NextS) > 0) and (Pos(NextS[1], DivChars) > 0) do
      System.Delete(NextS, 1, 1);      //Bsp: '23+4#5#',
    P := 0;
    for I := 1 to length(DivChars) do
    begin
      P1 := Pos(DivChars[i], NextS);   //Bsp: '#','+'
      if P = 0 then
        P := P1 else                   //Bsp: '23+4[#]5#',
      if P1 > 0 then
        P := IMin(P, P1);              //Bsp: '23[+]4#5#',
    end;
    if P > 0 then
    begin
      Result := copy(NextS, 1, P-1);
      NextS := copy(NextS, P+1, length(NextS));
      if doTrim then
        Result := Trim(Result);
      Exit;
    end;
  end;
  if doTrim then
    Result := Trim(NextS) else
    Result := NextS;
  NextS := '';
end;

function StrTok(S, DivChars: PAnsiChar; var NextStr: PAnsiChar): PAnsiChar;
var
  DivScan: PAnsiChar;
begin
  Result:= nil;
  if S <> nil then
    NextStr:= S;
  if NextStr = nil then
    Exit;
  if DivChars = nil then
    Exit;
  while NextStr^ <> #0 do                                { First skip separators }
  begin
    DivScan:= DivChars;
    while DivScan^ <> #0 do
    begin
      if DivScan^ = NextStr^ then
        Break;           {NextStr is a divider}
      Inc(DivScan);
    end;
    if DivScan^ = #0 then
      Break;             {if NextStr is not in DivChars, it is start of new token}
    Inc(NextStr);
  end;
  if NextStr^ = #0 then
    Exit;                {no token found before end of string, return nil}
  Result:= NextStr;
  {Now look for end of token}
  Inc(NextStr);
  while NextStr^ <> #0 do
  begin
    DivScan:= DIvChars;
    while DivScan^ <> #0 do
    begin
      if DivScan^ = NextStr^ then
      begin            {found a divider, will become end of token}
        NextStr^:= #0;   {replace divider char with end of string}
        Inc(NextStr);    {point past end of string for next call}
        Exit;
      end;
      Inc(DivScan);
    end;
    Inc(NextStr);       {NextStr^ not a divider, point to next char}
  end;
  {if we get here, we've reached the end of the string, which will become the end of the
    returned token}
end;

function StrTok(S, DivChars: PWideChar; var NextStr: PWideChar): PWideChar;
var
  DivScan: PWideChar;
begin
  Result:= nil;
  if S <> nil then
    NextStr:= S;
  if NextStr = nil then
    Exit;
  if DivChars = nil then
    Exit;
  while NextStr^ <> #0 do                                { First skip separators }
  begin
    DivScan:= DivChars;
    while DivScan^ <> #0 do
    begin
      if DivScan^ = NextStr^ then
        Break;           {NextStr is a divider}
      Inc(DivScan);
    end;
    if DivScan^ = #0 then
      Break;             {if NextStr is not in DivChars, it is start of new token}
    Inc(NextStr);
  end;
  if NextStr^ = #0 then
    Exit;                {no token found before end of string, return nil}
  Result:= NextStr;
  {Now look for end of token}
  Inc(NextStr);
  while NextStr^ <> #0 do
  begin
    DivScan:= DIvChars;
    while DivScan^ <> #0 do
    begin
      if DivScan^ = NextStr^ then
      begin            {found a divider, will become end of token}
        NextStr^:= #0;   {replace divider char with end of string}
        Inc(NextStr);    {point past end of string for next call}
        Exit;
      end;
      Inc(DivScan);
    end;
    Inc(NextStr);       {NextStr^ not a divider, point to next char}
  end;
  {if we get here, we've reached the end of the string, which will become the end of the
    returned token}
end;

function IndexOfToken(AToken, S, DivChars: string; IgnoreCase: boolean = false): integer;
(* ergibt Index des Tokens <AToken> (ab 0) in String mit mehreren Tokens mit <DivChars> getrennt
   oder -1 wenn nicht gefunden *)
var
  T, NextS: string;
  I: integer;
  B: boolean;
begin
  Result := -1;
  I := -1;
  T := PStrTok(S, DivChars, NextS, true);
  while T <> '' do
  begin
    I := I + 1;
    //if T = AToken then
    if IgnoreCase then
      B := AnsiSameText(T, AToken) else
      B := AnsiSameStr(T, AToken);
    if B then
    begin
      Result := I;
      break;
    end;
    T := PStrTok('', DivChars, NextS, true);
  end;
end;

function TokenAt(S: string; DivChars: string; AtPos: integer): string;
// Ergibt Token an der Position <AtPos> (ab 1 gezählt) oder ''
var
  S1, NextS: string;
  I: integer;
begin
  Result := '';
  I := 0;
  S1 := PStrTok(S, DivChars, NextS);
  while S1 <> '' do
  begin
    Inc(I);
    if I = AtPos then
    begin
      Result := S1;
      break;
    end;
    S1 := PStrTok('', DivChars, NextS);
  end;
end;

function TokenCount(S: string; DivChars: string): integer;
// Ergibt Anzahl der Tokens
var
  S1, NextS: string;
begin
  Result := 0;
  S1 := PStrTok(S, DivChars, NextS);
  while S1 <> '' do
  begin
    Inc(Result);
    S1 := PStrTok('', DivChars, NextS);
  end;
end;

procedure StrTokenize(S: string; DivCharSet: TSysCharSet; SL: TStrings;
  IncludeTrenner: boolean; doTrim: boolean = false);
//ergänzt SL mit den Tokens in S.
// IncludeTrenner: gibt in SL auch die Trenner aus: Concat der SL.Items ergibt S.
var
  I, Step: integer;
  S1: String;
  IsTrenner: boolean;
begin
  Step := -1;
  S1 := '';
  IsTrenner := false;  //Compiler
  for I := 1 to Length(S) do
  begin
    IsTrenner := CharInSet(S[I], DivCharSet);
    if not IsTrenner and doTrim and (S[I] = ' ') then
      Continue;  //Blanks ignorieren
    case Step of
    -1: begin
          S1 := S1 + S[I];
          if IsTrenner then
            Step := 1 else
            Step := 0;
        end;
     0: if IsTrenner then
        begin
          SL.Add(S1);
          S1 := S[I];
          Step := 1;
        end else
          S1 := S1 + S[I];
     1: if not IsTrenner then
        begin
          if IncludeTrenner then
            SL.Add(S1);
          S1 := S[I];
          Step := 0;
        end else
          S1 := S1 + S[I];
    end;  //case
  end;
  if S1 <> '' then
  begin
    if IncludeTrenner or not IsTrenner then
      SL.Add(S1);
  end;
end;

// es güngt erstmal dir char-Vriante
//function CharCount(AChar: string; S: string; IgnoreCase: boolean = false): integer;
//// Ergibt Anzahl der AChar in S
//var
//  I, L: integer;
//begin
//  Result := 0;
//  L := Length(AChar);
//  if L <= 0 then
//    Exit;
//  for I := 1 to Length(S) - (L - 1) do
//  begin
//    if (IgnoreCase and (CompareText(AChar, Copy(S, I, L) = 0)) or
//       (AChar = Copy(S, I, L)) then
//      Inc(Result);
//  end;
//end;

procedure StrDelete(Str: PAnsiChar; Index, Count:Integer);
(* wie System.Delete, aber mit PAnsiChar *)
begin
  StrMove(Str+Index, Str+Index+Count, StrLen(Str+Index+Count) + 1);
end;

procedure StrDelete(Str: PWideChar; Index, Count:Integer);
(* wie System.Delete, aber mit PAnsiChar *)
begin
  StrMove(Str+Index, Str+Index+Count, StrLen(Str+Index+Count) + 1);
end;

function CompareTextLen(const S1, S2: string; Len: integer): Integer;
(* Textvergleich der ersten <Len> Zeichen *)
begin
  Result := CompareText(copy(S1, 1, Len), copy(S2, 1, Len));
end;

function SameText(const S1, S2: string): Boolean;
(* Wie AnsiSameText ohne Ansi *)
begin
  Result := CompareText(S1, S2) = 0;
end;

procedure FileClearReadOnly(const Filename: string);
//faReadOnly weg
//kann Readonly werden wenn Filename vorher als Anhang aus E-Mail geöffnet wurde.
var
  Attrs: integer;
begin
  if FileExists(Filename) then
  begin
    Attrs := FileGetAttr(Filename);
    if Attrs and SysUtils.faReadOnly <> 0 then
      FileSetAttr(Filename, Attrs - SysUtils.faReadOnly);
  end;
end;

function GetFileCount(Directory, FileMask: string; Recurse: boolean): integer;
// Ergibt Anzahl Files in einem Verzeichnis (ohne Directories).
// Mask: wenn '' dann gilt '*.*'. Recurse: auch Unterverzeichnisse durchzählen
var
  sr: TSearchRec;
begin
  Result := 0;
  FileMask := StrDflt(Trim(FileMask), '*.*');
  Directory := ValidDir(Directory);
  //if FindFirst(Directory + FileMask, faAnyFile, sr) = 0 then
  //faReadOnly, faHidden, faSysFile, faVolumeID nicht scannen!
  if FindFirst(Directory + FileMask, faDirectory + faArchive, sr) = 0 then
  repeat
    if Char1(sr.Name) <> '.' then
    begin
      if (sr.Attr and faDirectory) <> 0 then
      begin
        if Recurse then
          Result := Result + GetFileCount(Directory + sr.Name, FileMask, Recurse);
      end else
        Result := Result + 1;
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
end;

function DelDir(const DirName: string): boolean;
//löscht Verzeichnisbaum auch wenn er nicht leer ist
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom  := PChar(DirName + #0);
  end;
  Result := (0 = ShFileOperation(fos));
  if not Result then
  begin
    CopyFileError := GetLastError;
    Prot0('DelDir:%d(%s)', [CopyFileError, SysErrorMessage(CopyFileError)]);
  end;
end;

function GetFileSize(const FileName: string): longint;
(* ermittelt die Filegröße anhand des Filenamens. Öffnet nicht *)
var
  SearchRec: TSearchRec;
begin
  if SysUtils.FindFirst(FileName, faAnyFile - faDirectory, SearchRec) = 0 then
  begin
    Result := SearchRec.Size;
  end else
    Result := -1;    {nicht gefunden}
  SysUtils.FindClose(SearchRec);
end;

function GetFileDateTime(const FileName: string): TDateTime;
// ermittelt das Filedatum als TDateTime anhand des Filenamens. Öffnet nicht
// ergibt 0 wenn File nicht gefunden.
//var
//  Age: integer;
begin
  if not FileAge(FileName, Result) then
    Result := 0;
//  Age := FileAge(FileName);
//  if Age > 0 then
//  begin
//    Result := FileDateToDateTime(Age);
//  end else
//    Result := 0;
end;

function SetFileDateTime(const FileName: string; DateTime: TDateTime): boolean;
// setzt das Filedatum als TDateTime.
// ergibt false wenn File nicht gefunden oder anderer Fehler.
var
  Age: integer;
  aFileHandle: integer;
  Err: integer;
begin
  Result := false;
  try
    aFileHandle := FileOpen(FileName, fmOpenWrite);
    if aFileHandle < 0 then  //ergibt negativen DOS Fehlercode bei Fehler
      EError('Error %d at FileOpen', [aFileHandle]);
    try
      Age := DateTimeToFileDate(DateTime);
      Err := FileSetDate(aFileHandle, Age);  //ergibt GetLastError bei Fehler oder 0
      if Err <> 0 then
        EError('FileSetDate:%d(%s)', [Err, SysErrorMessage(Err)]);
      Result := true;
    finally
      FileClose(aFileHandle);
    end;
  except on E:Exception do
    EProt(Application, E, 'SetFileDateTime(%s)', [FileName]);
  end;
end;

function DiffFileDateTime(const FileName: string; DateTime: TDateTime): integer;
//ergibt Differenz von File zu DateTime in Sekunden. Ist postiv wenn File neuer.
var
  FileDT, DiffDT: TDateTime;
begin
  FileDT := GetFileDateTime(FileName);
  DiffDT := FileDT - DateTime;
  Result := Round(DiffDT * SecsPerDay);
end;

function CopyFile(const FromName, ToName: string): Boolean;
// File über Shell kopieren. Ergibt true bei Erfolg.
var
  L: TStringList;
begin
  Prot0('CopyFile(%s -> %s)', [FromName, ToName]);
  //besser: mit Shell - 06.09.08
  L := TStringList.Create;
  try
    L.Add(FromName);
    Result := ShellFileOperation(L, ToName, FO_COPY, FOF_NOCONFIRMATION);
    if not Result then
    begin
      CopyFileError := GetLastError;
      Prot0('%d(%s)', [CopyFileError, SysErrorMessage(CopyFileError)]);
    end;
  finally
    L.Free;
  end;
end;

function CopyFileReplaceWithLink(const FromName, ToName, Description: string): Boolean;
// File kopieren. Danach Quelle löschen ersetzen mit Link zum Ziel.
var
  N: DWORD;
begin
  Result := CopyFile(FromName, ToName);
  if not FileExists(ToName) then
  begin
    Prot0('CopyFileReplaceWithLink: Target not exists', [0]);
    Result := false;
  end;
  if Result then
  begin
    //in ShellTools
    Result := CreateLink(ToName, FromName + '.lnk', Description);
    if not Result then
    begin
      N := GetLastError;
      Prot0('CopyFileReplaceWithLink %d(%s)', [N, SysErrorMessage(N)]);
    end;
  end;
  if Result then
  begin
    if not DeleteFile(FromName) then
    begin
      N := GetLastError;
      Prot0('CopyFileReplaceWithLink.DeleteFile %d(%s)', [N, SysErrorMessage(N)]);
    end;
  end;
end;

function MoveFile(const FromName, ToName: string): Boolean;
// File über Shell verschieben. Ergibt true bei Erfolg.
var
  L: TStringList;
  N: DWORD;
begin
  Prot0('MoveFile(%s -> %s)', [FromName, ToName]);
  L := TStringList.Create;
  try
    L.Add(FromName);
    Result := ShellFileOperation(L, ToName, FO_Move, FOF_NOCONFIRMATION);
    if not Result then
    begin
      N := GetLastError;
      Prot0('%d(%s)', [N, SysErrorMessage(N)]);
    end;
  finally
    L.Free;
  end;
end;

(* Menüfunktionen *)

function FindMenuItem(aMenu: TMenu; aCaption: string): TMenuItem;
var
  I: integer;
  aMenuItem: TMenuItem;
begin
  Result := nil;
  for I := 0 to aMenu.Items.Count - 1 do
  begin
    aMenuItem := aMenu.Items.Items[I];
    if RemoveAccelChar(aMenuItem.Caption) = RemoveAccelChar(aCaption) then
    begin
      Result := aMenuItem;
      Break;
    end;
  end;
end;

function FindMenuItem(aMenu: TMenu; aTag: integer): TMenuItem; overload;
var
  I: integer;
  aMenuItem: TMenuItem;
begin
  Result := nil;
  for I := 0 to aMenu.Items.Count - 1 do
  begin
    aMenuItem := aMenu.Items.Items[I];
    if aMenuItem.Tag = aTag then
    begin
      Result := aMenuItem;
      Break;
    end;
  end;
end;

(* Globale Umwandlungsfunktionen *)

function GetFieldText(AField: TField): string;
(* Text oder Blob-String ohne CRLF am Ende *)
var
  AstringList: TstringList;
(* {$ifdef WIN32}
  P  : array [0..255] of char;   {array size is number of characters needed}
  BS : tBlobStream;              {from the memo field}
begin
  If AField is TMemoField then
  begin
    BS := tBlobStream.Create(AField as TMemoField, bmRead);
    FillChar(P, SizeOf(P), #0);  {terminate the null string}
    BS.Read(P, SizeOf(P)-1);     {read chars from memo into blobStream}
    BS.Free;
    Result := StrPas(P);
  end else
{$else} *)
begin
  if AField = nil then            {beware or FieldIsNull(AField) then}
  begin
    Result := '';
  end else
  if IsBlobField(AField) then
  begin
    AstringList := TstringList.Create;
    try
      AstringList.Assign(AField);
      Result := GetstringsText(AstringList);
      while Pos(CharN(Result), CRLF) > 0 do       {kein CRLF am Ende CopyToHtml 30.05.02}
        System.Delete(Result, length(Result), 1);
    finally
      AstringList.Free;
    end;
  end else
  {if AField is TDateTimeField then
  begin
    if TDateTimeField(AField).DisplayFormat <> '' then     //lawa 11.12.04
      Result := FormatDateTime(TDateTimeField(AField).DisplayFormat, AField.AsDateTime) else
      Result := DateTimeToStr4(AField.AsDateTime);         //4st Jahr
  end else}
    Result := AField.DisplayText;  //DisplayFormat statt Text:EditFormat lawa.rmess.xls date
end;

function GetFieldValue(AField: TField): string;
(* wie GetFieldText, aber mit AsString statt Text. Memos ohne CRLF am Ende  *)
//var
  {D2 AstringList: TstringList;}
  {P  : array [0..256] of char;   {array size is number of characters needed}
  {BS : tBlobStream;              {from the memo field}
begin
  if AField = nil then            {beware or FieldIsNull(AField) then}
  begin
    Result := '';
  end else
  (*Delphi1
  if IsBlobField(AField) then
  begin
    try
      BS := tBlobStream.Create(AField as TBlobField, bmRead);
      FillChar(P, SizeOf(P), #0);    {terminate the null string}
      BS.Read(P, SizeOf(P)-1);       {read chars from memo into blobStream}
      Result := StrPas(P);
    except on E:Exception do
      begin
        EProt(AField, E, 'GetFieldValue(%s)',[AField.FieldName]);
        Result := '';
      end;
    end;
    BS.Free;
  end else*)
  if IsBlobField(AField) then
  begin
    try
      (*Delphi2
      AstringList := TstringList.Create;
      AstringList.Assign(AField);
      Result := GetStringsText(AstringList);
      *)
      //D5:   siehe VCL#Db.pas
      Result := RemoveTrailCRLF(AField.AsString); {kein CRLF am Ende 170699}
    except on E:Exception do
      begin
        EProt(AField, E, 'GetFieldValue(%s)',[AField.FieldName]);
        Result := '';
      end;
    end;
    //D2 AstringList.Free;
  end else
    Result := AField.Asstring;
end;

function GetFieldString(AField: TField): string;
(* liefert Einzeiligen string ohne CRLF
   * MarkAll *)
begin
  {Result := RemoveCRLF(GetFieldValue(AField));}
  {Result := StrCgeChar(GetFieldValue(AField), chr(10), chr(8));
  Result := StrCgeChar(Result, chr(13), chr(9));}
  {CRLF -> Tab}
  Result := StrCgeStrStr(GetFieldValue(AField), CRLF, TAB, false);
end;

procedure GetFieldStrings(AField: TField; L: TStrings);
// füllt Stringliste mit Feldinhalt. Feldtyp muß kein BLOB sein. Rechte.Params
// 03.03.13 Unicode: verwende AsString wenn Memo (es wird dann WideString geliefert)
begin
  if AField <> nil then
  begin
    if (AField is TMemoField) or (AField is TWideMemoField) then
    begin
      L.Text := AField.AsString;  //wandelt nach Widestring um wenn Unicode=true
    end else
    if IsBlobField(AField) then
    begin
      try
        L.Assign(AField);
      except on E:Exception do
        begin
          EProt(AField, E, 'GetFieldStrings(%s)',[AField.FieldName]);
        end;
      end;
    end else
      L.Text := AField.Text;
  end;
end;

procedure GetFieldPicture(AField: TField; aPicture: TPicture);
// Schreibt GraphicField Inhalt nach aPicture. BMP und JPG werden unterstützt. Siehe umDBImage.
// aPicture muss mit TPicture.Create angelegt sein.
var
  IsJPG: Boolean;
  MS: TMemoryStream;
  JPG: TJPEGImage;
{$IFDEF USEGIF}
  GIF: TGIFImage;
{$ENDIF}
begin
  if not aField.IsBlob then
   begin
    aPicture.Graphic := nil;
    Exit;
   end;

  with aField as TBlobField do
   begin
    IsJPG := (Pos('JFIF', Copy(AsString, 1, 10)) <> 0) or
             (Copy(AsString, 1, 2) = #$FF#$D8);
    if not IsJPG then                   // if not JPG
     if Copy(AsString, 1, 3) <> 'GIF' then // and not GIF
      begin
       try
         aPicture.Assign(aField);           // this is BMP ??
         Exit;
       except
         //<<<MD SMH Cam Axis2120
         IsJPG := true;
         {TBlobField(aField).SaveToFile(TempDir + aField.FieldName + '.um.jpg');
         aPicture.LoadFromFile(TempDir + TBlobField(aField).FieldName + '.um.jpg');}
         //<<<MD
       end;
      end;
   end;

  MS := TMemoryStream.Create;
  try
    TBlobField(aField).SaveToStream(MS);
    MS.Seek(soFromBeginning, 0);

    if IsJPG then
     begin
      JPG := TJPEGImage.Create;
      try
        JPG.LoadFromStream(MS);
        aPicture.Assign(JPG);
      finally
        JPG.Free;
      end;
     end
    else
     begin
{$IFDEF USEGIF}
      GIF := TGIFImage.Create;
      try
        GIF.LoadFromStream(MS);
        aPicture.Assign(GIF);
      finally
        GIF.Free;
      end;
{$ELSE}
      aPicture.Graphic := nil;
{$ENDIF}
     end;
  finally
    MS.Free;
  end;
end;

procedure SetFieldString(AField: TField; AString: string);
{Text setzten für MarkAll/Clipboard. Auch ReadOnly Felder}
var
  OldReadOnly: boolean;
  AstringList: TstringList;
begin
  OldReadOnly := AField.ReadOnly;
  try
    if OldReadOnly then
      AField.ReadOnly := false;

    if AString = '' then
      AField.Clear
    else
    begin
      AString := StrCgeStr(AString, TAB, CRLF);   {auch mehrz. TStringfields}
      if IsBlobField(AField) then
      begin
        AStringList := TstringList.Create;
        try
          {AString := StrCgeChar(AString, chr(8), chr(10));
          AString := StrCgeChar(AString, chr(9), chr(13));}
          SetStringsText(AstringList, AString);
          AField.Assign(AstringList);
        finally
          AstringList.Free;
        end;
      end else
        AField.AsString := AString;
    end;
  finally
    if OldReadOnly then
      AField.ReadOnly := OldReadOnly;
  end;
end;

procedure SetFieldText(AField: TField; AText: string);
{Text setzten typabhängig}
var
  AstringList: TstringList;
begin
  {Prot0('SetFieldValue(%s.%s=%s):',[AField.DataSet.Name,AField.FieldName,AText]);}
  {else if AField is TBlobField.DataType in [ftMemo,ftGraphic,ftBlob,ftVarBytes] then}
  if AText = '' then
    AField.Clear
  else
  if IsBlobField(AField) then
  begin
    AstringList := TstringList.Create;
    try
      SetStringsText(AstringList, AText);
      AField.Assign(AstringList);
    finally
      AstringList.Free;
    end;
  end else
    AField.Text := AText;
end;

procedure SetFieldStrings(AField: TField; Strings: TStrings);
//Weist Feld einer Stringliste zu. Feld kann Blob oder String sein. }
begin
  {Prot0('SetFieldValue(%s.%s=%s):',[AField.DataSet.Name,AField.FieldName,AText]);}
  {else if AField is TBlobField.DataType in [ftMemo,ftGraphic,ftBlob,ftVarBytes] then}
  if (Strings = nil) or (Trim(Strings.Text) = '')  then
  begin
    AField.Clear
  end else
  if (AField is TMemoField) or (AField is TWideMemoField) then
  begin
    AField.AsString := Strings.Text;  //wandelt nach Widestring um wenn Unicode=true
  end else
  if IsBlobField(AField) then
  begin
    AField.Assign(Strings);
  end else
  begin
    AField.AsString := RemoveTrailCrlf(Strings.Text);
  end;
end;

procedure SetFieldValue(AField: TField; AValue: string);
{Text setzten typunabhängig}
//05.03.12 mit TrimRight
var
  S1: string;
begin
  S1 := TrimRight(AValue);
  {if SysParam.ProtBeforeOpen then Prot0('SetFieldValue(%s.%s=%s):',
    [AField.DataSet.Name, AField.FieldName, AValue]);}
  if S1 = '' then
    AField.Clear
  else
{$ifdef WIN32}
{$else}
  if IsBlobField(AField) then
  begin
    try
      AstringList := TstringList.Create;
      SetStringsText(AstringList, S1);
      AField.Assign(AstringList);
    finally
      AstringList.Free;
    end;
  end else
{$endif}
  if AField is TIntegerField then
    AField.AsInteger := StrToIntTol(S1) else   //Nachkommas weg
  if AField is TFloatField then                    //war Integer??? 17.02.04
    AField.AsFloat := StrToFloatIntl(S1) else   //',' und '.' (GEN.GSADO 13.09.03)
    AField.AsString := S1;
end;

procedure SetFieldValueRO(AField: TField; AText: string);
(* für ReadOnly Felder *)
var
  OldReadOnly: boolean;
begin
  OldReadOnly := AField.ReadOnly;
  if OldReadOnly then
  try
    AField.ReadOnly := false;
    if AText = '' then
      AField.Clear else                                   {220400 ISA.Rech.Repo}
      SetFieldValue(AField, AText);
  finally
    AField.ReadOnly := OldReadOnly;
  end else
    SetFieldValue(AField, AText);
end;

procedure SetFieldFloatRO(AField: TField; AFloat: Extended);
{einem TField eine Float-Wert zuweisen. Auch bei ReadOnly}
var
  OldReadOnly: boolean;
begin
  OldReadOnly := AField.ReadOnly;
  if OldReadOnly then
    AField.ReadOnly := false;
  try
    if (AField is TFloatField) or (AField is TDateTimeField) then
      TFloatField(AField).AsFloat := AFloat else
    if AField is TIntegerField then
      TIntegerField(AField).AsInteger := Round(AFloat) else
      SetFieldValue(AField, FloatToStr(AFloat));            {auch für Blobs OK}
  finally
    if OldReadOnly then
      AField.ReadOnly := true;
  end;
end;

procedure SetFieldFloatN0(AField: TField; AFloat: Extended);
{einem TField eine Float-Wert zuweisen. Null wenn 0-Wert}
var
  OldReadOnly: boolean;
begin
  OldReadOnly := AField.ReadOnly;
  if OldReadOnly then
    AField.ReadOnly := false;
  try
    if AFloat = 0 then
      AField.Clear else
    if AField is TFloatField then
      TFloatField(AField).AsFloat := AFloat else
    if AField is TIntegerField then
      TIntegerField(AField).AsInteger := Round(AFloat) else
      SetFieldValue(AField, FloatToStr(AFloat));            {auch für Blobs OK}
  finally
    if OldReadOnly then
      AField.ReadOnly := true;
  end;
end;

procedure AddFieldText(AField: TField; AText: string);
(* Wert hinzufügen (Trenner ist ';')
   * AddFieldText *)
var
  AFieldText: string;
begin
  AFieldText := GetFieldText(AField);
  if AFieldText = '' then
    SetFieldValueRO(AField, AText) else         {RO 291200}
    SetFieldValueRO(AField, Format('%s;%s', [AFieldText, AText]));
end;

procedure AddFieldLine(AField: TField; ALine: string);
(* Wert hinzufügen (Trenner ist CRLF) *)
var
  AFieldText: string;
begin
  AFieldText := GetFieldText(AField);  //entfernt CRLF am Ende
  if AFieldText = '' then
    SetFieldValueRO(AField, ALine) else
    SetFieldValueRO(AField, Format('%s' + CRLF + '%s', [AFieldText, ALine]));
end;

procedure InsertFieldLine(AField: TField; APos: integer; ALine: string);
(* Zeile in mehrzeiligem Feld einfügen an Position APos. APos kann beliebig gross sein *)
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    if IsBlobField(AField) then
      AList.Assign(AField) else
      SetStringsText(AList, AField.Text);
    if APos >= AList.Count then
      AList.Add(ALine) else
      AList.Insert(APos, ALine);
    if IsBlobField(AField) then
      AField.Assign(AList) else
      AField.AsString := RemoveTrailCrlf(AList.Text);
  finally
    AList.Free;
  end;
end;

procedure SetFieldComp(AField: TField; AValue: string);
(* wie SetFieldValue, aber nur wenn Werte ungleich *)
begin
  if CompFieldValue(AField, AValue) <> 0 then
    SetFieldValueRO(AField, AValue);
end;

procedure SetFieldDflt(AField: TField; AValue: string);
(* Belegt Feldwert mit SetFieldValue(AValue) wenn AField.IsNull *)
begin
  if FieldIsNull(AField) then
    SetFieldValueRO(AField, AValue);
end;

function CompFieldValue(AField: TField; AValue: string; IgnoreCase: boolean = false): integer;
(* Vergleich Feldinhalt mit Text.
   Numerische Felder ohne Berücksichtigung des Formats
   Result: 0:AField = AText; <0: AField < AText; >0: AField > AText;
           -1:Fehler *)
var
  FieldInteger, AInteger: int64;
  FieldFloat, AFloat: Extended;
begin
  Result := -1;
  {if FieldIsNull(AField) and (AValue = '') then}
  if AField.IsNull and (Trim(AValue) = '') then   //MSSQL Problem '_'
  begin
    Result := 0;                {beide null ist gleich}
    exit;
  end else
  if AField.IsNull or (AValue = '') then   {isnull ist ungleich ''}
  begin
    Result := -1;
  end else
  if AField.DataType in [ftSmallInt,ftInteger,ftWord,ftAutoInc,
                         ftLargeint, ftLongWord, ftShortint, ftByte] then
  begin
    try
      FieldInteger := AField.AsLargeInt;
      AInteger := StrToInt(AValue);
      Result := Sgn(FieldInteger - AInteger);
    except
      {Result := -1;}
      if GNavigator <> nil then
        Result := GNavigator.DbCompare(GetFieldValue(AField), AValue, false);  {no ignore case 161098}
    end;
  end else
  if AField.DataType in [ftFloat, ftCurrency, ftBCD,
                         ftExtended] then
  begin
    try
      FieldFloat := AField.AsFloat;
      AFloat := StrToFloat(AValue);
      Result := Sgn(FieldFloat - AFloat);
    except
      Result := -1;
    end;
  end else
  if AField.DataType in [ftDate, ftTime, ftDatetime] then
  begin
    try
      FieldFloat := AField.AsFloat;
      AFloat := StrToDateTime4(AValue);
      Result := Sgn(FieldFloat - AFloat);
    except
      Result := -1;
    end;
  end else
  if GNavigator <> nil then
  begin
    Result := GNavigator.DbCompare(GetFieldValue(AField), AValue, IgnoreCase);  {no ignore case 161098}
  end else
  if IgnoreCase then
    Result := AnsiCompareText(GetFieldValue(AField), AValue) else
    Result := AnsiCompareStr(GetFieldValue(AField), AValue);  {no ignore case 161098}
end;

function ScanFieldValue(AField: TField; AValue: string): integer;
(* Vergleich Feldinhalt mit Text zeichenweise (vergl compfieldText)
   Result: <=; 0; >0 *)
begin
  Result := -1;
  if FieldIsNull(AField) and (AValue = '') then
  begin
    Result := 0;                {beide null ist gleich}
    exit;
  end;
  if AField.DataType in [ftSmallInt,ftInteger,ftWord,ftAutoInc,ftLargeInt,
                         ftFloat,ftCurrency,ftBCD,
                         ftDate, ftTime, ftDatetime] then
  begin
    Result := CompFieldValue(AField, AValue);
  end else
  begin
    if GNavigator <> nil then
      Result := GNavigator.DbCompare(copy(GetFieldValue(AField), 1, length(AValue)),
                                     AValue, true);  {ignore case}
    {Result := AnsiCompareText(copy(GetFieldValue(AField), 1, length(AValue)),
                               AValue);  {ignore case}
  end;
end;

function CompFields(Field1, Field2: TField): TCompareSet;
(* vergleicht 2 Felder -> Ergebinsmenge
   (compMinor, compMaior, compEqal, compNull, compNull1, compNull2) *)
begin
  Result := [];
  if FieldIsNull(Field1) then Result := Result + [compNull, compNull1];
  if FieldIsNull(Field2) then Result := Result + [compNull, compNull2];
  if FieldIsNull(Field1) <> FieldIsNull(Field2) then
  begin
    if FieldIsNull(Field1) then
      System.Include(Result, compMinor) else
      System.Include(Result, compMaior);
  end else
  begin
    if FieldIsNull(Field1) {or FieldIsNull(Field2)} then
      System.Include(Result, compEqal) else
      case SGN(CompFieldValue(Field1, GetFieldValue(Field2))) of
        -1: System.Include(Result, compMinor);
        +1: System.Include(Result, compMaior);
         0: System.Include(Result, compEqal);
      end;
  end;
end;

procedure AssignFieldRO(DstField, SrcField: TField);
(* Feldinhalt beliebiger Feldtypen kopieren.
   Ignoriert Readonly Flag *)
var
  OldReadOnly: boolean;
begin
  OldReadOnly := DstField.ReadOnly;
  if OldReadOnly then
  try
    DstField.ReadOnly := false;
    AssignField(DstField, SrcField);
  finally
    DstField.ReadOnly := OldReadOnly;
  end else
    AssignField(DstField, SrcField);
end;

function AssignField(DstField, SrcField: TField): boolean;
// Feldinhalt beliebiger Feldtypen kopieren
// ergibt true bei Änderung
begin
  Result := false;
  try
    Result := DstField.AsString <> SrcField.AsString;          //31.12.06
    {if SysParam.ProtBeforeOpen then Prot0('AssignField(%s.%s=%s)',
      [DstField.DataSet.Name, DstField.FieldName, SrcField.Text]);}
    if FieldIsNull(SrcField) then
    begin
      DstField.Clear;
    end else
    if (DstField.DataType = SrcField.DataType) and
       (DstField.Size = SrcField.Size) then
    begin
      case DstField.DataType of
        ftString, ftWideString: DstField.AsString := SrcField.AsString;
        ftSmallint, ftInteger, ftAutoInc, ftWord: DstField.AsInteger := SrcField.AsInteger;
        ftLargeInt: DstField.AsLargeInt := SrcField.AsLargeInt;  //ab 05.05.14 Large
        ftFloat, ftCurrency: DstField.AsFloat := SrcField.AsFloat;
        ftDate, ftTime, ftDateTime: DstField.AsDateTime := SrcField.AsDateTime;
      else
        DstField.Assign(SrcField);
      end;
    end else
    if IsBlobField(DstField) and IsBlobField(SrcField) then
    begin
      DstField.Assign(SrcField);
    end else
    if IsBlobField(DstField) or IsBlobField(SrcField) then
    begin
      SetFieldValue(DstField, GetFieldValue(SrcField));
    end else
    if (DstField.DataType in [ftString, ftWideString]) and
       not (SrcField.DataType in [ftString, ftWideString]) then
    begin                                     {Date, Number}
      DstField.AsString := SrcField.DisplayText;     {mit Format   100500}
    end else
    if (DstField.DataType in [ftDate, ftTime, ftDateTime]) and
       (SrcField.DataType in [ftDate, ftTime, ftDateTime]) then
    begin
      DstField.AsDateTime := SrcField.AsDateTime;
    end else
    begin
      DstField.AsString := SrcField.AsString;                  {bisher}
    end;
  except on E:Exception do
    begin
      EProt(DstField, E, 'AssignField', [0]);
      {DstField.AsString := SrcField.AsString;  Fehler bei Blob  Access}
    end;
  end;
end;

procedure AssignFieldComp(DstField, SrcField: TField);
(* Feldinhalt beliebiger Feldtypen kopieren: nur wenn ungleich *)
begin
  if CompFieldValue(DstField, GetFieldValue(SrcField)) <> 0 then
    AssignFieldRO(DstField, SrcField);              {RO: 250400 ISA.RECH}
end;

procedure MoveField(DstField, SrcField: TField);
begin
  AssignField(DstField, SrcField);
  SrcField.Clear;
end;

procedure AssignFieldByName(DstTbl: TDataSet; DstFieldName: string;
                             SrcTbl: TDataSet; SrcFieldName: string);
{Inhalte übertragen mit DataSet und Feldname}
begin
  AssignField(DstTbl.FieldByName(DstFieldName),
              SrcTbl.FieldByName(SrcFieldName));
end;

procedure AssignFieldByName1(Tbl: TDataSet; DstFieldName: string;
                             SrcFieldName: string);
{Inhalte übertragen mit gleichem DataSet und Feldname}
begin
  AssignField(Tbl.FieldByName(DstFieldName),
              Tbl.FieldByName(SrcFieldName));
end;

procedure MoveFieldByName1(Tbl: TDataSet; DstFieldName: string;
                             SrcFieldName: string);
{Inhalte bewegen mit gleichem DataSet und Feldname}
begin
  MoveField(Tbl.FieldByName(DstFieldName),
            Tbl.FieldByName(SrcFieldName));
end;

procedure LogicalToJaNein(AField: TField);
{Werte von Logical Field (dBase) nach JaNein-Field konvertieren}
begin
  case FieldAsChar(AField) of
    'T','W': AField.AsString := 'J';        {true -> ja}
    'F': AField.AsString := 'N';        {false -> nein}
  end;
end;

function NVL(AField: TField; NullValue: integer): integer;
begin
  if AField.IsNull then
    Result := NullValue else
    Result := AField.AsInteger;
end;

function NVL(AField: TField; NullValue: double): double;
begin
  if AField.IsNull then
    Result := NullValue else
    Result := AField.AsFloat;
end;

{* double
function NVL(AField: TField; NullValue: TDateTime): TDateTime;
begin
  if AField.IsNull then
    Result := NullValue else
    Result := AField.AsDateTime;
end;
*}

function NVL(AField: TField; NullValue: string): string;
begin
  if AField.IsNull then
    Result := NullValue else
    Result := AField.AsString;
end;

function GetFieldIndex(ADataSet: TDataSet; AField: TField): integer;
{liefert den Index vom Feld in TDataSet.Fields}
var
  i: integer;
begin
  Result := -1;
  for i:= 0 to ADataSet.FieldCount-1 do
  begin
    if ADataSet.Fields[i] = AField then
    begin
      Result := i;
      break;
    end;
  end;
end;

function IsBlobField(AField: TField): boolean;
{ergibt True wenn das Feld ein Blob Feld ist}
begin
{$ifdef WIN32}
  Result := (AField is TBlobField) or (AField is TBinaryField);
{$else}
  Result := (AField is TBlobField) or (AField is TBytesField) or
            (AField is TVarBytesField);
{$endif}
end;

function IsCalcField(AField: TField): boolean;
{ergibt True wenn das Feld ein Calc Feld ist}
begin
  Result := (AField <> nil) and ((AField.FieldNo < 0) or AField.Calculated);
end;

procedure ProcAssignFloat(aProc: TUniStoredProc; const AParamName, Value: string);
begin
  if Value = '' then
    AProc.ParamByName(AParamName).Clear else
  try
    AProc.ParamByName(AParamName).AsFloat := StrToFloat(Value);
  except on E:Exception do
    EError('ProcAssignFloat(%s=%s):%s', [AParamName, Value, E.Message]);
  end;
end;

procedure ProcAssignInt(aProc: TUniStoredProc; const AParamName, Value: string);
begin
  if Value = '' then
    AProc.ParamByName(AParamName).Clear else
  try
    AProc.ParamByName(AParamName).AsInteger := StrToInt(Value);
  except on E:Exception do
    EError('ProcAssignInt(%s=%s):%s', [AParamName, Value, E.Message]);
  end;
end;

procedure ProcAssignDate(aProc: TUniStoredProc; const AParamName, Value: string);
begin
  if Value = '' then
    AProc.ParamByName(AParamName).Clear else
  try
    AProc.ParamByName(AParamName).AsDateTime := StrToDate(Value);
  except on E:Exception do
    EError('ProcAssignDate(%s=%s):%s', [AParamName, Value, E.Message]);
  end;
end;

procedure ProcAssignStr(aProc: TUniStoredProc; const AParamName, Value: string);
begin
  if Value = '' then
    AProc.ParamByName(AParamName).Clear else
  try
    AProc.ParamByName(AParamName).AsString := Value;
  except on E:Exception do
    EError('ProcAssignStr(%s=%s):%s', [AParamName, Value, E.Message]);
  end;
end;

procedure SetMemoString(AMemo: TField; Ident, Value: string);
{Schreibt Values[Ident]=Value nach Memofield}
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    if IsBlobField(AMemo) then
      AList.Assign(AMemo) else
      SetStringsText(AList, AMemo.Text);
    AList.Values[Ident] := Value;
    if IsBlobField(AMemo) then
      AMemo.Assign(AList) else
      AMemo.Text := GetStringsText(AList);
  finally
    AList.Free;
  end;
end;

function GetMemoString(AMemo: TField; Ident, Default: string): string;
{liest Values[Ident] aus ValueList in Memofield}
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    if IsBlobField(AMemo) then
      AList.Assign(AMemo) else
      SetStringsText(AList, AMemo.Text);
    Result := GetStringsString(AList, Ident, Default);
  finally
    AList.Free;
  end;
end;

function GetMemoBool(AMemo: TField; Ident: string; Default: boolean): boolean;
{liest Values[Ident] aus ValueList in Memofield}
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    if IsBlobField(AMemo) then
      AList.Assign(AMemo) else
      SetStringsText(AList, AMemo.Text);
    Result := GetStringsBool(AList, Ident, Default);
  finally
    AList.Free;
  end;
end;

function GetMemoInteger(AMemo: TField; Ident: string; Default: Integer): Integer;
{liest Values[Ident] aus ValueList in Memofield}
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    if IsBlobField(AMemo) then
      AList.Assign(AMemo) else
      SetStringsText(AList, AMemo.Text);
    Result := GetStringsInteger(AList, Ident, Default);
  finally
    AList.Free;
  end;
end;

function GetMemoFloat(AMemo: TField; Ident: string; Default: Double): Double;
{liest Values[Ident] aus ValueList in Memofield}
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    if IsBlobField(AMemo) then
      AList.Assign(AMemo) else
      SetStringsText(AList, AMemo.Text);
    Result := GetStringsFloat(AList, Ident, Default);
  finally
    AList.Free;
  end;
end;

function GetStringsStrings(AList: TStrings; const Section: string;
  Strings: TStrings): boolean;
{liest alle Strings einer [Section] komplett. Groß/Klein egal.
 Leerzeilen und mit ; beginnende Zeilen werden ignoriert
 ergibt true wenn Section gefunden (auch wenn sie leer ist) }
var
  I: integer;
  S: string;
begin
  Result := false;
  for I := 0 to AList.Count - 1 do
  begin
    S := AList[I];
    if (S = '') or (char1(S) = ';') then
      continue;
    if not Result then
    begin
      if CompareText(S, Format('[%s]', [Section])) = 0 then
      begin
        Result := true;                {Section gefunden}
        Strings.Clear;
      end;
    end else
    if char1(S) = '[' then             {nächste Section}
    begin
      break;
    end else
    begin
      Strings.Add(S);                  {unsere Section}
    end;
  end;
end;

function GetStringsParam(AList: TStrings; Value, Default: string): string;
{liest linke Seite vom '=' bei rechter Seite = Value. Ignoriert Groß/Klein}
var
  I: integer;
begin
  Result := Default;
  for I := 0 to AList.Count - 1 do
    if CompareText(StrValue(AList[I]), Value) = 0 then
    begin
      Result := StrParam(AList[I]);
      break;
    end;
end;

function GetStringsString(AList: TStrings; Ident, Default: string): string;
{liest Values[Ident] aus ValueList in Strings}
begin
  Result := AList.Values[Ident];
  if Result = '' then
    Result := Default;
end;

function GetStringsBool(AList: TStrings; Ident: string; Default: boolean): boolean;
{liest Values[Ident] aus ValueList in AList}
var
  S: string;
begin
  S := Trim(AList.Values[Ident]);
  if S = '' then
    Result := Default else
    Result := S = '1';
end;

function GetStringsInteger(AList: TStrings; Ident: string; Default: Integer): Integer;
{liest Values[Ident] aus ValueList in AList}
var
  S: string;
begin
  Result := Default;
  if AList = nil then
    Exit;
  S := Trim(AList.Values[Ident]);
  if S = '' then
    Result := Default else
    Result := StrToIntDef(S, Default);
end;

function GetStringsFloat(AList: TStrings; Ident: string; Default: Double): Double;
{liest Values[Ident] aus ValueList in AList}
var
  S: string;
begin
  S := Trim(AList.Values[Ident]);
  if S = '' then
    Result := Default else
    Result := StrToFloatDef(S, Default);
end;

function GetStringsFloatIntl(AList: TStrings; Ident: string; Default: Double): Double;
{ liest Values[Ident]. Unterstützt verschiedene internationale Formate }
var
  S: string;
begin
  S := Trim(AList.Values[Ident]);
  if S = '' then
    Result := Default else
  try
    Result := StrToFloatIntl(S, false);
  except
    Result := Default;
  end;
end;

procedure SetStringsString(AList: TStrings; Ident, Value: string);
{belegt Values[Ident] mit Value}
begin
  AList.Values[Ident] := Value;
end;

procedure SetStringsBool(AList: TStrings; Ident: string; Value: boolean);
{belegt Values[Ident] mit Value}
begin
  AList.Values[Ident] := IntToStr(ord(Value));
end;

procedure SetStringsInteger(AList: TStrings; Ident: string; Value: Integer);
{belegt Values[Ident] mit Value}
begin
  AList.Values[Ident] := IntToStr(Value);
end;

procedure SetStringsFloat(AList: TStrings; Ident: string; Value: Double);
{belegt Values[Ident] mit Value}
begin
  AList.Values[Ident] := FloatToStr(Value);
end;

procedure GridToStrings(AGrid: TStringGrid; AList: TStrings; Fixed: boolean);
{schreibt belegte Grid-Cells nach AList i.d.F. <X>,<Y>=<Value>}
{Fixed: true = auch FixedCols/Rows beteiligen}
{AList wird vorher gelöscht}
var
  X, Y: integer;
  X0, Y0: integer;
begin
  AList.Clear;
  if Fixed then
  begin
    X0 := 0;
    Y0 := 0;
  end else
  begin
    X0 := AGrid.FixedCols;
    Y0 := AGrid.FixedRows;
  end;
  for Y := Y0 to AGrid.RowCount - 1 do
    for X := X0 to AGrid.ColCount - 1 do
      if AGrid.Cells[X,Y] <> '' then
        AList.Add(Format('%d,%d=%s', [X, Y, AGrid.Cells[X,Y]]));
end;

procedure StringsToGrid(AList: TStrings; AGrid: TStringGrid; Fixed: boolean);
{belegt Grid-Cells mit Stringsinhalt, Zeilenaufbau: <X>,<Y>=<Value>}
{Fixed: true = auch FixedCols/Rows beteiligen}
{erhöht ggf. RowColun, ColCount}
var
  I, X, Y: integer;
  NextS: string;
begin
  for I := 0 to AList.Count - 1 do
  begin
    X := StrToInt(PStrTok(StrParam(AList[I]), ',', NextS));
    Y := StrToInt(PStrTok('', ',', NextS));
    if Fixed or ((X >= AGrid.FixedCols) and (Y >= AGrid.FixedRows)) then
    begin
      AGrid.ColCount := IMax(AGrid.ColCount, X + 1);
      AGrid.RowCount := IMax(AGrid.RowCount, Y + 1);
      AGrid.Cells[X, Y] := StrValue(AList[I]);
    end;
  end;
end;

procedure SortStrings(Strings: TStrings; Descending: boolean = false);
(* Sortiert Strings via QuickSort *)
  procedure ExchangeItems(I, J: integer);
  begin
    {S := Strings[I];
    Strings[I] := Strings[J];
    Strings[J] := S;}
    Strings.Exchange(I, J);  //verschiebt Objekte auch mit
  end; {ExchangeItems}
  procedure QuickSort(L, R: Integer);
  var
    I, J: Integer;
    P: string;
  begin
    repeat
      I := L;
      J := R;
      P := Strings[(L + R) shr 1];
      repeat
        if Descending then
        begin
          while AnsiCompareText(Strings[I], P) > 0 do Inc(I);
          while AnsiCompareText(Strings[J], P) < 0 do Dec(J);
        end else
        begin
          while AnsiCompareText(Strings[I], P) < 0 do Inc(I);
          while AnsiCompareText(Strings[J], P) > 0 do Dec(J);
        end;
        if I <= J then
        begin
          ExchangeItems(I, J);
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then QuickSort(L, J);
      L := I;
    until I >= R;
  end; {QuickSort}
begin {SortStrings}
  if Strings.Count > 1 then
  begin
    Strings.BeginUpdate;
    QuickSort(0, Strings.Count - 1);
    Strings.EndUpdate;
  end;
end;

function StrParam(ALine: string; RightestEqual: boolean = false): string;
{Extrahiert die linke Seite vom '='. Wenn kein '=' dann ALine ohne Blanks}
// 1. ====5 -> '='   2. A=B=3 -> 'A'   3. A===B=3=5 -> 'A'
// 4. =B -> ''       5. '===' -> '='   6. A -> 'A'          7. A=  -> 'A'
var
  P: integer;
begin
  Result := '';
  if RightestEqual then
    P := PosR('=', ALine) else
    P := Pos('=', ALine);
  if P = 1 then
  begin
    if copy(ALine, 2, 1) = '=' then  //=== -> =
      Result := '=' else
      Result := '';
  end else
  if P > 1 then
    Result := Trim(Copy(ALine, 1, P-1)) else
    Result := Trim(ALine);
end;

function StrValue(ALine: string; RightestEqual: boolean = false): string;
{Extrahiert die rechte Seite vom ersten '='. Ergibt '' wenn '=' fehlt}
var
  P: integer;
begin
  if RightestEqual then
    P := PosR('=', ALine) else
    P := Pos('=', ALine);
  if (P > 0) and (length(ALine) > P) then
    Result := LTrim(Copy(ALine, P+1, Length(ALine) - p)) else
    Result := '';            {LTrim atatt Trim ab 051198}
end;

function StrValueDflt(ALine: string; RightestEqual: boolean = false): string;
{Extrahiert die rechte Seite vom '=' Ergibt ALine wenn '=' fehlt}
begin
  Result := StrValue(ALine, RightestEqual);
  if Result = '' then
    Result := ALine;
end;

procedure MergeStringsValues(Strings: TStrings; const Src: TStrings);
//ergänzt Dst mit den Werten von Src
//Dst wird nicht geändert wenn es keine Unterschiede gibt. (wg OnChange)
var
  I: integer;
  Par, Val: string;
begin
  for I := 0 to Src.Count - 1 do
  begin
    Par := StrParam(Src[I]);
    Val := StrValue(Src[I]);
    if Strings.Values[Par] <> Val then
      Strings.Values[Par] := Val;
  end;
end;

function AnsiCompStr(S1, S2: string; IgnoreCase: boolean): boolean;
begin
  if IgnoreCase then
    Result := AnsiCompareText(S1, S2) = 0 else
    Result := AnsiCompareStr(S1, S2) = 0;
end;

function CompStr(S1, S2: string; IgnoreCase: boolean): boolean;
begin
  if IgnoreCase then
    Result := CompareText(S1, S2) = 0 else
    Result := CompareStr(S1, S2) = 0;
end;

function StrIn(const Str, Values: string; IgnoreCase: boolean): boolean;
{ergibt TRUE wenn Str in Values. Tokens mit ; getrennt}
var
  S, NextS: string;
begin
  Result := false;
  if Str = '' then
  begin
    Result := false;
    exit;
  end;
  if CompStr(Str, Values, IgnoreCase) then
  begin
    Result := true;
    exit;
  end;
  S := PStrTok(Values, ';', NextS);
  while S <> '' do
  begin
    if CompStr(Str, S, IgnoreCase) then
    begin
      Result := true;
      break;
    end;
    S := PStrTok('', ';', NextS);
  end;
end;

function FieldIsName(AField: TField; AFieldName: string): boolean;
{ergibt TRUE wenn AField.FieldName = AFieldName ist (groß/klein/nil egal)
 mehrere Feldnamen können in <AFieldName> mit ';' getrennt werden
 Field=nil kann mit 'nil' als Feldnamen gekennzeichnet werden}
var
  TheFieldName, OneFieldName, NextS: string;
begin
  Result := false;
  {if AField <> nil then    ('nil' ist OK)}
  repeat
    OneFieldName := PStrTok(AFieldName, '; ', NextS);
    AFieldName := '';
    if AField = nil then
      TheFieldName := 'nil' else
      TheFieldName := AField.FieldName;
    if (OneFieldName <> '') and
       (CompareText(TheFieldName, OneFieldName) = 0) then
    begin
      Result := true;
      break;
    end;
  until OneFieldName = '';
end;

function OnlyFieldName(AFieldName: string): string;
// Alles ab dem letzten '.'
var
  P: integer;
begin
  P := Pos('.',AFieldName);
  if P = 0 then
    Result := Trim(AFieldName) else                 {Rekursion}
    Result := OnlyFieldName(Copy(AFieldName, P+1, Length(AFieldName) - P));
end;

function OnlyTableName(ATableName: string): string;
(* Alles vor dem letzten '.' *)
var
  P: integer;
begin
  P := length(ATableName);
  while (P > 0) and (ATableName[P] <> '.') do
    Dec(P);
  if P = 0 then
    Result := ATableName else
    Result := Copy(ATableName, 1, P-1);
end;

function StripExtension(AFilePath: string): string;
//entfernd die Endung (und Punkt) von Filepfad.
begin
  Result := OnlyTableName(AFilePath);
end;

function OnlyFileName(AFilePath: string): string;
//OnlyFileName extrahiert nur den Namen ohne Erweiterung aus einem Dateinamen.
begin
  Result := OnlyTableName(ExtractFileName(AFilePath));
end;

function ShortCaption(ACaption: string): string;
(* Extrahiert 1.Teil des Titels (vor dem ' - ')
   Caption [SubCaption] * ExtCaption - Caption2
   und vor dem '*' - 16.09.10
   und vor dem '[]' - 16.09.10
   Caption mit '-' möglich, wenn keine Leerzeichen davor
*)
var
  P, P1, P2, P3: integer;
begin
  P1 := Pos(' [', ACaption);
  P2 := Pos(' *', ACaption);
  P3 := Pos(' -', ACaption);
  // Später: '(', '{'
  P := 999999;
  if P1 > 0 then
    P := IMin(P, P1);
  if P2 > 0 then
    P := IMin(P, P2);
  if P3 > 0 then
    P := IMin(P, P3);
  if (P = 999999) or (P = 1) then
    Result := ACaption else
    Result := Copy(ACaption, 1, P - 1);
end;

function BeforeBracketCaption(ACaption, OpenBracket: string): string;
// Extrahiert HauptTeil des Titels vor der öffnenden Klammer bzw. vor ' -'
// erwartet Leerzeichen vor dem OpenBracket
// Klammern: [] oder () oder {}; kann aber auch '-' oder '*' sein. //16.09.10, 29.09.08
var
  P: integer;
begin
  P := Pos(' ' + OpenBracket, ACaption);
  if P <= 2 then
  begin
    if OpenBracket = '[' then
      Result := BeforeBracketCaption(ACaption, '*') else
    if OpenBracket = '*' then
      Result := BeforeBracketCaption(ACaption, '-') else
      Result := ACaption;
  end else
    Result := Copy(ACaption, 1, P - 1);
end;

function GetInnerBracketCaption(ACaption, OpenBracket, CloseBracket: string): string;
// Extrahiert Untertitel des Titels (zwischen OpenBrackect([) und CloseBrracket(]) - 29.09.08
// Klammern: [] oder () oder {}
var
  P1, P2: integer;
  L1: integer;
begin
  Result := '';
  L1 := Length(OpenBracket);
  P1 := Pos(' ' + OpenBracket, ACaption);
  if P1 > 0 then          //123 <<78>>12
  begin                   //123 (67)9     P1=4  P2=8  result=6..7
    { TODO : geschlossene Klammern vor P1 ignorieren }
    P2 := Pos(CloseBracket, ACaption);
    if P2 > P1 then                                              //4+1+2=7, 9-4-1-2=2
      Result := copy(ACaption, P1 + 1 + L1, P2 - P1 - 1 - L1);   //4+2=6, 8-4-2=2
  end;
end;

function BracketCaption(ACaption, ASubCaption, OpenBracket, CloseBracket: string): string;
// Baut Titel aus ACaption + <OpenBracket> + SubCaption + <CloseBracket> auf
// Bestehende Ausdrücke in den gleichen Klammern werden vorher entfernt - vergl SubCaption - 29.09.08
// Klammern: [] oder () oder {}
begin
  if ASubCaption = '' then
    Result := BeforeBracketCaption(ACaption, OpenBracket) else
  if ACaption = '' then
    Result := BeforeBracketCaption(ASubCaption, OpenBracket) else
    Result := Format('%s %s%s%s', [BeforeBracketCaption(ACaption, OpenBracket),
      OpenBracket, ASubCaption, CloseBracket]);
end;

function MainCaption(ACaption: string): string;
(* Extrahiert HauptTeil des Titels vom SubCaption (vor dem '[' bzw. ' - ') *)
begin
  Result := BeforeBracketCaption(ACaption, '[');
//  P := Pos(' [', ACaption);
//  if P <= 2 then
//    Result := ShortCaption(ACaption) else
//    Result := Copy(ACaption, 1, P - 1);
end;

function GetSubCaption(ACaption: string): string;
// Extrahiert Untertitel des Titels (zwischen '[' und ']' -
begin
  Result := GetInnerBracketCaption(ACaption, '[', ']');
//  Result := '';
//  P1 := Pos('[', ACaption);
//  if P1 > 0 then
//  begin
//    P2 := Pos(']', ACaption);
//    if P2 > P1 then
//      Result := copy(ACaption, P1 + 1, P2 - P1 - 1);
//  end;
end;

function SubCaption(ACaption, ASubCaption: string): string;
(* Baut Titel aus ACaption + '[' + SubCaption + ']' auf
   ACaption wird evtl. vor '[' gekürzt *)
var
  S: string;
begin
  S := '';
  if ASubCaption <> '' then
    S := '[' + ASubCaption + ']';
  Result := BeforeBracketCaption(ACaption, '[');
  AppendTok(Result, S, ' ');
end;

function ExtCaption(ACaption, AExtCaption: string): string;
// Baut Titel aus ACaption + ' *' + ExtCaption auf. ACaption wird vor '*' gekürzt
begin
  Result := BeforeBracketCaption(ACaption, '*');
  AppendTok(Result, AExtCaption, ' * ');
end;

function LongCaption(ACaption, Caption2: string): string;
// Baut Titel aus ACaption + ' - ' + Caption2 auf. ACaption wird vor ' -' gekürzt
begin
  Result := BeforeBracketCaption(ACaption, '-');
  AppendTok(Result, Caption2, ' - ');
end;

function FieldAsChar(AField: TField): Char;
begin
  Result := Char1(AField.Asstring);
end;

function FieldAsInt(AField: TField): longint;
begin
  Result := StrToIntDef(AField.Asstring, 0);
end;

function FieldAsTime(AField: TField): TDateTime;
{Ergibt Zeitwert. bei StringField: Wandelt String in TDateTime um}
begin
  if (AField is TDateField) or (AField is TTimeField) or
     (AField is TDateTimeField) then
    Result := OnlyTime(AField.AsDateTime) else
  if AField.Asstring <> '' then
    Result := StrToTime(AField.Text) else    //Formatierung bei integer
    Result := 0;
end;

procedure FieldSetTime(AField: TField; ATime: TDateTime);
{Setzt Zeitwert. Auch für String und Integer Fields}
var
  L: integer;
begin
  if (AField is TDateField) or (AField is TTimeField) or
     (AField is TDateTimeField) then
    AField.AsDateTime := ATime else
  if AField is TNumericField then
  begin
    L := Length(StrCgeChar(TNumericField(AField).DisplayFormat, ':', #0));
    AField.AsString := copy(FormatDateTime('HHNNSS', ATime), 1, L);
  end else
  begin
    //UniDAC Bug Unicode: Size ist x*4
    if AField.Size >= 20 then
      AField.Text := Copy(TimeToStr(ATime), 1, AField.Size div 4)
    else
      AField.Text := TimeToStr(ATime);
  end;
end;

function FieldAsDate(AField: TField): TDateTime;
{Wandelt Feldwert in Datum um. Y2 sicher, auch bei Stringfield}
begin
  Result := OnlyDate(AField.AsDateTime);
end;

function GetTimeInc(ATime: TDateTime; DHour, DMin, DSec: integer): TDateTime;
//Ergibt inkrementierten Zeitwert
begin
  Result := ATime;
  TimeInc(Result, DHour, DMin, DSec);
end;

procedure TimeInc(var ATime: TDateTime; DHour, DMin, DSec: integer);
(* Incrementiert Zeitwert, Decrement wenn negativ
   Datumsanteil bleibt unverändert *)
var
  wHour, wMin, wSec, wMSec: WORD;
  lHour, lMin, lSec, lMSec: longint;
  DiffSecs: longint;
  ADate: TDateTime;
begin
  ADate := OnlyDate(ATime);
  DecodeTime(ATime, wHour, wMin, wSec, wMSec);
  lHour := wHour;
  lMin := wMin;
  lSec := wSec;
  lMSec := wMSec;
  DiffSecs := (lSec + DSec) + (lMin + DMin) * 60 + (lHour + DHour) * 3600;
  if DiffSecs < 0 then
  begin
    if ADate > 0 then
      ADate := ADate - 1;
    DiffSecs := (24 * 3600) + DiffSecs;
  end;
  lHour := DiffSecs div 3600;
  Dec(DiffSecs, lHour * 3600);
  lMin := DiffSecs div 60;
  Dec(DiffSecs, lMin * 60);
  lSec := DiffSecs;
  ATime := ADate + EncodeTime(lHour mod 24, lMin, lSec, lMSec);
end;

procedure DateInc(var ADate: TDateTime; Years, Months, Days: integer);
(* Incrementiert Datumwert, Decrement wenn negativ *)
var
  AYear, AMonth, ADay: Word;
  ATime: TDateTime;
begin
  ATime := OnlyTime(ADate);
  DecodeDate(ADate, AYear, AMonth, ADay);
  Years := AYear + Years;
  Months := AMonth + Months;

  while Months < 1 do
  begin
    Years := Years - 1;
    Months := Months + 12;
  end;
  while Months > 12 do
  begin
    Years := Years + 1;
    Months := Months - 12;
  end;
  ADay := IMin(ADay, DaysOfMonth(Years, Months));

  Days := ADay + Days;
  while Days < 1 do
  begin
    Months := Months -1;
    if Months < 1 then
    begin
      Years := Years - 1;
      Months := Months + 12;
    end;
    Days := Days + DaysOfMonth(Years, Months);
  end;
  while Days > DaysOfMonth(Years, Months) do
  begin
    Days := Days - DaysOfMonth(Years, Months);
    Months := Months +1;
    if Months > 12 then
    begin
      Years := Years + 1;
      Months := Months - 12;
    end;
  end;
  ADate := EncodeDate(Years, Months, Days) + ATime;
end;

procedure DateIncWorkdays(var ADate: TDateTime; Days: integer);
(* Incrementiert Datumwert. Überspringt Arbeitstage [Sa,So] und Feiertage. *)
var
  Date2: TDateTime;
  I: integer;
begin
  Date2 := ADate;
  for I := 1 to Days do
  begin
    repeat
      Date2 := Date2 + 1;
    until not IsWochenende(Date2) and not IsFeiertag(Date2);
  end;
  ADate := Date2;
end;

function ExtractYear(ADate: TDateTime): integer;
{Ergibt Jahreszahl des Datums 4stellig Y2 sicher}
var
  AYear, AMonth, ADay: Word;
begin
  DecodeDate(Y2Date(ADate), AYear, AMonth, ADay);
  Result := AYear;
end;

function ExtractMonth(ADate: TDateTime): integer;
{Ergibt Monat des Datums 1..12}
var
  AYear, AMonth, ADay: Word;
begin
  DecodeDate(Y2Date(ADate), AYear, AMonth, ADay);
  Result := AMonth;
end;

function ExtractYearMonth(ADate: TDateTime): integer;
{Ergibt Jahreszahl|Monat des Datums i.d.F. yyyymm}
var
  AYear, AMonth, ADay: Word;
begin
  DecodeDate(Y2Date(ADate), AYear, AMonth, ADay);
  Result := AYear * 100 + AMonth;
end;

function ExtractDay(ADate: TDateTime): integer;
{Ergibt Tag des Datums 1..31}
var
  AYear, AMonth, ADay: Word;
begin
  DecodeDate(Y2Date(ADate), AYear, AMonth, ADay);
  Result := ADay;
end;

function ExtractSeconds(ADate: TDateTime): integer;
{Ergibt Anzahl Sekunden}
begin
  Result := Round(ADate * SecsPerDay);
end;

function ExtractDaysOfMonth(ADate: TDateTime): integer;
var
  AYear, AMonth: integer;
begin
  AYear := ExtractYear(ADate);
  AMonth := ExtractMonth(ADate);
  Result := DaysOfMonth(AYear, AMonth);
end;

function DaysOfMonth(Year, Month: integer): integer;
begin
  if Month in [1,3,5,7,8,10,12] then
    Result := 31 else
  if Month = 2 then
    if DaysOfYear(Year) = 366 then
      Result := 29 else
      Result := 28
  else
    Result := 30;
end;

function DaysOfYear(Year: integer): integer;
begin
  //if (Year mod 4 = 0) or (Year = 1900)  or (Year = 2000) then
  if IsLeapYear(Year) then
    Result := 366 else
    Result := 365;
end;

function Y2Year(AYear: Word): Word;
{Checkt Jahr 2000 Problematik. Ergibt korrektes Jahr: 1980..1999 2000..2079}
begin
  if AYear < 1900 then                          {19.12.02 GEN}
  begin
    if (AYear mod 100) in [00..79] then
      Result := 2000 + (AYear mod 100) else     {2000..2079}
      Result := 1900 + (AYear mod 100);         {1980..1999}
  end else
    Result := AYear;
end;

function Y2Date(ADateTime: TDateTime): TDateTime;
{Checkt Jahr 2000 Problematik. Ergibt korrektes Datum: 1980..1999 2000..2079
 bewahrt Uhrzeit}
var
  AYear, AMonth, ADay: Word;
  ATime: TDateTime;
begin
  ATime := OnlyTime(ADateTime);
  DecodeDate(ADateTime, AYear, AMonth, ADay);
  Result := EncodeDate(Y2Year(AYear), AMonth, ADay) + ATime;
end;

function OnlyDate(ADateTime: TDateTime): TDateTime;
{liefert Datumswert. Y2 sicher}
begin
  Result := Y2Date(Floor(ADateTime));
end;

function OnlyTime(ADateTime: TDateTime): TDateTime;
{liefert Zeitwert}
begin
  Result := ADateTime - Floor(ADateTime);
end;

function StrToDate4(const S: string): TDateTime;
(* 4stellige Erweiterung von StrToDate *)
begin
  Result := StrToDate(S);
  if DateToStr4(Result) <> S then      {19.04.1999 <> 19.04.99}
    Result := StrToDateY2(S);
end;

function StrToDateTime4(const S: string): TDateTime;
(* 4stelliges StrToDateTime. Uhrzeit kann fehlen *)
begin
  try
    Result := StrToDateTime(S);
    if DateTimeToStr4(Result) <> S then      {19.04.1999 <> 19.04.99}
      Result := StrToDateTimeY2(S);
  except
    Result := StrToDate4(S);
  end;
end;

function StrToDateY2(const S: string): TDateTime;
(* Y2000-sicheres StrToDate *)
begin
  Result := Y2Date(StrToDate(S));
end;

function StrToDateTol(const S: string): TDateTime;
(* StrToDate: toleriert auch Wochentage vorm Datum. Ergibt bei Fehler date *)
var
  S1: string;
begin
  S1 := S;
  if S = '' then
    Result := date else
  try
    while not IsNum(S1[1]) do              {excption wenn ''}
      System.Delete(S1, 1, 1);             {Wochentag usw. weg}
    Result := StrToDateY2(S1);
  except on E:Exception do begin
      {EProt(Application, E, 'StrToDateTol(%s)', [S]);   wen interessierts?}
      Result := date;
    end;
  end;
end;

function StrToDateTimeY2(const S: string): TDateTime;
(* Y2000-sicheres StrToDateTime. Uhrzeit kann fehlen *)
var
  ATime, ADate: TDateTime;
begin
  try
    Result := StrToDateTime(S);
    ATime := OnlyTime(Result);
  except
    Result := StrToDate(S);
    ATime := 0;
  end;
  ADate := OnlyDate(Result);         {macht auch Y2 Check}
  Result := ADate + ATime;
end;

function DateToStr4(ADate: TDateTime): string;
(* DateToStr mit 4st. Jahreszahl *)
var
  F: string;
  P: integer;
begin
  F := FormatSettings.ShortDateFormat;
  P := Pos('yyyy', F);
  if P <= 0 then
  begin
    P := Pos('yy', F);
    if P > 0 then
      System.Insert('yy', F, P);
  end;
  Result := FormatDateTime(F, ADate);
end;

function DateToStrY2(ADate: TDateTime): string;
(* Y2000-sicheres DateToStr mit 4st. Jahreszahl *)
begin
  if ADate = 0 then             //08.01.03 QDocs
    Result := '' else
    Result := DateToStr4(Y2Date(ADate));
end;

function DateTimeToStr4(ADateTime: TDateTime): string;
(* DateTimeToStr mit 4st. Jahreszahl *)
var
  F: string;
  P: integer;
begin
  if ADateTime = Floor(ADateTime) then
  begin
    Result := DateToStrY2(ADateTime);
  end else
  begin
    F := Format('%s %s', [FormatSettings.ShortDateFormat, FormatSettings.LongTimeFormat]);
    P := Pos('yyyy', F);
    if P <= 0 then
    begin
      P := Pos('yy', F);
      if P > 0 then
        System.Insert('yy', F, P);
    end;
    Result := FormatDateTime(F, ADateTime);
  end;
end;

function DateTimeToStrY2(ADateTime: TDateTime): string;
(* Y2000-sicheres DateTimeToStr mit 4st. Jahreszahl *)
begin
  Result := DateTimeToStr4(Y2Date(ADateTime));          {Y2Date bewahrt Uhrzeit}
end;

function TimeToStr2(ATime: TDateTime): string;
// wie TimeToStr aber immer mit 2stelliger Stundenzahl
begin
  Result := FormatDateTime('hh:mm:ss', ATime);
end;

function StrToDateTimeIntl(const S: string): TDateTime;
// Internationales StrToDateTime yyyy-mm-dd-hh-nn-ss. Uhrzeit kann fehlen
var
  S1, NextS: string;
  I, J: integer;
  AYear, AMonth, ADay: Word;
  AHour, AMin, ASec, AMSec: Word;
begin
  AYear := 0;  //wg Compilerwarnung
  AMonth := 0;
  ADay  := 0;
  AHour := 0;
  AMin := 0;
  ASec := 0;
  AMSec := 0;
  S1 := PStrTok(S, '-', NextS);
  for I := 1 to 6 do
  begin
    if S1 = '' then
      J := 0 else
      J := StrToInt(S1);
    case I of
      1: AYear := Y2Year(J);
      2: AMonth := J;
      3: ADay  := J;
      4: AHour := J;
      5: AMin := J;
      6: ASec := J;
    end;
    S1 := PStrTok('', '-', NextS);
  end;
  Result := EncodeDate(AYear, AMonth, ADay) +
            EncodeTime(AHour, AMin, ASec, AMSec);
end;

function DateTimeToStrIntl(ADateTime: TDateTime): string;
// Internationales DateTimeToStr yyyy-mm-dd-hh-nn-ss
begin
  Result := FormatDateTime('yyyy-mm-dd-hh-nn-ss', ADateTime);
end;

procedure CheckSql(AQuery: TuQuery);
(* SQL an DB anpassen - n.b. *)
var
  I, P1, P2, P3: integer;
  Txt: string;
begin
  if SysParam.MSSQL then
  begin
    (* 22.05.09: wirkt iVm TuDatabase.DoConnect
    aDB := QueryDatabase(AQuery);
    if aDB is TuDatabase then
      TuDatabase(aDB).CheckIsolation;           *)
  end else
  if SysParam.Informix then
  begin                //count(*) -> count *
    P1 := Pos('COUNT', Uppercase(GetstringsText(AQuery.Sql)));
    P2 := 0;  //wg Compilerwarnung
    if P1 > 0 then
    begin
      Txt := GetstringsText(AQuery.Sql);
      for I:= P1  + 5 to length(Txt) do
      begin
        if Txt[I] = '(' then
          P2 := I else
        if Txt[I] = '*' then
          exit else                                   {OK}
        if Txt[I] = ')' then
        begin
          P3 := I;
          Delete(Txt, P2+1, P3 - P2 - 1);
          Insert('*', Txt, P2+1);
          SetstringsText(AQuery.Sql, Txt);
          exit;
        end;
      end;
    end;
  end;
end;

procedure ReplaceParams(AQuery: TuQuery);
{ersetzt Parameter mit tatsächlichen Werten}
var
  S: string;
  I: integer;
  procedure ReplaceLine;
  var
    S1, NextS: string;
    AParam: TParam;
  begin
    S1 := PStrTok(S, ' ', NextS);
    S := '';
    while S1 <> '' do
    begin
      S1 := PStrTok('', ' ', NextS);
      if char1(S1) = ':' then
      begin
        AParam := AQuery.ParamByName(copy(S1, 2, 200));
        S1 := TranslateSqlOpn(AParam.Text, AParam.DataType);
      end;
      AppendTok(S, S1, ' ');
    end;
  end;
begin {ReplaceParams}
  for I := 0 to AQuery.SQL.Count - 1 do
  begin
    S := AQuery.SQL[I];
    ReplaceLine;
    AQuery.SQL[I] := S;
  end;
end;

function FieldIsNull(AField: TField): boolean;
begin                    {IsNull-Test über Inhalt = ''}
  try
    if AField is TBlobField then
      Result := GetFieldValue(AField) = '' else
    if AField is TStringField then
      Result := Trim(AField.AsString) = '' else    //23.02.10 Trim
      Result := AField.IsNull;
  except on E:Exception do
    begin
      EProt(AField, E, 'FieldIsNull', [0]);
      Result := true;
    end;
  end;
end;

function RequiredPos(ADataSet: TDataSet): integer;
(* Ergibt Index des ersten leeren Required-Feldes oder -1 *)
var
  I: integer;
  AField: TField;
begin
  Result := -1;
  for I:= 0 to ADataSet.FieldCount-1 do
  begin
    AField := ADataSet.Fields[I];
    if AField.Required and FieldIsNull(AField) then
    begin
      Result := I;
      break;
    end;
  end;
end;

function RequiredStr(ADataSet: TDataSet): string;
(* Ergibt DisplayName des ersten leeren Required-Feldes oder '' *)
var
  I: integer;
begin
  Result := '';
  I := RequiredPos(ADataSet);
  if I >= 0 then
{$ifdef WIN32}
    Result := ADataSet.Fields[I].DisplayName;
{$else}
    Result := ADataSet.Fields[I].DisplayName^;
{$endif}
end;

procedure RaiseRequired(AField: TField);
// Exception 'Feld %s darf nicht leer sein' auslösen
begin
  Prot0('Not null Error %s.%s', [OwnerDotName(AField.DataSet), AField.FieldName]);
{$ifdef WIN32}
  raise EDatabaseError.CreateFmt(SFieldRequired, [AField.DisplayName]);   {DB.CheckRequiredFields}
{$else}
Fehler16  raise DBErrorFmt(SFieldRequired, [AField.DisplayName^]);  {Exception wird erzeugt}
{$endif}
end;

procedure CheckRequired(ADataSet: TDataSet);
(* Müssen wir machen, da DB.CheckRequiredFields keine Memos Checkt
   .. und da wir es selbst aufrufen können
   Löst Exception aus wenn unerlaubtes Null Feld
   veraltet *)
var
  I: integer;
  AField: TField;
begin
  I := RequiredPos(ADataSet);
  if I >= 0 then
  begin
    AField := ADataSet.Fields[I];
    AField.FocusControl; {unter D5 wird hier nur DbGrid focusiert}
    RaiseRequired(AField);
  end;
end;

procedure FocusRequired(AForm: TForm; ADataSet: TDataSet);
(* Müssen wir machen, da DB.CheckRequiredFields keine Memos Checkt
   und FocusControl unter D5 nicht OK ist
   Löst Exception aus wenn unerlaubtes Null Feld *)
var
  I: integer;
  AField: TField;
begin
  I := RequiredPos(ADataSet);
  if I >= 0 then
  begin
    AField := ADataSet.Fields[I];
//    FocusField(AForm, AField);
//    RaiseRequired(AField);
    FocusAndRaise(AForm, AField);
  end;
end;

procedure FieldRequired(AForm: TForm; AField: TField);
//Wenn AField leer ist wird Exception 'FieldRequired' ausgelöst plus Focus
begin
  if FieldIsNull(AField) then
    FocusAndRaise(AForm, AField);
end;

procedure FocusAndRaise(AForm: TForm; AField: TField);
//setzt Focus und löst dann eine Exception 'FieldRequired' aus
begin
  try
    FocusField(AForm, AField);
  except on E:Exception do
    EProt(AForm, E, 'Fehler bei FocusAndRaise', [0]);
  end;
  RaiseRequired(AField);
end;

procedure FocusField(AForm: TForm; AField: TField);
(* Setzt Focus auf ein Control das mit Field verbunden ist.
   Wenn passende Grid aktiv ist dann wird Spalte focussiert *)
var
  J, I: integer;
begin
  if (AForm = nil) or (AField = nil) then
    Exit;
  try
    if (AForm.ActiveControl <> nil) and (AForm.ActiveControl is TDBGrid) and
       (TDBGrid(AForm.ActiveControl).DataSource.DataSet = AField.DataSet) then
    begin
      TDBGrid(AForm.ActiveControl).SelectedField := AField;
    end else
    (* Idee
    AComponent: TComponent;
    if (AForm.ActiveControl <> nil) and (AForm.ActiveControl is TComponent) then
    begin
      //Traversieren mit aufsteigendem Abstand zum Aktiven Control
      AComponent := TComponent(AForm.ActiveControl);
      I0 := AComponent.ComponentIndex;
      if not FocusComponent(AComponent) then
        for I := 1 to AForm.ComponentCount
    end else
    *)
    begin
      //rückwärts damit Standardfelder auf der Systemseite zuletzt focussiert werden
      for J := AForm.ComponentCount - 1 downto 0 do
      begin
        if (AForm is TqForm) and TqForm(AForm).ReverseFocusOrder then
          I := AForm.ComponentCount - J - 1 else
          I := J;
        if AForm.Components[I] is TDBEdit then
        begin
          with AForm.Components[I] as TDBEdit do
            if (DataSource <> nil) and (DataSource.DataSet <> nil) and
               (DataSource.DataSet = AField.DataSet) and
               (CompareText(DataField, AField.FieldName) = 0) then
            begin
              if ForceFocus(TWinControl(AForm.Components[I])) then
                break;
            end;
        end else
        if AForm.Components[I] is TDBMemo then
        begin
          with AForm.Components[I] as TDBMemo do
            if (DataSource <> nil) and (DataSource.DataSet <> nil) and
               (DataSource.DataSet = AField.DataSet) and
               (CompareText(DataField, AField.FieldName) = 0) then
            begin
              if ForceFocus(TWinControl(AForm.Components[I])) then
                break;
            end;
        end else
        if AForm.Components[I] is TDBComboBox then
        begin
          with AForm.Components[I] as TDBComboBox do
            if (DataSource <> nil) and (DataSource.DataSet <> nil) and
               (DataSource.DataSet = AField.DataSet) and
               (CompareText(DataField, AField.FieldName) = 0) then
            begin
              if ForceFocus(TWinControl(AForm.Components[I])) then
                break;
            end;
        end else
        if AForm.Components[I] is TDBCheckBox then
        begin
          with AForm.Components[I] as TDBCheckBox do
            if (DataSource <> nil) and (DataSource.DataSet <> nil) and
               (DataSource.DataSet = AField.DataSet) and
               (CompareText(DataField, AField.FieldName) = 0) then
            begin
              if ForceFocus(TWinControl(AForm.Components[I])) then
                break;
            end;
        end;
      end;
    end;
  except on E:Exception do
    EProt(AField, E, 'FocusField', [0]);
  end;
end;

function ForceFocus(aControl: TWinControl): boolean;
// erzwingt den Focus. Durchläuft alle Controls zurück und vor bis zum Ziel.
  function CheckFocus(Anchor: integer; C: TWinControl): boolean;
  begin
    Result := false;
    if C = nil then
    begin
      Prot0('ForceFocus%d is nil', [Anchor]);
    end else
    begin
      if C.Parent is TTabPage then
      begin
        if TTabbedNotebook(C.Parent.Parent).ActivePage <> TTabPage(C.Parent).Caption then
        begin
          TTabbedNotebook(C.Parent.Parent).ActivePage := TTabPage(C.Parent).Caption;
          Prot0('ForceFocus%d:%s.ActivePage=%s', [Anchor, OwnerDotName(TTabbedNotebook(C.Parent.Parent)), TTabPage(C.Parent).Caption]);
        end;
      end else
      if C.Parent is TPage then
      begin
        if TNotebook(C.Parent.Parent).ActivePage <> TPage(C.Parent).Caption then
        begin
          TNotebook(C.Parent.Parent).ActivePage := TPage(C.Parent).Caption;
          Prot0('ForceFocus%d:%s.ActivePage=%s', [Anchor, OwnerDotName(TNotebook(C.Parent.Parent)), TPage(C.Parent).Caption]);
        end;
      end else
      if C.Parent is TTabSheet then
      begin
        if TPageControl(C.Parent.Parent).ActivePage <> TTabSheet(C.Parent) then
        begin
          TPageControl(C.Parent.Parent).ActivePage := TTabSheet(C.Parent);
          Prot0('ForceFocus%d:%s.ActivePage=%s', [Anchor, OwnerDotName(TPageControl(C.Parent.Parent)), TTabSheet(C.Parent).Caption]);
        end;
      end;
      if C.CanFocus then
      begin
        if not C.Focused then
        begin
          C.SetFocus;
          if SysParam.ProtBeforeOpen then
            Prot0('ForceFocus%d:%s fokussiert', [Anchor, OwnerDotName(C)]);
        end;
        Result := true;
      end else
      begin
        if SysParam.ProtBeforeOpen then
          Prot0('ForceFocus%d:%s nicht fokussierbar', [Anchor, OwnerDotName(C)]);
      end;
    end;
  end;
var
  L: TStringList;
  C1: TWinControl;
  I: integer;
begin
  Result := false;
  if (aControl = nil) or (GetParentForm(aControl) = nil) then
  begin
    Prot0('ForceFocus(nil)', [0]);
    Exit;
  end;
  with GetParentForm(aControl) do
    if not (Visible and Enabled) then
    begin
      Prot0('ForceFocus(%s): Form nicht fokussierbar', [OwnerDotName(aControl)]);
      Exit;
    end;
  L := TStringList.Create;
  try
    //Kette des Ziel-Controls bilden
    if SysParam.ProtBeforeOpen then
      Prot0('ForceFocus(%s)', [OwnerDotName(aControl)]);
    C1 := aControl.Parent;
    while C1 <> nil do
    begin
      if SysParam.ProtBeforeOpen then
        Prot0('ForceFocus.Chain(%s)', [OwnerDotName(C1)]);
      L.AddObject(C1.Name, C1);
      C1 := C1.Parent;
    end;
    //Kette focussierend durchlaufen
    for I := L.Count - 1 downto 0 do
      CheckFocus(1, TWinControl(L.Objects[I]));
    for I := 0 to L.Count - 1 do
      CheckFocus(2, TWinControl(L.Objects[I]));
    Result := CheckFocus(3, aControl);
    if not Result then
      Prot0('ForceFocus:%s nicht fokussierbar', [OwnerDotName(aControl)]);
  finally
    L.Free;
  end;
end;

function CheckEOF(ADataSet: TDataSet): boolean;
(* Testet ob aktueller Datensatz der letzte ist.
   Setzt ADataSet auf EOF wenn Test positiv *)
var
  ABookMark: TBookMark;
begin
  if not ADataSet.EOF then
  begin
    ABookMark := ADataSet.GetBookMark;
    ADataSet.Next;
    if not ADataSet.EOF then
      ADataSet.GotoBookMark(ABookMark);
    ADataSet.FreeBookMark(ABookMark);
  end;
  Result := ADataSet.EOF;
end;

function GetName(AComponent: TComponent): string;
(* ergibt Name der Componente oder '(nil)' *)
begin
  try
    Result := AComponent.Name;
  except
    Result := '(nil)';
  end;
end;

function FindClassComponent(TheOwner: TComponent; ClassRef: TComponentRef):
  TComponent;
{liefert die erste Componente auf dem Formular die dem Typ entspricht}
var
  I: integer;
begin
  Result := nil;
  with TheOwner do
    for I:= 0 to ComponentCount - 1 do
      if Components[i] is ClassRef then
      begin
        Result := Components[i];
        break;
      end;
end;

function FindTagControl(TheParent: TWinControl; ATag: longint;
  ClassRef: TComponentRef): TComponent;
{liefert erstes Control vom Typ=ClassRef mit Parent=TheParent deren Tag=ATag ist
 wenn TheParent=nil dann wird nächstes Control bzgl. letztem Parent geliefert}
const
  OurParent: TWinControl = nil;
  I: integer = 0;
begin
  Result := nil;
  if TheParent <> nil then
  begin
    OurParent := TheParent;
    I := 0;
  end;
  if OurParent <> nil then
    with OurParent do
      while I < ControlCount do
        if (Controls[i] is ClassRef) and (Controls[i].Tag = ATag) then
        begin
          Result := Controls[I];
          Inc(I);
          break;
        end else
          Inc(I);
end;

function FindTagComponent(TheOwner: TComponent; ATag: longint;
  ClassRef: TComponentRef): TComponent;
{liefert erste Komponente vom Typ=ClassRef mit Owner=TheOwner deren Tag=ATag ist
 wenn TheOwner=nil dann wird nächste Komponente geliefert}
const
  OurOwner: TComponent = nil;
  I: integer = 0;
begin
  Result := nil;
  if TheOwner <> nil then
  begin
    OurOwner := TheOwner;
    I := 0;
  end;
  if OurOwner <> nil then
    with OurOwner do
      while I < ComponentCount do
        if (Components[i] is ClassRef) and (Components[i].Tag = ATag) then
        begin
          Result := Components[I];
          Inc(I);
          break;
        end else
          Inc(I);
end;

function IsDescendantOfParent(ADesc: TControl; AParent: TWinControl): boolean;
//ergibt true wenn ADesc ein Nachfolger von AParent ist (ADesc.Parent...Parent=AParent)
begin
  if (ADesc = nil) or (AParent = nil) then
    Result := false else
  if ADesc = AParent then
    Result := true else
  if ADesc.Parent = AParent then
    Result := true else
    Result := IsDescendantOfParent(ADesc.Parent, AParent);
end;

procedure GetControlsValues(TheParent: TWinControl; AList: TStrings);
// Liest Eingabewerte der Controls eines Panels und schreibt sie nach AList.
// Löscht AList NICHT! wg rekursivem Aufruf.
var
  I, J, P: integer;
  AControl: TControl;
  S: string;
begin
  if TheParent.ControlCount > 0 then
  try
    for I:= 0 to TheParent.ControlCount-1 do
    begin
      AControl := TheParent.Controls[I];
      if AControl is TCustomMemo then
        with AControl as TCustomMemo do
        begin
          AList.Add(Format('%s=%d',[Name, Lines.Count]));
          for J := 0 to Lines.Count-1 do
            AList.Add(Format('%s.%d=%s',[Name, J, Lines.Strings[J]]));
        end
      else if AControl is TCustomListBox then
        with AControl as TCustomListBox do
        begin
          AList.Add(Format('%s=%d',[Name, Items.Count]));
          for J := 0 to Items.Count-1 do
            AList.Add(Format('%s.%d=%s',[Name, J, Items.Strings[J]]));
        end
      else if AControl is TCustomEdit then
        AList.Add(Format('%s=%s',[AControl.Name, TCustomEdit(AControl).Text]))
      else if AControl is TCustomComboBox then
        AList.Add(Format('%s=%s',[AControl.Name, TDummyCustomComboBox(AControl).Text]))
      else if AControl is TCustomCheckBox then
      begin
        AList.Add(Format('%s=%d',[AControl.Name,
          ord(TDummyCustomCheckBox(AControl).State)]));
      end else
      if AControl is TCustomRadioGroup then
      begin
        AList.Add(Format('%s=%d',[AControl.Name,
          ord(TDummyCustomRadioGroup(AControl).ItemIndex)]));
      end else
      if AControl is TRadioButton then
      begin
        AList.Add(Format('%s=%d',[AControl.Name,
          ord(TRadioButton(AControl).Checked)]));
      end else
      if AControl is TWinControl then
      begin
        GetControlsValues(TWinControl(AControl), AList);  //Rekursion
      end;
    end;
    for I := 0 to AList.Count-1 do               {falls Blank nach '='}
    begin                                        {dann durch FFh ersetzen}
      P := Pos('= ', AList.Strings[I]);
      if P = Pos('=', AList.Strings[I]) then    {ohne Blank}
      begin
        S := AList.Strings[I];              // edit1= B
        S[P+1] := #$FF;
        AList.Strings[I] := S;              // edit1=$FFB
      end
    end;
  finally
  end;
end;

procedure PutControlsValues(TheParent: TWinControl; AList: TStrings);
// Belegt Eingabewerte mit Inhalt von AList
// Es werden nur Controls unterhalb von TheParent geändert!
var
  I, J, N: integer;
  AOwner: TComponent;
  AComponent: TComponent;
  function RightSide(Index: integer): string;
  var                                {wie StrValue, ohne Trim, ersetzt $FF}
    P: integer;
  begin
    P := Pos('=', AList.Strings[Index]);
    if (P > 0) and (length(AList.Strings[Index]) > P) then
    begin
      result := Copy(AList.Strings[Index], P+1, Maxint);
      if result[1] = #$FF then
        result[1] := ' ';
    end else
      result := '';
  end;
begin
  if TheParent is TForm then
    AOwner := TheParent else
    AOwner := TheParent.Owner;
  if AOwner = nil then
  begin  //'ReadValues:(%s) nicht gefunden'
    Prot0(SQwf_Form_005,[OwnerDotName(TheParent)]);
  end else
  try
    I := 0;
    while I < AList.Count do
    begin
      AComponent := AOwner.FindComponent(StrParam(AList.Strings[I]));
      if AComponent = nil then
      begin
        //'ReadValues:(%s) nicht gefunden'
        Prot0(SQwf_Form_005,[OwnerDotName(TheParent) + '.' + StrParam(AList.Strings[I])]);
        Inc(I);
        continue;
      end;
      if not (AComponent is TControl) then
      begin
        Continue;
      end;
      if not IsDescendantOfParent(TControl(AComponent), TheParent) then
      begin
        Prot0('%s is not descendant of %s', [OwnerDotName(AComponent), OwnerDotName(TheParent)]);
        Continue;
      end;

      if AComponent is TCustomMemo then
        with AComponent as TCustomMemo do
        begin
          N := StrToInt(RightSide(I));
          Lines.Clear;
          for J := 0 to N-1 do
          begin
            Inc(I);
            Lines.Add(RightSide(I));
          end;
        end
      else if AComponent is TCustomListBox then
        with AComponent as TCustomListBox do
        begin
          N := StrToInt(RightSide(I));
          Items.Clear;
          for J := 0 to N-1 do
          begin
            Inc(I);
            Items.Add(RightSide(I));
          end;
        end
      else if AComponent is TCustomEdit then
          TCustomEdit(AComponent).Text := RightSide(I)
      else if AComponent is TCustomComboBox then
        with AComponent as TCustomComboBox do
        begin
          TDummyCustomComboBox(AComponent).Text := RightSide(I);
          //Text := RightSide(I);
          for J := 0 to TCustomComboBox(AComponent).Items.Count - 1 do
            if TCustomComboBox(AComponent).Items[J] = TDummyCustomComboBox(AComponent).Text then
              TCustomComboBox(AComponent).ItemIndex := J;
        end
      else if AComponent is TCustomCheckBox then
      begin
        case StrToInt(RightSide(I)) of
0:        TDummyCustomCheckBox(AComponent).State := cbUnchecked;
1:        TDummyCustomCheckBox(AComponent).State := cbChecked;
2:        TDummyCustomCheckBox(AComponent).State := cbGrayed;
        end;
      end else
      if AComponent is TCustomRadioGroup then
      begin
          TDummyCustomRadioGroup(AComponent).ItemIndex := StrToIntTol(RightSide(I));
      end else
      if AComponent is TRadioButton then
      begin
        TRadioButton(AComponent).Checked := boolean(StrToIntTol(RightSide(I)));
      end;

      Inc(I);
    end;
  finally
  end;
end;

procedure SaveControlsToIni(TheParent: TWinControl; Section: string);
// Speichert Inhalt/Zustand der visuellen Komponenten in einem Panel in der INI.
// Die Section wird komplett gelöscht und überschrieben
var
  L: TStringList;
begin
  if Section = '' then
    Section := OwnerDotName(TheParent);
  L := TStringList.Create;
  try
    GetControlsValues(TheParent, L);
    IniKmp.ReplaceSection(Section, L);
  finally
    L.Free;
  end;
end;

procedure LoadControlsFromIni(TheParent: TWinControl; Section: string);
//Restauriert Inhalt/Zustand der visuellen Komponenten aus der INI
var
  L: TStringList;
begin
  if Section = '' then
    Section := OwnerDotName(TheParent);
  L := TStringList.Create;
  try
    IniKmp.ReadSectionValues(Section, L);
    PutControlsValues(TheParent, L);
  finally
    L.Free;
  end;
end;

function DispatchBC(Sender: TComponent; AComponent: TComponent;
  MsgNr: integer; Data: longint): longint;
{TWMBroadcast Message an Componente senden. Vergl. Qwf_form.BroadcastMessage}
var
  Msg: TWMBroadcast;
begin
  Msg.Msg := MsgNr;
  Msg.Data := Data;
  Msg.Sender := Sender;
  Msg.Result := 0;
  AComponent.Dispatch(Msg);      {perform}
  Result := Msg.Result;
end;

procedure CheckBoxChange(aChb: TCustomCheckBox);
// ruft OnClick Ereignis der Checkbox auf
begin
  TDummyCheckBox(aChb).Click;
end;

procedure CheckBoxSetChecked(aChb: TCustomCheckBox; AValue: boolean);
// Wert einer Checkbox programmatisch ändern mit OnClick (auch wenn nicht geändert)
begin
  TDummyCheckBox(aChb).Checked := AValue;
  CheckBoxChange(aChb);
end;

procedure SetCheckBoxAndChange(aChb: TCustomCheckBox; AValue: boolean);
// Wert einer Checkbox programmatisch ändern
// und OnClick-Ereignis auslösen wenn Check-Wert geändert wurde
begin
  if (TDummyCheckBox(aChb).Checked <> AValue) or (TDummyCheckBox(aChb).State = cbGrayed) then
  begin
    CheckBoxSetChecked(aChb, AValue);
  end;
end;

procedure ComboBoxChange(aCob: TCustomComboBox);
begin {ruft OnChange Ereignis der Combobox auf}
  aCob.Perform(CN_COMMAND, MAKELONG(0, CBN_SELCHANGE), 0);
end;

procedure ComboBoxSetText(aCob: TCustomComboBox; AText: string);
var
  cobIndex: integer;
begin {setzt Text und ruft OnChange Ereignis der Combobox auf (getestet ents.eanv)}
  cobIndex := aCob.Items.IndexOf(AText);
  if cobIndex < 0 then
  begin
    aCob.ItemIndex := -1;  //18.02.13
    TDummyCustomComboBox(aCob).Text := aText;
    ComboBoxChange(aCob);
  end else
    ComboBoxSetIndex(aCob, cobIndex);    //ab 13.04.10
end;

procedure ComboBoxSetIndex(aCob: TCustomComboBox; aIndex: integer);
begin {setzt ItemIndex und ruft OnChange Ereignis der Combobox auf (auch wenn nicht geändert)}
  aCob.ItemIndex := aIndex;
  ComboBoxChange(aCob);
end;

function ComboBoxText(aCob: TCustomComboBox): string;
begin {ergibt Inhalt des aktuellen Items}
  if aCob.ItemIndex >= 0 then
    Result := aCob.Items[aCob.ItemIndex] else
    Result := '';
end;

procedure ListBoxScrollWidth(aListBox: TListBox; S: string);
//Falls S nicht komplett sichtbar wird horizontale Scrollbar eingefügt
var
  ScrollWidth: integer;
begin
  ScrollWidth := MulDiv(aListBox.Canvas.TextWidth(S), 4, 3);  //Test QDocs
  if ScrollWidth > SendMessage(aListBox.Handle, LB_GetHorizontalExtent, 0, 0) then
    SendMessage(aListBox.Handle, LB_SetHorizontalExtent, ScrollWidth, 0); {horizontal scrollen}
end;

procedure ListBoxScrollWidths(aListBox: TListBox);
//Falls Inhalt horizontal nicht komplett sichtbar wird Scrollbar eingefügt
var
  I: integer;
begin
  for I := 0 to aListBox.Items.Count - 1 do
    ListBoxScrollWidth(aListBox, aListBox.Items[I]);
end;

function XCrypt(s: AnsiString): AnsiString;
var
  i: integer;
const
  k: string = 'Brzybolowski';
begin
  Result := '';
  for i:= 1 to length(s) do     {sieht sogar in Pascal unübersichtlich aus :-) }
    Result := Result + AnsiChar(chr(ord(s[i]) xor (ord(k[(i mod length(k))+1]))));
end;

function ByteArrToStr(BA: array of Byte): AnsiString;
//kopiert Byte Array nach AnsiString. Unabhängig vom lokalen Gebietsschema.
begin
  SetString(Result, PAnsiChar(@BA[0]), Length(BA));
end;

function StrToHexStr(const InString: AnsiString): AnsiString;
//Umwandlung in lesbaren Hex-Zeichen. Verdoppelt InString-Länge
var
  I: integer;
  //Ch: PAnsiChar;
  By: Byte;
begin
  Result := '';
  for I := 1 to Length(InString) do
  begin
    //Result := Result + Format('%02.2X', [ord(InString[I])]);
    By := Byte(InString[I]);
    Result := Result + AnsiString(IntToHex(By, 2));
  end;
end;

function HexStrToStr(const InString: AnsiString): AnsiString;
//Umwandlung von Hex- nach lesbaren Zeichen. Halbiert InString-Länge
var
  I, N: integer;
  By: Byte;
begin
  Result := '';
  N := length(InString);
  I := 1;
  while I < N do
  begin
    //Result := Result + chr(StrToIntDef('$' + InString[I] + InString[I + 1], ord('*')));
    By := StrToIntDef('$' + String(InString[I]) + String(InString[I + 1]), ord('*'));
    Result := Result + AnsiChar(By);
    I := I + 2;
  end;
end;

function HexByteToBinStr(AByte: Byte): string;
var
  S: string;
begin
  S := Format('%02.2X', [AByte]);
  Result := HexCharToBinStr(S[1]) + HexCharToBinStr(S[2]);
end;

function HexCharToBinStr(HC: char): string;
begin
  case UpCase(HC) of
  '0': Result := '0000';
  '1': Result := '0001';
  '2': Result := '0010';
  '3': Result := '0011';
  '4': Result := '0100';
  '5': Result := '0101';
  '6': Result := '0110';
  '7': Result := '0111';
  '8': Result := '1000';
  '9': Result := '1001';
  'A': Result := '1010';
  'B': Result := '1011';
  'C': Result := '1100';
  'D': Result := '1101';
  'E': Result := '1110';
  'F': Result := '1111';
  else
       Result := '0001';
  end;
end;

{$Q-}    //Overflow erlaubt
function Encrypt(const InString: AnsiString): AnsiString;
var
  I, Key: integer;
begin
  Result := '';
  Key := SysParam.StartKey;
  for I := 1 to Length(InString) do
  begin
    Result := Result + AnsiChar(Byte(InString[I]) xor (Key shr 8));
    {ProtA('encrypt key %d: %d xor %d    = %d', [
        I-1, Byte(InString[I]), Key shr 8, ord(Result[i])]); }
    Key := (Byte(Result[I]) + Key) * SysParam.MultKey + SysParam.AddKey;
  end;
  //Prot0('Encrypt(%s)=(%s)', [InString, Result]);
end;

function Decrypt(const InString: AnsiString): AnsiString;
var
  I, Key: integer;
  Ch: AnsiChar;
begin
  Result := '';
  Key := SysParam.StartKey;
  for I := 1 to Length(InString) do
  begin
    Ch := AnsiChar(Byte(InString[I]) xor (Key shr 8));
    Result := Result + Ch;
    Key := (Byte(InString[I]) + Key) * SysParam.MultKey + SysParam.AddKey;
  end;
  //Prot0('Decrypt(%s)=(%s)', [InString, Result]);
end;

function EncryptPassw(const InString: AnsiString; Len: integer = 80): AnsiString;
//Passwort als Hexstring der festen Länge <Len> verschlüsseln.
//Len muss mindestens 2*Länge von Passw haben und gerade sein. Ansonsten erfolgt Exception.
var
  S: AnsiString;
begin
  if TrimA(InString) = '' then
  begin  //Leeres Passwort nicht verschlüsseln
    Result := '';
    Exit;
  end;
  if length(InString) * 2 > Len then
    EError('EncryptPassw: Password (%d) to long (%d)', [length(InString) * 2, Len]);
  S := InString;
  while Length(S) < (Len div 2) do   //08.01.12 bug bei len
    S := S + ' ';
  Result := StrToHexStr(EnCrypt(S));
end;

function DecryptPassw(const InString: AnsiString): AnsiString;
//Passwort entschlüsseln. Muss mit EncryptPassw verschlüsselt worden sein.
// wenn InString nicht mit Hex-Zeichen beginnt dann wird InString unverändert zurückgegeben
begin
  if not IsHexDec(Char1(InString)) then
    Result := InString else
    Result := TrimA(DeCrypt(HexStrToStr(InString)));
end;

function CompareStrings(S1, S2: TStrings): integer;
{vergleicht stringlisten: 0=gleich}
var
  P1, P2: PChar;
begin
  P1 := S1.GetText;
  P2 := S2.GetText;
  Result := StrComp(P1, P2);
  StrDispose(P1);
  StrDispose(P2);
end;

function GetStringsText(Value: Tstrings): string;
{wandelt stringliste in string um}
begin
{$ifdef WIN32}
  Result := Value.Text;
{$else}
  AText := Value.GetText;
  Result := StrPas(AText);
  StrDispose(AText);
{$endif}
end;

procedure SetStringsText(Strings: TStrings; Text: string);
begin
{$ifdef WIN32}
  Strings.Text := Text;
{$else}
  PText := StrPNew(Text);
  Strings.SetText(PText);
  StrDispose(PText);
{$endif}
end;

procedure FreeObjects(Strings: TStrings);
{Alle Objekte von Strings und Strings selbst entfernen}
var
  I: integer;
begin
  if assigned(Strings) then
  try
    for I := 0 to Strings.Count - 1 do
      if assigned(Strings.Objects[I]) then
      try
        Strings.Objects[I].Free;
      except on E:Exception do
        EProt(Application, E, 'FreeObjects[%d]', [I]);
      end;
  finally
    FreeAndNil(Strings);
  end;
end;

procedure ClearObjects(Strings: TStrings);
{Alle Objekte von Strings entfernen. Strings selbst bleiben erhalten und ohne Elemente}
var
  I: integer;
begin
  if assigned(Strings) then
  try
    for I := 0 to Strings.Count - 1 do
      if assigned(Strings.Objects[I]) then
        Strings.Objects[I].Free;
  finally
    Strings.Clear;
  end;
end;

function CharCount(C: Char; S: string): integer;
{Zählt Anzahl C in S}
var
  I: integer;
begin
  Result := 0;
  for I := 1 to length(S) do
    if S[I] = C then
      Inc(Result);
end;

procedure SetStringsWidth(L: TStrings; LineWidth: integer; Trenner: string = '\');
{Breite der Zeilen beschränken. Trenner: Zeichen für Fortsetzung in nächster Zeile
 Linewidth: Breite incl. Trenner, 0 = epandieren}
var
  I: integer;
  S: string;
begin
  if L = nil then
    Exit;
  if L.Count = 0 then
    Exit;
  if LineWidth >= 2 then
  begin  //schmäler machen
    I := 0;
    while I <= L.Count - 1 do
    begin
      S := L[I];
      if Length(S) > LineWidth-1 then
      begin
        L[I] := Copy(S, 1, LineWidth-1) + Trenner;
        S := Copy(S, LineWidth, Maxint);
        L.Insert(I + 1, S);
      end;
      I := I + 1;
    end;
  end else
  if LineWidth = 0 then
  begin  //wieder breiter machen
    I := L.Count - 2;  //mit 2.letztem beginnen
    while I >= 0 do
    begin
      S := L[I];
      if EndsWith(S, Trenner) and (I < L.Count - 1) then
      begin
        L[I] := Copy(S, 1, Length(S) - Length(Trenner)) + L[I + 1];
        L.Delete(I + 1);
      end else
        I := I - 1;
    end;
  end;
end;

function ReplaceCRLF(S, ReplaceString: string): string;
{Löscht CrLf aus einem string und ersetzt es mit ReplaceString}
var
  ReplaceSource: char;
begin
  if Pos (CR, S) > 0 then
    ReplaceSource := CR else
  if Pos (LF, S) > 0 then
    ReplaceSource := LF else
  begin
    Result := S;
    Exit;
  end;
  Result := StrCgeStr(S, ReplaceSource, ReplaceString);
  Result := StrCgeChar(Result, chr(10), #0);
  Result := Trim(StrCgeChar(Result, chr(13), #0));
end;

function RemoveCrlf(S: string): string;
{Löscht CrLf aus einem string und ersetzt es mit 1 Blank}
begin
  Result := StrCgeStrStr(S, CRLF, ' ', false);
  Result := StrCgeChar(Result, chr(10), ' ');  //Bug 16.02.12
  Result := Trim(StrCgeChar(Result, chr(13), ' '));
end;

function RemoveTrailCrlf(const S: string): string;
{Löscht CR und LF Sequenzen am Ende eines String. Löscht auch Leerzeichen am Ende}
begin
  Result := RTrim(S);
  while Pos(CharN(Result), CRLF) > 0 do   //solange letztes Zeichen ein \n oder ein \r ist:
  begin
    System.Delete(Result, length(Result), 1);
    Result := RTrim(Result);
  end;
end;

function RemoveAccelChar(S: string): string;
{Löscht '&' aus einem string}
begin
  Result := StrCgeChar(S, '&', #0);
end;

function DuplAccelChar(S: string): string;
{Ersetzt '&' mit '&&', damit '&' angezeigt wird, z.B. für PanSMess
 kann mehrmals aufgerufen werden ohne Vervierfachung }
const
  MagicStr: string = '#_){]_#';  //sollte normal nicht vorkommen
begin
  Result := StringReplace(S, '&&', MagicStr, [rfReplaceAll]);
  Result := StringReplace(Result, '&', '&&', [rfReplaceAll]);
  Result := StringReplace(Result, MagicStr, '&&', [rfReplaceAll]);
end;

function AnsiCopy(S: AnsiString; Index: Integer; Count: Integer): AnsiString;
//wie Copy()
begin
  Result := AnsiString(Copy(String(S), Index, Count));
end;

function StrCtrl(const S: AnsiString): AnsiString;
{Str from Ctrl: Wandelt Steuerzeichen in druckbare Zeichenfolge um}
(* STX -> ^B usw. *)
var
  I, N: integer;
  Buffer: array[0..4097] of AnsiChar;
begin
  N := 0;
  {Buffer[0] := #0;}
  for I := 1 to length(S) do
    if N < SizeOf(Buffer) - 3 then
      if ord(S[I]) < 32 then
      begin
        Buffer[N] := '^';
        Inc(N);
        Buffer[N] := AnsiChar(ord(S[I]) + 64);
        Inc(N);
      end else
      begin
        Buffer[N] := S[I];
        Inc(N);
        if S[I] = '^' then
        begin  // ^ --> ^^
          Buffer[N] := S[I];
          Inc(N);
        end;
      end;
  Buffer[N] := #0;
  Result := StrPas(Buffer);
  (* Leak
  Result := '';
  for I := 1 to length(S) do
    if ord(S[I]) < 32 then
      Result := Result + '^' + chr(ord(S[I]) + 64) else
      Result := Result + S[I];
  *)
end;

function CtrlStr(const S: AnsiString): AnsiString;
{Ctrl from Str: Wandelt druckbare Zeichenfolge in Steuerzeichen um}
(* ^B --> #2 usw. *)
var
  P, Offs: integer;
begin
  Result := S;
  Offs := 0;
  while true do
  begin
    P := Offs + Pos('^', String(AnsiCopy(Result, Offs + 1, Maxint)));
    if (P = 0) or (P = length(Result)) then
      break;
    System.Delete(Result, P, 1);
    if Result[P] <> '^' then  // ^^ --> ^
      Result[P] := AnsiChar(ord(Result[P]) - 64);
    Offs := P;
  end;
end;

function StrCgeChar(const S: AnsiString; chVon, chNach: AnsiChar): AnsiString;
// Ansi-Verion
var
  I: integer;
begin
  Result := '';
  for I := 1 to length(S) do
    if S[I] = chVon then
    begin
      if chNach <> #0 then
        Result := Result + chNach;
    end else
      Result := Result + S[I];
end;

function StrCgeChar(const S: string; chVon, chNach: char): string;
{ersetzt ein Zeichen durch ein anderes. Wenn chNach = #0 wird das Zeichen gelöscht}
var
  I: integer;
begin
//  Result := S;
//  while Pos(chVon, Result) > 0 do
//    if chNach = #0 then
//      System.Delete(Result, Pos(chVon, Result), 1) else
//      Result[Pos(chVon, Result)] := chNach;
//
  if Pos(chVon, S) = 0 then
  begin  //Optimierung 15.01.12
    Result := S;
    Exit;
  end;
  Result := '';
  for I := 1 to length(S) do
    if S[I] = chVon then
    begin
      if chNach <> #0 then
        Result := Result + chNach;
    end else
      Result := Result + S[I];
end;

function StrCgeStr(const S: string; chVon: char; SNach: string): string;
{ersetzt ein Zeichen durch einen anderen String}
var
  I: integer;
begin
  if Pos(chVon, S) = 0 then
  begin  //Optimierung 15.01.12
    Result := S;
    Exit;
  end;
  Result := S;
  for I := length(Result) downto 1 do
  begin
    if Result[I] = chVon then
    begin
      System.delete(Result, I, 1);
      if SNach <> '' then
        System.Insert(SNach, Result, I);
    end;
  end;
end;

function StrCgeStrStr(const S: string; const SVon, SNach: string;
  IgnoreCase: boolean): string;
{ersetzt einen String durch einen anderen String}
var
  ReplaceFlags: TReplaceFlags;
begin
  if IgnoreCase then
    ReplaceFlags := [rfReplaceAll, rfIgnoreCase] else
    ReplaceFlags := [rfReplaceAll];
  Result := StringReplace(S, SVon, SNach, ReplaceFlags);
end;

function StrToValidIdent(const S: string): string;
// Ergibt gültigen Komponentenbezeichner. ÄÖÜäöüß -> ae,oe,ss,..
// erstes Zeichen keine Ziffer.
// ungültige Zeichen als '_'
var
  I: integer;
begin
  (* mit strcat zu umständlich - 24.05.07
  var BufChar: array[0..1] of Char;
  Buffer: array[0..4097] of Char;
  Buffer[0] := #0;
  BufChar[1] := #0;
  if (length(S) >= 1) and (S[1] in ['0'..'9']) then
  begin
    StrCat(Buffer, '_');
  end;
  for I:= 1 to length(S) do
    if StrLen(Buffer) < SizeOf(Buffer) - 3 then
      case S[I] of
        'Ä': StrCat(Buffer, 'AE');
        'Ö': StrCat(Buffer, 'OE');
        'Ü': StrCat(Buffer, 'UE');
        'ä': StrCat(Buffer, 'ae');
        'ö': StrCat(Buffer, 'oe');
        'ü': StrCat(Buffer, 'ue');
        'ß': StrCat(Buffer, 'ss');
        '0'..'9','A'..'Z','a'..'z':
           begin
             BufChar[0] := S[I];
             StrCat(Buffer, BufChar);
           end;
      else
        StrCat(Buffer, '_');
      end;
  Result := StrPas(Buffer);
  *)

  if (length(S) >= 1) and CharInSet(S[1], ['0'..'9']) then
    Result := '_' else      //darf nicht mit Ziffer beginnen    02.12.02 QDispo.Divo.Rechte
    Result := '';
  for I := 1 to length(S) do
  begin
    case S[I] of
      'Ä': Result := Result + 'AE';
      'Ö': Result := Result + 'OE';
      'Ü': Result := Result + 'UE';
      'ä': Result := Result + 'ae';
      'ö': Result := Result + 'oe';
      'ü': Result := Result + 'ue';
      'ß': Result := Result + 'ss';
      '0'..'9','A'..'Z','a'..'z':
        Result := Result + S[I];
    else
      Result := Result + '_';
    end;
  end;
end;

function StrToValidFilename(const S: string): string;
// ungültige Zeichen als '_' ersetzen. Nicht für Filepfade!
// Auf 255 Zeichen begrenzen
// 08.04.11 md mehrfache '_' unterdrücken
var
  I: integer;
begin
  Result := '';
  for I := 1 to IMin(Length(S), 255) do
  begin
    if CharInSet(S[I], ['/','\',':','*','"','?','<','>','|']) then
    begin
      if (Result = '') or not EndsWith(Result, '_') then
        Result := Result + '_';
    end else
      Result := Result + S[I];
  end;
end;

function StrToIntl(const S: string): string;
// Ergibt String ohne Umlaute und ß
var
  I: integer;
begin
  Result := '';
  for I := 1 to length(S) do
  begin
    case S[I] of
      'Ä': Result := Result + 'AE';
      'Ö': Result := Result + 'OE';
      'Ü': Result := Result + 'UE';
      'ä': Result := Result + 'ae';
      'ö': Result := Result + 'oe';
      'ü': Result := Result + 'ue';
      'ß': Result := Result + 'ss';
    else
      Result := Result + S[I];
    end;
  end;
end;

function TrimIdent(const S: string): string;
(* Extrahiert gültige Alphanumerische Zeichen und Umlaute. Für BCNextNullCtl *)
begin
  Result := StrCgeChar(StrToValidIdent(S), '_', #0);
end;

function StrPNew(const Source: AnsiString): PAnsiChar;
{dupliziert einen Pascall-string in einen nullterminierten string
 der mit StrDispose wieder gelöscht werden muß}
var
  I : Integer;
begin
  Result := AnsiStrAlloc(length(Source) + 3);
{$ifdef WIN32}
  for I:=0 to length(Source) - 1 do
  begin
   Result[I] := Source[I + 1];
  end;
  Result[length(Source)] := #0;
{$else}
  StrPCopy(Result, Source);
{$endif}
end;

function StrLPas(Str: PAnsiChar; Len : integer): AnsiString;
// Kopiert Teilstring nach Pascalstring. Bricht nicht bei #0 ab.
var
  I : integer;
begin
  Result := '';
  for I := 0 to Len-1 do
    Result := Result + Str[I];
end;

function StrLPas(Str: PWideChar; Len : integer): string;
// Kopiert Teilstring nach Pascalstring. Bricht nicht bei #0 ab.
var
  I : integer;
begin
  Result := '';
  for I := 0 to Len-1 do
    Result := Result + Str[I];
end;

function StrIPos(Str1, Str2: PAnsiChar): PAnsiChar;
(* Wie StrPos (Pos von Str2 in Str1) aber nicht Case Sensitiv *)
var
  U1, U2, UResult: PAnsiChar;
begin
  U1 := nil; U2 := nil;
  try
    U1 := StrUpper(StrNew(Str1));
    U2 := StrUpper(StrNew(Str2));
    UResult := StrPos(U1, U2);
    if UResult = nil then
      Result := nil else
      Result := Str1 + (UResult - U1);
  finally
    StrDispose(U1);
    StrDispose(U2);
  end;
end;

function PosI(Substr: string; S: string): Integer;
(* wie Pos aber nicht Case sensitiv (ignore case) *)
begin
  Result := Pos(AnsiUpperCase(Substr), AnsiUpperCase(S));   //ANSI ab 10.02.04 
end;

function ReverseStr(S: string): string;
(* dreht die Reihenfolge in S um  (aus ABC wird CBA) *)
var
  I, J: integer;
begin
  Result := S;
  J := 1;
  for I := length(S) downto 1 do
  begin
    Result[J] := S[I];
    Inc(J);
  end;
end;

function PosR(Substr: string; S: string): Integer;
(* wie Pos - findet letztes (am weitesten Rechts) Vorkommen von SubStr in S
   ergibt 0 wenn nicht gefunden *)
var
  P: integer;
begin
  Result := Pos(SubStr, S);
  if Result > 0 then
  begin
    P := PosR(SubStr, copy(S, Result + 1 {length(SubStr)}, length(S)));
    Result := Result + P;
  end;
  (*P := Pos(ReverseStr(SubStr), ReverseStr(S)); {mit umgedrehter Reihenfolge}
  if P > 0 then
    Result := length(S) + 2 - P - length(SubStr) else
    Result := 0;                  020899*)
end;

function PosRI(Substr: string; S: string): Integer;
(* wie PosR - aber nicht Case Sensitiv. Ergibt 0 wenn nicht gefunden *)
var
  P: integer;
begin
  Result := PosI(SubStr, S);
  if Result > 0 then
  begin
    P := PosRI(SubStr, copy(S, Result + 1, length(S)));
    Result := Result + P;
  end;
end;

function PosCh(Chars: TSysCharSet; S: string): Integer;
(* ergibt erste Position EINES Zeichens aus Chars in S oder 0 wenn nicht vorhanden *)
var
  I: integer;
begin
  Result := 0;
  for I := 1 to length(S) do
    if CharInSet(S[I], Chars) then  //D2010
    begin
      Result := I;
      break;
    end;
end;

function StrDflt(Src, Dflt: string): string;
// ergibt <Dflt> wenn S='' sonst S
//01.01.12 #0 = ''
begin
  if (Src = '') or (Src = #0) then
    Result := Dflt else
    Result := Src;
end;

function Char1(S: string): char;
(* Liefert 1.Character von S oder #0 wenn leer *)
begin
  if length(S) >= 1 then
    Result := S[1] else
    Result := #0;          //do not edit
end;

function Char1(S: AnsiString): AnsiChar;
(* Liefert 1.Character von S oder #0 wenn leer *)
begin
  if length(S) >= 1 then
    Result := S[1] else
    Result := #0;          //do not edit
end;

function CharI(S: string; I: integer): char;
(* Liefert i.Character von S oder #0 wenn leer *)
begin
  if (1 <= I) and (I <= length(S)) then
    Result := S[I] else
    Result := #0;
  {Result := Char1(copy(S, I, 1));}
end;

function CharN(S: string): char;
(* Liefert letzen Character von S oder #0 wenn leer *)
begin
  if length(S) >= 1 then
    Result := S[length(S)] else
    Result := #0;
end;

function BeginsWith(S, Tok: string; IgnoreCase: boolean = false): boolean;
(* ergibt true wenn S mit Tok beginnt *)
var
  S1: string;
begin
  {Result := (length(S) >= length(Tok)) and
            (copy(S, 1, length(Tok)) = Tok);}
  Result := (length(S) >= length(Tok));
  S1 := copy(S, 1, length(Tok));
  if not IgnoreCase then
    Result := Result and (S1 = Tok) else
    Result := Result and (AnsiCompareText(S1, Tok) = 0);
end;

function EndsWith(S, Tok: string; IgnoreCase: boolean = false): boolean;
(* ergibt true wenn S mit Tok endet *)
var
  S1: string;
begin
  {Result := (length(S) >= length(Tok)) and
            (copy(S, length(S) - length(Tok) + 1, length(Tok)) = Tok);}
  Result := length(S) >= length(Tok);
  if Result then
  begin
    S1 := copy(S, length(S) - length(Tok) + 1, length(Tok));
    if not IgnoreCase then
      Result := S1 = Tok else
      Result := CompareText(S1, Tok) = 0;
  end;
end;

function BoolToStr(B: boolean): string;
(* Liefert 'true' bzw. 'false' *)
begin
  if B then
    Result := 'true' else
    Result := 'false';
end;

function StrToFloatTol(const S: string): Extended;
(* führende/folgende Alpha/Leerzeichen ignorieren. 0 wenn Exception
   '-  1,23'  und '+  4,56' erlauben - 04.10.07
*)
var
  P1, P2 : integer;
  S1, S2, Vorz: string;
  L: integer;
const
  OldS: string = '';
begin
  if (Trim(S) = '') or (TrimCh(S, #0) = '') then
    Result := 0 else
  try
    L := length(S);
    P1 := 1;
    Vorz := '';
    while (P1 <= L) and (IsAlpha(S[P1]) or (S[P1] = ' ')) do
      Inc(P1);
    if (P1 <= L) and CharInSet(S[P1], ['+', '-']) then
    begin
      Vorz := S[P1];
      Inc(P1);
      while (P1 <= L) and (S[P1] = ' ') do
        Inc(P1);
    end;
    P2 := P1;
    while (P2 <= L) and (IsNum(S[P2]) or CharInSet(S[P2], ['+','-','.',',','E','e'])) do
      Inc(P2);
    S1 := Vorz + copy(S, P1, P2 - P1);
    if FormatSettings.ThousandSeparator <> FormatSettings.DecimalSeparator then
      S2 := StrCgeChar(S1, FormatSettings.ThousandSeparator, #0) else      {TauTrenner weg}
      S2 := S1;
    if S2 = '' then
    begin
      Result := 0;
      if OldS <> S then
        Prot0('StrToFloatTol(%s):nicht gültig', [S]);
      OldS := S;
    end else
      Result := StrToFloat(S2);
  except
    on E:Exception do
    begin
      if OldS <> S then
        Prot0('StrToFloatTol(%s):%s', [S, E.Message]);
      OldS := S;
      Result := 0;
    end;
  end;
end;

function StrToFloatDef(const S: string; Default: Extended): Extended;
{wie StrToFloat aber bei Fehler wird Default zurückgegeben}
begin
  try
    if S = '' then
      Result := Default else
      Result := StrToFloat(S);
  except
    Result := Default;
  end;
end;

function StrToFloatTolSep(const S: string): Extended;
(* wie StrToFloatTol, berücksichtigt anderen DecimalSeparator *)
var OldDecimalSeparator, OldThousandSeparator : char;
begin
  OldDecimalSeparator := FormatSettings.DecimalSeparator;
  OldThousandSeparator := FormatSettings.ThousandSeparator;
  try
    if (Pos('.', S) < Pos(',', S)) then       // Wert = Deutsch
    begin
      if FormatSettings.DecimalSeparator = '.' then
      begin
        FormatSettings.DecimalSeparator := ',';
        FormatSettings.ThousandSeparator := '.';
      end;
    end
    else begin                                // Wert = English
      if FormatSettings.DecimalSeparator = ',' then
      begin
        FormatSettings.DecimalSeparator := '.';
        FormatSettings.ThousandSeparator := ',';
      end;
    end;
    Result := StrToFloatTol(s);
  finally
    FormatSettings.DecimalSeparator := OldDecimalSeparator;
    FormatSettings.ThousandSeparator := OldThousandSeparator;
  end;
end;

function StrToIntTol(const S: AnsiString): longint;
//Ansi Version
begin
  Result := StrToIntTol(String(S));
end;

function StrToIntTol(const S: string): longint;
{ führende/folgende Alpha/Leerzeichen ignorieren. 0 wenn Exception
   28.11.97 mit Hex (beginnt mit $) }
var
  P1, P2 : integer;
  HasDollar: boolean;
  S1: string;
begin
  Result := 0;
  HasDollar := false;
  S1 := Trim(StrCgeChar(S, FormatSettings.ThousandSeparator, #0)); {TauTrenner weg}
  if S1 <> '' then
  try
    P1 := 1;
    //gehe bis zum Anfang einer Nummer +/-/$/1..9  (qsbt.shsimx.mirefresh - 29.09.04)
    while (length(S1) >= P1) and
          {(IsAlpha(S1[P1]) or (S1[P1] = ' ') or (S1[P1] = '0')) do}
          not CharInSet(S1[P1], ['-', '+', '$', '1'..'9']) do
    begin
      Inc(P1);
    end;
    P2 := P1;
    if P1 <= length(S1) then
    begin
      if S1[P1] = '$' then
      begin
        HasDollar := true;
        Inc(P2);
      end else
      if CharInSet(S1[P1], ['-', '+']) then
      begin
        Inc(P2);
      end;
    end;
    // ab jetzt nur noch Ziffern oder Hexzeichen
    while (P2 <= length(S1)) and
          ((HasDollar and IsHexDec(S1[P2]) or IsNum(S1[P2]))) do
    begin
      Inc(P2);
    end;
    if P2 = P1 then              {Leerstr}
      Result := 0 else
    if (P2 = P1 + 1) and not IsNum(S1[P1]) then  //nur '$', '-' oder '+'
      Result := 0 else
      Result := StrToInt(StrCgeChar(copy(S1, P1, P2 - P1),
                         FormatSettings.ThousandSeparator, #0)); {TauTrenner weg}
      //Result := StrToInt(copy(S1, P1, P2 - P1));
  except on E:Exception do
    if Sysparam.ProtBeforeOpen then
      Prot0('StrToIntTol(%s):%s', [S1, E.Message]);
  end;
end;

function StrToInt64Tol(const S: AnsiString): int64;
//Ansi Version. 64bit.
begin
  Result := StrToIntTol(String(S));
end;

function StrToInt64Tol(const S: string): int64;
// führende/folgende Alpha/Leerzeichen ignorieren. 0 wenn Exception
// mit Hex (beginnt mit $)
// 64bit
var
  P1, P2 : integer;
  HasDollar: boolean;
  S1: string;
begin
  Result := 0;
  HasDollar := false;
  S1 := Trim(StrCgeChar(S, FormatSettings.ThousandSeparator, #0)); {TauTrenner weg}
  if S1 <> '' then
  try
    P1 := 1;
    //gehe bis zum Anfang einer Nummer +/-/$/1..9  (qsbt.shsimx.mirefresh - 29.09.04)
    while (length(S1) >= P1) and
          {(IsAlpha(S1[P1]) or (S1[P1] = ' ') or (S1[P1] = '0')) do}
          not CharInSet(S1[P1], ['-', '+', '$', '1'..'9']) do
    begin
      Inc(P1);
    end;
    P2 := P1;
    if P1 <= length(S1) then
    begin
      if S1[P1] = '$' then
      begin
        HasDollar := true;
        Inc(P2);
      end else
      if CharInSet(S1[P1], ['-', '+']) then
      begin
        Inc(P2);
      end;
    end;
    // ab jetzt nur noch Ziffern oder Hexzeichen
    while (P2 <= length(S1)) and
          ((HasDollar and IsHexDec(S1[P2]) or IsNum(S1[P2]))) do
    begin
      Inc(P2);
    end;
    if P2 = P1 then              {Leerstr}
      Result := 0 else
    if (P2 = P1 + 1) and not IsNum(S1[P1]) then  //nur '$', '-' oder '+'
      Result := 0 else
      Result := StrToInt64(StrCgeChar(copy(S1, P1, P2 - P1),
                         FormatSettings.ThousandSeparator, #0)); {TauTrenner weg}
      //Result := StrToInt64(copy(S1, P1, P2 - P1));
  except on E:Exception do
    if Sysparam.ProtBeforeOpen then
      Prot0('StrToIntTol(%s):%s', [S1, E.Message]);
  end;
end;

function StrToMSecs(const S: string; const dflt: string = '0'): longint;
{ 'String to Milliseconds' - wandelt Zahl mit Einheit nach Millisekunden um
  S='1'->1; '1s'->1000; '1m'->60000; '1h'->3600000; '1ms'->1
  dflt:Vorgabewert, Format wie S }
var
  Einheit: string;
  S1: string;
begin
  if S <> '' then
  try
    Einheit := '';
    S1 := S;
    while (S1 <> '') and not IsHexDec(CharN(S1)) do
    begin
      Einheit := UpCase(CharN(S1)) + Einheit;
      System.Delete(S1, length(S1), 1);
    end;
    Result := StrToInt(S1);
    if Einheit = 'S' then Result := Result * 1000 else
    if Einheit = 'M' then Result := Result * 60000 else
    if Einheit = 'H' then Result := Result * 3600000 else
    if Einheit <> 'MS' then Result := StrToInt(S); //Exception bei falscher Einheit
    Exit;
  except on E:Exception do
    EProt(nil, E, 'StrToMSecs(%.20s,%.20s)', [S, dflt]);
  end;
  if dflt <> '' then
  begin
    Result := StrToMSecs(dflt, '0');
  end else
    Result := 0;
end;

function StrToFloatIntl(const S: string; tolerant: boolean = true;
  Default: Extended = 0): Extended;
{ String wird in verschiedenen internationalen Formaten korrekt interpretiert
  12,3  12.3  1.234,56  1,234.56  1,234.56  .5  ,5  (F, USA, GB, ES, CH, EU, ...)
  tolerant: die Umwandlung erfolgt ohne Exception via StrToFloatTol
  Hex-Zahlen werden nicht unterstützt (nichtdefiniertes Ergebnis)
  BG200104: um E erweitert}
var
  MyDecimalSeparator, MyThousandSeparator: char;
  I: integer;
  S1: string;
begin
  MyDecimalSeparator := #0;
  MyThousandSeparator := #0;
  for I := 1 to length(S) - 1 do
  begin
    if not IsNum(S[I]) and IsNum(S[I + 1]) and (S[I] <> 'E') then
    begin
      if (MyThousandSeparator <> S[I]) and
         (MyDecimalSeparator = #0) then
      begin
        MyDecimalSeparator := S[I];
      end else
      if (MyDecimalSeparator = S[I]) then
      begin   //Separator kommt mehrmals vor -> Thousands
        MyThousandSeparator := MyDecimalSeparator;
        MyDecimalSeparator := #0;
      end else
      if (MyThousandSeparator <> S[I]) and
         (MyDecimalSeparator <> S[I]) then
      begin
        if MyThousandSeparator <> #0 then
          break;      //wir haben schon einen
        MyThousandSeparator := MyDecimalSeparator;
        MyDecimalSeparator := S[I];
      end;
    end;
  end; { for }
  S1 := S;
  if CharInSet(MyDecimalSeparator, ['.', ',', #0]) and
     CharInSet(MyThousandSeparator, ['.', ',', '''', ' ', #0]) then
  begin  //Dezimaltrenner gemäß lokale; Tausendertrenner entfernen
    if MyDecimalSeparator <> #0 then
      S1 := StrCgeChar(S1, MyDecimalSeparator, #255);
    if MyThousandSeparator <> #0 then
      S1 := StrCgeChar(S1, MyThousandSeparator, #0);
    if MyDecimalSeparator <> #0 then
      S1 := StrCgeChar(S1, #255, FormatSettings.DecimalSeparator);
  end;
  if tolerant then
    Result := StrToFloatTol(S1) else
  if Default <> 0 then
    Result := StrToFloatDef(S1, Default) else
    Result := StrToFloat(S1);
end;

function FloatToStrIntl(Value: Extended): string;
(* DezPkt = '.'  ohne TauPkt
   * Für SQL *)
var
  OldDecimalSeparator: char;
begin
  OldDecimalSeparator := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';
  try
    Result := FormatFloat('0.##########', Value);
  finally
    FormatSettings.DecimalSeparator := OldDecimalSeparator;
  end;
end;

function FormatFloatIntl(const Format: string; Value: Extended): string;
{Erzeugt String im internationales Format (Dezimalpunkt)}
begin
  Result := StrCgeChar(FormatFloat(Format, Value), ',', '.');
end;

function FormatTol(const AFormat: string; const AArgs: array of const): string;
// StringFormat das Parameterfehler verzeiht. - BG151003
begin
  try
    Result := Format(AFormat, AArgs);
  except
    //Result := '???';
    Result := StringReplace(AFormat, '%', '?', [rfReplaceAll]);
    Prot0('FormatTol: %s', [Result]);
  end;
end;

function IPower(X, Y: longint): longint;
(* Ergibt X hoch Y mit Integers *)
begin
  if Y = 0 then
    Result := 1 else
  if Y > 0 then
    Result := X * IPower(X, Y - 1) else
  {if Y < 0 then}
    Result := 0;
end;

procedure ClearPendingExceptions;
// FCLEX clears any floating-point exceptions which may be pending.
// FNCLEX does the same thing but doesn't wait for previous floating-point
// operations (including the handling of pending exceptions) to finish first.
// http://www.delphifaq.com/faq/delphi_windows_API/f572.shtml
asm
  FNCLEX
end;

function RTrunc(X: Extended): Int64;
// Workaround für fehlerhalte Trunc Implementierung
begin
  ClearPendingExceptions;
  Result := Trunc(X);
end;

function RCeil(X: Extended): Int64;
// Workaround für fehlerhalte Ceil Implementierung
begin
  ClearPendingExceptions;
  Result := Ceil(X);
end;

function RFloor(X: Extended): Int64;
// Workaround für fehlerhalte Ceil Implementierung
//Floor(-2.8) = -3; Floor(2.8) = 2; Floor(-1.0) = -1
begin
  ClearPendingExceptions;
  Result := Floor(X);
end;

function RInt(X: Extended): Extended;
// Workaround für fehlerhalte Int Implementierung
begin
  ClearPendingExceptions;
  Result := Int(X);
end;

function RFrac(X: Extended): Extended;
// Workaround für fehlerhalte Frac Implementierung
begin
  ClearPendingExceptions;
  Result := Frac(X);
end;

function RPower(Base, Exponent: Extended): Extended;
// Workaround für fehlerhalte Power Implementierung
begin
  ClearPendingExceptions;
  Result := Power(Base, Exponent);
end;

function FracToInt(X: Extended; MaxNk: integer = 9): Integer;
(* schiebt alle Nachkommastellen vor das Komma. Vorkommastellen werden ignoriert *)
var
  S: string;
  P: integer;
begin
  // 3,141000000 -> 3,141;   3,00000 -> 3,
  S := RTrimCh(StrCgeChar(Format('%.*f', [MaxNk, X]), FormatSettings.ThousandSeparator, #0), '0');
  P := Pos(FormatSettings.DecimalSeparator, S);
  if (P = 0) or (P = length(S)) then
    Result := 0 else
  begin
    System.Delete(S, 1, P);
    Result := StrToInt(S);
  end;
end;

function FloatToIntTol(X: Extended; MinNk: integer): Integer;
(* Entfernt Komma aus X; wenn Frac(X) = 0, dann werden MinNk angeängt; => 0 wenn Exception *)
var
  S: string;
begin
  S := StrCgeChar(Format('%.*f', [MinNk, X]), FormatSettings.ThousandSeparator, #0);
  // S := StrCgeChar(FloatToStr(X), ThousandSeparator, #0);
  S := StrCgeChar(S, FormatSettings.DecimalSeparator, #0);
  try
    Result := StrToInt(S);
  except on E:Exception do
    begin
      // 'FloatToInt: %s ist kein gültiger Integer-Wert %s%s'
      Prot0(SProts_042, [S, CRLF, E.Message]);
      Result := 0;
    end;
  end;
end;

function FloatToIntTolNk(X: Extended; MinNk, MaxNk: Integer): Integer;
(* X wird auf MaxNK gerundet, dann Komma entfernt *)
begin
  Result := FloatToIntTol(RoundDec(X, MaxNk), MinNk);
end;

function HiDiv(Z, N: longint): longint;
(* ergibt Divisionsergebnis E, wobei E * N >= Z, d.h. HiDiv(5,3)=2 *)
begin
  Result := (Z + N - 1) div N;
end;

function RoundDec(X: Extended; NK: integer): Extended;
{Rundet eine Gleitkommazahl auf NK Nachkommastellen}
var
  Rounded, Faktor: extended;
begin
  Faktor := Power(10, NK);
  //Rounded := Round(Frac(X) * Faktor);           {0.5 -> 0; 0.51 -> 1; 1.5 -> 2}
  //Result := Int(X) + Rounded / Faktor;
  Rounded := Round(X * Faktor);                 {Test? 28.06.06}
  Result := Rounded / Faktor;
end;

function RoundCeil(X: Extended; NK: integer): Extended;
{Rundet eine Gleitkommazahl auf NK Nachkommastellen nach oben}
var
  Rounded, Faktor: extended;
begin
  Faktor := Power(10, NK);
  Rounded := Ceil(X * Faktor);   {NK=2: 1,234->1,24; 1,2301->1,24; 2->2}
  Result := Rounded / Faktor;
end;

function RoundFloor(X: Extended; NK: integer): Extended;
{Rundet eine Gleitkommazahl auf NK Nachkommastellen nach unten}
var
  Rounded, Faktor: extended;
begin
  Faktor := Power(10, NK);
  Rounded := Floor(X * Faktor);   {NK=2: 1,234->1,23; 1,2301->1,23; 2->2}
  Result := Rounded / Faktor;
end;

function RoundCur(X: Extended; NK: integer): Extended;
{Rundet kaufmännisch auf. (NK=2: 1,2350 -> 1,24). Berücksichtigt Float-Fehler}
var
  Rounded, Faktor: extended;
  S: string;
  P: integer;
begin
  S := FloatToStrF(X, ffFixed, 18, NK*2);  //Produkt aus 2 .NK Zahlen
  P := Pos(FormatSettings.DecimalSeparator, S);
  if P > 0 then
  begin  //Fehler vermeiden bei 1.2349999999999 -> 1.2350 -> 1.24
    Faktor := Power(10, NK);
    Rounded := RTrunc(StrToFloat(S) * Faktor + 0.5);   {NK=2: 1,234->1,23; 1,2301->1,23; 2->2}
    Result := Rounded / Faktor;
  end else
    Result := X;
  {Alte Version bis 29.01.05. Schneidet nur ab,
  S := FloatToStrF(X, ffFixed, 18, NK*2);  //Produkt aus 2 .NK Zahlen
  P := Pos(DecimalSeparator, S);
  if P > 0 then
    Result := StrToFloat(copy(S, 1, P + NK)) else
    Result := X;}
end;

function RoundEUR(X: Extended): Extended;
{Rundet kaufmännisch auf 2 NK }
begin
  Result := RoundCur(X, 2);
end;

function IsNum(Ch: Char): boolean;
begin
  Result := CharInSet(Ch, ['0'..'9']);
end;

function IsNum(Ch: AnsiChar): boolean;
begin
  Result := Ch in ['0'..'9'];
end;

function IsAlpha(Ch: Char): boolean;
begin
  Result := CharInSet(Ch, ['A'..'Z']) or CharInSet(Ch, ['a'..'z']);
end;

function IsAlpha(Ch: AnsiChar): boolean;
begin
  Result := (Ch in ['A'..'Z']) or (Ch in ['a'..'z']);
end;

function IsAlphaUml(Ch:char): boolean;
begin              {Buchstabe incl. dt. Umlauten und ß}
  Result := IsAlpha(Ch) or CharInSet(Ch, ['Ä','Ö','Ü']) or CharInSet(Ch, ['ä','ö','ü','ß']);
end;

function IsAlphaNum(Ch: Char): boolean;
begin
  Result := IsAlpha(Ch) or IsNum(Ch);
end;

function IsAlphaNum(Ch: AnsiChar): boolean;
begin
  Result := IsAlpha(Ch) or IsNum(Ch);
end;

function IsAlphaNumUml(Ch:char): boolean;
begin              {Ziffer oder Buchstabe incl. dt. Umlauten und ß}
  Result := IsNum(Ch) or IsAlphaUml(Ch);
end;

function IsHexDec(Ch: Char): boolean;
begin
  Result := IsNum(Ch) or CharInSet(UpCase(Ch), ['A'..'F']);
end;

function IsHexDec(Ch: AnsiChar): boolean;
begin  //Ansi
  Result := CharInSet(UpCase(Ch), ['0'..'9','A'..'F']);
end;

function IsIdentChar(Ch: Char): boolean;
begin
  Result := IsAlphaNum(Ch) or (Ch = '_');
end;

function IsIdentChar(Ch: AnsiChar): boolean;
begin
  Result := IsAlphaNum(Ch) or (Ch = '_');
end;

function StripAlphaNumUml(S: string): string;
//entfernt alle nicht AlphaNumUml
var
  I: integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    if IsAlphaNumUml(S[I]) then
      Result := Result + S[I];
end;

function IsNumeric(S: string): boolean;
//ergibt true wenn S nur aus Ziffern besteht
var
  I: integer;
begin
  Result := S <> '';  //leerer String ist kein Float Wert
  if Result then
  begin
    for I := 1 to length(S) do
      if not IsNum(S[I]) then
      begin
        Result := false;
        break;
      end;
  end;
end;

function IsFloatStr(S: string): boolean;
// ergibt true wenn S einen numerischen Floatwert darstellt  (QUPE.MatrProbFrm 13.10.04)
// 27.04.09 Blanks werden nicht mehr toleriert (webab eval ttnumeric)
// 18.06.13 Vorzeichen +/- (nur) an erster Stelle erlaubt
// 08.04.14 mindestens eine Ziffer. Mindestens eine Ziffer hinter Dezimalzeichen. (kein '2,')
var
  I: integer;
  SepFlag, VZFlag, NumFlag: boolean;
begin
  Result := S <> '';  //leerer String ist kein Float Wert
  if Result then
  begin
    SepFlag := false;
    VZFlag := false;
    NumFlag := false;
    for I := 1 to length(S) do
    begin
      if IsNum(S[I]) then
        NumFlag := true;
      if S[I] = FormatSettings.DecimalSeparator then
        NumFlag := false;
      if not IsNum(S[I]) and //weg 27.04.09 (S[I] <> ' ') and
         ((S[I] <> FormatSettings.DecimalSeparator) or SepFlag) and
         (((S[I] <> '-') and (S[I] <> '+')) or VZFlag) then
      begin
        Result := false;
        break;
      end;
      if S[I] = FormatSettings.DecimalSeparator then
        SepFlag := true;   //',' nur einmal erlaubt - 18.11.08
      VZFlag := true;  // +/- nur an erster Stelle erlaubt - 18.06.13
    end;
    Result := Result and NumFlag;
  end;
end;

function IsDateStr(S: string): boolean;
// ergibt true wenn S ein Datum darstellt  (ExcelPrnKmp 07.12.09)
// Regel: Zahl<Trenner>Zahl<Trenner>Zahl
var
  I, Step: integer;
begin
  Result := S <> '';  //leerer String ist kein DateTime Wert
  if Result then
  begin
    Step := 0;
    for I := 1 to length(S) do
    begin
      case Step of
      0: if not IsNum(S[I]) then
           Result := false else
         if S[I] = FormatSettings.DateSeparator then
           Step := 1;
      1: if not IsNum(S[I]) then
           Result := false else
         if S[I] = FormatSettings.DateSeparator then
           Step := 2;
      2: if not IsNum(S[I]) then
           Result := false;
      end;  //case
    end;
    if Step <> 2 then
      Result := false;
  end;
end;

function FirstUpper(S: string): string;
//Erster Buchstabe groß; Rest klein.
begin
  Result := ToUpper(Copy(S, 1, 1)) + ToLower(Copy(S, 2, Maxint));
end;

procedure SetEdText(AEdit: TCustomEdit; AText: string);
//Setzt Text und löst OnChange IMMER aus.
//AUch für TSpinEdit
begin
  if AEdit.Text <> AText then
    AEdit.Text := AText  //löst OnChange aus
  else
    AEdit.Perform(CM_TEXTCHANGED, 0, 0);  //OnChange auslösen.
end;

procedure SetEdNum(AEdit: TEdit; AText: string);
// Edit.Text rechtsbündig zweisen
// 27.11.13 md  mittlerweile gibt es Alignment
//var
//  N: integer;
//  ACanvas: TCanvas;
//  OldFont: TFont;
//  S: string;
//const
//  Indent: integer = 8;  {rechter Rand}
begin
  if AEdit <> nil then
  begin
    AEdit.Alignment := taRightJustify;
    AEdit.Text := Trim(AText);
  end;
//  S := Trim(AText);
//  if S <> '' then
//  try
//    ACanvas := nil;  //wg Compilerwarnung
//    try
//      if AEdit.Owner is TCustomForm then
//        ACanvas := (AEdit.Owner as TCustomForm).Canvas else
//      if AEdit.Owner.Owner is TCustomForm then
//        ACanvas := (AEdit.Owner.Owner as TCustomForm).Canvas;
//    except
//      ACanvas := (AEdit.Owner.Owner as TCustomForm).Canvas;
//    end;
//    OldFont := ACanvas.Font;
//    try
//      ACanvas.Font := AEdit.Font;
//      N := (AEdit.Width - Indent - ACanvas.TextWidth(S))
//           div ACanvas.TextWidth(' ');
//      if N < 1 then
//        AEdit.Text := S else
//        AEdit.Text := Format('%*s%s', [N, ' ', S]);
//    finally
//      ACanvas.Font := OldFont;
//    end;
//  except on E:Exception do
//    EProt(AEdit, E, 'Class(%s)', [AEdit.Owner.ClassName]);
//  end else
//    AEdit.Text := '';
end;

//procedure SetEdNum(AEdit: TCustomEdit; AText: string; Abstand: integer = 8);
//// Edit.Text rechtsbündig zweisen
//// 26.11.13 DeviceContext
//// Empfehlung: TMaskEdit mit Alignment=taRightJustify verwenden
//var
//  S, S1: string;
//  C: TCanvas;
//  h: HWnd;
//  x: integer;
//const
//  Indent: integer = 8;  {rechter Rand}
//begin
//  S := Trim(AText);
//  if S <> '' then
//  try
//    c := TCanvas.Create;
//    try
//      h := AEdit.Handle;
//      c.Handle := TDummyCustomEdit(AEdit).GetDeviceContext(h);
//      S1 := ' ' + S;
//      x := c.TextWidth(S1);
//      while x < AEdit.Width - Abstand do
//      begin
//        S := S1;
//        S1 := ' ' + S;
//        x := c.TextWidth(S1);
//      end;
//    finally
//      c.Free;
//    end;
//  except on E:Exception do
//    EProt(AEdit, E, 'Class(%s)', [AEdit.Owner.ClassName]);
//  end;
//  AEdit.Text := S;
//end;

procedure SetEdCenter(AEdit: TEdit; AText: string);
(* Edit.Text zentriert zweisen *)
var
  N: integer;
  ACanvas: TCanvas;
  S: string;
const
  Indent: integer = 8;
begin
  S := Trim(AText);
  if S <> '' then
  begin
    ACanvas := (AEdit.Owner as TForm).Canvas;
    N := (AEdit.Width - Indent - ACanvas.TextWidth(S))
         div ACanvas.TextWidth(' ');
    if N < 2 then
      AEdit.Text := S else
      AEdit.Text := Format('%*s%s', [N div 2, ' ', S]);
  end else
    AEdit.Text := '';
end;

procedure EdSelAll(AEdit: TCustomEdit);
(* alles markieren als Postmessage *)
begin
  if AEdit.Text <> '' then
    PostMessage(AEdit.Handle, EM_SETSEL, 0, -1);
end;

function ListCount(AList: TList): integer;
(* Anzahl belegter Elemente einer TList. Ohne nil-Elemente *)
var
  I: integer;
  AObject: TObject;
begin
  Result := 0;
  for I:= 0 to AList.Count-1 do
  begin
    AObject := TObject(AList.Items[I]);
    if AObject <> nil then
      inc(Result);
  end;
end;

(*** Bitoperationen *****************************************************)

function BITIS(I, Msk: integer): boolean;
begin                                              {Binäres und von zwei Zahlen}
  Result := (I and Msk) <> 0;
end;

function ISBITSET(I, BitNr: integer): boolean;
begin                             {Testet ob Bit[BitNr] gesetzt. BitNr in 0..31}
  Result := BITIS(I, 1 shl BitNr);
end;

procedure BITSET(var I: integer; BitNr: integer);
begin                                    {Setzt Bit[BitNr] in I. BitNr in 0..31}
  I := I or (1 shl BitNr);
end;

procedure BITSET(var I: Word; BitNr: integer);
begin                                    {Setzt Bit[BitNr] in I. BitNr in 0..15}
  I := I or (1 shl BitNr);
end;

procedure BITCLEAR(var I: integer; BitNr: integer);
begin                                   {Löscht Bit[BitNr] in I. BitNr in 0..31}
  I := I and not (1 shl BitNr);
end;

(*** Koordinaten ********************************************************)

function RectEqual(const R1, R2: TRect): boolean;
// ergibt true wenn beide TRect gleich sind
begin
  Result := (R1.Left = R2.Left) and (R1.Top = R2.Top) and
            (R1.Right = R2.Right) and (R1.Bottom = R2.Bottom);
end;

function RectWidth(const R: TRect): integer;
begin
  Result := R.Right - R.Left;
end;

function RectHeight(const R: TRect): integer;
begin
  Result := R.Bottom - R.Top;
end;

function NextTab(I, Tab: integer): integer;
begin         {ergibt nächsten Tabulator ab I (Tabulator ist Vielfaches von Tab}
  if Tab > 0 then                             {Tab5: 4->5 5->5 6->10}
    Result := I + Tab - (I mod Tab) else
  if Tab < 0 then                             {Tab-5: 4->}
  begin
    if I mod Tab = 0 then
      Result := I + Tab else
      Result := I - (I mod Tab);        {erstmal auf nächsten Tab runter}
  end else
    Result := I;
end;

function Sgn(I: extended): TSGN;
begin
  if abs(I) < 0.00001 then  //12.10.08 feiner um Sekunden zu unterscheiden
    I := 0;
  if I < 0 then
    Result := -1 else
  if I > 0 then
    Result := 1 else
    Result := 0;
end;

(*** TFields dynamisch anlegen ******************************************)

procedure OpenDS(aDataSet: TDataSet);
{Öffnet ein Detail Dataset. Füllt Parameter. DS Kann Disabled sein}
var
  I: integer;
  aQuery: TuQuery;
  aField: TField;
begin
  if aDataSet = nil then
    Exit;
  if (aDataSet is TuQuery) then // beware: aDataSet.ControlsDisabled da nur Master disabled
  begin
    aQuery := TuQuery(aDataSet);
    aQuery.Close;
    for I := 0 to aQuery.Params.Count - 1 do
    begin
      aField := aQuery.DataSource.DataSet.FindField(
                  aQuery.Params[I].Name);
      if aField <> nil then
      begin
        aQuery.Params[I].AssignField(aField);
        aQuery.Params[I].Bound := false;
      end;
    end;
  end;
  aDataSet.Open;
end;

function CreateDataField(Dataset: TDataset; FieldName: string;
 Display: string): TField;
 {dynamisch erzeugen von einem TField bewandt mit DataField}
(* Displaylänge: nach Doppelpunkt in Display (Name:20), (Unsichtbar:0) *)
var
  ADisplayWidth, P: integer;
begin
  with Dataset do
  begin
    Result := FindField(FieldName ); { First, see if it exists }
    if Result = nil then
    begin { If so, no need to create it. }
       { Have the FieldDef object create its own Field Object }
      Result := FieldDefs.Find(FieldName).CreateField(Dataset);
      Result.Name := Name + FieldName;
      (*
      Result.FieldName := FieldName;            {nein}
      Result.Index := DataSet.FieldCount;       {n ja}
      Result.DataSet := DataSet;                {nein}
      DataSet.FieldDefs.UpDate;                 {nein}
      *)

      Result.Visible := true;
      P := Pos(':',Display);             {Name:20}
      if P > 0 then
      begin
        Result.DisplayLabel := copy(Display, 1, P - 1);
        try
          ADisplayWidth := StrToInt(copy(Display, P+1, Length(Display) - P));
          if ADisplayWidth = 0 then Result.Visible := false;
          Result.DisplayWidth := ADisplayWidth;
        except
	  // 'CreateField:Fehler bei Format (%s)'
          ErrWarn(SProts_006,[Display]);
        end;
      end else
        Result.DisplayLabel := Display;
    end;
  end;
end;

function CreateCalcField(Dataset: TDataset; FieldName : string;
  Display: string; FieldType: TFieldType; Size : Word ) : TField;
(* Displaylänge: nach Doppelpunkt in Display (Name:20) (Unsichtbar:0) *)
{dynamisch anlegen von Calc-Fields}
var
  FieldClass: TFieldClass;
  P: integer;
begin
  Result := Dataset.FindField(FieldName );
  if Result = nil then
  begin
    case FieldType of
      ftstring: FieldClass := TStringField;
      ftWideString: FieldClass := TWideStringField;
      ftInteger, ftAutoInc: FieldClass := TIntegerField;
      ftSmallInt: FieldClass := TIntegerField;
      ftLargeInt: FieldClass := TLargeintField;
      ftFloat: FieldClass := TFloatField;
      ftBCD: FieldClass := TBCDField;
      ftCurrency: FieldClass := TCurrencyField;
      ftDate: FieldClass := TDateField;
      ftTime: FieldClass := TTimeField;
      ftDateTime: FieldClass := TDateTimeField;
      ftMemo: FieldClass := TMemoField;
      else FieldClass := nil;
    end;
    if FieldClass = nil then
      // 'Unbekannter Feldtyp %d (%s)'
      EError(SProts_007,[ord(FieldType),FieldName]);
    Result := FieldClass.Create(DataSet);
    try
      Result.FieldName := FieldName;
      if (FieldClass = TStringField) or (FieldClass = TWideStringField) or
         (FieldClass = TMemoField) then
        Result.Size := Size;
      Result.Calculated := True;
      Result.Dataset := Dataset;
      Result.Name := Dataset.Name + FieldName;
      {Result.FieldNo := -1}
      (* erzeugt Error 'bereits vorhanden'
      Result.FieldName := FieldName;            {n}
      Result.Index := DataSet.FieldCount;       {n}
      Result.DataSet := DataSet;                {n}
      DataSet.FieldDefs.UpDate;                 {n}
      *)
      P := Pos(':',Display);             {Name:20}
      if P > 0 then
      begin
        Result.DisplayLabel := copy(Display, 1, P - 1);
        try
          Result.DisplayWidth := StrToInt(copy(Display, P+1, Length(Display) - P));
        except
          ErrWarn(SProts_008,[Display]);	// 'CreateField:Fehler bei Format (%s)'
        end;
      end else
      begin
        Result.DisplayLabel := Display;
        if Size > 0 then
          Result.DisplayWidth := Size;
      end;
      Result.Visible := Result.DisplayWidth > 0;        {true;}
      Result.ReadOnly := false;         {sonst geht calc nicht}
    except
      Result.Free;
      raise;
    end;
  end;
 end;

function GetFieldType(TypeStr: string): TFieldType;
{Umwandlung von Bezeichnung in FieldTyp (für CreateCalcFields}
begin
  Result := ftstring;  //wg Compilerwarnung
  if IsNum(Char1(TypeStr)) then Result := TFieldType(StrToInt(TypeStr)) {für Lookup}
  else if CompareText(TypeStr, 'STRING')   = 0 then Result := ftString
  else if CompareText(TypeStr, 'WIDESTRING') = 0 then Result := ftWideString
  else if CompareText(TypeStr, 'INTEGER')  = 0 then Result := ftInteger
  else if CompareText(TypeStr, 'AUTOINC')  = 0 then Result := ftInteger
  else if CompareText(TypeStr, 'SMALLINT') = 0 then Result := ftInteger
  else if CompareText(TypeStr, 'FLOAT')    = 0 then Result := ftFloat
  else if CompareText(TypeStr, 'CURRENCY') = 0 then Result := ftCurrency
  else if CompareText(TypeStr, 'DATE')     = 0 then Result := ftDate
  else if CompareText(TypeStr, 'TIME')     = 0 then Result := ftTime
  else if CompareText(TypeStr, 'DATETIME') = 0 then Result := ftDateTime
  else if CompareText(TypeStr, 'MEMO')     = 0 then Result := ftMemo
  else EError(SProts_009, [TypeStr]);		// 'FieldTypeStr:(%s)falsch'
end;

function GetUniqueValues(AQuery: TuQuery): string;
//ergibt Feldname=Wert für alle Felder die Teil eines Unique Keys sind (für ImportXML)
//10.05.12 Bug wenn normale Indexe existieren.
var
  IL, OL, L: TStringList;
  I: integer;
  S1, S2, NextS: string;
  ATblName: string;
begin
  ATblName := QueryTableName(AQuery);
  Result := '';
  IL := TStringList.Create;
  OL := TStringList.Create;
  L := TStringList.Create;
  try
    IndexInfo(QueryDatabase(AQuery), ATblName, IL, OL);
    for I := 0 to IL.Count - 1 do
    begin
      S2 := OL.Values[StrParam(IL[I])];
      //beware. OL hat weniger Einträge if Pos('ixUnique', OL[I]) > 0 then
      if PosI('ixUnique', S2) > 0 then
      begin
        S1 := PStrTok(StrValue(IL[I]), ';', NextS);
        while S1 <> '' do
        begin
          L.Add(S1 + '=' + AQuery.FieldByName(S1).AsString);
          S1 := PStrTok('', ';', NextS);
        end;
      end;
    end;
  finally
    Result := L.Text;
    IL.Free;
    OL.Free;
    L.Free;
  end;
end;

//Projekt: DuplDetail. Begin:25.11.13. Nicht beendet (lawa.mest.erfass´)
//procedure DuplDetail(DtlNav: TNavLink; OldMaster, NewMaster: TDatapos);
////Dupliziert die Detail-Records von Old nach New Master
//var
//  S1, S2, RefValue: string;
//  I: integer;
//  DtlTablename: string;
//  DtlTbl: TuQuery;
//  Ps: TStringList;
//begin
//  {* insert into Dtl(Fields) values(select New.Keyfields, Field from Dtl where Old.KeyFields)
//  *}
//  Ps := TstringList.Create;
//  try
//    S1 := Format('insert into %s(', [DtlTablename]);
//    for I := 0 to DtlTbl.FieldCount - 1 do
//      AppendTok(S1, DtlTbl.Fields[I].FieldName, ', ');
//    AppendTok(S1, ') values select', CRLF);
//    for I := 0 to DtlTbl.FieldCount - 1 do
//    begin
//      S2 := DtlTbl.Fields[I].FieldName;
//      RefValue := DtlNav.References.Values[S2];
//      if BeginsWith(RefValue, ':') then
//      begin
//        S2 := ':new_' + S2;
//        Ps.Values['new_' + S2] := OldMaster.Values[...
//      end;
//      AppendTok(S1, S2, ', ');
//    end;
//    AppendTok(S1, 'where ' + DtlTbl.SQLGetWhere(DtlTbl.SQL.Text), CRLF);
//    //Params:
//
//  finally
//    Ps.Free;
//  end;
//end;

function GetKritValue(aTable, aFieldname, KritNames: string;
  KritFields: array of TField; AQue: TuQuery): string;
// ergibt Field.AsString der Spalte mit den Kriterien
// AQue muss gültige Connection haben
var
  S1, NextS: string;
  L: TStringList;
  I: integer;
  aField: TField;
  Schema: string;
begin
  Result := '';
  L := nil;
  S1 := PStrTok(KritNames, ';', NextS);
  I := 0;
  if S1 <> '' then
  try
    L := TStringList.Create;
    L.AddObject(S1, KritFields[I]);
    Inc(I);
    AQue.Close;
    AQue.UnPrepare;
    if not BeginsWith(aTable, 'dbo.', true) then
      Schema := 'dbo.' else
      Schema := '';
    AQue.Sql.Text := Format('select %s from %s%s where %s = :%s ', [
                            aFieldname, Schema, aTable, S1, S1]);
    while true do
    begin
      S1 := PStrTok('', ';', NextS);
      if S1 = '' then
        break;
      L.AddObject(S1, KritFields[I]);
      Inc(I);
      AQue.Sql.Text := AQue.Sql.Text + CRLF + Format('  and %s = :%s', [S1, S1]);
    end;
    for I := 0 to L.Count - 1 do
    begin
      aField := TField(L.Objects[I]);
      if AField.IsNull then
      begin
        AQue.ParamByName(L[I]).Clear;  //28.10.11
        AQue.ParamByName(L[I]).DataType := ftString;  //28.11.11
        AQue.ParamByName(L[I]).Bound := true;  //null Wert zuweisen
      end else if aField is TIntegerField then
        AQue.ParamByName(L[I]).AsInteger := aField.AsInteger
      else if aField is TDateTimeField then
        AQue.ParamByName(L[I]).AsDateTime := aField.AsDateTime
      else if aField is TFloatField then
        AQue.ParamByName(L[I]).AsFloat := aField.AsFloat
      else
        AQue.ParamByName(L[I]).AsString := aField.AsString;
    end;
    AQue.Open;
    Result := AQue.FieldByName(aFieldname).AsString;
    if not AQue.EOF then
    begin
      if Sysparam.ProtBeforeOpen then
      begin
        Prot0('GetKritValue(%s,%s,%s)=%s', [aTable, aFieldname, KritNames, Result]);
        ProtSql(AQue);
      end;
    end else
    begin
      Prot0('WARN EOF bei GetKritValue(%s,%s,%s) %s', [aTable, aFieldname, KritNames,
        QueryText(AQue, [qtoOneLine])]);
    end;
  finally
    L.Free;
    AQue.Close;
  end;
end;

function GetKritValue(aTable, aFieldname, KritNames: string;
  KritValues: string; AQue: TuQuery): string;
// wie oben aber mit String statt TFields - KritValues: Werte mit ';' getrennt.
// AQue muss gültige Connection haben
// SQL Generieren
var
  S1, NextS: string;
  L: TStringList;
  I: integer;
  Schema: string;
  S2, NextS2: string;
begin
  Result := '';
  L := nil;
  S1 := PStrTok(KritNames, ';', NextS);
  S2 := PStrTok(KritValues, ';', NextS2);
  I := 0;
  if S1 <> '' then
  try
    L := TStringList.Create;
      L.Add(S1 + '=' + S2);
    Inc(I);
    AQue.Close;
    AQue.UnPrepare;
    if not BeginsWith(aTable, 'dbo.', true) and SysParam.MSSQL then
      Schema := 'dbo.' else
      Schema := '';
    AQue.Sql.Text := Format('select %s from %s%s where %s = :%s ', [
                            aFieldname, Schema, aTable, S1, S1]);
    while true do
    begin
      S1 := PStrTok('', ';', NextS);
      S2 := PStrTok('', ';', NextS2);
      if S1 = '' then
        break;
      L.Add(S1 + '=' + S2);
      Inc(I);
      AQue.Sql.Text := AQue.Sql.Text + CRLF + Format('  and %s = :%s', [S1, S1]);
    end;
    Debug('%d', [I]);
    for I := 0 to L.Count - 1 do
    begin
      S1 := StrParam(L[I]);
      S2 := StrValue(L[I]);
      if S2 = '' then
      begin
        AQue.ParamByName(S1).Clear;  //28.10.11
        AQue.ParamByName(S1).DataType := ftString;  //28.11.11
        AQue.ParamByName(S1).Bound := true;  //null Wert zuweisen
      end else
        AQue.ParamByName(S1).AsString := S2;
    end;
    try
      AQue.Open;
    except on E:Exception do begin
        ProtSQL(AQue);
        Raise;
      end;
    end;
    Result := AQue.FieldByName(aFieldname).AsString;
    if not AQue.EOF then
    begin
      if Sysparam.ProtBeforeOpen then
      begin
        Prot0('GetKritValue(%s,%s,%s)=%s', [aTable, aFieldname, KritNames, Result]);
        ProtSql(AQue);
      end;
    end else
    begin
      Prot0('WARN EOF bei GetKritValue(%s,%s,%s) %s', [aTable, aFieldname, KritNames,
        QueryText(AQue, [qtoOneLine])]);
    end;
  finally
    L.Free;
    AQue.Close;
  end;
end;

function UniqueIndexFields(ADatabase: TuDatabase; ATblName: string; UniqueIndexFieldList: TStrings): string;
// Erstell Liste aller Feldnamen die an einem Unique Index beteiligt sind (nicht verwendet)
begin
  Result := InternalIndexInfo(ADatabase, ATblName, nil, nil, UniqueIndexFieldList);
end;

function IndexInfo(ADatabase: TuDatabase; ATblName: string;
  IndexList: TStrings = nil; OptionsList: TStrings = nil): string;
// Bestimmt Index Infos einer Tabelle. Ergibt Felder des Hauptkeys. Berücks. fehlende PKeys.
// UniDAC: Baue BDE-Arrays auf: IndexList, IndexFieldList
begin
  Result := InternalIndexInfo(ADatabase, ATblName, IndexList, OptionsList, nil);
end;

function InternalIndexInfo(ADatabase: TuDatabase; ATblName: string;
  IndexList, OptionsList, UniqueIndexFieldList: TStrings): string;
//UniDAC Version. Erkennt Schema (Schema.Tablename)
// ergibt PKey Felder mit ';' getrennt
// Info: GNavigator.TablePKeys ist identisch mit IndexInfos
var
  AMeta: TuMetadata;
  S1, S2: string;
  tmpIndexList, tmpOptionsList, tmpUniqueIndexFieldList: TStrings;
  PKeyName: string;  //Indexname für Result
  SchemaName, OnlyTableName, NextStr: string;
  RestrSchema: string; //Restrictions Wert
begin
  Result := '';
  ATblName := StrValueDflt(StrCgeChar(ATblName, '"', #0));  //ADRE=ADRESSEN
  if ATblName = '' then
    Exit;

  if (IndexList = nil) and (OptionsList = nil) and (UniqueIndexFieldList = nil) and
     (GNavigator <> nil) then
  begin
    Result := GNavigator.IndexInfos.Values[ATblName];
    if Result = '' then                        //dbo.tname -> tname (Alles ab dem letzten '.')
      Result := GNavigator.IndexInfos.Values[OnlyFieldName(ATblName)];
    if Result <> '' then          {bereits ermittelt}
      Exit;
  end;
  if ADatabase = nil then
    Exit;

  if IndexList = nil then
    tmpIndexList := TStringList.Create else
    tmpIndexList := IndexList;
  if tmpIndexList is TStringList then
    TStringList(tmpIndexList).Duplicates := dupIgnore;
  if OptionsList = nil then
    tmpOptionsList := TStringList.Create else
    tmpOptionsList := OptionsList;
  if UniqueIndexFieldList = nil then
    tmpUniqueIndexFieldList := TStringList.Create else
    tmpUniqueIndexFieldList := UniqueIndexFieldList;
  AMeta := TuMetadata.Create(nil);
  //geht nicht AMeta.Debug := true;  //test
  PKeyName := '';
  try
    if GNavigator <> nil then
      GNavigator.SetDuplDB(AMeta, ADataBase, 4)  //spezial
    else begin
      AMeta.SessionName := ADatabase.SessionName;
      AMeta.DatabaseName := ADatabase.DatabaseName;  //Connection
    end;
    tmpIndexList.Clear;  // alle Index nach tmpIndexList
    tmpOptionsList.Clear;

    AMeta.MetaDataKind := 'Indexes';
    SchemaName := '';
    OnlyTableName := ATblName;
    if Pos('.', ATblName) > 0 then
    begin
      SchemaName := PStrTok(ATblName, '.', NextStr);
      OnlyTableName := PStrTokNext('.', NextStr);
    end;
    //if SysParam.Oracle then
    if SameText(ADatabase.ProviderName, 'Oracle') then
    begin
      if SchemaName = '' then
        SchemaName := ADatabase.Username;  //TRINKMB statt TRINK
      RestrSchema := 'TABLE_SCHEMA';
    end else
    begin
      RestrSchema := 'SCHEMA_NAME';
    end;
    //ATblName  		// 'Indexinfo: Öffne %s'
    SMess(SProts_010, [SchemaName + '.' + OnlyTableName + '@' + RestrSchema]);
    AMeta.Restrictions.Values[RestrSchema] := SchemaName;
    AMeta.Restrictions.Values['TABLE_NAME'] := OnlyTableName;
    AMeta.Open;
    while not AMeta.EOF do
    begin
      S1 := AMeta.FieldByName('INDEX_NAME').AsString;
      tmpIndexList.Values[S1] := 'dummy';
      if AMeta.FieldByName('UNIQUE').AsInteger = 1 then
      begin
        tmpOptionsList.Values[S1] := 'Unique';
        if (PKeyName = '') or SameText(S1, OnlyTableName + '_ID') or
           BeginsWith(S1, 'PK_', true) then
          PKeyName := S1;
      end;
      AMeta.Next;
    end;
    AMeta.Close;

    //Alle Indexcolumns nach tmpIndexList
    AMeta.MetaDataKind := 'IndexColumns';
    AMeta.Restrictions.Values[RestrSchema] := SchemaName;
    AMeta.Restrictions.Values['TABLE_NAME'] := OnlyTableName;
    AMeta.Open;  //sortiert nach Indexname+Position
    while not AMeta.EOF do
    begin
      S1 := AMeta.FieldByName('INDEX_NAME').AsString;
      S2 := tmpIndexList.Values[S1];
      if S2 = 'dummy' then
        S2 := '';
      AppendUniqueTok(S2, AMeta.FieldByName('COLUMN_NAME').AsString, ';', true);
      tmpIndexList.Values[S1] := S2;
      if AMeta.FindField('DESCENDING') <> nil then
      begin
        if AMeta.FieldByName('DESCENDING').AsInteger = 1 then
        begin
          S2 := tmpOptionsList.Values[S1];
          AppendTok(S2, 'Descending', ', ');
          tmpOptionsList.Values[S1] := S2;
        end;
      end else
      if AMeta.FindField('SORT_ORDER') <> nil then
      begin
        if AMeta.FieldByName('SORT_ORDER').AsString = 'DESC' then
        begin
          S2 := tmpOptionsList.Values[S1];
          AppendTok(S2, 'Descending', ', ');
          tmpOptionsList.Values[S1] := S2;
        end;
      end;
      AMeta.Next;
    end;
    AMeta.Close;

    //Primary Key (wenn vorhanden)
    AMeta.MetaDataKind := 'Constraints';
    AMeta.Restrictions.Values[RestrSchema] := SchemaName;
    AMeta.Restrictions.Values['TABLE_NAME'] := OnlyTableName;
    AMeta.Restrictions.Values['CONSTRAINT_TYPE'] := 'PRIMARY KEY';
    AMeta.Open;
    if not AMeta.EOF then
    begin
      S1 := StrDflt(AMeta.FieldByName('INDEX_NAME').AsString,
                    AMeta.FieldByName('CONSTRAINT_NAME').AsString); //MSSQL
      S2 := tmpOptionsList.Values[S1];
      //27.12.11 entfernt wg Abfrage - if S2 = 'Unique' then S2 := '';
      AppendTok(S2, 'Primary', ', ');
      if S1 <> '' then
      begin
        tmpOptionsList.Values[S1] := S2;
        PKeyName := S1;
      end;
    end;
    AMeta.Close;

    if PKeyName <> '' then
    begin
      Result := tmpIndexList.Values[PKeyName];
      if Result = 'dummy' then
        Result := '';

      if (GNavigator <> nil) and (Result <> '') and
         not (csDesigning in GNavigator.ComponentState) then
        GNavigator.IndexInfos.Values[ATblName] := Result;   //merken
    end;

  finally
    if IndexList = nil then
      tmpIndexList.Free;
    if OptionsList = nil then
      tmpOptionsList.Free;
    if UniqueIndexFieldList = nil then
      tmpUniqueIndexFieldList.Free;
    FreeAndNil(AMeta);
  end;
end;

function QueryTableName(ADataSet: TDataSet): string;
{Extrahiert den ersten TableName aus SQL Text}
const
  SqlTrenner = CRLF + ', ';
var
  //P, P1: PChar;
  //NextStr: PChar;
  S1, NextS1: string;
  DoIt: boolean;
begin
//  P := StrNew(StrIPos(PChar(AQuery.Text), 'FROM'));
//  P1 := StrTok(P+4, ' ,' + CRLF, NextStr);
//  Result := StrPas(P1);
//  StrDispose(P);

  if ADataSet = nil then
  begin
    Result := '(nil)';
  end else
  if ADataSet is TuTable then
  begin
    Result := TuTable(ADataSet).Tablename;
  end else
  if ADataSet is TuQuery then
  begin
    //ab 27.12.09 Sql Tokens
    Result := '';
    S1 := PStrTok(TuQuery(ADataSet).Text, SqlTrenner, NextS1);
    while S1 <> '' do
    begin
      DoIt := SameText(S1, 'FROM');
      S1 := PStrTokNext(SqlTrenner, NextS1);
      if DoIt then
      begin
        Result := S1;
        Break;
      end;
    end;
    if SysParam.ProtBeforeOpen then
      Prot0('QueryTableName(%s)'+CRLF+'=(%s)', [RemoveCRLF(TuQuery(ADataSet).Text), Result]);
  end else
    Result := Format('(%s)', [ADataSet.Classname]);
end;

function QueryServerName(ADBDataSet: TuQuery): string;
//Ergibt den BDE Parameter SERVER NAME des Dataset
var
  DB: TuDatabase;
begin
  Result := '';
  try
    //DB := Session.FindDataBase(Query1.DataBaseName);
    DB := QueryDatabase(ADBDataSet);
    if DB <> nil then
    begin
      Result := DB.Database;  //18.02.13 vorher Server;
    end;
  except on E:Exception do
    EProt(ADBDataSet, E, 'Fehler bei QueryServerName', [0]);
  end;
end;

function QueryDatabase(ADataSet: TDataset): TuDataBase;
var
  iud: IUDataset;
begin
  Result := nil;
  if not assigned(ADataSet) then
    Exit;
  if not Supports(ADataSet, IUDataset, iud) then
    Exit;
  Result := iud.GetDataBase;
  if Result = nil then
  begin
    Result := QueryDatabase(iud.GetDataBaseName);
  end;

end;

function QueryDatabase(ADatabaseName: string): TuDataBase;
begin
  Result := nil;
  try
    Result := USession.FindDataBase(ADatabaseName);
    if Result = nil then
      EError('database (%s) has no session', [ADatabaseName]);
  except on E:Exception do
    EProt(Application, E, 'QueryDatabase(%s)', [ADatabaseName]);
  end;
end;

function IsLocalQuery(AQuery: TuQuery): boolean;
{liefert true wenn AQuery eine lokale Tabelle (Paradox,dBase) ist}
var
  ADataBase: TuDatabase;
begin
  ADataBase := QueryDataBase(AQuery);
  if ADataBase <> nil then
  begin
    ADataBase.Connected := true;    {um isSqlBased zu erkennen}
    Result := not ADataBase.IsSqlBased;
  end else
    Result := true;                 {kann passieren. Ist dann Local}
end;

function QueryHasNotnullBlobs(ADataSet: TDataSet): boolean;
//ergibt true wenn mindestens ein nicht leeres BLOB-Field existiert
var
  I: integer;
begin
  Result := false;
  for I := 0 to ADataSet.FieldCount - 1 do
  begin
    if ADataSet.Fields[I].IsBlob and not ADataSet.Fields[I].IsNull then
    begin
      Result := true;
      Break;
    end;
  end;
end;

function QueryPostCommitted(AQuery: TDataSet; WhenBlobs: boolean): integer;
{ führt AQuery.Post in einer Transaktion aus. AQuery muss im Edit/Insert Modus sein.
  Für BLOBS speichern (QueryHasNotnullBlobs())
  Für XMLExport.Import  Works for ORA 01.10.10!
  09.11.10 try datn?
  }
var
  ADataBase: TuDataBase;
  B1: boolean;
begin
  Result := 0;
  ADataBase := QueryDataBase(AQuery);
  if WhenBlobs then
    B1 := QueryHasNotnullBlobs(AQuery) else
    B1 := true;
  if (ADataBase <> nil) and B1 and
     not ADataBase.InTransaction then
  try
    ADataBase.StartTransaction;    //für NoAutocommit muss keine Tr. gestartet werden
    AQuery.Post;
    if AQuery is TuQuery then
      Result := TuQuery(AQuery).RowsAffected;  //geänderte Zeilen
    if ADataBase.InTransaction then
    try
      ADataBase.Commit;
    except
      //zur Zeit wird keine Trans vorgenommen
    end;
  except on E:Exception do begin
      try
        if ADataBase.InTransaction then
          ADataBase.Rollback;
      except
        // Exception hier uninteressant
      end;
      EProt(AQuery, E, 'Fehler bei QueryPostCommitted(%s)', [OwnerDotName(AQuery)]);
      raise;
    end;
  end else
  begin
    AQuery.Post;
    if AQuery is TuQuery then
      Result := TuQuery(AQuery).RowsAffected;  //geänderte Zeilen
  end;
end;

function QueryExecCommitted(AQuery: TuQuery): integer;
{ führt AQuery.ExecSql aus und Committed danach.
  Notwendig wenn in Database SQLPASSTHRU MODE=SHARED NOAUTOCOMMIT eingestellt ist. }
  //TransIsolation auf tiDirtyRead setzen
var
  ADataBase: TuDatabase;
begin
  ADataBase := QueryDataBase(AQuery);
  if (ADataBase <> nil) and
     (ADataBase.Params.Values['SQLPASSTHRU MODE'] = 'SHARED NOAUTOCOMMIT') and
     not ADataBase.InTransaction then
  try
    ADataBase.StartTransaction;    //für NoAutocommit muss keine Tr. gestartet werden
    AQuery.ExecSql;
    Result := AQuery.RowsAffected;  //geänderte Zeilen
    if ADataBase.InTransaction then
    try
      ADataBase.Commit;
    except
      //zur Zeit wird keine Trans vorgenommen
    end;
  except on E:Exception do begin
      try
        if ADataBase.InTransaction then
          ADataBase.Rollback;
      except
        // Exception hier uninteressant
      end;
      Prot0('Fehler bei QueryExecCommitted(%s)', [OwnerDotName(AQuery)]);
      raise;
    end;
  end else
  begin
    AQuery.ExecSql;
    Result := AQuery.RowsAffected;  //geänderte Zeilen
  end;
end;

procedure ProcExecCommitted(AProc: TUniStoredProc);
{ führt AProc.ProcExec aus und Committed danach.
  Notwendig wenn in Database SQLPASSTHRU MODE=SHARED NOAUTOCOMMIT eingestellt ist. }
var
  ADataBase: TuDatabase;
begin
  ADataBase := QueryDataBase(AProc);
  if (ADataBase <> nil) and
     (ADataBase.Params.Values['SQLPASSTHRU MODE'] = 'SHARED NOAUTOCOMMIT') and
     not ADataBase.InTransaction then
  try
    ADataBase.StartTransaction;    //für NoAutocommit muss keine Tr. gestartet werden
    AProc.ExecProc;
    if ADataBase.InTransaction then
      ADataBase.Commit;
  except on E:Exception do begin
      try
        if ADataBase.InTransaction then
          ADataBase.Rollback;
      except
        // Exception hier uninteressant
      end;
      Prot0('Fehler bei QueryExecCommitted(%s)', [OwnerDotName(AProc)]);
      raise;
    end;
  end else
    AProc.ExecProc;
end;

(* Dialogunterstützung *)

procedure StrToFont(const S: string; F: TFont);
{Fontbeschreibung nach Font. Aufbau:[Name, Size, Style, Color].  Style:[NFKUD]}
var
  Tok, NextS: string;
  Step: integer;
begin
  Tok := Trim(PStrTok(S, ',', NextS));
  Step := 1;
  while Tok <> '' do
  begin
    case Step of
      1: F.Name := Tok;
      2: F.Size := StrToIntDef(Tok, 10);
      3: begin {Style}
           F.Style := [];
           if Pos('F', Tok) > 0 then F.Style := F.Style + [fsBold];
           if Pos('K', Tok) > 0 then F.Style := F.Style + [fsItalic];
           if Pos('U', Tok) > 0 then F.Style := F.Style + [fsUnderline];
           if Pos('D', Tok) > 0 then F.Style := F.Style + [fsStrikeOut];
         end;
      //4: F.Color := StrToIntDef(Tok, clBlack);
      4: F.Color := StrToColor(Tok);
    end;
    Tok := Trim(PStrTok('', ',', NextS));
    Inc(Step);
  end;
end;

function FontToStr(F: TFont): string;
{ergibt Fontbeschreibung anhand Font}
var
  S1: string;
begin
  Result := F.Name;
  AppendTok(Result, IntToStr(F.Size), ', ');
  S1 := '';
  if fsBold in F.Style then S1 := S1 + 'F';
  if fsItalic in F.Style then S1 := S1 + 'K';
  if fsUnderline in F.Style then S1 := S1 + 'U';
  if fsStrikeOut in F.Style then S1 := S1 + 'D';
  if S1 = '' then S1 := 'N';
  AppendTok(Result, S1, ', ');
  //AppendTok(Result, Format('$%X', [F.Color]), ', ');
  AppendTok(Result, ColorToStr(F.Color), ', ');
end;

function StrToColor(const S: string; Dflt: TColor = clBlack): TColor;
begin
  //Result := StrToIntDef(S, Dflt);
  if S = '' then
    Result := Dflt else
  try
    Result := StrToInt(S);
  except
    Result := Dflt;
  end;
end;

function ColorToStr(cl: TColor): string;
begin
  //Result := Format('$%08.8X', [abs(cl)]);
  Result := Format('$%08.8X', [cl]);
end;

function GetAmpelColor(aVal, aMin, aMax: integer): TColor;
//aus Ampelwert in aVal GridFarbe ermitteln. aMin->Grün  aMax->Rot
//RGB: rot=255,0,0  gelb=255,255,0  grün=0,255,0
//Idee: Umsetztabelle (nicht linear) für jedes Spektrum. Spektrum=Max-Min+1(1..9->9)
//siehe AmpelSpektrum9
var
  RedVal, GreenVal: integer;
  Mitte: integer;
  function SetRed(Value: double): integer;
  var
    V: TVektor;
  begin   {Red: 0..(aMin+aMax)/2 -> 0..255}
    V := TVektor.Create(aMin, Mitte, 0, 255);
    try
      Result := round(IMax(0, IMin(255, V.FI(Value))));
    finally
      V.Free;
    end;
  end;
  function SetGreen(Value: double): integer;
  var//Gelbwert
    V: TVektor;
  begin   {Green: (aMin+aMax)/2..aMax -> 255..0}
    V := TVektor.Create(Mitte, aMax, 255, 0);
    try
      Result := round(IMax(0, IMin(255, V.FI(Value))));
    finally
      V.Free;
    end;
  end;
begin
  Mitte := (aMin + aMax) div 2;
  RedVal := SetRed(AVal);
  GreenVal := SetGreen(AVal);
  Result := RGB(RedVal, GreenVal, 0);
  if Sysparam.ProtBeforeOpen then
    ProtA('Ampel(%d,%d,%d) -> %08.8X', [aVal, aMin, aMax,  Result]);
end;

(* Betriebssystem, Drucker *)

procedure SetDefaultPrinter(Index: integer);
(* nicht nur in WIN16 sinnvoll *)
{Setze den Standartdrucker auf Drucker 'Index'}
var
  DefaultDevice: array[0..255] of char;
  ADevice, ADriver, APort: array[0..80] of char;
  ADeviceMode: THandle;
begin
  if StartPrnDevice = nil then
  begin
    StartPrnDevice := StrAlloc(255);
    GetProfilestring('Windows', 'Device', 'unbekannt', StartPrnDevice, 255);
    if Index < 0 then
      Exit;
  end;
  ProtL('SetDefaultPrinter(%d)', [Index]);
  if (Index >= 0) and (Index < Printer.Printers.Count) then
  begin
    SMess('SetDefaultPrinter10', [0]);
    Printer.PrinterIndex := Index;
    SMess('SetDefaultPrinter11', [0]);
    Printer.GetPrinter(ADevice, ADriver, APort, ADeviceMode);
    SMess('SetDefaultPrinter12', [0]);
    StrFmt(DefaultDevice, '%s,%s,%s',[ADevice, ADriver, APort]);
    WriteProfilestring('Windows', 'Device', DefaultDevice); {setzt Standarddrucker}
    SMess('SetDefaultPrinter13', [0]);
  end else
  begin
    SMess('SetDefaultPrinter20', [0]);
    WriteProfilestring('Windows', 'Device', StartPrnDevice);
    SMess('SetDefaultPrinter21', [0]);
  end;
  SMess('SetDefaultPrinter30', [0]);
  WriteProfilestring(nil, nil, nil);      {flush unter Win95}
  SMess('SetDefaultPrinter31', [0]);
  //SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, LPARAM(PAnsiChar('windows'))); {271200}  dauert
  //SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0, 0);  {08.03.03}  dauert
  //SendMessage(Application.Handle, WM_SETTINGCHANGE, 0, 0);  {09.03.03}  dauert auch zu lang
  if SysParam.SetIniChange then   //true bei WIN98! ISA30.04.03
    SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, LPARAM(PAnsiChar('windows')));
  SMess('SetDefaultPrinter32', [0]);
  Printer.PrinterIndex := -1;              {setzt Printer=Standarddrucker}
  SMess('SetDefaultPrinter33', [0]);
  SMess0;
end;

procedure SetupPrinter(ADruckerTyp: string);
{Dialog um Druckereinrichten}
begin
  TDlgPrnFont.Execute(ADruckerTyp);
end;

procedure SendChar(AWinControl: TWinControl; Characters: string);
(* Sendet Characters als WM_CHAR Messages an angegebenes Handle *)
var
  I: integer;
  OldInSendChar: boolean;
begin
  OldInSendChar := false;  //wg Compilerwarnung
  try
    if GNavigator <> nil then
    begin
      OldInSendChar := GNavigator.InSendChar;
      GNavigator.InSendChar := true;
    end;
    for I := 1 to length(Characters) do    {Canceled: mit ProcessMessages}
      if (GNavigator <> nil) and not GNavigator.Canceled then
        SendMessage(AWinControl.Handle, WM_CHAR, WPARAM(Characters[I]), 0);
  finally
    if GNavigator <> nil then
    begin
      GNavigator.InSendChar := OldInSendChar;
    end;
  end;
end;

procedure PostKeys(AWinControl: TWinControl; Keys: array of Word);
(* Postmessages Keys als WM_KEYDOWN+WM_KEYUP Messages an angegebenes Handle *)
var
  I: integer;
begin
  for I := low(Keys) to high(Keys) do    {Canceled: mit ProcessMessages}
    if (GNavigator <> nil) and not GNavigator.Canceled then
    begin {PostMessage wichtig für QDispo.DiAu}
      PostMessage(AWinControl.Handle, WM_KEYDOWN, WPARAM(Keys[I]), 0);
      PostMessage(AWinControl.Handle, WM_KEYUP, WPARAM(Keys[I]), 0);
    end;
end;

function ClientToClient(const Point: TPoint; SourceControl, TargetControl: TControl): TPoint;
(* Konvertierung zwischen den Koordinatensystemen verschiedener Steuerelente *)
begin
  Result := TargetControl.ScreenToClient(SourceControl.ClientToScreen(Point));
end;

procedure Delay(Value: longint; Silent: boolean = false);
(* Wartet Value [ms] *)
var
  Start: longint;
  OldProgress: integer;
begin
  OldProgress := 0;  //wg Compilerwarnung
  if not InDelay and (GNavigator <> nil) and (GNavigator.Gauge <> nil) then
  try
    InDelay := true;
    OldProgress := GNavigator.Gauge.Progress;
    TicksReset(Start);
    while TicksDelayed(Start) < Value do
    begin
      if (OldProgress = 0) and not GNavigator.NoProcessMessages and not Silent then
      begin
        GMessA(TicksDelayed(Start), Value);       {A/B*100}
      end;
      GNavigator.ProcessMessages;            {!!! DPE.Sps 310398, quvar3.hiost}
      //Application.ProcessMessages;    //08.12.02
    end;
  finally
    if OldProgress = 0 then
      GMess(0) {else
      GNavigator.Gauge.Progress := OldProgress};
    InDelay := false;
  end else
  begin
    {Prot0('Delay %d',[Value]);}
  end;
end;

procedure DelayHard(Value: longint; Silent: boolean = false);
(* Wartet Value [ms] - ohne Processmessages! *)
var
  Start: longint;
  OldProgress: integer;
begin
  OldProgress := 0;  //wg Compilerwarnung
  if not InDelay and (GNavigator <> nil) and (GNavigator.Gauge <> nil) then
  try
    InDelay := true;
    OldProgress := GNavigator.Gauge.Progress;
    TicksReset(Start);
    while TicksDelayed(Start) < Value do
    begin
      if (OldProgress = 0) and not GNavigator.NoProcessMessages and not Silent then
      begin
        GMessA(TicksDelayed(Start), Value);       {A/B*100}
      end;
      //ohne Processmessages!
    end;
  finally
    if OldProgress = 0 then
      GMess(0) {else
      GNavigator.Gauge.Progress := OldProgress};
    InDelay := false;
  end else
  begin
    {Prot0('Delay %d',[Value]);}
  end;
end;

function TicksDelayed(Start: integer): integer;
//Ergibt Zeitdifferenz zwischen jetzt und Start in Millisekunden
//Berücksichtigt negative Werte und Zurückspringen des Systemcounters
var
  T: integer;
begin
{$R-}
  T := GetCurrentTime; //GetTickCount; //mit Vorzeichen
  if T >= Start then
    Result := T - Start else
    Result := -T;
{$R+}
end;

function TicksRestTime(Start, Interval: integer): integer;
//Ergibt Restzeit bis Interval abgelaufen ist (TicksCheck true wird)
//entspricht Interval - (CurrentTime - Start)
// bzw. Interval + Start - CurrentTime
begin
  Result := IMax(0, Interval - TicksDelayed(Start));
end;

procedure TicksReset(var Start: integer);
//Setzt StartTicks zurück
begin
{$R-}
  Start := GetCurrentTime;
{$R+}
end;

function TicksCheck(var Start: integer; Interval: integer): boolean;
//Ergibt true wenn <Interval>ms seit letztem Aufruf verstrichen
//Verwendet <Start> für Speicherung des letzten Aufrufs
begin
  Result := TicksDelayed(Start) > Interval;
  if Result then
    TicksReset(Start);
end;

{ RTicks: Genauigkeit in ms aber absolute Angaben in TDateTime }

function RTicksDelayed(Start: TDateTime): Integer;
//wie TicksDelayed aber mit TDateTime als Start. Unabhängig von Rechnerlaufzeit.
var
  DiffDT: TDateTime;
  DiffSecs: Double;
begin
  DiffDT := Now - Start;
  DiffSecs := DiffDT * SecsPerDay;  //Auflösung in Sekunden als Float
  if DiffSecs > MaxInt div 1000 then
  begin  //zu groß für uns: Maximum annehmen
    Result := MaxInt;
    Exit;
  end;
  Result := Round(DiffSecs * 1000);
end;

function RTicksRestTime(Start: TDateTime; Interval: integer): Integer;
//wie TicksRestTime aber mit TDateTime als Start. Unabhängig von Rechnerlaufzeit.
begin
  Result := IMax(0, Interval - RTicksDelayed(Start));
end;

procedure RTicksReset(var Start: TDateTime);
//wie TicksReset aber mit TDateTime als Start. Unabhängig von Rechnerlaufzeit.
begin
  Start := Now;
end;

function RTicksCheck(var Start: TDateTime; Interval: Integer): boolean;
//wie TicksCheck aber mit TDateTime als Start. Unabhängig von Rechnerlaufzeit.
begin
  Result := RTicksDelayed(Start) > Interval;
  if Result then
    RTicksReset(Start);
end;

function FileTimeToMSecs(FileTime: TFileTime): integer;
{ ergibt Anzahl MilliSec vergangen seit FILETIME
  http://www.swissdelphicenter.ch/torry/showcode.php?id=671 }
var
  ModifiedTime: TFileTime;
  stFile: TSystemTime;
  dt: TDateTime;
  ts: TTimeStamp;
begin
  //GetSystemTime(st);              // gets current time
  Result := 0;
  if (FileTime.dwLowDateTime = 0) and (FileTime.dwHighDateTime = 0) then
    Exit;
  try
    FileTimeToLocalFileTime(FileTime, ModifiedTime);
    FileTimeToSystemTime(ModifiedTime, stFile);
    dt := now - SystemTimeToDateTime(stFile);
    ts := DateTimeToTimeStamp(dt);
    ts.Date := ts.Date - DateDelta;  //Days between 1/1/0001 and 12/31/1899
    Result := ts.Date * MSecsPerDay + ts.Time;
  except
    Result := 0;
  end;
end;

function InPort(PortAddr: Word): Byte;
{$IFDEF WIN32}
assembler; stdcall;
asm
        mov dx,PortAddr
        in al,dx
end;
{$ELSE}
begin
  Result := Port[PortAddr];  //Delphi1 selig
end;
{$ENDIF}

procedure OutPort(PortAddr: Word; Databyte: Byte);
{$IFDEF WIN32}
assembler; stdcall;
asm
   mov al,Databyte
   mov dx,PortAddr
   out dx,al
end;
{$ELSE}
begin
  Port[PortAddr] := DataByte;
end;
{$ENDIF}


function CreateClassID36: string;
//UUID bzw GUID ohne '{}'
begin
  Result := CreateClassID;
  Result := Copy(Result, 2, Length(Result) - 2);
end;

function WinExecErrorStr(ErrorNr: integer): string;
begin
{
  case ErrorNr of
0:  Result := 'Zuwenig freier Speicher, die ausführbare Datei war beschädigt, '+
              'oder die Verschiebungen waren unzulässig.';
2:  Result := 'Datei nicht gefunden.';
3:  Result := 'Pfad nicht gefunden.';
5:  Result := 'Unzulässiger Versuch, eine Task dynamisch einzubinden, oder es gab '+
              'einen Fehler beim gemeinsamen Zugriff bzw. einen Zugriffsfehler im '+
              'Netzwerk.';
6:  Result := 'Bibliothek erfordert getrennte Datensegmente für jede Task.';
8:  Result := 'Ungenügender Speicher, um die Anwendung zu starten.';
10: Result := 'Falsche Windows-Version.';
11: Result := 'Ungültige .EXE-Datei (Keine Windows-.EXE-Datei oder Fehler im '+
              '.EXE-Darstellungsformat).';
12: Result := 'Anwendung wurde für anderes Betriebssystem entworfen.';
13: Result := 'DOS 4.0-Anwendung.';
14: Result := 'Unbekannter .EXE-Dateityp.';
15: Result := 'Versuch, im Protected Mode (Standardmodus oder erweiterter 386-Modus) '+
              'eine für frühere Windows-Versionen erstellte .EXE-Datei zu laden';
16: Result := 'Es wurde versucht, eine zweite Instanz einer ausführbaren Datei zu '+
              'laden, die mehrfache (nicht Read-Only markierte) Datensegmente enthält.';
19: Result := 'Es wurde versucht, eine komprimierte ausführbare Datei zu laden. '+
              'Die Datei muß dekomprimiert werden, bevor sie geladen werden kann.';
20: Result := 'Die Dynamic-Link-Bibliothek(DLL)-Datei war fehlerhaft. Eine der '+
              'DLLs, die zum Start dieser Anwendung notwendig ist, war fehlerhaft.';
21: Result := 'Die Anwendung benötigt 32-Bit-Erweiterungen.';
31: Result := 'Datei nicht gefunden';
  else
    Result := 'Unbekannter Fehler';
  end;
}
  case ErrorNr of
0:  Result := SProts_011+SProts_012;
2:  Result := SProts_013;
3:  Result := SProts_014;
5:  Result := SProts_015+SProts_016+SProts_017;
6:  Result := SProts_018;
8:  Result := SProts_019;
10: Result := SProts_020;
11: Result := SProts_021+SProts_022;
12: Result := SProts_023;
13: Result := SProts_024;
14: Result := SProts_025;
15: Result := SProts_026+SProts_027;
16: Result := SProts_028+SProts_029;
19: Result := SProts_030+SProts_031;
20: Result := SProts_032+SProts_033;
21: Result := SProts_034;
31: Result := SProts_035;
  else
    Result := SProts_036 + ' ' + IntToStr(ErrorNr); //'Unbekannter Fehler';
  end;
end;

function GetAppFromExtension(Ext: string): string;
//Ergibt Anwendung für eine Extension. Ext mit '.', zB '.doc'
//Ergibt '' bei Fehler. Setzt
var
  FileName: string;
  f: System.Text;
  ExePath: array[0..512] of Char;
  InstanceID: THandle;
begin
  Result := '';
  FileName := TempDir + 'Temp' + Ext;   //c:\temp\Temp.doc
  if not FileExists(FileName) then
  begin
    AssignFile(f, FileName);
    Rewrite(f);
    Closefile(f);
  end;
  InstanceID := FindExecutable(PChar(FileName), nil, @ExePath);
  if InstanceID >= 32 then
  begin
    Result := StrPas(ExePath);
  end else
  begin  { a value less than 32 indicates an Exec error }
    if SysParam.ThrowWinExecError then
    begin //'Fehler beim Aufruf von "%s":';
      EError(SProts_039 + CRLF + '%s', [FileName, WinExecErrorStr(InstanceID)]);
    end else
    if SysParam.DisplayWinExecError then
    begin
      ErrWarn(SProts_037 + CRLF + '%d:%s',		// 'Fehler bei "%s" von "%s":'
        ['GetApp', FileName, InstanceID, WinExecErrorStr(InstanceID)]);
    end else
    begin
      // 'Fehler "%s" Aufruf von "%s": %s'
      Prot0(SProts_038, ['GetApp', FileName, WinExecErrorStr(InstanceID)])
    end;
  end;
end;

function JavaExec(JarFileName, JarArgs: string; Wait: boolean; Visibility: integer): DWORD;
var
  InstanceID: THandle;
  JavaPath: array[0..512] of char;
  ExeName, CmdLine: string;
begin                            {Ausführen Operation. Warten bzgl. Wait (n.a.)}
  Prot0('JavaExec(%s Wait:%d)', [JarFileName, Ord(Wait)]);
  try
    Screen.Cursor := crHourGlass;
    InstanceID := FindExecutable(PChar(JarFilename), nil, @JavaPath);  // ergibt java.exe
  finally
    Screen.Cursor := crDefault;
  end;
  if InstanceID < 32 then { a value less than 32 indicates an Exec error }
  begin
    Result := InstanceID;
    if SysParam.ThrowWinExecError then
    begin
      EError(SProts_039 + CRLF + '%s', [JarFileName, WinExecErrorStr(Result)]);
    end else
    if SysParam.DisplayWinExecError then
    begin
      ErrWarn(SProts_037 + CRLF + '%d:%s',		// 'Fehler bei "%s" von "%s":'
        ['Java', JarFileName, Result, WinExecErrorStr(Result)]);
    end else
    begin
      // 'Fehler "%s" Aufruf von "%s": %s'
      Prot0(SProts_038, ['Java', JarFileName, WinExecErrorStr(Result)])
    end;
    Exit;
  end;
  //if InstanceID >= 32 then
  ExeName := StrPas(JavaPath);
  CmdLine := ' -jar "' + JarFilename + '" ' + JarArgs;

  //Result := WinExecNoWait(ExeName + CmdLine, Visibility);
  Result := 0;
  ShellExecute(Application.Handle, 'open', JavaPath, PChar(CmdLine), nil, SW_SHOWNORMAL) ;
  Prot0('%s:%d', [ExeName + CmdLine, Result]);
end;

function ShellExecNoWait(FileName: string; Visibility: integer = SW_SHOWNORMAL): integer;
begin                             {Ausführen und nicht Warten bis beendet}
  //Result := ShellExecOp(FileName, Visibility, 'open', false);
  Result := ShellExecOp(FileName, Visibility, '', false);
end;

function ShellExecAndWait(FileName: string; Visibility: integer = SW_SHOWNORMAL): integer;
begin                             {Ausführen und Warten bis beendet}
  //Result := ShellExecOp(FileName, Visibility, 'open', true);
  //besser, da z.B. Notepad nur den 'Edit' Befehl kennt
  Result := ShellExecOp(FileName, Visibility, '', true);
end;


function ShellExecOp(FileName: string; Visibility: integer;
  Operation: string; Wait: boolean): integer;
var                              {Operation: Open, Print, Explore, FileNew}
  InstanceID: THandle;
  Path: array[0..512] of char;
  Op: array[0..64] of char;
  ExeName, CmdLine: string;
begin                            {Ausführen Operation. Warten bzgl. Wait (n.a.)}
  Result := 0;
  Prot0('ShellExec(%s, Op:%s Wait:%d)', [FileName, Operation, Ord(Wait)]);
  if Wait then
  begin
    try
      Screen.Cursor := crHourGlass;
      InstanceID := FindExecutable(PChar(FileName), nil, @Path);
    finally
      Screen.Cursor := crDefault;
    end;
    if InstanceID >= 32 then
    begin
      ExeName := StrPas(Path);
      if BeginsWith(Filename, '"') then
        CmdLine := '"' + ExeName + '"  ' + FileName else
        CmdLine := '"' + ExeName + '"  "' + FileName + '"';
      Result := WinExecAndWait(CmdLine, Visibility);
      Exit;
    end;
  end;

  { Try to open the application }
  if Operation = '' then
    InstanceID := ShellExecute(Application.Handle, nil,
      StrPCopy(Path, FileName), nil, nil, Visibility)
  else
    InstanceID := ShellExecute(Application.Handle, StrPCopy(Op, Operation),
      StrPCopy(Path, FileName), nil, nil, Visibility);  //Visibility sollte 0 sein bei print

  if InstanceID = 31 then { Anwendung nicht gefunden }
  begin
    if Wait then
      WinExecAndWait('NotePad ' + FileName, Visibility) else
      WinExecNoWait('NotePad ' + FileName, Visibility);
  end else
  if InstanceID < 32 then { a value less than 32 indicates an Exec error }
  begin
    Result := InstanceID;
    if SysParam.ThrowWinExecError then
    begin //'Fehler beim Aufruf von "%s":';
      EError(SProts_039 + CRLF + '%s', [FileName, WinExecErrorStr(Result)]);
    end else
    if SysParam.DisplayWinExecError then
    begin
      ErrWarn(SProts_037 + CRLF + '%d:%s',		// 'Fehler bei "%s" von "%s":'
        [Operation, FileName, Result, WinExecErrorStr(Result)]);
    end else
    begin
      // 'Fehler "%s" Aufruf von "%s": %s'
      Prot0(SProts_038, [Operation, FileName, WinExecErrorStr(Result)])
    end;
  end else
  if Wait then
  begin
    (* The GetModuleUsage function has been deleted.
       Each Win32-based application runs in its own address space.
    repeat
      GNavigator.ProcessMessages;
    until Application.Terminated or (GetModuleUsage(InstanceID) = 0); *)
    Result := 32;
    //auch net: WaitforSingleObject(InstanceID, INFINITE); //InstanceID=33
    {hProcess := OpenProcess(SYNCHRONIZE, False, InstanceId);  //PROCESS_QUERY_INFORMATION
    WaitforSingleObject(hProcess, INFINITE);}
    //klappt lt. ms nur über CreateProcess!!!
  end;
end;

function WinExecAndWait(FileName: string; Visibility: integer = SW_SHOWNORMAL): DWORD;
begin
  Result := WinExecAndWait(FileName, false, Visibility);
end;

function WinExecAndWait(FileName: string; SetCurrDir: boolean; Visibility: integer = SW_SHOWNORMAL): DWORD;
{Ausführe und Warte bis kommt}
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  S1, S2, S3: string;
  P2: integer;
  CurrDirStr: PChar;
begin
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;

  CurrDirStr := nil;
  if SetCurrDir then
  begin
    if BeginsWith(Filename, '"') then
    begin
      P2 := Pos('"', copy(Filename, 2, Maxint));
      S1 := copy(Filename, 2, P2 - 1);
    end else
      S1 := Filename;
    S2 := ExtractFilePath(S1);
    if S2 <> '' then
    begin
      S3 := PartDir(S2);  //ohne letzten \
      CurrDirStr := PChar(S3);
    end;
  end;

//  StartupInfo.dwFlags := StartupInfo.dwFlags + STARTF_USESTDHANDLES;
//  try
//    try
//      //hTest := FileOpen(TempDir + 'StdOut.dat', fmOpenWrite or fmShareDenyNone);
//      SysUtils.DeleteFile(TempDir + 'ExecStdOut.dat');
//      hTest := FileCreate(TempDir + 'ExecStdOut.dat');
//      FileWrite(hTest, 'Hallo', 5);
//      StartupInfo.hStdOutput := hTest;
//      StartupInfo.hStdError := hTest;
//    except on E:Exception do
//      EProt(Application, E, 'stdout', [0]);
//    end;

    Screen.Cursor := crHourGlass;
    if not CreateProcess(
       nil,                           { Application Name: replaced by zAppName}
       PChar(Filename),               { pointer to command line string }
       nil,                           { pointer to process security attributes }

       nil,                           { pointer to thread security attributes }
       false,                         { handle inheritance flag }
       CREATE_NEW_CONSOLE or          { creation flags }
       NORMAL_PRIORITY_CLASS,
       nil,                           { pointer to new environment block }
       CurrDirStr,                    { pointer to current directory name }
       StartupInfo,                   { pointer to STARTUPINFO }
       ProcessInfo) then              { pointer to PROCESS_INF }
    begin
      Screen.Cursor := crDefault;
      Result := GetLastError;
      if SysParam.ThrowWinExecError then
      begin
        EError(SProts_039 + CRLF + '%s', [FileName, WinExecErrorStr(Result)]);
      end else
      if SysParam.DisplayWinExecError then
      begin		// 'Fehler beim Aufruf von "%s":'
        ErrWarn(SProts_039 + CRLF + '%s', [FileName, WinExecErrorStr(Result)]);
      end else
        Prot0(SProts_040, [FileName, WinExecErrorStr(Result)]); // 'Fehler beim Aufruf von "%s": %s'
      Result := $FFFFFFFF;
    end else
    begin
      Screen.Cursor := crDefault;
      Result := 32;
      // Achtung: wartet zB auf Word nur wenn es nicht bereits gestartet ist!
      SMess('warte auf %s', [Filename]);
      WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
      SMess0;
      GetExitCodeProcess(ProcessInfo.hProcess, Result);
    end;
//  finally
//    FileClose(hTest);
//  end
end;

{      ShellExecute(0, // jmt.!!! Application.Handle,
        nil,
        PChar(TranslatedDefaultURL), nil, nil, SW_SHOWNOACTIVATE);
}

function WinExecNoWait(FileName: string; Visibility: integer = SW_SHOWNORMAL): integer;
{Ausführen. Nicht Warten}
var
  InstanceID : THandle;
  Path: array[0..255] of AnsiChar;
begin
  { Try to run the application }
  try
    Screen.Cursor := crHourGlass;
    InstanceID := WinExec(StrPCopy(Path, AnsiString(FileName)), Visibility);
  finally
    Screen.Cursor := crDefault;
  end;

  {if InstanceID < 32 then { a value less than 32 indicates an Exec error }
  Result := InstanceID;
  if Result < 32 then
    if SysParam.ThrowWinExecError then
    begin
      EError(SProts_039 + CRLF + '%s', [FileName, WinExecErrorStr(Result)]);
    end else
    if SysParam.DisplayWinExecError then
    begin	// 'Fehler beim Aufruf von "%s":'
      ErrWarn(SProts_039 + CRLF + '%s', [FileName, WinExecErrorStr(Result)]);
    end else
      Prot0(SProts_040, [FileName, WinExecErrorStr(Result)]); // 'Fehler beim Aufruf von "%s": %s'
end;

procedure ShutDown(ReBoot: boolean);
  //Rechner ausschalten. Reboot: true = neu starten

  function SetPrivilege(privilegeName: string; enable: boolean): boolean;
  //Privileg setzen, daß der Prozess Windows beenden darf
  var
    tpPrev,
    tp         : TTokenPrivileges;
    token      : THandle;
    dwRetLen   : DWord;
  begin
    Result := False;
    OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, token);
    tp.PrivilegeCount := 1;
    if LookupPrivilegeValue(nil, PChar(privilegeName), tp.Privileges[0].LUID) then
    begin
      if enable then
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
      else
        tp.Privileges[0].Attributes := 0;
      dwRetLen := 0;
      Result := AdjustTokenPrivileges(token, False, tp, SizeOf(tpPrev), tpPrev, dwRetLen);
    end;
    CloseHandle(token);
  end;

begin
  SetPrivilege('SeShutdownPrivilege', true);
  if InitiateSystemShutDown (nil, 'shutdown system ...', 15, true, ReBoot) then
      Prot0 ('ShutDown System(%d)',[ord(ReBoot)])
    else
      Prot0 ('Error on ShutDown System...',[]);
  Delay(2000);
  Application.Terminate;
end;

function NonClientMetrics: TNonClientMetrics;
//ergibt System Abmessungen:
//iBorderWidth: Specifies the thickness, in pixels, of the sizing border.
//iScrollWidth: Specifies the width, in pixels, of a standard vertical scroll bar.
//iScrollHeight: Specifies the height, in pixels, of a standard horizontal scroll bar.
begin
//Buggy D2010 und XP  Result.cbSize := sizeof(Result);
//von https://forums.embarcadero.com/thread.jspa?threadID=25425
{$IF CompilerVersion < 21.0}
Result.cbSize := SizeOf(TNONCLIENTMETRICS);
{$ELSE}
Result.cbSize := TNONCLIENTMETRICS.SizeOf;
{$IFEND}

  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @Result, 0);
end;

// Höhe der Titelleiste:
// GetSystemMetrics(SM_CYCAPTION);

function DelphiRunning: boolean;
var
  H1, H4 : Hwnd;
const
  Tested: char = #0;
  A1 : array[0..12] of char = 'TApplication'#0;
  A2 : array[0..15] of char = 'TAlignPalette'#0;
  A3 : array[0..18] of char = 'TPropertyInspector'#0;
  A4 : array[0..11] of char = 'TAppBuilder'#0;
{$ifdef WIN32}
  {T1 : array[0..10] of char = 'Delphi 2.0'#0;}
  T1 : array[0..10] of char = 'Delphi 5'#0;
{$else}
  T1 : array[0..6] of char = 'Delphi'#0;
{$endif}
begin
  if Tested = #0 then
  begin
    H1 := FindWindow(A1, nil);  // T1: D2010 nicht );
//    H2 := FindWindow(A2, nil);
//    H3 := FindWindow(A3, nil);
    H4 := FindWindow(A4, nil);
    Result := (H1 <> 0) and
              //D2010 nicht (H2 <> 0) and (H3 <> 0) and
              (H4 <> 0);
    if Result then
      Tested := 'T' else
      Tested := 'F';
  end else
    Result := Tested = 'T';
end;

function AskDelphiRunning(Meldung: string): boolean;
begin
  if DelphiRunning then
    Result := WMessYesNo('DelphiRunning(%s)?', [Meldung]) = mrYes else
    Result := false;
end;

function CpuMHz: longint;
const
  DelayTime = 500;
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority      := GetThreadPriority(GetCurrentThread);

  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  Sleep(10);
  asm
    dw 310Fh
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
    dw 310Fh
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);

  Result := TimerLo div (1000 * DelayTime);
end;

function PentiumBug: boolean;
(* true = Pentium Bug *)
const
  a: single = 4195835.0;
  b: single = 3145727.0;
var
  c: double;
begin
{$U-}
  c := a / b;
{$U+}
  if a - c * b > 1.0 then
    Result := true else
    Result := false;
end;

function EnumFunc(Wnd: HWND; TargetWindow: PHWND): bool;
var
  ClassName : array[0..255] of char;
  n: integer;
begin
  Result := true;
{$ifdef WIN32}
  {if GetWindowLong(Wnd, GWL_HINSTANCE) = hPrevInst then}
{$else}
  if GetWindowWord(Wnd, GWW_HINSTANCE) = hPrevInst then
{$endif}
  begin
    n := GetClassName(Wnd, ClassName, 255);
{$ifdef WIN32}
    if n = 0 then
      Prot0('EnumFunc:%d', [GetLastError]);
{$endif}
    if StrIComp(ClassName,'TApplication') = 0 then
    begin
      TargetWindow^ := Wnd;
      Result := false;
    end;
  end;
end;

procedure GotoPreviousInstance;
var
  PrevInstWnd : HWND;
begin
  PrevInstWnd := 0;
  EnumWindows(@EnumFunc, longint(@PrevInstWnd));
  if PrevInstWnd <> 0 then
  begin
    if IsIconic(PrevInstWnd) then
      ShowWindow(PrevInstWnd,SW_RESTORE)
    else
      BringWindowToTop(PrevInstWnd);
  end;
end;

(* Test ob bereits geladen unter Win32:
   siehe Komponente OnlyOnce
*)
procedure TSysParam.SetBatchMode(const Value: boolean);
begin
  fBatchMode := Value;
end;

initialization
  Set8087CW($133F);  //siehe Opengl.pas; turn off Floating point exceptions;

  Prot := nil;
  StartPrnDevice := nil;
  SysParam := TSysParam.Create;
finalization
  EnvStrings.Free;
  SysParam.Free;

(*
   03.10.96     Erstellen
   08.12.96     ExecAndWait
   26.12.96     CM_APP ab $8000
   25.09.97     OnlyDate,OnlyTime, BC SETTITEL, ListCount, MoveField
   06.10.97     ScanFieldValue und CompFieldText: ignore case ! (ROE GotoNearest)
   02.02.98     - Char1
                - ReverseStr
                - PosR
   07.03.98     Sysparam.BatchMode
   26.03.98     GetMemoString, Boolean
   08.04.98     GetStringsString, GetStringsInteger, Boolean, usw.
   16.04.98     SetEdNum(EdBtr, copy(S, 30, 8));
   25.06.98     Logfile:  Platzhalter umsetzen:
                          #D -> Tag;   #M -> Monat; #Y -> Jahr
                          #W -> WochenTag   (Mo=00 Di=01 .. So=06)
                          #H -> Stunde  #N = Minute  #S =sekunde
   26.07.98     CompareStrings
   04.08.98     CompareTextLen
   04.08.98     GetName(Component)
   09.09.98     StrCgeStrStr
   22.09.98     DbUserName
   19.10.98     SMess0,DMess0, HMess0, GMess0
   23.10.98     Bug bei PStrTok: nahm nicht immer den kürzesten Token
                AssignFieldComp
   26.10.98     BC SETTITEL -> BC LNAV mit Unterfunktionen
   02.11.98     FieldIsName:  mehrere Feldnamen mit ';' getrennt werden
   02.11.98     WMessErr, WMessWarn
   06.11.98     StrToDateY2, StrToDateTimeY2: Y2000-sicheres StrToDate
   09.11.98     Div0(Zähler,Nenner): sicheres Div,/.  Nenner kann 0 sein
   12.11.98     WinExecNoWait
   13.11.98     WriteOem, WriteFmt
   17.11.98     SetFieldFloatN0
   29.01.99     AppendTok
   22.02.99     FieldIsNull
   21.03.99     ReplaceParams
   10.05.99     SetFieldFloatRO, NextTab
   20.05.99     RequiredStr, StrDflt, ReadlnOem
   08.06.99     CharI
   01.07.99     SetEdCenter
   18.07.99     DirExists
   29.07.99     UpdateFieldDefs -> in FldDsKmp: FldDsc.Update
   27.01.00     Polling geht während MessageDlg weiter (in WMess, usw.)
                  nur wenn SysParam.PollIdle=true,
   18.04.00     ProtSql
   22.04.00    GetStringsStrings
   28.05.00    PosCh
   25.08.00    StrToOem, StrToAnsi
   29.01.01    StrToDateTol
   14.05.01    SendKeys, ClientToClient
   08.07.01    Delphi5. Win16 wird nicht mehr unterstützt.
   18.05.02    Tag Werte für qwf_form.FormResizeStd
   22.06.02    StrIn, CompStr, AnsiCompStr
   28.06.02    bei Löschen Immer nachfragen: ConfirmDelete
   24.08.02    FieldTypeStr() nach GetFieldType() umbenannt da Namenskonflikt.
   14.09.02    mrToStr
   26.09.02    Encrypt, Decrypt - Verschlüsselung nach Borland
   27.09.02    ProtDataSet {Protokolliert die Feldinhalte eines DataSet}
   10.01.03    ListBoxAdd
   13.01.03 JP Alternative Druckername / Druckerindex in .INI schreiben
   13.01.03 JP Alternative Druckername / Druckerindex in .INI schreiben
            TS FloatToIntTolNk
   10.05.03 BG WinSysDir, ProgDir
   23.08.03 MD Prot.Edit; Prot.EditAll; {anderes Logfile editieren}
   31.08.03 MD EndsWith, BeginsWith
   01.10.03 MD Prot.Edit; Prot.EditAll; EvalExpression; CompUserName; OnlyFileName
   15.10.03 BG function FormatTol
   11.12.03 MD OwnerDotName
   07.03.04 MD GetUniqueValues; IsLocalQuery (<-LocalQuery)
   06.05.04 MD StrToColor/ColorToStr
   29.09.04 MD Ticks*
   10.03.05 TS StrToFloatTolSep
   03.06.05 MD StrToMSecs
   11.10.05 MD FloatDflt
   21.11.05 MD PStrTok: Variante mit string(mehrere Zeichen, z.B. '\r') als Trenner. DoTrim=false
   13.12.05 MD GetAmpelColor
   16.10.07 MD PartDir, EncodeEnvDir, DecodeEnvDir, GetEnvStrings, GetLongPathName
   29.10.07 MD GetLongPathName in SystemKmp
   27.12.07 MD GetFileDateTime
   06.02.08 MD Indexinfo: Table.Open vermeiden
   03.04.08 MD FracToInt jetzt Integer mit Max.9 Stellen
   03.04.08 MD RTrunc als Ersatz für fehlerhaftes Trunc, RCeil, RPower
   06.07.08 MD ImageLoadOutZoomed
   07.06.08 MD SetFileDateTime
   14.08.08 MD WinExecAndWait: wenn Filename Pfad enthält dann wird CurrDir gesetzt (Tomcat restart)
   29.11.08 MD SameText
   08.03.09 MD QueryText: qtoShort
   14.04.09 MD AppendUniqueTok ergibt true wenn ergänzt und false wenn Tok bereits vorhanden
               Prot.FilePath neue Patterns: %U=Windowsuser %M=Computername %A=Anwendung ohne .exe
   23.04.09 MD SaveControlsToIni, LoadControlsFromIni
   27.02.10 MD Quersumme
   04.06.11 MD ExtractSeconds()
   06.09.12 md FileClearReadOnly(
*)
end.
