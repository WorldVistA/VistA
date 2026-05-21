unit ORCtrls.FormFontScaler;

///////////////////////////////////////////////////////////////////////////////
/// Based on code from here:
/// https://stackoverflow.com/questions/8296784/how-do-i-make-my-gui-behave-well-when-windows-font-scaling-is-greater-than-100
///////////////////////////////////////////////////////////////////////////////

interface

uses
  Vcl.Graphics,
  Vcl.Forms,
  Vcl.Controls;

type
  TAnchorsArray = array of TAnchors;

  TFormFontScaler = class(TObject)
  private
    class function CreateIconTitleFont: TFont; static;
    class function DisableAnchors(AParentControl: TWinControl)
      : TAnchorsArray; static;
    class procedure DisableAnchorsCore(AParentControl: TWinControl;
      var AAnchorStorage: TAnchorsArray; var AStartingIndex: Integer); static;
    class procedure EnableAnchors(AParentControl: TWinControl;
      AAnchorStorage: TAnchorsArray); static;
    class procedure EnableAnchorsCore(AParentControl: TWinControl;
      AAnchorStorage: TAnchorsArray; var AStartingIndex: Integer); static;
    class function GetControlFont(AControl: TControl): TFont; static;
    class procedure StandardizeFontControlCore(AControl: TControl;
      AForceClearType: Boolean; AFontName: string; AFontSize: Integer;
      AForceFontIfName: string; AForceFontIfSize: Integer); static;
    class procedure StandardizeFontControlFontCore(AControlFont: TFont;
      AForceClearType: Boolean; AFontName: string; AFontSize: Integer;
      AForceFontIfName: string; AForceFontIfSize: Integer); static;
  protected
    class procedure GetUserFontPreference(out AFontName: string;
      out AFontHeight: Integer);
    class function StandardizeFormFont(AForm: TForm; AFontName: string;
      AFontHeight: Integer): Real;
    class procedure ScaleForm(const AForm: TForm; const M, D: Integer);
  public
    class procedure Scale(const AForm: TForm; ANewFontHeight: Integer);
  end;

implementation

uses
  Winapi.MultiMon,
  Winapi.Windows,
  System.Classes,
  System.SysUtils,
  System.UITypes,
  System.TypInfo,
  System.Math,
  Vcl.ComCtrls;

class function TFormFontScaler.CreateIconTitleFont: TFont;
var
  ALogFont: TLogFont;
begin
  Result := nil;
  if not SystemParametersInfo(SPI_GETICONTITLELOGFONT, SizeOf(TLogFont),
    @ALogFont, 0) then
  begin
    RaiseLastOSError;
  end else begin
    Result := TFont.Create;
    try
      Result.Height := ALogFont.lfHeight;
      Result.Orientation := ALogFont.lfOrientation;
      Result.Charset := TFontCharset(ALogFont.lfCharSet);
      Result.Name := PChar(@ALogFont.lfFaceName);

      Result.Style := [];

      if ALogFont.lfWeight >= FW_BOLD then
          Result.Style := Result.Style + [fsBold];

      if ALogFont.lfItalic = 1 then Result.Style := Result.Style + [fsItalic];

      if ALogFont.lfUnderline = 1 then
          Result.Style := Result.Style + [fsUnderline];

      if ALogFont.lfStrikeOut = 1 then
          Result.Style := Result.Style + [fsStrikeOut];

      case ALogFont.lfPitchAndFamily and $F of
        VARIABLE_PITCH: Result.Pitch := fpVariable;
        FIXED_PITCH: Result.Pitch := fpFixed;
      else Result.Pitch := fpDefault;
      end;
    except
      FreeAndNil(Result);
      raise;
    end;
  end;
end;

class procedure TFormFontScaler.GetUserFontPreference(out AFontName: string;
  out AFontHeight: Integer);
// Returns the current font name and height
var
  AFont: TFont;
begin
  AFont := CreateIconTitleFont;
  try
    AFontName := AFont.Name; //e.g. "Segoe UI"
    //Dogfood testing: use a larger AFont than we're used to; to force us to actually test it
    if IsDebuggerPresent then AFont.Size := AFont.Size + 1;
    AFontHeight := AFont.Height; //e.g. -16
  finally
    FreeAndNil(AFont);
  end;
end;

class procedure TFormFontScaler.DisableAnchorsCore(AParentControl: TWinControl;
  var AAnchorStorage: TAnchorsArray; var AStartingIndex: Integer);
var
  ACounter: Integer;
  AChildControl: TControl;
begin
  if (AStartingIndex + AParentControl.ControlCount + 1) >
    (Length(AAnchorStorage)) then
      SetLength(AAnchorStorage, AStartingIndex +
      AParentControl.ControlCount + 1);

  for ACounter := 0 to AParentControl.ControlCount - 1 do
  begin
    AChildControl := AParentControl.Controls[ACounter];
    AAnchorStorage[AStartingIndex] := AChildControl.Anchors;

    //doesn't work for set of stacked top-aligned panels
    //      if ([akRight, akBottom ] * AChildControl.Anchors) <> [] then
    //          AChildControl.Anchors := [akLeft, akTop];

    if (AChildControl.Anchors) <> [akTop, akLeft] then
        AChildControl.Anchors := [akLeft, akTop];

    //      if ([akTop, akBottom] * AChildControl.Anchors) = [akTop, akBottom] then
    //          AChildControl.Anchors := AChildControl.Anchors - [akBottom];

    Inc(AStartingIndex);
  end;

  //Add children
  for ACounter := 0 to AParentControl.ControlCount - 1 do
  begin
    AChildControl := AParentControl.Controls[ACounter];
    if AChildControl is TWinControl then
        DisableAnchorsCore(TWinControl(AChildControl), AAnchorStorage,
        AStartingIndex);
  end;
end;

class function TFormFontScaler.DisableAnchors(AParentControl: TWinControl)
  : TAnchorsArray;
var
  AStartingIndex: Integer;
begin
  AStartingIndex := 0;
  DisableAnchorsCore(AParentControl, Result, AStartingIndex);
end;

class procedure TFormFontScaler.EnableAnchorsCore(AParentControl: TWinControl;
  AAnchorStorage: TAnchorsArray; var AStartingIndex: Integer);
var
  ACounter: Integer;
  AChildControl: TControl;
begin
  for ACounter := 0 to AParentControl.ControlCount - 1 do
  begin
    AChildControl := AParentControl.Controls[ACounter];
    AChildControl.Anchors := AAnchorStorage[AStartingIndex];

    Inc(AStartingIndex);
  end;

  //Restore children
  for ACounter := 0 to AParentControl.ControlCount - 1 do
  begin
    AChildControl := AParentControl.Controls[ACounter];
    if AChildControl is TWinControl then
        EnableAnchorsCore(TWinControl(AChildControl), AAnchorStorage,
        AStartingIndex);
  end;
end;

class procedure TFormFontScaler.EnableAnchors(AParentControl: TWinControl;
  AAnchorStorage: TAnchorsArray);
var
  AStartingIndex: Integer;
begin
  AStartingIndex := 0;
  EnableAnchorsCore(AParentControl, AAnchorStorage, AStartingIndex);
end;

class procedure TFormFontScaler.ScaleForm(const AForm: TForm;
  const M, D: Integer);
// The M and D parameters define a multiplier and divisor by which to scale the
// control.For example, to make a control 75 % of its original Size, specify
// the value of M as 75, and the value of D as 100. Any pair of values that has
// the same ratio has the same effect. Thus M = 3 and D = 4 also makes the
// control 75 % of its previous Size.
var
  AAnchorStorage: TAnchorsArray;
  ARectBefore, ARectAfter, AWorkArea: TRect;
  X, Y: Integer;
  AMonitorInfo: TMonitorInfo;
begin
  if (M = 0) and (D = 0) then Exit;
  if M = D then Exit;

  ARectBefore := AForm.BoundsRect;

  SetLength(AAnchorStorage, 0);
  AAnchorStorage := DisableAnchors(AForm);
  try
    AForm.ScaleBy(M, D);
  finally
    EnableAnchors(AForm, AAnchorStorage);
  end;

  ARectAfter := AForm.BoundsRect;

  case AForm.Position of
    poScreenCenter, poDesktopCenter, poMainFormCenter, poOwnerFormCenter,
      poDesigned:
      //I think I really want everything else to also follow the nudging rules...why did I exclude poDesigned
      begin
        //This was only nudging by one quarter the difference, rather than one half the difference
        //          X := ARectAfter.Left - ((ARectAfter.Right-ARectBefore.Right) div 2);
        //          Y := ARectAfter.Top - ((ARectAfter.Bottom-ARectBefore.Bottom) div 2);
        X := ARectAfter.Left - ((ARectAfter.Right - ARectAfter.Left) -
          (ARectBefore.Right - ARectBefore.Left)) div 2;
        Y := ARectAfter.Top - ((ARectAfter.Bottom - ARectAfter.Top) -
          (ARectBefore.Bottom - ARectBefore.Top)) div 2;
      end;
  else
    //poDesigned, poDefault, poDefaultPosOnly, poDefaultSizeOnly:
    X := ARectAfter.Left;
    Y := ARectAfter.Top;
  end;

  if AForm.Monitor <> nil then
  begin
    AMonitorInfo.cbSize := SizeOf(AMonitorInfo);
    if GetMonitorInfo(AForm.Monitor.Handle, @AMonitorInfo) then
        AWorkArea := AMonitorInfo.rcWork
    else
    begin
      OutputDebugString(PChar(SysErrorMessage(GetLastError)));
      AWorkArea := Rect(AForm.Monitor.Left, AForm.Monitor.Top,
        AForm.Monitor.Left + AForm.Monitor.Width,
        AForm.Monitor.Top + AForm.Monitor.Height);
    end;

    //      If the form is off the right or bottom of the screen then we need to pull it back
    if ARectAfter.Right > AWorkArea.Right then
        X := AWorkArea.Right - (ARectAfter.Right - ARectAfter.Left);
    //rightEdge - widthOfForm

    if ARectAfter.Bottom > AWorkArea.Bottom then
        Y := AWorkArea.Bottom - (ARectAfter.Bottom - ARectAfter.Top);
    //bottomEdge - heightOfForm

    X := Max(X, AWorkArea.Left); //don't go beyond left edge
    Y := Max(Y, AWorkArea.Top); //don't go above top edge
  end else begin
    X := Max(X, 0); //don't go beyond left edge
    Y := Max(Y, 0); //don't go above top edge
  end;

  AForm.SetBounds(X, Y, ARectAfter.Right - ARectAfter.Left, //Width
    ARectAfter.Bottom - ARectAfter.Top); //Height
end;

class procedure TFormFontScaler.StandardizeFontControlFontCore
  (AControlFont: TFont; AForceClearType: Boolean; AFontName: string;
  AFontSize: Integer; AForceFontIfName: string; AForceFontIfSize: Integer);
const
  CLEARTYPE_QUALITY = 5;
var
  ACanChangeName: Boolean;
  ACanChangeSize: Boolean;
  ALogFont: TLogFont;
begin
  if not Assigned(AControlFont) then Exit;

  //Standardize the font if it's currently
  //  "MS Shell Dlg 2" (meaning whoever it was opted into the 'change me' system
  //  "MS Sans Serif" (the Delphi default)
  //  "Tahoma" (when they wanted to match the OS, but "MS Shell Dlg 2" should have been used)
  //  "MS Shell Dlg" (the 9x name)
  ACanChangeName := (AFontName <> '') and (AControlFont.Name <> AFontName) and
    (((AForceFontIfName <> '') and (AControlFont.Name = AForceFontIfName)) or
    ((AForceFontIfName = '') and ((AControlFont.Name = 'MS Sans Serif') or
    (AControlFont.Name = 'Tahoma') or (AControlFont.Name = 'MS Shell Dlg 2') or
    (AControlFont.Name = 'MS Shell Dlg'))));

  ACanChangeSize := (
    //there is a font size
    (AFontSize <> 0) and (
    //the font is at it's default size, or we're specifying what it's default size is
    (AControlFont.Size = 8) or ((AForceFontIfSize <> 0) and
    (AControlFont.Size = AForceFontIfSize))) and
    //the font size (or height) is not equal
    (
    //negative for height (px)
    ((AFontSize < 0) and (AControlFont.Height <> AFontSize)) or
    //positive for size (pt)
    ((AFontSize > 0) and (AControlFont.Size <> AFontSize))) and
    //no point in using default font's size if they're not using the face
    ((AControlFont.Name = AFontName) or ACanChangeName));

  if ACanChangeName or ACanChangeSize or AForceClearType then
  begin
    if GetObject(AControlFont.Handle, SizeOf(TLogFont), @ALogFont) <> 0 then
    begin
      //Change the font attributes and put it back
      if ACanChangeName then
          StrPLCopy(Addr(ALogFont.lfFaceName[0]), AFontName, LF_FACESIZE);
      if ACanChangeSize then ALogFont.lfHeight := AFontSize;

      if AForceClearType then ALogFont.lfQuality := CLEARTYPE_QUALITY;
      AControlFont.Handle := CreateFontIndirect(ALogFont);
    end else begin
      if ACanChangeName then AControlFont.Name := AFontName;
      if ACanChangeSize then
      begin
        if AFontSize > 0 then AControlFont.Size := AFontSize
        else if AFontSize < 0 then AControlFont.Height := AFontSize;
      end;
    end;
  end;
end;

class function TFormFontScaler.GetControlFont(AControl: TControl): TFont;
begin
  Result := nil;
  if IsPublishedProp(AControl, 'ParentFont') and
    (GetOrdProp(AControl, 'ParentFont') = Ord(False)) and
    IsPublishedProp(AControl, 'Font') then
  begin
    Result := TFont(GetObjectProp(AControl, 'Font', TFont));
  end;
end;

class procedure TFormFontScaler.StandardizeFontControlCore(AControl: TControl;
  AForceClearType: Boolean; AFontName: string; AFontSize: Integer;
  AForceFontIfName: string; AForceFontIfSize: Integer);
const
  CLEARTYPE_QUALITY = 5;
var
  I: Integer;
  RunComponent: TComponent;
  AControlFont: TFont;
begin
  if not Assigned(AControl) then Exit;

  if (AControl is TStatusBar) then
  begin
    TStatusBar(AControl).UseSystemFont := False; //force...
    TStatusBar(AControl).UseSystemFont := True; //...it
  end else begin
    AControlFont := GetControlFont(AControl);

    if not Assigned(AControlFont) then Exit;

    StandardizeFontControlFontCore(AControlFont, AForceClearType, AFontName,
      AFontSize, AForceFontIfName, AForceFontIfSize);
  end;

  {   If a panel has a toolbar on it, the toolbar won't paint properly. So this idea won't work.
    if (not Toolkit.IsRemoteSession) and (AControl is TWinControl) and (not (AControl is TToolBar)) then
   TWinControl(AControl).DoubleBuffered := True;
  }

  //Iterate children
  for I := 0 to AControl.ComponentCount - 1 do
  begin
    RunComponent := AControl.Components[I];
    if RunComponent is TControl then
        StandardizeFontControlCore(TControl(RunComponent), AForceClearType,
        AFontName, AFontSize, AForceFontIfName, AForceFontIfSize);
  end;
end;

class function TFormFontScaler.StandardizeFormFont(AForm: TForm;
  AFontName: string; AFontHeight: Integer): Real;
// Standardizes the current font on the entire form. Rescales the form to fit
// the replaced fonts where required
var
  AOldHeight: Integer;
begin
  Assert(Assigned(AForm));

  if (AForm.Scaled) then
  begin
    OutputDebugString(PChar('WARNING: StandardizeFormFont: Form "' + AForm.Name
      + '" is set to Scaled. Proper form scaling requires VCL scaling to be disabled, unless you implement scaling by overriding the protected ChangeScale() method of the form.')
      );
  end;

  if (AForm.AutoScroll) then
  begin
    if AForm.WindowState = wsNormal then
    begin
      OutputDebugString(PChar('WARNING: StandardizeFormFont: Form "' +
        AForm.Name +
        '" is set to AutoScroll. Form designed size will be suseptable to changes in Windows form caption height (e.g. 2000 vs XP).')
        );
      // if IsDebuggerPresent then Winapi.Windows.DebugBreak;
      //Some forms would like it (to fix maximizing problem)
    end;
  end;

  if (not AForm.ShowHint) then
  begin
    AForm.ShowHint := True;
    OutputDebugString
      (PChar('INFORMATION: StandardizeFormFont: Turning on form "' + AForm.Name
      + '" hints. (ShowHint := True)'));
    // if IsDebuggerPresent then Winapi.Windows.DebugBreak;
    //Some forms would like it (to fix maximizing problem)
  end;

  AOldHeight := AForm.Font.Height;

  //Scale the form to the new font size
  // if (AFontHeight <> AOldHeight) then
  // for compatibility, it's safer to trigger a call to ChangeScale, since a
  // lot of people will be assuming it is always called
  begin
    ScaleForm(AForm, AFontHeight, AOldHeight);
  end;

  //Now change all controls to actually use the new font
  StandardizeFontControlCore(AForm, True, AFontName, AFontHeight,
    AForm.Font.Name, AForm.Font.Size);

  //Return the scaling ratio, so any hard-coded values can be multiplied
  Result := AFontHeight / AOldHeight;
end;

class procedure TFormFontScaler.Scale(const AForm: TForm;
  ANewFontHeight: Integer);
var
  AOldFontName: string;
  AOldFontHeight: Integer;
begin
  AForm.LockDrawing;
  try
    GetUserFontPreference(AOldFontName, AOldFontHeight);
    StandardizeFormFont(AForm, AOldFontName, AOldFontHeight);
    ScaleForm(AForm, Abs(ANewFontHeight), Abs(AOldFontHeight));
  finally
    AForm.UnlockDrawing;
  end;
end;

end.
