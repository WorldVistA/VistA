inherited frmOrderFlag: TfrmOrderFlag
  Left = 334
  Top = 234
  BorderStyle = bsDialog
  Caption = 'Flag Order'
  ClientHeight = 666
  ClientWidth = 474
  Constraints.MinWidth = 480
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 480
  ExplicitHeight = 695
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 635
    Width = 474
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 2
    Visible = False
    object pnlButtons: TPanel
      Left = 320
      Top = 0
      Width = 154
      Height = 31
      Align = alRight
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object cmdCancel: TButton
        AlignWithMargins = True
        Left = 79
        Top = 3
        Width = 72
        Height = 25
        Align = alRight
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 0
      end
      object cmdOK: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 70
        Height = 25
        Align = alClient
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 1
      end
    end
  end
  object pnlCanvas: TPanel [1]
    Left = 0
    Top = 65
    Width = 474
    Height = 570
    Align = alClient
    TabOrder = 1
    object splDetails: TSplitter
      Left = 1
      Top = 109
      Width = 472
      Height = 3
      Cursor = crVSplit
      Align = alTop
      Beveled = True
      ExplicitLeft = 0
      ExplicitTop = 133
      ExplicitWidth = 217
    end
    object pnlComment: TPanel
      Left = 1
      Top = 410
      Width = 472
      Height = 159
      Align = alBottom
      BevelOuter = bvNone
      Constraints.MinHeight = 46
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 4
      Visible = False
      object pnlRecipientsAdd: TPanel
        Left = 0
        Top = 0
        Width = 185
        Height = 159
        Margins.Left = 8
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        Visible = False
        object lblRecipientsAdd: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 3
          Width = 174
          Height = 13
          Margins.Left = 8
          Align = alTop
          Caption = 'Additional Recipients'
          ExplicitWidth = 99
        end
        object orRecipientsAdd: TORListBox
          AlignWithMargins = True
          Left = 8
          Top = 22
          Width = 174
          Height = 134
          Margins.Left = 8
          Align = alClient
          ItemHeight = 13
          MultiSelect = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnDblClick = orRecipientsAddDblClick
          OnKeyDown = orRecipientsAddKeyDown
          Caption = ''
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
        end
      end
      object pnlCommentSub: TPanel
        Left = 185
        Top = 0
        Width = 287
        Height = 159
        Align = alClient
        TabOrder = 1
        DesignSize = (
          287
          159)
        object lblComment: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 279
          Height = 13
          Align = alTop
          Caption = '&Comment'
          ExplicitWidth = 44
        end
        object cbRequiredComment: TCheckBox
          Left = 203
          Top = 5
          Width = 75
          Height = 24
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = 'Required'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Visible = False
          OnClick = cbRequiredCommentClick
        end
        object memComment: TMemo
          AlignWithMargins = True
          Left = 4
          Top = 50
          Width = 279
          Height = 105
          Align = alClient
          TabOrder = 1
          OnChange = memCommentChange
        end
        object txtComment: TCaptionEdit
          AlignWithMargins = True
          Left = 4
          Top = 23
          Width = 279
          Height = 21
          Align = alTop
          Ctl3D = True
          MaxLength = 240
          ParentCtl3D = False
          TabOrder = 2
          OnChange = txtCommentChange
          Caption = ''
        end
      end
    end
    object pnlNoActionAlert: TPanel
      Left = 1
      Top = 342
      Width = 472
      Height = 68
      Align = alBottom
      BevelOuter = bvNone
      Constraints.MinHeight = 68
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 3
      OnResize = pnlNoActionAlertResize
      DesignSize = (
        472
        68)
      object lblNoActionAlert: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 3
        Width = 456
        Height = 13
        Margins.Left = 8
        Margins.Right = 8
        Align = alTop
        Caption = '&No Action Alert'
        ExplicitWidth = 71
      end
      object cbCreateNoActionAlert: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 22
        Width = 456
        Height = 18
        Margins.Left = 8
        Margins.Right = 8
        Align = alTop
        Caption = 'Create a No Action Alert'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = cbCreateNoActionAlertClick
      end
      object cbNoActionRequired: TCheckBox
        Left = 389
        Top = -2
        Width = 75
        Height = 18
        Alignment = taLeftJustify
        Anchors = [akTop, akRight]
        Caption = 'Required'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Visible = False
        OnClick = cbNoActionRequiredClick
      end
      object dtFlagExpire: TORDateBox
        AlignWithMargins = True
        Left = 8
        Top = 46
        Width = 456
        Height = 21
        Margins.Left = 8
        Margins.Right = 8
        Align = alTop
        Ctl3D = True
        Enabled = False
        ParentCtl3D = False
        TabOrder = 2
        DateOnly = False
        RequireTime = True
        Caption = 'No Action Alert Flag Expiration Date'
      end
    end
    object pnlRecipients: TPanel
      Left = 1
      Top = 164
      Width = 472
      Height = 178
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinHeight = 132
      TabOrder = 2
      OnResize = pnlRecipientsResize
      DesignSize = (
        472
        178)
      object lblRecipients: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 3
        Width = 456
        Height = 13
        Margins.Left = 8
        Margins.Right = 8
        Align = alTop
        Caption = 'Flag Notification &Recipients'
        ExplicitWidth = 129
      end
      object cbRecipientsRequired: TCheckBox
        Left = 389
        Top = -1
        Width = 77
        Height = 17
        Alignment = taLeftJustify
        Anchors = [akTop, akRight]
        Caption = 'Required'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 0
        Visible = False
        OnClick = cbRecipientsRequiredClick
      end
      object pnlRecipientsSub: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 22
        Width = 459
        Height = 153
        Margins.Left = 5
        Margins.Right = 8
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object pnlListButtons: TPanel
          Left = 185
          Top = 0
          Width = 84
          Height = 153
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          object sbDebug: TSpeedButton
            AlignWithMargins = True
            Left = 0
            Top = 96
            Width = 84
            Height = 25
            Margins.Left = 0
            Margins.Right = 0
            Align = alTop
            Caption = 'Debug'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Visible = False
            OnClick = sbDebugClick
            ExplicitWidth = 81
          end
          object btnAddRecipient: TButton
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 84
            Height = 25
            Margins.Left = 0
            Margins.Right = 0
            Action = acRecipientAdd
            Align = alTop
            TabOrder = 0
          end
          object btnRemoveAllRecipients: TButton
            AlignWithMargins = True
            Left = 0
            Top = 65
            Width = 84
            Height = 25
            Margins.Left = 0
            Margins.Right = 0
            Action = acRecipientRemoveAll
            Align = alTop
            TabOrder = 2
          end
          object btnRemoveRecipients: TButton
            AlignWithMargins = True
            Left = 0
            Top = 34
            Width = 84
            Height = 25
            Margins.Left = 0
            Margins.Right = 0
            Action = acRecipientRemove
            Align = alTop
            TabOrder = 1
          end
        end
        object pnlRecipientsList: TPanel
          Left = 269
          Top = 0
          Width = 190
          Height = 153
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          OnResize = pnlRecipientsListResize
          object orSelectedRecipients: TORListBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 184
            Height = 147
            Align = alClient
            ItemHeight = 13
            MultiSelect = True
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = orSelectedRecipientsClick
            OnDblClick = orSelectedRecipientsDblClick
            OnEnter = orSelectedRecipientsEnter
            OnKeyPress = orSelectedRecipientsKeyPress
            Caption = ''
            ItemTipColor = clWindow
            LongList = False
            Pieces = '2,3'
          end
        end
        object pnlRecipientsSource: TPanel
          Left = 0
          Top = 0
          Width = 185
          Height = 153
          Align = alLeft
          BevelOuter = bvNone
          Constraints.MinWidth = 185
          TabOrder = 0
          object cboAlertRecipient: TORComboBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 179
            Height = 147
            Style = orcsSimple
            Align = alClient
            AutoSelect = True
            Caption = ''
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
            OnChange = cboAlertRecipientChange
            OnDblClick = cboAlertRecipientDblClick
            OnEnter = cboAlertRecipientEnter
            OnKeyDown = cboAlertRecipientKeyDown
            OnNeedData = cboAlertRecipientNeedData
            CharsNeedMatch = 1
            UniqueAutoComplete = True
          end
        end
      end
    end
    object pnlReason: TPanel
      Left = 1
      Top = 112
      Width = 472
      Height = 52
      Align = alTop
      BevelOuter = bvNone
      Constraints.MinHeight = 46
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      DesignSize = (
        472
        52)
      object lblReason: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 3
        Width = 456
        Height = 13
        Margins.Left = 8
        Margins.Right = 8
        Align = alTop
        Caption = '&Reason'
        ExplicitWidth = 37
      end
      object cboFlagReason: TORComboBox
        AlignWithMargins = True
        Left = 8
        Top = 22
        Width = 461
        Height = 21
        Margins.Left = 8
        Style = orcsDropDown
        Align = alTop
        AutoSelect = True
        Caption = ''
        Color = clWindow
        Ctl3D = True
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 240
        ParentCtl3D = False
        Pieces = '2'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        Text = ''
        OnChange = cboFlagReasonChange
        CharsNeedMatch = 1
      end
      object cbReasonRequired: TCheckBox
        Left = 389
        Top = -1
        Width = 77
        Height = 17
        Alignment = taLeftJustify
        Anchors = [akTop, akRight]
        Caption = 'Required'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 1
        Visible = False
        OnClick = cbReasonRequiredClick
      end
    end
    object pnlDescription: TPanel
      Left = 1
      Top = 1
      Width = 472
      Height = 108
      Align = alTop
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
      object lblOrderDetails: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 3
        Width = 456
        Height = 13
        Margins.Left = 8
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        Caption = '&Order(s) Details'
        ExplicitWidth = 72
      end
      object mmOrder: TMemo
        AlignWithMargins = True
        Left = 8
        Top = 24
        Width = 456
        Height = 76
        Hint = 'Selected flag(s) description'
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clCream
        Ctl3D = False
        ParentCtl3D = False
        ParentShowHint = False
        ReadOnly = True
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 0
        WantReturns = False
        OnEnter = mmOrderEnter
      end
    end
  end
  object pnlInstructions: TPanel [2]
    Left = 0
    Top = 0
    Width = 474
    Height = 65
    Align = alTop
    Alignment = taLeftJustify
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    Visible = False
    object mmInstructions: TMemo
      AlignWithMargins = True
      Left = 9
      Top = 1
      Width = 456
      Height = 55
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      WordWrap = False
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 24
    Top = 8
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = pnlCanvas'
        'Status = stsDefault')
      (
        'Component = pnlComment'
        'Status = stsDefault')
      (
        'Component = cbRequiredComment'
        'Status = stsDefault')
      (
        'Component = txtComment'
        'Label = lblComment'
        'Status = stsOK')
      (
        'Component = memComment'
        'Status = stsDefault')
      (
        'Component = orRecipientsAdd'
        'Label = lblRecipientsAdd'
        'Status = stsOK')
      (
        'Component = pnlNoActionAlert'
        'Status = stsDefault')
      (
        'Component = cbNoActionRequired'
        'Status = stsDefault')
      (
        'Component = dtFlagExpire'
        'Label = lblNoActionAlert'
        'Status = stsOK')
      (
        'Component = cbCreateNoActionAlert'
        'Status = stsDefault')
      (
        'Component = pnlRecipients'
        'Status = stsDefault')
      (
        'Component = pnlRecipientsList'
        'Status = stsDefault')
      (
        'Component = orSelectedRecipients'
        'Text = Flag Order Recipients'#13#10
        'Status = stsOK')
      (
        'Component = pnlListButtons'
        'Status = stsDefault')
      (
        'Component = btnAddRecipient'
        'Status = stsDefault')
      (
        'Component = btnRemoveAllRecipients'
        'Status = stsDefault')
      (
        'Component = btnRemoveRecipients'
        'Status = stsDefault')
      (
        'Component = pnlRecipientsSource'
        'Status = stsDefault')
      (
        'Component = cboAlertRecipient'
        'Label = lblRecipients'
        'Status = stsOK')
      (
        'Component = cbRecipientsRequired'
        'Status = stsDefault')
      (
        'Component = pnlReason'
        'Status = stsDefault')
      (
        'Component = cboFlagReason'
        'Label = lblReason'
        'Status = stsOK')
      (
        'Component = cbReasonRequired'
        'Status = stsDefault')
      (
        'Component = pnlDescription'
        'Status = stsDefault')
      (
        'Component = mmOrder'
        'Label = lblOrderDetails'
        'Status = stsOK')
      (
        'Component = pnlInstructions'
        'Status = stsDefault')
      (
        'Component = mmInstructions'
        'Status = stsDefault')
      (
        'Component = frmOrderFlag'
        'Status = stsDefault')
      (
        'Component = pnlRecipientsSub'
        'Status = stsDefault')
      (
        'Component = pnlRecipientsAdd'
        'Status = stsDefault')
      (
        'Component = pnlCommentSub'
        'Status = stsDefault'))
  end
  object alEditorActions: TActionList
    Left = 80
    Top = 8
    object acFlagRemove: TAction
      Caption = 'Remove Flag'
    end
    object acFlagComment: TAction
      Caption = 'Add Comment'
    end
    object acFlagSet: TAction
      Caption = 'Set Flag'
      OnExecute = acFlagSetExecute
    end
    object acRecipientAdd: TAction
      Caption = '&Add'
      Hint = 'Add selected recipient'
      OnExecute = acRecipientAddExecute
    end
    object acRecipientRemoveAll: TAction
      Caption = 'Remove A&ll'
      Hint = 'Remove all recipients'
      OnExecute = acRecipientRemoveAllExecute
    end
    object acRecipientSelect: TAction
      Caption = 'Add &Recipients'
      OnExecute = acRecipientSelectExecute
    end
    object acRecipientRemove: TAction
      Caption = 'Re&move'
      OnExecute = acRecipientRemoveExecute
    end
  end
end
