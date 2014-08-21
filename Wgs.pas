unit Wgs;

interface

uses
{$ifdef WIN32}
  Windows, 
{$else}
  WinTypes,
{$endif}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DB,  Uni, DBAccess, MemDS,
  QRepForm, Lnav_kmp, quickrpt, Qrctrls, LUDefkmp;

type
  TRepWgs = class(TQRepForm)
    QuickReport: TQuickRep;
    LDataSource1: TLDataSource;
    Query1: TuQuery;
    Nav: TLNavigator;
    LuERZ: TLookUpDef;
    TblErz: TuQuery;
    DetailBand1: TQRBand;
    QRDBText15: TQRDBText;
    QRDBText27: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText29: TQRDBText;
    QRDBText32: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText14: TQRDBText;
    QRDBText16: TQRDBText;
    QRDBText17: TQRDBText;
    QRDBText18: TQRDBText;
    QRDBText19: TQRDBText;
    QRDBText20: TQRDBText;
    QRDBText21: TQRDBText;
    QRDBText22: TQRDBText;
    QRDBText23: TQRDBText;
    QRDBText24: TQRDBText;
    QRDBText25: TQRDBText;
    QRDBText26: TQRDBText;
    QRDBText28: TQRDBText;
    QRDBText30: TQRDBText;
    QRDBText31: TQRDBText;
    QRDBText33: TQRDBText;
    QRDBText34: TQRDBText;
    LuMAND: TLookUpDef;
    TblMand: TuQuery;
    QRDBText35: TQRDBText;
    QRDBText36: TQRDBText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RepWgs: TRepWgs;

implementation

{$R *.DFM}

uses
  ParaFrm;


procedure TRepWgs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
