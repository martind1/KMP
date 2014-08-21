unit PrnFoDlg;
(* Dialog um EDrucker und Druckerschriftart zuzuordnen
   07.11.98     geplant: bis zu 3  Druckerschriftarten, mit '|' getrennt
   06.08.08 MD  FontSize
   09.09.10 md  Druckertyp im Titel anzeigen
*)
interface

uses
{$ifdef WIN32}
  ComCtrls,
{$else}
{$endif}
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, TabNotBk, SysUtils, Mask, DBCtrls, DB,  Uni, DBAccess, MemDS, ExtCtrls;

type
  (* TDlgErr Dialogbox *)
  TDlgPrnFont = class(TForm)
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    BtnEinrichten: TBitBtn;
    Label1: TLabel;
    cobPrinter: TComboBox;
    cobPrinterFonts: TComboBox;
    Label2: TLabel;
    Bevel1: TBevel;
    LaFontSize: TLabel;
    cobFontSize: TComboBox;
    procedure cobPrinterExit(Sender: TObject);
    procedure cobPrinterEnter(Sender: TObject);
    procedure cobPrinterChange(Sender: TObject);
    procedure BtnEinrichtenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PrinterChanged: boolean;
    class function Execute(ADruckerTyp: string): integer; overload;
    class function Execute(ADruckerTyp: string; var AFontSize: integer): integer; overload;
  end;

var
  DlgPrnFont: TDlgPrnFont;

implementation
{$R *.DFM}
uses
  Printers,
  Asws_Kmp, Prots, Err__Kmp, GNav_Kmp, KmpResString;

class function TDlgPrnFont.Execute(ADruckerTyp: string): integer;
var
  FS: integer;
begin
  FS := 0;
  Result := TDlgPrnFont.Execute(ADruckerTyp, FS);
end;

class function TDlgPrnFont.Execute(ADruckerTyp: string; var AFontSize: integer): integer;
{Dialog zum Druckereinrichten. Ergibt PrinterIndex}
var
  Btn: word;
  APrinterFont: string;
begin
  result := SysParam.GetPrinterIndex(ADruckerTyp, APrinterFont);
  with TDlgPrnFont.Create(Application) do
  try
    Caption := LongCaption(Caption, ADruckerTyp);
    cobPrinter.Items.Assign(Printer.Printers);
    cobPrinter.Items.Insert(0, SDefaultPrinter);
    cobPrinter.ItemIndex := result + 1;
    cobPrinter.ItemIndex := IMax(0, cobPrinter.ItemIndex);
    PrinterChanged := true;
    cobPrinterExit(Application);
    if APrinterFont <> '' then
      cobPrinterFonts.ItemIndex := cobPrinterFonts.Items.IndexOf(APrinterFont);
    // 06.08.08
    LaFontSize.Visible := AFontSize <> 0;
    CobFontSize.Visible := AFontSize <> 0;
    CobFontSize.Text := IntToStr(AFontSize);

    Btn := ShowModal;
    if Btn = mrOk then
    begin
      result := cobPrinter.ItemIndex - 1;
      if cobPrinterFonts.ItemIndex > 0 then
        APrinterFont := cobPrinterFonts.Items.Strings[cobPrinterFonts.ItemIndex]
      else
        APrinterFont := '';
      SysParam.SetPrinterIndex(ADruckerTyp, result, APrinterFont);

      AFontSize := StrToIntTol(cobFontSize.Text);
    end;
  finally
    Release; //Free;
  end;
end;

procedure TDlgPrnFont.FormCreate(Sender: TObject);
begin
  DlgPrnFont := self;
  GNavigator.TranslateForm(self);
end;

procedure TDlgPrnFont.FormDestroy(Sender: TObject);
begin
  DlgPrnFont := nil;
end;

procedure TDlgPrnFont.cobPrinterExit(Sender: TObject);
var
  OldPrinterIndex: integer;
begin
  if PrinterChanged and (cobPrinter.ItemIndex >= 0) then
  begin
    OldPrinterIndex := Printer.PrinterIndex;
    Printer.PrinterIndex := cobPrinter.ItemIndex - 1;
    try
      COBPrinterFonts.Items.Assign(Printer.Fonts);
    except on E:Exception do begin   //ausgewählter Drucker ist ungültig. State=psNoHandle
        EProt(self, E, 'cobPrinterExit', [0]);
        COBPrinterFonts.Items.Clear;
      end;
    end;    
    COBPrinterFonts.Items.Insert(0, SWindows);
    COBPrinterFonts.ItemIndex := 0;
    Printer.PrinterIndex := OldPrinterIndex;
  end;
end;

procedure TDlgPrnFont.cobPrinterEnter(Sender: TObject);
begin
  PrinterChanged := false;
end;

procedure TDlgPrnFont.cobPrinterChange(Sender: TObject);
begin
  PrinterChanged := true;
end;

procedure TDlgPrnFont.BtnEinrichtenClick(Sender: TObject);
//var
//  ADeviceMode: THandle;
//  ADevice, ADriver, APort: array[0..80] of char;
//  ADriverHandle: THandle;
begin
  (* Druckertreiber Dialog, und speichern
{$ifdef WIN32}
{$else}
  Printer.PrinterIndex := cobPrinter.ItemIndex - 1;
  Printer.GetPrinter(ADevice, ADriver, APort, ADeviceMode);
  ADriverHandle := LoadLibrary(ADriver);
  L := ExtDeviceMode(Application.Handle, ADriverHandle,
         ADevModeOutput, ADevice, APort,
         ADevModeInput, nil, 0);
{$endif}
  *)
end;

end.
