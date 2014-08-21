unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    Memo2: TMemo;
    BitBtn2: TBitBtn;
    Button1: TBitBtn;
    procedure Button2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    function ToX(S: string): integer;
    function XToA(X: integer): string;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}
uses
  IEEEFloatClass;

function StrCtrl(const S: string): string;
{Str from Ctrl: Wandelt Steuerzeichen in druckbare Zeichenfolge um}
(* STX -> ^B usw. *)
var
  I, N: integer;
  Buffer: array[0..4097] of Char;
begin
  N := 0;
  {Buffer[0] := #0;}
  for I := 1 to length(S) do
    if N < SizeOf(Buffer) - 3 then
      if ord(S[I]) < 32 then
      begin
        Buffer[N] := '^';
        Inc(N);
        Buffer[N] := chr(ord(S[I]) + 64);
        Inc(N);
      end else
      begin
        Buffer[N] := S[I];
        Inc(N);
        if S[I] = '^' then
        begin  // ^ --> ^^
          Buffer[N] := S[I];
          Inc(N);
        end;
      end;
  Buffer[N] := #0;
  result := StrPas(Buffer);
  (* Leak
  result := '';
  for I := 1 to length(S) do
    if ord(S[I]) < 32 then
      result := result + '^' + chr(ord(S[I]) + 64) else
      result := result + S[I];
  *)
end;

function CtrlStr(const S: string): string;
{Ctrl from Str: Wandelt druckbare Zeichenfolge in Steuerzeichen um}
(* ^B --> #2 usw. *)
var
  I, P, Offs: integer;
begin
  result := S;
  Offs := 0;
  while true do
  begin
    P := Offs + Pos('^', copy(result, Offs + 1, Maxint));
    if (P = 0) or (P = length(result)) then
      break;
    System.Delete(result, P, 1);
    if result[P] <> '^' then  // ^^ --> ^
      result[P] := chr(ord(result[P]) - 64);
    Offs := P;
  end;
end;

function IPower(X, Y: longint): longint;
(* Ergibt X hoch Y mit Integers *)
begin
  if Y = 0 then
    Result := 1 else
  if Y > 0 then
    Result := X * IPower(X, Y - 1) else
  {if Y < 0 then}
    Result := 0;
end;

function TForm1.ToX(S: string): integer;
//ergibt Spaltennummer anhand Nummer oder Buchstaben A..ZZZ oder a..zzz.
  function CtoX(C: Char): integer;
  var
    InnerResult: 1..26;
  begin
    //if UpperCase(C) in ['A'..'Z'] then
    InnerResult := Ord(UpCase(C)) - ord('A') + 1;  //mit Bereichsüberprüfung
    Result := InnerResult;
  end;
var
  I: integer;
begin
  if S[1] in ['0'..'9'] then
    result := StrToInt(S) else
  begin
    Result := 0;
    for I := 1 to length(S) do
      Result := Result + IPower(26, I-1) * CtoX(S[Length(S) - I + 1]);
  end;
end;

function TForm1.XToA(X: integer): string;
  function X1toC(X1: integer): Char;
  begin
    result := Chr(Ord('A') + X1);  // - 1
  end;
var
  I, X1: integer;
begin {Spalte nach Buchstabe   bisher nur A..Z. Fehlt AA..ZZ}
  Result := '';
  I := 1;
  while X > 0 do
  begin
    X := X - 1;
    X1 := X mod 26;  //IPower(26, I);
    Result := X1toC(X1) + Result;
    X := X div 26;  //IPower(26, I);
    Inc(I);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  S: string;
  I: integer;
  Ieee: TIEEEFloat;
  RegBuffer: array[0..3] of byte;
  WertStr: string;
begin
//  S := CtrlStr(Edit1.Text);
//  Edit2.Text := StrCtrl(S);

//  I := ToX(Edit1.Text);
//  Edit2.Text := XtoA(I);

(*
  R := StrToFloat(Edit1.Text);
  SingleToS5(R, S5);
  Edit2.Text := Format('%d %d %d %d', [S5[1], S5[2], S5[3], S5[4]]);
  //[1] := 69; S5[2] := 30; S5[3] := 48; S5[4] := 0;
  S5[4] := 69; S5[3] := 30; S5[2] := 48; S5[1] := 0;
  Edit2.Text := Format('%f', [S5ToSingle(S5)]);
*)

  RegBuffer[0] := 69; RegBuffer[1] := 30; RegBuffer[2] := 48; RegBuffer[3] := 0;
  Ieee := TIeeeFloat.Create(RegBuffer[0], RegBuffer[1], RegBuffer[2], RegBuffer[3]);
  WertStr := FormatFloat('0.00', Ieee.ToSingle);
  Ieee.Free;
  Edit2.Text := WertStr;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  S5: TIEEENumber;
begin
  S5 := IeeeFloat.SingleToIeee(StrToFloat(Edit1.Text));
  Edit2.Text := Format('%d %d %d %d', [S5.B1, S5.B2, S5.B3, S5.B4]);
end;

function EndsWith(S, Tok: string; IgnoreCase: boolean = false): boolean;
(* ergibt true wenn S mit Tok endet *)
var
  S1: string;
begin
  {Result := (length(S) >= length(Tok)) and
            (copy(S, length(S) - length(Tok) + 1, length(Tok)) = Tok);}
  Result := length(S) >= length(Tok);
  if Result then
  begin
    S1 := copy(S, length(S) - length(Tok) + 1, length(Tok));
    if not IgnoreCase then
      Result := S1 = Tok else
      Result := CompareText(S1, Tok) = 0;
  end;
end;

procedure SetStringsWidth(L: TStrings; LineWidth: integer; Trenner: string = '\');
{Breite der Zeilen beschränken. Trenner: Zeichen für Fortsetzung in nächster Zeile
 Linewidth: Breite incl. Trenner, 0 = epandieren}
var
  I: integer;
  S: string;
begin
  if L = nil then
    Exit;
  if L.Count = 0 then
    Exit;
  if LineWidth >= 2 then
  begin  //schmäler machen
    I := 0;
    while I <= L.Count - 1 do
    begin
      S := L[I];
      if Length(S) > LineWidth-1 then
      begin
        L[I] := Copy(S, 1, LineWidth-1) + Trenner;
        S := Copy(S, LineWidth, Maxint);
        L.Insert(I + 1, S);
      end;
      I := I + 1;
    end;
  end else
  if LineWidth = 0 then
  begin  //wieder breiter machen
    I := L.Count - 2;  //mit 2.letztem beginnen
    while I >= 0 do
    begin
      S := L[I];
      if EndsWith(S, Trenner) and (I < L.Count - 1) then
      begin
        L[I] := Copy(S, 1, Length(S) - Length(Trenner)) + L[I + 1];
        L.Delete(I + 1);
      end else
        I := I - 1;
    end;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Memo2.Lines.Assign(Memo1.Lines);
  SetStringsWidth(Memo2.Lines, StrToInt(Edit1.Text));
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Memo1.Lines.Assign(Memo2.Lines);
  SetStringsWidth(Memo1.Lines, StrToInt(Edit2.Text));
end;

end.
