inherited frmNoteProperties: TfrmNoteProperties
  Left = 384
  Top = 56
  BorderIcons = []
  Caption = 'Progress Note Properties'
  ClientHeight = 634
  ClientWidth = 691
  Constraints.MinHeight = 400
  Constraints.MinWidth = 551
  OnResize = FormResize
  ExplicitWidth = 707
  ExplicitHeight = 673
  PixelsPerInch = 96
  TextHeight = 13
  object pnlConsults: TPanel [0]
    Tag = 1
    Left = 0
    Top = 328
    Width = 691
    Height = 153
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    object bvlConsult: TBevel
      Tag = 1
      Left = 0
      Top = 0
      Width = 691
      Height = 2
      Align = alTop
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 2
      ExplicitWidth = 531
    end
    object pnlCTop: TPanel
      Left = 0
      Top = 2
      Width = 691
      Height = 49
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblConsult1: TLabel
        Tag = 1
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 685
        Height = 13
        Align = alTop
        Caption = 
          'This progress note title must be associated with a consult reque' +
          'st.'
        ExplicitWidth = 309
      end
      object pnlCText: TPanel
        Left = 0
        Top = 19
        Width = 691
        Height = 30
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblConsult2: TLabel
          Tag = 1
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 443
          Height = 24
          Align = alClient
          Caption = 'Select one of the following or choose a different title.'
          ExplicitWidth = 247
          ExplicitHeight = 13
        end
        object btnDetails: TButton
          AlignWithMargins = True
          Left = 576
          Top = 3
          Width = 112
          Height = 24
          Align = alRight
          Caption = 'Show &Details'
          TabOrder = 1
          OnClick = btnDetailsClick
        end
        object btnShowList: TButton
          AlignWithMargins = True
          Left = 452
          Top = 3
          Width = 118
          Height = 24
          Align = alRight
          Caption = 'Show &Unresolved'
          TabOrder = 0
          OnClick = btnShowListClick
        end
      end
    end
    object lstRequests: TCaptionListView
      Left = 0
      Top = 51
      Width = 691
      Height = 102
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
  object pnlPRF: TORAutoPanel [1]
    Tag = 3
    Left = 0
    Top = 481
    Width = 691
    Height = 153
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object lblPRF: TLabel
      Tag = 1
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 685
      Height = 13
      Align = alTop
      Caption = 'Which Patient Record Flag Action should this Note be linked to?'
      ExplicitWidth = 304
    end
    object Bevel1: TBevel
      Tag = 1
      Left = 0
      Top = 0
      Width = 691
      Height = 2
      Align = alTop
      ExplicitLeft = 1
      ExplicitTop = 2
      ExplicitWidth = 531
    end
    object lvPRF: TCaptionListView
      Left = 0
      Top = 32
      Width = 691
      Height = 121
      Align = alClient
      Columns = <
        item
          AutoSize = True
          Caption = 'Flag'
        end
        item
          AutoSize = True
          Caption = 'Facility'
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
      OnCompare = lvPRFCompare
      AutoSize = False
      Pieces = '1,8,6,3,9'
    end
  end
  object pnlSurgery: TPanel [2]
    Tag = 2
    Left = 0
    Top = 175
    Width = 691
    Height = 153
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object bvlSurgery: TBevel
      Tag = 2
      Left = 0
      Top = 0
      Width = 691
      Height = 2
      Align = alTop
      Shape = bsBottomLine
      ExplicitLeft = 1
      ExplicitTop = 2
      ExplicitWidth = 531
    end
    object lblSurgery1: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 3
      Top = 10
      Width = 685
      Height = 17
      Margins.Top = 8
      Margins.Bottom = 0
      Align = alTop
      Alignment = taCenter
      Caption = 'This document title must be associated with a surgery case.'
      TabOrder = 0
    end
    object lblSurgery2: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 3
      Top = 27
      Width = 685
      Height = 17
      Margins.Top = 0
      Align = alTop
      Alignment = taCenter
      Caption = 
        'Select one of the following or press cancel and choose a differe' +
        'nt title.'
      TabOrder = 1
    end
    object lstSurgery: TCaptionListView
      Left = 0
      Top = 47
      Width = 691
      Height = 106
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
  object gpMain: TGridPanel [3]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 685
    Height = 169
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 128.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 104.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = lblNewTitle
        Row = 0
        RowSpan = 2
      end
      item
        Column = 1
        ColumnSpan = 2
        Control = cboNewTitle
        Row = 0
        RowSpan = 2
      end
      item
        Column = 3
        Control = cmdOK
        Row = 0
      end
      item
        Column = 3
        Control = cmdCancel
        Row = 1
        RowSpan = 4
      end
      item
        Column = 0
        Control = lblDateTime
        Row = 2
      end
      item
        Column = 1
        Control = calNote
        Row = 2
      end
      item
        Column = 2
        Control = lblProcSummCode
        Row = 2
      end
      item
        Column = 0
        Control = lblAuthor
        Row = 3
      end
      item
        Column = 1
        Control = cboAuthor
        Row = 3
      end
      item
        Column = 2
        Control = cboProcSummCode
        Row = 3
      end
      item
        Column = 0
        Control = lblCosigner
        Row = 4
      end
      item
        Column = 1
        Control = cboCosigner
        Row = 4
      end
      item
        Column = 2
        Control = lblProcDateTime
        Row = 4
      end
      item
        Column = 2
        Control = calProcDateTime
        Row = 5
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 26.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 26.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 26.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 26.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 26.000000000000000000
      end>
    ShowCaption = False
    TabOrder = 3
    object lblNewTitle: TLabel
      AlignWithMargins = True
      Left = 32
      Top = 3
      Width = 93
      Height = 59
      Align = alRight
      Alignment = taRightJustify
      Caption = 'Progress Note Title:'
      ExplicitHeight = 13
    end
    object cboNewTitle: TORComboBox
      AlignWithMargins = True
      Left = 131
      Top = 3
      Width = 447
      Height = 59
      Style = orcsSimple
      Align = alClient
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
      OnEnter = cboNewTitleEnter
      OnExit = cboNewTitleExit
      OnMouseClick = cboNewTitleMouseClick
      OnNeedData = cboNewTitleNeedData
      CharsNeedMatch = 1
    end
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 584
      Top = 0
      Width = 98
      Height = 26
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alClient
      Caption = '&OK'
      Default = True
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 584
      Top = 29
      Width = 98
      Height = 26
      Align = alTop
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 2
      OnClick = cmdCancelClick
    end
    object lblDateTime: TLabel
      AlignWithMargins = True
      Left = 33
      Top = 68
      Width = 92
      Height = 20
      Align = alRight
      Alignment = taRightJustify
      Caption = 'Date/Time of Note:'
      ExplicitHeight = 13
    end
    object calNote: TORDateBox
      AlignWithMargins = True
      Left = 131
      Top = 65
      Width = 220
      Height = 26
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alClient
      TabOrder = 3
      OnEnter = calNoteEnter
      DateOnly = False
      RequireTime = True
      Caption = 'Date/Time of Note:'
      ExplicitHeight = 21
    end
    object lblProcSummCode: TLabel
      AlignWithMargins = True
      Left = 357
      Top = 68
      Width = 123
      Height = 20
      Align = alLeft
      Caption = 'Procedure Summary Code'
      Transparent = False
      ExplicitHeight = 13
    end
    object lblAuthor: TLabel
      AlignWithMargins = True
      Left = 91
      Top = 94
      Width = 34
      Height = 20
      Align = alRight
      Alignment = taRightJustify
      Caption = 'Author:'
      ExplicitHeight = 13
    end
    object cboAuthor: TORComboBox
      AlignWithMargins = True
      Left = 131
      Top = 94
      Width = 220
      Height = 21
      Style = orcsDropDown
      Align = alClient
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
      TabOrder = 4
      Text = ''
      OnEnter = cboAuthorEnter
      OnExit = cboAuthorExit
      OnMouseClick = cboAuthorMouseClick
      OnNeedData = NewPersonNeedData
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object cboProcSummCode: TORComboBox
      AlignWithMargins = True
      Left = 357
      Top = 94
      Width = 221
      Height = 21
      Style = orcsDropDown
      Align = alClient
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
      TabOrder = 5
      Text = ''
      CharsNeedMatch = 1
    end
    object lblCosigner: TLabel
      AlignWithMargins = True
      Left = 33
      Top = 120
      Width = 92
      Height = 20
      Align = alRight
      Alignment = taRightJustify
      Caption = 'Expected Cosigner:'
      ExplicitHeight = 13
    end
    object cboCosigner: TORComboBox
      AlignWithMargins = True
      Left = 131
      Top = 120
      Width = 220
      Height = 21
      Style = orcsDropDown
      Align = alClient
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
      TabOrder = 6
      Text = ''
      OnExit = cboCosignerExit
      OnNeedData = cboCosignerNeedData
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object lblProcDateTime: TLabel
      AlignWithMargins = True
      Left = 357
      Top = 120
      Width = 103
      Height = 20
      Align = alLeft
      Caption = 'Procedure Date/Time'
      Transparent = False
      ExplicitHeight = 13
    end
    object calProcDateTime: TORDateBox
      AlignWithMargins = True
      Left = 357
      Top = 143
      Width = 221
      Height = 26
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alClient
      TabOrder = 7
      OnEnter = calNoteEnter
      DateOnly = False
      RequireTime = True
      Caption = 'Procedure Date/Time'
      ExplicitHeight = 21
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
        'Status = stsDefault'
        'Columns'
        ())
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
        'Status = stsDefault'
        'Columns'
        ())
      (
        'Component = pnlCTop'
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
        'Status = stsOK'
        'Columns'
        ())
      (
        'Component = gpMain'
        'Status = stsDefault'))
  end
end
