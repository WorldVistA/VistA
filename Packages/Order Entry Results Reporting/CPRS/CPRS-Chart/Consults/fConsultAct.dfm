inherited frmConsultAction: TfrmConsultAction
  Left = 277
  Top = 217
  BorderIcons = []
  Caption = 'frmConsultAction'
  ClientHeight = 426
  ClientWidth = 584
  Constraints.MinHeight = 406
  Constraints.MinWidth = 600
  OldCreateOrder = True
  Position = poScreenCenter
  OnResize = ORFormResize
  ExplicitWidth = 600
  ExplicitHeight = 465
  TextHeight = 13
  object pnlBase: TPanel [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 582
    Height = 311
    Margins.Bottom = 6
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 357
    object pnlForward: TPanel
      Left = 0
      Top = 0
      Width = 224
      Height = 311
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
      object lblUrgency: TOROffsetLabel
        Left = 0
        Top = 270
        Width = 224
        Height = 20
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
        TabOrder = 3
      end
      object cboUrgency: TORComboBox
        Left = 0
        Top = 290
        Width = 224
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
        Height = 164
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
      Width = 358
      Height = 311
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object pnlSigFind: TPanel
        Left = 0
        Top = 0
        Width = 358
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object grpSigFindings: TRadioGroup
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 352
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
        Top = 41
        Width = 358
        Height = 223
        Align = alClient
        Alignment = taLeftJustify
        BevelOuter = bvNone
        TabOrder = 1
        object lblComments: TOROffsetLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 352
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
          Width = 352
          Height = 192
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
          ExplicitWidth = 348
          ExplicitHeight = 191
        end
      end
      object pnlAlert: TPanel
        Left = 0
        Top = 264
        Width = 358
        Height = 47
        Align = alBottom
        AutoSize = True
        BevelOuter = bvNone
        TabOrder = 2
        object lblAutoAlerts: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 352
          Height = 4
          Align = alTop
          TabOrder = 1
        end
        object ckAlert: TCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 17
          Width = 352
          Height = 27
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
    Top = 393
    Width = 582
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    object cmdCancel: TORAlignButton
      AlignWithMargins = True
      Left = 504
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
      Left = 423
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
  object pnlAll: TGridPanel [2]
    Left = 0
    Top = 320
    Width = 588
    Height = 70
    Align = alBottom
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 230.000000000000000000
      end
      item
        Value = 50.473963167969800000
      end
      item
        Value = 49.526036832030200000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = lblAttentionOf
        Row = 0
      end
      item
        Column = 1
        Control = lblDateofAction
        Row = 0
      end
      item
        Column = 2
        Control = lblActionBy
        Row = 0
      end
      item
        Column = 0
        Control = cboAttentionOf
        Row = 1
      end
      item
        Column = 1
        Control = calDateofAction
        Row = 1
      end
      item
        Column = 2
        Control = cboPerson
        Row = 1
      end>
    RowCollection = <
      item
        SizeStyle = ssAuto
        Value = 26.000000000000000000
      end
      item
        SizeStyle = ssAuto
        Value = 100.000000000000000000
      end>
    TabOrder = 1
    object lblAttentionOf: TOROffsetLabel
      Left = 1
      Top = 1
      Width = 230
      Height = 21
      Align = alTop
      Caption = 'Attention'
      HorzOffset = 2
      Transparent = False
      VertOffset = 6
      WordWrap = False
    end
    object lblDateofAction: TOROffsetLabel
      Left = 231
      Top = 1
      Width = 180
      Height = 21
      Align = alTop
      Caption = 'Date/time of this action'
      HorzOffset = 2
      Transparent = False
      VertOffset = 6
      WordWrap = False
    end
    object lblActionBy: TOROffsetLabel
      Left = 411
      Top = 1
      Width = 176
      Height = 21
      Align = alTop
      Caption = 'Action by'
      HorzOffset = 2
      Transparent = False
      VertOffset = 6
      WordWrap = False
    end
    object cboAttentionOf: TORCheckComboBox
      AlignWithMargins = True
      Left = 4
      Top = 25
      Width = 224
      Height = 40
      Style = orcsDropDown
      Align = alTop
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
      TabOrder = 0
      Text = ''
      OnNeedData = cboAttentionOfNeedData
      CharsNeedMatch = 1
      MainCheckBoxCaption = 'Include Non-VA Providers'
      MainCheckBoxVisible = True
      MainCheckBoxAlignment = calBottom
      OnMainCheckboxClick = cboAttentionOfMainCheckboxClick
      DropdownStyle = ddsControl
    end
    object calDateofAction: TORDateBox
      AlignWithMargins = True
      Left = 234
      Top = 25
      Width = 174
      Height = 21
      Align = alTop
      TabOrder = 1
      Text = 'Now'
      DateOnly = False
      RequireTime = False
      Caption = 'Date/time of this action'
    end
    object cboPerson: TORCheckComboBox
      AlignWithMargins = True
      Left = 414
      Top = 25
      Width = 170
      Height = 40
      Style = orcsDropDown
      Align = alTop
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
      TabOrder = 3
      TabStop = True
      Text = ''
      OnNeedData = cboPersonNeedData
      CharsNeedMatch = 1
      MainCheckBoxCaption = 'Include Non-VA Providers'
      MainCheckBoxVisible = True
      MainCheckBoxAlignment = calBottom
      OnMainCheckboxClick = cboPersonMainCheckboxClick
      DropdownStyle = ddsControl
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
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmConsultAction'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = btnLaunchToolbox'
        'Status = stsDefault')
      (
        'Component = pnlAll'
        'Status = stsDefault')
      (
        'Component = cboAttentionOf'
        'Status = stsDefault')
      (
        'Component = calDateofAction'
        'Text = Date/Time of this action. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cboPerson'
        'Status = stsDefault'))
  end
end
