object fraVitalHiLo: TfraVitalHiLo
  Left = 0
  Top = 0
  Width = 181
  Height = 226
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 181
    Height = 226
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object pnlValue: TPanel
      Left = 1
      Top = 176
      Width = 179
      Height = 49
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      OnResize = pnlValueResize
      object gb: TGroupBox
        Left = 0
        Top = 0
        Width = 179
        Height = 49
        Align = alClient
        Caption = 'gb'
        TabOrder = 0
        object edtValue: TEdit
          Left = 56
          Top = 16
          Width = 57
          Height = 21
          TabOrder = 0
          Text = 'edtValue'
          OnExit = edtValueExit
        end
      end
    end
    object pnlSlider: TPanel
      Left = 1
      Top = 50
      Width = 179
      Height = 126
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      OnResize = pnlSliderResize
      object tkbar: TTrackBar
        Left = 40
        Top = 0
        Width = 38
        Height = 126
        Align = alLeft
        Orientation = trVertical
        Frequency = 4
        TabOrder = 0
        TabStop = False
        OnChange = tkbarChange
      end
      object pnlMinMax: TPanel
        Left = 78
        Top = 0
        Width = 101
        Height = 126
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 1
        object lblMax: TLabel
          Left = 5
          Top = 5
          Width = 30
          Height = 13
          Align = alTop
          Caption = 'lblMax'
        end
        object lblMin: TLabel
          Left = 5
          Top = 108
          Width = 26
          Height = 13
          Align = alBottom
          Caption = 'lblMin'
        end
      end
      object pnlSpacer: TPanel
        Left = 0
        Top = 0
        Width = 40
        Height = 126
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 2
      end
    end
    object pnlHeader: TPanel
      Left = 1
      Top = 1
      Width = 179
      Height = 49
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 4
      Color = clHighlight
      ParentBackground = False
      TabOrder = 2
      object lblName: TLabel
        Left = 4
        Top = 4
        Width = 46
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'lblName'
        Color = clHighlight
        FocusControl = edtValue
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object lblHiLo: TLabel
        Left = 4
        Top = 17
        Width = 40
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'lblHiLo'
        Color = clHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object lblRange: TLabel
        Left = 4
        Top = 30
        Width = 51
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'lblRange'
        Color = clHighlight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlightText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
    end
  end
end
