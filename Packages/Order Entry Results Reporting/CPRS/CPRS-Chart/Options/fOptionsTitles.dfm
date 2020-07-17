inherited frmOptionsTitles: TfrmOptionsTitles
  Left = 271
  Top = 271
  HelpContext = 9230
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Document Titles'
  ClientHeight = 237
  ClientWidth = 533
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  OnShow = FormShow
  ExplicitWidth = 539
  ExplicitHeight = 270
  PixelsPerInch = 96
  TextHeight = 13
  object lblDocumentClass: TLabel [0]
    Left = 8
    Top = 17
    Width = 79
    Height = 13
    Caption = 'Document class:'
  end
  object lblDocumentTitles: TLabel [1]
    Left = 8
    Top = 57
    Width = 76
    Height = 13
    Caption = 'Document titles:'
  end
  object lblYourTitles: TLabel [2]
    Left = 299
    Top = 78
    Width = 76
    Height = 13
    Caption = 'Your list of titles:'
  end
  object lblDefaultTitle: TStaticText [3]
    Left = 299
    Top = 43
    Width = 41
    Height = 17
    Caption = 'Default:'
    TabOrder = 10
  end
  object lblDefault: TStaticText [4]
    Left = 299
    Top = 59
    Width = 108
    Height = 17
    Caption = '<no default specified>'
    ShowAccelChar = False
    TabOrder = 11
  end
  object lblDocumentPreference: TStaticText [5]
    Left = 199
    Top = 6
    Width = 132
    Height = 17
    Caption = 'Document List Preferences'
    TabOrder = 12
  end
  object cboDocumentClass: TORComboBox [6]
    Left = 8
    Top = 31
    Width = 200
    Height = 21
    HelpContext = 9231
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Document class'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
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
    OnClick = cboDocumentClassClick
    CharsNeedMatch = 1
  end
  object lstYourTitles: TORListBox [7]
    Left = 299
    Top = 93
    Width = 200
    Height = 108
    HelpContext = 9237
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = lstYourTitlesClick
    OnDblClick = btnRemoveClick
    Caption = 'Your list of titles'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
    OnChange = lstYourTitlesChange
  end
  object btnAdd: TButton [8]
    Left = 211
    Top = 93
    Width = 85
    Height = 22
    HelpContext = 9233
    Caption = 'Add'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnAddClick
  end
  object btnRemove: TButton [9]
    Left = 211
    Top = 121
    Width = 85
    Height = 22
    HelpContext = 9234
    Caption = 'Remove'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnRemoveClick
  end
  object btnDefault: TButton [10]
    Left = 211
    Top = 178
    Width = 85
    Height = 22
    HelpContext = 9236
    Caption = 'Set as Default'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnDefaultClick
  end
  object btnSaveChanges: TButton [11]
    Left = 211
    Top = 150
    Width = 85
    Height = 22
    HelpContext = 9235
    Caption = 'Save Changes'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnSaveChangesClick
  end
  object pnlBottom: TPanel [12]
    Left = 0
    Top = 204
    Width = 533
    Height = 33
    HelpContext = 9230
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 9
    ExplicitWidth = 527
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 533
      Height = 2
      Align = alTop
      ExplicitWidth = 527
    end
    object btnOK: TButton
      Left = 367
      Top = 7
      Width = 75
      Height = 22
      HelpContext = 9996
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 448
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
  object cboDocumentTitles: TORComboBox [13]
    Left = 8
    Top = 72
    Width = 200
    Height = 129
    HelpContext = 9232
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Document titles'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = True
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 1
    Text = ''
    OnChange = cboDocumentTitlesChange
    OnDblClick = btnAddClick
    OnNeedData = cboDocumentTitlesNeedData
    CharsNeedMatch = 1
  end
  object btnUp: TButton [14]
    Left = 504
    Top = 110
    Width = 22
    Height = 22
    HelpContext = 9021
    Caption = '^'
    TabOrder = 7
    OnClick = btnUpClick
  end
  object btnDown: TButton [15]
    Left = 504
    Top = 150
    Width = 22
    Height = 22
    HelpContext = 9022
    Caption = 'v'
    TabOrder = 8
    OnClick = btnDownClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblDefaultTitle'
        'Status = stsDefault')
      (
        'Component = lblDefault'
        'Status = stsDefault')
      (
        'Component = lblDocumentPreference'
        'Status = stsDefault')
      (
        'Component = cboDocumentClass'
        'Status = stsDefault')
      (
        'Component = lstYourTitles'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = btnDefault'
        'Status = stsDefault')
      (
        'Component = btnSaveChanges'
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
        'Component = cboDocumentTitles'
        'Status = stsDefault')
      (
        'Component = btnUp'
        'Status = stsDefault')
      (
        'Component = btnDown'
        'Status = stsDefault')
      (
        'Component = frmOptionsTitles'
        'Status = stsDefault'))
  end
end
