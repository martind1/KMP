unit MuSiFr;
(* Frame für Detail-Lookups

   In Projekt verwenden: MuSiFr in Projektfile hinzufügen (.dpr)

   05.01.05 MD  Buttons disablen bzgl. DisabledButtons
   18.01.08 MD  Delete Btn hinzugefügt, invisible als Dflt
*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, Btnp_kmp, Lnav_kmp, ExtCtrls, Grids, DBGrids, Mugrikmp;

type
  TFrMuSi = class(TFrame)
    Mu: TMultiGrid;
    Panel12: TPanel;
    btnSingle: TqBtnMuSi;
    btnInsert: TqBtnMuSi;
    btnEdit: TqBtnMuSi;
    btnFTab: TqBtnMuSi;
    btnDelete: TqBtnMuSi;
    procedure btnSingleClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnFTabClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
  end;

implementation
{$R *.DFM}
uses
  Prots, GNav_Kmp, NLnk_Kmp, LuDefKmp;

constructor TFrMuSi.Create(AOwner: TComponent);
begin
  inherited;
  //btnDelete.Visible := false;
end;

procedure TFrMuSi.Loaded;
var
  I, Y: integer;
  AControl: TControl;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    AControl := nil;
    Y := 2;
    for I := 1 to 5 do
    begin
      case I of
        1: AControl := btnSingle;
        2: AControl := btnInsert;
        3: AControl := btnEdit;
        4: AControl := btnFTab;
        5: AControl := btnDelete;
      end;
      if (AControl <> nil) and AControl.Visible then
      begin
        AControl.Top := Y;
        Inc(Y, 40);
      end;
    end;
  end;
end;

procedure TFrMuSi.btnSingleClick(Sender: TObject);
begin
  btnSingle.LookUpDef := TLookUpDef(Mu.DataSource);
end;

procedure TFrMuSi.btnInsertClick(Sender: TObject);
begin
  //Achtung: bei DeleteDetails=false muss LookUpModus=lumDetailTab manuell gesetzt werden!
  btnInsert.LookUpDef := TLookUpDef(Mu.DataSource);
end;

procedure TFrMuSi.btnEditClick(Sender: TObject);
begin
  btnEdit.LookUpDef := TLookUpDef(Mu.DataSource);
end;

procedure TFrMuSi.btnFTabClick(Sender: TObject);
begin
  btnFTab.LookUpDef := TLookUpDef(Mu.DataSource);
end;

procedure TFrMuSi.btnDeleteClick(Sender: TObject);
var
  ALuDef: TLookUpDef;
begin
  btnFTab.LookUpDef := nil;  //damit sicher gelöscht wird
//  TLookUpDef(Mu.DataSource).Navlink.DoDelete;
  { erst QNav Focus setzen und dann über QNav löschen (wg ConfirmDelete und DeleteMarked) }
  ALuDef := Mu.DataSource as TLookUpDef;
  ALuDef.LinkToGNav := true;
  Mu.Form.ActiveControl := Mu;  //Ruft SetLink
  PostMessage(GNavigator.X.Handle, BC_GNAVCLICK, WPARAM(qnbDelete), 0);
end;

end.
