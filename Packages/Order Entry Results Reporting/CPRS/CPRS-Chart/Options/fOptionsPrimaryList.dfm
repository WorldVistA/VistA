inherited frmOptionsPrimaryList: TfrmOptionsPrimaryList
  Left = 714
  Top = 143
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Primary List'
  ClientHeight = 232
  ClientWidth = 474
  HelpFile = 'CPRSWT.HLP'
  ExplicitWidth = 480
  ExplicitHeight = 260
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 200
    Width = 474
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    ExplicitWidth = 314
    object btnOK: TButton
      AlignWithMargins = True
      Left = 315
      Top = 3
      Width = 75
      Height = 26
      Align = alRight
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 155
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 396
      Top = 3
      Width = 75
      Height = 26
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 236
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 474
    Height = 200
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 72
    ExplicitTop = 112
    ExplicitWidth = 185
    ExplicitHeight = 41
    object lblPrimaryList: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 466
      Height = 38
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Select the list you wish to be your primary personal list.'
      WordWrap = True
      ExplicitLeft = 3
      ExplicitTop = 3
      ExplicitWidth = 228
    end
    object cboPrimary: TORComboBox
      AlignWithMargins = True
      Left = 4
      Top = 48
      Width = 466
      Height = 148
      Style = orcsSimple
      Align = alClient
      AutoSelect = True
      Caption = 'Select the list you wish to be your primary personal list.'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 16
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = True
      SynonymChars = '<>'
      TabOrder = 0
      Text = ''
      CharsNeedMatch = 1
      ExplicitWidth = 480
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 96
    Top = 112
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
        'Component = cboPrimary'
        'Status = stsDefault')
      (
        'Component = frmOptionsPrimaryList'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault'))
  end
end
