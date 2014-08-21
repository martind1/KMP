unit Zeitdlg;
(* TimeBtn
   DlgZeit
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DBCtrls, Forms, Dialogs, ExtCtrls, StdCtrls, Grids, TgridKmp, Buttons,
  Spin,
  DatumDlg;

type
  TTimeBtn = class(TBitBtn)
  private
    { Private-Deklarationen }
    FEdit: TCustomEdit;
    FStartTime: string;
    FBeforeClick: TNotifyEvent;
    procedure SetStartTime( Value: string);
    function GetDBEdit: TDBEdit;
  protected
    { Protected-Deklarationen }
    procedure SetName(const Value: TComponentName); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    ModalResult: TModalResult;             {Ergebnis des Dialogs (mrOK, mrCancel)}
                                           {zur Verwendung im OnClick Ereignis}
    TheTime: TDateTime;
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  published
    { Published-Deklarationen }
    property DBEdit: TCustomEdit read FEdit write FEdit;
    property StartTime: string read FStartTime write SetStartTime;
    property TabStop default false;
    property BeforeClick: TNotifyEvent read FBeforeClick write FBeforeClick;
  end;

type
  TDlgZeit = class(TForm)
    GridStunden: TTitleGrid;
    GridMinuten: TTitleGrid;
    Label1: TLabel;
    EdUhrzeit: TEdit;
    BtnOK: TBitBtn;
    BtnJetzt: TBitBtn;
    BtnCancel: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    TimeSpin1: TTimeSpin;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EdUhrzeitChange(Sender: TObject);
    procedure BtnJetztClick(Sender: TObject);
    procedure GridStundenClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private-Deklarationen }
    InEdUhrzeitChange: boolean;
    InGridClick: boolean;
  public
    { Public-Deklarationen }
    class function Run( var ATime: TDateTime): integer;
  end;

var
  DlgZeit: TDlgZeit;

implementation
{$R *.RES}           (* Resource 'ZEITBTN' in ZEITDLG.RES *)
{$R *.DFM}
uses
  DB,  Uni, DBAccess, MemDS,
  Prots, GNav_Kmp, Err__Kmp;

(* Zeit Button *************************************************************)

procedure TTimeBtn.SetStartTime( Value: string);
begin
  try
    TheTime := StrToTime( Value);
    FStartTime := FormatDateTime( 'hh:nn', TheTime);
  except on E:Exception do
    ShowMessage(E.Message);
  end;
end;

procedure TTimeBtn.SetName(const Value: TComponentName);
begin
  inherited SetName(Value);
  Caption := '';
end;

function TTimeBtn.GetDBEdit: TDBEdit;
begin
  if FEdit is TDBEdit then
    result := TDBEdit(FEdit) else
    result := nil;
end;

constructor TTimeBtn.Create( AOwner: TComponent);
begin
  inherited Create( AOwner);
  Glyph.Handle := LoadBitmap( HInstance, 'TIMEBTN');
  try
    NumGlyphs := IMax( 1, Glyph.Width div Glyph.Height);
  except
    NumGlyphs := 1;
  end;
  FStartTime := '07:00';
  Width := 21;
  Height := 21;
  Caption := '';
  if not (csLoading in ComponentState) then
    TabStop := false;
end;

procedure TTimeBtn.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FEdit) then
    FEdit := nil;
  inherited Notification( AComponent, Operation);
end;

procedure TTimeBtn.Click;
var
  N: integer;
begin
  try
    if assigned(FBeforeClick) then
      FBeforeClick(self);
    if FEdit = nil then
    begin
      TheTime := StrToTime( StartTime);
    end else
    if GetDBEdit <> nil then
    try
      if GetDBEdit.Field.IsNull then
      begin
        TheTime := StrToTime(StartTime);
      end else
        if GetDBEdit.Field is TDateTimeField then
          TheTime := TDateTimeField(GetDBEdit.Field).AsDateTime else
          TheTime := FieldAsTime(GetDBEdit.Field);
    except
      TheTime := StrToTime(StartTime);
    end else
    if FEdit.Text = '' then
    begin
      TheTime := StrToTime(StartTime);
    end else
    try
      TheTime := StrToTime(FEdit.Text)
    except
      TheTime := StrToTime(StartTime);
    end;
    ModalResult := TDlgZeit.Run(TheTime);
    if ModalResult = mrOK then
    begin
      if FEdit <> nil then
      begin
        if FEdit.CanFocus then
          FEdit.SetFocus;
        FEdit.SelectAll;
        GNavigator.Canceled := false;
        {SendChar(FEdit, TimeToStr(TheTime));}
        if GetDBEdit <> nil then
        begin
          if GetDBEdit.Field is TDateTimeField then
            GetDBEdit.Field.AsDateTime := TheTime else    {quku.ppla}
            FieldSetTime(GetDBEdit.Field, TheTime);       //IntegerField
        end else
        if FEdit is TEdit then
        begin
          N := TEdit(FEdit).MaxLength;
          if N = 0 then N := 8;
          FEdit.Text := copy(TimeToStr(TheTime), 1, N)
        end else
          FEdit.Text := TimeToStr(TheTime);
      end;
      inherited Click;
    end;
  except on E:Exception do
    EMess(Self, E, 'Click', [0]);
  end;
end;

(* Zeit Dialog **************************************************************)

class function TDlgZeit.Run( var ATime: TDateTime): integer;
(* OK = mrOK *)
var
  ADate, ATimeHelp: TDateTime;
  {AYear, AMonth, ADay, AHour, AMin, ASec, AMSec: Word;}
  S: string;
begin
  with TDlgZeit.Create( Application.MainForm) do
  try
    try
      EdUhrzeit.Text := FormatDateTime('hh:nn', ATime);
      ADate := OnlyDate(ATime);
    except
      EdUhrzeit.Text := FormatDateTime('hh:nn', now);
      ADate := 0;
    end;
    result := ShowModal;
    (* warum 300699 ? Stört für OPT.
    ATime := StrToTime(EdUhrzeit.Text + ':02');    {+2 sec}
    {DecodeTime(ATime, AHour, AMin, ASec, AMSec);
    DecodeDate(ADate, AYear, AMonth, ADay);
    EncodeDateTime}
    ATime := RoundDec(ADate + ATime, 5);*)
    ATimeHelp := OnlyTime(StrToTime(EdUhrzeit.Text + ':00'));
    {ATime := StrToTime(EdUhrzeit.Text + ':00');}
    ATime := ATimeHelp + ADate;
    S := DateTimeToStr(ATime);        {Debug}
  finally
    Release;
  end;
end;

procedure TDlgZeit.BtnOKClick(Sender: TObject);
var
  ATime: TDateTime;
  S: string;
begin
  try
    ATime := StrToTime(EdUhrzeit.Text);            {Test auf Syntax Korrektheit}
    S := DateTimeToStr(ATime);
    ModalResult := mrOK;
  except on E:Exception do
    begin
      ErrWarn('%s', [E.Message]);                {'schöne' Meldung' u. mrCancel}
      ModalResult := mrNone;
    end;
  end;
end;

procedure TDlgZeit.FormCreate(Sender: TObject);
begin
  DlgZeit := self;
  GNavigator.TranslateForm(self);
end;

procedure TDlgZeit.FormDestroy(Sender: TObject);
begin
  DlgZeit := nil;
end;

procedure TDlgZeit.EdUhrzeitChange(Sender: TObject);
var
  ATime: TDateTime;
  AHour, AMin, ASec, AMSec: Word;
begin
  if not InGridClick then
  try
    InEdUhrzeitChange := true;
    try
      ATime := StrToTime(EdUhrzeit.Text);
      DecodeTime(ATime, AHour, AMin, ASec, AMSec);
      GridStunden.Row := (AHour div 12) mod 2;
      GridStunden.Col := AHour mod 12;
      GridMinuten.Col := (AMin div 5) mod 12;
    except
    end;
  finally
    InEdUhrzeitChange := false;
  end;
end;

procedure TDlgZeit.BtnJetztClick(Sender: TObject);
begin
  EdUhrzeit.Text := FormatDateTime('hh:nn', now);
end;

procedure TDlgZeit.GridStundenClick(Sender: TObject);
begin
  if not InEdUhrzeitChange then
  try
    InGridClick := true;
    EdUhrzeit.Text := GridStunden.Cells[GridStunden.Col, GridStunden.Row] +
      copy(GridMinuten.Cells[GridMinuten.Col, GridMinuten.Row], 2, 2);
    if length(EdUhrzeit.Text) = 4 then          {z.B. '1:00'}
      EdUhrzeit.Text := '0' + EdUhrzeit.Text;       { 01:00}
  finally
    InGridClick := false;
  end;
end;

end.
