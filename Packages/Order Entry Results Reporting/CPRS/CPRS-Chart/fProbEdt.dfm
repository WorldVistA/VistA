inherited frmdlgProb: TfrmdlgProb
  Left = 148
  Top = 108
  HelpContext = 2000
  BorderIcons = []
  Caption = 'frmdlgProb'
  ClientHeight = 555
  ClientWidth = 903
  OldCreateOrder = True
  ExplicitWidth = 921
  ExplicitHeight = 600
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 446
    Width = 61
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Recorded'
    Visible = False
  end
  object Label5: TLabel [1]
    Left = 5
    Top = 460
    Width = 59
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Resolved'
    Visible = False
  end
  object Label7: TLabel [2]
    Left = 10
    Top = 478
    Width = 53
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Updated'
    Visible = False
  end
  object pnlComments: TPanel [3]
    Left = 0
    Top = 271
    Width = 903
    Height = 249
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 558
    DesignSize = (
      903
      249)
    object Bevel1: TBevel
      Left = 4
      Top = 1
      Width = 887
      Height = 249
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight, akBottom]
    end
    object lstComments: TCaptionListView
      AlignWithMargins = True
      Left = 10
      Top = 55
      Width = 883
      Height = 190
      Margins.Left = 10
      Margins.Top = 4
      Margins.Right = 10
      Margins.Bottom = 4
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
      ExplicitWidth = 542
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 903
      Height = 51
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 558
      DesignSize = (
        903
        51)
      object bbAdd: TBitBtn
        Left = 493
        Top = 13
        Width = 125
        Height = 27
        Hint = 'Add a new comment'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Add comment'
        Layout = blGlyphBottom
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = bbAddComClick
        ExplicitLeft = 230
      end
      object bbEdit: TBitBtn
        Left = 625
        Top = 13
        Width = 125
        Height = 27
        Hint = 'Edit selected comment'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Edit comment'
        Enabled = False
        Layout = blGlyphBottom
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = bbEditClick
        ExplicitLeft = 336
      end
      object bbRemove: TBitBtn
        Left = 758
        Top = 13
        Width = 125
        Height = 27
        Hint = 'Remove selected comment'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Remove comment'
        Enabled = False
        Layout = blGlyphBottom
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = bbRemoveClick
        ExplicitLeft = 442
      end
    end
  end
  object pnlBottom: TPanel [4]
    Left = 0
    Top = 520
    Width = 903
    Height = 35
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitWidth = 558
    DesignSize = (
      903
      35)
    object bbQuit: TBitBtn
      Left = 794
      Top = 5
      Width = 97
      Height = 26
      Hint = 'Cancel problem update...'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      Layout = blGlyphBottom
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 3
      OnClick = bbQuitClick
      ExplicitLeft = 471
    end
    object bbFile: TBitBtn
      Left = 686
      Top = 5
      Width = 98
      Height = 26
      Hint = 'Submit problem update...'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Layout = blGlyphBottom
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 2
      OnClick = bbFileClick
      ExplicitLeft = 385
    end
    object ckVerify: TCheckBox
      Left = 19
      Top = 9
      Width = 162
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabStop = False
      Caption = 'Problem Verified'
      TabOrder = 0
      Visible = False
    end
    object edRecDate: TCaptionEdit
      Left = 189
      Top = 8
      Width = 117
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
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
    Left = 189
    Top = 528
    Width = 117
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
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
    Left = 189
    Top = 528
    Width = 117
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
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
    Width = 903
    Height = 271
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 558
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 903
      Height = 64
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 558
      DesignSize = (
        903
        64)
      object lblAct: TLabel
        Left = 15
        Top = 5
        Width = 42
        Height = 16
        Caption = 'Activity'
        Visible = False
      end
      object bbChangeProb: TBitBtn
        Left = 680
        Top = 23
        Width = 155
        Height = 26
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Change problem...'
        Layout = blGlyphBottom
        TabOrder = 1
        OnClick = bbChangeProbClick
        ExplicitLeft = 380
      end
      object edProb: TCaptionEdit
        Left = 11
        Top = 24
        Width = 653
        Height = 24
        Hint = 'Problem Name'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 0
        Text = 'Problem Title'
        OnChange = ControlChange
        Caption = 'Activity'
        ExplicitWidth = 358
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 64
      Width = 580
      Height = 207
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 331
      DesignSize = (
        580
        207)
      object Label3: TLabel
        Left = 231
        Top = 93
        Width = 90
        Height = 16
        Caption = 'Resp Provider:'
      end
      object Label6: TLabel
        Left = 231
        Top = 35
        Width = 84
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Date of Onset:'
      end
      object lblLoc: TLabel
        Left = 231
        Top = 150
        Width = 35
        Height = 16
        Caption = 'Clinic:'
      end
      object cbLoc: TORComboBox
        Left = 231
        Top = 174
        Width = 335
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
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
        TabOrder = 5
        Text = ''
        OnChange = ControlChange
        OnClick = cbLocClick
        OnKeyPress = cbLocKeyPress
        OnNeedData = cbLocNeedData
        CharsNeedMatch = 1
        ExplicitWidth = 135
      end
      object cbProv: TORComboBox
        Left = 233
        Top = 116
        Width = 333
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
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
        TabOrder = 3
        Text = ''
        OnChange = ControlChange
        OnClick = cbProvClick
        OnKeyPress = cbProvKeyPress
        OnNeedData = cbProvNeedData
        CharsNeedMatch = 1
        ExplicitWidth = 134
      end
      object cbServ: TORComboBox
        Left = 233
        Top = 174
        Width = 333
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
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
        TabOrder = 4
        Text = ''
        Visible = False
        OnChange = ControlChange
        OnNeedData = cbServNeedData
        CharsNeedMatch = 1
        ExplicitWidth = 134
      end
      object edOnsetdate: TCaptionEdit
        Tag = 3
        Left = 234
        Top = 59
        Width = 332
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        Text = 'Today'
        OnChange = ControlChange
        Caption = 'Date of Onset'
        ExplicitWidth = 133
      end
      object rgStage: TKeyClickRadioGroup
        Left = 115
        Top = 31
        Width = 109
        Height = 170
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
        Left = 11
        Top = 31
        Width = 102
        Height = 170
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
      Left = 580
      Top = 64
      Width = 323
      Height = 207
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      TabOrder = 2
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 319
        Height = 203
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        AutoSize = True
        TabOrder = 0
        ExplicitWidth = 199
        object gbTreatment: TGroupBox
          Left = 1
          Top = 1
          Width = 317
          Height = 201
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          Caption = 'Treatment Factors'
          TabOrder = 0
          ExplicitWidth = 197
          object lblYN: TLabel
            Left = 4
            Top = 15
            Width = 45
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Yes No'
          end
          object ckNSC: TCheckBox
            Left = 30
            Top = 33
            Width = 200
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Service Connected '
            Enabled = False
            TabOrder = 1
            OnClick = ckNSCClick
          end
          object ckNRad: TCheckBox
            Left = 30
            Top = 73
            Width = 193
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Radiation '
            Enabled = False
            TabOrder = 5
            OnClick = ckNSCClick
          end
          object ckNAO: TCheckBox
            Left = 30
            Top = 53
            Width = 193
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Agent Orange '
            Enabled = False
            TabOrder = 3
            OnClick = ckNSCClick
          end
          object ckNENV: TCheckBox
            Left = 30
            Top = 93
            Width = 186
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Southwest Asia Conditions'
            Enabled = False
            TabOrder = 7
            OnClick = ckNSCClick
          end
          object ckNHNC: TCheckBox
            Left = 30
            Top = 153
            Width = 186
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Head and/or Neck Cancer'
            Enabled = False
            TabOrder = 13
            OnClick = ckNSCClick
          end
          object ckNMST: TCheckBox
            Left = 30
            Top = 133
            Width = 186
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'MST'
            Enabled = False
            TabOrder = 11
            OnClick = ckNSCClick
          end
          object ckNSHAD: TCheckBox
            Left = 30
            Top = 113
            Width = 213
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Shipboard Hazard and Defense'
            Enabled = False
            TabOrder = 9
            OnClick = ckNSCClick
          end
          object ckYSC: TCheckBox
            Left = 8
            Top = 33
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Enabled = False
            TabOrder = 0
            OnClick = ckNSCClick
          end
          object ckYAO: TCheckBox
            Left = 8
            Top = 53
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Enabled = False
            TabOrder = 2
            OnClick = ckNSCClick
          end
          object ckYRad: TCheckBox
            Left = 8
            Top = 73
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Enabled = False
            TabOrder = 4
            OnClick = ckNSCClick
          end
          object ckYENV: TCheckBox
            Left = 8
            Top = 93
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Enabled = False
            TabOrder = 6
            OnClick = ckNSCClick
          end
          object ckYSHAD: TCheckBox
            Left = 8
            Top = 113
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Enabled = False
            TabOrder = 8
            OnClick = ckNSCClick
          end
          object ckYMST: TCheckBox
            Left = 8
            Top = 133
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Enabled = False
            TabOrder = 10
            OnClick = ckNSCClick
          end
          object ckYHNC: TCheckBox
            Left = 8
            Top = 153
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Enabled = False
            TabOrder = 12
            OnClick = ckNSCClick
          end
          object ckNCL: TCheckBox
            Left = 30
            Top = 175
            Width = 186
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Camp Lejeune'
            Enabled = False
            TabOrder = 14
            OnClick = ckNSCClick
          end
          object ckYCL: TCheckBox
            Left = 8
            Top = 175
            Width = 21
            Height = 21
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
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
