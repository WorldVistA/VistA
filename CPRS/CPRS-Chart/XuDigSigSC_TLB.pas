unit XuDigSigSC_TLB;

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

// PASTLWTR : $Revision:   1.130.1.0.1.0.1.6  $
// File generated on 6/12/2003 4:03:57 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Projects\CryptoAPI2\SignCOM\XuDigSigSC.tlb (1)
// LIBID: {37B1AC3C-8CFB-41C2-951B-D1BCBD90DBBE}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
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
  XuDigSigSCMajorVersion = 1;
  XuDigSigSCMinorVersion = 1;

  LIBID_XuDigSigSC: TGUID = '{37B1AC3C-8CFB-41C2-951B-D1BCBD90DBBE}';

  IID_IXuDigSigS: TGUID = '{4F007CD0-ED3A-4022-AC5F-01D8494B02CF}';
  CLASS_XuDigSigS: TGUID = '{12037083-5899-495D-818D-BF4EC57C42C7}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IXuDigSigS = interface;
  IXuDigSigSDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  XuDigSigS = IXuDigSigS;


// *********************************************************************//
// Interface: IXuDigSigS
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4F007CD0-ED3A-4022-AC5F-01D8494B02CF}
// *********************************************************************//
  IXuDigSigS = interface(IDispatch)
    ['{4F007CD0-ED3A-4022-AC5F-01D8494B02CF}']
    procedure Set_DataBuffer(const Param1: WideString); safecall;
    procedure Set_UsrNumber(const Param1: WideString); safecall;
    function Get_DEAsig: WordBool; safecall;
    procedure Set_DEAsig(Value: WordBool); safecall;
    function Get_DEAInfo: WideString; safecall;
    function Get_HashValue: WideString; safecall;
    function Get_Signature: WideString; safecall;
    procedure Set_DrugSch(const Param1: WideString); safecall;
    function Signdata: WordBool; safecall;
    function Get_Reason: WideString; safecall;
    procedure Set_UsrName(const Param1: WideString); safecall;
    function Get_CrlUrl: WideString; safecall;
    procedure Reset; safecall;
    procedure GetCSP; safecall;
    function Get_SubReason: WideString; safecall;
    property DataBuffer: WideString write Set_DataBuffer;
    property UsrNumber: WideString write Set_UsrNumber;
    property DEAsig: WordBool read Get_DEAsig write Set_DEAsig;
    property DEAInfo: WideString read Get_DEAInfo;
    property HashValue: WideString read Get_HashValue;
    property Signature: WideString read Get_Signature;
    property DrugSch: WideString write Set_DrugSch;
    property Reason: WideString read Get_Reason;
    property UsrName: WideString write Set_UsrName;
    property CrlUrl: WideString read Get_CrlUrl;
    property SubReason: WideString read Get_SubReason;
  end;

// *********************************************************************//
// DispIntf:  IXuDigSigSDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4F007CD0-ED3A-4022-AC5F-01D8494B02CF}
// *********************************************************************//
  IXuDigSigSDisp = dispinterface
    ['{4F007CD0-ED3A-4022-AC5F-01D8494B02CF}']
    property DataBuffer: WideString writeonly dispid 1;
    property UsrNumber: WideString writeonly dispid 2;
    property DEAsig: WordBool dispid 3;
    property DEAInfo: WideString readonly dispid 4;
    property HashValue: WideString readonly dispid 5;
    property Signature: WideString readonly dispid 6;
    property DrugSch: WideString writeonly dispid 7;
    function Signdata: WordBool; dispid 8;
    property Reason: WideString readonly dispid 9;
    property UsrName: WideString writeonly dispid 10;
    property CrlUrl: WideString readonly dispid 11;
    procedure Reset; dispid 12;
    procedure GetCSP; dispid 13;
    property SubReason: WideString readonly dispid 14;
  end;

// *********************************************************************//
// The Class CoXuDigSigS provides a Create and CreateRemote method to          
// create instances of the default interface IXuDigSigS exposed by              
// the CoClass XuDigSigS. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoXuDigSigS = class
    class function Create: IXuDigSigS;
    class function CreateRemote(const MachineName: string): IXuDigSigS;
  end;

implementation

uses ComObj;

class function CoXuDigSigS.Create: IXuDigSigS;
begin
  Result := CreateComObject(CLASS_XuDigSigS) as IXuDigSigS;
end;

class function CoXuDigSigS.CreateRemote(const MachineName: string): IXuDigSigS;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XuDigSigS) as IXuDigSigS;
end;

end.
