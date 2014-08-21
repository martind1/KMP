unit FltrFrm;
(*
  Abfragen in Datenbank speichern und verwalten
  18.05.00     Alle im Tabset
  20.10.03 MD  UseFltr: in LuDef.Options bewirkt dass auch bei Lookup die
                        letzte Abfrage verwendet wird.
  25.06.06 MD  Abfragen vorgeben mit AddFltr
               Bsp: TFrmFltr.cobFltrInit(cobFltr,
                      TFrmFltr.AddFltr('Krefeld', 'LAGER_NR=85', '',
                      TFrmFltr.AddFltr('Hamm', 'LAGER_NR=100', '', nil)));
               mehrere Filterzeilen mit \r trennen
  31.07.08 MD  Tabellenlayout optional mitspeichern. Feld COLUMNLIST
  06.08.08 MD  Usergruppen: ERFASST_VON like % + SysParam.UserName + %
  29.11.09 MD  Bug fixed: beim Speichern ging Zielfenster auf Single-Seite
  19.12.09 MD  Der Ausdruck 'KeyFields=FLD1' in FltrList wird als KeyFields erkannt
  05.02.10 MD  (Alle) jetzt als ResourceString 'SFltrFrm_001'
  16.03.10 MD  InternalcobFltrInit, InternalFltrChange (zak eanv)
  21.12.13 md  per add_fltr übergebene Filter in DB aktualisieren (falls geändert)
               Achtung:In Anw berücksichtigen (webab#erec_bvor#Nacherfassung)
               Tabellenlayout nicht ändern
  20.05.14 md  Abfrage Formfilter mit :Parameter wegen Unicode+Umlate

---------------------------------------------
Idee: Abfragen auch für LookUp-Multigrids

{ erl AddFltr() erweitern mit ColumnList }

- Get: IniSection muss Standard sein
  Unterscheidung Fltr-IniSection und Standard-Inisection
  Standard-IniSection zwischenspeichern und restaurieren wenn
    Abfrage = (alle) oder Abfrage hat kein Tabellenlayout.

  Abfrage mit TLayout ausgewählt: setzte IniSection='Temp'
    Temp.. ist Spezialname und lädt/speichert nicht permanent in Ini.
  Keine Abfrage oder Abfrage ohne TL ausgewählt (und Temp.. aktiv):
    setzte IniSection=LoadedIniSection. Erstmal ''.

MSSQL:
ALTER TABLE FLTR add COLUMNLIST text null;


*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, UQue_Kmp, DBAccess, MemDS, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  Luedikmp, Lubtnkmp, NLnk_Kmp, qLab_kmp, Asws_Kmp;

type
  TFrmFltr = class(TqForm)
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    PsDflt: TPrnSource;
    PageBook: TqNoteBook;
    Panel1: TPanel;
    Mu1: TMultiGrid;
    ScrollBox1: TScrollBox;
    DetailBook: TTabbedNotebook;
    EdBEMERKUNG: TDBMemo;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Bevel4: TBevel;
    EditERFASST_VON: TDBEdit;
    EditERFASST_AM: TDBEdit;
    EditGEAENDERT_VON: TDBEdit;
    EditGEAENDERT_AM: TDBEdit;
    EditANZAHL_AENDERUNGEN: TDBEdit;
    gbIntern: TGroupBox;
    qLabel2: TqLabel;
    qLabel3: TqLabel;
    qLabel1: TqLabel;
    EdNAME: TDBEdit;
    qLabel4: TqLabel;
    EdFLTRLIST: TDBMemo;
    qLabel5: TqLabel;
    EdKEYFIELDS: TDBEdit;
    PanBottom: TPanel;
    LTabSet1: TLTabSet;
    PanRight: TPanel;
    BtnSpeichern: TBitBtn;
    cobFORM: TDBComboBox;
    Label1: TLabel;
    edFLTR_ID: TDBEdit;
    chbISPUBLIC: TAswCheckBox;
    chbAlle: TCheckBox;
    edCOLUMNLIST: TDBMemo;
    Panel2: TPanel;
    chbColumnList: TCheckBox;
    Query1: TuQuery;   BtnTestError: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NavRech(ADataSet: TDataSet; Field: TField;
      OnlyCalcFields: Boolean);
    procedure LDataSource1UpdateData(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LTabSet1Click(Sender: TObject);
    procedure BtnSpeichernClick(Sender: TObject);
    procedure NavSetTitel(Sender: TObject; var Titel, Titel2: TCaption);
    procedure NavPostStart(Sender: TObject);
    procedure Mu1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NavBuildSql(DataSet: TDataSet; var OK, fertig: Boolean);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure chbAlleClick(Sender: TObject);
    procedure Query1AfterOpen(DataSet: TDataSet);
    procedure NavStart(Sender: TObject);
    procedure BtnTestErrorClick(Sender: TObject);
  protected
  private
    { Private-Deklarationen }
    FormKurz: string;
    NavLink: TNavLink;
    FormSubCaption: TCaption;
    FormCaption: TCaption;
    InBtnAktualisieren: boolean;
    IsColumnList: boolean;
    class procedure InternalcobFltrInit(UseFltr, PreserveFltr: boolean;
      Sender: TComboBox; DfltFltr: TStrings);
    class procedure InternalFltrChange(Sender: TObject; PreserveFltr: boolean);
    class procedure InternalCobFltrChange(ALNav: TLNavigator;
  AName, AUser: string; PreserveFltr: boolean);
  public
    { Public-Deklarationen }
    class procedure LookUp(FormKurz: string; ANavLink: TNavLink; aName: string = '');
    class function AddFltr(aName, aFltrStr, aKeyFields: string;
      DfltFltr: TStrings): TStrings;
    class procedure cobFltrClear(Sender: TObject);
    class procedure cobFltrInitLU(Sender: TComboBox; DfltFltr: TStrings = nil);
    class procedure cobFltrInit(Sender: TComboBox; DfltFltr: TStrings = nil);
    class procedure cobFltrChange(Sender: TObject);
    class procedure cobFltrFill(Sender: TComboBox; FormKurz: string;
      DfltFltr: TStrings = nil);
    class procedure FltrChange(ALNav: TLNavigator; AName: string);
    class function AlleStr: string;  //ergibt '(alle)'
  end;

var
  FrmFltr: TFrmFltr;

implementation
{$R *.DFM}
uses
  Dialogs,
  GNav_Kmp, Prots, Ini__Kmp, Err__Kmp, AbortDlg, Sql__Dlg, DPos_Kmp,
  MainFrm, ParaFrm, FltrDlg, KmpResString;
type
  TFltrData = record
    FormKurz: string;
    NavLink: TNavLink;
    FormSubCaption: TCaption;
    FormCaption: TCaption;
    Name: string;
  end;
  PFltrData = ^TFltrData;
var
  FltrData: TFltrData;
  DfltFltrStr: string;

class function TFrmFltr.AlleStr: string;
begin
  Result := SFltrFrm_001;  //'(alle)'
end;

class function TFrmFltr.AddFltr(aName, aFltrStr, aKeyFields: string; DfltFltr: TStrings): TStrings;
//Vorgabe Filter angeben. Aufruf cascadierbar AddFltr(...,AddFltr(...,nil)).
//  und als 2.Parameter für cobFltrInit verwendbar
//  Aufbau eines Records: <Name>#<Keyfields>, Object=TFltrList
//  aFltrStr: <Feld1>=<Krits1> \r <Feld2>=<Krits2>;...
{ Beispiel:
  TFrmFltr.cobFltrInit(cobFltr,
    TFrmFltr.AddFltr('Krefeld', 'LAGER_NR=85', '',
    TFrmFltr.AddFltr('*Hamm', 'LAGER_NR=100', '', nil))); }
var
  FltrList: TFltrList;
  S1: string;
begin
  result := DfltFltr;
  if result = nil then
    result := TStringList.Create;
  FltrList := TFltrList.Create;
  FltrList.AddTokens(AFltrStr, ['\r'], true);  //mit Trim. 27.08.07 von ; nach \r
  S1 := FltrList.Values['KeyFields'];
  if S1 <> '' then
  begin
    if aKeyFields = '' then
      aKeyFields := S1;
    FltrList.Values['KeyFields'] := '';
  end;
  result.AddObject(Trim(aName) + '#' + Trim(aKeyFields), FltrList);
end;

class procedure TFrmFltr.cobFltrFill(Sender: TComboBox; FormKurz: string;
  DfltFltr: TStrings = nil);
//Füllen der Combobox mit Abfragen des Forms und Users
var
  ADatabase: TUniConnection;
  AQuery: TUQuery;
  TblName: string;
  I, J: integer;
  S1, NextS: string;
  DoIt, Found: boolean;
  KEYFIELDS, FLTRLIST: string;
begin
  ADataBase := QueryDatabase(IniKmp.ReadString('FLTR', 'DatabaseName', 'DB1')); //ALNav.NavLink.Query.DataBaseName;
  AQuery := TUQuery.Create(ADataBase);
  try
    //create AQuery.DataBaseName := IniKmp.ReadString('FLTR', 'DatabaseName', 'DB1'); //ALNav.NavLink.Query.DataBaseName;
    TblName := GetStringsString(GNavigator.TableSynonyms, 'FLTR', 'FILTERABFRAGEN');
    AQuery.Sql.Add('select * from ' + TblName); //FILTERABFRAGEN');
    AQuery.Sql.Add('where (FORM = ''' + FormKurz + ''')');
    // mehrere Erfasst_Von: User1;User2;User3
    AQuery.Sql.Add('and ((ERFASST_VON like ''%' + SysParam.UserName + '%'')');
    AQuery.Sql.Add(' or  (ISPUBLIC is null)');
    AQuery.Sql.Add(' or  (ISPUBLIC = ''J''))');
    AQuery.Sql.Add('order by NAME');
    Sender.Items.Clear;
    {weiter unten - Sender.Items.Add('(alle)');}
    //N := 1;
    try
      AQuery.Open;
    except on E:Exception do begin
        EProt(AQuery, E, 'TFrmFltr.cobFltrInit(%s)', [TblName]);
        if TblName <> 'FLTR' then
        try
          GNavigator.TableSynonyms.Values['FLTR'] := 'FLTR';
          AQuery.Sql[0] := 'select * from FLTR';
          AQuery.Open;
        except on E1:Exception do
          EProt(AQuery, E1, 'TFrmFltr.cobFltrInit(%s)', [TblName]);
        end;
      end;
    end;
    GNavigator.Canceled := false;
    while not AQuery.EOF and not GNavigator.Canceled do
    begin
      Sender.Items.Add(AQuery.FieldByName('NAME').AsString);
      AQuery.Next;
    end;
    //21.12.13 AQuery.Close;
    if DfltFltr <> nil then
    try
      //21.12.13 BDE - AQuery.RequestLive := true;
      //21.12.13 weg! AQuery.Open;
      for I := 0 to DfltFltr.Count - 1 do
      begin
        S1 := PStrTok(DfltFltr[I], '#', NextS);
        if BeginsWith(S1, '*') then
        begin
          S1 := copy(S1, 2, Maxint);
          DfltFltrStr := S1;
        end;
        DoIt := true;
        for J := 0 to Sender.Items.Count - 1 do
          if CompareText(Sender.Items[J], S1) = 0 then
          begin
            DoIt := false;      //Eintrag existiert bereits
            //Query positionieren: 21.12.13
            AQuery.First;
            while not SameText(AQuery.FieldByName('NAME').AsString, S1) and
                  not AQuery.Eof do
              AQuery.Next;
          end;
        KEYFIELDS := PStrTok('', '#', NextS);
        FLTRLIST := RemoveTrailCrlf(TStrings(DfltFltr.Objects[I]).Text);
        if DoIt then
        begin
          AQuery.Insert;
          AQuery.FieldByName('FORM').AsString := FormKurz;
          AQuery.FieldByName('ERFASST_VON').AsString := SysParam.UserName;
          AQuery.FieldByName('ISPUBLIC').AsString := 'J';   //??? 24.03.07 '=;J';
          AQuery.FieldByName('NAME').AsString := S1;
          AQuery.FieldByName('BEMERKUNG').AsString := 'Vorgabe';
        end else
        begin
          if (KEYFIELDS <> AQuery.FieldByName('KEYFIELDS').AsString) or
             (FLTRLIST <> AQuery.FieldByName('FLTRLIST').AsString) then
          begin
            AQuery.Edit;
            AQuery.FieldByName('BEMERKUNG').AsString := 'Edit Vorgabe';
          end;
        end;
        if AQuery.State in DsEditModes then
        begin
          AQuery.FieldByName('KEYFIELDS').AsString := KEYFIELDS;
          SetFieldStrings(AQuery.FieldByName('FLTRLIST'), TStrings(DfltFltr.Objects[I]));
          { TODO :
            Konstruktion mit TFltrObj:
            SetFieldStrings(AQuery.FieldByName('COLUMNLIST'), TFltrObj(DfltFltr.Objects[I]).ColumnList); }
          GNavigator.DoBeforePost(AQuery);  //FLTR_ID generieren
          AQuery.Post;
        end;
        if DoIt then
        begin
          Sender.Items.Add(AQuery.FieldByName('NAME').AsString);
        end;
//        if DoIt then
//        begin
//          AQuery.Insert;
//          AQuery.FieldByName('FORM').AsString := FormKurz;
//          AQuery.FieldByName('ERFASST_VON').AsString := SysParam.UserName;
//          AQuery.FieldByName('ISPUBLIC').AsString := 'J';   //??? 24.03.07 '=;J';
//          AQuery.FieldByName('NAME').AsString := S1;
//          AQuery.FieldByName('KEYFIELDS').AsString := PStrTok('', '#', NextS);
//          SetFieldStrings(AQuery.FieldByName('FLTRLIST'), TStrings(DfltFltr.Objects[I]));
//          { TODO :
//            Konstruktion mit TFltrObj:
//            SetFieldStrings(AQuery.FieldByName('COLUMNLIST'), TFltrObj(DfltFltr.Objects[I]).ColumnList); }
//          AQuery.FieldByName('BEMERKUNG').AsString := 'Vorgabe';
//          GNavigator.DoBeforePost(AQuery);  //FLTR_ID generieren
//          AQuery.Post;
//          Sender.Items.Add(AQuery.FieldByName('NAME').AsString);
//        end;
      end;
      FreeObjects(DfltFltr);
    except on E:Exception do
      EProt(Sender, E, 'Fehler bei cobFltrInit', [0]);
    end;
    Found := false;
    for I := 0 to Sender.Items.Count - 1 do
      if AnsiSameText(Sender.Items[I], TFrmFltr.AlleStr) then  //'(ALLE)'
        Found := true;
    if not Found then
      Sender.Items.Insert(0, TFrmFltr.AlleStr);  //'(alle)'
    Sender.DropDownCount := 60; //IMax(8, N + 1);
  finally
    AQuery.Free;
  end;
end;

class procedure TFrmFltr.cobFltrInitLU(Sender: TComboBox; DfltFltr: TStrings = nil);
begin
  InternalcobFltrInit(true, true, Sender, DfltFltr);  //UseFltr=true, PreserveFltr=true
end;

class procedure TFrmFltr.cobFltrInit(Sender: TComboBox; DfltFltr: TStrings = nil);
var
  ALNav: TLNavigator;
  UseFltr: boolean;
begin
  ALNav := FormGetLNav(Sender.Owner);
  UseFltr := true;
  if ALNav.ReturnAktiv then
  begin
    if (ALNav.ReturnLuDef <> nil) and (ALNav.ReturnLuDef is TLookUpDef) then
      UseFltr := luUseFltr in TLookUpDef(ALNav.ReturnLuDef).Options else
      UseFltr := false;
  end;
  InternalcobFltrInit(UseFltr, false, Sender, DfltFltr);
end;

class procedure TFrmFltr.InternalcobFltrInit(UseFltr, PreserveFltr: boolean; Sender: TComboBox;
  DfltFltr: TStrings);
//Initialisierung der Abfrage Funktionalität. In NavStart aufzurufen.
//DfltFltr werden im HS entfernt (Free)
var
  ALNav: TLNavigator;
begin
  DfltFltrStr := '';
  ALNav := FormGetLNav(Sender.Owner);
  cobFltrFill(Sender, ALNav.FormKurz, DfltFltr);
  if not Assigned(FrmFltr) or not FrmFltr.InBtnAktualisieren then
  try        //nicht wenn Benutzer neuen Filter speichert
    if UseFltr then
    begin
      if DfltFltrStr <> '' then
        Sender.ItemIndex := IMax(0, Sender.Items.IndexOf(DfltFltrStr))
      else
        Sender.ItemIndex := IMax(0, IniKmp.ReadInteger(TqForm(Sender.Owner).Kurz, Sender.Name, 0));
      //ComboBoxChange(Sender);
      InternalFltrChange(Sender, PreserveFltr);
    end;  // else   14.03.05 immer wg Änderung in cob Fltr Change
    ALNav.DataSet.Open;
  except on E:Exception do begin
      EProt(Sender, E, 'Fehler bei Filterabfrage initialisieren', [0]);
      ProtA('%s', [QueryText(ALNav.DataSet, [])]);
    end;
  end;
end;

class procedure TFrmFltr.cobFltrClear(Sender: TObject);
//entfernt Vorgabe der Combobox
begin
  IniKmp.EraseIdent(TqForm(TComboBox(Sender).Owner).Kurz,
      TComboBox(Sender).Name);
end;

class procedure TFrmFltr.cobFltrChange(Sender: TObject);
begin
  InternalFltrChange(Sender, false);
end;

class procedure TFrmFltr.InternalFltrChange(Sender: TObject; PreserveFltr: boolean);
var
  ALNav: TLNavigator;
  AName: string;
begin
  ALNav := FormGetLNav(TComboBox(Sender).Owner);
  AName := TComboBox(Sender).Text;
  InternalCobFltrChange(ALNav, AName, SysParam.UserName, PreserveFltr);
  IniKmp.WriteInteger(TqForm(TComboBox(Sender).Owner).Kurz,
    TComboBox(Sender).Name, TComboBox(Sender).ItemIndex);
end;

class procedure TFrmFltr.FltrChange(ALNav: TLNavigator; AName: string);
begin
  InternalCobFltrChange(ALNav, AName, '', false);
end;

class procedure TFrmFltr.InternalCobFltrChange(ALNav: TLNavigator;
  AName, AUser: string; PreserveFltr: boolean);
var
  AQuery: TUQuery;
  TblName: string;
  OldActive: boolean;    //14.03.05 quva.aufk
  HasColumnList: boolean;
  L: TFltrList;
begin
  OldActive := ALNav.DataSet.Active;
  L := TFltrList.Create;
  AQuery := TUQuery.Create(QueryDatabase(IniKmp.ReadString('FLTR', 'DatabaseName', 'DB1')));  //(TComboBox(Sender).Owner);
  try
    if not Assigned(FrmFltr) or not FrmFltr.InBtnAktualisieren then
    begin
      //create AQuery.DataBaseName := IniKmp.ReadString('FLTR', 'DatabaseName', 'DB1'); //ALNav.NavLink.Query.DataBaseName;
      TblName := GetStringsString(GNavigator.TableSynonyms, 'FLTR', 'FILTERABFRAGEN');
      AQuery.Sql.Add('select * from ' + TblName); //FILTERABFRAGEN');
//      AQuery.Sql.Add('where FORM = ''' + ALNav.FormKurz + '''');
//      AQuery.Sql.Add('and NAME = ''' + AName + '''');
//      AQuery.Sql.Add('and ((ERFASST_VON like ''%' + AUser + '%'')');
      AQuery.Sql.Add('where FORM = :FORM');
      AQuery.Sql.Add('and NAME = :NAME');
      // mehrere Erfasst_Von: User1;User2;User3
      AQuery.Sql.Add('and ((ERFASST_VON like :ERFASST_VON)');
      AQuery.Sql.Add(' or  (ISPUBLIC is null)');
      AQuery.Sql.Add(' or  (ISPUBLIC = ''J''))');
      AQuery.Sql.Add('order by NAME');
      AQuery.ParamByName('FORM').AsString := ALNav.FormKurz;
      AQuery.ParamByName('NAME').AsString := AName;
      AQuery.ParamByName('ERFASST_VON').AsString := '%' + AUser + '%';
      try
        AQuery.Open;
      except on E:Exception do
        begin
          EProt(AQuery, E, 'TFrmFltr.cobFltrChange', [0]);
          if DelphiRunning then
            TDlgSql.Execute(Application, AQuery, false);
        end;
      end;
      HasColumnList := AQuery.FindField('COLUMNLIST') <> nil;
      if not AQuery.EOF then
      begin
        //ALNav.NavLink.KeyFields := AQuery.FieldByName('KEYFIELDS').AsString;
        //ab 10.06.13:
        ALNav.NavLink.KeyFields := StrDflt(AQuery.FieldByName('KEYFIELDS').AsString,
                                           ALNav.NavLink.KeyFields);
        GetFieldStrings(AQuery.FieldByName('FLTRLIST'), L);
        if PreserveFltr then
          ALNav.NavLink.FltrList.MergeStrings(L) else  //alte Filter belassen
          ALNav.NavLink.FltrList.Assign(L);
        if HasColumnList and
           not AQuery.FieldByName('COLUMNLIST').IsNull and
           (ALNav.NavLink.MultiGrid <> nil) then
        begin
          TMultiGrid(ALNav.NavLink.MultiGrid).TempLayout := true;
          GetFieldStrings(AQuery.FieldByName('COLUMNLIST'),
                          TMultiGrid(ALNav.NavLink.MultiGrid).ColumnList);
        end else
          TMultiGrid(ALNav.NavLink.MultiGrid).TempLayout := false;

      end else                       {(alle)}
      begin
        ALNav.NavLink.FltrList.Clear;
        ALNav.NavLink.FltrList.Assign(ALNav.NavLink.LoadedFltrList);  //14.03.05 quva.aufk
        ALNav.NavLink.KeyFields := ALNav.NavLink.LoadedKeyFields;
        ALNav.NavLink.InitKeyFields := false;
        if (ALNav.NavLink.MultiGrid <> nil) then
          TMultiGrid(ALNav.NavLink.MultiGrid).TempLayout := false;  // lädt Layout von Ini neu
      end;
      if ALNav.dsQuery then
        GNavigator.X.SetFltr(ALNav.NavLink.FltrList) else
      if not ALNav.dsChangeAll then
      try
        ALNav.DataSet.Active := OldActive;  //14.03.05 quva.aufk ALNav.DataSet.Open;
      except on E:Exception do
        Prot0('cobFltrChange:%s', [E.Message]);
      end;
      {ALNav.NavLink.Form.Caption := SubCaption(ALNav.NavLink.Form.Caption,
        AQuery.FieldByName('NAME').AsString);
      ALNav.SetTitel;}
      ALNav.SubCaption := AQuery.FieldByName('NAME').AsString;
      Prot0('Abfrage %s: %s', [ALNav.NavLink.Form.ClassName, AQuery.FieldByName('NAME').AsString]);
    end;
    //IniKmp.WriteInteger(TqForm(TComboBox(Sender).Owner).Kurz,
    //  TComboBox(Sender).Name, TComboBox(Sender).ItemIndex);
  finally
    AQuery.Free;
    L.Free;
  end;
end;

class procedure TFrmFltr.LookUp(FormKurz: string; ANavLink: TNavLink; aName: string = '');
//Abfrage speichern
begin
  if (ANavLink = nil) or (ANavLink.nlState = nlInactive) then
  begin
    ErrWarn('kein Formular geöffnet', [0]);
    Exit;
  end;
  if ANavLink.nlState = nlQuery then
  begin
    SendMessage(GNavigator.X.Handle, BC_GNAVCLICK, WPARAM(qnbPost), 0);
  end;
  if ANavLink.nlState <> nlBrowse then
    Exit;
  FltrData.FormKurz := FormKurz;
  FltrData.NavLink := ANavLink;
  FltrData.FormSubCaption := GetSubCaption(ANavLink.Form.Caption);
  FltrData.FormCaption := MainCaption(ANavLink.Form.Caption);
  FltrData.Name := aName;
  if aName <> '' then
  begin
    GNavigator.StartFormData(Application.MainForm, 'FLTR', @FltrData, wsMinimized);
    if FrmFltr = nil then
      Exit;
    {FrmFltr.Nav.DataPos.Clear;  jetzt per Data - 10.08.08
    FrmFltr.Nav.DataPos.Values['NAME'] := aName;
    FrmFltr.Nav.DataPos.GotoPos(FrmFltr.Query1);}
    PostMessage(FrmFltr.Handle, WM_COMMAND, 0, FrmFltr.BtnSpeichern.Handle);
  end else
  begin
    // wenn kein Name angegeben dann BtnSpeichern nicht aufrufen (für FrmMain.Direktaufruf)
    GNavigator.StartFormData(Application.MainForm, 'FLTR', @FltrData, wsNormal);
  end;
end;

procedure TFrmFltr.FormCreate(Sender: TObject);
var
  I: integer;
  S: string;
begin
  FrmFltr := self;
  I := 0;
  cobForm.Items.Clear;
  while true do
  begin
    S := GNavigator.GetFormKurz(I);
    if S = '' then
      break;
    cobForm.Items.Add(S);
    inc(I);
  end;
  FrmPara.OnFormCreate(self);            {Enabled=false, bgIntern.Visible=false}
  if InitData <> nil then
  begin
    FormKurz := PFltrData(InitData)^.FormKurz;
    NavLink := PFltrData(InitData)^.NavLink;
    FormSubCaption := PFltrData(InitData)^.FormSubCaption;
    FormCaption := PFltrData(InitData)^.FormCaption;
    Nav.FltrList.Values['FORM'] := FormKurz;
    Nav.FltrList.Values['NAME'] := PFltrData(InitData)^.Name;  //kann leer sein
  end;
end;

procedure TFrmFltr.NavStart(Sender: TObject);
begin
  Query1.Open;
end;

procedure TFrmFltr.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);            {EdBemerkung anpassen}
  EdKEYFIELDS.Width := EdBemerkung.Width;
  EdFLTRLIST.Width := EdBemerkung.Width;
  EdNAME.Width := EdBemerkung.Width - (EdNAME.Left - EdBemerkung.Left);
end;

procedure TFrmFltr.FormDestroy(Sender: TObject);
begin
  FrmFltr := nil;
end;

procedure TFrmFltr.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmFltr.NavSetTitel(Sender: TObject; var Titel,
  Titel2: TCaption);
begin
  if InitData <> nil then
    Titel := Prots.SubCaption(Titel, FormCaption);
end;

procedure TFrmFltr.NavPostStart(Sender: TObject);
begin
  if Sender <> nil then  //bereits geschlossen?
  try
    Nav.DataPos.Clear;
    Nav.DataPos.Values['NAME'] := FormSubCaption;
    Nav.DataPos.GotoPos(Query1);
  except on E:Exception do
    EProt(self, E, 'PostStart', [0]);
  end;
end;

procedure TFrmFltr.NavRech(ADataSet: TDataSet; Field: TField;
  OnlyCalcFields: Boolean);
var
  HasColumnList: boolean;
begin
  with ADataSet do
  begin
    HasColumnList := FindField('COLUMNLIST') <> nil;
    if OnlyCalcFields then
    begin
    end else
    begin
      if (InitData <> nil) and InBtnAktualisieren then
      begin
        FieldByName('FORM').AsString := FormKurz;
        FieldByName('FLTRLIST').AsString := GetStringsText(NavLink.FltrList);
        FieldByName('KEYFIELDS').AsString := NavLink.KeyFields;

        if HasColumnList and (NavLink.MultiGrid <> nil) then
        begin
          if not IsColumnList then
            FieldByName('COLUMNLIST').Clear else
            SetFieldStrings(FieldByName('COLUMNLIST'),
                            TMultiGrid(NavLink.MultiGrid).ColumnList);
        end;
      end;
    end;
    chbColumnList.Checked := HasColumnList and not FieldByName('COLUMNLIST').IsNull;
    if HasColumnList then
    begin
      if edCOLUMNLIST.DataSource <> LDataSource1 then
        edCOLUMNLIST.DataSource := LDataSource1;
    end;
  end;
end;

procedure TFrmFltr.LDataSource1UpdateData(Sender: TObject);
begin
  if Sender <> LDataSource1 then  with (Sender as TDataSource).DataSet do
  begin                                                        {nur bei Import:}
  end;
end;

procedure TFrmFltr.LTabSet1Click(Sender: TObject);
var
  I: integer;
  AField: TField;
  cobFltr: TComboBox;
  HasColumnList: boolean;
begin
  with Query1 do
  begin
    HasColumnList := FindField('COLUMNLIST') <> nil;
    if (LTabSet1.TabIndex = 1) and (InitData <> nil) then
    begin  // Klick auf '(Alle)'
      NavLink.FltrList.Clear;
      NavLink.KeyFields := NavLink.LoadedKeyFields;
      if NavLink.nlState = nlQuery then
        NavLink.DataSet.ClearFields else
        NavLink.DataSet.Open;
    end else
    if {(LTabSet1.TabIndex = 0)-1 and} (InitData <> nil) then
    begin  // Klick auf 'Übernehmen'
      NavLink.KeyFields := FieldByName('KEYFIELDS').AsString;
      // SetStringsText(NavLink.FltrList, GetFieldValue(FieldByName('FLTRLIST')));
      GetFieldStrings(FieldByName('FLTRLIST'), NavLink.FltrList);
      if HasColumnList and (NavLink.MultiGrid <> nil) then
        GetFieldStrings(FieldByName('COLUMNLIST'), TMultiGrid(NavLink.MultiGrid).ColumnList);
      if NavLink.nlState = nlQuery then
      begin
        for I := 0 to NavLink.FltrList.Count - 1 do              {Werte von FilterList holen}
        begin
          AField := NavLink.DataSet.FindField(OnlyFieldName(NavLink.FltrList.Param(I)));
          if AField <> nil then                               {Entsprechung existiert}
            if AField.Tag > 0 then                                 {bei Auswahlfelder}
              AField.AsString := NavLink.FltrList.Value(I) else
              SetFieldText(AField, NavLink.FltrList.Value(I));             {Value schreiben}
        end;
      end else
        NavLink.DataSet.Open;
      if NavLink.Owner is TLNavigator then
      begin
        NavLink.Form.Caption := Prots.SubCaption(NavLink.Form.Caption,
          FieldByName('NAME').AsString);
        TLNavigator(NavLink.Owner).SetTitel;
        cobFltr := NavLink.Form.FindComponent('cobFltr') as TComboBox;
        if cobFltr <> nil then
        begin
          cobFltrInit(cobFltr);
          cobFltr.ItemIndex := cobFltr.Items.IndexOf(FieldByName('NAME').AsString);
          self.InBtnAktualisieren := false;  //Abfragename sofort in Caption anzeigen
          ComboBoxChange(cobFltr);                  {neue Einstellung verwenden}
        end;
      end;
    end;
  end;
  Close;
end;

procedure TFrmFltr.BtnSpeichernClick(Sender: TObject);
var
  S: string;
  IsPublic, HasColumnList: boolean;
  Users: string;
  WasPublic: boolean;
const
  JN: array[boolean] of char = ('N', 'J');
begin
  S := Query1.FieldByName('NAME').AsString;
  if S = '' then
  begin
    S := FormKurz + ' ' + DateTimeToStr(now);
    IsPublic := false;
  end else
  begin
    IsPublic := Query1.FieldByName('ISPUBLIC').AsString = 'J'; //JaNein_Ja;
  end;
  InBtnAktualisieren := true;
  //if WMessInput(ShortCaption, 'Name der Abfrage:', S) then
  HasColumnList := Query1.FindField('COLUMNLIST') <> nil;
  IsColumnList := HasColumnList and not Query1.FindField('COLUMNLIST').IsNull;
  Users := Query1.FieldByName('ERFASST_VON').AsString;
  if Users = '' then
    Users := SysParam.UserName;
  if TDlgFltr.Execute(S, IsPublic, HasColumnList, IsColumnList, Users) then
  try
    WasPublic := Query1.FieldByName('ISPUBLIC').AsString = 'J';
    if Query1.FieldByName('NAME').AsString <> S then
    begin
      WasPublic := false;
      Nav.FltrList.Clear;                  //gibt es den Namen bereits?
      Nav.FltrList.Values['FORM'] := FormKurz;
      Nav.FltrList.Values['NAME'] := S;
      Query1.Open;
      if Query1.EOF then
      begin
        Nav.DoInsert(IsPublic or WasPublic);  //Rechteüberprüfung nur wenn öffentlich
        Query1.FieldByName('NAME').AsString := S;
      end else
        Nav.DoEdit(IsPublic or WasPublic);  //Rechteüberprüfung nur wenn öffentlich
    end else
      Nav.DoEdit(IsPublic or WasPublic);  //Rechteüberprüfung nur wenn öffentlich
    Query1.FieldByName('ISPUBLIC').AsString := JN[IsPublic];
    if not IsPublic then
    begin
      if Pos(SysParam.UserName, Users) = 0 then
        Users := SysParam.UserName + ';' + Users;
      Query1.FieldByName('ERFASST_VON').AsString := Users;
    end;
    Nav.DoPost;
    LTabSet1.TabIndex := -1;  //Zurück
    LTabSet1Click(Sender);
  except on E:Exception do
    begin
      EProt(self, E, 'TFrmFltr.BtnSpeichern', [0]);
      self.Close;
    end;
  end else
  begin
//    if Nav.FltrList.Values['NAME'] <> '' then
//    begin
//      Nav.Datapos.Text := Format('NAME=%s', [Nav.FltrList.Values['NAME']]);
//      Nav.FltrList.Values['NAME'] := '';
//      // Filter FORM usw bleibt
//      Query1.Open;
//      Nav.Datapos.GotoPos(Query1);
//    end;
//    self.WindowState := wsNormal;  //Filter Form anzeigen
    self.Close;
  end;
  InBtnAktualisieren := false;
end;

procedure TFrmFltr.Mu1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    PostMessage(self.Handle, WM_COMMAND, 0, BtnSpeichern.Handle);
end;

procedure TFrmFltr.NavBuildSql(DataSet: TDataSet; var OK, fertig: Boolean);
begin
  if Query1.ParamCount > 0 then
  try
    (* entfernt - siehe beforeopen 10.08.08
    Query1.ParamByName('ERFASST_VON').DataType := ftString; widestring?
    Query1.ParamByName('ERFASST_VON').AsString := SysParam.UserName;
    *)
  except //auch OK
  end;
end;

procedure TFrmFltr.Query1BeforeOpen(DataSet: TDataSet);
begin
  if chbAlle.Checked then
    Nav.FltrList.Values['ERFASST_VON'] := '' else
    Nav.FltrList.Values['ERFASST_VON'] := Format('%%%s%%;%s', [
      SysParam.UserName, '{ISPUBLIC=''J'' or ISPUBLIC is null}']);
    {=nur öffentliche und private von Username}
  //PostMessage(self.Handle, WM_COMMAND, 0, BtnTestError.Handle);
end;

procedure TFrmFltr.chbAlleClick(Sender: TObject);
begin
  Nav.Refresh;
end;

procedure TFrmFltr.Query1AfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if FindField('FLTR_ID') <> nil then
      if edFLTR_ID.DataSource <> LDataSource1 then
        edFLTR_ID.DataSource := LDataSource1;
  end;
  //PostMessage(self.Handle, WM_COMMAND, 0, BtnTestError.Handle);
end;

procedure TFrmFltr.BtnTestErrorClick(Sender: TObject);
begin
  EError('Testmerkmale', [0]);
end;

end.
