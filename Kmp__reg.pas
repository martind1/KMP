unit Kmp__Reg;
(* KMP Registrieren
01.02.02 MD TOpcS7
03.03.02 MD LlPrn
17.03.02 MD TL8MD
16.04.02 MD TqSplitter
15.05.02 MD TL8MD und LLPrn entfernt. Jetzt in Addons\combit
28.07.02 MD WSDDE
30.09.02 MD Property Editoren in PropEds.pas; Kompatibilitäts-Typen in LNav_Kmp.pas
11.10.02 TS Disomat B+ DDP 8785 (DisB87Kmp), Pfister Deutag-Protokoll (WtSohKmp)
            Essmann, Dwt10Soh, Dwt2Soh
03.12.02 TS MCI__KMP (Bizerba)
21.05.03 MD DISK (Schenk Disomat-K), IT30
18.10.03 MD IniDbKmp
28.09.04 MD FileBtn
29.09.04 MD FawaWS
03.12.06 MB GtQrExt ausgelagert in addons\gnosticeKmp
17.12.06 MD Dwt410
11.02.07 MD CollapsePanel
02.11.07 MD AWE560
04.02.08 MD PR1613 Winsocket Client
04.06.08 MD Inmemkmp, Datn_Kmp
30.07.08 MD ADO__Kmp
02.08.08 MD TWordPrn
19.08.08 MD NXls_Kmp
10.10.08 MD WSPort
22.12.08 MD IT60
19.04.09 MD QTreeView
27.04.09 MD QDBCtrlGrid
25.09.09 MD Row10net
  12.11.09 MD SizeControls
  25.11.09 MD TAswCheckListBox
  07.12.09 MD TExcelPrn
  17.02.10 MD TCheckListBoxAsw
  18.02.10 MD TRadioGroupAsw
  16.05.10 MD Soe3030Kmp
  19.06.10 MG RAG701
  28.07.10 MD TQRStringGrid
  29.03.11 md  rhewa83z
17.10.09 MD  Delphi 2010 - DesignPackage getrennt
18.02.10 MD TRadioGroupAsw
02.11.11 md  TAliasNameProperty
22.11.11 md  Mettler

*)
interface

procedure Register;

implementation
{$R Kmp__reg.dcr}
uses
  Classes, Controls, comctrls,
  DesignIntf, PropEds,
  UDB__KMP, UQue_Kmp, UTbl_Kmp, USes_Kmp, UDS__Kmp, UMem_Kmp, UMetaKmp, UPro_Kmp,
  Sql__Dlg, DatumDlg,
  QNav_Kmp, GNav_Kmp, LNav_Kmp, LuDefKmp, LuEdiKmp, Prots,
  RzLabel, Qwf_Form, Err__Kmp, LuBtnKmp, MuGriKmp, CtrlMuGriKmp, Btnp_kmp,
  QRepForm, PSrc_Kmp, RechtKmp, CPor_Kmp, CPro_Kmp, Ini__Kmp, Poll_Kmp,
  FaWa_Kmp, Sche_Kmp, Dis39Kmp, Row7_Kmp, Pf11_Kmp, Dwt11Kmp, DwSohKmp, Dwt2Kmp,
  WT65_Kmp, WT60_Kmp, WT60TKmp, B051_Kmp, Mp85Kmp, RAG701Kmp, DdeGewichtKmp,
  MettlerKmp,
  Ro8EnqKmp, Ro8_3964Kmp, Row10net_Kmp, Soe3030Kmp, WoeDatKmp, Rhewa83zKmp,
  Dwt2SohKmp, Dwt10Kmp, WtSohKmp, DisB87Kmp, DisTrasKmp, Mci__Kmp,
  PR161Kmp, PR171Kmp,
  FawaWsKmp, Pr1613WsKmp, WSPortKmp,
  EssmKmp, DisKKmp, IT30Kmp, IT60Kmp, DwtEnqKmp, DWT410kmp, AWE560Kmp,
  Asws_Kmp, Repl_Kmp, Gen__Kmp, TGridKmp, Ausw_Kmp, QrExt,
  ErConnec, TabNbKmp, Radios, WaShare,
  CalcDlg, qLab_Kmp, ADO__Kmp, NXls_Kmp,
  WRep_Kmp, WordPrnKmp, ExcelPrnKmp, Qr3DCnvs, EmailSendKmp,
  Arc__Kmp,
  ZeitDlg, SpsProt, QEdi_Kmp, FDDE_Kmp, WSDDEKmp, QSpin_Kmp,
  OpcS7Kmp,
  qSplitter, IniDbKmp, CollapsePanel, QTreeView, QDBCtrlGrid,
  Datn_Kmp, SizeControls;

(* Register *)
procedure Register;
begin
  {RegisterComponents('Addons', [TMemoryTable]);}
  //RegisterComponents('Addons', [TStopWatch]);

  (* Addons *)
  RegisterComponents('Addons', [TRadios]);
  RegisterComponents('Addons', [TqSplitter]);
  RegisterComponents('Addons', [TCollapsePanel]);
  RegisterComponents('Addons', [TOpenBtn]);
  RegisterComponents('Addons', [TDirBtn]);
  RegisterComponents('Addons', [TQTreeView]);
  RegisterComponents('Addons', [TQDBCtrlGrid]);
  RegisterComponents('Addons', [TSizeControls]);

  (* GNAV *)
  RegisterComponents('GNAV', [TGNavigator]);
  RegisterComponents('GNAV', [TDBQBENav]);
  RegisterComponents('GNAV', [TError]);
  RegisterComponents('GNAV', [TProt]);
  RegisterComponents('GNAV', [TIniKmp]);
  RegisterComponents('GNAV', [TIniDbKmp]);
  RegisterComponents('GNAV', [TDatnKmp]);
  RegisterComponents('GNAV', [THintIni]);
  RegisterComponents('GNAV', [TPollKmp]);
  RegisterComponents('GNAV', [TRechte]);
  RegisterComponents('GNAV', [TAsw]);

  RegisterComponents('GNAV', [TRepl]);
  //d14 entfernt 17.10.09 - RegisterComponents('GNAV', [TExport]);

  RegisterComponents('GNAV', [TRzLabel]);
  RegisterComponents('GNAV', [TErConnect]);

  RegisterComponents('GNAV', [TqForm]);
  RegisterComponents('GNAV', [TQRepForm]);

  RegisterComponents('GNAV', [TEmailSendKmp]);

  RegisterComponents('ADO', [TqADOConnection]);

  (* LNAV *)
  RegisterComponents('LNAV', [TLNavigator]);
  RegisterComponents('LNAV', [TLDataSource]);
  RegisterComponents('LNAV', [TLTabSet]);
  RegisterComponents('LNAV', [TqNoteBook]);
  RegisterComponents('LNAV', [TqTabbedNoteBook]);
  RegisterComponents('LNAV', [TBtnPage]);
  RegisterComponents('LNAV', [TqBtnMuSi]);

  RegisterComponents('LNAV', [TPrnSource]);
  RegisterComponents('LNAV', [TAusw]);
  RegisterComponents('LNAV', [TWordPrn]);  //02.08.08
  RegisterComponents('LNAV', [TExcelPrn]);  //07.12.09

  RegisterComponents('LNAV', [TMultiGrid]);
  RegisterComponents('LNAV', [TCtrlMultiGrid]);
  RegisterComponents('LNAV', [TGenerator]);

  RegisterComponents('LNAV', [TLookUpDef]);
  RegisterComponents('LNAV', [TLookUpEdit]);
  RegisterComponents('LNAV', [TLookUpMemo]);
  RegisterComponents('LNAV', [TLookUpBtn]);
  RegisterComponents('LNAV', [TLovBtn]);

  RegisterComponents('LNAV', [TAswComboBox]);
  RegisterComponents('LNAV', [TAswCheckBox]);
  RegisterComponents('LNAV', [TAswRadioGroup]);
  RegisterComponents('LNAV', [TAswCheckListBox]);  //25.11.09
  RegisterComponents('LNAV', [TCheckListBoxAsw]);  //17.02.10
  RegisterComponents('LNAV', [TRadioGroupAsw]);
  RegisterComponents('LNAV', [TComboBoxAsw]);
  RegisterComponents('LNAV', [TRadioGroupAsw]);

  RegisterComponents('LNAV', [TDatumBtn]);
  RegisterComponents('LNAV', [TTimeSpin]);
  RegisterComponents('LNAV', [TTimeBtn]);
  RegisterComponents('LNAV', [TFileBtn]);
  RegisterComponents('LNAV', [TCalcBtn]);

  RegisterComponents('LNAV', [TTitleGrid]);
  RegisterComponents('LNAV', [TqEdit]);
  RegisterComponents('LNAV', [TqLabel]);
  RegisterComponents('LNAV', [TqSpin]);
  RegisterComponents('LNAV', [TNXlsKmp]);

  (* UKmp *)
  RegisterComponents('UKmp', [TuDataSource]);
  RegisterComponents('UKmp', [TuMemTable]);
  RegisterComponents('UKmp', [TuDataBase]);
  RegisterComponents('UKmp', [TuDataSource]);
  RegisterComponents('UKmp', [TuMemTable]);
  RegisterComponents('UKmp', [TuMetadata]);
  RegisterComponents('UKmp', [TuStoredProc]);
  RegisterComponents('UKmp', [TuQuery]);
  RegisterComponents('UKmp', [TuSession]);
  RegisterComponents('UKmp', [TuTable]);

  (* COM *)
  RegisterComponents('COM', [TFDDE]);
  RegisterComponents('COM', [TWSDDE]);
  RegisterComponents('COM', [TComPort]);
  RegisterComponents('COM', [TWSPort]);       //WinSocket ComPort (DWT800Net)
  RegisterComponents('COM', [TComProt]);
  RegisterComponents('COM', [TFaWaKmp]);
  RegisterComponents('COM', [TFaWaWS]);       //WinSocket Remote
  RegisterComponents('COM', [TScheKmp]);
  RegisterComponents('COM', [TDis39Kmp]);
  RegisterComponents('COM', [TMettlerKmp]);  //22.11.11 Polen
  RegisterComponents('COM', [TDisB87Kmp]);
  RegisterComponents('COM', [TDisTrasKmp]);
  RegisterComponents('COM', [TRow7Kmp]);
  RegisterComponents('COM', [TRow10NetKmp]);
  RegisterComponents('COM', [TPf11Kmp]);
  RegisterComponents('COM', [TDwt11Kmp]);
  RegisterComponents('COM', [TDwtSohKmp]);
  RegisterComponents('COM', [TDwt10Kmp]);
  RegisterComponents('COM', [TDwt2Kmp]);
  RegisterComponents('COM', [TDwt2SohKmp]);
  RegisterComponents('COM', [TWaShare]);
  RegisterComponents('COM', [TSpsProt]);
  RegisterComponents('COM', [TWT65Kmp]);
  RegisterComponents('COM', [TWT60Kmp]);
  RegisterComponents('COM', [TWT60TKmp]);
  RegisterComponents('COM', [TB051Kmp]);
  RegisterComponents('COM', [TPR1613]);
  RegisterComponents('COM', [TPr1613Ws]);       //WinSocket Remote
  RegisterComponents('COM', [TPR1713]);
  RegisterComponents('COM', [TDDEGewichtKmp]);
  RegisterComponents('COM', [TWtSohKmp]);      {Widra-Waage mit DEUTAG-Protokoll (Pfister-SOH)}
  RegisterComponents('COM', [TEssmannKmp]);
  RegisterComponents('COM', [TMciKmp]);        {Bizerba MCI (Minimalversion)}
  RegisterComponents('COM', [TDisKKmp]);       {Disomat-K (mit Fernanzeige)}
  RegisterComponents('COM', [TIT30Kmp]);       {SysTec IT3000}
  RegisterComponents('COM', [TIT60Kmp]);       {SysTec IT6000}
  RegisterComponents('COM', [TDwtEnq]);        {DWT2 ENQ}
  RegisterComponents('COM', [TDwt410Kmp]);     {DWT410 MPP}
  RegisterComponents('COM', [TAwe560Kmp]);     {AWE 560}
  RegisterComponents('COM', [TSoe3030Kmp]);    {Soehnle 3030 Terminal}
  RegisterComponents('COM', [TWoeDatKmp]);     //Wöhwa Datei QW MA 20.10.13

  RegisterComponents('COM', [TArcNet]);
  RegisterComponents('COM', [TSpsArc]);

  RegisterComponents('COM', [TMP85]);
  RegisterComponents('COM', [TRo8Enq]);
  RegisterComponents('COM', [TRo8_3964]);
  RegisterComponents('COM', [TOpcS7]);
  RegisterComponents('COM', [TRAG701]);
  RegisterComponents('COM', [Rhewa83z]);

  (* Quickreport Erweiterung: *)
  RegisterComponents('QReport', [TQRCheckBox]);
  RegisterComponents('QReport', [TQRDbCheckBox]);
  RegisterComponents('QReport', [TQRDBMemo]);
  RegisterComponents('QReport', [TQRDBFltr]);
  RegisterComponents('QReport', [TQRRawData]);
  RegisterComponents('QReport', [TQRPaintBox]);
  RegisterComponents('QReport', [TQR3DCanvas]);
  RegisterComponents('QReport', [TQRStringGrid]);
{$ifdef ver100}
  RegisterNonActiveX([TQRCheckBox, TQRDbCheckBox]);
  RegisterNonActiveX([TQRDBMemo]);
{$endif}
  RegisterComponents('QReport', [TWRep]);

  (* Combit List&Label Erweiterung:
  RegisterComponents('LNAV', [TLlPrn]);  in addons\combit\LL___REG
  RegisterComponents('combit', [TL8MD]);   dto.   *)

  (* Property Editoren: *)
  RegisterPropertyEditor(TypeInfo(string), TMultiGrid, 'DragFieldName', TDragFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TPrnSource, 'DruckerTyp', TDruckerTypProperty);
  RegisterPropertyEditor(TypeInfo(string), TAswCombobox, 'AswName', TAswNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TAswCheckBox, 'AswName', TAswNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TAswRadioGroup, 'AswName', TAswNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TAswCheckListBox, 'AswName', TAswNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TCheckListBoxAsw, 'AswName', TAswNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TComboboxAsw, 'AswName', TAswNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TRadioGroupAsw, 'AswName', TAswNameProperty);
  {RegisterPropertyEditor(TypeInfo(string), TCheckBoxAsw, 'AswName', TAswNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TRadioGroupAsw, 'AswName', TAswNameProperty);}
  RegisterPropertyEditor(TypeInfo(string), TAusw, 'DateField', TDateFieldProperty);
  RegisterPropertyEditor(TypeInfo(TWinControl), TLNavigator, 'Pagebook', TPagebookProperty);
  RegisterPropertyEditor(TypeInfo(TWinControl), TLNavigator, 'TabSet', TTabSetProperty);
  //von Delphi übernommen:
  RegisterPropertyEditor(TypeInfo(string), TIniDbKmp, 'DatabaseName', TIniDatabaseNameProperty);
  //D2010:
  RegisterPropertyEditor(TypeInfo(string), TuDataBase, 'AliasName', TAliasNameProperty);
end;

end.
