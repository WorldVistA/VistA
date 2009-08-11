inherited frmOptionsReminders: TfrmOptionsReminders
  Left = 693
  Top = 17
  HelpContext = 9020
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Clinical Reminders on Cover Sheet'
  ClientHeight = 323
  ClientWidth = 407
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblDisplayed: TLabel [0]
    Left = 209
    Top = 8
    Width = 129
    Height = 13
    Caption = 'Reminders being displayed:'
  end
  object lblNotDisplayed: TLabel [1]
    Left = 8
    Top = 8
    Width = 147
    Height = 13
    Caption = 'Reminders not being displayed:'
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 290
    Width = 407
    Height = 33
    HelpContext = 9020
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 7
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 407
      Height = 2
      Align = alTop
    end
    object btnOK: TButton
      Left = 247
      Top = 8
      Width = 75
      Height = 22
      HelpContext = 9996
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 327
      Top = 8
      Width = 75
      Height = 22
      HelpContext = 9997
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object lstDisplayed: TORListBox [3]
    Left = 209
    Top = 25
    Width = 160
    Height = 217
    HelpContext = 9025
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = lstDisplayedChange
    OnDblClick = btnDeleteClick
    Caption = 'Reminders being displayed:'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '3'
    OnChange = lstDisplayedChange
  end
  object lstNotDisplayed: TORListBox [4]
    Left = 8
    Top = 25
    Width = 160
    Height = 217
    HelpContext = 9026
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 0
    OnClick = lstNotDisplayedChange
    OnDblClick = btnAddClick
    Caption = 'Reminders not being displayed:'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '3'
    OnChange = lstNotDisplayedChange
  end
  object btnUp: TButton [5]
    Left = 378
    Top = 94
    Width = 22
    Height = 22
    HelpContext = 9021
    Caption = '^'
    TabOrder = 4
    OnClick = btnUpClick
  end
  object btnDown: TButton [6]
    Left = 378
    Top = 142
    Width = 22
    Height = 22
    HelpContext = 9022
    Caption = 'v'
    TabOrder = 6
    OnClick = btnDownClick
  end
  object btnDelete: TButton [7]
    Left = 178
    Top = 181
    Width = 22
    Height = 22
    HelpContext = 9023
    Caption = '<'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnDeleteClick
  end
  object btnAdd: TButton [8]
    Left = 178
    Top = 70
    Width = 22
    Height = 22
    HelpContext = 9024
    Caption = '>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnAddClick
  end
  object radSort: TRadioGroup [9]
    Left = 209
    Top = 246
    Width = 192
    Height = 37
    Caption = 'Sort by '
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      '&Display Order'
      '&Alphabetical')
    ParentFont = False
    TabOrder = 5
    OnClick = radSortClick
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
        'Component = lstDisplayed'
        'Status = stsDefault')
      (
        'Component = lstNotDisplayed'
        'Status = stsDefault')
      (
        'Component = btnUp'
        'Status = stsDefault')
      (
        'Component = btnDown'
        'Status = stsDefault')
      (
        'Component = btnDelete'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = radSort'
        'Status = stsDefault')
      (
        'Component = frmOptionsReminders'
        'Status = stsDefault'))
  end
end
