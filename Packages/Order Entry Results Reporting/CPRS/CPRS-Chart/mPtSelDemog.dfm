object fraPtSelDemog: TfraPtSelDemog
  Left = 0
  Top = 0
  Width = 323
  Height = 429
  Constraints.MinHeight = 200
  TabOrder = 0
  OnResize = FrameResize
  object gPanel: TGridPanel
    AlignWithMargins = True
    Left = 3
    Top = 20
    Width = 317
    Height = 406
    Margins.Top = 0
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 120.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = stxSSN
        Row = 0
      end
      item
        Column = 1
        Control = lblPtSSN
        Row = 0
      end
      item
        Column = 0
        Control = stxDOB
        Row = 1
      end
      item
        Column = 1
        Control = lblPtDOB
        Row = 1
      end
      item
        Column = 0
        Control = stxSexAge
        Row = 2
      end
      item
        Column = 1
        Control = lblPtSex
        Row = 2
      end
      item
        Column = 0
        Control = stxSIGI
        Row = 3
      end
      item
        Column = 1
        Control = lblPtSigi
        Row = 3
      end
      item
        Column = 0
        Control = stxVeteran
        Row = 4
      end
      item
        Column = 1
        Control = lblPtVet
        Row = 4
      end
      item
        Column = 0
        Control = stxSC
        Row = 5
      end
      item
        Column = 1
        Control = lblPtSC
        Row = 5
      end
      item
        Column = 0
        Control = stxLocation
        Row = 6
      end
      item
        Column = 1
        Control = lblPtLocation
        Row = 6
      end
      item
        Column = 0
        Control = stxRoomBed
        Row = 7
      end
      item
        Column = 1
        Control = lblPtRoomBed
        Row = 7
      end
      item
        Column = 1
        Control = lblCombatVet
        Row = 8
      end
      item
        Column = 0
        Control = lblVeteran
        Row = 8
      end
      item
        Column = 0
        Control = stxPrimaryProvider
        Row = 9
      end
      item
        Column = 1
        Control = stxPtPrimaryProvider
        Row = 9
      end
      item
        Column = 0
        Control = stxInpatientProvider
        Row = 10
      end
      item
        Column = 1
        Control = stxPtInpatientProvider
        Row = 10
      end
      item
        Column = 0
        Control = stxAttending
        Row = 11
      end
      item
        Column = 1
        Control = stxPtAttending
        Row = 11
      end
      item
        Column = 0
        Control = stxLastVisitLocation
        Row = 12
      end
      item
        Column = 1
        Control = stxPtLastVisitLocation
        Row = 12
      end
      item
        Column = 0
        Control = stxLastVisitDate
        Row = 13
      end
      item
        Column = 1
        Control = stxPtLastVisitDate
        Row = 13
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = Memo
        Row = 14
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ShowCaption = False
    TabOrder = 0
    object stxSSN: TStaticText
      Tag = 1
      AlignWithMargins = True
      Left = 3
      Top = 1
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      AutoSize = False
      Caption = 'SSN:'
      TabOrder = 0
      Visible = False
    end
    object lblPtSSN: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 123
      Top = 1
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = '123-45-1234'
      TabOrder = 1
    end
    object stxDOB: TStaticText
      Tag = 1
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'DOB:'
      TabOrder = 2
      Visible = False
    end
    object lblPtDOB: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 123
      Top = 22
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'Jun 26,1957'
      TabOrder = 3
    end
    object stxSexAge: TStaticText
      Tag = 1
      AlignWithMargins = True
      Left = 3
      Top = 43
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'Birth Sex:'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Visible = False
    end
    object lblPtSex: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 123
      Top = 43
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'Male, age 39'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object stxSIGI: TStaticText
      Tag = 1
      AlignWithMargins = True
      Left = 3
      Top = 64
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'SIGI:'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Visible = False
    end
    object lblPtSigi: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 123
      Top = 64
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'Male'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
    end
    object stxVeteran: TStaticText
      Tag = 1
      AlignWithMargins = True
      Left = 3
      Top = 85
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'Veteran:'
      TabOrder = 8
      Visible = False
    end
    object lblPtVet: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 123
      Top = 85
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'Veteran'
      TabOrder = 9
    end
    object stxSC: TStaticText
      Tag = 1
      AlignWithMargins = True
      Left = 3
      Top = 106
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'Service:'
      TabOrder = 10
      Visible = False
    end
    object lblPtSC: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 123
      Top = 106
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'Service Connected 50%'
      TabOrder = 11
    end
    object stxLocation: TStaticText
      Tag = 1
      AlignWithMargins = True
      Left = 3
      Top = 127
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'Location:'
      TabOrder = 12
      Visible = False
    end
    object lblPtLocation: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 123
      Top = 127
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = '2 EAST'
      ShowAccelChar = False
      TabOrder = 13
    end
    object stxRoomBed: TStaticText
      Tag = 1
      AlignWithMargins = True
      Left = 3
      Top = 148
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = 'Room-Bed:'
      TabOrder = 14
      Visible = False
    end
    object lblPtRoomBed: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 123
      Top = 148
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Anchors = []
      AutoSize = False
      Caption = '257-B'
      ShowAccelChar = False
      TabOrder = 15
    end
    object lblCombatVet: TStaticText
      Tag = 2
      AlignWithMargins = True
      Left = 123
      Top = 169
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'Combat Vet'
      TabOrder = 16
    end
    object lblVeteran: TStaticText
      AlignWithMargins = True
      Left = 3
      Top = 169
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'Combat Vet:'
      TabOrder = 17
      Visible = False
    end
    object stxPrimaryProvider: TStaticText
      AlignWithMargins = True
      Left = 3
      Top = 190
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'PC Provider:'
      TabOrder = 18
      Visible = False
    end
    object stxPtPrimaryProvider: TStaticText
      AlignWithMargins = True
      Left = 123
      Top = 190
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'Primary Provider'
      TabOrder = 19
    end
    object stxInpatientProvider: TStaticText
      AlignWithMargins = True
      Left = 3
      Top = 211
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'Inpt Provider:'
      TabOrder = 20
      Visible = False
    end
    object stxPtInpatientProvider: TStaticText
      AlignWithMargins = True
      Left = 123
      Top = 211
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'Inpatient Provider'
      TabOrder = 21
    end
    object stxAttending: TStaticText
      AlignWithMargins = True
      Left = 3
      Top = 232
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'Attending:'
      TabOrder = 22
      Visible = False
    end
    object stxPtAttending: TStaticText
      AlignWithMargins = True
      Left = 123
      Top = 232
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'stxPtAttending'
      TabOrder = 23
    end
    object stxLastVisitLocation: TStaticText
      AlignWithMargins = True
      Left = 3
      Top = 253
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'Last Location:'
      TabOrder = 24
      Visible = False
    end
    object stxPtLastVisitLocation: TStaticText
      AlignWithMargins = True
      Left = 123
      Top = 253
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'Last Location'
      TabOrder = 25
    end
    object stxLastVisitDate: TStaticText
      AlignWithMargins = True
      Left = 3
      Top = 274
      Width = 114
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'Last Visited:'
      TabOrder = 26
      Visible = False
    end
    object stxPtLastVisitDate: TStaticText
      AlignWithMargins = True
      Left = 123
      Top = 274
      Width = 191
      Height = 19
      Margins.Top = 1
      Margins.Bottom = 1
      Align = alClient
      Caption = 'stxPtLastVisitDate'
      TabOrder = 27
    end
    object Memo: TCaptionMemo
      AlignWithMargins = True
      Left = 3
      Top = 297
      Width = 311
      Height = 106
      Align = alClient
      HideSelection = False
      Lines.Strings = (
        'Memo')
      ReadOnly = True
      TabOrder = 28
      Visible = False
      WantReturns = False
      OnEnter = MemoEnter
      OnKeyDown = MemoKeyDown
      Caption = ''
    end
  end
  object lblPtName: TStaticText
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 317
    Height = 17
    Margins.Bottom = 0
    Align = alTop
    Caption = 'Winchester,Charles Emerson'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
end
