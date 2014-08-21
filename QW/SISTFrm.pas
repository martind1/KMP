unit SISTFrm;
(* QSBT - Silostellungen
   xx.02.06   SMH mit 11stelligem SPS-Code der im Silofeld gesendet wird
   29.09.06   SMW Umsetzungstabelle Anteil ->Öffnungszeit der im Anteilfeld übertr. wird
*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, DBAccess, MemDS,
  Mask, ExtCtrls,
  Grids, DBGrids, TabNotBk, Tabs, DBLookup, Dialogs,
  LNav_Kmp, GNav_Kmp, LuDefKmp, LuEdiKmp, Buttons, Qwf_Form,
  Btnp_kmp, Mugrikmp, Lubtnkmp, PSrc_Kmp, Asws_Kmp, Spin, QSpin_kmp, UQue_Kmp;

type
  TFrmSIST = class(TqForm)
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    PsDflt: TPrnSource;
    PageControl: TPageControl;
    Multi: TTabSheet;
    tsSingle: TTabSheet;
    DetailControl: TPageControl;
    TabSheet1: TTabSheet;
    ScrollBox5: TScrollBox;
    Panel2: TPanel;
    TabSheet2: TTabSheet;
    ScrollBox4: TScrollBox;
    GbStatisitk: TGroupBox;
    Label29: TLabel;
    Label31: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    EdERFASST_VON: TDBEdit;
    EdERFASST_AM: TDBEdit;
    EdGEAENDERT_VON: TDBEdit;
    EdGEAENDERT_AM: TDBEdit;
    EdANZAHL_AENDERUNGEN: TDBEdit;
    edID: TDBEdit;
    edERFASST_DATENBANK: TDBEdit;
    edGEAENDERT_DATENBANK: TDBEdit;
    ScrollBox3: TScrollBox;
    TabControl: TTabControl;
    Label2: TLabel;
    EdSILO_NR: TLookUpEdit;
    EditSILO_NAME: TDBEdit;
    Panel3: TPanel;
    chbWerk: TCheckBox;
    Mu1: TMultiGrid;
    LuDiPr: TLookUpDef;
    TabSheet4: TTabSheet;
    MuDiPr: TMultiGrid;
    Label1: TLabel;
    LuSILO: TLookUpDef;
    LeSILO_ID: TLookUpEdit;
    Label10: TLabel;
    edBEIN_NR: TLookUpEdit;
    edWERK_NR: TLookUpEdit;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    EdBEMERKUNG: TDBMemo;
    nbData: TNotebook;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Bevel1: TBevel;
    Label13: TLabel;
    edSILO_SPS_CODE: TLookUpEdit;
    edSPS_CODE: TLookUpEdit;
    EdA1: TEdit;
    EdS1: TEdit;
    EdA2: TEdit;
    EdS2: TEdit;
    edSIST_KEY: TLookUpEdit;
    edSTILLSTAND: TLookUpEdit;
    GroupBox3: TGroupBox;
    edSPS_CODE_SMW: TLookUpEdit;
    Label14: TLabel;
    SIST_KEY_2: TLookUpEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    edNACHLAUF: TLookUpEdit;
    Label19: TLabel;
    Label20: TLabel;
    edSTILLSTAND_SMW: TLookUpEdit;
    Label21: TLabel;
    Query1: TuQuery;
    TblDiPr: TuQuery;
    TblSILO: TuQuery;
    edLEISTUNG: TLookUpEdit;
    Label22: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TblDiPrBeforeOpen(DataSet: TDataSet);
    procedure LDataSource1StateChange(Sender: TObject);
    procedure EditExitS(Sender: TObject);
    procedure NavRech(ADataSet: TDataSet; Field: TField;
      OnlyCalcFields: Boolean);
    procedure LDataSource1DataChange(Sender: TObject; Field: TField);
    procedure NavGet(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure NavStart(Sender: TObject);
  private
    { Private-Deklarationen }
    InEditFill: boolean;
    function IsSMH: boolean;
  public
    { Public-Deklarationen }
  end;

var
  FrmSIST: TFrmSIST;

implementation
{$R *.DFM}
uses
  DPos_Kmp, Prots, NLnk_Kmp,
  MainFrm, PARAFRM;
const
  npSMH = 'SMH';  //Notebook Page auf nbData
  npSMW = 'SMW';  

function TFrmSIST.IsSMH: boolean;
//true=Haltern-Logik. false=SMW-Logik (Öffnungszeit)
begin
  result := Query1.FieldByName('WERK_NR').AsString = '0130';  //Haltern
end;

procedure TFrmSIST.FormCreate(Sender: TObject);
begin
  FrmSIST := self;
  FrmPara.OnFormCreate(self);
  if not PrgParam.QsbtSMH then
  begin
    Nav.FormatList.Values['SIST_KEY'] := '#0';
    Nav.FormatList.Values['SPS_CODE'] := '#0';
  end;
end;

procedure TFrmSIST.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);
end;

procedure TFrmSIST.FormDestroy(Sender: TObject);
begin
  FrmSIST := nil;
end;

procedure TFrmSIST.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmSIST.PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
begin
  FrmMain.DfltMultiGrid := Mu1;
end;

{ Anwendung }

procedure TFrmSIST.TblDiPrBeforeOpen(DataSet: TDataSet);
begin  //muss sein weil bein_nr nicht numerisch ist
  LuDiPr.References.Values['BEIN_NR'] := Query1.FieldByName('SILO_ID').AsString;
end;

procedure TFrmSIST.LDataSource1StateChange(Sender: TObject);
begin
  EdA1.ReadOnly := not (Nav.nlState in nlEditStates);
  EdS1.ReadOnly := EdA1.ReadOnly;
  EdA2.ReadOnly := EdA1.ReadOnly;
  EdS2.ReadOnly := EdA1.ReadOnly;
end;

procedure TFrmSIST.LDataSource1DataChange(Sender: TObject; Field: TField);
var
  S1: string;
  function NoNulls(S: string): string;
  begin
    if StrToIntTol(S) = 0 then
      result := '' else
      result := S;
  end;
begin
  if IsSMH then
  try
    nbData.ActivePage := npSMH;
    InEditFill := true;
    S1 := Format('%d000000000', [Query1.FieldByName('SPS_CODE').AsInteger]);
    EdA1.Text := NoNulls(copy(S1, 4, 1));
    EdS1.Text := NoNulls(copy(S1, 5, 2));
    EdA2.Text := NoNulls(copy(S1, 7, 1));
    EdS2.Text := NoNulls(copy(S1, 8, 2));
  finally
    InEditFill := false;
  end else
  begin
    nbData.ActivePage := npSMW;
  end;
end;

procedure TFrmSIST.NavGet(DataSet: TDataSet);
var
  S1: string;
  function NoNulls(S: string): string;
  begin
    if StrToIntTol(S) = 0 then
      result := '' else
      result := S;
  end;
begin
  if IsSMH then with DataSet do
  begin
    S1 := Format('%d000000000', [FieldByName('SPS_CODE').AsInteger]);
    FieldByName('cfA1').AsString := NoNulls(copy(S1, 4, 1));
    FieldByName('cfS1').AsString := NoNulls(copy(S1, 5, 2));
    FieldByName('cfA2').AsString := NoNulls(copy(S1, 7, 1));
    FieldByName('cfS2').AsString := NoNulls(copy(S1, 8, 2));
  end;
end;

procedure TFrmSIST.EditExitS(Sender: TObject);
begin
  TEdit(Sender).Text := Format('%02.2d', [StrToIntTol(TEdit(Sender).Text)]);
  EditExit(Sender);
end;

procedure TFrmSIST.EditExit(Sender: TObject);
begin
  if (Nav.nlState in nlEditStates) and not InEditFill then
  begin
    Nav.AssignValue('SPS_CODE', Format('%03.3d%01.1d%02.2d%01.1d%02.2d', [
      Query1.FieldByName('SILO_SPS_CODE').AsInteger,
      StrToIntTol(EdA1.Text), StrToIntTol(EdS1.Text),
      StrToIntTol(EdA2.Text), StrToIntTol(EdS2.Text)]));
  end;
end;

procedure TFrmSIST.NavRech(ADataSet: TDataSet; Field: TField;
  OnlyCalcFields: Boolean);
var
  S1, S2: string;
  VK, NK: integer;
  I1, I2: integer;
begin
  with ADataSet do
  begin
    if OnlyCalcFields then
    begin
    end else
    begin
      if IsSMH then
      begin
        if FieldIsName(Field, 'SPS_CODE') then
        begin
          I1 := FieldByName('SPS_CODE').AsInteger;
          I2 := FieldByName('SILO_SPS_CODE').AsInteger;
          S1 := Format('%d000000000', [I1]);
          S2 := Format('%03.3d%s', [I2, copy(S1, 4, Maxint)]);
          FieldByName('SPS_CODE').AsString := copy(S2, 1, 9);
          //VK := StrToInt(copy(S2, 4, 1)) + 10 * StrToInt(copy(S2, 7, 1));
          if StrToInt(copy(S2, 7, 1)) > 0 then
            VK := 10 * StrToInt(copy(S2, 4, 1)) + StrToInt(copy(S2, 7, 1)) else
            VK := StrToInt(copy(S2, 4, 1));
          NK := StrToInt(copy(S2, 5, 2)) + StrToInt(copy(S2, 8, 2));
          //'Anteil' Feld: Ausgang2Ausgang1,to1+to2
          FieldByName('SIST_KEY').AsString := Format('%d%s%02.2d', [
            VK, FormatSettings.DecimalSeparator, NK]);
        end;
      end;
    end;
  end;
end;

procedure TFrmSIST.NavStart(Sender: TObject);
begin
  if Query1.FindField('STILLSTAND') <> nil then
    edSTILLSTAND.DataField := 'STILLSTAND';
end;

end.
