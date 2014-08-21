unit IEEEFloatClass;
(* Klasse zur Umwandlung von Modbus IEEE Werten
27.11.13 md  fixed bug in SingleToIeee
*)
interface

type
  TIEEENumber = record  //4 Bytes von Modbus Gerät
                  B1, B2, B3, B4: Byte;
                end;
type
  TIEEEFloat = class(TObject)
  private
    fIEEENumber: TIEEENumber;
    fSingleValue: Single;
    function GetIEEENumber: TIEEENumber;
    function GetSingleValue: Single;
    procedure SetIEEENumber(const Value: TIEEENumber);
    procedure SetSingleValue(const Value: Single);
  protected
  public
    constructor Create(aIEEENumber: TIEEENumber); overload;
    constructor Create(B1, B2, B3, B4: Byte); overload;

    function IeeeToSingle(aIEEENumber: TIEEENumber): Single;
    function SingleToIeee(ASingle: Single): TIEEENumber;

    function ToSingle: single;

    property IEEENumber: TIEEENumber read GetIEEENumber write SetIEEENumber;
    property SingleValue: Single read GetSingleValue write SetSingleValue;
  end;

function IEEEFloat: TIEEEFloat;

implementation

uses
  SysUtils,
  Err__Kmp;

var
  fIEEEFloat: TIEEEFloat;

function IEEEFloat: TIEEEFloat;
begin
  if fIEEEFloat = nil then
    fIEEEFloat := TIEEEFloat.Create;
  Result := fIEEEFloat;
end;

{ TIEEEFloat }

constructor TIEEEFloat.Create(aIEEENumber: TIEEENumber);
begin
  SetIEEENumber(aIEEENumber);
end;

constructor TIEEEFloat.Create(B1, B2, B3, B4: Byte);
var
  aIEEENumber: TIEEENumber;
begin
  aIEEENumber.B1 := B1;
  aIEEENumber.B2 := B2;
  aIEEENumber.B3 := B3;
  aIEEENumber.B4 := B4;
  SetIEEENumber(aIEEENumber);
end;

function TIEEEFloat.GetIEEENumber: TIEEENumber;
begin
  result := fIEEENumber;
end;

function TIEEEFloat.GetSingleValue: Single;
begin
  result := fSingleValue;
end;

procedure TIEEEFloat.SetIEEENumber(const Value: TIEEENumber);
begin
  fIEEENumber := Value;
  fSingleValue := IEEEToSingle(Value);
end;

procedure TIEEEFloat.SetSingleValue(const Value: Single);
begin
  fSingleValue := Value;
  fIEEENumber := SingleToIEEE(Value);
end;

{ Interne Konvertierungsroutinen }

{$R-}      // Rangechecks off
type
  cvtFL = record
            case integer of
              0: (f: Single);
              1: (l: longint);
              2: (s: array[0..1] of word);    {16bit! integer}
              3: (b: array[0..3] of byte);
          end;

function IeeeSingleToLong(var f: Single): longint;
// ieee754 (Single) --> siemens kg *)
var
  src, dst: cvtFL;
  dstExp: byte;
begin
  src.f := f;
  dst.l := 0;
  if src.l <> 0 then
  begin
    dstExp := ((src.s[1] shr 7) and $FF) - 126;
    dst.l := ((src.l shr 1) and $3fffff) or $400000;
    if src.l < 0 then
      dst.l := -dst.l;
    dst.b[3] := dstExp;
  end;
  result := dst.l;
end;

function IeeeLongToSingle(l: longint): Single;
(* Siemens src --> Single *)
var
  src: cvtFL;
  dstExp: word;
  vz: longint;
begin
  src.l := l;
  if src.l <> 0 then
  begin
    vz := src.l and $800000;
    dstExp := src.b[3] + 127;
    src.b[3] := 0;   {exponent löschen}
    if src.l <> 0 then
    begin
      if vz <> 0 then
        src.l := ((not src.l) and $ffffff) + 1;
      if src.l <> 0 then
      begin
        while (src.l and $800000) = 0 do
        begin
          src.l := src.l shl 1;
          dec(dstExp);
        end;
        src.l := src.l shl 1;
        src.b[3] := dstExp;
        src.l := src.l shr 1;
        if vz <> 0 then
          src.l := Longint(Longword(src.l) or $80000000) else
          src.l := src.l and $7FFFFFFF;
       end;
    end;
  end;
  result := src.f;
end;

{ öffentliche Konvertierungsroutinen }

function TIEEEFloat.IeeeToSingle(aIEEENumber: TIEEENumber): Single;
// wandelt IEEE Gleitpunktzahl in Single um
var
  u: cvtFL;
  l: longint;
begin
  result := 0;
  try
    u.b[0] := aIEEENumber.B4; //chr(S5Number[4]);
    u.b[1] := aIEEENumber.B3; //chr(S5Number[3]);
    u.b[2] := aIEEENumber.B2; //chr(S5Number[2]);
    u.b[3] := aIEEENumber.B1; //chr(S5Number[1]);
    l := u.l;
    result := IeeeLongToSingle(l);
  except on E:Exception do
    EProt(self, E, 'IeeeToSingle($%X,$%X,$%X,$%X):%s', [aIEEENumber.B1,
      aIEEENumber.B2, aIEEENumber.B3, aIEEENumber.B4]);
  end;
end;

function TIEEEFloat.SingleToIeee(ASingle: Single): TIEEENumber;
// wandelt Single in IEEE Gleitpunktzahl (4Bytes) um
var
  u: cvtFL;
begin
  try
    //u.l := IeeeSingleToLong(ASingle);  beware ! 26.11.13
    u.f := ASingle;
    Result.B4 := u.b[0];
    Result.B3 := u.b[1];
    Result.B2 := u.b[2];
    Result.B1 := u.b[3];
  except on E:Exception do
    EProt(self, E, 'SingleToIeee(%f)', [aSingle]);
  end;
end;

function TIEEEFloat.ToSingle: single;
var
  u: cvtFL;
  // l: longint;
begin
  result := 0;
  try
    u.b[0] := fIEEENumber.B4; //chr(S5Number[4]);
    u.b[1] := fIEEENumber.B3; //chr(S5Number[3]);
    u.b[2] := fIEEENumber.B2; //chr(S5Number[2]);
    u.b[3] := fIEEENumber.B1; //chr(S5Number[1]);
    // l := u.l;
    result := u.f;
  except on E:Exception do
    EProt(self, E, 'IeeeToSingle($%X,$%X,$%X,$%X):%s', [fIEEENumber.B1,
      fIEEENumber.B2, fIEEENumber.B3, fIEEENumber.B4]);
  end;
end;

initialization

finalization
  if fIEEEFloat <> nil then
  begin
    fIEEEFloat.Free;
    fIEEEFloat := nil;
  end;
end.
