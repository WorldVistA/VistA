unit XMLUtils;

interface
uses
  SysUtils, MSXML_TLB, ORFn;

function Text2XML(const AText: string): string;
function FindXMLElement(Element: IXMLDOMNode; ElementTag: string): IXMLDOMNode;
function FindXMLAttributeValue(Element: IXMLDOMNode; AttributeTag: string): string;
function GetXMLWPText(Element: IXMLDOMNode): string;

implementation

type
  TXMLChars = (xcAmp, xcGT, xcLT, xcApos, xcQuot); // Keep & first in list!

const
  XMLCnvChr: array[TXMLChars] of string = ('&',   '>',    '<',   '''',    '"');
  XMLCnvStr: array[TXMLChars] of string = ('&amp;','&gt;','&lt;','&apos;','&quot;');

function Text2XML(const AText: string): string;
var
  i: TXMLChars;
  p: integer;
  tmp: string;

begin
  Result := AText;
  for i := low(TXMLChars) to high(TXMLChars) do
  begin
    tmp := Result;
    Result := '';
    repeat
      p := pos(XMLCnvChr[i],tmp);
      if(p > 0) then
      begin
        Result := Result + copy(tmp,1,p-1) + XMLCnvStr[i];
        delete(tmp,1,p);
      end;
    until(p=0);
    Result := Result + tmp;
  end;
end;

function FindXMLElement(Element: IXMLDOMNode; ElementTag: string): IXMLDOMNode;
var
  Children: IXMLDOMNodeList;
  Child: IXMLDOMNode;
  i, count: integer;

begin
  Result := nil;
  Children := Element.Get_childNodes;
  if assigned(Children) then
  begin
    count := Children.Get_length;
    for i := 0 to count-1 do
    begin
      Child := Children.Get_item(i);
      if assigned(Child) and (CompareText(Child.Get_nodeName, ElementTag) = 0) then
      begin
        Result := Child;
        break;
      end;
    end;
  end;
end;

function FindXMLAttributeValue(Element: IXMLDOMNode; AttributeTag: string): string;
var
  Attributes: IXMLDOMNamedNodeMap;
  Attribute: IXMLDOMNode;
  i, count: integer;

begin
  Result := '';
  Attributes := Element.Get_attributes;
  try
    if assigned(Attributes) then
    begin
      count := Attributes.Get_Length;
      for i := 0 to Count - 1 do
      begin
        Attribute := Attributes.Item[i];
        if CompareText(Attribute.Get_NodeName, AttributeTag) = 0 then
        begin
          Result := Attribute.Get_Text;
          break;
        end;
      end;
    end;
  finally
    Attribute := nil;
    Attributes := nil;
  end;
end;

function GetXMLWPText(Element: IXMLDOMNode): string;
var
  Children: IXMLDOMNodeList;
  Child: IXMLDOMNode;
  i, count: integer;

begin
  Result := '';
  Children := Element.Get_childNodes;
  try
    if assigned(Children) then
    begin
      count := Children.Length;
      for i := 0 to Count - 1 do
      begin
        Child := Children.Item[i];
        if CompareText(Child.NodeName, 'P') = 0 then
        begin
          if(Result <> '') then
            Result := Result + CRLF;
          Result := Result + Child.Get_Text;
        end;
      end;
    end;
  finally
    Child := nil;
    Children := nil;
  end;
end;

end.
