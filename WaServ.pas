unit Waserv;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, StdCtrls;

type
  TForm1 = class(TForm)
    BtnHost: TButton;
    BtnClient: TButton;
    Label1: TLabel;
    EdFilename: TEdit;
    Label2: TLabel;
    LaStatus: TLabel;
    MeDaten: TMemo;
    BtnWaage: TButton;
    procedure BtnHostClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnClientClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnWaageClick(Sender: TObject);
  private
    { Private-Deklarationen }
    MayClose, WantClose: boolean;
    T1: longint;
    FileName: string;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

procedure Delay( Value: longint);
(* Wartet Value [ms] *)
var
  Start: longint;
begin
  TicksReset(Start);
  repeat
    Application.ProcessMessages;
  until TicksDelayed(Start) >= Value;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FileName := EdFilename.Text;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not MayClose then
  begin
    CanClose := false;
    WantClose := true;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TForm1.BtnHostClick(Sender: TObject);
var
  R: double;
  AMemoryStream: TMemoryStream;
  P  : array [0..255] of char;       {array size is number of characters needed}
begin
  {T1 := 0;}
  while not WantClose do
  try
    BtnHost.Enabled := false;
    EdFileName.Text := FileName + 'CLI';
    if FileExists(EdFileName.Text) then           {neue Anfrage}
    begin
      DeleteFile(EdFileName.Text);
      EdFileName.Text := FileName + 'HOS';
      MeDaten.Lines.Clear;
      TicksReset(T1);
      R := T1 / 1000;
      MeDaten.Lines.Add(FloatToStr(R));
      {MeDaten.Lines.SaveToFile(EdFileName.Text);}

      StrPCopy(P, MeDaten.Lines[0]);
      AMemoryStream := TMemoryStream.Create;
      AMemoryStream.Write(P, SizeOf(P)-1);        {read chars from Stream into P}
      AMemoryStream.SaveToFile(EdFileName.Text);
      AMemoryStream.Free;
    end;
    Delay(10);      {Application.ProcessMessages;}
  except on E:Exception do
    begin
      LaStatus.Caption := E.Message;
      Application.ProcessMessages;
    end;
  end;
  BtnHost.Enabled := true;
  MayClose := true;
  if WantClose then
    Close;
end;

procedure TForm1.BtnClientClick(Sender: TObject);
var
  T1: longint;
  OldDate: TDateTime;
  AMemoryStream: TMemoryStream;
  P  : array [0..255] of char;       {array size is number of characters needed}
begin
  OldDate := 0;
  if WantClose then
  begin
    MayClose := true;
    Close;
  end else
  while not WantClose do
  try
    EdFileName.Text := FileName + 'HOS';
    if FileExists(EdFileName.Text) then
    begin
      AMemoryStream := TMemoryStream.Create;
      AMemoryStream.LoadFromFile(EdFileName.Text);
      FillChar(P, SizeOf(P), #0);                    {terminate the null string}
      AMemoryStream.Read(P, SizeOf(P)-1);        {read chars from Stream into P}
      AMemoryStream.Free;
      MeDaten.Lines[0] := StrPas(P);

      LaStatus.Caption := IntToStr(TicksDelayed(T1)) + ' ms';
      TicksReset(T1);
      if not DeleteFile(EdFileName.Text) then
        LaStatus.Caption := 'Can not delete';
    end;
    EdFileName.Text := FileName + 'CLI';
    if not FileExists(EdFileName.Text) then
    begin
      if MeDaten.Lines.Count = 0 then
        MeDaten.Lines.Add('Anfrage');
      MeDaten.Lines.SaveToFile(EdFileName.Text);
    end;
    Delay(10);      {Application.ProcessMessages;}
  except on E:Exception do
    begin
      LaStatus.Caption := E.Message;
      Application.ProcessMessages;
    end;
  end;
  MayClose := true;
  Close;
end;

procedure TForm1.BtnWaageClick(Sender: TObject);
var
  T1: longint;
  OldDate: TDateTime;
  AMemoryStream: TMemoryStream;
  P  : array [0..255] of char;       {array size is number of characters needed}
  Step: integer;
begin
  OldDate := 0;
  Step := 0;
  if WantClose then
  begin
    MayClose := true;
    Close;
  end else
  while not WantClose do
  try
    BtnWaage.Enabled := false;
    if Step = 0 then
    begin
      EdFileName.Text := FileName + 'ooo1.CLI';
      {if not FileExists(EdFileName.Text) then}
      begin
        if MeDaten.Lines.Count = 0 then
          MeDaten.Lines.Add('0001');
        MeDaten.Lines.SaveToFile(EdFileName.Text);
        LaStatus.Caption := '0';
        Step := 1;
      end;
    end;
    if Step = 1 then
    begin
      EdFileName.Text := FileName + 'ooo1.HOS';
      if FileExists(EdFileName.Text) then
      begin
        AMemoryStream := TMemoryStream.Create;
        AMemoryStream.LoadFromFile(EdFileName.Text);
        FillChar(P, SizeOf(P), #0);                    {terminate the null string}
        AMemoryStream.Read(P, SizeOf(P)-1);        {read chars from Stream into P}
        AMemoryStream.Free;
        MeDaten.Lines[0] := StrPas(P);

        LaStatus.Caption := '1 ' + IntToStr(TicksDelayed(T1)) + ' ms';
        TicksReset(T1);
        if not DeleteFile(EdFileName.Text) then
          LaStatus.Caption := 'Can not delete';
        Step := 0;
      end;
    end;
    Delay(10);      {Application.ProcessMessages;}
  except on E:Exception do
    begin
      LaStatus.Caption := E.Message;
      Application.ProcessMessages;
    end;
  end;
  BtnWaage.Enabled := true;
  MayClose := true;
  Close;
end;

end.
