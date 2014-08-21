unit qSplitter;
(* Splitter mit der Möglichkeit seinen Status permament zu speichern und
   zu restaurieren.
   Autor: Martin Dambach
   Letzte Änderung:
   16.04.02     Erstellen
   31.10.11 md  D2010 Bug bei Destroy/Komponente Installieren
   12.06.13 md  Saveposition default true. clSilver.
   --------------------------------
   GetSize:S, SetSize(S)
*)

interface

uses
  Messages, Windows, SysUtils, Classes, Controls, Forms, Menus, Graphics,
  StdCtrls, ExtCtrls;

type
  TqSplitter = class(TSplitter)
  private
    FSavePosition: boolean;
    function FindControl: TControl;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    function GetControlName: string;
    function GetControlProp: string;
    function GetSize: Integer;
  published
    property SavePosition: boolean read FSavePosition write FSavePosition default True;
    property Width default 3;
  end;

implementation

uses
  Consts;

{ TqSplitter }

constructor TqSplitter.Create(AOwner: TComponent);
begin
  inherited;
  SavePosition := true;
  Color := clSilver;
  Width := 4;
end;

function TqSplitter.FindControl: TControl;
var
  P: TPoint;
  I: Integer;
  R: TRect;
begin
  Result := nil;
  P := Point(Left, Top);
  case Align of
    alLeft:
      if not AlignWithMargins then
        Dec(P.X)
      else
        Dec(P.X, Margins.Left + 1);
    alRight:
      if not AlignWithMargins then
        Inc(P.X, Width)
      else
        Inc(P.X, Width + Margins.Right + 1);
    alTop:
      if not AlignWithMargins then
        Dec(P.Y)
      else
        Dec(P.Y, Margins.Top + 1);
    alBottom:
      if not AlignWithMargins then
        Inc(P.Y, Height)
      else
        Inc(P.Y, Height + Margins.Bottom + 1);
  else
    Exit;
  end;
  for I := 0 to Parent.ControlCount - 1 do
  begin
    Result := Parent.Controls[I];
    if Result.Visible and Result.Enabled then
    begin
      R := Result.BoundsRect;
      if Result.AlignWithMargins then
      begin
        Inc(R.Right, Result.Margins.Right);
        Dec(R.Left, Result.Margins.Left);
        Inc(R.Bottom, Result.Margins.Bottom);
        Dec(R.Top, Result.Margins.Top);
      end;
      if (R.Right - R.Left) = 0 then
        if Align in [alTop, alLeft] then
          Dec(R.Left)
        else
          Inc(R.Right);
      if (R.Bottom - R.Top) = 0 then
        if Align in [alTop, alLeft] then
          Dec(R.Top)
        else
          Inc(R.Bottom);
      if PtInRect(R, P) then Exit;
    end;
  end;
  Result := nil;
end;

function TqSplitter.GetControlName: string;
var
  AControl: TControl;
begin
  result := '';
  AControl := FindControl;
  if assigned(AControl) then
    result := AControl.Name;
end;

function TqSplitter.GetControlProp: string;
var
  AControl: TControl;
begin
  result := '';
  AControl := FindControl;
  if assigned(AControl) then
    case Align of
      alLeft, alRight: result := 'Width';
      alTop, alBottom: result := 'Height';
    end;
end;

function TqSplitter.GetSize: Integer;
var
  AControl: TControl;
begin
  result := 0;
  AControl := FindControl;
  if assigned(AControl) then
    case Align of
      alLeft, alRight: result := AControl.Width;
      alTop, alBottom: result := AControl.Height;
    end;
end;

end.
