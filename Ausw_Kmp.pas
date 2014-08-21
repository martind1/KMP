unit Ausw_Kmp;
(* Auswertung Komponente (statt PrnSource zu verwenden)
   Autor: Martin Dambach
   Letzte Änderung:
   10.05.97        Erstellen
   25.10.97        todo:
                   UserCheckBoxes
                   UserEdits (Bemerkung,..)
            ok     chkDatum in Enabled Enabled
            ok     DfltDatum: (1.1.80) bisHeute:
            ok     Feldbezeichner in Dialog ändern:
                   - Zeile in Userfields einfügen:
                   entweder
                     Feldbezeichnung=<Feldname>
                   oder
                     NeueFeldbezeichnung=:<NameDerKomponente>
                     NameDerKomponente: Zeitspanne = LaDtmVon
                                        Bis        = LaDtmBis
                                        Einzelnachweis = chbEinzel
                                        Zwischensummen = chbZwSum
                                        Gruppensummen  = chbGrpSum
                                        Caption      = LaCaption
   25.01.98        UserButton1
                   OnUserButton1Click
   06.08.98        DateTime
   30.09.98        Caption nach PSrc
   10.05.00        BeforeDlg Ereignis
   21.08.00 JM     ddy2BisHeute
   25.04.05 MD     chkDtmBis
*)


interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, Quickrpt,
  Psrc_kmp, DPos_Kmp, Qwf_Form;

const
  MaxAuswFields = 12;  //n.b.

type
  TDfltDate = (ddAktTag,
               ddAktMonat,
               ddAktJahr,
               ddPrevTag,
               ddPrevMonat,
               ddPrevJahr,
               ddBisHeute,
               ddy2BisHeute,
               ddBisVorlMonat,
               ddNone,
               ddMonBisHeute,
               ddDayMon,               //alle Tage des akt.Monats, des akt.Jahres
               ddDayYear,              //-"-
               ddMonYear,              //alle Monate des akt.Jahres
               ddYearAll,              //alle Jahre (ab 1.1.1980)
               ddJahrBisHeute          //1 Jahr bis heute
               );
  TCheck = (chkEinzel, chkZwSum, chkGrpSum, chkDatum,
            chkUser1, chkUser2, chkUser3,
            chkNoDtmBis, chkNoFormat);  //No wg Kompatibilität
  TChecks = set of TCheck;
  TDateGroup = (dgDay, dgMonth, dgYear);

  TAusw = class(TPrnSource)
  private
    { Private-Deklarationen }
    FDataSource: TDataSource;
    FDateField: string;                            {Zeitspanne Feld}
    FUserFields: TValueList;                       {Felder zum Spezifizieren}
    FUserButton1: string;                          {Caption von User Button1}
    FDfltDate: TDfltDate;                          {Zeitspanne Vorgabe Jahr,Monat}
    FEnabled: TChecks;                             {Checkboxen:Eingabe erlaubt}
    FChecked: TChecks;                             {Checkboxen:markiert}
    FCloseAction: TCloseAction;
    FDateTime: boolean;
    FDateGroup: TDateGroup;
    FOnUserButton1Click: TNotifyEvent;
    FBeforeDlg: TBeforePrnEvent;
    procedure SetUserFields( Value: TValueList);
    procedure SetDateGroup(const Value: TDateGroup);
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
  public
    { Public-Deklarationen }
    DlgAusw: TqForm;
    DateStr: string;               {Datum für Überschrift}
    DtmVon, DtmBis: TDateTime;     {Auswertungszeitspanne}
    UserButtonPressed: integer;    //0=kein Button gedrückt
    procedure DoUserButton1Click( Sender: TObject);  {Methode aufrufen}
    procedure ToggleChecked(Check: TCheck; Toggle: boolean);
    procedure ToggleEnabled(Check: TCheck; Toggle: boolean);
    constructor Create( AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoQRepInit(Sender: TCustomQuickRep; var PrintReport: Boolean); override;
    procedure DoRun; override;     {Startet Dlg. Falls von LNav.DoPrn}
    procedure DoPrn;               {Startet Ausdruck. Von DlgAusw}
    property DateGroup: TDateGroup read FDateGroup write SetDateGroup;
  published
    { Published-Deklarationen }
    property DataSource: TDataSource read FDataSource write FDataSource;
    property DateField: string read FDateField write FDateField;
    property UserFields: TValueList read FUserFields write SetUserFields;
    property UserButton1: string read FUserButton1 write FUserButton1;
    property DfltDate: TDfltDate read FDfltDate write FDfltDate;
    property Enabled: TChecks read FEnabled write FEnabled;
    property Checked: TChecks read FChecked write FChecked;
    property CloseAction: TCloseAction read FCloseAction write FCloseAction default caNone;
    property DateTime: boolean read FDateTime write FDateTime;
    property OnUserButton1Click: TNotifyEvent read FOnUserButton1Click write FOnUserButton1Click;
    property BeforeDlg: TBeforePrnEvent read FBeforeDlg write FBeforeDlg;
  end;

var
  AuswId: integer;     {Zähler für AuswDlg-Formular Name}

implementation

uses
  TypInfo, 
  Prots, GNav_Kmp, Ausw_Dlg;

procedure TAusw.SetUserFields( Value: TValueList);
begin
  FUserFields.Assign( Value);
end;

procedure TAusw.ToggleChecked(Check: TCheck; Toggle: boolean);
begin
  if Toggle then
    Checked := Checked + [Check] else
    Checked := Checked - [Check];
end;

procedure TAusw.ToggleEnabled(Check: TCheck; Toggle: boolean);
begin
  if Toggle then
    Enabled := Enabled + [Check] else
    Enabled := Enabled - [Check];
end;

constructor TAusw.Create( AOwner: TComponent);
begin
  inherited Create( AOwner);
  FUserFields := TValueList.Create;
  FUserFields.RightestEqual := true;
  Options := [psSetDisplay];     {psSetCaption}
  Enabled := [chkDatum];
  Checked := [];
  CopyFltr := false;
  OneRecord := false;
end;

procedure TAusw.Loaded;
begin
  inherited Loaded;
end;

destructor TAusw.Destroy;
begin
  if DlgAusw <> nil then
  begin
    TDlgAusw(DlgAusw).Ausw := nil;
    TDlgAusw(DlgAusw).Release;
  end;
  FUserFields.Free;
  inherited Destroy;
end;

procedure TAusw.DoRun;
var
  Kurz: string;
  Fertig: boolean;
begin
  UserButtonPressed := 0;
  if DlgAusw = nil then
  begin
    Fertig := false;
    if Assigned(FBeforeDlg) then
      FBeforeDlg(self, Fertig);
    if not Fertig then
    begin
      LoadedFltrList.Assign(FltrList);
      Inc( AuswId);
      Kurz := 'AUSW'+IntToStr(AuswId);
      GNavigator.AddTempForm( Kurz, TDlgAusw);
      DlgAusw := GNavigator.StartForm( self, Kurz);
    end;
  end else
    DlgAusw.ShowNormal(wsNormal);
end;

procedure TAusw.DoQRepInit(Sender: TCustomQuickRep; var PrintReport: Boolean);
(* Initialisieren QuickRep *)
begin
  {mit psSetCaption
  Sender.ReportTitle := Display;     {Titel mit Datum}
  if (DateStr <> '') and (DfltDate <> ddNone) then
    Sender.ReportTitle := LongCaption(Sender.ReportTitle, DateStr);
  inherited DoQRepInit( Sender, PrintReport);
end;

procedure TAusw.SetDateGroup(const Value: TDateGroup);
begin
  if FDateGroup <> Value then
  begin
    FDateGroup := Value;
    if DlgAusw <> nil then
    begin
      TDlgAusw(DlgAusw).rgDtm.ItemIndex := ord(Value);
    end;
  end;
end;

procedure TAusw.DoUserButton1Click( Sender: TObject);
begin
  UserButtonPressed := 1;
  if Assigned( FOnUserButton1Click) then
    FOnUserButton1Click( Sender);
end;

procedure TAusw.DoPrn;
(* Startet Ausdruck. Von DlgAusw *)
begin
  inherited DoRun;
end;

end.
