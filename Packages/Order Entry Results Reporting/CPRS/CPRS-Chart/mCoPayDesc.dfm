inherited fraCoPayDesc: TfraCoPayDesc
  Left = 0
  Top = 0
  Width = 508
  Height = 210
  Anchors = [akLeft, akTop, akRight]
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  ParentShowHint = False
  ShowHint = True
  TabOrder = 0
  object gpMain: TGridPanel
    Left = 0
    Top = 0
    Width = 508
    Height = 210
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = pnlSCandRD
        Row = 0
      end
      item
        Column = 1
        Control = pnlRight
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object pnlSCandRD: TPanel
      Left = 0
      Top = 0
      Width = 254
      Height = 210
      Align = alClient
      Anchors = []
      BevelOuter = bvNone
      TabOrder = 0
      object lblSCDisplay: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 244
        Height = 16
        Align = alTop
        AutoSize = False
        Caption = 'Service Connection && Rated Disabilities'
        Layout = tlCenter
        ExplicitWidth = 237
      end
      object pnlBorderLeft: TPanel
        Left = 0
        Top = 22
        Width = 250
        Height = 179
        Align = alClient
        BorderStyle = bsSingle
        TabOrder = 0
        ExplicitWidth = 254
        ExplicitHeight = 188
        object memSCDisplay: TCaptionMemo
          Left = 1
          Top = 1
          Width = 244
          Height = 173
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Color = clBtnFace
          Lines.Strings = (
            '')
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          Caption = 'Service Connection and Rated Disabilities'
          ExplicitLeft = 2
        end
      end
    end
    object pnlRight: TPanel
      Left = 254
      Top = 0
      Width = 254
      Height = 210
      Align = alClient
      BevelEdges = []
      BevelOuter = bvNone
      Caption = 'pnlRight'
      ShowCaption = False
      TabOrder = 1
      object lblCaption: TStaticText
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 244
        Height = 17
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'Outpatient Medications Related To:'
        TabOrder = 0
        ExplicitWidth = 248
      end
      object pnlBorderRight: TPanel
        Left = 0
        Top = 23
        Width = 250
        Height = 178
        Align = alClient
        BorderStyle = bsSingle
        TabOrder = 1
        ExplicitWidth = 254
        ExplicitHeight = 187
        object sbRight: TScrollBox
          Left = 1
          Top = 1
          Width = 244
          Height = 172
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object gpRight: TGridPanel
            Left = 0
            Top = 0
            Width = 240
            Height = 168
            Align = alTop
            BevelOuter = bvNone
            ColumnCollection = <
              item
                SizeStyle = ssAbsolute
                Value = 50.000000000000000000
              end
              item
                Value = 100.000000000000000000
              end>
            ControlCollection = <>
            RowCollection = <
              item
                Value = 100.000000000000000000
              end>
            ShowCaption = False
            TabOrder = 0
            OnResize = gpRightResize
            ExplicitLeft = 1
            ExplicitTop = -2
          end
        end
      end
    end
  end
  object bHint: TBalloonHint
    Style = bhsStandard
    Delay = 50
    HideAfter = 15000
    Position = hpBelow
    Left = 288
    Top = 64
  end
  object appEvents: TApplicationEvents
    OnMessage = appEventsMessage
    Left = 336
    Top = 64
  end
end
