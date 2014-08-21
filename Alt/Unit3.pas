unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}
uses
  Consts;

{ keystate }

procedure TForm1.Button1Click(Sender: TObject);
var
  KeyState: TKeyboardState;
  I: integer;
begin
  ListBox1.Items.Clear;
  GetKeyboardState(KeyState);
  for I := 0 to 255 do
  begin
    if (KeyState[I] <> 0) and (KeyState[I] <> 1) then
      ListBox1.Items.Add(Format('%3d($%4X) -> %3d($%4X)', [I, I, KeyState[I], KeyState[I]]));
  end;
end;

{ Trans }

procedure TForm1.Button2Click(Sender: TObject);
begin
  InputBox('Test', 'Enter something', 'Test');
end;

procedure HookResourceString(rs: PResStringRec; newStr: PChar);
var
  oldprotect: DWORD;
begin
  VirtualProtect(rs, SizeOf(rs^), PAGE_EXECUTE_READWRITE, @oldProtect);
  rs^.Identifier := Integer(newStr);
  VirtualProtect(rs, SizeOf(rs^), oldProtect, @oldProtect);
end;

const
  NewOK: PChar = 'New Ok';
  NewCancel: PChar = 'New Cancel';

initialization
  HookResourceString(@SMsgDlgOK, NewOK);
  HookResourceString(@SMsgDlgCancel, NewCancel);
end.
