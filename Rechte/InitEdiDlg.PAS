unit InitEdiDlg;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, Dialogs, ExtCtrls, Radios,
  Qwf_Form, DB, Uni, DBAccess, MemDS,
  NLnk_Kmp, UQue_Kmp;

type
  TDlgInitEdi = class(TqForm)
    gbTop: TGroupBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edANWE: TEdit;
    edTYP: TEdit;
    edNAME: TEdit;
    Label2: TLabel;
    edSECTION: TEdit;
    meEntries: TMemo;
    chbDelete: TCheckBox;
    chbOverwrite: TCheckBox;
    Query1: TuQuery;
    procedure EditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure edTYPChange(Sender: TObject);
  private
    { Private declarations }
    TableName: string;
    EntryQuery: TUQuery;
  public
    { Public declarations }
    class procedure Execute(nlENTRY: TNavLink; Insert: boolean);
  end;

var
  DlgInitEdi: TDlgInitEdi;

implementation
{$R *.DFM}
uses
  SysUtils,
  Prots, {Ini__Kmp, IniDbKmp,} Err__Kmp, Sql__Dlg, GNav_Kmp,
  InitEdFrm;

class procedure TDlgInitEdi.Execute(nlENTRY: TNavLink; Insert: boolean);
const
  Kurz: string = 'DlgInitEdi';
  SqlGetFmt: string =
    'select PARAM,WERT from %s' + CRLF +
    'where (ANWENDUNG=:AN) and (TYP=:TY) and (NAME=:NA) and (SECTION=:SE)' + CRLF +
    'order by INIT_ID';

  procedure FillParams;
  var
    I: integer;
  begin
    with DlgInitEdi do
      for I := 0 to Query1.ParamCount - 1 do
      begin
        Query1.Params[I].Datatype := ftString;
        if Query1.Params[I].Name = 'AN' then
          Query1.Params[I].AsString := EdANWE.Text else
        if Query1.Params[I].Name = 'TY' then
          Query1.Params[I].AsString := EdTYP.Text else
        if Query1.Params[I].Name = 'NA' then
          Query1.Params[I].AsString := EdNAME.Text else
        if Query1.Params[I].Name = 'SE' then
          Query1.Params[I].AsString := EdSECTION.Text else
          EError('TDlgInitEdi.Execute:unbekannter Parameter %s', [Query1.Params[I].Name]);
      end;
  end;

begin
  DlgInitEdi := Create(Application);
  with DlgInitEdi do
  begin
    TableName := StrDflt(GNavigator.TableSynonym[nlENTRY.TableName], nlENTRY.TableName);
    EdAnwe.Text := nlENTRY.DataSet.FieldByName('ANWENDUNG').AsString;
    EdTyp.Text := nlENTRY.DataSet.FieldByName('TYP').AsString;
    EdName.Text := nlENTRY.DataSet.FieldByName('NAME').AsString;
    try
      EdSection.Text := nlENTRY.DataSet.FieldByName('SECTION').AsString;
    except
      EdSection.Text := '';
    end;
    Query1.DatabaseName := nlENTRY.Query.DatabaseName;
    try
      gbTop.Enabled := TFrmINITED(nlENTRY.Form).sbTop.Enabled;
    except end;
    //chbDelete.Checked := Replace;
    EntryQuery := nlEntry.Query;
    MeEntries.Lines.Clear;
    if Insert then  //neue Section erfassen
    begin
      edSECTION.Text := '';
      chbDelete.Checked := false;
      chbDelete.Visible := false;
      chbOverwrite.Checked := false;
      chbOverwrite.Visible := false;
      ActiveControl := edSECTION;
    end;
    EditChange(DlgInitEdi);
    Query1.SQL.Text := Format(SqlGetFmt, [TableName]);
    FillParams;
    Query1.Open;
    while not Query1.EOF do
    begin
      MeEntries.Lines.Add(Format('%s=%s', [Query1.FieldByName('PARAM').AsString,
                                           Query1.FieldByName('WERT').AsString]));
      Query1.Next;
    end;
    DlgInitEdi.ShowNormal(wsNormal);
  end;
end;

procedure TDlgInitEdi.FormCreate(Sender: TObject);
begin
//
end;

procedure TDlgInitEdi.FormDestroy(Sender: TObject);
begin
//
end;

procedure TDlgInitEdi.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDlgInitEdi.edTYPChange(Sender: TObject);
begin
  if edTYP.Text = 'V' then
    EdNAME.Text := 'VORGABE';
  EditChange(Sender);
end;

procedure TDlgInitEdi.EditChange(Sender: TObject);
begin
  btnOK.Enabled := (EdANWE.Text <> '') and
                   (EdTYP.Text <> '') and
                   (EdNAME.Text <> '') and
                   (EdSECTION.Text <> '');
end;

procedure TDlgInitEdi.BtnCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TDlgInitEdi.BtnOKClick(Sender: TObject);
var
  I: integer;
  PA, WE: string;
const
  SqlDelFmt: string =
    'delete from %s' + CRLF +
    'where (ANWENDUNG=:AN) and (TYP=:TY) and (NAME=:NA) and (SECTION=:SE)';
  SqlUpdFmt: string =
    'update %s' + CRLF +
    'set WERT=:WE' + CRLF +
    'where (ANWENDUNG=:AN) and (TYP=:TY) and (NAME=:NA) and (SECTION=:SE)' + CRLF +
    '  and (PARAM=:PA)';
  SqlInsFmt: string =
    'insert into %s (ANWENDUNG,TYP,NAME,SECTION,PARAM,WERT)' + CRLF +
    'values (:AN,:TY,:NA,:SE,:PA,:WE)';

  procedure FillParams;
  var
    I: integer;
  begin
    for I := 0 to Query1.ParamCount - 1 do
    begin
      Query1.Params[I].Datatype := ftString;
      if Query1.Params[I].Name = 'AN' then
        Query1.Params[I].AsString := EdANWE.Text else
      if Query1.Params[I].Name = 'TY' then
        Query1.Params[I].AsString := EdTYP.Text else
      if Query1.Params[I].Name = 'NA' then
        Query1.Params[I].AsString := EdNAME.Text else
      if Query1.Params[I].Name = 'SE' then
        Query1.Params[I].AsString := EdSECTION.Text else
      if Query1.Params[I].Name = 'PA' then
        Query1.Params[I].AsString := PA else
      if Query1.Params[I].Name = 'WE' then
        Query1.Params[I].AsString := WE else
        EError('TDlgInitEdi.BtnOKClick:unbekannter Parameter %s', [Query1.Params[I].Name]);
    end;
  end;

begin
  try
    if chbDelete.Checked then
    begin
      Query1.SQL.Text := Format(SqlDelFmt, [TableName]);
      FillParams;
      Query1.ExecSql;
    end;
    (* jetzt in INITED.Close - 26.03.09
    if (IniDb <> nil) and
       (IniDb.Anwendung = edANWE.Text) then
    begin  //IniDb Einträge neu einlesen
      case Char1(edTYP.Text) of
        'M': if IniDb.Maschine = edNAME.Text then
             begin
               IniDb.Maschine := '';
               IniDb.Maschine := edNAME.Text;
             end;
        'U': if IniDb.User = edNAME.Text then
             begin
               IniDb.User := '';
               IniDb.User := edNAME.Text;
             end;
      else  // 'A', 'V'
               IniDb.Anwendung := '';
               IniDb.Anwendung := edANWE.Text;
      end;
    end; *)
    for I := 0 to meEntries.Lines.Count - 1 do
    try
      PA := StrParam(meEntries.Lines[I]);
      WE := StrValue(meEntries.Lines[I]);
      Query1.SQL.Text := Format(SqlInsFmt, [TableName]);
      FillParams;
      Query1.ExecSql;
    except on E:Exception do
      if chbOverwrite.Checked then
      begin      //Update
        Query1.SQL.Text := Format(SqlUpdFmt, [TableName]);
        FillParams;
        Query1.ExecSql;
      end else
        EProt(Query1, E, 'TDlgInitEdi.BtnOKClick', [0]);
    end;
    try
      EntryQuery.Close;
      EntryQuery.Open;
    except on E:Exception do
      EProt(self, E, '%s:Refresh failed', [self.Caption]);
    end;
    self.Close;
  except on E:Exception do
    //TDlgSql.Execute(self, Query1, false);
    EMess(Query1, E, 'Fehler bei %s.OK', [self.Caption]);
  end;
end;

end.

