inherited frmNoteCPFields: TfrmNoteCPFields
  Left = 508
  Top = 307
  Caption = 'Enter Required Fields'
  ClientHeight = 151
  ClientWidth = 249
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 257
  ExplicitHeight = 178
  PixelsPerInch = 96
  TextHeight = 13
  object lblAuthor: TLabel [0]
    Left = 7
    Top = 5
    Width = 94
    Height = 13
    AutoSize = False
    Caption = 'Author:'
  end
  object lblProcSummCode: TOROffsetLabel [1]
    Left = 4
    Top = 50
    Width = 125
    Height = 15
    Caption = 'Procedure Summary Code'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object lblProcDateTime: TOROffsetLabel [2]
    Left = 4
    Top = 96
    Width = 105
    Height = 15
    Caption = 'Procedure Date/Time'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object cboAuthor: TORComboBox [3]
    Left = 4
    Top = 17
    Width = 239
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Author'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = True
    LookupPiece = 2
    MaxLength = 0
    ParentShowHint = False
    Pieces = '2,3'
    ShowHint = True
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    OnNeedData = cboAuthorNeedData
    CharsNeedMatch = 1
  end
  object cboProcSummCode: TORComboBox [4]
    Left = 4
    Top = 66
    Width = 142
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Procedure Summary Code'
    Color = clWindow
    DropDownCount = 8
    Items.Strings = (
      '1^Normal'
      '2^Abnormal'
      '3^Borderline'
      '4^Incomplete')
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 1
    CharsNeedMatch = 1
  end
  object calProcDateTime: TORDateBox [5]
    Left = 4
    Top = 112
    Width = 142
    Height = 21
    TabOrder = 2
    DateOnly = False
    RequireTime = True
    Caption = 'Procedure Date/Time'
  end
  object cmdOK: TButton [6]
    Left = 166
    Top = 78
    Width = 72
    Height = 21
    Hint = 
      'Save these items, and continue to enter text interpretation of r' +
      'esults.'
    Caption = 'Save'
    Default = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [7]
    Left = 166
    Top = 105
    Width = 72
    Height = 21
    Hint = 
      'Enter text interpretation of results now, and enter these items ' +
      'later.'
    Cancel = True
    Caption = 'Enter Later'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = cmdCancelClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboAuthor'
        'Status = stsDefault')
      (
        'Component = cboProcSummCode'
        'Status = stsDefault')
      (
        'Component = calProcDateTime'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmNoteCPFields'
        'Status = stsDefault'))
  end
end
