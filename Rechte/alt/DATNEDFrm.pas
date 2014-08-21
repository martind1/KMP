unit DATNEDFrm;
(* QuRE/Rechte
   Datenbank-Files Editor
   04.06.08 MD Erstellt
*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  JvBrowseFolder,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  Luedikmp, Lubtnkmp, Gen__Kmp, Asws_Kmp, Zeitdlg, Qedi_kmp, TgridKmp, Xls,
  Dialogs, DPos_Kmp, DatumDlg, MuSiControlFr, qSplitter, Ini__kmp, IniDbkmp,
  UMem_Kmp, Menus, JvBaseDlg;

type
  TFrmDATNED = class(TqForm)
    Query1: TuQuery;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    PsDflt: TPrnSource;
    PageControl: TPageControl;
    tsMulti: TTabSheet;
    panTop: TPanel;
    panCenter: TPanel;
    Splitter1: TqSplitter;
    LuLokal: TLookUpDef;
    lbMu1ColsLokal: TListBox;
    PanLokal: TPanel;
    TblLokal: TuMemTable;
    PanDB: TPanel;
    LaLocalBase: TLabel;
    BtnToLeftMarked: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    LaOrdner: TLabel;
    EdLocalBase: TEdit;
    BtnLocalBase: TBitBtn;
    Panel3: TPanel;
    BtnImport: TBitBtn;
    Panel4: TPanel;
    Mu1: TMultiGrid;
    MuLokal: TMultiGrid;
    cobOrdner: TComboBox;
    Panel5: TPanel;
    BtnCheckOut: TBitBtn;
    BtnToRightMarked: TBitBtn;
    BtnToLeftAll: TBitBtn;
    BtnToRightAll: TBitBtn;
    tsImplementierung: TTabSheet;
    lbOrdner: TListBox;
    Panel6: TPanel;
    BtnNewOrdner: TBitBtn;
    BtnLocalBaseOpen: TBitBtn;
    PopupLokal: TPopupMenu;
    MiFileOpen: TMenuItem;
    MiImport: TMenuItem;
    DlgFileOpen: TOpenDialog;
    DlgFileImport: TOpenDialog;
    Panel8: TPanel;
    BtnAddOrdner: TBitBtn;
    BtnCheckIn: TBitBtn;
    BtnFileOpen: TBitBtn;
    JvBrowseForFolderDialog: TJvBrowseForFolderDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure FormResize(Sender: TObject);
    procedure BtnLocalBaseClick(Sender: TObject);
    procedure EdLocalBaseChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Splitter1Moved(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure EdLocalBaseExit(Sender: TObject);
    procedure cobOrdnerDropDown(Sender: TObject);
    procedure cobOrdnerChange(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure NavPostStart(Sender: TObject);
    procedure MuLokalDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure BtnToLeftMarkedClick(Sender: TObject);
    procedure BtnToRightMarkedClick(Sender: TObject);
    procedure BtnToLeftAllClick(Sender: TObject);
    procedure BtnToRightAllClick(Sender: TObject);
    procedure BtnLocalBaseOpenClick(Sender: TObject);
    procedure BtnNewOrdnerClick(Sender: TObject);
    procedure LuLokalBeforeDelete(ADataSet: TDataSet; var Done: Boolean);
    procedure LuLokalBeforeDeleteMarked(ADataSet: TDataSet;
      var Done: Boolean);
    procedure TblLokalInternalRefresh(DataSet: TDataSet);
    procedure Mu1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure BtnImportClick(Sender: TObject);
    procedure BtnMarkDbClick(Sender: TObject);
    procedure MiFileOpenClick(Sender: TObject);
    procedure MiImportClick(Sender: TObject);
    procedure BtnAddOrdnerClick(Sender: TObject);
    procedure BtnCheckOutClick(Sender: TObject);
    procedure BtnCheckInClick(Sender: TObject);
  private
    function GetOrdner: string;
    procedure SetOrdner(const Value: string);
    procedure AddOrdner(aOrdner: string);
  protected
  private
    { Private-Deklarationen }
    OrdnerChangedFlag: boolean;
    procedure SaveToIni;
    procedure CreateLokalTable;
    procedure LokalRefresh;
    property Ordner: string read GetOrdner write SetOrdner;
  public
    { Public-Deklarationen }
  end;

var
  FrmDATNED: TFrmDATNED;

implementation
{$R *.DFM}
uses
  IniFiles, FileCtrl,
  GNav_Kmp, Prots, NLnk_Kmp, Err__Kmp, nstr_Kmp, Lov__Dlg, Datn_Kmp,
  ParaFrm, mainfrm;


procedure TFrmDATNED.FormCreate(Sender: TObject);
begin
  FrmDATNED := self;

  GNavigator.Canceled := false;
  Mu1.LastColResize := true;            {manuelle Steuerung für letzte Spalte der Größe anpassen}
  FrmPara.OnFormCreate(self);           {Enabled=false, bgIntern.Visible=false}

  Nav.NavLink.EnabledButtons := Nav.NavLink.EnabledButtons + [qnbEdit, qnbInsert, qnbDelete];

  EdLocalBase.Text := Datn.BaseDir;  //Inikmp.Read bereits in LogonDlg
end;

procedure TFrmDATNED.SaveToIni;
begin
  IniKmp.WriteString('System', 'BaseDir', Datn.BaseDir);
  IniKmp.WriteString(Kurz, cobOrdner.Name, Ordner);
end;

procedure TFrmDATNED.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveToIni;
end;

procedure TFrmDATNED.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);            {Bemerkung Größe}
  EdLocalBase.Width := EdLocalBase.Parent.Width - EdLocalBase.Left -
                       BtnLocalBase.Width - BtnLocalBaseOpen.Width - 20;
  BtnLocalBase.Left := EdLocalBase.Left + EdLocalBase.Width;
  BtnLocalBaseOpen.Left := BtnLocalBase.Left + BtnLocalBase.Width;

  cobOrdner.Width := cobOrdner.Parent.Width - cobOrdner.Left -
                     BtnNewOrdner.Width - 20;
  BtnNewOrdner.Left := cobOrdner.Left + cobOrdner.Width;
end;

procedure TFrmDATNED.FormDestroy(Sender: TObject);
begin
  FrmDATNED := nil;
end;

procedure TFrmDATNED.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmDATNED.NavStart(Sender: TObject);
begin
  Splitter1Moved(Sender);
  CreateLokalTable;
end;

procedure TFrmDATNED.NavPostStart(Sender: TObject);
begin
  cobOrdner.Items.Assign(Datn.OrdnerList);
  
  Ordner := IniKmp.ReadString(Kurz, cobOrdner.Name, '\');
  //cobOrdner.ItemIndex := cobOrdner.Items.IndexOf(cobOrdner.Text);
  //ComboBoxChange(cobOrdner);
end;

procedure TFrmDATNED.CreateLokalTable;
var
  ColumnName: String;
  I: Integer;
  AField: TField;
begin
  // InMemoryTable anlegen vergl. TDBQBENav.QueryActivate
  Query1.Open;
  TblLokal.DataBaseName := '';
  TblLokal.TableName := 'lokal';
  TblLokal.FieldDefs.Clear;
  TblLokal.Fields.Clear;
  //unidac TblLokal.IndexDefs.Clear;
  with Query1 do
  begin
    //L := IMin(200, 16000 div FieldCount);
    for I := 0 to FieldCount - 1 do
    begin
      ColumnName := Fields[I].FieldName;
      if IsCalcField(Fields[I]) then
      begin
        TblLokal.FieldDefs.Add(ColumnName, ftString, 1, False);   {100}
      end else
      begin
        //TblLokal.FieldDefs.Add(ColumnName, ftString, L, False); {250}
        TblLokal.FieldDefs.AddFieldDef.Assign(FieldDefs[I]);
      end;
    end;

    { Der erste Index hat keinen Namen, denn er ist ein }
    { primärer Paradox-Schlüssel }
    (* keine Indexdefs mehr unidac
    with TblLokal.IndexDefs.AddIndexDef do
    begin
      Name := '';
      Fields := 'FILENAME';
      Options := [ixPrimary];
    end;
    *)
    IndexFieldNames := 'FILENAME';  //unidac

    for I := 0 to FieldCount - 1 do
    begin
      AField := TblLokal.FieldDefs.Items[I].CreateField(TblLokal);
      AField.Name := 'lokal' + StrToValidIdent(Fields[i].FieldName);
      AField.Visible := Fields[I].Visible;
      AField.ReadOnly := true;  // datn Fields[I].FieldNo < 0;  {bei Calc-Fields}
      if Fields[I].Tag > 0 then {bei Auswahlfelder}
      begin
        AField.Tag := Fields[I].Tag;
        AField.OnGetText := Nav.NavLink.FieldOnGetText; {Field wird als Sender an FieldOnGetText übermittelt}
        AField.OnSetText := Nav.NavLink.FieldOnSetText; {Erkennung der Auswahl über die Eigenschft Tag}
      end;
      if Fields[I].Visible then                           {wichtig für Grid}
      begin
        AField.DisplayWidth := Fields[I].DisplayWidth;      {zeitaufwendig!}
        AField.DisplayLabel := Fields[I].DisplayLabel;
      end;
    end;
  end;

  TblLokal.CreateTable; {Tabelle anlegen}
  TblLokal.ReadOnly := false;
end;

procedure TFrmDATNED.PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
begin
  FrmMain.DfltMultiGrid := Mu1;
end;

procedure TFrmDATNED.BtnLocalBaseClick(Sender: TObject);
begin
  with JvBrowseForFolderDialog do
  begin
    Title := LaLocalBase.Caption;
    Directory := EdLocalBase.Text;
    if Execute then
      EdLocalBase.Text := Directory;
  end;
end;

procedure TFrmDATNED.BtnLocalBaseOpenClick(Sender: TObject);
begin
//  OrdnerChangedFlag := true;
//  Datn.ExploreOrdner(Ordner);
//  SysParam.DisplayWinExecError := true;
//  ShellExecNoWait(BaseDir + aOrdner, SW_NORMAL);  //Warten gibts bei Explorer nicht da kein eigener Prozess

  with DlgFileOpen do
  begin     //noChangeDir=true
    InitialDir := Datn.BaseDir + Ordner;
    if Execute then
    begin
      if not BeginsWith(Filename, Datn.BaseDir, true) then
        EError('Sie können nur im Verzeichnis %s und seinen Unterverzeichnissen auswählen',
          [Datn.BaseDir]);
      Ordner := Datn.StripBaseDir(ExtractFilePath(Filename));
      LuLokal.DataPos.Text := 'FILENAME=' + ExtractFileName(Filename);
      if LuLokal.DataPos.GotoPos(TblLokal) then
        BtnFileOpen.Click;
    end;
  end;
end;

procedure TFrmDATNED.BtnNewOrdnerClick(Sender: TObject);
var
  S: string;
begin
  S := Ordner;
  if InputQuery(self.ShortCaption, BtnNewOrdner.Hint, S) then
  begin
    AddOrdner(S);
  end;
end;

procedure TFrmDATNED.BtnAddOrdnerClick(Sender: TObject);
var
  I: integer;
begin
  //AddOrdner(StrParam(lbOrdner.Items[lbOrdner.ItemIndex]));
  for I := 0 to lbOrdner.Items.Count - 1 do
  begin
    AddOrdner(StrParam(lbOrdner.Items[I]));
  end;
end;

procedure TFrmDATNED.AddOrdner(aOrdner: string);
begin
  aOrdner := Datn.StripBaseDir(aOrdner);
  if Datn.OrdnerList.IndexOf(aOrdner) < 0 then
  begin
    ForceDirectories(Datn.BaseDir + aOrdner);
    Datn.ClearOrdnerList;
    cobOrdner.Items.Assign(Datn.OrdnerList);
    Ordner := aOrdner;  //cob und Filelist in Gui
  end;
end;

procedure TFrmDATNED.Splitter1Moved(Sender: TObject);
begin
  BtnToLeftMarked.Left := Splitter1.Left + 5;
  BtnToRightMarked.Left := BtnToLeftMarked.Left;
  BtnToLeftAll.Left := BtnToLeftMarked.Left;
  BtnToRightAll.Left := BtnToLeftMarked.Left;
end;

procedure TFrmDATNED.EdLocalBaseChange(Sender: TObject);
begin
  if ActiveControl <> EdLocalBase then
  begin
    Datn.BaseDir := EdLocalBase.Text;
    //DMess('%s', [Datn.BaseDir]);
  end;
end;

procedure TFrmDATNED.EdLocalBaseExit(Sender: TObject);
begin
  EdLocalBaseChange(Sender);
end;

function TFrmDATNED.GetOrdner: string;
begin
  Result := cobOrdner.Text;
end;

procedure TFrmDATNED.SetOrdner(const Value: string);
begin
  cobOrdner.ItemIndex := cobOrdner.Items.IndexOf(Value);
  if cobOrdner.ItemIndex < 0 then
    cobOrdner.Text := Value;
  ComboBoxChange(cobOrdner);
end;

procedure TFrmDATNED.cobOrdnerDropDown(Sender: TObject);
begin { cobOrdnerDropDown }
  if OrdnerChangedFlag then
  begin
    OrdnerChangedFlag := false;
    Datn.ClearOrdnerList;
  end;
  cobOrdner.Items.Assign(Datn.OrdnerList);
end;

procedure TFrmDATNED.cobOrdnerChange(Sender: TObject);
begin
  Datn.FileList[Ordner];
  Nav.Refresh;
  LokalRefresh;
end;

procedure TFrmDATNED.Query1BeforeOpen(DataSet: TDataSet);
begin
  Nav.References.Values['ORDNER'] := Ordner;
end;

procedure TFrmDATNED.LokalRefresh;
var
  L: TStrings;
  FI: TDatnFileInfo;
  I: integer;
begin
  L := Datn.FileList[Ordner];
  try
    TblLokal.Close;
    CreateLokalTable;
    TblLokal.Open;
  except
  end;
//  TblLokal.First;
//  try
//    while not TblLokal.EOF do -
//      TblLokal.Delete;  // - Merkmal nicht erfügbar
//  except on E:Exception do
//    EProt(self, E, 'TblLokal.delete', [0]);
//  end;
  for I := 0 to L.Count - 1 do
  begin
    FI := TDatnFileInfo(L.Objects[I]);
    if FI.IsLokal then
    begin
      //TblLokal.Insert;  Mu Canceled!
      LuLokal.Navlink.DoInsert;
      SetFieldValueRO(TblLokal.FieldByName('ORDNER'), Ordner);
      SetFieldValueRO(TblLokal.FieldByName('FILENAME'), FI.Filename);
      SetFieldFloatRO(TblLokal.FieldByName('FILETIME'), FI.LokalDT);
      //TblLokal.FieldByName('FILETIME').AsDateTime := FI.LokalDT;
      LuLokal.Commit;
    end;
  end;
  TblLokal.First;
end;

procedure TFrmDATNED.TblLokalInternalRefresh(DataSet: TDataSet);
begin
  Datn.ClearFilelist(Ordner);
  LokalRefresh;
  Mu1.Invalidate;
end;

procedure TFrmDATNED.MuLokalDrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
var
  clFont, clBrush: TColor;
  fsStyle: TFontStyles;
  I: integer;
  L: TStrings;
  FI: TDatnFileInfo;
begin
  if not (gdFocused in State) and
//     TMultiGrid(Sender).IsActiveRow and
     not TMultiGrid(Sender).SelectedRows.CurrentRowSelected and
     (Nav.nlState = nlBrowse) then
  begin
    with TMultiGrid(Sender).DataSource.DataSet, TMultiGrid(Sender).Canvas do
    begin
      clBrush := clWindow; //clBlack;
      clFont := clBlack;
      fsStyle := [];

      L := Datn.FileList[Ordner];
      I := L.IndexOf(FieldByName('FILENAME').AsString);
      if I >= 0 then
      begin
        FI := TDatnFileInfo(L.Objects[I]);
        if FI.IsDB then
        begin
          if FI.LokalDT < FI.DbDT then
            clFont := clRed else
          if FI.LokalDT > FI.DbDT then
            clFont := clGreen;
        end else
          clFont := clGreen;
      end;

      if Font.Style <> fsStyle then
        Font.Style := fsStyle;
      if Font.Color <> clFont then
        Font.Color := clFont;
      if Brush.Color <> clBrush then
        Brush.Color := clBrush;
    end;
  end;
end;

procedure TFrmDATNED.Mu1DrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
var
  clFont, clBrush: TColor;
  fsStyle: TFontStyles;
  I: integer;
  L: TStrings;
  FI: TDatnFileInfo;
begin
  if not (gdFocused in State) and
     not TMultiGrid(Sender).SelectedRows.CurrentRowSelected and
     (Nav.nlState = nlBrowse) then
  begin
    with TMultiGrid(Sender).DataSource.DataSet, TMultiGrid(Sender).Canvas do
    begin
      clBrush := clWindow; //clBlack;
      clFont := clBlack;
      fsStyle := [];

      L := Datn.FileList[Ordner];
      I := L.IndexOf(FieldByName('FILENAME').AsString);
      if I >= 0 then
      begin
        FI := TDatnFileInfo(L.Objects[I]);
        if FI.IsLokal then
        begin
          if FI.LokalDT < FI.DbDT then
            clFont := clGreen else
          if FI.LokalDT > FI.DbDT then
            clFont := clRed;
        end else
          clFont := clGreen;
      end;

      if Font.Style <> fsStyle then
        Font.Style := fsStyle;
      if Font.Color <> clFont then
        Font.Color := clFont;
      if Brush.Color <> clBrush then
        Brush.Color := clBrush;
    end;
  end;
end;

procedure TFrmDATNED.BtnImportClick(Sender: TObject);
//neue markieren - n.b.
var
  I: integer;
  L: TStrings;
  FI: TDatnFileInfo;
begin
  TblLokal.First;
  MuLokal.SelectedRows.Clear;
  L := Datn.FileList[Ordner];
  while not TblLokal.EOF do
  begin
    I := L.IndexOf(TblLokal.FieldByName('FILENAME').AsString);
    FI := TDatnFileInfo(L.Objects[I]);
    if not FI.IsDB or (FI.LokalDT > FI.DbDT) then
      MuLokal.SelectedRows.CurrentRowSelected := true;
    TblLokal.Next;
  end;
end;

procedure TFrmDATNED.BtnMarkDbClick(Sender: TObject);
//neue markieren - n.b.
var
  I: integer;
  L: TStrings;
  FI: TDatnFileInfo;
begin
  Query1.First;
  Mu1.SelectedRows.Clear;
  L := Datn.FileList[Ordner];
  while not Query1.EOF do
  begin
    I := L.IndexOf(Query1.FieldByName('FILENAME').AsString);
    FI := TDatnFileInfo(L.Objects[I]);
    if not FI.IsLokal or (FI.DbDT > FI.LokalDT) then
      Mu1.SelectedRows.CurrentRowSelected := true;
    Query1.Next;
  end;
end;

procedure TFrmDATNED.BtnToLeftMarkedClick(Sender: TObject);
var
  I: integer;
begin
  if Mu1.SelectedRows.Count > 0 then
  begin
    for I := 0 to Mu1.SelectedRows.Count - 1 do
    begin
      Query1.Bookmark := Mu1.SelectedRows[I];
      Datn.CopyFileToLokal(Ordner, Query1.FieldByName('FILENAME').AsString);
    end;
  end else
  begin
    Datn.CopyFileToLokal(Ordner, Query1.FieldByName('FILENAME').AsString);
  end;
  LokalRefresh;
  Mu1.Invalidate;
end;

procedure TFrmDATNED.BtnToRightMarkedClick(Sender: TObject);
var
  I: integer;
begin
  if MuLokal.SelectedRows.Count > 0 then
  begin
    for I := 0 to MuLokal.SelectedRows.Count - 1 do
    begin
      TblLokal.Bookmark := MuLokal.SelectedRows[I];
      Datn.CopyFileToDb(Ordner, TblLokal.FieldByName('FILENAME').AsString);
    end;
  end else
  begin
    Datn.CopyFileToDb(Ordner, TblLokal.FieldByName('FILENAME').AsString);
  end;
  Nav.Refresh;
  MuLokal.Invalidate;
end;

procedure TFrmDATNED.BtnToLeftAllClick(Sender: TObject);
begin
  Datn.CopyOrdnerToLokal(Ordner);
  LokalRefresh;
  Mu1.Invalidate;
end;

procedure TFrmDATNED.BtnToRightAllClick(Sender: TObject);
begin
  Datn.CopyOrdnerToDb(Ordner);
  Nav.Refresh;
  MuLokal.Invalidate;
end;

procedure TFrmDATNED.LuLokalBeforeDeleteMarked(ADataSet: TDataSet;
  var Done: Boolean);
var
  I: integer;
  LokalFilename: string;
  Err: integer;
begin
  Done := true;
  for I := MuLokal.SelectedRows.Count - 1 downto 0 do
  begin
    TblLokal.Bookmark := MuLokal.SelectedRows[I];
    LokalFilename := Datn.BaseDir + Ordner + TblLokal.FieldByName('FILENAME').AsString;
    if not SysUtils.DeleteFile(LokalFilename) then
    begin
      Err := GetLastError;
      EError('%s Fehler %d bei DeleteFile(%s): %s', [Kurz, Err, LokalFilename, SysErrorMessage(Err)]);
    end;
  end;
  Datn.ClearFileList(Ordner);
  LokalRefresh;  //neu laden
  Mu1.Invalidate;
end;

procedure TFrmDATNED.LuLokalBeforeDelete(ADataSet: TDataSet;
  var Done: Boolean);
var
  aFilename: string;
  LokalFilename: string;
  Err: integer;
begin
  if not LuLokal.NavLink.InBeforeDelete then
  begin
    Exit;  //von DeleteMarked
  end;
  Done := true;
  aFilename := TblLokal.FieldByName('FILENAME').AsString;
  if aFilename <> '' then
  begin
    LokalFilename := Datn.BaseDir + Ordner + aFilename;
    if not SysUtils.DeleteFile(LokalFilename) then
    begin
      Err := GetLastError;
      EError('%s Fehler %d bei DeleteFile(%s): %s', [Kurz, Err, LokalFilename, SysErrorMessage(Err)]);
    end;
    Datn.ClearFileList(Ordner);
    LokalRefresh;     //Ordner := Ordner;  //neu laden
    Mu1.Invalidate;
  end else
  begin  //Ordner löschen
    LokalFilename := PartDir(Datn.BaseDir + Ordner);
    if not RemoveDir(LokalFilename) then
    begin
      Err := GetLastError;
      EError('%s Fehler %d bei RemoveDir(%s): %s', [Kurz, Err, LokalFilename, SysErrorMessage(Err)]);
    end;
    Datn.ClearOrdnerList;
    cobOrdner.Items.Assign(Datn.OrdnerList);
    Ordner := '\';
  end;
end;

{ PopupLokal }

procedure TFrmDATNED.MiFileOpenClick(Sender: TObject);
var
  aFilename: string;
  LokalFilename: string;
begin
  aFilename := TblLokal.FieldByName('FILENAME').AsString;
  LokalFilename := Datn.BaseDir + Ordner + aFilename;
  SysParam.DisplayWinExecError := true;
  ShellExecNoWait(LokalFilename, SW_NORMAL);
end;

procedure TFrmDATNED.MiImportClick(Sender: TObject);
var
  I: integer;
  S1, S2: string;
begin
  with DlgFileImport do
  begin  // ofAllowMultiSelect
    InitialDir := 'c:\';
    if Execute then
    begin
      ForceDirectories(Datn.BaseDir + Ordner);
      for I := 0 to Files.Count - 1 do
      begin
        S1 := Files[I];
        S2 := Datn.BaseDir + Ordner + ExtractFilename(S1);
        if CompareText(S1, S2) = 0 then
          EError('Sie können nicht aus dem gleichen Verzeichnis (%s) importieren',
            [ExtractFilePath(S1)]);
        CopyFile(S1, S2);  // from,To
      end;
      Datn.ClearFileList(Ordner);
      LokalRefresh;  //neu laden
      Mu1.Invalidate;
    end;
  end;
end;

procedure TFrmDATNED.BtnCheckOutClick(Sender: TObject);
begin
  Datn.CheckOut(Ordner);
  LokalRefresh;
  Mu1.Invalidate;
end;

procedure TFrmDATNED.BtnCheckInClick(Sender: TObject);
begin
  if MuLokal.SelectedRows.Count > 0 then
  begin
    if WMessYesNo('Beim Checkin werden alle Dateien abgeglichen.'+CRLF+
      'Wollen Sie trotzdem fortfahren?', [0]) <> mrYes then
      Exit;
  end;
  Datn.CheckIn(Ordner);
  Nav.Refresh;
  MuLokal.Invalidate;
end;

end.
