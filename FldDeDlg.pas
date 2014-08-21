unit Flddedlg;
(*
22.06.01 MD Delphi5 OK (size nicht übernehmen)
01.07.01 MD BDE Cache entfernen
*)
interface

uses
  ComCtrls,
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, TabNotBk, Mask, DBCtrls, DB,  Uni, DBAccess, MemDS, ExtCtrls,
  Grids, Outline, SysUtils,
  Qwf_Form, Menus;

type
  (* TDlgErr Dialogbox *)
  TDlgFldDesc = class(TqForm)
    Panel1: TPanel;
    BtnClose: TBitBtn;
    BtnLoad: TBitBtn;
    Outline1: TOutline;
    BtnSave: TBitBtn;
    BtnDelete: TBitBtn;
    PopupMenu1: TPopupMenu;
    MiCopy: TMenuItem;
    PanBdeFreeDisk: TPanel;
    LaBdeFreeDisk: TLabel;
    BtnBdeFreeDisk: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure Outline1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MiCopyClick(Sender: TObject);
    procedure BtnBdeFreeDiskClick(Sender: TObject);
  private
    { Private declarations }
    LaBdeFreeDiskCaption: string;
  public
    { Public declarations }
    procedure LoadFromDesc;
  end;

const
{$ifdef WIN32}
  // XE2 ohne ft Präfix
  FieldTypeStr: array[TFieldType] of string =
    ('Unknown','String','Smallint','Integer','Word',
     'Boolean','Float','Currency','BCD','Date','Time','DateTime',
     'Bytes','VarBytes','AutoInc','Blob','Memo','Graphic','FmtMemo',
     'ParadoxOle','DBaseOle','TypedBinary','Cursor','FixedChar','WideString',
     'Largeint','ADT','Array','Reference','DataSet','OraBlob','OraClob',
     'Variant','Interface','IDispatch','Guid','TimeStamp', 'FMTBcd',
     'FixedWideChar', 'WideMemo', 'OraTimeStamp','OraInterval',
     'LongWord', 'Shortint', 'Byte', 'Extended', 'Connection','Params', 'Stream',
     'TimeStampOffset', 'Object', 'Single');

{XE2:
  TFieldType = (ftUnknown, ftString, ftSmallint, ftInteger, ftWord, // 0..4
    ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate, ftTime, ftDateTime, // 5..11
    ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo, // 12..18
    ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar, ftWideString, // 19..24
    ftLargeint, ftADT, ftArray, ftReference, ftDataSet, ftOraBlob, ftOraClob, // 25..31
    ftVariant, ftInterface, ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd, // 32..37
    ftFixedWideChar, ftWideMemo, ftOraTimeStamp, ftOraInterval, // 38..41
    ftLongWord, ftShortint, ftByte, ftExtended, ftConnection, ftParams, ftStream, //42..48
    ftTimeStampOffset, ftObject, ftSingle); //49..51
}

{TFieldType = ({ftUnknown, ftString, ftSmallint, ftInteger, ftWord, ftBoolean,
    ftFloat, ftCurrency, ftBCD, ftDate, ftTime, ftDateTime, ftBytes,
    ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftParadoxOle,
    ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar, ftWideString, ftLargeint,
    ftADT, ftArray, ftReference, ftDataSet, ftOraBlob, ftOraClob, ftVariant,
    ftInterface, ftIDispatch, ftGuid
    * neu ab Delphi 2010: *
    ftTimeStamp, ftFMTBcd, ftFixedWideChar, ftWideMemo, ftOraTimeStamp,
    ftOraInterval, ftLongWord, ftShortint, ftByte, ftExtended, ftConnection,
    ftParams, ftStream, ftTimeStampOffset, ftObject, ftSingle)}

{$else}
  FieldTypeStr: array[TFieldType] of string[8] =
    ('Unknown','String','Smallint','Integer','Word','Boolean',
     'Float','Currency','BCD','Date','Time','DateTime','Bytes',
     'VarBytes','Blob','Memo','Graphic');
{$endif}
  RequiredStr: array[boolean] of string[8] =
    ('','not null');

  procedure FieldDescSaveToIni;
  procedure FieldDescLoadFromIni;
  procedure FieldDescDelete;

implementation
{$R *.DFM}
uses
  GNav_Kmp, FldDsKmp, Ini__Kmp, Err__Kmp, Prots, HtmlClp, DPos_Kmp;
const
  SSection = 'FieldDesc';

procedure BdeCacheDelete;
begin
  {BDE-Cache entfernen, z.B. in c:\temp}
end;


procedure FieldDescDelete;
begin
  Prot0('Feldbeschreibung wird gelöscht',[0]);
  FldDsc.Clear;          {bis 030401: ClearObjects;}
  IniKmp.EraseSection(SSection);
end;

procedure FieldDescSaveToIni;
var
  I, J: integer;
  S: string;
  P: PChar;
  MemStream: TMemoryStream;
  AFieldDefs: TFieldDefs;
  AFieldDef: TFieldDef;
begin
  with FldDsc do
  begin
    for I := 0 to Count-1 do
    begin
      MemStream := TMemoryStream.Create;          {realisiert dynamischen PChar}
      try
        AFieldDefs := TFieldDefs(Objects[I]);
        S := IntToStr(AFieldDefs.Count) + ',';
        MemStream.WriteBuffer(S[1], length(S));
        for J := 0 to AFieldDefs.Count-1 do
        begin
          AFieldDef := AFieldDefs.Items[J];
          S := IntToStr(Ord(AFieldDef.DataType)) + ',';
          MemStream.WriteBuffer(S[1], length(S));
          S := IntToStr(AFieldDef.FieldNo) + ',';
          MemStream.WriteBuffer(S[1], length(S));
          S := AFieldDef.Name + ',';
          MemStream.WriteBuffer(S[1], length(S));
          S := IntToStr(Ord(AFieldDef.Required)) + ',';
          MemStream.WriteBuffer(S[1], length(S));
          if J < AFieldDefs.Count-1 then
            S := IntToStr(AFieldDef.Size) + ',' else
            S := IntToStr(AFieldDef.Size) + #0;        {Ende}
          MemStream.WriteBuffer(S[1], length(S));
        end;
        P := MemStream.Memory;                      {unser dynamischer PChar}
        IniKmp.WriteStr(SSection, Strings[I], P);
      finally
        MemStream.Free;
      end;
    end;
  end;
end;

procedure FieldDescLoadFromIni;
var
  DescList: TStringList;
  DescName: string;
  I, J, K, Index: integer;
  Buff, P: PChar;
  S: string;
  ACount: integer;
  AFieldDefs: TFieldDefs;
  AFieldDef: TFieldDef;
  ADataType: TFieldType;
  AFieldNo: integer;
  AName: string;
  ARequired: boolean;
  //ASize: integer;  //nur erlaubt bei Blob-Felder
  NextStr: PChar;
const
  BuffSize = 20000;     {reicht für mehr als 500 Felder}
begin
  DescList := TStringList.Create;
  Buff := StrAlloc(BuffSize);
  ADataType := ftString;
  AFieldNo := 0;
  ARequired := false;
  try
    IniKmp.ReadSection(SSection, DescList);
    for I := 0 to DescList.Count - 1 do
    try
      DescName := DescList.Strings[I];
      IniKmp.ReadStr(SSection, DescName, '0', Buff, BuffSize);
      P := StrTok(Buff, ', ', NextStr);
      if P = nil then EError('%s:Rechte Seite fehlt',[DescName]);
      ACount := StrToInt(StrPas(P));
      AFieldDefs := TFieldDefs.Create(nil);
      for J := 0 to ACount - 1 do
      begin
        for K := 1 to 5 do
        begin
          P := StrTok(nil, ', ', NextStr);
          if P = nil then EError('%s:Datenfehler J=%d/%d K=%d',
            [DescName, J, ACount, K]);
          S := StrPas(P);
          case K of
            1: ADataType := TFieldType(StrToInt(S));
            2: AFieldNo := StrToInt(S);
            3: AName := S;
            4: ARequired := Boolean(StrToInt(S));
            5: //ASize := StrToInt(S);    //nur erlaubt bei Blob-Felder
          end;
        end;
        {AFieldDef := TFieldDef.Create(AFieldDefs, AName, ADataType, ASize,
          ARequired, AFieldNo);
        ab D5;}
        AFieldDef := AFieldDefs.AddFieldDef;
        with AFieldDef do
        begin
          DataType := ADataType;
          FieldNo := AFieldNo;
          Name := AName;
          Required := ARequired;
          (*Precision
          try
            Size := ASize;          {nur erlaubt bei Blob-Felder}
            ProtA('OK Size(%s:%d)', [AName, ASize]);
          except on E:Exception do
            //EProt(FldDsc, E, 'Size(%s)', [AName]);
          end;*)
        end;
      end; {for J}
      Index := FldDsc.IndexOf(DescName);
      if Index >= 0 then
        FldDsc.DeleteObjects(Index);
      FldDsc.AddObject(DescName, AFieldDefs);
    except on E:Exception do
      EProt(FldDsc, E, 'FieldDescLoadFromIni(%s)', [AName]);
    end; {for I}
  finally
    StrDispose(Buff);
    DescList.Free;
  end;
end;

procedure TDlgFldDesc.LoadFromDesc;
(* FieldDesc --> OutLine *)
var
  I, J: integer;
  AFieldDefs: TFieldDefs;
  AFieldDef: TFieldDef;
  function DataTypeStr(AFieldType: TFieldType; ASize: integer): string;
  begin
    if ASize = 0 then
      result := FieldTypeStr[AFieldType] else
      result := FieldTypeStr[AFieldType] + '(' + IntToStr(ASize) + ')';
  end;
begin
  OutLine1.BeginUpdate;
  OutLine1.Lines.Clear;
  with FldDsc do
  try
    for I := 0 to Count-1 do
    begin
      AFieldDefs := TFieldDefs(Objects[I]);
      if AFieldDefs = nil then
      begin
        OutLine1.Lines.Add(Strings[I] + ' (0)');
      end else
      begin
        OutLine1.Lines.Add(Strings[I] + ' (' + IntToStr(AFieldDefs.Count) + ')');
        for J := 0 to AFieldDefs.Count-1 do
        begin
          AFieldDef := AFieldDefs.Items[J];
          OutLine1.Lines.Add(Format(' %-19s %-11.11s %s',
            [AFieldDef.Name, DataTypeStr(AFieldDef.DataType, AFieldDef.Size),
             RequiredStr[AFieldDef.Required]]));
        end;
      end;
    end;
  finally
    OutLine1.EndUpdate;
  end;
end;

procedure TDlgFldDesc.FormCreate(Sender: TObject);
var
  N: Int64;
begin
  {Sizeable := true;   (nicht nötig da Showmodal}
  LoadFromDesc;

  N := DiskFreeBde(copy(TempDir, 1, 2) + '\');
  if N < 100 * 1024*1024 then
  begin
    LaBdeFreeDiskCaption := LaBdeFreeDisk.Caption;
    LaBdeFreeDisk.Caption := Format(LaBdeFreeDiskCaption, [N / (1024*1024)]);
    PanBdeFreeDisk.Visible := true;
  end;
end;

procedure TDlgFldDesc.BtnBdeFreeDiskClick(Sender: TObject);
var
  N: Int64;
begin
  BtnBdeFreeDisk.Enabled := false;
  FillDiskBde(TempDir);
  N := DiskFreeBde(copy(TempDir, 1, 2) + '\');
  LaBdeFreeDisk.Caption := Format(LaBdeFreeDiskCaption, [N / (1024*1024)]);
end;

procedure TDlgFldDesc.BtnSaveClick(Sender: TObject);
begin
  FieldDescSaveToIni;
end;

procedure TDlgFldDesc.BtnLoadClick(Sender: TObject);
begin
  FieldDescLoadFromIni;
  LoadFromDesc;
end;

procedure TDlgFldDesc.BtnDeleteClick(Sender: TObject);
begin
  if WMessYesNo('Wollen Sie wirklich alle Beschreibungen löschen ?',[0])
    = mrYes then
  begin
    FieldDescDelete;
    OutLine1.Lines.Clear;
  end;
end;

procedure TDlgFldDesc.Outline1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) then
  begin
  end;
end;

procedure TDlgFldDesc.MiCopyClick(Sender: TObject);
begin
  CopyTxt(Outline1.Lines.Text);
end;

end.
