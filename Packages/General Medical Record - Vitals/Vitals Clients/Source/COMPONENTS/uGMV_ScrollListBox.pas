unit uGMV_ScrollListBox;

interface
uses
  StdCtrls
  , Windows
  , Messages;

type
  // List Box without vertical scrollbar
  TNoVScrolllistbox = class( Tlistbox )
  private
    procedure WMNCCalcSize( Var msg: TMessage );
      message WM_NCCALCSIZE;
    procedure WMVScroll   (var Message: TWMVScroll);
      message WM_VSCROLL;
  public
    SearchTarget:String;
  end;


implementation

////////////////////////////////////////////////////////////////////////////////
procedure TNoVScrolllistbox.WMNCCalcSize(var msg: TMessage);
//var
//  style: Integer;
begin
(*  uncomment to hide scroll bar
  style := getWindowLong( handle, GWL_STYLE );
  If (style and WS_VSCROLL) <> 0 Then
    SetWindowLong( handle, GWL_STYLE, style and not WS_VSCROLL );
*)
  inherited;
end;

(*
Unit
QForms

type TScrollCode = (scLineUp, scLineDown, scPageUp, scPageDown, scPosition,
  scTrack, scTop, scBottom, scEndScroll);

scLineUp	User clicked the top or left scroll arrow or pressed the Up or Left arrow key.
scLineDown	User clicked the bottom or right scroll arrow or pressed the Down or Right arrow key.
scPageUp	User clicked the area to the left of the thumb tab or pressed the PgUp key.
scPageDown	User clicked the area to the right of the thumb tab or pressed the PgDn key.
scPosition	User positioned the thumb tab and released it.
scTrack	        User is moving the thumb tab.
scTop	        User moved the thumb tab to the top or far left on the scroll bar.

scBottom	User moved the thumb tab to the bottom or far right on the scroll bar.
scEndScroll	User finished moving the thumb tab on the scroll bar.
*)
procedure TNoVScrolllistbox.WMVScroll(var Message: TWMVScroll);
var
  i: Integer;
begin
  inherited;
  case Message.ScrollCode of
    0:SendMessage(Handle, WM_KEYDOWN, VK_Up, 1);
    1:SendMessage(Handle, WM_KEYDOWN, VK_Down, 1);
    2:SendMessage(Handle, WM_KEYDOWN, SB_PAGEUP, 1);
    3:SendMessage(Handle, WM_KEYDOWN, SB_PAGEDOWN, 1);
    4:begin
        i := Height div ItemHeight;
        if (TopIndex + i >= Items.Count - 1 ) then
          SendMessage(Handle, WM_KEYDOWN, SB_BOTTOM, 1)
        else if (TopIndex = 0) then
        begin
          SearchTarget := Items[0];
          SendMessage(Handle, WM_KEYDOWN, SB_TOP, 1);
        end;
      end;
    SB_TOP:SendMessage(Handle, WM_KEYDOWN, SB_TOP, 1);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
{
Want to scroll a windows control with Delphi code? Like a listbox, memo, etc, here's how to do it:
To scroll a windows control up use:
        SendMessage(Memo1.Handle, WM_KEYDOWN, VK_UP, 1);
To scroll a windows control down use:
        SendMessage(Memo1.Handle, WM_KEYDOWN, VK_DOWN, 1);
Simply replace the "Memo1" part with the name of the control you want to scroll.
}

(*
procedure WMVScroll      (var Message: TWMVScroll);       message WM_VSCROLL;
procedure TfrmGMV_PatientSelector.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
//  if Message.ScrollCode = SB_ENDSCROLL then uItemTip.Hide;
  case Message.ScrollCode of
    sB_LineUp: ScrollUp;
    sB_LineDown: ScrollDown;
  end;
end;
*)


(*
From:		Peter Below (TeamB) - view profile
Date:		Wed, Jul 24 2002 8:54 am
Email: 		"Peter Below (TeamB)" <100113.1...@compuXXserve.com>
Groups: 		borland.public.delphi.objectpascal
Not yet rated
Rating:
show options
Reply | Reply to Author | Forward | Print | Individual Message | Show original | Report Abuse | Find messages by this author

In article <3d3e13a0_1@dnews>, Gary H wrote:
> Does anyone know how to turn off the scroll bar in a
> TlistBox? I've looked at the component refrence book and can't seem to find
> any property that I can set to hide it. I would like to do a Ownerdraw list
> box and then control scrolling through code but I need to hide the scroll
> bar first.
> any tips would be appreciated.

Derive a new class from Tlistbox, like this:

type
  TNoVScrolllistbox = Class( Tlistbox )
  private
    Procedure WMNCCalcSize( Var msg: TMessage );
      message WM_NCCALCSIZE;
  end;

procedure TNoVScrolllistbox.WMNCCalcSize(var msg: TMessage);
var
  style: Integer;
begin
  style := getWindowLong( handle, GWL_STYLE );
  If (style and WS_VSCROLL) <> 0 Then
    SetWindowLong( handle, GWL_STYLE, style and not WS_VSCROLL );
  inherited;
end;

--
*)
end.
