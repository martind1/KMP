unit ReplaceDlg;
(* Suchen und Ersetzen Dialog. An Word2000 orientiert
   16.02.04 MD  erstellt
   20.01.09 MD  EnableControls während Ändern: automatisch in DoEdit
   20.04.09 MD  Flag für NavRech ua: SysParam.InReplace
   29.11.11 md  Ganzes Feld vergleichen: auf Nein voreingestellt

   Rechteverwaltung:
   um das ersetzen zu erlauben: Maske FRMREPLACEDLG, Update=X
   ---------------------------------------------
   todo: ResStrings
         Auswahlfelder: text
         - suchen nach, ersetzen durch: zeigen Auswahl Text
*)
{ TODO : replace generell verbieten. Nur erlauben für User mit FRMREPLACEDLG Update Berechtigungen. }
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls,
  Qwf_Form, NLnk_Kmp, Lnav_kmp, Menus;

type
  TDlgReplace = class(TqForm)
    Panel1: TPanel;
    Panel3: TPanel;
    DetailControl: TTabControl;
    Label1: TLabel;
    cobField: TComboBox;
    cobSearch: TComboBox;
    Label2: TLabel;
    chbMark: TCheckBox;
    laReplace: TLabel;
    cobReplace: TComboBox;
    BtnSearch: TBitBtn;
    BtnCancel: TBitBtn;
    btnReplaceAll: TBitBtn;
    btnReplace: TBitBtn;
    Nav: TLNavigator;
    PanTop: TPanel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    cobDirection: TComboBox;
    chbCase: TCheckBox;
    chbFieldMatch: TCheckBox;
    chbWildcards: TCheckBox;
    btnSearchAll: TBitBtn;
    BtnClose: TBitBtn;
    BtnSetFormFocus: TBitBtn;
    edAllFields: TEdit;
    PopupMenu1: TPopupMenu;
    MiCancel: TMenuItem;
    procedure DetailControlChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure NavPoll(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure NavSetTitel(Sender: TObject; var Titel,
      Titel2: TCaption);
    procedure NavPostStart(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure btnReplaceAllClick(Sender: TObject);
    procedure DetailControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure BtnSetFormFocusClick(Sender: TObject);
    procedure cobFieldChange(Sender: TObject);
    procedure BtnCancelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    fNavLink: TNavLink;
    SearchNextS: string;
    FieldList: string;
    SearchResult: boolean; 
    SearchFieldName: string;    //gefundener Feldname zum ändern
    BtnSearchCaption, BtnCancelCaption: string;
    FirstSearch: boolean;
    FirstReplace: boolean;
    HasReplaced: boolean;
    InSearch: boolean;
    IsAswField: boolean;
    fCanceled: boolean;       //eigener Flag da der von GNav bei DoEdit usw. zurückgesetzt wird
    procedure CheckVisible;
    procedure CheckEnabled;
    function IsMarkChecked: boolean;
    procedure InitFields;
    function GetNavLink: TNavLink;
    function GetCanceled: boolean;
    procedure SetCanceled(const Value: boolean);
    function MatchField(aFieldName: string): boolean;
    procedure ReplaceField(aFieldName: string);
    procedure SearchFirst;
    procedure SearchNext;
    procedure ShowSearch;
    function EndOfTable: boolean;
    procedure MarkSearch;
    property NavLink: TNavLink read GetNavLink write fNavLink;
    procedure CopyInputLists;
    procedure Replace(All: boolean);
    procedure BuildFieldList;
    property Canceled: boolean read GetCanceled write SetCanceled;
    procedure DoCancel;
    function ReplaceAllowed: boolean;
  public
    { Public declarations }
    class procedure Execute(aNavLink: TNavLink; StartReplace: boolean);
  end;

var
  DlgReplace: TDlgReplace;

implementation
{$R *.DFM}
uses
  SysUtils, Messages, Db, DbGrids, DbCtrls, RechtKmp, KmpResString, Err__Kmp,
  Prots, GNav_Kmp, Asws_Kmp;

var
  SearchList, ReplaceList: TStringList;

const
  DirAll = 2;     //Suchrichtung
  DirUp = 1;
  DirDown = 0;
  tiSearch = 0;   //Tabindizes
  tiReplace = 1;

class procedure TDlgReplace.Execute(aNavLink: TNavLink; StartReplace: boolean);
var
  AField: TField;
begin
  if DlgReplace = nil then
  begin
    DlgReplace := Create(Application);  //Tabellenrechte in FormCreate
    DlgReplace.Init(GNavigator);    //mit Translation
    DlgReplace.Nav.DoStart(GNavigator);      {Öffnet, Ereignis LNav.OnStart}
  end;
  with DlgReplace do
  begin
    fNavLink := aNavLink;
    try
//      if StartReplace then
//        DetailControlChanging(DetailControl, StartReplace);  //StartReplace->AllowChanged
      if StartReplace and ReplaceAllowed then
        DetailControl.TabIndex := tiReplace else
        DetailControl.TabIndex := tiSearch;
    except on E:Exception do
      EProt(DlgReplace, E, 'Execute', [0]);
    end;
    cobDirection.ItemIndex := 2;   //Gesamt
    FirstSearch := true;
    FirstReplace := true;
    HasReplaced := false;
    if (aNavLink.Form <> nil) and (aNavLink.Form.ActiveControl <> nil) then
    begin
      if aNavLink.Form.ActiveControl is TDBGrid then
        AField := TDBGrid(aNavLink.Form.ActiveControl).SelectedField else
      if aNavLink.Form.ActiveControl is TDBEdit then
        AField := TDBEdit(aNavLink.Form.ActiveControl).Field else
        AField := nil;
      if aNavLink.Form.ActiveControl is TDBGrid then
      begin
        cobField.Text := AField.DisplayName;
        cobSearch.Text := AField.AsString;
      end else
      if aNavLink.Form.ActiveControl is TDBEdit then
      begin
        cobField.Text := AField.DisplayName;
        cobSearch.Text := AField.AsString;
      end else
      begin
        cobField.Text := '';
        cobSearch.Text := '';
      end;
    end;
    InitFields;
    CopyInputLists;
    cobFieldChange(cobField);
    CheckVisible;
    CheckEnabled;
    if DelphiRunning then
    begin
      //FormStyle := fsNormal;
    end;
    Show;
  end;
end;

procedure TDlgReplace.InitFields;
var
  I: integer;
  L1: TStringList;
  AField: TField;
begin
  L1 := TStringList.Create;
  try
    L1.Sorted := true;
    cobField.Items.Clear;
    for I := 0 to NavLink.DataSet.FieldCount - 1 do
    begin
      AField := NavLink.DataSet.Fields[I];
      if AField.Visible then
        cobField.Items.Add(AField.DisplayName) else
        L1.Add(AField.DisplayName);
    end;
    for I := 0 to L1.Count - 1 do   //restl. Felder sortiert anhängen
      cobField.Items.Add(L1[I]);
    cobField.Items.Add(edAllFields.Text); // * - alle Felder
  finally
    L1.Free;
  end;
end;

procedure TDlgReplace.DetailControlChange(Sender: TObject);
begin
  if (Navlink.DbGrid <> nil) and (DetailControl.TabIndex = tiReplace) then
  begin
    Navlink.DBGrid.SelectedRows.Clear;
    SendMessage(Navlink.DBGrid.Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0);
  end;
  CheckVisible;
  CheckEnabled;  //BtnSearch.Caption
end;

procedure TDlgReplace.DetailControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  //ändern nur erlaubt wenn zu Ändernde Form zum Ändern freigegeben ist
  if (DetailControl.TabIndex = tiSearch) and not ReplaceAllowed then
  begin
    ErrWarn(SQNav_Kmp_016, [NavLink.Kennung]);	// 'Sie haben keine Rechte zum Ändern (%s)'
    AllowChange := false;
  end;
end;

function TDlgReplace.ReplaceAllowed: boolean;
begin
  Result := (reUpdate in NavLink.TabellenRechte) and  //Aufrufende Form
            (reUpdate in Nav.NavLink.TabellenRechte); //FrmReplaceDlg Maske in Rechteverw.
end;

procedure TDlgReplace.CheckVisible;
var
  I: integer;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TControl then
      with TControl(Components[I]) do
        if Tag <> 0 then
          Visible := ((Tag = 1) and (DetailControl.TabIndex = tiSearch)) or
                     ((Tag = 2) and (DetailControl.TabIndex = tiReplace));
end;

procedure TDlgReplace.CheckEnabled;
begin
  BtnSearch.Enabled := (cobSearch.Text <> '') and (cobField.Text <> '');
  BtnReplace.Enabled := BtnSearch.Enabled and (cobSearch.Text <> cobReplace.Text);
  BtnReplaceAll.Enabled := BtnReplace.Enabled;
  if BtnSearchCaption <> '' then  //erst nach NavPostStart
  begin
    //if not chbMark.Checked then
    if not IsMarkChecked then
      BtnSearch.Caption := BtnSearchCaption else
      BtnSearch.Caption := btnSearchAll.Caption;
    if not HasReplaced or InSearch then
      BtnCancel.Caption := BtnCancelCaption else
      BtnCancel.Caption := BtnClose.Caption;
  end;
end;

function TDlgReplace.IsMarkChecked: boolean;
begin
  result := chbMark.Checked and (DetailControl.TabIndex = tiSearch);
end;

function TDlgReplace.GetNavLink: TNavLink;
//Schließen wenn 
begin
  Result := fNavLink;
  if fNavLink = nil then
    self.Close;
end;

function TDlgReplace.GetCanceled: boolean;
begin
  if GNavigator.Canceled then      //mit GNavigator.ProcessMessages;
    fCanceled := true;
  Result := fCanceled;
end;

procedure TDlgReplace.SetCanceled(const Value: boolean);
begin
  fCanceled := Value;
  GNavigator.Canceled := false;
end;

procedure TDlgReplace.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDlgReplace.FormCreate(Sender: TObject);
var
  TabellenRechte: TRechteSet;
  FormObj: TqFormObj;
begin
  DlgReplace := self;
  DetailControl.TabIndex := tiSearch;
  //von GNav.GetFormObj:
  //erstmal ohne Test um zu erkennen ob Form gelistet ist
  FormObj := GNavigator.GetFormObj(Nav.FormKurz, false, false);
  if FormObj <> nil then
  begin
    //jetzt mit Test. Ergibt nil wenn keine Starterlaubnis (nicht in Maskenrechten des Users erfasst)
    FormObj := GNavigator.GetFormObj(Nav.FormKurz, true, false);  //mit Test ohne Meldung
    if FormObj = nil then
      TabellenRechte := [] else
      TabellenRechte := FormObj.TabellenRechte;
  end else
  begin
    TabellenRechte := AlleRechte;  //kein Object gelistet: alles berechtigen
  end;
  Nav.Navlink.TabellenRechte := TabellenRechte;
end;

procedure TDlgReplace.FormDestroy(Sender: TObject);
begin
  DlgReplace := nil;
end;

procedure TDlgReplace.NavPostStart(Sender: TObject);
begin
  //Translation wurden durchgeführt
  BtnSearchCaption := BtnSearch.Caption;
  BtnCancelCaption := BtnCancel.Caption;
end;

procedure TDlgReplace.BtnCancelClick(Sender: TObject);
begin
  if InSearch then
  begin                      //Hotkey, Popup verarbeiten
    if not fCanceled then
      DoCancel;
  end else
    self.Close;
end;

procedure TDlgReplace.BtnCancelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DoCancel;
end;

procedure TDlgReplace.DoCancel;
begin
  if InSearch then
  begin
    Canceled := true;
    SearchResult := false;
    FirstReplace := true;
    FirstSearch := true;
    WMess(Replace_003, [0]);      //'Bedienerabbruch'
  end;
end;

procedure TDlgReplace.NavPoll(Sender: TObject);
begin
  if not SysParam.InReplace then
  try
    if fNavLink.nlState <> nlBrowse then
      self.Close;
  except
    self.Close;    //NL nicht mehr gültig
  end;
end;

procedure TDlgReplace.EditChange(Sender: TObject);
begin
  FirstSearch := true;
  if Navlink.DbGrid <> nil then
  begin
    Navlink.DBGrid.SelectedRows.Clear;
    SendMessage(Navlink.DBGrid.Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0);
  end;
  CheckEnabled;
end;

procedure TDlgReplace.cobFieldChange(Sender: TObject);
var
  NewAswField: boolean;
  AField: TField;
  AAsw: TAsw;
  I: integer;
begin
  BuildFieldList;
  AField := Navlink.DataSet.FindField(FieldList);
  NewAswField := (Char1(cobField.Text) <> '*') and
                (Pos(';', cobField.Text) = 0) and
                (AField <> nil) and (AField.Tag > 0);
  {if NewAswField then
  begin
    if (AField = nil) or (AField.Tag <= 0) then
      NewAswField := false;
  end;}
  if NewAswField then
  begin
    AAsw := Asws.Asw(AField.Tag);
    cobSearch.Items.Clear;
    for I := 0 to AAsw.Items.Count - 1 do
      cobSearch.Items.Add(AAsw.Items.Value(I));
    cobReplace.Items.Assign(cobSearch.Items);
    cobSearch.Text := AField.Text;
  end else
  begin
    if (IsAswField <> NewAswField) then
      CopyInputLists;
    if AField <> nil then
      cobSearch.Text := AField.AsString;
  end;
  IsAswField := NewAswField;
  if (AField <> nil) and AField.IsNull then
    cobSearch.Text := '=';
  cobReplace.Text := '';
  EditChange(Sender);
end;

procedure TDlgReplace.NavSetTitel(Sender: TObject; var Titel,
  Titel2: TCaption);
begin
  if FNavLink <> nil then
  begin
    //Titel2 := NavLink.Display;
    Titel := Prots.SubCaption(Titel, Prots.ShortCaption(NavLink.Form.Caption));
  end;
end;

procedure TDlgReplace.CopyInputLists;
//kopiert globale Eingabelisten in die Combos
begin
  cobSearch.Items.Assign(SearchList);
  cobReplace.Items.Assign(ReplaceList);
end;

procedure TDlgReplace.ReplaceField(aFieldName: string);
var
  S1, S2: string;
  OldSingle: boolean;
  AField: TField;
  IsOk: boolean;
begin
  AField := Navlink.Dataset.FieldByName(aFieldName);
  if AField.Tag > 0 then
    S1 := AField.Text else    //Asw Field
    S1 := AField.AsString;
  S2 := S1;
  if (cobSearch.Text = '*') or (cobSearch.Text = '=') then
    S2 := cobReplace.Text else
  if chbFieldMatch.Checked then
    S2 := cobReplace.Text else
  if chbCase.Checked then
    S2 := StringReplace(S1, cobSearch.Text, cobReplace.Text, [rfReplaceAll]) else
    S2 := StringReplace(S1, cobSearch.Text, cobReplace.Text, [rfReplaceAll,rfIgnoreCase]);
  OldSingle := Navlink.EditSingle;
  if S2 <> S1 then
  try
    SysParam.InReplace := true;
    Navlink.EditSingle := false;
    NavLink.DoEdit(true);
    try
      if AField.Tag > 0 then
      begin
        AField.Text := S2;
        IsOK := AField.Text = S2;
      end else
      begin
        AField.AsString := S2;
        IsOK := AField.AsString = S2;
      end;
      if not IsOK then
        EError(Replace_001, [0]);  //'Wert wurde nicht übernommen'
      NavLink.DoPost(True);
      if NavLink.nlState in nlEditStates then  //falls Done:=true in BeforePost
        NavLink.Dataset.Cancel;
    except on E:Exception do begin
        NavLink.Dataset.Cancel;
        EError(Replace_002, [E.Message]);  //'Fehler bei Ersetzen: %s'
      end;
    end;
  finally
    SysParam.InReplace := false;
    Navlink.EditSingle := OldSingle;
  end;
end;

function TDlgReplace.MatchField(aFieldName: string): boolean;
var
  S: string;
  AField: TField;
  function Match(S1, S2: string): boolean;
  begin
    if S1 = '*' then
      result := true else
    if S1 = '=' then
      result := S2 = '' else
    if chbFieldMatch.Checked then
    begin
      if chbCase.Checked then
        result := AnsiCompareStr(S1, S2) = 0 else
        result := AnsiCompareText(S1, S2) = 0;
    end else
    if chbCase.Checked then
      result := Pos(S1, S2) > 0 else
      result := PosI(S1, S2) > 0;
  end;
begin
  AField := Navlink.Dataset.FieldByName(aFieldName);
  if AField.Tag > 0 then
    S := AField.Text else    //Asw Field
    S := AField.AsString;
  result := Match(cobSearch.Text, S);
  if not result and (AField.Tag > 0) then
  begin
    Result := Match(cobSearch.Text, AField.AsString);
    if Result then
      S := AField.AsString;  //für Prot
  end;
  if SysParam.ProtBeforeOpen then
  begin
    if Result then
      Prot0('%s MatchField(%s)==(%s)', [Kurz, aFieldName, S]) else
      Prot0('%s MatchField(%s)<>(%s)', [Kurz, aFieldName, S]);
  end;
end;

procedure TDlgReplace.ShowSearch;
//Suchergebnis-Feld als Markierung im Grid oder Focussierung des Edits anzeigen
begin
  FocusField(NavLink.Form, NavLink.DataSet.FieldByname(SearchFieldName));
  //NavLink.Form.SetFocus;
  PostMessage(self.Handle, WM_COMMAND, 0, BtnSetFormFocus.Handle);
end;

procedure TDlgReplace.BtnSetFormFocusClick(Sender: TObject);
begin
  //NavLink.Form.SetFocus;
  FormSetFocus(NavLink.Form);
end;

procedure TDlgReplace.MarkSearch;
//Suchergebnis-Zeile im Grid markieren
begin
  if NavLink.DBGrid <> nil then
  begin
    NavLink.DBGrid.SelectedRows.CurrentRowSelected := true;
    SendMessage(Navlink.DBGrid.Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0);
  end;
end;

function TDlgReplace.EndOfTable: boolean;
begin
  if cobDirection.ItemIndex = DirUp then
    result := Navlink.Dataset.BOF else
    result := Navlink.Dataset.EOF;
end;

procedure TDlgReplace.BuildFieldList;
var
  I: integer;
  S, NextS: string;
begin
  FieldList := '';
  if Char1(cobField.Text) = '*' then
  begin  //über alle Tabellenspalten suchen
    for I := 0 to NavLink.DataSet.FieldCount - 1 do
    begin
      if not NavLink.DataSet.Fields[I].Visible then
        continue;
      AppendTok(FieldList, NavLink.DataSet.Fields[I].FieldName, ';');
    end;
  end else
  begin  //über angegebene Felder suchen. Fieldname verwenden.
    S := Trim(PStrTok(cobField.Text, ';', NextS));
    while S <> '' do
    begin
      for I := 0 to Navlink.Dataset.FieldCount - 1 do
        if (Trim(NavLink.DataSet.Fields[I].DisplayName) = Trim(S)) then   //Trim wg 'AVV  =avvnr'
        begin
          AppendTok(FieldList, NavLink.DataSet.Fields[I].FieldName, ';');
          break;
        end;
      S := Trim(PStrTok('', ';', NextS));
    end;
  end;
end;

procedure TDlgReplace.SearchFirst;
//Suche starten. Definiert SearchResult.
var
  ABookMark: TBookMark;
begin
  SearchResult := false;
  if not IsAswField then
  begin
    if SearchList.IndexOf(cobSearch.Text) < 0 then
      SearchList.Add(cobSearch.Text);
    if ReplaceList.IndexOf(cobReplace.Text) < 0 then
      ReplaceList.Add(cobReplace.Text);
    CopyInputLists;
  end;
  BuildFieldList;
  Prot0('%s (%s) in (%s) Case:%d FieldMatch:%d Wildcards:%d', [Kurz,
    cobSearch.Text, FieldList, ord(chbCase.Checked), ord(chbFieldMatch.Checked),
    ord(chbWildcards.Checked)]);
  if cobDirection.ItemIndex = DirAll then
    Navlink.DataSet.First;
  try
    Navlink.Dataset.DisableControls;
    ABookMark := Navlink.Dataset.GetBookMark;
    try
      while not SearchResult and not EndOfTable and not Canceled do
      begin
        SearchFieldName := Trim(PStrTok(FieldList, ';', SearchNextS));
        while SearchFieldName <> '' do
        begin
          if MatchField(SearchFieldName) then
          begin
            SearchResult := true;
            break;
          end;
          SearchFieldName := Trim(PStrTok('', ';', SearchNextS));
        end;
        if not SearchResult and not Canceled then
          if cobDirection.ItemIndex = DirUp then
            Navlink.Dataset.Prior else
            Navlink.Dataset.Next;
      end;
    finally
      if not SearchResult then
        Navlink.Dataset.GotoBookMark(ABookMark);
      Navlink.Dataset.FreeBookMark(ABookMark);
    end;
  finally
    Navlink.Dataset.EnableControls;
  end;
end;

procedure TDlgReplace.SearchNext;
//Suche weiterführen. Definiert SearchResult.
var
  First: boolean;
  ABookMark: TBookMark;
begin
  SearchResult := false;
  First := true;
  Navlink.Dataset.DisableControls;
  try
    ABookMark := Navlink.Dataset.GetBookMark;
    try
      while not SearchResult and not EndOfTable and not Canceled do
      begin
        if First then
        begin
          First := false;
          SearchFieldName := Trim(PStrTok('', ';', SearchNextS));
        end else
          SearchFieldName := Trim(PStrTok(FieldList, ';', SearchNextS));
        while SearchFieldName <> '' do
        begin
          if MatchField(SearchFieldName) then
          begin
            SearchResult := true;
            break;
          end;
          SearchFieldName := Trim(PStrTok('', ';', SearchNextS));
        end;
        if not SearchResult and not Canceled then
          if cobDirection.ItemIndex = DirUp then
            Navlink.Dataset.Prior else
            Navlink.Dataset.Next;
      end;
    finally
      if not SearchResult then
        Navlink.Dataset.GotoBookMark(ABookMark);
      Navlink.Dataset.FreeBookMark(ABookMark);
    end;
  finally
    Navlink.Dataset.EnableControls;
  end;
end;

procedure TDlgReplace.BtnSearchClick(Sender: TObject);
begin
  Prot0('%s', [BtnSearch.Caption]);
  try
    InSearch := true;
    Canceled := false;
    CheckEnabled;
    if not IsMarkChecked then
    begin
      if FirstSearch then
      begin
        SearchFirst;
      end else
        SearchNext;
      if SearchResult then
      begin
        FirstSearch := false;
        FirstReplace := false;
        ShowSearch;
      end else
      begin
        if not Canceled then
          if FirstSearch then
            WMess(Replace_004, [0]) else  //'keine Datensätze gefunden'
            WMess(Replace_005, [0]);      //'Suche wurde beendet'
        ProtSql(Navlink.Dataset);
        FirstSearch := true;
      end;
      CheckEnabled;
    end else
    begin   //alle gefundenen markieren:
      if Navlink.DBGrid.SelectedRows.Count = 0 then
        FirstSearch := true;     //falls vorher normal gesucht
      if FirstSearch then
      begin
        Navlink.DBGrid.SelectedRows.Clear;
        SendMessage(Navlink.DBGrid.Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0);
        SearchFirst;
      end;
      if FirstSearch and SearchResult then
      begin
        FirstSearch := false;
        while SearchResult do
        begin
          MarkSearch;
          if not HasReplaced then
          begin
            HasReplaced := true;
            CheckEnabled;
          end;
          SearchNext;
        end;
        PostMessage(NavLink.DBGrid.Handle, BC_EXTGRIDSCR, egDataChanged, 0);
      end else
      begin
        if not Canceled then
          if FirstSearch then
            WMess(Replace_004, [0]) else  //'keine Datensätze gefunden'
            WMess(Replace_005, [0]);      //'Suche wurde beendet'
        //FirstSearch := true;    //kein SelectedRows.Clear wg. DblClick mancher User
        CheckEnabled;
      end;
    end;
  finally
    InSearch := false;
    CheckEnabled;
  end;
end;

procedure TDlgReplace.Replace(All: boolean);
var
  N: integer;
begin
  try
    InSearch := true;
    CheckEnabled;
    N := 0;
    Canceled := false;
    repeat
      if FirstReplace then
      begin
        SearchFirst;
      end else
      if SearchResult then
      begin
        ReplaceField(SearchFieldName);  //setzt Canceled=false
        Inc(N);
        if not HasReplaced then
        begin
          HasReplaced := true;
          CheckEnabled;
        end;
        SearchNext;
      end;
      if SearchResult then
      begin
        FirstReplace := false;
        if not All then
          ShowSearch;
      end else
      begin
        if not Canceled then
          if FirstReplace then
            WMess(Replace_004, [0]) else  //'keine Datensätze gefunden'
            WMess(Replace_006, [N]);      //'Ersetzen wurde beendet (%d)'
        FirstReplace := true;
        CheckEnabled;
      end;
    until not SearchResult or not All or Canceled;
  finally
    InSearch := false;
    CheckEnabled;
  end;
end;

procedure TDlgReplace.btnReplaceClick(Sender: TObject);
begin
  Prot0('%s', [btnReplace.Caption]);
  Replace(false);
end;

procedure TDlgReplace.btnReplaceAllClick(Sender: TObject);
begin
  Prot0('%s', [btnReplace.Caption]);
  Replace(true);
end;

initialization
  SearchList := TStringList.Create;
  ReplaceList := TStringList.Create;
 finalization
  SearchList.Free;
  ReplaceList.Free;
end.

