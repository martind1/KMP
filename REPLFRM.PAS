unit ReplFrm;

interface

uses
{$ifdef WIN32}
  ComCtrls,
{$else}
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Uni, DBAccess, MemDS, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  Luedikmp, Asws_Kmp;

type
  TFrmRepl = class(TqForm)
    Query1: TuQuery;
    PageBook: TqNoteBook;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Label2: TLabel;
    EdREPL_ID: TDBEdit;
    DetailBook: TTabbedNotebook;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EditERFASST_VON: TDBEdit;
    EditERFASST_AM: TDBEdit;
    EditGEAENDERT_VON: TDBEdit;
    EditGEAENDERT_AM: TDBEdit;
    EditANZAHL_AENDERUNGEN: TDBEdit;
    ScrollBox2: TScrollBox;
    Mu1: TMultiGrid;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    LTabSet1: TLTabSet;
    PrnSource1: TPrnSource;
    Label1: TLabel;
    Label12: TLabel;
    cobOP: TAswComboBox;
    Label4: TLabel;
    DBEdit1: TDBEdit;
    EdPKEY: TLookUpMemo;
    EdBEMERKUNG: TDBMemo;
    Label3: TLabel;
    BtnReplDB: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnReplDBClick(Sender: TObject);
  protected
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmRepl: TFrmRepl;

implementation

{$R *.DFM}

uses
  Dialogs,
  GNav_Kmp, Prots,
  MainFrm;

procedure TFrmRepl.FormCreate(Sender: TObject);
begin
  FrmRepl := self;
end;

procedure TFrmRepl.FormDestroy(Sender: TObject);
begin
  FrmRepl := nil;
end;

procedure TFrmRepl.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmRepl.BtnReplDBClick(Sender: TObject);
var
  TableNames: TStringList;
  ATable: TuTable;
  AField: TField;
  I, J: integer;
  IndexFields: string;
begin
  TableNames := TStringlist.Create;
  ATable := TuTable.Create(nil);
  ATable.DataBaseName := Query1.DatabaseName;
  ATable.SessionName := QueryDatabase(Query1).SessionName;
  try
    Session.GetTableNames( Query1.DataBaseName, '', false, false, TableNames);
    for I:= 0 to TableNames.Count-1 do
    begin
      ATable.TableName := TableNames.Strings[I];
      ATable.Open;
      IndexFields := '';
      {ProtL('%s:',[ATable.TableName]);}
      for J := 0 to ATable.FieldCount-1 do
      begin
        AField := ATable.Fields[J];
        if AField.IsIndexField then
        begin
          {ProtL('%s:%s',[ATable.TableName,AField.FieldName]);}
          if IndexFields = '' then
            IndexFields := AField.FieldName else
            IndexFields := IndexFields + ';' + AField.FieldName;
        end;
      end;
      while not ATable.EOF do
      begin
        {Repl.Ins( ATableName, ATable);}
      end;
      ATable.Close;
    end;
  finally
    ATable.Free;
    TableNames.Free;
  end;
end;

end.
