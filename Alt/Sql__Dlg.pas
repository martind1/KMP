unit Sql__dlg;
(* SQL Dialog
   auch für ExecSql
   auch für ausführen von PL/SQL Scripts (veroppelung der ':' z.B. für :new.

   01.08.98 MD   Erstellt (von GNav)
   00.08.98      Execute erweitert; Reiter für Parameter
   31.10.98      File Load / Save    : über rechte Maustaste
                 Batchverarbeitung: Trenner ist ';'
                                           oder '/' wenn Passthrough SQL
                                    Kommentare: '--' am Zeilenanfang
                                           oder '/*' am Zeilenanfang
                                           oder show errors;
   25.04.00      Auswahl DataSet (mit rechter Maustaste)
   28.10.00      Show (statt Showmodal)
   01.03.01      ExecList: Strings/File ausführen
   13.09.02      Bug bei ExecList. Kam zu früh zurück
   22.04.03      TMultiGrid (Kopie to HTML u.a.)
   29.11.04      Historie
   06.06.09      MiLoopSql
   03.11.11 md   UniDAC. Kein Export mehr.
   30.12.11 md   PassthroughSQL dient nur noch zur Blocktrennung (kein : -> :: mehr)
                 exec: warten bis form=nil (sonst seltsames Verhalten: App verschwindet)
   11.11.12 md   MiProcClick: PrepareSQL - notwendig für UniDAC
   05.09.13 md   Parameter werden nicht gleich angezeigt: Wechsel auf TPageControl
*)
interface

uses
  ComCtrls,
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls,
  Qwf_Form, DB, Uni, DBAccess, MemDS, Grids, DBGrids, ExtCtrls, TabNotBk, Menus,
  TgridKmp, Dialogs, DBCtrls, Mugrikmp, qSplitter, UQue_Kmp, UPro_Kmp;

type
  TSqlExecModus = set of (semIgnore, semSilent);
type
  TDlgSql = class(TqForm)
    DataSource1: TDataSource;
    Panel1: TPanel;
    Bevel1: TBevel;
    BtnOpen: TBitBtn;
    BtnCancel: TBitBtn;
    BtnExecSQL: TBitBtn;
    RbLive: TCheckBox;
    PopupMenu1: TPopupMenu;
    MiRequestLive: TMenuItem;
    MiPassthroughSQL: TMenuItem;
    N1: TMenuItem;
    MiFileOpen: TMenuItem;
    MiFileSave: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    MiSqlDelete: TMenuItem;
    N2: TMenuItem;
    MiProtBeforeOpen: TMenuItem;
    MiAlterColumn: TMenuItem;
    MiDisconnect: TMenuItem;
    MiDataSet: TMenuItem;
    MiDuplicates: TMenuItem;
    MiExplainPlan: TMenuItem;
    Transaktion1: TMenuItem;
    MiTransactionStart: TMenuItem;
    MiTransactionCommit: TMenuItem;
    MiTransactionRollBack: TMenuItem;
    MiProc: TMenuItem;
    MiUnidirectional: TMenuItem;
    Oracle1: TMenuItem;
    MiOraCompileInvalidObjects: TMenuItem;
    PopupMenu2: TPopupMenu;
    MiMarkAll: TMenuItem;
    N3: TMenuItem;
    MiLoopSql: TMenuItem;
    Query1: TuQuery;
    QueLoop: TuQuery;
    StoredProc1: TuStoredProc;
    Detailbook: TPageControl;
    tsSQL: TTabSheet;
    TsErgebnis: TTabSheet;
    tsParameter: TTabSheet;
    tsSkripte: TTabSheet;
    tsHistorie: TTabSheet;
    SqlMemo: TMemo;
    DBNavigator1: TDBNavigator;
    Mu1: TMultiGrid;
    GridParams: TTitleGrid;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    LbAlterColumn: TListBox;
    TabSheet2: TTabSheet;
    LbAlterColumnMsSql: TListBox;
    TabSheet3: TTabSheet;
    LbAlterColumnOra: TListBox;
    TabSheet4: TTabSheet;
    LbDuplicates: TListBox;
    tsOraObjects: TTabSheet;
    lbOraObjects: TListBox;
    Panel2: TPanel;
    LaHistPos: TLabel;
    BtnHistPrior: TBitBtn;
    BtnHistNext: TBitBtn;
    MeHistResult: TMemo;
    qSplitter1: TqSplitter;
    MeHistSql: TMemo;
    procedure BtnExecSQLClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MiRequestLiveClick(Sender: TObject);
    procedure MiPassthroughSQLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Query1AfterOpen(DataSet: TDataset);
    procedure MiFileOpenClick(Sender: TObject);
    procedure MiFileSaveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MiSqlDeleteClick(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure MiProtBeforeOpenClick(Sender: TObject);
    procedure MiAlterColumnClick(Sender: TObject);
    procedure MiDisconnectClick(Sender: TObject);
    procedure MiDataSetClick(Sender: TObject);
    procedure BtnOpenClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MiDuplicatesClick(Sender: TObject);
    procedure MiExplainPlanClick(Sender: TObject);
    procedure MiTransactionStartClick(Sender: TObject);
    procedure MiTransactionCommitClick(Sender: TObject);
    procedure MiTransactionRollBackClick(Sender: TObject);
    procedure MiProcClick(Sender: TObject);
    procedure MiUnidirectionalClick(Sender: TObject);
    procedure BtnHistPriorClick(Sender: TObject);
    procedure BtnHistNextClick(Sender: TObject);
    procedure MiOraCompileInvalidObjectsClick(Sender: TObject);
    procedure MiMarkAllClick(Sender: TObject);
    procedure MiLoopSqlClick(Sender: TObject);
    procedure DetailbookChanging(Sender: TObject; var AllowChange: Boolean);
    procedure DetailbookChange(Sender: TObject);
  private
    FHistIndex: integer;
    function GetHistIndex: integer;
    procedure SetHistIndex(const Value: integer);
    procedure ShowHistIndex;
    procedure AlterColumn(S: string);
    function ExecSQLMemo: string;
    function CompileInvalidOraObjects: integer;
    function QueryIsDDL(AQuery: TuQuery): boolean;
  private
    { Private declarations }
    Opened: boolean;
    SqlBuffPtr: integer;
    SqlBuff: TStrings;
    ModifyBuff: TStrings;
    SqlMemoBuff: TStrings;
    CallerQuery: TuQuery;
    CallerSql: TPersistent;
    SqlOK, CanOpen, CallerActive: boolean;
    BtnExecSQLCaption: string;
    ExecSqlFlag: bool;
    Modus: TSqlExecModus;
    SqlError: boolean;
    OldTab: TTabSheet;

    TblStr, FldStr, FmtStr, NeuStr: string;        {für AlterColumn}
    ProcStr: string;                               {für MiProc}
    function SqlNextStmt: boolean;
    //procedure IbReconnect;
    procedure ShowDb;
    property HistIndex: integer read GetHistIndex write SetHistIndex;
  public
    { Public declarations }
    class procedure Execute(Sender: TObject; AQuery: TuQuery; OpenEnabled: boolean);
    class function ExecList(DbName: string; Lines: TStrings; aModus: TSqlExecModus): boolean; overload;
    class function ExecList(Lines: TStrings; aModus: TSqlExecModus): boolean; overload;
    class procedure CheckVisible;             {für qwf_form}
    class function OraCompileInvalidObjects(DbName: string;
      aModus: TSqlExecModus): boolean;
    (* SQL Dialog *)
  end;

type
  THistorieEl = record
                  Sql: string;
                  Result: string;
                end;
  PHistorieEl = ^THistorieEl;
  THistorie = class(TObject)
  private
    Elements: TList;
  public
    function Add(S: string): integer;  //ergibt Handle
    procedure SetResult(H: integer; S: string);
    function Count: integer;
    function Sql(Index: integer): string;
    function Result(Index: integer): string;
    constructor Create;
    destructor Destroy; override;
  end;

var
  DlgSql: TDlgSql;
  Historie: THistorie;

implementation
{$R *.DFM}
uses
  SysUtils, Messages,
  Err__Kmp, Prots, GNav_Kmp, NStr_Kmp, Str__Dlg, DPos_Kmp,
  UDB__Kmp, USes_Kmp,
  NLnk_Kmp, KmpResString, MemoDlg;

//const
//  nbSql = 0;
//  nbErgebnis = 1;
//  nbParameter = 2;
//  nbSkripte = 3;
//  nbHistorie = 4;

var
  GlobalInitialDir: string = '';
  GlobalFileName: string = '';

class procedure TDlgSql.CheckVisible;
begin                     {Anzeige SQL-Dialog wenn verborgen (z.B. nach Export)}
  if DlgSql <> nil then
    DlgSql.Show;
end;

class function TDlgSql.ExecList(Lines: TStrings; aModus: TSqlExecModus): boolean;
begin
  result := ExecList('DB1', Lines, aModus);
end;

class function TDlgSql.ExecList(DbName: string; Lines: TStrings; aModus: TSqlExecModus): boolean;
// SQL Script in Strings ausführen. Ergbit true bei Erfolg
var
  I, T1: integer;
begin
  if DlgSql <> nil then
    Application.ProcessMessages;  //close vom letzten Aufruf beenden
  SMess('SQL Script', [0]);
  TDlgSql.Execute(nil, nil, false);
  DlgSql.SqlError := false;
  DlgSql.Query1.DatabaseName := DbName;
  DlgSql.ShowDB;
  DlgSql.Modus := aModus;
  DlgSql.SqlMemo.Lines.Assign(Lines); {Schreiben}
  DlgSql.MiPassthroughSQL.Checked := false;
  for I := 0 to DlgSql.SqlMemo.Lines.Count - 1 do
    if Trim(DlgSql.SqlMemo.Lines[I]) = '/' then
      DlgSql.MiPassthroughSQL.Checked := true;
  //Versuch 31.12.11 statt Postmessage - DlgSql.ExecSqlFlag := true;   //nach Ausführung schließen - 31.12.11
  DlgSql.BtnExecSQL.Click;
  result := not DlgSql.SqlError;

  //bei Fehler stehenbleiben
  PostMessage(DlgSql.Handle, WM_COMMAND, 0, DlgSql.BtnCancel.Handle);
  TicksReset(T1);
  while (DlgSql <> nil) and (TicksDelayed(T1) < 5000) do   //5s max warten bis frei
    Application.ProcessMessages;
  SMess0;
end;

class function TDlgSql.OraCompileInvalidObjects(DbName: string; aModus: TSqlExecModus): boolean;
// Kompiliert invalide Trigger, Proc und Views. Ergibt false bei Fehler.
var
  N, T1: integer;
begin
  result := true;
  SMess('SQL Script', [0]);
  TDlgSql.Execute(nil, nil, false);
  DlgSql.Query1.DatabaseName := DbName;
  DlgSql.ShowDB;
  DlgSql.Modus := aModus;

  N := 0;  //bis zu 4mal wiederholen (war Bug zu wenig Wdhlgs)
  while (N < 4) and Result and (DlgSql.CompileInvalidOraObjects > 0) do
  begin
    Inc(N);
    Prot0('OraCompileInvalidObjects(%d)', [N]);
    DlgSql.SqlError := false;
    DlgSql.BtnExecSQL.Click;
    result := not DlgSql.SqlError;
  end;

  //bei Fehler stehenbleiben
  PostMessage(DlgSql.Handle, WM_COMMAND, 0, DlgSql.BtnCancel.Handle);  //wegblenden
  TicksReset(T1);
  while (DlgSql <> nil) and (TicksDelayed(T1) < 5000) do   //5s max warten bis frei
    Application.ProcessMessages;
  SMess0;
end;

class procedure TDlgSql.Execute(Sender: TObject; AQuery: TuQuery; OpenEnabled: boolean);
// SQL Dialog starten (bleibt geöffnet)
begin
  if DlgSql = nil then
  begin
    TDlgSql.Create(Application.MainForm);
    if Sender is TControl then
    begin
      DlgSql.Left := TControl(Sender).Left; {Koordinaten}
      DlgSql.Top := TControl(Sender).Top + 50;
    end;

    DlgSql.SqlOK := true;
    DlgSql.CanOpen := OpenEnabled;
    DlgSql.CallerQuery := AQuery;
    if Aquery <> nil then
    begin
      DlgSql.CallerActive := AQuery.Active;
      DlgSql.CallerSql.Assign(AQuery.SQL); {SQL-abspeichern}

      DlgSql.SqlMemo.Lines.Assign(AQuery.SQL); {Schreiben}
      SendMessage(DlgSql.SqlMemo.Handle, EM_LINESCROLL, 0, 999);

      DlgSql.RbLive.Checked := AQuery.RequestLive; {Request Live übernehmen}
      DlgSql.MiUnidirectional.Checked := AQuery.Unidirectional;
      DlgSql.Query1.Params.Assign(AQuery.Params);
      //keine Dupl DB - create view wurde nicht ausgeführt (ohne Fehler)
      GNavigator.SetDuplDB(DlgSql.Query1, QueryDatabase(AQuery), 4);  //23.05.09: Special Database
      //DlgSql.Query1.SessionName := AQuery.SessionName;
      //DlgSql.Query1.DatabaseName := AQuery.DatabaseName;
      DlgSql.ShowDb;
    end;
    DlgSql.BtnOpen.Enabled := OpenEnabled and (AQuery <> nil);      {250400}
    DlgSql.MiRequestLive.Checked := DlgSql.RbLive.Checked;
  end;
  DlgSql.Show;
end;

procedure TDlgSql.FormCreate(Sender: TObject);
begin
  DlgSql := self;
  DetailBook.ActivePage := tsSql;
  CallerSql := TStringList.Create; {= TqStringList}
  SqlBuff := TStringList.Create;
  ModifyBuff := TStringList.Create;
  SqlMemoBuff := TStringList.Create;
  SqlError := false;
  HistIndex := -1;
  //GNavigator.NoTranslateList.Add(MeAlterColumn.Lines.Text); nicht notwendig
  GNavigator.TranslateForm(self);
  BtnExecSQLCaption := BtnExecSQL.Caption;
end;

procedure TDlgSql.FormDestroy(Sender: TObject);
begin
  SqlBuff.Free;
  ModifyBuff.Free;
  SqlMemoBuff.Free;
  CallerSql.Free;
  DlgSql := nil;
end;

procedure TDlgSql.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDlgSql.BtnOpenClick(Sender: TObject);
begin
  if CallerQuery <> nil then
  begin                                      {Open gedrückt}
    SqlOK := true;
    try
      CallerQuery.Close;
      CallerQuery.SQL.Assign(SqlMemo.Lines); {Mit Werten füllen}
      Prot0('Open:', [0]);
      ProtStrings(SqlMemo.Lines);
      CallerQuery.RequestLive := RbLive.Checked; {request live belegen}
      CallerQuery.Unidirectional := MiUnidirectional.Checked;
      CallerQuery.Open;                                 {Browse und Laden}
      Prot0('OK', [0]);
      Close;
    except
      on E:Exception do
      begin
        Prot0('%s', [E.Message]);
        ErrException(CallerQuery, E);
        SqlOK := false;
      end;
    end;
  end;
end;

procedure TDlgSql.BtnCancelClick(Sender: TObject);
begin          {Abbruch wurde betätigt}
  if BtnExecSQL.Caption = BtnExecSQLCaption then   //von BtnExecSql
  try
    if (CallerQuery <> nil) and not CallerQuery.Active then
    begin
      if CanOpen then
        CallerQuery.SQL.Assign(CallerSQL as TStrings);
      CallerQuery.RequestLive := DlgSql.RbLive.Checked; {request live belegen}
      CallerQuery.Unidirectional := DlgSql.MiUnidirectional.Checked;
      CallerQuery.Active := CallerActive;              {Browse und Laden}
      self.Close;
    end else
      self.Close;
  except on E:Exception do
    begin
      CallerQuery := nil;
      EProt(CallerQuery, E, SSql_Dlg_001, [0]);		// 'Schließen'
      self.Close;
    end;
  end else
    ExecSqlFlag := true;
end;

function TDlgSql.SqlNextStmt: boolean;
(* Kopiert nächstes Statement von SqlBuff nach SqlMemo. *)
var
  I, CntrAll, CntrAdd: integer;
  S, S1: string;
  S2, NextS: string;
  BreakChar: char;
  InRem: boolean;
  P1, P2: integer;
begin
  InRem := false;
  CntrAll := 0;
  CntrAdd := 0;
  if MiPassthroughSQL.Checked then
    BreakChar := '/' else
    BreakChar := ';';
  for I := SqlBuffPtr to SqlBuff.Count - 1 do
  begin
    Inc(CntrAll);
    S := SqlBuff[I];
    S1 := Trim(S);
    if InRem then
    begin
      if (Pos('*/', S1) > 0) then
        InRem := false;
      continue;
    end;
    if (S1 = '') or BeginsWith(S1, '--') or
       BeginsWith(S1, 'show errors', true) or
       BeginsWith(S1, '/*') or
       BeginsWith(S1, 'PROMPT', true) or
       BeginsWith(S1, 'REM', true) then
    begin
      if (copy(S1, 1, 2) = '/*') and (Pos('*/', S1) = 0) then
        InRem := true;
      continue;
    end;
    if BeginsWith(S, '@modify', true) then    //@modify tbl;fld;fmt
    begin
      PstrTok(S, ' ', NextS);
      S2 := PstrTok('', ' ', NextS);
      AlterColumn(S2);  //->SqlMemo
      ModifyBuff.AddStrings(SqlMemo.Lines);   //<- SqlMemo
      SqlMemo.Lines.Clear;
    end else
    begin
      //Kommentare mitten in einer Zeile
      P1 := Pos('--', S);
      if P1 > 0 then
        System.Delete(S, P1, MaxInt);
      while true do
      begin
        P1 := Pos('/*', S);
        P2 := Pos('*/', S);
        if (P1 > 0) and (P2 > P1) then
          System.Delete(S, P1, P2 - P1 + 2) else
          Break;
      end;
      if Trim(S) = '' then
        Continue;

//UniDAC: weg  if MiPassthroughSQL.Checked then
//               S := StrCgeStr(S, ':', '::');
      S := RTrim(S);
      result := CharN(S) = BreakChar;
      if result then
        System.Delete(S, length(RTrim(S)), 1);
      if CntrAdd = 0 then
        SqlMemo.Lines.Clear;
      Inc(CntrAdd);
      SqlMemo.Lines.Add(RemoveTrailCrlf(S));
      if result then
      begin
        {if SysParam.Interbase and (PosI('drop constraint', SqlMemo.Lines.Text) > 0) then
          IbReconnect;} //MiDisconnectClick(SqlMemo);
        Break;
      end;
    end;
  end;
  Inc(SqlBuffPtr, CntrAll);
  result := CntrAdd > 0;
end;

function TDlgSql.QueryIsDDL(AQuery: TuQuery): boolean;
var
  S: string;
begin
  S := AQuery.Text;
  Result := (PosI('create', S) > 0) or
            (PosI('drop', S) > 0) or
            (PosI('alter', S) > 0);
end;

function TDlgSql.ExecSQLMemo: string;
// ergibt '' wenn kein Stmnt ausgeführt; 'OK' wenn ausgeführt; sonst Fehlertext
var
  I: integer;
  NRows, NRows1: integer;
begin
  SqlBuff.Assign(SqlMemo.Lines);
  SqlBuffPtr := 0;
  result := '';
  I := 0;
  NRows := 0;
  try
    while SqlNextStmt do  //nach SqlMemo
    begin
      if I = 0 then
        result := 'OK';
      Inc(I);
      NRows1 := 0;
      BtnExecSQL.Caption := 'SQL (' + IntToStr(I) + ')';
      GNavigator.ProcessMessages;                {Anzeigen}
      Query1.SQL.Assign(SqlMemo.Lines);
      if Query1.SQL.Count > 0 then
      try
        ProtL('ExecSql[%s]:', [QueryServerName(Query1)]);
        ProtStrings(Query1.SQL);
        HistIndex := Historie.Add(Query1.Text);
        if QueryIsDDL(Query1) then  //create,drop,..
          Query1.ExecSql else
          NRows1 := QueryExecCommitted(Query1);  //Commit wenn InTransaction und Shared NoAutocommit eingestellt.
        Historie.SetResult(HistIndex, 'OK');
        if NRows1 > 0 then  //RowsAffected
        begin
          NRows := NRows +  NRows1;
          ProtL('OK %d Rows affected', [NRows1]);  //pro Statement
          Result := Format('OK (%d Rows affected)', [NRows]);  //Für Meldungsfenster Gesamtsumme
        end else
          ProtL('OK', [0]);
      except on E:Exception do
        begin
          Historie.SetResult(HistIndex, E.Message);
          SqlError := true;
          ProtL('%s', [E.Message]);
          result := E.Message;
          if not (semIgnore in Modus) then
            if WMessYesNo('%s' + CRLF + SSql_Dlg_002, [result]) <> mrYes then		// 'Ignorieren ?'
              raise;
        end;
      end;
    end;
  except on E:Exception do
    if not (semIgnore in Modus) then
      EMess(Query1, E, 'ExecSQL', [0]);
  end;
  SqlMemo.Lines.Assign(SqlBuff);
end;

procedure TDlgSql.BtnExecSQLClick(Sender: TObject);
var
  T1: longint;
  S1: string;
begin
  Screen.Cursor := crHourGlass;
  Query1.RequestLive:= false;

  TicksReset(T1);
  S1 := '';
  SqlMemoBuff.Assign(SqlMemo.Lines);
  BtnExecSQL.Caption := 'SQL';  //wichtig wg BtnCancel wenn nix auszuführen
  S1 := ExecSqlMemo;
  while ModifyBuff.Count > 0 do
  begin
    SqlMemo.Lines.Assign(ModifyBuff);
    ModifyBuff.Clear;
    S1 := S1 + CRLF + ExecSqlMemo;
  end;
  SqlMemo.Lines.Assign(SqlMemoBuff);

  if not (semSilent in Modus) and (S1 <> '') then
    WMess('ExcecSQL: %.60s' + CRLF + '%d ms', [S1, TicksDelayed(T1)]);
  Screen.Cursor := crDefault;
  BtnExecSQL.Caption := BtnExecSQLCaption;
  if ExecSqlFlag then  //bereits auf Abbruch gedrückt bzw. per Postmessage drücken lassen
    PostMessage(DlgSql.Handle, WM_COMMAND, 0, BtnCancel.Handle);
end;

procedure TDlgSql.DetailbookChange(Sender: TObject);
var
  I: integer;
  T1: longint;
  NewTab: TTabSheet;
begin
  NewTab := TPageControl(Sender).ActivePage;
  if OldTab = tsHistorie then
  begin
    SqlMemo.Lines.Assign(MeHistSql.Lines);
  end;
  if NewTab = tsHistorie then
  begin
    ShowHistIndex;   //Anzeige aktualisieren
  end;
  TicksReset(T1);
  if (NewTab = tsErgebnis) or (NewTab = tsParameter) then
  begin
    SqlBuff.Assign(SqlMemo.Lines);
    SqlBuffPtr := 0;
    SqlNextStmt;   //';' o.ä entfernen
    Query1.SQL.Assign(SqlMemo.Lines);
    Query1.RequestLive:= RbLive.Checked;
    Query1.Unidirectional := MiUnidirectional.Checked;
    if NewTab = tsErgebnis then
    try
      Prot0('Open Sql:', [0]);
      ProtStrings(Query1.SQL);
      HistIndex := Historie.Add(Query1.Text);
      Query1.Open;
      Historie.SetResult(HistIndex, 'OK');
    except on E:Exception do
      begin
        Historie.SetResult(HistIndex, E.Message);
        EMess(Query1, E, 'Open Sql', [0]);
        TPageControl(Sender).ActivePage := OldTab;
      end;
    end;
    if NewTab = tsParameter then            {Params anzeigen}
    begin
      if Query1.ParamCount > 0 then
      begin
        GridParams.RowCount := Query1.ParamCount + 1;
        for I := 0 to Query1.ParamCount - 1 do
        begin
          GridParams.Cells[0, I+1] := ':' + Query1.Params[I].Name;
          if Query1.Params[I].IsNull then
            GridParams.Cells[1, I+1] := 'null' else
          if Query1.Params[I].DataType in [ftString, ftWideString] then
            GridParams.Cells[1, I+1] := '''' + Query1.Params[I].Text + '''' else
            GridParams.Cells[1, I+1] := Query1.Params[I].Text;
        end;
        {GridParams.AdjustColWidths;}
      end else
        GridParams.RowCount := 2;
        { TODO : GridParams mit TTitleGrid wiederherstellen }
      GridParams.AdjustColWidths;
    end;
  end;
  if NewTab <> tsErgebnis then
  begin
    Query1.Close;
  end else
  begin
    DetailBook.Hint := Format(SSql_Dlg_003, [TicksDelayed(T1)]);	// 'Zeitdauer: %d ms'
  end;
end;

procedure TDlgSql.DetailbookChanging(Sender: TObject; var AllowChange: Boolean);
begin
  OldTab := TPageControl(Sender).ActivePage;
end;

procedure TDlgSql.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := BtnCancel.ModalResult;
end;

procedure TDlgSql.MiRequestLiveClick(Sender: TObject);
begin
  MiRequestLive.Checked := not MiRequestLive.Checked;
  RbLive.Checked := MiRequestLive.Checked;
end;

procedure TDlgSql.MiUnidirectionalClick(Sender: TObject);
begin
  MiUnidirectional.Checked := not MiUnidirectional.Checked;
end;

procedure TDlgSql.MiPassthroughSQLClick(Sender: TObject);
begin
  MiPassthroughSQL.Checked := not MiPassthroughSQL.Checked;
  RbLive.Checked := MiRequestLive.Checked;
end;

procedure TDlgSql.Query1BeforeOpen(DataSet: TDataSet);
var
  AParamName: string;
  I: integer;
begin
  Mu1.ColumnList.Clear;
  if CallerQuery <> nil then
  begin
    if Query1.ParamCount > 0 then
      for I := 0 to Query1.ParamCount - 1 do
      try
        AParamName := Query1.Params[I].Name;
        Query1.Params[I].Assign(CallerQuery.ParamByName(AParamName));
      except on E:Exception do
        EProt(CallerQuery, E, 'SqlDlg', [0]);
      end;
  end;
end;

procedure TDlgSql.Query1AfterOpen(DataSet: TDataset);
begin
  Opened := true;
end;

procedure TDlgSql.MiFileOpenClick(Sender: TObject);
var
  I: integer;
begin
  with OpenDialog1 do
  begin
    InitialDir := GlobalInitialDir;
    FileName := GlobalFileName;
    if InitialDir = '' then
      InitialDir := AppDir;
    if Execute then
    begin
      GlobalInitialDir := ExtractFilePath(FileName);
      GlobalFileName := ExtractFileName(FileName);
      Caption := LongCaption(Caption, GlobalFileName);
      SqlMemo.Lines.LoadFromFile(FileName);
      MiPassthroughSQL.Checked := false;
      for I := 0 to SqlMemo.Lines.Count - 1 do
        if Trim(SqlMemo.Lines[I]) = '/' then
          MiPassthroughSQL.Checked := true;
    end;
  end;
end;

procedure TDlgSql.MiFileSaveClick(Sender: TObject);
begin
  with SaveDialog1 do
  begin
    InitialDir := GlobalInitialDir;
    FileName := GlobalFileName;
    if InitialDir = '' then
      InitialDir := AppDir;
    FileName := OpenDialog1.FileName;
    if Execute then
    begin
      GlobalInitialDir := ExtractFilePath(FileName);
      GlobalFileName := ExtractFileName(FileName);
      Caption := LongCaption(Caption, GlobalFileName);
      SqlMemo.Lines.SaveToFile(FileName);
    end;
  end;
end;

procedure TDlgSql.MiSqlDeleteClick(Sender: TObject);
begin
  SqlMemo.Lines.Clear;
  //ActiveControl := SqlMemo;
  try
    SqlMemo.SetFocus;
  except
  end;
end;

procedure TDlgSql.MiExplainPlanClick(Sender: TObject);
begin
  if CompareText(copy(SqlMemo.Lines.Text, 1, 6), 'select') = 0 then
  begin
    SqlMemo.Lines.Insert(0, 'EXPLAIN PLAN FOR');
    MiExplainPlan.Checked := true;
  end else
    MiExplainPlan.Checked := false;
end;

procedure TDlgSql.PopupMenu1Popup(Sender: TObject);
begin
  MiProtBeforeOpen.Checked := SysParam.ProtBeforeOpen;
  MiProtBeforeOpen.Checked := SysParam.ProtBeforeOpen;
end;

procedure TDlgSql.MiProtBeforeOpenClick(Sender: TObject);
begin
  MiProtBeforeOpen.Checked := not MiProtBeforeOpen.Checked;
  SysParam.ProtBeforeOpen := MiProtBeforeOpen.Checked;
  PostMessage(Handle, WM_COMMAND, 0, BtnCancel.Handle);
end;

procedure TDlgSql.AlterColumn(S: string);
{ erzeugt Sqlbefehle für Spaltenänderungen gemäß S in SqlMemo }
var
  NextS: string;
  I: integer;
  ATemplate: TStrings;
begin
  if SysParam.Oracle then
    ATemplate := LbAlterColumnOra.Items else
  if SysParam.MSSQL then
    ATemplate := LbAlterColumnMsSql.Items else
    ATemplate := LbAlterColumn.Items;
  TblStr := PStrTok(S, ';', NextS);
  FldStr := PStrTok('', ';', NextS);
  FmtStr := PStrTok('', ';', NextS);
  NeuStr := PStrTok('', ';', NextS);
  SqlMemo.Clear;
  MiPassthroughSQL.Checked := false;
  for I := 0 to ATemplate.Count - 1 do
  begin
    S := StrCgeStrStr(ATemplate[I], '#Table#', TblStr, true);
    S := StrCgeStrStr(S, '#Col#', FldStr, true);
    S := StrCgeStrStr(S, '#Format#', FmtStr, true);
    if NeuStr <> '' then
      S := StrCgeStrStr(S, '#Neu#', NeuStr, true) else
      S := StrCgeStrStr(S, '#Neu#', FldStr, true);
    SqlMemo.Lines.Add(S);
    if Trim(S) = '/' then
      MiPassthroughSQL.Checked := true;
  end;
end;

procedure TDlgSql.MiAlterColumnClick(Sender: TObject);
{ Dialog und Durchführung Spaltenänderung }
var
  S: string;
begin
  S := TblStr;
  AppendTok(S, FldStr, ';');
  AppendTok(S, FmtStr, ';');
  AppendTok(S, NeuStr, ';');
  if InputQuery(MiAlterColumn.Caption, 'Tabelle;Feld;Format;NeuFeld', S) and
     (S <> '') then
  begin
    AlterColumn(S);
    DetailBook.ActivePage := tsSql;
  end;
end;

procedure TDlgSql.MiDuplicatesClick(Sender: TObject);
var
  S, NextS: string;
  I: integer;
begin
  S := TblStr;
  AppendTok(S, FldStr, ';');
  if InputQuery(MiDuplicates.Caption, 'Tabelle;Feld', S) and
     (S <> '') then
  begin
    TblStr := PStrTok(S, ';', NextS);
    FldStr := PStrTok('', ';', NextS);
    SqlMemo.Clear;
    for I := 0 to LbDuplicates.Items.Count - 1 do
    begin
      S := StrCgeStrStr(LbDuplicates.Items[I], '#Table#', TblStr, true);
      S := StrCgeStrStr(S, '#Col#', FldStr, true);
      SqlMemo.Lines.Add(S);
    end;
    MiPassthroughSQL.Checked := false;
    DetailBook.ActivePage := tsSql; {Sql anzeigen}
  end;
end;

procedure TDlgSql.ShowDb;
var             //Interbase muß manchmal neu starten
  S: string;
begin
  S := QueryServerName(Query1);
  if S <> '' then
  begin
    Caption := Prots.SubCaption(Caption, S);
  end;
end;

(* procedure TDlgSql.IbReconnect;
//Interbase muß manchmal neu starten
//11.01.07 nicht mehr verwendet da zu Dauerlast führt.
var
  DB: TuDatabase;
begin
  DB := USession.FindDataBase(Query1.DataBaseName);
  if DB <> nil then
  try
    Prot0('ReConnect %s', [Query1.DataBaseName]);
    DB.Close;
    DB.LoginPrompt := false; //ohne Abfrage
    DB.OnLogin := nil;
    DB.Open;
  except on E:Exception do
    EProt(self, E, 'IbReconnect', [0]);
  end else
    ErrWarn('Database(%s) nicht gefunden', [Query1.DataBaseName]);
end; *)

procedure TDlgSql.MiDisconnectClick(Sender: TObject);
var
  DB: TuDatabase;
begin
  DB := USession.FindDataBase(Query1.DataBaseName);
  if DB <> nil then
  begin
    Prot0('ReConnect %s', [Query1.DataBaseName]);
    DB.Close;
    DB.LoginPrompt := true;
    DB.OnLogin := nil; //mit Abfrage
    DB.Open;
  end else
    ErrWarn('Database(%s) nicht gefunden', [Query1.DataBaseName]);
end;

procedure TDlgSql.MiDataSetClick(Sender: TObject);

  function DatasetName(aDB: TuDatabase; aDataset: TDataset): string;
  var
    S1, NextS: string;
  begin
    if aDataset.Owner <> nil then
    begin
      //result := Format('%s.%s', [aDataSet.Owner.ClassName, aDataSet.Name]);
      result := OwnerDotName(aDataSet);
    end else
    if aDataSet is TuQuery then
      result := Format('%s.%.20s...', [aDB.DatabaseName, TuQuery(aDataset).Text]) else
      result := Format('%s.%s ???', [aDB.DatabaseName, aDataset.Classname]);
    if aDataset.Active then
      Result := 'X ' + Result else
      Result := '- ' + Result;

    if aDataSet is TuQuery then
    begin
      S1 := PStrTok(TuQuery(aDataSet).Text, ' '+CRLF, NextS);
      while S1 <> '' do
      begin
        if SameText(S1, 'from') then
        begin
          S1 := PStrTokNext(' '+CRLF, NextS);
          Result := Result + ' from ' + S1;
          break;
        end;
        S1 := PStrTokNext(' '+CRLF, NextS);
      end;
    end;
  end;

var
  AList: TStringList;
  I: integer;
  AQuery: TuQuery;
  aDB, aDuplDB: TuDatabase;
  IDupl: integer;
begin
  if Query1 <> nil then
  begin
    AList := TStringList.Create;
    try
      if CallerQuery <> nil then
        aDB := QueryDatabase(CallerQuery) else
        aDB := QueryDatabase(Query1);
      for I := 0 to aDB.DataSetCount - 1 do
        if aDB.DataSets[I] is TuQuery then
          AList.AddObject(DatasetName(aDB, aDB.DataSets[I]), aDB.DataSets[I]);
      if SysParam.UseDuplDb then
      begin
        for IDupl := 0 to DuplDbCount do
        begin
          if IDupl = DuplDbCount then
            aDuplDB := GNavigator.DB1 else
            aDuplDB := GNavigator.GetDuplDB(GNavigator.DB1, IDupl);
          if aDuplDB <> aDB then
            for I := 0 to aDuplDB.DataSetCount - 1 do
              if aDuplDB.DataSets[I] is TuQuery then
                AList.AddObject(DatasetName(aDuplDB, aDuplDB.DataSets[I]), aDuplDB.DataSets[I]);
        end;
      end;
      AList.Sort;  //17.06.12
      I := TDlgStrings.Execute(AList, MiDataSet.Hint); //'Aktive Datasets (X = geöffnet)'
      if I >= 0 then
      begin
        AQuery := TuQuery(AList.Objects[I]);
        SqlMemo.Lines.Assign(AQuery.SQL); {Schreiben}
        RbLive.Checked := AQuery.RequestLive; {Request Live übernehmen}
        MiUnidirectional.Checked := AQuery.Unidirectional;
        Query1.Params.Assign(AQuery.Params);
      end;
    finally
      AList.Free;
    end;
  end;
end;

procedure TDlgSql.MiTransactionStartClick(Sender: TObject);
begin
  GNavigator.DB1.StartTransaction;
end;

procedure TDlgSql.MiTransactionCommitClick(Sender: TObject);
begin
  GNavigator.DB1.Commit;
end;

procedure TDlgSql.MiTransactionRollBackClick(Sender: TObject);
begin
  GNavigator.DB1.RollBack;
end;

procedure TDlgSql.MiProcClick(Sender: TObject);
var
  S, S1, NextS: string;
  I: integer;
begin
  S := ProcStr;
  if InputQuery(MiProc.Caption, 'Procedure Name;Parameter1;Parameter2;...', S) and
     (S <> '') then
  begin
    ProcStr := S;
    Prot0('%s', [ProcStr]);
    with StoredProc1 do
    begin
      try
        DataBaseName := Query1.DataBaseName;
        StoredProcName := PStrTok(S, ';', NextS);
        PrepareSQL; //call PrepareSQL to describe parameters, assign parameter values
        I := 0;
        S1 := PStrTok('', ';', NextS);
        while (I < Params.Count) and (S1 <> '') do
        begin
          if not SameText(Params[I].Name, 'RETURN_VALUE') then
          begin
            case Params[I].DataType of
              ftFloat:    Params[I].AsFloat := StrToFloat(S1);
              ftDateTime: Params[I].AsDateTime := StrToDate(S1);
              ftInteger:  Params[I].AsInteger := StrToInt(S1);
              //ftString
            else          Params[I].AsString := S1;
            end;
            S1 := PStrTok('', ';', NextS);
          end;
          Inc(I);
        end;
        ProcExecCommitted(StoredProc1);
        S1 := 'OK';
      except on E:Exception do
        S1 := E.Message;
      end;
      DetailBook.ActivePage := tsSql;
      SqlMemo.Lines.Clear;
      SqlMemo.Lines.Add(StoredProcName);
      for I := 0 to Params.Count - 1 do
        SqlMemo.Lines.Add(Params[I].Name + '="' + Params[I].AsString + '"');
      SqlMemo.Lines.Add(S1);
      Prot0('%s', [SqlMemo.Lines.Text]);
    end;
  end;
end;

function TDlgSql.GetHistIndex: integer;
begin
  result := FHistIndex;
end;

procedure TDlgSql.SetHistIndex(const Value: integer);
begin
  FHistIndex := Value;
  if FHistIndex < 0 then
    FHistIndex := 0;
  if FHistIndex >= Historie.Count then
    FHistIndex := Historie.Count - 1;
  ShowHistIndex;
end;

procedure TDlgSql.ShowHistIndex;
begin
  if FHistIndex >= 0 then
  begin
    LaHistPos.Caption := Format('%d/%d', [FHistIndex + 1, Historie.Count]);
    MeHistSql.Text := Historie.Sql(FHistIndex);
    MeHistResult.Text := Historie.Result(FHistIndex);
  end else
  begin
    LaHistPos.Caption := '---';
    MeHistSql.Clear;
    MeHistResult.Clear;
  end;
end;

procedure TDlgSql.BtnHistPriorClick(Sender: TObject);
begin
  if HistIndex <= 0 then
    HistIndex := Historie.Count - 1 else
    HistIndex := HistIndex - 1;
end;

procedure TDlgSql.BtnHistNextClick(Sender: TObject);
begin
  if HistIndex >= Historie.Count - 1 then
    HistIndex := 0 else
    HistIndex := HistIndex + 1;
end;

{ THistorie }

constructor THistorie.Create;
begin
  Elements := TList.Create;
end;

destructor THistorie.Destroy;
begin
  Elements.Free;
  inherited;
end;

function THistorie.Add(S: string): integer;
var
  I: integer;
  AHistorieEl: PHistorieEl;
begin
  result := -1;
  for I := 0 to Elements.Count - 1 do
    if AnsiSameText(S, PHistorieEl(Elements[I]).Sql) then
    begin
      result := I;
      break;
    end;
  if result < 0 then
  begin
    new(AHistorieEl);
    AHistorieEl.Sql := S;
    result := Elements.Add(AHistorieEl);
  end;
end;

procedure THistorie.SetResult(H: integer; S: string);
var
  AHistorieEl: PHistorieEl;
begin
  AHistorieEl := PHistorieEl(Elements[H]);
  AHistorieEl.Result := S;
end;

function THistorie.Count: integer;
begin
  result := Elements.Count;
end;

function THistorie.Sql(Index: integer): string;
var
  AHistorieEl: PHistorieEl;
begin
  AHistorieEl := PHistorieEl(Elements[Index]);
  result := AHistorieEl.Sql;
end;

function THistorie.Result(Index: integer): string;
var
  AHistorieEl: PHistorieEl;
begin
  AHistorieEl := PHistorieEl(Elements[Index]);
  result := AHistorieEl.Result;
end;

procedure TDlgSql.MiOraCompileInvalidObjectsClick(Sender: TObject);
begin
  CompileInvalidOraObjects;
end;

function TDlgSql.CompileInvalidOraObjects: integer;
// Oracle: erzeugt Skript zum kompilieren von invalid Objects (Views, procedures, trigger)
// das Skript kann per BtnExecSql ausgeführt werden.
// ergibt Anzahl zu kompilierender Objekte
const
  types: array[1..3] of string = ('VIEW', 'PROCEDURE', 'TRIGGER');
var
  I, I1: integer;
  S1: string;
begin
  result := 0;
  SqlMemo.Lines.Clear;
  for I := low(types) to high(types) do
  begin
    Query1.Sql.Assign(lbOraObjects.Items);
    for I1 := 0 to Query1.Sql.Count - 1 do
    begin
      S1 := StringReplace(Query1.Sql[I1], '#owner',
                          UpperCase(StrDflt(Sysparam.DbUserName, Sysparam.UserName)),
                          [rfReplaceAll, rfIgnoreCase]);
      Query1.Sql[I1] := StringReplace(S1, '#type', types[I], [rfReplaceAll, rfIgnoreCase]);
    end;
    Query1.Open;
    while not Query1.EOF do
    begin
      result := result + 1;
      SqlMemo.Lines.Add(Format('alter %s %s compile;',
        [types[I], Query1.FieldByName('OBJECT_NAME').AsString]));
      Query1.Next;
    end;
    Query1.Close;
    Query1.Unprepare;
  end;
  MiPassthroughSQL.Checked := false;
  DetailBook.ActivePage := tsSql; {Sql anzeigen}
end;

procedure TDlgSql.MiMarkAllClick(Sender: TObject);
begin
  MarkAll(Mu1);
end;

procedure TDlgSql.MiLoopSqlClick(Sender: TObject);
var
  S1, ATblName, IndexFields: string;
  S2, S3, NextS: string;
  ADataBase: TuDataBase;
  CallerActive: boolean;
begin
  CallerActive := false;
  ATblName := QueryTableName(Query1);
  IndexFields := IndexInfo(QueryDatabase(Query1), ATblName, nil, nil);
  S1 := Format('update %s'+CRLF+'set', [ATblName]);
  S2 := PStrTok(IndexFields, ';', NextS);
  S3 := 'where';
  while S2 <> '' do
  begin
    AppendTok(S1, Format('%s %s =:%s', [S3, S2, S2]), CRLF);
    S3 := '  and';
    S2 := PStrTok('', ';', NextS);
  end;
  if TDlgMemo.Execute(MiLoopSql.Caption, 'SQL:', S1) then
  begin
    Prot0('LoopSql %s', [S1]);
    //GNavigator.SetDuplDB(QueLoop, QueryDatabase(Query1), 4);  //gleiche DB
    QueLoop.DatabaseName := Query1.DatabaseName;
    QueLoop.SessionName := Query1.SessionName;
    QueLoop.SQL.Text := S1;
//    Query1.DisableControls;
//    try
//      Query1.Last;  //fetch all damit es bei mssql keine blockierung gibt !?!
//      Query1.First; //mit der CallerQuery kann es trotzdem zu Problemen kommen
//    finally
//      Query1.EnableControls;
//    end;
    if CallerQuery <> nil then
    begin
      CallerActive := CallerQuery.Active;
      if CallerActive then
        CallerQuery.Close;
      //SMess('Caller FetchAll', [0]);
      //CallerQuery.SpecificOptions.Values['FetchAll'] := 'True';
    end;
    if Query1.Database.IsMSSQL then
    begin
      SMess('Query1 FetchAll', [0]);
      Query1.Close;
      Query1.SpecificOptions.Values['FetchAll'] := 'True';  //fetch all damit es bei mssql keine blockierung gibt !?!
    end;
    Query1.Open;
    SMess0;
    Query1.First;
    ADataBase := QueryDatabase(QueLoop);
    ADataBase.StartTransaction;
    try
      while not Query1.EOF do
      begin
        QueLoop.ExecSql;
        Query1.Next;
        Application.ProcessMessages;  //zeichnen
      end;
      ADataBase.Commit;
    except on E:Exception do begin
        //EProt(QueLoop, E, 'LoopSql:RollBack', [0]);
        ADataBase.RollBack;
        //EError('Fehler bei LoopSql(%s): %s', [S1, E.Message]);
        raise;
      end;
    end;
    if CallerActive then
      CallerQuery.Open;
  end;
end;

initialization
  Historie := THistorie.Create;
finalization
  Historie.Free;
end.
