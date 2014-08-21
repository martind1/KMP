unit SpsProt;
(* S5 über 3264R Prozedur *)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  CPro_kmp;

type
  TDW = record              {type of DW}
          case integer of
            0: (L, H: byte);
            1: (CL, CH: AnsiChar);
            2: (W: word);
            3: (I: integer);                    {Hi und Lo Byte sind vertauscht}
          end;
  TSpsSimulEvent = procedure (Sender: TObject; DB, DW: integer; var Data: TDW) of object;
  TSpsDataChangeEvent = procedure (Sender: TObject; DB, DW: integer; Data: TDW;
                                   Kennung: AnsiChar) of object;

type
  TSpsProt = class(TComProt)
  private
    { Private-Deklarationen }
    FOnSpsSimul: TSpsSimulEvent;
    FOnSpsDataChange: TSpsDataChangeEvent;
    FListBox: TListBox;
    procedure XProt(DB, DW: word; ADW: TDW; Kenn: string);
  protected
    { Protected-Deklarationen }
    WdhlgId: longint;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    function GetSimul: boolean; override;
    procedure DoSimul( ATel: TTel); override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ADWait( DB, DW, AnzDW, Koord: word; Data: array of TDW;
      Wait: boolean): longint; (* Ausgeben mit Wartefunktion (Wait=true) *)
    function AD( DB, DW, AnzDW, Koord: word; Data: array of TDW): longint;
    function ED( DB, DW, AnzDW, Koord: word): longint;  {Daten in SpsDataChange abholen}
  published
    { Published-Deklarationen }
    property ListBox: TListBox read FListBox write FListBox;
    property OnSpsSimul: TSpsSimulEvent read FOnSpsSimul write FOnSpsSimul;
    property OnSpsDataChange: TSpsDataChangeEvent read FOnSpsDataChange write FOnSpsDataChange;
  end;

  function DWInt( ADW: TDW): word;                       {vertauscht Hi und Lo}

implementation
uses
  Prots, Err__Kmp, CPor_Kmp;

(*** Hilfsfunktionen ********************************************************)

function DWInt( ADW: TDW): word;
{vertauscht Hi und Lo}
begin
  result := (word(ADW.H) shl 8) + ADW.L;
end;

procedure TSpsProt.XProt(DB, DW: word; ADW: TDW; Kenn: string);
var
  S: string;
begin
  if (ListBox <> nil) and not ListBox.Focused then
  begin
    S := Format('%4d.%-4d', [DB, DW]);
    ListBox.Items.Values[S] := Format('%0.2X %0.2X %s %s',
      [ADW.H, ADW.L, Kenn, DateTimeToStr(now)]);
  end;
end;

(*** Methoden ***************************************************************)

constructor TSpsProt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  No2Dle := true;                        {machen wir selbst}
  Description.Clear;
  Description.Add('T:5000');
  Description.Add('I:');      //ClearInput 30.04.06
  Description.Add('S:^B');
  Description.Add('W:^P');
  Description.Add('C:');                   {Bcc auf 0}
  {machen wir selbst i.V.m. No2DLE um keine Zeichenverzugszeit zu erhalten
  Description.Add('S:^@^@[SPS_BEF]D[SPS_DB][SPS_DW][SPS_ANZ2][SPS_KOORD]');
  Description.Add('B:');
  Description.Add('S:^P^C[BCC]');}
  Description.Add('B:');
  Description.Add('W:^P');
  Description.Add('W:^B');
  Description.Add('S:^P');
  Description.Add('A:128,^P,^C');   {0, 0, Err.H, Err.L, DW1.H, DW1.L, DW2.H,..}
  Description.Add('W:1');           {BCC}
  Description.Add('S:^P');
end;

destructor TSpsProt.Destroy;
begin
  inherited Destroy;
end;

procedure TSpsProt.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = ListBox) then
    ListBox := nil;
  inherited Notification( AComponent, Operation);
end;

function TSpsProt.AD( DB, DW, AnzDW, Koord: word; Data: array of TDW): longint;
(* Ausgeben Daten *)
begin
  result := ADWait( DB, DW, AnzDW, Koord, Data, false);
end;

function TSpsProt.ADWait( DB, DW, AnzDW, Koord: word; Data: array of TDW;
  Wait: boolean): longint;
(* Ausgeben mit Wartefunktion (Wait=true) *)
var
  Befehl : array[0..255] of AnsiChar;
  I, L: integer;
  Bcc: Byte;
  procedure AppendL( C: AnsiChar);
  begin
    Befehl[L] := C;
    Inc(L);
    if C = AnsiChar(DLE) then
    begin                                      {DLE verdoppeln}
      Befehl[L] := C;
      Inc(L);
    end;
  end;
begin
  L := 0;
  AppendL(#0);
  AppendL(#0);
  AppendL('A');
  AppendL('D');
  AppendL(AnsiChar(Lo(DB)));                        {L=4}
  AppendL(AnsiChar(Lo(DW)));                       {L=5}
  AppendL(AnsiChar(Hi(AnzDW)));                    {L=6}
  AppendL(AnsiChar(Lo(AnzDW)));
  AppendL(AnsiChar(Hi(Koord)));                    {L=8}
  AppendL(AnsiChar(Lo(Koord)));
  for I := 0 to AnzDW - 1 do                   {L= ab 10}
  begin
    AppendL(Data[I].CH);
    AppendL(Data[I].CL);
    XProt(DB, DW + I, Data[I], 'A');
    if assigned(FOnSpsDataChange) then
      FOnSpsDataChange(self, DB, DW + I, Data[I], 'A');
  end;
  Befehl[L] := AnsiChar(DLE); Inc(L);              {'^P'}
  Befehl[L] := AnsiChar(ETX); Inc(L);              {'^C'}
  Bcc := 0;
  for I := 0 to L - 1 do
    Bcc := Bcc xor ord(Befehl[I]);
  Befehl[L] := AnsiChar(Bcc); Inc(L);
  if Wait then
  begin
    WaitStart(Befehl, L, nil, I);
    result := -1;
  end else
    result := Start(Befehl, L);
end;

function TSpsProt.ED( DB, DW, AnzDW, Koord: word): longint;
(* Einlesen Daten Start *)
var
  Befehl : array[0..255] of AnsiChar;
  I, L: integer;
  Bcc: Byte;
  procedure AppendL( C: AnsiChar);
  begin
    Befehl[L] := C;
    Inc(L);
    if C = AnsiChar(DLE) then
    begin                               {DLE verdoppeln}
      Befehl[L] := C;
      Inc(L);
    end;
  end;
begin
  L := 0;
  AppendL(#0);
  AppendL(#0);
  AppendL('E');
  AppendL('D');
  {AppendL(AnsiChar(Hi(DB)));}
  AppendL(AnsiChar(Lo(DB)));
  {AppendL(AnsiChar(Hi(DW)));}
  AppendL(AnsiChar(Lo(DW)));
  AppendL(AnsiChar(Hi(AnzDW)));
  AppendL(AnsiChar(Lo(AnzDW)));
  AppendL(AnsiChar(Hi(Koord)));
  AppendL(AnsiChar(Lo(Koord)));
  Befehl[L] := AnsiChar(DLE); Inc(L);              {'^P'}
  Befehl[L] := AnsiChar(ETX); Inc(L);              {'^C'}
  Bcc := 0;
  for I := 0 to L - 1 do
    Bcc := Bcc xor ord(Befehl[I]);
  Befehl[L] := AnsiChar(Bcc); Inc(L);
  {result := Start(Befehl, L);}
  result := StartFlags(Befehl, L, [cpfPoll, cpfCache], '', 0);
end;

procedure TSpsProt.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  I, J, L: integer;
  EmpfBuff: array[0..512] of AnsiChar;
  ATel : TTel;
  ADW: TDW;
  DB_Nr, DW_Nr: word;
begin
  L := sizeof(EmpfBuff) - 1;
  ATel := GetTel( Tel_Id);
  if Tel_Id = WdhlgId then
    Prot0('Wdhlg:%d', [ord(ATel.Status)]);
  if GetData( Tel_Id, EmpfBuff, L) = cpsOK then
  try
    EmpfBuff[L] := #0;
    ADW.CH := #0;
    ADW.CL := ATel.OutData[4];
    DB_Nr := DWInt(ADW);
    ADW.CH := #0;
    ADW.CL := ATel.OutData[5];
    DW_Nr := DWInt(ADW);
    ADW.CH := EmpfBuff[2];
    ADW.CL := EmpfBuff[3];
    if ADW.W <> 0 then                       {Error Nummer}
    begin
      if assigned(FOnSpsDataChange) then
        FOnSpsDataChange(self, DB_Nr, DW_Nr, ADW, 'F');
      XProt(DB_Nr, DW_Nr, ADW, 'F');
    end else
    if ATel.OutData[2] = 'E' then            {nur Empfangsdaten}
    begin
      J := 0;
      for I := 4 to L - 1 do
        if Odd(I) then                       {5,7,9,..}
        begin
          ADW.CH := EmpfBuff[I - 1];
          ADW.CL := EmpfBuff[I];
          if assigned(FOnSpsDataChange) then
            FOnSpsDataChange(self, DB_Nr, DW_Nr + J, ADW, 'E');
          XProt(DB_Nr, DW_Nr + J, ADW, 'E');
          Inc(J);
        end;
    end;
  except on E:Exception do
    EProt(self, E, 'DoAntwort(%d)', [Tel_Id]);
  end else
  if ATel.OutData[2] = 'A' then            {nur Sendedaten 020299}
  try        {Fehler (^U empfangen)   wiederholen}
    if cpfWdhlg in ATel.Flags then
    begin
      {WdhlgId := StartOnTop(ATel.OutData, ATel.OutDataLen); {An Spitze stellen}
      WdhlgId := StartFlags(ATel.OutData, ATel.OutDataLen,
        [cpfPoll, cpfOnTop, cpfWdhlg], '', 0);
      Prot0('SPS-Antwort Wdhlg(%s)', [StrCtrl(StrLPas(ATel.OutData, ATel.OutDataLen))]);
    end else
      Prot0('SPS-Antwort Fail%d(%s)', [TelCount,
        StrCtrl(StrLPas(ATel.OutData, ATel.OutDataLen))]);
  except on E:Exception do
    EProt(self, E, 'SpsFehler(%d)', [Tel_Id]);
  end else
    Prot0('Fehler beim Lesen von SPS (%s)', [StrCtrl(StrLPas(ATel.OutData, ATel.OutDataLen))]);
  inherited DoAntwort( Sender, Tel_Id);   {erst hier sind alle DataChanges verarbeitet}
end;

function TSpsProt.GetSimul: boolean;
begin
  result := inherited GetSimul or Assigned(FOnSpsSimul);
end;

procedure TSpsProt.DoSimul( ATel: TTel);
var
  I, J, DB, DW, AnzDW: word;
  ADW: TDW;
begin
  if Assigned(FOnSpsSimul) then
  begin
    ATel.InData[0] := #0;                   {Kennung immer 00}
    ATel.InData[1] := #0;
    ATel.InData[2] := #0;                   {Fehlercode}
    ATel.InData[3] := #0;
    ATel.InDataLen := 4;                     {auch für AD}
    if ATel.OutData[2] = 'E' then            {nur Empfangsdaten}
    begin
      DB := ord(ATel.OutData[4]);
      DW := ord(ATel.OutData[5]);
      ADW.CH := ATel.OutData[6];
      ADW.CL := ATel.OutData[7];
      AnzDW := DWInt(ADW);
      J := 4;
      for I := 0 to AnzDW - 1 do
      begin
        ADW.I := 0;                          {Standardwert}
        FOnSpsSimul(self, DB, DW + I, ADW);
        ATel.InData[J] := ADW.CH; Inc(J);
        ATel.InData[J] := ADW.CL; Inc(J);
      end;
      ATel.InDataLen := J;
    end;
  end;
  inherited DoSimul(ATel);
end;

end.
