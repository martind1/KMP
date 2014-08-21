unit Row7Sfrm;
(* 23.02.97 Druck wenn Fehler
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DB,  Uni, DBAccess, MemDS,
  Qwf_Form, PSrc_Kmp, Lnav_kmp, ExtCtrls, Cpor_kmp, Prots,
  Spin, CPro_kmp, Menus, Fawa_kmp, Sche_kmp, Row7_kmp,
  ParaFrm;

type
  TStatus = (stRunning,stPause);


  TFrmRow7S = class(TqForm)
    LaGewicht: TLabel;
    ComPort1: TComPort;
    NavRow7: TLNavigator;
    PopupMenu1: TPopupMenu;
    MiAufzeichnung: TMenuItem;
    MiClose: TMenuItem;
    N1: TMenuItem;
    MiNullstellen: TMenuItem;
    Testausdruck1: TMenuItem;
    Row7Kmp1: TRow7Kmp;
    MiTestModus: TMenuItem;
    MiDelSpNr: TMenuItem;
    MiReset: TMenuItem;
    SpinButton1: TSpinButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComPort1Prot(Sender: TObject; ComModus: TComModus;
      Data: PChar; Len: Word);
    procedure MiAufzeichnungClick(Sender: TObject);
    procedure MiCloseClick(Sender: TObject);
    procedure MiNullstellenClick(Sender: TObject);
    procedure Testausdruck1Click(Sender: TObject);
    procedure Row7Kmp1Status(ATelId: Longint; AGewicht: Double;
      AStatus: TFaWaStatus);
    procedure Row7Kmp1ProtGewicht(ATelId: Longint; AGewicht: Double;
      AProtNr: Longint; AStatus: TFaWaStatus);
    procedure Row7Kmp1Nullstellen(ATelId: Longint; AStatus: TFaWaStatus);
    procedure MiTestModusClick(Sender: TObject);
    procedure MiDelSpNrClick(Sender: TObject);
    procedure MiResetClick(Sender: TObject);
    procedure Row7Kmp1Simul(OutData: PChar; OutDataLen: Integer;
      InData: PChar; var InDataLen: Integer);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private-Deklarationen }
    SimGewicht: double;
    SimDelta: double;
    SimWpNr: integer;
    SimSpNr: byte;
    procedure SpinButton1Click(Modus: integer);
    procedure SetText( const Fmt: string; const Args: array of const);
    procedure BCWindowPos( var Message: TWMBroadcast); message BC_WINDOWPOS;
  public
    { Public-Deklarationen }
    InBuff: string;
    ReadBuff, WriteBuff : string;
    OldComModus : TComModus;
    {Gewicht: double; vererbt}
    GewStr, ME: string;
    InPoll : boolean;
    Aktiv : boolean;
    PollId: longint;
    Stopped: boolean;
    procedure Row7Poll( Sender: TObject);
    procedure Stop( StopModus: boolean);
  end;

var
  FrmRow7S: TFrmRow7S;

implementation
{$R *.DFM}
{$I+}
uses
  GNav_Kmp, NStr_Kmp, Poll_Kmp;

procedure TFrmRow7S.BCWindowPos( var Message: TWMBroadcast);
var
  SPt: TPoint;
begin
  inherited;
  SPt := (Message.Sender as TControl).ClientToScreen( Point(0, 0));
  Left := SPt.X;
  Top := SPt.Y;
end;

procedure TFrmRow7S.SetText( const Fmt: string; const Args: array of const);
begin
  LaGewicht.Caption := Format( Fmt, Args);
  LaGewicht.Update;
end;

procedure TFrmRow7S.FormCreate(Sender: TObject);
var
  SPt: TPoint;
begin
  FrmRow7S := self;
  Caption := PrgParam.DeviName;
  if PrgParam.DeviParams <> '' then
    ComPort1.Params := PrgParam.DeviParams;
  if ComPort1.Open then
  begin
    if PollKmp <> nil then
      PollKmp.Add( Row7Poll, NavRow7, 100);
  end else
    ErrWarn('%s:Fehler beim Zugriff auf Serielle Schnittstelle:%s',
            [Caption, ComPort1.GetErrorStr]);
end;

procedure TFrmRow7S.FormActivate(Sender: TObject);
begin
  {if Row7Kmp1.GE = 'kg' then
    SimDelta := 1000 else}
    SimDelta := 100;
end;

procedure TFrmRow7S.FormDestroy(Sender: TObject);
begin
  if FrmRow7S <> nil then
  begin
    ComPort1.Close;
    if PollKmp <> nil then
      PollKmp.Sub( Row7Poll, NavRow7);
    FrmRow7S := nil;
  end;
end;

procedure TFrmRow7S.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FrmPara.InDeviStop then
  begin
    FormDestroy( Sender);
    Action := caFree;
  end else
    Action := caNone;
end;

procedure TFrmRow7S.Stop( StopModus: boolean);
begin
  if StopModus then
  begin
    ComPort1.Close;
    Stopped := true;
    SetText('---',[0]);
  end else
  begin
    ComPort1.Open;
    Stopped := false;
  end;
end;

procedure TFrmRow7S.Row7Poll( Sender: TObject);
begin
  if not Stopped then
  begin
    if (Row7Kmp1.GetTel( PollId) = nil) and
       (Row7Kmp1.GetTel( Row7Kmp1.StatusId) = nil) and
       (Row7Kmp1.GetTel( Row7Kmp1.ProtGewichtId) = nil) and
       (Row7Kmp1.GetTel( Row7Kmp1.NullstellenId) = nil) then
      PollId := Row7Kmp1.HoleStatus;
  end;
end;

procedure TFrmRow7S.ComPort1Prot(Sender: TObject; ComModus: TComModus;
  Data: PChar; Len: Word);
var
  S : string;
begin
  if csDestroying in ComponentState then
    Exit;
  if Aktiv then
  begin
    if OldComModus <> ComModus then
    begin
      OldComModus := ComModus;
      if ComModus = cmRead then
        S := ' I:' else
        S := ' O:';
    end else
      S := '';
    S := S + StrCtrl( StrLPas( Data, Len));
    GNavigator.PanelSMess.Caption := GNavigator.PanelSMess.Caption + S;
    S := GNavigator.PanelSMess.Caption;
    while length( S) > 90 do
      System.Delete( S, 1, 1);
    GNavigator.PanelSMess.Caption := S;
  end;
end;

procedure TFrmRow7S.MiResetClick(Sender: TObject);
begin
  Row7Kmp1.Reset;        {close, open}
end;

procedure TFrmRow7S.MiAufzeichnungClick(Sender: TObject);
begin
  Aktiv := not Aktiv;
  MiAufzeichnung.Checked := Aktiv;
end;

procedure TFrmRow7S.MiTestModusClick(Sender: TObject);
begin
  Row7Kmp1.TestModus := not Row7Kmp1.TestModus;
  MiTestModus.Checked := Row7Kmp1.TestModus;
end;

procedure TFrmRow7S.MiDelSpNrClick(Sender: TObject);
begin
  Row7Kmp1.DelSpNr( -1);
end;

procedure TFrmRow7S.MiCloseClick(Sender: TObject);
begin
  if WindowState = wsMinimized then
  begin
    WindowState := wsNormal;
    Show;
    MiClose.Checked := false;
  end else
  begin
    Close;
    MiClose.Checked := true;
  end;
end;

procedure TFrmRow7S.MiNullstellenClick(Sender: TObject);
begin
  Row7Kmp1.OnNullstellen := Row7Kmp1Nullstellen;
  Row7Kmp1.Nullstellen;
  SimGewicht := 0;
end;

procedure TFrmRow7S.Testausdruck1Click(Sender: TObject);
begin
  Row7Kmp1.OnProtGewicht := Row7Kmp1ProtGewicht;
  Row7Kmp1.ProtGewicht('TESTAUSDRUCK');
end;

(*** Waagenbefehle ******************************************************)

procedure TFrmRow7S.Row7Kmp1Status(ATelId: Longint; AGewicht: Double;
  AStatus: TFaWaStatus);
begin
  PollId := -1;
  if fwsGewichtOK in AStatus then
    LaGewicht.Caption := Row7Kmp1.Display
  else
    LaGewicht.Caption := Row7Kmp1.FaWaStatusStr( AStatus);
end;

procedure TFrmRow7S.Row7Kmp1ProtGewicht(ATelId: Longint; AGewicht: Double;
  AProtNr: Longint; AStatus: TFaWaStatus);
begin
  if not (fwsGewichtOk in AStatus) then
    ErrWarn('Fehler bei Protokolldruck:%s',[Row7Kmp1.FaWaStatusStr( AStatus)])
  else
    LaGewicht.Caption := '<' + Row7Kmp1.Display + '>';
end;

procedure TFrmRow7S.Row7Kmp1Nullstellen(ATelId: Longint;
  AStatus: TFaWaStatus);
begin
  if fwsNull in AStatus then
    ErrWarn('Waage (%s) wurde auf 0 gestellt.',[Caption])
  else
    ErrWarn('Waage (%s): Fehler bei Nullstellen (%s)',
      [Caption, Row7Kmp1.Display]);
end;

procedure TFrmRow7S.Row7Kmp1Simul(OutData: PChar; OutDataLen: Integer;
  InData: PChar; var InDataLen: Integer);
var
  InStr, OutStr: string;
begin
  OutStr := StrLPas( OutData, OutDataLen);
  InStr := '';
  try
    if StrLComp(OutData,'00',2) = 0 then
    begin
      {00wwffqnnnnnbbbbbs}
      InStr := Format('0001000%05.0f%05.0f1',[SimGewicht,SimGewicht]);
    end else
    if StrLComp(OutData,'01',2) = 0 then
    begin
      {01wwffllllllnnnnn}
      Inc( SimWpNr);
      InStr := Format('010100%06.6d%05.0f',[SimWpNr,SimGewicht]);
    end else
    if StrLComp(OutData,'10',2) = 0 then
    begin
      {10wwffsssnnnnn}
      Inc( SimSpNr);
      InStr := Format('100100%03.3d%05.0f',[SimSpNr,SimGewicht]);
    end else
    if StrLComp(OutData,'11',2) = 0 then            {SpNr Del}
    begin
      {11wwff}
      InStr := Format('110100',[0]);
    end else
    begin
      {bbwwff}
      InStr := Format('%s0100',[copy(OutStr, 1, 2)]);
    end;
  finally
    InDataLen := length(InStr);
    StrPCopy( InData, InStr);
  end;
end;

procedure TFrmRow7S.SpinButton1Click(Modus: integer);
begin
  SimGewicht := SimGewicht + Modus * SimDelta;
end;

procedure TFrmRow7S.SpinButton1DownClick(Sender: TObject);
begin
  SpinButton1Click( -1);
end;

procedure TFrmRow7S.SpinButton1UpClick(Sender: TObject);
begin
  SpinButton1Click( 1);
end;


end.


