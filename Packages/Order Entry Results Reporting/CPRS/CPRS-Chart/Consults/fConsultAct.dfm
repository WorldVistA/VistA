inherited frmConsultAction: TfrmConsultAction
  Left = 277
  Top = 217
  BorderIcons = []
  Caption = 'frmConsultAction'
  ClientHeight = 414
  ClientWidth = 584
  Constraints.MinHeight = 406
  Constraints.MinWidth = 600
  OldCreateOrder = True
  Position = poScreenCenter
  OnResize = ORFormResize
  ExplicitWidth = 600
  ExplicitHeight = 453
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TPanel [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 578
    Height = 369
    Margins.Bottom = 6
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlForward: TPanel
      Left = 0
      Top = 0
      Width = 224
      Height = 369
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblToService: TOROffsetLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 218
        Height = 19
        Align = alTop
        Caption = 'To service'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
        ExplicitLeft = 2
        ExplicitTop = 0
        ExplicitWidth = 120
      end
      object lblAttentionOf: TOROffsetLabel
        AlignWithMargins = True
        Left = 3
        Top = 320
        Width = 218
        Height = 19
        Align = alBottom
        Caption = 'Attention'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
        ExplicitLeft = 2
        ExplicitTop = 325
        ExplicitWidth = 44
      end
      object lblUrgency: TOROffsetLabel
        AlignWithMargins = True
        Left = 3
        Top = 268
        Width = 218
        Height = 19
        Align = alBottom
        Caption = 'Urgency'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
        ExplicitTop = 238
      end
      object Label1: TMemo
        Left = 18
        Top = 123
        Width = 185
        Height = 65
        TabStop = False
        Alignment = taCenter
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          'A procedure can only be forwarded to '
          'other services defined as being able to '
          'perform that procedure.  Valid '
          'selections for this procedure are listed '
          'in the drop-down box above.')
        ReadOnly = True
        TabOrder = 4
      end
      object cboAttentionOf: TORComboBox
        AlignWithMargins = True
        Left = 3
        Top = 345
        Width = 218
        Height = 21
        Style = orcsDropDown
        Align = alBottom
        AutoSelect = True
        Caption = 'Attention'
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
        OnNeedData = NewPersonNeedData
        CharsNeedMatch = 1
      end
      object cboUrgency: TORComboBox
        AlignWithMargins = True
        Left = 3
        Top = 293
        Width = 218
        Height = 21
        Style = orcsDropDown
        Align = alBottom
        AutoSelect = True
        Caption = 'Urgency'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '2'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 2
        Text = ''
        CharsNeedMatch = 1
      end
      object treService: TORTreeView
        AlignWithMargins = True
        Left = 3
        Top = 103
        Width = 218
        Height = 159
        Margins.Top = 0
        Align = alClient
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 1
        OnChange = treServiceChange
        Caption = 'To service'
        NodePiece = 0
      end
      object cboService: TORComboBox
        AlignWithMargins = True
        Left = 3
        Top = 28
        Width = 218
        Height = 75
        Margins.Bottom = 0
        Style = orcsSimple
        Align = alTop
        AutoSelect = True
        Caption = 'To service'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '2'
        Sorted = True
        SynonymChars = '<>'
        TabOrder = 0
        Text = ''
        OnKeyPause = cboServiceSelect
        OnMouseClick = cboServiceSelect
        CharsNeedMatch = 1
      end
    end
    object pnlOther: TPanel
      Left = 224
      Top = 0
      Width = 354
      Height = 369
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object pnlSigFind: TPanel
        Left = 0
        Top = 0
        Width = 354
        Height = 57
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object grpSigFindings: TRadioGroup
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 348
          Height = 41
          Align = alTop
          Caption = 'Significant Findings - Current status:  '
          Columns = 3
          Ctl3D = True
          Items.Strings = (
            '&Yes'
            '&No'
            '&Unknown')
          ParentCtl3D = False
          TabOrder = 0
          OnClick = grpSigFindingsClick
        end
      end
      object pnlComments: TPanel
        Left = 0
        Top = 57
        Width = 354
        Height = 200
        Align = alClient
        Alignment = taLeftJustify
        BevelOuter = bvNone
        TabOrder = 1
        object lblComments: TOROffsetLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 348
          Height = 19
          Align = alTop
          Caption = 'Comments'
          HorzOffset = 2
          Transparent = False
          VertOffset = 6
          WordWrap = False
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 368
        end
        object memComments: TCaptionMemo
          AlignWithMargins = True
          Left = 3
          Top = 28
          Width = 348
          Height = 169
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
          OnChange = ControlChange
          Caption = 'Comments'
        end
      end
      object pnlAllActions: TPanel
        Left = 0
        Top = 315
        Width = 354
        Height = 54
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 3
        object pnlActionDate: TPanel
          Left = 0
          Top = 0
          Width = 131
          Height = 54
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'pnlActionDate'
          ShowCaption = False
          TabOrder = 0
          object lblDateofAction: TOROffsetLabel
            AlignWithMargins = True
            Left = 3
            Top = 5
            Width = 125
            Height = 19
            Align = alBottom
            Caption = 'Date/time of this action'
            HorzOffset = 2
            Transparent = False
            VertOffset = 6
            WordWrap = False
            ExplicitLeft = 5
            ExplicitTop = -4
            ExplicitWidth = 112
          end
          object calDateofAction: TORDateBox
            AlignWithMargins = True
            Left = 3
            Top = 30
            Width = 125
            Height = 21
            Align = alBottom
            TabOrder = 0
            Text = 'Now'
            DateOnly = False
            RequireTime = False
            Caption = 'Date/time of this action'
          end
        end
        object pnlActionBy: TPanel
          Left = 131
          Top = 0
          Width = 223
          Height = 54
          Align = alClient
          BevelOuter = bvNone
          Caption = 'pnlActionBy'
          ShowCaption = False
          TabOrder = 1
          object lblActionBy: TOROffsetLabel
            AlignWithMargins = True
            Left = 3
            Top = 5
            Width = 217
            Height = 19
            Align = alBottom
            Caption = 'Action by'
            HorzOffset = 2
            Transparent = False
            VertOffset = 6
            WordWrap = False
            ExplicitLeft = 22
            ExplicitTop = -4
            ExplicitWidth = 215
          end
          object cboPerson: TORComboBox
            AlignWithMargins = True
            Left = 3
            Top = 30
            Width = 217
            Height = 21
            Style = orcsDropDown
            Align = alBottom
            AutoSelect = True
            Caption = 'Action by'
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
            TabOrder = 0
            TabStop = True
            Text = ''
            OnNeedData = NewPersonNeedData
            CharsNeedMatch = 1
          end
        end
      end
      object pnlAlert: TPanel
        Left = 0
        Top = 257
        Width = 354
        Height = 58
        Align = alBottom
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 2
        object lblAutoAlerts: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 4
          Height = 4
          Align = alTop
          TabOrder = 1
        end
        object ckAlert: TCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 38
          Width = 348
          Height = 17
          Align = alTop
          Caption = 'Send additional alerts'
          TabOrder = 0
          OnClick = ckAlertClick
        end
      end
    end
  end
  object pnlButtons: TPanel [1]
    AlignWithMargins = True
    Left = 3
    Top = 381
    Width = 578
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object cmdCancel: TORAlignButton
      AlignWithMargins = True
      Left = 500
      Top = 3
      Width = 75
      Height = 24
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = cmdCancelClick
    end
    object cmdOK: TORAlignButton
      AlignWithMargins = True
      Left = 419
      Top = 3
      Width = 75
      Height = 24
      Align = alRight
      Caption = 'OK'
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object btnLaunchToolbox: TButton
      Left = 3
      Top = 4
      Width = 130
      Height = 25
      Caption = 'Open Consult Toolbox'
      TabOrder = 0
      OnClick = btnLaunchToolboxClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = pnlForward'
        'Status = stsDefault')
      (
        'Component = Label1'
        'Status = stsDefault')
      (
        'Component = cboAttentionOf'
        'Status = stsDefault')
      (
        'Component = cboUrgency'
        'Status = stsDefault')
      (
        'Component = treService'
        'Status = stsDefault')
      (
        'Component = cboService'
        'Status = stsDefault')
      (
        'Component = pnlOther'
        'Status = stsDefault')
      (
        'Component = pnlSigFind'
        'Status = stsDefault')
      (
        'Component = grpSigFindings'
        'Status = stsDefault')
      (
        'Component = pnlComments'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = pnlAlert'
        'Status = stsDefault')
      (
        'Component = lblAutoAlerts'
        'Status = stsDefault')
      (
        'Component = ckAlert'
        'Status = stsDefault')
      (
        'Component = pnlAllActions'
        'Status = stsDefault')
      (
        'Component = calDateofAction'
        'Text = Date/Time of this action. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cboPerson'
        'Status = stsDefault')
      (
        'Component = frmConsultAction'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = pnlActionDate'
        'Status = stsDefault')
      (
        'Component = pnlActionBy'
        'Status = stsDefault')
      (
        'Component = btnLaunchToolbox'
        'Status = stsDefault'))
  end
end
