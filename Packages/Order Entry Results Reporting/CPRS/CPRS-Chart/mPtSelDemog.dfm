object fraPtSelDemog: TfraPtSelDemog
  Left = 0
  Top = 0
  Width = 180
  Height = 339
  TabOrder = 0
  object gpMain: TGridPanel
    Left = 0
    Top = 0
    Width = 180
    Height = 339
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 28.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 3
        Control = Memo
        Row = 9
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = lblPtName
        Row = 0
      end
      item
        Column = 0
        Control = lblSSN
        Row = 1
      end
      item
        Column = 1
        ColumnSpan = 2
        Control = lblPtSSN
        Row = 1
      end
      item
        Column = 0
        Control = lblDOB
        Row = 2
      end
      item
        Column = 1
        ColumnSpan = 2
        Control = lblPtDOB
        Row = 2
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = lblPtSex
        Row = 3
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = lblPtVet
        Row = 4
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = lblPtSC
        Row = 5
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = lblLocation
        Row = 6
      end
      item
        Column = 2
        Control = lblPtLocation
        Row = 6
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = lblRoomBed
        Row = 7
      end
      item
        Column = 2
        Control = lblPtRoomBed
        Row = 7
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = lblCombatVet
        Row = 8
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object Memo: TCaptionMemo
      Left = 0
      Top = 180
      Width = 180
      Height = 159
      Align = alClient
      HideSelection = False
      ReadOnly = True
      TabOrder = 0
      Visible = False
      WantReturns = False
      OnEnter = MemoEnter
      OnKeyDown = MemoKeyDown
      Caption = ''
    end
    object lblPtName: TStaticText
      Tag = 2
      Left = 0
      Top = 0
      Width = 180
      Height = 20
      Align = alClient
      Caption = 'Winchester,Charles Emerson'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object lblSSN: TStaticText
      Tag = 1
      Left = 0
      Top = 20
      Width = 30
      Height = 20
      Align = alClient
      Caption = 'SSN:'
      TabOrder = 3
    end
    object lblPtSSN: TStaticText
      Tag = 2
      Left = 30
      Top = 20
      Width = 150
      Height = 20
      Align = alClient
      Caption = '123-45-1234'
      TabOrder = 4
    end
    object lblDOB: TStaticText
      Tag = 1
      Left = 0
      Top = 40
      Width = 30
      Height = 20
      Align = alClient
      Caption = 'DOB:'
      TabOrder = 5
    end
    object lblPtDOB: TStaticText
      Tag = 2
      Left = 30
      Top = 40
      Width = 150
      Height = 20
      Align = alClient
      Caption = 'Jun 26,1957'
      TabOrder = 6
    end
    object lblPtSex: TStaticText
      Tag = 2
      Left = 0
      Top = 60
      Width = 180
      Height = 20
      Align = alClient
      Caption = 'Male, age 39'
      TabOrder = 7
    end
    object lblPtVet: TStaticText
      Tag = 2
      Left = 0
      Top = 80
      Width = 180
      Height = 20
      Align = alClient
      Caption = 'Veteran'
      TabOrder = 8
    end
    object lblPtSC: TStaticText
      Tag = 2
      Left = 0
      Top = 100
      Width = 180
      Height = 20
      Align = alClient
      Caption = 'Service Connected 50%'
      TabOrder = 9
    end
    object lblLocation: TStaticText
      Tag = 1
      Left = 0
      Top = 120
      Width = 58
      Height = 20
      Align = alClient
      Caption = 'Location:'
      TabOrder = 10
    end
    object lblPtLocation: TStaticText
      Tag = 2
      Left = 58
      Top = 120
      Width = 122
      Height = 20
      Align = alClient
      Caption = '2 EAST'
      ShowAccelChar = False
      TabOrder = 11
    end
    object lblRoomBed: TStaticText
      Tag = 1
      Left = 0
      Top = 140
      Width = 58
      Height = 20
      Align = alClient
      Caption = 'Room-Bed:'
      TabOrder = 12
    end
    object lblPtRoomBed: TStaticText
      Tag = 2
      Left = 58
      Top = 140
      Width = 122
      Height = 20
      Align = alClient
      Caption = '257-B'
      ShowAccelChar = False
      TabOrder = 13
    end
    object lblCombatVet: TStaticText
      Tag = 2
      Left = 0
      Top = 160
      Width = 180
      Height = 20
      Align = alClient
      Caption = 'lblCombatVet'
      TabOrder = 14
    end
  end
end
