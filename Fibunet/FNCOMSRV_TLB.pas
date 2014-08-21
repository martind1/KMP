unit FNCOMSRV_TLB;

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
// Datei am 09.11.2012 17:08:05 erzeugt aus der unten beschriebenen Typbibliothek.

// ************************************************************************  //
// Typbib.: C:\FibuNet\FNCOMSRV.dll (1)
// LIBID: {6C46C50C-9A89-4D7B-854A-5CA6B2E4EF99}
// LCID: 0
// Hilfedatei: 
// Hilfe-String: FibuNet v4.x COM-DB-Schnittstelle
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
  FNCOMSRVMajorVersion = 2;
  FNCOMSRVMinorVersion = 0;

  LIBID_FNCOMSRV: TGUID = '{6C46C50C-9A89-4D7B-854A-5CA6B2E4EF99}';

  IID_IFNFactory: TGUID = '{62E713E8-F920-457A-B3AE-936F377A51CA}';
  CLASS_FNFactory: TGUID = '{B02C2E24-78AB-447C-AE84-25F82607B44D}';
  IID_IUser: TGUID = '{E29B6B1D-30C4-4FE5-BC2C-12B9AB095984}';
  CLASS_User: TGUID = '{85676612-B97D-46B1-9D9B-B30CE4247183}';
  IID_IMandant: TGUID = '{F48EAEC3-8F81-4356-94F5-0D42EF4FFB59}';
  CLASS_Mandant: TGUID = '{DB051B59-4B88-4998-BBC2-06CE20C4E3A7}';
  IID_IAdresse: TGUID = '{D40FC78D-E961-4345-83A0-94576D8C8FA7}';
  CLASS_Adresse: TGUID = '{B0D20D02-AAC5-4973-8E1D-62ED39B8BFF4}';
  IID_ILand: TGUID = '{F182A2C6-5F5D-43E3-A9E3-4E3B8584EEB9}';
  CLASS_Land: TGUID = '{A1743BD4-02A1-4C37-B86F-58915FD8CEDE}';
  IID_IDebitor: TGUID = '{E3E62CF7-B5FE-4F37-98DD-6CE5AD4C7505}';
  CLASS_Debitor: TGUID = '{12C2334A-049A-485D-9F7F-7F98F45507E1}';
  IID_IKonto: TGUID = '{728D1D5B-1799-4139-9CC5-BDE06BDD2DFD}';
  CLASS_Konto: TGUID = '{93C53CC2-35EB-4BFA-8361-6BDAF6A3C25A}';
  IID_ISaldo: TGUID = '{5954A0E5-1E20-4DFD-8769-56F403985F0E}';
  CLASS_Saldo: TGUID = '{0C8EEC64-F0A2-4042-A823-7EC285BA803D}';
  IID_IPosten: TGUID = '{D9C25C8A-E7A4-48AA-A638-CCEA852FB5B5}';
  CLASS_Posten: TGUID = '{DFDE917C-1425-4438-ABAC-30E391EBD654}';
  IID_INavigate: TGUID = '{45ADFB97-6F13-47B6-BF10-F488AEA08CEB}';
  CLASS_Navigate: TGUID = '{79DE98BA-C039-4B74-873F-6F7597AB79F6}';
  IID_IKontierung: TGUID = '{8B8A6BB9-8950-4755-B35C-6BC7F281D6A2}';
  CLASS_Kontierung: TGUID = '{7C523A84-53E5-43E0-A0CF-139F8BF857F6}';
  IID_IJournal: TGUID = '{2AD3D557-8A90-40D1-A136-064BE6D44454}';
  CLASS_Journal: TGUID = '{3930151F-3BE1-4126-AEB3-49936AEF3042}';
  IID_IKLRJournal: TGUID = '{DB0BA66D-E770-4A28-9985-4F62B8837510}';
  CLASS_KLRJournal: TGUID = '{6C644117-EA21-42E1-937F-64A42AC89995}';
  IID_IFestkonto: TGUID = '{EBF5D737-E60A-43BD-8DF7-E2BFE361B01D}';
  CLASS_Festkonto: TGUID = '{B905E867-5C8E-43B7-B1BC-98CA47D00E82}';
  IID_IKreditor: TGUID = '{883889E8-44FD-402B-9ED9-16011E68D8EF}';
  CLASS_Kreditor: TGUID = '{AE7FB50A-F5CD-414C-A45A-CBF89AE53FEC}';
  IID_ISachkonto: TGUID = '{B9C004D3-06FA-44FB-B65A-A164FE943443}';
  CLASS_Sachkonto: TGUID = '{39C40436-6C94-4283-B16E-E0B8DA30FA8F}';
  IID_IBuchtext: TGUID = '{E7D65604-3692-4FBA-9A87-061D5B95CCC4}';
  CLASS_Buchtext: TGUID = '{E85F47D6-CB74-4E18-950E-4FB8E6F34179}';
  IID_ISteuer: TGUID = '{22C0CE96-24A8-4709-9E06-A2FF7AF6D473}';
  CLASS_Steuer: TGUID = '{73BCE1A3-62FB-416E-B83C-DD2F106B150D}';
  IID_IFinanzamt: TGUID = '{674A1634-FB20-4628-A844-B8EDA3816C13}';
  CLASS_Finanzamt: TGUID = '{8385D76C-6969-4F36-A2F7-5E37D1C20582}';
  IID_IBank: TGUID = '{B8862CA1-FB09-436E-ACED-030B76C2B036}';
  CLASS_Bank: TGUID = '{9C7E8B29-B247-41FC-9BFE-D5ADE539060D}';
  IID_IKontenbereich: TGUID = '{7972BFC3-14AE-4196-8B20-878EB497C9F9}';
  CLASS_Kontenbereich: TGUID = '{94D8857F-A6BE-4C20-9B94-9624030FE533}';
  IID_IBankverbindung: TGUID = '{31B86FDE-9985-4E8F-BBFE-0D7BFC116AD2}';
  CLASS_Bankverbindung: TGUID = '{BC37C9A3-3E07-4AF7-A3CC-6FA1E9A1F033}';
  IID_IGruppe: TGUID = '{36FFA492-B38C-4E00-A40B-4B8830C94AFD}';
  CLASS_Gruppe: TGUID = '{D719FAA3-F645-4D1F-A10A-4C3D15978441}';
  IID_IKostenart: TGUID = '{B8AA063F-0902-48B5-9DFD-1F28EF9FF9EC}';
  CLASS_Kostenart: TGUID = '{834EB643-83A7-4E78-A173-4CAD8B1E3EBA}';
  IID_IKostenstelle: TGUID = '{92DAE5A4-DCB5-497A-B729-838FD8284E3C}';
  CLASS_Kostenstelle: TGUID = '{EE6C870F-1A19-4D05-8F2E-122E93D69536}';
  IID_IBezugsgroesse: TGUID = '{2DBE782A-A5FE-471D-AD3C-91216B4C7376}';
  CLASS_Bezugsgroesse: TGUID = '{A1DD0C3A-A1F2-4600-B98C-0F9EFEB0C8D0}';
  IID_IPlanmenge: TGUID = '{76F18D94-865F-4667-B88C-027CC0F7AE7A}';
  CLASS_Planmenge: TGUID = '{08EFFDEE-AC57-446A-8C1F-E33BB1C765BB}';
  IID_IUSt: TGUID = '{80C79C66-0713-45D8-9999-8FE3C5525FBD}';
  CLASS_USt: TGUID = '{5D822809-F4E0-46C7-AFFE-80D6B1236DE6}';
  IID_IKurs: TGUID = '{8CB1660A-7274-4A68-8EBC-22D8A0388E6B}';
  CLASS_Kurs: TGUID = '{3721D2A7-393F-4EFE-8E92-2EB6F8637E27}';
  IID_IWaehrung: TGUID = '{7A0623CD-D78E-4584-9B6D-3C57369992B6}';
  CLASS_Waehrung: TGUID = '{9A1C1EB4-3237-4A37-BEF7-8B5E6904554A}';
  IID_IMahn: TGUID = '{0F6EC919-BF2F-4018-9036-3DACD1D62C57}';
  CLASS_Mahn: TGUID = '{B4A033DD-FE53-485E-894E-76ABB2CBDA70}';
  IID_IZahlkondition: TGUID = '{627A486E-3965-4E95-A7E3-E48643BE12AE}';
  CLASS_Zahlkondition: TGUID = '{5CB158A1-FF48-49DA-8F1D-DA170902DB2C}';
  IID_IFNReport: TGUID = '{790FCD48-C23E-449E-8B32-714965725863}';
  CLASS_FNReport: TGUID = '{0477E266-5303-41F0-9EA5-245FA3B7744E}';
  IID_IChooseMandant: TGUID = '{A42D9E77-71E7-4FA9-86A4-03F7E4116461}';
  CLASS_ChooseMandant: TGUID = '{DFD80C51-BD3B-4347-A6BC-D6858E769DD7}';
  IID_IPasswort: TGUID = '{EEB4FA02-617F-4F9C-A83B-510D5699B86E}';
  CLASS_Passwort: TGUID = '{3DA7F71B-A8B7-469B-833F-8D3EA8C3B84C}';
  IID_IBuchen: TGUID = '{08089F0D-B87E-4402-9649-EF3288D8EB81}';
  CLASS_Buchen: TGUID = '{0AD355FD-0649-4129-9413-5646451B82B3}';
  IID_IKostenstelleart: TGUID = '{B4660F77-9875-4625-BEDA-321EFBD2D2E6}';
  CLASS_Kostenstelleart: TGUID = '{09F58B84-7524-44B7-8121-B7F717EBE030}';
  IID_IFNImport: TGUID = '{1CC09930-7F41-4001-B2D4-5F4B289E1261}';
  CLASS_FNImport: TGUID = '{6DA87207-D6F1-4AEE-8D5E-CC3A827AC141}';
  IID_IREB: TGUID = '{7F83A8A9-142D-4657-BCED-270B0D922303}';
  CLASS_REB: TGUID = '{B2B72981-6CA4-4EF8-8C79-97A6DEADBD28}';
  IID_IOrt: TGUID = '{0D547D43-D232-4538-A1F8-BE47F281D4BE}';
  CLASS_Ort: TGUID = '{77CDFBA5-921B-45D2-8110-90462BA6D9CB}';
  IID_ILizenz: TGUID = '{C8017AD3-C3CE-473C-994C-2AF4553D644B}';
  CLASS_Lizenz: TGUID = '{A0416A15-4E1D-46AE-BF4B-859587A74C40}';
  IID_ICmdBuchen: TGUID = '{CD7D8E7E-4765-4556-9746-7280DE64FE5E}';
  CLASS_CmdBuchen: TGUID = '{45F56E9A-BD90-450C-BC71-3CBF3CF556D5}';
  IID_ICmdPosten: TGUID = '{9780F9D4-24F1-453D-A396-04A52AB2ED11}';
  CLASS_CmdPosten: TGUID = '{93CAEB71-617B-4CBA-ADC0-7FF056B40FDE}';
  IID_ICmdKLR: TGUID = '{F8580485-4A78-49C2-9766-C4BD6A49C3DB}';
  CLASS_CmdKLR: TGUID = '{197492FA-BB73-4457-B87A-17E5A9EBAC64}';
  IID_IKreditversicherung: TGUID = '{E2ECF706-2C7D-481A-A728-604B3D4A83DB}';
  CLASS_Kreditversicherung: TGUID = '{10708077-6D33-43AB-ACD0-76822E928A44}';
  IID_IArchiv: TGUID = '{8A5D903D-8898-4A58-AE69-0E767BE5F576}';
  CLASS_Archiv: TGUID = '{6B4F7DCE-C47F-496C-8C94-F2BE617B8303}';
  IID_IArchivierung: TGUID = '{630829FB-5738-4A10-BC7B-9EF47C2330ED}';
  CLASS_Archivierung: TGUID = '{38358A85-87CD-461D-ACB7-013FAA59654F}';
  IID_IBgMw: TGUID = '{5288A160-018C-4480-AF36-40FC8C7E93CA}';
  CLASS_BgMw: TGUID = '{0BA927B0-DC9C-4F05-8179-3543FA55A773}';
  IID_IBatchScript: TGUID = '{413A0B81-D980-4017-A58E-E604159136DB}';
  CLASS_BatchScript: TGUID = '{2F153B30-416F-4EB5-BC5E-D4DB6F02EDC0}';
  IID_IXML: TGUID = '{D18DD702-3327-4A56-9E99-6232AD16DEFC}';
  CLASS_XML: TGUID = '{3C3E8E7D-5152-435D-A4A3-6619D1B1D33B}';
  IID_IDCUebFiles: TGUID = '{E338E8EE-237E-4F01-B1A4-E463633785FB}';
  CLASS_DCUebFiles: TGUID = '{E1C1F422-0DA6-4150-8645-657C2720E116}';
  IID_IBgBeweg: TGUID = '{AAF13146-6868-4063-8707-DF52B8744F02}';
  CLASS_BgMwBeweg: TGUID = '{5CB9E442-E37B-4B4B-B87E-D0225BA93C5A}';
  IID_IInventar: TGUID = '{C14070AC-C87D-4BD6-B0CD-188EC0E50E5A}';
  CLASS_Inventar: TGUID = '{DC568BF6-26B6-4F52-BB96-DEEF753C1DA6}';
  IID_IInventarebene: TGUID = '{1DCE2E2C-5880-4BCC-87BA-6BF04613295C}';
  CLASS_Inventarebene: TGUID = '{38B256CB-9CE0-4D74-9CEC-978778AA52F3}';
  IID_IInventarstatus: TGUID = '{844A42E0-CF22-4460-8040-7BFD6B2AF300}';
  CLASS_Inventarstatus: TGUID = '{0BAE11DC-03BA-4D84-A496-5DBA653B5226}';
  IID_IInventarKLRAnteil: TGUID = '{33AA927D-2563-4C87-8D92-A34017C4851E}';
  CLASS_InventarKLRAnteil: TGUID = '{ECE8F1C1-522C-4EF5-A74C-7140972834A6}';
  IID_IServer: TGUID = '{15EC12A5-BC1E-4B53-9732-7B72A85F117B}';
  CLASS_Server: TGUID = '{1F63F551-A2E9-403C-81C9-26A60AEF8E3F}';
  IID_IBranche: TGUID = '{C1BB5972-3E8E-4733-95B8-8B53F26412BF}';
  CLASS_Branche: TGUID = '{38F5606A-5843-4A2C-A5B7-ADEFDE292E42}';
  IID_IWechsel: TGUID = '{69B51AF2-1309-4E18-9ED3-35B32FB3021C}';
  CLASS_Wechsel: TGUID = '{9C2508FD-6E39-4E5E-8C16-DD92083EA79C}';
  IID_ITageskurs: TGUID = '{2B67894D-57D6-4227-95A4-DAE954213CE5}';
  CLASS_Tageskurs: TGUID = '{641E0EB3-6004-4D90-AFAD-878DA76BCCD2}';
  IID_IEGSteuer: TGUID = '{E6BDBF00-3BC4-444C-9F3B-B4A64DE75F28}';
  CLASS_EGSteuer: TGUID = '{5FD0A957-2A74-46E5-85E1-1CC74EF0FDE9}';
  IID_IScheck: TGUID = '{971F3438-32FF-49D9-A580-3B456E82F760}';
  CLASS_Scheck: TGUID = '{970004B0-C013-4C64-98C4-D59E126BAFB5}';
  IID_IInventarJournal: TGUID = '{101698A4-FE62-4295-A4A6-BCA1A1FE1C95}';
  CLASS_InventarJournal: TGUID = '{7DE1D2A9-E5CC-431B-BC92-075228C17710}';
  IID_IKreditkarte: TGUID = '{A9F5CAD6-AE63-4BB1-8028-12F9A32F5EC5}';
  CLASS_Kreditkarte: TGUID = '{2F06231A-7F8A-47F4-A392-CDC56E389230}';
  IID_IVerteilung: TGUID = '{E5014709-DDF1-4613-A69C-9B225A2A6ECA}';
  CLASS_Verteilung: TGUID = '{F4CECD1E-5406-453B-8B4A-C6C1BEF2760C}';
  IID_IElster: TGUID = '{92B40CEE-D6CA-4683-AE0F-018476E8F954}';
  CLASS_Elster: TGUID = '{D8280740-9944-459E-801D-EB5ED4B94F12}';
  IID_IKLRAutomatik: TGUID = '{D870FD19-3731-4A17-BA47-41FF41C4DD62}';
  CLASS_KLRAutomatik: TGUID = '{979F9FB3-ECD9-45EB-87B8-FD76A72DA408}';

// *********************************************************************//
// Deklaration von in der Typbibliothek definierten Aufzählungen                     
// *********************************************************************//
// Konstanten für enum EKontoarten
type
  EKontoarten = TOleEnum;
const
  kaBilanz = $00000000;
  kaDiffbesteuerung = $00000001;
  kaEinkaufskonto = $00000002;
  kaInventarkonto = $00000003;
  kaKostenkonto = $00000004;
  kaNeutraleskonto = $00000005;
  kaTouristik = $00000006;
  kaVerkaufskonto = $00000007;
  kaZahlungskonto = $00000008;
  kaPrivatkonto = $00000009;
  kaWechselkonto = $0000000A;
  kaSammelkonto = $0000000B;

// Konstanten für enum EBilGuVZuordnung
type
  EBilGuVZuordnung = TOleEnum;
const
  zoOhne = $00000000;
  zoBilanz = $00000001;
  zoGuV = $00000002;

// Konstanten für enum ESammelKtArt
type
  ESammelKtArt = TOleEnum;
const
  saNormal = $00000000;
  saForderungen = $00000001;
  saVerbindlichkeiten = $00000002;

// Konstanten für enum EKontotypen
type
  EKontotypen = TOleEnum;
const
  ktAlleKonten = $00000000;
  ktDebitor = $00000001;
  ktKreditor = $00000002;
  ktSachkonto = $00000003;
  ktKostenstelle = $00000004;
  ktKostentraeger = $00000007;
  ktKostenart = $00000008;
  ktKeinKonto = $FFFFFFFF;

// Konstanten für enum EZahlarten
type
  EZahlarten = TOleEnum;
const
  zaOhne = $00000000;
  zaLastschrift = $00000001;
  zaScheck = $00000002;
  zaUeberweisung = $00000003;
  zaDC = $00000004;
  zaGutschrift = $00000005;
  zaAbbuchung = $00000006;
  zaAvis = $00000007;
  zaAZV = $00000008;
  zaVerrechnung = $00000009;
  zaReserve1 = $0000000A;
  zaReserve2 = $0000000B;
  zaReserve3 = $0000000C;
  zaReserve4 = $0000000D;
  zaReserve5 = $0000000E;
  zaReserve6 = $0000000F;

// Konstanten für enum ECmdTypen
type
  ECmdTypen = TOleEnum;
const
  cmBuchen = $0000044C;
  cmPosten = $00000456;
  cmKLR = $00000460;

// Konstanten für enum EModule
type
  EModule = TOleEnum;
const
  modBasis = $00000000;
  modZentralregulierung = $00000001;
  modAusland = $00000002;
  modWechselverwaltung = $00000003;
  modKasse = $00000004;
  modREB = $00000005;
  modInventar = $00000006;
  modKLR = $00000007;
  modReportgenerator = $00000008;
  modIntrastatmeldung = $00000009;
  modKontenverzinsung = $0000000A;
  modDebitorenverzinsung = $0000000B;
  modKonzern = $0000000C;
  modBanking = $0000000D;
  modTouristik = $0000000E;
  modArchivierung = $0000000F;
  modAnalyse = $00000010;
  modKreditversicherung = $00000011;
  modWiederkehrendeRechnung = $00000012;
  modZentralfakturierung = $00000013;
  modProvisionsabrechnung = $00000014;
  modImportProSoft = $00000015;
  modImpAral = $00000016;
  modImpDatev = $00000017;
  modImpLexware = $00000018;
  modExpCorpPlanner = $00000019;
  modKtoDoc = $0000001A;
  modBerAnpassen = $0000001B;
  modBatchImport = $0000001C;
  modExpSalden = $0000001D;
  modExpVolkswagen = $0000001E;
  modExpMFBPlanning = $0000001F;
  modImpVoksHonorar = $00000020;
  modImpWerWiSo = $00000021;
  modBIGPlanner = $00000022;
  modZGF = $00000023;
  modWeb = $00000024;
  modImpEuromobil = $00000025;
  modPremium = $00000026;
  modwebREB = $00000027;
  modMassenMail = $00000028;
  modWfDesigner = $00000029;
  modZuschussverwaltung = $0000002A;
  modImpEcaros = $0000002B;
  modImpIntercash = $0000002C;

// Konstanten für enum EUStArten
type
  EUStArten = TOleEnum;
const
  ua0 = $00000000;
  uaV = $00000001;
  uaM = $00000002;
  uaF = $00000003;

// Konstanten für enum EOpArten
type
  EOpArten = TOleEnum;
const
  oaRechnung = $00000001;
  oaGutschrift = $00000003;
  oaZahlung = $00000002;
  oaStorno = $00000005;
  oaVerech = $00000004;

// Konstanten für enum EKostentypen
type
  EKostentypen = TOleEnum;
const
  ktFix = $00000000;
  ktVar = $00000001;
  ktLeistung = $00000002;

// Konstanten für enum EArchivTypen
type
  EArchivTypen = TOleEnum;
const
  arvErfassung = $00000001;
  arvExport = $00000002;
  arvImport = $00000003;
  arvZugeordnet = $00000004;
  arvDifferenz = $00000005;

// Konstanten für enum EXMLTableTypen
type
  EXMLTableTypen = TOleEnum;
const
  xmtDebi = $00000001;
  xmtKred = $00000002;
  xmtSach = $00000003;
  xmtKoSt = $00000004;
  xmtKStKA = $00000005;
  xmtKTrKA = $00000006;
  xmtKoTr = $00000007;
  xmtKArt = $00000008;
  xmtPers = $00000009;
  xmtKto = $0000000A;
  xmtFinanz = $0000000B;
  xmtWaehr = $0000000C;
  xmtKurs = $0000000D;
  xmtBGS = $0000000E;
  xmtUmlage = $0000000F;
  xmtKLRGrp = $00000010;
  xmtTabBez = $00000011;
  xmtGrpBez = $00000012;
  xmtDBRForm = $00000013;
  xmtBWA = $00000014;
  xmtUser = $00000015;
  xmtWxl = $00000016;
  xmtBWxl = $00000017;
  xmtSWxl = $00000018;
  xmtKrVers = $00000019;
  xmtVerwKd = $0000001A;
  xmtInst = $0000001B;
  xmtArch = $0000001C;
  xmtVerwCfg = $0000001D;
  xmtKLRBg = $0000001E;
  xmtStSatzEG = $0000001F;
  xmtAuto = $00000020;
  xmtKATb = $00000021;
  xmtKSTb = $00000022;
  xmtKTTb = $00000023;
  xmtBJrn = $00000024;
  xmtOPJrn = $00000025;
  xmtKLRJrn = $00000026;
  xmtBank = $00000027;
  xmtOrte = $00000028;
  xmtLand = $00000029;
  xmtAuslBank = $0000002A;
  xmtZins = $0000002B;
  xmtInv = $0000002C;
  xmtFest = $0000002D;
  xmtStSatz = $0000002E;
  xmtSWIFT = $0000002F;
  xmtKTBer = $00000030;
  xmtMand = $00000031;
  xmtBranche = $00000032;
  xmtPKVk = $00000033;
  xmtGebiet = $00000034;
  xmtZVDCDebi = $00000035;
  xmtREB = $00000036;
  xmtKasse = $00000037;
  xmtScheck = $00000038;
  xmtZVSK = $00000039;
  xmtReport = $0000003A;
  xmtZVMA = $0000003B;
  xmtZVDCKred = $0000003C;
  xmtZVOPVorDebi = $0000003D;
  xmtZVOPVorKred = $0000003E;
  xmtZVAZV = $0000003F;
  xmtKasseStamm = $00000040;
  xmtMarkt = $00000041;
  xmtAutoAltHead = $00000042;
  xmtAutoAltList = $00000043;
  xmtAAListKSt = $00000044;
  xmtAAListKTr = $00000045;
  xmtAutoList = $00000046;
  xmtAutoListKSt = $00000047;
  xmtAutoListKTr = $00000048;
  xmtAutoKtoVkn = $00000049;
  xmtZFKTabInfo = $0000004A;
  xmtZFKKtTab = $0000004B;
  xmtInvAfAStamm = $0000004C;
  xmtInvKtBereich = $0000004D;
  xmtJobList = $0000004E;
  xmtUSGPos = $0000004F;
  xmtLayOpListe = $00000050;
  xmtLayMahn = $00000051;
  xmtLayAvisDebi = $00000052;
  xmtLayAvisKred = $00000053;
  xmtLayScheck = $00000054;
  xmtLayInvRep = $00000055;
  xmtLayREB = $00000056;
  xmtLaySkbrPro = $00000057;
  xmtLaySkbrNet = $00000058;
  xmtLayWiedRech = $00000059;
  xmtLayDebiZins = $0000005A;
  xmtLayZFK = $0000005B;
  xmtIntra = $0000005C;
  xmtInvJrn = $0000005D;
  xmtPNA = $0000005E;
  xmtFILES = $0000005F;
  xmtOpBeleg = $00000060;
  xmtSalden = $00000061;
  xmtKtoBudget = $00000062;
  xmtUStSchluessel = $00000063;
  xmtInvKLRAnteil = $00000064;
  xmtBuchStapel = $00000065;
  xmtKLRBudget = $00000066;
  xmtStation = $00000067;
  xmtUmlageZl = $00000068;
  xmtKATbZl = $00000069;
  xmtKSTbZl = $0000006A;
  xmtKTTbZl = $0000006B;
  xmtDBRZlDef = $0000006C;
  xmtDBRFormZl = $0000006D;
  xmtVersTyp = $0000006E;
  xmtInvVers = $0000006F;
  xmtDatei = $00000070;
  xmtSkoBrief = $00000071;
  xmtKtKombi = $00000072;
  xmtWiedBuch = $00000073;
  xmtZVZRegDebi = $00000074;
  xmtZVZRegKred = $00000075;
  xmtAZVRueck = $00000076;
  xmtKLRBgBeweg = $00000077;
  xmtEigenleistJrn = $00000078;
  xmtZVMeldesatz = $00000079;
  xmtZuschlag = $0000007A;
  xmtMahnarchive = $0000007B;
  xmtKtoDOC = $0000007C;
  xmtKtoDocVkn = $0000007D;
  xmtWechsel = $0000007E;
  xmtRepZmeldung = $0000007F;
  xmtRepSalden1 = $00000080;
  xmtRepKLRJrn = $00000081;
  xmtBatchScript = $00000082;
  xmtRepPosten = $00000083;

// Konstanten für enum EKontensperren
type
  EKontensperren = TOleEnum;
const
  spkNone = $00000000;
  spkManuellesBuchen = $00000001;
  spkAutomBuchen = $00000002;
  spkBuchen = $00000003;
  spkAdminOnly = $00000004;

// Konstanten für enum EBgAuftTypen
type
  EBgAuftTypen = TOleEnum;
const
  BgEinzelSatz = $00000000;
  BgAufteilung = $00000001;
  BgTeilsatz = $00000002;

// Konstanten für enum EInventarebenen
type
  EInventarebenen = TOleEnum;
const
  ieSteuerrechtlich = $00000001;
  ieHandelsrechtlich = $00000002;
  ieKalkulatorisch = $00000003;

// Konstanten für enum EWechselarten
type
  EWechselarten = TOleEnum;
const
  wxlaBesitzwechsel = $00000000;
  wxlaSchuldwechsel = $00000001;
  wxlaRefinanzbesitzwechsel = $00000002;
  wxlaRefinanzschuldwechsel = $00000003;

// Konstanten für enum EWechselverwendungen
type
  EWechselverwendungen = TOleEnum;
const
  wxlvDiskontierung = $00000000;
  wxlvInkasso = $00000001;
  wxlvAufbewahrung = $00000002;
  wxlvForfaitierung = $00000003;
  wxlvZMW = $00000004;

// Konstanten für enum EKontoRechte
type
  EKontoRechte = TOleEnum;
const
  acsRead = $00000001;
  acsSaldo = $00000002;
  acsUpdate = $00000004;
  acsInsert = $00000008;
  acsDelete = $00000010;
  acsBuchen = $00000020;

type

// *********************************************************************//
// Forward-Deklaration von in der Typbibliothek definierten Typen                     
// *********************************************************************//
  IFNFactory = interface;
  IFNFactoryDisp = dispinterface;
  IUser = interface;
  IUserDisp = dispinterface;
  IMandant = interface;
  IMandantDisp = dispinterface;
  IAdresse = interface;
  IAdresseDisp = dispinterface;
  ILand = interface;
  ILandDisp = dispinterface;
  IDebitor = interface;
  IDebitorDisp = dispinterface;
  IKonto = interface;
  IKontoDisp = dispinterface;
  ISaldo = interface;
  ISaldoDisp = dispinterface;
  IPosten = interface;
  IPostenDisp = dispinterface;
  INavigate = interface;
  INavigateDisp = dispinterface;
  IKontierung = interface;
  IKontierungDisp = dispinterface;
  IJournal = interface;
  IJournalDisp = dispinterface;
  IKLRJournal = interface;
  IKLRJournalDisp = dispinterface;
  IFestkonto = interface;
  IFestkontoDisp = dispinterface;
  IKreditor = interface;
  IKreditorDisp = dispinterface;
  ISachkonto = interface;
  ISachkontoDisp = dispinterface;
  IBuchtext = interface;
  IBuchtextDisp = dispinterface;
  ISteuer = interface;
  ISteuerDisp = dispinterface;
  IFinanzamt = interface;
  IFinanzamtDisp = dispinterface;
  IBank = interface;
  IBankDisp = dispinterface;
  IKontenbereich = interface;
  IKontenbereichDisp = dispinterface;
  IBankverbindung = interface;
  IBankverbindungDisp = dispinterface;
  IGruppe = interface;
  IGruppeDisp = dispinterface;
  IKostenart = interface;
  IKostenartDisp = dispinterface;
  IKostenstelle = interface;
  IKostenstelleDisp = dispinterface;
  IBezugsgroesse = interface;
  IBezugsgroesseDisp = dispinterface;
  IPlanmenge = interface;
  IPlanmengeDisp = dispinterface;
  IUSt = interface;
  IUStDisp = dispinterface;
  IKurs = interface;
  IKursDisp = dispinterface;
  IWaehrung = interface;
  IWaehrungDisp = dispinterface;
  IMahn = interface;
  IMahnDisp = dispinterface;
  IZahlkondition = interface;
  IZahlkonditionDisp = dispinterface;
  IFNReport = interface;
  IFNReportDisp = dispinterface;
  IChooseMandant = interface;
  IChooseMandantDisp = dispinterface;
  IPasswort = interface;
  IPasswortDisp = dispinterface;
  IBuchen = interface;
  IBuchenDisp = dispinterface;
  IKostenstelleart = interface;
  IKostenstelleartDisp = dispinterface;
  IFNImport = interface;
  IFNImportDisp = dispinterface;
  IREB = interface;
  IREBDisp = dispinterface;
  IOrt = interface;
  IOrtDisp = dispinterface;
  ILizenz = interface;
  ILizenzDisp = dispinterface;
  ICmdBuchen = interface;
  ICmdBuchenDisp = dispinterface;
  ICmdPosten = interface;
  ICmdPostenDisp = dispinterface;
  ICmdKLR = interface;
  ICmdKLRDisp = dispinterface;
  IKreditversicherung = interface;
  IKreditversicherungDisp = dispinterface;
  IArchiv = interface;
  IArchivDisp = dispinterface;
  IArchivierung = interface;
  IArchivierungDisp = dispinterface;
  IBgMw = interface;
  IBgMwDisp = dispinterface;
  IBatchScript = interface;
  IBatchScriptDisp = dispinterface;
  IXML = interface;
  IXMLDisp = dispinterface;
  IDCUebFiles = interface;
  IDCUebFilesDisp = dispinterface;
  IBgBeweg = interface;
  IBgBewegDisp = dispinterface;
  IInventar = interface;
  IInventarDisp = dispinterface;
  IInventarebene = interface;
  IInventarebeneDisp = dispinterface;
  IInventarstatus = interface;
  IInventarstatusDisp = dispinterface;
  IInventarKLRAnteil = interface;
  IInventarKLRAnteilDisp = dispinterface;
  IServer = interface;
  IServerDisp = dispinterface;
  IBranche = interface;
  IBrancheDisp = dispinterface;
  IWechsel = interface;
  IWechselDisp = dispinterface;
  ITageskurs = interface;
  ITageskursDisp = dispinterface;
  IEGSteuer = interface;
  IEGSteuerDisp = dispinterface;
  IScheck = interface;
  IScheckDisp = dispinterface;
  IInventarJournal = interface;
  IInventarJournalDisp = dispinterface;
  IKreditkarte = interface;
  IKreditkarteDisp = dispinterface;
  IVerteilung = interface;
  IVerteilungDisp = dispinterface;
  IElster = interface;
  IElsterDisp = dispinterface;
  IKLRAutomatik = interface;
  IKLRAutomatikDisp = dispinterface;

// *********************************************************************//
// Deklaration von in der Typbibliothek definierten CoClasses
// (HINWEIS: Hier wird jede CoClass ihrem Standard-Interface zugewiesen)              
// *********************************************************************//
  FNFactory = IFNFactory;
  User = IUser;
  Mandant = IMandant;
  Adresse = IAdresse;
  Land = ILand;
  Debitor = IDebitor;
  Konto = IKonto;
  Saldo = ISaldo;
  Posten = IPosten;
  Navigate = INavigate;
  Kontierung = IKontierung;
  Journal = IJournal;
  KLRJournal = IKLRJournal;
  Festkonto = IFestkonto;
  Kreditor = IKreditor;
  Sachkonto = ISachkonto;
  Buchtext = IBuchtext;
  Steuer = ISteuer;
  Finanzamt = IFinanzamt;
  Bank = IBank;
  Kontenbereich = IKontenbereich;
  Bankverbindung = IBankverbindung;
  Gruppe = IGruppe;
  Kostenart = IKostenart;
  Kostenstelle = IKostenstelle;
  Bezugsgroesse = IBezugsgroesse;
  Planmenge = IPlanmenge;
  USt = IUSt;
  Kurs = IKurs;
  Waehrung = IWaehrung;
  Mahn = IMahn;
  Zahlkondition = IZahlkondition;
  FNReport = IFNReport;
  ChooseMandant = IChooseMandant;
  Passwort = IPasswort;
  Buchen = IBuchen;
  Kostenstelleart = IKostenstelleart;
  FNImport = IFNImport;
  REB = IREB;
  Ort = IOrt;
  Lizenz = ILizenz;
  CmdBuchen = ICmdBuchen;
  CmdPosten = ICmdPosten;
  CmdKLR = ICmdKLR;
  Kreditversicherung = IKreditversicherung;
  Archiv = IArchiv;
  Archivierung = IArchivierung;
  BgMw = IBgMw;
  BatchScript = IBatchScript;
  XML = IXML;
  DCUebFiles = IDCUebFiles;
  BgMwBeweg = IBgBeweg;
  Inventar = IInventar;
  Inventarebene = IInventarebene;
  Inventarstatus = IInventarstatus;
  InventarKLRAnteil = IInventarKLRAnteil;
  Server = IServer;
  Branche = IBranche;
  Wechsel = IWechsel;
  Tageskurs = ITageskurs;
  EGSteuer = IEGSteuer;
  Scheck = IScheck;
  InventarJournal = IInventarJournal;
  Kreditkarte = IKreditkarte;
  Verteilung = IVerteilung;
  Elster = IElster;
  KLRAutomatik = IKLRAutomatik;


// *********************************************************************//
// Deklaration von Strukturen, Unions und Aliasen.                          
// *********************************************************************//
  Kostentraeger = IKostenstelle; 
  Kostentraegerart = IKostenstelleart; 
  Kostenartstelle = IKostenstelleart; 
  Kostenarttraeger = IKostenstelleart; 

  RAdresse = record
    Name1: WideString;
    Name2: WideString;
    Name3: WideString;
    Strasse1: WideString;
    Strasse2: WideString;
    PLZ: WideString;
    Ort: WideString;
    Land: WideString;
    Telefon: WideString;
    Fax: WideString;
    Mail: WideString;
    Anrede: WideString;
    PLZ2: WideString;
    Postfach: WideString;
    UStIdNr: WideString;
  end;


  RZahlkondition = record
    Tage1: Integer;
    Skonto1: Single;
    Tage2: Integer;
    Skonto2: Single;
    Nettozahlungsziel: Integer;
  end;

  RKontierung = record
    Betrag: Currency;
    Tagesdatum: TDateTime;
    Belegdatum: TDateTime;
    Buchdatum: TDateTime;
    Belegnummer1: WideString;
    Belegnummer2: WideString;
    Buchtext: WideString;
    Kontonummer: Integer;
    GegenKonto: Integer;
    Benutzer: WideString;
    IsValid: WordBool;
  end;

  RUSt = record
    Art: Integer;
    ArtMV: WideString;
    Schlussel: Integer;
  end;

  RKurs = record
    Waehrung: Integer;
    Basis: Integer;
    Tageskurs: Double;
    Waehrungsbetrag: Currency;
  end;


// *********************************************************************//
// Interface: IFNFactory
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {62E713E8-F920-457A-B3AE-936F377A51CA}
// *********************************************************************//
  IFNFactory = interface(IDispatch)
    ['{62E713E8-F920-457A-B3AE-936F377A51CA}']
    function Mandant: IMandant; safecall;
    function Get_Buchdatum: TDateTime; safecall;
    procedure Set_Buchdatum(Value: TDateTime); safecall;
    function GetSalden(VonKonto: Integer; BisKonto: Integer; OhneSaldo: WordBool): OleVariant; safecall;
    function GetOp(VonKonto: Integer; BisKonto: Integer; AllePosten: WordBool): OleVariant; safecall;
    function GetJrnRows(VonKonto: Integer; BisKonto: Integer; VonJrnRow: Integer; BisJrnRow: Integer): OleVariant; safecall;
    function GetAdresse(VonKonto: Integer; BisKonto: Integer): OleVariant; safecall;
    function Buchen: IBuchen; safecall;
    function GetKreditversicherung(VonKonto: Integer; BisKonto: Integer; MitSaldo: WordBool): OleVariant; safecall;
    function GetSachkonto(VonKonto: Integer; BisKonto: Integer): OleVariant; safecall;
    function GetKostenstelle(VonKSt: Integer; BisKSt: Integer): OleVariant; safecall;
    function GetKostentraeger(VonKTr: Integer; BisKTr: Integer): OleVariant; safecall;
    function GetKostenart(VonKArt: Integer; BisKArt: Integer): OleVariant; safecall;
    function User: IUser; safecall;
    function Finanzamt: IFinanzamt; safecall;
    function Bank: IBank; safecall;
    function Get_Separator: WideString; safecall;
    procedure Set_Separator(const Value: WideString); safecall;
    function Get_Stapelstatus: WordBool; safecall;
    procedure Set_Stapelstatus(Value: WordBool); safecall;
    function ChooseMandant: IChooseMandant; safecall;
    function Passwort: IPasswort; safecall;
    function CheckUStIdNr(const IdNr: WideString): WordBool; safecall;
    function Get_ClientComputerName: WideString; safecall;
    procedure Set_ClientComputerName(const Value: WideString); safecall;
    function Get_Wirtschaftsjahr(Datum: TDateTime): Integer; safecall;
    function Ort: IOrt; safecall;
    function Lizenz: ILizenz; safecall;
    function Get_Releasestand: Integer; safecall;
    function Get_ServerLog: WideString; safecall;
    function BatchScript: IBatchScript; safecall;
    function Get_WirtschaftsjahrAnfang(Datum: TDateTime): TDateTime; safecall;
    function Get_WirtschaftsjahrEnde(Datum: TDateTime): TDateTime; safecall;
    function Server: IServer; safecall;
    function Branche: IBranche; safecall;
    function Land: ILand; safecall;
    function Waehrung: IWaehrung; safecall;
    function EGSteuer: IEGSteuer; safecall;
    function Elster: IElster; safecall;
    procedure SetCurrentOrMaxDate; safecall;
    function GetZahlartBez(Nr: Integer): WideString; safecall;
    function Get_DatenIdentitaet: WideString; safecall;
    property Buchdatum: TDateTime read Get_Buchdatum write Set_Buchdatum;
    property Separator: WideString read Get_Separator write Set_Separator;
    property Stapelstatus: WordBool read Get_Stapelstatus write Set_Stapelstatus;
    property ClientComputerName: WideString read Get_ClientComputerName write Set_ClientComputerName;
    property Wirtschaftsjahr[Datum: TDateTime]: Integer read Get_Wirtschaftsjahr;
    property Releasestand: Integer read Get_Releasestand;
    property ServerLog: WideString read Get_ServerLog;
    property WirtschaftsjahrAnfang[Datum: TDateTime]: TDateTime read Get_WirtschaftsjahrAnfang;
    property WirtschaftsjahrEnde[Datum: TDateTime]: TDateTime read Get_WirtschaftsjahrEnde;
    property DatenIdentitaet: WideString read Get_DatenIdentitaet;
  end;

// *********************************************************************//
// DispIntf:  IFNFactoryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {62E713E8-F920-457A-B3AE-936F377A51CA}
// *********************************************************************//
  IFNFactoryDisp = dispinterface
    ['{62E713E8-F920-457A-B3AE-936F377A51CA}']
    function Mandant: IMandant; dispid 17;
    property Buchdatum: TDateTime dispid 16;
    function GetSalden(VonKonto: Integer; BisKonto: Integer; OhneSaldo: WordBool): OleVariant; dispid 1;
    function GetOp(VonKonto: Integer; BisKonto: Integer; AllePosten: WordBool): OleVariant; dispid 4;
    function GetJrnRows(VonKonto: Integer; BisKonto: Integer; VonJrnRow: Integer; BisJrnRow: Integer): OleVariant; dispid 9;
    function GetAdresse(VonKonto: Integer; BisKonto: Integer): OleVariant; dispid 18;
    function Buchen: IBuchen; dispid 19;
    function GetKreditversicherung(VonKonto: Integer; BisKonto: Integer; MitSaldo: WordBool): OleVariant; dispid 20;
    function GetSachkonto(VonKonto: Integer; BisKonto: Integer): OleVariant; dispid 24;
    function GetKostenstelle(VonKSt: Integer; BisKSt: Integer): OleVariant; dispid 25;
    function GetKostentraeger(VonKTr: Integer; BisKTr: Integer): OleVariant; dispid 26;
    function GetKostenart(VonKArt: Integer; BisKArt: Integer): OleVariant; dispid 27;
    function User: IUser; dispid 10;
    function Finanzamt: IFinanzamt; dispid 2;
    function Bank: IBank; dispid 3;
    property Separator: WideString dispid 5;
    property Stapelstatus: WordBool dispid 6;
    function ChooseMandant: IChooseMandant; dispid 7;
    function Passwort: IPasswort; dispid 8;
    function CheckUStIdNr(const IdNr: WideString): WordBool; dispid 12;
    property ClientComputerName: WideString dispid 11;
    property Wirtschaftsjahr[Datum: TDateTime]: Integer readonly dispid 14;
    function Ort: IOrt; dispid 13;
    function Lizenz: ILizenz; dispid 15;
    property Releasestand: Integer readonly dispid 21;
    property ServerLog: WideString readonly dispid 22;
    function BatchScript: IBatchScript; dispid 23;
    property WirtschaftsjahrAnfang[Datum: TDateTime]: TDateTime readonly dispid 28;
    property WirtschaftsjahrEnde[Datum: TDateTime]: TDateTime readonly dispid 29;
    function Server: IServer; dispid 30;
    function Branche: IBranche; dispid 201;
    function Land: ILand; dispid 202;
    function Waehrung: IWaehrung; dispid 203;
    function EGSteuer: IEGSteuer; dispid 204;
    function Elster: IElster; dispid 205;
    procedure SetCurrentOrMaxDate; dispid 206;
    function GetZahlartBez(Nr: Integer): WideString; dispid 207;
    property DatenIdentitaet: WideString readonly dispid 208;
  end;

// *********************************************************************//
// Interface: IUser
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E29B6B1D-30C4-4FE5-BC2C-12B9AB095984}
// *********************************************************************//
  IUser = interface(IDispatch)
    ['{E29B6B1D-30C4-4FE5-BC2C-12B9AB095984}']
    function Anmeldung(const Server: WideString; const Benutzer: WideString; 
                       const Passwort: WideString): WideString; safecall;
    function Get_Nummer: Integer; safecall;
    procedure Set_Nummer(Value: Integer); safecall;
    function Get_Benutzer: WideString; safecall;
    procedure Set_Benutzer(const Value: WideString); safecall;
    function Get_Abteilung: WideString; safecall;
    procedure Set_Abteilung(const Value: WideString); safecall;
    function Adresse: IAdresse; safecall;
    function Get_Info(Nr: Integer): WideString; safecall;
    procedure Set_Info(Nr: Integer; const Value: WideString); safecall;
    function Get_Info1: WideString; safecall;
    procedure Set_Info1(const Value: WideString); safecall;
    function Get_Info2: WideString; safecall;
    procedure Set_Info2(const Value: WideString); safecall;
    function DefaultBenutzer: WideString; safecall;
    function DefaultServer: WideString; safecall;
    function Get_DefaultPort: Integer; safecall;
    procedure Set_DefaultPort(Value: Integer); safecall;
    function Get_PruefzeitraumVon: TDateTime; safecall;
    function Get_PruefzeitraumBis: TDateTime; safecall;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Benutzer: WideString read Get_Benutzer write Set_Benutzer;
    property Abteilung: WideString read Get_Abteilung write Set_Abteilung;
    property Info[Nr: Integer]: WideString read Get_Info write Set_Info;
    property Info1: WideString read Get_Info1 write Set_Info1;
    property Info2: WideString read Get_Info2 write Set_Info2;
    property DefaultPort: Integer read Get_DefaultPort write Set_DefaultPort;
    property PruefzeitraumVon: TDateTime read Get_PruefzeitraumVon;
    property PruefzeitraumBis: TDateTime read Get_PruefzeitraumBis;
  end;

// *********************************************************************//
// DispIntf:  IUserDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E29B6B1D-30C4-4FE5-BC2C-12B9AB095984}
// *********************************************************************//
  IUserDisp = dispinterface
    ['{E29B6B1D-30C4-4FE5-BC2C-12B9AB095984}']
    function Anmeldung(const Server: WideString; const Benutzer: WideString; 
                       const Passwort: WideString): WideString; dispid 1;
    property Nummer: Integer dispid 2;
    property Benutzer: WideString dispid 3;
    property Abteilung: WideString dispid 6;
    function Adresse: IAdresse; dispid 8;
    property Info[Nr: Integer]: WideString dispid 14;
    property Info1: WideString dispid 15;
    property Info2: WideString dispid 16;
    function DefaultBenutzer: WideString; dispid 4;
    function DefaultServer: WideString; dispid 5;
    property DefaultPort: Integer dispid 7;
    property PruefzeitraumVon: TDateTime readonly dispid 201;
    property PruefzeitraumBis: TDateTime readonly dispid 202;
  end;

// *********************************************************************//
// Interface: IMandant
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F48EAEC3-8F81-4356-94F5-0D42EF4FFB59}
// *********************************************************************//
  IMandant = interface(IDispatch)
    ['{F48EAEC3-8F81-4356-94F5-0D42EF4FFB59}']
    function Get_Nummer: Integer; safecall;
    procedure Set_Nummer(Value: Integer); safecall;
    function Get_Bezeichnung: WideString; safecall;
    procedure Set_Bezeichnung(const Value: WideString); safecall;
    function Adresse: IAdresse; safecall;
    function Get_aktlWiJahr: Integer; safecall;
    procedure Set_aktlWiJahr(Value: Integer); safecall;
    function Get_letzteMonatWiJahr: Integer; safecall;
    procedure Set_letzteMonatWiJahr(Value: Integer); safecall;
    function Get_RumpfWiJahrAnfang: TDateTime; safecall;
    procedure Set_RumpfWiJahrAnfang(Value: TDateTime); safecall;
    function Get_RumpfWiJahrEnde: TDateTime; safecall;
    procedure Set_RumpfWiJahrEnde(Value: TDateTime); safecall;
    function Get_AbwMdNrStB: Integer; safecall;
    procedure Set_AbwMdNrStB(Value: Integer); safecall;
    function Get_Steuernummer: WideString; safecall;
    procedure Set_Steuernummer(const Value: WideString); safecall;
    function Debitor: IDebitor; safecall;
    function Kreditor: IKreditor; safecall;
    function Sachkonto: ISachkonto; safecall;
    function Journal(WiJ: Integer): IJournal; safecall;
    function KLRJournal(WiJ: Integer): IKLRJournal; safecall;
    function Festkonto: IFestkonto; safecall;
    function Buchtext: IBuchtext; safecall;
    function Steuer: ISteuer; safecall;
    function Finanzamt: IFinanzamt; safecall;
    function Kontenbereich: IKontenbereich; safecall;
    function Kostenart: IKostenart; safecall;
    function Kostenstelle: IKostenstelle; safecall;
    function Kostentraeger: Kostentraeger; safecall;
    function Bezugsgroesse: IBezugsgroesse; safecall;
    function FNReport: IFNReport; safecall;
    function Posten(KontoTyp: EKontotypen; AllePosten: WordBool): IPosten; safecall;
    function Kostenstelleart: IKostenstelleart; safecall;
    function Kostentraegerart: Kostentraegerart; safecall;
    function Kostenartstelle: Kostenartstelle; safecall;
    function Kostenarttraeger: Kostenarttraeger; safecall;
    function REB(IsGebucht: WordBool): IREB; safecall;
    function Get_ISOHausWaehrBez: WideString; safecall;
    function Archivierung: IArchivierung; safecall;
    function BgMw(IsPlan: WordBool; IsKTr: WordBool): IBgMw; safecall;
    function XML: IXML; safecall;
    function DCUebFiles: IDCUebFiles; safecall;
    function BgBeweg(IsPlan: WordBool): IBgBeweg; safecall;
    function Inventar: IInventar; safecall;
    function Waehrung: IWaehrung; safecall;
    function USGAAPPos: IGruppe; safecall;
    function HGBPos: IGruppe; safecall;
    function Wechsel: IWechsel; safecall;
    function Tageskurs(WaNr: Integer): ITageskurs; safecall;
    function GetKontoRechte(KtNr: Integer; KtTyp: EKontotypen): EKontoRechte; safecall;
    function Get_UStVAZeitraum: Integer; safecall;
    function Scheck: IScheck; safecall;
    function InventarJournal(EbeneNr: EInventarebenen): IInventarJournal; safecall;
    function Verteilung(VonMonat: Integer; BisMonat: Integer; vertKLRTyp: Integer; 
                        empfKLRTyp: Integer; VonKArt: Integer; BisKArt: Integer; BGNummer: Integer; 
                        FixVar: Integer): IVerteilung; safecall;
    function KontoGruppe: IGruppe; safecall;
    function InventarGruppe: IGruppe; safecall;
    function KLRGruppe: IGruppe; safecall;
    function Get_INIDatei: WideString; safecall;
    procedure Set_INIDatei(const Value: WideString); safecall;
    function KLRAutomatik: IKLRAutomatik; safecall;
    function KLRJrnKStKTr(WiJ: Integer): IKLRJournal; safecall;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property aktlWiJahr: Integer read Get_aktlWiJahr write Set_aktlWiJahr;
    property letzteMonatWiJahr: Integer read Get_letzteMonatWiJahr write Set_letzteMonatWiJahr;
    property RumpfWiJahrAnfang: TDateTime read Get_RumpfWiJahrAnfang write Set_RumpfWiJahrAnfang;
    property RumpfWiJahrEnde: TDateTime read Get_RumpfWiJahrEnde write Set_RumpfWiJahrEnde;
    property AbwMdNrStB: Integer read Get_AbwMdNrStB write Set_AbwMdNrStB;
    property Steuernummer: WideString read Get_Steuernummer write Set_Steuernummer;
    property ISOHausWaehrBez: WideString read Get_ISOHausWaehrBez;
    property UStVAZeitraum: Integer read Get_UStVAZeitraum;
    property INIDatei: WideString read Get_INIDatei write Set_INIDatei;
  end;

// *********************************************************************//
// DispIntf:  IMandantDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F48EAEC3-8F81-4356-94F5-0D42EF4FFB59}
// *********************************************************************//
  IMandantDisp = dispinterface
    ['{F48EAEC3-8F81-4356-94F5-0D42EF4FFB59}']
    property Nummer: Integer dispid 1;
    property Bezeichnung: WideString dispid 2;
    function Adresse: IAdresse; dispid 3;
    property aktlWiJahr: Integer dispid 5;
    property letzteMonatWiJahr: Integer dispid 6;
    property RumpfWiJahrAnfang: TDateTime dispid 7;
    property RumpfWiJahrEnde: TDateTime dispid 8;
    property AbwMdNrStB: Integer dispid 4;
    property Steuernummer: WideString dispid 9;
    function Debitor: IDebitor; dispid 10;
    function Kreditor: IKreditor; dispid 14;
    function Sachkonto: ISachkonto; dispid 15;
    function Journal(WiJ: Integer): IJournal; dispid 11;
    function KLRJournal(WiJ: Integer): IKLRJournal; dispid 12;
    function Festkonto: IFestkonto; dispid 13;
    function Buchtext: IBuchtext; dispid 16;
    function Steuer: ISteuer; dispid 17;
    function Finanzamt: IFinanzamt; dispid 18;
    function Kontenbereich: IKontenbereich; dispid 19;
    function Kostenart: IKostenart; dispid 20;
    function Kostenstelle: IKostenstelle; dispid 21;
    function Kostentraeger: Kostentraeger; dispid 22;
    function Bezugsgroesse: IBezugsgroesse; dispid 23;
    function FNReport: IFNReport; dispid 24;
    function Posten(KontoTyp: EKontotypen; AllePosten: WordBool): IPosten; dispid 25;
    function Kostenstelleart: IKostenstelleart; dispid 26;
    function Kostentraegerart: Kostentraegerart; dispid 27;
    function Kostenartstelle: Kostenartstelle; dispid 28;
    function Kostenarttraeger: Kostenarttraeger; dispid 29;
    function REB(IsGebucht: WordBool): IREB; dispid 30;
    property ISOHausWaehrBez: WideString readonly dispid 31;
    function Archivierung: IArchivierung; dispid 32;
    function BgMw(IsPlan: WordBool; IsKTr: WordBool): IBgMw; dispid 33;
    function XML: IXML; dispid 34;
    function DCUebFiles: IDCUebFiles; dispid 35;
    function BgBeweg(IsPlan: WordBool): IBgBeweg; dispid 37;
    function Inventar: IInventar; dispid 36;
    function Waehrung: IWaehrung; dispid 38;
    function USGAAPPos: IGruppe; dispid 202;
    function HGBPos: IGruppe; dispid 201;
    function Wechsel: IWechsel; dispid 203;
    function Tageskurs(WaNr: Integer): ITageskurs; dispid 204;
    function GetKontoRechte(KtNr: Integer; KtTyp: EKontotypen): EKontoRechte; dispid 205;
    property UStVAZeitraum: Integer readonly dispid 206;
    function Scheck: IScheck; dispid 207;
    function InventarJournal(EbeneNr: EInventarebenen): IInventarJournal; dispid 208;
    function Verteilung(VonMonat: Integer; BisMonat: Integer; vertKLRTyp: Integer; 
                        empfKLRTyp: Integer; VonKArt: Integer; BisKArt: Integer; BGNummer: Integer; 
                        FixVar: Integer): IVerteilung; dispid 209;
    function KontoGruppe: IGruppe; dispid 210;
    function InventarGruppe: IGruppe; dispid 211;
    function KLRGruppe: IGruppe; dispid 212;
    property INIDatei: WideString dispid 213;
    function KLRAutomatik: IKLRAutomatik; dispid 214;
    function KLRJrnKStKTr(WiJ: Integer): IKLRJournal; dispid 215;
  end;

// *********************************************************************//
// Interface: IAdresse
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D40FC78D-E961-4345-83A0-94576D8C8FA7}
// *********************************************************************//
  IAdresse = interface(IDispatch)
    ['{D40FC78D-E961-4345-83A0-94576D8C8FA7}']
    function Get_Name(Nr: Integer): WideString; safecall;
    procedure Set_Name(Nr: Integer; const Value: WideString); safecall;
    function Get_Name1: WideString; safecall;
    procedure Set_Name1(const Value: WideString); safecall;
    function Get_Name2: WideString; safecall;
    procedure Set_Name2(const Value: WideString); safecall;
    function Get_Name3: WideString; safecall;
    procedure Set_Name3(const Value: WideString); safecall;
    function Get_Strasse(Nr: Integer): WideString; safecall;
    procedure Set_Strasse(Nr: Integer; const Value: WideString); safecall;
    function Get_PLZ: WideString; safecall;
    procedure Set_PLZ(const Value: WideString); safecall;
    function Get_Ort: WideString; safecall;
    procedure Set_Ort(const Value: WideString); safecall;
    function Land: ILand; safecall;
    function Get_Telefon: WideString; safecall;
    procedure Set_Telefon(const Value: WideString); safecall;
    function Get_Fax: WideString; safecall;
    procedure Set_Fax(const Value: WideString); safecall;
    function Get_Mail: WideString; safecall;
    procedure Set_Mail(const Value: WideString); safecall;
    function Get_Anrede: WideString; safecall;
    function AsRecord: RAdresse; safecall;
    function Get_PLZ2: WideString; safecall;
    procedure Set_PLZ2(const Value: WideString); safecall;
    function Get_Postfach: WideString; safecall;
    procedure Set_Postfach(const Value: WideString); safecall;
    function Get_Strasse1: WideString; safecall;
    procedure Set_Strasse1(const Value: WideString); safecall;
    function Get_Strasse2: WideString; safecall;
    procedure Set_Strasse2(const Value: WideString); safecall;
    function Get_UStIdNr: WideString; safecall;
    function Get_Lkz: WideString; safecall;
    function Get_Mobiltelefon: WideString; safecall;
    function Get_Steuernummer: WideString; safecall;
    procedure Set_Steuernummer(const Value: WideString); safecall;
    property Name[Nr: Integer]: WideString read Get_Name write Set_Name;
    property Name1: WideString read Get_Name1 write Set_Name1;
    property Name2: WideString read Get_Name2 write Set_Name2;
    property Name3: WideString read Get_Name3 write Set_Name3;
    property Strasse[Nr: Integer]: WideString read Get_Strasse write Set_Strasse;
    property PLZ: WideString read Get_PLZ write Set_PLZ;
    property Ort: WideString read Get_Ort write Set_Ort;
    property Telefon: WideString read Get_Telefon write Set_Telefon;
    property Fax: WideString read Get_Fax write Set_Fax;
    property Mail: WideString read Get_Mail write Set_Mail;
    property Anrede: WideString read Get_Anrede;
    property PLZ2: WideString read Get_PLZ2 write Set_PLZ2;
    property Postfach: WideString read Get_Postfach write Set_Postfach;
    property Strasse1: WideString read Get_Strasse1 write Set_Strasse1;
    property Strasse2: WideString read Get_Strasse2 write Set_Strasse2;
    property UStIdNr: WideString read Get_UStIdNr;
    property Lkz: WideString read Get_Lkz;
    property Mobiltelefon: WideString read Get_Mobiltelefon;
    property Steuernummer: WideString read Get_Steuernummer write Set_Steuernummer;
  end;

// *********************************************************************//
// DispIntf:  IAdresseDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D40FC78D-E961-4345-83A0-94576D8C8FA7}
// *********************************************************************//
  IAdresseDisp = dispinterface
    ['{D40FC78D-E961-4345-83A0-94576D8C8FA7}']
    property Name[Nr: Integer]: WideString dispid 5;
    property Name1: WideString dispid 3;
    property Name2: WideString dispid 6;
    property Name3: WideString dispid 7;
    property Strasse[Nr: Integer]: WideString dispid 8;
    property PLZ: WideString dispid 9;
    property Ort: WideString dispid 10;
    function Land: ILand; dispid 11;
    property Telefon: WideString dispid 12;
    property Fax: WideString dispid 13;
    property Mail: WideString dispid 15;
    property Anrede: WideString readonly dispid 4;
    function AsRecord: {NOT_OLEAUTO(RAdresse)}OleVariant; dispid 1;
    property PLZ2: WideString dispid 2;
    property Postfach: WideString dispid 14;
    property Strasse1: WideString dispid 16;
    property Strasse2: WideString dispid 17;
    property UStIdNr: WideString readonly dispid 18;
    property Lkz: WideString readonly dispid 19;
    property Mobiltelefon: WideString readonly dispid 201;
    property Steuernummer: WideString dispid 202;
  end;

// *********************************************************************//
// Interface: ILand
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F182A2C6-5F5D-43E3-A9E3-4E3B8584EEB9}
// *********************************************************************//
  ILand = interface(IDispatch)
    ['{F182A2C6-5F5D-43E3-A9E3-4E3B8584EEB9}']
    function Navigate: INavigate; safecall;
    function Get_Lkz: WideString; safecall;
    procedure Set_Lkz(const Value: WideString); safecall;
    function Get_Bezeichnung(Nr: Integer): WideString; safecall;
    procedure Set_Bezeichnung(Nr: Integer; const Value: WideString); safecall;
    function Get_Bezeichnung1: WideString; safecall;
    procedure Set_Bezeichnung1(const Value: WideString); safecall;
    function Get_Bezeichnung2: WideString; safecall;
    procedure Set_Bezeichnung2(const Value: WideString); safecall;
    function Get_WaehrName: WideString; safecall;
    procedure Set_WaehrName(const Value: WideString); safecall;
    function IsEG: WordBool; safecall;
    function Get_Hauptstadt: WideString; safecall;
    procedure Set_Hauptstadt(const Value: WideString); safecall;
    function Get_EUMitgliedSeit: TDateTime; safecall;
    property Lkz: WideString read Get_Lkz write Set_Lkz;
    property Bezeichnung[Nr: Integer]: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property Bezeichnung1: WideString read Get_Bezeichnung1 write Set_Bezeichnung1;
    property Bezeichnung2: WideString read Get_Bezeichnung2 write Set_Bezeichnung2;
    property WaehrName: WideString read Get_WaehrName write Set_WaehrName;
    property Hauptstadt: WideString read Get_Hauptstadt write Set_Hauptstadt;
    property EUMitgliedSeit: TDateTime read Get_EUMitgliedSeit;
  end;

// *********************************************************************//
// DispIntf:  ILandDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F182A2C6-5F5D-43E3-A9E3-4E3B8584EEB9}
// *********************************************************************//
  ILandDisp = dispinterface
    ['{F182A2C6-5F5D-43E3-A9E3-4E3B8584EEB9}']
    function Navigate: INavigate; dispid 5;
    property Lkz: WideString dispid 1;
    property Bezeichnung[Nr: Integer]: WideString dispid 6;
    property Bezeichnung1: WideString dispid 7;
    property Bezeichnung2: WideString dispid 8;
    property WaehrName: WideString dispid 2;
    function IsEG: WordBool; dispid 3;
    property Hauptstadt: WideString dispid 9;
    property EUMitgliedSeit: TDateTime readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IDebitor
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E3E62CF7-B5FE-4F37-98DD-6CE5AD4C7505}
// *********************************************************************//
  IDebitor = interface(IDispatch)
    ['{E3E62CF7-B5FE-4F37-98DD-6CE5AD4C7505}']
    function Navigate: INavigate; safecall;
    function Get_Kontonummer: Integer; safecall;
    procedure Set_Kontonummer(Value: Integer); safecall;
    function Konto: IKonto; safecall;
    function Adresse: IAdresse; safecall;
    function Vertreter: IKreditor; safecall;
    function Get_InlEuroDritt: Integer; safecall;
    procedure Set_InlEuroDritt(Value: Integer); safecall;
    function Bankverbindung: IBankverbindung; safecall;
    function Get_Zahlart: EZahlarten; safecall;
    function Get_Zahlkondition: IZahlkondition; safecall;
    function Get_Kundennummer: WideString; safecall;
    function Kreditversicherung: IKreditversicherung; safecall;
    function Rabatt(Index: Integer): Currency; safecall;
    function Get_Vertreternummer: Integer; safecall;
    function Get_Konzern: Integer; safecall;
    function Get_NummerBeimPartner: WideString; safecall;
    function Get_Gebietsnummer: Integer; safecall;
    function Kreditkarte: IKreditkarte; safecall;
    function Get_MahnkulanzBetrag: Currency; safecall;
    function Get_MahnkulanzBis: TDateTime; safecall;
    function Get_MahnstopBis: TDateTime; safecall;
    function Get_Steuernummer: WideString; safecall;
    function Get_HR_Nummer: WideString; safecall;
    function Get_HR_Ort: WideString; safecall;
    function Get_ZdDatum: TDateTime; safecall;
    function Get_ZdZeitraumVon: TDateTime; safecall;
    function Get_ZdZeitraumBis: TDateTime; safecall;
    function Get_Zahldauer: Integer; safecall;
    function Get_ReGesamtAnzahl: Integer; safecall;
    function Get_ReGesamtUmsatz: Currency; safecall;
    function Get_ReGesamtSkonto: Currency; safecall;
    function Get_IsZentralregulierer: WordBool; safecall;
    function Get_ZentRegKontonummer: Integer; safecall;
    function Get_ZentRegReferenzNr: WideString; safecall;
    function Get_Vorwahl: WideString; safecall;
    function Get_Rufnummer: WideString; safecall;
    function Get_Ansprechpartner: WideString; safecall;
    function Get_Geburtstag: TDateTime; safecall;
    function Get_Rechtsform: Integer; safecall;
    function Get_GegenKonto: Integer; safecall;
    function Get_AbwSammelKt: Integer; safecall;
    function Get_AbwSkontoKt: Integer; safecall;
    property Kontonummer: Integer read Get_Kontonummer write Set_Kontonummer;
    property InlEuroDritt: Integer read Get_InlEuroDritt write Set_InlEuroDritt;
    property Zahlart: EZahlarten read Get_Zahlart;
    property Zahlkondition: IZahlkondition read Get_Zahlkondition;
    property Kundennummer: WideString read Get_Kundennummer;
    property Vertreternummer: Integer read Get_Vertreternummer;
    property Konzern: Integer read Get_Konzern;
    property NummerBeimPartner: WideString read Get_NummerBeimPartner;
    property Gebietsnummer: Integer read Get_Gebietsnummer;
    property MahnkulanzBetrag: Currency read Get_MahnkulanzBetrag;
    property MahnkulanzBis: TDateTime read Get_MahnkulanzBis;
    property MahnstopBis: TDateTime read Get_MahnstopBis;
    property Steuernummer: WideString read Get_Steuernummer;
    property HR_Nummer: WideString read Get_HR_Nummer;
    property HR_Ort: WideString read Get_HR_Ort;
    property ZdDatum: TDateTime read Get_ZdDatum;
    property ZdZeitraumVon: TDateTime read Get_ZdZeitraumVon;
    property ZdZeitraumBis: TDateTime read Get_ZdZeitraumBis;
    property Zahldauer: Integer read Get_Zahldauer;
    property ReGesamtAnzahl: Integer read Get_ReGesamtAnzahl;
    property ReGesamtUmsatz: Currency read Get_ReGesamtUmsatz;
    property ReGesamtSkonto: Currency read Get_ReGesamtSkonto;
    property IsZentralregulierer: WordBool read Get_IsZentralregulierer;
    property ZentRegKontonummer: Integer read Get_ZentRegKontonummer;
    property ZentRegReferenzNr: WideString read Get_ZentRegReferenzNr;
    property Vorwahl: WideString read Get_Vorwahl;
    property Rufnummer: WideString read Get_Rufnummer;
    property Ansprechpartner: WideString read Get_Ansprechpartner;
    property Geburtstag: TDateTime read Get_Geburtstag;
    property Rechtsform: Integer read Get_Rechtsform;
    property GegenKonto: Integer read Get_GegenKonto;
    property AbwSammelKt: Integer read Get_AbwSammelKt;
    property AbwSkontoKt: Integer read Get_AbwSkontoKt;
  end;

// *********************************************************************//
// DispIntf:  IDebitorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E3E62CF7-B5FE-4F37-98DD-6CE5AD4C7505}
// *********************************************************************//
  IDebitorDisp = dispinterface
    ['{E3E62CF7-B5FE-4F37-98DD-6CE5AD4C7505}']
    function Navigate: INavigate; dispid 1;
    property Kontonummer: Integer dispid 7;
    function Konto: IKonto; dispid 8;
    function Adresse: IAdresse; dispid 9;
    function Vertreter: IKreditor; dispid 10;
    property InlEuroDritt: Integer dispid 2;
    function Bankverbindung: IBankverbindung; dispid 3;
    property Zahlart: EZahlarten readonly dispid 4;
    property Zahlkondition: IZahlkondition readonly dispid 6;
    property Kundennummer: WideString readonly dispid 5;
    function Kreditversicherung: IKreditversicherung; dispid 11;
    function Rabatt(Index: Integer): Currency; dispid 12;
    property Vertreternummer: Integer readonly dispid 13;
    property Konzern: Integer readonly dispid 14;
    property NummerBeimPartner: WideString readonly dispid 15;
    property Gebietsnummer: Integer readonly dispid 201;
    function Kreditkarte: IKreditkarte; dispid 202;
    property MahnkulanzBetrag: Currency readonly dispid 203;
    property MahnkulanzBis: TDateTime readonly dispid 204;
    property MahnstopBis: TDateTime readonly dispid 205;
    property Steuernummer: WideString readonly dispid 206;
    property HR_Nummer: WideString readonly dispid 207;
    property HR_Ort: WideString readonly dispid 208;
    property ZdDatum: TDateTime readonly dispid 209;
    property ZdZeitraumVon: TDateTime readonly dispid 210;
    property ZdZeitraumBis: TDateTime readonly dispid 211;
    property Zahldauer: Integer readonly dispid 212;
    property ReGesamtAnzahl: Integer readonly dispid 213;
    property ReGesamtUmsatz: Currency readonly dispid 214;
    property ReGesamtSkonto: Currency readonly dispid 215;
    property IsZentralregulierer: WordBool readonly dispid 216;
    property ZentRegKontonummer: Integer readonly dispid 217;
    property ZentRegReferenzNr: WideString readonly dispid 218;
    property Vorwahl: WideString readonly dispid 219;
    property Rufnummer: WideString readonly dispid 220;
    property Ansprechpartner: WideString readonly dispid 221;
    property Geburtstag: TDateTime readonly dispid 222;
    property Rechtsform: Integer readonly dispid 223;
    property GegenKonto: Integer readonly dispid 224;
    property AbwSammelKt: Integer readonly dispid 225;
    property AbwSkontoKt: Integer readonly dispid 226;
  end;

// *********************************************************************//
// Interface: IKonto
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {728D1D5B-1799-4139-9CC5-BDE06BDD2DFD}
// *********************************************************************//
  IKonto = interface(IDispatch)
    ['{728D1D5B-1799-4139-9CC5-BDE06BDD2DFD}']
    function Nummer: Integer; safecall;
    function Get_Bezeichnung(Nr: Integer): WideString; safecall;
    procedure Set_Bezeichnung(Nr: Integer; const Value: WideString); safecall;
    function Get_Bezeichnung1: WideString; safecall;
    procedure Set_Bezeichnung1(const Value: WideString); safecall;
    function Get_Bezeichnung2: WideString; safecall;
    procedure Set_Bezeichnung2(const Value: WideString); safecall;
    function IsBebucht: WordBool; safecall;
    function IsOP: WordBool; safecall;
    function MitOpVerwaltung: WordBool; safecall;
    function Journal: IJournal; safecall;
    function Posten(AllePosten: WordBool): IPosten; safecall;
    function Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo; safecall;
    function Get_Aenderungsdatum: TDateTime; safecall;
    function Get_Anlagedatum: TDateTime; safecall;
    function Get_GueltigBis: TDateTime; safecall;
    function GrpNummer(Nr: Integer): Integer; safecall;
    function Get_Waehrungsnummer: Integer; safecall;
    function Get_OPVerwaltungsart: Integer; safecall;
    function Get_AlteKontonummer: Integer; safecall;
    function Get_GueltigAb: TDateTime; safecall;
    function Get_Sperre: Integer; safecall;
    function Get_AccessDenied: WordBool; safecall;
    property Bezeichnung[Nr: Integer]: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property Bezeichnung1: WideString read Get_Bezeichnung1 write Set_Bezeichnung1;
    property Bezeichnung2: WideString read Get_Bezeichnung2 write Set_Bezeichnung2;
    property Aenderungsdatum: TDateTime read Get_Aenderungsdatum;
    property Anlagedatum: TDateTime read Get_Anlagedatum;
    property GueltigBis: TDateTime read Get_GueltigBis;
    property Waehrungsnummer: Integer read Get_Waehrungsnummer;
    property OPVerwaltungsart: Integer read Get_OPVerwaltungsart;
    property AlteKontonummer: Integer read Get_AlteKontonummer;
    property GueltigAb: TDateTime read Get_GueltigAb;
    property Sperre: Integer read Get_Sperre;
    property AccessDenied: WordBool read Get_AccessDenied;
  end;

// *********************************************************************//
// DispIntf:  IKontoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {728D1D5B-1799-4139-9CC5-BDE06BDD2DFD}
// *********************************************************************//
  IKontoDisp = dispinterface
    ['{728D1D5B-1799-4139-9CC5-BDE06BDD2DFD}']
    function Nummer: Integer; dispid 1;
    property Bezeichnung[Nr: Integer]: WideString dispid 2;
    property Bezeichnung1: WideString dispid 3;
    property Bezeichnung2: WideString dispid 4;
    function IsBebucht: WordBool; dispid 5;
    function IsOP: WordBool; dispid 6;
    function MitOpVerwaltung: WordBool; dispid 7;
    function Journal: IJournal; dispid 8;
    function Posten(AllePosten: WordBool): IPosten; dispid 9;
    function Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo; dispid 10;
    property Aenderungsdatum: TDateTime readonly dispid 12;
    property Anlagedatum: TDateTime readonly dispid 13;
    property GueltigBis: TDateTime readonly dispid 14;
    function GrpNummer(Nr: Integer): Integer; dispid 11;
    property Waehrungsnummer: Integer readonly dispid 15;
    property OPVerwaltungsart: Integer readonly dispid 201;
    property AlteKontonummer: Integer readonly dispid 202;
    property GueltigAb: TDateTime readonly dispid 203;
    property Sperre: Integer readonly dispid 204;
    property AccessDenied: WordBool readonly dispid 205;
  end;

// *********************************************************************//
// Interface: ISaldo
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5954A0E5-1E20-4DFD-8769-56F403985F0E}
// *********************************************************************//
  ISaldo = interface(IDispatch)
    ['{5954A0E5-1E20-4DFD-8769-56F403985F0E}']
    function Nummer: Integer; safecall;
    function AccessDenied: WordBool; safecall;
    function Get_MVZ(SollHaben: Integer; Monat: Integer): Currency; safecall;
    function Get_EB: Currency; safecall;
    function Get_MVZS(Monat: Integer): Currency; safecall;
    function Get_MVZH(Monat: Integer): Currency; safecall;
    function Get_JVZS: Currency; safecall;
    function Get_JVZH: Currency; safecall;
    function Get_Saldo: Currency; safecall;
    function Kostenart: Integer; safecall;
    function Get_Monatswert(Zeile: Integer; Monat: Integer): Currency; safecall;
    function Get_IstPlan: Integer; safecall;
    procedure Set_IstPlan(Value: Integer); safecall;
    function Get_Fixekosten(Monat: Integer): Currency; safecall;
    function Get_Variablekosten(Monat: Integer): Currency; safecall;
    function Get_Leistung(Monat: Integer): Currency; safecall;
    function Get_ISOWaehrBez: WideString; safecall;
    function Get_Tagesdatum: TDateTime; safecall;
    procedure Set_Tagesdatum(Value: TDateTime); safecall;
    function Get_IsBuchungsstapel: WordBool; safecall;
    procedure Set_IsBuchungsstapel(Value: WordBool); safecall;
    function Get_Wirtschaftsjahr: Integer; safecall;
    procedure Set_Wirtschaftsjahr(Value: Integer); safecall;
    function Get_DatumTyp: Integer; safecall;
    procedure Set_DatumTyp(Value: Integer); safecall;
    function Get_IsWiMonat: WordBool; safecall;
    procedure Set_IsWiMonat(Value: WordBool); safecall;
    function Get_IsMVZKumuliert: WordBool; safecall;
    procedure Set_IsMVZKumuliert(Value: WordBool); safecall;
    property MVZ[SollHaben: Integer; Monat: Integer]: Currency read Get_MVZ;
    property EB: Currency read Get_EB;
    property MVZS[Monat: Integer]: Currency read Get_MVZS;
    property MVZH[Monat: Integer]: Currency read Get_MVZH;
    property JVZS: Currency read Get_JVZS;
    property JVZH: Currency read Get_JVZH;
    property Saldo: Currency read Get_Saldo;
    property Monatswert[Zeile: Integer; Monat: Integer]: Currency read Get_Monatswert;
    property IstPlan: Integer read Get_IstPlan write Set_IstPlan;
    property Fixekosten[Monat: Integer]: Currency read Get_Fixekosten;
    property Variablekosten[Monat: Integer]: Currency read Get_Variablekosten;
    property Leistung[Monat: Integer]: Currency read Get_Leistung;
    property ISOWaehrBez: WideString read Get_ISOWaehrBez;
    property Tagesdatum: TDateTime read Get_Tagesdatum write Set_Tagesdatum;
    property IsBuchungsstapel: WordBool read Get_IsBuchungsstapel write Set_IsBuchungsstapel;
    property Wirtschaftsjahr: Integer read Get_Wirtschaftsjahr write Set_Wirtschaftsjahr;
    property DatumTyp: Integer read Get_DatumTyp write Set_DatumTyp;
    property IsWiMonat: WordBool read Get_IsWiMonat write Set_IsWiMonat;
    property IsMVZKumuliert: WordBool read Get_IsMVZKumuliert write Set_IsMVZKumuliert;
  end;

// *********************************************************************//
// DispIntf:  ISaldoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5954A0E5-1E20-4DFD-8769-56F403985F0E}
// *********************************************************************//
  ISaldoDisp = dispinterface
    ['{5954A0E5-1E20-4DFD-8769-56F403985F0E}']
    function Nummer: Integer; dispid 2;
    function AccessDenied: WordBool; dispid 3;
    property MVZ[SollHaben: Integer; Monat: Integer]: Currency readonly dispid 1;
    property EB: Currency readonly dispid 12;
    property MVZS[Monat: Integer]: Currency readonly dispid 7;
    property MVZH[Monat: Integer]: Currency readonly dispid 8;
    property JVZS: Currency readonly dispid 9;
    property JVZH: Currency readonly dispid 10;
    property Saldo: Currency readonly dispid 11;
    function Kostenart: Integer; dispid 4;
    property Monatswert[Zeile: Integer; Monat: Integer]: Currency readonly dispid 5;
    property IstPlan: Integer dispid 6;
    property Fixekosten[Monat: Integer]: Currency readonly dispid 13;
    property Variablekosten[Monat: Integer]: Currency readonly dispid 14;
    property Leistung[Monat: Integer]: Currency readonly dispid 15;
    property ISOWaehrBez: WideString readonly dispid 16;
    property Tagesdatum: TDateTime dispid 201;
    property IsBuchungsstapel: WordBool dispid 202;
    property Wirtschaftsjahr: Integer dispid 203;
    property DatumTyp: Integer dispid 204;
    property IsWiMonat: WordBool dispid 205;
    property IsMVZKumuliert: WordBool dispid 206;
  end;

// *********************************************************************//
// Interface: IPosten
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D9C25C8A-E7A4-48AA-A638-CCEA852FB5B5}
// *********************************************************************//
  IPosten = interface(IDispatch)
    ['{D9C25C8A-E7A4-48AA-A638-CCEA852FB5B5}']
    function Navigate: INavigate; safecall;
    function Kontierung: IKontierung; safecall;
    function Buchung: IJournal; safecall;
    function USt: IUSt; safecall;
    function Kurs: IKurs; safecall;
    function Get_Postenart: Integer; safecall;
    procedure Set_Postenart(Value: Integer); safecall;
    function Get_PostenArtBez: WideString; safecall;
    function Get_Valutadatum: TDateTime; safecall;
    procedure Set_Valutadatum(Value: TDateTime); safecall;
    function Get_Zahlart: EZahlarten; safecall;
    procedure Set_Zahlart(Value: EZahlarten); safecall;
    function Get_Skontofaktor: Double; safecall;
    procedure Set_Skontofaktor(Value: Double); safecall;
    function Get_Skontogezogen: Currency; safecall;
    procedure Set_Skontogezogen(Value: Currency); safecall;
    function Get_IsBezahlt: WordBool; safecall;
    procedure Set_IsBezahlt(Value: WordBool); safecall;
    function Mahn: IMahn; safecall;
    function Get_BezahltDatum: TDateTime; safecall;
    procedure Set_BezahltDatum(Value: TDateTime); safecall;
    function Zahlkondition: IZahlkondition; safecall;
    function Get_IsPostenausgleich: WordBool; safecall;
    function Get_IsAnzahlung: WordBool; safecall;
    procedure Set_IsAnzahlung(Value: WordBool); safecall;
    function ZugeordnetPosten: IPosten; safecall;
    function Get_Postennummer: Integer; safecall;
    function Get_BuchJournalZeile: Integer; safecall;
    function Get_KLRJournalZeile: Integer; safecall;
    function Get_WiJ: Integer; safecall;
    function Get_ZugeordnetPostenJournalZeile: Integer; safecall;
    function Get_Kursdifferenz: Currency; safecall;
    function Get_IsPicture: WordBool; safecall;
    function Get_ZinsDatum: TDateTime; safecall;
    function Get_KlrWiJ: Integer; safecall;
    function Get_OpJrnZlVorjahr: Integer; safecall;
    property Postenart: Integer read Get_Postenart write Set_Postenart;
    property PostenArtBez: WideString read Get_PostenArtBez;
    property Valutadatum: TDateTime read Get_Valutadatum write Set_Valutadatum;
    property Zahlart: EZahlarten read Get_Zahlart write Set_Zahlart;
    property Skontofaktor: Double read Get_Skontofaktor write Set_Skontofaktor;
    property Skontogezogen: Currency read Get_Skontogezogen write Set_Skontogezogen;
    property IsBezahlt: WordBool read Get_IsBezahlt write Set_IsBezahlt;
    property BezahltDatum: TDateTime read Get_BezahltDatum write Set_BezahltDatum;
    property IsPostenausgleich: WordBool read Get_IsPostenausgleich;
    property IsAnzahlung: WordBool read Get_IsAnzahlung write Set_IsAnzahlung;
    property Postennummer: Integer read Get_Postennummer;
    property BuchJournalZeile: Integer read Get_BuchJournalZeile;
    property KLRJournalZeile: Integer read Get_KLRJournalZeile;
    property WiJ: Integer read Get_WiJ;
    property ZugeordnetPostenJournalZeile: Integer read Get_ZugeordnetPostenJournalZeile;
    property Kursdifferenz: Currency read Get_Kursdifferenz;
    property IsPicture: WordBool read Get_IsPicture;
    property ZinsDatum: TDateTime read Get_ZinsDatum;
    property KlrWiJ: Integer read Get_KlrWiJ;
    property OpJrnZlVorjahr: Integer read Get_OpJrnZlVorjahr;
  end;

// *********************************************************************//
// DispIntf:  IPostenDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D9C25C8A-E7A4-48AA-A638-CCEA852FB5B5}
// *********************************************************************//
  IPostenDisp = dispinterface
    ['{D9C25C8A-E7A4-48AA-A638-CCEA852FB5B5}']
    function Navigate: INavigate; dispid 1;
    function Kontierung: IKontierung; dispid 7;
    function Buchung: IJournal; dispid 8;
    function USt: IUSt; dispid 2;
    function Kurs: IKurs; dispid 3;
    property Postenart: Integer dispid 6;
    property PostenArtBez: WideString readonly dispid 10;
    property Valutadatum: TDateTime dispid 11;
    property Zahlart: EZahlarten dispid 12;
    property Skontofaktor: Double dispid 13;
    property Skontogezogen: Currency dispid 14;
    property IsBezahlt: WordBool dispid 15;
    function Mahn: IMahn; dispid 18;
    property BezahltDatum: TDateTime dispid 4;
    function Zahlkondition: IZahlkondition; dispid 5;
    property IsPostenausgleich: WordBool readonly dispid 16;
    property IsAnzahlung: WordBool dispid 17;
    function ZugeordnetPosten: IPosten; dispid 19;
    property Postennummer: Integer readonly dispid 20;
    property BuchJournalZeile: Integer readonly dispid 9;
    property KLRJournalZeile: Integer readonly dispid 21;
    property WiJ: Integer readonly dispid 22;
    property ZugeordnetPostenJournalZeile: Integer readonly dispid 23;
    property Kursdifferenz: Currency readonly dispid 201;
    property IsPicture: WordBool readonly dispid 202;
    property ZinsDatum: TDateTime readonly dispid 203;
    property KlrWiJ: Integer readonly dispid 204;
    property OpJrnZlVorjahr: Integer readonly dispid 205;
  end;

// *********************************************************************//
// Interface: INavigate
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {45ADFB97-6F13-47B6-BF10-F488AEA08CEB}
// *********************************************************************//
  INavigate = interface(IDispatch)
    ['{45ADFB97-6F13-47B6-BF10-F488AEA08CEB}']
    function Count: Integer; safecall;
    function First: WordBool; safecall;
    function Last: WordBool; safecall;
    function Next: WordBool; safecall;
    function Previous: WordBool; safecall;
    function Get_Current: Integer; safecall;
    procedure Set_Current(Value: Integer); safecall;
    function EOF: WordBool; safecall;
    function BOF: WordBool; safecall;
    function Get_Memotext: WideString; safecall;
    function Get_IsMemotext: WordBool; safecall;
    function Get_CacheSizeMB: Integer; safecall;
    procedure Set_CacheSizeMB(Value: Integer); safecall;
    property Current: Integer read Get_Current write Set_Current;
    property Memotext: WideString read Get_Memotext;
    property IsMemotext: WordBool read Get_IsMemotext;
    property CacheSizeMB: Integer read Get_CacheSizeMB write Set_CacheSizeMB;
  end;

// *********************************************************************//
// DispIntf:  INavigateDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {45ADFB97-6F13-47B6-BF10-F488AEA08CEB}
// *********************************************************************//
  INavigateDisp = dispinterface
    ['{45ADFB97-6F13-47B6-BF10-F488AEA08CEB}']
    function Count: Integer; dispid 1;
    function First: WordBool; dispid 2;
    function Last: WordBool; dispid 3;
    function Next: WordBool; dispid 5;
    function Previous: WordBool; dispid 4;
    property Current: Integer dispid 6;
    function EOF: WordBool; dispid 7;
    function BOF: WordBool; dispid 8;
    property Memotext: WideString readonly dispid 9;
    property IsMemotext: WordBool readonly dispid 201;
    property CacheSizeMB: Integer dispid 202;
  end;

// *********************************************************************//
// Interface: IKontierung
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8B8A6BB9-8950-4755-B35C-6BC7F281D6A2}
// *********************************************************************//
  IKontierung = interface(IDispatch)
    ['{8B8A6BB9-8950-4755-B35C-6BC7F281D6A2}']
    function Get_Journalzeile: Integer; safecall;
    function Get_Betrag: Currency; safecall;
    procedure Set_Betrag(Value: Currency); safecall;
    function Get_Tagesdatum: TDateTime; safecall;
    procedure Set_Tagesdatum(Value: TDateTime); safecall;
    function Get_Belegdatum: TDateTime; safecall;
    procedure Set_Belegdatum(Value: TDateTime); safecall;
    function Get_Buchdatum: TDateTime; safecall;
    procedure Set_Buchdatum(Value: TDateTime); safecall;
    function Get_Belegnummer(Nr: Integer): WideString; safecall;
    procedure Set_Belegnummer(Nr: Integer; const Value: WideString); safecall;
    function Get_Belegnummer1: WideString; safecall;
    procedure Set_Belegnummer1(const Value: WideString); safecall;
    function Get_Belegnummer2: WideString; safecall;
    procedure Set_Belegnummer2(const Value: WideString); safecall;
    function Get_Buchtext: WideString; safecall;
    procedure Set_Buchtext(const Value: WideString); safecall;
    function Get_Kontonummer: Integer; safecall;
    procedure Set_Kontonummer(Value: Integer); safecall;
    function Get_GegenKonto: Integer; safecall;
    procedure Set_GegenKonto(Value: Integer); safecall;
    function Get_Benutzer: WideString; safecall;
    procedure Set_Benutzer(const Value: WideString); safecall;
    function AsRecord: RKontierung; safecall;
    function Get_IsValid: WordBool; safecall;
    function Get_TaNr: Integer; safecall;
    property Journalzeile: Integer read Get_Journalzeile;
    property Betrag: Currency read Get_Betrag write Set_Betrag;
    property Tagesdatum: TDateTime read Get_Tagesdatum write Set_Tagesdatum;
    property Belegdatum: TDateTime read Get_Belegdatum write Set_Belegdatum;
    property Buchdatum: TDateTime read Get_Buchdatum write Set_Buchdatum;
    property Belegnummer[Nr: Integer]: WideString read Get_Belegnummer write Set_Belegnummer;
    property Belegnummer1: WideString read Get_Belegnummer1 write Set_Belegnummer1;
    property Belegnummer2: WideString read Get_Belegnummer2 write Set_Belegnummer2;
    property Buchtext: WideString read Get_Buchtext write Set_Buchtext;
    property Kontonummer: Integer read Get_Kontonummer write Set_Kontonummer;
    property GegenKonto: Integer read Get_GegenKonto write Set_GegenKonto;
    property Benutzer: WideString read Get_Benutzer write Set_Benutzer;
    property IsValid: WordBool read Get_IsValid;
    property TaNr: Integer read Get_TaNr;
  end;

// *********************************************************************//
// DispIntf:  IKontierungDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8B8A6BB9-8950-4755-B35C-6BC7F281D6A2}
// *********************************************************************//
  IKontierungDisp = dispinterface
    ['{8B8A6BB9-8950-4755-B35C-6BC7F281D6A2}']
    property Journalzeile: Integer readonly dispid 13;
    property Betrag: Currency dispid 1;
    property Tagesdatum: TDateTime dispid 2;
    property Belegdatum: TDateTime dispid 3;
    property Buchdatum: TDateTime dispid 4;
    property Belegnummer[Nr: Integer]: WideString dispid 5;
    property Belegnummer1: WideString dispid 6;
    property Belegnummer2: WideString dispid 7;
    property Buchtext: WideString dispid 8;
    property Kontonummer: Integer dispid 9;
    property GegenKonto: Integer dispid 10;
    property Benutzer: WideString dispid 11;
    function AsRecord: {NOT_OLEAUTO(RKontierung)}OleVariant; dispid 12;
    property IsValid: WordBool readonly dispid 14;
    property TaNr: Integer readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IJournal
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2AD3D557-8A90-40D1-A136-064BE6D44454}
// *********************************************************************//
  IJournal = interface(IDispatch)
    ['{2AD3D557-8A90-40D1-A136-064BE6D44454}']
    function Navigate: INavigate; safecall;
    function Kontierung: IKontierung; safecall;
    function USt: IUSt; safecall;
    function Get_SollHaben: Integer; safecall;
    function Get_IsLetzteBuchung: WordBool; safecall;
    function Get_Konzern: Integer; safecall;
    function Kurs: IKurs; safecall;
    function Get_UStIdNr: WideString; safecall;
    function Get_Wertstellungsdatum: TDateTime; safecall;
    function Get_Reisedatum: TDateTime; safecall;
    function Get_Steuersatz: Currency; safecall;
    function Get_KLRJournalZeile: Integer; safecall;
    function Get_PostenJournalzeile: Integer; safecall;
    function Get_IsPicture: WordBool; safecall;
    function Get_IsBarcode: WordBool; safecall;
    function Get_PictureCount: Integer; safecall;
    function AsTIF(Index: Integer): OleVariant; safecall;
    function AsBMP(Index: Integer): OleVariant; safecall;
    function AsJPG(Index: Integer): OleVariant; safecall;
    procedure TestTifPicture(const PictureName: WideString); safecall;
    function Get_Inventarnummer: WideString; safecall;
    function Get_AutomatikKennz: WideString; safecall;
    property SollHaben: Integer read Get_SollHaben;
    property IsLetzteBuchung: WordBool read Get_IsLetzteBuchung;
    property Konzern: Integer read Get_Konzern;
    property UStIdNr: WideString read Get_UStIdNr;
    property Wertstellungsdatum: TDateTime read Get_Wertstellungsdatum;
    property Reisedatum: TDateTime read Get_Reisedatum;
    property Steuersatz: Currency read Get_Steuersatz;
    property KLRJournalZeile: Integer read Get_KLRJournalZeile;
    property PostenJournalzeile: Integer read Get_PostenJournalzeile;
    property IsPicture: WordBool read Get_IsPicture;
    property IsBarcode: WordBool read Get_IsBarcode;
    property PictureCount: Integer read Get_PictureCount;
    property Inventarnummer: WideString read Get_Inventarnummer;
    property AutomatikKennz: WideString read Get_AutomatikKennz;
  end;

// *********************************************************************//
// DispIntf:  IJournalDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2AD3D557-8A90-40D1-A136-064BE6D44454}
// *********************************************************************//
  IJournalDisp = dispinterface
    ['{2AD3D557-8A90-40D1-A136-064BE6D44454}']
    function Navigate: INavigate; dispid 1;
    function Kontierung: IKontierung; dispid 2;
    function USt: IUSt; dispid 3;
    property SollHaben: Integer readonly dispid 5;
    property IsLetzteBuchung: WordBool readonly dispid 6;
    property Konzern: Integer readonly dispid 8;
    function Kurs: IKurs; dispid 9;
    property UStIdNr: WideString readonly dispid 10;
    property Wertstellungsdatum: TDateTime readonly dispid 11;
    property Reisedatum: TDateTime readonly dispid 12;
    property Steuersatz: Currency readonly dispid 4;
    property KLRJournalZeile: Integer readonly dispid 201;
    property PostenJournalzeile: Integer readonly dispid 202;
    property IsPicture: WordBool readonly dispid 203;
    property IsBarcode: WordBool readonly dispid 204;
    property PictureCount: Integer readonly dispid 205;
    function AsTIF(Index: Integer): OleVariant; dispid 206;
    function AsBMP(Index: Integer): OleVariant; dispid 207;
    function AsJPG(Index: Integer): OleVariant; dispid 208;
    procedure TestTifPicture(const PictureName: WideString); dispid 209;
    property Inventarnummer: WideString readonly dispid 210;
    property AutomatikKennz: WideString readonly dispid 211;
  end;

// *********************************************************************//
// Interface: IKLRJournal
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DB0BA66D-E770-4A28-9985-4F62B8837510}
// *********************************************************************//
  IKLRJournal = interface(IDispatch)
    ['{DB0BA66D-E770-4A28-9985-4F62B8837510}']
    function Navigate: INavigate; safecall;
    function Kontierung: IKontierung; safecall;
    function IsKostenstelle: WordBool; safecall;
    function Kostenstelle: IKostenstelle; safecall;
    function IsKostentraeger: WordBool; safecall;
    function Kostentraeger: IKostenstelle; safecall;
    function Get_FixVar: EKostentypen; safecall;
    procedure Set_FixVar(Value: EKostentypen); safecall;
    function Journal: IJournal; safecall;
    function Get_KoStTrNr: Integer; safecall;
    function Get_BuchJournalZeile: Integer; safecall;
    function Get_KArtNr: Integer; safecall;
    function Kostenart: IKostenart; safecall;
    function Get_SollHaben: Integer; safecall;
    function Get_IsLetzteBuchung: WordBool; safecall;
    function Get_Ebene: Integer; safecall;
    function Get_GegenkontoTyp: EKontotypen; safecall;
    function Get_Herkunft: Integer; safecall;
    function Get_KTrNr: Integer; safecall;
    function Get_PostenRef: Integer; safecall;
    property FixVar: EKostentypen read Get_FixVar write Set_FixVar;
    property KoStTrNr: Integer read Get_KoStTrNr;
    property BuchJournalZeile: Integer read Get_BuchJournalZeile;
    property KArtNr: Integer read Get_KArtNr;
    property SollHaben: Integer read Get_SollHaben;
    property IsLetzteBuchung: WordBool read Get_IsLetzteBuchung;
    property Ebene: Integer read Get_Ebene;
    property GegenkontoTyp: EKontotypen read Get_GegenkontoTyp;
    property Herkunft: Integer read Get_Herkunft;
    property KTrNr: Integer read Get_KTrNr;
    property PostenRef: Integer read Get_PostenRef;
  end;

// *********************************************************************//
// DispIntf:  IKLRJournalDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DB0BA66D-E770-4A28-9985-4F62B8837510}
// *********************************************************************//
  IKLRJournalDisp = dispinterface
    ['{DB0BA66D-E770-4A28-9985-4F62B8837510}']
    function Navigate: INavigate; dispid 1;
    function Kontierung: IKontierung; dispid 2;
    function IsKostenstelle: WordBool; dispid 3;
    function Kostenstelle: IKostenstelle; dispid 4;
    function IsKostentraeger: WordBool; dispid 5;
    function Kostentraeger: IKostenstelle; dispid 6;
    property FixVar: EKostentypen dispid 7;
    function Journal: IJournal; dispid 8;
    property KoStTrNr: Integer readonly dispid 9;
    property BuchJournalZeile: Integer readonly dispid 10;
    property KArtNr: Integer readonly dispid 11;
    function Kostenart: IKostenart; dispid 12;
    property SollHaben: Integer readonly dispid 13;
    property IsLetzteBuchung: WordBool readonly dispid 14;
    property Ebene: Integer readonly dispid 15;
    property GegenkontoTyp: EKontotypen readonly dispid 201;
    property Herkunft: Integer readonly dispid 202;
    property KTrNr: Integer readonly dispid 203;
    property PostenRef: Integer readonly dispid 204;
  end;

// *********************************************************************//
// Interface: IFestkonto
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EBF5D737-E60A-43BD-8DF7-E2BFE361B01D}
// *********************************************************************//
  IFestkonto = interface(IDispatch)
    ['{EBF5D737-E60A-43BD-8DF7-E2BFE361B01D}']
    function Get_Kontonummer(Nummer: Integer): Integer; safecall;
    procedure Set_Kontonummer(Nummer: Integer; Value: Integer); safecall;
    function Get_Bezeichnung(Nr: Integer): WideString; safecall;
    function Sachkonto: ISachkonto; safecall;
    function Get_Nummer: Integer; safecall;
    procedure Set_Nummer(Value: Integer); safecall;
    property Kontonummer[Nummer: Integer]: Integer read Get_Kontonummer write Set_Kontonummer;
    property Bezeichnung[Nr: Integer]: WideString read Get_Bezeichnung;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
  end;

// *********************************************************************//
// DispIntf:  IFestkontoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EBF5D737-E60A-43BD-8DF7-E2BFE361B01D}
// *********************************************************************//
  IFestkontoDisp = dispinterface
    ['{EBF5D737-E60A-43BD-8DF7-E2BFE361B01D}']
    property Kontonummer[Nummer: Integer]: Integer dispid 1;
    property Bezeichnung[Nr: Integer]: WideString readonly dispid 3;
    function Sachkonto: ISachkonto; dispid 4;
    property Nummer: Integer dispid 2;
  end;

// *********************************************************************//
// Interface: IKreditor
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {883889E8-44FD-402B-9ED9-16011E68D8EF}
// *********************************************************************//
  IKreditor = interface(IDispatch)
    ['{883889E8-44FD-402B-9ED9-16011E68D8EF}']
    function Navigate: INavigate; safecall;
    function Get_Kontonummer: Integer; safecall;
    procedure Set_Kontonummer(Value: Integer); safecall;
    function Konto: IKonto; safecall;
    function Adresse: IAdresse; safecall;
    function Get_InlEuroDritt: Integer; safecall;
    procedure Set_InlEuroDritt(Value: Integer); safecall;
    function Bankverbindung: IBankverbindung; safecall;
    function Get_Zahlart: EZahlarten; safecall;
    function Get_Zahlkondition: IZahlkondition; safecall;
    function Get_Kundennummer: WideString; safecall;
    function Rabatt(Index: Integer): Currency; safecall;
    function Get_Konzern: Integer; safecall;
    function Get_NummerBeimPartner: WideString; safecall;
    function Get_Gebietsnummer: Integer; safecall;
    function Get_Steuernummer: WideString; safecall;
    function Get_HR_Nummer: WideString; safecall;
    function Get_HR_Ort: WideString; safecall;
    function Get_ZdDatum: TDateTime; safecall;
    function Get_ZdZeitraumVon: TDateTime; safecall;
    function Get_ZdZeitraumBis: TDateTime; safecall;
    function Get_Zahldauer: Integer; safecall;
    function Get_ReGesamtAnzahl: Integer; safecall;
    function Get_ReGesamtUmsatz: Currency; safecall;
    function Get_ReGesamtSkonto: Currency; safecall;
    function Get_IsBauAbzugssteuer: WordBool; safecall;
    function Get_BauFreistellungVon: TDateTime; safecall;
    function Get_BauFreistellungBis: TDateTime; safecall;
    function Get_IsZentralregulierer: WordBool; safecall;
    function Get_ZentRegKontonummer: Integer; safecall;
    function Get_ZentRegReferenzNr: WideString; safecall;
    function Get_Vorwahl: WideString; safecall;
    function Get_Rufnummer: WideString; safecall;
    function Get_Ansprechpartner: WideString; safecall;
    function Get_Geburtstag: TDateTime; safecall;
    function Get_Rechtsform: Integer; safecall;
    function Get_GegenKonto: Integer; safecall;
    function Get_AbwSammelKt: Integer; safecall;
    function Get_AbwSkontoKt: Integer; safecall;
    property Kontonummer: Integer read Get_Kontonummer write Set_Kontonummer;
    property InlEuroDritt: Integer read Get_InlEuroDritt write Set_InlEuroDritt;
    property Zahlart: EZahlarten read Get_Zahlart;
    property Zahlkondition: IZahlkondition read Get_Zahlkondition;
    property Kundennummer: WideString read Get_Kundennummer;
    property Konzern: Integer read Get_Konzern;
    property NummerBeimPartner: WideString read Get_NummerBeimPartner;
    property Gebietsnummer: Integer read Get_Gebietsnummer;
    property Steuernummer: WideString read Get_Steuernummer;
    property HR_Nummer: WideString read Get_HR_Nummer;
    property HR_Ort: WideString read Get_HR_Ort;
    property ZdDatum: TDateTime read Get_ZdDatum;
    property ZdZeitraumVon: TDateTime read Get_ZdZeitraumVon;
    property ZdZeitraumBis: TDateTime read Get_ZdZeitraumBis;
    property Zahldauer: Integer read Get_Zahldauer;
    property ReGesamtAnzahl: Integer read Get_ReGesamtAnzahl;
    property ReGesamtUmsatz: Currency read Get_ReGesamtUmsatz;
    property ReGesamtSkonto: Currency read Get_ReGesamtSkonto;
    property IsBauAbzugssteuer: WordBool read Get_IsBauAbzugssteuer;
    property BauFreistellungVon: TDateTime read Get_BauFreistellungVon;
    property BauFreistellungBis: TDateTime read Get_BauFreistellungBis;
    property IsZentralregulierer: WordBool read Get_IsZentralregulierer;
    property ZentRegKontonummer: Integer read Get_ZentRegKontonummer;
    property ZentRegReferenzNr: WideString read Get_ZentRegReferenzNr;
    property Vorwahl: WideString read Get_Vorwahl;
    property Rufnummer: WideString read Get_Rufnummer;
    property Ansprechpartner: WideString read Get_Ansprechpartner;
    property Geburtstag: TDateTime read Get_Geburtstag;
    property Rechtsform: Integer read Get_Rechtsform;
    property GegenKonto: Integer read Get_GegenKonto;
    property AbwSammelKt: Integer read Get_AbwSammelKt;
    property AbwSkontoKt: Integer read Get_AbwSkontoKt;
  end;

// *********************************************************************//
// DispIntf:  IKreditorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {883889E8-44FD-402B-9ED9-16011E68D8EF}
// *********************************************************************//
  IKreditorDisp = dispinterface
    ['{883889E8-44FD-402B-9ED9-16011E68D8EF}']
    function Navigate: INavigate; dispid 1;
    property Kontonummer: Integer dispid 7;
    function Konto: IKonto; dispid 8;
    function Adresse: IAdresse; dispid 9;
    property InlEuroDritt: Integer dispid 2;
    function Bankverbindung: IBankverbindung; dispid 3;
    property Zahlart: EZahlarten readonly dispid 4;
    property Zahlkondition: IZahlkondition readonly dispid 5;
    property Kundennummer: WideString readonly dispid 6;
    function Rabatt(Index: Integer): Currency; dispid 10;
    property Konzern: Integer readonly dispid 11;
    property NummerBeimPartner: WideString readonly dispid 12;
    property Gebietsnummer: Integer readonly dispid 201;
    property Steuernummer: WideString readonly dispid 202;
    property HR_Nummer: WideString readonly dispid 203;
    property HR_Ort: WideString readonly dispid 204;
    property ZdDatum: TDateTime readonly dispid 205;
    property ZdZeitraumVon: TDateTime readonly dispid 206;
    property ZdZeitraumBis: TDateTime readonly dispid 207;
    property Zahldauer: Integer readonly dispid 208;
    property ReGesamtAnzahl: Integer readonly dispid 209;
    property ReGesamtUmsatz: Currency readonly dispid 210;
    property ReGesamtSkonto: Currency readonly dispid 211;
    property IsBauAbzugssteuer: WordBool readonly dispid 212;
    property BauFreistellungVon: TDateTime readonly dispid 213;
    property BauFreistellungBis: TDateTime readonly dispid 214;
    property IsZentralregulierer: WordBool readonly dispid 215;
    property ZentRegKontonummer: Integer readonly dispid 216;
    property ZentRegReferenzNr: WideString readonly dispid 217;
    property Vorwahl: WideString readonly dispid 218;
    property Rufnummer: WideString readonly dispid 219;
    property Ansprechpartner: WideString readonly dispid 220;
    property Geburtstag: TDateTime readonly dispid 221;
    property Rechtsform: Integer readonly dispid 222;
    property GegenKonto: Integer readonly dispid 223;
    property AbwSammelKt: Integer readonly dispid 224;
    property AbwSkontoKt: Integer readonly dispid 225;
  end;

// *********************************************************************//
// Interface: ISachkonto
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B9C004D3-06FA-44FB-B65A-A164FE943443}
// *********************************************************************//
  ISachkonto = interface(IDispatch)
    ['{B9C004D3-06FA-44FB-B65A-A164FE943443}']
    function Navigate: INavigate; safecall;
    function Get_Kontonummer: Integer; safecall;
    procedure Set_Kontonummer(Value: Integer); safecall;
    function Konto: IKonto; safecall;
    function HGBPosSGruppe: IGruppe; safecall;
    function HGBPosHGruppe: IGruppe; safecall;
    function Get_HGBGruppennummer: Integer; safecall;
    function USGAAPSGruppe: IGruppe; safecall;
    function USGAAPHGruppe: IGruppe; safecall;
    function Get_USGAAPGruppennummer: Integer; safecall;
    function Get_USGAAPKonto: WideString; safecall;
    function Kostenart: IKostenart; safecall;
    function USt: IUSt; safecall;
    function Get_Kontoart: EKontoarten; safecall;
    function Get_UStVA: Integer; safecall;
    procedure Set_UStVA(Value: Integer); safecall;
    function Get_HGBZuordnung: EBilGuVZuordnung; safecall;
    function Get_SammelKtArt: ESammelKtArt; safecall;
    function Get_Umsatzschluessel: WideString; safecall;
    function Get_USGAAPZuordnung: EBilGuVZuordnung; safecall;
    function Get_Sperre: EKontensperren; safecall;
    function Get_KArtNr: Integer; safecall;
    function Get_IsKostenstellenErfassung: WordBool; safecall;
    function Get_IsKostentraegerErfassung: WordBool; safecall;
    function Get_UStIdNr: WideString; safecall;
    function Bankverbindung: IBankverbindung; safecall;
    function Get_Kreditlimit: Currency; safecall;
    function Get_Obligolimit: Currency; safecall;
    function Get_IntraWaNr: Integer; safecall;
    function Get_Kostenstelle: Integer; safecall;
    function Get_Kostentraeger: Integer; safecall;
    function Get_Steuerkonto1: Integer; safecall;
    function Get_Steuerkonto2: Integer; safecall;
    function Get_IsVStGesperrt: WordBool; safecall;
    function Get_RatingKonto: Integer; safecall;
    function Get_AnzahlArt: Integer; safecall;
    function Get_AnzKtoUSt: Integer; safecall;
    function Get_AnzKonto: Integer; safecall;
    function Get_IsAufzuteilendeVSt: WordBool; safecall;
    function Get_ErwerbLieferungAus: Integer; safecall;
    function Get_Skontokonto: Integer; safecall;
    function Get_Differenzkonto: Integer; safecall;
    function Get_EBVortrag: Integer; safecall;
    function Get_EBKonto: Integer; safecall;
    property Kontonummer: Integer read Get_Kontonummer write Set_Kontonummer;
    property HGBGruppennummer: Integer read Get_HGBGruppennummer;
    property USGAAPGruppennummer: Integer read Get_USGAAPGruppennummer;
    property USGAAPKonto: WideString read Get_USGAAPKonto;
    property Kontoart: EKontoarten read Get_Kontoart;
    property UStVA: Integer read Get_UStVA write Set_UStVA;
    property HGBZuordnung: EBilGuVZuordnung read Get_HGBZuordnung;
    property SammelKtArt: ESammelKtArt read Get_SammelKtArt;
    property Umsatzschluessel: WideString read Get_Umsatzschluessel;
    property USGAAPZuordnung: EBilGuVZuordnung read Get_USGAAPZuordnung;
    property Sperre: EKontensperren read Get_Sperre;
    property KArtNr: Integer read Get_KArtNr;
    property IsKostenstellenErfassung: WordBool read Get_IsKostenstellenErfassung;
    property IsKostentraegerErfassung: WordBool read Get_IsKostentraegerErfassung;
    property UStIdNr: WideString read Get_UStIdNr;
    property Kreditlimit: Currency read Get_Kreditlimit;
    property Obligolimit: Currency read Get_Obligolimit;
    property IntraWaNr: Integer read Get_IntraWaNr;
    property Kostenstelle: Integer read Get_Kostenstelle;
    property Kostentraeger: Integer read Get_Kostentraeger;
    property Steuerkonto1: Integer read Get_Steuerkonto1;
    property Steuerkonto2: Integer read Get_Steuerkonto2;
    property IsVStGesperrt: WordBool read Get_IsVStGesperrt;
    property RatingKonto: Integer read Get_RatingKonto;
    property AnzahlArt: Integer read Get_AnzahlArt;
    property AnzKtoUSt: Integer read Get_AnzKtoUSt;
    property AnzKonto: Integer read Get_AnzKonto;
    property IsAufzuteilendeVSt: WordBool read Get_IsAufzuteilendeVSt;
    property ErwerbLieferungAus: Integer read Get_ErwerbLieferungAus;
    property Skontokonto: Integer read Get_Skontokonto;
    property Differenzkonto: Integer read Get_Differenzkonto;
    property EBVortrag: Integer read Get_EBVortrag;
    property EBKonto: Integer read Get_EBKonto;
  end;

// *********************************************************************//
// DispIntf:  ISachkontoDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B9C004D3-06FA-44FB-B65A-A164FE943443}
// *********************************************************************//
  ISachkontoDisp = dispinterface
    ['{B9C004D3-06FA-44FB-B65A-A164FE943443}']
    function Navigate: INavigate; dispid 1;
    property Kontonummer: Integer dispid 7;
    function Konto: IKonto; dispid 8;
    function HGBPosSGruppe: IGruppe; dispid 2;
    function HGBPosHGruppe: IGruppe; dispid 3;
    property HGBGruppennummer: Integer readonly dispid 12;
    function USGAAPSGruppe: IGruppe; dispid 4;
    function USGAAPHGruppe: IGruppe; dispid 5;
    property USGAAPGruppennummer: Integer readonly dispid 13;
    property USGAAPKonto: WideString readonly dispid 14;
    function Kostenart: IKostenart; dispid 6;
    function USt: IUSt; dispid 9;
    property Kontoart: EKontoarten readonly dispid 10;
    property UStVA: Integer dispid 11;
    property HGBZuordnung: EBilGuVZuordnung readonly dispid 15;
    property SammelKtArt: ESammelKtArt readonly dispid 16;
    property Umsatzschluessel: WideString readonly dispid 17;
    property USGAAPZuordnung: EBilGuVZuordnung readonly dispid 19;
    property Sperre: EKontensperren readonly dispid 18;
    property KArtNr: Integer readonly dispid 20;
    property IsKostenstellenErfassung: WordBool readonly dispid 22;
    property IsKostentraegerErfassung: WordBool readonly dispid 23;
    property UStIdNr: WideString readonly dispid 21;
    function Bankverbindung: IBankverbindung; dispid 201;
    property Kreditlimit: Currency readonly dispid 202;
    property Obligolimit: Currency readonly dispid 203;
    property IntraWaNr: Integer readonly dispid 204;
    property Kostenstelle: Integer readonly dispid 205;
    property Kostentraeger: Integer readonly dispid 206;
    property Steuerkonto1: Integer readonly dispid 207;
    property Steuerkonto2: Integer readonly dispid 208;
    property IsVStGesperrt: WordBool readonly dispid 209;
    property RatingKonto: Integer readonly dispid 210;
    property AnzahlArt: Integer readonly dispid 211;
    property AnzKtoUSt: Integer readonly dispid 212;
    property AnzKonto: Integer readonly dispid 213;
    property IsAufzuteilendeVSt: WordBool readonly dispid 214;
    property ErwerbLieferungAus: Integer readonly dispid 215;
    property Skontokonto: Integer readonly dispid 216;
    property Differenzkonto: Integer readonly dispid 217;
    property EBVortrag: Integer readonly dispid 218;
    property EBKonto: Integer readonly dispid 219;
  end;

// *********************************************************************//
// Interface: IBuchtext
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E7D65604-3692-4FBA-9A87-061D5B95CCC4}
// *********************************************************************//
  IBuchtext = interface(IDispatch)
    ['{E7D65604-3692-4FBA-9A87-061D5B95CCC4}']
    function Get_Text(Nr: Integer): WideString; safecall;
    procedure Set_Text(Nr: Integer; const Value: WideString); safecall;
    property Text[Nr: Integer]: WideString read Get_Text write Set_Text;
  end;

// *********************************************************************//
// DispIntf:  IBuchtextDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E7D65604-3692-4FBA-9A87-061D5B95CCC4}
// *********************************************************************//
  IBuchtextDisp = dispinterface
    ['{E7D65604-3692-4FBA-9A87-061D5B95CCC4}']
    property Text[Nr: Integer]: WideString dispid 1;
  end;

// *********************************************************************//
// Interface: ISteuer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22C0CE96-24A8-4709-9E06-A2FF7AF6D473}
// *********************************************************************//
  ISteuer = interface(IDispatch)
    ['{22C0CE96-24A8-4709-9E06-A2FF7AF6D473}']
    function Navigate: INavigate; safecall;
    function Get_Nummer: Integer; safecall;
    procedure Set_Nummer(Value: Integer); safecall;
    function Get_Bezeichnung: WideString; safecall;
    procedure Set_Bezeichnung(const Value: WideString); safecall;
    function Get_Steuersatz1: Double; safecall;
    procedure Set_Steuersatz1(Value: Double); safecall;
    function Get_AbDatum: TDateTime; safecall;
    procedure Set_AbDatum(Value: TDateTime); safecall;
    function Get_Steuersatz2: Double; safecall;
    procedure Set_Steuersatz2(Value: Double); safecall;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property Steuersatz1: Double read Get_Steuersatz1 write Set_Steuersatz1;
    property AbDatum: TDateTime read Get_AbDatum write Set_AbDatum;
    property Steuersatz2: Double read Get_Steuersatz2 write Set_Steuersatz2;
  end;

// *********************************************************************//
// DispIntf:  ISteuerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {22C0CE96-24A8-4709-9E06-A2FF7AF6D473}
// *********************************************************************//
  ISteuerDisp = dispinterface
    ['{22C0CE96-24A8-4709-9E06-A2FF7AF6D473}']
    function Navigate: INavigate; dispid 5;
    property Nummer: Integer dispid 6;
    property Bezeichnung: WideString dispid 1;
    property Steuersatz1: Double dispid 2;
    property AbDatum: TDateTime dispid 3;
    property Steuersatz2: Double dispid 4;
  end;

// *********************************************************************//
// Interface: IFinanzamt
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {674A1634-FB20-4628-A844-B8EDA3816C13}
// *********************************************************************//
  IFinanzamt = interface(IDispatch)
    ['{674A1634-FB20-4628-A844-B8EDA3816C13}']
    function Navigate: INavigate; safecall;
    function Get_Nummer: Integer; safecall;
    procedure Set_Nummer(Value: Integer); safecall;
    function Adresse: IAdresse; safecall;
    function Get_OFD: WideString; safecall;
    procedure Set_OFD(const Value: WideString); safecall;
    function Get_Bundesland: WideString; safecall;
    procedure Set_Bundesland(const Value: WideString); safecall;
    function Bankverbindung(Nr: Integer): IBankverbindung; safecall;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property OFD: WideString read Get_OFD write Set_OFD;
    property Bundesland: WideString read Get_Bundesland write Set_Bundesland;
  end;

// *********************************************************************//
// DispIntf:  IFinanzamtDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {674A1634-FB20-4628-A844-B8EDA3816C13}
// *********************************************************************//
  IFinanzamtDisp = dispinterface
    ['{674A1634-FB20-4628-A844-B8EDA3816C13}']
    function Navigate: INavigate; dispid 1;
    property Nummer: Integer dispid 2;
    function Adresse: IAdresse; dispid 3;
    property OFD: WideString dispid 4;
    property Bundesland: WideString dispid 5;
    function Bankverbindung(Nr: Integer): IBankverbindung; dispid 6;
  end;

// *********************************************************************//
// Interface: IBank
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B8862CA1-FB09-436E-ACED-030B76C2B036}
// *********************************************************************//
  IBank = interface(IDispatch)
    ['{B8862CA1-FB09-436E-ACED-030B76C2B036}']
    function Navigate: INavigate; safecall;
    function Get_BLZ: Integer; safecall;
    procedure Set_BLZ(Value: Integer); safecall;
    function Get_Bezeichnung: WideString; safecall;
    procedure Set_Bezeichnung(const Value: WideString); safecall;
    function CheckBLZ(BLZ: Integer): WordBool; safecall;
    function CheckKTO(BLZ: Integer; const KTO: WideString): WordBool; safecall;
    function Get_Pruefziffer: Integer; safecall;
    function Get_PLZ: Integer; safecall;
    function Ort: IOrt; safecall;
    function CheckIBAN(const IBANNr: WideString): WordBool; safecall;
    property BLZ: Integer read Get_BLZ write Set_BLZ;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property Pruefziffer: Integer read Get_Pruefziffer;
    property PLZ: Integer read Get_PLZ;
  end;

// *********************************************************************//
// DispIntf:  IBankDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B8862CA1-FB09-436E-ACED-030B76C2B036}
// *********************************************************************//
  IBankDisp = dispinterface
    ['{B8862CA1-FB09-436E-ACED-030B76C2B036}']
    function Navigate: INavigate; dispid 4;
    property BLZ: Integer dispid 1;
    property Bezeichnung: WideString dispid 3;
    function CheckBLZ(BLZ: Integer): WordBool; dispid 2;
    function CheckKTO(BLZ: Integer; const KTO: WideString): WordBool; dispid 5;
    property Pruefziffer: Integer readonly dispid 6;
    property PLZ: Integer readonly dispid 7;
    function Ort: IOrt; dispid 8;
    function CheckIBAN(const IBANNr: WideString): WordBool; dispid 9;
  end;

// *********************************************************************//
// Interface: IKontenbereich
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7972BFC3-14AE-4196-8B20-878EB497C9F9}
// *********************************************************************//
  IKontenbereich = interface(IDispatch)
    ['{7972BFC3-14AE-4196-8B20-878EB497C9F9}']
    procedure Debitoren(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); safecall;
    procedure Kreditoren(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); safecall;
    procedure Sachkonten(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); safecall;
    procedure Kostenstellen(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); safecall;
    procedure Kostentraeger(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); safecall;
    procedure Kostenarten(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); safecall;
    function GetKontoTyp(Konto: Integer): EKontotypen; safecall;
    function CheckKonto(Konto: Integer; KontoTyp: EKontotypen): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IKontenbereichDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7972BFC3-14AE-4196-8B20-878EB497C9F9}
// *********************************************************************//
  IKontenbereichDisp = dispinterface
    ['{7972BFC3-14AE-4196-8B20-878EB497C9F9}']
    procedure Debitoren(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); dispid 1;
    procedure Kreditoren(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); dispid 2;
    procedure Sachkonten(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); dispid 3;
    procedure Kostenstellen(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); dispid 4;
    procedure Kostentraeger(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); dispid 5;
    procedure Kostenarten(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer); dispid 6;
    function GetKontoTyp(Konto: Integer): EKontotypen; dispid 7;
    function CheckKonto(Konto: Integer; KontoTyp: EKontotypen): WordBool; dispid 8;
  end;

// *********************************************************************//
// Interface: IBankverbindung
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {31B86FDE-9985-4E8F-BBFE-0D7BFC116AD2}
// *********************************************************************//
  IBankverbindung = interface(IDispatch)
    ['{31B86FDE-9985-4E8F-BBFE-0D7BFC116AD2}']
    function Bank: IBank; safecall;
    function Get_KTO: WideString; safecall;
    procedure Set_KTO(const Value: WideString); safecall;
    function Get_Inhaber: WideString; safecall;
    procedure Set_Inhaber(const Value: WideString); safecall;
    function CheckKTO: WordBool; safecall;
    function Get_BLZ: Integer; safecall;
    function Get_IBAN: WideString; safecall;
    function CheckIBAN: WordBool; safecall;
    function Get_SWIFT: WideString; safecall;
    function Get_AuslBankKto: WideString; safecall;
    property KTO: WideString read Get_KTO write Set_KTO;
    property Inhaber: WideString read Get_Inhaber write Set_Inhaber;
    property BLZ: Integer read Get_BLZ;
    property IBAN: WideString read Get_IBAN;
    property SWIFT: WideString read Get_SWIFT;
    property AuslBankKto: WideString read Get_AuslBankKto;
  end;

// *********************************************************************//
// DispIntf:  IBankverbindungDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {31B86FDE-9985-4E8F-BBFE-0D7BFC116AD2}
// *********************************************************************//
  IBankverbindungDisp = dispinterface
    ['{31B86FDE-9985-4E8F-BBFE-0D7BFC116AD2}']
    function Bank: IBank; dispid 1;
    property KTO: WideString dispid 3;
    property Inhaber: WideString dispid 4;
    function CheckKTO: WordBool; dispid 2;
    property BLZ: Integer readonly dispid 5;
    property IBAN: WideString readonly dispid 6;
    function CheckIBAN: WordBool; dispid 7;
    property SWIFT: WideString readonly dispid 201;
    property AuslBankKto: WideString readonly dispid 202;
  end;

// *********************************************************************//
// Interface: IGruppe
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {36FFA492-B38C-4E00-A40B-4B8830C94AFD}
// *********************************************************************//
  IGruppe = interface(IDispatch)
    ['{36FFA492-B38C-4E00-A40B-4B8830C94AFD}']
    function Navigate: INavigate; safecall;
    function Get_Nummer: Integer; safecall;
    procedure Set_Nummer(Value: Integer); safecall;
    function Get_Bezeichnung: WideString; safecall;
    procedure Set_Bezeichnung(const Value: WideString); safecall;
    function Get_Zuordnung: EBilGuVZuordnung; safecall;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property Zuordnung: EBilGuVZuordnung read Get_Zuordnung;
  end;

// *********************************************************************//
// DispIntf:  IGruppeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {36FFA492-B38C-4E00-A40B-4B8830C94AFD}
// *********************************************************************//
  IGruppeDisp = dispinterface
    ['{36FFA492-B38C-4E00-A40B-4B8830C94AFD}']
    function Navigate: INavigate; dispid 1;
    property Nummer: Integer dispid 2;
    property Bezeichnung: WideString dispid 3;
    property Zuordnung: EBilGuVZuordnung readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IKostenart
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B8AA063F-0902-48B5-9DFD-1F28EF9FF9EC}
// *********************************************************************//
  IKostenart = interface(IDispatch)
    ['{B8AA063F-0902-48B5-9DFD-1F28EF9FF9EC}']
    function Navigate: INavigate; safecall;
    function Get_Nummer: Integer; safecall;
    procedure Set_Nummer(Value: Integer); safecall;
    function Get_Bezeichnung: WideString; safecall;
    procedure Set_Bezeichnung(const Value: WideString); safecall;
    function Get_IsLeistung: WordBool; safecall;
    procedure Set_IsLeistung(Value: WordBool); safecall;
    function Get_IsMengenerfassung: WordBool; safecall;
    function Get_IsBebucht: WordBool; safecall;
    function KStSaldo(WaNr: Integer; IsInHW: WordBool): ISaldo; safecall;
    function KTrSaldo(WaNr: Integer; IsInHW: WordBool): ISaldo; safecall;
    function Get_Bezeichnung1: WideString; safecall;
    procedure Set_Bezeichnung1(const Value: WideString); safecall;
    function KLRJournal(WiJ: Integer): IKLRJournal; safecall;
    function Get_IsMengePflicht: WordBool; safecall;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property IsLeistung: WordBool read Get_IsLeistung write Set_IsLeistung;
    property IsMengenerfassung: WordBool read Get_IsMengenerfassung;
    property IsBebucht: WordBool read Get_IsBebucht;
    property Bezeichnung1: WideString read Get_Bezeichnung1 write Set_Bezeichnung1;
    property IsMengePflicht: WordBool read Get_IsMengePflicht;
  end;

// *********************************************************************//
// DispIntf:  IKostenartDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B8AA063F-0902-48B5-9DFD-1F28EF9FF9EC}
// *********************************************************************//
  IKostenartDisp = dispinterface
    ['{B8AA063F-0902-48B5-9DFD-1F28EF9FF9EC}']
    function Navigate: INavigate; dispid 1;
    property Nummer: Integer dispid 2;
    property Bezeichnung: WideString dispid 3;
    property IsLeistung: WordBool dispid 4;
    property IsMengenerfassung: WordBool readonly dispid 5;
    property IsBebucht: WordBool readonly dispid 6;
    function KStSaldo(WaNr: Integer; IsInHW: WordBool): ISaldo; dispid 7;
    function KTrSaldo(WaNr: Integer; IsInHW: WordBool): ISaldo; dispid 8;
    property Bezeichnung1: WideString dispid 9;
    function KLRJournal(WiJ: Integer): IKLRJournal; dispid 201;
    property IsMengePflicht: WordBool readonly dispid 202;
  end;

// *********************************************************************//
// Interface: IKostenstelle
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92DAE5A4-DCB5-497A-B729-838FD8284E3C}
// *********************************************************************//
  IKostenstelle = interface(IDispatch)
    ['{92DAE5A4-DCB5-497A-B729-838FD8284E3C}']
    function Navigate: INavigate; safecall;
    function Get_Nummer: Integer; safecall;
    procedure Set_Nummer(Value: Integer); safecall;
    function Get_Bezeichnung(Nr: Integer): WideString; safecall;
    procedure Set_Bezeichnung(Nr: Integer; const Value: WideString); safecall;
    function Get_Bezeichnung1: WideString; safecall;
    procedure Set_Bezeichnung1(const Value: WideString); safecall;
    function Get_Bezeichnung2: WideString; safecall;
    procedure Set_Bezeichnung2(const Value: WideString); safecall;
    function Get_Bezeichnung3: WideString; safecall;
    procedure Set_Bezeichnung3(const Value: WideString); safecall;
    function Get_KurzBez: WideString; safecall;
    procedure Set_KurzBez(const Value: WideString); safecall;
    function Get_IsHaupt: WordBool; safecall;
    procedure Set_IsHaupt(Value: WordBool); safecall;
    function Get_FixVar: Integer; safecall;
    procedure Set_FixVar(Value: Integer); safecall;
    function Get_IsAskFixVar: WordBool; safecall;
    procedure Set_IsAskFixVar(Value: WordBool); safecall;
    function Gruppe(Nr: Integer): IGruppe; safecall;
    function Planmenge(Nr: Integer): IPlanmenge; safecall;
    function Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo; safecall;
    function Get_IsBebucht: WordBool; safecall;
    function GrpNummer(Nr: Integer): Integer; safecall;
    function Get_SperreTyp: Integer; safecall;
    function Get_SperrFreiDatumVon: TDateTime; safecall;
    function Get_SperrFreiDatumBis: TDateTime; safecall;
    function KLRJournal(WiJ: Integer): IKLRJournal; safecall;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung[Nr: Integer]: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property Bezeichnung1: WideString read Get_Bezeichnung1 write Set_Bezeichnung1;
    property Bezeichnung2: WideString read Get_Bezeichnung2 write Set_Bezeichnung2;
    property Bezeichnung3: WideString read Get_Bezeichnung3 write Set_Bezeichnung3;
    property KurzBez: WideString read Get_KurzBez write Set_KurzBez;
    property IsHaupt: WordBool read Get_IsHaupt write Set_IsHaupt;
    property FixVar: Integer read Get_FixVar write Set_FixVar;
    property IsAskFixVar: WordBool read Get_IsAskFixVar write Set_IsAskFixVar;
    property IsBebucht: WordBool read Get_IsBebucht;
    property SperreTyp: Integer read Get_SperreTyp;
    property SperrFreiDatumVon: TDateTime read Get_SperrFreiDatumVon;
    property SperrFreiDatumBis: TDateTime read Get_SperrFreiDatumBis;
  end;

// *********************************************************************//
// DispIntf:  IKostenstelleDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92DAE5A4-DCB5-497A-B729-838FD8284E3C}
// *********************************************************************//
  IKostenstelleDisp = dispinterface
    ['{92DAE5A4-DCB5-497A-B729-838FD8284E3C}']
    function Navigate: INavigate; dispid 1;
    property Nummer: Integer dispid 2;
    property Bezeichnung[Nr: Integer]: WideString dispid 3;
    property Bezeichnung1: WideString dispid 4;
    property Bezeichnung2: WideString dispid 5;
    property Bezeichnung3: WideString dispid 6;
    property KurzBez: WideString dispid 7;
    property IsHaupt: WordBool dispid 8;
    property FixVar: Integer dispid 9;
    property IsAskFixVar: WordBool dispid 10;
    function Gruppe(Nr: Integer): IGruppe; dispid 11;
    function Planmenge(Nr: Integer): IPlanmenge; dispid 12;
    function Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo; dispid 13;
    property IsBebucht: WordBool readonly dispid 14;
    function GrpNummer(Nr: Integer): Integer; dispid 16;
    property SperreTyp: Integer readonly dispid 201;
    property SperrFreiDatumVon: TDateTime readonly dispid 202;
    property SperrFreiDatumBis: TDateTime readonly dispid 203;
    function KLRJournal(WiJ: Integer): IKLRJournal; dispid 204;
  end;

// *********************************************************************//
// Interface: IBezugsgroesse
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2DBE782A-A5FE-471D-AD3C-91216B4C7376}
// *********************************************************************//
  IBezugsgroesse = interface(IDispatch)
    ['{2DBE782A-A5FE-471D-AD3C-91216B4C7376}']
    function Get_Nummer: Integer; safecall;
    procedure Set_Nummer(Value: Integer); safecall;
    function Get_Bezeichnung: WideString; safecall;
    procedure Set_Bezeichnung(const Value: WideString); safecall;
    function Get_KurzBez: WideString; safecall;
    procedure Set_KurzBez(const Value: WideString); safecall;
    function Get_Nachkomma: Integer; safecall;
    procedure Set_Nachkomma(Value: Integer); safecall;
    function Get_BGTyp: Integer; safecall;
    procedure Set_BGTyp(Value: Integer); safecall;
    function Navigate: INavigate; safecall;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property KurzBez: WideString read Get_KurzBez write Set_KurzBez;
    property Nachkomma: Integer read Get_Nachkomma write Set_Nachkomma;
    property BGTyp: Integer read Get_BGTyp write Set_BGTyp;
  end;

// *********************************************************************//
// DispIntf:  IBezugsgroesseDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2DBE782A-A5FE-471D-AD3C-91216B4C7376}
// *********************************************************************//
  IBezugsgroesseDisp = dispinterface
    ['{2DBE782A-A5FE-471D-AD3C-91216B4C7376}']
    property Nummer: Integer dispid 1;
    property Bezeichnung: WideString dispid 2;
    property KurzBez: WideString dispid 3;
    property Nachkomma: Integer dispid 4;
    property BGTyp: Integer dispid 5;
    function Navigate: INavigate; dispid 6;
  end;

// *********************************************************************//
// Interface: IPlanmenge
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {76F18D94-865F-4667-B88C-027CC0F7AE7A}
// *********************************************************************//
  IPlanmenge = interface(IDispatch)
    ['{76F18D94-865F-4667-B88C-027CC0F7AE7A}']
    function Bezugsgroesse: IBezugsgroesse; safecall;
    function Get_Wert: Double; safecall;
    procedure Set_Wert(Value: Double); safecall;
    function Get_IsAbfrage: WordBool; safecall;
    procedure Set_IsAbfrage(Value: WordBool); safecall;
    property Wert: Double read Get_Wert write Set_Wert;
    property IsAbfrage: WordBool read Get_IsAbfrage write Set_IsAbfrage;
  end;

// *********************************************************************//
// DispIntf:  IPlanmengeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {76F18D94-865F-4667-B88C-027CC0F7AE7A}
// *********************************************************************//
  IPlanmengeDisp = dispinterface
    ['{76F18D94-865F-4667-B88C-027CC0F7AE7A}']
    function Bezugsgroesse: IBezugsgroesse; dispid 1;
    property Wert: Double dispid 2;
    property IsAbfrage: WordBool dispid 3;
  end;

// *********************************************************************//
// Interface: IUSt
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {80C79C66-0713-45D8-9999-8FE3C5525FBD}
// *********************************************************************//
  IUSt = interface(IDispatch)
    ['{80C79C66-0713-45D8-9999-8FE3C5525FBD}']
    function Get_Art: EUStArten; safecall;
    procedure Set_Art(Value: EUStArten); safecall;
    function Get_ArtMV: WideString; safecall;
    procedure Set_ArtMV(const Value: WideString); safecall;
    function Steuer: ISteuer; safecall;
    function AsRecord: RUSt; safecall;
    function Get_Schluessel: Integer; safecall;
    function Get_IsAnzahlung: WordBool; safecall;
    property Art: EUStArten read Get_Art write Set_Art;
    property ArtMV: WideString read Get_ArtMV write Set_ArtMV;
    property Schluessel: Integer read Get_Schluessel;
    property IsAnzahlung: WordBool read Get_IsAnzahlung;
  end;

// *********************************************************************//
// DispIntf:  IUStDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {80C79C66-0713-45D8-9999-8FE3C5525FBD}
// *********************************************************************//
  IUStDisp = dispinterface
    ['{80C79C66-0713-45D8-9999-8FE3C5525FBD}']
    property Art: EUStArten dispid 1;
    property ArtMV: WideString dispid 2;
    function Steuer: ISteuer; dispid 4;
    function AsRecord: {NOT_OLEAUTO(RUSt)}OleVariant; dispid 3;
    property Schluessel: Integer readonly dispid 5;
    property IsAnzahlung: WordBool readonly dispid 6;
  end;

// *********************************************************************//
// Interface: IKurs
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8CB1660A-7274-4A68-8EBC-22D8A0388E6B}
// *********************************************************************//
  IKurs = interface(IDispatch)
    ['{8CB1660A-7274-4A68-8EBC-22D8A0388E6B}']
    function Waehrung: IWaehrung; safecall;
    function Get_Basis: Integer; safecall;
    procedure Set_Basis(Value: Integer); safecall;
    function Get_Tageskurs: Double; safecall;
    procedure Set_Tageskurs(Value: Double); safecall;
    function Get_Waehrungsbetrag: Currency; safecall;
    procedure Set_Waehrungsbetrag(Value: Currency); safecall;
    function AsRecord: RKurs; safecall;
    function Get_Waehrungsnummer: Integer; safecall;
    property Basis: Integer read Get_Basis write Set_Basis;
    property Tageskurs: Double read Get_Tageskurs write Set_Tageskurs;
    property Waehrungsbetrag: Currency read Get_Waehrungsbetrag write Set_Waehrungsbetrag;
    property Waehrungsnummer: Integer read Get_Waehrungsnummer;
  end;

// *********************************************************************//
// DispIntf:  IKursDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8CB1660A-7274-4A68-8EBC-22D8A0388E6B}
// *********************************************************************//
  IKursDisp = dispinterface
    ['{8CB1660A-7274-4A68-8EBC-22D8A0388E6B}']
    function Waehrung: IWaehrung; dispid 1;
    property Basis: Integer dispid 2;
    property Tageskurs: Double dispid 3;
    property Waehrungsbetrag: Currency dispid 5;
    function AsRecord: {NOT_OLEAUTO(RKurs)}OleVariant; dispid 4;
    property Waehrungsnummer: Integer readonly dispid 6;
  end;

// *********************************************************************//
// Interface: IWaehrung
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7A0623CD-D78E-4584-9B6D-3C57369992B6}
// *********************************************************************//
  IWaehrung = interface(IDispatch)
    ['{7A0623CD-D78E-4584-9B6D-3C57369992B6}']
    function Navigate: INavigate; safecall;
    function Get_Nummer: Integer; safecall;
    procedure Set_Nummer(Value: Integer); safecall;
    function Get_Bezeichnung: WideString; safecall;
    procedure Set_Bezeichnung(const Value: WideString); safecall;
    function Get_ISOBez: WideString; safecall;
    procedure Set_ISOBez(const Value: WideString); safecall;
    function Land: ILand; safecall;
    function Festkonto(Nr: Integer): IFestkonto; safecall;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property ISOBez: WideString read Get_ISOBez write Set_ISOBez;
  end;

// *********************************************************************//
// DispIntf:  IWaehrungDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7A0623CD-D78E-4584-9B6D-3C57369992B6}
// *********************************************************************//
  IWaehrungDisp = dispinterface
    ['{7A0623CD-D78E-4584-9B6D-3C57369992B6}']
    function Navigate: INavigate; dispid 2;
    property Nummer: Integer dispid 1;
    property Bezeichnung: WideString dispid 3;
    property ISOBez: WideString dispid 5;
    function Land: ILand; dispid 6;
    function Festkonto(Nr: Integer): IFestkonto; dispid 7;
  end;

// *********************************************************************//
// Interface: IMahn
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0F6EC919-BF2F-4018-9036-3DACD1D62C57}
// *********************************************************************//
  IMahn = interface(IDispatch)
    ['{0F6EC919-BF2F-4018-9036-3DACD1D62C57}']
    function Get_Mahnstufe: Integer; safecall;
    procedure Set_Mahnstufe(Value: Integer); safecall;
    function Get_Mahndatum: TDateTime; safecall;
    procedure Set_Mahndatum(Value: TDateTime); safecall;
    function Get_IsMahnstop: WordBool; safecall;
    procedure Set_IsMahnstop(Value: WordBool); safecall;
    property Mahnstufe: Integer read Get_Mahnstufe write Set_Mahnstufe;
    property Mahndatum: TDateTime read Get_Mahndatum write Set_Mahndatum;
    property IsMahnstop: WordBool read Get_IsMahnstop write Set_IsMahnstop;
  end;

// *********************************************************************//
// DispIntf:  IMahnDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0F6EC919-BF2F-4018-9036-3DACD1D62C57}
// *********************************************************************//
  IMahnDisp = dispinterface
    ['{0F6EC919-BF2F-4018-9036-3DACD1D62C57}']
    property Mahnstufe: Integer dispid 1;
    property Mahndatum: TDateTime dispid 2;
    property IsMahnstop: WordBool dispid 3;
  end;

// *********************************************************************//
// Interface: IZahlkondition
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {627A486E-3965-4E95-A7E3-E48643BE12AE}
// *********************************************************************//
  IZahlkondition = interface(IDispatch)
    ['{627A486E-3965-4E95-A7E3-E48643BE12AE}']
    function Get_Tage1: Integer; safecall;
    procedure Set_Tage1(Value: Integer); safecall;
    function Get_Skonto1: Single; safecall;
    procedure Set_Skonto1(Value: Single); safecall;
    function Get_Tage2: Integer; safecall;
    procedure Set_Tage2(Value: Integer); safecall;
    function Get_Skonto2: Single; safecall;
    procedure Set_Skonto2(Value: Single); safecall;
    function Get_Nettozahlungsziel: Integer; safecall;
    procedure Set_Nettozahlungsziel(Value: Integer); safecall;
    function AsRecord: RZahlkondition; safecall;
    property Tage1: Integer read Get_Tage1 write Set_Tage1;
    property Skonto1: Single read Get_Skonto1 write Set_Skonto1;
    property Tage2: Integer read Get_Tage2 write Set_Tage2;
    property Skonto2: Single read Get_Skonto2 write Set_Skonto2;
    property Nettozahlungsziel: Integer read Get_Nettozahlungsziel write Set_Nettozahlungsziel;
  end;

// *********************************************************************//
// DispIntf:  IZahlkonditionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {627A486E-3965-4E95-A7E3-E48643BE12AE}
// *********************************************************************//
  IZahlkonditionDisp = dispinterface
    ['{627A486E-3965-4E95-A7E3-E48643BE12AE}']
    property Tage1: Integer dispid 1;
    property Skonto1: Single dispid 2;
    property Tage2: Integer dispid 3;
    property Skonto2: Single dispid 4;
    property Nettozahlungsziel: Integer dispid 5;
    function AsRecord: {NOT_OLEAUTO(RZahlkondition)}OleVariant; dispid 6;
  end;

// *********************************************************************//
// Interface: IFNReport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {790FCD48-C23E-449E-8B32-714965725863}
// *********************************************************************//
  IFNReport = interface(IDispatch)
    ['{790FCD48-C23E-449E-8B32-714965725863}']
    function Taschenrechner(const Ausdruck: WideString): Double; safecall;
    procedure Load(const FrmName: WideString; const Passwort: WideString); safecall;
    procedure Save(const FrmName: WideString); safecall;
    function Get_Formular: OleVariant; safecall;
    procedure Set_Formular(Value: OleVariant); safecall;
    function Get_Formeln: OleVariant; safecall;
    procedure Set_Formeln(Value: OleVariant); safecall;
    function Get_Variable(const VarName: WideString): OleVariant; safecall;
    function Auswerten(Tagesabgrenzung: Integer; IsMVZabgrenzung: WordBool; IsMitStapel: WordBool): WordBool; safecall;
    property Formular: OleVariant read Get_Formular write Set_Formular;
    property Formeln: OleVariant read Get_Formeln write Set_Formeln;
    property Variable[const VarName: WideString]: OleVariant read Get_Variable;
  end;

// *********************************************************************//
// DispIntf:  IFNReportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {790FCD48-C23E-449E-8B32-714965725863}
// *********************************************************************//
  IFNReportDisp = dispinterface
    ['{790FCD48-C23E-449E-8B32-714965725863}']
    function Taschenrechner(const Ausdruck: WideString): Double; dispid 1;
    procedure Load(const FrmName: WideString; const Passwort: WideString); dispid 2;
    procedure Save(const FrmName: WideString); dispid 3;
    property Formular: OleVariant dispid 6;
    property Formeln: OleVariant dispid 7;
    property Variable[const VarName: WideString]: OleVariant readonly dispid 9;
    function Auswerten(Tagesabgrenzung: Integer; IsMVZabgrenzung: WordBool; IsMitStapel: WordBool): WordBool; dispid 10;
  end;

// *********************************************************************//
// Interface: IChooseMandant
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A42D9E77-71E7-4FA9-86A4-03F7E4116461}
// *********************************************************************//
  IChooseMandant = interface(IDispatch)
    ['{A42D9E77-71E7-4FA9-86A4-03F7E4116461}']
    function Navigate: INavigate; safecall;
    function Get_Nummer: Integer; safecall;
    function Get_Bezeichnung: WideString; safecall;
    function Get_aktlWiJahr: Integer; safecall;
    function Get_letzteMonatWiJahr: Integer; safecall;
    function Adresse: IAdresse; safecall;
    function Get_Bankleitzahl: Integer; safecall;
    function Get_Bankkontonummer: WideString; safecall;
    property Nummer: Integer read Get_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung;
    property aktlWiJahr: Integer read Get_aktlWiJahr;
    property letzteMonatWiJahr: Integer read Get_letzteMonatWiJahr;
    property Bankleitzahl: Integer read Get_Bankleitzahl;
    property Bankkontonummer: WideString read Get_Bankkontonummer;
  end;

// *********************************************************************//
// DispIntf:  IChooseMandantDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A42D9E77-71E7-4FA9-86A4-03F7E4116461}
// *********************************************************************//
  IChooseMandantDisp = dispinterface
    ['{A42D9E77-71E7-4FA9-86A4-03F7E4116461}']
    function Navigate: INavigate; dispid 1;
    property Nummer: Integer readonly dispid 2;
    property Bezeichnung: WideString readonly dispid 3;
    property aktlWiJahr: Integer readonly dispid 5;
    property letzteMonatWiJahr: Integer readonly dispid 6;
    function Adresse: IAdresse; dispid 4;
    property Bankleitzahl: Integer readonly dispid 201;
    property Bankkontonummer: WideString readonly dispid 202;
  end;

// *********************************************************************//
// Interface: IPasswort
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EEB4FA02-617F-4F9C-A83B-510D5699B86E}
// *********************************************************************//
  IPasswort = interface(IDispatch)
    ['{EEB4FA02-617F-4F9C-A83B-510D5699B86E}']
    function PruefeMandant(Mandant: Integer; const Passwort: WideString): WordBool; safecall;
    function SetzeMandant(Mandant: Integer; const Passwort: WideString): WordBool; safecall;
    procedure PruefeReportgenerator; safecall;
    function PruefeAdministrator(const Passwort: WideString): WordBool; safecall;
    procedure PruefeBenutzerverwalter; safecall;
  end;

// *********************************************************************//
// DispIntf:  IPasswortDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EEB4FA02-617F-4F9C-A83B-510D5699B86E}
// *********************************************************************//
  IPasswortDisp = dispinterface
    ['{EEB4FA02-617F-4F9C-A83B-510D5699B86E}']
    function PruefeMandant(Mandant: Integer; const Passwort: WideString): WordBool; dispid 2;
    function SetzeMandant(Mandant: Integer; const Passwort: WideString): WordBool; dispid 3;
    procedure PruefeReportgenerator; dispid 4;
    function PruefeAdministrator(const Passwort: WideString): WordBool; dispid 5;
    procedure PruefeBenutzerverwalter; dispid 6;
  end;

// *********************************************************************//
// Interface: IBuchen
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {08089F0D-B87E-4402-9649-EF3288D8EB81}
// *********************************************************************//
  IBuchen = interface(IDispatch)
    ['{08089F0D-B87E-4402-9649-EF3288D8EB81}']
    function Verarbeiten(const Data: WideString): WideString; safecall;
    function Primanota: WideString; safecall;
    function Hauswaehrung: WideString; safecall;
    procedure Close; safecall;
    function Open(EBJahre: Integer; IsKtlSumBlatt: WordBool; IsSimulation: WordBool; 
                  IsStapel: WordBool): WideString; safecall;
    function Journalzeile: Integer; safecall;
    function AskEBKorrektur: Integer; safecall;
    function Import: IFNImport; safecall;
    function MinMaxDatum(out VonDatum: TDateTime; out BisDatum: TDateTime): WordBool; safecall;
    function Get_MinBuchDatum: TDateTime; safecall;
    function Get_MaxBuchDatum: TDateTime; safecall;
    procedure ClearCmds; safecall;
    function GetCmd(aCmdTyp: ECmdTypen): OleVariant; safecall;
    procedure AddCmd(aCmdClass: OleVariant); safecall;
    function ReadCmds: WideString; safecall;
    function DCZahlung(FileNummer: Integer; Zahldatum: TDateTime; Wertstellungsdatum: TDateTime; 
                       out ErrText: WideString): WordBool; safecall;
    function Get_CmdLogSize: Integer; safecall;
    procedure CmdLogText(AbPosition: Integer; out LogSize: Integer; out LogText: WideString); safecall;
    function CmdDayLogCount: Integer; safecall;
    function CmdDayLogText(FileNr: Integer): WideString; safecall;
    property MinBuchDatum: TDateTime read Get_MinBuchDatum;
    property MaxBuchDatum: TDateTime read Get_MaxBuchDatum;
    property CmdLogSize: Integer read Get_CmdLogSize;
  end;

// *********************************************************************//
// DispIntf:  IBuchenDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {08089F0D-B87E-4402-9649-EF3288D8EB81}
// *********************************************************************//
  IBuchenDisp = dispinterface
    ['{08089F0D-B87E-4402-9649-EF3288D8EB81}']
    function Verarbeiten(const Data: WideString): WideString; dispid 1;
    function Primanota: WideString; dispid 2;
    function Hauswaehrung: WideString; dispid 3;
    procedure Close; dispid 4;
    function Open(EBJahre: Integer; IsKtlSumBlatt: WordBool; IsSimulation: WordBool; 
                  IsStapel: WordBool): WideString; dispid 5;
    function Journalzeile: Integer; dispid 6;
    function AskEBKorrektur: Integer; dispid 7;
    function Import: IFNImport; dispid 8;
    function MinMaxDatum(out VonDatum: TDateTime; out BisDatum: TDateTime): WordBool; dispid 9;
    property MinBuchDatum: TDateTime readonly dispid 10;
    property MaxBuchDatum: TDateTime readonly dispid 11;
    procedure ClearCmds; dispid 12;
    function GetCmd(aCmdTyp: ECmdTypen): OleVariant; dispid 13;
    procedure AddCmd(aCmdClass: OleVariant); dispid 14;
    function ReadCmds: WideString; dispid 15;
    function DCZahlung(FileNummer: Integer; Zahldatum: TDateTime; Wertstellungsdatum: TDateTime; 
                       out ErrText: WideString): WordBool; dispid 16;
    property CmdLogSize: Integer readonly dispid 201;
    procedure CmdLogText(AbPosition: Integer; out LogSize: Integer; out LogText: WideString); dispid 202;
    function CmdDayLogCount: Integer; dispid 203;
    function CmdDayLogText(FileNr: Integer): WideString; dispid 204;
  end;

// *********************************************************************//
// Interface: IKostenstelleart
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B4660F77-9875-4625-BEDA-321EFBD2D2E6}
// *********************************************************************//
  IKostenstelleart = interface(IDispatch)
    ['{B4660F77-9875-4625-BEDA-321EFBD2D2E6}']
    function Navigate: INavigate; safecall;
    function Get_Nummer: Integer; safecall;
    function Get_KostenartNummer: Integer; safecall;
    function Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo; safecall;
    function Get_IsLeistung: WordBool; safecall;
    function Get_IsBebucht: WordBool; safecall;
    function KStKTr: IKostenstelle; safecall;
    function Kostenart: IKostenart; safecall;
    function StTrArtNr(KStTrNr: Integer; KArtNr: Integer): WordBool; safecall;
    function KLRJournal(WiJ: Integer): IKLRJournal; safecall;
    property Nummer: Integer read Get_Nummer;
    property KostenartNummer: Integer read Get_KostenartNummer;
    property IsLeistung: WordBool read Get_IsLeistung;
    property IsBebucht: WordBool read Get_IsBebucht;
  end;

// *********************************************************************//
// DispIntf:  IKostenstelleartDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B4660F77-9875-4625-BEDA-321EFBD2D2E6}
// *********************************************************************//
  IKostenstelleartDisp = dispinterface
    ['{B4660F77-9875-4625-BEDA-321EFBD2D2E6}']
    function Navigate: INavigate; dispid 1;
    property Nummer: Integer readonly dispid 2;
    property KostenartNummer: Integer readonly dispid 3;
    function Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo; dispid 4;
    property IsLeistung: WordBool readonly dispid 5;
    property IsBebucht: WordBool readonly dispid 6;
    function KStKTr: IKostenstelle; dispid 7;
    function Kostenart: IKostenart; dispid 8;
    function StTrArtNr(KStTrNr: Integer; KArtNr: Integer): WordBool; dispid 9;
    function KLRJournal(WiJ: Integer): IKLRJournal; dispid 201;
  end;

// *********************************************************************//
// Interface: IFNImport
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1CC09930-7F41-4001-B2D4-5F4B289E1261}
// *********************************************************************//
  IFNImport = interface(IDispatch)
    ['{1CC09930-7F41-4001-B2D4-5F4B289E1261}']
    function Navigate: INavigate; safecall;
    function Get_Name: WideString; safecall;
    function Get_Info: WideString; safecall;
    function Get_Datum: TDateTime; safecall;
    function Get_Groesse: Integer; safecall;
    function SaveToFile(const Filename: WideString; const Text: WideString; Overwrite: WordBool; 
                        const Adminpasswort: WideString): WordBool; safecall;
    function DeleteFile(const Filename: WideString): WordBool; safecall;
    function Executefile(const Filename: WideString): Integer; safecall;
    function LoadFromFile(const Filename: WideString): WideString; safecall;
    property Name: WideString read Get_Name;
    property Info: WideString read Get_Info;
    property Datum: TDateTime read Get_Datum;
    property Groesse: Integer read Get_Groesse;
  end;

// *********************************************************************//
// DispIntf:  IFNImportDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1CC09930-7F41-4001-B2D4-5F4B289E1261}
// *********************************************************************//
  IFNImportDisp = dispinterface
    ['{1CC09930-7F41-4001-B2D4-5F4B289E1261}']
    function Navigate: INavigate; dispid 1;
    property Name: WideString readonly dispid 2;
    property Info: WideString readonly dispid 3;
    property Datum: TDateTime readonly dispid 4;
    property Groesse: Integer readonly dispid 6;
    function SaveToFile(const Filename: WideString; const Text: WideString; Overwrite: WordBool; 
                        const Adminpasswort: WideString): WordBool; dispid 8;
    function DeleteFile(const Filename: WideString): WordBool; dispid 9;
    function Executefile(const Filename: WideString): Integer; dispid 10;
    function LoadFromFile(const Filename: WideString): WideString; dispid 11;
  end;

// *********************************************************************//
// Interface: IREB
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F83A8A9-142D-4657-BCED-270B0D922303}
// *********************************************************************//
  IREB = interface(IDispatch)
    ['{7F83A8A9-142D-4657-BCED-270B0D922303}']
    function Navigate: INavigate; safecall;
    function Kontierung: IKontierung; safecall;
    function USt: IUSt; safecall;
    function Get_Sachbearbeiter: WideString; safecall;
    function Get_Valutadatum: TDateTime; safecall;
    function Get_Skontofaktor: Double; safecall;
    function Kurs: IKurs; safecall;
    function Get_Zahlart: EZahlarten; safecall;
    function Zahlkondition: IZahlkondition; safecall;
    function Get_ExportID: Integer; safecall;
    function Get_FreiUserName: WideString; safecall;
    function Get_FreiUserDatum: TDateTime; safecall;
    function Get_BuchUserName: WideString; safecall;
    property Sachbearbeiter: WideString read Get_Sachbearbeiter;
    property Valutadatum: TDateTime read Get_Valutadatum;
    property Skontofaktor: Double read Get_Skontofaktor;
    property Zahlart: EZahlarten read Get_Zahlart;
    property ExportID: Integer read Get_ExportID;
    property FreiUserName: WideString read Get_FreiUserName;
    property FreiUserDatum: TDateTime read Get_FreiUserDatum;
    property BuchUserName: WideString read Get_BuchUserName;
  end;

// *********************************************************************//
// DispIntf:  IREBDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {7F83A8A9-142D-4657-BCED-270B0D922303}
// *********************************************************************//
  IREBDisp = dispinterface
    ['{7F83A8A9-142D-4657-BCED-270B0D922303}']
    function Navigate: INavigate; dispid 1;
    function Kontierung: IKontierung; dispid 2;
    function USt: IUSt; dispid 3;
    property Sachbearbeiter: WideString readonly dispid 4;
    property Valutadatum: TDateTime readonly dispid 5;
    property Skontofaktor: Double readonly dispid 6;
    function Kurs: IKurs; dispid 7;
    property Zahlart: EZahlarten readonly dispid 8;
    function Zahlkondition: IZahlkondition; dispid 9;
    property ExportID: Integer readonly dispid 11;
    property FreiUserName: WideString readonly dispid 12;
    property FreiUserDatum: TDateTime readonly dispid 13;
    property BuchUserName: WideString readonly dispid 14;
  end;

// *********************************************************************//
// Interface: IOrt
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0D547D43-D232-4538-A1F8-BE47F281D4BE}
// *********************************************************************//
  IOrt = interface(IDispatch)
    ['{0D547D43-D232-4538-A1F8-BE47F281D4BE}']
    function Get_PLZ: Integer; safecall;
    procedure Set_PLZ(Value: Integer); safecall;
    function Get_Bezeichnung: WideString; safecall;
    function Navigate: INavigate; safecall;
    property PLZ: Integer read Get_PLZ write Set_PLZ;
    property Bezeichnung: WideString read Get_Bezeichnung;
  end;

// *********************************************************************//
// DispIntf:  IOrtDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0D547D43-D232-4538-A1F8-BE47F281D4BE}
// *********************************************************************//
  IOrtDisp = dispinterface
    ['{0D547D43-D232-4538-A1F8-BE47F281D4BE}']
    property PLZ: Integer dispid 1;
    property Bezeichnung: WideString readonly dispid 2;
    function Navigate: INavigate; dispid 3;
  end;

// *********************************************************************//
// Interface: ILizenz
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C8017AD3-C3CE-473C-994C-2AF4553D644B}
// *********************************************************************//
  ILizenz = interface(IDispatch)
    ['{C8017AD3-C3CE-473C-994C-2AF4553D644B}']
    function Get_SerNr: Integer; safecall;
    function Get_HdlNr: Integer; safecall;
    function Get_CodeFrist: Integer; safecall;
    function Get_Erstelldatum: TDateTime; safecall;
    function Get_AnzMandanten: Integer; safecall;
    function Get_AnzBankBew: Integer; safecall;
    function Get_AnzStationen: Integer; safecall;
    function Get_Lizenztext: WideString; safecall;
    function Get_IsDemoversion: WordBool; safecall;
    function Get_Versionsnummer: Integer; safecall;
    function Get_Modul(modTyp: EModule): WordBool; safecall;
    function Get_Modulbezeichnung(modTyp: EModule): WideString; safecall;
    function Get_ModulNutzbarBis(modTyp: EModule): TDateTime; safecall;
    function Get_AnzBIGStationen: Integer; safecall;
    function Get_webREBUser: Integer; safecall;
    function Get_webREBWorkflow: Integer; safecall;
    property SerNr: Integer read Get_SerNr;
    property HdlNr: Integer read Get_HdlNr;
    property CodeFrist: Integer read Get_CodeFrist;
    property Erstelldatum: TDateTime read Get_Erstelldatum;
    property AnzMandanten: Integer read Get_AnzMandanten;
    property AnzBankBew: Integer read Get_AnzBankBew;
    property AnzStationen: Integer read Get_AnzStationen;
    property Lizenztext: WideString read Get_Lizenztext;
    property IsDemoversion: WordBool read Get_IsDemoversion;
    property Versionsnummer: Integer read Get_Versionsnummer;
    property Modul[modTyp: EModule]: WordBool read Get_Modul;
    property Modulbezeichnung[modTyp: EModule]: WideString read Get_Modulbezeichnung;
    property ModulNutzbarBis[modTyp: EModule]: TDateTime read Get_ModulNutzbarBis;
    property AnzBIGStationen: Integer read Get_AnzBIGStationen;
    property webREBUser: Integer read Get_webREBUser;
    property webREBWorkflow: Integer read Get_webREBWorkflow;
  end;

// *********************************************************************//
// DispIntf:  ILizenzDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C8017AD3-C3CE-473C-994C-2AF4553D644B}
// *********************************************************************//
  ILizenzDisp = dispinterface
    ['{C8017AD3-C3CE-473C-994C-2AF4553D644B}']
    property SerNr: Integer readonly dispid 1;
    property HdlNr: Integer readonly dispid 2;
    property CodeFrist: Integer readonly dispid 3;
    property Erstelldatum: TDateTime readonly dispid 4;
    property AnzMandanten: Integer readonly dispid 5;
    property AnzBankBew: Integer readonly dispid 6;
    property AnzStationen: Integer readonly dispid 7;
    property Lizenztext: WideString readonly dispid 8;
    property IsDemoversion: WordBool readonly dispid 9;
    property Versionsnummer: Integer readonly dispid 10;
    property Modul[modTyp: EModule]: WordBool readonly dispid 15;
    property Modulbezeichnung[modTyp: EModule]: WideString readonly dispid 17;
    property ModulNutzbarBis[modTyp: EModule]: TDateTime readonly dispid 18;
    property AnzBIGStationen: Integer readonly dispid 11;
    property webREBUser: Integer readonly dispid 201;
    property webREBWorkflow: Integer readonly dispid 202;
  end;

// *********************************************************************//
// Interface: ICmdBuchen
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CD7D8E7E-4765-4556-9746-7280DE64FE5E}
// *********************************************************************//
  ICmdBuchen = interface(IDispatch)
    ['{CD7D8E7E-4765-4556-9746-7280DE64FE5E}']
    function Get_CmdTyp: ECmdTypen; safecall;
    procedure Clear; safecall;
    function Get_AsString: WideString; safecall;
    function Get_Betrag: Currency; safecall;
    procedure Set_Betrag(Value: Currency); safecall;
    function Get_Konto: Integer; safecall;
    procedure Set_Konto(Value: Integer); safecall;
    function Get_UStArt: EUStArten; safecall;
    procedure Set_UStArt(Value: EUStArten); safecall;
    function Get_UStSchl: Integer; safecall;
    procedure Set_UStSchl(Value: Integer); safecall;
    function Get_GegKonto: Integer; safecall;
    procedure Set_GegKonto(Value: Integer); safecall;
    function Get_GegUStArt: EUStArten; safecall;
    procedure Set_GegUStArt(Value: EUStArten); safecall;
    function Get_GegUStSchl: Integer; safecall;
    procedure Set_GegUStSchl(Value: Integer); safecall;
    function Get_Belegnummer1: WideString; safecall;
    procedure Set_Belegnummer1(const Value: WideString); safecall;
    function Get_Belegnummer2: WideString; safecall;
    procedure Set_Belegnummer2(const Value: WideString); safecall;
    function Get_Buchtext: WideString; safecall;
    procedure Set_Buchtext(const Value: WideString); safecall;
    function Get_Belegdatum: TDateTime; safecall;
    procedure Set_Belegdatum(Value: TDateTime); safecall;
    function Get_Valutadatum: TDateTime; safecall;
    procedure Set_Valutadatum(Value: TDateTime); safecall;
    function Get_Zahlart: EZahlarten; safecall;
    procedure Set_Zahlart(Value: EZahlarten); safecall;
    function Get_Zahlkonditionen: IZahlkondition; safecall;
    procedure Set_Zahlkonditionen(const Value: IZahlkondition); safecall;
    function Get_Wertstellungsdatum: TDateTime; safecall;
    procedure Set_Wertstellungsdatum(Value: TDateTime); safecall;
    function Get_Reisedatum: TDateTime; safecall;
    procedure Set_Reisedatum(Value: TDateTime); safecall;
    function Get_Waehrung: WideString; safecall;
    procedure Set_Waehrung(const Value: WideString); safecall;
    function Get_Tageskurs: Double; safecall;
    procedure Set_Tageskurs(Value: Double); safecall;
    function Get_Memotext: WideString; safecall;
    procedure Set_Memotext(const Value: WideString); safecall;
    function Get_OpAutomatik: WordBool; safecall;
    procedure Set_OpAutomatik(Value: WordBool); safecall;
    function Get_KLRAutomatik: WordBool; safecall;
    procedure Set_KLRAutomatik(Value: WordBool); safecall;
    function CmdPosten(Konto: Integer): ICmdPosten; safecall;
    function CmdKLR(Konto: Integer): ICmdKLR; safecall;
    function Get_UStSatz: Double; safecall;
    procedure Set_UStSatz(Value: Double); safecall;
    function Get_GegUStSatz: Double; safecall;
    procedure Set_GegUStSatz(Value: Double); safecall;
    property CmdTyp: ECmdTypen read Get_CmdTyp;
    property AsString: WideString read Get_AsString;
    property Betrag: Currency read Get_Betrag write Set_Betrag;
    property Konto: Integer read Get_Konto write Set_Konto;
    property UStArt: EUStArten read Get_UStArt write Set_UStArt;
    property UStSchl: Integer read Get_UStSchl write Set_UStSchl;
    property GegKonto: Integer read Get_GegKonto write Set_GegKonto;
    property GegUStArt: EUStArten read Get_GegUStArt write Set_GegUStArt;
    property GegUStSchl: Integer read Get_GegUStSchl write Set_GegUStSchl;
    property Belegnummer1: WideString read Get_Belegnummer1 write Set_Belegnummer1;
    property Belegnummer2: WideString read Get_Belegnummer2 write Set_Belegnummer2;
    property Buchtext: WideString read Get_Buchtext write Set_Buchtext;
    property Belegdatum: TDateTime read Get_Belegdatum write Set_Belegdatum;
    property Valutadatum: TDateTime read Get_Valutadatum write Set_Valutadatum;
    property Zahlart: EZahlarten read Get_Zahlart write Set_Zahlart;
    property Zahlkonditionen: IZahlkondition read Get_Zahlkonditionen write Set_Zahlkonditionen;
    property Wertstellungsdatum: TDateTime read Get_Wertstellungsdatum write Set_Wertstellungsdatum;
    property Reisedatum: TDateTime read Get_Reisedatum write Set_Reisedatum;
    property Waehrung: WideString read Get_Waehrung write Set_Waehrung;
    property Tageskurs: Double read Get_Tageskurs write Set_Tageskurs;
    property Memotext: WideString read Get_Memotext write Set_Memotext;
    property OpAutomatik: WordBool read Get_OpAutomatik write Set_OpAutomatik;
    property KLRAutomatik: WordBool read Get_KLRAutomatik write Set_KLRAutomatik;
    property UStSatz: Double read Get_UStSatz write Set_UStSatz;
    property GegUStSatz: Double read Get_GegUStSatz write Set_GegUStSatz;
  end;

// *********************************************************************//
// DispIntf:  ICmdBuchenDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CD7D8E7E-4765-4556-9746-7280DE64FE5E}
// *********************************************************************//
  ICmdBuchenDisp = dispinterface
    ['{CD7D8E7E-4765-4556-9746-7280DE64FE5E}']
    property CmdTyp: ECmdTypen readonly dispid 1;
    procedure Clear; dispid 3;
    property AsString: WideString readonly dispid 4;
    property Betrag: Currency dispid 5;
    property Konto: Integer dispid 6;
    property UStArt: EUStArten dispid 7;
    property UStSchl: Integer dispid 8;
    property GegKonto: Integer dispid 9;
    property GegUStArt: EUStArten dispid 10;
    property GegUStSchl: Integer dispid 11;
    property Belegnummer1: WideString dispid 12;
    property Belegnummer2: WideString dispid 13;
    property Buchtext: WideString dispid 14;
    property Belegdatum: TDateTime dispid 15;
    property Valutadatum: TDateTime dispid 16;
    property Zahlart: EZahlarten dispid 17;
    property Zahlkonditionen: IZahlkondition dispid 18;
    property Wertstellungsdatum: TDateTime dispid 2;
    property Reisedatum: TDateTime dispid 19;
    property Waehrung: WideString dispid 20;
    property Tageskurs: Double dispid 21;
    property Memotext: WideString dispid 22;
    property OpAutomatik: WordBool dispid 23;
    property KLRAutomatik: WordBool dispid 24;
    function CmdPosten(Konto: Integer): ICmdPosten; dispid 25;
    function CmdKLR(Konto: Integer): ICmdKLR; dispid 26;
    property UStSatz: Double dispid 27;
    property GegUStSatz: Double dispid 28;
  end;

// *********************************************************************//
// Interface: ICmdPosten
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9780F9D4-24F1-453D-A396-04A52AB2ED11}
// *********************************************************************//
  ICmdPosten = interface(IDispatch)
    ['{9780F9D4-24F1-453D-A396-04A52AB2ED11}']
    function Get_Betrag: Currency; safecall;
    procedure Set_Betrag(Value: Currency); safecall;
    function Get_OpArt: EOpArten; safecall;
    procedure Set_OpArt(Value: EOpArten); safecall;
    function Get_Konto: Integer; safecall;
    procedure Set_Konto(Value: Integer); safecall;
    function Get_GegKonto: Integer; safecall;
    procedure Set_GegKonto(Value: Integer); safecall;
    function Get_GegUStArt: EUStArten; safecall;
    procedure Set_GegUStArt(Value: EUStArten); safecall;
    function Get_GegUStSchl: Integer; safecall;
    procedure Set_GegUStSchl(Value: Integer); safecall;
    function Get_Belegnummer1: WideString; safecall;
    procedure Set_Belegnummer1(const Value: WideString); safecall;
    function Get_Belegnummer2: WideString; safecall;
    procedure Set_Belegnummer2(const Value: WideString); safecall;
    function Get_Buchtext: WideString; safecall;
    procedure Set_Buchtext(const Value: WideString); safecall;
    function Get_Belegdatum: TDateTime; safecall;
    procedure Set_Belegdatum(Value: TDateTime); safecall;
    function Get_Valutadatum: TDateTime; safecall;
    procedure Set_Valutadatum(Value: TDateTime); safecall;
    function Get_Zahlart: EZahlarten; safecall;
    procedure Set_Zahlart(Value: EZahlarten); safecall;
    function Get_Zahlkonditionen: IZahlkondition; safecall;
    function Get_Wechsel: Integer; safecall;
    procedure Set_Wechsel(Value: Integer); safecall;
    function Get_Skontofaehig: Currency; safecall;
    procedure Set_Skontofaehig(Value: Currency); safecall;
    function Get_Skontobetrag: Currency; safecall;
    procedure Set_Skontobetrag(Value: Currency); safecall;
    function Get_Zugeordnet: Integer; safecall;
    procedure Set_Zugeordnet(Value: Integer); safecall;
    function Get_Memotext: WideString; safecall;
    procedure Set_Memotext(const Value: WideString); safecall;
    function Get_CmdTyp: ECmdTypen; safecall;
    procedure Clear; safecall;
    function Get_AsString: WideString; safecall;
    property Betrag: Currency read Get_Betrag write Set_Betrag;
    property OpArt: EOpArten read Get_OpArt write Set_OpArt;
    property Konto: Integer read Get_Konto write Set_Konto;
    property GegKonto: Integer read Get_GegKonto write Set_GegKonto;
    property GegUStArt: EUStArten read Get_GegUStArt write Set_GegUStArt;
    property GegUStSchl: Integer read Get_GegUStSchl write Set_GegUStSchl;
    property Belegnummer1: WideString read Get_Belegnummer1 write Set_Belegnummer1;
    property Belegnummer2: WideString read Get_Belegnummer2 write Set_Belegnummer2;
    property Buchtext: WideString read Get_Buchtext write Set_Buchtext;
    property Belegdatum: TDateTime read Get_Belegdatum write Set_Belegdatum;
    property Valutadatum: TDateTime read Get_Valutadatum write Set_Valutadatum;
    property Zahlart: EZahlarten read Get_Zahlart write Set_Zahlart;
    property Zahlkonditionen: IZahlkondition read Get_Zahlkonditionen;
    property Wechsel: Integer read Get_Wechsel write Set_Wechsel;
    property Skontofaehig: Currency read Get_Skontofaehig write Set_Skontofaehig;
    property Skontobetrag: Currency read Get_Skontobetrag write Set_Skontobetrag;
    property Zugeordnet: Integer read Get_Zugeordnet write Set_Zugeordnet;
    property Memotext: WideString read Get_Memotext write Set_Memotext;
    property CmdTyp: ECmdTypen read Get_CmdTyp;
    property AsString: WideString read Get_AsString;
  end;

// *********************************************************************//
// DispIntf:  ICmdPostenDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9780F9D4-24F1-453D-A396-04A52AB2ED11}
// *********************************************************************//
  ICmdPostenDisp = dispinterface
    ['{9780F9D4-24F1-453D-A396-04A52AB2ED11}']
    property Betrag: Currency dispid 1;
    property OpArt: EOpArten dispid 2;
    property Konto: Integer dispid 3;
    property GegKonto: Integer dispid 4;
    property GegUStArt: EUStArten dispid 5;
    property GegUStSchl: Integer dispid 6;
    property Belegnummer1: WideString dispid 7;
    property Belegnummer2: WideString dispid 8;
    property Buchtext: WideString dispid 9;
    property Belegdatum: TDateTime dispid 10;
    property Valutadatum: TDateTime dispid 11;
    property Zahlart: EZahlarten dispid 12;
    property Zahlkonditionen: IZahlkondition readonly dispid 14;
    property Wechsel: Integer dispid 15;
    property Skontofaehig: Currency dispid 16;
    property Skontobetrag: Currency dispid 17;
    property Zugeordnet: Integer dispid 19;
    property Memotext: WideString dispid 20;
    property CmdTyp: ECmdTypen readonly dispid 22;
    procedure Clear; dispid 23;
    property AsString: WideString readonly dispid 24;
  end;

// *********************************************************************//
// Interface: ICmdKLR
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F8580485-4A78-49C2-9766-C4BD6A49C3DB}
// *********************************************************************//
  ICmdKLR = interface(IDispatch)
    ['{F8580485-4A78-49C2-9766-C4BD6A49C3DB}']
    function Get_CmdTyp: ECmdTypen; safecall;
    procedure Clear; safecall;
    function Get_AsString: WideString; safecall;
    function Get_Betrag: Currency; safecall;
    procedure Set_Betrag(Value: Currency); safecall;
    function Get_FixVar: EKostentypen; safecall;
    procedure Set_FixVar(Value: EKostentypen); safecall;
    function Get_Kostenstelle: Integer; safecall;
    procedure Set_Kostenstelle(Value: Integer); safecall;
    function Get_Kostentraeger: Integer; safecall;
    procedure Set_Kostentraeger(Value: Integer); safecall;
    function Get_Kostenart: Integer; safecall;
    procedure Set_Kostenart(Value: Integer); safecall;
    function Get_Sachkonto: Integer; safecall;
    procedure Set_Sachkonto(Value: Integer); safecall;
    function Get_SolHab: Integer; safecall;
    procedure Set_SolHab(Value: Integer); safecall;
    function Get_GegKonto: Integer; safecall;
    procedure Set_GegKonto(Value: Integer); safecall;
    function Get_Belegnummer1: WideString; safecall;
    procedure Set_Belegnummer1(const Value: WideString); safecall;
    function Get_Belegnummer2: WideString; safecall;
    procedure Set_Belegnummer2(const Value: WideString); safecall;
    function Get_Buchtext: WideString; safecall;
    procedure Set_Buchtext(const Value: WideString); safecall;
    function Get_Belegdatum: TDateTime; safecall;
    procedure Set_Belegdatum(Value: TDateTime); safecall;
    function Get_Art: Integer; safecall;
    procedure Set_Art(Value: Integer); safecall;
    function Get_Gruppe: Integer; safecall;
    procedure Set_Gruppe(Value: Integer); safecall;
    property CmdTyp: ECmdTypen read Get_CmdTyp;
    property AsString: WideString read Get_AsString;
    property Betrag: Currency read Get_Betrag write Set_Betrag;
    property FixVar: EKostentypen read Get_FixVar write Set_FixVar;
    property Kostenstelle: Integer read Get_Kostenstelle write Set_Kostenstelle;
    property Kostentraeger: Integer read Get_Kostentraeger write Set_Kostentraeger;
    property Kostenart: Integer read Get_Kostenart write Set_Kostenart;
    property Sachkonto: Integer read Get_Sachkonto write Set_Sachkonto;
    property SolHab: Integer read Get_SolHab write Set_SolHab;
    property GegKonto: Integer read Get_GegKonto write Set_GegKonto;
    property Belegnummer1: WideString read Get_Belegnummer1 write Set_Belegnummer1;
    property Belegnummer2: WideString read Get_Belegnummer2 write Set_Belegnummer2;
    property Buchtext: WideString read Get_Buchtext write Set_Buchtext;
    property Belegdatum: TDateTime read Get_Belegdatum write Set_Belegdatum;
    property Art: Integer read Get_Art write Set_Art;
    property Gruppe: Integer read Get_Gruppe write Set_Gruppe;
  end;

// *********************************************************************//
// DispIntf:  ICmdKLRDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F8580485-4A78-49C2-9766-C4BD6A49C3DB}
// *********************************************************************//
  ICmdKLRDisp = dispinterface
    ['{F8580485-4A78-49C2-9766-C4BD6A49C3DB}']
    property CmdTyp: ECmdTypen readonly dispid 1;
    procedure Clear; dispid 2;
    property AsString: WideString readonly dispid 3;
    property Betrag: Currency dispid 4;
    property FixVar: EKostentypen dispid 5;
    property Kostenstelle: Integer dispid 6;
    property Kostentraeger: Integer dispid 7;
    property Kostenart: Integer dispid 8;
    property Sachkonto: Integer dispid 9;
    property SolHab: Integer dispid 10;
    property GegKonto: Integer dispid 11;
    property Belegnummer1: WideString dispid 12;
    property Belegnummer2: WideString dispid 13;
    property Buchtext: WideString dispid 14;
    property Belegdatum: TDateTime dispid 15;
    property Art: Integer dispid 16;
    property Gruppe: Integer dispid 17;
  end;

// *********************************************************************//
// Interface: IKreditversicherung
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E2ECF706-2C7D-481A-A728-604B3D4A83DB}
// *********************************************************************//
  IKreditversicherung = interface(IDispatch)
    ['{E2ECF706-2C7D-481A-A728-604B3D4A83DB}']
    function Get_Limit1: Currency; safecall;
    function Get_Limit2: Currency; safecall;
    function Get_LimitAb: TDateTime; safecall;
    function Get_Typ: Integer; safecall;
    function Get_Ziel: Integer; safecall;
    function Get_Status: Integer; safecall;
    function Get_Nummer: WideString; safecall;
    function Get_VersicherungNr: Integer; safecall;
    function Get_SummeOP: Currency; safecall;
    function Get_SummeWechsel: Currency; safecall;
    function Get_RE_Belegnummer: WideString; safecall;
    function Get_RE_Belegdatum: TDateTime; safecall;
    function Get_RE_Alter: Integer; safecall;
    function Get_IsDubios: WordBool; safecall;
    function Get_IsVerklagt: WordBool; safecall;
    function Get_IsInkasso: WordBool; safecall;
    function Get_IsKonkurs: WordBool; safecall;
    function Get_IsWechsel: WordBool; safecall;
    function Get_InternesLimit: Currency; safecall;
    property Limit1: Currency read Get_Limit1;
    property Limit2: Currency read Get_Limit2;
    property LimitAb: TDateTime read Get_LimitAb;
    property Typ: Integer read Get_Typ;
    property Ziel: Integer read Get_Ziel;
    property Status: Integer read Get_Status;
    property Nummer: WideString read Get_Nummer;
    property VersicherungNr: Integer read Get_VersicherungNr;
    property SummeOP: Currency read Get_SummeOP;
    property SummeWechsel: Currency read Get_SummeWechsel;
    property RE_Belegnummer: WideString read Get_RE_Belegnummer;
    property RE_Belegdatum: TDateTime read Get_RE_Belegdatum;
    property RE_Alter: Integer read Get_RE_Alter;
    property IsDubios: WordBool read Get_IsDubios;
    property IsVerklagt: WordBool read Get_IsVerklagt;
    property IsInkasso: WordBool read Get_IsInkasso;
    property IsKonkurs: WordBool read Get_IsKonkurs;
    property IsWechsel: WordBool read Get_IsWechsel;
    property InternesLimit: Currency read Get_InternesLimit;
  end;

// *********************************************************************//
// DispIntf:  IKreditversicherungDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E2ECF706-2C7D-481A-A728-604B3D4A83DB}
// *********************************************************************//
  IKreditversicherungDisp = dispinterface
    ['{E2ECF706-2C7D-481A-A728-604B3D4A83DB}']
    property Limit1: Currency readonly dispid 1;
    property Limit2: Currency readonly dispid 2;
    property LimitAb: TDateTime readonly dispid 4;
    property Typ: Integer readonly dispid 5;
    property Ziel: Integer readonly dispid 6;
    property Status: Integer readonly dispid 7;
    property Nummer: WideString readonly dispid 8;
    property VersicherungNr: Integer readonly dispid 9;
    property SummeOP: Currency readonly dispid 201;
    property SummeWechsel: Currency readonly dispid 202;
    property RE_Belegnummer: WideString readonly dispid 203;
    property RE_Belegdatum: TDateTime readonly dispid 204;
    property RE_Alter: Integer readonly dispid 205;
    property IsDubios: WordBool readonly dispid 206;
    property IsVerklagt: WordBool readonly dispid 207;
    property IsInkasso: WordBool readonly dispid 208;
    property IsKonkurs: WordBool readonly dispid 209;
    property IsWechsel: WordBool readonly dispid 210;
    property InternesLimit: Currency readonly dispid 211;
  end;

// *********************************************************************//
// Interface: IArchiv
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8A5D903D-8898-4A58-AE69-0E767BE5F576}
// *********************************************************************//
  IArchiv = interface(IDispatch)
    ['{8A5D903D-8898-4A58-AE69-0E767BE5F576}']
    function Navigate: INavigate; safecall;
    function Get_Mandant: Integer; safecall;
    function Get_Wirtschaftsjahr: Integer; safecall;
    function Get_Journalzeile: Integer; safecall;
    function Get_Barcode: WideString; safecall;
    function Get_Buchdatum: TDateTime; safecall;
    function Get_Konto: Integer; safecall;
    function Get_GegKonto: Integer; safecall;
    function Get_Betrag: Currency; safecall;
    function Get_Belegdatum: TDateTime; safecall;
    function Get_Belegnummer1: WideString; safecall;
    function Get_Belegnummer2: WideString; safecall;
    function Get_Buchtext: WideString; safecall;
    function Get_DokumentID: WideString; safecall;
    function Get_Waehrungsbetrag: Currency; safecall;
    function Get_Waehrungskurs: Double; safecall;
    function Get_Memotext: WideString; safecall;
    function Get_Benutzer: WideString; safecall;
    function Get_FullBarcode: WideString; safecall;
    function Get_BarcodeJahr: Integer; safecall;
    property Mandant: Integer read Get_Mandant;
    property Wirtschaftsjahr: Integer read Get_Wirtschaftsjahr;
    property Journalzeile: Integer read Get_Journalzeile;
    property Barcode: WideString read Get_Barcode;
    property Buchdatum: TDateTime read Get_Buchdatum;
    property Konto: Integer read Get_Konto;
    property GegKonto: Integer read Get_GegKonto;
    property Betrag: Currency read Get_Betrag;
    property Belegdatum: TDateTime read Get_Belegdatum;
    property Belegnummer1: WideString read Get_Belegnummer1;
    property Belegnummer2: WideString read Get_Belegnummer2;
    property Buchtext: WideString read Get_Buchtext;
    property DokumentID: WideString read Get_DokumentID;
    property Waehrungsbetrag: Currency read Get_Waehrungsbetrag;
    property Waehrungskurs: Double read Get_Waehrungskurs;
    property Memotext: WideString read Get_Memotext;
    property Benutzer: WideString read Get_Benutzer;
    property FullBarcode: WideString read Get_FullBarcode;
    property BarcodeJahr: Integer read Get_BarcodeJahr;
  end;

// *********************************************************************//
// DispIntf:  IArchivDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8A5D903D-8898-4A58-AE69-0E767BE5F576}
// *********************************************************************//
  IArchivDisp = dispinterface
    ['{8A5D903D-8898-4A58-AE69-0E767BE5F576}']
    function Navigate: INavigate; dispid 1;
    property Mandant: Integer readonly dispid 2;
    property Wirtschaftsjahr: Integer readonly dispid 3;
    property Journalzeile: Integer readonly dispid 4;
    property Barcode: WideString readonly dispid 5;
    property Buchdatum: TDateTime readonly dispid 6;
    property Konto: Integer readonly dispid 7;
    property GegKonto: Integer readonly dispid 8;
    property Betrag: Currency readonly dispid 11;
    property Belegdatum: TDateTime readonly dispid 12;
    property Belegnummer1: WideString readonly dispid 13;
    property Belegnummer2: WideString readonly dispid 14;
    property Buchtext: WideString readonly dispid 15;
    property DokumentID: WideString readonly dispid 16;
    property Waehrungsbetrag: Currency readonly dispid 17;
    property Waehrungskurs: Double readonly dispid 18;
    property Memotext: WideString readonly dispid 19;
    property Benutzer: WideString readonly dispid 201;
    property FullBarcode: WideString readonly dispid 202;
    property BarcodeJahr: Integer readonly dispid 203;
  end;

// *********************************************************************//
// Interface: IArchivierung
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {630829FB-5738-4A10-BC7B-9EF47C2330ED}
// *********************************************************************//
  IArchivierung = interface(IDispatch)
    ['{630829FB-5738-4A10-BC7B-9EF47C2330ED}']
    function Archiv(ArchivTyp: EArchivTypen): IArchiv; safecall;
    function Barcodefinden(const aBarCode: WideString): IArchiv; safecall;
    function Belegarchiviert(const Barcode: WideString; JrnZl: Integer; const DocID: WideString; 
                             out ErrText: WideString): WordBool; safecall;
    function Barcodesuchen(ArchivTyp: EArchivTypen; const Barcode: WideString): IArchiv; safecall;
    function Get_NaechsterBarcode: Int64; safecall;
    procedure Set_NaechsterBarcode(Value: Int64); safecall;
    function ExtractBarcode(const Image: WideString; const Extension: WideString): WideString; safecall;
    property NaechsterBarcode: Int64 read Get_NaechsterBarcode write Set_NaechsterBarcode;
  end;

// *********************************************************************//
// DispIntf:  IArchivierungDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {630829FB-5738-4A10-BC7B-9EF47C2330ED}
// *********************************************************************//
  IArchivierungDisp = dispinterface
    ['{630829FB-5738-4A10-BC7B-9EF47C2330ED}']
    function Archiv(ArchivTyp: EArchivTypen): IArchiv; dispid 1;
    function Barcodefinden(const aBarCode: WideString): IArchiv; dispid 2;
    function Belegarchiviert(const Barcode: WideString; JrnZl: Integer; const DocID: WideString; 
                             out ErrText: WideString): WordBool; dispid 3;
    function Barcodesuchen(ArchivTyp: EArchivTypen; const Barcode: WideString): IArchiv; dispid 201;
    property NaechsterBarcode: Int64 dispid 202;
    function ExtractBarcode(const Image: WideString; const Extension: WideString): WideString; dispid 203;
  end;

// *********************************************************************//
// Interface: IBgMw
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5288A160-018C-4480-AF36-40FC8C7E93CA}
// *********************************************************************//
  IBgMw = interface(IDispatch)
    ['{5288A160-018C-4480-AF36-40FC8C7E93CA}']
    function Get_BGNr: Integer; safecall;
    function Get_KStTrNr: Integer; safecall;
    function Monatswert(Monat: Integer): Double; safecall;
    function Get_KArtNr: Integer; safecall;
    function Get_Bezugsgroesse: IBezugsgroesse; safecall;
    function Navigate: INavigate; safecall;
    property BGNr: Integer read Get_BGNr;
    property KStTrNr: Integer read Get_KStTrNr;
    property KArtNr: Integer read Get_KArtNr;
    property Bezugsgroesse: IBezugsgroesse read Get_Bezugsgroesse;
  end;

// *********************************************************************//
// DispIntf:  IBgMwDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {5288A160-018C-4480-AF36-40FC8C7E93CA}
// *********************************************************************//
  IBgMwDisp = dispinterface
    ['{5288A160-018C-4480-AF36-40FC8C7E93CA}']
    property BGNr: Integer readonly dispid 1;
    property KStTrNr: Integer readonly dispid 2;
    function Monatswert(Monat: Integer): Double; dispid 4;
    property KArtNr: Integer readonly dispid 5;
    property Bezugsgroesse: IBezugsgroesse readonly dispid 3;
    function Navigate: INavigate; dispid 6;
  end;

// *********************************************************************//
// Interface: IBatchScript
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {413A0B81-D980-4017-A58E-E604159136DB}
// *********************************************************************//
  IBatchScript = interface(IDispatch)
    ['{413A0B81-D980-4017-A58E-E604159136DB}']
    function Navigate: INavigate; safecall;
    function Get_Zeile: Integer; safecall;
    function Get_Status: Integer; safecall;
    function Get_Mandant: Integer; safecall;
    function Get_Buchdatum: TDateTime; safecall;
    function Get_Dateiname: WideString; safecall;
    function Get_Uebernahme: TDateTime; safecall;
    property Zeile: Integer read Get_Zeile;
    property Status: Integer read Get_Status;
    property Mandant: Integer read Get_Mandant;
    property Buchdatum: TDateTime read Get_Buchdatum;
    property Dateiname: WideString read Get_Dateiname;
    property Uebernahme: TDateTime read Get_Uebernahme;
  end;

// *********************************************************************//
// DispIntf:  IBatchScriptDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {413A0B81-D980-4017-A58E-E604159136DB}
// *********************************************************************//
  IBatchScriptDisp = dispinterface
    ['{413A0B81-D980-4017-A58E-E604159136DB}']
    function Navigate: INavigate; dispid 1;
    property Zeile: Integer readonly dispid 2;
    property Status: Integer readonly dispid 3;
    property Mandant: Integer readonly dispid 4;
    property Buchdatum: TDateTime readonly dispid 5;
    property Dateiname: WideString readonly dispid 6;
    property Uebernahme: TDateTime readonly dispid 7;
  end;

// *********************************************************************//
// Interface: IXML
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D18DD702-3327-4A56-9E99-6232AD16DEFC}
// *********************************************************************//
  IXML = interface(IDispatch)
    ['{D18DD702-3327-4A56-9E99-6232AD16DEFC}']
    function GetData(Value: EXMLTableTypen): WideString; safecall;
    function Get_OpenParams: WideString; safecall;
    procedure Set_OpenParams(const Value: WideString); safecall;
    property OpenParams: WideString read Get_OpenParams write Set_OpenParams;
  end;

// *********************************************************************//
// DispIntf:  IXMLDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D18DD702-3327-4A56-9E99-6232AD16DEFC}
// *********************************************************************//
  IXMLDisp = dispinterface
    ['{D18DD702-3327-4A56-9E99-6232AD16DEFC}']
    function GetData(Value: EXMLTableTypen): WideString; dispid 1;
    property OpenParams: WideString dispid 3;
  end;

// *********************************************************************//
// Interface: IDCUebFiles
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E338E8EE-237E-4F01-B1A4-E463633785FB}
// *********************************************************************//
  IDCUebFiles = interface(IDispatch)
    ['{E338E8EE-237E-4F01-B1A4-E463633785FB}']
    function Navigate: INavigate; safecall;
    function Get_Betrag: Currency; safecall;
    function Get_SollKonto: Integer; safecall;
    function Get_HabenKonto: Integer; safecall;
    function Get_Beleg1: WideString; safecall;
    function Get_Beleg2: WideString; safecall;
    function Get_Buchtext: WideString; safecall;
    function Get_Belegdatum: TDateTime; safecall;
    function Get_Dateiname: WideString; safecall;
    function Get_Erstellzeitpunkt: TDateTime; safecall;
    function Get_Dateigroesse: Integer; safecall;
    function Get_FileNummer: Integer; safecall;
    property Betrag: Currency read Get_Betrag;
    property SollKonto: Integer read Get_SollKonto;
    property HabenKonto: Integer read Get_HabenKonto;
    property Beleg1: WideString read Get_Beleg1;
    property Beleg2: WideString read Get_Beleg2;
    property Buchtext: WideString read Get_Buchtext;
    property Belegdatum: TDateTime read Get_Belegdatum;
    property Dateiname: WideString read Get_Dateiname;
    property Erstellzeitpunkt: TDateTime read Get_Erstellzeitpunkt;
    property Dateigroesse: Integer read Get_Dateigroesse;
    property FileNummer: Integer read Get_FileNummer;
  end;

// *********************************************************************//
// DispIntf:  IDCUebFilesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E338E8EE-237E-4F01-B1A4-E463633785FB}
// *********************************************************************//
  IDCUebFilesDisp = dispinterface
    ['{E338E8EE-237E-4F01-B1A4-E463633785FB}']
    function Navigate: INavigate; dispid 1;
    property Betrag: Currency readonly dispid 2;
    property SollKonto: Integer readonly dispid 4;
    property HabenKonto: Integer readonly dispid 5;
    property Beleg1: WideString readonly dispid 6;
    property Beleg2: WideString readonly dispid 7;
    property Buchtext: WideString readonly dispid 8;
    property Belegdatum: TDateTime readonly dispid 9;
    property Dateiname: WideString readonly dispid 10;
    property Erstellzeitpunkt: TDateTime readonly dispid 11;
    property Dateigroesse: Integer readonly dispid 13;
    property FileNummer: Integer readonly dispid 3;
  end;

// *********************************************************************//
// Interface: IBgBeweg
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AAF13146-6868-4063-8707-DF52B8744F02}
// *********************************************************************//
  IBgBeweg = interface(IDispatch)
    ['{AAF13146-6868-4063-8707-DF52B8744F02}']
    function Navigate: INavigate; safecall;
    function Get_BGNr: Integer; safecall;
    function Get_KStTrNr: Integer; safecall;
    function Get_Monatswert: Double; safecall;
    function Get_KArtNr: Integer; safecall;
    function Get_Bezugsgroesse: IBezugsgroesse; safecall;
    function Get_GegenKonto: Integer; safecall;
    function Get_Monat: Integer; safecall;
    function Get_IsLast: WordBool; safecall;
    function Get_Aufteilung: EBgAuftTypen; safecall;
    function Get_GegenkontoTyp: EKontotypen; safecall;
    function Get_KStTrTyp: EKontotypen; safecall;
    property BGNr: Integer read Get_BGNr;
    property KStTrNr: Integer read Get_KStTrNr;
    property Monatswert: Double read Get_Monatswert;
    property KArtNr: Integer read Get_KArtNr;
    property Bezugsgroesse: IBezugsgroesse read Get_Bezugsgroesse;
    property GegenKonto: Integer read Get_GegenKonto;
    property Monat: Integer read Get_Monat;
    property IsLast: WordBool read Get_IsLast;
    property Aufteilung: EBgAuftTypen read Get_Aufteilung;
    property GegenkontoTyp: EKontotypen read Get_GegenkontoTyp;
    property KStTrTyp: EKontotypen read Get_KStTrTyp;
  end;

// *********************************************************************//
// DispIntf:  IBgBewegDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AAF13146-6868-4063-8707-DF52B8744F02}
// *********************************************************************//
  IBgBewegDisp = dispinterface
    ['{AAF13146-6868-4063-8707-DF52B8744F02}']
    function Navigate: INavigate; dispid 1;
    property BGNr: Integer readonly dispid 2;
    property KStTrNr: Integer readonly dispid 3;
    property Monatswert: Double readonly dispid 4;
    property KArtNr: Integer readonly dispid 5;
    property Bezugsgroesse: IBezugsgroesse readonly dispid 6;
    property GegenKonto: Integer readonly dispid 7;
    property Monat: Integer readonly dispid 8;
    property IsLast: WordBool readonly dispid 9;
    property Aufteilung: EBgAuftTypen readonly dispid 10;
    property GegenkontoTyp: EKontotypen readonly dispid 11;
    property KStTrTyp: EKontotypen readonly dispid 12;
  end;

// *********************************************************************//
// Interface: IInventar
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C14070AC-C87D-4BD6-B0CD-188EC0E50E5A}
// *********************************************************************//
  IInventar = interface(IDispatch)
    ['{C14070AC-C87D-4BD6-B0CD-188EC0E50E5A}']
    function Bezeichnung(Nr: Integer): WideString; safecall;
    function Navigate: INavigate; safecall;
    function Get_Inventarnummer: WideString; safecall;
    procedure Set_Inventarnummer(const Value: WideString); safecall;
    function Get_WerkFilialNr: Integer; safecall;
    function Get_Standort: WideString; safecall;
    function Get_Anzahl: Integer; safecall;
    function Get_Seriennummer: WideString; safecall;
    function Get_Anlagedatum: TDateTime; safecall;
    function Get_Aenderungsdatum: TDateTime; safecall;
    function Get_Abgangsdatum: TDateTime; safecall;
    function GrpNummer(Nr: Integer): Integer; safecall;
    function Ebene(EbeneNr: EInventarebenen): IInventarebene; safecall;
    function Status(EbeneNr: EInventarebenen; perDatum: TDateTime; simAfA: WordBool): IInventarstatus; safecall;
    function KLRAnteil: IInventarKLRAnteil; safecall;
    function Get_Wirtschaftsgutart: Integer; safecall;
    function Get_Erinnerungswert: Currency; safecall;
    function Get_IsBebucht: WordBool; safecall;
    function Get_IsValid: WordBool; safecall;
    function Get_IsAbgegangen: WordBool; safecall;
    function Get_IsGenutzt: WordBool; safecall;
    function Get_IsGebraucht: WordBool; safecall;
    function Get_IsLeasing: WordBool; safecall;
    function Get_IsVerpachtet: WordBool; safecall;
    function Get_IsAfaAutomatisch: WordBool; safecall;
    function Get_Kreditorennummer: Integer; safecall;
    function Get_Anschaffungsdatum: TDateTime; safecall;
    function Information(Nr: Integer): WideString; safecall;
    function Get_Waehrungsnummer: Integer; safecall;
    function Waehrung: IWaehrung; safecall;
    function Get_IsFuehrungssatz: WordBool; safecall;
    function InventarJournal(EbeneNr: EInventarebenen): IInventarJournal; safecall;
    function Get_InventurNr: Integer; safecall;
    function GrpDatumAb(Nr: Integer): TDateTime; safecall;
    function GrpDatumBis(Nr: Integer): TDateTime; safecall;
    property Inventarnummer: WideString read Get_Inventarnummer write Set_Inventarnummer;
    property WerkFilialNr: Integer read Get_WerkFilialNr;
    property Standort: WideString read Get_Standort;
    property Anzahl: Integer read Get_Anzahl;
    property Seriennummer: WideString read Get_Seriennummer;
    property Anlagedatum: TDateTime read Get_Anlagedatum;
    property Aenderungsdatum: TDateTime read Get_Aenderungsdatum;
    property Abgangsdatum: TDateTime read Get_Abgangsdatum;
    property Wirtschaftsgutart: Integer read Get_Wirtschaftsgutart;
    property Erinnerungswert: Currency read Get_Erinnerungswert;
    property IsBebucht: WordBool read Get_IsBebucht;
    property IsValid: WordBool read Get_IsValid;
    property IsAbgegangen: WordBool read Get_IsAbgegangen;
    property IsGenutzt: WordBool read Get_IsGenutzt;
    property IsGebraucht: WordBool read Get_IsGebraucht;
    property IsLeasing: WordBool read Get_IsLeasing;
    property IsVerpachtet: WordBool read Get_IsVerpachtet;
    property IsAfaAutomatisch: WordBool read Get_IsAfaAutomatisch;
    property Kreditorennummer: Integer read Get_Kreditorennummer;
    property Anschaffungsdatum: TDateTime read Get_Anschaffungsdatum;
    property Waehrungsnummer: Integer read Get_Waehrungsnummer;
    property IsFuehrungssatz: WordBool read Get_IsFuehrungssatz;
    property InventurNr: Integer read Get_InventurNr;
  end;

// *********************************************************************//
// DispIntf:  IInventarDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C14070AC-C87D-4BD6-B0CD-188EC0E50E5A}
// *********************************************************************//
  IInventarDisp = dispinterface
    ['{C14070AC-C87D-4BD6-B0CD-188EC0E50E5A}']
    function Bezeichnung(Nr: Integer): WideString; dispid 4;
    function Navigate: INavigate; dispid 5;
    property Inventarnummer: WideString dispid 6;
    property WerkFilialNr: Integer readonly dispid 1;
    property Standort: WideString readonly dispid 2;
    property Anzahl: Integer readonly dispid 3;
    property Seriennummer: WideString readonly dispid 7;
    property Anlagedatum: TDateTime readonly dispid 8;
    property Aenderungsdatum: TDateTime readonly dispid 9;
    property Abgangsdatum: TDateTime readonly dispid 10;
    function GrpNummer(Nr: Integer): Integer; dispid 11;
    function Ebene(EbeneNr: EInventarebenen): IInventarebene; dispid 12;
    function Status(EbeneNr: EInventarebenen; perDatum: TDateTime; simAfA: WordBool): IInventarstatus; dispid 13;
    function KLRAnteil: IInventarKLRAnteil; dispid 14;
    property Wirtschaftsgutart: Integer readonly dispid 15;
    property Erinnerungswert: Currency readonly dispid 16;
    property IsBebucht: WordBool readonly dispid 18;
    property IsValid: WordBool readonly dispid 17;
    property IsAbgegangen: WordBool readonly dispid 19;
    property IsGenutzt: WordBool readonly dispid 20;
    property IsGebraucht: WordBool readonly dispid 21;
    property IsLeasing: WordBool readonly dispid 22;
    property IsVerpachtet: WordBool readonly dispid 23;
    property IsAfaAutomatisch: WordBool readonly dispid 24;
    property Kreditorennummer: Integer readonly dispid 25;
    property Anschaffungsdatum: TDateTime readonly dispid 26;
    function Information(Nr: Integer): WideString; dispid 30;
    property Waehrungsnummer: Integer readonly dispid 31;
    function Waehrung: IWaehrung; dispid 32;
    property IsFuehrungssatz: WordBool readonly dispid 27;
    function InventarJournal(EbeneNr: EInventarebenen): IInventarJournal; dispid 201;
    property InventurNr: Integer readonly dispid 202;
    function GrpDatumAb(Nr: Integer): TDateTime; dispid 205;
    function GrpDatumBis(Nr: Integer): TDateTime; dispid 203;
  end;

// *********************************************************************//
// Interface: IInventarebene
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1DCE2E2C-5880-4BCC-87BA-6BF04613295C}
// *********************************************************************//
  IInventarebene = interface(IDispatch)
    ['{1DCE2E2C-5880-4BCC-87BA-6BF04613295C}']
    function Get_Fibukonto: Integer; safecall;
    function Get_AfAKonto: Integer; safecall;
    function Get_Nutzbeginn: TDateTime; safecall;
    function Get_NutzdauerJahre: Integer; safecall;
    function Get_NutzdauerMonate: Integer; safecall;
    function Get_AfAArtNr: Integer; safecall;
    function Get_AfASchluessel: Integer; safecall;
    function Get_Schichtfaktor: Currency; safecall;
    function Get_IsSonderAfA: WordBool; safecall;
    function Get_SonderAfaMaxProzent: Currency; safecall;
    function Get_IsVereinfachungsregel: WordBool; safecall;
    property Fibukonto: Integer read Get_Fibukonto;
    property AfAKonto: Integer read Get_AfAKonto;
    property Nutzbeginn: TDateTime read Get_Nutzbeginn;
    property NutzdauerJahre: Integer read Get_NutzdauerJahre;
    property NutzdauerMonate: Integer read Get_NutzdauerMonate;
    property AfAArtNr: Integer read Get_AfAArtNr;
    property AfASchluessel: Integer read Get_AfASchluessel;
    property Schichtfaktor: Currency read Get_Schichtfaktor;
    property IsSonderAfA: WordBool read Get_IsSonderAfA;
    property SonderAfaMaxProzent: Currency read Get_SonderAfaMaxProzent;
    property IsVereinfachungsregel: WordBool read Get_IsVereinfachungsregel;
  end;

// *********************************************************************//
// DispIntf:  IInventarebeneDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1DCE2E2C-5880-4BCC-87BA-6BF04613295C}
// *********************************************************************//
  IInventarebeneDisp = dispinterface
    ['{1DCE2E2C-5880-4BCC-87BA-6BF04613295C}']
    property Fibukonto: Integer readonly dispid 1;
    property AfAKonto: Integer readonly dispid 2;
    property Nutzbeginn: TDateTime readonly dispid 3;
    property NutzdauerJahre: Integer readonly dispid 4;
    property NutzdauerMonate: Integer readonly dispid 5;
    property AfAArtNr: Integer readonly dispid 6;
    property AfASchluessel: Integer readonly dispid 7;
    property Schichtfaktor: Currency readonly dispid 8;
    property IsSonderAfA: WordBool readonly dispid 9;
    property SonderAfaMaxProzent: Currency readonly dispid 10;
    property IsVereinfachungsregel: WordBool readonly dispid 201;
  end;

// *********************************************************************//
// Interface: IInventarstatus
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {844A42E0-CF22-4460-8040-7BFD6B2AF300}
// *********************************************************************//
  IInventarstatus = interface(IDispatch)
    ['{844A42E0-CF22-4460-8040-7BFD6B2AF300}']
    function Get_Anschaffungskosten: Currency; safecall;
    function Get_Abschreibung: Currency; safecall;
    function Get_Restbuchwert: Currency; safecall;
    function Get_AnschaffungskostenAnfang: Currency; safecall;
    function Get_AnschaffungskostenZugang: Currency; safecall;
    function Get_AnschaffungskostenAbgang: Currency; safecall;
    function Get_AnschaffungskostenUmbuchung: Currency; safecall;
    function Get_AbschreibungAnfang: Currency; safecall;
    function Get_AbschreibungZugang: Currency; safecall;
    function Get_AbschreibungAbgang: Currency; safecall;
    function Get_AbschreibungUmbuchung: Currency; safecall;
    function Get_AbschreibungSimulation: Currency; safecall;
    function Get_RestbuchwertAnfang: Currency; safecall;
    function Get_RestbuchwertAbgang: Currency; safecall;
    function Get_RestbuchwertUmbuchung: Currency; safecall;
    function Get_RestbuchwertZugang: Currency; safecall;
    function Get_Sonderabschreibung: Currency; safecall;
    function Get_SonderabschreibungAnfang: Currency; safecall;
    function Get_SonderabschreibungZugang: Currency; safecall;
    function Get_AbschreibungProzent: Double; safecall;
    property Anschaffungskosten: Currency read Get_Anschaffungskosten;
    property Abschreibung: Currency read Get_Abschreibung;
    property Restbuchwert: Currency read Get_Restbuchwert;
    property AnschaffungskostenAnfang: Currency read Get_AnschaffungskostenAnfang;
    property AnschaffungskostenZugang: Currency read Get_AnschaffungskostenZugang;
    property AnschaffungskostenAbgang: Currency read Get_AnschaffungskostenAbgang;
    property AnschaffungskostenUmbuchung: Currency read Get_AnschaffungskostenUmbuchung;
    property AbschreibungAnfang: Currency read Get_AbschreibungAnfang;
    property AbschreibungZugang: Currency read Get_AbschreibungZugang;
    property AbschreibungAbgang: Currency read Get_AbschreibungAbgang;
    property AbschreibungUmbuchung: Currency read Get_AbschreibungUmbuchung;
    property AbschreibungSimulation: Currency read Get_AbschreibungSimulation;
    property RestbuchwertAnfang: Currency read Get_RestbuchwertAnfang;
    property RestbuchwertAbgang: Currency read Get_RestbuchwertAbgang;
    property RestbuchwertUmbuchung: Currency read Get_RestbuchwertUmbuchung;
    property RestbuchwertZugang: Currency read Get_RestbuchwertZugang;
    property Sonderabschreibung: Currency read Get_Sonderabschreibung;
    property SonderabschreibungAnfang: Currency read Get_SonderabschreibungAnfang;
    property SonderabschreibungZugang: Currency read Get_SonderabschreibungZugang;
    property AbschreibungProzent: Double read Get_AbschreibungProzent;
  end;

// *********************************************************************//
// DispIntf:  IInventarstatusDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {844A42E0-CF22-4460-8040-7BFD6B2AF300}
// *********************************************************************//
  IInventarstatusDisp = dispinterface
    ['{844A42E0-CF22-4460-8040-7BFD6B2AF300}']
    property Anschaffungskosten: Currency readonly dispid 1;
    property Abschreibung: Currency readonly dispid 2;
    property Restbuchwert: Currency readonly dispid 3;
    property AnschaffungskostenAnfang: Currency readonly dispid 4;
    property AnschaffungskostenZugang: Currency readonly dispid 5;
    property AnschaffungskostenAbgang: Currency readonly dispid 6;
    property AnschaffungskostenUmbuchung: Currency readonly dispid 7;
    property AbschreibungAnfang: Currency readonly dispid 8;
    property AbschreibungZugang: Currency readonly dispid 9;
    property AbschreibungAbgang: Currency readonly dispid 10;
    property AbschreibungUmbuchung: Currency readonly dispid 11;
    property AbschreibungSimulation: Currency readonly dispid 12;
    property RestbuchwertAnfang: Currency readonly dispid 13;
    property RestbuchwertAbgang: Currency readonly dispid 14;
    property RestbuchwertUmbuchung: Currency readonly dispid 15;
    property RestbuchwertZugang: Currency readonly dispid 16;
    property Sonderabschreibung: Currency readonly dispid 201;
    property SonderabschreibungAnfang: Currency readonly dispid 202;
    property SonderabschreibungZugang: Currency readonly dispid 203;
    property AbschreibungProzent: Double readonly dispid 204;
  end;

// *********************************************************************//
// Interface: IInventarKLRAnteil
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {33AA927D-2563-4C87-8D92-A34017C4851E}
// *********************************************************************//
  IInventarKLRAnteil = interface(IDispatch)
    ['{33AA927D-2563-4C87-8D92-A34017C4851E}']
    function Navigate: INavigate; safecall;
    function Get_IsKostenstelle: WordBool; safecall;
    function Get_IsKostentraeger: WordBool; safecall;
    function Get_KoStTrNr: Integer; safecall;
    function Get_Ordnung: Integer; safecall;
    function Get_Anteil: Integer; safecall;
    function Get_AbDatum: TDateTime; safecall;
    function Get_BisDatum: TDateTime; safecall;
    property IsKostenstelle: WordBool read Get_IsKostenstelle;
    property IsKostentraeger: WordBool read Get_IsKostentraeger;
    property KoStTrNr: Integer read Get_KoStTrNr;
    property Ordnung: Integer read Get_Ordnung;
    property Anteil: Integer read Get_Anteil;
    property AbDatum: TDateTime read Get_AbDatum;
    property BisDatum: TDateTime read Get_BisDatum;
  end;

// *********************************************************************//
// DispIntf:  IInventarKLRAnteilDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {33AA927D-2563-4C87-8D92-A34017C4851E}
// *********************************************************************//
  IInventarKLRAnteilDisp = dispinterface
    ['{33AA927D-2563-4C87-8D92-A34017C4851E}']
    function Navigate: INavigate; dispid 1;
    property IsKostenstelle: WordBool readonly dispid 2;
    property IsKostentraeger: WordBool readonly dispid 3;
    property KoStTrNr: Integer readonly dispid 4;
    property Ordnung: Integer readonly dispid 5;
    property Anteil: Integer readonly dispid 6;
    property AbDatum: TDateTime readonly dispid 7;
    property BisDatum: TDateTime readonly dispid 8;
  end;

// *********************************************************************//
// Interface: IServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {15EC12A5-BC1E-4B53-9732-7B72A85F117B}
// *********************************************************************//
  IServer = interface(IDispatch)
    ['{15EC12A5-BC1E-4B53-9732-7B72A85F117B}']
    function ConnectionCount: Integer; safecall;
    procedure ShutDown; safecall;
  end;

// *********************************************************************//
// DispIntf:  IServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {15EC12A5-BC1E-4B53-9732-7B72A85F117B}
// *********************************************************************//
  IServerDisp = dispinterface
    ['{15EC12A5-BC1E-4B53-9732-7B72A85F117B}']
    function ConnectionCount: Integer; dispid 1;
    procedure ShutDown; dispid 2;
  end;

// *********************************************************************//
// Interface: IBranche
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C1BB5972-3E8E-4733-95B8-8B53F26412BF}
// *********************************************************************//
  IBranche = interface(IDispatch)
    ['{C1BB5972-3E8E-4733-95B8-8B53F26412BF}']
    function Get_Bezeichnung: WideString; safecall;
    function Navigate: INavigate; safecall;
    function Get_Schluessel: Integer; safecall;
    procedure Set_Schluessel(Value: Integer); safecall;
    property Bezeichnung: WideString read Get_Bezeichnung;
    property Schluessel: Integer read Get_Schluessel write Set_Schluessel;
  end;

// *********************************************************************//
// DispIntf:  IBrancheDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C1BB5972-3E8E-4733-95B8-8B53F26412BF}
// *********************************************************************//
  IBrancheDisp = dispinterface
    ['{C1BB5972-3E8E-4733-95B8-8B53F26412BF}']
    property Bezeichnung: WideString readonly dispid 202;
    function Navigate: INavigate; dispid 203;
    property Schluessel: Integer dispid 201;
  end;

// *********************************************************************//
// Interface: IWechsel
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {69B51AF2-1309-4E18-9ED3-35B32FB3021C}
// *********************************************************************//
  IWechsel = interface(IDispatch)
    ['{69B51AF2-1309-4E18-9ED3-35B32FB3021C}']
    function Get_Nummer: Integer; safecall;
    procedure Set_Nummer(Value: Integer); safecall;
    function Get_Art: EWechselarten; safecall;
    function Navigate: INavigate; safecall;
    function Get_Konto1: Integer; safecall;
    function Get_Konto2: Integer; safecall;
    function Get_Hauswaehrung: Integer; safecall;
    function Get_HwBetrag: Currency; safecall;
    function Get_Fremdwaehrung: Integer; safecall;
    function Get_FwBetrag: Currency; safecall;
    function Get_Verwendung: EWechselverwendungen; safecall;
    function Get_Bezogener: Integer; safecall;
    function Get_Aussteller: Integer; safecall;
    function Get_Indossant: Integer; safecall;
    function Get_Indossatar: Integer; safecall;
    function Get_AnOrder: Integer; safecall;
    function Get_ZahlbarIn: WideString; safecall;
    function Get_ZahlbarBeiBank: WideString; safecall;
    function Get_ZahlbarBeiBKtNr: WideString; safecall;
    function Get_IBAN: WideString; safecall;
    function Get_AusstellOrt: WideString; safecall;
    function Get_AusstellDatum: TDateTime; safecall;
    function Get_FaelligDatum: TDateTime; safecall;
    function Get_AkzeptiertDatum: TDateTime; safecall;
    function Get_VersandDatum: TDateTime; safecall;
    function Get_VersandAn: Integer; safecall;
    function Get_Eingangsdatum: TDateTime; safecall;
    function Get_EingangVon: Integer; safecall;
    function Get_Ausgangsdatum: TDateTime; safecall;
    function Get_Diskontbank: Integer; safecall;
    function Get_DiskontDatum: TDateTime; safecall;
    function Get_DiskontoNr: WideString; safecall;
    function Get_ProlongDatum: TDateTime; safecall;
    function Get_ProtestDatum: TDateTime; safecall;
    function Get_Anlagedatum: TDateTime; safecall;
    function Get_Ursprungskonto: Integer; safecall;
    function Get_FibuNetBankKonto: Integer; safecall;
    function Get_Einloesdatum: TDateTime; safecall;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Art: EWechselarten read Get_Art;
    property Konto1: Integer read Get_Konto1;
    property Konto2: Integer read Get_Konto2;
    property Hauswaehrung: Integer read Get_Hauswaehrung;
    property HwBetrag: Currency read Get_HwBetrag;
    property Fremdwaehrung: Integer read Get_Fremdwaehrung;
    property FwBetrag: Currency read Get_FwBetrag;
    property Verwendung: EWechselverwendungen read Get_Verwendung;
    property Bezogener: Integer read Get_Bezogener;
    property Aussteller: Integer read Get_Aussteller;
    property Indossant: Integer read Get_Indossant;
    property Indossatar: Integer read Get_Indossatar;
    property AnOrder: Integer read Get_AnOrder;
    property ZahlbarIn: WideString read Get_ZahlbarIn;
    property ZahlbarBeiBank: WideString read Get_ZahlbarBeiBank;
    property ZahlbarBeiBKtNr: WideString read Get_ZahlbarBeiBKtNr;
    property IBAN: WideString read Get_IBAN;
    property AusstellOrt: WideString read Get_AusstellOrt;
    property AusstellDatum: TDateTime read Get_AusstellDatum;
    property FaelligDatum: TDateTime read Get_FaelligDatum;
    property AkzeptiertDatum: TDateTime read Get_AkzeptiertDatum;
    property VersandDatum: TDateTime read Get_VersandDatum;
    property VersandAn: Integer read Get_VersandAn;
    property Eingangsdatum: TDateTime read Get_Eingangsdatum;
    property EingangVon: Integer read Get_EingangVon;
    property Ausgangsdatum: TDateTime read Get_Ausgangsdatum;
    property Diskontbank: Integer read Get_Diskontbank;
    property DiskontDatum: TDateTime read Get_DiskontDatum;
    property DiskontoNr: WideString read Get_DiskontoNr;
    property ProlongDatum: TDateTime read Get_ProlongDatum;
    property ProtestDatum: TDateTime read Get_ProtestDatum;
    property Anlagedatum: TDateTime read Get_Anlagedatum;
    property Ursprungskonto: Integer read Get_Ursprungskonto;
    property FibuNetBankKonto: Integer read Get_FibuNetBankKonto;
    property Einloesdatum: TDateTime read Get_Einloesdatum;
  end;

// *********************************************************************//
// DispIntf:  IWechselDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {69B51AF2-1309-4E18-9ED3-35B32FB3021C}
// *********************************************************************//
  IWechselDisp = dispinterface
    ['{69B51AF2-1309-4E18-9ED3-35B32FB3021C}']
    property Nummer: Integer dispid 201;
    property Art: EWechselarten readonly dispid 202;
    function Navigate: INavigate; dispid 203;
    property Konto1: Integer readonly dispid 204;
    property Konto2: Integer readonly dispid 205;
    property Hauswaehrung: Integer readonly dispid 206;
    property HwBetrag: Currency readonly dispid 207;
    property Fremdwaehrung: Integer readonly dispid 208;
    property FwBetrag: Currency readonly dispid 209;
    property Verwendung: EWechselverwendungen readonly dispid 210;
    property Bezogener: Integer readonly dispid 211;
    property Aussteller: Integer readonly dispid 212;
    property Indossant: Integer readonly dispid 213;
    property Indossatar: Integer readonly dispid 214;
    property AnOrder: Integer readonly dispid 215;
    property ZahlbarIn: WideString readonly dispid 216;
    property ZahlbarBeiBank: WideString readonly dispid 217;
    property ZahlbarBeiBKtNr: WideString readonly dispid 218;
    property IBAN: WideString readonly dispid 219;
    property AusstellOrt: WideString readonly dispid 220;
    property AusstellDatum: TDateTime readonly dispid 221;
    property FaelligDatum: TDateTime readonly dispid 222;
    property AkzeptiertDatum: TDateTime readonly dispid 223;
    property VersandDatum: TDateTime readonly dispid 224;
    property VersandAn: Integer readonly dispid 225;
    property Eingangsdatum: TDateTime readonly dispid 226;
    property EingangVon: Integer readonly dispid 227;
    property Ausgangsdatum: TDateTime readonly dispid 228;
    property Diskontbank: Integer readonly dispid 229;
    property DiskontDatum: TDateTime readonly dispid 230;
    property DiskontoNr: WideString readonly dispid 231;
    property ProlongDatum: TDateTime readonly dispid 232;
    property ProtestDatum: TDateTime readonly dispid 233;
    property Anlagedatum: TDateTime readonly dispid 234;
    property Ursprungskonto: Integer readonly dispid 235;
    property FibuNetBankKonto: Integer readonly dispid 236;
    property Einloesdatum: TDateTime readonly dispid 237;
  end;

// *********************************************************************//
// Interface: ITageskurs
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2B67894D-57D6-4227-95A4-DAE954213CE5}
// *********************************************************************//
  ITageskurs = interface(IDispatch)
    ['{2B67894D-57D6-4227-95A4-DAE954213CE5}']
    function Navigate: INavigate; safecall;
    function Get_Tagesdatum: TDateTime; safecall;
    procedure Set_Tagesdatum(Value: TDateTime); safecall;
    function Get_Geldkurs: Currency; safecall;
    function Get_Briefkurs: Currency; safecall;
    property Tagesdatum: TDateTime read Get_Tagesdatum write Set_Tagesdatum;
    property Geldkurs: Currency read Get_Geldkurs;
    property Briefkurs: Currency read Get_Briefkurs;
  end;

// *********************************************************************//
// DispIntf:  ITageskursDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2B67894D-57D6-4227-95A4-DAE954213CE5}
// *********************************************************************//
  ITageskursDisp = dispinterface
    ['{2B67894D-57D6-4227-95A4-DAE954213CE5}']
    function Navigate: INavigate; dispid 201;
    property Tagesdatum: TDateTime dispid 202;
    property Geldkurs: Currency readonly dispid 203;
    property Briefkurs: Currency readonly dispid 204;
  end;

// *********************************************************************//
// Interface: IEGSteuer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E6BDBF00-3BC4-444C-9F3B-B4A64DE75F28}
// *********************************************************************//
  IEGSteuer = interface(IDispatch)
    ['{E6BDBF00-3BC4-444C-9F3B-B4A64DE75F28}']
    function Navigate: INavigate; safecall;
    function Get_UID: WideString; safecall;
    function Land(Value: Integer): WideString; safecall;
    function Get_Erwerbschwelle: Currency; safecall;
    function Get_Lieferschwelle: Currency; safecall;
    function GueltigAb(IdxValue: Integer; StSchlValue: Integer): TDateTime; safecall;
    function Steuersatz(IdxValue: Integer; StSchlValue: Integer): Double; safecall;
    function Get_Lkz: WideString; safecall;
    procedure Set_Lkz(const Value: WideString); safecall;
    function Get_EUMitgliedSeit: TDateTime; safecall;
    function Get_UStIdLen: Integer; safecall;
    function AbDatum(IdxValue: Integer): TDateTime; safecall;
    function FindSteuersatz(const Lkz: WideString; Schluessel: Integer; Belegdatum: TDateTime): Double; safecall;
    function FindSteuerschluessel(const Lkz: WideString; Prozent: Double; Belegdatum: TDateTime): Integer; safecall;
    property UID: WideString read Get_UID;
    property Erwerbschwelle: Currency read Get_Erwerbschwelle;
    property Lieferschwelle: Currency read Get_Lieferschwelle;
    property Lkz: WideString read Get_Lkz write Set_Lkz;
    property EUMitgliedSeit: TDateTime read Get_EUMitgliedSeit;
    property UStIdLen: Integer read Get_UStIdLen;
  end;

// *********************************************************************//
// DispIntf:  IEGSteuerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E6BDBF00-3BC4-444C-9F3B-B4A64DE75F28}
// *********************************************************************//
  IEGSteuerDisp = dispinterface
    ['{E6BDBF00-3BC4-444C-9F3B-B4A64DE75F28}']
    function Navigate: INavigate; dispid 201;
    property UID: WideString readonly dispid 203;
    function Land(Value: Integer): WideString; dispid 204;
    property Erwerbschwelle: Currency readonly dispid 205;
    property Lieferschwelle: Currency readonly dispid 206;
    function GueltigAb(IdxValue: Integer; StSchlValue: Integer): TDateTime; dispid 208;
    function Steuersatz(IdxValue: Integer; StSchlValue: Integer): Double; dispid 209;
    property Lkz: WideString dispid 210;
    property EUMitgliedSeit: TDateTime readonly dispid 202;
    property UStIdLen: Integer readonly dispid 207;
    function AbDatum(IdxValue: Integer): TDateTime; dispid 211;
    function FindSteuersatz(const Lkz: WideString; Schluessel: Integer; Belegdatum: TDateTime): Double; dispid 212;
    function FindSteuerschluessel(const Lkz: WideString; Prozent: Double; Belegdatum: TDateTime): Integer; dispid 213;
  end;

// *********************************************************************//
// Interface: IScheck
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {971F3438-32FF-49D9-A580-3B456E82F760}
// *********************************************************************//
  IScheck = interface(IDispatch)
    ['{971F3438-32FF-49D9-A580-3B456E82F760}']
    function Navigate: INavigate; safecall;
    function Get_Nummer: WideString; safecall;
    function Get_Tagesdatum: TDateTime; safecall;
    function Get_Betrag: Currency; safecall;
    function Get_Skonto: Currency; safecall;
    function Get_Konto: Integer; safecall;
    function Get_Zahldatum: TDateTime; safecall;
    function Get_KTO: WideString; safecall;
    function Get_BLZ: Integer; safecall;
    function Get_WaNr: Integer; safecall;
    function Get_WaBetrag: Currency; safecall;
    function Get_WaSkonto: Currency; safecall;
    function Get_FrmNr: Integer; safecall;
    function Zahlbuchung(Belegdatum: TDateTime; Wertdatum: TDateTime): WideString; safecall;
    function Loeschen: WordBool; safecall;
    property Nummer: WideString read Get_Nummer;
    property Tagesdatum: TDateTime read Get_Tagesdatum;
    property Betrag: Currency read Get_Betrag;
    property Skonto: Currency read Get_Skonto;
    property Konto: Integer read Get_Konto;
    property Zahldatum: TDateTime read Get_Zahldatum;
    property KTO: WideString read Get_KTO;
    property BLZ: Integer read Get_BLZ;
    property WaNr: Integer read Get_WaNr;
    property WaBetrag: Currency read Get_WaBetrag;
    property WaSkonto: Currency read Get_WaSkonto;
    property FrmNr: Integer read Get_FrmNr;
  end;

// *********************************************************************//
// DispIntf:  IScheckDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {971F3438-32FF-49D9-A580-3B456E82F760}
// *********************************************************************//
  IScheckDisp = dispinterface
    ['{971F3438-32FF-49D9-A580-3B456E82F760}']
    function Navigate: INavigate; dispid 201;
    property Nummer: WideString readonly dispid 202;
    property Tagesdatum: TDateTime readonly dispid 203;
    property Betrag: Currency readonly dispid 204;
    property Skonto: Currency readonly dispid 205;
    property Konto: Integer readonly dispid 206;
    property Zahldatum: TDateTime readonly dispid 207;
    property KTO: WideString readonly dispid 208;
    property BLZ: Integer readonly dispid 209;
    property WaNr: Integer readonly dispid 210;
    property WaBetrag: Currency readonly dispid 211;
    property WaSkonto: Currency readonly dispid 212;
    property FrmNr: Integer readonly dispid 213;
    function Zahlbuchung(Belegdatum: TDateTime; Wertdatum: TDateTime): WideString; dispid 214;
    function Loeschen: WordBool; dispid 215;
  end;

// *********************************************************************//
// Interface: IInventarJournal
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {101698A4-FE62-4295-A4A6-BCA1A1FE1C95}
// *********************************************************************//
  IInventarJournal = interface(IDispatch)
    ['{101698A4-FE62-4295-A4A6-BCA1A1FE1C95}']
    function Navigate: INavigate; safecall;
    function Kontierung: IKontierung; safecall;
    function Get_Inventarnummer: WideString; safecall;
    function Get_Bewegungsart: Integer; safecall;
    function Get_Einheit: Integer; safecall;
    function Get_Buchkenner: Integer; safecall;
    function Get_BuchJournalZeile: Integer; safecall;
    property Inventarnummer: WideString read Get_Inventarnummer;
    property Bewegungsart: Integer read Get_Bewegungsart;
    property Einheit: Integer read Get_Einheit;
    property Buchkenner: Integer read Get_Buchkenner;
    property BuchJournalZeile: Integer read Get_BuchJournalZeile;
  end;

// *********************************************************************//
// DispIntf:  IInventarJournalDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {101698A4-FE62-4295-A4A6-BCA1A1FE1C95}
// *********************************************************************//
  IInventarJournalDisp = dispinterface
    ['{101698A4-FE62-4295-A4A6-BCA1A1FE1C95}']
    function Navigate: INavigate; dispid 201;
    function Kontierung: IKontierung; dispid 202;
    property Inventarnummer: WideString readonly dispid 203;
    property Bewegungsart: Integer readonly dispid 204;
    property Einheit: Integer readonly dispid 205;
    property Buchkenner: Integer readonly dispid 206;
    property BuchJournalZeile: Integer readonly dispid 207;
  end;

// *********************************************************************//
// Interface: IKreditkarte
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A9F5CAD6-AE63-4BB1-8028-12F9A32F5EC5}
// *********************************************************************//
  IKreditkarte = interface(IDispatch)
    ['{A9F5CAD6-AE63-4BB1-8028-12F9A32F5EC5}']
    function Get_Marke: Integer; safecall;
    function Get_Nummer: WideString; safecall;
    function Get_CVC: WideString; safecall;
    function Get_GueltigBis: TDateTime; safecall;
    function Get_Inhaber: WideString; safecall;
    property Marke: Integer read Get_Marke;
    property Nummer: WideString read Get_Nummer;
    property CVC: WideString read Get_CVC;
    property GueltigBis: TDateTime read Get_GueltigBis;
    property Inhaber: WideString read Get_Inhaber;
  end;

// *********************************************************************//
// DispIntf:  IKreditkarteDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A9F5CAD6-AE63-4BB1-8028-12F9A32F5EC5}
// *********************************************************************//
  IKreditkarteDisp = dispinterface
    ['{A9F5CAD6-AE63-4BB1-8028-12F9A32F5EC5}']
    property Marke: Integer readonly dispid 201;
    property Nummer: WideString readonly dispid 202;
    property CVC: WideString readonly dispid 203;
    property GueltigBis: TDateTime readonly dispid 204;
    property Inhaber: WideString readonly dispid 205;
  end;

// *********************************************************************//
// Interface: IVerteilung
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E5014709-DDF1-4613-A69C-9B225A2A6ECA}
// *********************************************************************//
  IVerteilung = interface(IDispatch)
    ['{E5014709-DDF1-4613-A69C-9B225A2A6ECA}']
    function Navigate: INavigate; safecall;
    function Get_vertIsKostenstelle: WordBool; safecall;
    function Get_vertStTr: Integer; safecall;
    function Get_empfIsKostenstelle: WordBool; safecall;
    function Get_empfStTr: Integer; safecall;
    function Get_Kostenart: Integer; safecall;
    function Get_Betrag: Currency; safecall;
    function Get_BGS: Integer; safecall;
    function Get_Monat: Integer; safecall;
    function Get_FixVar: Integer; safecall;
    property vertIsKostenstelle: WordBool read Get_vertIsKostenstelle;
    property vertStTr: Integer read Get_vertStTr;
    property empfIsKostenstelle: WordBool read Get_empfIsKostenstelle;
    property empfStTr: Integer read Get_empfStTr;
    property Kostenart: Integer read Get_Kostenart;
    property Betrag: Currency read Get_Betrag;
    property BGS: Integer read Get_BGS;
    property Monat: Integer read Get_Monat;
    property FixVar: Integer read Get_FixVar;
  end;

// *********************************************************************//
// DispIntf:  IVerteilungDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E5014709-DDF1-4613-A69C-9B225A2A6ECA}
// *********************************************************************//
  IVerteilungDisp = dispinterface
    ['{E5014709-DDF1-4613-A69C-9B225A2A6ECA}']
    function Navigate: INavigate; dispid 201;
    property vertIsKostenstelle: WordBool readonly dispid 202;
    property vertStTr: Integer readonly dispid 203;
    property empfIsKostenstelle: WordBool readonly dispid 204;
    property empfStTr: Integer readonly dispid 205;
    property Kostenart: Integer readonly dispid 206;
    property Betrag: Currency readonly dispid 207;
    property BGS: Integer readonly dispid 208;
    property Monat: Integer readonly dispid 209;
    property FixVar: Integer readonly dispid 210;
  end;

// *********************************************************************//
// Interface: IElster
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92B40CEE-D6CA-4683-AE0F-018476E8F954}
// *********************************************************************//
  IElster = interface(IDispatch)
    ['{92B40CEE-D6CA-4683-AE0F-018476E8F954}']
    function LoadElsterFile(const Filename: WideString; IsDelete: WordBool): OleVariant; safecall;
    procedure SaveElsterFile(const Filename: WideString; Data: OleVariant); safecall;
    function GetElsterFileList: WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IElsterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {92B40CEE-D6CA-4683-AE0F-018476E8F954}
// *********************************************************************//
  IElsterDisp = dispinterface
    ['{92B40CEE-D6CA-4683-AE0F-018476E8F954}']
    function LoadElsterFile(const Filename: WideString; IsDelete: WordBool): OleVariant; dispid 202;
    procedure SaveElsterFile(const Filename: WideString; Data: OleVariant); dispid 203;
    function GetElsterFileList: WideString; dispid 201;
  end;

// *********************************************************************//
// Interface: IKLRAutomatik
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D870FD19-3731-4A17-BA47-41FF41C4DD62}
// *********************************************************************//
  IKLRAutomatik = interface(IDispatch)
    ['{D870FD19-3731-4A17-BA47-41FF41C4DD62}']
    function Navigate: INavigate; safecall;
    function Get_Nummer: Integer; safecall;
    function Get_Bezeichnung: WideString; safecall;
    function Get_KurzBez: WideString; safecall;
    function Get_IsSachkonto: WordBool; safecall;
    function Get_IsDebitor: WordBool; safecall;
    function Get_IsKreditor: WordBool; safecall;
    property Nummer: Integer read Get_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung;
    property KurzBez: WideString read Get_KurzBez;
    property IsSachkonto: WordBool read Get_IsSachkonto;
    property IsDebitor: WordBool read Get_IsDebitor;
    property IsKreditor: WordBool read Get_IsKreditor;
  end;

// *********************************************************************//
// DispIntf:  IKLRAutomatikDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D870FD19-3731-4A17-BA47-41FF41C4DD62}
// *********************************************************************//
  IKLRAutomatikDisp = dispinterface
    ['{D870FD19-3731-4A17-BA47-41FF41C4DD62}']
    function Navigate: INavigate; dispid 201;
    property Nummer: Integer readonly dispid 202;
    property Bezeichnung: WideString readonly dispid 203;
    property KurzBez: WideString readonly dispid 204;
    property IsSachkonto: WordBool readonly dispid 205;
    property IsDebitor: WordBool readonly dispid 206;
    property IsKreditor: WordBool readonly dispid 207;
  end;

// *********************************************************************//
// Die Klasse CoFNFactory stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IFNFactory, dargestellt
// von CoClass FNFactory, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoFNFactory = class
    class function Create: IFNFactory;
    class function CreateRemote(const MachineName: string): IFNFactory;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TFNFactory
// Hilfe-String      : Konten Objekt
// Standard-Interface: IFNFactory
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TFNFactory = class(TOleServer)
  private
    FIntf: IFNFactory;
    function GetDefaultInterface: IFNFactory;
  protected
    procedure InitServerData; override;
    function Get_Buchdatum: TDateTime;
    procedure Set_Buchdatum(Value: TDateTime);
    function Get_Separator: WideString;
    procedure Set_Separator(const Value: WideString);
    function Get_Stapelstatus: WordBool;
    procedure Set_Stapelstatus(Value: WordBool);
    function Get_ClientComputerName: WideString;
    procedure Set_ClientComputerName(const Value: WideString);
    function Get_Wirtschaftsjahr(Datum: TDateTime): Integer;
    function Get_Releasestand: Integer;
    function Get_ServerLog: WideString;
    function Get_WirtschaftsjahrAnfang(Datum: TDateTime): TDateTime;
    function Get_WirtschaftsjahrEnde(Datum: TDateTime): TDateTime;
    function Get_DatenIdentitaet: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFNFactory);
    procedure Disconnect; override;
    function Mandant: IMandant;
    function GetSalden(VonKonto: Integer; BisKonto: Integer; OhneSaldo: WordBool): OleVariant;
    function GetOp(VonKonto: Integer; BisKonto: Integer; AllePosten: WordBool): OleVariant;
    function GetJrnRows(VonKonto: Integer; BisKonto: Integer; VonJrnRow: Integer; BisJrnRow: Integer): OleVariant;
    function GetAdresse(VonKonto: Integer; BisKonto: Integer): OleVariant;
    function Buchen: IBuchen;
    function GetKreditversicherung(VonKonto: Integer; BisKonto: Integer; MitSaldo: WordBool): OleVariant;
    function GetSachkonto(VonKonto: Integer; BisKonto: Integer): OleVariant;
    function GetKostenstelle(VonKSt: Integer; BisKSt: Integer): OleVariant;
    function GetKostentraeger(VonKTr: Integer; BisKTr: Integer): OleVariant;
    function GetKostenart(VonKArt: Integer; BisKArt: Integer): OleVariant;
    function User: IUser;
    function Finanzamt: IFinanzamt;
    function Bank: IBank;
    function ChooseMandant: IChooseMandant;
    function Passwort: IPasswort;
    function CheckUStIdNr(const IdNr: WideString): WordBool;
    function Ort: IOrt;
    function Lizenz: ILizenz;
    function BatchScript: IBatchScript;
    function Server: IServer;
    function Branche: IBranche;
    function Land: ILand;
    function Waehrung: IWaehrung;
    function EGSteuer: IEGSteuer;
    function Elster: IElster;
    procedure SetCurrentOrMaxDate;
    function GetZahlartBez(Nr: Integer): WideString;
    property DefaultInterface: IFNFactory read GetDefaultInterface;
    property Wirtschaftsjahr[Datum: TDateTime]: Integer read Get_Wirtschaftsjahr;
    property Releasestand: Integer read Get_Releasestand;
    property ServerLog: WideString read Get_ServerLog;
    property WirtschaftsjahrAnfang[Datum: TDateTime]: TDateTime read Get_WirtschaftsjahrAnfang;
    property WirtschaftsjahrEnde[Datum: TDateTime]: TDateTime read Get_WirtschaftsjahrEnde;
    property DatenIdentitaet: WideString read Get_DatenIdentitaet;
    property Buchdatum: TDateTime read Get_Buchdatum write Set_Buchdatum;
    property Separator: WideString read Get_Separator write Set_Separator;
    property Stapelstatus: WordBool read Get_Stapelstatus write Set_Stapelstatus;
    property ClientComputerName: WideString read Get_ClientComputerName write Set_ClientComputerName;
  published
  end;

// *********************************************************************//
// Die Klasse CoUser stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IUser, dargestellt
// von CoClass User, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoUser = class
    class function Create: IUser;
    class function CreateRemote(const MachineName: string): IUser;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TUser
// Hilfe-String      : User Objekt
// Standard-Interface: IUser
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TUser = class(TOleServer)
  private
    FIntf: IUser;
    function GetDefaultInterface: IUser;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    procedure Set_Nummer(Value: Integer);
    function Get_Benutzer: WideString;
    procedure Set_Benutzer(const Value: WideString);
    function Get_Abteilung: WideString;
    procedure Set_Abteilung(const Value: WideString);
    function Get_Info(Nr: Integer): WideString;
    procedure Set_Info(Nr: Integer; const Value: WideString);
    function Get_Info1: WideString;
    procedure Set_Info1(const Value: WideString);
    function Get_Info2: WideString;
    procedure Set_Info2(const Value: WideString);
    function Get_DefaultPort: Integer;
    procedure Set_DefaultPort(Value: Integer);
    function Get_PruefzeitraumVon: TDateTime;
    function Get_PruefzeitraumBis: TDateTime;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IUser);
    procedure Disconnect; override;
    function Anmeldung(const Server: WideString; const Benutzer: WideString; 
                       const Passwort: WideString): WideString;
    function Adresse: IAdresse;
    function DefaultBenutzer: WideString;
    function DefaultServer: WideString;
    property DefaultInterface: IUser read GetDefaultInterface;
    property Info[Nr: Integer]: WideString read Get_Info write Set_Info;
    property PruefzeitraumVon: TDateTime read Get_PruefzeitraumVon;
    property PruefzeitraumBis: TDateTime read Get_PruefzeitraumBis;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Benutzer: WideString read Get_Benutzer write Set_Benutzer;
    property Abteilung: WideString read Get_Abteilung write Set_Abteilung;
    property Info1: WideString read Get_Info1 write Set_Info1;
    property Info2: WideString read Get_Info2 write Set_Info2;
    property DefaultPort: Integer read Get_DefaultPort write Set_DefaultPort;
  published
  end;

// *********************************************************************//
// Die Klasse CoMandant stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IMandant, dargestellt
// von CoClass Mandant, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoMandant = class
    class function Create: IMandant;
    class function CreateRemote(const MachineName: string): IMandant;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TMandant
// Hilfe-String      : Mandant Objekt
// Standard-Interface: IMandant
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TMandant = class(TOleServer)
  private
    FIntf: IMandant;
    function GetDefaultInterface: IMandant;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    procedure Set_Nummer(Value: Integer);
    function Get_Bezeichnung: WideString;
    procedure Set_Bezeichnung(const Value: WideString);
    function Get_aktlWiJahr: Integer;
    procedure Set_aktlWiJahr(Value: Integer);
    function Get_letzteMonatWiJahr: Integer;
    procedure Set_letzteMonatWiJahr(Value: Integer);
    function Get_RumpfWiJahrAnfang: TDateTime;
    procedure Set_RumpfWiJahrAnfang(Value: TDateTime);
    function Get_RumpfWiJahrEnde: TDateTime;
    procedure Set_RumpfWiJahrEnde(Value: TDateTime);
    function Get_AbwMdNrStB: Integer;
    procedure Set_AbwMdNrStB(Value: Integer);
    function Get_Steuernummer: WideString;
    procedure Set_Steuernummer(const Value: WideString);
    function Get_ISOHausWaehrBez: WideString;
    function Get_UStVAZeitraum: Integer;
    function Get_INIDatei: WideString;
    procedure Set_INIDatei(const Value: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMandant);
    procedure Disconnect; override;
    function Adresse: IAdresse;
    function Debitor: IDebitor;
    function Kreditor: IKreditor;
    function Sachkonto: ISachkonto;
    function Journal(WiJ: Integer): IJournal;
    function KLRJournal(WiJ: Integer): IKLRJournal;
    function Festkonto: IFestkonto;
    function Buchtext: IBuchtext;
    function Steuer: ISteuer;
    function Finanzamt: IFinanzamt;
    function Kontenbereich: IKontenbereich;
    function Kostenart: IKostenart;
    function Kostenstelle: IKostenstelle;
    function Kostentraeger: Kostentraeger;
    function Bezugsgroesse: IBezugsgroesse;
    function FNReport: IFNReport;
    function Posten(KontoTyp: EKontotypen; AllePosten: WordBool): IPosten;
    function Kostenstelleart: IKostenstelleart;
    function Kostentraegerart: Kostentraegerart;
    function Kostenartstelle: Kostenartstelle;
    function Kostenarttraeger: Kostenarttraeger;
    function REB(IsGebucht: WordBool): IREB;
    function Archivierung: IArchivierung;
    function BgMw(IsPlan: WordBool; IsKTr: WordBool): IBgMw;
    function XML: IXML;
    function DCUebFiles: IDCUebFiles;
    function BgBeweg(IsPlan: WordBool): IBgBeweg;
    function Inventar: IInventar;
    function Waehrung: IWaehrung;
    function USGAAPPos: IGruppe;
    function HGBPos: IGruppe;
    function Wechsel: IWechsel;
    function Tageskurs(WaNr: Integer): ITageskurs;
    function GetKontoRechte(KtNr: Integer; KtTyp: EKontotypen): EKontoRechte;
    function Scheck: IScheck;
    function InventarJournal(EbeneNr: EInventarebenen): IInventarJournal;
    function Verteilung(VonMonat: Integer; BisMonat: Integer; vertKLRTyp: Integer; 
                        empfKLRTyp: Integer; VonKArt: Integer; BisKArt: Integer; BGNummer: Integer; 
                        FixVar: Integer): IVerteilung;
    function KontoGruppe: IGruppe;
    function InventarGruppe: IGruppe;
    function KLRGruppe: IGruppe;
    function KLRAutomatik: IKLRAutomatik;
    function KLRJrnKStKTr(WiJ: Integer): IKLRJournal;
    property DefaultInterface: IMandant read GetDefaultInterface;
    property ISOHausWaehrBez: WideString read Get_ISOHausWaehrBez;
    property UStVAZeitraum: Integer read Get_UStVAZeitraum;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property aktlWiJahr: Integer read Get_aktlWiJahr write Set_aktlWiJahr;
    property letzteMonatWiJahr: Integer read Get_letzteMonatWiJahr write Set_letzteMonatWiJahr;
    property RumpfWiJahrAnfang: TDateTime read Get_RumpfWiJahrAnfang write Set_RumpfWiJahrAnfang;
    property RumpfWiJahrEnde: TDateTime read Get_RumpfWiJahrEnde write Set_RumpfWiJahrEnde;
    property AbwMdNrStB: Integer read Get_AbwMdNrStB write Set_AbwMdNrStB;
    property Steuernummer: WideString read Get_Steuernummer write Set_Steuernummer;
    property INIDatei: WideString read Get_INIDatei write Set_INIDatei;
  published
  end;

// *********************************************************************//
// Die Klasse CoAdresse stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IAdresse, dargestellt
// von CoClass Adresse, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoAdresse = class
    class function Create: IAdresse;
    class function CreateRemote(const MachineName: string): IAdresse;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TAdresse
// Hilfe-String      : Adresse Objekt
// Standard-Interface: IAdresse
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TAdresse = class(TOleServer)
  private
    FIntf: IAdresse;
    function GetDefaultInterface: IAdresse;
  protected
    procedure InitServerData; override;
    function Get_Name(Nr: Integer): WideString;
    procedure Set_Name(Nr: Integer; const Value: WideString);
    function Get_Name1: WideString;
    procedure Set_Name1(const Value: WideString);
    function Get_Name2: WideString;
    procedure Set_Name2(const Value: WideString);
    function Get_Name3: WideString;
    procedure Set_Name3(const Value: WideString);
    function Get_Strasse(Nr: Integer): WideString;
    procedure Set_Strasse(Nr: Integer; const Value: WideString);
    function Get_PLZ: WideString;
    procedure Set_PLZ(const Value: WideString);
    function Get_Ort: WideString;
    procedure Set_Ort(const Value: WideString);
    function Get_Telefon: WideString;
    procedure Set_Telefon(const Value: WideString);
    function Get_Fax: WideString;
    procedure Set_Fax(const Value: WideString);
    function Get_Mail: WideString;
    procedure Set_Mail(const Value: WideString);
    function Get_Anrede: WideString;
    function Get_PLZ2: WideString;
    procedure Set_PLZ2(const Value: WideString);
    function Get_Postfach: WideString;
    procedure Set_Postfach(const Value: WideString);
    function Get_Strasse1: WideString;
    procedure Set_Strasse1(const Value: WideString);
    function Get_Strasse2: WideString;
    procedure Set_Strasse2(const Value: WideString);
    function Get_UStIdNr: WideString;
    function Get_Lkz: WideString;
    function Get_Mobiltelefon: WideString;
    function Get_Steuernummer: WideString;
    procedure Set_Steuernummer(const Value: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IAdresse);
    procedure Disconnect; override;
    function Land: ILand;
    function AsRecord: RAdresse;
    property DefaultInterface: IAdresse read GetDefaultInterface;
    property Name[Nr: Integer]: WideString read Get_Name write Set_Name;
    property Strasse[Nr: Integer]: WideString read Get_Strasse write Set_Strasse;
    property Anrede: WideString read Get_Anrede;
    property UStIdNr: WideString read Get_UStIdNr;
    property Lkz: WideString read Get_Lkz;
    property Mobiltelefon: WideString read Get_Mobiltelefon;
    property Name1: WideString read Get_Name1 write Set_Name1;
    property Name2: WideString read Get_Name2 write Set_Name2;
    property Name3: WideString read Get_Name3 write Set_Name3;
    property PLZ: WideString read Get_PLZ write Set_PLZ;
    property Ort: WideString read Get_Ort write Set_Ort;
    property Telefon: WideString read Get_Telefon write Set_Telefon;
    property Fax: WideString read Get_Fax write Set_Fax;
    property Mail: WideString read Get_Mail write Set_Mail;
    property PLZ2: WideString read Get_PLZ2 write Set_PLZ2;
    property Postfach: WideString read Get_Postfach write Set_Postfach;
    property Strasse1: WideString read Get_Strasse1 write Set_Strasse1;
    property Strasse2: WideString read Get_Strasse2 write Set_Strasse2;
    property Steuernummer: WideString read Get_Steuernummer write Set_Steuernummer;
  published
  end;

// *********************************************************************//
// Die Klasse CoLand stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface ILand, dargestellt
// von CoClass Land, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoLand = class
    class function Create: ILand;
    class function CreateRemote(const MachineName: string): ILand;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TLand
// Hilfe-String      : Land Objekt
// Standard-Interface: ILand
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TLand = class(TOleServer)
  private
    FIntf: ILand;
    function GetDefaultInterface: ILand;
  protected
    procedure InitServerData; override;
    function Get_Lkz: WideString;
    procedure Set_Lkz(const Value: WideString);
    function Get_Bezeichnung(Nr: Integer): WideString;
    procedure Set_Bezeichnung(Nr: Integer; const Value: WideString);
    function Get_Bezeichnung1: WideString;
    procedure Set_Bezeichnung1(const Value: WideString);
    function Get_Bezeichnung2: WideString;
    procedure Set_Bezeichnung2(const Value: WideString);
    function Get_WaehrName: WideString;
    procedure Set_WaehrName(const Value: WideString);
    function Get_Hauptstadt: WideString;
    procedure Set_Hauptstadt(const Value: WideString);
    function Get_EUMitgliedSeit: TDateTime;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ILand);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function IsEG: WordBool;
    property DefaultInterface: ILand read GetDefaultInterface;
    property Bezeichnung[Nr: Integer]: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property EUMitgliedSeit: TDateTime read Get_EUMitgliedSeit;
    property Lkz: WideString read Get_Lkz write Set_Lkz;
    property Bezeichnung1: WideString read Get_Bezeichnung1 write Set_Bezeichnung1;
    property Bezeichnung2: WideString read Get_Bezeichnung2 write Set_Bezeichnung2;
    property WaehrName: WideString read Get_WaehrName write Set_WaehrName;
    property Hauptstadt: WideString read Get_Hauptstadt write Set_Hauptstadt;
  published
  end;

// *********************************************************************//
// Die Klasse CoDebitor stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IDebitor, dargestellt
// von CoClass Debitor, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoDebitor = class
    class function Create: IDebitor;
    class function CreateRemote(const MachineName: string): IDebitor;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TDebitor
// Hilfe-String      : Debitor Objekt
// Standard-Interface: IDebitor
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TDebitor = class(TOleServer)
  private
    FIntf: IDebitor;
    function GetDefaultInterface: IDebitor;
  protected
    procedure InitServerData; override;
    function Get_Kontonummer: Integer;
    procedure Set_Kontonummer(Value: Integer);
    function Get_InlEuroDritt: Integer;
    procedure Set_InlEuroDritt(Value: Integer);
    function Get_Zahlart: EZahlarten;
    function Get_Zahlkondition: IZahlkondition;
    function Get_Kundennummer: WideString;
    function Get_Vertreternummer: Integer;
    function Get_Konzern: Integer;
    function Get_NummerBeimPartner: WideString;
    function Get_Gebietsnummer: Integer;
    function Get_MahnkulanzBetrag: Currency;
    function Get_MahnkulanzBis: TDateTime;
    function Get_MahnstopBis: TDateTime;
    function Get_Steuernummer: WideString;
    function Get_HR_Nummer: WideString;
    function Get_HR_Ort: WideString;
    function Get_ZdDatum: TDateTime;
    function Get_ZdZeitraumVon: TDateTime;
    function Get_ZdZeitraumBis: TDateTime;
    function Get_Zahldauer: Integer;
    function Get_ReGesamtAnzahl: Integer;
    function Get_ReGesamtUmsatz: Currency;
    function Get_ReGesamtSkonto: Currency;
    function Get_IsZentralregulierer: WordBool;
    function Get_ZentRegKontonummer: Integer;
    function Get_ZentRegReferenzNr: WideString;
    function Get_Vorwahl: WideString;
    function Get_Rufnummer: WideString;
    function Get_Ansprechpartner: WideString;
    function Get_Geburtstag: TDateTime;
    function Get_Rechtsform: Integer;
    function Get_GegenKonto: Integer;
    function Get_AbwSammelKt: Integer;
    function Get_AbwSkontoKt: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDebitor);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Konto: IKonto;
    function Adresse: IAdresse;
    function Vertreter: IKreditor;
    function Bankverbindung: IBankverbindung;
    function Kreditversicherung: IKreditversicherung;
    function Rabatt(Index: Integer): Currency;
    function Kreditkarte: IKreditkarte;
    property DefaultInterface: IDebitor read GetDefaultInterface;
    property Zahlart: EZahlarten read Get_Zahlart;
    property Zahlkondition: IZahlkondition read Get_Zahlkondition;
    property Kundennummer: WideString read Get_Kundennummer;
    property Vertreternummer: Integer read Get_Vertreternummer;
    property Konzern: Integer read Get_Konzern;
    property NummerBeimPartner: WideString read Get_NummerBeimPartner;
    property Gebietsnummer: Integer read Get_Gebietsnummer;
    property MahnkulanzBetrag: Currency read Get_MahnkulanzBetrag;
    property MahnkulanzBis: TDateTime read Get_MahnkulanzBis;
    property MahnstopBis: TDateTime read Get_MahnstopBis;
    property Steuernummer: WideString read Get_Steuernummer;
    property HR_Nummer: WideString read Get_HR_Nummer;
    property HR_Ort: WideString read Get_HR_Ort;
    property ZdDatum: TDateTime read Get_ZdDatum;
    property ZdZeitraumVon: TDateTime read Get_ZdZeitraumVon;
    property ZdZeitraumBis: TDateTime read Get_ZdZeitraumBis;
    property Zahldauer: Integer read Get_Zahldauer;
    property ReGesamtAnzahl: Integer read Get_ReGesamtAnzahl;
    property ReGesamtUmsatz: Currency read Get_ReGesamtUmsatz;
    property ReGesamtSkonto: Currency read Get_ReGesamtSkonto;
    property IsZentralregulierer: WordBool read Get_IsZentralregulierer;
    property ZentRegKontonummer: Integer read Get_ZentRegKontonummer;
    property ZentRegReferenzNr: WideString read Get_ZentRegReferenzNr;
    property Vorwahl: WideString read Get_Vorwahl;
    property Rufnummer: WideString read Get_Rufnummer;
    property Ansprechpartner: WideString read Get_Ansprechpartner;
    property Geburtstag: TDateTime read Get_Geburtstag;
    property Rechtsform: Integer read Get_Rechtsform;
    property GegenKonto: Integer read Get_GegenKonto;
    property AbwSammelKt: Integer read Get_AbwSammelKt;
    property AbwSkontoKt: Integer read Get_AbwSkontoKt;
    property Kontonummer: Integer read Get_Kontonummer write Set_Kontonummer;
    property InlEuroDritt: Integer read Get_InlEuroDritt write Set_InlEuroDritt;
  published
  end;

// *********************************************************************//
// Die Klasse CoKonto stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKonto, dargestellt
// von CoClass Konto, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKonto = class
    class function Create: IKonto;
    class function CreateRemote(const MachineName: string): IKonto;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKonto
// Hilfe-String      : Konto Objekt
// Standard-Interface: IKonto
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TKonto = class(TOleServer)
  private
    FIntf: IKonto;
    function GetDefaultInterface: IKonto;
  protected
    procedure InitServerData; override;
    function Get_Bezeichnung(Nr: Integer): WideString;
    procedure Set_Bezeichnung(Nr: Integer; const Value: WideString);
    function Get_Bezeichnung1: WideString;
    procedure Set_Bezeichnung1(const Value: WideString);
    function Get_Bezeichnung2: WideString;
    procedure Set_Bezeichnung2(const Value: WideString);
    function Get_Aenderungsdatum: TDateTime;
    function Get_Anlagedatum: TDateTime;
    function Get_GueltigBis: TDateTime;
    function Get_Waehrungsnummer: Integer;
    function Get_OPVerwaltungsart: Integer;
    function Get_AlteKontonummer: Integer;
    function Get_GueltigAb: TDateTime;
    function Get_Sperre: Integer;
    function Get_AccessDenied: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKonto);
    procedure Disconnect; override;
    function Nummer: Integer;
    function IsBebucht: WordBool;
    function IsOP: WordBool;
    function MitOpVerwaltung: WordBool;
    function Journal: IJournal;
    function Posten(AllePosten: WordBool): IPosten;
    function Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo;
    function GrpNummer(Nr: Integer): Integer;
    property DefaultInterface: IKonto read GetDefaultInterface;
    property Bezeichnung[Nr: Integer]: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property Aenderungsdatum: TDateTime read Get_Aenderungsdatum;
    property Anlagedatum: TDateTime read Get_Anlagedatum;
    property GueltigBis: TDateTime read Get_GueltigBis;
    property Waehrungsnummer: Integer read Get_Waehrungsnummer;
    property OPVerwaltungsart: Integer read Get_OPVerwaltungsart;
    property AlteKontonummer: Integer read Get_AlteKontonummer;
    property GueltigAb: TDateTime read Get_GueltigAb;
    property Sperre: Integer read Get_Sperre;
    property AccessDenied: WordBool read Get_AccessDenied;
    property Bezeichnung1: WideString read Get_Bezeichnung1 write Set_Bezeichnung1;
    property Bezeichnung2: WideString read Get_Bezeichnung2 write Set_Bezeichnung2;
  published
  end;

// *********************************************************************//
// Die Klasse CoSaldo stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface ISaldo, dargestellt
// von CoClass Saldo, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoSaldo = class
    class function Create: ISaldo;
    class function CreateRemote(const MachineName: string): ISaldo;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TSaldo
// Hilfe-String      : Saldo Objekt
// Standard-Interface: ISaldo
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TSaldo = class(TOleServer)
  private
    FIntf: ISaldo;
    function GetDefaultInterface: ISaldo;
  protected
    procedure InitServerData; override;
    function Get_MVZ(SollHaben: Integer; Monat: Integer): Currency;
    function Get_EB: Currency;
    function Get_MVZS(Monat: Integer): Currency;
    function Get_MVZH(Monat: Integer): Currency;
    function Get_JVZS: Currency;
    function Get_JVZH: Currency;
    function Get_Saldo: Currency;
    function Get_Monatswert(Zeile: Integer; Monat: Integer): Currency;
    function Get_IstPlan: Integer;
    procedure Set_IstPlan(Value: Integer);
    function Get_Fixekosten(Monat: Integer): Currency;
    function Get_Variablekosten(Monat: Integer): Currency;
    function Get_Leistung(Monat: Integer): Currency;
    function Get_ISOWaehrBez: WideString;
    function Get_Tagesdatum: TDateTime;
    procedure Set_Tagesdatum(Value: TDateTime);
    function Get_IsBuchungsstapel: WordBool;
    procedure Set_IsBuchungsstapel(Value: WordBool);
    function Get_Wirtschaftsjahr: Integer;
    procedure Set_Wirtschaftsjahr(Value: Integer);
    function Get_DatumTyp: Integer;
    procedure Set_DatumTyp(Value: Integer);
    function Get_IsWiMonat: WordBool;
    procedure Set_IsWiMonat(Value: WordBool);
    function Get_IsMVZKumuliert: WordBool;
    procedure Set_IsMVZKumuliert(Value: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISaldo);
    procedure Disconnect; override;
    function Nummer: Integer;
    function AccessDenied: WordBool;
    function Kostenart: Integer;
    property DefaultInterface: ISaldo read GetDefaultInterface;
    property MVZ[SollHaben: Integer; Monat: Integer]: Currency read Get_MVZ;
    property EB: Currency read Get_EB;
    property MVZS[Monat: Integer]: Currency read Get_MVZS;
    property MVZH[Monat: Integer]: Currency read Get_MVZH;
    property JVZS: Currency read Get_JVZS;
    property JVZH: Currency read Get_JVZH;
    property Saldo: Currency read Get_Saldo;
    property Monatswert[Zeile: Integer; Monat: Integer]: Currency read Get_Monatswert;
    property Fixekosten[Monat: Integer]: Currency read Get_Fixekosten;
    property Variablekosten[Monat: Integer]: Currency read Get_Variablekosten;
    property Leistung[Monat: Integer]: Currency read Get_Leistung;
    property ISOWaehrBez: WideString read Get_ISOWaehrBez;
    property IstPlan: Integer read Get_IstPlan write Set_IstPlan;
    property Tagesdatum: TDateTime read Get_Tagesdatum write Set_Tagesdatum;
    property IsBuchungsstapel: WordBool read Get_IsBuchungsstapel write Set_IsBuchungsstapel;
    property Wirtschaftsjahr: Integer read Get_Wirtschaftsjahr write Set_Wirtschaftsjahr;
    property DatumTyp: Integer read Get_DatumTyp write Set_DatumTyp;
    property IsWiMonat: WordBool read Get_IsWiMonat write Set_IsWiMonat;
    property IsMVZKumuliert: WordBool read Get_IsMVZKumuliert write Set_IsMVZKumuliert;
  published
  end;

// *********************************************************************//
// Die Klasse CoPosten stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IPosten, dargestellt
// von CoClass Posten, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoPosten = class
    class function Create: IPosten;
    class function CreateRemote(const MachineName: string): IPosten;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TPosten
// Hilfe-String      : Posten Objekt
// Standard-Interface: IPosten
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TPosten = class(TOleServer)
  private
    FIntf: IPosten;
    function GetDefaultInterface: IPosten;
  protected
    procedure InitServerData; override;
    function Get_Postenart: Integer;
    procedure Set_Postenart(Value: Integer);
    function Get_PostenArtBez: WideString;
    function Get_Valutadatum: TDateTime;
    procedure Set_Valutadatum(Value: TDateTime);
    function Get_Zahlart: EZahlarten;
    procedure Set_Zahlart(Value: EZahlarten);
    function Get_Skontofaktor: Double;
    procedure Set_Skontofaktor(Value: Double);
    function Get_Skontogezogen: Currency;
    procedure Set_Skontogezogen(Value: Currency);
    function Get_IsBezahlt: WordBool;
    procedure Set_IsBezahlt(Value: WordBool);
    function Get_BezahltDatum: TDateTime;
    procedure Set_BezahltDatum(Value: TDateTime);
    function Get_IsPostenausgleich: WordBool;
    function Get_IsAnzahlung: WordBool;
    procedure Set_IsAnzahlung(Value: WordBool);
    function Get_Postennummer: Integer;
    function Get_BuchJournalZeile: Integer;
    function Get_KLRJournalZeile: Integer;
    function Get_WiJ: Integer;
    function Get_ZugeordnetPostenJournalZeile: Integer;
    function Get_Kursdifferenz: Currency;
    function Get_IsPicture: WordBool;
    function Get_ZinsDatum: TDateTime;
    function Get_KlrWiJ: Integer;
    function Get_OpJrnZlVorjahr: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IPosten);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Kontierung: IKontierung;
    function Buchung: IJournal;
    function USt: IUSt;
    function Kurs: IKurs;
    function Mahn: IMahn;
    function Zahlkondition: IZahlkondition;
    function ZugeordnetPosten: IPosten;
    property DefaultInterface: IPosten read GetDefaultInterface;
    property PostenArtBez: WideString read Get_PostenArtBez;
    property IsPostenausgleich: WordBool read Get_IsPostenausgleich;
    property Postennummer: Integer read Get_Postennummer;
    property BuchJournalZeile: Integer read Get_BuchJournalZeile;
    property KLRJournalZeile: Integer read Get_KLRJournalZeile;
    property WiJ: Integer read Get_WiJ;
    property ZugeordnetPostenJournalZeile: Integer read Get_ZugeordnetPostenJournalZeile;
    property Kursdifferenz: Currency read Get_Kursdifferenz;
    property IsPicture: WordBool read Get_IsPicture;
    property ZinsDatum: TDateTime read Get_ZinsDatum;
    property KlrWiJ: Integer read Get_KlrWiJ;
    property OpJrnZlVorjahr: Integer read Get_OpJrnZlVorjahr;
    property Postenart: Integer read Get_Postenart write Set_Postenart;
    property Valutadatum: TDateTime read Get_Valutadatum write Set_Valutadatum;
    property Zahlart: EZahlarten read Get_Zahlart write Set_Zahlart;
    property Skontofaktor: Double read Get_Skontofaktor write Set_Skontofaktor;
    property Skontogezogen: Currency read Get_Skontogezogen write Set_Skontogezogen;
    property IsBezahlt: WordBool read Get_IsBezahlt write Set_IsBezahlt;
    property BezahltDatum: TDateTime read Get_BezahltDatum write Set_BezahltDatum;
    property IsAnzahlung: WordBool read Get_IsAnzahlung write Set_IsAnzahlung;
  published
  end;

// *********************************************************************//
// Die Klasse CoNavigate stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface INavigate, dargestellt
// von CoClass Navigate, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoNavigate = class
    class function Create: INavigate;
    class function CreateRemote(const MachineName: string): INavigate;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TNavigate
// Hilfe-String      : Navigate Objekt
// Standard-Interface: INavigate
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TNavigate = class(TOleServer)
  private
    FIntf: INavigate;
    function GetDefaultInterface: INavigate;
  protected
    procedure InitServerData; override;
    function Get_Current: Integer;
    procedure Set_Current(Value: Integer);
    function Get_Memotext: WideString;
    function Get_IsMemotext: WordBool;
    function Get_CacheSizeMB: Integer;
    procedure Set_CacheSizeMB(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: INavigate);
    procedure Disconnect; override;
    function Count: Integer;
    function First: WordBool;
    function Last: WordBool;
    function Next: WordBool;
    function Previous: WordBool;
    function EOF: WordBool;
    function BOF: WordBool;
    property DefaultInterface: INavigate read GetDefaultInterface;
    property Memotext: WideString read Get_Memotext;
    property IsMemotext: WordBool read Get_IsMemotext;
    property Current: Integer read Get_Current write Set_Current;
    property CacheSizeMB: Integer read Get_CacheSizeMB write Set_CacheSizeMB;
  published
  end;

// *********************************************************************//
// Die Klasse CoKontierung stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKontierung, dargestellt
// von CoClass Kontierung, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKontierung = class
    class function Create: IKontierung;
    class function CreateRemote(const MachineName: string): IKontierung;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKontierung
// Hilfe-String      : Kontierung Objekt
// Standard-Interface: IKontierung
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TKontierung = class(TOleServer)
  private
    FIntf: IKontierung;
    function GetDefaultInterface: IKontierung;
  protected
    procedure InitServerData; override;
    function Get_Journalzeile: Integer;
    function Get_Betrag: Currency;
    procedure Set_Betrag(Value: Currency);
    function Get_Tagesdatum: TDateTime;
    procedure Set_Tagesdatum(Value: TDateTime);
    function Get_Belegdatum: TDateTime;
    procedure Set_Belegdatum(Value: TDateTime);
    function Get_Buchdatum: TDateTime;
    procedure Set_Buchdatum(Value: TDateTime);
    function Get_Belegnummer(Nr: Integer): WideString;
    procedure Set_Belegnummer(Nr: Integer; const Value: WideString);
    function Get_Belegnummer1: WideString;
    procedure Set_Belegnummer1(const Value: WideString);
    function Get_Belegnummer2: WideString;
    procedure Set_Belegnummer2(const Value: WideString);
    function Get_Buchtext: WideString;
    procedure Set_Buchtext(const Value: WideString);
    function Get_Kontonummer: Integer;
    procedure Set_Kontonummer(Value: Integer);
    function Get_GegenKonto: Integer;
    procedure Set_GegenKonto(Value: Integer);
    function Get_Benutzer: WideString;
    procedure Set_Benutzer(const Value: WideString);
    function Get_IsValid: WordBool;
    function Get_TaNr: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKontierung);
    procedure Disconnect; override;
    function AsRecord: RKontierung;
    property DefaultInterface: IKontierung read GetDefaultInterface;
    property Journalzeile: Integer read Get_Journalzeile;
    property Belegnummer[Nr: Integer]: WideString read Get_Belegnummer write Set_Belegnummer;
    property IsValid: WordBool read Get_IsValid;
    property TaNr: Integer read Get_TaNr;
    property Betrag: Currency read Get_Betrag write Set_Betrag;
    property Tagesdatum: TDateTime read Get_Tagesdatum write Set_Tagesdatum;
    property Belegdatum: TDateTime read Get_Belegdatum write Set_Belegdatum;
    property Buchdatum: TDateTime read Get_Buchdatum write Set_Buchdatum;
    property Belegnummer1: WideString read Get_Belegnummer1 write Set_Belegnummer1;
    property Belegnummer2: WideString read Get_Belegnummer2 write Set_Belegnummer2;
    property Buchtext: WideString read Get_Buchtext write Set_Buchtext;
    property Kontonummer: Integer read Get_Kontonummer write Set_Kontonummer;
    property GegenKonto: Integer read Get_GegenKonto write Set_GegenKonto;
    property Benutzer: WideString read Get_Benutzer write Set_Benutzer;
  published
  end;

// *********************************************************************//
// Die Klasse CoJournal stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IJournal, dargestellt
// von CoClass Journal, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoJournal = class
    class function Create: IJournal;
    class function CreateRemote(const MachineName: string): IJournal;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TJournal
// Hilfe-String      : Journal Objekt (Buchungen)
// Standard-Interface: IJournal
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TJournal = class(TOleServer)
  private
    FIntf: IJournal;
    function GetDefaultInterface: IJournal;
  protected
    procedure InitServerData; override;
    function Get_SollHaben: Integer;
    function Get_IsLetzteBuchung: WordBool;
    function Get_Konzern: Integer;
    function Get_UStIdNr: WideString;
    function Get_Wertstellungsdatum: TDateTime;
    function Get_Reisedatum: TDateTime;
    function Get_Steuersatz: Currency;
    function Get_KLRJournalZeile: Integer;
    function Get_PostenJournalzeile: Integer;
    function Get_IsPicture: WordBool;
    function Get_IsBarcode: WordBool;
    function Get_PictureCount: Integer;
    function Get_Inventarnummer: WideString;
    function Get_AutomatikKennz: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IJournal);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Kontierung: IKontierung;
    function USt: IUSt;
    function Kurs: IKurs;
    function AsTIF(Index: Integer): OleVariant;
    function AsBMP(Index: Integer): OleVariant;
    function AsJPG(Index: Integer): OleVariant;
    procedure TestTifPicture(const PictureName: WideString);
    property DefaultInterface: IJournal read GetDefaultInterface;
    property SollHaben: Integer read Get_SollHaben;
    property IsLetzteBuchung: WordBool read Get_IsLetzteBuchung;
    property Konzern: Integer read Get_Konzern;
    property UStIdNr: WideString read Get_UStIdNr;
    property Wertstellungsdatum: TDateTime read Get_Wertstellungsdatum;
    property Reisedatum: TDateTime read Get_Reisedatum;
    property Steuersatz: Currency read Get_Steuersatz;
    property KLRJournalZeile: Integer read Get_KLRJournalZeile;
    property PostenJournalzeile: Integer read Get_PostenJournalzeile;
    property IsPicture: WordBool read Get_IsPicture;
    property IsBarcode: WordBool read Get_IsBarcode;
    property PictureCount: Integer read Get_PictureCount;
    property Inventarnummer: WideString read Get_Inventarnummer;
    property AutomatikKennz: WideString read Get_AutomatikKennz;
  published
  end;

// *********************************************************************//
// Die Klasse CoKLRJournal stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKLRJournal, dargestellt
// von CoClass KLRJournal, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKLRJournal = class
    class function Create: IKLRJournal;
    class function CreateRemote(const MachineName: string): IKLRJournal;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKLRJournal
// Hilfe-String      : KLRJournal Objekt
// Standard-Interface: IKLRJournal
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TKLRJournal = class(TOleServer)
  private
    FIntf: IKLRJournal;
    function GetDefaultInterface: IKLRJournal;
  protected
    procedure InitServerData; override;
    function Get_FixVar: EKostentypen;
    procedure Set_FixVar(Value: EKostentypen);
    function Get_KoStTrNr: Integer;
    function Get_BuchJournalZeile: Integer;
    function Get_KArtNr: Integer;
    function Get_SollHaben: Integer;
    function Get_IsLetzteBuchung: WordBool;
    function Get_Ebene: Integer;
    function Get_GegenkontoTyp: EKontotypen;
    function Get_Herkunft: Integer;
    function Get_KTrNr: Integer;
    function Get_PostenRef: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKLRJournal);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Kontierung: IKontierung;
    function IsKostenstelle: WordBool;
    function Kostenstelle: IKostenstelle;
    function IsKostentraeger: WordBool;
    function Kostentraeger: IKostenstelle;
    function Journal: IJournal;
    function Kostenart: IKostenart;
    property DefaultInterface: IKLRJournal read GetDefaultInterface;
    property KoStTrNr: Integer read Get_KoStTrNr;
    property BuchJournalZeile: Integer read Get_BuchJournalZeile;
    property KArtNr: Integer read Get_KArtNr;
    property SollHaben: Integer read Get_SollHaben;
    property IsLetzteBuchung: WordBool read Get_IsLetzteBuchung;
    property Ebene: Integer read Get_Ebene;
    property GegenkontoTyp: EKontotypen read Get_GegenkontoTyp;
    property Herkunft: Integer read Get_Herkunft;
    property KTrNr: Integer read Get_KTrNr;
    property PostenRef: Integer read Get_PostenRef;
    property FixVar: EKostentypen read Get_FixVar write Set_FixVar;
  published
  end;

// *********************************************************************//
// Die Klasse CoFestkonto stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IFestkonto, dargestellt
// von CoClass Festkonto, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoFestkonto = class
    class function Create: IFestkonto;
    class function CreateRemote(const MachineName: string): IFestkonto;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TFestkonto
// Hilfe-String      : Festkonto Objekt
// Standard-Interface: IFestkonto
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TFestkonto = class(TOleServer)
  private
    FIntf: IFestkonto;
    function GetDefaultInterface: IFestkonto;
  protected
    procedure InitServerData; override;
    function Get_Kontonummer(Nummer: Integer): Integer;
    procedure Set_Kontonummer(Nummer: Integer; Value: Integer);
    function Get_Bezeichnung(Nr: Integer): WideString;
    function Get_Nummer: Integer;
    procedure Set_Nummer(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFestkonto);
    procedure Disconnect; override;
    function Sachkonto: ISachkonto;
    property DefaultInterface: IFestkonto read GetDefaultInterface;
    property Kontonummer[Nummer: Integer]: Integer read Get_Kontonummer write Set_Kontonummer;
    property Bezeichnung[Nr: Integer]: WideString read Get_Bezeichnung;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
  published
  end;

// *********************************************************************//
// Die Klasse CoKreditor stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKreditor, dargestellt
// von CoClass Kreditor, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKreditor = class
    class function Create: IKreditor;
    class function CreateRemote(const MachineName: string): IKreditor;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKreditor
// Hilfe-String      : Kreditor Objekt
// Standard-Interface: IKreditor
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TKreditor = class(TOleServer)
  private
    FIntf: IKreditor;
    function GetDefaultInterface: IKreditor;
  protected
    procedure InitServerData; override;
    function Get_Kontonummer: Integer;
    procedure Set_Kontonummer(Value: Integer);
    function Get_InlEuroDritt: Integer;
    procedure Set_InlEuroDritt(Value: Integer);
    function Get_Zahlart: EZahlarten;
    function Get_Zahlkondition: IZahlkondition;
    function Get_Kundennummer: WideString;
    function Get_Konzern: Integer;
    function Get_NummerBeimPartner: WideString;
    function Get_Gebietsnummer: Integer;
    function Get_Steuernummer: WideString;
    function Get_HR_Nummer: WideString;
    function Get_HR_Ort: WideString;
    function Get_ZdDatum: TDateTime;
    function Get_ZdZeitraumVon: TDateTime;
    function Get_ZdZeitraumBis: TDateTime;
    function Get_Zahldauer: Integer;
    function Get_ReGesamtAnzahl: Integer;
    function Get_ReGesamtUmsatz: Currency;
    function Get_ReGesamtSkonto: Currency;
    function Get_IsBauAbzugssteuer: WordBool;
    function Get_BauFreistellungVon: TDateTime;
    function Get_BauFreistellungBis: TDateTime;
    function Get_IsZentralregulierer: WordBool;
    function Get_ZentRegKontonummer: Integer;
    function Get_ZentRegReferenzNr: WideString;
    function Get_Vorwahl: WideString;
    function Get_Rufnummer: WideString;
    function Get_Ansprechpartner: WideString;
    function Get_Geburtstag: TDateTime;
    function Get_Rechtsform: Integer;
    function Get_GegenKonto: Integer;
    function Get_AbwSammelKt: Integer;
    function Get_AbwSkontoKt: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKreditor);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Konto: IKonto;
    function Adresse: IAdresse;
    function Bankverbindung: IBankverbindung;
    function Rabatt(Index: Integer): Currency;
    property DefaultInterface: IKreditor read GetDefaultInterface;
    property Zahlart: EZahlarten read Get_Zahlart;
    property Zahlkondition: IZahlkondition read Get_Zahlkondition;
    property Kundennummer: WideString read Get_Kundennummer;
    property Konzern: Integer read Get_Konzern;
    property NummerBeimPartner: WideString read Get_NummerBeimPartner;
    property Gebietsnummer: Integer read Get_Gebietsnummer;
    property Steuernummer: WideString read Get_Steuernummer;
    property HR_Nummer: WideString read Get_HR_Nummer;
    property HR_Ort: WideString read Get_HR_Ort;
    property ZdDatum: TDateTime read Get_ZdDatum;
    property ZdZeitraumVon: TDateTime read Get_ZdZeitraumVon;
    property ZdZeitraumBis: TDateTime read Get_ZdZeitraumBis;
    property Zahldauer: Integer read Get_Zahldauer;
    property ReGesamtAnzahl: Integer read Get_ReGesamtAnzahl;
    property ReGesamtUmsatz: Currency read Get_ReGesamtUmsatz;
    property ReGesamtSkonto: Currency read Get_ReGesamtSkonto;
    property IsBauAbzugssteuer: WordBool read Get_IsBauAbzugssteuer;
    property BauFreistellungVon: TDateTime read Get_BauFreistellungVon;
    property BauFreistellungBis: TDateTime read Get_BauFreistellungBis;
    property IsZentralregulierer: WordBool read Get_IsZentralregulierer;
    property ZentRegKontonummer: Integer read Get_ZentRegKontonummer;
    property ZentRegReferenzNr: WideString read Get_ZentRegReferenzNr;
    property Vorwahl: WideString read Get_Vorwahl;
    property Rufnummer: WideString read Get_Rufnummer;
    property Ansprechpartner: WideString read Get_Ansprechpartner;
    property Geburtstag: TDateTime read Get_Geburtstag;
    property Rechtsform: Integer read Get_Rechtsform;
    property GegenKonto: Integer read Get_GegenKonto;
    property AbwSammelKt: Integer read Get_AbwSammelKt;
    property AbwSkontoKt: Integer read Get_AbwSkontoKt;
    property Kontonummer: Integer read Get_Kontonummer write Set_Kontonummer;
    property InlEuroDritt: Integer read Get_InlEuroDritt write Set_InlEuroDritt;
  published
  end;

// *********************************************************************//
// Die Klasse CoSachkonto stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface ISachkonto, dargestellt
// von CoClass Sachkonto, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoSachkonto = class
    class function Create: ISachkonto;
    class function CreateRemote(const MachineName: string): ISachkonto;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TSachkonto
// Hilfe-String      : Sachkonto Objekt
// Standard-Interface: ISachkonto
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TSachkonto = class(TOleServer)
  private
    FIntf: ISachkonto;
    function GetDefaultInterface: ISachkonto;
  protected
    procedure InitServerData; override;
    function Get_Kontonummer: Integer;
    procedure Set_Kontonummer(Value: Integer);
    function Get_HGBGruppennummer: Integer;
    function Get_USGAAPGruppennummer: Integer;
    function Get_USGAAPKonto: WideString;
    function Get_Kontoart: EKontoarten;
    function Get_UStVA: Integer;
    procedure Set_UStVA(Value: Integer);
    function Get_HGBZuordnung: EBilGuVZuordnung;
    function Get_SammelKtArt: ESammelKtArt;
    function Get_Umsatzschluessel: WideString;
    function Get_USGAAPZuordnung: EBilGuVZuordnung;
    function Get_Sperre: EKontensperren;
    function Get_KArtNr: Integer;
    function Get_IsKostenstellenErfassung: WordBool;
    function Get_IsKostentraegerErfassung: WordBool;
    function Get_UStIdNr: WideString;
    function Get_Kreditlimit: Currency;
    function Get_Obligolimit: Currency;
    function Get_IntraWaNr: Integer;
    function Get_Kostenstelle: Integer;
    function Get_Kostentraeger: Integer;
    function Get_Steuerkonto1: Integer;
    function Get_Steuerkonto2: Integer;
    function Get_IsVStGesperrt: WordBool;
    function Get_RatingKonto: Integer;
    function Get_AnzahlArt: Integer;
    function Get_AnzKtoUSt: Integer;
    function Get_AnzKonto: Integer;
    function Get_IsAufzuteilendeVSt: WordBool;
    function Get_ErwerbLieferungAus: Integer;
    function Get_Skontokonto: Integer;
    function Get_Differenzkonto: Integer;
    function Get_EBVortrag: Integer;
    function Get_EBKonto: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISachkonto);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Konto: IKonto;
    function HGBPosSGruppe: IGruppe;
    function HGBPosHGruppe: IGruppe;
    function USGAAPSGruppe: IGruppe;
    function USGAAPHGruppe: IGruppe;
    function Kostenart: IKostenart;
    function USt: IUSt;
    function Bankverbindung: IBankverbindung;
    property DefaultInterface: ISachkonto read GetDefaultInterface;
    property HGBGruppennummer: Integer read Get_HGBGruppennummer;
    property USGAAPGruppennummer: Integer read Get_USGAAPGruppennummer;
    property USGAAPKonto: WideString read Get_USGAAPKonto;
    property Kontoart: EKontoarten read Get_Kontoart;
    property HGBZuordnung: EBilGuVZuordnung read Get_HGBZuordnung;
    property SammelKtArt: ESammelKtArt read Get_SammelKtArt;
    property Umsatzschluessel: WideString read Get_Umsatzschluessel;
    property USGAAPZuordnung: EBilGuVZuordnung read Get_USGAAPZuordnung;
    property Sperre: EKontensperren read Get_Sperre;
    property KArtNr: Integer read Get_KArtNr;
    property IsKostenstellenErfassung: WordBool read Get_IsKostenstellenErfassung;
    property IsKostentraegerErfassung: WordBool read Get_IsKostentraegerErfassung;
    property UStIdNr: WideString read Get_UStIdNr;
    property Kreditlimit: Currency read Get_Kreditlimit;
    property Obligolimit: Currency read Get_Obligolimit;
    property IntraWaNr: Integer read Get_IntraWaNr;
    property Kostenstelle: Integer read Get_Kostenstelle;
    property Kostentraeger: Integer read Get_Kostentraeger;
    property Steuerkonto1: Integer read Get_Steuerkonto1;
    property Steuerkonto2: Integer read Get_Steuerkonto2;
    property IsVStGesperrt: WordBool read Get_IsVStGesperrt;
    property RatingKonto: Integer read Get_RatingKonto;
    property AnzahlArt: Integer read Get_AnzahlArt;
    property AnzKtoUSt: Integer read Get_AnzKtoUSt;
    property AnzKonto: Integer read Get_AnzKonto;
    property IsAufzuteilendeVSt: WordBool read Get_IsAufzuteilendeVSt;
    property ErwerbLieferungAus: Integer read Get_ErwerbLieferungAus;
    property Skontokonto: Integer read Get_Skontokonto;
    property Differenzkonto: Integer read Get_Differenzkonto;
    property EBVortrag: Integer read Get_EBVortrag;
    property EBKonto: Integer read Get_EBKonto;
    property Kontonummer: Integer read Get_Kontonummer write Set_Kontonummer;
    property UStVA: Integer read Get_UStVA write Set_UStVA;
  published
  end;

// *********************************************************************//
// Die Klasse CoBuchtext stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IBuchtext, dargestellt
// von CoClass Buchtext, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoBuchtext = class
    class function Create: IBuchtext;
    class function CreateRemote(const MachineName: string): IBuchtext;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TBuchtext
// Hilfe-String      : Buchtext Objekt
// Standard-Interface: IBuchtext
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TBuchtext = class(TOleServer)
  private
    FIntf: IBuchtext;
    function GetDefaultInterface: IBuchtext;
  protected
    procedure InitServerData; override;
    function Get_Text(Nr: Integer): WideString;
    procedure Set_Text(Nr: Integer; const Value: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBuchtext);
    procedure Disconnect; override;
    property DefaultInterface: IBuchtext read GetDefaultInterface;
    property Text[Nr: Integer]: WideString read Get_Text write Set_Text;
  published
  end;

// *********************************************************************//
// Die Klasse CoSteuer stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface ISteuer, dargestellt
// von CoClass Steuer, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoSteuer = class
    class function Create: ISteuer;
    class function CreateRemote(const MachineName: string): ISteuer;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TSteuer
// Hilfe-String      : Steuer Objekt
// Standard-Interface: ISteuer
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TSteuer = class(TOleServer)
  private
    FIntf: ISteuer;
    function GetDefaultInterface: ISteuer;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    procedure Set_Nummer(Value: Integer);
    function Get_Bezeichnung: WideString;
    procedure Set_Bezeichnung(const Value: WideString);
    function Get_Steuersatz1: Double;
    procedure Set_Steuersatz1(Value: Double);
    function Get_AbDatum: TDateTime;
    procedure Set_AbDatum(Value: TDateTime);
    function Get_Steuersatz2: Double;
    procedure Set_Steuersatz2(Value: Double);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISteuer);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: ISteuer read GetDefaultInterface;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property Steuersatz1: Double read Get_Steuersatz1 write Set_Steuersatz1;
    property AbDatum: TDateTime read Get_AbDatum write Set_AbDatum;
    property Steuersatz2: Double read Get_Steuersatz2 write Set_Steuersatz2;
  published
  end;

// *********************************************************************//
// Die Klasse CoFinanzamt stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IFinanzamt, dargestellt
// von CoClass Finanzamt, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoFinanzamt = class
    class function Create: IFinanzamt;
    class function CreateRemote(const MachineName: string): IFinanzamt;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TFinanzamt
// Hilfe-String      : Finanzamt Objekt
// Standard-Interface: IFinanzamt
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TFinanzamt = class(TOleServer)
  private
    FIntf: IFinanzamt;
    function GetDefaultInterface: IFinanzamt;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    procedure Set_Nummer(Value: Integer);
    function Get_OFD: WideString;
    procedure Set_OFD(const Value: WideString);
    function Get_Bundesland: WideString;
    procedure Set_Bundesland(const Value: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFinanzamt);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Adresse: IAdresse;
    function Bankverbindung(Nr: Integer): IBankverbindung;
    property DefaultInterface: IFinanzamt read GetDefaultInterface;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property OFD: WideString read Get_OFD write Set_OFD;
    property Bundesland: WideString read Get_Bundesland write Set_Bundesland;
  published
  end;

// *********************************************************************//
// Die Klasse CoBank stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IBank, dargestellt
// von CoClass Bank, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoBank = class
    class function Create: IBank;
    class function CreateRemote(const MachineName: string): IBank;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TBank
// Hilfe-String      : Bank Objekt
// Standard-Interface: IBank
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TBank = class(TOleServer)
  private
    FIntf: IBank;
    function GetDefaultInterface: IBank;
  protected
    procedure InitServerData; override;
    function Get_BLZ: Integer;
    procedure Set_BLZ(Value: Integer);
    function Get_Bezeichnung: WideString;
    procedure Set_Bezeichnung(const Value: WideString);
    function Get_Pruefziffer: Integer;
    function Get_PLZ: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBank);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function CheckBLZ(BLZ: Integer): WordBool;
    function CheckKTO(BLZ: Integer; const KTO: WideString): WordBool;
    function Ort: IOrt;
    function CheckIBAN(const IBANNr: WideString): WordBool;
    property DefaultInterface: IBank read GetDefaultInterface;
    property Pruefziffer: Integer read Get_Pruefziffer;
    property PLZ: Integer read Get_PLZ;
    property BLZ: Integer read Get_BLZ write Set_BLZ;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
  published
  end;

// *********************************************************************//
// Die Klasse CoKontenbereich stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKontenbereich, dargestellt
// von CoClass Kontenbereich, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKontenbereich = class
    class function Create: IKontenbereich;
    class function CreateRemote(const MachineName: string): IKontenbereich;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKontenbereich
// Hilfe-String      : Kontenbereich Objekt
// Standard-Interface: IKontenbereich
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TKontenbereich = class(TOleServer)
  private
    FIntf: IKontenbereich;
    function GetDefaultInterface: IKontenbereich;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKontenbereich);
    procedure Disconnect; override;
    procedure Debitoren(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
    procedure Kreditoren(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
    procedure Sachkonten(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
    procedure Kostenstellen(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
    procedure Kostentraeger(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
    procedure Kostenarten(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
    function GetKontoTyp(Konto: Integer): EKontotypen;
    function CheckKonto(Konto: Integer; KontoTyp: EKontotypen): WordBool;
    property DefaultInterface: IKontenbereich read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// Die Klasse CoBankverbindung stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IBankverbindung, dargestellt
// von CoClass Bankverbindung, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoBankverbindung = class
    class function Create: IBankverbindung;
    class function CreateRemote(const MachineName: string): IBankverbindung;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TBankverbindung
// Hilfe-String      : Bankverbindung Objekt
// Standard-Interface: IBankverbindung
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TBankverbindung = class(TOleServer)
  private
    FIntf: IBankverbindung;
    function GetDefaultInterface: IBankverbindung;
  protected
    procedure InitServerData; override;
    function Get_KTO: WideString;
    procedure Set_KTO(const Value: WideString);
    function Get_Inhaber: WideString;
    procedure Set_Inhaber(const Value: WideString);
    function Get_BLZ: Integer;
    function Get_IBAN: WideString;
    function Get_SWIFT: WideString;
    function Get_AuslBankKto: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBankverbindung);
    procedure Disconnect; override;
    function Bank: IBank;
    function CheckKTO: WordBool;
    function CheckIBAN: WordBool;
    property DefaultInterface: IBankverbindung read GetDefaultInterface;
    property BLZ: Integer read Get_BLZ;
    property IBAN: WideString read Get_IBAN;
    property SWIFT: WideString read Get_SWIFT;
    property AuslBankKto: WideString read Get_AuslBankKto;
    property KTO: WideString read Get_KTO write Set_KTO;
    property Inhaber: WideString read Get_Inhaber write Set_Inhaber;
  published
  end;

// *********************************************************************//
// Die Klasse CoGruppe stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IGruppe, dargestellt
// von CoClass Gruppe, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoGruppe = class
    class function Create: IGruppe;
    class function CreateRemote(const MachineName: string): IGruppe;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TGruppe
// Hilfe-String      : Gruppe Objekt
// Standard-Interface: IGruppe
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TGruppe = class(TOleServer)
  private
    FIntf: IGruppe;
    function GetDefaultInterface: IGruppe;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    procedure Set_Nummer(Value: Integer);
    function Get_Bezeichnung: WideString;
    procedure Set_Bezeichnung(const Value: WideString);
    function Get_Zuordnung: EBilGuVZuordnung;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IGruppe);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IGruppe read GetDefaultInterface;
    property Zuordnung: EBilGuVZuordnung read Get_Zuordnung;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
  published
  end;

// *********************************************************************//
// Die Klasse CoKostenart stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKostenart, dargestellt
// von CoClass Kostenart, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKostenart = class
    class function Create: IKostenart;
    class function CreateRemote(const MachineName: string): IKostenart;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKostenart
// Hilfe-String      : Kostenart Objekt
// Standard-Interface: IKostenart
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TKostenart = class(TOleServer)
  private
    FIntf: IKostenart;
    function GetDefaultInterface: IKostenart;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    procedure Set_Nummer(Value: Integer);
    function Get_Bezeichnung: WideString;
    procedure Set_Bezeichnung(const Value: WideString);
    function Get_IsLeistung: WordBool;
    procedure Set_IsLeistung(Value: WordBool);
    function Get_IsMengenerfassung: WordBool;
    function Get_IsBebucht: WordBool;
    function Get_Bezeichnung1: WideString;
    procedure Set_Bezeichnung1(const Value: WideString);
    function Get_IsMengePflicht: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKostenart);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function KStSaldo(WaNr: Integer; IsInHW: WordBool): ISaldo;
    function KTrSaldo(WaNr: Integer; IsInHW: WordBool): ISaldo;
    function KLRJournal(WiJ: Integer): IKLRJournal;
    property DefaultInterface: IKostenart read GetDefaultInterface;
    property IsMengenerfassung: WordBool read Get_IsMengenerfassung;
    property IsBebucht: WordBool read Get_IsBebucht;
    property IsMengePflicht: WordBool read Get_IsMengePflicht;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property IsLeistung: WordBool read Get_IsLeistung write Set_IsLeistung;
    property Bezeichnung1: WideString read Get_Bezeichnung1 write Set_Bezeichnung1;
  published
  end;

// *********************************************************************//
// Die Klasse CoKostenstelle stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKostenstelle, dargestellt
// von CoClass Kostenstelle, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKostenstelle = class
    class function Create: IKostenstelle;
    class function CreateRemote(const MachineName: string): IKostenstelle;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKostenstelle
// Hilfe-String      : Kostenstelle Objekt
// Standard-Interface: IKostenstelle
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TKostenstelle = class(TOleServer)
  private
    FIntf: IKostenstelle;
    function GetDefaultInterface: IKostenstelle;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    procedure Set_Nummer(Value: Integer);
    function Get_Bezeichnung(Nr: Integer): WideString;
    procedure Set_Bezeichnung(Nr: Integer; const Value: WideString);
    function Get_Bezeichnung1: WideString;
    procedure Set_Bezeichnung1(const Value: WideString);
    function Get_Bezeichnung2: WideString;
    procedure Set_Bezeichnung2(const Value: WideString);
    function Get_Bezeichnung3: WideString;
    procedure Set_Bezeichnung3(const Value: WideString);
    function Get_KurzBez: WideString;
    procedure Set_KurzBez(const Value: WideString);
    function Get_IsHaupt: WordBool;
    procedure Set_IsHaupt(Value: WordBool);
    function Get_FixVar: Integer;
    procedure Set_FixVar(Value: Integer);
    function Get_IsAskFixVar: WordBool;
    procedure Set_IsAskFixVar(Value: WordBool);
    function Get_IsBebucht: WordBool;
    function Get_SperreTyp: Integer;
    function Get_SperrFreiDatumVon: TDateTime;
    function Get_SperrFreiDatumBis: TDateTime;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKostenstelle);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Gruppe(Nr: Integer): IGruppe;
    function Planmenge(Nr: Integer): IPlanmenge;
    function Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo;
    function GrpNummer(Nr: Integer): Integer;
    function KLRJournal(WiJ: Integer): IKLRJournal;
    property DefaultInterface: IKostenstelle read GetDefaultInterface;
    property Bezeichnung[Nr: Integer]: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property IsBebucht: WordBool read Get_IsBebucht;
    property SperreTyp: Integer read Get_SperreTyp;
    property SperrFreiDatumVon: TDateTime read Get_SperrFreiDatumVon;
    property SperrFreiDatumBis: TDateTime read Get_SperrFreiDatumBis;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung1: WideString read Get_Bezeichnung1 write Set_Bezeichnung1;
    property Bezeichnung2: WideString read Get_Bezeichnung2 write Set_Bezeichnung2;
    property Bezeichnung3: WideString read Get_Bezeichnung3 write Set_Bezeichnung3;
    property KurzBez: WideString read Get_KurzBez write Set_KurzBez;
    property IsHaupt: WordBool read Get_IsHaupt write Set_IsHaupt;
    property FixVar: Integer read Get_FixVar write Set_FixVar;
    property IsAskFixVar: WordBool read Get_IsAskFixVar write Set_IsAskFixVar;
  published
  end;

// *********************************************************************//
// Die Klasse CoBezugsgroesse stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IBezugsgroesse, dargestellt
// von CoClass Bezugsgroesse, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoBezugsgroesse = class
    class function Create: IBezugsgroesse;
    class function CreateRemote(const MachineName: string): IBezugsgroesse;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TBezugsgroesse
// Hilfe-String      : Bezugsgroesse Objekt
// Standard-Interface: IBezugsgroesse
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TBezugsgroesse = class(TOleServer)
  private
    FIntf: IBezugsgroesse;
    function GetDefaultInterface: IBezugsgroesse;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    procedure Set_Nummer(Value: Integer);
    function Get_Bezeichnung: WideString;
    procedure Set_Bezeichnung(const Value: WideString);
    function Get_KurzBez: WideString;
    procedure Set_KurzBez(const Value: WideString);
    function Get_Nachkomma: Integer;
    procedure Set_Nachkomma(Value: Integer);
    function Get_BGTyp: Integer;
    procedure Set_BGTyp(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBezugsgroesse);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IBezugsgroesse read GetDefaultInterface;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property KurzBez: WideString read Get_KurzBez write Set_KurzBez;
    property Nachkomma: Integer read Get_Nachkomma write Set_Nachkomma;
    property BGTyp: Integer read Get_BGTyp write Set_BGTyp;
  published
  end;

// *********************************************************************//
// Die Klasse CoPlanmenge stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IPlanmenge, dargestellt
// von CoClass Planmenge, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoPlanmenge = class
    class function Create: IPlanmenge;
    class function CreateRemote(const MachineName: string): IPlanmenge;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TPlanmenge
// Hilfe-String      : Planmenge Objekt
// Standard-Interface: IPlanmenge
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TPlanmenge = class(TOleServer)
  private
    FIntf: IPlanmenge;
    function GetDefaultInterface: IPlanmenge;
  protected
    procedure InitServerData; override;
    function Get_Wert: Double;
    procedure Set_Wert(Value: Double);
    function Get_IsAbfrage: WordBool;
    procedure Set_IsAbfrage(Value: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IPlanmenge);
    procedure Disconnect; override;
    function Bezugsgroesse: IBezugsgroesse;
    property DefaultInterface: IPlanmenge read GetDefaultInterface;
    property Wert: Double read Get_Wert write Set_Wert;
    property IsAbfrage: WordBool read Get_IsAbfrage write Set_IsAbfrage;
  published
  end;

// *********************************************************************//
// Die Klasse CoUSt stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IUSt, dargestellt
// von CoClass USt, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoUSt = class
    class function Create: IUSt;
    class function CreateRemote(const MachineName: string): IUSt;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TUSt
// Hilfe-String      : USt Objekt
// Standard-Interface: IUSt
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TUSt = class(TOleServer)
  private
    FIntf: IUSt;
    function GetDefaultInterface: IUSt;
  protected
    procedure InitServerData; override;
    function Get_Art: EUStArten;
    procedure Set_Art(Value: EUStArten);
    function Get_ArtMV: WideString;
    procedure Set_ArtMV(const Value: WideString);
    function Get_Schluessel: Integer;
    function Get_IsAnzahlung: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IUSt);
    procedure Disconnect; override;
    function Steuer: ISteuer;
    function AsRecord: RUSt;
    property DefaultInterface: IUSt read GetDefaultInterface;
    property Schluessel: Integer read Get_Schluessel;
    property IsAnzahlung: WordBool read Get_IsAnzahlung;
    property Art: EUStArten read Get_Art write Set_Art;
    property ArtMV: WideString read Get_ArtMV write Set_ArtMV;
  published
  end;

// *********************************************************************//
// Die Klasse CoKurs stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKurs, dargestellt
// von CoClass Kurs, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKurs = class
    class function Create: IKurs;
    class function CreateRemote(const MachineName: string): IKurs;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKurs
// Hilfe-String      : Kurs Objekt
// Standard-Interface: IKurs
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TKurs = class(TOleServer)
  private
    FIntf: IKurs;
    function GetDefaultInterface: IKurs;
  protected
    procedure InitServerData; override;
    function Get_Basis: Integer;
    procedure Set_Basis(Value: Integer);
    function Get_Tageskurs: Double;
    procedure Set_Tageskurs(Value: Double);
    function Get_Waehrungsbetrag: Currency;
    procedure Set_Waehrungsbetrag(Value: Currency);
    function Get_Waehrungsnummer: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKurs);
    procedure Disconnect; override;
    function Waehrung: IWaehrung;
    function AsRecord: RKurs;
    property DefaultInterface: IKurs read GetDefaultInterface;
    property Waehrungsnummer: Integer read Get_Waehrungsnummer;
    property Basis: Integer read Get_Basis write Set_Basis;
    property Tageskurs: Double read Get_Tageskurs write Set_Tageskurs;
    property Waehrungsbetrag: Currency read Get_Waehrungsbetrag write Set_Waehrungsbetrag;
  published
  end;

// *********************************************************************//
// Die Klasse CoWaehrung stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IWaehrung, dargestellt
// von CoClass Waehrung, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoWaehrung = class
    class function Create: IWaehrung;
    class function CreateRemote(const MachineName: string): IWaehrung;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TWaehrung
// Hilfe-String      : Waehrung Objekt
// Standard-Interface: IWaehrung
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TWaehrung = class(TOleServer)
  private
    FIntf: IWaehrung;
    function GetDefaultInterface: IWaehrung;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    procedure Set_Nummer(Value: Integer);
    function Get_Bezeichnung: WideString;
    procedure Set_Bezeichnung(const Value: WideString);
    function Get_ISOBez: WideString;
    procedure Set_ISOBez(const Value: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IWaehrung);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Land: ILand;
    function Festkonto(Nr: Integer): IFestkonto;
    property DefaultInterface: IWaehrung read GetDefaultInterface;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung write Set_Bezeichnung;
    property ISOBez: WideString read Get_ISOBez write Set_ISOBez;
  published
  end;

// *********************************************************************//
// Die Klasse CoMahn stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IMahn, dargestellt
// von CoClass Mahn, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoMahn = class
    class function Create: IMahn;
    class function CreateRemote(const MachineName: string): IMahn;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TMahn
// Hilfe-String      : Mahn Objekt
// Standard-Interface: IMahn
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TMahn = class(TOleServer)
  private
    FIntf: IMahn;
    function GetDefaultInterface: IMahn;
  protected
    procedure InitServerData; override;
    function Get_Mahnstufe: Integer;
    procedure Set_Mahnstufe(Value: Integer);
    function Get_Mahndatum: TDateTime;
    procedure Set_Mahndatum(Value: TDateTime);
    function Get_IsMahnstop: WordBool;
    procedure Set_IsMahnstop(Value: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMahn);
    procedure Disconnect; override;
    property DefaultInterface: IMahn read GetDefaultInterface;
    property Mahnstufe: Integer read Get_Mahnstufe write Set_Mahnstufe;
    property Mahndatum: TDateTime read Get_Mahndatum write Set_Mahndatum;
    property IsMahnstop: WordBool read Get_IsMahnstop write Set_IsMahnstop;
  published
  end;

// *********************************************************************//
// Die Klasse CoZahlkondition stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IZahlkondition, dargestellt
// von CoClass Zahlkondition, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoZahlkondition = class
    class function Create: IZahlkondition;
    class function CreateRemote(const MachineName: string): IZahlkondition;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TZahlkondition
// Hilfe-String      : Zahlkondition Objekt
// Standard-Interface: IZahlkondition
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TZahlkondition = class(TOleServer)
  private
    FIntf: IZahlkondition;
    function GetDefaultInterface: IZahlkondition;
  protected
    procedure InitServerData; override;
    function Get_Tage1: Integer;
    procedure Set_Tage1(Value: Integer);
    function Get_Skonto1: Single;
    procedure Set_Skonto1(Value: Single);
    function Get_Tage2: Integer;
    procedure Set_Tage2(Value: Integer);
    function Get_Skonto2: Single;
    procedure Set_Skonto2(Value: Single);
    function Get_Nettozahlungsziel: Integer;
    procedure Set_Nettozahlungsziel(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IZahlkondition);
    procedure Disconnect; override;
    function AsRecord: RZahlkondition;
    property DefaultInterface: IZahlkondition read GetDefaultInterface;
    property Tage1: Integer read Get_Tage1 write Set_Tage1;
    property Skonto1: Single read Get_Skonto1 write Set_Skonto1;
    property Tage2: Integer read Get_Tage2 write Set_Tage2;
    property Skonto2: Single read Get_Skonto2 write Set_Skonto2;
    property Nettozahlungsziel: Integer read Get_Nettozahlungsziel write Set_Nettozahlungsziel;
  published
  end;

// *********************************************************************//
// Die Klasse CoFNReport stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IFNReport, dargestellt
// von CoClass FNReport, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoFNReport = class
    class function Create: IFNReport;
    class function CreateRemote(const MachineName: string): IFNReport;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TFNReport
// Hilfe-String      : FibuNet Report Generator
// Standard-Interface: IFNReport
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (16) Hidden
// *********************************************************************//
  TFNReport = class(TOleServer)
  private
    FIntf: IFNReport;
    function GetDefaultInterface: IFNReport;
  protected
    procedure InitServerData; override;
    function Get_Formular: OleVariant;
    procedure Set_Formular(Value: OleVariant);
    function Get_Formeln: OleVariant;
    procedure Set_Formeln(Value: OleVariant);
    function Get_Variable(const VarName: WideString): OleVariant;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFNReport);
    procedure Disconnect; override;
    function Taschenrechner(const Ausdruck: WideString): Double;
    procedure Load(const FrmName: WideString; const Passwort: WideString);
    procedure Save(const FrmName: WideString);
    function Auswerten(Tagesabgrenzung: Integer; IsMVZabgrenzung: WordBool; IsMitStapel: WordBool): WordBool;
    property DefaultInterface: IFNReport read GetDefaultInterface;
    property Formular: OleVariant read Get_Formular write Set_Formular;
    property Formeln: OleVariant read Get_Formeln write Set_Formeln;
    property Variable[const VarName: WideString]: OleVariant read Get_Variable;
  published
  end;

// *********************************************************************//
// Die Klasse CoChooseMandant stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IChooseMandant, dargestellt
// von CoClass ChooseMandant, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoChooseMandant = class
    class function Create: IChooseMandant;
    class function CreateRemote(const MachineName: string): IChooseMandant;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TChooseMandant
// Hilfe-String      : Mandantenauswahl Objekt 
// Standard-Interface: IChooseMandant
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TChooseMandant = class(TOleServer)
  private
    FIntf: IChooseMandant;
    function GetDefaultInterface: IChooseMandant;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    function Get_Bezeichnung: WideString;
    function Get_aktlWiJahr: Integer;
    function Get_letzteMonatWiJahr: Integer;
    function Get_Bankleitzahl: Integer;
    function Get_Bankkontonummer: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IChooseMandant);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Adresse: IAdresse;
    property DefaultInterface: IChooseMandant read GetDefaultInterface;
    property Nummer: Integer read Get_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung;
    property aktlWiJahr: Integer read Get_aktlWiJahr;
    property letzteMonatWiJahr: Integer read Get_letzteMonatWiJahr;
    property Bankleitzahl: Integer read Get_Bankleitzahl;
    property Bankkontonummer: WideString read Get_Bankkontonummer;
  published
  end;

// *********************************************************************//
// Die Klasse CoPasswort stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IPasswort, dargestellt
// von CoClass Passwort, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoPasswort = class
    class function Create: IPasswort;
    class function CreateRemote(const MachineName: string): IPasswort;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TPasswort
// Hilfe-String      : Passwort Objekt
// Standard-Interface: IPasswort
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TPasswort = class(TOleServer)
  private
    FIntf: IPasswort;
    function GetDefaultInterface: IPasswort;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IPasswort);
    procedure Disconnect; override;
    function PruefeMandant(Mandant: Integer; const Passwort: WideString): WordBool;
    function SetzeMandant(Mandant: Integer; const Passwort: WideString): WordBool;
    procedure PruefeReportgenerator;
    function PruefeAdministrator(const Passwort: WideString): WordBool;
    procedure PruefeBenutzerverwalter;
    property DefaultInterface: IPasswort read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// Die Klasse CoBuchen stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IBuchen, dargestellt
// von CoClass Buchen, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoBuchen = class
    class function Create: IBuchen;
    class function CreateRemote(const MachineName: string): IBuchen;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TBuchen
// Hilfe-String      : Buchen Objekt
// Standard-Interface: IBuchen
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TBuchen = class(TOleServer)
  private
    FIntf: IBuchen;
    function GetDefaultInterface: IBuchen;
  protected
    procedure InitServerData; override;
    function Get_MinBuchDatum: TDateTime;
    function Get_MaxBuchDatum: TDateTime;
    function Get_CmdLogSize: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBuchen);
    procedure Disconnect; override;
    function Verarbeiten(const Data: WideString): WideString;
    function Primanota: WideString;
    function Hauswaehrung: WideString;
    procedure Close;
    function Open(EBJahre: Integer; IsKtlSumBlatt: WordBool; IsSimulation: WordBool; 
                  IsStapel: WordBool): WideString;
    function Journalzeile: Integer;
    function AskEBKorrektur: Integer;
    function Import: IFNImport;
    function MinMaxDatum(out VonDatum: TDateTime; out BisDatum: TDateTime): WordBool;
    procedure ClearCmds;
    function GetCmd(aCmdTyp: ECmdTypen): OleVariant;
    procedure AddCmd(aCmdClass: OleVariant);
    function ReadCmds: WideString;
    function DCZahlung(FileNummer: Integer; Zahldatum: TDateTime; Wertstellungsdatum: TDateTime; 
                       out ErrText: WideString): WordBool;
    procedure CmdLogText(AbPosition: Integer; out LogSize: Integer; out LogText: WideString);
    function CmdDayLogCount: Integer;
    function CmdDayLogText(FileNr: Integer): WideString;
    property DefaultInterface: IBuchen read GetDefaultInterface;
    property MinBuchDatum: TDateTime read Get_MinBuchDatum;
    property MaxBuchDatum: TDateTime read Get_MaxBuchDatum;
    property CmdLogSize: Integer read Get_CmdLogSize;
  published
  end;

// *********************************************************************//
// Die Klasse CoKostenstelleart stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKostenstelleart, dargestellt
// von CoClass Kostenstelleart, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKostenstelleart = class
    class function Create: IKostenstelleart;
    class function CreateRemote(const MachineName: string): IKostenstelleart;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKostenstelleart
// Hilfe-String      : Kostenstellenartenstamm
// Standard-Interface: IKostenstelleart
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TKostenstelleart = class(TOleServer)
  private
    FIntf: IKostenstelleart;
    function GetDefaultInterface: IKostenstelleart;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    function Get_KostenartNummer: Integer;
    function Get_IsLeistung: WordBool;
    function Get_IsBebucht: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKostenstelleart);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo;
    function KStKTr: IKostenstelle;
    function Kostenart: IKostenart;
    function StTrArtNr(KStTrNr: Integer; KArtNr: Integer): WordBool;
    function KLRJournal(WiJ: Integer): IKLRJournal;
    property DefaultInterface: IKostenstelleart read GetDefaultInterface;
    property Nummer: Integer read Get_Nummer;
    property KostenartNummer: Integer read Get_KostenartNummer;
    property IsLeistung: WordBool read Get_IsLeistung;
    property IsBebucht: WordBool read Get_IsBebucht;
  published
  end;

// *********************************************************************//
// Die Klasse CoFNImport stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IFNImport, dargestellt
// von CoClass FNImport, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoFNImport = class
    class function Create: IFNImport;
    class function CreateRemote(const MachineName: string): IFNImport;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TFNImport
// Hilfe-String      : FNImport Objekt
// Standard-Interface: IFNImport
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TFNImport = class(TOleServer)
  private
    FIntf: IFNImport;
    function GetDefaultInterface: IFNImport;
  protected
    procedure InitServerData; override;
    function Get_Name: WideString;
    function Get_Info: WideString;
    function Get_Datum: TDateTime;
    function Get_Groesse: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFNImport);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function SaveToFile(const Filename: WideString; const Text: WideString; Overwrite: WordBool; 
                        const Adminpasswort: WideString): WordBool;
    function DeleteFile(const Filename: WideString): WordBool;
    function Executefile(const Filename: WideString): Integer;
    function LoadFromFile(const Filename: WideString): WideString;
    property DefaultInterface: IFNImport read GetDefaultInterface;
    property Name: WideString read Get_Name;
    property Info: WideString read Get_Info;
    property Datum: TDateTime read Get_Datum;
    property Groesse: Integer read Get_Groesse;
  published
  end;

// *********************************************************************//
// Die Klasse CoREB stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IREB, dargestellt
// von CoClass REB, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoREB = class
    class function Create: IREB;
    class function CreateRemote(const MachineName: string): IREB;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TREB
// Hilfe-String      : REB Objekt
// Standard-Interface: IREB
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TREB = class(TOleServer)
  private
    FIntf: IREB;
    function GetDefaultInterface: IREB;
  protected
    procedure InitServerData; override;
    function Get_Sachbearbeiter: WideString;
    function Get_Valutadatum: TDateTime;
    function Get_Skontofaktor: Double;
    function Get_Zahlart: EZahlarten;
    function Get_ExportID: Integer;
    function Get_FreiUserName: WideString;
    function Get_FreiUserDatum: TDateTime;
    function Get_BuchUserName: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IREB);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Kontierung: IKontierung;
    function USt: IUSt;
    function Kurs: IKurs;
    function Zahlkondition: IZahlkondition;
    property DefaultInterface: IREB read GetDefaultInterface;
    property Sachbearbeiter: WideString read Get_Sachbearbeiter;
    property Valutadatum: TDateTime read Get_Valutadatum;
    property Skontofaktor: Double read Get_Skontofaktor;
    property Zahlart: EZahlarten read Get_Zahlart;
    property ExportID: Integer read Get_ExportID;
    property FreiUserName: WideString read Get_FreiUserName;
    property FreiUserDatum: TDateTime read Get_FreiUserDatum;
    property BuchUserName: WideString read Get_BuchUserName;
  published
  end;

// *********************************************************************//
// Die Klasse CoOrt stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IOrt, dargestellt
// von CoClass Ort, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoOrt = class
    class function Create: IOrt;
    class function CreateRemote(const MachineName: string): IOrt;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TOrt
// Hilfe-String      : Ort Objekt
// Standard-Interface: IOrt
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TOrt = class(TOleServer)
  private
    FIntf: IOrt;
    function GetDefaultInterface: IOrt;
  protected
    procedure InitServerData; override;
    function Get_PLZ: Integer;
    procedure Set_PLZ(Value: Integer);
    function Get_Bezeichnung: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IOrt);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IOrt read GetDefaultInterface;
    property Bezeichnung: WideString read Get_Bezeichnung;
    property PLZ: Integer read Get_PLZ write Set_PLZ;
  published
  end;

// *********************************************************************//
// Die Klasse CoLizenz stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface ILizenz, dargestellt
// von CoClass Lizenz, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoLizenz = class
    class function Create: ILizenz;
    class function CreateRemote(const MachineName: string): ILizenz;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TLizenz
// Hilfe-String      : Lizenz Objekt
// Standard-Interface: ILizenz
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TLizenz = class(TOleServer)
  private
    FIntf: ILizenz;
    function GetDefaultInterface: ILizenz;
  protected
    procedure InitServerData; override;
    function Get_SerNr: Integer;
    function Get_HdlNr: Integer;
    function Get_CodeFrist: Integer;
    function Get_Erstelldatum: TDateTime;
    function Get_AnzMandanten: Integer;
    function Get_AnzBankBew: Integer;
    function Get_AnzStationen: Integer;
    function Get_Lizenztext: WideString;
    function Get_IsDemoversion: WordBool;
    function Get_Versionsnummer: Integer;
    function Get_Modul(modTyp: EModule): WordBool;
    function Get_Modulbezeichnung(modTyp: EModule): WideString;
    function Get_ModulNutzbarBis(modTyp: EModule): TDateTime;
    function Get_AnzBIGStationen: Integer;
    function Get_webREBUser: Integer;
    function Get_webREBWorkflow: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ILizenz);
    procedure Disconnect; override;
    property DefaultInterface: ILizenz read GetDefaultInterface;
    property SerNr: Integer read Get_SerNr;
    property HdlNr: Integer read Get_HdlNr;
    property CodeFrist: Integer read Get_CodeFrist;
    property Erstelldatum: TDateTime read Get_Erstelldatum;
    property AnzMandanten: Integer read Get_AnzMandanten;
    property AnzBankBew: Integer read Get_AnzBankBew;
    property AnzStationen: Integer read Get_AnzStationen;
    property Lizenztext: WideString read Get_Lizenztext;
    property IsDemoversion: WordBool read Get_IsDemoversion;
    property Versionsnummer: Integer read Get_Versionsnummer;
    property Modul[modTyp: EModule]: WordBool read Get_Modul;
    property Modulbezeichnung[modTyp: EModule]: WideString read Get_Modulbezeichnung;
    property ModulNutzbarBis[modTyp: EModule]: TDateTime read Get_ModulNutzbarBis;
    property AnzBIGStationen: Integer read Get_AnzBIGStationen;
    property webREBUser: Integer read Get_webREBUser;
    property webREBWorkflow: Integer read Get_webREBWorkflow;
  published
  end;

// *********************************************************************//
// Die Klasse CoCmdBuchen stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface ICmdBuchen, dargestellt
// von CoClass CmdBuchen, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoCmdBuchen = class
    class function Create: ICmdBuchen;
    class function CreateRemote(const MachineName: string): ICmdBuchen;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TCmdBuchen
// Hilfe-String      : CmdBuchen Objekt
// Standard-Interface: ICmdBuchen
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TCmdBuchen = class(TOleServer)
  private
    FIntf: ICmdBuchen;
    function GetDefaultInterface: ICmdBuchen;
  protected
    procedure InitServerData; override;
    function Get_CmdTyp: ECmdTypen;
    function Get_AsString: WideString;
    function Get_Betrag: Currency;
    procedure Set_Betrag(Value: Currency);
    function Get_Konto: Integer;
    procedure Set_Konto(Value: Integer);
    function Get_UStArt: EUStArten;
    procedure Set_UStArt(Value: EUStArten);
    function Get_UStSchl: Integer;
    procedure Set_UStSchl(Value: Integer);
    function Get_GegKonto: Integer;
    procedure Set_GegKonto(Value: Integer);
    function Get_GegUStArt: EUStArten;
    procedure Set_GegUStArt(Value: EUStArten);
    function Get_GegUStSchl: Integer;
    procedure Set_GegUStSchl(Value: Integer);
    function Get_Belegnummer1: WideString;
    procedure Set_Belegnummer1(const Value: WideString);
    function Get_Belegnummer2: WideString;
    procedure Set_Belegnummer2(const Value: WideString);
    function Get_Buchtext: WideString;
    procedure Set_Buchtext(const Value: WideString);
    function Get_Belegdatum: TDateTime;
    procedure Set_Belegdatum(Value: TDateTime);
    function Get_Valutadatum: TDateTime;
    procedure Set_Valutadatum(Value: TDateTime);
    function Get_Zahlart: EZahlarten;
    procedure Set_Zahlart(Value: EZahlarten);
    function Get_Zahlkonditionen: IZahlkondition;
    procedure Set_Zahlkonditionen(const Value: IZahlkondition);
    function Get_Wertstellungsdatum: TDateTime;
    procedure Set_Wertstellungsdatum(Value: TDateTime);
    function Get_Reisedatum: TDateTime;
    procedure Set_Reisedatum(Value: TDateTime);
    function Get_Waehrung: WideString;
    procedure Set_Waehrung(const Value: WideString);
    function Get_Tageskurs: Double;
    procedure Set_Tageskurs(Value: Double);
    function Get_Memotext: WideString;
    procedure Set_Memotext(const Value: WideString);
    function Get_OpAutomatik: WordBool;
    procedure Set_OpAutomatik(Value: WordBool);
    function Get_KLRAutomatik: WordBool;
    procedure Set_KLRAutomatik(Value: WordBool);
    function Get_UStSatz: Double;
    procedure Set_UStSatz(Value: Double);
    function Get_GegUStSatz: Double;
    procedure Set_GegUStSatz(Value: Double);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICmdBuchen);
    procedure Disconnect; override;
    procedure Clear;
    function CmdPosten(Konto: Integer): ICmdPosten;
    function CmdKLR(Konto: Integer): ICmdKLR;
    property DefaultInterface: ICmdBuchen read GetDefaultInterface;
    property CmdTyp: ECmdTypen read Get_CmdTyp;
    property AsString: WideString read Get_AsString;
    property Betrag: Currency read Get_Betrag write Set_Betrag;
    property Konto: Integer read Get_Konto write Set_Konto;
    property UStArt: EUStArten read Get_UStArt write Set_UStArt;
    property UStSchl: Integer read Get_UStSchl write Set_UStSchl;
    property GegKonto: Integer read Get_GegKonto write Set_GegKonto;
    property GegUStArt: EUStArten read Get_GegUStArt write Set_GegUStArt;
    property GegUStSchl: Integer read Get_GegUStSchl write Set_GegUStSchl;
    property Belegnummer1: WideString read Get_Belegnummer1 write Set_Belegnummer1;
    property Belegnummer2: WideString read Get_Belegnummer2 write Set_Belegnummer2;
    property Buchtext: WideString read Get_Buchtext write Set_Buchtext;
    property Belegdatum: TDateTime read Get_Belegdatum write Set_Belegdatum;
    property Valutadatum: TDateTime read Get_Valutadatum write Set_Valutadatum;
    property Zahlart: EZahlarten read Get_Zahlart write Set_Zahlart;
    property Zahlkonditionen: IZahlkondition read Get_Zahlkonditionen write Set_Zahlkonditionen;
    property Wertstellungsdatum: TDateTime read Get_Wertstellungsdatum write Set_Wertstellungsdatum;
    property Reisedatum: TDateTime read Get_Reisedatum write Set_Reisedatum;
    property Waehrung: WideString read Get_Waehrung write Set_Waehrung;
    property Tageskurs: Double read Get_Tageskurs write Set_Tageskurs;
    property Memotext: WideString read Get_Memotext write Set_Memotext;
    property OpAutomatik: WordBool read Get_OpAutomatik write Set_OpAutomatik;
    property KLRAutomatik: WordBool read Get_KLRAutomatik write Set_KLRAutomatik;
    property UStSatz: Double read Get_UStSatz write Set_UStSatz;
    property GegUStSatz: Double read Get_GegUStSatz write Set_GegUStSatz;
  published
  end;

// *********************************************************************//
// Die Klasse CoCmdPosten stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface ICmdPosten, dargestellt
// von CoClass CmdPosten, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoCmdPosten = class
    class function Create: ICmdPosten;
    class function CreateRemote(const MachineName: string): ICmdPosten;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TCmdPosten
// Hilfe-String      : CmdPosten Objekt
// Standard-Interface: ICmdPosten
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TCmdPosten = class(TOleServer)
  private
    FIntf: ICmdPosten;
    function GetDefaultInterface: ICmdPosten;
  protected
    procedure InitServerData; override;
    function Get_Betrag: Currency;
    procedure Set_Betrag(Value: Currency);
    function Get_OpArt: EOpArten;
    procedure Set_OpArt(Value: EOpArten);
    function Get_Konto: Integer;
    procedure Set_Konto(Value: Integer);
    function Get_GegKonto: Integer;
    procedure Set_GegKonto(Value: Integer);
    function Get_GegUStArt: EUStArten;
    procedure Set_GegUStArt(Value: EUStArten);
    function Get_GegUStSchl: Integer;
    procedure Set_GegUStSchl(Value: Integer);
    function Get_Belegnummer1: WideString;
    procedure Set_Belegnummer1(const Value: WideString);
    function Get_Belegnummer2: WideString;
    procedure Set_Belegnummer2(const Value: WideString);
    function Get_Buchtext: WideString;
    procedure Set_Buchtext(const Value: WideString);
    function Get_Belegdatum: TDateTime;
    procedure Set_Belegdatum(Value: TDateTime);
    function Get_Valutadatum: TDateTime;
    procedure Set_Valutadatum(Value: TDateTime);
    function Get_Zahlart: EZahlarten;
    procedure Set_Zahlart(Value: EZahlarten);
    function Get_Zahlkonditionen: IZahlkondition;
    function Get_Wechsel: Integer;
    procedure Set_Wechsel(Value: Integer);
    function Get_Skontofaehig: Currency;
    procedure Set_Skontofaehig(Value: Currency);
    function Get_Skontobetrag: Currency;
    procedure Set_Skontobetrag(Value: Currency);
    function Get_Zugeordnet: Integer;
    procedure Set_Zugeordnet(Value: Integer);
    function Get_Memotext: WideString;
    procedure Set_Memotext(const Value: WideString);
    function Get_CmdTyp: ECmdTypen;
    function Get_AsString: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICmdPosten);
    procedure Disconnect; override;
    procedure Clear;
    property DefaultInterface: ICmdPosten read GetDefaultInterface;
    property Zahlkonditionen: IZahlkondition read Get_Zahlkonditionen;
    property CmdTyp: ECmdTypen read Get_CmdTyp;
    property AsString: WideString read Get_AsString;
    property Betrag: Currency read Get_Betrag write Set_Betrag;
    property OpArt: EOpArten read Get_OpArt write Set_OpArt;
    property Konto: Integer read Get_Konto write Set_Konto;
    property GegKonto: Integer read Get_GegKonto write Set_GegKonto;
    property GegUStArt: EUStArten read Get_GegUStArt write Set_GegUStArt;
    property GegUStSchl: Integer read Get_GegUStSchl write Set_GegUStSchl;
    property Belegnummer1: WideString read Get_Belegnummer1 write Set_Belegnummer1;
    property Belegnummer2: WideString read Get_Belegnummer2 write Set_Belegnummer2;
    property Buchtext: WideString read Get_Buchtext write Set_Buchtext;
    property Belegdatum: TDateTime read Get_Belegdatum write Set_Belegdatum;
    property Valutadatum: TDateTime read Get_Valutadatum write Set_Valutadatum;
    property Zahlart: EZahlarten read Get_Zahlart write Set_Zahlart;
    property Wechsel: Integer read Get_Wechsel write Set_Wechsel;
    property Skontofaehig: Currency read Get_Skontofaehig write Set_Skontofaehig;
    property Skontobetrag: Currency read Get_Skontobetrag write Set_Skontobetrag;
    property Zugeordnet: Integer read Get_Zugeordnet write Set_Zugeordnet;
    property Memotext: WideString read Get_Memotext write Set_Memotext;
  published
  end;

// *********************************************************************//
// Die Klasse CoCmdKLR stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface ICmdKLR, dargestellt
// von CoClass CmdKLR, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoCmdKLR = class
    class function Create: ICmdKLR;
    class function CreateRemote(const MachineName: string): ICmdKLR;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TCmdKLR
// Hilfe-String      : CmdKLR Objekt
// Standard-Interface: ICmdKLR
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TCmdKLR = class(TOleServer)
  private
    FIntf: ICmdKLR;
    function GetDefaultInterface: ICmdKLR;
  protected
    procedure InitServerData; override;
    function Get_CmdTyp: ECmdTypen;
    function Get_AsString: WideString;
    function Get_Betrag: Currency;
    procedure Set_Betrag(Value: Currency);
    function Get_FixVar: EKostentypen;
    procedure Set_FixVar(Value: EKostentypen);
    function Get_Kostenstelle: Integer;
    procedure Set_Kostenstelle(Value: Integer);
    function Get_Kostentraeger: Integer;
    procedure Set_Kostentraeger(Value: Integer);
    function Get_Kostenart: Integer;
    procedure Set_Kostenart(Value: Integer);
    function Get_Sachkonto: Integer;
    procedure Set_Sachkonto(Value: Integer);
    function Get_SolHab: Integer;
    procedure Set_SolHab(Value: Integer);
    function Get_GegKonto: Integer;
    procedure Set_GegKonto(Value: Integer);
    function Get_Belegnummer1: WideString;
    procedure Set_Belegnummer1(const Value: WideString);
    function Get_Belegnummer2: WideString;
    procedure Set_Belegnummer2(const Value: WideString);
    function Get_Buchtext: WideString;
    procedure Set_Buchtext(const Value: WideString);
    function Get_Belegdatum: TDateTime;
    procedure Set_Belegdatum(Value: TDateTime);
    function Get_Art: Integer;
    procedure Set_Art(Value: Integer);
    function Get_Gruppe: Integer;
    procedure Set_Gruppe(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ICmdKLR);
    procedure Disconnect; override;
    procedure Clear;
    property DefaultInterface: ICmdKLR read GetDefaultInterface;
    property CmdTyp: ECmdTypen read Get_CmdTyp;
    property AsString: WideString read Get_AsString;
    property Betrag: Currency read Get_Betrag write Set_Betrag;
    property FixVar: EKostentypen read Get_FixVar write Set_FixVar;
    property Kostenstelle: Integer read Get_Kostenstelle write Set_Kostenstelle;
    property Kostentraeger: Integer read Get_Kostentraeger write Set_Kostentraeger;
    property Kostenart: Integer read Get_Kostenart write Set_Kostenart;
    property Sachkonto: Integer read Get_Sachkonto write Set_Sachkonto;
    property SolHab: Integer read Get_SolHab write Set_SolHab;
    property GegKonto: Integer read Get_GegKonto write Set_GegKonto;
    property Belegnummer1: WideString read Get_Belegnummer1 write Set_Belegnummer1;
    property Belegnummer2: WideString read Get_Belegnummer2 write Set_Belegnummer2;
    property Buchtext: WideString read Get_Buchtext write Set_Buchtext;
    property Belegdatum: TDateTime read Get_Belegdatum write Set_Belegdatum;
    property Art: Integer read Get_Art write Set_Art;
    property Gruppe: Integer read Get_Gruppe write Set_Gruppe;
  published
  end;

// *********************************************************************//
// Die Klasse CoKreditversicherung stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKreditversicherung, dargestellt
// von CoClass Kreditversicherung, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKreditversicherung = class
    class function Create: IKreditversicherung;
    class function CreateRemote(const MachineName: string): IKreditversicherung;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKreditversicherung
// Hilfe-String      : Kreditversicherung Objekt
// Standard-Interface: IKreditversicherung
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TKreditversicherung = class(TOleServer)
  private
    FIntf: IKreditversicherung;
    function GetDefaultInterface: IKreditversicherung;
  protected
    procedure InitServerData; override;
    function Get_Limit1: Currency;
    function Get_Limit2: Currency;
    function Get_LimitAb: TDateTime;
    function Get_Typ: Integer;
    function Get_Ziel: Integer;
    function Get_Status: Integer;
    function Get_Nummer: WideString;
    function Get_VersicherungNr: Integer;
    function Get_SummeOP: Currency;
    function Get_SummeWechsel: Currency;
    function Get_RE_Belegnummer: WideString;
    function Get_RE_Belegdatum: TDateTime;
    function Get_RE_Alter: Integer;
    function Get_IsDubios: WordBool;
    function Get_IsVerklagt: WordBool;
    function Get_IsInkasso: WordBool;
    function Get_IsKonkurs: WordBool;
    function Get_IsWechsel: WordBool;
    function Get_InternesLimit: Currency;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKreditversicherung);
    procedure Disconnect; override;
    property DefaultInterface: IKreditversicherung read GetDefaultInterface;
    property Limit1: Currency read Get_Limit1;
    property Limit2: Currency read Get_Limit2;
    property LimitAb: TDateTime read Get_LimitAb;
    property Typ: Integer read Get_Typ;
    property Ziel: Integer read Get_Ziel;
    property Status: Integer read Get_Status;
    property Nummer: WideString read Get_Nummer;
    property VersicherungNr: Integer read Get_VersicherungNr;
    property SummeOP: Currency read Get_SummeOP;
    property SummeWechsel: Currency read Get_SummeWechsel;
    property RE_Belegnummer: WideString read Get_RE_Belegnummer;
    property RE_Belegdatum: TDateTime read Get_RE_Belegdatum;
    property RE_Alter: Integer read Get_RE_Alter;
    property IsDubios: WordBool read Get_IsDubios;
    property IsVerklagt: WordBool read Get_IsVerklagt;
    property IsInkasso: WordBool read Get_IsInkasso;
    property IsKonkurs: WordBool read Get_IsKonkurs;
    property IsWechsel: WordBool read Get_IsWechsel;
    property InternesLimit: Currency read Get_InternesLimit;
  published
  end;

// *********************************************************************//
// Die Klasse CoArchiv stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IArchiv, dargestellt
// von CoClass Archiv, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoArchiv = class
    class function Create: IArchiv;
    class function CreateRemote(const MachineName: string): IArchiv;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TArchiv
// Hilfe-String      : Archiv Objekt
// Standard-Interface: IArchiv
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TArchiv = class(TOleServer)
  private
    FIntf: IArchiv;
    function GetDefaultInterface: IArchiv;
  protected
    procedure InitServerData; override;
    function Get_Mandant: Integer;
    function Get_Wirtschaftsjahr: Integer;
    function Get_Journalzeile: Integer;
    function Get_Barcode: WideString;
    function Get_Buchdatum: TDateTime;
    function Get_Konto: Integer;
    function Get_GegKonto: Integer;
    function Get_Betrag: Currency;
    function Get_Belegdatum: TDateTime;
    function Get_Belegnummer1: WideString;
    function Get_Belegnummer2: WideString;
    function Get_Buchtext: WideString;
    function Get_DokumentID: WideString;
    function Get_Waehrungsbetrag: Currency;
    function Get_Waehrungskurs: Double;
    function Get_Memotext: WideString;
    function Get_Benutzer: WideString;
    function Get_FullBarcode: WideString;
    function Get_BarcodeJahr: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IArchiv);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IArchiv read GetDefaultInterface;
    property Mandant: Integer read Get_Mandant;
    property Wirtschaftsjahr: Integer read Get_Wirtschaftsjahr;
    property Journalzeile: Integer read Get_Journalzeile;
    property Barcode: WideString read Get_Barcode;
    property Buchdatum: TDateTime read Get_Buchdatum;
    property Konto: Integer read Get_Konto;
    property GegKonto: Integer read Get_GegKonto;
    property Betrag: Currency read Get_Betrag;
    property Belegdatum: TDateTime read Get_Belegdatum;
    property Belegnummer1: WideString read Get_Belegnummer1;
    property Belegnummer2: WideString read Get_Belegnummer2;
    property Buchtext: WideString read Get_Buchtext;
    property DokumentID: WideString read Get_DokumentID;
    property Waehrungsbetrag: Currency read Get_Waehrungsbetrag;
    property Waehrungskurs: Double read Get_Waehrungskurs;
    property Memotext: WideString read Get_Memotext;
    property Benutzer: WideString read Get_Benutzer;
    property FullBarcode: WideString read Get_FullBarcode;
    property BarcodeJahr: Integer read Get_BarcodeJahr;
  published
  end;

// *********************************************************************//
// Die Klasse CoArchivierung stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IArchivierung, dargestellt
// von CoClass Archivierung, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoArchivierung = class
    class function Create: IArchivierung;
    class function CreateRemote(const MachineName: string): IArchivierung;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TArchivierung
// Hilfe-String      : Archivierung Objekt
// Standard-Interface: IArchivierung
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TArchivierung = class(TOleServer)
  private
    FIntf: IArchivierung;
    function GetDefaultInterface: IArchivierung;
  protected
    procedure InitServerData; override;
    function Get_NaechsterBarcode: Int64;
    procedure Set_NaechsterBarcode(Value: Int64);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IArchivierung);
    procedure Disconnect; override;
    function Archiv(ArchivTyp: EArchivTypen): IArchiv;
    function Barcodefinden(const aBarCode: WideString): IArchiv;
    function Belegarchiviert(const Barcode: WideString; JrnZl: Integer; const DocID: WideString; 
                             out ErrText: WideString): WordBool;
    function Barcodesuchen(ArchivTyp: EArchivTypen; const Barcode: WideString): IArchiv;
    function ExtractBarcode(const Image: WideString; const Extension: WideString): WideString;
    property DefaultInterface: IArchivierung read GetDefaultInterface;
    property NaechsterBarcode: Int64 read Get_NaechsterBarcode write Set_NaechsterBarcode;
  published
  end;

// *********************************************************************//
// Die Klasse CoBgMw stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IBgMw, dargestellt
// von CoClass BgMw, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoBgMw = class
    class function Create: IBgMw;
    class function CreateRemote(const MachineName: string): IBgMw;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TBgMw
// Hilfe-String      : BgMw Objekt
// Standard-Interface: IBgMw
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TBgMw = class(TOleServer)
  private
    FIntf: IBgMw;
    function GetDefaultInterface: IBgMw;
  protected
    procedure InitServerData; override;
    function Get_BGNr: Integer;
    function Get_KStTrNr: Integer;
    function Get_KArtNr: Integer;
    function Get_Bezugsgroesse: IBezugsgroesse;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBgMw);
    procedure Disconnect; override;
    function Monatswert(Monat: Integer): Double;
    function Navigate: INavigate;
    property DefaultInterface: IBgMw read GetDefaultInterface;
    property BGNr: Integer read Get_BGNr;
    property KStTrNr: Integer read Get_KStTrNr;
    property KArtNr: Integer read Get_KArtNr;
    property Bezugsgroesse: IBezugsgroesse read Get_Bezugsgroesse;
  published
  end;

// *********************************************************************//
// Die Klasse CoBatchScript stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IBatchScript, dargestellt
// von CoClass BatchScript, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoBatchScript = class
    class function Create: IBatchScript;
    class function CreateRemote(const MachineName: string): IBatchScript;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TBatchScript
// Hilfe-String      : BatchScript Objekt
// Standard-Interface: IBatchScript
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TBatchScript = class(TOleServer)
  private
    FIntf: IBatchScript;
    function GetDefaultInterface: IBatchScript;
  protected
    procedure InitServerData; override;
    function Get_Zeile: Integer;
    function Get_Status: Integer;
    function Get_Mandant: Integer;
    function Get_Buchdatum: TDateTime;
    function Get_Dateiname: WideString;
    function Get_Uebernahme: TDateTime;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBatchScript);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IBatchScript read GetDefaultInterface;
    property Zeile: Integer read Get_Zeile;
    property Status: Integer read Get_Status;
    property Mandant: Integer read Get_Mandant;
    property Buchdatum: TDateTime read Get_Buchdatum;
    property Dateiname: WideString read Get_Dateiname;
    property Uebernahme: TDateTime read Get_Uebernahme;
  published
  end;

// *********************************************************************//
// Die Klasse CoXML stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IXML, dargestellt
// von CoClass XML, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoXML = class
    class function Create: IXML;
    class function CreateRemote(const MachineName: string): IXML;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TXML
// Hilfe-String      : XML Objekt
// Standard-Interface: IXML
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TXML = class(TOleServer)
  private
    FIntf: IXML;
    function GetDefaultInterface: IXML;
  protected
    procedure InitServerData; override;
    function Get_OpenParams: WideString;
    procedure Set_OpenParams(const Value: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IXML);
    procedure Disconnect; override;
    function GetData(Value: EXMLTableTypen): WideString;
    property DefaultInterface: IXML read GetDefaultInterface;
    property OpenParams: WideString read Get_OpenParams write Set_OpenParams;
  published
  end;

// *********************************************************************//
// Die Klasse CoDCUebFiles stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IDCUebFiles, dargestellt
// von CoClass DCUebFiles, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoDCUebFiles = class
    class function Create: IDCUebFiles;
    class function CreateRemote(const MachineName: string): IDCUebFiles;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TDCUebFiles
// Hilfe-String      : DCUebFiles Objekt
// Standard-Interface: IDCUebFiles
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TDCUebFiles = class(TOleServer)
  private
    FIntf: IDCUebFiles;
    function GetDefaultInterface: IDCUebFiles;
  protected
    procedure InitServerData; override;
    function Get_Betrag: Currency;
    function Get_SollKonto: Integer;
    function Get_HabenKonto: Integer;
    function Get_Beleg1: WideString;
    function Get_Beleg2: WideString;
    function Get_Buchtext: WideString;
    function Get_Belegdatum: TDateTime;
    function Get_Dateiname: WideString;
    function Get_Erstellzeitpunkt: TDateTime;
    function Get_Dateigroesse: Integer;
    function Get_FileNummer: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDCUebFiles);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IDCUebFiles read GetDefaultInterface;
    property Betrag: Currency read Get_Betrag;
    property SollKonto: Integer read Get_SollKonto;
    property HabenKonto: Integer read Get_HabenKonto;
    property Beleg1: WideString read Get_Beleg1;
    property Beleg2: WideString read Get_Beleg2;
    property Buchtext: WideString read Get_Buchtext;
    property Belegdatum: TDateTime read Get_Belegdatum;
    property Dateiname: WideString read Get_Dateiname;
    property Erstellzeitpunkt: TDateTime read Get_Erstellzeitpunkt;
    property Dateigroesse: Integer read Get_Dateigroesse;
    property FileNummer: Integer read Get_FileNummer;
  published
  end;

// *********************************************************************//
// Die Klasse CoBgMwBeweg stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IBgBeweg, dargestellt
// von CoClass BgMwBeweg, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoBgMwBeweg = class
    class function Create: IBgBeweg;
    class function CreateRemote(const MachineName: string): IBgBeweg;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TBgMwBeweg
// Hilfe-String      : BgMwBeweg Objekt
// Standard-Interface: IBgBeweg
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TBgMwBeweg = class(TOleServer)
  private
    FIntf: IBgBeweg;
    function GetDefaultInterface: IBgBeweg;
  protected
    procedure InitServerData; override;
    function Get_BGNr: Integer;
    function Get_KStTrNr: Integer;
    function Get_Monatswert: Double;
    function Get_KArtNr: Integer;
    function Get_Bezugsgroesse: IBezugsgroesse;
    function Get_GegenKonto: Integer;
    function Get_Monat: Integer;
    function Get_IsLast: WordBool;
    function Get_Aufteilung: EBgAuftTypen;
    function Get_GegenkontoTyp: EKontotypen;
    function Get_KStTrTyp: EKontotypen;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBgBeweg);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IBgBeweg read GetDefaultInterface;
    property BGNr: Integer read Get_BGNr;
    property KStTrNr: Integer read Get_KStTrNr;
    property Monatswert: Double read Get_Monatswert;
    property KArtNr: Integer read Get_KArtNr;
    property Bezugsgroesse: IBezugsgroesse read Get_Bezugsgroesse;
    property GegenKonto: Integer read Get_GegenKonto;
    property Monat: Integer read Get_Monat;
    property IsLast: WordBool read Get_IsLast;
    property Aufteilung: EBgAuftTypen read Get_Aufteilung;
    property GegenkontoTyp: EKontotypen read Get_GegenkontoTyp;
    property KStTrTyp: EKontotypen read Get_KStTrTyp;
  published
  end;

// *********************************************************************//
// Die Klasse CoInventar stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IInventar, dargestellt
// von CoClass Inventar, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoInventar = class
    class function Create: IInventar;
    class function CreateRemote(const MachineName: string): IInventar;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TInventar
// Hilfe-String      : Inventar Objekt
// Standard-Interface: IInventar
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TInventar = class(TOleServer)
  private
    FIntf: IInventar;
    function GetDefaultInterface: IInventar;
  protected
    procedure InitServerData; override;
    function Get_Inventarnummer: WideString;
    procedure Set_Inventarnummer(const Value: WideString);
    function Get_WerkFilialNr: Integer;
    function Get_Standort: WideString;
    function Get_Anzahl: Integer;
    function Get_Seriennummer: WideString;
    function Get_Anlagedatum: TDateTime;
    function Get_Aenderungsdatum: TDateTime;
    function Get_Abgangsdatum: TDateTime;
    function Get_Wirtschaftsgutart: Integer;
    function Get_Erinnerungswert: Currency;
    function Get_IsBebucht: WordBool;
    function Get_IsValid: WordBool;
    function Get_IsAbgegangen: WordBool;
    function Get_IsGenutzt: WordBool;
    function Get_IsGebraucht: WordBool;
    function Get_IsLeasing: WordBool;
    function Get_IsVerpachtet: WordBool;
    function Get_IsAfaAutomatisch: WordBool;
    function Get_Kreditorennummer: Integer;
    function Get_Anschaffungsdatum: TDateTime;
    function Get_Waehrungsnummer: Integer;
    function Get_IsFuehrungssatz: WordBool;
    function Get_InventurNr: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IInventar);
    procedure Disconnect; override;
    function Bezeichnung(Nr: Integer): WideString;
    function Navigate: INavigate;
    function GrpNummer(Nr: Integer): Integer;
    function Ebene(EbeneNr: EInventarebenen): IInventarebene;
    function Status(EbeneNr: EInventarebenen; perDatum: TDateTime; simAfA: WordBool): IInventarstatus;
    function KLRAnteil: IInventarKLRAnteil;
    function Information(Nr: Integer): WideString;
    function Waehrung: IWaehrung;
    function InventarJournal(EbeneNr: EInventarebenen): IInventarJournal;
    function GrpDatumAb(Nr: Integer): TDateTime;
    function GrpDatumBis(Nr: Integer): TDateTime;
    property DefaultInterface: IInventar read GetDefaultInterface;
    property WerkFilialNr: Integer read Get_WerkFilialNr;
    property Standort: WideString read Get_Standort;
    property Anzahl: Integer read Get_Anzahl;
    property Seriennummer: WideString read Get_Seriennummer;
    property Anlagedatum: TDateTime read Get_Anlagedatum;
    property Aenderungsdatum: TDateTime read Get_Aenderungsdatum;
    property Abgangsdatum: TDateTime read Get_Abgangsdatum;
    property Wirtschaftsgutart: Integer read Get_Wirtschaftsgutart;
    property Erinnerungswert: Currency read Get_Erinnerungswert;
    property IsBebucht: WordBool read Get_IsBebucht;
    property IsValid: WordBool read Get_IsValid;
    property IsAbgegangen: WordBool read Get_IsAbgegangen;
    property IsGenutzt: WordBool read Get_IsGenutzt;
    property IsGebraucht: WordBool read Get_IsGebraucht;
    property IsLeasing: WordBool read Get_IsLeasing;
    property IsVerpachtet: WordBool read Get_IsVerpachtet;
    property IsAfaAutomatisch: WordBool read Get_IsAfaAutomatisch;
    property Kreditorennummer: Integer read Get_Kreditorennummer;
    property Anschaffungsdatum: TDateTime read Get_Anschaffungsdatum;
    property Waehrungsnummer: Integer read Get_Waehrungsnummer;
    property IsFuehrungssatz: WordBool read Get_IsFuehrungssatz;
    property InventurNr: Integer read Get_InventurNr;
    property Inventarnummer: WideString read Get_Inventarnummer write Set_Inventarnummer;
  published
  end;

// *********************************************************************//
// Die Klasse CoInventarebene stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IInventarebene, dargestellt
// von CoClass Inventarebene, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoInventarebene = class
    class function Create: IInventarebene;
    class function CreateRemote(const MachineName: string): IInventarebene;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TInventarebene
// Hilfe-String      : Inventarebene Objekt
// Standard-Interface: IInventarebene
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (0)
// *********************************************************************//
  TInventarebene = class(TOleServer)
  private
    FIntf: IInventarebene;
    function GetDefaultInterface: IInventarebene;
  protected
    procedure InitServerData; override;
    function Get_Fibukonto: Integer;
    function Get_AfAKonto: Integer;
    function Get_Nutzbeginn: TDateTime;
    function Get_NutzdauerJahre: Integer;
    function Get_NutzdauerMonate: Integer;
    function Get_AfAArtNr: Integer;
    function Get_AfASchluessel: Integer;
    function Get_Schichtfaktor: Currency;
    function Get_IsSonderAfA: WordBool;
    function Get_SonderAfaMaxProzent: Currency;
    function Get_IsVereinfachungsregel: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IInventarebene);
    procedure Disconnect; override;
    property DefaultInterface: IInventarebene read GetDefaultInterface;
    property Fibukonto: Integer read Get_Fibukonto;
    property AfAKonto: Integer read Get_AfAKonto;
    property Nutzbeginn: TDateTime read Get_Nutzbeginn;
    property NutzdauerJahre: Integer read Get_NutzdauerJahre;
    property NutzdauerMonate: Integer read Get_NutzdauerMonate;
    property AfAArtNr: Integer read Get_AfAArtNr;
    property AfASchluessel: Integer read Get_AfASchluessel;
    property Schichtfaktor: Currency read Get_Schichtfaktor;
    property IsSonderAfA: WordBool read Get_IsSonderAfA;
    property SonderAfaMaxProzent: Currency read Get_SonderAfaMaxProzent;
    property IsVereinfachungsregel: WordBool read Get_IsVereinfachungsregel;
  published
  end;

// *********************************************************************//
// Die Klasse CoInventarstatus stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IInventarstatus, dargestellt
// von CoClass Inventarstatus, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoInventarstatus = class
    class function Create: IInventarstatus;
    class function CreateRemote(const MachineName: string): IInventarstatus;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TInventarstatus
// Hilfe-String      : Inventarstatus Objekt
// Standard-Interface: IInventarstatus
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TInventarstatus = class(TOleServer)
  private
    FIntf: IInventarstatus;
    function GetDefaultInterface: IInventarstatus;
  protected
    procedure InitServerData; override;
    function Get_Anschaffungskosten: Currency;
    function Get_Abschreibung: Currency;
    function Get_Restbuchwert: Currency;
    function Get_AnschaffungskostenAnfang: Currency;
    function Get_AnschaffungskostenZugang: Currency;
    function Get_AnschaffungskostenAbgang: Currency;
    function Get_AnschaffungskostenUmbuchung: Currency;
    function Get_AbschreibungAnfang: Currency;
    function Get_AbschreibungZugang: Currency;
    function Get_AbschreibungAbgang: Currency;
    function Get_AbschreibungUmbuchung: Currency;
    function Get_AbschreibungSimulation: Currency;
    function Get_RestbuchwertAnfang: Currency;
    function Get_RestbuchwertAbgang: Currency;
    function Get_RestbuchwertUmbuchung: Currency;
    function Get_RestbuchwertZugang: Currency;
    function Get_Sonderabschreibung: Currency;
    function Get_SonderabschreibungAnfang: Currency;
    function Get_SonderabschreibungZugang: Currency;
    function Get_AbschreibungProzent: Double;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IInventarstatus);
    procedure Disconnect; override;
    property DefaultInterface: IInventarstatus read GetDefaultInterface;
    property Anschaffungskosten: Currency read Get_Anschaffungskosten;
    property Abschreibung: Currency read Get_Abschreibung;
    property Restbuchwert: Currency read Get_Restbuchwert;
    property AnschaffungskostenAnfang: Currency read Get_AnschaffungskostenAnfang;
    property AnschaffungskostenZugang: Currency read Get_AnschaffungskostenZugang;
    property AnschaffungskostenAbgang: Currency read Get_AnschaffungskostenAbgang;
    property AnschaffungskostenUmbuchung: Currency read Get_AnschaffungskostenUmbuchung;
    property AbschreibungAnfang: Currency read Get_AbschreibungAnfang;
    property AbschreibungZugang: Currency read Get_AbschreibungZugang;
    property AbschreibungAbgang: Currency read Get_AbschreibungAbgang;
    property AbschreibungUmbuchung: Currency read Get_AbschreibungUmbuchung;
    property AbschreibungSimulation: Currency read Get_AbschreibungSimulation;
    property RestbuchwertAnfang: Currency read Get_RestbuchwertAnfang;
    property RestbuchwertAbgang: Currency read Get_RestbuchwertAbgang;
    property RestbuchwertUmbuchung: Currency read Get_RestbuchwertUmbuchung;
    property RestbuchwertZugang: Currency read Get_RestbuchwertZugang;
    property Sonderabschreibung: Currency read Get_Sonderabschreibung;
    property SonderabschreibungAnfang: Currency read Get_SonderabschreibungAnfang;
    property SonderabschreibungZugang: Currency read Get_SonderabschreibungZugang;
    property AbschreibungProzent: Double read Get_AbschreibungProzent;
  published
  end;

// *********************************************************************//
// Die Klasse CoInventarKLRAnteil stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IInventarKLRAnteil, dargestellt
// von CoClass InventarKLRAnteil, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoInventarKLRAnteil = class
    class function Create: IInventarKLRAnteil;
    class function CreateRemote(const MachineName: string): IInventarKLRAnteil;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TInventarKLRAnteil
// Hilfe-String      : InventarKLRAnteil Objekt
// Standard-Interface: IInventarKLRAnteil
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TInventarKLRAnteil = class(TOleServer)
  private
    FIntf: IInventarKLRAnteil;
    function GetDefaultInterface: IInventarKLRAnteil;
  protected
    procedure InitServerData; override;
    function Get_IsKostenstelle: WordBool;
    function Get_IsKostentraeger: WordBool;
    function Get_KoStTrNr: Integer;
    function Get_Ordnung: Integer;
    function Get_Anteil: Integer;
    function Get_AbDatum: TDateTime;
    function Get_BisDatum: TDateTime;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IInventarKLRAnteil);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IInventarKLRAnteil read GetDefaultInterface;
    property IsKostenstelle: WordBool read Get_IsKostenstelle;
    property IsKostentraeger: WordBool read Get_IsKostentraeger;
    property KoStTrNr: Integer read Get_KoStTrNr;
    property Ordnung: Integer read Get_Ordnung;
    property Anteil: Integer read Get_Anteil;
    property AbDatum: TDateTime read Get_AbDatum;
    property BisDatum: TDateTime read Get_BisDatum;
  published
  end;

// *********************************************************************//
// Die Klasse CoServer stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IServer, dargestellt
// von CoClass Server, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoServer = class
    class function Create: IServer;
    class function CreateRemote(const MachineName: string): IServer;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TServer
// Hilfe-String      : Server Objekt
// Standard-Interface: IServer
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TServer = class(TOleServer)
  private
    FIntf: IServer;
    function GetDefaultInterface: IServer;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IServer);
    procedure Disconnect; override;
    function ConnectionCount: Integer;
    procedure ShutDown;
    property DefaultInterface: IServer read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// Die Klasse CoBranche stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IBranche, dargestellt
// von CoClass Branche, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoBranche = class
    class function Create: IBranche;
    class function CreateRemote(const MachineName: string): IBranche;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TBranche
// Hilfe-String      : Branche Objekt
// Standard-Interface: IBranche
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TBranche = class(TOleServer)
  private
    FIntf: IBranche;
    function GetDefaultInterface: IBranche;
  protected
    procedure InitServerData; override;
    function Get_Bezeichnung: WideString;
    function Get_Schluessel: Integer;
    procedure Set_Schluessel(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBranche);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IBranche read GetDefaultInterface;
    property Bezeichnung: WideString read Get_Bezeichnung;
    property Schluessel: Integer read Get_Schluessel write Set_Schluessel;
  published
  end;

// *********************************************************************//
// Die Klasse CoWechsel stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IWechsel, dargestellt
// von CoClass Wechsel, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoWechsel = class
    class function Create: IWechsel;
    class function CreateRemote(const MachineName: string): IWechsel;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TWechsel
// Hilfe-String      : Wechsel Objekt
// Standard-Interface: IWechsel
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TWechsel = class(TOleServer)
  private
    FIntf: IWechsel;
    function GetDefaultInterface: IWechsel;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    procedure Set_Nummer(Value: Integer);
    function Get_Art: EWechselarten;
    function Get_Konto1: Integer;
    function Get_Konto2: Integer;
    function Get_Hauswaehrung: Integer;
    function Get_HwBetrag: Currency;
    function Get_Fremdwaehrung: Integer;
    function Get_FwBetrag: Currency;
    function Get_Verwendung: EWechselverwendungen;
    function Get_Bezogener: Integer;
    function Get_Aussteller: Integer;
    function Get_Indossant: Integer;
    function Get_Indossatar: Integer;
    function Get_AnOrder: Integer;
    function Get_ZahlbarIn: WideString;
    function Get_ZahlbarBeiBank: WideString;
    function Get_ZahlbarBeiBKtNr: WideString;
    function Get_IBAN: WideString;
    function Get_AusstellOrt: WideString;
    function Get_AusstellDatum: TDateTime;
    function Get_FaelligDatum: TDateTime;
    function Get_AkzeptiertDatum: TDateTime;
    function Get_VersandDatum: TDateTime;
    function Get_VersandAn: Integer;
    function Get_Eingangsdatum: TDateTime;
    function Get_EingangVon: Integer;
    function Get_Ausgangsdatum: TDateTime;
    function Get_Diskontbank: Integer;
    function Get_DiskontDatum: TDateTime;
    function Get_DiskontoNr: WideString;
    function Get_ProlongDatum: TDateTime;
    function Get_ProtestDatum: TDateTime;
    function Get_Anlagedatum: TDateTime;
    function Get_Ursprungskonto: Integer;
    function Get_FibuNetBankKonto: Integer;
    function Get_Einloesdatum: TDateTime;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IWechsel);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IWechsel read GetDefaultInterface;
    property Art: EWechselarten read Get_Art;
    property Konto1: Integer read Get_Konto1;
    property Konto2: Integer read Get_Konto2;
    property Hauswaehrung: Integer read Get_Hauswaehrung;
    property HwBetrag: Currency read Get_HwBetrag;
    property Fremdwaehrung: Integer read Get_Fremdwaehrung;
    property FwBetrag: Currency read Get_FwBetrag;
    property Verwendung: EWechselverwendungen read Get_Verwendung;
    property Bezogener: Integer read Get_Bezogener;
    property Aussteller: Integer read Get_Aussteller;
    property Indossant: Integer read Get_Indossant;
    property Indossatar: Integer read Get_Indossatar;
    property AnOrder: Integer read Get_AnOrder;
    property ZahlbarIn: WideString read Get_ZahlbarIn;
    property ZahlbarBeiBank: WideString read Get_ZahlbarBeiBank;
    property ZahlbarBeiBKtNr: WideString read Get_ZahlbarBeiBKtNr;
    property IBAN: WideString read Get_IBAN;
    property AusstellOrt: WideString read Get_AusstellOrt;
    property AusstellDatum: TDateTime read Get_AusstellDatum;
    property FaelligDatum: TDateTime read Get_FaelligDatum;
    property AkzeptiertDatum: TDateTime read Get_AkzeptiertDatum;
    property VersandDatum: TDateTime read Get_VersandDatum;
    property VersandAn: Integer read Get_VersandAn;
    property Eingangsdatum: TDateTime read Get_Eingangsdatum;
    property EingangVon: Integer read Get_EingangVon;
    property Ausgangsdatum: TDateTime read Get_Ausgangsdatum;
    property Diskontbank: Integer read Get_Diskontbank;
    property DiskontDatum: TDateTime read Get_DiskontDatum;
    property DiskontoNr: WideString read Get_DiskontoNr;
    property ProlongDatum: TDateTime read Get_ProlongDatum;
    property ProtestDatum: TDateTime read Get_ProtestDatum;
    property Anlagedatum: TDateTime read Get_Anlagedatum;
    property Ursprungskonto: Integer read Get_Ursprungskonto;
    property FibuNetBankKonto: Integer read Get_FibuNetBankKonto;
    property Einloesdatum: TDateTime read Get_Einloesdatum;
    property Nummer: Integer read Get_Nummer write Set_Nummer;
  published
  end;

// *********************************************************************//
// Die Klasse CoTageskurs stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface ITageskurs, dargestellt
// von CoClass Tageskurs, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoTageskurs = class
    class function Create: ITageskurs;
    class function CreateRemote(const MachineName: string): ITageskurs;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TTageskurs
// Hilfe-String      : Tageskurs Objekt
// Standard-Interface: ITageskurs
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TTageskurs = class(TOleServer)
  private
    FIntf: ITageskurs;
    function GetDefaultInterface: ITageskurs;
  protected
    procedure InitServerData; override;
    function Get_Tagesdatum: TDateTime;
    procedure Set_Tagesdatum(Value: TDateTime);
    function Get_Geldkurs: Currency;
    function Get_Briefkurs: Currency;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ITageskurs);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: ITageskurs read GetDefaultInterface;
    property Geldkurs: Currency read Get_Geldkurs;
    property Briefkurs: Currency read Get_Briefkurs;
    property Tagesdatum: TDateTime read Get_Tagesdatum write Set_Tagesdatum;
  published
  end;

// *********************************************************************//
// Die Klasse CoEGSteuer stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IEGSteuer, dargestellt
// von CoClass EGSteuer, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoEGSteuer = class
    class function Create: IEGSteuer;
    class function CreateRemote(const MachineName: string): IEGSteuer;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TEGSteuer
// Hilfe-String      : EGSteuer Objekt
// Standard-Interface: IEGSteuer
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TEGSteuer = class(TOleServer)
  private
    FIntf: IEGSteuer;
    function GetDefaultInterface: IEGSteuer;
  protected
    procedure InitServerData; override;
    function Get_UID: WideString;
    function Get_Erwerbschwelle: Currency;
    function Get_Lieferschwelle: Currency;
    function Get_Lkz: WideString;
    procedure Set_Lkz(const Value: WideString);
    function Get_EUMitgliedSeit: TDateTime;
    function Get_UStIdLen: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IEGSteuer);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Land(Value: Integer): WideString;
    function GueltigAb(IdxValue: Integer; StSchlValue: Integer): TDateTime;
    function Steuersatz(IdxValue: Integer; StSchlValue: Integer): Double;
    function AbDatum(IdxValue: Integer): TDateTime;
    function FindSteuersatz(const Lkz: WideString; Schluessel: Integer; Belegdatum: TDateTime): Double;
    function FindSteuerschluessel(const Lkz: WideString; Prozent: Double; Belegdatum: TDateTime): Integer;
    property DefaultInterface: IEGSteuer read GetDefaultInterface;
    property UID: WideString read Get_UID;
    property Erwerbschwelle: Currency read Get_Erwerbschwelle;
    property Lieferschwelle: Currency read Get_Lieferschwelle;
    property EUMitgliedSeit: TDateTime read Get_EUMitgliedSeit;
    property UStIdLen: Integer read Get_UStIdLen;
    property Lkz: WideString read Get_Lkz write Set_Lkz;
  published
  end;

// *********************************************************************//
// Die Klasse CoScheck stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IScheck, dargestellt
// von CoClass Scheck, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoScheck = class
    class function Create: IScheck;
    class function CreateRemote(const MachineName: string): IScheck;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TScheck
// Hilfe-String      : Scheck Objekt
// Standard-Interface: IScheck
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TScheck = class(TOleServer)
  private
    FIntf: IScheck;
    function GetDefaultInterface: IScheck;
  protected
    procedure InitServerData; override;
    function Get_Nummer: WideString;
    function Get_Tagesdatum: TDateTime;
    function Get_Betrag: Currency;
    function Get_Skonto: Currency;
    function Get_Konto: Integer;
    function Get_Zahldatum: TDateTime;
    function Get_KTO: WideString;
    function Get_BLZ: Integer;
    function Get_WaNr: Integer;
    function Get_WaBetrag: Currency;
    function Get_WaSkonto: Currency;
    function Get_FrmNr: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IScheck);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Zahlbuchung(Belegdatum: TDateTime; Wertdatum: TDateTime): WideString;
    function Loeschen: WordBool;
    property DefaultInterface: IScheck read GetDefaultInterface;
    property Nummer: WideString read Get_Nummer;
    property Tagesdatum: TDateTime read Get_Tagesdatum;
    property Betrag: Currency read Get_Betrag;
    property Skonto: Currency read Get_Skonto;
    property Konto: Integer read Get_Konto;
    property Zahldatum: TDateTime read Get_Zahldatum;
    property KTO: WideString read Get_KTO;
    property BLZ: Integer read Get_BLZ;
    property WaNr: Integer read Get_WaNr;
    property WaBetrag: Currency read Get_WaBetrag;
    property WaSkonto: Currency read Get_WaSkonto;
    property FrmNr: Integer read Get_FrmNr;
  published
  end;

// *********************************************************************//
// Die Klasse CoInventarJournal stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IInventarJournal, dargestellt
// von CoClass InventarJournal, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoInventarJournal = class
    class function Create: IInventarJournal;
    class function CreateRemote(const MachineName: string): IInventarJournal;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TInventarJournal
// Hilfe-String      : InventarJournal Objekt
// Standard-Interface: IInventarJournal
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TInventarJournal = class(TOleServer)
  private
    FIntf: IInventarJournal;
    function GetDefaultInterface: IInventarJournal;
  protected
    procedure InitServerData; override;
    function Get_Inventarnummer: WideString;
    function Get_Bewegungsart: Integer;
    function Get_Einheit: Integer;
    function Get_Buchkenner: Integer;
    function Get_BuchJournalZeile: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IInventarJournal);
    procedure Disconnect; override;
    function Navigate: INavigate;
    function Kontierung: IKontierung;
    property DefaultInterface: IInventarJournal read GetDefaultInterface;
    property Inventarnummer: WideString read Get_Inventarnummer;
    property Bewegungsart: Integer read Get_Bewegungsart;
    property Einheit: Integer read Get_Einheit;
    property Buchkenner: Integer read Get_Buchkenner;
    property BuchJournalZeile: Integer read Get_BuchJournalZeile;
  published
  end;

// *********************************************************************//
// Die Klasse CoKreditkarte stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKreditkarte, dargestellt
// von CoClass Kreditkarte, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKreditkarte = class
    class function Create: IKreditkarte;
    class function CreateRemote(const MachineName: string): IKreditkarte;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKreditkarte
// Hilfe-String      : Kreditkarte Objekt
// Standard-Interface: IKreditkarte
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TKreditkarte = class(TOleServer)
  private
    FIntf: IKreditkarte;
    function GetDefaultInterface: IKreditkarte;
  protected
    procedure InitServerData; override;
    function Get_Marke: Integer;
    function Get_Nummer: WideString;
    function Get_CVC: WideString;
    function Get_GueltigBis: TDateTime;
    function Get_Inhaber: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKreditkarte);
    procedure Disconnect; override;
    property DefaultInterface: IKreditkarte read GetDefaultInterface;
    property Marke: Integer read Get_Marke;
    property Nummer: WideString read Get_Nummer;
    property CVC: WideString read Get_CVC;
    property GueltigBis: TDateTime read Get_GueltigBis;
    property Inhaber: WideString read Get_Inhaber;
  published
  end;

// *********************************************************************//
// Die Klasse CoVerteilung stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IVerteilung, dargestellt
// von CoClass Verteilung, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoVerteilung = class
    class function Create: IVerteilung;
    class function CreateRemote(const MachineName: string): IVerteilung;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TVerteilung
// Hilfe-String      : Verteilung Objekt
// Standard-Interface: IVerteilung
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TVerteilung = class(TOleServer)
  private
    FIntf: IVerteilung;
    function GetDefaultInterface: IVerteilung;
  protected
    procedure InitServerData; override;
    function Get_vertIsKostenstelle: WordBool;
    function Get_vertStTr: Integer;
    function Get_empfIsKostenstelle: WordBool;
    function Get_empfStTr: Integer;
    function Get_Kostenart: Integer;
    function Get_Betrag: Currency;
    function Get_BGS: Integer;
    function Get_Monat: Integer;
    function Get_FixVar: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IVerteilung);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IVerteilung read GetDefaultInterface;
    property vertIsKostenstelle: WordBool read Get_vertIsKostenstelle;
    property vertStTr: Integer read Get_vertStTr;
    property empfIsKostenstelle: WordBool read Get_empfIsKostenstelle;
    property empfStTr: Integer read Get_empfStTr;
    property Kostenart: Integer read Get_Kostenart;
    property Betrag: Currency read Get_Betrag;
    property BGS: Integer read Get_BGS;
    property Monat: Integer read Get_Monat;
    property FixVar: Integer read Get_FixVar;
  published
  end;

// *********************************************************************//
// Die Klasse CoElster stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IElster, dargestellt
// von CoClass Elster, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoElster = class
    class function Create: IElster;
    class function CreateRemote(const MachineName: string): IElster;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TElster
// Hilfe-String      : Elster Objekt
// Standard-Interface: IElster
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TElster = class(TOleServer)
  private
    FIntf: IElster;
    function GetDefaultInterface: IElster;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IElster);
    procedure Disconnect; override;
    function LoadElsterFile(const Filename: WideString; IsDelete: WordBool): OleVariant;
    procedure SaveElsterFile(const Filename: WideString; Data: OleVariant);
    function GetElsterFileList: WideString;
    property DefaultInterface: IElster read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// Die Klasse CoKLRAutomatik stellt die Methoden Create und CreateRemote zur
// Verfügung, um Instanzen des Standard-Interface IKLRAutomatik, dargestellt
// von CoClass KLRAutomatik, zu erzeugen. Diese Funktionen können
// von einem Client verwendet werden, der die CoClasses automatisieren
// will, die von dieser Typbibliothek dargestellt werden.                                           
// *********************************************************************//
  CoKLRAutomatik = class
    class function Create: IKLRAutomatik;
    class function CreateRemote(const MachineName: string): IKLRAutomatik;
  end;


// *********************************************************************//
// OLE-Server-Proxy-Klassendeklaration
// Server-Objekt     : TKLRAutomatik
// Hilfe-String      : KLRAutomatik Objekt
// Standard-Interface: IKLRAutomatik
// Def. Intf. DISP?  : No
// Ereignis-Interface: 
// TypeFlags         : (2) CanCreate
// *********************************************************************//
  TKLRAutomatik = class(TOleServer)
  private
    FIntf: IKLRAutomatik;
    function GetDefaultInterface: IKLRAutomatik;
  protected
    procedure InitServerData; override;
    function Get_Nummer: Integer;
    function Get_Bezeichnung: WideString;
    function Get_KurzBez: WideString;
    function Get_IsSachkonto: WordBool;
    function Get_IsDebitor: WordBool;
    function Get_IsKreditor: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IKLRAutomatik);
    procedure Disconnect; override;
    function Navigate: INavigate;
    property DefaultInterface: IKLRAutomatik read GetDefaultInterface;
    property Nummer: Integer read Get_Nummer;
    property Bezeichnung: WideString read Get_Bezeichnung;
    property KurzBez: WideString read Get_KurzBez;
    property IsSachkonto: WordBool read Get_IsSachkonto;
    property IsDebitor: WordBool read Get_IsDebitor;
    property IsKreditor: WordBool read Get_IsKreditor;
  published
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses System.Win.ComObj;

class function CoFNFactory.Create: IFNFactory;
begin
  Result := CreateComObject(CLASS_FNFactory) as IFNFactory;
end;

class function CoFNFactory.CreateRemote(const MachineName: string): IFNFactory;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FNFactory) as IFNFactory;
end;

procedure TFNFactory.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B02C2E24-78AB-447C-AE84-25F82607B44D}';
    IntfIID:   '{62E713E8-F920-457A-B3AE-936F377A51CA}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFNFactory.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFNFactory;
  end;
end;

procedure TFNFactory.ConnectTo(svrIntf: IFNFactory);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFNFactory.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFNFactory.GetDefaultInterface: IFNFactory;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TFNFactory.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFNFactory.Destroy;
begin
  inherited Destroy;
end;

function TFNFactory.Get_Buchdatum: TDateTime;
begin
  Result := DefaultInterface.Buchdatum;
end;

procedure TFNFactory.Set_Buchdatum(Value: TDateTime);
begin
  DefaultInterface.Buchdatum := Value;
end;

function TFNFactory.Get_Separator: WideString;
begin
  Result := DefaultInterface.Separator;
end;

procedure TFNFactory.Set_Separator(const Value: WideString);
begin
  DefaultInterface.Separator := Value;
end;

function TFNFactory.Get_Stapelstatus: WordBool;
begin
  Result := DefaultInterface.Stapelstatus;
end;

procedure TFNFactory.Set_Stapelstatus(Value: WordBool);
begin
  DefaultInterface.Stapelstatus := Value;
end;

function TFNFactory.Get_ClientComputerName: WideString;
begin
  Result := DefaultInterface.ClientComputerName;
end;

procedure TFNFactory.Set_ClientComputerName(const Value: WideString);
begin
  DefaultInterface.ClientComputerName := Value;
end;

function TFNFactory.Get_Wirtschaftsjahr(Datum: TDateTime): Integer;
begin
  Result := DefaultInterface.Wirtschaftsjahr[Datum];
end;

function TFNFactory.Get_Releasestand: Integer;
begin
  Result := DefaultInterface.Releasestand;
end;

function TFNFactory.Get_ServerLog: WideString;
begin
  Result := DefaultInterface.ServerLog;
end;

function TFNFactory.Get_WirtschaftsjahrAnfang(Datum: TDateTime): TDateTime;
begin
  Result := DefaultInterface.WirtschaftsjahrAnfang[Datum];
end;

function TFNFactory.Get_WirtschaftsjahrEnde(Datum: TDateTime): TDateTime;
begin
  Result := DefaultInterface.WirtschaftsjahrEnde[Datum];
end;

function TFNFactory.Get_DatenIdentitaet: WideString;
begin
  Result := DefaultInterface.DatenIdentitaet;
end;

function TFNFactory.Mandant: IMandant;
begin
  Result := DefaultInterface.Mandant;
end;

function TFNFactory.GetSalden(VonKonto: Integer; BisKonto: Integer; OhneSaldo: WordBool): OleVariant;
begin
  Result := DefaultInterface.GetSalden(VonKonto, BisKonto, OhneSaldo);
end;

function TFNFactory.GetOp(VonKonto: Integer; BisKonto: Integer; AllePosten: WordBool): OleVariant;
begin
  Result := DefaultInterface.GetOp(VonKonto, BisKonto, AllePosten);
end;

function TFNFactory.GetJrnRows(VonKonto: Integer; BisKonto: Integer; VonJrnRow: Integer; 
                               BisJrnRow: Integer): OleVariant;
begin
  Result := DefaultInterface.GetJrnRows(VonKonto, BisKonto, VonJrnRow, BisJrnRow);
end;

function TFNFactory.GetAdresse(VonKonto: Integer; BisKonto: Integer): OleVariant;
begin
  Result := DefaultInterface.GetAdresse(VonKonto, BisKonto);
end;

function TFNFactory.Buchen: IBuchen;
begin
  Result := DefaultInterface.Buchen;
end;

function TFNFactory.GetKreditversicherung(VonKonto: Integer; BisKonto: Integer; MitSaldo: WordBool): OleVariant;
begin
  Result := DefaultInterface.GetKreditversicherung(VonKonto, BisKonto, MitSaldo);
end;

function TFNFactory.GetSachkonto(VonKonto: Integer; BisKonto: Integer): OleVariant;
begin
  Result := DefaultInterface.GetSachkonto(VonKonto, BisKonto);
end;

function TFNFactory.GetKostenstelle(VonKSt: Integer; BisKSt: Integer): OleVariant;
begin
  Result := DefaultInterface.GetKostenstelle(VonKSt, BisKSt);
end;

function TFNFactory.GetKostentraeger(VonKTr: Integer; BisKTr: Integer): OleVariant;
begin
  Result := DefaultInterface.GetKostentraeger(VonKTr, BisKTr);
end;

function TFNFactory.GetKostenart(VonKArt: Integer; BisKArt: Integer): OleVariant;
begin
  Result := DefaultInterface.GetKostenart(VonKArt, BisKArt);
end;

function TFNFactory.User: IUser;
begin
  Result := DefaultInterface.User;
end;

function TFNFactory.Finanzamt: IFinanzamt;
begin
  Result := DefaultInterface.Finanzamt;
end;

function TFNFactory.Bank: IBank;
begin
  Result := DefaultInterface.Bank;
end;

function TFNFactory.ChooseMandant: IChooseMandant;
begin
  Result := DefaultInterface.ChooseMandant;
end;

function TFNFactory.Passwort: IPasswort;
begin
  Result := DefaultInterface.Passwort;
end;

function TFNFactory.CheckUStIdNr(const IdNr: WideString): WordBool;
begin
  Result := DefaultInterface.CheckUStIdNr(IdNr);
end;

function TFNFactory.Ort: IOrt;
begin
  Result := DefaultInterface.Ort;
end;

function TFNFactory.Lizenz: ILizenz;
begin
  Result := DefaultInterface.Lizenz;
end;

function TFNFactory.BatchScript: IBatchScript;
begin
  Result := DefaultInterface.BatchScript;
end;

function TFNFactory.Server: IServer;
begin
  Result := DefaultInterface.Server;
end;

function TFNFactory.Branche: IBranche;
begin
  Result := DefaultInterface.Branche;
end;

function TFNFactory.Land: ILand;
begin
  Result := DefaultInterface.Land;
end;

function TFNFactory.Waehrung: IWaehrung;
begin
  Result := DefaultInterface.Waehrung;
end;

function TFNFactory.EGSteuer: IEGSteuer;
begin
  Result := DefaultInterface.EGSteuer;
end;

function TFNFactory.Elster: IElster;
begin
  Result := DefaultInterface.Elster;
end;

procedure TFNFactory.SetCurrentOrMaxDate;
begin
  DefaultInterface.SetCurrentOrMaxDate;
end;

function TFNFactory.GetZahlartBez(Nr: Integer): WideString;
begin
  Result := DefaultInterface.GetZahlartBez(Nr);
end;

class function CoUser.Create: IUser;
begin
  Result := CreateComObject(CLASS_User) as IUser;
end;

class function CoUser.CreateRemote(const MachineName: string): IUser;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_User) as IUser;
end;

procedure TUser.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{85676612-B97D-46B1-9D9B-B30CE4247183}';
    IntfIID:   '{E29B6B1D-30C4-4FE5-BC2C-12B9AB095984}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TUser.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IUser;
  end;
end;

procedure TUser.ConnectTo(svrIntf: IUser);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TUser.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TUser.GetDefaultInterface: IUser;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TUser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TUser.Destroy;
begin
  inherited Destroy;
end;

function TUser.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

procedure TUser.Set_Nummer(Value: Integer);
begin
  DefaultInterface.Nummer := Value;
end;

function TUser.Get_Benutzer: WideString;
begin
  Result := DefaultInterface.Benutzer;
end;

procedure TUser.Set_Benutzer(const Value: WideString);
begin
  DefaultInterface.Benutzer := Value;
end;

function TUser.Get_Abteilung: WideString;
begin
  Result := DefaultInterface.Abteilung;
end;

procedure TUser.Set_Abteilung(const Value: WideString);
begin
  DefaultInterface.Abteilung := Value;
end;

function TUser.Get_Info(Nr: Integer): WideString;
begin
  Result := DefaultInterface.Info[Nr];
end;

procedure TUser.Set_Info(Nr: Integer; const Value: WideString);
begin
  DefaultInterface.Info[Nr] := Value;
end;

function TUser.Get_Info1: WideString;
begin
  Result := DefaultInterface.Info1;
end;

procedure TUser.Set_Info1(const Value: WideString);
begin
  DefaultInterface.Info1 := Value;
end;

function TUser.Get_Info2: WideString;
begin
  Result := DefaultInterface.Info2;
end;

procedure TUser.Set_Info2(const Value: WideString);
begin
  DefaultInterface.Info2 := Value;
end;

function TUser.Get_DefaultPort: Integer;
begin
  Result := DefaultInterface.DefaultPort;
end;

procedure TUser.Set_DefaultPort(Value: Integer);
begin
  DefaultInterface.DefaultPort := Value;
end;

function TUser.Get_PruefzeitraumVon: TDateTime;
begin
  Result := DefaultInterface.PruefzeitraumVon;
end;

function TUser.Get_PruefzeitraumBis: TDateTime;
begin
  Result := DefaultInterface.PruefzeitraumBis;
end;

function TUser.Anmeldung(const Server: WideString; const Benutzer: WideString; 
                         const Passwort: WideString): WideString;
begin
  Result := DefaultInterface.Anmeldung(Server, Benutzer, Passwort);
end;

function TUser.Adresse: IAdresse;
begin
  Result := DefaultInterface.Adresse;
end;

function TUser.DefaultBenutzer: WideString;
begin
  Result := DefaultInterface.DefaultBenutzer;
end;

function TUser.DefaultServer: WideString;
begin
  Result := DefaultInterface.DefaultServer;
end;

class function CoMandant.Create: IMandant;
begin
  Result := CreateComObject(CLASS_Mandant) as IMandant;
end;

class function CoMandant.CreateRemote(const MachineName: string): IMandant;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Mandant) as IMandant;
end;

procedure TMandant.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{DB051B59-4B88-4998-BBC2-06CE20C4E3A7}';
    IntfIID:   '{F48EAEC3-8F81-4356-94F5-0D42EF4FFB59}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMandant.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMandant;
  end;
end;

procedure TMandant.ConnectTo(svrIntf: IMandant);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMandant.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMandant.GetDefaultInterface: IMandant;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TMandant.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMandant.Destroy;
begin
  inherited Destroy;
end;

function TMandant.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

procedure TMandant.Set_Nummer(Value: Integer);
begin
  DefaultInterface.Nummer := Value;
end;

function TMandant.Get_Bezeichnung: WideString;
begin
  Result := DefaultInterface.Bezeichnung;
end;

procedure TMandant.Set_Bezeichnung(const Value: WideString);
begin
  DefaultInterface.Bezeichnung := Value;
end;

function TMandant.Get_aktlWiJahr: Integer;
begin
  Result := DefaultInterface.aktlWiJahr;
end;

procedure TMandant.Set_aktlWiJahr(Value: Integer);
begin
  DefaultInterface.aktlWiJahr := Value;
end;

function TMandant.Get_letzteMonatWiJahr: Integer;
begin
  Result := DefaultInterface.letzteMonatWiJahr;
end;

procedure TMandant.Set_letzteMonatWiJahr(Value: Integer);
begin
  DefaultInterface.letzteMonatWiJahr := Value;
end;

function TMandant.Get_RumpfWiJahrAnfang: TDateTime;
begin
  Result := DefaultInterface.RumpfWiJahrAnfang;
end;

procedure TMandant.Set_RumpfWiJahrAnfang(Value: TDateTime);
begin
  DefaultInterface.RumpfWiJahrAnfang := Value;
end;

function TMandant.Get_RumpfWiJahrEnde: TDateTime;
begin
  Result := DefaultInterface.RumpfWiJahrEnde;
end;

procedure TMandant.Set_RumpfWiJahrEnde(Value: TDateTime);
begin
  DefaultInterface.RumpfWiJahrEnde := Value;
end;

function TMandant.Get_AbwMdNrStB: Integer;
begin
  Result := DefaultInterface.AbwMdNrStB;
end;

procedure TMandant.Set_AbwMdNrStB(Value: Integer);
begin
  DefaultInterface.AbwMdNrStB := Value;
end;

function TMandant.Get_Steuernummer: WideString;
begin
  Result := DefaultInterface.Steuernummer;
end;

procedure TMandant.Set_Steuernummer(const Value: WideString);
begin
  DefaultInterface.Steuernummer := Value;
end;

function TMandant.Get_ISOHausWaehrBez: WideString;
begin
  Result := DefaultInterface.ISOHausWaehrBez;
end;

function TMandant.Get_UStVAZeitraum: Integer;
begin
  Result := DefaultInterface.UStVAZeitraum;
end;

function TMandant.Get_INIDatei: WideString;
begin
  Result := DefaultInterface.INIDatei;
end;

procedure TMandant.Set_INIDatei(const Value: WideString);
begin
  DefaultInterface.INIDatei := Value;
end;

function TMandant.Adresse: IAdresse;
begin
  Result := DefaultInterface.Adresse;
end;

function TMandant.Debitor: IDebitor;
begin
  Result := DefaultInterface.Debitor;
end;

function TMandant.Kreditor: IKreditor;
begin
  Result := DefaultInterface.Kreditor;
end;

function TMandant.Sachkonto: ISachkonto;
begin
  Result := DefaultInterface.Sachkonto;
end;

function TMandant.Journal(WiJ: Integer): IJournal;
begin
  Result := DefaultInterface.Journal(WiJ);
end;

function TMandant.KLRJournal(WiJ: Integer): IKLRJournal;
begin
  Result := DefaultInterface.KLRJournal(WiJ);
end;

function TMandant.Festkonto: IFestkonto;
begin
  Result := DefaultInterface.Festkonto;
end;

function TMandant.Buchtext: IBuchtext;
begin
  Result := DefaultInterface.Buchtext;
end;

function TMandant.Steuer: ISteuer;
begin
  Result := DefaultInterface.Steuer;
end;

function TMandant.Finanzamt: IFinanzamt;
begin
  Result := DefaultInterface.Finanzamt;
end;

function TMandant.Kontenbereich: IKontenbereich;
begin
  Result := DefaultInterface.Kontenbereich;
end;

function TMandant.Kostenart: IKostenart;
begin
  Result := DefaultInterface.Kostenart;
end;

function TMandant.Kostenstelle: IKostenstelle;
begin
  Result := DefaultInterface.Kostenstelle;
end;

function TMandant.Kostentraeger: Kostentraeger;
begin
  Result := DefaultInterface.Kostentraeger;
end;

function TMandant.Bezugsgroesse: IBezugsgroesse;
begin
  Result := DefaultInterface.Bezugsgroesse;
end;

function TMandant.FNReport: IFNReport;
begin
  Result := DefaultInterface.FNReport;
end;

function TMandant.Posten(KontoTyp: EKontotypen; AllePosten: WordBool): IPosten;
begin
  Result := DefaultInterface.Posten(KontoTyp, AllePosten);
end;

function TMandant.Kostenstelleart: IKostenstelleart;
begin
  Result := DefaultInterface.Kostenstelleart;
end;

function TMandant.Kostentraegerart: Kostentraegerart;
begin
  Result := DefaultInterface.Kostentraegerart;
end;

function TMandant.Kostenartstelle: Kostenartstelle;
begin
  Result := DefaultInterface.Kostenartstelle;
end;

function TMandant.Kostenarttraeger: Kostenarttraeger;
begin
  Result := DefaultInterface.Kostenarttraeger;
end;

function TMandant.REB(IsGebucht: WordBool): IREB;
begin
  Result := DefaultInterface.REB(IsGebucht);
end;

function TMandant.Archivierung: IArchivierung;
begin
  Result := DefaultInterface.Archivierung;
end;

function TMandant.BgMw(IsPlan: WordBool; IsKTr: WordBool): IBgMw;
begin
  Result := DefaultInterface.BgMw(IsPlan, IsKTr);
end;

function TMandant.XML: IXML;
begin
  Result := DefaultInterface.XML;
end;

function TMandant.DCUebFiles: IDCUebFiles;
begin
  Result := DefaultInterface.DCUebFiles;
end;

function TMandant.BgBeweg(IsPlan: WordBool): IBgBeweg;
begin
  Result := DefaultInterface.BgBeweg(IsPlan);
end;

function TMandant.Inventar: IInventar;
begin
  Result := DefaultInterface.Inventar;
end;

function TMandant.Waehrung: IWaehrung;
begin
  Result := DefaultInterface.Waehrung;
end;

function TMandant.USGAAPPos: IGruppe;
begin
  Result := DefaultInterface.USGAAPPos;
end;

function TMandant.HGBPos: IGruppe;
begin
  Result := DefaultInterface.HGBPos;
end;

function TMandant.Wechsel: IWechsel;
begin
  Result := DefaultInterface.Wechsel;
end;

function TMandant.Tageskurs(WaNr: Integer): ITageskurs;
begin
  Result := DefaultInterface.Tageskurs(WaNr);
end;

function TMandant.GetKontoRechte(KtNr: Integer; KtTyp: EKontotypen): EKontoRechte;
begin
  Result := DefaultInterface.GetKontoRechte(KtNr, KtTyp);
end;

function TMandant.Scheck: IScheck;
begin
  Result := DefaultInterface.Scheck;
end;

function TMandant.InventarJournal(EbeneNr: EInventarebenen): IInventarJournal;
begin
  Result := DefaultInterface.InventarJournal(EbeneNr);
end;

function TMandant.Verteilung(VonMonat: Integer; BisMonat: Integer; vertKLRTyp: Integer; 
                             empfKLRTyp: Integer; VonKArt: Integer; BisKArt: Integer; 
                             BGNummer: Integer; FixVar: Integer): IVerteilung;
begin
  Result := DefaultInterface.Verteilung(VonMonat, BisMonat, vertKLRTyp, empfKLRTyp, VonKArt, 
                                        BisKArt, BGNummer, FixVar);
end;

function TMandant.KontoGruppe: IGruppe;
begin
  Result := DefaultInterface.KontoGruppe;
end;

function TMandant.InventarGruppe: IGruppe;
begin
  Result := DefaultInterface.InventarGruppe;
end;

function TMandant.KLRGruppe: IGruppe;
begin
  Result := DefaultInterface.KLRGruppe;
end;

function TMandant.KLRAutomatik: IKLRAutomatik;
begin
  Result := DefaultInterface.KLRAutomatik;
end;

function TMandant.KLRJrnKStKTr(WiJ: Integer): IKLRJournal;
begin
  Result := DefaultInterface.KLRJrnKStKTr(WiJ);
end;

class function CoAdresse.Create: IAdresse;
begin
  Result := CreateComObject(CLASS_Adresse) as IAdresse;
end;

class function CoAdresse.CreateRemote(const MachineName: string): IAdresse;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Adresse) as IAdresse;
end;

procedure TAdresse.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B0D20D02-AAC5-4973-8E1D-62ED39B8BFF4}';
    IntfIID:   '{D40FC78D-E961-4345-83A0-94576D8C8FA7}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TAdresse.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IAdresse;
  end;
end;

procedure TAdresse.ConnectTo(svrIntf: IAdresse);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TAdresse.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TAdresse.GetDefaultInterface: IAdresse;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TAdresse.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TAdresse.Destroy;
begin
  inherited Destroy;
end;

function TAdresse.Get_Name(Nr: Integer): WideString;
begin
  Result := DefaultInterface.Name[Nr];
end;

procedure TAdresse.Set_Name(Nr: Integer; const Value: WideString);
begin
  DefaultInterface.Name[Nr] := Value;
end;

function TAdresse.Get_Name1: WideString;
begin
  Result := DefaultInterface.Name1;
end;

procedure TAdresse.Set_Name1(const Value: WideString);
begin
  DefaultInterface.Name1 := Value;
end;

function TAdresse.Get_Name2: WideString;
begin
  Result := DefaultInterface.Name2;
end;

procedure TAdresse.Set_Name2(const Value: WideString);
begin
  DefaultInterface.Name2 := Value;
end;

function TAdresse.Get_Name3: WideString;
begin
  Result := DefaultInterface.Name3;
end;

procedure TAdresse.Set_Name3(const Value: WideString);
begin
  DefaultInterface.Name3 := Value;
end;

function TAdresse.Get_Strasse(Nr: Integer): WideString;
begin
  Result := DefaultInterface.Strasse[Nr];
end;

procedure TAdresse.Set_Strasse(Nr: Integer; const Value: WideString);
begin
  DefaultInterface.Strasse[Nr] := Value;
end;

function TAdresse.Get_PLZ: WideString;
begin
  Result := DefaultInterface.PLZ;
end;

procedure TAdresse.Set_PLZ(const Value: WideString);
begin
  DefaultInterface.PLZ := Value;
end;

function TAdresse.Get_Ort: WideString;
begin
  Result := DefaultInterface.Ort;
end;

procedure TAdresse.Set_Ort(const Value: WideString);
begin
  DefaultInterface.Ort := Value;
end;

function TAdresse.Get_Telefon: WideString;
begin
  Result := DefaultInterface.Telefon;
end;

procedure TAdresse.Set_Telefon(const Value: WideString);
begin
  DefaultInterface.Telefon := Value;
end;

function TAdresse.Get_Fax: WideString;
begin
  Result := DefaultInterface.Fax;
end;

procedure TAdresse.Set_Fax(const Value: WideString);
begin
  DefaultInterface.Fax := Value;
end;

function TAdresse.Get_Mail: WideString;
begin
  Result := DefaultInterface.Mail;
end;

procedure TAdresse.Set_Mail(const Value: WideString);
begin
  DefaultInterface.Mail := Value;
end;

function TAdresse.Get_Anrede: WideString;
begin
  Result := DefaultInterface.Anrede;
end;

function TAdresse.Get_PLZ2: WideString;
begin
  Result := DefaultInterface.PLZ2;
end;

procedure TAdresse.Set_PLZ2(const Value: WideString);
begin
  DefaultInterface.PLZ2 := Value;
end;

function TAdresse.Get_Postfach: WideString;
begin
  Result := DefaultInterface.Postfach;
end;

procedure TAdresse.Set_Postfach(const Value: WideString);
begin
  DefaultInterface.Postfach := Value;
end;

function TAdresse.Get_Strasse1: WideString;
begin
  Result := DefaultInterface.Strasse1;
end;

procedure TAdresse.Set_Strasse1(const Value: WideString);
begin
  DefaultInterface.Strasse1 := Value;
end;

function TAdresse.Get_Strasse2: WideString;
begin
  Result := DefaultInterface.Strasse2;
end;

procedure TAdresse.Set_Strasse2(const Value: WideString);
begin
  DefaultInterface.Strasse2 := Value;
end;

function TAdresse.Get_UStIdNr: WideString;
begin
  Result := DefaultInterface.UStIdNr;
end;

function TAdresse.Get_Lkz: WideString;
begin
  Result := DefaultInterface.Lkz;
end;

function TAdresse.Get_Mobiltelefon: WideString;
begin
  Result := DefaultInterface.Mobiltelefon;
end;

function TAdresse.Get_Steuernummer: WideString;
begin
  Result := DefaultInterface.Steuernummer;
end;

procedure TAdresse.Set_Steuernummer(const Value: WideString);
begin
  DefaultInterface.Steuernummer := Value;
end;

function TAdresse.Land: ILand;
begin
  Result := DefaultInterface.Land;
end;

function TAdresse.AsRecord: RAdresse;
begin
  Result := DefaultInterface.AsRecord;
end;

class function CoLand.Create: ILand;
begin
  Result := CreateComObject(CLASS_Land) as ILand;
end;

class function CoLand.CreateRemote(const MachineName: string): ILand;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Land) as ILand;
end;

procedure TLand.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A1743BD4-02A1-4C37-B86F-58915FD8CEDE}';
    IntfIID:   '{F182A2C6-5F5D-43E3-A9E3-4E3B8584EEB9}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TLand.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ILand;
  end;
end;

procedure TLand.ConnectTo(svrIntf: ILand);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TLand.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TLand.GetDefaultInterface: ILand;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TLand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TLand.Destroy;
begin
  inherited Destroy;
end;

function TLand.Get_Lkz: WideString;
begin
  Result := DefaultInterface.Lkz;
end;

procedure TLand.Set_Lkz(const Value: WideString);
begin
  DefaultInterface.Lkz := Value;
end;

function TLand.Get_Bezeichnung(Nr: Integer): WideString;
begin
  Result := DefaultInterface.Bezeichnung[Nr];
end;

procedure TLand.Set_Bezeichnung(Nr: Integer; const Value: WideString);
begin
  DefaultInterface.Bezeichnung[Nr] := Value;
end;

function TLand.Get_Bezeichnung1: WideString;
begin
  Result := DefaultInterface.Bezeichnung1;
end;

procedure TLand.Set_Bezeichnung1(const Value: WideString);
begin
  DefaultInterface.Bezeichnung1 := Value;
end;

function TLand.Get_Bezeichnung2: WideString;
begin
  Result := DefaultInterface.Bezeichnung2;
end;

procedure TLand.Set_Bezeichnung2(const Value: WideString);
begin
  DefaultInterface.Bezeichnung2 := Value;
end;

function TLand.Get_WaehrName: WideString;
begin
  Result := DefaultInterface.WaehrName;
end;

procedure TLand.Set_WaehrName(const Value: WideString);
begin
  DefaultInterface.WaehrName := Value;
end;

function TLand.Get_Hauptstadt: WideString;
begin
  Result := DefaultInterface.Hauptstadt;
end;

procedure TLand.Set_Hauptstadt(const Value: WideString);
begin
  DefaultInterface.Hauptstadt := Value;
end;

function TLand.Get_EUMitgliedSeit: TDateTime;
begin
  Result := DefaultInterface.EUMitgliedSeit;
end;

function TLand.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TLand.IsEG: WordBool;
begin
  Result := DefaultInterface.IsEG;
end;

class function CoDebitor.Create: IDebitor;
begin
  Result := CreateComObject(CLASS_Debitor) as IDebitor;
end;

class function CoDebitor.CreateRemote(const MachineName: string): IDebitor;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Debitor) as IDebitor;
end;

procedure TDebitor.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{12C2334A-049A-485D-9F7F-7F98F45507E1}';
    IntfIID:   '{E3E62CF7-B5FE-4F37-98DD-6CE5AD4C7505}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDebitor.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDebitor;
  end;
end;

procedure TDebitor.ConnectTo(svrIntf: IDebitor);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDebitor.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDebitor.GetDefaultInterface: IDebitor;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TDebitor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TDebitor.Destroy;
begin
  inherited Destroy;
end;

function TDebitor.Get_Kontonummer: Integer;
begin
  Result := DefaultInterface.Kontonummer;
end;

procedure TDebitor.Set_Kontonummer(Value: Integer);
begin
  DefaultInterface.Kontonummer := Value;
end;

function TDebitor.Get_InlEuroDritt: Integer;
begin
  Result := DefaultInterface.InlEuroDritt;
end;

procedure TDebitor.Set_InlEuroDritt(Value: Integer);
begin
  DefaultInterface.InlEuroDritt := Value;
end;

function TDebitor.Get_Zahlart: EZahlarten;
begin
  Result := DefaultInterface.Zahlart;
end;

function TDebitor.Get_Zahlkondition: IZahlkondition;
begin
  Result := DefaultInterface.Zahlkondition;
end;

function TDebitor.Get_Kundennummer: WideString;
begin
  Result := DefaultInterface.Kundennummer;
end;

function TDebitor.Get_Vertreternummer: Integer;
begin
  Result := DefaultInterface.Vertreternummer;
end;

function TDebitor.Get_Konzern: Integer;
begin
  Result := DefaultInterface.Konzern;
end;

function TDebitor.Get_NummerBeimPartner: WideString;
begin
  Result := DefaultInterface.NummerBeimPartner;
end;

function TDebitor.Get_Gebietsnummer: Integer;
begin
  Result := DefaultInterface.Gebietsnummer;
end;

function TDebitor.Get_MahnkulanzBetrag: Currency;
begin
  Result := DefaultInterface.MahnkulanzBetrag;
end;

function TDebitor.Get_MahnkulanzBis: TDateTime;
begin
  Result := DefaultInterface.MahnkulanzBis;
end;

function TDebitor.Get_MahnstopBis: TDateTime;
begin
  Result := DefaultInterface.MahnstopBis;
end;

function TDebitor.Get_Steuernummer: WideString;
begin
  Result := DefaultInterface.Steuernummer;
end;

function TDebitor.Get_HR_Nummer: WideString;
begin
  Result := DefaultInterface.HR_Nummer;
end;

function TDebitor.Get_HR_Ort: WideString;
begin
  Result := DefaultInterface.HR_Ort;
end;

function TDebitor.Get_ZdDatum: TDateTime;
begin
  Result := DefaultInterface.ZdDatum;
end;

function TDebitor.Get_ZdZeitraumVon: TDateTime;
begin
  Result := DefaultInterface.ZdZeitraumVon;
end;

function TDebitor.Get_ZdZeitraumBis: TDateTime;
begin
  Result := DefaultInterface.ZdZeitraumBis;
end;

function TDebitor.Get_Zahldauer: Integer;
begin
  Result := DefaultInterface.Zahldauer;
end;

function TDebitor.Get_ReGesamtAnzahl: Integer;
begin
  Result := DefaultInterface.ReGesamtAnzahl;
end;

function TDebitor.Get_ReGesamtUmsatz: Currency;
begin
  Result := DefaultInterface.ReGesamtUmsatz;
end;

function TDebitor.Get_ReGesamtSkonto: Currency;
begin
  Result := DefaultInterface.ReGesamtSkonto;
end;

function TDebitor.Get_IsZentralregulierer: WordBool;
begin
  Result := DefaultInterface.IsZentralregulierer;
end;

function TDebitor.Get_ZentRegKontonummer: Integer;
begin
  Result := DefaultInterface.ZentRegKontonummer;
end;

function TDebitor.Get_ZentRegReferenzNr: WideString;
begin
  Result := DefaultInterface.ZentRegReferenzNr;
end;

function TDebitor.Get_Vorwahl: WideString;
begin
  Result := DefaultInterface.Vorwahl;
end;

function TDebitor.Get_Rufnummer: WideString;
begin
  Result := DefaultInterface.Rufnummer;
end;

function TDebitor.Get_Ansprechpartner: WideString;
begin
  Result := DefaultInterface.Ansprechpartner;
end;

function TDebitor.Get_Geburtstag: TDateTime;
begin
  Result := DefaultInterface.Geburtstag;
end;

function TDebitor.Get_Rechtsform: Integer;
begin
  Result := DefaultInterface.Rechtsform;
end;

function TDebitor.Get_GegenKonto: Integer;
begin
  Result := DefaultInterface.GegenKonto;
end;

function TDebitor.Get_AbwSammelKt: Integer;
begin
  Result := DefaultInterface.AbwSammelKt;
end;

function TDebitor.Get_AbwSkontoKt: Integer;
begin
  Result := DefaultInterface.AbwSkontoKt;
end;

function TDebitor.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TDebitor.Konto: IKonto;
begin
  Result := DefaultInterface.Konto;
end;

function TDebitor.Adresse: IAdresse;
begin
  Result := DefaultInterface.Adresse;
end;

function TDebitor.Vertreter: IKreditor;
begin
  Result := DefaultInterface.Vertreter;
end;

function TDebitor.Bankverbindung: IBankverbindung;
begin
  Result := DefaultInterface.Bankverbindung;
end;

function TDebitor.Kreditversicherung: IKreditversicherung;
begin
  Result := DefaultInterface.Kreditversicherung;
end;

function TDebitor.Rabatt(Index: Integer): Currency;
begin
  Result := DefaultInterface.Rabatt(Index);
end;

function TDebitor.Kreditkarte: IKreditkarte;
begin
  Result := DefaultInterface.Kreditkarte;
end;

class function CoKonto.Create: IKonto;
begin
  Result := CreateComObject(CLASS_Konto) as IKonto;
end;

class function CoKonto.CreateRemote(const MachineName: string): IKonto;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Konto) as IKonto;
end;

procedure TKonto.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{93C53CC2-35EB-4BFA-8361-6BDAF6A3C25A}';
    IntfIID:   '{728D1D5B-1799-4139-9CC5-BDE06BDD2DFD}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKonto.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKonto;
  end;
end;

procedure TKonto.ConnectTo(svrIntf: IKonto);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKonto.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKonto.GetDefaultInterface: IKonto;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKonto.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKonto.Destroy;
begin
  inherited Destroy;
end;

function TKonto.Get_Bezeichnung(Nr: Integer): WideString;
begin
  Result := DefaultInterface.Bezeichnung[Nr];
end;

procedure TKonto.Set_Bezeichnung(Nr: Integer; const Value: WideString);
begin
  DefaultInterface.Bezeichnung[Nr] := Value;
end;

function TKonto.Get_Bezeichnung1: WideString;
begin
  Result := DefaultInterface.Bezeichnung1;
end;

procedure TKonto.Set_Bezeichnung1(const Value: WideString);
begin
  DefaultInterface.Bezeichnung1 := Value;
end;

function TKonto.Get_Bezeichnung2: WideString;
begin
  Result := DefaultInterface.Bezeichnung2;
end;

procedure TKonto.Set_Bezeichnung2(const Value: WideString);
begin
  DefaultInterface.Bezeichnung2 := Value;
end;

function TKonto.Get_Aenderungsdatum: TDateTime;
begin
  Result := DefaultInterface.Aenderungsdatum;
end;

function TKonto.Get_Anlagedatum: TDateTime;
begin
  Result := DefaultInterface.Anlagedatum;
end;

function TKonto.Get_GueltigBis: TDateTime;
begin
  Result := DefaultInterface.GueltigBis;
end;

function TKonto.Get_Waehrungsnummer: Integer;
begin
  Result := DefaultInterface.Waehrungsnummer;
end;

function TKonto.Get_OPVerwaltungsart: Integer;
begin
  Result := DefaultInterface.OPVerwaltungsart;
end;

function TKonto.Get_AlteKontonummer: Integer;
begin
  Result := DefaultInterface.AlteKontonummer;
end;

function TKonto.Get_GueltigAb: TDateTime;
begin
  Result := DefaultInterface.GueltigAb;
end;

function TKonto.Get_Sperre: Integer;
begin
  Result := DefaultInterface.Sperre;
end;

function TKonto.Get_AccessDenied: WordBool;
begin
  Result := DefaultInterface.AccessDenied;
end;

function TKonto.Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

function TKonto.IsBebucht: WordBool;
begin
  Result := DefaultInterface.IsBebucht;
end;

function TKonto.IsOP: WordBool;
begin
  Result := DefaultInterface.IsOP;
end;

function TKonto.MitOpVerwaltung: WordBool;
begin
  Result := DefaultInterface.MitOpVerwaltung;
end;

function TKonto.Journal: IJournal;
begin
  Result := DefaultInterface.Journal;
end;

function TKonto.Posten(AllePosten: WordBool): IPosten;
begin
  Result := DefaultInterface.Posten(AllePosten);
end;

function TKonto.Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo;
begin
  Result := DefaultInterface.Saldo(WaNr, IsInHW);
end;

function TKonto.GrpNummer(Nr: Integer): Integer;
begin
  Result := DefaultInterface.GrpNummer(Nr);
end;

class function CoSaldo.Create: ISaldo;
begin
  Result := CreateComObject(CLASS_Saldo) as ISaldo;
end;

class function CoSaldo.CreateRemote(const MachineName: string): ISaldo;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Saldo) as ISaldo;
end;

procedure TSaldo.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0C8EEC64-F0A2-4042-A823-7EC285BA803D}';
    IntfIID:   '{5954A0E5-1E20-4DFD-8769-56F403985F0E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSaldo.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISaldo;
  end;
end;

procedure TSaldo.ConnectTo(svrIntf: ISaldo);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSaldo.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSaldo.GetDefaultInterface: ISaldo;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TSaldo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TSaldo.Destroy;
begin
  inherited Destroy;
end;

function TSaldo.Get_MVZ(SollHaben: Integer; Monat: Integer): Currency;
begin
  Result := DefaultInterface.MVZ[SollHaben, Monat];
end;

function TSaldo.Get_EB: Currency;
begin
  Result := DefaultInterface.EB;
end;

function TSaldo.Get_MVZS(Monat: Integer): Currency;
begin
  Result := DefaultInterface.MVZS[Monat];
end;

function TSaldo.Get_MVZH(Monat: Integer): Currency;
begin
  Result := DefaultInterface.MVZH[Monat];
end;

function TSaldo.Get_JVZS: Currency;
begin
  Result := DefaultInterface.JVZS;
end;

function TSaldo.Get_JVZH: Currency;
begin
  Result := DefaultInterface.JVZH;
end;

function TSaldo.Get_Saldo: Currency;
begin
  Result := DefaultInterface.Saldo;
end;

function TSaldo.Get_Monatswert(Zeile: Integer; Monat: Integer): Currency;
begin
  Result := DefaultInterface.Monatswert[Zeile, Monat];
end;

function TSaldo.Get_IstPlan: Integer;
begin
  Result := DefaultInterface.IstPlan;
end;

procedure TSaldo.Set_IstPlan(Value: Integer);
begin
  DefaultInterface.IstPlan := Value;
end;

function TSaldo.Get_Fixekosten(Monat: Integer): Currency;
begin
  Result := DefaultInterface.Fixekosten[Monat];
end;

function TSaldo.Get_Variablekosten(Monat: Integer): Currency;
begin
  Result := DefaultInterface.Variablekosten[Monat];
end;

function TSaldo.Get_Leistung(Monat: Integer): Currency;
begin
  Result := DefaultInterface.Leistung[Monat];
end;

function TSaldo.Get_ISOWaehrBez: WideString;
begin
  Result := DefaultInterface.ISOWaehrBez;
end;

function TSaldo.Get_Tagesdatum: TDateTime;
begin
  Result := DefaultInterface.Tagesdatum;
end;

procedure TSaldo.Set_Tagesdatum(Value: TDateTime);
begin
  DefaultInterface.Tagesdatum := Value;
end;

function TSaldo.Get_IsBuchungsstapel: WordBool;
begin
  Result := DefaultInterface.IsBuchungsstapel;
end;

procedure TSaldo.Set_IsBuchungsstapel(Value: WordBool);
begin
  DefaultInterface.IsBuchungsstapel := Value;
end;

function TSaldo.Get_Wirtschaftsjahr: Integer;
begin
  Result := DefaultInterface.Wirtschaftsjahr;
end;

procedure TSaldo.Set_Wirtschaftsjahr(Value: Integer);
begin
  DefaultInterface.Wirtschaftsjahr := Value;
end;

function TSaldo.Get_DatumTyp: Integer;
begin
  Result := DefaultInterface.DatumTyp;
end;

procedure TSaldo.Set_DatumTyp(Value: Integer);
begin
  DefaultInterface.DatumTyp := Value;
end;

function TSaldo.Get_IsWiMonat: WordBool;
begin
  Result := DefaultInterface.IsWiMonat;
end;

procedure TSaldo.Set_IsWiMonat(Value: WordBool);
begin
  DefaultInterface.IsWiMonat := Value;
end;

function TSaldo.Get_IsMVZKumuliert: WordBool;
begin
  Result := DefaultInterface.IsMVZKumuliert;
end;

procedure TSaldo.Set_IsMVZKumuliert(Value: WordBool);
begin
  DefaultInterface.IsMVZKumuliert := Value;
end;

function TSaldo.Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

function TSaldo.AccessDenied: WordBool;
begin
  Result := DefaultInterface.AccessDenied;
end;

function TSaldo.Kostenart: Integer;
begin
  Result := DefaultInterface.Kostenart;
end;

class function CoPosten.Create: IPosten;
begin
  Result := CreateComObject(CLASS_Posten) as IPosten;
end;

class function CoPosten.CreateRemote(const MachineName: string): IPosten;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Posten) as IPosten;
end;

procedure TPosten.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{DFDE917C-1425-4438-ABAC-30E391EBD654}';
    IntfIID:   '{D9C25C8A-E7A4-48AA-A638-CCEA852FB5B5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TPosten.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IPosten;
  end;
end;

procedure TPosten.ConnectTo(svrIntf: IPosten);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TPosten.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TPosten.GetDefaultInterface: IPosten;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TPosten.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TPosten.Destroy;
begin
  inherited Destroy;
end;

function TPosten.Get_Postenart: Integer;
begin
  Result := DefaultInterface.Postenart;
end;

procedure TPosten.Set_Postenart(Value: Integer);
begin
  DefaultInterface.Postenart := Value;
end;

function TPosten.Get_PostenArtBez: WideString;
begin
  Result := DefaultInterface.PostenArtBez;
end;

function TPosten.Get_Valutadatum: TDateTime;
begin
  Result := DefaultInterface.Valutadatum;
end;

procedure TPosten.Set_Valutadatum(Value: TDateTime);
begin
  DefaultInterface.Valutadatum := Value;
end;

function TPosten.Get_Zahlart: EZahlarten;
begin
  Result := DefaultInterface.Zahlart;
end;

procedure TPosten.Set_Zahlart(Value: EZahlarten);
begin
  DefaultInterface.Zahlart := Value;
end;

function TPosten.Get_Skontofaktor: Double;
begin
  Result := DefaultInterface.Skontofaktor;
end;

procedure TPosten.Set_Skontofaktor(Value: Double);
begin
  DefaultInterface.Skontofaktor := Value;
end;

function TPosten.Get_Skontogezogen: Currency;
begin
  Result := DefaultInterface.Skontogezogen;
end;

procedure TPosten.Set_Skontogezogen(Value: Currency);
begin
  DefaultInterface.Skontogezogen := Value;
end;

function TPosten.Get_IsBezahlt: WordBool;
begin
  Result := DefaultInterface.IsBezahlt;
end;

procedure TPosten.Set_IsBezahlt(Value: WordBool);
begin
  DefaultInterface.IsBezahlt := Value;
end;

function TPosten.Get_BezahltDatum: TDateTime;
begin
  Result := DefaultInterface.BezahltDatum;
end;

procedure TPosten.Set_BezahltDatum(Value: TDateTime);
begin
  DefaultInterface.BezahltDatum := Value;
end;

function TPosten.Get_IsPostenausgleich: WordBool;
begin
  Result := DefaultInterface.IsPostenausgleich;
end;

function TPosten.Get_IsAnzahlung: WordBool;
begin
  Result := DefaultInterface.IsAnzahlung;
end;

procedure TPosten.Set_IsAnzahlung(Value: WordBool);
begin
  DefaultInterface.IsAnzahlung := Value;
end;

function TPosten.Get_Postennummer: Integer;
begin
  Result := DefaultInterface.Postennummer;
end;

function TPosten.Get_BuchJournalZeile: Integer;
begin
  Result := DefaultInterface.BuchJournalZeile;
end;

function TPosten.Get_KLRJournalZeile: Integer;
begin
  Result := DefaultInterface.KLRJournalZeile;
end;

function TPosten.Get_WiJ: Integer;
begin
  Result := DefaultInterface.WiJ;
end;

function TPosten.Get_ZugeordnetPostenJournalZeile: Integer;
begin
  Result := DefaultInterface.ZugeordnetPostenJournalZeile;
end;

function TPosten.Get_Kursdifferenz: Currency;
begin
  Result := DefaultInterface.Kursdifferenz;
end;

function TPosten.Get_IsPicture: WordBool;
begin
  Result := DefaultInterface.IsPicture;
end;

function TPosten.Get_ZinsDatum: TDateTime;
begin
  Result := DefaultInterface.ZinsDatum;
end;

function TPosten.Get_KlrWiJ: Integer;
begin
  Result := DefaultInterface.KlrWiJ;
end;

function TPosten.Get_OpJrnZlVorjahr: Integer;
begin
  Result := DefaultInterface.OpJrnZlVorjahr;
end;

function TPosten.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TPosten.Kontierung: IKontierung;
begin
  Result := DefaultInterface.Kontierung;
end;

function TPosten.Buchung: IJournal;
begin
  Result := DefaultInterface.Buchung;
end;

function TPosten.USt: IUSt;
begin
  Result := DefaultInterface.USt;
end;

function TPosten.Kurs: IKurs;
begin
  Result := DefaultInterface.Kurs;
end;

function TPosten.Mahn: IMahn;
begin
  Result := DefaultInterface.Mahn;
end;

function TPosten.Zahlkondition: IZahlkondition;
begin
  Result := DefaultInterface.Zahlkondition;
end;

function TPosten.ZugeordnetPosten: IPosten;
begin
  Result := DefaultInterface.ZugeordnetPosten;
end;

class function CoNavigate.Create: INavigate;
begin
  Result := CreateComObject(CLASS_Navigate) as INavigate;
end;

class function CoNavigate.CreateRemote(const MachineName: string): INavigate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Navigate) as INavigate;
end;

procedure TNavigate.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{79DE98BA-C039-4B74-873F-6F7597AB79F6}';
    IntfIID:   '{45ADFB97-6F13-47B6-BF10-F488AEA08CEB}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TNavigate.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as INavigate;
  end;
end;

procedure TNavigate.ConnectTo(svrIntf: INavigate);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TNavigate.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TNavigate.GetDefaultInterface: INavigate;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TNavigate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TNavigate.Destroy;
begin
  inherited Destroy;
end;

function TNavigate.Get_Current: Integer;
begin
  Result := DefaultInterface.Current;
end;

procedure TNavigate.Set_Current(Value: Integer);
begin
  DefaultInterface.Current := Value;
end;

function TNavigate.Get_Memotext: WideString;
begin
  Result := DefaultInterface.Memotext;
end;

function TNavigate.Get_IsMemotext: WordBool;
begin
  Result := DefaultInterface.IsMemotext;
end;

function TNavigate.Get_CacheSizeMB: Integer;
begin
  Result := DefaultInterface.CacheSizeMB;
end;

procedure TNavigate.Set_CacheSizeMB(Value: Integer);
begin
  DefaultInterface.CacheSizeMB := Value;
end;

function TNavigate.Count: Integer;
begin
  Result := DefaultInterface.Count;
end;

function TNavigate.First: WordBool;
begin
  Result := DefaultInterface.First;
end;

function TNavigate.Last: WordBool;
begin
  Result := DefaultInterface.Last;
end;

function TNavigate.Next: WordBool;
begin
  Result := DefaultInterface.Next;
end;

function TNavigate.Previous: WordBool;
begin
  Result := DefaultInterface.Previous;
end;

function TNavigate.EOF: WordBool;
begin
  Result := DefaultInterface.EOF;
end;

function TNavigate.BOF: WordBool;
begin
  Result := DefaultInterface.BOF;
end;

class function CoKontierung.Create: IKontierung;
begin
  Result := CreateComObject(CLASS_Kontierung) as IKontierung;
end;

class function CoKontierung.CreateRemote(const MachineName: string): IKontierung;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Kontierung) as IKontierung;
end;

procedure TKontierung.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{7C523A84-53E5-43E0-A0CF-139F8BF857F6}';
    IntfIID:   '{8B8A6BB9-8950-4755-B35C-6BC7F281D6A2}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKontierung.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKontierung;
  end;
end;

procedure TKontierung.ConnectTo(svrIntf: IKontierung);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKontierung.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKontierung.GetDefaultInterface: IKontierung;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKontierung.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKontierung.Destroy;
begin
  inherited Destroy;
end;

function TKontierung.Get_Journalzeile: Integer;
begin
  Result := DefaultInterface.Journalzeile;
end;

function TKontierung.Get_Betrag: Currency;
begin
  Result := DefaultInterface.Betrag;
end;

procedure TKontierung.Set_Betrag(Value: Currency);
begin
  DefaultInterface.Betrag := Value;
end;

function TKontierung.Get_Tagesdatum: TDateTime;
begin
  Result := DefaultInterface.Tagesdatum;
end;

procedure TKontierung.Set_Tagesdatum(Value: TDateTime);
begin
  DefaultInterface.Tagesdatum := Value;
end;

function TKontierung.Get_Belegdatum: TDateTime;
begin
  Result := DefaultInterface.Belegdatum;
end;

procedure TKontierung.Set_Belegdatum(Value: TDateTime);
begin
  DefaultInterface.Belegdatum := Value;
end;

function TKontierung.Get_Buchdatum: TDateTime;
begin
  Result := DefaultInterface.Buchdatum;
end;

procedure TKontierung.Set_Buchdatum(Value: TDateTime);
begin
  DefaultInterface.Buchdatum := Value;
end;

function TKontierung.Get_Belegnummer(Nr: Integer): WideString;
begin
  Result := DefaultInterface.Belegnummer[Nr];
end;

procedure TKontierung.Set_Belegnummer(Nr: Integer; const Value: WideString);
begin
  DefaultInterface.Belegnummer[Nr] := Value;
end;

function TKontierung.Get_Belegnummer1: WideString;
begin
  Result := DefaultInterface.Belegnummer1;
end;

procedure TKontierung.Set_Belegnummer1(const Value: WideString);
begin
  DefaultInterface.Belegnummer1 := Value;
end;

function TKontierung.Get_Belegnummer2: WideString;
begin
  Result := DefaultInterface.Belegnummer2;
end;

procedure TKontierung.Set_Belegnummer2(const Value: WideString);
begin
  DefaultInterface.Belegnummer2 := Value;
end;

function TKontierung.Get_Buchtext: WideString;
begin
  Result := DefaultInterface.Buchtext;
end;

procedure TKontierung.Set_Buchtext(const Value: WideString);
begin
  DefaultInterface.Buchtext := Value;
end;

function TKontierung.Get_Kontonummer: Integer;
begin
  Result := DefaultInterface.Kontonummer;
end;

procedure TKontierung.Set_Kontonummer(Value: Integer);
begin
  DefaultInterface.Kontonummer := Value;
end;

function TKontierung.Get_GegenKonto: Integer;
begin
  Result := DefaultInterface.GegenKonto;
end;

procedure TKontierung.Set_GegenKonto(Value: Integer);
begin
  DefaultInterface.GegenKonto := Value;
end;

function TKontierung.Get_Benutzer: WideString;
begin
  Result := DefaultInterface.Benutzer;
end;

procedure TKontierung.Set_Benutzer(const Value: WideString);
begin
  DefaultInterface.Benutzer := Value;
end;

function TKontierung.Get_IsValid: WordBool;
begin
  Result := DefaultInterface.IsValid;
end;

function TKontierung.Get_TaNr: Integer;
begin
  Result := DefaultInterface.TaNr;
end;

function TKontierung.AsRecord: RKontierung;
begin
  Result := DefaultInterface.AsRecord;
end;

class function CoJournal.Create: IJournal;
begin
  Result := CreateComObject(CLASS_Journal) as IJournal;
end;

class function CoJournal.CreateRemote(const MachineName: string): IJournal;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Journal) as IJournal;
end;

procedure TJournal.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{3930151F-3BE1-4126-AEB3-49936AEF3042}';
    IntfIID:   '{2AD3D557-8A90-40D1-A136-064BE6D44454}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TJournal.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IJournal;
  end;
end;

procedure TJournal.ConnectTo(svrIntf: IJournal);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TJournal.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TJournal.GetDefaultInterface: IJournal;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TJournal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TJournal.Destroy;
begin
  inherited Destroy;
end;

function TJournal.Get_SollHaben: Integer;
begin
  Result := DefaultInterface.SollHaben;
end;

function TJournal.Get_IsLetzteBuchung: WordBool;
begin
  Result := DefaultInterface.IsLetzteBuchung;
end;

function TJournal.Get_Konzern: Integer;
begin
  Result := DefaultInterface.Konzern;
end;

function TJournal.Get_UStIdNr: WideString;
begin
  Result := DefaultInterface.UStIdNr;
end;

function TJournal.Get_Wertstellungsdatum: TDateTime;
begin
  Result := DefaultInterface.Wertstellungsdatum;
end;

function TJournal.Get_Reisedatum: TDateTime;
begin
  Result := DefaultInterface.Reisedatum;
end;

function TJournal.Get_Steuersatz: Currency;
begin
  Result := DefaultInterface.Steuersatz;
end;

function TJournal.Get_KLRJournalZeile: Integer;
begin
  Result := DefaultInterface.KLRJournalZeile;
end;

function TJournal.Get_PostenJournalzeile: Integer;
begin
  Result := DefaultInterface.PostenJournalzeile;
end;

function TJournal.Get_IsPicture: WordBool;
begin
  Result := DefaultInterface.IsPicture;
end;

function TJournal.Get_IsBarcode: WordBool;
begin
  Result := DefaultInterface.IsBarcode;
end;

function TJournal.Get_PictureCount: Integer;
begin
  Result := DefaultInterface.PictureCount;
end;

function TJournal.Get_Inventarnummer: WideString;
begin
  Result := DefaultInterface.Inventarnummer;
end;

function TJournal.Get_AutomatikKennz: WideString;
begin
  Result := DefaultInterface.AutomatikKennz;
end;

function TJournal.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TJournal.Kontierung: IKontierung;
begin
  Result := DefaultInterface.Kontierung;
end;

function TJournal.USt: IUSt;
begin
  Result := DefaultInterface.USt;
end;

function TJournal.Kurs: IKurs;
begin
  Result := DefaultInterface.Kurs;
end;

function TJournal.AsTIF(Index: Integer): OleVariant;
begin
  Result := DefaultInterface.AsTIF(Index);
end;

function TJournal.AsBMP(Index: Integer): OleVariant;
begin
  Result := DefaultInterface.AsBMP(Index);
end;

function TJournal.AsJPG(Index: Integer): OleVariant;
begin
  Result := DefaultInterface.AsJPG(Index);
end;

procedure TJournal.TestTifPicture(const PictureName: WideString);
begin
  DefaultInterface.TestTifPicture(PictureName);
end;

class function CoKLRJournal.Create: IKLRJournal;
begin
  Result := CreateComObject(CLASS_KLRJournal) as IKLRJournal;
end;

class function CoKLRJournal.CreateRemote(const MachineName: string): IKLRJournal;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_KLRJournal) as IKLRJournal;
end;

procedure TKLRJournal.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6C644117-EA21-42E1-937F-64A42AC89995}';
    IntfIID:   '{DB0BA66D-E770-4A28-9985-4F62B8837510}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKLRJournal.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKLRJournal;
  end;
end;

procedure TKLRJournal.ConnectTo(svrIntf: IKLRJournal);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKLRJournal.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKLRJournal.GetDefaultInterface: IKLRJournal;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKLRJournal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKLRJournal.Destroy;
begin
  inherited Destroy;
end;

function TKLRJournal.Get_FixVar: EKostentypen;
begin
  Result := DefaultInterface.FixVar;
end;

procedure TKLRJournal.Set_FixVar(Value: EKostentypen);
begin
  DefaultInterface.FixVar := Value;
end;

function TKLRJournal.Get_KoStTrNr: Integer;
begin
  Result := DefaultInterface.KoStTrNr;
end;

function TKLRJournal.Get_BuchJournalZeile: Integer;
begin
  Result := DefaultInterface.BuchJournalZeile;
end;

function TKLRJournal.Get_KArtNr: Integer;
begin
  Result := DefaultInterface.KArtNr;
end;

function TKLRJournal.Get_SollHaben: Integer;
begin
  Result := DefaultInterface.SollHaben;
end;

function TKLRJournal.Get_IsLetzteBuchung: WordBool;
begin
  Result := DefaultInterface.IsLetzteBuchung;
end;

function TKLRJournal.Get_Ebene: Integer;
begin
  Result := DefaultInterface.Ebene;
end;

function TKLRJournal.Get_GegenkontoTyp: EKontotypen;
begin
  Result := DefaultInterface.GegenkontoTyp;
end;

function TKLRJournal.Get_Herkunft: Integer;
begin
  Result := DefaultInterface.Herkunft;
end;

function TKLRJournal.Get_KTrNr: Integer;
begin
  Result := DefaultInterface.KTrNr;
end;

function TKLRJournal.Get_PostenRef: Integer;
begin
  Result := DefaultInterface.PostenRef;
end;

function TKLRJournal.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TKLRJournal.Kontierung: IKontierung;
begin
  Result := DefaultInterface.Kontierung;
end;

function TKLRJournal.IsKostenstelle: WordBool;
begin
  Result := DefaultInterface.IsKostenstelle;
end;

function TKLRJournal.Kostenstelle: IKostenstelle;
begin
  Result := DefaultInterface.Kostenstelle;
end;

function TKLRJournal.IsKostentraeger: WordBool;
begin
  Result := DefaultInterface.IsKostentraeger;
end;

function TKLRJournal.Kostentraeger: IKostenstelle;
begin
  Result := DefaultInterface.Kostentraeger;
end;

function TKLRJournal.Journal: IJournal;
begin
  Result := DefaultInterface.Journal;
end;

function TKLRJournal.Kostenart: IKostenart;
begin
  Result := DefaultInterface.Kostenart;
end;

class function CoFestkonto.Create: IFestkonto;
begin
  Result := CreateComObject(CLASS_Festkonto) as IFestkonto;
end;

class function CoFestkonto.CreateRemote(const MachineName: string): IFestkonto;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Festkonto) as IFestkonto;
end;

procedure TFestkonto.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B905E867-5C8E-43B7-B1BC-98CA47D00E82}';
    IntfIID:   '{EBF5D737-E60A-43BD-8DF7-E2BFE361B01D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFestkonto.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFestkonto;
  end;
end;

procedure TFestkonto.ConnectTo(svrIntf: IFestkonto);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFestkonto.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFestkonto.GetDefaultInterface: IFestkonto;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TFestkonto.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFestkonto.Destroy;
begin
  inherited Destroy;
end;

function TFestkonto.Get_Kontonummer(Nummer: Integer): Integer;
begin
  Result := DefaultInterface.Kontonummer[Nummer];
end;

procedure TFestkonto.Set_Kontonummer(Nummer: Integer; Value: Integer);
begin
  DefaultInterface.Kontonummer[Nummer] := Value;
end;

function TFestkonto.Get_Bezeichnung(Nr: Integer): WideString;
begin
  Result := DefaultInterface.Bezeichnung[Nr];
end;

function TFestkonto.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

procedure TFestkonto.Set_Nummer(Value: Integer);
begin
  DefaultInterface.Nummer := Value;
end;

function TFestkonto.Sachkonto: ISachkonto;
begin
  Result := DefaultInterface.Sachkonto;
end;

class function CoKreditor.Create: IKreditor;
begin
  Result := CreateComObject(CLASS_Kreditor) as IKreditor;
end;

class function CoKreditor.CreateRemote(const MachineName: string): IKreditor;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Kreditor) as IKreditor;
end;

procedure TKreditor.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{AE7FB50A-F5CD-414C-A45A-CBF89AE53FEC}';
    IntfIID:   '{883889E8-44FD-402B-9ED9-16011E68D8EF}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKreditor.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKreditor;
  end;
end;

procedure TKreditor.ConnectTo(svrIntf: IKreditor);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKreditor.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKreditor.GetDefaultInterface: IKreditor;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKreditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKreditor.Destroy;
begin
  inherited Destroy;
end;

function TKreditor.Get_Kontonummer: Integer;
begin
  Result := DefaultInterface.Kontonummer;
end;

procedure TKreditor.Set_Kontonummer(Value: Integer);
begin
  DefaultInterface.Kontonummer := Value;
end;

function TKreditor.Get_InlEuroDritt: Integer;
begin
  Result := DefaultInterface.InlEuroDritt;
end;

procedure TKreditor.Set_InlEuroDritt(Value: Integer);
begin
  DefaultInterface.InlEuroDritt := Value;
end;

function TKreditor.Get_Zahlart: EZahlarten;
begin
  Result := DefaultInterface.Zahlart;
end;

function TKreditor.Get_Zahlkondition: IZahlkondition;
begin
  Result := DefaultInterface.Zahlkondition;
end;

function TKreditor.Get_Kundennummer: WideString;
begin
  Result := DefaultInterface.Kundennummer;
end;

function TKreditor.Get_Konzern: Integer;
begin
  Result := DefaultInterface.Konzern;
end;

function TKreditor.Get_NummerBeimPartner: WideString;
begin
  Result := DefaultInterface.NummerBeimPartner;
end;

function TKreditor.Get_Gebietsnummer: Integer;
begin
  Result := DefaultInterface.Gebietsnummer;
end;

function TKreditor.Get_Steuernummer: WideString;
begin
  Result := DefaultInterface.Steuernummer;
end;

function TKreditor.Get_HR_Nummer: WideString;
begin
  Result := DefaultInterface.HR_Nummer;
end;

function TKreditor.Get_HR_Ort: WideString;
begin
  Result := DefaultInterface.HR_Ort;
end;

function TKreditor.Get_ZdDatum: TDateTime;
begin
  Result := DefaultInterface.ZdDatum;
end;

function TKreditor.Get_ZdZeitraumVon: TDateTime;
begin
  Result := DefaultInterface.ZdZeitraumVon;
end;

function TKreditor.Get_ZdZeitraumBis: TDateTime;
begin
  Result := DefaultInterface.ZdZeitraumBis;
end;

function TKreditor.Get_Zahldauer: Integer;
begin
  Result := DefaultInterface.Zahldauer;
end;

function TKreditor.Get_ReGesamtAnzahl: Integer;
begin
  Result := DefaultInterface.ReGesamtAnzahl;
end;

function TKreditor.Get_ReGesamtUmsatz: Currency;
begin
  Result := DefaultInterface.ReGesamtUmsatz;
end;

function TKreditor.Get_ReGesamtSkonto: Currency;
begin
  Result := DefaultInterface.ReGesamtSkonto;
end;

function TKreditor.Get_IsBauAbzugssteuer: WordBool;
begin
  Result := DefaultInterface.IsBauAbzugssteuer;
end;

function TKreditor.Get_BauFreistellungVon: TDateTime;
begin
  Result := DefaultInterface.BauFreistellungVon;
end;

function TKreditor.Get_BauFreistellungBis: TDateTime;
begin
  Result := DefaultInterface.BauFreistellungBis;
end;

function TKreditor.Get_IsZentralregulierer: WordBool;
begin
  Result := DefaultInterface.IsZentralregulierer;
end;

function TKreditor.Get_ZentRegKontonummer: Integer;
begin
  Result := DefaultInterface.ZentRegKontonummer;
end;

function TKreditor.Get_ZentRegReferenzNr: WideString;
begin
  Result := DefaultInterface.ZentRegReferenzNr;
end;

function TKreditor.Get_Vorwahl: WideString;
begin
  Result := DefaultInterface.Vorwahl;
end;

function TKreditor.Get_Rufnummer: WideString;
begin
  Result := DefaultInterface.Rufnummer;
end;

function TKreditor.Get_Ansprechpartner: WideString;
begin
  Result := DefaultInterface.Ansprechpartner;
end;

function TKreditor.Get_Geburtstag: TDateTime;
begin
  Result := DefaultInterface.Geburtstag;
end;

function TKreditor.Get_Rechtsform: Integer;
begin
  Result := DefaultInterface.Rechtsform;
end;

function TKreditor.Get_GegenKonto: Integer;
begin
  Result := DefaultInterface.GegenKonto;
end;

function TKreditor.Get_AbwSammelKt: Integer;
begin
  Result := DefaultInterface.AbwSammelKt;
end;

function TKreditor.Get_AbwSkontoKt: Integer;
begin
  Result := DefaultInterface.AbwSkontoKt;
end;

function TKreditor.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TKreditor.Konto: IKonto;
begin
  Result := DefaultInterface.Konto;
end;

function TKreditor.Adresse: IAdresse;
begin
  Result := DefaultInterface.Adresse;
end;

function TKreditor.Bankverbindung: IBankverbindung;
begin
  Result := DefaultInterface.Bankverbindung;
end;

function TKreditor.Rabatt(Index: Integer): Currency;
begin
  Result := DefaultInterface.Rabatt(Index);
end;

class function CoSachkonto.Create: ISachkonto;
begin
  Result := CreateComObject(CLASS_Sachkonto) as ISachkonto;
end;

class function CoSachkonto.CreateRemote(const MachineName: string): ISachkonto;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Sachkonto) as ISachkonto;
end;

procedure TSachkonto.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{39C40436-6C94-4283-B16E-E0B8DA30FA8F}';
    IntfIID:   '{B9C004D3-06FA-44FB-B65A-A164FE943443}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSachkonto.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISachkonto;
  end;
end;

procedure TSachkonto.ConnectTo(svrIntf: ISachkonto);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSachkonto.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSachkonto.GetDefaultInterface: ISachkonto;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TSachkonto.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TSachkonto.Destroy;
begin
  inherited Destroy;
end;

function TSachkonto.Get_Kontonummer: Integer;
begin
  Result := DefaultInterface.Kontonummer;
end;

procedure TSachkonto.Set_Kontonummer(Value: Integer);
begin
  DefaultInterface.Kontonummer := Value;
end;

function TSachkonto.Get_HGBGruppennummer: Integer;
begin
  Result := DefaultInterface.HGBGruppennummer;
end;

function TSachkonto.Get_USGAAPGruppennummer: Integer;
begin
  Result := DefaultInterface.USGAAPGruppennummer;
end;

function TSachkonto.Get_USGAAPKonto: WideString;
begin
  Result := DefaultInterface.USGAAPKonto;
end;

function TSachkonto.Get_Kontoart: EKontoarten;
begin
  Result := DefaultInterface.Kontoart;
end;

function TSachkonto.Get_UStVA: Integer;
begin
  Result := DefaultInterface.UStVA;
end;

procedure TSachkonto.Set_UStVA(Value: Integer);
begin
  DefaultInterface.UStVA := Value;
end;

function TSachkonto.Get_HGBZuordnung: EBilGuVZuordnung;
begin
  Result := DefaultInterface.HGBZuordnung;
end;

function TSachkonto.Get_SammelKtArt: ESammelKtArt;
begin
  Result := DefaultInterface.SammelKtArt;
end;

function TSachkonto.Get_Umsatzschluessel: WideString;
begin
  Result := DefaultInterface.Umsatzschluessel;
end;

function TSachkonto.Get_USGAAPZuordnung: EBilGuVZuordnung;
begin
  Result := DefaultInterface.USGAAPZuordnung;
end;

function TSachkonto.Get_Sperre: EKontensperren;
begin
  Result := DefaultInterface.Sperre;
end;

function TSachkonto.Get_KArtNr: Integer;
begin
  Result := DefaultInterface.KArtNr;
end;

function TSachkonto.Get_IsKostenstellenErfassung: WordBool;
begin
  Result := DefaultInterface.IsKostenstellenErfassung;
end;

function TSachkonto.Get_IsKostentraegerErfassung: WordBool;
begin
  Result := DefaultInterface.IsKostentraegerErfassung;
end;

function TSachkonto.Get_UStIdNr: WideString;
begin
  Result := DefaultInterface.UStIdNr;
end;

function TSachkonto.Get_Kreditlimit: Currency;
begin
  Result := DefaultInterface.Kreditlimit;
end;

function TSachkonto.Get_Obligolimit: Currency;
begin
  Result := DefaultInterface.Obligolimit;
end;

function TSachkonto.Get_IntraWaNr: Integer;
begin
  Result := DefaultInterface.IntraWaNr;
end;

function TSachkonto.Get_Kostenstelle: Integer;
begin
  Result := DefaultInterface.Kostenstelle;
end;

function TSachkonto.Get_Kostentraeger: Integer;
begin
  Result := DefaultInterface.Kostentraeger;
end;

function TSachkonto.Get_Steuerkonto1: Integer;
begin
  Result := DefaultInterface.Steuerkonto1;
end;

function TSachkonto.Get_Steuerkonto2: Integer;
begin
  Result := DefaultInterface.Steuerkonto2;
end;

function TSachkonto.Get_IsVStGesperrt: WordBool;
begin
  Result := DefaultInterface.IsVStGesperrt;
end;

function TSachkonto.Get_RatingKonto: Integer;
begin
  Result := DefaultInterface.RatingKonto;
end;

function TSachkonto.Get_AnzahlArt: Integer;
begin
  Result := DefaultInterface.AnzahlArt;
end;

function TSachkonto.Get_AnzKtoUSt: Integer;
begin
  Result := DefaultInterface.AnzKtoUSt;
end;

function TSachkonto.Get_AnzKonto: Integer;
begin
  Result := DefaultInterface.AnzKonto;
end;

function TSachkonto.Get_IsAufzuteilendeVSt: WordBool;
begin
  Result := DefaultInterface.IsAufzuteilendeVSt;
end;

function TSachkonto.Get_ErwerbLieferungAus: Integer;
begin
  Result := DefaultInterface.ErwerbLieferungAus;
end;

function TSachkonto.Get_Skontokonto: Integer;
begin
  Result := DefaultInterface.Skontokonto;
end;

function TSachkonto.Get_Differenzkonto: Integer;
begin
  Result := DefaultInterface.Differenzkonto;
end;

function TSachkonto.Get_EBVortrag: Integer;
begin
  Result := DefaultInterface.EBVortrag;
end;

function TSachkonto.Get_EBKonto: Integer;
begin
  Result := DefaultInterface.EBKonto;
end;

function TSachkonto.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TSachkonto.Konto: IKonto;
begin
  Result := DefaultInterface.Konto;
end;

function TSachkonto.HGBPosSGruppe: IGruppe;
begin
  Result := DefaultInterface.HGBPosSGruppe;
end;

function TSachkonto.HGBPosHGruppe: IGruppe;
begin
  Result := DefaultInterface.HGBPosHGruppe;
end;

function TSachkonto.USGAAPSGruppe: IGruppe;
begin
  Result := DefaultInterface.USGAAPSGruppe;
end;

function TSachkonto.USGAAPHGruppe: IGruppe;
begin
  Result := DefaultInterface.USGAAPHGruppe;
end;

function TSachkonto.Kostenart: IKostenart;
begin
  Result := DefaultInterface.Kostenart;
end;

function TSachkonto.USt: IUSt;
begin
  Result := DefaultInterface.USt;
end;

function TSachkonto.Bankverbindung: IBankverbindung;
begin
  Result := DefaultInterface.Bankverbindung;
end;

class function CoBuchtext.Create: IBuchtext;
begin
  Result := CreateComObject(CLASS_Buchtext) as IBuchtext;
end;

class function CoBuchtext.CreateRemote(const MachineName: string): IBuchtext;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Buchtext) as IBuchtext;
end;

procedure TBuchtext.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{E85F47D6-CB74-4E18-950E-4FB8E6F34179}';
    IntfIID:   '{E7D65604-3692-4FBA-9A87-061D5B95CCC4}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBuchtext.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBuchtext;
  end;
end;

procedure TBuchtext.ConnectTo(svrIntf: IBuchtext);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBuchtext.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBuchtext.GetDefaultInterface: IBuchtext;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TBuchtext.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBuchtext.Destroy;
begin
  inherited Destroy;
end;

function TBuchtext.Get_Text(Nr: Integer): WideString;
begin
  Result := DefaultInterface.Text[Nr];
end;

procedure TBuchtext.Set_Text(Nr: Integer; const Value: WideString);
begin
  DefaultInterface.Text[Nr] := Value;
end;

class function CoSteuer.Create: ISteuer;
begin
  Result := CreateComObject(CLASS_Steuer) as ISteuer;
end;

class function CoSteuer.CreateRemote(const MachineName: string): ISteuer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Steuer) as ISteuer;
end;

procedure TSteuer.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{73BCE1A3-62FB-416E-B83C-DD2F106B150D}';
    IntfIID:   '{22C0CE96-24A8-4709-9E06-A2FF7AF6D473}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSteuer.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISteuer;
  end;
end;

procedure TSteuer.ConnectTo(svrIntf: ISteuer);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSteuer.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSteuer.GetDefaultInterface: ISteuer;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TSteuer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TSteuer.Destroy;
begin
  inherited Destroy;
end;

function TSteuer.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

procedure TSteuer.Set_Nummer(Value: Integer);
begin
  DefaultInterface.Nummer := Value;
end;

function TSteuer.Get_Bezeichnung: WideString;
begin
  Result := DefaultInterface.Bezeichnung;
end;

procedure TSteuer.Set_Bezeichnung(const Value: WideString);
begin
  DefaultInterface.Bezeichnung := Value;
end;

function TSteuer.Get_Steuersatz1: Double;
begin
  Result := DefaultInterface.Steuersatz1;
end;

procedure TSteuer.Set_Steuersatz1(Value: Double);
begin
  DefaultInterface.Steuersatz1 := Value;
end;

function TSteuer.Get_AbDatum: TDateTime;
begin
  Result := DefaultInterface.AbDatum;
end;

procedure TSteuer.Set_AbDatum(Value: TDateTime);
begin
  DefaultInterface.AbDatum := Value;
end;

function TSteuer.Get_Steuersatz2: Double;
begin
  Result := DefaultInterface.Steuersatz2;
end;

procedure TSteuer.Set_Steuersatz2(Value: Double);
begin
  DefaultInterface.Steuersatz2 := Value;
end;

function TSteuer.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoFinanzamt.Create: IFinanzamt;
begin
  Result := CreateComObject(CLASS_Finanzamt) as IFinanzamt;
end;

class function CoFinanzamt.CreateRemote(const MachineName: string): IFinanzamt;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Finanzamt) as IFinanzamt;
end;

procedure TFinanzamt.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{8385D76C-6969-4F36-A2F7-5E37D1C20582}';
    IntfIID:   '{674A1634-FB20-4628-A844-B8EDA3816C13}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFinanzamt.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFinanzamt;
  end;
end;

procedure TFinanzamt.ConnectTo(svrIntf: IFinanzamt);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFinanzamt.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFinanzamt.GetDefaultInterface: IFinanzamt;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TFinanzamt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFinanzamt.Destroy;
begin
  inherited Destroy;
end;

function TFinanzamt.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

procedure TFinanzamt.Set_Nummer(Value: Integer);
begin
  DefaultInterface.Nummer := Value;
end;

function TFinanzamt.Get_OFD: WideString;
begin
  Result := DefaultInterface.OFD;
end;

procedure TFinanzamt.Set_OFD(const Value: WideString);
begin
  DefaultInterface.OFD := Value;
end;

function TFinanzamt.Get_Bundesland: WideString;
begin
  Result := DefaultInterface.Bundesland;
end;

procedure TFinanzamt.Set_Bundesland(const Value: WideString);
begin
  DefaultInterface.Bundesland := Value;
end;

function TFinanzamt.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TFinanzamt.Adresse: IAdresse;
begin
  Result := DefaultInterface.Adresse;
end;

function TFinanzamt.Bankverbindung(Nr: Integer): IBankverbindung;
begin
  Result := DefaultInterface.Bankverbindung(Nr);
end;

class function CoBank.Create: IBank;
begin
  Result := CreateComObject(CLASS_Bank) as IBank;
end;

class function CoBank.CreateRemote(const MachineName: string): IBank;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Bank) as IBank;
end;

procedure TBank.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{9C7E8B29-B247-41FC-9BFE-D5ADE539060D}';
    IntfIID:   '{B8862CA1-FB09-436E-ACED-030B76C2B036}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBank.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBank;
  end;
end;

procedure TBank.ConnectTo(svrIntf: IBank);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBank.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBank.GetDefaultInterface: IBank;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TBank.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBank.Destroy;
begin
  inherited Destroy;
end;

function TBank.Get_BLZ: Integer;
begin
  Result := DefaultInterface.BLZ;
end;

procedure TBank.Set_BLZ(Value: Integer);
begin
  DefaultInterface.BLZ := Value;
end;

function TBank.Get_Bezeichnung: WideString;
begin
  Result := DefaultInterface.Bezeichnung;
end;

procedure TBank.Set_Bezeichnung(const Value: WideString);
begin
  DefaultInterface.Bezeichnung := Value;
end;

function TBank.Get_Pruefziffer: Integer;
begin
  Result := DefaultInterface.Pruefziffer;
end;

function TBank.Get_PLZ: Integer;
begin
  Result := DefaultInterface.PLZ;
end;

function TBank.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TBank.CheckBLZ(BLZ: Integer): WordBool;
begin
  Result := DefaultInterface.CheckBLZ(BLZ);
end;

function TBank.CheckKTO(BLZ: Integer; const KTO: WideString): WordBool;
begin
  Result := DefaultInterface.CheckKTO(BLZ, KTO);
end;

function TBank.Ort: IOrt;
begin
  Result := DefaultInterface.Ort;
end;

function TBank.CheckIBAN(const IBANNr: WideString): WordBool;
begin
  Result := DefaultInterface.CheckIBAN(IBANNr);
end;

class function CoKontenbereich.Create: IKontenbereich;
begin
  Result := CreateComObject(CLASS_Kontenbereich) as IKontenbereich;
end;

class function CoKontenbereich.CreateRemote(const MachineName: string): IKontenbereich;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Kontenbereich) as IKontenbereich;
end;

procedure TKontenbereich.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{94D8857F-A6BE-4C20-9B94-9624030FE533}';
    IntfIID:   '{7972BFC3-14AE-4196-8B20-878EB497C9F9}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKontenbereich.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKontenbereich;
  end;
end;

procedure TKontenbereich.ConnectTo(svrIntf: IKontenbereich);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKontenbereich.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKontenbereich.GetDefaultInterface: IKontenbereich;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKontenbereich.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKontenbereich.Destroy;
begin
  inherited Destroy;
end;

procedure TKontenbereich.Debitoren(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
begin
  DefaultInterface.Debitoren(Von, Bis, Kontenklasse);
end;

procedure TKontenbereich.Kreditoren(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
begin
  DefaultInterface.Kreditoren(Von, Bis, Kontenklasse);
end;

procedure TKontenbereich.Sachkonten(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
begin
  DefaultInterface.Sachkonten(Von, Bis, Kontenklasse);
end;

procedure TKontenbereich.Kostenstellen(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
begin
  DefaultInterface.Kostenstellen(Von, Bis, Kontenklasse);
end;

procedure TKontenbereich.Kostentraeger(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
begin
  DefaultInterface.Kostentraeger(Von, Bis, Kontenklasse);
end;

procedure TKontenbereich.Kostenarten(out Von: Integer; out Bis: Integer; out Kontenklasse: Integer);
begin
  DefaultInterface.Kostenarten(Von, Bis, Kontenklasse);
end;

function TKontenbereich.GetKontoTyp(Konto: Integer): EKontotypen;
begin
  Result := DefaultInterface.GetKontoTyp(Konto);
end;

function TKontenbereich.CheckKonto(Konto: Integer; KontoTyp: EKontotypen): WordBool;
begin
  Result := DefaultInterface.CheckKonto(Konto, KontoTyp);
end;

class function CoBankverbindung.Create: IBankverbindung;
begin
  Result := CreateComObject(CLASS_Bankverbindung) as IBankverbindung;
end;

class function CoBankverbindung.CreateRemote(const MachineName: string): IBankverbindung;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Bankverbindung) as IBankverbindung;
end;

procedure TBankverbindung.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{BC37C9A3-3E07-4AF7-A3CC-6FA1E9A1F033}';
    IntfIID:   '{31B86FDE-9985-4E8F-BBFE-0D7BFC116AD2}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBankverbindung.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBankverbindung;
  end;
end;

procedure TBankverbindung.ConnectTo(svrIntf: IBankverbindung);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBankverbindung.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBankverbindung.GetDefaultInterface: IBankverbindung;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TBankverbindung.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBankverbindung.Destroy;
begin
  inherited Destroy;
end;

function TBankverbindung.Get_KTO: WideString;
begin
  Result := DefaultInterface.KTO;
end;

procedure TBankverbindung.Set_KTO(const Value: WideString);
begin
  DefaultInterface.KTO := Value;
end;

function TBankverbindung.Get_Inhaber: WideString;
begin
  Result := DefaultInterface.Inhaber;
end;

procedure TBankverbindung.Set_Inhaber(const Value: WideString);
begin
  DefaultInterface.Inhaber := Value;
end;

function TBankverbindung.Get_BLZ: Integer;
begin
  Result := DefaultInterface.BLZ;
end;

function TBankverbindung.Get_IBAN: WideString;
begin
  Result := DefaultInterface.IBAN;
end;

function TBankverbindung.Get_SWIFT: WideString;
begin
  Result := DefaultInterface.SWIFT;
end;

function TBankverbindung.Get_AuslBankKto: WideString;
begin
  Result := DefaultInterface.AuslBankKto;
end;

function TBankverbindung.Bank: IBank;
begin
  Result := DefaultInterface.Bank;
end;

function TBankverbindung.CheckKTO: WordBool;
begin
  Result := DefaultInterface.CheckKTO;
end;

function TBankverbindung.CheckIBAN: WordBool;
begin
  Result := DefaultInterface.CheckIBAN;
end;

class function CoGruppe.Create: IGruppe;
begin
  Result := CreateComObject(CLASS_Gruppe) as IGruppe;
end;

class function CoGruppe.CreateRemote(const MachineName: string): IGruppe;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Gruppe) as IGruppe;
end;

procedure TGruppe.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D719FAA3-F645-4D1F-A10A-4C3D15978441}';
    IntfIID:   '{36FFA492-B38C-4E00-A40B-4B8830C94AFD}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TGruppe.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IGruppe;
  end;
end;

procedure TGruppe.ConnectTo(svrIntf: IGruppe);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TGruppe.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TGruppe.GetDefaultInterface: IGruppe;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TGruppe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TGruppe.Destroy;
begin
  inherited Destroy;
end;

function TGruppe.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

procedure TGruppe.Set_Nummer(Value: Integer);
begin
  DefaultInterface.Nummer := Value;
end;

function TGruppe.Get_Bezeichnung: WideString;
begin
  Result := DefaultInterface.Bezeichnung;
end;

procedure TGruppe.Set_Bezeichnung(const Value: WideString);
begin
  DefaultInterface.Bezeichnung := Value;
end;

function TGruppe.Get_Zuordnung: EBilGuVZuordnung;
begin
  Result := DefaultInterface.Zuordnung;
end;

function TGruppe.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoKostenart.Create: IKostenart;
begin
  Result := CreateComObject(CLASS_Kostenart) as IKostenart;
end;

class function CoKostenart.CreateRemote(const MachineName: string): IKostenart;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Kostenart) as IKostenart;
end;

procedure TKostenart.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{834EB643-83A7-4E78-A173-4CAD8B1E3EBA}';
    IntfIID:   '{B8AA063F-0902-48B5-9DFD-1F28EF9FF9EC}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKostenart.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKostenart;
  end;
end;

procedure TKostenart.ConnectTo(svrIntf: IKostenart);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKostenart.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKostenart.GetDefaultInterface: IKostenart;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKostenart.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKostenart.Destroy;
begin
  inherited Destroy;
end;

function TKostenart.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

procedure TKostenart.Set_Nummer(Value: Integer);
begin
  DefaultInterface.Nummer := Value;
end;

function TKostenart.Get_Bezeichnung: WideString;
begin
  Result := DefaultInterface.Bezeichnung;
end;

procedure TKostenart.Set_Bezeichnung(const Value: WideString);
begin
  DefaultInterface.Bezeichnung := Value;
end;

function TKostenart.Get_IsLeistung: WordBool;
begin
  Result := DefaultInterface.IsLeistung;
end;

procedure TKostenart.Set_IsLeistung(Value: WordBool);
begin
  DefaultInterface.IsLeistung := Value;
end;

function TKostenart.Get_IsMengenerfassung: WordBool;
begin
  Result := DefaultInterface.IsMengenerfassung;
end;

function TKostenart.Get_IsBebucht: WordBool;
begin
  Result := DefaultInterface.IsBebucht;
end;

function TKostenart.Get_Bezeichnung1: WideString;
begin
  Result := DefaultInterface.Bezeichnung1;
end;

procedure TKostenart.Set_Bezeichnung1(const Value: WideString);
begin
  DefaultInterface.Bezeichnung1 := Value;
end;

function TKostenart.Get_IsMengePflicht: WordBool;
begin
  Result := DefaultInterface.IsMengePflicht;
end;

function TKostenart.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TKostenart.KStSaldo(WaNr: Integer; IsInHW: WordBool): ISaldo;
begin
  Result := DefaultInterface.KStSaldo(WaNr, IsInHW);
end;

function TKostenart.KTrSaldo(WaNr: Integer; IsInHW: WordBool): ISaldo;
begin
  Result := DefaultInterface.KTrSaldo(WaNr, IsInHW);
end;

function TKostenart.KLRJournal(WiJ: Integer): IKLRJournal;
begin
  Result := DefaultInterface.KLRJournal(WiJ);
end;

class function CoKostenstelle.Create: IKostenstelle;
begin
  Result := CreateComObject(CLASS_Kostenstelle) as IKostenstelle;
end;

class function CoKostenstelle.CreateRemote(const MachineName: string): IKostenstelle;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Kostenstelle) as IKostenstelle;
end;

procedure TKostenstelle.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{EE6C870F-1A19-4D05-8F2E-122E93D69536}';
    IntfIID:   '{92DAE5A4-DCB5-497A-B729-838FD8284E3C}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKostenstelle.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKostenstelle;
  end;
end;

procedure TKostenstelle.ConnectTo(svrIntf: IKostenstelle);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKostenstelle.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKostenstelle.GetDefaultInterface: IKostenstelle;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKostenstelle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKostenstelle.Destroy;
begin
  inherited Destroy;
end;

function TKostenstelle.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

procedure TKostenstelle.Set_Nummer(Value: Integer);
begin
  DefaultInterface.Nummer := Value;
end;

function TKostenstelle.Get_Bezeichnung(Nr: Integer): WideString;
begin
  Result := DefaultInterface.Bezeichnung[Nr];
end;

procedure TKostenstelle.Set_Bezeichnung(Nr: Integer; const Value: WideString);
begin
  DefaultInterface.Bezeichnung[Nr] := Value;
end;

function TKostenstelle.Get_Bezeichnung1: WideString;
begin
  Result := DefaultInterface.Bezeichnung1;
end;

procedure TKostenstelle.Set_Bezeichnung1(const Value: WideString);
begin
  DefaultInterface.Bezeichnung1 := Value;
end;

function TKostenstelle.Get_Bezeichnung2: WideString;
begin
  Result := DefaultInterface.Bezeichnung2;
end;

procedure TKostenstelle.Set_Bezeichnung2(const Value: WideString);
begin
  DefaultInterface.Bezeichnung2 := Value;
end;

function TKostenstelle.Get_Bezeichnung3: WideString;
begin
  Result := DefaultInterface.Bezeichnung3;
end;

procedure TKostenstelle.Set_Bezeichnung3(const Value: WideString);
begin
  DefaultInterface.Bezeichnung3 := Value;
end;

function TKostenstelle.Get_KurzBez: WideString;
begin
  Result := DefaultInterface.KurzBez;
end;

procedure TKostenstelle.Set_KurzBez(const Value: WideString);
begin
  DefaultInterface.KurzBez := Value;
end;

function TKostenstelle.Get_IsHaupt: WordBool;
begin
  Result := DefaultInterface.IsHaupt;
end;

procedure TKostenstelle.Set_IsHaupt(Value: WordBool);
begin
  DefaultInterface.IsHaupt := Value;
end;

function TKostenstelle.Get_FixVar: Integer;
begin
  Result := DefaultInterface.FixVar;
end;

procedure TKostenstelle.Set_FixVar(Value: Integer);
begin
  DefaultInterface.FixVar := Value;
end;

function TKostenstelle.Get_IsAskFixVar: WordBool;
begin
  Result := DefaultInterface.IsAskFixVar;
end;

procedure TKostenstelle.Set_IsAskFixVar(Value: WordBool);
begin
  DefaultInterface.IsAskFixVar := Value;
end;

function TKostenstelle.Get_IsBebucht: WordBool;
begin
  Result := DefaultInterface.IsBebucht;
end;

function TKostenstelle.Get_SperreTyp: Integer;
begin
  Result := DefaultInterface.SperreTyp;
end;

function TKostenstelle.Get_SperrFreiDatumVon: TDateTime;
begin
  Result := DefaultInterface.SperrFreiDatumVon;
end;

function TKostenstelle.Get_SperrFreiDatumBis: TDateTime;
begin
  Result := DefaultInterface.SperrFreiDatumBis;
end;

function TKostenstelle.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TKostenstelle.Gruppe(Nr: Integer): IGruppe;
begin
  Result := DefaultInterface.Gruppe(Nr);
end;

function TKostenstelle.Planmenge(Nr: Integer): IPlanmenge;
begin
  Result := DefaultInterface.Planmenge(Nr);
end;

function TKostenstelle.Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo;
begin
  Result := DefaultInterface.Saldo(WaNr, IsInHW);
end;

function TKostenstelle.GrpNummer(Nr: Integer): Integer;
begin
  Result := DefaultInterface.GrpNummer(Nr);
end;

function TKostenstelle.KLRJournal(WiJ: Integer): IKLRJournal;
begin
  Result := DefaultInterface.KLRJournal(WiJ);
end;

class function CoBezugsgroesse.Create: IBezugsgroesse;
begin
  Result := CreateComObject(CLASS_Bezugsgroesse) as IBezugsgroesse;
end;

class function CoBezugsgroesse.CreateRemote(const MachineName: string): IBezugsgroesse;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Bezugsgroesse) as IBezugsgroesse;
end;

procedure TBezugsgroesse.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A1DD0C3A-A1F2-4600-B98C-0F9EFEB0C8D0}';
    IntfIID:   '{2DBE782A-A5FE-471D-AD3C-91216B4C7376}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBezugsgroesse.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBezugsgroesse;
  end;
end;

procedure TBezugsgroesse.ConnectTo(svrIntf: IBezugsgroesse);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBezugsgroesse.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBezugsgroesse.GetDefaultInterface: IBezugsgroesse;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TBezugsgroesse.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBezugsgroesse.Destroy;
begin
  inherited Destroy;
end;

function TBezugsgroesse.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

procedure TBezugsgroesse.Set_Nummer(Value: Integer);
begin
  DefaultInterface.Nummer := Value;
end;

function TBezugsgroesse.Get_Bezeichnung: WideString;
begin
  Result := DefaultInterface.Bezeichnung;
end;

procedure TBezugsgroesse.Set_Bezeichnung(const Value: WideString);
begin
  DefaultInterface.Bezeichnung := Value;
end;

function TBezugsgroesse.Get_KurzBez: WideString;
begin
  Result := DefaultInterface.KurzBez;
end;

procedure TBezugsgroesse.Set_KurzBez(const Value: WideString);
begin
  DefaultInterface.KurzBez := Value;
end;

function TBezugsgroesse.Get_Nachkomma: Integer;
begin
  Result := DefaultInterface.Nachkomma;
end;

procedure TBezugsgroesse.Set_Nachkomma(Value: Integer);
begin
  DefaultInterface.Nachkomma := Value;
end;

function TBezugsgroesse.Get_BGTyp: Integer;
begin
  Result := DefaultInterface.BGTyp;
end;

procedure TBezugsgroesse.Set_BGTyp(Value: Integer);
begin
  DefaultInterface.BGTyp := Value;
end;

function TBezugsgroesse.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoPlanmenge.Create: IPlanmenge;
begin
  Result := CreateComObject(CLASS_Planmenge) as IPlanmenge;
end;

class function CoPlanmenge.CreateRemote(const MachineName: string): IPlanmenge;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Planmenge) as IPlanmenge;
end;

procedure TPlanmenge.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{08EFFDEE-AC57-446A-8C1F-E33BB1C765BB}';
    IntfIID:   '{76F18D94-865F-4667-B88C-027CC0F7AE7A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TPlanmenge.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IPlanmenge;
  end;
end;

procedure TPlanmenge.ConnectTo(svrIntf: IPlanmenge);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TPlanmenge.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TPlanmenge.GetDefaultInterface: IPlanmenge;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TPlanmenge.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TPlanmenge.Destroy;
begin
  inherited Destroy;
end;

function TPlanmenge.Get_Wert: Double;
begin
  Result := DefaultInterface.Wert;
end;

procedure TPlanmenge.Set_Wert(Value: Double);
begin
  DefaultInterface.Wert := Value;
end;

function TPlanmenge.Get_IsAbfrage: WordBool;
begin
  Result := DefaultInterface.IsAbfrage;
end;

procedure TPlanmenge.Set_IsAbfrage(Value: WordBool);
begin
  DefaultInterface.IsAbfrage := Value;
end;

function TPlanmenge.Bezugsgroesse: IBezugsgroesse;
begin
  Result := DefaultInterface.Bezugsgroesse;
end;

class function CoUSt.Create: IUSt;
begin
  Result := CreateComObject(CLASS_USt) as IUSt;
end;

class function CoUSt.CreateRemote(const MachineName: string): IUSt;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_USt) as IUSt;
end;

procedure TUSt.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5D822809-F4E0-46C7-AFFE-80D6B1236DE6}';
    IntfIID:   '{80C79C66-0713-45D8-9999-8FE3C5525FBD}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TUSt.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IUSt;
  end;
end;

procedure TUSt.ConnectTo(svrIntf: IUSt);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TUSt.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TUSt.GetDefaultInterface: IUSt;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TUSt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TUSt.Destroy;
begin
  inherited Destroy;
end;

function TUSt.Get_Art: EUStArten;
begin
  Result := DefaultInterface.Art;
end;

procedure TUSt.Set_Art(Value: EUStArten);
begin
  DefaultInterface.Art := Value;
end;

function TUSt.Get_ArtMV: WideString;
begin
  Result := DefaultInterface.ArtMV;
end;

procedure TUSt.Set_ArtMV(const Value: WideString);
begin
  DefaultInterface.ArtMV := Value;
end;

function TUSt.Get_Schluessel: Integer;
begin
  Result := DefaultInterface.Schluessel;
end;

function TUSt.Get_IsAnzahlung: WordBool;
begin
  Result := DefaultInterface.IsAnzahlung;
end;

function TUSt.Steuer: ISteuer;
begin
  Result := DefaultInterface.Steuer;
end;

function TUSt.AsRecord: RUSt;
begin
  Result := DefaultInterface.AsRecord;
end;

class function CoKurs.Create: IKurs;
begin
  Result := CreateComObject(CLASS_Kurs) as IKurs;
end;

class function CoKurs.CreateRemote(const MachineName: string): IKurs;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Kurs) as IKurs;
end;

procedure TKurs.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{3721D2A7-393F-4EFE-8E92-2EB6F8637E27}';
    IntfIID:   '{8CB1660A-7274-4A68-8EBC-22D8A0388E6B}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKurs.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKurs;
  end;
end;

procedure TKurs.ConnectTo(svrIntf: IKurs);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKurs.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKurs.GetDefaultInterface: IKurs;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKurs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKurs.Destroy;
begin
  inherited Destroy;
end;

function TKurs.Get_Basis: Integer;
begin
  Result := DefaultInterface.Basis;
end;

procedure TKurs.Set_Basis(Value: Integer);
begin
  DefaultInterface.Basis := Value;
end;

function TKurs.Get_Tageskurs: Double;
begin
  Result := DefaultInterface.Tageskurs;
end;

procedure TKurs.Set_Tageskurs(Value: Double);
begin
  DefaultInterface.Tageskurs := Value;
end;

function TKurs.Get_Waehrungsbetrag: Currency;
begin
  Result := DefaultInterface.Waehrungsbetrag;
end;

procedure TKurs.Set_Waehrungsbetrag(Value: Currency);
begin
  DefaultInterface.Waehrungsbetrag := Value;
end;

function TKurs.Get_Waehrungsnummer: Integer;
begin
  Result := DefaultInterface.Waehrungsnummer;
end;

function TKurs.Waehrung: IWaehrung;
begin
  Result := DefaultInterface.Waehrung;
end;

function TKurs.AsRecord: RKurs;
begin
  Result := DefaultInterface.AsRecord;
end;

class function CoWaehrung.Create: IWaehrung;
begin
  Result := CreateComObject(CLASS_Waehrung) as IWaehrung;
end;

class function CoWaehrung.CreateRemote(const MachineName: string): IWaehrung;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Waehrung) as IWaehrung;
end;

procedure TWaehrung.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{9A1C1EB4-3237-4A37-BEF7-8B5E6904554A}';
    IntfIID:   '{7A0623CD-D78E-4584-9B6D-3C57369992B6}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TWaehrung.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IWaehrung;
  end;
end;

procedure TWaehrung.ConnectTo(svrIntf: IWaehrung);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TWaehrung.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TWaehrung.GetDefaultInterface: IWaehrung;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TWaehrung.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TWaehrung.Destroy;
begin
  inherited Destroy;
end;

function TWaehrung.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

procedure TWaehrung.Set_Nummer(Value: Integer);
begin
  DefaultInterface.Nummer := Value;
end;

function TWaehrung.Get_Bezeichnung: WideString;
begin
  Result := DefaultInterface.Bezeichnung;
end;

procedure TWaehrung.Set_Bezeichnung(const Value: WideString);
begin
  DefaultInterface.Bezeichnung := Value;
end;

function TWaehrung.Get_ISOBez: WideString;
begin
  Result := DefaultInterface.ISOBez;
end;

procedure TWaehrung.Set_ISOBez(const Value: WideString);
begin
  DefaultInterface.ISOBez := Value;
end;

function TWaehrung.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TWaehrung.Land: ILand;
begin
  Result := DefaultInterface.Land;
end;

function TWaehrung.Festkonto(Nr: Integer): IFestkonto;
begin
  Result := DefaultInterface.Festkonto(Nr);
end;

class function CoMahn.Create: IMahn;
begin
  Result := CreateComObject(CLASS_Mahn) as IMahn;
end;

class function CoMahn.CreateRemote(const MachineName: string): IMahn;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Mahn) as IMahn;
end;

procedure TMahn.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B4A033DD-FE53-485E-894E-76ABB2CBDA70}';
    IntfIID:   '{0F6EC919-BF2F-4018-9036-3DACD1D62C57}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMahn.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMahn;
  end;
end;

procedure TMahn.ConnectTo(svrIntf: IMahn);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMahn.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMahn.GetDefaultInterface: IMahn;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TMahn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMahn.Destroy;
begin
  inherited Destroy;
end;

function TMahn.Get_Mahnstufe: Integer;
begin
  Result := DefaultInterface.Mahnstufe;
end;

procedure TMahn.Set_Mahnstufe(Value: Integer);
begin
  DefaultInterface.Mahnstufe := Value;
end;

function TMahn.Get_Mahndatum: TDateTime;
begin
  Result := DefaultInterface.Mahndatum;
end;

procedure TMahn.Set_Mahndatum(Value: TDateTime);
begin
  DefaultInterface.Mahndatum := Value;
end;

function TMahn.Get_IsMahnstop: WordBool;
begin
  Result := DefaultInterface.IsMahnstop;
end;

procedure TMahn.Set_IsMahnstop(Value: WordBool);
begin
  DefaultInterface.IsMahnstop := Value;
end;

class function CoZahlkondition.Create: IZahlkondition;
begin
  Result := CreateComObject(CLASS_Zahlkondition) as IZahlkondition;
end;

class function CoZahlkondition.CreateRemote(const MachineName: string): IZahlkondition;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Zahlkondition) as IZahlkondition;
end;

procedure TZahlkondition.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5CB158A1-FF48-49DA-8F1D-DA170902DB2C}';
    IntfIID:   '{627A486E-3965-4E95-A7E3-E48643BE12AE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TZahlkondition.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IZahlkondition;
  end;
end;

procedure TZahlkondition.ConnectTo(svrIntf: IZahlkondition);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TZahlkondition.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TZahlkondition.GetDefaultInterface: IZahlkondition;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TZahlkondition.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TZahlkondition.Destroy;
begin
  inherited Destroy;
end;

function TZahlkondition.Get_Tage1: Integer;
begin
  Result := DefaultInterface.Tage1;
end;

procedure TZahlkondition.Set_Tage1(Value: Integer);
begin
  DefaultInterface.Tage1 := Value;
end;

function TZahlkondition.Get_Skonto1: Single;
begin
  Result := DefaultInterface.Skonto1;
end;

procedure TZahlkondition.Set_Skonto1(Value: Single);
begin
  DefaultInterface.Skonto1 := Value;
end;

function TZahlkondition.Get_Tage2: Integer;
begin
  Result := DefaultInterface.Tage2;
end;

procedure TZahlkondition.Set_Tage2(Value: Integer);
begin
  DefaultInterface.Tage2 := Value;
end;

function TZahlkondition.Get_Skonto2: Single;
begin
  Result := DefaultInterface.Skonto2;
end;

procedure TZahlkondition.Set_Skonto2(Value: Single);
begin
  DefaultInterface.Skonto2 := Value;
end;

function TZahlkondition.Get_Nettozahlungsziel: Integer;
begin
  Result := DefaultInterface.Nettozahlungsziel;
end;

procedure TZahlkondition.Set_Nettozahlungsziel(Value: Integer);
begin
  DefaultInterface.Nettozahlungsziel := Value;
end;

function TZahlkondition.AsRecord: RZahlkondition;
begin
  Result := DefaultInterface.AsRecord;
end;

class function CoFNReport.Create: IFNReport;
begin
  Result := CreateComObject(CLASS_FNReport) as IFNReport;
end;

class function CoFNReport.CreateRemote(const MachineName: string): IFNReport;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FNReport) as IFNReport;
end;

procedure TFNReport.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0477E266-5303-41F0-9EA5-245FA3B7744E}';
    IntfIID:   '{790FCD48-C23E-449E-8B32-714965725863}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFNReport.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFNReport;
  end;
end;

procedure TFNReport.ConnectTo(svrIntf: IFNReport);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFNReport.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFNReport.GetDefaultInterface: IFNReport;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TFNReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFNReport.Destroy;
begin
  inherited Destroy;
end;

function TFNReport.Get_Formular: OleVariant;
begin
  Result := DefaultInterface.Formular;
end;

procedure TFNReport.Set_Formular(Value: OleVariant);
begin
  DefaultInterface.Formular := Value;
end;

function TFNReport.Get_Formeln: OleVariant;
begin
  Result := DefaultInterface.Formeln;
end;

procedure TFNReport.Set_Formeln(Value: OleVariant);
begin
  DefaultInterface.Formeln := Value;
end;

function TFNReport.Get_Variable(const VarName: WideString): OleVariant;
begin
  Result := DefaultInterface.Variable[VarName];
end;

function TFNReport.Taschenrechner(const Ausdruck: WideString): Double;
begin
  Result := DefaultInterface.Taschenrechner(Ausdruck);
end;

procedure TFNReport.Load(const FrmName: WideString; const Passwort: WideString);
begin
  DefaultInterface.Load(FrmName, Passwort);
end;

procedure TFNReport.Save(const FrmName: WideString);
begin
  DefaultInterface.Save(FrmName);
end;

function TFNReport.Auswerten(Tagesabgrenzung: Integer; IsMVZabgrenzung: WordBool; 
                             IsMitStapel: WordBool): WordBool;
begin
  Result := DefaultInterface.Auswerten(Tagesabgrenzung, IsMVZabgrenzung, IsMitStapel);
end;

class function CoChooseMandant.Create: IChooseMandant;
begin
  Result := CreateComObject(CLASS_ChooseMandant) as IChooseMandant;
end;

class function CoChooseMandant.CreateRemote(const MachineName: string): IChooseMandant;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ChooseMandant) as IChooseMandant;
end;

procedure TChooseMandant.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{DFD80C51-BD3B-4347-A6BC-D6858E769DD7}';
    IntfIID:   '{A42D9E77-71E7-4FA9-86A4-03F7E4116461}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TChooseMandant.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IChooseMandant;
  end;
end;

procedure TChooseMandant.ConnectTo(svrIntf: IChooseMandant);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TChooseMandant.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TChooseMandant.GetDefaultInterface: IChooseMandant;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TChooseMandant.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TChooseMandant.Destroy;
begin
  inherited Destroy;
end;

function TChooseMandant.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

function TChooseMandant.Get_Bezeichnung: WideString;
begin
  Result := DefaultInterface.Bezeichnung;
end;

function TChooseMandant.Get_aktlWiJahr: Integer;
begin
  Result := DefaultInterface.aktlWiJahr;
end;

function TChooseMandant.Get_letzteMonatWiJahr: Integer;
begin
  Result := DefaultInterface.letzteMonatWiJahr;
end;

function TChooseMandant.Get_Bankleitzahl: Integer;
begin
  Result := DefaultInterface.Bankleitzahl;
end;

function TChooseMandant.Get_Bankkontonummer: WideString;
begin
  Result := DefaultInterface.Bankkontonummer;
end;

function TChooseMandant.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TChooseMandant.Adresse: IAdresse;
begin
  Result := DefaultInterface.Adresse;
end;

class function CoPasswort.Create: IPasswort;
begin
  Result := CreateComObject(CLASS_Passwort) as IPasswort;
end;

class function CoPasswort.CreateRemote(const MachineName: string): IPasswort;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Passwort) as IPasswort;
end;

procedure TPasswort.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{3DA7F71B-A8B7-469B-833F-8D3EA8C3B84C}';
    IntfIID:   '{EEB4FA02-617F-4F9C-A83B-510D5699B86E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TPasswort.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IPasswort;
  end;
end;

procedure TPasswort.ConnectTo(svrIntf: IPasswort);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TPasswort.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TPasswort.GetDefaultInterface: IPasswort;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TPasswort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TPasswort.Destroy;
begin
  inherited Destroy;
end;

function TPasswort.PruefeMandant(Mandant: Integer; const Passwort: WideString): WordBool;
begin
  Result := DefaultInterface.PruefeMandant(Mandant, Passwort);
end;

function TPasswort.SetzeMandant(Mandant: Integer; const Passwort: WideString): WordBool;
begin
  Result := DefaultInterface.SetzeMandant(Mandant, Passwort);
end;

procedure TPasswort.PruefeReportgenerator;
begin
  DefaultInterface.PruefeReportgenerator;
end;

function TPasswort.PruefeAdministrator(const Passwort: WideString): WordBool;
begin
  Result := DefaultInterface.PruefeAdministrator(Passwort);
end;

procedure TPasswort.PruefeBenutzerverwalter;
begin
  DefaultInterface.PruefeBenutzerverwalter;
end;

class function CoBuchen.Create: IBuchen;
begin
  Result := CreateComObject(CLASS_Buchen) as IBuchen;
end;

class function CoBuchen.CreateRemote(const MachineName: string): IBuchen;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Buchen) as IBuchen;
end;

procedure TBuchen.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0AD355FD-0649-4129-9413-5646451B82B3}';
    IntfIID:   '{08089F0D-B87E-4402-9649-EF3288D8EB81}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBuchen.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBuchen;
  end;
end;

procedure TBuchen.ConnectTo(svrIntf: IBuchen);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBuchen.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBuchen.GetDefaultInterface: IBuchen;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TBuchen.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBuchen.Destroy;
begin
  inherited Destroy;
end;

function TBuchen.Get_MinBuchDatum: TDateTime;
begin
  Result := DefaultInterface.MinBuchDatum;
end;

function TBuchen.Get_MaxBuchDatum: TDateTime;
begin
  Result := DefaultInterface.MaxBuchDatum;
end;

function TBuchen.Get_CmdLogSize: Integer;
begin
  Result := DefaultInterface.CmdLogSize;
end;

function TBuchen.Verarbeiten(const Data: WideString): WideString;
begin
  Result := DefaultInterface.Verarbeiten(Data);
end;

function TBuchen.Primanota: WideString;
begin
  Result := DefaultInterface.Primanota;
end;

function TBuchen.Hauswaehrung: WideString;
begin
  Result := DefaultInterface.Hauswaehrung;
end;

procedure TBuchen.Close;
begin
  DefaultInterface.Close;
end;

function TBuchen.Open(EBJahre: Integer; IsKtlSumBlatt: WordBool; IsSimulation: WordBool; 
                      IsStapel: WordBool): WideString;
begin
  Result := DefaultInterface.Open(EBJahre, IsKtlSumBlatt, IsSimulation, IsStapel);
end;

function TBuchen.Journalzeile: Integer;
begin
  Result := DefaultInterface.Journalzeile;
end;

function TBuchen.AskEBKorrektur: Integer;
begin
  Result := DefaultInterface.AskEBKorrektur;
end;

function TBuchen.Import: IFNImport;
begin
  Result := DefaultInterface.Import;
end;

function TBuchen.MinMaxDatum(out VonDatum: TDateTime; out BisDatum: TDateTime): WordBool;
begin
  Result := DefaultInterface.MinMaxDatum(VonDatum, BisDatum);
end;

procedure TBuchen.ClearCmds;
begin
  DefaultInterface.ClearCmds;
end;

function TBuchen.GetCmd(aCmdTyp: ECmdTypen): OleVariant;
begin
  Result := DefaultInterface.GetCmd(aCmdTyp);
end;

procedure TBuchen.AddCmd(aCmdClass: OleVariant);
begin
  DefaultInterface.AddCmd(aCmdClass);
end;

function TBuchen.ReadCmds: WideString;
begin
  Result := DefaultInterface.ReadCmds;
end;

function TBuchen.DCZahlung(FileNummer: Integer; Zahldatum: TDateTime; 
                           Wertstellungsdatum: TDateTime; out ErrText: WideString): WordBool;
begin
  Result := DefaultInterface.DCZahlung(FileNummer, Zahldatum, Wertstellungsdatum, ErrText);
end;

procedure TBuchen.CmdLogText(AbPosition: Integer; out LogSize: Integer; out LogText: WideString);
begin
  DefaultInterface.CmdLogText(AbPosition, LogSize, LogText);
end;

function TBuchen.CmdDayLogCount: Integer;
begin
  Result := DefaultInterface.CmdDayLogCount;
end;

function TBuchen.CmdDayLogText(FileNr: Integer): WideString;
begin
  Result := DefaultInterface.CmdDayLogText(FileNr);
end;

class function CoKostenstelleart.Create: IKostenstelleart;
begin
  Result := CreateComObject(CLASS_Kostenstelleart) as IKostenstelleart;
end;

class function CoKostenstelleart.CreateRemote(const MachineName: string): IKostenstelleart;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Kostenstelleart) as IKostenstelleart;
end;

procedure TKostenstelleart.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{09F58B84-7524-44B7-8121-B7F717EBE030}';
    IntfIID:   '{B4660F77-9875-4625-BEDA-321EFBD2D2E6}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKostenstelleart.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKostenstelleart;
  end;
end;

procedure TKostenstelleart.ConnectTo(svrIntf: IKostenstelleart);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKostenstelleart.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKostenstelleart.GetDefaultInterface: IKostenstelleart;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKostenstelleart.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKostenstelleart.Destroy;
begin
  inherited Destroy;
end;

function TKostenstelleart.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

function TKostenstelleart.Get_KostenartNummer: Integer;
begin
  Result := DefaultInterface.KostenartNummer;
end;

function TKostenstelleart.Get_IsLeistung: WordBool;
begin
  Result := DefaultInterface.IsLeistung;
end;

function TKostenstelleart.Get_IsBebucht: WordBool;
begin
  Result := DefaultInterface.IsBebucht;
end;

function TKostenstelleart.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TKostenstelleart.Saldo(WaNr: Integer; IsInHW: WordBool): ISaldo;
begin
  Result := DefaultInterface.Saldo(WaNr, IsInHW);
end;

function TKostenstelleart.KStKTr: IKostenstelle;
begin
  Result := DefaultInterface.KStKTr;
end;

function TKostenstelleart.Kostenart: IKostenart;
begin
  Result := DefaultInterface.Kostenart;
end;

function TKostenstelleart.StTrArtNr(KStTrNr: Integer; KArtNr: Integer): WordBool;
begin
  Result := DefaultInterface.StTrArtNr(KStTrNr, KArtNr);
end;

function TKostenstelleart.KLRJournal(WiJ: Integer): IKLRJournal;
begin
  Result := DefaultInterface.KLRJournal(WiJ);
end;

class function CoFNImport.Create: IFNImport;
begin
  Result := CreateComObject(CLASS_FNImport) as IFNImport;
end;

class function CoFNImport.CreateRemote(const MachineName: string): IFNImport;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FNImport) as IFNImport;
end;

procedure TFNImport.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6DA87207-D6F1-4AEE-8D5E-CC3A827AC141}';
    IntfIID:   '{1CC09930-7F41-4001-B2D4-5F4B289E1261}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFNImport.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFNImport;
  end;
end;

procedure TFNImport.ConnectTo(svrIntf: IFNImport);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFNImport.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFNImport.GetDefaultInterface: IFNImport;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TFNImport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFNImport.Destroy;
begin
  inherited Destroy;
end;

function TFNImport.Get_Name: WideString;
begin
  Result := DefaultInterface.Name;
end;

function TFNImport.Get_Info: WideString;
begin
  Result := DefaultInterface.Info;
end;

function TFNImport.Get_Datum: TDateTime;
begin
  Result := DefaultInterface.Datum;
end;

function TFNImport.Get_Groesse: Integer;
begin
  Result := DefaultInterface.Groesse;
end;

function TFNImport.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TFNImport.SaveToFile(const Filename: WideString; const Text: WideString; 
                              Overwrite: WordBool; const Adminpasswort: WideString): WordBool;
begin
  Result := DefaultInterface.SaveToFile(Filename, Text, Overwrite, Adminpasswort);
end;

function TFNImport.DeleteFile(const Filename: WideString): WordBool;
begin
  Result := DefaultInterface.DeleteFile(Filename);
end;

function TFNImport.Executefile(const Filename: WideString): Integer;
begin
  Result := DefaultInterface.Executefile(Filename);
end;

function TFNImport.LoadFromFile(const Filename: WideString): WideString;
begin
  Result := DefaultInterface.LoadFromFile(Filename);
end;

class function CoREB.Create: IREB;
begin
  Result := CreateComObject(CLASS_REB) as IREB;
end;

class function CoREB.CreateRemote(const MachineName: string): IREB;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_REB) as IREB;
end;

procedure TREB.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{B2B72981-6CA4-4EF8-8C79-97A6DEADBD28}';
    IntfIID:   '{7F83A8A9-142D-4657-BCED-270B0D922303}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TREB.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IREB;
  end;
end;

procedure TREB.ConnectTo(svrIntf: IREB);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TREB.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TREB.GetDefaultInterface: IREB;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TREB.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TREB.Destroy;
begin
  inherited Destroy;
end;

function TREB.Get_Sachbearbeiter: WideString;
begin
  Result := DefaultInterface.Sachbearbeiter;
end;

function TREB.Get_Valutadatum: TDateTime;
begin
  Result := DefaultInterface.Valutadatum;
end;

function TREB.Get_Skontofaktor: Double;
begin
  Result := DefaultInterface.Skontofaktor;
end;

function TREB.Get_Zahlart: EZahlarten;
begin
  Result := DefaultInterface.Zahlart;
end;

function TREB.Get_ExportID: Integer;
begin
  Result := DefaultInterface.ExportID;
end;

function TREB.Get_FreiUserName: WideString;
begin
  Result := DefaultInterface.FreiUserName;
end;

function TREB.Get_FreiUserDatum: TDateTime;
begin
  Result := DefaultInterface.FreiUserDatum;
end;

function TREB.Get_BuchUserName: WideString;
begin
  Result := DefaultInterface.BuchUserName;
end;

function TREB.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TREB.Kontierung: IKontierung;
begin
  Result := DefaultInterface.Kontierung;
end;

function TREB.USt: IUSt;
begin
  Result := DefaultInterface.USt;
end;

function TREB.Kurs: IKurs;
begin
  Result := DefaultInterface.Kurs;
end;

function TREB.Zahlkondition: IZahlkondition;
begin
  Result := DefaultInterface.Zahlkondition;
end;

class function CoOrt.Create: IOrt;
begin
  Result := CreateComObject(CLASS_Ort) as IOrt;
end;

class function CoOrt.CreateRemote(const MachineName: string): IOrt;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Ort) as IOrt;
end;

procedure TOrt.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{77CDFBA5-921B-45D2-8110-90462BA6D9CB}';
    IntfIID:   '{0D547D43-D232-4538-A1F8-BE47F281D4BE}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TOrt.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IOrt;
  end;
end;

procedure TOrt.ConnectTo(svrIntf: IOrt);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TOrt.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TOrt.GetDefaultInterface: IOrt;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TOrt.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TOrt.Destroy;
begin
  inherited Destroy;
end;

function TOrt.Get_PLZ: Integer;
begin
  Result := DefaultInterface.PLZ;
end;

procedure TOrt.Set_PLZ(Value: Integer);
begin
  DefaultInterface.PLZ := Value;
end;

function TOrt.Get_Bezeichnung: WideString;
begin
  Result := DefaultInterface.Bezeichnung;
end;

function TOrt.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoLizenz.Create: ILizenz;
begin
  Result := CreateComObject(CLASS_Lizenz) as ILizenz;
end;

class function CoLizenz.CreateRemote(const MachineName: string): ILizenz;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Lizenz) as ILizenz;
end;

procedure TLizenz.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{A0416A15-4E1D-46AE-BF4B-859587A74C40}';
    IntfIID:   '{C8017AD3-C3CE-473C-994C-2AF4553D644B}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TLizenz.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ILizenz;
  end;
end;

procedure TLizenz.ConnectTo(svrIntf: ILizenz);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TLizenz.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TLizenz.GetDefaultInterface: ILizenz;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TLizenz.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TLizenz.Destroy;
begin
  inherited Destroy;
end;

function TLizenz.Get_SerNr: Integer;
begin
  Result := DefaultInterface.SerNr;
end;

function TLizenz.Get_HdlNr: Integer;
begin
  Result := DefaultInterface.HdlNr;
end;

function TLizenz.Get_CodeFrist: Integer;
begin
  Result := DefaultInterface.CodeFrist;
end;

function TLizenz.Get_Erstelldatum: TDateTime;
begin
  Result := DefaultInterface.Erstelldatum;
end;

function TLizenz.Get_AnzMandanten: Integer;
begin
  Result := DefaultInterface.AnzMandanten;
end;

function TLizenz.Get_AnzBankBew: Integer;
begin
  Result := DefaultInterface.AnzBankBew;
end;

function TLizenz.Get_AnzStationen: Integer;
begin
  Result := DefaultInterface.AnzStationen;
end;

function TLizenz.Get_Lizenztext: WideString;
begin
  Result := DefaultInterface.Lizenztext;
end;

function TLizenz.Get_IsDemoversion: WordBool;
begin
  Result := DefaultInterface.IsDemoversion;
end;

function TLizenz.Get_Versionsnummer: Integer;
begin
  Result := DefaultInterface.Versionsnummer;
end;

function TLizenz.Get_Modul(modTyp: EModule): WordBool;
begin
  Result := DefaultInterface.Modul[modTyp];
end;

function TLizenz.Get_Modulbezeichnung(modTyp: EModule): WideString;
begin
  Result := DefaultInterface.Modulbezeichnung[modTyp];
end;

function TLizenz.Get_ModulNutzbarBis(modTyp: EModule): TDateTime;
begin
  Result := DefaultInterface.ModulNutzbarBis[modTyp];
end;

function TLizenz.Get_AnzBIGStationen: Integer;
begin
  Result := DefaultInterface.AnzBIGStationen;
end;

function TLizenz.Get_webREBUser: Integer;
begin
  Result := DefaultInterface.webREBUser;
end;

function TLizenz.Get_webREBWorkflow: Integer;
begin
  Result := DefaultInterface.webREBWorkflow;
end;

class function CoCmdBuchen.Create: ICmdBuchen;
begin
  Result := CreateComObject(CLASS_CmdBuchen) as ICmdBuchen;
end;

class function CoCmdBuchen.CreateRemote(const MachineName: string): ICmdBuchen;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CmdBuchen) as ICmdBuchen;
end;

procedure TCmdBuchen.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{45F56E9A-BD90-450C-BC71-3CBF3CF556D5}';
    IntfIID:   '{CD7D8E7E-4765-4556-9746-7280DE64FE5E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCmdBuchen.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICmdBuchen;
  end;
end;

procedure TCmdBuchen.ConnectTo(svrIntf: ICmdBuchen);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCmdBuchen.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCmdBuchen.GetDefaultInterface: ICmdBuchen;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TCmdBuchen.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCmdBuchen.Destroy;
begin
  inherited Destroy;
end;

function TCmdBuchen.Get_CmdTyp: ECmdTypen;
begin
  Result := DefaultInterface.CmdTyp;
end;

function TCmdBuchen.Get_AsString: WideString;
begin
  Result := DefaultInterface.AsString;
end;

function TCmdBuchen.Get_Betrag: Currency;
begin
  Result := DefaultInterface.Betrag;
end;

procedure TCmdBuchen.Set_Betrag(Value: Currency);
begin
  DefaultInterface.Betrag := Value;
end;

function TCmdBuchen.Get_Konto: Integer;
begin
  Result := DefaultInterface.Konto;
end;

procedure TCmdBuchen.Set_Konto(Value: Integer);
begin
  DefaultInterface.Konto := Value;
end;

function TCmdBuchen.Get_UStArt: EUStArten;
begin
  Result := DefaultInterface.UStArt;
end;

procedure TCmdBuchen.Set_UStArt(Value: EUStArten);
begin
  DefaultInterface.UStArt := Value;
end;

function TCmdBuchen.Get_UStSchl: Integer;
begin
  Result := DefaultInterface.UStSchl;
end;

procedure TCmdBuchen.Set_UStSchl(Value: Integer);
begin
  DefaultInterface.UStSchl := Value;
end;

function TCmdBuchen.Get_GegKonto: Integer;
begin
  Result := DefaultInterface.GegKonto;
end;

procedure TCmdBuchen.Set_GegKonto(Value: Integer);
begin
  DefaultInterface.GegKonto := Value;
end;

function TCmdBuchen.Get_GegUStArt: EUStArten;
begin
  Result := DefaultInterface.GegUStArt;
end;

procedure TCmdBuchen.Set_GegUStArt(Value: EUStArten);
begin
  DefaultInterface.GegUStArt := Value;
end;

function TCmdBuchen.Get_GegUStSchl: Integer;
begin
  Result := DefaultInterface.GegUStSchl;
end;

procedure TCmdBuchen.Set_GegUStSchl(Value: Integer);
begin
  DefaultInterface.GegUStSchl := Value;
end;

function TCmdBuchen.Get_Belegnummer1: WideString;
begin
  Result := DefaultInterface.Belegnummer1;
end;

procedure TCmdBuchen.Set_Belegnummer1(const Value: WideString);
begin
  DefaultInterface.Belegnummer1 := Value;
end;

function TCmdBuchen.Get_Belegnummer2: WideString;
begin
  Result := DefaultInterface.Belegnummer2;
end;

procedure TCmdBuchen.Set_Belegnummer2(const Value: WideString);
begin
  DefaultInterface.Belegnummer2 := Value;
end;

function TCmdBuchen.Get_Buchtext: WideString;
begin
  Result := DefaultInterface.Buchtext;
end;

procedure TCmdBuchen.Set_Buchtext(const Value: WideString);
begin
  DefaultInterface.Buchtext := Value;
end;

function TCmdBuchen.Get_Belegdatum: TDateTime;
begin
  Result := DefaultInterface.Belegdatum;
end;

procedure TCmdBuchen.Set_Belegdatum(Value: TDateTime);
begin
  DefaultInterface.Belegdatum := Value;
end;

function TCmdBuchen.Get_Valutadatum: TDateTime;
begin
  Result := DefaultInterface.Valutadatum;
end;

procedure TCmdBuchen.Set_Valutadatum(Value: TDateTime);
begin
  DefaultInterface.Valutadatum := Value;
end;

function TCmdBuchen.Get_Zahlart: EZahlarten;
begin
  Result := DefaultInterface.Zahlart;
end;

procedure TCmdBuchen.Set_Zahlart(Value: EZahlarten);
begin
  DefaultInterface.Zahlart := Value;
end;

function TCmdBuchen.Get_Zahlkonditionen: IZahlkondition;
begin
  Result := DefaultInterface.Zahlkonditionen;
end;

procedure TCmdBuchen.Set_Zahlkonditionen(const Value: IZahlkondition);
begin
  DefaultInterface.Zahlkonditionen := Value;
end;

function TCmdBuchen.Get_Wertstellungsdatum: TDateTime;
begin
  Result := DefaultInterface.Wertstellungsdatum;
end;

procedure TCmdBuchen.Set_Wertstellungsdatum(Value: TDateTime);
begin
  DefaultInterface.Wertstellungsdatum := Value;
end;

function TCmdBuchen.Get_Reisedatum: TDateTime;
begin
  Result := DefaultInterface.Reisedatum;
end;

procedure TCmdBuchen.Set_Reisedatum(Value: TDateTime);
begin
  DefaultInterface.Reisedatum := Value;
end;

function TCmdBuchen.Get_Waehrung: WideString;
begin
  Result := DefaultInterface.Waehrung;
end;

procedure TCmdBuchen.Set_Waehrung(const Value: WideString);
begin
  DefaultInterface.Waehrung := Value;
end;

function TCmdBuchen.Get_Tageskurs: Double;
begin
  Result := DefaultInterface.Tageskurs;
end;

procedure TCmdBuchen.Set_Tageskurs(Value: Double);
begin
  DefaultInterface.Tageskurs := Value;
end;

function TCmdBuchen.Get_Memotext: WideString;
begin
  Result := DefaultInterface.Memotext;
end;

procedure TCmdBuchen.Set_Memotext(const Value: WideString);
begin
  DefaultInterface.Memotext := Value;
end;

function TCmdBuchen.Get_OpAutomatik: WordBool;
begin
  Result := DefaultInterface.OpAutomatik;
end;

procedure TCmdBuchen.Set_OpAutomatik(Value: WordBool);
begin
  DefaultInterface.OpAutomatik := Value;
end;

function TCmdBuchen.Get_KLRAutomatik: WordBool;
begin
  Result := DefaultInterface.KLRAutomatik;
end;

procedure TCmdBuchen.Set_KLRAutomatik(Value: WordBool);
begin
  DefaultInterface.KLRAutomatik := Value;
end;

function TCmdBuchen.Get_UStSatz: Double;
begin
  Result := DefaultInterface.UStSatz;
end;

procedure TCmdBuchen.Set_UStSatz(Value: Double);
begin
  DefaultInterface.UStSatz := Value;
end;

function TCmdBuchen.Get_GegUStSatz: Double;
begin
  Result := DefaultInterface.GegUStSatz;
end;

procedure TCmdBuchen.Set_GegUStSatz(Value: Double);
begin
  DefaultInterface.GegUStSatz := Value;
end;

procedure TCmdBuchen.Clear;
begin
  DefaultInterface.Clear;
end;

function TCmdBuchen.CmdPosten(Konto: Integer): ICmdPosten;
begin
  Result := DefaultInterface.CmdPosten(Konto);
end;

function TCmdBuchen.CmdKLR(Konto: Integer): ICmdKLR;
begin
  Result := DefaultInterface.CmdKLR(Konto);
end;

class function CoCmdPosten.Create: ICmdPosten;
begin
  Result := CreateComObject(CLASS_CmdPosten) as ICmdPosten;
end;

class function CoCmdPosten.CreateRemote(const MachineName: string): ICmdPosten;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CmdPosten) as ICmdPosten;
end;

procedure TCmdPosten.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{93CAEB71-617B-4CBA-ADC0-7FF056B40FDE}';
    IntfIID:   '{9780F9D4-24F1-453D-A396-04A52AB2ED11}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCmdPosten.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICmdPosten;
  end;
end;

procedure TCmdPosten.ConnectTo(svrIntf: ICmdPosten);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCmdPosten.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCmdPosten.GetDefaultInterface: ICmdPosten;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TCmdPosten.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCmdPosten.Destroy;
begin
  inherited Destroy;
end;

function TCmdPosten.Get_Betrag: Currency;
begin
  Result := DefaultInterface.Betrag;
end;

procedure TCmdPosten.Set_Betrag(Value: Currency);
begin
  DefaultInterface.Betrag := Value;
end;

function TCmdPosten.Get_OpArt: EOpArten;
begin
  Result := DefaultInterface.OpArt;
end;

procedure TCmdPosten.Set_OpArt(Value: EOpArten);
begin
  DefaultInterface.OpArt := Value;
end;

function TCmdPosten.Get_Konto: Integer;
begin
  Result := DefaultInterface.Konto;
end;

procedure TCmdPosten.Set_Konto(Value: Integer);
begin
  DefaultInterface.Konto := Value;
end;

function TCmdPosten.Get_GegKonto: Integer;
begin
  Result := DefaultInterface.GegKonto;
end;

procedure TCmdPosten.Set_GegKonto(Value: Integer);
begin
  DefaultInterface.GegKonto := Value;
end;

function TCmdPosten.Get_GegUStArt: EUStArten;
begin
  Result := DefaultInterface.GegUStArt;
end;

procedure TCmdPosten.Set_GegUStArt(Value: EUStArten);
begin
  DefaultInterface.GegUStArt := Value;
end;

function TCmdPosten.Get_GegUStSchl: Integer;
begin
  Result := DefaultInterface.GegUStSchl;
end;

procedure TCmdPosten.Set_GegUStSchl(Value: Integer);
begin
  DefaultInterface.GegUStSchl := Value;
end;

function TCmdPosten.Get_Belegnummer1: WideString;
begin
  Result := DefaultInterface.Belegnummer1;
end;

procedure TCmdPosten.Set_Belegnummer1(const Value: WideString);
begin
  DefaultInterface.Belegnummer1 := Value;
end;

function TCmdPosten.Get_Belegnummer2: WideString;
begin
  Result := DefaultInterface.Belegnummer2;
end;

procedure TCmdPosten.Set_Belegnummer2(const Value: WideString);
begin
  DefaultInterface.Belegnummer2 := Value;
end;

function TCmdPosten.Get_Buchtext: WideString;
begin
  Result := DefaultInterface.Buchtext;
end;

procedure TCmdPosten.Set_Buchtext(const Value: WideString);
begin
  DefaultInterface.Buchtext := Value;
end;

function TCmdPosten.Get_Belegdatum: TDateTime;
begin
  Result := DefaultInterface.Belegdatum;
end;

procedure TCmdPosten.Set_Belegdatum(Value: TDateTime);
begin
  DefaultInterface.Belegdatum := Value;
end;

function TCmdPosten.Get_Valutadatum: TDateTime;
begin
  Result := DefaultInterface.Valutadatum;
end;

procedure TCmdPosten.Set_Valutadatum(Value: TDateTime);
begin
  DefaultInterface.Valutadatum := Value;
end;

function TCmdPosten.Get_Zahlart: EZahlarten;
begin
  Result := DefaultInterface.Zahlart;
end;

procedure TCmdPosten.Set_Zahlart(Value: EZahlarten);
begin
  DefaultInterface.Zahlart := Value;
end;

function TCmdPosten.Get_Zahlkonditionen: IZahlkondition;
begin
  Result := DefaultInterface.Zahlkonditionen;
end;

function TCmdPosten.Get_Wechsel: Integer;
begin
  Result := DefaultInterface.Wechsel;
end;

procedure TCmdPosten.Set_Wechsel(Value: Integer);
begin
  DefaultInterface.Wechsel := Value;
end;

function TCmdPosten.Get_Skontofaehig: Currency;
begin
  Result := DefaultInterface.Skontofaehig;
end;

procedure TCmdPosten.Set_Skontofaehig(Value: Currency);
begin
  DefaultInterface.Skontofaehig := Value;
end;

function TCmdPosten.Get_Skontobetrag: Currency;
begin
  Result := DefaultInterface.Skontobetrag;
end;

procedure TCmdPosten.Set_Skontobetrag(Value: Currency);
begin
  DefaultInterface.Skontobetrag := Value;
end;

function TCmdPosten.Get_Zugeordnet: Integer;
begin
  Result := DefaultInterface.Zugeordnet;
end;

procedure TCmdPosten.Set_Zugeordnet(Value: Integer);
begin
  DefaultInterface.Zugeordnet := Value;
end;

function TCmdPosten.Get_Memotext: WideString;
begin
  Result := DefaultInterface.Memotext;
end;

procedure TCmdPosten.Set_Memotext(const Value: WideString);
begin
  DefaultInterface.Memotext := Value;
end;

function TCmdPosten.Get_CmdTyp: ECmdTypen;
begin
  Result := DefaultInterface.CmdTyp;
end;

function TCmdPosten.Get_AsString: WideString;
begin
  Result := DefaultInterface.AsString;
end;

procedure TCmdPosten.Clear;
begin
  DefaultInterface.Clear;
end;

class function CoCmdKLR.Create: ICmdKLR;
begin
  Result := CreateComObject(CLASS_CmdKLR) as ICmdKLR;
end;

class function CoCmdKLR.CreateRemote(const MachineName: string): ICmdKLR;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CmdKLR) as ICmdKLR;
end;

procedure TCmdKLR.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{197492FA-BB73-4457-B87A-17E5A9EBAC64}';
    IntfIID:   '{F8580485-4A78-49C2-9766-C4BD6A49C3DB}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCmdKLR.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ICmdKLR;
  end;
end;

procedure TCmdKLR.ConnectTo(svrIntf: ICmdKLR);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCmdKLR.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCmdKLR.GetDefaultInterface: ICmdKLR;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TCmdKLR.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCmdKLR.Destroy;
begin
  inherited Destroy;
end;

function TCmdKLR.Get_CmdTyp: ECmdTypen;
begin
  Result := DefaultInterface.CmdTyp;
end;

function TCmdKLR.Get_AsString: WideString;
begin
  Result := DefaultInterface.AsString;
end;

function TCmdKLR.Get_Betrag: Currency;
begin
  Result := DefaultInterface.Betrag;
end;

procedure TCmdKLR.Set_Betrag(Value: Currency);
begin
  DefaultInterface.Betrag := Value;
end;

function TCmdKLR.Get_FixVar: EKostentypen;
begin
  Result := DefaultInterface.FixVar;
end;

procedure TCmdKLR.Set_FixVar(Value: EKostentypen);
begin
  DefaultInterface.FixVar := Value;
end;

function TCmdKLR.Get_Kostenstelle: Integer;
begin
  Result := DefaultInterface.Kostenstelle;
end;

procedure TCmdKLR.Set_Kostenstelle(Value: Integer);
begin
  DefaultInterface.Kostenstelle := Value;
end;

function TCmdKLR.Get_Kostentraeger: Integer;
begin
  Result := DefaultInterface.Kostentraeger;
end;

procedure TCmdKLR.Set_Kostentraeger(Value: Integer);
begin
  DefaultInterface.Kostentraeger := Value;
end;

function TCmdKLR.Get_Kostenart: Integer;
begin
  Result := DefaultInterface.Kostenart;
end;

procedure TCmdKLR.Set_Kostenart(Value: Integer);
begin
  DefaultInterface.Kostenart := Value;
end;

function TCmdKLR.Get_Sachkonto: Integer;
begin
  Result := DefaultInterface.Sachkonto;
end;

procedure TCmdKLR.Set_Sachkonto(Value: Integer);
begin
  DefaultInterface.Sachkonto := Value;
end;

function TCmdKLR.Get_SolHab: Integer;
begin
  Result := DefaultInterface.SolHab;
end;

procedure TCmdKLR.Set_SolHab(Value: Integer);
begin
  DefaultInterface.SolHab := Value;
end;

function TCmdKLR.Get_GegKonto: Integer;
begin
  Result := DefaultInterface.GegKonto;
end;

procedure TCmdKLR.Set_GegKonto(Value: Integer);
begin
  DefaultInterface.GegKonto := Value;
end;

function TCmdKLR.Get_Belegnummer1: WideString;
begin
  Result := DefaultInterface.Belegnummer1;
end;

procedure TCmdKLR.Set_Belegnummer1(const Value: WideString);
begin
  DefaultInterface.Belegnummer1 := Value;
end;

function TCmdKLR.Get_Belegnummer2: WideString;
begin
  Result := DefaultInterface.Belegnummer2;
end;

procedure TCmdKLR.Set_Belegnummer2(const Value: WideString);
begin
  DefaultInterface.Belegnummer2 := Value;
end;

function TCmdKLR.Get_Buchtext: WideString;
begin
  Result := DefaultInterface.Buchtext;
end;

procedure TCmdKLR.Set_Buchtext(const Value: WideString);
begin
  DefaultInterface.Buchtext := Value;
end;

function TCmdKLR.Get_Belegdatum: TDateTime;
begin
  Result := DefaultInterface.Belegdatum;
end;

procedure TCmdKLR.Set_Belegdatum(Value: TDateTime);
begin
  DefaultInterface.Belegdatum := Value;
end;

function TCmdKLR.Get_Art: Integer;
begin
  Result := DefaultInterface.Art;
end;

procedure TCmdKLR.Set_Art(Value: Integer);
begin
  DefaultInterface.Art := Value;
end;

function TCmdKLR.Get_Gruppe: Integer;
begin
  Result := DefaultInterface.Gruppe;
end;

procedure TCmdKLR.Set_Gruppe(Value: Integer);
begin
  DefaultInterface.Gruppe := Value;
end;

procedure TCmdKLR.Clear;
begin
  DefaultInterface.Clear;
end;

class function CoKreditversicherung.Create: IKreditversicherung;
begin
  Result := CreateComObject(CLASS_Kreditversicherung) as IKreditversicherung;
end;

class function CoKreditversicherung.CreateRemote(const MachineName: string): IKreditversicherung;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Kreditversicherung) as IKreditversicherung;
end;

procedure TKreditversicherung.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{10708077-6D33-43AB-ACD0-76822E928A44}';
    IntfIID:   '{E2ECF706-2C7D-481A-A728-604B3D4A83DB}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKreditversicherung.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKreditversicherung;
  end;
end;

procedure TKreditversicherung.ConnectTo(svrIntf: IKreditversicherung);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKreditversicherung.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKreditversicherung.GetDefaultInterface: IKreditversicherung;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKreditversicherung.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKreditversicherung.Destroy;
begin
  inherited Destroy;
end;

function TKreditversicherung.Get_Limit1: Currency;
begin
  Result := DefaultInterface.Limit1;
end;

function TKreditversicherung.Get_Limit2: Currency;
begin
  Result := DefaultInterface.Limit2;
end;

function TKreditversicherung.Get_LimitAb: TDateTime;
begin
  Result := DefaultInterface.LimitAb;
end;

function TKreditversicherung.Get_Typ: Integer;
begin
  Result := DefaultInterface.Typ;
end;

function TKreditversicherung.Get_Ziel: Integer;
begin
  Result := DefaultInterface.Ziel;
end;

function TKreditversicherung.Get_Status: Integer;
begin
  Result := DefaultInterface.Status;
end;

function TKreditversicherung.Get_Nummer: WideString;
begin
  Result := DefaultInterface.Nummer;
end;

function TKreditversicherung.Get_VersicherungNr: Integer;
begin
  Result := DefaultInterface.VersicherungNr;
end;

function TKreditversicherung.Get_SummeOP: Currency;
begin
  Result := DefaultInterface.SummeOP;
end;

function TKreditversicherung.Get_SummeWechsel: Currency;
begin
  Result := DefaultInterface.SummeWechsel;
end;

function TKreditversicherung.Get_RE_Belegnummer: WideString;
begin
  Result := DefaultInterface.RE_Belegnummer;
end;

function TKreditversicherung.Get_RE_Belegdatum: TDateTime;
begin
  Result := DefaultInterface.RE_Belegdatum;
end;

function TKreditversicherung.Get_RE_Alter: Integer;
begin
  Result := DefaultInterface.RE_Alter;
end;

function TKreditversicherung.Get_IsDubios: WordBool;
begin
  Result := DefaultInterface.IsDubios;
end;

function TKreditversicherung.Get_IsVerklagt: WordBool;
begin
  Result := DefaultInterface.IsVerklagt;
end;

function TKreditversicherung.Get_IsInkasso: WordBool;
begin
  Result := DefaultInterface.IsInkasso;
end;

function TKreditversicherung.Get_IsKonkurs: WordBool;
begin
  Result := DefaultInterface.IsKonkurs;
end;

function TKreditversicherung.Get_IsWechsel: WordBool;
begin
  Result := DefaultInterface.IsWechsel;
end;

function TKreditversicherung.Get_InternesLimit: Currency;
begin
  Result := DefaultInterface.InternesLimit;
end;

class function CoArchiv.Create: IArchiv;
begin
  Result := CreateComObject(CLASS_Archiv) as IArchiv;
end;

class function CoArchiv.CreateRemote(const MachineName: string): IArchiv;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Archiv) as IArchiv;
end;

procedure TArchiv.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{6B4F7DCE-C47F-496C-8C94-F2BE617B8303}';
    IntfIID:   '{8A5D903D-8898-4A58-AE69-0E767BE5F576}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TArchiv.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IArchiv;
  end;
end;

procedure TArchiv.ConnectTo(svrIntf: IArchiv);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TArchiv.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TArchiv.GetDefaultInterface: IArchiv;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TArchiv.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TArchiv.Destroy;
begin
  inherited Destroy;
end;

function TArchiv.Get_Mandant: Integer;
begin
  Result := DefaultInterface.Mandant;
end;

function TArchiv.Get_Wirtschaftsjahr: Integer;
begin
  Result := DefaultInterface.Wirtschaftsjahr;
end;

function TArchiv.Get_Journalzeile: Integer;
begin
  Result := DefaultInterface.Journalzeile;
end;

function TArchiv.Get_Barcode: WideString;
begin
  Result := DefaultInterface.Barcode;
end;

function TArchiv.Get_Buchdatum: TDateTime;
begin
  Result := DefaultInterface.Buchdatum;
end;

function TArchiv.Get_Konto: Integer;
begin
  Result := DefaultInterface.Konto;
end;

function TArchiv.Get_GegKonto: Integer;
begin
  Result := DefaultInterface.GegKonto;
end;

function TArchiv.Get_Betrag: Currency;
begin
  Result := DefaultInterface.Betrag;
end;

function TArchiv.Get_Belegdatum: TDateTime;
begin
  Result := DefaultInterface.Belegdatum;
end;

function TArchiv.Get_Belegnummer1: WideString;
begin
  Result := DefaultInterface.Belegnummer1;
end;

function TArchiv.Get_Belegnummer2: WideString;
begin
  Result := DefaultInterface.Belegnummer2;
end;

function TArchiv.Get_Buchtext: WideString;
begin
  Result := DefaultInterface.Buchtext;
end;

function TArchiv.Get_DokumentID: WideString;
begin
  Result := DefaultInterface.DokumentID;
end;

function TArchiv.Get_Waehrungsbetrag: Currency;
begin
  Result := DefaultInterface.Waehrungsbetrag;
end;

function TArchiv.Get_Waehrungskurs: Double;
begin
  Result := DefaultInterface.Waehrungskurs;
end;

function TArchiv.Get_Memotext: WideString;
begin
  Result := DefaultInterface.Memotext;
end;

function TArchiv.Get_Benutzer: WideString;
begin
  Result := DefaultInterface.Benutzer;
end;

function TArchiv.Get_FullBarcode: WideString;
begin
  Result := DefaultInterface.FullBarcode;
end;

function TArchiv.Get_BarcodeJahr: Integer;
begin
  Result := DefaultInterface.BarcodeJahr;
end;

function TArchiv.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoArchivierung.Create: IArchivierung;
begin
  Result := CreateComObject(CLASS_Archivierung) as IArchivierung;
end;

class function CoArchivierung.CreateRemote(const MachineName: string): IArchivierung;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Archivierung) as IArchivierung;
end;

procedure TArchivierung.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{38358A85-87CD-461D-ACB7-013FAA59654F}';
    IntfIID:   '{630829FB-5738-4A10-BC7B-9EF47C2330ED}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TArchivierung.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IArchivierung;
  end;
end;

procedure TArchivierung.ConnectTo(svrIntf: IArchivierung);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TArchivierung.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TArchivierung.GetDefaultInterface: IArchivierung;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TArchivierung.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TArchivierung.Destroy;
begin
  inherited Destroy;
end;

function TArchivierung.Get_NaechsterBarcode: Int64;
begin
  Result := DefaultInterface.NaechsterBarcode;
end;

procedure TArchivierung.Set_NaechsterBarcode(Value: Int64);
begin
  DefaultInterface.NaechsterBarcode := Value;
end;

function TArchivierung.Archiv(ArchivTyp: EArchivTypen): IArchiv;
begin
  Result := DefaultInterface.Archiv(ArchivTyp);
end;

function TArchivierung.Barcodefinden(const aBarCode: WideString): IArchiv;
begin
  Result := DefaultInterface.Barcodefinden(aBarCode);
end;

function TArchivierung.Belegarchiviert(const Barcode: WideString; JrnZl: Integer; 
                                       const DocID: WideString; out ErrText: WideString): WordBool;
begin
  Result := DefaultInterface.Belegarchiviert(Barcode, JrnZl, DocID, ErrText);
end;

function TArchivierung.Barcodesuchen(ArchivTyp: EArchivTypen; const Barcode: WideString): IArchiv;
begin
  Result := DefaultInterface.Barcodesuchen(ArchivTyp, Barcode);
end;

function TArchivierung.ExtractBarcode(const Image: WideString; const Extension: WideString): WideString;
begin
  Result := DefaultInterface.ExtractBarcode(Image, Extension);
end;

class function CoBgMw.Create: IBgMw;
begin
  Result := CreateComObject(CLASS_BgMw) as IBgMw;
end;

class function CoBgMw.CreateRemote(const MachineName: string): IBgMw;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BgMw) as IBgMw;
end;

procedure TBgMw.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0BA927B0-DC9C-4F05-8179-3543FA55A773}';
    IntfIID:   '{5288A160-018C-4480-AF36-40FC8C7E93CA}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBgMw.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBgMw;
  end;
end;

procedure TBgMw.ConnectTo(svrIntf: IBgMw);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBgMw.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBgMw.GetDefaultInterface: IBgMw;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TBgMw.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBgMw.Destroy;
begin
  inherited Destroy;
end;

function TBgMw.Get_BGNr: Integer;
begin
  Result := DefaultInterface.BGNr;
end;

function TBgMw.Get_KStTrNr: Integer;
begin
  Result := DefaultInterface.KStTrNr;
end;

function TBgMw.Get_KArtNr: Integer;
begin
  Result := DefaultInterface.KArtNr;
end;

function TBgMw.Get_Bezugsgroesse: IBezugsgroesse;
begin
  Result := DefaultInterface.Bezugsgroesse;
end;

function TBgMw.Monatswert(Monat: Integer): Double;
begin
  Result := DefaultInterface.Monatswert(Monat);
end;

function TBgMw.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoBatchScript.Create: IBatchScript;
begin
  Result := CreateComObject(CLASS_BatchScript) as IBatchScript;
end;

class function CoBatchScript.CreateRemote(const MachineName: string): IBatchScript;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BatchScript) as IBatchScript;
end;

procedure TBatchScript.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2F153B30-416F-4EB5-BC5E-D4DB6F02EDC0}';
    IntfIID:   '{413A0B81-D980-4017-A58E-E604159136DB}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBatchScript.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBatchScript;
  end;
end;

procedure TBatchScript.ConnectTo(svrIntf: IBatchScript);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBatchScript.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBatchScript.GetDefaultInterface: IBatchScript;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TBatchScript.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBatchScript.Destroy;
begin
  inherited Destroy;
end;

function TBatchScript.Get_Zeile: Integer;
begin
  Result := DefaultInterface.Zeile;
end;

function TBatchScript.Get_Status: Integer;
begin
  Result := DefaultInterface.Status;
end;

function TBatchScript.Get_Mandant: Integer;
begin
  Result := DefaultInterface.Mandant;
end;

function TBatchScript.Get_Buchdatum: TDateTime;
begin
  Result := DefaultInterface.Buchdatum;
end;

function TBatchScript.Get_Dateiname: WideString;
begin
  Result := DefaultInterface.Dateiname;
end;

function TBatchScript.Get_Uebernahme: TDateTime;
begin
  Result := DefaultInterface.Uebernahme;
end;

function TBatchScript.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoXML.Create: IXML;
begin
  Result := CreateComObject(CLASS_XML) as IXML;
end;

class function CoXML.CreateRemote(const MachineName: string): IXML;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XML) as IXML;
end;

procedure TXML.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{3C3E8E7D-5152-435D-A4A3-6619D1B1D33B}';
    IntfIID:   '{D18DD702-3327-4A56-9E99-6232AD16DEFC}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TXML.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IXML;
  end;
end;

procedure TXML.ConnectTo(svrIntf: IXML);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TXML.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TXML.GetDefaultInterface: IXML;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TXML.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TXML.Destroy;
begin
  inherited Destroy;
end;

function TXML.Get_OpenParams: WideString;
begin
  Result := DefaultInterface.OpenParams;
end;

procedure TXML.Set_OpenParams(const Value: WideString);
begin
  DefaultInterface.OpenParams := Value;
end;

function TXML.GetData(Value: EXMLTableTypen): WideString;
begin
  Result := DefaultInterface.GetData(Value);
end;

class function CoDCUebFiles.Create: IDCUebFiles;
begin
  Result := CreateComObject(CLASS_DCUebFiles) as IDCUebFiles;
end;

class function CoDCUebFiles.CreateRemote(const MachineName: string): IDCUebFiles;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DCUebFiles) as IDCUebFiles;
end;

procedure TDCUebFiles.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{E1C1F422-0DA6-4150-8645-657C2720E116}';
    IntfIID:   '{E338E8EE-237E-4F01-B1A4-E463633785FB}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDCUebFiles.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDCUebFiles;
  end;
end;

procedure TDCUebFiles.ConnectTo(svrIntf: IDCUebFiles);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDCUebFiles.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDCUebFiles.GetDefaultInterface: IDCUebFiles;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TDCUebFiles.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TDCUebFiles.Destroy;
begin
  inherited Destroy;
end;

function TDCUebFiles.Get_Betrag: Currency;
begin
  Result := DefaultInterface.Betrag;
end;

function TDCUebFiles.Get_SollKonto: Integer;
begin
  Result := DefaultInterface.SollKonto;
end;

function TDCUebFiles.Get_HabenKonto: Integer;
begin
  Result := DefaultInterface.HabenKonto;
end;

function TDCUebFiles.Get_Beleg1: WideString;
begin
  Result := DefaultInterface.Beleg1;
end;

function TDCUebFiles.Get_Beleg2: WideString;
begin
  Result := DefaultInterface.Beleg2;
end;

function TDCUebFiles.Get_Buchtext: WideString;
begin
  Result := DefaultInterface.Buchtext;
end;

function TDCUebFiles.Get_Belegdatum: TDateTime;
begin
  Result := DefaultInterface.Belegdatum;
end;

function TDCUebFiles.Get_Dateiname: WideString;
begin
  Result := DefaultInterface.Dateiname;
end;

function TDCUebFiles.Get_Erstellzeitpunkt: TDateTime;
begin
  Result := DefaultInterface.Erstellzeitpunkt;
end;

function TDCUebFiles.Get_Dateigroesse: Integer;
begin
  Result := DefaultInterface.Dateigroesse;
end;

function TDCUebFiles.Get_FileNummer: Integer;
begin
  Result := DefaultInterface.FileNummer;
end;

function TDCUebFiles.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoBgMwBeweg.Create: IBgBeweg;
begin
  Result := CreateComObject(CLASS_BgMwBeweg) as IBgBeweg;
end;

class function CoBgMwBeweg.CreateRemote(const MachineName: string): IBgBeweg;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BgMwBeweg) as IBgBeweg;
end;

procedure TBgMwBeweg.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5CB9E442-E37B-4B4B-B87E-D0225BA93C5A}';
    IntfIID:   '{AAF13146-6868-4063-8707-DF52B8744F02}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBgMwBeweg.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBgBeweg;
  end;
end;

procedure TBgMwBeweg.ConnectTo(svrIntf: IBgBeweg);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBgMwBeweg.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBgMwBeweg.GetDefaultInterface: IBgBeweg;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TBgMwBeweg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBgMwBeweg.Destroy;
begin
  inherited Destroy;
end;

function TBgMwBeweg.Get_BGNr: Integer;
begin
  Result := DefaultInterface.BGNr;
end;

function TBgMwBeweg.Get_KStTrNr: Integer;
begin
  Result := DefaultInterface.KStTrNr;
end;

function TBgMwBeweg.Get_Monatswert: Double;
begin
  Result := DefaultInterface.Monatswert;
end;

function TBgMwBeweg.Get_KArtNr: Integer;
begin
  Result := DefaultInterface.KArtNr;
end;

function TBgMwBeweg.Get_Bezugsgroesse: IBezugsgroesse;
begin
  Result := DefaultInterface.Bezugsgroesse;
end;

function TBgMwBeweg.Get_GegenKonto: Integer;
begin
  Result := DefaultInterface.GegenKonto;
end;

function TBgMwBeweg.Get_Monat: Integer;
begin
  Result := DefaultInterface.Monat;
end;

function TBgMwBeweg.Get_IsLast: WordBool;
begin
  Result := DefaultInterface.IsLast;
end;

function TBgMwBeweg.Get_Aufteilung: EBgAuftTypen;
begin
  Result := DefaultInterface.Aufteilung;
end;

function TBgMwBeweg.Get_GegenkontoTyp: EKontotypen;
begin
  Result := DefaultInterface.GegenkontoTyp;
end;

function TBgMwBeweg.Get_KStTrTyp: EKontotypen;
begin
  Result := DefaultInterface.KStTrTyp;
end;

function TBgMwBeweg.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoInventar.Create: IInventar;
begin
  Result := CreateComObject(CLASS_Inventar) as IInventar;
end;

class function CoInventar.CreateRemote(const MachineName: string): IInventar;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Inventar) as IInventar;
end;

procedure TInventar.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{DC568BF6-26B6-4F52-BB96-DEEF753C1DA6}';
    IntfIID:   '{C14070AC-C87D-4BD6-B0CD-188EC0E50E5A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TInventar.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IInventar;
  end;
end;

procedure TInventar.ConnectTo(svrIntf: IInventar);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TInventar.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TInventar.GetDefaultInterface: IInventar;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TInventar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TInventar.Destroy;
begin
  inherited Destroy;
end;

function TInventar.Get_Inventarnummer: WideString;
begin
  Result := DefaultInterface.Inventarnummer;
end;

procedure TInventar.Set_Inventarnummer(const Value: WideString);
begin
  DefaultInterface.Inventarnummer := Value;
end;

function TInventar.Get_WerkFilialNr: Integer;
begin
  Result := DefaultInterface.WerkFilialNr;
end;

function TInventar.Get_Standort: WideString;
begin
  Result := DefaultInterface.Standort;
end;

function TInventar.Get_Anzahl: Integer;
begin
  Result := DefaultInterface.Anzahl;
end;

function TInventar.Get_Seriennummer: WideString;
begin
  Result := DefaultInterface.Seriennummer;
end;

function TInventar.Get_Anlagedatum: TDateTime;
begin
  Result := DefaultInterface.Anlagedatum;
end;

function TInventar.Get_Aenderungsdatum: TDateTime;
begin
  Result := DefaultInterface.Aenderungsdatum;
end;

function TInventar.Get_Abgangsdatum: TDateTime;
begin
  Result := DefaultInterface.Abgangsdatum;
end;

function TInventar.Get_Wirtschaftsgutart: Integer;
begin
  Result := DefaultInterface.Wirtschaftsgutart;
end;

function TInventar.Get_Erinnerungswert: Currency;
begin
  Result := DefaultInterface.Erinnerungswert;
end;

function TInventar.Get_IsBebucht: WordBool;
begin
  Result := DefaultInterface.IsBebucht;
end;

function TInventar.Get_IsValid: WordBool;
begin
  Result := DefaultInterface.IsValid;
end;

function TInventar.Get_IsAbgegangen: WordBool;
begin
  Result := DefaultInterface.IsAbgegangen;
end;

function TInventar.Get_IsGenutzt: WordBool;
begin
  Result := DefaultInterface.IsGenutzt;
end;

function TInventar.Get_IsGebraucht: WordBool;
begin
  Result := DefaultInterface.IsGebraucht;
end;

function TInventar.Get_IsLeasing: WordBool;
begin
  Result := DefaultInterface.IsLeasing;
end;

function TInventar.Get_IsVerpachtet: WordBool;
begin
  Result := DefaultInterface.IsVerpachtet;
end;

function TInventar.Get_IsAfaAutomatisch: WordBool;
begin
  Result := DefaultInterface.IsAfaAutomatisch;
end;

function TInventar.Get_Kreditorennummer: Integer;
begin
  Result := DefaultInterface.Kreditorennummer;
end;

function TInventar.Get_Anschaffungsdatum: TDateTime;
begin
  Result := DefaultInterface.Anschaffungsdatum;
end;

function TInventar.Get_Waehrungsnummer: Integer;
begin
  Result := DefaultInterface.Waehrungsnummer;
end;

function TInventar.Get_IsFuehrungssatz: WordBool;
begin
  Result := DefaultInterface.IsFuehrungssatz;
end;

function TInventar.Get_InventurNr: Integer;
begin
  Result := DefaultInterface.InventurNr;
end;

function TInventar.Bezeichnung(Nr: Integer): WideString;
begin
  Result := DefaultInterface.Bezeichnung(Nr);
end;

function TInventar.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TInventar.GrpNummer(Nr: Integer): Integer;
begin
  Result := DefaultInterface.GrpNummer(Nr);
end;

function TInventar.Ebene(EbeneNr: EInventarebenen): IInventarebene;
begin
  Result := DefaultInterface.Ebene(EbeneNr);
end;

function TInventar.Status(EbeneNr: EInventarebenen; perDatum: TDateTime; simAfA: WordBool): IInventarstatus;
begin
  Result := DefaultInterface.Status(EbeneNr, perDatum, simAfA);
end;

function TInventar.KLRAnteil: IInventarKLRAnteil;
begin
  Result := DefaultInterface.KLRAnteil;
end;

function TInventar.Information(Nr: Integer): WideString;
begin
  Result := DefaultInterface.Information(Nr);
end;

function TInventar.Waehrung: IWaehrung;
begin
  Result := DefaultInterface.Waehrung;
end;

function TInventar.InventarJournal(EbeneNr: EInventarebenen): IInventarJournal;
begin
  Result := DefaultInterface.InventarJournal(EbeneNr);
end;

function TInventar.GrpDatumAb(Nr: Integer): TDateTime;
begin
  Result := DefaultInterface.GrpDatumAb(Nr);
end;

function TInventar.GrpDatumBis(Nr: Integer): TDateTime;
begin
  Result := DefaultInterface.GrpDatumBis(Nr);
end;

class function CoInventarebene.Create: IInventarebene;
begin
  Result := CreateComObject(CLASS_Inventarebene) as IInventarebene;
end;

class function CoInventarebene.CreateRemote(const MachineName: string): IInventarebene;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Inventarebene) as IInventarebene;
end;

procedure TInventarebene.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{38B256CB-9CE0-4D74-9CEC-978778AA52F3}';
    IntfIID:   '{1DCE2E2C-5880-4BCC-87BA-6BF04613295C}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TInventarebene.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IInventarebene;
  end;
end;

procedure TInventarebene.ConnectTo(svrIntf: IInventarebene);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TInventarebene.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TInventarebene.GetDefaultInterface: IInventarebene;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TInventarebene.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TInventarebene.Destroy;
begin
  inherited Destroy;
end;

function TInventarebene.Get_Fibukonto: Integer;
begin
  Result := DefaultInterface.Fibukonto;
end;

function TInventarebene.Get_AfAKonto: Integer;
begin
  Result := DefaultInterface.AfAKonto;
end;

function TInventarebene.Get_Nutzbeginn: TDateTime;
begin
  Result := DefaultInterface.Nutzbeginn;
end;

function TInventarebene.Get_NutzdauerJahre: Integer;
begin
  Result := DefaultInterface.NutzdauerJahre;
end;

function TInventarebene.Get_NutzdauerMonate: Integer;
begin
  Result := DefaultInterface.NutzdauerMonate;
end;

function TInventarebene.Get_AfAArtNr: Integer;
begin
  Result := DefaultInterface.AfAArtNr;
end;

function TInventarebene.Get_AfASchluessel: Integer;
begin
  Result := DefaultInterface.AfASchluessel;
end;

function TInventarebene.Get_Schichtfaktor: Currency;
begin
  Result := DefaultInterface.Schichtfaktor;
end;

function TInventarebene.Get_IsSonderAfA: WordBool;
begin
  Result := DefaultInterface.IsSonderAfA;
end;

function TInventarebene.Get_SonderAfaMaxProzent: Currency;
begin
  Result := DefaultInterface.SonderAfaMaxProzent;
end;

function TInventarebene.Get_IsVereinfachungsregel: WordBool;
begin
  Result := DefaultInterface.IsVereinfachungsregel;
end;

class function CoInventarstatus.Create: IInventarstatus;
begin
  Result := CreateComObject(CLASS_Inventarstatus) as IInventarstatus;
end;

class function CoInventarstatus.CreateRemote(const MachineName: string): IInventarstatus;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Inventarstatus) as IInventarstatus;
end;

procedure TInventarstatus.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{0BAE11DC-03BA-4D84-A496-5DBA653B5226}';
    IntfIID:   '{844A42E0-CF22-4460-8040-7BFD6B2AF300}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TInventarstatus.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IInventarstatus;
  end;
end;

procedure TInventarstatus.ConnectTo(svrIntf: IInventarstatus);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TInventarstatus.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TInventarstatus.GetDefaultInterface: IInventarstatus;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TInventarstatus.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TInventarstatus.Destroy;
begin
  inherited Destroy;
end;

function TInventarstatus.Get_Anschaffungskosten: Currency;
begin
  Result := DefaultInterface.Anschaffungskosten;
end;

function TInventarstatus.Get_Abschreibung: Currency;
begin
  Result := DefaultInterface.Abschreibung;
end;

function TInventarstatus.Get_Restbuchwert: Currency;
begin
  Result := DefaultInterface.Restbuchwert;
end;

function TInventarstatus.Get_AnschaffungskostenAnfang: Currency;
begin
  Result := DefaultInterface.AnschaffungskostenAnfang;
end;

function TInventarstatus.Get_AnschaffungskostenZugang: Currency;
begin
  Result := DefaultInterface.AnschaffungskostenZugang;
end;

function TInventarstatus.Get_AnschaffungskostenAbgang: Currency;
begin
  Result := DefaultInterface.AnschaffungskostenAbgang;
end;

function TInventarstatus.Get_AnschaffungskostenUmbuchung: Currency;
begin
  Result := DefaultInterface.AnschaffungskostenUmbuchung;
end;

function TInventarstatus.Get_AbschreibungAnfang: Currency;
begin
  Result := DefaultInterface.AbschreibungAnfang;
end;

function TInventarstatus.Get_AbschreibungZugang: Currency;
begin
  Result := DefaultInterface.AbschreibungZugang;
end;

function TInventarstatus.Get_AbschreibungAbgang: Currency;
begin
  Result := DefaultInterface.AbschreibungAbgang;
end;

function TInventarstatus.Get_AbschreibungUmbuchung: Currency;
begin
  Result := DefaultInterface.AbschreibungUmbuchung;
end;

function TInventarstatus.Get_AbschreibungSimulation: Currency;
begin
  Result := DefaultInterface.AbschreibungSimulation;
end;

function TInventarstatus.Get_RestbuchwertAnfang: Currency;
begin
  Result := DefaultInterface.RestbuchwertAnfang;
end;

function TInventarstatus.Get_RestbuchwertAbgang: Currency;
begin
  Result := DefaultInterface.RestbuchwertAbgang;
end;

function TInventarstatus.Get_RestbuchwertUmbuchung: Currency;
begin
  Result := DefaultInterface.RestbuchwertUmbuchung;
end;

function TInventarstatus.Get_RestbuchwertZugang: Currency;
begin
  Result := DefaultInterface.RestbuchwertZugang;
end;

function TInventarstatus.Get_Sonderabschreibung: Currency;
begin
  Result := DefaultInterface.Sonderabschreibung;
end;

function TInventarstatus.Get_SonderabschreibungAnfang: Currency;
begin
  Result := DefaultInterface.SonderabschreibungAnfang;
end;

function TInventarstatus.Get_SonderabschreibungZugang: Currency;
begin
  Result := DefaultInterface.SonderabschreibungZugang;
end;

function TInventarstatus.Get_AbschreibungProzent: Double;
begin
  Result := DefaultInterface.AbschreibungProzent;
end;

class function CoInventarKLRAnteil.Create: IInventarKLRAnteil;
begin
  Result := CreateComObject(CLASS_InventarKLRAnteil) as IInventarKLRAnteil;
end;

class function CoInventarKLRAnteil.CreateRemote(const MachineName: string): IInventarKLRAnteil;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_InventarKLRAnteil) as IInventarKLRAnteil;
end;

procedure TInventarKLRAnteil.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{ECE8F1C1-522C-4EF5-A74C-7140972834A6}';
    IntfIID:   '{33AA927D-2563-4C87-8D92-A34017C4851E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TInventarKLRAnteil.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IInventarKLRAnteil;
  end;
end;

procedure TInventarKLRAnteil.ConnectTo(svrIntf: IInventarKLRAnteil);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TInventarKLRAnteil.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TInventarKLRAnteil.GetDefaultInterface: IInventarKLRAnteil;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TInventarKLRAnteil.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TInventarKLRAnteil.Destroy;
begin
  inherited Destroy;
end;

function TInventarKLRAnteil.Get_IsKostenstelle: WordBool;
begin
  Result := DefaultInterface.IsKostenstelle;
end;

function TInventarKLRAnteil.Get_IsKostentraeger: WordBool;
begin
  Result := DefaultInterface.IsKostentraeger;
end;

function TInventarKLRAnteil.Get_KoStTrNr: Integer;
begin
  Result := DefaultInterface.KoStTrNr;
end;

function TInventarKLRAnteil.Get_Ordnung: Integer;
begin
  Result := DefaultInterface.Ordnung;
end;

function TInventarKLRAnteil.Get_Anteil: Integer;
begin
  Result := DefaultInterface.Anteil;
end;

function TInventarKLRAnteil.Get_AbDatum: TDateTime;
begin
  Result := DefaultInterface.AbDatum;
end;

function TInventarKLRAnteil.Get_BisDatum: TDateTime;
begin
  Result := DefaultInterface.BisDatum;
end;

function TInventarKLRAnteil.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoServer.Create: IServer;
begin
  Result := CreateComObject(CLASS_Server) as IServer;
end;

class function CoServer.CreateRemote(const MachineName: string): IServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Server) as IServer;
end;

procedure TServer.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{1F63F551-A2E9-403C-81C9-26A60AEF8E3F}';
    IntfIID:   '{15EC12A5-BC1E-4B53-9732-7B72A85F117B}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TServer.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IServer;
  end;
end;

procedure TServer.ConnectTo(svrIntf: IServer);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TServer.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TServer.GetDefaultInterface: IServer;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TServer.Destroy;
begin
  inherited Destroy;
end;

function TServer.ConnectionCount: Integer;
begin
  Result := DefaultInterface.ConnectionCount;
end;

procedure TServer.ShutDown;
begin
  DefaultInterface.ShutDown;
end;

class function CoBranche.Create: IBranche;
begin
  Result := CreateComObject(CLASS_Branche) as IBranche;
end;

class function CoBranche.CreateRemote(const MachineName: string): IBranche;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Branche) as IBranche;
end;

procedure TBranche.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{38F5606A-5843-4A2C-A5B7-ADEFDE292E42}';
    IntfIID:   '{C1BB5972-3E8E-4733-95B8-8B53F26412BF}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBranche.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBranche;
  end;
end;

procedure TBranche.ConnectTo(svrIntf: IBranche);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBranche.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBranche.GetDefaultInterface: IBranche;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TBranche.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBranche.Destroy;
begin
  inherited Destroy;
end;

function TBranche.Get_Bezeichnung: WideString;
begin
  Result := DefaultInterface.Bezeichnung;
end;

function TBranche.Get_Schluessel: Integer;
begin
  Result := DefaultInterface.Schluessel;
end;

procedure TBranche.Set_Schluessel(Value: Integer);
begin
  DefaultInterface.Schluessel := Value;
end;

function TBranche.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoWechsel.Create: IWechsel;
begin
  Result := CreateComObject(CLASS_Wechsel) as IWechsel;
end;

class function CoWechsel.CreateRemote(const MachineName: string): IWechsel;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Wechsel) as IWechsel;
end;

procedure TWechsel.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{9C2508FD-6E39-4E5E-8C16-DD92083EA79C}';
    IntfIID:   '{69B51AF2-1309-4E18-9ED3-35B32FB3021C}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TWechsel.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IWechsel;
  end;
end;

procedure TWechsel.ConnectTo(svrIntf: IWechsel);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TWechsel.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TWechsel.GetDefaultInterface: IWechsel;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TWechsel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TWechsel.Destroy;
begin
  inherited Destroy;
end;

function TWechsel.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

procedure TWechsel.Set_Nummer(Value: Integer);
begin
  DefaultInterface.Nummer := Value;
end;

function TWechsel.Get_Art: EWechselarten;
begin
  Result := DefaultInterface.Art;
end;

function TWechsel.Get_Konto1: Integer;
begin
  Result := DefaultInterface.Konto1;
end;

function TWechsel.Get_Konto2: Integer;
begin
  Result := DefaultInterface.Konto2;
end;

function TWechsel.Get_Hauswaehrung: Integer;
begin
  Result := DefaultInterface.Hauswaehrung;
end;

function TWechsel.Get_HwBetrag: Currency;
begin
  Result := DefaultInterface.HwBetrag;
end;

function TWechsel.Get_Fremdwaehrung: Integer;
begin
  Result := DefaultInterface.Fremdwaehrung;
end;

function TWechsel.Get_FwBetrag: Currency;
begin
  Result := DefaultInterface.FwBetrag;
end;

function TWechsel.Get_Verwendung: EWechselverwendungen;
begin
  Result := DefaultInterface.Verwendung;
end;

function TWechsel.Get_Bezogener: Integer;
begin
  Result := DefaultInterface.Bezogener;
end;

function TWechsel.Get_Aussteller: Integer;
begin
  Result := DefaultInterface.Aussteller;
end;

function TWechsel.Get_Indossant: Integer;
begin
  Result := DefaultInterface.Indossant;
end;

function TWechsel.Get_Indossatar: Integer;
begin
  Result := DefaultInterface.Indossatar;
end;

function TWechsel.Get_AnOrder: Integer;
begin
  Result := DefaultInterface.AnOrder;
end;

function TWechsel.Get_ZahlbarIn: WideString;
begin
  Result := DefaultInterface.ZahlbarIn;
end;

function TWechsel.Get_ZahlbarBeiBank: WideString;
begin
  Result := DefaultInterface.ZahlbarBeiBank;
end;

function TWechsel.Get_ZahlbarBeiBKtNr: WideString;
begin
  Result := DefaultInterface.ZahlbarBeiBKtNr;
end;

function TWechsel.Get_IBAN: WideString;
begin
  Result := DefaultInterface.IBAN;
end;

function TWechsel.Get_AusstellOrt: WideString;
begin
  Result := DefaultInterface.AusstellOrt;
end;

function TWechsel.Get_AusstellDatum: TDateTime;
begin
  Result := DefaultInterface.AusstellDatum;
end;

function TWechsel.Get_FaelligDatum: TDateTime;
begin
  Result := DefaultInterface.FaelligDatum;
end;

function TWechsel.Get_AkzeptiertDatum: TDateTime;
begin
  Result := DefaultInterface.AkzeptiertDatum;
end;

function TWechsel.Get_VersandDatum: TDateTime;
begin
  Result := DefaultInterface.VersandDatum;
end;

function TWechsel.Get_VersandAn: Integer;
begin
  Result := DefaultInterface.VersandAn;
end;

function TWechsel.Get_Eingangsdatum: TDateTime;
begin
  Result := DefaultInterface.Eingangsdatum;
end;

function TWechsel.Get_EingangVon: Integer;
begin
  Result := DefaultInterface.EingangVon;
end;

function TWechsel.Get_Ausgangsdatum: TDateTime;
begin
  Result := DefaultInterface.Ausgangsdatum;
end;

function TWechsel.Get_Diskontbank: Integer;
begin
  Result := DefaultInterface.Diskontbank;
end;

function TWechsel.Get_DiskontDatum: TDateTime;
begin
  Result := DefaultInterface.DiskontDatum;
end;

function TWechsel.Get_DiskontoNr: WideString;
begin
  Result := DefaultInterface.DiskontoNr;
end;

function TWechsel.Get_ProlongDatum: TDateTime;
begin
  Result := DefaultInterface.ProlongDatum;
end;

function TWechsel.Get_ProtestDatum: TDateTime;
begin
  Result := DefaultInterface.ProtestDatum;
end;

function TWechsel.Get_Anlagedatum: TDateTime;
begin
  Result := DefaultInterface.Anlagedatum;
end;

function TWechsel.Get_Ursprungskonto: Integer;
begin
  Result := DefaultInterface.Ursprungskonto;
end;

function TWechsel.Get_FibuNetBankKonto: Integer;
begin
  Result := DefaultInterface.FibuNetBankKonto;
end;

function TWechsel.Get_Einloesdatum: TDateTime;
begin
  Result := DefaultInterface.Einloesdatum;
end;

function TWechsel.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoTageskurs.Create: ITageskurs;
begin
  Result := CreateComObject(CLASS_Tageskurs) as ITageskurs;
end;

class function CoTageskurs.CreateRemote(const MachineName: string): ITageskurs;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Tageskurs) as ITageskurs;
end;

procedure TTageskurs.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{641E0EB3-6004-4D90-AFAD-878DA76BCCD2}';
    IntfIID:   '{2B67894D-57D6-4227-95A4-DAE954213CE5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TTageskurs.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ITageskurs;
  end;
end;

procedure TTageskurs.ConnectTo(svrIntf: ITageskurs);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TTageskurs.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TTageskurs.GetDefaultInterface: ITageskurs;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TTageskurs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TTageskurs.Destroy;
begin
  inherited Destroy;
end;

function TTageskurs.Get_Tagesdatum: TDateTime;
begin
  Result := DefaultInterface.Tagesdatum;
end;

procedure TTageskurs.Set_Tagesdatum(Value: TDateTime);
begin
  DefaultInterface.Tagesdatum := Value;
end;

function TTageskurs.Get_Geldkurs: Currency;
begin
  Result := DefaultInterface.Geldkurs;
end;

function TTageskurs.Get_Briefkurs: Currency;
begin
  Result := DefaultInterface.Briefkurs;
end;

function TTageskurs.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoEGSteuer.Create: IEGSteuer;
begin
  Result := CreateComObject(CLASS_EGSteuer) as IEGSteuer;
end;

class function CoEGSteuer.CreateRemote(const MachineName: string): IEGSteuer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_EGSteuer) as IEGSteuer;
end;

procedure TEGSteuer.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5FD0A957-2A74-46E5-85E1-1CC74EF0FDE9}';
    IntfIID:   '{E6BDBF00-3BC4-444C-9F3B-B4A64DE75F28}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TEGSteuer.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IEGSteuer;
  end;
end;

procedure TEGSteuer.ConnectTo(svrIntf: IEGSteuer);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TEGSteuer.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TEGSteuer.GetDefaultInterface: IEGSteuer;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TEGSteuer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TEGSteuer.Destroy;
begin
  inherited Destroy;
end;

function TEGSteuer.Get_UID: WideString;
begin
  Result := DefaultInterface.UID;
end;

function TEGSteuer.Get_Erwerbschwelle: Currency;
begin
  Result := DefaultInterface.Erwerbschwelle;
end;

function TEGSteuer.Get_Lieferschwelle: Currency;
begin
  Result := DefaultInterface.Lieferschwelle;
end;

function TEGSteuer.Get_Lkz: WideString;
begin
  Result := DefaultInterface.Lkz;
end;

procedure TEGSteuer.Set_Lkz(const Value: WideString);
begin
  DefaultInterface.Lkz := Value;
end;

function TEGSteuer.Get_EUMitgliedSeit: TDateTime;
begin
  Result := DefaultInterface.EUMitgliedSeit;
end;

function TEGSteuer.Get_UStIdLen: Integer;
begin
  Result := DefaultInterface.UStIdLen;
end;

function TEGSteuer.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TEGSteuer.Land(Value: Integer): WideString;
begin
  Result := DefaultInterface.Land(Value);
end;

function TEGSteuer.GueltigAb(IdxValue: Integer; StSchlValue: Integer): TDateTime;
begin
  Result := DefaultInterface.GueltigAb(IdxValue, StSchlValue);
end;

function TEGSteuer.Steuersatz(IdxValue: Integer; StSchlValue: Integer): Double;
begin
  Result := DefaultInterface.Steuersatz(IdxValue, StSchlValue);
end;

function TEGSteuer.AbDatum(IdxValue: Integer): TDateTime;
begin
  Result := DefaultInterface.AbDatum(IdxValue);
end;

function TEGSteuer.FindSteuersatz(const Lkz: WideString; Schluessel: Integer; Belegdatum: TDateTime): Double;
begin
  Result := DefaultInterface.FindSteuersatz(Lkz, Schluessel, Belegdatum);
end;

function TEGSteuer.FindSteuerschluessel(const Lkz: WideString; Prozent: Double; 
                                        Belegdatum: TDateTime): Integer;
begin
  Result := DefaultInterface.FindSteuerschluessel(Lkz, Prozent, Belegdatum);
end;

class function CoScheck.Create: IScheck;
begin
  Result := CreateComObject(CLASS_Scheck) as IScheck;
end;

class function CoScheck.CreateRemote(const MachineName: string): IScheck;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Scheck) as IScheck;
end;

procedure TScheck.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{970004B0-C013-4C64-98C4-D59E126BAFB5}';
    IntfIID:   '{971F3438-32FF-49D9-A580-3B456E82F760}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TScheck.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IScheck;
  end;
end;

procedure TScheck.ConnectTo(svrIntf: IScheck);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TScheck.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TScheck.GetDefaultInterface: IScheck;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TScheck.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TScheck.Destroy;
begin
  inherited Destroy;
end;

function TScheck.Get_Nummer: WideString;
begin
  Result := DefaultInterface.Nummer;
end;

function TScheck.Get_Tagesdatum: TDateTime;
begin
  Result := DefaultInterface.Tagesdatum;
end;

function TScheck.Get_Betrag: Currency;
begin
  Result := DefaultInterface.Betrag;
end;

function TScheck.Get_Skonto: Currency;
begin
  Result := DefaultInterface.Skonto;
end;

function TScheck.Get_Konto: Integer;
begin
  Result := DefaultInterface.Konto;
end;

function TScheck.Get_Zahldatum: TDateTime;
begin
  Result := DefaultInterface.Zahldatum;
end;

function TScheck.Get_KTO: WideString;
begin
  Result := DefaultInterface.KTO;
end;

function TScheck.Get_BLZ: Integer;
begin
  Result := DefaultInterface.BLZ;
end;

function TScheck.Get_WaNr: Integer;
begin
  Result := DefaultInterface.WaNr;
end;

function TScheck.Get_WaBetrag: Currency;
begin
  Result := DefaultInterface.WaBetrag;
end;

function TScheck.Get_WaSkonto: Currency;
begin
  Result := DefaultInterface.WaSkonto;
end;

function TScheck.Get_FrmNr: Integer;
begin
  Result := DefaultInterface.FrmNr;
end;

function TScheck.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TScheck.Zahlbuchung(Belegdatum: TDateTime; Wertdatum: TDateTime): WideString;
begin
  Result := DefaultInterface.Zahlbuchung(Belegdatum, Wertdatum);
end;

function TScheck.Loeschen: WordBool;
begin
  Result := DefaultInterface.Loeschen;
end;

class function CoInventarJournal.Create: IInventarJournal;
begin
  Result := CreateComObject(CLASS_InventarJournal) as IInventarJournal;
end;

class function CoInventarJournal.CreateRemote(const MachineName: string): IInventarJournal;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_InventarJournal) as IInventarJournal;
end;

procedure TInventarJournal.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{7DE1D2A9-E5CC-431B-BC92-075228C17710}';
    IntfIID:   '{101698A4-FE62-4295-A4A6-BCA1A1FE1C95}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TInventarJournal.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IInventarJournal;
  end;
end;

procedure TInventarJournal.ConnectTo(svrIntf: IInventarJournal);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TInventarJournal.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TInventarJournal.GetDefaultInterface: IInventarJournal;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TInventarJournal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TInventarJournal.Destroy;
begin
  inherited Destroy;
end;

function TInventarJournal.Get_Inventarnummer: WideString;
begin
  Result := DefaultInterface.Inventarnummer;
end;

function TInventarJournal.Get_Bewegungsart: Integer;
begin
  Result := DefaultInterface.Bewegungsart;
end;

function TInventarJournal.Get_Einheit: Integer;
begin
  Result := DefaultInterface.Einheit;
end;

function TInventarJournal.Get_Buchkenner: Integer;
begin
  Result := DefaultInterface.Buchkenner;
end;

function TInventarJournal.Get_BuchJournalZeile: Integer;
begin
  Result := DefaultInterface.BuchJournalZeile;
end;

function TInventarJournal.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

function TInventarJournal.Kontierung: IKontierung;
begin
  Result := DefaultInterface.Kontierung;
end;

class function CoKreditkarte.Create: IKreditkarte;
begin
  Result := CreateComObject(CLASS_Kreditkarte) as IKreditkarte;
end;

class function CoKreditkarte.CreateRemote(const MachineName: string): IKreditkarte;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Kreditkarte) as IKreditkarte;
end;

procedure TKreditkarte.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2F06231A-7F8A-47F4-A392-CDC56E389230}';
    IntfIID:   '{A9F5CAD6-AE63-4BB1-8028-12F9A32F5EC5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKreditkarte.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKreditkarte;
  end;
end;

procedure TKreditkarte.ConnectTo(svrIntf: IKreditkarte);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKreditkarte.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKreditkarte.GetDefaultInterface: IKreditkarte;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKreditkarte.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKreditkarte.Destroy;
begin
  inherited Destroy;
end;

function TKreditkarte.Get_Marke: Integer;
begin
  Result := DefaultInterface.Marke;
end;

function TKreditkarte.Get_Nummer: WideString;
begin
  Result := DefaultInterface.Nummer;
end;

function TKreditkarte.Get_CVC: WideString;
begin
  Result := DefaultInterface.CVC;
end;

function TKreditkarte.Get_GueltigBis: TDateTime;
begin
  Result := DefaultInterface.GueltigBis;
end;

function TKreditkarte.Get_Inhaber: WideString;
begin
  Result := DefaultInterface.Inhaber;
end;

class function CoVerteilung.Create: IVerteilung;
begin
  Result := CreateComObject(CLASS_Verteilung) as IVerteilung;
end;

class function CoVerteilung.CreateRemote(const MachineName: string): IVerteilung;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Verteilung) as IVerteilung;
end;

procedure TVerteilung.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{F4CECD1E-5406-453B-8B4A-C6C1BEF2760C}';
    IntfIID:   '{E5014709-DDF1-4613-A69C-9B225A2A6ECA}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TVerteilung.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IVerteilung;
  end;
end;

procedure TVerteilung.ConnectTo(svrIntf: IVerteilung);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TVerteilung.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TVerteilung.GetDefaultInterface: IVerteilung;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TVerteilung.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TVerteilung.Destroy;
begin
  inherited Destroy;
end;

function TVerteilung.Get_vertIsKostenstelle: WordBool;
begin
  Result := DefaultInterface.vertIsKostenstelle;
end;

function TVerteilung.Get_vertStTr: Integer;
begin
  Result := DefaultInterface.vertStTr;
end;

function TVerteilung.Get_empfIsKostenstelle: WordBool;
begin
  Result := DefaultInterface.empfIsKostenstelle;
end;

function TVerteilung.Get_empfStTr: Integer;
begin
  Result := DefaultInterface.empfStTr;
end;

function TVerteilung.Get_Kostenart: Integer;
begin
  Result := DefaultInterface.Kostenart;
end;

function TVerteilung.Get_Betrag: Currency;
begin
  Result := DefaultInterface.Betrag;
end;

function TVerteilung.Get_BGS: Integer;
begin
  Result := DefaultInterface.BGS;
end;

function TVerteilung.Get_Monat: Integer;
begin
  Result := DefaultInterface.Monat;
end;

function TVerteilung.Get_FixVar: Integer;
begin
  Result := DefaultInterface.FixVar;
end;

function TVerteilung.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

class function CoElster.Create: IElster;
begin
  Result := CreateComObject(CLASS_Elster) as IElster;
end;

class function CoElster.CreateRemote(const MachineName: string): IElster;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Elster) as IElster;
end;

procedure TElster.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D8280740-9944-459E-801D-EB5ED4B94F12}';
    IntfIID:   '{92B40CEE-D6CA-4683-AE0F-018476E8F954}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TElster.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IElster;
  end;
end;

procedure TElster.ConnectTo(svrIntf: IElster);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TElster.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TElster.GetDefaultInterface: IElster;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TElster.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TElster.Destroy;
begin
  inherited Destroy;
end;

function TElster.LoadElsterFile(const Filename: WideString; IsDelete: WordBool): OleVariant;
begin
  Result := DefaultInterface.LoadElsterFile(Filename, IsDelete);
end;

procedure TElster.SaveElsterFile(const Filename: WideString; Data: OleVariant);
begin
  DefaultInterface.SaveElsterFile(Filename, Data);
end;

function TElster.GetElsterFileList: WideString;
begin
  Result := DefaultInterface.GetElsterFileList;
end;

class function CoKLRAutomatik.Create: IKLRAutomatik;
begin
  Result := CreateComObject(CLASS_KLRAutomatik) as IKLRAutomatik;
end;

class function CoKLRAutomatik.CreateRemote(const MachineName: string): IKLRAutomatik;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_KLRAutomatik) as IKLRAutomatik;
end;

procedure TKLRAutomatik.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{979F9FB3-ECD9-45EB-87B8-FD76A72DA408}';
    IntfIID:   '{D870FD19-3731-4A17-BA47-41FF41C4DD62}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TKLRAutomatik.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IKLRAutomatik;
  end;
end;

procedure TKLRAutomatik.ConnectTo(svrIntf: IKLRAutomatik);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TKLRAutomatik.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TKLRAutomatik.GetDefaultInterface: IKLRAutomatik;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface ist NULL. Die Komponente ist nicht mit dem Server verbunden. Sie müssen vor dieser Operation "Connect" oder "ConnectTo" aufrufen');
  Result := FIntf;
end;

constructor TKLRAutomatik.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TKLRAutomatik.Destroy;
begin
  inherited Destroy;
end;

function TKLRAutomatik.Get_Nummer: Integer;
begin
  Result := DefaultInterface.Nummer;
end;

function TKLRAutomatik.Get_Bezeichnung: WideString;
begin
  Result := DefaultInterface.Bezeichnung;
end;

function TKLRAutomatik.Get_KurzBez: WideString;
begin
  Result := DefaultInterface.KurzBez;
end;

function TKLRAutomatik.Get_IsSachkonto: WordBool;
begin
  Result := DefaultInterface.IsSachkonto;
end;

function TKLRAutomatik.Get_IsDebitor: WordBool;
begin
  Result := DefaultInterface.IsDebitor;
end;

function TKLRAutomatik.Get_IsKreditor: WordBool;
begin
  Result := DefaultInterface.IsKreditor;
end;

function TKLRAutomatik.Navigate: INavigate;
begin
  Result := DefaultInterface.Navigate;
end;

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TFNFactory, TUser, TMandant, TAdresse, 
    TLand, TDebitor, TKonto, TSaldo, TPosten, 
    TNavigate, TKontierung, TJournal, TKLRJournal, TFestkonto, 
    TKreditor, TSachkonto, TBuchtext, TSteuer, TFinanzamt, 
    TBank, TKontenbereich, TBankverbindung, TGruppe, TKostenart, 
    TKostenstelle, TBezugsgroesse, TPlanmenge, TUSt, TKurs, 
    TWaehrung, TMahn, TZahlkondition, TFNReport, TChooseMandant, 
    TPasswort, TBuchen, TKostenstelleart, TFNImport, TREB, 
    TOrt, TLizenz, TCmdBuchen, TCmdPosten, TCmdKLR, 
    TKreditversicherung, TArchiv, TArchivierung, TBgMw, TBatchScript, 
    TXML, TDCUebFiles, TBgMwBeweg, TInventar, TInventarebene, 
    TInventarstatus, TInventarKLRAnteil, TServer, TBranche, TWechsel, 
    TTageskurs, TEGSteuer, TScheck, TInventarJournal, TKreditkarte, 
    TVerteilung, TElster, TKLRAutomatik]);
end;

end.
