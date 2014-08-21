unit WideStringConvert;
(* deals with Unicode and Widestrings
*)
interface

function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
function StringToWideString(const s: AnsiString; codePage: Word): WideString;

implementation

uses
  Windows;



{:Converts Unicode string to Ansi string using specified code page.
  @param   ws       Unicode string.
  @param   codePage Code page to be used in conversion.
  @returns Converted ansi string.
}

function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
var
  l: integer;
  Flags: DWORD;
begin
  if ws = '' then
    Result := ''
  else
  begin
    Flags := WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR;
    //Flags := WC_COMPOSITECHECK or WC_SEPCHARS;
    l := WideCharToMultiByte(codePage, Flags, @ws[1], - 1, nil, 0, nil, nil);
    SetLength(Result, l - 1);
    if l > 1 then
      WideCharToMultiByte(codePage, Flags, @ws[1], - 1, @Result[1], l - 1, nil, nil);
  end; 
end; { WideStringToString } 


{:Converts Ansi string to Unicode string using specified code page. 
  @param   s        Ansi string. 
  @param   codePage Code page to be used in conversion. 
  @returns Converted wide string. 
} 
function StringToWideString(const s: AnsiString; codePage: Word): WideString;
var
  l: integer;
begin 
  if s = '' then
    Result := ''
  else  
  begin 
    l := MultiByteToWideChar(codePage, MB_PRECOMPOSED, PAnsiChar(@s[1]), - 1, nil, 0);
    SetLength(Result, l - 1); 
    if l > 1 then 
      MultiByteToWideChar(CodePage, MB_PRECOMPOSED, PAnsiChar(@s[1]),
        - 1, PWideChar(@Result[1]), l - 1); 
  end; 
end; { StringToWideString }

end.