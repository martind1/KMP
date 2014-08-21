unit WRep_Kmp;
(* Report to Word
13.06.11 md  UNI, uTable
31.01.14 md  InOnFillData nach private
*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB,  Uni, DBAccess, MemDS,
  DPos_Kmp, NLnk_Kmp, UTbl_Kmp, UDS__Kmp;

type
  TWRepFillDataEvent = procedure(Sender: TObject; First: boolean;
    var EndOfData, Done: boolean) of object;

  TWRep = class(TuTable)
  private
    { Private-Deklarationen }
    FDataSource: TuDataSource;               {Datenquelle}
    FColumnList: TValueList;                {Beschreibung der Table Fields}
    FFileName: TFileName;                   {.DOC}
    FKurz: string;
    FOnFillData: TWRepFillDataEvent;
    InOnFillData: boolean;
    procedure SetColumnList(Value: TValueList);
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
    procedure DoFillData(First: boolean; var EndOfData: boolean);
  public
    { Public-Deklarationen }
    NavLink: TNavLink;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Run;
    procedure RewriteTable;
    procedure FillTable;
    procedure StartWord;
  published
    { Published-Deklarationen }
    property DataSource: TuDataSource read FDataSource write FDataSource;
    property ColumnList: TValueList read FColumnList write SetColumnList;
    property FileName: TFileName read FFileName write FFileName;
    property OnFillData: TWRepFillDataEvent read FOnFillData write FOnFillData;
  end;

implementation

uses
  Prots, Qwf_Form, GNav_Kmp, Ini__Kmp, AbortDlg, Err__Kmp;

procedure TWRep.SetColumnList(Value: TValueList);
begin
  FColumnList.Assign(Value);
end;

constructor TWRep.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColumnList := TValueList.Create;
end;

destructor TWRep.Destroy;
begin
  FColumnList.Free;
  if not (csDesigning in ComponentState) then
  begin
    IniKmp.WriteString(FKurz, 'WREP.TableName', TableName);
    IniKmp.WriteString(FKurz, 'WREP.FileName', FileName);
  end;
  inherited Destroy;
end;

procedure TWRep.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
  begin
    FKurz := TqForm(Owner).Kurz;
    TableName := IniKmp.ReadString(FKurz, 'WREP.TableName', TableName);
    FileName := IniKmp.ReadString(FKurz, 'WREP.FileName', FileName);
  end;
end;

procedure TWRep.Run;
begin
  try
    DisableControls;
    RewriteTable;
    FillTable;
    StartWord;
  finally
    EnableControls;
  end;
end;

procedure TWRep.StartWord;
begin
  ShellExecNoWait(FFileName, SW_SHOWNORMAL);
end;

procedure TWRep.RewriteTable;
var
  I: integer;
  //AFieldDef: TFieldDef;
  AField: TField;
  S1, S2, NextS: string;
begin
  try
    if Active then
      Close;
    EmptyTable;
  except
    if WMessYesNo('Tabelle (%s) nicht vorhanden.' + CRLF + 'Neu erstellen ?',
      [TableName]) = mrYes then
    begin
      FieldDefs.Clear;
      for I := 0 to FColumnList.Count - 1 do
      begin
        S2 := FColumnList.Value(I);
        //AFieldDef := FDataSource.DataSet.FieldDefs.Find(S2);
        AField := FDataSource.DataSet.FieldByName(S2);
        S1 := PStrTok(FColumnList.Param(I), ':', NextS);
        //case AFieldDef.DataType of
        case AField.DataType of
          ftDate, ftTime, ftDateTime:
            FieldDefs.Add(S1, ftString, Length(DateToStrY2(Date)), false);
        else
          //FieldDefs.Add(S1, AFieldDef.DataType, AFieldDef.Size, false);
          FieldDefs.Add(S1, AField.DataType, AField.Size, false);
        end;
      end;
      CreateTable;
    end else
      raise;
  end;
  Open;
end;

procedure TWRep.FillTable;
var
  EndOfData, First: boolean;
begin
  try
    if not Active then
      Open;
    TDlgAbort.CreateDlg(Format('Erzeuge "%s.%s"', [DataBaseName, TableName]));
    try
      EndOfData := false;
      First := true;
      GMess0;
      while not EndOfData and not GNavigator.Canceled do
      try
        Insert;
        DoFillData(First, EndOfData);
        First := false;
        if EndOfData then
          Cancel else
          Post;
      finally
        if State in dsEditModes then
          Cancel;
      end;
    finally
      TDlgAbort.FreeDlg;
    end;
  except on E:Exception do
    EMess(self, E, 'Fehler beim Füllen der Exporttabelle', [0]);
  end;
end;

procedure TWRep.DoFillData(First: boolean; var EndOfData: boolean);
var
  Done: boolean;
  I: integer;
  S1, S2, NextS: string;
begin
  Done := false;
  if Assigned(OnFillData) and not InOnFillData then
  try
    InOnFillData := true;
    OnFillData(self, First, EndOfData, Done);
  finally
    InOnFillData := false;
  end;
  if not Done then
  begin
    if First then
    begin
      NavLink := DsGetNavLink(FDataSource);
      if NavLink.EditState = nlInsert then
        NavLink.DataSet.Close;
      NavLink.DataSet.Open;
      NavLink.DataSet.First;
    end else
      NavLink.DataSet.Next;
    EndOfData := NavLink.DataSet.EOF;
    if not EndOfData then
    begin
      for I := 0 to FColumnList.Count - 1 do
      begin
        S2 := FColumnList.Value(I);
        S1 := PStrTok(FColumnList.Param(I), ':', NextS);
        AssignField(FieldByName(S1), NavLink.DataSet.FieldByName(S2));
      end;
    end;
  end;
end;

end.
