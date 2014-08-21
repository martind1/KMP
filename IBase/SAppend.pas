unit SAppend;

interface

function appendtok(sz1, sz2, szTok: PChar): PChar; cdecl; export;

implementation

uses
  SysUtils;


function appendtok(sz1, sz2, szTok: PChar): PChar; cdecl; export;
begin
  //result := SysAllocStringLen(sz1, StrLen(sz1) + StrLen(sz2) + StrLen(szTok));
  result := System.SysGetMem(StrLen(sz1) + StrLen(sz2) + StrLen(szTok));
  if StrLen(sz1) = 0 then
    StrCopy(result, sz2) else
  begin
    StrCopy(result, sz1);
    if StrLen(sz2) > 0 then
    begin
      StrCat(result, szTok);
      StrCat(result, sz2);
    end;
  end;
end;

end.
