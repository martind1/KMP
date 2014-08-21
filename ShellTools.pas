unit ShellTools;
{ Demonstration der API-Funktionen
  SHFileOperation und SHBrowseForFolder.
  Zusammengebastelt von Simon Reinhardt
  S.Reinhardt@WTal.de}
(*
27.10.08 MD  CreateLink
17.01.12 MD  D2010 CreateLink neu da Fehler
26.02.12     uses ole2 entfernt. Dafür II hier hard kopiert von ole2.pas
             damit ole2.pas nichgt implizit in das Package eingefügt wird.
*)

interface

uses
  Classes;

function ShellGetFolder(Root:integer;Caption:string):string;
function ShellFileOperation(QuellDateien: TStrings; Zielverz: string;
  Action: integer; Flags: Word):boolean;
function CreateLink(const AppName, LinkName, Desc: string): Boolean;

implementation

uses
  Windows, Messages, SysUtils, Forms,
  ShellAPI, ShlObj, ActiveX;

const
{ Standard GUIDs }
  IID_IPersistFile: TGUID = (
    D1:$0000010B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

function ShellGetFolder(Root:integer;Caption:string):string;
var
    bi            : TBROWSEINFO;
    lpBuffer      : PChar;
    pidlPrograms,
    pidlBrowse    : PItemIDList;
begin
  if (not SUCCEEDED(SHGetSpecialFolderLocation(getactivewindow,Root,pidlPrograms))) then
    Exit;
  lpBuffer:=StrAlloc(max_path);
  bi.hwndOwner := getactivewindow;
  bi.pidlRoot := pidlPrograms;
  bi.pszDisplayName := lpBuffer;
  bi.lpszTitle := pChar(caption);
  bi.ulFlags := BIF_RETURNONLYFSDIRS;
  bi.lpfn := nil;
  bi.lParam := 0;
  pidlBrowse := SHBrowseForFolder(bi);
  if (pidlBrowse<>nil) then begin
    if (SHGetPathFromIDList(pidlBrowse, lpBuffer)) then
      Result:=lpBuffer;
  end;
  StrDispose(lpBuffer);
end; {ShellGetFolder}

function ShellFileOperation(QuellDateien: TStrings; Zielverz: string;
  Action: integer; Flags: Word):boolean;
var Operation : TSHFileOpStruct;
    i         : integer;
    Quellen   : string;
begin
  with Operation do begin
    {Parent Window}
    wnd:=Application.Handle;
    {was soll gemacht werden?}
    wFunc:=Action;

    {Quelldateien nach pFrom kopieren}
    Quellen:='';
    for i:=0 to QuellDateien.Count-1 do
      Quellen:=Quellen+QuellDateien[i]+#0;
    Quellen:=Quellen+#0;
    pFrom:=PChar(Quellen);

    {Zielverzeichnis nach pTo kopieren}
    pTo:=PChar(ZielVerz);

    {Titel der Fortschrittanzeige}
    case Action of
      FO_Delete : lpszProgressTitle:='Dateien löschen';
      FO_Copy   : lpszProgressTitle:='Dateien kopieren';
      FO_Move   : lpszProgressTitle:='Dateien verschieben';
      FO_Rename : lpszProgressTitle:='Dateien umbenennen';
    end;
{   Flags für die Aktion einstellen

    FOF_ALLOWUNDO	Preserves undo information, if possible.
    FOF_CONFIRMMOUSE	Not implemented.
    FOF_FILESONLY	Performs the operation only on files if a wildcard filename (*.*) is specified.
    FOF_MULTIDESTFILES	Indicates that the pTo member specifies multiple destination files (one for each source file) rather than one directory where all source files are to be deposited.
*   FOF_NOCONFIRMATION	Responds with "yes to all" for any dialog box that is displayed.
    FOF_NOCONFIRMMKDIR	Does not confirm the creation of a new directory if the operation requires one to be created.
-   FOF_RENAMEONCOLLISION	Gives the file being operated on a new name (such as "Copy #1 of...") in a move, copy, or rename operation if a file of the target name already exists.
    FOF_SILENT	Does not display a progress dialog box.
    FOF_SIMPLEPROGRESS	Displays a progress dialog box, but does not show the filenames.
    FOF_WANTMAPPINGHANDLE	Fills in the hNameMappings member. The handle must be freed by using the SHFreeNameMappings function.

    ohne Fortschrittanzeige:
    fFlags:=FOF_ALLOWUNDO or FOF_SILENT;

    ohne Bestätigung :
    fFlags:=FOF_ALLOWUNDO or FOF_NOCONFIRMATION

    z.B. klammheimlich in den Papierkorb verschieben:
    fFlags:=FOF_ALLOWUNDO or FOF_SILENT or FOF_NOCONFIRMATION

    fFlags:=FOF_ALLOWUNDO;}

    fFlags := Flags;
  end;

  {Und los gehts!}
  Result:=SHFileOperation(Operation)=0;
end;

function CreateLink(const AppName, LinkName, Desc: string): Boolean;
// Desc enthält Pfad und Filename und Extension (.lnk)
// http://delphi-kb.blogspot.com/2011/03/create-program-icon-on-desktop-or-in.html
var
  SL: IShellLink;
  PF: IPersistFile;
  LnkName: string;
  WStr: array[0..MAX_PATH - 1] of WideChar;
begin
  Result := false;
  if SUCCEEDED(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
    IID_IShellLink, SL)) then
  try
    { The IShellLink Interface supports the IPersistFile interface. Get an interface pointer to it. }
    if SUCCEEDED(SL.QueryInterface(System.TGUID(IID_IPersistFile), PF)) then
    try
      if SUCCEEDED(SL.SetPath(PChar(AppName))) then {set link path to proper file}
      begin
        if Desc <> '' then
        begin
          SUCCEEDED(SL.SetDescription(PChar(Desc))); {set description}
        end;
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
      //Interfaces werden nicht released PF.Release;
    end;
  finally
      //Interfaces werden nicht released SL.Release;
  end;
end;



(* Aufruf:
  if CreateLink('d:\Datei.exe', 'c:\Verknüpfung.exe.lnk', 'Verknüpfung') then
    MessageDlg('Verknüpfung angelegt', mtInformation, [mbOk], 0);
*)

(*** Beispielanwendung: ***

procedure TMainForm.BtnSuchenClick(Sender: TObject);
var i : integer;
begin
  if OpenDlg.Execute then
    for i:=0 to OpenDlg.Files.Count-1 do
      FileList.Items.Add(OpenDlg.Files[i]);
end;

procedure TMainForm.BtnListeLoeschenClick(Sender: TObject);
begin
  FileList.Clear;
end;

procedure TMainForm.BtnLoeschenClick(Sender: TObject);
begin
  ShellFileOperation(FileList.Items,'',FO_Delete);
  FileList.Clear;
end;

procedure TMainForm.BtnKopierenClick(Sender: TObject);
var ZielVerz : string;
    Move     : boolean;
begin
  with Sender as TBitBtn do
    Move:=Tag=1;
  ZielVerz:=ShellGetFolder(CSIDL_Drives,'Zielverzeichnis auswählen:');
  if ZielVerz<>'' then begin
    if ZielVerz[Length(ZielVerz)]<>'\' then
      ZielVerz:=ZielVerz+'\';
    if Move then
      ShellFileOperation(FileList.Items,ZielVerz,FO_Move)
    else
      ShellFileOperation(FileList.Items,ZielVerz,FO_Copy);
    FileList.Clear;
  end;
end;

function CreateLink(lpszPathObj, lpszPathLink, lpszDesc: string): Boolean;
var
  psl: IShellLink;
  ppf: IPersistFile;

const
  IID_IPersistFile:
     TGUID = (D1:$0000010B;
              D2:$0000;
              D3:$0000;
              D4:($C0,$00,$00,$00,$00,$00,$00,$46));
begin
  result := False;
  if SUCCEEDED(CoCreateInstance(CLSID_ShellLink,
                                nil,
                                CLSCTX_INPROC_SERVER,
                                IID_IShellLinkA,
                                psl)) then
  begin
    psl.SetPath(PChar(lpszPathObj));
    psl.SetDescription(PChar(lpszDesc));
    if SUCCEEDED(psl.QueryInterface(IID_IPersistFile,
                 ppf)) then
      begin
        ppf.Save(StringToOLEStr(lpszPathLink),TRUE);
        Result := true;
//md28.10.08 weg -       ppf._Release; //---> Runtime-Error wenn aktiv
      end;
  end;
//md28.10.08 weg -  psl._Release; // ---> Runtime-Error wenn aktiv
end;

***)

end.

