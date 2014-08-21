unit qLab_kmp;
(* Label mit Kobntrolle der Position der FocusControl
*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TqLabel = class(TLabel)
  private
    { Private-Deklarationen }
    fFocusTop: integer;
    fFocusRight: integer;
    procedure SetFocusTop(Value: integer);
    procedure SetFocusRight(Value: integer);
  protected
    { Protected-Deklarationen }
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
  published
    { Published-Deklarationen }
    property FocusTop: integer read fFocusTop write SetFocusTop;
    property FocusRight: integer read fFocusRight write SetFocusRight;
  end;

implementation

uses
  Prots;

constructor TqLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fFocusTop := -2;
  fFocusRight := 8;
end;

procedure TqLabel.Loaded;
var
  I: integer;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) and
     (FocusControl <> nil) and (Owner <> nil) then
    for I := 0 to Owner.ComponentCount - 1 do
      if (Owner.Components[I] is TqLabel) and (Owner.Components[I] <> self) then
        with Owner.Components[I] as TqLabel do
          if FocusControl = self.FocusControl then
            Self.FocusControl := nil;
end;

procedure TqLabel.SetFocusTop(Value: integer);
begin
  if (csDesigning in ComponentState) and (FocusControl <> nil) then
    FocusControl.Top := Top + Value;
  fFocusTop := Value;
end;

procedure TqLabel.SetFocusRight(Value: integer);
begin
  if (csDesigning in ComponentState) and (FocusControl <> nil) then
  begin
    if Alignment = taLeftJustify then
    begin
      if (Value < Width) and (FocusTop < Height - 2) then
        Value := Value + Width;
      FocusControl.Left := Left + Value;
    end else
    begin
      if Value > Width then
        Value := Value - Width;
      FocusControl.Left := Left + Width + Value;
    end;
  end;
  fFocusRight := Value;
end;

procedure TqLabel.WMWindowPosChanged(var Message: TWMWindowPosChanged); {message WM_WINDOWPOSCHANGED;}
begin
  SetFocusTop(fFocusTop);
  SetFocusRight(fFocusRight);
end;

end.
