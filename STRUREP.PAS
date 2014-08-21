unit StruRep;

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
  TRepStru = class(TQRepForm)
    QuickReport: TQuickRep;
    HdrText: TQRBand;
    FtrPage: TQRBand;
    Line: TQRBand;
    FtrText: TQRBand;
    QRLabel3: TQRLabel;
    QRDBText1: TQRDBText;
    Query1: TuQuery;
    DataSource1: TLDataSource;
    Nav: TLNavigator;
    QRDBText2: TQRDBText;
    QRLabel1: TQRLabel;
    QRImage1: TQRImage;
    HdrCol: TQRBand;
    ChildCol: TQRChildBand;
    PageNumber: TQRSysData;
    QRDateTime: TQRSysData;
    QRSysData1: TQRSysData;
    QRLabel13: TQRLabel;
    QRLabel16: TQRLabel;
    QRLabel2: TQRLabel;
    QRDBText3: TQRDBText;
    QRLabel4: TQRLabel;
    QRDBText4: TQRDBText;
    QRLabel5: TQRLabel;
    QRDBText5: TQRDBText;
    QRLabel6: TQRLabel;
    QRDBText6: TQRDBText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RepStru: TRepStru;

implementation

{$R *.DFM}

procedure TRepStru.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
