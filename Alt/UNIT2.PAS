unit Unit2;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Grids, TgridKmp, Buttons;

type
  TForm2 = class(TForm)
    TitleGrid1: TTitleGrid;
    TitleGrid2: TTitleGrid;
    Label1: TLabel;
    Edit1: TEdit;
    BtnOK: TBitBtn;
    BtnHeute: TBitBtn;
    BtnCancel: TBitBtn;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

end.
