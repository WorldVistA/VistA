unit uInfoBoxWithBtnControls;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  VA508AccessibilityManager, ORFn, VAUtils;

function DefMessageDlg(const Msg: string; DlgType: TMsgDlgType; list: TStringList;
        const aCaption: string = ''; NoDefault: Boolean = false): Integer;

implementation


function DefMessageDlg(const Msg: string; DlgType: TMsgDlgType; list: TStringList;
          const aCaption: string = ''; NoDefault: Boolean = false): Integer;


var
  Dlg: TForm;
  i, j, cnt, btnHalf, btnLast, btnPos, btnSpace, btnNum, formHalf,value,
  lastBtnLeft, OldSize, gap, tgap: integer;
  btn: TButton;
//  zPnl: TPanel;
  str: string;
//  bforeground, bfocused, bactive,
//  bres: Boolean;
//  BytesAllocated: longInt;
  Buttons: TMsgDlgButtons;

begin
//  Dlg := nil; // rpk 4/23/2009
//  zPnl := nil; // rpk 4/23/2009

//  BytesAllocated := GetHeapStatus.TotalAllocated;

  //map captions to the following button
  //    (mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore,
  //    mbAll, mbNoToAll, mbYesToAll, mbHelp, mbClose);
  Result := -1;
  lastBtnLeft := 0;
  cnt := list.Count;
  case cnt of
        4:
        begin
          str := list.Strings[0];
          SetPiece(str, U, 3, 'Yes');
          list.Strings[0] := str;
          str := list.Strings[1];
          SetPiece(str, U, 3, 'No');
          list.Strings[1] := str;
          str := list.Strings[2];
          SetPiece(str, U, 3, 'Cancel');
          list.Strings[2] := str;
          str := list.Strings[3];
          SetPiece(str, U, 3, 'Abort');
          list.Strings[3] := str;
          Buttons := [mbYes, mbNo, mbCancel, mbAbort];
        end;
        3:
        begin
          str := list.Strings[0];
          SetPiece(str, U, 3, 'Yes');
          list.Strings[0] := str;
          str := list.Strings[1];
          SetPiece(str, U, 3, 'No');
          list.Strings[1] := str;
          str := list.Strings[2];
          SetPiece(str, U, 3, 'Cancel');
          list.Strings[2] := str;
          Buttons := [mbYes, mbNo, mbCancel];
        end;
        2:
        begin
          str := list.Strings[0];
          SetPiece(str, U, 3, 'Yes');
          list.Strings[0] := str;
          str := list.Strings[1];
          SetPiece(str, U, 3, 'No');
          list.Strings[1] := str;
          Buttons := [mbYes, mbNo];
        end;
        1:
        begin
          str := list.Strings[0];
          SetPiece(str, U, 3, 'Yes');
          list.Strings[0] := str;
          Buttons := [mbYes];
        end;
  end;
  OldSize := Screen.MessageFont.Size;
  try
    if Assigned(Application.MainForm) then
      Screen.MessageFont.Size := Application.MainForm.Font.Size;
    Dlg := CreateMessageDialog(Msg, DlgType, buttons);
    if Dlg <> nil then begin // rpk 5/14/2013
      try
        btnPos := 0;
        btnSpace := 0;
        btnNum := 0;
        btnLast := 0;
        gap := 8;
        //determine the existing space between buttons
        if cnt>0 then
          begin
          for i := 0 to Dlg.ComponentCount - 1 do
            if Dlg.Components[i] is TButton then begin
              btn := TButton(Dlg.Components[i]);
              tgap := btn.Height - TextHeightByFont(Screen.MessageFont.Handle, btn.Caption) + 4;
              if tgap > gap then
                gap := tgap;
              if cnt < 2 then
                break;
              if btnNum = 0 then btnlast := btn.Left + btn.Width
              else btnSpace := (btn.Left + btn.Width) - btnlast;
              inc(btnNum);
              if btnNum = 2 then break;
            end;
          end;
        if btnSpace = 0 then btnSpace := 10;

        for i := 0 to Dlg.ComponentCount - 1 do
          if Dlg.Components[i] is TButton then begin
            btn := TButton(Dlg.Components[i]);
            for j := 0 to list.count-1 do
              begin
                str := list.Strings[j];
                if (Piece(str, U, 3) = btn.Name) then
                  begin
                    btn.Caption := Piece(str, u, 1);
                    SetPiece(str, U, 4, IntToStr(btn.modalResult));
                    list.Strings[j] := str;
                    if Piece(str, U, 2) = 'true' then
                      begin
                        btn.default := true;
                        btn.tabstop := true;
                      end
                    else
                      begin
                        btn.default := false;
                        btn.tabstop := ScreenReaderActive;
                      end;
                    break;
                  end;
              end;
            btn.Width :=  TextWidthByFont(Screen.MessageFont.Handle, btn.caption) + gap;
            if cnt = 1 then
              begin
                btnHalf := btn.Width div 2;
                formHalf := dlg.Width div 2;
                btn.Left := formHalf - btnHalf;
                lastBtnLeft := btn.Left + btn.Width;
              end
            else
              begin
                btn.Left := btnPos + btnSpace;
                //if btn.Left < btnPos then btn.Left := btnPos + btnSpace;
                btnPos := btn.Left + btn.Width;
                lastBtnLeft := btnPos;
              end;
            If NoDefault then
            begin
              btn.default := false;
              btn.tabstop := ScreenReaderActive;
              dlg.ActiveControl := nil;
              dlg.DefocusControl(btn, False);
            end;
        end;
        if dlg.Width < (btnPos + btnSpace) then dlg.Width := btnPos + btnSpace;

      finally
      end;

      try // rpk 2/23/2012
      //This will cover that hopefully rare scenario that the message box receives so
      //much text that it tries to expand right off the screen.
        with Dlg do
          if Height > Screen.WorkAreaHeight then begin
            AutoScroll := True;
            Top := Screen.WorkAreaTop;
            Height := Screen.WorkAreaHeight;
            if lastBtnLeft > 0 then Width := lastBtnLeft + btnSpace
            else Width := Screen.WorkAreaWidth;
  //          Width := TLabel(FindComponent('Message')).Width +
  //            TImage(FindComponent('Image')).Width + 60;
          end;

        // center on main form
        Dlg.Position := poMainFormCenter; // rpk 10/25/2012

  // NOTE: fsStayOnTop: Don't use
  // This form remains on top of the DESKTOP and of other forms in the project,
  // except any others that also have FormStyle set to fsStayOnTop.
  // If one fsStayOnTop form launches another, neither form will consistently remain on top.

  //      Dlg.FormStyle := fsStayOnTop; // rpk 10/25/2013

  //      if HelpCtx > 0 then begin // rpk 5/14/2013
  //        Dlg.HelpType := htContext; // rpk 5/14/2013
  //        Dlg.HelpContext := HelpCtx; // rpk 5/9/2013
  //      end;

        if aCaption = '' then
          case DlgType of
            mtWarning:
              Dlg.Caption := 'Warning';
            mtError:
              Dlg.Caption := 'Error';
            mtInformation:
              Dlg.Caption := 'Information';
            mtConfirmation:
              Dlg.Caption := 'Confirmation';
          end
        else
          Dlg.Caption := aCaption;

  //      BytesAllocated := GetHeapStatus.TotalAllocated;
         //not sure if this is needed
  //      zPnl := TPanel.Create(Application);
  //      if zPnl <> nil then begin // rpk 5/14/2013
  //        try // rpk 2/23/2012
  //
  //          BytesAllocated := GetHeapStatus.TotalAllocated;
  //
  //          with zPnl do begin
  //            Caption := msg;
  //            Left := 0; // rpk 5/14/2013
  //            Parent := Dlg;
  //            Height := 1;
  //            Width := 1;
  //          end;

            dlg.BringToFront; // use BringToFront to move dlg to top of form stack;  rpk 10/25/2013


            value := Dlg.ShowModal;
            result := value;
            for j := 0 to list.count-1 do
              begin
                str := list.Strings[j];
                if (Piece(str, U, 4) = IntToStr(value)) then
                  begin
                    Result := j;
                    break;
                  end;
              end;
  //        finally // rpk 3/9/2009
  //          zPnl.Free; // rpk 3/9/2009
            ;
  //        end; // rpk 3/9/2009
  //      end; // if zPnl <> nil
      finally // rpk 3/9/2009
        Dlg.Release; // rpk 6/18/2013
    //    bres := ShowApplicationAndFocusOK(Application);
      end; // rpk 3/9/2009
    end; // if Dlg <> nil
  finally
    Screen.MessageFont.Size := OldSize;
  end;
//  BytesAllocated := GetHeapStatus.TotalAllocated;

end; // DefMessageDlg
end.
