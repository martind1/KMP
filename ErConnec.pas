unit Erconnec;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls;

type
  TErDirection = (dirUp, dirDown, dirLeft, dirRight, dirUpDown, dirLeftRight);

  TErConnect = class(TPaintBox)
  private
    { Private-Deklarationen }
    FDirection: TErDirection;
    procedure SetDirection( Value: TErDirection);
  protected
    { Protected-Deklarationen }
    procedure Paint; override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
  published
    { Published-Deklarationen }
    property Direction: TErDirection read FDirection write SetDirection;
  end;


implementation

constructor TErConnect.Create(AOwner: TComponent);
begin
  inherited Create( AOwner);
  Direction := dirDown;
  Width := 24;
  Height := 48;
end;

procedure TErConnect.SetDirection( Value: TErDirection);
var
  I: integer;
begin
  if FDirection <> Value then
  begin
    if [csLoading,csDesigning] * ComponentState = [csDesigning] then
    begin
      if (FDirection in [dirLeft,dirRight,dirLeftRight]) <>
         (Value in [dirLeft,dirRight,dirLeftRight]) then
      begin
        I := Width;
        Width := Height;
        Height := I;
      end;
    end;
    FDirection := Value;
    Invalidate;
  end;
end;

procedure TErConnect.Paint;
var
  W, W2, H, H2: integer;
begin
  W2 := Width div 2;
  W := W2 * 2;
  H2 := Height div 2;
  H := H2 * 2;
  {if Odd( Width) then Dec( W);}
  with Canvas do
    case FDirection of
      dirUp:    begin
                  MoveTo( W2, 0);
                  LineTo( W2, Height);
                  MoveTo( W2, W2);
                  LineTo( 0, 0);
                  MoveTo( W2, W2);
                  LineTo( W, 0);
                end;
      dirDown:  begin
                  MoveTo( W2, 0);
                  LineTo( W2, Height);
                  MoveTo( W2, Height - W2);
                  LineTo( 0, Height);
                  MoveTo( W2, Height - W2);
                  LineTo( W, Height);
                end;
      dirUpDown:  begin
                    MoveTo( W2, 0);
                    LineTo( W2, Height);
                    MoveTo( W2, Height - W2);
                    LineTo( 0, Height);
                    MoveTo( W2, Height - W2);
                    LineTo( W, Height);
                    MoveTo( W2, W2);
                    LineTo( 0, 0);
                    MoveTo( W2, W2);
                    LineTo( W, 0);
                  end;
      dirLeft:  begin
                  MoveTo( 0, H2);
                  LineTo( Width, H2);
                  MoveTo( H2, H2);
                  LineTo( 0, 0);
                  MoveTo( H2, H2);
                  LineTo( 0, H);
                end;
      dirRight: begin
                  MoveTo( 0, H2);
                  LineTo( Width, H2);
                  MoveTo( W-H2, H2);
                  LineTo( W, 0);
                  MoveTo( W-H2, H2);
                  LineTo( W, H);
                end;
      dirLeftRight: begin
                      MoveTo( 0, H2);
                      LineTo( Width, H2);
                      MoveTo( W-H2, H2);
                      LineTo( W, 0);
                      MoveTo( W-H2, H2);
                      LineTo( W, H);
                      MoveTo( H2, H2);
                      LineTo( 0, 0);
                      MoveTo( H2, H2);
                      LineTo( 0, H);
                    end;
    end;
end;

end.
