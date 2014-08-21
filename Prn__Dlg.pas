unit Prn__dlg;
(* Drucklisten Dialog
   29.02.00 MD nichtmodaler Aufruf in LNav mit Dialog:
               1. TDlgPrn.Create
               2. PrnList und Devicelist füllen
               3. Dialog aufrufen
               Dialog: Dialog und Start der Druckliste
               Vorteil: Aufruf Prieview über PollMessage
   10.06.00    Anzahl Kopien
   08.05.09 md wenn in PrnSource kein Druckertyp eingetragen wird Button [Drucker] disabled
*)

interface

uses
{$ifdef WIN32}
  Windows,
{$else}
  WinTypes, WinProcs,
{$endif}
  Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls,
  Qwf_Form, Dialogs, Spin, ExtCtrls, Radios, qSplitter, QSpin_kmp, Lnav_kmp;

type
  TDlgPrn = class(TqForm)
    BtnRun: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PrnList: TListBox;
    qSplitter1: TqSplitter;
    Panel4: TPanel;
    Panel5: TPanel;
    DevList: TListBox;
    Panel6: TPanel;
    BtnScr: TBitBtn;
    BtnCancel: TBitBtn;
    BtnPrn: TBitBtn;
    BtnSetUp: TBitBtn;
    PrnLabel: TLabel;
    Label1: TLabel;
    Panel7: TPanel;
    Panel8: TPanel;
    BtnKopien: TqSpin;
    EdKopien: TEdit;
    Label2: TLabel;
    Panel9: TPanel;
    PanOrientation: TPanel;
    rgOrientation: TRadios;
    Panel11: TPanel;
    Panel12: TPanel;
    rgAktuell: TRadios;
    Nav: TLNavigator;
    procedure PrnListDblClick(Sender: TObject);
    procedure BtnSetUpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PrnListClick(Sender: TObject);
    procedure DevListClick(Sender: TObject);
    procedure BtnScrClick(Sender: TObject);
    procedure BtnRunClick(Sender: TObject);
    procedure BtnPrnClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rgAktuellClick(Sender: TObject);
    procedure EdKopienKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rgOrientationClick(Sender: TObject);
    procedure DevListDblClick(Sender: TObject);
  private
    { Private declarations }
    Preview: boolean;
    procedure CheckKopien;
  public
    { Public declarations }
    procedure Dialog;
  end;

var
  DlgPrn: TDlgPrn;

implementation
{$R *.DFM}
uses
  SysUtils, Messages,
  Printers, Err__Kmp, PSrc_Kmp, Ini__Kmp, Prots, DPos_Kmp, Poll_Kmp,
  GNav_Kmp, KmpResString;


procedure TDlgPrn.FormCreate(Sender: TObject);
begin
  DlgPrn := self;
  GNavigator.TranslateForm(self);
end;

procedure TDlgPrn.FormDestroy(Sender: TObject);
begin
  DlgPrn := nil;
end;

procedure TDlgPrn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDlgPrn.BtnCancelClick(Sender: TObject);
begin
  //Release;
  self.Close;  //Action = free
end;

procedure TDlgPrn.Dialog;
begin
  if PrnList.Items.Count > 0 then
  begin
    PrnList.Selected[0] := true;
    PrnList.ItemIndex := 0;                    {Ersten markieren}
    DevList.ItemIndex := 0;
    CheckKopien;
  end;
  Show;                         {Dialog aufrufen}
end;

procedure TDlgPrn.BtnRunClick(Sender: TObject);
var
  APrnSource: TPrnSource;
  Reports: TValueList;
  I, IReport: integer;
  ProgName: string;
  Running: boolean;
begin
  Running := true;
  try
    {if PrnList.ItemIndex >= 0 then}
    for I := 0 to PrnList.Items.Count - 1 do if PrnList.Selected[I] then
    begin                                                     {gültige Wahl}
      if (I < DevList.Items.Count) then
      begin                         {bist du nicht von der Rechteverwaltung}
        APrnSource := PrnList.Items.Objects[I] as TPrnSource; {Printer auf PrnSource zuweisen}
        if APrnSource.IsFiller then
        begin
          Running := false;
        end else
        begin
          //alle drucken und noch Zeilen markiert: Markierung aufheben:
          if (APrnSource.MuSelect <> nil) and (rgAktuell.ItemIndex = 2) and
             (APrnSource.MuSelect.SelectedRows.Count > 0) then
            APrnSource.MuSelect.SelectedRows.Clear;  //21.09.12 erst hier
          APrnSource.Preview := Preview;
          APrnSource.Kopien := StrToIntDef(EdKopien.Text, 1);
          APrnSource.DoRun;                      {und aufrufen über PrnSource}
        end;
      end else                                             {externe Reports}
      begin                     {Index von externen selektierter berechnen:}
        IReport := I - DevList.Items.Count;
        Reports := PrnList.Items.Objects[I] as TValueList;
        ProgName := Reports.Value(IReport);                 {rechte Seite holen}
        WinExecAndWait(ProgName, SW_RESTORE);                         {Aufrufen}
      end;
    end;
  finally
    if Running then
      DlgPrn.Close;  //bis 04.04.13: Release;
  end;
end;

procedure TDlgPrn.BtnScrClick(Sender: TObject);
begin
  Preview := true;                                          {Seitenvorschau}
  BtnScr.Enabled := false;
  PollKmp.PollMessage(Handle, WM_COMMAND, 0, BtnRun.Handle); {außerhalb Polling}
end;

procedure TDlgPrn.BtnPrnClick(Sender: TObject);
begin
  Preview := false;                                            {auf Drucker}
  BtnPrn.Enabled := false;
  PollKmp.PollMessage(Handle, WM_COMMAND, 0, BtnRun.Handle); {außerhalb Polling}
end;

procedure TDlgPrn.PrnListDblClick(Sender: TObject);
begin
  if SysParam.Preview then
    BtnScr.Click else
    BtnPrn.Click;
end;

procedure TDlgPrn.DevListDblClick(Sender: TObject);
begin
  if BtnSetUp.Enabled then
    BtnSetUp.Click;
end;

procedure TDlgPrn.BtnSetUpClick(Sender: TObject);
var
  APrnSource: TPrnSource;
  ADruckerTyp, PrinterName, PrinterFont: string;
  PrinterIndex: integer;
  HasChanged: boolean;
  I: integer;
begin
  try
    if IniKmp = nil then
      EError(SPrn_Dlg_001, [0]);	// '"IniKmp" nicht aktiv.'
    if PrnList.ItemIndex >= 0 then
    begin
      APrnSource := PrnList.Items.Objects[PrnList.ItemIndex] as TPrnSource;
      HasChanged := true;
      APrnSource.SetupPrn(HasChanged);
      if HasChanged then
      begin
        ADruckerTyp := APrnSource.DruckerTyp;
        //SetupPrinter( ADruckerTyp);
        PrinterIndex := SysParam.GetPrinterIndex( ADruckerTyp, PrinterFont);
        if PrinterIndex < 0 then
          PrinterName := SPrn_Dlg_002 else	// 'Standarddrucker'
          PrinterName := Printer.Printers[PrinterIndex];
        if PrinterFont <> '' then
          PrinterName := PrinterName + ',' + PrinterFont;
        for I := 0 to DevList.Items.Count - 1 do
        begin
          APrnSource := PrnList.Items.Objects[I] as TPrnSource;
          if APrnSource.DruckerTyp = ADruckerTyp then
            DevList.Items.Strings[I] := PrinterName;
        end;
        DevList.ItemIndex := PrnList.ItemIndex;
      end;
    end;
  except on E:Exception do
    EProt(self, E, SPrn_Dlg_003, [0]);		// 'Einrichten'
  end;
end;

procedure TDlgPrn.PrnListClick(Sender: TObject);
begin
  if PrnList.SelCount > 1 then
  begin
    DevList.ItemIndex := -1;
    Exit;
  end;
  DevList.ItemIndex := PrnList.ItemIndex;
  CheckKopien;
  SMess('%s', [PrnList.Items[PrnList.ItemIndex]]);
end;

procedure TDlgPrn.DevListClick(Sender: TObject);
var
  I: integer;
begin
  //PrnList.ItemIndex := DevList.ItemIndex;
  for I := 0 to DevList.Items.Count - 1 do   //MultiSelect
    PrnList.Selected[I] := DevList.ItemIndex = I;
  CheckKopien;
  SMess('%s', [PrnList.Items[PrnList.ItemIndex]]);
end;

procedure TDlgPrn.CheckKopien;
var
  APrnSource: TPrnSource;
begin
  APrnSource := nil;
  if PrnList.ItemIndex >= 0 then
  begin
    APrnSource := PrnList.Items.Objects[PrnList.ItemIndex] as TPrnSource;
    //SetEdNum(EdKopien, IntToStr(APrnSource.Kopien));
    //EdKopien.Text := IntToStr(APrnSource.Kopien);
    BtnKopien.Value := APrnSource.Kopien;

    rgAktuell.ItemIndex := -1;  //Aufruf von rgAktuellClick erzwingen
    if (APrnSource.MuSelect <> nil) and
       (APrnSource.MuSelect.SelectedRows.Count > 0) then
      rgAktuell.ItemIndex := 1 else
    if APrnSource.OneRecord or (psDisableAll in APrnSource.Options) then
      rgAktuell.ItemIndex := 0 else
      rgAktuell.ItemIndex := 2;

//    if APrnSource.QRepKurz = 'DFLT' then  //der Standardausdruck hat immer diese Option - 14.05.08
//      APrnSource.Options := APrnSource.Options + [psOrientation];

    PanOrientation.Visible := psOrientation in APrnSource.Options;
    if PanOrientation.Visible then
    begin
      if APrnSource.IsLandscape then
        rgOrientation.ItemIndex := 1 else
        rgOrientation.ItemIndex := 0;
    end;

  end;
  BtnScr.Enabled := (APrnSource <> nil) and not APrnSource.IsFiller;
  BtnPrn.Enabled := BtnScr.Enabled and
                    ((APrnSource.DruckerTyp <> '') or  //08.05.09 Drucker nur wenn in PrnSource ein Druckertyp eingetragen
                     (APrnSource.ClassType <> TPrnSource)); //16.02.10 LlPrn nicht
  BtnSetUp.Enabled := BtnScr.Enabled;
end;

procedure TDlgPrn.rgOrientationClick(Sender: TObject);
var
  APrnSource: TPrnSource;
begin
  if PrnList.ItemIndex >= 0 then
  begin
    APrnSource := PrnList.Items.Objects[PrnList.ItemIndex] as TPrnSource;
    APrnSource.IsLandScape := rgOrientation.ItemIndex = 1;
  end;
end;

procedure TDlgPrn.rgAktuellClick(Sender: TObject);
var
  APrnSource: TPrnSource;
begin
  if PrnList.ItemIndex >= 0 then
  begin
    APrnSource := PrnList.Items.Objects[PrnList.ItemIndex] as TPrnSource;
    case rgAktuell.ItemIndex of
      0: APrnSource.OneRecord := true;
      1: if (APrnSource.MuSelect <> nil) and
            (APrnSource.MuSelect.SelectedRows.Count > 0) then
           APrnSource.OneRecord := false else
           rgAktuell.ItemIndex := 0;  //markierte geht nicht. Auf 'aktueller' setzen.
           //21.09.12 weg rgAktuell.ItemIndex := 2;  //markierte geht nicht. Auf 'alle' setzen.
      2: begin
           if not (psDisableAll in APrnSource.Options) then
             APrnSource.OneRecord := false else
             rgAktuell.ItemIndex := 0;  //alle nicht erlaubt. Auf 'aktueller' setzen.
//           if (APrnSource.MuSelect <> nil) and
//              (APrnSource.MuSelect.SelectedRows.Count > 0) then
//           begin
//              //21.09.12 erst bei Start: APrnSource.MuSelect.SelectedRows.Clear;
//              //rgAktuell.ItemIndex := 2;
//           end;
         end;
    end;
  end;
end;

procedure TDlgPrn.EdKopienKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_UP then
    BtnKopien.Value := BtnKopien.Value + 1;
  if Key = VK_DOWN then
    BtnKopien.Value := BtnKopien.Value - 1;
end;

end.
