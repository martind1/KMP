unit Tools;
(* Hilfsobjekte und Funktionen

   Autor: Martin Dambach
   Letzte Änderung:
   09.10.97     Erstellen
   07.10.10     InputPasswort
   -------------------------------------
   - TDevice: Gerät mit Formular und Daten von BEIN/DEVI

*)

interface

uses
{$ifdef WIN32}
  Windows,  WinSpool,
{$else}
  WinTypes, WinProcs,
{$endif}
  Classes, Grids,
  QuickRpt,
  CPro_Kmp, FaWa_Kmp, Qwf_Form;

type
  (* TDevice - Gerät mit Formular und Daten *)
  TDevice = class( TObject)
  public
    Nr: string;
    Name: string;
    Params: string;
    Options: string;
    ModulCode: string;
    Transportart: char;      //L;B;X
    Verpackart: char;      //L;V;null
    Text: TStringList;
    ID: longint;
    Device: TComProt;
    Form: TqForm;
    function FaWa: TFaWaKmp;
    constructor Create( DeviceNr: string);
    destructor Destroy; override;
  end;

  (* Drucker *)
  procedure FillDruckerGrid( AStringGrid: TStringGrid);
  procedure CheckRawData(S: string; P: PChar; var N: integer);
  procedure PrintRawData(QR: TQuickRep; S: string);
  function WriteRawData(QR: TQuickRep; P: PChar; N: integer): DWORD;

  function InputPassword(const ACaption, APrompt: string; var Value: string): Boolean;
  //wie InputQuery1 aber mit PassworChar='*'

implementation
uses
  SysUtils, Printers, QrPrntr,
  Forms, StdCtrls, Graphics, Consts, Controls, Dialogs,
  Prots, Err__Kmp, KmpResString;

(*** TDevice *****************************************************************)

constructor TDevice.Create( DeviceNr: string);
begin
  Nr := DeviceNr;
  Text := TStringList.Create;
end;

destructor TDevice.Destroy;
begin
  Text.Free;
  inherited Destroy;
end;

function TDevice.FaWa: TFaWaKmp;
begin
  if (Device <> nil) and (Device is TFaWaKmp) then
    result := Device as TFaWaKmp else
    result := nil;
end;

(*** Drucker ******************************************************************)

procedure FillDruckerGrid( AStringGrid: TStringGrid);
var
  I, IRow, APrinterIndex: integer;
  APrinterName: string;
begin
  with AStringGrid do
  begin
    Cells[ 0, 0] := STools_001;		//  'Kategorie'
    Cells[ 1, 0] := 'Idx';
    Cells[ 2, 0] := STools_002;		// 'Drucker'
    RowCount := SysParam.Drucker.Count + 1;
    for I := 0 to SysParam.Drucker.Count - 1 do
    begin
      IRow := I + 1;
      Cells[ 0, IRow] := SysParam.Drucker.Param(I);
      Cells[ 1, IRow] := SysParam.Drucker.Value(I);
      try    APrinterIndex := StrToIntTol( SysParam.Drucker.Value(I));
      except APrinterIndex := -1;
      end;
      if (APrinterIndex < 0) or (APrinterIndex >= Printer.Printers.Count) then
      begin
        APrinterName := STools_003;	// 'Standarddrucker'
      end else
        APrinterName := Printer.Printers.Strings[APrinterIndex];
      Cells[ 2, IRow] := APrinterName;
    end;
  end;
end;

(*** Druckertreiber: direkt drucken *******************************************)

procedure CheckRawData(S: string; P: PChar; var N: integer);
(* analysiert und kopiert S nach P.
   Max.Soll- und IstAnzahl in N.
   P kann nil sein zum Testen.
   Syntax von S: \xx = Hexwert \\ = '\' *)
var
  I, MaxN: integer;
  Step: byte;
  procedure Add(C: char);
  begin
    if (P <> nil) and (N < MaxN) then
      P[N] := C;
    Inc(N);
  end;
begin
  MaxN := N;
  N := 0;
  Step := 0;
  for I := 1 to length(S) do
  begin
    case Step of
      0: if S[I] = '\' then
           Step := 1 else
           Add(S[I]);
      1: if S[I] = '\' then
         begin
           Add('\');
           Step := 0;
         end else
           Step := 2;
      2: try
           Add(char(StrToInt('$' + copy(S, I - 1, 2))));
           Step := 0;
         except on E:Exception do
           EError('CheckRawData(%s) failed at %d(%s)' + CRLF + '%s',
           [S, I, S[I], E.Message]);
         end;
    end;
  end;
end;

procedure PrintRawData(QR: TQuickRep; S: string);
(* druckt direkt auf aktuellen Printer unter Umgehung des Druckertreibers *)
var
  P: array[0..750] of char;
  N: integer;
begin
  N := sizeof(P);
  CheckRawData(S, P, N);
  WriteRawData(QR, P, N);
end;

{$ifdef WIN32}
function WriteRawData(QR: TQuickRep; P: PChar; N: integer): DWORD;
var                                {ergibt Anzahl tatsächlich geschr. Bytes}
  PrinterName: String;
  Handle: THandle;
  {N: DWORD;}
  DocInfo1: TDocInfo1;

  function GetPrinterName: string;
  var
    pDevice : pChar;
    pDriver : pChar;
    pPort   : pChar;
    hDMode : THandle;
  begin
    GetMem(pDevice, cchDeviceName);
    GetMem(pDriver, MAX_PATH);
    GetMem(pPort, MAX_PATH);
    Printer.GetPrinter(pDevice, pDriver, pPort, hDMode);
    if lStrLen(pDriver) = 0 then
    begin
      GetProfileString('Devices', pDevice, '', pDriver, MAX_PATH);
      pDriver[pos(',', pDriver) - 1] := #0;
    end;
    result := StrPas(pDevice);
    FreeMem(pDevice, cchDeviceName);
    FreeMem(pDriver, MAX_PATH);
    FreeMem(pPort, MAX_PATH);
  end; (* GetPrinterName *)

begin (* WriteRawData *)
  PrinterName := GetPrinterName;
  if not OpenPrinter(PChar(PrinterName), Handle, nil) then
    EError('%s: Open Error %d', [Printername, GetLastError]);
  with DocInfo1 do
  begin
    pDocName := PChar('test doc');
    pOutputFile := nil;
    pDataType := 'RAW';
  end;
  if StartDocPrinter(Handle, 1, @DocInfo1) = 0 then
    EError('%s: StartDoc Error %d', [Printername, GetLastError]);
  if not StartPagePrinter(Handle) then
    EError('%s: StartPage Error %d', [Printername, GetLastError]);

  if not WritePrinter(Handle, P, N, result) then
    EError('%s: Write Error %d', [Printername, GetLastError]);

  if not EndPagePrinter(Handle) then
    EError('%s: Endpage Error %d', [Printername, GetLastError]);
  if not EndDocPrinter(Handle) then
    EError('%s: EndDoc Error %d', [Printername, GetLastError]);
  if not ClosePrinter(Handle) then
    EError('%s: Close Error %d', [Printername, GetLastError]);
end;

{$else}
function WriteRawData(QR: TQuickRep; P: PChar; N: integer): integer;
var                                                          {OK unter Delphi16}
  InData: packed record
             L: word;
             D: array[0..255] of char;
           end;
  EscapeFunc: word;
  I1: integer;
  function SP_Str(SP_Error: integer): string;
  begin
    {
    if SP_Error = SP_ERROR then
      result := 'Allgemeiner Fehler.' else
    if SP_Error = SP_OUTOFDISK then
      result := 'Speicherplatz auf der Diskette bzw. Platte nicht ausreichend für Spooling. ' +
        'Zusätzlicher Speicherplatz kann nicht verfügbar gemacht werden.' else
    if SP_Error = SP_OUTOFMEMORY then
      result := 'Arbeitsspeicher ist für Spooling nicht ausreichend.' else
    if SP_Error = SP_USERABORT then
      result := 'Der Benutzer hat den Druckauftrag mit Hilfe des Druck-Managers abgebrochen.' else
      result := 'NotReported';
    }
    if SP_Error = SP_ERROR then
      result := STools_004 else
    if SP_Error = SP_OUTOFDISK then
      result := STools_005 +
        STools_006 else
    if SP_Error = SP_OUTOFMEMORY then
      result := STools_007 else
    if SP_Error = SP_USERABORT then
      result := STools_008 else
      result := 'NotReported';
  end; (* SP_Str *)

begin  (* WriteRawData *)
  InData.L := IMin(N, sizeof(InData.D));
  StrMove(InData.D, P, InData.L);
  EscapeFunc := PASSTHROUGH;
  I1 := Escape(QR.QrPrinter.Canvas.Handle, QUERYESCSUPPORT,
               SizeOf(EscapeFunc), @EscapeFunc, nil);
  if I1 = 0 then
    EError(STools_009, [I1]);		// 'Fehler %d bei RawData.QUERYESCSUPPORT'
  I1 := Escape(QR.QrPrinter.Canvas.Handle, PASSTHROUGH, 0, @InData, nil);
  if I1 < 0 then
    EError(STools_010, [I1, SP_str(I1)]);	// 'Fehler %d bei RawData.PASSTHROUGH: %s'
end;
{$endif}

(*** Passwort eingeben ********************************************************)

function InputPassword(const ACaption, APrompt: string; var Value: string): Boolean;
//wie InputQuery1 aber mit PassworChar='*'
//Delphi XE2 kann jetzt Passwort: chr(1)
begin
  Result := InputQuery(ACaption, chr(1)+APrompt, Value);
end;

end.
