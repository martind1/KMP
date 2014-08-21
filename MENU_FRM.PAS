unit Menu_frm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Uni, DBAccess, MemDS, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Psrc_kmp, Ausw_Kmp, Luedikmp, 
  Erconnec;

type
  TFrmMenu = class(TqForm)
    ScrollBox1: TScrollBox;
    LNavigator1: TLNavigator;
    BtnBein: TButton;
    BtnWerk: TButton;
    BtnTest: TButton;
    BtnAbout: TButton;
    Button3: TButton;
    BtnErrM: TButton;
    BtnComTerm: TButton;
    BtnBdiErr: TBitBtn;
    BtnDbStru: TButton;
    BtnExport: TButton;
    Query1: TuQuery;
    LDataSource1: TLDataSource;
    LookUpEdit1: TLookUpEdit;
    BitBtn1: TBitBtn;
    ErConnect1: TErConnect;
    BtnDdeSysInfo: TBitBtn;
    Button1: TButton;
    BtnZeitDlg: TBitBtn;
    BtnWSDDE: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnBeinClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnWerkClick(Sender: TObject);
    procedure BtnTestClick(Sender: TObject);
    procedure BtnAboutClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BtnErrMClick(Sender: TObject);
    procedure BtnComTermClick(Sender: TObject);
    procedure BtnBdiErrClick(Sender: TObject);
    procedure BtnDbStruClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BtnDdeSysInfoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnZeitDlgClick(Sender: TObject);
    procedure BtnWSDDEClick(Sender: TObject);
  protected
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmMenu: TFrmMenu;

implementation
{$R *.DFM}
uses
  Dialogs,
  GNav_Kmp, Prots,
  MainFrm, Aboutdlg, ZeitDlg,
  DbiTypes, DbiProcs, DbiErrs,
  WsDDeFrm;

procedure TFrmMenu.FormCreate(Sender: TObject);
begin
  InitWidth := GNavigator.PanelClient.Width;
  InitHeight := GNavigator.PanelClient.Height;
  NoRechteCheck := true;
  FrmMenu := self;
end;

procedure TFrmMenu.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Btn: word;
begin
  Btn := MessageDlg('Wollen Sie das Programm beenden ', mtConfirmation,
    [mbYes,mbNo,mbCancel], 0);
  if Btn = mrYes then
  begin
    FrmMain.Close;
    Action := caFree;
  end else
    Action := caNone;
end;

procedure TFrmMenu.FormDestroy(Sender: TObject);
begin
  FrmMenu := nil;
end;

procedure TFrmMenu.BtnBeinClick(Sender: TObject);
begin
  GNavigator.StartForm(self,'BEIN');
end;

procedure TFrmMenu.BtnWerkClick(Sender: TObject);
begin
  GNavigator.StartForm(self,'WERK');
end;

procedure TFrmMenu.BtnTestClick(Sender: TObject);
begin
  GNavigator.StartForm(self,'TEST');
end;

procedure TFrmMenu.BtnAboutClick(Sender: TObject);
begin
  DlgAbout.ShowModal;
end;

procedure TFrmMenu.Button3Click(Sender: TObject);
begin
  GNavigator.StartForm(self, 'QREDI');
end;

procedure TFrmMenu.BtnErrMClick(Sender: TObject);
begin
  GNavigator.StartForm(self,'ERRM');
end;

procedure TFrmMenu.BtnComTermClick(Sender: TObject);
begin
  GNavigator.StartForm(self,'CTER');
end;

procedure TFrmMenu.Button1Click(Sender: TObject);
begin
  GNavigator.StartForm(self,'CTER2');
end;

procedure TFrmMenu.BtnBdiErrClick(Sender: TObject);
var
  Category: byte;
  Code: byte;
  ResultCode: word;
  ErrorString: array[0..DBIMAXMSGLEN + 1] of char;
  Output: textfile;
  OutString: string;
begin
  DbiInit(nil);
  AssignFile(Output, 'ErrList.Txt');
  Rewrite(Output);
  for Category := ERRCAT_NONE to ERRCAT_RC do
    for Code := 0 to 255 do
    begin
      ResultCode := (Category shl 8) + Code;
      DbiGetErrorString(ResultCode, ErrorString);
      if StrLen(ErrorString) > 0 then
      begin
        OutString := Format('%6d  %0.4x  %s', [ResultCode, ResultCode, ErrorString]);
        WriteLn(Output, OutString);
      end;
    end;
  DbiExit;
end;

procedure TFrmMenu.BtnDbStruClick(Sender: TObject);
begin
  GNavigator.StartForm(self,'STRU');
end;

procedure TFrmMenu.BtnExportClick(Sender: TObject);
begin
  GNavigator.StartForm(self,'EXPORT');
end;

procedure TFrmMenu.BitBtn1Click(Sender: TObject);
begin
  {AuswKund.DoRun;}
end;

procedure TFrmMenu.BtnDdeSysInfoClick(Sender: TObject);
begin
  GNavigator.DdeSysInfoDlg;
end;

procedure TFrmMenu.BtnZeitDlgClick(Sender: TObject);
var
  ATime: TDateTime;
begin
  TDlgZeit.Run(ATime);
  DMess('Zeit=%s', [TimeToStr(ATime)]);
end;

procedure TFrmMenu.BtnWSDDEClick(Sender: TObject);
begin
  with TFrmWsDDe.Create(self) do
    Show;
end;

end.
