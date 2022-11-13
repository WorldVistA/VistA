inherited frmOptionsCombinations: TfrmOptionsCombinations
  Left = 366
  Top = 189
  HelpContext = 9120
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Source Combinations'
  ClientHeight = 345
  ClientWidth = 474
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  ExplicitWidth = 480
  ExplicitHeight = 374
  PixelsPerInch = 96
  TextHeight = 13
  object lblAddby: TLabel [0]
    Left = 7
    Top = 97
    Width = 29
    Height = 13
    Caption = 'Ward:'
  end
  object lblCombinations: TLabel [1]
    Left = 280
    Top = 96
    Width = 66
    Height = 13
    Caption = 'Combinations:'
  end
  object lblInfo: TMemo [2]
    Left = 183
    Top = 8
    Width = 283
    Height = 89
    TabStop = False
    Anchors = [akLeft, akTop, akRight]
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'You can change your combinations by adding '
      'or removing  specific wards, clinics, providers, '
      'specialties, lists, or PCMM teams. Patients '
      'meeting this criteria can be used for patient'
      'selection.')
    ReadOnly = True
    TabOrder = 6
  end
  object radAddByType: TRadioGroup [3]
    Left = 7
    Top = 8
    Width = 170
    Height = 86
    HelpContext = 9121
    Caption = 'Select source by '
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      '&Ward'
      '&Clinic'
      '&Provider'
      '&Specialty'
      '&List'
      'PC&MM')
    TabOrder = 0
    OnClick = radAddByTypeClick
  end
  object lstAddBy: TORComboBox [4]
    Left = 7
    Top = 112
    Width = 170
    Height = 189
    HelpContext = 9122
    Anchors = [akLeft, akTop, akBottom]
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Ward'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 2
    MaxLength = 0
    Pieces = '2'
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 1
    Text = ''
    OnChange = lstAddByChange
    OnDblClick = btnAddClick
    OnEnter = lstAddByEnter
    OnExit = lstAddByExit
    OnKeyUp = lstAddByKeyUp
    OnNeedData = lstAddByNeedData
    CharsNeedMatch = 1
  end
  object btnAdd: TButton [5]
    Left = 183
    Top = 145
    Width = 75
    Height = 22
    HelpContext = 9124
    Caption = '&Add'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnAddClick
  end
  object btnRemove: TButton [6]
    Left = 183
    Top = 186
    Width = 75
    Height = 22
    HelpContext = 9125
    Caption = '&Remove'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnRemoveClick
  end
  object pnlBottom: TPanel [7]
    Left = 0
    Top = 313
    Width = 474
    Height = 32
    HelpContext = 9120
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 5
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 474
      Height = 2
      Align = alTop
      ExplicitWidth = 407
    end
    object btnOK: TButton
      AlignWithMargins = True
      Left = 315
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9996
      Align = alRight
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 396
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9997
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object lvwCombinations: TCaptionListView [8]
    Left = 264
    Top = 118
    Width = 202
    Height = 183
    HelpContext = 9123
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Entry'
        Width = 100
      end
      item
        Caption = 'Source'
        Width = 72
      end>
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    SortType = stBoth
    TabOrder = 4
    ViewStyle = vsReport
    OnChange = lvwCombinationsChange
    OnColumnClick = lvwCombinationsColumnClick
    OnCompare = lvwCombinationsCompare
    OnDblClick = btnRemoveClick
    AutoSize = False
    Caption = 'Combinations'
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 288
    Data = (
      (
        'Component = lblInfo'
        'Status = stsDefault')
      (
        'Component = radAddByType'
        'Status = stsDefault')
      (
        'Component = lstAddBy'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'Status = stsDefault')
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
        'Component = lvwCombinations'
        'Status = stsDefault')
      (
        'Component = frmOptionsCombinations'
        'Status = stsDefault'))
  end
end
