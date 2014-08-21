unit Ctsetdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  CPor_Kmp;

type
  TDlgCtSet = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cboPort: TComboBox;
    cboBaud: TComboBox;
    cboParity: TComboBox;
    cboStop: TComboBox;
    cboData: TComboBox;
    Label5: TLabel;
    btnOK: TButton;
    Label6: TLabel;
    cboFlow: TComboBox;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure Execute( Sender: TComponent; ComPort: TComPort;
      PortEnabled : boolean);
  end;

var
  DlgCtSet: TDlgCtSet;

implementation

{$R *.DFM}

class procedure TDlgCtSet.Execute( Sender: TComponent; ComPort: TComPort;
  PortEnabled : boolean);
begin
  if DlgCtSet = nil then
    DlgCtSet := TDlgCtSet.Create( Sender);
  try
    { shouldn't be able to change port # if port is open }
    DlgCtSet.cboPort.Enabled := PortEnabled;
    { read settings from comm control into settings dialog }
    DlgCtSet.cboPort.ItemIndex := ComPort.Port;
    DlgCtSet.cboBaud.ItemIndex := Ord(ComPort.BaudRate);
    DlgCtSet.cboData.ItemIndex := Ord(ComPort.DataBits);
    DlgCtSet.cboParity.ItemIndex := Ord(ComPort.ParityBits);
    DlgCtSet.cboStop.ItemIndex := Ord(ComPort.StopBits);
    DlgCtSet.cboFlow.ItemIndex := Ord(ComPort.FlowControl);
    { show settings dialog }
    DlgCtSet.ShowModal;
    { copy settings from dialog into comm control }
    ComPort.Port := DlgCtSet.cboPort.ItemIndex;
    case DlgCtSet.cboBaud.ItemIndex of
      0: ComPort.BaudRate := br110;
      1: ComPort.BaudRate := br300;
      2: ComPort.BaudRate := br600;
      3: ComPort.BaudRate := br1200;
      4: ComPort.BaudRate := br2400;
      5: ComPort.BaudRate := br4800;
      6: ComPort.BaudRate := br9600;
      7: ComPort.BaudRate := br14400;
      8: ComPort.BaudRate := br19200;
      9: ComPort.BaudRate := br38400;
      10: ComPort.BaudRate := br56000;
      11: ComPort.BaudRate := br128000;
      12: ComPort.BaudRate := br256000;
    end;
    case DlgCtSet.cboParity.ItemIndex of
      0: ComPort.ParityBits := pbNone;
      1: ComPort.ParityBits := pbOdd;
      2: ComPort.ParityBits := pbEven;
      3: ComPort.ParityBits := pbMark;
      4: ComPort.ParityBits := pbSpace;
    end;
    case DlgCtSet.cboData.ItemIndex of
      0: ComPort.DataBits := dbFour;
      1: ComPort.DataBits := dbFive;
      2: ComPort.DataBits := dbSix;
      3: ComPort.DataBits := dbSeven;
      4: ComPort.DataBits := dbEight;
    end;
    case DlgCtSet.cboStop.ItemIndex of
      0: ComPort.StopBits := sbOne;
      1: ComPort.StopBits := sbOnePointFive;
      2: ComPort.StopBits := sbTwo;
    end;
    case DlgCtSet.cboFlow.ItemIndex of
      0: ComPort.FlowControl := fcNone;
      1: ComPort.FlowControl := fcRTSCTS;
      2: ComPort.FlowControl := fcXONXOFF;
    end;
  finally
    DlgCtSet.Free;
    DlgCtSet := nil;
  end;
end;

procedure TDlgCtSet.btnOKClick(Sender: TObject);
begin
 Close;
end;

procedure TDlgCtSet.FormCreate(Sender: TObject);
begin

  cboPort.Items.Add('(none)');
  cboPort.Items.Add('1');
  cboPort.Items.Add('2');
  cboPort.Items.Add('3');
  cboPort.Items.Add('4');
  cboPort.Items.Add('5');
  cboPort.Items.Add('6');
  cboPort.Items.Add('7');
  cboPort.Items.Add('8');
  cboPort.Items.Add('9');

  cboBaud.Items.Add('110');
  cboBaud.Items.Add('300');
  cboBaud.Items.Add('600');
  cboBaud.Items.Add('1200');
  cboBaud.Items.Add('2400');
  cboBaud.Items.Add('4800');
  cboBaud.Items.Add('9600');
  cboBaud.Items.Add('14400');
  cboBaud.Items.Add('19200');
  cboBaud.Items.Add('38400');
  cboBaud.Items.Add('56000');
  cboBaud.Items.Add('128000');
  cboBaud.Items.Add('256000');

  cboData.Items.Add('4');
  cboData.Items.Add('5');
  cboData.Items.Add('6');
  cboData.Items.Add('7');
  cboData.Items.Add('8');

  cboParity.Items.Add('None');
  cboParity.Items.Add('Odd');
  cboParity.Items.Add('Even');
  cboParity.Items.Add('Mark');
  cboParity.Items.Add('Space');

  cboStop.Items.Add('1');
  cboStop.Items.Add('1.5');
  cboStop.Items.Add('2');

  cboFlow.Items.Add('None');
  cboFlow.Items.Add('RTS/CTS');
  cboFlow.Items.Add('XON/XOFF');

end;

end.
