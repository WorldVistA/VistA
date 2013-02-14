inherited frmNoteProperties: TfrmNoteProperties
  Left = 384
  Top = 56
  BorderIcons = []
  Caption = 'Progress Note Properties'
  ClientHeight = 676
  ClientWidth = 543
  Constraints.MinWidth = 551
  Position = poScreenCenter
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  ExplicitLeft = 384
  ExplicitTop = 56
  ExplicitWidth = 551
  ExplicitHeight = 710
  PixelsPerInch = 96
  TextHeight = 13
  object lblNewTitle: TLabel [0]
    Left = 7
    Top = 14
    Width = 93
    Height = 13
    Alignment = taRightJustify
    Caption = 'Progress Note Title:'
  end
  object lblDateTime: TLabel [1]
    Left = 6
    Top = 138
    Width = 94
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Date/Time of Note:'
  end
  object lblAuthor: TLabel [2]
    Left = 6
    Top = 165
    Width = 94
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Author:'
  end
  object lblCosigner: TLabel [3]
    Left = 6
    Top = 192
    Width = 94
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Expected Cosigner:'
  end
  object lblProcSummCode: TOROffsetLabel [4]
    Left = 371
    Top = 135
    Width = 125
    Height = 15
    Caption = 'Procedure Summary Code'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object lblProcDateTime: TOROffsetLabel [5]
    Left = 371
    Top = 174
    Width = 105
    Height = 15
    Caption = 'Procedure Date/Time'
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object cboNewTitle: TORComboBox [6]
    Left = 104
    Top = 11
    Width = 347
    Height = 118
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Progress Note Title'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = True
    LookupPiece = 0
    MaxLength = 0
    ParentShowHint = False
    Pieces = '2'
    ShowHint = True
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    OnDblClick = cboNewTitleDblClick
    OnDropDownClose = cboNewTitleDropDownClose
    OnEnter = cboNewTitleEnter
    OnExit = cboNewTitleExit
    OnMouseClick = cboNewTitleMouseClick
    OnNeedData = cboNewTitleNeedData
    CharsNeedMatch = 1
  end
  object calNote: TORDateBox [7]
    Left = 104
    Top = 135
    Width = 140
    Height = 21
    TabOrder = 1
    OnEnter = calNoteEnter
    DateOnly = False
    RequireTime = True
    Caption = 'Date/Time of Note:'
  end
  object cboAuthor: TORComboBox [8]
    Left = 104
    Top = 162
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
    TabOrder = 2
    OnEnter = cboAuthorEnter
    OnExit = cboAuthorExit
    OnMouseClick = cboAuthorMouseClick
    OnNeedData = NewPersonNeedData
    CharsNeedMatch = 1
  end
  object cboCosigner: TORComboBox [9]
    Left = 104
    Top = 189
    Width = 239
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Expected Cosigner:'
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
    TabOrder = 3
    OnExit = cboCosignerExit
    OnNeedData = cboCosignerNeedData
    CharsNeedMatch = 1
  end
  object cmdOK: TButton [10]
    Left = 465
    Top = 11
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 9
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [11]
    Left = 465
    Top = 38
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 10
    OnClick = cmdCancelClick
  end
  object cboProcSummCode: TORComboBox [12]
    Left = 371
    Top = 150
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
    TabOrder = 4
    CharsNeedMatch = 1
  end
  object calProcDateTime: TORDateBox [13]
    Left = 371
    Top = 189
    Width = 142
    Height = 21
    TabOrder = 5
    OnEnter = calNoteEnter
    DateOnly = False
    RequireTime = True
    Caption = 'Procedure Date/Time'
  end
  object pnlSurgery: TORAutoPanel [14]
    Tag = 2
    Left = 0
    Top = 217
    Width = 543
    Height = 153
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    Visible = False
    object lblSurgDate: TLabel
      Tag = 2
      Left = 2
      Top = 40
      Width = 62
      Height = 13
      Caption = 'Surgery Date'
    end
    object lblSurgProc: TLabel
      Tag = 2
      Left = 98
      Top = 40
      Width = 49
      Height = 13
      Caption = 'Procedure'
    end
    object lblSurgeon: TLabel
      Tag = 2
      Left = 362
      Top = 40
      Width = 40
      Height = 13
      Caption = 'Surgeon'
    end
    object bvlSurgery: TBevel
      Tag = 2
      Left = 1
      Top = 2
      Width = 531
      Height = 2
    end
    object lblSurgery1: TStaticText
      Tag = 2
      Left = 103
      Top = 8
      Width = 284
      Height = 17
      Caption = 'This document title must be associated with a surgery case.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object lblSurgery2: TStaticText
      Tag = 2
      Left = 93
      Top = 22
      Width = 335
      Height = 17
      Caption = 
        'Select one of the following or press cancel and choose a differe' +
        'nt title.'
      TabOrder = 2
    end
    object lstSurgery: TORListBox
      Tag = 2
      Left = 0
      Top = 52
      Width = 543
      Height = 101
      Align = alBottom
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'Associated Surgery Case'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '3,2,4'
      TabPositions = '16,60,85'
    end
  end
  object pnlConsults: TORAutoPanel [15]
    Tag = 1
    Left = 0
    Top = 370
    Width = 543
    Height = 153
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 7
    Visible = False
    object lblConsult1: TLabel
      Tag = 1
      Left = 3
      Top = 8
      Width = 309
      Height = 13
      Caption = 
        'This progress note title must be associated with a consult reque' +
        'st.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblConsult2: TLabel
      Tag = 1
      Left = 3
      Top = 22
      Width = 247
      Height = 13
      Caption = 'Select one of the following or choose a different title.'
    end
    object lblCsltDate: TLabel
      Tag = 1
      Left = 2
      Top = 40
      Width = 104
      Height = 13
      Caption = 'Consult Request Date'
    end
    object lblCsltServ: TLabel
      Tag = 1
      Left = 128
      Top = 40
      Width = 36
      Height = 13
      Caption = 'Service'
    end
    object lblCsltProc: TLabel
      Tag = 1
      Left = 261
      Top = 40
      Width = 49
      Height = 13
      Caption = 'Procedure'
    end
    object lblCsltStat: TLabel
      Tag = 1
      Left = 416
      Top = 40
      Width = 30
      Height = 13
      Caption = 'Status'
    end
    object lblCsltNotes: TLabel
      Tag = 1
      Left = 482
      Top = 40
      Width = 38
      Height = 13
      Caption = '# Notes'
    end
    object bvlConsult: TBevel
      Tag = 1
      Left = 1
      Top = 2
      Width = 531
      Height = 2
    end
    object lstRequests: TORListBox
      Tag = 1
      Left = 0
      Top = 52
      Width = 543
      Height = 101
      Align = alBottom
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'Associated Consult Request'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2,3,4,5,6'
      TabPositions = '21,43,69,83'
      OnChange = lstRequestsChange
    end
    object btnShowList: TButton
      Left = 335
      Top = 13
      Width = 100
      Height = 21
      Caption = 'Show Unresolved'
      TabOrder = 1
      OnClick = btnShowListClick
    end
    object btnDetails: TButton
      Left = 450
      Top = 13
      Width = 75
      Height = 21
      Caption = 'Show Details'
      TabOrder = 2
      OnClick = btnDetailsClick
    end
  end
  object pnlPRF: TORAutoPanel [16]
    Tag = 3
    Left = 0
    Top = 523
    Width = 543
    Height = 153
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 8
    Visible = False
    object lblPRF: TLabel
      Tag = 1
      Left = 2
      Top = 16
      Width = 304
      Height = 13
      Caption = 'Which Patient Record Flag Action should this Note be linked to?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Bevel1: TBevel
      Tag = 1
      Left = 1
      Top = 2
      Width = 531
      Height = 2
    end
    object lvPRF: TCaptionListView
      Left = 0
      Top = 32
      Width = 543
      Height = 121
      Align = alBottom
      Columns = <
        item
          Caption = 'Used For Screen Readers'
          Width = 1
        end
        item
          AutoSize = True
          Caption = 'Flag'
        end
        item
          AutoSize = True
          Caption = 'Date'
        end
        item
          AutoSize = True
          Caption = 'Action'
        end
        item
          AutoSize = True
          Caption = 'Note'
        end>
      Constraints.MinHeight = 50
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboNewTitle'
        'Status = stsDefault')
      (
        'Component = calNote'
        'Label = lblDateTime'
        'Status = stsOK')
      (
        'Component = cboAuthor'
        'Status = stsDefault')
      (
        'Component = cboCosigner'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cboProcSummCode'
        'Status = stsDefault')
      (
        'Component = calProcDateTime'
        'Property = Caption'
        'Status = stsOK')
      (
        'Component = pnlSurgery'
        'Status = stsDefault')
      (
        'Component = lblSurgery1'
        'Status = stsDefault')
      (
        'Component = lblSurgery2'
        'Status = stsDefault')
      (
        'Component = lstSurgery'
        'Status = stsDefault')
      (
        'Component = pnlConsults'
        'Status = stsDefault')
      (
        'Component = lstRequests'
        'Status = stsDefault')
      (
        'Component = btnShowList'
        'Status = stsDefault')
      (
        'Component = btnDetails'
        'Status = stsDefault')
      (
        'Component = pnlPRF'
        'Status = stsDefault')
      (
        'Component = lvPRF'
        'Status = stsDefault')
      (
        'Component = frmNoteProperties'
        'Status = stsDefault'))
  end
end
