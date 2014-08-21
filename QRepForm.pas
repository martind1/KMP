unit QRepForm;
(* Quickreport Formular
   Autor: Martin Dambach
   Letzte Änderung:
   22.12.96     Erstellen
   07.08.97     Composite
   13.09.98     GetAusw ergibt nil wenn keine Ausw (und keine Exception)
   15.12.99     Init: Öffnet LuDefs mit AutoOpen=true
   18.04.00     Neu: Loaded statt Init
   08.05.00     auch für WRep (Word Reporting)
                PrintIfEmpty
   --------------------------------
   - Zugriff auf Quickreport
   - für PrnSource
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, QuickRpt,
  LNav_Kmp, LuEdiKmp, PSrc_Kmp, Qwf_Form, Ausw_Kmp, Prots, WRep_Kmp;

type
  TQRepForm = class(TqForm)
  private
    { Private-Deklarationen }
    function GetQuickReport: TQuickRep;
    function GetCompositeReport: TQRCompositeReport;
    function GetWRep: TWRep;
    function GetAusw: TAusw;
    function GetPrnSource: TPrnSource;
  protected
    { Protected-Deklarationen }
    {procedure Destroy; override;}
  public
    { Public-Deklarationen }
    QRepKurz: string;
    procedure Loaded; override;
    destructor Destroy; override;
    procedure SetPrinterFonts(FontLine: string);
    function PrintIfEmpty: boolean;

    property PrnSource: TPrnSource read GetPrnSource;
    property QuickReport: TQuickRep read GetQuickReport;
    property CompositeReport: TQRCompositeReport read GetCompositeReport;
    property Ausw: TAusw read GetAusw;
    property WRep: TWRep read GetWRep;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  ExtCtrls, QrCtrls,
  GNav_Kmp, LuDefKmp, Err__Kmp, NStr_Kmp, Tools;

procedure TQRepForm.Loaded;
(* setzt LuDefs mit AutoOpen auf NoOpen=false damit sie öffnen *)
var
  I: integer;
  ALookUpDef: TLookUpDef;
begin
  for I:= 0 to ComponentCount-1 do
    if Components[i] is TLookUpDef then
    begin
      ALookUpDef := Components[i] as TLookUpDef;
      if ALookUpDef.AutoOpen then
        ALookUpDef.NoOpen := false;
    end;
  inherited Loaded;         {TqForm.Loaded}
end;

destructor TQRepForm.Destroy;
begin
  if GNavigator <> nil then
    GNavigator.EndQRepForm( self, QRepKurz);
  Kurz := '';                                              {damit kein EndForm}
  inherited Destroy;
end;

function TQRepForm.GetCompositeReport: TQRCompositeReport;
var
  I: integer;
begin
  for I:= 0 to ComponentCount-1 do
    if Components[i] is TQRCompositeReport then
    begin
      result := Components[i] as TQRCompositeReport;
      exit;
    end;
  result := nil;        {kein Fehler}
end;

function TQRepForm.GetAusw: TAusw;
begin
  if (PrnSource <> nil) and (PrnSource is TAusw) then
    result := PrnSource as TAusw else
    result := nil;     {EError('Ausw: nicht verfügbar (%s)',[Caption]);}
end;

function TQRepForm.GetPrnSource: TPrnSource;
begin
  if GNavigator <> nil then
    result := GNavigator.GetPrnSource(Kurz) as TPrnSource else
    result := nil;
end;

function TQRepForm.GetQuickReport: TQuickRep;
var
  I: integer;
begin
  result := nil;
  for I:= 0 to ComponentCount-1 do
    if Components[i] is TQuickRep then
    begin
      result := Components[i] as TQuickRep;
      exit;
    end;
  {raise Exception.CreateFmt('%s:Quickreport nicht gefunden',[Caption]);}
end;

procedure TQRepForm.SetPrinterFonts(FontLine: string);
(* Fontline enthält die Namen bis zu 3 Druckerfonts, mit '|' getrennt
   1.Font = Alle Felder mit ParentFont=true
   2.Font = Alle Felder mit Tag and $1
   3.Font = Alle Felder mit Tag and $2
*)
var
  PrinterFont, PrinterFont1, PrinterFont2, NextS: string;
  I: integer;
begin
  if FontLine <> '' then
  begin
    PrinterFont := Trim(PStrTok(FontLine, '|', NextS));       {ohne Leerzeichen}
    PrinterFont1 := Trim(PStrTok('', '|', NextS));
    PrinterFont2 := Trim(PStrTok('', '|', NextS));
    if PrinterFont1 = '' then
      PrinterFont1 := PrinterFont;
    if PrinterFont2 = '' then
      PrinterFont2 := PrinterFont1;
    for I := 0 to ComponentCount - 1 do
    begin
      if Components[I] is TQuickRep then
      begin
        if PrinterFont <> '' then
          TQuickRep(Components[I]).Font.Name := PrinterFont;
      end else
      if Components[I] is TQrCustomLabel then
      begin
        if (PrinterFont1 <> '') and BITIS(Components[I].Tag, 1) then
          TQrCustomLabel(Components[i]).Font.Name := PrinterFont1 else
        if (PrinterFont2 <> '') and BITIS(Components[I].Tag, 2) then
          TQrCustomLabel(Components[i]).Font.Name := PrinterFont2;
      end;
    end;
  end;
end;

(*** WRep *********************************************************************)

function TQRepForm.PrintIfEmpty: boolean;
begin
  if QuickReport <> nil then
    result := QuickReport.PrintIfEmpty else
    result := true;    {WRep}
end;

function TQRepForm.GetWRep: TWRep;
var
  I: integer;
begin
  for I:= 0 to ComponentCount-1 do
    if Components[i] is TWRep then
    begin
      result := Components[i] as TWRep;
      exit;
    end;
  result := nil;        {kein Fehler}
end;

end.
