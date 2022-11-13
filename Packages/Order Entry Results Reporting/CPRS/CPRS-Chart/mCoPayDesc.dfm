object fraCoPayDesc: TfraCoPayDesc
  Left = 0
  Top = 0
  Width = 500
  Height = 204
  Anchors = [akLeft, akTop, akRight]
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  ParentFont = False
  ParentShowHint = False
  ShowHint = True
  TabOrder = 0
  object pnlSCandRD: TPanel
    Left = 0
    Top = 0
    Width = 250
    Height = 204
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = -3
    ExplicitTop = -6
    ExplicitWidth = 264
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
    object memSCDisplay: TCaptionMemo
      Left = 0
      Top = 22
      Width = 250
      Height = 182
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
  object pnlRight: TPanel
    Left = 250
    Top = 0
    Width = 250
    Height = 204
    Align = alRight
    BevelOuter = bvNone
    Caption = 'pnlRight'
    ShowCaption = False
    TabOrder = 1
    ExplicitLeft = 368
    object ScrollBox2: TScrollBox
      Left = 0
      Top = 22
      Width = 250
      Height = 182
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 32
      ExplicitTop = 80
      ExplicitWidth = 185
      ExplicitHeight = 41
      object GridPanel1: TGridPanel
        Left = 0
        Top = 0
        Width = 246
        Height = 175
        Align = alTop
        Caption = 'GridPanel1'
        ColumnCollection = <
          item
            SizeStyle = ssAbsolute
            Value = 56.000000000000000000
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
            Value = 24.000000000000000000
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
          end>
        ShowCaption = False
        TabOrder = 0
        object lblAO: TVA508StaticText
          Name = 'lblAO'
          Left = 29
          Top = 1
          Width = 23
          Height = 15
          Align = alRight
          Alignment = taLeftJustify
          Caption = 'AO -'
          TabOrder = 0
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 16
          ExplicitTop = 4
          ExplicitHeight = 18
        end
        object lblAO2: TVA508StaticText
          Name = 'lblAO2'
          Left = 57
          Top = 1
          Width = 115
          Height = 15
          Align = alLeft
          Alignment = taLeftJustify
          AutoSize = True
          Caption = 'Agent &Orange Exposure'
          TabOrder = 1
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 50
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblSC: TVA508StaticText
          Name = 'lblSC'
          Left = 30
          Top = 25
          Width = 22
          Height = 15
          Align = alRight
          Alignment = taLeftJustify
          Caption = 'SC -'
          TabOrder = 2
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 20
          ExplicitTop = 2
          ExplicitHeight = 18
        end
        object lblSC2: TVA508StaticText
          Name = 'lblSC2'
          Left = 57
          Top = 25
          Width = 140
          Height = 15
          Align = alLeft
          Alignment = taLeftJustify
          AutoSize = True
          Caption = 'Service &Connected Condition'
          TabOrder = 3
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 50
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblCV: TVA508StaticText
          Name = 'lblCV'
          Left = 30
          Top = 44
          Width = 22
          Height = 15
          Align = alRight
          Alignment = taLeftJustify
          Caption = 'CV -'
          TabOrder = 4
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 20
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblCV2: TVA508StaticText
          Name = 'lblCV2'
          Left = 57
          Top = 44
          Width = 142
          Height = 15
          Align = alLeft
          Alignment = taLeftJustify
          AutoSize = True
          Caption = 'Combat &Vet (Combat Related)'
          TabOrder = 5
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 50
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblIR: TVA508StaticText
          Name = 'lblIR'
          Left = 35
          Top = 63
          Width = 19
          Height = 15
          Align = alRight
          Alignment = taLeftJustify
          Caption = 'IR -'
          TabOrder = 6
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 21
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblIR2: TVA508StaticText
          Name = 'lblIR2'
          Left = 57
          Top = 63
          Width = 133
          Height = 15
          Align = alLeft
          Alignment = taLeftJustify
          AutoSize = True
          Caption = 'Ionizing &Radiation Exposure'
          TabOrder = 7
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 50
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblSWAC: TVA508StaticText
          Name = 'lblSWAC'
          Left = 8
          Top = 82
          Width = 40
          Height = 15
          Align = alRight
          Alignment = taLeftJustify
          Caption = 'SWAC -'
          TabOrder = 8
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 3
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblSWAC2: TVA508StaticText
          Name = 'lblSWAC2'
          Left = 57
          Top = 82
          Width = 127
          Height = 15
          Align = alLeft
          Alignment = taLeftJustify
          AutoSize = True
          Caption = 'Southwest &Asia Conditions'
          TabOrder = 9
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 50
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblSHAD: TVA508StaticText
          Name = 'lblSHAD'
          Left = 19
          Top = 101
          Width = 31
          Height = 15
          Align = alRight
          Alignment = taLeftJustify
          Caption = 'SHD -'
          TabOrder = 10
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 13
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblSHAD2: TVA508StaticText
          Name = 'lblSHAD2'
          Left = 57
          Top = 101
          Width = 151
          Height = 15
          Align = alLeft
          Alignment = taLeftJustify
          AutoSize = True
          Caption = 'Shipboard &Hazard and Defense'
          TabOrder = 11
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 54
          ExplicitTop = 110
          ExplicitHeight = 18
        end
        object lblMST: TVA508StaticText
          Name = 'lblMST'
          Left = 19
          Top = 120
          Width = 31
          Height = 15
          Align = alRight
          Alignment = taLeftJustify
          Caption = 'MST -'
          TabOrder = 12
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 13
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblMST2: TVA508StaticText
          Name = 'lblMST2'
          Left = 57
          Top = 120
          Width = 25
          Height = 15
          Align = alLeft
          Alignment = taLeftJustify
          AutoSize = True
          Caption = '&MST'
          TabOrder = 13
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 50
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblHNC: TVA508StaticText
          Name = 'lblHNC'
          Left = 19
          Top = 139
          Width = 31
          Height = 15
          Align = alRight
          Alignment = taLeftJustify
          Caption = 'HNC -'
          TabOrder = 14
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 14
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblHNC2: TVA508StaticText
          Name = 'lblHNC2'
          Left = 57
          Top = 139
          Width = 129
          Height = 15
          Align = alLeft
          Alignment = taLeftJustify
          AutoSize = True
          Caption = 'Head and/or &Neck Cancer'
          TabOrder = 15
          TabStop = True
          OnEnter = lblEnter
          OnExit = lblExit
          ShowAccelChar = True
          ExplicitLeft = 50
          ExplicitTop = 0
          ExplicitHeight = 18
        end
        object lblCL: TVA508StaticText
          Name = 'lblCL'
          Left = 32
          Top = 158
          Width = 21
          Height = 15
          Align = alRight
          Alignment = taLeftJustify
          Caption = 'CL -'
          TabOrder = 16
          ShowAccelChar = True
          ExplicitLeft = 20
          ExplicitTop = 157
          ExplicitHeight = 18
        end
        object lblCL2: TVA508StaticText
          Name = 'lblCL2'
          Left = 57
          Top = 158
          Width = 70
          Height = 15
          Align = alLeft
          Alignment = taLeftJustify
          AutoSize = True
          Caption = 'Camp Lejeune'
          TabOrder = 17
          ShowAccelChar = True
          ExplicitLeft = 110
          ExplicitTop = 157
          ExplicitHeight = 18
        end
      end
    end
    object lblCaption: TStaticText
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 244
      Height = 16
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Outpatient Medications Related To:'
      TabOrder = 1
      ExplicitWidth = 253
    end
  end
end
