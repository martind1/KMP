unit Beinfrm;
(* Beladeeinrichtungen verwalten + globale Funktionen zum Laden.
   14.08.03 MD erstmal innerhalb Werk nachschlagen. Wenn nicht gef. dann global.
   ??.??.03 MD nbOptions mit Hilfetexten zur jedem Modulcode im Formular
   19.01.04 MD verallgemeinert in \kmp\qw für QUPE; TFrmBein.Caption
   25.11.11 md  Eichnummer im Gerät verwalten: GenProtNr()
   06.07.12 md  leist_max

-------------------------
für alte DBs: CalcList: LEIST_MAX=float:2

*)

interface

uses
  ComCtrls,
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Mask, ExtCtrls,
  Grids, DBGrids, TabNotBk, Tabs, DBLookup, Dialogs,
  LNav_Kmp, GNav_Kmp, LuDefKmp, LuEdiKmp, Buttons, Qwf_Form,
  Btnp_kmp, Mugrikmp, Lubtnkmp, PSrc_Kmp, Asws_Kmp, Tools, MemDS, DBAccess, Uni,
  UQue_Kmp, qSplitter, MuSiFr;

const
  SGenProtNr = 'GenProtNr';  //in Options. Für Genereierung der Eichnr

type
  TFrmBein = class(TqForm)
    Panel2: TPanel;
    PageBook: TqNoteBook;
    ScrollBox2: TScrollBox;
    Mu1: TMultiGrid;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Label2: TLabel;
    Label5: TLabel;
    EditBEIN_NR: TDBEdit;
    EditBEIN_NAME: TDBEdit;
    BtnMulti: TqBtnMuSi;
    BtnSingle: TqBtnMuSi;
    LuWerk: TLookUpDef;
    LeWERK_NR: TLookUpEdit;
    LTabSet1: TLTabSet;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    LubWerk: TLookUpBtn;
    EditWERK_NAME: TDBEdit;
    PsDflt: TPrnSource;
    Panel3: TPanel;
    chbWerk: TCheckBox;
    Panel4: TPanel;
    Query1: TuQuery;
    BtnArbeitsblatt: TBitBtn;
    TblWerk: TuQuery;
    TblCfWerk: TuQuery;
    LuSILO: TLookUpDef;
    TblSILO: TuQuery;
    Detailbook: TPageControl;
    tsEtc: TTabSheet;
    tsSILO: TTabSheet;
    tsSystem: TTabSheet;
    FrSILO: TFrMuSi;
    Label1: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    EditBEIN_ID: TDBEdit;
    EditERFASST_VON: TDBEdit;
    EditERFASST_AM: TDBEdit;
    EditGEAENDERT_VON: TDBEdit;
    EditGEAENDERT_AM: TDBEdit;
    EditANZAHL_AENDERUNGEN: TDBEdit;
    LeWERK_ID: TLookUpEdit;
    GroupBox2: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    BtnInstall: TBitBtn;
    EdWerkAlt: TEdit;
    EdWerkNeu: TEdit;
    BtnModulStarten: TBitBtn;
    Panel7: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    EditPARAM: TDBEdit;
    cobTRANSPORTART: TAswComboBox;
    cobMODULCODE: TAswComboBox;
    cobVERPACKART: TAswComboBox;
    AswCheckBox1: TAswCheckBox;
    edLEIST_MAX: TLookUpEdit;
    Panel5: TPanel;
    qSplitter1: TqSplitter;
    Panel6: TPanel;
    Label4: TLabel;
    Label14: TLabel;
    EdBEM: TDBMemo;
    nbOptions: TNotebook;
    Memo47: TMemo;
    MeGAW: TMemo;
    Memo48: TMemo;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    Memo6: TMemo;
    Memo7: TMemo;
    Memo8: TMemo;
    Memo10: TMemo;
    Memo11: TMemo;
    Memo12: TMemo;
    Memo13: TMemo;
    Memo14: TMemo;
    Memo15: TMemo;
    Memo16: TMemo;
    Memo17: TMemo;
    Memo19: TMemo;
    Memo20: TMemo;
    Memo21: TMemo;
    Memo22: TMemo;
    Memo23: TMemo;
    Memo24: TMemo;
    Memo25: TMemo;
    Memo26: TMemo;
    Memo27: TMemo;
    Memo28: TMemo;
    Memo30: TMemo;
    Memo31: TMemo;
    Memo32: TMemo;
    Memo33: TMemo;
    Memo34: TMemo;
    Memo35: TMemo;
    Memo36: TMemo;
    Memo37: TMemo;
    Memo38: TMemo;
    Memo39: TMemo;
    Memo40: TMemo;
    Memo41: TMemo;
    Memo42: TMemo;
    Memo43: TMemo;
    Memo44: TMemo;
    Memo45: TMemo;
    Memo46: TMemo;
    Memo9: TMemo;
    Memo18: TMemo;
    Memo29: TMemo;
    Memo49: TMemo;
    Memo50: TMemo;
    MeVorgabe: TMemo;
    Memo51: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NavGet(DataSet: TDataset);
    procedure chbWerkClick(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure NavPageChange(PageIndex: Integer);
    procedure BtnInstallClick(Sender: TObject);
    procedure PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cobMODULCODEChange(Sender: TObject);
    procedure LDataSource1DataChange(Sender: TObject; Field: TField);
    procedure NavSetTitel(Sender: TObject; var Titel, Titel2: TCaption);
    procedure BtnModulStartenClick(Sender: TObject);
    procedure BtnArbeitsblattClick(Sender: TObject);
    procedure cobMODULCODEDropDown(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
  private
    { Private-Deklarationen }
    MODULCODEItems: TStringList;
  public
    { Public-Deklarationen }
    class procedure SetCaption(aCaption: string);
    class function GenProtNr(ADevice: TDevice): integer;
  end;

  function StartDevice(DeviceNr: string): TDevice;
  function CreateDevice(DeviceNr: string): TDevice;
  procedure DestroyDevice(var ADevice: TDevice);

var
  FrmBein: TFrmBein;

implementation
{$R *.DFM}
uses
  DPos_Kmp, Prots, CPro_Kmp, Err__Kmp,
  FaWa_Kmp {SProtNr},
{ TODO : in QuvaE aktivieren }
//  ArbeitsblattFrm,
  MainFrm, WerkFrm, Parafrm;
const
  FormCaption: string = '';
  piSilos = 1;

{ Initialisierungs Funktionen }

function StartDevice(DeviceNr: string): TDevice;
begin
  result := CreateDevice(DeviceNr);
  if (result <> nil) and (result.Text.Values['NoStart'] <> '1') then
  try
    {Damit das Formular nicht gleich sichtbar ist, muß Form.Enabled=false sein}
    result.Form := GNavigator.StartFormData(Application, result.ModulCode, result);
    if result.Form = nil then
      Sysutils.Abort;
    result.Form.Caption := result.Name;
    result.Device := FindClassComponent(result.Form, TComProt) as TComProt;
  except
    result.Free;
    result := nil;
  end;
end;

procedure OpenDeviceQuery(AQuery: TuQuery; Updateable: boolean;
  DeviceNr, Werknr: string);
begin
  try
    AQuery.Close;
    AQuery.RequestLive := Updateable;
    AQuery.SessionName := 'Default';
    AQuery.DataBaseName := GNavigator.DB1.DataBaseName;
    AQuery.SessionName := GNavigator.DB1.SessionName;
    AQuery.SQL.Add('select * from BEIN where BEIN_NR=:BEIN_NR and ' +
                   'SO_WERK_NR=:WERK_NR');
    AQuery.Params[0].DataType := ftString;
    AQuery.Params[0].AsString := DeviceNr;
    AQuery.Params[1].DataType := ftString;
    AQuery.Params[1].AsString := WerkNr;  //SysParam.WerkNr
    AQuery.Open;
  except on E:Exception do
    EMess(AQuery, E, 'Fehler bei Gerät %s.%s laden', [DeviceNr, Sysparam.WerkNr]);
  end;
  if AQuery.EOF then
  begin  //werksübergreifend
    try
      AQuery.Close;
      AQuery.RequestLive := Updateable;
      AQuery.SQL.Clear;
      AQuery.SQL.Add('select * from BEIN where BEIN_NR=:BEIN_NR');
      AQuery.Params[0].DataType := ftString;
      AQuery.Params[0].AsString := DeviceNr;
      AQuery.Open;
    except on E:Exception do
      EMess(AQuery, E, 'Fehler bei Gerät %s.* laden', [DeviceNr]);
    end;
  end;
end;

function CreateDevice(DeviceNr: string): TDevice;
var
  AQuery: TuQuery;
begin
  result := nil;
  if DeviceNr <> '' then
  begin
    AQuery := TuQuery.Create(GNavigator.DB1);
    try
      OpenDeviceQuery(AQuery, false, DeviceNr, SysParam.Werknr);
      if not AQuery.EOF then
      try
        result := TDevice.Create(DeviceNr);
        result.Name := AQuery.FieldByName('BEIN_NAME').AsString;
        result.Params := AQuery.FieldByName('PARAM').AsString;
        result.ModulCode := AQuery.FieldByName('MODULCODE').AsString;
        if AQuery.FindField('TRANSPORTART') <> nil then
          result.Transportart := FieldAsChar(AQuery.FieldByName('TRANSPORTART'));
        if AQuery.FindField('VERPACKART') <> nil then
          result.Verpackart := FieldAsChar(AQuery.FieldByName('VERPACKART'));
        GetFieldStrings(AQuery.FieldByName('BEMERKUNG'), result.Text);
        if AQuery.FindField('BEIN_ID') <> nil then
          result.ID := AQuery.FieldByName('BEIN_ID').AsInteger;
      except
        result.Free;
        result := nil;
      end;
    finally
      AQuery.Free;
    end;
  end;
end;

class function TFrmBein.GenProtNr(ADevice: TDevice): integer;
//Ergibt neue Eichnummer ab 100000
//in Device.Text.Values['ProtNr']
var
  AQuery: TuQuery;
  ProtNr: integer;
begin
  Result := 0;
  if ADevice = nil then
    Exit;
  Result := 1 + StrToIntTol(ADevice.Text.Values[SProtNr]);
  AQuery := TuQuery.Create(GNavigator.DB1);
  try
    OpenDeviceQuery(AQuery, true, ADevice.Nr, SysParam.Werknr);
    if not AQuery.EOF then
    try
      AQuery.Edit;
      ProtNr := GetMemoInteger(AQuery.FieldByName('BEMERKUNG'), SProtNr, 0);
      if ProtNr = 0 then
        ProtNr := 100000 else
        ProtNr := ProtNr  + 1;
      SetMemoString(AQuery.FieldByName('BEMERKUNG'), SProtNr, IntToStr(ProtNr));
      AQuery.Post;
      Result := ProtNr;
    except on E:Exception do begin
        EProt(AQuery, E, 'Fehler bei GenProtNr %s', [ADevice.Nr]);
      end;
    end;
  finally
    AQuery.Free;
  end;
  if Result = 0 then
    Result := 100000;
  ADevice.Text.Values[SProtNr] := IntToStr(Result);
  Prot0('GENPROT %s %d', [ADevice.Nr, Result]);
end;

procedure DestroyDevice(var ADevice: TDevice);
(* löscht ADevice und setzt es auf nil *)
begin
  if ADevice <> nil then
  begin
    if ADevice.Device <> nil then
      ADevice.Device.Close;
    if ADevice.Form <> nil then
      ADevice.Form.Release;
    ADevice.Destroy;
    ADevice := nil;
  end;
end;

{ Klassen Funktionen }

class procedure TFrmBein.SetCaption(aCaption: string);
begin
  FormCaption := aCaption;
  if FrmBein <> nil then
    FrmBein.Nav.SetTitel;
end;

{ Standard Funktionen }

procedure TFrmBein.FormCreate(Sender: TObject);
begin
  FrmBein := self;
  FrmPara.OnFormCreate(self);
  MODULCODEItems := nil;
{ TODO : in QuvaE aktivieren }
//  BtnArbeitsblatt.Visible := true;
end;

procedure TFrmBein.FormDestroy(Sender: TObject);
begin
  MODULCODEItems.Free;
  FrmBein := nil;
end;

procedure TFrmBein.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);             {EdBemerkung}
end;

procedure TFrmBein.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmBein.NavSetTitel(Sender: TObject; var Titel,
  Titel2: TCaption);
begin
  Titel := StrDflt(FormCaption, Titel);
end;

procedure TFrmBein.NavStart(Sender: TObject);
begin
  if not Nav.ReturnAktiv then
    chbWerk.Checked := true else
    Query1.Open;
  if Query1.FindField('VERPACKART') <> nil then
    cobVERPACKART.DataField := 'VERPACKART';
end;

procedure TFrmBein.NavPageChange(PageIndex: Integer);
begin
  TblWerk.Active := PageIndex < 10;
  TblSILO.Active := PageIndex = piSilos;
end;

procedure TFrmBein.NavGet(DataSet: TDataset);
begin
(*  with DataSet do
  begin
    if WerkNr <> FieldByName('SO_WERK_NR').AsFloat then
    begin
      WerkNr := FieldByName('SO_WERK_NR').AsFloat;
      TblCfWerk.Close;
      TblCfWerk.ParamByName('WERK_NR').AsFloat := WerkNr;
      TblCfWerk.Open;
      WerkName := TblCfWerk.FieldByName('WERK_NAME').AsString;
      TblCfWerk.Close;
    end;
    FieldByName('BEIN_WERK_NAME').AsString := WerkName;
    {AssignField(FieldByName('cfBEMERKUNG'), FieldByName('BEMERKUNG'));}
  end;
*)  
end;

procedure TFrmBein.chbWerkClick(Sender: TObject);
begin
  {if Nav.nlState in [nlQuery,nlBrowse] then}
  begin
    chbWerk.Caption := 'Werk ' + SysParam.WerkNr;
    Query1.Close;
    try
      if chbWerk.Checked then
        Nav.FltrList.Values['SO_WERK_NR'] := SysParam.WerkNr else
        Nav.FltrList.Values['SO_WERK_NR'] := '';
    finally
      Query1.Open;
    end;
  end;
end;

procedure TFrmBein.BtnInstallClick(Sender: TObject);
begin
  Nav.PageIndex := 0;
  Nav.FltrList.Clear;
  Nav.FltrList.Values['SO_WERK_NR'] := EdWerkAlt.Text;
  Query1.Open;
  while not Query1.EOF do
  begin
    Nav.DoEdit;
    Query1.FieldByName('SO_WERK_NR').AsString := EdWerkNeu.Text;
    Nav.DoPost;
    GNavigator.ProcessMessages;
    Query1.Next;
  end;
end;

procedure TFrmBein.PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
var
  S: string;
begin
  S := Nav.FltrList.Values['SO_WERK_NR'];
  if S <> '' then
  begin
    TblWerk.Open;
    PsDflt.Caption := 'Werk ' + TblWerk.FieldByName('WERK_NAME').AsString;
  end else
    PsDflt.Caption := '';
end;

procedure TFrmBein.Query1BeforeOpen(DataSet: TDataSet);
begin
//  with DataSet do
//  begin
//    if FindField('LEIST_MAX') <> nil then
//    begin
//      edLEIST_MAX.DataField := 'LEIST_MAX';
//    end;
//  end;
end;

procedure TFrmBein.cobMODULCODEChange(Sender: TObject);
begin
  nbOptions.ActivePage := cobMODULCODE.Text;
  if Uppercase(nbOptions.ActivePage) <> Uppercase(cobMODULCODE.Text) then
    nbOptions.PageIndex := 0;
end;

procedure TFrmBein.LDataSource1DataChange(Sender: TObject; Field: TField);
begin
  cobMODULCODEChange(Sender);
end;

procedure TFrmBein.BtnModulStartenClick(Sender: TObject);
begin
  GNavigator.StartFormShow(self, Query1.FieldByName('MODULCODE').AsString);
end;

procedure TFrmBein.BtnArbeitsblattClick(Sender: TObject);
begin
{ TODO : in QuvaE aktivieren }
//  TFrmArbeitsblatt.Execute(Query1.FieldByName('BEIN_NR').AsString, true);
end;

procedure TFrmBein.cobMODULCODEDropDown(Sender: TObject);
var
  I: integer;
begin
  if MODULCODEItems = nil then
  begin
    MODULCODEItems := TStringList.Create;
    MODULCODEItems.Duplicates := dupIgnore;
    MODULCODEItems.Sorted := true;

    //nur die mit AddSysForm hinzufügen
    for I := 0 to GNavigator.FormList.Count - 1 do
      {if TqFormObj(GNavigator.FormList.Objects[I]).NoRechteCheck then }
        MODULCODEItems.Add(GNavigator.FormList[I]);
  end;
  cobMODULCODE.Items.Assign(MODULCODEItems);
end;

end.
