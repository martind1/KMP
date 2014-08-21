unit Qedi_kmp;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask;

type
  TqEdit = class(TCustomMaskEdit)
  private
    { Private-Deklarationen }
    FAlignment: TAlignment;
    FCanvas: TControlCanvas;
    FFocused: Boolean;
    function GetTextMargins: TPoint;
    procedure SetFocused(Value: Boolean);
  protected
    { Protected-Deklarationen }
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
    { Public-Deklarationen }
  published
    { Published-Deklarationen }
    property Alignment: TAlignment read FAlignment write FAlignment;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Ctl3D;
    property Color;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property ParentColor;
    property ReadOnly;
    property TabOrder;
    property HelpContext;
    property MaxLength;
    property EditMask;
    property ShowHint;
    property Visible;
    property Enabled;
    property Left;
    property Top;
    property Width;
    property Height;
    property Hint;
    property Text;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnChange;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

implementation

procedure TqEdit.CMEnter(var Message: TCMEnter);
begin
  SetFocused(True);
  inherited;
end;

procedure TqEdit.CMExit(var Message: TCMExit);
begin
  SetFocused(False);
  CheckCursor;
  DoExit;
end;

procedure TqEdit.SetFocused(Value: Boolean);
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if (FAlignment <> taLeftJustify) and not IsMasked then
      Invalidate;
  end;
end;

procedure TqEdit.WMPaint(var Message: TWMPaint);
var
  Left: Integer;
  Margins: TPoint;
  R: TRect;
  DC: HDC;
  PS: TPaintStruct;
  S: string;
begin
  if ((FAlignment = taLeftJustify) or Focused)
{$ifdef WIN32}
    and not (csPaintCopy in ControlState)
{$else}
{$endif}
  then
  begin
    inherited;
    Exit;
  end;
{ Since edit controls do not handle justification unless multi-line (and
  then only poorly) we will draw right and center justify manually unless
  the edit has the focus. }
  if FCanvas = nil then
  begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := Self;
  end;
  DC := Message.DC;
  if DC = 0 then DC := BeginPaint(Handle, PS);
  FCanvas.Handle := DC;
  try
    FCanvas.Font := Font;
    with FCanvas do
    begin
      R := ClientRect;
      if not (NewStyleControls and Ctl3D) and (BorderStyle = bsSingle) then
      begin
        Brush.Color := clWindowFrame;
        FrameRect(R);
        InflateRect(R, -1, -1);
      end;
      Brush.Color := Color;
      S := Text;
{$ifdef WIN32}
      if (csPaintCopy in ControlState) then
{$else}
{$endif}
      begin
        case CharCase of
          ecUpperCase: S := AnsiUpperCase(S);
          ecLowerCase: S := AnsiLowerCase(S);
        end;
      end;
      if PasswordChar <> #0 then
        FillChar(S[1], Length(S), PasswordChar);
      Margins := GetTextMargins;
      case FAlignment of
        taLeftJustify: Left := Margins.X;
        taRightJustify: Left := ClientWidth - TextWidth(S) - Margins.X - 1;
      else
        Left := (ClientWidth - TextWidth(S)) div 2;
      end;
      TextRect(R, Left, Margins.Y, S);
    end;
  finally
    FCanvas.Handle := 0;
    if Message.DC = 0 then EndPaint(Handle, PS);
  end;
end;

function TqEdit.GetTextMargins: TPoint;
var
  DC: HDC;
  SaveFont: HFont;
  I, IY: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
{$ifdef WIN32}
  if NewStyleControls and AutoSize then
  begin
    if BorderStyle = bsNone then
      I := 0 else
    if Ctl3D then
      I := 1 else
      I := 2;
    Result.X := SendMessage(Handle, EM_GETMARGINS, 0, 0) and $0000FFFF + I;
    Result.Y := I;
  end else
{$else}
{$endif}
  begin
    if BorderStyle = bsNone then
    begin
      I := 0;
      IY := 0;
    end else
    begin
      DC := GetDC(0);
      GetTextMetrics(DC, SysMetrics);
      SaveFont := SelectObject(DC, Font.Handle);
      GetTextMetrics(DC, Metrics);
      SelectObject(DC, SaveFont);
      ReleaseDC(0, DC);
      I := SysMetrics.tmHeight;
      if I > Metrics.tmHeight then
        I := Metrics.tmHeight;
      I := I div 4;
      IY := (Height - Metrics.tmHeight) div 2;
    end;
    Result.X := I;
    Result.Y := IY;
  end;
end;

end.
