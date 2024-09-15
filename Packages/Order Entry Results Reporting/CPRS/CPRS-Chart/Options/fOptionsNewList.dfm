inherited frmOptionsNewList: TfrmOptionsNewList
  Left = 623
  Top = 446
  HelpContext = 9085
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'New Personal List'
  ClientHeight = 152
  ClientWidth = 314
  HelpFile = 'CPRSWT.HLP'
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitHeight = 180
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 120
    Width = 314
    Height = 32
    HelpContext = 9085
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    ExplicitTop = 145
    object btnOK: TButton
      AlignWithMargins = True
      Left = 155
      Top = 3
      Width = 75
      Height = 26
      HelpContext = 9996
      Align = alRight
      Caption = 'OK'
      Default = True
      Enabled = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 236
      Top = 3
      Width = 75
      Height = 26
      HelpContext = 9997
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 314
    Height = 120
    Align = alClient
    ShowCaption = False
    TabOrder = 2
    ExplicitLeft = 72
    ExplicitTop = 80
    ExplicitWidth = 185
    ExplicitHeight = 41
    object lblEnter: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 306
      Height = 16
      Align = alTop
      Caption = 'Enter the name of a new personal list'
      ExplicitLeft = 3
      ExplicitTop = 3
      ExplicitWidth = 216
    end
    object txtNewList: TCaptionEdit
      AlignWithMargins = True
      Left = 4
      Top = 26
      Width = 306
      Height = 24
      HelpContext = 9086
      Align = alTop
      MaxLength = 30
      TabOrder = 0
      OnChange = txtNewListChange
      OnKeyPress = txtNewListKeyPress
      Caption = 'Enter the name of a new personal list'
      ExplicitLeft = 3
      ExplicitTop = 3
      ExplicitWidth = 308
    end
    object grpVisibility: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 56
      Width = 306
      Height = 60
      Align = alClient
      Caption = 'Who should be able to see and use this list?'
      Columns = 2
      ItemIndex = 1
      Items.Strings = (
        '&Myself only'
        '&All CPRS users')
      TabOrder = 1
      ExplicitLeft = 3
      ExplicitTop = 25
      ExplicitWidth = 308
      ExplicitHeight = 52
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 232
    Top = 8
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
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault'))
  end
end
