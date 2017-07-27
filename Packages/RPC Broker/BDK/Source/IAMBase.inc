{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Herlan Westra
	Description: Contains Identity and Access Management Properties.
	Current Release: Version 1.1 Patch 65 (2016)
*************************************************************** }

const
  //Setting IAM_Server_URL = '' disables 2-factor authentication if Windows Registry
  //  HKLM entry is not set
  //IAM_Server_URL = '';
  IAM_Server_URL = 'https://services.indomain.ext:9301/STS/RequestSecurityToken';
  //Hashed pass phrase for IAM Binding RPC (REMOTE APPLICATION file entry)
  IAM_Binding = '29mgM|vENcll|eY!Z|mkF)';
  //Parts 1 and 2 of SOAP message sent to IAM
  iamMessagePart1 = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://docs.oasis-open.org/ws-sx/ws-trust/200512">'
    + '<soapenv:Header/>'
    + '<soapenv:Body>'
    +   '<ns:RequestSecurityToken>'
    +     '<ns:Base>'
    +       '<wss:TLS xmlns:wss="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"/>'
    +     '</ns:Base>'
    +     '<wsp:AppliesTo xmlns:wsp="http://schemas.xmlsoap.org/ws/2004/09/policy">'
    +       '<wsa:EndpointReference xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing">'
    +         '<wsa:Address>';
  iamMessagePart2 = '</wsa:Address>'
    +       '</wsa:EndpointReference>'
    +     '</wsp:AppliesTo>'
    +       '<ns:Issuer>'
    +         '<wsa:Address xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing">https://ssoi.domain.ext/Issuer/smtoken/SAML2</wsa:Address>'
    +       '</ns:Issuer>'
    +         '<ns:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Validate</ns:RequestType> '
    +   '</ns:RequestSecurityToken>'
    + '</soapenv:Body>'
    + '</soapenv:Envelope>';


