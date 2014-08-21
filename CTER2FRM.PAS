unit Cter2frm;

interface

uses Messages, WinTypes, WinProcs, Classes, Graphics, Forms, Controls,
     StdCtrls, ExtCtrls, Menus, SysUtils, Dialogs,
     Qwf_Form, Cpor_kmp, Buttons, Prots;

const
  BC_CTER2 = BC_USER + 1;

type
  TfrmCTer2 = class(TqForm)
    PaSpeedBar: TPanel;
    Panel1: TPanel;
    LaPort1: TLabel;
    LaPort2: TLabel;
    LaCtrl: TLabel;
    La1: TLabel;
    La2: TLabel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    MiConfig1: TMenuItem;
    MiInfo: TMenuItem;
    Data1: TMemo;
    Data2: TMemo;
    BtnConfig: TSpeedButton;
    ComPort1: TComPort;
    N1: TMenuItem;
    MiStrgB: TMenuItem;
    StrgA1: TMenuItem;
    StrgC1: TMenuItem;
    StrgD1: TMenuItem;
    StrgE1: TMenuItem;
    StrgF1: TMenuItem;
    StrgP1: TMenuItem;
    ComPort2: TComPort;
    BtnConfig2: TSpeedButton;
    MiConfig2: TMenuItem;
    MiProt: TMenuItem;
    procedure OpenPort;
    procedure ClosePort;
    procedure MiConfig1Click(Sender: TObject);
    procedure MiInfoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnConfig2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComPort1Receive(Sender: TObject; Count: Word);
    procedure ComPort2Receive(Sender: TObject; Count: Word);
    procedure MiProtClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    SendChar: byte;
    procedure Poll( Sender: TObject);
    procedure BcCter2( var Message: TMessage); message BC_CTER2;
  public
    InKeyPress: boolean;
    CtrlState: boolean;
    LastPort: integer;
  end;

var
  frmCTer2: TfrmCTer2;

implementation
{$R *.DFM}
uses
  Poll_Kmp, Ini__Kmp,
  CtSetDlg;

procedure TfrmCTer2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmCTer2.FormCreate(Sender: TObject);
begin
  PollKmp.Add( Poll, self, 100);
  MaxSizeable := true;
  ComPort1.Params := IniKmp.ReadString('CTER2', 'ComPort1.Params', ComPort1.Params);
  ComPort2.Params := IniKmp.ReadString('CTER2', 'ComPort2.Params', ComPort2.Params);
end;

procedure TfrmCTer2.FormResize(Sender: TObject);
begin
  Data1.Width := Panel2.Width div 2;
end;

procedure TfrmCTer2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IniKmp.WriteString('CTER2', 'ComPort1.Params', ComPort1.Params);
  IniKmp.WriteString('CTER2', 'ComPort2.Params', ComPort2.Params);
end;

procedure TfrmCTer2.FormDestroy(Sender: TObject);
begin
  PollKmp.Sub( Poll, self);
end;

{ fired when we get data from the serial port. Takes the data and
 sends it to the memo component as a keypress windows message.
 I'm not sure this is the most efficient way to do this (?) }
procedure TfrmCTer2.Poll( Sender: TObject);
var
  aChar: byte;
  I, N: Word;
  Buff: string;
begin
  LaCtrl.Caption := Format('Li(%d) re(%d)', [Comport1.cId, Comport2.cId]);
  if (Comport1.cId >= 0) and (Comport1.InCount > 0) then
  begin
    if LastPort <> 1 then
    begin
      if MiProt.Checked then
      begin
        ProtA('', [0]);
      end;
      SendMessage(Data1.Handle, WM_CHAR, word($0D),0);
      SendMessage(Data2.Handle, WM_CHAR, word($0D),0);
      LastPort := 1;
    end;
    N := 0;
    for i := 1 to Comport1.InCount do
    begin
      ComPort1.Read(@aChar, SizeOf(aChar));
      Buff := Buff + chr(aChar);
      Inc(N);
      if (aChar < $20)  then
      begin
        SendMessage(Data1.Handle, WM_CHAR, Word('^'),0);
        SendMessage(Data1.Handle, WM_CHAR, Word(aChar+$40),0);
        if MiProt.Checked then
          Prot.X( [prFile,prRemain], '^%s', [chr(aChar+$40)]);
      end else
      begin
        SendMessage(Data1.Handle, WM_CHAR, Word(aChar),0);
        if MiProt.Checked then
          Prot.X( [prFile,prRemain], '%s', [chr(aChar)]);
      end;
      ComPort2.Write(@aChar, SizeOf(aChar));
      if aChar = $0D then
      begin
        {SendMessage(Data2.Handle, WM_CHAR, word($0D),0);}
      end;
    end;
    //ComPort2.Write(PChar(Buff), length(Buff));
    Debug('%d', [N]);
  end;
  N := 0;
  if (Comport2.cId >= 0) and (Comport2.InCount > 0) then
  begin
    if LastPort <> 2 then
    begin
      LastPort := 2;
    end;
    for i := 1 to Comport2.InCount do
    begin
      ComPort2.Read(@aChar, SizeOf(aChar));
      Buff := Buff + Chr(aChar);
      Inc(N);
      if (aChar < $20)  then
      begin
        SendMessage(Data2.Handle, WM_CHAR, Word('^'),0);
        SendMessage(Data2.Handle, WM_CHAR, Word(aChar+$40),0);
        if MiProt.Checked then
          Prot.X( [prFile,prRemain], '^%s', [chr(aChar+$40)]);
      end else
      begin
        SendMessage(Data2.Handle, WM_CHAR, Word(aChar),0);
        if MiProt.Checked then
          Prot.X( [prFile,prRemain], '%s', [chr(aChar)]);
      end;
      ComPort1.Write(@aChar, SizeOf(aChar));
      if aChar = $0D then
      begin
        {SendMessage(Data1.Handle, WM_CHAR, word($0D),0);}
      end;
    end;
    //ComPort1.Write(PChar(Buff), N);
    Debug('%d', [N]);
  end;
  La2.Caption := IntToStr(Data2.Lines.Count);
  La1.Caption := IntToStr(Data1.Lines.Count);
end;

{ show about dialog with control version number in x.xx format }
procedure TfrmCTer2.MiInfoClick(Sender: TObject);
begin
  MessageFmt('ComPort Komponente' + CRLF + 'Version %02.1f', [ComPort1.Version],
             mtInformation, [mbOK], 0);
end;

{ attempt to open the port and sets window options appropriately }
procedure TfrmCTer2.OpenPort;
var
  temp: array [0..254] of char;
begin
  if (not ComPort1.Open) then
  begin
    Application.MessageBox( StrPCopy( temp, ComPort1.GetErrorStr),
      'Cannot open comm port', mb_iconstop);
    ClosePort;
  end else
  if (not ComPort2.Open) then
  begin
    Application.MessageBox( StrPCopy( temp, ComPort2.GetErrorStr),
      'Cannot open comm port', mb_iconstop);
    ClosePort;
  end else
  begin
  end;
end;

{ close the port and set window options appropriately }
procedure TfrmCTer2.ClosePort;
begin
  ComPort1.Close;
  ComPort2.Close;
end;

procedure TfrmCTer2.MiConfig1Click(Sender: TObject);
begin
  ClosePort;
  TDlgCtSet.Execute( self, ComPort1, Comport1.cId < 0);
  ComPort2.BaudRate := ComPort1.BaudRate;
  ComPort2.DataBits := ComPort1.DataBits;
  ComPort2.FlowControl := ComPort1.FlowControl;
  ComPort2.ParityBits := ComPort1.ParityBits;
  ComPort2.StopBits := ComPort1.StopBits;
  if ComPort1.Port = ComPort2.Port then
    if ComPort1.Port = 1 then
      ComPort2.Port := 2 else
      ComPort2.Port := 1;
  LaPort1.Caption := 'Input COM' + IntToStr(ComPort1.Port);
  LaPort2.Caption := 'Input COM' + IntToStr(ComPort2.Port);
  OpenPort;
end;

procedure TfrmCTer2.BtnConfig2Click(Sender: TObject);
begin
  ClosePort;
  TDlgCtSet.Execute( self, ComPort2, Comport1.cId < 0);
  LaPort2.Caption := 'Input COM' + IntToStr(ComPort2.Port);
  OpenPort;
end;

procedure TfrmCTer2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F10) and (Shift = [ssAlt]) then
    PopupMenu1.Popup(0,0);
end;

procedure TfrmCTer2.ComPort1Receive(Sender: TObject; Count: Word);
var
  aChar: byte;
  i: Word;
begin
  if (Comport1.cId >= 0) and (Comport1.InCount > 0) then
  begin
    if LastPort <> 1 then
    begin
      SendMessage(Data1.Handle, WM_CHAR, word($0D),0);
      LastPort := 1;
    end;
    for i := 1 to Comport1.InCount do
    begin
      ComPort1.Read(@aChar, SizeOf(aChar));
      if (aChar < $20) and (aChar <> $0A) and (aChar <> $0D) then
      begin
        SendMessage(Data1.Handle, WM_CHAR, Word('^'),0);
        SendMessage(Data1.Handle, WM_CHAR, Word(aChar+$40),0);
      end else
        SendMessage(Data1.Handle, WM_CHAR, Word(aChar),0);
      {ComPort2.Write(@aChar, SizeOf(aChar));}
      SendChar := aChar;
      PostMessage(Handle, BC_CTER2, 2, 0);

      if aChar = $0D then
      begin
        SendMessage(Data2.Handle, WM_CHAR, word($0D),0);
      end;
    end;
  end;
end;

procedure TfrmCTer2.ComPort2Receive(Sender: TObject; Count: Word);
var
  aChar: byte;
  i: Word;
begin
  if (Comport2.cId >= 0) and (Comport2.InCount > 0) then
  begin
    if LastPort <> 2 then
    begin
      SendMessage(Data2.Handle, WM_CHAR, word($0D),0);
      LastPort := 2;
    end;
    for i := 1 to Comport2.InCount do
    begin
      ComPort2.Read(@aChar, SizeOf(aChar));
      if (aChar < $20) and (aChar <> $0A) and (aChar <> $0D) then
      begin
        SendMessage(Data2.Handle, WM_CHAR, Word('^'),0);
        SendMessage(Data2.Handle, WM_CHAR, Word(aChar+$40),0);
      end else
        SendMessage(Data2.Handle, WM_CHAR, Word(aChar),0);
      {ComPort1.Write(@aChar, SizeOf(aChar));}
      SendChar := aChar;
      PostMessage(Handle, BC_CTER2, 1, 0);

      if aChar = $0D then
      begin
        SendMessage(Data1.Handle, WM_CHAR, word($0D),0);
      end;
    end;
  end;
end;

procedure TfrmCTer2.BcCter2( var Message: TMessage);
begin
  if Message.WParam = 1 then
    ComPort1.Write(@SendChar, 1) else
    ComPort2.Write(@SendChar, 1);
end;

procedure TfrmCTer2.MiProtClick(Sender: TObject);
begin
  MiProt.Checked := not MiProt.Checked;
end;

end.
