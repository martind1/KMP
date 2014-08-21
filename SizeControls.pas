unit SizeControls;
(* Komponente zum Skalieren der Controls auf einem Panel oder Form

12.11.09 MD  erstellt
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TSizeControlsOption = (scoSizeFonts);
  TSizeControlsOptions = set of TSizeControlsOption;

  TSizeControls = class(TComponent)
  private
    { Private-Deklarationen }
    SizePanelHeight, SizePanelWidth: integer;
    SizeControlsList: TStringList;
    InSizeControls: boolean;
    InitFlag: boolean;
    fOptions: TSizeControlsOptions;
    fSizePanel: TWinControl;
    procedure SetOptions(const Value: TSizeControlsOptions);
    procedure SetSizePanel(const Value: TWinControl);
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitControls;
    procedure ResizeControls;
  published
    { Published-Deklarationen }
    property Options: TSizeControlsOptions read fOptions write SetOptions;
    property SizePanel: TWinControl read fSizePanel write SetSizePanel;
  end;

// procedure Register

implementation

uses
  StdCtrls, tabnotbk,
  Prots;  //FreeObjects, ClearObjects

type
  TPointClass = class(TObject)
  public
    Left, Top, Width, Height, FontSize: integer;
    constructor Create(aLeft, aTop, aWidth, aHeight, aFontSize: integer);
  end;

{ TPointClass }

constructor TPointClass.Create(aLeft, aTop, aWidth, aHeight, aFontSize: integer);
begin
  Left := aLeft;
  Top := aTop;
  Width := aWidth;
  Height := aHeight;
  FontSize := aFontSize;
end;

{ TSizeControls }

constructor TSizeControls.Create(AOwner: TComponent);
begin
  inherited;
  SizeControlsList := TStringList.Create;
  Options := [scoSizeFonts];
  if fSizePanel = nil then
    if Owner is TWinControl then
      fSizePanel := Owner as TWinControl;
end;

destructor TSizeControls.Destroy;
begin
  FreeObjects(SizeControlsList);
  inherited;
end;

procedure TSizeControls.Loaded;
begin
  inherited;
end;

procedure TSizeControls.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent = SizePanel then
      SizePanel := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TSizeControls.SetOptions(const Value: TSizeControlsOptions);
begin
  fOptions := Value;
end;

procedure TSizeControls.SetSizePanel(const Value: TWinControl);
begin
  fSizePanel := Value;
  InitFlag := false;
end;

type
  TDummyWinControl = class(TWinControl);
  TDummyControl = class(TControl);
  TDummyCustomLabel = class(TCustomLabel);

procedure TSizeControls.InitControls;

  procedure LoadControls(aWinControl: TWinControl);
  var
    I: integer;
    aControl: TDummyControl;
  begin
    SizeControlsList.AddObject(aWinControl.Name, TPointClass.Create(aWinControl.Left,
      aWinControl.Top, aWinControl.Width, aWinControl.Height,
      TDummyWinControl(aWinControl).Font.Size));

    for I := 0 to aWinControl.ControlCount - 1 do
    begin
      aControl := TDummyControl(aWinControl.Controls[I]);
      if (scoSizeFonts in Options) then
        aControl.ParentFont := false;
      SizeControlsList.AddObject(aControl.Name, TPointClass.Create(aControl.Left,
        aControl.Top, aControl.Width, aControl.Height, aControl.Font.Size));

      if aWinControl.Controls[I] is TCustomRadioGroup then
      begin
        Debug0;
      end else
      if aWinControl.Controls[I] is TWinControl then
      begin
        LoadControls(TWinControl(aControl));
      end;
    end;
  end;
begin
  if fSizePanel = nil then
    Exit;
  if InitFlag then
    Exit;
  ClearObjects(SizeControlsList);
  SizePanelWidth := SizePanel.Width;
  SizePanelHeight := SizePanel.Height;
  SizeControlsList.Sorted := true;
  SizeControlsList.Duplicates := dupIgnore;
  LoadControls(SizePanel);
  InitFlag := true;
end;

procedure TSizeControls.ResizeControls;
// Wägemaske Höhen der Auflösung anpasen
var
  MulHeight, MulWidth, MulFont: double;

  procedure InternalSize(aWinControl: TWinControl);
  var
    I: integer;
    aControl: TControl;
    aPoint: TPointClass;
    aLeft, aTop, aWidth, aHeight: integer;
    procedure aControlSetBounds;
    begin
      if (aControl.Align = alClient) then
      begin
      end else
      if (aControl.Align = alTop) or (aControl.Align = alBottom) then
      begin
        aControl.Height := aHeight;
      end else
      if (aControl.Align = alLeft) or (aControl.Align = alRight) then
      begin
        aControl.Width := aWidth;
      end else  //aControl.Align = alNone
        aControl.SetBounds(aLeft, aTop, aWidth, aHeight);
    end;
  begin
    for I := 0 to aWinControl.ControlCount - 1 do
    begin
      aControl := aWinControl.Controls[I];
      if SizeControlsList.IndexOf(aControl.Name) >= 0 then
      begin
        aPoint := TPointClass(SizeControlsList.Objects[SizeControlsList.IndexOf(aControl.Name)]);
        aLeft   := MulDiv(aPoint.Left,   Round(MulWidth  * 1000), 1000);
        aTop    := MulDiv(aPoint.Top,    Round(MulHeight * 1000), 1000);
        aWidth  := MulDiv(aPoint.Width,  Round(MulWidth  * 1000), 1000);
        aHeight := MulDiv(aPoint.Height, Round(MulHeight * 1000), 1000);

        if not (scoSizeFonts in Options) and (MulWidth >= 1) and (MulHeight >= 1) then
        begin  //nur Positionieren
          if aControl is TCustomEdit then
            aHeight := aControl.Height;
          //aWidth := aControl.Width;
        end;

//        if aControl is TLookUpBtn then
//        begin
//          aControl.Left := aLeft;
//          aControl.Top := aTop;
//          //nicht vergrößern
//        end else
        if (aControl is TDummyCustomLabel) and TDummyCustomLabel(aControl).AutoSize then
        begin
          TDummyCustomLabel(aControl).AutoSize := false;
          aControlSetBounds;
          TDummyControl(aControl).Font.Size := MulDiv(aPoint.Fontsize, Round(MulFont * 1000), 1000);
          TDummyCustomLabel(aControl).AutoSize := true;
        end else
        begin
          aControlSetBounds;
          TDummyControl(aControl).Font.Size := MulDiv(aPoint.Fontsize, Round(MulFont * 1000), 1000);
        end;
      end;
      if (aControl is TWinControl) and not (aControl is TCustomRadioGroup) then
      try
        InternalSize(TWinControl(aControl));
      except on E:Exception do
        Debug0;
      end;
//      end else
//      if AControl is TTabbedNoteBook then
//      begin
//        ADetailBook := AControl as TTabbedNoteBook;
//        for IPage := 0 to ADetailBook.Pages.Count-1 do
//        begin
//          APage := ADetailBook.Pages.Objects[IPage] as TTabPage;
//          InternalSize(TWinControl(APage));
//        end;
//      end;
    end;
  end;

begin { ResizeControls }
  if not InitFlag then
    Exit;  //noch nicht initialisiert
  InSizeControls := true;
  try
    MulHeight := SizePanel.Height / SizePanelHeight;  //Zoomfaktor für Höhe
    MulWidth := SizePanel.Width / SizePanelWidth;     //Zoomfaktor für Breite
    MulFont := (MulWidth + MulHeight) / 2;          //Zoomfaktor für Fontsize
    if not (scoSizeFonts in Options) then
    begin
      MulWidth := FloatMin(MulWidth, 1.15);  //nicht überbreit
      MulFont := FloatMin(MulFont, 1.01);  //Font nicht vergrößern nur verkleinern
    end;
    if Owner is TScrollingWinControl then
      TScrollingWinControl(Owner).DisableAutoRange;
    try
      InternalSize(SizePanel);
    finally
      if Owner is TScrollingWinControl then
        TScrollingWinControl(Owner).EnableAutoRange;
    end;
  finally
    InSizeControls := false;
  end;
end;

//procedure Register;
//begin
//  RegisterComponents('Beispiele', [TSizeControls]);
//end;

end.
