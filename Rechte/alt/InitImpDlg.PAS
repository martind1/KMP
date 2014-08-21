unit InitImpDlg;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, Dialogs, Ini__kmp, IniDbkmp;

type
  TDlgInitImp = class(TForm)
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    GroupBox1: TGroupBox;
    gbNach: TGroupBox;
    Label1: TLabel;
    edAnwendung: TEdit;
    Label2: TLabel;
    edFilename: TEdit;
    btnFilenameDialog: TBitBtn;
    btnFilenameOpen: TBitBtn;
    edMaschine: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EdUser: TEdit;
    LaStatus: TLabel;
    dlgFilename: TOpenDialog;
    chbOverwrite: TCheckBox;
    IniDb1: TIniDbKmp;
    lbSectionTypes: TListBox;
    chbAsk: TCheckBox;
    procedure btnFilenameDialogClick(Sender: TObject);
    procedure btnFilenameOpenClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure edFilenameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure ImportIni(Anwendung, Maschine, User, Filename: string;
      Overwrite, Ask: boolean);
    { Private declarations }
  public
    { Public declarations }
    class function Execute: boolean; overload;
    class function Execute(var Anwendung, Maschine, User, Filename: string): boolean; overload;
  end;

var
  DlgInitImp: TDlgInitImp;

implementation
{$R *.DFM}
uses
  SysUtils, IniFiles,
  Prots,
  InitAskDlg, INITEDFrm;

class function TDlgInitImp.Execute: boolean;
var
  Anwendung, Maschine, User, Filename: string;
begin
  Result := true;
  Anwendung := AnsiUppercase(OnlyFileName(Application.ExeName)); //'QUVA32';
  Maschine := AnsiUppercase(CompName);
  User := Sysparam.Username;
  if IniKmp <> IniDb then
    Filename := IniKmp.FilePath else
    Filename := '';
  if TDlgInitImp.Execute(Anwendung, Maschine, User, Filename) then

end;

class function TDlgInitImp.Execute(var Anwendung, Maschine, User, Filename: string): boolean;
var
  Btn: word;
const
  Kurz: string = 'DlgInitImp';
begin
  DlgInitImp := Create(Application);
  with DlgInitImp do
  begin
    {if Anwendung <> '' then
    begin
      EdAnwendung.Text := Anwendung;
      EdMaschine.Text := Maschine;
      EdUser.Text := User;
      EdFilename.Text := Filename;
      chbOverwrite.Checked := Overwrite;
    end else
    begin
      EdAnwendung.Text := IniKmp.ReadString(Kurz, EdAnwendung.Name, EdAnwendung.Text);
      EdMaschine.Text := IniKmp.ReadString(Kurz, EdMaschine.Name, AnsiUppercase(CompName));
      EdUser.Text := IniKmp.ReadString(Kurz, EdUser.Name, AnsiUppercase(Sysparam.Username));
      EdFilename.Text := IniKmp.ReadString(Kurz, EdFilename.Name, EdFilename.Text);
      chbOverwrite.Checked := IniKmp.ReadBool(Kurz, chbOverwrite.Name, chbOverwrite.Checked);
    end;}
    if Anwendung <> '' then
      EdAnwendung.Text := Anwendung else
      EdAnwendung.Text := IniKmp.ReadString(Kurz, EdAnwendung.Name, EdAnwendung.Text);
    if Maschine <> '' then
      EdMaschine.Text := Maschine else
      EdMaschine.Text := IniKmp.ReadString(Kurz, EdMaschine.Name, AnsiUppercase(CompName));
    if User <> '' then
      EdUser.Text := User else
      EdUser.Text := IniKmp.ReadString(Kurz, EdUser.Name, AnsiUppercase(Sysparam.Username));
    if Filename <> '' then
      EdFilename.Text := Filename else
      EdFilename.Text := IniKmp.ReadString(Kurz, EdFilename.Name, EdFilename.Text);

    EditChange(DlgInitImp);
    Btn := DlgInitImp.ShowModal;
    result := false;
    if Btn = mrOK then
    begin
      result := true;
      Anwendung := EdAnwendung.Text;
      Maschine := EdMaschine.Text;
      User := EdUser.Text;
      Filename := EdFilename.Text;
      //Overwrite := chbOverwrite.Checked;

      IniKmp.SectionTyp[Kurz] := stMaschine;
      IniKmp.WriteString(Kurz, EdAnwendung.Name, EdAnwendung.Text);
      IniKmp.WriteString(Kurz, EdMaschine.Name, EdMaschine.Text);
      if EdUser.Text <> '' then
        IniKmp.WriteString(Kurz, EdUser.Name, EdUser.Text);
      IniKmp.WriteString(Kurz, EdFilename.Name, EdFilename.Text);
      IniKmp.WriteBool(Kurz, chbOverwrite.Name, chbOverwrite.Checked);
      IniKmp.WriteBool(Kurz, chbAsk.Name, chbAsk.Checked);

      ImportIni(Anwendung, Maschine, User, Filename, chbOverwrite.Checked, chbAsk.Checked);
    end;
  end;
  DlgInitImp.Release;
  DlgInitImp := nil;
end;

procedure TDlgInitImp.btnFilenameDialogClick(Sender: TObject);
begin
  with dlgFilename do
  begin
    InitialDir := ExtractFilePath(EdFileName.Text);
    if InitialDir = '' then
      InitialDir := AppDir;
    Title := btnFilenameDialog.Caption;
    FileName := EdFileName.Text;
    if Execute then
      EdFileName.Text := FileName;
  end;
end;

procedure TDlgInitImp.btnFilenameOpenClick(Sender: TObject);
begin
  SysParam.DisplayWinExecError := true;
  ShellExecNoWait(EdFileName.Text, SW_NORMAL);
end;

procedure TDlgInitImp.edFilenameChange(Sender: TObject);
begin
  LaStatus.Visible := not FileExists(EdFilename.Text);
  EditChange(Sender);
end;

procedure TDlgInitImp.EditChange(Sender: TObject);
begin
  btnOK.Enabled := (EdFilename.Text <> '') and
                   (EdAnwendung.Text <> '') and
                   (EdMaschine.Text <> '') and
                   // (EdUser.Text <> '') and
                   not LaStatus.Visible;
end;

procedure TDlgInitImp.ImportIni(Anwendung, Maschine, User, Filename: string;
  Overwrite, Ask: boolean);
//Liest alle Zeilen und importiert
var
  AMemIni: TMemIniFile;
  Sections, Entries: TStringList;
  ASection: string;
  I, I1, N1: integer;
  S1: string;
  ATypChar: char;
  AParam, AValue, OldValue: string;
begin
  IniDb1.Anwendung := Anwendung;
  IniDb1.Maschine := Maschine;
  if User <> '' then
    IniDb1.User := User;
  IniDb1.DbLoad;
  IniDb1.AutoUpdate := false;
  IniDb1.UpLoginParams.Assign(IniDb.UpLoginParams);       //schlieﬂt UpDatabase
  AMemIni := TMemIniFile.Create(Filename);
  Sections := TStringList.Create;
  Entries := TStringList.Create;
  try
    AMemIni.ReadSections(Sections);
    for I := 0 to Sections.Count - 1 do
    begin
      ASection := Sections[I];
      if ASection = '' then
        continue;
      ATypChar := IniDb1.SectionTypChar[ASection];
      AMemIni.ReadSectionValues(ASection, Entries);
      if Entries.Count = 0 then
        continue;
      //if ATypChar = #0 then   beware! wenn irgendein Dolly Ger‰te auf User erfasst hat...! - 07.01.04
      begin
        for I1 := 0 to lbSectionTypes.Items.Count - 1 do
        begin
          S1 := StrParam(lbSectionTypes.Items[I1]);
          if CharN(S1) = '*' then
          begin
            N1 := length(S1) - 1;
            if CompareText(copy(ASection, 1, N1), copy(S1, 1, N1)) = 0 then
              ATypChar := Char1(StrValue(lbSectionTypes.Items[I1]));
          end else
            if CompareText(ASection, S1) = 0 then
              ATypChar := Char1(StrValue(lbSectionTypes.Items[I1]));
        end;
      end;
      if ATypChar in [#0, 'V'] then     //Vorgabe immer fragen
      begin
        if Ask then
        begin
          if not TDlgInitAsk.Execute(ASection, Entries, ATypChar) then
            Sysutils.Abort;
        end else
          ATypChar := 'U';
      end;
      if ATypChar = #0 then
        continue;

      IniDb1.SectionTypChar[ASection] := ATypChar;
      for I1 := 0 to Entries.Count - 1 do
      begin
        AParam := StrParam(Entries[I1]);
        AValue := StrValue(Entries[I1]);
        OldValue := IniDb1.ReadString(ASection, AParam, '');
        if (AValue <> '') and (AValue <> OldValue) and
           (Overwrite or (OldValue = '')) then
        begin
          if (ATypChar = 'U') and (User = '') then
          begin
            //kein User: nicht schreiben
          end else
          begin
            IniDb1.CacheAdd(ASection, StrParam(Entries[I1]), StrValue(Entries[I1]), ATypChar);
          end;
        end;
      end;
    end;
    IniDb1.DbUpdate(false);   //mit SMess
  finally
    AMemIni.Free;
    Sections.Free;
    Entries.Free;
  end;
end;

procedure TDlgInitImp.FormCreate(Sender: TObject);
begin
  if FrmINITED <> nil then
    gbNach.Enabled := FrmINITED.sbTop.Enabled;
end;

end.

