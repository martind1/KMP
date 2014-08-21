unit PropEds;
(* Property Editoren Designtime
30.09.02 MD  hier zusammengefasst
02.11.11 md  TAliasNameProperty
*)
interface

uses
  Classes,
  DesignIntf, DesignEditors, TypInfo;

{ TPagebookProperty (TLNavigator) }
type
  TPagebookProperty = class(TComponentProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

{ TTabSetProperty (TLNavigator) }
type
  TTabSetProperty = class(TComponentProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

{ TDragFieldNameProperty (TMultiGrid) }

  TDragFieldNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{ TDruckerTypProperty }

  TDruckerTypProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{ TAswNameProperty }

  TAswNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{ TAliasNameProperty }

  TAliasNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{ TQRDBStringProperty }

  TQRDBStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual; abstract;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{ TDataFieldProperty }

  TQRDataFieldProperty = class(TQRDBStringProperty)
  public
    function GetDataSetPropName: string; virtual;
    procedure GetValueList(List: TStrings); override;
  end;

{ TDateFieldProperty }

  TDateFieldProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{ TIniDBStringProperty }

  TIniDBStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{ TIniDatabaseNameProperty (TIniDb) }

type
  TIniDatabaseNameProperty = class(TIniDBStringProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

implementation

uses
  extctrls, comctrls, db, tabs, SysUtils, USes_Kmp,
  Ini__Kmp, LNav_Kmp, Asws_Kmp, IniDbKmp;

{ TPagebookProperty }

procedure TPagebookProperty.GetValues(Proc: TGetStrProc);
begin
  Designer.GetComponentNames(GetTypeData(TypeInfo(TNotebook)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TPageControl)), Proc);
end;

procedure TPagebookProperty.SetValue(const Value: string);
begin
  inherited;

end;

{ TTabSetProperty }

procedure TTabSetProperty.GetValues(Proc: TGetStrProc);
begin
  Designer.GetComponentNames(GetTypeData(TypeInfo(TTabSet)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TTabControl)), Proc);
end;

procedure TTabSetProperty.SetValue(const Value: string);
begin
  inherited;

end;

{ TDragFieldNameProperty }

function TDragFieldNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paValueList, paSortList];
end;

procedure TDragFieldNameProperty.GetValues(Proc: TGetStrProc);
var
  Instance: TComponent;
  PropInfo: PPropInfo;
  DataSource: TDataSource;
  List: TStringList;
  I: Integer;
begin
  Instance := TComponent(GetComponent(0));
  PropInfo := TypInfo.GetPropInfo(Instance.ClassInfo, 'DataSource');
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
  begin
    List := TStringList.Create;
    try
      DataSource := TObject(GetOrdProp(Instance, PropInfo)) as TDataSource;
      if (DataSource <> nil) and (DataSource.DataSet <> nil) then
      begin
        DataSource.DataSet.GetFieldNames(List);
        for I := 0 to List.Count-1 do
          Proc(List[I]);
      end;
    finally
      List.Free;
    end;
  end;
end;

{ TDruckerTypProperty }

function TDruckerTypProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paValueList];
end;

procedure TDruckerTypProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  if IniKmp <> nil then {Ini-Komponetnte da}
  begin
    for I := 0 to IniKmp.DruckerTypen.Count-1 do
      Proc(IniKmp.DruckerTypen[I]);
  end else
    Proc('(no IniKmp)');
end;

{ TAswNameProperty }

function TAswNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paValueList, paSortList];
end;

procedure TAswNameProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Asw1: TAsw;
begin
  I := Asws.FirstAsw(Asw1);
  while I > 0 do
  begin
    Proc(copy(Asw1.Name, 4, 100));
    I := Asws.NextAsw(I, Asw1);
  end;
end;

{ TAliasNameProperty }

function TAliasNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paValueList, paSortList];
end;

procedure TAliasNameProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  if (USession <> nil) and (USession.AliasList <> nil) then
  begin
    if (USession.AliasList.Count > 0) then
    begin
      for I := 0 to USession.AliasList.Count - 1 do
        Proc(USession.AliasList[I].AliasName);
    end else
      Proc('FN'+USession.AliasFilename);
  end else
  if USession = nil then
    Proc('USession = nil')
  else if USession.AliasList = nil then
    Proc('Aliaslist = nil') else
    Proc('wasanderes');

end;

{ TQRDBStringProperty }

function TQRDBStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

procedure TQRDBStringProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

{ TQRDataFieldProperty }

function TQRDataFieldProperty.GetDataSetPropName: string;
begin
  Result := 'DataSet'; {<-- do not resource}
end;

procedure TQRDataFieldProperty.GetValueList(List: TStrings);
var
  Instance: TComponent;
  PropInfo: PPropInfo;
  DataSet: TDataSet;
begin
  Instance := TComponent(GetComponent(0));
  PropInfo := TypInfo.GetPropInfo(Instance.ClassInfo, GetDataSetPropName);
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
  begin
    DataSet := TObject(GetOrdProp(Instance, PropInfo)) as TDataSet;
    if (DataSet <> nil) then
      DataSet.GetFieldNames(List);
  end;
end;

{ TDateFieldProperty }

function TDateFieldProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paValueList];
end;

procedure TDateFieldProperty.GetValues(Proc: TGetStrProc);
var
  Instance: TComponent;
  PropInfo: PPropInfo;
  DataSource: TDataSource;
  I: Integer;
begin
  Instance := TComponent(GetComponent(0));
  PropInfo := TypInfo.GetPropInfo(Instance.ClassInfo, 'DataSource');
  if (PropInfo <> nil) and (PropInfo^.PropType^.Kind = tkClass) then
  begin
    DataSource := TObject(GetOrdProp(Instance, PropInfo)) as TDataSource;
    if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    begin
      DataSource.DataSet.Fielddefs.Update;
      for I := 0 to DataSource.DataSet.FieldDefs.Count-1 do
        if DataSource.DataSet.FieldDefs[I].DataType in [ftDate, ftTime, ftDateTime] then
          Proc(DataSource.DataSet.FieldDefs[I].Name);
    end;
  end;
end;

{ TIniDBStringProperty (TIniDb) }

function TIniDBStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

procedure TIniDBStringProperty.GetValueList(List: TStrings);
begin
end;

procedure TIniDBStringProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  Values: TStringList;
begin
  Values := TStringList.Create;
  try
    GetValueList(Values);
    for I := 0 to Values.Count - 1 do Proc(Values[I]);
  finally
    Values.Free;
  end;
end;

{ TIniDatabaseNameProperty (TIniDb) }

procedure TIniDatabaseNameProperty.GetValueList(List: TStrings);
begin
  //(GetComponent(0) as TIniDbKmp).Query.Session.GetDatabaseNames(List);
  USession.GetDatabaseNames(List);
end;

end.
