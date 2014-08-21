unit MettlerKmp;
(* Mettler Toledo Continuous Mode
   22.11.11 md  erstellt
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

const
  MaxKontakte = 16;

type
  TMettlerKmp = class(TFaWaKmp)
  private
    FContinuous: boolean;
    { Private-Deklarationen }
    procedure StrToWaStat(Tok: PAnsiChar; var Status: TFaWaStatus);
    procedure SetContinuous(const Value: boolean);
  protected
    { Protected-Deklarationen }
    DescBefehl, DescCont: TStringList;
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Loaded; override;
    function Nullstellen: longint; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
  published
    { Published-Deklarationen }
    property Continuous: boolean read FContinuous write SetContinuous;
  end;

implementation

uses
  Prots, Err__Kmp;

(*** Initialisierung *********************************************************)

constructor TMettlerKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DescBefehl := TStringList.Create;
  DescCont := TStringList.Create;
  FContinuous := True;
end;

procedure TMettlerKmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TMettlerKmp.Destroy;
begin
  FreeAndNil(DescBefehl);
  FreeAndNil(DescCont);
  inherited Destroy;
end;

procedure TMettlerKmp.BuildDescription;
begin
  Description.Clear;
  //if Continuous then
  begin
    //STX ABC123456123456 CR BCC
    //Gewicht ohne Komma (nk=-3 setzen für to)
    Description.Add(';Continuous');
    Description.Add('T:5000');
    Description.Add('A:255,^M');  {  <- Antwort, CR }
    Description.Add('W:1');        {<-BCC}

    DescCont.Assign(Description);

    DescBefehl.Clear;
    DescBefehl.Add('B:');  //nur Befehl senden, keine Antwort 'Z'=Nullstellen
  end;
end;

(*** Methoden ***************************************************************)

procedure TMettlerKmp.Init;
//var
//  Befehl : array[0..128] of AnsiChar;
//  BefLen: integer;
begin
end;


(*** Interne Methoden *******************************************************)

//procedure TMettlerKmp.TokToGewicht(Tok: PAnsiChar; var Gewicht: double);
//begin
//  Gewicht := StrToFloatTol(StrPas(Tok));
//end;

procedure TMettlerKmp.SetContinuous(const Value: boolean);
begin
  FContinuous := Value;
end;

procedure TMettlerKmp.StrToWaStat(Tok: PAnsiChar; var Status: TFaWaStatus);
(* Tok Statuswort B (1 Byte), Bits 0-6 zählen *)
begin
  if BITIS(Ord(Tok[0]), $2) then Include(Status, fwsKeinGewicht);  {Negativ}
  if BITIS(Ord(Tok[0]), $4) then Include(Status, fwsKeinGewicht);  {Überlast/Unterlast}
  if BITIS(Ord(Tok[0]), $8) then Include(Status, fwsKeinStillstand) else
                                 Exclude(Status, fwsKeinStillstand);
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TMettlerKmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L : integer;
  ATel : TTel;
  Offset: integer;
  SWB: PAnsiChar;
  GewStr: AnsiString;
begin
  inherited DoAntwort(Sender, Tel_Id);

  FaWaStatus := [];
  L := sizeof(EmpfBuff) - 1;
  ATel := nil;
  try
    ATel := GetTel(Tel_Id);
    GetData(Tel_Id, EmpfBuff, L);
  finally
    EmpfBuff[L] := #0;

    if Tel_Id = StatusId then
    try
      StatusId := -1;
      FaWaStatus := [];
      if ATel.Status = cpsOK then
      try
        //  0 1   5    0    5
        //<STX>ABC123456123456<CR><BCC>
        //   ^B20  14980     0^M    richtig. L = 16 (ohne CR)
        //   ^B20  10     0^M       falsch
        //Gewicht ohne Komma (nk=-3 setzen für to)
        //vom Ende her rechnen da kontinuierlich gesendet wird. STX = Pos0.
        //letzte 15 Zeichen
        Offset := L - 16;
        if Offset < 0 then
        begin
          Include(FaWaStatus, fwsSpeicherfehler);   //interner Fehler
          Display := Format('Offset=%d', [Offset]);
        end else
        begin
          SWB := EmpfBuff + Offset + 2;
          StrToWaStat(SWB, FaWaStatus);

          GewStr := AnsiString(Trim(String(StrLPas(EmpfBuff + Offset + 4, 6))));
          StrToGewicht(String(GewStr), Gewicht);   {definiert NachK, in FaWa}
          if SameStr(GE, 't') then
            Nachk := IMin(Nachk, 2);
          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
          Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
        end;
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
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    if Tel_Id = ProtGewichtId then
    try
      ProtGewichtId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          Prot0('TMettlerKmp.DoAntwort', [0]);
          ProtA('%s', [EmpfBuff]);

          //siehe Status
          Offset := L - 16;
          if Offset < 0 then
          begin
            Include(FaWaStatus, fwsSpeicherfehler);   //interner Fehler
            EError('Offset=%d', [Offset]);
          end;

          SWB := EmpfBuff + Offset + 2;
          StrToWaStat(SWB, FaWaStatus);

          GewStr := AnsiString(Trim(String(StrLPas(EmpfBuff + Offset + 4, 6))));
          StrToGewicht(String(GewStr), Gewicht);   {definiert NachK, in FaWa}

          Display := Format('<%5.*f %s>', [NachK, Gewicht, GE]);
          Include(FaWaStatus, fwsGewichtOk);   {bei Status so}

          if not (fwsKeinGewicht in FaWaStatus) then
            Include(FaWaStatus, fwsGewichtOk);
        end else
        begin
          FaWaStatus := [fwsTimeout];
          Gewicht := 0;
        end;
      except on E:Exception do begin
          EProt(self, E, 'ProtGewicht', [0]);
          FaWaStatus := [fwsTimeout];
          Gewicht := 0;
        end;
      end;
    finally
      if assigned(FOnProtGewicht) then
        FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else

    if Tel_Id = NullstellenId then
    try
      NullstellenId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          FaWaStatus := [fwsGewichtOk];
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
        FOnNullstellen(Tel_Id, FaWaStatus);
    end else
    begin
    end;
  end;
end;

function TMettlerKmp.Nullstellen: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Description.Assign(DescBefehl);
  StrFmt(Befehl, 'Z', [0]);
  BefLen := StrLen(Befehl);
  NullstellenId := Start(Befehl, BefLen);
  Result := NullstellenId;
end;

function TMettlerKmp.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin  //identisch mit Status
  Description.Assign(DescCont);  //Continuous: kein Befehl
  StrFmt(Befehl, 'egal', []);
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TMettlerKmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Description.Assign(DescCont);  //Continuous: kein Befehl
  StrFmt(Befehl, 'egal', []);
  BefLen := StrLen(Befehl);
  StatusId := Start(Befehl, BefLen);
  Result := StatusId;
end;

end.
