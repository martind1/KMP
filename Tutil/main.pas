unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, DB, TUtil32, BDE, DBTables;

type

  TBDEUtil = class;
  
  TMainForm = class(TForm)
    ExitBtn: TButton;
    AboutBtn: TButton;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    AliasCombo: TComboBox;
    TableCombo: TComboBox;
    TableLocEdit: TEdit;
    ByDirectBtn: TButton;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    FieldsLB: TLabel;
    RecSizeLB: TLabel;
    IndexLB: TLabel;
    ValidLB: TLabel;
    RefLB: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    RestructLB: TLabel;
    AuxPassLB: TLabel;
    CodePageLB: TLabel;
    BlockSizeLB: TLabel;
    TabLvlLB: TLabel;
    VerifyBtn: TButton;
    RebuildBtn: TButton;
    GroupBox3: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    MessageLB: TLabel;
    PBHeader: TProgressBar;
    PBIndexes: TProgressBar;
    PBData: TProgressBar;
    PBRebuild: TProgressBar;
    OpenDialog1: TOpenDialog;
    Session1: TSession;
    Database1: TuDataBase;
    procedure FormCreate(Sender: TObject);
    procedure AliasComboChange(Sender: TObject);
    procedure ByDirectBtnClick(Sender: TObject);
    procedure TableComboChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure VerifyBtnClick(Sender: TObject);
    procedure RebuildBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
  private
    { Private declarations }
    BDEUtil: TBDEUtil;
    procedure OpenDatabaseList;
    procedure SetTableAndDir(ByDirectory: Boolean);
    procedure ClearBars;
    procedure ClearLabels;
    procedure SetTableInfo;
    procedure ClearTable;
    procedure SetTable(TableName: String);
  public
    { Public declarations }
  end;

  TBDEUtil = class
    CbInfo: TUVerifyCallback;
    TUProps: CURProps;
    hDb: hDBIDb;
    vhTSes: hTUSes;
    constructor Create;
    destructor Destroy; override;
    function GetTCursorProps(szTable: String): Boolean;
    procedure RegisterCallBack;
    procedure UnRegisterCallBack;
  end;

var
  MainForm: TMainForm;

implementation

uses about;

{$R *.DFM}

function GenProgressCallBack(ecbType: CBType; Data: LongInt; pcbInfo: Pointer):
  CBRType; stdcall;
var
  CBInfo: TUVerifyCallBack;
begin
  CBInfo := TUVerifyCallBack(pcbInfo^);
  if ecbType = cbGENPROGRESS then
    case CBInfo.Process of
     TUVerifyHeader: begin
       MainForm.PBHeader.Position := CBInfo.percentdone;
     end;
     TUVerifyIndex: begin
       MainForm.PBIndexes.Position := CBInfo.percentdone;
     end;
     TUVerifyData: begin
       MainForm.PBData.Position := CBInfo.percentdone;
     end;
     TURebuild: begin
       MainForm.PBRebuild.Position := CBInfo.percentdone;
     end;
    end;

  Result := cbrUSEDEF;
end;


constructor TBDEUtil.Create;
begin
  Check(TUInit(vhtSes));
end;

destructor TBDEUtil.Destroy;
begin
  Check(TUExit(vhtSes));
  inherited Destroy;
end;

function TBDEUtil.GetTCursorProps(szTable: String): Boolean;
begin
  if TUFillCURProps(vHtSes, PChar(szTable), TUProps) = DBIERR_NONE then
    Result := True
  else Result := False;
end;

procedure TBDEUtil.RegisterCallback;
begin
 Check(DbiRegisterCallBack(nil, cbGENPROGRESS, 0,
            sizeof(TUVerifyCallBack), @CbInfo, GenProgressCallback));
end;

procedure TBDEUtil.UnRegisterCallback;
begin
  Check(DbiRegisterCallBack(nil, cbGENPROGRESS, 0,
           sizeof(TUVerifyCallBack), @CbInfo, nil));
end;

procedure TMainForm.OpenDataBaseList;
var
  TmpCursor: hDbiCur;
  vDBDesc: DBDesc;
begin
  AliasCombo.Items.Clear;
  Check(DbiOpenDatabaseList(TmpCursor));
  while (DbiGetNextRecord(TmpCursor, dbiNOLOCK, @vDBDesc, nil)
                                      = DBIERR_NONE) do begin
    if vDBDesc.szDBType = 'STANDARD' then
      AliasCombo.Items.Add(vDBDesc.szName);
  end;
  Check(DbiCloseCursor(TmpCursor));
end;

procedure TMainForm.ClearBars;
begin
  MessageLB.Caption := '';
  PBHeader.Position := 0;
  PBIndexes.Position := 0;
  PBData.Position := 0;
  PBRebuild.Position := 0;
end;

procedure TMainForm.ClearLabels;
begin
  FieldsLB.Caption := '0';
  RecSizeLB.Caption := '0';
  IndexLB.Caption := '0';
  ValidLB.Caption := '0';
  RefLB.Caption := '0';
  RestructLB.Caption := '0';
  AuxPassLB.Caption := '0';
  CodePageLB.Caption := '0';
  BlockSizeLB.Caption := '0';
  TabLvlLB.Caption := '0';
end;

procedure TMainForm.ClearTable;
begin
  TableLocEdit.Text := '';
  VerifyBtn.Enabled := False;
  RebuildBtn.Enabled := False;
end;

procedure TMainForm.SetTable(TableName: String);
begin
  TableLocEdit.Text := TableName;
  VerifyBtn.Enabled := True;
  RebuildBtn.Enabled := True;
end;

procedure TMainForm.SetTableAndDir;
var
  vDBDesc: DBDesc;
  Alias: String;
  Table: String;
begin
  Alias := AliasCombo.Items[AliasCombo.ItemIndex];
  Table := TableCombo.Items[TableCombo.ItemIndex];
  Check(DbiGeTuDataBaseDesc(PChar(Alias), @vDBDesc));
  SetTable(Format('%s\%s', [vDBDesc.szPhyName, Table]));
  ClearBars;
  SetTableInfo();
end;

procedure TMainForm.SetTableInfo;
var
  Table: String;
  
begin
  Table := TableLocEdit.Text;
  if BDEUtil.GetTCursorProps(Table) then
  with BDEUtil.TUProps do begin
    FieldsLB.Caption := IntToStr(iFields);
    RecSizeLB.Caption := IntToStr(iRecBufSize);
    IndexLB.Caption := IntToStr(iIndexes);
    ValidLB.Caption := InttoStr(iValChecks);
    RefLB.Caption := IntToStr(iRefIntChecks);
    RestructLB.Caption := IntToStr(iRestrVersion);
    AuxPassLB.Caption := IntToStr(iPasswords);
    CodePageLB.Caption := IntToStr(iCodePage);
    BlockSizeLB.Caption := IntToStr(iBlockSize);
    TabLvlLB.Caption := IntToStr(iTblLevel);
  end;
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  Session1.Active := True;
  OpenDatabaseList;
  BDEUtil := TBDEUtil.Create;
end;

procedure TMainForm.AliasComboChange(Sender: TObject);
begin
//  Database1.Connected := False;
//  Database1.AliasName := AliasCombo.Items[AliasCombo.ItemIndex];
//  DataBase1.Connected := True;
  Session1.GetTableNames(AliasCombo.Items[AliasCombo.ItemIndex], '*.*',
    True, False, TableCombo.Items);
  ClearBars;
  ClearLabels;
  ClearTable;
end;

procedure TMainForm.ByDirectBtnClick(Sender: TObject);
begin
 if OpenDialog1.Execute then begin
   SetTable(OpenDialog1.FileName);
   AliasCombo.ItemIndex := -1;
   TableCombo.Items.Clear;
   ClearBars;
   SetTableInfo;
 end;
end;

procedure TMainForm.TableComboChange(Sender: TObject);
begin
  SetTableAndDir(False);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  BDEUtil.Free;
end;

procedure TMainForm.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.VerifyBtnClick(Sender: TObject);
var
  Msg: Integer;
  Table: String;

begin
  Screen.Cursor := crHourGlass;
  try
    ClearBars;
    Table := TableLocEdit.Text;
    Check(TUExit(BDEUtil.vHtSes));
    Check(TUInit(BDEUtil.vHtSes));
    BDEUtil.RegisterCallBack;
    try
      if TUVerifyTable(BDEUtil.vHtSes, PChar(Table), szPARADOX, 'VERIFY.DB',
           nil, 0, Msg) = DBIERR_NONE then begin
      case Msg of
        0: MessageLB.Caption := 'Verification Successful. Table has no errors.';
        1: MessageLB.Caption := 'Verification Successful. Verification completed.';
        2: MessageLB.Caption := 'Verification Successful. Verification could not be completed.';
        3: MessageLB.Caption := 'Verification Successful. Table must be rebuild manually.';
        4: MessageLB.Caption := 'Verification Successful. Table cannot be rebuilt.';
      else
        MessageLB.Caption := 'Verification unsuccessful.';
      end;
      end;
    finally
      BDEUtil.UnRegisterCallBack;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.RebuildBtnClick(Sender: TObject);
var
  iFld, iIdx, iSec, iVal, iRI, iOptP, iOptD: word;
  szTable: String;
  rslt: DBIResult;
  Msg: Integer;
  TblDesc: CRTBlDesc;
  Backup: String;
begin
  Screen.Cursor := crHourGlass;
  try
    ClearBars;
    Check(TUExit(BDEUtil.vHtSes));
    Check(TUInit(BDEUtil.vHtSes));
    szTable := TableLocEdit.Text;
    BDEUtil.RegisterCallBack;
    try
      Check(TUVerifyTable(BDEUtil.vHtSes, PChar(szTable), szPARADOX, 'VERIFY.DB',
           nil, 0, Msg));
      rslt := TUGetCRTblDescCount(BDEUtil.vhTSes, PChar(szTable), iFld,
            iIdx, iSec, iVal, iRI, iOptP, iOptD);
      if rslt = DBIERR_NONE then begin
        FillChar(TblDesc, SizeOf(CRTBlDesc), 0);
        StrPCopy(TblDesc.szTblName, szTable);
        TblDesc.szTblType := szParadox;
        TblDesc.szErrTblName := 'Rebuild.DB';

        TblDesc.iFldCount := iFld;
        GetMem(TblDesc.pFldDesc, (iFld * SizeOf(FldDesc)));

        TblDesc.iIdxCount := iIdx;
        GetMem(TblDesc.pIdxDesc, (iIdx * SizeOf(IdxDesc)));

        TblDesc.iSecRecCount := iSec;
        GetMem(TblDesc.pSecDesc, (iSec * SizeOf(SecDesc)));

        TblDesc.iValChkCount := iVal;
        GetMem(TblDesc.pvchkDesc, (iVal * SizeOf(VCHKDesc)));

        TblDesc.iRintCount := iRI;
        GetMem(TblDesc.printDesc, (iRI * SizeOf(RINTDesc)));

        TblDesc.iOptParams := iOptP;
        GetMem(TblDesc.pfldOptParams, (iOptP * sizeOf(FLDDesc)));

        GetMem(TblDesc.pOptData, (iOptD * DBIMAXSCFLDLEN));
        try
           rslt := TUFillCRTblDesc(BDEUtil.vhTSes, @TblDesc, PChar(szTable), nil);
           if rslt = DBIERR_NONE then begin
             Backup := 'Backup.Db';
             if TURebuildTable(BDEUtil.vhTSes, PChar(szTable), szPARADOX,
                 PChar(Backup), 'KEYVIOL.DB', 'PROBLEM.DB', @TblDesc) = DBIERR_NONE
             then MessageLB.Caption := 'Rebuild was successful.'
             else MessageLB.Caption := 'Rebuild was not successful.';
           end
           else
             MessageDlg('Error Filling table structure', mtError, [mbok], 0);
        finally
          FreeMem(TblDesc.pFldDesc, (iFld * SizeOf(FldDesc)));
          FreeMem(TblDesc.pIdxDesc, (iIdx * SizeOf(IdxDesc)));
          FreeMem(TblDesc.pSecDesc, (iSec * SizeOf(SecDesc)));
          FreeMem(TblDesc.pvchkDesc, (iVal * SizeOf(VCHKDesc)));
          FreeMem(TblDesc.printDesc, (iRI * SizeOf(RINTDesc)));
          FreeMem(TblDesc.pfldOptParams, (iOptP * sizeOf(FLDDesc)));
          FreeMem(TblDesc.pOptData, (iOptD * DBIMAXSCFLDLEN));
        end;
      end;
    finally
      BDEUtil.UnRegisterCallBack;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

end.
