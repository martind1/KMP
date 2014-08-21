unit FNDCOM_TLB;

// ************************************************************************ //
// WARNUNG
// -------
// Die in dieser Datei deklarierten Typen wurden aus Daten einer Typbibliothek
// generiert. Wenn diese Typbibliothek explizit oder indirekt (über eine
// andere Typbibliothek) reimportiert wird oder wenn der Befehl
// 'Aktualisieren' im Typbibliotheks-Editor während des Bearbeitens der
// Typbibliothek aktiviert ist, wird der Inhalt dieser Datei neu generiert und
// alle manuell vorgenommenen Änderungen gehen verloren.                                        
// ************************************************************************ //

// $Rev: 45604 $
// Datei am 09.11.2012 16:50:40 erzeugt aus der unten beschriebenen Typbibliothek.

// ************************************************************************  //
// Typbib.: C:\FibuNet\FNCLIENT.EXE (1)
// LIBID: {A2D2DB50-181E-11D3-B2AF-0060974B958A}
// LCID: 0
// Hilfedatei: 
// Hilfe-String: FNDCOM Bibliothek
// Liste der Abhäng.: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit muss ohne Typüberprüfung für Zeiger compiliert werden.  
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;
  
// *********************************************************************//
// In der Typbibliothek deklarierte GUIDS. Die folgenden Präfixe werden verwendet:        
//   Typbibliotheken      : LIBID_xxxx                                      
//   CoClasses            : CLASS_xxxx                                      
//   DISPInterfaces       : DIID_xxxx                                       
//   Nicht-DISP-Interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // Haupt- und Nebenversionen der Typbibliothek
  FNDCOMMajorVersion = 1;
  FNDCOMMinorVersion = 0;

  LIBID_FNDCOM: TGUID = '{A2D2DB50-181E-11D3-B2AF-0060974B958A}';

  IID_IFEC: TGUID = '{A2D2DB51-181E-11D3-B2AF-0060974B958A}';
  CLASS_FEC: TGUID = '{A2D2DB53-181E-11D3-B2AF-0060974B958A}';
  IID_ICallBack: TGUID = '{91A1D963-1C48-11D3-BE71-000000000000}';
  DIID_Client: TGUID = '{91A1D96A-1C48-11D3-BE71-000000000000}';
  IID_ICallBackObj: TGUID = '{91A1D96C-1C48-11D3-BE71-000000000000}';
  CLASS_CallBackObj: TGUID = '{91A1D96E-1C48-11D3-BE71-000000000000}';
  IID_IFNClientApplication: TGUID = '{0310C1EC-D7D7-4E4C-8E2E-E43819347F15}';
  CLASS_FNClientApplication: TGUID = '{0673E5B2-AAA2-4304-8184-9C3B7202EAD6}';
type

// *********************************************************************//
// Forward-Deklaration von in der Typbibliothek definierten Typen                     
// *********************************************************************//
  IFEC = interface;
  IFECDisp = dispinterface;
  ICallBack = interface;
  ICallBackDisp = dispinterface;
  Client = dispinterface;
  ICallBackObj = interface;
  ICallBackObjDisp = dispinterface;
  IFNClientApplication = interface;
  IFNClientApplicationDisp = dispinterface;

// *********************************************************************//
// Deklaration von in der Typbibliothek definierten CoClasses
// (HINWEIS: Hier wird jede CoClass ihrem Standard-Interface zugewiesen)              
// *********************************************************************//
  FEC = IFEC;
  CallBackObj = ICallBackObj;
  FNClientApplication = IFNClientApplication;


// *********************************************************************//
// Interface: IFEC
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A2D2DB51-181E-11D3-B2AF-0060974B958A}
// *********************************************************************//
  IFEC = interface(IDispatch)
    ['{A2D2DB51-181E-11D3-B2AF-0060974B958A}']
    function Anmeldung(Computername: OleVariant; Username: OleVariant; Benutzername: OleVariant; 
                       Passwort: OleVariant; const CallBack: ICallBack; Packdata: WordBool; 
                       FibuSerNr: Integer; ClientVersion: Integer): OleVariant; safecall;
    function Get_Mandant: Integer; safecall;
    procedure Set_Mandant(Value: Integer); safecall;
    function Get_Buchdatum: Integer; safecall;
    procedure Set_Buchdatum(Value: Integer); safecall;
    function OpenData(TabName: OleVariant; Filter: OleVariant; Sort: OleVariant; 
                      var AnzRecs: Integer; var RecSize: Integer): Integer; safecall;
    function CloseData(Handle: Integer): WordBool; safecall;
    function GetData(Handle: Integer; StartPos: Integer; var AnzRecs: Integer): OleVariant; safecall;
    function Get_IsProgressWindowEnabled: WordBool; safecall;
    procedure Set_IsProgressWindowEnabled(Value: WordBool); safecall;
    function SortData(Handle: Integer; Sort: OleVariant): WordBool; safecall;
    function SearchData(Handle: Integer; SearchMode: Integer; SearchStr: OleVariant; 
                        out Rec: OleVariant): Integer; safecall;
    function SetData(Handle: Integer; AtPos: Integer; Mode: Integer; DataRec: OleVariant): WordBool; safecall;
    function Buchen(Data: OleVariant; Modus: Integer): OleVariant; safecall;
    function Get_IsMsgOnDataChanged: WordBool; safecall;
    procedure Set_IsMsgOnDataChanged(Value: WordBool); safecall;
    function LoadIniData(IniTyp: Integer; out IsLoad: WordBool): OleVariant; safecall;
    function SaveIniData(IniTyp: Integer; Value: OleVariant): WordBool; safecall;
    function GetPopUpItems(PopUpID: Integer): OleVariant; safecall;
    function LoadStream(aStreamNr: Integer; out IsLoad: WordBool): OleVariant; safecall;
    function SaveStream(aStreamNr: Integer; Value: OleVariant): WordBool; safecall;
    function HandleData(FuncNr: Integer; SubFuncNr: Integer; var IO_DATA: OleVariant; 
                        var DataLen: Integer): Integer; safecall;
    property Mandant: Integer read Get_Mandant write Set_Mandant;
    property Buchdatum: Integer read Get_Buchdatum write Set_Buchdatum;
    property IsProgressWindowEnabled: WordBool read Get_IsProgressWindowEnabled write Set_IsProgressWindowEnabled;
    property IsMsgOnDataChanged: WordBool read Get_IsMsgOnDataChanged write Set_IsMsgOnDataChanged;
  end;

// *********************************************************************//
// DispIntf:  IFECDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A2D2DB51-181E-11D3-B2AF-0060974B958A}
// *********************************************************************//
  IFECDisp = dispinterface
    ['{A2D2DB51-181E-11D3-B2AF-0060974B958A}']
    function Anmeldung(Computername: OleVariant; Username: OleVariant; Benutzername: OleVariant; 
                       Passwort: OleVariant; const CallBack: ICallBack; Packdata: WordBool; 
                       FibuSerNr: Integer; ClientVersion: Integer): OleVariant; dispid 1;
    property Mandant: Integer dispid 3;
    property Buchdatum: Integer dispid 4;
    function OpenData(TabName: OleVariant; Filter: OleVariant; Sort: OleVariant; 
                      var AnzRecs: Integer; var RecSize: Integer): Integer; dispid 5;
    function CloseData(Handle: Integer): WordBool; dispid 6;
    function GetData(Handle: Integer; StartPos: Integer; var AnzRecs: Integer): OleVariant; dispid 7;
    property IsProgressWindowEnabled: WordBool dispid 2;
    function SortData(Handle: Integer; Sort: OleVariant): WordBool; dispid 8;
    function SearchData(Handle: Integer; SearchMode: Integer; SearchStr: OleVariant; 
                        out Rec: OleVariant): Integer; dispid 9;
    function SetData(Handle: Integer; AtPos: Integer; Mode: Integer; DataRec: OleVariant): WordBool; dispid 10;
    function Buchen(Data: OleVariant; Modus: Integer): OleVariant; dispid 11;
    property IsMsgOnDataChanged: WordBool dispid 13;
    function LoadIniData(IniTyp: Integer; out IsLoad: WordBool): OleVariant; dispid 12;
    function SaveIniData(IniTyp: Integer; Value: OleVariant): WordBool; dispid 14;
    function GetPopUpItems(PopUpID: Integer): OleVariant; dispid 15;
    function LoadStream(aStreamNr: Integer; out IsLoad: WordBool): OleVariant; dispid 16;
    function SaveStream(aStreamNr: Integer; Value: OleVariant): WordBool; dispid 17;
    function HandleData(FuncNr: Integer; SubFuncNr: Integer; var IO_DATA: OleVariant; 
                        var DataLen: Integer): Integer; dispid 18;
  end;

// *********************************************************************//
// Interface: ICallBack
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {91A1D963-1C48-11D3-BE71-000000000000}
// *********************************************************************//
  ICallBack = interface(IDispatch)
    ['{91A1D963-1C48-11D3-BE71-000000000000}']
    function Message(const Msg: WideString; Wait: Integer): Integer; safecall;
    procedure OnDataChanged(DACOBJ: Integer; RecNr: Integer; NewMaxRec: Integer; Mode: Integer); safecall;
    function PrnStream(FNPrinter: Integer; Data: OleVariant; DataSize: Integer; Prozent: Integer): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICallBackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {91A1D963-1C48-11D3-BE71-000000000000}
// *********************************************************************//
  ICallBackDisp = dispinterface
    ['{91A1D963-1C48-11D3-BE71-000000000000}']
    function Message(const Msg: WideString; Wait: Integer): Integer; dispid 1;
    procedure OnDataChanged(DACOBJ: Integer; RecNr: Integer; NewMaxRec: Integer; Mode: Integer); dispid 2;
    function PrnStream(FNPrinter: Integer; Data: OleVariant; DataSize: Integer; Prozent: Integer): Integer; dispid 3;
  end;

// *********************************************************************//
// DispIntf:  Client
// Flags:     (4096) Dispatchable
// GUID:      {91A1D96A-1C48-11D3-BE71-000000000000}
// *********************************************************************//
  Client = dispinterface
    ['{91A1D96A-1C48-11D3-BE71-000000000000}']
  end;

// *********************************************************************//
// Interface: ICallBackObj
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {91A1D96C-1C48-11D3-BE71-000000000000}
// *********************************************************************//
  ICallBackObj = interface(IDispatch)
    ['{91A1D96C-1C48-11D3-BE71-000000000000}']
  end;

// *********************************************************************//
// DispIntf:  ICallBackObjDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {91A1D96C-1C48-11D3-BE71-000000000000}
// *********************************************************************//
  ICallBackObjDisp = dispinterface
    ['{91A1D96C-1C48-11D3-BE71-000000000000}']
  end;

// *********************************************************************//
// Interface: IFNClientApplication
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0310C1EC-D7D7-4E4C-8E2E-E43819347F15}
// *********************************************************************//
  IFNClientApplication = interface(IDispatch)
    ['{0310C1EC-D7D7-4E4C-8E2E-E43819347F15}']
    function Get_KeepAlive: WordBool; safecall;
    procedure Set_KeepAlive(Value: WordBool); safecall;
    procedure Kontoauskunft(aKontonummer: Integer); safecall;
    procedure CorporatePlannerAuskunft(const aKonto: WideString; aMandant: Integer; 
                                       aDatumAb: TDateTime; aDatumBis: TDateTime); safecall;
    property KeepAlive: WordBool read Get_KeepAlive write Set_KeepAlive;
  end;

// *********************************************************************//
// DispIntf:  IFNClientApplicationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0310C1EC-D7D7-4E4C-8E2E-E43819347F15}
// *********************************************************************//
  IFNClientApplicationDisp = dispinterface
    ['{0310C1EC-D7D7-4E4C-8E2E-E43819347F15}']
    property KeepAlive: WordBool dispid 201;
    procedure Kontoauskunft(aKontonummer: Integer); dispid 202;
    procedure CorporatePlannerAuskunft(const aKonto: WideString; aMandant: Integer; 
                                       aDatumAb: TDateTime; aDatumBis: TDateTime); dispid 203;
  end;

// *********************************************************************//
// Die Klasse CoFEC stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IFEC, dargestellt
// von CoClass FEC, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoFEC = class
    class function Create: IFEC;
    class function CreateRemote(const MachineName: string): IFEC;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TFEC
// Hilfe-String      : FibuNet DCOM-Server v3.x
// Standard-Interface: IFEC
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TFEC = class(TOleServer)
  private
    FIntf: IFEC;
    function GetDefaultInterface: IFEC;
  protected
    procedure InitServerData; override;
    function Get_Mandant: Integer;
    procedure Set_Mandant(Value: Integer);
    function Get_Buchdatum: Integer;
    procedure Set_Buchdatum(Value: Integer);
    function Get_IsProgressWindowEnabled: WordBool;
    procedure Set_IsProgressWindowEnabled(Value: WordBool);
    function Get_IsMsgOnDataChanged: WordBool;
    procedure Set_IsMsgOnDataChanged(Value: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFEC);
    procedure Disconnect; override;
    function Anmeldung(Computername: OleVariant; Username: OleVariant; Benutzername: OleVariant; 
                       Passwort: OleVariant; const CallBack: ICallBack; Packdata: WordBool; 
                       FibuSerNr: Integer; ClientVersion: Integer): OleVariant;
    function OpenData(TabName: OleVariant; Filter: OleVariant; Sort: OleVariant; 
                      var AnzRecs: Integer; var RecSize: Integer): Integer;
    function CloseData(Handle: Integer): WordBool;
    function GetData(Handle: Integer; StartPos: Integer; var AnzRecs: Integer): OleVariant;
    function SortData(Handle: Integer; Sort: OleVariant): WordBool;
    function SearchData(Handle: Integer; SearchMode: Integer; SearchStr: OleVariant; 
                        out Rec: OleVariant): Integer;
    function SetData(Handle: Integer; AtPos: Integer; Mode: Integer; DataRec: OleVariant): WordBool;
    function Buchen(Data: OleVariant; Modus: Integer): OleVariant;
    function LoadIniData(IniTyp: Integer; out IsLoad: WordBool): OleVariant;
    function SaveIniData(IniTyp: Integer; Value: OleVariant): WordBool;
    function GetPopUpItems(PopUpID: Integer): OleVariant;
    function LoadStream(aStreamNr: Integer; out IsLoad: WordBool): OleVariant;
    function SaveStream(aStreamNr: Integer; Value: OleVariant): WordBool;
    function HandleData(FuncNr: Integer; SubFuncNr: Integer; var IO_DATA: OleVariant; 
                        var DataLen: Integer): Integer;
    property DefaultInterface: IFEC read GetDefaultInterface;
    property Mandant: Integer read Get_Mandant write Set_Mandant;
    property Buchdatum: Integer read Get_Buchdatum write Set_Buchdatum;
    property IsProgressWindowEnabled: WordBool read Get_IsProgressWindowEnabled write Set_IsProgressWindowEnabled;
    property IsMsgOnDataChanged: WordBool read Get_IsMsgOnDataChanged write Set_IsMsgOnDataChanged;
  published
  end;

// *********************************************************************//
// Die Klasse CoCallBackObj stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface ICallBackObj, dargestellt
// von CoClass CallBackObj, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoCallBackObj = class
    class function Create: ICallBackObj;
    class function CreateRemote(const MachineName: string): ICallBackObj;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TCallBackObj
// Hilfe-String      : Callback Container im Client
// Standard-Interface: ICallBackObj
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TCallBackObj = class(TOleServer)
  private
    FIntf: ICallBackObj;
    function GetDefaultInterface: ICallBackObj;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICallBackObj);
    procedure Disconnect; override;
    property DefaultInterface: ICallBackObj read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// Die Klasse CoFNClientApplication stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IFNClientApplication, dargestellt
// von CoClass FNClientApplication, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoFNClientApplication = class
    class function Create: IFNClientApplication;
    class function CreateRemote(const MachineName: string): IFNClientApplication;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TFNClientApplication
// Hilfe-String      : FNClientApplication Objekt
// Standard-Interface: IFNClientApplication
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TFNClientApplication = class(TOleServer)
  private
    FIntf: IFNClientApplication;
    function GetDefaultInterface: IFNClientApplication;
  protected
    procedure InitServerData; override;
    function Get_KeepAlive: WordBool;
    procedure Set_KeepAlive(Value: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFNClientApplication);
    procedure Disconnect; override;
    procedure Kontoauskunft(aKontonummer: Integer);
    procedure CorporatePlannerAuskunft(const aKonto: WideString; aMandant: Integer; 
                                       aDatumAb: TDateTime; aDatumBis: TDateTime);
    property DefaultInterface: IFNClientApplication read GetDefaultInterface;
    property KeepAlive: WordBool read Get_KeepAlive write Set_KeepAlive;
  published
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses System.Win.ComObj;

class function CoFEC.Create: IFEC;
begin
  Result := CreateComObject(CLASS_FEC) as IFEC;
end;

class function CoFEC.CreateRemote(const MachineName: string): IFEC;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FEC) as IFEC;
end;

procedure TFEC.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A2D2DB53-181E-11D3-B2AF-0060974B958A}';
    IntfIID:   '{A2D2DB51-181E-11D3-B2AF-0060974B958A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFEC.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFEC;
  end;
end;

procedure TFEC.ConnectTo(svrIntf: IFEC);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFEC.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFEC.GetDefaultInterface: IFEC;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TFEC.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFEC.Destroy;
begin
  inherited Destroy;
end;

function TFEC.Get_Mandant: Integer;
begin
  Result := DefaultInterface.Mandant;
end;

procedure TFEC.Set_Mandant(Value: Integer);
begin
  DefaultInterface.Mandant := Value;
end;

function TFEC.Get_Buchdatum: Integer;
begin
  Result := DefaultInterface.Buchdatum;
end;

procedure TFEC.Set_Buchdatum(Value: Integer);
begin
  DefaultInterface.Buchdatum := Value;
end;

function TFEC.Get_IsProgressWindowEnabled: WordBool;
begin
  Result := DefaultInterface.IsProgressWindowEnabled;
end;

procedure TFEC.Set_IsProgressWindowEnabled(Value: WordBool);
begin
  DefaultInterface.IsProgressWindowEnabled := Value;
end;

function TFEC.Get_IsMsgOnDataChanged: WordBool;
begin
  Result := DefaultInterface.IsMsgOnDataChanged;
end;

procedure TFEC.Set_IsMsgOnDataChanged(Value: WordBool);
begin
  DefaultInterface.IsMsgOnDataChanged := Value;
end;

function TFEC.Anmeldung(Computername: OleVariant; Username: OleVariant; Benutzername: OleVariant; 
                        Passwort: OleVariant; const CallBack: ICallBack; Packdata: WordBool; 
                        FibuSerNr: Integer; ClientVersion: Integer): OleVariant;
begin
  Result := DefaultInterface.Anmeldung(Computername, Username, Benutzername, Passwort, CallBack, 
                                       Packdata, FibuSerNr, ClientVersion);
end;

function TFEC.OpenData(TabName: OleVariant; Filter: OleVariant; Sort: OleVariant; 
                       var AnzRecs: Integer; var RecSize: Integer): Integer;
begin
  Result := DefaultInterface.OpenData(TabName, Filter, Sort, AnzRecs, RecSize);
end;

function TFEC.CloseData(Handle: Integer): WordBool;
begin
  Result := DefaultInterface.CloseData(Handle);
end;

function TFEC.GetData(Handle: Integer; StartPos: Integer; var AnzRecs: Integer): OleVariant;
begin
  Result := DefaultInterface.GetData(Handle, StartPos, AnzRecs);
end;

function TFEC.SortData(Handle: Integer; Sort: OleVariant): WordBool;
begin
  Result := DefaultInterface.SortData(Handle, Sort);
end;

function TFEC.SearchData(Handle: Integer; SearchMode: Integer; SearchStr: OleVariant; 
                         out Rec: OleVariant): Integer;
begin
  Result := DefaultInterface.SearchData(Handle, SearchMode, SearchStr, Rec);
end;

function TFEC.SetData(Handle: Integer; AtPos: Integer; Mode: Integer; DataRec: OleVariant): WordBool;
begin
  Result := DefaultInterface.SetData(Handle, AtPos, Mode, DataRec);
end;

function TFEC.Buchen(Data: OleVariant; Modus: Integer): OleVariant;
begin
  Result := DefaultInterface.Buchen(Data, Modus);
end;

function TFEC.LoadIniData(IniTyp: Integer; out IsLoad: WordBool): OleVariant;
begin
  Result := DefaultInterface.LoadIniData(IniTyp, IsLoad);
end;

function TFEC.SaveIniData(IniTyp: Integer; Value: OleVariant): WordBool;
begin
  Result := DefaultInterface.SaveIniData(IniTyp, Value);
end;

function TFEC.GetPopUpItems(PopUpID: Integer): OleVariant;
begin
  Result := DefaultInterface.GetPopUpItems(PopUpID);
end;

function TFEC.LoadStream(aStreamNr: Integer; out IsLoad: WordBool): OleVariant;
begin
  Result := DefaultInterface.LoadStream(aStreamNr, IsLoad);
end;

function TFEC.SaveStream(aStreamNr: Integer; Value: OleVariant): WordBool;
begin
  Result := DefaultInterface.SaveStream(aStreamNr, Value);
end;

function TFEC.HandleData(FuncNr: Integer; SubFuncNr: Integer; var IO_DATA: OleVariant; 
                         var DataLen: Integer): Integer;
begin
  Result := DefaultInterface.HandleData(FuncNr, SubFuncNr, IO_DATA, DataLen);
end;

class function CoCallBackObj.Create: ICallBackObj;
begin
  Result := CreateComObject(CLASS_CallBackObj) as ICallBackObj;
end;

class function CoCallBackObj.CreateRemote(const MachineName: string): ICallBackObj;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CallBackObj) as ICallBackObj;
end;

procedure TCallBackObj.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{91A1D96E-1C48-11D3-BE71-000000000000}';
    IntfIID:   '{91A1D96C-1C48-11D3-BE71-000000000000}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCallBackObj.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICallBackObj;
  end;
end;

procedure TCallBackObj.ConnectTo(svrIntf: ICallBackObj);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCallBackObj.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCallBackObj.GetDefaultInterface: ICallBackObj;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TCallBackObj.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCallBackObj.Destroy;
begin
  inherited Destroy;
end;

class function CoFNClientApplication.Create: IFNClientApplication;
begin
  Result := CreateComObject(CLASS_FNClientApplication) as IFNClientApplication;
end;

class function CoFNClientApplication.CreateRemote(const MachineName: string): IFNClientApplication;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FNClientApplication) as IFNClientApplication;
end;

procedure TFNClientApplication.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0673E5B2-AAA2-4304-8184-9C3B7202EAD6}';
    IntfIID:   '{0310C1EC-D7D7-4E4C-8E2E-E43819347F15}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFNClientApplication.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFNClientApplication;
  end;
end;

procedure TFNClientApplication.ConnectTo(svrIntf: IFNClientApplication);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFNClientApplication.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFNClientApplication.GetDefaultInterface: IFNClientApplication;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TFNClientApplication.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFNClientApplication.Destroy;
begin
  inherited Destroy;
end;

function TFNClientApplication.Get_KeepAlive: WordBool;
begin
  Result := DefaultInterface.KeepAlive;
end;

procedure TFNClientApplication.Set_KeepAlive(Value: WordBool);
begin
  DefaultInterface.KeepAlive := Value;
end;

procedure TFNClientApplication.Kontoauskunft(aKontonummer: Integer);
begin
  DefaultInterface.Kontoauskunft(aKontonummer);
end;

procedure TFNClientApplication.CorporatePlannerAuskunft(const aKonto: WideString; 
                                                        aMandant: Integer; aDatumAb: TDateTime; 
                                                        aDatumBis: TDateTime);
begin
  DefaultInterface.CorporatePlannerAuskunft(aKonto, aMandant, aDatumAb, aDatumBis);
end;

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TFEC, TCallBackObj, TFNClientApplication]);
end;

end.
