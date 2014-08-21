unit TMSAlphaNum;
(* Zusatzroutinen für TMS Touch Keyboard
23.11.11 md  erstellt QSBT D2010
*)
interface

uses
  Graphics, Sysutils, Classes,
  AdvTouchKeyboard;

procedure ATKBuildAlphanumKeyBoard(ATK: TAdvTouchKeyboard);

procedure ATKAlignTo(ATK: TAdvTouchKeyboard; aWidth, aHeight: integer);

implementation

uses
  Windows;

var
  CurrentX2: integer;
  fATK: TAdvTouchKeyboard;

procedure ATKAddKey(Caption, ShiftCaption,
  AltGrCaption: ShortString; KeyValue, ShiftKeyValue, AltGrKeyValue,
  ImageIndex, aWidth, aHeight: Integer; var X :Integer; Y: Integer;
  SpecialKey: TSpecialKey; Color: TColor = clSilver);
var
  aShortCut: string;
begin
  aShortCut := '';
  if CompareText(String(Caption), 'Minus') = 0 then
    aShortCut := '-';
  if CompareText(String(Caption), 'Komma') = 0 then
    aShortCut := ',';

  with fATK, fATK.Keys do
  begin
    Add;
    Items[Keys.Count - 1].Caption := string(Caption);
    Items[Keys.Count - 1].ShortCut := aShortCut;  //md04.08.11
    Items[Keys.Count - 1].Color := Color;
    Items[Keys.Count - 1].ShiftCaption := string(ShiftCaption);
    Items[Keys.Count - 1].AltGrCaption := string(AltGrCaption);
    Items[Keys.Count - 1].KeyValue := KeyValue;
    Items[Keys.Count - 1].ShiftKeyValue := ShiftKeyValue;
    Items[Keys.Count - 1].AltGrKeyValue := AltGrKeyValue;
    if not (csDesigning in fATK.ComponentState) then
    begin
      //IFDEF DELPHI6_LVL}
      if Assigned(fATK.Images) then
        Items[Keys.Count - 1].ImageIndex := ImageIndex
      //ELSE}
      //if Assigned((ATK.GetOwner as TAdvTouchKeyboard).Images) then
      //  Items[Keys.Count - 1].ImageIndex := ImageIndex
      //ENDIF}
    end
    else
      Items[Keys.Count - 1].ImageIndex := -1;
    Items[Keys.Count - 1].SpecialKey := SpecialKey;
    Items[Keys.Count - 1].Width := aWidth;
    Items[Keys.Count - 1].Height := aHeight;
    Items[Keys.Count - 1].X := X;
    Items[Keys.Count - 1].Y := Y;
    X := X + Items[Keys.Count - 1].Width;
  end;
end;

procedure ATKNewRow(var X, Y: Integer; Size: Integer);
begin
  X := CurrentX2;
  Y := Y + Size;
end;

procedure ATKBuildAlphanumKeyBoard(ATK: TAdvTouchKeyboard);
// Einfaches Alphanumerisches Keyboard zusammenbauchen (Tastenfolge ABCDE..)
var
  CurrentX,
  CurrentY,
  Size   : integer;

begin
 fATK := ATK;
 
 with ATK.Keys do
 begin
  Clear;
 end;

  CurrentX2 := 0;
  CurrentY := 0;
  CurrentX := CurrentY;
  Size := 40;
  ATK.Height := 160;
  ATK.Width  := 600;

 with ATK.Keys do
 begin

  ATKAddKey('A', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('B', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('C', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('D', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('E', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('F', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('G', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('H', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('I', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('J', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKNewRow(CurrentX, CurrentY, Size);

  ATKAddKey('K', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('L', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('M', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('N', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('O', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('P', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('Q', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('R', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('S', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('T', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKNewRow(CurrentX, CurrentY, Size);

  ATKAddKey('U', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('V', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('W', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('X', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('Y', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('Z', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('ß', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('Ä', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('Ö', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('Ü', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKNewRow(CurrentX, CurrentY, Size);

  ATKAddKey('Leerzeichen', '','', VK_SPACE, -1, -1, -1, Size * 8, Size, CurrentX, CurrentY, skSpaceBar);
  ATKAddKey('löschen', '','', VK_BACK, -1, -1, -1, Size * 2, Size, CurrentX, CurrentY, skBackSpace, $A0A0A0);

  CurrentX2 := CurrentX + Size;
  ATKNewRow(CurrentX, CurrentY, Size);
  CurrentY := 0;
  CurrentX := CurrentX2;

  ATKAddKey('1', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('2', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('3', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('/', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKNewRow(CurrentX, CurrentY, Size);

  ATKAddKey('4', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('5', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('6', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('*', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKNewRow(CurrentX, CurrentY, Size);

  ATKAddKey('7', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('8', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('9', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('-', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKNewRow(CurrentX, CurrentY, Size);

  ATKAddKey('0', '','', -1, -1, -1, -1, Size * 2, Size, CurrentX, CurrentY, skNone);
  ATKAddKey(',', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);
  ATKAddKey('+', '','', -1, -1, -1, -1, Size, Size, CurrentX, CurrentY, skNone);

 end;
end;

procedure ATKAlignTo(ATK: TAdvTouchKeyboard; aWidth, aHeight: integer);
// Größe anpassen
var
  W, H: integer;
begin
  W := ATK.Width;
  H := ATK.Height;

  if H * aWidth/W > aHeight then
    W := Round(H * aWidth / aHeight);
  if W * aHeight/H > aWidth then
    H := Round(W * aHeight / aWidth);

  ATK.Zoom(aWidth/W, aHeight/H, false, true);
end;


end.
