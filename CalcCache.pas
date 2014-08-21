unit CalcCache;
(* LookupDefs Cachen
   02.02.07 MD  Init/ExitLuDef: mehrere CalcFields öffnen nur einmal die Table
   12.03.14 md  DoFillCache (experimentell)
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Controls,
  DB,  Uni, DBAccess, MemDS, StdCtrls, DBGrids,
  RechtKmp, KmpResString, DPos_Kmp,
  NLnk_Kmp, LuDefKmp;

type
  TCalcCache = class(TObject)            {Caching von Calc-LookUp-Fields}
  private
    CacheList: TValueList;
  protected
    Owner: TNavLink;
    CalcFieldName, LuFieldName: string;
    CalcField: TField;
    LuDef: TLookUpDef;
    MasterFields: string;
    IndexFields: string;
    CacheFilled: boolean;
  public
    LuField: TField;
    LuDatatype: TFieldType;
    LuSize: integer;
    InitFlag: boolean;
    InitActive: boolean;
    FillCache: boolean;  //LuDef.Options.LuFillCache
    constructor Create(AOwner: TNavLink; ACalcFieldName: string;
                       ALuDef: TLookUpDef; ALuFieldName: string);
    destructor Destroy; override;
    procedure ExitLuDef;
    procedure InitLuDef;
    procedure DoCalcField(ADataSet: TDataSet);
    procedure Clear;  //Cache löschen
    procedure ClearCalcField(ADataSet: TDataSet);  //Cache für aktuellen Wert löschen
    procedure DoFillCache;
  end;

implementation

uses
  Prots, Err__Kmp;

(*** TCalcCache ***************************************************************)

constructor TCalcCache.Create(AOwner: TNavLink; ACalcFieldName: string;
  ALuDef: TLookUpDef; ALuFieldName: string);
var
  {AQuery: TuQuery;}
  AField: TField;
  I1, I2: integer;
begin
  Owner := AOwner;
  LuDef := ALuDef;
  LuFieldName := ALuFieldName;
  CalcFieldName := ACalcFieldName;
  if LuDef = nil then
  begin
    LuDatatype := ftString;
    LuSize := 64;
  end else
  begin
    FillCache := LuFillCache in ALuDef.Options;
    MasterFields := ALuDef.NavLink.MasterFieldNames;
    IndexFields := ALuDef.NavLink.IndexFieldNames;
    I1 := 0;
    I2 := 0;
    try
      if (LuDef.NavLink <> nil) and
         (not LuDef.NavLink.CalcOK or  {07.09.04}
          ((LuDef.DataSet <> nil) and
           (LuDef.DataSet.FieldDefs.Count = 0) and (LuDef.DataSet.FieldCount = 0))) then  //20.10.04
      begin
        LuDef.NavLink.BuildSql;  //14.11.12
        LuDef.NavLink.CalcOK := true;
        LuDef.NavLink.AddCalcFields;
      end;
      I1 := -1; I2 := -2;
      if LuDef.DataSet <> nil then
      begin
        I1 := LuDef.DataSet.FieldDefs.Count;
        I2 := LuDef.DataSet.FieldCount;
      end;
      LuDatatype := ftString;
      LuSize := 250;
      AField := LuDef.DataSet.FieldByName(LuFieldName);
      LuDataType := AField.DataType;
      LuSize := AField.DataSize;
      if LuDatatype in [ftMemo] then
      begin
        LuDatatype := ftString;
        LuSize := 255;
      end;
      //test 24.11.06
      if Sysparam.ProtBeforeOpen then
        Prot0('CalcCache.Create %s=LookUp:%s;%s %d/%d', [CalcFieldName, LuDef.Name, LuFieldName, I1, I2]);
    except on E:Exception do begin
        EProt(self, E, '%s=LookUp:%s;%s %d/%d', [CalcFieldName, LuDef.Name, LuFieldName, I1, I2]);
        if LuDef.DataSet <> nil then
          ProtSql(LuDef.DataSet);
      end;
    end;
  end;
  CacheList := TValueList.Create;
end;

destructor TCalcCache.Destroy;
begin
  CacheList.Free;
  inherited Destroy;
end;

procedure TCalcCache.Clear;
begin
  CacheList.Clear;
  CacheFilled := false;
  // zum Cache neu laden gehört auch das
  if (LuDef = nil) or (LuDef.DataSet = nil) or (LuDef.Mastersource = nil) then
    Exit;
  LuDef.DataSet.Active := InitActive;
end;

procedure TCalcCache.InitLuDef;
// Aufruf in Master.CalcFields
begin
  if (LuDef = nil) or (LuDef.DataSet = nil) or (LuDef.Mastersource = nil) then
    Exit;
  InitFlag := true;
  InitActive := LuDef.DataSet.Active;
  if not LuDef.NoOpen then
  begin
    // LuDef.DataSet.Open;  //27.02.14 test
    //beware InitActive := true;
  end;
  if FillCache and not CacheFilled then
  begin
    CacheFilled := true;
    DoFillCache;
  end;
end;

procedure TCalcCache.ExitLuDef;
begin
  if (LuDef = nil) or (LuDef.DataSet = nil) or (LuDef.Mastersource = nil) then
    Exit;
  InitFlag := false;
  LuDef.DataSet.Active := InitActive;
end;

procedure TCalcCache.DoCalcField(ADataSet: TDataSet);
var
  AParam, AValue, NextS: string;
  AFieldName, AFieldValue: string;
  OldActive: boolean;
begin
  CalcField := ADataSet.FieldByName(CalcFieldName);
  if (LuDef = nil) or (LuDef.DataSet = nil) or (LuDef.Mastersource = nil) then //warum Master? wird unten angesprochen
  begin
    AValue := 'nil';
  end else
  begin
    AParam := '';
    //ADataSet := Owner.DataSet; //LuDef.Mastersource.DataSet; - qpilot 01.06.04
    AFieldName := Trim(PStrTok(MasterFields, ';', NextS));
    while AFieldName <> '' do
    begin
      //AFieldValue := ADataset.FieldByName(AFieldName).AsString;
      AFieldValue := LuDef.Mastersource.DataSet.FieldByName(AFieldName).AsString;  //SWE.GELI 11.11.04
      AppendTok(AParam, AFieldValue, ';');
      AFieldName := Trim(PStrTok('', ';', NextS));
    end;
    if (CacheList.ValueIndex(AParam, @AValue) < 0) then      {OK definiert AValue}
    begin                                                  {noch nicht gecached}
      OldActive := LuDef.DataSet.Active;
      if CacheFilled then
      begin  //wir haben alle Werte. Kann hier nur ein () sein.
        AValue := '';
        CacheList.Values[AParam] := '()';
      end else
      try
        try
          LuDef.DataSet.Open;  //LuDef.NavLink.Refresh; 02.02.07
          LuField := LuDef.DataSet.FieldByName(LuFieldName);
          AValue := GetFieldValue(LuField);
          if AValue = '' then
            CacheList.Values[AParam] := '()' else
            CacheList.Values[AParam] := AValue;
        except on E:Exception do
          EProt(LuDef.DataSet, E, 'DoCalcField(%s)', [AParam]);
        end;
      finally
        if not InitFlag then  //nur wenn außerhalb NLNK verwendet:
          LuDef.DataSet.Active := OldActive;
      end;
      //test 24.11.06
      if Sysparam.ProtBeforeOpen then
        Prot0('DoCalcField(%s.%s)[%s]="%s"', [OwnerDotName(LuDef), CalcFieldName, AParam, AValue]);
    end else
    if AValue = '()' then
      AValue := '';
  end;
  SetFieldValue(CalcField, AValue);
end;

procedure TCalcCache.ClearCalcField(ADataSet: TDataSet);
//einen Wert entfernen aus Cache
var
  AParam, NextS: string;
  AFieldName, AFieldValue: string;
begin
  CalcField := ADataSet.FieldByName(CalcFieldName);
  if (LuDef = nil) or (LuDef.DataSet = nil) or (LuDef.Mastersource = nil) then //warum Master? wird unten angesprochen
  begin
  end else
  begin
    AParam := '';
    //ADataSet := Owner.DataSet; //LuDef.Mastersource.DataSet; - qpilot 01.06.04
    AFieldName := Trim(PStrTok(MasterFields, ';', NextS));
    while AFieldName <> '' do
    begin
      //AFieldValue := ADataset.FieldByName(AFieldName).AsString;
      AFieldValue := LuDef.Mastersource.DataSet.FieldByName(AFieldName).AsString;  //SWE.GELI 11.11.04
      AppendTok(AParam, AFieldValue, ';');
      AFieldName := Trim(PStrTok('', ';', NextS));
    end;
    CacheList.Values[AParam] := '';  //Wert entfernen
  end;
  CacheFilled := false;
end;

procedure TCalcCache.DoFillCache;
//Cache mit allen Werten der LuDef füllen. Experimentell.
var
  AParam, NextS: string;
  AFieldName, AFieldValue: string;
  AValue: string;
  OldRef: TFltrList;
begin
  if (LuDef = nil) or (LuDef.DataSet = nil) or (LuDef.Mastersource = nil) then //warum Master? wird unten angesprochen
    Exit;

  CacheList.Clear;
  OldRef := TFltrList.Create;
  try
    //LuDef: References: Masterfields entfernen
    OldRef.Assign(LuDef.References);
    AFieldName := Trim(PStrTok(IndexFields, ';', NextS));
    while AFieldName <> '' do
    begin
      LuDef.References.Values[AFieldName] := '';

      AFieldName := Trim(PStrTok('', ';', NextS));
    end;
    LuDef.DataSet.Open;

    while not LuDef.DataSet.EOF do
    begin
      AParam := '';
      AFieldName := Trim(PStrTok(IndexFields, ';', NextS));
      while AFieldName <> '' do
      begin
        AFieldValue := LuDef.DataSet.FieldByName(AFieldName).AsString;
        AppendTok(AParam, AFieldValue, ';');
        AFieldName := Trim(PStrTok('', ';', NextS));
      end;

      LuField := LuDef.DataSet.FieldByName(LuFieldName);
      AValue := GetFieldValue(LuField);
      if AValue = '' then
        CacheList.Values[AParam] := '()' else
        CacheList.Values[AParam] := AValue;

      LuDef.DataSet.Next;
    end;
  finally
    LuDef.References.Assign(OldRef);
    OldRef.Free;
  end;
end;


end.
