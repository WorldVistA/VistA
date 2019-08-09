unit uGMV_DLLCommon;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 1/16/09 2:17p $
*       Developer:    dddddddddomain.user@domain.ext
*       Site:         Hines OIFO
*
*       Description:  Common DLL handling functions.
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSUTILS/uGMV_DLLCommon.pas $
*
* $History: uGMV_DLLCommon.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSUTILS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:39p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/VITALSUTILS
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 1/20/09    Time: 3:42p
 * Updated in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSUTILS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/VITALSUTILS
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 7/17/07    Time: 2:30p
 * Updated in $/Vitals GUI 2007/Vitals-5-0-18/VITALSUTILS
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
 * User: Zzzzzzandria Date: 1/25/06    Time: 8:57a
 * Created in $/Vitals/Vitals 5.0.3/DLL-Common
 * 060125 test
 *

 ================================================================================
}
interface

uses
  Forms,Windows,Dialogs;

  procedure FindModule(const aLibrary: String; const aModule:String;var H:THandle;var P: Pointer);
  function RunDLLDialog(aLibrary,aFunction:String): Integer;

implementation

// Note: Don't forget to free memory if H is not 0!
procedure FindModule(const aLibrary: String; const aModule:String;var H:THandle;var P: Pointer);
var
  DLLHandle: THandle;
begin
  P := nil;
  try
    DLLHandle := LoadLibrary(PChar(aLibrary));
    if DLLHandle <> 0 then
      begin
        H := DLLHandle;
        P := nil;
        P := GetProcAddress(DLLHandle,PChar(aModule));
{$IFNDEF USEVSMONITOR}
        if not Assigned(P) then
         ShowMessage('Error: Failure loaging function <'+aModule+'>');
      end
    else
      ShowMessage('Error: Failure loaging library <'+PChar(aLibrary)+'>');
{$ELSE}
      end
{$ENDIF}
  except
    H := 0;
    P := nil;
  end;
end;

function RunDLLDialog(aLibrary,aFunction:String): Integer;
type
  TFuncSign = function:Integer;
var
  FuncSign : TFuncSign;
  DLLHandle : THandle;
  P: Pointer;
  i: Integer;
begin
  i := -1;
  FindModule(aLibrary,aFunction,DLLHandle,P);
  if Assigned(P) then
    begin
      @FuncSign := P;
      i := FuncSign;
    end;
  @FuncSign := nil;
  FreeLibrary(DLLHandle);
  Result := i;
end;

end.
