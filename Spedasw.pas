unit SpedAsw;

interface

uses
{$ifdef WIN32}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DB,  Uni, DBAccess, MemDS,
  QRepForm, Lnav_kmp, quickrpt, Qrctrls;
{$else}
  WinTypes, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DB, 
  QRepForm, Lnav_kmp, quickrpt, Qrctrls;
{$endif}

type
  TRepSped = class(TQRepForm)
    QuickReport: TQuickRep;
    HdrText: TQRBand;
    FtrPage: TQRBand;
    Line: TQRBand;
    FtrText: TQRBand;
    QRLabel3: TQRLabel;
    Query1: TuQuery;
    DataSource1: TLDataSource;
    QRDBText2: TQRDBText;
    HdrCol: TQRBand;
    ChildCol: TQRChildBand;
    PageNumber: TQRSysData;
    QRDateTime: TQRSysData;
    QRSysData1: TQRSysData;
    QRLabel16: TQRLabel;
    QRImage1: TQRImage;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRLabel13: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel17: TQRLabel;
    QRLabel18: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRLabel14: TQRLabel;
    QRDBText12: TQRDBText;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    Nav: TLNavigator;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RepSped: TRepSped;

implementation

{$R *.DFM}

procedure TRepSped.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
