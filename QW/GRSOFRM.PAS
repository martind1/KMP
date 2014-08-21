unit GRSOFRM;
(* Grund und Mischsorten

   Grundsorte: KOMBI_KNZ=N oder null
   Mischsorte: KOMBI_KNZ=J

   12.08.06 MD  Mischsorte darf nicht aus anderen Mischsorten bestehen
                (nur Grundsorte) Grund: V_GRSO_SILOS
*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, DBAccess, MemDS,
  Mask, ExtCtrls,
  Grids, DBGrids, TabNotBk, Tabs, DBLookup, Dialogs,
  LNav_Kmp, GNav_Kmp, LuDefKmp, LuEdiKmp, Buttons, Qwf_Form,
  Btnp_kmp, Mugrikmp, Lubtnkmp, PSrc_Kmp, Asws_Kmp, MuSiFr, UQue_Kmp;

type
  TFrmGrso = class(TqForm)
    LuWerk: TLookUpDef;
    Nav: TLNavigator;
    LDataSource1: TLDataSource;
    PsDflt: TPrnSource;
    Label16: TLabel;
    LuGrso2: TLookUpDef;
    LuGrso3: TLookUpDef;
    LuGrso1: TLookUpDef;
    LuMARA: TLookUpDef;
    PageControl: TPageControl;
    Multi: TTabSheet;
    Single: TTabSheet;
    DetailControl: TPageControl;
    TabSheet1: TTabSheet;
    ScrollBox5: TScrollBox;
    TabSheet2: TTabSheet;
    ScrollBox4: TScrollBox;
    ScrollBox3: TScrollBox;
    PanMu: TPanel;
    chbWerk: TCheckBox;
    Mu1: TMultiGrid;
    Label6: TLabel;
    Label17: TLabel;
    edBEZEICHNUNG: TLookUpEdit;
    EdWERK_NAME: TDBEdit;
    LeWERK_NR: TLookUpEdit;
    BtnLuWerk: TLookUpBtn;
    BtnLuMARA: TLookUpBtn;
    edMARA_NAME: TDBEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label9: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label19: TLabel;
    Label1: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edGRSO_ID: TDBEdit;
    EditERFASST_VON: TDBEdit;
    EditERFASST_AM: TDBEdit;
    EditGEAENDERT_VON: TDBEdit;
    EditGEAENDERT_AM: TDBEdit;
    EditANZAHL_AENDERUNGEN: TDBEdit;
    EditERFASST_DATENBANK: TDBEdit;
    EditREPLIKATION: TDBEdit;
    EditGEAENDERT_DATENBANK: TDBEdit;
    edGRSO1_ID: TLookUpEdit;
    edGRSO2_ID: TLookUpEdit;
    edGRSO3_ID: TLookUpEdit;
    EdMaraWERK_NR: TLookUpEdit;
    TabControl: TTabControl;
    TabSheet3: TTabSheet;
    LuSILO: TLookUpDef;
    GroupBox2: TGroupBox;
    FrSILO: TFrMuSi;
    Panel1: TPanel;
    Label18: TLabel;
    Label5: TLabel;
    chbKOMBI_KNZ: TAswCheckBox;
    gbMisch: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    LaAnteil: TLabel;
    LeBEZEICHNUNG1: TLookUpEdit;
    EdPos1: TEdit;
    EdPos2: TEdit;
    LeBEZEICHNUNG2: TLookUpEdit;
    BtnLuSilo1: TLookUpBtn;
    BtnLuSilo2: TLookUpBtn;
    chbOFFENE_BEL: TAswCheckBox;
    edSPS_SORTE: TLookUpEdit;
    panTROCKEN_FEUCHT: TPanel;
    AswRadioGroup1: TAswRadioGroup;
    Panel2: TPanel;
    EdBEMERKUNG: TDBMemo;
    Label14: TLabel;
    edGrso1MARA_NAME: TLookUpEdit;
    edGrso2MARA_NAME: TLookUpEdit;
    chbGrundsorte: TCheckBox;
    chbMischsorte: TCheckBox;
    TabSheet4: TTabSheet;
    LuV_LABI_GRSO_MK: TLookUpDef;
    MuV_LABI_GRSO_MK: TMultiGrid;
    BtnMuV_LABI_MK: TBitBtn;
    cobGRSO1_ANTEIL: TDBComboBox;
    cobGRSO2_ANTEIL: TDBComboBox;
    PanSilo3: TPanel;
    EdPos3: TEdit;
    LeBEZEICHNUNG3: TLookUpEdit;
    BtnLuSilo3: TLookUpBtn;
    edGrso3MARA_NAME: TLookUpEdit;
    cobGRSO3_ANTEIL: TDBComboBox;
    Query1: TuQuery;
    TblWerk: TuQuery;
    TblGrso1: TuQuery;
    TblGrso2: TuQuery;
    TblGrso3: TuQuery;
    TblMARA: TuQuery;
    QueMARA: TuQuery;
    TblSILO: TuQuery;
    TblV_LABI_GRSO_MK: TuQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NavStart(Sender: TObject);
    procedure PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure chbFltrClick(Sender: TObject);
    procedure NavPageChange(PageIndex: Integer);
    procedure NavErfass(Sender: TObject);
    procedure NavRech(ADataSet: TDataSet; Field: TField;
      OnlyCalcFields: Boolean);
    procedure LuGrsoGet(DataSet: TDataSet);
    procedure Query1BeforePost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnMuV_LABI_MKClick(Sender: TObject);
    procedure LuV_LABI_GRSO_MKStateChange(Sender: TObject);
    procedure NavPrn(Sender: TObject; var fertig: Boolean);
    procedure NavBeforePost(ADataSet: TDataSet; var Done: Boolean);
    procedure TblGrso1BeforeOpen(DataSet: TDataSet);
    procedure TblGrso1BeforeClose(DataSet: TDataSet);
    procedure TblGrso1BeforeFetch(DataSet: TCustomDADataSet;
      var Cancel: Boolean);
  private
    function FrmNr: integer;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmGrso: TFrmGrso;
  FrmGrso1: TFrmGrso;
  FrmGrso2: TFrmGrso;
  FrmGrso3: TFrmGrso;

implementation
{$R *.DFM}
uses
  NLnk_Kmp, Prots, Poll_Kmp, Err__Kmp,
  MainFrm, WerkFrm, PARAFRM, QuvaStr;

function TFrmGrso.FrmNr: integer;
begin
  Result := StrToIntDef(CharN(Kurz), 0);
end;

procedure TFrmGrso.FormCreate(Sender: TObject);
begin
  case FrmNr of
    1: FrmGRSO1 := self;
    2: FrmGRSO2 := self;
    3: FrmGRSO3 := self;
  else
    FrmGRSO := self;
  end;
  if FrmNr >= 1 then
    self.Caption := 'Mischsorte' + IntToStr(FrmNr);
  PanSilo3.Visible := PrgParam.SiloMix >= 3;
  FrmPara.OnFormCreate(self);
end;

procedure TFrmGrso.FormDestroy(Sender: TObject);
begin
  case FrmNr of
    1: FrmGRSO1 := nil;
    2: FrmGRSO2 := nil;
    3: FrmGRSO3 := nil;
  else
    FrmGRSO := nil;
  end;
end;

procedure TFrmGrso.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);
  LaAnteil.Left := gbMisch.Width - 76;

  BtnLuSilo1.Left := gbMisch.Width - 100;
  cobGRSO1_ANTEIL.Left := BtnLuSilo1.Left + 24;

  BtnLuSilo2.Left := gbMisch.Width - 100;
  cobGRSO2_ANTEIL.Left := BtnLuSilo2.Left + 24;

  BtnLuSilo3.Left := gbMisch.Width - 102;
  cobGRSO3_ANTEIL.Left := BtnLuSilo3.Left + 24;

  edGrso1MARA_NAME.Width := BtnLuSilo1.Left - edGrso1MARA_NAME.Left;
  edGrso2MARA_NAME.Width := BtnLuSilo2.Left - edGrso2MARA_NAME.Left;
  edGrso3MARA_NAME.Width := BtnLuSilo3.Left - edGrso3MARA_NAME.Left;
end;

procedure TFrmGrso.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmGrso.NavStart(Sender: TObject);
begin
  if not Nav.ReturnAktiv then
    chbWerk.Checked := true else
    Query1.Open;
end;

procedure TFrmGrso.NavPageChange(PageIndex: Integer);
begin
//  TblWerk.Active := PageIndex < 10;
//  TblGrso1.Active := PageIndex < 10;
//  TblGrso2.Active := PageIndex < 10;
//  TblGrso3.Active := PageIndex < 10;
  TblV_LABI_GRSO_MK.Close;
end;

procedure TFrmGrso.NavPrn(Sender: TObject; var fertig: Boolean);
begin
  PsDflt.MuSelect := Mu1;
end;

procedure TFrmGrso.PsDfltBeforePrn(Sender: TObject;
  var fertig: Boolean);
var
  S: string;
begin
  S := Nav.FltrList.Values['WERK_NR'];
  if S <> '' then
  begin
    TblWerk.Open;
    PsDflt.Caption := 'Werk ' + TblWerk.FieldByName('WERK_NAME').AsString;
  end else
    PsDflt.Caption := '';
  FrmMain.DfltMultiGrid := Mu1;
end;

procedure TFrmGrso.chbFltrClick(Sender: TObject);
begin
  {if Nav.nlState in [nlQuery,nlBrowse] then}
  begin
    chbWerk.Caption := 'Werk ' + SysParam.WerkNr;
    Query1.Close;
    try
      if chbWerk.Checked then
        Nav.FltrList.Values['WERK_NR'] := SysParam.WerkNr else
        Nav.FltrList.Values['WERK_NR'] := '';
      if chbGrundsorte.Checked = chbMischsorte.Checked then
        Nav.FltrList.Values['KOMBI_KNZ'] := '' else
      if chbGrundsorte.Checked then
        Nav.FltrList.Values['KOMBI_KNZ'] := '<>J;=' else
        Nav.FltrList.Values['KOMBI_KNZ'] := 'J';
    finally
      Query1.Open;
    end;
  end;
end;

procedure TFrmGrso.NavErfass(Sender: TObject);
begin
  Nav.AssignValueIfNull('KOMBI_KNZ', 'N');
  Nav.AssignValueIfNull('OFFENE_BEL', 'N');
end;

procedure TFrmGrso.Query1BeforePost(DataSet: TDataSet);
var
  L: TStringList;
  S: string;
  procedure CheckS(BezS, AntS: string);
  var
    S: string;
  begin
    with DataSet do
    begin
      S := FieldByName(BezS).AsString;
      if S <> '' then
      begin
        L.Add(S);
        if FieldByName(AntS).AsString = '' then
        begin
          //EError('@Anteil fehlt (%s)', [S]);
          FieldByName(AntS).AsString := '100';
        end;
      end;
    end;
  end;
begin
  with DataSet do
  try
    L := TStringList.Create;
    try
      L.Sorted := true;
      L.Duplicates := dupError;   //erzeugt E wenn Doppels
      S := FieldByName('BEZEICHNUNG').AsString;
      if S <> '' then L.Add(S);
      CheckS('GRSO1_BEZEICHNUNG', 'GRSO1_ANTEIL');
      CheckS('GRSO2_BEZEICHNUNG', 'GRSO2_ANTEIL');
      CheckS('GRSO3_BEZEICHNUNG', 'GRSO3_ANTEIL');
    except on E:Exception do
      if E is EStringListError then
      begin
        //Sender.Clear;
        EError(GRSOFRM_001+' (%s)', [S]);  //'Duplikat nicht erlaubt'
        //ErrWarn('Duplikat nicht erlaubt (%s)', [S]);
      end else
        raise;
    end;
  finally
    L.Free;
  end;
end;

procedure TFrmGrso.TblGrso1BeforeClose(DataSet: TDataSet);
begin
debug0;
end;

procedure TFrmGrso.TblGrso1BeforeFetch(DataSet: TCustomDADataSet;
  var Cancel: Boolean);
begin
debug0;
end;

procedure TFrmGrso.TblGrso1BeforeOpen(DataSet: TDataSet);
begin
debug0;
end;

procedure TFrmGrso.NavRech(ADataSet: TDataSet; Field: TField;
  OnlyCalcFields: Boolean);
var
  M: boolean;  
begin
  with ADataSet do
  begin
    if OnlyCalcFields then
    begin
    end else
    begin
      FieldByName('OFFENE_BEL').AsString := StrDflt(FieldByName('OFFENE_BEL').AsString, 'N');
      if FieldIsName(Field, 'KOMBI_KNZ') then
      begin
        if FieldByName('KOMBI_KNZ').AsString = JaNein_Nein then
        begin
          FieldByName('GRSO1_BEZEICHNUNG').Clear;
          FieldByName('GRSO2_BEZEICHNUNG').Clear;
          FieldByName('GRSO3_BEZEICHNUNG').Clear;
        end;
      end;
      M := false;
      if FieldByName('GRSO1_BEZEICHNUNG').AsString = '' then
        FieldByName('GRSO1_ANTEIL').Clear else M := true;
      if FieldByName('GRSO2_BEZEICHNUNG').AsString = '' then
        FieldByName('GRSO2_ANTEIL').Clear else M := true;
      if FieldByName('GRSO3_BEZEICHNUNG').AsString = '' then
        FieldByName('GRSO3_ANTEIL').Clear else M := true;
      if M then
        FieldByName('KOMBI_KNZ').AsString := JaNein_Ja else
        FieldByName('KOMBI_KNZ').AsString := JaNein_Nein;
    end;
  end;
end;

procedure TFrmGrso.LuGrsoGet(DataSet: TDataSet);
begin
  with DataSet do
  begin
    QueMARA.Close;
    QueMARA.ParamByName('WERK_NR').AsString := FieldByName('WERK_NR').AsString;
    QueMARA.ParamByName('MARA_NR').AsString := FieldByName('BEZEICHNUNG').AsString;
    QueMARA.Open;
    FieldByName('cfMARA_NAME').AsString := QueMARA.FieldByName('MARA_NAME').AsString;
    QueMARA.Close;
  end;
end;

procedure TFrmGrso.BtnMuV_LABI_MKClick(Sender: TObject);
begin
  TblV_LABI_GRSO_MK.Open;
end;

procedure TFrmGrso.LuV_LABI_GRSO_MKStateChange(Sender: TObject);
begin
  BtnMuV_LABI_MK.Visible := LuV_LABI_GRSO_MK.nlState = nlInactive;
end;

procedure TFrmGrso.NavBeforePost(ADataSet: TDataSet; var Done: Boolean);
begin
  with ADataSet do
  begin
    if PrgParam.SiloMix < 3 then
    begin
      FieldByName('GRSO3_BEZEICHNUNG').Clear;
      FieldByName('GRSO3_ANTEIL').Clear;
    end;
  end;
end;

end.
