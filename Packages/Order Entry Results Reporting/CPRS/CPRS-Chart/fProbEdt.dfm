inherited frmdlgProb: TfrmdlgProb
  Left = 148
  Top = 108
  HelpContext = 2000
  BorderIcons = []
  Caption = 'frmdlgProb'
  ClientHeight = 394
  ClientWidth = 494
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 502
  ExplicitHeight = 428
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
    Top = 200
    Width = 494
    Height = 166
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      494
      166)
    object Bevel1: TBevel
      Left = 3
      Top = 1
      Width = 482
      Height = 166
      Anchors = [akLeft, akTop, akRight, akBottom]
    end
    object lblCmtDate: TOROffsetLabel
      Left = 10
      Top = 20
      Width = 29
      Height = 15
      Caption = 'Date'
      HorzOffset = 6
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object lblComment: TOROffsetLabel
      Left = 75
      Top = 20
      Width = 50
      Height = 15
      Caption = 'Comment'
      HorzOffset = 6
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object lblCom: TStaticText
      Left = 10
      Top = 6
      Width = 53
      Height = 17
      Caption = 'Comments'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object bbAdd: TBitBtn
      Left = 176
      Top = 10
      Width = 100
      Height = 22
      Hint = 'Add a new comment'
      Anchors = [akTop, akRight]
      Caption = 'Add comment'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = bbAddComClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
    object bbRemove: TBitBtn
      Left = 383
      Top = 10
      Width = 100
      Height = 22
      Hint = 'Remove selected comment'
      Anchors = [akTop, akRight]
      Caption = 'Remove comment'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = bbRemoveClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
    object lstComments: TORListBox
      Left = 10
      Top = 38
      Width = 475
      Height = 120
      Anchors = [akLeft, akTop, akRight, akBottom]
      ExtendedSelect = False
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Caption = 'Comments'
      ItemTipColor = clWindow
      LongList = True
      Pieces = '1,2'
      TabPositions = '1,12'
      OnChange = ControlChange
    end
    object bbEdit: TBitBtn
      Left = 279
      Top = 10
      Width = 100
      Height = 22
      Hint = 'Edit selected comment'
      Anchors = [akTop, akRight]
      Caption = 'Edit comment'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = bbEditClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
  end
  object pnlBottom: TPanel [4]
    Left = 0
    Top = 366
    Width = 494
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      494
      28)
    object bbQuit: TBitBtn
      Left = 407
      Top = 4
      Width = 78
      Height = 21
      Hint = 'Cancel problem update...'
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 3
      OnClick = bbQuitClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
    object bbFile: TBitBtn
      Left = 321
      Top = 4
      Width = 78
      Height = 21
      Hint = 'Submit problem update...'
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 2
      OnClick = bbFileClick
      Layout = blGlyphBottom
      NumGlyphs = 2
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
    Top = 372
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
    Top = 372
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
    Width = 494
    Height = 200
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      494
      200)
    object lblAct: TLabel
      Left = 12
      Top = 4
      Width = 34
      Height = 13
      Caption = 'Activity'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lblLoc: TLabel
      Left = 187
      Top = 149
      Width = 28
      Height = 13
      Caption = 'Clinic:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 187
      Top = 105
      Width = 70
      Height = 13
      Caption = 'Resp Provider:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 187
      Top = 63
      Width = 69
      Height = 13
      Caption = 'Date of Onset:'
    end
    object rgStatus: TKeyClickRadioGroup
      Left = 9
      Top = 64
      Width = 81
      Height = 124
      Caption = 'Status'
      ItemIndex = 0
      Items.Strings = (
        'Active'
        'Inactive')
      TabOrder = 2
      TabStop = True
      OnClick = rgStatusClick
    end
    object rgStage: TKeyClickRadioGroup
      Left = 92
      Top = 64
      Width = 87
      Height = 124
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
    object bbChangeProb: TBitBtn
      Left = 316
      Top = 18
      Width = 124
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Change problem...'
      TabOrder = 1
      OnClick = bbChangeProbClick
      Layout = blGlyphBottom
    end
    object edProb: TCaptionEdit
      Left = 9
      Top = 19
      Width = 294
      Height = 21
      Hint = 'Problem Name'
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 0
      Text = 'Problem Title'
      OnChange = ControlChange
      Caption = 'Activity'
    end
    object gbTreatment: TGroupBox
      Left = 289
      Top = 52
      Width = 196
      Height = 142
      Anchors = [akTop, akRight]
      Caption = 'Treatment Factors'
      TabOrder = 8
      DesignSize = (
        196
        142)
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
        Anchors = [akTop, akRight]
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
        Anchors = [akTop, akRight]
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
        Anchors = [akTop, akRight]
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
        Anchors = [akTop, akRight]
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
        Anchors = [akTop, akRight]
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
        Anchors = [akTop, akRight]
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
    end
    object cbServ: TORComboBox
      Left = 186
      Top = 166
      Width = 97
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Service:'
      Color = clWindow
      DropDownCount = 8
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
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
      TabOrder = 7
      Visible = False
      OnChange = ControlChange
      OnNeedData = cbServNeedData
      CharsNeedMatch = 1
    end
    object cbLoc: TORComboBox
      Left = 185
      Top = 168
      Width = 98
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Style = orcsDropDown
      AutoSelect = True
      Color = clWindow
      DropDownCount = 8
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
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
      TabOrder = 6
      OnChange = ControlChange
      OnClick = cbLocClick
      OnKeyPress = cbLocKeyPress
      OnNeedData = cbLocNeedData
      CharsNeedMatch = 1
    end
    object cbProv: TORComboBox
      Left = 186
      Top = 122
      Width = 97
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Resp Provider'
      Color = clWindow
      DropDownCount = 8
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
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
      TabOrder = 5
      OnChange = ControlChange
      OnClick = cbProvClick
      OnKeyPress = cbProvKeyPress
      OnNeedData = cbProvNeedData
      CharsNeedMatch = 1
    end
    object edOnsetdate: TCaptionEdit
      Left = 187
      Top = 79
      Width = 96
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      Text = 'Today'
      OnChange = ControlChange
      Caption = 'Date of Onset'
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 472
    Data = (
      (
        'Component = pnlComments'
        'Status = stsDefault')
      (
        'Component = lblCom'
        'Status = stsDefault')
      (
        'Component = bbAdd'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = bbRemove'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = lstComments'
        'Property = Caption'
        'Status = stsOK')
      (
        'Component = bbEdit'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = bbQuit'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = bbFile'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = ckVerify'
        'Property = Caption'
        'Status = stsOK')
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
        'Property = Caption'
        'Status = stsOK')
      (
        'Component = rgStage'
        'Property = Caption'
        'Status = stsOK')
      (
        'Component = bbChangeProb'
        'Property = Caption'
        'Status = stsOK')
      (
        'Component = edProb'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = gbTreatment'
        'Property = Caption'
        'Status = stsOK')
      (
        'Component = ckNSC'
        'Status = stsDefault')
      (
        'Component = ckNRad'
        'Status = stsDefault')
      (
        'Component = ckNAO'
        'Status = stsDefault')
      (
        'Component = ckNENV'
        'Status = stsDefault')
      (
        'Component = ckNHNC'
        'Status = stsDefault')
      (
        'Component = ckNMST'
        'Status = stsDefault')
      (
        'Component = ckNSHAD'
        'Status = stsDefault')
      (
        'Component = cbServ'
        'Property = Caption'
        'Status = stsOK')
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
        'Property = Caption'
        'Status = stsOK')
      (
        'Component = frmdlgProb'
        'Status = stsDefault')
      (
        'Component = ckYSC'
        'Status = stsDefault')
      (
        'Component = ckYAO'
        'Status = stsDefault')
      (
        'Component = ckYRad'
        'Status = stsDefault')
      (
        'Component = ckYENV'
        'Status = stsDefault')
      (
        'Component = ckYSHAD'
        'Status = stsDefault')
      (
        'Component = ckYMST'
        'Status = stsDefault')
      (
        'Component = ckYHNC'
        'Status = stsDefault'))
  end
end
