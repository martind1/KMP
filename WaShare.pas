unit WaShare;
(* Waagensharing Verwaltung für Röhm, DPE

   Steuerung über externe Query, welche für ein Device die Felder
   PCNR und CNTR im Schreibzugriff bereitstellt

   Starten über Methode Init;

   Autor: M.Dambach

   30.03.98     Erstellen
*)
interface

uses
{$ifdef WIN32}
  Windows,
{$else}
{$endif}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB,  Uni, DBAccess, MemDS,
  CPro_Kmp;

type
  TLockState = (lsLock, lsNoLock);
  TWaShare = class(TComponent)
  private
    { Private-Deklarationen }
    FActive: boolean;
    FCntr: integer;
    FComProt: TComProt;
    FTblWSha: TDataSet;
    FWsActive: boolean;
    FPollInterval: integer;
    OldPollInterval: integer;
    procedure SetActive( Value: boolean);
    procedure SetWsActive( Value: boolean);
    procedure SetCntr( Value: integer);
  protected
    { Protected-Deklarationen }
    InternalActive: boolean;
    PcNr: string;
    Changed: boolean;
    procedure Loaded; override;
    procedure Poll( Sender: TObject);
    procedure Load( Modus: TLockState);
    procedure UnLock;
    procedure Save( APcNr: string);
    procedure Wait;
    procedure Answer;
    procedure WaitForActive;                       {für externen Aufruf}
    property Cntr: integer read FCntr write SetCntr;
    property WsActive: boolean read FWsActive write SetWsActive;
  public
    { Public-Deklarationen }
    Debug: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open;             {für externen Aufruf}
    procedure Close;             {für externen Aufruf}
    procedure Connect( Value: boolean);
  published
    { Published-Deklarationen }
    property Active: boolean read FActive write SetActive;
    property ComProt: TComProt read FComProt write FComProt;
    property TblWSha: TDataSet read FTblWSha write FTblWSha;
    property PollInterval: integer read FPollInterval write FPollInterval;
  end;

implementation

uses
  GNav_Kmp, Poll_Kmp, Err__Kmp, Prots, AbortDlg;

constructor TWaShare.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPollInterval := 2000;       {jede 2. Sekunde Pollen}
end;

procedure TWaShare.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
  begin
    OldPollInterval := FPollInterval;
    PollKmp.Add(Poll, self, FPollInterval);
    Active := InternalActive;
  end;
end;

destructor TWaShare.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    Close;
    if assigned(PollKmp) then
      PollKmp.Sub(Poll, self);
  end;
  inherited Destroy;
end;

procedure TWaShare.Open;
begin
  Active := true;
end;

procedure TWaShare.Close;
begin
  Active := false;
end;

procedure TWaShare.SetActive( Value: boolean);
begin
  if csDesigning in ComponentState then
  begin
    FActive := Value;
  end else
  if csReading in ComponentState then
  begin
    InternalActive := Value;
  end else
  if FActive <> Value then
  begin
    FActive := Value;
    if Value then
    begin
      Load( lsLock);
      if PcNr = '' then
        Save(SysParam.PcNr) else
        UnLock;
      WsActive := (PcNr = '') or (PcNr = SysParam.PcNr);
    end else
    begin
      WsActive := false;
    end;
  end;
end;

procedure TWaShare.Connect( Value: boolean);
(* Freigeben/Sperren für Aufrufe vor Zugriff auf Waage oder für manuelle Pause *)
begin
  if FWsActive <> Value then
  begin
    if Value then
    begin
      WaitForActive;
    end else
    begin
      WsActive := false;
      Load( lsLock);
      if PcNr = SysParam.PcNr then
        Save( '') else
        UnLock;
    end;
  end;
end;

procedure TWaShare.SetWsActive( Value: boolean);
begin
  FWsActive := Value;
  if (FActive or not Value) and (ComProt <> nil) then
    ComProt.Active := Value;
end;

procedure TWaShare.SetCntr( Value: integer);
begin
  if FCntr <> Value then
  begin
    Changed := true;
    FCntr := Value;
  end;
end;

procedure TWaShare.Load( Modus: TLockState);
const
  Tmp: integer = 0;
begin
  if TblWsha <> nil then
  try
    TblWsha.Close;
    TblWsha.Open;
    Screen.Cursor := crDefault;
    if TblWSha.EOF then
    begin
      EError('Steuerdatensatz für Waagensharing fehlt(%s)',[Name]);
      {TblWsha.Insert;
      TblWsha.FieldByName('Nr').AsInteger := ComProt.Tag + 1;
      TblWsha.FieldByName('PcNr').AsString := SysParam.PcNr;
      TblWsha.FieldByName('Cntr').AsInteger := 1;
      GNavigator.DoBeforePost( TblWsha);
      TblWsha.Post;}
    end;
    if Modus = lsLock then
      TblWsha.Edit;
    PcNr := TblWsha.FieldByName('PcNr').AsString;
    Cntr := TblWsha.FieldByName('Cntr').AsInteger;
  except on E:Exception do begin
      EProt(self, E, 'Load', [0]);
      if EisBdeFreeDiskError(E) then //$2503 - Zu wenig Festplattenspeicher
        FillDiskBde(TempDir);
      PcNr := '';
      Cntr := 0;
    end;
  end;
  if Debug then
  begin
    Inc(Tmp);
    SMess('%d:Tag(%d)Pc(%s)Cn(%d)We[%s]',[Tmp,Tag,PcNr,Cntr,SysParam.PcNr]);
  end;
end;

procedure TWaShare.UnLock;
begin
  Changed := false;
  if TblWsha <> nil then
  try
    TblWSha.Cancel;
  except
  end;
end;

procedure TWaShare.Save( APcNr: string);
begin
  if TblWsha <> nil then
  try
    Cntr := Cntr + 1;
    Changed := false;
    TblWsha.FieldByName('PcNr').AsString := APcNr;
    TblWsha.FieldByName('Cntr').AsInteger := Cntr;
    GNavigator.DoBeforePost( TblWsha);
    TblWsha.Post;
    TblWsha.Close;
  except on E:Exception do
    begin
      ProtL('%s'+CRLF+'WaShare.Save(%s)',[E.Message, APcNr]);
      TblWsha.Close;
    end;
  end;
end;

procedure TWaShare.Wait;
begin
  if TblWsha <> nil then
  begin
    //OldCntr := Cntr;
    {DlgAbort := CreateAbortDlg('Warte auf Antwort von anderem PC');
    while (OldCntr = Cntr) and not DlgAbort.Canceled do
      GNavigator.ProcessMessages;
    DlgAbort.Release;}
  end;
end;

procedure TWaShare.Answer;
begin
  if (PcNr <> SysParam.PcNr) and (PcNr <> '') then
  begin
    WsActive := false;
    Save( PcNr);
  end else
  begin
    if PcNr = '' then
      Save( SysParam.PcNr) else
      UnLock;
    WsActive := true;
  end;
end;

procedure TWaShare.Poll( Sender: TObject);
begin
  if OldPollInterval <> FPollInterval then
  begin
    OldPollInterval := FPollInterval;
    PollKmp.SetPeriod(Poll, self, FPollInterval);
  end;
  if not FActive then
    Exit;
  Load( lsNoLock);
  if Changed then
  begin
    Load( lsLock);
    Answer;
  end;
end;

procedure TWaShare.WaitForActive;
(* für Aufruf vor Gewicht holen u.ä. *)
begin
  if not WsActive then
    while true do
    begin
      Load( lsLock);
      if Changed then
      begin
        Answer;
        continue;
      end else
      if PcNr <> SysParam.PcNr then
      begin
        Save( SysParam.PcNr);
        Wait;                 {auf Antwort von anderem PC}
        continue;
      end else
      begin
        UnLock;
        WsActive := true;
        break;
      end;
    end;
end;

end.
