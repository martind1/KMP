unit AbortDlg;
(* Abbruch Dialog
   31.11.98    Änderung bei Aufruf:
                 Ende mit FreeAbortDlg
                 DlgAbort nicht mehr sichtbar
                 CancelBtn bewirkt Release
                 FreeAbortDlg kann immer aufgerufen werden
   10.06.99 MD SetBtnCaption
               SetBtnOnClick
*)
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Gauges, ExtCtrls;

type
  TDlgAbort = class(TForm)
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    LaStatus: TLabel;
    Gauge1: TGauge;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    BtnOnClick: TNotifyEvent;
    StartTime, LastTime: longint;
    TimeRest, Time100: longint;
    LaStatusCaption: string;
    procedure SetProgress(Prozent: integer);
  public
    { Public declarations }
    fCanceled: boolean;
    class procedure SetPosition(aLeft, aTop: integer);
    class procedure CreateDlg(AText: string);              {Anzeigen}
    class procedure FreeDlg;                               {Wegblenden}
    class procedure SetText(AText: string);                {Text ändern}
    class procedure SetCaption(ACaption: string);          {Titel ändern}
    class procedure SetBtnCaption(ACaption: string);       {Button ändern}
    class procedure SetBtnOnClick(AOnClick: TNotifyEvent);     {auf Click reagieren}
    class procedure GMessA(Anteil, Gesamt: longint);       {Gauge anzeigen}
    class procedure GMess(AProgress: integer);
    class procedure Cancel(Sender: TObject);
    class function Canceled: boolean;
    class function Running: boolean;
  end;

  (* Kompatibilität: *)
  procedure CreateAbortDlg( AText: string);              {Anzeigen}
  procedure FreeAbortDlg;                                {Wegblenden}

implementation
{$R *.DFM}
uses
  SysUtils, System.Types,
  Prots, GNav_Kmp, Err__Kmp;
var
  DlgAbort: TDlgAbort;                 {nur Intern !   - FreeAbortDlg verwenden}
  ManPosition: boolean;
  DlgPosition: TPoint;

procedure CreateAbortDlg( AText: string);
begin
  TDlgAbort.CreateDlg(AText);
  if GNavigator <> nil then
    GNavigator.ProcessMessages else
    Application.ProcessMessages;
end;

procedure FreeAbortDlg;
begin
  TDlgAbort.FreeDlg;
end;

class procedure TDlgAbort.CreateDlg(AText: string);              {Anzeigen}
begin
  if DlgAbort = nil then
    DlgAbort := TDlgAbort.Create( Application);
  DlgAbort.Caption := Application.Title;
  DlgAbort.Label1.Caption := AText;
  DlgAbort.fCanceled := false;
  if GNavigator <> nil then
    GNavigator.Canceled := false;
  DlgAbort.Show;
  if GNavigator <> nil then
    GNavigator.ProcessMessages else
    Application.ProcessMessages;
  Prot0('%s - AbortDlg', [AText]);
end;

class procedure TDlgAbort.FreeDlg;                               {Wegblenden}
begin
  if (DlgAbort <> nil) and not (csDestroying in DlgAbort.ComponentState) then
  begin
    Prot0('%s - FreeDlg', [DlgAbort.Caption]);
    DlgAbort.Release;
    //DMess0;  06.06.05 warum?
    GMess0;
  end;
  if GNavigator <> nil then
    GNavigator.ProcessMessages else
    Application.ProcessMessages;
end;

class procedure TDlgAbort.SetText(AText: string);                {Text ändern}
begin
  if DlgAbort <> nil then
    DlgAbort.Label1.Caption := AText else
    SMess('%s', [AText]);
    //ProtL('%s', [AText]);   vor 25.01.04 (GEN#GSIMPORT.Import)
  if GNavigator <> nil then
    GNavigator.ProcessMessages else
    Application.ProcessMessages;
end;

class procedure TDlgAbort.SetCaption(ACaption: string);          {Titel ändern}
begin
  if DlgAbort <> nil then
  begin
    DlgAbort.Caption := ACaption;
  end;
  if GNavigator <> nil then
    GNavigator.ProcessMessages else
    Application.ProcessMessages;
end;

class procedure TDlgAbort.GMessA(Anteil, Gesamt: longint);
var
  S1: string;
begin
  if DlgAbort <> nil then
  begin
    if Gesamt = 0 then
      DlgAbort.SetProgress(Anteil mod 100) else
      DlgAbort.SetProgress(MulDiv(Anteil, 100, Gesamt));   {Anteil*100/Gesamt:Prozent}
    S1 := LongCaption(DlgAbort.Label1.Caption, Format('%d/%d', [Anteil, Gesamt]));
    if DlgAbort.Label1.Caption <> S1 then
    begin
      DlgAbort.Label1.Caption := S1;
      DlgAbort.Label1.Update;
    end;
  end else
    Prots.GMessA(Anteil, Gesamt);
  if GNavigator <> nil then
    GNavigator.ProcessMessages else
    Application.ProcessMessages;
end;

class procedure TDlgAbort.GMess(AProgress: integer);
begin
  if DlgAbort <> nil then
  begin
    DlgAbort.Gauge1.Progress := AProgress;
    DlgAbort.Gauge1.Visible := true;
  end;
  if GNavigator <> nil then
    GNavigator.ProcessMessages else
    Application.ProcessMessages;
end;

class procedure TDlgAbort.SetBtnCaption(ACaption: string);
begin {Button ändern}
  if DlgAbort <> nil then
  begin
    DlgAbort.CancelBtn.Caption := ACaption;
    DlgAbort.CancelBtn.Width := DlgAbort.Canvas.TextWidth(ACaption) + 16;
  end;
end;

class procedure TDlgAbort.SetBtnOnClick(AOnClick: TNotifyEvent);
begin  {auf Click reagieren}
  if DlgAbort <> nil then
  begin
    DlgAbort.BtnOnClick := AOnClick;
  end;
end;

class procedure TDlgAbort.Cancel(Sender: TObject);
begin
  if DlgAbort <> nil then
    DlgAbort.CancelBtnClick(Sender);
end;

class function TDlgAbort.Canceled: boolean;
begin
  if GNavigator <> nil then
    GNavigator.ProcessMessages else
    Application.ProcessMessages;
  if DlgAbort <> nil then
    result := DlgAbort.fCanceled else             {170500 GEN}
  if GNavigator <> nil then
    result := GNavigator.Canceled else
    result := false;
end;

class function TDlgAbort.Running: boolean;
begin
  result := DlgAbort <> nil;
end;

class procedure TDlgAbort.SetPosition(aLeft, aTop: integer);
//Position des Fensters definieren. (-1, -1) = Screen.Center
begin
  ManPosition := (aLeft >=0) and (aTop >= 0);
  DlgPosition := Point(aLeft, aTop);
end;

procedure TDlgAbort.FormCreate(Sender: TObject);
begin
  DlgAbort := self;
  if DelphiRunning then
  begin
    Position := poDesigned;
    Top := 0;
    Left := Screen.Width - Width;
  end else
  if ManPosition then
  begin
    Position := poDesigned;
    Left := IMin(DlgPosition.X, Screen.Width - Width);
    Top := IMin(DlgPosition.Y, Screen.Height - Height);
  end;
  TicksReset(StartTime);
  LastTime := StartTime;
  Gauge1.Progress := 0;
  if GNavigator <> nil then
  begin
    GNavigator.NoTranslateList.Add(Label1.Caption);
    GNavigator.TranslateForm(self);
  end;
  LaStatusCaption := LaStatus.Caption;
  LaStatus.Caption := '';  //erst nach Translation!
end;

procedure TDlgAbort.FormDestroy(Sender: TObject);
begin
  DlgAbort := nil;
end;

procedure TDlgAbort.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  CancelBtn.Click;
end;

procedure TDlgAbort.SetProgress(Prozent: integer);
var
  DiffTime, T100, TRest, hr, mr, sr, h1, m1, s1: longint;
  Si, Sn: string;
begin
  Gauge1.Visible := true;
  (*if (StartTime = 0) or (Value = 0) then
    TicksReset(StartTime);*)

  DiffTime := TicksDelayed(LastTime);
  if (Gauge1.Progress <> Prozent) or (DiffTime >= 1000) then
  begin
    TicksReset(LastTime);
    if (DiffTime > 0) and (Prozent > 0) then
    begin
      if (Gauge1.Progress <> Prozent) then
      begin
        DiffTime := TicksDelayed(StartTime);
        Time100 := MulDiv(DiffTime, 100, Prozent); {DiffTime / Value * 100}
        TimeRest := MulDiv(Time100, 100 - Prozent, 100); {(DiffTime / Value) * (100 - Value);}
        Gauge1.Progress := Prozent;
        Gauge1.Update;
      end else
        TimeRest := IMax(0, TimeRest - DiffTime);
      T100 := Time100;
      TRest := TimeRest;
      h1 := T100 div 3600000;
      T100 := T100 - h1 * 3600000;
      m1 := T100 div 60000;
      T100 := T100 - m1 * 60000;
      s1 := T100 div 1000;

      hr := TRest div 3600000;
      TRest := TRest - hr * 3600000;
      mr := TRest div 60000;
      TRest := TRest - mr * 60000;
      sr := TRest div 1000;
      {LaStatus.Caption := Format('noch %d:%02.2d:%02.2d  von %d:%02.2d:%02.2d',
        [hr, mr, sr,  h1, m1, s1]);}
      {LaStatus.Caption := Format('%d:%02.2d:%02.2d / %d:%02.2d:%02.2d',
        [hr, mr, sr,  h1, m1, s1]);}
      Si := Format('%d:%02.2d:%02.2d', [hr, mr, sr]);
      Sn := Format('%d:%02.2d:%02.2d', [h1, m1, s1]);
      // 'Dauer %s Gesamt %s',
      LaStatus.Caption := Format(LaStatusCaption, [Si, Sn]);
    end;
  end;
end;

procedure TDlgAbort.CancelBtnClick(Sender: TObject);
begin
  fCanceled := true;
  if GNavigator <> nil then
    if Sender <> GNavigator then
      GNavigator.Canceled := true;
  LaStatus.Caption := 'Abgebrochen';
  Release;
  if assigned(BtnOnClick) then
  try
    BtnOnClick(Sender);
  except on E:Exception do
    EProt(self, E, 'Cancel(%s)', [Label1.Caption]);
  end;
end;

(* Beispiel für Anwendung:

procedure TFrmTest.BtnTestClick(Sender: TObject);
var
  I: integer;
  procedure DoIt;
  begin
    Nav.NavLink.AssignValue('TEST', 'NeuerWert');
    Nav.NavLink.Commit;
  end;
begin
  with Query1, TButton(Sender), Mu1 do
  try
    DisableControls;
    TDlgAbort.CreateDlg(Caption);
    Open;
    First;
    if SelectedRows.Count > 0 then
    begin                             //markierte Zeilen
      for I := 0 to SelectedRows.Count - 1 do
      begin
        TDlgAbort.GMessA(I, SelectedRows.Count);
        Bookmark := SelectedRows[I];
        DoIt;
      end;
    end else
    begin                             //alle ausgewählte
      I := 0;
      while not EOF and not TDlgAbort.Canceled do
      begin
        Inc(I);
        TDlgAbort.GMessA(I, Nav.NavLink.RecordCount);
        DoIt;
        Next;
      end;
    end;
  finally
    TDlgAbort.FreeDlg;
    EnableControls;
  end;
end;
*)

begin
  ManPosition := false;
end.
