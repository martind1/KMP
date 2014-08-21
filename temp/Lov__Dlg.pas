unit Lov__dlg;
(* List of Values Dialog
   28.04.00 MD Positionierung anhand GNavigator.DbCompare
   ??.03.03 JM LovDlgVL, LovDlgVLEx mit FieldList
               Aufbau FieldList:                  Ergebnis in Fieldlist:
               KeyFields=<KField1>;<KField2>;...  Field1=Value1
               Field1=J  <-- verwenden            Field2=Value2
               Field2=N  <-- nicht verwenden
   06.07.04 MD DlgEx mit FltrList (Lov Btn)
   07.11.07 MD berücksichtigt Sortierung bei Schnellsuche. Case egal. Slide nicht wg. Message/modal
   30.10.08    Slidebar geht doch.
*)
interface

uses
{$ifdef WIN32}
  ComCtrls,
{$else}
{$endif}
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, TabNotBk, SysUtils, Mask, DBCtrls, DB, Uni, DBAccess, MemDS, ExtCtrls,
  Grids, DBGrids,
  Mugrikmp, NLnk_Kmp, Lnav_kmp, Qwf_Form, DPos_Kmp;                             {JM 23.01.02}

type
  TLovFlag = (
              lovFltr,                {Filter übernehmen}
              lovNoReferences         {References nicht übernehmen}
             );
  TLovFlags = set of TLovFlag;

  TDlgLov = class(TqForm)
    DataSource1: TDataSource;
    PanButtons: TPanel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    PanEdit: TPanel;
    Edit1: TEdit;
    MultiGrid1: TMultiGrid;
    Query1: TUniQuery;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    BtnSql: TBitBtn;
    Label1: TLabel;
    procedure Edit1Change(Sender: TObject);
    procedure MultiGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnSqlClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure Query1AfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function LovDlgEx(ANavLink: TNavLink; Fields: string; Flags: TLovFlags;
    AFltrList: TFltrList = nil): string;
  function LovDlg(ANavLink: TNavLink; Fields: string): string;
  function LovDlgVLEx(ANavLink: TNavLink; var FieldList: TValueList; Flags: TLovFlags): String;{JM 23.01.02}
  function LovDlgVL(ANavLink: TNavLink; var FieldList: TValueList): String;     {JM 23.01.02}

var
  DlgLov : TDlgLov;

implementation
{$R *.DFM}
uses
  Messages,
  Asws_Kmp, Prots, Sql__Dlg, GNav_Kmp, Err__Kmp, nstr_kmp;
const
  MaxCount = 30;
  LovMaxWidth: integer = 742;
  MinCount = 2;
  LovMinWidth = 182;
  ScrollWidth = 20;

function LovDlg(ANavLink: TNavLink; Fields: string): string;
begin
  result := LovDlgEx(ANavLink, Fields, [lovFltr]);
end;

function LovNLDataSet(ANavLink: TNavLink): TDataSet;
begin  //ergibt auch im Suchen-Modus die tatsächliche Datenmenge.
  if ANavLink.nlState = nlQuery then
    result := ANavLink.SaveDataSet else
    result := ANavLink.DataSet;
end;

function LovDlgEx(ANavLink: TNavLink; Fields: string; Flags: TLovFlags;
  AFltrList: TFltrList = nil): string;
var
  Btn: word;
  I, P, FWidth: integer;
  AFieldName: string;
  AField: TField;
  S, ATblName, NextS: string;
begin
  DlgLov := TDlgLov.Create(Application);
  with DlgLov do
  try
    try
      Query1.DataBaseName := (LovNLDataSet(ANavLink) as TDBDataSet).DataBaseName;
      {Query1.Tag := 1;       {kein Update der Fielddefs in Buildsql ! weg 140298}
      ATblName := ANavLink.TableName;
      AFieldName := PStrTok(Fields, ',;', NextS);
      Nav.KeyFields := AFieldName;

      Nav.SqlFieldList.Clear;
      Nav.SqlFieldList.AddTokens(Fields, ';');
      for I := 0 to Nav.SqlFieldList.Count - 1 do
      begin                       {falls mehrere Tabellen:}
        if BeginsWith(Nav.SqlFieldList[I], '*') then
        begin     //*Feldname -> nach Feldname wird sortiert
          S := copy(Nav.SqlFieldList[I], 2, MaxInt);
          Nav.SqlFieldList[I] := S;
          Nav.KeyFields := S;
        end else
          S := Nav.SqlFieldList[I];
        P := Pos('.', S);
        if P > 0 then
        begin
          ATblName := copy(S, 1, P-1);
          Nav.SqlFieldList[I] := copy(S, P+1, 254);
          Flags := Flags + [lovNoReferences];                 {Quvad 11.08.01}
        end;
      end;
      Nav.SqlFieldList[0] := 'distinct ' + Nav.SqlFieldList[0];
      Nav.TableName := ATblName;

      if AFltrList <> nil then
        Nav.FltrList.Assign(AFltrList);

      //if (lovFltr in Flags) and (Pos(';', ATblName) = 0) then
      if (lovFltr in Flags) or (Pos(';', ATblName) > 0) then  {Quvad 11.08.01}
      begin
        for I := 0 to ANavLink.FltrList.Count - 1 do         {GEN.LINK.LovBtn}
          if Pos(':', ANavLink.FltrList.Value(I)) = 0 then
            Nav.FltrList.Add(ANavLink.FltrList[I]);
        if not (lovNoReferences in Flags) then                {Quvad 11.08.01}
          for I := 0 to ANavLink.References.Count - 1 do
            if Pos(':', ANavLink.References.Value(I)) = 0 then
              Nav.References.Add(ANavLink.References[I]);
      end;

      MultiGrid1.ColumnList.Clear;
      AFieldName := LTrimCh(PStrTok(Fields, ',;', NextS, true), '*');
      while AFieldName <> '' do
      begin
        AField := LovNLDataSet(ANavLink).FieldByName(OnlyFieldName(AFieldName));
        Nav.FormatList.Values[OnlyFieldName(AFieldName)] :=
          ANavLink.FormatList.Values[OnlyFieldName(AFieldName)];
        if IsBlobField(AField) then
          FWidth := 200 else
        if AField is TStringField then
          FWidth := IMax(AField.Size, AField.DisplayWidth) else   {30.10.08, 121100}
          FWidth := AField.DisplayWidth;
        //FWidth := IMin(50, FWidth);       //11.04.04 nein ISA 07.07.04
        MultiGrid1.ColumnList.Add(Format('%s:%d=%s',
          [AField.DisplayLabel, MulDiv(FWidth, 4, 3), AField.FieldName]));
        AFieldName := LTrimCh(PStrTok('', ',;', NextS, true), '*');
      end;
      Query1.Open;
      Query1.EnableControls;

      Btn := ShowModal;  //Checkt auch Breite
      if Btn = mrOk then
      begin
        if MultiGrid1.SelectedRows.Count > 0 then
        begin
          result := '';
          for I := 0 to MultiGrid1.SelectedRows.Count - 1 do
          begin
            Query1.Bookmark := MultiGrid1.SelectedRows[I];
            AppendTok(result, GetFieldValue(Query1.Fields[0]), ';');
          end;
        end else
          result := GetFieldValue(Query1.Fields[0]);
      end else
        result := '';
    except on E:Exception do
      EMess(Query1, E, 'LovDlgEx', [0]);
    end;
  finally
    Free;
  end;
end;

function LovDlgVL(ANavLink: TNavLink; var FieldList: TValueList): String;       {>JM 23.01.02}
begin
  result := LovDlgVLEx(ANavLink, FieldList, [lovFltr]);
end;

function LovDlgVLEx(ANavLink: TNavLink; var FieldList: TValueList; Flags: TLovFlags): String;
var
  Btn: word;
  I, P, FWidth: integer;
  AFieldName: string;
  AField: TField;
  S, ATblName: string;
begin
  DlgLov := TDlgLov.Create(Application);
  with DlgLov do
  try
    try
      Query1.DataBaseName := (LovNLDataSet(ANavLink) as TDBDataSet).DataBaseName;
      {Query1.Tag := 1;       {kein Update der Fielddefs in Buildsql ! weg 140298}
      ATblName := ANavLink.TableName;

//      AFieldName := FieldList.Param(0);
      AFieldName := FieldList.Values[sKeyFields];
      FieldList.Values[sKeyFields] := '';
      Nav.KeyFields := AFieldName;

      Nav.SqlFieldList.Clear;
      For I := 0 To FieldList.Count - 1 Do
        Nav.SqlFieldList.Add(FieldList.Param(I));

      for I := 0 to Nav.SqlFieldList.Count - 1 do
      begin                       {falls mehrere Tabellen:}
        S := Nav.SqlFieldList[I];
        P := Pos('.', S);
        if P > 0 then
        begin
          ATblName := copy(S, 1, P-1);
          Nav.SqlFieldList[I] := copy(S, P+1, 254);
          Flags := Flags + [lovNoReferences];                 {Quvad 11.08.01}
        end;
      end;
      Nav.SqlFieldList[0] := 'distinct ' + Nav.SqlFieldList[0];
      Nav.TableName := ATblName;

      //if (lovFltr in Flags) and (Pos(';', ATblName) = 0) then
      if (lovFltr in Flags) or (Pos(';', ATblName) > 0) then  {Quvad 11.08.01}
      begin
        for I := 0 to ANavLink.FltrList.Count - 1 do         {GEN.LINK.LovBtn}
          if Pos(':', ANavLink.FltrList.Value(I)) = 0 then
            Nav.FltrList.Add(ANavLink.FltrList[I]);
        if not (lovNoReferences in Flags) then                {Quvad 11.08.01}
          for I := 0 to ANavLink.References.Count - 1 do
            if Pos(':', ANavLink.References.Value(I)) = 0 then
              Nav.References.Add(ANavLink.References[I]);
      end;

      MultiGrid1.ColumnList.Clear;
      For I := 0 To FieldList.Count Do Begin
        AFieldName := FieldList.Param(I);
        If (AFieldName <> '') And (FieldList.Value(I) = 'J') Then Begin
          AField := LovNLDataSet(ANavLink).FieldByName(OnlyFieldName(AFieldName));
          if IsBlobField(AField) then
            FWidth := 200 else
          if AField is TStringField then
            FWidth := AField.Size else                      {121100}
            FWidth := AField.DisplayWidth;
          MultiGrid1.ColumnList.Add(Format('%s:%d=%s',
            [AField.DisplayLabel, MulDiv(FWidth, 4, 3), AField.FieldName]));
        End;
      end;
      Query1.Open;
      Query1.EnableControls;

      Btn := ShowModal;
      FieldList.Clear;
      if Btn = mrOk then Begin
        For I := 0 To Query1.FieldCount - 1 Do
          FieldList.Values[Query1.Fields[I].FieldName] := GetFieldValue(Query1.Fields[I]);
        result := GetFieldValue(Query1.Fields[0]);
      End
      Else result := '';
    except on E:Exception do
      EMess(Query1, E, 'LovDlgVLEx', [0]);
    end;
  finally
    Free;
  end;
end;                                                                            {<JM 23.01.02}

procedure TDlgLov.FormCreate(Sender: TObject);
begin
  Sizeable := true;
  BtnSql.Visible := DelphiRunning;
end;

procedure TDlgLov.FormShow(Sender: TObject);
var
  I, AWidth: integer;
begin
  AWidth := 8;
  for I:= 0 to MultiGrid1.ColCount-1 do
    AWidth := AWidth + MultiGrid1.ColWidths[i] + 4;
  InitWidth := IMax(LovMinWidth, IMin(LovMaxWidth, AWidth)) + 8;  {Rahmen um Grid}
  MultiGrid1.LastColResize := true;  //07.07.04
end;

procedure TDlgLov.FormResize(Sender: TObject);
begin
  //Edit1.Width := MultiGrid1.ColWidths[1] + 4;
  FormResizeStd(self);
end;

procedure TDlgLov.Edit1Change(Sender: TObject);
var
  S: string;
  L: integer;
  F: TField;
  I: integer;
begin
  if Edit1.Text = '' then
  begin
    Query1.First;
    exit;
  end;
  I := IMax(0, Query1.FieldList.IndexOf(Nav.KeyFields));
  F := Query1.Fields[I];  //berücksichtigt Sortierung
  S := Edit1.Text;
  L := length(S);
  (*if F is TNumericField then
  begin
    D := StrToFloatTol(S);
    while not Query1.BOF and (F.AsFloat >= D) do
      Query1.Prior;
    while not Query1.EOF and (F.AsFloat < D) do
      Query1.Next;
  end else   - Zahlen wie Zeichen behandeln md 07.11.07 *)
  begin
    while not Query1.BOF and
          //ignorecase=false wichtig weil Kleinbuchstaben erst am Ende kommen
          //evtl. Datenbank unterscheiden (MS setzt kleinnicht ans Ende)
          (GNavigator.DbCompare(copy(GetFieldValue(F), 1, L), S, false) >= 0) do
      Query1.Prior;
    while not Query1.EOF and
          (GNavigator.DbCompare(copy(GetFieldValue(F), 1, L), S, false) < 0) do
      Query1.Next;
  end;
end;

procedure TDlgLov.MultiGrid1DblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TDlgLov.BtnSqlClick(Sender: TObject);
begin
  TDlgSql.Execute(Sender, Query1, true);
end;

procedure TDlgLov.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ActiveControl <> MultiGrid1 then
  begin
    if (Key = VK_DOWN) or (Key = VK_UP) or
       (Key = VK_NEXT) or (Key = VK_PRIOR) then
      MultiGrid1.KeyDown(Key, Shift);
      //SendMessage(MultiGrid1.Handle, WM_KEYDOWN, Key, 0);              //Query1.Next;
  end;
end;

procedure TDlgLov.Query1AfterOpen(DataSet: TDataSet);
begin
//  self.Resize;  //MuGrid letzte Zeile war nur teilw sichtbar
//    procedure WMSize(var Message: TWMSize); message WM_SIZE;          {Slidebar}
  PostMessage(MultiGrid1.Handle, WM_SIZE, 0, 0);
end;

begin
  LovMaxWidth := Screen.Width - 58;
end.
