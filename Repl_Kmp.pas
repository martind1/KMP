unit Repl_Kmp;
(* Replikator Komponente
   05.10.97 MD Erstellt
*)   
interface

uses
  WinProcs, WinTypes, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, DB,  Uni, DBAccess, MemDS,
  DPos_Kmp, UTbl_Kmp;

type
  TRepl = class(TuTable)
  private
    { Private-Deklarationen }
    FPKeyValues: TDataPos;
    FKillList: TStringList;
    procedure SetKillList( Value: TStringList);
  protected
    { Protected-Deklarationen }
    NewId: longint;
    PKeyList: TValueList;
    procedure Loaded; override;
    function PKeyValues( ATableName: string; ATable: TDataSet): TStringList;
    procedure Event( ATableName: string; ATable: TDataSet; Op: string);
  public
    { Public-Deklarationen }
    constructor Create( AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Edi( ATableName: string; ATable: TDataSet);
    procedure Ins( ATableName: string; ATable: TDataSet);
    procedure Upd( ATableName: string; ATable: TDataSet);
    procedure Del( ATableName: string; ATable: TDataSet);
  published
    { Published-Deklarationen }
    property KillList: TStringList read FKillList write SetKillList;
  end;

var
  Repl: TRepl;

implementation

uses
  Prots,
  USes_Kmp;

procedure TRepl.SetKillList( Value: TStringList);
begin
  FKillList.Assign( Value);
end;

function TRepl.PKeyValues( ATableName: string; ATable: TDataSet): TStringList;
begin
  FPKeyValues.Clear;
  FPKeyValues.AddFieldsValue( ATable, PKeyList.Values[ATableName]);
  result := FPKeyValues;
end;

constructor TRepl.Create( AOwner: TComponent);
begin
  inherited Create( AOwner);
  Repl := self;
  PKeyList := TValueList.Create;
  FPKeyValues := TDataPos.Create;
  FKillList := TStringList.Create;
  FKillList.Add('REPL');
end;

destructor TRepl.Destroy;
begin
  PKeyList.Free; PKeyList := nil;
  FPKeyValues.Free; FPKeyValues := nil;
  FKillList.Free; FKillList := nil;
  Repl := nil;
  inherited Destroy;
end;

procedure TRepl.Loaded;
(* - PKey --> PKeys
   - Aktueller Max. ID-Wert --> NewId *)
var
  TableNames: TStringList;
  ATable: TuTable;
  I: integer;
  IndexFields: string;
begin
  inherited Loaded;
  if csDesigning in ComponentState then
    Exit;
  SMess('Replikation wird initialisiert (%s)',['']);
  Open;
  Last;
  NewId := FieldByName('REPL_ID').AsInteger + 1;
  Close;
  TableNames := TStringlist.Create;
  ATable := TuTable.Create(self);
  ATable.DataBaseName := DataBaseName;
  ATable.SessionName := QueryDatabase(DataBaseName).SessionName;
  try
    USession.GetTableNames(DataBaseName, TableNames, false);
    for I:= 0 to TableNames.Count-1 do
    begin
      ATable.TableName := TableNames.Strings[I];
      IndexFields := IndexInfo(ATable.Database, ATable.TableName);
      SMess('Replikation wird initialisiert (%s.%s)',[ATable.TableName, IndexFields]);
//      ATable.Open;
//      for J := 0 to ATable.FieldCount-1 do
//      begin
//        AField := ATable.Fields[J];
//        if AField.IsIndexField then
//          if IndexFields = '' then
//            IndexFields := AField.FieldName else
//            IndexFields := IndexFields + ';' + AField.FieldName;
//        SMess('Replikation wird initialisiert (%s.%s)',[ATable.TableName, AField.FieldName]);
//      end;
//      ATable.Close;
      PKeyList.Add( ATable.TableName + '=' + IndexFields);
    end;
  finally
    ATable.Free;
    TableNames.Free;
    SMess('',[0]);
  end;
end;

procedure TRepl.Event( ATableName: string; ATable: TDataSet; Op: string);
begin
  if KillList.IndexOf( OnlyTableName( ATableName)) >= 0 then
    Exit;
  Open;
  Insert;
  Inc( NewId);
  FieldByName('REPL_ID').AsInteger := NewId;
  FieldByName('OP').AsString := Op;
  FieldByName('TABLENAME').AsString := ATableName;
  FieldByName('PKEY').Assign( PKeyValues( ATableName, ATable));
  Post;
end;

procedure TRepl.Edi( ATableName: string; ATable: TDataSet);
begin              {Editieren wird eingeleitet}
end;

procedure TRepl.Ins( ATableName: string; ATable: TDataSet);
begin
  Event( ATableName, ATable, 'I');
end;

procedure TRepl.Upd( ATableName: string; ATable: TDataSet);
begin
  Event( ATableName, ATable, 'U');
end;

procedure TRepl.Del( ATableName: string; ATable: TDataSet);
begin
  Event( ATableName, ATable, 'D');
end;

end.
