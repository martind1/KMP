unit Radios;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TFrameStyle = (frLowered, frNone);

type
  TRadios = class(TRadioGroup)
  private
    { Private-Deklarationen }
    FFrame: TFrameStyle;
    procedure SetFrame(Value: TFrameStyle);
  protected
    { Protected-Deklarationen }
    procedure Paint; override;
  public
    { Public-Deklarationen }
  published
    { Published-Deklarationen }
    property Frame: TFrameStyle read FFrame write SetFrame;
  end;

implementation

procedure TRadios.SetFrame(Value: TFrameStyle);
begin
  FFrame := Value;
  if not (csReading in ComponentState) then
    Invalidate;
end;

procedure TRadios.Paint;
begin
  if FFrame = frLowered then
    inherited Paint;
  {else nix. kein Rahmen!}
end;


end.
