unit N0Fncs;

interface

function N0Dbl(var Value: Double): Double; cdecl; export;
function N0Int(var Value: Integer): Integer; cdecl; export;
function N0Str(sz: PChar): PChar; cdecl; export;

implementation

function N0Dbl(var Value: Double): Double;
begin
  result := Value;
end;

function N0Int(var Value: Integer): Integer; cdecl; export;
begin
  result := Value;
end;

function N0Str(sz: PChar): PChar; cdecl; export;
begin
  result := sz;
end;

end.
