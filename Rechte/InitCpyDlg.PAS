unit InitCpyDlg;
(* INI-DB Einträge kopieren
09.11.12 md  keine Transaction mehr (UniDAC)
*)
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, Dialogs, ExtCtrls, Db, Uni, DBAccess, MemDS,
  NLnk_Kmp, UQue_Kmp;

type
  TDlgInitCpy = class(TForm)
    Panel1: TPanel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    edANWEnach: TEdit;
    edMACHnach: TEdit;
    edUSERnach: TEdit;
    edSECTnach: TEdit;
    edANWEvon: TEdit;
    edMACHvon: TEdit;
    edUSERvon: TEdit;
    edSECTvon: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    chbDelete: TCheckBox;
    EdVorgVon: TEdit;
    EdVorgNach: TEdit;
    rgKopiere: TRadioGroup;
    StaticText1: TStaticText;
    Query1: TuQuery;
    procedure EditChange(Sender: TObject);
  private
    TableName: string;
    CallerAnwe, CallerTyp, CallerName, CallerSection: string;
    function DoCopy: integer;
    { Private declarations }
  public
    { Public declarations }
    class function Execute(nlINIT: TNavLink; Replace: boolean;
      var Anwe, Mach, User, Grup, Sect: string): boolean;
  end;

var
  DlgInitCpy: TDlgInitCpy;

implementation
{$R *.DFM}
uses
  SysUtils,
  Prots, Ini__Kmp, Err__Kmp, Sql__Dlg, GNav_Kmp;

const
  koANWE = 0;
  koMACH = 1;
  koUSER = 2;
  koVORG = 3;
  koSECT = 4;
const
  rgAnwe = 0;
  rgMach = 1;
  rgUser = 2;
  rgVorg = 3;

class function TDlgInitCpy.Execute(nlINIT: TNavLink; Replace: boolean;
  var Anwe, Mach, User, Grup, Sect: string): boolean;
var
  Btn: word;
  N: integer;
const
  Kurz: string = 'DlgInitCpy';
begin
  result := false;
  DlgInitCpy := Create(Application);
  with DlgInitCpy do
  begin
    TableName := StrDflt(GNavigator.TableSynonyms.Values[nlINIT.TableName],
                         nlINIT.TableName);
    Query1.DatabaseName := nlINIT.Query.DatabaseName;
    CallerAnwe := nlINIT.DataSet.FieldByName('ANWENDUNG').AsString;
    CallerTyp := nlINIT.DataSet.FieldByName('TYP').AsString;
    CallerName := nlINIT.DataSet.FieldByName('NAME').AsString;
    CallerSection := nlINIT.DataSet.FieldByName('SECTION').AsString;
    chbDelete.Checked := Replace;

    EdAnweVon.Text := CallerAnwe;
    if (Sect = '%') or
       (WMessYesNo('Alle Sections kopieren?' + CRLF +
                  'Ja = alle' + CRLF +
                  'Nein = nur Section "%s" kopieren', [Sect]) = mrYes) then
      EdSectVon.Text := '%' else
      EdSectVon.Text := Sect;
    { EdAnweVon.Text := Anwe;
    EdMachVon.Text := Mach;
    EdUserVon.Text := User;
    EdVorgVon.Text := Grup; }
    case Char1(CallerTyp) of
      'A': begin EdAnweVon.Text := CallerName; rgKopiere.ItemIndex := rgAnwe; end;
      'M': begin EdMachVon.Text := CallerName; rgKopiere.ItemIndex := rgMach; end;
      'U': begin EdUserVon.Text := CallerName; rgKopiere.ItemIndex := rgUser; end;
      'V': begin EdVorgVon.Text := CallerName; rgKopiere.ItemIndex := rgVorg; end;
    end;
    EditChange(DlgInitCpy);
    repeat
      Btn := DlgInitCpy.ShowModal;
      try
        if Btn = mrOK then
        begin
          N := DoCopy;
          result := true;
          Anwe := EdAnweNach.Text;
          Mach := EdMachNach.Text;
          User := EdUserNach.Text;
          Grup := EdVorgNach.Text;
          Sect := EdSectNach.Text;
          WMess('%d Datensätze eingefügt', [N]);
        end;
      except on E:Exception do
        begin
          Btn := 0;
          EMess(DlgInitCpy, E, 'Fehler beim kopieren', [0]);
        end;
      end;
    until Btn <> 0;
  end;
  DlgInitCpy.Release;
  DlgInitCpy := nil;
end;

procedure TDlgInitCpy.EditChange(Sender: TObject);
var
  eqA, eqM, eqU, eqV, eqS, OK: boolean;
  I: integer;
  function Check2(v, n: TEdit): boolean;
  var
    nStr: string;
  begin
    nStr := n.Text;
    if (v.Text = '') or (v.Text = '%') then
    begin
      nStr := v.Text;
    end else
    if nStr = '' then
      nStr := '%';
    result := (v.Text = nStr) or (nStr = '%');
    if (nStr <> '%') and (nStr <> '') then
      OK := true;
    if n <> self.ActiveControl then
      n.Text := nStr;
  end;
begin
  OK := false;
  if edSectVon.Text = '' then
    edSectVon.Text := '%';
  eqA := Check2(edAnweVon, EdAnweNach);
  eqM := Check2(edMachVon, EdMachNach);
  eqU := Check2(edUserVon, EdUserNach);
  eqV := Check2(edVorgVon, EdVorgNach);
  eqS := Check2(edSectVon, EdSectNach);
  if OK then
    OK := not eqA or not eqM or not eqU or not eqV or not eqS;

  I := rgKopiere.ItemIndex;
  if I < 0 then OK := false;

  if ((I = koANWE) and eqA) or
     ((I = koMACH) and eqM and eqA) or
     ((I = koUSER) and eqU and eqA) or
     ((I = koVORG) and eqV and eqA) or
     ((I = koSECT) and eqS and eqA and eqM and eqU and eqV) then OK := false;

  btnOK.Enabled := OK;
end;

function TDlgInitCpy.DoCopy: integer;
// führt das Sql zum kopieren aus. Ergibt Anzahl eingefügter Records.
var
  ANWENDUNGnach: string;
  ANWEvon, MACHvon, USERvon, VORGvon, SECTvon: string;
  ANWEnach, MACHnach, USERnach, VORGnach, SECTnach: string;
  NachStr: string;
const
  SqlDelFmt: string =
    'delete from %s' + CRLF +
    'where (ANWENDUNG=:ANWENDUNGnach) ' + CRLF +
    '  and (((TYP like ''A'') and (NAME like :ANWEnach))' + CRLF +
    '    or ((TYP like ''M'') and (NAME like :MACHnach))' + CRLF +
    '    or ((TYP like ''U'') and (NAME like :USERnach))' + CRLF +
    '    or ((TYP like ''V'') and (NAME like :VORGnach)))' + CRLF +
    ' and (SECTION like :SECTnach)';
(*  SqlInsFmt: string =
    'insert into %s (ANWENDUNG,TYP,NAME,SECTION,PARAM,WERT)' + CRLF +
    'values (:AN,:TY,:NA,:SE,:PA,:WE)';*)
  SqlInsFmt: string =
    'insert into %s (ANWENDUNG,TYP,NAME,SECTION,PARAM,WERT)' + CRLF +
    //(select ANWENDUNG,TYP,NAME,SECTION,PARAM,WERT from %s' + CRLF +
    //(select %s,%s,%s,%s,%s,%s from %s' + CRLF +
    ' select %s,TYP,%s,%s,PARAM,WERT from %s' + CRLF +
    '  where (ANWENDUNG=:ANWENDUNGvon)' + CRLF +
    '    and (((TYP like ''A'') and (NAME like :ANWEvon))' + CRLF +
    '      or ((TYP like ''M'') and (NAME like :MACHvon))' + CRLF +
    '      or ((TYP like ''U'') and (NAME like :USERvon))' + CRLF +
    '      or ((TYP like ''V'') and (NAME like :VORGvon)))' + CRLF +
    '    and (SECTION like :SECTvon)' + CRLF +
    '  order by INIT_ID';

  procedure FillParams;
  var
    I: integer;
  begin
    for I := 0 to Query1.ParamCount - 1 do
    begin
      Query1.Params[I].Datatype := ftString;
      if Query1.Params[I].Name = 'ANWENDUNGvon' then
        Query1.Params[I].AsString := edANWEvon.Text else
      if Query1.Params[I].Name = 'ANWEvon' then
        Query1.Params[I].AsString := ANWEvon else
      if Query1.Params[I].Name = 'MACHvon' then
        Query1.Params[I].AsString := MACHvon else
      if Query1.Params[I].Name = 'USERvon' then
        Query1.Params[I].AsString := USERvon else
      if Query1.Params[I].Name = 'VORGvon' then
        Query1.Params[I].AsString := VORGvon else
      if Query1.Params[I].Name = 'SECTvon' then
        Query1.Params[I].AsString := edSECTvon.Text else
      if Query1.Params[I].Name = 'ANWENDUNGnach' then
        Query1.Params[I].AsString := ANWENDUNGnach else
      if Query1.Params[I].Name = 'ANWEnach' then
        Query1.Params[I].AsString := ANWEnach else
      if Query1.Params[I].Name = 'MACHnach' then
        Query1.Params[I].AsString := MACHnach else
      if Query1.Params[I].Name = 'USERnach' then
        Query1.Params[I].AsString := USERnach else
      if Query1.Params[I].Name = 'VORGnach' then
        Query1.Params[I].AsString := VORGnach else
      if Query1.Params[I].Name = 'SECTnach' then
        Query1.Params[I].AsString := SECTnach else
        EError('TDlgInitCpy.DoCopy:unbekannter Parameter %s', [Query1.Params[I].Name]);
    end;
  end;

  function GetNachParam(edVon, edNach: TEdit): string;
  begin
    if (edNach.Text = '%') and (edVon.Text <> '%') then
      result := edVon.Text else
      result := edNach.Text;
  end;

  function IsNachValue(edNach: TEdit): boolean;
  begin
    result := (edNach.Text <> '%') and (edNach.Text <> '');
  end;

  function GetNachValue(edNach: TEdit; Dflt: string): string;
  begin
    if IsNachValue(edNach) then
      result := '''' + edNach.Text + '''' else
      result := Dflt;
  end;

begin { DoCopy }
  Result := 0;
  EditChange(self);
  if not btnOK.Enabled then Exit;
  //09.11.12 QueryDataBase(Query1).StartTransaction;
  try
    ANWENDUNGnach := GetNachParam(edANWEvon, edANWEnach);
    ANWEnach := GetNachParam(edANWEvon, edANWEnach);
    if ANWEnach = edANWEvon.Text then
      ANWEnach := '';
    MACHnach := GetNachParam(edMACHvon, edMACHnach);
    USERnach := GetNachParam(edUSERvon, edUSERnach);
    VORGnach := GetNachParam(edVORGvon, edVORGnach);
    SECTnach := GetNachParam(edSECTvon, edSECTnach);

    ANWEvon := '';
    MACHvon := '';
    USERvon := '';
    VORGvon := '';
    SECTvon := '';
    case rgKopiere.ItemIndex of
      koANWE: ANWEvon := edANWEvon.Text;
      koMACH: MACHvon := edMACHvon.Text;
      koUSER: USERvon := edUSERvon.Text;
      koVORG: VORGvon := edVORGvon.Text;
    end;

    if chbDelete.Checked then
    begin
      Query1.SQL.Text := Format(SqlDelFmt, [TableName]);
      FillParams;
      ProtSQL(Query1);
      QueryExecCommitted(Query1);  //11.10.10 Query1.ExecSql;
    end;
    case rgKopiere.ItemIndex of
      koANWE: NachStr := GetNachValue(edANWEnach, 'NAME');
      koMACH: NachStr := GetNachValue(edMACHnach, 'NAME');
      koUSER: NachStr := GetNachValue(edUSERnach, 'NAME');
      koVORG: NachStr := GetNachValue(edVORGnach, 'NAME');
      koSECT: {if IsNachValue(edANWEnach) then
                NachStr := '''' + edANWEnach.Text + '''' else}
              if IsNachValue(edMACHnach) then
                NachStr := '''' + edMACHnach.Text + '''' else
              if IsNachValue(edUSERnach) then
                NachStr := '''' + edUSERnach.Text + '''' else
              if IsNachValue(edVORGnach) then
                NachStr := '''' + edVORGnach.Text + '''' else
                NachStr := 'NAME';
                //EError('NachStr not defined', [0]);
    else
      EError('rgKopiere Value not defined', [0]);
    end;
    Query1.SQL.Text := Format(SqlInsFmt, [TableName,
      GetNachValue(edANWEnach, 'ANWENDUNG'),
      NachStr,  //Name
      GetNachValue(edSECTnach, 'SECTION'),
      TableName]);
    FillParams;
    ProtSQL(Query1);
    QueryExecCommitted(Query1);  //11.10.10 Query1.ExecSql;
    Result := Query1.RowsAffected;
    //09.11.12 QueryDataBase(Query1).Commit;
  except on E:Exception do
    begin
      //09.11.12 try QueryDataBase(Query1).Rollback;
      //         except; {Exception hier uninteressant} end;
      EMess(Query1, E, 'Fehler beim Kopieren', [0]);
      //TDlgSql.Execute(self, Query1, false);
    end;
  end;
end;

end.

