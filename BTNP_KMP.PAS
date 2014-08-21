unit Btnp_kmp;
(* Buttons für Notebook Seitenumschaltung.
   Gruppenindex fest auf 901 eingestellt
   Autor: Martin Dambach
   letzte Änderung:
   28.10.96     erstellt
   15.01.02 MD  LookUpDef  (wenn <> nil wird Notebook entfernt)
   19.01.02 MD  AllowAllUp wird gesetzt
   19.01.02 MD

   ----------------------------------------
   - für LNavigator,GNavigator
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Buttons,
  LuDefKmp;

type
  (* BtnPage: Button für Pageumschaltung eines NoteBooks *)
  TBtnPage = class(TSpeedButton)
  private
    { Private-Deklarationen }
    FNoteBook: TNoteBook;
    FLookUpDef: TLookUpDef;
    FLookUpModus: TLookUpModus;
    FPage: string;
    OldPageChanged: TNotifyEvent; {altes PageChanged von Notebook}
    procedure SetNoteBook2(Value: TNoteBook);
    procedure SetLookUpDef(Value: TLookUpDef);
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
    procedure NoteBookPageChanged(Sender: TObject); virtual;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Click; override;
    procedure SetNoteBook(ANoteBook: TNoteBook);
  published
    { Published-Deklarationen }
    property NoteBook: TNoteBook read FNoteBook write SetNoteBook2;
    property Page: string read FPage write FPage;
    property LookUpDef: TLookUpDef read FLookUpDef write SetLookUpDef;
    property LookUpModus: TLookUpModus read FLookUpModus write FLookUpModus;
  end;

  (* Kompatibilität: *)
type
  (* Multi Single Button *)
  TqBtnMuSi = class(TBtnPage) end;

implementation

uses
  Prots, Err__Kmp, TabNbKmp;

constructor TBtnPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  GroupIndex := 901;
  AllowAllUp := false;
  FLookUpModus := lumZeigMsk;
end;

destructor TBtnPage.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    (*try                         erzeugt Pointer Fehler
      if NoteBook <> nil then
      begin
        NoteBook.OnPageChanged := nil;
      end;
    except
      on E:Exception do
        ProtA('%s.Destroy:%s',[Name,E.Message]);
    end;*)
  end;
  inherited Destroy;
end;

procedure TBtnPage.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
  begin
    if NoteBook <> nil then
    begin
      OldPageChanged := nil;  {damit PageChanged nicht spinnt}
      NoteBookPageChanged(self);
      OldPageChanged := NoteBook.OnPageChanged;
      NoteBook.OnPageChanged := NoteBookPageChanged;
    end;
  end;
end;

procedure TBtnPage.Notification(AComponent: TComponent; Operation: TOperation);
begin
  {ProtA('Not(%s):(%s)%d',[Name,AComponent.Name,ord(Operation)]);}
  if Operation = opRemove then
  begin
    if AComponent = NoteBook then
      NoteBook := nil;
    if AComponent = LookUpDef then
      LookUpDef := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TBtnPage.SetNoteBook2(Value: TNoteBook);
begin
  FNoteBook := Value;
  if Value <> nil then
  begin
    if not (csLoading in ComponentState) then
      LookUpDef := nil {else
      AllowAllUp := false};       //falls nur ein Btn plaziert ist
  end;
end;

procedure TBtnPage.SetLookUpDef(Value: TLookUpDef);
begin
  FLookUpDef := Value;
  if Value <> nil then
  begin
    if not (csLoading in ComponentState) then
      NoteBook := nil else
      AllowAllUp := true;
  end;
end;

procedure TBtnPage.NoteBookPageChanged(Sender: TObject);
begin
  if NoteBook <> nil then
    Down := NoteBook.ActivePage = Page; {aktive gleich eigene}
  {Enabled := not Down;}
  if assigned(OldPageChanged) then
    OldPageChanged(Sender);
end;

procedure TBtnPage.Click;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FNoteBook <> nil then
    begin
      inherited Click;
      try
        {NoteBook.ActivePage := Page; {Umschalten auf eigene Seite}
        SetNoteBookActivePage(FNoteBook, Page); {Umschalten: Resourcenschonend}
        {171200 Quva Sizu - keine Aktion da sonst AV
        if UpperCase(NoteBook.ActivePage) <> UpperCase(Page) then
          ErrWarn('Seite fehlt (%s<>%s)',[NoteBook.ActivePage,Page]);}
      except on E:Exception do
        EProt(self, E, 'Seite (%s) fehlt',[Page]);
      end;
    end else
    try
      inherited Click;        //auch hier damit bei Exception wieder Down=false ist
      if FLookUpDef <> nil then
      begin
        if FLookUpModus = lumErfassMsk then
        begin
          FLookUpDef.NavLink.DoInsert(true);  //CheckRights, Detail Insert
        end else
        if FLookUpModus = lumAendMsk then
        begin
          FLookUpDef.NavLink.DoEdit(true);  //CheckRights, Detail Insert
        end else
        begin
          FLookUpDef.LookUp(FLookUpModus); // berücksichtigt nicht editsingle
        end;
      end else
      begin
        if not assigned(OnClick) then
          Prot0('%s.%s.Seite(%s):NoteBook/Lookupdef fehlt', [Owner.Name, Name, Page]);
      end;
    finally
      Down := false;
    end;
  end else
    inherited Click;
end;

procedure TBtnPage.SetNoteBook(ANoteBook: TNoteBook);
(* neues Notebook zuordnen: für GNav *)
begin
  if not (csDesigning in ComponentState) then
  begin
    NoteBook := ANoteBook;
    NoteBookPageChanged(Self);       {für GNav Buttons}
  end;
end;

end.
