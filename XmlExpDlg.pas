unit XmlExpDlg;
(* Export/Import per XML
23.08.02 MD  erstellt
todo: bestehnes File erweitern statt ersetzen
*)
interface

uses
{$ifdef WIN32}
  ComCtrls,
{$else}
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Mask, ExtCtrls,
  Grids, DBGrids, TabNotBk, Tabs, DBLookup, Dialogs,
  LNav_Kmp, GNav_Kmp, LuDefKmp, LuEdiKmp, Buttons, Qwf_Form, 
  Btnp_kmp, PSrc_Kmp, Asws_Kmp, Tools,
  qLab_kmp, qSplitter, TgridKmp, Qedi_kmp, Radios, Ausw_Kmp, NLnk_Kmp, MemDS,
  DBAccess, Uni, UQue_Kmp;

type
  TDlgXMLEXP = class(TqForm)
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    dlgOpen: TOpenDialog;
    DetailControl: TPageControl;
    Panel1: TPanel;
    BtnExport: TBitBtn;
    BtnClose: TBitBtn;
    TabSheet1: TTabSheet;
    BtnImport: TBitBtn;
    GroupBox5: TGroupBox;
    ScrollBox1: TScrollBox;
    Label18: TLabel;
    EdFileName: TEdit;
    btnFilename: TBitBtn;
    btnOpen: TBitBtn;
    Label1: TLabel;
    EdTableName: TEdit;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    lbTables: TListBox;
    MeSQL: TMemo;
    Query1: TuQuery;
    QueImp: TuQuery;
    qSplitter1: TqSplitter;
    GroupBox1: TGroupBox;
    MeSqlParam: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFilenameClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOpenClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnImportClick(Sender: TObject);
    procedure MeSQLChange(Sender: TObject);
  private
    btnFilenameClicked: boolean;
    Que: TuQuery;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure ExportTableList(aComment: string; AList: TStrings);
    procedure Import(aFileName: string; aOverwriteBtn: word;
      Silent: boolean);
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    class procedure Execute(ANavLink: TNavLink);
    class procedure ExecImp(aFileName: string);
    class procedure ImpQue(UseQuery: TuQuery);  //qusy
    class procedure ExpStrings(SqlCmds: TStrings); //qusy
  end;

var
  DlgXMLEXP: TDlgXMLEXP;

implementation
{$R *.DFM}
uses
  DPos_Kmp, Prots, Err__Kmp, Ini__Kmp, AbortDlg, Sql__Dlg, XMLExport;
const
  piTreeView = 1;

class procedure TDlgXMLEXP.Execute(ANavLink: TNavLink);
begin
  with TDlgXMLEXP.Create(Application) do
  begin
    MeSQL.HandleNeeded;
    MeSQL.Text := ANavLink.Query.Text;
    EdTableName.Text := ANavLink.TableName;
    Que.DatabaseName := ANavLink.Query.DatabaseName;
  end;
end;

class procedure TDlgXMLEXP.ExpStrings(SqlCmds: TStrings);
begin
  with TDlgXMLEXP.Create(Application) do
  begin
    lbTables.Items.Assign(SqlCmds);
    DetailControl.ActivePage := TabSheet2;
    BtnImport.Enabled := false;  //qusy - md09.05.04
  end;
end;

class procedure TDlgXMLEXP.ImpQue(UseQuery: TuQuery);
begin  //nur Import. Verwendet externe Query.
  with TDlgXMLEXP.Create(Application) do
  begin
    Que := UseQuery;
    BtnExport.Enabled := false;  //qusy - md09.05.04
    with dlgOpen do
    begin
      Title := btnImport.Caption;
      FileName := EdFileName.Text;
      if Execute then
      begin
        EdFileName.Text := FileName;
        Import(FileName, mrNoToAll, false);
      end;
    end;
    PostMessage(Handle, WM_CLOSE, 0, 0);
  end;
end;

class procedure TDlgXMLEXP.ExecImp(aFileName: string);
begin
  with TDlgXMLEXP.Create(Application) do
  begin
    Import(aFileName, mrYesToAll, true);
    GMess0;
    PostMessage(Handle, WM_CLOSE, 0, 0);
  end;
end;

procedure TDlgXMLEXP.MeSQLChange(Sender: TObject);
begin
  lbTables.Items.Clear;
  lbTables.Items.Add(MeSQL.Text);
end;

procedure TDlgXMLEXP.FormCreate(Sender: TObject);
begin
  DlgXMLEXP := self;
  Que := QueImp;
  LoadFromIni;
  GNavigator.TranslateForm(self);
end;

procedure TDlgXMLEXP.FormDestroy(Sender: TObject);
begin
  DlgXMLEXP := nil;
end;

procedure TDlgXMLEXP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDlgXMLEXP.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveToIni;
end;

procedure TDlgXMLEXP.btnFilenameClick(Sender: TObject);
begin
  with dlgOpen do
  begin
    InitialDir := ExtractFilePath(EdFileName.Text);
    if InitialDir = '' then
      InitialDir := AppDir;
    Title := btnFilename.Hint;
    FileName := EdFileName.Text;
    if Execute then
    begin
      EdFileName.Text := FileName;
      btnFilenameClicked := true;
    end;
  end;
end;

procedure TDlgXMLEXP.btnOpenClick(Sender: TObject);
begin
  SysParam.DisplayWinExecError := true;
  ShellExecNoWait(EdFileName.Text, SW_NORMAL);
end;

procedure TDlgXMLEXP.LoadFromIni;
begin
  EdFileName.Text := IniKmp.ReadString(Kurz, EdFileName.Name, EdFileName.Text);
end;

procedure TDlgXMLEXP.SaveToIni;
begin
  IniKmp.WriteString(Kurz, EdFileName.Name, EdFileName.Text);
end;

procedure TDlgXMLEXP.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDlgXMLEXP.BtnExportClick(Sender: TObject);
begin
  ExportTableList('Standard', lbTables.Items);
end;

procedure TDlgXMLEXP.ExportTableList(aComment: string; AList: TStrings);

  procedure CheckQueParam;
  //Que.SQL.Params setzen. Fehlende nachfragen.
  var
    I: integer;
    AParam: TParam;
    S: string;
  begin
    for I := 0 to Que.ParamCount - 1 do
    begin
      AParam := Que.Params[I];
      S := MeSqlParam.Lines.Values[AParam.Name];
      if S = '' then
      begin
        if not WMessInput('Parameter', AParam.Name, S) then
          Sysutils.Abort;  //Bedienerabbruch
        S := StrDflt(S, 'null');
        MeSqlParam.Lines.Values[AParam.Name] := S;
      end;
      if S = 'null' then
        AParam.Clear else
        AParam.AsString := S;
    end;
  end;
var
  XMLExport: TXMLExport;
  I, hXmlTable: integer;
  ATableName: string;
begin { ExportTableList }
  if not btnFilenameClicked then
    with dlgOpen do
    begin
      Title := btnExport.Caption;
      FileName := ExpandFileName(EdFileName.Text);
      if Execute then
        EdFileName.Text := FileName else
        Exit;
    end;
  XMLExport := TXMLExport.Create(self);
  try
    if FileExists(EdFileName.Text) then          //immer ergänzen
    begin
      XMLExport.LoadFromFile(EdFileName.Text);
    end else
    begin
      XMLExport.SetDocComment('Export', aComment);
    end;
    TDlgAbort.CreateDlg('Export');

    MeSqlParam.Lines.Clear;
    for I := 0 to AList.Count - 1 do
    begin
      Que.Close;
      TDlgAbort.GMessA(I, AList.Count);
      Que.SQL.Text := AList[I];
      CheckQueParam;
      ATableName := QueryTableName(Que);
      ProtLD('Export %s (%s)', [ATableName, Que.Text]);
      Que.Open;
      hXmlTable := XMLExport.AddTable(ATableName, Que);
      XMLExport.AddRows(hXmlTable);
      DMess0;
    end;

    //GNavigator.StartForm(self, 'PROT');
    //XMLExport.SetRootAttr('Funktion', ShortCaption);
    //XMLExport.FormatLF := true;  (ist Std.)
    XMLExport.SaveToFile(EdFileName.Text);   //incl. AddLF
  finally
    XMLExport.Free;
    TDlgAbort.SetText('Export beendet');
    TDlgAbort.GMess(100);
    TDlgAbort.SetBtnCaption('&OK');
  end;
end;

procedure TDlgXMLEXP.BtnImportClick(Sender: TObject);
begin
  if not btnFilenameClicked then with dlgOpen do
  begin
    Title := btnImport.Caption;
    FileName := EdFileName.Text;
    if Execute then
      EdFileName.Text := FileName else
      Exit;
  end;
  Import(EdFileName.Text, 0, false);
end;

procedure TDlgXMLEXP.Import(aFileName: string; aOverwriteBtn: word; Silent: boolean);
var
  XMLExport: TXMLExport;
  I, J: integer;
begin
  EdFileName.Text := aFileName;
  XMLExport := TXMLExport.Create(self);
  try
    XMLExport.OverwriteBtn := aOverwriteBtn;
    XMLExport.LoadFromFile(aFileName);
    //GNavigator.StartForm(self, 'PROT');
    Prot0('XML Import %s', [aFileName]);
    if Silent then
      SMess('Import %s', [aFileName]) else
      TDlgAbort.CreateDlg('Import');
    for I := 0 to XMLExport.TableCount - 1 do
    try
      Prot0('XML IMPORT %d:%s:%d', [I, XMLExport.Tables[I].TableName, XMLExport.Tables[I].RowCount]);
      for J := 0 to XMLExport.Tables[I].PKeys.Count - 1 do
        ProtP('   %d:%s', [J, XMLExport.Tables[I].PKeys[J]]);
      TDlgAbort.SetText('Import ' + XMLExport.Tables[I].TableName);

      Que.SQL.Text := 'select * from ' + XMLExport.Tables[I].TableName;
      Que.RequestLive := true;
      Que.Open;
      XMLExport.ImportTable(XMLExport.Tables[I].TableName, Que);
      Prot0('%s:%d Rows importiert', [XMLExport.Tables[I].TableName, XMLExport.Tables[I].RowCount]);
    except on E:exception do
      EProt(self, E, 'BtnImportClick', [0]);
    end;
  finally
    TDlgAbort.FreeDlg;
    XMLExport.Free;
  end;
end;

end.
