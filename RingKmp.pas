unit RingKmp;
(* Einfacher Ringpuffer
   Begrenzte Anzahl von Werten
   PushFirst, PushLast
   GetFirst, GetLast
   PullFirst, PullLast
   Avg
   Sum

Tests: Kmp\Projekt6
Profi-Version: http://www.odsrv.com/RingBuffer/RingBuffer.htm

29.03.14 md  erstellt

*)
interface

uses
  Windows, Classes;

type
  TRing = class(TObject)
    D: array of integer;
    DSize: integer;
    N: integer;
    Start: integer;
    Ende: integer;
    constructor Create(DSize: integer);
    destructor Destroy; override;
    procedure PushFirst(V: integer);
    function Avg: Double;  //für gleitenden Mittelwert
  end;

implementation

uses
  Prots, Err__Kmp;

{ TRing }

constructor TRing.Create(DSize: integer);
begin
  inherited Create;

  Start := 0;
  Ende := 0;
  N := 0;
  Self.DSize := DSize;
  SetLength(D, DSize);
end;

destructor TRing.Destroy;
begin
  SetLength(D, 0);
  inherited;
end;

procedure TRing.PushFirst(V: integer);
begin
  if Start = 0 then
    Start := DSize - 1 else
    Start := Start - 1;
  D[Start] := V;
  N := IMin(N + 1, DSize);

  Ende := Start + N - 1;
  if Ende >= DSize then
    Ende := Ende - DSize;
end;

function TRing.Avg: Double;
var
  I, J: integer;
begin
  Result := 0;
  if N = 0 then
    EError('Ring.Avg: N=0', [0]);
  for J := Start to Start + N - 1 do
  begin
    if J >= DSize then
      I := J - DSize else
      I := J;
    Result := Result + D[I];
  end;
  Result := Result / N;
end;

end.
