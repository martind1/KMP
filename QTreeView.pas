unit QTreeView;
(* Treeview modifiziert
   Doppelklick führt nicht automatisch zu Expand/Collapse
   Neue Eigenschaft: DblClickExpands: boolean
                     wenn false bewirkt Doppleklick kein Expand/Collapse
*)

interface

uses SysUtils, Classes, comctrls, messages;

type

  TQTreeView = class(TTreeView)
  private
    FDblClickExpands: boolean;
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    procedure WMLButtonDblClk(var Message: TWMLButtonDown); message WM_LBUTTONDBLCLK;
  public
    { Public-Deklarationen }
  published
    { Published-Deklarationen }
    property DblClickExpands: boolean read FDblClickExpands write FDblClickExpands;
  end;

implementation

{ TQTreeView }

procedure TQTreeView.WMLButtonDblClk(var Message: TWMLButtonDown);
begin
  if FDblClickExpands then
    inherited else
  if Assigned(OnDblClick) then
    OnDblClick(self);
end;

end.
