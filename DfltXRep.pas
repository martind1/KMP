unit DfltXRep;
(* Standard Druckliste erweitert: verwendet Original-DataSet 
   30.10.06 MD  IsLast
   23.05.08 MD  in Kmp aufgenommen (von Dflt)
*)
interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, 
  QRepForm, Lnav_kmp, quickrpt, Qrctrls,
  Qwf_Form, DPos_Kmp, LuDefKmp;

type
  TRepDfltX = class(TQRepForm)
    QuickReport: TQuickRep;
    HdrText: TQRBand;
    FtrPage: TQRBand;
    Line: TQRBand;
    SumText: TQRBand;
    HdrCol: TQRBand;
    ChildCol: TQRChildBand;
    QRDateTime: TQRSysData;
    QRSysData1: TQRSysData;
    QRLabel8: TQRLabel;
    Nav: TLNavigator;
    LaCaption: TQRLabel;
    QRLaName: TQRLabel;
    QRImLogo: TQRImage;
    FtrText: TQRChildBand;
    QRLabel3: TQRLabel;
    QRSysData2: TQRSysData;
    QRSysData3: TQRSysData;
    PageNumber: TQRSysData;
    ExprSum1: TQRExpr;
    LaSum1: TQRLabel;
    LaSum2: TQRLabel;
    ExprSum2: TQRExpr;
    LaSum3: TQRLabel;
    ExprSum3: TQRExpr;
    LaSum4: TQRLabel;
    ExprSum4: TQRExpr;
    gtQRDBText1: TQRDBText;
    ChildBand1: TQRChildBand;
    LDataSource1: TLDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LaCaptionPrint(sender: TObject; var Value: string);
    procedure QRDateTimePrint(sender: TObject; var Value: string);
    procedure HdrTextAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
    procedure QuickReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure SumTextBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure QRSysData2Print(sender: TObject; var Value: String);
    procedure LineBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure ChildBand1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
  private
    { Private declarations }
    PrintSumText: boolean;  //true=Summen drucken (bei 'M' Option)
    StripLine: boolean;     //true=zu breite Texte mit '...' (wenn Mu1 einzeilig sichtbar)
    procedure DfltPrint(sender: TObject; var Value: string);
  public
    { Public declarations }
    Framed: boolean;
    Lined: boolean;
  end;

var
  RepDfltX: TRepDfltX;

implementation
{$R *.DFM}
uses
  Printers,
  Prots, NLnk_Kmp, MuGriKmp, Err__Kmp, KmpResString, Qrext, Psrc_kmp,
  MainFrm, ParaFrm;

procedure TRepDfltX.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TRepDfltX.FormDestroy(Sender: TObject);
begin
  RepDfltX := nil;
end;

procedure TRepDfltX.FormCreate(Sender: TObject);

  procedure AddSum(I: integer);
  var
    S, NextS: string;
  begin
    S := PrnSource.Bemerkung.GetString(Format('Sum%d', [I]), '');
    if S <> '' then
    begin
      PrintSumText := true;
      with TQRExpr(FindComponent('ExprSum' + IntToStr(I))) do
      begin
        Expression := Format('sum(%s.%s)', [QuickReport.DataSet.Name, PStrTok(S, ';', NextS)]);
        Transparent := true;
        Enabled := true;
      end;
      with TQRLabel(FindComponent('LaSum' + IntToStr(I))) do
      begin
        Caption := PStrTok('', ';', NextS);
        Transparent := true;
        Enabled := true;
      end;
    end;
  end;

var
  I, X, DX: integer;
  AField: TField;
  LabelWidth: boolean;
  ANLnk: TNavLink;
  AMu: TMultigrid;
  AForm: TqForm;
  AWidth: integer;
  IsLast: boolean;

begin {FormCreate}
  RepDfltX := self;
  //if Char1(PrnSource.Bemerkung.GetString('Orientation', 'P')) = 'L' then
  if PrnSource.IsLandscape then
    QuickReport.Page.Orientation := poLandscape;
  Framed := PrnSource.Bemerkung.GetBool('Framed', SysParam.DfltRepFramed);
  Lined := PrnSource.Bemerkung.GetBool('Lined', SysParam.DfltRepLined);

  if (PrnSource.MuSelect <> nil) and (PrnSource.MuSelect is TMultiGrid) then
    AMu := TMultiGrid(PrnSource.MuSelect) else   //17.05.12 hier
    AMu := FrmMain.DfltMultiGrid;    //depreciated
  ANLnk := nil;
  try
    ANLnk := AMu.NavLink;    {FrmMain.DfltMultiGrid;             {Frm.LNavigator;}
  except
    EError('Fehler bei FrmMain.DfltMultiGrid', [0]);
  end;
  AForm := ANLnk.Form as TqForm;
  QuickReport.DataSet := ANLnk.DataSet;
  LDataSource1.DataSet := ANLnk.DataSet;  //wg Sql Button

  StripLine := not AMu.DrawMultiLine;
  // QuickReport.Font.Size := AMu.Font.Size; {FrmMain.DfltFrm.Font.Size}
  QuickReport.Font.Size := PrnSource.Bemerkung.GetInteger(SFontSize, AMu.Font.Size);
  { mit Abfrage ausgeben - ISA 23.05.08
  P := Pos('[', AForm.ShortCaption);
  if P > 0 then
    QuickReport.ReportTitle := copy(AForm.ShortCaption, 1, P-1) else
    QuickReport.ReportTitle := AForm.ShortCaption; }
  //07.04.11 Steuerungsmöglichkeit über bemerkung:
  QuickReport.ReportTitle := PrnSource.Bemerkung.GetString(sReportTitle,
                             AForm.ShortCaption);
  for I := 1 to 4 do
    AddSum(I);
  if Framed or Lined then
  begin
    Line.Frame.DrawTop := true;
//    Line.Frame.DrawBottom := true;
//    FtrPage.Frame.DrawTop := false;
//    FtrText.Frame.DrawTop := false;
  end;
  if Framed then
    DX := 3 else
    DX := QuickReport.TextWidth(QuickReport.Font, '0');
  X := 2;

  //Rand ganz links zeichnen
  if Framed {or SysParam.PrintLineNr} then
  begin
    with ChildCol.AddPrintable(TQRShape) as TQRShape do
    begin
      Shape := qrsVertLine;
      Width := DX;
      Top := 0;
      Left := X - DX;
      Height := ChildCol.Height;
    end;
    with Line.AddPrintable(TQRShape) as TQRShape do
    begin
      Shape := qrsVertLine;
      Width := DX;
      Top := 0;
      Left := X - DX;
      Height := Line.Height;
    end;
  end;
  try
    Debug('%d', [AMu.FieldCount]);
  except
    EError('%s: FrmMain.DfltMultiGrid nicht zugeordnet', [QRLaName.Caption]);
  end;

  //Laufende Zeile:
  if SysParam.PrintLineNr then
  begin
    with ChildCol.AddPrintable(TQRLabel) as TQRLabel do
    begin  //waagrecht
      Top := 2;
      Left := X;
      Color := clSilver;
      Caption := SDfltRep_001;  //'Zeile';
      Transparent := true;
      AWidth := Width;
    end;
    with ChildCol.AddPrintable(TQRShape) as TQRShape do
    begin
      Shape := qrsVertLine;
      Width := DX;
      Top := 0;
      Left := X + AWidth;
      Height := ChildCol.Height;
    end;

    with Line.AddPrintable(TQRSysData) as TQRSysData do
    begin
      Top := 1;
      Left := X;
      Autosize := false;
      Alignment := taCenter;  //taRightJustify;
      Data := qrsDetailNo;
      Width := AWidth;
      Transparent := true;
    end;
    with Line.AddPrintable(TQRShape) as TQRShape do
    begin
      Shape := qrsVertLine;
      Width := DX;
      Top := 0;
      Left := X + AWidth;
      Height := Line.Height;
    end;
    X := X + AWidth + DX;
  end;

  //Spalten der MuGrid
  for I:= 0 to AMu.FieldCount - 1 do
  begin
    AField := AMu.Fields[I];  {geht nicht bei Pd}
    IsLast := I >= AMu.FieldCount - 1;
    if AMu.DisplayList.Values[AField.FieldName] = 'S' then
      LNavigator.FormatList.Values[AField.FieldName] := '';   {kein Asw.Text}
    if X + Canvas.TextWidth(AField.DisplayLabel) >= ChildCol.Width then
      break;
    with ChildCol.AddPrintable(TQRLabel) as TQRLabel do
    begin
      Top := 2;
      Left := X;
      Color := clSilver;
      Caption := AField.DisplayLabel;
      if Left + Width > ChildCol.Width - 2 then
      begin
        Autosize := false;
        Width := ChildCol.Width - Left - 2;
        LabelWidth := true;
      end else
      begin
        LabelWidth := false;
        Width := IMax(Width, AMu.ColWidths[I+1]);
        if AField is TNumericField then
          Alignment := taRightJustify else
      end;
      Transparent := true;
      AWidth := Width;
      if IsLast and not (AField is TNumericField) then
      begin
        AWidth := Line.Width - X;    //Bug: DX - md15.05.08
      end;
    end;
    if Framed then
      with ChildCol.AddPrintable(TQRShape) as TQRShape do
      begin
        Shape := qrsVertLine;
        Width := DX;
        Top := 0;
        Left := X + AWidth;
        Height := ChildCol.Height;
      end;
    if (AMu.DisplayList.Values[AField.FieldName] = 'M') then   {Summe}
      with SumText.AddPrintable(TQRExpr) as TQRExpr do
      begin
        PrintSumText := true;
        Top := 5;
        Left := X;
        Autosize := false;
        Width := AWidth;
        Alignment := taRightJustify;
        Expression := 'Sum(' + QuickReport.DataSet.Name + '.' + AField.FieldName + ')';
        Transparent := true;
        Master := QuickReport;
        if AField is TNumericField then
          Mask := TNumericField(AField).DisplayFormat;
        Autosize := true;
        {Frame.DrawTop := true;}
      end;
    with Line.AddPrintable(TQRDBText) as TQRDBText do
    begin
      Top := 1;
      Left := X;
      DataSet := QuickReport.DataSet;
      DataField := AField.FieldName;
      Line.Height := Height + Top;
      if LabelWidth then
      begin
        Autosize := false;
      end else
      begin
        Autosize := false;
      end;
//       Autosize := I = AMu.FieldCount - 1;           {040700}
      Width := AWidth;
      if AField is TNumericField then
        Alignment := taRightJustify else
      begin
        WordWrap := true;
        AutoStretch := true;
      end;
      Transparent := true;
      OnPrint := DfltPrint;
    end;
    if Framed then
      with Line.AddPrintable(TQRShape) as TQRShape do
      begin
        Shape := qrsVertLine;
        Width := DX;
        Top := 0;
        Left := X + AWidth;
        Height := Line.Height;
      end;
    X := X + AWidth + DX;
    if X >= Line.Width then
      break;
  end;
end;

type
  TQRPrintableHack = class(TQRPrintable);
  TQRCustomLabelHack = class(TQRCustomLabel);
  TQRCustomBandHack = class(TQRCustomBand);

procedure TRepDfltX.LineBeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
var
  I, aHeight: integer;
  AQRDBText: TQRDBText;
  L: TStringList;
begin
  { Trick um Zeilen nicht zu trennen: Childband, die auch LinkBand ist, mit der
    gestretchten Höhe versehen, aber nicht drucken }
  L := TStringList.Create;
  try
    aHeight := Line.Height;
    for I := 0 to Line.ControlCount - 1 do
    begin
      if Line.Controls[I] is TQRDBText then
      begin
        AQRDBText := TQRDBText(Line.Controls[I]);
        if AQRDBText.Enabled and (AQRDBText.Alignment = taLeftJustify) then  //keine numerics
        begin
          QRFormatLines(AQRDBText, L);  //Qrext
          aHeight := IMax(aHeight, AQRDBText.Top + L.Count * AQRDBText.Height);
  //        TQRCustomLabelHack(AQRDBText).FormattedLines.Clear;
  //        TQRCustomLabelHack(AQRDBText).FormatLines;
  //        N := TQRCustomLabelHack(AQRDBText).FormattedLines.Count;
  //        aHeight := IMax(aHeight, AQRDBText.Top + N * AQRDBText.Height);
  //        TQRCustomLabelHack(AQRDBText).FormattedLines.Clear;
        end;
      end;
    end;
    ChildBand1.Height := aHeight - Line.Height;
  finally
    L.Free;
  end;
end;

procedure TRepDfltX.ChildBand1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  PrintBand := false;
end;

procedure TRepDfltX.DfltPrint(sender: TObject; var Value: string);
var
  AField: TField;
begin
  if Posi('Neufassung', Value) > 0 then
    Debug0;
  with sender as TQRDBText do
  begin
    if Pos(CRLF, Value) > 0 then
      Value := RemoveTrailCrlf(Value);

    AField := Dataset.FindField(DataField);
    if AField.Tag > 0 then
    begin
      //keine Manipulation bei Auswahlfeldern
    end else

    if (Pos(' ', Value) > 0) or (Pos(CRLF, Value) > 0) or
       ((AField <> nil) and IsBlobField(AField)) then
    begin
      //Height := Line.Height - Top;                 {Trick um Height zu übernehmen}
//      TQRPrintableHack(Sender).QRPrinter.Canvas.Font.Size := 222;
//    TQRCustomBandHack(Line).MakeSpace;
    end else

    if (QuickReport.TextWidth(Font, Value) > Width) and
       not IsBlobField(Dataset.FieldByName(DataField)) and (Pos(CRLF, Value) = 0) and
       StripLine then
    begin
      Value := Value + chr(133);       {...}
      while (QuickReport.TextWidth(Font, Value) > Width) and (length(Value) > 3) do
        System.Delete(Value, length(Value) - 1, 1);
      while (QuickReport.TextWidth(Font, Value) > Width) do
        System.Delete(Value, length(Value), 1);
    end;
  end;
end;

procedure TRepDfltX.LaCaptionPrint(sender: TObject; var Value: string);
begin
  Value := PrnSource.Caption;
end;

procedure TRepDfltX.QRDateTimePrint(sender: TObject; var Value: string);
begin
  Value := Format(Value, [Sysparam.Username]);
  System.Delete(Value, length(Value) - 2, 3);    {Sek weg}
end;

procedure TRepDfltX.HdrTextAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  {FrmMain.PrintVorlage('K', 'D', QuickReport);}
end;

procedure TRepDfltX.QuickReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
//  ChildBand1.Height := 1;
  FrmPara.SetupLogo(QRImLogo, QrLaName, true);
end;

procedure TRepDfltX.SumTextBeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  PrintBand := PrintSumText;
end;

procedure TRepDfltX.QRSysData2Print(sender: TObject; var Value: String);
begin
  if SysParam.PrintLineNr then
    Value := ' ';
end;

//Problem: senkrechter Strich hoch genog auch bei Autostretch
//procedure TRepDflt.SetShapeHeight;
//var
//  I: integer;
//begin
//  for I := 0 to Line.ControlCount - 1 do
//    if Line.Controls[I] is TQRShape then
//      with Line.Controls[I] as TQRShape do
//      begin
//        if Shape = qrsVertLine then
//          Height := Line.Height;
//      end;
//end;

end.
