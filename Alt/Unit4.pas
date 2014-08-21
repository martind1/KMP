unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, DBAccess, Uni, UDB__Kmp, MemDS, UQue_Kmp;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    BitBtn2: TBitBtn;
    Memo1: TMemo;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}
uses
  CodecUtilsWin32;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  LBuffer: TBytes;
  LByteOrderMark: TBytes;
  LOffset: Integer;
  LEncoding, DestEncoding: TEncoding;
  LFileStream: TFileStream;
  EncodingArray: array[0..5] of TEncoding;

  codec: TUnicodeCodec;
  S: WideString;
  SL: TStringList;
begin
  LEncoding:= nil;
  EncodingArray[0]:= TEncoding.UTF8;
  EncodingArray[1]:= TEncoding.UTF7;
  EncodingArray[2]:= TEncoding.Unicode;
  EncodingArray[3]:= TEncoding.Default;
  EncodingArray[4]:= TEncoding.BigEndianUnicode;
  EncodingArray[5]:= TEncoding.ASCII;
  DestEncoding := TEncoding.UTF8;
  LFileStream := TFileStream.Create(Edit1.Text, fmOpenRead);
  try
    // Read file into buffer.
    SetLength(LBuffer, LFileStream.Size);
    LFileStream.Read(LBuffer[0], Length(LBuffer));  //LFileStream.ReadBuffer(Pointer(LBuffer)^, Length(LBuffer));

(* klappt nur teilweise. Charset fehlt!    //MD:
    LEncoding := TEncoding.GetEncoding(1250);
    // Identify encoding and convert buffer to UTF8.
    LOffset := TEncoding.GetBufferEncoding(LBuffer, LEncoding);
//    for I := 0 to Length(LBuffer) - 1 do
//      Memo1.Lines.Add((LBuffer[I]));
    LBuffer := LEncoding.Convert(LEncoding, DestEncoding, LBuffer,
      LOffset, Length(LBuffer) - LOffset);
*)

    codec := TEncodingRepository.CreateCodecByAlias('ISO-8859-2');

    codec.DecodeStr(Pointer(LBuffer), Length(LBuffer), S);

  finally
    LFileStream.Free;
  end;

  //LFileStream := TFileStream.Create(Edit2.Text, fmCreate);
  SL := TStringList.Create;
  try
    (*
    // Write an encoding byte-order mark and buffer to output file.
    LByteOrderMark := DestEncoding.GetPreamble;
    LFileStream.Write(LByteOrderMark[0], Length(LByteOrderMark));
    LFileStream.Write(LBuffer[0], Length(LBuffer));
    *)
    SL.Text := S;
    SL.SaveToFile(Edit2.Text, TEncoding.UTF8);
  finally
    //LFileStream.Free;
    SL.Free;
  end;
end;

function StrToWideString(const S: AnsiString; const CodecAlias: string): WideString;
// Ergibt UTF8 String anhand Ansi und Codec-Alias ('ISO-8859-2')
var
  codec: TUnicodeCodec;
begin
  codec := TEncodingRepository.CreateCodecByAlias(CodecAlias);
  codec.DecodeStr(Pointer(S), Length(S), Result);
end;

procedure ReadLF(var F: TextFile; var S: string);
var
  C: AnsiChar;
  AStr: AnsiString;
begin
  AStr := '';
  while not EOF(F) do
  begin
    Read(F, C);
    if C = #13 then   //CR
      continue;
    if C = #10 then   //LF
      break;
    if ord(C) < 32 then
      break;
    AStr := AStr + C;
  end;
  S := StrToWideString(AStr, 'ISO-8859-2');
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  F: Textfile;
  FN: string;
  S: string;
begin
  Memo1.Lines.Clear;
  FN := Edit1.Text;
  begin
    AssignFile(F, FN);
    Reset(F);
    try
      while not Eof(F) do
      begin
        ReadLF(F, S);
        Memo1.Lines.Add(S);
      end;
    finally
      CloseFile(F);
    end;
  end;
end;

end.
