unit UDS__Kmp;
(* TuDataSource - Wrapper für TUniDataSource - ersetzt TLDataSource
13.06.11 md  erstellt
*)
interface

uses
  SysUtils, Classes, DB, DBAccess, Uni;

type
  TuDataSource = class(TUniDataSource)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
  published
    { Published-Deklarationen }
  end;

implementation

end.
