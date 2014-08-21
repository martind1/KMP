unit UUpdateSQL;
(* TUniUpdateSQL modifiziert:
   Wrapper für TUniUpdateSQL
   Ersetzt BDE TUpdateSQL




Letzte Änderung:
09.10.11 md  Erstellen

*)

interface

uses
  SysUtils, Classes, DBAccess, Uni;

type
  TuUpdateSQL = class(TUniUpdateSQL)
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
