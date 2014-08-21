unit ProtFrm;
(* Universelles Protokollfenster

26.08.09 md  Idee an anderes Fenseter andocken. Im Fremdfenster ist im
             OnResize-Ereigniss FrmProt.Dock aufzurufen - nicht implementiert
             Hint: Dock ist bereits als Form-Methode registriert.
23.07.10 md  beim Drucken nicht weiter protokollieren wenn vorher not running             
*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Uni, DBAccess, MemDS, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  Luedikmp, Lubtnkmp, Gen__Kmp, Menus, UCLinePrinter, Dialogs;

type
  TFrmProt = class(TqForm)
    Nav: TLNavigator;
    lbProt: TListBox;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    miAlwaysOnTop: TMenuItem;
    BtnDrucken: TBitBtn;
    UCLinePrinter1: TUCLinePrinter;
    LaStatus: TStaticText;
    PanWeiter: TPanel;
    BtnWeiter: TBitBtn;
    MiDelete: TMenuItem;
    MiSaveAs: TMenuItem;
    N1: TMenuItem;
    MiPrint: TMenuItem;
    SaveDialog1: TSaveDialog;
    PrnSource1: TPrnSource;
    PrintDialog: TPrintDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NavPoll(Sender: TObject);
    procedure miAlwaysOnTopClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure BtnDruckenClick(Sender: TObject);
    procedure NavSetTitel(Sender: TObject; var Titel, Titel2: TCaption);
    procedure BtnWeiterClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MiDeleteClick(Sender: TObject);
    procedure MiSaveAsClick(Sender: TObject);
    procedure PrnSource1BeforePrn(Sender: TObject; var fertig: Boolean);
  protected
  private
    { Private-Deklarationen }
    //Active: boolean;
    InEnde: boolean;
    fRunning: boolean;
    procedure ErrKmpError(Sender: TObject; E: Exception;
      var Done: Boolean);
    function GetRunning: boolean;
    procedure SetRunning(const Value: boolean);
    class procedure InitForm(aWindowState: TWindowState);
  public
    { Public-Deklarationen }
    property Running: boolean read GetRunning write SetRunning;
    procedure ProtDock(AForm: TForm; DockLayout: TButtonLayout); //andocken
    class procedure Load;  //minimized, mit OnError Ereignisbehandlung
    class procedure Show;  //Inhalt nicht löschen
    class procedure Start; //Inhalt löschen
    class procedure StartDock(AForm: TForm; DockLayout: TButtonLayout); //Inhalt löschen und andocken
    class procedure Ende; //Fenster schließen
    class procedure SetProt(const Value: boolean);  //Running setzen
//    class procedure Clear;
//    class procedure Stopp;
//    class procedure Weiter;

  end;

var
  FrmProt: TFrmProt;

implementation

{$R *.DFM}

uses
  GNav_Kmp, Prots, Err__Kmp;

class procedure TFrmProt.InitForm(aWindowState: TWindowState);
begin
  try
    GNavigator.GetFormObj('PROT', false).WindowState := aWindowState;
  except on E:Exception do
    EError('"PROT" kann nicht gestartet werden (GNavigator.AddForm fehlt)'+CRLF+'%s', [E.Message]);
  end;
end;

class procedure TFrmProt.Load;
begin
  TFrmProt.InitForm(wsMinimized);
  GNavigator.StartForm(Application, 'PROT');
end;

class procedure TFrmProt.Show;
begin
  TFrmProt.InitForm(wsNormal);
  GNavigator.StartFormShow(Application, 'PROT');
end;

class procedure TFrmProt.Start;
begin
  TFrmProt.StartDock(nil, blGlyphBottom);
end;

class procedure TFrmProt.StartDock(AForm: TForm; DockLayout: TButtonLayout);
begin
  TFrmProt.InitForm(wsNormal);
  GNavigator.StartForm(Application, 'PROT');
  if AForm <> nil then
    FrmProt.ProtDock(AForm, DockLayout);
end;

class procedure TFrmProt.Ende;
begin
  if FrmPROT <> nil then
  begin
    FrmPROT.InEnde := true;
    FrmPROT.Close;
  end;
end;

class procedure TFrmProt.SetProt(const Value: boolean);
begin
  if FrmPROT <> nil then
    FrmProt.SetRunning(Value);
end;

procedure TFrmProt.FormCreate(Sender: TObject);
begin
  FrmPROT := self;
  Sizeable := true;
  Prot.MaxCount := IMax(1000, Prot.MaxCount);
  Prot.ListBox := lbProt;
  if ErrKmp <> nil then
    ErrKmp.OnError := ErrKmpError;
end;

procedure TFrmProt.FormShow(Sender: TObject);
begin                        {horizontal scrollen}
  SendMessage(lbProt.Handle, LB_SetHorizontalExtent, Screen.Width , 0);
  ActiveControl := Panel1;   //22.01.03
end;

procedure TFrmProt.FormDestroy(Sender: TObject);
begin
  if Prot.ListBox = lbProt then
    Prot.ListBox := nil;
  FrmPROT := nil;
end;

procedure TFrmProt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if InEnde then
    Action := caFree else
    Action := caMinimize; // 14.10.01 caFree;
end;

procedure TFrmProt.NavStart(Sender: TObject);
begin
  lbProt.Items.Clear;    //31.07.02 QUPE.Prob.ImportZL
  ActiveControl := Panel1;
end;

procedure TFrmProt.ErrKmpError(Sender: TObject; E: Exception;
  var Done: Boolean);
begin
  if Running then        //03.01.03 SendIP
  begin
    WindowState := wsNormal;
    BringToFront;
    ActiveControl := laStatus;
  end;
end;

function TFrmProt.GetRunning: boolean;
begin
  //result := ActiveControl <> lbProt;
  result := (Prot.ListBox = lbProt) and (ActiveControl <> lbProt);
            //(ActiveControl <> BtnDrucken);  //23.07.10
end;

procedure TFrmProt.SetRunning(const Value: boolean);
begin
  fRunning := Value;
  SendMessage(self.Handle, BC_LNAVIGATOR, lnavSetTitel, 0);
  try
    if Value then
    begin
      Prot.ListBox := lbProt;
      if ActiveControl = lbProt then
        ActiveControl := nil;
    end else
    begin
      Prot.ListBox := nil;
      if ActiveControl <> lbProt then
        ActiveControl := lbProt;   //somit wird nichts ausgegeben
    end;
  except on E:Exception do
    EProt(self, E, 'SetRunning(%d)', [ord(Value)]);  //falls Focus nicht vorhanden
  end;
end;

procedure TFrmProt.NavPoll(Sender: TObject);
const
  OldRunning: boolean = true;
begin
  Prot.ListBox := lbProt;
  PanWeiter.Visible := not Running;
  LaStatus.Visible := not PanWeiter.Visible;
  if Running then
    ActiveControl := laStatus;
  if OldRunning <> Running then
  begin
    OldRunning := Running;
    SendMessage(self.Handle, BC_LNAVIGATOR, lnavSetTitel, 0);
  end;
end;

procedure TFrmProt.NavSetTitel(Sender: TObject; var Titel,
  Titel2: TCaption);
begin
  if Running then
    Titel2 := 'läuft' else
    Titel2 := 'gestoppt';
end;

procedure TFrmProt.BtnWeiterClick(Sender: TObject);
begin
  Nav.Poll;
end;

procedure TFrmProt.miAlwaysOnTopClick(Sender: TObject);
begin
  miAlwaysOnTop.Checked := not miAlwaysOnTop.Checked;
  if miAlwaysOnTop.Checked then
  begin
    LNavigator.Options := LNavigator.Options - [lnSavePosition];
    FormStyle := fsStayOnTop;
    BorderStyle := bsSizeable;
  end else
  begin
    FormStyle := fsMDIChild;
    BorderStyle := bsSizeable;  //17.02.13 bsDialog;
    LNavigator.Options := LNavigator.Options + [lnSavePosition];
    LoadPosition;
  end;
end;

procedure TFrmProt.BtnDruckenClick(Sender: TObject);
begin
  if not fRunning then
    ActiveControl := lbProt;  //keine Ausgabe
  if PrintDialog.Execute then
  begin
    UCLinePrinter1.PrintTitle := LongCaption(Application.MainForm.Caption, ShortCaption);
    UCLinePrinter1.Font.Assign(lbProt.Font);
    UCLinePrinter1.Lines.Assign(lbProt.Items);
    UCLinePrinter1.Print;
  end;  
end;

procedure TFrmProt.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if miAlwaysOnTop.Checked then
  begin
    miAlwaysOnTopClick(Sender);  //setzt miAlwaysOnTop.Checked := false;
  end else
  begin
//     beware User schließt aber wir minimieren
//     if Prot.ListBox = lbProt then
//       Prot.ListBox := nil;
  end;
end;

procedure TFrmProt.MiDeleteClick(Sender: TObject);
begin
  lbProt.Items.Clear;
end;

procedure TFrmProt.MiSaveAsClick(Sender: TObject);
begin
  with SaveDialog1 do
  begin
    FileName := 'Protokoll.txt';
    InitialDir := TempDir;
    if Execute then
      lbProt.Items.SaveToFile(FileName);
  end;
end;

procedure TFrmProt.PrnSource1BeforePrn(Sender: TObject;
  var fertig: Boolean);
begin
  fertig := true;
  PostMessage(self.Handle, WM_COMMAND, 0, btnDrucken.Handle);
end;

procedure TFrmProt.ProtDock(AForm: TForm; DockLayout: TButtonLayout);
begin
  { TODO : Docking implementieren }
end;

end.
