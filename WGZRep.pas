unit WGZRep;
(* Ladeschein
   11.06.01 MD Lager
*)   
interface

uses
{$ifdef WIN32}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DB,  Uni, DBAccess, MemDS,
  QRepForm, Lnav_kmp, Kmp__reg, quickrpt, Qrctrls, LuDefKmp;
{$else}
  WinTypes, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DB, 
  QRepForm, Lnav_kmp, Kmp__reg, quickrpt, Qrctrls;
{$endif}

type
  TRepWGZ = class(TQRepForm)
    QuickReport: TQuickRep;
    Query1: TuQuery;
    LDatasource1: TLDataSource;
    Nav: TLNavigator;
    HdrCol: TQRBand;
    SummaryBand1: TQRBand;
    ChildBand1: TQRChildBand;
    QRLabel6: TQRLabel;
    QRDBText21: TQRDBText;
    QRDBText22: TQRDBText;
    QRDBText23: TQRDBText;
    QRDBText24: TQRDBText;
    QRSysData1: TQRSysData;
    QRDateTime: TQRSysData;
    PageNumber: TQRSysData;
    LaCaption: TQRLabel;
    LuAufk: TLookUpDef;
    TblAufk: TuQuery;
    ChildBand2: TQRChildBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel5: TQRLabel;
    QRExpr1: TQRExpr;
    QRLabel3: TQRLabel;
    QRDBText5: TQRDBText;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText13: TQRDBText;
    QRExpr2: TQRExpr;
    QRLabel9: TQRLabel;
    QRDBText14: TQRDBText;
    QRDBText15: TQRDBText;
    QRLabel10: TQRLabel;
    QRDBText16: TQRDBText;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRDBText17: TQRDBText;
    QRDBText18: TQRDBText;
    QRLabel13: TQRLabel;
    QRSubDetail1: TQRSubDetail;
    LuAufp: TLookUpDef;
    TblAufp: TuQuery;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRLabel20: TQRLabel;
    QRLabel21: TQRLabel;
    QRDBText3: TQRDBText;
    QRLabel22: TQRLabel;
    QRDBText4: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText27: TQRDBText;
    QRLabel23: TQRLabel;
    QRLabel24: TQRLabel;
    QRLabel25: TQRLabel;
    QRLabel26: TQRLabel;
    QRLabel19: TQRLabel;
    QRDBText28: TQRDBText;
    QRLabel27: TQRLabel;
    QRDBText29: TQRDBText;
    LuBels: TLookUpDef;
    TblBels: TuQuery;
    ProdHinweis: TQRChildBand;
    QRLabel28: TQRLabel;
    VersHinweis: TQRChildBand;
    QRLabel29: TQRLabel;
    Werksattest: TQRChildBand;
    PageFooterBand1: TQRBand;
    QRLabel30: TQRLabel;
    QRDBText19: TQRDBText;
    QRLabel14: TQRLabel;
    QRLabel4: TQRLabel;
    QRDBText7: TQRDBText;
    QRDBText20: TQRDBText;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRLabel17: TQRLabel;
    QRDBText25: TQRDBText;
    QRLabel18: TQRLabel;
    QRDBText26: TQRDBText;
    QRDBText6: TQRDBText;
    QRLabel31: TQRLabel;
    QRLabel32: TQRLabel;
    QRDBText32: TQRDBText;
    QRExpr3: TQRExpr;
    edProdHinweis: TQRDBText;
    edVersHinweis: TQRDBText;
    LuLfsp: TLookUpDef;
    TblLfsp: TuQuery;
    laABHOLLAGER: TQRLabel;
    ChildSub: TQRChildBand;
    QRLabel33: TQRLabel;
    edWerksattest: TQRDBText;
    QRLabel34: TQRLabel;
    QRDBText9: TQRDBText;
    QRLabel35: TQRLabel;
    laEichNr: TQRLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QRDateTimePrint(sender: TObject; var Value: String);
    procedure LaCaptionPrint(sender: TObject; var Value: String);
    procedure HdrTextAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
    procedure LuAufpGet(DataSet: TDataSet);
    procedure ProdHinweisBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure VersHinweisBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure TrimL0Print(sender: TObject; var Value: String);
    procedure HdrColBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure Query1BeforeScroll(DataSet: TDataSet);
    procedure QRSubDetail1AfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
    procedure NavGet(DataSet: TDataSet);
    procedure ChildBand1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure WerksattestBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure SummaryBand1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
  private
    { Private declarations }
    AufpPrinted: boolean;
  public
    { Public declarations }
  end;

var
  RepWGZ: TRepWGZ;

implementation
{$R *.DFM}
uses
  Prots, nstr_Kmp,
  MainFrm;

procedure TRepWGZ.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TRepWGZ.HdrColBeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  TblAufp.Open;   {Ladeoptimierung}
end;

procedure TRepWGZ.Query1BeforeScroll(DataSet: TDataSet);
begin
  if AufpPrinted then
    TblAufp.Close;
end;

procedure TRepWGZ.QRSubDetail1AfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  AufpPrinted := true;
end;

procedure TRepWGZ.QRDateTimePrint(sender: TObject; var Value: String);
begin
  Value := Format(Value, [Sysparam.Username]);
  System.Delete(Value, length(Value) - 2, 3);    {Sek weg}
end;

procedure TRepWGZ.LaCaptionPrint(sender: TObject; var Value: String);
begin
  Value := PrnSource.Caption;
end;

procedure TRepWGZ.HdrTextAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  FrmMain.PrintVorlage('K', 'D', QuickReport);
end;

procedure TRepWGZ.NavGet(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if FieldByName('LEER_GEWICHT').AsFloat = 0 then
      AssignField(FieldByName('cfLEER_GEWICHT'), FieldByName('TARA_GEWICHT')) else
      AssignField(FieldByName('cfLEER_GEWICHT'), FieldByName('LEER_GEWICHT'));
  end;
end;

procedure TRepWGZ.LuAufpGet(DataSet: TDataSet);
begin
  TblLfsp.Close;
  TblLfsp.Open;
  with DataSet do
  begin
    if not TblLfsp.FieldByName('MENGE').IsNull then         {vom Lieferschein LFSP}
      AssignField(FieldByName('cfMenge'), TblLfsp.FieldByName('MENGE')) else
    if FieldByName('UEBERPOSITION').AsString = FieldByName('AUFP_NR').AsString then
    begin    {von DISP}
      if FieldByName('VERS_MENGE').AsFloat > 0 then
        AssignField(FieldByName('cfMenge'), FieldByName('VERS_MENGE')) else
      if (FieldByName('LADE_GEWICHT').AsFloat > 0) and     {nur Bahn:}
         (Char1(Query1.FieldByName('VERSANDART_TYP').AsString) = 'B') then
        AssignField(FieldByName('cfMenge'), FieldByName('LADE_GEWICHT')) else
        AssignField(FieldByName('cfMenge'), FieldByName('DISP_MENGE'));
    end else {von Auftrag}
      AssignField(FieldByName('cfMenge'), FieldByName('BESTELLMENGE'));

    if FieldByName('UEBERPOSITION').AsString = FieldByName('AUFP_NR').AsString then
    begin    {von DISP}
      {edProdHinweis.DataField := 'PRODHINWEIS';
      edVersHinweis.DataField := 'VERSHINWEIS';
      exProdHinweis.Expression := 'TblAufp.PRODHINWEIS';
      exVersHinweis.Expression := 'TblAufp.VERSHINWEIS';}
      AssignField(FieldByName('cfProdHinweis'), FieldByName('PRODHINWEIS'));
      AssignField(FieldByName('cfVersHinweis'), FieldByName('VERSHINWEIS'));
      AssignField(FieldByName('cfWerksattest'), FieldByName('DISPWERKSATTEST'));
    end else
    begin    {von Auftrag}
      {edProdHinweis.DataField := 'TEXT_KONSERVE_4';
      edVersHinweis.DataField := 'TEXT_KONSERVE_3';
      exProdHinweis.Expression := 'TblAufp.TEXT_KONSERVE_4';
      exVersHinweis.Expression := 'TblAufp.TEXT_KONSERVE_3';}
      AssignField(FieldByName('cfProdHinweis'), FieldByName('TEXT_KONSERVE_4'));
      AssignField(FieldByName('cfVersHinweis'), FieldByName('TEXT_KONSERVE_3'));
      AssignField(FieldByName('cfWerksattest'), FieldByName('AUFPWERKSATTEST'));
    end;
  end;
end;

procedure TRepWGZ.ProdHinweisBeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  PrintBand := not FieldIsNull(
    edProdHinweis.DataSet.FieldByName(edProdHinweis.DataField)) and
    (PrnSource.Bemerkung.Values['P'] <> '0');
end;

procedure TRepWGZ.VersHinweisBeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  PrintBand := not FieldIsNull(
    edVersHinweis.DataSet.FieldByName(edVersHinweis.DataField)) and
    (PrnSource.Bemerkung.Values['V'] <> '0');
end;

procedure TRepWGZ.WerksattestBeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  PrintBand := not FieldIsNull(
    edWerksattest.DataSet.FieldByName(edWerksattest.DataField));
end;

procedure TRepWGZ.TrimL0Print(sender: TObject; var Value: String);
begin
  Value := LTrimCh(Value, '0');
end;

procedure TRepWGZ.ChildBand1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
var
  S: string;
begin
  S := Query1.FieldByName('ABHOLLAGER').AsString;
  AppendTok(S, Query1.FieldByName('BUETTE').AsString, ' / ');
  LaAbhollager.Caption := S;
end;

procedure TRepWGZ.SummaryBand1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Assign(Query1.FieldByName('BEMERKUNG'));
    laEichNr.Caption := L.Values['EichNr'];
  finally
    L.Free;
  end;
end;

end.
