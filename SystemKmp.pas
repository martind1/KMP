unit SystemKmp;
(* enthält Routinen aus System.pas die dort nicht öffentlich sind.
   03.11.07 MD  erstellt
*)

interface

function ToLongPath(AFileName: PChar): PChar;

implementation

uses
  Classes, Windows;

const
  kernel = 'kernel32.dll';

(* Die WinAPI Funktion GetLongPathName ist ab Windows 98 verfügbar.
   Mit dieser Funktion können kurze Pfade in Lange umgewandelt werden.
   Sie ist nicht bei NT und nicht bei Win95 verfügbar.
   function GetLongPathNameA; external kernel32 Name 'GetLongPathNameA';

   SetLength(Result, MAX_PATH);
   SetLength(Result, GetLongPathNameA(PChar(ShortName), PChar(Result), MAX_PATH));
*)


function FindBS(Current: PChar): PChar;
begin
  Result := Current;
  while (Result^ <> #0) and (Result^ <> '\') do
    Result := CharNext(Result);
end;

function ToLongPath(AFileName: PChar): PChar;
var
  CurrBS, NextBS: PChar;
  Handle, L: Integer;
  FindData: TWin32FindData;
  Buffer: array[0..MAX_PATH] of Char;
  GetLongPathName: function (ShortPathName: PChar; LongPathName: PChar;
    cchBuffer: Integer): Integer stdcall;
const
  {$IFNDEF UNICODE}
  longPathName = 'GetLongPathNameA';
  {$ELSE}
  longPathName = 'GetLongPathNameW';
  {$ENDIF}
begin
  Result := AFileName;
  Handle := GetModuleHandle(kernel);
  if Handle <> 0 then
  begin
    @GetLongPathName := GetProcAddress(Handle, longPathName);
    if Assigned(GetLongPathName) and
      (GetLongPathName(AFileName, Buffer, Length(Buffer)) <> 0) then
    begin
      lstrcpy(AFileName, Buffer);
      Exit;
    end;
  end;

  if AFileName[0] = '\' then
  begin
    if AFileName[1] <> '\' then Exit;
    CurrBS := FindBS(AFileName + 2);  // skip server name
    if CurrBS^ = #0 then Exit;
    CurrBS := FindBS(CurrBS + 1);     // skip share name
    if CurrBS^ = #0 then Exit;
  end else
    CurrBS := AFileName + 2;          // skip drive name

  L := CurrBS - AFileName;
  lstrcpyn(Buffer, AFileName, L + 1);
  while CurrBS^ <> #0 do
  begin
    NextBS := FindBS(CurrBS + 1);
    if L + (NextBS - CurrBS) + 1 > Length(Buffer) then Exit;
    lstrcpyn(Buffer + L, CurrBS, (NextBS - CurrBS) + 1);

    Handle := FindFirstFile(Buffer, FindData);
    if (Handle = -1) then Exit;
    FindClose(Handle);

    if L + 1 + lstrlen(FindData.cFileName) + 1 > Length(Buffer) then Exit;
    Buffer[L] := '\';
    lstrcpyn(Buffer + L + 1, FindData.cFileName, Length(Buffer) - L - 1);
    Inc(L, lstrlen(FindData.cFileName) + 1);
    CurrBS := NextBS;
  end;
  lstrcpy(AFileName, Buffer);
end;

end.
