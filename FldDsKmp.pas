unit FldDsKmp;
(* Field Descriptions global verwalten
   TFldDsc ist eine TStringlist|Objects i.d.F. <TableName>|<TFieldDefs
   GetFieldDef(ADBName,ATblName,AFieldName) liefert TFieldDef eines Feldes.
   Falls die Feldbeschreibung noch nicht bekannt wird sie von einer
   temporären TuQuery übernommen.
   09.12.03 MD  selects über mehrere Schemas werden erkannt i.d.F.
                 select F1, F2 from Schema1.T1, Schema2.T2
   01.11.04 MD  TableSynonyms; ComponentList
   07.02.06 MD  DBName -> ADatabase
   06.06.11 md  test mit uni
   28.12.11 md  Erkennung von "max(F1) as FN1" -> Feld F1 wird erkannt
   04.11.12 md  Blacki: EAccess bei dac160.bpl:
*)
interface

uses
  Windows,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UDB__KMP, UQue_Kmp, UMem_Kmp,
  DB,  Uni, DBAccess, MemDS, contnrs,
  DPos_Kmp;

type
  TFldDsc = class(TValueList)
  private
    { Private-Deklarationen }
    QueryList: TComponentList;
    InvalidDatasetList: TComponentList;  //vergeblich gelesene Datasets
    function GetFieldDef(ADatabase: TuDatabase; ATblName, AFieldName: string): TFieldDef;
    procedure CheckOraUnicodeBug(aFieldDefs: TFieldDefs);
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create;
    destructor Destroy; override;
    function CreateFieldDefs(ADatabase: TuDatabase; var ATblName: string): TFieldDefs;
    procedure Update(ADataSet: TDataSet; ATblName: string;
      ASqlFieldList: TValueList);
    function GetFieldInfo(ADatabase: TuDatabase; var ATblName, AFieldName: string;
      var AFieldDef: TFieldDef): boolean;
    property FieldDef[ADatabase: TuDatabase; ATblName, AFieldName: string]: TFieldDef
      read GetFieldDef;
  public
    class function IsDataTypeStr(S: string): boolean;  //ergibt true wenn S=integer,float usw.
  end;

  function FldDsc: TFldDsc;

implementation

uses
  StrUtils,
  Prots, Err__Kmp, GNav_Kmp;

const
  SDummy = 'Dummy';

var
  FFldDsc: TFldDsc;

class function TFldDsc.IsDataTypeStr(S: string): boolean;
begin
  Result := MatchText(S, [
    'String', 'WideString', 'Integer', 'Float', 'DateTime', 'BCD']);
end;

procedure TFldDsc.CheckOraUnicodeBug(aFieldDefs: TFieldDefs);
begin
//2011/UnioDAC wieder in Betracht zu ziehen:
//  if SysParam.OraUnicodeBug then
//  begin
//    for I := 0 to aFieldDefs.Count - 1 do
//    begin
//      if (aFieldDefs.Items[I].DataType = ftWideString) and
//         (aFieldDefs.Items[I].Size >= 4) and
//         (aFieldDefs.Items[I].Size <= 255*4) and
//         ((aFieldDefs.Items[I].Size mod 4) = 0) then
//        aFieldDefs.Items[I].Size := aFieldDefs.Items[I].Size div 4;
//    end;
//  end;
end;

function TFldDsc.GetFieldDef(ADatabase: TuDatabase; ATblName, AFieldName: string): TFieldDef;
begin
  result := nil;
  GetFieldInfo(ADatabase, ATblName, AFieldName, result);
end;

function TFldDsc.GetFieldInfo(ADatabase: TuDatabase; var ATblName, AFieldName: string;
  var AFieldDef: TFieldDef): boolean;
(* liefert TableName, FieldName (Groß/Klein korrigiert)
   und FieldDef (nil bei Fehler)
   ergibt true wenn gefunden *)

  function FDef(ATName, AFName: string): boolean;
  var
    I: integer;
    AFieldDefs: TFieldDefs;
  begin
    result := false;
    if IndexOf(ATName) >= 0 then
    begin
      AFieldDefs := TFieldDefs(Objects[IndexOf(ATName)]);
      if AFieldDefs <> nil then
      try
        for I := 0 to AFieldDefs.Count - 1 do
          if CompareText(AFieldDefs[I].Name, AFName) = 0 then
          begin
            AFieldDef := AFieldDefs[I];
            AFieldName := AFieldDef.Name;    {Großschrift}
            ATblName := ATName;
            result := true;
            break;
          end;
      except on E:Exception do begin
          //Eaccess wenn von fremder Session (sdbl.dokwFrm)
          EProt(self, E, 'FieldDefs(%s)', [ATName]);
          Objects[IndexOf(ATName)] := nil;
        end;
      end;
    end;
  end;

  function RemoveRemarks(S: string): string;
  // "/* aha */ fn" -> fn
  //  1      8
  var
    P1, P2: integer;
    S1: string;
  begin
    S1 := S;
    P1 := Pos('/*', S1);
    if P1 > 0 then
    begin
      P2 := PosR('*/', S1);
      if P2 > P1 then
        System.Delete(S1, 1, P2 - P1 + 2);
    end;
    Result := Trim(S1);
  end;

var
  S1, NextS: string;
  P, P1: integer;
  ATblList: TValueList;
  I: integer;
  TName: string;
  FName: string;
begin { GetFieldInfo }
  result := false;
  AFieldDef := nil;
  // distinct TN.FN -> FN (distinct FN bleibt); "/* hint allOpts */ FN" -> FN
  FName := OnlyFieldName(RemoveRemarks(AFieldName));
  P := Pos(' ', FName);
  if P > 0 then
    FName := copy(FName, P + 1, 250);          {distinct FN -> FN}
  P := Pos(':', FName);     //F:string
  if P > 0 then
  begin  //mit Fomatangebe    F:string, F:integer, F:float, F:DateTime
    TName := SDummy;
    CreateFieldDefs(ADatabase, TName);
    S1 := copy(FName, 1, P - 1);
    FName := 'ft' + copy(FName, P + 1, 250);  //für FDef: ftFloat, String, Integer, DateTime
    result := FDef(SDummy, FName);
    AFieldName := S1;   //F
  end else
  begin
    P1 := Pos('(', AFieldName);
    if P1 = 0 then      {Test auf Fkt Max() o.ä.}
    begin
      P := Pos('.', AFieldName);        //T1.F1
      if P > 0 then
      begin                                               {Table ist vorgeschrieben}
        TName := copy(AFieldName, 1, P - 1);    {distinct TN.FN -> distinct TN}
        P := Pos(' ', TName);
        if P > 0 then
          TName := copy(TName, P + 1, 250);          {distinct TN -> TN}
        ATblList := TValueList.Create;
        try
          ATblList.AddTokens(ATblName, ';');
          for I := 0 to ATblList.Count - 1 do
            if SameText(TName, OnlyFieldName(StrParam(ATblList[I]))) then
            begin                             //Tkurz=Tlang
              TName := StrValueDflt(ATblList[I]);    {TN -> <Schema>.TN}
              break;
            end;
        finally
          ATblList.Free;
        end;
        CreateFieldDefs(ADatabase, TName);
        result := FDef(TName, FName);
      end else
      begin
        TName := Trim(StrValueDflt(PStrTok(ATblName, ';', NextS)));
        while (TName <> '') and not result do
        begin
          CreateFieldDefs(ADatabase, TName);
          result := FDef(TName, FName);
          TName := Trim(StrValueDflt(PStrTok('', ';', NextS)));
        end;
      end;
    end else
    begin  //Funktion max(fldname) - 26.12.11
//schlecht: ergibt falsche Parameter (tmb2.meda.maxpage)
//      P2 := Pos(')', AFieldName);
//      if P2 > P1 + 1 then
//      begin
//        FName := Trim(Copy(AFieldName, P1 + 1, P2 - P1 - 1));
//        TName := Trim(StrValueDflt(PStrTok(ATblName, ';', NextS)));
//        while (TName <> '') and not result do
//        begin
//          CreateFieldDefs(ADatabase, TName);
//          result := FDef(TName, FName);
//          TName := Trim(StrValueDflt(PStrTok('', ';', NextS)));
//        end;
//      end;
    end;
  end;
end;

function TFldDsc.CreateFieldDefs(ADatabase: TuDatabase; var ATblName: string): TFieldDefs;
var
  AQuery: TuQuery;
  ATable: TuMemTable;  //für Dummy
  ADataSet: TDataSet;
  I: integer;
  S, WhereClause: string;
  Updated: boolean;
  ErrNr: integer;
begin                                                                           ErrNr := 0;
  result := nil;
  AQuery := nil;
  ADataSet := nil;
  // ADatabase = nil wird in Except mit einer Fehlermeldung abgefangen
  try
    if GNavigator <> nil then
      ATblName := StrDflt(GNavigator.TableSynonyms.Values[ATblName], ATblName);
    I := IndexOf(ATblName);                                                     ErrNr := 1;
    if I < 0 then
    try
      if ATblName = SDummy then
      begin                                                                     ErrNr := 2;
        ATable := TuMemTable.Create(nil);                                       ErrNr := 3;
        //beware ATable.DatabaseName := ADatabase.DatabaseName;
        //beware ATable.SessionName := ADatabase.SessionName;
        ADataSet := ATable;
        //ATable.TableType := ttParadox;
        //beware ATable.TableName := SDummy;
        with ATable.FieldDefs do
        begin
          Clear;
          with AddFieldDef do
          begin
            Name := 'ftString';
            DataType := ftString;
            Size := 250;
          end;
          with AddFieldDef do
          begin
            Name := 'ftWideString';
            DataType := ftWideString;
            Size := 250;
          end;
          with AddFieldDef do
          begin
            Name := 'ftInteger';
            DataType := ftInteger;
          end;
          with AddFieldDef do
          begin
            Name := 'ftFloat';
            DataType := ftFloat;
          end;
          with AddFieldDef do
          begin
            Name := 'ftDateTime';
            DataType := ftDateTime;
          end;
          with AddFieldDef do
          begin
            Name := 'ftBCD';      //BCD webab - 28.11.08
            DataType := ftBCD;
          end;
        end;
        result := ATable.FieldDefs;
      end else
      begin                                                                     ErrNr := 4;
        AQuery := TuQuery.Create(ADatabase);                                    ErrNr := 5;
        ADataSet := AQuery;
        AQuery.Sql.Clear;
        S := '';
        if GNavigator <> nil then
        begin
          S := GNavigator.TableSynonyms.Values[ATblName];
          if S = '' then   //K=Kunden ->Kunden; K ->K
            S := GNavigator.TableSynonyms.Values[StrValueDflt(ATblName)];
        end;
        if S = '' then
          S := StrValueDflt(ATblName);
        SDebg('Lese C %s', [S]);  //hier S noch ohne WhereClause
        if Pos('ENTS', S) > 0 then
          Debug0;
        Updated := false;                                                       ErrNr := 6;
        if (GNavigator <> nil) and Assigned(GNavigator.OnUpdateFieldDefs) then
        try  //insbesondere für MSSQL ClearStatistics
          GNavigator.OnUpdateFieldDefs(AQuery, S, Updated);
          //nur bei unbekannten S/TblNames. Kann FldDsWhereSql aktiv ändern.
          //wenn Updated=true muss Query1.FieldDefs zugewiesen sein
        except on E:Exception do
          EProt(self, E, 'CreateFieldDefs(%s)', [ATblName]);
        end;
        if not Updated then
        begin
          if GNavigator = nil then
            WhereClause := '1=0' else
            WhereClause := StrDflt(GNavigator.FldDsWhereSql.Values[S], '1=0');  //02.05.09
          if WhereClause <> '' then
            S := S + ' where ' + WhereClause;
          AQuery.Sql.Add(Format('select * from %s', [S]));
          AQuery.FieldDefs.Update;
          SDebg('OK', [0]);
        end;
        CheckOraUnicodeBug(AQuery.FieldDefs);                                   ErrNr := 7;
        result := AQuery.FieldDefs;
        SMess0;
      end;
      if not (csDesigning in ADataSet.ComponentState) then
        AddObject(ATblName, result);
    finally
      if ADataSet <> nil then
        QueryList.Add(ADataSet);
      SMess0;
    end else
      result := TFieldDefs(Objects[I]);
  except on E:Exception do
    begin
      {if not (csDesigning in Application.ComponentState) then
        AddObject(ATblName, result);  Probleme im Designer}
      if EIsNoSuchTableFehler(E) then
      begin
        if (AQuery <> nil) and not (csDesigning in AQuery.ComponentState) then
          AddObject(ATblName, result);
      end else
      if (E is EAccessViolation) and DelphiRunning then
      begin
        //passiert wenn Form mit DB nicht im Editor
      end else
      begin
        if ADatabase = nil then
          EProt(Application, E, 'CreateFieldDefs(nil,%s):%d', [ATblName, ErrNr]) else
          EProt(Application, E, 'CreateFieldDefs(%s,%s):%d', [ADatabase.Databasename, ATblName, ErrNr]);
      end;
    end;
  end;
end;

procedure TFldDsc.Update(ADataSet: TDataSet; ATblName: string;
  ASqlFieldList: TValueList);
var
  ErrNr: integer;
  ErrSt: string;

  procedure AddFDef(AFDef: TFieldDef; AFieldName: string);
  var
    I: integer;
  begin
    I := 0;
    while ADataSet.FieldDefs.IndexOf(AFieldName) >= 0 do
    begin
      ErrNr := 10 + I;
      Inc(I);
      AFieldName := Format('%s_%d', [AFDef.Name, I]);
    end;
    ErrNr := 100;
    //04.11.12 EAccessError in dac160.bpl zur Designzeit.
    ErrSt := Format('(%d,%d,%d,Name:%s,%d,%d,%d)', [ADataSet.FieldCount, ADataSet.FieldDefs.Count,
      ord(ADataSet.FieldDefs.Updated),
      AFieldName, ord(AFDef.DataType), AFDef.Size, ord(AFDef.Required)]);
    if not (csDesigning in ADataSet.ComponentState) then  //09.11.12 EAccessError
    begin
      ADataSet.FieldDefs.Add(AFieldName, AFDef.DataType, AFDef.Size, AFDef.Required);
    end;
    ErrNr := 101;
    //04.11.12 bringt nix:
//    with ADataSet.FieldDefs.AddFieldDef do
//    begin                                               ErrNr := 101;
//      {FieldNo is defaulted}
//      Name := AFieldName;                               ErrNr := 102;
//      DataType := AFDef.DataType;                       ErrNr := 103;
//      Size := AFDef.Size;                               ErrNr := 104;
//      { Precision is defaulted }
//      Required := AFDef.Required;                       ErrNr := 105;
//    end;
  end;
var
  AFieldDef: TFieldDef;
  AFieldDefs: TFieldDefs;
  I: integer;
  S1, NextS: string;
  ADatabase: TuDatabase;
  AFieldDefName: string;
begin
  ErrNr := 0;
  ErrSt := '';
  if {(Pos(';', ATblName) = 0) and    Nein QDispo Hirschau 080501}
     (ADataSet.FieldDefs.Count = 0) and not (ADataSet is TuMemTable) then
  try                                                                ErrNr := 1;
    {ADataSet.FieldDefs.Clear;}
    if ADataSet is TuQuery then
      ADatabase := QueryDatabase(TuQuery(ADataSet)) else
      ADatabase := nil;
    if (ASqlFieldList <> nil) and (ASqlFieldList.Count > 0) then
    begin                                                            ErrNr := 2;
      for I := 0 to ASqlFieldList.Count - 1 do
      begin
        if (ASqlFieldList[I] = '') or (Char1(ASqlFieldList[I]) = ';') or
           BeginsWith(ASqlFieldList[I], '/*') then
          Continue;
        AFieldDef := nil;
        AFieldDefName := ASqlFieldList.Param(I);
        S1 := ATblName;
        GetFieldInfo(ADatabase, S1, AFieldDefName, AFieldDef);
        if (AFieldDef = nil) and (ASqlFieldList.Value(I) <> '') then
        begin   {FN=TN.FN1}
          AFieldDef := GetFieldDef(ADatabase, ATblName, ASqlFieldList.Value(I));
          AFieldDefName := ASqlFieldList.Param(I);
        end;                                                         ErrNr := 3;
        if AFieldDef = nil then
        begin
          ADataSet.FieldDefs.Clear;       {vorbereiten für BDE}
          break;
        end else
          AddFDef(AFieldDef, AFieldDefName);
      end;
    end else
    //04.11.12 EAccess bei dac160.bpl:
    //09.11.12 Violation auch bei Runtime: komplett deaktivieren:
    //         NEIN: Calcfields müssen ergänzt werden!  and false
    //jetzt in Add FDef: if not (csDesigning in ADataSet.ComponentState) then
    begin
      S1 := Trim(StrValueDflt(PStrTok(ATblName, ';', NextS))); {t1=sch.tbl1;t2 -> sch.tbl1}
      ADataSet.FieldDefs.BeginUpdate;
      try
        while S1 <> '' do
        begin                                                          ErrNr := 4;
          AFieldDefs := CreateFieldDefs(ADatabase, S1);                ErrNr := 5;
          if AFieldDefs <> nil then
          begin
            for I := 0 to AFieldDefs.Count - 1 do
              AddFDef(AFieldDefs[I], AFieldDefs[I].Name);          //ErrNr ab 10
          end;
          S1 := Trim(StrValueDflt(PStrTok('', ';', NextS)));
        end;
      finally
        ADataSet.FieldDefs.EndUpdate;
      end;
    end;
  except on E:Exception do
    EProt(ADataSet, E, 'FldDsc.Update%d%s(%s)', [ErrNr, ErrSt, ATblName]);
  end;
  if ADataSet.FieldDefs.Count = 0 then
  try
    I := InvalidDatasetList.IndexOf(ADataSet);
    if I < 0 then
    begin
      if (ATblName = '') and (ADataSet is TuQuery) then  //wenn ludef.tablename=''
        SMess('Lese U %s', [RemoveCRLF(TuQuery(ADataSet).Text)]) else
        SMess('Lese U %s', [ATblName]);
      if SysParam.ProtBeforeOpen then
      begin
        Prot0('Lese U %s', [OwnerDotName(ADataSet)]);
        ProtSql(ADataSet);
      end;
      ADataSet.FieldDefs.Update;      {wir können das nicht. Solls die BDE machen:}
      CheckOraUnicodeBug(ADataSet.FieldDefs);
      if SysParam.ProtBeforeOpen then
        Prot0('Gelesen U %s', [ATblName]);
    end;
  except on E:Exception do begin
      InvalidDatasetList.Add(ADataSet);
      if (GNavigator <> nil) and (GNavigator.DB1 <> nil) then
        EProt(ADataSet, E, 'FieldDefs.InvalidDataset(%s)', [OwnerDotName(ADataSet)]);
    end;
  end;
  SMess0;
end;

function FldDsc: TFldDsc;
begin
  if FFldDsc = nil then
    FFldDsc := TFldDsc.Create;
  Result := FFldDsc;
end;

constructor TFldDsc.Create;
begin
  QueryList := TComponentList.Create(false);           //true bringt RTE bei final
  InvalidDatasetList := TComponentList.Create(false); //OwnsObjects := false;
end;

destructor TFldDsc.Destroy;
var
  I: integer;
begin
  try
    for I := QueryList.Count - 1 downto 0 do
      TDataSet(QueryList[I]).Free;
  except
    Debug0;
  end;
  QueryList.Free;
  InvalidDatasetList.Free;
  inherited;
end;

{$ifdef WIN32}
{$else}
procedure DestroyGlobals; far;
begin
  if FFldDsc <> nil then
  begin
    FFldDsc.Free;
    FFldDsc := nil;
  end;
end;
{$endif}

initialization
  FFldDsc := nil;
{$ifdef WIN32}
finalization
  if FFldDsc <> nil then
    FreeAndNil(FFldDsc);
{$else}
  AddExitProc(DestroyGlobals);
{$endif}

end.

