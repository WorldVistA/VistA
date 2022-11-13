unit uPrinting;

interface

uses
  SysUtils, Vcl.Printers, Vcl.Dialogs, WinApi.windows;

type
  TPrinterRetryProc1 = procedure of object;
  TPrinterRetryProc2 = procedure(X, Y: Integer; const Text: String) of object;

procedure TryPrintProc(proc: TPrinterRetryProc1); overload;
procedure TryPrintProc(proc: TPrinterRetryProc2; X, Y: Integer;
  const Text: String); overload;

// do NOT move TPrintDialog to ORExtensions!!!
type
  TPrintDialog = class(Vcl.Dialogs.TPrintDialog)
  public
    function Execute(ParentWnd: HWND): Boolean; override;
  end;

implementation

uses
  ORFn;

Procedure ResetPrinting;
begin
  try
    Vcl.Printers.SetPrinter(nil).Free;
  except
  end;
end;

function AskRetryPrinting(E: EPrinter): Boolean;
begin
  Result := InfoBox('A printing error has occured:' + CRLF + CRLF + '  ' +
    E.Message, 'Printer Error', MB_RETRYCANCEL or MB_ICONERROR) = IDRETRY;
  if not Result then
  begin
    ResetPrinting;
    raise EPrinter.Create(E.Message); // Don't reraise the passed in error
  end;
end;

procedure TryPrintProc(proc: TPrinterRetryProc1); overload;
var
  Done: Boolean;

begin
  repeat
    Done := True;
    try
      proc;
    except
      on E: EPrinter do
        if AskRetryPrinting(E) then
          Done := False;
      else
        raise;
    end;
  until Done;
end;

procedure TryPrintProc(proc: TPrinterRetryProc2; X, Y: Integer;
  const Text: String); overload;
var
  Done: Boolean;

begin
  repeat
    Done := True;
    try
      proc(X, Y, Text);
    except
      on E: EPrinter do
        if AskRetryPrinting(E) then
          Done := False;
      else
        raise;
    end;
  until Done;
end;

{ TPrintDialog }

function TPrintDialog.Execute(ParentWnd: HWND): Boolean;
begin
//  ResetPrinting;
  try
    Result := inherited Execute(ParentWnd);
  except
    on E:Exception do
    begin
      ResetPrinting;
      ShowMessage(E.Message);
      Result := False;
    end;
  end;
end;

end.
