unit MuSiControlFr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Mugrikmp, ComCtrls,
  LuDefKmp;

type
  TFrMusiControl = class(TFrame)
    PC: TPageControl;
    tsSingle: TTabSheet;
    tsMulti: TTabSheet;
    Mu: TMultiGrid;
    procedure PCChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

{$R *.DFM}

procedure TFrMusiControl.PCChange(Sender: TObject);
begin
  if PC.ActivePage = tsSingle then
  begin
    if (Mu.DataSource <> nil) and (Mu.DataSource is TLookupDef) then
      TLookupDef(Mu.Datasource).Lookup(lumZeigMsk);
    PC.ActivePage := tsMulti;
  end;
end;

end.
