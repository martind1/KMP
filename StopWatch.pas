unit StopWatch;
(* Stoppuhr mit mehreren Timern. Ein Objekt (SW) ist immer vorhanden
   Bsp.: SW[0].Start;  SW[0].Stop;  I := SW[1].ValueMs;  SW.ENum(SWFunc);
   procedure SWFunc(ITimer: integer; Sender: TSWTimer);
   24.05.04 MD  Counter
   04.11.07 MD  StartExcl: alle anderen Timer (auﬂer 0) stoppen
*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TSWTimer = class(TObject)
  private
    { Private-Deklarationen }
    FValueMs: integer;
    FCounter: integer;
    function GetValueSec: double;
    procedure SetValueSec(const Value: double);
    function GetValueMs: integer;
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    StartTime, StopTime: integer;
    Running: boolean;
    procedure Start;
    procedure Stop;
    procedure Reset;
    property ValueMs: integer read GetValueMs write FValueMs;
    property ValueSec: double read GetValueSec write SetValueSec;
    property Counter: integer read FCounter write FCounter;
  end;

  TStopWatchEvent = procedure (ITimer: integer; Sender: TSWTimer) of object;

  TStopWatch = class(TObject)
  private
    { Private-Deklarationen }
    FTimerList: TList;
    function GetSWTimer(ITimer: Integer): TSWTimer;
    function GetValueMs(ITimer: Integer): integer;
    function GetValueSec(ITimer: Integer): double;
    procedure SetValueMs(ITimer: Integer; const Value: integer);
    procedure SetValueSec(ITimer: Integer; const Value: double);
    function GetCounter(ITimer: Integer): integer;
    procedure SetCounter(ITimer: Integer; const Value: integer);
    procedure ProtEnum(ITimer: integer; Sender: TSWTimer);
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create;
    destructor Destroy; override;
    procedure Start(ITimer: integer);
    procedure StartExcl(ITimer: integer);  //alle anderen (auﬂer 0) stoppen
    procedure Stop(ITimer: integer);
    procedure Reset(ITimer: integer);
    procedure ENum(Fkt: TStopWatchEvent);
    procedure Prot;
    property SWTimer[ITimer: Integer]: TSWTimer read GetSWTimer; default;
    property ValueMs[ITimer: Integer]: integer read GetValueMs write SetValueMs;
    property ValueSec[ITimer: Integer]: double read GetValueSec write SetValueSec;
    property Counter[ITimer: Integer]: integer read GetCounter write SetCounter;
  end;

function SW: TStopWatch;

implementation

uses
  Prots;

var
  fSW: TStopWatch;

function SW: TStopWatch;
begin
  if fSW = nil then
    fSW := TStopWatch.Create;
  result := fSW;
end;

{ TStopWatch }

constructor TStopWatch.Create;
begin
  FTimerList := TList.Create;
end;

destructor TStopWatch.Destroy;
var
  I: integer;
begin
  for I := 0 to FTimerList.Count - 1 do
    TSWTimer(FTimerList[I]).Free;
  FTimerList.Free;
  inherited;
end;

procedure TStopWatch.ENum(Fkt: TStopWatchEvent);
var
  I: integer;
begin
  for I := 0 to FTimerList.Count - 1 do
    Fkt(I, TSWTimer(FTimerList[I]));
end;

procedure TStopWatch.ProtEnum(ITimer: integer; Sender: TSWTimer);
begin
  ProtA('SW[%d]: %6d ms', [ITimer, Sender.ValueMs]);
end;

procedure TStopWatch.Prot;
begin
  ENum(ProtEnum);
end;

function TStopWatch.GetCounter(ITimer: Integer): integer;
begin
  result := SWTimer[ITimer].Counter;
end;

function TStopWatch.GetSWTimer(ITimer: Integer): TSWTimer;
var
  I: integer;
begin
  if FTimerList.Count <= ITimer then
    for I := FTimerList.Count to ITimer do
      FTimerList.Add(TSWTimer.Create);
  result := TSWTimer(FTimerList[ITimer]);
end;

function TStopWatch.GetValueMs(ITimer: Integer): integer;
begin
  result := SWTimer[ITimer].ValueMs;
end;

function TStopWatch.GetValueSec(ITimer: Integer): double;
begin
  result := SWTimer[ITimer].ValueSec;
end;

procedure TStopWatch.Reset(ITimer: integer);
begin
  SWTimer[ITimer].Reset;
end;

procedure TStopWatch.SetCounter(ITimer: Integer; const Value: integer);
begin
  SWTimer[ITimer].Counter := Value;
end;

procedure TStopWatch.SetValueMs(ITimer: Integer; const Value: integer);
begin
  SWTimer[ITimer].ValueMs := Value;
end;

procedure TStopWatch.SetValueSec(ITimer: Integer; const Value: double);
begin
  SWTimer[ITimer].ValueSec := Value;
end;

procedure TStopWatch.Start(ITimer: integer);
begin
  SWTimer[ITimer].Start;
end;

procedure TStopWatch.StartExcl(ITimer: integer);
//alle anderen  (auﬂer 0) stoppen
var
  I: integer;
begin
  for I := 1 to FTimerList.Count - 1 do
    SWTimer[I].Stop;
  SWTimer[ITimer].Start;
end;

procedure TStopWatch.Stop(ITimer: integer);
begin
  SWTimer[ITimer].Stop;
end;

{ TSWTimer }

function TSWTimer.GetValueMs: integer;
begin
  if Running then
    Result := FValueMs + StopTime - StartTime else
    Result := FValueMs;
end;

function TSWTimer.GetValueSec: double;
begin
  result := ValueMs / 1000;
end;

procedure TSWTimer.Reset;
begin
  FValueMs := 0;
  FCounter := 0;
  Running := false;
end;

procedure TSWTimer.SetValueSec(const Value: double);
begin
  FValueMs := round(Value * 1000);
end;

procedure TSWTimer.Start;
begin
  if not Running then
  begin
    TicksReset(StartTime);
    Inc(FCounter);
    Running := true;
  end;
end;

procedure TSWTimer.Stop;
begin
  if Running then
  begin
    Running := false;
    TicksReset(StopTime);
    FValueMs := FValueMs + StopTime - StartTime;
  end;
end;

initialization
  { initialization-Abschnitt }
finalization
  { finalization-Abschnitt }
  if fSW <> nil then
  begin
    fSW.Free;
    fSW := nil;
  end;
end.
