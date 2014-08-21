unit FDDE_Kmp;
(* File-DDE
   Autor: Martin Dambach
   17.06.99        Erstellt
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs;

type
  TRemote = (reHost,             {Hostmodus und Lokaler Modus mit Verbindung}
             reClient);          {Clientmodus ohne direkte Verbindung}
  TFDdeModus = (fmHost, fmClient);

  TFDde = class(TComponent)
  private
    { Private-Deklarationen }
    FPollIntervall: integer;
    FRemote: TRemote;                        {Host/Lokal oder Client}
    FHost: string;                           {Stammverzeichnis des Host}
    FLines: TStringList;
    FOnChange: TNotifyEvent;
    procedure Poll(Sender : TObject);
    procedure SetLines(Value: TStringList);
    function GetText: string;
    procedure SetText(Value: string);
    procedure SetHost(Value: string);
    procedure LinesChange(Sender: TObject);
  protected
    { Protected-Deklarationen }
    Clients: TStringList;                   {Host: Namen der Clients}
    ClientId: string;                       {Client:Unique ID für Client}
    AktFileId: string;                      {Host: Aktuelle ID des Datenfiles}
    AktClientIndex: integer;                {Host:Aktueller Client}
    PollClientIndex: integer;                {Polling:Aktueller Client}
    OldLines: TStringList;
    InEmpf: boolean;
    PollError: boolean;
    function GetUniqueId: string;           {12345678}
    procedure HostEmpf(AFileName: string);
    procedure HostSend(ClientIndex: integer; aFileId: string);
    procedure ClientEmpf(AFileName: string);
    procedure ClientSend;
    procedure Loaded; override;
    procedure DoOnChange;
    procedure LoadClients;
  public
    { Public-Deklarationen }
    procedure RemoveAllClients;
    procedure RemoveClient(Id: string);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Lines: TStringList read FLines write SetLines;
    property Text: string read GetText write SetText;
  published
    { Published-Deklarationen }
    property PollIntervall: integer read FPollIntervall write FPollIntervall;
    property Remote: TRemote read FRemote write FRemote;
    property Host: string read FHost write SetHost;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation
uses
  Prots, Poll_Kmp, GNav_Kmp, Err__Kmp;

function TFDde.GetUniqueId: string;
begin
  result := IntToStr(Int64(GetCurrentTime) mod 100000000);
end;

procedure TFDde.SetLines(Value: TStringList);
begin
  FLines.Assign(Value);
end;

procedure TFDde.LinesChange(Sender: TObject);
begin
  if not InEmpf then
    if FRemote = reClient then
      ClientSend else
      HostSend(AktClientIndex, AktFileId);
end;

function TFDde.GetText: string;
begin
  if Lines.Count > 0 then
    result := Lines[0] else
    result := '';
end;

procedure TFDde.SetText(Value: string);
begin
  SetStringsText(Lines, Value);
end;

procedure TFDde.SetHost(Value: string);
var
  S1: string;
begin
  if fHost <> Value then
  begin
    fHost := Value;
    if (fHost <> '') and (CharN(fHost) <> '\') then
      fHost := Format('%s\', [fHost]);
    if not (csDesigning in ComponentState) and (fHost <> '') then
    begin
      ClientId := GetUniqueId;     {eindeutige ID. Zur Sicherheit immer anlegen}
      if (fHost <> '') and (CharN(fHost) = '\') then
      try
        S1 := copy(fHost, 1, length(fHost) - 1);   {ohne \}
        if not DirExists(S1) then                     {DIR Vorhandensein testen}
          CreatePath(S1);                                  {Host Verzeichnis anlegen}
      except on E:Exception do
      end;
      if Remote = reClient then
      try
        S1 := Format('%s%s', [fHost, ClientId]);
        if not DirExists(S1) then
          CreatePath(S1);      {eindeutiges Client Verzeichnis anlegen}
      except on E:Exception do
        EProt(self, E, 'SetHost(%s,%s)', [Value, ClientId]);
      end;
    end;
  end;
end;

procedure TFDde.LoadClients;
var
  S, NextS: string;
  SearchRec: TSearchRec;
begin              (* lädt alle Client-Verzeichnisse nach Clients[] *)
  Clients.Clear;
  S := Format('%s*.', [Host]);
  if SysUtils.FindFirst(S, faDirectory, SearchRec) = 0 then
  try
    repeat
      if Char1(SearchRec.Name) <> '.' then
        Clients.Add(PStrTok(SearchRec.Name, '.', NextS));
    until SysUtils.FindNext(SearchRec) <> 0;
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

procedure TFDde.RemoveAllClients;
(* Host: löscht alle vorhandenen Client-Verzeichnisse
   -> Service Funktion um nach Client-Abstürzen die alten Files zu löchen *)
var
  I: integer;   
begin
  LoadClients;
  Prot0('%s:RemoveAllClients', [Name]);
  for I := 0 to Clients.Count - 1 do
  begin
    Prot0('%s:RemoveClient(%s)', [Name, Clients[I]]);
    RemoveClient(Clients[I]);
  end;
end;

procedure TFDde.RemoveClient(Id: string);
var
  SearchRec: TSearchRec;
  S1: string;
begin                              (* Löscht das Client-Verzeichnis <Id> *)
  if fHost <> '' then
  try
    S1 := Format('%s%s', [fHost, Id]);
    if SysUtils.FindFirst(Format('%s\*.*', [S1]), faAnyFile, SearchRec) = 0 then
    try
      repeat
        SysUtils.DeleteFile(Format('%s\%s', [S1, SearchRec.Name]));
      until SysUtils.FindNext(SearchRec) <> 0;
    finally
      SysUtils.FindClose(SearchRec);
    end;
{$ifdef WIN32}
    RemoveDir(S1);
{$else}
    RmDir(S1);
{$endif}
  except on E:Exception do
    EProt(self, E, 'RemoveClient(%s)', [Id]);
  end;
end;

procedure TFDde.DoOnChange;
begin
  if Assigned(fOnChange) then
  try
    fOnChange(self);
  except on E:Exception do
    EProt(self, E, 'OnChange', [0]);
  end;
end;

constructor TFDde.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Clients := TStringList.Create;
  FLines := TStringList.Create;
  OldLines := TStringList.Create;
  FRemote := reClient;
  FPollIntervall := 500;
  FLines.OnChange := LinesChange;
end;

procedure TFDde.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
  begin
    PollKmp.Add(Poll, self, PollIntervall);         {Pollingfunktion anmelden}
  end;
end;

destructor TFDde.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    PollKmp.Sub(Poll, self);
    if (Remote = reClient) and (fHost <> '') then
      RemoveClient(ClientId);
  end;
  Clients.free; Clients := nil;
  FLines.free; FLines := nil;
  OldLines.free; OldLines := nil;
  inherited Destroy;
end;

procedure TFDde.HostEmpf(AFileName: string);
var
  NextS: string;
begin
  try
    InEmpf := true;
    AktFileId := PStrTok(ExtractFileName(AFileName), '.', NextS);{ID zum Senden}
    {X Lines.LoadFromFile(AFileName);}
    StringsFromFile(Lines, AFileName);
    {ProtP('%s:HostEmpf(%s:%.30s)', [Name, ExtractFileName(AFileName), Lines.Text]);}
    if not SysUtils.DeleteFile(AFileName) then
      EError('HostEmpf:DeleteFile (%s) failed', [AFileName]);
    InEmpf := false;                                             {Sendefreigabe}
    DoOnChange;
  finally
    InEmpf := false;
    AktFileId := '';             {ab jetzt wieder neue ID zum Senden generieren}
  end;
end;

procedure TFDde.HostSend(ClientIndex: integer; aFileId: string);
var
  I, ErrCnt: integer;
  AFileName: string;
begin
  if fHost = '' then
    Exit;
  if aFileId = '' then
    aFileId := GetUniqueId;
  I := 0;
  ErrCnt := 0;
  while (I < Clients.Count) and (ErrCnt < 5) do
  try
    if (I = ClientIndex) or (ClientIndex < 0) then
    begin
      AFileName := Format('%s%s\%s.HOS', [Host, Clients[I], aFileId]);
      Lines.SaveToFile(AFileName);    {frisst Speicher!}
    end;
    Inc(I);
  except on E:Exception do
    begin
      Inc(ErrCnt);                     {5 mal wiederholen bis OK}
      EProt(self, E, 'HostSend(%d,%s):%d', [ClientIndex, AFileName, ErrCnt]);
      Application.ProcessMessages;
    end;
  end;
end;

procedure TFDde.ClientSend;
var
  AFileName: string;
  ErrCnt: integer;
begin                                 {Identisches ohne Antwort nicht nochmal senden}
  if (fHost <> '') and (GetStringsText(OldLines) <> GetStringsText(Lines)) then
  begin
    ErrCnt := 0;
    while ErrCnt < 5 do
    try
      AFileName := '';
      AktFileId := GetUniqueId;
      AFileName := Format('%s%s\%s.CLI', [Host, ClientId, AktFileId]);
      Lines.SaveToFile(AFileName);
      {ProtP('%s:ClientSend(%.30s)', [Name, Lines.Text]);}
      OldLines.Assign(Lines);
      ErrCnt := 99;
    except on E:Exception do
      begin
        Inc(ErrCnt);                     {5 mal wiederholen bis OK}
        EProt(self, E, 'ClientSend(%s)', [AFileName]);
        Application.ProcessMessages;
      end;
    end;
  end;
end;

procedure TFDde.ClientEmpf(AFileName: string);
begin
  try
    InEmpf := true;
    OldLines.Clear;                     {'' ist Kennzeichen daß Empfangen}
    {XLines.LoadFromFile(AFileName);}
    StringsFromFile(Lines, AFileName);
    {ProtP('%s:ClientEmpf(%.30s)', [Name, Lines.Text]);}
    if not SysUtils.DeleteFile(AFileName) then
      EError('ClientEmpf:DeleteFile (%s) failed', [AFileName]);
    InEmpf := false;                                             {Sendefreigabe}
    DoOnChange;
  finally
    InEmpf := false;
  end;
end;

procedure TFDde.Poll(Sender : TObject);
var
  SearchRec: TSearchRec;
  S, ErrStr: string;
begin                                                          {Pollingfunktion}
  ErrStr := '';
  if [csLoading,csReading,csDestroying] * ComponentState <> [] then
    Exit;
  if fHost <> '' then
  try
    if Remote = reHost then
    begin
      LoadClients;
      if Clients.Count > 0 then
      begin
        PollClientIndex := (PollClientIndex + 1) mod Clients.Count;
        S := Format('%s%s\', [Host, Clients[PollClientIndex]]);
        ErrStr := S;
        if SysUtils.FindFirst(Format('%s*.CLI', [S]), faArchive, SearchRec) = 0 then
        try
          AktClientIndex := PollClientIndex;      {Antwort (in OnChange) nur an diesen Client}
          repeat
            ErrStr := Format('HostEmpf(%s%s)', [S, SearchRec.Name]);
            HostEmpf(Format('%s%s', [S, SearchRec.Name]));
          until SysUtils.FindNext(SearchRec) <> 0;
        finally
          SysUtils.FindClose(SearchRec);
          AktClientIndex := -1;                      {ab jetzt wieder Broadcast}
        end;
      end;
    end else
    if Remote = reClient then
    begin
      S := Format('%s%s\', [Host, ClientId]);
      ErrStr := S;
      if SysUtils.FindFirst(Format('%s*.HOS', [S]), faArchive, SearchRec) = 0 then
      try
        repeat
          ErrStr := Format('ClientEmpf(%s%s)', [S, SearchRec.Name]);
          ClientEmpf(Format('%s%s', [S, SearchRec.Name]));
        until SysUtils.FindNext(SearchRec) <> 0;
      finally
        SysUtils.FindClose(SearchRec);
      end;
    end;
  except on E:Exception do
    begin
      PollError := true;
      EProt(self, E, 'Poll(%s)',[ErrStr]);
    end;  
  end;
end;

end.

