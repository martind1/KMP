unit Poll_Kmp;
(* Polling Komponente
   08.04.98  mit SenderAdr statt Sender um das selbe Form mehrmals zu verwenden
   14.04.99  Win32 mit NSTimer   (noch nicht freigegeben, daher auskommentiert)
   05.07.99  PollWait
   15.07.99  DestroyForms, ReleaseForms
   29.02.00  PollMessage
   14.01.02  DoPoll: InTimer immer auf false setzen
   30.09.04  TicksDelayed funkioniert auch wenn PC >21Tage läuft
   31.01.14  PollWaitAktiv statt lokalem Aktiv
*)
interface

//definieren wenn über ThreadTimer: nicht verwenden da Sync Probleme
{.$define NSTIMER}
{$undef NSTIMER}

uses
{$ifdef NSTIMER}
  NSTimer,
{$else}
{$endif}
  WinTypes, WinProcs,
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls;

type
  TPollFunk = class(Tobject)
    Funk : TNotifyEvent;   {Aufzurufen}
    Sender : TComponent;
    Display: string;            {Sender Name}
    Active : boolean;
    Deleting : boolean;
    Period : longint;           {Periode in ms}
    LastTime : longint;         {letzter Startzeitpunkt}
    LastTimeChanged: boolean;   {Flag ob Sleep innerhalb Active aufgerufen}
  end;
  TPollMessage = record
    Sender: HWND;
    Msg: Word;
    WParam: Word;
    LParam: Longint;
  end;
  PPollMessage = ^TPollMessage;

{$ifdef NSTIMER}
  TPollKmp = class(TNonSystemTimer)  {von Threaded (Non System) Timer}
{$else}
  TPollKmp = class(TTimer)  {Deklaration der Komponente}
{$endif}
  private
    { Private-Deklarationen }
    FList : TList;
    FIdle: boolean;
    procedure DoPoll;
  protected
    { Protected-Deklarationen }
{$ifdef NSTIMER}
    procedure DummyTimer(Sender: TComponent); {Callback-Funktion für den Timer}
{$else}
    procedure Timer; override; {Callback-Funktion für den Timer}
    procedure DummyTimer(Sender: TObject); {Wenn keine Funktionen eingefügt dann Verweis auf den Dummy}
{$endif}
  public
    { Public-Deklarationen }
    ItemIndex : integer; {Index der aktiven Funktion}
    InTimer : boolean;   {Befindet sich Timerfunktion}
    Counter: longint;    {wird z.Z nicht benutzt}
    DestroyForms: TList;  {Liste der wartenden Forms}
    ReleaseForms: TList;  {Liste der wartenden Forms}
    MessageList: TList;   {Liste der wartenden Messages}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetIndex(AFunk: TNotifyEvent; ASender : TComponent;
                       var APollFunk: TPollFunk; var AIndex: integer): boolean;
            {Sucht eine vorhandene Funktion. Index oder -1 wenn nicht vorhanden}
    procedure Add(AFunk: TNotifyEvent; ASender : TComponent; APeriod : longint);
                                 {Fügt eine Funktion zur Timer behandlung hinzu}
    procedure Sub(AFunk: TNotifyEvent; ASender : TComponent);
                  {Nimmt eine vorhandene Funktion aus der Timer-Behandlung raus}
    procedure SetPeriod(AFunk: TNotifyEvent; ASender : TComponent;
      NewPeriod: longint); {Ändert für eine vorhandene Funktion Period}
    procedure Sleep(AFunk: TNotifyEvent; ASender: TComponent; AnzahlMs: longint);
    {vorhandene Funktion 'schläft' für AnzahlMs [ms]. 0=gleich aufrufen}
    procedure DoIdle;
    procedure PollMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM);
    {Message absenden wenn Polling frei ist}
  published
    { Published-Deklarationen }
    property Idle: boolean read FIdle write FIdle;
  end;

  procedure PollWait;

var
  PollKmp : TPollKmp;

implementation

uses
  GNav_Kmp, Err__Kmp, Prots,
  CPro_Kmp,     {GlobalTimeOut}
  Qwf_Form, KmpResString;

var
  PollWaitAktiv: boolean;

procedure PollWait;
(* Wartet bis keine Poll Funktion mehr ausgeführt wird. Für CmRelease *)
var
  StartTime, DiffTime, N: longint;
  OldEnabled: boolean;
begin
  if PollKmp = nil then
    Exit;
  if not PollWaitAktiv then
  try
    PollWaitAktiv := true;
    OldEnabled := PollKmp.Enabled;
    PollKmp.Enabled := false;
    TicksReset(StartTime);
    DiffTime := GlobalTimeOut;
    N := 0;
    while PollKmp.InTimer and (DiffTime > 0) do
    begin
      Inc(N);
      SMess(SPoll_Kmp_001, [DiffTime div 1000]);	// '%s'+CRLF+'Daten Ändern'
      Application.ProcessMessages;
      DiffTime := TicksRestTime(StartTime, GlobalTimeOut);
    end;
    PollKmp.Enabled := OldEnabled;
    if N > 0 then
      SMess('',[0]);
  finally
    PollWaitAktiv := false;
  end;
end;

constructor TPollKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if PollKmp = nil then
    PollKmp := self else
    ErrWarn('PollKmp bereits vorhanden', [0]);
    //raise EInit.Create(SPoll_Kmp_002);	// 'Polling Komponente bereits vorhanden'
  DestroyForms := TList.Create;
  ReleaseForms := TList.Create;
  MessageList := TList.Create;
  FList := TList.Create;  {Initialisieren der Object-Liste}
  ItemIndex := 0;         {keine Funkton eingefügt}
  OnTimer := DummyTimer;        {muß damit TTimer den Win-Timer installiert}
  Interval := 50;               {1/18 Tics ausnutzen, Min. Period berücksichtigen}
end;

destructor TPollKmp.Destroy;
var
  I: integer;
begin
  Enabled := false;           {Timer}
  for I := 0 to FList.Count-1 do
  begin
    if assigned(TPollFunk(FList.Items[I])) then
      TPollFunk(FList.Items[I]).Free;  //27.09.13
  end;
  FList.Free; FList := nil; {Objectliste freigeben}
  DestroyForms.Free; DestroyForms := nil;
  ReleaseForms.Free; ReleaseForms := nil;
  MessageList.Free; MessageList := nil;
  if PollKmp = self then
    PollKmp := nil;
  inherited Destroy;
end;

{$ifdef NSTIMER}
procedure TPollKmp.DummyTimer(Sender: TComponent);
begin          (* Timer Event *)
  if not Idle then
    DoPoll;
end;
{$else}
procedure TPollKmp.DummyTimer(Sender: TObject);
begin          (* wichtig für Timer *)
end;
{$endif}

function TPollKmp.GetIndex(AFunk: TNotifyEvent; ASender : TComponent;
  var APollFunk: TPollFunk; var AIndex: integer): boolean;
(* Sucht eine vorhandene Funktion. Index oder -1 wenn nicht vorhanden *)
var
  I: integer;
begin
  result := false;
  for I := 0 to FList.Count-1 do
  begin
    APollFunk := TPollFunk(FList.Items[I]);
    if (APollFunk <> nil) and
       (Addr(APollFunk.Funk) = Addr(AFunk)) and
       (APollFunk.Sender = ASender) then
    begin
      AIndex := I;
      result := true;
      exit;                                            {die richtige gefunden}
    end;
  end;
end;

procedure TPollKmp.Add(AFunk: TNotifyEvent; ASender : TComponent; APeriod : longint);
{Fügt eine Funktion zur Timer behandlung hinzu}
var
  APollFunk : TPollFunk;
  I: integer;
begin
  if csDesigning in ComponentState then
    Exit;
  if not GetIndex(AFunk, ASender, APollFunk, I) then
  try
{$ifdef NSTIMER}
  GNavigator.NoProcessMessages := true;
{$else}
{$endif}
    {Die Datenstruktur anlegen und mit Werten belegen}
    APollFunk := TPollFunk.Create;
    APollFunk.Funk := AFunk;
    APollFunk.Sender := ASender;
    {if ASender.Owner <> nil then
      APollFunk.Display := Format('%s.%s', [ASender.Owner.Name, ASender.Name]) else
      APollFunk.Display := ASender.Name;}
    APollFunk.Display := OwnerDotName(ASender);
    APollFunk.Period := APeriod;
    APollFunk.Active := false;
    APollFunk.Deleting := false;
    TicksReset(APollFunk.LastTime);  {1.Start erst nach Ablauf von Period [ms]. Wichtig für DatumDlg}
    FList.Add(APollFunk);   {Der Liste der Objekte hinzufügen}
    Enabled := not Idle;    {Ist zugänglich}
    Prot0('%s.Added(%s)', [ClassName, OwnerDotName(ASender)]);
  except on E:Exception do
    EProt(self, E, 'Add', [0]);
  end else
    Prot0(SPoll_Kmp_003, [ClassName, OwnerDotName(ASender)]);	// '%s:Add(%s) bereits vorhanden'
end;

procedure TPollKmp.Sub(AFunk: TNotifyEvent; ASender : TComponent);
{Nimmt eine vorhandene Funktion aus der Timer-Behandlung raus}
var
  I: integer;
  APollFunk : TPollFunk;
  AName: string;
begin
  if (self <> nil) and ([csDesigning, csDestroying] * ComponentState = []) then
  try
    if GetIndex(AFunk, ASender, APollFunk, I) then
    begin
      AName := APollFunk.Sender.Name;
      APollFunk.Deleting := true;
      while APollFunk.Active and (GNavigator <> nil) do          {solange aktiv}
      begin
        Prot0('PollKmp.Sub(%s):Waiting',[AName]);
        GNavigator.ProcessMessages;                {Kontrolle an Windows geben}
        Prot0('PollKmp.Sub(%s):Processed',[AName]);
        break;
      end;
      FList.Delete(I); {aus Liste entfernen}
      APollFunk.Free;
    end;
  except on E:Exception do
    Prot0('%s%sPollKmp.Sub',[E.Message, CRLF]);
  end;
  if FList.Count = 0 then                    {keine Funktionen mehr für Polling}
    Enabled := false;                                        {Timer ausschalten}
end;

procedure TPollKmp.SetPeriod(AFunk: TNotifyEvent; ASender : TComponent;
  NewPeriod : longint);
{Ändert für eine vorhandene Funktion Period}
var
  I: integer;
  APollFunk : TPollFunk;
begin
  if not (csDesigning in ComponentState) then
    if GetIndex(AFunk, ASender, APollFunk, I) then
      APollFunk.Period := NewPeriod;
end;

procedure TPollKmp.Sleep(AFunk: TNotifyEvent; ASender: TComponent; AnzahlMs: longint);
{vorhandene Funktion 'schläft' für AnzahlMs [ms]. 0=gleich aufrufen}
var
  I: integer;
  APollFunk : TPollFunk;
begin
  if not (csDesigning in ComponentState) then
    if GetIndex(AFunk, ASender, APollFunk, I) then
    begin
      APollFunk.LastTimeChanged := APollFunk.Active;
      //alt:
      //APollFunk.LastTime := TicksDelayed(APollFunk.Period + AnzahlMs);
      //19.06.13
      TicksReset(APollFunk.LastTime);
      APollFunk.LastTime := APollFunk.LastTime + AnzahlMs - APollFunk.Period;
    end;
end;

{$ifdef NSTIMER}
{$else}
procedure TPollKmp.Timer;
begin               {Behandlung des Timer-Ereignisses}
  inherited Timer;
  if not Idle then
    DoPoll;
end;
{$endif}

procedure TPollKmp.DoIdle;
{Behandlung des Timer-Ereignisses über OnIdle von GNavigator}
begin
  if Idle then
    DoPoll;
end;

procedure TPollKmp.DoPoll;
{Behandlung des Timer-Ereignisses}
var
  I, Err: integer;
  AName: string;
  APollFunk : TPollFunk;
  Done: Boolean;
  CurTime: longint;
  AForm: TqForm;
  AMessage: PPollMessage;
  OldInTimer: boolean;
begin
  OldInTimer := InTimer;                      {160799}
  Err := 0;
  {Nur wenn nicht im Designer und nicht beim Formular-Schließen }
  if not (csDesigning in ComponentState) and
     not (csDestroying in ComponentState) and   {nein qwf)  {X ja}
     not InTimer and (Enabled or Idle) then   //warum InTimer? 30.01.12 SecSigner
  try
    InTimer := true;                                {Wir sind im Timer-Ereignis}
    Done := false;
    TicksReset(CurTime);                            {Startzeit merken}
    AName := '';
    for I := 0 to FList.Count - 1 do                {über die Liste der Objekte}
    begin
      if not Done and (Enabled or Idle) then
      try
        ItemIndex := (ItemIndex + 1) mod FList.Count; {ItemIndex wird immmer weiter inkrementiert}
        APollFunk := TPollFunk(FList.Items[ItemIndex]);
        if (APollFunk <> nil)
          and ((APollFunk.Sender = nil) or
               not (csDestroying in APollFunk.Sender.ComponentState))
          and not APollFunk.Active                      {und nicht gerade aktiv}
          and not APollFunk.Deleting                          {und nicht in Sub}
          and (APollFunk.Period > 0)                          {und mit Interval}
          and (TicksRestTime(APollFunk.LastTime, APollFunk.Period) <= 0) then  //wird nie <0 !
        begin
          try
            AName := 'PollFunk.Display';
            AName := APollFunk.Display;
            APollFunk.Active := true;                     {geht in Aktivzustand}
            //if DlgMMGr <> nil then
            //  TDlgMMGr.EndCheck(Format('Start:%s', [AName]));
            APollFunk.Funk(APollFunk.Sender);      {Aufruf der Funktion selbst}
            if (PollKmp = nil) or (csDestroying in PollKmp.ComponentState) then
              exit;
            //if DlgMMGr <> nil then
            //begin
            //  {X} Application.ProcessMessages;
            //  TDlgMMGr.EndCheck(Format(SPoll_Kmp_004, [AName]));	// 'Ende:%s'
            //end;
          except on E:Exception do
            begin
              Done := true;
              Prot0('PollTimer%d(%s):%s', [ItemIndex, AName, E.Message]);
              SMess('PollTimer%d(%s):%s', [ItemIndex, AName, E.Message]);
            end;
          end;
          APollFunk.Active := false;
          {break;               zu langsam                  {besser gleich raus}
          if TicksDelayed(CurTime) > 200 then
            Done := true; {Nach der Rückkehr LastTime setzen für den nächsten Aufruf}
          if not APollFunk.LastTimeChanged then
            TicksReset(APollFunk.LastTime) else
            APollFunk.LastTimeChanged := false;
        end;
      except on E:Exception do
        begin
          ProtL('PollList%d(%s):%s',[ItemIndex, AName, E.Message]);
          Done := true;
        end;
      end;
{$ifdef NSTIMER}
      break;
{$else}
      {break;            zu langsam                     {besser gleich raus}
{$endif}
    end;
  finally
    InTimer := OldInTimer;                      {160799}
    InTimer := false;                           {Flag löschen  19.12.01}
    if not InTimer and (DestroyForms <> nil) then
    try
      Err := 1;
      while (DestroyForms.Count > 0) and (DestroyForms[0] <> nil) do
      begin
        AForm := TqForm(DestroyForms[0]);
        DestroyForms.Delete(0);
        DestroyForms.Pack;
        AForm.Destroy;
        SMess0;
      end;
    except on E:Exception do
      EProt(self, E, 'DestroyForms:%d', [Err]);
    end;
    if not InTimer and (ReleaseForms <> nil) then
    try
      while (ReleaseForms.Count > 0) and (ReleaseForms[0] <> nil) do
      begin
        AForm := TqForm(ReleaseForms[0]);
        Prot0('Poll.Release(%s)', [AForm.Kurz]);
        ReleaseForms.Delete(0);
        ReleaseForms.Pack;
        AForm.Release;
        SMess0;
      end;
    except on E:Exception do
      EProt(self, E, 'ReleaseForms', [0]);
    end;
    if not InTimer and (MessageList <> nil) then
    try
      while (MessageList.Count > 0) and (MessageList[0] <> nil) do
      begin
        AMessage := PPollMessage(MessageList[0]);
        MessageList.Delete(0);
        MessageList.Pack;
        SendMessage(AMessage^.Sender, AMessage^.Msg, AMessage^.WParam, AMessage^.LParam);
        Dispose(AMessage);
        SMess0;
      end;
    except on E:Exception do
      EProt(self, E, 'MessageList', [0]);
    end;
    //Lebenszeichen:
    if GNavigator <> nil then
      GNavigator.SendAlive(SysParam.AliveTime);
  end;
end;

procedure TPollKmp.PollMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM);
{Messages absenden wenn Polling frei ist}
var
  AMessage: PPollMessage;
begin
  if InTimer then
  begin
    SMess(SPoll_Kmp_005, [Msg]);	// 'Starte %d'
    New(AMessage);
    AMessage^.Sender := hWnd;
    AMessage^.Msg := Msg;
    AMessage^.wParam := wParam;
    AMessage^.lParam := lParam;
    MessageList.Add(AMessage);
  end else
  try
    SendMessage(hWnd, Msg, WParam, LParam);
  except on E:Exception do
    EProt(self, E, 'PollMessage', [0]);
  end;
end;

begin
  PollWaitAktiv := false;
end.
