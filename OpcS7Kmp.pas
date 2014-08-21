unit OpcS7Kmp;
(*
01.02.02 MD Erstellt http://www.opc.dial.pipex.com/delphi.shtml
            Nur eine Standard Group
04.02.02 MD ProgID als Property (QTank)
09.02.02 MD ReadBeforeWrite      (optimiert schreiben: ur bei Differenz)
10.12.02    WriteVar, Status, Meldung
10.01.04 MD ReadWord, WriteWord (S5)
*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  ActiveX, ComObj, OPCtypes, OPCDA, OPCutils,
  DPos_Kmp;

const
  ServerProgID = 'OPC.SimaticNET';
  RPC_C_AUTHN_LEVEL_NONE = 1;
  RPC_C_IMP_LEVEL_IMPERSONATE = 3;
  EOAC_NONE = 0;

type
  TOpcS7 = class(TComponent)
  private
    { Private-Deklarationen }
    FConnection: string;
    FMachineName: string;
    FProgID: string;
    FConnected: boolean;
    FSimul: boolean;
    FReadBeforeWrite: boolean;
    FLbRead: TListBox;
    FLbWrite: TListBox;
    function AddReadItem(VarName: string): integer;
    function AddWriteItem(VarName: string): integer;
    procedure LbReadValue(VarName, aValue: string);
    procedure LbWriteValue(VarName, aValue: string);
  protected
    { Protected-Deklarationen }
    ServerIf: IOPCServer;
    GroupIf: IOPCItemMgt;
    GroupHandle: OPCHANDLE;
    InWrite: boolean;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetStatus(aStatus: integer; aMeldung: string);
  public
    { Public-Deklarationen }
    ReadList: TValueList;
    WriteList: TValueList;
    Status: integer;    //0=OK
    Meldung: string;    //Fehlermeldung
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    procedure RemoveItems;
    function Read(VarName: string; var Value: string): boolean;
    function Write(VarName, Value: string): boolean;

    procedure Sim(DB, Adr: integer; Str: string);

    function ReadVar(VarName: string; Adv: boolean): string; //für nicht-S7 Konvention
    procedure WriteVar(VarName, Value: string);              //für nicht-S7 Konvention

    procedure WriteString(DB, Adr, Count: integer; Str: string);
    procedure WriteDInt(DB, Adr: integer; I: integer);
    procedure WriteInt(DB, Adr: integer; I: integer);
    procedure WriteWord(DB, Adr, I: integer);
    procedure WriteDInts(DB, Adr: integer; Ints: array of integer);
    procedure WriteInts(DB, Adr: integer; Ints: array of integer);
    function ReadString(DB, Adr, Count: integer; Adv: boolean): string;
    function ReadDInt(DB, Adr: integer; Adv: boolean): integer;
    function ReadInt(DB, Adr: integer; Adv: boolean): integer;
    function ReadWord(DB, Adr: integer; Adv: boolean): integer;
  published
    { Published-Deklarationen }
    property Connection: string read FConnection write FConnection;
    property MachineName: string read FMachineName write FMachineName;
    property ProgID: string read FProgID write FProgID;
    property Connected: boolean read FConnected write FConnected;
    property Simul: boolean read FSimul write FSimul;
    property ReadBeforeWrite: boolean read FReadBeforeWrite write FReadBeforeWrite;
    property LbRead: TListBox read FLbRead write FLbRead;
    property LbWrite: TListBox read FLbWrite write FLbWrite;
  end;

implementation

uses
  Prots, Err__Kmp, nstr_kmp;

{ TOpcS7 }

type
  TOpcItem = class(TObject)
    VarName: string;    {ohne Connection}
    Handle: OPCHANDLE;
    VarType: TVarType;
    Value: string;
    Quality: Word;
  end;

constructor TOpcS7.Create(AOwner: TComponent);
var
  HR: HResult;
begin
  inherited Create(AOwner);
  ReadList := TValueList.Create;
  WriteList := TValueList.Create;
  ProgID := ServerProgID;
  // this is for DCOM:
  // without this, callbacks from the server may get blocked, depending on
  // DCOM configuration settings
  HR := CoInitializeSecurity(
    nil,                    // points to security descriptor
    -1,                     // count of entries in asAuthSvc
    nil,                    // array of names to register
    nil,                    // reserved for future use
    RPC_C_AUTHN_LEVEL_NONE, // the default authentication level for proxies
    RPC_C_IMP_LEVEL_IMPERSONATE,// the default impersonation level for proxies
    nil,                    // used only on Windows 2000
    EOAC_NONE,              // additional client or server-side capabilities
    nil                     // reserved for future use
    );
  if Failed(HR) then
  begin
    ProtL('OPC: Failed to initialize DCOM security', [0]);
  end;
end;

destructor TOpcS7.Destroy;
begin
  Disconnect;
  // Delphi runtime library will release all interfaces automatically when
  // variables go out of scope
  ReadList.FreeObjects;
  WriteList.FreeObjects;
  inherited Destroy;
end;

procedure TOpcS7.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if (AComponent = LbRead) then
      LbRead := nil else
    if (AComponent = LbWrite) then
      LbWrite := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TOpcS7.SetStatus(aStatus: integer; aMeldung: string);
begin
  Status := aStatus;
  Meldung := aMeldung;
end;

procedure TOpcS7.LbReadValue(VarName, aValue: string);
begin
  if FLbRead <> nil then
  begin
    FLbRead.Items.Values[VarName] := aValue;
    if aValue = '' then
      FLbRead.Items.Add(VarName + '=');
  end;
end;

procedure TOpcS7.LbWriteValue(VarName, aValue: string);
begin
  if FLbWrite <> nil then
  begin
    FLbWrite.Items.Values[VarName] := aValue;
    if aValue = '' then
      FLbWrite.Items.Add(VarName + '=');
  end;
  if FLbRead <> nil then
  begin
    if FLbRead.Items.Values[VarName] <> '' then
      FLbRead.Items.Values[VarName] := aValue;
  end;
end;

procedure TOpcS7.Connect;
var
  HR: HResult;
  ClassID: TGUID;
  UnknownIF: IUnknown;
  S1: string;
begin
  if Simul then
    FConnected := true else
  if not FConnected then
  begin
    if ServerIF = nil then
    try
      // we will use the custom OPC interfaces, and OPCProxy.dll will handle
      // marshaling for us automatically (if registered)
      ClassId := ProgIDToClassID(ProgID);
      S1 := GUIDToString(ClassId);
      if FMachineName <> '' then
        UnknownIF := CreateRemoteComObject(FMachineName, ClassID)
      else
        UnknownIF := CreateComObject(ClassID);
      ServerIf := UnknownIF as IOPCServer;
    except on E:Exception do
      begin
        ServerIf := nil;
        EError('Unable to connect to OPC server (%s %s): %s', [FMachineName, ProgID, E.Message]);  //FConnection
      end;
    end;
    // now add a group
    S1 := self.Name; //LTrimCh(FConnection, '.'); //war 'Name'
    HR := ServerAddGroup(ServerIf, S1, True, 500, 0, GroupIf, GroupHandle);
    if not Succeeded(HR) then
      EError('Unable to add group (%s) to server:%d', [S1, HR]);
    FConnected := true;
  end;
end;

procedure TOpcS7.Disconnect;
var
  HR: HResult;
begin
  if Simul then
    FConnected := false else
  if FConnected then
  begin
    // now cleanup
    HR := ServerIf.RemoveGroup(GroupHandle, False);
    if not Succeeded(HR) then
      ProtL('Unable to remove group:%d', [HR]);
    FConnected := false;
  end;
end;

procedure TOpcS7.RemoveItems;
//Entfernt items. Für GWT.
var
  I: integer;
begin
  if FConnected then
  try
    if not Simul then
    begin
      for I := 0 to ReadList.Count - 1 do
      try
        Prot0('Remove ReadList[%d] %s', [I, ReadList[I]]);
        GroupRemoveItem(GroupIf, TOpcItem(ReadList.Objects[I]).Handle);
      except on E:Exception do
        EProt(self, E, 'Disconnect', [0]);
      end;
      for I := 0 to WriteList.Count - 1 do
      try
        Prot0('Remove WriteList[%d] %s', [I, WriteList[I]]);
        GroupRemoveItem(GroupIf, TOpcItem(WriteList.Objects[I]).Handle);
      except on E:Exception do
        EProt(self, E, 'Disconnect', [0]);
      end;
    end;
  finally
    ReadList.ClearObjects;
    WriteList.ClearObjects;
    if FLbRead <> nil then
      FLbRead.Items.Clear;
    if FLbWrite <> nil then
      FLbWrite.Items.Clear;
  end;
end;

function TOpcS7.AddReadItem(VarName: string): integer;
var
  HR: HResult;
  ItemName: string;
  ItemHandle: OPCHANDLE;
  ItemType: TVarType;
  OpcItem: TOpcItem;
  ErrorStr: POleStr;
begin
  result := ReadList.ValueIndex(VarName, nil);
  if result >= 0 then
    Exit;
  if Simul then
  begin
    result := ReadList.AddFmt('%s=0', [VarName]);
  end else
  begin
    // now items to the group
    ItemName := Connection + VarName;
    HR := GroupAddItem(GroupIf, ItemName, 0, VT_EMPTY, ItemHandle, ItemType);
    if Succeeded(HR) then
    begin
      result := ReadList.AddFmt('%s=0', [VarName]);
      OpcItem := TOpcItem.Create;
      OpcItem.VarName := VarName;
      OpcItem.Handle := ItemHandle;
      OpcItem.VarType := ItemType;
      ReadList.Objects[result] := OpcItem;
    end else
    begin
      ServerIf.GetErrorString(HR, 0, ErrorStr);
      if ErrorStr <> nil then
        EError('Unable to add item %s to group:%s', [ItemName, ErrorStr]) else
        EError('Unable to add item %s to group:nil', [ItemName]);
    end;
  end;
end;

function TOpcS7.AddWriteItem(VarName: string): integer;
var
  HR: HResult;
  ItemName: string;
  ItemHandle: OPCHANDLE;
  ItemType: TVarType;
  OpcItem: TOpcItem;
  ErrorStr: POleStr;
begin
  result := WriteList.ValueIndex(VarName, nil);
  if result >= 0 then
    Exit;
  if Simul then
  begin
    result := WriteList.AddFmt('%s=0', [VarName]);
  end else
  begin
    // now items to the group
    ItemName := Connection + VarName;
    HR := GroupAddItem(GroupIf, ItemName, 0, VT_EMPTY, ItemHandle, ItemType);
    if Succeeded(HR) then
    begin
      result := WriteList.AddFmt('%s=0', [VarName]);
      OpcItem := TOpcItem.Create;
      OpcItem.VarName := VarName;
      OpcItem.Handle := ItemHandle;
      OpcItem.VarType := ItemType;
      WriteList.Objects[result] := OpcItem;
    end else
    begin
      ServerIf.GetErrorString(HR, 0, ErrorStr);
      EError('Unable to add item %s to group:%s', [ItemName, ErrorStr]);
    end;
  end;
end;

function TOpcS7.Read(VarName: string; var Value: string): boolean;
var
  HR: HResult;
  I: integer;
  ItemQuality: Word;
  OpcItem: TOpcItem;
  ErrorStr: POleStr;
begin
  result := false;
  if Simul then
  begin
    AddReadItem(VarName);
    if FLbRead <> nil then
      Value := FLbRead.Items.Values[VarName] else
      Value := ReadList.Values[VarName];
    LbReadValue(VarName, Value);
    Application.ProcessMessages;
    result := true;
  end else
  try
    Connect;
    I := AddReadItem(VarName);
    OpcItem := TOpcItem(ReadList.Objects[I]);
    HR := ReadOPCGroupItemValue(GroupIf, OpcItem.Handle, Value, ItemQuality);
    OpcItem.Value := Value;
    OpcItem.Quality := ItemQuality;
    ReadList.Values[OpcItem.VarName] := Value;
    if not InWrite then
      LbReadValue(OpcItem.VarName, Value);  {in Read}
    if Succeeded(HR) then
      result := true else
    begin
      ServerIf.GetErrorString(HR, 0, ErrorStr);
      ProtL('Failed to read item %s value synchronously:%s', [VarName, ErrorStr]);
    end;
  except on E:Exception do
    ProtL('Exception at read item %s: %s', [VarName, E.Message]);
  end;
end;

function TOpcS7.Write(VarName, Value: string): boolean;
var
  HR: HResult;
  I: integer;
  ItemValue: OleVariant;
  OpcItem: TOpcItem;
  ErrorStr: POleStr;
  NewValue: string;
  DoIt: boolean;
  OldInWrite: boolean;
begin
  result := false;
  HR := 0;
  if Simul then
  begin
    AddWriteItem(VarName);
    WriteList.Values[VarName] := Value;
    LbWriteValue(VarName, Value);
    Application.ProcessMessages;
    result := true;
  end else
  try
    Connect;
    I := AddWriteItem(VarName);
    OpcItem := TOpcItem(WriteList.Objects[I]);
    ItemValue := Value;
    OldInWrite := InWrite;
    if FReadBeforeWrite then
    try
      InWrite := true;
      Read(VarName, NewValue);
      DoIt := NewValue <> Value;
    finally
      InWrite := OldInWrite;
    end else
      DoIt := true;
    if DoIt then
    begin
      HR := WriteOPCGroupItemValue(GroupIf, OpcItem.Handle, ItemValue)
    end else
      result := true;
    OpcItem.Value := ItemValue;
    WriteList.Values[OpcItem.VarName] := ItemValue;
    if not InWrite then
      LbWriteValue(OpcItem.VarName, ItemValue);
    if DoIt then
    begin
      if Succeeded(HR) then
        Result := true else
      begin
        ServerIf.GetErrorString(HR, 0, ErrorStr);
        ProtL('Failed to write item %s value (%s) synchronously:%s', [VarName, Value, ErrorStr]);
      end;
    end;
  except on E:Exception do
    ProtL('Exception at write item %s value(%s): %s', [VarName, Value, E.Message]);
  end;
end;

(*** SPS Zugriff *************************************************************)

procedure TOpcS7.Sim(DB, Adr: integer; Str: string);
var
  S1, NextS, VarName: string;
  I: integer;
  Done: boolean;
begin                {setzt SPS Read-Wert für Simulation}
  Done := false;
  if LbRead <> nil then
  begin
    for I := 0 to LbRead.Items.Count - 1 do
    begin
      S1 := PStrTok(LbRead.Items[I], ',', NextS);
      {if CompareText(copy(S1, 3, 100), IntToStr(DB)) = 0 then}
      if StrToIntTol(S1) = DB then
      begin
        S1 := PStrTok('', ',', NextS);
        {if Pos(IntToStr(Adr), S1) > 0 then}
        if StrToIntTol(S1) = Adr then
        begin
          if Str = '' then
            LbRead.Items.Delete(I) else
            LbRead.Items[I] := StrParam(LbRead.Items[I]) + '=' + Str;
          Done := true;
          break;
        end;
      end;
    end;
    if not Done then
    begin
      if StrToIntDef(Str, -1) >= 0 then
        VarName := Format('DB%d,dint%d', [DB, Adr]) else
        VarName := Format('DB%d,char%d', [DB, Adr]);
      LbRead.Items.Values[VarName] := Str;
      I := LbRead.Items.IndexOf(VarName + '=');
      if I >= 0 then
        LbRead.Items.Delete(I);
    end;
  end;
end;

procedure TOpcS7.WriteVar(VarName, Value: string);
var
  B: boolean;
begin
  try
    if not Simul then
    try
      B :=Write(VarName, Value);
    finally
    end else
    begin
      Application.ProcessMessages;
      B := true;
    end;
    LbWriteValue(VarName, Value);
    ProtP0('S7WriteVar(%s,%s):%d', [VarName, Value, ord(B)]);
    if B then
      SetStatus(0, 'OK') else
      SetStatus(11, 'nicht geschrieben');
  except on E:Exception do
    begin
      ProtP0('S7WriteVar(%s,%s):%s', [VarName, Value, E.Message]);
      SetStatus(21, E.Message);
    end;
  end;
end;

procedure TOpcS7.WriteString(DB, Adr, Count: integer; Str: string);
var
  B: boolean;
  S, VarName: string;
  I: integer;
begin
  B := false;
  try
    S := Format('%-*.*s', [Count, Count, Str]);
    VarName := Format('DB%d,char%d,%d', [DB, Adr, length(S)]);
    if not Simul then
    try
      {for I := 1 to length(Str) do
        B :=Write(Format('DB%d,char%d', [DB, Adr - 1 + I]), IntToStr(ord(Str[I])));}

      for I := 0 to Count - 1 do
        if I + 1 <= length(Str) then
          B :=Write(Format('DB%d,char%d', [DB, Adr + I]), IntToStr(ord(Str[I + 1])))
        else
          B :=Write(Format('DB%d,char%d', [DB, Adr + I]), '0');
    finally
    end else
    begin
      Application.ProcessMessages;
      B := true;
    end;
    LbWriteValue(VarName, S);
    ProtP0('S7WriteString(%s,%s):%d', [VarName, S, ord(B)]);
    if B then
      SetStatus(0, 'OK') else
      SetStatus(11, 'nicht geschrieben');
  except on E:Exception do
    begin
      ProtP0('S7WriteString(%s,%s):%s', [VarName, S, E.Message]);
      SetStatus(21, E.Message);
    end;
  end;
end;

procedure TOpcS7.WriteDInt(DB, Adr: integer; I: integer);
var
  B: boolean;
  S, VarName: string;
begin
  try
    VarName := Format('DB%d,dint%d', [DB, Adr]);
    S := IntToStr(I);
    if not Simul then
    try
      B := Write(VarName, S);
    finally
    end else
    begin
      Application.ProcessMessages;
      B := true;
    end;
    LbWriteValue(VarName, S);
    ProtP0('S7WriteDInt(%s,%s):%d', [VarName, S, ord(B)]);
    if B then
      SetStatus(0, 'OK') else
      SetStatus(11, 'nicht geschrieben');
  except on E:Exception do
    begin
      ProtP0('S7WriteDInt(%s,%s):%s', [VarName, S, E.Message]);
      SetStatus(21, E.Message);
    end;
  end;
end;

procedure TOpcS7.WriteInt(DB, Adr: integer; I: integer);
var
  B: boolean;
  S, VarName: string;
  Value: string;
begin
  try
    VarName := Format('DB%d,int%d', [DB, Adr]);
    S := IntToStr(I);
    if not Simul then
    try
      Value := S;
      B :=Write(VarName, Value);
    finally
    end else
    begin
      Application.ProcessMessages;
      B := true;
    end;
    LbWriteValue(VarName, S);
    ProtP0('S7WriteInt(%s,%s):%d', [VarName, S, ord(B)]);
    if B then
      SetStatus(0, 'OK') else
      SetStatus(11, 'nicht geschrieben');
  except on E:Exception do
    begin
      ProtP0('S7WriteInt(%s,%s):%s', [VarName, S, E.Message]);
      SetStatus(21, E.Message);
    end;
  end;
end;

procedure TOpcS7.WriteWord(DB, Adr: integer; I: integer);
//für S5.DW
var
  B: boolean;
  S, VarName: string;
  Value: string;
begin
  try
    VarName := Format('DB%d,word%d', [DB, Adr]);
    S := IntToStr(I);
    if not Simul then
    try
      Value := S;
      B := Write(VarName, Value);
    finally
    end else
    begin
      Application.ProcessMessages;
      B := true;
    end;
    LbWriteValue(VarName, S);
    ProtP0('S7WriteWord(%s,%s):%d', [VarName, S, ord(B)]);
    if B then
      SetStatus(0, 'OK') else
      SetStatus(11, 'nicht geschrieben');
  except on E:Exception do
    begin
      ProtP0('S7WriteWord(%s,%s):%s', [VarName, S, E.Message]);
      SetStatus(21, E.Message);
    end;
  end;
end;

procedure TOpcS7.WriteDInts(DB, Adr: integer; Ints: array of integer);
var
  B: boolean;
  S1, S, VarName: string;
  I, Adr1: integer;
begin
  B := false;
  try
    VarName := Format('DB%d,dint%d,%d', [DB, Adr, high(ints) - low(Ints) + 1]);
    S := CRLF;
    S1 := '';
    for I := low(Ints) to high(Ints) do
    begin
      S := S + IntToStr(Ints[I]) + CRLF;
      AppendTok(S1, IntToStr(Ints[I]), '|');
    end;
    if not Simul then
    try
      Adr1 := Adr;
      for I := low(Ints) to high(Ints) do
      begin
        B :=Write(Format('DB%d,dint%d', [DB, Adr1]), IntToStr(Ints[I]));
        Adr1 := Adr1 + 4;
      end;
    finally
    end else
    begin
      Application.ProcessMessages;
      B := true;
    end;
    LbWriteValue(VarName, S1);
    ProtP0('S7WriteDInts(%s,%s):%d', [VarName, S1, ord(B)]);
    if B then
      SetStatus(0, 'OK') else
      SetStatus(11, 'nicht geschrieben');
  except on E:Exception do
    begin
      ProtP0('S7WriteDInts(%s,%s):%s', [VarName, S1, E.Message]);
      SetStatus(21, E.Message);
    end;
  end;
end;

procedure TOpcS7.WriteInts(DB, Adr: integer; Ints: array of integer);
var
  B: boolean;
  S, S1, VarName: string;
  I: integer;
  Adr1: integer;
begin
  B := false;
  try
    VarName := Format('DB%d,int%d,%d', [DB, Adr, high(ints) - low(Ints) + 1]);
    S := CRLF;
    S1 := '';
    for I := low(Ints) to high(Ints) do
    begin
      S := S + IntToStr(Ints[I]) + CRLF;
      AppendTok(S1, IntToStr(Ints[I]), '|');
    end;
    if not Simul then
    try
      Adr1 := Adr;
      for I := low(Ints) to high(Ints) do
      begin
        B :=Write(Format('DB%d,int%d', [DB, Adr1]), IntToStr(Ints[I]));
        Adr1 := Adr1 + 2;
      end;
    finally
    end else
    begin
      Application.ProcessMessages;
      B := true;
    end;
    LbWriteValue(VarName, S1);
    ProtP0('S7WriteInts(%s,%s):%d', [VarName, S1, ord(B)]);
    if B then
      SetStatus(0, 'OK') else
      SetStatus(11, 'nicht geschrieben');
  except on E:Exception do
    begin
      ProtP0('S7WriteInts(%s,%s):%s', [VarName, S, E.Message]);
      SetStatus(21, E.Message);
    end;
  end;
end;

function TOpcS7.ReadVar(VarName: string; Adv: boolean): string;
var
  B: boolean;
  S: string;
begin
  try
    result := '';
    try
      B := Read(VarName, result);
    finally
    end;
    ProtP0('S7ReadVar(%s):%s', [VarName, S]);
    if B then
      SetStatus(0, 'OK') else
      SetStatus(11, 'nicht geschrieben');
  except on E:Exception do
    begin
      ProtP0('S7ReadVar(%s):%s', [VarName, E.Message]);
      SetStatus(22, E.Message);
    end;
  end;
end;

function TOpcS7.ReadString(DB, Adr, Count: integer; Adv: boolean): string;
var
  B, Advise: boolean;
  VarName: string;
  I: integer;
  Value: string;
begin
  try
    B := true;
    VarName := Format('DB%d,char%d,%d', [DB, Adr, Count]);
    Advise := Simul; //Adv or Simul; {chbAdvise.Checked;}
    if Advise then
    begin
      result := LbRead.Items.Values[VarName];
      if result = '' then                         {Simul kennt nur char ohne länge}
        result := LbRead.Items.Values[Format('DB%d,char%d', [DB, Adr])];
      if result = '' then
        Advise := false;
    end;
    if not Advise then
    begin
      if not Simul then
      begin
        result := '';
        for I := 1 to Count do
        try
          B := Read(Format('DB%d,char%d', [DB, Adr - 1 + I]), Value);
          result := result + chr(StrToIntTol(Value));
        finally
        end;
      end else
      begin
        Application.ProcessMessages;
        result := '';
      end;
      if result = '' then
        result := '?';
      if Adv then
      begin
        LbReadValue(VarName, result);
        {if LbRead.Items.Values[VarName] <> result then
          LbRead.Items.Values[VarName] := result;}
      end;
      ProtP0('S7ReadString(%s):%s', [VarName, result]);
    end;
    if B then
      SetStatus(0, 'OK') else
      SetStatus(12, 'nicht gelesen');
  except on E:Exception do
    begin
      ProtP0('S7ReadString(%s):%s', [VarName, E.Message]);
      SetStatus(22, E.Message);
    end;
  end;
end;

function TOpcS7.ReadDInt(DB, Adr: integer; Adv: boolean): integer;
var
  B, Advise: boolean;
  S, VarName: string;
begin
  Result := 0;
  try
    B := true;
    VarName := Format('DB%d,dint%d', [DB, Adr]);
    Advise := Simul; //Adv or Simul; {chbAdvise.Checked;}
    if Advise then
    begin
      S := LbRead.Items.Values[VarName];
      if S = '' then
        Advise := false;
    end;
    if not Advise then
    begin
      if not Simul then
      try
        B :=Read(VarName, S);
      finally
      end else
      begin
        Application.ProcessMessages;
        S := '';
      end;
      if S = '' then
        S := '0';
      if Adv then
      begin
        LbReadValue(VarName, S);
        {if LbRead.Items.Values[VarName] <> S then
          LbRead.Items.Values[VarName] := S;}
      end;
      ProtP0('S7ReadDInt(%s):%s', [VarName, S]);
    end;
    Result := StrToIntTol(S);
    if B then
      SetStatus(0, 'OK') else
      SetStatus(11, 'nicht geschrieben');
  except on E:Exception do
    begin
      ProtP0('S7ReadDInt(%s):%s', [VarName, E.Message]);
      SetStatus(22, E.Message);
    end;
  end;
end;

function TOpcS7.ReadInt(DB, Adr: integer; Adv: boolean): integer;
var
  B, Advise: boolean;
  S, VarName: string;
begin
  Result := 0;
  try
    B := true;
    VarName := Format('DB%d,int%d', [DB, Adr]);
    Advise := Simul; //Adv or Simul; {chbAdvise.Checked;}
    if Advise then
    begin
      S := LbRead.Items.Values[VarName];
      if S = '' then                         {Simul kennt nur dint}
        S := LbRead.Items.Values[Format('DB%d,dint%d', [DB, Adr])];
      if S = '' then
        Advise := false;
    end;
    if not Advise then
    begin
      if not Simul then
      try
        B :=Read(VarName, S);
      finally
      end else
      begin
        Application.ProcessMessages;
        S := '';
      end;
      if S = '' then
        S := '0';
      if Adv then
      begin
        LbReadValue(VarName, S);
        {if LbRead.Items.Values[VarName] <> S then
          LbRead.Items.Values[VarName] := S;}
      end;
      ProtP0('S7ReadInt(%s):%s', [VarName, S]);
    end;
    Result := StrToIntTol(S);
    if B then
      SetStatus(0, 'OK') else
      SetStatus(11, 'nicht geschrieben');
  except on E:Exception do
    begin
      ProtP0('S7ReadInt(%s):%s', [VarName, E.Message]);
      SetStatus(22, E.Message);
    end;
  end;
end;

function TOpcS7.ReadWord(DB, Adr: integer; Adv: boolean): integer;
//für s5 DW
var
  B, Advise: boolean;
  S, VarName: string;
begin
  Result := 0;
  try
    B := true;
    VarName := Format('DB%d,word%d', [DB, Adr]);
    Advise := Simul; //Adv or Simul; {chbAdvise.Checked;}
    if Advise then
    begin
      S := LbRead.Items.Values[VarName];
      if S = '' then                         {Simul kennt nur dint}
        S := LbRead.Items.Values[Format('DB%d,dint%d', [DB, Adr])];
      if S = '' then
        Advise := false;
    end;
    if not Advise then
    begin
      if not Simul then
      try
        B := Read(VarName, S);
      finally
      end else
      begin
        Application.ProcessMessages;
        S := '';
      end;
      if S = '' then
        S := '0';
      if Adv then
      begin
        LbReadValue(VarName, S);
        {if LbRead.Items.Values[VarName] <> S then
          LbRead.Items.Values[VarName] := S;}
      end;
      ProtP0('S7ReadWord(%s):%s', [VarName, S]);
    end;
    Result := StrToIntTol(S);
    if B then
      SetStatus(0, 'OK') else
      SetStatus(11, 'nicht geschrieben');
  except on E:Exception do
    begin
      ProtP0('S7ReadWord(%s):%s', [VarName, E.Message]);
      SetStatus(22, E.Message);
    end;
  end;
end;

end.
