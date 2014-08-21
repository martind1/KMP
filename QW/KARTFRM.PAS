unit Kartfrm;
(*
10.06.02 MD Erweitert für QSBT
25.07.04 MD ori_kart_nr enthält aufgedruckte Nr wenn gelesene verschieden
05.07.05 MD AUFBAU
08.12.05 MD nach kmp\qw gemeinsam mit qsbt
27.12.05 MD Kundenkarte ohne Kunde wenn Spedition vorhanden ist
21.03.07 MD Material als Suchkriterium, Mara_Name deshalb nicht mehr sichtbar
28.10.13 md  Spedition keine Großschrift mehr (Gambach, SPEDFrm)
*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, DBAccess, MemDS,
  Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  Lubtnkmp, Luedikmp, Asws_Kmp, CalcCache, MuSiFr, UQue_Kmp;

type
  TFrmKart = class(TqForm)
    PageBook: TqNoteBook;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Label2: TLabel;
    edKART_NR: TDBEdit;
    DetailBook: TTabbedNotebook;
    ScrollBox2: TScrollBox;
    Mu1: TMultiGrid;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    LTabSet1: TLTabSet;
    Panel2: TPanel;
    BtnMulti: TqBtnMuSi;
    BtnSingle: TqBtnMuSi;
    PsDflt: TPrnSource;
    MuAufp: TMultiGrid;
    edKUNW_NR: TLookUpEdit;
    Label1: TLabel;
    Label4: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label9: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label19: TLabel;
    EdMARA_ID: TDBEdit;
    EditERFASST_VON: TDBEdit;
    EditERFASST_AM: TDBEdit;
    EditGEAENDERT_VON: TDBEdit;
    EditGEAENDERT_AM: TDBEdit;
    EditANZAHL_AENDERUNGEN: TDBEdit;
    EditERFASST_DATENBANK: TDBEdit;
    EditGEAENDERT_DATENBANK: TDBEdit;
    EditREPLIKATION: TDBEdit;
    Label5: TLabel;
    LuAufp: TLookUpDef;
    Panel3: TPanel;
    chbWerk: TCheckBox;
    LuWERK: TLookUpDef;
    BtnKUNW_NR: TLookUpBtn;
    LuPEKR: TLookUpDef;
    Label15: TLabel;
    LePEKR_ID: TLookUpEdit;
    chbSPERR_KNZ: TAswCheckBox;
    edSPENDER_KNZ: TAswCheckBox;
    PanRg: TPanel;
    rgKUND_KNZ: TAswRadioGroup;
    LuAUFK: TLookUpDef;
    LuMARA: TLookUpDef;
    LuSILO: TLookUpDef;
    edSO_WERK_NR: TLookUpEdit;
    Label25: TLabel;
    LuLFSK: TLookUpDef;
    Panel4: TPanel;
    Label6: TLabel;
    edcfKUNDE: TDBEdit;
    ScrollBox3: TScrollBox;
    Label3: TLabel;
    Label10: TLabel;
    Bevel1: TBevel;
    Label14: TLabel;
    Label16: TLabel;
    Bevel2: TBevel;
    Label18: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Bevel3: TBevel;
    Label24: TLabel;
    Label17: TLabel;
    Label28: TLabel;
    Label26: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    laTEILMENGE4: TLabel;
    latTEILMENGE4: TLabel;
    laTEILMENGE5: TLabel;
    latTEILMENGE5: TLabel;
    EdBEMERKUNG: TDBMemo;
    edPEKR_NR: TLookUpEdit;
    BtnPEKR_NR: TLookUpBtn;
    edPEKR_BEZ: TLookUpEdit;
    leAUFK_NR: TLookUpEdit;
    BtnAUFK_NR: TLookUpBtn;
    LeMARA_NR: TLookUpEdit;
    BtnMARA_NR: TLookUpBtn;
    edMARA_NAME: TLookUpEdit;
    edTRANSPORTMITTEL: TLookUpEdit;
    edSOLLMENGE: TLookUpEdit;
    chbSORTE_KNZ: TAswCheckBox;
    edSILO_NR: TLookUpEdit;
    BtnSILO_NR: TLookUpBtn;
    edSILO_NAME: TLookUpEdit;
    chbFREMDWAEGUNG: TAswCheckBox;
    edSPEDITION: TLookUpEdit;
    LovSPEDITION: TLovBtn;
    edTARA_GEWICHT: TLookUpEdit;
    edTARA_DATUM: TLookUpEdit;
    BtnLFSK: TLookUpBtn;
    cobTROCKEN_FEUCHT: TAswComboBox;
    edMAX_BRUTTO: TLookUpEdit;
    edTEILMENGE1: TLookUpEdit;
    edTEILMENGE2: TLookUpEdit;
    edTEILMENGE3: TLookUpEdit;
    edTEILMENGE4: TLookUpEdit;
    edTEILMENGE5: TLookUpEdit;
    chbPROBENPFLICHT: TAswCheckBox;
    edORI_KART_NR: TDBEdit;
    Label42: TLabel;
    Label8: TLabel;
    leWERK_NR: TLookUpEdit;
    BtnWERK_NR: TLookUpBtn;
    cobAUFBAU: TAswComboBox;
    Label7: TLabel;
    LuSped: TLookUpDef;
    btnSPEDITION: TLookUpBtn;
    LeSpedWERK_NR: TLookUpEdit;
    Label43: TLabel;
    LuZSPKU: TLookUpDef;
    FrZSPKU: TFrMuSi;
    edKUNW_NAME1: TDBEdit;
    Label38: TLabel;
    edcfKUNDE_1: TLookUpEdit;
    Panel5: TPanel;
    Label39: TLabel;
    edSPEDITION_1: TLookUpEdit;
    chbFestTara: TCheckBox;
    Label27: TLabel;
    edTARA_TAGE: TLookUpEdit;
    Label40: TLabel;
    Query1: TuQuery;
    TblAufP: TuQuery;
    TblWERK: TuQuery;
    TblKUNW: TuQuery;
    TblPEKR: TuQuery;
    TblAUFK: TuQuery;
    TblMARA: TuQuery;
    TblSILO: TuQuery;
    TblLFSK: TuQuery;
    TblSPED: TuQuery;
    TblZSPKU: TuQuery;
    LuKUNW: TLookUpDef;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chbWerkClick(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure NavBeforePost(ADataSet: TDataSet; var Done: Boolean);
    procedure NavErfass(Sender: TObject);
    procedure NavRech(ADataSet: TDataSet; Field: TField;
      OnlyCalcFields: Boolean);
    procedure TblLFSKBeforeOpen(DataSet: TDataSet);
    procedure LuLFSKAfterReturn(Sender: TLookUpDef;
      LookUpModus: TLookUpModus);
    procedure LuAufpGet(DataSet: TDataSet);
    procedure chbFestTaraClick(Sender: TObject);
    procedure LDataSource1StateChange(Sender: TObject);
    procedure LDataSource1DataChange(Sender: TObject; Field: TField);
    procedure LuMARAAfterReturn(Sender: TLookUpDef;
      LookUpModus: TLookUpModus);
    procedure TblPEKRBeforeClose(DataSet: TDataSet);
    procedure TblPEKRBeforeOpen(DataSet: TDataSet);
    procedure TblPEKRBeforeFetch(DataSet: TCustomDADataSet;
      var Cancel: Boolean);
    procedure edTRANSPORTMITTELKeyPress(Sender: TObject; var Key: Char);
  protected
  private
    { Private-Deklarationen }
    OldTara: double;
    procedure SetWerkFltr(Value: boolean);
  public
    { Public-Deklarationen }
  end;

var
  FrmKart: TFrmKart;

implementation

{$R *.DFM}

uses
  Dialogs,
  GNav_Kmp, Prots, NLnk_Kmp,
  MainFrm, PARAFRM;

procedure TFrmKart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmKart.NavStart(Sender: TObject);
begin
  if not Nav.ReturnAktiv then
    SetWerkFltr(true) else  //chbWerk.Checked := true else
    Query1.Open;
end;

procedure TFrmKart.PsDfltBeforePrn(Sender: TObject;
  var fertig: Boolean);
var
  S: string;
begin
  S := Nav.FltrList.Values['WERK_NR'];
  if S <> '' then
  begin
    PsDflt.Caption := 'Werk Nr. ' + Query1.FieldByName('WERK_NR').AsString;
  end;
  FrmMain.DfltMultiGrid := Mu1;
end;

procedure TFrmKart.FormCreate(Sender: TObject);
begin
  FrmKart := self;
  FrmPara.OnFormCreate(self);
  {try
    Query1.Open;
    if Query1.FieldByName('TARA_GEWICHT').AsFloat > 0 then ;
  except   //Datenbankschema noch nicht erweitert
    edTARA_GEWICHT.Free;
    edTARA_DATUM.Free;
    Query1.Open;
  end;}
  {doch nicht if PrgParam.QsbtSMH then
  begin
    laTEILMENGE4.Visible := false;
    edTEILMENGE4.Visible := false;
    latTEILMENGE4.Visible := false;
    laTEILMENGE5.Visible := false;
    edTEILMENGE5.Visible := false;
    latTEILMENGE5.Visible := false;
  end;}
  if PrgParam.QsbtSMH then
    chbSORTE_KNZ.Enabled := false;
end;

procedure TFrmKart.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);
end;

procedure TFrmKart.FormDestroy(Sender: TObject);
begin
  FrmKart := nil;
end;

procedure TFrmKart.SetWerkFltr(Value: boolean);
const
  Aktiv: boolean = false;
begin
  if Aktiv then
    Exit;
  try
    Aktiv := true;
    chbWerk.Checked := Value;
    Query1.Close;
    try
      if chbWerk.Checked then
        Nav.FltrList.Values['WERK_NR'] := SysParam.WerkNr else
        Nav.FltrList.Values['WERK_NR'] := '';
    finally
      Query1.Open;
    end;
  finally
    Aktiv := false;
  end;
end;

procedure TFrmKart.chbWerkClick(Sender: TObject);
begin
  {if Nav.nlState in [nlQuery,nlBrowse] then}
  begin
    SetWerkFltr(chbWerk.Checked);
    {Query1.Close;
    try
      if chbWerk.Checked then
        Nav.FltrList.Values['WERK_NR'] := SysParam.WerkNr else
        Nav.FltrList.Values['WERK_NR'] := '';
    finally
      Query1.Open;
    end;}
  end;
end;

procedure TFrmKart.edTRANSPORTMITTELKeyPress(Sender: TObject; var Key: Char);
begin
  FrmPara.EdTRANSPORTMITTELKeyPress(Sender, Key);
end;

procedure TFrmKart.Query1BeforeOpen(DataSet: TDataSet);
begin
  ChbWerk.Caption := 'Werk ' + SysParam.WerkNr; //Nav.FltrList.Values['WERK_NR'];
end;

procedure TFrmKart.NavErfass(Sender: TObject);
begin
  with Query1 do
  begin
    FieldByName('KUND_KNZ').AsString := JaNein_Nein;
    FieldByName('SPERR_KNZ').AsString := JaNein_Nein;
    FieldByName('SPENDER_KNZ').AsString := JaNein_Nein;
    FieldByName('SORTE_KNZ').AsString := JaNein_Nein;
    FieldByName('FREMDWAEGUNG').AsString := JaNein_Nein;
    FieldByName('PROBENPFLICHT').AsString := JaNein_Nein;
    FieldByName('PEKR_NR').AsString := PrgParam.PekrDflt;
  end;
end;

procedure TFrmKart.NavRech(ADataSet: TDataSet; Field: TField;
  OnlyCalcFields: Boolean);
begin
  with ADataSet do
  begin
    if OnlyCalcFields then
    begin
    end else
    begin
      if (FieldByName('KUNW_NR').AsString <> '') or
         (FieldByName('SPEDITION').AsString <> '') then
        FieldByName('KUND_KNZ').AsString := JaNein_Ja else
        FieldByName('KUND_KNZ').AsString := JaNein_Nein;
      if FieldIsName(Field, 'TARA_GEWICHT') then
      begin
        if FieldIsNull(Field) then
          FieldByName('TARA_DATUM').Clear else
          FieldByName('TARA_DATUM').AsDateTime := date;
      end;
    end;
  end;
end;

procedure TFrmKart.chbFestTaraClick(Sender: TObject);
begin
  try
    if chbFestTara.Checked and Query1.FieldByName('TARA_GEWICHT').IsNull then
      Query1.FieldByName('TARA_GEWICHT').AsFloat := OldTara else
    if not chbFestTara.Checked and not Query1.FieldByName('TARA_GEWICHT').IsNull then
    begin
      OldTara := Query1.FieldByName('TARA_GEWICHT').AsFloat;
      Query1.FieldByName('TARA_GEWICHT').Clear;
    end;
  finally
    chbFestTara.Checked := not FieldIsNull(Query1.FieldByName('TARA_GEWICHT'));
  end;
end;

procedure TFrmKart.LDataSource1DataChange(Sender: TObject; Field: TField);
begin
  chbFestTara.Checked := not FieldIsNull(Query1.FieldByName('TARA_GEWICHT'));
end;

procedure TFrmKart.LDataSource1StateChange(Sender: TObject);
begin
  if Nav.nlState in nlEditStates then
  begin
    chbFestTara.Color := clBtnFace;
    OldTara := Query1.FieldByName('TARA_GEWICHT').AsFloat;
  end else
    chbFestTara.Color := $00C8D0D4;
end;

procedure TFrmKart.NavBeforePost(ADataSet: TDataSet; var Done: Boolean);
begin
  with ADataSet do
  begin
    //FieldByName('KUNW_NR').Required := FieldByName('KUND_KNZ').AsString = JaNein_Ja;
    FieldByName('BEMERKUNG').Required := FieldByName('KUND_KNZ').AsString = JaNein_Nein;
    if PrgParam.QsbtSMH then
      FieldByName('AUFBAU').Required := true;
  end;
end;

procedure TFrmKart.TblLFSKBeforeOpen(DataSet: TDataSet);
begin
  LuLFSK.FltrList.Values['BELADEDATUM'] := '>=' + DateToStr(date - 365);
end;

procedure TFrmKart.TblPEKRBeforeClose(DataSet: TDataSet);
begin
debug0;
end;

procedure TFrmKart.TblPEKRBeforeFetch(DataSet: TCustomDADataSet;
  var Cancel: Boolean);
begin
debug0;
end;

procedure TFrmKart.TblPEKRBeforeOpen(DataSet: TDataSet);
begin
debug0;
end;

procedure TFrmKart.LuLFSKAfterReturn(Sender: TLookUpDef;
  LookUpModus: TLookUpModus);
begin
  Nav.AssignValue('TARA_GEWICHT', LuLFSK.DataPos.Values['TARA_GEWICHT']);
  Nav.AssignValue('TARA_DATUM', LuLFSK.DataPos.Values['BELADEDATUM']);
end;

procedure TFrmKart.LuAufpGet(DataSet: TDataSet);
var
  S: string;
begin
  with DataSet do
  begin
    S := FieldByName('KUNW_NAME1').AsString;
    {AppendTok(S, FieldByName('KUNW_NAME2').AsString, ' ');
    AppendTok(S, FieldByName('KUNW_NAME3').AsString, ' ');}
    AppendTok(S, FieldByName('KUNW_LAND').AsString, ', ');
    AppendTok(S, FieldByName('KUNW_ORT').AsString, ', ');
    FieldByName('cfKUNDE').AsString := S;
  end;
end;

procedure TFrmKart.LuMARAAfterReturn(Sender: TLookUpDef;
  LookUpModus: TLookUpModus);
begin
  Nav.AssignValue('MARA_NR', Sender.DataPos.Values['MARA_NR']);
end;

end.
