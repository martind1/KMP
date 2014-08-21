unit HtmlClp;
(* HTML Clipboard Routinen
   04.01.00 MD Erstellt (GEN)

   GNavigator.HtmlTable enthält die Vorlage einer einfachen HTML Tabelle:
   [HdrTable]
   <TABLE BORDER=1>
   [HdrCaptions]
   <TR>
   [Captions]
     <TD><b>%s</b></TD>
   [FtrCaptions]
   </TR>
   [HdrLine]
   <TR>
   [Line]
     <TD>%s</TD>
   [FtrLine]
   </TR>
   [FtrTable]
   </TABLE>

   Ein anderes Format kann in GNavigator.HtmlTable eingetragen werden oder
   im File HtmlTable.INI, das zur Laufzeit eingelesen wird.
   Beispiel für Access-Format: ..\kmp\htmlAccess.ini

   weitere Html-Routinen:
   MuGriKmp: TMultiGrid.CopyToHtml - kopiert markierte Zeilen ins Html Clipboard
   Prots: StrToHtml - ergibt String mit Umlauten im Html Format (&auml;) 
*)


interface

uses
  Classes;

procedure ShowLastError(aCaption: string);
(* LastError mit Text aus Windows-System anzeigen *)
procedure GetClpFormats(Strings: TStrings);
(* füllt Strings mit Clipboard Formaten: <Nr>=<Text> *)
procedure GetClpData(ClpFormat: integer; Strings: TStrings);
(* füllt Strings mit Clipboard Formaten: <Nr>=<Text> *)
procedure CopyHtml(HtmlFragment, ContextStart, ContextEnd: string);
(* ergänzt und kopiert Html Frgment ins Clipboard *)
procedure CopyRtf(RtfFragment: string);
(* kopiert Rtf Frgment ins Clipboard *)
procedure CopyTxt(TxtFragment: string);
(* kopiert Txt Frgment ins Clipboard *)
procedure CopyCsv(CsvFragment: string);
(* kopiert Csv Frgment ins Clipboard *)

implementation

uses
  Clipbrd, RichEdit, Windows, SysUtils,
  Prots, Err__Kmp;

procedure ShowLastError(aCaption: string);
(* LastError mit Text aus Windows-System anzeigen *)
var
  //lpMsgBuf: PChar;
  Err: DWORD;
begin
  Err := GetLastError;
  ErrWarn('Systemerror %d at %s: %s', [Err, aCaption, SysErrorMessage(Err)]);

//  lpMsgBuf := nil;  //wird angelegt
//  FormatMessage(
//    FORMAT_MESSAGE_ALLOCATE_BUFFER + FORMAT_MESSAGE_FROM_SYSTEM,
//    nil,
//    GetLastError,
//    0, // Default language
//    lpMsgBuf,
//    0,
//    nil);
//  // Display the string.
//  MessageBox(NULL, lpMsgBuf, 'GetLastError', MB_OK+MB_ICONINFORMATION );
//  // Free the buffer.
//  LocalFree(THandle(lpMsgBuf));
end;

procedure GetClpFormats(Strings: TStrings);
(* füllt Strings mit Clipboard Formaten: <Nr>=<Text> *)
var
  I: integer;
  P: array[0..300] of char;
begin
  Strings.Clear;
  for I := 0 to ClipBoard.FormatCount - 1 do
  begin
    GetClipboardFormatName(ClipBoard.Formats[I], P, 250);
    Strings.Add(Format('%d=%s', [ClipBoard.Formats[I], P]));
  end;
end;

procedure GetClpData(ClpFormat: integer; Strings: TStrings);
(* füllt Strings mit Clipboard Formaten: <Nr>=<Text> *)
var
  Data: THandle;
  DataPtr: PChar;       {Pointer;}
begin                   {Grid Daten nach Word: Clipboard Format cfIndex}
  Strings.Clear;
  ClipBoard.Open;
  Data := GetClipboardData(ClpFormat);
  if Data <> 0 then
  begin
    DataPtr := GlobalLock(Data);
    if DataPtr <> nil then
      Strings.Text := StrPas(DataPtr);
    GlobalUnlock(Data);
  end;
  ClipBoard.Close;
end;

procedure CopyHtml(HtmlFragment, ContextStart, ContextEnd: string);
// ergänzt und kopiert Html Frgment ins Clipboard
//D2010
const
  Description = 'Version:1.0' + CRLF +
                'StartHTML:aaaaaaaaaa' + CRLF +
                'EndHTML:bbbbbbbbbb' + CRLF +
                'StartFragment:cccccccccc' + CRLF +
                'EndFragment:dddddddddd' + CRLF;
var
  ClpHTML: integer;
  S1: String;
  AnsiStr: AnsiString;
  Data: THandle;
  DataPtr: PAnsiChar;
begin
  if ContextStart = '' then ContextStart := '<HTML><BODY>';
  if ContextEnd = '' then ContextEnd := '</BODY></HTML>';
  ContextStart := ContextStart + '<!--StartFragment -->';
  ContextEnd := '<!--EndFragment -->' + ContextEnd;
  ClpHTML := RegisterClipboardFormat('HTML Format');
  if ClpHTML <> 0 then
  begin
    // Build the HTML given the description, the fragment and the context.
    // And, replace the offset place holders in the description with values
    // for the offsets of StartHMTL, EndHTML, StartFragment and EndFragment.
    S1 := Description + ContextStart + HtmlFragment + ContextEnd;
    S1 := StrCgeStrStr(S1, 'aaaaaaaaaa', FormatFloat('0000000000', length(Description)), true);
    S1 := StrCgeStrStr(S1, 'bbbbbbbbbb', FormatFloat('0000000000', length(S1)), true);
    S1 := StrCgeStrStr(S1, 'cccccccccc', FormatFloat('0000000000',
                                 length(Description) + length(ContextStart)), true);
    S1 := StrCgeStrStr(S1, 'dddddddddd', FormatFloat('0000000000',
          length(Description) + length(ContextStart) + length(HtmlFragment)), true);
    // Add the HTML code to the clipboard
    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_SHARE + GMEM_ZEROINIT,
                        sizeof(Char) * (length(S1) + 10));
    if Data = 0 then
    begin
      ShowLastError('CopyHtml');
    end else
    begin
      DataPtr := GlobalLock(Data);
      if DataPtr <> nil then
      begin
        AnsiStr := AnsiString(S1);
        StrPCopy(DataPtr, AnsiStr);
        GlobalUnlock(Data);
        ClipBoard.SetAsHandle(ClpHTML, Data);
      end;
    end;
  end;
end;

procedure CopyRtf(RtfFragment: string);
(* kopiert Rtf Frgment ins Clipboard *)
var
  ClpRTF: integer;
  Data: THandle;
  DataPtr: PAnsiChar;
  AnsiStr: AnsiString;
begin
  ClpRTF := RegisterClipboardFormat(CF_RTF);
  if ClpRTF <> 0 then
  begin
    Clipboard.Open;
    {Clipboard.Clear;    nicht wenn nach Html}
    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_SHARE + GMEM_ZEROINIT,
                        sizeof(Char) * (length(RtfFragment) + 10));
    if Data = 0 then
    begin
      ShowLastError('CopyRtf');
    end else
    begin
      DataPtr := GlobalLock(Data);
      if DataPtr <> nil then
      begin
        AnsiStr := AnsiString(RtfFragment);
        StrPCopy(DataPtr, AnsiStr);
        GlobalUnlock(Data);
        if SetClipboardData(ClpRTF, Data) = 0 then
          ShowLastError('CopyRtf');
      end;
    end;
    Clipboard.Close;
  end;
end;

procedure CopyTxt(TxtFragment: string);
// kopiert Txt Frgment ins Clipboard
//28.12.11 works
begin
  Clipboard.Open;
  try
    Clipboard.SetTextBuf(PChar(TxtFragment));
  finally
    Clipboard.Close;
  end;
end;

procedure CopyCsv(CsvFragment: string);
(* kopiert Csv Frgment ins Clipboard *)
var
  ClpCsv: integer;
  Data: THandle;
  DataPtr: PAnsiChar;
  Err: DWORD;
  AnsiStr: AnsiString;
begin
  ClpCsv := RegisterClipboardFormat('csv');
  if ClpCsv <> 0 then
  begin
    try
      Clipboard.Open;
    except on E:Exception do begin
        Err := GetLastError;
        EError('%s'+CRLF+'%d:%s', [E.Message, Err, SysErrorMessage(Err)]);
      end;
    end;
    try
      {Clipboard.Clear;    nicht wenn nach Html}
      Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_SHARE + GMEM_ZEROINIT,
                          sizeof(Char) * (length(CsvFragment) + 10));
      if Data = 0 then
      begin
        ShowLastError('CopyCsv');
      end else
      begin
        DataPtr := GlobalLock(Data);
        if DataPtr <> nil then
        begin
          AnsiStr := AnsiString(CsvFragment);
          StrPCopy(DataPtr, AnsiStr);
          GlobalUnlock(Data);
          if SetClipboardData(ClpCsv, Data) = 0 then
            ShowLastError('CopyCsv');
        end;
      end;
    finally
      Clipboard.Close;
    end;
  end;
end;

end.
