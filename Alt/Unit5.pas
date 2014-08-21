unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TForm5 = class(TForm)
    BtnOpen: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    BtnSave: TBitBtn;
    BtnStrToIntTol: TBitBtn;
    EdSrc: TEdit;
    EdDest: TEdit;
    procedure BtnOpenClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnStrToIntTolClick(Sender: TObject);
  private
    { Private-Deklarationen }
    L, L2: TStringList;
    procedure Process;
    function ProcessLine(S: Ansistring): Ansistring;
  public
    { Public-Deklarationen }
  end;

var
  Form5: TForm5;

implementation
{$R *.dfm}
uses
  ShellApi;

function TForm5.ProcessLine(S: Ansistring): Ansistring;
var
  I, Step: integer;
  Ch: AnsiChar;
  S1: Ansistring;
begin
  Step := 0;
  Result := '';
  for I := 1 to length(S) do
  begin
    Ch := S[I];
    if Step = 0 then
    begin
      if Ch = ' ' then
      begin
        Result := Result + Ch;
      end else
      begin
        S1 := Ch;
        Step := 1;
      end;
    end else
    if Step = 1 then
    begin
      if Ch = ' ' then
      begin
        if (length(S1) = 2) and (S1[1] in ['0'..'9','A'..'F']) and
           (S1[2] in ['0'..'9','A'..'F']) then
        begin  //41 -> 'A'
          S1 := chr(StrToInt('$' + S1));
        end;
        Result := Result + S1 + Ch;
        S1 := '';
        Step := 0;
      end else
      begin
        S1 := S1 + Ch;
      end;
    end;
  end;
end;

procedure TForm5.Process;
var
  I: Integer;
begin
  for I := 0 to L.Count - 1 do
    L2.Add(ProcessLine(L[I]));
end;

procedure TForm5.BtnOpenClick(Sender: TObject);
var
  N: integer;
begin
  L := TStringList.Create;
  L2 := TStringList.Create;
  L.LoadFromFile(Edit1.Text);
  Process;
end;

procedure TForm5.BtnSaveClick(Sender: TObject);
begin
  L2.SaveToFile(Edit2.Text);
end;

//StrToIntTol:

function IsNum(Ch: Char): boolean;
begin
  Result := CharInSet(Ch, ['0'..'9']);
end;

function IsHexDec(Ch: Char): boolean;
begin
  Result := IsNum(Ch) or CharInSet(UpCase(Ch), ['A'..'F']);
end;

function StrCgeChar(const S: string; chVon, chNach: char): string;
{ersetzt ein Zeichen durch ein anderes. Wenn chNach = #0 wird das Zeichen gelöscht}
var
  I: integer;
begin
//  Result := S;
//  while Pos(chVon, Result) > 0 do
//    if chNach = #0 then
//      System.Delete(Result, Pos(chVon, Result), 1) else
//      Result[Pos(chVon, Result)] := chNach;
//
  if Pos(chVon, S) = 0 then
  begin  //Optimierung 15.01.12
    Result := S;
    Exit;
  end;
  Result := '';
  for I := 1 to length(S) do
    if S[I] = chVon then
    begin
      if chNach <> #0 then
        Result := Result + chNach;
    end else
      Result := Result + S[I];
end;

function StrToIntTol(const S: string): longint;
{ führende/folgende Alpha/Leerzeichen ignorieren. 0 wenn Exception
   28.11.97 mit Hex (beginnt mit $) }
var
  P1, P2 : integer;
  HasDollar: boolean;
  S1: string;
begin
  Result := 0;
  HasDollar := false;
  S1 := Trim(StrCgeChar(S, SysUtils.ThousandSeparator, #0)); {TauTrenner weg}
  if S1 <> '' then
  try
    P1 := 1;
    //gehe bis zum Anfang einer Nummer +/-/$/1..9  (qsbt.shsimx.mirefresh - 29.09.04)
    while (length(S1) >= P1) and
          {(IsAlpha(S1[P1]) or (S1[P1] = ' ') or (S1[P1] = '0')) do}
          not CharInSet(S1[P1], ['-', '+', '$', '1'..'9']) do
    begin
      Inc(P1);
    end;
    P2 := P1;
    if P1 <= length(S1) then
    begin
      if S1[P1] = '$' then
      begin
        HasDollar := true;
        Inc(P2);
      end else
      if CharInSet(S1[P1], ['-', '+']) then
      begin
        Inc(P2);
      end;
    end;
    // ab jetzt nur noch Ziffern oder Hexzeichen
//    while (P2 <= length(S1)) and
//          (IsHexDec(S1[P2]) or
//           ((S1[P2] = '$') and (P2 = P1) and (length(S1) > 1)) or
//           ((P2 < length(S1)) and
//            CharInSet(S1[P2], ['+','-',SysUtils.ThousandSeparator]) and
//            IsHexDec(S1[P2+1]))) do
    while (P2 <= length(S1)) and
          ((HasDollar and IsHexDec(S1[P2]) or IsNum(S1[P2]))) do
    begin
      Inc(P2);
    end;
    if P2 = P1 then              {Leerstr}
      Result := 0 else
    if (P2 = P1 + 1) and not IsNum(S1[P1]) then  //nur '$', '-' oder '+'
      Result := 0 else
      Result := StrToInt(StrCgeChar(copy(S1, P1, P2 - P1),
                         SysUtils.ThousandSeparator, #0)); {TauTrenner weg}
      //Result := StrToInt(copy(S1, P1, P2 - P1));
  except on E:Exception do
    Result := -99;
  end;
end;


procedure TForm5.BtnStrToIntTolClick(Sender: TObject);
begin
  EdDest.Text := IntToStr( StrToIntTol(EdSrc.Text));
end;

end.
