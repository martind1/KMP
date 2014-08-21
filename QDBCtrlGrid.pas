unit QDBCtrlGrid;
(* DBCtrlGrid modifiziert
   LinkToGNav, Enter, Exit, CheckFocus
*)

interface

uses SysUtils, Classes, comctrls, messages, dbcgrids, forms,
     NLnk_Kmp, Mugrikmp {MuOptions};

type

  TQDBCtrlGrid = class(TDBCtrlGrid)
  private
    { Private-Deklarationen }
    FMuOptions: TMuOptions;
    function GetForm: TForm;
    function GetNavLink: TNavLink;
  protected
    { Protected-Deklarationen }
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    { Public-Deklarationen }
    function CheckFocus: boolean;
    constructor Create(AOwner: TComponent); override;
    property Form: TForm read GetForm;
    property NavLink: TNavLink read GetNavLink;
  published
    { Published-Deklarationen }
    property MuOptions: TMuOptions read FMuOptions write FMuOptions;  //muPostOnExit
  end;

implementation

uses
  Prots, LNav_Kmp, LuDefKmp, Qwf_Form, GNav_Kmp;

{ TQDBCtrlGrid }

procedure TQDBCtrlGrid.DoEnter;
//von MultiGrid
begin
  inherited DoEnter;
  CheckFocus;
end;

procedure TQDBCtrlGrid.DoExit;
//von MultiGrid
var
  ALNav: TLNavigator;
  ALuDef: TLookUpDef;
begin
  if csDesigning in ComponentState then
  begin
    inherited DoExit;
    Exit;
  end;
  if muPostOnExit in MuOptions then
    if (NavLink <> nil) and (NavLink.DataSet <> nil) then
      NavLink.DoPost(True);
  if DataSource is TLookUpDef then
  begin
    ALuDef := DataSource as TLookUpDef;
    if ALuDef.LinkToGNav then
    begin
      ALNav := FormGetLNav(Form);
      GNavigator.SetLink(Form, ALNav.NavLink, ALNav.NavLink.ActiveSource); {Checkt Color}
      if ALNav.PageBook <> nil then
        GNavigator.PageChanged(ALNav.GetPage);
      SMess('',[0]);
    end;
  end;
  inherited DoExit;            {erst hier !}
end;

function TQDBCtrlGrid.CheckFocus: boolean;
//von MultiGrid
//   > true=SetLink auf self wurde durchgeführt.
//   * für doEnter, und für GNav.ActiveFormChanged *)
var
  ALuDef: TLookUpDef;
begin
  result := false;
  if (DataSource <> nil) and (DataSource is TLookUpDef) then
  begin
    ALuDef := DataSource as TLookUpDef;
    if ALuDef.LinkToGNav then   {Wenn verbunden mit GNav}
    begin
      GNavigator.SetLink(Form, ALuDef.NavLink, ALuDef);       {-> Checkt Color}
      result := true;
      GNavigator.PageChanged('Multi');      {Buttons auf Multi Sicht einstellen}
      if ALuDef.AutoOpen and (ALuDef.DataSet <> nil) then
        ALuDef.DataSet.Active := true;
    end;
  end;
end;

constructor TQDBCtrlGrid.Create(AOwner: TComponent);
begin
  inherited;
  MuOptions := [muPostOnExit];
end;

function TQDBCtrlGrid.GetForm: TForm;
begin
  result := nil;
  try
    if Owner <> nil then
      if Owner is TFrame then
      result := Owner.Owner as TForm else
      result := Owner as TForm;
  except
    result := nil;
  end;
end;

function TQDBCtrlGrid.GetNavLink: TNavLink;
begin
  if DataSource = nil then
    result := nil else
  if DataSource is TLookUpDef then
    result := (DataSource as TLookUpDef).NavLink else
  if FormGetLNav(Form) <> nil then
    result := FormGetLNav(Form).NavLink else
    result := nil;
end;

end.
