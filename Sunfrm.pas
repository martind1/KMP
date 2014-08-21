unit Sunfrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Qwf_Form, StdCtrls, Buttons, ExtCtrls, Lnav_kmp;

type
  TSpk = record
    case integer of
      0: (LoByte,
          HiByte: byte);
      1: (W: word);
  end;
type
  TFrmSPS = class(TqForm)
    Nav: TLNavigator;
    GroupBox1: TGroupBox;
    rgConnectEin: TRadioGroup;
    rgWaEinAmEin: TRadioGroup;
    GroupBox2: TGroupBox;
    rgConnectAus: TRadioGroup;
    rgWaAusAmEin: TRadioGroup;
    BtnClose: TBitBtn;
    rgWaEinAmAus: TRadioGroup;
    rgWaAusAmAus: TRadioGroup;
    procedure rgAmpelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    NoSps: boolean;
    procedure SpkRsp(SpkOut: TSpk; var SpkIn: TSpk; Hsb: byte);
  public
    { Public-Deklarationen }
    procedure SpkBef(Befehl: integer; var Code: integer);
  end;

var
  FrmSPS: TFrmSPS;

implementation
{$R *.DFM}
uses
  Prots, AbortDlg,
  ParaFrm;

procedure TFrmSPS.SpkRsp(SpkOut: TSpk; var SpkIn: TSpk; Hsb: byte);
var
  B1, B2: word;
  DlgAbort: TDlgAbort;
begin
  if NoSPS then exit;
  DlgAbort := CreateAbortDlg('Warte auf Antwort von SPS');
  repeat
    Delay(150);
    B1 := Port[PrgParam.InPortAdr+1];
    B2 := Port[PrgParam.InPortAdr+0];
    SpkIn.W := (B1 shl 8) or B2;
  until ((SpkIn.HiByte and 1) = Hsb) or DlgAbort.Canceled;
  if DlgAbort.Canceled then
    if WMessYesNo('SPS ignorieren ',[0]) = mrYes then
      NoSPS := true;
  DlgAbort.Release;
end;

procedure TFrmSPS.SpkBef(Befehl: integer; var Code: integer);
var
  SpkOut, SpkIn: TSpk;
begin
  SpkOut.LoByte := Befehl + (Code shl 5);
  SpkOut.HiByte := 0;
  SpkRsp(SpkOut, SpkIn, 0);
  Delay(150);
  SpkOut.HiByte := 1;
  PortW[PrgParam.OutPortAdr] := SpkOut.W;
  SpkRsp(SpkOut, SpkIn, 1);
  if Code = 0 then
    Code := SpkIn.LoByte shr 5;
  SpkOut.HiByte := 0;
  PortW[PrgParam.OutPortAdr] := SpkOut.W;
end;

procedure TFrmSPS.rgAmpelClick(Sender: TObject);
var
  Code: integer;
begin
  Code := TRadioGroup(Sender).ItemIndex + 1;
  SpkBef(TRadioGroup(Sender).Tag, Code);
end;

procedure TFrmSPS.FormActivate(Sender: TObject);
var
  Code: integer;
begin
  Code := 0;
  SpkBef( rgWaEinAmEin.Tag, Code);
  rgWaEinAmEin.ItemIndex := Code - 1;
  Code := 0;
  SpkBef( rgWaEinAmAus.Tag, Code);
  rgWaEinAmAus.ItemIndex := Code - 1;
  Code := 0;
  SpkBef( rgWaAusAmEin.Tag, Code);
  rgWaAusAmEin.ItemIndex := Code - 1;
  Code := 0;
  SpkBef( rgWaAusAmAus.Tag, Code);
  rgWaAusAmAus.ItemIndex := Code - 1;
end;

procedure TFrmSPS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caMinimize;
end;

procedure TFrmSPS.BtnCloseClick(Sender: TObject);
begin
  rgWaEinAmAus.ItemIndex := 1;
  Close;
end;

procedure TFrmSPS.FormCreate(Sender: TObject);
begin
  FrmSPS := self;
end;

procedure TFrmSPS.FormDestroy(Sender: TObject);
begin
  FrmSPS := nil;
end;

end.
