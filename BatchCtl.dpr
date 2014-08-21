program BatchCtl;

uses
  Forms,
  BatMain in 'BatMain.pas' {FrmStart};

{$R *.RES}

begin
  Application.Title := 'Batchmode Controller';
  Application.CreateForm(TFrmStart, FrmStart);
  Application.Run;
end.
