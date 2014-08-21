program UniAdmin;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  MAINFrm in 'MAINFrm.PAS' {FrmMAIN},
  ABOUT in 'ABOUT.PAS' {AboutBox},
  CREditorFrm in 'CREditorFrm.pas',
  DAEditorFrm in 'DAEditorFrm.pas' {FrmDAEditor},
  DAConnectionEditorFrm in 'DAConnectionEditorFrm.pas' {FrmDAConnectionEditor},
  ConnectionEditorFrm in 'ConnectionEditorFrm.pas' {FrmConnectionEditor},
  SpecificOptionsFrame in 'SpecificOptionsFrame.pas' {FrSpecificOptions: TFrame},
  TnsImpFrm in 'TnsImpFrm.pas' {FrmTnsImp};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMAIN, FrmMAIN);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
 
