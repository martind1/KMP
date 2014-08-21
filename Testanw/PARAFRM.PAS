unit Parafrm;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, TabNotBk, ComCtrls, Mask, DBCtrls, DB,  Uni, DBAccess, MemDS,
  Grids, Dialogs,
  Qwf_Form, Lnav_kmp, Prots, FaWa_Kmp, LUDefkmp, Tabs,
  quickrpt, Qrctrls;

type
  {TGewichtForm = class(TqForm)
  public
    Gewicht : double;
  end;}

  TPrgParam = record
    Dummy: integer;
    DfltRepFramed: boolean;  //DfltRep
  end;

  TFrmPara = class(TqForm)
    DetailBook: TTabbedNotebook;
    Panel1: TPanel;
    Label4: TLabel;
    EdPcNr: TEdit;
    Query1: TuQuery;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    EdSQLDATUM: TDBEdit;
    Label9: TLabel;
    SgDrucker: TStringGrid;
    BtnDruckerEinrichten: TBitBtn;
    EdBenutzer: TEdit;
    Label1: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    LTabSet1: TLTabSet;
    GroupBox1: TGroupBox;
    cbProtBeforeOpen: TCheckBox;
    Label2: TLabel;
    EdAlias: TEdit;
    cbFormsInFrame: TCheckBox;
    cbFormsSizeable: TCheckBox;
    EdFaxPrefix: TEdit;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnDruckerEinrichtenClick(Sender: TObject);
    procedure NavBeforePost(ADataSet: TDataSet; var Done: Boolean);
    procedure NavStart(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    InGetIni : boolean;
    procedure GetIni;
    procedure PutIni;
    procedure FillDruckerGrid;
    procedure SetupLogo(QRImLogo: TQRImage; QrLaName: TQRLabel);
  end;

var
  FrmPara: TFrmPara;
  PrgParam: TPrgParam;

const
  BC_USER_GEWICHT = BC_USER + 1;

implementation
{$R *.DFM}
uses
  Messages, SysUtils, Printers,
  Err__Kmp, Ini__Kmp, GNav_Kmp, Poll_Kmp, RechtKmp, PrnFoDlg,
  MainFrm;

procedure TFrmPara.FillDruckerGrid;
(* SysParam -> Ed *)
var
  I, IRow, APrinterIndex: integer;
  APrinterName: string;
begin
  with SgDrucker do
  begin
    Cells[ 0, 0] := 'Kategorie';
    Cells[ 1, 0] := 'Idx';
    Cells[ 2, 0] := 'Drucker';
    RowCount := SysParam.Drucker.Count + 1;
    for I := 0 to SysParam.Drucker.Count - 1 do
    begin
      IRow := I + 1;
      Cells[ 0, IRow] := SysParam.Drucker.Param(I);
      Cells[ 1, IRow] := SysParam.Drucker.Value(I);
      try    APrinterIndex := StrToIntTol( SysParam.Drucker.Value(I));
      except APrinterIndex := -1;
      end;
      if (APrinterIndex < 0) or (APrinterIndex >= Printer.Printers.Count) then
      begin
        APrinterName := 'Standarddrucker';
      end else
        APrinterName := Printer.Printers.Strings[APrinterIndex];
      Cells[ 2, IRow] := APrinterName;
    end;
  end;
end;

procedure TFrmPara.GetIni;
(* INI -> PrgParam, Ed *)
begin
  if IniKmp <> nil then
  try
    InGetIni := true;

    IniKmp.ReadDrucker;
    FillDruckerGrid;

    SysParam.UserName := IniKmp.ReadString( 'Umgebung', 'UserName', '*');
    EdBenutzer.Text := SysParam.UserName;

    SysParam.PcNr := IniKmp.ReadString( 'Umgebung', 'PCNR', '00');
    EdPcNr.Text := SysParam.PcNr;

    SysParam.ProtBeforeOpen := IniKmp.ReadBool( 'System', 'ProtBeforeOpen', false);
    cbProtBeforeOpen.Checked := SysParam.ProtBeforeOpen;

    SysParam.FormsInFrame := IniKmp.ReadBool( 'System', 'FormsInFrame', false);
    cbFormsInFrame.Checked := SysParam.FormsInFrame;

    SysParam.FormsSizeable := IniKmp.ReadBool( 'System', 'FormsSizeable', false);
    cbFormsSizeable.Checked := SysParam.FormsSizeable;

    SysParam.Alias := IniKmp.ReadString( 'Umgebung', 'Alias', '');
    EdAlias.Text := SysParam.Alias;

    SysParam.FaxPrefix := IniKmp.ReadString( 'Umgebung', 'FaxPrefix', '');
    EdFaxPrefix.Text := SysParam.FaxPrefix;

  finally
    InGetIni := false;
  end;
end;

procedure TFrmPara.PutIni;
(* Ed -> PrgParam, INI *)
begin
  if IniKmp <> nil then
  begin
    SysParam.PcNr := EdPcNr.Text;
    IniKmp.WriteString( 'Umgebung', 'PCNR', SysParam.PcNr);

    SysParam.UserName := EdBenutzer.Text;
    IniKmp.WriteString( 'Umgebung', 'UserName', SysParam.UserName);

    SysParam.ProtBeforeOpen := cbProtBeforeOpen.Checked;
    IniKmp.WriteBool( 'System', 'ProtBeforeOpen', SysParam.ProtBeforeOpen);

    SysParam.FormsInFrame := cbFormsInFrame.Checked;
    IniKmp.WriteBool( 'System', 'FormsInFrame', SysParam.FormsInFrame);

    SysParam.FormsSizeable := cbFormsSizeable.Checked;
    IniKmp.WriteBool( 'System', 'FormsSizeable', SysParam.FormsSizeable);

    SysParam.Alias := EdAlias.Text;
    IniKmp.WriteString( 'Umgebung', 'Alias', SysParam.Alias);

    SysParam.FaxPrefix := EdFaxPrefix.Text;
    IniKmp.WriteString( 'Umgebung', 'FaxPrefix', SysParam.FaxPrefix);

    IniKmp.WriteDrucker;
  end;
end;

procedure TFrmPara.FormCreate(Sender: TObject);
begin
  FrmPara := self;
  NoRechteCheck := true;
  GetIni;
end;

procedure TFrmPara.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PutIni;  {kein LNav}
  GetIni;
  Action := caMinimize;
end;

procedure TFrmPara.NavStart(Sender: TObject);
begin
  GetIni;
end;

procedure TFrmPara.NavBeforePost(ADataSet: TDataSet;
  var Done: Boolean);
begin
  PutIni;
  PostMessage( Handle, WM_CLOSE, LPARAM(0), WPARAM(0));
end;

(*** Buttonmethoden *********************************************************)

procedure TFrmPara.BtnDruckerEinrichtenClick(Sender: TObject);
var
  I: integer;
  ADruckerTyp: string;
begin
  I := SgDrucker.Row - 1;
  ADruckerTyp := SysParam.Drucker.Param(I);
  SetupPrinter( ADruckerTyp);
  FillDruckerGrid;
end;

(*** Zusatzmethoden für externen Auftruf *************************************)

procedure TFrmPara.SetupLogo(QRImLogo: TQRImage; QrLaName: TQRLabel);
begin
  //für DfltRep
end;

end.

