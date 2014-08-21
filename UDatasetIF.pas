unit UDatasetIF;
(* Interface für UTbl und UQue
11.10.11 md  erstellt UniDAC
*)

interface

uses
  classes,
  UDB__Kmp;

type
  IUDataset = interface
    ['{78C3DD53-ED5B-4165-9550-A17A124E3411}']
    function GetDatabaseName: string;
    procedure SetDatabaseName(const Value: string);
    function GetDataBase: TuDataBase;
    procedure SetDataBase(const Value: TuDataBase);
    function GetSessionName: string;
    procedure SetSessionName(const Value: string);

    function GetTag: Integer;
    function GetComponent: TObject;
  end;

implementation

end.
