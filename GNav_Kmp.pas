unit Gnav_kmp;
(* GNavKmp.PAS

   Globaler Navigator: Komponente

   Autor: Martin Dambach
   Letzte ƒnderung                    siehe auch doc\history.txt
   24.09.96     Erstellen
   19.10.96     mit Exceptionhandler
   09.10.97     LNav.DoInit jetzt in Qwf_Form.Init
   27.10.97     TableSynonyms
   30.12.97     MarkAllMemo keine Property mehr. Intern verwaltet.
   15.04.97     (In)ProcessMessages
   25.06.98     Close
                ProtStart
                Alive...
   24.07.98     Makros:
                1. Submenu 'Makros' mit den Eintr‰gen:
                   Makro Definieren --> GNavigator.MakroDefineClick(Sender: TObject);
                   (Strg-) B,C,G,H,I,J,N,L,O,P,Q,R --> GNavigator.MakroClick(Sender: TObject);
                2. GNavigator.MakroInit(MiMakros: TMenuItem);    (in FrmMain.FormCreate aufrufen)
                Syntax:    \r = zum n‰chsten Dialogelement
                Men¸ f¸r Clipbord: in kmp\mimakros.clp
   26.07.98     DoBeforePost
   09.09.98     Konvert
   18.09.98     DoNavLinkInit globales Ereignis
   09.11.98     V2.00  KmpVersion
   26.11.98     V2.01  Roe. PrnSource.Caption
   09.12.98     SMessLocked
   07.01.99     DbCompare
   17.05.99     V2.02  SQL:or  DisplayWinExecError, rechte Maustaste,
                       PrnSource.Options.psSetCaption, OnPostError, Y2000,
                       QR.Preview Zoom
   25.05.99     PropsDlg;
   05.06.99     NoOpenSMess
   28.07.99     V2.10 FldDsc Modul
   07.02.00     V2.11 BeforeDelete, AfterPost(nl)
   30.03.00     Canceled als Property: mit ProcessMessages
   07.04.00     V2.12 Nur f¸r Delphi32:
                NavLink.MarkList jetzt durch NavLink.DBGrid.BookMarkList ersetzt
   02.01.01     V3.00 Nur f¸r Delphi5:
   05.01.01     HtmlTable StringList
   14.02.01     V3.01 vor English Resource strings
   23.04.01     V3.02 KeyList.Values['Standard'] als Std-Key
   04.05.01     V3.03 Mu.Layout:Spalten korrekt. mgColDefChanged.
   29.06.01     V3.03a CPro ¸berarbeitet ErrorProt
   13.07.01     FldDsWhereSql
   23.07.01     V3.04 OnTranslateStr (noch mit ResourceStrings)
   05.08.01     V3.05 Translate per OnTranslateStr, TranslateForm, MP85 Waage
   06.11.01           a
   18.12.01     V3.06 CanReBoot. Poll
   27.01.02          a Reload nach Insert bei PageChange
   01.02.02     V3.06b OPC   c Detailins   d Reload nach Erfass
   03.03.02     V3.06e Combit   f llPrn   g llPrn  h L8MD
   14.04.02     V3.07 Mu.DragField
   11.05.02     V3.08 Rechteverw.
   15.05.02     V3.09 Combit LL-Komponenten entfernt (addons/combit)
   23.06.02     V3.10 GNavigator.SysFields (bisher const in Prots)  a  26.08.02 b
   31.08.02     V3.11 Detailbook kann auch TPagecontrol sein  a addons\email  b mrToStr
                      c StopWatch  d MemoryLeaks  e Ausw.DateGroup, XML
   26.09.02     V3.11 f Encryption   g Rechte, Sql drop, ProtDataset
   01.10.02     V3.12 PropEds, PageControl f¸r Pagebook und Detailbook, TabControl
   10.10.02     V3.12 b qSplitter pattern
   29.10.02     V3.12 c XML Export Dialog in Mu-Menu  d XML
   18.12.02     V3.12 e Bug bei Destroy CProt. XML NoToAll.
   28.12.02           f Bug ValidDir
   28.12.02           g ShellExec ohne 'open'.
   05.02.03           h wenn Canceled auf true dann wird AbortDlg beendet
   13.02.03           i Rechteverw
   17.03.03           j TS ƒnderungen auﬂer nlnk, sql(nstr)
   01.04.03     V3.12 k Gen.SQL bei INT-Format
   08.04.03     V3.12 l Hardcopy als QRepKurz
   28.04.03	V3.12 m
   22.05.03     V3.12 n CProt, DisK, LLPrn
   26.05.03     V3.12 o Translate
   01.06.03     V3.12 p IT3000 Waage
   02.06.03     V3.12 q UserActionTime
   02.06.03     V3.12 r SysFields: BEMERKUNG entfernt. ComProt: property NoThread erg‰nzt (OLE-Zugriff)
   19.07.03     V3.12 s Sql_Dlg
   19.07.03     V3.12 t ComboboxAsw, Translation TCombobox aus
   24.07.03     V3.12 u property TableSynonym[]
   08.08.03     V3.12v  siehe Dekl.  w)   x:Pr171Kmp
   29.10.03     V3.13   IniDbKmp,  a IniDb,  HinitIni in IniDb  b bugs  c inidb,div
   05.01.04          d  IniDb + Permanent Keys
   21.01.04          e  Lookup lumZeigMsk und AendMsk: keine ‹bernahme eines anderen Datensatzes mehr mˆglich
   10.02.04          f  SearchDlg. Abbruch w‰hrend MarkAll mˆglich.
   03.03.04          g  prop TablePKeys (Primarykeys ohne Datenbankinfo festlegen)
   29.03.04          h  Rechte.Userlist; IniDb; XML Import; Nav.OnDelete Error Ereignis
   06.04.04          i  FltrFrm; Eprot erg‰nzt 'Fehler bei'
   16.05.04          j  AddCalcFields:TIBQuery;
                        Markierte Lˆschen:Weiter bei Fehler;
                        StrValueDflt, FltrList.ValueDflt: nimmt linke Seite wenn rechte Seite leer
                        SQL:Tablename Alias 'K1=KUND;K2=KUND..';
                            IgnoreCase: Suchkrit Sonderzeichen '^' -> erzeugt UPPER(FIELD)='SUCHSTRING'
                            SQL-Zeilenumbruch nach 80 Zeichen (RestrictSqlLine)
                        Auswertung:Datumdialog:Abbruch->lˆscht Datum;
                        Sysparam.MSSQL;
                        LovDlg:‹bernehmen nur bei AutoEdit; Pfeiltasten; Spalten auf 50 begrenzen;
                        MultiGrid: Hint 'Reihenfolge mit Maus ziehen' wenn dies mˆglich;
                                   Spaltenbreite begrenzen; Speichern bei Enter;
                        Prots: PosRI; StrToColor/ColorToStr; StrValueDflt
                        Comboboxen als nicht markiert verlassen (SetRoAttrib)
                        SqlDlg: MiUniDirectional; mehrzeilige /* Kommentare */; Templates
                        WSDDEKmp:ClientSocketSendText protokolliert nicht mehr bei Fehler
                        XML Import:ImpQue(Que):Angabe einer Query f¸r BeforePost Ereignis
   13.07.04          k
   29.07.04          l  Permanent Sort in LuGrid
   08.09.04          m  Formular in Verwendung:LuGrid verwenden.
                        Asws_Kmp:TComboboxAsw
                        DPos_Kmp:SetChangedValue
                        Err__Kmp: EIsNotnullFehler
                        GNav:Session.SetPrivateDir
                        Lookup:Test ob Formular in Verwendung. Wenn ja dann mit LuGrid weiter.
                        Notnull Fehler rufen jetzt auch Ereignis FOnPostError
                        Prots:ComboboxSetText
                        Xls:Widestring Unterst¸tzung
   26.09.04          n  DwtEnq
   11.10.04          o  ErrKmp
   21.10.04          p  Calccache Designzeit
   09.11.04          q
   02.12.04          r  SqlDlg.Historie;CalcCache;Opc
   06.12.04          s  Auswert.Zeitbis,Checkbox Visible
   13.12.04          t  Ausw:ddNone;Prots:DateTimeIntl
   07.01.05          u  DdeSiDlg;
   21.02.05          v  ReplaceAll;RoundCUR
   09.03.05          w  IniEdiCopy
   20.04.05          x  BlobSize=500 qw\logondlg f¸r Lfs.Bitmaps
   29.04.05          y  ThrowWinExecError; SqlBtn in QrPreview; Bug bei nstr_kmp Sql;
   02.05.05          z  Dwt2 f¸r QuvaSvr
   28.05.05     V3.14a  ShellExecAndWait; TAsw.DlgIndex; NXls; StopWatch.ProtEnum;
                        TDlgXmlExport.Database von Query
   07.06.05          b  GNavigator.OnLMess; IniKmp.ReadMSecs; Prots.StringToMSecs
                        Prots.FileTimeToMSecs; TTitleGrid.AdjustColWidths(UpOnly)
   15.06.05          c  ProtP0
   19.07.05          d  EmailKmp, Xls:VariantOf, Ini:DfltSection, MuGri:MarkAll, Ro8_3964
   09.08.05          e  SqlDlg, Xls
   20.10.05          f
   22.20.05          g  Prot0 threadsafe
   23.10.05          h bug wmess threadsafe; FormatTol in Prot0,EError,MessageFmt,..
   24.10.05          i prots.prNoLbFocus {In Listbox auch bei Focus auff¸llen}
   10.11.05          j gen per Ini
   10.01.06          k
   07.04.06          l prots.QueryDatabase(); prots.ProtStoredProc();
   01.05.06          m CPro_Kmp
   18.05.06          n unicodebug (kein Effekt)
   06.06.06          o StripExtension, SqlDialog:Prot, Bug Multigrid, AbortDlg
   18.06.06          p EAccess Fehler bei Projektwechsel Designtime
   05.07.06          q BtnSort, KmpRes, Mu:Sort by DblClick,
   14.07.06          r EAccess Fehler bei Projektwechsel Designtime: GNav#DbInit
   26.07.06          s Tmb, Scroll, DragDrop
   06.09.06          t Slidebar, Qw
   08.09.06          u Lookup:InLookupList:nur Edit, Qw Silo Schenk
   10.10.06          v Qw, Mu, Prots, NLnk
   24.10.06          w Asws.Params, FldDeDlg, Lnav, Nlnk, Prots, Qnav
   22.11.06          x CPro:ClearInput liefert InputPuffer zur¸ck
                       DPos:SQL Generierer ber¸cksichtigt MSSQL's DatePart
                       FldDsKmp:weitere except Absicherung
                       FltrFrm:Alle reservierte Objekte werden freigegeben
                       LuDef: LuEdits mit Options.LeNoOverride werden auch in direkten Zugriff nicht ¸berschrieben (spart Nachladen indirekt zugeordneter Tabellen wenn PKEY aus mehreren Feldern besteht)
                       LuEditKmp: bei Options.LeNoNullValues wird der Master-Datensatz erst geladen wenn dieses Feld gef¸llt ist.
                       FormatList: Reihenfolge der N, R, usw. egal. Asw, und ##0.0 Formatierung m¸ssen weiterhin am Ende stehen
                       FormatList: 'A,' erg‰nzt, setzt TField.AutoGenrateValue=true
                       Prn__Dlg: ¸berarbeitet
                       Prots: 'EUR' ist Standardw‰hrung (war 'DM')
                       Prots:QueryText und ProtSql erlauben jetzt TDataSet und unterst¸tzen TIBQuery
                       QSpin_Kmp: property Mask hinzugef¸gt (als FormatFloat Argument)
                                  public Property Value: longint verf¸gbar
   09.12.06          y StartForm:SendToBack
   18.12.06          z Dwt410, 'Gmbh & Co',
   03.01.07     V3.15  Bug Asws; BuildSOList dynamisch; IntDflt; SourceFocus; ChangeLogDlg;
   04.01.07          a Bug bei OnDataChange:Stack¸berlauf
   25.01.07          b BG2001; CProt:Descr.: W:$80; FltrFrm:ˆffentlich; GNav.ScreenToClient f¸r Maskenpositionierung;
                       IniDB:Protlist threadsave; LNav.SetPollSleep; Multi:0-RowHeights;
                       Multi:Letzte Zeile immer komlett; mdMaster-LuDef immer lˆschen;
                       Fltr-Abfrage kann ' - ' enthalten; Sql:IbReconnect weg;
   20.02.07          c CalcCache optimiert mehrere Felder; CollapsePanel; FieldSetTime(int);
                       ChangeLog-Trigger f¸r MSSQL; 'SQVA'-Release
   06.03.07          d markierte drucken: PrnSource.MuSelect; ShellTools; CPro:SleepStartTime
   29.03.07          e qw\FltrFrm weg
   18.04.07          f Qw
   23.04.07          g OPCS7, FawaWS
   04.05.07          h Clipboard; CTerm
   09.05.07          i NoOpen bleibt in Nav.Start; Mu.ToggleEditor
   02.07.07          j EmailKmp:Outbox-Verz von Reg.; FawaKmp.StrToGewich(Nk=0 orig); lumErfassMsk:FltrList;
                       LuDef auch duplizierbar; StrToIntl; Preview BringToFront; TDlgSql.OraCompileInvalidObjects;
   14.07.07          k SubCaption
   25.07.07          l prots
   31.07.07          m FltrFrm Eprot statt Emess
   07.08.07          n Asws:Exc; DlgSql:Close before ExecList
   30.08.07          o DfltRep+CalcCache; ForceFocus; ComponentLogName; AddFltr('\r')
   03.09.07          p PollKmp:Aufruf Sleep innerhalb OnPoll; Prots.X Lˆschschutz
   11.09.07          q PollKmp:blockt jetzt auch bei csFreeNotification in ComponentState
   12.09.07          r Xml Import verwendet :Parameter zum Positionieren
   18.09.07          s XmlImport:<Format>, Bde/Bdexx, MuGri.MarkAll
   20.09.07          t Nav.IsAfterPostStart, PollKmp:ComponentState:nur destroy beachten
   24.09.07          u Bug bei HasFltrChar (Lookup Suchkriterien)
   28.09.07          v DdeSiDlg, LNav:Detail+Rechte, Qwf_Form:BC_CREATEWND erst in Loaded
   29.10.07          w Awe560, FltrFrm(\r), SystemKmp, Sysparam.UsePressKey waterproof,
                       Prots.PartDir, EncodeEnvDir, List GetEnvStrings, GetTimeInc
   03.11.07          x Fawa.ProtDruck:true=ProtNr von Waage false=Speichenr von Waage, Hintergrundsdruck
                       (ProtDruck entfernt in Row7, wt65, wt60, it30)
   20.11.07          y Lov:*sortiert, Sanduhr bei Clipboard, prots.GraphicFileFound
   08.01.08          z +IEEEFloatClass, Prots.GetIPAdress, Prots.GetFileDateTime,
                       Prots.TimeToStr2 mit 2stelliger Stundenanzeige
   05.02.08     V3.16  Mu markieren mit mittl.Maustaste, WSDDE Clientindex
   18.02.08          a Bug bei CreateUniqueFilename, EmailSendKmp
   13.03.08          b XMLWriter
   18.03.08          c XMLWriter als Component
   21.03.08          d Konv_Dlg, Refaktoring Compilerwarnungen
   27.03.08          e Ini.CacheTemp, Suchen+DblClick in Multigrid, InCheckAutoOpen
   01.04.08          f Lookups nicht unerwÅnscht îffnen: AssignValue&ReadOnly
   04.04.08          g RTrunc usw.
   11.04.08          h RTrunc per original rechnen, jetzt mit ClearPendingExceptions;
                       qForm.InitList; Eigenschaften mit Session.PrivateDir
   21.04.08          i Sql Hints /*+all_rows*/ in eigener Zeile von SqlFieldlist setzen;
                       GNav.LoadForm ruft auch Nav.DoStart auf (incl. PostStart und Poll)
                       Sortieren-Dialog ¸bernimmt 'absteigend' und 'permanent' ohne sonst ƒnderungen
   27.04.08          j Qnav.dsQuery; GNav.LoadForm ruft NICHT MEHR Nav.DoStart auf (war bug)
   06.05.08          k Nav.Poll wieder erlauben auch bei LoadForm
   06.05.08          l Navlink.AssignField und AssignValue laden Daten bei Feld‰nderung wieder nach
   15.05.08          m DFLTRep:Hoch/Querformat,
   05.06.08          n DfltRep; DfltXRep neu; PrnDialog Portrait/Landscape, Leerzeilen; Options.psOrientation
                       QueryExecCommitted f¸r SQLPASSTHRU MODE=SHARED NOAUTOCOMMIT; qrext.QRFormatLines
                       Bug in Rechteverwaltung (Objektrechte)
   17.06.08          o Bug Startform Z-Order; LuDef.LuMultiname kann auch Zahl f¸r Pageindex enthalten
   27.06.08          p TPrnSource kopiert auch References
   26.08.08          q WordPrnKmp, NXls_Kmp (NativeExcel), QRep:ImageLoadOutZoomedQr,
                       MultiGrid:Spalten nicht editierbar wenn entspr. DBEdit.Readonly
                       Tabellenlayout auch im Suchen-Modus ‰nderbar
                       FormatList: 'C,' f¸r Felder die auf dem Server berechnet werden
                       Abfragen: FltrFrm speichert auch Tabellenlayout (optional)
                       STMEFrm, DfltRep: Fontsize, TqAdoConnection, FileBtn, DirBtn
   30.09.08          r BdeFreeDisk, Calc mit History, Dateiablage (Datn), EmailSendKmp mit Html/text,
                       Navlink.AssignFloat, AssignDatetime, Prots.FillTemplate, GetDetailFieldValues,
                       HtmlToText
   15.12.08          s
   18.12.08          t qw\logon quku32
   23.12.08          u Flimmern unter XP bei Lookup weg (GetClientHeight)
   28.01.09          v Bug LuDef Scrollbar
   17.04.09          w LuGrid Position merken. EditSingle per Mu.Popup. LuGrid Schnellsuche.
                       TqForm.Maximized
   14.05.09          x vieles
   14.05.09          y LuGrid, Bug bei Strg + Sort
   23.07.09          z
   31.07.09     V3.17  RW
   30.09.09          a
   12.11.09          b TSizeControls, UdpPort, Rowa10 Netz, WsPort(=wie Comm aber per Tcp)
   10.05.10          c
   23.06.10          d RAG701
   30.07.10          e BDE Fehler bei mehreren gestarteten Programmen behoben
   09.09.10          f AAsw.Translate Bug
   11.09.10          g Exception im Designmodus bei Projektwechsel
   16.09.10          h ‹bersetzung LuDef.TabTitel f¸r Lookup-Tabs
   12.05.11          i WordPrnKmp: OnDefineWideField
   04.06.11          j SqlHint 'top 50'. MinRowHeight
   18.06.11          k FormResizeStd ohne EProt
   30.10.11     V4.00  Delphi 2010 und UniDAC
   23.04.12          a Nlnk:Form darf nil sein (Datamodule). Qwlogon:Ideen
   24.04.12          b L&L 17
   26.04.12          c SQL Readonly und Unidac.SQLUpdate
   27.04.12          d datn qupp
   01.05.12    V4.20   XE2
   31.08.12         a  mehrere ƒnderungen
   02.11.12         b  Commit f¸r Backi
   28.11.12         c  IDTables f¸r New_ID(Tablename)
   29.04.12         d  Prots.MuDrawingStyle. Navlink.RecordCount von Unidac
   24.01.14         e  Astrics
   31.01.14            IdleX, IdleY, Aktiv1 nach Class.private
   14.03.14         f  ‰nderbare Konstanten entfernt
   20.05.14         g  Prots.AssignField bug bei LargeInt; IsFloatStr min 1 Ziffer;
                       PrnSource: PageCount via QR.Prepare;
                       TuMetadate erweitert(Kind, Schema, Table)
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, DB, DBCtrls,  Buttons, Menus,
  Uni, DbAccess,
  QNav_Kmp, LNav_Kmp, DPos_Kmp, LUDefKmp, BtnP_Kmp, Qwf_Form, QRepForm,
  Gauges, NLnk_Kmp, RechtKmp, CalcDlg, UDB__KMP, UQue_Kmp, UDatasetIF;

const
  KmpVersion = '4.20f';

const
  DuplDbCount = 5;  //0..4

type
  (* Trick f¸r CharChase: *)
  TDummyCustomEdit = class(TCustomEdit);

  TqFormRef = class of TqForm;
  TqFormObj = class(TObject)
                Locked: boolean;          {sperren w‰hrend Form.Create}
                FormRef: TqFormRef;
                Form: TqForm;
                Data: Pointer;            {wird bei Destroy auf nil gesetzt}
                TabellenRechte: TRechteSet;
                IsTemp: boolean;              {Tempor‰r}
                NoRechteCheck: boolean;       {ohne Rechteverwaltung}
                Disabled: boolean;
                WindowState: TWindowState;    {f¸r WsMinimized}
                constructor Create; virtual;
              end;

  TQRepFormRef = class of TQRepForm;
  TQRepFormObj = class(TObject)
                Locked: boolean;          {sperren w‰hrend Form.Create}
                FormRef: TQRepFormRef;
                PrnSource: TComponent;
                Form: TQRepForm;
              end;

  TLMess = (lmSMess, lmDMess, lmHMess, lmGMess);

  TErrWarnEvent = procedure(Sender: TObject; const Fmt: string;
                  const Args: array of const; var Done: boolean) of object;
  TCompareEvent = procedure(const S1, S2: string; IgnoreCase: boolean;
                  var Value: integer) of object;
  TNavLinkNotifyEvent = procedure(NavLink: TNavLink) of object;
  TTranslateStrEvent = procedure(Sender: TObject; const Src: string;
                       var Dst: string) of object;
  TLMessEvent = procedure(Sender: TObject; const LMessTyp: TLMess;
                var MessText: string) of object;
  TEndFormEvent = procedure(Sender: TObject; const Kurz: string) of object;
  TUpdateFieldDefsEvent = procedure(Sender: TDataSet; const TblName: string;
                          var Updated: boolean) of object;
  TCheckVersionEvent = procedure(Sender: TObject; var NewVersion: boolean) of object;

  (* Globaler Navigator *)
  (* TGNavigator = class(TDBQBENav) *)
  TGNavigator = class(TComponent)
  private
    { Private-Deklarationen }
    { FNavigator: TDBNavigator; sp‰ter enth‰lt DataSource }
    //FAktFormLabel: TEdit;

    MarkAllMemo: TMemo;
    MiMakros: TMenuItem;

    FPanelSMess: TPanel;
    FPanelDMess: TPanel;
    FPanelHMess: TPanel;
    FPanelClient: TPanel;
    FMiCharCase: TMenuItem;
    FBtnSort: TSpeedButton;
    FBtnDruck: TSpeedButton;
    FBtnEscape: TSpeedButton;
    FBtnSingle: TBtnPage;
    FBtnMulti: TBtnPage;
    FBtnSql: TSpeedButton;
    FBtnCalc: TCalcBtn;
    FGauge: TGauge;
    FLokalMuSi: boolean;             {true = Lokale Multi/Single Buttons}
    FColorEditWhite: TColor;         {EditFarbe DBEdits}
    FColorEditGray: TColor;          {EditFarbe Radiogroups u.‰.}
    FColorDetail: TColor;            {EditFarbe Detailtabelle}
    FColorMarkAll: TColor;           {EditFarbe wenn alles Markiert}
    FParamList: TValueList;          {jeder P. hat die Form <Param>=<Value>}
    FTableSynonyms: TValueList;      {jeder P. hat die Form <Param>=<Value>}
    FIDTables: TValueList;           {Viewname=Tablename}
    FFldDsWhereSql: TValueList;      {Field Description where Klausel}
    FSysFields: TStringList;         {Systemfelder. Werden nicht dupliziert}
    FDuplDb1: array[0..DuplDbCount-1] of TuDatabase;  {interne Database Variable}
    FBemerkung: TStringList;
    FHtmlTable: TStringList;         {Syntax f¸r HTML Clipbord Format}
    FVersion: string;
    FMinSpaceLines: integer;         {Anzahl reservierter Zeilen f¸r Symbole}
    fCanceled: boolean;              {Abbruch-Button-Flag f¸r Loops      170198}
    IdleX: integer;
    IdleY: integer;
    Aktiv1: boolean;

    (* Ereignisse von Application und Screen *)
    FOnIdle: TIdleEvent;
    FOnHint: TNotifyEvent;
    FOnControlChange: TNotifyEvent;
    FOnFormChange: TNotifyEvent;
    FOnErrWarn: TErrWarnEvent;
    FOnCheckLizenz: TErrWarnEvent;
    FBeforePost: TDataSetNotifyEvent;
    FBeforeDelete: TDataSetNotifyEvent;
    FAfterPost: TNavLinkNotifyEvent;
    FOnNavLinkInit: TNotifyEvent;
    FOnDbCompare: TCompareEvent;
    FOnTranslateStr: TTranslateStrEvent;
    FOnLMess: TLMessEvent;
    FOnEndForm: TEndFormEvent;
    FOnUpdateFieldDefs: TUpdateFieldDefsEvent;
    FOnCheckVersion: TCheckVersionEvent;
    procedure DoOnIdle(Sender: TObject; var Done: Boolean); {Application.HandleMessage}
    procedure DoOnHint(Sender: TObject);
    procedure DoOnControlChange(Sender: TObject);
    procedure SetParamList(Value: TValueList);
    procedure SetTableSynonyms(Value: TValueList);
    procedure SetFldDsWhereSql(Value: TValueList);
    procedure SetBemerkung(Value: TStringList);
    procedure SetSysFields(Value: TStringList);
    procedure SetHtmlTable(Value: TStringList);
    procedure SetVersion(Value: string);
    procedure SetMarkAllMarked(Value: boolean);
    function GetDB1: TuDataBase;
    function GetClientWidth: integer;
    function GetClientHeight: integer;
    function GetCanceled: boolean;
    procedure SetCanceled(const Value: boolean);
    function GetTableSynonym(ATblName: string): string;
    procedure SetTableSynonym(ATblName: string; const Value: string);
    procedure SetTablePKeys(const Value: TValueList);
    procedure FDuplDb1Login(Database: TuDataBase; LoginParams: TStrings);
    procedure SetIDTables(const Value: TValueList);
    function DoOnCheckVersion: boolean;
  protected
    { Protected-Deklarationen }
    MaskenRecht : boolean;
    IdleTime: string;
    CheckVersionStart: integer;
    InCheckVersion: boolean;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetQrForms(const FormKurz: string): TQRepForm;  {f¸r prop QrForms}
  public
    { Public-Deklarationen }
    FormList: TStringList;
    QRepFormList: TStringList;
    X: TDBQBENav;
    LNavigator: TLNavigator;          {NoteBook,Kurz,}
    PreviewForm: TForm;               {Aktives Formular w‰hrend Preview}
    CreateKurz: string;               {FormKurz w‰hrend Create f¸r TqForm}
    DMessText, HMessText, SMessText: string;
    DMessTimer: integer;
    SMessLocked: boolean;
    DragCount: longint;               {1=Dragging aktiv}
    NoProcessMessages: boolean;  {true=kein ProcessMessages}
    InBtnEscapeClick: boolean;
    InProcessMessages: boolean;
    FMarkAllMarked, MarkAllCopied: boolean;
    ProtStart: boolean;                {Flag ob Programmstart protokolliert wurde}
    LastAliveTime: longint;            {Zeitpunkt letzte Alive Meldung}
    NoOpenSMess: boolean;              {true = '÷ffne ...' verhindern}
    CanReBoot: boolean;                {false=kein Boot mˆglich. Vergl. ReBoot()}
    IndexInfos: TValueList;            {Zwischenspeicher von PrimaryKeys f¸r IndexInfo}
    TmpPrimaryKey: string;             {f¸r DetailInsert i.V.m. ORA Blobs nachladen}
    UserActionTime: integer;           {Timestamp letzte User-Aktion Key oder Maus}
    NoTranslateList: TStringList;      {Liste mit nicht zu ¸bersetzenden Texten}
    PrivateDirOK: boolean;             {Flag ob Session.PrivateDir erfolgreich gesetzt wurde}
    LizenzDtNow, LizenzDtWarn, LizenzDtSperr: TDateTime; {Lizenz ¸berpr¸fen}
    LizenzWarnCount: integer;
    Db1DesignParamsSet: boolean;       {Flag f¸r Designmodus}
    InSendChar: boolean;               {Flag w‰hren Makroausf¸hrung gesetzt}
    CheckBoundsFlag: boolean;
    ProtControlChange: boolean;        //true = jeden Feldwechsel protokollieren

    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    destructor Destroy; override;
    procedure Close;                    {Programm Ende}
    procedure DbInit;
    function SetDuplDB(aUDataset: IUDataset; aDB: TuDataBase; aIndex: integer): boolean;
    function GetDuplDB(aDB: TuDataBase; aIndex: integer): TuDataBase;
    function GetFormKurz(Index: integer): string;
    procedure SetLink(AForm: TForm; ANavLink: TNavLink; ADataSource: TDataSource);
    procedure ActiveFormChange(Sender: TObject);      { AktForm setzen }
    procedure PageChanged(NewPage: string);
    function GetFormObj(Kurz: string; RechteTest: boolean;
      DisplayErrorMessage: boolean = true): TqFormObj;
    function AddForm(Kurz: string; FormRef: TqFormRef): TqFormObj;     {Formular anmelden}
    function AddTempForm(Kurz: string; FormRef: TqFormRef): TqFormObj; {Tempor‰res Formular anmelden}
    function AddSysForm(Kurz: string; FormRef: TqFormRef): TqFormObj;
    procedure SetForm(Kurz: string; AForm: TqForm);
    function GetForm(Kurz: string): TqForm;
    procedure SetFormData(Kurz: string; Data: Pointer);
    function GetFormData(Kurz: string): Pointer;
    function GetFormValue(Kurz, ParamName: string): string;
    function SetFormValue(Kurz, ParamName, Value: string): boolean;
    function FormIsDisabled(Kurz: string): boolean;
    function ReleaseForm(Kurz: string): boolean;
    procedure PostForm(Kurz: string);
    procedure PostCloseForm(Sender: TqForm; Kurz: string);
    function StartFormIndex(Index: integer): TqForm;
    function StartFormData(AOwner: TComponent; Kurz: string;
      Data: Pointer): TqForm; overload;
    function StartFormData(AOwner: TComponent; Kurz: string;
      Data: Pointer; aWindowState: TWindowState): TqForm; overload;
    {Aufruf einer Form ¸ber K¸rzel. MMit ‹bergabe von Init-Daten}
    function StartFormShow(AOwner: TComponent; Kurz: string;
                           aWindowState: TWindowState = wsNormal): TqForm;
    (* Formular starten oder nur zeigen wenn bereits angelegt *)
    function StartForm(AOwner: TComponent; Kurz: string): TqForm;
    {Aufruf einer Form ¸ber K¸rzel}
    function LoadForm(AOwner: TComponent; Kurz: string; Data: Pointer): TqForm;
    (* Laden und initialisieren einer Form ohne anzuzeigen *)
    procedure KillForm(Kurz: string);
    procedure EndForm(AOwner: TComponent; Kurz: string);
    function GetQRepForm(Kurz: string): TQRepForm;
    function GetQRepFormObj(Kurz: string): TQRepFormObj;
    procedure AddQrepForm(Kurz: string; FormRef: TQRepFormRef);
    function GetPrnSource(Kurz: string): TComponent;
    function StartQRepForm(APrnSource: TComponent; Kurz: string): TQRepForm;
    procedure EndQRepForm(AOwner: TComponent; Kurz: string);
    procedure SendAlive(aAliveTime: integer);
    procedure SetLizenzDatum(aDtmWarn, aDtmSperr: TDateTime);
    function CheckVersion(aVersion: string; Interval: integer;
      aComment: string = ''): boolean;
    function CheckLizenz(aKurz: string): boolean;
    function CheckActiveLookUp: boolean;
    procedure LookUp(LNavCaller: TLNavigator; ALookUpDef:TLookUpDef;
                      LookUpKurz: string);
    function Return(FromForm: TqForm; ToKurz: string; ALookUpModus: TLookUpModus;
                     ADataPos: TDataPos; ToLuName: string): boolean;
    (* f¸r Aufrufe von auﬂerhalb *)
    procedure BtnSortClick(Sender: TObject);
    procedure BtnDruckClick(Sender: TObject);
    procedure BtnEscapeClick(Sender: TObject);
    procedure BtnSqlClick(Sender: TObject);
    procedure BtnSingleClick(Sender: TObject);
    procedure BtnMultiClick(Sender: TObject);
    procedure BtnCalcClick(Sender: TObject);
    procedure BtnHintClick(Sender: TObject);
    procedure MiCharCaseCaption(Sender: TObject);
    procedure MiCharCaseClick(Sender: TObject);
    procedure Export;
    procedure Import;
    procedure Konvert;
    procedure ChangeAll;
    procedure SearchAndReplace(Replace: boolean);
    function DbCompare(const S1, S2: string; IgnoreCase: boolean): Integer;
    (* vergleicht 2 Strings mit Datenbank-Sortierfolge Verwendet OnDbCompare - Ereignis *)
    function TranslateStr(Sender: TObject; const Src: string): string;
    (* ergibt ‹bersetzung eines Strings. Die Realisierung erfolgt anwendungsspezifisch
       im Ereignis OnTranslateStr *)
    procedure TranslateComponent(aComponent: TComponent);
    procedure TranslateForm(aForm: TCustomForm);  {‹bersetzt Captions in Form}
    procedure TrInit; {Translation Init. Von Application erst aufrufen wenn ‹bersetzung mˆglich}
    procedure ProcessMessages;       {entspr. Application.~}
    procedure HandleMessages;        {ProcessMessages + HandleMessage}
    procedure FieldDescDlg;          {Dialog ¸ber verwaltete Feldbeschreibungen}
    procedure PropsDlg;              {Aktuelle Tabellen Properties}
    procedure DdeSysInfoDlg;         {DDE Server f¸r QuSy aufbauen}
    procedure DdeObjektInfo(AKennung: string; AList: TStrings);
    procedure MakroInit(MiMakros: TMenuItem);
    procedure MakroClick(Sender: TObject);
    procedure MakroDefineClick(Sender: TObject);
    procedure CutItem(AControl: TWinControl);
    procedure CopyItem(AControl: TWinControl);
    procedure PasteItem(AControl: TWinControl);
    procedure ClearItem(AControl: TWinControl);
    procedure MarkAll;
    procedure Duplicate;
    procedure DoBeforePost(DataSet: TDataSet);   {Aufruf des BeforePost Ereignisses}
    procedure DoBeforeDelete(DataSet: TDataSet); {Aufruf des BeforeDelete Ereignisses}
    procedure DoAfterPost(NavLink: TNavLink);    {Aufruf des AfterPost Ereignisses}
    procedure DoNavLinkInit(Sender: TNavLink);   {Aufruf des NavLinkInit Ereignisses}
    procedure DoErrWarn(const Fmt: string; const Args: array of const; var Done: boolean);
    function ScreenToClient(const Point: TPoint): TPoint;
    procedure SetMaximizeBounds(var AWidth, AHeight: integer);
    property MarkAllMarked: boolean read FMarkAllMarked write SetMarkAllMarked; {Farbwechsel}
    property DB1: TuDataBase read GetDB1;         {1.Geladene DataBase}
    property QrForms[const FormKurz: string]: TQRepForm read GetQrForms; {Ergibt geˆffnetes TQrForm anhand FormKurz oder nil}
    property ClientWidth: integer read GetClientWidth;
    property ClientHeight: integer read GetClientHeight;
    property Canceled: boolean read GetCanceled write SetCanceled;
    property TableSynonym[ATblName: string]: string read GetTableSynonym write SetTableSynonym;
  published
    { Published-Deklarationen }
    { erstmal von DBNavigator }
    property QbeNavigator: TDBQBENav read X write X;
    property PanelSMess: TPanel read FPanelSMess write FPanelSMess;
    property PanelDMess: TPanel read FPanelDMess write FPanelDMess;
    property PanelHMess: TPanel read FPanelHMess write FPanelHMess;
    property PanelClient: TPanel read FPanelClient write FPanelClient;
    property BtnSort: TSpeedButton read FBtnSort write FBtnSort;
    property BtnDruck: TSpeedButton read FBtnDruck write FBtnDruck;
    property BtnEscape: TSpeedButton read FBtnEscape write FBtnEscape;
    property BtnSingle: TBtnPage read FBtnSingle write FBtnSingle;
    property BtnMulti: TBtnPage read FBtnMulti write FBtnMulti;
    property BtnSql: TSpeedButton read FBtnSql write FBtnSql;
    property BtnCalc: TCalcBtn read FBtnCalc write FBtnCalc;
    property MiCharCase: TMenuItem read FMiCharCase write FMiCharCase;
    property Gauge: TGauge read FGauge write FGauge;
    property LokalMuSi : boolean read FLokalMuSi write FLokalMuSi;
    property ColorEditWhite: TColor read FColorEditWhite write FColorEditWhite;
    property ColorEditGray: TColor read FColorEditGray write FColorEditGray;
    property ColorDetail: TColor read FColorDetail write FColorDetail;
    property ColorMarkAll: TColor read FColorMarkAll write FColorMarkAll;
    property ParamList: TValueList read FParamList write SetParamList;
    property TableSynonyms: TValueList read FTableSynonyms write SetTableSynonyms;
    property IDTables: TValueList read FIDTables write SetIDTables;
    property TablePKeys: TValueList read IndexInfos write SetTablePKeys;
    property FldDsWhereSql: TValueList read FFldDsWhereSql write SetFldDsWhereSql;
    property SysFields: TStringList read FSysFields write SetSysFields;
    property Bemerkung: TStringList read FBemerkung write SetBemerkung;
    property HtmlTable: TStringList read FHtmlTable write SetHtmlTable;
    property Version: string read FVersion write SetVersion;
    property MinSpaceLines: integer read FMinSpaceLines write FMinSpaceLines;
    property BeforePost: TDataSetNotifyEvent read FBeforePost write FBeforePost;
    property BeforeDelete: TDataSetNotifyEvent read FBeforeDelete write FBeforeDelete;
    property AfterPost: TNavLinkNotifyEvent read FAfterPost write FAfterPost;
    property OnNavLinkInit: TNotifyEvent read FOnNavLinkInit write FOnNavLinkInit;
    property OnHint: TNotifyEvent read FOnHint write FOnHint;
    property OnIdle: TIdleEvent read FOnIdle write FOnIdle;
    property OnControlChange: TNotifyEvent read FOnControlChange write FOnControlChange;
    property OnFormChange: TNotifyEvent read FOnFormChange write FOnFormChange;
    property OnErrWarn: TErrWarnEvent read FOnErrWarn write FOnErrWarn;
    property OnCheckLizenz: TErrWarnEvent read FOnCheckLizenz write FOnCheckLizenz;
    property OnDbCompare: TCompareEvent read FOnDbCompare write FOnDbCompare;
    property OnTranslateStr: TTranslateStrEvent read FOnTranslateStr write FOnTranslateStr;
    property OnLMess: TLMessEvent read FOnLMess write FOnLMess;
    property OnEndForm: TEndFormEvent read FOnEndForm write FOnEndForm;
    property OnUpdateFieldDefs: TUpdateFieldDefsEvent read FOnUpdateFieldDefs write FOnUpdateFieldDefs;
    property OnCheckVersion: TCheckVersionEvent read FOnCheckVersion write FOnCheckVersion;
  end;

const
  DfltSysFields: array[1..9] of string = ('ERFASST_VON', 'ERFASST_AM',
    'GEAENDERT_VON', 'GEAENDERT_AM', 'ANZAHL_AENDERUNGEN', 'ID',  //'BEMERKUNG', 02.06.03
    'ERFASST_DATENBANK', 'GEAENDERT_DATENBANK', 'REPLIKATION');
const
  STableSynonyms = 'TableSynonyms';

var
  GNavigator: TGNavigator;

implementation
{$R+}
uses
  Mask, Grids, DBGrids, ClipBrd, TabNotBk, comctrls,
  Qrctrls, QuickRpt, QRPrntr, QrPreDlg, Tabs,
  Prots, Sort_Dlg, Err__Kmp, Sql__Dlg, {Prn__Dlg, LuGriDlg,} MuGriKmp, Datn_Kmp,
  Poll_Kmp, CPro_Kmp, Str__Dlg, PSrc_Kmp, Ausw_Kmp, Ini__Kmp, IniDbKmp,
  Asws_Kmp, TGridKmp, HtmlClp, WinTools,
  FldDeDlg, DdeSiDlg, MakroDlg, Konv_Dlg, PropsDlg, AbortDlg, KmpResString,
  ReplaceDlg, QDBCtrlGrid,
  CollapsePanel,
  USes_Kmp;


{ TqFormObj }

constructor TqFormObj.Create;
begin
  WindowState := wsNormal;
end;

{ TGNavigator }

procedure TGNavigator.SetMarkAllMarked(Value: boolean);
begin
  if FMarkAllMarked <> Value then
  begin
    FMarkAllMarked := Value;
    if LNavigator <> nil then
      (LNavigator.Owner as TqForm).CheckReadOnly;
  end;
end;

function TGNavigator.GetDB1: TuDataBase;
var
  I: integer;
begin
  if USession.DataBaseCount > 0 then
  begin
    for I := 0 to USession.DataBaseCount - 1 do
      if USession.DataBases[I].DatabaseName = 'DB1' then
      begin
        result := USession.DataBases[I];
        exit;
      end;
    result := USession.DataBases[0];
  end else
    result := nil;
end;

function TGNavigator.SetDuplDB(aUDataset: IUDataset; aDB: TuDataBase; aIndex: integer): boolean;
// setzt DuplDb1 nach aQuery. Ergibt true wenn durchgfef¸hrt (aktiv usw)
// geht auch mit StoredProc
var
  aDuplDb: TuDataBase;
begin
  Result := false;
  aDuplDb := GetDuplDB(aDB, aIndex);
  if aDuplDb <> DB1 then
  begin
    Prot0_D('DUPLDB %d %s', [aUDataset.GetTag, OwnerDotName(aUDataset.GetComponent)]);
    Result := true;
  end;
  aUDataset.SetSessionName(aDuplDb.SessionName);
  aUDataset.SetDatabaseName(aDuplDb.DatabaseName);
end;

function TGNavigator.GetDuplDB(aDB: TuDataBase; aIndex: integer): TuDataBase;
//Ergibt Duplicat der Database[aDB]
//Anwendung: AQuery.DatabaseName := GNavigator.GetDuplDB(QueryDatabase(MyQuery)).DatabaseName;
//Wichtig f¸r selbst zusammengebaute Query die paralell zur Hauptquery ausgef¸hrt wird,
//  also IniDb und RecordCount
{ Liste verwalten und nicht nur DB1 }
(* Index  Verwendung
   0      Lookupdefs Standard (siehe webab.para.onformcreate
   1      lange Lookup-Queries (Tag=1)
   2      lange Hauptqueries ?
   3      lange Hauptqueries (ARTI.Query1.Tag=3)
   4      IniDb, RecordCount, sql_dlg
*)
begin
  if not SysParam.UseDuplDb or not (aIndex in [0..DuplDbCount-1]) or
     ((aDB <> DB1) and (aDB <> FDuplDb1[0]) and (aDB <> FDuplDb1[1]) and
      (aDB <> FDuplDb1[2]) and (aDB <> FDuplDb1[3]) and (aDB <> FDuplDb1[4])) then
  begin
    Result := aDB;
    Exit;
  end;
  if FDuplDb1[aIndex] = nil then
  try
    Prot0('GetDuplDB1[%d]', [aIndex]);
    FDuplDb1[aIndex] := TuDatabase.Create(Owner);
    FDuplDb1[aIndex].Name := Format('DuplDb1_%d', [aIndex]);
    FDuplDb1[aIndex].LoginPrompt := true;  {mit login Ereignis}
    FDuplDb1[aIndex].OnLogin := FDuplDb1Login;

    FDuplDb1[aIndex].DatabaseName := aDB.DatabaseName + '_DUPL' + IntToStr(aIndex);
    FDuplDb1[aIndex].SessionName := aDB.SessionName;
    FDuplDb1[aIndex].AliasName := aDB.AliasName;
    FDuplDb1[aIndex].Params.Assign(aDB.Params);
    if aDB is TuDatabase then
      FDuplDb1[aIndex].TblPrefix := TuDatabase(aDB).TblPrefix;
    FDuplDb1[aIndex].TransIsolation := aDB.TransIsolation;

    FDuplDb1[aIndex].Open;
  except on E:Exception do
    EProt(self, E, 'Error at GetDuplDB1[%d]', [aIndex]);
  end;
  result := FDuplDb1[aIndex];
end;

procedure TGNavigator.FDuplDb1Login(Database: TuDataBase; LoginParams: TStrings);
// f¸r GetDuplDB1
begin
  LoginParams.Assign(SysParam.Db1Params);
end;


procedure TGNavigator.SetMaximizeBounds(var AWidth, AHeight: integer);
begin  // (m¸sste eigentlich GetMaximizeBounds heiﬂen)
  AWidth := ClientWidth;
  AHeight := ClientHeight;
(* in TqForm.SetMaximized behandeln:
  if MinSpaceLines <> 0 then       {Zeile(n) f¸r Min.Fenster reservieren}
  begin
    //AHeight := AHeight - GetSystemMetrics(SM_CYMINSPACING) * MinSpaceLines;  W2K
    AHeight := AHeight - GetSystemMetrics(SM_CYMINIMIZED) * MinSpaceLines;  //XP
  end;
*)
end;

function TGNavigator.GetClientWidth: integer;
var
  Re: TRect;
begin
  (* f¸hrt zu Flimmern unter XP - 23.12.08
  if PanelClient <> nil then                  {f¸r NT 4.0 Bug -> SDO.FrmMain}
  begin
    PanelClient.Visible := true;
    if PanelClient.Align <> alClient then
      PanelClient.Align := alClient;
    result := PanelClient.Width;
    if PanelClient.Visible <> false then
      PanelClient.Visible := false;
  end else
  *)
  if Application.MainForm.FormStyle = fsMDIForm then
  begin
    GetWindowRect(Application.MainForm.ClientHandle, Re);
    result := Re.Right - Re.Left;
  end else
    result := Application.MainForm.ClientWidth;
  result := result - GetSystemMetrics(SM_CYFRAME);   {W2K: 4}
end;

function TGNavigator.GetClientHeight: integer;
var
  Re: TRect;
begin
  (* f¸hrt zu Flimmern unter XP - 23.12.08
  if PanelClient <> nil then                  {f¸r NT 4.0 Bug -> SDO.FrmMain}
  begin
    PanelClient.Visible := true;
    PanelClient.Align := alClient;
    result := PanelClient.Height;
    PanelClient.Visible := false;
  end else
  *)
  if Application.MainForm.FormStyle = fsMDIForm then
  begin
    //GetClientRect(Application.MainForm.ClientHandle, Re); bringt nix
    GetWindowRect(Application.MainForm.ClientHandle, Re);
    result := Re.Bottom - Re.Top;
  end else
    result := Application.MainForm.ClientHeight;
  result := result - GetSystemMetrics(SM_CXFRAME);   {W2K: 4}
end;

function TGNavigator.ScreenToClient(const Point: TPoint): TPoint;
//‹bersetzt Screenkoordinaten in Clientbereich
var
  Re: TRect;
begin
  (* f¸hrt zu Flimmern unter XP - 23.12.08
  if PanelClient <> nil then                  {f¸r NT 4.0 Bug -> SDO.FrmMain}
  begin
    result := PanelClient.ScreenToClient(Point);
  end else
  *)
  if Application.MainForm.FormStyle = fsMDIForm then
  begin
    GetWindowRect(Application.MainForm.ClientHandle, Re);
    result.X := Point.X - Re.Left;
    result.Y := Point.Y - Re.Top;
  end else
    result := Application.MainForm.ScreenToClient(Point);
end;

function TGNavigator.GetCanceled: boolean;
begin
  try
    ProcessMessages;
  except on E:Exception do
    EProt(self, E, 'GetCanceled', [0]);
  end;
  result := fCanceled;
end;

procedure TGNavigator.SetCanceled(const Value: boolean);
var
  Changed: boolean;
begin
  Changed := fCanceled <> Value;
  fCanceled := Value;
  if Value then
    TDlgAbort.Cancel(self);
  if Changed and not Value and (QbeNavigator <> nil) then
    QbeNavigator.EditingChanged;
end;

procedure TGNavigator.SetParamList(Value: TValueList);
begin
  FParamList.Assign(Value);
end;

procedure TGNavigator.SetTableSynonyms(Value: TValueList);
begin
  FTableSynonyms.Assign(Value);
end;

procedure TGNavigator.SetTablePKeys(const Value: TValueList);
begin
  IndexInfos.Assign(Value);
end;

procedure TGNavigator.SetFldDsWhereSql(Value: TValueList);
begin
  FFldDsWhereSql.Assign(Value);
end;

procedure TGNavigator.SetSysFields(Value: TStringList);
begin
  FSysFields.Assign(Value);
end;

procedure TGNavigator.SetBemerkung(Value: TStringList);
begin
  FBemerkung.Assign(Value);
end;

procedure TGNavigator.SetHtmlTable(Value: TStringList);
begin
  FHtmlTable.Assign(Value);
end;

procedure TGNavigator.SetIDTables(const Value: TValueList);
begin
  FIDTables.Assign(Value);
end;

procedure TGNavigator.SetVersion(Value: string);
begin
  FVersion := KmpVersion;
end;

constructor TGNavigator.Create(AOwner: TComponent);
var
  I: integer;
begin
  inherited Create(AOwner);
  if GNavigator = nil then
    GNavigator := self;
  FVersion := KmpVersion;
  LizenzDtWarn := 0; LizenzDtSperr := 0; LizenzWarnCount := 0; 
  TicksReset(CheckVersionStart);  //nicht gleich ¸berpr¸fen

  if not (csDesigning in ComponentState) then
  begin
    Screen.OnActiveFormChange := ActiveFormChange; {Globale Variable, Ereignis umbiegen}
    MarkAllMemo := TMemo.Create(AOwner);      {free autom. ¸ber G Nav}
    MarkAllMemo.Visible := false;
    MarkAllMemo.Parent := AOwner as TForm;
  end;
  FormList := TStringList.Create;
  QRepFormList := TStringList.Create;
  FParamList := TValueList.Create;
  FTableSynonyms := TValueList.Create;
  FIDTables := TValueList.Create;
  FFldDsWhereSql := TValueList.Create;
  FSysFields := TStringList.Create;
  for I := low(DfltSysFields) to high(DfltSysFields) do
    FSysFields.Add(DfltSysFields[I]);
  FBemerkung := TStringList.Create;
  FHtmlTable := TStringList.Create;
  IndexInfos := TValueList.Create;
  NoTranslateList := TStringList.Create;
    NoTranslateList.Sorted := true;
    NoTranslateList.Duplicates := dupIgnore; //keine doppelten 
  FColorEditWhite := clYellow;
  FColorEditGray := clYellow;
  FColorDetail := clLime;
  if not (csDesigning in ComponentState) then
  begin
    Application.OnHint := DoOnHint;
    Application.OnIdle := DoOnIdle;

    Screen.OnActiveControlChange := DoOnControlChange;
  end;
  // unit QRPrntr
  RegisterPreviewClass(TDlgQRPreviewInterface);  //25.04.12

  FHtmlTable.Add('[HdrTable]');
  FHtmlTable.Add('<TABLE BORDER=1>');
  FHtmlTable.Add('[HdrCaptions]');
  FHtmlTable.Add('<TR>');
  FHtmlTable.Add('[Captions]');
  FHtmlTable.Add('  <TD><b>%s</b></TD>');
  FHtmlTable.Add('[FtrCaptions]');
  FHtmlTable.Add('</TR>');
  FHtmlTable.Add('[HdrLine]');
  FHtmlTable.Add('<TR>');
  FHtmlTable.Add('[Line]');
  FHtmlTable.Add('  <TD>%s</TD>');
  FHtmlTable.Add('[FtrLine]');
  FHtmlTable.Add('</TR>');
  FHtmlTable.Add('[FtrTable]');
  FHtmlTable.Add('</TABLE>');
end;

destructor TGNavigator.Destroy;
var
  I: integer;
begin
  Application.OnHint := nil;
  Application.OnIdle := nil;
  Screen.OnActiveControlChange := nil;
  if GNavigator = self then
    GNavigator := nil;
  MarkAllMemo := nil;
  if FormList <> nil then
  begin
    for I := 0 to FormList.Count - 1 do
    try
      TqFormObj(FormList.Objects[I]).Free;
    except on E:Exception do
      Debug0;
    end;
    FormList.Free;
  end;
  if QRepFormList <> nil then
  begin
    for I := 0 to QRepFormList.Count - 1 do
    try
      TQRepFormObj(QRepFormList.Objects[I]).Free;
    except on E:Exception do
      Debug0;
    end;
    QRepFormList.Free;
  end;
  FreeAndNil(FParamList);
  FreeAndNil(FTableSynonyms);
  FreeAndNil(FIDTables);
  FreeAndNil(FFldDsWhereSql);
  FreeAndNil(FSysFields);
  FreeAndNil(FBemerkung);
  FreeAndNil(FHtmlTable);
  FreeAndNil(IndexInfos);
  FreeAndNil(NoTranslateList);
  //FreeAndNil(FDuplDb1);  hat bereits owner
  inherited Destroy;
end;

procedure TGNavigator.Loaded;
var
  I, P: integer;
  ALine: string;
begin
  if not (csDesigning in ComponentState) then
  begin
    {Umbiegen von Ereignissen:}
    if BtnSort <> nil then BtnSort.OnClick := BtnSortClick;
    if BtnDruck <> nil then BtnDruck.OnClick := BtnDruckClick;
    if BtnEscape <> nil then BtnEscape.OnClick := BtnEscapeClick;
    if BtnSql <> nil then BtnSql.OnClick := BtnSqlClick;
    if BtnSingle <> nil then BtnSingle.OnClick := BtnSingleClick;
    if BtnMulti <> nil then BtnMulti.OnClick := BtnMultiClick;
    if BtnCalc <> nil then BtnCalc.BeforeClick := BtnCalcClick;
    if MiCharCase <> nil then MiCharCase.OnClick := MiCharCaseClick;

    if BtnSort <> nil then BtnSort.Flat := true;
    if BtnDruck <> nil then BtnDruck.Flat := true;
    if BtnEscape <> nil then BtnEscape.Flat := true;
    if BtnSql <> nil then BtnSql.Flat := true;
    if BtnSingle <> nil then BtnSingle.Flat := true;
    if BtnMulti <> nil then BtnMulti.Flat := true;
    if BtnCalc <> nil then BtnCalc.Flat := true;
    SMess(SGNav_Kmp_001,[0]);		// 'Laden ...'
    GMess(0);
  end else
  begin
    SMess('SMess:csDesigning',[0]);
    DMess('DMess:csDesigning',[0]);
    HMess('HMess:csDesigning',[0]);
  end;
  { jetzt Properties 040699
  if PanelClient = nil then
  begin
    ClientWidth := Screen.Width;
    ClientHeight := Screen.Height;
  end else
  begin
    ClientWidth := PanelClient.Width;
    ClientHeight := PanelClient.Height;
  end; }
  if MarkAllMemo <> nil then
    MarkAllMemo.WordWrap := false;
  if not (csDesigning in ComponentState) then
  begin
    if IniKmp <> nil then
    begin
      IniKmp.ReadSectionValues('PARAMS', ParamList);
    end;
    for I:= 1 to ParamCount do
    begin
      ALine := ParamStr(I);
      P := Pos('=', ALine);
      if P <= 1 then
      begin
        if ParamList.IndexOf(ALine) < 0 then
          ParamList.Add(ALine);
      end else
        ParamList.Values[copy(ALine, 1, P-1)] := copy(ALine, P+1, length(ALine));
    end;
  end;
  if DB1 <> nil then
  begin
    DbInit;
  end;
  if not (csDesigning in ComponentState) then
  begin
    if (ParamList.Values['LoadFieldDesc'] = '1') then
      FldDeDlg.FieldDescLoadFromIni;                   {Feldbeschr. von INI laden}
    if (ParamList.Values['BatchMode'] = '1') then
      SysParam.BatchMode := true;                         {ohne Bedienereingaben}

    if FileExists(AppDir + 'HtmlTable.Ini') then
      FHtmlTable.LoadFromFile(AppDir + 'HtmlTable.Ini');

    if IniKmp <> nil then                                  {110101 BahnDispo}
      IniKmp.ReadSectionValues(STableSynonyms, TableSynonyms);

    //d14 AddForm('EXPORT', TDlgExport);                       {Exportformular anmelden}
  end;
end;

procedure TGNavigator.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if (AComponent = BtnDruck) then
      BtnDruck := nil else
    if (AComponent = BtnEscape) then
      BtnEscape := nil else
    if (AComponent = BtnMulti) then
      BtnMulti := nil else
    if (AComponent = BtnSingle) then
      BtnSingle:= nil else
    if (AComponent = BtnSort) then
      BtnSort := nil else
    if (AComponent = BtnSql) then
      BtnSql := nil else
    if (AComponent = BtnCalc) then
      BtnCalc := nil else
    if (AComponent = Gauge) then
      Gauge := nil else
    if (AComponent = PanelClient) then
      PanelClient := nil else
    if (AComponent = PanelDMess) then
      PanelDMess := nil else
    if (AComponent = PanelHMess) then
      PanelHMess := nil else
    if (AComponent = PanelSMess) then
      PanelSMess := nil else
    if (AComponent = QbeNavigator) then
      QbeNavigator := nil else
    if (AComponent = MarkAllMemo) then
      MarkAllMemo := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TGNavigator.Close;
begin
  if not (csDesigning in ComponentState) then
  begin
    Prot0(SGNav_Kmp_002,[Application.ExeName]);		// 'Ende(%s)'
    if (ParamList.Values['LoadFieldDesc'] = '1') then   {vergl. loaded}
      FldDeDlg.FieldDescSaveToIni;          {Feldbeschr. nach INI speichern}
  end;
end;

procedure TGNavigator.DbInit;
var
  AQuery: TuQuery;
  AType: string;
  I: integer;
  S1, S2: string;
  Par, Val: string;
begin
  AQuery := nil;
  if not (csDesigning in ComponentState) and not SysParam.NoDB and
     SysParam.Oracle and (SysParam.SessionId = 0) and (DB1 <> nil) and
     DB1.Connected then
  try
    AQuery := TuQuery.Create(DB1);
    try       {USession ID}
      AQuery.Sql.Text := 'select USERENV(''SESSIONID'') from DUAL';
      AQuery.Open;
      SysParam.SessionId := AQuery.Fields[0].AsFloat;
    except on E:Exception do
      begin
        ProtL('GetSessionId:%s',[E.Message]);
        SysParam.SessionId := -1;
      end;
    end;
    AQuery.Close;
    //ab 24.03.12 in TuDataBase.DoConnect;
//    try    // Y2000 Format in USession bekanntgeben:
//      SysParam.DbSqlDatum := '''DD.MM.YYYY''';
//      AQuery.Sql.Text := Format('ALTER SESSION SET NLS_DATE_FORMAT = %s', [
//                                 StrDflt(SysParam.DbSqlDatum, SysUtils.ShortDateFormat)]);
//      QueryExecCommitted(AQuery);
//
//      //Test Multibyte
//      //AQuery.Sql.Text := Format('ALTER SESSION SET NLS_CHARACTERSET = %s', ['UTF8']); AQuery.//ExecSql;
//      //AQuery.Sql.Text := Format('ALTER SESSION SET NLS_LENGTH_SEMANTICS = %s', ['BYTE']); AQuery.//ExecSql;
//
//      // Test Berechtigungen f¸r Metadaten: weg wg UniDAC
//    except on E:Exception do
//      begin  //mit Messagebox ab 22.11.06
//        ProtM('Fehler bei "%s"'+CRLF+'%s',[Trim(RemoveCRLF(AQuery.Sql.Text)), E.Message]);
//        SysParam.SessionId := -1;
//      end;
//    end;
  finally
    AQuery.Free;
  end;

  //Designtime BDE Parameter anhand GNav.Bemerkung setzen,
  //z.B. DB1.USER NAME=myuser
  //vergl. TuDatabase.Loaded;
  if (csDesigning in ComponentState) and (DB1 <> nil) and not Db1DesignParamsSet then
  begin
    Db1DesignParamsSet := true;  //nur einmal durchlaufen
    try // vergl. UDB.Loaded
      for I := 0 to Bemerkung.Count - 1 do
      begin
        S1 := Bemerkung[I]; // DB1.SERVER NAME=myserver
        if BeginsWith(S1, DB1.DatabaseName + '.', true) then
        begin // SERVER NAME, ALIAS, ...
          S2 := Copy(S1, Length(DB1.DatabaseName) + 2, MaxInt);
          Par := StrParam(S2);
          Val := StrValue(S2);
          if Pos('=', S2) > 0 then  // SERVER NAME=myserver
          begin
            if SameText(Par, 'Alias') then
            begin
              if DB1.Aliasname <> Val then
                DB1.Aliasname := Val;
            end else
            if DB1.Params.Values[Par] <> Val then
              DB1.Params.Values[Par] := Val;
          end;
        end;
      end;
    except on E:Exception do
      ProtL('Fehler bei Db1DesignParamsSet: %s', [E.Message]);
    end;
    {S1 := Bemerkung.Values['USER NAME'];
    if S1 <> '' then
      DB1.Params.Values['USER NAME'] := S1;
    S1 := Bemerkung.Values['PASSWORD'];
    if S1 <> '' then
      DB1.Params.Values['PASSWORD'] := S1; }
  end;

  //Verzeichnis weg f¸r private BDE wg uniDAC
  IniKmp.SectionTyp['Session'] := stMaschine;

  if not (csDesigning in ComponentState) and (DB1 <> nil) and
     DB1.Connected then
  begin
    AType := DB1.ProviderName;  //GetDataBaseType(DB1);
    if AType <> '' then
    begin
(* Stand 13.06.11
  UniProviders.RegisterProviderDesc('Access', 'Access', 'accessprovider', 'Devart.UniDac.Access', '');
  UniProviders.RegisterProviderDesc('Advantage', 'Advantage', 'adsprovider', 'Devart.UniDac.Advantage', '');
  UniProviders.RegisterProviderDesc('ASE', 'ASE', 'aseprovider', 'Devart.UniDac.ASE', '');
  UniProviders.RegisterProviderDesc('DB2', 'DB2', 'db2provider', 'Devart.UniDac.DB2', '');
  UniProviders.RegisterProviderDesc('DBF', 'DBF', 'dbfprovider', 'Devart.UniDac.DBF', '');
  UniProviders.RegisterProviderDesc('InterBase', 'InterBase', 'ibprovider', 'Devart.UniDac.InterBase', 'IBDAC');
  UniProviders.RegisterProviderDesc('MySQL', 'MySQL', 'myprovider', 'Devart.UniDac.MySQL', 'MyDAC');
  UniProviders.RegisterProviderDesc('NexusDB', 'NexusDB', 'nexusprovider', 'Devart.UniDac.NexusDB', '');
  UniProviders.RegisterProviderDesc('ODBC', 'ODBC', 'odbcprovider', 'Devart.UniDac.ODBC', '');
  UniProviders.RegisterProviderDesc('Oracle', 'Oracle', 'oraprovider', 'Devart.UniDac.Oracle', 'ODAC');
  UniProviders.RegisterProviderDesc('PostgreSQL', 'PostgreSQL', 'pgprovider', 'Devart.UniDac.PostgreSQL', 'PgDAC');
  UniProviders.RegisterProviderDesc('SQL Server', 'SQLServer', 'msprovider', 'Devart.UniDac.SQLServer', 'SDAC');
  UniProviders.RegisterProviderDesc('SQLite', 'SQLite', 'liteprovider', 'Devart.UniDac.SQLite', '');
*)
      SysParam.Oracle := CompareText(AType, 'Oracle') = 0;
      SysParam.Informix := CompareText(AType, 'INFORMIX') = 0;
      SysParam.InterBase := CompareText(AType, 'InterBase') = 0;
      SysParam.MSSQL := CompareText(AType, 'SQL Server') = 0;
      SysParam.Access := CompareText(AType, 'Access') = 0;
      SysParam.Paradox := CompareText(AType, 'STANDARD') = 0;  //Paradox als ODBC
      SysParam.Standard := CompareText(AType, 'DBF') = 0;  //Standard = dBase
      SysParam.Odbc := CompareText(AType, 'ODBC') = 0;
      SysParam.SqlIsCaseSensitiv := not SysParam.Access and         {bei Access ausschalten}
                                    not SysParam.MSSQL;

    end;
  end;
end;

procedure TGNavigator.DoOnIdle(Sender: TObject; var Done: Boolean);
var
  S: string;
  P: TPoint;
  FileDT: TDateTime;
begin
  try
    { Programmstart Meldung }
    if not ProtStart and (Prot <> nil) then
    try
      ProtStart := true;
      FileAge(Application.ExeName, FileDT);
      Prot0('Start(%s) Version(%s) Build(%s)',[Application.ExeName, AppVersion, DateTimeToStr(FileDT)]);
      ProtStrings(ParamList);  //ab 15.06.10
      ProtA('Logfile=%s', [Prot.FilePath]);
      if Datn <> nil then
        ProtA('Datn.BaseDir=%s', [Datn.BaseDir]);
      if GNavigator.X <> nil then  //29.01.13
        PostMessage(GNavigator.X.Handle, BC_INIDB, WPARAM(idProt), 0);  //27.01.13 - falls bei Logon bei IniDb was schief ging
    except on E:Exception do
      EProt(Sender, E, 'Start(%s)', [Application.ExeName]);
    end;
    { Oracle Initialisierung }
    DbInit;

    {Fenstergrˆﬂen der MDIChilds anpassen}
    if CheckBoundsFlag or
       ((Application.MainForm is TqForm) and TqForm(Application.MainForm).ScrollBarsVisible) then
    begin
      CheckBoundsFlag := false;
      TqForm.CheckBounds;
    end;

    { Poll Idle Bedienung }
    if PollKmp <> nil then
      PollKmp.DoIdle;

    { Anwendungs Ereignis, HMess }
    if Assigned(FOnIdle) then
    begin
      FOnIdle(Sender, Done);
    end else
    begin
      S := FormatDateTime('hh:nn:ss', Now);
      if IdleTime <> S then
      begin
        IdleTime := S;
        HMess('  %s  %s', [SysParam.UserName, S]);
      end;
    end;

    { UserActionTime }
    GetCursorPos(P);
    if (IdleX <> P.X) or (IdleY <> P.Y) then
    begin
      IdleX := P.X;
      IdleY := P.Y;
      TicksReset(UserActionTime);
    end;

    { DMessT1 Timer }
    if (DMessTimer <> 0) and (TicksDelayed(DMessTimer) > 5000) then
    begin
      DMessTimer := 0;
      DMessText := '';
    end;
    { Auswahlmaske ist modal und darf nicht verschwinden }
    TDlgStrings.CheckOnTop;

    { Drag & Drop Unterst¸tzung f¸r MultiGrid }
    if (DragCount > 0) and (Screen.ActiveForm is TqForm) then
    begin
      TqForm(Screen.ActiveForm).BroadcastMessage(self, TMultiGrid, BC_MULTIGRID, mgDragPoll);
    end;

    { Lebenszeichen }
    //19.06.12 aufruf in PollKmp -
    if PollKmp = nil then
      SendAlive(SysParam.AliveTime);

  except on E:Exception do
    EProt(Application, E, 'GNav.DoOnIdle', [0]);
  end;
end;

procedure TGNavigator.SendAlive(aAliveTime: integer);
// sendet Alive-Meldung nach SysParam.AliveFile.
// Automatisch in Idle wenn SysParam.AliveTime > 0
// Um den Aufruf in der Anwendung zu verwalten ist SysParam.AliveTime=0 zu setzen
//    und die AliveTime in der Anwendung in einer anderen variablen zu speichern
//19.06.12 Aufruf in PollKmp
var
  S: string;
begin
  //warum? 19.06.12 Processmessages;  //05.04.10
  if aAliveTime > 0 then
  begin
    if TicksCheck(LastAliveTime, aAliveTime) then
    try
      S := Prot.FileName;
      if (SysParam.AliveFile <> '') and (SysParam.AliveFile <> Prot.FileName) then
      begin
        Prot.FileName := SysParam.AliveFile;
        Prot.LoeschFlag := true;  {File vorher lˆschen}
      end;
      //Prot0('%s', [HMessText]);   {User, Timer usw.} weg 02.06.03
      //Prot.X([prFile,prTimeStamp], '%s', [HMessText]); //User, Timer usw. Nicht in Listbox
      Prot.X([prFile], 'MSG=%s', [HMessText]); //Starter ready
      Prot.X([prFile], 'RECORDCOUNT=%d', [SysParam.RecordCount]); //Anzahl verarbeitete Datens‰tze
    finally
      Prot.FileName := S;
    end;
  end;
end;

procedure TGNavigator.DoOnHint(Sender: TObject);
begin
  //if FPanelSMess <> nil then   (OnLMess)
    SMess('%s', [RemoveCRLF(GetLongHint(Application.Hint))]);
    {FPanelSMess.Caption := Application.Hint;}
  if Assigned(FOnHint) then
    FOnHint(Sender);
end;

procedure TGNavigator.DoOnControlChange(Sender: TObject);
{Fokus‰nderung des Steuerelements}
var
  S1: string;
begin
  MarkAllMarked := false;
  MiCharCaseCaption(Screen.ActiveControl);
  if Screen.ActiveControl <> nil then    // Hint auch bei tastaturnavi zeigen
  begin
    S1 := Screen.ActiveControl.Hint;
    //if S1 <> '' then
      SMess('%s', [S1]);
    if CompareText(Screen.ActiveControl.Name, SysParam.OurLookUpEdit) = 0 then
      Debug0;  //edGUELTIG_AB
  end;
  if Assigned(FOnControlChange) then
    FOnControlChange(Sender);
  if ProtControlChange then
    Prot0('ControlChange: %s', [OwnerDotName(Screen.ActiveControl)]);
end;

(*** Formularverwaltung ******************************************************)

procedure TGNavigator.SetLink(AForm: TForm; ANavLink: TNavLink;
  ADataSource: TDataSource);
begin
  if QbeNavigator <> nil then
  begin
    QbeNavigator.NavLink := ANavLink;              {Speichern des LNav auf X.NavLink}
    QbeNavigator.DataSource := ADataSource;        {der von DBNavigator }
  end;
  if AForm is TqForm then
    TqForm(AForm).BroadcastMessage(ADataSource, TMultiGrid, BC_MULTIGRID, mgCheckColor);
  PostMessage(AForm.Handle, BC_LNAVIGATOR, lnavSetTitel, 0);
end;

procedure TGNavigator.ActiveFormChange(Sender: TObject);
{Fokus‰nderung des Formulars}
var
  Status: string;
  AForm: TForm;
  LinkSet: boolean;
begin
  if not (csDesigning in ComponentState) then
  begin
    {if PreviewForm <> nil then
    begin
      AForm := PreviewForm;
      PreviewForm := nil;
    end else}
      AForm := Screen.ActiveForm;
    if (Aktiv1 = false) and (AForm <> nil)   {Aktiv1 Semaphore f¸r einmalige Ausf¸hrung}
       and (AForm <> Owner) then           {nicht die MainForm (qugl.main.cobgueltig)}
    try
      Aktiv1 := true;
      Status := ShortCaption(AForm.Caption);
      {SMess('(%s)',[Status]);}
      if AForm is TqForm then             {Zuordnung vom lokalen Navigator LNav}
        LNavigator := TqForm(AForm).LNavigator else
      if AForm is TQRepForm then
        LNavigator := TQRepForm(AForm).LNavigator else
        LNavigator := nil;
      if LNavigator <> nil then
      begin
        LinkSet := false;
        if not (AForm is TQRepForm) then
        begin
          {PostMessage(AForm.Handle, BC_SETTITEL, 0, 0);         {LNav.SetTitel;}
                                         {Titel aufbauen anhand Datenbankstatus}
          LNavigator.SetTabIndex(-1);                        {Tabs deaktivieren}
          if LNavigator.PageBook is TNoteBook then           {Zuweisung des richtigen NoteBooks}
          begin
            if BtnSingle <> nil then BtnSingle.SetNoteBook(TNoteBook(LNavigator.PageBook));
            if BtnMulti <> nil then BtnMulti.SetNoteBook(TNoteBook(LNavigator.PageBook));
          end else
          if LNavigator.PageBook is TPageControl then        {Zuweisung der richtigen Seite}
          begin
            if BtnSingle <> nil then BtnSingle.Down := LNavigator.PageIndex < 10;
            if BtnMulti <> nil then BtnMulti.Down := LNavigator.PageIndex >= 10;
          end else
          begin
            if BtnSingle <> nil then BtnSingle.SetNoteBook(nil);
            if BtnMulti <> nil then BtnMulti.SetNoteBook(nil);
          end;
          try
            AForm.SetFocus;                  {Fokusieren des aktiven Steuerelements}
          except on E:Exception do
            //EProt(self
          end;
          if (AForm.ActiveControl <> nil) then
          begin
            if (AForm.ActiveControl is TCustomMaskEdit) then
              TCustomMaskEdit(AForm.ActiveControl).SelectAll; {beim Edit Inhalt markieren}
            if (AForm.ActiveControl is TMultiGrid) then
            begin                                    {true=SetLink durchgef¸hrt}
              LinkSet := TMultiGrid(AForm.ActiveControl).CheckFocus;
            end else
            if (AForm.ActiveControl is TQDBCtrlGrid) then
            begin                                    {true=SetLink durchgef¸hrt}
              LinkSet := TQDBCtrlGrid(AForm.ActiveControl).CheckFocus;
            end;
          end;
        end;
        if not LinkSet then
          SetLink(AForm, LNavigator.NavLink, LNavigator.NavLink.ActiveSource); {Q}
      end else {LNav = nil}
      begin
        if X <> nil then
        begin
          X.NavLink := X.NavLinkStart;                          {Dummy-Variable}
          X.DataSource := nil;
        end;
      end;
      if Assigned(FOnFormChange) then
        FOnFormChange(self);
    finally
      Aktiv1 := false;
    end;
  end;
end;

function TGNavigator.GetQRepForm(Kurz: string): TQRepForm;
var
  FormObj : TQRepFormObj;
begin
  result := nil;
  FormObj := GetQRepFormObj(Kurz);
  if (FormObj <> nil) and (FormObj.Form <> nil) then
    result := FormObj.Form;
end;

function TGNavigator.GetQRepFormObj(Kurz: string): TQRepFormObj;
var
  I: Integer;
begin
  I := QRepFormList.IndexOf(UpperCase(Kurz));
  if I >= 0 then
  begin
    result := QRepFormList.Objects[I] as TQRepFormObj;
    if result = nil then
      Prot0('GetQRepFormObj(%s):Objekt fehlt', [Kurz]);
  end else
    result := nil;
end;

function TGNavigator.GetQrForms(const FormKurz: string): TQRepForm;
var
  FormObj : TQRepFormObj;
begin
  result := nil;
  FormObj := GetQRepFormObj(FormKurz);
  if FormObj <> nil then
    result := FormObj.Form;
end;

procedure TGNavigator.AddQRepForm(Kurz: string; FormRef: TQRepFormRef);
var
  FormObj : TQRepFormObj;
begin
  FormObj := GetQRepFormObj(Kurz);
  if FormObj <> nil then
    ErrWarn(SGNav_Kmp_003, [Kurz]) else		// 'AddQRepForm(%s): bereits vorhanden'
  begin
    FormObj := TQRepFormObj.Create;
    FormObj.FormRef := FormRef;
    QRepFormList.AddObject(UpperCase(Kurz), FormObj);
  end;
end;

function TGNavigator.GetPrnSource(Kurz: string): TComponent;
var
  FormObj: TQRepFormObj;
begin
  result := nil;
  FormObj := GetQRepFormObj(Kurz);
  if FormObj <> nil then
    result := FormObj.PrnSource;
end;

function TGNavigator.StartQRepForm(APrnSource: TComponent; Kurz: string): TQRepForm;
var
  FormObj: TQRepFormObj;
  I: integer;
begin
  result := nil;
  try
    FormObj := GetQRepFormObj(Kurz);
    if FormObj <> nil then
    begin
      if FormObj.Form = nil then
      begin
        if FormObj.Locked then
          ProtL(SGNav_Kmp_004,[Kurz]) else		// 'Report(%s) gesperrt'
        try
          FormObj.Locked := true;         {sperren w‰hrend Form.Create}
          Screen.Cursor := crHourGlass;   {TForm(AOwner)}
          ComWait;     {Warten bis serielle Kommunikation sicher}
          CreateKurz := Kurz;
          FormObj.PrnSource := APrnSource;   {Create sieht AOwner. F¸r Dpe.DfltRep}
          FormObj.Form := FormObj.FormRef.Create(Application.MainForm);
          FormObj.Form.Caller := APrnSource;
          FormObj.Form.QRepKurz := Kurz;
          Screen.Cursor := crDefault;
        finally
          FormObj.Locked := false;
          CreateKurz := '';
        end;
        result := FormObj.Form;
      end;
    end else
    begin
      ErrWarn(SGNav_Kmp_005, [Kurz]);		// 'StartQRepForm:(%s) fehlt'
      for I := 0 to QRepFormList.Count - 1 do
        ProtA('%s', [QRepFormList[I]]);
    end;
  except
    on E:Exception do ErrException(self, E);
  end;
end;

procedure TGNavigator.EndQRepForm(AOwner: TComponent; Kurz: string);
var
  FormObj: TQRepFormObj;
begin
  FormObj := GetQRepFormObj(Kurz);
  if FormObj <> nil then
  begin
    if FormObj.Form <> nil then
    begin
      FormObj.Form := nil;
    end else
      ProtA(SGNav_Kmp_006, [Kurz]);		// 'EndQRepForm:(%s) bereits Ende'
  end;
end;

function TGNavigator.GetFormObj(Kurz: string; RechteTest: boolean;
  DisplayErrorMessage: boolean = true): TqFormObj;
{Sucht nach einer Datenstruktur zur 'Kurz', mit Rechte-Check}
var
  I: Integer;
  FormName: string;
begin
  MaskenRecht := true;
  (*if (LizenzDtWarn > 0) and (Now > LizenzDtWarn) then
  begin
    //'Fehler bei Aufruf (%s)'
    //ErrWarn(SGNav_Kmp_033, [DateToStr(LizenzDtWarn) + ',' + DateToStr(LizenzDtWarn)]);
    Inc(LizenzWarnCount);
    if (LizenzDtSperr > 0) and (Now > LizenzDtSperr) or (LizenzWarnCount < 3) then
      Exit;
  end;*)
  I := FormList.IndexOf(UpperCase(StrDflt(Kurz, '-'))); {Index holen}
  if I >= 0 then
  begin
    Result := FormList.Objects[I] as TqFormObj;
    {if RechteTest and (Uppercase(copy(Kurz, 1, 6)) <> 'LOOKUP') then}
    {LOOKUP1.. und FrmQuer1..   QUERY 160997}
    if RechteTest then
    begin
      if (KmpRechte <> nil) and not Result.NoRechteCheck then
      begin
        {FormName := copy(ClassName, 2, length(ClassName)-1);}
        FormName := Format('FRM%s', [Uppercase(Kurz)]);
        KmpRechte.GetMaske(FormName, MaskenRecht, result.TabellenRechte);
        {Maskenrechte holen von KmpRechte}
        if not MaskenRecht then {kein Recht zum starten}
        begin
          if DisplayErrorMessage then
            ErrWarn(SGNav_Kmp_007, [FormName]);		// 'Sie haben keine Rechte f¸r diese Maske (%s)'
          {raise Exception.CreateFmt('nein Sie haben keine Rechte f¸r diese Maske (%s)',
            [FormName]);}
          result := nil;
        end;
      end else
        Result.TabellenRechte := [reUpdate, reInsert, reDelete, reDisplayed, reEnabled];
      if (GNavigator.DB1 <> nil) and GNavigator.DB1.ReadOnly then
        Result.TabellenRechte := [reDisplayed, reEnabled];
    end;
  end else
    Result := nil;
end;

function TGNavigator.AddTempForm(Kurz: string; FormRef: TqFormRef): TqFormObj;
{Tempor‰res Formular (ohne RechteCheck) anmelden}
var
  FormObj: TqFormObj;
begin
  FormObj := GetFormObj(Kurz, false);
  if FormObj = nil then              //Fehlermeldung 'bereits vorhanden' unterdr¸cken
    FormObj := AddForm(Kurz, FormRef);
  //FormObj := GetFormObj(Kurz, false);
  FormObj.IsTemp := true;
  FormObj.NoRechteCheck := true;
  result := FormObj;
end;

function TGNavigator.AddSysForm(Kurz: string; FormRef: TqFormRef): TqFormObj;
{System Formular (ohne RechteCheck) anmelden}
var
  FormObj: TqFormObj;
begin
  FormObj := AddForm(Kurz, FormRef);
  //FormObj := GetFormObj(Kurz, false);
  FormObj.NoRechteCheck := true;
  result := FormObj;
end;

function TGNavigator.AddForm(Kurz: string; FormRef: TqFormRef): TqFormObj;
{Name und Classe (Typ) anmelden}
var
  FormObj: TqFormObj;
begin
  FormObj := GetFormObj(Kurz, false);
  if FormObj <> nil then
  begin
    Prot0(SGNav_Kmp_008, [Kurz])		// 'AddForm(%s): bereits vorhanden'
  end else
  begin
    FormObj := TqFormObj.Create;
    FormObj.FormRef := FormRef;
    FormList.AddObject(UpperCase(Kurz), FormObj);
  end;
  result := FormObj;
end;

procedure TGNavigator.SetForm(Kurz: string; AForm: TqForm);
(* Form ohne Start/LookUpForm anmelden. F¸r Para *)
// mit Tabellenrechte
var
  FormObj: TqFormObj;
  ALNav: TLNavigator;
begin
  FormObj := GetFormObj(Kurz, true, false);  //mit Rechtecheck - 21.01.05 qsbt#datafrm
  if (FormObj <> nil) and (FormObj.Form = nil) then
  begin
    FormObj.Form := AForm;
    AForm.Kurz := Kurz;
    if AForm <> nil then
    begin
      ALNav := FormGetLNav(AForm);
      if ALNav <> nil then
        ALNav.NavLink.TabellenRechte := FormObj.TabellenRechte; {Rechte kopieren auf den LNav}
    end;
  end;
end;

function TGNavigator.GetForm(Kurz: string): TqForm;
var
  FormObj : TqFormObj;
begin
  result := nil;
  FormObj := GetFormObj(Kurz, false, false);
  if (FormObj <> nil) and (FormObj.Form <> nil) then
    result := FormObj.Form;
end;

procedure TGNavigator.SetFormData(Kurz: string; Data: Pointer);
(* Zusatzdaten f¸r LNav.InitData anmelden *)
var
  FormObj: TqFormObj;
begin
  FormObj := GetFormObj(Kurz, false);
  if FormObj <> nil then
      FormObj.Data := Data;
end;

function TGNavigator.GetFormData(Kurz: string): Pointer;
// f¸r qForm.InitData
var
  FormObj : TqFormObj;
begin
  result := nil;
  FormObj := GetFormObj(Kurz, false);
  if FormObj <> nil then
    result := FormObj.Data;
end;

function TGNavigator.GetFormValue(Kurz, ParamName: string): string;
// f¸r Kommunikation zwischen Forms
var
  FormObj : TqFormObj;
begin
  result := '';
  FormObj := GetFormObj(Kurz, false);
  if (FormObj <> nil) and (FormObj.Form <> nil) and (FormGetLNav(FormObj.Form) <> nil) then
  begin
    result := FormGetLNav(FormObj.Form).GetFormValue(ParamName);
  end else
  begin
    //Prot0('WARN GNav.GetFormValue(%s,%s):nil', [Kurz, ParamName]);
    Debug0;
  end;
end;

function TGNavigator.SetFormValue(Kurz, ParamName, Value: string): boolean;
// f¸r Kommunikation zwischen Forms
// ergibt false wenn nicht ausf¸hrbar weil Form nicht vorhanden
var
  FormObj : TqFormObj;
begin
  Result := false;
  FormObj := GetFormObj(Kurz, false);
  if (FormObj <> nil) and (FormObj.Form <> nil) and (FormGetLNav(FormObj.Form) <> nil) then
  begin
    FormGetLNav(FormObj.Form).SetFormValue(ParamName, Value);
    Result := true;
  end else
  begin
    //Prot0('WARN GNav.SetFormValue(%s,%s,%s):nil', [Kurz, ParamName, Value]);
    Debug0;
  end;
end;

function TGNavigator.FormIsDisabled(Kurz: string): boolean;
var
  FormObj : TqFormObj;
begin
  result := false;
  FormObj := GetFormObj(Kurz, false);
  if FormObj <> nil then
    result := FormObj.Disabled;
end;

function TGNavigator.ReleaseForm(Kurz: string): boolean;
var
  FormObj : TqFormObj;
begin
  result := false;
  FormObj := GetFormObj(Kurz, false);
  if FormObj <> nil then
    if FormObj.Form <> nil then
    begin
      FormObj.Form.Release;
      result := true;
    end;
end;

function TGNavigator.LoadForm(AOwner: TComponent; Kurz: string;
  Data: Pointer): TqForm;
{Laden und Initialisieren einer Form ohne anzuzeigen. Mit Init-Daten}
var
  FormObj : TqFormObj;
  OldDisabled: boolean;
begin
  result := nil;
  FormObj := GetFormObj(Kurz, false);
  if FormObj <> nil then
  begin
    OldDisabled := FormObj.Disabled;
    try
      FormObj.Disabled := true;
      result := StartFormData(AOwner, Kurz, Data);
    finally
      FormObj.Disabled := OldDisabled;         {restaurieren}
    end;
  end;
end;

function TGNavigator.StartFormData(AOwner: TComponent; Kurz: string;
  Data: Pointer): TqForm;
// Start mit voreingestelltem Windowstate (bisherige Logik)
var
  FormObj: TqFormObj;
  aWindowState: TWindowState;
begin
  aWindowState := wsNormal;
  FormObj := GetFormObj(Kurz, false);  //keine Meldung hier. Erst in StartForm.
  if FormObj <> nil then
    aWindowState := FormObj.WindowState;
  Result := StartFormData(AOwner, Kurz, Data, aWindowState);
end;

function TGNavigator.StartFormData(AOwner: TComponent; Kurz: string;
  Data: Pointer; aWindowState: TWindowState): TqForm;
{Aufruf einer Form ¸ber K¸rzel. Mit Angabe tempor‰rer Init-Daten und Windowstate}
var
  FormObj: TqFormObj;
  OldWindowState: TWindowState;
begin
  SetFormData(Kurz, Data);
  //result := StartForm(AOwner, Kurz);
  OldWindowState := aWindowState;  //wg Compilerwarnung
  FormObj := GetFormObj(Kurz, false);  //keine Meldung hier. Erst in StartForm.
  try
    if FormObj <> nil then
    begin
      OldWindowState := FormObj.WindowState;
      FormObj.WindowState := aWindowState;
    end;
    result := StartForm(AOwner, Kurz);
  finally
    if FormObj <> nil then
    begin
      FormObj.WindowState := OldWindowState
    end;
  end;
end;

procedure TGNavigator.PostForm(Kurz: string);
{Aufruf einer Form ¸ber PostMessage}
var
  I: integer;
begin
  I := FormList.IndexOf(UpperCase(Kurz)); {Index holen}
  PostMessage(X.Handle, BC_STARTFORM, I, 0);
end;

procedure TGNavigator.PostCloseForm(Sender: TqForm; Kurz: string);
{Aufruf einer Form ¸ber PostMessage}
var
  I: integer;
  ISender: longint;
  OldKurz: string;
begin
  {Sender schlieﬂen und in bc_startform warten bis er gelˆscht ist}
  if Sender <> nil then
  begin
    OldKurz := Sender.Kurz;
    ISender := 1 + FormList.IndexOf(UpperCase(OldKurz)); {Index Sender (ab 1) holen}
    Prot0('PostCloseForm(%s):ISender=%d',[OldKurz, ISender - 1]);
    Sender.Release;
  end else
    ISender := 0;
  I := FormList.IndexOf(UpperCase(Kurz)); {Index holen}
  PostMessage(X.Handle, BC_STARTFORM, I, LPARAM(ISender));
end;

function TGNavigator.GetFormKurz(Index: integer): string;
begin
  result := '';
  if Index >= FormList.Count then
  try
    result := FormList.Strings[Index];
  except
  end;
end;

function TGNavigator.StartFormIndex(Index: integer): TqForm;
{Aufruf einer Form von PostForm ¸ber TDBQBENav.BCStartForm}
begin
  result := StartForm(Application.MainForm, FormList.Strings[Index]);
end;

function TGNavigator.StartFormShow(AOwner: TComponent; Kurz: string;
  aWindowState: TWindowState = wsNormal): TqForm;
(* Formular starten oder nur zeigen wenn bereits angelegt. Kann minimieren *)
var
  Done: boolean;
  FormObj: TqFormObj;
  AForm: TForm;
  OldWindowState: TWindowState;
  I: integer;
  aMDIForm: TForm;
begin
  Done := false;
  Result := nil;
  FormObj := GetFormObj(Kurz, false);  //keine Meldung hier. Erst in StartForm.
  if (FormObj <> nil) and not FormObj.Disabled and
     (FormObj.Form <> nil) and FormObj.Form.Enabled and FormObj.Form.HasInit {and
     not FormObj.Form.Closed (warum?)} then
  begin
    if (aWindowState <> wsMinimized) and
       (AOwner <> Application.MainForm) and (AOwner <> nil) and
       (AOwner is TqForm) and ((AOwner as TqForm).FormStyle = fsMDIChild) then
    begin
      AForm := AOwner as TqForm;
      AForm.SendToBack;
    end;
    (*ShowWindow(FormObj.Form.Handle, SW_RESTORE); //SW_SHOWNORMAL);
    FormObj.Form.Show;
    *)
    FormObj.Form.WindowState := aWindowState; //wsNormal;

    for I:= 0 to Application.MainForm.MDIChildCount - 1 do
    begin
      aMDIForm := Application.MainForm.MDIChildren[I];
      if aMDIForm.WindowState = wsMinimized then
      begin
        //Minimierte hinter Men¸ plazieren              //aMDIForm.SendToBack;  //beware kste neu - 14.11.06
        SetWindowPos(aMDIForm.Handle, HWND_BOTTOM, 0, 0, 0, 0,
                     SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);  //verschwindet in windowmnu: SWP_HIDEWINDOW);
      end;
    end;

    if aWindowState <> wsMinimized then
      FormObj.Form.BringToFront;
    result := FormObj.Form;
    Done := true;
  end;
  OldWindowState := aWindowState;  //wg Compilerwarnung
  if not Done then
  try
    if FormObj <> nil then
    begin
      OldWindowState := FormObj.WindowState;
      FormObj.WindowState := aWindowState;
    end;
    result := StartForm(AOwner, Kurz);
  finally
    if FormObj <> nil then
    begin
      FormObj.WindowState := OldWindowState
    end;
  end;
end;

function TGNavigator.StartForm(AOwner: TComponent; Kurz: string): TqForm;
{Aufruf einer Form ¸ber K¸rzel}
var
  FormObj: TqFormObj;
  ALNav: TLNavigator;
  AOwnerForm, aMDIForm: TForm;
  I: integer;
begin
  result := nil;
  try
    FormObj := GetFormObj(Kurz, true);
    if FormObj <> nil then
    begin
      if not AnsiSameText(Kurz, 'MENU') and not AnsiSameText(Kurz, 'PARA') and
         not FormObj.NoRechteCheck and not CheckLizenz(Kurz) then
        Exit;
      if FormObj.Locked then
      begin                   {wahrscheinlich mit Doppelklick gestartet}
        ProtL(SGNav_Kmp_009,[Kurz])	// 'Form(%s) gesperrt w‰hrend Form.Create'
      end else
      try
        Canceled := false;    //GNavigator.Canceled - 28.10.03
        FormObj.Locked := true;                   {sperren w‰hrend Form.Create}
        Prot0('StartForm(%s)', [Kurz]);           //11.09.08

        if not FormObj.Disabled and (FormObj.WindowState = wsNormal) and
           (AOwner <> Application.MainForm) and (AOwner <> nil) and
           (AOwner is TqForm) and ((AOwner as TqForm).FormStyle = fsMDIChild) then
        begin  {Z-Ordnung aufr‰umen}
          AOwnerForm := AOwner as TqForm;
          if SameText(TqForm(AOwnerForm).Kurz, 'MENU') then
          begin
            //AOwnerForm.SendToBack;  //Menu nach hinten plazieren - korrigiert 26.06.08
            // besser: ohne Neuzeichnen
            SetWindowPos(AOwnerForm.Handle, HWND_BOTTOM, 0, 0, 0, 0,
                           SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
          end;
          for I:= 0 to Application.MainForm.MDIChildCount - 1 do
          begin
            aMDIForm := Application.MainForm.MDIChildren[I];
            if aMDIForm.WindowState = wsMinimized then
            begin
              //Minimierte hinter Men¸ plazieren              //aMDIForm.SendToBack;  //beware kste neu - 14.11.06
              SetWindowPos(aMDIForm.Handle, HWND_BOTTOM, 0, 0, 0, 0,
                           SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);  //verschwindet in windowmnu: SWP_HIDEWINDOW);
            end;
          end;
        end;
        Screen.Cursor := crHourGlass;     {}
        if FormObj.Form = nil then                 {Formular noch nicht angelegt}
        begin
          ComWait;     {Warten bis serielle Kommunikation sicher}
          CreateKurz := Kurz;
          FormObj.Form := FormObj.FormRef.Create(Application.MainForm);
          if csDestroying in FormObj.Form.ComponentState then
            Abort;  {Notbremse, da Exceptions in TForm.Create behandelt werden}
        end;  //kein else - LAWA 29.04.04
        begin
          if not FormObj.Disabled then
            FormObj.Form.Enabled := true;          //nicht bei LoadForm()
        end;
        FormObj.Form.Kurz := Kurz;
        FormObj.Form.Caller := AOwner;                                 {AuswDlg}
        FormObj.Form.Closed := false;                        {f¸r StartFormShow}
        if not FormObj.Disabled then
        begin                                                //nicht bei LoadForm()
          FormObj.Form.ShowNormal(FormObj.WindowState);      {anzeigen}
          if FormObj.WindowState = WsMinimized then
            Application.MainForm.ArrangeIcons;
        end;
        result := FormObj.Form;
        ALNav := FormObj.Form.LNavigator;
        if ALNav <> nil then
        begin
          if (ALNav.FormKurz <> Kurz) and not FormObj.IsTemp then
          begin
            {if CompareText(ALNav.FormKurz, Kurz) <> 0 then
              Prot0('LNav(%s)<>Kurz(%s)',[ALNav.FormKurz, Kurz]);}
            ALNav.FormKurz := Kurz;
          end;
          ALNav.NavLink.TabellenRechte := FormObj.TabellenRechte; {Rechte kopieren auf den LNav}
          if not (reUpdate in ALNav.NavLink.TabellenRechte) and
             (ALNav.DataSource <> nil) then
            ALNav.DataSource.AutoEdit := false;
          if not FormObj.Form.HasInit then {Initialisierungroutine noch nicht gelaufen}
          begin
            FormObj.Form.Init(self);    //mit Translation, SetForm/Tabellenrechte
            {mit NavLink.Init, LNavInit, LuDefInit, ObjektRechte, LNav.OnInit}
            FormObj.Form.HasInit := true;
            if IniDb = IniKmp then
              IniDb.ReadHints(Kurz, GNavigator.GetForm(Kurz)) else
            if HintIni <> nil then
              HintIni.ReadHints(Kurz, GNavigator.GetForm(Kurz));
          end else {schon initialisiert}
          if FormObj.Form.HasStarted then //bereits gestartet (also nicht nur per LoadForm geladen)
          begin {Filter und Sortierung restaurieren}
            ALNav.FltrList.AssignChanged(ALNav.NavLink.LoadedFltrList);
            if ALNav.KeyFields <> ALNav.NavLink.LoadedKeyFields then
              ALNav.KeyFields := ALNav.NavLink.LoadedKeyFields;
          end;
          if not FormObj.Disabled and FormObj.Form.Enabled then
          begin                                              //nicht bei LoadForm()
            FormObj.Form.HasStarted := true;
            ALNav.DoStart(self);      {÷ffnet, Ereignis LNav.OnStart, Objektrechte}
          end;
          //ALNav.DoStart(self);  beware! ParaFrms.NavStart
        end;
        FormObj.Form.Started := true;
      finally
        Screen.Cursor := crDefault;
        FormObj.Locked := false;
        CreateKurz := '';
      end;
    end else
    begin
      if MaskenRecht then
        ErrWarn(SGNav_Kmp_010, [Kurz]);		// 'Formular(%s) kann nicht gestartet werden'
    end;
  except on E:Exception do
    EProt(self, E, 'Fehler bei StartForm %s', [Kurz]);
  end;
end;

procedure TGNavigator.KillForm(Kurz: string);
var
  I: Integer;
begin
  I := FormList.IndexOf(UpperCase(Kurz));
  if I >= 0 then
    FormList.Delete(I);
end;

procedure TGNavigator.EndForm(AOwner: TComponent; Kurz: string);
var
  FormObj : TqFormObj;
begin
  FormObj := GetFormObj(Kurz, false);
  if FormObj <> nil then
  begin
    if FormObj.Form <> nil then
    begin
      FormObj.Form := nil;
      if FormObj.IsTemp then      {if FormObj.FormRef = TDlgLuGrid then}
        KillForm(Kurz);
      if SysParam.ProtBeforeOpen then
        ProtA('EndForm(%s): OK', [Kurz]);
    end else
      ProtA(SGNav_Kmp_011, [Kurz]);	// 'EndForm(%s): bereits Ende'
  end else
  begin
    {kann passieren, z.B. LuGrid
     MessageFmt('EndForm:(%s) fehlt', [Kurz], mtWarning, [mbOk], 0);}
  end;
  if Assigned(FOnEndForm) then
    FOnEndForm(AOwner, Kurz);
end;

(*** Lookup *****************************************************************)

function TGNavigator.CheckActiveLookUp: boolean;
// ‹berpr¸ft ob das aktuelle Controll lookup-f‰hig ist und f¸hrt dann lookup aus
// Ergibt true wenn Lookup ausgef¸hrt wird
var
  OwnerNav: TLNavigator;
  TheControl: TControl;
begin
//  Result := (LNavigator <> nil) and (X.NavLink.Owner is TLNavigator) and
//    (((TLNavigator(X.NavLink.Owner).ActiveLookUpEdit <> nil) and
//      (X.NavLink.Form.ActiveControl = TLNavigator(X.NavLink.Owner).ActiveLookUpEdit)) or
//     ((TLNavigator(X.NavLink.Owner).ActiveLookUpMemo <> nil) and
//      (X.NavLink.Form.ActiveControl = TLNavigator(X.NavLink.Owner).ActiveLookUpMemo)));
  Result := (LNavigator <> nil) and (X.NavLink.Owner is TLNavigator);
  if Result then
  begin
    OwnerNav := TLNavigator(X.NavLink.Owner);
    TheControl := X.NavLink.Form.ActiveControl;
    Result :=
     (((OwnerNav.ActiveLookUpEdit <> nil) and (TheControl = OwnerNav.ActiveLookUpEdit)) or
      ((OwnerNav.ActiveLookUpMemo <> nil) and (TheControl = OwnerNav.ActiveLookUpMemo)));
    if Result then
      LNavigator.DoLookUp(lumTab);
  end;
end;

procedure TGNavigator.LookUp(LNavCaller: TLNavigator; ALookUpDef:TLookUpDef;
                             LookUpKurz: string);
var
  FormObj: TqFormObj;
  LNavLU: TLNavigator;

  function InLookUpList(aLNav: TLNavigator; Tiefe: integer): boolean;
  var
    aFormObj: TqFormObj;
  begin
    result := false;
    if aLNav.ReturnKurz <> '' then
    begin
      if CompareText(aLNav.ReturnKurz, LookUpKurz) = 0 then
      begin
        aFormObj := GetFormObj(aLNav.ReturnKurz, false);
        if aFormObj <> nil then
        begin
          result := aFormObj.Form <> nil;
          if result then
          begin
            if (FormGetLnav(aFormObj.Form) <> nil) and
               (FormGetLnav(aFormObj.Form).nlState = nlBrowse) then
              result := false;
          end;
        end;
      end else
      if Tiefe < 100 then
      begin
        aFormObj := GetFormObj(aLNav.ReturnKurz, false);
        if (aFormObj <> nil) and (aFormObj.Form <> nil) and (aFormObj.Form.GetLNav <> nil) then
          result := InLookUpList(aFormObj.Form.GetLNav, Tiefe + 1);
      end;
    end;
  end; {InLookUpList}

begin {LookUp}
  Screen.Cursor := crHourGlass;
  try
    //05.06.12 weg if SysParam.ProtBeforeOpen then
    Prot0('GNav.Lookup(%s)', [LookUpKurz]);
    FormObj := GetFormObj(LookUpKurz, true); {Form holen ¸ber K¸rzel}
    if FormObj = nil then
    begin
      {Kurz wird in except eingef¸gt}
      EError(SGNav_Kmp_012, [0]);           // 'Formular fehlt'
    end;
    if FormObj.Form = nil then  {Wenn zu diesem Objekt noch kein Formular existiert}
    begin
      ComWait;     {Warten bis serielle Kommunikation sicher}
      CreateKurz := LookUpKurz;
      {FormObj.Form := FormObj.FormRef.Create(LNavCaller.Owner); {owner ist das Caller-Formular}
      FormObj.Form := FormObj.FormRef.Create(Application.MainForm);
      {somit wird Lookup-Formular nicht entfernt wenn Hauptformular entfernt wird 290400}
    end else
    begin
      //if CompareText(LNavCaller.ReturnKurz, LookUpKurz) = 0 then
      if InLookUpList(LNavCaller, 0) then
      begin
        FormObj.Form.BringToFront;
        EError(SGNav_Kmp_032, [0]);  //'Formular bereits in Verwendung'
      end;
      FormObj.Form.Enabled := true;
    end;
    FormObj.Form.Kurz := LookUpKurz;
    LNavLU := FormObj.Form.GetLNav; {LNav von der aufzurufenden Form holen}
    if LNavLU.FormKurz <> LookUpKurz then
    begin
      {Prot0('LNav(%s)<>Kurz(%s)',[LNavLU.FormKurz, LookUpKurz]);}
      LNavLU.FormKurz := LookUpKurz;
    end;
    LNavLU.NavLink.TabellenRechte := FormObj.TabellenRechte; {Tabellenrechtestruktur zuweisen}
    if not (reUpdate in LNavLU.NavLink.TabellenRechte) and
       (LNavLU.DataSource <> nil) then
      LNavLU.DataSource.AutoEdit := false;
    if LNavLU.nlState in [nlEdit,nlInsert,nlQuery] then
    begin
      FormObj.Form.BringToFront;
      LNavLU.DoCancel;
      if LNavLU.nlState in [nlEdit,nlInsert,nlQuery] then
        raise Exception.Create(SGNav_Kmp_013);	// 'Im Formular wird bereits ge‰ndert oder gesucht'
    end;
    (* LU positionieren: Filter, Key, Datapos
    LNavLU.SetFilter(ALookUpDef.Filter);
    LNavLU.GotoDatapos(ALookUpDef.Datapos);
    *)
    if FormObj.Form.HasInit then  {ist schon angelegt}
    begin
      LNavLU.FltrList := LNavLU.NavLink.LoadedFltrList;   {Orginalfilter restaurieren}
      LNavLU.KeyFields := LNavLU.NavLink.LoadedKeyFields; {Orginalkeyfields restaurieren}
    end;
    LNavLU.SetReturn(0, LNavCaller.FormKurz, ALookUpDef);         {‰ndert sql}
    if not FormObj.Form.HasInit then {ist noch nicht initialisiert}
    begin
      FormObj.Form.Init(self);                 {mit NavLink.Init, Rechte, Open}
      FormObj.Form.HasInit := true;
    end;
    LNavLU.DoStart(self);                                            { ˆffnen}
    LNavLU.SetReturn(1, LNavCaller.FormKurz, ALookUpDef);       {positioniert}

    if (ALookUpDef <> nil) and
       (ALookUpDef.LookUpModus in
        [lumTab,lumDetailTab,lumMasterTab,lumFltrTab,lumSuch]) then  {Seite setzten}
    begin
      //LNavLU.SetPage(ALookUpDef.LuMultiName)  bis 17.06.08 allein
      //kann Multi Page '10'..'19' sein. Ansonsten Multi
      if (StrToIntTol(ALookUpDef.LuMultiName) >= 10) then
        LNavLU.SetPage(ALookUpDef.LuMultiName) else
        //LNavLU.SetPage('Multi');
        LNavLU.SetPage(ALookUpDef.LuMultiName);  //ab 08.11.08 WeBAB KSTE 'Single'
    end else
    begin
      //LNavLU.SetPage('Single');               bis 17.06.08 allein
      //kann Single Page '1'..'9' sein. Ansonsten Single
      if (ALookUpDef <> nil) and
         (StrToIntTol(ALookUpDef.LuMultiName) >= 1) and
         (StrToIntTol(ALookUpDef.LuMultiName) <= 9) then
        LNavLU.SetPage(ALookUpDef.LuMultiName) else
        LNavLU.SetPage('Single');
      LNavLU.BrowsePageIndex := LNavLU.PageIndex;  {kein Multi nach Post}
    end;
    FormObj.Form.ShowNormal(wsNormal);
    Screen.Cursor := crDefault;
    if (ALookUpDef <> nil) and (ALookUpDef.LookUpModus in [lumZeigMsk, lumAendMsk]) and
       (LNavLU.Dataset <> nil) then
    begin
      LNavLU.Dataset.Open;
      if LNavLU.Dataset.BOF and LNavLU.Dataset.EOF then
      begin
        ProtSQL(LNavLU.Dataset);     //17.12.10
        EError(SLNav_Kmp_022, []);   //'Keine Daten vorhanden' - 19.01.04
        {* 18.01.11 Idee
        //konfigurierbare Nachricht (webab.bvor 'sie haben keine Rechte'
        Btn := DoMsgFmt(mtWMessConfirmation, MSG_VALUENOTFOUND,
          SNLnk_Kmp_013+CRLF+SNLnk_Kmp_014,		// 'Wert(%s) in(%s.%s) nicht gefunden.'+CRLF+'Tabelle ?',
          [AFieldText, Display, AFieldName]) else
        *}
      end;
    end;
  except
    on E:Exception do
    begin
      Screen.Cursor := crDefault;
      if MaskenRecht then
        EMess(self, E, SGNav_Kmp_014,	// 'LookUp(%s) kann nicht ausgef¸hrt werden'
          [LookUpKurz]);
    end;
  end;
  CreateKurz := '';
end;

function TGNavigator.Return(FromForm: TqForm; ToKurz: string;
                             ALookUpModus: TLookUpModus;
                             ADataPos: TDataPos; ToLuName: string): boolean;
(* Return from LookUp: Werte ¸bertragen *)
var
  FormObj: TqFormObj;
  LNavCall: TLNavigator;
  ALookUpDef: TLookUpDef;
  AList: TDataPos;
  I, ErrNr: integer;
begin
  result := true;
  ErrNr := 0;
  try
    FormObj := GetFormObj(ToKurz, false);   {Identifizieren des Formulars}
    if (ToKurz = '') or SameText(ToKurz, 'MAIN') then
    begin
      Prot0('GNav.Return(from %s to %s,%s)', [OwnerDotName(FromForm), ToKurz, ToLuName]);
      Exit;
    end;
    if FormObj = nil then
    begin
      Prot0('GNav.Return(to %s,%s)', [ToKurz, ToLuName]);
      raise Exception.Create(SGNav_Kmp_015);	// 'Formular fehlt (Nicht mit AddForm angelegt).'
    end else
    if SysParam.ProtBeforeOpen then
      Prot0('GNav.Return(to %s,%s)', [ToKurz, ToLuName]);

    if FormObj.Form = nil then
    begin
      // raise Exception.Create(SGNav_Kmp_016);	// 'Zielformular bereits geschlossen'
      GNavigator.StartForm(Application, ToKurz);
    end;
    LNavCall := FormObj.Form.LNavigator;
    if LNavCall = nil then
      raise Exception.Create(SGNav_Kmp_017);	// 'LNavigator fehlt'

    ALookUpDef := FormObj.Form.FindComponent(ToLuName) as TLookUpDef; {LookUpDef suchen}
    {if ALookUpDef = nil then
      raise Exception.Create('LookUpDef fehlt');}
    if ALookUpDef <> nil then
      ALookUpDef.DataPos.Assign(ADataPos); {wichtig f¸r AfterReturn Ereignisse,
                                             kopieren von DataSet}
    try FromForm.LNavigator.DataSet.Close;     {DisableControls;}
    except on E:Exception do
      EMess(FromForm.LNavigator.DataSet, E, 'GNav.Return(%s)',[ToLuName]);
    end;
    {FromForm.Release;                 nicht hier !! erst in LNav.StartReturn !! ISA.POSI.LuRepo
    GNavigator.ProcessMessages;}

    (* Felder von Lookup aktualisieren *)
    if ALookUpDef <> nil then with ALookUpDef do
    begin
      HangingReturn := false;                 {von LuEdi.DoEnter   07.09.97 ROE}
      if (MDTyp = mdMaster) and (ALookUpModus <> lumDetailTab) then        {n:m}
      begin
        ErrNr := 1;
        if (MasterSource <> nil) and
           (MasterSource.State in [dsEdit,dsInsert]) then
        begin
          ErrNr := 2;
          if LookUpModus = lumSuch then
          begin
            ADataPos.AddReferenceFields(DataSet, IndexFieldNames, MasterSource,
              MasterFieldNames);
          end else
          if LookUpModus in [lumZeigMsk, lumAendMsk] then
            ALookUpDef.NavLink.Refresh else              //19.01.04 SDBL.KUSR#sepr
            PutReferenceFields;
            {ADataPos.PutReferenceFields(DataSet, IndexFieldNames, MasterSource,
                                         MasterFieldNames);}
          if (MasterSource is TLookUpDef) and
             (ALookUpModus <> lumTab) and                 {130400 ISA.POSI.REPO}
             (TLookUpDef(MasterSource).MDTyp = mdDetail) then   {231098 DPE.ERF}
            TLookUpDef(MasterSource).NavLink.DoPost(true);          {entspr. MDDetail}
        end else
        if (MDTyp = mdMaster) and
           (MasterSource is TLookUpDef) and
           (ALookUpModus in [lumZeigMsk, lumAendMsk]) then                      {n:m Beziehung}
        begin                                        {30.01.02: lumZeigMask, ReLoad}
          if TLookUpDef(MasterSource).NoGotoPos then
            TLookUpDef(MasterSource).NavLink.Refresh else
            TLookUpDef(MasterSource).NavLink.ReLoad;
        end;
      end else
      if (MDTyp = mdDetail) then
      begin
        ErrNr := 3;
        DataSet.Close;
        DataSet.Open;
        (*if (PrimaryKeyFields <> '') and
           (DataPos.Values[PrimaryKeyFields] <> '') then*)
        if (NavLink.PrimaryKeyList.Count > 0) and                   {011199 SDO}
           (DataPos.Values[NavLink.PrimaryKeyList
             [NavLink.PrimaryKeyList.Count - 1]] <> '') then
        begin
          AList := TDataPos.Create;
          try
            for I := 0 to NavLink.PrimaryKeyList.Count - 1 do
              AList.Values[NavLink.PrimaryKeyList[I]] :=
                DataPos.Values[NavLink.PrimaryKeyList[I]];
            (*AList.Add(Format('%s=%s', [PrimaryKeyFields,
              DataPos.Values[PrimaryKeyFields]]));*)
            ErrNr := 4;
            AList.GotoPosSilent(DataSet);                             {240789 qugl.grbu}
          finally
            AList.Free;
          end;
        end;
      end;
    end;     {ALookUpDef <> nil}
    {FromForm.Close;}
    with FormObj.Form do
    begin
      ErrNr := 5;
      {BringToFront;}
      ShowNormal(wsNormal);
      LNavCall.DoAfterReturn(self, ALookUpModus, ALookUpDef);
    end;
  except
    on E:Exception do
    begin
      if ToKurz <> '' then  //ist '' bei Stme-Return
        EProt(self, E, 'Return(%.30s,%.30s) Error %d', [ToKurz, ToLuName, ErrNr]);  //01.03.11 keine EMess mehr - QUPE
      result := false;
    end;
  end;
end;

(*** Buttons ****************************************************************)

procedure TGNavigator.BtnSortClick(Sender: TObject);
{Sortieren}
var
  I: integer;
  AKeyFields: string;
  Permanent, OldPermanent: boolean;
  AForm: TqForm;
  ADataPos: TDataPos;
begin
  if (X <> nil) and
     (X.FNavLink <> nil) and (DlgSort = nil) and {DlgSort Flag 'bin dabei'}
     (X.FNavLink.ActiveSource <> nil) then
  begin
    AKeyFields := X.NavLink.KeyFields;
    Permanent := X.NavLink.PermanentKeysAllowed; //LoadedKeyFields = '';
    OldPermanent := Permanent;
    {I := TDlgSort.Execute(Sender, X.NavLink.KeyList, AKeyFields, Permanent);}

    TqForm(X.NavLink.Form).BroadcastMessage(X.NavLink.DataSource, TMultiGrid, BC_MULTIGRID,
      mgAddSortList);
    //Sortlist wird von MultiGrid gebildet, mit Spaltennamen und KeyList-Titel
    I := TDlgSort.Execute(Sender, X.NavLink.SortList, AKeyFields, Permanent);
    if I >= 0 then
    begin
      if (X.NavLink.KeyFields = AKeyFields) and (OldPermanent = Permanent) then
      begin
        if X.NavLink.nlState <> nlQuery then           {wenn nicht im Suchmodus}
          X.DataSource.DataSet.Open;                          {Browse und Laden}
        if Permanent then
        begin                                         {Keylist in INI speichern}
          AForm := X.DataSource.Owner as TqForm;
          AForm.BroadcastMessage(X.DataSource, TMultiGrid, BC_MULTIGRID, mgSaveKeyList);
        end;
      end else
      begin
        ADataPos := TDataPos.Create;
        try
          if SysParam.GotoPos and X.DataSource.DataSet.Active then
            ADataPos.AddFieldsValue(X.DataSource.DataSet, X.NavLink.PrimaryKeyFields);
          X.NavLink.KeyFields := AKeyFields;  {belegen auf LNav. Rest automatisch}
          if Permanent then
          begin                                         {Keylist in INI speichern}
            AForm := X.DataSource.Owner as TqForm;
            AForm.BroadcastMessage(X.DataSource, TMultiGrid, BC_MULTIGRID, mgSaveKeyList);
          end;
          if X.NavLink.nlState <> nlQuery then           {wenn nicht im Suchmodus}
          begin
            if X.NavLink.BuildSql then                              {SQL-aufbauen}
            begin
              X.DataSource.DataSet.Open;                        {Browse und Laden}
              if SysParam.GotoPos then
                ADataPos.GotoPosEx(X.DataSource.DataSet, [dpoEnableControls]);
            end;
          end;
        finally
          ADataPos.Free;
        end;
      end;
    end;
  end else
    ErrWarn(SGNav_Kmp_018,[0]);		// 'Sortierung hier nicht verf¸gbar'
end;

procedure TGNavigator.BtnDruckClick(Sender: TObject);
{DoPrn vom aktuellen LNav aufrufen}
begin
  if (LNavigator <> nil) then
  begin
    LNavigator.DoPrn;         {mit Formularauswahl}
  end;
end;

procedure TGNavigator.BtnEscapeClick(Sender: TObject);
{Lieber EXIT-Knopf}
begin
  with Owner as TForm do               {MainForm ist owner von GNav}
  try
    InBtnEscapeClick := true;                    {QWF.HaltFrm 23.02.98}
    if ActiveMDIChild <> nil then {MDI Modus}
      ActiveMDIChild.Close
    else
    // 'Programmende'
    if MessageFmt(SGNav_Kmp_019, [0], mtConfirmation, mbYesNoCancel, 0) = mrYes then
      Application.Terminate;
  finally
    InBtnEscapeClick := false;
  end;
end;

procedure TGNavigator.BtnSqlClick(Sender: TObject);
{SQL-Dialog aufrufen}
var
  AQuery: TuQuery;
begin
  if (GNavigator.PreviewForm <> nil) and
     (FormGetLNav(GNavigator.PreviewForm) <> nil) then
  begin                                               {w‰hrend Quickrep Preview}
    AQuery := FormGetLNav(GNavigator.PreviewForm).Query;
    TDlgSql.Execute(Sender, AQuery, false);
  end else
  if (X <> nil) and
     (X.DataSource <> nil) and
     (X.DataSource.State in [dsBrowse,dsInactive]) then
  begin                                              {w‰hrend aktiver Anwendung}
    AQuery := X.DataSource.DataSet as TuQuery;
    TDlgSql.Execute(Sender, AQuery, true);
  end else
  if (X <> nil) and
     (X.DataSource <> nil) then
  begin                                 {w‰hrend aktiver Anwendung im Editmodus}
    AQuery := X.DataSource.DataSet as TuQuery;
    TDlgSql.Execute(Sender, AQuery, false);
  end else
  begin                             {keine Anwendung aktiv}
    TDlgSql.Execute(Sender, nil, false);    {ErrWarn('SQL hier nicht verf¸gbar',[0]);}
  end;
  {Idee DlgSql mit Rechteverw}
  if DlgSql <> nil then
  begin
    DlgSql.SetObjRechte;
    DlgSql.Init(self);    //mit Translation, SetForm/Tabellenrechte  //Rechteverwaltung 'TDlgSql':
  end;
end;

procedure TGNavigator.BtnSingleClick(Sender: TObject);
var
  ALookUpDef: TLookUpDef;
begin
  if (X <> nil) and (X.FNavLink <> nil) and
     (X.FNavLink.ActiveSource is TLookUpDef) then
  begin
    ALookUpDef := X.FNavLink.ActiveSource as TLookUpDef;
    if (ALookUpDef.LookUpSource <> nil) then
    begin
      TLookUpDef(ALookUpDef.LookUpSource).LookUp(lumZeigMsk);
    end else
      ALookUpDef.LookUp(lumZeigMsk);
  end else
  if (LNavigator <> nil) and (LNavigator.BtnSingle <> nil) then
  begin
    LNavigator.BtnSingle.Click;
  end else
  if (LNavigator <> nil) and (LNavigator.PageBook <> nil) then
  try
//    if BtnSingle <> nil then
//      LNavigator.PageBook.ActivePage := BtnSingle.Page else
//      LNavigator.PageIndex := 0;
    if BtnSingle <> nil then
      LNavigator.SetPage(BtnSingle.Page) else
      if LNavigator.PageIndex >= 10 then
        LNavigator.PageIndex := LNavigator.PageIndex - 10;
  except on E:Exception do
    EProt(LNavigator.PageBook, E, 'GNavigator.BtnSingleClick', [0]);
  end else
  if Sender = BtnSingle then
      ErrWarn(SGNav_Kmp_020,[0]);	// 'Einzeldarstellung hier nicht verf¸gbar'
end;

procedure TGNavigator.BtnMultiClick(Sender: TObject);
begin
  {if BtnMulti <> nil then
    BtnMulti.Click}
  if (LNavigator <> nil) and (LNavigator.BtnMulti <> nil) then
  begin
    LNavigator.BtnMulti.Click;
  end else
  if (LNavigator <> nil) and (LNavigator.PageBook <> nil) then
  begin
//    if BtnMulti <> nil then
//      LNavigator.PageBook.ActivePage := BtnMulti.Page else
//      LNavigator.PageIndex := 10;
    if BtnMulti <> nil then
      LNavigator.SetPage(BtnMulti.Page) else
      if LNavigator.PageIndex < 10 then
        LNavigator.PageIndex := LNavigator.PageIndex + 10;
  end else
  if Sender = BtnMulti then
    ErrWarn(SGNav_Kmp_021,[0]);		// 'Tabellendarstellung hier nicht verf¸gbar'
end;

procedure TGNavigator.BtnCalcClick(Sender: TObject);
begin                        {Standard BeforeClick Ereignis}
  if (BtnCalc <> nil) and
     (X <> nil) and
     (X.FNavLink <> nil) then
  begin
    if (X.FNavLink.Form.ActiveControl is TCustomEdit) then
      BtnCalc.Edit := TCustomEdit(X.FNavLink.Form.ActiveControl) else
    if (X.FNavLink.Form.ActiveControl is TMultiGrid) then               {130400}
      BtnCalc.Edit := TMultiGrid(X.FNavLink.Form.ActiveControl).InplaceEditor;
  end;
end;

procedure TGNavigator.BtnHintClick(Sender: TObject);
begin
  if IniDb = IniKmp then
    IniDb.EditHint(X.NavLink, X.NavLink.Form.ActiveControl) else
  if HintIni <> nil then
    HintIni.EditHint(X.NavLink, X.NavLink.Form.ActiveControl) else
    ErrWarn(SGNav_Kmp_022, [0]);		//  'Keine HintIni Komponente gefunden'
end;

procedure TGNavigator.MiCharCaseCaption(Sender: TObject);
begin
  if (MiCharCase <> nil) and not (csDestroying in ComponentState) then
    if (Sender <> nil) and (Sender is TCustomEdit) then
      case TDummyCustomEdit(Sender).CharCase of
        ecNormal: MiCharCase.Checked := false;
        ecUpperCase: begin
                       MiCharCase.Caption := SGrossschrift;
                       MiCharCase.Checked := true;
                     end;
        ecLowerCase: begin
                       MiCharCase.Caption := SKleinschrift;
                       MiCharCase.Checked := true;
                     end;
      end else
        MiCharCase.Checked := false;
end;

procedure TGNavigator.MiCharCaseClick(Sender: TObject);
{bei 'Strg k' wird das aktiveControl auf Normalschrift gesetzt}
begin
  if MiCharCase <> nil then
    if (Screen.ActiveControl <> nil) and
       (Screen.ActiveControl is TCustomEdit) then
    begin
      MiCharCase.Checked := not MiCharCase.Checked;
      if not MiCharCase.Checked then
      begin
        TDummyCustomEdit(Screen.ActiveControl).CharCase := ecNormal;
        MiCharCase.Caption := SGrossschrift;
      end else
      if MiCharCase.Caption = SGrossschrift then
        TDummyCustomEdit(Screen.ActiveControl).CharCase := ecUpperCase else
      if MiCharCase.Caption = SKleinschrift then
        TDummyCustomEdit(Screen.ActiveControl).CharCase := ecLowerCase;
    end;
  MiCharCaseCaption(Screen.ActiveControl);
end;

procedure TGNavigator.Export;
begin
(* in d14 entfernt 17.10.09
  if (X <> nil) and (X.DataSource <> nil) and (X.DataSource.DataSet <> nil) and
     X.DataSource.DataSet.Active and (DlgSql = nil) then
  begin
    TDlgExport.Export(LNavigator);
  end else
    TDlgExport.Export(nil);
*)
end;

procedure TGNavigator.Import;
begin
(* in d14 entfernt 17.10.09
  if (X <> nil) and (X.DataSource <> nil) and (X.DataSource.DataSet <> nil) and
     X.DataSource.DataSet.Active and (DlgSql = nil) then
  begin
    TDlgExport.Import(LNavigator);
  end else
    TDlgExport.Import(nil);
*)
end;

procedure TGNavigator.Konvert;
begin
  if (X <> nil) and (X.NavLink <> nil) then
  begin
    TDlgKonvert.Execute(X.NavLink);
  end else
    EError(SGNav_Kmp_023, [0]);		// 'Konvert: Tabellenbezug fehlt'
end;

procedure TGNavigator.SearchAndReplace(Replace: boolean);
begin
  if (X <> nil) and
     (X.FNavLink <> nil) and {(DlgReplace = nil) and}
     (X.FNavLink.ActiveSource <> nil) then
  begin
    TDlgReplace.Execute(X.FNavLink, Replace);
  end else
    ErrWarn(SGNav_Kmp_031,[0]);		// 'Suchen und Ersetzen hier nicht verf¸gbar'
end;

procedure TGNavigator.ChangeAll;
begin
  if (X <> nil) and (X.NavLink <> nil) then
  begin
    X.QueryActivate(qmChangeAll);
  end else
    EError(SGNav_Kmp_023, [0]);		// 'Konvert: Tabellenbezug fehlt'
end;

procedure TGNavigator.HandleMessages;
begin
  ProcessMessages;
  try
    Application.HandleMessage;           {mit Idle}
  except on E:Exception do
    begin
      EProt(Application, E, 'HandleMessages', [0]);
      raise;
    end;
  end;
end;

procedure TGNavigator.ProcessMessages;
var
  OldIn: boolean;
begin
  OldIn := InProcessMessages;
  if not NoProcessMessages then
  try
    InProcessMessages := true;
    try
      Application.ProcessMessages;
    except on E:Exception do
      begin
        EProt(Application, E, 'ProcessMessages', [0]);
        raise;
      end;
    end;
  finally
    InProcessMessages := OldIn;
  end;
end;

procedure TGNavigator.FieldDescDlg;
begin
  with TDlgFldDesc.Create(Application) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TGNavigator.PropsDlg;
begin
  TDlgProps.Execute(X.NavLink);
end;

procedure TGNavigator.PageChanged(NewPage: string);
{ruft der LNav hat bei uns kein Effekt}
begin
  if BtnSingle <> nil then BtnSingle.Down := NewPage = BtnSingle.Page;
  if BtnMulti <> nil then BtnMulti.Down := NewPage = BtnMulti.Page;
end;

(*** Clipboard ***************************************************************)

procedure TGNavigator.CutItem(AControl: TWinControl); {AControl aktives Control}
var
  S: string;
begin
  {cut selection to clipboard}
  S:= AControl.ClassName;
  if AControl is TDBImage  then
    (AControl as TDBImage).CutToClipBoard  else
  if AControl is TCustomEdit then {z.B. DBEdit, DBMemo}
    (AControl as TCustomEdit).CutToClipBoard else
  if AControl is TDBGrid   then
  begin
    ClipBoard.AsText := (AControl as TDBGrid).SelectedField.Text; {Der ganze Text}
    (AControl as TDBGrid).SelectedField.Text := '';
  end else
  MessageBeep(Word(-1));
end;

procedure TGNavigator.CopyItem(AControl: TWinControl);
var
  I: integer;
  ALine: string;
  S1: string;
  X, Y: integer;
begin
  {copy selection to clipboard}
  MarkAllCopied := false;
  if MarkAllMarked then {wenn alle kopieren aktiv}
  begin
    MarkAllMarked := false; {zur¸cksetzen}
    if LNavigator = nil then
      EError(SGNav_Kmp_024,[0]);	// 'Keine Daten zum Markieren vorhanden'
    if (LNavigator.NavLink <> nil) and (LNavigator.NavLink.DataSet <> nil) then
      with LNavigator.NavLink.DataSet do
      begin
        MarkAllMemo.Lines.Clear;                             {Hilfsmemo lˆschen}
        for I:= 0 to FieldCount-1 do                         {¸ber alle TFields}
        begin
          ALine := Format('%s=%s', [Fields[I].FieldName, GetFieldString(Fields[I])]);
          {Feldname=FeldInhalt}
          MarkAllMemo.Lines.Add(ALine);                            {hinzunehmen}
        end;
        MarkAllCopied := true;
        MarkAllMemo.SelectAll;
        MarkAllMemo.CopyToClipBoard;                   {ab daf¸r aufs Clipboard}
      end;
  end else {nicht alle kopieren}
  begin
    MarkAllCopied := false;
    if AControl is TDBImage  then
      (AControl as TDBImage).CopyToClipBoard  else
    if AControl is TCustomEdit then
      (AControl as TCustomEdit).CopyToClipBoard else
    if AControl is TListBox then
    begin
      CopyTxt(TListBox(AControl).Items.Text);
    end else
    if AControl is TDBGrid then
    begin
      if (AControl is TMultiGrid) and
         (TMultiGrid(AControl).SelectedRows.Count > 0) then
      begin   {Html Copy}
        TMultiGrid(AControl).CopyToHtml;
        {TMultiGrid(AControl).CopyToRtf;
        TMultiGrid(AControl).CopyToTxt;}
      end else
      if TDBGrid(AControl).SelectedField = nil then
      begin
      end else
      begin
        if IsBlobField(TDBGrid(AControl).SelectedField) then
          ClipBoard.AsText := TDBGrid(AControl).SelectedField.AsString else
          ClipBoard.AsText := TDBGrid(AControl).SelectedField.Text;
      end;
    end else
    if AControl is TStringGrid then
    begin
      {ClipBoard.AsText := TStringGrid(AControl).Cells[
        TStringGrid(AControl).Col, TStringGrid(AControl).Row]; }
      with TStringGrid(AControl) do
      begin
        ALine := '';
        for Y := Selection.Top to Selection.Bottom do
        begin
          S1 := '';
          for X := Selection.Left to Selection.Right do
            AppendTok(S1, Cells[X, Y], TAB);
          AppendTok(ALine, S1, CRLF);
        end;
      end;
      ClipBoard.AsText := ALine;
    end else
      MessageBeep(Word(-1));
  end;
end;

procedure TGNavigator.PasteItem(AControl: TWinControl);
var
  S, S1, S2: string;
  I, P: integer;
begin
  {paste from clipboard: TDBEdit, TDBImage, TDBMemo, TEdit, TMaskEdit, TMemo,}
  if MarkAllCopied then
  begin
    if LNavigator = nil then  {muﬂ vorhanden sein}
      EError(SGNav_Kmp_025,[0]);	// 'GNav:Lnavigator fehlt'
    if not (LNavigator.nlState in nlEditStates) then
      EError(SGNav_Kmp_026,[0]);	// 'Nicht im Editier-Modus'
    MarkAllMemo.Lines.Clear;
    MarkAllMemo.PasteFromClipboard; {KOpieren von Cliepboard}
    for I:= 0 to MarkAllMemo.Lines.Count-1 do   {letzte Zle u.a.Schrott}
    begin
      S := MarkAllMemo.Lines.Strings[I];
      P := pos('=',S);
      {if P < 1 then
        EError('falsche MarkAll-Syntax(%s)',[S]);}
      if P > 1 then
      begin
        S1 := copy(S, 1, P-1); {Feldname}
        S2 := copy(S, P+1, length(S)); {Feldwert}
        try
          {SetFieldValueRO(LNavigator.NavLink.DataSet.FieldByName(S1), S2);}
          SetFieldString(LNavigator.NavLink.DataSet.FieldByName(S1), S2);
          {TField mit Wert belegen}
        except
          {Feld nicht vorhanden: OK}
        end;
      end;
    end;
  end else {Standard}
  if AControl is TDBImage  then
    (AControl as TDBImage).PasteFromClipBoard  else
  if AControl is TCustomEdit then
    (AControl as TCustomEdit).PasteFromClipBoard else
  if AControl is TDBGrid then
  begin
    S := ClipBoard.AsText;
    for I := 1 to length(S) do
      SendMessage(AControl.Handle, WM_CHAR, WPARAM(S[I]), LPARAM(0));
      {}
  end else
    MessageBeep(Word(-1));
end;

type TDummyCustomRadioGroup = class(TCustomRadioGroup);
type TDummyCustomCheckBox = class(TCustomCheckBox);

procedure TGNavigator.ClearItem(AControl: TWinControl);
var
  S: string;
begin
  // Feldinhalt entfernen. 13.03.10 TCustomComboBox
  S:= AControl.ClassName;
  if AControl is TDBImage  then               (AControl as TDBImage).CutToClipBoard else
  if AControl is TCustomEdit then             AControl.SetTextBuf('') else
  if AControl is TDBRadioGroup then           TDBRadioGroup(AControl).Field.Clear else
  if AControl.Owner is TDBRadioGroup then     TDBRadioGroup(AControl.Owner).Field.Clear else
  if AControl is TCustomRadioGroup then       TDummyCustomRadioGroup(AControl).ItemIndex := -1 else
  if AControl.Owner is TCustomRadioGroup then TDummyCustomRadioGroup(AControl.Owner).ItemIndex := -1 else
  if AControl is TCustomCheckBox then         TDummyCustomCheckBox(AControl).State := cbGrayed else
  if AControl is TCustomComboBox then         TCustomComboBox(AControl).ItemIndex := -1 else
  if AControl is TDBGrid then                 TDBGrid(AControl).SelectedField.Text := '' else
                                              AControl.SetTextBuf('');
end;

procedure TGNavigator.MarkAll;
{Single: alle Felder markieren
 Multi: alle Datens‰tze markieren}
var
  I: longint;
  AForm: TForm;
  ADBGrid: TDBGrid;
begin
  if (LNavigator = nil) or (LNavigator.DataSet = nil) then
    EError(SGNav_Kmp_024,[0]);		// 'Keine Daten zum Markieren vorhanden'
  AForm := LNavigator.Owner as TForm; {Form holen ¸ber LNav}
  if AForm.ActiveControl is TDBGrid then   {bin im Multi}
  begin
    ADBGrid := TDBGrid(AForm.ActiveControl);
    MuGriKmp.MarkAll(ADBGrid);
    (*I := 0;
    ADBGrid.DataSource.DataSet.EnableControls;
    ADBGrid.DataSource.DataSet.First;
    GMess0;
    while not ADBGrid.DataSource.DataSet.EOF and not Canceled do
    begin
      Inc(I);
      //SMess(SGNav_Kmp_027,[I]);	// 'Markiere(%d)'
      ADBGrid.SelectedRows.CurrentRowSelected := true;
      SendMessage(ADBGrid.Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0); //SMess Count
      ADBGrid.DataSource.DataSet.Next;
    end;*)
    AForm.Invalidate;
  end else
  (*if LNavigator.PageIndex >= 10 then         {bin im Multi}
  begin
    if LNavigator.NavLink.DBGrid <> nil then
    begin
      I := 0;
      LNavigator.DataSet.EnableControls;
      LNavigator.DataSet.First;
      while not LNavigator.DataSet.EOF do
      begin
        Inc(I);
        SMess(SGNav_Kmp_027,[I]);	// 'Markiere(%d)'
        LNavigator.NavLink.DBGrid.SelectedRows.CurrentRowSelected := true;
        LNavigator.DataSet.Next;
      end;
      AForm.Invalidate;
    end;
  end else*)
  begin
    if MarkAllMemo = nil then
      EError(SGNav_Kmp_028,[0]);  // 'Funktion (MarkAll) wird nicht unterst¸tzt'
    MarkAllMarked := true;                      {Flag f¸r CheckReadOnly setzten}
    for I:= 0 to AForm.ComponentCount-1 do
      if AForm.Components[i] is TCustomEdit then
        (AForm.Components[i] as TCustomEdit).SelectAll;
    {Brush.Color := clHighlight;
    Font.Color := clHighlightText;}
  end;
  {if MarkAllMemo = nil then
    MarkAllMemo := TMemo.Create(Application.MainForm);}
end;

procedure TGNavigator.Duplicate;
begin
  if (LNavigator <> nil) and (LNavigator.NlState = nlBrowse) then
    LNavigator.NavLink.Duplicate;          {umgezogen am 02.06.02}
end;

procedure TGNavigator.DoErrWarn(const Fmt: string; const Args: array of const;
var Done: boolean);
(* ErrWarn Ereignis starten. Wird intern von ErrWarn aufgerufen *)
begin
   if Assigned(FOnErrWarn) then
     FOnErrWarn(self, Fmt, Args, Done);
end;

procedure TGNavigator.DoBeforePost(DataSet: TDataSet);
begin                        {Aufruf des BeforePost Ereignisses}
  if Assigned(FBeforePost) then
    FBeforePost(DataSet);
end;

procedure TGNavigator.DoAfterPost(NavLink: TNavLink);
begin                        {Aufruf des AfterPost Ereignisses}
  if Assigned(FAfterPost) then
    FAfterPost(NavLink);
end;

procedure TGNavigator.DoBeforeDelete(DataSet: TDataSet);
begin                        {Aufruf des BeforeDelete Ereignisses}
  if Assigned(FBeforeDelete) then
    FBeforeDelete(DataSet);
end;

procedure TGNavigator.DoNavLinkInit(Sender: TNavLink);
begin
  if Assigned(FOnNavLinkInit) then
    FOnNavLinkInit(Sender);
end;

procedure TGNavigator.DdeSysInfoDlg;
(* DDE Serververbindung in Dialogfenster aufbauen *)
var
  I: integer;
begin
  if DlgDdeSysInfo = nil then
    TDlgDdeSysInfo.Create(self);
  with DlgDdeSysInfo do
  begin
    Edit1.Lines.Clear;
    Edit1.Lines.Add(copy(Application.MainForm.ClassName, 2, 64)); {(T)FrmMain}
    for I := 0 to FormList.Count - 1 do
    begin
      {AFormObj := TqFormObj(FormList.Objects[I]);
       if not AFormObj.NoRechteCheck then    08.07.01 weg wg FrmMenu}
        Edit1.Lines.Add(Format('Frm%s', [FormList.Strings[I]]));
    end;
    GetFormsInfo.Lines.Assign(Edit1.Lines);
    Show;
  end;
end;

procedure TGNavigator.DdeObjektInfo(AKennung: string; AList: TStrings);
(* L‰dt die Objektnamen eines Forms nach AList.
   Umgeht alle Rechte und Initialisierungen.
   Lˆscht das Form wieder
   f¸r DDE Serververbindung *)
var
  I, J: integer;
  AFormObj: TqFormObj;
  AFormKurz: string;
  AForm: TForm;
  AComponent: TComponent;
  ATabbedNoteBook: TTabbedNoteBook;
begin
  AForm := nil;
  AFormObj := nil;
  AList.Clear;
  try
    for I := 0 to Screen.FormCount - 1 do
      if CompareText(Screen.Forms[I].ClassName, Format('T%s', [AKennung])) = 0 then
      begin
        AForm := Screen.Forms[I];
        break;
      end;
    if AForm = nil then
    begin
      AFormKurz := copy(AKennung, 4, 200);      {Frm weg}
      I := FormList.IndexOf(AFormKurz);
      if I >= 0 then
      begin
        AFormObj := TqFormObj(FormList.Objects[I]);
        AFormObj.Form := AFormObj.FormRef.Create(Application.MainForm);
        AForm := AFormObj.Form;
      end;
    end;
    if AForm <> nil then
    try
      for I := 0 to AForm.ComponentCount - 1 do
      begin
        AComponent := AForm.Components[I] as TComponent;
        if (AComponent is TControl) or
           (AComponent is TMenuItem) or
           (AComponent is TPopupMenu) or
           (AComponent is TPrnSource) then
          AList.Add(Format('%s=%s', [AComponent.Name, AComponent.ClassName]));
        if (AComponent is TTabbedNoteBook) then
        begin
          ATabbedNoteBook := AComponent as TTabbedNoteBook;
          for J := 0 to ATabbedNoteBook.Pages.Count - 1 do
            AList.Add(RemoveAccelChar(Format('%s=TTabPage',
              [ATabbedNoteBook.Pages[J]])));
        end;
      end;
    finally
      if AFormObj <> nil then
      begin
        AFormObj.Form.Release;
        AFormObj.Form := nil;
      end;
    end else
      EError(SGNav_Kmp_029,[AKennung]);		// 'Keine Objekte von "%s" gefunden'
  except on E:Exception do
    AList.Add(E.Message);
  end;
end;

procedure TGNavigator.MakroInit(MiMakros: TMenuItem);
var
  MI, N: integer;
  Break: boolean;
  S1, S2: string;
begin
  self.MiMakros := MiMakros;
  Break := false;
  for Mi := 1 to MiMakros.Count - 1 do
  begin
    S1 := IniKmp.ReadString('Makros',
      ShortCutToText(MiMakros.Items[MI].ShortCut), MiMakros.Items[MI].Caption);

    MiMakros.Items[MI].Hint := S1;
    MiMakros.Items[MI].OnClick := MakroClick;
    if MiMakros.Items[MI].Break <> mbNone then
      Break := true;    {bei 2.Spalte muﬂ Tastenk¸rzel manuell angezeigt werden}

    if length(S1) > 20 then
      S1 := copy(S1, 1, 20) + ' ..';
    S2 := ShortCutToText(MiMakros.Items[MI].ShortCut);
    if IsWindows2000 then
      Break := false;   // ab W2k nicht mehr nˆtig
    if Break then            {bei 2.Spalte muﬂ Tastenk¸rzel manuell angezeigt werden}
    begin
      N := TForm(MiMakros.Owner).Canvas.TextWidth(' ') * 10 -
           (TForm(MiMakros.Owner).Canvas.TextWidth(S2) div 2);
      MiMakros.Items[MI].Caption := Format('%s%*s%s', [S2, IMax(1, N), ' ', S1]);
    end else
      MiMakros.Items[MI].Caption := S1;
  end;
end;

procedure TGNavigator.MakroClick(Sender: TObject);
var
  P: integer;
  S: string;
begin
  InSendChar := true;
  try
    GMess0;      {GNavigator.Canceled auf false setzen f¸r SendChar}
    S := TMenuItem(Sender).Hint;
    P := Pos('\r', S);
    while P > 0 do
    begin
      SendChar(Screen.ActiveControl, copy(S, 1, P-1));
      SendMessage(Screen.ActiveForm.Handle, WM_NEXTDLGCTL, 0, 0);
      S := copy(S, P+2, 255);
      P := Pos('\r', S);
    end;
    SendChar(Screen.ActiveControl, S);
  finally
    InSendChar := false;
  end;
end;

procedure TGNavigator.MakroDefineClick(Sender: TObject);
var
  I, MI: integer;
begin
  if MiMakros = nil then
    EError(SGNav_Kmp_030, [0]);		// 'Aufruf "GNavigator.MakroInit" fehlt'
  with TDlgMakro.Create(self) do
  try
    Grid.RowTitles.Clear;
    for Mi := 1 to MiMakros.Count - 1 do
    begin
      I := Mi - 1;
      {Grid.Cells[0,I] := ShortCutToText(MiMakros.Items[I].ShortCut);}
      Grid.RowTitles.Add(ShortCutToText(MiMakros.Items[MI].ShortCut));
      Grid.Cells[1,I] := MiMakros.Items[MI].Hint;
    end;
    if ShowModal = mrOK then
    begin
      for Mi := 1 to MiMakros.Count - 1 do
      begin
        I := Mi - 1;
        MiMakros.Items[MI].Hint := Grid.Cells[1,I];
        IniKmp.WriteString('Makros',
          ShortCutToText(MiMakros.Items[MI].ShortCut), MiMakros.Items[MI].Hint);
        //MiMakros.Items[MI].Caption := copy(MiMakros.Items[MI].Hint, 1, 20) + ' ..';
      end;
      MakroInit(self.MiMakros);
    end;
  finally
    Release;
  end;
end;

function TGNavigator.DbCompare(const S1, S2: string; IgnoreCase: boolean): Integer;
(* vergleicht 2 Strings mit Datenbank-Sortierfolge
   Verwendet OnDbCompare - Ereignis *)
begin
  result := 0;
  if Assigned(FOnDbCompare) then
    FOnDbCompare(S1, S2, IgnoreCase, result) else
  if IgnoreCase then
    result := AnsiCompareText(S1, S2) else                         {ignore case}
    result := AnsiCompareStr(S1, S2);                           {no ignore case}
end;

function TGNavigator.TranslateStr(Sender: TObject; const Src: string): string;
(* ergibt ‹bersetzung eines Strings. Die Realisierung erfolgt anwendungsspezifisch
   im Ereignis OnTranslateStr *)
begin
  if Assigned(FOnTranslateStr) then
  try
    if NoTranslateList.IndexOf(Src) >= 0 then
      result := Src else
      FOnTranslateStr(Sender, Src, result);
  except on E:Exception do
    begin
      EProt(self, E, 'TranslateStr(%.20s)', [Src]);
      result := Src;
    end;
  end else
    result := Src;
end;

type
  TDummyControl = class(TControl);    {Caption sichtbar machen}
  TDummyRadioGroup = class(TCustomRadioGroup);   {Items}

procedure TGNavigator.TranslateComponent(aComponent: TComponent);
var   {Translate Form}
  I1: integer;
  S1: string;
begin
  if aComponent is TCustomForm then
  begin
    if (aComponent is TqForm) and (aComponent <> Application.MainForm) then
      TqForm(aComponent).Caption :=
        TranslateStr(aComponent, TqForm(aComponent).ShortCaption) else
      TCustomForm(aComponent).Caption :=
        TranslateStr(aComponent, TqForm(aComponent).Caption);
  end else
  if aComponent is TTabbedNoteBook then
  begin
    with aComponent as TTabbedNoteBook do
    begin
      for I1:= 0 to Pages.Count-1 do
        Pages.Strings[I1] := TranslateStr(aComponent, Pages.Strings[I1]);
    end;
    //TPagecontrol hat TTabSheets und die werden ¸ber TControl.Caption erledigt
  end else
  if aComponent is TCustomRadioGroup then
  begin
    with TDummyRadioGroup(aComponent) do
    begin
      Caption := TranslateStr(aComponent, Caption);
      if not (aComponent is TAswRadioGroup) then
        for I1:= 0 to Items.Count-1 do
          Items.Strings[I1] := TranslateStr(aComponent, Items.Strings[I1]);
    end;
  end else
  if aComponent is TTabSet then
  begin
    with aComponent as TTabSet do
    begin
      for I1 := 0 to Tabs.Count - 1 do
        Tabs[I1] := TranslateStr(aComponent, Tabs[I1]);
    end;
  end else
  if aComponent is TTabControl then
  begin
    with aComponent as TTabControl do
    begin
      for I1 := 0 to Tabs.Count - 1 do
        Tabs[I1] := TranslateStr(aComponent, Tabs[I1]);
    end;
  end else
  if aComponent is TLNavigator then
  begin  // 16.09.10
    with aComponent as TLNavigator do
    begin
      if BeginsWith(NavLink.TabTitel, ';') then
        S1 := Copy(NavLink.TabTitel, 2, MaxInt) else
        S1 := NavLink.TabTitel;
      NavLink.TrTabTitel := TranslateStr(aComponent, S1);
      //NavLink.Display := TranslateStr(aComponent, NavLink.Display);
      //Keynamen: - 19.12.11
      for I1 := 0 to KeyList.Count - 1 do
      begin
        S1 := StrParam(KeyList[I1]);
        if not SameText(S1, sStandardKey) then
          KeyList[I1] := TranslateStr(aComponent, S1) + '=' + StrValue(KeyList[I1]);
      end;
    end;
  end else
  if aComponent is TLookUpDef then
  begin  // f¸r Tab-Beschriftung in Lookupmodus 16.09.10
    with aComponent as TLookUpDef do
    begin
      if BeginsWith(NavLink.TabTitel, ';') then
        S1 := Copy(NavLink.TabTitel, 2, MaxInt) else
        S1 := NavLink.TabTitel;
      NavLink.TrTabTitel := TranslateStr(aComponent, S1);
      //NavLink.Display := TranslateStr(aComponent, NavLink.Display);
    end;
  end else
  if aComponent is TPrnSource then
  begin
    with aComponent as TPrnSource do
    begin
      Caption := TranslateStr(aComponent, Caption);
      Display := TranslateStr(aComponent, Display);
      if aComponent is TAusw then with aComponent as TAusw do
      begin
        //Labels der Userfields: - 23.01.12
        for I1 := 0 to UserFields.Count - 1 do
        begin
          S1 := StrParam(UserFields[I1]);
          UserFields[I1] := TranslateStr(aComponent, S1) + '=' + StrValue(UserFields[I1]);
        end;
        UserButton1 := TranslateStr(aComponent, UserButton1);
      end;
    end;
  end else
  if aComponent is TMenuItem then
  begin
    with aComponent as TMenuItem do
    begin
      if (Parent <> self.MiMakros) or (ShortCut = 0) then //'Definieren' wird ¸bersetzt
      begin
        Caption := TranslateStr(aComponent, Caption);
        Hint := TranslateStr(aComponent, Hint);
      end else
        Debug0;
    end;
  end else
  if aComponent is TQRSysData then
  begin
    with aComponent as TQRSysData do
    begin
      Text := TranslateStr(aComponent, Text);
    end;
  end else
  if aComponent is TQRLabel then  //08.04.14 keine QRDBEdits usw, also weg mit TQRCustomLabel
  begin
    with aComponent as TQRLabel do
    begin
      Caption := TranslateStr(aComponent, Caption);
    end;
  end else
  if aComponent is TCustomQuickRep then
  begin
    with aComponent as TCustomQuickRep do
    begin
      ReportTitle := TranslateStr(aComponent, ReportTitle);
    end;
  end else
  if aComponent is TTitleGrid then
  begin
    with aComponent as TTitleGrid do
    begin    //Aufbau: Name=Breite. ‹bersetzt wird nur Name - 07.03.04 lawa
      Titles.BeginUpdate;
      try
        for I1 := 0 to Titles.Count - 1 do
        begin
          S1 := TranslateStr(aComponent, StrParam(Titles[I1]));
          AppendTok(S1, StrValue(Titles[I1]), '=');
          Titles[I1] := S1;
        end;
      finally
        Titles.EndUpdate;
      end;
      RowTitles.BeginUpdate;
      try
        for I1 := 0 to RowTitles.Count - 1 do
        begin
          S1 := TranslateStr(aComponent, StrParam(RowTitles[I1]));
          AppendTok(S1, StrValue(RowTitles[I1]), '=');
          RowTitles[I1] := S1;
        end;
      finally
        RowTitles.EndUpdate;
      end;
    end;
  end else
  (* jetzt in MuGriKmp direkt
  if aComponent is TMultiGrid then
  begin
    with aComponent as TMultiGrid do
    begin
      for I1 := 0 to ColumnList.Count-1 do
      begin
        S := ColumnList.Param(I1);
        P := Pos(':', S);
        if P > 0 then
          S1 := TranslateStr(aComponent, copy(S, 1, P- 1)) + copy(S, P, 100) else
          S1 := TranslateStr(aComponent, S);
        if S1 <> S then
          ColumnList[I1] := S1 + '=' + ColumnList.Value(I1);
      end;
    end;
  end else*)
  if aComponent is TCustomEdit then
  begin
    with TCustomEdit(aComponent) do
    begin                {Caption hier nicht da nach Text}
      Hint := TranslateStr(aComponent, Hint);
    end;
  end else
  if aComponent is TCustomComboBox then
  begin
    with TCustomComboBox(aComponent) do
    begin                {Caption hier nicht da nach Text  19.07.03 Lawa}
      Hint := TranslateStr(aComponent, Hint);
    end;
  end else
  if aComponent is TControl then
  begin
    with TDummyControl(aComponent) do
    begin
      Caption := TranslateStr(aComponent, Caption);
      Hint := TranslateStr(aComponent, Hint);
    end;
    if aComponent is TCollapsePanel then
    begin
      with TCollapsePanel(aComponent) do
      begin
        HeaderCaption := TranslateStr(aComponent, HeaderCaption);
      end;
    end;
  end else
  if aComponent is TCustomFrame then
  begin
    //todo -oMD: TFrame
  end;
end;

procedure TGNavigator.TranslateForm(aForm: TCustomForm);
var   {Translate Form}
  I: integer;
begin
  if not Assigned(FOnTranslateStr) then
    Exit;
  TranslateComponent(aForm);
  for I := 0 to aForm.ComponentCount - 1 do
    TranslateComponent(aForm.Components[I]);
end;

procedure TGNavigator.TrInit;
begin      {Translation Init. Von Application erst aufrufen wenn ‹bersetzung mˆglich}
  KmpResStringInit;
  TNavLink.TrInit;    {Titel2, NavLinkStateStr}
  X.TrInit;   // TDBQBENav;
  Asws.TrInit;
end;

function TGNavigator.GetTableSynonym(ATblName: string): string;
begin
  result := TableSynonyms.Values[ATblName];
  if result = '' then
    result := ATblName;
end;

procedure TGNavigator.SetTableSynonym(ATblName: string;
  const Value: string);
begin
  TableSynonyms.Values[ATblName] := Value;
end;

procedure TGNavigator.SetLizenzDatum(aDtmWarn, aDtmSperr: TDateTime);
begin
  LizenzDtWarn := aDtmWarn;
  LizenzDtSperr := aDtmSperr;
end;

function TGNavigator.CheckLizenz(aKurz: string): boolean;
var
  Done: boolean;
begin
  result := true;  //erlauben
  if csDesigning in ComponentState then
    Exit;
  Done := false;
  LizenzDtNow := now;
  if assigned(FOnCheckLizenz) then
  begin
    FOnCheckLizenz(self, '', [0], Done);
  end;
  if not Done and (LizenzDtWarn > 0) and (LizenzDtNow > LizenzDtWarn) then
  begin
    //'Fehler bei Aufruf (%s)'
    ErrWarn(SGNav_Kmp_033, [aKurz]); //DateToStr(LizenzDtWarn) + ',' + DateToStr(LizenzDtSperr)]);
    Inc(LizenzWarnCount);
    if (LizenzDtSperr > 0) and (LizenzDtNow > LizenzDtSperr) and
       (LizenzWarnCount <> Random(MulDiv(LizenzWarnCount + 10, 10, 8))) then
      result := false;  //verbieten
  end;
end;

function TGNavigator.DoOnCheckVersion: boolean;
//Ereignis aufrufen welches die Version ¸berpr¸ft und true bei neuer Version ergibt:
//Quva: Datn.Version.txt vergleichen
begin
  Result := false;
  if Assigned(OnCheckVersion) then
    OnCheckVersion(Self, Result);
end;

function TGNavigator.CheckVersion(aVersion: string; Interval: integer;
  aComment: string = ''): boolean;
//QLoader: ¸berpr¸ft ob <Temp>-exe ungleich <AppDir>-exe
// ber¸cksichtigt auf .ex, .ex_ und .e Extensions
//wenn ja: Meldung
//nur wenn exe in Temp liegt und AppDir ungleich ist
//ergibt true wenn Meldung angezeigt wurde
var
  TempDT, AppDT: TDateTime;
  AppExe, ExeFilename: string;
begin
  Result := false;
  if InCheckVersion then
    Exit;
  if not TicksCheck(CheckVersionStart, Interval) then
    Exit;
  InCheckVersion := true;
  try
    Result := DoOnCheckVersion;

    if not Result and  //nicht per QLoader gestartet (Exe liegt nicht in Temp, kein Vergleich mˆglich)
       not SameText(ValidDir(ExtractFilePath(Application.ExeName)), AppDir) then
    try  //Standard Methode ¸ber Timestamp Vergleich
      TempDT := GetFileDateTime(Application.ExeName);
      ExeFilename := ExtractFilename(Application.ExeName);
      AppExe := AppDir + ExeFilename;
      if not FileExists(AppExe) then       //Extensions von QLoader
      begin
        ExeFilename := StripExtension(ExeFilename) + '.ex';
        AppExe := AppDir + ExeFilename;
        if not FileExists(AppExe) then
        begin
          ExeFilename := StripExtension(ExeFilename) + '.ex_';
          AppExe := AppDir + ExeFilename;
          if not FileExists(AppExe) then
          begin
            ExeFilename := StripExtension(ExeFilename) + '.e';
            AppExe := AppDir + ExeFilename;
          end;
        end;
      end;
      if FileExists(AppExe) then
      begin
        AppDT := GetFileDateTime(AppExe);
        Result := AppDT <> TempDT;
      end;
    except on E:Exception do  //falls AppDir nicht existiert oder Netzwerkfehler o.a.
      EProt(self, E, 'Error: GNavigator.CheckVersion', [0]);
    end;

    if Result then
    begin  //do the job
      //'Eine neue Version wurde installiert (%s). Bitte starten Sie das Programm neu.'
      if DelphiRunning or SysParam.BatchMode then
        ProtLD(SGNav_Kmp_034+CRLF+CRLF+'%s', [aVersion, aComment])  //mit DMess
      else
        WMess(SGNav_Kmp_034+CRLF+CRLF+'%s', [aVersion, aComment]);
      TicksReset(CheckVersionStart);
    end;
  finally
    InCheckVersion := false;
  end;
end;

end.
