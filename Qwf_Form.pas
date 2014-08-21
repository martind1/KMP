unit Qwf_form;
(* QWF - TForm-Version
   Autor: Martin Dambach
   Letzte Änderung:
   15.10.96     Erstellen
   09.05.97     UpdateEdit gelöscht. Jetzt global in Prots
   01.08.97     BCPostStart, BCSetPageIndex
   08.03.98     CloseQuery: MainForm: ComWait und PollKmp disablen
   31.05.99     Minimize
   05.07.99     PollWait-Logik bei destroy
                Sysmenü.Maximize: bei sizeable: setzt Koordinaten auf MinMax Werte
                MaxSizeable: kann immer bis Maximized-Größe vergrößert werden
   01.09.99     SavePosition (Eigenschaft im LNav)
   07.06.00     GetObjRechte: Objektrechte in Formularkmonenten übertragen
                              neu: setzt auch Visible := true wenn Recht erteilt und bisher false (HDO.Anmelden)
   19.04.02     FormResizeStd: Standard Aktionen für Resize Ereignis
   03.05.01     CheckReadOnly berücksichtigt Parent.Enabled
   05.05.03     Rechteverw.: Objektrecht kann Disabled-Objekte enablen.
   31.12.03     SetObjRechte: DBCheckbox readonly bei disabled. DBGrid:Readonly bei disabled
   03.03.04     Lookupdef: Berechtigungen von LuKurz-Form nehmen (statt von LNav)
   27.03.04     LoadFromIni; SaveToIni
   07.04.04     Comboboxen als nicht markiert verlassen (SetRoAttrib)
   26.06.08     negativer Tag verhindert Resize
   20.12.08     Resize schneller: SavePosition jetzt erst bei MouseUP
   08.04.09     FormResizeStd berücksichtigt Constraints.MaxWidth, MaxHeight
   13.01.10     Started: wird erst am Ende von StartForm true. Für PollFnk in Device-Umgebung.
   01.03.10     DatasetList: Liste: Name=<DataSAet>
   18.05.12     Resize TDirBtn
   01.08.12     Jedi JVCL Controls: TJvCheckBox
   03.06.13     SetMinMaxInfo: MinMaxInit auch wenn minimized gestartet (StartDevice)
   21.12.13     SetRoAttrib: NoCheckTabStop
   31.01.14     Loaded: FormIndex globale Var statt lokal I (Create:Init auf 1)
   --------------------------------
   08.04.08     todo: InitList: InitData als TStrings
   - Größe nicht änderbar
   - MDI-Anzeige passend
   - ShowNormal
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, TabNotBk, Mask,
  Prots, LNav_Kmp, LuEdiKmp;

type
  (* Trick für readonly: *)
  TDummyCustomEdit = class(TCustomEdit);
  (* Trick für SetSel: *)
  TDummyCustomMaskEdit = class(TCustomMaskEdit);
  (* Trick für pagelist: *)
  TDummyNoteBook = class(TTabbedNoteBook);
  (* Trick für color: *)
  TDummyControl = class(TControl);
  (* Trick für text: *)
  TDummyCustomComboBox = class(TCustomComboBox);
  (* Trick für text: *)
  TDummyCustomCheckBox = class(TCustomCheckBox);
  (* Trick für ItemIndex: *)
  TDummyCustomRadioGroup = class(TCustomRadioGroup);

  TrwvFlags = set of (rwvDialog );           {Read/Write Values eines Formulars}

  TqForm = class(TForm)
  private
    { Private-Deklarationen }
    OldCloseQuery: TCloseQueryEvent;
    InLoaded,
    HasLoaded,
    InScMaximize,
    InUpdateEdit: boolean;
    CheckedReadOnly: boolean;
    FMaximized: boolean;
    FSizeable: boolean;
    fDatasetList: TStrings;                       {verkleinerbar}

    function GetShortCaption: string;
    function GetSubCaption: string;
    function GetInitData: Pointer;
    procedure CloseQuery(Sender: TObject; var CanClose: Boolean); reintroduce;
    procedure WMShowWindow(var Message: TWMShowWindow); message WM_SHOWWINDOW;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure WMInitMenuPopup(var Msg: TWMInitMenuPopup); message WM_INITMENUPOPUP;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHitTest;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMQueryEndSession(var Message: TMessage); message WM_QUERYENDSESSION;

    procedure CMRelease(var Message: TMessage); message CM_RELEASE;

    procedure BCCreateWnd(var Message: TWMBroadcast); message BC_CREATEWND;
    procedure BCCheckReadOnly(var Message: TWMBroadcast); message BC_CHECKREADONLY;
    procedure BCPostStart(var Message: TWMBroadcast); message BC_POSTSTART;
    procedure BCSetPageIndex(var Message: TWMBroadcast); message BC_SETPAGEINDEX;
    procedure BCLNavigator(var Message: TWMBroadcast); message BC_LNAVIGATOR;
    procedure BCQForm(var Message: TMessage); message BC_QFORM;
    procedure BCPageChange(var Message: TWMBroadcast); message BC_PAGECHANGE;
    procedure BCEnableControls(var Message: TWMBroadcast); message BC_ENABLECONTROLS;
    procedure BCNextNullCtl(var Message: TMessage); message BC_NEXTNULLCTL;

    procedure SetRoAttrib(WinControl: TWinControl; NoInput: boolean; cl:TColor; TabStopOK: boolean);
    function GetInitList: TStrings;
    procedure SetMaximized(const Value: boolean);
    procedure SetSizeable(const Value: boolean);
//    procedure CNKeyDown(var Message: TWMKeyDown);
    function GetDatasetList: TStrings;
    function KurzPos: string;
  protected
    { Protected-Deklarationen }
    ObjRechteSet: boolean;
    FInitList: TStrings;
    procedure Paint; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    { Public-Deklarationen }
    LNavigator: TLNavigator;
    Caller: TComponent;
    MinMaxWidth, MinMaxHeight: integer;
    MinWidth, MinHeight: integer;
    MaxWidth, MaxHeight: integer;
    MinMaxInit: boolean;
    MaxSizeable: boolean;                    {vergrößerbar}
    InitWidth, InitHeight: integer;
    MaxLeft, MaxTop: integer;
    HasInit: boolean;
    HasStarted: boolean;    //true = mit StartForm gestartet (nicht mit LoadForm geladen)
    NoRechteCheck: boolean;
    HasRechte: boolean;
    Kurz: string;
    InCloseQuery: boolean;
    Closed: boolean;
    SavePositionFlag: boolean;
    ReverseFocusOrder: boolean;  //für FocusField
    Started: boolean;
    EnterAsTab: boolean;
    NoCheckTabStop: boolean; //true = Tabstop hier nicht bestimmen

    destructor Destroy; override;
    procedure Loaded; override;
    procedure CreateWnd; override;
    procedure ActiveChanged; override;
    procedure Resize; override;                  {hier nur damit in Kmp sichtbar}
    procedure SetMinMaxInfo;
    procedure ShowNormal(State: TWindowState = wsNormal);
    procedure Minimize;
    procedure Init(Sender: TComponent); virtual; { Aufruf in showwind und vor druck}
    function GetLNav: TLNavigator;
    procedure LoadPosition;                   {Position und Größe von INI laden}
    procedure SavePosition(Persistent: boolean); {Position und Größe in INI sichern}
    procedure SetObjRechte;
    procedure SetFormRechte(FormName: string);
    procedure CheckReadOnly;
    procedure UpdateEdit;
    procedure PutValues(AList: TStrings);     { Eingabewerte von AList übernehmen}
    procedure GetValues(AList: TStrings);     { Eingabewerte nach AList kopieren}
    procedure LoadFromIni(Section: string);   { Eingabewerte von INI übernehmen}
    procedure SaveToIni(Section: string);     { Eingabewerte nach INI schreiben}
    function FindFocusControl(CurControl: TWinControl; GoForward, CheckTabStop,
                              CheckParent: Boolean): TWinControl;

    function BroadcastForms(Sender: TComponent; ComponentRef: TComponentRef;
                             MsgNr: integer; Data: longint): longint;
    function BroadcastMessage(Sender: TComponent; ComponentRef: TComponentRef;
                               MsgNr: integer; Data: longint): longint;

    procedure ArrangeMinimized;
    function ScrollBarsVisible: Boolean;
    class procedure CheckBounds; {Scrolbars wegblenden}

    property ShortCaption: string read GetShortCaption;
    property SubCaption: string read GetSubCaption;
    property InitData: Pointer read GetInitData;              {von GNav.FormObj}
    property InitList: TStrings read GetInitList;
    property Maximized: boolean read FMaximized write SetMaximized;
    property Sizeable: boolean read FSizeable write SetSizeable;
    property DatasetList: TStrings read GetDatasetList;
  published
    { Published-Deklarationen }
  end;

  { ohne Klasse }
  function FormGetLNav(AForm: TObject): TLNavigator; (* für Designzeit *)
  procedure FormCheckAsw(AForm: TForm); (* Checkt bei Asw-Komponenten die korrekte Einstellung *)
  procedure FormSetFocus(AForm: TForm); (* Focus erzwingen. Auch wenn DBGrid aktiv. Für Umschaltung von MDIForm nach MDIChild *)
  procedure FormResizeStd(AForm: TqForm); (* Standard Aktionen für Resize Ereignis *)

implementation

uses
  System.Types,
  DB, DbCtrls,  Uni, DBAccess, MemDS, Buttons, Menus, IniFiles, DBGrids, comctrls,
  JvCheckBox {Jedi JVCL},
  GNav_Kmp, LuDefKmp, MuGriKmp, PSrc_Kmp, RechtKmp, DPos_Kmp, Err__Kmp,
  Asws_Kmp, NLnk_Kmp, Poll_Kmp, Ini__Kmp, CPro_Kmp, QrPreDlg, QrExt, Sql__Dlg,
  DatumDlg {TDirBtn}, Lubtnkmp,
  qSplitter, KmpResString, QRepForm,
  UQue_Kmp;

var
  FormIndex: integer;  //muss auf 1 initialisiert werden

procedure TqForm.Loaded;
var
  NewName: string;
  N: integer;
begin
  inherited Loaded;
  if BorderStyle = bsDialog then
    Sizeable := false else
    Sizeable := SysParam.FormsSizeable;       //17.04.09 bereits hier damit FormCreate überschreiben kann
  PostMessage(Handle, BC_CREATEWND, 0, 0);  //erst hier sind alle Elemente geladen - 26.09.07
  try
    InLoaded := true;
    N := 0;
    Inc(FormIndex);   //neu
    while N < 9999 do  //max. 10000 Versuche
    try
      Inc(N);
      NewName := copy(ClassName, 2, 240) + IntToStr(FormIndex);
      Name := NewName;
      break;
    except
      on E: EAccessViolation do
        raise;
      on E: Exception do
        Inc(FormIndex);
    end;
    if LNavigator <> nil then
    begin
      Kurz := LNavigator.FormKurz;   {für GetInitData}
    end else
      Kurz :=Classname;
    if GNavigator <> nil then
    begin
      if GNavigator.CreateKurz <> '' then
      begin
        Kurz := GNavigator.CreateKurz;      {besser falls <> LNav für GetInitData}
        if GNavigator.FormIsDisabled(Kurz) then    {von LoadForm}
        begin
          WindowState := wsMinimized;
          //Application.MainForm.ArrangeIcons;
          //Top := 0; Left := 0;
          EnableAutoRange;  {X}
          Enabled := false;
        end;
      end;
    end;
    if (LNavigator <> nil) and
       ((lnSavePosition in LNavigator.Options) or (SysParam.SavePosition)) then
      LoadPosition;
    InitWidth := Width;
    InitHeight := Height;
    MinMaxInit := false;
    HasInit := false;
    if not Assigned(OldCloseQuery) then
    begin
      OldCloseQuery := OnCloseQuery;
      OnCloseQuery := CloseQuery;
    end;
  finally
    InLoaded := false;
    HasLoaded := true;
  end;
end;

procedure TqForm.WMQueryEndSession(var Message: TMessage); {message WM_QUERYENDSESSION;}
begin
  SMess('WM_QUERYENDSESSION', [0]);
  Message.Result := 0;
  PollWait;
  ComWait;
  Inherited;
end;

procedure TqForm.CMRelease(var Message: TMessage); {message CM_RELEASE;}
//vermeiden, dass sich aufrufende Form innerhalb Polling beendet.
//  Das Beenden wird verzögert wenn Polling in save state.
//17.01.12 nicht mehr für QRepFroms (die pollen ja nicht). DPE KATAAUTO Vorf.Export PDF
begin
  if (PollKmp <> nil) and PollKmp.InTimer and (self.ClassType = TqForm) then
  begin
    ProtL(SQwf_Form_001, [Kurz]);	// 'Release(%s):Warte auf Poll'
    PollKmp.ReleaseForms.Add(self);
  end else
    inherited;
end;

destructor TqForm.Destroy;
var
  S1: string;
begin
  (*HDO funktioniert nicht
  if (PollKmp <> nil) and PollKmp.InTimer {and
     (PollKmp.DestroyForms.IndexOf(self) < 0)} then
  begin
    ProtL('Destroy(%s,%d):Warte auf Poll', [Kurz, Handle]);
    PollKmp.DestroyForms.Add(self);
  end else
  *)
  begin
    S1 := self.ClassName;
    if GNavigator <> nil then
    try
      if self is TQRepForm then
      begin
        //gibts nicht GNavigator.SetQRepFormData(Kurz, nil);
        if (Kurz <> '') and (GNavigator <> nil) then
          GNavigator.EndQRepForm(self, Kurz);
      end else
      begin
        GNavigator.SetFormData(Kurz, nil);
        if (Kurz <> '') and (GNavigator <> nil) then
          GNavigator.EndForm(self, Kurz);
      end;
    except                                        {keine Behandlung, nur abfangen}
    end;
    {if ([csDestroying,csLoading,csDesigning] * ComponentState = []) then
      PollWait;                                                           150799}
    try
      inherited Destroy;
    except on E:Exception do
      EProt(nil, E, 'Fehler bei Destroy(%s)', [S1]);   //wieder da 21.04.08
    end;
    FreeAndNil(FInitList);
    FreeAndNil(fDatasetList);
  end;
end;

procedure TqForm.SetObjRechte;
var
  Formname: string;
begin
  //if RechteKurz <> '' then   //Kürzel für rechteverwaltung falls eine form viele Kurz (webab.bvor) - 21.10.10
  //  FormName := 'FRM' + Uppercase(RechteKurz) else
  if Kurz = '' then
    FormName := copy(ClassName, 2, length(ClassName)-1) else   {Main}
    FormName := 'FRM' + Uppercase(Kurz);
  SetFormRechte(FormName);
end;

procedure TqForm.SetFormRechte(FormName: string);
(* Objektrechte in Eigenschaften (Enabled, Visible) der Komponenten auf dem Formular umsetzen *)
// wenn keine Objektrechte vorhanden dann erfolgt auch keine Änderung 05.05.03

  procedure SetControlRechte(AName: string; AControl: TControl;
    ControlRechte: TRechteSet; HasObjekt: boolean);
  //rekursive Verarbeitung. HasObjekt: true=wurde in Rechteverwaltung erfasst
  var
    I1, IPage: integer;
    ObjRechte: TRechteSet;
    ADetailBook: TTabbedNoteBook;
    APageName: string;
    APage: TTabPage;
    ACustomEdit: TDummyCustomEdit;
    ADBComboBox: TDBComboBox;
    ADBEdit: TDBEdit;
    ADBMemo: TDBMemo;
    ACustomLabel: TCustomLabel;
    ADBCheckBox: TDBCheckBox;
    AAswCheckListBox: TAswCheckListBox;
    ADBGrid: TDBGrid;
    ATabSheet: TTabSheet;
  begin
    //30.05.08 - Bug: KmpRechte.GetObjekt wurde nicht aufgerufen bei HasObjekt - ObjRechte blieb undefiniert
    HasObjekt := KmpRechte.GetObjekt(FormName, AName, ObjRechte) or HasObjekt;
    ObjRechte := ObjRechte * ControlRechte;    {restrict}
    if KmpRechte.ProtRechte and HasObjekt then
      ProtA('TqForm.SetControlRechte(%s.%s) %s', [FormName, AName,
        KmpRechte.RechteToStr(ObjRechte) {, ord(HasObjekt)}]);
    if AControl.Name = SysParam.OurLookUpEdit then
      Debug0;

    if AControl is TTabbedNoteBook then
    begin
      ADetailBook := AControl as TTabbedNoteBook;
      for IPage := 0 to ADetailBook.Pages.Count-1 do
      begin
        APageName := RemoveAccelChar(ADetailBook.Pages[IPage]);
        APage := ADetailBook.Pages.Objects[IPage] as TTabPage;
        SetControlRechte(APageName, APage, ObjRechte, HasObjekt);
        if not (reDisplayed in ObjRechte) then   {in Klammern setzen=Knz für Invisible}
          ADetailBook.Pages[IPage] := Format('(%s)', [APageName]);
      end;
    end else
    if (AControl is TDBRadioGroup) and (TDBRadioGroup(AControl).ControlCount > 0) then
    begin
      if HasObjekt then
      begin
        TDBRadioGroup(AControl).Visible := reDisplayed in ObjRechte;
        TDBRadioGroup(AControl).ReadOnly := not (reEnabled in ObjRechte);
      end;
    end else
    if (AControl is TCustomRadioGroup) and (TCustomRadioGroup(AControl).ControlCount > 0) then
    begin
      if HasObjekt then
      begin
        TCustomRadioGroup(AControl).Visible := reDisplayed in ObjRechte;
        TCustomRadioGroup(AControl).Enabled := reEnabled in ObjRechte;
      end;
    end else
    if AControl is TPageControl then
    begin
      for IPage := 0 to TPageControl(AControl).PageCount-1 do
      begin
        SetControlRechte(TPageControl(AControl).Pages[IPage].Name,
                         TPageControl(AControl).Pages[IPage],
                         ObjRechte, HasObjekt);
      end;
    end else
    if (AControl is TTabSheet) then
    begin
      for I1 := 0 to TWinControl(AControl).ControlCount - 1 do
      begin
        SetControlRechte(TWinControl(AControl).Controls[I1].Name,
                         TWinControl(AControl).Controls[I1],
                         ObjRechte + [reDisplayed], HasObjekt);
      end;
      if HasObjekt then
      begin
        ATabSheet := TTabSheet(AControl);
        ATabSheet.TabVisible := reDisplayed in ObjRechte;
        ATabSheet.Enabled := reEnabled in ObjRechte;  //29.05.08 quvae
        if not ATabSheet.TabVisible then
        begin
          if (ATabSheet.PageControl <> nil) and
             (ATabSheet.PageControl.ActivePage = ATabSheet) then
          begin  //aktive Seite wurde invisible -> auf next visible Seite gehen
            for I1 := 0 to ATabSheet.PageControl.PageCount - 1 do
              if ATabSheet.PageControl.Pages[I1].TabVisible then
              begin
                ATabSheet.PageControl.ActivePageIndex := I1;
                break;
              end;
          end;
        end;
      end;
    end else
    if AControl is TDBComboBox then
    begin
      if HasObjekt then
      begin
        ADBComboBox := TDBComboBox(AControl);
        ADBComboBox.Visible := reDisplayed in ObjRechte;
        ADBComboBox.ReadOnly := not (reEnabled in ObjRechte);
      end;
    end else
    if AControl is TDBMemo then
    begin
      if HasObjekt then
      begin
        ADBMemo := TDBMemo(AControl);
        ADBMemo.Visible := reDisplayed in ObjRechte;
        ADBMemo.ReadOnly := not (reEnabled in ObjRechte);
      end;
    end else
    if AControl is TDBEdit then
    begin
      if HasObjekt then
      begin
        ADBEdit := TDBEdit(AControl);
        ADBEdit.Visible := reDisplayed in ObjRechte;
        ADBEdit.ReadOnly := not (reEnabled in ObjRechte);
      end;
    end else
    if AControl is TCustomEdit then
    begin
      if HasObjekt then
      begin
        ACustomEdit := TDummyCustomEdit(AControl);
        ACustomEdit.Visible := reDisplayed in ObjRechte;
        ACustomEdit.ReadOnly := not (reEnabled in ObjRechte);
      end;
    end else
    if AControl is TDBCheckBox then
    begin
      if HasObjekt then
      begin
        ADBCheckBox := TDBCheckBox(AControl);
        ADBCheckBox.Visible := reDisplayed in ObjRechte;
        ADBCheckBox.ReadOnly := not (reEnabled in ObjRechte);
      end;
    end else
    if AControl is TAswCheckListBox then
    begin
      if HasObjekt then
      begin
        AAswCheckListBox := TAswCheckListBox(AControl);
        AAswCheckListBox.Visible := reDisplayed in ObjRechte;
        AAswCheckListBox.ReadOnly := not (reEnabled in ObjRechte);
      end;
    end else
    if AControl is TDBGrid then
    begin
      if HasObjekt then
      begin
        ADBGrid := TDBGrid(AControl);
        ADBGrid.Visible := reDisplayed in ObjRechte;
        ADBGrid.ReadOnly := not (reEnabled in ObjRechte);
      end;
    end else
    if AControl is TCustomLabel then
    begin
      if HasObjekt then
      begin
        ACustomLabel := TCustomLabel(AControl);
        ACustomLabel.Visible := reDisplayed in ObjRechte;
        {ACustomLabel.ReadOnly := nicht disablen da sonst schlecht lesbar}
        //ACustomLabel.Enabled := reEnabled in ObjRechte;  //schlecht lesbar qupi.lsth 31.12.03
      end;
    end else
    if (AControl is TWinControl) and (TWinControl(AControl).ControlCount > 0) then
    begin
      for I1 := 0 to TWinControl(AControl).ControlCount - 1 do
      begin
        //ProtA('Want SetControlRechte(%s.%s->%s)', [FormName, AName, TWinControl(AControl).Controls[I1].Name]);
        SetControlRechte(TWinControl(AControl).Controls[I1].Name,
                         TWinControl(AControl).Controls[I1],
                         ObjRechte, HasObjekt);
      end;
      if HasObjekt then
      begin
        AControl.Visible := reDisplayed in ObjRechte;
        AControl.Enabled := reEnabled in ObjRechte;
      end;
//14.04.14 ??? weg
//      if HasObjekt then
//      begin
//        AControl.Visible := AControl.Visible and (reDisplayed in ObjRechte);
//      end;
//      //14.04.14 aktiviert - ? nein weil DBEdits beim Suchen wieder enabled sein sollen (dort:Readonly)
//      AControl.Enabled := AControl.Enabled and (reEnabled in ObjRechte);
    end else
    begin
      if HasObjekt then
      begin
        AControl.Visible := reDisplayed in ObjRechte;
        AControl.Enabled := reEnabled in ObjRechte;
      end;
    end;
  end; {SetControlRechte}

var
  I: integer;
  APrnSource: TPrnSource;
  ObjektRechte: TRechteSet;
  AMenuItem: TMenuItem;
  APopupMenu: TPopupMenu;
  HasObjekt1: boolean;
begin {SetFormRechte}
  if (KmpRechte <> nil) and not KmpRechte.AllowAll then
  begin
    KmpRechte.InitMaske(self, FormName);
    for I:= ComponentCount-1 downto 0 do {Rechte der Objekte realisieren}
    begin
      if Components[I] is TMenuItem then
      begin
        AMenuItem := Components[I] as TMenuItem;
        if KmpRechte.GetObjekt(FormName, AMenuItem.Name, ObjektRechte) then
        begin
          AMenuItem.Visible := reDisplayed in ObjektRechte;
          AMenuItem.Enabled := reEnabled in ObjektRechte;

          if KmpRechte.ProtRechte then
            ProtA('SetObjRechte(%s.%s) %s', [FormName, AMenuItem.Name,
              KmpRechte.RechteToStr(ObjektRechte)]);
        end;
      end else
      if Components[I] is TPopupMenu then
      begin
        APopupMenu := Components[I] as TPopupMenu;
        if KmpRechte.GetObjekt(FormName, APopupMenu.Name, ObjektRechte) then
        begin
          APopupMenu.AutoPopup := reDisplayed in ObjektRechte;
          //APopupMenu.Enabled := reEnabled in ObjektRechte;

          if KmpRechte.ProtRechte then
            ProtA('SetObjRechte(%s.%s) %s', [FormName, APopupMenu.Name,
              KmpRechte.RechteToStr(ObjektRechte)]);
        end;
      end else
      if Components[I] is TPrnSource then
      begin
        APrnSource := Components[I] as TPrnSource;
        if KmpRechte.GetObjekt(FormName, APrnSource.Name, ObjektRechte) then
        begin
          APrnSource.Visible := (reDisplayed in ObjektRechte) and (reEnabled in ObjektRechte);
          {APrnSource.Enabled := reEnabled in ObjektRechte; {Enabled gibts nicht}

          if KmpRechte.ProtRechte then
            ProtA('SetObjRechte(%s.%s) %s', [FormName, APrnSource.Name,
              KmpRechte.RechteToStr(ObjektRechte)]);
        end;
      end else
      (*if Components[I] is TTabbedNoteBook then
      begin
        ADetailBook := Components[I] as TTabbedNoteBook;
        for IPage:= 0 to ADetailBook.Pages.Count-1 do
        begin
          APageName := RemoveAccelChar(ADetailBook.Pages[IPage]);
          APage := ADetailBook.Pages.Objects[IPage] as TTabPage;
          if KmpRechte.GetObjekt(FormName, APageName, ObjektRechte) then
          begin
            if not (reDisplayed in ObjektRechte) then
              ADetailBook.Pages[IPage] := Format('(%s)', [APageName]);
            {APage.Visible := false;}
            {ADetailBook.Pages.Delete(IPage); löscht Luedi Felder!}
            for IComp := 0 to APage.ControlCount-1 do
              APage.Controls[IComp].Visible := reDisplayed in ObjektRechte;

            {APage.Enabled := false;}
            for IComp := 0 to APage.ControlCount-1 do
            begin
              if APage.Controls[IComp].Name = SysParam.OurLookUpEdit then
                Debug0;
              APage.Controls[IComp].Enabled := reEnabled in ObjektRechte
            end;
          end;
        end;
      end else*)
      begin
      end;
      (*if Components[I] is TControl then
      begin
        KmpRechte.GetObjekt(FormName, Components[I].Name, ObjektRechte);
        SetControlRechte(TControl(Components[I]), ObjektRechte);
      end;*)
    end; {for}
    HasObjekt1 := KmpRechte.GetObjekt(FormName, FormName, ObjektRechte); //Form ist selbst Rechteobjekt.
    SetControlRechte(self.Name, self, ObjektRechte, HasObjekt1);
  end; {if}
end;

procedure TqForm.BCCreateWnd(var Message: TWMBroadcast);
(* Aufruf als PostMessage in CreateWnd: Objektrechte setzen *)
begin
  //SetObjRechte;   * 18.03.08 testweise in LNav.DoPostStart <-schlecht:zu spät
  //               ** 23.05.13 testweise in LNav.
end;

procedure TqForm.CreateWnd;
begin
  //17.04.09 bereits in Create Sizeable := Sizeable or SysParam.FormsSizeable;             {270997 KMP QrEdi}
//  if Sizeable then                                      {050699 i.V.m. Maximize}
//    BorderIcons := BorderIcons + [biMaximize];                {vor inzherited !}
  inherited CreateWnd;
  //PostMessage(Handle, BC_CREATEWND, 0, 0);  //erst in Loaded Lawa.zmes  mmm
end;

procedure TqForm.SetSizeable(const Value: boolean);
begin
  FSizeable := Value;
  if (Application.MainForm = nil) or (self = Application.MainForm) then
  begin
    // Application.MainForm = nil bei Programmstart
  end else
  if FSizeable then
    BorderIcons := BorderIcons + [biMaximize] else
    BorderIcons := BorderIcons - [biMaximize];       //zu spät?
end;

procedure TqForm.ActiveChanged;
begin
  inherited ActiveChanged;
(*  if ActiveControl is TWinControl then
    with ActiveControl as TWinControl do
      if ShowHint and
         not (csDesigning in ComponentState) and
         not (csLoading in ComponentState) and
         not (csDestroying in ComponentState) then
        DMess(Hint, [0]);*)
end;

procedure TqForm.Resize;                 {hier nur damit in Kmp sichtbar}
begin
  //Vergrößerungen in Maximized Childs weitergeben
  if (GNavigator <> nil) and (self = Application.MainForm) then
    GNavigator.CheckBoundsFlag := true;

  inherited Resize;
end;

procedure TqForm.WMSize(var Message: TWMSize);
begin
  inherited;
  //Minimierte Icons gleich arrangieren
  if Message.SizeType = SIZE_MINIMIZED then
  begin
    if GNavigator <> nil then
      GNavigator.CheckBoundsFlag := true;
  end;
end;

function TqForm.BroadcastForms(Sender: TComponent; ComponentRef: TComponentRef;
  MsgNr: integer; Data: longint): longint;
(* Löst BroadcastMessage bei allen Forms vom Typ TqForm aus (auch nicht-MDIs).
  Wenn eine Form bzw. die angesprochene Komponente die Msg bearbeitet hat und
  kein anderes Form mehr bearbeiten soll, dann setzt es Result auf einen
  Wert <> 0
  Bemerkung: Die Msg wird auch an das eigene Formular gesendet *)
var
  I: integer;
begin
  result := 0;
  I := 0;
  while I < Screen.FormCount do
  begin
    if (Screen.Forms[I] is TqForm) then
    begin
      result := TqForm(Screen.Forms[I]).BroadCastMessage(Sender,
        ComponentRef, MsgNr, Data);
      if result <> 0 then
        break;
    end;
    Inc(I);
  end;
end;

function TqForm.BroadcastMessage(Sender: TComponent; ComponentRef: TComponentRef;
  MsgNr: integer; Data: longint): longint;
(* Löst eine Msg bei allen Komponenten vom Typ TComponetRef aus bzw. beim
   Formular wenn TComponentRef = TForm oder TqForm ist *)
var
  Msg: TWMBroadcast;
  I, J: integer;

  function DispatchMsg(AComponent: TComponent): longint;
  begin
    Msg.Msg := MsgNr;
    Msg.Data := Data;
    Msg.Sender := Sender;
    Msg.Result := 0;
    AComponent.Dispatch(Msg);      {perform}
    result := Msg.Result;
  end;

begin
  result := 0;
  if self is ComponentRef then       {Msg geht ans Formular selbst}
  begin
    result := DispatchMsg(self);
    {if result <> 0 then             immer exit. 131199 ISA}
      exit;
  end;
  for I:= 0 to ComponentCount-1 do
  begin
    if Components[I] is ComponentRef then
    begin
      result := DispatchMsg(Components[I]);
      if result <> 0 then
        break;
    end else
    if Components[I] is TFrame then
    begin
      for J:= 0 to TFrame(Components[I]).ComponentCount-1 do
      begin
        if TFrame(Components[I]).Components[J] is ComponentRef then
        begin
          result := DispatchMsg(TFrame(Components[I]).Components[J]);
          if result <> 0 then
            break;
        end;
      end;
    end;
  end;
end;

function TqForm.GetShortCaption: string;
begin
  result := Prots.ShortCaption(Caption);
end;

function TqForm.GetSubCaption: string;
// Ergibt Caption [SubCaption]
begin
  (* 29.10.10 qupp.gemiso - ExtCaption
  result := Prots.BeforeBracketCaption(Caption, '*');
  *)
  result := Prots.BeforeBracketCaption(Caption, '- ');
end;

function TqForm.GetInitData: Pointer;
begin
  if GNavigator <> nil then
    result := GNavigator.GetFormData(Kurz) else
    result := nil;
end;

function TqForm.GetInitList: TStrings;
//ergibt String in InitData idF A;B;C als TStrings mit den Zeilen A/B/C
//fixed " durch Verwendung von SetDelimiterText. dflt Delimiter=;
begin
  if FInitList = nil then
  begin
    FInitList := TValueList.Create;
    if InitData <> nil then
    try
      //TValueList(FInitList).AddTokens(PChar(InitData), ';', true);
      //ab 15.07.14:
      TValueList(FInitList).DelimiterText := PChar(InitData);
    except on E:Exception do
      EProt(self, E, 'GetInitList', [0]);
    end;
  end;
  Result := FInitList;
end;

procedure TqForm.CloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Btn: Word;
  I: integer;
  OldConfirmCancel: boolean;
begin
  if ([csLoading,csDesigning,csDestroying] * ComponentState = []) then
  try
    {if (DlgQRPreview <> nil) and (DlgQRPreview.PrnSource <> nil) and
       (DlgQRPreview.PrnSource.Owner = Sender) then     EGPFault}
    if (DlgQRPreview <> nil) and (TForm(Sender).ModalResult = 0) then
    begin
      CanClose := false;
      // 'Ausdruck läuft noch (%s)'
      ProtL(SQwf_Form_002, [DlgQRPreview.Caption]); {smess+error.dat}
      DlgQRPreview.WindowState := wsNormal;      {dem Bediener auch zeigen 250899}
      DlgQRPreview.Show;
      Exit;
    end;
    if (LNavigator <> nil) and not InLoaded and HasLoaded and SavePositionFlag and
       ((lnSavePosition in LNavigator.Options) or (SysParam.SavePosition)) then
      SavePosition(true);
    InCloseQuery := true;
    UpdateEdit;
    if Assigned(OldCloseQuery) then
      OldCloseQuery(Sender, CanClose);
    if CanClose and (LNavigator <> nil) and (LNavigator.EditSource <> nil) then
    begin
      OldConfirmCancel := LNavigator.NavLink.ConfirmCancel;
      try
        LNavigator.NavLink.ConfirmCancel := false;   {wir haben eigene Msg 130400}
        (* Grids abschließen: Layout speichern *)
        BroadcastMessage(self, TMultiGrid, BC_CANCLOSE, 0);
        if (LNavigator.EditSource.State in [dsEdit,dsInsert]) and
           LNavigator.NavLink.Modified and
           not LNavigator.dsQuery and not LNavigator.dsChangeAll then
        begin
          ShowNormal(wsNormal);
          // 'Daten wurden geändert.' ..  'Speichern ?'
          Btn := MessageFmt('<<< %s >>>' +CRLF+ SQwf_Form_003 +CRLF+
            SQwf_Form_004, [Caption], mtConfirmation, mbYesNoCancel, 0);
          if Btn = mrCancel then
            CanClose := false else
          begin
            if Btn = mrNo then
            try
              LNavigator.NavLink.SetEnable(false, false);
              //LNavigator.NavLink.DoCancel;  15.04.09 weg - qupe.MatrVersFrm.TblZ3BeforeOpen
            except on E:Exception do
              EMess(self, E, 'CanClose.Cancel',[0]);
            end else
            if Btn = mrYes then
            try
              LNavigator.NavLink.DoPost(true);
            except
              on E:Exception do
              begin
                CanClose := false;
                ErrWarn('CanClose(%s):%s',[Caption,E.Message]);
              end;
            end;
          end;
        end else
        if LNavigator.dsQuery or LNavigator.dsChangeAll then
        begin
          ShowNormal(wsNormal);
          GNavigator.X.QueryCancel;
        end else
        if (LNavigator.EditSource.State in [dsEdit,dsInsert]) then
        begin
          LNavigator.NavLink.SetEnable(false, false);
          //LNavigator.NavLink.DoCancel;  15.04.09 weg - qupe.MatrVersFrm.TblZ3BeforeOpen
        end;
        if CanClose then
        try
          (* Alle LuDef.Tables Schließen *)
          {LNavigator.NavLink.SetEnable(false, false); bereichsüberschreitung}
          BroadcastMessage(LNavigator.EditSource, TLookUpDef, BC_LOOKUPDEF, ldCloseAll);
          if (GNavigator.LNavigator = LNavigator) and (GNavigator.X <> nil) and
             (GNavigator.X.DataSource <> LNavigator.DataSource) then
            GNavigator.X.DataSource := LNavigator.DataSource;
        except on E:Exception do
          EProt(self, E, 'Error at CloseQuery BC_LOOKUPDEF', [0]);
        end;
      finally
        LNavigator.NavLink.ConfirmCancel := OldConfirmCancel;
      end;
    end;
    if CanClose then
    begin
      Closed := true;
      with GNavigator.Owner as TForm do               {MainForm}
        if ActiveMDIChild = self then           {wichtig für Übernehmen}
        begin
          I := 0;
          repeat
            Inc(I);
            Next;                               {nächstes Mdi Child}
          until (ActiveMDIChild.WindowState <> wsMinimized) or (I >= MDIChildCount);
        end;
      {PollWait;                                   {150799}
      if self = Application.MainForm then
      begin
        ComWait;
        if PollKmp <> nil then
          PollKmp.Enabled := false;
        GNavigator.Close;
      end;
    end;
    Prot0('CloseQuery(%s):%d', [Kurz, ord(CanClose)]);
  except on E:Exception do
    EProt(self, E, 'CloseQuery(%s):%d - %s', [Kurz, ord(CanClose), Caption]);
  end;
  {InCloseQuery := CanClose;              {14.04.99 false;}
  InCloseQuery := false;                 {Must wg TNavLink.NewBeforeClose! 19.12.02 Quva.HaltFrm}
  if CanClose then
    PostMessage(self.Handle, BC_QFORM, qfCheckNonModal, 0);
end;

procedure TqForm.BCQForm(var Message: TMessage);  {message BC_QFORM;}
begin  {Message an das qForm selbst}
  if Message.wParam = qfCheckNonModal then
  begin
    TDlgSql.CheckVisible;       {Anzeige SQL-Dialog wenn verborgen (z.B. nach Export)}
  end;
  if Message.wParam = qfCheckVScroll then
  begin   //n.b.
    TqForm.CheckBounds;
  end;
end;

procedure TqForm.BCPageChange(var Message: TWMBroadcast);  //message BC_PAGECHANGE;
{Table.Active automatisch setzen}
begin
  if ([csDestroying,csLoading,csDesigning] * ComponentState = []) and
     Assigned(LNavigator) then
    LNavigator.DoAfterPageChange(Message.Data);
end;

procedure TqForm.BCPostStart(var Message: TWMBroadcast);  //message BC_POSTSTART;
{Die PostStart von LNav aufrufen}
begin
  if LNavigator <> nil then     //beware! and (Message.Sender <> nil) then
    LNavigator.DoPostStart(Message.Sender);
end;

procedure TqForm.BCSetPageIndex(var Message: TWMBroadcast);
begin
  if LNavigator <> nil then
    LNavigator.PageIndex := Message.Data;
end;

procedure TqForm.BCLNavigator(var Message: TWMBroadcast); {message BC_LNAVIGATOR;}
begin
  if LNavigator <> nil then
  try
    case Byte(Message.Data) of
      lnavSetTitel: LNavigator.SetTitel;
      lnavStartReturn: LNavigator.StartReturn;
      lnavGotoDataPos: LNavigator.GotoDataPos;
      lnavSetTabs: LNavigator.SetTabs;  //untere Tabs Buttons/Register setzen
    end;
  except on E:Exception do  //vermutlich bereits geschlossen und Postmessage
    // EProt(self, E, 'BCLNavigator(%d)', [Message.Data]);
  end;
end;

procedure TqForm.BCEnableControls(var Message: TWMBroadcast);
(* message BC_ENABLECONTROLS; *)
begin
  if (LNavigator <> nil) and (LNavigator.Dataset <> nil) then
    LNavigator.Dataset.EnableControls;
end;

procedure TqForm.BCNextNullCtl(var Message: TMessage);
(* Parameter entspr. WM_NEXTDLGCTL *)
var
  AWinControl: TWinControl;
  GoForward, CheckTabStop, CheckParent: boolean;
  N: integer;
begin
  if Screen.ActiveForm <> self then
    Exit;                                     {Fehlermeldung}
  if LNavigator.NavLink.InDataChange then {or (tötlich) GNavigator.InProcessMessages}
  begin
    Message.Result := 1;
    if Message.LParam = 0 then  //überspricngen
      PostMessage(Handle, BC_NextNullCTL, Message.WParam, LPARAM(1));
  end else
  begin
    AWinControl := ActiveControl;
    GoForward := Message.WParam = 0;      {1 = rückwärts}
    CheckTabStop := true;
    CheckParent := false;
    N := 0;
    repeat
      AWinControl := FindNextControl(AWinControl, GoForward, CheckTabStop, CheckParent);
      Inc(N);
    until (AWinControl = nil) or (N >= ComponentCount) or
          ((AWinControl is TCustomEdit) and
           (TrimIdent(TCustomEdit(AWinControl).Text) = ''));  {EditMask}
           {(TCustomEdit(AWinControl).Text = ''));}
    if AWinControl <> nil then
      ActiveControl := AWinControl;
    (*
    AWinControl := ActiveControl;
    GoForward := Message.WParam = 0;      {1 = rückwärts}
    L := TList.Create;
    try
      self.GetTabOrderList(L);
      N := 0;
      Found := false;
      if GoForward then I := 0 else I := L.Count - 1;
      while N < L.Count do
      begin
        Inc(N);
        if not Found and (TWinControl(L[I]) = AWinControl) then
          Found := true else
        if Found then
        begin
          AWinControl := TWinControl(L[I]);
          if (AWinControl <> nil) and AWinControl.TabStop and
             (AWinControl is TCustomEdit) and                      {EditMask}
             (TrimIdent(TCustomEdit(AWinControl).Text) = '') then
          begin
            ActiveControl := AWinControl;
            break;
          end;
        end;
        if GoForward then Inc(I) else Dec(I);
      end;
    finally
      L.Free;
    end;
    *)
  end;
end;

function TqForm.FindFocusControl(CurControl: TWinControl;
  GoForward, CheckTabStop, CheckParent: Boolean): TWinControl;
(* entspr. FindNextControl aber nur wenn ein TLabel.FocusControl existiert *)
var
  AWinControl: TWinControl;
  N: integer;
  OkFocus: boolean;
  function HasFocusControl(AWinControl: TWinControl): boolean;
  var
    I: integer;
  begin
    result := false;
    for I := 0 to ComponentCount - 1 do
      if Components[I] is TLabel then
        if TLabel(Components[I]).FocusControl = AWinControl then
        begin
          result := true;
          break;
        end;
  end;
begin
  N := 0;
  AWinControl := CurControl;
  result := AWinControl;
  repeat
    inc(N);
    AWinControl := FindNextControl(AWinControl, GoForward, CheckTabStop, CheckParent);
    OkFocus := HasFocusControl(AWinControl);
  until (N >= ComponentCount) or OkFocus;
  if OkFocus then
    result := AWinControl;
end;

procedure TqForm.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  inherited ;
  if csDesigning in ComponentState then
    Exit;
  if FormStyle <> fsMDIChild then
  begin
    Message.Result := 1;
  end else
  if (Application.MainForm = nil) or (self <> Application.MainForm) then
  begin
    if MinMaxInit then
    begin
      if not Sizeable then
        Message.MinMaxInfo^.ptMinTrackSize := Point(MinMaxWidth, MinMaxHeight) else
        Message.MinMaxInfo^.ptMinTrackSize := Point(MinWidth, MinHeight); {normal 0}
      if not MaxSizeable and not Sizeable then
        Message.MinMaxInfo^.ptMaxTrackSize := Point(MinMaxWidth, MinMaxHeight) else
        Message.MinMaxInfo^.ptMaxTrackSize := Point(MaxWidth, MaxHeight);  //neu 11.12.05 qsbt.haltern
      Message.Result := 0;
    end;
  end;
end;

procedure TqForm.WMInitMenuPopup(var Msg: TWMInitMenuPopup);
begin //'Vergrößern' im Systemmenü disablen wenn entspr. Flag gesetzt
  inherited;
  if not (csDesigning in ComponentState) and (FormStyle = fsMDIChild) then
  begin
    if Msg.SystemMenu and not Sizeable then
    begin
      EnableMenuItem(Msg.MenuPopup, SC_SIZE, MF_BYCOMMAND or MF_GRAYED);
      Msg.Result := 0;
    end;
  end;
end;

procedure TqForm.WMSysCommand(var Msg: TWMSysCommand); {message WM_SYSCOMMAND;}
var
  RunDefWindowProc: boolean;
  //ALeft, ATop, AWidth, AHeight: integer;
begin
  RunDefWindowProc := true;
  if not (csDesigning in ComponentState) and (FormStyle = fsMDIChild) then
  begin
    (* bei Doppelklick auf Titelleiste: 61458, 61490
    if (Msg.CmdType = 61490) or (Msg.CmdType = 61458) then     {Nr unbekannt}
    begin                           {Maximiert das MDI-Fenster}
      RunDefWindowProc := false;    {aber das wollen wir nicht   060400}
      Msg.Result := 0;
    end else*)
    if Sysparam.ProtBeforeOpen then Prot0('Sys:%d', [Msg.CmdType]);
    if Msg.CmdType = SC_KEYMENU then
      Debug0;
    if (Msg.CmdType = SC_MAXIMIZE) or (Msg.CmdType = 61490) then
    try                              {Systemkommando 'Maximieren' umbiegen:}
      InScMaximize := true;
      WindowState := wsNormal;       {Koordinaten vergrößern aber Status geht NICHT auf Maximiert}
      Maximized := true;
      (*
      ALeft := 0;
      ATop := 0;
      if MaxSizeable and (GNavigator <> nil) then
      begin
        GNavigator.SetMaximizeBounds(MinMaxWidth, MinMaxHeight);
      end;
      DoResize := (Width = MinMaxWidth) and (Height = MinMaxHeight);
      AWidth := MinMaxWidth;
      AHeight := MinMaxHeight;
      SetBounds(ALeft, ATop, AWidth, AHeight);
      MaxWidth := MinMaxWidth;
      MaxHeight := MinMaxHeight;
      if DoResize then
        Resize;                    {immer wenn sonst nichts geändert (OPT.TREN)}
      *)
      Msg.Result := 0;
      RunDefWindowProc := false;
    finally
      InScMaximize := false;
    end;
  end;
  if RunDefWindowProc then
    inherited;                        {führt DefWindowProc aus}
  if Msg.CmdType = SC_MINIMIZE then
    PostMessage(Handle, BC_LNAVIGATOR, lnavSetTitel, 0);
end;

procedure TqForm.SetMaximized(const Value: boolean);
var
  DoResize: boolean;
  ALeft, ATop, AWidth, AHeight: integer;
begin
  FMaximized := Value;
  if FMaximized and (GNavigator <> nil) then
  try
    //25.05.09
    if WindowState <> wsNormal then
      WindowState := wsNormal;

    {BorderIcons := BorderIcons - [biMaximize];}
    ALeft := 0;
    ATop := 0;
    //if MaxSizeable * beware wg setbounds
    GNavigator.SetMaximizeBounds(MinMaxWidth, MinMaxHeight);
    DoResize := (Width = MinMaxWidth) and (Height = MinMaxHeight);
    AWidth := MinMaxWidth;
    AHeight := MinMaxHeight;
    if (GNavigator <> nil) and (GNavigator.MinSpaceLines > 0) then
    begin   // Zeile(n) für Min.Fenster reservieren
      //AHeight := AHeight - GetSystemMetrics(SM_CYMINSPACING) * GNavigator.MinSpaceLines;  W2K
      AHeight := AHeight - GetSystemMetrics(SM_CYMINIMIZED) * GNavigator.MinSpaceLines;  //XP
    end;
    InitWidth := AWidth;
    InitHeight := AHeight;
    MaxWidth := MinMaxWidth;
    MaxHeight := MinMaxHeight;
    if not Sizeable then
    begin
      MinMaxWidth := AWidth;
      MinMaxHeight := AHeight;
    end;
    SetBounds(ALeft, ATop, AWidth, AHeight);

    if DoResize and InScMaximize then
      Resize;                    {immer wenn sonst nichts geändert (OPT.TREN)}
  finally
    FMaximized := true;  //kann zwischenzeitlich zurückgesetzt werden
  end else
  begin
    {if MaxSizeable then
      BorderIcons := BorderIcons + [biMaximize];}
  end;
end;

procedure TqForm.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  if not (csDesigning in ComponentState) and (FormStyle = fsMDIChild) and
     not Sizeable then with Msg do
    if Result in [HTLEFT, HTRIGHT, HTBOTTOM, HTBOTTOMRIGHT,
                  HTBOTTOMLEFT, HTTOP, HTTOPRIGHT, HTTOPLEFT] then
      Result:= longint(HTNOWHERE);
end;

procedure TqForm.WMWindowPosChanging(var Message: TWMWindowPosChanging);
begin
  inherited ;
  if csDesigning in ComponentState then
    Exit;
  if FormStyle = fsMDIChild then
  begin
    if MinMaxInit and (WindowState = wsNormal) then
      with Message.WindowPos^ do
      begin
        if SysParam.FormsInFrame then
        begin
          if  x < 0 then x := 0;
          if y < 0 then y := 0;
          if Sizeable or true then     //30.11.02 or true SweDepoSvr
          begin
            MaxLeft := IMax(0, IMin(x, MaxWidth - cx));
            MaxTop := IMax(0, IMin(y, MaxHeight - cy));
          end;
          if x > MaxLeft then
            x := MaxLeft;
          if y > MaxTop then
            y := MaxTop;
          Message.Result := 0;
        end;
      end else
        Debug0;
  end;
end;

(* jetzt ohne Klasse über alle Forms:
procedure TqForm.CheckVScroll;
{Scrollbars in MainFrm wegmachen:}
//  if (Application.MainForm <> nil) and
//     (Application.MainForm.FormStyle = fsMDIForm) then
//    if GetWindowLong(Application.MainForm.ClientHandle, GWL_STYLE) and
//       (WS_VSCROLL or WS_HSCROLL) <> 0 then
//      Application.MainForm.ArrangeIcons;
  function ScrollBarVisible(Code: Word): Boolean;
  var
    Style: Longint;
  begin
    Style := WS_HSCROLL;
    if Code = SB_VERT then Style := WS_VSCROLL;
    Result := GetWindowLong(Application.MainForm.ClientHandle, GWL_STYLE) and Style <> 0;
  end;
var
  MaxWidth, MaxHeight: integer;
begin
  {Scrollbars entfernen. Bei ArrangeIcons wird 2Pixels unter den sichtbaren
   Bereich plaziert und dadurch bei der nächsten Aktion die Scrollbar erzeugt
   NT-Bug? , allerdings werden zunächst die Scrollbars entfernt, was wir hier nutzen}
  if (Application.MainForm <> nil) and
     (Application.MainForm.FormStyle = fsMDIForm) and
     ScrollBarVisible(SB_VERT) then    //works
  begin
    Application.MainForm.ArrangeIcons;
    if WindowState = wsNormal then
    begin  //MenüFenster verkleinern
      GNavigator.SetMaximizeBounds(MaxWidth, MaxHeight);
      if (Left <> 0) or (Top <> 0) or (Width > MaxWidth) or (Height > MaxHeight) then
        SetBounds(0, 0, MaxWidth, MaxHeight);
    end;
  end;
end;
*)

function TqForm.ScrollBarsVisible: Boolean;
//ergibt true wenn Scrollbars sichtbar weil Clientbereich zu groß ist
begin
  //ist immer false: Result := HorzScrollBar.Visible or VertScrollBar.Visible;
  Result := GetWindowLong(ClientHandle, GWL_STYLE) and (WS_HSCROLL or WS_VSCROLL) <> 0;
end;

procedure TqForm.ArrangeMinimized;
//nur MDIForm: XP-Style-Tauglicher Ersatz für ArrangeIcons
var
  I, X, Y: integer;
  aMDIForm: TForm;
  R, RM: TRect;
  WP: TWindowPlacement;
  Msl: integer;
begin
  if FormStyle <> fsMDIForm then
  begin
    Prot0('%s WARN ArrangeMinimized: kein fsMDIForm', [Kurz]);
    Exit;
  end;
  {ArrangeIcons entfernt die Scrollbars, was wir hier nutzen}
  ArrangeIcons;  //wichtig um Scrollbars zu entfernen!?
  GetWindowRect(ClientHandle, RM);  //in Screen Koord
  X := 0;
  Y := GNavigator.ClientHeight - GetSystemMetrics(SM_CYMINIMIZED);
  Msl := 1;
  for I:= 0 to MDIChildCount - 1 do
  begin
    aMDIForm := MDIChildren[I];
    if aMDIForm.WindowState = wsMinimized then
    begin
      if not aMDIForm.Enabled then
      begin
        //leidiges minimiertes ParaFrm ist nicht mehr sichtbar
        ShowWindow(aMDIForm.Handle, SW_HIDE);
      end else
      begin
        GetWindowRect(aMDIForm.Handle, R);  //in Screen Koord
        WP.length := sizeof(TWindowPlacement);
        GetWindowPlacement(aMDIForm.Handle, Addr(WP));

        if X + R.Right - R.Left + 1 > RM.Right then
        begin
          Inc(Msl);
          X := 0;
          Y := Y - GetSystemMetrics(SM_CYMINIMIZED);
        end;
        WP.flags := WPF_SETMINPOSITION;
        WP.ptMinPosition := Point(X, Y);
        WP.showCmd := SW_MINIMIZE;
        SetWindowPlacement(aMDIForm.Handle, Addr(WP));
        debug0;
        X := X + R.Right - R.Left + 1;
      end;
    end;
  end;
  if (GNavigator <> nil) and (GNavigator.MinSpaceLines > 0) then
  begin
    GNavigator.MinSpaceLines := Msl;
  end;
end;

// class procedure TqForm.CheckVScroll; nicht mehr verwenden!

class procedure TqForm.CheckBounds;
// Größenanpassung der ClientWindows im Modus Sysparam.FormsInFrame.
// Vergrößerung der MainForm bewirkt Vergrößerung der Maximized Childs
// Verkleinerung auch an Childs zur Vermeidung von Scrollbars
// Minimierte Icons XP-gerecht positionieren
// Nur für Aufruf per GNavigator.DoOnIdle wenn CheckBoundsFlag gesetzt in ReSize, WMSize
var
  MaxWidth, MaxHeight: integer;
  aLeft, aTop, aWidth, aHeight: integer;
  aForm: TForm;
  I: integer;
  Reduce, OldMaximized: boolean;
begin
  {Scrollbars entfernen. Bei ArrangeIcons wird 2Pixels unter den sichtbaren
   Bereich plaziert und dadurch bei der nächsten Aktion die Scrollbar erzeugt
   NT-Bug? , allerdings werden zunächst die Scrollbars entfernt, was wir hier nutzen}
  if (Application.MainForm <> nil) and
     (Application.MainForm is TqForm) and
     (Application.MainForm.FormStyle = fsMDIForm) and
     Sysparam.FormsInFrame then
  begin
    TqForm(Application.MainForm).ArrangeMinimized;  // Application.MainForm.ArrangeIcons; schlecht unter XP
    GNavigator.SetMaximizeBounds(MaxWidth, MaxHeight);
    Reduce := TqForm(Application.MainForm).ScrollBarsVisible;
    for I := 0 to Application.MainForm.MDIChildCount - 1 do
    begin
      aForm := Application.MainForm.MDIChildren[I];
      OldMaximized := TqForm(aForm).Maximized;
      if aForm is TqForm then
      begin
        TqForm(aForm).MaxWidth := MaxWidth;
        TqForm(aForm).MaxHeight := MaxHeight;
        //TqForm(aForm).MinMaxWidth := MaxWidth;    beware bei not sizeable (ParaFrm)
        //TqForm(aForm).MinMaxHeight := MaxHeight;
      end;
      if aForm.WindowState = wsNormal then  //unnötig and (aForm.FormStyle = fsMDIChild) then
      begin
        if Reduce then
        begin  //Child-Fenster verkleinern
          aLeft := aForm.Left;
          aTop := aForm.Top;
          aWidth := aForm.Width;
          aHeight := aForm.Height;
          if aLeft + aWidth > MaxWidth then
          begin
            aLeft := IMax(0, MaxWidth - aWidth);
            aWidth := IMin(aWidth, MaxWidth - aLeft);
          end;
          if aTop + aHeight > MaxHeight then
          begin
            aTop := IMax(0, MaxHeight - aHeight);
            aHeight := IMin(aHeight, MaxHeight - aTop);
          end;
//          if not TqForm(aForm).Sizeable then
//          begin
//            TqForm(aForm).MinMaxWidth := aWidth;
//            TqForm(aForm).MinMaxHeight := aHeight;
//          end;
          aForm.SetBounds(aLeft, aTop, aWidth, aHeight);
        end;
        if aForm is TqForm then
        begin
          TqForm(aForm).SetMaximized(OldMaximized);  //Maximized Fenster (zB MenuFrm) vergrößern
        end;
      end;
    end;
  end;
end;

procedure TqForm.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin                                           {message WM_WINDOWPOSCHANGED;}
  inherited;
  if (LNavigator <> nil) and not InLoaded and HasLoaded and
     ((lnSavePosition in LNavigator.Options) or (SysParam.SavePosition)) then
  begin
    // SavePosition(true); - schlecht - 19.12.08
    SavePositionFlag := true;
  end;
  //SMess('%s WMWindowPosChanged %s', [TimeToStr(Time), self.Classname]);

  //Bediener hat Fenster verkleinert. Das Fenster ist nicht mehr Maximized.
  if MinMaxInit and Sizeable and
     ((MaxWidth - Width > 10) or (MaxHeight - Height > 10)) then
    Maximized := false;
end;

procedure TqForm.WMActivate(var Message: TWMActivate);
begin
  inherited;  //18.04.09
end;

procedure TqForm.WMShowWindow(var Message: TWMShowWindow);
begin
  (*AHeight := InitHeight;
  AWidth := InitWidth;
  if (LNavigator <> nil) and (lnSavePosition in LNavigator.Options SysParam.SavePosition)) ) then
  begin
    LoadPosition;
  end;*)
  if (WindowState = wsNormal) and not MinMaxInit then
    SetMinMaxInfo;
  inherited ;
end;

procedure TqForm.SetMinMaxInfo;
var
  ALeft, ATop, AWidth, AHeight: integer;
  FullScreenHeight: integer;
  (*PanClient: TWinControl;
  Re: TRect;
  WndHandle: HWND;*)
begin
  if (csDesigning in ComponentState) then Exit;
  if (self <> Application.MainForm) and (Application.MainForm <> nil) then
  begin
    if (Application.MainForm <> nil) and (GNavigator <> nil) and
       (FormStyle = fsMDIChild) then
    begin
      if Sizeable or true then  //05.02.08 immer                //30.11.02 Sizeable SweDepoSvr
      begin
        MaxWidth := GNavigator.ClientWidth;
        MaxHeight := GNavigator.ClientHeight;
      end else
      begin
        MaxWidth := IMin(InitWidth, GNavigator.ClientWidth);  //IMax vor 11.12.05
        MaxHeight := IMin(InitHeight, GNavigator.ClientHeight);
      end;
    end else
    begin
      MaxWidth := Screen.Width;
      MaxHeight := Screen.Height;
    end;

    if self <> Application.MainForm then
      AutoScroll := true;

    //if WindowState = wsNormal then   * 03.06.13 weg - auch wenn minimiert gestartet
    begin
      AWidth := IMin(InitWidth, MaxWidth);       {Width);}
      AHeight := IMin(InitHeight, MaxHeight);    {Height);}
      ALeft := IMax(0, IMin(Left, MaxWidth - AWidth));
      ATop := IMax(0, IMin(Top, MaxHeight - AHeight));
      (* if (FormStyle = fsNormal) and          29.10.00 ELP
         (GNavigator <> nil) and (GNavigator.PanelClient <> nil) then
      begin
        Pt := GNavigator.PanelClient.ClientToScreen(Point(Left, Top));
        ALeft := Pt.X;
        ATop := Pt.Y;
      end;*)
      if Maximized then
      begin
        AWidth := MaxWidth;
        AHeight := MaxHeight;
        ALeft := 0;
        ATop := 0;
      end;
      MinMaxWidth := AWidth;
      MinMaxHeight := AHeight;
      MaxLeft := MaxWidth - Width;
      MaxTop := MaxHeight - Height;
      MinMaxInit := true;
      if (ALeft <> Left) or (ATop <> Top) or (AWidth <> Width) or (AHeight <> Height) then
        SetBounds(ALeft, ATop, AWidth, AHeight) else  //erst hier wg WMSetMinMaxInfo
        self.Resize;
    end;
  end;
  if FormStyle <> fsMDIChild then
  begin                                        {Main:}
    FullScreenHeight := GetSystemMetrics(SM_CYFULLSCREEN); {Taskbar}
    if (Height < FullScreenHeight) and            {Taskbar nicht überlappen}
      (Top + Height > FullScreenHeight) then
      begin
        Top := FullScreenHeight - Height;
      end;
  end;
end;

procedure TqForm.Minimize;
begin
  WindowState := wsMinimized;
end;

procedure TqForm.LoadPosition;
var
  ALeft, ATop, AWidth, AHeight: integer;
  I, ASize: integer;
  L: TValueList;
  AParam, ACompName, APropName, NextS: string;
  AComponent: TComponent;
  AKurz: string;
begin
  AKurz := KurzPos;
  if IniKmp <> nil then
  try           {040999: ClassName -> Kurz}
    Maximized := IniKmp.ReadBool(AKurz, 'Maximized', Maximized);
    if not Maximized then
    begin
      ALeft := IniKmp.ReadInteger(AKurz, 'Left', Left);
      ATop := IniKmp.ReadInteger(AKurz, 'Top', Top);
      AWidth := IniKmp.ReadInteger(AKurz, 'Width', Width);
      AHeight := IniKmp.ReadInteger(AKurz, 'Height', Height);
      SetBounds(ALeft, ATop, AWidth, AHeight);
      Prot0_D('LoadPosition1 %s(%d,%d,%d,%d)', [AKurz, ALeft, ATop, AWidth, AHeight]);
      Prot0_D('LoadPosition2 %s(%d,%d,%d,%d)', [AKurz, Left, Top, Width, Height]);
    end;

    //Splitter-Position über Width/Height seines Controls speichern:
    L := TValueList.Create;
    try
      IniKmp.ReadSectionValues(AKurz, L);
      for I := 0 to L.Count - 1 do
      begin
        AParam := L.Param(I);
        ACompName := PStrTok(AParam, '.', NextS);
        APropName := PStrTok('', '.', NextS);
        ASize := StrToIntDef(L.Value(I), 0);
        if APropName <> '' then
        try
          AComponent := FindComponent(ACompName);
          if AComponent <> nil then
          begin
            if CompareText(APropName, 'WIDTH') = 0 then
              TControl(AComponent).Width := ASize else
            if CompareText(APropName, 'HEIGHT') = 0 then
              TControl(AComponent).Height := ASize;
          end else
          if (CompareText(APropName, 'WIDTH') = 0) or
             (CompareText(APropName, 'HEIGHT') = 0) then
          begin
            IniKmp.DeleteKey(AKurz, AParam);  //nicht mehr speichern - 05.01.04
            IniKmp.WriteString(AKurz, 'unknown komponent ' + ACompName, APropName + '=' + L.Value(I));
          end;
        except on E:Exception do
          EProt(self, E, 'TqForm.LoadPosition(%s.%s', [ACompName, APropName]);
        end;
      end;
    finally
      L.Free;
    end;
  except on E:Exception do
    EProt(self, E, 'LoadPosition', [0]);
  end;
end;

procedure TqForm.WMLButtonUp(var Message: TWMLButtonUp);
begin
  //Achtung: diese proc wird nie aufgerufen!
  inherited;
  if SavePositionFlag then
  begin
    SavePositionFlag := false;
    SavePosition(true);
  end;
  { TODO : auch wenn Größenänderung per Keyboard: SavePosition aufrufen }

end;

function TqForm.KurzPos: string;
// Ergibt Kurz für Load/SavePosition.
// Berücksichtigt Spezialmaske 'AUSWx' von Ausw_Kmp.
begin
  Result := Kurz;
  if BeginsWith(Kurz, 'AUSW', false) and (StrToIntTol(Copy(Kurz, 5, MaxInt)) > 0) then
    Result := 'AUSW1';
end;

procedure TqForm.SavePosition(Persistent: boolean);
var
  I: integer;
  ASplitter: TqSplitter;
  ARect: TRect;
  LastError: DWORD;
  ALeft, ATop, AWidth, AHeight: integer;
  AKurz: string;
begin
  if (IniKmp <> nil) and (WindowState = wsNormal) then
  try           {040999: ClassName -> Kurz}
    if Persistent then
    begin
      ALeft := Left;
      ATop := Top;
      AWidth := Width;
      AHeight := Height;
      if FormStyle <> fsMDIChild then
      begin
        //Falls Taskbar oben oder links ist dann Koord anpassen
        if not SystemParametersInfo(SPI_GETWORKAREA, 0, @ARect, 0) then
        begin
          LastError := GetLastError;
          Prot0('SystemParametersInfo(SPI_GETWORKAREA): %d(%s)', [LastError, SysErrorMessage(LastError)]);
        end else
        begin
          ALeft := ALeft - ARect.Left;
          ATop := ATop - ARect.Top;
        end;
      end;
      AKurz := KurzPos;
      IniKmp.WriteInteger(AKurz, 'Left', ALeft);
      IniKmp.WriteInteger(AKurz, 'Top', ATop);
      IniKmp.WriteInteger(AKurz, 'Width', AWidth);
      IniKmp.WriteInteger(AKurz, 'Height', AHeight);
      IniKmp.WriteBool(AKurz, 'Maximized', Maximized);
      Prot0_D('Saveposition %s(%d,%d,%d,%d)', [AKurz, ALeft, ATop, AWidth, AHeight]);
      for I := 0 to ComponentCount - 1 do
        if Components[I] is TqSplitter then
        begin
          ASplitter := Components[I] as TqSplitter;
          {IniKmp.WriteInteger(AKurz, Name + '.Size', GetSize);  geht so nicht}
          //Splitter-Position über Width/Height seines Controls speichern:
          if ASplitter.SavePosition and ASplitter.Visible and (ASplitter.GetControlName <> '') then
          begin
            IniKmp.WriteInteger(AKurz, Format('%s.%s', [ASplitter.GetControlName,
              ASplitter.GetControlProp]), IMax(1, ASplitter.GetSize));  //0-Größe nicht speichern!
          end;
        end;
    end;
    {InitWidth := Width;
    InitHeight := Height;  030200}
  except on E:Exception do
    EProt(self, E, 'SavePosition', [0]);
  end;
end;

procedure TqForm.ShowNormal(State: TWindowState = wsNormal);
{Normal anzeigen}
begin
  if Enabled then {Delphi Eigenschaft}
  begin
    //WindowState := wsNormal;
    WindowState := State;   //ab 12.01.04
    if not MinMaxInit then
      SetMinMaxInfo; {Koordinaten berechnen }
    if WindowState <> wsMinimized then
    begin
      Show;
      SetFocus;
    end;
    {270799: Sizeable in CreateWnd}
  end;
end;

procedure TqForm.Paint;
begin
  if LNavigator <> nil  then
  begin
    LNavigator.PaintBackGround(self);
  end;
  inherited Paint;
end;

procedure TqForm.Init(Sender: TComponent);      {von WmShowWindow}
(* Öffnet
   Checked Objektrechte *)
{Expliziete Initialisierung von GNav}
var
  I: integer;
  ALookUpDef: TLookUpDef;
  FormObj: TqFormObj;
begin
  {exit; verhindert tabbedfehler}
  for I:= 0 to ComponentCount-1 do           {Berechtigungen für LookUpDef's}
    if Components[i] is TLookUpDef then
    begin
      ALookUpDef := Components[i] as TLookUpDef;       {gleiche Rechte wie LNav}
      {Form-Objekt und Rechte holen über Kürzel. Keine Fehlermeldugn anzeigen}
      if GNavigator = nil then
        FormObj := nil else
        FormObj := GNavigator.GetFormObj(ALookUpDef.LuKurz, true, false);
      if FormObj <> nil then                           {Rechte von Fremdmaske}
        ALookUpDef.NavLink.TabellenRechte := FormObj.TabellenRechte else  //neu 03.03.04
        ALookUpDef.NavLink.TabellenRechte := LNavigator.NavLink.TabellenRechte; //wie bisher
    end;
  if LNavigator <> nil then
    LNavigator.Init;                         {SQL-Afbau, FormatList, CalcList}
  for I:= 0 to ComponentCount-1 do           {Initialisierung von LookUpDef's}
    if Components[i] is TLookUpDef then
    begin
      ALookUpDef := Components[i] as TLookUpDef;
      ALookUpDef.Init;                                 {BuildSql, AddCalcFields}
    end;
  if LNavigator <> nil then
    if LNavigator.DataSet <> nil then
      LNavigator.DataSet.EnableControls;    {ruft OnRech-Ereignis. alle Tbls OK}
  for I:= 0 to ComponentCount-1 do
    if Components[i] is TLookUpDef then
    begin
      ALookUpDef := Components[i] as TLookUpDef;
      if ALookUpDef.DataSet <> nil then
        ALookUpDef.DataSet.EnableControls;          {OnRech. Alle Tbls jetzt OK}
    end;
  if LNavigator <> nil then
    LNavigator.DoInit;         {Ruft OnInit-Ereignis wenn noch nicht aufgerufen}
  FormCheckAsw(self);

  CheckReadOnly;
  HasInit := true;
//   if LNavigator <> nil then
//     LNavigator.CheckAutoOpen(false);  // erst hier; siehe LNavigator.StateChange; - 11.01.07
end;

procedure TqForm.CheckReadOnly;
begin
  if not CheckedReadOnly then
  begin
    CheckedReadOnly := true;   //Flag dass nur einmal aufgerufen
    PostMessage(Handle, BC_CHECKREADONLY, WPARAM(0), LPARAM(0));
  end;
end;

procedure TqForm.SetRoAttrib(WinControl: TWinControl; NoInput: boolean;
  cl:TColor; TabStopOK: boolean);
// Set ReadOnly-Farbe. Für BCCheckReadOnly
var
  AColor: TColor;
  ATabStop: boolean;
  clEdit, clMark: TColor;
  clOK: boolean;
  clCtl: TColor;
  ParentControl: TWinControl;
begin
  clCtl := TDummyControl(WinControl).Color;
  if WinControl.Name = SysParam.OurLookUpEdit then
    Debug0;
  if GNavigator <> nil then
  begin
    if cl = clWindow then
    begin
      {Brush.Color := clHighlight;
       Font.Color := clHighlightText;}
      if GNavigator.MarkAllMarked then
        clEdit := GNavigator.ColorMarkAll else
        clEdit := GNavigator.ColorEditWhite;
      clMark := GNavigator.ColorMarkAll;
      clOK := (clCtl = clWindow) or (clCtl = GNavigator.ColorEditWhite) or
              (clCtl = GNavigator.ColorMarkAll);
    end else
    begin
      clEdit := GNavigator.ColorEditGray;
      clMark := GNavigator.ColorEditGray;
      clOK := (clCtl = clBtnFace) or (clCtl = GNavigator.ColorEditGray) or
              (clCtl = GNavigator.ColorMarkAll) or
              (clCtl = GNavigator.ColorDetail);
    end;
    if not NoInput then
    begin                   //übergeordnete Controls checken auf Enabled - 31.12.03
      ParentControl := WinControl.Parent;
      while not NoInput and (ParentControl <> nil) do
      begin
        if ParentControl.Visible and not ParentControl.Enabled then
          NoInput := true else
          ParentControl := ParentControl.Parent;
      end;
    end;
    if NoInput then
    begin
      ATabStop := false;
      if GNavigator.MarkAllMarked then
        AColor := clMark else
        AColor := cl;
    end else                 {clBtnFace,clGrayText}
    begin
      ATabStop := true;
      AColor := clEdit;
    end;
    if (clCtl <> AColor) and clOK then
      TDummyControl(WinControl).Color := AColor;
    if (WinControl.TabStop <> ATabStop) and TabStopOK and not Self.NoCheckTabStop then
      WinControl.TabStop := ATabStop;                //27.11.13 Tabstop nur wenn Global eingestellt
    if WinControl is TCustomComboBox then            //Problem mit markierten Comboboxen
      TCustomComboBox(WinControl).SelLength := 0;
  end;
end;

procedure TqForm.BCCheckReadOnly(var Message: TWMBroadcast); //message BC_CHECKREADONLY;
// Farbe zur Erkennung der Eingabeerlaubnis setzen
var
  I, I1: integer;
  {ACustomEdit: TCustomEdit;
  ADBCheckBox: TDBCheckBox;
  ADBRadioGroup: TDBRadioGroup;
  ACheckBox: TCheckBox;}
  AWinControl: TWinControl;
  AField: TField;
  NoInput, InQuery: boolean;
  ARadioButton: TRadioButton;
begin
  CheckedReadOnly := false;
  InQuery := (LNavigator <> nil) and (LNavigator.dsQuery or LNavigator.dsChangeAll);
  for I:= 0 to ComponentCount-1 do
  begin
    if Components[i] is TWinControl then
    begin
      AWinControl := Components[i] as TWinControl;
      if AWinControl is TCustomEdit then
      begin
        if AWinControl is TDBEdit then
          with AWinControl as TDBEdit do
          begin
            NoInput := ReadOnly or not Enabled or (DataSource = nil) or (Field = nil);
            if not NoInput and not Field.CanModify then
              NoInput := true;
            if not NoInput and (DataSource <> nil) and
               (DataSource.State in [dsBrowse,dsInActive]) then
              NoInput := true;
            if not NoInput and (MaxLength <> 0) and (MaxLength <> Field.Size) then
              if Field is TStringField then
                MaxLength := Field.Size else  //wird beim Suchen nicht immer so gesetzt - 24.04.09
                MaxLength := 0;               //BCD: size = Anzahl Nachkommas
          end else
        if AWinControl is TDBMemo then
          with AWinControl as TDBMemo do
          begin
            NoInput := ReadOnly or not Enabled or (DataSource = nil) or (Field = nil);
            if not NoInput and not Field.CanModify then
              NoInput := true;
            if not NoInput and (DataSource <> nil) and
              (DataSource.State in [dsBrowse,dsInActive]) then
              NoInput := true;
          end else
        with TDummyCustomEdit(AWinControl) do
        begin
          NoInput := ReadOnly or not Enabled;
        end;
        SetRoAttrib(AWinControl, NoInput, clWindow, true);
      end else
      if AWinControl is TMultiGrid then
      begin
        with AWinControl as TMultiGrid do
        if (LNavigator <> nil) and (LNavigator.DataSource <> nil) and
           (LNavigator.DataSource.DataSet <> nil) and
           (DataSource <> nil) and (DataSource.DataSet <> nil) and
           (DataSource <> LNavigator.DataSource) then         {nur Detail-Grids}
        begin
          NoInput := (DataSet is TuQuery) and not TuQuery(DataSet).RequestLive;
          if InQuery or not (LNavigator.nlState in nlEditStates) then
            NoInput := true;
          if not (muCustColor in MuOptions) and not ReadOnly then
          begin
            SetRoAttrib(AWinControl, NoInput, clWindow, true);
            AWinControl.Perform(BC_MULTIGRID, mgColorChanged, 0);
          end;
        end;
      end else
      if AWinControl is TAswCheckListBox then
      begin
        with AWinControl as TAswCheckListBox do
        begin
          NoInput := ReadOnly or not Enabled;
          if not NoInput then
          begin
            if (Field = nil) and (DataSource <> nil) and
               (DataSource.DataSet <> nil) then
              AField := DataSource.DataSet.FindField(DataField) else
              AField := Field;
            if AField <> nil then
            begin
              NoInput := not AField.CanModify;
              if not NoInput and (DataSource.State = dsBrowse) then
                NoInput := true;
            end;
          end;
          SetRoAttrib(AWinControl, NoInput, LoadedColor, true);
        end;
      end else
      if AWinControl is TDBCheckBox then
      begin
        with AWinControl as TDBCheckBox do
        begin
          NoInput := ReadOnly or not Enabled;
          if InQuery then
            AllowGrayed := true else
          if AWinControl is TAswCheckBox then
            AllowGrayed := TAswCheckBox(AWinControl).LoadedAllowGrayed;
          if not NoInput then
          begin
            if (Field = nil) and (DataSource <> nil) and
               (DataSource.DataSet <> nil) then
              AField := DataSource.DataSet.FindField(DataField) else
              AField := Field;
            if AField <> nil then
            begin
              NoInput := not AField.CanModify;
              if not NoInput and (DataSource.State = dsBrowse) then
                NoInput := true;
            end;
          end;
          SetRoAttrib(AWinControl, NoInput, clBtnFace, true);
        end;
      end else
      if AWinControl is TDBComboBox  then
      begin
        with AWinControl as TDBComboBox do
        begin
          NoInput := ReadOnly or not Enabled;
          if not NoInput then
          begin
            if (Field = nil) and (DataSource <> nil) and
               (DataSource.DataSet <> nil) then
              AField := DataSource.DataSet.FindField(DataField) else
              AField := Field;
            if AField <> nil then
            begin
              NoInput := not AField.CanModify;
              if not NoInput and (DataSource.State = dsBrowse) then
                NoInput := true;
            end;
          end;
          SetRoAttrib(AWinControl, NoInput, clWindow, true);
        end;
      end else
      if AWinControl is TDBRadioGroup then
      begin
        with AWinControl as TDBRadioGroup do
        begin
          NoInput := ReadOnly or not Enabled or not Parent.Enabled;
          if not NoInput then
          begin
            if (Field = nil) and (DataSource <> nil) and
               (DataSource.DataSet <> nil) then
              AField := DataSource.DataSet.FindField(DataField) else
              AField := Field;
            if AField <> nil then
            begin
              NoInput := not AField.CanModify;
              if not NoInput and (DataSource.State = dsBrowse) then
                NoInput := true;
            end;
          end;
          (*SetRoAttrib(AWinControl, NoInput, clBtnFace, true);
          Besser weil nur innerer Teil gefärbt: tabstop *)
          if TDummyControl(AWinControl).Color = clBtnFace then
            for I1 := 0 to AWinControl.ControlCount-1 do
            begin
              ARadioButton := AWinControl.Controls[I1] as TRadioButton;
              SetRoAttrib(ARadioButton, NoInput, clBtnFace, false);
            end;
        end;
      end else
      if AWinControl is TCheckBox then
      begin
        if AWinControl is TJvCheckBox then  //Jedi JVCL
          with AWinControl as TJvCheckBox do
          begin
            NoInput := ReadOnly or not Enabled;
            SetRoAttrib(AWinControl, NoInput, clBtnFace, true);
          end else
          with AWinControl as TCheckBox do
          begin
            NoInput := not Enabled;
            SetRoAttrib(AWinControl, NoInput, clBtnFace, true);
          end;
      end else
      if AWinControl is TCustomCombobox then
      begin
        with AWinControl as TCustomCombobox do
        begin
          NoInput := not Enabled;
          SetRoAttrib(AWinControl, NoInput, clWindow, true);
        end;
      end else
      if AWinControl is TRadioButton then
      begin
        with AWinControl as TRadioButton do
        begin
          NoInput := not Enabled;
          SetRoAttrib(AWinControl, NoInput, clBtnFace, true);
        end;
      end else
      if AWinControl is TRadioGroup then
      begin
        with AWinControl as TRadioGroup do
        begin
          NoInput := not Enabled or not Parent.Enabled;
          {SetRoAttrib(AWinControl, NoInput, clBtnFace);}
          (* Besser weil nur innerer Teil gefärbt: *)
          if TRadioGroup(AWinControl).Color = clSilver then
          begin
          end;
          if TRadioGroup(AWinControl).Color = clBtnFace then
            for I1 := 0 to AWinControl.ControlCount-1 do
            begin
              ARadioButton := AWinControl.Controls[I1] as TRadioButton;
              SetRoAttrib(ARadioButton, NoInput, clBtnFace, false);
            end;
        end;
      end;
    end;
  end;
end;

procedure TqForm.UpdateEdit;
(* letztes Eingabefeld speichern
   * für Qw_Form.CloseQuery und QbeNav.Cancel *)
begin
  if ActiveControl = nil then
    Exit;
  if not InUpdateEdit then            {Semphore}
  try
    InUpdateEdit := true;
    (*if (LNavigator <> nil) and (LNavigator.EditSource <> nil) and
       (LNavigator.EditSource.DataSet <> nil) and
       (LNavigator.nlState in nlEditStates) then
    begin
      try
        LNavigator.EditSource.DataSet.UpdateRecord;
      except on E:Exception do
          ErrWarn('%s'+CRLF+'UpdateEdit',[E.Message]);
      end;
      {Exit;}
    end else*)
    {ActiveControl.Perform(CM_EXIT, 0, 0);  {ruft FDataLink.UpdateRecord;}
    {ActiveControl.Perform(CM_ENTER, 0, 0);  {wieder zurück}
    if (ActiveControl is TLookUpEdit) then with ActiveControl as TLookUpEdit do
    begin
      UpdateField;
    end else
    if (ActiveControl is TDBEdit) then with ActiveControl as TDBEdit do
    begin
      if Modified and (Field <> nil) and (DataSource.State in dsEditModes) then
        if Field.Text <> Text then        {wg. Datum Y2}
        try
          Field.Text := Text;
        except
        end;
    end else
    if (ActiveControl is TDBMemo) then with ActiveControl as TDBMemo do
    begin
      if Modified and (Field <> nil) and (DataSource.State in dsEditModes) then
        if Field is TStringField then
          Field.Text := Text else
          Perform(CM_EXIT, 0, 0);  {ruft FDataLink.UpdateRecord;}
        {if Field.DataType in [ftMemo,ftGraphic,ftBlob,ftVarBytes] then
          Field.Assign(Lines) else
          Field.Text := GetStringsText(Lines);}
    end else
    if (ActiveControl is TMultiGrid) then with ActiveControl as TMultiGrid do
    begin
      if (DataSource <> nil) and (DataSource.State in dsEditModes) then
        UpdateField;
    end else
    if (ActiveControl.Owner is TMultiGrid) then with ActiveControl.Owner as TMultiGrid do
    begin                                                   {TDBGridInplaceEdit}
      if (DataSource <> nil) and (DataSource.State in dsEditModes) then
        UpdateField;
    end else
    if (ActiveControl is TDBComboBox) then with ActiveControl as TDBComboBox do
    begin
      if (Field <> nil) and (DataSource.State in dsEditModes) then
        Perform(CM_EXIT, 0, 0);  {ruft FDataLink.UpdateRecord;}
    end else
    if (ActiveControl is TDBCheckBox) then with ActiveControl as TDBCheckBox do
    begin
      if (Field <> nil) and (DataSource.State in dsEditModes) then
        Perform(CM_EXIT, 0, 0);  {ruft FDataLink.UpdateRecord;}
    end else
    if (ActiveControl is TDBRadioGroup) then with ActiveControl as TDBRadioGroup do
    begin
      if (Field <> nil) and (DataSource.State in dsEditModes) then
        Perform(CM_EXIT, 0, 0);  {ruft FDataLink.UpdateRecord;}
    end;
  finally
    InUpdateEdit := false;
  end;
end;

procedure TqForm.PutValues(AList: TStrings);
(* Belegt Eingabewerte mit Inhalt von AList *)
var
  I, J, N: integer;
  AComponent: TComponent;
  function RightSide(Index: integer): string;
  var                                {wie StrValue, ohne Trim, ersetzt $FF}
    P: integer;
  begin
    P := Pos('=', AList.Strings[Index]);
    if (P > 0) and (length(AList.Strings[Index]) > P) then
    begin
      result := Copy(AList.Strings[Index], P+1, 254);
      if result[1] = #$FF then
        result[1] := ' ';
    end else
      result := '';
  end;
begin
  try
    I := 0;
    while I < AList.Count do
    begin
      AComponent := FindComponent(StrParam(AList.Strings[I]));
      if AComponent = nil then
      begin
	// 'ReadValues:(%s) nicht gefunden'
        Prot0(SQwf_Form_005,[Kurz + '.' + StrParam(AList.Strings[I])]);
        Inc(I);
        continue;
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

procedure TqForm.GetValues(AList: TStrings);
(* Liest Eingabewerte und schreibt sie nach AList. Löscht vorher AList. *)
var
  I, J, P: integer;
  AComponent: TComponent;
  S: string;
begin
  if csDesigning in ComponentState then
    Exit;
  AList.Clear;
  try
    for I:= 0 to ComponentCount-1 do
    begin
      AComponent := Components[I];
      if AComponent is TCustomMemo then
        with AComponent as TCustomMemo do
        begin
          AList.Add(Format('%s=%d',[Name, Lines.Count]));
          for J := 0 to Lines.Count-1 do
            AList.Add(Format('%s.%d=%s',[Name, J, Lines.Strings[J]]));
        end
      else if AComponent is TCustomListBox then
        with AComponent as TCustomListBox do
        begin
          AList.Add(Format('%s=%d',[Name, Items.Count]));
          for J := 0 to Items.Count-1 do
            AList.Add(Format('%s.%d=%s',[Name, J, Items.Strings[J]]));
        end
      else if AComponent is TCustomEdit then
        AList.Add(Format('%s=%s',[AComponent.Name, TCustomEdit(AComponent).Text]))
      else if AComponent is TCustomComboBox then
        AList.Add(Format('%s=%s',[AComponent.Name, TDummyCustomComboBox(AComponent).Text]))
      else if AComponent is TCustomCheckBox then
      begin
        AList.Add(Format('%s=%d',[AComponent.Name,
          ord(TDummyCustomCheckBox(AComponent).State)]));
      end else
      if AComponent is TCustomRadioGroup then
      begin
        AList.Add(Format('%s=%d',[AComponent.Name,
          ord(TDummyCustomRadioGroup(AComponent).ItemIndex)]));
      end else
      if AComponent is TRadioButton then
      begin
        AList.Add(Format('%s=%d',[AComponent.Name,
          ord(TRadioButton(AComponent).Checked)]));
      end;
    end;
    for I := 0 to AList.Count-1 do               {falls Blank nach '='}
    begin                                        {dann durch FFh ersetzen}
      P := Pos('= ', AList.Strings[I]);
      if P = Pos('=', AList.Strings[I]) then    {ohne Blank}
      begin
        S := AList.Strings[I];
        S[P+1] := #$FF;
        AList.Strings[I] := S;
      end
    end;
  finally
  end;
end;

procedure TqForm.SaveToIni(Section: string);
//Speichert Inhalt/Zustand der visuellen Komponenten in INI
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    GetValues(L);
    IniKmp.ReplaceSection(Section, L);
  finally
    L.Free;
  end;
end;

procedure TqForm.LoadFromIni(Section: string);
//Restauriert Inhalt/Zustand der visuellen Komponenten aus der INI
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    IniKmp.ReadSectionValues(Section, L);
    PutValues(L);
  finally
    L.Free;
  end;
end;

function TqForm.GetLNav: TLNavigator;
begin
  result := LNavigator;
  if result = nil then
    EError(SQwf_Form_006, [Caption]);	// '%s:LNavigator fehlt'
end;

(*** Formularspezifische Routinen ohne Klasse ********************************)

function FormGetLNav(AForm: TObject): TLNavigator;
(* für Designzeit *)
begin
  if AForm = nil then
    EError(SQwf_Form_007+CRLF+'FormGetLNav',[0]);	// 'Formular fehlt'
  if AForm is TqForm then
    result := (AForm as TqForm).LNavigator else
    result := nil;
  (* if not (AForm is TForm) then                warum 100100 ?
    EError('Falscher Formulartyp(%s)'+CRLF+'FormGetLNav',[AForm.ClassName]) else
  *)
  if (result = nil) and (AForm is TForm) then
    result := FindClassComponent(AForm as TForm, TLNavigator) as TLNavigator;
end;

procedure FormCheckAsw(AForm: TForm);
(* Checkt bei Asw-Komponenten die korrekte Einstellung *)
var
  I: integer;
begin
  for I:= 0 to AForm.ComponentCount-1 do
  try
    if AForm.Components[I] is TAswRadioGroup then
      with AForm.Components[I] as TAswRadioGroup do
        AswName := AswName
    else
    if AForm.Components[I] is TAswComboBox then
      with AForm.Components[I] as TAswComboBox do
        AswName := AswName
    else
    if AForm.Components[I] is TAswCheckBox then
      with AForm.Components[I] as TAswCheckBox do
        AswName := AswName
    else
    if AForm.Components[I] is TAswCheckListBox then
      with AForm.Components[I] as TAswCheckListBox do
        AswName := AswName
    else
    if AForm.Components[I] is TQRDBCheckBox then
      with AForm.Components[I] as TQRDBCheckBox do
      begin
        DataField := DataField;
        AswName := AswName;
      end;
  except on E:Exception do
    EProt(Application, E, 'FormCheckAsw(%s)', [OwnerDotName(AForm.Components[I])]);
  end;
end;

procedure FormSetFocus(AForm: TForm);
(* Focus erzwingen. Auch wenn DBGrid aktiv. Für Umschaltung von MDIForm nach MDIChild *)
var
  OldControl: TWinControl;
begin
  if AForm <> nil then
  begin
    OldControl := AForm.ActiveControl;
    if (OldControl is TDBGrid) and (AForm is TqForm) then
    begin
      if (FormGetLNav(AForm) <> nil) and (FormGetLNav(AForm).PageBook <> nil) then
      begin
        FormGetLNav(AForm).PageBook.SetFocus;
        OldControl.SetFocus;
      end;
    end;
    AForm.SetFocus;
  end;
end;

procedure FormResizeStd(AForm: TqForm);
(* Standard Aktionen für Resize Ereignis
   verwendet Tag Offsets bis 4096 ($1000) reserviert bis 32768 ($8000)
    TAG_RESIZE_WIDTH_8 = 32;       $0020
    TAG_RESIZE_HEIGHT_8 = 64;      $0040
    TAG_RESIZE_WIDTH_20 = 128;     $0080
    TAG_RESIZE_HEIGHT_20 = 256;    $0100
    TAG_RESIZE_WIDTH_32  = 512;    $0200
    TAG_RESIZE_BOTTOM    = 1024;   $0400
    TAG_RESIZE_WIDTH_0   = 2048;   $0800
    TAG_RESIZE_HEIGHT_0  = 4096;   $1000
   weitere reservierte Tag Offsets  ($xxxx kan im Tag-Feld eingetippt werden)
    Charset=0 / ANSI_CHARSET       65536 ($10000)  -
*)
var
  edBemerkung: TDBMemo;
  I, N: integer;
  FWidth, FHeight: integer;
  FMaxWidth, FMaxHeight: integer;
  CompName: string;
  ABitBtn: TBitBtn;
  ADBEdit: TCustomEdit;
begin                        (* Schwenk:Enabled=false, bgIntern.Visible=false *)
  I := 0;
  CompName := '?';
  with AForm do
  try
    { wird später nicht mehr unterstützt. In Projektroutine einsetzen. }
    edBemerkung := FindComponent('EdBEMERKUNG') as TDBMemo;
    if (edBemerkung <> nil) and (edBemerkung.Align = alNone) and
       (EdBEMERKUNG.Parent.Width > 0) and (EdBEMERKUNG.Tag = 0) then
    begin
//07.07.12 weg: Tag <> 0 wird unten bearbeitet
//      if EdBEMERKUNG.Tag > 0 then
//        N := EdBEMERKUNG.Tag else
      N := 20;    {Scrollbar}
      EdBEMERKUNG.Width := IMax(20, EdBEMERKUNG.Parent.Width - EdBEMERKUNG.Left - N);
      EdBEMERKUNG.Height := IMax(20, EdBEMERKUNG.Parent.Height - EdBEMERKUNG.Top - N);
    end else
      EdBEMERKUNG := nil;
    for I := 0 to ComponentCount - 1 do
      if (Components[I] <> EdBEMERKUNG) then
    begin
      if I = 318 then
        Debug0;
      if CompareText(Name, SysParam.OurLookUpEdit) = 0 then
      begin
        Debug0;
      end;

      if (Components[I] is TBitBtn) and
         (TWinControl(Components[I]).Parent <> nil) and
         (TWinControl(Components[I]).Parent.Width > 0) then
      begin
        //Buttons mit Edit verknüpft: Button rechts mit Abstand 20px
        aBitBtn := Components[I] as TBitBtn;
        if (aBitBtn.Tag > 0) and ((aBitBtn.Tag and TAG_RESIZE_WIDTH_20) <> 0) then  //128
        begin
          aBitBtn.Left := aBitBtn.Parent.Width - 20 - aBitBtn.Width;
          if Components[I] is TDirBtn then
            aDBEdit := TDirBtn(Components[I]).DBEdit else
          if Components[I] is TFileBtn then
            aDBEdit := TFileBtn(Components[I]).DBEdit else
          if Components[I] is TOpenBtn then
            aDBEdit := TOpenBtn(Components[I]).DBEdit else
          if Components[I] is TLovBtn then
            aDBEdit := TLovBtn(Components[I]).DBEdit else
          if Components[I] is TLookUpBtn then
            aDBEdit := TLookUpBtn(Components[I]).LookUpEdit else
            aDBEdit := nil;
          if aDBEdit <> nil then
          begin
            aDBEdit.Width := aBitBtn.Left - aDBEdit.Left;
            aDBEdit.Tag := aDBEdit.Tag and not TAG_RESIZE_WIDTH_20;
          end;
        end;
      end else
      if Components[I] is TBevel then with Components[I] as TBevel do
      begin
        if (Shape = bsTopLine) and (Parent.Width > 0) then  //and Left = 0
        begin
          Left := 0;
          if (Tag and TAG_RESIZE_WIDTH_8) <> 0 then        //32
            Width := Parent.Width - 8 else
          if (Tag and TAG_RESIZE_WIDTH_20) <> 0 then       //128
            Width := Parent.Width - 20 else
            Width := Parent.Width;
        end;
      end else
      if ((Components[I] is TCustomEdit) or (Components[I] is TCustomComboBox)) and
         (TWinControl(Components[I]).Parent <> nil) and
         (TWinControl(Components[I]).Parent.Width > 0) then
        with Components[I] as TWinControl do
      begin
        if (Tag < 10000) and (Tag >= 32) then
        begin
          FWidth := Width;
          FHeight := Height;
          FMaxWidth := IntDflt(Constraints.MaxWidth, 9999);
          FMaxHeight := IntDflt(Constraints.MaxHeight, 9999);

          if (Tag and TAG_RESIZE_HEIGHT_0) <> 0 then       //4096   \
            FHeight := Parent.Height - Top - 0;            //         + 6144
          if (Tag and TAG_RESIZE_WIDTH_0) <> 0 then        //2048   /
            FWidth := Parent.Width - Left - 0;
          if (Tag and TAG_RESIZE_WIDTH_8) <> 0 then        //32
            FWidth := Parent.Width - Left - 8;
          if (Tag and TAG_RESIZE_HEIGHT_8) <> 0 then       //64
            FHeight :=Parent.Height - Top - 8;
          if (Tag and TAG_RESIZE_WIDTH_20) <> 0 then       //128    \
            FWidth := Parent.Width - Left - 20;            //         + 384
          if (Tag and TAG_RESIZE_HEIGHT_20) <> 0 then      //256    /
            FHeight :=Parent.Height - Top - 20;
          if (Tag and TAG_RESIZE_WIDTH_32) <> 0 then       //512
            FWidth := Parent.Width - Left - 32;
          if (Align = alNone) and
             ((Tag and TAG_RESIZE_BOTTOM) <> 0) then       //1024
          begin
            FWidth := Parent.Width - Left;
            FHeight :=Parent.Height - Top;
          end;

          SetBounds(Left, Top, IMin(FMaxWidth, FWidth), IMin(FMaxHeight, FHeight));  //Flimmern vermeiden
        end;
      end else
      { vor 12.10.02
        if Components[I] is TCustomControl then with Components[I] as TCustomControl do }
      //if Components[I] is TWinControl then with Components[I] as TWinControl do
      if (Components[I] is TControl) and
         not (Components[I] is TCustomButton) and  //TButton, TBitBtn, TSpeedBtn
         (TWinControl(Components[I]).Parent <> nil) and
         (TControl(Components[I]).Parent.Width > 0) then
      with Components[I] as TControl do
      begin
        if (Align = alNone) and (Tag < 10000) and (Tag >= 32) then
        begin


          FWidth := Width;
          FHeight := Height;
          FMaxWidth := IntDflt(Constraints.MaxWidth, 9999);
          FMaxHeight := IntDflt(Constraints.MaxHeight, 9999);

          if (Tag and TAG_RESIZE_BOTTOM) <> 0 then       //1024
          begin
            FWidth := Parent.Width - Left;
            FHeight :=Parent.Height - Top;
          end;
          if (Tag and TAG_RESIZE_HEIGHT_0) <> 0 then     //4096
            FHeight :=Parent.Height - Top - 0;
          if (Tag and TAG_RESIZE_WIDTH_0) <> 0 then      //2048
            FWidth := Parent.Width - Left - 0;
          if (Tag and TAG_RESIZE_WIDTH_8) <> 0 then      //32
            FWidth := Parent.Width - Left - 8;
          if (Tag and TAG_RESIZE_HEIGHT_8) <> 0 then     //64
            FHeight :=Parent.Height - Top - 8;
          if (Tag and TAG_RESIZE_WIDTH_20) <> 0 then     //128
            FWidth := Parent.Width - Left - 20;
          if (Tag and TAG_RESIZE_HEIGHT_20) <> 0 then    //256
            FHeight :=Parent.Height - Top - 20;
          if (Tag and TAG_RESIZE_WIDTH_32) <> 0 then     //512
            FWidth := Parent.Width - Left - 32;

          SetBounds(Left, Top, IMin(FMaxWidth, FWidth), IMin(FMaxHeight, FHeight));  //Flimmern vermeiden
        end;
      end;
    end;
    I := -1;
  except on E:Exception do begin
      //EProt(AForm, E, 'FormResizeStd:%d', [I]);
      try
        CompName := OwnerDotName(Components[I]);
      except end;
      Prot0('FormResizeStd:%d(%s) - %s', [I, CompName, E.Message]);
    end;
  end;
end;

//ersetzt durch KeyDown
//procedure TqForm.CNKeyDown(var Message: TWMKeyDown);
//begin
//  with Message do if EnterAsTab then
//  begin
//    Result := 1;
//    if CharCode = VK_RETURN then
//    begin
//      CharCode := VK_TAB;
//      Result := 0;
//    end;
//  end;
//  inherited;
//end;

procedure TqForm.KeyDown(var Key: Word; Shift: TShiftState);
var
  Mgs: TMsg;
begin
  if EnterAsTab and (Key = VK_RETURN) then  //nur die Enter-Taste auf dem NumBlock
  begin
    Key := 0;
    Perform(WM_NextDlgCtl, ord(Shift = [ssShift]), 0);
    PeekMessage(Mgs, 0, WM_CHAR, WM_CHAR, PM_REMOVE); // Beep-Ton ausschalten (WMCHAR's will be removed)
  end else
    inherited;
end;

function TqForm.GetDatasetList: TStrings;
//Liste der Datasets der form. Name in Großbuchstaben (für IndexOf).
var
  I: integer;
  ADataSet: TDataSet;
begin
  if fDatasetList = nil then
  begin
    fDatasetList := TStringList.Create;
    for I := 0 to ComponentCount - 1 do
    begin
      if Components[I] is TDataSet then
      begin
        ADataSet := Components[I] as TDataSet;
        fDatasetList.AddObject(UpperCase(ADataSet.Name), ADataSet);
      end;
    end;
  end;
  Result := fDatasetList;
end;

begin
  FormIndex := 1;
end.

