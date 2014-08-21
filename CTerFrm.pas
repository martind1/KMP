unit Cterfrm;

interface

uses Messages, WinTypes, WinProcs, Classes, Graphics, Forms, Controls,
     StdCtrls, ExtCtrls, Menus, SysUtils, Dialogs,
     Qwf_Form, Cpor_kmp, Buttons;
type
  TInOut = (ioIn, ioOut);
  TOnData = procedure (Sender: TObject; InBuff: string; var OutBuff: string) of object;

type
  TFrmCTer = class(TqForm)
    PaSpeedBar: TPanel;
    Panel1: TPanel;
    LaOutPut: TLabel;
    Label1: TLabel;
    LaCtrl: TLabel;
    LaOut: TLabel;
    LaIn: TLabel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    MiConfig: TMenuItem;
    MiOpen: TMenuItem;
    MiClose: TMenuItem;
    MiInfo: TMenuItem;
    DataOut: TMemo;
    DataIn: TMemo;
    BtnConfig: TSpeedButton;
    BtnOpen: TSpeedButton;
    BtnClose: TSpeedButton;
    N1: TMenuItem;
    MiStrgB: TMenuItem;
    StrgA1: TMenuItem;
    StrgC1: TMenuItem;
    StrgD1: TMenuItem;
    StrgE1: TMenuItem;
    StrgF1: TMenuItem;
    StrgP1: TMenuItem;
    ComPort1: TComPort;
    procedure MiConfigClick(Sender: TObject);
    procedure MiCloseClick(Sender: TObject);
    procedure MiOpenClick(Sender: TObject);
    procedure MiInfoClick(Sender: TObject);
    procedure DataOutKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DataOutKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MiStrgClick(Sender: TObject);
  private
    InKeyPress: boolean;
    CtrlState: boolean;
    InOut: TInOut;
    InBuff, OutBuff: string;
    FOnData: TOnData;
    procedure Poll(Sender: TObject);
    procedure SendByte(aByte: byte);
  public
    procedure OpenPort;
    procedure ClosePort;
    property OnData: TOnData read FOnData write FOnData;
  end;

var
  FrmCTer: TFrmCTer;

implementation
{$R *.DFM}
uses
  Prots, Poll_Kmp,
  CtSetDlg;

procedure TFrmCTer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmCTer.FormCreate(Sender: TObject);
begin
  FrmCTer := self;
  PollKmp.Add(Poll, self, 100);
end;

procedure TFrmCTer.FormDestroy(Sender: TObject);
begin
  PollKmp.Sub(Poll, self);
  FrmCTer := nil;
end;

{ fired when we get data from the serial port. Takes the data and
 sends it to the memo component as a keypress windows message.
 I'm not sure this is the most efficient way to do this (?) }
procedure TFrmCTer.Poll(Sender: TObject);
var
  aChar: byte;
  I: integer;
begin
  if Comport1.cId < 0 then
    Exit;

  if (Comport1.InCount = 0) and (length(InBuff) > 0) then
  begin
    if assigned(FOnData) then
    begin
      OutBuff := '';
      FOnData(self, InBuff, OutBuff);
      for I := 1 to length(OutBuff) do
      begin
        SendByte(ord(OutBuff[I]));
      end;
    end;
    InBuff := '';
  end else
  if Comport1.InCount > 0 then
  begin
    if InOut = ioOut then
      InOut := ioIn;
    while Comport1.InCount > 0 do
    begin
      ComPort1.Read(@aChar, SizeOf(aChar));
      InBuff := InBuff + char(aChar);
      if (aChar < $20) and (aChar <> $0A) and (aChar <> $0D) then
      begin
        SendMessage(DataIn.Handle, WM_CHAR, Word('^'),0);
        SendMessage(DataIn.Handle, WM_CHAR, Word(aChar+$40),0);
      end else
        SendMessage(DataIn.Handle, WM_CHAR, Word(aChar),0);

      InKeyPress := true;
      if aChar = $0D then
      begin
        SendMessage(DataOut.Handle, WM_CHAR, word($0D),0);
      end;
      InKeyPress := false;
    end;
    LaOut.Caption := IntToStr(DataOut.Lines.Count);
    LaIn.Caption := IntToStr(DataIn.Lines.Count);
  end;
end;

procedure TFrmCTer.SendByte(aByte: byte);
begin
  if aByte < 32 then
  try
    CtrlState := true;
    SendMessage(DataOut.Handle, WM_CHAR, aByte+64, 0);
  finally
    CtrlState := false;
  end else
  begin
    SendMessage(DataOut.Handle, WM_CHAR, aByte, 0);
  end;
end;

procedure TFrmCTer.DataOutKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {if (ssCtrl in Shift) and (Key >= ord('A')) and (Key <= ord('Z')) then
  begin
    CtrlState := true;
    SendMessage(DataOut.Handle, WM_CHAR, Key, 0);
    CtrlState := false;
    Key := 0;
  end;}
end;

procedure TFrmCTer.MiStrgClick(Sender: TObject);
begin
  CtrlState := true;
  SendMessage(DataOut.Handle, WM_CHAR, (Sender as TMenuItem).Tag+64, 0);
  CtrlState := false;
end;

procedure TFrmCTer.DataOutKeyPress(Sender: TObject; var Key: Char);
const
  CtrlChar = '^';
var
  CtrlKey: byte;
begin
  if not InKeyPress then
  begin
    InKeyPress := true;

    if InOut = ioIn then
    begin
      InOut := ioOut;
      SendMessage(DataIn.Handle, WM_CHAR, word($0D),0);
      SendMessage(DataOut.Handle, WM_CHAR, word($0D),0);
    end;
    try
      if CtrlState and (CharInSet(Key, ['A'..'Z']) or CharInSet(Key, ['a'..'z'])) then
      begin
        Key := UpCase(Key);
        CtrlKey := ord(Key) - $40;
        SendMessage(DataOut.Handle, WM_CHAR, Word(CtrlChar),0);
        ComPort1.Write(@CtrlKey, 1);
      end else
        ComPort1.Write(@Key, SizeOf(Key));
    finally
      InKeyPress := false;
    end;
    LaOut.Caption := IntToStr(DataOut.Lines.Count);
    LaIn.Caption := IntToStr(DataIn.Lines.Count);
  end;
end;

{ show about dialog with control version number in x.xx format }
procedure TFrmCTer.MiInfoClick(Sender: TObject);
begin
  MessageFmt('ComPort Komponente' + CRLF + 'Version %02.1f', [ComPort1.Version],
             mtInformation, [mbOK], 0);
end;

{ attempt to open the port and sets window options appropriately }
procedure TFrmCTer.OpenPort;
var
  temp: array [0..254] of char;
begin
  if (not ComPort1.Open) then
  begin
    Application.MessageBox(StrPCopy(temp, ComPort1.GetErrorStr),
      'Cannot open comm port', mb_iconstop);
    ClosePort;
  end else
  begin
    DataOut.Color := clWindow;
    DataOut.Enabled := True;
    DataOut.SetFocus;
    MiOpen.Enabled := False;
    MiClose.Enabled := True;
    exit;
  end;
end;

{ close the port and set window options appropriately }
procedure TFrmCTer.ClosePort;
begin
  ComPort1.Close;
  DataOut.Clear;
  DataOut.Color := clBtnFace;
  DataOut.Enabled := False;
  MiOpen.Enabled := True;
  MiClose.Enabled := False;
end;

procedure TFrmCTer.MiConfigClick(Sender: TObject);
begin
  TDlgCtSet.Execute(self, Comport1, MiOpen.Enabled);
end;

procedure TFrmCTer.MiOpenClick(Sender: TObject);
begin
  OpenPort;
end;

procedure TFrmCTer.MiCloseClick(Sender: TObject);
begin
  ClosePort;
end;

end.
