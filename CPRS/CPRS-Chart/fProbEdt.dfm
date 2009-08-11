inherited frmdlgProb: TfrmdlgProb
  Left = 148
  Top = 108
  HelpContext = 2000
  BorderIcons = []
  Caption = 'frmdlgProb'
  ClientHeight = 358
  ClientWidth = 496
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
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
    Width = 496
    Height = 131
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 5
    DesignSize = (
      496
      131)
    object Bevel1: TBevel
      Left = 7
      Top = 3
      Width = 484
      Height = 128
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
      Left = 178
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
      Left = 385
      Top = 10
      Width = 100
      Height = 22
      Hint = 'Remove selected comment'
      Anchors = [akTop, akRight]
      Caption = 'Remove comment'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = bbRemoveClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
    object lstComments: TORListBox
      Left = 10
      Top = 38
      Width = 477
      Height = 85
      Anchors = [akLeft, akTop, akRight, akBottom]
      ExtendedSelect = False
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Caption = 'Comments'
      ItemTipColor = clWindow
      LongList = True
      Pieces = '1,2'
      TabPositions = '1,12'
      OnChange = ControlChange
    end
    object bbEdit: TBitBtn
      Left = 281
      Top = 10
      Width = 100
      Height = 22
      Hint = 'Edit selected comment'
      Anchors = [akTop, akRight]
      Caption = 'Edit comment'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = bbEditClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
  end
  object pnlBottom: TPanel [4]
    Left = 0
    Top = 331
    Width = 496
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      496
      27)
    object bbQuit: TBitBtn
      Left = 299
      Top = 4
      Width = 78
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      OnClick = bbQuitClick
      Layout = blGlyphBottom
      NumGlyphs = 2
    end
    object bbFile: TBitBtn
      Left = 381
      Top = 4
      Width = 78
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
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
      TabOrder = 2
      Visible = False
    end
    object edRecDate: TCaptionEdit
      Left = 145
      Top = 7
      Width = 94
      Height = 21
      TabStop = False
      Color = clInactiveCaptionText
      Enabled = False
      TabOrder = 3
      Text = 'Today'
      Visible = False
      OnChange = ControlChange
      Caption = 'Rec Date'
    end
  end
  object edResDate: TCaptionEdit [5]
    Left = 66
    Top = 365
    Width = 94
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
  object edUpdate: TCaptionEdit [6]
    Left = 67
    Top = 376
    Width = 94
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
  object pnlTop: TPanel [7]
    Left = 0
    Top = 0
    Width = 496
    Height = 200
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
    DesignSize = (
      496
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
      TabOrder = 0
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
      TabOrder = 1
      TabStop = True
      OnClick = ControlChange
    end
    object bbChangeProb: TBitBtn
      Left = 318
      Top = 18
      Width = 124
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Change problem...'
      TabOrder = 2
      OnClick = bbChangeProbClick
      Layout = blGlyphBottom
    end
    object edProb: TCaptionEdit
      Left = 9
      Top = 19
      Width = 296
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 3
      Text = 'Problem Title'
      OnChange = ControlChange
      Caption = 'Activity'
    end
    object gbTreatment: TGroupBox
      Left = 310
      Top = 58
      Width = 181
      Height = 142
      Anchors = [akTop, akRight]
      Caption = 'Treatment Factors'
      TabOrder = 5
      DesignSize = (
        181
        142)
      object ckSC: TCheckBox
        Left = 7
        Top = 15
        Width = 160
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Service Connected '
        Enabled = False
        TabOrder = 0
        OnClick = ControlChange
      end
      object ckRad: TCheckBox
        Left = 7
        Top = 50
        Width = 154
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Radiation '
        Enabled = False
        TabOrder = 1
        OnClick = ControlChange
      end
      object ckAO: TCheckBox
        Left = 7
        Top = 32
        Width = 154
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Agent Orange '
        Enabled = False
        TabOrder = 2
        OnClick = ControlChange
      end
      object ckENV: TCheckBox
        Left = 7
        Top = 68
        Width = 149
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Southwest &Asia Conditions'
        Enabled = False
        TabOrder = 3
        OnClick = ControlChange
      end
      object ckHNC: TCheckBox
        Left = 7
        Top = 119
        Width = 149
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Head and/or Neck Cancer'
        Enabled = False
        TabOrder = 4
        OnClick = ControlChange
      end
      object ckMST: TCheckBox
        Left = 7
        Top = 102
        Width = 149
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'MST'
        Enabled = False
        TabOrder = 5
        OnClick = ControlChange
      end
      object ckSHAD: TCheckBox
        Left = 7
        Top = 85
        Width = 170
        Height = 17
        Caption = 'Shipboard Hazard and Defense'
        TabOrder = 6
      end
    end
    object cbServ: TORComboBox
      Left = 186
      Top = 166
      Width = 113
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
      TabOrder = 6
      Visible = False
      OnChange = ControlChange
      OnNeedData = cbServNeedData
      CharsNeedMatch = 1
    end
    object cbLoc: TORComboBox
      Left = 186
      Top = 166
      Width = 113
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
      TabOrder = 7
      OnChange = ControlChange
      OnClick = cbLocClick
      OnKeyPress = cbLocKeyPress
      OnNeedData = cbLocNeedData
      CharsNeedMatch = 1
    end
    object cbProv: TORComboBox
      Left = 186
      Top = 122
      Width = 113
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
      TabOrder = 8
      OnChange = ControlChange
      OnClick = cbProvClick
      OnKeyPress = cbProvKeyPress
      OnNeedData = cbProvNeedData
      CharsNeedMatch = 1
    end
    object edOnsetdate: TCaptionEdit
      Left = 187
      Top = 79
      Width = 113
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 9
      Text = 'Today'
      OnChange = ControlChange
      Caption = 'Date of Onset'
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlComments'
        'Status = stsDefault')
      (
        'Component = lblCom'
        'Status = stsDefault')
      (
        'Component = bbAdd'
        'Status = stsDefault')
      (
        'Component = bbRemove'
        'Status = stsDefault')
      (
        'Component = lstComments'
        'Status = stsDefault')
      (
        'Component = bbEdit'
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
        'Component = gbTreatment'
        'Status = stsDefault')
      (
        'Component = ckSC'
        'Status = stsDefault')
      (
        'Component = ckRad'
        'Status = stsDefault')
      (
        'Component = ckAO'
        'Status = stsDefault')
      (
        'Component = ckENV'
        'Status = stsDefault')
      (
        'Component = ckHNC'
        'Status = stsDefault')
      (
        'Component = ckMST'
        'Status = stsDefault')
      (
        'Component = ckSHAD'
        'Status = stsDefault')
      (
        'Component = cbServ'
        'Status = stsDefault')
      (
        'Component = cbLoc'
        'Status = stsDefault')
      (
        'Component = cbProv'
        'Status = stsDefault')
      (
        'Component = edOnsetdate'
        'Status = stsDefault')
      (
        'Component = frmdlgProb'
        'Status = stsDefault'))
  end
end
