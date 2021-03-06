unit Beinrep;

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
  TRepBein = class(TQRepForm)
    QuickReport: TQuickRep;
    HdrText: TQRBand;
    FtrPage: TQRBand;
    Line: TQRBand;
    FtrText: TQRBand;
    QRLabel3: TQRLabel;
    QRDBText1: TQRDBText;
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
    Query1: TuQuery;
    LDataSource1: TLDataSource;
    LNavigator1: TLNavigator;
    QRLabel2: TQRLabel;
    QRLabel4: TQRLabel;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRDBText6: TQRDBText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RepBein: TRepBein;

implementation

{$R *.DFM}

procedure TRepBein.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
