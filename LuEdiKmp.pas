unit Luedikmp;
(* LookUpEdit: DBEdit mit Lookup-Verbindung, Indexverbindung
   LookUpMemo: DBMemo mit Lookup-Verbindung
   Autor: Martin Dambach
   Letzte Änderung
   03.10.96     Erstellen
   08.05.97     LookUpMemo
   10.10.98     LeOptions
   21.10.98     property OnDataChange: TNotifyEvent
   12.11.98     Changed
   05.05.04     BeforePaint (für DbCtrlGrid)
   04.10.07     KeyDown inherited
   19.06.08     Changed -> TextChanged
   29.07.08     Filterzeichen ('*','%'): nur noch nachladen wenn Taste gedrückt
   23.01.10     In Datumsfelder kann auch Komma (,) statt Punkt getippt werden.
   10.03.12     D2010 UniDAC: NewReferences mit :Parameter statt festen Werten
                              weil ansonsten kein Afterreturn-Update
   13.03.12                   schlecht da keine Filter übernommen werden.
                              wieder zuück auf Werte statt :P
                              i.V.m. TuQuery.SetDatafield
   16.04.13 md  LeNoFltrChar
   10.08.14 md  DblKlick nur wenn KeyField=True
   ---------------------------------------------------------
   Wie DBEdit, aber mit LookUp-Angaben

*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, DBCtrls, DB,
  LuDefKmp, Prots, DPos_Kmp;

type
  //LeOptions und Object nach LuDefKmp verschoben 11.08.02

  TLookUpEdit = class(TDBEdit)
  private
    { Private-Deklarationen }
    FOptions: TLeOptions;
    FLookUpSource: TLookUpDef;
    FLookUpField: string;
    FReferences: TFltrList;
    FKeyField: boolean;
    FOnDataChange: TNotifyEvent;
    FBeforePaint: TNotifyEvent;
    AFieldName, AFieldValue, KeyFields: string; {intern von BCDataChange um Stack
                                                nicht aufzublähen bei Rekursion}
    FInDataChange: boolean;
    procedure SetReferences(Value: TFltrList);
    procedure SetOptions(Value: TLeOptions);
    procedure SetLookUpSource(Value: TLookUpDef);
    procedure SetLookUpField(Value: string);
    function GetLuField: TField;
    function GetTextChanged: boolean;
    function IsDateTime: boolean;
    procedure SetInDataChange(const Value: boolean);
    procedure PrepareEnter;
  protected
    { Protected-Deklarationen }
    InKeyDown: boolean;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure DblClick; override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure BCDataChange(var Message: TWMBroadcast); message BC_DATACHANGE;
    procedure BCPrepareEnter(var Message: TWMBroadcast); message BC_PREPAREENTER;
  public
    { Public-Deklarationen }
    InPostMessage: boolean;
    EnterText: TCaption;                          {Typ entspr. Eigenschaft Text}
    procedure DoEnter; override;
    procedure UpdateField;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property LuField: TField read GetLuField;
    property TextChanged: boolean read GetTextChanged;  // reintroduce;
    property InDataChange: boolean read FInDataChange write SetInDataChange;
  published
    { Published-Deklarationen }
    property Options: TLeOptions read FOptions write SetOptions;
    property LookupSource: TLookUpDef read FLookUpSource write SetLookUpSource;
    property LookupField: string read FLookUpField write SetLookUpField;
    property References: TFltrList read FReferences write SetReferences;
    property KeyField: boolean read FKeyField write FKeyField;
    property OnDataChange: TNotifyEvent read FOnDataChange write FOnDataChange;
    property BeforePaint: TNotifyEvent read FBeforePaint write FBeforePaint;
  end;

  TLookUpMemo = class(TDBMemo)
  private
    { Private-Deklarationen }
    FOptions: TLeOptions;
    FLookUpSource: TLookUpDef;
    FLookUpField: string;
    procedure SetOptions(const Value: TLeOptions);
    function GetLuField: TField;
    procedure PrepareEnter;
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
    procedure DblClick; override;
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    { Public-Deklarationen }
    EnterText: TCaption;                          {Typ entspr. Eigenschaft Text}
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property LuField: TField read GetLuField;
  published
    { Published-Deklarationen }
    property Options: TLeOptions read FOptions write SetOptions;
    property LookupSource: TLookUpDef read FLookUpSource write FLookUpSource;
    property LookupField: string read FLookUpField write FLookUpField;
  end;

implementation

uses
  Uni, DBAccess, MemDS,
  Qwf_Form, LNav_Kmp, Err__Kmp, NLnk_Kmp, nstr_kmp,
  UQue_Kmp;

procedure TLookUpEdit.SetReferences(Value: TFltrList);
begin
  if FReferences <> Value then
    FReferences.Assign(Value);
end;

procedure TLookUpEdit.SetOptions(Value: TLeOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    if (ComponentState * [csDesigning, csLoading] = []) and (LookUpSource <> nil) then
    begin   {nur wenn zur Laufzeit die Options explizit geändert werden}
      LookUpSource.NavLink.BuildSOList;    {Änderung wiederspiegeln}
    end;
  end;
end;

procedure TLookUpEdit.SetLookUpSource(Value: TLookUpDef);
var
  TmpLookupSource: TLookupDef;
begin                          {warum wird das bei Value=nil nicht aufgerufen ?}
  TmpLookUpSource := FLookUpSource;
  FLookUpSource := Value;
  if not (csLoading in Owner.Componentstate) and
         (DataSource <> nil) and
         (Value <> nil) and
         (TmpLookUpSource <> nil) then
  begin
    DSGetNavLink(TmpLookUpSource).BuildSOList;
  end;
end;

procedure TLookUpEdit.SetInDataChange(const Value: boolean);
begin
  FInDataChange := Value;
end;

procedure TLookUpEdit.SetLookUpField(Value: string);
begin                          {warum wird das bei Value=nil nicht aufgerufen ?}
  FLookUpField := Value;
  if not (csLoading in Owner.Componentstate) and
         (DataSource <> nil) and
         (FLookUpSource <> nil) then
  begin
    DSGetNavLink(FLookUpSource).BuildSOList;
  end;
end;

function TLookUpEdit.GetLuField: TField;
begin
  result := nil;
  if (LookUpSource <> nil) and (LookUpSource.DataSet <> nil) and
     (LookUpField <> '') then
    result := LookUpSource.DataSet.FindField(LookUpField);
end;

function TLookUpEdit.GetTextChanged: boolean;
begin
  result := Text <> EnterText;
  EnterText := Text;                         {Changed := false}
end;

constructor TLookUpEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FReferences := TFltrList.Create;
  KeyField := true;
end;

destructor TLookUpEdit.Destroy;
begin
  FReferences.Free;     FReferences := nil;
  inherited Destroy;
end;

procedure TLookUpEdit.Loaded;
begin
  inherited;
  if SysParam.LuEdiNoDblClick then
    FOptions := FOptions + [LeNoDblClick];
end;

procedure TLookUpEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent = LookUpSource then
      LookUpSource := nil;
  end;
  inherited Notification( AComponent, Operation);
end;

procedure TLookUpEdit.WMPaint(var Message: TWMPaint);
begin
  if Assigned(FBeforePaint) then
    FBeforePaint(self);
  inherited;
end;

procedure TLookUpEdit.BCPrepareEnter(var Message: TWMBroadcast);
// wenn gesuchtes LuEdit dann HangingReturn=true setzen
// für nl.EnterValue
var
  AField: TField;
begin
  if (DataField = '') or (DataSource = nil) or (DataSource.DataSet = nil) or
     (LookUpField = '') or (LookUpSource = nil) or (LookUpSource.DataSet = nil) then
    Exit;
  AField := DataSource.DataSet.FindField(DataField);
  if (AField = nil) {or AField.IsNull and (LeNoNullValues in Options)} then
    Exit;
  if KeyField and (Message.Sender = DataSource) {ist die Broadcast für mich}
     and (Message.Data = AField.Index) then     {word(AField.Index) 20.07.03. FieldNo 140897}
  begin
    PrepareEnter;
  end;
end;

procedure TLookUpEdit.BCDataChange(var Message: TWMBroadcast);
// Im Editmodus wurde ein LuEdi Feld geändert: Lu nachladen
// von NavLink.DataChange
var
  I: integer;
  AField: TField;
  OldReferences, NewReferences: TFltrList;
  ALNav: TLNavigator;
  DoIt, OldNoBuildSql: boolean;
  FirstField, AllKeySegs: boolean;
  P, KeySeg, KeyIndex: integer;
  NextS: string;
  {AFieldName, AFieldValue, KeyFields: string; (siehe private}
  AllNullValues: boolean;   //es gibt nur null Werte
  NullValueExit: boolean;   //keine Aktion da 1 null Wert nu LeNoNullValues
begin
  if CompareText(Name, SysParam.OurLookUpEdit) = 0 then
  begin
    Debug0;
  end;
  if (DataField = '') or (DataSource = nil) or (DataSource.DataSet = nil) or
     (LookUpField = '') or (LookUpSource = nil) or (LookUpSource.DataSet = nil) then
    Exit;
  AField := DataSource.DataSet.FindField(DataField);
  if (AField = nil) {or AField.IsNull and (LeNoNullValues in Options)} then
    Exit;
  ALNav := TqForm(Owner).LNavigator;
  FirstField := Message.Sender = self;
  if FirstField or InPostMessage then
    Message.Sender := DataSource else
    if ALNav.ActiveLookUpEdit = self then
      exit;
  if KeyField and (Message.Sender = DataSource) {ist die Broadcast für mich}
     and (Message.Data = AField.Index)          {word(AField.Index) 20.07.03. FieldNo 140897}
     and not InDataChange                       {271098}
     and Enabled                                {060900}
     and (LookUpSource.DataSet.Active or LookUpSource.AutoOpen)
     and not LookUpSource.NavLink.InDataChange      {wichtig !}
     and ((LookUpSource.DataSet.State = dsBrowse) or  {180398 qwf.db}
          LookUpSource.AutoOpen) then
  begin
    if pfActive in LookUpSource.PutStatus then            {241098 DPE.ERF.Post}
    begin
      if pfDataChanged in LookUpSource.PutStatus then
        Exit;
    end else
      LookUpSource.KeyIndex := -1;                 {241098}
    if CompareText(Name, SysParam.OurLookUpEdit) = 0 then
    begin
      Debug0;
    end;
    // %, * in Feldwert wird als Filterzeichen interpretiert. Nix nachladen. - 27.07.08
    if HasFltrChr(AField.AsString) and false then
    begin
      Prot0('HasFltrChr %s=%s', [OwnerDotName(self), AField.AsString]);
      Exit;
    end;

    if DsGetNavLink(DataSource).pmDataChange then  //Postmessage Datachange
    begin
      if not InPostMessage then
      begin
        if SysParam.ProtBeforeOpen then
          Prot0('pmDataChange(%s)',[Name]);
        InPostMessage := true;
{$ifdef WIN32}
        PostMessage(Handle, BC_DATACHANGE, Message.Data, LPARAM(Message.Sender));
{$else}
        PostMessage(Handle, BC_DATACHANGE, TMessage(Message).WParam, TMessage(Message).LParam);
{$endif}
        Exit;
      end else
        InPostMessage := false;
    end;
    AllKeySegs := true;
    AllNullValues := true;
    NullValueExit := false; 
    OldReferences := TFltrList.Create;
    NewReferences := TFltrList.Create;
    OldNoBuildSql := LookUpSource.NavLink.NoBuildSql;
    try
      InDataChange := true;
      if assigned(FOnDataChange) then
        FOnDataChange(self);
      OldReferences.Assign( LookUpSource.References);

      (* Key für Referenzen in KeyList suchen *)
      KeySeg := 0;
      KeyIndex := 0;
      for I := 0 to LookUpSource.KeyList.Count-1 do
      begin
        if (LookUpSource.KeyIndex >= 0) and (LookUpSource.KeyIndex <> I) then
          continue;                         {Key wird vorgeschrieben}
        KeyFields := LookUpSource.KeyList.Value( I);
        P := 0;
        AFieldName := PStrTok(KeyFields, ';,', NextS, true);
        while (AFieldName <> '') and
              (CompareText( AFieldName, LookUpField) <> 0) do
        begin
          Inc( P);
          AFieldName := PStrTok( '', ';,', NextS, true);
          if AFieldName = '' then
            P := 0;
        end;
        if (CompareText( AFieldName, LookUpField) = 0) then
          Inc( P);
        if (P > 0) and ((KeySeg = 0) or (KeySeg > P)) then
        begin
          KeySeg := P;   //Anzahl Einzelfelder im Key
          KeyIndex := I; {Index in KeyList}
        end;
      end;
      if KeySeg > 0 then
      begin
        LookUpSource.KeyIndex := KeyIndex;
        P := 0; {lfd. Position des Segments in KeyFields}
        KeyFields := LookUpSource.KeyList.Value( KeyIndex); {Key Segmente}
        AFieldName := PStrTok(KeyFields, ';,', NextS, true); {ein Segment}
        while AFieldName <> '' do
        begin
          I := LookUpSource.NavLink.SOList.ValueIndex(AFieldName, @AFieldValue);
          if I < 0 then
            EError('Keyfeld "%s" nicht in SOList/LuEdit fehlt (%s.%s)',
              [AFieldName, Owner.Name, Name]);
          if Pos(':', AFieldValue) = 1 then
          begin  //Masterfied
            AField := DataSource.DataSet.FieldByName(copy(AFieldValue, 2, 250));
            AFieldValue := GetFieldValue(AField)
          end;
          if AFieldValue = '' then   //16.11.06 SQVA MultiField PKey
          begin
            if LeForceEmpty in Options then
              AFieldValue := '=';
            if LeNoNullValues in Options then
              NullValueExit := true;
          end;
          if (P > 0) and (CompareText(AFieldName, LookUpField) <> 0) then
            DoIt := AFieldValue <> '' else  {leere Felder weglassen}
            DoIt := true;        {1.Keysegment und eigenes Feld immer}
          if DoIt then   {nur wenn nicht leer od. 1.Keysegment}
          begin
            {NewReferences.Add( LookUpSource.SOList.Strings[I]);}
            if AFieldValue = '' then
              AFieldValue := '=' else
              AllNullValues := false;
            NewReferences.AddFmt('%s=%s', [LookupSource.NavLink.LongFieldName(AFieldName),
              AFieldValue]);
          end;
          Inc( P);
          if (P >= KeySeg) and              {nur bis zu unserem Keysegment}
             not (LeForceEmpty in Options) then  //16.11.06 SQVA MultiField PKey
          begin
            AllKeySegs := false;
            break;
          end;
          AFieldName := PStrTok('', ';,', NextS, true);
        end;
      end else
      begin  //kein KeySeg gefunden:
        AFieldValue := GetFieldValue(DataSource.DataSet.FieldByName(DataField));
        if AFieldValue = '' then
        begin
          AFieldValue := '=';
          if LeNoNullValues in Options then
            NullValueExit := true;
        end else
          AllNullValues := false;
        NewReferences.AddFmt('%s=%s',
          [LookupSource.NavLink.LongFieldName(LookUpField), AFieldValue]);
      end;
      for I:= 0 to OldReferences.Count-1 do      {Referenzen zw. mehreren Tabellen}
      begin                                      //T1.F1=T2.F2
        if Pos(':', OldReferences.Strings[I]) <= 0 then
          NewReferences.Add( OldReferences.Strings[I]);
      end;
      for I := 0 to References.Count - 1 do
      begin   //nur für LuEdit.References
        AFieldValue := References.Value(I);
        if Char1(References.Value(I)) = ':' then
        begin
          AFieldName := copy( References.Value(I), 2, 200); {:FieldName}
          AField := DataSource.DataSet.FieldByName( AFieldName);
          AFieldValue := GetFieldValue( AField);
        end else
          AFieldValue := References.Value(I);

        if AFieldValue = '' then   //16.11.06 SQVA MultiField PKey
        begin
          if LeForceEmpty in Options then
            AFieldValue := '=';
          if LeNoNullValues in Options then
            NullValueExit := true;  //kein Nachladen wenn Feldinhalte fehlen
        end;
        if AFieldValue <> '' then                {wichtig HLW.Aur.Kund}
        begin
          NewReferences.AddFmt('%s=%s',[References.Param(I), AFieldValue]);
          AllNullValues := false;
        end;
      end;   {auch bei User-Input filtern, Vergl. auch LuDefKmp.UserData}
      if not NullValueExit then
      begin
        if AllKeySegs then        {nur wenn alle KeySegmente beteiligt waren:}
          LookUpSource.PutStatus := LookUpSource.PutStatus + [pfDataChanged];

        LookUpSource.NavLink.NoBuildSql := false;
        if SysParam.ProtBeforeOpen then
          Prot0('BCDataChange(%s):%.80s',[Name, GetStringsText( NewReferences)]);

        if (GetStringsText(LookUpSource.References) <> GetStringsText(NewReferences)) or
           (LookUpSource.DataSet is TuQuery) then   {optimieren}
        begin
//12.03.12 unnötig wg set references
//          try
//            LookUpSource.NavLink.InRefresh := true;    {Close erzwingen}
//            LookUpSource.DataSet.Close;
//          finally
//            LookUpSource.NavLink.InRefresh := false;
//          end;
          LookUpSource.References := NewReferences;    {Builds SQL}

          LookUpSource.NavLink.NoBuildSql := true;     {setzt hangingsql - q weg}
          LookUpSource.References := OldReferences;
        end;
      end;
      if NullValueExit then
      begin
        DoIt := false;
      end else
      if LookUpSource.AutoOpen and AllNullValues and
         not LookUpSource.DataSet.Active then
      begin
        DoIt := false;
        if not (luTolerant in LookUpSource.Options) and not ALNav.InStartLookUp then
          LookUpSource.PutSOFields;    {Leere Felder übernehmen 101198 entspr NewDataChange}
      end else
        DoIt := true;
      if DoIt then
      begin
        if CompareText(Name, SysParam.OurLookUpEdit) = 0 then
        begin
          Debug0;
        end;
        LookUpSource.DataSet.Open;
        if LookUpSource.HangingReturn and not LookUpSource.DataSet.Eof then
        begin
          LookUpSource.HangingReturn := false;             {070997 ROE}
          LookUpSource.DataPos.GetValues( LookUpSource.DataSet);
          ALNav.DoAfterReturn( self, lumDirect, LookUpSource);
        end;
      end else
        LookUpSource.HangingReturn := false;             {070997 ROE}
    finally
      InDataChange := false;
      LookUpSource.NavLink.NoBuildSql := OldNoBuildSql;
      OldReferences.Free;
      NewReferences.Free;
      {Message.Result := 0;   {2 mit versch. LuDefs !}
      {Message.Result := 1;   {Ende} {040697 HLW, wg.KeyField OK!}
      Message.Result := 0;   {weiter mit nächstem ludef 250398 DPE.Vo.ZSod}
    end;
  end;
end;

procedure TLookUpEdit.UpdateField;
begin
  if (Field <> nil) and (Field.Text <> Text) and
     (Field.DataSet <> nil) and (Field.DataSet.State in dsEditModes) then
    Field.Text := Text;
end;

function TLookUpEdit.IsDateTime: boolean;
begin
  Result := false;
  if Field <> nil then
    Result := Field is TDateTimeField;
end;

procedure TLookUpEdit.PrepareEnter;
// Feld aktivieren für Lookup's.
var
  LNav: TLNavigator;
begin
  EnterText := Text;
  if (LookUpSource <> nil) and (LookUpField <> '') then
  begin
    LNav := FormGetLNav( Owner);
    LNav.SetActiveLookUpEdit(self);
    {wmess('enter(%s)',[Name]);}
    Modified := false;
    LookUpSource.HangingReturn := true;
  end;
end;

procedure TLookUpEdit.DoEnter;
(* Feld betreten. * für LuDef:ChangeData *)
begin
  PrepareEnter;
  inherited DoEnter;  {erst hier damit OnEnter ActLuEdi ändern kann. HLW.auer}
  if Hint <> '' then
    SMess( '%s', [RemoveCRLF(GetLongHint(Hint))]); {falls über Tastatur erreicht (später über WndProc aller Ctrls)}
end;

procedure TLookUpEdit.DoExit;
(* Feld verlassen *)
var
  AForm: TqForm;
  LNav: TLNavigator;
begin
  InKeyDown := false;
  if (LookUpSource <> nil) and (LookUpField <> '') then
  begin
    AForm := Owner as TqForm;
    LNav := AForm.GetLNav;
    if (AForm.ActiveControl <> self) and        {Bug in Win Dialog}
       (AForm.ActiveControl <> LNav.ActiveLookUpEdit) then //12.03.12 test - D2010 spinnt bei bcnextcontrol
    begin
      LNav.SetActiveLookUpEdit(nil);
      {wmess('exit(%s)',[Name]);}
      LookUpSource.HangingReturn := false;
      if (LeReadOnly in Options) and               {ReadOnly realisieren}
         (Field <> nil) and (LuField <> nil) and
         (DataSource.DataSet.State in dsEditModes) then
      begin
        LuField.DataSet.Open;
        SetFieldComp(Field, LuField.AsString);
      end;
    end;
  end;
  inherited DoExit;   {erst hier damit Onexit ActLuEdi ändern kann}
  if Hint <> '' then
    SMess( '',[0]);      {falls über Tastatur erreicht   (später über WndProc aller Ctrls)}
end;

procedure TLookUpEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  InKeyDown := (Key <= $2F) or (Key >= $70);  // <=VK_HELP, >=VK_F1
  if (Shift = []) and (Key = VK_RETURN) then
  begin
    Key := 0;
    UpdateField;
    SelectAll;
  end else
    inherited;
end;

procedure TLookUpEdit.KeyPress(var Key: Char);
begin
  if (Key = ',') and IsDateTime then   { TODO : or IsFloatStr }
  begin
    Key := '.';
  end else
    inherited KeyPress(Key);
end;

procedure TLookUpEdit.DblClick;
begin
  if (LookUpSource <> nil) and not (LeNoDblClick in Options) and
     KeyField then  //10.08.14 nur wenn KeyField=True
  begin
    LookUpSource.LookUp( lumTab);
  end else
  begin
    if not Assigned(OnDblClick) and CtrlKeyDown then
      SelectAll;
    inherited;
  end;
end;

(*** LookUpMemo **************************************************************)

procedure TLookUpMemo.Loaded;
begin
  inherited;
  if SysParam.LuEdiNoDblClick then
    FOptions := FOptions + [LeNoDblClick];
end;

procedure TLookUpMemo.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent = LookUpSource then
      LookUpSource := nil;
  end;
  inherited Notification( AComponent, Operation);
end;

procedure TLookUpMemo.DblClick;
begin
  if (LookUpSource <> nil) and not (LeNoDblClick in Options) then
  begin
    LookUpSource.LookUp( lumTab);
  end else
  begin
    if not Assigned(OnDblClick) and CtrlKeyDown then
      SelectAll;
    inherited;
  end;
end;

procedure TLookUpMemo.SetOptions(const Value: TLeOptions);
begin
  FOptions := Value;
  if (ComponentState = []) and (LookUpSource <> nil) then
  begin   {nur wenn zur Laufzeit die Options explizit geändert werden}
    LookUpSource.NavLink.BuildSOList;    {Änderung wiederspiegeln}
  end;
end;

procedure TLookUpMemo.PrepareEnter;
// Feld aktivieren für Lookup's.
var
  LNav: TLNavigator;
begin
  EnterText := Text;
  if (LookUpSource <> nil) and (LookUpField <> '') then
  begin
    LNav := FormGetLNav( Owner);
    LNav.SetActiveLookUpEdit(self);
    Modified := false;
    LookUpSource.HangingReturn := true;
  end;
end;

procedure TLookUpMemo.DoEnter;
(* Feld betreten. * für LuDef:ChangeData *)
begin
  PrepareEnter;
  inherited DoEnter;  {erst hier damit OnEnter ActLuEdi ändern kann. HLW.auer}
  if Hint <> '' then
    SMess( '%s', [RemoveCRLF(GetLongHint(Hint))]); {falls über Tastatur erreicht (später über WndProc aller Ctrls)}
end;

procedure TLookUpMemo.DoExit;
var
  AForm: TqForm;
  LNav: TLNavigator;
begin
  if (LookUpSource <> nil) and (LookUpField <> '') then
  begin
    AForm := Owner as TqForm;
    if AForm.ActiveControl <> self then        {Bug in Win Dialog}
    begin
      LNav := AForm.GetLNav;
      LNav.SetActiveLookUpEdit(nil);
      LookUpSource.HangingReturn := false;
      if (LeReadOnly in Options) and               {ReadOnly realisieren}
         (Field <> nil) and (LuField <> nil) and
         (DataSource.DataSet.State in dsEditModes) then
      begin
        LuField.DataSet.Open;
        SetFieldComp(Field, LuField.AsString);
      end;
    end;
  end;
  inherited DoExit;   {erst hier damit Onexit ActLuEdi ändern kann}
  if Hint <> '' then
    SMess( '',[0]);      {falls über Tastatur erreicht   (später über WndProc aller Ctrls)}
end;

function TLookUpMemo.GetLuField: TField;
begin
  result := nil;
  if (LookUpSource <> nil) and (LookUpSource.DataSet <> nil) and
     (LookUpField <> '') then
    result := LookUpSource.DataSet.FindField(LookUpField);
end;

end.
