program Kmp__prj;



uses
  Forms,
  GNAV_KMP in 'GNAV_KMP.PAS',
  LUDEFKMP in 'LUDEFKMP.PAS',
  NSTR_KMP in 'NSTR_KMP.PAS',
  TOOLS in 'TOOLS.PAS',
  QNAV_KMP in 'QNAV_KMP.PAS',
  BTNP_KMP in 'BTNP_KMP.PAS',
  RZLABEL in 'RZLABEL.PAS',
  QWF_FORM in 'QWF_FORM.PAS',
  BEINFRM in 'BEINFRM.PAS' {FrmBein},
  ERR__KMP in 'ERR__KMP.PAS' {DlgErr},
  MAINFRM in 'MAINFRM.PAS' {FrmMain},
  LNAV_KMP in 'LNAV_KMP.PAS',
  DPOS_KMP in 'DPOS_KMP.PAS',
  PRN__DLG in 'PRN__DLG.PAS' {DlgPrn},
  SQL__DLG in 'SQL__DLG.PAS' {DlgSql},
  LUBTNKMP in 'LUBTNKMP.PAS',
  MUGRIKMP in 'MUGRIKMP.PAS',
  ERRMFRM in 'ERRMFRM.PAS' {FrmErrM},
  LUEDIKMP in 'LUEDIKMP.PAS',
  SORT_DLG in 'SORT_DLG.PAS' {DlgSort},
  QREPFORM in 'QREPFORM.PAS',
  PSRC_KMP in 'PSRC_KMP.PAS',
  STRUFRM in 'STRUFRM.PAS' {FrmStru},
  LUGRIDLG in 'LUGRIDLG.PAS' {DlgLuGrid},
  CalcCache in 'CalcCache.PAS',
  RECHTKMP in 'RECHTKMP.PAS',
  BEINREP in 'BEINREP.PAS' {RepBein},
  STRUREP in 'STRUREP.PAS' {RepStru},
  CPOR_KMP in 'CPOR_KMP.PAS',
  Ini__Dlg in 'Ini__Dlg.pas' {DlgIni},
  INI__KMP in 'INI__KMP.PAS',
  CPRO_KMP in 'CPRO_KMP.PAS',
  CTERFRM in 'CTERFRM.PAS' {frmCTer},
  CTELFRM in 'CTELFRM.PAS' {frmCTel},
  POLL_KMP in 'POLL_KMP.PAS',
  TESTFRM in 'TESTFRM.PAS' {FrmTest},
  FAWA_KMP in 'FAWA_KMP.PAS',
  SCHE_KMP in 'SCHE_KMP.PAS',
  ROW7_KMP in 'ROW7_KMP.PAS',
  ASWS_KMP in 'ASWS_KMP.PAS',
  DATUMDLG in 'DATUMDLG.PAS' {DlgDatum},
  WERKFRM in 'WERKFRM.PAS' {FrmWerk},
  WERKREP in 'WERKREP.PAS' {RepWerk},
  PARAFRM in 'PARAFRM.PAS' {FrmPara},
  GEN__KMP in 'GEN__KMP.PAS',
  QTreeView in 'QTreeView.pas',
  QREXT in 'QREXT.PAS',
  EXP__DLG in 'EXP__DLG.pas' {DlgExport},
  ABOUTDLG in 'ABOUTDLG.PAS' {DlgAbout},
  TABNBKMP in 'TABNBKMP.PAS',
  PRNFODLG in 'PRNFODLG.PAS' {DlgPrnFont},
  AUSW_KMP in 'AUSW_KMP.PAS',
  AUSW_DLG in 'AUSW_DLG.PAS' {DlgAusw},
  MENU_FRM in 'MENU_FRM.PAS' {FrmMenu},
  ABORTDLG in 'ABORTDLG.PAS' {DlgAbort},
  CHANGDLG in 'CHANGDLG.PAS' {DlgChange},
  REPLFRM in 'REPLFRM.PAS' {FrmRepl},
  PROTS in 'PROTS.PAS',
  DWT410kmp in 'DWT410kmp.PAS',
  ERCONNEC in 'ERCONNEC.PAS',
  EXP__KMP in 'EXP__KMP.pas',
  TGRIDKMP in 'TGRIDKMP.PAS',
  STR__DLG in 'STR__DLG.PAS' {DlgStrings},
  FLDDEDLG in 'FLDDEDLG.PAS' {DlgFldDesc},
  ADO__Kmp in 'ADO__Kmp.PAS',
  DDESIDLG in 'DDESIDLG.PAS' {DlgDdeSysInfo},
  RADIOS in 'RADIOS.PAS',
  WASHARE in 'WASHARE.PAS',
  CTER2FRM in 'CTER2FRM.PAS' {frmCTer2},
  MAKRODLG in 'MAKRODLG.PAS' {DlgMakro},
  ZEITDLG in 'ZEITDLG.PAS' {DlgZeit},
  KONV_DLG in 'KONV_DLG.PAS' {DlgKonvert},
  SpsProt in 'SpsProt.pas',
  Ctsetdlg in 'Ctsetdlg.pas' {DlgCtSet},
  wt65_kmp in 'wt65_kmp.pas',
  FDDE_Kmp in 'FDDE_Kmp.pas',
  FldDsKmp in 'FldDsKmp.pas',
  CalcDlg in 'CalcDlg.pas' {DlgCalc},
  PR161Kmp in 'PR161Kmp.pas',
  B051_kmp in 'B051_kmp.pas',
  Wt60tkmp in 'Wt60tkmp.pas',
  AswEdDlg in 'AswEdDlg.pas' {DlgAswEd},
  Asw__dlg in 'Asw__dlg.pas' {DlgAsw},
  MMGrDlg in 'MMGrDlg.pas' {DlgMMgr},
  QrPreDlg in 'QrPreDlg.pas' {DlgQRPreview},
  MuGriDlg in 'MuGriDlg.pas' {DlgMuGri},
  PropsDlg in 'PropsDlg.pas' {DlgProps},
  ProtFrm in 'ProtFrm.pas' {FrmProt},
  Dis39kmp in 'Dis39kmp.pas',
  KmpResString in 'KmpResString.pas',
  QSpin_kmp in 'QSpin_kmp.pas',
  OpcS7Kmp in 'OpcS7Kmp.pas',
  OPCtypes in 'OPCtypes.pas',
  OPCDA in 'OPCDA.pas',
  OPCutils in 'OPCutils.pas',
  WSDDEKmp in 'WSDDEKmp.pas',
  WsDDEFrm in 'WinSocket\WsDDEFrm.pas' {FrmWsDDe},
  StopWatch in 'StopWatch.pas',
  XMLExport in 'XML\XMLExport.pas',
  Arc__Kmp in 'Arc__Kmp.pas',
  ddegewichtkmp in 'ddegewichtkmp.pas',
  DEVIFRM in 'DEVIFRM.PAS' {FrmDevi},
  DWSOHKMP in 'DWSOHKMP.PAS',
  Dwt2kmp in 'Dwt2kmp.pas',
  ESSMKMP in 'ESSMKMP.PAS',
  KMP__REG in 'KMP__REG.pas',
  PropEds in 'PropEds.pas',
  XmlExpDlg in 'XmlExpDlg.pas' {DlgXMLEXP},
  DisKKmp in 'DisKKmp.pas',
  Mci__Kmp in 'Mci__Kmp.pas',
  IT30Kmp in 'IT30Kmp.pas',
  PR171Kmp in 'PR171Kmp.pas',
  IniDbkmp in 'IniDbkmp.pas',
  NLnk_Kmp in 'NLnk_Kmp.pas',
  Ro8_3964Simul in 'Ro8_3964Simul.pas' {DlgRo8Simul},
  Ro8_3964Kmp in 'Ro8_3964Kmp.pas',
  Ro8EnqKmp in 'Ro8EnqKmp.pas',
  EmailSendKmp in 'EmailSendKmp.pas',
  Dwt11kmp in 'Dwt11kmp.pas',
  CollapsePanel in 'CollapsePanel.pas',
  ShellTools in 'ShellTools.pas',
  dfltrep in 'dfltrep.pas' {RepDflt},
  SystemKmp in 'SystemKmp.pas',
  AWE560Kmp in 'AWE560Kmp.pas',
  WtSohKmp in 'WtSohKmp.pas',
  WT60_Kmp in 'WT60_Kmp.pas',
  IEEEFloatClass in 'IEEEFloatClass.pas',
  Pr1613WsKmp in 'Pr1613WsKmp.pas',
  Datn_Kmp in 'Datn_Kmp.pas',
  Db___Kmp in 'Db___Kmp.pas',
  WordPrnKmp in 'WordPrnKmp.pas',
  QSTRINGL in 'QSTRINGL.PAS';

{$R *.RES}

begin
  Application.Initialize;
  begin
    Application.Title := 'Komponenten f�r Delphi';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TDlgAbout, DlgAbout);
  GNavigator.StartForm(Application,'PARA');
  FrmPara.Enabled := true;
  FrmMain.ArrangeIcons;
  GNavigator.StartForm(Application,'MENU');
  Application.Run;
  end;
end.
