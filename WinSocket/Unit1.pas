unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ScktComp, ComCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    Server: TTabSheet;
    Client: TTabSheet;
    ServerSocket1: TServerSocket;
    ClientSocket1: TClientSocket;
    lbProt: TListBox;
    Label1: TLabel;
    EdPort: TEdit;
    BtnSvrActive: TSpeedButton;
    BtnCliActive: TSpeedButton;
    Label2: TLabel;
    EdClientRead: TEdit;
    Label3: TLabel;
    EdSendText: TEdit;
    BtnAntwort: TSpeedButton;
    EdClientWrite: TEdit;
    Label5: TLabel;
    EdAddress: TEdit;
    EdHost: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EdRead: TEdit;
    EdWriSendText: TEdit;
    EdWrite: TEdit;
    BtnWrite: TSpeedButton;
    BtnCliCheckActive: TSpeedButton;
    procedure EdPortChange(Sender: TObject);
    procedure BtnSvrActiveClick(Sender: TObject);
    procedure BtnCliActiveClick(Sender: TObject);
    procedure ServerSocket1Accept(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1Listen(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure EdAddressChange(Sender: TObject);
    procedure EdHostChange(Sender: TObject);
    procedure ClientSocket1Connecting(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket1Lookup(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Write(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure BtnWriteClick(Sender: TObject);
    procedure BtnCliCheckActiveClick(Sender: TObject);
    procedure BtnAntwortClick(Sender: TObject);
  private
    procedure AppException(Sender: TObject; E: Exception);
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  EdPortChange(Sender);
  EdAddressChange(Sender);
  Application.OnException := AppException;
end;

procedure TForm1.AppException(Sender: TObject; E: Exception);
begin                                          // ESocketError
  //MessageDlg(Format('Application Exception von (%s):(%s)', [Sender.Classname, E.Message]), mtError, [mbOK], 0);
  lbProt.Items.Add(Format('%s:%s', [E.Classname, E.Message]));
end;

procedure TForm1.EdPortChange(Sender: TObject);
begin
  ServerSocket1.Port := StrToInt(EdPort.Text);
  ClientSocket1.Port := StrToInt(EdPort.Text);
end;

procedure TForm1.EdAddressChange(Sender: TObject);
begin
  ClientSocket1.Address := EdAddress.Text;
end;

procedure TForm1.EdHostChange(Sender: TObject);
begin
  ClientSocket1.Host := EdHost.Text;
end;

procedure TForm1.BtnSvrActiveClick(Sender: TObject);
begin
  try
    ServerSocket1.Active := BtnSvrActive.Down;
  finally
    BtnSvrActive.Down := ServerSocket1.Active;
    lbProt.Items.Add(Format('Svr:Active:%d', [ord(ServerSocket1.Active)]));
  end;
end;

procedure TForm1.BtnCliActiveClick(Sender: TObject);
begin
  try
    ClientSocket1.Active := BtnCliActive.Down;
  finally
    BtnCliCheckActive.Click;
  end;
end;

procedure TForm1.BtnCliCheckActiveClick(Sender: TObject);
begin
  if ClientSocket1.Active then
  begin
    EdAddress.Text := ClientSocket1.Address;
    EdHost.Text := ClientSocket1.Host;
  end;
  if BtnCliActive.Down <> ClientSocket1.Active then
  begin
    BtnCliActive.Down := ClientSocket1.Active;
    lbProt.Items.Add(Format('Cli:Active:%d', [ord(ClientSocket1.Active)]));
  end;
end;

procedure TForm1.ServerSocket1Accept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  lbProt.Items.Add(Format('Svr:Accept(%s)', [Socket.RemoteAddress]));
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  lbProt.Items.Add(Format('Svr:ClientConnect(%s)', [Socket.RemoteAddress]));
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  lbProt.Items.Add(Format('Svr:ClientDisConnect(%s)', [Socket.RemoteAddress]));
end;

procedure TForm1.ServerSocket1Listen(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  lbProt.Items.Add(Format('Svr:Listen(%s)', [Socket.RemoteAddress]));
end;

procedure TForm1.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  lbProt.Items.Add(Format('Svr:ClientError%d(%s)', [ErrorCode, Socket.RemoteAddress]));
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  EdClientRead.Text := Socket.ReceiveText;
  lbProt.Items.Add(Format('Svr:ClientRead(%s)', [EdClientRead.Text]));
end;

procedure TForm1.ServerSocket1ClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  EdSendText.Text := IntToStr(
    Socket.SendText(EdClientWrite.Text));
  lbProt.Items.Add(Format('Svr:ClientWrite(%s):%s', [EdClientWrite.Text, EdSendText.Text]));
end;

procedure TForm1.ClientSocket1Connecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  lbProt.Items.Add(Format('Cli:Connecting(%s)', [Socket.RemoteAddress]));
  BtnCliCheckActive.Click;
end;

procedure TForm1.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  lbProt.Items.Add(Format('Cli:Connect(%s)', [Socket.RemoteAddress]));
  BtnCliCheckActive.Click;
end;

procedure TForm1.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  lbProt.Items.Add(Format('Cli:Disconnect(%s)', [Socket.RemoteAddress]));
  BtnCliCheckActive.Click;
end;

procedure TForm1.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  lbProt.Items.Add(Format('Cli:Error%d(%s)', [ErrorCode, Socket.RemoteAddress]));
  BtnCliCheckActive.Click;
end;

procedure TForm1.ClientSocket1Lookup(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  lbProt.Items.Add(Format('Cli:Lookup(%s)', [Socket.RemoteAddress]));
  BtnCliCheckActive.Click;
end;

procedure TForm1.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  EdRead.Text := Socket.ReceiveText;
  lbProt.Items.Add(Format('Cli:Read(%s)', [EdRead.Text]));
end;

procedure TForm1.ClientSocket1Write(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  EdWriSendText.Text := IntToStr(
    Socket.SendText(EdWrite.Text));
  lbProt.Items.Add(Format('Cli:Write(%s):%s', [EdWrite.Text, EdWriSendText.Text]));
end;

procedure TForm1.BtnWriteClick(Sender: TObject);
begin
  BtnWrite.Down := false;
  ClientSocket1Write(Sender, ClientSocket1.Socket);
end;

procedure TForm1.BtnAntwortClick(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to ServerSocket1.Socket.ActiveConnections - 1 do
  begin
    ServerSocket1ClientWrite(ServerSocket1, ServerSocket1.Socket.Connections[I]);
  end;
end;

end.
