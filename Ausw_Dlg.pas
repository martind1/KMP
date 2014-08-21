unit Ausw_Dlg;
(* Auswertung - Dialog i.v.m. TAusw Komponente

   Autor: Martin Dambach
   Letzte Änderung
   07.07.97     Erstellen
   ToDo
   24.06.98     Filter übernehmen: 1.Datum  2.User Fields
   24.06.98     Lookup (Lov) mit mehreren Spalten zur Ansicht
   08.08.98     Datumsformat verbieten aber Datum eingeben:
                Enabled.chkDatum=false und Checked.chkDatum=true
   02.04.99     Datum immer 4stellig erzeugt Y2
   02.04.01 JP  Formularhöhe wegen Darstellung in NT geändert
   04.12.04 MD  DatumVon nicht leermachen wenn gleich DatumBis
                Checkboxen invisible wenn nicht verwendet
   06.11.09     NiceDate: '2009-10' -> 'Oktober 2009' im Ausdruck
   17.04.13 MD  kein Farbumschlag mehr. Prot alle Components bei Fehler in UserFields.
   17.10.13     TEdit Höhe:Standard. Asw.FormatFilter. Nav.SavePosition
                Auswahl:Checklistbox wenn >2 Auswahlmöglichkeiten.
   31.01.14 md  InrgDtmClick (statt lokal Aktiv)
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Menus, Spin, Lubtnkmp, PSrc_Kmp,
  Dialogs, DatumDlg, Luedikmp, Ausw_Kmp, Mugrikmp, Prots;

type
  TDlgAusw = class(TqForm)
    Nav: TLNavigator;
    PopupMenu1: TPopupMenu;
    MiLookUp: TMenuItem;
    PanBottom: TPanel;
    PanTop: TScrollBox;
    LaDtmVon: TLabel;
    LaDtmBis: TLabel;
    LaBemerkung: TLabel;
    BtnDtmVon: TDatumBtn;
    EdDtmVon: TEdit;
    EdDtmBis: TEdit;
    chbEinzel: TCheckBox;
    BtnDtmBis: TDatumBtn;
    rgDtm: TRadioGroup;
    chbZwSum: TCheckBox;
    chbGrpSum: TCheckBox;
    EdCaption: TEdit;
    PanClient: TPanel;
    ScrollBoxUser: TScrollBox;
    BtnScr1: TBitBtn;
    Panel1: TPanel;
    BtnScr: TBitBtn;
    BtnPrn: TBitBtn;
    BtnSetup: TBitBtn;
    BtnClose: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnSetupClick(Sender: TObject);
    procedure BtnScrClick(Sender: TObject);
    procedure BtnPrnClick(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure rgDtmClick(Sender: TObject);
    procedure BtnDtmClick(Sender: TObject);
    procedure BtnDtmEnter(Sender: TObject);
    procedure EdDtmExit(Sender: TObject);
    procedure MiLookUpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbClick(Sender: TObject);
    procedure BtnScr1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EdCaptionChange(Sender: TObject);
  protected
    procedure BCCheckReadOnly(var Message: TWMBroadcast); message BC_CHECKREADONLY;
  private
    { Private-Deklarationen }
    FDtmVon, FDtmBis: TDateTime;
    Ausw_Caption: string;
    TestEdit: TEdit;
    InrgDtmClick: boolean;
    procedure SetDtmVon(Value: TDateTime);
    procedure SetDtmBis(Value: TDateTime);
    procedure UserButton1Click(Sender: TObject);
    procedure LuBtnClick(Sender: TObject);
    function DateFmt: string;
    function NiceDate(S: string): string;
    procedure UserEditChange(Sender: TObject);
  public
    { Public-Deklarationen }
    Ausw: TAusw;
    //DateFmt: string;
    InDoPrn: boolean;
    procedure Prepare;           {Ausw-Felder definieren anhand Eingabe}
    procedure DoPrn(Preview: boolean);
    property DtmVon: TDateTime read FDtmVon write SetDtmVon;
    property DtmBis: TDateTime read FDtmBis write SetDtmBis;
  end;

var
  DlgAusw: TDlgAusw;

implementation
{$R *.DFM}
uses
  Printers,
  GNav_Kmp, Ini__Kmp, Asws_Kmp, Lov__Dlg, Asw__Dlg, AswClDlg, Nlnk_Kmp,
  Tools, nstr_Kmp, Err__Kmp, Poll_Kmp, DPos_Kmp, KmpResString;
const
  SEdUsr = 'EdUsr';
  SLaUsr = 'LaUsr';

procedure TDlgAusw.FormCreate(Sender: TObject);
begin
  DlgAusw := self;
  Sizeable := true;
  Font.Assign(Application.MainForm.Font);
end;

procedure TDlgAusw.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if InDoPrn and (Ausw <> nil) then
    Action := Ausw.CloseAction else
    Action := caFree;
end;

procedure TDlgAusw.FormDestroy(Sender: TObject);
begin
  if Ausw <> nil then
    Ausw.DlgAusw := nil;
  DlgAusw := nil;
end;

procedure TDlgAusw.FormResize(Sender: TObject);
var
  I, xBtn: integer;
begin
  EdCaption.Width := PanTop.Width - 20 - EdCaption.Left;
  xBtn := ScrollBoxUser.Width - 20 - EdCaption.Height;  //11.09.02
  for I := 0 to ComponentCount - 1 do
    if Components[I].Tag = 7 then
    begin
      if Components[I] is TBitBtn then
      begin
        xBtn := ScrollBoxUser.Width - NonClientMetrics.iScrollWidth - TBitBtn(Components[I]).Width;
        TBitBtn(Components[I]).Left := xBtn;
      end;
    end;
  for I := 0 to ComponentCount - 1 do
    if Components[I].Tag = 7 then
    begin
      if Components[I] is TEdit then
        TEdit(Components[I]).Width := xBtn - TEdit(Components[I]).Left;
    end;
end;

procedure TDlgAusw.NavStart(Sender: TObject);
var
  yUser, xLabel, xEdit: integer;

  procedure CreateChb(aChk: TCheck; aName: string);
  var
    aChb: TCheckBox;
  begin
    aChb := TCheckbox.Create(self);
    aChb.Parent := ScrollBoxUser;
    aChb.Name := aName;    {'chbUser1';}
    aChb.Caption := Ausw.UserFields.Params[':' + aChb.Name];
    //aChb.Color := clSilver;  weg 17.04.13
    aChb.Alignment := taLeftJustify;
    aChb.Top := yUser;
    aChb.Left := xLabel;
    aChb.Width := IMax(xEdit + 13 - xLabel,
      Canvas.TextWidth(AChb.Caption) + 2 * aChb.Height);  {*1.2}
    {xEdit := IMax(xEdit, aChb.Width - 13);}
    aChb.TabStop := true;
    aChb.Checked := aChk in Ausw.Checked;
    aChb.Tag := ord(aChk);
    aChb.OnClick := chbClick;
    yUser := yUser + aChb.Height + 2;
  end; (* CreateChb *)

var
  ADate: TDateTime;
  AYear, AMonth, ADay: word;
  ALabel: TLabel;
  AEdit: TEdit;
  ABtn: TBitBtn;
  AValue: string;
  AComponent: TComponent;
  I, P, yDiff, xBtn: integer;
  TmpList: TFltrList;
  S1, S2, NextS: string;
  AField: TField;
  AAsw: TAsw;
  UserFieldsError: boolean;
  I1: integer;
  L1: TStringList;
  EditList: array of TEdit;

begin (* NavStart *)
  if (Caller = nil) or not (Caller is TAusw) then
  begin
    ErrWarn('Auswahldialog kann nicht gestartet werden',[0]);
    Close;
    Exit;
  end;
  Ausw := (Caller as TAusw);
  Ausw.DlgAusw := self;
  TmpList := TFltrList.Create;
  try
    if Ausw.CopyFltr then                {19.12.02 GEN.Word}
      Ausw.FltrList.MergeStrings(DsGetNavLink(Ausw.DataSource).FltrList);

    TmpList.AddFltrList(Ausw.DataSource.DataSet, Ausw.FltrList, true);
    //BtnScr.Enabled := not Ausw.NoPreview;
    BtnScr.Visible := not Ausw.NoPreview;       //14.09.02 LAWA
    BtnPrn.Visible := Ausw.DruckerTyp <> '';  //30.06.12 nur wenn DruckerTyp zugeordnet


    Caption := Ausw.Display;
    EdCaption.Text := Ausw.Caption;
    Ausw_Caption := Ausw.Caption;

    case Ausw.DfltDate of
      ddAktTag, ddPrevTag, ddNone, ddBisHeute, ddy2BisHeute, ddBisVorlMonat, ddMonBisHeute,
      ddDayMon, ddDayYear, ddJahrBisHeute:
        Ausw.DateGroup := dgDay;
      ddAktMonat, ddPrevMonat, ddMonYear:
        Ausw.DateGroup := dgMonth;
      ddAktJahr, ddPrevJahr, ddYearAll:
        Ausw.DateGroup := dgYear;
    end;
    case Ausw.DateGroup of        {19.12.02}
      dgDay: rgDtm.ItemIndex := 0;
      dgMonth: rgDtm.ItemIndex := 1;
      dgYear: rgDtm.ItemIndex := 2;
    end;
    ADate := date;
    DecodeDate(ADate, AYear, AMonth, ADay);              {hier für ddMonBisHeute}
    if Ausw.DfltDate in [ddPrevJahr, ddPrevMonat, ddPrevTag] then
      DateInc(ADate, 0, -1, 0);
    if Ausw.DfltDate in [ddJahrBisHeute] then
      DateInc(ADate, -1, 0, 1);
    if Ausw.DfltDate in [ddNone, ddBisHeute, ddBisVorlMonat, ddYearAll] then
      ADate := EncodeDate(1980, 1, 1);
    if Ausw.DfltDate in [ddy2BisHeute] then
      ADate := EncodeDate(2000, 1, 1);
    if Ausw.DfltDate in [ddMonBisHeute, ddDayMon] then
      ADate := EncodeDate(AYear, AMonth, 1);
    if Ausw.DfltDate in [ddDayYear, ddMonYear] then
      ADate := EncodeDate(AYear, 1, 1);
    if Ausw.DtmVon = 0 then
      DtmVon := ADate else
      DtmVon := Ausw.DtmVon;
    if Ausw.DfltDate in [ddNone, ddBisHeute, ddy2BisHeute, ddBisVorlMonat, ddMonBisHeute,
      ddDayMon, ddDayYear, ddMonYear, ddYearAll, ddJahrBisHeute] then
    begin
      ADate := Date;
      if Ausw.DfltDate in [ddBisVorlMonat] then
      begin
        DateInc(ADate, 0, -2, 0);
        DecodeDate(ADate, AYear, AMonth, ADay);
        ADay := DaysOfMonth(AYear, AMonth);
        ADate := EncodeDate(AYear, AMonth, ADay);
      end;
    end;
    if Ausw.DtmBis = 0 then
      DtmBis := ADate else
      DtmBis := Ausw.DtmBis;
    if not (chkDatum in Ausw.Enabled) or (Ausw.DfltDate = ddNone) or
       (chkNoFormat in Ausw.Enabled) then
    begin
      if not (chkDatum in Ausw.Checked) then
      begin
        EdDtmVon.ReadOnly := true;
        EdDtmBis.ReadOnly := true;
        BtnDtmVon.Enabled := false;
        BtnDtmBis.Enabled := false;
        EdDtmVon.Text := '';          //28.01.03
        EdDtmBis.Text := '';
      end;
      rgDtm.Enabled := false;
    end;
    chbEinzel.Enabled := chkEinzel in Ausw.Enabled;
    chbEinzel.Checked := chkEinzel in Ausw.Checked;
    chbZwSum.Enabled := chkZwSum in Ausw.Enabled;
    chbZwSum.Checked := chkZwSum in Ausw.Checked;
    chbGrpSum.Enabled := chkGrpSum in Ausw.Enabled;
    chbGrpSum.Checked := chkGrpSum in Ausw.Checked;
    //04.12.04 Lawa
    chbEinzel.Visible := chbEinzel.Enabled or chbEinzel.Checked;
    chbZwSum.Visible := chbZwSum.Enabled or chbZwSum.Checked;
    chbGrpSum.Visible := chbGrpSum.Enabled or chbGrpSum.Checked;
    //25.04.05 Depo
    EdDtmBis.Visible := not (chkNoDtmBis in Ausw.Enabled);
    LaDtmBis.Visible := EdDtmBis.Visible;
    BtnDtmBis.Visible := EdDtmBis.Visible;

    if TmpList.Values[Ausw.DateField] <> '' then  //es gibt Filter
    begin
      S1 := PStrTok(TmpList.Values[Ausw.DateField], '>=<~*%', NextS);
      P := Pos('..', S1);
      if P > 1 then
      begin
        S2 := copy(S1, P + 2, 100);
        S1 := copy(S1, 1, P - 1);
      end else
        S2 := PStrTok('', '>=<~*%', NextS);
      rgDtm.ItemIndex := 0;
      if Char1(Ausw.DateField) = '>' then
      begin
        if CharI(Ausw.DateField, 2) = '=' then
          DtmVon := StrToDateTol(S1) else
          DtmVon := StrToDateTol(S1) + 1;
        DtmBis := date + 365;
      end else
      if Char1(Ausw.DateField) = '<' then
      begin
        if CharI(Ausw.DateField, 2) = '=' then
          DtmBis := StrToDateTol(S1) else
          DtmBis := StrToDateTol(S1) - 1;
        DtmVon := EncodeDate(1, 1, 1900);
      end else
      if S2 <> '' then
      begin
        DtmVon := StrToDateTol(S1);
        DtmBis := StrToDateTol(S2);
      end else
      begin
        DtmVon := StrToDateTol(S1);
        DtmBis := StrToDateTol(S1);
      end;
    end;
    if not EdDtmBis.Visible then
      EdDtmBis.Text := '';

    Height := Constraints.MinHeight;  //19.04.14
    ScrollBoxUser.Visible := false;
    yUser := 4;
    xLabel := 8;
    xEdit := 96;
    {xBtn := 435;         {ScrollBoxUser.Width - 30;     {368;}
    xBtn := ScrollBoxUser.Width - 20 - (EdCaption.Height - 2);  //11.09.02
    if chkUser1 in Ausw.Enabled then
      CreateChb(chkUser1, 'chbUser1');
    if chkUser2 in Ausw.Enabled then
      CreateChb(chkUser2, 'chbUser2');
    if chkUser3 in Ausw.Enabled then
      CreateChb(chkUser3, 'chbUser3');

    UserFieldsError := false;
    SetLength(EditList, Ausw.UserFields.Count);
    for I:= 0 to Ausw.UserFields.Count-1 do
    begin
      if (Trim(Ausw.UserFields[I]) = '') or BeginsWith(Ausw.UserFields[I], ';') then
      begin
        Debug0;
        continue;
      end;
      AValue := OnlyFieldName(Ausw.UserFields.Value(I));  //Jahr=Tbl.EDT
      P := Pos(';', AValue);
      if P > 0 then
        System.Delete(AValue, P, MaxInt);
      if (Ausw.DateField <> '') and
         (CompareText(AValue, Ausw.DateField) = 0) then
      begin
        LaDtmVon.Caption := Ausw.UserFields.Param(I);
        continue;
      end;
      {if CompareText(AValue, ':Bemerkung') = 0 then
      begin
        LaBemerkung.Caption := Ausw.UserFields.Param(I);
        continue;
      end;}
      // MeineSumme=:chbZwSum
      if Char1(AValue) = ':' then
      begin
        AComponent := FindComponent(copy(AValue, 2, 200));
        if AComponent <> nil then
        begin
          if AComponent is TLabel then
            (AComponent as TLabel).Caption := Ausw.UserFields.Param(I) else
          if AComponent is TCheckBox then
            (AComponent as TCheckBox).Caption := Ausw.UserFields.Param(I) else
          if AComponent is TEdit then
            (AComponent as TEdit).Text := Ausw.UserFields.Param(I) else
          if AComponent is TButton then
          begin
            (AComponent as TButton).Caption := Ausw.UserFields.Param(I);
            (AComponent as TButton).Hint := '';  //Ausgabe auf Drucker o.ä. weg. 14.09.02 LAWA
          end else
          begin
            UserFieldsError := true;
            ProtL('Component (%s) Typ (%s) falsch.', [copy(AValue, 2, 200), AComponent.ClassName]);
          end;
        end else
        begin
          UserFieldsError := true;
          ProtL('Component (%s) fehlt in Ausw_Dlg.',[copy(AValue, 2, 200)]);
        end;
        continue;
      end;

      ALabel := TLabel.Create(self);
      ALabel.Parent := ScrollBoxUser;
      ALabel.Top := yUser + 2;
      ALabel.Left := xLabel;
      ALabel.Name := SLaUsr + StrToValidIdent(AValue);  //23.03.06
      ALabel.Caption := Ausw.UserFields.Param(I);
      //xEdit := IMax(xEdit, ALabel.Left + ALabel.Width + 8);  //06.11.09 +8
      //if ALabel.Left + ALabel.Width > xEdit then
      //  xEdit := ALabel.Left + ALabel.Width + 8;  //06.11.09 +8
      xEdit := IMax(xEdit, ALabel.Left + ALabel.Width + 8);  //18.10.13 iVm 2.Loop/EditList

      AEdit := TEdit.Create(self);
      EditList[I] := AEdit;
      TestEdit := AEdit;  //test 30.11.11
      //AEdit.AutoSize := false;  //bis 17.10.13  //30.11.11
      AEdit.Tag := 7; //für Resize
      AEdit.Parent := ScrollBoxUser;
      AEdit.Color := clWhite;
      AEdit.Top := yUser;
      AEdit.Left := xEdit;
      //AEdit.Width := xBtn - xEdit - 2;    {270;}
      AEdit.Width := xBtn - xEdit;    //11.09.02
      AEdit.Name := SEdUsr + StrToValidIdent(AValue);  //23.03.06
      AEdit.Hint := 'Mehrere Werte mit ; trennen. Von..Bis mit .. trennen.';
      AEdit.Text := TmpList.Values[AValue];  {Filter 100500 Ausw.FltrList}
      if psUserCaption in Ausw.Options then
        AEdit.OnChange := UserEditChange;
      try
        AField := Ausw.DataSource.DataSet.FieldByName(AValue);
        if AField.Tag > 0 then       {Asw}
        begin
          AAsw := Asws.Asw(AField.Tag);
          //Auswahlfelder: Kriterien im Klartext anzeigen
          AEdit.Text := AAsw.FormatFilter(TmpList.Values[AValue]);  //bis 17.10.13 AAsw.FindValue(
        end;
      except on E:Exception do
        EProt(self, E, 'NavStart.UserFields', [0]);
      end;

      ABtn := TBitBtn.Create(self);
      ABtn.Tag := 7; //für Resize
      ABtn.Parent := ScrollBoxUser;
      ABtn.Top := yUser + 1;
      ABtn.Left := xBtn;
      ABtn.Height := EdCaption.Height - 2;
      ABtn.Width := ABtn.Height;
      ABtn.TabStop := false;
      ABtn.Name := 'Btn' + AValue;
      ABtn.Caption := '';
      ABtn.Glyph.Handle := LoadBitmap(HInstance, 'LUBTN');
      ABtn.OnClick := LuBtnClick;

      yUser := yUser + AEdit.Height + 2;
    end;  // Ausw.UserFields
    for I := 0 to Length(EditList) - 1 do
    begin
      if EditList[I] <> nil then
      begin
        EditList[I].Left := xEdit;
        EditList[I].Width := xBtn - xEdit;
      end;
    end;

    if UserFieldsError then
    begin
      L1 := TStringList.Create;
      L1.Sorted := true;
      for I1 := 0 to ComponentCount - 1 do
        L1.Add(Format('%s: %s', [Components[I1].Name, Components[I1].ClassName]));
      ProtA('%s', [L1.Text]);
      L1.Free;
    end;

    if Ausw.UserButton1 <> '' then
    begin
      ABtn := TBitBtn.Create(self);
      ABtn.Caption := Ausw.UserButton1;
      ABtn.Parent := ScrollBoxUser;
      ABtn.Top := yUser;
      ABtn.Left := xLabel;
      ABtn.Height := BtnScr.Height;
      ABtn.Width := ((Canvas.TextWidth(ABtn.Caption) * 6) div 5) + 8;  {*1.2}
      ABtn.TabStop := true;
      ABtn.Name := 'UserButton1';
      ABtn.OnClick := UserButton1Click;
      ABtn.Tag := 1;
      yUser := yUser + ABtn.Height + 2;
    end;
    yUser := yUser + 4;
    yDiff := yUser - ScrollBoxUser.Height;
    if yDiff > 0 then
    begin
      Sizeable := true;
      InitHeight := IMin(GNavigator.ClientHeight, InitHeight + yDiff);
      MinMaxHeight := InitHeight;
{>JP 02.04.2001 Formularhöhe wegen Darstellung unter NT geändert}
      //Height := InitHeight;
      Height := InitHeight + 10;
{<JP}
      Top := IMin(Top, GNavigator.ClientHeight - Height);
    end;
    ScrollBoxUser.Visible := true;
    // Filter vorbelegen und zeigen
    if psUserCaption in Ausw.Options then
    begin
      Ausw_Caption := '';  //keine alten Filterdaten
      UserEditChange(self);
    end;
  finally
    TmpList.Free;
  end;
end;

(*** Hilfsroutinen ***********************************************************)

procedure TDlgAusw.UserEditChange(Sender: TObject);
// setzt Bemerkungsfeld zusammen aus Ausw.Caption und Suchkriterien
var
  I, P: integer;
  S: string;
  AValue, ALabel_Name, AEdit_Name: string;
  ALabel: TLabel;
  AEdit: TEdit;
begin
  S := Ausw_Caption;
  //for I := 0 to ScrollBoxUser.ControllCount - 1 do
  for I:= 0 to Ausw.UserFields.Count-1 do
  begin
    AValue := OnlyFieldName(Ausw.UserFields.Value(I));  //Jahr=Tbl.EDT;ADT;sonst
    P := Pos(';', AValue);
    if P > 0 then
      System.Delete(AValue, P, MaxInt);

    ALabel_Name := SLaUsr + StrToValidIdent(AValue);
    AEdit_Name := SEdUsr + StrToValidIdent(AValue);
    ALabel := self.FindComponent(ALabel_Name) as TLabel;
    AEdit := self.FindComponent(AEdit_Name) as TEdit;
    if (Trim(AEdit.Text) <> '') and
       (Trim(AEdit.Text) <> '%') and
       (Trim(AEdit.Text) <> '*') then  //07.04.14
      AppendTok(S, ALabel.Caption + ': ' + AEdit.Text, ' · ');
  end;

  EdCaption.Text := S;
end;

function TDlgAusw.DateFmt: string;
var
  P: integer;
begin
  case rgDtm.ItemIndex of
    1: result := SysParam.MonthDateFormat;        {'yyyy-mm'; Monat}
    2: result := 'yyyy';             {Jahr}
  else {0, -1:}
    result := FormatSettings.ShortDateFormat;    {Tag}
    P := Pos('yyyy', result);
    if P <= 0 then
    begin
      P := Pos('yy', result);
      if P > 0 then
        System.Insert('yy', result, P);      {ddmmyy -> ddmmyyyy}
    end;
  end;
end;

procedure TDlgAusw.SetDtmVon(Value: TDateTime);
begin
  FDtmVon := Value;
  EdDtmVon.Text := FormatDateTime(DateFmt, Value);
  if (Value > DtmBis) or (EdDtmBis.Text = '') or not EdDtmBis.Visible then
    DtmBis := Value;
end;

procedure TDlgAusw.SetDtmBis(Value: TDateTime);
begin
  if Value < DtmVon then
    FDtmBis := DtmVon else
    FDtmBis := Value;
  EdDtmBis.Text := FormatDateTime(DateFmt, FDtmBis);
  {if EdDtmBis.Text = EdDtmVon.Text then
    EdDtmBis.Text := '';   04.12.04}
end;

procedure TDlgAusw.UserButton1Click(Sender: TObject);
begin
  Prepare;                   {Felder nach Ausw}
  Ausw.DoUserButton1Click(Sender);
end;

procedure TDlgAusw.LuBtnClick(Sender: TObject);
var
  AEdit: TEdit;
  ALabel: TLabel;
  AField: TField;
  AAsw: TAsw;
  ANavLink: TNavLink;
  AFieldName, AValue, Fields: string;
  I: integer;
  S1: string;
begin
  {ProtM('%s klicked',[(Sender as TBitBtn).Name]);}
  if Ausw = nil then
    exit;
  ANavLink := DsGetNavLink(Ausw.DataSource);
  AFieldName := copy((Sender as TBitBtn).Name, 4, 200);
  AField := ANavLink.DataSet.FieldByName(AFieldName);
  AEdit := FindComponent(SEdUsr + AFieldName) as TEdit;  //17.10.13 hier
  ALabel := FindComponent(SLaUsr + AFieldName) as TLabel;
  AValue := '';

  if AField.Tag > 0 then       {Asw}
  begin
    AAsw := Asws.Asw(AField.Tag);
    if AAsw.NiceItems.Count > 2 then
    begin                                    // 'Auswahl'
      S1 := AAsw.UnFormatFilter(AEdit.Text);
      if TDlgAswCl.ExecVal(AAsw.AswName, ALabel.Caption, S1) then
      begin
        AValue := AAsw.FormatFilter(S1);
        if AValue = '' then
          AEdit.Text := '';
      end;
    end else
    begin  //vor 17.10.13. Jetzt nur noch für JaNein u.ä.
      AValue := TDlgAsw.Execute(AAsw.AswName, ALabel.Caption);
      AValue := AAsw.FindValue(AValue);
    end;
  end else
  begin
    Fields := Ausw.UserFields.Values[ALabel.Caption];
    {Schwenk:}
    Prepare;                   {Felder nach Ausw}
    //OldActive := ANavLink.DataSet.Active;           //geöffnet bleiben nach Lov 10.02.03 QDispo
    ANavLink.Bemerkung.Assign(ANavLink.FltrList);                      {Sichern}
    try
      ANavLink.FltrList.MergeStrings(Ausw.FltrList);        //kopiert nur wenn ungleich
      if (Ausw.DfltDate = ddNone) and (Ausw.DateField <> '') then
        ANavLink.FltrList.SetChangedValue(Ausw.DateField, '');
      ANavLink.FltrList.SetChangedValue(AFieldName, '');         {aktuelles Feld nicht mit Filter}
      AValue := LovDlg(DsGetNavLink(Ausw.DataSource), Fields);
    finally
      ANavLink.FltrList.Assign(ANavLink.Bemerkung);                 {Restaurieren}
      //ANavLink.DataSet.Active := OldActive;
    end;
  end;
  if AValue <> '' then
  begin
    if (length(AEdit.Text) = 0) or
       IsAlphaNum(AEdit.Text[length(AEdit.Text)]) or
       (AEdit.Text[length(AEdit.Text)] <> ';') then  //29.10.13: nur or ergänzen
      AEdit.Text := '';
    for I := 1 to length(AValue) do
      SendMessage(AEdit.Handle, WM_CHAR, WPARAM(AValue[I]), 0);
      {AEdit.Text := AEdit.Text + AValue else
      AEdit.Text := AValue;}
  end;
end;

procedure TDlgAusw.DoPrn(Preview: boolean);
var
  OldCopyFltr, OldOneRecord: boolean;
begin
  InDoPrn := true;
  if Ausw <> nil then
  try
    Prepare;
    OldCopyFltr := Ausw.CopyFltr;
    OldOneRecord := Ausw.OneRecord;
    try
      Ausw.CopyFltr := false;
      Ausw.OneRecord := false;
      Ausw.Preview := Preview;
      if Ausw.CloseAction = caFree then
        Height := 0;
      Ausw.DoPrn;
    finally
      Ausw.CopyFltr := OldCopyFltr;
      Ausw.OneRecord := OldOneRecord;
      if Ausw.CloseAction <> caNone then
        Close;
    end;
  finally
    InDoPrn := false;
  end else
  begin
    ErrWarn('%s', [SPsrc_Kmp_011]);  //'Ausdruck kann nicht mehr gestartet werden'
    Close;
  end;
end;

function TDlgAusw.NiceDate(S: string): string;
begin
  Result := S;
  if Pos('-', S) = 5 then  //2009-10 -> Oktober 2009
  try
    Result := Format('%s %s', [FormatSettings.LongMonthNames[StrToInt(Copy(S, 6, 2))], Copy(S, 1, 4)]);
  except
  end;
end;

procedure TDlgAusw.Prepare;
(* Eingaben nach Ausw.FltrList speichern *)
var
  AEdit: TEdit;
  ATag: longint;
  AFieldName, AFilterValue, NextS: string;
  AYear, AMonth, ADay: word;
  I: integer;
  Error: boolean;
begin
  if (ActiveControl = EdDtmVon) or (ActiveControl = EdDtmBis) then
    EdDtmExit(ActiveControl);
  if Ausw = nil then
    Exit;
  Ausw.Caption := EdCaption.Text;

  for I:= 0 to Ausw.UserFields.Count-1 do
  begin
      if (Trim(Ausw.UserFields[I]) = '') or BeginsWith(Ausw.UserFields[I], ';') then
      continue;
    AFieldName := OnlyFieldName(PStrTok(Ausw.UserFields.Value(I), ';,', NextS));
    if AFieldName[1] = ':' then
      continue;                            {kein DB Feld}
    AEdit := FindComponent(SEdUsr + AFieldName) as TEdit;
    try
      ATag := Ausw.DataSource.DataSet.FieldByName(AFieldName).Tag;
    except
      ATag := 0;
    end;
    if ATag > 0 then            { Auswahlfeld }
    begin
//17.10.13 ersetzt durch Asw-Standardfunktion
//      AFilterValue := '';
//      S1 := '';
//      S2 := TranslateSql(AEdit.Text);
//      for I1 := 1 to length(S2) do
//      begin
//        if CharInSet(S2[I1], ['%', '?'] + OptTokens + BlockTrenner) then  {def.in nstr_kmp}
//        begin
//          if S1 <> '' then
//          begin
//            AFilterValue := AFilterValue + Asws.Asw(ATag).FindParam(S1);
//            S1 := '';
//          end;
//          AFilterValue := AFilterValue + S2[I1];  //bis 17.10.13 beware AEdit.Text[I1];
//        end else
//          S1 := S1 + S2[I1];
//      end;
//      if S1 <> '' then
//        AFilterValue := AFilterValue + Asws.Asw(ATag).FindParam(S1);
      AFilterValue := Asws.Asw(ATag).UnFormatFilter(AEdit.Text);
    end else
      AFilterValue := AEdit.Text;
    Ausw.FltrList.Values[AFieldName] := AFilterValue;
  end;
  if (Ausw.DfltDate <> ddNone) then  //29.10.09 weg and (Ausw.DateField <> '') then
  begin
    AFieldName := Ausw.DateField;
    DecodeDate(DtmVon, AYear, AMonth, ADay);
    case rgDtm.ItemIndex of
      1: if SysParam.FirstDayOfMonth > 1 then            {Monat}
         begin
           ADay := SysParam.FirstDayOfMonth;
           Dec(AMonth);
           if AMonth < 1 then
           begin
             Dec(AYear);
             AMonth := 12;
           end;
         end else
           ADay := 1;
      2: if SysParam.FirstDayOfMonth > 1 then            {Jahr}
         begin
           ADay := SysParam.FirstDayOfMonth;
           AMonth := 12;
           Dec(AYear);
         end else
         begin
           ADay := 1;
           AMonth := 1;
         end;
    end;
    Error := true;
    while Error do
    try
      Ausw.DtmVon := EncodeDate(AYear, AMonth, ADay);
      Error := false;
    except
      ADay := ADay - 1;
      if ADay < 28 then
        raise;
    end;
    if (EdDtmBis.Text <> '') and EdDtmBis.Visible and
       (EdDtmBis.Text <> EdDtmVon.Text) then //04.12.04
    begin
      Ausw.DateStr := Format('%s bis %s', [NiceDate(EdDtmVon.Text), NiceDate(EdDtmBis.Text)]);
      DecodeDate(DtmBis, AYear, AMonth, ADay);
    end else
      Ausw.DateStr := NiceDate(EdDtmVon.Text);
    case rgDtm.ItemIndex of
      1: if SysParam.FirstDayOfMonth > 1 then            {Monat}
         begin
           Inc(AMonth);
           if AMonth > 12 then
           begin
             Inc(AYear);
             AMonth := 1;
           end;
           ADay := SysParam.FirstDayOfMonth - 1;
         end else
           ADay := DaysOfMonth(AYear, AMonth);
      2: if SysParam.FirstDayOfMonth > 1 then            {Jahr}
         begin
           Inc(AMonth);
           if AMonth > 12 then
           begin
             Inc(AYear);
             AMonth := 1;
           end;
           ADay := SysParam.FirstDayOfMonth - 1;
           AMonth := 12;
         end else
         begin
           ADay := 31;
           AMonth := 12;
         end;
    end;
    Ausw.DtmBis := EncodeDate(AYear, AMonth, ADay);
    {Ausw.DtmVon := Y2Date(Ausw.DtmVon);
    Ausw.DtmBis := Y2Date(Ausw.DtmBis);           GEN.WRep}
    if Ausw.DateTime then         {warum nicht immer true ?. wg. FltrEqal Abfragen}
    begin
      {if Ausw.DtmVon = Ausw.DtmBis then
        Ausw.DtmBis := Ausw.DtmVon + EncodeTime(23,59,59,99) else
        Ausw.DtmBis := Ausw.DtmBis + EncodeTime(23,59,59,99);
      AFilterValue := DateTimeToStr(Ausw.DtmVon) + '~' +
                      DateTimeToStr(Ausw.DtmBis);       nicht bei ora}
      AFilterValue := Format('%s~<%s',
        [DateTimeToStrY2(Ausw.DtmVon), DateTimeToStrY2(Ausw.DtmBis + 1)]);
    end else
    if Ausw.DtmVon = Ausw.DtmBis then
      AFilterValue := DateToStrY2(Ausw.DtmVon) else
      AFilterValue := Format('%s~%s',
        [DateToStr4(Ausw.DtmVon), DateToStr4(Ausw.DtmBis)]);    {100500 Y2}
    if AFieldName <> '' then
      Ausw.FltrList.Values[AFieldName] := AFilterValue;
  end else
  begin    {ddNone}
    Ausw.DateStr := '';
    AFieldName := Ausw.DateField;
    if AFieldName <> '' then
      Ausw.FltrList.Values[AFieldName] := '';
  end;
end;

(*** Auswertungen ************************************************************)

procedure TDlgAusw.BCCheckReadOnly(var Message: TWMBroadcast);
begin
  //Farbe nicht ändern.
  //Standardverhalten von TqForm ändern.
end;

procedure TDlgAusw.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDlgAusw.BtnSetupClick(Sender: TObject);
begin
  if Ausw <> nil then
    SetUpPrinter(Ausw.DruckerTyp);
end;

procedure TDlgAusw.BtnScrClick(Sender: TObject);
// sicher vor Polling
begin
  PollKmp.PollMessage(Handle, WM_COMMAND, 0, BtnScr1.Handle);
end;

procedure TDlgAusw.BtnScr1Click(Sender: TObject);
begin
  try
    Screen.Cursor := crHourGlass;
    BtnScr.Enabled := false;
    DoPrn(true);
  finally
    Screen.Cursor := crDefault;
    BtnScr.Enabled := true;
  end;
end;

procedure TDlgAusw.BtnPrnClick(Sender: TObject);
begin
  try
    Screen.Cursor := crHourGlass;
    BtnPrn.Enabled := false;
    DoPrn(false);
  finally
    Screen.Cursor := crDefault;
    BtnPrn.Enabled := true;
  end;
end;

procedure TDlgAusw.chbClick(Sender: TObject);
begin
  if Ausw <> nil then
    if TCheckBox(Sender).Checked then
      Ausw.Checked := Ausw.Checked + [TCheck(TCheckBox(Sender).Tag)] else
      Ausw.Checked := Ausw.Checked - [TCheck(TCheckBox(Sender).Tag)];
end;

(*** Ereignisse **************************************************************)

procedure TDlgAusw.rgDtmClick(Sender: TObject);
begin
  if not InrgDtmClick then
  try
    InrgDtmClick := true;
    Ausw.DateGroup := TDateGroup(rgDtm.ItemIndex);
//    case rgDtm.ItemIndex of
//      0: begin
//           DateFmt := ShortDateFormat;    {Tag}
//           P := Pos('yyyy', DateFmt);
//           if P <= 0 then
//           begin
//             P := Pos('yy', DateFmt);
//             if P > 0 then
//               System.Insert('yy', DateFmt, P);      {ddmmyy -> ddmmyyyy}
//           end;
//         end;
//      1: DateFmt := SysParam.MonthDateFormat;        {'yyyy-mm'; Monat}
//      2: DateFmt := 'yyyy';             {Jahr}
//    end;
    DtmVon := DtmVon;
    DtmBis := DtmBis;
  finally
    InrgDtmClick := false;
  end;
end;

procedure TDlgAusw.BtnDtmClick(Sender: TObject);
begin
  if TDatumBtn(Sender).ModalResult = mrOK then
  begin
    if Sender = BtnDtmVon then
      DtmVon := TDatumBtn(Sender).Datum else
      DtmBis := TDatumBtn(Sender).Datum;
  end else
  begin
    if Sender = BtnDtmVon then
      DtmVon := date else
      DtmBis := DtmVon;
  end;
end;

procedure TDlgAusw.BtnDtmEnter(Sender: TObject);
begin
  if Sender = BtnDtmVon then
    (Sender as TDatumBtn).Datum := DtmVon else
    (Sender as TDatumBtn).Datum := DtmBis;
end;

procedure TDlgAusw.EdCaptionChange(Sender: TObject);
begin
debug0;
end;

procedure TDlgAusw.EdDtmExit(Sender: TObject);
var
  AEdit: TEdit;
  Jahr, Monat, Tag, Fmt: string;
  AYear, AMonth, ADay: word;
  I: integer;
begin
  if SysParam.ProtBeforeOpen then
  begin  //Testausgabe
    for I := 0 to self.ComponentCount - 1 do
    begin
      ProtA('%d %s %s', [I, OwnerDotName(self.Components[I]), self.Components[I].ClassName]);
      if self.Components[I] is TEdit then
        with self.Components[I] as TEdit do
        begin
          ProtA('Visible:%d, Bounds(%d,%d,%d,%d)', [ord(Visible), Left, Top, Width, Height]);
          if Width = 0 then
            Width := 121;
        end;
    end;
  end;

  AEdit := (Sender as TEdit);
  if AEdit.Modified then
  begin
    if DateFmt = FormatSettings.ShortDateFormat then
    try
      if AEdit = EdDtmVon then
        DtmVon := StrToDateY2(EdDtmVon.Text) else
        DtmBis := StrToDateY2(StrDflt(EdDtmBis.Text, EdDtmVon.Text));
    except on E:Exception do
      EMess(self, E, 'Falsches Datum', [0]);
    end else
    begin
      if AEdit = EdDtmVon then
        DecodeDate(DtmVon, AYear, AMonth, ADay) else
        DecodeDate(DtmBis, AYear, AMonth, ADay);
      Jahr := '';
      Monat := '';
      Tag := '';
      Fmt := StrCgeChar(StrCgeChar(DateFmt, '''', #0), '"', #0);
      for I:= 1 to IMin(length(Fmt), length(AEdit.Text)) do
        case UpCase(Fmt[I]) of
          'Y': Jahr := Jahr + AEdit.Text[I];
          'M': Monat := Monat + AEdit.Text[I];
          'D': Tag := Tag + AEdit.Text[I];
        end;
      if Jahr <> '' then AYear := StrToInt(Jahr);
      if Monat <> '' then AMonth := StrToInt(Monat);
      if Tag <> '' then ADay := StrToInt(Tag);
      ADay := IMin(ADay, DaysOfMonth(AYear, AMonth));
      if AEdit = EdDtmVon then
        DtmVon := EncodeDate(AYear, AMonth, ADay) else
        DtmBis := EncodeDate(AYear, AMonth, ADay);
    end;
    AEdit.Modified := false;
  end;
  if (EdDtmBis.Text = '') or not EdDtmBis.Visible then
    DtmBis := DtmVon;
end;

procedure TDlgAusw.MiLookUpClick(Sender: TObject);
(* Reaktion auf F2 *)
begin
  if ActiveControl = EdDtmVon then
  begin
    EdDtmExit(ActiveControl);
    BtnDtmEnter(BtnDtmVon);
    BtnDtmVon.Click;
  end else
  if ActiveControl = EdDtmBis then
  begin
    EdDtmExit(ActiveControl);
    BtnDtmEnter(BtnDtmBis);
    BtnDtmBis.Click;
  end else
  if (ActiveControl is TEdit) and
     (copy(TEdit(ActiveControl).Name, 1, 5) = SEdUsr) then
  begin
    (FindComponent('Btn'+ copy(TEdit(ActiveControl).Name, 6, 200))
      as TBitBtn).Click;
  end else
    Nav.DoLookUp(lumTab);
end;

end.
