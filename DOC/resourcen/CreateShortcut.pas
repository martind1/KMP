[17.01.12]
http://delphi-kb.blogspot.com/2011/03/create-program-icon-on-desktop-or-in.html

Solve 1:

This is a unit to create a link in any folder you want, including the Windows Desktop:

unit ShellLink;

uses
  SysUtils, ShlObj, OLE2, Windows, Registry;

interface
procedure OLECheck(OleRetVal: HResult);
function GetShellLink: IShellLink;
function GetFolderLocation(const FolderType: string): string;
function ChangeFileExt(FileName, Ext: string): string;
function CreateLink(const AppName, LinkName, Desc, Dest: string): string;

implementation

procedure OLECheck(OleRetVal: HResult);
{Checks the HResult return value of an OLE function.  Raises an exception if value is
something other than S_OK. }
const
  OleErrStr = 'OLE function call failed. HResult is $%x. GetLastError is $%x';
begin
  if OleRetVal <> S_OK then
    raise EShellOleError.CreateFmt(OleErrStr, [OleRetVal, GetLastError]);
end;

function GetShellLink: IShellLink;
{ Returns reference to ISHellLink object }
begin
  OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
    IID_IShellLink, Result));
end;

function GetFolderLocation(const FolderType: string): string;
{ Retrieves from registry path to folder indicated in FolderType }
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    with Reg do
    begin
      RootKey := HKEY_CURRENT_USER;
      if not OpenKey(SFolderKey, False) then
        { Open key where shell folder information is kept }
        raise ERegistryException.CreateFmt('Folder key "%s" not found', [SFolderKey]);
      { Get path for specified folder }
      Result := ReadString(FolderType);
      if Result = '' then
        raise ERegistryException.CreateFmt('"%s" item not found in registry',
          [FolderType]);
      CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

function ChangeFileExt(FileName, Ext: string): string;
var
  aFn: string;
begin
  aFn := ExtractFileName(FileName);
  delete(aFn, length(aFn) - 2, 3);
  aFn := aFn + Ext;
  Result := aFn;
end;

function CreateLink(const AppName, LinkName, Desc, Dest: string): string;
{ Creates a shell link for application or document specified in AppName with description Desc. Link will be located in folder specified by Dest, which is one of the string constants shown at the top of this unit. Returns the full path name of the link file. }
var
  SL: IShellLink;
  PF: IPersistFile;
  LnkName: string;
  WStr: array[0..MAX_PATH - 1] of WideChar;
begin
  SL := GetShellLink;
  try
    { The IShellLink Interface supports the IPersistFile interface. Get an interface pointer to it. }
    OleCheck(SL.QueryInterface(IID_IPersistFile, PF));
    try
      OleCheck(SL.SetPath(PChar(AppName))); {set link path to proper file}
      if Desc <> '' then
        OleCheck(SL.SetDescription(PChar(Desc))); {set description}
      { create a path location and filename for link file }
      LnkName := Dest + '\' + linkName;
      { If you want to create a link to"Desktop", you must call GetFolderLocation('Desktop') }
      { convert the link file pathname to a PWideChar }
      StringToWideChar(LnkName, WStr, MAX_PATH);
      PF.Save(WStr, True); {save link file}
    finally
      PF.Release;
    end;
  finally
    SL.Release;
  end;
  Result := LnkName;
end;
initialization
  OleInitialize(nil);
finalization
  OleUninitialize;

Example:

uses
  shellLink;

var
  lnkName: string;
  FileToInstall: string;
  LinkFile: string;
  comment: string;
  Dest: string; { destination's folder }
begin
  FileToInstall := 'Example.exe';
  LinkFile := 'Example.lnk';
  Comment := 'Link to Example.exe';
  Dest := GetFolderLocation('Desktop')
    lnkName := CreateLink(FileToInstall, LinkFile, Comment, Dest);
end;


(*** Solve 2: ***)

uses
  Registry, ShlObj, ActiveX, ComObj;

type
  ShortcutType = (_DESKTOP, _STARTMENU);

procedure CreateShortcut(FileName: string; Location: ShortcutType);
var
  MyObject: IUnknown;
  MySLink: IShellLink;
  MyPFile: IPersistFile;
  Directory, LinkName: string;
  WFileName: WideString;
  MyReg: TRegIniFile;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  MySLink.SetPath(PChar(FileName));
  MyReg := TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');
  try
    LinkName := ChangeFileExt(FileName, '.lnk');
    LinkName := ExtractFileName(LinkName);
    if Location = _DESKTOP then
    begin
      {Use the next line of code to put the shortcut on your desktop}
      Directory := MyReg.ReadString('Shell Folders', 'Desktop', '');
      WFileName := Directory + '\' + LinkName;
      MyPFile.Save(PWChar(WFileName), False);
    end;
    if Location = _STARTMENU then
    begin
      {Use the next two lines to put the shortcut on your start menu}
      Directory := MyReg.ReadString('Shell Folders', 'Start Menu', '');
      CreateDir(Directory);
      WFileName := Directory + '\' + LinkName;
      MyPFile.Save(PWChar(WFileName), False);
    end;
  finally
    MyReg.Free;
  end;
end;


(*** Solve 3: ***)

{ uses ShlObj, ActiveX, ComObj, SysUtils, etc... }
{ "DestFolder" should be one of the CSIDL_ constants as declared in the ShlObj unit }

procedure CreateProgramShortcut(DestFolder: Integer; const Applic: string);
var
  SL: IShellLink;
  PF: IPersistFile;
  LnkName: WideString;
  FP: array[0..MAX_PATH * 2] of Char;
  IDL: PItemIDList;
begin
  CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER, IShellLink, SL);
  PF := SL as IPersistFile;
  { Make shortcut point to Application.Exename }
  SL.SetPath(PChar(Applic));
  { Set input paramters (if any) }
  { Set default directory to exe-file's location }
  SL.SetWorkingDirectory(PChar(ExtractFilePath(Applic)));
  { Use the exe-file's icon }
  SL.SetIconLocation(PChar(Applic), 0);
  { Just leaving the following fields empty for now. Could be adjusted if the customer must have these set }
  SL.SetArguments('');
  SL.SetDescription('');
  SL.SetShowCmd(0);
  SL.SetHotKey(0);
  { Resolve the path-name of the special folder }
  if SHGetSpecialFolderLocation(0, DestFolder, IDL) = NOERROR then
    SHGetPathFromIDList(IDL, FP);
  { save the file as "Exename.lnk" }
  LnkName := WideString(FP) + '\' + ExtractFilename(ChangeFileExt(Applic, '.lnk'));
  PF.Save(PWideChar(LnkName), True);
end;

//Now you can just paste this procedure into your project and then, the only thing to do is to call something like this:

{ Create a shortcut to current exe on the desktop }
CreateProgramShortcut(CSIDL_DESKTOP, ParamStr(0));
{ Create a shortcut to notepad in the start-menu }
CreateProgramShortcut(CSIDL_STARTMENU, 'c:\windwos\notepad.exe');


(*** Solve 4: ***)

Following code originates from a DragDrop demo of Angus Johnson and Anders Melander:

uses
  ActiveX, ShlObj, ComObj;

{Create a file link}

function CreateLink(SourceFile, ShortCutName: string): string;
var
  IUnk: IUnknown;
  ShellLink: IShellLink;
  IPFile: IPersistFile;
  tmpShortCutName: string;
  WideStr: WideString;
  i: integer;
begin
  IUnk := CreateComObject(CLSID_ShellLink);
  ShellLink := IUnk as IShellLink;
  IPFile := IUnk as IPersistFile;
  with ShellLink do
  begin
    SetPath(PChar(SourceFile));
    SetWorkingDirectory(PChar(ExtractFilePath(SourceFile)));
  end;
  ShortCutName := ChangeFileExt(ShortCutName, '.lnk');
  if FileExists(ShortCutName) then
  begin
    ShortCutName := Copy(ShortCutName, 1, Length(ShortCutName) - 4);
    i := 1;
    repeat
      tmpShortCutName := ShortCutName + '(' + IntToStr(i) + ').lnk';
      Inc(i);
    until
      not FileExists(tmpShortCutName);
    Result := tmpShortCutName;
  end
  else
    Result := ShortCutName;
  WideStr := Result;
  IPFile.Save(PWChar(WideStr), False);
end;

// Usage is similar as with CopyFile but instead of actual copying it, it creates a shortcut to the sourcefile.

// CreateLink('c:\apath\afile.ext', 'c:\anotherpath\afile.ext');


(*** Solve 5: ***)

{Shortcut Component for Delphi 2.0 by Elliott Shevin, Oak Park, Mich. USA
April, 1999
email: shevine@aol.com
version 1.1.

Includes the following corrections:
The Write method doesn't set a hot key if that property is not greater than space.
The correct values are used for ShowCmd.

This component incorporates the shortcut read function of TShellLink by Radek Voltr with shortcut creation code from Jordan Russell, who merits special thanks for reviewing and improving the code.

This is a freeware component. Use it any way you like, but please report errors and improvements to me, and acknowledge Radek and Jordan.}

unit ShortcutLink;

{$IFNDEF VER80}{$IFNDEF VER90}{$IFNDEF VER93}
{$DEFINE Delphi3orHigher}
{$ENDIF}{$ENDIF}{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Forms,
{$IFNDEF Delphi3orHigher}
  OLE2,
{$ELSE}
  ActiveX, ComObj,
{$ENDIF}
  ShellAPI, ShlObj, CommCtrl, StdCtrls;

const
  SLR_NO_UI = $0001;
  SLR_ANY_MATCH = $0002;
  SLR_UPDATE = $0004;
  SLGP_SHORTPATH = $0001;
  SLGP_UNCPRIORITY = $0002;
  Error_Message = 'Unable to create .lnk file';
{$IFDEF Delphi3orHigher}
  IID_IPersistFile: TGUID = (D1: $0000010B; D2: $0000; D3: $0000;
    D4: ($C0, $00, $00, $00, $00, $00, $00, $46));
{$ENDIF}

type
  EShortcutError = class(Exception);
  TShowCmd = (scShowMaximized, scShowMinimized, scShowNormal);

type
  TShortcutLink = class(TComponent)
  private
    { Private declarations }
  protected
    { Protected declarations }
    fShortcutFile, fTarget, fWorkingDir, fDescription, fArguments, fIconLocation:
      string;
    fIconNumber, fHotKey: Word;
    fShowCmd: integer;
    procedure fSetHotKey(c: string);
    function fGetHotKey: string;
    procedure fSetShowCmd(c: TShowCmd);
    function fGetShowCmd: TShowCmd;
    function fGetDesktopFolder: string;
    function fGetProgramsFolder: string;
    function fGetStartFolder: string;
    function fGetStartupFolder: string;
    function fGetSpecialFolder(nFolder: integer): string;
  public
    { Public declarations }
    procedure Read;
    procedure Write;
    property DesktopFolder: string read fGetDesktopFolder;
    property ProgramsFolder: string read fGetProgramsFolder;
    property StartFolder: string read fGetStartFolder;
    property StartupFolder: string read fGetStartupFolder;
  published
    { Published declarations }
    property ShortcutFile: string read fShortcutFile write fShortcutFile;
    property Target: string read fTarget write fTarget;
    property WorkingDir: string read fWorkingDir write fWorkingDir;
    property Description: string read fDescription write fDescription;
    property Arguments: string read fArguments write fArguments;
    property IconLocation: string read fIconLocation write fIconLocation;
    property HotKey: string read fGetHotKey write fSetHotKey;
    property ShowCmd: TShowCmd read fGetShowCmd write fSetShowCmd default
      scShowNormal;
    property IconNumber: Word read fIconNumber write fIconNumber;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Win95', [TShortcutLink]);
end;

{This is the Read method, which reads the link to which fShortcutFile points. It was SetSelfPath in Radek Voltr's TShellLink component, where setting the ShortcutFile property caused the shortcut file to be read immediately.}

procedure TShortcutLink.Read;
var
  X3: PChar;
  hresx: HResult;
  Psl: IShellLink;
  Ppf: IPersistFile;
  Saver: array[0..Max_Path] of WideChar;
  X1: array[0..MAX_PATH - 1] of Char;
  Data: TWin32FindData;
  I, Y: Integer;
  W: Word;
begin
  hresx := CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
{$IFDEF Delphi3orHigher}IID_IShellLinkA
{$ELSE}IID_IShellLink
{$ENDIF}, psl);
  if hresx <> 0 then
    Exit;
  hresx := psl.QueryInterface(IID_IPersistFile, ppf);
  if hresx <> 0 then
    Exit;
  X3 := StrAlloc(MAX_PATH);
  StrPCopy(X3, fShortcutFile);
  MultiByteToWideChar(CP_ACP, 0, X3, -1, Saver, Max_Path);
  hresx := ppf.Load(Saver, STGM_READ);
  if hresx <> 0 then
  begin
    raise EShortcutError.Create('Unable to open link file');
    Exit;
  end;
  hresx := psl.Resolve(0, SLR_ANY_MATCH);
  if hresx <> 0 then
    Exit;
  hresx := psl.GetWorkingDirectory(@X1, MAX_PATH);
  if hresx <> 0 then
  begin
    raise EShortcutError.Create('Error in getting WorkingDir');
    Exit;
  end;
  fWorkingDir := StrPas(@X1);
  hresx := psl.GetPath(@X1, MAX_PATH, Data, SLGP_UNCPRIORITY);
  if hresx <> 0 then
  begin
    raise EShortcutError.Create('Error in getting Target');
    Exit;
  end;
  fTarget := StrPas(@X1);
  hresx := psl.GetIconLocation(@X1, MAX_PATH, I);
  if hresx <> 0 then
  begin
    raise EShortcutError.Create('Error in getting icon data');
    Exit;
  end;
  fIconLocation := StrPas(@X1);
  fIconNumber := I;
  hresx := psl.GetDescription(@X1, MAX_PATH);
  if hresx <> 0 then
  begin
    raise EShortcutError.Create('Error in get Description');
    Exit;
  end;
  fDescription := StrPas(@X1);
  Y := 0;
  hresx := psl.GetShowCmd(Y);
  if hresx <> 0 then
  begin
    raise EShortcutError.Create('Error in getting ShowCmd');
    Exit;
  end;
  fShowCmd := Y;
  W := 0;
  hresx := psl.GetHotKey(W);
  if hresx <> 0 then
  begin
    raise EShortcutError.Create('Error in geting HotKey');
    Exit;
  end;
  fHotKey := W;
  if fHotKey = 0 then
    HotKey := ' '
  else
    HotKey := chr(fHotKey);
  hresx := psl.GetArguments(@X1, MAX_PATH);
  if hresx <> 0 then
  begin
    raise EShortcutError.Create('Error in getting Arguments');
    Exit;
  end;
  fArguments := StrPas(@X1);
{$IFNDEF Delphi3orHigher}
  ppf.release;
  psl.release;
{$ENDIF}
  StrDispose(X3);
end;

{The Write method is adapted from code in Jordan Russell's Inno Setup.}

procedure TShortcutLink.Write;
var
  aISL: IShellLink;
  aIPF: IPersistFile;
{$IFNDEF Delphi3OrHigher}
  aPidl: PItemIDList;
  WideFilename: array[0..MAX_PATH - 1] of WideChar;
{$ELSE}
  Obj: IUnknown;
  WideFilename: WideString;
{$ENDIF}
begin
  {Get an IShellLink interface to make the shortcut. The methods differ between
  Delphi 2 and later releases.}

{$IFNDEF Delphi3OrHigher}
  if not SUCCEEDED(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
    IID_IShellLink, aISL)) then
    raise EShortcutError.Create(Error_Message);
{$ELSE}
  Obj := CreateComObject(CLSID_ShellLink);
  aiSL := Obj as IShellLink;
{$ENDIF}

  try
    {Now we have an IShellLink interface, so we can set it up as we like. Set the target.}
    aISL.SetPath(Pchar(fTarget));
    {Set the working directory ("Start in")}
    aISL.SetWorkingDirectory(PChar(fWorkingDir));
    {Set the command-line params}
    aISL.SetArguments(Pchar(fArguments));
    {Set the description}
    aISL.SetDescription(Pchar(fDescription));
    {Set the show command}
    aISL.SetShowCmd(fShowCmd);
    {Set the hotkey}
    {Vers. 1.1 avoids this command if fHotKey isn't greater than a space.}
    if fHotKey > ord(' ') then
      aISL.SetHotKey(((HOTKEYF_ALT or HOTKEYF_CONTROL) shl 8) or fHotKey);
    {Set the icon location}
    aISL.SetIconLocation(Pchar(fIconLocation), fIconNumber);
    {The shortcut IShellLink is now all set up. We get an IPersistFile interface from it, and use it to save the link. Delphi 2 differs from later releases.}

{$IFNDEF Delphi3OrHigher}
    if aISL.QueryInterface(IID_IPersistFile, aIPF) <> S_OK then
      raise EShortcutError.Create(Error_Message)
    else
      MultiByteToWideChar(CP_ACP, 0, PChar(fShortcutFile), -1, WideFilename,
        MAX_PATH);
{$ELSE}
    aiPF := Obj as IPersistFile;
    WideFilename := fShortcutFile;
{$ENDIF}

    try
{$IFNDEF Delphi3OrHigher}
      if aIPF.Save(WideFilename, True) <> S_OK
{$ELSE}
      if aIPF.Save(PWideChar(WideFilename), True) <> S_OK
{$ENDIF} then
        raise EShortcutError.Create(Error_Message);
    finally
{$IFNDEF Delphi3OrHigher}
      aIPF.Release; {Only needed for D2--later releases do this implicitly.}
{$ENDIF}
    end;

  finally
{$IFNDEF Delphi3OrHigher}
    aISL.Release; {Only needed for D2--later releases do this implicitly.}
{$ENDIF}
  end;
end;

function TShortcutLink.fGetDesktopFolder: string;
begin
  result := fGetSpecialFolder(CSIDL_DESKTOPDIRECTORY);
end;

function TShortcutLink.fGetProgramsFolder: string;
begin
  result := fGetSpecialFolder(CSIDL_PROGRAMS);
end;

function TShortcutLink.fGetStartFolder: string;
begin
  result := fGetSpecialFolder(CSIDL_STARTMENU);
end;

function TShortcutLink.fGetStartupFolder: string;
begin
  result := fGetSpecialFolder(CSIDL_STARTUP);
end;

function TShortcutLink.fGetSpecialFolder(nFolder: integer): string;
var
  aPidl: PItemIDList;
  handle: THandle;
  TC: TComponent;
  fLinkDir: string;
begin
  {Get the folder location (as a PItemIDList)}
  TC := self.owner;
  handle := (TC as TForm).handle;
  if SUCCEEDED(SHGetSpecialFolderLocation(handle, nFolder, aPidl)) then
  begin
    {Get the actual path of the desktop directory from the PItemIDList}
    SetLength(fLinkDir, MAX_PATH); {SHGetPathFromIDList assumes MAX_PATH buffer}
    SHGetPathFromIDList(aPidl, PChar(fLinkDir)); {Do it}
    SetLength(fLinkDir, StrLen(PChar(fLinkDir)));
    result := fLinkDir;
  end;
end;

procedure TShortcutLink.fSetHotKey(c: string);
var
  s: string[1];
  c2: char;
begin
  s := c;
  if length(c) < 1 then
    s := ' ';
  s := uppercase(s);
  c2 := s[1];
  if ord(c2) < ord(' ') then
    c2 := ' ';
  fHotKey := ord(c2);
end;

function TShortcutLink.fGetHotKey: string;
begin
  if fHotKey = 0 then
    fHotKey := ord(' ');
  result := chr(fHotKey);
end;

procedure TShortcutLink.fSetShowCmd(c: TShowCmd);
begin
  case c of
    scSHOWMAXIMIZED: fShowCmd := SW_Maximize;
    scSHOWMINIMIZED: fShowCmd := SW_ShowMinNoActive;
    scSHOWNORMAL: fShowCmd := SW_Restore;
  end;
end;

function TShortcutLink.fGetShowCmd: TShowCmd;
begin
  case fShowCmd of
    SW_MAXIMIZE: result := scShowMaximized;
    SW_SHOWMINNOACTIVE: result := scShowMinimized;
    SW_RESTORE: result := scShowNormal;
  else
    result := scShowNormal;
  end;
end;

initialization
  CoInitialize(nil); {Must initialize COM or CoCreateInstance won't work}
finalization
  CoUninitialize; {Symmetric uninitialize}

end.


(*** Solve 6: ***)

function CreateShellLink(sEintrag, sExeFile, sParams, sIconFile: string; iIconNr:
  Integer;
  const sDescription: string): HRESULT;
{create ShellLink, overwrite if already exist}
var
  hrInit: HRESULT;
  pIShellLink: IShellLink;
  pIPersistFile: IPersistFile;
begin
  result := E_FAIL;
  {they should be NIL}
  Assert((nil = pIShellLink) and (nil = pIPersistFile));
  {parameter test}
  Assert((sEintrag <> '') and (sExeFile <> ''));
  if (sEintrag = '') or (sExeFile = '') then
    Exit;
  {action}
  hrInit := CoInitialize(nil);
  try
    result := hrInit;
    if FAILED(result) then
      Exit;
    {Get a pointer to the IShellLink interface}
    result := CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
      IID_IShellLinkA, pIShellLink);
    if FAILED(result) then
      Exit;
    {Set the path to the shortcut target and the params}
    pIShellLink.SetPath(PChar(sExeFile));
    pIShellLink.SetArguments(PChar(sParams));
    {add description and icon}
    if sDescription <> '' then
      pIShellLink.SetDescription(PChar(sDescription));
    if sIconFile <> '' then
      pIShellLink.SetIconLocation(PChar(sIconFile), iIconNr);
    {Query IShellLink for the IPersistFile interface for saving the shortcut in persistent storage}
    result := pIShellLink.QueryInterface(IID_IPersistFile, pIPersistFile);
    if FAILED(result) then
      Exit;
    {Ensure that the string is OLECHAR
    Ensure that the new link has the .LNK extension
    Save the link by calling IPersistFile::Save.}
    if CompareText(ExtractFileExt(sEintrag), '.lnk') <> 0 then
      sEintrag := sEintrag + '.lnk';
    ForceDirectories(ExtractFilePath(sEintrag));
    result := pIPersistFile.Save(PWideChar(WideString(sEintrag)), True);
  finally
    pIShellLink := nil;
    pIPersistFile := nil;
    if SUCCEEDED(hrInit) then
      CoUninitialize;
  end;
end;


(*** Solve 7: ***)

uses
  ComObj, ShlObj, ActiveX;

procedure CreateShortcut(AFileName: string; ALocation: string);
var
  MyObject: IUnknown;
  MySLink: IShellLink;
  MyPFile: IPersistFile;
  WFileName: WideString;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  MySLink.SetPath(PChar(AFileName));
  MySLink.SetWorkingDirectory(PChar(ExtractFilePath(AFileName)));
  WFileName := ALocation;
  MyPFile.Save(PWChar(WFileName), False);
end;

function GetSpecialFolder(AFolderID: Integer): string;
var
  AInfo: PItemIdList;
  Buffer: array[0..MAX_PATH] of Char;
begin
  if (SHGetspecialFolderLocation(Application.Handle, AFolderID, aInfo) = NOERROR)
    and SHGetPathFromIDList(aInfo, Buffer) then
    Result := StrPas(Buffer);
end;

procedure MakeShortcut;
begin
  CreateShortcut(Application.ExeName, GetSpecialFolder(CSIDL_COMMON_STARTUP)
    + '\shortcutname.lnk');
end;

procedure DeleteShortCut;
  DeleteFile(PChar(GetSpecialFolder(CSIDL_COMMON_STARTUP) + '\shortcutname.lnk'));
end; 

function CreateLink(const AppName, LinkName, Desc: string): Boolean;
// Desc enthält Pfad und Filename und Extension (.lnk)
var
  SL: IShellLink;
  PF: IPersistFile;
  LnkName: string;
  WStr: array[0..MAX_PATH - 1] of WideChar;
begin
  Result := false;
  SL := GetShellLink;
  try
    { The IShellLink Interface supports the IPersistFile interface. Get an interface pointer to it. }
    if SUCCEEDED(SL.QueryInterface(IID_IPersistFile, PF)) then
    try
      if SUCCEEDED(SL.SetPath(PChar(AppName))) then {set link path to proper file}
      begin
        if Desc <> '' then
          OleCheck(SL.SetDescription(PChar(Desc))); {set description}
        { create a path location and filename for link file }
        //MD LnkName := Dest + '\' + linkName;
        LnkName := linkName;
        { If you want to create a link to"Desktop", you must call GetFolderLocation('Desktop') }
        { convert the link file pathname to a PWideChar }
        StringToWideChar(LnkName, WStr, MAX_PATH);
        PF.Save(WStr, True); {save link file}
        Result := true;
      end;
    finally
      PF.Release;
    end;
  finally
    SL.Release;
  end;
end;
