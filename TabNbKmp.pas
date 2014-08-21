unit TabNbKmp;
(* TabbedNoteBook modifiziert: benötigt weniger Resourcen
   SetNoteBookPage: weniger Resourcen
   Autor: Martin Dambach
   Letzte Änderung:
   12.01.97        Erstellen
   14.12.98        qNoteBook
   27.02.98        SetNoteBookPageIndex: nicht in Win32, da sonst doppelte Überschriften
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  ExtCtrls, Forms, Dialogs, Tabs, TabNotBk;

type
  TqTabbedNoteBook = class(TTabbedNoteBook)
  private
    { Private-Deklarationen }
    FOptimize: boolean;
    OldChange: TTabChangeEvent;
    procedure NewChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
  published
    { Published-Deklarationen }
    property Optimize: boolean read FOptimize write FOptimize;
  end;

  procedure SetNoteBookPageIndex(ANoteBook: TNoteBook; APageIndex: integer);
  procedure SetNoteBookActivePage(ANoteBook: TNoteBook; APage: string);
implementation

uses
  Prots, DPos_Kmp;
type
  TDummyWinControl = class( TWinControl);

procedure SetNoteBookPageIndex(ANoteBook: TNoteBook; APageIndex: integer);
{Umschalten: Resourcenschonend}
begin
{$ifdef WIN32}
{$else}
  if (APageIndex >= 0) and (APageIndex < ANoteBook.Pages.Count) and
     (APageIndex <> ANoteBook.PageIndex) then
    with ANotebook do
    begin
      TDummyWinControl(Pages.objects[PageIndex]).DestroyHandle;
    end;
{$endif}
  ANoteBook.PageIndex := APageIndex;
end;

procedure SetNoteBookActivePage(ANoteBook: TNoteBook; APage: string);
{Umschalten: Resourcenschonend}
begin
  if StrToIntDef(APage, -1) > -1 then
    SetNoteBookPageIndex(ANoteBook, StrToIntDef(APage, -1)) else
    SetNoteBookPageIndex(ANoteBook, ANoteBook.Pages.IndexOf(APage));
end;

(*** TqTabbedNoteBook *********************************************************)

constructor TqTabbedNoteBook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOptimize := true;
end;

procedure TqTabbedNoteBook.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
  begin
    if not assigned(OldChange) then
    begin
      OldChange := OnChange;
      OnChange := NewChange;
    end;
  end;
end;

procedure TqTabbedNoteBook.NewChange( Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var
  CurrentPage, NewPage: TDummyWinControl;
begin
  if not (csDesigning in ComponentState) then
  begin
    if Assigned( OldChange) then
      OldChange( Sender, NewTab, AllowChange);
    if AllowChange and FOptimize then
    try
      CurrentPage := TDummyWinControl(pages.objects[PageIndex]);
      NewPage := TDummyWinControl(pages.objects[NewTab]);
      LockWindowUpdate( Handle);
      NewPage.HandleNeeded;
      CurrentPage.DestroyHandle;
      LockWindowUpdate(0);
    except
      {PageIndex kann -1 sein }
    end;                          { This code modified from Lloyd's help file! }
  end;
end;

end.

