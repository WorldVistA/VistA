inherited frmdlgProb: TfrmdlgProb
  Left = 2
  Top = 2
  HelpContext = 2000
  Align = alClient
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'frmdlgProb'
  ClientHeight = 536
  ClientWidth = 834
  ParentFont = True
  StyleElements = [seFont, seClient, seBorder]
  OldCreateOrder = True
  ExplicitWidth = 834
  ExplicitHeight = 536
  TextHeight = 13
  object edResDate: TCaptionEdit [0]
    Left = 189
    Top = 8
    Width = 117
    Height = 21
    TabStop = False
    Color = clInactiveCaptionText
    Enabled = False
    TabOrder = 0
    Text = 'Today'
    Visible = False
    OnChange = ControlChange
    Caption = 'Res Date'
  end
  object edUpdate: TCaptionEdit [1]
    Left = 189
    Top = 8
    Width = 117
    Height = 21
    TabStop = False
    Color = clInactiveCaptionText
    Enabled = False
    TabOrder = 1
    Text = 'Today'
    Visible = False
    OnChange = ControlChange
    Caption = 'Update'
  end
  object gpMain: TGridPanel [2]
    Left = 0
    Top = 0
    Width = 834
    Height = 536
    Align = alClient
    BevelOuter = bvNone
    Caption = 'gpMain'
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 100.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 120.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 120.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 5
        Control = lblAct
        Row = 0
      end
      item
        Column = 0
        ColumnSpan = 4
        Control = edProb
        Row = 1
      end
      item
        Column = 4
        Control = bbChangeProb
        Row = 1
      end
      item
        Column = 0
        Control = rgStatus
        Row = 3
      end
      item
        Column = 1
        Control = rgStage
        Row = 3
      end
      item
        Column = 2
        ColumnSpan = 3
        Control = pnlTop
        Row = 3
      end
      item
        Column = 0
        ColumnSpan = 5
        Control = pnlComments
        Row = 4
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = ckVerify
        Row = 5
      end
      item
        Column = 3
        Control = bbFile
        Row = 5
      end
      item
        Column = 4
        Control = bbQuit
        Row = 5
      end
      item
        Column = 0
        ColumnSpan = 5
        Control = bvlTop
        Row = 2
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 200.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 30.000000000000000000
      end>
    ShowCaption = False
    TabOrder = 4
    object lblAct: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 3
      Width = 823
      Height = 24
      Margins.Left = 8
      Align = alClient
      Caption = 'Activity'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      Visible = False
      ExplicitWidth = 42
      ExplicitHeight = 16
    end
    object edProb: TCaptionEdit
      AlignWithMargins = True
      Left = 8
      Top = 33
      Width = 698
      Height = 24
      Hint = 'Problem Name'
      Margins.Left = 8
      Margins.Right = 8
      Align = alClient
      ReadOnly = True
      TabOrder = 0
      Text = 'Problem Title'
      OnChange = ControlChange
      Caption = ''
      ExplicitHeight = 21
    end
    object bbChangeProb: TBitBtn
      AlignWithMargins = True
      Left = 722
      Top = 33
      Width = 104
      Height = 24
      Margins.Left = 8
      Margins.Right = 8
      Align = alClient
      Caption = 'Change problem...'
      Layout = blGlyphBottom
      TabOrder = 1
      OnClick = bbChangeProbClick
    end
    object rgStatus: TKeyClickRadioGroup
      AlignWithMargins = True
      Left = 8
      Top = 93
      Width = 89
      Height = 194
      Margins.Left = 8
      Align = alClient
      Caption = 'Status'
      ItemIndex = 0
      Items.Strings = (
        'Active'
        'Inactive')
      TabOrder = 2
      TabStop = True
      OnClick = rgStatusClick
      OnEnter = rgStatusEnter
    end
    object rgStage: TKeyClickRadioGroup
      AlignWithMargins = True
      Left = 103
      Top = 93
      Width = 94
      Height = 194
      Align = alClient
      Caption = 'Immediacy'
      Ctl3D = True
      ItemIndex = 2
      Items.Strings = (
        'Acute'
        'Chronic'
        '<unknown>')
      ParentCtl3D = False
      TabOrder = 3
      TabStop = True
      OnClick = ControlChange
    end
    object pnlTop: TPanel
      AlignWithMargins = True
      Left = 203
      Top = 93
      Width = 623
      Height = 194
      Margins.Right = 8
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 4
      object pnlDetails: TPanel
        Left = 0
        Top = 0
        Width = 421
        Height = 194
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblRespProv: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 49
          Width = 415
          Height = 13
          Align = alTop
          Caption = 'Resp Provider:'
          ExplicitWidth = 70
        end
        object lblOnsetDate: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 415
          Height = 13
          Align = alTop
          Caption = 'Date of Onset:'
          ExplicitWidth = 69
        end
        object lblLoc: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 114
          Width = 415
          Height = 13
          Align = alTop
          Caption = 'Clinic:'
          ExplicitTop = 118
          ExplicitWidth = 28
        end
        object cbLoc: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 160
          Width = 415
          Height = 21
          Style = orcsDropDown
          Align = alTop
          AutoSelect = True
          Caption = ''
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = True
          LookupPiece = 0
          MaxLength = 0
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 3
          Text = ''
          FlatCheckBoxes = False
          OnChange = ControlChange
          OnClick = cbLocClick
          OnKeyPress = cbLocKeyPress
          OnNeedData = cbLocNeedData
          CharsNeedMatch = 1
        end
        object cbServ: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 133
          Width = 415
          Height = 21
          Style = orcsDropDown
          Align = alTop
          AutoSelect = True
          Caption = 'Service:'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = True
          LookupPiece = 0
          MaxLength = 0
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 2
          Text = ''
          Visible = False
          FlatCheckBoxes = False
          OnChange = ControlChange
          OnNeedData = cbServNeedData
          CharsNeedMatch = 1
        end
        object edOnsetdate: TCaptionEdit
          Tag = 3
          AlignWithMargins = True
          Left = 3
          Top = 22
          Width = 415
          Height = 21
          Align = alTop
          TabOrder = 0
          Text = 'Today'
          OnChange = ControlChange
          Caption = 'Date of Onset'
        end
        object cbProv: TORCheckComboBox
          AlignWithMargins = True
          Left = 3
          Top = 68
          Width = 415
          Height = 40
          Style = orcsDropDown
          Align = alTop
          AutoSelect = True
          Caption = 'Resp Provider'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = True
          LookupPiece = 2
          MaxLength = 0
          Pieces = '2,3'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 1
          Text = ''
          FlatCheckBoxes = False
          OnChange = ControlChange
          OnClick = cbProvClick
          OnKeyPress = cbProvKeyPress
          OnNeedData = cbProvNeedData
          CharsNeedMatch = 1
          MainCheckBoxCaption = 'Include Non-VA Providers'
          MainCheckBoxVisible = True
          MainCheckBoxAlignment = calBottom
          OnMainCheckboxClick = cbProvMainCheckboxClick
          DropdownStyle = ddsControl
        end
      end
      inline fraSpecialAuthorities: TfraVisitRelated
        Left = 421
        Top = 0
        Width = 202
        Height = 194
        Align = alRight
        TabOrder = 1
        ExplicitLeft = 421
        ExplicitWidth = 202
        ExplicitHeight = 194
        inherited sbMain: TScrollBox
          Width = 202
          Height = 194
          BevelKind = bkFlat
          BorderStyle = bsSingle
          ExplicitLeft = 3
          ExplicitTop = 2
          ExplicitWidth = 202
          ExplicitHeight = 194
          inherited pnlMain: TPanel
            Width = 194
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 194
            inherited gbVisitRelatedTo: TGroupBox
              Width = 188
              Caption = 'Treatment Factors'
              ExplicitWidth = 188
              inherited gpMain: TGridPanel
                Top = 15
                Width = 178
                Height = 75
                ControlCollection = <
                  item
                    Column = 0
                    Control = fraSpecialAuthorities.lblYes
                    Row = 0
                  end
                  item
                    Column = 1
                    Control = fraSpecialAuthorities.lblNo
                    Row = 0
                  end>
                StyleElements = [seFont, seClient, seBorder]
                ExplicitTop = 15
                ExplicitWidth = 178
                ExplicitHeight = 75
                inherited lblYes: TLabel
                  Top = 2
                  Height = 13
                  StyleElements = [seFont, seClient, seBorder]
                  ExplicitTop = 2
                  ExplicitWidth = 18
                  ExplicitHeight = 13
                end
                inherited lblNo: TLabel
                  Top = 2
                  Width = 155
                  Height = 13
                  StyleElements = [seFont, seClient, seBorder]
                  ExplicitTop = 2
                  ExplicitWidth = 14
                  ExplicitHeight = 13
                end
              end
            end
          end
        end
      end
    end
    object pnlComments: TPanel
      AlignWithMargins = True
      Left = 8
      Top = 293
      Width = 818
      Height = 210
      Margins.Left = 8
      Margins.Right = 8
      Align = alClient
      Anchors = []
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 6
      object lstComments: TCaptionListView
        AlignWithMargins = True
        Left = 3
        Top = 33
        Width = 808
        Height = 170
        Align = alClient
        Columns = <
          item
            Caption = 'Comment Date'
            Width = 125
          end
          item
            Caption = 'Comment'
            Tag = 1
            Width = 250
          end>
        HideSelection = False
        HoverTime = 0
        IconOptions.WrapText = False
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        ShowWorkAreas = True
        ShowHint = True
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lstCommentsChange
        AutoSize = False
        Caption = 'Comments'
        Pieces = '1,2'
        ExplicitTop = 35
        ExplicitHeight = 168
      end
      object pnlButtons: TPanel
        Left = 0
        Top = 0
        Width = 814
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        Caption = 'pnlButtons'
        ShowCaption = False
        TabOrder = 1
        object bbAdd: TBitBtn
          AlignWithMargins = True
          Left = 442
          Top = 3
          Width = 114
          Height = 24
          Hint = 'Add a new comment'
          Margins.Right = 8
          Align = alRight
          Caption = 'Add comment'
          Layout = blGlyphBottom
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = bbAddComClick
          ExplicitHeight = 26
        end
        object bbRemove: TBitBtn
          AlignWithMargins = True
          Left = 692
          Top = 3
          Width = 114
          Height = 24
          Hint = 'Remove selected comment'
          Margins.Right = 8
          Align = alRight
          Caption = 'Remove comment'
          Enabled = False
          Layout = blGlyphBottom
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = bbRemoveClick
          ExplicitHeight = 26
        end
        object bbEdit: TBitBtn
          AlignWithMargins = True
          Left = 567
          Top = 3
          Width = 114
          Height = 24
          Hint = 'Edit selected comment'
          Margins.Right = 8
          Align = alRight
          Caption = 'Edit comment'
          Enabled = False
          Layout = blGlyphBottom
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = bbEditClick
          ExplicitHeight = 26
        end
      end
    end
    object ckVerify: TCheckBox
      AlignWithMargins = True
      Left = 8
      Top = 509
      Width = 583
      Height = 24
      Margins.Left = 8
      TabStop = False
      Align = alClient
      Caption = 'Problem Verified'
      TabOrder = 7
      Visible = False
    end
    object bbFile: TBitBtn
      AlignWithMargins = True
      Left = 602
      Top = 509
      Width = 104
      Height = 24
      Hint = 'Submit problem update...'
      Margins.Left = 8
      Margins.Right = 8
      Align = alClient
      Caption = 'OK'
      Layout = blGlyphBottom
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 8
      OnClick = bbFileClick
    end
    object bbQuit: TBitBtn
      AlignWithMargins = True
      Left = 719
      Top = 509
      Width = 104
      Height = 24
      Hint = 'Cancel problem update...'
      Margins.Left = 5
      Margins.Right = 11
      Align = alClient
      Cancel = True
      Caption = 'Cancel'
      Layout = blGlyphBottom
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 9
      OnClick = bbQuitClick
    end
    object bvlTop: TBevel
      Left = 0
      Top = 60
      Width = 834
      Height = 30
      Align = alClient
      Shape = bsBottomLine
      ExplicitLeft = 352
      ExplicitTop = 72
      ExplicitWidth = 50
      ExplicitHeight = 50
    end
  end
  object edRecDate: TCaptionEdit [3]
    Left = 189
    Top = 8
    Width = 117
    Height = 21
    TabStop = False
    Color = clInactiveCaptionText
    Enabled = False
    TabOrder = 5
    Text = 'Today'
    Visible = False
    OnChange = ControlChange
    Caption = ''
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 624
    Top = 400
    Data = (
      (
        'Component = pnlComments'
        'Status = stsDefault')
      (
        'Component = bbQuit'
        'Status = stsDefault')
      (
        'Component = bbFile'
        'Status = stsDefault')
      (
        'Component = ckVerify'
        'Status = stsDefault')
      (
        'Component = edRecDate'
        'Status = stsDefault')
      (
        'Component = edResDate'
        'Status = stsDefault')
      (
        'Component = edUpdate'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = rgStatus'
        'Status = stsDefault')
      (
        'Component = rgStage'
        'Status = stsDefault')
      (
        'Component = bbChangeProb'
        'Status = stsDefault')
      (
        'Component = edProb'
        'Status = stsDefault')
      (
        'Component = cbServ'
        'Status = stsDefault')
      (
        'Component = cbLoc'
        'Label = lblLoc'
        'Status = stsOK')
      (
        'Component = cbProv'
        'Text = Responsible Provider'
        'Status = stsOK')
      (
        'Component = edOnsetdate'
        'Status = stsDefault')
      (
        'Component = frmdlgProb'
        'Status = stsDefault')
      (
        'Component = pnlDetails'
        'Status = stsDefault')
      (
        'Component = fraSpecialAuthorities'
        'Status = stsDefault')
      (
        'Component = fraSpecialAuthorities.sbMain'
        'Status = stsDefault')
      (
        'Component = fraSpecialAuthorities.pnlMain'
        'Status = stsDefault')
      (
        'Component = fraSpecialAuthorities.gbVisitRelatedTo'
        'Status = stsDefault')
      (
        'Component = fraSpecialAuthorities.gpMain'
        'Status = stsDefault')
      (
        'Component = gpMain'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault'))
  end
end
