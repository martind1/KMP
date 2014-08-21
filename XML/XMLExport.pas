unit XMLExport;
(* XML erstellen anhand einer oder mehrerer Datenbanktabellen.
   Optionen/Features können flexibel erweitert werden.
   Typbibliothek: Mocrosoft XML Version 2.0  -> MSXML_TLB.PAS

   XML Struktur:
   <DB1 Attr1="Attr1">              -- Optionen nur als Attribute.
     <Table1>                       -- Als Elemente sind nur Tablenames erlaubt
       <Name>Tablename</Name>       -- Name der Tabelle für INSERT
       ...                          -- andere Tabellenoptionen
       <ROW>                        -- für jede Zeile
         <Feld1>FeldinhaltToHtml</Feld1>
         ..                         -- weitere Tabellenfelder
       </ROW>
       <ROW>                        -- nächste Zeile
       ...
       </ROW>
     </Table1>
     <Table2>                        -- nächste Tabelle
     ...
     </Table2
   </DB1>                           -- Ende

23.08.02 MD  Erstellt
24.08.02 MD  Meta
26.08.02 MD  Parser, Import
27.08.02 MD  <META> ersetzt durch <FIELDS>
             PrimaryKey, Einfügen einer Row nur wenn PKey noch nicht vorhanden
22.07.03 MD  neues Schema V2.0 siehe Idee.txt
10.05.04 MD  Transaktionen bei: Test Lawa (IBase Blobs, ORA Blobs)
12.09.07     Import: OverwriteDataset: verwendet :Parameter
18.09.07 MD  XmlExpVersion 1.0.2: pro Table:
               <FORMAT>
                 ShortDateFormat="m/d/yyyy"
                 LongTimeFormat="AMPM h:mm:ss AMPM"
                 DecimalSeparator="."
                 DateSeparator
                 TimeSeparator
                 TimeAMString
                 TimePMString
               </FORMAT>
28.03.10 MD  nur Felder in <FIELDS /> übernehmen (für eanv-Ergänzung)
12.04.10 md  keine Sql-Berechnete Felder übernehmen (wird von BDE nicht erkannt)
             Tipp: Um bestimmte Felder nicht zu übernehmen, entfernt man sie
                   in <FIELDS>
30.05.12 md  Unidac: Transaction weg (war wg Blobs)
*)
{ TODO -oMD : neues Schema V2.0 siehe Idee.txt }
{ TODO -oMD : rdupOverwrite noch nicht ganz korrekt (letzter ist doppelt, einer fehlt) }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB,  MSXML_TLB,
  UDB__Kmp;

const
  //XmlExpVersion = '1.0';       //noch ohne Table-Qualifier
  //XmlExpVersion = '1.0.1';       //mit CDATA, Base64
  XmlExpVersion = '1.0.2';       //mit FORMAT, SHORTDATEFORMAT, LONGTIMEFORMAT, DECIMALSEPARATOR

  sDATABASE = 'DATABASE';      //fester Tagbezeichner
  //sTABLE = 'TABLE';            //fester Tagbezeichner
  sROW = 'ROW';                //fester Tagbezeichner
  sFIELDS = 'FIELDS';          //fester Tagbezeichner
  sPKEY = 'PKEY';
  sFORMAT = 'FORMAT';
    sShortDateFormat = 'ShortDateFormat';
    sLongTimeFormat = 'LongTimeFormat';
    sDecimalSeparator = 'DecimalSeparator';
    sDateSeparator = 'DateSeparator';
    sTimeSeparator = 'TimeSeparator';
    sTimeAMString = 'TimeAMString';
    sTimePMString = 'TimePMString';
  sCreatedAt = 'CreatedAt';
  sCreatedBy = 'CreatedBy';
  sXmlExpVersion = 'XmlExpVersion';
  sAlias = 'Alias';
  sServerName = 'ServerName';
  sTableName = 'Name';
  sRowCount = 'Count';
  sSql = 'Sql';
  sFieldType = 'Type';
  sFieldSize = 'Size';
  sPrecision = 'Precision';
  sDisplayLabel = 'Display';
  sRowPKey = 'PKey';

type
  TProcessNodeEvent = procedure (Sender: TObject; Node: IXMLDomNode; Level: Integer) of object;

  TRowDuplicates = (rdupIgnore,          //nicht überschreiben
                    rdupAccept,          //doppelte erlauben
                    rdupError,           //Fehler wenn vorhanden
                    rdupOverwrite);      //Überschreiben wenn vorhanden

  TPKeyObject = class(TObject)
  public
    { Public-Deklarationen }
    El: IXMLDomElement;
    constructor Create(XMLDomElement: IXMLDomElement);
  end;

  TLocaleRec = record
                 DecimalSeparator: Char;
                 DateSeparator: Char;
                 ShortDateFormat: string;
                 TimeSeparator: Char;
                 TimeAMString: string;
                 TimePMString: string;
                 LongTimeFormat: string;
               end;

  TTableObject = class(TObject)
  private
  public
    { Public-Deklarationen }
    Handle: integer;                 //Identifizierung/Index in Liste
    DataSet: TDataSet;
    TableName: string;
    RowCount: integer;               //Anzahl Datensätze
    StoredRowCount: integer;         //Anzahl Datensätze wie gespeichert (Import)
    ProcessedRowCount: integer;      //Anzahl Datensätze verarbeitet (nicht unbedingt importiert)
    AktPKey: string;                 //für Import
    Sql: string;
    IndexFields: string;             //Feldnamen mit ';' getrennt
    PKeys: TStringList;              //Sortierte Liste der Primärschlüssel und El
    FieldList: TStringList;          //Liste der Feldnamen (Load)
    TableEl: IXMLDomElement;
    CountAttr: IXMLDOMAttribute;     //Anzahl
    MetaAdded: boolean;              //Flag ob Metadaten hinzugefügt wurden
    OverwriteBtn: Word;              //Speichern der letzten Benutzerantwort
    LocaleRec: TLocaleRec;           //Locale der Xml-Daten für Import
    constructor Create;
    destructor Destroy; override;
  end;

  TXMLParser = class(TObject)
  private
    { Private-Deklarationen }
    FDOMDocument: IXMLDOMDocument;    //das XML Hauptobjekt
    FBeforeProcessNode: TProcessNodeEvent;
    FAfterProcessNode: TProcessNodeEvent;
    procedure DoBeforeProcessNode(Node: IXMLDomNode; Level: Integer);
    procedure DoAfterProcessNode(Node: IXMLDomNode; Level: Integer);
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    ProtMode: integer;             //0=kein Protokoll,  1=ProtP
    constructor Create(DOMDocument: IXMLDOMDocument);
    procedure SetProcess(BeforeProcessNode, AfterProcessNode: TProcessNodeEvent);
    procedure ProcessNode(Node: IXMLDomNode; Level: Integer);
    procedure Process;
    //Properties:
    property BeforeProcessNode: TProcessNodeEvent read FBeforeProcessNode write FBeforeProcessNode;
    property AfterProcessNode: TProcessNodeEvent read FAfterProcessNode write FAfterProcessNode;
  end;

  TXMLBase = class(TComponent)
  private
    //Einrücken:
    procedure LFAfterProcessNode(Sender: TObject; Node: IXMLDomNode; Level: Integer);
    procedure LFBeforeProcessNode(Sender: TObject; Node: IXMLDomNode; Level: Integer);
  protected
    FDOMDocument: IXMLDOMDocument;    //das XML Hauptobjekt
  end;

  //Utility Objekt um eigene XMLs zu erstellen
  TXMLWriter = class(TXMLBase)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    ProtMode: integer;             //0=kein Protokoll,  1=ProtP
    constructor Create(AOwner: TComponent); override;
    procedure SetDocComment(const Param, Value: string);    //das XML Hauptobjekt
    function AddField(ParentEl: IXMLDomElement; aAttribute, aValue: string): IXMLDomElement;
    function AddNode(ParentEl: IXMLDomElement; aText: string): IXMLDomElement;
    procedure SaveToFile(const FileName: string);
  end;


 TXMLExport = class(TXMLBase)
  private
    { Private-Deklarationen }
    FTableList: TStringList;
    FRootEl: IXMLDomElement;          //das XML Root Element 'DATABASE'
    //FRootNode: IXMLDomNode;           //der Root Knoten des RootEl
    FParser: TXMLParser;
    FFormatLF: boolean;               //True = Linefeeds hinzufügen damit besser lesbar
    FIncludeMeta: boolean;            //True = Metadaten hinzufügen
    FRowDuplicates: TRowDuplicates;   //Verhalten bei InsertRow
    procedure AddMeta(ATableHandle: integer);
    function GetXMLParser: TXMLParser;
    function GetTableCount: integer;
    function GetTables(Index: integer): TTableObject;
    { Import }
    procedure LoadBeforeProcessNode(Sender: TObject; Node: IXMLDomNode; Level: Integer);
    procedure LoadAfterProcessNode(Sender: TObject; Node: IXMLDomNode; Level: Integer); //für LoadFromFile
    procedure ImpBeforeProcessNode(Sender: TObject; Node: IXMLDomNode; Level: Integer);
    procedure ImpAfterProcessNode(Sender: TObject; Node: IXMLDomNode; Level: Integer);
    procedure OverwriteDataset(aTblName: string; aDataset: TDataset; aFieldList: TStrings);
    function GetFieldValue(AField: TField): string;
    function GetPKey(PKeyFields: string; ADataSet: TDataSet): string;
  protected
    { Protected-Deklarationen }
    LFAdded: boolean;                  //Flag ob Linefeeds hinzugefügt wurden
    ImpStep: integer;                  //Imp
    ImpTable: TTableObject;            //Imp
  public
    { Public-Deklarationen }
    OverwriteBtn: Word;              //Vorgabe der Benutzerantwort für Import
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddDatabase(ADatabase: TuDataBase);
    function AddTable(aTableName: string; aDataSet: TDataSet): integer;
    procedure InsertRow(ATableHandle: integer);
    procedure AddRows(ATableHandle: integer);
    procedure SaveToFile(const FileName: string);
    procedure LoadFromFile(const FileName: string);
    procedure AddLF;
    procedure SetRootAttr(const Param, Value: string);
    procedure SetDocComment(const Param, Value: string);
    { Import }
    function ImportTable(aTableName: string; aDataSet: TDataSet): integer;
    procedure ImporTuDataBase(aDatabase: TuDataBase); //für ImportTable
    { Properties }
    property Parser: TXMLParser read GetXMLParser;
    property TableCount: integer read GetTableCount;
    property Tables[Index: integer]: TTableObject read GetTables;
  published
    { Published-Deklarationen }
    property FormatLF: boolean read FFormatLF write FFormatLF;
    property IncludeMeta: boolean read FIncludeMeta write FIncludeMeta;
    property RowDuplicates: TRowDuplicates read FRowDuplicates write FRowDuplicates;
  end;

  function NodeTypeStr(NodeType: integer): string;
  procedure LocaleToSys(L: TLocaleRec);
  procedure SysToLocale(var L: TLocaleRec);

implementation

uses
  ComObj,
  Prots, GNav_Kmp, DPos_Kmp, Err__Kmp, Flddedlg, AbortDlg, 
  DIMime, DIMimeStreams,
  DBAccess, UQue_Kmp, USes_Kmp;

{ ohne Klasse }

procedure LocaleToSys(L: TLocaleRec);
begin
  FormatSettings.DecimalSeparator := L.DecimalSeparator;
  FormatSettings.DateSeparator := L.DateSeparator;
  FormatSettings.ShortDateFormat := L.ShortDateFormat;
  FormatSettings.TimeSeparator := L.TimeSeparator;
  FormatSettings.TimeAMString := L.TimeAMString;
  FormatSettings.TimePMString := L.TimePMString;
  FormatSettings.LongTimeFormat := L.LongTimeFormat;
end;

procedure SysToLocale(var L: TLocaleRec);
begin
  L.DecimalSeparator := FormatSettings.DecimalSeparator;
  L.DateSeparator := FormatSettings.DateSeparator;
  L.ShortDateFormat := FormatSettings.ShortDateFormat;
  L.TimeSeparator := FormatSettings.TimeSeparator;
  L.TimeAMString := FormatSettings.TimeAMString;
  L.TimePMString := FormatSettings.TimePMString;
  L.LongTimeFormat := FormatSettings.LongTimeFormat;
end;

function NodeTypeStr(NodeType: integer): string;
begin                                       //für Protokollierung
//  NODE_INVALID = $00000000;
//  NODE_ELEMENT = $00000001;
//  NODE_ATTRIBUTE = $00000002;
//  NODE_TEXT = $00000003;
//  NODE_CDATA_SECTION = $00000004;
//  NODE_ENTITY_REFERENCE = $00000005;
//  NODE_ENTITY = $00000006;
//  NODE_PROCESSING_INSTRUCTION = $00000007;
//  NODE_COMMENT = $00000008;
//  NODE_DOCUMENT = $00000009;
//  NODE_DOCUMENT_TYPE = $0000000A;
//  NODE_DOCUMENT_FRAGMENT = $0000000B;
//  NODE_NOTATION = $0000000C;
  case (NodeType) of
    NODE_INVALID: result := 'NODE_INVALID';
    NODE_ELEMENT: result := 'NODE_ELEMENT';
    NODE_ATTRIBUTE: result := 'NODE_ATTRIBUTE';
    NODE_TEXT: result := 'NODE_TEXT';
    NODE_CDATA_SECTION: result := 'NODE_CDATA_SECTION';
    NODE_ENTITY_REFERENCE: result := 'NODE_ENTITY_REFERENCE';
    NODE_ENTITY: result := 'NODE_ENTITY';
    NODE_PROCESSING_INSTRUCTION: result := 'NODE_PROCESSING_INSTRUCTION';
    NODE_COMMENT: result := 'NODE_COMMENT';
    NODE_DOCUMENT: result := 'NODE_DOCUMENT';
    NODE_DOCUMENT_TYPE: result := 'NODE_DOCUMENT_TYPE';
    NODE_DOCUMENT_FRAGMENT: result := 'NODE_DOCUMENT_FRAGMENT';
    NODE_NOTATION: result := 'NODE_NOTATION';
  else
    result := Format('NODE_%d???', [NodeType]);
  end;
end;

{ TPKeyObject }

constructor TPKeyObject.Create(XMLDomElement: IXMLDomElement);
begin
  El := XMLDomElement;
end;

{ TTableObject }

constructor TTableObject.Create;
begin
  PKeys := TStringList.Create;
  PKeys.Sorted := true;
  PKeys.Duplicates := dupIgnore;  //wird später ersetzt
  FieldList := TStringList.Create;
  SysToLocale(LocaleRec);         //zur Sicherheit immer definiert
end;

destructor TTableObject.Destroy;
var
  I: integer;
begin
  for I := 0 to PKeys.Count - 1 do
    TPKeyObject(PKeys.Objects[I]).Free;
  PKeys.Free;
  FieldList.Free;
  inherited;
end;

{ TXMLParser }

constructor TXMLParser.Create(DOMDocument: IXMLDOMDocument);
begin
  FDOMDocument := DOMDocument;
  ProtMode := ord(Sysparam.ProtBeforeOpen);  //ProtP - nur nach ListBox
end;

procedure TXMLParser.DoBeforeProcessNode(Node: IXMLDomNode;
  Level: Integer);
begin
  if ProtMode = 1 then
  try
    if Node = nil then
      ProtP('Node = nil', [0]) else
      ProtP('%.*s<%s>=(%.30s) %s', [Level*2, '                              ',
        Node.NodeName, Node.NodeValue, NodeTypeStr(Node.NodeType)]);
  except
    Debug0;
  end;
  if assigned(FBeforeProcessNode) then
    FBeforeProcessNode(self, Node, Level);
end;

procedure TXMLParser.DoAfterProcessNode(Node: IXMLDomNode;
  Level: Integer);
begin
  if assigned(FAfterProcessNode) then
  try
    //07.04.04 GNavigator.DB1.StartTransaction;
    FAfterProcessNode(self, Node, Level);
    //07.04.04 GNavigator.DB1.Commit;
  except on E:Exception do
    begin
      EProt(self, E, 'TXMLParser.DoAfterProcessNode', [0]);
      try
        //GNavigator.DB1.RollBack;
      except on E1:Exception do
        //EProt(self, E, 'TXMLParser Rollback', [0]);
      end;
      raise;
    end;
  end;
  if ProtMode = 1 then
    ProtP('%.*s</%s> %s', [Level*2, '                              ',
      Node.NodeName, NodeTypeStr(Node.NodeType)]);
end;

procedure TXMLParser.ProcessNode(Node: IXMLDomNode; Level: Integer);
//Rekursiv die Knoten durchlaufen
var
  ChildNode, LastChildNode: IXMLDomNode;
  Attributes: IXMLDOMNamedNodeMap;
  Attribute: IXMLDOMNode;
  AttrCount, I: Integer;
begin
  DoBeforeProcessNode(Node, Level);
  if Node.NodeType <> NODE_DOCUMENT then
    Inc(Level);
  if Node.Attributes <> nil then
  begin
    Attributes := Node.Attributes;
    AttrCount := Attributes.Length;
    for I := 0 to AttrCount - 1 do
    begin      // Output any attributes on this element
      Attribute := Attributes.Item[I];
      ProcessNode(Attribute, Level);
    end;
  end;
  ChildNode := Node.FirstChild;
  LastChildNode := nil;
  while ChildNode <> nil do
  begin
    LastChildNode := ChildNode;
    ProcessNode(ChildNode, Level);
    ChildNode := ChildNode.NextSibling;
  end;
//  if LastChildNode <> nil then
//    DoAfterProcessNode(LastChildNode, Level - 1);
  if Node.NodeType <> NODE_DOCUMENT then
    Dec(Level);
  DoAfterProcessNode(Node, Level);
end;

procedure TXMLParser.Process;
begin
  ProcessNode(FDOMDocument, 0);
end;

procedure TXMLParser.SetProcess(BeforeProcessNode,
  AfterProcessNode: TProcessNodeEvent);
begin
  FBeforeProcessNode := BeforeProcessNode;
  FAfterProcessNode := AfterProcessNode;
end;

{ TXMLBase }

procedure TXMLBase.LFBeforeProcessNode(Sender: TObject; Node: IXMLDomNode; Level: Integer);
var
  TextNode: IXMLDOMText;
begin //Ereignis aufrufen: Node wird danach durchlaufen
  if (Node <> nil) and
     (Node.NodeType in [NODE_ELEMENT, NODE_ENTITY_REFERENCE]) then
  begin
    if (Node.ParentNode <> nil) and
       (Node.ParentNode.NodeType in [NODE_ELEMENT, NODE_ENTITY_REFERENCE]) then
    begin  //Zeilenumbruch:
      TextNode := FDOMDocument.createTextNode(
        Format('%s%.*s', [#13#10, Level*2, '                    ']));
      Node.ParentNode.InsertBefore(TextNode, Node);
    end;
  end;
end;

procedure TXMLBase.LFAfterProcessNode(Sender: TObject; Node: IXMLDomNode; Level: Integer);
var
  TextNode: IXMLDOMText;
  ChildNode: IXMLDomNode;
begin //Ereignis aufrufen: Node wurde durchlaufen
  ChildNode := Node.LastChild;
  if (ChildNode <> nil) and    //hinter Attribut kein LF
     (ChildNode.NodeType in [NODE_ELEMENT, NODE_ENTITY_REFERENCE]) then
  begin
    if (Node <> nil) and
       (Node.NodeType in [NODE_ELEMENT]) then
    begin  //Zeilenumbruch:
      TextNode := FDOMDocument.createTextNode(
        Format('%s%.*s', [#13#10, Level*2, '                    ']));
      Node.AppendChild(TextNode);
    end;
  end;
end;

{ TXMLExport }

function TXMLExport.GetFieldValue(AField: TField): string;
var
  BS: TStream;
  ST: TStringStream;
begin
  if AField = nil then            {beware or FieldIsNull(AField) then}
  begin
    result := '';
  end else
  try
    if AField is TMemoField then
    begin
      result := RemoveTrailCRLF(AField.AsString); {kein CRLF am Ende}
    end else
    if AField is TBlobField then
    begin
      //vor UNI - BS := TBlobStream.Create(TBlobField(AField), bmRead);
      BS := TCustomDADataSet(AField.DataSet).CreateBlobStream(AField, bmRead);
      ST := TStringStream.Create('');
      try
        //Test TBlobField(AField).SaveToFile('c:\lawa\send\zugbild.gif');
        //N := TBlobField(AField).DataSize;
        //ST.CopyFrom(BS, 0);
        MimeEncodeStream(BS, ST);  //BS nach Base64 codieren und nach ST kopieren
        result := ST.DataString;
      finally
        BS.Free;
        ST.Free;
      end;
    end else
    if AField is TNumericField then
    begin
      result := AField.Text;    //NK beschränken
    end else
      result := AField.Asstring;
  except on E:Exception do
    EProt(self, E, 'Fehler bei GetFieldValue', [0]);
  end;
end;

function TXMLExport.GetPKey(PKeyFields: string; ADataSet: TDataSet): string;
//Ergibt Inhalt des Primarykeys entspr. der Feldnamen in PKeyFields, mit ';' getrennt.
var
  AFieldName, NextS: string;
  AField: TField;
  AValue: string;
begin
  result := '';
  AFieldName := PStrTok(PKeyFields, ';', NextS);
  while AFieldName <> '' do
  begin
    AField := ADataSet.FieldByName(AFieldName);
    AValue := GetFieldValue(AField); //CRLF am Ende weg. //AsString; //ab D5 auch für Blobs OK
    AValue := StrCgeChar(AValue, ';', ',');    //';' darf in Feldinhalt nicht auftreten
    AppendTok(result, AValue, ';');
    AFieldName := PStrTok('', ';', NextS);
  end;
end;

function TXMLExport.GetTableCount: integer;
begin
  result := FTableList.Count;
end;

function TXMLExport.GetTables(Index: integer): TTableObject;
begin
  result := nil;
  try
    result := TTableObject(FTableList.Objects[Index]);
  except on E:Exception do
    EError('TableObject[%d] nicht vorhanden: %s', [Index, E.Message]);
  end;
end;

procedure TXMLExport.AddMeta(ATableHandle: integer);
//Metadaten (Feldtypen) ergänzen
var
  ATableObject: TTableObject;
  FieldsEl, FieldEl: IXMLDOMElement;
  Attr: IXMLDOMAttribute;
  I: integer;
  AFieldDef: TFieldDef;
  AField: TField;
  PKeyEl: IXMLDOMElement;
begin
  ATableObject := Tables[ATableHandle];
  if ATableObject.DataSet.FieldDefs.Count > 0 then
  begin
    ATableObject.MetaAdded := true;
    //<FIELDS>
    FieldsEl := FDOMDocument.createElement(sFIELDS);
    ATableObject.TableEl.appendchild(FieldsEl);
    for I := 0 to ATableObject.DataSet.FieldDefs.Count - 1 do
    begin
      AFieldDef := ATableObject.DataSet.FieldDefs.Items[I];
      FieldEl := FDOMDocument.createElement(AFieldDef.Name);
      //mit Attribut:
      Attr := FDOMDocument.createAttribute(SFieldType);
      Attr.Value := FieldTypeStr[AFieldDef.DataType];
      FieldEl.setAttributeNode(Attr);
      if AFieldDef.Size > 0 then
      begin
        Attr := FDOMDocument.createAttribute(SFieldSize);
        Attr.Value := IntToStr(AFieldDef.Size);
        FieldEl.setAttributeNode(Attr);
      end;
      if AFieldDef.Precision > 0 then
      begin
        Attr := FDOMDocument.createAttribute(SPrecision);
        Attr.Value := IntToStr(AFieldDef.Precision);
        FieldEl.setAttributeNode(Attr);
      end;
      AField := ATableObject.DataSet.FieldByName(AFieldDef.Name);
      if (AField <> nil) and (AField.DisplayLabel <> AFieldDef.Name) then
      begin
        Attr := FDOMDocument.createAttribute(SDisplayLabel);
        Attr.Value := AField.DisplayLabel;
        FieldEl.setAttributeNode(Attr);
      end;
      FieldsEl.appendchild(FieldEl);
    end;
    //<PKEY>
    if ATableObject.DataSet is TuQuery then
    begin
      ATableObject.IndexFields :=
        IndexInfo(QueryDatabase(TuQuery(ATableObject.DataSet)),
                  ATableObject.TableName, nil, nil);
      PKeyEl := FDOMDocument.createElement(sPKEY);
      PKeyEl.appendChild(FDOMDocument.createTextNode(ATableObject.IndexFields));
      ATableObject.TableEl.appendchild(PKeyEl);
    end;
  end;
end;

procedure TXMLExport.InsertRow(ATableHandle: integer);
// Datensatz hinzufügen. Test auf Vorhandensein anhand RowDuplicates.
var
  PKey: string;
  IKey: integer;
  ATableObject: TTableObject;
  RowEl, FieldEl: IXMLDOMElement;
  I: integer;
  AField: TField;
  AValue: string;
  Attr: IXMLDOMAttribute;
begin
  ATableObject := Tables[ATableHandle];
  if not ATableObject.MetaAdded and IncludeMeta then
    AddMeta(ATableHandle);
  case RowDuplicates of
    //rdupIgnore: ATableObject.PKeys.Duplicates := dupIgnore; //Dupl nicht einfügen
    rdupAccept: ATableObject.PKeys.Duplicates := dupAccept; //Dupl erlaubt
    rdupIgnore,
    rdupError,
    rdupOverwrite: ATableObject.PKeys.Duplicates := dupError;
  end;
  IKey := 0;
  try
    PKey := GetPKey(ATableObject.IndexFields, ATableObject.DataSet);

    IKey := ATableObject.PKeys.Add(PKey);
  except
    case RowDuplicates of
      rdupIgnore: Exit;
      //rdupAccept: kann nicht vorkommen
      rdupError: EError('Fehler beim Einfügen des doppelten Schlüssels "%s" in "%s"',
                   [PKey, ATableObject.TableName]);
      rdupOverwrite: begin                    //klappt nocht nicht ganz (s.o.)!
        Dec(ATableObject.RowCount);           //Anzahl erniedrigen, da später erhöht
        RowEl := TPKeyObject(ATableObject.PKeys.Objects[IKey]).El;
        TPKeyObject(ATableObject.PKeys.Objects[IKey]).Free;
        if RowEl <> nil then                //ist nil falls von Loadfromfile
          ATableObject.TableEl.RemoveChild(RowEl);
      end;
    end;
  end;

  RowEl := FDOMDocument.createElement(sROW); // Append the ROW element to the TABLE object
  ATableObject.TableEl.appendchild(RowEl);
  ATableObject.PKeys.Objects[IKey] := TPKeyObject.Create(RowEl);

  Attr := FDOMDocument.createAttribute(SRowPKey);
  Attr.Value := PKey; //GetPKey(ATableObject.IndexFields, ATableObject.DataSet);
  RowEl.setAttributeNode(Attr);

  for I := 0 to ATableObject.DataSet.FieldCount - 1 do
  begin
    AField := ATableObject.DataSet.Fields[I];
    AValue := GetFieldValue(AField); //CRLF am Ende weg. //AsString; //ab D5 auch für Blobs OK
    if AValue <> '' then       //leere Felder nicht
    begin
      FieldEl := FDOMDocument.createElement(AField.FieldName);
      if AField is TMemoField then
      begin
        FieldEl.appendChild(FDOMDocument.createCDATASection(AValue));
      end else
      if AField is TBlobField then
      begin   //Binärdaten (base64) nach XML
        FieldEl.Set_dataType('bin.base64');     //somit klappts mit Microsoft. ORG hat keine Lösung :-(
        FieldEl.nodeTypedValue := AValue;       //muß base64 codiert sein
        //FieldEl.nodeTypedValue := Format('<![BASE64[%s]]>', [AValue]);  //macht &Umlaute
        //FieldEl.appendChild(FDOMDocument.createTextNode(Format('<![BASE64[%s]]>', [AValue])));  //macht auch &Umlaute
        {FieldEl.appendChild(FDOMDocument.createCDATASection(
          Format('<![BASE64[%s]]>', [AValue])));    //ungültige Daten wg ']]' }
      end else
      begin
        FieldEl.appendChild(FDOMDocument.createTextNode(AValue));
      end;
      RowEl.appendchild(FieldEl);
    end;
  end;
  Inc(ATableObject.RowCount);           //Anzahl erhöhen
  if ATableObject.CountAttr <> nil then
    ATableObject.CountAttr.Value := IntToStr(ATableObject.RowCount);
end;

procedure TXMLExport.AddRows(ATableHandle: integer);
var
  ATableObject: TTableObject;
begin
  ATableObject := Tables[ATableHandle];
  ATableObject.DataSet.Open;
  ATableObject.DataSet.First;
  while not ATableObject.DataSet.EOF do
  begin
    InsertRow(ATableHandle);
    ATableObject.DataSet.Next;
  end;
end;

function TXMLExport.AddTable(aTableName: string;
  aDataSet: TDataSet): integer;
//ergibt Handle für InsertRow. Wenn vorhanden wird vorhandener Index geliefert.
// groß/klein wird unterschieden
var
  ATableObject: TTableObject;
  Attr: IXMLDOMAttribute;
  El: IXMLDOMElement;
  //TextNode: IXMLDOMText;
  ADatabase: TuDataBase;
begin
  if FRootEl = nil then
  begin
    if aDataSet is TuQuery then
    begin
      ADataBase := TuQuery(aDataSet).Database;
      if (ADataBase = nil) and (aDataSet is TuQuery) then
        ADatabase := QueryDataBase(TuQuery(aDataSet));
    end else
      ADataBase := nil;
    AddDataBase(ADataBase);
  end;

  result := FTableList.IndexOf(aTableName);
  if result >= 0 then
  begin                    //bereits vorhanden (Loadfromfile)
    ATableObject := Tables[result];
    if ATableObject.DataSet = nil then
      ATableObject.DataSet := aDataSet;
  end else
  //if result < 0 then
  begin                    //Neu anlegen
    ATableObject := TTableObject.Create;
    ATableObject.DataSet := aDataSet;
    ATableObject.TableName := aTableName;
    // Append the TABLE element to the DATABASE object:
    ATableObject.TableEl := FDOMDocument.createElement(aTableName);
    FRootEl.appendchild(ATableObject.TableEl);
    //mit Attribut:
    Attr := FDOMDocument.createAttribute(STableName);
    Attr.Value := ATableObject.TableName;
    ATableObject.TableEl.setAttributeNode(Attr);
    //mit Element:
//    El := FDOMDocument.createElement(STableName);
//    El.appendChild(FDOMDocument.createTextNode(ATableObject.TableName));
//    ATableObject.TableEl.appendchild(El);

    ATableObject.CountAttr := FDOMDocument.createAttribute(sRowCount);
    ATableObject.RowCount := 0;           //Anzahl erstmal 0
    ATableObject.CountAttr.Value := IntToStr(ATableObject.RowCount);
    ATableObject.TableEl.setAttributeNode(ATableObject.CountAttr);

    //<SQL>
    if aDataSet is TuQuery then
    begin
      ATableObject.Sql := TuQuery(aDataSet).Text;
      El := FDOMDocument.createElement(sSql);
      El.appendChild(FDOMDocument.createTextNode(
//14.03.14        RemoveTrailCRLF(ATableObject.Sql)));
        RemoveTrailCRLF(QueryText(TuQuery(aDataSet), [qtoOneLine]))));
      ATableObject.TableEl.appendchild(El);
    end;
    //<FORMAT> ab V1.0.2
    El := FDOMDocument.createElement(sFORMAT);
    Attr := FDOMDocument.createAttribute(sShortDateFormat);
    Attr.Value := FormatSettings.ShortDateFormat;
    El.setAttributeNode(Attr);

    Attr := FDOMDocument.createAttribute(sLongTimeFormat);
    Attr.Value := FormatSettings.LongTimeFormat;
    El.setAttributeNode(Attr);

    Attr := FDOMDocument.createAttribute(sDecimalSeparator);
    Attr.Value := FormatSettings.DecimalSeparator;
    El.setAttributeNode(Attr);

    Attr := FDOMDocument.createAttribute(sDateSeparator);
    Attr.Value := FormatSettings.DateSeparator;
    El.setAttributeNode(Attr);
    Attr := FDOMDocument.createAttribute(sTimeSeparator);
    Attr.Value := FormatSettings.TimeSeparator;
    El.setAttributeNode(Attr);
    Attr := FDOMDocument.createAttribute(sTimeAMString);
    Attr.Value := FormatSettings.TimeAMString;
    El.setAttributeNode(Attr);
    Attr := FDOMDocument.createAttribute(sTimePMString);
    Attr.Value := FormatSettings.TimePMString;
    El.setAttributeNode(Attr);

    ATableObject.TableEl.appendchild(El);

    result := FTableList.AddObject(aTableName, ATableObject);
    if IncludeMeta then
      AddMeta(result);
  end;
end;

constructor TXMLExport.Create(AOwner: TComponent);
var
  pi: IXMLDOMProcessingInstruction;
begin
  inherited;
  FormatLF := true;    //Std: Linefeeds zur Formatierung hinzufügen
  IncludeMeta := true;
  FRowDuplicates := rdupOverwrite;  //Standard: überschreiben
  FTableList := TStringList.Create;
  FDOMDocument := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  FDOMDocument.async := false;
  //FDOMDocument.preserveWhiteSpace := true;  //erhält nicht CRLF in Node.Text

  //encoding: ISO-8859-1 = Westeuropa. UTF-8 = 8bit. UTF-16 = 16bit
  //  wenn ohne Angabe dann ISO/IEC 10646, das ist ein Unicode.
  //standalone: wenn Yes dann ist DTD im XML enthalten
  pi := FDOMDocument.createProcessingInstruction('xml', 'version="1.0"');
  //pi := FDOMDocument.createProcessingInstruction('xml', 'version="1.0" encoding="ISO-8859-1"');

  FDOMDocument.insertBefore(pi, FDOMDocument.childNodes.item[0]);

  SetDocComment(sXmlExpVersion, XmlExpVersion);
  SetDocComment(sCreatedBy, ExtractFileName(ParamStr(0))); //ClassName);
  SetDocComment(sCreatedAt, DateTimeToStr(now));
end;

procedure TXMLExport.AddDatabase(ADatabase: TuDataBase);
var
  //TextNode: IXMLDOMText;
  //Attr: IXMLDOMAttribute;
  L: TValueList;
begin
  // Append the root element to the Document object
  FRootEl := FDOMDocument.CreateElement(sDATABASE);
  FDOMDocument.AppendChild(FRootEl);

  if ADatabase <> nil then
  begin
    L := TValueList.Create;
    try
      //als Element:
      //SetRootAttr(sAlias, GNavigator.DB1.AliasName);
      //Als Attribut:
  //    Attr := FDOMDocument.createAttribute(SAlias);
  //    Attr.Value := ADatabase.AliasName;
  //    FRootEl.setAttributeNode(Attr);
      SetRootAttr(sAlias, ADatabase.AliasName);

      USession.GetAliasParams(ADatabase.AliasName, L);
      L.MergeStrings(ADatabase.Params);  {anderer User, Pasw.,..}
      SetRootAttr(sServerName, L.Values['SERVER NAME']);
    except on E:Exception do
      EProt(self, E, 'Fehler bei Session.GetAliasParams', [0]);
    end;
    L.Free;
  end;
end;

destructor TXMLExport.Destroy;
var
  I: integer;
begin
  for I := 0 to FTableList.Count - 1 do
    TTableObject(FTableList.Objects[I]).Free;
  FTableList.Free;
  FParser.Free;
  inherited;
end;

procedure TXMLExport.SetDocComment(const Param, Value: string);
//Kommentar auf Dokumentebene (vor Root-Knoten)
var
  S: string;
  Comment: IXMLDOMComment;
begin
  S := '';
  AppendTok(S, Param, ':');
  AppendTok(S, Value, ' ');
  if S <> '' then
  begin
    Comment := FDOMDocument.CreateComment(S);
    FDOMDocument.appendChild(Comment);
    //FDOMDocument.InsertBefore(Comment, FDOMDocument.childNodes.item[0]);  //Probleme bei InsertBefore von 1.00
    FDOMDocument.InsertBefore(Comment, FDOMDocument.DocumentElement);
  end;
end;

procedure TXMLExport.SetRootAttr(const Param, Value: string);
var          //Datenbank Parameter ergänzen: nur Attribute erlaubt
  Attr: IXMLDOMAttribute;
  I: integer;
  Done: boolean;
begin
  if FRootEl = nil then
    AddDataBase(nil);
  if (Param <> '') and (Value <> '') then
  begin
    Done := false;
    if FRootEl.Attributes <> nil then
    begin
      for I := 0 to FRootEl.Attributes.Length - 1 do
      begin      // Output any attributes on this element
        if FRootEl.Attributes.Item[I].NodeName = Param then
        begin
          FRootEl.Attributes.Item[I].NodeValue := RemoveTrailCRLF(Value);
          Done := true;
          break;
        end;
      end;
    end;
    if not Done then
    begin
      Attr := FDOMDocument.createAttribute(Param);
      Attr.Value := RemoveTrailCRLF(Value);
      FRootEl.setAttributeNode(Attr);
    end;
  end;
end;

procedure TXMLExport.SaveToFile(const FileName: string);
begin
  if FRootEl = nil then
    AddDataBase(nil);
  if FFormatLF then
    AddLF;    //falls ausgewählt dann Formatierung durchführen
  FDOMDocument.Save(FileName);
end;

function TXMLExport.GetXMLParser: TXMLParser;
begin
  if FParser = nil then
    FParser := TXMLParser.Create(FDOMDocument);
  result := FParser;
end;

procedure TXMLExport.AddLF;
begin //Formatieren: Zeilenumbruch hinzufügen
  if not LFAdded then
  try
    //Parser.ProtMode := 1;
    Parser.SetProcess(LFBeforeProcessNode, LFAfterProcessNode); //Aktion festlegen
    Parser.Process;  //Dokument Durchlaufen
  finally
    LFAdded := true;
  end;
end;

{ Import }

procedure TXMLExport.LoadBeforeProcessNode(Sender: TObject;
  Node: IXMLDomNode; Level: Integer);
begin //Tabellenelement durchlaufen
  if Node = nil then
    Exit;
  if (Node.NodeType in [NODE_ATTRIBUTE, NODE_ELEMENT]) and
     (Node.NodeName = SRowCount) then
  begin
    ImpTable.RowCount := StrToIntTol(Node.Text);
  end else
  if (Node.NodeType in [NODE_ATTRIBUTE, NODE_ELEMENT]) and
     (Node.NodeName = SSql) then
  begin
    ImpTable.Sql := Node.Text;
  end else
//  if (Node.NodeType = NODE_ELEMENT] and (Node.NodeName = SRow) then
//  begin
//    ImpTable.PKey
//  end else
  if (Node.NodeType = NODE_ATTRIBUTE) and (Node.NodeName = SRowPKey) then
  begin
    ImpTable.PKeys.AddObject(Node.NodeValue,
      TPKeyObject.Create(IXMLDOMElement(Node.ParentNode)));
  end else
  { FieldList einlesen <FIELDS> }
  if (Node.NodeType = NODE_ELEMENT) and (Node.NodeName = sFIELDS) then
  begin
    ImpTable.FieldList.Clear;
  end else
  if (Node.NodeType = NODE_ELEMENT) and
     (Node.ParentNode.NodeType = NODE_ELEMENT) and
     (Node.ParentNode.NodeName = sFIELDS) then
  begin
    ImpTable.FieldList.Add(Node.NodeName);
  end;
end;

procedure TXMLExport.LoadAfterProcessNode(Sender: TObject;
  Node: IXMLDomNode; Level: Integer);
begin //Ereignis aufrufen: Node wurde durchlaufen
end;

procedure TXMLExport.LoadFromFile(const FileName: string);
var
  Node: IXMLDomNode;
  //Attributes: IXMLDOMNamedNodeMap;
  //Attribute: IXMLDOMNode;
  //AttrCount, I: Integer;
begin
  FDOMDocument.Load(FileName);
  ImpStep := 0;
  FRootEl := FDOMDocument.DocumentElement;
  if FRootEl <> nil then
  begin
    Parser.SetProcess(LoadBeforeProcessNode, LoadAfterProcessNode); //Aktion festlegen
    Node := FDOMDocument.DocumentElement.FirstChild;
    while Node <> nil do
    begin
      ImpTable := TTableObject.Create;
      ImpTable.TableName := Node.NodeName;
      ImpTable.TableEl := IXMLDOMElement(Node);

      Parser.ProcessNode(Node, 0);

      FTableList.AddObject(ImpTable.TableName, ImpTable);

      Node := Node.NextSibling;
    end;
  end;
end;

procedure TXMLExport.ImpBeforeProcessNode(Sender: TObject;
  Node: IXMLDomNode; Level: Integer);
var
  aField: TField;
  aFieldDef: TFieldDef;
  BS: TStream;
  ST: TStringStream;
  //OleVar1: OleVariant;
  //P: ^Byte;
begin
  if Node = nil then
    Exit;
  if (Node.NodeType = NODE_ELEMENT) and (Node.NodeName = sROW) then
  begin
    ImpTable.DataSet.Insert;
  end else
  if (Node.NodeType = NODE_ATTRIBUTE) and (Node.NodeName = SRowPKey) then
  begin
    ImpTable.AktPKey := Node.NodeValue;
  end else
  { TODO -oMD : Parent auf sFORMAT checken }
  if (Node.NodeType = NODE_ATTRIBUTE) and (Node.NodeName = sShortDateFormat) then
  begin
    FormatSettings.ShortDateFormat := Node.NodeValue;
  end else
  if (Node.NodeType = NODE_ATTRIBUTE) and (Node.NodeName = sLongTimeFormat) then
  begin
    FormatSettings.LongTimeFormat := Node.NodeValue;
  end else
  if (Node.NodeType = NODE_ATTRIBUTE) and (Node.NodeName = sDecimalSeparator) then
  begin
    FormatSettings.DecimalSeparator := Char1(Node.NodeValue);
  end else
  if (Node.NodeType = NODE_ATTRIBUTE) and (Node.NodeName = sDateSeparator) then
  begin
    FormatSettings.DateSeparator := Char1(Node.NodeValue);
  end else
  if (Node.NodeType = NODE_ATTRIBUTE) and (Node.NodeName = sTimeSeparator) then
  begin
    FormatSettings.TimeSeparator := Char1(Node.NodeValue);
  end else
  if (Node.NodeType = NODE_ATTRIBUTE) and (Node.NodeName = sTimeAMString) then
  begin
    FormatSettings.TimeAMString := Node.NodeValue;
  end else
  if (Node.NodeType = NODE_ATTRIBUTE) and (Node.NodeName = sTimePMString) then
  begin
    FormatSettings.TimePMString := Node.NodeValue;
  end else
  if (ImpTable <> nil) and (Node.NodeType in [NODE_ELEMENT]) and
     (ImpTable.DataSet.State = dsInsert) then
  begin
    try
      //ProtP('%s=%s', [Node.NodeName, Node.Text]);
      aField := ImpTable.Dataset.FindField(Node.NodeName);
      if (aField <> nil) and (ImpTable.FieldList.Count > 0) and
         (ImpTable.FieldList.IndexOf(Node.NodeName) < 0) then
      begin
        aField := nil;
      end;
      if aField <> nil then
      begin
        aFieldDef := ImpTable.Dataset.FieldDefs.Find(Node.NodeName);
        if aFieldDef.InternalCalcField then
        begin
          aField := nil;
        end;
      end;
      if aField <> nil then
      begin
        if Node.Get_dataType = 'bin.base64' then
        begin
          (* works fine but with IE-Mime
          OleVar1 := Node.nodeTypedValue;
          try
            P := VarArrayLock(OleVar1);
            BS := TBlobStream.Create(TBlobField(aField), bmWrite);
            BS.Write(P^, VarArrayHighBound(OleVar1, 1));
          finally
            VarArrayUnLock(OleVar1);
            BS.Free;
          end;*)
          //UNI 13.06.11 - BS := TBlobStream.Create(TBlobField(aField), bmWrite);
          BS := TCustomDADataSet(AField.DataSet).CreateBlobStream(AField, bmWrite);

          ST := TStringStream.Create(Node.Text);
          try
            MimeDecodeStream(ST, BS);    //unsere DIMime Komponente
          finally
            ST.Free;
            BS.Free;
            //TBlobField(aField).SaveToFile('c:\lawa\send\empfbild.gif');
          end;
        end else
        begin
          aField.AsString := Node.Text;
          if Pos(#10, Node.Text) > 0 then    //in XML steht CRLF und trotzdem macht MSDOM hier LF daraus!
            aField.AsString := ConvertEOL(Node.Text);    //LF -> CRLF
        end;
      end;
    except on E:Exception do
      EProt(self, E, 'Fehler bei Feldname(%s)', [Node.NodeName]);
    end;
  end;
end;

procedure TXMLExport.ImpAfterProcessNode(Sender: TObject;
  Node: IXMLDomNode; Level: Integer);
var
  S: string;
begin
  if (Node.NodeType = NODE_ELEMENT) and (Node.NodeName = sROW) then
  try
    Inc(ImpTable.ProcessedRowCount);
    TDlgAbort.GMessA(ImpTable.ProcessedRowCount, ImpTable.StoredRowCount);
    ImpTable.DataSet.Post;
    Inc(ImpTable.RowCount);
  except on E:Exception do
    begin
      if not EIsIndexFehler(E) then
      begin
        EProt(ImpTable.DataSet, E, 'ImpAfterProcessNode', [0]);
        if not (E is EAbort) then
        begin
          if E is EDatabaseError then  //UNI
            ProtDataSet(ImpTable.DataSet);
          ImpTable.DataSet.Cancel;
          if MessageDlg('Fehler beim Einfügen' + CRLF + E.Message, mtWarning,
             [mbAbort,mbIgnore], 0) = mrAbort then
            raise;
        end else
          ImpTable.DataSet.Cancel;
      end else
      begin
        if not (ImpTable.OverwriteBtn in [mrYesToAll, mrNoToAll]) then
          ImpTable.OverwriteBtn := OverwriteBtn;
        if not (ImpTable.OverwriteBtn in [mrYesToAll, mrNoToAll]) then
        begin
          S := '';
          if ImpTable.DataSet is TuQuery then
            S := GetUniqueValues(TuQuery(ImpTable.DataSet));
          ImpTable.OverwriteBtn :=
            MessageDlg(Format('Datensatz in "%s" bereits vorhanden.' + CRLF +
              CRLF + '%s' + CRLF + 'Überschreiben?',
              [ImpTable.TableName, S]), mtConfirmation,
              [mbYes, mbNo, mbCancel, mbNoToAll, mbYesToAll], 0);
        end;
        if ImpTable.OverwriteBtn in [mrYesToAll, mrYes] then
        begin
          OverwriteDataset(ImpTable.TableName, ImpTable.DataSet, ImpTable.FieldList);
        end else
        begin
          Prot0('%s (%s) breits vorhanden', [ImpTable.TableName, ImpTable.AktPKey]);
          //EProt(ImpTable.DataSet, E, 'Fehler bei XML Import', [0]);
          ImpTable.DataSet.Cancel;
          if ImpTable.OverwriteBtn = mrCancel then
          begin
            ProtA('Abbruch', [0]);
            Sysutils.Abort;
          end;
        end;
      end;
    end;
  end;
end;

procedure TXMLExport.OverwriteDataset(aTblName: string; aDataset: TDataset; aFieldList: TStrings);
//Dataset enthält Daten die wg. Indexfehler nicht eingefügt werden können.
//Datensatz suchen und überschreiben.
var
  ADataPos: TDataPos;
  AFltrList: TFltrList;
  IndexFields, AFieldName, NextS, ErrStr: string;
  Que: TuQuery;
  S1: string;
  I: integer;
  F1: TField;
  FD1: TFieldDef;
begin
  ADataPos := TDataPos.Create;
  AFltrList := TFltrList.Create;
  try
    ADataPos.GetValues(ImpTable.DataSet);
    ImpTable.DataSet.Cancel;               //muss immer passieren
    if aDataSet is TuQuery then
    begin
      IndexFields := IndexInfo(QueryDatabase(TuQuery(aDataset)), ATblName, nil, nil);
      AFieldName := PStrTok(IndexFields, ';', NextS);
      if AFieldName = '' then
        EError('TXMLExport.OverwriteDataset(%s): missing primary key'+CRLF+'%s',
          [aTblName, QueryText(aDataSet)]);
      while AFieldName <> '' do
      begin
        //Problem: Feldwert kann auch selbst Sql-Statement sein oder ''' enthalten
        //AFltrList.AddFmt('%s=%s', [AFieldName, ADataPos.Values[AFieldName]]);
        //Lösung über Parameter:
        AFltrList.AddFmt('%s=:%s', [AFieldName, AFieldName]);
        // ConvertFltrChr(ADataPos.Values[AFieldName])]);  //Metazeichen nach '_' wandeln
        AFieldName := PStrTok('', ';', NextS);
      end;
      Que := TuQuery.Create(nil);
      try
        try
          Que.DatabaseName := TuQuery(aDataSet).DatabaseName;
          Que.UpdateMode := upWhereKeyOnly;
          AFltrList.BuildSql(Que, ATblName, '', nil, ErrStr);

          AFieldName := PStrTok(IndexFields, ';', NextS);
          while AFieldName <> '' do
          begin
            Que.ParamByName(AFieldName).AsString := ADataPos.Values[AFieldName];
            AFieldName := PStrTok('', ';', NextS);
          end;

          Que.RequestLive := true;
          Que.Open;
          Que.Edit;
          if aFieldList.Count > 0 then
          begin
            //nur Felder in <FIELDS /> übernehmen. Ist eigentlich immer der Fall
            for I := 0 to aFieldList.Count - 1 do
            begin
              S1 := aFieldList[I];
              F1 := Que.FindField(S1);
              if F1 <> nil then
              begin
                FD1 := Que.FieldDefs.Find(S1);
                if (FD1 <> nil) and FD1.InternalCalcField then
                begin  //nicht importieren da SL-berechnetes Feld (klappt nicht immer)
                end else
                  SetFieldComp(F1, Trim(ADataPos.Values[S1]));
              end;
            end;
          end else
          begin
            //ADataPos.PutValues(Que);
            ADataPos.WriteFieldValues('', Que);  //verzeiht fehlende Felder in Que - 23.03.10
          end;
          Que.Post;
          Inc(ImpTable.RowCount);
        except on E:Exception do
          EProt(Que, E, 'Fehler bei TXMLExport.OverwriteDataset(%s.%s)',
            [ATblName, ErrStr]);
        end;
      finally
        Que.Free;
      end;
    end;
  finally
    AFltrList.Free;
    ADataPos.Free;
  end;
end;

function TXMLExport.ImportTable(aTableName: string; aDataSet: TDataSet): integer;
//Tabelle importieren. Ergibt Anzahl importierter Datensätze
var
  H: integer;
begin
  result := 0;
  H := FTableList.IndexOf(aTableName);
  if H >= 0 then
  begin
    ImpTable := Tables[H];
    aDataSet.Last;  // 17.03.10 entspricht FetchAll;
    IndexInfo(QueryDatabase(TuQuery(aDataset)), ATableName, nil, nil);  //17.03.10 prefetch
    ImpTable.DataSet := aDataSet;
    ImpTable.StoredRowCount := ImpTable.RowCount;
    ImpTable.ProcessedRowCount := 0;
    ImpTable.RowCount := 0;   //zurücksetzen
    //Unidac 30.05.12 GNavigator.DB1.StartTransaction;  //06.11.05 bitmaps blob import
    SysToLocale(ImpTable.LocaleRec);  //Zwischenspeichern da während Import SysUtils geändert wird
    try
      try
        Parser.SetProcess(ImpBeforeProcessNode, ImpAfterProcessNode); //Aktion festlegen
        Parser.ProcessNode(ImpTable.TableEl, 0);
      except on E:Exception do
        EProt(self, E, 'Importtable', [0]);
      end;
    finally
      LocaleToSys(ImpTable.LocaleRec);  //Restaurieren
      //Unidac 30.05.12 GNavigator.DB1.Commit;  //immer. Fehler bewirken kein Rollback.
    end;
    result := ImpTable.RowCount;
  end else
    Prot0('ImportTable: "%s" nicht im XML vorhanden', [aTableName]);
end;

procedure TXMLExport.ImporTuDataBase(aDatabase: TuDataBase);
//Gesamte Datenbank importieren.
var
  Que: TuQuery;
  I: integer;
begin
  Que := TuQuery.Create(nil);
  try
    Que.DataBaseName := aDataBase.DataBaseName;
    for I := 0 to TableCount - 1 do
    begin
      ProtP('IMPORT %d:%s:%d', [I, Tables[I].TableName, Tables[I].RowCount]);
      ProtP('%s', [Tables[I].Sql]);
      Que.SQL.Text := 'select * from ' + Tables[I].TableName;
      Que.RequestLive := true;
      Que.Open;
      ImportTable(Tables[I].TableName, Que);
      Prot0('%s:%d Rows importiert', [Tables[I].TableName, Tables[I].RowCount]);
    end;
  finally
    Que.Free;
  end;
end;

{ TXMLWriter }

constructor TXMLWriter.Create(AOwner: TComponent);
var
  pi: IXMLDOMProcessingInstruction;
begin
  inherited;
  FDOMDocument := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
  FDOMDocument.async := false;
  //FDOMDocument.preserveWhiteSpace := true;  //erhält nicht CRLF in Node.Text
  //encoding: ISO-8859-1 = Westeuropa. UTF-8 = 8bit. UTF-16 = 16bit
  //  wenn ohne Angabe dann ISO/IEC 10646, das ist ein Unicode.
  //standalone: wenn Yes dann ist DTD im XML enthalten
  pi := FDOMDocument.createProcessingInstruction('xml', 'version="1.0"');
  FDOMDocument.insertBefore(pi, FDOMDocument.childNodes.item[0]);
  //SetDocComment(sXmlExpVersion, XmlExpVersion);
  //Xml.AddNode(nil, 'ZUG');  //root
end;

procedure TXMLWriter.SaveToFile(const FileName: string);
var
 aParser: TXMLParser;
begin
  //falls ausgewählt dann Formatierung durchführen
  aParser := TXMLParser.Create(FDOMDocument);
  try
    aParser.SetProcess(LFBeforeProcessNode, LFAfterProcessNode); //Aktion festlegen
    aParser.Process;  //Dokument Durchlaufen
  finally
    aParser.Free;
  end;
  FDOMDocument.Save(FileName);
end;

function TXMLWriter.AddNode(ParentEl: IXMLDomElement; aText: string): IXMLDomElement;
begin
  Result := FDOMDocument.createElement(aText);
  if Assigned(ParentEl) then
    ParentEl.AppendChild(Result) else
    FDOMDocument.AppendChild(Result);
end;

function TXMLWriter.AddField(ParentEl: IXMLDomElement; aAttribute, aValue: string): IXMLDomElement;
begin
  Result := FDOMDocument.createElement(aAttribute);
  Result.appendChild(FDOMDocument.createTextNode(aValue));
  ParentEl.AppendChild(Result);
end;

procedure TXMLWriter.SetDocComment(const Param, Value: string);
//Kommentar auf Dokumentebene (vor Root-Knoten)
var
  S: string;
  Comment: IXMLDOMComment;
begin
  S := '';
  AppendTok(S, Param, ':');
  AppendTok(S, Value, ' ');
  if S <> '' then
  begin
    Comment := FDOMDocument.CreateComment(S);
    FDOMDocument.appendChild(Comment);
    FDOMDocument.InsertBefore(Comment, FDOMDocument.DocumentElement);
  end;
end;

end.
