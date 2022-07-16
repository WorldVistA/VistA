{*******************************************************}
{       VA FileMan Delphi Components                    }
{                                                       }
{       San Francisco CIOFO                             }
{                                                       }
{       Revision Date: 10/06/98                         }
{                                                       }
{       Distribution Date: 02/28/98                     }
{                                                       }
{       Version: 1.0                                    }
{                                                       }
{*******************************************************}

unit didataprob;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmDataProblemList = class(TForm)
    BitBtn1: TBitBtn;
    ProblemListBox: TListBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure ProblemListBoxDblClick(Sender: TObject);
  protected
    procedure CantFocus(fld: string); virtual;
  end;

var
  frmDataProblemList: TfrmDataProblemList;

implementation

uses
  System.UITypes,
  fmcntrls;

{$R *.DFM}

procedure TfrmDataProblemList.BitBtn1Click(Sender: TObject);
begin
  MessageDlg('Double click on item in box to correct data problem', mtInformation, [mbOK], 0);
end;

procedure TfrmDataProblemList.ProblemListBoxDblClick(Sender: TObject);
var
  obj: TObject;
  x : string;
  olditemindex, newitemindex : integer;
begin
  if ProblemListBox.ItemIndex = -1 then exit;
  obj := ProblemListBox.Items.Objects[ProblemListBox.ItemIndex];
  if (obj is TFMEdit) then begin
    x := TFMEdit(obj).FMDisplayName;
    if TFMEdit(obj).CanFocus then TFMEdit(obj).Setfocus
    else  CantFocus(x);
    end
  else if obj is TFMCheckBox then begin
    x := TFMCheckBox(obj).FMDisplayName;
    if TFMCheckBox(obj).CanFocus then TFMCheckBox(obj).Setfocus
    else  CantFocus(x);
    end
  else if (obj is TFMComboBox) or (obj is TFMComboBoxLookUp)then begin
    x := TFMComboBox(obj).FMDisplayName;
    if TFMComboBox(obj).CanFocus then TFMComboBox(obj).Setfocus
    else  CantFocus(x);
    end
  else if obj is TFMListBox then begin
    x := TFMListBox(obj).FMDisplayName;
    if TFMListBox(obj).CanFocus then TFMListBox(obj).Setfocus
    else  CantFocus(x);
    end
  else if obj is TFMMemo then begin
    x := TFMMemo(obj).FMDisplayName;
    if TFMMemo(obj).CanFocus then TFMMemo(obj).Setfocus
    else  CantFocus(x);
    end
  else if obj is TFMRadioButton then begin
    x := TFMRadioButton(obj).FMDisplayName;
    if TFMRadioButton(obj).CanFocus then TFMRadioButton(obj).Setfocus
    else  CantFocus(x);
    end
  else if obj is TFMRadioGroup then begin
    x := TFMRadioGroup(obj).FMDisplayName;
    if TFMRadioGroup(obj).CanFocus then begin
      with TFMRadioGroup(obj) do begin
        SetFocus;
        OldItemIndex := ItemIndex;
        if OldItemIndex <> -1 then NewItemIndex := OldItemIndex
        else NewItemIndex := 0;
        with (Components[NewItemIndex] as TRadioButton) do SetFocus;
        ItemIndex := OldItemIndex;
        end;
      end
    else  CantFocus(x);
    end;
end;

procedure TfrmDataProblemList.CantFocus(fld: string);
begin
  if fld = '' then fld := 'this field';
  MessageDlg('Cannot set focus to ' + fld, mtInformation, [mbOK], 0);
end;

end.
