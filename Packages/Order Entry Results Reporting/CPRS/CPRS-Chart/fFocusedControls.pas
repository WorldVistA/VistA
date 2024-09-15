unit fFocusedControls;
{==============================================================================}
{  Focused Control Dialog                                                      }
{------------------------------------------------------------------------------}
{  This dialog handles displaying focus changes during the normal operation    }
{  of the application.  It uses the internal Delphi message CMFocusChanged     }
{  to populate the list.                                                       }
{                                                                              }
{  ShowFocusedControlDialog is a global variable indicating this dialog        }
{  should be shown, and the globals DestinationControl and Previous Control    }
{  are used to track and report the position of the current focus.             }
{                                                                              }
{  The dialog is a singleton, meaning only one exists at a given time, and it  }
{  should only be accessed through the GetInstance function.                   }
{==============================================================================}
                                                                               
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, fBase508Form, VA508AccessibilityManager;

type
  // Indicates which tab key is used, if any
  TTabKeyUsed = (tkuTab, tkuShiftTab, tkuNone);
  
  // Focus Dialog  
  TdlgFocusedControls = class(TfrmBase508Form)
    sbar: TStatusBar;
    lv: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Count: integer; // used for line numbering
  public
    class function GetInstance: TdlgFocusedControls; // Singleton access.  Also shows dialog if it isn't already visible.
    procedure AddFocusChange(const ASource, ADestination, ADirection: string);  // Called to add an entry to the dialog
  end;

var
  ShowFocusedControlDialog: boolean; // Toggle used to determine if the dialog should show.
  DestinationControl: TWinControl;   // Global used to change the focus inside the parent form, in conjunction with CMFocusChange window message
  PreviousControl: TWinControl;      // Global used for focus changes
   
const
  TabKeyUsedStr: array[TTabKeyUsed] of string = ('Tab', 'Shift Tab', 'None'); // used to display tab states in diagnostics


implementation

{$R *.dfm}

uses fFrame;  

var
  dlgFocusedControls: TdlgFocusedControls; // put down here because the dialog is a singleton.


{ TdlgFocusedControls }

{-----------------------------------------------------------------------------------}
{  AddFocusChange - called to add a line to the list                                }
{     ASource:      Name of the source control of the focus change (From)           }
{     ADestination: Name of the destination control of the focus change (To)        }
{     ADirection:   Indicates which direction the focus is coming from (Tab State)  }
{-----------------------------------------------------------------------------------}
procedure TdlgFocusedControls.AddFocusChange(const ASource, ADestination, ADirection: string);
var
  li: TListItem;
begin
  if not Visible then Show;       // make sure the form is showing, as it may have been closed previously.
  inc(Count);
  li := lv.Items.Add;
  li.Caption := IntToStr(Count);  // line number
  li.SubItems.Add(ASource);       // From
  li.SubItems.Add(ADestination);  // To
  li.SubItems.Add(ADirection);    // Which way
  Repaint;
end;

{----------------------------------}
{  FormClose - closing the dialog  }
{----------------------------------}
procedure TdlgFocusedControls.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  // make sure the menu item and the toggle are set back to false
  ShowFocusedControlDialog := False;
  frmFrame.mnuFocusChanges.Checked := False;
end;                  

{------------------------------------}
{  FormCreate - starting the dialog  }
{------------------------------------}
procedure TdlgFocusedControls.FormCreate(Sender: TObject);       
begin
  Count := 0; // line number
  lv.Clear;   // make sure test form data is cleared
end;

{----------------------------------------------------------------------}
{  GetInstance - Handles calling the singleton instance of the dialog  }
{                In other words, making sure there is only one.        }
{----------------------------------------------------------------------}
class function TdlgFocusedControls.GetInstance: TdlgFocusedControls;
begin
  if not assigned(dlgFocusedControls) then begin // Create if it doesn't exist
    dlgFocusedControls := TdlgFocusedControls.Create(nil);
  end;
  Result := dlgFocusedControls;
end;

initialization
  ShowFocusedControlDialog := False; // default to False
  
finalization
  if assigned(dlgFocusedControls) then // clean up singleton, not destroyed by application automatically
    dlgFocusedControls.Free;
end.
