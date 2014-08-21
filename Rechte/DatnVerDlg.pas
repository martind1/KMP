unit DatnVerDlg;
(* Dialog zum Verteilen der Programmversion auf mehrere Datenbanken
   Frontend zu Komponente DatnVer Komponente

xx.xx.13 md  erstellt
10.04.14 md  Kommentare
*)
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Datn_Kmp,
  Data.DB, DBAccess, Uni, UDB__Kmp, Vcl.ExtCtrls,
  DatumDlg;

type
  TDlgDatnVer = class(TForm)
    Panel4: TPanel;
    LaZip: TLabel;
    EdZip: TEdit;
    BtnZip: TFileBtn;
    Panel5: TPanel;
    GroupBox2: TGroupBox;
    lbProt: TListBox;
    LaApp: TLabel;
    EdApp: TEdit;
    EdVersion: TEdit;
    LaVersion: TLabel;
    Panel1: TPanel;
    Panel3: TPanel;
    BtnStart: TBitBtn;
    BtnClose: TBitBtn;
    gbVerteilen: TGroupBox;
    Label1: TLabel;
    cobAlias: TComboBox;
    BtnAdd: TBitBtn;
    BtnSub: TBitBtn;
    lbAlias: TListBox;
    MeComment: TMemo;
    procedure BtnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnSubClick(Sender: TObject);
    procedure BtnZipClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure cobAliasClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Started: boolean;
    Kurz: string;
    procedure DatnVerCallback(S: string);
    procedure CheckVersion;
    procedure SaveToIni;
  public
    { Public-Deklarationen }
    class function Execute: boolean;
  end;

var
  DlgDatnVer: TDlgDatnVer;

implementation
{$R *.dfm}
uses
  WinTools, Zip,
  Prots, USes_Kmp, Ini__Kmp, Err__Kmp,
  DatnVer;

class function TDlgDatnVer.Execute: boolean;
begin
  with TDlgDatnVer.Create(Application) do
  try
    ShowModal;
    Result := Started;
  finally
    Close;
  end;
end;

procedure TDlgDatnVer.FormCreate(Sender: TObject);
var
  InternalName, FileVersion: string;
begin
  DlgDatnVer := self;
  Kurz := 'DatnVer';
  GetFileInfo(InternalName, FileVersion, Application.Exename);
  EdApp.Text := UpperCase(InternalName);
  EdVersion.Text := FileVersion;
  USession.GetAliasNames(cobAlias.Items);  //Alias Liste
  cobAlias.Text := IniKmp.ReadString(Kurz, cobAlias.Name, Sysparam.Alias);
  EdZip.Text := IniKmp.ReadString(Kurz, EdZip.Name, Format('%s_%s.zip', [
                                  InternalName, FileVersion]));
  IniKmp.GetSectionStrings(Kurz+'.'+lbAlias.Name, lbAlias.Items);
  //besser nicht wg fehlender Unicodeunterstützung IniKmp.ReadSectionValues(Kurz+'.'+MeComment.Name, MeComment.Lines);
  CheckVersion;
end;

procedure TDlgDatnVer.SaveToIni;
begin
  IniKmp.WriteString(Kurz, EdZip.Name, EdZip.Text);
  IniKmp.WriteString(Kurz, cobAlias.Name, cobAlias.Text);
  //IniKmp.ReplaceSection(Kurz+'.'+lbAlias.Name, lbAlias.Items);
  IniKmp.EraseSection(Kurz+'.'+lbAlias.Name);
  IniKmp.WriteSectionStrings(Kurz+'.'+lbAlias.Name, lbAlias.Items);  //ergänzt Zähler+'='
  IniKmp.ReplaceSection(Kurz+'.'+MeComment.Name, MeComment.Lines);
end;

procedure TDlgDatnVer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDlgDatnVer.FormDestroy(Sender: TObject);
begin
  DlgDatnVer := nil;
end;

procedure TDlgDatnVer.FormResize(Sender: TObject);
begin                        //176 - 113 = 63
  lbAlias.Height := gbVerteilen.Height - 63;
  MeComment.Width := MeComment.Parent.Width - MeComment.Left - 8;
end;

procedure TDlgDatnVer.BtnZipClick(Sender: TObject);
begin
  BtnZip.InitialDir := ExtractFilepath(EdZip.Text);
  SaveToIni;
  //BtnZip.ModalResult := mrNone;  //bringt nix
  self.ModalResult := mrNone;
  CheckVersion;
end;

procedure TDlgDatnVer.cobAliasClick(Sender: TObject);
begin
//Nein. Schlechte Experience.  PostMessage(self.Handle, WM_COMMAND, 0, BtnAdd.Handle);
end;

procedure TDlgDatnVer.BtnAddClick(Sender: TObject);
begin
  if lbAlias.Items.IndexOf(cobAlias.Text) < 0 then
    lbAlias.Items.Add(cobAlias.Text);
end;

procedure TDlgDatnVer.BtnSubClick(Sender: TObject);
begin
  if lbAlias.ItemIndex >= 0 then
    lbAlias.Items.Delete(lbAlias.ItemIndex);
end;

procedure TDlgDatnVer.EditChange(Sender: TObject);
begin
  BtnStart.Enabled := (EdApp.Text <> '') and (EdVersion.Text <> '') and
                      FileExists(EdZip.Text);
  if EdApp.Text = '' then
    SMess('%s fehlt', [LaApp.Caption]);
  if EdVersion.Text = '' then
    SMess('%s fehlt', [LaVersion.Caption]);
  if not FileExists(EdZip.Text) then
    SMess('%s existiert nicht', [LaZip.Caption]);
end;

procedure TDlgDatnVer.CheckVersion;
var
  NextS: string;
  InternalName, FileVersion: string;
begin
  //ExtractZipFile(BaseDir + Ordner + ZipFilename, BaseDir + Ordner);
  //wenn eine EXE dann nach \APPS\<app>\ entpacken, dabei App=Filename setzen
  //  und Version der EXE lesen
  EdApp.Text := '';
  EdVersion.Text := '';
  if SameText(ExtractFileExt(EdZip.Text), '.ZIP') then
  begin
    EdApp.Text := PStrTok(OnlyFilename(ExtractFilename(EdZip.Text)), '_', NextS);
    EdVersion.Text := PStrTokNext('_', NextS);
  end;
  if SameText(ExtractFileExt(EdZip.Text), '.EXE') then
  begin
    GetFileInfo(InternalName, FileVersion, EdZip.Text);
    EdApp.Text := InternalName;
    EdVersion.Text := FileVersion;
  end;

//Quatsch
//  ZipFile := TZipFile.Create;
//  try
//    ZipFile.Open(EdZip.Text, zmRead);
//    for I := 0 to ZipFile.FileCount - 1 do
//    begin
//      S1 := ExtractFileExt(ZipFile.FileNames[I]);
//      if SameText(S1, '.EXE') then
//      begin
//        EdApp.Text := PStrTok(S1, '_', NextS);
//        EdVersion.Text := PStrTokNext('_', NextS);
//        Done := EdVersion.Text <> '';
//      end;
//    end;
//    if not Done then
//    begin
//      //EError('Falsche Programmdatei in Zip (%s)', [S1]);
//    end;
//  finally
//    ZipFile.Free;
//  end;
end;

procedure TDlgDatnVer.DatnVerCallback(S: string);
begin
  Prot0('%s', [S]);
end;

procedure TDlgDatnVer.BtnCloseClick(Sender: TObject);
begin
  SaveToIni;
end;

procedure TDlgDatnVer.BtnStartClick(Sender: TObject);
var
  DatnVer: TDatnVer;
  I: integer;
  OldLb: TListBox;
begin
  Started := true;
  DatnVer := TDatnVer.Create;
  OldLb := Prot.Listbox;
  try
    try
      Screen.Cursor := crHourGlass;
      Prot.Listbox := lbProt;
      DatnVer.ProtCallback := DatnVerCallback;
      DatnVer.BaseDir := Datn.BaseDir;  //für Make und UploadApp
      DatnVer.App := EdApp.Text;  //InternalName. Zuerst!
      DatnVer.ExeName := Application.ExeName;  //leider nicht möglich weil bereits geöffnet
      DatnVer.DatnVersion := EdVersion.Text;  //GetFileVersion(Application.Exename)
      DatnVer.DatnComment := MeComment.Lines.Text;
      DatnVer.Inputfile := EdZip.Text;  //setzt App und Version. Zip:setzt Exename
      DatnVer.TableName := Datn.Tablename;  //für UploadApp
      DatnVer.Username := SysParam.DbUserName;
      DatnVer.Password := SysParam.DbPassword;

      DatnVer.MakeApp;  //nach lokalem Datn Verzeichnis zippen&version.txt

      //pro Alias:
      if lbAlias.Items.Count = 0 then
      begin
        DatnVer.Alias := cobAlias.Text;
        DatnVer.UploadApp;  //Verteilen auf Fremd DB
      end else
      begin
        cobAlias.Text := '';
        for I := 0 to lbAlias.Items.Count - 1 do
        begin
          DatnVer.Alias := lbAlias.Items[I];
          DatnVer.UploadApp;  //Verteilen auf Fremd DB
        end;
      end;
    except on E:Exception do
      Prot0('%s', [E.Message]);
    end;
  finally
    DatnVer.Free;
    Prot.Listbox := OldLb;
    Screen.Cursor := crDefault;
  end;
end;

end.
