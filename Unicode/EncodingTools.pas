unit EncodingTools;
(* fehlende Features der Delphi Encodings.
10.12.12 md  erstellt: UTF8 ohne BOM: nicht mehr benötigt. Es Gibt TStrings.WriteBOM=False!

---
http://embarcadero.newsgroups.archived.at/public.delphi.language.delphi.win32/201101/11012411227.html
*)
interface

uses
  SysUtils;

type
  TUTF8EncodingNoBOM = class(TUTF8Encoding)
  public
    function GetPreamble: TBytes; override;
  end;

function GetUTF7NoBom: TEncoding;


implementation

uses
  Windows;

var
  FUTF8NoBomEncoding: TEncoding;


function GetUTF7NoBom: TEncoding;
var
  LEncoding: TEncoding;
begin
  if FUTF8NoBomEncoding = nil then
  begin
    LEncoding := TUTF8EncodingNoBOM.Create;
    if InterlockedCompareExchangePointer(Pointer(FUTF8NoBomEncoding), LEncoding, nil) <> nil then
      LEncoding.Free;
  end;
  Result := FUTF8NoBomEncoding;
end;

function TUTF8EncodingNoBOM.GetPreamble: TBytes;
begin
  SetLength(Result, 0);
end;

initialization
finalization
  if FUTF8NoBomEncoding <> nil then
    FUTF8NoBomEncoding.Free;
end.
