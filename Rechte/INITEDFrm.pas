unit INITEDFrm;
(* QuRE/Rechte
   DB-Ini Editor
   18.10.03 MD Erstellt
*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, DBAccess, MemDS,
  Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  Luedikmp, Lubtnkmp, Gen__Kmp, Asws_Kmp, Zeitdlg, Qedi_kmp, TgridKmp, Xls,
  Dialogs, DPos_Kmp, DatumDlg, MuSiControlFr, qSplitter, Ini__kmp, IniDbkmp,
  Menus, UQue_Kmp;

type
  TFrmINITED = class(TqForm)
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    PsDflt: TPrnSource;
    TabControl: TTabControl;
    PageControl: TPageControl;
    tsMulti: TTabSheet;
    btnImport: TBitBtn;
    panTop: TPanel;
    panCenter: TPanel;
    sbTop: TScrollBox;
    btnFltrAnwe: TSpeedButton;
    cobFltrAnwe: TComboBox;
    btnFltrMach: TSpeedButton;
    cobFltrMach: TComboBox;
    cobFltrUser: TComboBox;
    btnFltrUser: TSpeedButton;
    qSplitter1: TqSplitter;
    cobFltrVorg: TComboBox;
    btnFltrVorg: TSpeedButton;
    btnFltrSect: TSpeedButton;
    cobFltrSect: TComboBox;
    LuEntry: TLookUpDef;
    MuEntry: TMultiGrid;
    btnCopy: TBitBtn;
    btnEditor: TBitBtn;
    btnMu1: TBitBtn;
    lovFltrAnwe: TLovBtn;
    lovFltrMach: TLovBtn;
    LuLOV: TLookUpDef;
    LuINIT: TLookUpDef;
    lbMu1ColsLokal: TListBox;
    lovFltrUser: TLovBtn;
    Panel1: TPanel;
    Mu1: TMultiGrid;
    BtnSearch: TBitBtn;
    PopupMenu1: TPopupMenu;
    MiFindNext: TMenuItem;
    Query1: TuQuery;
    TblEntry: TuQuery;
    TblLOV: TuQuery;
    TblINIT: TuQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cobFltrChange(Sender: TObject);
    procedure meEntriesChange(Sender: TObject);
    procedure btnFltrAnweClick(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure LDataSource1StateChange(Sender: TObject);
    procedure btnEditorClick(Sender: TObject);
    procedure btnMu1Click(Sender: TObject);
    procedure TblEntryAfterInsert(DataSet: TDataSet);
    procedure lovFltrAnweClick(Sender: TObject);
    procedure lovFltrMachClick(Sender: TObject);
    procedure Query1AfterClose(DataSet: TDataSet);
    procedure btnCopyClick(Sender: TObject);
    procedure btnFltrClick(Sender: TObject);
    procedure NavBeforeInsert(ADataSet: TDataSet; var Done: Boolean);
    procedure NavBeforeEdit(ADataSet: TDataSet; var Done: Boolean);
    procedure Query1AfterOpen(DataSet: TDataSet);
    procedure NavBeforeDelete(ADataSet: TDataSet; var Done: Boolean);
    procedure cobFltrKeyPress(Sender: TObject; var Key: Char);
    procedure NavStart(Sender: TObject);
    procedure btnFltrSectClick(Sender: TObject);
    procedure lovFltrUserClick(Sender: TObject);
    procedure cobFltrSectDblClick(Sender: TObject);
    procedure TblEntryAfterPost(DataSet: TDataSet);
    procedure btnImportClick(Sender: TObject);
    procedure NavPostStart(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure MiFindNextClick(Sender: TObject);
  protected
  private
    EntriesChanged: boolean;
    procedure cobAddText(cob: TCombobox; S: string); overload;
    procedure cobAddText(cob: TCombobox); overload;
    procedure cobAddItem(cob: TCombobox; S: string);
    procedure Query1SECTIONOnGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure cobSetItem(cob: TCombobox; S: string);
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmINITED: TFrmINITED;

implementation
{$R *.DFM}
uses
  IniFiles,
  GNav_Kmp, Prots, NLnk_Kmp, Err__Kmp, nstr_Kmp, Lov__Dlg,
  FltrFrm, parafrm, mainfrm,
  InitAskDlg, InitEdiDlg, InitCpyDlg, InitImpDlg, InitSearchDlg;
const
  sAlle = '(alle)';


procedure TFrmINITED.cobAddText(cob: TCombobox; S: string);
begin
  cob.SelectAll;
  SendChar(cob, StrDflt(S, '%'));   //löst Change Ereignis aus
  cobAddText(cob);
end;

procedure TFrmINITED.cobAddText(cob: TCombobox);
begin
  cob.Text := AnsiUppercase(cob.Text);
  cobAddItem(cob, cob.Text);
end;

procedure TFrmINITED.cobSetItem(cob: TCombobox; S: string);
begin
  //cob.Items.Clear;  * weg 13.09.08
  cobAddItem(cob, S);
  cob.SelectAll;
  SendChar(cob, StrDflt(S, '%'));   //löst Change Ereignis aus
end;

procedure TFrmINITED.cobAddItem(cob: TCombobox; S: string);
var
  L: TStringList;
begin
  if (S <> '') and (cob.Items.Indexof(S) < 0) then
  begin
    L := TStringList.Create;
    try
      L.Sorted := true;
      L.Assign(cob.Items);
      L.Add(S);
      cob.Items.Assign(L);
    finally
      L.Free;
    end;
  end;
end;

procedure TFrmINITED.FormCreate(Sender: TObject);
var
  L: TValueList;
  S: string;
begin
  FrmINITED := self;
  GNavigator.Canceled := false;
  Mu1.LastColResize := true;            {manuelle Steuerung für letzte Spalte der Größe anpassen}
  FrmPara.OnFormCreate(self);           {Enabled=false, bgIntern.Visible=false}
  L := TValueList.Create;
  try
    if InitData <> nil then
    begin
      S := PChar(InitData);
      L.AddTokens(S, ';');
    end;
    L.Values['ANWE'] := AnsiUppercase(StrDflt(L.Values['ANWE'], OnlyFilename(Application.ExeName)));
    L.Values['MACH'] := AnsiUppercase(StrDflt(L.Values['MACH'], CompName));
    L.Values['USER'] := AnsiUppercase(StrDflt(L.Values['USER'], CompUserName));

    cobAddText(cobFltrAnwe, '%');
    cobAddText(cobFltrMach, '%');
    cobAddText(cobFltrUser, '%');
    cobAddText(cobFltrVorg, '%');
    cobAddText(cobFltrAnwe, L.Values['ANWE']);
    cobAddText(cobFltrMach, L.Values['MACH']);
    cobAddText(cobFltrUser, L.Values['USER']);
    cobAddText(cobFltrSect, 'Hints.%');
    cobSetItem(cobFltrSect, '<>Spalten%&<>Sortierung%');  //die stören nur
    btnFltrSect.Down := true;
  finally
    L.Free;
  end;

  LuEntry.AutoCommit := true;
  BtnMu1.Left := Mu1.Left + 2;
  BtnMu1.Top := Mu1.Top + 2;
  Nav.NavLink.EnabledButtons := Nav.NavLink.EnabledButtons + [qnbEdit, qnbInsert, qnbDelete];

  Mu1.IniSection := Kurz;
  if Kurz <> 'INITED' then   //volle Rechte nur in QURE oder [IniDb] FrmInitEd=INITED
  begin
    sbTop.Enabled := false;
//    BtnFltrAnwe.Enabled := false;
//    BtnFltrMach.Enabled := false;
//    BtnFltrUser.Enabled := false;
//    BtnFltrVorg.Enabled := false;
//    BtnFltrSect.Enabled := false;
//    lovFltrAnwe.Enabled := false;
//    lovFltrMach.Enabled := false;
//    lovFltrUser.Enabled := false;
//    btnCopy.Enabled := false;
//    LuINIT.Enabled := false;
//    Nav.SetTabs;  //Lu-Tab nicht anzeigen
//    Mu1.LoadedColumnList.Assign(lbMu1ColsLokal.Items);
  end else
  begin
    if GNavigator.GetForm(LuINIT.LuKurz) = nil then  //'INIT' - FrmINIT von RECHTE32
    begin
      LuINIT.Enabled := false;
      Nav.SetTabs;  //Lu-Tab nicht anzeigen
    end;
  end;
end;

procedure TFrmINITED.NavStart(Sender: TObject);
//var
//  S1: string;
begin
//  if Kurz <> 'INITED' then   //volle Rechte nur in QURE
//  begin
//    S1 := OnlyFilename(Application.ExeName);
//    AppendTok(S1, CompName, ', ');
//    AppendTok(S1, CompUserName, ', ');
//    Caption := SubCaption(ShortCaption, S1);
//    Query1.Open;
//  end;
end;

procedure TFrmINITED.NavPostStart(Sender: TObject);
var
  S1: string;
begin
  //Erst jetzt sind Rechte geladen
  if not sbTop.Enabled then
  begin
    BtnFltrAnwe.Enabled := false;
    BtnFltrMach.Enabled := false;
    BtnFltrUser.Enabled := false;
    BtnFltrVorg.Enabled := false;
    BtnFltrSect.Enabled := false;
    lovFltrAnwe.Enabled := false;
    lovFltrMach.Enabled := false;
    lovFltrUser.Enabled := false;
    sbTop.Enabled := false;
    btnCopy.Enabled := false;
    LuINIT.Enabled := false;
    Nav.SetTabs;  //Lu-Tab nicht anzeigen
    Mu1.LoadedColumnList.Assign(lbMu1ColsLokal.Items);

    S1 := OnlyFilename(Application.ExeName);
    AppendTok(S1, CompName, ', ');
    AppendTok(S1, CompUserName, ', ');
    Caption := Prots.SubCaption(ShortCaption, S1);
    Query1.Open;
  end;
end;

procedure TFrmINITED.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);            {Bemerkung Größe}
end;

procedure TFrmINITED.FormDestroy(Sender: TObject);
begin
  if DlgIniSearch <> nil then
    DlgIniSearch.Release;
  FrmINITED := nil;
end;

procedure TFrmINITED.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if IniDb <> nil then
    IniDb.Refresh([]);
end;

procedure TFrmINITED.cobFltrChange(Sender: TObject);
begin
  TFrmFltr.cobFltrChange(Sender);
end;

procedure TFrmINITED.meEntriesChange(Sender: TObject);
begin
  //Einträge wurden geändert. Cache speichern.
  EntriesChanged := true;
end;

procedure TFrmINITED.cobFltrSectDblClick(Sender: TObject);
begin
  cobFltrSect.Text := Query1.FieldByName('SECTION').AsString;
end;

procedure TFrmINITED.btnFltrAnweClick(Sender: TObject);
begin
  if not Nav.NavLink.InOnRech then
    Query1.Close;
end;

procedure TFrmINITED.btnFltrSectClick(Sender: TObject);
begin
//  if btnFltrSect.Down then
//  begin
//    if IsAlphaNum(cobFltrSect.Text) then
//    begin
//      btnFltrAnwe.Down := false;
//      btnFltrMach.Down := false;
//      btnFltrUser.Down := false;
//      btnFltrVorg.Down := false;
//    end;
//  end else
//  begin
//    if IsAlphaNum(cobFltrSect.Text) then
//    begin
//      btnFltrAnwe.Down := true;
//      btnFltrMach.Down := true;
//      btnFltrUser.Down := true;
//      btnFltrVorg.Down := true;
//    end;
//  end;
  btnFltrClick(Sender);
end;

procedure TFrmINITED.btnFltrClick(Sender: TObject);
var
  cob: TCombobox;
begin
  Query1.Close;
  with TSpeedButton(Sender) do
  begin
    cob := TCombobox(self.FindComponent(Format('cob%s', [copy(Name, 4, MaxInt)])));
    if Down then
    begin
      if cob.Text = '' then
        cob.Text := '%';
    end else
      cob.Text := '';
  end;
end;

procedure TFrmINITED.Query1BeforeOpen(DataSet: TDataSet);
var
  S: string;
  AnweSql, MachSql, UserSql, VorgSql: string;
  B: boolean;
begin
  Nav.FltrList.Values['ANWENDUNG'] := cobFltrANWE.Text;

  cobAddText(cobFltrANWE);
  cobAddText(cobFltrMACH);
  cobAddText(cobFltrUSER);
  cobAddText(cobFltrVORG);

  B := true; //ReadOnly
  GenerateSQL(StrDflt(cobFltrANWE.Text, '%'), 'NAME', ftString, B, -1, ANWESql);
  GenerateSQL(StrDflt(cobFltrMACH.Text, '%'), 'NAME', ftString, B, -1, MACHSql);
  GenerateSQL(StrDflt(cobFltrUSER.Text, '%'), 'NAME', ftString, B, -1, USERSql);
  GenerateSQL(StrDflt(cobFltrVORG.Text, '%'), 'NAME', ftString, B, -1, VORGSql);

  S := '';
  if btnFltrANWE.Down then
    AppendTok(S, 'A', ';'); //'{(TYP = ''A'') and ' + ANWESql + '}', ';');
  if btnFltrMACH.Down then
    AppendTok(S, '{(TYP = ''M'') and ' + MACHSql + '}', ';');
  if btnFltrUSER.Down then
    AppendTok(S, '{(TYP = ''U'') and ' + USERSql + '}', ';');
  if btnFltrVORG.Down then
    AppendTok(S, '{(TYP = ''V'') and ' + VORGSql + '}', ';');
  Nav.FltrList.Values['TYP'] := S;
  if btnFltrSECT.Down then
    Nav.FltrList.Values['SECTION'] := cobFltrSECT.Text else
    Nav.FltrList.Values['SECTION'] := '';
end;

procedure TFrmINITED.LDataSource1StateChange(Sender: TObject);
begin
  BtnMu1.Visible := Nav.nlState = nlInactive;
  if BtnMu1.Visible then
    BtnMu1.Default := true;
end;

procedure TFrmINITED.btnMu1Click(Sender: TObject);
begin
  try
    Query1.Open;
    Mu1.SetFocus;
  except on E:Exception do
    EMess(Query1, E, BtnMu1.Caption, [0]);
  end;
end;

procedure TFrmINITED.NavBeforeInsert(ADataSet: TDataSet;
  var Done: Boolean);
begin
  Done := true;
  TDlgInitEdi.Execute(Nav.NavLink, true);
end;

procedure TFrmINITED.btnEditorClick(Sender: TObject);
begin
  TDlgInitEdi.Execute(LuEntry.NavLink, false);
end;

procedure TFrmINITED.TblEntryAfterInsert(DataSet: TDataSet);
begin
  LuEntry.GetFields(LuEntry.References);  //oder SOList
end;

procedure TFrmINITED.TblEntryAfterPost(DataSet: TDataSet);
begin
(* Refresh aller Einträge jetzt bei close - 26.03.09
  with DataSet do
  begin
    if (IniDb <> nil) and
       (IniDb.Anwendung = FieldByname('ANWENDUNG').AsString) then
    begin
      case FieldAsChar(FieldByname('TYP')) of
        'M': if IniDb.Maschine = FieldByname('NAME').AsString then
             begin
               IniDb.Maschine := '';
               IniDb.Maschine := FieldByname('NAME').AsString;
             end;
        'U': if IniDb.User = FieldByname('NAME').AsString then
             begin
               IniDb.User := '';
               IniDb.User := FieldByname('NAME').AsString;
             end;
      else  // 'A', 'V'
               IniDb.Anwendung := '';
               IniDb.Anwendung := FieldByname('ANWENDUNG').AsString;
      end;
    end;
  end;
*)  
end;

procedure TFrmINITED.lovFltrAnweClick(Sender: TObject);
var
  AValue: string;
begin
  AValue := LovDlgEx(Nav.NavLink, 'ANWENDUNG', []);     {mit/ohne Filter}
  cobAddText(cobFltrAnwe, AValue);
end;

procedure TFrmINITED.lovFltrMachClick(Sender: TObject);
var
  AValue: string;
begin
  LuLOV.References.Clear;
  LuLOV.References.Values['TYP'] := 'M';
  if btnFltrAnwe.Down then
    LuLOV.References.Values['ANWENDUNG'] := cobFltrAnwe.Text;
  TblLOV.FieldByName('NAME').DisplayLabel := 'Maschine';
  AValue := LovDlgEx(LuLOV.NavLink, 'NAME', [lovFltr]);     {mit/ohne Filter}
  if AValue <> '' then
  begin
    cobFltrMach.SelectAll;
    SendChar(cobFltrMach, AValue);
  end;
end;

procedure TFrmINITED.lovFltrUserClick(Sender: TObject);
var
  AValue: string;
begin
  LuLOV.References.Clear;
  LuLOV.References.Values['TYP'] := 'U';
  if btnFltrAnwe.Down then
    LuLOV.References.Values['ANWENDUNG'] := cobFltrAnwe.Text;
  TblLOV.FieldByName('NAME').DisplayLabel := 'User';
  AValue := LovDlgEx(LuLOV.NavLink, 'NAME', [lovFltr]);     {mit/ohne Filter}
  if AValue <> '' then
  begin
    cobFltrUser.SelectAll;
    SendChar(cobFltrUser, AValue);
  end;
end;

procedure TFrmINITED.Query1AfterClose(DataSet: TDataSet);
begin
  TblEntry.Close;
end;

procedure TFrmINITED.btnCopyClick(Sender: TObject);
var
  Anwe, Mach, User, Grup, Sect: string;
  S: string;
begin
  //Anwe := cobFltrAnwe.Text;
  Mach := cobFltrMach.Text;
  User := cobFltrUser.Text;
  Grup := cobFltrVorg.Text;
  //Sect := cobFltrSect.Text;
  Sect := Query1.FieldByName('SECTION').AsString;
  Anwe := Query1.FieldByName('ANWENDUNG').AsString;
  S := Query1.FieldByName('NAME').AsString;
  case FieldAsChar(Query1.FieldByName('TYP')) of
    'A': Anwe := S;
    'M': Mach := S;
    'U': User := S;
    'V': Grup := S;
  end;
  if TDlgInitCpy.Execute(Nav.NavLink, true, Anwe, Mach, User, Grup, Sect) then
  begin
    cobAddItem(cobFltrAnwe, Anwe);
    cobAddItem(cobFltrMach, Mach);
    cobAddItem(cobFltrUser, User);
    cobAddItem(cobFltrVorg, Grup);
    cobAddItem(cobFltrSect, Sect);
  end;
end;

procedure TFrmINITED.NavBeforeEdit(ADataSet: TDataSet; var Done: Boolean);
begin
  Done := true;
  PostMessage(self.Handle, WM_COMMAND, 0, BtnEditor.Handle);
end;

procedure TFrmINITED.Query1AfterOpen(DataSet: TDataSet);
begin
  DataSet.FieldByName('SECTION').OnGetText := Query1SECTIONOnGetText;
  TblEntry.Open;
end;

type
  TDummyField = class(TField); //Zugriff auf protected GetText()

procedure TFrmINITED.Query1SECTIONOnGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
var
  S: string;
begin
  TDummyField(Sender).GetText(Text, DisplayText);
  with Sender.DataSet do
  try
    S := FieldByName('NAME').AsString;
    case Char1(FieldByName('TYP').AsString) of
      'A': cobAddItem(cobFltrAnwe, S);
      'M': cobAddItem(cobFltrMach, S);
      'U': cobAddItem(cobFltrUser, S);
      'V': cobAddItem(cobFltrVorg, S);
    end;
    cobAddItem(cobFltrSect, Text); //FieldByName('SECTION').AsString);
    S := FieldByName('ANWENDUNG').AsString;
    cobAddItem(cobFltrAnwe, S);
  except on E:Exception do
    EProt(Sender.DataSet, E, 'TFrmINITED.Query1SECTIONOnGetText', [0]);
  end;
end;

procedure TFrmINITED.NavBeforeDelete(ADataSet: TDataSet;
  var Done: Boolean);
begin
  //Section bein nächsten mal neu einlesen:
  IniDb.SectionTypChar[ADataSet.FieldByName('SECTION').AsString] := #0;
  if Nav.NavLink.InBeforeDelete then
  begin
    Done := true;
    LuEntry.DeleteAll;
  end;
  if not Nav.NavLink.InDoDeleteMarked then
    Nav.Refresh;
end;

procedure TFrmINITED.cobFltrKeyPress(Sender: TObject; var Key: Char);
begin
  Key := UpCase(Key);
end;

procedure TFrmINITED.btnImportClick(Sender: TObject);
var
  Anwendung, Maschine, User, Filename: string;
begin
  Anwendung := AnsiUppercase(OnlyFileName(Application.ExeName)); //'QUVA32';
  Maschine := AnsiUppercase(CompName);
  User := Sysparam.Username;
  Filename := '';
  if IsAlphaNum(Char1(cobFltrAnwe.Text)) then
    Anwendung := cobFltrAnwe.Text;
  if IsAlphaNum(Char1(cobFltrMach.Text)) then
    Maschine := cobFltrMach.Text;
  if IsAlphaNum(Char1(cobFltrUser.Text)) then
    User := cobFltrUser.Text;
  TDlgInitImp.Execute(Anwendung, Maschine, User, Filename);
end;

procedure TFrmINITED.BtnSearchClick(Sender: TObject);
begin
  TDlgIniSearch.FindFirst;
end;

procedure TFrmINITED.MiFindNextClick(Sender: TObject);
begin
  TDlgIniSearch.FindNext;
end;

end.
