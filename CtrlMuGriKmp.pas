unit CtrlMuGriKmp;
(* DBCtrlGrid Komponente. Ersetzt TDBCtrlGrid

   Autor: Martin Dambach
   Letzte Änderung
   01.05.13    Erstellen: Maus Scroll verschiebt Zeile
*)

interface

uses
  System.SysUtils, System.Classes, System.Types, Vcl.Controls, Vcl.DBCGrids, Messages;

type
  TCtrlMultiGrid = class(TDBCtrlGrid)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
  public
    { Public-Deklarationen }
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Data.DB;

{ TCtrlMultiGrid }

{ TCtrlMultiGrid }

function TCtrlMultiGrid.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  if (DataSource <> nil) and (DataSource.DataSet <> nil) and
     (DataSource.DataSet.State = dsBrowse) then
    DataSource.DataSet.MoveBy(1);
  Result := True;
end;

function TCtrlMultiGrid.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  if (DataSource <> nil) and (DataSource.DataSet <> nil) and
     (DataSource.DataSet.State = dsBrowse) then
    DataSource.DataSet.MoveBy(-1);
  Result := True;
end;

end.
