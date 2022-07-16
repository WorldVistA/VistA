unit uGN_RPCLog;

interface

uses
  vcl.StdCtrls,
  fGN_RPCLog, Dialogs, Forms, Classes, System.SysUtils, System.Types, Graphics;

function WorkArea: TRect;

function RPCLogExists: Boolean;
procedure RPCLogInit;
procedure RPCLogClose;
procedure AddLogLine(aLine, aTitle: string; bLoud: Boolean = true);
procedure AddFlag(aText, aTitle: string);
procedure ShowBroker; overload;
procedure ShowBroker(RR: TRect); overload;
procedure RPCLogNext;
procedure RPCLogPrev;
procedure RPCLogSaveAll;
procedure RPCLogDump;
procedure DebugShowServer;
function RPCLogDefaultFileName: TFileName;
procedure RPCLogSetFontSize(aSize: Integer);
procedure RPCLogShowActiveControl;
procedure RPCLogShowVistAObjects;

function AddVistAObject(aName:String; anObject: TObject): Boolean;

procedure DebugListItems(AListBox: TListBox);

var
  RPCLog_SaveAvailable: Boolean; // If TRUE saving of the Log is available
  RPCLog_TrackForms: Boolean; // If TRUE Forms events are tracked
  RPCLog_SaveOnExit: Boolean; // If TRUE Log will be saved by RPCLogClose
  RPCLog_Chronological: Boolean; // If TRUE the oldest record is on the top

  RPCLog_clFlag: Integer = clRed; // clBlack
  RPCLog_clItem: Integer = clBlue;
  RPCLog_clTarget: Integer = clRed;

  RPCLog_bgclTarget: Integer = clYellow;
  RPCLog_bgclFlag: Integer = clBtnFace; //clInfoBk;
  RPCLog_bgclItem: Integer = clInactiveCaption;

  VistAObjects: TStringList;

const

  RPCLog_Title = 'RPC Log';
  RPCLog_ItemBegin = '<<< ';
  RPCLog_ItemEnd = ' >>>';

  RPCLog_Flag = '¤¤¤¤¤¤¤¤¤';
  RPCLog_ItemExport = '---  ';
  RPCLog_OnActivate = '---> Activate';
  RPCLog_OnDeactivate = '---< Deactivate';
  RPCLog_OnCreate = '--»» Create ';
  RPCLog_OnHide = '---¤ Hide ';
  RPCLog_Onshow = '---- Show ';
  RPCLog_OnClose = '---x Close ';
  RPCLog_OnDestroy = '--«« Destroy ';
  RPCLog_Import = '--- IMPORT ---';
  RPCLog_Export = '--- EXPORT ---';

implementation

uses
  System.RTTI,
  VAUtils, WinApi.SHFolder, Windows, ORCtrls, vcl.ComCtrls, vcl.Controls;

var
  RPCLog_Enabled: Boolean; // Indicates the Log is available

procedure DebugListItems(AListBox: TListBox);
var
  sTitle,sText: String;
begin
  try
    begin
      sTitle := aListBox.ClassName;
      if AListBox is TORListBox then
        sText := TORListBox(AListBox).Items.Text
      else
        sText := AListBox.Items.Text;
      AddLogLine(sText,sTitle);
    end;
  finally
  end;
end;

function WorkArea: TRect;
var
  r: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);
  Result := r;
end;

function RPCLogExists: Boolean;
begin
  Result := Assigned(frmRPCLog);
end;

procedure RPCLogInit;
// Create the Log window, updates RPCLog_Enabled flag
begin
  if not Assigned(frmRPCLog) then
    try
      frmRPCLog := TfrmRPCLog.Create(Application);
{$IFNDEF DEBUG}
      frmRPCLog.FileSaveAs1.Visible := False;
      frmRPCLog.FileSaveAs2.Visible := False;
{$ENDIF}
    except
      on E: Exception do
      begin
        ShowMessage('RPC Log: ' + #10#13#10#13 + E.Message);
        if Assigned(frmRPCLog) then
          frmRPCLog.Free;
        frmRPCLog := nil;
      end;
    end;

  RPCLog_Enabled := Assigned(frmRPCLog);
end;

procedure RPCLogClose;
// Destroys the Log window, updates RPCLog_Enabled flag
begin
  RPCLogSaveAll;
  if Assigned(frmRPCLog) then
  begin
    frmRPCLog.Free;
    frmRPCLog := nil;
  end;
  RPCLog_Enabled := Assigned(frmRPCLog);
end;

procedure AddLogLine(aLine, aTitle: string; bLoud: Boolean = true);
// Adds record to the Log. Does nothing if the bLoud is False
var
  sl: TStringList;
begin
  if not bLoud then
    Exit;

  if not RPCLog_Enabled then
    RPCLogInit;

  sl := TStringList.Create;
  sl.Text := aLine;
  frmRPCLog.addLogItem(aTitle, aTitle, sl);
end;

procedure AddFlag(aText, aTitle: string);
// Adds Flag record to the Log
var
  s: String;
begin
  s := RPCLog_Flag + ' ' + aTitle;
  if aText = '' then
    aText := aTitle;
  AddLogLine(aText, s);
end;

procedure ShowBroker(RR: TRect);
// Opens Log Window in specified position
var
  b: Boolean;
begin
  RPCLogInit;
  if Assigned(frmRPCLog) then
  begin
    if (RR.Top <> RR.Bottom) and (RR.Left <> RR.Right) then
    begin
      frmRPCLog.Top := RR.Top;
      frmRPCLog.Left := RR.Left;
      if Screen.MonitorCount > 0 then
        frmRPCLog.Height := RR.Bottom - RR.Top
      else
        frmRPCLog.Height := Screen.DesktopHeight;
      frmRPCLog.Width := RR.Right;
    end;
    b := frmRPCLog.Reviewed;
    frmRPCLog.Show;
    frmRPCLog.BringToFront;
    if not b then // align on first Show
      frmRPCLog.acToTheLeft.Execute;
  end;
end;

procedure ShowBroker;
// Opens Log Window in the default position
var
  RR: TRect;
begin
  RR.Top := 0;
  RR.Bottom := 0;
  RR.Left := 0;
  RR.Right := 0;
  ShowBroker(RR);
end;

procedure RPCLogNext;
// Scrolls Log to the next record
begin
  if Assigned(frmRPCLog) then
    frmRPCLog.doNext;
end;

procedure RPCLogPrev;
// Scrolls Log to the previous record
begin
  if Assigned(frmRPCLog) then
    frmRPCLog.doPrev;
end;

procedure RPCLogSaveAll;
// Saves Lod in the file with the Default name
begin
  if Assigned(frmRPCLog) and RPCLog_SaveOnExit then
    frmRPCLog.SaveAll;
end;

function RPCLogDefaultFileName: TFileName;
// Default file name

// Finds the users special directory (AVCatcher code)
  function LocalAppDataPath: string;
  const
    SHGFP_TYPE_CURRENT = 0;
  var
    path: array [0 .. MaxChar] of char;
  begin
    SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @path[0]);
    Result := StrPas(path);
  end;

begin
  Result := LocalAppDataPath;
  if (Copy(Result, Length(Result), 1) <> '\') then
    Result := Result + '\CPRS\' ;
  if not DirectoryExists(Result) then
    CreateDir(Result);

  Result := Result + piece(ExtractFileName(Application.ExeName), '.', 1) + '_v'
    + FileVersionValue(Application.ExeName, 'FileVersion') + '_Log_' +
    FormatDateTime('YYYY_MM_DD_HH_NN_SS', Now) + '.txt';
end;

procedure DebugShowServer;
begin
  RPCLogInit;
  if Assigned(frmRPCLog) then
  begin
    frmRPCLog.acSymbolTable.Execute;
    ShowBroker;
  end;
end;

procedure RPCLogDump;
begin
  RPCLogInit;
  frmRPCLog.acSaveOnExit.Checked := True;
  frmRPCLog.SaveAll;
end;

procedure RPCLogSetFontSize(aSize: Integer);
begin
  if Assigned(frmRPCLog) then
    frmRPCLog.setFontSize(aSize);
end;

function getObjectInfo(aControl: TObject): String;
var
  aName: String;
  indent, aLine: String;
  anObj, _Obj: TObject;
  aContext: TRttiContext;
  aType: TRttiType;
  aField: TRttiField;
  aRecord: TRTTIRecordType;
  aValue: TValue;

  procedure LogUpdate(aLine: String);
  begin
    Result := Result + #13#10 + aLine;
  end;

  procedure SortResult;
  var
    sl: TStringList;
  begin
    if Result = '' then
      Exit;
    sl := TStringList.Create;
    try
      sl.Text := Result;
      sl.Sort;
      Result := sl.Text;
    finally
      sl.Free;
    end;
  end;

  function ListViewToString(aLV: TListView): String;
  var
    li: TListItem;
    i: Integer;
  begin
    Result := '';
    for li in aLV.Items do
    begin
      Result := Result + '    ' + li.Caption;
      for i := 0 to li.SubItems.Count - 1 do
        Result := Result + '^' + li.SubItems[i];
      Result := Result + #13#10;
    end;
  end;

  function EscapeQuotes(const s: String): String;
  begin
    Result := StringReplace(s, '\', '\\', [rfReplaceAll]);
    Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
  end;

const
  fmtLine = '                            %s';
  fmtNameValue = '%-25.25s %s';
  fmtNameClassValue = '%-25.25s (%-25.25s) %s';

begin
  anObj := TObject(aControl);
  indent := '  ';
  Result := '';

  if anObj = nil then
    Exit;
  if anObj.ClassType = nil then
    Exit;

  if anObj is TStringList then
  begin
    for aLine in TStringList(anObj) do
      Result := Result + #13#10 + aLine;
  end
  else if (anObj is TListBox) then
    Result := TListBox(anObj).Items.Text
  else if (anObj is TListView) then
    Result := ListViewToString(TListView(anObj))
  else
    try
      aType := aContext.GetType(anObj.ClassType);
      if aType.IsRecord then
      begin
        aRecord := aType.AsRecord;
        for aField in aRecord.GetFields do
        begin
          aName := aField.Name;
          aValue := aField.GetValue(anObj);
          Result := Result + #13#10 + aName + '="' + EscapeQuotes(aValue.ToString) + '"';
        end;
      end
      else if aType.IsInstance then
      begin
        for aField in aType.GetFields do
          if aField.FieldType.IsInstance then
          begin
            _Obj := nil;
            try
              _Obj := aField.GetValue(anObj).AsObject;
              if Assigned(_Obj) then
                if _Obj is TStrings then
                begin
                  LogUpdate(indent + Format(fmtNameValue,
                    [aField.Name, _Obj.ClassName]));
                  for aLine in TStrings(_Obj) do
                    if pos(#13, aLine) > 0 then
                      Result := Result + Format(fmtLine, [aLine])
                    else
                      Result := Result + #13#10 + Format(fmtLine, [aLine]);
                end
                else
                  LogUpdate(indent + Format(fmtNameValue,
                    [aField.Name, _Obj.ClassName]));
            except
              on E: Exception do
                if Assigned(_Obj) then
                  LogUpdate(_Obj.ClassName + #13#10 + E.Message);
            end;
          end
          else
            LogUpdate(indent + Format(fmtNameValue,
              [aField.Name, aField.GetValue(anObj).ToString]));
      end;
    except
      on E: Exception do
      begin
        LogUpdate('--------------------------------------------');
        LogUpdate('ClassName <' + anObj.ClassType.ClassName + '>');
        LogUpdate(E.Message);
      end;
    end;
end;

const
  fmtObjTitle = ' %s (%s)';

procedure RPCLogShowActiveControl;
var
  s: String;

begin
  if Assigned(Screen.ActiveControl) then
  begin
    s := 'Form:    ' + Screen.ActiveForm.Name + #13#10;
    s := s + 'Control: ' + Screen.ActiveControl.Name + ' (' +
      Screen.ActiveControl.ClassName + ')' + #13#10#13#10;
    AddLogLine(s + getObjectInfo(Screen.ActiveControl),
      Format(fmtObjTitle, [Screen.ActiveControl.Name,
      Screen.ActiveControl.ClassName]));
  end;
end;

procedure RPCLogShowVistAObjects;
var
  i: Integer;
  anObj: TObject;

begin
  for i := 0 to VistAObjects.Count - 1 do
  begin
    anObj := VistAObjects.Objects[i];
    if Assigned(anObj) then
    begin
      AddLogLine(getObjectInfo(anObj), Format(fmtObjTitle,
        [VistAObjects[i], anObj.ClassName]));
    end;
  end;

end;

function AddVistAObject(aName:String; anObject: TObject): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i  := 0 to VistAObjects.Count - 1 do
    begin
      Result :=  VistAObjects.Objects[i] = anObject;
      if Result then
        break;
    end;
  if not Result then
    VistAObjects.AddObject(aName,anObject);
end;

initialization

RPCLog_Enabled := False;
RPCLog_SaveAvailable := False;
RPCLog_TrackForms := False;
RPCLog_SaveOnExit := False;
RPCLog_Chronological := False;

VistAObjects := TStringList.Create;

finalization

VistAObjects.Free;

end.
