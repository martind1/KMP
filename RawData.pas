unit RawData;

interface

  procedure WriteRawStringToPrinter(S: String);

implementation
uses
{$ifdef WIN32}
  Windows,  WinSpool,
{$else}
  WinTypes,
{$endif}
  SysUtils, Printers, Forms,
  Prots, Err__Kmp, QrPreDlg;

procedure WriteRawStringToPrinter(S: String);
(* Schreibt Text direkt in Printerspooler. nur WIN32 *)
{$ifdef WIN32}
var
  PrinterName: String;
  Handle: THandle;
  N: DWORD;
  DocInfo1: TDocInfo1;
  function GetPrinterName: string;
  var
    ADevice: array[0..cchDeviceName] of Char;
    ADriver, APort: array[0..MAX_PATH] of Char;
    ADeviceMode: THandle;
  begin
    Printer.GetPrinter(ADevice, ADriver, APort, ADeviceMode); {Globale Variable Printer auslesen}
    if ADeviceMode = 0 then                     {ADeviceMode Druckerdatenstruktur}
      Printer.GetPrinter(ADevice, ADriver, APort, ADeviceMode);
    if StrLen(ADriver) = 0 then
    begin
      GetProfileString('Devices', ADevice, '', ADriver, MAX_PATH);
      ADriver[pos(',', ADriver) - 1] := #0;
    end;
    result := StrPas(ADevice);
  end;
begin
  if DlgQRPreview = nil then {nicht bei Seitenansicht}
  try
    PrinterName := GetPrinterName;
    if not OpenPrinter(PChar(PrinterName), Handle, nil) then
      EError('%s: Open Error %d', [Printername, GetLastError]);
    with DocInfo1 do
    begin
      pDocName := PChar('Printer Data');
      pOutputFile := nil;
      pDataType := 'RAW';
    end;
    {direkter Zugriff auf Print Spooler:}
    if StartDocPrinter(Handle, 1, @DocInfo1) = 0 then EError('%s: StartDoc Error %d', [Printername, GetLastError]);
    if not StartPagePrinter(Handle) then EError('%s: StartPage Error %d', [Printername, GetLastError]);
    if not WritePrinter(Handle, PChar(S), Length(S), N) then EError('%s: Write Error %d', [Printername, GetLastError]);
    if not EndPagePrinter(Handle) then EError('%s: Endpage Error %d', [Printername, GetLastError]);
    if not EndDocPrinter(Handle) then EError('%s: EndDoc Error %d', [Printername, GetLastError]);
    if not ClosePrinter(Handle) then EError('%s: Close Error %d', [Printername, GetLastError]);
  except on E:Exception do
    EProt(Application, E, 'RawData', [0]);
  end;
{$else}
begin
{$endif}
end;

(*** Für FrmMain: ***********************************************************)
(*
function TFrmMain.GetVorlage(Typ, Sprache: string): string;
begin
  case char1(Typ) of
    'L': if Sprache = 'D' then            {(L)ieferschein}
           Result := PrgParam.VorlD else
           Result := PrgParam.VorlE;
  else {'K':}
    Result := PrgParam.VorlLFSV;     {(K)opf der Drucklisten}
  end;
end;

procedure TFrmMain.PrintVorlage32(Typ, Sprache: string);
var
  S: string;
begin
{$ifdef WIN32}
  S := GetVorlage(Typ, Sprache);
  if PosI('.bmp', S) > 0 then   {Bitmap bereits geladen}
    Exit;
  WriteRawStringToPrinter(S);
{$else}
{$endif}
end;

procedure TFrmMain.PrintVorlage(Typ, Sprache: string; QR: TQuickRep);
var
  S: string;
  ABitmap: TBitmap;
begin
  S := GetVorlage(Typ, Sprache);
  if PosI('.bmp', S) > 0 then   {Bitmap laden}
  try
    ABitmap := TBitmap.Create;
    if (Pos('\', S) <= 0) or         {Bitmap im Verzeichnis der .EXE}
       not FileExists(S) then
      S := ExtractFilePath(Application.Exename) + S;
    try
      ABitmap.LoadFromFile(S);
      QR.QRPrinter.Canvas.Draw(1, 1, ABitmap);
    except on E:Exception do
      Prot0('FrmMain.PrintVorlage(%s,%s,%s):%s', [Typ, Sprache, S, E.Message]);
    end;
  finally
    ABitmap.Free;
{$ifdef WIN32}
  end;
{$else}
  end else
  if S <> '' then
    QR.QRPrinter.Canvas.TextOut(1, 1, Char(27) + S); {Sequenz für HP Laser}
{$endif}
end;
*)



(*** Delphi1 Testmethode ****************************************************)
(*
procedure EscapeTest16;
var
  InData: packed record
             L: word;
             D: array[0..255] of char;
           end;
  EscapeFunc: word;
  I1: integer;
begin                                                        {OK unter Delphi1}
  StrCopy(InData.D, 'Rawdata');
  InData.L := StrLen(InData.D);
  EscapeFunc := PASSTHROUGH;
  I1 := Escape(QuickReport.QrPrinter.Canvas.Handle, QUERYESCSUPPORT,
               SizeOf(EscapeFunc), @EscapeFunc, nil);
  I1 := Escape(QuickReport.QrPrinter.Canvas.Handle, PASSTHROUGH, 0, @InData, nil);
end;
*)


end.
