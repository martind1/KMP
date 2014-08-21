unit Round_trip_databases_with_XML;

interface

implementation

var
  DataList : TStringlist;
  doc : IXMLDOMDocument;
  root, child, child1 : IXMLDomElement;
  text1, text2 : IXMLDOMText;
  nlist : IXMLDOMNodelist;
  dataRecord : String;Add the following function to your unit. This will generate an XML file by reading data from country table.


function TForm1.makeXml(table:TTable):Integer;
var
  i : Integer;
  xml : String;
begin
  try
    table.close;
    table.open;
    xml  := table.TableName;
    doc  := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
    // Set the root name of the XML file to match the table name: in this case, "country."
    root := doc.createElement(xml);
    // Append the root element to the Document object.
    doc.appendchild(root);
    // This loop will go through the entire table to generate the XML file.
    while not table.eof do
    begin
    // Adds the first level children, records.
      child:= doc.createElement('Records');
      root.appendchild(child);
      // Adds second level children.
      for i:=0 to table.FieldCount-1 do
      begin
        child1:=doc.createElement(table.Fields[i].FieldName);
        child1.appendChild(doc.createTextNode(table.Fields[i].value));
        child.appendchild(child1);
      end;
    table.Next;
    end;
    doc.save(xml+'.xml');
    Result:=1;
  except
    on e:Exception do
      Result:=-1;
  end;
end;Call the function in Button1's click event: 

procedure TForm1.Button1Click(Sender: TObject);
begin
  if makeXml(table1)=1 then
    showmessage('XML Generated')
  else
    showmessage('Error while generating XML File');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   i,ret_val,count:Integer;
   strData:String;
begin
    // Before inserting data into the country table, make sure that the data in
    // the generated XML file (country.xml) and country table (DBDEMOS) are
    // different.
    try
      count:=1;
      DataList:=TStringList.Create;
      memo1.Clear;
      doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
      // Load country.xml file.
      doc.load('country.xml');
      nlist:=doc.getElementsByTagName('Records');
      memo1.lines.append('Table Name  :country');
      memo1.lines.append('---------------------');
      for i:=0 to nlist.Get_length-1 do
      begin
        travelChildren(nlist.Get_item(i).Get_childNodes);
        // Removes the first character(,) from dataRecord.
        strData:=copy(dataRecord,2,length(dataRecord));
        memo1.lines.append(strData);
        dataRecord:='';
        ret_val:=insertintotable(Datalist);
        if ret_val=1 then
          memo1.lines.append('Data inserted successfully.............!')
        else if ret_val=-1 then
          memo1.lines.append('Error while updating.....Try again.....!');
        memo1.lines.append('=============================================' + '==(Record no. :'+inttostr(count)+')');
        DataList.Clear;
        count:=count+1;
      end;
    except
      on e:Exception do
        Showmessage(e.message);
   end;
end;

procedure TForm1.travelChildren(nlist1:IXMLDOMNodeList);
var
  j:Integer;
  temp:String;
begin
  for j:=0 to nlist1.Get_length-1 do
  begin
  // Node type 1 means an entity and node type 5 means EntityRef.
  if((nlist1.Get_item(j).Get_nodeType= 1) or (nlist1.Get_item(j).Get_nodeType=5)) then
    travelChildren(nlist1.Get_item(j).Get_childNodes)
    // Node Type 3 means a text node, i.e. you find the data.
    else if(nlist1.Get_item(j).Get_nodeType=3) then
    begin
      temp:= trim(nlist1.Get_item(j).Get_nodeValue);
      dataRecord:=dataRecord+','+temp; 
      // this is for displaying a single record on the memo.
      DataList.Add(temp); 
      // Datalist will contain one record after completing one full travel through the node list.
    end
  end;
end;

function TForm1.insertintotable(stpt:TStringList):Integer;
var
  I:Integer;
begin
  table1.close;
  table1.open;
  table1.Insert;
  for I := 0 to stpt.Count - 1 do
    table1.Fields[I].AsVariant:=stpt[I];
  try
    table1.post;
    result:=1;
  except
    on E:Exception do
      result:=-1;
  end;
end;

end.
 