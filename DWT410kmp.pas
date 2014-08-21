unit DWT410kmp;
(* Fahrzeugwaage Pfister DWT410 Version SQ (Standard)
   Status mit Remote Protokoll
   Registrierung in MPP Betriebsart (Standard)
   17.12.06 MD  erstellt
   11.10.08 MD  Verwendung als DWT800 Winsock iVm WSPortKmp: SendACK=false
                SQVA (RS232): SendACK=true
   24.03.09 MD  Variante ohne Terminalnummer MPP automatisch erkennen (SQVA Ausfahrt)
   19.05.11 MD  CKW Variante mit mehreren Brücken (MPA/MPB/MPC, XBA/XBB/XBC)
                  ACK bei MP. Sonst nicht
   08.06.11 md  CKW NoShortACK
   04.08.14 md  TODO: AZ:Nullstellen;  XS:Status (Nullstellbereich,Stillst) alle 30s
-------------------------------------
todo: GE automatisch erkennen -> BuildDescription
*)
interface

uses
  Math,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TDwt410Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    ShortDescr: TStringList;
    //ShortDescrOhneACK: TStringList;
    fSendACK: boolean;
    fNoShortACK: boolean;
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    SendLF: boolean;   //CKW Brücke = true
    Bef : string;
    Netto : string;
    ProtStr: string;  //MPP Kennung falls nicht numerisch
    Antwort: PAnsiChar;
    AntwLen: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure UserFnk(ATel: TTel; FnkName : string); override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
    function Zeilendruck(Zeile: string): longint; override;
    function SwitchMessNr(AMessNr: integer): longint; override;

    function StartShort(const Fmt: string; const Args: array of const): longint;  //Start mit ShortDesc
  published
    { Published-Deklarationen }
    property SendACK: boolean read fSendACK write fSendACK;
    property NoShortACK: boolean read fNoShortACK write fNoShortACK;
  end;

implementation

uses
  Prots, Err__Kmp, CPor_Kmp;
(*** Initialisierung *********************************************************)

constructor TDwt410Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
  ShortDescr := TStringList.Create;
  //ShortDescrOhneACK := TStringList.Create;
end;

procedure TDwt410Kmp.BuildDescription;
begin
  inherited BuildDescription;
  //MPP:
//  Description.Clear;
//  Description.Add('B:');     //MP
//  Description.Add('S:^M');   //CR
//  Description.Add('A:22');
//  Description.Add('S:^F');   //ACK

//  if OkMode then
//  begin
//    //MP-> OK^M^J$MP0000008  1880kg0C^M^J
//    Description.Clear;
//    Description.Add('I:');
//    Description.Add('B:');     //MP
//    Description.Add('S:^M');   //CR
//    Description.Add('W:20,M,P');  //$MP
//    if GE = 't' then
//      Description.Add('A:64,t') else
//      Description.Add('A:64,k,g');
//    //if BCC 13.05.10
//    Description.Add('W:2');    //BCC
//    if SendACK then
//      Description.Add('S:^F');   //ACK  nicht bei Winsock
//  end else
  begin
    //MPP kg:
    Description.Clear;
    Description.Add('I:');
    Description.Add('B:');     //MP
    Description.Add('S:^M^J');  //CKW: immer
    Description.Add('W:20,M,P');  //OK^M^J$MP

    if GE = 't' then
      Description.Add('A:64,t') else
      Description.Add('A:64,k,g');
    //if BCC 13.05.10
    Description.Add('W:4:2');    //BCC und evtl CRLF

    if SendACK then
      Description.Add('S:^F');   //ACK  nicht bei Winsock. Doch:in CKW
  end;
  //Status:
  ShortDescr.Clear;
  ShortDescr.Add('I:');
  ShortDescr.Add('B:');
  if SendLF then
   ShortDescr.Add('S:^M^J') else
   ShortDescr.Add('S:^M');   //nur CR: CKW iVm BinaryMode
  //vor 08.06.11 CKW - ShortDescr.Add('A:255,^M,^J');
  ShortDescr.Add('A:255,^M');
  ShortDescr.Add('I:');
  if SendACK and not NoShortACK then
    ShortDescr.Add('S:^F');   //ACK  nicht bei Winsock. Nicht in CKW

//  08.06.11 CKW weg
//  ShortDescrOhneACK.Clear;
//  ShortDescrOhneACK.Add('I:');
//  ShortDescrOhneACK.Add('B:');
//  ShortDescrOhneACK.Add('S:^M');   //CR
//  ShortDescrOhneACK.Add('A:255,^M,^J');

end;

procedure TDwt410Kmp.Loaded;
begin
  inherited Loaded;
end;

destructor TDwt410Kmp.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  ShortDescr.Free;
  //ShortDescrOhneACK.Free;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TDwt410Kmp.Init;
begin
  inherited Init;
end;


(*** Interne Methoden *******************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

procedure TDwt410Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L: integer;
  ATel : TTel;
  S1, S2, S3, NextS: string;
  P: integer;
  BInd: integer; //md190511
begin
  inherited DoAntwort(Sender, Tel_Id);

  FaWaStatus := [];
  ATel := nil;
  L := sizeof(EmpfBuff) - 1;
  try
    ATel := GetTel(Tel_Id);
    GetData(Tel_Id, EmpfBuff, L);
  finally
    EmpfBuff[L] := #0;

    if Tel_Id = StatusId then            {XB -> 12,34 t bzw. '   12 kg'}
    try                                  //    44,75  t B
      StatusId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      ProtNr := 0;
      try
        if ATel.Status = cpsOK then
        begin
          S1 := String(PStrTok(String(StrLPas(EmpfBuff+0, L)), ' ', NextS));
          S2 := PStrTok('', ' ', NextS);
          S3 := PStrTok('', ' ', NextS);
          {Hier OK da ShortDesc unabh. von GE:}
          if S2 = '' then
          begin
            Display := S1;  // XBB -> OK
          end else
          begin
            GE := S2;   //t, kg, lb
            Netto := S1;
            P := Pos(',', Netto);
            if P > 0 then
            begin
              Nk := P - length(Netto);  //12,34 -> -2
              Netto := StrCgeChar(Netto, ',', #0);
            end;
            StrToGewicht(Netto, Gewicht);   // bzgl.Nk, setzt NachK
            Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
            Include(FaWaStatus, fwsGewichtOk);
          end;
        end else
        begin
          Include(FaWaStatus, fwsTimeout);
          Gewicht := 0;
          Display := FaWaStatusStr(FaWaStatus);
        end;
      except on E:Exception do
        begin
          Include(FaWaStatus, fwsTimeout);
          Display := E.Message;
          Prot0('%s(%.*s)',[E.Message, ATel.OutDataLen, ATel.OutData]);
          Gewicht := 0;
        end;
      end;
    finally
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    if (Tel_Id = ProtGewichtId) then      (* Gewicht holen und Eichfähig speichern *)
    try
      //Variante mit WNr: 0010032100   13820kg
      //        ohne WNr: 0033383   39820kg
      //Haltern           $MP
      //                  0000020    1.50t45        !Punkt als Dezimaltrenner
      //                  01234567890123456789012
      //                            1         2
      //Gambach           0010032187   40040kg2B      $MP wird in Descr weggeschnitten
      //Caminau Brücke    $MP
      //                  A+B+C0001179    5.55 t08
      //Caminau FrzgWg    OK^M^J$MP  (ohne Bruecke)
      //                  0010393       0kg

      ProtGewichtId := -1;               //ist 0 1480  0,0t
      FaWaStatus := [];                  //gew ab 18,8. bis Ende  prot ab 11,7
      Gewicht := 0;                      //ab $MP: 001pppppppgggggggg
      ProtNr := 0;                       // 1   5    0    5    0    5
      try                                // 0    5    0    5    0    5
        if ATel.Status = cpsOK then      // $MPNO STAB-1234,56kgBC
        begin
          Bef := String(StrLPas(EmpfBuff+0, 7));  //17.08.10 war 3
          include(FaWaStatus, fwsWaagenstoerung);
          if Bef = 'NO STAB' then EError('%s:instabiles Gewicht',[Bef]);
          if Bef = 'NO VAL ' then EError('%s:unzulässiges Gewicht',[Bef]);
          if Bef = 'ERRMEM ' then EError('%s:Speicherfehler',[Bef]);
          exclude(FaWaStatus, fwsWaagenstoerung);
          BInd := 0;
          while EmpfBuff[BInd] in ['A','B','C','+'] do  //A+B+C
            BInd := BInd +1;
          //warum funktioniert das nicht if EmpfBuff[BInd + 7] = ' ' then
          if IsNum(EmpfBuff[BInd + 7]) then        //mit WNr bzw. mit MP$
          begin                                    //0010032100   13820kg
            ProtStr := String(StrLPas(EmpfBuff + BInd + 3, 7));
            Netto := String(StrLPas(EmpfBuff + BInd + 10, 8));
          end else                                 //ohne WNr
          begin                                    //0033383   39820kg
            ProtStr := String(StrLPas(EmpfBuff + BInd + 0, 7));
            Netto := String(StrLPas(EmpfBuff + BInd + 7, 8));
          end;
          ProtNr := StrToIntTol(ProtStr);
          P := Pos(',', Netto);
          if P > 0 then
          begin
            Nk := P - length(Netto);              //12,34 -> -2
            Netto := StrCgeChar(Netto, ',', #0);  //12,34 -> 1234
          end;
          P := Pos('.', Netto);  //Haltern: sendet 1.50t45
          if P > 0 then
          begin
            Nk := P - length(Netto);              //12,34 -> -2
            Netto := StrCgeChar(Netto, '.', #0);  //12.34 -> 1234
          end;
          {schlecht da Vorgabe für BuildDesc. Wird in Status übertragen.
          GE := Trim(StrLPas(EmpfBuff + BInd + 18, 2)); }

          Include(FaWaStatus, fwsGewichtOk);
          StrToGewicht(Netto, Gewicht);
          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
        end else
        begin
          Include(FaWaStatus, fwsTimeout);
          Gewicht := 0;
        end;
      except on E:Exception do
        begin
          Include(FaWaStatus, fwsTimeout);
          Display := E.Message;
          Prot0('%s(%.*s)',[E.Message, ATel.OutDataLen, ATel.OutData]);
          Gewicht := 0;
        end;
      end;
    finally
      if assigned(FOnProtGewicht) then
        FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else

    {Antwort auf Befehl Zeilendruck}
    if (Tel_Id = DruckId) then
    begin  //nichts zu tun. nur Ereignis auslösen.
      DruckId := -1;
      FaWaStatus := [];
      if assigned(FOnZeilendruck) then
        FOnZeilendruck(Tel_Id, FaWaStatus);
    end else

    begin
      (* Speichernummer(n) löschen: Erfolg anzeigen *)
    end;
  end;
end;

function TDwt410Kmp.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  //Bruecke nur A, B oder C erlaubt (keine Kombination)
  StrPCopy(Befehl, AnsiString('MP'+Bruecke));
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  //GetTel(ProtGewichtId).Description.Assign(ShortDescr);  MPP=long
  Result := ProtGewichtId;
end;

function TDwt410Kmp.HoleStatus: longint;
begin
  //Bruecke: leer oder A oder B oder C (DWT800: darf nicht '' sein)
  StatusId := StartShort('%s', ['XB'+Bruecke]);  //DWT800: Bruecke schaltet Anzeige um
  Result := StatusId;
end;

function TDwt410Kmp.SwitchMessNr(AMessNr: integer): longint;
var
  S1, S: string;
begin
  //DWT800 TCP Camionau: Brücken umschalten.
  //123 -> ABC falsch!
  {S := StrCgeStrStr(StrCgeStrStr(StrCgeStrStr(
         IntToStr(AMessNr), '1', 'A', false), '2', 'B', false), '3', 'C', false); }
  //123 -> A+B+C
  MessNr := AMessNr;
  S1 := IntToStr(AMessNr);
  S := '';
  if Pos('1', S1) > 0 then AppendTok(S, 'A', '+');
  if Pos('2', S1) > 0 then AppendTok(S, 'B', '+');
  if Pos('3', S1) > 0 then AppendTok(S, 'C', '+');
  SwitchMessNrId := StartShort('%s', ['SB'+S]);  //DWT800: Bruecke schaltet Anzeige um
  Result := SwitchMessNrId;
end;

function TDwt410Kmp.StartShort(const Fmt: string;
  const Args: array of const): longint;
begin  //Start mit ShortDescr. Für CKWSvr
  Result := StartFmt(Fmt, Args);
  GetTel(Result).Description.Assign(ShortDescr);
end;

procedure TDwt410Kmp.UserFnk(ATel: TTel; FnkName : string);
var
  I : integer;
  BccCh : Byte;
begin
  if Uppercase(FnkName) = 'ROWBCC' then
  begin
    if Bcc then
    begin
      BccCh := 0;
      for I:= 0 to ATel.OutDataLen-1 do
        BccCh := BccCh xor ord(ATel.OutData[I]);
      BccCh := BccCh xor DLE;   {^P}
      BccCh := BccCh xor ETX;   {^C}
      ComPort.Write(Addr(BccCh), 1);
    end;
  end else
    inherited UserFnk(ATel, FnkName);
end;

procedure TDwt410Kmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
Var
  ProtStr, GewStr, GEStr: String;
  S1: AnsiString;
begin
  StrCopy(ATel.InData, '');

  if GE = 't' then
  begin
    GEStr := 't';
    GewStr := Format('%.2f', [SimGewicht / 100]);
  end else
  begin
    GEStr := 'kg';
    GewStr := Format('%d', [SimGewicht]);
  end;
  if StrLComp(ATel.OutData,'MP', 2) = 0 then
  begin  // ProtGewicht
    //Variante mit WNr: 0010032100   13820kg
    //        ohne WNr: 0033383   39820kg
    //Haltern        $MP0000020    1.50t45        !Punkt als Dezimaltrenner
    //%MP ist nicht Bestandteil von Antwort
    Inc(SimProtNr);
    if SimProtNr < 100001 then
      SimProtNr := 100001;
    if SimGewicht < 100 then
      ProtStr := 'NO VAL' else
      ProtStr := Format('%07.7d', [SimProtNr]);
    StrFmt(ATel.InData, '%s%-7.7s%8.8s%s', [Bruecke, ProtStr, GewStr, GEStr]);
  end else
  if StrLComp(ATel.OutData,'SB', 2) = 0 then
  begin  // MessNr
    StrFmt(ATel.InData, 'OK', [0]);
  end else
  begin  //Status
    {XB -> 12,34 t bzw. '   12 kg'}
    if CharInSet(Char1(Bruecke), ['A','B','C']) then
      GewStr[1] := Chr(Ord(Char1(Bruecke)) - ord('A') + ord('1')) else  //A->1  C->3
      GewStr[1] := '0';
    S1 := AnsiString(Format('%5.5s %s B', [GewStr, GEStr]));
    StrFmt(ATel.InData, '%s', [S1]);
  end;

  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TDwt410Kmp.Zeilendruck(Zeile: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '', [0]);  //keine Kommunikation. Nur OnAntwort.
  BefLen := StrLen(Befehl);
  DruckID := StartFlags(Befehl, BefLen, [cpfPoll, cpfDummy], '', 0);
  Result := DruckID;
end;

end.
