inherited frmNoteCPFields: TfrmNoteCPFields
  Left = 508
  Top = 307
  Caption = 'Enter Required Fields'
  ClientHeight = 210
  ClientWidth = 275
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 275
    Height = 179
    Align = alClient
    ShowCaption = False
    TabOrder = 1
    object lblAuthor: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 267
      Height = 12
      Align = alTop
      AutoSize = False
      Caption = 'Author:'
    end
    object lblProcSummCode: TOROffsetLabel
      AlignWithMargins = True
      Left = 4
      Top = 73
      Width = 267
      Height = 18
      Align = alTop
      Caption = 'Procedure Summary Code'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
      ExplicitWidth = 161
    end
    object lblProcDateTime: TOROffsetLabel
      AlignWithMargins = True
      Left = 4
      Top = 124
      Width = 267
      Height = 18
      Align = alTop
      Caption = 'Procedure Date/Time'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
      ExplicitTop = 107
      ExplicitWidth = 134
    end
    object cboAuthor: TORCheckComboBox
      AlignWithMargins = True
      Left = 4
      Top = 22
      Width = 267
      Height = 45
      Style = orcsDropDown
      Align = alTop
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
      Text = ''
      OnNeedData = cboAuthorNeedData
      CharsNeedMatch = 1
      MainCheckBoxCaption = 'Include Non-VA Providers'
      MainCheckBoxVisible = True
      MainCheckBoxAlignment = calBottom
      OnMainCheckboxClick = cboAuthorMainCheckboxClick
      DropdownStyle = ddsControl
    end
    object cboProcSummCode: TORComboBox
      AlignWithMargins = True
      Left = 4
      Top = 97
      Width = 267
      Height = 21
      Style = orcsDropDown
      Align = alTop
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
      Text = ''
      CharsNeedMatch = 1
    end
    object calProcDateTime: TORDateBox
      AlignWithMargins = True
      Left = 4
      Top = 148
      Width = 267
      Height = 21
      Align = alTop
      TabOrder = 2
      DateOnly = False
      RequireTime = True
      Caption = 'Procedure Date/Time'
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 179
    Width = 275
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 181
      Top = 3
      Width = 91
      Height = 25
      Hint = 
        'Enter text interpretation of results now, and enter these items ' +
        'later.'
      Align = alRight
      Cancel = True
      Caption = 'Enter Later'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = cmdCancelClick
    end
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 103
      Top = 3
      Width = 72
      Height = 25
      Hint = 
        'Save these items, and continue to enter text interpretation of r' +
        'esults.'
      Align = alRight
      Caption = 'Save'
      Default = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = cmdOKClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Panel1'
        'Status = stsDefault')
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
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = frmNoteCPFields'
        'Status = stsDefault'))
  end
end
