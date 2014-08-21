unit Pboxkmp;
(* Tests mit Paintbox *)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls;

type
  TPaintBoxWeiter = class(TPaintBox)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    procedure Paint; override;
  public
    { Public-Deklarationen }
  published
    { Published-Deklarationen }
  end;

procedure Register;

implementation


procedure TPaintBoxWeiter.Paint;
begin
   with canvas do
   begin
       brush.color := CLBlue;
       pen.color := CLRed;
       moveto(0, (height)div 3);
       LineTo(width, (height)div 3);

       moveto(0, 2*((height)div 3));
       LineTo(width, 2*((height)div 3));

       moveto(0, (width)div 3);
       LineTo(height, (width)div 3);

       moveto(0, 2*((width)div 3));
       LineTo(height, 2*((width)div 3));

   end;
end;

procedure Register;
begin
  RegisterComponents('Beispiele', [TPaintBoxWeiter]);
end;

end.
