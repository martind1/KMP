unit FTPFileSystem;
(* Filesystem für Indy FTP Server
18.11.11 md  erstellt
04.09.13 md  MaxFiles Sets a maximum limit on the number of files listed in one directory listing

- keine Designtime Komponente.
  Die Komponente wird manuell in der Serverform erstellt und initialisiert.
  Die Routionen werden manuell in der Serverform-Ereignissen aufgerufen.
  Weil nur bei einem fehlenden Ereignis eine korrekte Antwort zu Client geht.

- die Verzeichnisse sind Unix-like ( /, /dir1/dir2)


- Userverwaltung

- Berechtigungen

*)

interface

uses
  Classes,
  IdBaseComponent,
  IdException,
  IdFTPList,
  IdFTPListOutput,
  IdFTPServerContextBase,
  IdFTPBaseFileSystem,
  syncobjs;

type
  TFTPFileSystem = class(TIdFTPBaseFileSystem)
  private
    FRootPath: string;
    function ReplaceChars(APath: string): string;
    //alternate function GetSizeOfFile(AFile : string) : Integer;
    procedure SetRootPath(const Value: string);
  protected
    procedure InitComponent; override;
  published
  public
    MaxFiles: integer;  //0 = ohne Beschränkung der Anzahl im File Listing
    property RootPath: string read FRootPath write SetRootPath;
  public
    LockStatus: TCriticalSection;
    procedure RenameFileFrom(AContext: TIdFTPServerContextBase;
      const ARenameFromFile, ARenameToFile: TIdFTPFileName);
    // von Basisklasse:
    procedure ChangeDir(AContext : TIdFTPServerContextBase; var VDirectory: TIdFTPFileName); override;
    procedure GetFileSize(AContext : TIdFTPServerContextBase; const AFilename: TIdFTPFileName; var VFileSize: Int64); override;
    procedure GetFileDate(AContext : TIdFTPServerContextBase; const AFilename: TIdFTPFileName; var VFileDate: TDateTime); override;
    procedure ListDirectory(AContext : TIdFTPServerContextBase; const APath: TIdFTPFileName; ADirectoryListing: TIdFTPListOutput; const ACmd, ASwitches : string); override;
    procedure RenameFile(AContext : TIdFTPServerContextBase; const ARenameToFile: TIdFTPFileName); override;
    procedure DeleteFile(AContext : TIdFTPServerContextBase; const APathName: TIdFTPFileName); override;
    procedure RetrieveFile(AContext : TIdFTPServerContextBase; const AFileName: TIdFTPFileName; var VStream: TStream); override;
    procedure StoreFile(AContext : TIdFTPServerContextBase; const AFileName: TIdFTPFileName; AAppend: Boolean; var VStream: TStream); override;
    procedure MakeDirectory(AContext : TIdFTPServerContextBase; var VDirectory: TIdFTPFileName); override;
    procedure RemoveDirectory(AContext : TIdFTPServerContextBase; var VDirectory: TIdFTPFileName); override;
    procedure SetModifiedFileDate(AContext : TIdFTPServerContextBase; const AFileName: TIdFTPFileName; var VDateTime: TDateTime); override;
    procedure GetCRCCalcStream(AContext : TIdFTPServerContextBase; const AFileName: TIdFTPFileName; var VStream : TStream); override;
    procedure CombineFiles(AContext : TIdFTPServerContextBase;
      const ATargetFileName: TIdFTPFileName; AParts: Tstrings); override;

  end;

implementation
uses
  SysUtils,
  IdResourcestringsProtocols, IdFTPServer,
  Prots, Err__Kmp;

type
  TDummyIdFTPServer = class(TIdFTPServer);

{ TFTPFileSystem }

procedure TFTPFileSystem.InitComponent;
begin
  inherited;
  RootPath:='C:';
end;

//alternate
//function TFTPFileSystem.GetSizeOfFile(AFile: string): Integer;
//var
//  FStream: TFileStream;
//begin
//  try
//    FStream := TFileStream.Create(AFile, fmOpenRead);
//    try
//      Result := FStream.Size;
//    finally
//      FreeAndNil(FStream);
//    end;
//  except
//    Result := 0;
//  end;
//end;

function TFTPFileSystem.ReplaceChars(APath: string): string;
// c:\\a/b -> c\a\b
var
  s: string;
begin
  s := stringReplace(APath, '/', '\', [rfReplaceAll]);
  s := stringReplace(s, '\\', '\', [rfReplaceAll]);
  Result := s;
end;

procedure TFTPFileSystem.SetRootPath(const Value: string);
begin
  FRootPath := PartDir(Value);  //ohne abschl '\'
end;


{ TIdFTPBaseFileSystem }

procedure TFTPFileSystem.CombineFiles(AContext: TIdFTPServerContextBase;
  const ATargetFileName: TIdFTPFileName; AParts: Tstrings);
begin
  EError('FTP Server: COMB not implemented', [0]);
end;

procedure TFTPFileSystem.DeleteFile(AContext: TIdFTPServerContextBase;
  const APathName: TIdFTPFileName);
begin
  SysUtils.DeleteFile(ReplaceChars(RootPath+APathName));
end;

procedure TFTPFileSystem.GetCRCCalcStream(AContext: TIdFTPServerContextBase;
  const AFileName: TIdFTPFileName; var VStream: TStream);
begin
  VStream := TFileStream.Create(ReplaceChars(RootPath+AFilename), fmOpenRead);
end;

procedure TFTPFileSystem.GetFileDate(AContext: TIdFTPServerContextBase;
  const AFilename: TIdFTPFileName; var VFileDate: TDateTime);
begin
  //VFileDate := FileDateTime(ReplaceChars(RootPath+AFilename));
  if not FileAge(ReplaceChars(RootPath+AFilename), VFileDate) then
    EError('GetFileDate', [0]);
end;

procedure TFTPFileSystem.GetFileSize(AContext: TIdFTPServerContextBase;
  const AFilename: TIdFTPFileName; var VFileSize: Int64);
begin
  VFileSize := Prots.GetFileSize(ReplaceChars(RootPath+AFilename));  //Prots
end;

procedure TFTPFileSystem.ChangeDir(AContext: TIdFTPServerContextBase;
  var VDirectory: TIdFTPFileName);
begin
  AContext.CurrentDir := VDirectory;
end;

procedure TFTPFileSystem.ListDirectory(AContext: TIdFTPServerContextBase;
  const APath: TIdFTPFileName; ADirectoryListing: TIdFTPListOutput; const ACmd,
  ASwitches: string);
var
  LFTPItem :TIdFTPListItem;
  SR : TSearchRec;
  SRI : Integer;
  N: integer;
begin
   N := 0;
   SRI := FindFirst(RootPath + ReplaceChars(APath) + '\*.*',
          faAnyFile - faHidden - faSysFile, SR);
   while (SRI = 0) and ((N < MaxFiles) or (MaxFiles = 0)) do
   begin
     Inc(N);
     LFTPItem := ADirectoryListing.Add;
     LFTPItem.FileName := SR.Name;
     LFTPItem.Size := SR.Size;
     LFTPItem.ModifiedDate := FileDateToDateTime(SR.Time);
     if SR.Attr = faDirectory then
       LFTPItem.ItemType := ditDirectory
     else
       LFTPItem.ItemType := ditFile;
     SRI := FindNext(SR);
   end;
   FindClose(SR);
   SetCurrentDir(RootPath + ReplaceChars(APath) + '\..');
end;

procedure TFTPFileSystem.MakeDirectory(AContext: TIdFTPServerContextBase;
  var VDirectory: TIdFTPFileName);
begin
   if not ForceDirectories(ReplaceChars(RootPath + VDirectory)) then
   begin
     raise Exception.Create('Unable to create directory');
   end;
end;

procedure TFTPFileSystem.RemoveDirectory(AContext: TIdFTPServerContextBase;
  var VDirectory: TIdFTPFileName);
begin
  DelDir(ReplaceChars(RootPath + VDirectory));  //Prots
end;

procedure TFTPFileSystem.RenameFile(AContext: TIdFTPServerContextBase;
  const ARenameToFile: TIdFTPFileName);
begin
  //Bug: from fehlt
end;

procedure TFTPFileSystem.RenameFileFrom(AContext: TIdFTPServerContextBase;
  const ARenameFromFile, ARenameToFile: TIdFTPFileName);
begin
  // ohne Bug. Direktaufruf.
  SysUtils.RenameFile(ReplaceChars(RootPath+ARenameFromFile),
                      ReplaceChars(RootPath+ARenameToFile));
end;

procedure TFTPFileSystem.RetrieveFile(AContext: TIdFTPServerContextBase;
  const AFileName: TIdFTPFileName; var VStream: TStream);
begin
  VStream := TFileStream.Create(ReplaceChars(RootPath+AFilename), fmOpenRead);
end;

procedure TFTPFileSystem.SetModifiedFileDate(
  AContext: TIdFTPServerContextBase; const AFileName: TIdFTPFileName;
  var VDateTime: TDateTime);
begin
  SetFileDateTime(ReplaceChars(RootPath+AFilename), VDateTime);
end;

procedure TFTPFileSystem.StoreFile(AContext: TIdFTPServerContextBase;
  const AFileName: TIdFTPFileName; AAppend: Boolean; var VStream: TStream);
begin
  if not Aappend then
    VStream := TFileStream.Create(ReplaceChars(RootPath+AFilename), fmCreate)
  else
    VStream := TFileStream.Create(ReplaceChars(RootPath+AFilename), fmOpenWrite);
end;

end.



