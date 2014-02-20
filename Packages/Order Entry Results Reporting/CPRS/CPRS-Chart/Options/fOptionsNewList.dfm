inherited frmOptionsNewList: TfrmOptionsNewList
  Left = 623
  Top = 446
  HelpContext = 9085
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'New Personal List'
  ClientHeight = 234
  ClientWidth = 173
  Font.Name = 'Tahoma'
  HelpFile = 'CPRSWT.HLP'
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 179
  ExplicitHeight = 262
  PixelsPerInch = 96
  TextHeight = 13
  object lblEnter: TLabel [0]
    Left = 10
    Top = 8
    Width = 96
    Height = 13
    Caption = 'Enter the name of a'
  end
  object lblNew: TLabel [1]
    Left = 10
    Top = 24
    Width = 84
    Height = 13
    Caption = 'new personal list.'
  end
  object Label1: TLabel [2]
    Left = 11
    Top = 80
    Width = 156
    Height = 33
    AutoSize = False
    Caption = 'Who should be able to see and use this list?'
    WordWrap = True
  end
  object pnlBottom: TPanel [3]
    Left = 0
    Top = 200
    Width = 173
    Height = 34
    HelpContext = 9085
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object btnOK: TButton
      Left = 11
      Top = 7
      Width = 75
      Height = 22
      HelpContext = 9996
      Caption = 'OK'
      Default = True
      Enabled = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 91
      Top = 7
      Width = 75
      Height = 22
      HelpContext = 9997
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object txtNewList: TCaptionEdit [4]
    Left = 10
    Top = 45
    Width = 153
    Height = 21
    HelpContext = 9086
    MaxLength = 30
    TabOrder = 0
    OnChange = txtNewListChange
    OnKeyPress = txtNewListKeyPress
    Caption = 'Enter the name of a new personal list'
  end
  object grpVisibility: TRadioGroup [5]
    Left = 11
    Top = 105
    Width = 156
    Height = 81
    ItemIndex = 1
    Items.Strings = (
      '&Myself only'
      '&All CPRS users')
    TabOrder = 1
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = txtNewList'
        'Status = stsDefault')
      (
        'Component = grpVisibility'
        'Status = stsDefault')
      (
        'Component = frmOptionsNewList'
        'Status = stsDefault'))
  end
end
