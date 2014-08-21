unit Testfrm;

interface

uses
{$ifdef WIN32}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Poll_kmp, Math,
  Qwf_Form, Lnav_kmp,
  Cpor_kmp, CPro_kmp, Grids, Buttons, Fawa_kmp, Sche_kmp, Row7_kmp;
{$else}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Poll_kmp, Qwf_Form, Lnav_kmp,
  Cpor_kmp, CPro_kmp, Grids, Buttons, Fawa_kmp, Sche_kmp, Row7_kmp;
{$endif}

type
  TFrmTest = class(TqForm)
    BtnUp: TButton;
    BtnDown: TButton;
    EdStatus: TEdit;
    LNavigator1: TLNavigator;
    ProtGawMoni: TComProt;
    ComPort1: TComPort;
    EdSend: TEdit;
    BtnSend: TButton;
    EdEmpf: TEdit;
    GridProt: TStringGrid;
    Label1: TLabel;
    ProtWoehwaKarte: TComProt;
    BtnConfig: TSpeedButton;
    ProtSche: TScheKmp;
    LaTelId: TLabel;
    ProtGaw: TComProt;
    ProtRow7: TRow7Kmp;
    procedure FormCreate(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure BtnDownClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnSendClick(Sender: TObject);
    procedure ComPort1Prot(Sender: TObject; ComModus: TComModus;
      Data: PChar; Len: Word);
    procedure BtnConfigClick(Sender: TObject);
    procedure ProtScheAntwort(Sender: TObject; Tel_Id: Longint);
    procedure ProtRow7Antwort(Sender: TObject; Tel_Id: Longint);
  private
    { Private-Deklarationen }
    OldComModus : TComModus;
    GridY : integer;
    procedure PollTest( Sender: TObject);
    procedure StrToGewicht( GewStr: string; var Gewicht: double);
  public
    { Public-Deklarationen }
    PollTelId, TelId : longint;
    Stopped: boolean;
  end;

var
  FrmTest: TFrmTest;

implementation
{$R *.DFM}
uses
  Prots, CtSetDlg;

procedure TFrmTest.FormCreate(Sender: TObject);
begin
  ComPort1.Open;
  PollKmp.Add( PollTest, EdStatus, 10);
  PollTelId := -1;
  TelId := -1;
  Stopped := true;

  GridY := 1;
  OldComModus := cmWrite;
  GridProt.Cells[0,0] := 'Senden';
  GridProt.Cells[1,0] := 'Empfangen';
end;

procedure TFrmTest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PollKmp.Sub( PollTest, EdStatus);
  ComPort1.Close;
  Action := caFree;
end;

procedure TFrmTest.PollTest( Sender: TObject);
var
  AEdit : TEdit;
begin
  if not Stopped and (PollTelId < 0) and (TelId < 0) then
  begin
    {PollTelId := ProtSche.Start( '1#TN#', 5);  Sche}
    PollTelId := ProtRow7.Start( '0001', 4); {Row7}
    Smess('StartPoll:%d',[PollTelId]);
  end;

  BtnSend.Enabled := TelId < 0;

  AEdit := Sender as TEdit;
  AEdit.Refresh;
end;

procedure TFrmTest.BtnUpClick(Sender: TObject);
begin
  Stopped := false;
  EdStatus.Text := 'UP';
end;

procedure TFrmTest.BtnDownClick(Sender: TObject);
begin
  Stopped := true;
  EdStatus.Text := 'DOWN';
end;

procedure TFrmTest.BtnSendClick(Sender: TObject);
var
  SendBuff : array[0..255] of char;
  L : word;
begin
  {GridProt.RowCount := 2;
  GridY := 1;
  GridProt.Cells[0,1] := '';
  GridProt.Cells[1,1] := '';}

  L := length( EdSend.Text);
  TelID := ProtRow7.Start( StrPCopy( SendBuff, EdSend.Text), L);
  LaTelId.Caption := 'ID: ' + IntToStr( TelId);
end;

procedure TFrmTest.ComPort1Prot(Sender: TObject; ComModus: TComModus;
  Data: PChar; Len: Word);
var
  X, I : integer;
  S : string;
  gr : TGridRect;
begin
  if (ComModus = cmWrite) and (OldComModus = cmRead) then
    Inc( GridY);
  OldComModus := ComModus;
  if GridProt.RowCount <= GridY then
    GridProt.RowCount := GridY + 1;
  if ComModus = cmWrite then
    X := 0 else
    X := 1;
  S := '';
  for I := 0 to Len-1 do
    if Data[I] < chr(32) then
      S := S + '^' + chr( ord(Data[I]) + 64) else
      S := S + Data[I];
  GridProt.Cells[X, GridY] := GridProt.Cells[X, GridY] + S;
  gr.Left := X; gr.Right := X;
  gr.Top := GridY; gr.Bottom := GridY;
  GridProt.Selection := gr;
  GridProt.TopRow := IMax( 1, GridY - GridProt.VisibleRowCount + 1);
end;

procedure TFrmTest.BtnConfigClick(Sender: TObject);
begin
  PollKmp.Sub( PollTest, EdStatus);
  ComPort1.Close;
  TDlgCtSet.Execute( self, ComPort1, true);
  ComPort1.Open;
  PollKmp.Add( PollTest, EdStatus, 1000);
end;

(* Sche *)

procedure TFrmTest.ProtScheAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of char;
  L : integer;
  Tok: PChar;
  // ATel : TTel;
  ME, GewStr: string;
  Gewicht: double;
  NextStr: PChar;
begin
  smess('Antwort:%d',[Tel_Id]);
  L := sizeof(EmpfBuff) - 1;
  try
    ProtSche.GetData( Tel_Id, EmpfBuff, L);
  finally
    EmpfBuff[L] := #0;
    if Tel_Id = TelId then
    try
      EdEmpf.Text := StrPas( EmpfBuff);
    finally
      TelId := -1;
    end else
    if Tel_Id = PollTelId then
    try
      // ATel := ProtSche.GetTel( Tel_Id);
      if L > 0 then
      try
        Tok := StrTok( EmpfBuff, '#', NextStr);
        Debug('%s', [Tok]);
        {Waagenadresse}
        Tok := StrTok( nil, '#', NextStr);
        Debug('%s', [Tok]);
        {TN}
        Tok := StrTok( nil, '#', NextStr);
        Debug('%s', [Tok]);
        {Gewicht}
        GewStr := StrPas( Tok);
        Tok := StrTok( nil, '#', NextStr);
        Debug('%s', [Tok]);

        {Waagenstatus}


        Gewicht := StrToFloatTol( GewStr);
        ME := 't';
        EdStatus.Text := Format( '%d:%5.2f %-2.2s', [Tel_Id, Gewicht, ME]);
      except
        on E:Exception do
          EdStatus.Text := IntToStr(Tel_Id) + ':%s' + E.Message;
      end;
    finally
      PollTelId := -1;
    end else
      ErrWarn('Falsche ID (%d)',[Tel_Id]);
  end;
end;

procedure TFrmTest.StrToGewicht( GewStr: string; var Gewicht: double);
var
  NachK : integer;
begin
  if ProtRow7.Nk < 0 then
    NachK := -ProtRow7.Nk else
    NachK := 0;
  Gewicht := RoundDec( StrToFloatTol( GewStr) * Power( 10, ProtRow7.Nk), NachK);
end;

procedure TFrmTest.ProtRow7Antwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of char;
  L : integer;
  ATel : TTel;
  GewStr: string;
  Gewicht: double;
begin
  smess('Antwort:%d',[Tel_Id]);
  L := sizeof(EmpfBuff) - 1;
  try
    ProtRow7.GetData( Tel_Id, EmpfBuff, L);
  finally
    EmpfBuff[L] := #0;
    if Tel_Id = TelId then
    try
      EdEmpf.Text := StrPas( EmpfBuff);
    finally
      TelId := -1;
    end else
    if Tel_Id = PollTelId then
    try
      ATel := ProtRow7.GetTel( Tel_Id);
      if ATel.Status = cpsOK then
      begin
        GewStr := StrLPas( EmpfBuff+7, 5);
        StrToGewicht( GewStr, Gewicht);
        EdStatus.Text := Format( '%d:%f%s', [Tel_Id, Gewicht, ProtRow7.GE]);
      end;
    finally
      PollTelId := -1;
    end else
      ErrWarn('Falsche ID (%d)',[Tel_Id]);
  end;
end;

end.
