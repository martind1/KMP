unit DatumDlg;
(* Datum Button
   Datum Dialog
   Time Spin
   File Button
   21.07.99 MD BeforeClick Ereignis
   26.07.99 MD Combos Year, Month
   13.08.99 MD Caption des Labels mit Focuscontrol im Untertitel
   21.07.01 MD File Button
   14.01.05 MD KW 1 = erste 4-Tage Woche
   01.08.08 MD FileBtn: plus Filter: 'word|*.doc|alle|*.*';
                        plus InitialDir
                        Filename nicht mehr published; liest/schreibt Edit.Text
                        Hint nach OpenDlg.Caption
                        Options: Pfad nicht nach Filename übernehmen
   07.06.09 MD Bild auf/ab rumgedreht: Auf=Vergangenheit. Ab=Zukunft. Wie im Tageskalender
   04.07.12 md  OpenBtn: OnBeforeClick kann Filename ändern (SetFilename is new)
*)

interface

uses WinProcs, WinTypes, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Grids, DBCtrls, Calendar, Spin, Dialogs,
  JvBrowseFolder,
  Prots;

type
  TDatumBtn = class(TBitBtn)
  private
    { Private-Deklarationen }
    FEdit: TCustomEdit;
    FDay,
    FMonth,
    FYear: word;
    FFormat: string;
    FBeforeClick: TNotifyEvent;
    function GetDatum: TDateTime;
    procedure SetDatum(Value: TDateTime);
    function GetDBEdit: TDBEdit;
  protected
    { Protected-Deklarationen }
    procedure SetName(const Value: TComponentName); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
//    ModalResult: TModalResult;             {Ergebnis des Dialogs (mrOK, mrCancel)}
//                                           {zur Verwendung im OnClick Ereignis}
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
    property Datum: TDateTime read GetDatum write SetDatum;
  published
    { Published-Deklarationen }
    property DBEdit: TCustomEdit read FEdit write FEdit;
    property Day: word read FDay write FDay;
    property Month: word read FMonth write FMonth;
    property Year: word read FYear write FYear;
    property Format: string read FFormat write FFormat;
    property TabStop default false;
    property BeforeClick: TNotifyEvent read FBeforeClick write FBeforeClick;
  end;

  (*** TimeSpin ***************************************************************)

  TTimeChangedEvent = procedure (Sender: TObject; ATime: TDateTime) of object;

  TTimeSpin = class(TSpinButton)
  private
    { Private-Deklarationen }
    FEdit: TCustomEdit;
    FStartTime: string;
    FStepTime: string;
    FActualTime: string;
    FOnTimeChanged: TTimeChangedEvent;
    procedure SetStartTime(Value: string);
    procedure SetStepTime(Value: string);
    function GetDBEdit: TDBEdit;
  protected
    { Protected-Deklarationen }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure NewDownClick(Sender: TObject);
    procedure NewUpClick(Sender: TObject);
    procedure NewTime(Modus: TPlusMinus);
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
  published
    { Published-Deklarationen }
    property DBEdit: TCustomEdit read FEdit write FEdit;
    property StartTime: string read FStartTime write SetStartTime;
    property StepTime: string read FStepTime write SetStepTime;
    property OnTimeChanged: TTimeChangedEvent read FOnTimeChanged write FOnTimeChanged;
  end;

  { TFileBtn }

  TFileBtnOption = (fboOnlyFilename        // Pfad nicht nach Filename übernehmen
                   );
  TFileBtnOptions = set of TFileBtnOption;

  TFileBtn = class(TBitBtn)
  private
    { Private-Deklarationen }
    FEdit: TCustomEdit;
    FFilename: string;
    FBeforeClick: TNotifyEvent;
    FOpenDialog: TOpenDialog;
    fInitialDir: string;
    fFilter: string;
    fOptions: TFileBtnOptions;
    function GetDBEdit: TDBEdit;
    function GetFilename: string;
    procedure SetFilename(const Value: string);
  protected
    { Protected-Deklarationen }
    procedure SetName(const Value: TComponentName); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
    property Filename: string read GetFilename write SetFilename;
  published
    { Published-Deklarationen }
    { TODO : Eigenschaften von TOpenDialog ergänzen }
    property DBEdit: TCustomEdit read FEdit write FEdit;
    property Filter: string read fFilter write fFilter;
    property InitialDir: string read fInitialDir write fInitialDir;
    property Options: TFileBtnOptions read fOptions write fOptions;
    property TabStop default false;
    property BeforeClick: TNotifyEvent read FBeforeClick write FBeforeClick;
  end;

  TDirBtn = class(TBitBtn)
  private
    { Private-Deklarationen }
    FEdit: TCustomEdit;
    FDirname: string;
    FBeforeClick: TNotifyEvent;
    JvBrowseForFolderDialog: TJvBrowseForFolderDialog;
    function GetDBEdit: TDBEdit;
    function GetDirname: string;
    procedure SetDirname(const Value: string);
  protected
    { Protected-Deklarationen }
    procedure SetName(const Value: TComponentName); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
    property Dirname: string read GetDirname write SetDirname;
  published
    { Published-Deklarationen }
    property DBEdit: TCustomEdit read FEdit write FEdit;
    property TabStop default false;
    property BeforeClick: TNotifyEvent read FBeforeClick write FBeforeClick;
  end;

  { TOpenBtn }

  TOpenBtnOption = (obWait        // warten bis Editor beendet.
                   );
  TOpenBtnOptions = set of TOpenBtnOption;

  TOpenBtn = class(TBitBtn)
  private
    { Private-Deklarationen }
    FEdit: TCustomEdit;
    FFilename: string;
    FBeforeClick: TNotifyEvent;
    fInitialDir: string;
    fOptions: TOpenBtnOptions;
    function GetDBEdit: TDBEdit;
    function GetFilename: string;
    procedure SetFilename(const Value: string);
  protected
    { Protected-Deklarationen }
    procedure SetName(const Value: TComponentName); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
    property Filename: string read GetFilename write SetFilename;
  published
    { Published-Deklarationen }
    property DBEdit: TCustomEdit read FEdit write FEdit;
    property InitialDir: string read fInitialDir write fInitialDir;
    property Options: TOpenBtnOptions read fOptions write fOptions;
    property TabStop default false;
    property BeforeClick: TNotifyEvent read FBeforeClick write FBeforeClick;
  end;

  TDlgDatum = class(TForm)
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    Cal: TCalendar;
    BtnPrevMonth: TSpeedButton;
    BtnNextMonth: TSpeedButton;
    BtnHeute: TBitBtn;
    LaKw1: TLabel;
    LaKw2: TLabel;
    LaKw3: TLabel;
    LaKw4: TLabel;
    LaKw5: TLabel;
    LaKw6: TLabel;
    Bevel1: TBevel;
    BtnPrevYear: TSpeedButton;
    BtnNextYear: TSpeedButton;
    BtnKW: TButton;
    cobMonth: TComboBox;
    cobYear: TComboBox;
    procedure CalChange(Sender: TObject);
    procedure BtnPrevMonthClick(Sender: TObject);
    procedure BtnNextMonthClick(Sender: TObject);
    procedure BtnHeuteClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnPrevYearClick(Sender: TObject);
    procedure BtnNextYearClick(Sender: TObject);
    procedure CalDblClick(Sender: TObject);
    procedure BtnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure cobChange(Sender: TObject);
  private
    { Private declarations }
    procedure Poll(Sender: TObject);
  public
    { Public declarations }
    class function Run(var ADate: TDateTime; SubTitle: string): integer;
  end;

var
  DlgDatum: TDlgDatum;

function DayOfYear(ADate: TDateTime): integer;
function KwOfDate(ADate: TDateTime): integer;
function TagderWoche(Date: TDateTime): Integer;

const
  HoursPerDay = 24;
  MinutesPerDay = 24 * 60;

implementation
{$R *.RES}           (* Resource 'DATUMBTN' in DATUMDLG.RES *)
{$R *.DFM}
uses
   Uni, DBAccess, MemDS, Db,
  Err__Kmp, Poll_Kmp, GNav_Kmp, KmpResString;
const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}

(* Datum Button *************************************************************)

constructor TDatumBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Glyph.Handle := LoadBitmap(HInstance, 'DATUMBTN');
  try    NumGlyphs := IMax(1, Glyph.Width div Glyph.Height);
  except NumGlyphs := 1;
  end;
  Width := 21;
  Height := 21;
  Caption := '';
  if not (csLoading in ComponentState) then
    TabStop := false;
end;

function TDatumBtn.GetDatum: TDateTime;
var
  AYear, AMonth, ADay: word;
begin
  if (Year = 0) and (Month = 0) and (Day = 0) then
  begin
    DecodeDate(date, aYear, aMonth, aDay);
    Year := AYear;
    Month := AMonth;
    Day := ADay;
  end;
  try
    result := EncodeDate(Year, Month, Day);
  except
    result := date;
    DecodeDate(result, aYear, aMonth, aDay);
    Year := AYear;
    Month := AMonth;
    Day := ADay;
  end;
end;

procedure TDatumBtn.SetDatum(Value: TDateTime);
var
  AYear, AMonth, ADay: word;
begin
  DecodeDate(Value, AYear, AMonth, ADay);
  Year := AYear;
  Month := AMonth;
  Day := ADay;

  if FEdit <> nil then
  begin
    if GetDBEdit <> nil then
    begin
      GetDBEdit.DataSource.Edit; {Edit ruft die Methode Edit der Datenmenge auf, wenn AutoEdit True und State dsBrowse ist.}
      {SendChar(FEdit, DateToStr(ADatum));    {auch für Getdbedit falls Autoedit}
      if GetDBEdit.DataSource.State in dsEditModes then
        if Value = 0 then
          GetDBEdit.Field.Clear else
          GetDBEdit.Field.AsDateTime := Value;
    end else
      if Value = 0 then
        FEdit.Text := '' else
      if FFormat <> '' then
        FEdit.Text := FormatDateTime(FFormat, Value) else
        FEdit.Text := DateToStrY2(Value);
  end;
  {DecodeDate(ADatum, FYear, FMonth, FDay);}
end;

procedure TDatumBtn.SetName(const Value: TComponentName);
begin
  inherited SetName(Value);
  Caption := '';
end;

function TDatumBtn.GetDBEdit: TDBEdit;
begin
  if FEdit is TDBEdit then
    result := TDBEdit(FEdit) else
    result := nil;
end;

procedure TDatumBtn.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FEdit) then
    FEdit := nil;
  inherited Notification(AComponent, Operation);
end;

procedure TDatumBtn.Click;
var
  ADatum: TDateTime;
  {Btn: integer;}
  S1: string;
  I: integer;
begin
  if assigned(FBeforeClick) then
    FBeforeClick(self);
  if FEdit <> nil then
  try
    if GetDBEdit <> nil then
    begin
      {if (GetDBEdit.Field <> nil) and not (GetDBEdit.Field.IsNull) then}
      if (GetDBEdit.Field <> nil) and (GetDBEdit.Text <> '') then
        ADatum := FieldAsDate(GetDBEdit.Field) else
        ADatum := Date;
    end else
    if FEdit.Text = '' then
      ADatum := Date else
      ADatum := StrToDateTol(FEdit.Text);    {Wochentag usw. weg}
    (*try
      S1 := FEdit.Text;
      while not IsNum(S1[1]) do              {Wochentag usw. weg}
        System.Delete(S1, 1, 1);
      ADatum := StrToDateY2(S1);
    except on E:Exception do
      begin
        EProt(self, E, 'Click', [0]);
        ADatum := date;
      end;
    end;*)
  except on E:Exception do
    begin
      EProt(self, E, 'Click', [0]); //ErrWarn('%s',[E.Message]);
      ADatum := Date;
    end;
  end else
  try
    ADatum := EncodeDate(Year, Month, Day);
  except
    ADatum := Date;
  end;
  S1 := '';
  if Owner <> nil then
    for I := 0 to TForm(Owner).ComponentCount - 1 do
      if TForm(Owner).Components[I] is TLabel then
        with TForm(Owner).Components[I] as TLabel do
          if (FocusControl = self) or
             ((FocusControl = FEdit) and (FEdit <> nil)) then
          begin
            S1 := RemoveAccelChar(Caption);
            break;
          end;

  ModalResult := TDlgDatum.Run(ADatum, S1);
  if ModalResult = mrOK then
  begin
    if FEdit <> nil then
    begin
      if FEdit.CanFocus then
        FEdit.SetFocus;
      FEdit.SelectAll;
    end;
    Datum := ADatum;
  end;
  inherited Click;
end;

(* Time Spin *************************************************************)

procedure TTimeSpin.SetStartTime(Value: string);
var
  ATime: TDateTime;
begin
  try
    ATime := StrToTime(Value);
    FStartTime := FormatDateTime('hh:nn', ATime);
    FActualTime := FStartTime;
  except on E:Exception do
    ErrException(self, E);
  end;
end;

procedure TTimeSpin.SetStepTime(Value: string);
var
  ATime: TDateTime;
begin
  try
    ATime := StrToTime(Value);
    FStepTime := FormatDateTime('hh:nn', ATime);
  except on E:Exception do
    ErrException(self, E);
  end;
end;

function TTimeSpin.GetDBEdit: TDBEdit;
begin
  if FEdit is TDBEdit then
    result := TDBEdit(FEdit) else
    result := nil;
end;

constructor TTimeSpin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 21;
  Height := 21;
  TabStop := false;
  FStartTime := '12:00';
  FStepTime := '01:00';
end;

procedure TTimeSpin.Loaded;
begin
  inherited Loaded;
  OnDownClick := NewDownClick;
  OnUpClick := NewUpClick;
end;

procedure TTimeSpin.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FEdit) then
    FEdit := nil;
  inherited Notification(AComponent, Operation);
end;

procedure TTimeSpin.NewTime(Modus: TPlusMinus);
var
  ATime: TDateTime;
  AStepTime: TDateTime;
  AHour, AMin, ASec, AMSec: word;
  First: boolean;
begin
  first := false;
  try
    if FEdit = nil then
    begin
      first := FActualTime = '';
      ATime := StrToTime(FActualTime);
    end else
    if GetDBEdit <> nil then
    try
      if GetDBEdit.Field.IsNull then
      begin
        first := true;
        ATime := StrToTime(StartTime);
      end else
        {if GetDBEdit.Field is TDateTimeField then
           ATime := TDateTimeField(GetDBEdit.Field).AsDateTime else}
          ATime := FieldAsTime(GetDBEdit.Field);      {jetzt auch mit TStringField OK}
    except
      first := true;
      ATime := StrToTime(StartTime);
    end else
    if FEdit.Text = '' then
    begin
      first := true;
      ATime := StrToTime(StartTime);
    end else
    try
      ATime := StrToTime(FEdit.Text)
    except
      first := true;
      ATime := StrToTime(StartTime);
    end;
    if not first then
    begin
      AStepTime := StrToTime(StepTime);
      DecodeTime(AStepTime, AHour, AMin, ASec, AMSec);
      if Modus = pmMinus then
        TimeInc(ATime, -AHour, -AMin, -ASec) else
        TimeInc(ATime, AHour, AMin, ASec);
    end;
    FActualTime := TimeToStr(ATime);
    if FEdit <> nil then
    begin
      if FEdit.CanFocus then
        FEdit.SetFocus;
      FEdit.SelectAll;
      SendChar(FEdit, copy(FActualTime,1,5));
      if GetDBEdit = nil then
      begin
        if (FEdit is TEdit) and (TEdit(FEdit).MaxLength > 0) then
          FEdit.Text := copy(FActualTime, 1, TEdit(FEdit).MaxLength) else
          FEdit.Text := FActualTime;
      end else
        if GetDBEdit.MaxLength > 0 then
          GetDBEdit.Field.Text := copy(FActualTime, 1, GetDBEdit.MaxLength) else
          GetDBEdit.Field.Text := FActualTime;
    end;
    if Assigned(FOnTimeChanged) then
      FOnTimeChanged(self, ATime);                 {Ereignis aufrufen}
  except on E:Exception do
    ErrException(self, E);
  end;
end;

procedure TTimeSpin.NewDownClick(Sender: TObject);
begin
  NewTime(pmMinus);
end;

procedure TTimeSpin.NewUpClick(Sender: TObject);
begin
  NewTime(pmPlus);
end;

(* Datum Dialog *************************************************************)

class function TDlgDatum.Run(var ADate: TDateTime; SubTitle: string): integer;
(* OK = mrOK *)
begin
  with TDlgDatum.Create(Application.MainForm) do
  try
    if SubTitle <> '' then
      Caption := SubTitle;
    try    Cal.CalendarDate := ADate;
    except Cal.CalendarDate := date;
    end;
    //Caption := LongCaption(Caption, SubTitle);
    result := ShowModal;
    ADate := Cal.CalendarDate;
  finally
    Release;
  end;
end;

procedure TDlgDatum.FormCreate(Sender: TObject);
var
  I: integer;
begin
  cobMonth.Items.Clear;
  GNavigator.TranslateForm(self);
  for I := 1 to 12 do
    cobMonth.Items.Add(FormatSettings.LongMonthNames[I]);
  cobYear.Items.Clear;
  for I := ExtractYear(Date) - 10 to ExtractYear(Date) + 10 do
    cobYear.Items.Add(IntToStr(I));
end;

procedure TDlgDatum.cobChange(Sender: TObject);
var
  AYear, AMonth, ADay: word;
  LastDay: boolean;
begin
  try
    DecodeDate(Cal.CalendarDate, AYear, AMonth, ADay);
    LastDay := ADay = DaysOfMonth(AYear, AMonth);
    AYear := StrToInt(cobYear.Text);
    if AYear < 1000 then
      // EError('Bitte 4stelliges Datum eingeben', [0]) else
      EError(SDatumDlg_001, [0]) else
      SMess0;
    AMonth := cobMonth.ItemIndex + 1;
    if LastDay then
      ADay := DaysOfMonth(AYear, AMonth) else
      ADay := IMin(ADay, DaysOfMonth(AYear, AMonth));
    Cal.CalendarDate := EncodeDate(AYear, AMonth, ADay);          {ruft CalChange}
  except on E:Exception do
    SMess('%s', [E.Message]);
    {Bediener gibt gerade die Ziffern eines Jahres ein}
  end;
end;

procedure TDlgDatum.CalDblClick(Sender: TObject);
begin
  ModalResult := BtnOK.ModalResult;
end;

procedure TDlgDatum.CalChange(Sender: TObject);
var
  Dow, Dom, I, N: integer;
  AYear, AMonth, ADay: word;
  ADate: TDateTime;
begin
  cobYear.Text := FormatDateTime('yyyy', Cal.CalendarDate);
  {cobMonth.Text := FormatDateTime('mmmm', Cal.CalendarDate);}
  I := cobYear.Items.IndexOf(cobYear.Text);
  if I >= 0 then
    cobYear.ItemIndex := I;
  cobMonth.ItemIndex := cobMonth.Items.IndexOf(FormatDateTime('mmmm', Cal.CalendarDate));
  BtnHeute.Enabled := (Cal.CalendarDate <> Date);

  DecodeDate(Cal.CalendarDate, AYear, AMonth, ADay);
  ADate := EncodeDate(AYear, AMonth, 1);
  //Kw1 := KwOfDate(ADate);
  Dow := DayOfWeek(ADate);
  Dom := DaysOfMonth(AYear, AMonth);
  if ((Dow = 7) and (Dom >= 31)) or       {Sa}
     ((Dow = 1) and (Dom >= 30)) then     {So}
    N := 6 else
    N := 5;
  for I:= 1 to N do
    (FindComponent(Format('LaKw%d',[I])) as TLabel).Caption :=
      Format('%02.2d', [KwOfDate(ADate + 7*(I-1))]); //[Kw1 + I - 1]);
  for I:= N+1 to 6 do
    (FindComponent(Format('LaKw%d',[I])) as TLabel).Caption := '';
  SMess('%s', [DateToStr(Cal.CalendarDate)]);
  Caption := LongCaption(Caption, DateToStr(Cal.CalendarDate));
end;

procedure TDlgDatum.BtnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PollKmp.Add(Poll, TComponent(Sender), InitRepeatPause);
end;

procedure TDlgDatum.BtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PollKmp.Sub(Poll, TComponent(Sender));
end;

procedure TDlgDatum.Poll(Sender: TObject);
begin
  PollKmp.SetPeriod(Poll, TComponent(Sender), RepeatPause);
  {smess('%s D(%d) C(%d)', [TSpeedButton(Sender).Name, ord(TSpeedButton(Sender).Down), ord(MouseCapture)]);}
  {if (TSpeedButton(Sender).Down) and MouseCapture then}
  begin
    try
      TSpeedButton(Sender).Click;
    except
      PollKmp.Sub(Poll, TComponent(Sender));
      raise;
    end;
  end;
end;

procedure TDlgDatum.BtnPrevMonthClick(Sender: TObject);
begin
  Cal.PrevMonth;
  GNavigator.ProcessMessages;   {warten bis angezeigt}
end;

procedure TDlgDatum.BtnNextMonthClick(Sender: TObject);
begin
  Cal.NextMonth;
end;

procedure TDlgDatum.BtnPrevYearClick(Sender: TObject);
begin
  Cal.PrevYear;
end;

procedure TDlgDatum.BtnNextYearClick(Sender: TObject);
begin
  Cal.NextYear;
end;

procedure TDlgDatum.BtnHeuteClick(Sender: TObject);
begin
  Cal.CalendarDate := Date;
end;

procedure TDlgDatum.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_PRIOR) and (ssCtrl in Shift) then  //Bild auf
  begin
    Key := 0;
    Cal.PrevYear;
  end else
  if (Key = VK_NEXT) and (ssCtrl in Shift) then   //Bild ab
  begin
    Key := 0;
    Cal.NextYear;
  end else
  if Key = VK_PRIOR then
  begin
    Key := 0;
    BtnPrevMonthClick(self);
  end else
  if Key = VK_NEXT then
  begin
    Key := 0;
    BtnNextMonthClick(self);
  end;
end;

(*** KW Hilfsfunktionen *****************************************************)

function DayOfYear(ADate: TDateTime): integer;
var
  AYear, AMonth, ADay, I: word;
begin
  result := 0;
  DecodeDate(ADate, AYear, AMonth, ADay);
  for I:= 1 to AMonth-1 do
    result := result + DaysOfMonth(AYear, I);
  result := result + ADay;
end;

function TagderWoche(Date: TDateTime): Integer;
(* ergibt Wochentag entspr. DayofWeek, aber: Mo=0,Di=1,..Sa=5,So=6    quku*)
begin
  result := (DayOfWeek(Date) + 5) mod 7;   {1->6, 2->0, 3->1,..,7->5}
end;

function KwOfDate(ADate: TDateTime): integer;
var
  AYear, AMonth, ADay: word;
  Doy, Offset: integer;
  TmpDate: TDateTime;
begin
  Doy := DayOfYear(ADate);
  DecodeDate(ADate, AYear, AMonth, ADay);
  TmpDate := EncodeDate(AYear, 1, 1);
  Offset := TagderWoche(TmpDate);         {Mo=0,Di=1,..Sa=5,So=6}
  result := ((Doy + Offset - 1) div 7) + 1;
  if Offset >= 4 then
  begin //1.Woche hat keine 4 Tage -> 53
    result := result - 1;
    if result = 0 then
      result := 53;
  end;
end;


{ TFileBtn }

constructor TFileBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOpenDialog := TOpenDialog.Create(self);
  Glyph.Handle := LoadBitmap(HInstance, 'FILEBTN');
  try    NumGlyphs := IMax(1, Glyph.Width div Glyph.Height);
  except NumGlyphs := 1;
  end;
  Width := 21;
  Height := 21;
  Caption := '';
  if not (csLoading in ComponentState) then
    TabStop := false;
end;

destructor TFileBtn.Destroy;
begin
  FOpenDialog.Free;
  inherited Destroy;
end;

procedure TFileBtn.Click;
var
  S1: string;
  I: integer;
begin
  Prot0('%s.Click', [OwnerDotName(self)]);
  if assigned(FBeforeClick) then
    FBeforeClick(self);
  S1 := Hint;
  if (S1 = '') and (Owner <> nil) then
    for I := 0 to TForm(Owner).ComponentCount - 1 do
      if TForm(Owner).Components[I] is TLabel then
        with TForm(Owner).Components[I] as TLabel do
          if (FocusControl = self) or
             ((FocusControl = FEdit) and (FEdit <> nil)) then
          begin  //Caption vom Label mit FocusControl
            S1 := RemoveAccelChar(Caption);
            break;
          end;
  if S1 <> '' then
    FOpenDialog.Title := S1;
  FOpenDialog.Filename := Filename;
  FOpenDialog.Filter := Filter;
  FOpenDialog.InitialDir := InitialDir;
  if FOpenDialog.Execute then
  begin
    ModalResult := mrOK;
    if FEdit <> nil then
    begin
      if FEdit.CanFocus then
        FEdit.SetFocus;
      FEdit.SelectAll;
    end;
    if fboOnlyFilename in Options then
      Filename := ExtractFileName(FOpenDialog.Filename) else
      Filename := FOpenDialog.Filename;
  end else
    ModalResult := mrCancel;
  inherited Click;  //mit OnClick Ereignis
end;

function TFileBtn.GetDBEdit: TDBEdit;
begin
  if FEdit is TDBEdit then
    result := TDBEdit(FEdit) else
    result := nil;
end;

function TFileBtn.GetFilename: string;
begin
  FFilename := '';
  if FEdit <> nil then
  try
    if GetDBEdit <> nil then
    begin
      if GetDBEdit.Field <> nil then
        FFilename := GetDBEdit.Field.AsString;
    end else
    if FEdit.Text <> '' then
      FFilename := FEdit.Text;
  except on E:Exception do
    EProt(self, E, 'GetFilename', [0]);
  end;
  result := FFilename;
end;

procedure TFileBtn.SetFilename(const Value: string);
begin
  if FFilename <> Value then
  begin
    Prot0('%s %s <-- %s', [OwnerDotName(self), Value, FFilename]);
    FFilename := Value;
    if FEdit <> nil then
    try
      if GetDBEdit <> nil then
      begin
        GetDBEdit.DataSource.Edit; {Edit ruft die Methode Edit der Datenmenge auf, wenn AutoEdit True und State dsBrowse ist.}
        if GetDBEdit.DataSource.State in dsEditModes then
          if Value = '' then
            GetDBEdit.Field.Clear else
            GetDBEdit.Field.AsString := Value;
      end else
        FEdit.Text := Value;
    except on E:Exception do
      EProt(self, E, 'SetFilename(%s)', [Value]);
    end;
  end;
end;

procedure TFileBtn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FEdit) then
    FEdit := nil;
  inherited Notification(AComponent, Operation);
end;

procedure TFileBtn.SetName(const Value: TComponentName);
var
  OldCaption: string;
begin
  OldCaption := Caption;
  inherited SetName(Value);
  Caption := OldCaption;
end;

{ TOpenBtn }

procedure TOpenBtn.Click;
var
  S1: string;
begin
  Prot0('%s.Click', [OwnerDotName(self)]);
  GetFilename;  //setzt FFilename
  if assigned(FBeforeClick) then
    FBeforeClick(self);  //EAbort wenn fertig. Kann Filename setzen

  if InitialDir <> '' then
    S1 := ValidDir(InitialDir) + ExtractFilename(FFileName) else
    S1 := FFileName;
  SysParam.ThrowWinExecError := false;
  SysParam.DisplayWinExecError := true;
  if obWait in Options then
    ShellExecAndWait(S1) else
    ShellExecNoWait(S1);
  inherited Click;  //mit OnClick Ereignis
end;

constructor TOpenBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Glyph.Handle := LoadBitmap(HInstance, 'OPENBTN');
  try    NumGlyphs := IMax(1, Glyph.Width div Glyph.Height);
  except NumGlyphs := 1;
  end;
  Width := 21;
  Height := 21;
  Caption := '';
  if not (csLoading in ComponentState) then
    TabStop := false;
end;

destructor TOpenBtn.Destroy;
begin
  inherited Destroy;
end;

function TOpenBtn.GetDBEdit: TDBEdit;
begin
  if FEdit is TDBEdit then
    result := TDBEdit(FEdit) else
    result := nil;
end;

function TOpenBtn.GetFilename: string;
begin
  FFilename := '';
  if FEdit <> nil then
  try
    if GetDBEdit <> nil then
    begin
      if GetDBEdit.Field <> nil then
        FFilename := GetDBEdit.Field.AsString;
    end else
    if FEdit.Text <> '' then
      FFilename := FEdit.Text;
  except on E:Exception do
    EProt(self, E, 'GetFilename', [0]);
  end;
  result := FFilename;
end;

procedure TOpenBtn.SetFilename(const Value: string);
//Filename auf einen anderen Wert setzen. Nur in OnBeforeClick.
begin
  FFilename := Value;
end;

procedure TOpenBtn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FEdit) then
    FEdit := nil;
  inherited Notification(AComponent, Operation);
end;

procedure TOpenBtn.SetName(const Value: TComponentName);
var
  OldCaption: string;
begin
  OldCaption := Caption;
  inherited SetName(Value);
  Caption := OldCaption;
end;

{ TDirBtn }

procedure TDirBtn.Click;
var
  S1: string;
  I: integer;
begin
  Prot0('%s.Click', [OwnerDotName(self)]);
  if assigned(FBeforeClick) then
    FBeforeClick(self);
  S1 := Hint;
  if (S1 = '') and (Owner <> nil) then
    for I := 0 to TForm(Owner).ComponentCount - 1 do
      if TForm(Owner).Components[I] is TLabel then
        with TForm(Owner).Components[I] as TLabel do
          if (FocusControl = self) or
             ((FocusControl = FEdit) and (FEdit <> nil)) then
          begin  //Caption vom Label mit FocusControl
            S1 := RemoveAccelChar(Caption);
            break;
          end;
  if S1 <> '' then
    JvBrowseForFolderDialog.Title := S1;
  JvBrowseForFolderDialog.Directory := DirName;
  if JvBrowseForFolderDialog.Execute then
  begin
    ModalResult := mrOK;
    if FEdit <> nil then
    begin
      if FEdit.CanFocus then
        FEdit.SetFocus;
      FEdit.SelectAll;
    end;
    Dirname := JvBrowseForFolderDialog.Directory;
  end else
    ModalResult := mrCancel;
  inherited Click;  //mit OnClick Ereignis
end;

constructor TDirBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  JvBrowseForFolderDialog := TJvBrowseForFolderDialog.Create(self);
  Glyph.Handle := LoadBitmap(HInstance, 'OPENBTN');   //DIRBTN
  try    NumGlyphs := IMax(1, Glyph.Width div Glyph.Height);
  except NumGlyphs := 1;
  end;
  Width := 21;
  Height := 21;
  Caption := '';
  if not (csLoading in ComponentState) then
    TabStop := false;
end;

destructor TDirBtn.Destroy;
begin
  JvBrowseForFolderDialog.Free;
  inherited Destroy;
end;

function TDirBtn.GetDBEdit: TDBEdit;
begin
  if FEdit is TDBEdit then
    result := TDBEdit(FEdit) else
    result := nil;
end;

function TDirBtn.GetDirname: string;
begin
  FDirname := '';
  if FEdit <> nil then
  try
    if GetDBEdit <> nil then
    begin
      if GetDBEdit.Field <> nil then
        FDirname := GetDBEdit.Field.AsString;
    end else
    if FEdit.Text <> '' then
      FDirname := FEdit.Text;
  except on E:Exception do
    EProt(self, E, 'GetDirname', [0]);
  end;
  result := FDirname;
end;

procedure TDirBtn.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FEdit) then
    FEdit := nil;
  inherited Notification(AComponent, Operation);
end;

procedure TDirBtn.SetDirname(const Value: string);
begin
  if FDirname <> Value then
  begin
    Prot0('%s %s <-- %s', [OwnerDotName(self), Value, FDirName]);
    FDirname := Value;
    if FEdit <> nil then
    try
      if GetDBEdit <> nil then
      begin
        GetDBEdit.DataSource.Edit; {Edit ruft die Methode Edit der Datenmenge auf, wenn AutoEdit True und State dsBrowse ist.}
        if GetDBEdit.DataSource.State in dsEditModes then
          if Value = '' then
            GetDBEdit.Field.Clear else
            GetDBEdit.Field.AsString := Value;
      end else
        FEdit.Text := Value;
    except on E:Exception do
      EProt(self, E, 'SetDirname(%s)', [Value]);
    end;
  end;
end;

procedure TDirBtn.SetName(const Value: TComponentName);
var
  OldCaption: string;
begin
  OldCaption := Caption;
  inherited SetName(Value);
  Caption := OldCaption;
end;

end.
