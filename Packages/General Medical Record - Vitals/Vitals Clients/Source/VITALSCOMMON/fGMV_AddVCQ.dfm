object frmGMV_AddVCQ: TfrmGMV_AddVCQ
  Left = 211
  Top = 354
  BorderStyle = bsDialog
  Caption = 'Add Vital'
  ClientHeight = 190
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 168
    Top = 160
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 88
    Top = 160
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
  object lbxVitals: TListBox
    Left = 8
    Top = 8
    Width = 233
    Height = 145
    ItemHeight = 13
    MultiSelect = True
    Sorted = True
    TabOrder = 2
    OnDblClick = lbxVitalsDblClick
  end
end
