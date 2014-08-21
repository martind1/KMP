{==================================}
{= RzLabel - 3D Label Component   =}
{=                                =}
{= Ray Konopka                    =}
{= Raize Software Solutions, Inc. =}
{==================================}

unit Rzlabel;

interface

  uses
    SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
    Forms, Dialogs, StdCtrls;

  type
    TTextStyle = ( tsNone, tsRaised, tsRecessed );

    TRzLabel = class( TLabel )
    private
      FTextStyle : TTextStyle;
      procedure DoDrawText(var Rect: TRect; Flags: Word); reintroduce;
    protected
      procedure Paint; override;
      procedure SetTextStyle( Value : TTextStyle );
    public
      constructor Create( AOwner : TComponent ); override;
    published
      property TextStyle : TTextStyle read FTextStyle
                                      write SetTextStyle
                                      default tsRecessed;
    end;

implementation

uses
  Types;

  constructor TRzLabel.Create( AOwner : TComponent );
  begin
    inherited Create( AOwner );
    FTextStyle := tsRecessed;
  end;


  procedure TRzLabel.SetTextStyle( Value : TTextStyle );
  begin
    if Value <> FTextStyle then
    begin
      FTextStyle := Value;
      Invalidate;
    end;
  end; {= TRzLabel.SetTextStyle =}


  procedure TRzLabel.DoDrawText( var Rect : TRect; Flags : Word );
  var
    Text       : array[ 0..255 ] of Char;
    TmpRect    : TRect;
    UpperColor : TColor;
    LowerColor : TColor;
  begin
    GetTextBuf(Text, SizeOf(Text));
    if ( Flags and DT_CALCRECT <> 0) and
       ( ( Text[0] = #0 ) or ShowAccelChar and
         ( Text[0] = '&' ) and
         ( Text[1] = #0 ) ) then
      StrCopy(Text, ' ');

    if not ShowAccelChar then
      Flags := Flags or DT_NOPREFIX;
    Canvas.Font := Font;

    UpperColor := clBtnHighlight;
    LowerColor := clBtnShadow;
    if FTextStyle = tsRecessed then
    begin
      UpperColor := clBtnShadow;
      LowerColor := clBtnHighlight;
    end;

    if FTextStyle in [ tsRecessed, tsRaised ] then
    begin
      TmpRect := Rect;
      OffsetRect( TmpRect, 1, 1 );
      Canvas.Font.Color := LowerColor;
      DrawText(Canvas.Handle, Text, StrLen(Text), TmpRect, Flags);

      TmpRect := Rect;
      OffsetRect( TmpRect, -1, -1 );
      Canvas.Font.Color := UpperColor;
      DrawText(Canvas.Handle, Text, StrLen(Text), TmpRect, Flags);
    end;

    Canvas.Font.Color := Font.Color;
    if not Enabled then
      Canvas.Font.Color := clGrayText;
    DrawText(Canvas.Handle, Text, StrLen(Text), Rect, Flags);
  end; {= TRzLabel.DoDrawText =}


  procedure TRzLabel.Paint;
  const
    Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  var
    Rect: TRect;
  begin
    with Canvas do
    begin
      if not Transparent then
      begin
        Brush.Color := Self.Color;
        Brush.Style := bsSolid;
        FillRect(ClientRect);
      end;
      Brush.Style := bsClear;
      Rect := ClientRect;
      DoDrawText( Rect, ( DT_EXPANDTABS or DT_WORDBREAK ) or
                  Alignments[ Alignment ] );
    end;
  end; {= TRzLabel.Paint =}

end.
