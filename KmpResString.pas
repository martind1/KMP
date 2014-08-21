unit KmpResString;
(* Stringkonstanten für KMP
24.07.01 MD  von KmpResString übernommen. In const umgewandelt. Für DB-Translation.
             die Konvertierung erfolgte über Excel
29.12.11 md  uses
*)
interface


const
  {GNav_Kmp}
  SGrossschrift: string = 'Großschrift';
  SKleinschrift: string = 'Kleinschrift';

  {QNav_Kmp}
  SSuchen: string = 'Suchen';
  SFirstRecord: string = 'Erster Datensatz';
  SPriorRecord: string = 'Vorheriger Datensatz';
  SNextRecord: string = 'Nächster Datensatz';
  SLastRecord: string = 'Letzter Datensatz';
  SReadOnly: string = 'Nur Lesen';
  SInsertRecord: string = 'Datensatz einfügen';
  SDeleteRecord: string = 'Datensatz löschen';
  SEditRecord: string = 'Datensatz bearbeiten';
  SPostEdit: string = 'Übernehmen';
  SCancelEdit: string = 'Bearbeiten abbrechen';
  SRefreshRecord: string = 'Daten aktualisieren';
  SDeleteRecordQuestion: string = 'Datensatz löschen?';
  SDeleteZuoQuestion: string = 'Zuordnung entfernen?';  //ab 16.05.14
  SDeleteMultipleRecordsQuestion: string = 'Alle markierten Datensätze löschen?';

  {PrnFoDlg}
  SWindows: string = '(Windows)';
  SDefaultPrinter: string = '(Standarddrucker)';

SDatumDlg_001: string = 'Bitte 4stelliges Datum eingeben';

SDPos_Kmp_001: string = '%s:Mastersource fehlt';
SDPos_Kmp_002: string = '%s:MasterFields fehlt';
SDPos_Kmp_003: string = 'BuildSQLDelete:Feld(%s) in Zeile(%s) falsch:%s';
SDPos_Kmp_004: string = '%s:TableName enthält "," (%s)';
SDPos_Kmp_005: string = 'TFltrList.BuildSql: Feld(%s):DataType nicht gefunden';
SDPos_Kmp_006: string = 'Syntaxfehler';
SDPos_Kmp_007: string = '%s:KeyFields enthält "," (%s)';


SErr__Kmp_001: string = 'Errorkomponente bereits vorhanden';
SErr__Kmp_002: string = 'Bitte Operation wiederholen.';
SErr__Kmp_003: string = 'Merkmal nicht verfügbar.';
SErr__Kmp_004: string = 'Tabelle wird auf ReadOnly gesetzt.';
SErr__Kmp_005: string = 'Zurückblättern nicht mehr möglich.';
SErr__Kmp_006: string = 'Tabelle wird neu geladen.';
SErr__Kmp_007: string = 'Übersetzungsfehler (%s)';
SErr__Kmp_008: string = 'Abfrage so nicht ausführbar.';
SErr__Kmp_009: string = 'Tabelle schreibgeschützt öffnen ?';
SErr__Kmp_010: string = 'BDE-Datenbankfehler';
SErr__Kmp_011: string = '(Textende)';
SErr__Kmp_012: string = 'Fehler bei ERRM.Post (%s)';
SErr__Kmp_013: string = 'Datenbank meldet Fehler';
SErr__Kmp_014: string = 'Datenbankfehler';
SErr__Kmp_015: string = 'Fehlermeldung';
SErr__Kmp_016: string = 'Interner Fehler';
SErr__Kmp_017: string = 'Typ: ';
SErr__Kmp_018: string = 'von: ';
SErr__Kmp_019: string = 'Ändern hier nicht möglich';
SErr__Kmp_020: string = 'Fehler in %s: %s';
SErr__Kmp_021: string = 'von: %s.%s';
SErr__Kmp_022: string = 'von: %s';
SErr__Kmp_023: string = 'Doppelter Wert';
SErr__Kmp_024: string = 'Fehler bei ';
SErr__Kmp_025: string = 'Aktualisierung misslungen. Der Datensatz wurde an anderer Stelle geändert und muss neu geladen werden';
SErr__Kmp_026: string = 'Fehler beim Speichern. Wert bereits vorhanden:';
SErr__Kmp_027: string = 'Programm wird beendet';

SGNav_Kmp_001: string = 'Laden ...';
SGNav_Kmp_002: string = 'Ende(%s)';
SGNav_Kmp_003: string = 'AddQRepForm(%s): bereits vorhanden';
SGNav_Kmp_004: string = 'Report(%s) gesperrt';
SGNav_Kmp_005: string = 'StartQRepForm:(%s) fehlt';
SGNav_Kmp_006: string = 'EndQRepForm:(%s) bereits Ende';
SGNav_Kmp_007: string = 'Sie haben keine Rechte für diese Maske (%s)';
SGNav_Kmp_008: string = 'AddForm(%s): bereits vorhanden';
SGNav_Kmp_009: string = 'Form(%s) gesperrt während Form.Create';
SGNav_Kmp_010: string = 'Formular(%s) kann nicht gestartet werden';
SGNav_Kmp_011: string = 'EndForm(%s): bereits Ende';
SGNav_Kmp_012: string = 'Formular fehlt';
SGNav_Kmp_013: string = 'Im Formular wird bereits geändert oder gesucht';
SGNav_Kmp_014: string = 'LookUp(%s) kann nicht ausgeführt werden';
SGNav_Kmp_015: string = 'Formular fehlt (Nicht mit AddForm angelegt).';
SGNav_Kmp_016: string = 'Zielformular bereits geschlossen';
SGNav_Kmp_017: string = 'LNavigator fehlt';
SGNav_Kmp_018: string = 'Sortierung hier nicht verfügbar';
SGNav_Kmp_019: string = 'Programmende';
SGNav_Kmp_020: string = 'Einzeldarstellung hier nicht verfügbar';
SGNav_Kmp_021: string = 'Tabellendarstellung hier nicht verfügbar';
SGNav_Kmp_022: string = 'Keine HintIni Komponente gefunden';
SGNav_Kmp_023: string = 'Konvert: Tabellenbezug fehlt';
SGNav_Kmp_024: string = 'Keine Daten zum Markieren vorhanden';
SGNav_Kmp_025: string = 'GNav:Lnavigator fehlt';
SGNav_Kmp_026: string = 'Nicht im Editier-Modus';
SGNav_Kmp_027: string = 'Markiere(%d)';
SGNav_Kmp_028: string = 'Funktion (MarkAll) wird nicht unterstützt';
SGNav_Kmp_029: string = 'Keine Objekte von "%s" gefunden';
SGNav_Kmp_030: string = 'Aufruf "GNavigator.MakroInit" fehlt';
SGNav_Kmp_031: string = 'Suchen und Ersetzen hier nicht verfügbar';
SGNav_Kmp_032: string = 'Formular bereits in Verwendung';
SGNav_Kmp_033: string = 'Fehler bei Aufruf (%s). Bitte Hersteller kontaktieren.';
SGNav_Kmp_034: string = 'Eine neue Version (%s) wurde installiert. Bitte starten Sie das Programm neu.';

SLNav_Kmp_001: string = '%s nicht TqForm';
SLNav_Kmp_002: string = 'Bitte erst speichern';
SLNav_Kmp_003: string = 'Standarddrucker';
SLNav_Kmp_004: string = 'Click:LookUpDef(%s) fehlt';
SLNav_Kmp_005: string = 'LookUp hier nicht verfügbar (%s)';
SLNav_Kmp_006: string = 'DetailInsert(%s.%s):Positionierung schlug fehl';
SLNav_Kmp_007: string = 'Seite falsch (%s)';
SLNav_Kmp_008: string = 'SetReturn:SQL-Positionierung nicht möglich (%s) in (%s)';
SLNav_Kmp_009: string = 'Positionierung läuft';
SLNav_Kmp_010: string = '%s:Übernahme nicht mehr möglich:%d';
SLNav_Kmp_011: string = 'Übernahme nicht vorgesehen';
SLNav_Kmp_012: string = 'Fehler bei Übernahme.';
SLNav_Kmp_013: string = 'Daten wurden geändert.';
SLNav_Kmp_014: string = 'Speichern ?';
SLNav_Kmp_015: string = 'Zuordnung nicht möglich.';
SLNav_Kmp_016: string = '%s.Take.OldBeforePost: übergebenes Dataset verwenden !';
SLNav_Kmp_017: string = 'Übernehmen nicht möglich. %s';
SLNav_Kmp_018: string = 'ALookUpDef be missing';
SLNav_Kmp_019: string = 'Anzeige nicht möglich, da Verweis in "%s" fehlt';
SLNav_Kmp_020: string = '&Zurück';
SLNav_Kmp_021: string = '&übernehmen';
SLNav_Kmp_022: string = 'Keine Daten vorhanden';
SLNav_Kmp_023: string = 'nichts ausgewählt';

SLuGriDlg_001: string = 'Suchspalte fehlt';

SMugriKmp_001: string = '%s:Einfügen abgebrochen';
SMugriKmp_002: string = 'Fehler bei Format (%s). ';
SMugriKmp_003: string = 'Flags mit "," trennen.';
SMugriKmp_004: string = 'Spalte(%s) fehlt (%s)';
SMugriKmp_005: string = 'Fehler bei ColumnList:%d(%s)';
SMugriKmp_006: string = 'Layout wurde geändert. Speichern ?';
SMugriKmp_007: string = '(Abbruch = Standard wiederherstellen)';
SMugriKmp_008: string = 'Datensatz %d von %d';
SMugriKmp_009: string = 'Fehler beim Ablegen von %d nach %d';
SMugriKmp_010: string = 'Spalten';
SMugriKmp_011: string = 'Sortierung';
SMugriKmp_012: string = '%d von %d Datensätzen markiert';
SMugriKmp_013: string = '%d Datensatz markiert';
SMugriKmp_014: string = '%d Datensätze markiert';
SMugriKmp_015: string = 'Reihenfolge mit der Maus ziehen';
SMugriKmp_016: string = 'nach dieser Spalte kann nicht sortiert werden (%s)';
SMugriKmp_017: string = 'Ändern dieser Spalte nicht erlaubt (%s)';
SMugriKmp_018: string = '%d von %d Datensätzen kopiert';
SMugriKmp_019: string = '%d Zeilen geladen';

SNLnk_Kmp_001: string = 'Bestimme Anzahl der Datensätze .. %s';
SNLnk_Kmp_002: string = '%s:%s war geöffnet';
SNLnk_Kmp_003: string = 'Abbruch Schließen (%s)';
SNLnk_Kmp_004: string = 'Schließe (%s)';
SNLnk_Kmp_005: string = 'Lese O(%s)';
SNLnk_Kmp_006: string = 'Öffne (%s)F%dD%d:';
SNLnk_Kmp_007: string = 'Öffne (%s)';
SNLnk_Kmp_008: string = 'Geöffnet(%s):EOF=%s';
SNLnk_Kmp_009: string = 'Daten wurden geändert (%s).';
SNLnk_Kmp_010: string = 'Speichern ?';
SNLnk_Kmp_011: string = 'Lösche %s(%s) User(%s)';
SNLnk_Kmp_012: string = 'endeCHANGE(%s.%s):%s';
SNLnk_Kmp_013: string = 'Wert(%s) in(%s.%s) nicht gefunden.';
SNLnk_Kmp_014: string = 'Tabelle ?';
SNLnk_Kmp_015: string = '%s.%s.Rechnen(%s%s)';
SNLnk_Kmp_016: string = 'Neu Laden ?';
SNLnk_Kmp_017: string = 'DoEdit.Rechnen(%s.%s):%s';
SNLnk_Kmp_018: string = 'Erfassen abgebrochen';
SNLnk_Kmp_019: string = 'Markierte Datensätze löschen';
SNLnk_Kmp_020: string = 'Löschen nicht möglich.';
SNLnk_Kmp_021: string = '%s.DeleteDetails muß true sein.';
SNLnk_Kmp_022: string = 'Positionierung nicht möglich da Primary Key fehlt';
SNLnk_Kmp_023: string = '%s.%s.ReLoad:Positionierung fehlgeschlagen:';
SNLnk_Kmp_024: string = '%s:A UpdateFieldDefs nicht möglich (%s)';
SNLnk_Kmp_025: string = 'Formatfehler';
SNLnk_Kmp_026: string = 'CalcCache:LookUpDef(%s) fehlt';
SNLnk_Kmp_027: string = '%s.%s.FormatList(%s):Feld fehlt';
SNLnk_Kmp_028: string = '%s.%s.Columnlist(%s):Feld fehlt';
SNLnk_Kmp_029: string = 'ColumnList:Fehler bei Format(%s). ';
SNLnk_Kmp_030: string = 'Flags mit "," trennen.';
SNLnk_Kmp_031: string = 'Lösche (%s):%d';
SNLnk_Kmp_032: string = 'Syntaxfehler(%d)';
SNLnk_Kmp_033: string = 'Änderungen durchführen';
SNLnk_Kmp_034: string = 'Daten Ändern';
SNLnk_Kmp_035: string = 'Öffne (%s) %dms';

SPoll_Kmp_001: string = 'Polling beenden %ds';
SPoll_Kmp_002: string = 'Polling Komponente bereits vorhanden';
SPoll_Kmp_003: string = '%s:Add(%s) bereits vorhanden';
SPoll_Kmp_004: string = 'Ende:%s';
SPoll_Kmp_005: string = 'Starte %d';

SPrn_Dlg_001: string = '"IniKmp" nicht aktiv.';
SPrn_Dlg_002: string = 'Standarddrucker';
SPrn_Dlg_003: string = 'Einrichten';

SProts_001: string = '%s:"%s" kein gültiger PrinterIndex%s%s';
SProts_002: string = 'Protokollkomponente bereits vorhanden';
SProts_003: string = 'Prot:Fehler bei Insert(%s): %s';
SProts_004: string = 'Prot:Fehler bei Öffnen(%s): %s';
SProts_005: string = 'Kopiere %d bytes von %s nach %s';
SProts_006: string = 'CreateField:Fehler bei Format (%s)';
SProts_007: string = 'Unbekannter Feldtyp %d (%s)';
SProts_008: string = 'CreateField:Fehler bei Format (%s)';
SProts_009: string = 'FieldTypeStr:(%s)falsch';
SProts_010: string = 'Indexinfo: Öffne %s';
SProts_011: string = 'Zuwenig freier Speicher, die ausführbare Datei war beschädigt, ';
SProts_012: string = 'oder die Verschiebungen waren unzulässig.';
SProts_013: string = 'Datei nicht gefunden.';
SProts_014: string = 'Pfad nicht gefunden.';
SProts_015: string = 'Unzulässiger Versuch, eine Task dynamisch einzubinden, oder es gab ';
SProts_016: string = 'einen Fehler beim gemeinsamen Zugriff bzw. einen Zugriffsfehler im ';
SProts_017: string = 'Netzwerk.';
SProts_018: string = 'Bibliothek erfordert getrennte Datensegmente für jede Task.';
SProts_019: string = 'Ungenügender Speicher, um die Anwendung zu starten.';
SProts_020: string = 'Falsche Windows-Version.';
SProts_021: string = 'Ungültige .EXE-Datei (Keine Windows-.EXE-Datei oder Fehler im ';
SProts_022: string = '.EXE-Darstellungsformat).';
SProts_023: string = 'Anwendung wurde für anderes Betriebssystem entworfen.';
SProts_024: string = 'DOS 4.0-Anwendung.';
SProts_025: string = 'Unbekannter .EXE-Dateityp.';
SProts_026: string = 'Versuch, im Protected Mode (Standardmodus oder erweiterter 386-Modus) ';
SProts_027: string = 'eine für frühere Windows-Versionen erstellte .EXE-Datei zu laden';
SProts_028: string = 'Es wurde versucht, eine zweite Instanz einer ausführbaren Datei zu ';
SProts_029: string = 'die mehrfache (nicht Read-Only markierte) Datensegmente enthält.';
SProts_030: string = 'Es wurde versucht, eine komprimierte ausführbare Datei zu laden. ';
SProts_031: string = 'Die Datei muß dekomprimiert werden, bevor sie geladen werden kann.';
SProts_032: string = 'Die Dynamic-Link-Bibliothek(DLL)-Datei war fehlerhaft. Eine der ';
SProts_033: string = 'DLLs, die zum Start dieser Anwendung notwendig ist, war fehlerhaft.';
SProts_034: string =  'Die Anwendung benötigt 32-Bit-Erweiterungen.';
SProts_035: string = 'Datei nicht gefunden';
SProts_036: string = 'Unbekannter Fehler';
SProts_037: string = 'Fehler bei "%s" von "%s":';
SProts_038: string = 'Fehler "%s" Aufruf von "%s": %s';
SProts_039: string = 'Fehler beim Aufruf von "%s":';
SProts_040: string = 'Fehler beim Aufruf von "%s": %s';
SProts_041: string = 'Fehler bei "%s" von "%s": %s';
SProts_042: string = 'FloatToInt: %s ist kein gültiger Integer-Wert %s%s';

SPsrc_Kmp_001: string = 'Druckertyp (%s) in IniKmp nicht gefunden.';
SPsrc_Kmp_002: string = 'Formular mit IniKmp nicht aktiv.';
SPsrc_Kmp_003: string = 'Richte DDE-Verbindung zu Winfax ein (%s %s)';
SPsrc_Kmp_004: string = 'Nummer kann nicht zu Winfax übertragen werden (%s %s)';
SPsrc_Kmp_005: string = 'Ausdruck läuft ...';
SPsrc_Kmp_006: string = 'Keine Datensätze zum Drucken gefunden';
SPsrc_Kmp_007: string = 'Fehler bei CompositeReport:%s';
SPsrc_Kmp_008: string = 'Ausfertigung %d/%d wird gedruckt ...';
SPsrc_Kmp_009: string = 'Fehler bei Quickreport(%s)';
SPsrc_Kmp_010: string = 'Quickreport ist nicht angegeben';
SPsrc_Kmp_011: string = 'Ausdruck kann nicht mehr gestartet werden';

SQNav_Kmp_013: string = 'NavLink=nil bei ';
SQNav_Kmp_014: string = 'BCStartForm:Warte bis (%s)=nil';
SQNav_Kmp_015: string = 'Suche kann hier nicht gestartet werden';
SQNav_Kmp_016: string = 'Sie haben keine Rechte zum Ändern (%s)';
SQNav_Kmp_017: string = 'Sie haben keine Rechte zum Erfassen (%s)';
SQNav_Kmp_018: string = 'Suchkriterien wurden gelöscht';
SQNav_Kmp_019: string = 'Wollen Sie alle markierten Datensätze löschen ?';
SQNav_Kmp_020: string = 'Sie haben keine Rechte zum Löschen (%s)';
SQNav_Kmp_021: string = 'Fehler bei %s';
SQNav_Kmp_022: string = 'Suchen';
SQNav_Kmp_023: string = 'Kann Suchtabelle nicht öffnen';
SQNav_Kmp_024: string = 'Laden';
SQNav_Kmp_025: string = 'Keine Daten gefunden';
SQNav_Kmp_026: string = 'Nochmal Suchen ?';
SQNav_Kmp_027: string = 'Keine Daten gefunden (%s)';
SQNav_Kmp_028: string = 'Fehler beim Öffnen von %s';
SQNav_Kmp_029: string = 'gefiltert';
SQNav_Kmp_030: string = 'Speichern hier nicht erlaubt';

SQrPreDlg_001: string = 'Seite ';
SQrPreDlg_002: string = ' von ';

SQwf_Form_001: string = 'Release(%s):Warte auf Poll';
SQwf_Form_002: string = 'Ausdruck läuft noch (%s)';
SQwf_Form_003: string = 'Daten wurden geändert.';
SQwf_Form_004: string = 'Speichern ?';
SQwf_Form_005: string = 'ReadValues:(%s) nicht gefunden';
SQwf_Form_006: string = '%s:LNavigator fehlt';
SQwf_Form_007: string = 'Formular fehlt';

SSort_Dlg_001: string = '(ohne)';
SSort_Dlg_002: string = 'Sortierung nach %s';
SSort_Dlg_003: string = 'Ohne Sortierung';

SSql_Dlg_001: string = 'Schließen';
SSql_Dlg_002: string = 'Ignorieren ?';
SSql_Dlg_003: string = 'Zeitdauer: %d ms';

STools_001: string = 'Kategorie';
STools_002: string = 'Drucker';
STools_003: string = 'Standarddrucker';
STools_004: string = 'Allgemeiner Fehler.';
STools_005: string = 'Speicherplatz auf der Diskette bzw. Platte nicht ausreichend für Spooling. ';
STools_006: string = 'Zusätzlicher Speicherplatz kann nicht verfügbar gemacht werden.';
STools_007: string = 'Arbeitsspeicher ist für Spooling nicht ausreichend.';
STools_008: string = 'Der Benutzer hat den Druckauftrag mit Hilfe des Druck-Managers abgebrochen.';
STools_009: string = 'Fehler %d bei RawData.QUERYESCSUPPORT';
STools_010: string = 'Fehler %d bei RawData.PASSTHROUGH: %s';

Replace_001: string = 'Wert wurde nicht übernommen';
Replace_002: string = 'Fehler bei Ersetzen: %s';
Replace_003: string = 'Bedienerabbruch';
Replace_004: string = 'keine Datensätze gefunden';
Replace_005: string = 'Suche wurde beendet';
Replace_006: string = 'Ersetzen wurde beendet (%d)';

SUSes_001: string = 'unbekannter Alias "%s"';

SDfltRep_001: string = 'Zeile';

SFltrFrm_001: string = '(alle)';

WordPrn_001: string = 'Word beenden?';
ExcelPrn_001: string = 'Excel beenden?';

procedure KmpResStringInit;

implementation

uses
  GNav_Kmp;

procedure KmpResStringInit;
begin
  with GNavigator do
  begin
    SGrossschrift:= TranslateStr(Gnavigator,  SGrossschrift);
    SKleinschrift:= TranslateStr(Gnavigator,  SKleinschrift);
    SSuchen:= TranslateStr(Gnavigator,  SSuchen);
    SFirstRecord:= TranslateStr(Gnavigator,  SFirstRecord);
    SPriorRecord:= TranslateStr(Gnavigator,  SPriorRecord);
    SNextRecord:= TranslateStr(Gnavigator,  SNextRecord);
    SLastRecord:= TranslateStr(Gnavigator,  SLastRecord);
    SReadOnly:= TranslateStr(Gnavigator,  SReadOnly);
    SInsertRecord:= TranslateStr(Gnavigator,  SInsertRecord);
    SDeleteRecord:= TranslateStr(Gnavigator,  SDeleteRecord);
    SEditRecord:= TranslateStr(Gnavigator,  SEditRecord);
    SPostEdit:= TranslateStr(Gnavigator,  SPostEdit);
    SCancelEdit:= TranslateStr(Gnavigator,  SCancelEdit);
    SRefreshRecord:= TranslateStr(Gnavigator,  SRefreshRecord);
    SDeleteRecordQuestion:= TranslateStr(Gnavigator,  SDeleteRecordQuestion);
    SDeleteMultipleRecordsQuestion:= TranslateStr(Gnavigator,  SDeleteMultipleRecordsQuestion);
    SWindows:= TranslateStr(Gnavigator,  SWindows);
    SDefaultPrinter:= TranslateStr(Gnavigator,  SDefaultPrinter);

    SDatumDlg_001	:= TranslateStr(Gnavigator,	SDatumDlg_001	);

    SDPos_Kmp_001	:= TranslateStr(Gnavigator,	SDPos_Kmp_001	);
    SDPos_Kmp_002	:= TranslateStr(Gnavigator,	SDPos_Kmp_002	);
    SDPos_Kmp_003	:= TranslateStr(Gnavigator,	SDPos_Kmp_003	);
    SDPos_Kmp_004	:= TranslateStr(Gnavigator,	SDPos_Kmp_004	);
    SDPos_Kmp_005	:= TranslateStr(Gnavigator,	SDPos_Kmp_005	);
    SDPos_Kmp_006	:= TranslateStr(Gnavigator,	SDPos_Kmp_006	);
    SDPos_Kmp_007	:= TranslateStr(Gnavigator,	SDPos_Kmp_007	);
			
			
    SErr__Kmp_001	:= TranslateStr(Gnavigator,	SErr__Kmp_001	);
    SErr__Kmp_002	:= TranslateStr(Gnavigator,	SErr__Kmp_002	);
    SErr__Kmp_003	:= TranslateStr(Gnavigator,	SErr__Kmp_003	);
    SErr__Kmp_004	:= TranslateStr(Gnavigator,	SErr__Kmp_004	);
    SErr__Kmp_005	:= TranslateStr(Gnavigator,	SErr__Kmp_005	);
    SErr__Kmp_006	:= TranslateStr(Gnavigator,	SErr__Kmp_006	);
    SErr__Kmp_007	:= TranslateStr(Gnavigator,	SErr__Kmp_007	);
    SErr__Kmp_008	:= TranslateStr(Gnavigator,	SErr__Kmp_008	);
    SErr__Kmp_009	:= TranslateStr(Gnavigator,	SErr__Kmp_009	);
    SErr__Kmp_010	:= TranslateStr(Gnavigator,	SErr__Kmp_010	);
    SErr__Kmp_011	:= TranslateStr(Gnavigator,	SErr__Kmp_011	);
    SErr__Kmp_012	:= TranslateStr(Gnavigator,	SErr__Kmp_012	);
    SErr__Kmp_013	:= TranslateStr(Gnavigator,	SErr__Kmp_013	);
    SErr__Kmp_014	:= TranslateStr(Gnavigator,	SErr__Kmp_014	);
    SErr__Kmp_015	:= TranslateStr(Gnavigator,	SErr__Kmp_015	);
    SErr__Kmp_016	:= TranslateStr(Gnavigator,	SErr__Kmp_016	);
    SErr__Kmp_017	:= TranslateStr(Gnavigator,	SErr__Kmp_017	);
    SErr__Kmp_018	:= TranslateStr(Gnavigator,	SErr__Kmp_018	);
    SErr__Kmp_019	:= TranslateStr(Gnavigator,	SErr__Kmp_019	);
    SErr__Kmp_020	:= TranslateStr(Gnavigator,	SErr__Kmp_020	);
    SErr__Kmp_021	:= TranslateStr(Gnavigator,	SErr__Kmp_021	);
    SErr__Kmp_022	:= TranslateStr(Gnavigator,	SErr__Kmp_022	);
    SErr__Kmp_023	:= TranslateStr(Gnavigator,	SErr__Kmp_023	);
    SErr__Kmp_024	:= TranslateStr(Gnavigator,	SErr__Kmp_024	);
    SErr__Kmp_025	:= TranslateStr(Gnavigator,	SErr__Kmp_025	);
    SErr__Kmp_026	:= TranslateStr(Gnavigator,	SErr__Kmp_026	);
    SErr__Kmp_027	:= TranslateStr(Gnavigator,	SErr__Kmp_027	);

			
    SGNav_Kmp_001	:= TranslateStr(Gnavigator,	SGNav_Kmp_001	);
    SGNav_Kmp_002	:= TranslateStr(Gnavigator,	SGNav_Kmp_002	);
    SGNav_Kmp_003	:= TranslateStr(Gnavigator,	SGNav_Kmp_003	);
    SGNav_Kmp_004	:= TranslateStr(Gnavigator,	SGNav_Kmp_004	);
    SGNav_Kmp_005	:= TranslateStr(Gnavigator,	SGNav_Kmp_005	);
    SGNav_Kmp_006	:= TranslateStr(Gnavigator,	SGNav_Kmp_006	);
    SGNav_Kmp_007	:= TranslateStr(Gnavigator,	SGNav_Kmp_007	);
    SGNav_Kmp_008	:= TranslateStr(Gnavigator,	SGNav_Kmp_008	);
    SGNav_Kmp_009	:= TranslateStr(Gnavigator,	SGNav_Kmp_009	);
    SGNav_Kmp_010	:= TranslateStr(Gnavigator,	SGNav_Kmp_010	);
    SGNav_Kmp_011	:= TranslateStr(Gnavigator,	SGNav_Kmp_011	);
    SGNav_Kmp_012	:= TranslateStr(Gnavigator,	SGNav_Kmp_012	);
    SGNav_Kmp_013	:= TranslateStr(Gnavigator,	SGNav_Kmp_013	);
    SGNav_Kmp_014	:= TranslateStr(Gnavigator,	SGNav_Kmp_014	);
    SGNav_Kmp_015	:= TranslateStr(Gnavigator,	SGNav_Kmp_015	);
    SGNav_Kmp_016	:= TranslateStr(Gnavigator,	SGNav_Kmp_016	);
    SGNav_Kmp_017	:= TranslateStr(Gnavigator,	SGNav_Kmp_017	);
    SGNav_Kmp_018	:= TranslateStr(Gnavigator,	SGNav_Kmp_018	);
    SGNav_Kmp_019	:= TranslateStr(Gnavigator,	SGNav_Kmp_019	);
    SGNav_Kmp_020	:= TranslateStr(Gnavigator,	SGNav_Kmp_020	);
    SGNav_Kmp_021	:= TranslateStr(Gnavigator,	SGNav_Kmp_021	);
    SGNav_Kmp_022	:= TranslateStr(Gnavigator,	SGNav_Kmp_022	);
    SGNav_Kmp_023	:= TranslateStr(Gnavigator,	SGNav_Kmp_023	);
    SGNav_Kmp_024	:= TranslateStr(Gnavigator,	SGNav_Kmp_024	);
    SGNav_Kmp_025	:= TranslateStr(Gnavigator,	SGNav_Kmp_025	);
    SGNav_Kmp_026	:= TranslateStr(Gnavigator,	SGNav_Kmp_026	);
    SGNav_Kmp_027	:= TranslateStr(Gnavigator,	SGNav_Kmp_027	);
    SGNav_Kmp_028	:= TranslateStr(Gnavigator,	SGNav_Kmp_028	);
    SGNav_Kmp_029	:= TranslateStr(Gnavigator,	SGNav_Kmp_029	);
    SGNav_Kmp_030	:= TranslateStr(Gnavigator,	SGNav_Kmp_030	);
    SGNav_Kmp_031	:= TranslateStr(Gnavigator,	SGNav_Kmp_031	);
    SGNav_Kmp_032	:= TranslateStr(Gnavigator,	SGNav_Kmp_032	);
    SGNav_Kmp_033	:= TranslateStr(Gnavigator,	SGNav_Kmp_033	);
    SGNav_Kmp_034	:= TranslateStr(Gnavigator,	SGNav_Kmp_034	);

			
    SLNav_Kmp_001	:= TranslateStr(Gnavigator,	SLNav_Kmp_001	);
    SLNav_Kmp_002	:= TranslateStr(Gnavigator,	SLNav_Kmp_002	);
    SLNav_Kmp_003	:= TranslateStr(Gnavigator,	SLNav_Kmp_003	);
    SLNav_Kmp_004	:= TranslateStr(Gnavigator,	SLNav_Kmp_004	);
    SLNav_Kmp_005	:= TranslateStr(Gnavigator,	SLNav_Kmp_005	);
    SLNav_Kmp_006	:= TranslateStr(Gnavigator,	SLNav_Kmp_006	);
    SLNav_Kmp_007	:= TranslateStr(Gnavigator,	SLNav_Kmp_007	);
    SLNav_Kmp_008	:= TranslateStr(Gnavigator,	SLNav_Kmp_008	);
    SLNav_Kmp_009	:= TranslateStr(Gnavigator,	SLNav_Kmp_009	);
    SLNav_Kmp_010	:= TranslateStr(Gnavigator,	SLNav_Kmp_010	);
    SLNav_Kmp_011	:= TranslateStr(Gnavigator,	SLNav_Kmp_011	);
    SLNav_Kmp_012	:= TranslateStr(Gnavigator,	SLNav_Kmp_012	);
    SLNav_Kmp_013	:= TranslateStr(Gnavigator,	SLNav_Kmp_013	);
    SLNav_Kmp_014	:= TranslateStr(Gnavigator,	SLNav_Kmp_014	);
    SLNav_Kmp_015	:= TranslateStr(Gnavigator,	SLNav_Kmp_015	);
    SLNav_Kmp_016	:= TranslateStr(Gnavigator,	SLNav_Kmp_016	);
    SLNav_Kmp_017	:= TranslateStr(Gnavigator,	SLNav_Kmp_017	);
    SLNav_Kmp_018	:= TranslateStr(Gnavigator,	SLNav_Kmp_018	);
    SLNav_Kmp_019	:= TranslateStr(Gnavigator,	SLNav_Kmp_019	);
    SLNav_Kmp_020	:= TranslateStr(Gnavigator,	SLNav_Kmp_020	);
    SLNav_Kmp_021	:= TranslateStr(Gnavigator,	SLNav_Kmp_021	);
    SLNav_Kmp_022	:= TranslateStr(Gnavigator,	SLNav_Kmp_022	);
    SLNav_Kmp_023	:= TranslateStr(Gnavigator,	SLNav_Kmp_023	);

			
    SMugriKmp_001	:= TranslateStr(Gnavigator,	SMugriKmp_001	);
    SMugriKmp_002	:= TranslateStr(Gnavigator,	SMugriKmp_002	);
    SMugriKmp_003	:= TranslateStr(Gnavigator,	SMugriKmp_003	);
    SMugriKmp_004	:= TranslateStr(Gnavigator,	SMugriKmp_004	);
    SMugriKmp_005	:= TranslateStr(Gnavigator,	SMugriKmp_005	);
    SMugriKmp_006	:= TranslateStr(Gnavigator,	SMugriKmp_006	);
    SMugriKmp_007	:= TranslateStr(Gnavigator,	SMugriKmp_007	);
    SMugriKmp_008	:= TranslateStr(Gnavigator,	SMugriKmp_008	);
    SMugriKmp_009	:= TranslateStr(Gnavigator,	SMugriKmp_009	);
    SMugriKmp_010	:= TranslateStr(Gnavigator,	SMugriKmp_010	);
    SMugriKmp_011	:= TranslateStr(Gnavigator,	SMugriKmp_011	);
    SMugriKmp_012	:= TranslateStr(Gnavigator,	SMugriKmp_012	);
    SMugriKmp_013	:= TranslateStr(Gnavigator,	SMugriKmp_013	);
    SMugriKmp_014	:= TranslateStr(Gnavigator,	SMugriKmp_014	);
    SMugriKmp_015	:= TranslateStr(Gnavigator,	SMugriKmp_015	);
    SMugriKmp_016	:= TranslateStr(Gnavigator,	SMugriKmp_016	);
    SMugriKmp_017	:= TranslateStr(Gnavigator,	SMugriKmp_017	);
    SMugriKmp_018	:= TranslateStr(Gnavigator,	SMugriKmp_018	);
    SMugriKmp_019	:= TranslateStr(Gnavigator,	SMugriKmp_019	);

			
    SNLnk_Kmp_001	:= TranslateStr(Gnavigator,	SNLnk_Kmp_001	);
    SNLnk_Kmp_002	:= TranslateStr(Gnavigator,	SNLnk_Kmp_002	);
    SNLnk_Kmp_003	:= TranslateStr(Gnavigator,	SNLnk_Kmp_003	);
    SNLnk_Kmp_004	:= TranslateStr(Gnavigator,	SNLnk_Kmp_004	);
    SNLnk_Kmp_005	:= TranslateStr(Gnavigator,	SNLnk_Kmp_005	);
    SNLnk_Kmp_006	:= TranslateStr(Gnavigator,	SNLnk_Kmp_006	);
    SNLnk_Kmp_007	:= TranslateStr(Gnavigator,	SNLnk_Kmp_007	);
    SNLnk_Kmp_008	:= TranslateStr(Gnavigator,	SNLnk_Kmp_008	);
    SNLnk_Kmp_009	:= TranslateStr(Gnavigator,	SNLnk_Kmp_009	);
    SNLnk_Kmp_010	:= TranslateStr(Gnavigator,	SNLnk_Kmp_010	);
    SNLnk_Kmp_011	:= TranslateStr(Gnavigator,	SNLnk_Kmp_011	);
    SNLnk_Kmp_012	:= TranslateStr(Gnavigator,	SNLnk_Kmp_012	);
    SNLnk_Kmp_013	:= TranslateStr(Gnavigator,	SNLnk_Kmp_013	);
    SNLnk_Kmp_014	:= TranslateStr(Gnavigator,	SNLnk_Kmp_014	);
    SNLnk_Kmp_015	:= TranslateStr(Gnavigator,	SNLnk_Kmp_015	);
    SNLnk_Kmp_016	:= TranslateStr(Gnavigator,	SNLnk_Kmp_016	);
    SNLnk_Kmp_017	:= TranslateStr(Gnavigator,	SNLnk_Kmp_017	);
    SNLnk_Kmp_018	:= TranslateStr(Gnavigator,	SNLnk_Kmp_018	);
    SNLnk_Kmp_019	:= TranslateStr(Gnavigator,	SNLnk_Kmp_019	);
    SNLnk_Kmp_020	:= TranslateStr(Gnavigator,	SNLnk_Kmp_020	);
    SNLnk_Kmp_021	:= TranslateStr(Gnavigator,	SNLnk_Kmp_021	);
    SNLnk_Kmp_022	:= TranslateStr(Gnavigator,	SNLnk_Kmp_022	);
    SNLnk_Kmp_023	:= TranslateStr(Gnavigator,	SNLnk_Kmp_023	);
    SNLnk_Kmp_024	:= TranslateStr(Gnavigator,	SNLnk_Kmp_024	);
    SNLnk_Kmp_025	:= TranslateStr(Gnavigator,	SNLnk_Kmp_025	);
    SNLnk_Kmp_026	:= TranslateStr(Gnavigator,	SNLnk_Kmp_026	);
    SNLnk_Kmp_027	:= TranslateStr(Gnavigator,	SNLnk_Kmp_027	);
    SNLnk_Kmp_028	:= TranslateStr(Gnavigator,	SNLnk_Kmp_028	);
    SNLnk_Kmp_029	:= TranslateStr(Gnavigator,	SNLnk_Kmp_029	);
    SNLnk_Kmp_030	:= TranslateStr(Gnavigator,	SNLnk_Kmp_030	);
    SNLnk_Kmp_031	:= TranslateStr(Gnavigator,	SNLnk_Kmp_031	);
    SNLnk_Kmp_032	:= TranslateStr(Gnavigator,	SNLnk_Kmp_032	);
    SNLnk_Kmp_033	:= TranslateStr(Gnavigator,	SNLnk_Kmp_033	);
    SNLnk_Kmp_034	:= TranslateStr(Gnavigator,	SNLnk_Kmp_034	);

			
    SPoll_Kmp_001	:= TranslateStr(Gnavigator,	SPoll_Kmp_001	);
    SPoll_Kmp_002	:= TranslateStr(Gnavigator,	SPoll_Kmp_002	);
    SPoll_Kmp_003	:= TranslateStr(Gnavigator,	SPoll_Kmp_003	);
    SPoll_Kmp_004	:= TranslateStr(Gnavigator,	SPoll_Kmp_004	);
    SPoll_Kmp_005	:= TranslateStr(Gnavigator,	SPoll_Kmp_005	);
			
			
    SPrn_Dlg_001	:= TranslateStr(Gnavigator,	SPrn_Dlg_001	);
    SPrn_Dlg_002	:= TranslateStr(Gnavigator,	SPrn_Dlg_002	);
    SPrn_Dlg_003	:= TranslateStr(Gnavigator,	SPrn_Dlg_003	);

			
    SProts_001	:= TranslateStr(Gnavigator,	SProts_001	);
    SProts_002	:= TranslateStr(Gnavigator,	SProts_002	);
    SProts_003	:= TranslateStr(Gnavigator,	SProts_003	);
    SProts_004	:= TranslateStr(Gnavigator,	SProts_004	);
    SProts_005	:= TranslateStr(Gnavigator,	SProts_005	);
    SProts_006	:= TranslateStr(Gnavigator,	SProts_006	);
    SProts_007	:= TranslateStr(Gnavigator,	SProts_007	);
    SProts_008	:= TranslateStr(Gnavigator,	SProts_008	);
    SProts_009	:= TranslateStr(Gnavigator,	SProts_009	);
    SProts_010	:= TranslateStr(Gnavigator,	SProts_010	);
    SProts_011	:= TranslateStr(Gnavigator,	SProts_011	);
    SProts_012	:= TranslateStr(Gnavigator,	SProts_012	);
    SProts_013	:= TranslateStr(Gnavigator,	SProts_013	);
    SProts_014	:= TranslateStr(Gnavigator,	SProts_014	);
    SProts_015	:= TranslateStr(Gnavigator,	SProts_015	);
    SProts_016	:= TranslateStr(Gnavigator,	SProts_016	);
    SProts_017	:= TranslateStr(Gnavigator,	SProts_017	);
    SProts_018	:= TranslateStr(Gnavigator,	SProts_018	);
    SProts_019	:= TranslateStr(Gnavigator,	SProts_019	);
    SProts_020	:= TranslateStr(Gnavigator,	SProts_020	);
    SProts_021	:= TranslateStr(Gnavigator,	SProts_021	);
    SProts_022	:= TranslateStr(Gnavigator,	SProts_022	);
    SProts_023	:= TranslateStr(Gnavigator,	SProts_023	);
    SProts_024	:= TranslateStr(Gnavigator,	SProts_024	);
    SProts_025	:= TranslateStr(Gnavigator,	SProts_025	);
    SProts_026	:= TranslateStr(Gnavigator,	SProts_026	);
    SProts_027	:= TranslateStr(Gnavigator,	SProts_027	);
    SProts_028	:= TranslateStr(Gnavigator,	SProts_028	);
    SProts_029	:= TranslateStr(Gnavigator,	SProts_029	);
    SProts_030	:= TranslateStr(Gnavigator,	SProts_030	);
    SProts_031	:= TranslateStr(Gnavigator,	SProts_031	);
    SProts_032	:= TranslateStr(Gnavigator,	SProts_032	);
    SProts_033	:= TranslateStr(Gnavigator,	SProts_033	);
    SProts_034	:= TranslateStr(Gnavigator,	SProts_034	);
    SProts_035	:= TranslateStr(Gnavigator,	SProts_035	);
    SProts_036	:= TranslateStr(Gnavigator,	SProts_036	);
    SProts_037	:= TranslateStr(Gnavigator,	SProts_037	);
    SProts_038	:= TranslateStr(Gnavigator,	SProts_038	);
    SProts_039	:= TranslateStr(Gnavigator,	SProts_039	);
    SProts_040	:= TranslateStr(Gnavigator,	SProts_040	);
    SProts_041	:= TranslateStr(Gnavigator,	SProts_041	);
    SProts_042	:= TranslateStr(Gnavigator,	SProts_042	);

    SPsrc_Kmp_001	:= TranslateStr(Gnavigator,	SPsrc_Kmp_001	);
    SPsrc_Kmp_002	:= TranslateStr(Gnavigator,	SPsrc_Kmp_002	);
    SPsrc_Kmp_003	:= TranslateStr(Gnavigator,	SPsrc_Kmp_003	);
    SPsrc_Kmp_004	:= TranslateStr(Gnavigator,	SPsrc_Kmp_004	);
    SPsrc_Kmp_005	:= TranslateStr(Gnavigator,	SPsrc_Kmp_005	);
    SPsrc_Kmp_006	:= TranslateStr(Gnavigator,	SPsrc_Kmp_006	);
    SPsrc_Kmp_007	:= TranslateStr(Gnavigator,	SPsrc_Kmp_007	);
    SPsrc_Kmp_008	:= TranslateStr(Gnavigator,	SPsrc_Kmp_008	);
    SPsrc_Kmp_009	:= TranslateStr(Gnavigator,	SPsrc_Kmp_009	);
    SPsrc_Kmp_010	:= TranslateStr(Gnavigator,	SPsrc_Kmp_010	);
    SPsrc_Kmp_011	:= TranslateStr(Gnavigator,	SPsrc_Kmp_011	);

			
    SQNav_Kmp_013	:= TranslateStr(Gnavigator,	SQNav_Kmp_013	);
    SQNav_Kmp_014	:= TranslateStr(Gnavigator,	SQNav_Kmp_014	);
    SQNav_Kmp_015	:= TranslateStr(Gnavigator,	SQNav_Kmp_015	);
    SQNav_Kmp_016	:= TranslateStr(Gnavigator,	SQNav_Kmp_016	);
    SQNav_Kmp_017	:= TranslateStr(Gnavigator,	SQNav_Kmp_017	);
    SQNav_Kmp_018	:= TranslateStr(Gnavigator,	SQNav_Kmp_018	);
    SQNav_Kmp_019	:= TranslateStr(Gnavigator,	SQNav_Kmp_019	);
    SQNav_Kmp_020	:= TranslateStr(Gnavigator,	SQNav_Kmp_020	);
    SQNav_Kmp_021	:= TranslateStr(Gnavigator,	SQNav_Kmp_021	);
    SQNav_Kmp_022	:= TranslateStr(Gnavigator,	SQNav_Kmp_022	);
    SQNav_Kmp_023	:= TranslateStr(Gnavigator,	SQNav_Kmp_023	);
    SQNav_Kmp_024	:= TranslateStr(Gnavigator,	SQNav_Kmp_024	);
    SQNav_Kmp_025	:= TranslateStr(Gnavigator,	SQNav_Kmp_025	);
    SQNav_Kmp_026	:= TranslateStr(Gnavigator,	SQNav_Kmp_026	);
    SQNav_Kmp_027	:= TranslateStr(Gnavigator,	SQNav_Kmp_027	);
    SQNav_Kmp_028	:= TranslateStr(Gnavigator,	SQNav_Kmp_028	);
    SQNav_Kmp_029	:= TranslateStr(Gnavigator,	SQNav_Kmp_029	);
    SQNav_Kmp_030	:= TranslateStr(Gnavigator,	SQNav_Kmp_030	);

    SQrPreDlg_001	:= TranslateStr(Gnavigator,	SQrPreDlg_001	);
    SQrPreDlg_002	:= TranslateStr(Gnavigator,	SQrPreDlg_002	);

    SQwf_Form_001	:= TranslateStr(Gnavigator,	SQwf_Form_001	);
    SQwf_Form_002	:= TranslateStr(Gnavigator,	SQwf_Form_002	);
    SQwf_Form_003	:= TranslateStr(Gnavigator,	SQwf_Form_003	);
    SQwf_Form_004	:= TranslateStr(Gnavigator,	SQwf_Form_004	);
    SQwf_Form_005	:= TranslateStr(Gnavigator,	SQwf_Form_005	);
    SQwf_Form_006	:= TranslateStr(Gnavigator,	SQwf_Form_006	);
    SQwf_Form_007	:= TranslateStr(Gnavigator,	SQwf_Form_007	);

    SSort_Dlg_001	:= TranslateStr(Gnavigator,	SSort_Dlg_001	);
    SSort_Dlg_002	:= TranslateStr(Gnavigator,	SSort_Dlg_002	);
    SSort_Dlg_003	:= TranslateStr(Gnavigator,	SSort_Dlg_003	);

    SSql_Dlg_001	:= TranslateStr(Gnavigator,	SSql_Dlg_001	);
    SSql_Dlg_002	:= TranslateStr(Gnavigator,	SSql_Dlg_002	);
    SSql_Dlg_003	:= TranslateStr(Gnavigator,	SSql_Dlg_003	);

    STools_001	:= TranslateStr(Gnavigator,	STools_001	);
    STools_002	:= TranslateStr(Gnavigator,	STools_002	);
    STools_003	:= TranslateStr(Gnavigator,	STools_003	);
    STools_004	:= TranslateStr(Gnavigator,	STools_004	);
    STools_005	:= TranslateStr(Gnavigator,	STools_005	);
    STools_006	:= TranslateStr(Gnavigator,	STools_006	);
    STools_007	:= TranslateStr(Gnavigator,	STools_007	);
    STools_008	:= TranslateStr(Gnavigator,	STools_008	);
    STools_009	:= TranslateStr(Gnavigator,	STools_009	);
    STools_010	:= TranslateStr(Gnavigator,	STools_010	);

    Replace_001	:= TranslateStr(Gnavigator,	Replace_001);
    Replace_002	:= TranslateStr(Gnavigator,	Replace_002);
    Replace_003	:= TranslateStr(Gnavigator,	Replace_003);
    Replace_004	:= TranslateStr(Gnavigator,	Replace_004);
    Replace_005	:= TranslateStr(Gnavigator,	Replace_005);
    Replace_006	:= TranslateStr(Gnavigator,	Replace_006);

    SUSes_001	:= TranslateStr(Gnavigator,	SUSes_001);

    SDfltRep_001 := TranslateStr(Gnavigator,	SDfltRep_001);

    SFltrFrm_001 := TranslateStr(Gnavigator,	SFltrFrm_001);

    WordPrn_001 := TranslateStr(Gnavigator,	WordPrn_001);
    ExcelPrn_001 := TranslateStr(Gnavigator,	ExcelPrn_001);
  end;
end;

end.
