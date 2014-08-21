unit PropsDlg;
(* Eigenschaften einer Query
   25.05.99    Erstellt
   21.09.99    SQL
   17.02.00    Feldwerte, Feldsortierung aus
*)
interface

uses
{$ifdef WIN32}
  ComCtrls,
{$else}
{$endif}
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, TabNotBk, SysUtils, Mask, DBCtrls, DB,  Uni, DBAccess, MemDS, ExtCtrls,
  Grids, Outline,
  NLnk_Kmp, Qwf_Form, Menus;

type
  (* TDlgErr Dialogbox *)
  TDlgProps = class(TqForm)
    Panel1: TPanel;
    Outline1: TOutline;
    PanRight: TPanel;
    BtnClose: TBitBtn;
    PopupMenu1: TPopupMenu;
    MiSort: TMenuItem;
    MiCopy: TMenuItem;
    lbS: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure Outline1Expand(Sender: TObject; Index: Longint);
    procedure FormDestroy(Sender: TObject);
    procedure MiSortClick(Sender: TObject);
    procedure MiCopyClick(Sender: TObject);
  private
    { Private declarations }
    NavLink: TNavLink;
    procedure FormInit;
  public
    { Public declarations }
    class procedure Execute(Sender: TNavLink);
  end;

var
  DlgProps: TDlgProps;

implementation
{$R *.DFM}
uses
  MemData {FieldDesc},
  Prots, DPos_Kmp, GNav_Kmp, FldDeDlg, HtmlClp,
  USes_Kmp;
const
  IRecordCount = 0;  //'Anzahl Datensätze';
  IDbParams = 1;  //'Datenbankparameter';
  IFields = 2;  //'Felder';
  IIndex = 3;  //'Indizes';
  ISql = 4;  //'SQL';
  IDatenbank = 5;  //'Datenbank';

class procedure TDlgProps.Execute(Sender: TNavLink);
begin
  with TDlgProps.Create(Application) do
  try
    NavLink := Sender;
    if NavLink <> nil then                 //[NavLink.Display]) else
      Caption := Format(Caption, [copy(Navlink.Kennung, 4, Maxint)]) else  //ohne 'Frm'
      Caption := 'nil';
    ShowModal;
  finally
    Release;
  end;
end;

procedure TDlgProps.FormCreate(Sender: TObject);
var
  I: integer;
begin
  DlgProps := self;
  GNavigator.TranslateForm(self);
  for I := 0 to lbS.Items.Count - 1 do
  begin
    lbS.Items[I] := GNavigator.TranslateStr(self, lbS.Items[I]);
  end;
  FormInit;
end;

procedure TDlgProps.FormDestroy(Sender: TObject);
begin
  DlgProps := nil;
end;

procedure TDlgProps.FormInit;
begin
  with OutLine1 do
  try
    BeginUpdate;
    Lines.Clear;
    Lines.Add(lbS.Items[IRecordCount]);
    Lines.Add(lbS.Items[IDbParams]);
    Lines.Add(lbS.Items[IFields]);
    Lines.Add(lbS.Items[IIndex]);
    Lines.Add(lbS.Items[ISql]);
  finally
    EndUpdate;
  end;
end;

procedure TDlgProps.Outline1Expand(Sender: TObject; Index: Longint);
var
  S, NextS: string;
  I: integer;
  L, o: TValueList;
  AFieldDef: TFieldDef;
  S1: string;
  aFieldDesc: TFieldDesc;
  function DataTypeStr(AFieldType: TFieldType; ASize: integer): string;
  begin
    if ASize = 0 then
      result := FieldTypeStr[AFieldType] else
      result := FieldTypeStr[AFieldType] + '(' + IntToStr(ASize) + ')';
  end;
  function ChangedStr(FldName: string): string;
  begin
    if NavLink.ChangedFields.IndexOf(Uppercase(FldName)) >= 0 then   //Upper 10.09.03 siehe nlnk
      result := '*' else
      result := '';
  end;
begin
  if not Outline1.Items[Index].HasItems then with Outline1 do
  begin
    L := TValueList.Create;
    try
      S := Items[Index].Text;
      if S = lbS.Items[IRecordCount] then
      begin
        AddChild(Index, Format('%d', [NavLink.RecordCount]));
      end else
      if S = lbS.Items[IDbParams] then
      begin
        AddChild(Index, Format('%s: %s', [lbS.Items[IDatenbank], NavLink.Query.DatabaseName]));
        if (NavLink.Query <> nil) and (NavLink.Query.Database <> nil) then
        begin
          L.Sorted := MiSort.Checked;
          AddChild(Index, Format('Alias: %s', [NavLink.Query.Database.AliasName]));
          USession.GetAliasParams(NavLink.Query.Database.AliasName, L);
          L.MergeStrings(NavLink.Query.Database.Params);  {anderer User, Pasw.,..}
          if not DelphiRunning then
            L.Values['PASSWORD'] := '';
          //L.Add('PrivateDir: ' + USession.PrivateDir);
          for I := 0 to L.Count - 1 do
            AddChild(Index, L[I]);
        end;
      end else
      if S = lbS.Items[IFields] then
      begin
        if (NavLink.DataSet <> nil) and (NavLink.DataSet.FieldDefs.Count > 0) then
        begin
          L.Sorted := MiSort.Checked;
          for I := 0 to NavLink.DataSet.FieldDefs.Count-1 do
          begin
            //FieldDesc.Length ist leider auch varchar2.size * 4
            if NavLink.DataSet is TMemDataSet then
            begin
              aFieldDesc := TMemDataSet(NavLink.DataSet).GetFieldDesc(NavLink.DataSet.Fields[I]);
              S1 := aFieldDesc.ActualName + '.' + IntToStr(aFieldDesc.Length) +
                '.' + IntToStr(aFieldDesc.Scale) + '.' + IntToStr(aFieldDesc.Size);
            end else
              S1 := NavLink.DataSet.ClassName;

            AFieldDef := NavLink.DataSet.FieldDefs.Items[I];
            L.Add(Format('%-19s %-17.17s %8s %1s %s',
              [AFieldDef.Name,
              DataTypeStr(AFieldDef.DataType, AFieldDef.Size),
              RequiredStr[AFieldDef.Required], ChangedStr(AFieldDef.Name),
              GetFieldString(NavLink.DataSet.FindField(AFieldDef.Name))]));
          end;
          for I := 0 to L.Count - 1 do
            AddChild(Index, Format('%3d.%s', [I+1, L[I]]));
        end;
      end else
      if S = lbS.Items[IIndex] then
      begin
        if (NavLink.DataSet <> nil) and (NavLink.DataSet.FieldDefs.Count > 0) then
        begin
          o := TValueList.Create;
          try
            S1 := PStrTok(NavLink.TableName, ';', NextS);
            S1 := StrDflt(GNavigator.TableSynonyms.Values[S1], S1);
            IndexInfo(QueryDatabase(NavLink.Query),   //NavLink.Query.DatabaseName,
                      S1, L, o);
            for I := 0 to L.Count - 1 do
              AddChild(Index, Format('%s (%s)', [L[I], o.Values[StrParam(L[I])]]));
          finally
            o.Free;
          end;
        end;
      end else
      if S = lbS.Items[ISql] then
      begin
        if NavLink.Query <> nil then
        begin
          for I := 0 to NavLink.Query.Sql.Count - 1 do
            AddChild(Index, NavLink.Query.Sql[I]);
        end;
      end else
      begin
      end;
    finally
      L.Free;
    end;
  end;
end;

procedure TDlgProps.MiSortClick(Sender: TObject);
begin
  MiSort.Checked := not MiSort.Checked;
  FormInit;
end;

procedure TDlgProps.MiCopyClick(Sender: TObject);
begin
  CopyTxt(Outline1.Lines.Text);
end;

end.
