inherited frmConsMedRslt: TfrmConsMedRslt
  Left = 468
  Top = 172
  BorderStyle = bsDialog
  Caption = 'Select Medicine Result'
  ClientHeight = 264
  ClientWidth = 526
  Position = poScreenCenter
  ExplicitWidth = 532
  ExplicitHeight = 297
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 526
    Height = 231
    Align = alClient
    TabOrder = 0
    object pnlAction: TPanel
      Left = 1
      Top = 168
      Width = 524
      Height = 62
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        524
        62)
      object lblDateofAction: TOROffsetLabel
        Left = 133
        Top = -3
        Width = 157
        Height = 28
        Caption = 'Date/time of this action'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
      end
      object lblActionBy: TOROffsetLabel
        Left = 296
        Top = -2
        Width = 220
        Height = 27
        Caption = 'Action by'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
      end
      object calDateofAction: TORDateBox
        Left = 131
        Top = 23
        Width = 159
        Height = 24
        TabOrder = 1
        Text = 'Now'
        DateOnly = False
        RequireTime = False
        Caption = 'Date/time of this action'
      end
      object cboPerson: TORComboBox
        Left = 296
        Top = 23
        Width = 216
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Action by'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 16
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = True
        LookupPiece = 2
        MaxLength = 0
        Pieces = '2,3'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 2
        TabStop = True
        Text = ''
        OnNeedData = NewPersonNeedData
        CharsNeedMatch = 1
      end
      object ckAlert: TCheckBox
        Left = 8
        Top = 28
        Width = 89
        Height = 17
        Caption = 'Send alert'
        TabOrder = 0
        OnClick = ckAlertClick
      end
    end
    object pnlMiddle: TPanel
      Left = 1
      Top = 1
      Width = 524
      Height = 167
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object SrcLabel: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 518
        Height = 16
        Align = alTop
        AutoSize = False
        Caption = 'Select medicine result:'
        ExplicitLeft = 1
        ExplicitTop = 0
        ExplicitWidth = 498
      end
      object lstMedResults: TCaptionListView
        AlignWithMargins = True
        Left = 3
        Top = 25
        Width = 518
        Height = 139
        Align = alClient
        Columns = <
          item
            Caption = 'Type of Result'
            Width = 180
          end
          item
            Caption = 'Date of Result'
            Tag = 1
            Width = 100
          end
          item
            Caption = 'Summary'
            Tag = 2
            Width = 160
          end>
        HideSelection = False
        HoverTime = 0
        IconOptions.WrapText = False
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        ShowWorkAreas = True
        ShowHint = True
        SmallImages = ImageList1
        TabOrder = 0
        ViewStyle = vsReport
        AutoSize = False
        Caption = 'Select medicine result'
        Pieces = '2,3,4'
      end
    end
  end
  object pnlbottom: TPanel [1]
    Left = 0
    Top = 231
    Width = 526
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object pnlButtons: TPanel
      Left = 341
      Top = 0
      Width = 185
      Height = 33
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object cmdOK: TButton
        AlignWithMargins = True
        Left = 26
        Top = 3
        Width = 75
        Height = 27
        Align = alRight
        Caption = 'OK'
        Default = True
        TabOrder = 0
        OnClick = cmdOKClick
      end
      object cmdCancel: TButton
        AlignWithMargins = True
        Left = 107
        Top = 3
        Width = 75
        Height = 27
        Align = alRight
        Cancel = True
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = cmdCancelClick
      end
    end
    object cmdDetails: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 110
      Height = 27
      Align = alLeft
      Caption = 'Show Details'
      TabOrder = 0
      OnClick = cmdDetailsClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 72
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = frmConsMedRslt'
        'Status = stsDefault')
      (
        'Component = pnlAction'
        'Status = stsDefault')
      (
        'Component = pnlMiddle'
        'Status = stsDefault')
      (
        'Component = pnlbottom'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = ckAlert'
        'Status = stsDefault')
      (
        'Component = cmdDetails'
        'Status = stsDefault')
      (
        'Component = calDateofAction'
        'Text = Date/Time of this action. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cboPerson'
        'Status = stsDefault')
      (
        'Component = lstMedResults'
        'Status = stsDefault'))
  end
  object ImageList1: TImageList
    Height = 12
    Width = 12
    Left = 104
    Top = 72
  end
end
