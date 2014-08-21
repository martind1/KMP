unit Dfltrep;
(* Standard Druckliste
   04.07.00 md rechte Spalte hat AutoSize
   30.10.06 MD IsLast
   03.07.07 MD Lu.CalcCache
   21.03.08 MD SysParam.PrintLineNr (QUGL)
   23.03.08 MD StripLine (war dflt true)
   16.05.08 MD ISA: Lined (nur waagr. Linien); keinen Seitenwechsel innerhalb Zeilen
   27.11.09 MD PrnSource.MuSelect verwenden (statt FrmMain.DfltMultiGrid)
   23.02.11 md  :Params kopieren
   23.04.12 md  großes und breites Textfeld in
*)
interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, Uni, DBAccess, MemDS, 
  QRepForm, Lnav_kmp, quickrpt, Qrctrls,
  Qwf_Form, DPos_Kmp, LuDefKmp, MuGriKmp, UQue_Kmp;

type
  TRepDflt = class(TQRepForm)
    QuickReport: TQuickRep;
    HdrText: TQRBand;
    FtrPage: TQRBand;
    Line: TQRBand;
    SumText: TQRBand;
    DataSource1: TLDataSource;
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
    Query1: TuQuery;
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
    procedure Query1BeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
    PrintSumText: boolean;  //true=Summen drucken (bei 'M' Option)
    StripLine: boolean;     //true=zu breite Texte mit '...' (wenn Mu1 einzeilig sichtbar)
    FontZoom: double;
    AMu: TMultigrid;       //auch für DfltPrint
    DelphiQRDateTime: string;
    procedure DfltPrint(sender: TObject; var Value: string);
    procedure CheckCalcCache(AForm: TqForm; ACalcList: TValueList);
    procedure InsertLuDef(FromLuDef: TLookupDef; LuName: string);
  public
    { Public declarations }
    Framed: boolean;
    Lined: boolean;
  end;

var
  RepDflt: TRepDflt;

implementation
{$R *.DFM}
uses
  Printers,
  Prots, NLnk_Kmp, Err__Kmp, KmpResString, Qrext, Psrc_kmp,
  MainFrm, ParaFrm;

procedure TRepDflt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TRepDflt.FormDestroy(Sender: TObject);
begin
  RepDflt := nil;
end;

procedure TRepDflt.InsertLuDef(FromLuDef: TLookupDef; LuName: string);
var
  Lu: TLookupDef;
  Qu: TUQuery;
begin
  if FromLuDef = nil then
  begin
    Prot0('%s WARN InsertLuDef FromLuDef=nil', [self.Caption]);
    Exit;
  end;
  if self.FindComponent(LuName) <> nil then
    Exit;  //bereits vorhanden
  Lu := TLookupDef.Create(self);  //owner definiert. Dadurch automatisches Destroy
  Lu.Name := LuName;

  Qu := TUQuery.Create(self);  //FromLuDef.DataSet;
  Qu.DatabaseName := Query1.DataBaseName;
  Lu.Navlink.DataSet := Qu;  //that's the key! (für OnGet)
  Lu.MasterSource := DataSource1;

  Lu.CalcList.Assign(FromLuDef.CalcList);
  Lu.FltrList.Assign(FromLuDef.FltrList);
  Lu.FormatList.Assign(FromLuDef.FormatList);
  Lu.KeyFields := FromLuDef.KeyFields;
  Lu.PrimaryKeyFields := FromLuDef.PrimaryKeyFields;
  Lu.SqlFieldList.Assign(FromLuDef.SqlFieldList);
  Lu.References.Assign(FromLuDef.References);
  Lu.TableName := FromLuDef.TableName;
  Lu.OnGet := FromLuDef.OnGet;
  //Qu.Open;  beware query1 ist noch nicht soweit
  Debug0;
end;

procedure TRepDflt.CheckCalcCache(AForm: TqForm; ACalcList: TValueList);
var
  I: integer;
  S1, LuName, NextS: string;
  ALuDef: TLookupDef;
begin
  for I := 0 to ACalcList.Count - 1 do
  begin
    S1 := PStrTok(ACalcList.Value(I), ':', NextS);
    if CompareText(S1, 'Lookup') = 0 then
    begin
      LuName := PStrTok('', ';', NextS);
      ALuDef := TLookUpDef(aForm.FindComponent(LuName));
      InsertLuDef(ALuDef, LuName);
    end;
  end;
end;

procedure TRepDflt.FormCreate(Sender: TObject);
var
  I, X, DX: integer;
  AField: TField;
  ANLnk: TNavLink;
  AForm: TqForm;
  AWidth: integer;
  IsLast: boolean;
  S1: string;
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
begin {FormCreate}
  RepDflt := self;
  //if Char1(PrnSource.Bemerkung.GetString('Orientation', 'P')) = 'L' - Property liest so aus
  if PrnSource.IsLandscape then
    QuickReport.Page.Orientation := poLandscape;
  Framed := PrnSource.Bemerkung.GetBool('Framed', SysParam.DfltRepFramed);
  Lined := PrnSource.Bemerkung.GetBool('Lined', SysParam.DfltRepLined);

  if (PrnSource.MuSelect <> nil) and (PrnSource.MuSelect is TMultiGrid) then
    AMu := TMultiGrid(PrnSource.MuSelect) else   //27.11.09
    AMu := FrmMain.DfltMultiGrid;    //depreciated
  ANLnk := AMu.NavLink;
  AForm := ANLnk.Form as TqForm;
  Query1.DataBaseName := ANLnk.Query.DataBaseName;
  Query1.MasterSource := ANLnk.Query.MasterSource;           {021099 Dpe.Zak, vor unidac: datasource}
//verhindert korrektes Nachlagen von Lookup-CalcFields (webab.vmat)  Query1.OnCalcFields := ANLnk.Query.OnCalcFields;       //24.05.09:webab   13.04.07 VoKl weg?
  LNavigator.Navlink.OldCalcFields := ANLnk.OldCalcFields; //03.07.07 Bhae
  CheckCalcCache(AForm, ANLnk.CalcList);                 //Lookups einfügen
  LNavigator.TableName := ANLnk.TableName;
  LNavigator.CalcList.Assign(ANLnk.CalcList);
  LNavigator.ColumnList.Assign(ANLnk.ColumnList);
  LNavigator.FltrList.Assign(ANLnk.FltrList);
  PrnSource.FltrList.Assign(ANLnk.FltrList);  //19.05.09: für PrnSource.DoRun
  LNavigator.SqlFieldList.Assign(ANLnk.SqlFieldList);
  LNavigator.FormatList.Assign(ANLnk.FormatList);
  LNavigator.KeyFields := ANLnk.KeyFields;
  LNavigator.PrimaryKeyFields := ANLnk.PrimaryKeyFields;
  LNavigator.References.Assign(ANLnk.References);
  LNavigator.OnGet := ANLnk.OnGet;                  {Calcfields}
  LNavigator.OnBuildSql := ANLnk.OnBuildSql;        {QDispo.Disp.psAbruf 27.12.11}
  {beware wg CalcCache 24.07.07
  for I := 0 to self.ComponentCount - 1 do
    if self.Components[I] is TLookupDef then
      with self.Components[I] as TLookupDef do
        DataSet.Open; }
  //Feldbezeichnungen übernehmen. Für LaCaption
  for I := 0 to ANLnk.DataSet.FieldCount - 1 do
  begin
    AField := Query1.FindField(ANLnk.DataSet.Fields[I].FieldName);
    if AField <> nil then
      AField.DisplayLabel := ANLnk.DataSet.Fields[I].DisplayName;
  end;
  //:Params übernehmen
  if ANLnk.DataSet is TUQuery then
  begin
    Query1.Params.AssignValues(TUQuery(ANLnk.DataSet).Params);
//    for I := 0 to Query1.ParamCount - 1 do
//    begin
//      Query1.Params[I].Assign(TUQuery(ANLnk.DataSet).Params[I]);
//    end;
  end;
  StripLine := not AMu.DrawMultiLine;
  QuickReport.Font.Size := PrnSource.FontSize; //beware! Bemerkung.GetInteger(SFontSize, AMu.Font.Size);
  self.Font.Size := QuickReport.Font.Size;
  FontZoom := QuickReport.Font.Size / AMu.Font.Size;  // <1 = verkleinern

  { mit Abfrage ausgeben - ISA 23.05.08
  P := Pos('[', AForm.ShortCaption);
  if P > 0 then
    QuickReport.ReportTitle := copy(AForm.ShortCaption, 1, P-1) else }
  //  QuickReport.ReportTitle := AForm.ShortCaption;
  S1 := PrnSource.Bemerkung.GetString('ReportTitle', AForm.SubCaption);
  if BeginsWith(S1, 'Lookup ', true) then
    S1 := Copy(S1, 8, MaxInt);
  QuickReport.ReportTitle := S1;

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
    if Pos('S', AMu.DisplayList.Values[AField.FieldName]) > 0 then
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
        //LabelWidth := true;  //??
      end else
      begin
        //LabelWidth := false; //??
        Width := IMax(Width, Round(FontZoom * AMu.ColWidths[I+1]));
        if (AField is TNumericField) or (AField.Alignment = taRightJustify) then
        begin
          Alignment := taRightJustify;
        end;
      end;
      Transparent := true;
      AWidth := Width;
      if IsLast and not (AField is TNumericField) then
      begin
        AWidth := Line.Width - X;    //Bug: DX - md15.05.08
      end;

      ChildCol.Height := IMax(ChildCol.Height, Height + 4);
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
    if Pos('M', AMu.DisplayList.Values[AField.FieldName]) > 0 then   {Summe}
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
      DataSet := Query1;
      DataField := AField.FieldName;
      Line.Height := Height + Top;
      //if LabelWidth then 
      Autosize := false;
      Width := AWidth;
      if (AField is TNumericField) or (AField.Alignment = taRightJustify) then
        Alignment := taRightJustify;
      if AField is TNumericField then
      begin
        Autosize := true;          //bei Zahlen nix abschneiden
      end else
      if Pos('O', AMu.DisplayList.Values[AField.FieldName]) > 0 then   {OptiWidth}
      begin
        WordWrap := false;
        AutoStretch := false;
        Autosize := true;          //nix abschneiden auch wenn knapp wird
      end else
      begin
        WordWrap := true;
        AutoStretch := AField.Tag <= 0;  //nicht bei Asw - ents 23.05.08
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

procedure TRepDflt.LineBeforePrint(Sender: TQRCustomBand;
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

procedure TRepDflt.DfltPrint(sender: TObject; var Value: string);
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
    if Pos('O', AMu.DisplayList.Values[AField.FieldName]) > 0 then   {OptiWidth}
    begin
      //kein ... weil Optimale Breite bereits berechnet (klemmt halt um 1-2 Pixel)
    end else
    if AField is TNumericField then
    begin
      //kein ... weil numerisch, rechtsbündig
    end else

//warum?
//    if (Pos(' ', Value) > 0) or (Pos(CRLF, Value) > 0) or
//       ((AField <> nil) and IsBlobField(AField)) then
//    begin
//      //Height := Line.Height - Top;                 {Trick um Height zu übernehmen}
////      TQRPrintableHack(Sender).QRPrinter.Canvas.Font.Size := 222;
////    TQRCustomBandHack(Line).MakeSpace;
//    end else

    if (QuickReport.TextWidth(Font, Value) > Width) and
       { not IsBlobField(Dataset.FieldByName(DataField)) and (Pos(CRLF, Value) = 0) and }
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

procedure TRepDflt.ChildBand1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  PrintBand := false;
end;

procedure TRepDflt.LaCaptionPrint(sender: TObject; var Value: string);
// Filterwerte im Feld Caption ausgeben
var
  I, P: Integer;
  S, S2: string;
  L: TValueList;
  AField: TField;
begin
  Value := PrnSource.Caption;
  if {(Trim(Value) = '') or} EndsWith(Value, ';') then  //20.05.09: nur wenn mit ';' angefordert
  try
    if EndsWith(Value, ';') then
      S := Copy(Value, 1, Length(Value) - 1) else
      S := Value;  //nicht mehr 16.09.10
    L := TValueList.Create;
    try
      L.Assign(LNavigator.FltrList);
      L.MergeStrings(LNavigator.References);
      for I := 0 to L.Count - 1 do
      begin
        AField := Query1.FindField(L.Param(I));
        S2 := L.Value(I);
        if S2 = '>=' then
          S2 := '';
        for P := 0 to Query1.ParamCount - 1 do
        begin  //23.02.11 :Parameter durch Wert ersetzen
          S2 := StrCgeStrStr(S2, ':' + Query1.Params[P].Name, Query1.Params[P].AsString, false);
        end;
        if BeginsWith(S2, ':') and (Query1.DataSource <> nil) then
        try
          S2 := Query1.DataSource.Dataset.FieldByName(Copy(S2, 2, MaxInt)).Text;
        except on E:Exception do
          EProt(Query1, E, 'WARN TRepDflt.LaCaptionPrint(%s)', [L[I]]);
        end;
        if (AField <> nil) and (S2 <> '') and not BeginsWith(S2, ':') then
          AppendTok(S, Format('%s: %s', [AField.DisplayName, S2]), ' · ');
      end;
    finally
      L.Free;
    end;
    Value := S;
  except on E:Exception do begin
      Value := E.Message;
      EProt(self, E, 'TRepDflt.LaCaptionPrint', [0]);
    end;
  end;
end;

procedure TRepDflt.QRDateTimePrint(sender: TObject; var Value: string);
begin
  Value := Format(Value, [Sysparam.Username]);
  System.Delete(Value, length(Value) - 2, 3);    {Sek weg}
  if DelphiRunning then
  begin
    if DelphiQRDateTime = '' then
    begin
      DelphiQRDateTime := Value;
      WMessInput('DelphiRunning', 'QRDateTime', DelphiQRDateTime);
    end;
    Value := DelphiQRDateTime;
  end;
end;

procedure TRepDflt.HdrTextAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  {FrmMain.PrintVorlage('K', 'D', QuickReport);}
end;

procedure TRepDflt.QuickReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
//  ChildBand1.Height := 1;
  FrmPara.SetupLogo(QRImLogo, QrLaName, true);  //Align
  LaCaption.Width := PageNumber.Left - LaCaption.Left - 20;
end;

procedure TRepDflt.SumTextBeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  PrintBand := PrintSumText;
end;

procedure TRepDflt.QRSysData2Print(sender: TObject; var Value: String);
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

procedure TRepDflt.Query1BeforeOpen(DataSet: TDataSet);
var
  ANLnk: TNavLink;
begin
  ANLnk := AMu.NavLink;
  if ANLnk.DataSet is TUQuery then
  begin
    Query1.Params.AssignValues(TUQuery(ANLnk.DataSet).Params);
  end;
end;

end.
