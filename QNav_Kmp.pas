unit QNav_Kmp;
(* Query Navigator

   Autor: Martin Dambach

   letzte Änderung
   01.09.96     Erstellen
   11.10.96     ReadOnly
                Gruppierung mit Spaces-Property
   24.09.97     Cancel und Refresh Buttons enabled öfter (ROE)
   12.01.98     Suchtabelle Feldlänge=64   (war 100)
   07.10.99     SetFltr(AFltrList: TFltrList)
   07.04.00     nur Delphi32: Navlink.Marklist ersetzt durch TDBGrid.SelectedRows
   21.05.01     BtnRefresh: Open mit PostMessage. Strg: positioniert
   22.09.02     'Auge' Button entspr. RequestLive :
                 nein da DataSource.AutoEdit nützlicher ist um Massenänderungen in Tabellen durchzuführen
   23.04.09     In der Einzelsicht haben die TDBEdits wieder Maxlength=200
   22.02.13     '[gefiltert]' nach QueryAccept in Titel
   -------------------------------------------
   Basis für GNavigator
   TQbeNavigateBtn: +nbReadOnly            in nlnk__Kmp
                 Auge-Bitmap
   Gruppierung:


*)

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, Controls, Forms, Mask,
  Buttons, Graphics, Menus, StdCtrls, ExtCtrls, DB, Uni, DBAccess, MemDS,
  UMem_Kmp, UQue_Kmp,
  DPos_Kmp, NLnk_Kmp, Prots;


const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}
  SpaceSize       =  5;   { size of space between special buttons }

(*** TNavLink *************************************************************)
  BtnHintId: array[TQbeNavigateBtn] of string = ('Suchen', 'Erster Datensatz',
    'Vorheriger Datensatz', 'Nächster Datensatz', 'Letzter Datensatz',
    'Nur Lesen', 'Datensatz einfügen', 'Datensatz löschen',
    'Datensatz bearbeiten', 'Übernehmen', 'Bearbeiten abbrechen',
    'Daten aktualisieren');

type
  TNavButton = class;
  TQBEDataLink = class;

  TQueryModus = (qmQuery, qmChangeAll);
  TNavGlyph = (ngEnabled, ngDisabled);

  {TButtonSet = set of TQbeNavigateBtn; in NLnk}
  TNavButtonStyle = set of (nsAllowTimer, nsFocusRect);

  ENavClick = procedure (Sender: TObject; Button: TQbeNavigateBtn) of object;

{ TDBQBENav }

  TDBQBENav = class (TCustomPanel)
  private

    FDataLink: TQBEDataLink;  {Verbindung zur Datasource}
    FSpace: Integer;  {Anzahl Pixel zwischen Buttongruppen}
    FVisibleButtons: TQbeButtonSet; {Menge der sichtbaren Buttons}
    FOnNavClick: ENavClick; {Click Ereigniss}
    FocusedButton: TQbeNavigateBtn; {aktiver Button}
    ButtonWidth: Integer;
    MinBtnSize: TPoint;
    GlyphName: string;

    procedure SetSpace(Value: integer);
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    procedure InitButtons;
    function SpaceFollows(I: TQbeNavigateBtn): boolean;
    procedure InitHints;
    procedure Click(Sender: TObject); reintroduce;  {kein override. Sender immer Btn !}
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    {Gemeinsame Mouse-Down Ereigniss für alle Buttons}
    procedure SetVisible(Value: TQbeButtonSet);
    procedure AdjustSize (var W: Integer; var H: Integer); reintroduce;
    procedure WMSize(var Message: TWMSize);  message WM_SIZE; {vom Panel}
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;

    function GetNavLink: TNavLink;
    procedure SetdsQuery(Value: boolean);
    function GetdsQuery: boolean;
    procedure SetAutoCommit(Value: boolean);
    function GetAutoCommit: boolean;
    procedure SetQBETableName(Value: string);
    function GetQBETableName: string;
    procedure SetQBETable(Value: TuMemTable);
    function GetQBETable: TuMemTable;
    procedure SetQBESaveDataSet(Value: TuQuery);
    function GetQBESaveDataSet: TuQuery;
    function GetEditSource: TDataSource;
    procedure SetEditSource(Value: TDataSource);
    procedure SetFltrList(Fltr: TFltrList);
    function GetFltrList: TFltrList;
    procedure SetKeyList(Value: TValueList);
    function GetKeyList: TValueList;
    procedure SetKeyFields(Value: string);
    function GetKeyFields: string;
    procedure ChangeAllAccepted;
    function GetChangeAll: Boolean;
    procedure SetChangeAll(const Value: Boolean);
  protected
    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure BCGNavClick(var Message: TMessage); message BC_GNAVCLICK;
    procedure BCStartForm( var Message: TMessage); message BC_STARTFORM;
    procedure BCIniDb( var Message: TMessage); message BC_INIDB;
  public
    Buttons: array[TQbeNavigateBtn] of TNavButton;
    ButtonHints: array[TQbeNavigateBtn] of string;
    FNavLink: TNavLink;       {wichtig für Zugrif von LNav.Destroy}
    FNavLinkStart: TNavLink;
    InQueryAccepted: boolean;
    InBtnClick: boolean;
    {User Routinen}
    function IsNavLink(aNlnk: TNavLink): boolean;
    procedure TrInit;
    procedure SetFltr(AFltrList: TFltrList);
    procedure CopyFltr(AFltrList: TFltrList);
    {Suchroutinen}
    procedure QueryBeforePost(ADataSet: TDataSet);
    procedure QueryActivate(Modus: TQueryModus);
    procedure QueryCancel;
    procedure QueryAccepted;                                     {Suche starten}

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure BtnClick(Index: TQbeNavigateBtn);
    procedure Commit;
    procedure DataChanged;
    procedure EditingChanged;
    procedure ActiveChanged;

    property NavLink: TNavLink read GetNavLink write FNavLink;
    property NavLinkStart: TNavLink read FNavLinkStart write FNavLinkStart;
    property QBETableName: string read GetQBETableName write SetQBETableName;
    property QBETable: TuMemTable read GetQBETable write SetQBETable;
    property QBESaveDataSet: TuQuery read GetQBESaveDataSet write SetQBESaveDataSet;
    property dsQuery: Boolean read GetdsQuery write SetdsQuery;
    property dsChangeAll: Boolean read GetChangeAll write SetChangeAll;
    property AutoCommit: Boolean read GetAutoCommit write SetAutoCommit;         {von NavLink}
    property FltrList: TFltrList read GetFltrList write SetFltrList;
    property KeyList: TValueList read GetKeyList write SetKeyList;
    property KeyFields: string read GetKeyFields write SetKeyFields;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property EditSource: TDataSource read GetEditSource write SetEditSource;
    property Space: integer read FSpace write SetSpace;
    property VisibleButtons: TQbeButtonSet read FVisibleButtons write SetVisible
      {default [qnbQuery, qnbFirst, qnbPrior, qnbNext, qnbLast, qnbInsert,
        qnbDelete, qnbEdit, qnbPost, qnbCancel, qnbRefresh]};
    property Align;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Ctl3D;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick: ENavClick read FOnNavClick write FOnNavClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
  end;

{ TNavButton }

  TNavButton = class(TSpeedButton)
  private
    FIndex: TQbeNavigateBtn;
    FNavStyle: TNavButtonStyle;
    FRepeatTimer: TTimer;
    procedure TimerExpired(Sender: TObject);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    destructor Destroy; override;
    property NavStyle: TNavButtonStyle read FNavStyle write FNavStyle;
    property Index : TQbeNavigateBtn read FIndex write FIndex;
 published

   end;

{ TQBEDataLink ****************************************************** }

  TQBEDataLink = class(TDataLink)
  private
    FNavigator: TDBQBENav;
  protected
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure ActiveChanged; override;
  public
    constructor Create(ANav: TDBQBENav);
    destructor Destroy; override;
  end;

implementation
{$R *.RES}           (* Resourcen 'QBE_?????' in QNAV_KMP.RES *)
uses DBIErrs, DBITypes, Clipbrd, DBConsts, Dialogs,
     DBCtrls,
     Nstr_Kmp, GNav_Kmp, LNav_Kmp, Err__Kmp, RechtKmp, IniDbKmp,
     Qwf_Form, LuDefKmp, MuGriKmp, KmpResString;

type
  TDummyDataSet = class(TDataSet);

const
  BtnStateName: array[TNavGlyph] of PChar = ('EN', 'DI');

  BtnTypeName: array[TQbeNavigateBtn] of PChar = (
        'QUERY',
        'FIRST', 'PRIOR', 'NEXT', 'LAST',
        'READONLY', 'INSERT', 'DELETE', 'EDIT',
        'POST', 'CANCEL', 'REFRESH');

{ TDBQBENav ********************************************************** }

constructor TDBQBENav.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNavLinkStart := TNavLink.Create( self);
  NavLink := FNavLinkStart;
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] +
    [csFramed, csOpaque];
  FDataLink := TQBEDataLink.Create(Self);
  if not (csLoading in ComponentState) then
    FVisibleButtons := [qnbQuery,
                        qnbFirst, qnbPrior, qnbNext, qnbLast,
                        qnbReadOnly, qnbInsert, qnbDelete, qnbEdit,
                        qnbPost, qnbCancel, qnbRefresh];
  ShowHint:=True;
  InitButtons;
  BevelOuter := bvNone;
  BevelInner := bvNone;
  Width := 241;
  Height := 25;
  ButtonWidth := 0;
  FocusedButton := qnbFirst;
end;

destructor TDBQBENav.Destroy;
begin
  NavLinkStart.Free;
  FNavLinkStart := nil;
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TDBQBENav.InitButtons;
{Buttons anlegen}
var
  I: TQbeNavigateBtn;
  Btn: TNavButton;
  X: Integer;
  ResName: array[0..40] of Char;
begin
  MinBtnSize := Point(25, 25);          { ori Point(20, 18);}
  X := 0;
  for I := Low(Buttons) to High(Buttons) do {Buttons is array of Tbutton}
  begin
    Btn := TNavButton.Create (Self);
    Btn.Index := I;
    Btn.Visible := I in FVisibleButtons;
    Btn.Enabled := True;
    Btn.Flat := True;                    {win98 Style 290101}
    Btn.SetBounds (X, 0, MinBtnSize.X, MinBtnSize.Y);
    Btn.Glyph.Handle := LoadBitmap(HInstance,
        StrFmt(ResName, 'QBE_%s', [BtnTypeName[I]]));
    GlyphName := 'QBE_QUERY';
    {if I = nbQuery then Btn.NumGlyphs:=1 else}
    Btn.NumGlyphs := IMax(1, Btn.Glyph.Width div Btn.Glyph.Height);
    Btn.OnClick := Click;
    Btn.OnMouseDown := BtnMouseDown;
    Btn.Parent := self;
    if I in [qnbQuery, qnbReadOnly, qnbInsert, qnbDelete, qnbEdit] then
    begin
      Btn.GroupIndex := self.Tag + 1 + ord(I);           {somit Down möglich}
      Btn.AllowAllUp := true;
    end;
    Buttons[I] := Btn;
    X := X + MinBtnSize.X;
    if SpaceFollows(I) then
      X := X + Space;
  end;
  InitHints;
  Buttons[qnbPrior].NavStyle := Buttons[qnbPrior].NavStyle + [nsAllowTimer];
  Buttons[qnbNext].NavStyle  := Buttons[qnbNext].NavStyle + [nsAllowTimer];
end;

procedure TDBQBENav.InitHints;
var
  J: TQbeNavigateBtn;
begin
  for J := Low(Buttons) to High(Buttons) do
  begin
    //Buttons[J].Hint := BtnHintId[J];
    ButtonHints[J] := BtnHintId[J];
  end;
end;

procedure TDBQBENav.TrInit;
var                   {Translation Init (erst aufrufen wenn Quelle aktiv}
  J: TQbeNavigateBtn;
begin
  for J := Low(Buttons) to High(Buttons) do
  begin
    //Buttons[J].Hint := GNavigator.TranslateStr(self, BtnHintId[J]);
    ButtonHints[J] := GNavigator.TranslateStr(self, BtnHintId[J]);
  end;
end;

(* NavLink als Properties ******************************************************)

function TDBQBENav.IsNavLink(aNlnk: TNavLink): boolean;
begin
  if (self = nil) or (FNavLink = nil) then
    result := false else
    result := aNlnk = FNavLink;
end;

function TDBQBENav.GetNavLink: TNavLink;
begin
  if FNavLink = nil then
    raise Exception.Create('NavLink=nil');
  result := FNavLink;
end;

procedure TDBQBENav.SetdsQuery(Value: boolean);
var
  NewGlyphName: string;
  ResName: array[0..40] of Char;
begin
  if not (csDestroying in ComponentState) and
     (NavLink.dsQuery <> Value) then
  begin
    NavLink.dsQuery := Value;
    if (DataSource <> nil) then
      DataSource.OnStateChange( self);
    if Value then
      NewGlyphName := 'QBE_QACCEPT' else
      NewGlyphName := 'QBE_POST';
    if GlyphName <> NewGlyphName then
    begin
      GlyphName := NewGlyphName;
      Buttons[qnbPost].Glyph.Handle := LoadBitmap(HInstance,
          StrFmt(ResName, '%s', [GlyphName]));
    end;
  end;
end;

function TDBQBENav.GetdsQuery: boolean;
begin
  if FNavLink = nil then
    result := false else
    result := NavLink.dsQuery;
end;

procedure TDBQBENav.SetChangeAll(const Value: Boolean);
var
  NewGlyphName: string;
  ResName: array[0..40] of Char;
begin
  if not (csDestroying in ComponentState) and
     (NavLink.dsChangeAll <> Value) then
  begin
    NavLink.dsChangeAll := Value;
    if (DataSource <> nil) then
      DataSource.OnStateChange(self);  //sollen wir hier wirklich Ereignis auslösen?
    if Value then
      NewGlyphName := 'QBE_QCHANGEALL' else
      NewGlyphName := 'QBE_POST';
    if GlyphName <> NewGlyphName then
    try
      GlyphName := NewGlyphName;
      Buttons[qnbPost].Glyph.Handle := LoadBitmap(HInstance,
          StrFmt(ResName, '%s', [GlyphName]));
    except on E:Exception do
      EProt(self, E, 'SetChangeAll%d(%s)', [ord(Value), NewGlyphName]);
    end;
  end;
end;

function TDBQBENav.GetChangeAll: Boolean;
begin
  if FNavLink = nil then
    result := false else
    result := NavLink.dsChangeAll;
end;

procedure TDBQBENav.SetQBETableName(Value: string);
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+' SetQbeTableName');
  NavLink.TableName := Value;
end;

function TDBQBENav.GetQBETableName: string;
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+' GetQbeTableName');
  result := NavLink.TableName;
end;

procedure TDBQBENav.SetQBETable(Value: TuMemTable);
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+' SetQbeTable');
  NavLink.MemTable := Value;
end;

function TDBQBENav.GetQBETable: TuMemTable;
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+' GetQbeTable');
  result := NavLink.MemTable;
end;

procedure TDBQBENav.SetQBESaveDataSet(Value: TuQuery);
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+' SetQbeSaveDataSet');
  NavLink.SaveDataSet := Value;
end;

function TDBQBENav.GetQBESaveDataSet: TuQuery;
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+' GetQbeSaveDataSet');
  result := NavLink.SaveDataSet;
end;

function TDBQBENav.GetEditSource: TDataSource;
begin
  result := NavLink.EditSource;
end;

procedure TDBQBENav.SetEditSource(Value: TDataSource);
begin
  NavLink.EditSource := Value;
end;

procedure TDBQBENav.SetFltrList(Fltr: TFltrList);
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+' SetFltrList');
  NavLink.FltrList := Fltr;
end;

function TDBQBENav.GetFltrList: TFltrList;
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+' GetFltrList');
  result := NavLink.FltrList;
end;

procedure TDBQBENav.SetKeyList(Value: TValueList);
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+' SetKeyList');
  NavLink.KeyList := Value;
end;

function TDBQBENav.GetKeyList: TValueList;
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+' GetKeyList');
  result := NavLink.KeyList;
end;

procedure TDBQBENav.SetKeyFields(Value: string);
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+' SetKeyFields');
  NavLink.KeyFields := Value;
end;

function TDBQBENav.GetKeyFields: string;
begin
  // 'NavLink=nil bei '
  if FNavLink = nil then raise Exception.Create(SQNav_Kmp_013+'GetKeyFields');
  result := NavLink.KeyFields;
end;

procedure TDBQBENav.SetAutoCommit(Value: boolean);
begin
  if FNavLink <> nil then
  begin
    NavLink.AutoCommit := Value;
  end;
end;

function TDBQBENav.GetAutoCommit: boolean;
begin
  if FNavLink <> nil then
    result := NavLink.AutoCommit
  else
    result := false;
end;

procedure TDBQBENav.Commit;
begin
  if FNavLink <> nil then
    NavLink.Commit;
end;

(*** Größe und Windowsmessages *******************************************)

procedure TDBQBENav.SetSpace(Value: integer);
var
  W, H: integer;
begin
  FSpace := Value;
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
end;

procedure TDBQBENav.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TDBQBENav.BCStartForm( var Message: TMessage);  //message BC_STARTFORM;
//Startet Form mit Index in <Message.wParam>
//Wenn <Message.lParam> > 0 dann wird gewartet bis
//     Form mit Index <Message.lParam - 1> beendet ist.
//Für GNavigator.PostForm und GNavigator.PostCloseForm
var
  AKurz: string;
  IRelease, IStart: integer;
  T1, T2: integer;
begin
  {IRelease := Message.LParam;  {falsch}
  if Message.LParam = 0 then
    IRelease := -1 else
    IRelease := Message.LParam - 1;
  IStart := Message.wParam;
  if GNavigator <> nil then
  begin
    if IRelease >= 0 then
    begin
      AKurz := GNavigator.GetFormKurz(IRelease);
      Prot0('BCStartForm%d(%s):Releasing',[IRelease, AKurz]);
      TicksReset(T1);
      TicksReset(T2);
      while GNavigator.GetForm(AKurz) <> nil do
      begin
        if TicksDelayed(T1) > 1000 then
        begin
          Prot0(SQNav_Kmp_014, [AKurz]);  // 'BCStartForm:Warte bis (%s)=nil'
          TicksReset(T1);
        end;
        GNavigator.ProcessMessages;
        if TicksDelayed(T2) > 3000 then
          break;                         //24.03.08 und 14.01.02
      end;
    end;
    GNavigator.StartFormIndex(IStart);
  end;
end;

procedure TDBQBENav.BCIniDb(var Message: TMessage);
begin
  if Message.WParam = idProt then
  begin
    if IniDb <> nil then
      IniDb.ProtThreadSafe;
  end;
end;

procedure TDBQBENav.BCGNavClick(var Message: TMessage); {message BC_GNAVCLICK}
var
  MsgStr: PChar;
begin
  if Message.WParam = gnOpen then
  begin
    if (DataSource <> nil) and (DataSource.DataSet <> nil) and (NavLink <> nil) then
    begin
      DataSource.DataSet.Open;
      if NavLink.DataPos.Count > 0 then
        NavLink.DataPos.GotoPos(DataSource.DataSet);
    end;
  end else
  if Message.WParam = gnEditingChanged then
  begin
    EditingChanged;
  end else
  if Message.WParam = gnProtA then
  begin
    MsgStr := PChar(Message.LParam);
    ProtA('%s', [MsgStr]);
    StrDispose(MsgStr);
  end else
    BtnClick(TQbeNavigateBtn(Message.WParam));
end;

procedure TDBQBENav.SetVisible(Value: TQbeButtonSet);
var
  I: TQbeNavigateBtn;
  W, H: Integer;
begin
  W := Width;
  H := Height;
  FVisibleButtons := Value;
  for I := Low(Buttons) to High(Buttons) do
    Buttons[I].Visible := I in FVisibleButtons;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  Invalidate;
end;

function TDBQBENav.SpaceFollows(I: TQbeNavigateBtn): boolean;
begin
  if I in [qnbQuery,qnbLast,qnbEdit] then
    result := true else
  if (I = qnbNext) and not (qnbLast in FVisibleButtons) then
    result := true else
    result := false;
end;

procedure TDBQBENav.AdjustSize (var W: Integer; var H: Integer);
var
  Count: Integer;
  MinW: Integer;
  I: TQbeNavigateBtn;
  //LastBtn: TQbeNavigateBtn;
  RemSpace, Temp, Remain: Integer;
  X: Integer;
  Spaces: Integer;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[qnbFirst] = nil then Exit;
  Spaces := 0;
  Count := 0;
  //LastBtn := High(Buttons);
  for I := Low(Buttons) to High(Buttons) do
  begin
    if Buttons[I].Visible then
    begin
      Inc(Count);
      //LastBtn := I;
      if SpaceFollows(I) then
        Inc( Spaces, Space);
    end;
  end;
  if Count = 0 then Inc(Count);

  MinW := Count * (MinBtnSize.X - 1) + 1 + Spaces;
  if W < MinW then
    W := MinW;
  if H < MinBtnSize.Y then
    H := MinBtnSize.Y;

  ButtonWidth := ((W - 1 - Spaces) div Count) + 1;
  Temp := Count * (ButtonWidth - 1) + 1 + Spaces;
  if Align = alNone then
    W := Temp;

  X := 0;
  Remain := W - Temp;
  Temp := Count div 2;
  for I := Low(Buttons) to High(Buttons) do
  begin
    if Buttons[I].Visible then
    begin
      RemSpace := 0;
      if Remain <> 0 then
      begin
        Dec (Temp, Remain);
        if Temp < 0 then
        begin
          Inc (Temp, Count);
          RemSpace := 1;
        end;
      end;
      Buttons[I].SetBounds (X, 0, ButtonWidth + RemSpace, Height);
      Inc (X, ButtonWidth - 1 + RemSpace);
      if SpaceFollows(I) then
        X := X + Space;
      //LastBtn := I;
    end
    else
      Buttons[I].SetBounds (Width + 1, 0, ButtonWidth, Height);
  end;
end;

procedure TDBQBENav.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TDBQBENav.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;

  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds(Left, Top, W, H);
  Message.Result := 0;
end;

procedure TDBQBENav.Click(Sender: TObject);
{Gemeinsame Clickbearbeitungsroutine}
begin
  BtnClick (TNavButton (Sender).Index);
end;

procedure TDBQBENav.BtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldFocus: TQbeNavigateBtn;
begin
  OldFocus := FocusedButton;
  FocusedButton := TNavButton (Sender).Index;
  if TabStop and (GetFocus <> Handle) and CanFocus then
  begin
    SetFocus;
    if (GetFocus <> Handle) then
      Exit;
  end
  else if TabStop and (GetFocus = Handle) and (OldFocus <> FocusedButton) then
  begin
    Buttons[OldFocus].Invalidate;
    Buttons[FocusedButton].Invalidate;
  end;
end;

procedure TDBQBENav.BtnClick(Index: TQbeNavigateBtn);
{Eigentliche Bearbeitung von Clik-Ereignissen}
var
  DoIt, DoMark: boolean;
  AForm: TqForm;
  ALNav: TLNavigator;
  StrgDown, IsQuery: boolean;
begin
  if not InBtnClick and {(DataSource <> nil) and}
     Buttons[Index].Enabled then                        {230400 ISA.POSI.RECH}
  try
    try
      InBtnClick := true;
      case Index of

        qnbQuery: begin {Suchen}
          //if (DataSource <> nil) and (DataSource.State = dsBrowse) then  20.08.08
          if (DataSource <> nil) and (Navlink.nlState in [nlBrowse, nlInactive]) then
          begin
            Screen.Cursor := crHourGlass;
            if Navlink.nlState = nlBrowse then
              TqForm(NavLink.Form).BroadcastMessage(DataSource, TMultiGrid,
                BC_MULTIGRID, mgSaveSelectedField);
            NavLink.DoQuery;  //QueryActivate
          end else
            ErrWarn(SQNav_Kmp_015,[0]);		// 'Suche kann hier nicht gestartet werden'
        end;

        qnbPrior, qnbNext, qnbFirst, qnbLast:
          if (DataSource <> nil) and (DataSource.State <> dsInactive) then
            NavLink.DoNavigate( Index);

        qnbReadOnly:
          if (DataSource <> nil) and (DataSource.DataSet <> nil) then
          begin
            if Sysparam.AugeAutoEdit then
            begin
              DataSource.AutoEdit := not DataSource.AutoEdit;    {q}
              if not (reUpdate in NavLink.TabellenRechte) and
                 DataSource.AutoEdit then
              begin
                ErrWarn(SQNav_Kmp_016,[NavLink.Kennung]);	// 'Sie haben keine Rechte zum Ändern (%s)'
                DataSource.AutoEdit := false;
              end;
            end else
            begin
              NavLink.LiveRequest := not NavLink.LiveRequest;
              {if DataSource.DataSet is TuQuery then
                TuQuery(DataSource.DataSet).RequestLive := not TuQuery(DataSource.DataSet).RequestLive
              else if DataSource.DataSet is TuTable then
                TuTable(DataSource.DataSet).ReadOnly := not TuTable(DataSource.DataSet).ReadOnly;}
            end;
          end;

        qnbInsert:
          if (DataSource <> nil) and (DataSource.State <> dsInactive) then
          begin
            NavLink.DoInsert(true);	// 'Sie haben keine Rechte zum Erfassen (%s)'
          end;

        qnbEdit:
          if (DataSource <> nil) and (DataSource.State <> dsInactive) then
          begin
            if not Buttons[qnbInsert].Enabled and (DataSource.DataSet <> nil)
               and DataSource.DataSet.BOF and DataSource.DataSet.EOF then
            begin
              //beware Exit;  //kein Erfassen über den Ändern-Button
              Buttons[Index].Down := false;
              Sysutils.Abort;  //muss bei finally landen
            end;
            NavLink.DoEdit(true);	// 'Sie haben keine Rechte zum Ändern (%s)'
          end;

        qnbDelete:
          if (DataSource <> nil) and (DataSource.State <> dsInactive) then
          begin
            if dsQuery or dsChangeAll then                   {wenn im Suchmodus}
            begin
              if QBETable <> nil then
              begin
                QBETable.ClearFields;
                SMess(SQNav_Kmp_018, [0]);	// 'Suchkriterien wurden gelöscht'
              end;
            end else
            if reDelete in NavLink.TabellenRechte then
            begin
              if (NavLink.DBGrid <> nil) and
                 (NavLink.DBGrid.SelectedRows.Count > 0) then
              begin
                DoIt := false;
                DoMark := NavLink.DoMsgFmt(mtWMessConfirmation, MSG_CONFIRMDELMARKED,
                          SQNav_Kmp_019,	// 'Wollen Sie alle markierten Datensätze löschen ?',
                          [0]) = mrYes;
              end else
              begin
                DoMark := false;
                {if NavLink.ConfirmDelete then
                  DoIt := NavLink.DoMsgFmt(mtWMessConfirmation, MSG_CONFIRMDELETE,
                      SDeleteRecordQuestion + CRLF + '(%s)',
                      [NavLink.Display]) = mrYes else}
                if NavLink.ConfirmDelete then
                  DoIt := NavLink.DeleteRecordConfirmed else  //Datensatz löschen?
                  DoIt := true;
              end;
              if DoIt then
                NavLink.DoDelete else
              if DoMark then
                NavLink.DoDeleteMarked(false);
            end else
              ErrWarn(SQNav_Kmp_020,[NavLink.Kennung]);	// 'Sie haben keine Rechte zum Löschen (%s)'
          end;

        qnbCancel:
          begin
            if GNavigator <> nil then
            begin
               GMess0;  {Gauge weg  22.09.02}
               GNavigator.Canceled := true; {Abbruch}
            end;
            if dsQuery or dsChangeAll then
            begin
              QueryCancel;
            end else {if DataSource.State <> dsInactive then     weg 261198 roe}
            if DataSource <> nil then
            begin
              if (DataSource.DataSet.State = dsBrowse) and
                 (DataSource is TLookUpDef) and
                 (TLookUpDef(DataSource).MasterSource <> nil) then
              begin                                {Aktiven Datasource wechseln}
                AForm := TqForm(NavLink.Form);              {(Owner as TqForm)?}
                ALNav := AForm.GetLNav;               {vergl. TMultiGrid.DoExit}
                if (AForm.ActiveControl <> ALNav.FirstControl) and
                   (ALNav.nlState in nlEditStates) then
                begin
                  AForm.ActiveControl := ALNav.FirstControl; {Detail-Multi verlassen}
                  PostMessage(self.Handle, BC_GNAVCLICK, WPARAM(qnbCancel), 0);
                end;
              end else
                NavLink.DoCancel;
            end;
          end;

        qnbPost:
          if (DataSource <> nil) and (DataSource.State <> dsInactive) then
          begin
            Screen.Cursor := crHourGlass;
            if dsQuery then {im Suchmodus}
            begin
              QueryAccepted;
            end else
            if dsChangeAll then {im Changeallmodus}
            begin
              ChangeAllAccepted;
            end else
            begin
              if (DataSource.DataSet.State = dsBrowse) and
                 (DataSource is TLookUpDef) and
                 (TLookUpDef(DataSource).MasterSource <> nil) then
              begin                                {Aktiven Datasource wechseln}
                AForm := TqForm(NavLink.Form);              {(Owner as TqForm)?}
                ALNav := AForm.GetLNav;               {vergl. TMultiGrid.DoExit}
                //AForm.ActiveControl := ALNav.FirstControl; {Detail-Multi verlassen} wirft Exc!
                ForceFocus(ALNav.FirstControl); {Detail-Multi verlassen - 28.11.08}
                if ALNav.nlState in nlEditStates then
                begin
                  //von Lookupdef nach LNav wechseln und LNav commiten - 03.06.08
                  GNavigator.SetLink(AForm, ALNav.NavLink, ALNav.NavLink.ActiveSource); {Checkt Color}
                  PostMessage(self.Handle, BC_GNAVCLICK, WPARAM(qnbPost), 0);
                end;
              end else
                NavLink.DoPost(True);           {Commit;}
            end;
          end;

        qnbRefresh: begin
          Screen.Cursor := crHourGlass;
          (* 170101 entfernt, das Cache Werte fehlen BahnDispo
          NavLink.CalcCacheList.ClearObjects;       {Caches der Feldwerte löschen}
          *)
          if (DataSource <> nil) and (DataSource.DataSet <> nil) then
          begin
            StrgDown := (GetKeyState(VK_CONTROL) and $FFFE) <> 0;
            IsQuery := DataSource.DataSet is TuQuery;
            if not IsQuery and not StrgDown then
            try {bei TuQuery erzeugt dies den Fehler: Tabelle ist nicht eindeutig indiziert}
              DataSource.DataSet.Refresh;
            except
              IsQuery := true;
            end;
            if IsQuery then
            begin
              NavLink.DataPos.Clear;
              if StrgDown then        {Strg gedrückt -> mit Positionieren}
                NavLink.DataPos.AddFieldsValue(DataSource.DataSet,
                  NavLink.PrimaryKeyFields);
              DataSource.DataSet.Close;
              PostMessage(self.Handle, BC_GNAVCLICK, gnOpen, 0);
            end;
          end;
        end;
      end;
    except
      on E:EAccessViolation do
      begin
        //HandleNeeded
      end;
      on E:Exception do
      begin
        if DataSource <> nil then // 'Fehler bei %s'
          EMess(DataSource.DataSet, E, SQNav_Kmp_021, [Buttons[Index].Hint]) else
          EMess(self, E, SQNav_Kmp_021, [Buttons[Index].Hint]);
        Sysutils.Abort;
      end;
    end;
  finally
    {if GNavigator <> nil then
      GNavigator.ProcessMessages;   {warten bis angezeigt}
    InBtnClick := false;
    Screen.Cursor := crDefault;
  end else
    Buttons[Index].Down := false;
  if not (csDesigning in ComponentState) and Assigned(FOnNavClick) then
    FOnNavClick(Self, Index);
  EditingChanged;
//Y  if GNavigator <> nil then
//    GNavigator.ProcessMessages;   {warten bis angezeigt}
end;

procedure TDBQBENav.WMSetFocus(var Message: TWMSetFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TDBQBENav.WMKillFocus(var Message: TWMKillFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TDBQBENav.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewFocus: TQbeNavigateBtn;
  OldFocus: TQbeNavigateBtn;
begin
  OldFocus := FocusedButton;
  case Key of
    VK_RIGHT:
      begin
        NewFocus := FocusedButton;
        repeat
          if NewFocus < High(Buttons) then
            NewFocus := Succ(NewFocus);
        until (NewFocus = High(Buttons)) or (Buttons[NewFocus].Visible);
        if NewFocus <> FocusedButton then
        begin
          FocusedButton := NewFocus;
          Buttons[OldFocus].Invalidate;
          Buttons[FocusedButton].Invalidate;
        end;
      end;
    VK_LEFT:
      begin
        NewFocus := FocusedButton;
        repeat
          if NewFocus > Low(Buttons) then
            NewFocus := Pred(NewFocus);
        until (NewFocus = Low(Buttons)) or (Buttons[NewFocus].Visible);
        if NewFocus <> FocusedButton then
        begin
          FocusedButton := NewFocus;
          Buttons[OldFocus].Invalidate;
          Buttons[FocusedButton].Invalidate;
        end;
      end;
    VK_SPACE:
      begin
        if Buttons[FocusedButton].Enabled then
          Buttons[FocusedButton].Click;
      end;
  end;
end;

procedure TDBQBENav.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

(*** Buttons Status ****************************************************)

procedure TDBQBENav.DataChanged;
{über DataLink auf aktuelles DataSource
  steuert den Zustand der Buttons}
var
  Bof, Eof, UpEnable, DnEnable: Boolean;
  I: TQbeNavigateBtn;
begin
  Bof := (FDataLink.DataSet = nil) or FDataLink.DataSet.BOF;
  Eof := (FDataLink.DataSet = nil) or FDataLink.DataSet.EOF;
  UpEnable := Enabled and FDataLink.Active and not BOF;
  DnEnable := Enabled and FDataLink.Active and not EOF;
  {Buttons[qnbQuery].Enabled:= not FDataLink.Editing and FDataLink.Active;
  Buttons[qnbReadOnly].Enabled:= not FDataLink.Editing and FDataLink.Active;}
  Buttons[qnbFirst].Enabled := UpEnable and not FDataLink.Editing;
  Buttons[qnbPrior].Enabled := UpEnable and not FDataLink.Editing;
  Buttons[qnbNext].Enabled := DnEnable and not FDataLink.Editing;
  Buttons[qnbLast].Enabled := DnEnable and not FDataLink.Editing;
  {Buttons[qnbDelete].Enabled := Enabled and FDataLink.Active and
    FDataLink.DataSet.CanModify and
    not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF) and
    not FDataLink.Editing;}
  for I := Low(Buttons) to High(Buttons) do
  begin
    if (FNavLink <> nil) and (I in [qnbFirst,qnbPrior,qnbNext,qnbLast]) then
    begin
      Buttons[I].Enabled := (Buttons[I].Enabled and not (I in FNavLink.DisabledButtons)) or
                            (I in FNavLink.EnabledButtons);
    end;
    if (FNavLink <> nil) and (NavLink.ButtonHints.Values[IntToStr(ord(I))] <> '') then
      Buttons[I].Hint := NavLink.ButtonHints.Values[IntToStr(ord(I))] else
      Buttons[I].Hint := ButtonHints[I];
  end;
end;

procedure TDBQBENav.EditingChanged;
{über DataLink auf aktuelles DataSource
  steuert den Zustand der Buttons}
var
  CanModify, IsActive, IsEditing, MasterEditing: Boolean;
  IsEmpty: boolean;
  Ins, Ed, Qu, RO, RL: boolean;
  OurSource: TDataSource;
  DisabledButtons: TQbeButtonSet;    {QBE Buttons manuell deaktivieren}
  EnabledButtons: TQbeButtonSet;     {QBE Buttons manuell aktivieren}
  OldNPM: boolean;
  I: TQbeNavigateBtn;
  Hints: TStrings;
begin
  OldNPM := GNavigator.NoProcessMessages;
  try
    GNavigator.NoProcessMessages := true;    {für GNavigator.Canceled ! 060400}
    RL := false;
    IsActive := FDataLink.Active;
    if (FNavLink <> nil) and
       (NavLink.DataSource <> nil) and (EditSource <> NavLink.DataSource) and
       not dsQuery and not dsChangeAll then
    begin
      CanModify := true;
      IsEditing := EditSource.State in [dsEdit,dsInsert];
      OurSource := EditSource;
    end else
    begin
      CanModify := Enabled and IsActive and (FDataLink.DataSet <> nil) and
                   FDataLink.DataSet.CanModify;
      IsEditing := FDataLink.Editing;
      OurSource := DataSource;
    end;
    MasterEditing := (FNavLink <> nil) and (FNavLink.MasterSource <> nil) and
                     (FNavLink.MasterSource.State in [dsEdit,dsInsert]);
    if FNavLink <> nil then
    begin
      DisabledButtons := FNavLink.DisabledButtons;
      EnabledButtons := FNavLink.EnabledButtons;
      Hints := FNavLink.ButtonHints;
    end else
    begin
      DisabledButtons := [];
      EnabledButtons := [];
      Hints := nil;
    end;
    if IsActive then
    begin
      Qu := dsQuery or dsChangeAll;
      Ins := (not Qu) and (OurSource <> nil) and (OurSource.State = dsInsert);
      Ed := (OurSource <> nil) and (OurSource.State = dsEdit);
      RO := ((OurSource = nil) or not OurSource.AutoEdit) and not Ed and not Ins and CanModify;
      RL := (FNavLink <> nil) and FNavLink.LiveRequest;
      {RL := (DataSource.DataSet <> nil) and
            (((DataSource.DataSet is TuQuery) and TuQuery(DataSource.DataSet).RequestLive) or
             ((DataSource.DataSet is TuTable) and not TuTable(DataSource.DataSet).ReadOnly));}
      IsEmpty := (OurSource = nil) or (OurSource.DataSet = nil) or
                 (OurSource.DataSet.BOF and OurSource.DataSet.EOF);
    end else
    begin
      Qu := false; Ins := false; Ed := false; RO := false; IsEmpty := true;
    end;
    Buttons[qnbInsert].Enabled := Ins or (CanModify and not IsEditing);
    Buttons[qnbEdit].Enabled := Ed or (CanModify and not IsEditing and not IsEmpty);
    Buttons[qnbPost].Enabled := (CanModify and IsEditing) or MasterEditing;
    Buttons[qnbCancel].Enabled := not GNavigator.Canceled or              {140699}
      (DataSource <> nil);  {030399} {IsActive; {CanModify and IsEditing;} {240997}
    Buttons[qnbRefresh].Enabled := {CanModify and} not IsEditing;   {240997}
    Buttons[qnbQuery].Enabled := (not IsEditing and not dsQuery and not dsChangeAll) and
                                 (FNavLink <> nil) and (FNavLink.DataSource <> nil);
    if Sysparam.AugeAutoEdit then
      Buttons[qnbReadOnly].Enabled := IsActive else
      Buttons[qnbReadOnly].Enabled := (FNavLink <> nil) and not (Ed or Ins or Qu);
    Buttons[qnbDelete].Enabled := (CanModify and not IsEditing and
      (FDataLink.DataSet <> nil) and
      not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF)) or Qu;

    for I := Low(Buttons) to High(Buttons) do
    begin
      Buttons[I].Enabled := (Buttons[I].Enabled and not ((I in DisabledButtons) and
                             not dsQuery and not dsChangeAll)) or
                            (I in EnabledButtons);
      if (Hints <> nil) and (Hints.Values[IntToStr(ord(I))] <> '') then
        Buttons[I].Hint := Hints.Values[IntToStr(ord(I))] else
        Buttons[I].Hint := ButtonHints[I];
    end;
    if IsActive then
    begin
      {Buttons[qnbInsert].Down := not Ins;          {so ein Quatsch muß sein }
      Buttons[qnbEdit].Down := not Ed;             {damit Button wirklich   }
      Buttons[qnbQuery].Down := not Qu;            {gedrückt ist !          }
      if Sysparam.AugeAutoEdit then
        Buttons[qnbReadOnly].Down := not RO else   {                        }
        Buttons[qnbReadOnly].Down := RL;           {                        }
      {Buttons[qnbInsert].Down := Ins;    kann während Insert gedrückt werden}
      Buttons[qnbInsert].Down := false;

      Buttons[qnbEdit].Down := Ed;
      Buttons[qnbQuery].Down := Qu;
      if Sysparam.AugeAutoEdit then
        Buttons[qnbReadOnly].Down := RO else
        Buttons[qnbReadOnly].Down := not RL;
      Buttons[qnbDelete].Down := false;
    end;
  finally
    GNavigator.NoProcessMessages := OldNPM;
  end;
  {GNavigator.Smess('Ins:%d Ed:%d Qu:%d RO:%d', [ord(Ins),ord(Ed),ord(Qu),ord(RO)]);}
  {[ord(Buttons[qnbInsert].Down),
    ord(Buttons[qnbEdit].Down),ord(Buttons[qnbQuery].Down),ord(Buttons[qnbReadOnly].Down)]);}
end;

procedure TDBQBENav.ActiveChanged;
var
  I: TQbeNavigateBtn;
begin
  if not (Enabled and FDataLink.Active) then
  begin
    for I := Low(Buttons) to High(Buttons) do
      Buttons[I].Enabled := False
  end; { else}
  begin
    DataChanged;
    EditingChanged;
  end;
end;

procedure TDBQBENav.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    ActiveChanged;
end;

procedure TDBQBENav.SetDataSource(Value: TDataSource);
begin
  if FDataLink <> nil then
  begin
    FDataLink.DataSource := Value;
    if not (csLoading in ComponentState) then
      ActiveChanged;
  end;
end;

function TDBQBENav.GetDataSource: TDataSource;
begin
  if FDataLink <> nil then
    Result := FDataLink.DataSource else
    Result := nil;
end;

procedure TDBQBENav.Loaded;
var
  W, H: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  InitHints;
  if not (csDesigning in ComponentState) then
    ActiveChanged;
end;

(*** Query durchführen ***************************************************)

procedure TDBQBENav.QueryBeforePost(ADataSet: TDataSet);
(* kein autocommit *)
begin
  if not (csDesigning in ComponentState) and
     not InQueryAccepted then
  begin
    {ErrWarn('Suche bitte abschließen',[0]);}
    PostMessage( GNavigator.X.Handle, BC_GNAVCLICK, WPARAM(qnbPost), 0);
    SysUtils.Abort;
  end;
end;

procedure TDBQBENav.SetFltr(AFltrList: TFltrList);
var
  I: Integer;
  AField: TField;
begin
  for I := 0 to AFltrList.Count - 1 do              {Werte von FilterList holen}
  begin
    AField := QBETable.FindField(OnlyFieldName(AFltrList.Param(I)));
    if AField <> nil then                               {Entsprechung existiert}
      if AField.Tag > 0 then                                 {bei Auswahlfelder}
        AField.AsString := AFltrList.Value(I) else
        SetFieldText(AField, AFltrList.Value(I));             {Value schreiben}
  end;
end;

procedure TDBQBENav.CopyFltr(AFltrList: TFltrList);
var
  I: Integer;
  AField: TField;
begin
  for I := 0 to QBETable.FieldCount - 1 do
  try
    AField := QBETable.Fields[I];
    if not IsCalcField(AField) then                             {kein CalcField}
      if AField.Tag > 0 then                                 {bei Auswahlfelder}
        AField.AsString := AFltrList.Values[AField.FieldName] else
        SetFieldComp(AField, AFltrList.Values[AField.FieldName]);   //SetFieldText bringt Fehler weil Calcfields nicht erkannt werden
  except on E:Exception do
    EProt(QBETable, E, 'CopyFltr', [0]);
  end;
end;

procedure TDBQBENav.QueryActivate(Modus: TQueryModus);
var
  ColumnName: String;
  I, L: Integer;
  AField: TField;
begin
  SMess(SQNav_Kmp_022,[0]);	// 'Suchen'
  QBESaveDataSet:= DataSource.DataSet as TuQuery; {TuQuery zwischenspeichern}
  dsQuery := Modus = qmQuery;
  dsChangeAll := Modus = qmChangeAll;
  try
    // DataSource.DataSet.DisableControls;  bringtnix
    // DataSource.Enabled := false;  //schlecht:Readonly bleibt. Gut für Eingabelänge der TDBEdits - 23.04.09
    GMess( 10);
    NavLink.SetEnable( false, true); {Sekundärtabellen schliesen}
    GMess( 20);
    if QBETable = nil then                              {QBETable in memory}
    begin
      QBETable := TuMemTable.Create(NavLink.Owner); {Anlegen}
      //beware QBETable.DataBaseName := '';
      //beware QBETable.TableName := QBETableName;
      GMess( 25); {Fortschrittanzeige}
      with DataSource.DataSet do
      begin
        //L := IMin(200, 16000 div FieldCount);   //Max. Gesamtgröße des MemTable Datenpuffers
        //03.09.12 Unidac: keine Beschränkung:
        L := 255;
        for I:=0 to FieldCount - 1 do
        begin
          ColumnName:=Fields[I].FieldName;
          if IsCalcField(Fields[I]) then
          begin
            { TODO : if Query.Unicode then ftWideString }
            QBETable.AddField(ColumnName, ftString, 1, False);   {100}
            {als Stringtyp länge 100 keine Calcfields -> 64}
          end else
            QBETable.AddField(ColumnName, ftString, L, False); {250}
        end
      end;
      GMess( 30);
      //UNI: nicht benötigt - QBETable.CreateTable; {Tabelle anlegen}
      //UNI: klären - QBETable.ReadOnly:=False;
      //QBETable.DisableControls; bringt nix
      GMess( 35);
      DataSource.DataSet := QBETable; {DataSet austauschen}
      with QBESaveDataSet do {mit dem echten DataSet}
      begin
        for I:=0 to FieldCount - 1 do
        begin
          AField := QBETable.FieldDefs.Items[i].CreateField( QBETable);
          {mit FieldDef Felder anlegen}
          AField.Name := 'QBETable' + StrToValidIdent( Fields[i].FieldName);
          {prota('%d(%s)%d',[i,Fields[I].FieldName,Fields[I].FieldNo]);}
          AField.Visible := Fields[I].Visible;
          if Fields[I].FieldNo < 0 then  {bei Calc-Fields}
          begin
            AField.ReadOnly := true;           {AField.Calculated := True;}
          end else
            AField.ReadOnly := false;  {sonst für Eingabe bereit}
          if Fields[I].Tag > 0 then {bei Auswahlfelder}
          begin
            AField.Tag := Fields[I].Tag;
            AField.OnGetText := NavLink.FieldOnGetText; {Field wird als Sender an FieldOnGetText übermittelt}
            AField.OnSetText := NavLink.FieldOnSetText; {Erkennung der Auswahl über die Eigenschft Tag}
          end;
          {if Fields[I] is TStringField then    (Großschrift beim Suchen ?)
            (AField as TStringField).EditMask := (Fields[I] as TStringField).EditMask;}
          if Fields[I].Visible then                           {wichtig für Grid}
          begin
            AField.DisplayWidth := Fields[I].DisplayWidth;      {zeitaufwendig!}
            AField.DisplayLabel := Fields[I].DisplayLabel;
            GMess( 30 + ((I * 30) div FieldCount));                      {Gauge}
          end;
            //AField.DisplayWidth := 250;
        end
      end;
      GMess( 70);
      QBETable.Open;
      GMess( 80);
      QBETable.Insert;                                   {und ab in Insertmodus}
    end else                              {Tabelle in Memory ist schon angelegt}
    begin
      GMess( 41);
      TqForm(NavLink.Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID,
        mgColDefChanged);         {geänderte Tabellenspalten übernehmen}
      DataSource.DataSet := QBETable;
      QBETable.Open;
      QBETable.Edit;
      QBETable.ClearFields; {Felder löschen}
    end;
    //23.04.09 bringtnix TDummyDataSet(QBETable).DataEvent(deRecordChange, 0);  //wg TDBEdit.MaxSize
    //23.03.09 beware: öffnet bei QBETable.Open alle Sekundärtabellen !
    // NavLink.SetEnable(false, true); {Sekundärtabellen schliesen - erst jetzt wg cob.readonly}
    if dsQuery then
    begin
      SetFltr(FltrList);                                    {FltrList -> QBETable}
    end;
    QBETable.BeforePost := QueryBeforePost;
    if NavLink.Form is TqForm then
    begin
      TqForm(NavLink.Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID,
        mgLoadSelectedField);
      TqForm(NavLink.Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID,
        mgSetRecCount);
    end;
  except
    on E:Exception do
    begin
      dsQuery := False;
      dsChangeAll := False;
      EMess(QBETable, E, SQNav_Kmp_023, [0]);	// 'Kann Suchtabelle nicht öffnen'
      try
        DataSource.DataSet:= QBESaveDataSet;
        DataSource.DataSet.Cancel;
        DataSource.DataSet.Open;
        {DataSource.DataSet.EnableControls;}
        NavLink.SetEnable( true, true);
      except
        on E:Exception do ErrException( self, E);
      end;
    end;
  end;
  //DataSource.DataSet.EnableControls;  s.o.
  //DataSource.Enabled := true;  s.o.

  SMess('',[0]);
  GMess( 0);
end;

procedure TDBQBENav.QueryCancel;
begin
  if not (csDestroying in ComponentState) then
  begin
    //dsQuery := False;
    dsChangeAll := false;
    SMess('',[0]);
    DataSource.Enabled := false;
    try
      DataSource.DataSet := QBESaveDataSet;
      dsQuery := False;
      NavLink.SetEnable( true, true);
      DataSource.DataSet.Cancel;
      DataSource.DataSet.Open;
      QBETable.Cancel;
      {QBETable.Free;}
    except
      on E:Exception do ErrWarn('QueryCancel:%s', [E.Message]);
    end;
    DataSource.Enabled := true;
  end;
end;

procedure TDBQBENav.QueryAccepted;
{Suche starten}
var
  I: Integer;
  ErrField: TField;
  ErrFieldName: string;
  {ALNav: TLNavigator;}
  SqlResult: boolean;
  Btn: word;
  OldUseFltrList: boolean;
  Gefiltert: boolean;
begin
  {ALNav := GNavigator.LNavigator;}
  SMess(SQNav_Kmp_024,[0]);	// 'Laden'
  TqForm(NavLink.Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID,
    mgSaveSelectedField);
  InQueryAccepted := true;
  try
    QBETable.Post;                                                 {InMem Table}
  finally
    InQueryAccepted := false;
  end;
  FltrList.Clear; {alles löschen}
  Gefiltert := false;
  for I:=0 to QBETable.FieldCount - 1 do {über in memory DataSet}
  begin
    with QBETable.Fields[I] do
    begin
      if not IsNull then                  {FltrList um akt.Feldinhalt erweitern}
      begin
        FltrList.SetFltrField(QBETable.Fields[I]);
        Gefiltert := true;
      end;
    end;
  end;
  OldUseFltrList := NavLink.UseFltrList;
  try
    {DataSource.Enabled := false;}
    NavLink.UseFltrList := true;    {Sql auch bei LuDef mit FltrList aufbauen}
    DataSource.DataSet := QBESaveDataSet;             {restaurieren von DataSet}
    if NavLink.Owner is TLNavigator then
    begin                      {InsertFlag: PKey-Filter in References löschen}
      TLNavigator(NavLink.Owner).DetailInsert(diClear);       {diClear 100600}
      if Gefiltert then
        TLNavigator(NavLink.Owner).SubCaption := SQNav_Kmp_029 else // 'gefiltert'
        TLNavigator(NavLink.Owner).SubCaption := '';        //23.10.06 QUPP.HPGEBI
    end;
    SqlResult := NavLink.BuildSql;                             {SQL-Aufbauen }
    ErrFieldName := NavLink.ErrorFieldName;           {Fehlerbeschreibung holen}
    if not SqlResult then                                       {nicht alles OK}
    begin
      DataSource.DataSet := QBETable;
      ErrField := QBESaveDataSet.FindField( ErrFieldName);   {Fehlerfeld finden}
      if ErrField <> nil then
        ErrField.FocusControl;                                   {Positionieren}
      QBETable.Edit; {Suchen geht weiter}
      {in buildsql
       ErrWarn('Fehler bei Schreibweise (%s...) in (%s)',
       [FltrList.Value(0),ErrFieldName]);}
    end else  {kein SQL Fehler}
    begin
      dsQuery:=False; {nicht mehr imSuchmodus}
      dsChangeAll := False; {nicht mehr im Changeallmodus}
      QBETable.Cancel;
      try
        {DataSource.DataSet:=QBESaveDataSet;}
        GMess( 50);
        QBESaveDataSet.Close;           {warum:für prepare?  damit öffnet!}
        GMess( 60);
        GMess( 65);
        Prot0('Suche: %s', [QueryText(QBESaveDataSet, qtoShort)]);  //ProtStrings(QBESaveDataSet.SQL);
        QBESaveDataSet.Open;            {Browse und Laden}
        GMess( 70);
        NavLink.SetEnable( true, true);               {nach Open wg. Param Types}
        if DataSource.DataSet.BOF and DataSource.DataSet.EOF then
        begin
          Btn := MessageDlg(SQNav_Kmp_025 + CRLF +				// 'Keine Daten gefunden'
                            SQNav_Kmp_026, mtWarning, mbYesNoCancel, HI_104);	// 'Nochmal Suchen ?'
          Prot0(SQNav_Kmp_027,[QueryText(QBESaveDataSet, [qtoOneLine])]);	// 'Keine Daten gefunden (%s)'
          if Btn = mrYes then
          begin
            QueryActivate(qmQuery);  //Suchmodus aktivieren
          end;
        end else
        begin
          GMess( 80);
          //Delphi Bug: verliert Scrollbar in MuGrid:
          TqForm(NavLink.Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID,
            mgForceScrollBar);
          GMess( 90);
        end;
      except
        on E:Exception do
        begin
          EMess(QBESaveDataSet, E, SQNav_Kmp_028, [NavLink.Display]);	// 'Fehler beim Öffnen von %s'
          //DataSource.DataSet := QBESaveDataSet;  weg 09.02.05
          QueryActivate(qmQuery);  
        end;
      end;
    end;
  finally
    {DataSource.Enabled := true;}
    NavLink.UseFltrList := OldUseFltrList;
  end;
  GMess( 0);
  SMess('',[0]);
end;

procedure TDBQBENav.ChangeAllAccepted;
{Änderungen durchführen}
var
  I: Integer;
begin
  SMess(SQNav_Kmp_024,[0]);	// 'Laden'
  TqForm(NavLink.Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID,
    mgSaveSelectedField);
  InQueryAccepted := true;
  try
    QBETable.Post;                                                 {InMem Table}
  finally
    InQueryAccepted := false;
  end;
  NavLink.ChangeList.Clear; {alles löschen}
  for I:=0 to QBETable.FieldCount - 1 do {über in memory DataSet}
  begin
    with QBETable.Fields[I] do
    begin
      if not IsNull then                  {FltrList um akt.Feldinhalt erweitern}
      begin
        NavLink.ChangeList.Values[QBETable.Fields[I].FieldName] :=
          GetFieldValue(QBETable.Fields[I]);

      end;
    end;
  end;
  DataSource.DataSet := QBESaveDataSet;             {restaurieren von DataSet}
  if NavLink.Owner is TLNavigator then
  begin                      {InsertFlag: PKey-Filter in References löschen}
    TLNavigator(NavLink.Owner).DetailInsert(diClear);       {diClear 100600}
  end;
  dsChangeAll := False; {nicht mehr im Changeallmodus}
  dsQuery:=False; {nicht mehr imSuchmodus}
  QBETable.Cancel;
  try
    NavLink.ChangeAll;
  except
    on E:Exception do
    begin
      EMess(QBESaveDataSet, E, SQNav_Kmp_028, [NavLink.Display]);	// 'Fehler beim Öffnen von %s'
      DataSource.DataSet := QBESaveDataSet;
      QueryActivate(qmChangeAll);
    end;
  end;
  GMess( 0);
  SMess('',[0]);
end;

(* TNavButton ***********************************************************)

destructor TNavButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited Destroy;
end;

procedure TNavButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);
  if nsAllowTimer in FNavStyle then
  begin
    if FRepeatTimer = nil then
      FRepeatTimer := TTimer.Create(Self);

    FRepeatTimer.OnTimer := TimerExpired;
    FRepeatTimer.Interval := InitRepeatPause;
    FRepeatTimer.Enabled  := True;
  end;
end;

procedure TNavButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;
end;

procedure TNavButton.TimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := RepeatPause;
  if (FState = bsDown) and MouseCapture then
  begin
    try
      Click;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

procedure TNavButton.Paint;
var
  R: TRect;
begin
  inherited Paint;
  if (GetFocus = Parent.Handle) and
     (FIndex = TDBQBENav (Parent).FocusedButton) then
  begin
    R := Bounds(0, 0, Width, Height);
    InflateRect(R, -3, -3);
    if FState = bsDown then
      OffsetRect(R, 1, 1);
    DrawFocusRect(Canvas.Handle, R);
  end;
end;

{ TQBEDataLink *********************************************************** }

constructor TQBEDataLink.Create(ANav: TDBQBENav);
begin
  inherited Create;
  FNavigator := ANav;
end;

destructor TQBEDataLink.Destroy;
begin
  FNavigator := nil;
  inherited Destroy;
end;

procedure TQBEDataLink.EditingChanged;
var
  NewSource: TDataSource;
  Done: boolean;
begin
  if (FNavigator <> nil) then
    with FNavigator do
    begin
      Done := false;
      if (EditSource <> NavLink.DataSource) and not dsQuery and not dsChangeAll then
      begin
        if Editing and not dsQuery and not dsChangeAll then
          NewSource := EditSource else
          NewSource := NavLink.DataSource;
        if DataSource <> NewSource then
        begin
          Done := true;
          FNavigator.DataSource := NewSource;
        end;
      end;
      if not Done then
      begin
        FNavigator.DataChanged;
        FNavigator.EditingChanged;
      end;
    end;
end;

procedure TQBEDataLink.DataSetChanged;
begin
  if FNavigator <> nil then
    FNavigator.DataChanged;
end;

procedure TQBEDataLink.ActiveChanged;
begin
  if FNavigator <> nil then
    FNavigator.ActiveChanged;
end;

end.





