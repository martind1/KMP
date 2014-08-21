unit Scale99_TLB;

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
// Datei am 08.11.2012 03:36:59 erzeugt aus der unten beschriebenen Typbibliothek.

// ************************************************************************  //
// Typbib.: d:\Mailbox\Rowasoft\eScale\Scale99\s99_r1\S99_R1.exe (1)
// LIBID: {C5CA46C0-A8B2-11D4-8710-0040054A2998}
// LCID: 0
// Hilfedatei: 
// Hilfe-String: Scale99 Bibliothek
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
  Scale99MajorVersion = 1;
  Scale99MinorVersion = 1;

  LIBID_Scale99: TGUID = '{C5CA46C0-A8B2-11D4-8710-0040054A2998}';

  IID_IScale: TGUID = '{C5CA46C1-A8B2-11D4-8710-0040054A2998}';
  CLASS_Scale: TGUID = '{C5CA46C3-A8B2-11D4-8710-0040054A2998}';
  IID_IServ: TGUID = '{CB0184A0-CC3E-11D4-8710-0040054A2998}';
  CLASS_Serv: TGUID = '{CB0184A2-CC3E-11D4-8710-0040054A2998}';
type

// *********************************************************************//
// Forward-Deklaration von in der Typbibliothek definierten Typen                     
// *********************************************************************//
  IScale = interface;
  IScaleDisp = dispinterface;
  IServ = interface;
  IServDisp = dispinterface;

// *********************************************************************//
// Deklaration von in der Typbibliothek definierten CoClasses
// (HINWEIS: Hier wird jede CoClass ihrem Standard-Interface zugewiesen)              
// *********************************************************************//
  Scale = IScale;
  Serv = IServ;


// *********************************************************************//
// Interface: IScale
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C5CA46C1-A8B2-11D4-8710-0040054A2998}
// *********************************************************************//
  IScale = interface(IDispatch)
    ['{C5CA46C1-A8B2-11D4-8710-0040054A2998}']
  end;

// *********************************************************************//
// DispIntf:  IScaleDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C5CA46C1-A8B2-11D4-8710-0040054A2998}
// *********************************************************************//
  IScaleDisp = dispinterface
    ['{C5CA46C1-A8B2-11D4-8710-0040054A2998}']
  end;

// *********************************************************************//
// Interface: IServ
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CB0184A0-CC3E-11D4-8710-0040054A2998}
// *********************************************************************//
  IServ = interface(IDispatch)
    ['{CB0184A0-CC3E-11D4-8710-0040054A2998}']
    procedure Hide; safecall;
    procedure Show; safecall;
    procedure Position(x: Integer; y: Integer); safecall;
    procedure Zero; safecall;
    function Get_Value: OleVariant; safecall;
    function Get_Regist: OleVariant; safecall;
    procedure SetTare; safecall;
    procedure ClrTare; safecall;
    procedure SetTime; safecall;
    procedure Switch(w: Integer); safecall;
    property Value: OleVariant read Get_Value;
    property Regist: OleVariant read Get_Regist;
  end;

// *********************************************************************//
// DispIntf:  IServDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CB0184A0-CC3E-11D4-8710-0040054A2998}
// *********************************************************************//
  IServDisp = dispinterface
    ['{CB0184A0-CC3E-11D4-8710-0040054A2998}']
    procedure Hide; dispid 1;
    procedure Show; dispid 2;
    procedure Position(x: Integer; y: Integer); dispid 3;
    procedure Zero; dispid 4;
    property Value: OleVariant readonly dispid 8;
    property Regist: OleVariant readonly dispid 9;
    procedure SetTare; dispid 10;
    procedure ClrTare; dispid 11;
    procedure SetTime; dispid 12;
    procedure Switch(w: Integer); dispid 5;
  end;

// *********************************************************************//
// Die Klasse CoScale stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IScale, dargestellt
// von CoClass Scale, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoScale = class
    class function Create: IScale;
    class function CreateRemote(const MachineName: string): IScale;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TScale
// Hilfe-String      : Scale Objekt
// Standard-Interface: IScale
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TScale = class(TOleServer)
  private
    FIntf: IScale;
    function GetDefaultInterface: IScale;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IScale);
    procedure Disconnect; override;
    property DefaultInterface: IScale read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// Die Klasse CoServ stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IServ, dargestellt
// von CoClass Serv, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoServ = class
    class function Create: IServ;
    class function CreateRemote(const MachineName: string): IServ;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TServ
// Hilfe-String      : Serv Objekt
// Standard-Interface: IServ
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TServ = class(TOleServer)
  private
    FIntf: IServ;
    function GetDefaultInterface: IServ;
  protected
    procedure InitServerData; override;
    function Get_Value: OleVariant;
    function Get_Regist: OleVariant;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IServ);
    procedure Disconnect; override;
    procedure Hide;
    procedure Show;
    procedure Position(x: Integer; y: Integer);
    procedure Zero;
    procedure SetTare;
    procedure ClrTare;
    procedure SetTime;
    procedure Switch(w: Integer);
    property DefaultInterface: IServ read GetDefaultInterface;
    property Value: OleVariant read Get_Value;
    property Regist: OleVariant read Get_Regist;
  published
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses System.Win.ComObj;

class function CoScale.Create: IScale;
begin
  Result := CreateComObject(CLASS_Scale) as IScale;
end;

class function CoScale.CreateRemote(const MachineName: string): IScale;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Scale) as IScale;
end;

procedure TScale.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{C5CA46C3-A8B2-11D4-8710-0040054A2998}';
    IntfIID:   '{C5CA46C1-A8B2-11D4-8710-0040054A2998}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TScale.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IScale;
  end;
end;

procedure TScale.ConnectTo(svrIntf: IScale);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TScale.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TScale.GetDefaultInterface: IScale;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TScale.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TScale.Destroy;
begin
  inherited Destroy;
end;

class function CoServ.Create: IServ;
begin
  Result := CreateComObject(CLASS_Serv) as IServ;
end;

class function CoServ.CreateRemote(const MachineName: string): IServ;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Serv) as IServ;
end;

procedure TServ.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{CB0184A2-CC3E-11D4-8710-0040054A2998}';
    IntfIID:   '{CB0184A0-CC3E-11D4-8710-0040054A2998}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TServ.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IServ;
  end;
end;

procedure TServ.ConnectTo(svrIntf: IServ);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TServ.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TServ.GetDefaultInterface: IServ;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TServ.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TServ.Destroy;
begin
  inherited Destroy;
end;

function TServ.Get_Value: OleVariant;
begin
  Result := DefaultInterface.Value;
end;

function TServ.Get_Regist: OleVariant;
begin
  Result := DefaultInterface.Regist;
end;

procedure TServ.Hide;
begin
  DefaultInterface.Hide;
end;

procedure TServ.Show;
begin
  DefaultInterface.Show;
end;

procedure TServ.Position(x: Integer; y: Integer);
begin
  DefaultInterface.Position(x, y);
end;

procedure TServ.Zero;
begin
  DefaultInterface.Zero;
end;

procedure TServ.SetTare;
begin
  DefaultInterface.SetTare;
end;

procedure TServ.ClrTare;
begin
  DefaultInterface.ClrTare;
end;

procedure TServ.SetTime;
begin
  DefaultInterface.SetTime;
end;

procedure TServ.Switch(w: Integer);
begin
  DefaultInterface.Switch(w);
end;

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TScale, TServ]);
end;

end.
