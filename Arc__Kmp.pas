unit Arc__Kmp;  
(* erstellt MD
   10.01.00 MD KurzePakete
*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HW_32;

type
  TDwNr = 0..256;                      {Bereich der Nummern der Datenworte}
  TArcMem = array[0..2047] of Byte;    {Speicherbereich der ArcNet Karte}
  PArcMem = ^TArcMem;                  {[0000..1023] = Sendbereich (PC-->SPS)  }
                                       {[1024..2047]  = Empfbereich (PC<--SPS) }
  TBit16 = 0..15;
  TDBData = array[1..256] of word;
type

  (*** Class TArcNet **********************************************************)

  TArcNet = class(TComponent)
  private
    { Private-Deklarationen }
    FHw32: TVicHw32;
    fBaseAddr: longint;
    fIoBase: integer;
    fEmpfOffs: longint;
    ArcMem: PArcMem;
    ArcId: integer;                    {eigene Knotennummer}
    SpsId: integer;                    {SPS Knotennummer}
    fActive, fStreamedActive: boolean;
    fSimul: boolean;
    function GetActive: boolean;
    procedure SetActive(Value: boolean);
    function GetSimul: boolean;
    procedure SetSimul(Value: boolean);
    function GetBaseAddr: string;
    procedure SetBaseAddr(Value: string);
    function GetIoBase: string;
    procedure SetIoBase(Value: string);
    function GetEmpfOffs: string;
    procedure SetEmpfOffs(Value: string);
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    IsCom9066: boolean;                {Identifizierung des 16bit Chips}
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure ArcOpen;
    procedure ArcClose;
    function Empf(Adresse: Pointer; var Size: word): boolean;
    function Send(Adresse: Pointer; Count: word): boolean;
  published
    { Published-Deklarationen }
    property Hw32: TVicHw32 read FHw32 write FHw32;
    property Active: boolean read GetActive write SetActive;
    property Simul: boolean read GetSimul write SetSimul;
    property BaseAddr: string read GetBaseAddr write SetBaseAddr;
    property IoBase: string read GetIoBase write SetIoBase;
    property EmpfOffs: string read GetEmpfOffs write SetEmpfOffs;
  end; (* TArcNet *)

  (*** Class TSpsArc **********************************************************)

  TSpsArc = class(TComponent)
  private
    { Private-Deklarationen }
    fArcNet: TArcNet;
    fSendDB: word;
    fEmpfDB: word;
    fSendDBData: TDBData;
    fEmpfDBData: TDBData;
    fPaketLen: integer;
    function GetEmpfDW(ADw: byte): word;
    procedure SetEmpfDW(ADw: byte; Value: word);
    function GetEmpfDWBit(ADw: byte; ABit: TBit16): boolean;
    procedure SetEmpfDWBit(ADw: byte; ABit: TBit16; Value: boolean);
    function GetSendDW(ADw: byte): word;
    procedure SetSendDW(ADw: byte; Value: word);
    function GetSendDWBit(ADw: byte; ABit: TBit16): boolean;
    procedure SetSendDWBit(ADw: byte; ABit: TBit16; Value: boolean);
    function GetSimul: boolean;
  protected
    { Protected-Deklarationen }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner:TComponent); override;
    function ReadFromSps: boolean;
    function WriteToSps: boolean;
    property EmpfDW[Dw: byte]: word read GetEmpfDW write SetEmpfDW;
    property EmpfDWBit[Dw: byte; Bit: TBit16]: boolean read GetEmpfDWBit write SetEmpfDWBit;
    property SendDW[Dw: byte]: word read GetSendDW write SetSendDW;
    property SendDWBit[Dw: byte; Bit: TBit16]: boolean read GetSendDWBit write SetSendDWBit;
    property Simul: boolean read GetSimul;
  published
    { Published-Deklarationen }
    property ArcNet: TArcNet read FArcNet write FArcNet;
    property SendDB: word read fSendDB write fSendDB;
    property EmpfDB: word read fEmpfDB write fEmpfDB;
    property PaketLen: integer read fPaketLen write fPaketLen;
  end; (* TSpsArc *)

implementation

uses
  Prots, Err__Kmp;

(*** Class TSpsArc **********************************************************)

constructor TSpsArc.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  fPaketLen := 508;           {Lange Pakete, Kurze: 64 o.ä.}
end;

procedure TSpsArc.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = ArcNet) then
    ArcNet := nil;
  inherited Notification(AComponent, Operation);
end;

function TSpsArc.GetSimul: boolean;
begin
  result := (fArcNet = nil) or fArcNet.Simul;
end;

function TSpsArc.GetEmpfDW(ADw: byte): word;
begin
  result := 0;
  try
    result := (Lo(fEmpfDbData[ADw]) shl 8) or Hi(fEmpfDbData[ADw]);{Bytes umkehren}
  except on E:Exception do
    EProt(self, E, 'GetEmpfDw(%d)', [ADw]);
  end;
end;

procedure TSpsArc.SetEmpfDW(ADw: byte; Value: word);
begin
  try
    fEmpfDbData[ADw] := (Lo(Value) shl 8) or Hi(Value);           {Bytes umkehren}
  except on E:Exception do
    EProt(self, E, 'SetEmpfDW(%d,%d)', [ADw, Value]);
  end;
end;

function TSpsArc.GetEmpfDWBit(ADw: byte; ABit: TBit16): boolean;
begin
  result := ISBITSET(GetEmpfDW(ADw), ABit);
end;

procedure TSpsArc.SetEmpfDWBit(ADw: byte; ABit: TBit16; Value: boolean);
var
  DwValue: integer;
begin
  try
    DwValue := (Lo(fEmpfDbData[ADw]) shl 8) or Hi(fEmpfDbData[ADw]);{Bytes umkehren}
    if Value then
      BITSET(DWValue, ABit) else
      BITCLEAR(DWValue, ABit);
    SetEmpfDW(ADw, DwValue);                                      {Bytes umkehren}
  except on E:Exception do
    EProt(self, E, 'SetEmpfDWBit(%d,%d,%d)', [ADw, ABit, Value]);
  end;
end;

function TSpsArc.GetSendDW(ADw: byte): word;
begin
  result := 0;
  try
    result := (Lo(fSendDbData[ADw]) shl 8) or Hi(fSendDbData[ADw]);{Bytes umkehren}
  except on E:Exception do
    EProt(self, E, 'GetSendDw(%d)', [ADw]);
  end;
end;

procedure TSpsArc.SetSendDW(ADw: byte; Value: word);
begin
  try
    fSendDbData[ADw] := (Lo(Value) shl 8) or Hi(Value);           {Bytes umkehren}
  except on E:Exception do
    EProt(self, E, 'SetSendDW(%d,%d)', [ADw, Value]);
  end;
end;

function TSpsArc.GetSendDWBit(ADw: byte; ABit: TBit16): boolean;
begin
  result := ISBITSET(GetSendDW(ADw), ABit);
end;

procedure TSpsArc.SetSendDWBit(ADw: byte; ABit: TBit16; Value: boolean);
var
  DwValue: integer;
begin
  try
    DwValue := (Lo(fSendDbData[ADw]) shl 8) or Hi(fSendDbData[ADw]);{Bytes umkehren}
    if Value then
      BITSET(DWValue, ABit) else
      BITCLEAR(DWValue, ABit);
    SetSendDW(ADw, DwValue);                                      {Bytes umkehren}
  except on E:Exception do
    EProt(self, E, 'SetSendDWBit(%d,%d,%d)', [ADw, ABit, Value]);
  end;
end;

function TSpsArc.ReadFromSps: boolean;
var
  N: word;
begin
  result := false;
  N := sizeof(fEmpfDBData);
  if fArcNet <> nil then
    result := fArcNet.Empf(Addr(fEmpfDBData), N);
end;

function TSpsArc.WriteToSps: boolean;
var
  N: integer;
begin
  result := false;
  N := fPaketLen;         {508;}
  if fArcNet <> nil then
    result := fArcNet.Send(Addr(fSendDBData), N);
end;


(*** Class TArcNet **********************************************************)

constructor TArcNet.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  fBaseAddr := $D0000;                {physicalische Adresse der Arcnet Karte}
  fIoBase := $2E0;                {IO-Adresse zum Steuern der Arcnet Karte}
  fEmpfOffs := $0400;           {Start der Empfangsdaten im Arcnet Speicher}
end;

destructor  TArcNet.Destroy;
begin
  inherited Destroy;
end;

procedure TArcNet.Loaded;
begin
  if fStreamedActive then
    ArcOpen;
end;

procedure TArcNet.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = Hw32) then
    Hw32 := nil;
  inherited Notification(AComponent, Operation);
end;

function TArcNet.GetSimul: boolean;
begin
  result := fSimul;
end;

function TArcNet.GetBaseAddr: string;
begin
  result := Format('$%4.4X', [fBaseAddr]);
end;

procedure TArcNet.SetBaseAddr(Value: string);
begin
  fBaseAddr := StrToInt(Value);
end;

function TArcNet.GetIoBase: string;
begin
  result := Format('$%4.4X', [fIoBase]);
end;

procedure TArcNet.SetIoBase(Value: string);
begin
  fIoBase := StrToInt(Value);
end;

function TArcNet.GetEmpfOffs: string;
begin
  result := Format('$%4.4X', [fEmpfOffs]);
end;

procedure TArcNet.SetEmpfOffs(Value: string);
begin
  fEmpfOffs := StrToInt(Value);
end;

procedure TArcNet.SetSimul(Value: boolean);
begin
  fSimul := Value;
end;

function TArcNet.GetActive: boolean;
begin
  result := fActive;
end;

procedure TArcNet.SetActive(Value: boolean);
var
  //B1: byte;
  I: integer;
begin
  if Simul then
  begin
    fActive := Value;
    Prot0('%s:Simulation', [Name]);
  end else
  if csReading in ComponentState then
  begin
    fStreamedActive := Active;                     {vergl. TuDataBase.StreamedConnected}
  end else
  if Hw32 = nil then
  begin
    if not (csDesigning in ComponentState) then
      EError('%s.SetActive: Hw32 fehlt', [Name]);
  end else
  with Hw32 do
  begin
    if Value and not Active then
    try
      OpenDriver;
      if ActiveHW then
      begin
        ArcMem := MapPhysToLinear (fBaseAddr, sizeof(TArcMem));
        for i := Low(TArcMem) to High(TArcMem) do
          ArcMem^[i] := 0;                             {Speicher initialisieren}
        SpsId := 1;
        port [fIoBase + $2] := $1A;                  {Prüfe ARCNET-Chip-Typ}
        IsCom9066 := Port[fIoBase + $2] = $1A;
        Prot0('Com9066:%s', [BoolToStr(IsCom9066)]);

        //B1 := port[fIoBase + $8];           {Reset: benötigt laut Angabe 150 µs}
        delay(100);                           {0.1 Sek. warten}

        port[fIoBase + $1] := $1E;          {Reset-Flags}
        port[fIoBase + $2] := $1C;          {Je nach Typ}
        ArcID := port[fIoBase + $5];        {eigene Knotennummer}
                                              {kurze und lange Pakete}
        port[fIoBase + $1] := $D;           {Define Configuration:}
        port[fIoBase + $0] := $0;           {Interruptmaske}
        port[fIoBase + $1] := $94;          {enable receive to page 2}
      end else
        raise Exception.Create('ERROR: Kernelmode Treiber kann nicht geöffnet werden');
    except on E:Exception do
      EMess(self, E, 'Fehler beim Initialisieren', [0]);
    end else
    if not Value and Active then
    try
      CloseDriver;
    except on E:Exception do
      EMess(self, E, 'Fehler beim Schließen', [0]);
    end;
    fActive := ActiveHW;
  end;
end;

procedure TArcNet.ArcOpen;
begin
  Active := true;
end;

procedure TArcNet.ArcClose;
begin
  Active := false;
end;

function TArcNet.Empf(Adresse: Pointer; var Size: word): boolean;
var
  B1: byte;
  Count: word;
  RecId: integer;
const
  LastResult: boolean = true;
begin
  result := false;
  RecID := 0;
  if not Simul and (Hw32 <> nil) then with Hw32 do
  begin
    B1 := port[fIoBase + $0];        {Statusbyte holen}
    if BitIs(B1, $80) then             {Bit 'Receiver inhibited' ist gesetzt}
    begin                              {'Empfänger gehemmt'->Daten wurden empfangen}
      SpsID := ArcMem^[fEmpfOffs + 0];                   // Sender ID
      //RecID := ArcMem^[fEmpfOffs + 1];                   // Receiver ID
      if ArcMem^[fEmpfOffs + 2] = 0 then      // langes Paket
      begin
        Count := ArcMem^[fEmpfOffs + 3];                   // Anzahl Bytes
        if (Size >= (512 - Count)) then
        begin                                     // rechtsbündig kopieren
          move(ArcMem^[fEmpfOffs + Count], Adresse^, (512 - Count));
          result := true;
        end;
        Size := 512 - Count;
      end else
      begin                                   // kurzes Paket
        Count := ArcMem^[fEmpfOffs + 2];                   // Anzahl Bytes
        if (Size >= (256 - Count)) then
        begin                                     // rechtsbündig kopieren
          move(ArcMem^[fEmpfOffs + Count], Adresse^, (256 - Count));
          result := true;
        end;
        Size := 256 - Count;
      end;
      port[fIoBase + $1] := $94;              // für erneuten Empfang freigeben
    end else
    if LastResult then
      ProtL('Arcnet.Empf(%d:%d<-%d):Fehler(Receiver inhibited=0)', [ArcId, RecId, SpsId]);
      (*ProtL('Arcnet.Send(%d->%d):Fehler(Receiver inhibited=0)', [ArcId, SpsId]);*)
  end;
  LastResult := result;
end;

function TArcNet.Send(Adresse: Pointer; Count: word): boolean;
var
  B1: byte;
  AdrPtr: PChar;
  I: integer;
const
  LastResult: boolean = true;
begin
  result := false;
  if not Simul and (Hw32 <> nil) then with Hw32 do
  begin
    B1 := port[fIoBase + $0];        {Statusbyte holen}
    if BitIs(B1, $01) then             {Bit 'Transmitter available' ist gesetzt}
    begin
      result := true;
      {SMess('Arcnet.Send(%d->%d):OK', [ArcId, SpsId]);  0->1}
      ArcMem^[0] := ArcId;             // Eigene Knotennummer
      ArcMem^[1] := SpsId;             // Empfängernummer
      if (Count > 253) and (Count < 257) then    // weder kurz noch lang -> lang
      begin
        ArcMem^[2] := 0;
        ArcMem^[3] := $FF;               // Anzahl Bytes
        move(Adresse^, ArcMem^[256-Count], Count);
        AdrPtr := Adresse;
        for i := Count to 256 do AdrPtr[255+i] := #0;
      end else
      if (Count > 256) and (Count < 509) then       // lange Pakete
      begin
        ArcMem^[2] := 0;
        ArcMem^[3] := 512 - Count;       // Anzahl Bytes  (Count muß 508 sein)
        move(Adresse^, ArcMem^[512-Count], Count);
      end else
      if (Count > 0) and (Count < 254) then      // kurze Pakete, z.B. 64
      begin
        ArcMem^[2] := 256-Count;         // Anzahl Bytes  (Count muß 253 sein)
        move(Adresse^, ArcMem^[256-Count], Count);
      end else                           //
      if LastResult then
      begin
        ProtL('Arcnet.Send:Falscher Wert für Count (%d)', [Count]);
        result := false;
      end;
      port[fIoBase + $1] := $03;     // enable transmit from page 0
    end else
    if LastResult then
      ProtL('Arcnet.Send(%d->%d):Fehler(Transmitter available=0)', [ArcId, SpsId]);
  end {else
    SMess('Arcnet.Send(%d->%d):Simul', [ArcId, SpsId])};
  LastResult := result;
end;

end.
