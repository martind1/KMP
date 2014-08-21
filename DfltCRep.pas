unit DfltCRep;
(* Default Report mit Angabe der Spalten in Mu.NavLink.ColumnList
10.07.01 MD bestätigt

todo: nach d2010, unidac. Anpassen an dfltrep.
*)
interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, Uni, UQue_Kmp, DBAccess, MemDS,
  QRepForm, Lnav_kmp, quickrpt, Qrctrls, UDS__Kmp;
{$ifdef WIN32}
{$else}
{$endif}

type
  TRepDfltC = class(TQRepForm)
    QuickReport: TQuickRep;
    HdrText: TQRBand;
    FtrPage: TQRBand;
    Line: TQRBand;
    SumText: TQRBand;
    Query1: TuQuery;
    HdrCol: TQRBand;
    ChildCol: TQRChildBand;
    PageNumber: TQRSysData;
    QRDateTime: TQRSysData;
    QRSysData1: TQRSysData;
    QRLabel8: TQRLabel;
    Nav: TLNavigator;
    LaCaption: TQRLabel;
    Bemerkung: TQRChildBand;
    QRSysData2: TQRSysData;
    FtrText: TQRChildBand;
    laAusdruckEnde: TQRLabel;
    QRMemo1: TQRMemo;
    DataSource1: TuDataSource;
    QRImLogo: TQRImage;
    QRLaName: TQRLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LaCaptionPrint(sender: TObject; var Value: string);
    procedure QRDateTimePrint(sender: TObject; var Value: string);
    procedure HdrTextAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
    procedure QuickReportBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure SumTextBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure SumPrint(sender: TObject; var Value: String);
  private
    { Private declarations }
    PrintSumText: boolean;
    procedure DfltPrint(sender: TObject; var Value: string);
  public
    { Public declarations }
    Framed: integer;
  end;

var
  RepDfltC: TRepDfltC;

implementation
{$R *.DFM}
uses
  Printers,
  Prots, MuGriKmp, NLnk_Kmp, Qwf_Form, DPos_Kmp,
  MainFrm, ParaFrm;

procedure TRepDfltC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TRepDfltC.FormDestroy(Sender: TObject);
begin
  RepDfltC := nil;
end;

procedure TRepDfltC.FormCreate(Sender: TObject);
var
  I, P, X, DX, MaxLines: integer;
  AField: TField;
  S: string;
  LastCol: boolean;
  ANLnk: TNavLink;
  AMu: TMultigrid;
  AForm: TqForm;
  AColumnList: TValueList;
  ADisplayWidth, WidthOf9: integer;
  ADisplayLabel, ADisplayOptions: string;

  function GetDisplay(S: string): boolean;
  var
    ADisplay, NextS: string;
  begin    {AField, ADisplayLabel, ADisplayWidth, ADisplayOptions}
    result := false;
    AField := ANLnk.DataSet.FindField(AColumnList.Value(I));
    if AField = nil then
      Exit;
    {if Query1.FieldDefs.IndexOf(AField.FieldName) < 0 then
      Exit;                                            {keine CalcFields}
    ADisplay := StrParam(S);                 {Display[:Len]=FieldName}
    if Char1(ADisplay) = ':' then
      Exit;                             {:Steuerzeile für Height usw.}
    P := Pos(':',ADisplay);             {Name:20,S    S=ohne Aswtext}
    if P > 0 then                       {             M=Summierung}
    begin                               {             V=variable Höhe}
      ADisplayLabel := copy(ADisplay, 1, P - 1);
      ADisplayOptions := PStrTok(copy(ADisplay, P+1, Length(ADisplay) - P), ',', NextS);
      ADisplayWidth := WidthOf9 * StrToIntTol(ADisplayOptions);
      if ADisplayWidth = 0 then
        Exit;
      ADisplayOptions := PStrTok('', '', NextS);  {Rest nach ,}
    end else
    begin
      ADisplayLabel := ADisplay;
      ADisplayOptions := '';
      ADisplayWidth := WidthOf9 * AField.DisplayWidth;
    end;
    result := true;
  end;

begin
  RepDfltC := self;
  if PrnSource.Bemerkung.GetString('Orientation', 'P') = 'L' then
    QuickReport.Page.Orientation := poLandscape;
  {auch tötlich:
  Line.Height := Line.Height * PrnSource.Bemerkung.GetInteger('MinLines', 1);}
  Framed := PrnSource.Bemerkung.GetInteger('Framed', ord(SysParam.DfltRepFramed));
  MaxLines := PrnSource.Bemerkung.GetInteger('MaxLines', 5);
  if Framed and 2 <> 0 then
  begin
    FtrText.Height := Line.Height * MaxLines;
    {FtrPage.Height := Line.Height * MaxLines;    {tötlich. auch bei ident.Zuweisung. warum?}
  end;
  AMu := FrmMain.DfltMultiGrid;
  ANLnk := AMu.NavLink;

  AColumnList := ANLnk.ColumnList;
  if AColumnList.Count = 0 then
  begin
    {with ANLnk.DataSet, AColumnList do
      for i := 0 to FieldCount - 1 do
        Add(Format('%s=%s', [Fields[i].FieldName, Fields[i].FieldName]));}
    AColumnList := AMu.ColumnList;                       {wie Dflt}
  end;
  AForm := ANLnk.Form as TqForm;
  Query1.DataBaseName := ANLnk.Query.DataBaseName;
  Query1.MasterSource := ANLnk.Query.MasterSource;           {021099 Dpe.Zak}
  LNavigator.CalcList.Assign( ANLnk.CalcList);
  LNavigator.ColumnList.Assign( ANLnk.ColumnList);
  LNavigator.FltrList.Assign( ANLnk.FltrList);
  LNavigator.FormatList.Assign( ANLnk.FormatList);
  LNavigator.KeyFields := ANLnk.KeyFields;
  LNavigator.PrimaryKeyFields := ANLnk.PrimaryKeyFields;
  LNavigator.References.Assign( ANLnk.References);
  LNavigator.SqlFieldList.Assign( ANLnk.SqlFieldList);
  LNavigator.TableName := ANLnk.TableName;
  LNavigator.OnGet := ANLnk.OnGet;                  {Calcfields}

  //QuickReport.Font.Size := AMu.Font.Size;
  QuickReport.Font.Size := PrnSource.Bemerkung.GetInteger('FontSize', AMu.Font.Size);
  QuickReport.ReportTitle := AForm.ShortCaption;
  WidthOf9 := QuickReport.TextWidth(QuickReport.Font, '0');
  if Framed <> 0 then
  begin
    //DX := 3;
    if Framed and 1 <> 0 then
      Line.Frame.DrawBottom := true;
    if Framed and 2 <> 0 then
    begin
      Line.Frame.DrawLeft := true;
      Line.Frame.DrawRight := true;
    end;
    DX := WidthOf9;
  end else
    DX := WidthOf9;
  X := 2;
  for I:= 0 to AColumnList.Count - 1 do
  begin
    if not GetDisplay(AColumnList[I]) then
      Continue;          {AField, ADisplayLabel, ADisplayWidth, ADisplayOptions}
    if ADisplayOptions = 'S' then
      LNavigator.FormatList.Values[AField.FieldName] := '';   {kein Asw.Text}
    if X + Canvas.TextWidth(ADisplayLabel) >= ChildCol.Width then
      break;
    with ChildCol.AddPrintable(TQRLabel) as TQRLabel do
    begin
      Top := 2;
      Left := X;
      Color := clSilver;
      Caption := ADisplayLabel;
      ADisplayWidth := IMax(ADisplayWidth, Width);
      LastCol := (X + ADisplayWidth + DX >= Line.Width);
      ADisplayWidth := IMin(ChildCol.Width - Left - 2, ADisplayWidth);
      Autosize := false;
      Width := ADisplayWidth;
      if AField is TNumericField then
        Alignment := taRightJustify;
      if (Framed and 0 <> 0) and not LastCol then
      begin
        Frame.DrawLeft := true;
        Frame.DrawRight := true;
      end;
    end;
    {Vert.Linien:}
    if (Framed and 2 <> 0) and not LastCol then
    begin
      with ChildCol.AddPrintable(TQRShape) as TQRShape do
      begin
        Shape := qrsVertLine;
        Width := DX;
        Top := 0;
        Left := X + ADisplayWidth;
        Height := ChildCol.Height * MaxLines;
      end;
    end;
    if (ADisplayOptions = 'M') then   {Summe}
      with SumText.AddPrintable(TQRExpr) as TQRExpr do
      begin
        PrintSumText := true;
        Top := QRSysData2.Top;
        Left := X;
        Autosize := false;
        Width := ADisplayWidth;
        Alignment := taRightJustify;
        Expression := 'Sum(' {+ ANLnk.DataSet.Name + '.'} + AField.FieldName + ')';
        Master := QuickReport;
        if AField is TNumericField then
          Mask := TNumericField(AField).DisplayFormat;
        Autosize := true;
        Transparent := true;
        OnPrint := SumPrint;
        {Frame.DrawTop := true;}
      end;
    with Line.AddPrintable(TQRDBText) as TQRDBText do
    begin
       Top := 1;
       Left := X;
       DataSet := Query1;
       DataField := AField.FieldName;
       Line.Height := Height + Top;
       Autosize := false;
       Width := ADisplayWidth;
       if AField is TNumericField then
         Alignment := taRightJustify else
       begin
         WordWrap := true;
         AutoStretch := true;
       end;
       OnPrint := DfltPrint;
       if (Framed and 0 <> 0) and not LastCol then
       begin
         Frame.DrawLeft := true;
         Frame.DrawRight := true;
       end;
    end;
    {Vert.Linien: }
    if (Framed and 2 <> 0) and not LastCol then
    begin
      with Line.AddPrintable(TQRShape) as TQRShape do
      begin
        Shape := qrsVertLine;
        Width := DX;
        Top := 0;
        Left := X + ADisplayWidth;
        Height := Line.Height * MaxLines;
      end;
    end;
    X := X + ADisplayWidth + DX;
    if X >= Line.Width then
      break;
  end;
  {if Line.Width > X then
    Line.Width := X;              geht so nicht}
  S := PrnSource.Bemerkung.GetString('Memo1', '');
  if S <> '' then
  begin
    QrMemo1.Lines.Text := S;
    Bemerkung.Enabled := true;
  end else
    Bemerkung.Enabled := false;
end;

type
  TQRPrintableHack = class(TQRPrintable);

procedure TRepDfltC.DfltPrint(sender: TObject; var Value: string);
var
  AField: TField;
begin
  with sender as TQRDBText do
  begin
    AField := Dataset.FieldByName(DataField);
    if (Pos(' ', Value) > 0) or (Pos(CRLF, Value) > 0) or IsBlobField(AField) then
    begin
      Height := Line.Height - Top;                 {Trick um Height zu übernehmen}
      TQRPrintableHack(Sender).QRPrinter.Canvas.Font.Size := 222;
    end else
    if (QuickReport.TextWidth(Font, Value) > Width) and
       not IsBlobField(AField) and (Pos(CRLF, Value) <= 0) and
       not (AField is TDateTimeField) then
    begin
      Value := Value + chr(133);       {...}
      while (QuickReport.TextWidth(Font, Value) > Width) and (length(Value) > 3) do
        System.Delete(Value, length(Value) - 1, 1);
      while (QuickReport.TextWidth(Font, Value) > Width) do
        System.Delete(Value, length(Value), 1);
    end;
  end;
end;

procedure TRepDfltC.SumPrint(sender: TObject; var Value: String);
begin
  smess0;  //test
  // Value := 'Hallo World';
end;

procedure TRepDfltC.LaCaptionPrint(sender: TObject; var Value: string);
begin
  Value := PrnSource.Caption;
end;

procedure TRepDfltC.QRDateTimePrint(sender: TObject; var Value: string);
begin
  Value := Format(Value, [Sysparam.Username]);
  System.Delete(Value, length(Value) - 2, 3);    {Sek weg}
end;

procedure TRepDfltC.HdrTextAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  // FrmMain.PrintVorlage('K', 'D', QuickReport);
end;

procedure TRepDfltC.QuickReportBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  //FrmMain.PrintVorlage32('K', 'D');
  FrmPara.SetupLogo(QRImLogo, QrLaName, true);  //Align
  LaCaption.Width := PageNumber.Left - LaCaption.Left - 20;
end;

procedure TRepDfltC.SumTextBeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  PrintBand := PrintSumText;
end;

end.
