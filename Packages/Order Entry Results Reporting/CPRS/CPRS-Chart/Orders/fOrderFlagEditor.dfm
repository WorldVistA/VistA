object frmOrderFlag: TfrmOrderFlag
  Left = 334
  Top = 234
  BorderStyle = bsDialog
  Caption = 'Flag Order'
  ClientHeight = 666
  ClientWidth = 474
  Color = clBtnFace
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
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
  object pnlCanvas: TPanel
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
      object grbComment: TGroupBox
        AlignWithMargins = True
        Left = 196
        Top = 3
        Width = 273
        Height = 153
        Align = alClient
        Caption = '&Comment'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 1
        DesignSize = (
          273
          153)
        object cbRequiredComment: TCheckBox
          Left = 196
          Top = -3
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
        object txtComment: TCaptionEdit
          AlignWithMargins = True
          Left = 5
          Top = 127
          Width = 263
          Height = 21
          Align = alBottom
          Ctl3D = True
          MaxLength = 240
          ParentCtl3D = False
          TabOrder = 1
          OnChange = txtCommentChange
          Caption = 'Comment (optional)'
        end
        object memComment: TMemo
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 263
          Height = 103
          Align = alClient
          TabOrder = 3
          OnChange = memCommentChange
        end
      end
      object grbRecipientsAdd: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 187
        Height = 153
        Align = alLeft
        Caption = 'Additional Recipients'
        TabOrder = 0
        Visible = False
        object orRecipientsAdd: TORListBox
          AlignWithMargins = True
          Left = 4
          Top = 17
          Width = 179
          Height = 132
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
      object grbNoActionAlert: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 466
        Height = 62
        Align = alClient
        Caption = '&No Action Alert'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        DesignSize = (
          466
          62)
        object cbNoActionRequired: TCheckBox
          Left = 389
          Top = -1
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
          TabOrder = 0
          Visible = False
          OnClick = cbNoActionRequiredClick
        end
        object dtFlagExpire: TORDateBox
          AlignWithMargins = True
          Left = 5
          Top = 36
          Width = 456
          Height = 21
          Align = alBottom
          Ctl3D = True
          Enabled = False
          ParentCtl3D = False
          TabOrder = 2
          DateOnly = False
          RequireTime = True
          Caption = ''
        end
        object cbCreateNoActionAlert: TCheckBox
          Left = 5
          Top = 16
          Width = 456
          Height = 18
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Create a No Action Alert'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = cbCreateNoActionAlertClick
        end
      end
    end
    object pnlRecipients: TPanel
      Left = 1
      Top = 176
      Width = 472
      Height = 166
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinHeight = 132
      TabOrder = 2
      OnResize = pnlRecipientsResize
      object grbRecipients: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 466
        Height = 160
        Align = alClient
        Caption = 'Flag Notification &Recepients'
        TabOrder = 0
        DesignSize = (
          466
          160)
        object pnlRecipientsList: TPanel
          Left = 271
          Top = 15
          Width = 193
          Height = 143
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          OnResize = pnlRecipientsListResize
          ExplicitLeft = 274
          ExplicitWidth = 190
          object orSelectedRecipients: TORListBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 187
            Height = 137
            TabStop = False
            Align = alClient
            ItemHeight = 13
            MultiSelect = True
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = orSelectedRecipientsClick
            OnDblClick = orSelectedRecipientsDblClick
            OnEnter = orSelectedRecipientsEnter
            OnExit = orSelectedRecipientsExit
            Caption = ''
            ItemTipColor = clWindow
            LongList = False
            Pieces = '2,3'
            OnChange = orSelectedRecipientsChange
            ExplicitWidth = 184
          end
        end
        object pnlListButtons: TPanel
          Left = 187
          Top = 15
          Width = 84
          Height = 143
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitLeft = 190
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
            ExplicitWidth = 81
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
            ExplicitWidth = 81
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
            ExplicitWidth = 81
          end
        end
        object pnlRecipientsSource: TPanel
          Left = 2
          Top = 15
          Width = 185
          Height = 143
          Align = alLeft
          BevelOuter = bvNone
          Constraints.MinWidth = 185
          TabOrder = 0
          object cboAlertRecipient: TORComboBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 179
            Height = 137
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
            OnClick = cboAlertRecipientClick
            OnDblClick = cboAlertRecipientDblClick
            OnEnter = cboAlertRecipientEnter
            OnExit = cboAlertRecipientExit
            OnKeyDown = cboAlertRecipientKeyDown
            OnNeedData = cboAlertRecipientNeedData
            CharsNeedMatch = 1
          end
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
          TabOrder = 3
          Visible = False
          OnClick = cbRecipientsRequiredClick
        end
      end
    end
    object pnlReason: TPanel
      Left = 1
      Top = 112
      Width = 472
      Height = 64
      Align = alTop
      BevelOuter = bvNone
      Constraints.MinHeight = 46
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      object grbReason: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 466
        Height = 58
        Align = alClient
        Caption = '&Reason'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        DesignSize = (
          466
          58)
        object cboFlagReason: TORComboBox
          AlignWithMargins = True
          Left = 5
          Top = 32
          Width = 456
          Height = 21
          Style = orcsDropDown
          Align = alBottom
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
      object grbOrderDetails: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 466
        Height = 102
        Align = alClient
        Caption = '&Order(s) Details'
        Color = clCream
        ParentBackground = False
        ParentColor = False
        TabOrder = 0
        object mmOrder: TMemo
          AlignWithMargins = True
          Left = 10
          Top = 23
          Width = 446
          Height = 69
          Hint = 'Selected flag(s) description'
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 8
          TabStop = False
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
          OnChange = mmOrderChange
        end
      end
    end
  end
  object pnlInstructions: TPanel
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
    object grbInstructions: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 466
      Height = 57
      Align = alClient
      TabOrder = 0
      object mmInstructions: TMemo
        AlignWithMargins = True
        Left = 10
        Top = 15
        Width = 446
        Height = 32
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
  end
  object alEditorActions: TActionList
    Left = 56
    Top = 104
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
