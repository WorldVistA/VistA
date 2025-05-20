{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Herlan Westra, Roy Gaber
	Description: Contains Identity and Access Management Properties.
	Current Release: Version 1.1 Patch 71 (2019)
*************************************************************** }

const
  //Setting IAM_Server_URL = '' disables 2-factor authentication if Windows Registry
  //  HKLM entry is not set
  //IAM_Server_URL = '';
  PasswordProvider = '{6f45dc1e-5384-457a-bc13-2cd81b0d28ed}';  //added in p71
  LastLoggedOnProvider = 'LastLoggedOnProvider';
  IAM_Server_URL = 'https://domain.aaaaa.aaaa.ext:9301/STS/RequestSecurityToken';
  //p71 - Added following line to address Active Directory fall-back endpoint
  IAM_Server_AD_URL = 'https://domain.aaaaa.aaaa.ext:9201/STS/RequestSecurityToken';
  //RIOSERVICE_VALUE and RIOPORT_VALUE added in p71
  RIOSERVICE_VALUE = 'SecurityTokenService';
  RIOPORT_VALUE = 'RequestSecurityToken';
  //Hashed pass phrase for IAM Binding RPC (REMOTE APPLICATION file entry)
  IAM_Binding = '29mgM|vENcll|eY!Z|mkF)';
  //Parts 1 and 2 of SOAP message sent to IAM for PIV login
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
    +         '<wsa:Address xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing">https://domain.aaaa.ext/Issuer/smtoken/SAML2</wsa:Address>'
    +       '</ns:Issuer>'
    +         '<ns:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Validate</ns:RequestType> '
    +   '</ns:RequestSecurityToken>'
    + '</soapenv:Body>'
    + '</soapenv:Envelope>';


  //Parts of SOAP message sent to IAM for Active Directory login
  iamMessageADPart1 = '<soapenv:Envelope xmlns:add="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:ns="http://docs.oasis-open.org/ws-sx/ws-trust/200512" '
    +'xmlns:pol="http://schemas.xmlsoap.org/ws/2004/09/policy" xmlns:ser="http://domain.aaaaa.aaaaa.ext/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" '
    + 'xmlns:stspapp="http://sts.iam.gov.va/" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'
    +	'<soapenv:Header>'
    +		'<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">';
	iamMessageADPart2 = '<u:Timestamp u:Id=';
    iamMessageADPart3 =	'</u:Timestamp>'
    +      '<wsse:UsernameToken u:Id=';
	iamMessageADPart4 =	'<wsse:Username>'; 
	iamMessageADPart5 = '</wsse:Username>'
	+			'<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">';
	iamMessageADPart6 = '</wsse:Password>'
    +					'<u:Created>';
	iamMessageADPart7 = '</wsse:UsernameToken>'
	+	'</wsse:Security>'
	+  '</soapenv:Header>'
    +  '<soapenv:Body>'
	+	'<ns:RequestSecurityToken>'
	+		'<pol:AppliesTo>'
	+			'<add:EndpointReference>'
	+				'<add:Address>https://domain.aaaa.ext/Issuer/smtoken/SAML2</add:Address>'
	+			'</add:EndpointReference>'
	+		'</pol:AppliesTo>'
	+		'<ns:Issuer>'
	+			'<add:Address xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing">https://domain.aaaa.ext/Issuer/smtoken/SAML2</add:Address>'
	+		'</ns:Issuer>'
	+		'<KeyType>http://docs.oasis-open.org/ws-sx/ws-trust/200512/Bearer</KeyType>'
	+		'<RequestType>http://docs.oasis-open.org/ws-sx/ws-trust/200512/Issue</RequestType>'
	+		'<TokenType>urn:oasis:names:tc:SAML:2.0:assertion</TokenType>'
	+	'</ns:RequestSecurityToken>'
	+'</soapenv:Body>'
    +'</soapenv:Envelope>';
