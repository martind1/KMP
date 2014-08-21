unit VektorKmp;
(* Komponente für lineare Funktionen. Die Gerade geht durch P1(X1,Y1) und P2(X2,Y2)
   X, Y sind integer.   F(X) ist double.
                                          Y2 - Y1
   F(X1) = Y1; F(X2) = Y2;         F(X) = ------- * (X - X1) + Y1;
                                          X2 - X1
  ***}

*)
interface

uses
  Windows, Classes;

type
  TVektor = class(TObject)
    X1, X2, Y1, Y2: integer;
    DX, DY: integer;
    constructor Create(aX1, aX2, aY1, aY2: integer);
    function F(X: integer): double;
    function FI(X: integer): integer; overload;
    function FI(X: double): integer; overload;
  end;

implementation

constructor TVektor.Create(aX1, aX2, aY1, aY2: integer);
begin
  X1 := aX1;
  X2 := aX2;
  Y1 := aY1;
  Y2 := aY2;
  DX := X2 - X1;
  DY := Y2 - Y1;
end;

function TVektor.F(X: integer): double;
begin
  if (DX = 0) or (DY = 0) then
    result := Y1 else
    result := DY * (X - X1) / DX + Y1;
end;

function TVektor.FI(X: integer): integer;
begin    {wie F aber mit Integer result}
  if (DX = 0) or (DY = 0) then
    result := Y1 else
    result := MulDiv(DY, (X - X1), DX) + Y1;
end;

function TVektor.FI(X: double): integer;
begin
  if (DX = 0) or (DY = 0) then
    result := Y1 else
    result := round(DY * (X - X1) / DX + Y1);
end;

end.
