unit ASWSFrm;
(* TMB
   23.01.06 MD  Erstellt
   SQVA
   02.12.06 MD  Modifiziert. todo:in TMB nachtragen
                Loaded-Werte behalten
*)
{ TODO : Fehler: erkennt hinzugefügte Werte nicht (ErlAktion) }
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  Luedikmp, Lubtnkmp, Gen__Kmp, Asws_Kmp, Zeitdlg, Qedi_kmp, TgridKmp, Xls,
  Dialogs, DPos_Kmp, DatumDlg, MuSiControlFr, qSplitter,
  MemDS, DBAccess, Uni, UQue_Kmp;

type
  TFrmASWS = class(TqForm)
    Query1: TuQuery;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    PsDflt: TPrnSource;
    TabControl: TTabControl;
    PageControl: TPageControl;
    tsMulti: TTabSheet;
    Mu1: TMultiGrid;
    Panel2: TPanel;
    tsSingle: TTabSheet;
    DetailControl: TPageControl;
    tsAllgemein: TTabSheet;
    tsSystem: TTabSheet;
    Panel1: TPanel;
    cobFltr: TComboBox;
    btnFltr: TSpeedButton;
    GbStatisitk: TGroupBox;
    gbIntern: TGroupBox;
    qSplitter1: TqSplitter;
    Label20: TLabel;
    GroupBox1: TGroupBox;
    Label29: TLabel;
    Label31: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    EdERFASST_VON: TDBEdit;
    EdERFASST_AM: TDBEdit;
    EdGEAENDERT_VON: TDBEdit;
    EdGEAENDERT_AM: TDBEdit;
    EdANZAHL_AENDERUNGEN: TDBEdit;
    edID: TDBEdit;
    edASW_NAME: TLookUpEdit;
    LuASWS: TLookUpDef;
    TblASWS: TuQuery;
    MuASWS: TMultiGrid;
    genITEM_POS: TGenerator;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cobFltrChange(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure btnFltrClick(Sender: TObject);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure TblASWSBeforePost(DataSet: TDataSet);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure NavBeforeDelete(ADataSet: TDataSet; var Done: Boolean);
    procedure NavPoll(Sender: TObject);
  protected
  private
    { Private-Deklarationen }
    DeleteMarkedFlag: boolean;
  public
    { Public-Deklarationen }
    class procedure DataInit;
  end;

var
  FrmASWS: TFrmASWS;

implementation
{$R *.DFM}
uses
  GNav_Kmp, Prots, NLnk_Kmp, Ini__Kmp, Err__Kmp, UDB__Kmp,
  FltrFrm, ParaFrm, MainFrm;

class procedure TFrmASWS.DataInit;
var
  AswHandle: integer;
  AAsw: TAsw;
  ADatabase: TuDataBase;
  AQuery: TuQuery;
  ATblName: string;
  AList: TStringList;
  I1, I2, ItemPos: integer;
  AswName: string;
  AItemList: TValueList;
  ItemValue, ItemDisplay: string;
begin
  AswHandle := Asws.FirstAsw(aAsw);
  AList := nil;
  AQuery := nil;
  if AswHandle > 0 then
  try
    AList := TStringList.Create;
    ADataBase := QueryDatabase(IniKmp.ReadString('ASWS', 'DatabaseName', 'DB1'));
    AQuery := TuQuery.Create(ADataBase);
    try
      AQuery.RequestLive := true;
      ATblName := GetStringsString(GNavigator.TableSynonyms, 'ASWS', 'ASWS');
      AQuery.Sql.Add('select * from ' + ATblName);
      AQuery.Sql.Add('order by ASW_NAME,ITEM_POS');
      AQuery.Open;
      //von Datenbank einlesen:
      while not AQuery.EOF do
      begin
        AswName := AQuery.FieldByName('ASW_NAME').AsString;
        I1 := AList.IndexOf(AswName);
        if I1 < 0 then
        begin
          AItemList := TValueList.Create;
          AList.AddObject(AswName, AItemList);
        end else
        begin
          AItemList := TValueList(AList.Objects[I1]);
        end;
        AItemList.Values[AQuery.FieldByName('ITEM_VALUE').AsString] :=
          AQuery.FieldByName('ITEM_DISPLAY').AsString;
        AQuery.Next;
      end;

      //alle Asw Komponenten durchlaufen:
      while AswHandle > 0 do
      begin
        AswName := aAsw.AswName;
        I1 := AList.IndexOf(AswName);
        if I1 < 0 then
        begin  //nicht in Db
          AItemList := TValueList.Create;
          AList.AddObject(AswName, AItemList);
        end else
        begin
          AItemList := TValueList(AList.Objects[I1]);
        end;
        //Schleife über die LoadedItems einer Asw
        //In DB einfügen wenn dort fehlt
        //Display von DB wenn dort vorhanden
        for I2 := 0 to aAsw.LoadedItems.Count - 1 do
        begin
          ItemValue := StrParam(aAsw.LoadedItems[I2]);  //Linke Seite vom '='
          ItemPos := AItemList.ValueIndex(ItemValue, @ItemDisplay);
          if ItemPos < 0 then
          try  //nicht in DB
            ItemPos := AItemList.Add(ItemValue + '=' + ItemDisplay);
            ItemDisplay := StrValue(aAsw.LoadedItems[I2]);  //Rechte Seite vom '='
            AQuery.Insert;
            AQuery.FieldByName('ASW_NAME').AsString := AswName;
            AQuery.FieldByName('ITEM_POS').AsString := IntToStr(1 + ItemPos);
            AQuery.FieldByName('ITEM_VALUE').AsString := ItemValue;
            AQuery.FieldByName('ITEM_DISPLAY').AsString := ItemDisplay;
            try
              GNavigator.DoBeforePost(AQuery);  //erfasst_am usw.
            except on E:Exception do
              EProt(AQuery, E, 'Init %s', [AswName]);
            end;
            Prot0('ASWS insert(%s,%s=%s)', [AswName, ItemValue, ItemDisplay]);
            AQuery.Post;
          except on E:Exception do begin
              EProt(aAsw, E, 'Fehler bei ASWS Insert', [0]);
              AQuery.Cancel;
            end;
          end else
          begin
            aAsw.Items.Values[ItemValue] := ItemDisplay;  //von AItemList
          end;
        end;
        //nächste Asw:
        AswHandle := Asws.NextAsw(AswHandle, aAsw);
      end;
    except on E:Exception do
      EProt(AQuery, E, 'Fehler bei TFrmASWS.Init', [0]);
    end;
  finally
    FreeObjects(AList);
    AQuery.Free;
  end;
end;

procedure TFrmASWS.FormCreate(Sender: TObject);
begin
  FrmASWS := self;
  FrmPara.OnFormCreate(self);            {Enabled=false, bgIntern.Visible=false}
  Nav.Navlink.EnabledButtons := Nav.Navlink.EnabledButtons + [qnbDelete];
end;

procedure TFrmASWS.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);            {Bemerkung Größe}
end;

procedure TFrmASWS.FormDestroy(Sender: TObject);
begin
  FrmASWS := nil;
end;

procedure TFrmASWS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmASWS.cobFltrChange(Sender: TObject);
begin
  TFrmFltr.cobFltrChange(Sender);
end;

procedure TFrmASWS.NavStart(Sender: TObject);
begin
  TFrmFltr.cobFltrInit(cobFltr);
end;

procedure TFrmASWS.btnFltrClick(Sender: TObject);
begin
  TSpeedButton(Sender).Down := false;
  TFrmFltr.LookUp(Kurz, Nav.NavLink);
end;

procedure TFrmASWS.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := not (Nav.nlState in nlEditStates);
end;

{ Anwendung }

procedure TFrmASWS.TblASWSBeforePost(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if FieldByName('ITEM_POS').IsNull then
      GenITEM_POS.NewNumber(true); 
  end;
end;

procedure TFrmASWS.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  TFrmASWS.DataInit;
end;

procedure TFrmASWS.NavBeforeDelete(ADataSet: TDataSet; var Done: Boolean);
begin
  if not Nav.Navlink.InBeforeDelete then
    Exit;  //Markierte Start
  Done := true;
  if Nav.Navlink.InDoDeleteMarked then
  begin
    LuASWS.DeleteAll;
    DeleteMarkedFlag := true;
  end else
  if WMessYesNo('Wollen Sie den Originalzustand wiederherstellen?', [0]) = mrYes then
  begin
    //Nav.DataPos.Text := 'ASW_NAME=' + Query1.FieldByName('ASW_NAME').AsString;
    LuASWS.DeleteAll;
    TFrmASWS.DataInit;
    Nav.Navlink.ReLoad;
  end;
end;

procedure TFrmASWS.NavPoll(Sender: TObject);
begin
  if DeleteMarkedFlag and not Nav.Navlink.InDoDeleteMarked then
  begin
    DeleteMarkedFlag := false;
    TFrmASWS.DataInit;
  end;
end;

end.
