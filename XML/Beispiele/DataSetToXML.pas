//Dataset data exporting into XML file

//Author: Mike Shkolnik


//Sometimes in our development we must export a data from dataset into different formats like MS Excel, Word, HTML, Text etc. Now in the Internet we have a new popular format - XML-file. So for large part of applications we wants to include the possibility of export into XML, of course. I want to demonstrate the sample of one procedure for exporting of dataset's data into XML:

procedure DatasetToXML(Dataset: TDataset; FileName: string);The first Dataset parameter is source dataset with data (your Table or Query component, or some other third-party dataset). The second FileName parameter is a name of target XML-file. 

{ SMExport suite's free demo
  Data export from dataset into XML-file

  Copyright(C) 1998-2001, written by Scalabium, Shkolnik Mike
  E-Mail:  smexport@scalabium.com
           mshkolnik@yahoo.com
  WEB: http://www.scalabium.com
       http://www.geocities.com/mshkolnik
}
unit DS2XML;

interface

uses
  Classes, DB;

procedure DatasetToXML(Dataset: TDataset; FileName: string);

implementation

uses
  SysUtils;

var
  SourceBuffer: PChar;

procedure WriteString(Stream: TFileStream; s: string);
begin
  StrPCopy(SourceBuffer, s);
  Stream.Write(SourceBuffer[0], StrLen(SourceBuffer));
end;

procedure WriteFileBegin(Stream: TFileStream; Dataset: TDataset);

  function XMLFieldType(fld: TField): string;
  begin
    case fld.DataType of
      ftString, ftWideString: Result := '"string" WIDTH="' + IntToStr(fld.Size) + '"';
      ftSmallint: Result := '"i4"'; //??
      ftInteger: Result := '"i4"';
      ftLargeInt: Result := '"i4"';
      ftWord: Result := '"i4"'; //??
      ftBoolean: Result := '"boolean"';
      ftAutoInc: Result := '"i4" SUBTYPE="Autoinc"';
      ftFloat: Result := '"r8"';
      ftCurrency: Result := '"r8" SUBTYPE="Money"';
      ftBCD: Result := '"r8"'; //??
      ftDate: Result := '"date"';
      ftTime: Result := '"time"'; //??
      ftDateTime: Result := '"datetime"';
    else
    end;
    if fld.Required then
      Result := Result + ' required="true"';
    if fld.Readonly then
      Result := Result + ' readonly="true"';
  end;

var
  i: Integer;
begin
  WriteString(Stream, '  ' +
                      '');
  WriteString(Stream, '');

  {write th metadata}
  with Dataset do
    for i := 0 to FieldCount-1 do
    begin
      WriteString(Stream, ''" fieldtype=' +
                          XMLFieldType(Fields[i]) +
                          '/>');
    end;
  WriteString(Stream, '');
  WriteString(Stream, '');
  WriteString(Stream, '');
end;

procedure WriteFileEnd(Stream: TFileStream);
begin
  WriteString(Stream, '');
end;

procedure WriteRowStart(Stream: TFileStream; IsAddedTitle: Boolean);
begin
  if not IsAddedTitle then
    WriteString(Stream, '<ROW>');
end;

procedure WriteRowEnd(Stream: TFileStream; IsAddedTitle: Boolean);
begin
  if not IsAddedTitle then
    WriteString(Stream, '/>');
end;

procedure WriteData(Stream: TFileStream; fld: TField; AString: ShortString);
begin
  if Assigned(fld) and (AString <> '') then
    WriteString(Stream, ' ' + fld.FieldName + '="' + AString + '"');
end;

function GetFieldStr(Field: TField): string;

  function GetDig(i, j: Word): string;
  begin
    Result := IntToStr(i);
    while (Length(Result) < j) do
      Result := '0' + Result;
  end;

var Hour, Min, Sec, MSec: Word;
begin
  case Field.DataType of
    ftBoolean: Result := UpperCase(Field.AsString);
    ftDate: Result := FormatDateTime('yyyymmdd', Field.AsDateTime);
    ftTime: Result := FormatDateTime('hhnnss', Field.AsDateTime);
    ftDateTime: begin
                  Result := FormatDateTime('yyyymmdd', Field.AsDateTime);
                  DecodeTime(Field.AsDateTime, Hour, Min, Sec, MSec);
                  if (Hour <> 0) or (Min <> 0) or (Sec <> 0) or (MSec <> 0) then
                    Result := Result + 'T' + GetDig(Hour, 2) + ':' + GetDig(Min, 2)
                     + ':' + GetDig(Sec, 2) + GetDig(MSec, 3);
                end;
  else
    Result := Field.AsString;
  end;
end;

procedure DatasetToXML(Dataset: TDataset; FileName: string);
var
  Stream: TFileStream;
  bkmark: TBookmark;
  i: Integer;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  SourceBuffer := StrAlloc(1024);
  WriteFileBegin(Stream, Dataset);

  with DataSet do
  begin
    DisableControls;
    bkmark := GetBookmark;
    First;

    {write a title row}
    WriteRowStart(Stream, True);
    for i := 0 to FieldCount-1 do
      WriteData(Stream, nil, Fields[i].DisplayLabel);
    {write the end of row}
    WriteRowEnd(Stream, True);

    while (not EOF) do
    begin
      WriteRowStart(Stream, False);
      for i := 0 to FieldCount-1 do
        WriteData(Stream, Fields[i], GetFieldStr(Fields[i]));
      {write the end of row}
      WriteRowEnd(Stream, False);

      Next;
    end;

    GotoBookmark(bkmark);
    EnableControls;
  end;

  WriteFileEnd(Stream);
  Stream.Free;
  StrDispose(SourceBuffer);
end;


end.
PS: I created this simple procedure from own TSMExportToXML component which have a lot of other useful extensions in export process. This component is part of shareware SMExport suite for Delphi/C++Builder so I cut a part of code and created a simple procedure for exporting into XML.


From: rsutcliffe@bigfoot.com
If you are using ADO, you can use _RecordSet.Save("filename", adPersistXML) instead.
