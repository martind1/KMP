unit Unit1;

(*
  Jim Tierney
  3/15/00

  This sample application demonstrates how MIDAS components support
  XML data, delta, and error packets.

  Using this sample:

  The two check boxes at the top indicate whether to retrieve data from a
  MIDAS server or from a local TDataSetProvider.

  Before using the MIDAS server option you will need to build and run
  (to register) demos/midas/internetexpress/
  customlist/rdmcustomerdata.dpr.

  Typically you will use this app as follows:
    Click Get Server XML
    Modify Data displayed in the grid
    Click Get Delta (optional)
    Click Apply Updates
    Click Get Server XML to retrieve modified records

  The ClientDataSet is not reloaded after clicking ApplyUpdates.  You will need
  to click the "Get Server XML" button to retrieve updated records.

  Clicking the "Apply Updates" button a second time will cause reconcile error(s)
  because the table has already been updated.

  Notes about MIDAS:

  MIDAS 3 servers support both XML and binary packets
  without any changes.  It is up to the client to specify the format.

  To get an XML data packet using IAppServer.GetRecords or TDataSetProvider.
  GetRecords, pass the grXML flag in the options parameter.

  The ApplyUpdates method detects whether the delta packet is XML or binary.
  If an XML delta packet is passed in then an XML error packet will
  be returned.

  All IAppServer and TDataSetProvider data, delta, and error packets are passed as
  OleVariant.  Use StringToVariantArray and VariantArrayToString to convert
  between XML text and a variant.

  A little bit of extra work is required to retrieve an XML delta packet from
  a ClientDataSet.  The technique used in this example is to use a temporary
  ClientDataSet to stream out XML.

*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBClient, MConnect, provider, Midas, Grids, DBGrids, dsintf,
  DBTables;

type
  TForm1 = class(TForm)
    DCOMConnection1: TDCOMConnection;
    ClientDataSet1: TClientDataSet;
    btnGetServerXML: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    memServerXML: TMemo;
    Label1: TLabel;
    btnApplyUpdates: TButton;
    memDelta: TMemo;
    Label2: TLabel;
    memErrors: TMemo;
    btnGetDelta: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    lblErrorCount: TLabel;
    Table1: TTable;
    DataSetProvider1: TDataSetProvider;
    cbUseProvider: TRadioButton;
    cbUseDCOMConnection: TRadioButton;
    procedure btnGetServerXMLClick(Sender: TObject);
    procedure btnApplyUpdatesClick(Sender: TObject);
    procedure btnGetDeltaClick(Sender: TObject);
  private
    function ApplyUpdates(Delta: OleVariant;
      var ErrorCount: Integer): OleVariant;
    function GetRecords: OleVariant;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


function TForm1.GetRecords: OleVariant;
var
  Options: TGetRecordOptions;
  Params, OwnerData: OleVariant;
  RecsOut: Integer;
begin
  Options := [grMetaData, grXML, grReset];
  RecsOut := 0;
  if cbUseProvider.Checked then
    Result := DataSetProvider1.GetRecords(-1, RecsOut, Byte(Options), '', Params, OwnerData)
  else
    // Pass grXML to retrieve an OleVariant containing XML
    Result := DComConnection1.GetServer.AS_GetRecords('CustNames', -1, RecsOut, Byte(Options), '', Params, OwnerData);
end;

function TForm1.ApplyUpdates(Delta: OleVariant; var ErrorCount: Integer): OleVariant;
var
  OwnerData: OleVariant;
begin
  if cbUseProvider.Checked then
    Result := DataSetProvider1.ApplyUpdates(Delta, -1, ErrorCount, OwnerData)
  else
    // Pass the OleVariant to AppServer.  An XML error packet is returned.
    Result := DComConnection1.GetServer.AS_ApplyUpdates('CustNames', Delta, -1, ErrorCount, OwnerData)
end;


procedure TForm1.btnGetServerXMLClick(Sender: TObject);
var
  ByteArray: OleVariant;
begin
  memServerXML.Lines.Text := '';
  ByteArray := GetRecords;
  // Convert the OleVariant back into a string
  memServerXML.Lines.Text := VariantArrayToString(ByteArray);
  ClientDataSet1.Data := ByteArray;
  ClientDataSet1.Open;
end;

procedure TForm1.btnApplyUpdatesClick(Sender: TObject);
var
  S: TStringStream;
  DS: TClientDataSet;
  ByteArray: OleVariant;
  ErrorCount: Integer;
begin
  memErrors.Lines.Text := '';
  lblErrorCount.Caption := '';
  // Get delta packet as XML by setting a temporary ClientDataSet
  // data to the delta and then streaming the data out as XML.
  S := TStringStream.Create('');
  try
    DS := TClientDataSet.Create(nil);
    try
      DS.Data := ClientDataSet1.Delta;
      DS.SaveToStream(S, dfXML);
    finally
      DS.Free;
    end;
    memDelta.Lines.Text := S.DataString;
    // Store the XML string in an OleVariant
    ByteArray := StringToVariantArray(S.DataString);
    ByteArray := ApplyUpdates(ByteArray, ErrorCount);
    // An XML error packet is returned, convert to text
    memErrors.Lines.Text := VariantArrayToString(ByteArray);
    lblErrorCount.Caption := IntToStr(ErrorCount);
  finally
    S.Free;
  end;
end;

procedure TForm1.btnGetDeltaClick(Sender: TObject);
var
  S: TStringStream;
  DS: TClientDataSet;
begin
  memDelta.Lines.Text := '';
  if ClientDataSet1.State in [dsEdit] then
    ClientDataSet1.Post;
  // Get delta packet as XML by setting a temporary ClientDataSet
  // data to the delta and then streaming the data out as XML.
  S := TStringStream.Create('');
  try
    DS := TClientDataSet.Create(nil);
    try
      DS.Data := ClientDataSet1.Delta;
      DS.SaveToStream(S, dfXML);
    finally
      DS.Free;
    end;
    memDelta.Lines.Text := S.DataString;
  finally
    S.Free;
  end;
end;

end.
