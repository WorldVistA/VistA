unit CCOW_const;
{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Contains TRPCBroker and related components.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }


interface
const
  // Note: set the 'CCOW' suffix to the suffix this app should look for in the context.
  // Eg. Patient.ID.MRN.GeneralHospital,  Patient.ID.MRN.VendorAppName, etc.
  // This string is used during startup (to check for an existing context),
  // during a commit event (to check the new context), etc.

  //The VistA Domain
  CCOW_LOGON_ID = 'user.id.logon.vistalogon';        //CCOW
  //The VistA Token
  CCOW_LOGON_TOKEN = 'user.id.logon.vistatoken';     //CCOW
  //The VistA user Name
  CCOW_LOGON_NAME = 'user.id.logon.vistaname';            //CCOW
  // The VistA Vpid
  CCOW_LOGON_VPID = 'user.id.logon.vpid';
  // The generic name
  CCOW_USER_NAME = 'user.co.name';

implementation

end.
 