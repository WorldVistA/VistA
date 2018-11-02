{
  RichOle.pas

  Pascal version of richole.h (version: 2005 platform SDK).

  Version 1.3d - always find the most current version at
  http://flocke.vssd.de/prog/code/pascal/rtflabel/

  Copyright (C) 2001-2009 Volker Siebert <flocke@vssd.de>
  All rights reserved.

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation
  the rights to use, copy, modify, merge, publish, distribute, sublicense,
  and/or sell copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.
}

//{$I DelphiVersion.inc}

unit ovcRTF_RichOle;

{$WEAKPACKAGEUNIT}
{$MINENUMSIZE 4}

interface

{$IFDEF WIN32}

uses
  Windows, ActiveX, RichEdit;

(*
 *      RICHOLE.H
 *
 *      Purpose:
 *              OLE Extensions to the Rich Text Editor
 *
 *      Copyright (c) 1985-1999, Microsoft Corporation
 *)

// Structure passed to GetObject and InsertObject
type
  PReObject = ^TReObject;
  {$IFDEF CPPBUILDER}{$EXTERNALSYM _REOBJECT}{$ENDIF}
  _REOBJECT = packed record
    cbStruct: DWORD;            // [00] Size of structure
    cp: Integer;                // [04] Character position of object
    clsid: TCLSID;              // [08] Class ID of object
    oleobj: IOleObject;         // [18] OLE object interface
    stg: IStorage;              // [1C] Associated storage interface
    olesite: IOLEClientSite;    // [20] Associated client site interface
    sizel: TSize;               // [24] Size of object (may be 0,0)
    dvaspect: DWORD;            // [2C] Display aspect to use
    dwFlags: DWORD;             // [30] Object status flags
    dwUser: DWORD;              // [34] Dword for user's use
  end;
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REOBJECT}{$ENDIF}
  REOBJECT = _reobject;
  TReObject = _reobject;

const
  // Flags to specify which interfaces should
  // be returned in the structure above
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_GETOBJ_NO_INTERFACES}{$ENDIF}
  REO_GETOBJ_NO_INTERFACES  = $00000000;
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_GETOBJ_POLEOBJ}{$ENDIF}
  REO_GETOBJ_POLEOBJ        = $00000001;
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_GETOBJ_PSTG}{$ENDIF}
  REO_GETOBJ_PSTG           = $00000002;
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_GETOBJ_POLESITE}{$ENDIF}
  REO_GETOBJ_POLESITE       = $00000004;
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_GETOBJ_ALL_INTERFACES}{$ENDIF}
  REO_GETOBJ_ALL_INTERFACES = $00000007;

  // Place object at selection
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_CP_SELECTION}{$ENDIF}
  REO_CP_SELECTION          = -1;  // why? cardinal(-1);

  // Use character position to specify object instead of index
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_IOB_SELECTION}{$ENDIF}
  REO_IOB_SELECTION         = -1;  // why? cardinal(-1);
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_IOB_USE_CP}{$ENDIF}
  REO_IOB_USE_CP            = -2;  // why? cardinal(-2);

  // Object flags
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_NULL}{$ENDIF}
  REO_NULL                  = $00000000;  // No flags
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_READWRITEMASK}{$ENDIF}
  REO_READWRITEMASK         = $0000003F;  // Mask out RO bits
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_DONTNEEDPALETTE}{$ENDIF}
  REO_DONTNEEDPALETTE       = $00000020;  // Object doesn't need palette
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_BLANK}{$ENDIF}
  REO_BLANK                 = $00000010;  // Object is blank
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_DYNAMICSIZE}{$ENDIF}
  REO_DYNAMICSIZE           = $00000008;  // Object defines size always
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_INVERTEDSELECT}{$ENDIF}
  REO_INVERTEDSELECT        = $00000004;  // Object drawn all inverted if sel
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_BELOWBASELINE}{$ENDIF}
  REO_BELOWBASELINE         = $00000002;  // Object sits below the baseline
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_RESIZABLE}{$ENDIF}
  REO_RESIZABLE             = $00000001;  // Object may be resized
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_LINK}{$ENDIF}
  REO_LINK                  = $80000000;  // Object is a link (RO)
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_STATIC}{$ENDIF}
  REO_STATIC                = $40000000;  // Object is static (RO)
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_SELECTED}{$ENDIF}
  REO_SELECTED              = $08000000;  // Object selected (RO)
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_OPEN}{$ENDIF}
  REO_OPEN                  = $04000000;  // Object open in its server (RO)
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_INPLACEACTIVE}{$ENDIF}
  REO_INPLACEACTIVE         = $02000000;  // Object in place active (RO)
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_HILITED}{$ENDIF}
  REO_HILITED               = $01000000;  // Object is to be hilited (RO)
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_LINKAVAILABLE}{$ENDIF}
  REO_LINKAVAILABLE         = $00800000;  // Link believed available (RO)
  {$IFDEF CPPBUILDER}{$EXTERNALSYM REO_GETMETAFILE}{$ENDIF}
  REO_GETMETAFILE           = $00400000;  // Object requires metafile (RO)

  // flags for IRichEditOle::GetClipboardData(),
  // IRichEditOleCallback::GetClipboardData() and
  // IRichEditOleCallback::QueryAcceptData()
  {$IFDEF CPPBUILDER}{$EXTERNALSYM RECO_PASTE}{$ENDIF}
  RECO_PASTE                = $00000000;  // paste from clipboard
  {$IFDEF CPPBUILDER}{$EXTERNALSYM RECO_DROP}{$ENDIF}
  RECO_DROP                 = $00000001;  // drop
  {$IFDEF CPPBUILDER}{$EXTERNALSYM RECO_COPY}{$ENDIF}
  RECO_COPY                 = $00000002;  // copy to the clipboard
  {$IFDEF CPPBUILDER}{$EXTERNALSYM RECO_CUT}{$ENDIF}
  RECO_CUT                  = $00000003;  // cut to the clipboard
  {$IFDEF CPPBUILDER}{$EXTERNALSYM RECO_DRAG}{$ENDIF}
  RECO_DRAG                 = $00000004;  // drag

type
  (*
   * IRichEditOle
   *
   * Purpose:
   *   Interface used by the client of RichEdit to perform OLE-related
   *   operations.
   *
   * //$ REVIEW:
   *   The methods herein may just want to be regular Windows messages.
   *)
  {$IFDEF CPPBUILDER}{$EXTERNALSYM IRichEditOle}{$ENDIF}
  IRichEditOle = interface(IUnknown)
    ['{00020D00-0000-0000-C000-000000000046}']
    // *** IRichEditOle methods ***
    function GetClientSite(out clientSite: IOleClientSite): HRESULT; stdcall;
    function GetObjectCount: Integer; stdcall;
    function GetLinkCount: Integer; stdcall;
    function GetObject(iob: Integer; out ReObject: TReObject;
      dwFlags: DWORD): HRESULT; stdcall;
    function InsertObject(var ReObject: TReObject): HRESULT; stdcall;
    function ConvertObject(iob: Integer; const clsidNew: TCLSID;
      lpStrUserTypeNew: LPCSTR): HRESULT; stdcall;
    function ActivateAs(const clsid, clsidAs: TCLSID): HRESULT; stdcall;
    function SetHostNames(lpstrContainerApp: LPCSTR;
      lpstrContainerObj: LPCSTR): HRESULT; stdcall;
    function SetLinkAvailable(iob: Integer; fAvailable: BOOL): HRESULT; stdcall;
    function SetDvaspect(iob: Integer; dvaspect: DWORD): HRESULT; stdcall;
    function HandsOffStorage(iob: Integer): HRESULT; stdcall;
    function SaveCompleted(iob: Integer; const stg: IStorage): HRESULT; stdcall;
    function InPlaceDeactivate: HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD;
      out dataobj: IDataObject): HRESULT; stdcall;
    function ImportDataObject(const dataobj: IDataObject; cf: TClipFormat;
      hMetaPict: HGLOBAL): HRESULT; stdcall;
  end;

  (*
   * IRichEditOleCallback
   *
   * Purpose:
   *   Interface used by the RichEdit to get OLE-related stuff from the
   *   application using RichEdit.
   *)
  {$IFDEF CPPBUILDER}{$EXTERNALSYM IRichEditOleCallback}{$ENDIF}
  IRichEditOleCallback = interface(IUnknown)
    ['{00020D03-0000-0000-C000-000000000046}']
    // *** IRichEditOleCallback methods ***
    function GetNewStorage(out stg: IStorage): HRESULT; stdcall;
    function GetInPlaceContext(out Frame: IOleInPlaceFrame;
      out Doc: IOleInPlaceUIWindow;
      lpFrameInfo: POleInPlaceFrameInfo): HRESULT; stdcall;
    function ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
    function QueryInsertObject(const clsid: TCLSID; const stg: IStorage;
      cp: Integer): HRESULT; stdcall;
    function DeleteObject(const oleobj: IOleObject): HRESULT; stdcall;
    function QueryAcceptData(const dataobj: IDataObject;
      var cfFormat: TClipFormat; reco: DWORD; fReally: BOOL;
      hMetaPict: HGLOBAL): HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD;
      out dataobj: IDataObject): HRESULT; stdcall;
    function GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD;
      var dwEffect: DWORD): HRESULT; stdcall;
    function GetContextMenu(seltype: Word; oleobj: IOleObject;
      const chrg: TCharRange; var menu: HMENU): HRESULT; stdcall;
  end;

const
  IID_IRichEditOle: TGUID = '{00020D00-0000-0000-C000-000000000046}';
  IID_IRichEditOleCallback: TGUID = '{00020D03-0000-0000-C000-000000000046}';

{$IFDEF CPPBUILDER}{$EXTERNALSYM RichEdit_SetOleCallback}{$ENDIF}
function RichEdit_SetOleCallback(Wnd: HWND;
  const Intf: IRichEditOleCallback): Boolean;
{$IFDEF CPPBUILDER}{$EXTERNALSYM RichEdit_GetOleInterface}{$ENDIF}
function RichEdit_GetOleInterface(Wnd: HWND; out Intf: IRichEditOle): Boolean;

{$ENDIF}

implementation

{$IFDEF WIN32}

function RichEdit_SetOleCallback(Wnd: HWND;
  const Intf: IRichEditOleCallback): Boolean;
begin
  Result := SendMessage(Wnd, EM_SETOLECALLBACK, 0, NativeInt(Intf)) <> 0;
end;

function RichEdit_GetOleInterface(Wnd: HWND; out Intf: IRichEditOle): Boolean;
begin
  Result := SendMessage(Wnd, EM_GETOLEINTERFACE, 0, NativeInt(@Intf)) <> 0;
end;

{$ENDIF}

end.
