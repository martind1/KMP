unit BatMain;
(* Program BatchCtl
   Kontrolle von Programmen mit AutoBatch-Parameter.
   Das Programm wird automatisch gestartet wenn es beendet ist
   Paramater:   EXE-Name ExeParam1 2 3 ..
   Autor: M.Dambach
   02.12.98    Erstellt

*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,
  StdCtrls, DB,  Uni, DBAccess, MemDS;

type
  TFrmStart = class(TForm)
    EdAufruf: TEdit;
    BtnStart: TButton;
    Label1: TLabel;
    EdHandle: TEdit;
    Label2: TLabel;
    procedure BtnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmStart: TFrmStart;

implementation
{$R *.DFM}

procedure TFrmStart.FormCreate(Sender: TObject);
var
  I: integer;
begin
  if ParamCount > 0 then
  begin
    EdAufruf.Text := '';
    for I := 1 to ParamCount do
      EdAufruf.Text := EdAufruf.Text + ParamStr(I) + ' ';
    PostMessage( Handle, WM_COMMAND, 0, BtnStart.Handle);
  end;
end;

procedure TFrmStart.BtnStartClick(Sender: TObject);
var
  zAppName: array[0..512] of char;
  zCurDir: array[0..255] of char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  P, AResult: integer;
begin
  StrPCopy(zAppName, EdAufruf.Text);
  P := Pos(' ', EdAufruf.Text);
  if P = 0 then P := length(EdAufruf.Text) + 1;
  WorkDir := ExtractFilePath(copy(EdAufruf.Text, 1, P - 1));
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_NORMAL;
  if CreateProcess(
     nil,                           { App }
     zAppName,                      { pointer to command line string }
     nil,                           { pointer to process security attributes }

     nil,                           { pointer to thread security attributes }
     false,                         { handle inheritance flag }
     CREATE_NEW_CONSOLE or          { creation flags }
     NORMAL_PRIORITY_CLASS,
     nil,                           { pointer to new environment block }
     nil,                           { pointer to current directory name }
     StartupInfo,                   { pointer to STARTUPINFO }
     ProcessInfo) then              { pointer to PROCESS_INF }
  begin
    EdHandle.Text := IntToStr(ProcessInfo.hProcess);
    Application.ProcessMessages;
    WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    if GetExitCodeProcess(ProcessInfo.hProcess, AResult) then
      PostMessage(Handle, WM_COMMAND, 0, BtnStart.Handle);
  end else
    EdHandle.Text := 'failed';

end;

end.
