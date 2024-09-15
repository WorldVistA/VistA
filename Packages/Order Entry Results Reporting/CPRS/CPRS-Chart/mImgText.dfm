object fraImgText: TfraImgText
  Left = 0
  Top = 0
  Width = 451
  Height = 20
  Align = alTop
  AutoScroll = True
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentCtl3D = False
  ParentFont = False
  TabOrder = 0
  TabStop = True
  OnEnter = FrameEnter
  OnExit = FrameExit
  object gp: TGridPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 20
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 48.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = img
        Row = 0
      end
      item
        Column = 1
        Control = lblText
        Row = 0
      end>
    Ctl3D = False
    ParentCtl3D = False
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    ShowCaption = False
    TabOrder = 0
    StyleElements = [seClient, seBorder]
    object img: TImage
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 42
      Height = 14
      Align = alClient
      AutoSize = True
      ExplicitLeft = 4
      ExplicitTop = 2
      ExplicitWidth = 90
      ExplicitHeight = 16
    end
    object lblText: TStaticText
      AlignWithMargins = True
      Left = 51
      Top = 3
      Width = 397
      Height = 14
      Align = alClient
      Caption = 'lblText'
      TabOrder = 0
    end
  end
end
