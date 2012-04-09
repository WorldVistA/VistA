unit CPRSChart_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 1/24/2011 11:37:00 AM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Vista\cprs\main\CPRS-Chart\CPRSChart.tlb (1)
// LIBID: {0A4A6086-6504-11D5-82DE-00C04F72C274}
// LCID: 0
// Helpfile: 
// HelpString: CPRSChart Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  CPRSChartMajorVersion = 1;
  CPRSChartMinorVersion = 0;

  LIBID_CPRSChart: TGUID = '{0A4A6086-6504-11D5-82DE-00C04F72C274}';

  IID_ICPRSBroker: TGUID = '{63DC619B-6BE0-11D5-82E6-00C04F72C274}';
  IID_ICPRSState: TGUID = '{63DC619E-6BE0-11D5-82E6-00C04F72C274}';
  IID_ICPRSExtension: TGUID = '{63DC61C4-6BE0-11D5-82E6-00C04F72C274}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum BrokerParamType
type
  BrokerParamType = TOleEnum;
const
  bptLiteral = $00000000;
  bptReference = $00000001;
  bptList = $00000002;
  bptUndefined = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICPRSBroker = interface;
  ICPRSBrokerDisp = dispinterface;
  ICPRSState = interface;
  ICPRSStateDisp = dispinterface;
  ICPRSExtension = interface;
  ICPRSExtensionDisp = dispinterface;

// *********************************************************************//
// Interface: ICPRSBroker
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC619B-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSBroker = interface(IDispatch)
    ['{63DC619B-6BE0-11D5-82E6-00C04F72C274}']
    function SetContext(const Context: WideString): WordBool; safecall;
    function Server: WideString; safecall;
    function Port: Integer; safecall;
    function DebugMode: WordBool; safecall;
    function Get_RPCVersion: WideString; safecall;
    procedure Set_RPCVersion(const Value: WideString); safecall;
    function Get_ClearParameters: WordBool; safecall;
    procedure Set_ClearParameters(Value: WordBool); safecall;
    function Get_ClearResults: WordBool; safecall;
    procedure Set_ClearResults(Value: WordBool); safecall;
    procedure CallRPC(const RPCName: WideString); safecall;
    function Get_Results: WideString; safecall;
    procedure Set_Results(const Value: WideString); safecall;
    function Get_Param(Index: Integer): WideString; safecall;
    procedure Set_Param(Index: Integer; const Value: WideString); safecall;
    function Get_ParamType(Index: Integer): BrokerParamType; safecall;
    procedure Set_ParamType(Index: Integer; Value: BrokerParamType); safecall;
    function Get_ParamList(Index: Integer; const Node: WideString): WideString; safecall;
    procedure Set_ParamList(Index: Integer; const Node: WideString; const Value: WideString); safecall;
    function ParamCount: Integer; safecall;
    function ParamListCount(Index: Integer): Integer; safecall;
    property RPCVersion: WideString read Get_RPCVersion write Set_RPCVersion;
    property ClearParameters: WordBool read Get_ClearParameters write Set_ClearParameters;
    property ClearResults: WordBool read Get_ClearResults write Set_ClearResults;
    property Results: WideString read Get_Results write Set_Results;
    property Param[Index: Integer]: WideString read Get_Param write Set_Param;
    property ParamType[Index: Integer]: BrokerParamType read Get_ParamType write Set_ParamType;
    property ParamList[Index: Integer; const Node: WideString]: WideString read Get_ParamList write Set_ParamList;
  end;

// *********************************************************************//
// DispIntf:  ICPRSBrokerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC619B-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSBrokerDisp = dispinterface
    ['{63DC619B-6BE0-11D5-82E6-00C04F72C274}']
    function SetContext(const Context: WideString): WordBool; dispid 1;
    function Server: WideString; dispid 2;
    function Port: Integer; dispid 3;
    function DebugMode: WordBool; dispid 4;
    property RPCVersion: WideString dispid 5;
    property ClearParameters: WordBool dispid 6;
    property ClearResults: WordBool dispid 7;
    procedure CallRPC(const RPCName: WideString); dispid 8;
    property Results: WideString dispid 9;
    property Param[Index: Integer]: WideString dispid 10;
    property ParamType[Index: Integer]: BrokerParamType dispid 11;
    property ParamList[Index: Integer; const Node: WideString]: WideString dispid 12;
    function ParamCount: Integer; dispid 13;
    function ParamListCount(Index: Integer): Integer; dispid 14;
  end;

// *********************************************************************//
// Interface: ICPRSState
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC619E-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSState = interface(IDispatch)
    ['{63DC619E-6BE0-11D5-82E6-00C04F72C274}']
    function Handle: WideString; safecall;
    function UserDUZ: WideString; safecall;
    function UserName: WideString; safecall;
    function PatientDFN: WideString; safecall;
    function PatientName: WideString; safecall;
    function PatientDOB: WideString; safecall;
    function PatientSSN: WideString; safecall;
    function LocationIEN: Integer; safecall;
    function LocationName: WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICPRSStateDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC619E-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSStateDisp = dispinterface
    ['{63DC619E-6BE0-11D5-82E6-00C04F72C274}']
    function Handle: WideString; dispid 1;
    function UserDUZ: WideString; dispid 2;
    function UserName: WideString; dispid 3;
    function PatientDFN: WideString; dispid 4;
    function PatientName: WideString; dispid 5;
    function PatientDOB: WideString; dispid 6;
    function PatientSSN: WideString; dispid 7;
    function LocationIEN: Integer; dispid 8;
    function LocationName: WideString; dispid 9;
  end;

// *********************************************************************//
// Interface: ICPRSExtension
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC61C4-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSExtension = interface(IDispatch)
    ['{63DC61C4-6BE0-11D5-82E6-00C04F72C274}']
    function Execute(const CPRSBroker: ICPRSBroker; const CPRSState: ICPRSState; 
                     const Param1: WideString; const Param2: WideString; const Param3: WideString; 
                     var Data1: WideString; var Data2: WideString): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  ICPRSExtensionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {63DC61C4-6BE0-11D5-82E6-00C04F72C274}
// *********************************************************************//
  ICPRSExtensionDisp = dispinterface
    ['{63DC61C4-6BE0-11D5-82E6-00C04F72C274}']
    function Execute(const CPRSBroker: ICPRSBroker; const CPRSState: ICPRSState; 
                     const Param1: WideString; const Param2: WideString; const Param3: WideString; 
                     var Data1: WideString; var Data2: WideString): WordBool; dispid 1;
  end;

implementation

uses ComObj;

end.
