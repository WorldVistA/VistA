{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Joel Ivey
  Description: Contains TRPCBroker and related components.
  Unit: CCOW_const sets CCOW string.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 08/05/2015) XWB*1.1*65
  1. None.

  Changes in v1.1.60 (HGW 08/28/2013) XWB*1.1*60
  1. None

  Changes in v1.1.50 (JLI 09/01/2011) XWB*1.1*50
  1. None
  ************************************************** }
unit CCOW_const;

interface

const
  // Note: set the 'CCOW' suffix to the suffix this app should look for in the context.
  // Eg. Patient.ID.MRN.GeneralHospital,  Patient.ID.MRN.VendorAppName, etc.
  // This string is used during startup (to check for an existing context),
  // during a commit event (to check the new context), etc.

  // The VistA Domain
  CCOW_LOGON_ID = 'user.id.logon.vistalogon'; // CCOW
  // The VistA Token
  CCOW_LOGON_TOKEN = 'user.id.logon.vistatoken'; // CCOW
  // The VistA user Name
  CCOW_LOGON_NAME = 'user.id.logon.vistaname'; // CCOW
  // The VistA Vpid
  CCOW_LOGON_VPID = 'user.id.logon.vpid';
  // The generic name
  CCOW_USER_NAME = 'user.co.name';

implementation

end.
