unit Qr3DCnvs;

interface

uses
  Windows, Classes, SysUtils, Controls, Forms,
  Graphics, Messages, Dialogs,
  StdCtrls, Math,
  QRPrntr, Quickrpt, QR5Const, QrCtrls, U3DCnvs;

type
  TQR3DCanvas = class(TQRPrintable)
  private
    FPen    : TPen;
    FBrush  : TBrush;
    FFont   : TFont;
    FViewer:TViewer;
    FMinX:Extended;
    FMaxX:Extended;
    FMinY:Extended;
    FMaxY:Extended;
    FScale:Extended;
    FOnPrint : TNotifyEvent;
    procedure SetPen        (Value: TPen);
    procedure SetBrush      (Value: TBrush);
    procedure SetFont       (Value: TFont);
    procedure SetViewer     (Value : TViewer);
    procedure SetMinX(Value:Extended);
    procedure SetMaxX(Value:Extended);
    procedure SetMinY(Value:Extended);
    procedure SetMaxY(Value:Extended);
    procedure UpdateScale;
  protected
    {property  Canvas;         MD}
    procedure Paint; override;
    function  RealToScreen(Point3D:TPoint3D):TPoint;
  public
    R: TRect;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Clear;
    procedure   SetWindow (xmin, xmax, ymin, ymax : Extended);
    procedure   MoveTo    (P3D: TPoint3D);
    procedure   LineTo    (P3D: TPoint3D);
    procedure   TextOut   (P3D_Start, P3D_end: TPoint3D; Text:String);
    procedure   Polygon(Points: array of TPoint3D);
    procedure   Polyline(Points: array of TPoint3D);
    procedure Print(OfsX, OfsY : integer); override;    {md}
  published
    property Viewer : TViewer   read FViewer  write SetViewer;
    property Font   : TFont     read FFont    write SetFont;
    property Brush  : TBrush    read FBrush   write SetBrush;
    property Pen    : TPen      read FPen     write SetPen;
    property MinX   : Extended  read FMinX    write SetMinX;
    property MaxX   : Extended  read FMaxX    write SetMaxX;
    property MinY   : Extended  read FMinY    write SetMinY;
    property MaxY   : Extended  read FMaxY    write SetMaxY;
    property Transparent;
    property OnPrint: TNotifyEvent read FOnPrint write FOnPrint;
  end;

  function Point3D(x,y,z:Extended):TPoint3D;
  function atan4(x:Extended;y:Extended):Extended;

implementation

function RTrunc(X: Extended): Int64;
// Workaround für fehlerhalte Trunk Implementierung
begin
  Result := Round(X - 0.5);
end;

constructor TQR3DCanvas.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FBrush := TBrush.Create;
  FFont :=TFont.Create;
  FPen := TPen.Create;
  {Canvas.Brush.style:=bsClear; md}
  FMinX:=-100;
  FMaxX:=100;
  FMinY:=-100;
  FMaxY:=100;
  UpdateScale;
  FViewer:=TViewer.Create;
  FViewer.Zoom:=1.0E-20;
  FViewer.Longitude:=30.0;
  FViewer.Latitude:=30.0;
  FViewer.Distance:=1.0E20;
  FViewer.Size:=1.0;
  FViewer.Zoom:=1.0E-20;
  FViewer.Update;
  {ControlStyle := ControlStyle + [csReplicatable]; md}
  Width := 100;
  Height := 100;
end; {Create}

destructor TQR3DCanvas.Destroy;
begin
  inherited destroy;
end; {Destroy}

procedure TQR3DCanvas.Paint;
begin
  if csDesigning in ComponentState
    then with Canvas do begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
end;  {Paint}

function TQR3DCanvas.RealToScreen(Point3D:TPoint3D):TPoint;
var
  T             : Extended;
  X,Y           : Extended;
begin
  FViewer.Update;
  T := 1.0 / (FViewer.Distance - (  FViewer.Ix * Point3D.x
                                  + FViewer.Iy * Point3D.y
                                  + FViewer.Iz * Point3D.z));

  X := T * ( FViewer.Jx * Point3D.x
           + FViewer.Jy * Point3D.y);

  Y := T * ( FViewer.Kx * Point3D.x
           + FViewer.Ky * Point3D.y
           + FViewer.Kz * Point3D.z);

  UpdateScale;

  Result.x:=RTrunc((X-FMinX)*FScale);
  Result.y:=RTrunc((FMaxY-Y)*FScale);
end;  {RealToScreen}

procedure TQR3DCanvas.Clear;
begin
  ParentReport.QRPrinter.Canvas.Brush.style:=bsClear;
  Repaint;
end;  {Clear}

procedure TQR3DCanvas.UpdateScale;
var Scale_x, Scale_y:Extended;
    Width_F,Height_F:Extended;
begin
  Width_F:=Width;
  Height_F:=Height;
  Scale_x:=Width_F/(FMaxX-FMinX);
  Scale_y:=Height_F/(FMaxy-FMiny);
  if Scale_x > Scale_y
    then FScale:=Scale_y
    else FScale:=Scale_x;
end;  {UpdateScale}

procedure TQR3DCanvas.SetWindow(xmin,xmax,ymin,ymax:Extended);
begin
  SetMinX(xmin);
  SetMaxX(xmax);
  SetMinY(ymin);
  SetMaxY(ymax);
  UpdateScale;
end;  {SetWindow}

procedure TQR3DCanvas.MoveTo(P3D: TPoint3D);
var P:TPoint;
begin
  P:=RealToScreen(P3D);
  with ParentReport.QRPrinter.Canvas do
    MoveTo(R.Left + P.x, R.Top + P.y);
end; {MoveTo}

procedure TQR3DCanvas.LineTo(P3D: TPoint3D);
var P:TPoint;
begin
  P:=RealToScreen(P3D);
  with ParentReport.QRPrinter.Canvas do
  begin
    Pen := FPen;
    LineTo(R.Left + P.x, R.Top + P.y);
  end;
end;  {LineTo}

procedure TQR3DCanvas.TextOut(P3D_Start,P3D_end: TPoint3D; Text:String);
var
  Font_Log_Record: TLogFont;
  Angle:Extended;
  P1,P2:TPoint;
begin
  P1:=RealToScreen(P3D_Start);
  P2:=RealToScreen(P3D_end);
  Angle:=atan4((P2.x-P1.x),(P1.y-P2.y));
  Angle:=RadToDeg(Angle);

  Canvas.Font := FFont;
  GetObject(Canvas.Font.Handle, SizeOf(Font_Log_Record), Addr(Font_Log_Record));
  Font_Log_Record.lfEscapement := RTrunc(Angle * 10);
  Font_Log_Record.lfOutPrecision := OUT_TT_ONLY_PRECIS;
  with ParentReport.QRPrinter do
  begin
    Canvas.Font.Handle := CreateFontIndirect(Font_Log_Record);
    Canvas.TextOut(R.Left + P1.X, R.Top + P1.Y, Text);
    Canvas.Font:=FFont;
  end;
end;

procedure TQR3DCanvas.Polygon(Points: array of TPoint3D);
var i:integer;
    Pts:array [0..12] of TPoint;
    P:TPoint;
    N:integer;
begin
  if High(Points) > High(Pts) then exit;
  N:=High(Points)+1;
  for i:=0 to High(Points) do
  begin
    P:=RealToScreen(Points[i]);
    {Pts[i] := P;   md}
    Pts[i] := Point(R.Left + P.X, R.Top + P.Y);
  end;
  with ParentReport.QRPrinter.Canvas do
  begin;
    Pen := FPen;
    if not Transparent then
      Brush := FBrush;
    Polygon(Slice(Pts, N));
  end;
end;

procedure TQR3DCanvas.Polyline(Points: array of TPoint3D);
var i:integer;
    Pts:array [0..12] of TPoint;
    P:TPoint;
    N:integer;
begin
  if High(Points) > High(Pts) then exit;

  N:=High(Points)+1;
  for i:=0 to High(Points) do
  begin
    P:=RealToScreen(Points[i]);
    {Pts[i] := P;   md}
    Pts[i] := Point(R.Left + P.X, R.Top + P.Y);
  end;
  with ParentReport.QRPrinter.Canvas do
  begin;
    Pen := FPen;
    Polyline(Slice(Pts, N));
  end;
end;{Polyline}

procedure TQR3DCanvas.SetMinX(Value: Extended);
begin
  if Value <> FMinX
  then if Value < FMaxX
    then begin
        FMinX := Value;
        UpdateScale;
      end
    else ShowMessage('MinX should be smaller than MaxX');
end;

procedure TQR3DCanvas.SetMaxX(Value: Extended);
begin
  if Value <> FMaxX
    then if Value > FMinX
      then begin
        FMaxX := Value;
        UpdateScale;
      end
    else ShowMessage('MaxX should be greater than MinX');
end;

procedure TQR3DCanvas.SetMinY(Value: Extended);
begin
  if Value <> FMinY
    then if Value < FMaxY
      then begin
          FMinY := Value;
          UpdateScale;
        end
      else ShowMessage('MinY should be smaller than MaxY');
end;

procedure TQR3DCanvas.SetMaxY(Value: Extended);
begin
  if Value <> FMaxY
  then if Value > FMinY
    then begin
        FMaxY := Value;
        UpdateScale;
      end
    else ShowMessage('MaxY should be greater than MinY');
end;

procedure TQR3DCanvas.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TQR3DCanvas.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TQR3DCanvas.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TQR3DCanvas.SetViewer(Value : TViewer);
begin
  FViewer.Assign(Value);
  FViewer.Update;
  Invalidate;
end;

procedure TQR3DCanvas.Print(OfsX, OfsY : integer);
begin
  if Assigned(FOnPrint) then
  begin
    with ParentReport.QRPrinter do
    begin
      R := Rect(XPos(OfsX + Size.Left),
                YPos(OfsY + Size.Top),
                XPos(OfsX + Size.Left + Size.Width),
                YPos(OfsY + Size.Top + Size.Height));
    end;
    FOnPrint(self);
  end;
end;

// Utility functions
function Point3D(x,y,z:Extended):TPoint3D;
begin
  Result.x:=x;  Result.y:=y;  Result.z:=z;
end;

function atan4(x:Extended;y:Extended):Extended;
  {full quadrant tan function}
begin
  result:=0;
  if ((x=0) and (y>0.0)) then
    Result:=Pi/2;

  if ((x=0.0) and (y<0.0)) then
    Result:=3*Pi/2;

  if ((x>0.0) and (y=0.0)) then
    Result:=0;

  if ((x<0.0) and (y=0.0)) then
    Result:=2*Pi;

  if ((x > 0.0) and (y > 0.0)) then
    Result := arctan(y/x);

  if ((x < 0.0) and (y > 0.0)) then
    Result := Pi - arctan(abs(y/x));

  if ((x < 0.0) and (y < 0.0)) then
      Result := Pi + arctan(abs(y/x));

  if ((x > 0.0) and (y < 0.0)) then
    Result := 2*Pi - arctan(abs(y/x));
end;

end.




