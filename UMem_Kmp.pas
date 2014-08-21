unit UMem_Kmp;
(* TMemDataSet (Uni) ersetzt TInMemoryTable
   Wrapper für TVirtualTable
   Letzte Änderung:
   06.06.11 md  Erstellen
                Databasename
                SessionName
                TableName  (Flddesc)
                für QNav
   31.10.11 md  Interface, ReadOnly, CreateTable
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, DB,  Uni, DBAccess, MemDS,
  VirtualTable, UDB__Kmp, UDatasetIF;

type
  TuMemTable = class(TVirtualTable, IUDataset)
  private
    FSessionName: string;
    FTableName: string;
    FDatabaseName: string;
    FReadOnly: boolean;
    { Private-Deklarationen }
    function GetTag: Integer;  //für Interface
    function GetComponent: TObject;
    function GetDataBase: TuDataBase;  //für Interface
    procedure SetDataBase(const Value: TuDataBase);
    function GetDatabaseName: string;
    function GetSessionName: string;
    function GetTableName: string;
    procedure SetDatabaseName(const Value: string);
    procedure SetSessionName(const Value: string);
    procedure SetTableName(const Value: string);
    procedure SetReadOnly(const Value: boolean);
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
  public
    { Public-Deklarationen }
    procedure CreateTable;
  published
    { Published-Deklarationen }
    property DatabaseName: string read GetDatabaseName write SetDatabaseName;
    property SessionName: string read GetSessionName write SetSessionName;
    property TableName: string read GetTableName write SetTableName;
    property ReadOnly: boolean read FReadOnly write SetReadOnly default False;
  end;

implementation

uses
  Prots, Err__Kmp, GNav_Kmp;

{ TuMemTable }

procedure TuMemTable.CreateTable;
begin
  //macht nichts. In unidac nicht notwendig.
end;

function TuMemTable.GetComponent: TObject;
begin
  Result := self;
end;

function TuMemTable.GetDataBase: TuDataBase;
begin
  Result := nil;
end;

function TuMemTable.GetDatabaseName: string;
begin
  Result := FDatabaseName;
end;

procedure TuMemTable.SetDatabaseName(const Value: string);
begin
  FDatabaseName := Value;
end;

procedure TuMemTable.SetReadOnly(const Value: boolean);
begin
  FReadOnly := Value;
end;

function TuMemTable.GetSessionName: string;
begin
  Result := FSessionName;
end;

procedure TuMemTable.SetSessionName(const Value: string);
begin
  FSessionName := Value;
end;

procedure TuMemTable.SetDataBase(const Value: TuDataBase);
begin
  //keine Aktion da In Memory
end;

function TuMemTable.GetTableName: string;
begin
  Result := FTableName;
end;

procedure TuMemTable.SetTableName(const Value: string);
begin
  FTableName := Value;
end;

function TuMemTable.GetTag: Integer;
begin
  Result := self.Tag;
end;

procedure TuMemTable.Loaded;
begin
  inherited;
end;

end.
