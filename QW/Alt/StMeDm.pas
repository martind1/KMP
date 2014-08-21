unit StMeDm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db,  UDB__KMP, MemDS, DBAccess, Uni, UQue_Kmp, Uni, DBAccess, MemDS, Uni, DBAccess, MemDS, USes_Kmp;

type
  TDmStme = class(TDataModule)
    Session1: TuSession;
    Database1: TuDatabase;
    QueSTME: TuQuery;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  DmStme: TDmStme;

implementation

{$R *.DFM}

end.
