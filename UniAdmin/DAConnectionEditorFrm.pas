
//////////////////////////////////////////////////
//  Data Access Components
//  Copyright � 1998-2011 Devart. All right reserved.
//  ConnectionEditor Editor
//////////////////////////////////////////////////

{$IFNDEF CLR}
{$I Dac.inc}

unit DAConnectionEditorFrm;
{$ENDIF}
interface

//md:
{$UNDEF DBTOOLS}

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Registry, DacVcl, Buttons,
  {$IFNDEF FPC}Mask,{$ENDIF}
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QMask, QExtCtrls, QComCtrls, DacClx, Qt, QButtons,
{$ENDIF}
{$IFDEF DBTOOLS}
  DBToolsClient,
{$ENDIF}
{$IFDEF FPC}
  LResources, LCLType,
{$ENDIF}
  DAEditorFrm, CREditorFrm,
  MemUtils, DBAccess,
//md:+
  AdminCRFunctions;
//md  CRDesignUtils, DADesignUtils;

type
  TFrmDAConnectionEditor = class(TFrmDAEditor)
    PageControl: TPageControl;
    shConnect: TTabSheet;
    Panel: TPanel;
    lbUsername: TLabel;
    lbPassword: TLabel;
    lbServer: TLabel;
    edUsername: TEdit;
  {$IFNDEF FPC}
    edPassword: TMaskEdit;
  {$ELSE}
    edPassword: TEdit;
  {$ENDIF}
    edServer: TComboBox;
    btConnect: TButton;
    btDisconnect: TButton;
    shInfo: TTabSheet;
    shAbout: TTabSheet;
    btClose: TButton;
    meInfo: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    lbVersion: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbWeb: TLabel;
    lbMail: TLabel;
    lbIDE: TLabel;
    cbLoginPrompt: TCheckBox;
    shRed: TShape;
    shYellow: TShape;
    shGreen: TShape;
    imPeng: TImage;
    lbEdition: TLabel;
    procedure btDisconnectClick(Sender: TObject);
    procedure lbWebClick(Sender: TObject);
    procedure lbMailClick(Sender: TObject);
    procedure cbLoginPromptClick(Sender: TObject);
    procedure lbWebMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure shAboutMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbMailMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure edUsernameChange(Sender: TObject);
    procedure edPasswordChange(Sender: TObject);
    procedure edServerChange(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure edServerDropDown(Sender: TObject); virtual;
    procedure PageControlChange(Sender: TObject);
    procedure edServerKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edServerExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  protected
    FConnection: TCustomDAConnection;
    FInDoInit: boolean;
    FConnectDialog: TCustomConnectDialog;
  {$IFDEF MSWINDOWS}
    FRegistry: TRegistry;
  {$ENDIF}
  {$IFDEF DBTOOLS}
    FInExistingChange: boolean;

    function GetExistingConnectionComboBox: TComboBox; virtual;
    procedure ChooseExistingConnection;
    function GetConnectionCondition: string; virtual;
  {$ENDIF}

    procedure GetServerList(List: TStrings); virtual;
  {$IFDEF MSWINDOWS}
    procedure AddServerToList; virtual;
  {$ENDIF}

    procedure ShowState(Yellow: boolean = False); virtual;
    procedure ConnToControls; virtual;
    procedure ControlsToConn; virtual;
    procedure FillInfo; virtual;
    procedure PerformConnect; virtual;
    procedure PerformDisconnect; virtual;
    function IsConnected: boolean; virtual;
    procedure AssignUsername(const Value: string); virtual;
    procedure AssignPassword(const Value: string); virtual;
    procedure AssignServer(const Value: string); virtual;
    procedure AssignLoginPrompt(Value: boolean); virtual;
    function GetConnectDialogClass: TConnectDialogClass; virtual;

    procedure DoInit; override;
    procedure DoActivate; override;
    procedure UpdateVersionPosition; virtual;

    function GetComponent: TComponent; override;
    procedure SetComponent(Value: TComponent); override;

  public

  end;

implementation

uses
  {$IFDEF MSWINDOWS}ShellAPI, {mdHelpUtils,} {$ENDIF}
  {$IFDEF VER6P}Variants, {$ENDIF}
  MemData;

//md:
{$R *.dfm}

{$I DacVer.inc}

{$IFDEF KYLIX}
type
  _TMaskEdit = class (TMaskEdit)
  end;
{$ENDIF}

procedure TFrmDAConnectionEditor.FormCreate(Sender: TObject);
begin
  inherited;

{$IFDEF MSWINDOWS}
  FRegistry := TRegistry.Create(KEY_READ OR KEY_WRITE);
  if not FRegistry.OpenKey('\SOFTWARE\Devart\' + GetProjectName + '\Connect', True) then
    FreeAndNil(FRegistry);
{$ENDIF}
end;

procedure TFrmDAConnectionEditor.FormDestroy(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  FreeAndNil(FRegistry);
{$ENDIF}

  FConnectDialog.Free;

  inherited;
end;

procedure TFrmDAConnectionEditor.DoInit;
var
  IDE: string;
begin
  FInDoInit := True;
  try
    inherited;

  {$IFDEF D5}
    IDE := 'Delphi 5';
  {$ENDIF}
  {$IFDEF D6}
    IDE := 'Delphi 6';
  {$ENDIF}
  {$IFDEF D7}
    IDE := 'Delphi 7';
  {$ENDIF}
  {$IFDEF D8}
    IDE := 'Delphi 8';
  {$ENDIF}
  {$IFDEF D9}
    IDE := 'Delphi 2005';
  {$ENDIF}
  {$IFDEF D10}
    IDE := 'Delphi 2006';
  {$ENDIF}
  {$IFDEF D11}
    IDE := 'Delphi 2007';
  {$ENDIF}
  {$IFDEF D12}
    IDE := 'Delphi 2009';
  {$ENDIF}
  {$IFDEF D14}
    IDE := 'Delphi 2010';
  {$ENDIF}
  {$IFDEF D15}
    IDE := 'Delphi XE';
  {$ENDIF}
  {$IFDEF D16}
    IDE := 'Delphi XE2';
  {$ENDIF}
  {$IFDEF CB5}
    IDE := 'C++Builder 5';
  {$ENDIF}
  {$IFDEF CB6}
    IDE := 'C++Builder 6';
  {$ENDIF}
  {$IFDEF KYLIX}
    IDE := 'Kylix';
  {$ENDIF}
  {$IFDEF FPC}
    IDE := 'Lazarus';
  {$ENDIF}

    lbVersion.Caption := DACVersion + ' ';
    lbIDE.Caption := 'for ' + IDE;
    UpdateVersionPosition;


  {$IFDEF KYLIX}
    imPeng.Visible := True;
    imPeng.BringToFront;
    _TMaskEdit(edPassword).EchoMode := emPassword;
  {$ENDIF}

  {$IFDEF DBTOOLS}
    if DADesignUtilsClass.DBToolsAvailable then begin
      GetDBToolsService(DADesignUtilsClass).GetConnections(GetExistingConnectionComboBox.Items, GetConnectionCondition);
      ChooseExistingConnection;
    end;  
  {$ENDIF}

    FConnectDialog := GetConnectDialogClass.Create(nil);
    TDBAccessUtils.SetConnection(FConnectDialog, FConnection);
    TDBAccessUtils.SetUseServerHistory(FConnectDialog, False);

    ConnToControls;

    ShowState;
  finally
    FInDoInit := False;
  end;
end;

procedure TFrmDAConnectionEditor.DoActivate;
begin
  inherited;

{$IFDEF FPC}
  if (PageControl.ActivePage = nil) and (PageControl.PageCount > 0) then
    PageControl.ActivePage := PageControl.Pages[0];
{$ENDIF}
end;

procedure TFrmDAConnectionEditor.UpdateVersionPosition;
begin
  lbIDE.Left := lbVersion.Left + lbVersion.Width;
end;

function TFrmDAConnectionEditor.GetComponent: TComponent;
begin
  Result := FConnection;
end;

procedure TFrmDAConnectionEditor.SetComponent(Value: TComponent);
begin
  FConnection := Value as TCustomDAConnection;
end;

{$IFDEF DBTOOLS}
function TFrmDAConnectionEditor.GetExistingConnectionComboBox: TComboBox;
begin
  Result := nil;
  Assert(False, 'Must be overriden');
end;

procedure TFrmDAConnectionEditor.ChooseExistingConnection;
begin
  if not FInExistingChange and DADesignUtilsClass.DBToolsAvailable then
    with GetExistingConnectionComboBox do
      ItemIndex := Items.IndexOf(GetDBToolsService(DADesignUtilsClass).FindConnectionName(FConnection));
end;

function TFrmDAConnectionEditor.GetConnectionCondition: string;
begin
  Result := '';
end;
{$ENDIF}

procedure TFrmDAConnectionEditor.ConnToControls;
begin
  edUsername.Text := FConnection.Username;
  edPassword.Text := FConnection.Password;
  edServer.Text := FConnection.Server;
  cbLoginPrompt.Checked := FConnection.LoginPrompt;
end;

procedure TFrmDAConnectionEditor.ControlsToConn;
begin
  // all parameters are set in controls OnChange event handlers
end;

procedure TFrmDAConnectionEditor.ShowState(Yellow: boolean);
begin
  btDisconnect.Enabled := IsConnected;

  shRed.Brush.Color := clBtnFace;
  shYellow.Brush.Color := clBtnFace;
  shGreen.Brush.Color := clBtnFace;

  if Yellow then begin
    shYellow.Brush.Color := clYellow;
    shYellow.Update;
  end
  else
    if IsConnected then begin
      shGreen.Brush.Color := clGreen;
      shYellow.Update;
    end
    else
      shRed.Brush.Color := clRed;
end;

procedure TFrmDAConnectionEditor.lbWebClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
//md  OpenUrl('http://' + lbWeb.Caption);
  lbWeb.Font.Color := $FF0000;
{$ENDIF}
end;

procedure TFrmDAConnectionEditor.lbMailClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
//md  MailTo(lbMail.Caption);
  lbMail.Font.Color := $FF0000;
{$ENDIF}
end;

procedure TFrmDAConnectionEditor.cbLoginPromptClick(Sender: TObject);
begin
  AssignLoginPrompt(cbLoginPrompt.Checked);
end;

procedure TFrmDAConnectionEditor.lbWebMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbWeb.Font.Color := $4080FF;
end;

procedure TFrmDAConnectionEditor.lbMailMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbMail.Font.Color := $4080FF;
end;

procedure TFrmDAConnectionEditor.shAboutMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lbWeb.Font.Color := $FF0000;
  lbMail.Font.Color := $FF0000;
end;

procedure TFrmDAConnectionEditor.edUsernameChange(Sender: TObject);
begin
  if FInDoInit then
    Exit;

  try
    AssignUsername(edUsername.Text);
  finally
    ShowState;
  end;
end;

procedure TFrmDAConnectionEditor.edPasswordChange(Sender: TObject);
begin
  if FInDoInit then
    Exit;

  try
    AssignPassword(edPassword.Text);
  finally
    ShowState;
  end;
end;

procedure TFrmDAConnectionEditor.edServerChange(Sender: TObject);
begin
  if FInDoInit then
    Exit;

  try
    AssignServer(edServer.Text);
  finally
    ShowState;
  end;
end;

procedure TFrmDAConnectionEditor.btConnectClick(Sender: TObject);
begin
  ShowState(True);
{$IFDEF DBTOOLS}
  ChooseExistingConnection;
{$ENDIF}
  StartWait;
  try
    ControlsToConn;
    PerformConnect;
  {$IFDEF MSWINDOWS}
    if IsConnected then
      AddServerToList;
  {$ENDIF}
  finally
    StopWait;
    ShowState;
  end;

  ModalResult := mrOk;
end;

procedure TFrmDAConnectionEditor.btDisconnectClick(Sender: TObject);
begin
{$IFDEF DBTOOLS}
  ChooseExistingConnection;
{$ENDIF}
  try
    PerformDisconnect;
  finally
    ShowState;
  end;
end;

procedure TFrmDAConnectionEditor.edServerDropDown(Sender: TObject);
var
  List: TStringList;
begin
  StartWait;
  List := TStringList.Create;
  try
    GetServerList(List);
    AssignStrings(List, edServer.Items);
  finally
    StopWait;
    List.Free;
  end;
end;

procedure TFrmDAConnectionEditor.GetServerList(List: TStrings);
begin
  FConnectDialog.GetServerList(List);
end;

{$IFDEF MSWINDOWS}
procedure TFrmDAConnectionEditor.AddServerToList;
begin
  try
    TDBAccessUtils.SaveServerListToRegistry(FConnectDialog);
  finally
    SetCursor(crDefault);
  end;
end;
{$ENDIF}

procedure TFrmDAConnectionEditor.FillInfo;
var
  OldLoginPrompt: boolean;

begin
  OldLoginPrompt := FConnection.LoginPrompt;
  try
    FConnection.LoginPrompt := False;

    if not IsConnected then
      try
        ShowState(True);
        PerformConnect;
      except
        on E: Exception do
        begin
          // PageControl.ActivePage := shConnect;
          // Application.ShowException(E); - silent exception. Please see CR MyDAC 3443
        end;
      end;
    meInfo.Lines.Clear;
  finally
    FConnection.LoginPrompt := OldLoginPrompt;
    ShowState(False);
  end;
end;

procedure TFrmDAConnectionEditor.PerformConnect;
begin
  FConnection.PerformConnect;
end;

procedure TFrmDAConnectionEditor.PerformDisconnect;
begin
  FConnection.Disconnect;
end;

function TFrmDAConnectionEditor.IsConnected: boolean;
begin
  Result := FConnection.Connected;
end;

procedure TFrmDAConnectionEditor.AssignUsername(const Value: string);
begin
  FConnection.Username := Value;
end;

procedure TFrmDAConnectionEditor.AssignPassword(const Value: string);
begin
  FConnection.Password := Value;
end;

procedure TFrmDAConnectionEditor.AssignServer(const Value: string);
begin
  FConnection.Server := Value;
end;

procedure TFrmDAConnectionEditor.AssignLoginPrompt(Value: boolean);
begin
  FConnection.LoginPrompt := Value;
end;

function TFrmDAConnectionEditor.GetConnectDialogClass: TConnectDialogClass;
begin
  Assert(FConnection <> nil);
  Result := TDBAccessUtils.ConnectDialogClass(FConnection);
end;

procedure TFrmDAConnectionEditor.PageControlChange(Sender: TObject);
begin
  if PageControl.ActivePage = shInfo then
    FillInfo;
end;

procedure TFrmDAConnectionEditor.edServerKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key ={$IFNDEF KYLIX}VK_RETURN{$ELSE}KEY_RETURN{$ENDIF} then
    edServerChange(Sender);
end;

procedure TFrmDAConnectionEditor.edServerExit(Sender: TObject);
begin
{$IFDEF DBTOOLS}
  ChooseExistingConnection;
{$ENDIF}
end;

{$IFDEF FPC}
initialization
  {$i DAConnectionEditor.lrs}
{$ENDIF}

end.
