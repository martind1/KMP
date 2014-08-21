unit QSpin_kmp;
(* Spin Button
   08.12.01 JP
   30.10.06 MD property Value; OnKeyDown/Up; Mask(000 -> %03.3d; '' -> %d; '###' -> %3.3d)
*)

interface

uses WinProcs, WinTypes, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Grids, DBCtrls, Spin,
  Prots;

type
  TValueChangedEvent = procedure (Sender: TObject; AValue: longint) of object;
  TPlusMinusNone = (pmMinus, pmPlus, pmNone);
const
  PlusMinusNoneStr: Array[TPlusMinusNone] of string = ('-', '+', '*');
type
  TqSpin = class(TSpinButton)
  private
    { Private-Deklarationen }
    FEdit: TCustomEdit;
    FMinValue: LongInt;
    FMaxValue: LongInt;
    FStartValue: longint;
    FStepValue: longint;
    FValue: longint;
    FOnValueChanged: TValueChangedEvent;
    InOnValueChanged: boolean;
    FMask: string;
    function GetDBEdit: TDBEdit;
    function CheckValue(NewValue: LongInt): LongInt;
    function GetValue: longint;
    procedure SetValue(const Value: longint);
    procedure ValueChanged;
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure NewDownClick(Sender: TObject);
    procedure NewUpClick(Sender: TObject);
    procedure NewValue(Modus: TPlusMinusNone);
  public
    { Public-Deklarationen }
    OldValue: longint;  //für Event ValueChanged
    constructor Create(AOwner: TComponent); override;
    procedure CheckNewValue(Sender: TObject);
    property Value: longint read GetValue write SetValue;
  published
    { Published-Deklarationen }
    property DBEdit: TCustomEdit read FEdit write FEdit;
    property MaxValue: LongInt read FMaxValue write FMaxValue;
    property MinValue: LongInt read FMinValue write FMinValue;
    property StartValue: longint read FStartValue write FStartValue;
    property StepValue: longint read FStepValue write FStepValue;
    property Mask: string read FMask write FMask;
    property OnValueChanged: TValueChangedEvent read FOnValueChanged write FOnValueChanged;
  end;

implementation
uses
  Err__Kmp;

function TqSpin.GetDBEdit: TDBEdit;
begin
  if FEdit is TDBEdit then
    result := TDBEdit(FEdit) else
    result := nil;
end;

constructor TqSpin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 21;
  Height := 21;
  TabStop := false;
  FStartValue := 0;
  FStepValue := 1;
  FMinValue := -MaxInt;
  FMaxValue := MaxInt;
  FMask := '0';
end;

procedure TqSpin.Loaded;
begin
  inherited Loaded;
  OnDownClick := NewDownClick;
  OnUpClick := NewUpClick;
end;

procedure TqSpin.ValueChanged;
begin
  if not (csDesigning in ComponentState) and
     (OldValue <> FValue) and not InOnValueChanged and
     Assigned(FOnValueChanged) then
  try
    OldValue := FValue;
    InOnValueChanged := true;
    FOnValueChanged(self, FValue);                 {Ereignis aufrufen}
  finally
    InOnValueChanged := false;
  end;
end;

function TqSpin.GetValue: longint;
//ergibt aktuellen Wert. Exception wenn interner Wert nicht passt oder Feld=null oder leer ('')
//keine Exception wenn von Editfeld gelieferter Wert nicht innerhalb Min-Max
begin
  if FEdit = nil then
  begin
    if (FValue < FMinValue) or (FValue > FMaxValue) then
      EError('%s: F:%d out of bounds', [OwnerDotName(self), FValue]);
  end else
  if GetDBEdit <> nil then
  begin
    if GetDBEdit.Field.IsNull then
      EError('%s: null value', [OwnerDotName(GetDBEdit)]);
    FValue := FieldAsInt(GetDBEdit.Field);
  end else
  if FEdit.Text = '' then
  begin
    EError('%s: null string', [OwnerDotName(FEdit)]);
  end else
    FValue := StrToInt(FEdit.Text);
  ValueChanged;
  result := FValue;
end;

procedure TqSpin.SetValue(const Value: longint);
var
  M: string;
begin
  OldValue := FValue;
  FValue := CheckValue(Value);
  if FEdit <> nil then
  begin
    M := StrDflt(Mask, '0');
//     if GetDBEdit = nil then
//       FEdit.Text := IntToStr(FValue) else
//       GetDBEdit.Field.AsInteger := FValue;
    if GetDBEdit = nil then
      FEdit.Text := FormatFloat(M, FValue) else
      GetDBEdit.Field.AsString := FormatFloat(M, FValue);
  end;
  ValueChanged;
end;

function TqSpin.CheckValue(NewValue: LongInt): LongInt;
begin
  Result := NewValue;
  if FMaxValue > FMinValue then
  begin
    if NewValue < FMinValue then
      Result := FMinValue
    else if NewValue > FMaxValue then
      Result := FMaxValue;
  end;
end;

procedure TqSpin.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FEdit) then
    FEdit := nil;
  inherited Notification(AComponent, Operation);
end;

procedure TqSpin.NewValue(Modus: TPlusMinusNone);
//ändert Wert bzgl. Modus. Checkt Min-Max Grenzen (setzt Min bei Fehler)
var
  AValue: longint;
begin
  try
    AValue := Value;
    if (AValue < FMinValue) or (AValue > FMaxValue) then
      EError('%s: A:%d out of bounds (%d..%d)', [OwnerDotName(self), AValue,
                                                 FMinValue, FMaxValue]);
    try
      if Modus = pmMinus then
        Value := AValue - StepValue else
      if Modus = pmPlus then
        Value := AValue + StepValue else
        Value := AValue;
    except on E:Exception do
      EProt(self, E, 'SetNewValue%s', [PlusMinusNoneStr[Modus]]);
    end;
  except on E:Exception do begin
      EProt(self, E, 'GetNewValue%s', [PlusMinusNoneStr[Modus]]);
      try
        Value := MinValue;
      except on E:Exception do
        EProt(self, E, 'GetSetNewValue%s', [PlusMinusNoneStr[Modus]]);
      end;
    end;
  end;
end;

procedure TqSpin.NewDownClick(Sender: TObject);
begin
  NewValue(pmMinus);
end;

procedure TqSpin.NewUpClick(Sender: TObject);
begin
  NewValue(pmPlus);
end;

procedure TqSpin.CheckNewValue(Sender: TObject);
begin
  NewValue(pmNone);
end;

end.
