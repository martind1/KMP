unit CalcDlg;
(* 14.01.00 MD  Taschenrechner
   21.09.08 MD  mit Historienliste. Merkt sich Positionierung.
*)

interface

uses WinProcs, WinTypes, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Grids, DBCtrls, Messages,
  Prots;

type
  TCalcBtn = class(TSpeedButton)
  private
    { Private-Deklarationen }
    FEdit: TCustomEdit;
    FCalc: Extended;
    FBeforeClick: TNotifyEvent;
    function GetCalc: Extended;
    procedure SetCalc(Value: Extended);
    function GetDBEdit: TDBEdit;
  protected
    { Protected-Deklarationen }
    procedure SetName(const Value: TComponentName); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    ModalResult: TModalResult;             {Ergebnis des Dialogs (mrOK, mrCancel)}
                                           {zur Verwendung im OnClick Ereignis}
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;             {startet Dialog}
    property DBEdit: TDBEdit read GetDBEdit;
  published
    { Published-Deklarationen }
    property Edit: TCustomEdit read FEdit write FEdit;
    property Calc: Extended read GetCalc write SetCalc;
    {property TabStop default false;}
    property BeforeClick: TNotifyEvent read FBeforeClick write FBeforeClick;
  end;

  TDlgCalc = class(TForm)
    Panel1: TPanel;
    Btn7: TSpeedButton;
    Btn8: TSpeedButton;
    Btn4: TSpeedButton;
    Btn9: TSpeedButton;
    Btn5: TSpeedButton;
    Btn6: TSpeedButton;
    Btn1: TSpeedButton;
    Btn2: TSpeedButton;
    Btn3: TSpeedButton;
    Btn0: TSpeedButton;
    BtnPlusMinus: TSpeedButton;
    BtnKomma: TSpeedButton;
    BtnClear: TSpeedButton;
    BtnDiv: TSpeedButton;
    BtnMul: TSpeedButton;
    BtnPlus: TSpeedButton;
    BtnMinus: TSpeedButton;
    BtnGleich: TSpeedButton;
    BtnOK: TBitBtn;
    BtnEsc: TBitBtn;
    EdCalc: TEdit;
    MemoHist: TMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    fCalcStr: string;
    Op, Step: char;
    Op1Str, Op2Str: string;
    procedure SetCalcStr(Value: string);
    function KeyToBtn(Key: Word): TSpeedButton;
    procedure CalcIt;
    procedure LoadFromIni;
    procedure SaveToIni;
    function Kurz: string;
  protected
    { Protected declarations }
    procedure BCBtnDown(var Message: TMessage); message BC_BTNDOWN;
    property CalcStr: string read fCalcStr write SetCalcStr;
  public
    { Public declarations }
    class function Run(var ACalc: Extended; SubTitle: string): integer;
  end;

var
  DlgCalc: TDlgCalc;

implementation
//UniDAC in Prj {$R *.RES}           (* Resource 'CalcBtn' in CalcDLG.RES *)
{$R *.DFM}
uses
  Dialogs,  Uni, DBAccess, MemDS,
  Err__Kmp, Poll_Kmp, GNav_Kmp, NStr_Kmp, Ini__Kmp;
const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}

(* Calc Button *************************************************************)

constructor TCalcBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Glyph.Handle := LoadBitmap(HInstance, 'CalcBtn');
  try    NumGlyphs := IMax(1, IntDiv0(Glyph.Width, Glyph.Height));
  except NumGlyphs := 1;
  end;
  Width := 21;
  Height := 21;
  Caption := '';
  {if not (csLoading in ComponentState) then
    TabStop := false;}
end;

function TCalcBtn.GetCalc: Extended;
begin
  result := fCalc;
end;

procedure TCalcBtn.SetCalc(Value: Extended);
begin
  fCalc := Value;
  if FEdit <> nil then
  begin
    if DBEdit <> nil then
    begin
      DBEdit.DataSource.Edit; {Edit ruft die Methode Edit der Datenmenge auf, wenn AutoEdit True und State dsBrowse ist.}
      {SendChar(FEdit, DateToStr(ADatum));    {auch für Getdbedit falls Autoedit}
      DBEdit.Field.AsFloat := Value;
    end else
    begin
      {FEdit.Text := FloatToStr(Value);}
      SendChar(FEdit, FloatToStr(Value));    {130400 wg. MultiGrid.Inplace}
    end;
  end;
end;

procedure TCalcBtn.SetName(const Value: TComponentName);
begin
  inherited SetName(Value);
  Caption := '';
end;

function TCalcBtn.GetDBEdit: TDBEdit;
begin
  if FEdit is TDBEdit then
    result := TDBEdit(FEdit) else
    result := nil;
end;

procedure TCalcBtn.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FEdit) then
    FEdit := nil;
  inherited Notification(AComponent, Operation);
end;

procedure TCalcBtn.Click;
var
  ACalc: Extended;
  S1: string;
  I: integer;
begin                   {für Aufruf von GNav und Click}
  if assigned(FBeforeClick) then
    FBeforeClick(self);
  ACalc := 0;
  if FEdit <> nil then
  try
    { if (DBEdit <> nil) and (DBEdit.Field <> nil) then
      ACalc := DBEdit.Field.AsFloat else }
      ACalc := StrToFloatTol(FEdit.Text);
  except on E:Exception do begin
      FEdit := nil;  //ungültig geworden
      EProt(self, E, '%s', ['TCalcBtn.Click']);
    end;
  end;

  S1 := '';
  if (fEdit <> nil) and (fEdit.Owner <> nil) then
    for I := 0 to TForm(fEdit.Owner).ComponentCount - 1 do
      if TForm(fEdit.Owner).Components[I] is TLabel then
        with TForm(fEdit.Owner).Components[I] as TLabel do
          if FocusControl = FEdit then
          begin
            S1 := RemoveAccelChar(Caption);
            break;
          end;
  ModalResult := TDlgCalc.Run(ACalc, S1);
  if ModalResult = mrOK then
  begin
    if FEdit <> nil then
    try
      if FEdit.CanFocus then
        FEdit.SetFocus;
      FEdit.SelectAll;
    except on E:Exception do
      EProt(self, E, '%s', ['TCalcBtn.Click']);
    end;
    Calc := ACalc;
  end;
  inherited Click;
end;

(* Calc Dialog *************************************************************)

class function TDlgCalc.Run(var ACalc: Extended; SubTitle: string): integer;
(* OK = mrOK *)
begin
  with TDlgCalc.Create(Application.MainForm) do
  try
    CalcStr := FloatToStr(aCalc);
    Caption := LongCaption(Caption, SubTitle);
    result := ShowModal;
    ACalc := StrToFloatTol(EdCalc.Text);
  finally
    Release;
  end;
end;

procedure TDlgCalc.SetCalcStr(Value: string);
begin
  fCalcStr := LTrimCh(Value, '0');
  if (length(fCalcStr) = 0) or (Char1(fCalcStr) = ',') then
    fCalcStr := '0' + fCalcStr;
  SetEdNum(EdCalc, fCalcStr);
end;

procedure TDlgCalc.FormCreate(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TSpeedButton then
      with Components[I] as TSpeedButton do
        Tag := ord(Char1(Caption));
  BtnPlusMinus.Tag := VK_F9;
  BtnClear.Tag := VK_DELETE;
  Op1Str := '';
  Op2Str := '';
  Step := '=';
  GNavigator.TranslateForm(self);
end;

procedure TDlgCalc.FormShow(Sender: TObject);
begin
  LoadFromIni;
end;

procedure TDlgCalc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveToIni;
end;

procedure TDlgCalc.LoadFromIni;
begin
  Width := IniKmp.ReadInteger(Kurz, 'Width', Width);
  Height := IniKmp.ReadInteger(Kurz, 'Height', Height);
  Top := IMax(0, IMin(Screen.Height - Height, IniKmp.ReadInteger(Kurz, 'Top', Top)));
  Left := IMax(0, IMin(Screen.Width - Width, IniKmp.ReadInteger(Kurz, 'Left', Left)));
end;

procedure TDlgCalc.SaveToIni;
begin
  IniKmp.WriteInteger(Kurz, 'Top', Top);
  IniKmp.WriteInteger(Kurz, 'Left', Left);
  IniKmp.WriteInteger(Kurz, 'Width', Width);
  IniKmp.WriteInteger(Kurz, 'Height', Height);
end;

function TDlgCalc.KeyToBtn(Key: Word): TSpeedButton;
var
  aChar: char;
  KeyState: TKeyBoardState;
begin
  GetKeyBoardState(KeyState);
  aChar := #0;
  ToAscii(Key, 0, KeyState, @aChar, 0);
  result := TSpeedButton(FindTagComponent(self, longint(aChar), TSpeedButton));
  if result = nil then
    result := TSpeedButton(FindTagComponent(self, Key, TSpeedButton)); {F9,Entf}
end;

procedure TDlgCalc.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  aSpeedButton: TSpeedButton;
begin
  aSpeedButton := KeyToBtn(Key);
  if aSpeedButton <> nil then
  begin
    aSpeedButton.Down := true;
  end;
end;

procedure TDlgCalc.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  aSpeedButton: TSpeedButton;
begin
  aSpeedButton := KeyToBtn(Key);
  if aSpeedButton <> nil then
  begin
    if aSpeedButton.Down then
      PostMessage(Handle, BC_BTNDOWN, 0, aSpeedButton.Tag);
  end else
  begin
    {CalcSta := '#' + IntToStr(Key) + '#' + Char(Byte(Key));}
  end;
end;

procedure TDlgCalc.BtnClick(Sender: TObject);
begin
  if TSpeedButton(Sender).Down then
    PostMessage(Handle, BC_BTNDOWN, 0, TSpeedButton(Sender).Tag);
end;

procedure TDlgCalc.CalcIt;
begin
  if (Op1Str <> '') and (Op2Str <> '') then
  try
    if Op = '+' then
      CalcStr := FloatToStr(StrToFloat(Op1Str) + StrToFloat(Op2Str)) else
    if Op = '-' then
      CalcStr := FloatToStr(StrToFloat(Op1Str) - StrToFloat(Op2Str)) else
    if Op = '*' then
      CalcStr := FloatToStr(StrToFloat(Op1Str) * StrToFloat(Op2Str)) else
    if Op = '/' then
      CalcStr := FloatToStr(StrToFloat(Op1Str) / StrToFloat(Op2Str));

//    MemoHist.Lines.Add(Format('%s  %s', [Op, CalcStr]));
  except on E:Exception do
    begin
      CalcStr := '0';
      SMess('Rechner: %s', [E.Message]);
    end;
  end;
end;

procedure TDlgCalc.BCBtnDown(var Message: TMessage); {message BC_BTNDOWN;}
var
  aSpeedButton: TSpeedButton;
const
  LastTag: longint = 0;
begin
  aSpeedButton := TSpeedButton(FindTagComponent(self, Message.LParam, TSpeedButton));
  aSpeedButton.Down := false;
  if ((aSpeedButton.Tag >= ord('0')) and (aSpeedButton.Tag <= ord('9'))) or
     (aSpeedButton.Tag = ord(',')) then
  begin
    if CharInSet(Step, ['+', '-', '*', '/', '=']) then
      CalcStr := '';
    if Step = '=' then
    begin
      Op1Str := '';
      Op2Str := '';
    end;
    Step := char(byte(aSpeedButton.Tag));
    CalcStr := CalcStr + aSpeedButton.Caption;
  end else
  if aSpeedButton = BtnClear then
  begin
    Op1Str := '';
    Op2Str := '';
    CalcStr := '0';
    Op := #0;
    MemoHist.Lines.Add('');
  end else
  if aSpeedButton = BtnPlusMinus then
  begin
    CalcStr := FloatToStr(-StrToFloat(CalcStr));
    Step := '-';
    MemoHist.Lines.Add(Format('%s', [CalcStr]));
  end else
  if aSpeedButton.Tag in [ord('+'), ord('-'), ord('*'), ord('/')] then
  begin
    if not CharInSet(Step, ['+', '-', '*', '/', '=']) then
    begin
      if Op = #0 then
        MemoHist.Lines.Add(Format('%s', [CalcStr])) else
        MemoHist.Lines.Add(Format('%s %s', [Op, CalcStr]));
      Op2Str := CalcStr;
      CalcIt;
    end;
    Op1Str := CalcStr;
    Op := char(byte(aSpeedButton.Tag));
    Step := Op;
  end else
  if aSpeedButton.Tag = ord('=') then
  begin
    MemoHist.Lines.Add(Format('%s %s', [Op, CalcStr]));
    if Step <> '=' then
      Op2Str := CalcStr;
    CalcIt;
    MemoHist.Lines.Add(Format('= %s', [CalcStr]));
    Op1Str := CalcStr;
    Step := '=';
  end else
  begin
    Exit;
  end;
//  MemoHist.Lines.Add(Format('%s  %s', [Op, CalcStr]));
end;

procedure TDlgCalc.BtnOKClick(Sender: TObject);
begin
  if Step <> '=' then
  begin
    Op2Str := CalcStr;
    CalcIt;
  end;
end;

function TDlgCalc.Kurz: string;
begin
  Result := Caption;
end;

end.
