unit Cpor_kmp;
(* Kommunikation mit der seriellen Schnittstelle  (MSCOMM)
28.07.01 MD ComShare
16.01.03 MD IsActive
15.03.03 MD ComSimul
10.10.08 MD TWSPort und TCustomPort
01.10.09 MD UdpPort
24.11.11 md  Flush: Sendedaten werden erst beim Aufruf von FlushBuff / InCount geschrieben
                    somit gibt es keine Zeichenverzugszeit mehr (Problem bei Schenk u.a.)

CustomPort:
ComPort.Open
ComPort.Close;
ComPort.Reset;
ComPort.ErrorCode :=
ComPort.ErrorStr
ComPort.WriteEcho(Data, Len, true)
ComPort.Write(Data, Len);
ComPort.Write2Dle(Data, Len);
ComPort.InCount > 0
ComPort.Read(@aChar, 1);
ComPort.DoProt(cmWrite, Data, Len);
ComPort.TimeOut :=
ComPort.BusyFlag
ComPort.Bcc := 0;


*)
interface

uses Messages, WinTypes, WinProcs, Classes, Forms, SysUtils;

const
  dcb_Binary         = $00000001;
  dcb_Parity         = $00000002;
  dcb_OutxCtsFlow    = $00000004;
  dcb_OutxDsrFlow    = $00000008;
  dcb_DtrControl     = $00000030;
  dcb_DsrSensitivity = $00000040;
  dcb_ContOnXoff     = $00000080;

  dcb_OutX           = $00000100;
  dcb_InX            = $00000200;
  dcb_ErrorChar      = $00000400;
  dcb_Null           = $00000800;
  dcb_RtsControl     = $00003000;
  dcb_AbortOnError   = $00004000;
  dcb_Dummy2         = $FFFF8000;

{ Events }

const
  ev_RXChar  = $0001;    { Any Character received       }
  ev_RXFlag  = $0002;    { Received certain character   }
  ev_TXEmpty = $0004;    { Transmitt Queue Empty        }
  ev_CTS     = $0008;    { CTS changed state            }
  ev_DSR     = $0010;    { DSR changed state            }
  ev_RLSD    = $0020;    { RLSD changed state           }
  ev_Break   = $0040;    { BREAK received               }
  ev_Err     = $0080;    { Line status error occurred   }
  ev_Ring    = $0100;    { Ring signal detected         }
  ev_PErr    = $0200;    { Printer error occured        }
  ev_CTSS    = $0400;    { CTS state                    }
  ev_DSRS    = $0800;    { DSR state                    }
  ev_RLSDS   = $1000;    { RLSD state                   }
  ev_RingTe  = $2000;    { Ring trailing edge indicator }

const
  ce_RXOver   = $0001;   { Receive Queue overflow       }
  ce_Overrun  = $0002;   { Receive Overrun Error        }
  ce_RXParity = $0004;   { Receive Parity Error         }
  ce_Frame    = $0008;   { Receive Framing error        }
  ce_Break    = $0010;   { Break Detected               }
  ce_CTSTO    = $0020;   { CTS Timeout                  }
  ce_DSRTO    = $0040;   { DSR Timeout                  }
  ce_RLSDTO   = $0080;   { RLSD Timeout                 }
  ce_TXFull   = $0100;   { TX Queue is full             }
  ce_PTO      = $0200;   { LPTx Timeout                 }
  ce_IOE      = $0400;   { LPTx I/O Error               }
  ce_DNS      = $0800;   { LPTx Device not selected     }
  ce_OOP      = $1000;   { LPTx Out-Of-Paper            }
  ce_Mode     = $8000;   { Requested mode unsupported   }

const
 SOH = 1;        {^A}
 STX = 2;        {^B}
 ETX = 3;        {^C}
 EOT = 4;        {^D}
 ENQ = 5;        {^E}
 ACK = 6;        {^F}
 BEL = 7;        {^G}
 BS = 8;         {^H}
 Tab = 9;        {^I}
 LF = 10;        {^J}
 VT = 11;        {^K}
 FF = 12;        {^L}
 CR = 13;        {^M}
 SO = 14;        {^N}
 SI = 15;        {^O}
 DLE = 16;       {^P}
 DC1 = 17;       {^Q}
 NAK = 21;       {^U}
 SYN = 22;       {^V}
 ETB = 23;       {^W}
 ESC = 27;       {^[}

type
  TBaudRate = (br110, br300, br600, br1200, br2400, br4800, br9600, br14400,
               br19200, br38400, br56000, br128000, br256000);
  TParityBits = (pbNone, pbOdd, pbEven, pbMark, pbSpace);
  TDataBits = (dbFour, dbFive, dbSix, dbSeven, dbEight);
  TStopBits = (sbOne, sbOnePointFive, sbTwo);
  TCommEvent = (ceBreak, ceCts, ceCtss, ceDsr, ceErr, cePErr, ceRing, ceRlsd,
                ceRlsds, ceRxChar, ceRxFlag, ceTxEmpty);
  TFlowControl = (fcNone, fcRTSCTS, fcXONXOFF);
  TCommEvents = set of TCommEvent;
  TComModus = (cmRead, cmWrite, cmOpen, cmClose, cmError);

type

  TNotifyCommEventEvent = procedure(Sender: TObject; CommEvent: TCommEvents) of object;
  TNotifyReceiveEvent = procedure(Sender: TObject; Count: Word) of object;
  TNotifyTransmitLowEvent = procedure(Sender: TObject; Count: Word) of object;
  TComProtEvent = procedure(Sender: TObject; ComModus: TComModus;
    Data: PAnsiChar; Len: Word) of object;

  TCustomPort = class(TComponent)
  (*
ComPort.Open
ComPort.Close;
ComPort.Reset;
ComPort.ErrorCode :=
ComPort.ErrorStr
ComPort.WriteEcho(Data, Len, true)
ComPort.Write(Data, Len);
ComPort.Write2Dle(Data, Len);
ComPort.Read(@aChar, 1);
ComPort.DoProt(cmWrite, Data, Len);
ComPort.InCount > 0
ComPort.TimeOut :=
ComPort.BusyFlag
ComPort.Bcc := 0;
  *)
  private
    FOnProt: TComProtEvent;
    FSMessProt: boolean;                 {kann zum Protokollieren gesetzt werden}
    FTimeOut: Word;
    FVersion: Single;
    procedure SetSMessProt(Value: boolean);
    procedure SetPort(Value: integer);
    function GetBusyFlag: boolean;    {true=Comport von anderem Objekt belegt}
    procedure SetBusyFlag(Value: boolean);
  protected
    FPort: integer;
    FParams: string;
    procedure BuildParams; virtual;
    procedure SetParams(Value: string); virtual;
  public
    Bcc: byte;
    ErrorCode: integer;
    ErrorStr: string;
    OldComModus: TComModus;
    constructor Create(AOwner: TComponent); override;
    function Open: Boolean; virtual;
    procedure Close; virtual;
    function IsActive: boolean; virtual;
    procedure Reset; virtual;
    procedure Write(Data: PAnsiChar; Len: Word); virtual;
    procedure Write2Dle(Data: PAnsiChar; Len: Word); virtual;
    procedure WriteEcho(Data: PAnsiChar; Len: Word; No2Dle: boolean); virtual;
    procedure Read(Data: PAnsiChar; Len: Word); virtual;
    procedure DoProt(ComModus: TComModus; Data: PAnsiChar; Len: Word); virtual;
    function GetErrorStr: string;
    function InCount: integer; virtual;
    function BusyId: string; virtual;
    property SMessProt: boolean read FSMessProt write SetSMessProt;
    property BusyFlag: boolean read GetBusyFlag write SetBusyFlag;
  published
    property Port: integer read FPort write SetPort;
    property Version: Single read FVersion;
    property TimeOut: Word read FTimeOut write FTimeOut;
    property Params: string read FParams write SetParams;
    property OnProt: TComProtEvent read FOnProt write FOnProt;
  end;

  TComPort = class(TCustomPort)
  private
    FBaudRate: TBaudRate;
    FParityBits: TParityBits;
    FDataBits: TDataBits;
    FStopBits: TStopBits;
    FFlowControl: TFlowControl;
    FRxBufSize: Word;
    FTxBufSize: Word;
    FRxFull: Word;
    FTxLow: Word;
    FEvents: TCommEvents;
    FOnCommEvent: TNotifyCommEventEvent;
    FOnReceive: TNotifyReceiveEvent;
    FOnTransmitLow: TNotifyTransmitLowEvent;
    //beware FParams: string;
    FhWnd: hWnd;
    OutBuff: AnsiString;
    procedure SetBaudRate(Value: TBaudRate);
    procedure SetParityBits(Value: TParityBits);
    procedure SetDataBits(Value: TDataBits);
    procedure SetStopBits(Value: TStopBits);
    procedure SetFlowControl(Value: TFlowControl);
    procedure SetRxBufSize(Value: Word);
    procedure SetTxBufSize(Value: Word);
    procedure SetRxFull(Value: Word);
    procedure SetTxLow(Value: Word);
    procedure SetEvents(Value: TCommEvents);
    function parseOpenErr(Errcode: Integer): string;
    function parseGenErr: string;
    function ParseGenErrCode(ErrCode : cardinal): string;
    procedure WriteFlush(Data: PAnsiChar; Len: Word);
  protected
    procedure BuildParams; override;
    procedure SetParams(Value: string); override;
  public
    cId: Integer;                        { handle to comm port }
    ComStat: TComStat;
    InReadTimeOut : boolean;
    ShareFlag: boolean;               {true=Cid ist von einem anderem Object}
    ComSimul: boolean;                {Comport wird nicht geöffnet}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Write(Data: PAnsiChar; Len: Word); override;
    procedure Write2Dle(Data: PAnsiChar; Len: Word); override;
    procedure WriteEcho(Data: PAnsiChar; Len: Word; No2Dle: boolean); override;
    procedure Read(Data: PAnsiChar; Len: Word); override;
    procedure ReadTimeOut(Data: PAnsiChar; var Len: Word; Delim, Delim2: AnsiChar); {Lesen mit TimeOut}
    function InCount: integer; override; {Anzahl der Zeichen im Empfangspuffer}
    function BusyId: string; override;
    function OutCount: integer;   {Anzahl der Zeichen im Sendepuffer}
    function Open: Boolean; override; {Schmittstelle öffnen}
    procedure Close; override; {Schmittstelle schliessen}
    function IsActive: boolean; override;
    procedure Reset; override;
    function SetState(var DCB: TDCB): Integer;           {SetCommState Win16+32}
    function SetEventMask(Cid: Integer; EvtMask: Word): boolean;
                                                     {SetCommEventMask Win16+32}
    function EnableNotification(A: Integer; B: HWnd; C, D: Integer): Bool;
                                               {EnableCommNotification Win16+32}
    function GetError(Cid: Integer; var Stat: TComStat): Integer;
                                                         {GetCommError Win16+32}
    function WritePort(Cid: Integer; Buf: PAnsiChar; Size: Integer): Integer;
                                                            {WriteComm Win16+32}
    function GetEventMask(Cid, EvtMask: Integer): cardinal;
                                                     {GetCommEventMask Win16+32}
    function ReadPort(Cid: Integer; Buf: PAnsiChar; Size: Integer): Integer;
                                                             {ReadComm Win16+32}
    function OpenPort(ComName: PChar; InQueue, OutQueue: Word): Integer;
                                                             {OpenComm Win16+32}
    procedure FlushBuff;  //OutBuff senden
  published
    property Version;
    property TimeOut;
    property Port;
    property BaudRate: TBaudRate read FBaudRate write SetBaudRate;
    property ParityBits: TParityBits read FParityBits write SetParityBits;
    property DataBits: TDataBits read FDataBits write SetDataBits;
    property StopBits: TStopBits read FStopBits write SetStopBits;
    property FlowControl: TFlowControl read FFlowControl write SetFlowControl;
    property TxBufSize: Word read FTxBufSize write SetTxBufSize;
    property RxBufSize: Word read FRxBufSize write SetRxBufSize;
    property RxFullCount: Word read FRxFull write SetRxFull;
    property TxLowCount: Word read FTxLow write SetTxLow;
    property Events: TCommEvents read FEvents write SetEvents;
    property OnCommEvent: TNotifyCommEventEvent read FOnCommEvent write FOnCommEvent;
    property OnReceive: TNotifyReceiveEvent read FOnReceive write FOnReceive;
    property OnTransmitLow: TNotifyTransmitLowEvent read FOnTransmitLow write FOnTransmitLow;

    property OnProt;
    property Params;
  end;

const
  ComModusChars: array[TComModus] of char = ('R','W','O','C', 'E');

implementation

uses
  Dialogs, Controls,
  GNav_Kmp, Err__Kmp, Prots;
type
  TDummyControl = class(TCustomControl);
var
  ComPortList: TStringList;      {global. vergl. ShareFlag}
  ComBusyList: TStringList;      {global. für BusyFlag}

function TComPort.SetState(var DCB: TDCB): Integer;
{SetCommState Win16+32}
begin
  result := integer(SetCommState(cId, DCB));
end;

function TComPort.SetEventMask(Cid: Integer; EvtMask: Word): boolean;
{SetCommEventMask Win16+32}
//  result16: PWord;
begin
  result := SetCommMask(cId, EvtMask);
end;

function TComPort.EnableNotification(A: Integer; B: HWnd; C, D: Integer): Bool;
{EnableCommNotification Win16+32}
begin
  result := true;        {WaitCommEvent}
end;

function TComPort.GetError(Cid: Integer; var Stat: TComStat): Integer;
{GetCommError Win16+32}
var
  Errors: DWORD;
  Stat32: TComStat;
begin
  GetLastError;
  ClearCommError(Cid, Errors, @Stat32);
  Stat := Stat32;
  result := Errors; {Fehlermaske oder 0 wenn OK}
end;

function TComPort.WritePort(Cid: Integer; Buf: PAnsiChar; Size: Integer): Integer;
{WriteComm Win16+32}
var
  result32: boolean;
  Written: DWORD;
begin
  result32 := WriteFile(Cid, Buf^, Size, Written, nil);
  if result32 then
    result := Written else
    result := 0;
end;

function TComPort.GetEventMask(Cid, EvtMask: Integer): cardinal;
{GetCommEventMask Win16+32}
var
  result32: boolean;
begin
  result32 := GetCommMask(THandle(Cid), DWORD(EvtMask));
  if result32 then
    result := EvtMask else
    result := 0;
end;

function TComPort.ReadPort(Cid: Integer; Buf: PAnsiChar; Size: Integer): Integer;
{ReadComm Win16+32}
var
  result32: boolean;
  NumRead: DWORD;
begin
  result32 := ReadFile(Cid, Buf^, Size, NumRead, nil);
  if result32 then
    result := NumRead else
    result := 0;
end;

function TComPort.OpenPort(ComName: PChar; InQueue, OutQueue: Word): Integer;
{OpenComm Win16+32}
var
  result32: THandle;
begin
  result32 := CreateFile(ComName,
                        GENERIC_READ or GENERIC_WRITE, {dwDesiredAccess}
                        0,                             {dwShareMode}
                        nil,                           {PSecurityAttributes}
                        OPEN_EXISTING,                 {dwCreationDisposition}
                        0,                             {dwFlagsAndAttributes}
                        0                              {hTemplateFile}
                      );
  result := integer(result32);
end;


(* Params -- string *)

procedure TComPort.BuildParams;
(* Params string anhand Baud, Parity, Data, Stop, Flow aufbauen *)
var
  S: string;
begin
  FParams := IntToStr(FPort) + ':';
  S := '9600';
  case BaudRate of
    br110: S := '110';
    br300: S := '300';
    br600: S := '600';
    br1200: S := '1200';
    br2400: S := '2400';
    br4800: S := '4800';
    br9600: S := '9600';
    br14400: S := '14400';
    br19200: S := '19200';
    br38400: S := '38400';
    br56000: S := '56000';
    br128000: S := '128000';
    br256000: S := '256000';
  end;
  FParams := FParams + S;
  S := 'N';
  case ParityBits of
    pbNone: S := 'N';
    pbOdd: S := 'O';
    pbEven: S := 'E';
    pbMark: S := 'M';
    pbSpace: S := 'S';
  end;
  FParams := FParams + ',' + S;
  S := '8';
  case DataBits of
    dbFour: S := '4';
    dbFive: S := '5';
    dbSix: S := '6';
    dbSeven: S := '7';
    dbEight: S := '8';
  end;
  FParams := FParams + ',' + S;
  S := '1';
  case StopBits of
    sbOne: S := '1';
    sbOnePointFive: S := '1.5';
    sbTwo: S := '2';
  end;
  FParams := FParams + ',' + S;
  S := 'N';
  case FlowControl of
    fcNone: S := 'N';
    fcRTSCTS: S := 'H';
    fcXONXOFF: S := 'S';
  end;
  FParams := FParams + ',' + S;
end;

procedure TComPort.SetParams(Value: string);
(* Baud, Parity, Data, Stop, Flow anhand Params string aufbauen *)
var
  Tok, TokStr: PAnsiChar;
  ABaud, ABaudDiv, AStop: integer;
  OldDecimalSeparator: char;
  NextStr: PAnsiChar;
const
  Trenner = ' ,;:';
begin
  TokStr := StrPNew(AnsiString(Value));
  try
    Tok := StrTok(TokStr, Trenner, NextStr);
    if Tok = nil then
      raise Exception.Create('Port');
    FPort := StrToInt(String(StrPas(Tok)));

    Tok := StrTok(nil, Trenner, NextStr);
    if Tok = nil then
      raise Exception.Create('Baud');
    ABaud := StrToInt(String(StrPas(Tok))) mod 10000;
    ABaudDiv := StrToInt(String(StrPas(Tok))) DIV 10000;
    case ABaud of
      110: FBaudRate := br110;
      300: FBaudRate := br300;
      600: FBaudRate := br600;
      1200: FBaudRate := br1200;
      2400: FBaudRate := br2400;
      4800: FBaudRate := br4800;
      9600: FBaudRate := br9600;
      4400: FBaudRate := br14400;
      9200: FBaudRate := br19200;
      8400: FBaudRate := br38400;
      6000: case ABaudDiv of
              5: FBaudRate := br56000;
             25: FBaudRate := br256000;
            end;
      8000: FBaudRate := br128000;
    end;
    (*case ABaud of
      110: FBaudRate := br110;
      300: FBaudRate := br300;
      600: FBaudRate := br600;
      1200: FBaudRate := br1200;
      2400: FBaudRate := br2400;
      4800: FBaudRate := br4800;
      9600: FBaudRate := br9600;
      1440: FBaudRate := br14400;
      1920: FBaudRate := br19200;
      3840: FBaudRate := br38400;
      5600: FBaudRate := br56000;
      1280: FBaudRate := br128000;
      2560: FBaudRate := br256000;
    end;*)
    Tok := StrTok(nil, Trenner, NextStr);
    if Tok = nil then
      raise Exception.Create('Parity');
    case UpperCase(String(StrPas(Tok)))[1] of
      'N': FParityBits := pbNone;
      'O': FParityBits := pbOdd;
      'E': FParityBits := pbEven;
      'M': FParityBits := pbMark;
      'S': FParityBits := pbSpace;
    end;

    Tok := StrTok(nil, Trenner, NextStr);
    if Tok = nil then
      raise Exception.Create('Data');
    case StrToInt(String(StrPas(Tok))) of
      4: FDataBits := dbFour;
      5: FDataBits := dbFive;
      6: FDataBits := dbSix;
      7: FDataBits := dbSeven;
      8: FDataBits := dbEight;
    end;

    Tok := StrTok(nil, Trenner, NextStr);
    if Tok = nil then
      raise Exception.Create('Stop');
    OldDecimalSeparator := FormatSettings.DecimalSeparator;
    FormatSettings.DecimalSeparator := '.';
    AStop := Round(10 * StrToFloat(String(StrPas(Tok))));
    FormatSettings.DecimalSeparator := OldDecimalSeparator;
    case AStop of
      10: FStopBits := sbOne;
      15: FStopBits := sbOnePointFive;
      20: FStopBits := sbTwo;
    end;

    Tok := StrTok(nil, Trenner, NextStr);
    if Tok <> nil then
      case Uppercase(String(StrPas(Tok)))[1] of
        'N': FFlowControl := fcNone;
        'H': FFlowControl := fcRTSCTS;
        'S': FFlowControl := fcXONXOFF;
      end;

    FParams := Value;
  except on E:Exception do
    //MessageFmt('ComPort.Params:Syntaxfehler:%s', [E.Message], mtWarning, [mbOK], 0);
    EError('ComPort.Params:Syntaxfehler:%s', [E.Message]);
  end;
  StrDispose(TokStr);
end;

{ Set baud rate: 110-256,000. Notice that this will change the baud rate of the port
 immediately-- if it is currently open! This goes for most of the other com port
 settings below as well.}
procedure TComPort.SetBaudRate(Value: TBaudRate);
var
  DCB: TDCB;
begin
  FBaudRate := Value;
  BuildParams;
  if cId >= 0 then begin
    GetCommState(cId, DCB);
    case Value of
      br110: DCB.BaudRate := 110;
      br300: DCB.BaudRate := 300;
      br600: DCB.BaudRate := 600;
      br1200: DCB.BaudRate := 1200;
      br2400: DCB.BaudRate := 2400;
      br4800: DCB.BaudRate := 4800;
      br9600: DCB.BaudRate := 9600;
      br14400: DCB.BaudRate := 14400;
      br19200: DCB.BaudRate := 19200;
      br38400: DCB.BaudRate := 38400;
      br56000: DCB.BaudRate := 56000;
      br128000: DCB.BaudRate := 128000;
      br256000: DCB.BaudRate := 256000;
    end;
    SetState(DCB);
  end;
end;

{ set parity: none, odd, even, mark, space }
procedure TComPort.SetParityBits(Value: TParityBits);
var
  DCB: TDCB;
begin
  FParityBits := Value;
  BuildParams;
  if cId < 0 then
    exit;
  GetCommState(cId, DCB);
  case Value of
    pbNone: DCB.Parity := 0;
    pbOdd: DCB.Parity := 1;
    pbEven: DCB.Parity := 2;
    pbMark: DCB.Parity := 3;
    pbSpace: DCB.Parity := 4;
  end;
  SetState(DCB);
end;

{ set # of data bits 4-8 }
procedure TComPort.SetDataBits(Value: TDataBits);
var
  DCB: TDCB;
begin
  FDataBits := Value;
  BuildParams;
  if cId < 0 then
    exit;
  GetCommState(cId, DCB);
  case Value of
    dbFour: DCB.ByteSize := 4;
    dbFive: DCB.ByteSize := 5;
    dbSix: DCB.ByteSize := 6;
    dbSeven: DCB.ByteSize := 7;
    dbEight: DCB.ByteSize := 8;
  end;
  SetState(DCB);
end;

{ set number of stop bits 1, 1.5 or 2 }
procedure TComPort.SetStopBits(Value: TStopBits);
var
  DCB: TDCB;
begin
  FStopBits := Value;
  BuildParams;
  if cId < 0 then
    exit;
  GetCommState(cId, DCB);
  case Value of
    sbOne: DCB.StopBits := 0;
    sbOnePointFive: DCB.StopBits := 1;
    sbTwo: DCB.StopBits := 2;
  end;
  SetState(DCB);
end;

{ Set flow control: None, RTS/CTS, or Xon/Xoff. Flow control works in conjunction
with the read and write buffers to ensure that the flow of data *will* stop if
the buffers get critically full. If there is no flow control, it's possible
to lose data.. with flow control on, technically, it's impossible since if the
buffers get full, flow control will kick in and stop the data flow until the
buffers have time to get clear. }
procedure TComPort.SetFlowControl(Value: TFlowControl);
var
  DCB: TDCB;
begin
  FFlowControl := Value;
  BuildParams;
  if cId < 0 then
    exit;
  GetCommState(cId, DCB);
  DCB.Flags := DCB.Flags and not
    (dcb_OutxCtsFlow or dcb_OutxDsrFlow or dcb_OutX or dcb_InX);
  DCB.Flags := DCB.Flags or RTS_CONTROL_HANDSHAKE or DTR_CONTROL_HANDSHAKE;
  case Value of
    fcNone: DCB.Flags := DCB.Flags and not
      (dcb_OutxCtsFlow or dcb_OutxDsrFlow);
    fcRTSCTS: DCB.Flags := DCB.Flags or dcb_OutxCtsFlow or dcb_OutxDsrFlow;
    fcXONXOFF: DCB.Flags := DCB.Flags or dcb_OutX or dcb_InX;
  end;
  SetState(DCB);
end;

{ RxBuf is the amount of memory set aside to buffer reads (incoming data)
to the serial port. It is possible to overflow the read buffer depending on how
frequently you are servicing (reading) the incoming data and how fast data is
coming in the serial port. NOTE: This setting takes effect only when opening
the port. }
procedure TComPort.SetRxBufSize(Value: Word);
begin
  FRxBufSize := Value;
end;

{ TxBuf is the amount of memory set aside to buffer writes (outgoing data)
to the serial port. Must be larger than any chunk of data you plan to write at
once. It is possible to overflow the tx buffer depending on how fast data
is going out of the modem, and how fast you're writing to the serial port. NOTE: this
setting takes effect only when opening the port. }
procedure TComPort.SetTxBufSize(Value: Word);
begin
  FTxBufSize := Value;
end;

{ RxFull indicates the number of bytes the COM driver must write to the
application's input queue before sending a notification message. The message
signals the application to read information from the input queue. This "forces"
the driver to send notification during periods of data "streaming." It will
stop what it's doing and notify you when it gets at least this many chars.
This will only affect data streaming; normally data is sent during lulls in
the "stream." If there are no lulls, this setting comes into effect. The
event OnReceive fires when ANY amount of data is received. The maximum
chunk of data you will receive is set by the RxFull amount. }
procedure TComPort.SetRxFull(Value: Word);
begin
  FRxFull := Value;
  if cId < 0 then
    exit;
  EnableNotification(cId, FhWnd, FRxFull, FTxLow);
end;

{ TxLow Indicates the minimum number of bytes in the output queue. When the
number of bytes in the output queue falls below this number, the COM driver
sends the application a notification message, signaling it to write information
to the output queue. This can be handy to avoid overflowing the (outgoing)
read buffer. The event OnTransmitLow fires when this happens.}
procedure TComPort.SetTxLow(Value: Word);
begin
  FTxLow := Value;
  if cId < 0 then
    exit;
  EnableNotification(cId, FhWnd, FRxFull, FTxLow);
end;

{ Build the event mask. Indicates which misc events we want the comm control to
tell us about. }
procedure TComPort.SetEvents(Value: TCommEvents);
var
  Events: Word;
begin
  FEvents := Value;
  if cId < 0 then
    exit;
  Events := 0;
  if ceBreak in FEvents then Events := Events or EV_BREAK;
  if ceCts in FEvents then Events := Events or EV_CTS;
  if ceCtss in FEvents then Events := Events or EV_CTSS;
  if ceDsr in FEvents then Events := Events or EV_DSR;
  if ceErr in FEvents then Events := Events or EV_ERR;
  if cePErr in FEvents then Events := Events or EV_PERR;
  if ceRing in FEvents then Events := Events or EV_RING;
  if ceRlsd in FEvents then Events := Events or EV_RLSD;
  if ceRlsds in FEvents then Events := Events or EV_RLSDS;
  if ceRxChar in FEvents then Events := Events or EV_RXCHAR;
  if ceRxFlag in FEvents then Events := Events or EV_RXFLAG;
  if ceTxEmpty in FEvents then Events := Events or EV_TXEMPTY;
  SetEventMask(cId, Events);
end;

{ This is the message handler for the invisible window; it handles comm msgs
that are handed to the invisible window. We hook into these messages using
EnableNotification and our invisible window handle. This routine hands
off to the "do(x)" routines below. }

(* kein WM_COMNOTIFY mehr, alles über Events. *)

{ construct: create invisible message window, set default values }
constructor TComPort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ErrorStr := '';
  FTimeOut := 1000;
  FVersion := 1.00;
  FPort := 2;
  FBaudRate := br9600;
  FParityBits := pbNone;
  FDataBits := dbEight;
  FStopBits := sbOne;
  FTxBufSize := 2048;
  FRxBufSize := 2048;
  FRxFull := 512;
  FTxLow := 512;
  FEvents := [];
  cId := -1;
end;

{ destructor: close invisible message window, close comm port }
destructor TComPort.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    while InReadTimeOut and (GNavigator <> nil) do
      GNavigator.ProcessMessages;
  end;
  DeallocatehWnd(FhWnd);
  if cId >= 0 then
    Close;
  ComPortList.Values[BusyId] := '';
  inherited Destroy;
end;

function TComPort.InCount: integer;
begin
  if cId >= 0 then
  begin
    FlushBuff;
    ErrorCode := GetError(cId, ComStat);
    result := ComStat.cbInQue;
  end else
    result := 0;
end;

function TComPort.OutCount: integer;
begin
  if cId >= 0 then
  begin
    ErrorCode := GetError(cId, ComStat);
    result := ComStat.cbOutQue;
  end else
    result := 0;
end;

function TComPort.BusyId: string;
begin
  Result := IntToStr(FPort);
end;

{ Write data to comm port. This routine will reject an attempt
 to write a chunk of data larger than the write buffer size. WARNING: This
 routine could *potentially* wait forever for the buffer to clear. But at least
 your machine won't lock up since we're processing messages in the wait loop.
 NOTE: theoretically, you should check the ErrorStr property for errors
 after every write. Any ErrorStr during read or write can stop flow of data. }
procedure TComPort.WriteFlush(Data: PAnsiChar; Len: Word);
var
  I: integer;
begin
  if cId < 0 then
    exit;
  if Len <= 0 then
    exit;
  if Len > FTxBufSize then
  begin
    ErrorCode := -2;
    ErrorStr := 'write larger than transmit buffer size';
    exit;
  end;
  {repeat            sehr schlecht da innerhalb ComProt.DoProt ein ProcessMsg!
    ErrorCode := GetError(cId, ComStat);
    bufroom := FTxBufSize - ComStat.cbOutQue;
    GNavigator.ProcessMessages;
  until bufroom >= len;}
  for I:= 0 to Len-1 do
  begin
    Bcc := Bcc xor ord(Data[I]);
  end;

  if WritePort(cId, Data, Len) < 0 then
    ErrorStr := ParseGenErr else
    DoProt(cmWrite, Data, Len);
  GetEventMask(cId, Integer($FFFF));
end;

procedure TComPort.FlushBuff;
begin
  if OutBuff <> '' then
  begin
    WriteFlush(@OutBuff[1], Length(Outbuff));
    OutBuff := '';
  end;
end;

procedure TComPort.Write(Data: PAnsiChar; Len: Word);
var
  S1: AnsiString;
  I: integer;
begin
  S1 := '';
  for I := 0 to Len - 1 do
  begin
    Bcc := Bcc xor ord(Data[I]);
    S1 := S1 + Data[I];
  end;
  OutBuff := OutBuff + S1;
end;

procedure TComPort.Write2Dle(Data: PAnsiChar; Len: Word);
(* Verdoppelung von DLE *)
var
  I: integer;
begin
  if Len <= 0 then
    exit;
  for I:= 0 to Len-1 do
  begin
    Write(Data+I, 1);
    if ord(Data[I]) = DLE then
      Write(Data+I, 1);            {nochmal}
  end;
end;

procedure TComPort.WriteEcho(Data: PAnsiChar; Len: Word; No2Dle: boolean);
(* Verdoppelung von DLE *)
var
  I: integer;
  L1: word;
  Ch: AnsiChar;
begin
  if Len <= 0 then
    exit;
  for I:= 0 to Len-1 do
  begin
    WriteFlush(Data+I, 1);
    L1 := 1;
    ReadTimeOut(@Ch, L1, #0, #0);
    if not No2Dle then
    begin
      if ord(Data[I]) = DLE then
      begin
        WriteFlush(Data+I, 1);            {nochmal}
        L1 := 1;
        ReadTimeOut(@Ch, L1, #0, #0);
      end;
    end;
  end;
end;

{ Read data from comm port. Should only do read when you've been notified you
 have data. Attempting to read when nothing is in read buffer results
 in spurious Error. You can never read a larger chunk than the read buffer
 size. NOTE: theoretically, you should check the Error property for errors
 after every read. Any Error during read or write can stop flow of data. }
procedure TComPort.Read(Data: PAnsiChar; Len: Word);
begin
  if cId < 0 then
    exit;
  if ReadPort(cId, Data, Len) < 0 then {< 0 Fehler}
    ErrorStr := ParseGenErr else
    DoProt(cmRead, Data, Len);
  GetEventMask(cId, Integer($FFFF));
end;

procedure TComPort.ReadTimeOut(Data: PAnsiChar; var Len: Word;
  Delim, Delim2: AnsiChar);
(* Lesen mit Timeout und Delimiter Überwachung
   wenn kein Delimiter dann ist Delim = 0: Feste Länge in Len
   wenn Delim2<>0 dann wird doppelter Delimiter und Delim ohne folgender Delim2
     nicht als Delim sondern (einmal) als Data verwendet.
   wenn nix gekommen ist dann ist Len = 0 *)
var
  bufroom: Integer;
  TimeStart: longint;
  ReadLen: integer;
  aChar: AnsiChar;
  DelimRead: boolean;
  S3: array[0..2] of AnsiChar;
begin
  if not InReadTimeOut then
  try
    InReadTimeOut := true;
    DelimRead := false;
    ReadLen := 0;
    StrLCopy(Data, '', Len);
    TicksReset(TimeStart);
    repeat
      Application.ProcessMessages;
      ErrorCode := GetError(cId, ComStat);
      bufroom := ComStat.cbInQue;
      if bufroom > 0 then
      begin
        Read(@aChar, 1);
        if DelimRead then
        begin
          if aChar = Delim2 then
          begin
            Len := ReadLen;
            break;
          end else
          if aChar = Delim then
          begin
            S3[0] := Delim;
            S3[1] := #0;
            StrLCat(Data, S3, Len);
            Inc(ReadLen,1);
          end else
          begin
            S3[0] := Delim;
            S3[1] := aChar;
            S3[2] := #0;
            StrLCat(Data, S3, Len);
            Inc(ReadLen,2);
          end;
        end else
        if aChar = Delim then
        begin
          DelimRead := true;
          if Delim2 = #0 then
          begin
            Len := ReadLen;
            break;
          end;
        end else
        begin
          S3[0] := aChar;
          S3[1] := #0;
          StrLCat(Data, S3, Len);
          Inc(ReadLen,1);
          if (ReadLen >= Len) and (Delim = #0) then
          begin
            Len := ReadLen;
            break;
          end;
        end;
      end else
      begin
        if TicksDelayed(TimeStart) > TimeOut then
        begin
          Data[0] := #0;
          Len := 0;
          ErrorCode := CE_PTO;          {timeout}
          break;
        end;
      end;
    until (ErrorCode <> 0);
    if ErrorCode <> 0 then
      ErrorStr := ParseGenErrCode(ErrorCode);
  finally
    InReadTimeOut := false;
  end;
end;

{ failure to open results in a negative cId, this will translate the
  negative cId value into an explanation. }
function TComPort.parseOpenErr(Errcode: Integer): string;
begin
  case DWORD(Errcode) of
    IE_BADID: result := 'Device identifier is invalid or unsupported';
    IE_OPEN: result := 'Device is already open.';
    IE_NOPEN: result := 'Device is not open.';
    IE_MEMORY: result := 'Cannot allocate queues.';
    IE_DEFAULT: result := 'Default parameters are in ErrorStr.';
    IE_HARDWARE: result := 'Hardware not available (locked by another device).';
    IE_BYTESIZE: result := 'Specified byte size is invalid.';
    IE_BAUDRATE: result := 'Device baud rate is unsupported.';
 else
   result := 'Open Error ' + IntToStr(Errcode);
 end;
end;

{ failure to read or write to comm port results in a negative returned
value. This will translate the value into an explanation. }
function TComPort.ParseGenErr: string;
begin
  ErrorCode := GetError(cId, ComStat);
  result := ParseGenErrCode(ErrorCode);
end;

function TComPort.ParseGenErrCode(ErrCode : cardinal): string;
(* erzeugt string anhand ErrCode *)
begin
  case ErrCode of
    0: result := 'OK';
    CE_BREAK: result := 'Hardware detected a break condition.';
    CE_CTSTO: result := 'CTS (clear-to-send) timeout.';
    CE_DNS: result := 'Parallel device was not selected.';
    CE_DSRTO: result := 'DSR (data-set-ready) timeout.';
    CE_FRAME: result := 'Hardware detected a framing Error.';
    CE_IOE: result := 'I/O ErrorStr during communication with parallel device.';
    CE_MODE: result := 'Requested mode is not supported';
    CE_OOP: result := 'Parallel device is out of paper.';
    CE_OVERRUN: result := 'Character was overwritten before it could be retrieved.';
    CE_PTO: result := 'Timeout during communication.';
    CE_RLSDTO: result := 'RLSD (receive-line-signal-detect) timeout.';
    CE_RXOVER: result := 'Receive buffer overflow.';
    CE_RXPARITY: result := 'Hardware detected a parity Error.';
    CE_TXFULL: result := 'Transmit buffer overflow.';
  else
    result := IntToStr(ErrCode) + ':General Error';
  end;
end;

{ Explicitly open port. Returns success/failure, check ErrorStr property for details.
 This routine also begins hooking the comm messages to our invisible window we
 created upon instantiation. Will NOT close port (if open) before re-opening. }
function TComPort.Open: Boolean;
var
  commName: String;
  tempStr: AnsiString;
begin
  result := false;
  ShareFlag := false;
  ErrorCode := 0;
  if (GNavigator <> nil) and (GNavigator.ParamList.Values['COMSIMUL'] = '1') then
  begin
    ComSimul := true;
    ErrorStr := 'ComSimul';
    FTimeOut := 0;
    DMess('ComSimul', [0]);
    result := false;
    exit;
  end;
  if cId >= 0 then
  begin
    ErrorStr := 'Bereits Offen';
    result := true;
    exit;
  end;
  if Fport = 0 then
  begin
    ErrorStr := 'COM-Nummer fehlt';
    exit;
  end;
  close;
  TempStr := AnsiString(ComPortList.Values[IntToStr(Fport)]);
  cId := StrToIntDef(String(TempStr), -1);
  if cId >= 0 then
  begin
    ShareFlag := true;
    ErrorStr := 'Shared';
    result := true;
    Exit;
  end;
  //tempStr := 'COM' + IntToStr(Fport) + ':';
  commName := 'COM' + IntToStr(Fport);
  cId := OpenPort(PChar(commName), RxBufSize, TxBufSize); {Port öffnen}
  tempStr := AnsiString(commName);
  DoProt(cmOpen, PAnsiChar(tempStr), Length(tempStr));
  if cId < 0 then
  begin
    ErrorCode := -1;
    ErrorStr := parseOpenErr(cId);
    result := False;
    exit;
  end;
  SetBaudRate(FBaudRate);
  SetParityBits(FParityBits);
  SetDataBits(FDataBits);
  SetStopBits(FStopBits);
  SetFlowControl(FFlowControl);
  SetEvents(FEvents);
  EnableNotification(cId, FhWnd, FRxFull, FTxLow);
  ComPortList.Values[IntToStr(Fport)] := IntToStr(cId);
  result := True;
end;

procedure TComPort.Reset;
begin
  Close;
  Open;
end;

{ closes the comm port, if it is open. }
procedure TComPort.Close;
var
  ProtInfo: AnsiString;
begin
  if ShareFlag then
  begin
    cId := -1;
  end else
  if cId >= 0 then
  begin
    ProtInfo := AnsiString(Format('close(%d)', [cId]));
    DoProt(cmClose, PAnsiChar(ProtInfo), Length(ProtInfo));
    ErrorStr := ParseGenErr;      {bereits hier da ID noch gültig - 121200}
    CloseHandle(cId);
    ComPortList.Values[IntToStr(Fport)] := '';
    BusyFlag := false;
    cId := -1;
  end;
end;

function TComPort.IsActive: boolean;
begin
  result := cId >= 0;
end;

{ TCustomPort }

procedure TCustomPort.Close;
begin
  EError('TCustomPort.Close is virtual', [0]);
end;

function TCustomPort.Open: Boolean;
begin
  Result := false;
  EError('TCustomPort.Open is virtual', [0]);
end;

function TCustomPort.IsActive: boolean;
begin
  Result := false;
  EError('TCustomPort.IsActive is virtual', [0]);
end;

procedure TCustomPort.Reset;
begin
  EError('TCustomPort.Reset is virtual', [0]);
end;

{ Set com port value. Used when you open the port. NOTE: This only takes effect when
 opening the port-- obviously! Only works for ports 1 thru 9 currently, though I
 think newer versions of Windows support up to 254 comm ports. Set this to port
 zero (0) if you want to disable the comm control.}
procedure TCustomPort.SetPort(Value: integer);
begin
  FPort := Value;
  BuildParams;
end;

procedure TCustomPort.SetSMessProt(Value: boolean);
begin
  FSMessProt := Value;
  if GNavigator <> nil then
    GNavigator.SMessLocked := FSMessProt;     {sperren für andere SMess}
end;

{ returns ErrorStr text (if any) and clears it }
function TCustomPort.GetErrorStr: string;
begin
  Result := ErrorStr;
  ErrorStr := '';
end;

procedure TCustomPort.DoProt(ComModus: TComModus; Data: PAnsiChar; Len: Word);
(* Protokollfunktion *)
var
  S1: string;
begin
  if (GNavigator <> nil) and
     not (csDestroying in GNavigator.ComponentState) and
     (GNavigator.PanelSMess <> nil) then
  begin
    if assigned(FOnProt) then
      FOnProt(self, ComModus, Data, Len);
  end;
  if SMessProt and (GNavigator <> nil) and
     not (csDestroying in GNavigator.ComponentState) and
     (GNavigator.PanelSMess <> nil) then
  begin
    if OldComModus <> ComModus then
    begin
      OldComModus := ComModus;
      if ComModus = cmRead then
        S1 := ' i:' else
        S1 := ' o:';
    end else
      S1 := '';
    S1 := S1 + String(StrCtrl(StrCgeChar(StrLPas(Data, Len), #0, '~')));
    {S := GNavigator.PanelSMess.Caption;
    if length(S) > 90 then
      S := S1;}
    {for I := 1 to length(S1) do
    begin
      while length(S) * 6 > GNavigator.PanelSMess.Width do
        System.Delete(S, 1, 1);
      S := S + S1[I];
    end;
    SMess('%s',[S]); }
    GNavigator.SMessLocked := true;
    GNavigator.PanelSMess.Caption := GNavigator.PanelSMess.Caption + S1;
    while TDummyControl(GNavigator.PanelSMess).Canvas.TextWidth(
      GNavigator.PanelSMess.Caption) + 4 > GNavigator.PanelSMess.Width do
    begin
      GNavigator.PanelSMess.Caption :=
        copy(GNavigator.PanelSMess.Caption, 2, 254);
      if Sysparam.ComProtDelay > 0 then
        Delay(Sysparam.ComProtDelay) else       {Verzögerung zum 'Mitschauen'}
        GNavigator.PanelSMess.Update;
    end;
  end;
end;


function TCustomPort.GetBusyFlag: boolean;    {true=Comport von anderem Objekt belegt}
begin
  result := ComBusyList.Values[BusyId] = '1';
end;

procedure TCustomPort.SetBusyFlag(Value: boolean);
begin
  ComBusyList.Values[BusyId] := IntToStr(ord(Value));
end;

procedure TCustomPort.Read(Data: PAnsiChar; Len: Word);
begin
  EError('TCustomPort.Read is virtual', [0]);
end;

procedure TCustomPort.Write(Data: PAnsiChar; Len: Word);
begin
  EError('TCustomPort.Write is virtual', [0]);
end;

procedure TCustomPort.Write2Dle(Data: PAnsiChar; Len: Word);
begin
  EError('TCustomPort.Write2Dle is virtual', [0]);
end;

procedure TCustomPort.WriteEcho(Data: PAnsiChar; Len: Word; No2Dle: boolean);
begin
  EError('TCustomPort.WriteEcho is virtual', [0]);
end;

constructor TCustomPort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ErrorStr := '';
  FTimeOut := 1000;
  FVersion := 1.00;
end;

function TCustomPort.InCount: integer;
begin
  Result := 0;
  EError('TCustomPort.InCount is virtual', [0]);
end;

procedure TCustomPort.BuildParams;
begin
  EError('TCustomPort.BuildParams is virtual', [0]);
end;

procedure TCustomPort.SetParams(Value: string);
begin
  EError('TCustomPort.SetParams is virtual', [0]);
end;

function TCustomPort.BusyId: string;
begin
  EError('TCustomPort.BusyId is virtual', [0]);
end;

initialization
  ComPortList := TStringList.Create;
  ComBusyList := TStringList.Create;

finalization
  ComPortList.Free;
  ComBusyList.Free;

end.
