unit WinTools;
(* Win Api Routinen

Autor: Martin Dambach
Letzte Änderung:
10.12.04     Erstellen
15.11.13 md  GetFileInfo
-------------------------------------

*)

interface

uses
  Windows;

function GetProcessID(sProcName: String): Integer;
procedure KillProcessName(sProcName: String);
procedure KillProcess(dwProcID: DWORD);
function GetFileInfo(var aInternalName, aFileVersion: String; FileName: String): Boolean;

implementation

uses
  TLHelp32, Forms, SysUtils,
  Prots, Err__Kmp;

{******************************************************************************}
{**                                                                          **}
{** ProzessID an Hand der Exe-Datei ermittlen                                **}
{**                                                                          **}
{******************************************************************************}
function GetProcessID(sProcName: String): Integer;
var
  hProcSnap: THandle;
  pe32: TProcessEntry32;
begin
  result := -1;
  hProcSnap := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
  if hProcSnap = INVALID_HANDLE_VALUE then
    exit;
  pe32.dwSize := SizeOf(ProcessEntry32);
  if Process32First(hProcSnap, pe32) = true then  { wenn es geklappt hat }
    while Process32Next(hProcSnap, pe32) = true do
    begin    { und los geht's: Prozess suchen}
      if pos(sProcName, pe32.szExeFile) <> 0 then
        result := pe32.th32ProcessID;
    end;
  CloseHandle(hProcSnap);
end;

{******************************************************************************}
{**                                                                          **}
{** Prozess beenden                                                          **}
{**                                                                          **}
{******************************************************************************}
procedure KillProcessName(sProcName: String);
begin
  Prot0('KillProcess(%s)', [sProcName]);
  KillProcess(GetProcessID(sProcName));  //'EXCEL.EXE'
end;

procedure KillProcess(dwProcID: DWORD);
var
  hProcess: Cardinal;
  dw: DWORD;
  N: integer;
begin
  { open the process and store the process-handle }
  hProcess := OpenProcess(SYNCHRONIZE or PROCESS_TERMINATE, False, dwProcID);
  TerminateProcess(hProcess, 0);  { kill it }
  { TerminateProcess returns immediately, so wie have to verify the result via WFSO }
  dw := WaitForSingleObject(hProcess, 5000);
  case dw of
    WAIT_OBJECT_0:    { everythings's all right, we killed the process }
      Prot0('Prozess %d wurde beendet.', [dwProcID]);
    WAIT_TIMEOUT:    { process could not be terminated after 5 seconds }
      Prot0('Prozess %d konnte nicht innerhalb von 5 Sekunden beendet werden.',
        [dwProcID]);
    WAIT_FAILED:    { error in calling WaitForSingleObject }
      begin        // RaiseLastOSError (D6) - RaiseLastWin32Error (D5)
        N := GetLastError;
        Prot0('Fehler in KillProcess:%d(%s)', [N, SysErrorMessage(N)]);
      end;
  else
    Prot0('KillProcess:dw=%d', [dw]);
  end;
  CloseHandle(hProcess);
end;


{******************************************************************************}
{**                                                                          **}
{** Versions Info von Datei liefern                                          **}
{**                                                                          **}
{******************************************************************************}
function GetFileInfo(var aInternalName, aFileVersion: String; FileName: String): Boolean;
var
  VersionInfoSize, VerInfoSize, GetInfoSizeJunk: DWORD;
  VersionInfo, Translation, InfoPointer: Pointer;
  VersionValue: String;
begin
  Result := False;
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), GetInfoSizeJunk);
  if VerInfoSize > 0 then
  begin
    GetMem(VersionInfo, VerInfoSize);
    try
      GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VersionInfo);
      VerQueryValue(
        VersionInfo, '\\VarFileInfo\\Translation', Translation, VerInfoSize
      );
      VersionValue :=
        '\\StringFileInfo\\' + IntToHex(LoWord(LongInt(Translation^)), 4) +
        IntToHex(HiWord(LongInt(Translation^)), 4) + '\\';
      VersionInfoSize := 0;

      VerQueryValue(
        VersionInfo, PChar(VersionValue + 'InternalName'), InfoPointer,
        VersionInfoSize
      );
      aInternalName := String(PChar(InfoPointer));

      VerQueryValue(
        VersionInfo, PChar(VersionValue + 'FileVersion'), InfoPointer,
        VersionInfoSize
      );
      aFileVersion := String(PChar(InfoPointer));

    finally
      FreeMem(VersionInfo);
    end;
    aInternalName := Trim(aInternalName);
    aFileVersion := Trim(aFileVersion);
    Result := (aInternalName <> '') and (aFileVersion <> '');
  end;
end;
end.
