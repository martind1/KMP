unit Werkrep;

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
  TRepWerk = class(TQRepForm)
    QuickReport: TQuickRep;
    HdrText: TQRBand;
    FtrPage: TQRBand;
    Line: TQRBand;
    FtrText: TQRBand;
    QRLabel3: TQRLabel;
    QRDBText1: TQRDBText;
    Query1: TuQuery;
    DataSource1: TLDataSource;
    LNavigator1: TLNavigator;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RepWerk: TRepWerk;

implementation

{$R *.DFM}

procedure TRepWerk.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
