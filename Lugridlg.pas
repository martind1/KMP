unit Lugridlg;
(* Lookup Grid: Dynamisch angepasstes Multi für Lookups im Modus LuGrid

   10.11.98    von Einzelsicht zurück wieder auf LuGrid
               (bisher: zurück zum Caller-Formular)
   06.06.00    Insert, Edit möglich: ruft erst Fremdmaske auf
   16.04.09    Position und Größe merken. Größe änderbar.
               LuGridSavePos oder SysParam.GridSavePos=True
   17.04.09    Positionieren über Anfangsbuchstaben. LuGridSearch=true
   20.01.11 md  bei GridFltr: Focus auf Feld für Eingabe. Wenn Len=1 dann '*' ergänzen
   29.11.13 md  GridFltr:Filter anzeigen. Focus wieder auf Mu aber nur wenn Filter <> ''
                Up/Down wechselt zu Suchfeld
*)

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls, Tabs,
  Buttons, ExtCtrls, Lnav_kmp, DB, Uni, DBAccess, MemDS, Grids, DBGrids, Messages,
  Prots, Mugrikmp, Btnp_kmp, Qwf_Form, LuDefKmp, DPos_Kmp, UDS__Kmp, UQue_Kmp,
  Psrc_kmp;

type
  (* Trick um an private Felder ranzukommen *)
  TDummyGrid = class(TDBGrid);

  TLuDlg = class(TObject)
  public
    {LeftTop: TPoint;                 ->LuRect}
    LuRect: TRect;
    AdjustGridSize: boolean;
    CallerForm: TqForm;
    CallerLNav: TLNavigator;
    CallerLuDef: TLookUpDef;
    procedure Execute(ALookUpDef: TLookUpDef);
  end;

  TDlgLuGrid = class(TqForm)
    LuTabSet: TLTabSet;
    Nav: TLNavigator;
    panCenter: TPanel;
    PageBook: TNotebook;
    Label1: TLabel;
    BtnTabelle: TBitBtn;
    Mu1: TMultiGrid;
    PanelMuSi: TPanel;
    BtnMulti: TqBtnMuSi;
    BtnSingle: TqBtnMuSi;
    panFltr: TPanel;
    Label2: TLabel;
    cobFltr: TComboBox;
    EdFltr: TEdit;
    btnFltr: TBitBtn;
    PanSchnellsuche: TPanel;
    LaSchnellsuche: TLabel;
    Query1: TuQuery;
    LDataSource1: TuDataSource;
    PsDflt: TPrnSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Mu1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LuGridDblClick(Sender: TObject);
    procedure NavStartReturn(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NavPageChange(PageIndex: Integer);
    procedure LDataSource1StateChange(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure BtnTabelleClick(Sender: TObject);
    procedure LDataSource1DataChange(Sender: TObject; Field: TField);
    procedure FormDestroy(Sender: TObject);
    procedure NavBeforeInsert(ADataSet: TDataSet; var Done: Boolean);
    procedure NavBeforeEdit(ADataSet: TDataSet; var Done: Boolean);
    procedure NavPostStart(Sender: TObject);
    procedure btnFltrClick(Sender: TObject);
    procedure Mu1LayoutChanged(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Query1AfterOpen(DataSet: TDataSet);
    procedure NavPoll(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure cobFltrChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    procedure BCLuGrid(var Message: TMessage); message BC_LUGRID;
  private
    { Private declarations }
    ActionFlag: char;
    CallerLayoutChanged: TNotifyEvent;
    LoadedFltrList: TFltrList;
  public
    { Public declarations }
    LuDlg: TLuDlg;
  end;

var
  AktLuDlg: TLuDlg;
  DlgLuGrid: TDlgLuGrid;
  LuGridCounter: Word;
  LuGridCount: Integer;              {Anzahl gestarteter LuGrids}

implementation
{$R *.DFM}
uses
  SysUtils, System.Character,
  GNav_Kmp, NLnk_Kmp, Err__Kmp, KmpResString, CPor_Kmp {BS}, UDatasetIF;

(*** LuDlg ********************************************************************)

procedure TLuDlg.Execute(ALookUpDef: TLookUpDef);
var
  TmpDlgLuGrid: TDlgLuGrid;
begin
  AktLuDlg := self;
  CallerForm := ALookUpDef.Owner as TqForm;
  //SavePosition := LuGridSavePos in ALookUpDef.Options;
  CallerLuDef := ALookUpDef;
  CallerLNav := CallerForm.LNavigator;
  TmpDlgLuGrid := TDlgLuGrid.Create(Application.MainForm);  //beware CallerForm. bringt EAccess

  GNavigator.AddTempForm(TmpDlgLuGrid.Nav.FormKurz, TDlgLuGrid);
  GNavigator.SetForm(TmpDlgLuGrid.Nav.FormKurz, TmpDlgLuGrid);
  GNavigator.LookUp(CallerLNav, ALookUpDef, TmpDlgLuGrid.Nav.FormKurz);
end;

(*** TDlgLuGrid *************************************************************)

procedure TDlgLuGrid.FormCreate(Sender: TObject);
begin
  LuDlg := AktLuDlg;
  DlgLuGrid := self;
  self.Font.Assign(LuDlg.CallerForm.Font);
  GNavigator.TranslateForm(self);
  Inc(LuGridCounter);
  Inc(LuGridCount);
  LoadedFltrList := TFltrList.Create;
  try
    PanelMuSi.Visible := GNavigator.LokalMuSi;
    panFltr.Visible := (luGridFltr in LuDlg.CallerLuDef.Options);
    PanSchnellsuche.Visible := LuGridSearch in LuDlg.CallerLuDef.Options;
    Nav.NoAccelCharInTabs := PanSchnellsuche.Visible;
    LaSchnellsuche.Caption := '';
    with LuDlg do
    begin
      Caption := Format('%.100s',[CallerLuDef.NavLink.Display]);  //'LookUp %.100s',[NavLink.Display]);
      //Nav.FormKurz := Format('LOOKUP%02d', [LuGridCounter]);
      Nav.FormKurz := Format('%s.LUGRID', [OwnerDotName(LuDlg.CallerLuDef)]);  //16.04.09
      Nav.TabTitel := CallerLuDef.TabTitel;
      Nav.NavLink.Display := CallerLuDef.TabTitel;

      if Supports(CallerLuDef.DataSet, IUDataset) then
      begin
        //DB1 duplikates
        if BeginsWith((CallerLuDef.DataSet as IUDataset).GetDataBaseName, 'DB1', true) then
          Query1.DataBaseName := 'DB1' else  //DB1_DUPL -> DB1
          Query1.DataBaseName := (CallerLuDef.DataSet as IUDataset).GetDataBaseName;
      end;
      {Query1.DataSource := MasterSource;      {für :Params}
      {DataSource.}

      {Nav.NavLink.NoBuildSql := Navlink.NoBuildSql; schlecht wenn von
        BCDatachange}
      if CallerLuDef.DataSet is TuQuery then
      begin
        Query1.RequestLive := TuQuery(CallerLuDef.DataSet).RequestLive;
        if (CallerLuDef.TableName = '') or Nav.NavLink.NoBuildSql then
          Query1.SQL := TuQuery(CallerLuDef.DataSet).SQL;
      end else
        Query1.RequestLive := true;
      Nav.NavLink.LoadedRequestLive := Query1.RequestLive; {für NLnk.BuildSql}

      Nav.CalcList := CallerLuDef.CalcList;
      Nav.FormatList := CallerLuDef.FormatList;
      {Nav.FltrList := FltrList;}  {q nein, bereits in setreturn}
      Nav.KeyList := CallerLuDef.KeyList;
      Nav.KeyFields := CallerLuDef.KeyFields;  //KeyFields werden in Nav.SetReturn überschrieben
      if CallerLuDef.KeyList.Values['LookUp'] <> '' then        //Spezialsortierung für LookupGrid
        Nav.KeyFields := CallerLuDef.KeyList.Values['LookUp'];    //siehe auch Nav.SetReturn
      Nav.NavLink.InitKeyFields := false;    //ggf. von INI reataurieren
      Nav.PrimaryKeyFields := CallerLuDef.PrimaryKeyFields;
      Nav.SqlFieldList := CallerLuDef.SqlFieldList;
      Nav.NavLink.NoBuildSql := true;
      Nav.TableName := CallerLuDef.TableName;
      Nav.NavLink.NoBuildSql := false;
      Nav.OnGet := CallerLuDef.OnGet;
      Nav.OnBuildSql := CallerLuDef.OnBuildSql;
      {for I:= References.Count-1 downto 0 do
      begin                                    (nein, bereits in setreturn)
        AString := References.Strings[I];
        if Pos(':',AString) = 0 then
          Nav.References.Insert(0, AString);
      end;}
      Mu1.IniSection := Format('%s.LookUp.%s.%s',     {Layout speichern}
        [SSpalten, LuDlg.CallerForm.ClassName, LuDlg.CallerLuDef.Name]);
      self.Font.Assign(LuDlg.CallerForm.Font);
      if (LuGridSavePos in LuDlg.CallerLuDef.Options) or SysParam.GridSavePos then
      begin
        Nav.Options := Nav.Options + [lnSavePosition];
      end;
      Nav.Navlink.DisabledButtons := CallerLuDef.DisabledButtons;  //kann somit Query verbieten
      Mu1.OnDrawDataCell := CallerLuDef.GridDrawDataCell;
      //Mu1.OnLayoutChanged := GridLayoutChanged;
      CallerLayoutChanged := CallerLuDef.GridLayoutChanged;
      Mu1.ColumnList := CallerLuDef.ColumnList;
      Mu1.AddKeyList;

      cobFltr.Items.Clear;
      cobFltr.Text := Nav.KeyFields;
    end;
    Nav.NavLink.EnabledButtons := Nav.NavLink.EnabledButtons + [qnbInsert, qnbEdit];
    BroadcastMessage(self, TForm, BC_FORMCREATE, 0);
  except
    on E:Exception do
      ErrWarn('DlgLuGrid.FormCreate:%s',[E.Message]);
  end;
end;

procedure TDlgLuGrid.FormDestroy(Sender: TObject);
begin
  Dec(LuGridCount);
  if DlgLuGrid = self then
    DlgLuGrid := nil;
  LoadedFltrList.Free;
  LuDlg.Free;
end;

procedure TDlgLuGrid.FormResize(Sender: TObject);
begin
  FormResizeStd(self);
  btnFltr.Left := EdFltr.Left + EdFltr.Width;
end;

procedure TDlgLuGrid.NavPostStart(Sender: TObject);
begin
  BringToFront;
  Height := Height + 1;  //Resize
  Mu1.SetFocus;
  //29.11.13 weg
  if panFltr.Visible and (EdFltr.Text = '') then
    EdFltr.SetFocus;
end;

procedure TDlgLuGrid.NavPoll(Sender: TObject);
begin
  { Blinkt!
  I := 0;
  while ((GetWindowLong(Mu1.Handle, GWL_STYLE) and WS_HSCROLL) <> 0) and
        (Width < GNavigator.ClientWidth) do
  begin
    Width := Width + 1;
    Application.ProcessMessages;
    I := I + 1;
  end; }
//  DMess('Width += %d', [I]);  immer 14
end;

procedure TDlgLuGrid.NavStart(Sender: TObject);
(* Breite Festlegen:
   - zu schmal: letztes Feld breiter
   - zu breit: Formular breiter *)
var
  i, WidthOfCols, DiffWidth: integer;
  CCount: LongInt;
  ALuRect: TRect;
  ATop, ALeft, AWidth, AHeight: integer;
begin
  MinMaxInit := false;
  AWidth := Width;
  AHeight := Height;

  CCount := TDummyGrid(Mu1).ColCount;  {pt-Zugriff geht weil in gleicher unit}
  if CCount > 0 then
  begin
    //PanelMuSi.Visible := GNavigator.LokalMuSi;   in Create 21.08.03

    WidthOfCols := 0;
    for i := 0 to CCount - 1 do
      Inc(WidthOfCols, TDummyGrid(Mu1).ColWidths[i]);
    Inc(WidthOfCols, CCount + 1);
    DiffWidth := Mu1.ClientWidth -
                 (WidthOfCols + NonClientMetrics.iScrollWidth);  // 17.08.06
    if DiffWidth > 0 then                       {letzte Spalte vergrößern}
    begin
       {TDummyGrid(Mu1).ColWidths[CCount - 1] :=
       TDummyGrid(Mu1).ColWidths[CCount - 1] + DiffWidth}
    end else
    begin
      AWidth := AWidth + Abs(DiffWidth);          {Formular verbreitern}
    end;
  end;
  ALuRect.TopLeft := Application.MainForm.ScreenToClient(      {NEIN quva.ausu}
    LuDlg.LuRect.TopLeft);                         {290798 SO müssts doch gehen}
  ALuRect.BottomRight := LuDlg.LuRect.BottomRight;

  ATop := IMax(0, ALuRect.Top);
  ALeft := IMax(0, ALuRect.Left);
  if LuDlg.AdjustGridSize then           {Position erzwingen über Verkleinerung}
  begin
    AWidth := iMin(AWidth, GNavigator.ClientWidth - ALeft);
    AHeight := iMin(AHeight, GNavigator.ClientHeight - ATop);
  end;
  if ATop + AHeight > GNavigator.ClientHeight then ATop := 0;
  if ALeft + AWidth > GNavigator.ClientWidth then
    if AWidth <= ALeft then ALeft := 0;      {0: nur wenn es links davon reinpasst}
  AWidth := iMin(AWidth, GNavigator.ClientWidth);
  AHeight := iMin(AHeight, GNavigator.ClientHeight);
  ALeft := IMin(ALeft, GNavigator.ClientWidth - AWidth);
  ATop := IMin(ATop, GNavigator.ClientHeight - AHeight);
  SetBounds(ALeft, ATop, AWidth, AHeight);

  if (LuGridSavePos in LuDlg.CallerLuDef.Options) or SysParam.GridSavePos then
  begin
    self.Sizeable := true;
    self.MaxSizeable := true;
    self.LoadPosition;  //wurde noch nicht aufgerufen weil lnSavePosition zu spät kam
  end;

  (* warum. Ist in SetMinMaxInfo enthalten - 16.04.09 - height *)
  MinMaxWidth := Width;
  MinMaxHeight := Height;
  InitWidth := Width;            {OK}
  InitHeight := Height;
  MaxLeft := GNavigator.ClientWidth - Width;
  MaxTop := GNavigator.ClientHeight - Height;
  MaxWidth := GNavigator.ClientWidth;
  MaxHeight := GNavigator.ClientHeight;
  MinMaxInit := true;

  Enabled := true;
  {ShowNormal;}
  BtnSingle.Enabled := LuDlg.CallerLuDef.LuKurz <> '';
  LoadedFltrList.Assign(Nav.FltrList);
  Query1.Open;
end;

procedure TDlgLuGrid.NavBeforeInsert(ADataSet: TDataSet;
  var Done: Boolean);
begin
  Done := true;
  ActionFlag := 'I';
  Nav.PageIndex := 0;
  //PostMessage(GNavigator.X.Handle, BC_GNAVCLICK, WParam(qnbInsert), 0);
end;

procedure TDlgLuGrid.NavBeforeEdit(ADataSet: TDataSet; var Done: Boolean);
begin
  if not Nav.InStartReturn then
  begin
    Done := true;
    ActionFlag := 'E';
    Nav.PageIndex := 0;
    //PostMessage(GNavigator.X.Handle, BC_GNAVCLICK, WParam(qnbEdit), 0);
  end;
end;

procedure TDlgLuGrid.NavPageChange(PageIndex: Integer);
(* wechseln zu Formular *)
begin
  if (LuDlg <> nil) and
     (LuDlg.CallerLuDef <> nil) and (LuDlg.CallerLNav <> nil) and
     (LuDlg.CallerLuDef.LuKurz <> '') then
    if PageIndex < 10 then       {auf Single}
    begin
      with LuDlg.CallerLuDef do
      begin
        if Nav.PrimaryKeyFields <> '' then
        begin
          DataPos.Clear;
          DataPos.AddFieldsValue(Query1, Nav.PrimaryKeyFields);
          //DataPos.AddFltrList(Query1, Nav.FltrList, false);
        end else
          DataPos.GetValues(Query1);
        SendMessage(Handle, BC_LUGRID, lgPageChange, 0);   {auf Mu1 zurück: Post}
      end;
      {vom Einzelsicht-Formular nicht mehr auf Mu1 zurück:}
      if not (csDestroying in ComponentState) then  //unklar warum diese Abfrage notwendig ist. - 27.07.08
      begin
        BtnMulti.Down := true;
        Close;                {111098}
      end;
    end;
end;

procedure TDlgLuGrid.BCLuGrid(var Message: TMessage);  //message BC_LUGRID;
var
  OldLookUpTyp: TLookUpTyp;
  OldLookUpModus: TLookUpModus;
  Flag: char;
begin
  if Message.WParam = lgPageChange then
  begin
    Flag := ActionFlag;
    ActionFlag := ' ';
    PageBook.PageIndex := 1;
    with LuDlg.CallerLuDef do
    begin
      OldLookUpTyp := LookUpTyp;
      OldLookUpModus := LookUpModus;
      LookUpTyp := lupFMask;
      if Flag = 'I' then
        LookUpModus := lumErfassMsk else
        LookUpModus := lumZeigMsk;
      try
        {GNavigator.LookUp(Nav, LuDlg.CallerLuDef, LuKurz);}
        {vom Einzelsicht-Formular nicht mehr auf Mu1 zurück:}
        GNavigator.LookUp(LuDlg.CallerLNav, LuDlg.CallerLuDef, LuKurz);
//        if Flag = 'I' then
//          PostMessage(GNavigator.X.Handle, BC_GNAVCLICK, WParam(qnbInsert), 0);
        if Flag = 'E' then
          PostMessage(GNavigator.X.Handle, BC_GNAVCLICK, WParam(qnbEdit), 0);
      finally
        LookUpTyp := OldLookUpTyp;
        LookUpModus := OldLookUpModus;
      end;
    end;
  end;
end;

procedure TDlgLuGrid.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDlgLuGrid.Mu1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    {siehe MultiGrid.KeyDown
    if (Nav.ReturnLookUpModus = lumDetailTab) then
      Nav.Take else
      Nav.StartReturn;}
  end else
  if Key = VK_ESCAPE then
    Close;
end;

procedure TDlgLuGrid.LuGridDblClick(Sender: TObject);
begin
  {siehe MultiGrid.DblClick
  if (Nav.ReturnLookUpModus = lumDetailTab) then
    Nav.Take else
    Nav.StartReturn;}
end;

procedure TDlgLuGrid.NavStartReturn(Sender: TObject);
begin
  Query1.Close;               {schnellere Übernahme in Caller}
end;

procedure TDlgLuGrid.LDataSource1StateChange(Sender: TObject);
begin
  if Nav.dsQuery or Nav.dsChangeAll then
  begin
    Mu1.ReadOnly := false;
    Mu1.Options := Mu1.Options - [dgRowSelect];
    Mu1.Options := Mu1.Options + [dgEditing,dgAlwaysShowEditor];
  end else
  begin
    Mu1.ReadOnly := true;
    Mu1.Options := Mu1.Options - [dgEditing,dgAlwaysShowEditor];
    {Mu1.Options := Mu1.Options + [dgRowSelect]; 290897 Nein, damit
                                      User waagr. scrollen kann}
  end;
end;

procedure TDlgLuGrid.BtnTabelleClick(Sender: TObject);
begin
  PageBook.PageIndex := 1;   {Multi}
end;

procedure TDlgLuGrid.cobFltrChange(Sender: TObject);
var
  I: integer;
begin  //29.11.13: Filter anzeigen
  for I := 0 to Mu1.ColumnList.Count - 1 do
    if TokenAt(StrParam(Mu1.ColumnList[I]), ':', 1) = cobFltr.Text then
    begin
      EdFltr.Text := Nav.FltrList.Values[StrValue(Mu1.ColumnList[I])];
      Break;
    end;
end;

procedure TDlgLuGrid.LDataSource1DataChange(Sender: TObject;
  Field: TField);
begin
  try
    if assigned(LuDlg.CallerLuDef.NavLink.OldDataChange) then
      LuDlg.CallerLuDef.NavLink.OldDataChange(Sender, Field);
  except on E:Exception do
      EProt(self, E, 'LuDataSourceDataChange',[0]);
    {Caller bereits beendet}
  end;
end;

procedure TDlgLuGrid.btnFltrClick(Sender: TObject);
var
  FltrStr, FieldStr, NextS: string;
  I: integer;
  S1: string;
begin
  if cobFltr.Text = '' then
    EError(SLuGriDlg_001, [0]);  //'Suchspalte fehlt'
  FieldStr := cobFltr.Text;  //Falls Feldname direkt
  for I := 0 to Mu1.ColumnList.Count - 1 do
    if PStrTok(StrParam(Mu1.ColumnList[I]), ':', NextS) = cobFltr.Text then
    begin
      FieldStr := StrValue(Mu1.ColumnList[I]);
      break;
    end;

  FltrStr := edFltr.Text;
  if (PosCh(['*','%',';','>','<','='], FltrStr) = 0) and
     (Pos('..', edFltr.Text) = 0) then
  begin
    if Length(FltrStr) <= 2 then
      FltrStr := FltrStr + '*' else  //20.01.11 ge -> GE*
      FltrStr := '..' + FltrStr;
    edFltr.Text := FltrStr;
  end;
  Nav.FltrList.Assign(LoadedFltrList);
  S1 := FltrStr;
  AppendUniqueTok(S1, ToUpper(FltrStr), ';', false);
  AppendUniqueTok(S1, ToLower(FltrStr), ';', false);
  AppendUniqueTok(S1, FirstUpper(FltrStr), ';', false);
  Nav.FltrList.Values[FieldStr] := S1;
  Query1.Open;
end;

procedure TDlgLuGrid.Mu1LayoutChanged(Sender: TObject);
var
  NextS, OldText: string;
  I, II: integer;
begin
  if panFltr.Visible then
  begin
    //Section := Format('Filter.LookUp.%s.%s', [LuDlg.CallerForm.ClassName, LuDlg.CallerLuDef.Name]);
    OldText := cobFltr.Text;
    cobFltr.Items.Clear;
    for I := 0 to Mu1.ColumnList.Count - 1 do
    begin
      II := cobFltr.Items.Add(PStrTok(StrParam(Mu1.ColumnList[I]), ':', NextS));
      if OldText = cobFltr.Items[II] then
      begin
        cobFltr.ItemIndex := II;
      end;
    end;
    if cobFltr.ItemIndex = -1 then
      ComboBoxSetIndex(cobFltr, IMin(0, cobFltr.Items.Count - 1));  //mit changed
  end;
  if assigned(CallerLayoutChanged) then
    CallerLayoutChanged(Sender);
end;

procedure TDlgLuGrid.Query1AfterOpen(DataSet: TDataSet);
var
  I: integer;
  CallerField, GridField: TField;
begin
  //Get/SetText von Caller übernehmen (Quva.KUVE). evtl. als Option.
  with LuDlg.CallerLuDef do
  begin
    for I := 0 to NavLink.DataSet.FieldCount - 1 do
    begin
      CallerField := NavLink.DataSet.Fields[I];
      GridField := Query1.FindField(CallerField.FieldName);
      if GridField <> nil then
      begin
        GridField.OnGetText := CallerField.OnGetText;
        GridField.OnSetText := CallerField.OnSetText;
      end;
    end;
  end;
end;

procedure TDlgLuGrid.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) and (ActiveControl = EdFltr) then
  begin
    ActiveControl := Mu1;
    Key := 0;
  end;
  if (Key = VK_UP) and (ActiveControl = Mu1) and Query1.BOF then
  begin
    ActiveControl := EdFltr;
    Key := 0;
  end;
  if (Key = VK_ESCAPE) and (ActiveControl <> Mu1) then
  begin
    Self.Close;
    Key := 0;
  end;
end;

procedure TDlgLuGrid.FormKeyPress(Sender: TObject; var Key: Char);
var
  S: string;
begin
  if not (LuGridSearch in LuDlg.CallerLuDef.Options) then
    Exit;
  if (Ord(Key) < 32) and (Key <> Chr(BS)) then
    Exit;  //Ctrl-Key, Esc

  if Ord(Key) = 127 then  //Strg + BS
  begin
    LaSchnellsuche.Caption := '';
    S := '0';
  end else
  if Key = Chr(BS) then
    LaSchnellsuche.Caption := Copy(LaSchnellsuche.Caption, 1, IMax(0, Length(LaSchnellsuche.Caption) - 1))
  else
    LaSchnellsuche.Caption := LaSchnellsuche.Caption + Key;

  if Key = Chr(BS) then
    S := LaSchnellsuche.Caption + '0' else   //damit zurückpositioniert wird
    S := LaSchnellsuche.Caption;

  Nav.DataPos.Text := Format('%s=%s', [Nav.Navlink.KeyFieldList[Nav.Navlink.KeyFieldList.Count - 1], S]);
  Nav.DataPos.GotoNearest(Query1, [{dpoEnableControls,} dpoNoProcessMessages, dpoPrior, dpoNext]);

  Key := #0;  //keine Weiterverarbeitung
end;

initialization

begin
  LuGridCounter := 1;
end;

end.
