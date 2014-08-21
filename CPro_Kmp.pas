unit CPro_Kmp;
(* Com Protokoll. Remote noch per Filesystem.

   Autor: Martin Dambach
   letzte Änderung:
   23.04.97        DoProt mit Unterbrechung wenn keine Zeichen anliegen
   12.05.97        Reset
   16.01.99        cpfOnTop (Telegramm sofort ausführen)
   18.06.99        Remote (Waagenserver)
   25.06.99        GlobalStopped startet trotzdem Tel mit cpsWaiting
   08.02.99        Cport Simul
   19.03.01        ComWait: führt nur DoProt aus (kein Poll mehr)
   29.06.01        Description in Tel. Kann bei Start in Prot zugewiesen werden
   27.07.01        Thread (NSTimer) statt PollKmp
   04.07.02        Echo, P:Pause
   06.06.03        property NoThread für OLE/DCOM Zugriff (IT9000)
   15.10.03        ErrProt nach Ausgabe immer löschen
   23.07.04        EmpfBuffer löschen (shsvr)
   25.09.04        neuer Typ 'I' löscht EmpfBuffer
   28.02.07        SleepStartTime (Bug: nach 25Tagen Laufzeit wird Ticks<0
   25.09.09        Antwort ohne Endebedingung (für Ethernet): A:n:min,d1,d2
                   ComThreadInterval auf 100 gesetzt (bei 50 zu viel cpu Belastung)
   13.05.10        neuer Typ 'D' löscht auch EmpfBuffer (wie I)

   *** Description: *** keine Leerzeichen! ***
   T:m             m = TimeOut in ms
   C:              Block Check Character auf 0 zurücksetzen
   I:              Empfangspuffer löschen (ClearInput)
   D:              Empfangspuffer löschen (ClearInput)
   S:^c|a|$xx      Sende Steuerzeichen. c=A..Z, a=0..9,a..z,A..Z, x=0..9,a..f
   B:              Befehl senden
   W:n[:m]|d1,d2   Warte auf Steuerzeichen. n=Anzahl[:Mindestanzahl], d1,d2=max. 2 Steuerzeichen
                     die das Ende markieren i.d.F, ^c: c=A..Z,[,\,] oder $xx
   A:n[:m],d1,d2   Antwort empfangen. Mit Anzahl oder Steuerzeichen wie bei W:
   ;               Kommentar
   P:m             Pause. m = Zeit in ms
   E:1 bzw. E:0    Echo ein/Ausschalten (ein:erwartet Echo nach jedem Sendezeichen)
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,
  nstimer,
  CPor_Kmp, DPos_Kmp,
  WsDDEKmp {TRemote};

type
  TComProt = class;
  TComProtRef = class of TComProt;          {Referenz Klassen TComProt}
  TTel = class;

  TComProtStatus = (cpsOK, cpsWaiting, cpsHanging, cpsError);
  TComProtError = (cpeOK, cpeTimeOut, cpeLength, cpeReset);
  TComProtErrorAction = (cpaIgnore, cpaShow, cpaProt);
  TComProtErrorActions = set of TComProtErrorAction;
  TComProtFlags = set of (cpfWait,         {Warten auf Antwort}
                          cpfPoll,         {Antwort als Ereignis (Standard)}
                          cpfOnTop,        {vor anderen wartenden Tel.ausführen}
                          cpfCache,        {Ergebnis für Remotezugriff cachen}
                          cpfWdhlg,        {Wiederholung bei Fehler (nur SpsProt)}
                          cpfUseId,        {Bestehende ID nochmal verwenden}
                          cpfDummy,        {ohne Kommunikation gleich onAntwort}
                          cpfStart);       {Sofortstart}
  ECom = class(Exception);
  TTelEvent = procedure (Sender: TObject; Tel_Id: longint) of object;
  TComSimulEvent = procedure (OutData: PAnsiChar; OutDataLen: integer;
                               InData: PAnsiChar; var InDataLen: integer) of object;
  TUserFnkEvent = procedure (Sender: TComProt; ATel: TTel; FnkName: String) of object;
  {TComErrorEvent = procedure (Sender: TObject; ErrorStr: String) of object;}

  TTel = class(TObject)
  public
    Owner: TComProt;
    ID: longint;
    Step: integer;
    OutData: PAnsiChar;
    OutDataLen: integer;
    InData: PAnsiChar;
    InDataLen: integer;
    DummyData: PAnsiChar;
    DummyDataLen: integer;
    Flags: TComProtFlags;
    Status: TComProtStatus;
    Error: TComProtError;
    DelimRead: boolean;
    StartTime: longint;
    Reseting: boolean;
    SleepTime: longint;
    SleepProt: boolean;               {true = bereits protokolliert}
    RemoteClient: String;             {Verzeichnis+Filename der Zielfiles}
    Description: TStringList;
    constructor Create(AOwner: TComProt);
    destructor Destroy; override;
    function GetStatusStr: String;
    function GetErrorStr: String;
  end;

  TComProt = class(TComponent)
  private
    { Private-Deklarationen }
    FDescription: TStringList;
    FMaxDataLen: word;
    FComPort: TCustomPort;
    FTestModus: boolean;
    FErrorActions: TComProtErrorActions;
    FOnAntwort: TTelEvent;
    FOnError: TNotifyEvent;
    FActive: boolean;
    FNo2Dle: boolean;                     {keine DLE-Verdoppelung}
    FEcho: boolean;                       {Gerät gibt gesendete Zeichen zurück}
    FRemote: TRemote;                     {Host/Lokal oder Client}
    FRemoteHost: String;                  {Client: Verzeichnis des Hosts}
    FRemoteClients: TValueList;         {Host: Verzeichnisse der Clients}
    FRemoteCache: TValueList;             {Host: Ergebnisse cachen}
    FNoThread: boolean;                   {true: kein Thread(NSTimer) verwenden. Für DCOM-Zugriff}
    InDoProt: boolean;
    TelList: TList;
    LastTime: longint;
    NSTimer: TNonSystemTimer;           {Threading}

    function GetMsStr: String;
    procedure OnNSTimer(Sender: TComponent);
    procedure SetDescription(Value: TStringList);
    procedure SetRemoteClients(Value: TValueList);
    procedure SetMaxDataLen(Value: word);

    procedure ComPoll(Sender: TObject);
    {Pollingfunktion}
    procedure Send(ATel: TTel; DescLine: PAnsiChar);
    function ReadData(Data: PAnsiChar; var Len: Word;
                       Delim1: AnsiChar; Delim2: AnsiChar; var aDelimRead: boolean): boolean;
    function Empf(ATel: TTel; Data: boolean; DescLine: PAnsiChar): boolean;
  protected
    { Protected-Deklarationen }
    OldErrorStr: String;
    FOnSimul: TComSimulEvent;
    FOnUserFnk: TUserFnkEvent;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetSimul: boolean; virtual;
    procedure ErrCom(const Msg: String; const Args: array of const); virtual;
    procedure UserFnk(ATel: TTel; FnkName: String); virtual;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); virtual;
    procedure DoSimul(ATel: TTel); virtual;
    procedure SetActive(Value: boolean); virtual;
    procedure HostStart(AFileName: String);
    procedure HostAntwort(Tel_Id: Longint);
    procedure ClientSend(AFileName: String; OutData: PAnsiChar;
      OutDataLen: integer);
    function ClientEmpf(ATelId: longint; InData: PAnsiChar;
      var InDataLen: integer): boolean;
  public
    { Public-Deklarationen }
    ErrorStr: String;
    ErrorProt: TStringList;
    ProtTelId: longint;
    WaitTelId: longint;
    WaitAntwort: PAnsiChar;
    WaitAntLen: integer;
    WaitStatus: TComProtStatus;
    WaitStatusStr: String;
    SleepStartTime, SleepDauer: longint;
    RemoteCacheTime: longint;                     {max. ALter der Remote-Caches}
    RemoteDelay: longint;          {Verz. zw. FindFirst in ms, dflt=300}

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DoProt;               {private}
    function Open: boolean;
    procedure Close;
    procedure Wait;
    procedure Clear;
    function GetTel(TelID: longint): TTel;
    procedure DeleteTel(TelID: longint);
    function TelCount: integer;
    procedure Sleep(TelID: longint; AnzahlMs: longint);   {läßt sich Zeit für das nächste Telegramm}

    function StartFlags(Befehl: PAnsiChar; Len: integer;
      AFlags: TComProtFlags; ARemoteClient: String; UseId: longint): longint;
    function StartFmt(const Fmt: String; const Args: array of const): longint;
    function Start(Befehl: PAnsiChar; Len: integer): longint;
    function StartOnTop(Befehl: PAnsiChar; Len: integer): longint;
    function GetData(TelID: longint; Antwort: PAnsiChar; var Len: integer;
      IgnoreError: boolean = false): TComProtStatus;
    function WaitStart(Befehl: PAnsiChar; BefLen: integer;
      Antwort: PAnsiChar; var AntLen: integer): TComProtStatus;
    procedure Reset;
    function ClearInput: AnsiString;
    procedure ComWrite(Data: PAnsiChar; Len: Word);
    procedure ComWrite2Dle(Data: PAnsiChar; Len: Word);
    property Active: boolean read FActive write SetActive;
    property Simul: boolean read GetSimul;
  published
    { Published-Deklarationen }
    property ComPort: TCustomPort read FComPort write FComPort;
    property Description: TStringList read FDescription write SetDescription;
    property MaxDataLen: word read FMaxDataLen write SetMaxDataLen;
    property TestModus: boolean read FTestModus write FTestModus;
    property No2Dle: boolean read FNo2Dle write FNo2Dle;
    property Echo: boolean read FEcho write FEcho;
    property ErrorActions: TComProtErrorActions read FErrorActions write FErrorActions;
    property Remote: TRemote read FRemote write FRemote;
    property RemoteHost: String read FRemoteHost write FRemoteHost;
    property RemoteClients: TValueList read FRemoteClients write SetRemoteClients;
    property NoThread: boolean read FNoThread write FNoThread;
    property OnAntwort: TTelEvent read FOnAntwort write FOnAntwort;
    property OnError: TNotifyEvent read FOnError write FOnError;
    property OnUserFnk: TUserFnkEvent read FOnUserFnk write FOnUserFnk;
    property OnSimul: TComSimulEvent read FOnSimul write FOnSimul;
  end;

var
  TelIDCounter: longint;
  GlobalTelList: TList;
  GlobalStopped: boolean;
  GlobalTimeOut: integer;        {wird in initialisation auf 10000 gesetzt 10 sec}
  ComThreadInterval: integer;    {wird in initialisation auf 50 [ms]}

  function ComHanging: boolean;
  procedure ComWait;
  function NewTelId: longint;

const
  InComWait: boolean = false;
  
implementation

uses
  Prots, Poll_Kmp, GNav_Kmp, Err__Kmp;

(*** GlobalTelList (ohne Klasse) **************************************************)

function ComHanging: boolean;
(* Liefert Globalen Status: ob mind. ein Telegramm gerade übertragen wird *)
var
  I: integer;
  ATel: TTel;
begin
  result := false;
  if GlobalTelList <> nil then
  try
    GlobalTelList.Pack;
    for I:= 0 to GlobalTelList.Count-1 do
    begin
      ATel := TTel(GlobalTelList.Items[I]);
      if ATel = nil then continue;
      if ATel.Owner.InDoProt then
      begin
        result := false;         {avoiding deadlock !  171097}
        break;
      end;
      if (ATel.Status = cpsHanging) and (ATel.Step > 0) then
      begin
        { entfernt wg NSTimer }
        //ATel.Owner.DoProt;
        result := true;
      end;
    end;
  except
    {OK: DoProt hat beendet und Tel gelöscht}
  end;
end;

procedure ComWait;
(* Wartet bis kein Telegramm übertragen wird *)
var
  StartTime, DiffTime, N: longint;
begin
  GlobalStopped := true;         {keine neuen Tel starten }
  TicksReset(StartTime);
  DiffTime := GlobalTimeOut;
  { entfernt wg NSTimer }
//  if PollKmp <> nil then
//  begin
//    OldEnabled := PollKmp.Enabled;   {kein Poll}
//    PollKmp.Enabled := false;        {kein Poll}
//  end;
  if not InComWait then
  try
    InComWait := true;
    N := 0;
    {nur SQ:
    if not ComHanging then         //07.02.11 ProcessMessages wird hier immer erwartet
      GNavigator.ProcessMessages;
    }
    while ComHanging and (DiffTime > 0) and (GNavigator <> nil) and
          not GNavigator.NoProcessMessages do
    begin
      GNavigator.SMessLocked := false;
      SMess('Übertragung beenden %ds', [DiffTime div 1000]);
      {DoProt wird bereits in ComHanging aufgerufen}
      GNavigator.ProcessMessages;
      DiffTime := TicksRestTime(StartTime, GlobalTimeOut);
      Inc(N);
    end;
    GlobalStopped := false;
    if SysParam.Delay > 0 then
    begin
      DiffTime := SysParam.Delay;
      while (DiffTime > 0) and (GNavigator <> nil) and
            not GNavigator.NoProcessMessages do
      begin
        GNavigator.SMessLocked := false;
        SMess('Verzögerung beenden %dms', [DiffTime]);
        GNavigator.ProcessMessages;
        DiffTime := TicksRestTime(StartTime, SysParam.Delay);
        Inc(N);
      end;
    end;
    if N > 0 then
      SMess('',[0]);
  finally
    InComWait := false;
    { entfernt wg NSTimer }
//    if PollKmp <> nil then
//    begin
//      PollKmp.Enabled := OldEnabled;   {kein Poll}
//    end;
  end;
end;

function NewTelId: longint;
begin
  Inc(TelIDCounter);
  result := TelIDCounter; {ab 1}
end;

(*** TTel *******************************************************************)

constructor TTel.Create(AOwner: TComProt);
begin
  Owner := AOwner;
  Description := TStringList.Create;
  OutData := AnsiStrAlloc(Owner.MaxDataLen + 1);
  InData := AnsiStrAlloc(Owner.MaxDataLen + 1);
  DummyData := AnsiStrAlloc(Owner.MaxDataLen + 1);
  Description.Assign(AOwner.FDescription);
  Status := cpsOK;
  Error := cpeOK;
  Step := 0;
  DelimRead := false;
  ID := NewTelID;
  (* Registrieren *)
  if GlobalTelList = nil then
    GlobalTelList := TList.Create;
  GlobalTelList.Add(self);
end;

destructor TTel.Destroy;
var
  I: integer;
begin
  I := GlobalTelList.IndexOf(self);
  if I >= 0 then
    GlobalTelList.Delete(I) else
    Prot0('TTel:Index fehlt',[0]);
  StrDispose(OutData);
  StrDispose(InData);
  StrDispose(DummyData);
  Description.Free;
end;

function TTel.GetStatusStr: String;
begin
  case Status of
    cpsOK: result := 'OK';
    cpsHanging: result := 'Hanging';
    cpsError: result := 'Error';
    else
      result := '?' + IntToStr(Ord(Status));
  end;
end;

function TTel.GetErrorStr: String;
begin
  if Status = cpsOK then
    result := '' else
  case Error of
    cpeOK: result := 'OK';
    cpeTimeOut: result := 'Zeitüberschreitung';
    cpeLength: result := 'Längenfehler';
    cpeReset: result := 'Zurückgesetzt';
    else
      result := '?' + IntToStr(Ord(Error));
  end;
end;

(*** TComProt ***************************************************************)

function TComProt.GetMsStr: String;
var
  lpSystemTime: TSystemTime;
begin
//  result := IntToStr(GetTickCount mod 10000);
//  insert('.', result, length(result) - 2);
  GetLocalTime(lpSystemTime);
  result := Format('%d:%d.%d', [lpSystemTime.wMinute, lpSystemTime.wSecond,
    lpSystemTime.wMilliseconds]);
end;

procedure TComProt.ErrCom(const Msg: String; const Args: array of const);
begin
  ErrorStr := (Owner as TComponent).Name+'.'+Name+':'+Format(Msg, Args);
  if OldErrorStr <> ErrorStr then
  begin
    OldErrorStr := ErrorStr;
    if assigned(FOnError) then
      FOnError(self);
    if CpaShow in ErrorActions then
      ErrWarn('%s', [ErrorStr]) else
    if CpaProt in ErrorActions then
    begin
      //Prot0('%s%s%s', [ErrorStr, CRLF, ErrorProt.Text]);        {0:Dpe.erf.autom}
      Prot0('%s', [ErrorStr]);        {0:Dpe.erf.autom}
      ProtStrings(ErrorProt);
      ErrorProt.Clear;                //15.10.03
    end;
    if ComPort <> nil then
    begin
      ComPort.DoProt(cmError, '(ERR)', 5);
    end;
  end;
end;

procedure TComProt.SetDescription(Value: TStringList);
begin
  FDescription.Assign(Value);
end;

procedure TComProt.SetRemoteClients(Value: TValueList);
begin
  FRemoteClients.Assign(Value);
end;

procedure TComProt.SetMaxDataLen(Value: word);
begin
  FMaxDataLen := Value;
end;

(*** Initialisierung *********************************************************)

constructor TComProt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDescription := TStringList.Create;
  FRemoteClients := TValueList.Create;
  FRemoteCache := TValueList.Create;
  ErrorProt := TStringList.Create;
  TelList := TList.Create;
  MaxDataLen := 1024;
  RemoteDelay := 500;
  ProtTelId := -1;
  WaitAntwort := AnsiStrAlloc(MaxDataLen + 1);

  FDescription.Add('B:DATA');
  FDescription.Add('S:^M');
  FDescription.Add('A:128,^M');
end;

procedure TComProt.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
  begin
    if not NoThread then
    begin
      NSTimer := TNonSystemTimer.Create(self);
      NSTimer.Name := self.Name + '_' + 'NSTimer';
      NSTimer.Interval := ComThreadInterval; //100;
      NSTimer.SyncVcl := true;    {dauert länger. Ist sicherer}
      NSTimer.Enabled := true;
      NSTimer.OnTimer := OnNSTimer;
    end else
    begin
      { entfernt wg NSTimer }
      PollKmp.Add(ComPoll, self, 100); {Pollingfunktion anmelden}
    end;
  end;
end;

procedure TComProt.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = ComPort) then
    ComPort := nil;
  inherited Notification(AComponent, Operation);
end;

destructor TComProt.Destroy;
var
  I: integer;
  ATel: TTel;
begin
  if not (csDesigning in ComponentState) then
  begin
    if not NoThread then
    begin
      FreeAndNil(NSTimer);
    end else
    begin
      { entfernt wg NSTimer }
      PollKmp.Sub(ComPoll, self);
    end;
    { warum? if GNavigator <> nil then
      GNavigator.ProcessMessages;}
    for I:= 0 to TelList.Count-1 do
    begin
      ATel := TTel(TelList.Items[i]);
      if (ATel <> nil) then
        ATel.Free;
    end;
  end;
  TelList.Free; TelList := nil;
  FDescription.free; FDescription := nil;
  FRemoteClients.free; FRemoteClients := nil;
  FRemoteCache.free; FRemoteCache := nil;
  StrDispose(WaitAntwort); WaitAntwort := nil;
  ErrorProt.free; ErrorProt := nil;
  inherited Destroy;
end;

function TComProt.Open: boolean;
begin
  Active := true;
  result := Active;          {false wenn Port öffnen nicht möglich}
end;

procedure TComProt.Close;
begin
  if csDestroying in ComponentState then
    Exit;
  Active := false;
end;

procedure TComProt.Wait;
(* Wartet bis alle Telegramme dieses ComProts beendet sind *)
var
  StartTime, DiffTime: longint;
  OldCount: integer;
begin
  OldCount := 0;  //wg Compilerwarnung
  if TelList <> nil then
  begin
    TelList.Pack;
    OldCount := TelList.Count;
  end;
  TicksReset(StartTime);
  if ComPort <> nil then
    DiffTime := ComPort.TimeOut else
    DiffTime := 0;
  while not (csDestroying in ComponentState) and (GNavigator <> nil) and
        (TelList <> nil) and (TelList.Count > 0) and (DiffTime > 0) and
        not GNavigator.NoProcessMessages and not Simul do
  begin
    if ComPort <> nil then
      ComPort.TimeOut := GlobalTimeOut;
    GNavigator.SMessLocked := false;
    SMess('%d Telegramm(e) beenden %ds',[TelList.Count, DiffTime div 1000]);
    GNavigator.ProcessMessages;
    if (csDestroying in ComponentState) or (csDestroying in Owner.ComponentState) then
      Exit;
    if TelList <> nil then
    begin
      TelList.Pack;
      if OldCount <> TelList.Count then
      begin
        OldCount := TelList.Count;
        TicksReset(StartTime);
      end;
    end;
    if ComPort <> nil then
      DiffTime := TicksRestTime(StartTime, ComPort.TimeOut);
  end;
  SMess('',[0]);
end;

procedure TComProt.Clear;
// Beendet alle Telegramme auf schnellstem Weg. Wartet nicht auf Antwort
// Dient z.B. dem Abbruch nach DruckeBlock
var
  OldTimeOut: integer;
begin
  OldTimeOut := GlobalTimeOut;
  try
    GlobalTimeOut := 0;
    Wait;
  finally
    GlobalTimeOut := OldTimeOut;
  end;
end;

procedure TComProt.SetActive(Value: boolean);
(* false = alle anstehenden Telegramme beenden und Port Schließen.
   true  = Port Öffnen. *)
var
  S1: string;
  SearchRec: TSearchRec;
  I: integer;
begin
  if FActive = Value then
    Exit;
  FActive := Value;
  if (csDestroying in ComponentState) or (csDestroying in Owner.ComponentState) then
    Exit;
  if FActive then
  begin
    if Remote = reClient then
    begin
      if (RemoteHost <> '') and (CharN(RemoteHost) = '\') then
      begin
        S1 := copy(RemoteHost, 1, length(RemoteHost) - 1);   {ohne \}
        {if not FileExists(S1) then            (kann damit kein DIR testen}
        try
          MkDir(S1);
        except on E:Exception do
          {EProt(self, E, 'Fehler beim Anlegen von RemoteHost(%s)', [S1]);
           passiert wenn bereits vorhanden}
        end;
        if SysUtils.FindFirst(Format('%s*.HOS', [RemoteHost]), faAnyFile, SearchRec) = 0 then
        try
          repeat                  {*.HOS löschen da nicht mehr bearbeitet}
            SysUtils.DeleteFile(Format('%s%s', [RemoteHost, SearchRec.Name]));
          until SysUtils.FindNext(SearchRec) <> 0;
        except on E:Exception do
          EProt(self, E, 'Open:Delete(%s%s)', [RemoteHost, SearchRec.Name]);
        end;
        SysUtils.FindClose(SearchRec);
      end;
    end else
    begin                (* reHost *)
      if RemoteClients.Count > 0 then
      begin
        for I := 0 to RemoteClients.Count - 1 do
          if SysUtils.FindFirst(Format('%s*.CLI', [RemoteClients[I]]), faAnyFile, SearchRec) = 0 then
          try
            repeat                  {*.CLI löschen da nicht mehr bearbeitet}
              SysUtils.DeleteFile(RemoteClients[I] + SearchRec.Name);
            until SysUtils.FindNext(SearchRec) <> 0;
          except on E:Exception do
            EProt(self, E, 'Open:Delete(%s)', [RemoteClients[I] + SearchRec.Name]);
          end;
        SysUtils.FindClose(SearchRec);
      end;

      if not Simul and (ComPort <> nil) then
        if not ComPort.Open then
          FActive := false;
    end;
  end else
  begin
    Wait;
    if not Simul and (Remote <> reClient) and (ComPort <> nil) then
      ComPort.Close;
  end;
end;

(*** Methoden ***************************************************************)

function TComProt.GetTel(TelID: longint): TTel;
var
  I: integer;
  ATel: TTel;
begin
  result := nil;
  if TelID < 0 then
    Exit;
  if not (csDestroying in ComponentState) then
  begin
    for I:= TelList.Count-1 downto 0 do        {wenn 2 gleiche dann neueren}
    begin
      ATel := TTel(TelList.Items[i]);
      if (ATel <> nil) and (ATel.ID = TelId) then
      begin
        result := ATel;
        break;
      end;
    end;
  end;
end;

procedure TComProt.DeleteTel(TelID: longint);
var
  I: integer;
  ATel: TTel;
begin
  for I:= 0 to TelList.Count-1 do
  begin
    ATel := TTel(TelList.Items[i]);
    if (ATel <> nil) and (ATel.ID = TelId) then
    begin
      TelList.Delete(i);
      ATel.Free;
      break;
    end;
  end;
end;

function TComProt.TelCount: integer;
begin
  result := 0;
  if TelList = nil then
    exit;
  if not InDoProt then
    TelList.Pack;
  result := TelList.Count;
end;

function TComProt.StartFlags(Befehl: PAnsiChar; Len: integer;
  AFlags: TComProtFlags; ARemoteClient: string; UseId: longint): longint;
{ Starten mit Flags:
}
var
  ATel: TTel;
  DescTyp: Char;
  DescLine: array[0..255] of AnsiChar;  //24.02.12 war 80
begin
  if (ComPort = nil) and not Simul and not (cpfDummy in AFlags) then
  begin
    result := -1;
    ErrCom('TComProt.Start:ComPort fehlt',[0]);
  end else
  if not FActive then
  begin
    result := -1;
    ErrCom('TComProt.Start:Protokoll geschlossen',[0]);
  end else
  (*if GlobalStopped then                    (jetzt in Prot)
  begin
    result := -1;
    ErrCom('Start:Protokolle gestopt',[0]);
  end else*)
  begin
    ATel := TTel.Create(self);
    with ATel do
    begin
      Flags := AFlags;
      if Len > MaxDataLen then
      begin
        ErrCom('TComProt.MaxDataLen (%d) zu klein (%d).',[MaxDataLen,Len]);
        Len := MaxDataLen;
      end;
      if cpfUseId in Flags then
        ATel.ID := UseId;
      OutDataLen := Len;
      InDataLen := 0;
      DummyDataLen := 0;
      StrMove(OutData, Befehl, Len);
      Step := 0;
      if ComPort <> nil then
        ComPort.ErrorCode := 0;
      Status := cpsWaiting;    {cpsHanging;}
      RemoteClient := ARemoteClient;         {normall ''}
    end;
    result := ATel.ID;
    if cpfOnTop in AFlags then
    begin
      if (cpfStart in AFlags) and not (cpfDummy in AFlags) and
         not Simul and (Remote <> reClient) then
      begin
        while (ATel.Step < ATel.Description.Count) do
        begin
          DescTyp := Char1(ATel.Description[ATel.Step]);
          if CharInSet(DescTyp, ['S','B']) then
          begin
            if DescTyp = 'S' then                             {Sende S:<^C>|A|$XX}
            begin
              StrPCopy(DescLine, AnsiString(copy(ATel.Description[ATel.Step], 3, 255)));
              Send(ATel, DescLine);
              if TestModus then
                Prot0('cpfStart %s:Tel%d:(%s)', [Name, ATel.ID,
                  ATel.Description[ATel.Step]])
            end else
            begin
              if FNo2Dle then                            {Befehl  B: aus dem Puffer}
                ComWrite(ATel.OutData, ATel.OutDataLen) else
                ComWrite2Dle(ATel.OutData, ATel.OutDataLen);
              if TestModus then
                Prot0('cpfStart %s:Tel%d:B(%s)', [Name, ATel.ID,
                  StrCtrl(StrLPas(ATel.OutData, ATel.OutDataLen))]);
            end;
            Inc(ATel.Step);
            TicksReset(ATel.StartTime);
          end else
            break;
        end;
      end;
      TelList.Insert(0, ATel);
    end else
      TelList.Add(ATel);
  end;
end;

function TComProt.StartFmt(const Fmt: string; const Args: array of const): longint;
var
  S: AnsiString;
begin
  S := AnsiString(Format(Fmt, Args));
  result := Start(PAnsiChar(S), length(S));
end;

function TComProt.Start(Befehl: PAnsiChar; Len: integer): longint;
begin
  if WaitStatus = cpsHanging then
    result := -1 else                      {ErrCom('Start:Belegt',[0]);  zu oft}
    result := StartFlags(Befehl, Len, [cpfPoll], '', 0);
end;

function TComProt.StartOnTop(Befehl: PAnsiChar; Len: integer): longint;
begin
  if WaitStatus = cpsHanging then
    result := -1 else                      {ErrCom('Start:Belegt',[0]);  zu oft}
    result := StartFlags(Befehl, Len, [cpfPoll, cpfOnTop], '', 0);
end;

function TComProt.WaitStart(Befehl: PAnsiChar; BefLen: integer;
  Antwort: PAnsiChar; var AntLen: integer): TComProtStatus;
begin
  if WaitStatus = cpsHanging then
  begin
    ErrCom('WaitStart:Hanging(%s)',[StrCtrl(StrLPas(Befehl, BefLen))]);
    AntLen := 0;
    result := cpsError;
  end else
  begin
    if (Antwort <> nil) then
      StrMove(WaitAntwort, Antwort, AntLen);
    WaitAntLen := AntLen;
    WaitStatus := cpsHanging;
    AntLen := 0;
    try
      WaitTelId := StartFlags(Befehl, BefLen, [cpfWait], '', 0);
      while (WaitStatus = cpsHanging) and (GNavigator <> nil) do
      begin
        GNavigator.ProcessMessages;
        {DoProt;  !!! geht nicht da kein ComReceive möglich}
      end;
    finally
      if WaitStatus = cpsHanging then
        WaitStatus := cpsError;
      if (Antwort <> nil) then   {nil:Antw interessiert nicht. Wir haben ja OnAntwort}
      begin
        StrMove(Antwort, WaitAntwort, WaitAntLen);
      end;
      AntLen := WaitAntLen;
      result := WaitStatus;
    end;
  end;
end;

function TComProt.GetData(TelID: longint; Antwort: PAnsiChar; var Len: integer;
  IgnoreError: boolean = false): TComProtStatus;
//Empfangsdaten holen. Für OnAntwort Ereignis. IgnoreError:true=Ergibt Daten auch bei Fehler
var
  ATel: TTel;
begin
  result := cpsError;
  ATel := GetTel(TelID);
  if ATel <> nil then with ATel do
  begin
    result := Status;
    try
      if Status = cpsHanging then
      begin
        ErrCom('GetData:Protokoll läuft noch',[0]);
      end else
      if (Status = cpsError) and (not IgnoreError or (InDataLen = 0)) then
      begin
        ErrCom('GetData:Fehler in %d.%d(%s)',[TelID, ATel.Step, ATel.GetErrorStr]);
        Len := 0;
      end else
      begin
        if Len < InDataLen then
        begin
          if not (cpfWait in ATel.Flags) then
            ErrCom('Antwortgröße(%d) zu klein. Muß(%d) sein',[Len, InDataLen]);
          InDataLen := Len;
        end;
        if (InDataLen > 0) and (Antwort <> nil) then
          StrMove(Antwort, InData, InDataLen);
        Len := InDataLen;
      end;
    except
      on E:Exception do
        ErrCom('GetData.Ausnahme:%s',[E.Message]);
    end;
  end else
    Len := 0;                                            {220699}
end;

function TComProt.GetSimul: boolean;
begin
  result := assigned(FOnSimul);
end;

procedure TComProt.DoSimul(ATel: TTel);
begin
  if assigned(FOnSimul) then
    FOnSimul(ATel.OutData, ATel.OutDataLen, ATel.InData, ATel.InDataLen);
end;

procedure TComProt.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  ATel: TTel;
begin
  ATel := GetTel(Tel_Id);
  if ATel <> nil then
  begin
    if ATel.RemoteClient <> '' then
    begin
      HostAntwort(Tel_Id);
    end else
    begin
      if assigned(FOnAntwort) then
        FOnAntwort(Sender, Tel_Id);
      if cpfWait in ATel.Flags then
      begin
        WaitStatus := GetData(Tel_Id, WaitAntwort, WaitAntLen);
      end;
    end;
  end;
end;

procedure TComProt.Reset;
var
  ATel: TTel;
begin
  if ProtTelId >= 0 then
  begin
    ATel := GetTel(ProtTelId);
    if ATel <> nil then
      ATel.Reseting := true;
  end else
  if ComPort <> nil then
    ComPort.Reset;
end;

procedure TComProt.Sleep(TelID: longint; AnzahlMs: longint);
{läßt sich Zeit für das nächste Telegramm}
var
  ATel: TTel;
begin
  ATel := GetTel(TelId);
  if ATel <> nil then
    ATel.SleepTime := AnzahlMs;
end;

(*** Timer Prozedur **********************************************************)

procedure TComProt.HostStart(AFileName: string);
var
  AMemoryStream: TMemoryStream;
  Buff: array [0..255] of AnsiChar;       {array size is number of characters needed}
  P, N, I: integer;
  Tel_Id: longint;
  ATel: TTel;
  S, S1, S2: AnsiString;
begin
  AMemoryStream := TMemoryStream.Create;
  try
    AMemoryStream.LoadFromFile(AFileName);
    FillChar(Buff, SizeOf(Buff), #0);               {terminate the null String}
    N := AMemoryStream.Read(Buff, SizeOf(Buff)-1); {read chars from Stream into Buff}
  finally
    AMemoryStream.Free;
  end;
  if not SysUtils.DeleteFile(AFileName) then
    ErrCom('HostStart:DeleteFile (%s) failed', [AFileName]);
  if N > 0 then
  begin
    P := PosR('.', AFileName);                         {letzter '.'. ohne .CLI}
    if P > 0 then System.Delete(AFileName, P, 100);
    Tel_Id := StartFlags(Buff, N, [cpfPoll], AFileName, 0);
    if Tel_Id >= 0 then
    begin
      S := StrCtrl(StrLPas(Buff, N));
      S1 := AnsiString(FRemoteCache.Values[String(S)]);
      if S1 <> '' then                          {ist im Cache}
      begin
        ATel := GetTel(Tel_Id);
        if ATel <> nil then
        begin
          S2 := CtrlStr(S1);
          for I := 1 to IMin(length(S2), MaxDataLen) do
            ATel.InData[I - 1] := S2[I];
          {StrPLCopy(ATel.InData, S2, MaxDataLen);}
          {ATel.InDataLen := StrLen(ATel.InData);       {geht nicht wenn #0 in S2}
          ATel.InDataLen := Length(S2);
          FRemoteCache.Values[String(S)] := '';                  {Cache löschen ERF.SPS!!! pollt nicht immer am Host}
          ATel.Status := cpsOK;                           {alles OK}
          ATel.Step := ATel.Description.Count;
          HostAntwort(Tel_Id);
          DeleteTel(ATel.ID);
        end;
      end;
    end;
  end;
end;

procedure TComProt.HostAntwort(Tel_Id: Longint);
var
  ATel: TTel;
  AFileName: String;
  AMemoryStream: TMemoryStream;
  Buff: array[0..512] of AnsiChar;
  N: integer;
begin
  ATel := GetTel(Tel_Id);
  N := sizeof(Buff);
  if GetData(Tel_Id, Buff, N) = cpsOK then
  begin
    AMemoryStream := TMemoryStream.Create;
    try
      AMemoryStream.Write(Buff, N);              {write chars from Buff into Stream}
      AFileName := ATel.RemoteClient + '.HOS';
      AMemoryStream.SaveToFile(AFileName);
    finally
      AMemoryStream.Free;
    end;
  end;
end;

procedure TComProt.ClientSend(AFileName: String; OutData: PAnsiChar;
  OutDataLen: integer);
var
  AMemoryStream: TMemoryStream;
begin
  AMemoryStream := TMemoryStream.Create;
  try
    AMemoryStream.Write(OutData^, OutDataLen);                   {Buff -> Stream}
    AMemoryStream.SaveToFile(AFileName);
  finally
    AMemoryStream.Free;
  end;
end;

function TComProt.ClientEmpf(ATelId: longint; InData: PAnsiChar;
  var InDataLen: integer): boolean;
var
  AMemoryStream: TMemoryStream;
  SName, AFileName: String;
  ASearchRec: TSearchRec;
  K: integer;
begin
  SName :=  IntToStr(ATelID mod 100000000) + '.HOS';
  result := false;
  if TicksDelayed(LastTime) < RemoteDelay then
    Exit;
  TicksReset(LastTime);
  K := FindFirst(RemoteHost + '*.HOS', faAnyFile, ASearchRec);
  while K = 0 do
  begin
    {smess('Search(%s) Find(%s):%d', [RemoteHost + SName, ASearchRec.Name,
      ord(ASearchRec.Name = SName)]);}
    {Application.ProcessMessages;}
    if ASearchRec.Name <> SName then
    begin
      if not SysUtils.DeleteFile(RemoteHost + ASearchRec.Name) then
        ErrCom('ClientEmpf:DeleteFile (%s) failed', [RemoteHost + ASearchRec.Name]);
    end else
      result := true;
    K := FindNext(ASearchRec);
  end;
  SysUtils.FindClose(ASearchRec);
  if result then
  begin
    AFileName := RemoteHost + SName;
    {result := FileExists(AFileName);
    smess('Exists(%s):%d', [AFileName, ord(Result)]);}
  end;
  if result then
  begin
    AMemoryStream := TMemoryStream.Create;
    try
      AMemoryStream.LoadFromFile(AFileName);
      InDataLen := AMemoryStream.Read(InData^, MaxDataLen);      {Stream -> Buff}
      if not SysUtils.DeleteFile(AFileName) then
        ErrCom('ClientEmpf:DeleteFile (%s) failed', [AFileName]);
      {smess('Read(%s):%d', [StrLPas(InData, InDataLen), InDataLen]);}
    finally
      AMemoryStream.Free;
    end;
  end;
end;

procedure TComProt.OnNSTimer(Sender: TComponent);
begin
  if [csLoading,csReading,csDestroying] * ComponentState = [] then
    ComPoll(Sender);
end;

procedure TComProt.ComPoll(Sender: TObject);
var
  ASearchRec: TSearchRec;
  I, K: integer;
{const
  I: integer = 0;}
begin                                                          {Pollingfunktion}
  if [csLoading,csReading,csDestroying] * ComponentState = [] then
  try
    DoProt;
    if (Remote = reHost) and (RemoteClients.Count > 0) and
       (TicksDelayed(LastTime) >= RemoteDelay) then
    begin
      TicksReset(LastTime);
      {I := (I + 1) mod RemoteClients.Count;}
      for I := 0 to RemoteClients.Count - 1 do
      try
        K := FindFirst(RemoteClients[I] + '*.CLI', faAnyFile, ASearchRec);
        {ProtL('FindFirst%d(%s):%d', [I, RemoteClients[I] + '*.CLI', K]);}
        if K = 0 then
        begin
          HostStart(RemoteClients[I] + ASearchRec.Name);
        end;
      finally
        SysUtils.FindClose(ASearchRec);
      end;
    end;
  except on E:Exception do
    {ErrCom('ComPoll:%s', [E.Message]);}
    EProt(self, E, 'ComPoll',[0]);        {raise;  010797}
  end;
end;

procedure TComProt.ComWrite(Data: PAnsiChar; Len: Word);
begin
  if ComPort = nil then
    Exit;
  if Simul then
  begin
    ComPort.DoProt(cmWrite, Data, Len);
  end else
  begin
    ErrorProt.Add(GetMsStr + '=o:' +
      String(StrCtrl(StrCgeChar(StrLPas(Data, Len), #0, '@'))));
    if Echo then
      ComPort.WriteEcho(Data, Len, true) else
      ComPort.Write(Data, Len);
  end;
end;

procedure TComProt.ComWrite2Dle(Data: PAnsiChar; Len: Word);
begin
  if ComPort = nil then
    Exit;
  if Simul then
    ComPort.DoProt(cmWrite, Data, Len) else
  begin
    ErrorProt.Add(GetMsStr + '=o2:' +
      String(StrCtrl(StrCgeChar(StrLPas(Data, Len), #0, '@'))));
    if Echo then
      ComPort.WriteEcho(Data, Len, false) else
      ComPort.Write2Dle(Data, Len);
  end;
end;

procedure TComProt.Send(ATel: TTel; DescLine: PAnsiChar);
var
  CtrlChar: boolean;
  HexChar: boolean;
  I: integer;
  Ch: AnsiChar;
  FnkName: string;
begin
  CtrlChar := false;
  HexChar := false;
  I := 0;
  while DescLine[i] <> #0 do
  begin
    Ch := DescLine[i];
    if Ch = '^' then
    begin
      if not CtrlChar then
      begin
        CtrlChar := true;
        Inc(I);
        continue;
      end;
    end else
    if Ch = '$' then
    begin
      HexChar := true;
      Inc(I);
      continue;
    end else
    if (Ch = '[') and (DescLine[I+1] <> #0) then
    begin
      if DescLine[I+1] = '[' then
      begin
        I := I + 1;
      end else
      begin
        FnkName := '';
        I := I + 1;
        while (DescLine[I] <> #0) and (DescLine[I] <> ']') do
        begin
          FnkName := FnkName + String(DescLine[I]);
          I := I + 1;
        end;
        I := I + 1;
        UserFnk(ATel, FnkName);
        continue;
      end;
    end else
    if CtrlChar then
    begin
      Ch := AnsiChar(Chr(Ord(Ch) - 64));
      CtrlChar := false;
    end else
    if HexChar then
    begin
      Ch := AnsiChar(Chr(StrToIntDef(Format('$%s%s', [Ch, DescLine[i+1]]), 0)));
      Inc(I);
      HexChar := false;
    end;
    ComWrite(@ch, 1);
    Inc(I);
  end;
end;

function TComProt.ClearInput: AnsiString;
var              {Input Puffer leeren. Warte bis alle Zeichen abgeholt}
  aChar: AnsiChar;
begin
  result := '';
  while (ComPort <> nil) and (ComPort.InCount > 0) do
  begin
    ComPort.Read(@aChar, 1);
    result := result + aChar;
  end;
end;

function TComProt.ReadData(Data: PAnsiChar; var Len: Word;
  Delim1: AnsiChar; Delim2: AnsiChar; var aDelimRead: boolean): boolean;
var      {result=false bedeutet nur daß noch nicht alle Zeichen eingelesen
          wurden und kein Abbruch des Telegramms}
  aChar: AnsiChar;
  I, Err: integer;
  S: AnsiString;
begin
  I := 0;
  Err := 0;
  result := false;
  while (ComPort.InCount > 0) and (I <= Len) do
  begin
    ComPort.Read(@aChar, 1);
    S := S + aChar;
    if aDelimRead then
    begin
      aDelimRead := false;                              {010798}
      if (aChar = Delim2) and (Delim2 <> #0) then
      begin
        result := true;
        break;
      end else
      if (aChar = Delim1) and (Delim1 <> #0) then         {DLE Verdoppelung}
      begin
        if I < Len then
        begin
          Data[I] := Delim1;
          Inc(I);
        end;
      end else
      begin
        if I < Len then
        begin
          Data[I] := Delim1;
          Inc(I);
          if I < Len then
          begin
            Data[I] := aChar;
            Inc(I);
          end;
        end;
      end;
    end else
    if (aChar = Delim1) and (Delim1 <> #0) then
    begin
      if Delim2 = #0 then
      begin
        result := true;
        break;
      end else
      begin
        aDelimRead := true;
      end;
    end else
    begin
      if I < Len then
      begin
        Data[I] := aChar;
        Inc(I);
      end;                        {kein else wg Inc(I)!}
      if (I >= Len) and (Delim1 = #0) then
      begin
        result := true;
        break;
      end;
      if (I >= Len) and (Len > 0) and
         (aChar <> Delim1) and (Delim1 <> #0) then
      begin
        S := S + '[' + aChar + ' statt ' + Delim1 + ']';
        Err := ord(aChar);               {falsches Zeichen. 290601}
        result := false;
        break;
      end;
    end;
  end; {while}
  Len := I;
  ErrorProt.Add(GetMsStr + '=i:' + String(StrCtrl(StrCgeChar(S, #0, '@'))));
  if Err <> 0 then
    EError('Falsches Zeichen(#%d)', [Err]);
end;

function TComProt.Empf(ATel: TTel; Data: boolean; DescLine: PAnsiChar): boolean;
var
  Delim1, Delim2: AnsiChar;
  Tok: PAnsiChar;
  Len, MinLen: word;
  NextStr: PAnsiChar;
  S1, NextS: AnsiString;
begin
  Delim1 := #0;
  Delim2 := #0;
  Len := 0; MinLen := 0;
  Tok := StrTok(DescLine, ',', NextStr);      //keine Leerzeichen! 255, $0A, $0A
  if Data or ((Tok <> nil) and IsNum(Tok[0])) then
  begin
    if Tok <> nil then                        //255
    begin
      S1 := PStrTok(StrPas(Tok), ':', NextS); //255
      Len := StrToInt(String(S1));
      MinLen := Len;
      S1 := PStrTok('', ':', NextS);          //''
      if S1 <> '' then
        MinLen := StrToInt(String(S1));
      //alt Len := StrToInt(Trim(StrPas(Tok)));
    end;
    Tok := StrTok(nil, ',', NextStr);        //$0A
  end;
  if Tok <> nil then
  begin
    if Tok[0] = '$' then    //$80 -> chr(128)
      Delim1 := AnsiChar(Chr(StrToInt(String(StrPas(Tok))))) else
    if Tok[0] = '^' then
      Delim1 := AnsiChar(Chr(ord(UpCase(Tok[1])) - 64)) else
      Delim1 := Tok[0];
    Tok := StrTok(nil, ',', NextStr);       //$0A
  end;
  if Tok <> nil then
  begin
    if Tok[0] = '$' then    //$80 -> chr(128)
      Delim1 := AnsiChar(Chr(StrToInt(String(StrPas(Tok))))) else
    if Tok[0] = '^' then
      Delim2 := AnsiChar(Chr(ord(UpCase(Tok[1])) - 64)) else
      Delim2 := Tok[0];
  end;
  if Data then
  begin
    Len := IMax(0, Len - ATel.InDataLen); {Datenstrom kann während ReadData abreisen}
    result := ReadData(ATel.InData + ATel.InDataLen, Len, Delim1, Delim2,
      ATel.DelimRead);
    Inc(ATel.InDataLen, Len);
    if ATel.InDataLen >= MinLen then
      Result := true;
  end else
  begin
    Len := IMax(0, Len - ATel.DummyDataLen); {Datenstrom kann während ReadData abreisen}
    result := ReadData(ATel.DummyData + ATel.DummyDataLen, Len, Delim1, Delim2,
      ATel.DelimRead);
    Inc(ATel.DummyDataLen, Len);
    if ATel.DummyDataLen >= MinLen then
      Result := true;
  end;
end;


procedure TComProt.DoProt;
{Steuerung vom Ablauf vom Protokoll}
var
  DescTyp: AnsiChar;
  DescLine: array[0..80] of AnsiChar;
  S: AnsiString;
  RemoteName, RemoteFileName: string;
  I, L, iTel: integer;
  ATel: TTel; {Ein Telegramm Ein Protokoll kann mehrere Telegramme haben}
  EOK: boolean;   {Empfang OK}

  procedure ProtLine1(const Fmt: string; const Args: array of const);
  const
    OldS: String = '';
  var
    S: String;
  begin
    S := Format(Fmt, Args);
    if OldS <> S then
    begin
      OldS := S;
      Prot0(Fmt, Args);
    end;
  end;
begin { DoProt }
  if not (csDestroying in ComponentState) and
     not InDoProt and (TelList <> nil) and (TelList.Count > 0) then
  try
    InDoProt := true;
    try
      for iTel:= 0 to TelList.Count-1 do {über alle Telegramme}
      begin
        ATel := TTel(TelList.Items[iTel]);
        if TTel(TelList.Items[iTel]) = nil then
          continue;

        if ATel.RemoteClient = '' then
        begin
          if SleepStartTime <> 0 then
          begin
            if TicksDelayed(SleepStartTime) < SleepDauer then
            begin
              if not ATel.SleepProt then
              begin
                ATel.SleepProt := true;
              end;
              // ClearInput;  beware 30.04.06 ErfSps
              continue;
            end else
              SleepStartTime := 0;
          end;
        end;
        //if (ATel.Status = cpsWaiting) and not GlobalStopped and ComPort.BusyFlag then ProtL('%d:busy', [ATel.ID]);
        if (ATel.Status = cpsHanging) or                             {ist aktiv}
           ((ATel.Status = cpsWaiting) and not GlobalStopped and     {250699}
            ((Comport = nil) or not ComPort.BusyFlag)) then
        begin
          ATel.Status := cpsHanging;
          ProtTelId := ATel.ID; {aktiv in der Bearbeitung}
          try
            (* ohne Kommunikation *)
            if (cpfDummy in ATel.Flags) and not Simul then   //Simul wg Scale99
            begin
              ATel.Status := cpsOK;
            end else
            (* Simulation *)
            if Simul then
            begin
              ATel.Status := cpsOK;
              ATel.InDataLen := 0;
              for I := 0 to ATel.Description.Count - 1 do
              begin
                S := AnsiString(ATel.Description.Strings[I]);
                DescTyp := Char1(S);
                L := length(S) - 2;
                StrPCopy(DescLine, copy(S, 3, L));
                case DescTyp of
           'C':   ComPort.Bcc := 0;
           'S':   Send(ATel, DescLine);                     {Sende S:<^C>|A|$XX}
           'B': begin
                  if ComPort <> nil then
                    ComPort.DoProt(cmWrite, ATel.OutData, ATel.OutDataLen);
                  if TestModus then
                    Prot0('%s:Tel%d:B(%s)', [Name, ATel.ID, StrCtrl(StrLPas(ATel.OutData, ATel.OutDataLen))]);
                end;
           'W':   if ComPort <> nil then
                    ComPort.DoProt(cmRead, DescLine, strlen(DescLine)); {Wait W:...}
           'A': begin
                  try
                    DoSimul(ATel);
                    if TestModus then
                      Prot0('%s:Tel%d:A(%s)', [Name, ATel.ID, StrCtrl(StrLPas(ATel.InData, ATel.InDataLen))]);
                  except on E:Exception do
                    begin
                      ATel.Status := cpsError;
                      EProt(self, E, 'OnSimul(%s)',[E.Message]);
                    end;
                  end;
                  if ComPort <> nil then
                    ComPort.DoProt(cmRead, ATel.InData, ATel.InDataLen);
                end;
                else
                end;
              end; {Simul for}
            end else
            (* Remote: Client *)
            if Remote = reClient then
            begin
              RemoteName := RemoteHost + IntToStr(ATel.ID mod 100000000);
              if ATel.Step = 0 then
              begin
                if ComPort <> nil then
                  ComPort.DoProt(cmWrite, ATel.OutData, ATel.OutDataLen);
                for I := 0 to ATel.Description.Count - 1 do
                begin
                  S := AnsiString(ATel.Description.Strings[I]);
                  DescTyp := Char1(S);
                  L := length(S) - 2;
                  StrPCopy(DescLine, copy(S, 3, L));
                  if DescTyp = 'T' then                          {Timeout in ms}
                    ComPort.TimeOut := IMax(ComPort.TimeOut,
                      StrToIntTol(StrPas(DescLine)));
                end;
                RemoteFileName := RemoteName + '.CLI';
                ClientSend(RemoteFileName, ATel.OutData, ATel.OutDataLen);
                TicksReset(ATel.StartTime);
                ATel.Step := 1;
                if TestModus then
                  Prot0('%s:Tel%d:B(%s)', [Name, ATel.ID, StrCtrl(StrLPas(ATel.OutData, ATel.OutDataLen))]);
              end else
              if ATel.Step = 1 then
              begin
                if TicksDelayed(ATel.StartTime) > ComPort.TimeOut then
                begin                                      {Timeout überwachung}
                  ATel.Status := cpsError;
                  ATel.Error := cpeTimeOut;
                  if TestModus then
                    Prot0('%s:Tel%d:Timeout', [Name, ATel.Id]);
                end else
                begin
                  RemoteFileName := RemoteName + '.HOS';
                  if ClientEmpf(ATel.ID, ATel.InData, ATel.InDataLen) then
                  begin
                    ATel.Status := cpsOK;                             {alles OK}
                    ATel.Step := ATel.Description.Count;
                    if TestModus then
                      Prot0('%s:Tel%d:A(%s)', [Name, ATel.ID, StrCtrl(StrLPas(ATel.InData, ATel.InDataLen))]);
                  end {else
                    SMess('Client%d %d/%d ms',
                    [ATel.Id, TicksDelayed(ATel.StartTime), ComPort.TimeOut])};
                end;
              end;
              if ATel.Status = cpsOK then
                if ComPort <> nil then
                  ComPort.DoProt(cmRead, ATel.InData, ATel.InDataLen);
            end else
            (* Lokales Protokoll *)
            while ATel.Step < ATel.Description.Count do {Innerhalb des Telegramms}
            begin
              //if not ComPort.BusyFlag then ProtL('%d:start busy', [ATel.ID]);
              ComPort.BusyFlag := true;
              //EOK := true;                             {Empfang OK}
              S := AnsiString(ATel.Description.Strings[ATel.Step]);
              DescTyp := Char1(S);                           {Das erste Zeichen}
              L := length(S) - 2;
              StrPCopy(DescLine, copy(S, 3, L));       {: auch weg, reine Daten}
              if TestModus then                        {im Testmodus protokolieren}
                ProtLine1('%s:Tel%d.%d(%s)', [Name, ATel.ID, ATel.Step, S]);

              if DescTyp in ['A','W'] then           {einzelne Typen abarbeiten}
              begin                        {A=Antwort W=Warte auf Steuerzeichen}
                if ComPort.InCount = 0 then                   {nichts empfangen}
                begin
                  if TicksDelayed(ATel.StartTime) > ComPort.TimeOut then
                  begin                                    {Timeout überwachung}
                    ATel.Status := cpsError;
                    ATel.Error := cpeTimeOut;
                    //EOK := false;                      {Empfang nicht OK}
                  end;
                  break; {while}
                end;
              end;


              if DescTyp in ['I', 'D'] then
              begin
                //Empfangspuffer leeren. Wir erwarten keine Zeichen - 23.07.04 SHSVR
                ClearInput;
              end else
              if DescTyp = 'T' then                        {Timeout pro Schritt}
              begin
                ComPort.TimeOut := StrToInt(String(StrPas(DescLine)));  {Timeout in ms  T:<ms>}
                TicksReset(ATel.StartTime);
                Inc(ATel.Step);
                break;
              end else
              if DescTyp = 'P' then                        {Pause}
              begin
                //SleepEndTime := IMax(SleepEndTime, Ticks +
                //  StrToInt(Trim(StrPas(DescLine)))); {QSBT 04.07.02}
                SleepDauer := StrToInt(Trim(String(StrPas(DescLine)))); {QSBT 28.02.07}
                TicksReset(SleepStartTime);
                ATel.SleepProt := false;
                Inc(ATel.Step);
                break;
              end else
              if DescTyp = 'R' then                               {Remote Cache}
              begin
                RemoteCacheTime := StrToIntTol(String(StrPas(DescLine)));
                if RemoteCacheTime = 0 then
                  RemoteCacheTime := 1000;
                {kein break}
              end else
              if DescTyp = 'E' then                               {Echo}
              begin
                if DescLine = '0' then
                  Echo := false else
                  Echo := true;
                if TestModus then
                  ProtLine1('Echo:%d', [ord(Echo)]);
                {kein break}
              end else
              if DescTyp = 'C' then  {Bcc auf 0}
              begin
                ComPort.Bcc := 0;
                Inc(ATel.Step);
                break;
              end else
              if DescTyp = 'S' then {senden}
              begin
                Send(ATel, DescLine);                     {Sende S:<^C>|A|$XX}
                {kein break}
              end else
              if DescTyp = 'B' then {Befehl senden}
              begin
                if FNo2Dle then                      {Befehl  B: aus dem Puffer}
                  ComWrite(ATel.OutData, ATel.OutDataLen) else
                  ComWrite2Dle(ATel.OutData, ATel.OutDataLen);
                {kein break}
              end else
              if DescTyp = 'W' then                     {Wait for Steuerzeichen}
              begin
                EOK := Empf(ATel, false, DescLine);     {Wait for  W:<n>|<D1>,<D2>}
                if EOK then
                  Debug0 else
                  break;  //noch kein 'EndOfKommunikation', Step nicht erhöhen.
              end else
              if DescTyp = 'A' then
              begin
                EOK := Empf(ATel, true, DescLine);         {Antwort  A:<Len>,<D1>,<D2>}
                if EOK then
                  Debug0 else
                  break;
              end else
              if DescTyp = ';' then
              begin                                                  {Kommentar}
                {kein break}
              end else
              begin
                ATel.Status := cpsError;
                ATel.Error := cpeLength;
                ErrCom('Syntaxfehler in Description %d(%s)',[ATel.Step, S]);
                break;
              end;

              if (ComPort.ErrorCode <> 0) then
              begin
                ATel.Status := cpsError;
                ATel.Error := cpeTimeOut;
                ErrCom('ComPort Fehler(%s)',[ComPort.ErrorStr]);
                break;
              end;

              if ATel.Step < ATel.Description.Count-1 then
              begin
                S := AnsiString(ATel.Description.Strings[ATel.Step + 1]);
                DescTyp := S[1];
                if DescTyp in ['A','W'] then
                begin
                  TicksReset(ATel.StartTime);
                  ATel.DelimRead := false;
                  (* Nein PR1613
                     if DescTyp = 'A' then {Lesepuffer löschen}
                    ATel.InDataLen := 0; *)
                  if DescTyp = 'W' then
                    ATel.DummyDataLen := 0;
                end;
              end;

              Inc(ATel.Step); {zum nächsten Schritt}
            end; {while}
            (*if not EOK then         {Empfang noch nicht komplett: ist auch OK}
            begin
              ATel.Status := cpsError;
              if ATel.Error <> cpeTimeOut then
                ATel.Error := cpeLength;    {Längenfehler, falsches Zeichen empf}
              if not TestModus then                        {im Testmodus protokolieren}
                ProtLine1('%s:Tel%d.%d(%s)', [Name, ATel.ID, ATel.Step,
                  ATel.Description.Strings[ATel.Step]]);
              {ErrCom('Fehler bei Empfang',[0]);  {in GetData}
            end;*)
          except
            on E:Exception do
            begin
              ATel.Status := cpsError;
              ATel.Error := cpeTimeOut;
              ErrCom('ComProt.Ausnahme:%s',[E.Message]);
            end;
          end;

          if (ATel.Status <> cpsHanging) or
             (ATel.Step >= ATel.Description.Count) then
          begin
            //if ComPort.BusyFlag then ProtL('%d:end busy', [ATel.ID]);
            if ComPort <> nil then
              ComPort.BusyFlag := false;
            ProtTelId := -1;                             {bereits hier wg Reset}
            if ATel.Reseting then
            begin
              if ComPort <> nil then
                ComPort.Reset;
              ATel.Status := cpsError;
              ATel.Error := cpeReset;
            end;
            if (ATel.Status = cpsHanging) then              {erst hier wg Reset}
              ATel.Status := cpsOK;
            { if ((ATel.Status = cpsOK) or not (CpaProt in ErrorActions)) and
               TestModus then
              ProtStrings(ErrorProt); 15.10.03}
            try
              DoAntwort(self, ATel.ID);
            except on E:Exception do
              ErrCom('ComProt.DoAntwort:%s',[E.Message]);
            end;
            if cpfCache in ATel.Flags then
              FRemoteCache.Values[String(StrCtrl(StrLPas(ATel.OutData, ATel.OutDataLen)))] :=
                String(StrCtrl(StrLPas(ATel.InData, ATel.InDataLen)));
            if ATel.SleepTime > 0 then
            begin
              //SleepEndTime := IMax(SleepEndTime, Ticks + ATel.SleepTime); {SWE 090299}
              SleepDauer := ATel.SleepTime;
              TicksReset(SleepStartTime);
              ATel.SleepTime := 0;
              ATel.SleepProt := false;
            end;
            DeleteTel(ATel.ID);
            if TestModus then
              ProtStrings(ErrorProt);
            ErrorProt.Clear;
          end;              {kein else da sonst Listenindex Fehler in for ..}
          break;
        end; {if}
      end; {for}

    except
      on E:Exception do
        ErrCom('ComProt.DoProt:%s',[E.Message]);
    end;
  finally
    InDoProt := false;
  end;
end;

(*** User Funktions *******************************************************)

procedure TComProt.UserFnk(ATel: TTel; FnkName: string);
// ist virtual, kann override'd werden
var
  I: integer;
  Bcc: integer;
  Ch: Byte;
begin
  if Uppercase(FnkName) = 'BCC' then          {Standard BCC}
  begin
    Bcc := ComPort.Bcc;
    ComWrite2Dle(Addr(Bcc), 1);
  end else
  if Uppercase(FnkName) = 'GAWCHECK' then     {Gawellek-BCC}
  begin
    Bcc := 0;
    for I := 0 to ATel.OutDataLen-1 do
    begin
      Bcc := Bcc + ord(ATel.OutData[I]);
    end;
    Ch := Bcc mod 256;
    ComWrite(Addr(ch), 1);
  end else
  if Uppercase(FnkName) = 'BCCSCHENK' then    {Schenk BCC}
  begin
    Bcc := ETX;
    for I := 0 to ATel.OutDataLen-1 do
    begin
      Bcc := Bcc xor (ord(ATel.OutData[I]));
    end;
    ComWrite(Addr(Bcc), 1);
  end else
  if Uppercase(FnkName) = 'BCCDIS39' then    {Schenk Disomat 3964R BCC}
  begin
    Bcc := ETX xor DLE;
    for I := 0 to ATel.OutDataLen-1 do
    begin
      Bcc := Bcc xor (ord(ATel.OutData[I]));
    end;
    ComWrite(Addr(Bcc), 1);
  end else
  if Uppercase(FnkName) = 'BCCDPP8785' then    {Schenk Disomat DPP8785}
  begin
    Bcc := ETX;
    for I := 0 to ATel.OutDataLen-1 do
    begin
      Bcc := Bcc xor (ord(ATel.OutData[I]));
    end;
    ComWrite(Addr(Bcc), 1);
  end else
  if assigned(FOnUserFnk) then                {Ereignis aufrufen}
  begin
    FOnUserFnk(self, ATel, FnkName);
  end else
  begin
    Prot0('Unbekannte Funktion (%s)'+CRLF+'TComProt.UserFnk',[FnkName]);
  end;
end;

initialization
  GlobalTimeOut := 10000;          { 10 sec}
  ComThreadInterval := 100;        // war 50 und hob CPU auf 50%! jetzt 0%! vor 27.09.09
end.

