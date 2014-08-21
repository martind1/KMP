unit Lubtnkmp;
(*             Lookup Button
   15.09.98    Lov Button
   28.01.98    PopupMenu
   17.01.01    LovFlags: Filter
   25.04.03    Click:lumZeigMask nur bei Browse, sonst lumTab (z.B. inactive. AUSU)
   06.07.04    Lov FltrList
   07.06.12    Typ geändert wg StdResize: TLookUpBtn.FLookUpEdit von TLookUpEdit nach TCustomEdit
   05.07.12    LovBtn DBEdit, readonly, für resizeStd
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, DB, StdCtrls,
  LuDefKmp, LuEdiKmp, DPos_Kmp,
  Lov__Dlg;  {TLovFlags}

type
  (* TLookUpBtn *)
  TLuBtnModus = (lubMulti,lubSingle);

  TLookUpBtn = class(TBitBtn)
  private
    { Private-Deklarationen }
    FLookUpDef: TLookUpDef;
    FModus: TLuBtnModus;
    FLookUpEdit: TCustomEdit;
    procedure SetLookUpEdit(Value: TCustomEdit);
    procedure PopupClick(Sender: TObject);
  protected
    { Protected-Deklarationen }
    procedure SetName(const Value: TComponentName); override;
    procedure Loaded; override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Click; override;
  published
    { Published-Deklarationen }
    property LookUpEdit: TCustomEdit read FLookUpEdit write SetLookUpEdit;
    property LookUpDef: TLookUpDef read FLookUpDef write FLookUpDef;
    property Modus: TLuBtnModus read FModus write FModus;
    property TabStop default false;
  end;


  (* TLovBtn *)
  TLovBtn = class(TBitBtn)
  private
    { Private-Deklarationen }
    FDataSource: TDataSource;
    FDataField: string;
    FFields: string;
    FLovFlags: TLovFlags;
    FFltrList: TFltrList;
    FValue: string;  //für afterclick
    FAfterClick: TNotifyEvent;
    procedure SetDataField(Value: string);
    procedure SetFltrList(const Value: TFltrList);
    function GetDBEdit: TCustomEdit;
  protected
    { Protected-Deklarationen }
    procedure SetName(const Value: TComponentName); override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Click; override;
    property Value: string read FValue write FValue;
    property DBEdit: TCustomEdit read GetDBEdit;
  published
    { Published-Deklarationen }
    property DataSource: TDataSource read FDataSource write FDataSource;
    property DataField: string read FDataField write SetDataField;
    property Fields: string read FFields write FFields;
    property FltrList: TFltrList read FFltrList write SetFltrList;
    property LovFlags: TLovFlags read FLovFlags write FLovFlags;
    property TabStop default false;
    property AfterClick: TNotifyEvent read FAfterClick write FAfterClick;
  end;


implementation
{$R *.RES}           (* Resource 'LUBTN' und 'LOVBTN' in LUBTNKMP.RES *)
uses
  Menus, DBCtrls,
  Prots, Qwf_Form, LNav_Kmp, NLnk_Kmp, Err__Kmp;

(* TLookUpBtn *)

procedure TLookUpBtn.SetLookUpEdit(Value: TCustomEdit);
begin
  FLookUpEdit := Value;
  if Value <> nil then
  begin
    if Value is TLookUpEdit then
      FLookUpDef := TLookUpEdit(Value).LookupSource else
    if Value is TLookUpMemo then
      FLookUpDef := TLookUpMemo(Value).LookupSource;
  end;
end;

constructor TLookUpBtn.Create( AOwner: TComponent);
begin
  inherited Create( AOwner);
  Glyph.Handle := LoadBitmap( HInstance, 'LUBTN');
  try
    NumGlyphs := IMax( 1, Glyph.Width div Glyph.Height);
  except
    NumGlyphs := 1;
  end;
  Width := 21;
  Height := 21;
  Caption := '';
  Modus := lubMulti;
  if not (csLoading in ComponentState) then
    TabStop := false;
end;

procedure TLookUpBtn.Loaded;
var
  PopupItem, NewItem: TMenuItem;
  I: integer;
  S1, NextS: string;
const
  Captions: array[0..8] of string = (
    'Lookup Tabelle',
    'Ändern in Fremdmaske',
    'Anzeigen in Fremdmaske',
    'Suchen in Fremdmaske',
    '',                        {lumReturn nicht implementiert}
    '',                        {lumDetailTab}
    '',                        {lumDirect nicht implementiert}
    'Erfassen in Fremdmaske',
    'Werteliste,I');
begin
  inherited Loaded;
  if (PopupMenu = nil) and not (csDesigning in ComponentState) then
  begin
    PopupMenu := TPopupMenu.Create(Owner);
    PopupItem := PopupMenu.Items;    {Erzeugen der Menüeinträge}
    //N := 0;
    for I := low(Captions) to high(Captions) do
    begin
      if Captions[I] = '' then
        continue;
      NewItem := TMenuItem.Create(PopupMenu);  {Erzeugen des neuen Menüeintrags}
      S1 := PStrTok(Captions[I], ',', NextS);
      NewItem.Caption := S1;              {Titelzeile für den neuen Menüeintrag}
      S1 := PStrTok('', ',', NextS);
      NewItem.Enabled := Pos('I', S1) <= 0;                         {I=Disabled}
      NewItem.Tag := I;                                          {Tag für Click}
      NewItem.OnClick := PopupClick;{OnClick Ereignis für den neuen Menüeintrag}
      PopupItem.Add(NewItem);                  {Einfügen des neuen Menüeintrags}
      //Inc(N);
    end;
  end;
end;

procedure TLookUpBtn.PopupClick(Sender: TObject);
var
  M: TLookUpModus;
begin
  M := TLookUpModus(TMenuItem(Sender).Tag);
  if M = lumErfassMsk then
    LookupDef.NavLink.DoInsert(true) else
    LookupDef.LookUp(TLookUpModus(TMenuItem(Sender).Tag));
end;

procedure TLookUpBtn.SetName(const Value: TComponentName);
begin
  inherited SetName(Value);
  if Caption = Value then
    Caption := '';
end;

procedure TLookUpBtn.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent = LookUpDef then
      LookUpDef := nil;
    if AComponent = LookUpEdit then
      LookUpEdit := nil;
  end;
  inherited Notification( AComponent, Operation);
end;

procedure TLookUpBtn.Click;
var
  ALNav: TLNavigator;
begin
  inherited Click;
  ALNav := FormGetLNav( Owner);
  if (ALNav <> nil) and (ALNav.DataSource <> nil) then
  begin
    try
      ALNav.DataSource.Edit;   {nur bei Autoedit und dsBrowse}
    except on E:Exception do   //kann passieren bei Readonly. Quva.Ausu
      EProt(self, E, 'Click:%s.Edit', [OwnerDotName(ALNav.DataSource)]);
    end;
    if FLookUpEdit <> nil then
      ALNav.SetActiveLookUpEdit(FLookUpEdit);
    ALNav.ActiveLookUpDef := FLookUpDef;
    if FLookUpDef <> nil then
    begin
      if Modus = lubSingle then {Eigenschaft eines Buttons}
      begin
        if ALNav.nlState in nlEditStates then
          ALNav.StartLookUp(lumAendMsk, LookUpDef) else
          ALNav.StartLookUp(lumZeigMsk, LookUpDef);
      end else  //lubMulti:
      if FLookUpDef.MDTyp = mdDetail then
      begin
        ALNav.StartLookUp(lumMasterTab, LookUpDef);   {Fremdtabelle mit Detailfilter}
      end else
      if ALNav.nlState = nlQuery then                 //von LNav - 21.12.02
      begin
        ALNav.StartLookUp(lumSuch, LookUpDef);
      end else
      if ALNav.nlState = nlBrowse then
      begin
        ALNav.StartLookUp(lumZeigMsk, LookUpDef);
      end else
        ALNav.StartLookUp(lumTab, LookUpDef);
      (*if ALNav.nlState in nlEditStates then
      begin
        ALNav.StartLookUp(lumTab, LookUpDef);   {Starte als Tabelle}
      end else
        ALNav.StartLookUp(lumZeigMsk, LookUpDef); {lumTab LookUpModus}*)
    end;
  end else
    ProtP('LookUpBtn:LNavigator fehlt (%s)',[Name]);
end;

(* TLovBtn *)

constructor TLovBtn.Create( AOwner: TComponent);
begin
  inherited Create( AOwner);
  FFltrList := TFltrList.create;
  Glyph.Handle := LoadBitmap( HInstance, 'LOBTN');
  try
    NumGlyphs := IMax( 1, Glyph.Width div Glyph.Height);
  except
    NumGlyphs := 1;
  end;
  Width := 21;
  Height := 21;
  Caption := '';
  if not (csLoading in ComponentState) then
    TabStop := false;
end;

destructor TLovBtn.Destroy;
begin
  FFltrList.Free;       FFltrList := nil;
  inherited;
end;

function TLovBtn.GetDBEdit: TCustomEdit;
//sucht dazugehöriges DBEdit mit gleichem Owner/Parent
var
  AParent: TWinControl;
  I: integer;
begin
  Result := nil;
  AParent := self.Parent;
  for I := 0 to AParent.ControlCount - 1 do
    if AParent.Controls[I] is TDBEdit then
      with AParent.Controls[I] as TDBEdit do
        if (DataField = self.DataField) and (DataSource = self.DataSource) then
        begin
          Result := AParent.Controls[I] as TCustomEdit;
          Exit;
        end;
end;

procedure TLovBtn.SetDataField(Value: string);
begin
  FDataField := Value;
  if Pos(FDataField, FFields) <= 0 then
    FFields := FDataField;                {mind. eins muß für Lov vorh. sein}
end;

procedure TLovBtn.SetName(const Value: TComponentName);
begin
  inherited SetName(Value);
  Caption := '';
end;

procedure TLovBtn.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent = DataSource then
      DataSource := nil;
  end;
  inherited Notification( AComponent, Operation);
end;

procedure TLovBtn.Click;
var
  ANavLink: TNavLink;
begin
  inherited Click;
  if DataSource <> nil then
  begin
    if DataSource is TLookUpDef then
      ANavLink := TLookUpDef(DataSource).NavLink else
      ANavLink := FormGetLNav(Owner).NavLink;
    {ANavLink.DataSet.Open;}
    FValue := LovDlgEx(ANavLink, Fields, FLovFlags, FFltrList);     {mit/ohne Filter}
    if FValue <> '' then
    begin
      {ANavLink.AssignValue(DataField, FValue); nicht generell auf Edit gehen}
      DataSource.Edit;   {nur bei Autoedit und dsBrowse}
      if DataSource.DataSet.State in dsEditModes then
        DataSource.DataSet.FieldByName(DataField).AsString := FValue;
    end;
    if assigned(FAfterClick) then
      FAfterClick(self);
  end;
end;

procedure TLovBtn.SetFltrList(const Value: TFltrList);
begin
  FFltrList.Assign( Value);
end;

end.
