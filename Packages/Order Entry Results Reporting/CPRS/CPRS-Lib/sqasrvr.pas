        {*************************************************************************
        *
        * Copyright 2000 - 2004 Rational Software Corporation. All Rights Reserved.
        * This software contains proprietary and confidential information of Rational
        * and its suppliers. Use, disclosure or reproduction is prohibited
        * without the prior express written consent of Rational.
        *
        *    Name:              sqasrvr.pas
        *    Description:
        *
        *    Revision History:
        *    Programmer         Date       Description
        *    sraj               05/18/2004 Fixed Delphi 5 compilation issues.
        *    sraj               07/25/2003 Supported TTreeView items collection in properties.
        *    sraj               07/25/2003 Supported TStringGrid object data.
        *    sraj               24/04/2003 RATLC00447073: Included FindControl1() to lookup delphi object
        *                                  given a window handle effectively.
        *    sraj               10/03/2002 RATLC00436896, RATLC00052492 : Included BeautifyApplicationWindow
        *    sraj               06/23/2003 RATLC00449186 : Exception trace enabled using a Registry key.
        *    sraj               10/03/2002 RATLC00436896, RATLC00052492 : Included BeautifyApplicationWindow
        *                                  to make application object available as a window property.
        *                                  Removed the call RegisterAutomationServer() from unit Initialization.
        *    PBeaulieu          01/08/2002 Changed TPublishedAutoDispatch.NewDispatch to set the found
        *                                  flag if found in first case to bypass the second search method.
        *    PBeaulieu          08/20/2001 Changed TIObjectDispatch.GetProperty inorder to make
        *                                  sure that Unassigned Variant or incorrect Variant type
        *                                  would not be used in retrieving a property. Changed
        *                                  TPublishedAutoDispatch.NewDispatch to search manually the
        *                                  inheritance hierarchy if InheritsFrom fails.  This allows
        *                                  for objects that the InheritsFrom function fails on
        *                                  seemingly because it cannot access the information with
        *                                  the functions it is using.  This seemed to happen with
        *                                  MDI app where the MDI children were created from another
        *                                  dll that encapsulated the form in another object.
        *    PBeaulieu	        06/26/01   Merged in Pete Ness's changes to fix some warnings and
        *                                  to add some logging for exceptions.  Also, added the function
        *                                  TIObjectDispatch.ParentClassName.
        *    PMNess             05/16/01   Changed the "Classname" calls in TPublishedAutoDispatch
        *                                  to FObject.Classname - as Classname was always
        *                                  returning TPublishedAutoDispatch instead of
        *                                  the actual invoked class.
        *    PMNess             05/15/01   Updated and removed hints/warnings under D5
        *                                  Added try/excepts around all automated calls
        *                                  to trap exceptions that may happen and log to
        *                                  file.
        *    KPATEL             05/25/00   Replaced the function 'VarAsType' with
        *                                  'VarToStr' as Delphi 5 takes only string as
        *                                  the third parameter in SetStrProp function.
        *    SJPak              03/31/98   Modified TIObjectDispatch.GetEnumList to
        *                                  return empty variant when the total length of
        *                                  the strings for enumerated choices exceed
        *                                  2047.  This is to keep Robot from crashing
        *                                  Robot cannot handle more 2048 characters total.
        *    SJPak              04/02/97   Modified TPublishedAutoDispatch.Invoke to
        *                                  support TColor type properties.
        *    SJPak              08/04/96   Added additional interface TIStringGridDispatch
        *                                  to support Cols and Rows properties of TStringGrid.
        *    SJPak              03/06/97   Modified TICollectionDispatch.GetPropNames
        *                                  and TICollectionDispatch.GetProperty to support
        *                                  Items property.
        *    SJPak              11/21/96   Replacing calls to OLECheck which
        *                                  will raise an exception when return value
        *                                  is less than 0.  Raising an exception
        *                                  will cause a messagebox to pop up when ran
        *                                  from Delphi IDE.
        *    SJPak              11/15/96   Fixed a memory leak in
        *                                  TIObjectDispatch.SetProperty
        *    SJPak              11/11/96   Modified TIStringsDispatch.GetProperty
        *                                  to check for empty "Strings" property.
        *    SJPak              11/07/96   Removed calls to OleError to prevent
        *                                  error messages being displayed during
        *                                  Rec/Plaback session through IDE.
        *    SJPak              10/07/96   Modified TIStringsDispatch to support
        *                                  Strings property of TStrings object.
        *    SJPak              09/19/96   Changed CLSID of the server.
        *    SJPak              08/04/96   Added additional interface TIOleControlDispatch
        *                                  to support OCXs.
        *    SJPak              08/01/96   Modified TPublishedAutoDispatch.Invoke
        *                                  to return tkSet type properties as
        *                                  a safe array of Variants containing
        *                                  names of all possible items in the set
        *                                  and booleans representing whether the items
        *                                  are in the particular set.
        *    SJPak              07/31/96   Fixed Borland's bug in
        *                                  TPublishedAutoDispatch.Invoke function's
        *                                  handling of min and max values of
        *                                  tkSet properties.
        *    SJPak              07/18/96   Changed Unit name to SQASrvr
        *    SJPak              07/18/96   Added addtional interface TIStringsDispatch
        *                                  to support TStrings class.
        *    SJPak              07/18/96   Added GetPropNames and GetProeprty to
        *                                  TICollectionDispatch.
        *    SJPak              07/18/96   Added GetPropNames method to TIObjectDispatch
        *                                  interface.
        *    SJPak              07/08/96   Added SetProperty method to TIObjectDispatch
        *                                  interface.
        *    SJPak              07/08/96   Additional interface define for
        *                                  DatSet Objects.
        *    SJPak              07/01/96   Fixed a bug in TPublishedAutoDispatch.Invoke
        *    SJPak              07/01/96   Additional interface defined for
        *                                  collections.
        *    SJPak              07/01/96   Original From Delphi.
        *
        **************************************************************************}
        unit SQASrvr;

        interface

        uses
          Windows,
			{$IFDEF VER140}
				Variants,
			{$ENDIF}
			{$IFDEF VER150}
				Variants,
      {$ELSE}      //Added for Delphi 2006
        Variants,  //Added for Delphi 2006
			{$ENDIF}
          OleAuto,
          OLE2, TypInfo, DB, DBTables, OleCtrls, Grids, Controls, Registry, ComCtrls;
        const
          AutoClassExistsMsg = 'Automation enabler for class %s is already registered';

          { FirstComponentIndex needs to be high enough so that it doesn't conflict with
            the DispIDs of the TAutoObject.  The "automated" properties and methods have
            DispIDs starting with 1 in the base object and incrementing by one from
            there. }
          FirstComponentIndex  = $000000FF;
          LastComponentIndex   = $0000FFFE;
          FirstPropIndex       = $0000FFFF;
          LastPropIndex        = $7FFFFFFF;  { maxint }
        
          // Arbitrary Max for each element of TStrings.Strings property.
          MaxStringItem = 32000;
        
        type
          { SJP Todo:  This limits the set range from 0 - 15.
            According to Doc. Set can have upto 256 elements }
          TCardinalSet = set of 0..SizeOf(Cardinal) * 8 - 1;
        //  TCardinalSet = set of 0..255;
        
        { TPublishedAutoDispatch }
        
          TPublishedAutoDispatch = class(TAutoDispatch)
          private
            FObject: TObject;
          public
            constructor Create(AutoObject: TAutoObject; BoundObj: TObject);
            procedure NewDispatch(var V: Variant; Obj: TObject);
            function GetIDsOfNames(const iid: TIID; rgszNames: POleStrList;
              cNames: Integer; lcid: TLCID; rgdispid: PDispIDList): HResult; override;
            function Invoke(dispIDMember: TDispID; const iid: TIID; lcid: TLCID;
              flags: Word; var dispParams: TDispParams; varResult: PVariant;
              excepInfo: PExcepInfo; argErr: PInteger): HResult; override;
          end;
        
        { TIObjectDispatch }
        
          TIObjectDispatch = class(TAutoObject)
          private
            procedure GetProps(var v: Variant; TypeKinds: TTypeKinds);
          protected
            FObject: TObject;
            function CreateAutoDispatch: TAutoDispatch; override;
            // 5/16/2001 - PMNess - Added new GetExceptionInfo to log any
            // exception on the invoke to a log file.  This works generically when anything
            // is called...
            procedure GetExceptionInfo(ExceptObject: TObject;
              var ExcepInfo: TExcepInfo); override;
          public
            constructor Connect(Obj: TObject); virtual;
          automated
            function ClassName: String;
            function GetProperty(PropName: String): Variant;
            function GetObject(ObjName: String): Variant;
            procedure GetEnumList(PropName: String; var v: Variant);
            procedure GetProperties(var v: Variant);
            procedure GetObjects(var v: Variant);
            function InheritsFrom(AClass: String): WordBool;
            // SJP: 07/09/96 Added SetProperty.
            function SetProperty(PropName: String; var v: Variant): WordBool;
            // SJP: 07/18/96 Added SetProperty.
            procedure GetPropNames(var v: Variant);
            //PBeaulieu: 05/22/2001 Added ParentClassName
            function ParentClassName: String;
          end;
        
        { TIComponentDispatch }
        
          TIComponentDispatch = class(TIObjectDispatch)
          private
            function GetComponents(Index: Integer): Variant;
            function GetComponentCount: Integer;
            function GetComponentIndex: Integer;
            function GetOwner: Variant;
          protected // 5-16-2001 - Added protected to get rid of hint on GetDesignInfo
            function GetDesignInfo: LongInt;
          automated
            property Components[Index: Integer]: Variant read GetComponents;
            property ComponentCount: Integer read GetComponentCount;
            property ComponentIndex: Integer read GetComponentIndex;
            property Owner: Variant read GetOwner;
            function FindComponent(AName: String): Variant;
          end;
        
        { TIControlDispatch }
        
          TIControlDispatch = class(TIComponentDispatch)
          private
            function GetParent: Variant;
          automated
            property Parent: Variant read GetParent;
          end;
        
        { TIWinControlDispatch }
        
          TIWinControlDispatch = class(TIControlDispatch)
          private
            function GetHandle: Integer;
            function GetControls(Index: Integer): Variant;
            function GetControlCount: Integer;
          automated
            property Handle: Integer read GetHandle;
            property Controls[Index: Integer]: Variant read GetControls;
            property ControlCount: Integer read GetControlCount;
            function ControlAtPos(X, Y: Integer): Variant;
          end;
        
        { TIApplicationDispatch }
        
          TIApplicationDispatch = class(TIComponentDispatch)
          private
            function GetHandle: Integer;
            function GetMainForm: Variant;
            function GetExeName: String;
            function FindControl1(hWndToFind: HWnd): TWinControl;
          public
            constructor Create; override;
          automated
            property Handle: Integer read GetHandle;
            property MainForm: Variant read GetMainForm;
            property ExeName: String read GetExeName;
            function GetDispFromHandle(Handle: Integer): Variant;
          end;
        
        // SJP 07/01/96  Additional interface defined for collections
        { TICollectionDispatch }
        
          TICollectionDispatch = class(TIObjectDispatch)
          private
            function GetItemCount: Integer;
          automated
            property ItemCount: Integer read GetItemCount;
            procedure GetPropNames(var v: Variant);
            function GetProperty(PropName: String): Variant;
          end;
        
        // SJP 07/08/96 Additional interface defined for 'dataset' objects.
        { TIDataSetDispatch }
        
          TIDataSetDispatch = class(TIObjectDispatch)
          private
            function GetFieldCount: Integer;
          automated
            property FieldCount: Integer read GetFieldCount;
            function GetData: String;
          end;
        
        // SJP 07/18/96 Additional interface defined for TStrings Objects
        { TIStringsDispatch }
        
          TIStringsDispatch = class(TIObjectDispatch)
          automated
            function GetProperty(PropName: String): Variant;
            procedure GetPropNames(var v: Variant);
          end;
        
        // SJP 08/03/96 Addition interface defined for TOleControl(OCX) Component
          TIOleControlDispatch = class(TIWinControlDispatch)
          private
            function GetOleObject: Variant;
          automated
            property OleObject: Variant read GetOleObject;
          end;
        
        // SJP 03/10/97 Addition interface defined for TStringGrid Component
          TIStringGridDispatch = class(TIWinControlDispatch)
          automated
            function GetProperty(PropName: String): Variant;
            procedure GetPropNames(var v: Variant);
            function GetData: String;
        end;

        // Addition interface defined for TTreeView Component
          TITreeViewDispatch = class(TIWinControlDispatch)
          automated
            function GetProperty(PropName: String): Variant;
            procedure GetPropNames(var v: Variant);
        end;

        { Support functions}
        
          TIObjectDispatchRef = class of TIObjectDispatch;
        
          PClassMapRecord = ^TClassMapRecord;
          TClassMapRecord = record
            ObjectClass: TClass;
            DispClass: TIObjectDispatchRef;
          end;
        
          procedure FreeClassLists;
        
          procedure RegisterAutomationEnabler( ObjectClass: TClass;
            DispClass: TIObjectDispatchRef);
        
        implementation
        
        uses Forms, Classes, SysUtils;
        
        var
          ClassMap: TList = nil;
        
        // Called when any exception is raised from this COM object.  Logs the
        // error to a log file.
        procedure WriteToLog(ErrorMsg: String);
        var
          LogFile: TextFile;
          LogFileName: String;
        begin // AddToErrorLog
          try
            LogFileName := ExtractFilePath(ParamStr(0))+'\Robot Errors for '+ExtractFileName(ParamStr(0))+'.log';
            AssignFile(LogFile, LogFileName);
            if (FileExists(LogFileName))
            then Append(LogFile)
            else Rewrite(LogFile);
            try
              Writeln(LogFile, DateTimeToStr(Now)+' '+ErrorMsg);
            finally
              CloseFile(LogFile);
            end;
          except
            // Supress this - as we're likely in some kind of error log already!
          end;
        end;
    
        function IsExceptionTraceEnabled( ) :  Boolean;
        var
        	Reg: TRegistry;
        	deTrace: string;
        begin
        	Result := False;
        	Reg := TRegistry.Create;
        	try
        		Reg.RootKey := HKEY_CURRENT_USER;
        		if Reg.OpenKey('Software\Rational Software\Rational Test\8\Robot', False) then
        	begin
        		deTrace := Reg.ReadString( 'DelphiExceptionTrace' );
        		if ( (deTrace = '1') or ( LowerCase(deTrace) = 'true' ) ) then
        		begin
        			Result := True;
        		end;
        			
        		Reg.CloseKey;
        		end;
        	finally
        		Reg.Free;
        	end;
        end;
                
        { Exit procedure used to free memory used by the ClassList }
        procedure FreeClassLists;
        var
          I: Integer;
        begin
          for I := 0 to ClassMap.Count-1 do
            Dispose(PClassMapRecord(ClassMap[I]));
          ClassMap.Free;
        end;
        
        { This is called in the initialization section of a unit for all new
          automation objects.  It associates an AutoObject with a VCL class. }
        procedure RegisterAutomationEnabler(ObjectClass: TClass;
          DispClass: TIObjectDispatchRef);
        var
          P: PClassMapRecord;
          X: Integer;
          Found: Boolean;
        begin
          if not Assigned(ClassMap) then
          begin
            AddExitProc(FreeClassLists);
            ClassMap := TList.Create;
          end;
          Found := False;
          for X := 0 to ClassMap.Count-1 do
          begin
            P := PClassMapRecord(ClassMap[x]);
            if ObjectClass.InheritsFrom(P^.ObjectClass) then
              if ObjectClass = P^.ObjectClass then
                raise Exception.CreateFmt(AutoClassExistsMsg,[ObjectClass.ClassName])
              else
              begin
                Found := True;
                break;
              end;
          end;
          New(P);
          P^.ObjectClass := ObjectClass;
          P^.DispClass := DispClass;
          if Found then
            { ObjectClass is a descendent of P^.ObjectClass, so insert the descendent
              into the class list in front of the ancestor.  }
            ClassMap.Insert(X,P)
          else
            { ObjectClass is not related to any classes already in the list, so just add
              it to the end of the list. }
            ClassMap.Add(P);
        end;
        
        { TPublishedAutoDispatch }
        
        constructor TPublishedAutoDispatch.Create(AutoObject: TAutoObject; BoundObj: TObject);
        begin
          inherited Create(AutoObject);
          FObject := BoundObj;
        end;
        
        { NewDispatch is called to create an AutoObject bound to a VCL object.
          Example: when the controller calls Application.MainForm.Button1.Caption,
          NewDispatch would be called to return the dispatches for MainForm and
          Button1. Not called directly by the controller.  }
        procedure TPublishedAutoDispatch.NewDispatch(var V: Variant; Obj: TObject);
        var
          i: Integer;
          P: PClassMapRecord;
          Found: Boolean;
          Cls: TClass;
        begin
          VarClear(V);
          Found := FALSE;
          if not (Assigned(Obj) and Assigned(ClassMap)) then Exit;
          for i := 0 to ClassMap.Count - 1 do
          begin
            P := PClassMapRecord(ClassMap[i]);
            if Obj.InheritsFrom(P^.ObjectClass) then
            begin
              V := P^.DispClass.Connect(Obj).OleObject;
              { Do a release here because the Connect does an AddRef and the
                OleObject does an AddRef, we only want 1. }
              VarToInterface(V).Release;
              Found := TRUE;
              break;
            end;
          end;

          if Found = FALSE then
          begin
                  for i := 0 to ClassMap.Count - 1 do
                  begin
                    P := PClassMapRecord(ClassMap[i]);

                    if Obj.ClassName = P^.ObjectClass.ClassName then
                    begin
                          V := P^.DispClass.Connect(Obj).OleObject;
                          { Do a release here because the Connect does an AddRef and the
                          OleObject does an AddRef, we only want 1. }
                          VarToInterface(V).Release;
                          break;
                    end;

                    Cls := Obj.ClassParent;

                    while( Cls <> nil ) do
                    begin
                        if Cls.ClassName = P^.ObjectClass.ClassName then
                        begin
                          V := P^.DispClass.Connect(Obj).OleObject;
                          { Do a release here because the Connect does an AddRef and the
                          OleObject does an AddRef, we only want 1. }
                          VarToInterface(V).Release;
                          Found := TRUE;
                         break;
                       end;
                       Cls := Cls.ClassParent;
                   end;

                   if Found = TRUE then
                   begin
                        break;
                   end;
                  end;
          end;
        end;
        
        {  Searches through the published properties of the associated object for the
           requested name (property).  If it is not found it calls the inherited
           GetIDsOfNames which will then search through the TAutoObject's "automated"
           section for the name. }
        function TPublishedAutoDispatch.GetIDsOfNames(const iid: TIID; rgszNames: POleStrList;
          cNames: Integer; lcid: TLCID; rgdispid: PDispIDList): HResult;
        var
          PropName: string;
          SubComponent: TComponent;
        begin
          if cNames <> 1 then
          begin
            Result := inherited GetIDsOfNames(iid, rgszNames, cNames, lcid, rgdispid);
            Exit;
          end;
          Result := DISP_E_UNKNOWNNAME;
          PropName := WideCharToString(rgszNames^[0]);
          rgdispid^[0] := TDISPID(GetPropInfo(FObject.ClassInfo, PropName));
          if rgdispid^[0] <> 0 then
          begin
            if PPropInfo(rgdispid^[0])^.PropType^.Kind in [tkInteger, tkEnumeration,
              tkString, tkFloat, tkClass, tkSet, tkMethod, tkLString{, tkLWString}] then
              Result := S_OK;
          end
          else if FObject is TComponent then
          begin
            SubComponent := TComponent(FObject).FindComponent(PropName);
            if SubComponent <> nil then
            begin
              rgdispid^[0] := FirstComponentIndex + TDispID(SubComponent.ComponentIndex);
              Result := S_OK;
            end;
          end;
          { Pass to inherited if nothing resolves the call. }
          if Result <> S_OK then
            Result := inherited GetIDsOfNames(iid, rgszNames, cNames, lcid, rgdispid);
        end;
        
        { Gets a property or calls a method of the associated object.  If the
          dispIDMember is less than FirstComponentIndex it should be in the AutoObject,
          otherwise it attempts to find the request in the published section of the
          associated object. }
        function TPublishedAutoDispatch.Invoke(dispIDMember: TDispID; const iid: TIID; lcid: TLCID;
              flags: Word; var dispParams: TDispParams; varResult: PVariant;
              excepInfo: PExcepInfo; argErr: PInteger): HResult;
        var
          PropInfo: PPropInfo;
          W: Cardinal;
          TypeInfo: PTypeInfo;
          TypeData: PTypeData;
          ErrorMessage: String;
          I: Integer;
          J: Integer;
        //  SetItemString: String;
        begin
          Result := DISP_E_MEMBERNOTFOUND;
          PropInfo := NIL;
          try
            { If it is a component then call NewDispatch to return the IDispatch to
              the controller }
            if (dispIDMember >= FirstComponentIndex) and
               (dispIDMember <= LastComponentIndex) then
            begin
              NewDispatch(VarResult^,TComponent(FObject).Components[dispIDMember - FirstComponentIndex]);
              Result := S_OK;
            end
            { Check to see if it is a property }
            else if (dispIDMember >= FirstPropIndex) then
        //           and (dispIDMember <= LastPropIndex) 5-16-2001 Removed - as this is always true
            begin
              PropInfo := PPropInfo(dispIDMember);
              if Flags and DISPATCH_PROPERTYGET <> 0 then  //Only Get Property
              begin
                VarClear(VarResult^);
                Result := S_OK;
                case PropInfo^.PropType^.Kind of
                  tkInteger:
                  begin
                    VarResult^ := GetOrdProp(FObject, PropInfo);
                    // SJP: 04/02/97 Modifying original.
                    //      Set a flag to indicate Color property.
                    if PropInfo^.PropType^.Name = 'TColor' then
                    begin
                      TVariantArg(VarResult^).wReserved1 := 8;
                    end;
                  end;
                  tkEnumeration:
                  // SJP: 07/10/96  Modifying original.
                  //      Now tkEnumeration properties will
                  //      be returned as VT_I2;
                  begin
                    //TVariantArg(VarResult^).vt := VT_BSTR;
                    //TVariantArg(VarResult^).bstrVal := StringToOleStr(
                    //GetEnumName(PropInfo^.PropType, GetOrdProp(FObject, PropInfo)));
                    TVariantArg(VarResult^).vt := VT_I2;
                    TVariantArg(VarResult^).iVal := GetOrdProp(FObject, PropInfo);
                  end;
                  tkFloat:
                    VarResult^ := GetFloatProp(FObject, PropInfo);
                  tkString:
                    VarResult^ := GetStrProp(FObject, PropInfo);
                  tkSet:
                  begin
                    // SJP: 07/31/96 Modifying the original.
                    //      Changing to return a safe array of Variants containing
                    //      Names of all possible items in the set
                    //      and booleans representing whether the items are
                    //      in this particular set.
        //          SetItemString := '[';
                    W := GetOrdProp(FObject, PropInfo);
        {$IFDEF VER90}
                    TypeData := GetTypeData(PropInfo^.PropType);
                    TypeInfo := TypeData^.CompType;
        {$ELSE}
                    TypeData := GetTypeData(PropInfo^.PropType^);
                    TypeInfo := TypeData^.CompType^;
        {$ENDIF}
                    // SJP: 07/31/96 Modifying the original Borland code.
                    //      Get the TypeData again from the TypeInfo
                    //      TypeInfo represents the OrdType of the set.
                    //      the new TypeData will have correct MinValue and MaxValue.
                    TypeData := GetTypeData(TypeInfo);
                    VarResult^ := VarArrayCreate([0, TypeData^.MaxValue - TypeData^.MinValue, 0, 1], varVariant);
                    J := 0;
                    for I := TypeData^.MinValue to TypeData^.MaxValue do
                    begin
                      VarResult^[J, 0] := GetEnumName(TypeInfo, I);
                      if I in TCardinalSet(W) then
                        VarResult^[J, 1] := True
                      else
                        VarResult^[J, 1] := False;
                      J := J + 1;
                    end;
        //            begin
        //              if Length(SetItemString) <> 1 then
        //                SetItemString := SetItemString + ',';
        //              SetItemString := SetItemString + GetEnumName(TypeInfo, I);
        //            end;
        //          SetItemString := SetItemString + ']';
        //          TVariantArg(VarResult^).vt := VT_BSTR;
        //          TVariantArg(VarResult^).bstrVal := StringToOleStr(SetItemString);
                  end;
                  tkClass:
                    NewDispatch(VarResult^, TObject(GetOrdProp(FObject, PropInfo)));
                  tkLString:
                  begin
                    TVariantArg(VarResult^).vt := VT_BSTR;
                    TVariantArg(VarResult^).bstrVal := StringToOleStr(GetStrProp(FObject, PropInfo));
                  end;
                else
                  Result := E_NOTIMPL;
                end;
              end
              else if Flags and DISPATCH_PROPERTYPUT <> 0 then
              begin
                Result := S_OK;
                case PropInfo^.PropType^.Kind of
                  tkInteger:
                    SetOrdProp(FObject, PropInfo, VarAsType(Variant(dispParams.rgvarg[0]),varInteger));
                  tkString:
        //      KPATEL: Replaced the function 'VarAsType' with 'VarToStr' as Delphi 5
        //      takes only string as the third parameter in SetStrProp function.
        //            SetStrProp(FObject, PropInfo, VarAsType(Variant(dispParams.rgvarg[0]),varString));
                    SetStrProp(FObject, PropInfo, VarToStr(Variant(dispParams.rgvarg[0])));
                  tkLString:
        //      KPATEL: Replaced the function 'VarAsType' with 'VarToStr' as Delphi 5
        //      takes only string as the third parameter in SetStrProp function.
        //            SetStrProp(FObject, PropInfo, VarAsType(Variant(dispParams.rgvarg[0]),varString));
                    SetStrProp(FObject, PropInfo, VarToStr(Variant(dispParams.rgvarg[0])));
                  tkEnumeration:
                    SetOrdProp(FObject, PropInfo, VarAsType(Variant(dispParams.rgvarg[0]),varSmallInt));
                  tkFloat:
                    SetFloatProp(FObject, PropInfo, VarAsType(Variant(dispParams.rgvarg[0]),varSingle));
        {          tkSet:
                  begin
                    SetItemString := '[';
                    W := GetOrdProp(FObject, PropInfo);
                    TypeData := GetTypeData(PropInfo^.PropType);
                    TypeInfo := TypeData^.CompType;
                    // SJP:  Commented out because TypeData^.MinValue/MaxValue is
                    //       bogus.
        //          ShowMessage(IntToStr(TypeData^.MinValue));
        //          ShowMessage(IntToStr(TypeData^.MaxValue));
        //          for I := TypeData^.MinValue to TypeData^.MaxValue do
                    for I := 0 to 255 do
                      if I in TCardinalSet(W) then
                      begin
                        if Length(SetItemString) <> 1 then
                          SetItemString := SetItemString + ',';
                        SetItemString := SetItemString + GetEnumName(TypeInfo, I);
                      end;
                    SetItemString := SetItemString + ']';
                    TVariantArg(VarResult^).vt := VT_BSTR;
                    TVariantArg(VarResult^).bstrVal := StringToOleStr(SetItemString);
                  end;}
                else
                  Result := E_NOTIMPL;
                end;
              end;
            end;
            { If not found then pass it to the TAutoDispatch.Invoke method. }
            if Result <> S_OK then
            begin
              Result := inherited Invoke(dispIDMember, iid, lcid, flags, dispParams,
                                         varResult, excepInfo, argErr);
            end
          except
            on E:Exception
            do begin
              ErrorMessage := FObject.ClassName;
              if (Assigned(PropInfo)) then ErrorMessage := ErrorMessage + '.' + PropInfo.Name;
        
              if ExcepInfo <> nil then
              begin
                FillChar(ExcepInfo^, 0, SizeOf(TExcepInfo));
                //Copied this from TAutoObject.GetExceptionInfo
                with ExcepInfo^ do
                begin
                  bstrSource := StringToOleStr(FObject.ClassName);
                  if ExceptObject is Exception then
                  begin
                    bstrDescription := StringToOleStr(Exception(ExceptObject).Message);
                    ErrorMessage := ErrorMessage + ': ' + Exception(ExceptObject).Message;
                  end
                  else ErrorMessage := ErrorMessage + ': ' + E.Message;
                  scode := E_FAIL;
                end;
              end
              else ErrorMessage := ErrorMessage + ': ' + E.Message;
        
              WriteToLog(ErrorMessage);
              Result := DISP_E_EXCEPTION;
            end;
          end;
        end;
        
        { TIObjectDispatch }
        
        { Obj is the Object that is being "Bound" to here.  This AutoObject will then
          surface properties for Obj. }
        constructor TIObjectDispatch.Connect(Obj: TObject);
        begin
          FObject := Obj;
          inherited Create;
        end;
        
        function TIObjectDispatch.CreateAutoDispatch: TAutoDispatch;
        begin
          Result := TPublishedAutoDispatch.Create(Self, FObject);
        end;
        
        // New override to trap exceptions raised in the invoke.
        // 5/16/2001 - PMNess
        procedure TIObjectDispatch.GetExceptionInfo(ExceptObject: TObject;
          var ExcepInfo: TExcepInfo);
        begin
          try
            if (ExceptObject is Exception) then
            begin
              WriteToLog(PChar(Exception(ExceptObject).Message));
            end;
          except
            // 5/16/2001 - PMNess
            // If the exception object has a problem, we don't want to cause another
            // exception here, so just mask it.
          end;
          inherited;
        end;
        
        function TIObjectDispatch.ClassName: String;
        begin
          Result := FObject.ClassName;
        end;
        
        function TIObjectDispatch.ParentClassName: String;
        var
         P: TClass;
         ClassNames: String;
        begin
          P := FObject.ClassParent;
          ClassNames := '';
        
          while( P <> nil ) do
          begin
                if Length(ClassNames) > 0 then
                begin
                        ClassNames := ClassNames + ',';
                end;
        
                ClassNames := ClassNames + P.ClassName;
                
                P := P.ClassParent;
          end;
        
          Result := ClassNames;
        end;
        
        function TIObjectDispatch.InheritsFrom(AClass: String): WordBool;
        var
          P: TClass;
        begin
          P := FObject.ClassType;
          while (P <> nil) and (CompareText(P.ClassName, AClass) <> 0) do
            P := P.ClassParent;
          Result := P <> nil;
        end;
        
        { Just a friendly wrapper around GetProperty for ease of use }
        function TIObjectDispatch.GetObject(ObjName: String): Variant;
        begin
          Result := GetProperty(ObjName);
        end;
        
        {  GetProperty can take a full path to a property or object
           (ie Form1.Button1.Caption) and return the value of the property or object
           as a variant. }
        function TIObjectDispatch.GetProperty(PropName: String): Variant;
        var
          Params: TDispParams;
          Index: TDISPID;
          ExpInfo: TEXCEPINFO;
          ArgErr: Integer;
          PWStr: PWideChar;
          Name: String;
          Idx: Integer;
          Holder: Variant;
          guid: TGUID;
        begin
          FillChar(Params,SizeOf(Params),0);
          FillChar(ExpInfo,SizeOf(ExpInfo),0);
          ArgErr := 0;
          Idx := Pos('.', PropName);
          if Idx > 0 then
          begin
            Name := Copy(PropName,1,Idx - 1);
            Delete(PropName,1,Idx);
          end
          else
            Name := PropName;
          PWStr := StringToOleStr(Name);
        
        //  11/21/96 SJPak Replacing calls to OLECheck which will raise an exception
        //                 when return value is less than 0.  Raising an exception
        //                 will cause a messagebox to pop up when ran from IDE.
          if AutoDispatch.GetIDsOfNames(guid, @PWStr, 1, 0, @Index) >= 0 then
            if AutoDispatch.Invoke(Index, guid, 0, Dispatch_PropertyGet or Dispatch_Method,
                                       Params, @Holder, @ExpInfo, @ArgErr) >= 0 then
              if VarType(Holder) = varDispatch then
                VarToInterface(Holder).AddRef;

          SysFreeString(PWStr);
        
          if ( not VarIsEmpty( Holder ) ) and ( VarType( Holder ) = varDispatch ) and ( Idx > 0 ) then
          begin
            Result := Holder.GetProperty(PropName);
            VarToInterface(Holder).Release;
            VarClear(Holder);
          end
          else if ( VarIsEmpty( Holder ) ) then
          begin
            Holder := NULL;
           // VarClear( Holder );
            Result := Holder;
          end
          else
            Result := Holder;
        end;
        
        procedure TIObjectDispatch.GetProps(var v: Variant; TypeKinds: TTypeKinds);
        var
          I, J, Count: Integer;
          PropInfo: PPropInfo;
          TempList: PPropList;
          SetItemString: String;
          W: Cardinal;
        begin
          Count := GetPropList(FObject.ClassInfo, TypeKinds, nil);
          if Count > 0 then
          begin
            v := VarArrayCreate([0, Count - 1, 0, 2], varVariant);
            GetMem(TempList, Count * SizeOf(Pointer));
            try
              GetPropList(FObject.ClassInfo, TypeKinds, TempList);
              for I := 0 to Count - 1 do
              begin
                PropInfo := TempList^[I];
                v[i,2] := PropInfo^.PropType^.Kind;
                case PropInfo^.PropType^.Kind of
                  tkClass:
                  begin
                    v[i,0] := PropInfo^.Name;
                    v[i,1] := '(' + PropInfo^.PropType^.Name + ')';
                  end;
                  tkString,
                  tkLString:
                  begin
                    v[i,0] := PropInfo^.Name;
                    v[i,1] := GetStrProp(FObject,PropInfo);
                  end;
                  tkChar:
                  begin
                    v[i,0] := PropInfo^.Name;
                    v[i,1] := Chr(GetOrdProp(FObject,PropInfo));
                    if IsCharAlpha(Chr(GetOrdProp(FObject,PropInfo))) then
                      v[i,1] := Chr(GetOrdProp(FObject,PropInfo))
                    else
                      v[i,1] := '#' + IntToStr(GetOrdProp(FObject,PropInfo));
                  end;
                  tkInteger:
                  begin
                    v[i,0] := PropInfo^.Name;
                    v[i,1] := IntToStr(GetOrdProp(FObject,PropInfo));
                  end;
                  tkFloat:
                  begin
                    v[i,0] := PropInfo^.Name;
                    v[i,1] := FloatToStr(GetFloatProp(FObject,PropInfo));
                  end;
                  tkEnumeration:
                  begin
                    v[i,0] := PropInfo^.Name;
        {$IFDEF VER90}
                    v[i,1] := GetEnumName(PropInfo^.PropType, GetOrdProp(FObject, PropInfo));
        {$ELSE}
                    v[i,1] := GetEnumName(PropInfo^.PropType^, GetOrdProp(FObject, PropInfo));
        {$ENDIF}
                  end;
                  tkSet:
                  begin
                    v[i,0] := PropInfo^.Name;
                    SetItemString := '[';
                    W := GetOrdProp(FObject, PropInfo);
                    for J := 0 to 15 do
                      if J in TCardinalSet(W) then
                      begin
                        if Length(SetItemString) <> 1 then
                          SetItemString := SetItemString + ',';
                        SetItemString := SetItemString +
        {$IFDEF VER90}
                         GetEnumName(GetTypeData(PropInfo^.PropType)^.CompType, J);
        {$ELSE}
                         GetEnumName(GetTypeData(PropInfo^.PropType^)^.CompType^, J);
        {$ENDIF}
                      end;
                    SetItemString := SetItemString + ']';
                    v[i,1] := SetItemString;
                  end;
                  tkVariant:
                  try
                    v[i,0] := PropInfo^.Name;
                    v[i,1] := VarAsType(GetVariantProp(FObject,PropInfo), varString);
                  except
                    v[i,1] := '(Variant)';
                  end;
        //None of these area implemented...
        //          tkWChar:
        //          tkLWString:
        //          tkUnknown:
        //          tkMethod:
                end;
              end;
            finally
              FreeMem(TempList, Count * SizeOf(Pointer));
            end;
          end;
        end;
        
        procedure TIObjectDispatch.GetProperties(var v: Variant);
        const
          TypeKinds: TTypeKinds = [{tkUnknown,} tkInteger, tkChar, tkEnumeration, tkFloat,
            tkString, tkSet, tkClass, {tkMethod, }{tkWChar, }tkLString, {tkLWString,}
            tkVariant];
        begin
          GetProps(v, TypeKinds);
        end;
        
        procedure TIObjectDispatch.GetObjects(var v: Variant);
        begin
          GetProps(v, [tkClass]);
        end;
        
        { Given the property name this will return an array containing the possible
          values of an enum. }
        procedure TIObjectDispatch.GetEnumList(PropName: String; var v: Variant);
        var
          Name: String;
          Idx: Integer;
          Obj: Variant;
          I, J: Integer;
          TotalLength: Integer;
          PropInfo: PPropInfo;
          TypeData: PTypeData;
        begin
          Idx := Length(PropName);
          while (Idx > 0) and (PropName[Idx] <> '.') do
            Dec(Idx);
          if Idx > 0 then
          begin
            Name := PropName;
            Delete(Name,1,Idx);
            Obj := GetProperty(Copy(PropName,1,Idx - 1));
            try
              Obj.GetEnumList(Name,v);
            finally
              VarToInterface(Obj).Release;
            end;
          end
          else
          begin
            PropInfo := GetPropInfo(FObject.ClassInfo,PropName);
            if PropInfo^.PropType^.Kind <> tkEnumeration then
              raise EOleSysError(DISP_E_TYPEMISMATCH);
        {$IFDEF VER90}
            TypeData := GetTypeData(PropInfo^.PropType);
        {$ELSE}
            TypeData := GetTypeData(PropInfo^.PropType^);
        {$ENDIF}
            j := TypeData^.MaxValue - TypeData^.MinValue;
            v := VarArrayCreate([0, j], varVariant);
            j := 0;
            TotalLength := 0;
            for i := TypeData^.MinValue to TypeData^.MaxValue do
            begin
        {$IFDEF VER90}
              v[j] := GetEnumName(PropInfo^.PropType,i);
        {$ELSE}
              v[j] := GetEnumName(PropInfo^.PropType^,i);
        {$ENDIF}
              TotalLength := TotalLength + Length(v[j]) + 1;
              Inc(j);
            end;
        
            // SJP 3/31/98 Temporary fix to allow buffer overwrite in 6.1 SQAXDEL.DLL
            if TotalLength > 2047 then
            begin
              v := UnAssigned;
            end;
        
          end;
        end;
        
        // SJP: 07/09/96 Added SetProperty.
        function TIObjectDispatch.SetProperty(PropName: String; var v: Variant): WordBool;
        var
          Params: TDispParams;
          Index: TDISPID;
          ExpInfo: TEXCEPINFO;
          ArgErr: Integer;
          PWStr: PWideChar;
          Name: String;
          Idx: Integer;
          Obj: Variant;
          guid: TGUID;
          bSuccess: WordBool;
        begin
          bSuccess := True;
          // Separate the last property from the full path name.
          Idx := Length(PropName);
          while (Idx > 0) and (PropName[Idx] <> '.') do
            Dec(Idx);
          if Idx > 0 then
          begin
            Name := PropName;
            Delete(Name,1,Idx);
            Obj := GetProperty(Copy(PropName,1,Idx - 1));
            try
              bSuccess := Obj.SetProperty(Name,v);
            finally
              VarToInterface(Obj).Release;
            end;
          end
          else
          begin
            FillChar(Params,SizeOf(Params),0);
            FillChar(ExpInfo,SizeOf(ExpInfo),0);
            ArgErr := 0;
            PWStr := StringToOleStr(PropName);
            New(Params.rgvarg);
            Params.rgvarg[0] := TVariantArg(v);
            params.cArgs := 1;
        
        //  11/21/96 SJPak Replacing calls to OLECheck which will raise an exception
        //                 when return value is less than 0.  Raising an exception
        //                 will cause a messagebox to pop up when ran from IDE.
            if AutoDispatch.GetIDsOfNames(guid, @PWStr, 1, 0, @Index) >= 0 then
            begin
              if AutoDispatch.Invoke(Index, guid, 0, Dispatch_PropertyPut,
                                           Params, nil, @ExpInfo, @ArgErr) < 0 then
                bSuccess := False;
            end
            else
              bSuccess := False;
        
            SysFreeString(PWStr);
            Dispose(params.rgvarg);
          end;
          Result := bSuccess;
        end;
        
        // SJP: 07/18/96 Added.
        procedure TIObjectDispatch.GetPropNames(var v: Variant);
        const
          TypeKinds: TTypeKinds = [{tkUnknown,} tkInteger, tkChar, tkEnumeration, tkFloat,
            tkString, tkSet, tkClass, {tkMethod, }{tkWChar, }tkLString, {tkLWString,}
            tkVariant];
        var
          I, Count: Integer;
          PropInfo: PPropInfo;
          TempList: PPropList;
        begin
          Count := GetPropList(FObject.ClassInfo, TypeKinds, nil);
          if Count > 0 then
          begin
            v := VarArrayCreate([0, Count - 1, 0, 1], varVariant);
            GetMem(TempList, Count * SizeOf(Pointer));
            try
              GetPropList(FObject.ClassInfo, TypeKinds, TempList);
              for I := 0 to Count - 1 do
              begin
                PropInfo := TempList^[I];
                v[i,1] := PropInfo^.PropType^.Kind;
                case PropInfo^.PropType^.Kind of
                  tkClass:
                    v[i,0] := PropInfo^.Name;
                  tkString,
                  tkLString:
                    v[i,0] := PropInfo^.Name;
                  tkChar:
                    v[i,0] := PropInfo^.Name;
                  tkInteger:
                    v[i,0] := PropInfo^.Name;
                  tkFloat:
                    v[i,0] := PropInfo^.Name;
                  tkEnumeration:
                    v[i,0] := PropInfo^.Name;
                  tkSet:
                    v[i,0] := PropInfo^.Name;
                  tkVariant:
                    v[i,0] := PropInfo^.Name;
        //None of these area implemented...
        //          tkWChar:
        //          tkLWString:
        //          tkUnknown:
        //          tkMethod:
                end;
              end;
            finally
              FreeMem(TempList, Count * SizeOf(Pointer));
            end;
          end;
        end;
        
        
        { TIComponentDispatch }
        
        function TIComponentDispatch.GetComponents(Index: Integer): Variant;
        begin
          if (Index >= 0) and (Index < TComponent(FObject).ComponentCount) then
            TPublishedAutoDispatch(AutoDispatch).NewDispatch(Result, TComponent(FObject).Components[Index])
          else
            ;
        //    OleError(DISP_E_BADINDEX);
        end;
        
        function TIComponentDispatch.GetComponentCount: Integer;
        begin
          Result := TComponent(FObject).ComponentCount;
        end;
        
        function TIComponentDispatch.GetComponentIndex: Integer;
        begin
          Result := TComponent(FObject).ComponentIndex;
        end;
        
        function TIComponentDispatch.GetOwner: Variant;
        begin
          TPublishedAutoDispatch(AutoDispatch).NewDispatch(Result, TComponent(FObject).Owner)
        end;
        
        function TIComponentDispatch.GetDesignInfo: LongInt;
        begin
          Result := TComponent(FObject).DesignInfo;
        end;
        
        function TIComponentDispatch.FindComponent(AName: String): Variant;
        var
          Obj: TComponent;
        begin
          Obj := TComponent(FObject).FindComponent(AName);
          if Obj <> nil then
            TPublishedAutoDispatch(AutoDispatch).NewDispatch(Result, Obj)
          else
            ;
        //    OleError(DISP_E_UNKNOWNNAME);
        end;
        
        { TICollectionDispatch }
        
        function TICollectionDispatch.GetItemCount: Integer;
        begin
          Result := TCollection(FObject).Count;
        end;
        
        procedure TICollectionDispatch.GetPropNames(var v: Variant);
        var
          Count, I : Integer;
          vTemp : Variant;
        begin
          inherited GetPropNames(vTemp);
          Count := -1;
          if VarIsArray(vTemp) then
            Count := VarArrayHighBound(vTemp, 1);
          v := VarArrayCreate([0, Count + 2, 0, 1], varVariant);
          for I := 0 to Count do
          begin
            v[I, 0] := vTemp[I, 0];
            v[I, 1] := vTemp[1, 1];
          end;
          v[Count + 1, 0] := 'Count';
          v[Count + 1, 1] := tkInteger;
          v[Count + 2, 0] := 'Items';
          v[Count + 2, 1] := tkClass;
          VarClear(vTemp);
        end;
        
        function TICollectionDispatch.GetProperty(PropName: String): Variant;
        var
          Count: Integer;
          I: Integer;
          Item: Variant;
          Holder: Variant;
        begin
          if Propname = 'Count' then
          begin
            Holder := TCollection(FObject).Count;
            Result := Holder;
          end
          else if Propname = 'Items' then
          begin
            Count := TCollection(FObject).Count;
            Holder := VarArrayCreate([0, Count-1], varDispatch);
            for I := 0 to Count-1 do
            begin
              TPublishedAutoDispatch(AutoDispatch).NewDispatch(Item, TCollection(FObject).Items[I]);
              Holder[I] := Item;
            end;
            Result := Holder;
          end
          else
            Result := inherited GetProperty(PropName);
        end;
        
        { TIDataSetDispatch }
        // SJP. 07/08/96 Returns FieldCount for TDataSet Objects.
        function TIDataSetDispatch.GetFieldCount: Integer;
        begin
          Result := TDataSet(FObject).FieldCount;
        end;
        
        // SJP. 07/08/96 Returns Tab-delimited/New-line separated
        // 'data' for TDataSet Objects.
        function TIDataSetDispatch.GetData: String;
        var
          I: Integer;
          Data: String;
          InitialBookMark: TBookMark;
        begin
          InitialBookMark := TDataSet(FObject).GetBookMark;
          Data := '';
          TDataSet(FObject).First;
          while TDataSet(FObject).EOF = False do
          begin
            for I := 0 to TDataSet(FObject).FieldCount - 1 do
            begin
              if TDataSet(FObject).Fields[I].InheritsFrom(TMemoField) then
                Data := Data + '(Memo)'
              else if TDataSet(FObject).Fields[I].InheritsFrom(TGraphicField) then
                Data := Data + '(Graphic)'
              else if TDataSet(FObject).Fields[I].InheritsFrom(TBlobField) then
                Data := Data + '(Blob)'
              else if TDataSet(FObject).Fields[I].InheritsFrom(TBytesField) then
                Data := Data + '(Bytes)'
              else if TDataSet(FObject).Fields[I].InheritsFrom(TVarBytesField) then
                Data := Data + '(Var Bytes)'
              else
                Data := Data + TDataSet(FObject).Fields[I].AsString;
              if I < TDataSet(FObject).FieldCount - 1 then
                Data := Data + #9;
            end;
            TDataSet(FObject).Next;
            Data := Data + #13;
          end;
          TDataSet(FObject).GotoBookMark(InitialBookMark);
          TDataSet(FObject).FreeBookMark(InitialBookMark);
          Result := Data;
        end;
        
        { TIStringDispatch }
        
        procedure TIStringsDispatch.GetPropNames(var v: Variant);
        var
          Count, I : Integer;
          vTemp : Variant;
        begin
          inherited GetPropNames(vTemp);
          Count := -1;
          if VarIsArray(vTemp) then
            Count := VarArrayHighBound(vTemp, 1);
          v := VarArrayCreate([0, Count + 2, 0, 1], varVariant);
          for I := 0 to Count do
          begin
            v[I, 0] := vTemp[I, 0];
            v[I, 1] := vTemp[1, 1];
          end;
          v[Count + 1, 0] := 'Text';
          v[Count + 1, 1] := tkString;
          v[Count + 2, 0] := 'Strings';
          v[Count + 2, 1] := tkString;
          VarClear(vTemp);
        end;
        
        function TIStringsDispatch.GetProperty(PropName: String): Variant;
        var
          I: Integer;
          Count: Integer;
          Holder: Variant;
        begin
          if Propname = 'Strings' then
          begin
            Count := TStrings(FObject).Count;
            if Count > 0 then
            begin
              Holder := VarArrayCreate([0, Count-1], varOleStr);
              for I := 0 to Count-1 do
              begin
                // Arbitrary Max len of 32000
                Holder[I] := Copy(TStrings(FObject).Strings[I], 0, MaxStringItem);
              end;
            end;
            Result := Holder;
          end
          else if Propname = 'Text' then
          begin
            Holder := TStrings(FObject).Text;
            Result := Holder;
          end
          else
            Result := inherited GetProperty(PropName);
        end;
        
        { TIOleControlDispatch }
        
        function TIOleControlDispatch.GetOleObject: Variant;
        begin
          Result := TOleControl(FObject).OleObject;
        end;
        
        { TIStringGridDispatch }
        
        procedure TIStringGridDispatch.GetPropNames(var v: Variant);
        var
          Count, I : Integer;
          vTemp : Variant;
        begin
          inherited GetPropNames(vTemp);
          Count := -1;
          if VarIsArray(vTemp) then
            Count := VarArrayHighBound(vTemp, 1);
          v := VarArrayCreate([0, Count + 2, 0, 1], varVariant);
          for I := 0 to Count do
          begin
            v[I, 0] := vTemp[I, 0];
            v[I, 1] := vTemp[1, 1];
          end;
          v[Count + 1, 0] := 'Cols';
          v[Count + 1, 1] := tkClass;
          v[Count + 2, 0] := 'Rows';
          v[Count + 2, 1] := tkClass;
          VarClear(vTemp);
        end;
        
        function TIStringGridDispatch.GetProperty(PropName: String): Variant;
        var
          Count: Integer;
          I: Integer;
          Item: Variant;
          Holder: Variant;
        begin
          if Propname = 'Cols' then
          begin
            Count := TStringGrid(FObject).ColCount;
            Holder := VarArrayCreate([0, Count-1], varDispatch);
            for I := 0 to Count-1 do
            begin
              TPublishedAutoDispatch(AutoDispatch).NewDispatch(Item, TStringGrid(FObject).Cols[I]);
              Holder[I] := Item;
            end;
            Result := Holder;
          end
          else if Propname = 'Rows' then
          begin
            Count := TStringGrid(FObject).RowCount;
            Holder := VarArrayCreate([0, Count-1], varDispatch);
            for I := 0 to Count-1 do
            begin
              TPublishedAutoDispatch(AutoDispatch).NewDispatch(Item, TStringGrid(FObject).Rows[I]);
              Holder[I] := Item;
            end;
            Result := Holder;
          end
          else
            Result := inherited GetProperty(PropName);
        end;

        function TIStringGridDispatch.GetData: String;
        var
          row, col, RowCount, ColCount: Integer;
          DataTemp, Data: String;
        begin
          //OutputDebugString( PChar( 'TIStringGridDispatch.GetData : ' + #13#10 ) );
          Data := '';

          RowCount := TStringGrid(FObject).RowCount;
          ColCount := TStringGrid(FObject).ColCount;

          for row := 0 to RowCount - 1 do
          begin
            DataTemp := '';
            for col := 0 to ColCount - 1 do
            begin
              DataTemp := DataTemp + TStringGrid(FObject).Cells[ col, row ];
              if col < ColCount - 1 then
                DataTemp := DataTemp + #9;
            end;

            Data := Data + DataTemp + #13;
          end;

          //OutputDebugString( PChar( 'TIStringGridDispatch.GetData Returing: ' + Data + #13#10 ) );
          Result := Data;
        end;

        { TITreeViewDispatch }
        
        procedure TITreeViewDispatch.GetPropNames(var v: Variant);
        begin
          inherited GetPropNames(v);
        end;
        
        function TITreeViewDispatch.GetProperty(PropName: String): Variant;
        var
          Count: Integer;
          I: Integer;
          Holder: Variant;
          Nodes: TTreeNodes;
          Node, NodeTemp: TTreeNode;
          NodePath: string;
        begin
          //OutputDebugString( PChar( 'TITreeViewDispatch.GetProperty : ' + PropName + #13#10) );
          if Propname = 'Items' then
          begin
            Nodes := TTreeView(FObject).Items;
            Count := Nodes.Count;
            Holder := VarArrayCreate([0, Count-1], varOleStr);
            for I := 0 to Count - 1 do
            begin
                Node := Nodes.Item[ I ];
                NodeTemp := Node.Parent;
                NodePath := Node.Text;

                while( NodeTemp <> nil ) do
                begin
                        NodePath := NodeTemp.Text + '->' + NodePath;
                        NodeTemp := NodeTemp.Parent;
                end;
                Holder[I] := Copy( NodePath, 0, MaxStringItem);
            end;
            Result := Holder;
          end
          else
            Result := inherited GetProperty(PropName);
        end;

        { TIControlDispatch }

        function TIControlDispatch.GetParent: Variant;
        begin
          TPublishedAutoDispatch(AutoDispatch).NewDispatch(Result, TControl(FObject).Parent)
        end;
        
        {TIWinControlDispatch}
        
        function TIWinControlDispatch.GetControls(Index: Integer): Variant;
        begin
          if (Index >= 0) and (Index < TWinControl(FObject).ControlCount) then
            TPublishedAutoDispatch(AutoDispatch).NewDispatch(Result, TWinControl(FObject).Controls[Index])
          else
            ;
        //    OleError(DISP_E_BADINDEX);
        end;
        
        function TIWinControlDispatch.GetHandle: Integer;
        begin
          Result := TWinControl(FObject).Handle;
        end;
        
        function TIWinControlDispatch.GetControlCount: Integer;
        begin
          Result := TWinControl(FObject).ControlCount;
        end;
        
        function TIWinControlDispatch.ControlAtPos(X, Y: Integer): Variant;
        var
          Pt: TPoint;
          Control: TControl;
        begin
          Pt.y := Y;
          Pt.x := X;
          Control := TWinControl(FObject).ControlAtPos(Pt, True);
          if Control <> nil then
            TPublishedAutoDispatch(AutoDispatch).NewDispatch(Result, Control)
          else
            ;
        //    OleError(DISP_E_BADINDEX);
        end;
        
        { TIApplicationDispatch }
        
        constructor TIApplicationDispatch.Create;
        begin
          FObject := Application;
          inherited Create;
        end;
        
        function TIApplicationDispatch.GetDispFromHandle(Handle: Integer): Variant;
        var
          Obj: TObject;
        begin
          Obj := FindControl(Handle);
          if (Obj <> nil) then
            TPublishedAutoDispatch(AutoDispatch).NewDispatch(Result, Obj)
          else
            ;
        //    OleError(DISP_E_PARAMNOTFOUND);
        end;
        
        function TIApplicationDispatch.GetHandle: Integer;
        begin
          Result := TApplication(FObject).Handle;
        end;
        
        function TIApplicationDispatch.GetExeName: String;
        begin
          Result := TApplication(FObject).ExeName;
        end;
        
        function TIApplicationDispatch.GetMainForm: Variant;
        begin
          TPublishedAutoDispatch(AutoDispatch).NewDispatch(Result, TApplication(FObject).MainForm);
        end;
        
        procedure RegisterAutomationServer;
        const
          AutoClassInfo: TAutoClassInfo = (
            AutoClass: TIApplicationDispatch;
            ProgID: 'SQAServer.Application';
            ClassID: '{92E4FBC0-1169-11D0-B5AB-00A02484352C}';
            Description: 'SQA Test Automation Server';
            Instancing: acMultiInstance);
        begin
          Automation.RegisterClass(AutoClassInfo);
        end;

        function GetPropertyName : string;
        var
                propName : string;
        begin
                Result := 'SQAApplicationObject';
                if ( System.IsLibrary ) then
                begin
                        propName := Format( 'SQAApplicationObject_%x', [ HInstance ] );
                        Result := propName;
                end;
        end;

        function GetApplicationHandle: THandle;
        var
                appHandle : THandle;
        begin

                Result := Application.Handle;
                if ( Result = 0 ) then
                begin
                        appHandle := FindWindow( PChar( 'TApplication' ), nil );
                        Result := appHandle;
                end;
        end;

        procedure BeautifyApplicationWindow;
        var
                appD : TIApplicationDispatch;
                propName : string;
                aut : TAutoDispatch;
                V : ^Variant;
                appHandle : THandle;
        begin
                propName := GetPropertyName( );
                appHandle := GetApplicationHandle( );
                //OutputDebugString( PChar( Format( 'DEEnabler: Application handle :<%x>' + #13#10, [ appHandle ] ) ) );

                if ( GetProp( appHandle, PChar(propName) ) = 0 ) then
                begin

                        New( V );
                        VarClear( V^ );
                        appD := TIApplicationDispatch.Create( );
                        aut := appD.AutoDispatch;

                        TVarData(V^).VType := varDispatch;
                        TVarData(V^).VDispatch := aut;
                        //VarToInterface(V^).AddRef;

                        //OutputDebugString( PChar( Format( 'DEEnabler: SetProp <%s> apphandle <%x> object <%x>' + #13#10, [ PChar(propName), appHandle, THandle( V ) ] ) ) );
                        SetProp( appHandle, PChar(propName), THandle( V ) );
                end;
        end;

        procedure RevertApplicationWindowChanges;
        var
                th : THandle;
                V : PVariant;
                propName : PChar;
                appHandle : THandle;
        begin
                propName := 'SQAApplicationObject';

                appHandle := GetApplicationHandle();
                th := Windows.GetProp( appHandle, propName );
                if ( th <> 0 ) then
                begin
                        V := PVariant(th);
                        Dispose( V );
                        //VarToInterface(V^).Release;
                        Windows.RemoveProp( appHandle, propName );
                end;
        end;

	function TIApplicationDispatch.FindControl1(hWndToFind: HWnd): TWinControl;
	var
		lControlAtom: TAtom;
		lControlAtomString: string;
		lOwningProcess: Pointer;
                lUnknownProcess: DWORD;
		lRM_GetObjectInstance: DWORD;
	begin

		Result := nil;
		if (hWndToFind <> 0) then
		begin
			lControlAtomString := Format('ControlOfs%.8X%.8X', [GetWindowLong( hWndToFind, GWL_HINSTANCE), GetCurrentThreadID]);
			lControlAtom := GlobalAddAtom(PChar(lControlAtomString));

			if GlobalFindAtom(PChar(lControlAtomString)) = lControlAtom then
			begin
				Result := Pointer(GetProp(hWndToFind, MakeIntAtom(lControlAtom)))
			end
			else
			begin
				lRM_GetObjectInstance := RegisterWindowMessage(PChar(lControlAtomString));

                                lOwningProcess := nil;
				GetWindowThreadProcessID(hWndToFind, lOwningProcess);

                                lUnknownProcess := GetCurrentProcessID();
				if DWORD(lOwningProcess) = lUnknownProcess then
				begin
					Result := Pointer(SendMessage(hWndToFind, lRM_GetObjectInstance, 0, 0))
				end
				else
				begin
					Result := nil;
				end;
			end;
		end;
	end;

        begin
          RegisterAutomationEnabler(TObject, TIObjectDispatch);
          RegisterAutomationEnabler(TComponent, TIComponentDispatch);
          RegisterAutomationEnabler(TControl, TIControlDispatch);
          RegisterAutomationEnabler(TWinControl, TIWinControlDispatch);
          // SJP: Added 07/01/96.
          RegisterAutomationEnabler(TCollection, TICollectionDispatch);
          // SJP: Added 07/08/96.
          RegisterAutomationEnabler(TDataSet, TIDataSetDispatch);
          // SJP: Added 07/08/96.
          RegisterAutomationEnabler(TStrings, TIStringsDispatch);
          // SJP: Added 08/04/96.
          RegisterAutomationEnabler(TOleControl, TIOleControlDispatch);
          // SJP: Added 03/12/97.
          RegisterAutomationEnabler(TStringGrid, TIStringGridDispatch);
          // TreeView support
          RegisterAutomationEnabler(TTreeView, TITreeViewDispatch);

          //RegisterAutomationServer;
          BeautifyApplicationWindow( );
        end.

