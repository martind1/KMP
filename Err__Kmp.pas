unit Err__kmp;
(*
   16.09.98    EDatabaseError bewirkt löschen von FieldDesc
   15.03.03    EIsFieldDescFehler überarbeitet (CompareFmtStr)
   12.09.04    EIsNotNullFehler
   07.10.04    DelphiMess: Fehlermeldung wenn Delphi läuft
   23.04.09    Allgemein-Seite mit Infos bei DBEngineError jetzt immer (wenn not OpenStored) anzeigen
   16.12.11    madExcept Integration: ExceptEvent
   09.02.12    EOutOfMemory: Terminate
   13.01.14    IsFatalError: Terminate (nur durch nl.OnPostError vermeidbar)
*)
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, TabNotBk, SysUtils, Mask, DBCtrls, DB,  Uni, DBAccess, MemDS, ComCtrls,
  {$ifdef madExcept}
  madExcept,
  {$endif}
  Menus, ExtCtrls,
  UQue_Kmp;

type
  (* EInit Exception *)
  EInit = class(Exception);
  EIndexFehler = class(Exception);  //zum Auslösen für EIsIndexFehler

  (* TDlgErr Dialogbox *)
  TDlgErr = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    EdAllgTxt: TMemo;
    DataSource1: TDataSource;
    PopupMenu1: TPopupMenu;
    MiSQL: TMenuItem;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    MiTerminate: TMenuItem;
    Panel2: TPanel;
    EdERRM_NR: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    BtnChange: TBitBtn;
    Panel5: TPanel;
    MemoERRM_BESCHR: TDBMemo;
    Panel6: TPanel;
    MeErrStack: TMemo;
    procedure BtnChangeClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MiSQLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MiTerminateClick(Sender: TObject);
    procedure TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    SqlErr: LongInt;
  end;

  (* TError Komponente *)
  TErrorEvent = procedure (Sender: TObject; E: Exception; var Done: boolean)
    of object; {Definition von einem Funktionspointer}

  TError = class(TComponent)
  private
    FErrTbl: TuQuery;
    FIgnore: boolean;
    FOnError: TErrorEvent; {Pointer auf eine Funktion}
    FOnSocketError: TErrorEvent; {Extrabehandlung in WSDDEKmp}
    TheSender: TObject;
    FOpenStored: boolean;   {gespeicherte Texte anzeigen, wenn vorhanden}        {TS 3.10}
    FDelphiMess: Boolean;
{$ifdef madExcept}
    ErrIntf: IMEException;
    procedure ExceptEvent(const exceptIntf: IMEException; var handled: boolean);
{$endif}
  protected
    InEMess: boolean;
    ErrReport: string;
    fErrStack: string;
    procedure DoError(Sender: TObject; E: Exception; var Done: boolean);
    {Führt die Fehlerbehandlung durch}
  public
    Aktiv: boolean;
    Infos: TStrings;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ErrStack: string;  //19.11.13 hierher
    procedure AppException(Sender: TObject; E: Exception); {Behandlungsroutine für Advanced Exception-Handling}
    procedure SetInfo(AInfo: string); {Zusatzzeile für nächste Fehlermeldung definieren}
    procedure SetInfos(AInfos: TStrings); {Zusatzzeilen für nächste Fehlermeldung defineren}
  published
    property ErrTbl: TuQuery read FErrTbl write FErrTbl; {Error Tabelle}
    property Ignore: boolean read FIgnore write FIgnore; {Flag für Ignorieren von sämtlicher Fehler}
    property OpenStored: Boolean read FOpenStored write FOpenStored; {Flag für Sonderbehandlung}
    property DelphiMess: Boolean read FDelphiMess write FDelphiMess; {Fehlermeldung wenn Delphi läuft}
    property OnError: TErrorEvent read FOnError write FOnError; {Ereigniss für Sonderbehandlung}
    property OnSocketError: TErrorEvent read FOnSocketError write FOnSocketError; {Ereigniss für Sonderbehandlung}
  end;

  (* Exception Handling *)
  procedure ErrException(Sender: TObject; E: Exception);
  {Zugang von aussen für die Standardbehandlung einer Exception
  Korrekte Angabe des Senders(für Sonderbehandlung wichtig)
  kann nur in einem Except-Block aufgerufen werden}
  procedure EMess(Sender: TObject; E: Exception;
                  Fmt: string; const Args: array of const);
  (* Anzeige Exception-Infos wie ErrException aber mit Zusatzinfo *)
  procedure EProt(Sender: TObject; E: Exception;
                  Fmt: string; const Args: array of const);
  (* Ausgabe Exception-Info nach Protokolldatei (mit Zusatzinfo) *)
  procedure EError(const Fmt: string; const Args: array of const);
  {Auslösen einer Exception mit formatierter Textausgabe}

  function EIsIndexFehler(E: Exception): boolean;
  // ergibt true bei Indexfehler 
  function EisBdeFreeDiskError(E: Exception): boolean;
  // ergibt true bei Bde Fehler 'Festplatte voll'
  function EIsFatalFehler(E: Exception): boolean;
  // ergibt true bei Fatelem Fehler (Programm muss beendet werden)
  function EIsFieldDescFehler(E: Exception): boolean;
  // ergibt true bei Fehler in Feldbschreibung (fehlt oder falscher Typ)
  function EIsForeignKeyFehler(E: Exception): boolean;
  // ergibt true bei Hauptdatensatz nicht gefunden (violation of FOREIGN KEY constraint)
  function EIsDeadlockFehler(E: Exception): boolean;
  // ergibt true bei Deadlock Fehler (MSSQL)
  function EIsBlobFehler(E: Exception): boolean;                                {JM 30.01.03}
  // ergibt true bei Fehler 12292. Fehler tritt bei Eingaben in Blobfeldern beim
  //   Insert in Tabellen mit OnInsert-Trigger auf
  function EIsNoSuchTableFehler(E: Exception): boolean;
  // ergibt true wenn Tabelle nicht vorhanden
  function EIsNotNullFehler(E: Exception): boolean;
  // ergibt true wenn NotNull Fehler beim speichern

var
  DlgErr: TDlgErr;
  ErrKmp: TError;

implementation
{$R *.DFM}
uses
  DbiErrs, DbConsts, BdeConst, scktcomp,
  madStackTrace, DAConsts {SCustomUpdateFailed},
  DBGrids, GNav_Kmp, Ini__Kmp, FldDeDlg, Sql__Dlg,
  Prots, KmpResString, Dialogs;

const
  piStack = 2;

constructor TError.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDelphiMess := true;
  Infos := TStringList.Create;
  if ErrKmp <> nil then
  begin
    //raise EInit.Create(SErr__Kmp_001);	// 'Errorkomponente bereits vorhanden'
    ErrWarn('ErrKmp bereits vorhanden', [0]);
  end else
  begin
    ErrKmp := self;
    if not (csDesigning in ComponentState) then
    begin
      {Eine nicht behandelte Exception ruft AppException auf}
      // ohne madExcept:
      Application.OnException := AppException;
{$ifdef madExcept}
      // mit madExcept:
      RegisterExceptionHandler(ExceptEvent, stTrySyncCallOnSuccess, epMainPhase);
{$endif}
    end;
  end;
end;

{$ifdef madExcept}
procedure TError.ExceptEvent(const exceptIntf : IMEException;
                             var handled      : boolean);
begin
  if SysParam.Batchmode then
  begin
    Handled := true;
  end;  //kein else
  if exceptIntf.ExceptObject is Exception then
  begin
    Handled := true;
    ErrIntf := exceptIntf;
    ErrReport := ''; //01.02.12 dauert lang? exceptIntf.BugReport; //ohne Stack
//    ErrStack := '';
    //exceptIntf.ScreenShot.SavePng(AppDir+'SceenShot.png');//I save the PrintScreen
    //exceptIntf.ExceptMessage
    //MESettings.ExceptMsg
    //for I := 0 to exceptIntf.BugReportSections.Itemcount - 1 do
    //nur Thread main:
//erst später wg lazy loading
//    I := 0;
//    begin
//      S1 := exceptIntf.BugReportSections.Items[I];
//      ErrStack := ErrStack + S1 + CRLF +
//                  exceptIntf.BugReportSections.Contents[S1] +  //StackTrace;
//                  CRLF + CRLF;
//    end;
    AppException(exceptIntf.RelatedObject, exceptIntf.ExceptObject as Exception);
//    Handled := WMessYesNo('%s / %s / %s / Handled?', [
//      exceptIntf.ExceptMessage, exceptIntf.ExceptObject.Classname,
//      exceptIntf.RelatedObject.Classname
//      ]) = mrYes;
  end;
end;

function TError.ErrStack: string;
var
  I: integer;
  S1: String;
begin
  if Assigned(ErrIntf) then
  begin
    fErrStack := '';
    ErrIntf.ShowPleaseWaitBox := false;
    ErrReport := String(ErrIntf.BugReport); //ohne Stack
    I := 0;
    begin
      S1 := String(ErrIntf.BugReportSections.Items[I]);
      fErrStack := fErrStack + S1 + CRLF +
                   String(ErrIntf.BugReportSections.Contents[S1]) +  //StackTrace;
                   CRLF + CRLF;
    end;
  end else
  begin
    fErrStack := GetCrashStackTrace;  //19.11.13
  end;
  Result := fErrStack;
end;

{$else}

function TError.ErrStack: string;
begin
  //ohne MadExcept
  Result := '';
end;

{$endif}

destructor TError.Destroy;
begin
  Infos.Free; Infos := nil;
  if ErrKmp = self then
    ErrKmp := nil;
  inherited Destroy;
end;

procedure TError.SetInfo(AInfo: string);
{Zusatzzeile für nächste Fehlermeldung definieren}
begin
  Infos.Clear;
  Infos.Add(AInfo);
end;

procedure TError.SetInfos(AInfos: TStrings);
{Zusatzzeilen für nächste Fehlermeldung defineren}
begin
  Infos.Assign(AInfos);
end;

function CompareFmtString(Fmt, S: string): boolean;
// vergleicht Formatstring Fmt mit einem daraus resultierenden String S
// ergibt true wenn gleich
{ TODO -oMD : auch für %d, %f usw. }
var
  P1: integer;
  S1: string;
begin
  result := true;
  S1 := Fmt;
  P1 := Pos('%s', S1);
  while P1 > 0 do
  begin
    if (P1 > 1) and (Pos(copy(S1, 1, P1 - 1), S) <= 0) then
    begin
      result := false;
      exit;
    end;
    S1 := copy(S1, P1 + 2, MaxInt);
    P1 := Pos('%s', S1);
  end;
  if (S1 <> '') and (Pos(S1, S) <= 0) then
    result := false;
end;

function EIsFieldDescFehler(E: Exception): boolean;
(* ergibt true bei Fehler in Feldbschreibung (fehlt oder falscher Typ) *)
var
  B2, B3: boolean;
begin
  result := false;
  if (E is EDatabaseError) then
  begin
    {Feld '%s' ist nicht vom erwarteten Typ}
    {Unterschiedliche Typen für Feld '%s'; erwartet: %s, gefunden: %s}
    B2 := CompareFmtString(SFieldTypeMismatch, E.Message) or
          CompareFmtString('%s: ' + SFieldTypeMismatch, E.Message);

    {Feld '%s' nicht gefunden}
    B3 := CompareFmtString(SFieldNotFound, E.Message);

    result := B2 or B3;
  end;
end;

function EisBdeFreeDiskError(E: Exception): boolean;
// ergibt true bei Bde Fehler 'Festplatte voll'
begin
  // Errors[0].ErrorCode = DBIERR_NODISKSPACE) then  //$2503 - Zu wenig Festplattenspeicher
  result := false;
end;


function EIsFatalFehler(E: Exception): boolean;
// ergibt true bei Fatelem Fehler (Programm muss beendet werden)
begin
  result := (E is EDAError) and
            EDAError(E).IsFatalError;
end;

function EIsNativeFehler(E: Exception; NativeError: array of integer): boolean;
var
  I: integer;
begin
  Result := false;
  if E is EDAError then
    for I := Low(NativeError) to High(NativeError) do
      if EDAError(E).ErrorCode = NativeError[I] then
      begin
        Result := true;
        break;
      end;
end;

function EIsIndexFehler(E: Exception): boolean;
// ergibt true bei Indexfehler. MSSQL: #2601
begin
  result := (E is EIndexFehler) or  //programmiert ausgelöst
            ((E is EDAError) and
             ((EDAError(E).IsKeyViolation) or
              (Sysparam.MSSQL and (EDAError(E).ErrorCode = 2601)) or
              (Pos(SErr__Kmp_023, E.Message) > 0)));	// 'Doppelter Wert'
end;

function EIsForeignKeyFehler(E: Exception): boolean;
// ergibt true bei Hauptdatensatz nicht gefunden (violation of FOREIGN KEY constraint)
begin
//   (EDAError(E).Errors[0].ErrorCode = DBIERR_FORIEGNKEYERR);  {($2605)}
  result := false;
  { TODO : ErrorCode für ForeignKey Fehler }
end;

function EIsDeadlockFehler(E: Exception): boolean;
// ergibt true bei Deadlock Fehler (MSSQL)
begin
//            (EDAError(E).Errors[0].ErrorCode = DBIERR_DEADLOCK);  {($280F)}
  result := false;
  { TODO : ErrorCode für DeadLock Fehler }
end;

function EIsBlobFehler(E: Exception): boolean;                                  {>JM 30.01.03}
begin
  result := (E is EDAError) and (EDAError(E).ErrorCode = 12292);
end;                                                                            {<JM 30.01.03}

function EIsNoSuchTableFehler(E: Exception): boolean;
// ergibt true wenn Tabelle nicht vorhanden
begin
  result := false;
  Result := Pos('ORA-00942', E.Message) > 0;  //ORA-00942: table or view does not exist
// ErrorCode = DBIERR_NOSUCHTABLE);  {($2728)}
end;

function EIsNotNullFehler(E: Exception): boolean;
// ergibt true wenn NotNull Fehler beim speichern
var
  S1, S2, NextS: string;
begin
  result := false;  //(E is EDAError) and (EDAError(E).);  {($2728)}
  //  ErrorCode = DBIERR_REQDERR);  {($2728)}
  if not result and (E is EDAError) then  //vergl. prots#FocusRequired
  begin
    S1 := PStrTok(E.Message, '''', NextS);
    if S1 <> '' then
    begin
      S2 := PStrTok('', '''', NextS);  //ist Feldname innerhalb ''
      S2 := PStrTok('', '''', NextS);
      if S1 + '''%s''' + S2 = SFieldRequired then
        result := true;
    end;
  end;
  if not result and (E is EDAError) and SysParam.MSSQL and
     (EDAError(E).ErrorCode = 515) then
     //(EDAError(E).Errors[0].ErrorCode = DBIERR_UNKNOWNSQL) and  {($3303)}
     //(EDAError(E).ErrorCount > 1) and
     //(EDAError(E).Errors[1].NativeError = 515) then
  begin //Der Wert NULL kann in die FAHR_NAME-Spalte, SQVA.dbo.FAHR-Tabelle, nicht eingefügt werden. Die Spalte lässt NULL-Werte nicht zu
    result := true;
  end;
  if not result and (E is EDAError) and SysParam.Oracle and
     (EDAError(E).ErrorCode = 1400) then
  begin //ORA-01400: cannot insert NULL into ("schema"."table"."field")
    result := true;
  end;
end;

(* ergibt true bei 'Tabellenende' nach (erfolgreichem) post
function EIsTabellenende(E: Exception): boolean;
begin
  result := (E is EDAError) and
            ((EDAError(E).Errors[0].ErrorCode = DBIERR_KEYVIOL) or
             (Pos('Doppelter Wert', E.Message) > 0));
end;
*)

procedure TError.DoError(Sender: TObject; E: Exception; var Done: boolean);
(* spezielle Fehlerbehandlung, Ereignis aufrufen *)
var
  ADataSet: TDataSet;
begin
  Done := false;
  if assigned(FOnError) then {wenn vom User eine Behandlung vorgesehen wurde}
    FOnError(Sender, E, Done);
  if not Done then
  begin
    if (Sender is TDataSet) then
      ADataSet := TDataSet(Sender) else
    if (Sender is TDBGrid) then
      ADataSet := TDBGrid(Sender).DataSource.DataSet else
      ADataSet := nil;
    if E is EOutOfMemory then
    begin
      ErrWarn('%s'+CRLF+'%s', [E.Message, SErr__Kmp_027]); //'Programm wird beendet'
      Done := true;
      Application.Terminate;
    end else
    if EisFieldDescFehler(E) then
    begin
      //ProtSQL(ADataSet);
      (* Feld "..." ist nicht vom erwarteten Typ * nicht gefunden *)
      ErrWarn('%s' + '%s' + CRLF + '%s',
        [Infos.Text, E.Message, SErr__Kmp_002]); // 'Bitte Operation wiederholen.'
      FieldDescDelete;             {Win32: mit FlushSchemaCache(TblName);}
      Done := true;
    end else
    if EisBdeFreeDiskError(E) then //$2503 - Zu wenig Festplattenspeicher
    begin
      ErrWarn('%s' + '%s' + CRLF + '%s',
        [Infos.Text, E.Message, SErr__Kmp_002]); // 'Bitte Operation wiederholen.'
      FillDiskBde(TempDir);
      Done := true;
    end else
    if E is ESocketError then
    begin               //kommt asynchron. ab 30.09.04 nicht mehr da in wsddekmp abgehandelt
      Done := true;
      Prot0('%s',[E.Message]);
      (* Idee:
      if assigned(FOnSocketError) then {wenn vom User eine Behandlung vorgesehen wurde}
      begin
        FOnSocketError(Sender, E, Done);
      end else
        Prot0('%s',[E.Message]);
      *)
    end else
    if E is EDAError then
    begin
      with E as EDAError do
      begin
        if (ErrorCode = 12289) then
        begin                             {Merkmal nicht verfügbar}  {48/12289.1/0}
          Done := (ADataSet <> nil) and (ADataSet is TuQuery);
          if Done then
          begin
            ErrWarn('%s' + SErr__Kmp_003 + CRLF + // 'Merkmal nicht verfügbar.'
                    SErr__Kmp_004, [Infos.Text]); // 'Tabelle wird auf ReadOnly gesetzt.'
            ProtA('%s', [OwnerDotName(ADataSet)]);
            ProtSql(TuQuery(ADataSet));
            ADataSet.Close;
            TuQuery(ADataSet).RequestLive := false;
            ADataSet.Open;
          end;
        end else
        if (ErrorCode = 9985) then
        begin    //$2701 Zahl außerhalb des gültigen Bereichs - Number is out of range - DBIERR_OUTOFRANGE
          //passiert wenn in CalcList 2 versch. LookupDefs angegeben werden
          Done := true;
          Prot0('%s', [E.Message]);
        end else
        if SysParam.Oracle and
           (ErrorCode = 1410) then
        begin                             {ORA-1410: ungültige ROWID}
        end else
        if {E.}IsFatalError then
        begin
          {  Oracle: OCI_SESSION_KILLED;OCI_NOT_LOGGEDON;OCI_EOF_COMMUNICATION;OCI_NOT_CONNECTED;
             TNS:unable to connect to destination; TNS packet writer failure;
             TNS:listener does not currently know of service; TNS:unable to send break message
             28;1012;3113;3114
             12203;12571;12514;12152  }
          ErrWarn('%s'+CRLF+'%s', [E.Message, SErr__Kmp_027]); //'Programm wird beendet'
          Done := true;
          Application.Terminate;
        end;
        (* todo: bearbeiten für UniDAC:
        if (Errors[0].ErrorCode = DBIERR_INVALIDBLOBHANDLE) then
        begin                             {ungültiges BLOB Handle ($272E) }
          Done := ADataSet <> nil;
          if Done then
          begin
            ErrWarn(SErr__Kmp_005 + CRLF +	// 'Zurückblättern nicht mehr möglich.'
                    SErr__Kmp_006,[0]);		// 'Tabelle wird neu geladen.'
            ADataSet.Close;
            ADataSet.Open;
          end;
        end else
        if (Errors[0].ErrorCode = DBIERR_SEARCHCOLREQD) or {Searchable (Non-blob column) required}
           (Errors[0].ErrorCode = DBIERR_INVALIDFIELDNAME) then {Ungültiger Feldname }
        begin
          FieldDescDelete;             {Win32: mit FlushSchemaCache(TblName);}
          if not InEMess then
          begin
            // Non-blob column in table required to perform operation
            ErrWarn(SErr__Kmp_002 + CRLF +       // 'Bitte Operation wiederholen.'
                    '%s', [E.Message]);
            Done := true;
          end;
        end else
        if Errors[0].ErrorCode = DBIERR_INVALIDXLATION then
        begin              {Translate Error - Translate DID NOT happen ($2723) }
          Done := true;
          if Sender is TComponent then
            ProtL(SErr__Kmp_007,[TComponent(Sender).Name]);	// 'Übersetzungsfehler (%s)'
          Prot0('%s',[E.Message]);
        end else
        if Sysparam.Access and (Sender is TuQuery) and        {von QueryAccepted}
           (ErrorCount > 0) and (Errors[1].NativeError = -3100) and
           (TuQuery(Sender).RequestLive = true) then
        begin
          {Unzulässige Bezugnahme auf Formular: '|'. in '(`tabu_txt`) alike  ('%ram%')'.}
          Done := true;                                 // Abfrage zu komplex
          if WMessYesNo(SErr__Kmp_008 +CRLF+		// 'Abfrage so nicht ausführbar.'
            SErr__Kmp_009,[0]) = mrYes then		// 'Tabelle schreibgeschützt öffnen ?'
          begin
            TuQuery(Sender).RequestLive := false;
          end;
        end else
        if SysParam.Interbase and (ErrorCount > 1) and
           (Errors[1].NativeError = -504) then
        begin                    //Interbase: ungültiger Cursor
          {ADataSet.Close;       //Prior/Next in Except Block
          ADataSet.Open;}
        end;
        *)
      end; {with}
    end else {EDAError}
    if (E is EDatabaseError) and (E.Message = SUpdateFailed) then
    begin
    end else
    if (E is EDatabaseError) and (BeginsWith(E.Message, SCustomUpdateFailed)) then
    begin  //'Update failed'
      Debug0;
    end;
  end; {not done}
  if Done and (Sender is TuQuery) then
    ProtStrings(TuQuery(Sender).SQL);
end;


procedure TError.AppException(Sender: TObject; E: Exception);
(*Zusatzexception-Behandlungsroutine blendet ErrDlg auf *)
var
  I: integer;
  SL: TStringList;
  AField: TField;
  Done: boolean;
  errMessStored : boolean;                {Fehlertext ist in ErrTbl gespeichert} {TS 3.10}
  E_Message: string;
  procedure SLAdd(Modus: integer; AddStr: string);
  var
    S1, NextS: string;
  begin
    S1 := PStrTok(AddStr, CRLF, NextS);
    while S1 <> '' do
    begin
      SL.Add(S1);
      if Modus = 1 then
        ProtA('%s', [S1]);
      S1 := PStrTok('', CRLF, NextS);
    end;  
  end;
begin
  if E is EAbort then                                         {Stille Exception}
    Exit;
  if csDesigning in ComponentState then
  begin
    Application.ShowException(E);                {Standardbehandlung: MsgBox}
    Exit;
  end;
  Screen.Cursor := crDefault;
  TheSender := Sender;
  if GNavigator <> nil then
    GNavigator.Canceled := true;
  if Ignore then
  begin
    Application.ProcessMessages;
    Exit;                    {Globaler Flag: Exceptions ignorieren}
  end;
  E_Message := ConvertEOL(E.Message, osWIN);
  if Aktiv or (csDesigning in ComponentState) then //{or (E.ClassName = Exception.ClassName)} then
  try
    if not SysParam.BatchMode and not (E is ESocketError) then  {ohne Bediener}
    begin
      if Sysparam.ErrTimeout = 0 then
      try
        Inc(Sysparam.ErrTimeout);
        //Application.ShowException(E);  beware! ruft AppException              {Standardbehandlung: MsgBox}
        ErrWarn('%s', [E_Message]);
      finally
        Dec(Sysparam.ErrTimeout);
      end;
    end;
    //if Sender <> nil then
    begin
      Prot0('%s:%s', [OwnerDotName(Sender), E_Message]);
    end;
  except
  end else
  try
    Prot0('%s', [E_Message]);                      {Protokolieren mit TimeStamp}
    Aktiv := true;                         {Semaphore um Rekursion zu vermeiden}
    Done := false;
    try
      DoError(Sender, E, Done);   {Sonderbehandlung und Aufruf des Ereignisses}
    except
    end;
    if not Done then              {Wenn DoError keine Behandlung ausgeführt hat}
    begin
      DlgErr := TDlgErr.Create(Application);            {Error-Dialog erzeugen}
      SL := TStringList.Create;                     {Anlegen einer StringList}
      try
        DlgErr.MeErrStack.Lines.Clear;
//erst später wg lazy loading
//        if ErrStack <> '' then
//        begin                            //madExcept Stacktrace
//          SL.Text := ErrStack;
//          //007b1f5a +41a QuvaE.exe  QrPreDlg  384  +69 TDlgQRPreview.SaveClick
//          //005467a0 +2d4 QuvaE.exe  Controls           TControl.WndProc
//          for I := 0 to SL.Count-1 do
//            if Pos('        ', SL[I]) = 0 then  //nur mit Quelltext-Zeileninfo
//              DlgErr.MeErrStack.Lines.Add(SL[I]);
//          ErrReport := '';
//          ErrStack := '';
//        end;

        SL.Clear;
        for I := 0 to Infos.Count-1 do
          SLAdd(1, Infos.Strings[I]);
        if Infos.Count > 0 then
          SLAdd(0, ' ');
        if E is EDAError then
        begin
          DlgErr.Caption := SErr__Kmp_010;	// 'DBE-Datenbankfehler'
          with E as EDAError do  {beim EDAError Error}
          begin
            DlgErr.SqlErr := ErrorCode;
            SL.Add(E_Message);
            SL.Add('');
            SL.Add(SErr__Kmp_011);	// '(Textende)'

            if (DlgErr.SqlErr <> 0) and (ErrKmp.ErrTbl <> nil) then {Bei SQL_Native-Fehler}
            try
              DlgErr.DataSource1.DataSet := ErrKmp.ErrTbl;

              ErrKmp.ErrTbl.Close;
              ErrKmp.ErrTbl.ParamByName('ERRM_NR').AsString :=
                IntToStr(DlgErr.SqlErr);  {010101 Quva Oracle}
              {Versucht den Fehler aus der Tabelle zu laden}
              ErrKmp.ErrTbl.Open;
              AField := ErrKmp.ErrTbl.FindField('ERRM_ID');
              if AField <> nil then
                AField.Required := false;    {wird expliziet auf NOT (NOT NULL)}
              if ErrKmp.ErrTbl.EOF then      {nicht gefunden}
              begin
                errMessStored := False;						 {TS 3.10}
                ErrKmp.ErrTbl.Last;               {wg.Schlüssel gelöscht fehler}
                ErrKmp.ErrTbl.Insert;
                ErrKmp.ErrTbl.FieldByName('ERRM_NR').AsInteger := DlgErr.SqlErr;
                {Die Fehlernummer belegen}
                  SetFieldText(ErrKmp.ErrTbl.FieldByName('ERRM_BESCHR'),
                    E_Message);           {'(nicht verfügbar)');}
                {Errormessage als 'nicht verfügbar' vorbelegen}
                try
                  {ErrKmp.ErrTbl.Post; {und direkt speichern - nein da sonst nicht mehr änderbar 010398}
                except
                  on E:Exception do Prot0(SErr__Kmp_012,[E_Message]);	// 'Fehler bei ERRM.Post (%s)'
                end;
              (* weg 22.07.01 end else if Infos.Count > 0 then
              begin
                ErrKmp.ErrTbl.Edit;
                {weg 22.07.01 ErrKmp.ErrTbl.FieldByName('ERRM_NR').AsInteger := 0;  {kein DB Fehler}
                SetFieldText(ErrKmp.ErrTbl.FieldByName('ERRM_BESCHR'),
                    GetStringsText(Infos));
              *)
              end else
                errMessStored := True;                                       {TS V3.10}
              DlgErr.Caption := SErr__Kmp_013;		// 'Datenbank meldet Fehler'
              if FOpenStored then                       // Verfahren DEUTAG     {TS V3.10}
              begin
                if (Infos.Count > 0) AND Not errMessStored then
                  DlgErr.TabbedNoteBook1.PageIndex := 0 else {Allgemein-Seite mit Infos}
                  DlgErr.TabbedNoteBook1.PageIndex := 1;     {DB-Seite}
              end else
              begin
                // Allgemein-Seite mit Infos - 23.04.09 jetzt immer
                DlgErr.TabbedNoteBook1.PageIndex := 0;
                
                (*if Infos.Count > 0 then
                  DlgErr.TabbedNoteBook1.PageIndex := 0 else {Allgemein-Seite mit Infos}
                  DlgErr.TabbedNoteBook1.PageIndex := 1;     {DB-Seite}
                *)
              end;
            except
              DlgErr.Caption := SErr__Kmp_013;		// 'Datenbank meldet Fehler'
              DlgErr.TabbedNoteBook1.PageIndex := 0;   {Allgemein-Seite}
              ErrKmp.ErrTbl.Close;
            end else
              DlgErr.TabbedNoteBook1.PageIndex := 0;
          end;
        end else
        begin
          if E is EDatabaseError then {bei EDatabaseError}
            DlgErr.Caption := SErr__Kmp_014 else	// 'Datenbankfehler'
          if E.ClassName = Exception.ClassName then {zB von EError}
            DlgErr.Caption := SErr__Kmp_015 else	// 'Fehlermeldung'
            DlgErr.Caption := SErr__Kmp_016;		// 'Interner Fehler';
          DlgErr.TabbedNoteBook1.PageIndex := 0;
          SL.Add(E_Message);
        end;
        with DlgErr do
        begin  //ab 11.11.08 immer
          if Sender <> nil then
          begin
            SL.Add('----------------------------------------------------');
            SLAdd(1, SErr__Kmp_017 + E.ClassName);		// 'Typ: '
            (*if (Sender is TComponent) and not (Sender is TForm) and
               not (Sender is TApplication) then
              SLAdd(1, SErr__Kmp_018 + OwnerDotName(TComponent(Sender))) else
              SLAdd(1, SErr__Kmp_018 + Sender.ClassName); *)
            SLAdd(1, SErr__Kmp_018 + OwnerDotName(Sender)); // 'von: '
            if (E.ClassType <> EDatabaseError) and
               (Sender is TuQuery) then with Sender as TuQuery do
            begin
              for I := 0 to SQL.Count-1 do
                SLAdd(1, SQL.Strings[I]);           //mit ProtA
              for I := 0 to ParamCount - 1 do
                SLAdd(1, Format(':%s=(%s)', [Params[I].Name, Params[I].AsString]));
            end;
          end;
          //ProtStrings(SL); 31.01.04 ersetzt dur SLAdd
          if DlgErr.MeErrStack.Lines.Count > 0 then
            ProtA('%s', [DlgErr.MeErrStack.Lines.Text]);
          {Zusammenstellung von Zusatzinformationen wie von wem usw}
          if Sysparam.BatchMode or (E is ESocketError) then
          begin
            //ProtStrings(SL);
            {Application.Terminate;    Nicht in Dpe.Erf.Automatik!!!!}
            {if ((E is EAccessViolation) or (E is EOutOfMemory)) then
              ExitWindowsEx(0, EWX_REBOOT);}
          end else
          begin
            EdAllgTxt.Lines.Assign(SL); {Kopieren der Stringliste in Memofeld}
            ShowModal; {Modalanzeigen}
          end;
        end;
      finally
        SL.Free;
        Infos.Clear;
        DlgErr.Free;
      end;
    end;
  finally
    Aktiv := false;
  end;
end;

function NiceErrStack(S: string): string;
//nur mit Quelltext Zeileninfo
var
  SL, SLR: TStringList;
  I: integer;
  S1, NextS: string;
begin
  Result := S;
  SL := TStringList.Create;
  SLR := TStringList.Create;
  try
    SL.Text := S;
    //007b1f5a +41a QuvaE.exe  QrPreDlg  384  +69 TDlgQRPreview.SaveClick
    //005467a0 +2d4 QuvaE.exe  Controls           TControl.WndProc
    //neu:
    //00d51d8d Lawa.exe     ModKmp         4099 TLascaSensor.LoadLascaSample
    //00490238 Lawa.exe     System.Classes      StdWndProc
    //falsch: if Pos('        ', SL[I]) = 0 then  //nur mit Quelltext-Zeileninfo

    for I := 0 to SL.Count-1 do
    begin
      S1 := PStrTok(Copy(SL[I], 10, Maxint), ' ', NextS);  //Pos1-10=Adresse
      while S1 <> '' do
      begin
        if IsNumeric(S1) then
        begin
          SLR.Add(SL[I]);
          Break;
        end;
        S1 := PStrTokNext(' ', NextS);
      end;
    end;
    Result := SLR.Text;
  finally
    SL.Free;
    SLR.Free;
  end;
end;

procedure TDlgErr.TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
//var
//  S1: string;
//  SL: TStringList;
//  I: integer;
begin
  if NewTab = piStack then
  begin
    DlgErr.MeErrStack.Lines.Text := NiceErrStack(ErrKmp.ErrStack);  //nur Zeilen mit Quelltext-Info
//    DlgErr.MeErrStack.Lines.Clear;
//    S1 := ErrKmp.ErrStack;
//    SL := nil;
//    if S1 <> '' then
//    try                       //madExcept Stacktrace
//      SL := TStringList.Create;
//      SL.Text := S1;
//      //007b1f5a +41a QuvaE.exe  QrPreDlg  384  +69 TDlgQRPreview.SaveClick
//      //005467a0 +2d4 QuvaE.exe  Controls           TControl.WndProc
//      for I := 0 to SL.Count-1 do
//        if Pos('        ', SL[I]) = 0 then  //nur mit Quelltext-Zeileninfo
//          DlgErr.MeErrStack.Lines.Add(SL[I]);
//      //ErrReport := '';
//      S1 := '';
//    finally
//      SL.Free;
//    end;
  end;
end;

procedure TDlgErr.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ErrKmp.ErrReport := '';
{$ifdef madExcept}
  ErrKmp.ErrIntf := nil;
{$endif}
  ErrKmp.fErrStack := '';

  if ErrKmp.ErrTbl <> nil then
    ErrKmp.ErrTbl.Close;
end;

procedure TDlgErr.FormCreate(Sender: TObject);
begin if GNavigator <> nil then
  try
    GNavigator.TranslateForm(self);
  except
  end;
end;

procedure TDlgErr.FormShow(Sender: TObject);
begin
  if Sysparam.BatchMode then
  begin
    ProtStrings(EdAllgTxt.Lines);
    ModalResult := mrOK;
    OKBtnClick(self);
  end;
end;

procedure TDlgErr.BtnChangeClick(Sender: TObject);
{Änder des Fehlertextes}
begin
  if (SqlErr <> 0) and (ErrKmp.ErrTbl.FieldByName('ERRM_NR').AsInteger <> 0) then
  begin
    if ErrKmp.ErrTbl.State = dsBrowse then
      ErrKmp.ErrTbl.Edit;
    {ErrKmp.ErrTbl.FieldByName('ERRM_NR').Text := IntToStr(SqlErr);}
    MemoERRM_BESCHR.SetFocus;
    MemoERRM_BESCHR.SelectAll;
  end else
    ErrWarn(SErr__Kmp_019,[0]);		// // 'Ändern hier nicht möglich'
end;

procedure TDlgErr.OKBtnClick(Sender: TObject);
begin
  {Wenn verlassen wird in Edit oder Inser Modus}
  if (ErrKmp.ErrTbl <> nil) and (ErrKmp.ErrTbl.State in [dsEdit,dsInsert]) then
  try
    if ErrKmp.ErrTbl.FieldByName('ERRM_NR').AsInteger <> 0 then
      ErrKmp.ErrTbl.Post;
  except
    if not (csDesigning in ComponentState) then
      TDlgSql.Execute(Application, ErrKmp.ErrTbl, false);
  end;
end;

procedure TDlgErr.MiSQLClick(Sender: TObject);
begin
  if (ErrKmp.TheSender <> nil) and (ErrKmp.TheSender is TuQuery) then
    TDlgSql.Execute(self, TuQuery(ErrKmp.TheSender), false);
end;

(*** ohne Klasse **********************************************************)

procedure ErrException(Sender: TObject; E: Exception);
{Zugang von aussen für die Standardbehandlung einer Exception
 Korrekte Angabe des Senders(für Sonderbehandlung wichtig)
 kann nur in einem Except-Block aufgerufen werden}
begin
  if not (E is EAbort) then
    if ErrKmp <> nil then
    begin
      ErrKmp.AppException(Sender, E);
    end else
      ErrWarn(SErr__Kmp_020,[OwnerDotName(Sender), ConvertEOL(E.Message, osWIN)]);	// 'Fehler in %s: %s'
end;

procedure EMess(Sender: TObject; E: Exception;
                Fmt: string; const Args: array of const);
(* wie ErrException aber mit Zusatzinfo *)
var
  AName: string;
begin
  if not (E is EAbort) then
  begin
    if not (csDesigning in ErrKmp.ComponentState) then
    begin
      EProt(Sender, E, Fmt, Args);  //Listing in Logfile
    end;
    {if PosI('Fehler', Fmt) = 0 then
      Fmt := SErr__Kmp_024 + Fmt;  //'Fehler bei '}
    if (ErrKmp <> nil) and not (csDesigning in ErrKmp.ComponentState) then
    try
      ErrKmp.InEMess := true;
      ErrKmp.SetInfo(FormatTol(Fmt, Args));
      ErrKmp.AppException(Sender, E);
    finally
      ErrKmp.InEMess := false;
    end else
    begin
      (*if Sender = nil then
        AName := 'nil' else
      if (Sender is TComponent) and not (Sender is TForm) and not (Sender is TApplication) then
        AName := (Sender as TComponent).Name else
        AName := Sender.ClassName;*)
      AName := OwnerDotName(Sender);
      ErrWarn('%s'+CRLF+'in %s.'+CRLF+'%s'+CRLF+'%s',
        [FormatTol(Fmt, Args), AName, E.ClassName, ConvertEOL(E.Message, osWIN)]);
    end;
  end;
end;

procedure EProt(Sender: TObject; E: Exception;
                Fmt: string; const Args: array of const);
var
  I: integer;
  S: string;
  //Own: TComponent;
  OldMode, Done: boolean;
begin
  if (ErrKmp <> nil) and ErrKmp.DelphiMess and
     (csDesigning in ErrKmp.ComponentState) then
  begin
    EMess(Sender, E, Fmt, Args);
    Exit;
  end;
  if not (E is EAbort) then
  begin
    OldMode := SysParam.Batchmode;
    if (ErrKmp <> nil) and not (csDesigning in ErrKmp.ComponentState) then
    try  //zB um EisBdeFreeDiskError zu behandeln
      SysParam.Batchmode := true;
      try
        ErrKmp.SetInfo('EProt');
        ErrKmp.DoError(Sender, E, Done);   {Sonderbehandlung und Aufruf des Ereignisses}
      except end;  
    finally
      SysParam.Batchmode := OldMode;
    end;
    S := FormatTol(Fmt, Args);
    AppendTok(S, RemoveCRLF(ConvertEOL(E.Message, osWIN)), ': ');
    SMess('%s', [S]);
    {if PosI('Fehler', Fmt) = 0 then Fmt := SErr__Kmp_024 + Fmt;  //'Fehler bei '}
    Prot0(Fmt, Args);
    ProtA('%s',[E.ClassName]);
    if E is EDAError then
    begin
      with E as EDAError do
        ProtA('$%X SQL: %s', [ErrorCode, ConvertEOL(E.Message, osWIN)]);
    end else
      ProtA('%s',[ConvertEOL(E.Message, osWIN)]);
    if Sender <> nil then
    begin
      (*if (Sender is TComponent) and not (Sender is TForm) and not (Sender is TApplication) and
         (TComponent(Sender).Name <> '') then
      begin
        S := TComponent(Sender).Name;
        Own := TComponent(Sender).Owner;
        if not (Own is TForm) and not (Own is TApplication) and
           (TComponent(Own).Name <> '') then
        begin
          S := Own.Owner.ClassName + '.' + Own.Name + '.' + S;  //Frame
        end else
          S := Own.ClassName + '.' + S;
      end else
        S := Sender.ClassName;*)
      S := OwnerDotName(TComponent(Sender));
      ProtA(SErr__Kmp_022, [S]);	// 'von: %s'
      {if (Sender is TComponent) and not (Sender is TForm) and not (Sender is TApplication) and
         (TComponent(Sender).Name <> '') then
        ProtA(SErr__Kmp_021, [TComponent(Sender).Owner.ClassName, TComponent(Sender).Name]) else // 'von: %s.%s'
        ProtA(SErr__Kmp_022, [Sender.ClassName]);	// 'von: %s'}
      if Sender is TuQuery then
      begin
        ProtStrings(TuQuery(Sender).Sql);
        for I := 0 to TuQuery(Sender).ParamCount - 1 do
          if TuQuery(Sender).Params[I].IsNull then
            ProtA(':%s=null', [TuQuery(Sender).Params[I].Name]) else
          if TuQuery(Sender).Params[I].DataType in [ftString, ftWideString] then
            ProtA(':%s=''%s''', [TuQuery(Sender).Params[I].Name,
              TuQuery(Sender).Params[I].AsString]) else
            ProtA(':%s=%s', [TuQuery(Sender).Params[I].Name, TuQuery(Sender).Params[I].AsString])
      end;
      if Sender is TUniStoredProc then
      begin
        ProtA('%s()', [TUniStoredProc(Sender).StoredProcName]);
        for I := 0 to TUniStoredProc(Sender).ParamCount - 1 do
          ProtA('  %s=[%s]', [TUniStoredProc(Sender).Params[I].Name,
                              TUniStoredProc(Sender).Params[I].Text]);
      end;
    end;
    if ErrKmp <> nil then
    begin
      S := NiceErrStack(ErrKmp.ErrStack);
      if S <> '' then
        ProtA('%s', [S]);
    end;
  end;
end;

procedure EError(const Fmt: string; const Args: array of const);
{Auslösen einer Exception mit formatierter Textausgabe}
begin
  raise Exception.CreateFmt('%s', [FormatTol(Fmt, Args)]);
end;

procedure TDlgErr.MiTerminateClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
