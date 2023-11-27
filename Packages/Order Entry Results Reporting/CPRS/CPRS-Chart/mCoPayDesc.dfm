object fraCoPayDesc: TfraCoPayDesc
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
        Width = 248
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
        Width = 254
        Height = 188
        Align = alClient
        BorderStyle = bsSingle
        TabOrder = 0
        object memSCDisplay: TCaptionMemo
          Left = 1
          Top = 1
          Width = 248
          Height = 182
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
        Width = 248
        Height = 17
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'Outpatient Medications Related To:'
        TabOrder = 0
      end
      object pnlBorderRight: TPanel
        Left = 0
        Top = 23
        Width = 254
        Height = 187
        Align = alClient
        BorderStyle = bsSingle
        TabOrder = 1
        object gpRight: TGridPanel
          Left = 1
          Top = 1
          Width = 248
          Height = 181
          Align = alClient
          BevelOuter = bvNone
          ColumnCollection = <
            item
              SizeStyle = ssAbsolute
              Value = 50.000000000000000000
            end
            item
              Value = 100.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = lblAO
              Row = 0
            end
            item
              Column = 1
              Control = lblAO2
              Row = 0
            end
            item
              Column = 0
              Control = lblSC
              Row = 1
            end
            item
              Column = 1
              Control = lblSC2
              Row = 1
            end
            item
              Column = 0
              Control = lblCV
              Row = 2
            end
            item
              Column = 1
              Control = lblCV2
              Row = 2
            end
            item
              Column = 0
              Control = lblIR
              Row = 3
            end
            item
              Column = 1
              Control = lblIR2
              Row = 3
            end
            item
              Column = 0
              Control = lblSWAC
              Row = 4
            end
            item
              Column = 1
              Control = lblSWAC2
              Row = 4
            end
            item
              Column = 0
              Control = lblSHAD
              Row = 5
            end
            item
              Column = 1
              Control = lblSHAD2
              Row = 5
            end
            item
              Column = 0
              Control = lblMST
              Row = 6
            end
            item
              Column = 1
              Control = lblMST2
              Row = 6
            end
            item
              Column = 0
              Control = lblHNC
              Row = 7
            end
            item
              Column = 1
              Control = lblHNC2
              Row = 7
            end
            item
              Column = 0
              Control = lblCL
              Row = 8
            end
            item
              Column = 1
              Control = lblCL2
              Row = 8
            end>
          RowCollection = <
            item
              SizeStyle = ssAbsolute
              Value = 19.000000000000000000
            end
            item
              SizeStyle = ssAbsolute
              Value = 19.000000000000000000
            end
            item
              SizeStyle = ssAbsolute
              Value = 19.000000000000000000
            end
            item
              SizeStyle = ssAbsolute
              Value = 19.000000000000000000
            end
            item
              SizeStyle = ssAbsolute
              Value = 19.000000000000000000
            end
            item
              SizeStyle = ssAbsolute
              Value = 19.000000000000000000
            end
            item
              SizeStyle = ssAbsolute
              Value = 19.000000000000000000
            end
            item
              SizeStyle = ssAbsolute
              Value = 19.000000000000000000
            end
            item
              SizeStyle = ssAbsolute
              Value = 19.000000000000000000
            end
            item
              SizeStyle = ssAuto
            end>
          ShowCaption = False
          TabOrder = 0
          OnResize = gpRightResize
          object lblAO: TVA508StaticText
            Name = 'lblAO'
            Left = 26
            Top = 0
            Width = 24
            Height = 19
            Align = alRight
            Alignment = taLeftJustify
            Caption = 'AO -'
            TabOrder = 0
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
            ExplicitLeft = 27
          end
          object lblAO2: TVA508StaticText
            Name = 'lblAO2'
            Left = 50
            Top = 0
            Width = 121
            Height = 19
            Align = alLeft
            Alignment = taLeftJustify
            AutoSize = True
            Caption = ' Agent &Orange Exposure'
            TabOrder = 1
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
          end
          object lblSC: TVA508StaticText
            Name = 'lblSC'
            Left = 28
            Top = 19
            Width = 22
            Height = 19
            Align = alRight
            Alignment = taLeftJustify
            Caption = 'SC -'
            TabOrder = 2
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
            ExplicitHeight = 15
          end
          object lblSC2: TVA508StaticText
            Name = 'lblSC2'
            Left = 50
            Top = 19
            Width = 143
            Height = 19
            Align = alLeft
            Alignment = taLeftJustify
            AutoSize = True
            Caption = ' Service &Connected Condition'
            TabOrder = 3
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
          end
          object lblCV: TVA508StaticText
            Name = 'lblCV'
            Left = 28
            Top = 38
            Width = 22
            Height = 19
            Align = alRight
            Alignment = taLeftJustify
            Caption = 'CV -'
            TabOrder = 4
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
            ExplicitHeight = 15
          end
          object lblCV2: TVA508StaticText
            Name = 'lblCV2'
            Left = 50
            Top = 38
            Width = 149
            Height = 19
            Align = alLeft
            Alignment = taLeftJustify
            AutoSize = True
            Caption = ' Combat &Vet (Combat Related)'
            TabOrder = 5
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
          end
          object lblIR: TVA508StaticText
            Name = 'lblIR'
            Left = 30
            Top = 57
            Width = 20
            Height = 19
            Align = alRight
            Alignment = taLeftJustify
            Caption = 'IR -'
            TabOrder = 6
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
            ExplicitLeft = 31
          end
          object lblIR2: TVA508StaticText
            Name = 'lblIR2'
            Left = 50
            Top = 57
            Width = 138
            Height = 19
            Align = alLeft
            Alignment = taLeftJustify
            AutoSize = True
            Caption = ' Ionizing &Radiation Exposure'
            TabOrder = 7
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
          end
          object lblSWAC: TVA508StaticText
            Name = 'lblSWAC'
            Left = 11
            Top = 76
            Width = 39
            Height = 19
            Align = alRight
            Alignment = taLeftJustify
            Caption = 'SWAC -'
            TabOrder = 8
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
            ExplicitLeft = 10
          end
          object lblSWAC2: TVA508StaticText
            Name = 'lblSWAC2'
            Left = 50
            Top = 76
            Width = 132
            Height = 19
            Align = alLeft
            Alignment = taLeftJustify
            AutoSize = True
            Caption = ' Southwest &Asia Conditions'
            TabOrder = 9
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
          end
          object lblSHAD: TVA508StaticText
            Name = 'lblSHAD'
            Left = 21
            Top = 95
            Width = 29
            Height = 19
            Align = alRight
            Alignment = taLeftJustify
            Caption = 'SHD -'
            TabOrder = 10
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
            ExplicitLeft = 19
          end
          object lblSHAD2: TVA508StaticText
            Name = 'lblSHAD2'
            Left = 50
            Top = 95
            Width = 154
            Height = 19
            Align = alLeft
            Alignment = taLeftJustify
            AutoSize = True
            Caption = ' Shipboard &Hazard and Defense'
            TabOrder = 11
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
          end
          object lblMST: TVA508StaticText
            Name = 'lblMST'
            Left = 21
            Top = 114
            Width = 29
            Height = 19
            Align = alRight
            Alignment = taLeftJustify
            Caption = 'MST -'
            TabOrder = 12
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
            ExplicitLeft = 19
          end
          object lblMST2: TVA508StaticText
            Name = 'lblMST2'
            Left = 50
            Top = 114
            Width = 25
            Height = 19
            Align = alLeft
            Alignment = taLeftJustify
            AutoSize = True
            Caption = ' &MST'
            TabOrder = 13
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
          end
          object lblHNC: TVA508StaticText
            Name = 'lblHNC'
            Left = 20
            Top = 133
            Width = 30
            Height = 19
            Align = alRight
            Alignment = taLeftJustify
            Caption = 'HNC -'
            TabOrder = 14
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
            ExplicitLeft = 19
          end
          object lblHNC2: TVA508StaticText
            Name = 'lblHNC2'
            Left = 50
            Top = 133
            Width = 128
            Height = 19
            Align = alLeft
            Alignment = taLeftJustify
            AutoSize = True
            Caption = ' Head and/or &Neck Cancer'
            TabOrder = 15
            TabStop = True
            OnEnter = lblEnter
            OnExit = lblExit
            ShowAccelChar = True
          end
          object lblCL: TVA508StaticText
            Name = 'lblCL'
            Left = 29
            Top = 152
            Width = 21
            Height = 19
            Align = alRight
            Alignment = taLeftJustify
            Caption = 'CL -'
            TabOrder = 16
            ShowAccelChar = True
            ExplicitHeight = 15
          end
          object lblCL2: TVA508StaticText
            Name = 'lblCL2'
            Left = 50
            Top = 152
            Width = 73
            Height = 19
            Align = alLeft
            Alignment = taLeftJustify
            AutoSize = True
            Caption = ' Camp Lejeune'
            TabOrder = 17
            ShowAccelChar = True
          end
        end
      end
    end
  end
end
