unit ChangeLogDlg;
(* ChangeLog Trigger erzeugen. Protokolliert alle DB Änderungen
   Keine BLOB Felder
22.05.09 md  MSSQL: convert statt str: ergibt alle Nachkommastellen
15.07.11 md  ORA Apex: INFO_FIELD für delete und insert.
             Date mit Minuten: OraOldField, OraNewField
07.10.12 md  TMemoField mit aufnehmen (LoadBeforeProcessNode#387)
             MSSQL: text-, ntext- oder image-Spalten können in den eingefügten und gelöschten Tabellen nicht verwendet werden.
28.10.13 md  [new_werk_nr],[old_werk_nr]: :w -> :new/old.w / :new.w -> :old.w
*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Buttons, MSXML_TLB,
  Qwf_Form, Lnav_kmp, DB, NLnk_Kmp, MemDS, DBAccess, Uni, UQue_Kmp;

const
  MemoLen = 80;   //max. Länge eines Memo Inhalts

type
  TDlgChangeLog = class(TqForm)
    Panel1: TPanel;
    DetailBook: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EdXmlFilename: TEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    EdTableName: TEdit;
    EdShort: TEdit;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    edSTME_NR: TEdit;
    EdWERK_NR: TEdit;
    Label5: TLabel;
    edPKEY_FIELD: TEdit;
    Label6: TLabel;
    btnXmlSelect: TBitBtn;
    btnXmlOpen: TBitBtn;
    dlgXml: TOpenDialog;
    Nav: TLNavigator;
    LDataSource1: TLDataSource;
    DlgSql: TOpenDialog;
    BtnRun: TBitBtn;
    BtnClose: TBitBtn;
    tsErgebnis: TTabSheet;
    MeSQL: TMemo;
    TabSheet3: TTabSheet;
    lbParse: TListBox;
    GroupBox4: TGroupBox;
    BtnSqlSave: TBitBtn;
    EdSqlFileName: TEdit;
    Label7: TLabel;
    BtnSqlCopy: TBitBtn;
    GroupBox5: TGroupBox;
    EdIgnoredFields: TEdit;
    EdINFO_FIELD: TEdit;
    Label8: TLabel;
    cobTableName: TComboBox;
    Query1: TuQuery;
    procedure btnXmlSelectClick(Sender: TObject);
    procedure btnXmlOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BtnSqlSaveClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnRunClick(Sender: TObject);
    procedure BtnSqlCopyClick(Sender: TObject);
    procedure cobTableNameDropDown(Sender: TObject);
    procedure cobTableNameChange(Sender: TObject);
  private
    FDOMDocument: IXMLDOMDocument;    //das XML Hauptobjekt
    procedure BuildXml;
    procedure LoadAfterProcessNode(Sender: TObject; Node: IXMLDomNode;
      Level: Integer);
    procedure LoadBeforeProcessNode(Sender: TObject; Node: IXMLDomNode;
      Level: Integer);
    function IgnoredField(AFieldname: string): boolean;
    procedure LoadFromIni(aName: string);
    procedure SaveToIni;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    class procedure Execute(aDatabaseName: string;
      ATableName: string = ''; AShort: string = ''; APKEY_Field: string = '';
      AINFO_Field: string = ''); overload;
    class procedure Execute(aNavlink: TNavLink); overload;
  end;

var
  DlgChangeLog: TDlgChangeLog;

implementation
{$R *.DFM}
uses
  ComObj,
  Ini__Kmp, Prots, GNav_Kmp, XMLExport;

class procedure TDlgChangeLog.Execute(aNavlink: TNavLink);
var
  aTableName, aShort, aPKEY_Field, aINFO_FIELD, aDatabaseName: string;
begin
  if aNavlink <> nil then
  begin
    aTableName := OnlyFieldName(aNavLink.TableName);
    aShort := copy(aNavLink.Kennung, 4, MaxInt);  //Frmabcd -> abcd
    aPKEY_Field := aNavLink.PrimaryKeyFields;
    aINFO_FIELD := StrDflt(aNavLink.KeyFields, aNavLink.KeyList.Values['Standard']);
    if aNavlink.Dataset is TuQuery then
      aDatabaseName := TuQuery(aNavlink.Dataset).DatabaseName else
      aDatabaseName := GNavigator.DB1.DatabaseName;

    TDlgChangeLog.Execute(aDatabaseName, ATableName, AShort, APKEY_Field);
  end else
    TDlgChangeLog.Execute(GNavigator.DB1.DatabaseName);
end;

class procedure TDlgChangeLog.Execute(aDatabaseName: string;
  ATableName: string = ''; AShort: string = ''; APKEY_Field: string = '';
  AINFO_Field: string = '');
var
  S1: string;
begin
  with TDlgChangeLog.Create(Application) do
  begin
    Query1.DatabaseName := aDatabaseName;

    EdTableName.Text := StrDflt(ATableName, EdTableName.Text);
    EdShort.Text := StrDflt(AShort, EdShort.Text);
    edPKEY_FIELD.Text := StrDflt(APKEY_Field, edPKEY_FIELD.Text);
    edINFO_FIELD.Text := StrDflt(AINFO_Field, edINFO_FIELD.Text);

    if AShort <> '' then
    begin
      S1 := 'TR_' + AShort + '_CHANGELOG';
      S1 := ValidDir(ExtractFileDir(EdSqlFileName.Text)) + S1;
      EdSqlFileName.Text := StrDflt(S1, EdSqlFileName.Text);
    end;
    ShowNormal;
  end;
end;

procedure TDlgChangeLog.FormCreate(Sender: TObject);
begin
  DlgChangeLog := self;
  LoadFromIni('');
end;

procedure TDlgChangeLog.FormDestroy(Sender: TObject);
begin
  DlgChangeLog := nil;
end;

procedure TDlgChangeLog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  //Erstellen. SaveToIni;
end;

procedure TDlgChangeLog.LoadFromIni(aName: string);
var
  Kurz_Name: string;
begin
  if aName = '' then
    Kurz_Name := Kurz else
    Kurz_Name := Kurz + '.' + aName;

  EdXmlFilename.Text := IniKmp.ReadString(Kurz_Name, EdXmlFilename.Name, EdXmlFilename.Text);
  EdTableName.Text := IniKmp.ReadString(Kurz_Name, EdTableName.Name, EdTableName.Text);
  EdShort.Text := IniKmp.ReadString(Kurz_Name, EdShort.Name, EdShort.Text);
  edPKEY_FIELD.Text := IniKmp.ReadString(Kurz_Name, edPKEY_FIELD.Name, edPKEY_FIELD.Text);
  edINFO_FIELD.Text := IniKmp.ReadString(Kurz_Name, edINFO_FIELD.Name, edINFO_FIELD.Text);
  edSTME_NR.Text := IniKmp.ReadString(Kurz_Name, edSTME_NR.Name, edSTME_NR.Text);
  EdWERK_NR.Text := IniKmp.ReadString(Kurz_Name, EdWERK_NR.Name, EdWERK_NR.Text);
  EdSqlFileName.Text := IniKmp.ReadString(Kurz_Name, EdSqlFileName.Name, EdSqlFileName.Text);
  EdIgnoredFields.Text := IniKmp.ReadString(Kurz_Name, EdIgnoredFields.Name, EdIgnoredFields.Text);
end;

procedure TDlgChangeLog.SaveToIni;
var
  Kurz_Name: string;
begin
  IniKmp.WriteString(Kurz, EdXmlFilename.Name, EdXmlFilename.Text);
  IniKmp.WriteString(Kurz, EdTableName.Name, EdTableName.Text);
  IniKmp.WriteString(Kurz, EdShort.Name, EdShort.Text);
  IniKmp.WriteString(Kurz, edPKEY_FIELD.Name, edPKEY_FIELD.Text);
  IniKmp.WriteString(Kurz, edINFO_FIELD.Name, edINFO_FIELD.Text);
  IniKmp.WriteString(Kurz, edSTME_NR.Name, edSTME_NR.Text);
  IniKmp.WriteString(Kurz, EdWERK_NR.Name, EdWERK_NR.Text);
  IniKmp.WriteString(Kurz, EdSqlFileName.Name, EdSqlFileName.Text);
  IniKmp.WriteString(Kurz, EdIgnoredFields.Name, EdIgnoredFields.Text);
  //pro Name:
  if EdXmlFilename.Name <> '' then
  begin
    IniKmp.WriteString(Kurz + '.Namen', EdTableName.Text, '1');
    Kurz_Name := Kurz + '.' + EdTableName.Text;
    IniKmp.WriteString(Kurz_Name, EdXmlFilename.Name, EdXmlFilename.Text);
    IniKmp.WriteString(Kurz_Name, EdTableName.Name, EdTableName.Text);
    IniKmp.WriteString(Kurz_Name, EdShort.Name, EdShort.Text);
    IniKmp.WriteString(Kurz_Name, edPKEY_FIELD.Name, edPKEY_FIELD.Text);
    IniKmp.WriteString(Kurz_Name, edINFO_FIELD.Name, edINFO_FIELD.Text);
    IniKmp.WriteString(Kurz_Name, edSTME_NR.Name, edSTME_NR.Text);
    IniKmp.WriteString(Kurz_Name, EdWERK_NR.Name, EdWERK_NR.Text);
    IniKmp.WriteString(Kurz_Name, EdSqlFileName.Name, EdSqlFileName.Text);
    IniKmp.WriteString(Kurz_Name, EdIgnoredFields.Name, EdIgnoredFields.Text);
  end;
end;

procedure TDlgChangeLog.cobTableNameDropDown(Sender: TObject);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    IniKmp.ReadSection(Kurz + '.Namen', L);
    cobTableName.Items.Assign(L);
  finally
    L.Free;
  end;
end;

procedure TDlgChangeLog.cobTableNameChange(Sender: TObject);
begin
  LoadFromIni(cobTableName.Text);
end;

procedure TDlgChangeLog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDlgChangeLog.btnXmlSelectClick(Sender: TObject);
begin
  with dlgXml do
  begin
    InitialDir := ExtractFilePath(EdXmlFileName.Text);
    if InitialDir = '' then
      InitialDir := AppDir;
    Title := btnXmlSelect.Hint;
    FileName := EdXmlFileName.Text;
    if Execute then
    begin
      EdXmlFileName.Text := FileName;
    end;
  end;
end;

procedure TDlgChangeLog.btnXmlOpenClick(Sender: TObject);
begin
  SysParam.DisplayWinExecError := true;
  ShellExecNoWait(EdXmlFileName.Text, SW_NORMAL);
end;

procedure TDlgChangeLog.BtnSqlSaveClick(Sender: TObject);
begin
  with dlgSql do
  begin
    InitialDir := ExtractFilePath(EdSqlFileName.Text);
    if InitialDir = '' then
      InitialDir := AppDir;
    Title := btnSqlSave.Hint;
    FileName := EdSqlFileName.Text;
    if Execute then
    begin
      EdSqlFileName.Text := FileName;
      SaveToIni;
      MeSQL.Lines.SaveToFile(FileName);
    end;
  end;
end;

procedure TDlgChangeLog.BtnSqlCopyClick(Sender: TObject);
begin
  MeSql.SelectAll;
  MeSql.CopyToClipboard;
  MeSql.SelLength := 0;
end;

procedure TDlgChangeLog.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDlgChangeLog.BtnRunClick(Sender: TObject);
begin
  SaveToIni;
  Nav.TableName := EdTableName.Text;
  BuildXML;
  DetailBook.ActivePage := tsErgebnis;
end;

function TDlgChangeLog.IgnoredField(AFieldname: string): boolean;
var    //true = Field wier ignoriert
  S1, NextS: string;
begin
  result := false;
  S1 := PStrTok(EdIgnoredFields.Text, ';', NextS, true);
  while S1 <> '' do
  begin
    if CompareText(S1, AFieldName) = 0 then
    begin
      result := true;
      exit;
    end;
    S1 := PStrTok('', ';', NextS, true);
  end;
end;

{ XML }

procedure TDlgChangeLog.LoadBeforeProcessNode(Sender: TObject;
  Node: IXMLDomNode; Level: Integer);
var
  I: integer;
  AField: TField;

  procedure ParseValue(N: IXMLDomNode);
  var
    I: integer;
    L: TStringList;

    function ParseTok(T: string): string;
    begin
      result := lbParse.Items.Values[T];
    end; { ParseTok }

    function ParseLine(S: string): string;
    var
      I, P1, P2, Step: integer;
      S1, Tok: string;
    begin
      result := '';
      Step := 1;
      I := 1;
      P1 := 1;  //wg Compiler
      while I <= length(S) do
      begin
        case Step of
          1: if S[I] = '[' then
             begin
               P1 := I;
               Step := 2;
             end else
               result := result + S[I];
          2: if S[I] = ']' then
             begin
               while (I < length(S)) and (S[I + 1] = ']') do
                 Inc(I);    //geschachtelte Klammern
               P2 := I;
               Tok := copy(S, P1 + 1, P2 - P1 - 1);
               S1 := ParseTok(Tok);
               result := result + Trim(S1);
               Step := 1;
             end;
        end;
        Inc(I);
      end;
    end; { ParseLine }

  begin { ParseValue }
    L := TStringList.Create;
    try
      L.Text := N.Text;
      for I := 0 to L.Count - 1 do
        if Trim(L[I]) <> '' then
          MeSQL.Lines.Add(ParseLine(L[I]));
    finally
      L.Free;
    end;
  end;

begin { LoadBeforeProcessNode }
  if Node = nil then
    Exit;
  //if Node.NodeType in [NODE_TEXT] then
  begin
    if Node.NodeName = 'line' then
    begin
      ParseValue(Node);
    end else
    if Node.NodeName = 'field' then
    begin
      for I := 0 to Query1.FieldCount - 1 do
      begin
        AField := Query1.Fields[I];
        if (not (AField is TBlobField) or not Sysparam.MSSQL) and
           not IgnoredField(AField.Fieldname) then
        with lbParse.Items do
        begin
          Values['Field'] := AField.FieldName;
          if AField is TNumericField then
            Values['NullValue'] := '0' else
          if AField is TDateTimeField then
            Values['NullValue'] := 'TO_DATE(''01.01.1980'', ''DD.MM.YYYY'')' else
            Values['NullValue'] := '''?''';   //String,Memo
          if AField is TDateTimeField then
            Values['MsNullValue'] := 'CONVERT(datetime, ''01.01.1980'', 104)' else
            Values['MsNullValue'] := Values['NullValue'];  //wie Orcl

          if AField is TNumericField then
          begin
            Values['MSValue'] := Format('convert(varchar, %s)', [AField.FieldName]);
            Values['MSAtValue'] := Format('convert(varchar, @%s)', [AField.FieldName]);
          end else
          if AField is TDateTimeField then
          begin
            Values['MSValue'] := Format('convert(varchar, %s, 104)', [AField.FieldName]);
            Values['MSAtValue'] := Format('convert(varchar, @%s, 104)', [AField.FieldName]);
          end else
          if AField is TBlobField then  //Memo
          begin
            Values['MSValue'] := Format('convert(varchar(%d), %s)', [MemoLen, AField.FieldName]);
            Values['MSAtValue'] := Format('convert(varchar(%d), @%s)', [MemoLen, AField.FieldName]);
          end else
          begin
            Values['MSValue'] := Format('%s', [AField.FieldName]);   //String,Memo
            Values['MSAtValue'] := Format('@%s', [AField.FieldName]);   //String,Memo
          end;

          //MSSQL: string
          Values['MSOld'] := Format('select %s from deleted', [Values['MSValue']]);
          Values['MSNew'] := Format('select %s from inserted', [Values['MSValue']]);

          //MSSQL: Lines mit Cursor
          Values['MSFieldOld'] := Format('select %s from deleted where %s', [Values['Field'], Values['MsCurWhere']]);
          //PKey Felder haben wird bereits
          if IndexOfToken(Values['Field'], EdPKEY_FIELD.Text, ',;', true) >= 0 then
          begin
            Values['MSFieldNew'] := '@' + Values['Field'];
            Values['MSStrNew'] := Values['MSAtValue'];
          end else
          begin
            Values['MSFieldNew'] := Format('select %s from inserted where %s', [Values['Field'], Values['MsCurWhere']]);
            Values['MSStrNew'] := Format('select %s from inserted where %s', [Values['MSValue'], Values['MsCurWhere']]);
          end;
          Values['MSStrOld'] := Format('select %s from deleted where %s', [Values['MSValue'], Values['MsCurWhere']]);

          //15.07.11: Ora Apex
          if AField is TDateTimeField then
          begin
            Values['OraOldField'] := Format('to_char(:old.%s, ''DD.MM.YYYY HH24:MI:SS'')', [AField.FieldName]);
            Values['OraNewField'] := Format('to_char(:new.%s, ''DD.MM.YYYY HH24:MI:SS'')', [AField.FieldName]);
          end else
          if AField is TBlobField then  //Memo - or TStringField and size>255
          begin
            Values['OraOldField'] := Format('substr(:old.%s,1,%d)', [AField.FieldName, MemoLen]);
            Values['OraNewField'] := Format('substr(:new.%s,1,%d)', [AField.FieldName, MemoLen]);
          end else
          begin
            Values['OraOldField'] := Format(':old.%s', [AField.FieldName]);
            Values['OraNewField'] := Format(':new.%s', [AField.FieldName]);
          end;

          ParseValue(Node);
        end;
      end;
    end else
    begin
      Prot0('unbekannter Knotenname %s', [Node.NodeName]);
    end;
  end;
end;

procedure TDlgChangeLog.LoadAfterProcessNode(Sender: TObject;
  Node: IXMLDomNode; Level: Integer);
begin //Ereignis aufrufen: Node wurde durchlaufen
end;

procedure TDlgChangeLog.BuildXml;
//XML erstellen: Liest Vorlage ein

  function MsFieldTypeStr(AField: TField): string;
  begin
    if AField is TIntegerField then
      Result := 'int' else
    if AField is TFloatField then
      Result := 'float' else
    if AField is TDateTimeField then
      Result := 'datetime' else
    if AField is TStringField then
      Result := Format('varchar(%d)', [AField.Size]) else
      Result := 'varchar(250)';  //unbekannt
  end;

var
  Parser: TXmlParser;
  S1, S2, S3, S4, NextS: string;
  AField: TField;
  S1At, S5, S6, S7, S8, S9: string;
begin
  with lbParse.Items do
  begin
    Clear;
    Values['Short'] := EdShort.Text;
    Values['TableName'] := EdTableName.Text;
    Values['STME_NR'] := EdSTME_NR.Text;
    if BeginsWith(EdWERK_NR.Text, ':') then
    begin
      Values['WERK_NR'] := EdWERK_NR.Text;  //:NEW.wwww
      if PosI(':new.', EdWERK_NR.Text) > 0 then  //28.10.13
      begin
        Values['NEW_WERK_NR'] := EdWERK_NR.Text;  //:NEW.wwww
        Values['OLD_WERK_NR'] := StrCgeStrStr(EdWERK_NR.Text, ':new.', ':old.', true);  //:old.wwww
      end else
      begin   //:wwww
        Values['NEW_WERK_NR'] := ':new.' + copy(EdWERK_NR.Text, 2, Maxint);  //:new.wwww
        Values['OLD_WERK_NR'] := ':old.' + copy(EdWERK_NR.Text, 2, Maxint);  //:old.wwww
      end;
    end else
    begin
      Values['WERK_NR'] := ''''+EdWERK_NR.Text+'''';      //'0175'
      Values['NEW_WERK_NR'] := Values['WERK_NR'];
      Values['OLD_WERK_NR'] := Values['WERK_NR'];  //19.02.14 bug war new
    end;
    Values['PKEY_FIELD'] := EdPKEY_FIELD.Text;
    S2 := '';
    S3 := '';
    S4 := '';
    S5 := ''; S6 := ''; S7 := ''; S8 := ''; S9 := '';
    S1 := PStrTok(EdPKEY_FIELD.Text, ',;', NextS);
    while S1 <> '' do
    begin
      AField := Query1.FindField(S1);
      if AField <> nil then
      begin
        if AField is TNumericField then
          S1 := 'convert(varchar, '+AField.FieldName+')' else
        if AField is TDateTimeField then
          S1 := 'convert(varchar, '+AField.FieldName+', 104)' else
          S1 := AField.FieldName;   //String,Memo
        if AField is TNumericField then
          S1At := 'convert(varchar, @'+AField.FieldName+')' else
        if AField is TDateTimeField then
          S1At := 'convert(varchar, @'+AField.FieldName+', 104)' else
          S1At := '@' + AField.FieldName;   //String,Memo
      end;
      AppendTok(S2, Format('(select %s from inserted)', [S1]), ' +''.''+ ');
      AppendTok(S3, Format('(select %s from deleted)', [S1]), ' +''.''+ ');
      AppendTok(S4, Format('(select %s from inserted)', [S1]), ' +''|''+ ');

      AppendTok(S5, AField.Fieldname, ',');
      AppendTok(S6, '@' + AField.Fieldname, ',');
      AppendTok(S7, '@' + AField.Fieldname + ' ' + MsFieldTypeStr(AField), ',');
      //AppendTok(S8, S1At, ' + ''.'' + '); bis 30.04.12
      AppendTok(S8, Format('isnull(%s,'''')', [S1At]), ' + ''.'' + ');
      AppendTok(S9, Format('(%s=@%s or @%s is null)', [AField.Fieldname, AField.Fieldname, AField.Fieldname]),
                ' and ');

      S1 := PStrTok('', ',;', NextS);
    end;
    //alt: RowCount=1
    Values['MsPKEY'] := S2;
    Values['MsPKEYDeleted'] := S3;
    Values['MsPKEY1'] := S4;  //WFER

    //neu:mit Cursor
    Values['MsPkeyFields'] := S5;  //fld1,fld2,fld3
    Values['MsPkeyAtFields'] := S6;  //@fld1,@fld2,@fld3
    Values['MsPkeyDeclFields'] := S7;  //@fld1 int,@fld2 float,@fld3 varchar(30)
    Values['MsCurPkey'] := S8;  //convert(@fld1) + '.' convert(@fld2) + '.' + @fld3
    Values['MsCurWhere'] := S9;  //[where ] @fld1=val1 and @fld2=val2 and @fld3=val3

    Values['Field'] := 'Field';
    Values['NullValue'] := 'NullValue';
    Values['MsNullValue'] := 'MsNullValue';

    //15.07.11 Ora Apex Info Field Ora: Für Ausgabe bei Insert und Delete
    S2 := ''; S3 := '';
    S1 := PStrTok(EdINFO_FIELD.Text, ',;', NextS);
    while S1 <> '' do
    begin
      AField := Query1.FindField(S1);
      if AField <> nil then
      begin
        if AField is TDateTimeField then
        begin
          S4 := Format('to_char(:old.%s, ''DD.MM.YYYY HH24:MI:SS'')', [AField.FieldName]);
          S5 := Format('to_char(:new.%s, ''DD.MM.YYYY HH24:MI:SS'')', [AField.FieldName]);
        end else
        if AField is TBlobField then  //Memo
        begin
          S4 := Format('substr(:old.%s,1,%d)', [AField.FieldName, MemoLen]);
          S5 := Format('substr(:new.%s,1,%d)', [AField.FieldName, MemoLen]);
        end else
        begin
          S4 := Format(':old.%s', [AField.FieldName]);
          S5 := Format(':new.%s', [AField.FieldName]);
        end;
        S2 := S2 + Format('||'' %s(''||%s||'')''', [AField.FieldName, S4]);
        S3 := S3 + Format('||'' %s(''||%s||'')''', [AField.FieldName, S5]);
      end;

      S1 := PStrTok('', ',;', NextS);
    end;

    Values['OraOldInfo'] := S2;  //für line
    Values['OraNewInfo'] := S3;
  end;  //with

  //Starten:
  MeSQL.Lines.Clear;

  FDOMDocument := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  FDOMDocument.async := false;

  FDOMDocument.Load(EdXmlFilename.Text);
  Parser := TXMLParser.Create(FDOMDocument);
  Parser.SetProcess(LoadBeforeProcessNode, LoadAfterProcessNode); //Aktion festlegen
  Parser.ProcessNode(FDOMDocument.DocumentElement, 0);

  {FnXML := TempDir + DokuNr + '.xml';
  FDOMDocument.Save(FnXML);}

end;

end.
