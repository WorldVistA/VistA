unit ORExtensions;

interface

uses
  ORCtrls,
  System.Classes,
  Vcl.Clipbrd,
  Vcl.ComCtrls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows,
  TLHelp32,
  System.SysUtils,
  Vcl.Dialogs,
  System.UITypes;

type
  TEdit = class(Vcl.StdCtrls.TEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TMemo = class(Vcl.StdCtrls.TMemo)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TRichEdit = class(Vcl.ComCtrls.TRichEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMKeyDown(var Message: TMessage); message WM_KEYDOWN;
  end;

  TCaptionEdit = class(ORCtrls.TCaptionEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TCaptionMemo = class(ORCtrls.TCaptionMemo)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

procedure ScrubTheClipboard;

implementation

procedure ScrubTheClipboard;
begin
 // NB: OSEHRA/SMH - Plan 6 - This method is no longer needed.
 // It converted everything to ASCII using a poor man's manual converter.
end;

{ TEdit }

procedure TEdit.WMPaste(var Message: TMessage);
begin
  ScrubTheClipboard;
  inherited;
end;

{ TMemo }

procedure TMemo.WMPaste(var Message: TMessage);
begin
  ScrubTheClipboard;
  inherited;
end;

{ TRichEdit }

procedure TRichEdit.WMKeyDown(var Message: TMessage);
var
  aShiftState: TShiftState;
begin
  aShiftState := KeyDataToShiftState(message.WParam);
  if (ssCtrl in aShiftState) and (message.WParam = Ord('V')) then
    ScrubTheClipboard;
  if (ssShift in aShiftState) and (message.WParam = VK_INSERT) then
    ScrubTheClipboard;
  inherited;
end;

procedure TRichEdit.WMPaste(var Message: TMessage);
begin
  ScrubTheClipboard;
  inherited;
end;

{ TCaptionEdit }

procedure TCaptionEdit.WMPaste(var Message: TMessage);
begin
  ScrubTheClipboard;
  inherited;
end;

{ TCaptionMemo }

procedure TCaptionMemo.WMPaste(var Message: TMessage);
begin
  ScrubTheClipboard;
  inherited;
end;

end.
