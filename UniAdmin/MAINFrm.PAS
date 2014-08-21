unit MAINFrm;
(* UniAdmin
   Verwaltung der UniDAC Aliase.
   Standard: %ALLUSERSPROFILE%\UniDAC\Unidac.ini
             für Entwicklungsrechner/Delphi2010 feste Vorgabe
   Laufzeit: 1. Parameter: Uni=x:\Unidac.ini
             2. Umgebungsvariable: UNIADMIN=x:\Unidac.ini
             3. AppDir\Unidac.ini
             4. %ALLUSERSPROFILE%\UniDAC\Unidac.ini

27.10.11 md  V1.00  Erstellt
09.11.11          a Splitter, Ankreuzen=EditDialog, TNS:beliebig viele Aliase mit Komma getrennt

*)
interface

uses Windows, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, StdActns, inifiles,
  ActnList, ToolWin, CheckLst, Grids, TgridKmp, Ini__kmp, DBAccess, UniDacVcl,
  DB, Uni, UDB__Kmp, DBFUniProvider, SQLiteUniProvider, SQLServerUniProvider,
  PostgreSQLUniProvider, OracleUniProvider, MySQLUniProvider,
  InterBaseUniProvider, DB2UniProvider, ASEUniProvider, AdvantageUniProvider,
  UniProvider, ODBCUniProvider, AccessUniProvider, Prots;

const
  Version = '1.00a';

type
  TFrmMAIN = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ToolBar1: TToolBar;
    ToolButton9: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileOpen1: TAction;
    FileSave1: TAction;
    FileSaveAs1: TAction;
    FileExit1: TAction;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    HelpAbout1: TAction;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    Help1: TMenuItem;
    HelpAboutItem: TMenuItem;
    Panel1: TPanel;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    tgParams: TTitleGrid;
    GroupBox1: TGroupBox;
    clbAlias: TCheckListBox;
    Panel2: TPanel;
    Label1: TLabel;
    BtnEdit: TBitBtn;
    BtnInsert: TBitBtn;
    BtnDelete: TBitBtn;
    BtnTnsImp: TBitBtn;
    uDataBase1: TuDataBase;
    UniConnectDialog1: TUniConnectDialog;
    AccessUniProvider1: TAccessUniProvider;
    AdvantageUniProvider1: TAdvantageUniProvider;
    ASEUniProvider1: TASEUniProvider;
    DB2UniProvider1: TDB2UniProvider;
    InterBaseUniProvider1: TInterBaseUniProvider;
    MySQLUniProvider1: TMySQLUniProvider;
    ODBCUniProvider1: TODBCUniProvider;
    OracleUniProvider1: TOracleUniProvider;
    PostgreSQLUniProvider1: TPostgreSQLUniProvider;
    SQLServerUniProvider1: TSQLServerUniProvider;
    SQLiteUniProvider1: TSQLiteUniProvider;
    DBFUniProvider1: TDBFUniProvider;
    Prot1: TProt;
    Splitter1: TSplitter;
    MiSortieren: TMenuItem;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FileSave1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure clbAliasClick(Sender: TObject);
    procedure clbAliasClickCheck(Sender: TObject);
    procedure BtnInsertClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDecryptClick(Sender: TObject);
    procedure BtnEncryptClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnTnsImpClick(Sender: TObject);
    procedure MiSortierenClick(Sender: TObject);
    procedure FileSaveAs1Execute(Sender: TObject);
  private
    MemIniFile: TMemIniFile;
    procedure LoadFromIni;
    procedure ClearData;
    procedure LoadParams(ASection: string);
    procedure UpdateCaption;
    procedure SetMarked(AliasIndex: integer);
    procedure FillParams(L: TStrings);
    procedure FillIniSection(ASection: string; L: TStrings);
    procedure GetParams(L: TStrings);
    procedure LoadIniFile(Filename: string);
    procedure CheckMarked;

    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure TnsImp(Aliasname, Host, Port, ServiceName: string);
  end;

var
  FrmMAIN: TFrmMAIN;

implementation

uses
  SysUtils, Messages,
  about,
  ConnectionEditorFrm, TnsImpFrm;
{$R *.dfm}
const
  SNewIniFile = 'new.uni';

procedure TFrmMAIN.FileNew1Execute(Sender: TObject);
// neues Config File anlegen
begin
  ClearData;
  MemIniFile.Clear;
  MemIniFile.Rename(SNewIniFile, false);  //nicht laden
  UpdateCaption;
end;

procedure TFrmMAIN.FileOpen1Execute(Sender: TObject);
// Config File laden
begin
  OpenDialog.InitialDir := AppDir;
  if OpenDialog.Execute then
  begin
    LoadIniFile(OpenDialog.FileName);

    ClearData;
    MemIniFile.Rename(OpenDialog.FileName, true);
    LoadFromIni;
    UpdateCaption;
  end;
end;

procedure TFrmMAIN.FileSave1Execute(Sender: TObject);
begin
  MemIniFile.UpdateFile;
end;

procedure TFrmMAIN.FileSaveAs1Execute(Sender: TObject);
begin
  SaveDialog.InitialDir := AppDir;
  SaveDialog.FileName := MemIniFile.Filename;
  if SaveDialog.Execute then
  begin
    if ExtractFilename(SaveDialog.FileName) = SNewIniFile then
      raise Exception.CreateFmt(
        'unter diesem Namen (%s) kann nicht gespeichert werden.', [SNewIniFile]);
    MemIniFile.Rename(SaveDialog.FileName, false);
    MemIniFile.UpdateFile;
    UpdateCaption;
  end;
end;

procedure TFrmMAIN.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TFrmMAIN.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TFrmMAIN.FormCreate(Sender: TObject);
var
  S: string;
  DefaultPath: string;
begin
  DefaultPath := AllUsersDir + 'UniDAC';
  ForceDirectories(DefaultPath);
  // erster Parameter ist IniFile (default = Exename.uni) (default = letzter Aufruf)
  if ParamCount > 0 then
    S := ExpandFilename(ParamStr(1)) else  // 0 = ExeFilename
    S := ValidDir(DefaultPath) + 'Unidac.ini';
  MemIniFile := TMemIniFile.Create('');
  LoadIniFile(S);
  StatusBar.Panels[2].Text := Format('Version %s', [Version]);
end;

procedure TFrmMAIN.FormDestroy(Sender: TObject);
begin
  FreeAndNil(MemIniFile);
end;

{ Anwendung }

procedure TFrmMAIN.BtnInsertClick(Sender: TObject);
var
  AliasName: string;
  TmpDatabase: TuDatabase;
  I: integer;
  NameOK: boolean;
begin
  AliasName := '';
  if not InputQuery(BtnInsert.Caption, 'Alias Name', AliasName) or
     (AliasName = '') then
    Exit;
  //if uDatabase1.ConnectDialog.Execute then
  if FrmConnectionEditor = nil then
    TFrmConnectionEditor.Create(nil);
  try
    TmpDatabase := TuDatabase.Create(nil);
    NameOK := false;
    try
      TmpDatabase.Name := StrToValidIdent(AliasName);
      NameOK := true;
    except on E:Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
    if NameOK then
    begin
      FrmConnectionEditor.Component := TmpDatabase;  //Connection
      if FrmConnectionEditor.ShowModal = mrOK then
      begin  //Übernehmen nach clbAlias und TgParams
        I := clbAlias.ItemIndex;
        if I >= 0 then
          clbAlias.Items.Insert(clbAlias.ItemIndex, AliasName) else
          I := clbAlias.Items.Add(AliasName);
        FillIniSection(AliasName, TmpDatabase.ConnectionParams);
        LoadParams(AliasName);
        clbAlias.ItemIndex := I;
        clbAlias.Checked[clbAlias.ItemIndex] := true;
        SetMarked(clbAlias.ItemIndex);  //bold
        CheckMarked;  //nur einer fett
        //clbAliasClickCheck(clbAlias);  //nur einer fett
      end;
    end;
  finally
    FrmConnectionEditor.Release;
    TmpDatabase.Free;
  end;
end;

procedure TFrmMAIN.BtnDeleteClick(Sender: TObject);
//aktuellen Alias löschen
var
  AliasName: string;
  I: integer;
begin
  if clbAlias.ItemIndex < 0 then
    Exit;
  I := clbAlias.ItemIndex;
  AliasName := clbAlias.Items[clbAlias.ItemIndex];
  MemIniFile.EraseSection(AliasName);
  clbAlias.Items.Delete(clbAlias.ItemIndex);
  if clbAlias.Items.Count = 0 then
  begin
    tgParams.ClearAll;
    Exit;
  end;
  if clbAlias.Items.Count > I then
    clbAlias.ItemIndex := I else
    clbAlias.ItemIndex := 0;
  clbAliasClick(clbAlias);
end;

procedure TFrmMAIN.BtnEditClick(Sender: TObject);
var
  AliasName: string;
  TmpDatabase: TuDatabase;
  I: integer;
  L: TStrings;
begin
  if clbAlias.ItemIndex < 0 then
    Exit;
  AliasName := clbAlias.Items[clbAlias.ItemIndex];
  L := nil;

  //if uDatabase1.ConnectDialog.Execute then
  if FrmConnectionEditor = nil then
    TFrmConnectionEditor.Create(nil);
  try
    TmpDatabase := TuDatabase.Create(nil);
    TmpDatabase.Name := StrToValidIdent(AliasName);
    L := TStringList.Create;
    GetParams(L);  //tgParams to Strings
    TmpDatabase.Params := L;

    FrmConnectionEditor.Component := TmpDatabase;  //Connection
    if (FrmConnectionEditor.ShowModal = mrOK) and TmpDatabase.Connected then
    begin  //Übernehmen nach clbAlias und TgParams
      FillIniSection(AliasName, TmpDatabase.ConnectionParams);
      LoadParams(AliasName);
      clbAlias.Checked[clbAlias.ItemIndex] := true;
      SetMarked(clbAlias.ItemIndex);  //bold
      CheckMarked;  //nur einer fett
      //clbAliasClickCheck(clbAlias);  //nur einer fett
    end else
    begin
      clbAlias.Checked[clbAlias.ItemIndex] := false;
    end;
  finally
    FrmConnectionEditor.Release;
    FreeAndNil(TmpDatabase);
    FreeAndNil(L);
  end;
end;



{ Oberfläche }

procedure TFrmMAIN.clbAliasClick(Sender: TObject);
begin
  if clbAlias.ItemIndex >= 0 then
  begin
    LoadParams(clbAlias.Items[clbAlias.ItemIndex]);
    SetMarked(clbAlias.ItemIndex);
  end;
end;

procedure TFrmMAIN.CheckMarked;
//nur einer ist aktiv
var
  I: integer;
begin
  for I := 0 to clbAlias.Items.Count - 1 do
    if clbAlias.ItemIndex <> I then
      clbAlias.Checked[I] := false;
end;

procedure TFrmMAIN.clbAliasClickCheck(Sender: TObject);
//nur einer ist aktiv
var
  I: integer;
begin
  if clbAlias.Checked[clbAlias.ItemIndex] then
  begin
    CheckMarked;
  //siehe edit - SetMarked(clbAlias.ItemIndex);

    PostMessage(self.Handle, WM_COMMAND, 0, BtnEdit.Handle)
  end else
    SetMarked(clbAlias.ItemIndex);
end;

procedure TFrmMAIN.ClearData;
begin
  clbAlias.Clear;
  tgParams.ClearAll;
end;

procedure TFrmMAIN.UpdateCaption;
begin
  self.Caption := Prots.SubCaption(self.Caption, MemIniFile.Filename);
end;

procedure TFrmMAIN.LoadFromIni;
//MemIniFile to Data
begin
  MemIniFile.ReadSections(clbAlias.Items);
  if clbAlias.Items.Count > 0 then
  begin
    LoadParams(clbAlias.Items[0]);
    clbAlias.ItemIndex := 0;
  end;
end;

procedure TFrmMAIN.LoadIniFile(Filename: string);
// Config File laden
begin
  ClearData;
  MemIniFile.Rename(FileName, true); //Reload
  LoadFromIni;
  UpdateCaption;
end;

//so nicht ! (ist nur ein LoadfromFile)
//procedure TFrmMAIN.MiSortierenClick(Sender: TObject);
////sortiert nach Aliasname
//var
//  L: TStringList;
//begin
//  L := TStringList.Create;
//  try
//    //L.Sorted := true;
//    L.Duplicates := dupIgnore;
//    MemIniFile.GetStrings(L);
//    L.Sort;
//    MemIniFile.SetStrings(L);
//    LoadFromIni;
//  finally
//    L.Free
//  end;
//end;

procedure TFrmMAIN.MiSortierenClick(Sender: TObject);
//sortiert nach Aliasname
var
  TmpIniFile: TMemIniFile;
  AliasList: TStringList;
  ParamList: TStringList;
  IniList: TStringList;
  AI, I: integer;
  ASection: string;
begin
  TmpIniFile := TMemIniFile.Create(TempDir + 'Temp.ini');
  AliasList := TStringList.Create;
  ParamList := TStringList.Create;
  IniList := TStringList.Create;
  try
    TmpIniFile.Clear;
    AliasList.Sorted := true;
    AliasList.Duplicates := dupIgnore;
    AliasList.Assign(clbAlias.Items);
    for AI := 0 to AliasList.Count - 1 do
    begin
      ASection := AliasList[AI];
      MemIniFile.ReadSectionValues(ASection, ParamList);
      for I := 0 to ParamList.Count - 1 do
        if not SameText(StrParam(ParamList[I]), 'PASSWORD') then
          TmpIniFile.WriteString(ASection, StrParam(ParamList[I]), StrValue(ParamList[I]));
    end;
    TmpIniFile.GetStrings(IniList);  //kopieren
    MemIniFile.SetStrings(IniList);
    clbAlias.Items.Assign(AliasList);
    if clbAlias.Items.Count > 0 then  //ersten Alias korrekt anzeigen
    begin
      LoadParams(clbAlias.Items[0]);
      clbAlias.ItemIndex := 0;
    end;
  finally
    TmpIniFile.Free;
    AliasList.Free;
    ParamList.Free;
    IniList.Free;
  end;
end;

{ Controller }

procedure TFrmMAIN.LoadParams(ASection: string);
//Section to Data
var
  L: TStrings;
  I: integer;
begin
  L := TStringList.Create;
  try
    MemIniFile.ReadSectionValues(ASection, L);
    FillParams(L);
  finally
    L.Free
  end;
end;

procedure TFrmMAIN.FillIniSection(ASection: string; L: TStrings);
//L to INI Section
//08.11.11 md  ohne PASSWORD
var
  I: integer;
begin
  MemIniFile.EraseSection(ASection);
  for I := 0 to L.Count - 1 do
    if not SameText(StrParam(L[I]), 'PASSWORD') then
      MemIniFile.WriteString(ASection, StrParam(L[I]), StrValue(L[I]));
end;

procedure TFrmMAIN.GetParams(L: TStrings);
//tbParams to Strings
var
  Y: integer;
begin
  L.BeginUpdate;
  try
    L.Clear;
    for Y := tgParams.FixedRows to tgParams.RowCount - 1 do
    begin
      L.Add(Format('%s=%s', [tgParams.Cells[0, Y], tgParams.Cells[1, Y]]));
    end;
  finally
    L.EndUpdate;
  end;
end;

procedure TFrmMAIN.FillParams(L: TStrings);
//Strings to tbParams
var
  I: integer;
begin
  tgParams.ClearAll;
  for I := 0 to L.Count - 1 do
  begin
    tgParams.AddCell(0, I + 1, StrParam(L[I]));
    tgParams.AddCell(1, I + 1, StrValue(L[I]));
  end;
  //häßlich tgParams.AdjustColWidths();
end;

procedure TFrmMAIN.SetMarked(AliasIndex: integer);
// Wenn geöffnet dann Fette Schrift.
begin
  if (AliasIndex >= 0) and
     clbAlias.Checked[AliasIndex] then
    TgParams.Font.Style := TgParams.Font.Style + [fsBold] else
    TgParams.Font.Style := TgParams.Font.Style - [fsBold];
//häßlich tgParams.AdjustColWidths();
end;

procedure TFrmMAIN.BtnTnsImpClick(Sender: TObject);
begin
  TFrmTnsImp.Execute(self);
end;

procedure TFrmMAIN.TnsImp(Aliasname, Host, Port, ServiceName: string);
var
  L: TStringList;
  I, ItemIndex: integer;
begin
  L := TStringList.Create;
  try
    ItemIndex := -1;
    for I := 0 to clbAlias.Items.Count - 1 do
      if SameText(clbAlias.Items[I], AliasName) then
      begin
        ItemIndex := I;
        Break;
      end;
    if ItemIndex = -1 then
      ItemIndex := clbAlias.Items.Add(AliasName);

    L.Values['SERVER NAME'] := Format('%s:%s:%s', [Host, Port, ServiceName]);
    L.Values['ProviderName'] := 'Oracle';
    L.Values['Oracle.Direct'] := 'True';

    FillIniSection(AliasName, L);

  finally
    L.Free
  end;
end;

{ Test }

procedure TFrmMAIN.BtnDecryptClick(Sender: TObject);
begin
//  EdCrypt.Text := DecryptPassw(EdCrypt.Text);
end;

procedure TFrmMAIN.BtnEncryptClick(Sender: TObject);
begin
//  EdCrypt.Text := EncryptPassw(EdCrypt.Text);
end;

end.
