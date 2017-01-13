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
  ExplicitWidth = 559
  ExplicitHeight = 714
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
    Text = ''
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
    Text = ''
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
    Text = ''
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
    TabOrder = 8
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [11]
    Left = 465
    Top = 38
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 9
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
    Text = ''
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
  object pnlConsults: TPanel [14]
    Tag = 1
    Left = 0
    Top = 370
    Width = 543
    Height = 153
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    Visible = False
    object bvlConsult: TBevel
      Tag = 1
      Left = 1
      Top = 2
      Width = 531
      Height = 2
    end
    object pnlCTop: TPanel
      Left = 0
      Top = 0
      Width = 543
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object pnlCButtons: TPanel
        Left = 334
        Top = 0
        Width = 209
        Height = 41
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object btnShowList: TButton
          Left = 21
          Top = 10
          Width = 100
          Height = 21
          Caption = 'Show Unresolved'
          TabOrder = 0
          OnClick = btnShowListClick
        end
        object btnDetails: TButton
          Left = 127
          Top = 10
          Width = 75
          Height = 21
          Caption = 'Show Details'
          TabOrder = 1
          OnClick = btnDetailsClick
        end
      end
      object pnlCText: TPanel
        Left = 0
        Top = 0
        Width = 334
        Height = 41
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object lblConsult1: TLabel
          Tag = 1
          Left = 3
          Top = 10
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
      end
    end
    object lstRequests: TCaptionListView
      Left = 0
      Top = 41
      Width = 543
      Height = 112
      Margins.Left = 8
      Margins.Right = 8
      Align = alClient
      Columns = <
        item
          Caption = 'Consult Request Date'
          Width = 120
        end
        item
          Caption = 'Service'
          Tag = 1
          Width = 120
        end
        item
          Caption = 'Procedure'
          Tag = 2
          Width = 160
        end
        item
          Caption = 'Status'
          Width = 70
        end
        item
          Caption = '# Notes'
        end>
      HideSelection = False
      HoverTime = 0
      IconOptions.WrapText = False
      ReadOnly = True
      RowSelect = True
      ParentShowHint = False
      ShowWorkAreas = True
      ShowHint = True
      TabOrder = 1
      ViewStyle = vsReport
      OnChange = CaptionListView1Change
      AutoSize = False
      Caption = 'Associated Consult Request'
      Pieces = '2,3,4,5,6'
    end
  end
  object pnlPRF: TPanel [15]
    Tag = 3
    Left = 0
    Top = 523
    Width = 543
    Height = 153
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 7
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
      AutoSize = False
    end
  end
  object pnlSurgery: TPanel [16]
    Tag = 2
    Left = 0
    Top = 217
    Width = 543
    Height = 153
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 12
    Visible = False
    object bvlSurgery: TBevel
      Tag = 2
      Left = 1
      Top = 2
      Width = 531
      Height = 2
    end
    object lblSurgery1: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 100
      Top = 8
      Width = 440
      Height = 17
      Margins.Left = 100
      Margins.Top = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'This document title must be associated with a surgery case.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object lblSurgery2: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 90
      Top = 25
      Width = 450
      Height = 17
      Margins.Left = 90
      Margins.Top = 0
      Align = alTop
      Caption = 
        'Select one of the following or press cancel and choose a differe' +
        'nt title.'
      TabOrder = 1
    end
    object lstSurgery: TCaptionListView
      Left = 0
      Top = 45
      Width = 543
      Height = 108
      Margins.Left = 8
      Margins.Right = 8
      Align = alClient
      Columns = <
        item
          Caption = 'Surgery Date'
          Width = 180
        end
        item
          Caption = 'Procedure'
          Tag = 1
          Width = 100
        end
        item
          Caption = 'Surgeon'
          Tag = 2
          Width = 160
        end>
      HideSelection = False
      HoverTime = 0
      IconOptions.WrapText = False
      ReadOnly = True
      RowSelect = True
      ParentShowHint = False
      ShowWorkAreas = True
      ShowHint = True
      TabOrder = 2
      ViewStyle = vsReport
      AutoSize = False
      Caption = 'Associated Surgery Case'
      Pieces = '3,2,4'
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboNewTitle'
        'Status = stsDefault')
      (
        'Component = calNote'
        'Text = Date/Time of Note. Press the enter key to access.'
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
        'Text = Procedure Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = pnlConsults'
        'Status = stsDefault')
      (
        'Component = pnlPRF'
        'Status = stsDefault')
      (
        'Component = lvPRF'
        'Status = stsDefault')
      (
        'Component = frmNoteProperties'
        'Status = stsDefault')
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
        'Component = pnlCTop'
        'Status = stsDefault')
      (
        'Component = pnlCButtons'
        'Status = stsDefault')
      (
        'Component = pnlCText'
        'Status = stsDefault')
      (
        'Component = btnShowList'
        'Status = stsDefault')
      (
        'Component = btnDetails'
        'Status = stsDefault')
      (
        'Component = lstRequests'
        
          'Text = This progress note title must be associated with a consul' +
          't request.'#13#10'Select one of the following or choose a different ti' +
          'tle.'
        'Status = stsOK'))
  end
end
