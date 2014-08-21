unit Aboutdlg;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, SysUtils, Rzlabel, DB,  Uni, DBAccess, MemDS;

type
  TDlgAbout = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    Panel2: TPanel;
    Label8: TLabel;
    Label10: TLabel;
    UserName: TLabel;
    CompanyName: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    WinVersion: TLabel;
    DosVersion: TLabel;
    Coprocessor: TLabel;
    CPU: TLabel;
    Panel4: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    FreeMemory: TLabel;
    FreeResources: TLabel;
    FreeDisk: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    BitBtn1: TBitBtn;
    VersionNumber: TRzLabel;
    Copyright: TRzLabel;
    ProductName: TRzLabel;
    Comments: TRzLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
DlgAbout: TDlgAbout;

implementation
{$R *.DFM}
uses
  Prots, GNav_Kmp,
  MainFrm;

procedure TDlgAbout.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TDlgAbout.FormActivate(Sender: TObject);
var
{$ifdef WIN32}
  SystemInfo: TSystemInfo;
  MemoryStatus: TMemoryStatus;
  VersionInfo: TOSVersionInfo;
  sCompName: array[0..MAX_COMPUTERNAME_LENGTH + 1] of char;
  lCompName: integer;
  sUserName: array[0..255] of char;
  lUserName: integer;
{$else}
{$endif}
  S1, S2: string;
begin
  VersionNumber.Caption := Format('Version %s', [KmpVersion]);
{$ifdef WIN32}
  VersionInfo.dwOSVersionInfoSize := sizeof( TOSVersionInfo);
  GetVersionEx( VersionInfo);
  WinVersion.Caption := Format( '%d.%d.%d %s',
    [VersionInfo.dwMajorVersion, VersionInfo.dwMinorVersion,
     LoWord( VersionInfo.dwBuildNumber), StrPas( VersionInfo.szCSDVersion)]);

  case VersionInfo.dwPlatformId of
    VER_PLATFORM_WIN32s: S1 := 'WIN32s';
    VER_PLATFORM_WIN32_WINDOWS: S1 := 'WIN95';
    VER_PLATFORM_WIN32_NT: S1 := 'WIN NT';
  else
    S1 := 'Plattform ' + IntToStr( VersionInfo.dwPlatformId);
  end;
  DosVersion.Caption := S1;
    {Format( '%d.%d', [IntToStr( GetDOSMajorVersion), IntToStr( GetDOSMinorVersion)]);}

  FillMemory( @SystemInfo, sizeof(TSystemInfo), 0);
  GetSystemInfo( SystemInfo);
  if PentiumBug then
    S1 := 'Pentium Bug!' else
    S1 := '';
  Coprocessor.Caption := IntToStr( SystemInfo.dwNumberOfProcessors -1);
  case SystemInfo.wProcessorArchitecture of
    {INTEL}0: CPU.Caption := Format( 'INTEL %d / %04.4X %s',
      [SystemInfo.dwProcessorType, SystemInfo.wProcessorRevision, S1]);
    {MIPS}1:  CPU.Caption := Format( 'MIPS %d', [SystemInfo.wProcessorRevision]);
    {ALPHA}2: CPU.Caption := Format( 'ALPHA %d', [SystemInfo.wProcessorRevision]);
    {PPC}3:   CPU.Caption := Format( 'PPC %d', [SystemInfo.wProcessorRevision]);
  end;

  FillMemory( @MemoryStatus, sizeof(TMemoryStatus), 0);
  MemoryStatus.dwLength := sizeof(TMemoryStatus);
  GlobalMemoryStatus( MemoryStatus);
  FreeMemory.Caption := IntToStr(MemoryStatus.dwAvailPageFile div 1024) + ' KB';
  FreeResources.Caption := Format('%d%%', [MemoryStatus.dwMemoryLoad]);
    {[double(MemoryStatus.dwAvailVirtual) / double(MemoryStatus.dwTotalVirtual) * 100]);}


  lUserName := sizeof(sUserName);
  GetUserName( sUserName, DWORD(lUserName));
  UserName.Caption := sUserName;

  lCompName := sizeof(sCompName);
  GetComputerName( sCompName, DWORD(lCompName));
  CompanyName.Caption := sCompName;

  { Get free memory, resources, disk space }
  S1 := ExpandFileName('X');
  S2 := ExtractFileDrive( S1);
  FreeDisk.Caption := S2 + ' ' + IntToStr(DiskFree(0) div 1000000) + ' MB';

{$else}
  { Win16: Get Win/Dos version numbers }
  wVersion := LoWord(GetVersion);
  dVersion := HiWord(GetVersion);
  WinVersion.Caption := IntToStr(LO(wVersion)) + '.' +
                        IntToStr(HI(wVersion));
  DosVersion.Caption := IntToStr(HI(dVersion)) + '.' +
                        IntToStr(LO(dVersion));

  winFlags := GetWinFlags;
  if winFlags and WF_80x87 > 0 then
     Coprocessor.Caption := 'Vorhanden' else
     Coprocessor.Caption := 'Nicht Vorhanden';
  if winFlags and WF_CPU486 > 0 then
     CPU.Caption := '486 oder Pentium';
  if winFlags and WF_CPU386 > 0 then
     CPU.Caption := '386';
  if winFlags and WF_CPU286 > 0 then
     CPU.Caption := '286';

  { Get free memory, resources, disk space }
  FreeMemory.Caption := IntToStr(GetFreeSpace(0) div 1000) + ' KB';
  FreeResources.Caption := IntToStr(GetFreeSystemResources(GFSR_SYSTEMRESOURCES))
                               + '%';
  FreeDisk.Caption := IntToStr(DiskFree(3) div 1000000) + ' MB';
  { Get user name and company name }
  fileHandle := LoadLibrary('USER');
  UserName.Caption := '';
  CompanyName.Caption := '';
  if fileHandle >= HINSTANCE_ERROR then begin
    if LoadString(fileHandle, 514, Addr(fileBuffer), 30) <> 0 then
       UserName.Caption := fileBuffer;
    if LoadString(fileHandle, 515, Addr(fileBuffer), 30) <> 0 then
       CompanyName.Caption := fileBuffer;
    FreeLibrary(fileHandle);
  end;
{$endif}  {Win16}

end;

end.

