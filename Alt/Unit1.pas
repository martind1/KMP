unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    Edit2: TEdit;
    LaFileDatetime1: TLabel;
    LaFiledate1: TLabel;
    LaFiledate2: TLabel;
    LaFileDatetime2: TLabel;
    LaFatDate1: TLabel;
    LaFatDate2: TLabel;
    LaFiledateb1: TLabel;
    LaFiledateb2: TLabel;
    BitBtn2: TBitBtn;
    BtnBeep: TButton;
    BtnTimeToStr: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BitBtn2Click(Sender: TObject);
    procedure BtnBeepClick(Sender: TObject);
    procedure BtnTimeToStrClick(Sender: TObject);
  private
    procedure FileDatim;
    procedure GetInfo;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}
uses
  Math;

function IsAlpha(Ch:char): boolean;
begin
  result := (Ch in ['A'..'Z']) or (Ch in ['a'..'z']);
end;

function IsNum(Ch:char): boolean;
begin
  result := Ch in ['0'..'9'];
end;

function StrCgeChar(S: string; chVon, chNach: char): string;
{ersetzt ein Zeichen durch ein anderes. Wenn chNach = #0 wird das Zeichen gelöscht}
var
  I: integer;
begin
//  result := S;
//  while Pos(chVon, result) > 0 do
//    if chNach = #0 then
//      System.Delete(result, Pos(chVon, result), 1) else
//      result[Pos(chVon, result)] := chNach;
//
  result := '';
  for I := 1 to length(S) do
    if S[I] = chVon then
    begin
      if chNach <> #0 then
        result := result + chNach;
    end else
      result := result + S[I];
end;

function LTrimCh(S: string; Ch: Char): string;
{ return a string with leading ch removed }
var
  I: Word;
begin
  I:=1;
  while (I <= length(S)) and (S[I] = Ch) do inc(I);
  Result :=Copy(S, I, length(S) - I + 1)
end;

function Trim0(S: string): string;
{ return a string with leading '0' removed }
begin
  Result := LTrimCh(S, '0');
end;

function LTrim(S: string): string;
{ return a string with leading spaces removed }
begin
  Result :=ltrimCh(S, ' ')
end;

function RTrimCh(S: string; Ch:Char): string;
{ return a string with trailing ch removed }
var
  I: Word;
begin
  I:=length(S);
  while (I > 0) and (S[I] =Ch) do
  begin
    Delete( S, I, 1);
    Dec(I);
  end;
  Result :=S
end;

function RTrim(S: string): string;
{ return a string with leading spaces removed }
begin
  Result :=rtrimCh(S, ' ')
end;

function TrimCh(S: string; Ch: Char): string;
{ return a string with leading and trailing ch removed }
begin
  Result :=ltrimCh(rtrimCh(S, Ch), Ch)
end;

function Trim(S: string): string;
{ return a string with leading and trailing spaces removed }
begin
  Result := rtrim(ltrim(S))
end;

function StrToFloatTol(const S: string): Extended;
(* führende/folgende Alpha/Leerzeichen ignorieren. 0 wenn Exception *)
var
  P1, P2 : integer;
  S1, S2: string;
const
  OldS: string = '';
begin
  if (Trim(S) = '') or (TrimCh(S, #0) = '') then
    result := 0 else
  try
    P1 := 1;
    while (length(S) >= P1) and (IsAlpha(S[P1]) or (S[P1] = ' ')) do
      Inc(P1);
    P2 := P1;
    while (length(S) >= P2) and (IsNum(S[P2]) or (S[P2] in ['+','-','.',',','E','e'])) do
      Inc(P2);
    S1 := copy(S, P1, P2 - P1);
    if SysUtils.ThousandSeparator <> SysUtils.DecimalSeparator then
      S2 := StrCgeChar(S1, SysUtils.ThousandSeparator, #0) else      {TauTrenner weg}
      S2 := S1;
    result := StrToFloat(S2);
  except
    on E:Exception do
    begin
      OldS := S;
      result := 0;
    end;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var                  {Destination in Insert-Modus}
  //P: array[0..256] of char;
  E: boolean;
  P: integer;
begin
  //Edit2.Text := FloatToStr(StrToFloatTol(Edit1.Text));
  FileDatim;
end;

procedure TForm1.FileDatim;
var
  FileHandle: integer;
  ftLastWrite: FILETIME;
  lpFatDate, lpFatTime: Word;
  FatDateTime: LongRec;
begin
  try
    FileHandle := FileOpen(Edit1.Text, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then
    begin
      {LaFiledate1.Caption := IntToStr(FileGetDate(FileHandle));
      LaFileDatetime1.Caption := DateTimeToStr(FileDateToDateTime(FileGetDate(FileHandle)));}

      GetFileTime(FileHandle, nil, nil, @ftLastWrite);
      LaFiledate1.Caption := IntToStr(int64(ftLastWrite));
      FileTimeToDosDateTime(ftLastWrite, lpFatDate, lpFatTime);
      FatDateTime.hi := lpFatDate;
      FatDateTime.lo := lpFatTime;
      LaFatDate1.Caption := IntToStr(integer(FatDateTime));
      LaFileDatetime1.Caption := DateTimeToStr(FileDateToDateTime(integer(FatDateTime)));

      DosDateTimeToFileTime(lpFatDate, lpFatTime, ftLastWrite);
      LaFiledateb1.Caption := IntToStr(int64(ftLastWrite));
    end;

    FileHandle := FileOpen(Edit2.Text, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then
    begin
      //LaFiledate2.Caption := IntToStr(FileGetDate(FileHandle));
      //LaFileDatetime2.Caption := DateTimeToStr(FileDateToDateTime(FileGetDate(FileHandle)));
      GetFileTime(FileHandle, nil, nil, @ftLastWrite);
      LaFiledate2.Caption := IntToStr(int64(ftLastWrite));
      FileTimeToDosDateTime(ftLastWrite, lpFatDate, lpFatTime);
      FatDateTime.hi := lpFatDate;
      FatDateTime.lo := lpFatTime;
      LaFatDate2.Caption := IntToStr(integer(FatDateTime));
      LaFileDatetime2.Caption := DateTimeToStr(FileDateToDateTime(integer(FatDateTime)));

      DosDateTimeToFileTime(lpFatDate, lpFatTime, ftLastWrite);
      LaFiledateb2.Caption := IntToStr(int64(ftLastWrite));
    end;
  finally
     FileClose(FileHandle);
  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //CanClose := false;
end;


procedure TForm1.GetInfo;
//von Starter
var
  TS: TTimeStamp;
  S1: string;
  T1: integer;
  T1u: Longword;  //32 Bit, ohne Vorzeichen
  OldT1: integer;
  DTOffs: TDateTime;
begin
{$OVERFLOWCHECKS ON}
{$RANGECHECKS ON}
  DTOffs := 0;
  OldT1 := 1;
  try
    T1 := $80000000;  //$FFFFFFFF;  //;  //TicksDelayed(StartTime);
    if T1 < 0 then
    begin
      if OldT1 > 0 then
        DTOffs := DTOffs + ($80000000 / MSecsPerDay);
      OldT1 := T1;
      T1 := Longword(T1) - $80000000;  //xor -1;  //T1 := T1 - $7FFFFFFF
    end;

    TS := MSecsToTimeStamp(T1);
    TS.Date := TS.Date + trunc(DTOffs);
    TS.Time := TS.Time + round(Frac(DTOffs) * MSecsPerDay);
    S1 := TimeToStr(TimeStampToDateTime(TS));
    if TS.Date = 0 then
      Edit1.Text := S1 else
      Edit1.Text := Format('%dT %s', [TS.Date, S1]);
  except on E:Exception do
    Edit1.Text := E.Message;
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  GetInfo;
end;

procedure TForm1.BtnBeepClick(Sender: TObject);
begin
  Beep;
end;

procedure TForm1.BtnTimeToStrClick(Sender: TObject);
var
  S: string;
begin
  S := Format('%s|%s|%s', [ShortTimeFormat, LongTimeFormat, TimeToStr(30 / SecsPerDay)]);
  MessageDlg(S, mtInformation, [mbOK], 0);
  
  ShortTimeFormat := 'hh:mm';
  LongTimeFormat := 'hh:mm:ss';
  S := Format('%s|%s|%s', [ShortTimeFormat, LongTimeFormat, TimeToStr(30 / SecsPerDay)]);
  MessageDlg(S, mtInformation, [mbOK], 0);
end;

end.
