inherited frmNoteProperties: TfrmNoteProperties
  Left = 384
  Top = 56
  BorderIcons = []
  Caption = 'Progress Note Properties'
  ClientHeight = 861
  ClientWidth = 758
  Constraints.MinWidth = 775
  Font.Height = -16
  Font.Name = 'Tahoma'
  Position = poScreenCenter
  OnDestroy = FormDestroy
  ExplicitTop = -284
  ExplicitWidth = 776
  ExplicitHeight = 906
  PixelsPerInch = 120
  TextHeight = 19
  object lblNewTitle: TLabel [0]
    Left = 43
    Top = 18
    Width = 141
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taRightJustify
    Caption = 'Progress Note Title:'
  end
  object lblDateTime: TLabel [1]
    Left = 47
    Top = 173
    Width = 137
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taRightJustify
    Caption = 'Date/Time of Note:'
  end
  object lblAuthor: TLabel [2]
    Left = 129
    Top = 205
    Width = 55
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taRightJustify
    Caption = 'Author:'
  end
  object lblCosigner: TLabel [3]
    Left = 48
    Top = 239
    Width = 136
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taRightJustify
    Caption = 'Expected Cosigner:'
  end
  object lblProcSummCode: TLabel [4]
    Left = 520
    Top = 169
    Width = 185
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Procedure Summary Code'
    Transparent = False
  end
  object lblProcDateTime: TLabel [5]
    Left = 520
    Top = 218
    Width = 150
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Procedure Date/Time'
    Transparent = False
  end
  object cboNewTitle: TORComboBox [6]
    Left = 193
    Top = 14
    Width = 445
    Height = 147
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight]
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Progress Note Title'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 19
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
  object calNote: TORDateBox [7]
    Left = 193
    Top = 169
    Width = 175
    Height = 27
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 1
    OnEnter = calNoteEnter
    DateOnly = False
    RequireTime = True
    Caption = 'Date/Time of Note:'
  end
  object cboAuthor: TORComboBox [8]
    Left = 193
    Top = 204
    Width = 292
    Height = 27
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Author'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 19
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
    Left = 193
    Top = 236
    Width = 292
    Height = 27
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Expected Cosigner:'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 19
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
    Left = 655
    Top = 14
    Width = 90
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akTop, akRight]
    Caption = 'OK'
    Default = True
    TabOrder = 8
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [11]
    Left = 655
    Top = 48
    Width = 90
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 9
    OnClick = cmdCancelClick
  end
  object cboProcSummCode: TORComboBox [12]
    Left = 520
    Top = 188
    Width = 200
    Height = 27
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
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
    ItemHeight = 19
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
    Left = 520
    Top = 236
    Width = 200
    Height = 27
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 5
    OnEnter = calNoteEnter
    DateOnly = False
    RequireTime = True
    Caption = 'Procedure Date/Time'
  end
  object pnlConsults: TPanel [14]
    Tag = 1
    Left = 0
    Top = 459
    Width = 758
    Height = 211
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    Visible = False
    object bvlConsult: TBevel
      Tag = 1
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 750
      Height = 2
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
    end
    object pnlCTop: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 14
      Width = 750
      Height = 51
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object pnlCButtons: TPanel
        Left = 489
        Top = 0
        Width = 261
        Height = 51
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object btnShowList: TButton
          Left = 13
          Top = 13
          Width = 125
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show Unresolved'
          TabOrder = 0
          OnClick = btnShowListClick
        end
        object btnDetails: TButton
          Left = 143
          Top = 13
          Width = 110
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Show Details'
          TabOrder = 1
          OnClick = btnDetailsClick
        end
      end
      object pnlCText: TPanel
        Left = 0
        Top = 0
        Width = 489
        Height = 51
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object lblConsult1: TLabel
          Tag = 1
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 483
          Height = 19
          Margins.Bottom = 0
          Align = alTop
          Caption = 
            'This progress note title must be associated with a consult reque' +
            'st.'
          Layout = tlCenter
          ExplicitWidth = 467
        end
        object lblConsult2: TLabel
          Tag = 1
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 483
          Height = 23
          Align = alClient
          Caption = 'Select one of the following or choose a different title.'
          ExplicitTop = 21
          ExplicitWidth = 375
          ExplicitHeight = 19
        end
      end
    end
    object lstRequests: TCaptionListView
      AlignWithMargins = True
      Left = 3
      Top = 72
      Width = 752
      Height = 136
      Align = alClient
      Columns = <
        item
          Caption = 'Consult Request Date'
          Width = 175
        end
        item
          AutoSize = True
          Caption = 'Service'
          Tag = 1
        end
        item
          AutoSize = True
          Caption = 'Procedure'
          Tag = 2
        end
        item
          Caption = 'Status'
          Width = 75
        end
        item
          Caption = '# Notes'
          Width = 75
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
      HideTinyColumns = False
    end
  end
  object pnlPRF: TORAutoPanel [15]
    Tag = 3
    Left = 0
    Top = 670
    Width = 758
    Height = 191
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 7
    Visible = False
    object lblPRF: TLabel
      Tag = 1
      AlignWithMargins = True
      Left = 4
      Top = 14
      Width = 750
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Which Patient Record Flag Action should this Note be linked to?'
      ExplicitWidth = 450
    end
    object Bevel1: TBevel
      Tag = 1
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 750
      Height = 2
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
    end
    object lvPRF: TCaptionListView
      AlignWithMargins = True
      Left = 4
      Top = 41
      Width = 750
      Height = 146
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
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
      Constraints.MinHeight = 63
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      AutoSize = False
      HideTinyColumns = True
    end
  end
  object pnlSurgery: TPanel [16]
    Tag = 2
    AlignWithMargins = True
    Left = 4
    Top = 263
    Width = 750
    Height = 192
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 12
    Visible = False
    object bvlSurgery: TBevel
      Tag = 2
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 744
      Height = 2
      Align = alTop
      ExplicitWidth = 745
    end
    object lblSurgery1: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 3
      Top = 11
      Width = 744
      Height = 23
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
      Top = 34
      Width = 744
      Height = 23
      Margins.Top = 0
      Align = alTop
      Alignment = taCenter
      Caption = 
        'Select one of the following or press cancel and choose a differe' +
        'nt title.'
      TabOrder = 1
    end
    object lstSurgery: TCaptionListView
      AlignWithMargins = True
      Left = 3
      Top = 63
      Width = 744
      Height = 126
      Align = alClient
      Columns = <
        item
          Caption = 'Surgery Date'
          Width = 175
        end
        item
          AutoSize = True
          Caption = 'Procedure'
          Tag = 1
        end
        item
          AutoSize = True
          Caption = 'Surgeon'
          Tag = 2
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
      HideTinyColumns = False
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 24
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
