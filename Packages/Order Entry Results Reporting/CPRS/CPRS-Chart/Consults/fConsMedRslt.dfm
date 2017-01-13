inherited frmConsMedRslt: TfrmConsMedRslt
  Left = 468
  Top = 172
  BorderStyle = bsDialog
  Caption = 'Select Medicine Result'
  ClientHeight = 222
  ClientWidth = 500
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 506
  ExplicitHeight = 250
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 500
    Height = 222
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlAction: TPanel
      Left = 0
      Top = 128
      Width = 500
      Height = 53
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        500
        53)
      object lblDateofAction: TOROffsetLabel
        Left = 134
        Top = -2
        Width = 112
        Height = 20
        Caption = 'Date/time of this action'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
      end
      object lblActionBy: TOROffsetLabel
        Left = 267
        Top = -2
        Width = 215
        Height = 19
        Caption = 'Action by'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
      end
      object cmdDetails: TButton
        Left = 15
        Top = 23
        Width = 75
        Height = 21
        Caption = 'Show Details'
        TabOrder = 0
        OnClick = cmdDetailsClick
      end
      object calDateofAction: TORDateBox
        Left = 131
        Top = 23
        Width = 116
        Height = 21
        TabOrder = 1
        Text = 'Now'
        DateOnly = False
        RequireTime = False
        Caption = 'Date/time of this action'
      end
      object cboPerson: TORComboBox
        Left = 267
        Top = 23
        Width = 221
        Height = 21
        Anchors = [akLeft, akTop, akRight]
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
        TabOrder = 2
        TabStop = True
        Text = ''
        OnNeedData = NewPersonNeedData
        CharsNeedMatch = 1
      end
    end
    object pnlMiddle: TPanel
      Left = 0
      Top = 0
      Width = 500
      Height = 128
      Align = alClient
      TabOrder = 0
      object SrcLabel: TLabel
        Left = 1
        Top = 1
        Width = 498
        Height = 16
        Align = alTop
        AutoSize = False
        Caption = 'Select medicine result:'
        ExplicitLeft = 12
        ExplicitTop = 6
        ExplicitWidth = 145
      end
      object lstMedResults: TCaptionListView
        Left = 1
        Top = 17
        Width = 498
        Height = 110
        Margins.Left = 8
        Margins.Right = 8
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
    object pnlbottom: TPanel
      Left = 0
      Top = 181
      Width = 500
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object pnlButtons: TPanel
        Left = 315
        Top = 0
        Width = 185
        Height = 41
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object cmdOK: TButton
          Left = 11
          Top = 9
          Width = 75
          Height = 21
          Caption = 'OK'
          Default = True
          TabOrder = 0
          OnClick = cmdOKClick
        end
        object cmdCancel: TButton
          Left = 99
          Top = 9
          Width = 75
          Height = 21
          Cancel = True
          Caption = 'Cancel'
          TabOrder = 1
          OnClick = cmdCancelClick
        end
      end
      object ckAlert: TCheckBox
        Left = 134
        Top = 12
        Width = 79
        Height = 17
        Caption = 'Send alert'
        TabOrder = 0
        OnClick = ckAlertClick
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 40
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
    Left = 8
  end
end
