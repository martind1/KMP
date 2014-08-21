unit Ddesidlg;
(* DDE Server für Rechteverwaltung (Rechte32.exe)

10.03.09 md  LaFoName entspricht jetzt der Rechteverwaltung (Frm+<Kurz> statt Classname)
*)
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls, DdeMan,
  Menus, ExtCtrls, Buttons, Lnav_kmp, Qwf_Form;

type
  TDlgDdeSysInfo = class(TqForm)
    SysInfo: TDdeServerConv;
    GetFormsInfo: TDdeServerItem;
    Label3: TLabel;
    Label4: TLabel;
    LaServiceName: TLabel;
    Bevel1: TBevel;
    Edit1: TMemo;
    GetObjektInfo: TDdeServerItem;
    LNavigator1: TLNavigator;
    Panel1: TPanel;
    LaFoName: TLabel;
    LaKoName: TLabel;
    Panel2: TPanel;
    BtnClose: TBitBtn;
    procedure BtnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GetObjektInfoPokeData(Sender: TObject);

  private
    MenuStrParent, MenuStrControl: string;
    procedure Poll(Sender: TObject);
    function DisplayControl(AControl: TControl): string;
  public
    { Public declarations }
    procedure SetMenuItem(aForm: TqForm; aMenuItem: TMenuItem);
  end;

var
  DlgDdeSysInfo: TDlgDdeSysInfo;

implementation
{$R *.DFM}
uses
  Dialogs, SysUtils, Messages, ComCtrls,
  Prots, GNav_Kmp, Poll_Kmp;

procedure TDlgDdeSysInfo.FormCreate(Sender: TObject);
var
  NextS: string;
begin
  DlgDdeSysInfo := self;
  LaServiceName.Caption :=
   'Service Name: ' + '"' +
     PStrTok(ExtractFileName(Application.ExeName), '.', NextS) + '"';
  {Rest in TGNavigator.DdeSysInfoDlg}
  PollKmp.Add(Poll, SysInfo, 250);
end;

procedure TDlgDdeSysInfo.FormDestroy(Sender: TObject);
begin
  if PollKmp <> nil then
    PollKmp.Sub(Poll, SysInfo);
  DlgDdeSysInfo := nil;
end;

function TDlgDdeSysInfo.DisplayControl(AControl: TControl): string;
begin
  if AControl = nil then
    Result := 'nil'
  else
  if (AControl is TqForm) and (TqForm(AControl).Kurz <> '') then
    Result := 'FRM' + Uppercase(TqForm(AControl).Kurz)
  else
  if AControl is TCustomForm then
    //TFrmMain -> FrmMain
    Result := copy(AControl.Classname, 2, MaxInt)
  else
  if (AControl is TPageControl) and (TPageControl(AControl).ActivePage <> nil) then
    Result := AControl.Name + '.' + TPageControl(AControl).ActivePage.Name
  else
    Result := AControl.Name;
end;

procedure TDlgDdeSysInfo.SetMenuItem(aForm: TqForm; aMenuItem: TMenuItem);
begin
  if (aForm = nil) or (aMenuItem = nil) then
  begin
    MenuStrParent := '';
    MenuStrControl := '';
  end else
  begin
    MenuStrParent := DisplayControl(aForm);
    MenuStrControl := aMenuItem.Name;
  end;
end;

procedure TDlgDdeSysInfo.Poll(Sender: TObject);
(* Zeigt Aktuelles Formular und Komponente bzgl. Mausposition *)
var
  P: TPoint;
  AControl: TControl;
  AParent: TWinControl;
  StrControl, StrParent, StrParents: string;
begin
  if MenuStrParent <> '' then
  begin
    LaFoName.Caption := MenuStrParent; //StrParents
    LaKoName.Caption := MenuStrControl; //AControl.Name;
  end else
  with Screen.ActiveForm do
  begin
    GetCursorPos(P);
    AControl := FindDragTarget(P, false);
    StrParents := '';
    if AControl <> nil then
    begin
      StrControl := DisplayControl(AControl);
      AParent := AControl.Parent;
      while AParent <> nil do
      begin
        if StrControl = '' then
          StrControl := AParent.Name;
        if AParent is TCustomFrame then
          StrControl := AParent.Name + '.' + StrControl;

        StrParent := DisplayControl(AParent);
        if StrParents = '' then
          StrParents := StrParent else
          StrParents := StrParent + '.' + StrParents;
        AParent := AParent.Parent;
      end;
    end else
      StrControl := '(nil)';
    if StrParents = '' then
    begin
      StrParent := DisplayControl(Screen.ActiveForm);
      StrParents := StrParent;
    end;
    LaFoName.Caption := StrParent; //StrParents
    LaKoName.Caption := StrControl; //AControl.Name;
  end;
end;

procedure TDlgDdeSysInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDlgDdeSysInfo.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDlgDdeSysInfo.GetObjektInfoPokeData(Sender: TObject);
(* Reaktion auf PokeData von DDE Client *)
var
  AFormKurz: string;
  L: longint;
  P: PChar;
begin
  AFormKurz := GetObjektInfo.Text;  {copy(GetObjektInfo.Text, 4, 200); in GNav}
  try
    GNavigator.DdeObjektInfo(AFormKurz, Edit1.Lines);
  finally
    {GetObjektInfo.Lines.Assign(Edit1.Lines);}
    L := SendMessage(Edit1.Handle, WM_GETTEXTLENGTH, 0, 0);
    P := StrAlloc(L+1);
    SendMessage(Edit1.Handle, WM_GETTEXT, L, LPARAM(P));
    GetObjektInfo.Lines.SetText(P);
    StrDispose(P);
  end;
end;

end.
