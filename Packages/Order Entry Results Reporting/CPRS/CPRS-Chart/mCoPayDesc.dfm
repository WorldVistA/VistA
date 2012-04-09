object fraCoPayDesc: TfraCoPayDesc
  Left = 0
  Top = 0
  Width = 592
  Height = 157
  Anchors = [akLeft, akTop, akRight]
  ParentShowHint = False
  ShowHint = True
  TabOrder = 0
  object pnlRight: TPanel
    Left = 304
    Top = 0
    Width = 288
    Height = 157
    Align = alRight
    Alignment = taLeftJustify
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 310
    object Spacer2: TLabel
      Left = 0
      Top = 16
      Width = 288
      Height = 3
      Align = alTop
      AutoSize = False
    end
    object lblCaption: TStaticText
      Left = 0
      Top = 0
      Width = 288
      Height = 16
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Outpatient Medications Related To:'
      TabOrder = 0
    end
    object pnlMain: TPanel
      Left = 16
      Top = 15
      Width = 265
      Height = 141
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object spacer1: TLabel
        Left = 2
        Top = 2
        Width = 261
        Height = 3
        Align = alTop
        AutoSize = False
        ExplicitWidth = 213
      end
      object pnlHNC: TPanel
        Left = 2
        Top = 112
        Width = 261
        Height = 15
        Align = alTop
        Alignment = taRightJustify
        BevelOuter = bvNone
        TabOrder = 7
        object lblHNC2: TVA508StaticText
          Name = 'lblHNC2'
          Left = 50
          Top = 0
          Width = 125
          Height = 15
          Caption = 'Head and/or &Neck Cancer'
          TabOrder = 1
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
        object lblHNC: TVA508StaticText
          Name = 'lblHNC'
          Left = 12
          Top = 0
          Width = 30
          Height = 15
          Caption = 'HNC -'
          TabOrder = 0
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
      end
      object pnlMST: TPanel
        Left = 2
        Top = 97
        Width = 261
        Height = 15
        Align = alTop
        Alignment = taRightJustify
        BevelOuter = bvNone
        TabOrder = 6
        object lblMST2: TVA508StaticText
          Name = 'lblMST2'
          Left = 50
          Top = 0
          Width = 22
          Height = 15
          Caption = '&MST'
          TabOrder = 1
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
        object lblMST: TVA508StaticText
          Name = 'lblMST'
          Left = 13
          Top = 0
          Width = 29
          Height = 15
          Caption = 'MST -'
          TabOrder = 0
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
      end
      object pnlSWAC: TPanel
        Left = 2
        Top = 65
        Width = 261
        Height = 15
        Align = alTop
        Alignment = taRightJustify
        BevelOuter = bvNone
        TabOrder = 4
        object lblSWAC2: TVA508StaticText
          Name = 'lblSWAC2'
          Left = 50
          Top = 0
          Width = 129
          Height = 15
          Caption = 'Southwest &Asia Conditions'
          TabOrder = 1
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
        object lblSWAC: TVA508StaticText
          Name = 'lblSWAC'
          Left = 3
          Top = 0
          Width = 39
          Height = 15
          Caption = 'SWAC -'
          TabOrder = 0
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
      end
      object pnlIR: TPanel
        Left = 2
        Top = 50
        Width = 261
        Height = 15
        Align = alTop
        Alignment = taRightJustify
        BevelOuter = bvNone
        TabOrder = 3
        object lblIR2: TVA508StaticText
          Name = 'lblIR2'
          Left = 50
          Top = 0
          Width = 135
          Height = 15
          Caption = 'Ionizing &Radiation Exposure'
          TabOrder = 1
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
        object lblIR: TVA508StaticText
          Name = 'lblIR'
          Left = 21
          Top = 0
          Width = 20
          Height = 15
          Caption = 'IR -'
          TabOrder = 0
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
      end
      object pnlAO: TPanel
        Left = 2
        Top = 35
        Width = 261
        Height = 15
        Align = alTop
        Alignment = taRightJustify
        BevelOuter = bvNone
        TabOrder = 2
        object lblAO2: TVA508StaticText
          Name = 'lblAO2'
          Left = 50
          Top = 0
          Width = 118
          Height = 15
          Caption = 'Agent &Orange Exposure'
          TabOrder = 1
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
        object lblAO: TVA508StaticText
          Name = 'lblAO'
          Left = 18
          Top = 0
          Width = 24
          Height = 15
          Caption = 'AO -'
          TabOrder = 0
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
      end
      object pnlSC: TPanel
        Left = 2
        Top = 5
        Width = 261
        Height = 15
        Align = alTop
        Alignment = taRightJustify
        BevelOuter = bvNone
        TabOrder = 0
        object lblSC2: TVA508StaticText
          Name = 'lblSC2'
          Left = 50
          Top = 0
          Width = 140
          Height = 15
          Caption = 'Service &Connected Condition'
          TabOrder = 1
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
        object lblSC: TVA508StaticText
          Name = 'lblSC'
          Left = 20
          Top = 2
          Width = 22
          Height = 15
          Caption = 'SC -'
          TabOrder = 0
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
      end
      object pnlCV: TPanel
        Left = 2
        Top = 20
        Width = 261
        Height = 15
        Align = alTop
        Alignment = taRightJustify
        BevelOuter = bvNone
        TabOrder = 1
        object lblCV2: TVA508StaticText
          Name = 'lblCV2'
          Left = 50
          Top = 0
          Width = 146
          Height = 15
          Caption = 'Combat &Vet (Combat Related)'
          TabOrder = 1
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
        object lblCV: TVA508StaticText
          Name = 'lblCV'
          Left = 20
          Top = 0
          Width = 22
          Height = 15
          Caption = 'CV -'
          TabOrder = 0
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
      end
      object pnlSHD: TPanel
        Left = 2
        Top = 80
        Width = 261
        Height = 17
        Align = alTop
        Alignment = taRightJustify
        BevelOuter = bvNone
        TabOrder = 5
        object lblSHAD: TVA508StaticText
          Name = 'lblSHAD'
          Left = 13
          Top = 0
          Width = 29
          Height = 15
          Caption = 'SHD -'
          TabOrder = 0
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
        object lblSHAD2: TVA508StaticText
          Name = 'lblSHAD2'
          Left = 51
          Top = 0
          Width = 151
          Height = 15
          Caption = 'Shipboard &Hazard and Defense'
          TabOrder = 1
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
        end
      end
    end
  end
  object pnlSCandRD: TPanel
    Left = 0
    Top = 0
    Width = 304
    Height = 157
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblSCDisplay: TLabel
      Left = 0
      Top = 0
      Width = 304
      Height = 17
      Align = alTop
      AutoSize = False
      Caption = 'Service Connection && Rated Disabilities'
      Layout = tlCenter
    end
    object memSCDisplay: TCaptionMemo
      Left = 0
      Top = 17
      Width = 304
      Height = 140
      Align = alClient
      Color = clBtnFace
      Lines.Strings = (
        '')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      Caption = 'Service Connection and Rated Disabilities'
    end
  end
end
