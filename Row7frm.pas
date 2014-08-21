unit Row7frm;
(* 23.02.97 Druck wenn Fehler
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DB,  Uni, DBAccess, MemDS,
  Qwf_Form, PSrc_Kmp, Lnav_kmp, ExtCtrls, Cpor_kmp, Prots,
  ParaFrm, Spin, CPro_kmp, Menus, Fawa_kmp, Sche_kmp, Row7_kmp;

type
  TStatus = (stRunning,stPause);


  TFrmRow7 = class(TqForm)
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
  private
    { Private-Deklarationen }
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
  FrmRow7: TFrmRow7;

implementation
{$R *.DFM}
{$I+}
uses
  GNav_Kmp, NStr_Kmp, Poll_Kmp;

procedure TFrmRow7.SetText( const Fmt: string; const Args: array of const);
begin
  LaGewicht.Caption := Format( Fmt, Args);
  LaGewicht.Update;
end;

procedure TFrmRow7.BCWindowPos( var Message: TWMBroadcast);
var
  SPt: TPoint;
begin
  inherited;
  SPt := (Message.Sender as TControl).ClientToScreen( Point(0, 0));
  Left := SPt.X;
  Top := SPt.Y;
end;

procedure TFrmRow7.FormCreate(Sender: TObject);
begin
  FrmRow7 := self;
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

procedure TFrmRow7.FormDestroy(Sender: TObject);
begin
  if FrmRow7 <> nil then
  begin
    ComPort1.Close;
    if PollKmp <> nil then
      PollKmp.Sub( Row7Poll, NavRow7);
    FrmRow7 := nil;
  end;
end;

procedure TFrmRow7.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FrmPara.InDeviStop then
  begin
    FormDestroy( Sender);
    Action := caFree;
  end else
    Action := caNone;
end;

procedure TFrmRow7.Stop( StopModus: boolean);
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

procedure TFrmRow7.Row7Poll( Sender: TObject);
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

procedure TFrmRow7.ComPort1Prot(Sender: TObject; ComModus: TComModus;
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

procedure TFrmRow7.MiResetClick(Sender: TObject);
begin
  Row7Kmp1.Reset;        {close, open}
end;

procedure TFrmRow7.MiAufzeichnungClick(Sender: TObject);
begin
  Aktiv := not Aktiv;
  MiAufzeichnung.Checked := Aktiv;
end;

procedure TFrmRow7.MiTestModusClick(Sender: TObject);
begin
  Row7Kmp1.TestModus := not Row7Kmp1.TestModus;
  MiTestModus.Checked := Row7Kmp1.TestModus;
end;

procedure TFrmRow7.MiDelSpNrClick(Sender: TObject);
begin
  Row7Kmp1.DelSpNr( -1);
end;

procedure TFrmRow7.MiCloseClick(Sender: TObject);
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

procedure TFrmRow7.MiNullstellenClick(Sender: TObject);
begin
  Row7Kmp1.OnNullstellen := Row7Kmp1Nullstellen;
  Row7Kmp1.Nullstellen;
  {if Row7Kmp1.Status = cpsOK then
    ErrWarn('Nullstellen OK',[0]) else
    ErrWarn('Fehler bei Nullstellen',[0]);}
end;

procedure TFrmRow7.Testausdruck1Click(Sender: TObject);
begin
  Row7Kmp1.OnProtGewicht := Row7Kmp1ProtGewicht;
  Row7Kmp1.ProtGewicht('TESTAUSDRUCK');
end;

(*** Waagenbefehle ******************************************************)

procedure TFrmRow7.Row7Kmp1Status(ATelId: Longint; AGewicht: Double;
  AStatus: TFaWaStatus);
begin
  PollId := -1;
  if fwsGewichtOK in AStatus then
    LaGewicht.Caption := Row7Kmp1.Display
  else
    LaGewicht.Caption := Row7Kmp1.FaWaStatusStr( AStatus);
end;

procedure TFrmRow7.Row7Kmp1ProtGewicht(ATelId: Longint; AGewicht: Double;
  AProtNr: Longint; AStatus: TFaWaStatus);
begin
  if not (fwsGewichtOk in AStatus) then
    ErrWarn('Fehler bei Protokolldruck:%s',[Row7Kmp1.FaWaStatusStr( AStatus)])
  else
    LaGewicht.Caption := '<' + Row7Kmp1.Display + '>';
end;

procedure TFrmRow7.Row7Kmp1Nullstellen(ATelId: Longint;
  AStatus: TFaWaStatus);
begin
  if fwsNull in AStatus then
    ErrWarn('Waage (%s) wurde auf 0 gestellt.',[Caption])
  else
    ErrWarn('Waage (%s): Fehler bei Nullstellen (%s)',
      [Caption, Row7Kmp1.Display]);
end;

end.


