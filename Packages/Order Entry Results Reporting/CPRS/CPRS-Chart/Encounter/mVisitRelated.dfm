inherited fraVisitRelated: TfraVisitRelated
  Width = 318
  Height = 289
  Align = alClient
  ExplicitWidth = 318
  ExplicitHeight = 289
  object sbMain: TScrollBox
    Left = 0
    Top = 0
    Width = 318
    Height = 289
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    object pnlMain: TPanel
      Left = 0
      Top = 0
      Width = 318
      Height = 265
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object gbVisitRelatedTo: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 312
        Height = 259
        Align = alClient
        Caption = 'Visit Related To'
        TabOrder = 0
        object lblNoSAAvailable: TStaticText
          Left = 2
          Top = 17
          Width = 308
          Height = 19
          Align = alTop
          Caption = 'No Special Authorities to select'
          TabOrder = 1
          TabStop = True
          Visible = False
        end
        object gpMain: TGridPanel
          AlignWithMargins = True
          Left = 5
          Top = 36
          Width = 302
          Height = 221
          Margins.Top = 0
          Margins.Bottom = 0
          Align = alClient
          BevelEdges = []
          BevelOuter = bvNone
          ColumnCollection = <
            item
              SizeStyle = ssAbsolute
              Value = 23.000000000000000000
            end
            item
              Value = 100.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = lblYes
              Row = 0
            end
            item
              Column = 1
              Control = lblNo
              Row = 0
            end>
          RowCollection = <
            item
              SizeStyle = ssAbsolute
              Value = 15.000000000000000000
            end
            item
              SizeStyle = ssAuto
            end>
          ShowCaption = False
          TabOrder = 0
          object lblYes: TLabel
            Left = 0
            Top = 0
            Width = 23
            Height = 15
            Align = alBottom
            Caption = 'Yes'
            Layout = tlBottom
            ExplicitWidth = 17
          end
          object lblNo: TLabel
            Left = 23
            Top = 0
            Width = 279
            Height = 15
            Align = alBottom
            Caption = 'No'
            Layout = tlBottom
            ExplicitWidth = 16
          end
        end
      end
    end
  end
  object bHint: TBalloonHint
    Style = bhsStandard
    HideAfter = 15000
    Position = hpBelow
    Left = 16
    Top = 44
  end
  object appEvents: TApplicationEvents
    OnMessage = appEventsMessage
    Left = 64
    Top = 44
  end
end
