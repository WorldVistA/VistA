unit uXML;
{
================================================================================
*
*       Application:  CliO
*       Revision:     $Revision: 1 $  $Modtime: 12/20/07 12:44p $
*       Developer:    doma.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Contains global XML text utilities.
*
*
*       Notes:
*
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSUTILS/uXML.pas $
*
* $History: uXML.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSUTILS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:39p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSUTILS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSUTILS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/14/07    Time: 10:30a
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/VITALSUTILS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:44p
 * Created in $/Vitals/VITALS-5-0-18/VitalsUtils
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:33p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/VitalsUtils
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 5:04p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, CCOW) - Delphi 6/VitalsUtils
 * 
 * *****************  Version 4  *****************
 * User: Zzzzzzpetitd Date: 10/27/04   Time: 9:05a
 * Updated in $/CP Modernization/CliO/Source Code
 * Completed initial work for the renal controller.
 *
 * *****************  Version 3  *****************
 * User: Zzzzzzpetitd Date: 10/13/04   Time: 2:33p
 * Updated in $/CP Modernization/CliO/Source Code
 * Finished base Insert Update and Query functions.
 *
 * *****************  Version 2  *****************
 * User: Zzzzzzpetitd Date: 10/07/04   Time: 4:49p
 * Updated in $/CP Modernization/CliO/Source Code
 * Finished preliminary work on Insert and have it functioning with both
 * ADO and the VistABroker connections
 *
 * *****************  Version 1  *****************
 * User: Zzzzzzpetitd Date: 10/02/04   Time: 9:46a
 * Created in $/CP Modernization/CliO/Source Code
 * Initial check in
 *
 *
*
*
================================================================================
}
interface

uses
  SysUtils,
  Classes,
  XMLIntf,
  XMLDoc;

function XMLHeader(const AName: string): string; overload;
function XMLHeader(const AName: string; AIdentifierNames, AIdentifierValues: array of string): string; overload;

function XMLFooter(const AName: string): string;

function XMLElement(const ATag: string; const AValue: string): string; overload;
function XMLElement(const ATag: string; const AValue: Integer): string; overload;
function XMLElement(const ATag: string; const AValue: Double; const ADecimals: integer): string; overload;
function XMLElement(const ATag: string; const AValue: Boolean): string; overload;
function XMLElement(const ATag: string; const AValue: TDateTime): string; overload;

function XMLStream(const AXML: string): TStringStream;

function XMLDocument(const AXML: string): IXMLDocument;

function XMLDateTime(const ADateTime: TDateTime): string;

function XMLNodeValue(const AXMLDoc: IXMLDocument; const ATag: string): string;

function XMLFieldValue(AXMLCurrentRecordNode: IXMLNode; AFieldName: string): string;

function XMLFirstRecord(AXMLResultsDocument: IXMLDocument): IXMLNode;

function XMLNextRecord(AXMLCurrentRecordNode: IXMLNode): IXMLNode;

function XMLErrorMessage(const aErrorMsgText: string): string;

function XMLSuccessMessage(const aMsgText: string): string;

function XMLString(aString: string): string;

function GetXMLStatusValue(aXMLString: string): string;
function GetXMLNodeValue(aXMLString, aXMLNodeName: string): string;

const
  XML_DATE = 'YYYY-MM-DD';
  XML_DATETIME = 'YYYY-MM-DD hh:mm:ss';
  XML_VERSION = '<?xml version="1.0"?>';
  XML_STATUS_OK = '<RESULT><STATUS>OK</STATUS></RESULT>';
  XML_STATUS_ERROR = '<RESULT><STATUS>ERROR</STATUS><DB_ENGINE_ERROR_MESSAGE>%s</DB_ENGINE_ERROR_MESSAGE></RESULT>';

implementation

uses StrUtils;

function BuildElement(const ATag: string; const AValue: string): string;
{Used internally once the element value is formatted to a string}
begin
  Result := Format('<%s>%s</%s>', [ATag, AValue, ATag]) + #13;
end;

function XMLHeader(const AName: string): string; overload;
begin
  Result := XMLHeader(AName, [], []);
end;

function XMLHeader(const AName: string; AIdentifierNames, AIdentifierValues: array of string): string;
var
  i: integer;
begin
  Result := AName;

  if High(AIdentifierNames) > -1 then
    begin
      Result := Format('%s', [Result]);
      i := 0;
      while i <= High(AIdentifierNames) do
        begin
          Result := Format('%s %s=%s', [Result, AIdentifierNames[i], AnsiQuotedStr(AIdentifierValues[i], '''')]);
          inc(i);
        end;
    end;

  Result := Format('<%s>', [Result]) + #13;
end;

function XMLFooter(const AName: string): string;
begin
  Result := Format('</%s>', [AName]) + #13;
end;

function XMLElement(const ATag: string; const AValue: string): string; overload;
begin
  Result := BuildElement(ATag, AValue);
end;

function XMLElement(const ATag: string; const AValue: Integer): string; overload;
begin
  Result := BuildElement(ATag, Format('%d', [AValue]));
end;

function XMLElement(const ATag: string; const AValue: Double; const ADecimals: integer): string; overload;
begin
  Result := BuildElement(ATag, Format(Format('%%0.%df', [ADecimals]), [AValue]));
end;

function XMLElement(const ATag: string; const AValue: Boolean): string; overload;
begin
  Result := BuildElement(ATag, BoolToStr(AValue, True));
end;

function XMLElement(const ATag: string; const AValue: TDateTime): string; overload;
begin
  Result := BuildElement(ATag, FormatDateTime(XML_DATETIME, AValue));
end;

function XMLDateTime(const ADateTime: TDateTime): string;
begin
  Result := FormatDateTime(XML_DATETIME, ADateTime);
end;

function XMLStream(const AXML: string): TStringStream;
begin
  Result := TStringStream.Create(AXML);
end;

function XMLDocument(const AXML: string): IXMLDocument;
begin
  Result := NewXMLDocument;
  Result.LoadFromStream(XMLStream(AXML));
  Result.Active := True;
end;

function XMLNodeValue(const AXMLDoc: IXMLDocument; const ATag: string): string;
var
  XMLNode: IXMLNode;
begin
  Result := '';
  XMLNode := AXMLDoc.DocumentElement.ChildNodes.FindNode(ATag);
  if XMLNode <> nil then
    if XMLNode.IsTextElement then
      Result := XMLNode.NodeValue;
end;

function XMLFieldValue(AXMLCurrentRecordNode: IXMLNode; AFieldName: string): string;
begin
  Result := '';
  if AXMLCurrentRecordNode.ChildNodes.FindNode(AFieldName) <> nil then
    if AXMLCurrentRecordNode.ChildNodes.FindNode(AFieldName).IsTextElement then
      Result := AXMLCurrentRecordNode.ChildNodes.FindNode(AFieldName).NodeValue;
end;

function XMLFirstRecord(AXMLResultsDocument: IXMLDocument): IXMLNode;
begin
  Result := AXMLResultsDocument.DocumentElement.ChildNodes.FindNode('RECORD');
end;

function XMLNextRecord(AXMLCurrentRecordNode: IXMLNode): IXMLNode;
begin
  Result := AXMLCurrentRecordNode.NextSibling;
end;

function XMLErrorMessage(const aErrorMsgText: string): string;
begin
  Result :=
    XMLHeader('RESULTS') +
    XMLElement('STATUS', 'ERROR') +
    XMLElement('MESSAGE', aErrorMsgText) +
    XMLFooter('RESULTS');
end;

function XMLSuccessMessage(const aMsgText: string): string;
begin
  Result :=
    XMLHeader('RESULTS') +
    XMLElement('STATUS', 'OK') +
    XMLElement('MESSAGE', aMsgText) +
    XMLFooter('RESULTS');
end;

function XMLString(aString: string): string;
begin
  Result := aString;
  Result := AnsiReplaceStr(Result, '&', '&amp;');
  Result := AnsiReplaceStr(Result, '<', '&lt;');
  Result := AnsiReplaceStr(Result, '>', '&gt;');
  Result := AnsiReplaceStr(Result, '''', '&apos;');
  Result := AnsiReplaceStr(Result, '"', '&quot;');
end;

function GetXMLStatusValue(aXMLString: string): string;
begin
  Result := GetXMLNodeValue(aXMLString, 'STATUS');
end;

function GetXMLNodeValue(aXMLString, aXMLNodeName: string): string;
begin
  try
    with LoadXMLData(aXMLString).DocumentElement do
      Result := ChildValues[aXMLNodeName];
  except
    on E: Exception do
      Result := '';
  end;
end;

end.

