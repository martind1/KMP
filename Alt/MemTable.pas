unit MemTable;
 
 {$N+,P+,S-}
 
 {.$I RX.INC}
 
 interface
 
 uses SysUtils, Classes, Controls, {$IFDEF WIN32} Bde, {$ELSE} DbiTypes,
   DbiProcs, DbiErrs, {$ENDIF} DB,  Uni, DBAccess, MemDS;
 
 type
 
 { TMemoryTable }
 
   TMemoryTable = class(TuQuery)
   private
     FTableName: TFileName;
     FMoveHandle: HDBICur;
     FEnableDelete: Boolean;
     FDisableEvents: Boolean;
     procedure EncodeFieldDesc(var FieldDesc: FLDDesc;
       const Name: string; DataType: TFieldType; Size: Word);
     procedure SetTableName(const Value: TFileName);
     function SupportedFieldType(AType: TFieldType): Boolean;
     procedure DeleteCurrentRecord;
   protected
     function CreateHandle: HDBICur; override;
     procedure DoAfterClose; override;
     procedure DoAfterOpen; override;
     procedure DoBeforeClose; override;
     procedure DoBeforeDelete; override;
     procedure DoBeforeOpen; override;
 {$IFDEF WIN32}
     function GetRecordCount: {$IFDEF VER90} Longint {$ELSE}
       Integer; override {$ENDIF};
 {$ENDIF}
 {$IFDEF RX_D3}
     function IsSequenced: Boolean; override;
     function GetRecNo: Integer; override;
     procedure SetRecNo(Value: Integer); override;
 {$ELSE}
     function GetRecordNumber: Longint; {$IFDEF VER90} override; {$ENDIF}
     procedure SetRecNo(Value: Longint);
 {$ENDIF}
   public
     constructor Create(AOwner: TComponent); override;
     function BatchMove(ASource: TDataSet; AMode: TBatchMode;
       ARecordCount: Longint): Longint;
     procedure CopyStructure(ASource: TDataSet);
     procedure CreateTable;
     procedure DeleteTable;
     procedure EmptyTable;
     procedure GotoRecord(RecordNo: Longint);
     procedure SetFieldValues(const FieldNames: array of string;
       const Values: array of const);
 {$IFDEF VER90}
     property RecordCount: Longint read GetRecordCount;
 {$ENDIF}
 {$IFNDEF RX_D3}
     property RecNo: Longint read GetRecordNumber write SetRecNo;
 {$ENDIF}
   published
     property EnableDelete: Boolean read FEnableDelete write
 FEnableDelete
       default True;
     property TableName: TFileName read FTableName write SetTableName;
   end;
 
 implementation
 uses
   DBConsts,
{$ifdef WIN32}
   {DBUtils,}
{$endif}
{$IFDEF RX_D3}
   BDEConst, MaxMin,
{$ENDIF}
   Forms,
   Prots;
 
 { Memory tables are created in RAM and deleted when you close them. They
   are much faster and are very useful when you need fast operations on
   small tables. Memory tables do not support certain features (like
   deleting records, referntial integrity, indexes, autoincrement fields
   and BLOBs) }
 
 { TMemoryTable }
 
 constructor TMemoryTable.Create(AOwner: TComponent);
 begin
   inherited Create(AOwner);
   FEnableDelete := True;
 end;
 
 function TMemoryTable.BatchMove(ASource: TDataSet; AMode: TBatchMode;
   ARecordCount: Longint): Longint;
 var
   SourceActive: Boolean;
   MovedCount: Longint;
   procedure AssignRecord(Src, Dst: TDataset; Flag: boolean);
   var I: integer;
   begin
     for I := 0 to Src.FieldCount - 1 do
       SetFieldValue( Dst.Fields[I], Src.Fields[I].AsString);
   end;
 begin
   if (ASource = nil) or (Self = ASource) or
     not (AMode in [batCopy, batAppend]) then
     DBError(SInvalidBatchMove);
   SourceActive := ASource.Active;
   try
     ASource.DisableControls;
     DisableControls;
     ASource.Open;
     ASource.CheckBrowseMode;
     ASource.UpdateCursorPos;
     if AMode = batCopy then begin
       Close;
       CopyStructure(ASource);
     end;
     if not Active then Open;
     CheckBrowseMode;
     if ARecordCount > 0 then begin
       ASource.UpdateCursorPos;
       MovedCount := ARecordCount;
     end
     else begin
       ASource.First;
       MovedCount := MaxLongint;
     end;
     try
       Result := 0;
       while not ASource.EOF do begin
         Append;
         AssignRecord(ASource, Self, True);
         Post;
         Inc(Result);
         if Result >= MovedCount then Break;
         ASource.Next;
       end;
     finally
       Self.First;
     end;
   finally
     if not SourceActive then ASource.Close;
     Self.EnableControls;
     ASource.EnableControls;
   end;
 end;
 
 procedure TMemoryTable.CopyStructure(ASource: TDataSet);
 var
   I: Integer;
 begin
   CheckInactive;
   for I := FieldCount - 1 downto 0 do Fields[I].Free;
   if (ASource = nil) then Exit;
   FieldDefs := ASource.FieldDefs;
   for I := 0 to FieldDefs.Count - 1 do begin
     if SupportedFieldType(FieldDefs.Items[I].DataType) then
       FieldDefs.Items[I].CreateField(Self);
   end;
 end;
 
 procedure TMemoryTable.DeleteCurrentRecord;
 var
   CurRecNo, CurRec: Longint;
   Buffer: Pointer;
   iFldCount: Word;
   FieldDescs: PFLDDesc;
 begin
   CurRecNo := RecNo;
   iFldCount := FieldDefs.Count;
   FieldDescs := AllocMem(iFldCount * SizeOf(FLDDesc));
   try
     Check(DbiGetFieldDescs(Handle, FieldDescs));
     Check(DbiCreateInMemTable(DBHandle, '$InMem$', iFldCount,
 FieldDescs,
       FMoveHandle));
     try
       DisableControls;
       Buffer := AllocMem(RecordSize);
       try
         First;
         CurRec := 0;
         while not Self.EOF do begin
           Inc(CurRec);
           if CurRec <> CurRecNo then begin
             DbiInitRecord(FMoveHandle, Buffer);
             Self.GetCurrentRecord(Buffer);
             Check(DbiAppendRecord(FMoveHandle, Buffer));
           end;
           Self.Next;
         end;
         FDisableEvents := True;
         try
           Close; Open; FMoveHandle := nil;
         finally
           FDisableEvents := False;
         end;
       finally
         FreeMem(Buffer, RecordSize);
       end;
     except
       DbiCloseCursor(FMoveHandle);
       FMoveHandle := nil;
       raise;
     end;
     GotoRecord(CurRecNo - 1);
   finally
     if FieldDescs <> nil then FreeMem(FieldDescs, iFldCount *
 SizeOf(FLDDesc));
     FMoveHandle := nil;
     EnableControls;
   end;
 end;
 
 procedure TMemoryTable.DoBeforeDelete;
 begin
   inherited DoBeforeDelete;
   if EnableDelete then begin
     DeleteCurrentRecord;
     DoAfterDelete;
     SysUtils.Abort;
   end;
 end;
 
 procedure TMemoryTable.DoAfterClose;
 begin
   if not FDisableEvents then inherited DoAfterClose;
 end;
 
 procedure TMemoryTable.DoAfterOpen;
 begin
   if not FDisableEvents then inherited DoAfterOpen;
 end;
 
 procedure TMemoryTable.DoBeforeClose;
 begin
   if not FDisableEvents then inherited DoBeforeClose;
 end;
 
 procedure TMemoryTable.DoBeforeOpen;
 begin
   if not FDisableEvents then inherited DoBeforeOpen;
 end;
 
 function TMemoryTable.SupportedFieldType(AType: TFieldType): Boolean;
 begin
   Result := not (AType in
 {$IFDEF WIN32}
     [ftUnknown, ftBytes, ftVarBytes, ftBlob, ftMemo, ftGraphic,
     ftFmtMemo, ftParadoxOle, ftDBaseOle, ftTypedBinary]);
 {$ELSE}
     [ftUnknown, ftBytes, ftVarBytes, ftBlob, ftMemo, ftGraphic]);
 {$ENDIF}
 end;
 
 function TMemoryTable.CreateHandle: HDBICur;
 var
   I: Integer;
   FieldDescs: PFLDDesc;
   iFldCount: Cardinal;
   szTblName: DBITBLNAME;
 begin
   if (FMoveHandle <> nil) then begin
     Result := FMoveHandle;
     Exit;
   end;
   if FTableName = '' then DBError(SNoTableName);
   if FieldCount > 0 then FieldDefs.Clear;
   if FieldDefs.Count = 0 then
     for I := 0 to FieldCount - 1 do begin
       if not SupportedFieldType(Fields[I].DataType) then
 {$IFDEF RX_D3}
         DatabaseErrorFmt(SFieldUnsupportedType, [Fields[I].FieldName]);
 {$ELSE}
         DBErrorFmt(SFieldUnsupportedType, [Fields[I].FieldName]);
 {$ENDIF}
       with Fields[I] do
         if not (Calculated {$IFDEF WIN32} or Lookup {$ENDIF}) then
           FieldDefs.Add(FieldName, DataType, Size, Required);
     end;
   FieldDescs := nil;
   SetDBFlag(dbfTable, True);
   try
     AnsiToNative(Locale, TableName, szTblName, SizeOf(szTblName) - 1);
     iFldCount := FieldDefs.Count;
     FieldDescs := AllocMem(iFldCount * SizeOf(FLDDesc));
     for I := 0 to FieldDefs.Count - 1 do
       with FieldDefs[I] do begin
         EncodeFieldDesc(PFieldDescList(FieldDescs)^[I], Name,
           DataType, Size);
       end;
     Check(DbiTranslateRecordStructure(nil, iFldCount, FieldDescs, nil,
       nil, FieldDescs {$IFDEF WIN32}, False {$ENDIF}));
     Check(DbiCreateInMemTable(DBHandle, szTblName, iFldCount,
 FieldDescs,
       Result));
   finally
     if FieldDescs <> nil then FreeMem(FieldDescs, iFldCount *
 SizeOf(FLDDesc));
     SetDBFlag(dbfTable, False);
   end;
 end;
 
 procedure TMemoryTable.CreateTable;
 begin
   CheckInactive;
   Open;
 end;
 
 procedure TMemoryTable.DeleteTable;
 begin
   CheckBrowseMode;
   Close;
 end;
 
 procedure TMemoryTable.EmptyTable;
 begin
   if Active then begin
     CheckBrowseMode;
     DisableControls;
     FDisableEvents := True;
     try
       Close;
       Open;
     finally
       FDisableEvents := False;
       EnableControls;
     end;
   end;
 end;
 
procedure TMemoryTable.EncodeFieldDesc(var FieldDesc: FLDDesc;
  const Name: string; DataType: TFieldType; Size: Word);
const
{$ifdef WIN32}
  TypeMap: array[TFieldType] of Byte = (
    fldUNKNOWN, fldZSTRING, fldINT16, fldINT32, fldUINT16, fldBOOL,
    fldFLOAT, fldFLOAT, fldBCD, fldDATE, fldTIME, fldTIMESTAMP, fldBYTES,
    fldVARBYTES, FldFLOAT, fldBLOB, fldBLOB, fldBLOB, FldBLOB, FldBLOB, FldBLOB, FldBLOB);
   {fldUnknown, fldString, fldSmallint, fldInteger, fldWord, fldBoolean, fldFloat,
  fldCurrency, fldBCD, fldDate, fldTime, fldDateTime, fldBytes, fldVarBytes, fldAutoInc,
  fldBlob, fldMemo, fldGraphic, fldFmtMemo, fldParadoxOle, fldDBaseOle, fldTypedBinary);}
{$else}
  TypeMap: array[TFieldType] of Byte = (
    fldUNKNOWN, fldZSTRING, fldINT16, fldINT32, fldUINT16, fldBOOL,
    fldFLOAT, fldFLOAT, fldBCD, fldDATE, fldTIME, fldTIMESTAMP, fldBYTES,
    fldVARBYTES, fldBLOB, fldBLOB, fldBLOB);
{$endif}
begin
  with FieldDesc do
  begin
    AnsiToNative(Locale, Name, szName, SizeOf(szName) - 1);
    iFldType := TypeMap[DataType];
    case DataType of
      ftString, ftWideString, ftBytes, ftVarBytes, ftBlob, ftMemo, ftGraphic:
        iUnits1 := Size;
      ftBCD:
        begin
          iUnits1 := 32;
          iUnits2 := Size;
        end;
    end;
    case DataType of
      ftCurrency:
        iSubType := fldstMONEY;
      ftBlob:
        iSubType := fldstBINARY;
      ftMemo:
        iSubType := fldstMEMO;
      ftGraphic:
        iSubType := fldstGRAPHIC;
    end;
  end;
end;

(* procedure TMemoryTable.EncodeFieldDesc(var FieldDesc: FLDDesc;
   const Name: string; DataType: TFieldType; Size: Word);
 begin
   with FieldDesc do begin
     AnsiToNative(Locale, Name, szName, SizeOf(szName) - 1);
     iFldType := FieldLogicMap(DataType);
     iSubType := FieldSubtypeMap(DataType);
 {$IFDEF WIN32}
     if iSubType = fldstAUTOINC then iSubType := 0;
 {$ENDIF WIN32}
     case DataType of
       ftString, ftBytes, ftVarBytes, ftBlob, ftMemo, ftGraphic
       {$IFDEF WIN32}, ftFmtMemo, ftParadoxOle, ftDBaseOle,
       ftTypedBinary {$ENDIF}:
         iUnits1 := Size;
       ftBCD:
         begin
           iUnits1 := 32;
           iUnits2 := Size;
         end;
     end;
   end;
 end;*)
 
 {$IFDEF WIN32}
 function TMemoryTable.GetRecordCount: {$IFDEF VER90} Longint {$ELSE}
 Integer {$ENDIF};
 begin
   if State = dsInactive then DBError(SDataSetClosed);
   Check(DbiGetRecordCount(Handle, Result));
 end;
 {$ENDIF WIN32}
 
 procedure TMemoryTable.SetRecNo(Value: {$IFDEF RX_D3} Integer {$ELSE}
 Longint {$ENDIF});
 var
   Rslt: DBIResult;
 begin
   CheckBrowseMode;
   UpdateCursorPos;
   Rslt := DbiSetToSeqNo(Handle, Value);
   if Rslt = DBIERR_EOF then Last
   else if Rslt = DBIERR_BOF then First
   else begin
     Check(Rslt);
     Resync([rmExact, rmCenter]);
   end;
 end;
 
 {$IFDEF RX_D3}
 function TMemoryTable.GetRecNo: Integer;
 {$ELSE}
 function TMemoryTable.GetRecordNumber: Longint;
 {$ENDIF}
 var
   Rslt: DBIResult;
 begin
   Result := -1;
   if State in [dsBrowse, dsEdit] then begin
     UpdateCursorPos;
     Rslt := DbiGetSeqNo(Handle, Result);
     if (Rslt = DBIERR_EOF) or (Rslt = DBIERR_BOF) then Exit
     else Check(Rslt);
   end;
 end;
 
 procedure TMemoryTable.GotoRecord(RecordNo: Longint);
 begin
   RecNo := RecordNo;
 end;
 
 {$IFDEF RX_D3}
 function TMemoryTable.IsSequenced: Boolean;
 begin
   Result := not Filtered;
 end;
 {$ENDIF RX_D3}
 
 procedure TMemoryTable.SetFieldValues(const FieldNames: array of string;
   const Values: array of const);
 var
   I: Integer;
   Pos: Longint;
 begin
   Pos := RecNo;
   DisableControls;
   try
     First;
     while not EOF do begin
       Edit;
       for I := 0 to IMax(High(FieldNames), High(Values)) do
         FieldByName(FieldNames[I]).AssignValue(Values[I]);
       Post;
       Next;
     end;
     GotoRecord(Pos);
   finally
     EnableControls;
   end;
 end;
 
 procedure TMemoryTable.SetTableName(const Value: TFileName);
 begin
   CheckInactive;
   FTableName := Value;
   DataEvent(dePropertyChange, 0);
 end;
 
 end.


