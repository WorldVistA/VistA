{*******************************************************}
{       VA FileMan Delphi Components                    }
{                                                       }
{       San Francisco CIOFO                             }
{          (originally developed at Albany IRMFO)       }
{                                                       }
{       Revision Date: 02/24/98                         }
{                                                       }
{       Distribution Date: 02/28/98                     }
{                                                       }
{       Version: 1.0                                    }
{                                                       }
{*******************************************************}

unit Fmlookup;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Fmcmpnts, Fmcntrls, StdCtrls, ExtCtrls, Buttons, mfunstr,
  Diaccess, Dityplib;

type
  TFMLookUp = class(TComponent)
    private
    protected
      FFMLister: TFMLister;
      FRecordNumber:   String;
      FRecordResult : TFMRecordObj;
      FTitle :    String;
      FHelpContext : LongInt;
      FRecordIndex:    Integer;
      FAllowNew: Boolean;
      FFMFinderIndex, FFMFinderNumber: string;
      procedure SetAllowNew(value: Boolean); virtual;
      procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    public
      property RecordNumber: string read FRecordNumber;
      property RecordIndex: integer read FRecordIndex; //d0
      property RecordResult : TFMRecordObj read FRecordResult;
      function Execute(var new: boolean): Boolean; virtual;
      procedure TextLookUp(txtField: TFMEdit; LookUpFile: String); virtual; //d0
    published
      property AllowNew: Boolean read FAllowNew write SetAllowNew default false;
      property FMLister: TFMLister read FFMLister write FFMLister;
      property Title: String read FTitle write FTitle;           //d1
      property HelpContext : LongInt read FHelpContext write FHelpContext;
      property FMFinderNumber: string read FFMFinderNumber write FFMFinderNumber;
      property FMFinderIndex: string read FFMFinderIndex write FFMFinderIndex;
    end;

  TfrmLookUp = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    lstPick: TListBox;
    MoreBtn: TBitBtn;
    cmdFind: TBitBtn;
    Listr: TFMLister;
    cmdNew: TBitBtn;
    chkNew: TCheckBox;
    procedure MoreBtnClick(Sender: TObject); virtual;
    procedure cmdFindClick(Sender: TObject); virtual;
    procedure FormShow(Sender: TObject); virtual;
    procedure lstPickDblClick(Sender: TObject); virtual;
    procedure cmdNewClick(Sender: TObject); virtual;
  private
  protected
    FFNumber, FFIndex: string;
    procedure Reset; virtual;
  end;

var
  LookUpBox: TfrmLookUp;

procedure Register;

implementation

{$R *.DFM}

procedure TFMLookUp.SetAllowNew(Value: Boolean);
begin
  if FAllowNew <> Value then FAllowNew := Value;
end;

procedure TFMLookUp.Notification(AComponent :TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFMLister) then FFMLister := nil;
end;

 {Execute the lookup.  The function expects a boolean value to be passed in,
  This value will be returned as true if the New button is clicked.  If the
  New button is clicked, then the var New is set to true and the function
  result is set to true.  The execute function will return a true if the OK
  button (or New) is clicked, or false if the Cancel button is clicked.

  If either a list item is double clicked,or a list item is highlighted and
  then the Ok button is clicked, the index number of the list item and
  it's FileMan IEN will be returned in the RecordNumber and RecordIndex
  properties.

  If only One item is found for the list, that item is returned directly
  and the lookup dialog box will not be shown. }
function TFMLookUp.Execute(var New: boolean): Boolean;
var
  rtn, ndx, i: integer;
  ffmtext: string;
  z: TObject;
  r: TFMRecordObj;
begin
  result := False;
  try
    LookUpBox := TfrmLookUp.Create(application);
    LookUpBox.Listr.CopyTo(FFMLister);
    LookUpBox.Listr.GetList(LookUpBox.lstPick.Items);
    ffmtext := '';
    if LookUpBox.Listr.ErrorList.Count <> 0 then begin
       LookUpBox.Listr.DisplayErrors;
       Result := False;
       New := False;
       LookUpBox.Release;
       Exit;
       end;
    New := false;
    if (LookUpBox.Listr.Results.count > 0) or FAllowNew then begin
      with LookUpBox do begin
        if FTitle <> '' then Caption := FTitle
        else Caption := 'Look Up Utility';
        if FHelpContext > 0 then begin
          HelpContext := FHelpContext;
          HelpBtn.HelpContext := FHelpContext;
          end
        else HelpBtn.Visible := False;
        cmdNew.Visible := FAllowNew;
        chkNew.Checked := false;
        FFIndex := FFMFinderIndex;
        FFNumber := FFMFinderNumber;
        rtn := ShowModal;
        if chkNew.checked and (rtn = idok) then begin
          new := true;
          FRecordNumber := '0';
          FRecordIndex := -1;
          FRecordResult := nil;
          Result := true;
          end
        else
          if (rtn = idOk) and ( lstPick.ItemIndex >= 0) then begin
            ndx := lstPick.ItemIndex;
            FRecordIndex := ndx;
            z := lstPick.Items.Objects[ndx];
            if (z <> nil) and (z is TFMRecordObj) then FRecordResult := TFMRecordObj(z);
            FRecordNumber := FRecordResult.IEN;
            Result := True;
            end
          else begin
            FRecordNumber := '-1';
            FRecordIndex := -1;
            FRecordResult := nil;
            Result := False;
            end;
        end;
      end
    else exit;
    for i := 0 to LookupBox.lstPick.Items.Count -1 do begin
      z := LookupBox.lstPick.Items.Objects[i];
      if (z <> nil) and (z is TFMRecordObj) then begin
        r := TFMRecordObj(z);
        FFMLister.Results.AddObject(r.IEN, r);
        end
      end;
    LookUpBox.Release;
  except
    on E: Exception do
      MessageDlg('An ' + E.ClassName + ' occured in the Lookup Component',
           mtWarning, [mbOk], 0);
  end;
end;

{ *** Lookup form *** }

{when the more button is clicked, the lister will retrieve more items
and add them to the  pick list; the last item retrieved is highlighted.}
procedure TfrmLookUp.MoreBtnClick(Sender: TObject);
begin
  MoreBtn.Enabled := false;
  Listr.GetMore(lstPick.Items);
  if Listr.ErrorList.Count <> 0 then begin
    Listr.DisplayErrors;
    Exit;
    end;
  lstPick.ItemIndex :=  lstPick.Items.Count - 1;
  MoreBtn.Enabled := Listr.More;
end;

{Double click list item to select}
procedure TfrmLookUp.lstPickDblClick(Sender: TObject);
begin
  OkBtn.Click
end;

{Create TFMFinder for partial matching.}
procedure TfrmLookUp.cmdFindClick(Sender: TObject);
var
  s: string;
  TempFinder : TFMFinder;
begin
  s := '';
  if InputQuery('Find...', 'Enter search string:', s) then begin
    if MoreBtn.Enabled then MoreBtn.Enabled := false;
    lstPick.Items.Clear;
    TempFinder := TFMFinder.Create(application);
    TempFinder.DisplayFields.Assign(Listr.DisplayFields);
    TempFinder.FieldNumbers.Assign(Listr.FieldNumbers);
    TempFinder.FileNumber := Listr.FileNumber;
    if FFIndex <> '' then TempFinder.FMIndex := FFIndex
    else TempFinder.FMIndex := Listr.FMIndex;
    TempFinder.Identifier := Listr.Identifier;
    TempFinder.IENS := Listr.IENS;
    if FFNumber <> '' then TempFinder.Number := FFNumber
    else TempFinder.Number := '*';
    TempFinder.RPCBroker := Listr.RPCBroker;
    TempFinder.Screen := Listr.Screen;
    TempFinder.Value := s;
    if loReturnWriteIDs in Listr.ListerOptions then
      TempFinder.FinderOptions := [foReturnWriteIDs];
    TempFinder.GetFinderList(lstPick.Items);
    if TempFinder.ErrorList.Count <> 0 then begin
      TempFinder.DisplayErrors;
      Exit;
      end;
    if TempFinder.More then begin
      lstPick.Items.Clear;
      MessageDlg('Too many matches found.  Please be more specific.', mtInformation, [mbOk], 0);
      Reset;
      exit;
      end;
    if TempFinder.Results.Count > 0 then begin
      Listr.Results.Assign(TempFinder.Results);
      OKbtn.Enabled := True;
      lstPick.ItemIndex := 0;
      end
    else begin
      OKbtn.Enabled := False;
      MessageDlg('No match was found', mtInformation, [mbOk], 0);
      Reset;
      end;
    TempFinder.Free;
    end;
end;

{Add a new entry }
procedure TfrmLookUp.cmdNewClick(Sender: TObject);
begin
  ChkNew.Checked := true;
  lstPick.ItemIndex := -1;
  okbtn.click;
end;

{Form set up prior to showing.  Get items for list and set more button.}
procedure TfrmLookUp.FormShow(Sender: TObject);
begin
  if lstPick.Items.Count > 0 then begin
    OKbtn.Enabled := True;
    lstPick.ItemIndex := 0;
    MoreBtn.Visible := not (Listr.Number = '*');
    MoreBtn.Enabled := Listr.More;
    end
  else begin
    OKBtn.Enabled := False;
    end;
end;

//bring original list back
procedure TfrmLookUp.Reset;
begin
  Listr.PartList.Clear;
  Listr.GetList(lstPick.Items);
  if Listr.ErrorList.Count <> 0 then begin
    Listr.DisplayErrors;
    Exit;
    end;
  if lstPick.Items.Count > 0 then begin
    OKbtn.Enabled := True;
    lstPick.ItemIndex := 0;
    MoreBtn.Enabled := Listr.More;
    end;
end;

procedure TFMLookup.TextLookUp(txtField: TFMEdit; LookUpFile: String);
var
  new: boolean;
  z : TObject;
begin
  {Tell Lister component that is associated with lookup component which
   file to do lookup on.}
  FMLister.FileNumber := LookUpFile;
  FMLister.ListerOptions := [loReturnIXValues];
  FMLister.ListerFlags := [];
  FMLister.PartList.Clear;
  if Pos('?', txtField.Text) > 0  then FMLister.PartList.Add('')
  else FMLister.PartList.Add(UpperCase(txtField.Text));
  {Execute looup and test if user selected an entry.
   RecordIndex property of FMLookup component contains index to user's selection.}
  if (Execute(new)) and not (RecordIndex < 0) then begin
    z := FMLister.Results.Objects[RecordIndex];
    if (z <> nil) and (z is TFMRecordObj) then FRecordResult := TFMRecordObj(z);
    txtField.Text       := FRecordResult.FMIXExternalValues[0];
    txtField.FMCtrlInternal := FRecordResult.IEN;
    txtField.FMFiler.AddChgdControl(txtField);
    end
  else
    {if user does not make a selection then reset to previous value}
    txtField.text := txtField.FMTag;
end;

procedure Register;
begin
  RegisterComponents('FileMan', [TFMLookUp]);
end;

end.
