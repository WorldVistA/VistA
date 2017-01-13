inherited frmdlgProb: TfrmdlgProb
  Left = 148
  Top = 108
  HelpContext = 2000
  BorderIcons = []
  Caption = 'frmdlgProb'
  ClientHeight = 444
  ClientWidth = 722
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 738
  ExplicitHeight = 479
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 6
    Top = 357
    Width = 47
    Height = 13
    Caption = 'Recorded'
    Visible = False
  end
  object Label5: TLabel [1]
    Left = 4
    Top = 368
    Width = 45
    Height = 13
    Caption = 'Resolved'
    Visible = False
  end
  object Label7: TLabel [2]
    Left = 8
    Top = 382
    Width = 41
    Height = 13
    Caption = 'Updated'
    Visible = False
  end
  object pnlComments: TPanel [3]
    Left = 0
    Top = 217
    Width = 722
    Height = 199
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      722
      199)
    object Bevel1: TBevel
      Left = 3
      Top = 1
      Width = 710
      Height = 199
      Anchors = [akLeft, akTop, akRight, akBottom]
      ExplicitWidth = 482
      ExplicitHeight = 166
    end
    object lstComments: TCaptionListView
      AlignWithMargins = True
      Left = 8
      Top = 44
      Width = 706
      Height = 152
      Margins.Left = 8
      Margins.Right = 8
      Align = alClient
      Columns = <
        item
          Caption = 'Comment Date'
          Width = 100
        end
        item
          Caption = 'Comment'
          Tag = 1
          Width = 200
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
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 722
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        722
        41)
      object bbAdd: TBitBtn
        Left = 394
        Top = 10
        Width = 100
        Height = 22
        Hint = 'Add a new comment'
        Anchors = [akTop, akRight]
        Caption = 'Add comment'
        Layout = blGlyphBottom
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = bbAddComClick
      end
      object bbEdit: TBitBtn
        Left = 500
        Top = 10
        Width = 100
        Height = 22
        Hint = 'Edit selected comment'
        Anchors = [akTop, akRight]
        Caption = 'Edit comment'
        Enabled = False
        Layout = blGlyphBottom
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = bbEditClick
      end
      object bbRemove: TBitBtn
        Left = 606
        Top = 10
        Width = 100
        Height = 22
        Hint = 'Remove selected comment'
        Anchors = [akTop, akRight]
        Caption = 'Remove comment'
        Enabled = False
        Layout = blGlyphBottom
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = bbRemoveClick
      end
    end
  end
  object pnlBottom: TPanel [4]
    Left = 0
    Top = 416
    Width = 722
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      722
      28)
    object bbQuit: TBitBtn
      Left = 635
      Top = 4
      Width = 78
      Height = 21
      Hint = 'Cancel problem update...'
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      Layout = blGlyphBottom
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 3
      OnClick = bbQuitClick
    end
    object bbFile: TBitBtn
      Left = 549
      Top = 4
      Width = 78
      Height = 21
      Hint = 'Submit problem update...'
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Layout = blGlyphBottom
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 2
      OnClick = bbFileClick
    end
    object ckVerify: TCheckBox
      Left = 15
      Top = 7
      Width = 130
      Height = 15
      TabStop = False
      Caption = 'Problem Verified'
      TabOrder = 0
      Visible = False
    end
    object edRecDate: TCaptionEdit
      Left = 151
      Top = 6
      Width = 94
      Height = 21
      TabStop = False
      Color = clInactiveCaptionText
      Enabled = False
      TabOrder = 1
      Text = 'Today'
      Visible = False
      OnChange = ControlChange
      Caption = 'Rec Date'
    end
  end
  object edResDate: TCaptionEdit [5]
    Left = 151
    Top = 422
    Width = 94
    Height = 21
    TabStop = False
    Color = clInactiveCaptionText
    Enabled = False
    TabOrder = 2
    Text = 'Today'
    Visible = False
    OnChange = ControlChange
    Caption = 'Res Date'
  end
  object edUpdate: TCaptionEdit [6]
    Left = 151
    Top = 422
    Width = 94
    Height = 21
    TabStop = False
    Color = clInactiveCaptionText
    Enabled = False
    TabOrder = 3
    Text = 'Today'
    Visible = False
    OnChange = ControlChange
    Caption = 'Update'
  end
  object pnlTop: TPanel [7]
    Left = 0
    Top = 0
    Width = 722
    Height = 217
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 722
      Height = 51
      Align = alTop
      TabOrder = 0
      DesignSize = (
        722
        51)
      object lblAct: TLabel
        Left = 12
        Top = 4
        Width = 34
        Height = 13
        Caption = 'Activity'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object bbChangeProb: TBitBtn
        Left = 544
        Top = 18
        Width = 124
        Height = 21
        Anchors = [akTop, akRight]
        Caption = 'Change problem...'
        Layout = blGlyphBottom
        TabOrder = 1
        OnClick = bbChangeProbClick
      end
      object edProb: TCaptionEdit
        Left = 9
        Top = 19
        Width = 522
        Height = 21
        Hint = 'Problem Name'
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 0
        Text = 'Problem Title'
        OnChange = ControlChange
        Caption = 'Activity'
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 51
      Width = 464
      Height = 166
      Align = alClient
      TabOrder = 1
      DesignSize = (
        464
        166)
      object Label3: TLabel
        Left = 185
        Top = 74
        Width = 70
        Height = 13
        Caption = 'Resp Provider:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 185
        Top = 28
        Width = 69
        Height = 13
        Caption = 'Date of Onset:'
      end
      object lblLoc: TLabel
        Left = 185
        Top = 120
        Width = 28
        Height = 13
        Caption = 'Clinic:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object cbLoc: TORComboBox
        Left = 185
        Top = 139
        Width = 268
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
        AutoSelect = True
        Caption = ''
        Color = clWindow
        DropDownCount = 8
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = True
        LookupPiece = 0
        MaxLength = 0
        ParentFont = False
        Pieces = '2'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 5
        Text = ''
        OnChange = ControlChange
        OnClick = cbLocClick
        OnKeyPress = cbLocKeyPress
        OnNeedData = cbLocNeedData
        CharsNeedMatch = 1
      end
      object cbProv: TORComboBox
        Left = 186
        Top = 93
        Width = 267
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Resp Provider'
        Color = clWindow
        DropDownCount = 8
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = True
        LookupPiece = 2
        MaxLength = 0
        ParentFont = False
        Pieces = '2,3'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 3
        Text = ''
        OnChange = ControlChange
        OnClick = cbProvClick
        OnKeyPress = cbProvKeyPress
        OnNeedData = cbProvNeedData
        CharsNeedMatch = 1
      end
      object cbServ: TORComboBox
        Left = 186
        Top = 139
        Width = 267
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Service:'
        Color = clWindow
        DropDownCount = 8
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = True
        LookupPiece = 0
        MaxLength = 0
        ParentFont = False
        Pieces = '2'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 4
        Text = ''
        Visible = False
        OnChange = ControlChange
        OnNeedData = cbServNeedData
        CharsNeedMatch = 1
      end
      object edOnsetdate: TCaptionEdit
        Tag = 3
        Left = 187
        Top = 47
        Width = 266
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        Text = 'Today'
        OnChange = ControlChange
        Caption = 'Date of Onset'
      end
      object rgStage: TKeyClickRadioGroup
        Left = 92
        Top = 25
        Width = 87
        Height = 136
        Caption = 'Immediacy'
        Ctl3D = True
        ItemIndex = 2
        Items.Strings = (
          'Acute'
          'Chronic'
          '<unknown>')
        ParentCtl3D = False
        TabOrder = 1
        TabStop = True
        OnClick = ControlChange
      end
      object rgStatus: TKeyClickRadioGroup
        Left = 9
        Top = 25
        Width = 81
        Height = 136
        Caption = 'Status'
        ItemIndex = 0
        Items.Strings = (
          'Active'
          'Inactive')
        TabOrder = 0
        TabStop = True
        OnClick = rgStatusClick
        OnEnter = rgStatusEnter
      end
    end
    object ScrollBox1: TScrollBox
      Left = 464
      Top = 51
      Width = 258
      Height = 166
      Align = alRight
      TabOrder = 2
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 254
        Height = 159
        Align = alTop
        AutoSize = True
        TabOrder = 0
        object gbTreatment: TGroupBox
          Left = 1
          Top = 1
          Width = 252
          Height = 157
          Align = alClient
          Caption = 'Treatment Factors'
          TabOrder = 0
          object lblYN: TLabel
            Left = 3
            Top = 12
            Width = 35
            Height = 13
            Caption = 'Yes No'
          end
          object ckNSC: TCheckBox
            Left = 24
            Top = 26
            Width = 160
            Height = 17
            Caption = 'Service Connected '
            Enabled = False
            TabOrder = 1
            OnClick = ckNSCClick
          end
          object ckNRad: TCheckBox
            Left = 24
            Top = 58
            Width = 154
            Height = 17
            Caption = 'Radiation '
            Enabled = False
            TabOrder = 5
            OnClick = ckNSCClick
          end
          object ckNAO: TCheckBox
            Left = 24
            Top = 42
            Width = 154
            Height = 17
            Caption = 'Agent Orange '
            Enabled = False
            TabOrder = 3
            OnClick = ckNSCClick
          end
          object ckNENV: TCheckBox
            Left = 24
            Top = 74
            Width = 149
            Height = 17
            Caption = 'Southwest Asia Conditions'
            Enabled = False
            TabOrder = 7
            OnClick = ckNSCClick
          end
          object ckNHNC: TCheckBox
            Left = 24
            Top = 122
            Width = 149
            Height = 17
            Caption = 'Head and/or Neck Cancer'
            Enabled = False
            TabOrder = 13
            OnClick = ckNSCClick
          end
          object ckNMST: TCheckBox
            Left = 24
            Top = 106
            Width = 149
            Height = 17
            Caption = 'MST'
            Enabled = False
            TabOrder = 11
            OnClick = ckNSCClick
          end
          object ckNSHAD: TCheckBox
            Left = 24
            Top = 90
            Width = 170
            Height = 17
            Caption = 'Shipboard Hazard and Defense'
            Enabled = False
            TabOrder = 9
            OnClick = ckNSCClick
          end
          object ckYSC: TCheckBox
            Left = 6
            Top = 26
            Width = 17
            Height = 17
            Enabled = False
            TabOrder = 0
            OnClick = ckNSCClick
          end
          object ckYAO: TCheckBox
            Left = 6
            Top = 42
            Width = 17
            Height = 17
            Enabled = False
            TabOrder = 2
            OnClick = ckNSCClick
          end
          object ckYRad: TCheckBox
            Left = 6
            Top = 58
            Width = 17
            Height = 17
            Enabled = False
            TabOrder = 4
            OnClick = ckNSCClick
          end
          object ckYENV: TCheckBox
            Left = 6
            Top = 74
            Width = 17
            Height = 17
            Enabled = False
            TabOrder = 6
            OnClick = ckNSCClick
          end
          object ckYSHAD: TCheckBox
            Left = 6
            Top = 90
            Width = 17
            Height = 17
            Enabled = False
            TabOrder = 8
            OnClick = ckNSCClick
          end
          object ckYMST: TCheckBox
            Left = 6
            Top = 106
            Width = 17
            Height = 17
            Enabled = False
            TabOrder = 10
            OnClick = ckNSCClick
          end
          object ckYHNC: TCheckBox
            Left = 6
            Top = 122
            Width = 17
            Height = 17
            Enabled = False
            TabOrder = 12
            OnClick = ckNSCClick
          end
          object ckNCL: TCheckBox
            Left = 24
            Top = 140
            Width = 149
            Height = 17
            Caption = 'Camp Lejeune'
            Enabled = False
            TabOrder = 14
            OnClick = ckNSCClick
          end
          object ckYCL: TCheckBox
            Left = 6
            Top = 140
            Width = 17
            Height = 17
            Enabled = False
            TabOrder = 15
            OnClick = ckNSCClick
          end
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 472
    Data = (
      (
        'Component = pnlComments'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
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
        'Label = Label1'
        'Status = stsOK')
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
        'Component = gbTreatment'
        'Status = stsDefault')
      (
        'Component = ckNSC'
        'Text = Service Connected Condition    No'
        'Status = stsOK')
      (
        'Component = ckNRad'
        'Text = Ionizing Radiation Exposure    No'
        'Status = stsOK')
      (
        'Component = ckNAO'
        'Text = Agent Orange Exposure    No'
        'Status = stsOK')
      (
        'Component = ckNENV'
        'Text = Southwest Asia Conditions     No'
        'Status = stsOK')
      (
        'Component = ckNHNC'
        'Text = Head and/or Neck Cancer    No'
        'Status = stsOK')
      (
        'Component = ckNMST'
        'Text = MST     No'
        'Status = stsOK')
      (
        'Component = ckNSHAD'
        'Text = Shipboard Hazard and Defense     Yes'
        'Status = stsOK')
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
        'Component = ckYSC'
        'Text = Service Connected Condition     Yes'
        'Status = stsOK')
      (
        'Component = ckYAO'
        'Text = Agent Orange Exposure     Yes'
        'Status = stsOK')
      (
        'Component = ckYRad'
        'Text = Ionizing Radiation Exposure     Yes'
        'Status = stsOK')
      (
        'Component = ckYENV'
        'Text = Southwest Asia Conditions     Yes'
        'Status = stsOK')
      (
        'Component = ckYSHAD'
        'Text = Shipboard Hazard and Defense     Yes'
        'Status = stsOK')
      (
        'Component = ckYMST'
        'Text = MST     Yes'
        'Status = stsOK')
      (
        'Component = ckYHNC'
        'Text = Head and/or Neck Cancer    No'
        'Status = stsOK')
      (
        'Component = lstComments'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = bbAdd'
        'Status = stsDefault')
      (
        'Component = bbEdit'
        'Status = stsDefault')
      (
        'Component = bbRemove'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = ScrollBox1'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = ckNCL'
        'Text = Camp Lejeune    No'
        'Status = stsOK')
      (
        'Component = ckYCL'
        'Text = Camp Lejeune    Yes'
        'Status = stsOK'))
  end
end
