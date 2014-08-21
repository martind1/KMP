unit Ctelfrm;

interface

uses Messages, WinTypes, WinProcs, Classes, Graphics, Forms, Controls,
     StdCtrls, ExtCtrls, Menus, SysUtils, Dialogs,
     Qwf_Form, Cpor_kmp, Buttons;
type
  TInOut = (ioIn, ioOut);

  TfrmCTel = class(TqForm)
    ComPort1: TComPort;
    PaSpeedBar: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    MiConfig: TMenuItem;
    MiOpen: TMenuItem;
    MiClose: TMenuItem;
    MiInfo: TMenuItem;
    BtnConfig: TSpeedButton;
    BtnOpen: TSpeedButton;
    BtnClose: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure OpenPort;
    procedure ClosePort;
    procedure MiConfigClick(Sender: TObject);
    procedure MiCloseClick(Sender: TObject);
    procedure MiOpenClick(Sender: TObject);
    procedure MiInfoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
    InKeyPress: boolean;
    CtrlState: boolean;
    InOut: TInOut;
  end;

var
  frmCTel: TfrmCTel;

implementation
{$R *.DFM}
uses
  Prots, CtSetDlg;

procedure TfrmCTel.MiConfigClick(Sender: TObject);
begin
  if DlgCtSet = nil then
    DlgCtSet := TDlgCtSet.Create(self);
  try
    { shouldn't be able to change port # if port is open }
    DlgCtSet.cboPort.Enabled := MiOpen.Enabled;
    { read settings from comm control into settings dialog }
    DlgCtSet.cboPort.ItemIndex := ComPort1.Port;
    DlgCtSet.cboBaud.ItemIndex := Ord(ComPort1.BaudRate);
    DlgCtSet.cboData.ItemIndex := Ord(ComPort1.DataBits);
    DlgCtSet.cboParity.ItemIndex := Ord(ComPort1.ParityBits);
    DlgCtSet.cboStop.ItemIndex := Ord(ComPort1.StopBits);
    DlgCtSet.cboFlow.ItemIndex := Ord(ComPort1.FlowControl);
    { show settings dialog }
    DlgCtSet.ShowModal;
    { copy settings from dialog into comm control }
    ComPort1.Port := DlgCtSet.cboPort.ItemIndex;
    case DlgCtSet.cboBaud.ItemIndex of
      0: ComPort1.BaudRate := br110;
      1: ComPort1.BaudRate := br300;
      2: ComPort1.BaudRate := br600;
      3: ComPort1.BaudRate := br1200;
      4: ComPort1.BaudRate := br2400;
      5: ComPort1.BaudRate := br4800;
      6: ComPort1.BaudRate := br9600;
      7: ComPort1.BaudRate := br14400;
      8: ComPort1.BaudRate := br19200;
      9: ComPort1.BaudRate := br38400;
      10: ComPort1.BaudRate := br56000;
      11: ComPort1.BaudRate := br128000;
      12: ComPort1.BaudRate := br256000;
    end;
    case DlgCtSet.cboParity.ItemIndex of
      0: ComPort1.ParityBits := pbNone;
      1: ComPort1.ParityBits := pbOdd;
      2: ComPort1.ParityBits := pbEven;
      3: ComPort1.ParityBits := pbMark;
      4: ComPort1.ParityBits := pbSpace;
    end;
    case DlgCtSet.cboData.ItemIndex of
      0: ComPort1.DataBits := dbFour;
      1: ComPort1.DataBits := dbFive;
      2: ComPort1.DataBits := dbSix;
      3: ComPort1.DataBits := dbSeven;
      4: ComPort1.DataBits := dbEight;
    end;
    case DlgCtSet.cboStop.ItemIndex of
      0: ComPort1.StopBits := sbOne;
      1: ComPort1.StopBits := sbOnePointFive;
      2: ComPort1.StopBits := sbTwo;
    end;
    case DlgCtSet.cboFlow.ItemIndex of
      0: ComPort1.FlowControl := fcNone;
      1: ComPort1.FlowControl := fcRTSCTS;
      2: ComPort1.FlowControl := fcXONXOFF;
    end;
  finally
    DlgCtSet.Free;
    DlgCtSet := nil;
  end;
end;

procedure TfrmCTel.MiInfoClick(Sender: TObject);
begin
  MessageFmt('ComPort Komponente' + CRLF + 'Version %02.1f', [ComPort1.Version],
             mtInformation, [mbOK], 0);
end;

{ attempt to open the port and sets window options appropriately }
procedure TfrmCTel.OpenPort;
var
  temp: array [0..254] of char;
begin
  if (not ComPort1.Open) then
  begin
    Application.MessageBox( StrPCopy( temp, ComPort1.GetErrorStr),
      'Cannot open comm port', mb_iconstop);
    ClosePort;
  end else
  begin
    MiOpen.Enabled := False;
    MiClose.Enabled := True;
    exit;
  end;
end;

{ close the port and set window options appropriately }
procedure TfrmCTel.ClosePort;
begin
  ComPort1.Close;
  MiOpen.Enabled := True;
  MiClose.Enabled := False;
end;

procedure TfrmCTel.MiOpenClick(Sender: TObject);
begin
  OpenPort;
end;

procedure TfrmCTel.MiCloseClick(Sender: TObject);
begin
  ClosePort;
end;

procedure TfrmCTel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
