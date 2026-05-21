unit ORCtrls.MessageReceiver;

////////////////////////////////////////////////////////////////////////////////
/// TMessageReceiver is a class that can be created with a Windows message
/// constant and a callback event. When a message of that type is posted to
/// the handle of TMessageReceiver then the callback event is called. This
/// provides a lean implementation of a way to respond to Windows Messages in
/// objects that don't inherit from TWinControl, or where the Handle of the
/// object cannot be relied upon (see TORRichEdit)
////////////////////////////////////////////////////////////////////////////////

interface

uses
  Winapi.Windows,
  Winapi.Messages;

type
  TMessageNotifyEvent = procedure(Sender: TObject; AMessage: TMessage)
    of object;

  TMessageReceiver = class(TObject)
  strict private
    FHandle: HWND;
    FMsg: Cardinal;
    FMessageNotifyEvent: TMessageNotifyEvent;
    procedure WndProc(var AMessage: TMessage);
    function GetHandle: HWND;
  public
    constructor Create(AMsg: Cardinal;
      AMessageNotifyEvent: TMessageNotifyEvent = nil);
    destructor Destroy; override;
    property MessageNotifyEvent: TMessageNotifyEvent read FMessageNotifyEvent
      write FMessageNotifyEvent;
    property Handle: HWND read GetHandle;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  Vcl.Forms;

constructor TMessageReceiver.Create(AMsg: Cardinal;
  AMessageNotifyEvent: TMessageNotifyEvent = nil);
// AMsg: The Windows Message type (usually a constant in the WM_USER range) to
// listen for.
// AMessageNotifyEvent: The event handler to call when AMessage is received.
begin
  if AMsg <= 0 then raise Exception.Create('AMsg not Assigned');
  inherited Create;
  FMsg := AMsg;
  FMessageNotifyEvent := AMessageNotifyEvent;
end;

destructor TMessageReceiver.Destroy;
begin
  if FHandle <> 0 then
  begin
    DeallocateHWnd(FHandle);
    FHandle := 0;
  end;
  inherited Destroy;
end;

function TMessageReceiver.GetHandle: HWND;
begin
  if FHandle = 0 then
    FHandle := AllocateHWnd(WndProc);
  Result := FHandle;
end;

procedure TMessageReceiver.WndProc(var AMessage: TMessage);
// This code was copied and adapted from TTimer
// Note that FMsg is a Cardinal representing a Windows message type, and
// AMessage is a Winapi.Messages.TMessage. It gets confusing.
begin
  if AMessage.Msg = FMsg then
    try
      if Assigned(FMessageNotifyEvent) then
        FMessageNotifyEvent(Self, AMessage);
    except
      Application.HandleException(Self);
    end
  else
    AMessage.Result := DefWindowProc(Handle, AMessage.Msg, AMessage.WParam,
      AMessage.lParam);
end;

end.
