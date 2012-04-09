inherited frmConsultAction: TfrmConsultAction
  Left = 277
  Top = 217
  BorderIcons = []
  Caption = 'frmConsultAction'
  ClientHeight = 429
  ClientWidth = 592
  Constraints.MinHeight = 406
  Constraints.MinWidth = 600
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 600
  ExplicitHeight = 456
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TPanel [0]
    Left = 0
    Top = 0
    Width = 592
    Height = 429
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitHeight = 379
    object pnlForward: TPanel
      Left = 0
      Top = 0
      Width = 224
      Height = 429
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitHeight = 379
      object lblToService: TOROffsetLabel
        Left = 2
        Top = 0
        Width = 120
        Height = 19
        Caption = 'To service'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
      end
      object lblAttentionOf: TOROffsetLabel
        Left = 2
        Top = 325
        Width = 44
        Height = 19
        Caption = 'Attention'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
      end
      object lblUrgency: TOROffsetLabel
        Left = 2
        Top = 277
        Width = 42
        Height = 19
        Caption = 'Urgency'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
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
        Left = 2
        Top = 344
        Width = 212
        Height = 21
        Style = orcsDropDown
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
        OnNeedData = NewPersonNeedData
        CharsNeedMatch = 1
      end
      object cboUrgency: TORComboBox
        Left = 2
        Top = 297
        Width = 212
        Height = 21
        Style = orcsDropDown
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
        CharsNeedMatch = 1
      end
      object treService: TORTreeView
        Left = 2
        Top = 100
        Width = 212
        Height = 182
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 1
        OnChange = treServiceChange
        OnExit = treServiceExit
        Caption = 'To service'
        NodePiece = 0
      end
      object cboService: TORComboBox
        Left = 2
        Top = 23
        Width = 212
        Height = 75
        Style = orcsSimple
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
        OnKeyPause = cboServiceSelect
        OnMouseClick = cboServiceSelect
        CharsNeedMatch = 1
      end
    end
    object pnlOther: TPanel
      Left = 224
      Top = 0
      Width = 368
      Height = 429
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitHeight = 379
      object pnlSigFind: TPanel
        Left = 0
        Top = 0
        Width = 368
        Height = 57
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object grpSigFindings: TRadioGroup
          Left = 9
          Top = 7
          Width = 350
          Height = 41
          Caption = 'Significant Findings - Current status:  '
          Columns = 3
          Ctl3D = True
          Items.Strings = (
            '&Yes'
            '&No'
            '&Unknown')
          ParentCtl3D = False
          TabOrder = 0
        end
      end
      object pnlComments: TPanel
        Left = 0
        Top = 57
        Width = 368
        Height = 274
        Align = alClient
        Alignment = taLeftJustify
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitHeight = 224
        object lblComments: TOROffsetLabel
          Left = 0
          Top = 0
          Width = 368
          Height = 19
          Align = alTop
          Caption = 'Comments'
          HorzOffset = 2
          Transparent = False
          VertOffset = 6
          WordWrap = False
        end
        object memComments: TCaptionMemo
          Left = 0
          Top = 19
          Width = 368
          Height = 220
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
          Caption = 'Comments'
          ExplicitHeight = 170
        end
        object pnlAlert: TPanel
          Left = 0
          Top = 239
          Width = 368
          Height = 35
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitTop = 189
          object lblAutoAlerts: TStaticText
            Left = 6
            Top = 1
            Width = 4
            Height = 4
            TabOrder = 1
          end
          object ckAlert: TCheckBox
            Left = 6
            Top = 17
            Width = 129
            Height = 17
            Caption = 'Send additional alerts'
            TabOrder = 0
            OnClick = ckAlertClick
          end
        end
      end
      object pnlAllActions: TPanel
        Left = 0
        Top = 331
        Width = 368
        Height = 98
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        ExplicitTop = 281
        DesignSize = (
          368
          98)
        object lblActionBy: TOROffsetLabel
          Left = 138
          Top = -4
          Width = 215
          Height = 19
          Caption = 'Action by'
          HorzOffset = 2
          Transparent = False
          VertOffset = 6
          WordWrap = False
        end
        object lblDateofAction: TOROffsetLabel
          Left = 5
          Top = -4
          Width = 112
          Height = 19
          Caption = 'Date/time of this action'
          HorzOffset = 2
          Transparent = False
          VertOffset = 6
          WordWrap = False
        end
        object calDateofAction: TORDateBox
          Left = 5
          Top = 15
          Width = 116
          Height = 21
          TabOrder = 0
          Text = 'Now'
          DateOnly = False
          RequireTime = False
          Caption = 'Date/time of this action'
        end
        object cmdOK: TORAlignButton
          Left = 201
          Top = 62
          Width = 75
          Height = 22
          Anchors = [akRight, akBottom]
          Caption = 'OK'
          TabOrder = 2
          OnClick = cmdOKClick
        end
        object cmdCancel: TORAlignButton
          Left = 286
          Top = 62
          Width = 75
          Height = 22
          Anchors = [akRight, akBottom]
          Cancel = True
          Caption = 'Cancel'
          TabOrder = 3
          OnClick = cmdCancelClick
        end
        object cboPerson: TORComboBox
          Left = 137
          Top = 15
          Width = 220
          Height = 21
          Style = orcsDropDown
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
          TabOrder = 1
          TabStop = True
          OnNeedData = NewPersonNeedData
          CharsNeedMatch = 1
        end
      end
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
        'Status = stsDefault')
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
        'Status = stsDefault'))
  end
end
