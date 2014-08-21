unit Sche_kmp;
(* Fahrzeugwaage Schenk *)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TScheKmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    procedure TokToGewicht( Tok: PAnsiChar; var Gewicht: double);
    procedure StrToWaStat( Tok: PAnsiChar; var Status: TFaWaStatus);
    procedure StrToSysStat( Tok: PAnsiChar; var Status: TFaWaStatus);
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    function Nullstellen: longint; override;
    function HoleStatus: longint; override;
    function ProtGewicht( Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, Err__Kmp;

(*** Initialisierung *********************************************************)

constructor TScheKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Description.Clear;
  Description.Add('S:^B');
  Description.Add('B:');
  Description.Add('S:^C[BCCSCHENK]');
  Description.Add('W:1');

  Description.Add('W:^B');
  Description.Add('A:255,^C');
  Description.Add('W:1');
  Description.Add('S:^F');

end;

(*** Methoden ***************************************************************)

procedure TScheKmp.Init;
var
  Befehl: array[0..128] of AnsiChar;
  BefLen: integer;
begin
  StrFmt( Befehl, '#EU#%s#%s',
    [FormatDateTime('dd.mm.jj', date), FormatDateTime('hh:nn', time)]);
  BefLen := StrLen( Befehl);
  Start( Befehl, BefLen);

  {Zeilendruck( Format( '%s %s',
    ['Wägeprotokoll ab', FormatDateTime('dd.mm.jj hh:nn:ss', now)]));
  Zeilendruck( 'Datum... Zeit. Num. Fahrzeug.... Wa Tara.... Brutto..');}
end;


(*** Interne Methoden *******************************************************)

procedure TScheKmp.TokToGewicht( Tok: PAnsiChar; var Gewicht: double);
begin
  Gewicht := StrToFloatTol(String(StrPas( Tok)));
end;

procedure TScheKmp.StrToWaStat( Tok: PAnsiChar; var Status: TFaWaStatus);
(* Tok 2stellig, Bits 0-4 zählen *)
begin
  if BITIS( Ord(Tok[0]), $8) then Exclude( Status, fwsKeinStillstand) else
                                  Include( Status, fwsKeinStillstand);
  if BITIS( Ord(Tok[0]), $2) then Include( Status, fwsKeinGewicht);  {Gew.ungültig}
  if BITIS( Ord(Tok[0]), $1) then Include( Status, fwsNull);  {0t}

  if BITIS( Ord(Tok[1]), $8) then Include( Status, fwsNull);  {0t}
  if BITIS( Ord(Tok[1]), $2) then Include( Status, fwsKeinGewicht);  {Overflow}
  if BITIS( Ord(Tok[1]), $1) then Include( Status, fwsKeinGewicht);  {Underflow}
end;

procedure TScheKmp.StrToSysStat( Tok: PAnsiChar; var Status: TFaWaStatus);
(* Tok 1stellig, Bits 0-4 zählen *)
begin
  if BITIS( Ord(Tok[0]), $8) then Include( Status, fwsDruckerstoerung); {ohne Drucker}
  if BITIS( Ord(Tok[0]), $4) then Include( Status, fwsWaagenstoerung);
  if BITIS( Ord(Tok[0]), $1) then Include( Status, fwsDruckerstoerung);

  if not (BITIS( Ord(Tok[0]), $F)) then
    Include( Status, fwsGewichtOK);
  {if [fwsNull,fwsKeinGewicht] * Status <> [] then
    Exclude( Status, fwsGewichtOK);}
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TScheKmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L : integer;
  Tok: PAnsiChar;
  ATel : TTel;
  NextStr: PAnsiChar;
begin
  inherited DoAntwort( Sender, Tel_Id);

  FaWaStatus := [];
  L := sizeof(EmpfBuff) - 1;
  ATel := nil;
  try
    ATel := GetTel( Tel_Id);
    GetData( Tel_Id, EmpfBuff, L);
  finally
    EmpfBuff[L] := #0;
    if Tel_Id = StatusId then
    try
      StatusId := -1;
      //showmessage(String(EmpfBuff));
      ATel := GetTel( Tel_Id);
      if ATel.Status = cpsOK then
      try
        {ersten Token ignorieren}
        StrTok( EmpfBuff, '#', NextStr);
        {Waagenadresse}
        Tok := StrTok( nil, '#', NextStr);
        {TN}
        if StrComp(Tok, 'TN') <> 0 then
          EError('%s:falsch',[Tok]);
        {TG}
        {if StrComp(Tok, 'TG') <> 0 then
          EError('%s:falsch',[Tok]); }
        Tok := StrTok( nil, '#', NextStr);
        {Gewicht}
        Display := String(StrPas(Tok));
        Tok := StrTok( nil, '#', NextStr);
        {Waagenstatus}
        StrToWaStat( Tok, FaWaStatus);
        Gewicht := StrToFloatTol( Display);
        GE := 't';
        {if not (fwsKeinGewicht in FaWaStatus) then}
          Include( FaWaStatus, fwsGewichtOk);   {bei Status so}
      except
        on E:Exception do
        begin
          Display := E.Message;
          Prot0('%s',[E.Message]);
        end;
      end else
        Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
    finally
      if assigned(FOnStatus) then
        FOnStatus( Tel_Id, Gewicht, FaWaStatus);
    end else

    if Tel_Id = ProtGewichtId then
    try
      ProtGewichtId := -1;
      FaWaStatus := [];
      try
      {
      o:^B1#TP#^C6
      i:^F^B1#TP#02.09.06#11:34#8779##01# 00,00t #80#4^CA
      o:^F
        }
        if ATel.Status = cpsOK then
        begin
          {ersten Token ignorieren}
          StrTok( EmpfBuff, '#', NextStr);
          {Waagenadresse}
          Tok := StrTok( nil, '#', NextStr);
          {TP}
          if StrComp(Tok, 'TP') <> 0 then
            EError('%s:falsch',[Tok]);
          StrTok( nil, '#', NextStr);
          {Datum}
          StrTok( nil, '#', NextStr);
          {Zeit}
          Tok := StrTok( nil, '#', NextStr);
          {LfdNr}
          ProtNr := StrToInt(String(StrPas(Tok)));
          Include(FaWaStatus, fwsProtNr);
          StrTok( nil, '#', NextStr);
          {Beizeichen}
          StrTok( nil, '#', NextStr);
          {Waagenkennung}
          Tok := StrTok( nil, '#', NextStr);
          {Gewicht}
          Display := String(StrPas(Tok));
          TokToGewicht( Tok, Gewicht);
          Tok := StrTok( nil, '#', NextStr);
          {Waagenstatus}
          StrToWaStat( Tok, FaWaStatus);
          Tok := StrTok( nil, '#', NextStr);
          {Systemstatus (Drucker)}
          StrToSysStat( Tok, FaWaStatus);
        end else
        begin
          FaWaStatus := [fwsTimeout];
          Gewicht := 0;
        end;
      except
        FaWaStatus := [fwsTimeout];
        Gewicht := 0;
      end;
    finally
      if assigned(FOnProtGewicht) then
        FOnProtGewicht( Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else

    if Tel_Id = NullstellenId then
    try
      NullstellenId := -1;
      FaWaStatus := [fwsTimeout];
      try
        if ATel.Status = cpsOK then
        begin
          StrTok( EmpfBuff, '#', NextStr);
          {Waagenadresse}
          Tok := StrTok( nil, '#', NextStr);
          {AZ}
          if StrComp(Tok, 'AZ') <> 0 then
            EError('%s:falsch',[Tok]);
          Tok := StrTok( nil, '#', NextStr);
          {0=OK /1}
          if Tok[0] = '0' then
            FaWaStatus := [fwsNull] else
            FaWaStatus := [];
        end else
        begin
          FaWaStatus := [fwsTimeout];
          Gewicht := 0;
        end;
      except
        FaWaStatus := [fwsTimeout];
        Gewicht := 0;
      end;
    finally
      if assigned(FOnNullstellen) then
        FOnNullstellen( Tel_Id, FaWaStatus);
    end else
    begin
    end;
  end;
end;

function TScheKmp.Nullstellen: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt( Befehl, '1#AZ#', [0]);
  BefLen := StrLen( Befehl);
  NullstellenId := Start( Befehl, BefLen);
  Result := NullstellenId;
end;

function TScheKmp.ProtGewicht( Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt( Befehl, '1#TP#%s', [Beizeichen]);
  BefLen := StrLen( Befehl);
  ProtGewichtId := Start( Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TScheKmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt( Befehl, '1#TN#', [0]);  //02.09.06
  //StrFmt( Befehl, '1#TN', [0]);     {Weferlingen 'TN' ohne #}
  //StrFmt( Befehl, '1#TG', [0]);     {AKW 'TG' ohne #}
  BefLen := StrLen( Befehl);
  StatusId := Start( Befehl, BefLen);
  Result := StatusId;
end;

end.
