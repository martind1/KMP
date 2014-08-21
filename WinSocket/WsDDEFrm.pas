unit WsDDEFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ScktComp, ComCtrls, WSDDEKmp, ExtCtrls;

type
  TFrmWsDDe = class(TForm)
    PageControl1: TPageControl;
    Server: TTabSheet;
    Client: TTabSheet;
    lbProt: TListBox;
    Label2: TLabel;
    EdClientRead: TEdit;
    BtnAntwort: TSpeedButton;
    EdClientWrite: TEdit;
    EdHost: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    EdRead: TEdit;
    EdWrite: TEdit;
    BtnWrite: TSpeedButton;
    Panel1: TPanel;
    EdPort: TEdit;
    Label1: TLabel;
    WSDDE1: TWSDDE;
    procedure EdPortChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EdHostChange(Sender: TObject);
    procedure BtnWriteClick(Sender: TObject);
    procedure BtnAntwortClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WSDDESvrChange(Sender: TObject);
    procedure WSDDECliChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmWsDDe: TFrmWsDDe;

implementation
{$R *.DFM}
uses
  Prots, CPro_Kmp;

procedure TFrmWsDDe.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmWsDDe.FormCreate(Sender: TObject);
begin
  EdPortChange(Sender);
  EdHostChange(Sender);
  PageControl1Change(Sender);
  Prot.Listbox := lbProt;
end;

procedure TFrmWsDDe.EdPortChange(Sender: TObject);
begin
  WSDDE1.Port := StrToInt(EdPort.Text);
end;

procedure TFrmWsDDe.EdHostChange(Sender: TObject);
begin
  WSDDE1.Host := EdHost.Text;
end;

procedure TFrmWsDDe.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = Server then
  begin
    WSDDE1.Remote := reHost;
    WSDDE1.OnChange := WSDDESvrChange;
  end else
  begin
    WSDDE1.Remote := reClient;
    WSDDE1.OnChange := WSDDECliChange;
  end;
end;

procedure TFrmWsDDe.BtnWriteClick(Sender: TObject);
begin
  BtnWrite.Down := false;
  WSDDE1.Text := EdWrite.Text;
end;

procedure TFrmWsDDe.BtnAntwortClick(Sender: TObject);
begin
  BtnAntwort.Down := false;
  WSDDE1.Text := EdClientWrite.Text;
end;

procedure TFrmWsDDe.WSDDESvrChange(Sender: TObject);
begin
  EdClientRead.Text := WSDDE1.Text;
end;

procedure TFrmWsDDe.WSDDECliChange(Sender: TObject);
begin
  EdRead.Text := WSDDE1.Text;
end;

end.
