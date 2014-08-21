//Dynamically Creating an XML Document in Delphi
//Overview
//This paper covers creating an XML document using the DOM object model. It is the third in a series of articles on XML and Delphi. The first article covered basic XML syntax, while the second article looked into the subject in a bit more depth.
//
//Subjects covered in this paper include:
//
//Creating a TDomDocument object. 
//Using the methods of TDomDocument for creating new nodes on an XML document.
//This include CreateElement, CreateText, CreateComment, CreateCDATASection, and
//CreateProcessingInstruction.
//Adding Text Elements to your XML Code.
//Adding Comments to your XML Code
//Formatting your XML Code.
//Adding Version Information to your XML Code
//Saving Your XML to Disk
//Dynamically creating an XML document compatible with the Borland MIDAS technology.
//The code in this program is based on the Open XML components for parsing XML found at http://www.philo.de/homepage.htm. You can, however, make the code work with Microsoft's XML components with only a small amount of work. In several cases, I show code that works with both parsers, but the focus is on the Open XML components. Readers of the previous articles in this series already know that both parses follow the standards laid out by the www.w3.org committee, and so their object models are quite nearly identical.
//
//This is not a difficult paper to understand, but it includes important information for people who are interested in working with DOM parsers. So sit back and relax, and spend a few minutes learning how to add a few more routines to your XML toolkit.
//
//Creating an XML Document
//Listing 1 shows code for creating a DOM document. The code shown here shows how to create most of the different types of nodes found in an XML document.
//
//Listing 1: Code for creating an XML Document

type
  TForm1 = class(TForm)
    // Code omitted here
  private
    FDoc: TDOMDocument;
    FRoot: TDomElement;
    FChild11, FChild12, FChild13: TDomElement;
    FGrandChild_111, FGrandChild_112: TDomElement;
    FGrandChild_121, FGrandChild_122: TDomElement;
    FGrandChild_131: TDOMElement;
    attr01, Attr02: TDomAttr;
    textNode1, textNode2: TDomText;
    Comment: TDomComment;
    cDataSec: TDOMCDataSection;
    docPi: TDOMProcessingInstruction;
  end;

procedure TForm1.CreateDocument;
var
  Stream: TFileStream;
  S: string;
begin
  FDoc := TDomDocument.Create;
  // Create XML root
  FRoot := Fdoc.createElement('RootElement');
  FDoc.appendChild(FRoot);
  // Create Top Tier Children
  FChild11 := Fdoc.createElement('Child_One');
  FRoot.appendChild(FChild11);
  FChild12 := Fdoc.createElement('Child_Two');
  FRoot.appendChild(FChild12);
  FChild13 := Fdoc.createElement('Child_Three');
  FRoot.appendChild(FChild13);
  // Attach some text
  textNode1 := Fdoc.createText('Text One');
  FChild11.appendChild(textNode1);
  textNode2 := Fdoc.createText('Text Two');
  FChild12.appendChild(textNode2);

  //Create GrandChildren
  FGrandChild_111 := FDoc.createElement('GrandChild_111');
  FChild11.appendChild(FGrandChild_111);
  attr01  := Fdoc.createAttribute('Attr01');
  FChild11.setAttributeNode(attr01);

  FGrandChild_112 := Fdoc.createElement('GrandChild_112');
  FChild11.appendChild(FGrandChild_112);

  FGrandChild_121 := Fdoc.createElement('GrandChild_121');
  FChild12.appendChild(FGrandChild_121);
  attr02 := Fdoc.createAttribute('Attr01');
  FChild12.setAttributeNode(attr02);

  FGrandChild_122 := Fdoc.createElement('GrandChild_122');
  FChild12.appendChild(FGrandChild_122);

  FGrandChild_131 := FDoc.createElement('GrandChild_131');
  FChild13.appendChild(FGrandChild_131);

  Comment := FDoc.createComment('DocComment');
  FRoot.appendChild(Comment);

  cdataSec := Fdoc.createCDATASection('DocCDataSection');
  FChild11.appendChild(cdataSec);

  docPI := Fdoc.createProcessingInstruction('DocPI', 'DocTarget');
  FChild13.appendChild(docPI);
  S := FDoc.Code;
  Stream := TFileStream.Create(GetStartDir +   'sammy.xml', fmCreate or fmOpenWrite);
  Stream.Write(PChar(S)^, Length(S));
  Stream.Free;
end;
//Its length makes this method appear perhaps a bit intimidating, but the operations it encapsulates are relatively straightforward. If you spend a few moments coming to terms with the methods used by the code, you should have little trouble understanding its logic. In short the code is simple, you merely need to become familiar with a few useful routines available on the parser.
//
//The first step is to simply create a TDomDocument object by calling its constructor. You can then use the methods of the TDomDocument object you created to append nodes to the document, as shown in Listing 2.
//
//Listing 2: Creating a TDomDocument object and appending a root element to it.

  FDoc := TDomDocument.Create;
  // Create XML root
  FRoot := Fdoc.createElement('RootElement');
  FDoc.appendChild(FRoot);

//Creating an instance of a TDomDocument is a very straightforward process when working
//with Open XML: all you need do is call the Create constructor. Here is code for doing
//the same thing using Microsoft's model:

Doc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
//Though it looks different, this Microsoft COM code does more or less the same
//thing as the call to TDomDocument.Create. Both methods simple create an instance
//of an object. In one case the program asks the Delphi object model to create the
//instance, in the second case it asks the Microsoft COM model to create the instance.
//In either case, we end up with an object on which we can call the methods that drive our code.

//Once you have an instance of a DOM document, you can call the CreateElement method
//to create an instance of an element node. If you call CreateElement, and pass in
//the string "RootElement" as a parameter, then you end up with a standard XML node:

//<RootElement></RootElement>
//You can, of coures, pass in any string you want, and its name will be mirrored
//back to you in the nodes creaded in your document. For instance, if you pass in
//Foo, then you end up with this: <Foo></Foo>.
//
//Documents can be built up by creating a series of these elements nested under the root element:
//
//<RootElement>
//  <Data>
//     <Name>Sam</Name>
//     <Phone>Phone</Phone>
//  </Data>
//</RootElement>
//The code shown here has RootElement at the top of the hierarchy, in the "root"
//position. All XML documents can have one, and only one root element. Other types
//of code, such as comments or version declarations may appear at the same level of
//the document, but there can be only one root element. The differences between
//comments, version information, and elements should become clear as you see examples
//of each type while reading this document. So if the subject is still a bit fuzzy in
//your mind, don't worry, as it will become clear to you before you reach the end of
//this document.
//
//The example code for adding the root element creates the first node in an XML document.
//Here is code for adding three second level elements, such as the Data elements shown
//immediately above the paragraph preceding this one:

  FChild11 := Fdoc.createElement('Child_One');
  FRoot.appendChild(FChild11);
  FChild12 := Fdoc.createElement('Child_Two');
  FRoot.appendChild(FChild12);
  FChild13 := Fdoc.createElement('Child_Three');
  FRoot.appendChild(FChild13);

//The XML produced by this code looks like this:
//<RootElement><Child_One></Child_One><Child_Two></Child_Two><Child_Three></Child_Three></RootElement>
//I do not properly format the code, but if I did, it would look like this:
//
//<RootElement>
//  <Child_One></Child_One>
//  <Child_Two></Child_Two>
//  <Child_Three></Child_Three>
//</RootElement>
//The subject of formating the code in this manner is covered below in the section
//called Formatting your Code.
//
//Microsoft's XML parser would actually create nodes that look like this: <Child_One/>,
//which is a shorthand way of writing <Child_One></Child_One>. Both syntaxes have the
//same syntactic meaning. However, the MS way does save space in your documents,
//and it reflects the technique used in Borland's MIDAS technology.
//
//If you want to add a child to one of these nodes, you can do so as follows:
//
//  FGrandChild_111 := FDoc.createElement('GrandChild_111');
//  FChild11.appendChild(FGrandChild_111);
//
//Notice that the new node is appended on to not the the root element, but the first
//child element. The end result is XML code that -- if I had properly formatted it --
//would look like this:
//
//<RootElement>
//  <Child_One>
//    <GrandChild_111></GrandChild_111>
//  </Child_One>
//  <Child_Two></Child_Two>
//  <Child_Three></Child_Three>
//</RootElement>
//At this stage the desire to format your code properly is perhaps gaining a foothold
//in the readers mind. As a result, I will now take a few moments to cover that subject.
//
//Formating Your Code
//Sometimes you want to do more than simply generate correct XML. In particular,
//there are times when you want to format your XML so that it is reasonably approachable
//by any humans who might want to peruse it. Here is code that inserts a node value
//and some formating for a node

    NewElement := FDoc.CreateElement('Foo');
    TextNode := FDoc.CreateText(#13#10#32#32);
    Game.AppendChild(TextNode);
    NewElement.AppendChild(FDoc.CreateText('Foo Text'));
    Game.AppendChild(NewElement);
    TextNode := FDoc.CreateText(#13#10);
    Game.AppendChild(TextNode);

//This code creates a node called NewElement, and then uses text nodes to format
//the element and add a NodeValue to it:
//
//  <Foo>Foo Text</Foo>
//Notice that I explicitly add a carriage return line feed  (#13#10) at the
//beginning and end of the node, and I add two spaces (#32#32) at the end of
//the node. If I didn't do this, then the code when appear all on one long line.
//It is not wrong to put your code on one line, but it is better to have it
//properly formated.
//
//Here is an example of code with no formating:
//
//<Bar><Foo>Text1</Foo><Foo>Text2</Foo><Foo>Text3</Foo></Bar>
//Here is code that is formated with line feeds and spaces:
//
//<Bar>
//  <Foo>Text1</Foo>
//  <Foo>Text2</Foo>
//  <Foo>Text3</Foo>
//  <Foo>Text4</Foo>
//</Bar>
//Adding Comments to Your XML Code
//So far we have been only adding TDomElement and TDomText nodes to our XML model.
//It is, however, trivial to add other types of nodes. For instance, here is code
//for adding a comment to you XML:

  Comment := FDoc.createComment('DocComment');
  FRoot.appendChild(Comment);This adds a comment in XML style to your code: <!-- DocComment -->.

//Adding Attributes to Your XML Code
//Here is code for adding an attribute:

  attr02 := Fdoc.createAttribute('Attr01');
  FChild12.setAttributeNode(attr02);

//The end result of this Pascal code is XML code that looks like this:
//
//<Child_One Attr01="">.
//
//My example includes code for adding several other types of nodes. The end result,
//however, is an XML tree that looks like this:
//
//<RootElement>
//  <Child_One Attr01="">
//    Text One
//    <GrandChild_111></GrandChild_111>
//    <GrandChild_112></GrandChild_112>
//    <![CDATA[DocCDataSection]]></Child_One>
//  <Child_Two Attr01="">
//    Text Two
//    <GrandChild_121></GrandChild_121>
//    <GrandChild_122></GrandChild_122>
//  </Child_Two>
//  <Child_Three>
//    <GrandChild_131></GrandChild_131>
//    <?DocPI DocTarget?></Child_Three>
//    <!--DocComment-->
//</RootElement>
//Saving the XML to Disk
//After creating your XML, you will, of course, want to save it to disk. This is a simple task that involves first retrieving a single string containing the entire XML document that you created. The document comes to you in the form of a simple Object Pascal string. You can then create a stream and save your code to disk.

  S := FDoc.Code;
  Stream := TFileStream.Create(GetStartDir +   'sammy.xml', fmCreate or fmOpenWrite);
  Stream.Write(PChar(S)^, Length(S));
  Stream.Free;
//The call to the Code property of the TDomDocument retrieves a string containing
//your entire docuemnt. You can then save this to disk by creating a TFileStream
//object, and writing the data to the stream, and then closing the stream.
//When you open up the stream in a text editor, it will contain exactly the
//formating that you gave it when you created the document.
//
//Summary
//In this short paper you have learned how to create an XML file and save it to disk.
//You can, of course, simply use a TextFile and WriteLn to do this kind of work.
//However, if you use the methods shown here you will be able to validate your
//tree and manipulate in memory using the the standard parsing APIs.
//
//Subjects covered in this paper include creating an XML document, as well as
//adding elements, text notes, comments, version information and other syntactical
//elements to it. You also saw techniques for formatting your code.

