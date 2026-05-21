object frmORSymbolLabelPE: TfrmORSymbolLabelPE
  Left = 0
  Top = 0
  Caption = 'frmORSymbolLabelPE'
  ClientHeight = 544
  ClientWidth = 971
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  TextHeight = 20
  object splMain: TSplitter
    Left = 473
    Top = 0
    Height = 544
    ExplicitLeft = 432
    ExplicitTop = 264
    ExplicitHeight = 100
  end
  object pnlRight: TPanel
    Left = 476
    Top = 0
    Width = 495
    Height = 544
    Margins.Top = 6
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 468
    ExplicitWidth = 499
    ExplicitHeight = 543
    object gpButtons: TGridPanel
      Left = 1
      Top = 502
      Width = 493
      Height = 41
      Align = alBottom
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
          Control = btnOK
          Row = 0
        end
        item
          Column = 1
          Control = btnCancel
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 1
      ExplicitTop = 501
      ExplicitWidth = 497
      object btnOK: TBitBtn
        Tag = 99
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 240
        Height = 33
        Align = alClient
        Kind = bkOK
        NumGlyphs = 2
        TabOrder = 0
        OnEnter = ctrlEnter
        ExplicitWidth = 244
      end
      object btnCancel: TBitBtn
        Tag = 99
        AlignWithMargins = True
        Left = 250
        Top = 4
        Width = 239
        Height = 33
        Align = alClient
        Kind = bkCancel
        NumGlyphs = 2
        TabOrder = 1
        OnEnter = ctrlEnter
        ExplicitLeft = 254
        ExplicitWidth = 243
      end
    end
    object gpMain: TGridPanel
      Left = 1
      Top = 161
      Width = 493
      Height = 341
      Align = alClient
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 12.000000000000000000
        end
        item
          Value = 12.000000000000000000
        end
        item
          Value = 12.000000000000000000
        end
        item
          Value = 12.000000000000000000
        end
        item
          Value = 12.000000000000000000
        end
        item
          Value = 12.000000000000000000
        end
        item
          Value = 28.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = lblForegroundValue
          Row = 1
        end
        item
          Column = 6
          Control = lblForegroundColor
          Row = 1
        end
        item
          Column = 0
          Control = edtForegroundValue
          Row = 2
        end
        item
          Column = 0
          Control = btnForegroundValueKeep
          Row = 3
        end
        item
          Column = 3
          Control = btnForegroundNext
          Row = 3
        end
        item
          Column = 4
          Control = btnForegroundPrev
          Row = 3
        end
        item
          Column = 6
          Control = lblGap1
          Row = 3
        end
        item
          Column = 0
          ColumnSpan = 7
          Control = lblGap2
          Row = 4
        end
        item
          Column = 0
          Control = lblBackgroundValue
          Row = 6
        end
        item
          Column = 6
          Control = lblBackgroundColor
          Row = 6
        end
        item
          Column = 0
          Control = edtBackgroundValue
          Row = 7
        end
        item
          Column = 0
          Control = btnBackgroundValueKeep
          Row = 8
        end
        item
          Column = 3
          Control = btnBackgroundNext
          Row = 8
        end
        item
          Column = 4
          Control = btnBackgroundPrev
          Row = 8
        end
        item
          Column = 6
          Control = lblGap3
          Row = 8
        end
        item
          Column = 6
          Control = clrForeground
          Row = 2
        end
        item
          Column = 6
          Control = clrBackground
          Row = 7
        end
        item
          Column = 1
          ColumnSpan = 5
          Control = lblForegroundName
          Row = 1
        end
        item
          Column = 1
          ColumnSpan = 5
          Control = edtForegroundName
          Row = 2
        end
        item
          Column = 1
          ColumnSpan = 5
          Control = lblBackgroundName
          Row = 6
        end
        item
          Column = 1
          ColumnSpan = 5
          Control = edtBackgroundName
          Row = 7
        end
        item
          Column = 0
          ColumnSpan = 7
          Control = lblForeground
          Row = 0
        end
        item
          Column = 0
          ColumnSpan = 7
          Control = lblBackground
          Row = 5
        end
        item
          Column = 2
          Control = btnForegroundNameKeep
          Row = 3
        end
        item
          Column = 2
          Control = btnBackgroundNameKeep
          Row = 8
        end
        item
          Column = 1
          Control = lblGap4
          Row = 3
        end
        item
          Column = 1
          Control = lblGap5
          Row = 8
        end
        item
          Column = 5
          Control = btnForegroundClear
          Row = 3
        end
        item
          Column = 5
          Control = btnBackgroundClear
          Row = 8
        end>
      RowCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 34.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 34.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 10.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 34.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 34.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 0
      ExplicitWidth = 497
      ExplicitHeight = 340
      object lblForegroundValue: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 33
        Width = 53
        Height = 24
        Align = alClient
        BiDiMode = bdLeftToRight
        Caption = 'Value'
        ParentBiDiMode = False
        Layout = tlCenter
        ExplicitWidth = 36
        ExplicitHeight = 20
      end
      object lblForegroundColor: TLabel
        AlignWithMargins = True
        Left = 358
        Top = 33
        Width = 132
        Height = 24
        Align = alClient
        Caption = 'Color'
        Layout = tlCenter
        ExplicitLeft = 364
        ExplicitWidth = 36
        ExplicitHeight = 20
      end
      object edtForegroundValue: TEdit
        AlignWithMargins = True
        Left = 3
        Top = 63
        Width = 53
        Height = 28
        Align = alClient
        NumbersOnly = True
        TabOrder = 0
        OnEnter = ctrlEnter
        OnKeyDown = edtKeyDown
        ExplicitWidth = 54
      end
      object btnForegroundValueKeep: TButton
        AlignWithMargins = True
        Left = 3
        Top = 97
        Width = 53
        Height = 28
        Align = alClient
        Caption = 'Keep'
        TabOrder = 1
        OnClick = btnKeepClick
        OnEnter = ctrlEnter
        ExplicitWidth = 54
      end
      object btnForegroundNext: TButton
        Tag = 1
        AlignWithMargins = True
        Left = 180
        Top = 97
        Width = 54
        Height = 28
        Align = alClient
        Caption = 'Next'
        TabOrder = 4
        OnClick = btnNextClick
        OnEnter = ctrlEnter
        ExplicitLeft = 183
      end
      object btnForegroundPrev: TButton
        Tag = 1
        AlignWithMargins = True
        Left = 240
        Top = 97
        Width = 53
        Height = 28
        Align = alClient
        Caption = 'Prev'
        TabOrder = 5
        OnClick = btnPrevClick
        OnEnter = ctrlEnter
        ExplicitLeft = 243
        ExplicitWidth = 55
      end
      object lblGap1: TLabel
        AlignWithMargins = True
        Left = 358
        Top = 97
        Width = 132
        Height = 28
        Align = alClient
        Alignment = taCenter
        Caption = 'lblGap'
        Layout = tlCenter
        Visible = False
        ExplicitLeft = 364
        ExplicitWidth = 44
        ExplicitHeight = 20
      end
      object lblGap2: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 131
        Width = 487
        Height = 4
        Align = alClient
        Alignment = taCenter
        Caption = 'lblGap'
        Layout = tlCenter
        Visible = False
        ExplicitWidth = 44
        ExplicitHeight = 20
      end
      object lblBackgroundValue: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 171
        Width = 53
        Height = 24
        Align = alClient
        Caption = 'Value'
        Layout = tlCenter
        ExplicitWidth = 36
        ExplicitHeight = 20
      end
      object lblBackgroundColor: TLabel
        AlignWithMargins = True
        Left = 358
        Top = 171
        Width = 132
        Height = 24
        Align = alClient
        Caption = 'Color'
        Layout = tlCenter
        ExplicitLeft = 364
        ExplicitWidth = 36
        ExplicitHeight = 20
      end
      object edtBackgroundValue: TEdit
        Tag = 2
        AlignWithMargins = True
        Left = 3
        Top = 201
        Width = 53
        Height = 28
        Align = alClient
        NumbersOnly = True
        TabOrder = 8
        OnEnter = ctrlEnter
        OnKeyDown = edtKeyDown
        ExplicitWidth = 54
      end
      object btnBackgroundValueKeep: TButton
        Tag = 2
        AlignWithMargins = True
        Left = 3
        Top = 235
        Width = 53
        Height = 28
        Align = alClient
        Caption = 'Keep'
        TabOrder = 9
        OnClick = btnKeepClick
        OnEnter = ctrlEnter
        ExplicitWidth = 54
      end
      object btnBackgroundNext: TButton
        Tag = 3
        AlignWithMargins = True
        Left = 180
        Top = 235
        Width = 54
        Height = 28
        Align = alClient
        Caption = 'Next'
        TabOrder = 12
        OnClick = btnNextClick
        OnEnter = ctrlEnter
        ExplicitLeft = 183
      end
      object btnBackgroundPrev: TButton
        Tag = 3
        AlignWithMargins = True
        Left = 240
        Top = 235
        Width = 53
        Height = 28
        Align = alClient
        Caption = 'Prev'
        TabOrder = 13
        OnClick = btnPrevClick
        OnEnter = ctrlEnter
        ExplicitLeft = 243
        ExplicitWidth = 55
      end
      object lblGap3: TLabel
        AlignWithMargins = True
        Left = 358
        Top = 235
        Width = 132
        Height = 28
        Align = alClient
        Alignment = taCenter
        Caption = 'lblGap'
        Layout = tlCenter
        Visible = False
        ExplicitLeft = 364
        ExplicitWidth = 44
        ExplicitHeight = 20
      end
      object clrForeground: TColorBox
        AlignWithMargins = True
        Left = 358
        Top = 63
        Width = 132
        Height = 22
        Align = alClient
        Selected = clWindowText
        TabOrder = 7
        OnChange = clrChange
        OnEnter = ctrlEnter
        ExplicitLeft = 364
        ExplicitWidth = 134
      end
      object clrBackground: TColorBox
        Tag = 2
        AlignWithMargins = True
        Left = 358
        Top = 201
        Width = 132
        Height = 22
        Align = alClient
        Selected = clWindowText
        TabOrder = 15
        OnChange = clrChange
        OnEnter = ctrlEnter
        ExplicitLeft = 364
        ExplicitWidth = 134
      end
      object lblForegroundName: TLabel
        AlignWithMargins = True
        Left = 62
        Top = 33
        Width = 290
        Height = 24
        Align = alClient
        Caption = 'Name'
        Layout = tlCenter
        ExplicitLeft = 63
        ExplicitWidth = 40
        ExplicitHeight = 20
      end
      object edtForegroundName: TEdit
        Tag = 1
        AlignWithMargins = True
        Left = 62
        Top = 63
        Width = 290
        Height = 28
        Align = alClient
        TabOrder = 2
        OnEnter = ctrlEnter
        OnKeyDown = edtKeyDown
        ExplicitLeft = 63
        ExplicitWidth = 295
      end
      object lblBackgroundName: TLabel
        AlignWithMargins = True
        Left = 62
        Top = 171
        Width = 290
        Height = 24
        Align = alClient
        Caption = 'Name'
        Layout = tlCenter
        ExplicitLeft = 63
        ExplicitWidth = 40
        ExplicitHeight = 20
      end
      object edtBackgroundName: TEdit
        Tag = 3
        AlignWithMargins = True
        Left = 62
        Top = 201
        Width = 290
        Height = 28
        Align = alClient
        TabOrder = 10
        OnEnter = ctrlEnter
        OnKeyDown = edtKeyDown
        ExplicitLeft = 63
        ExplicitWidth = 295
      end
      object lblForeground: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 487
        Height = 24
        Align = alClient
        Caption = 'Foreground Symbol'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitWidth = 131
        ExplicitHeight = 20
      end
      object lblBackground: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 141
        Width = 487
        Height = 24
        Align = alClient
        Caption = 'Background Symbol'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitWidth = 133
        ExplicitHeight = 20
      end
      object btnForegroundNameKeep: TButton
        Tag = 1
        AlignWithMargins = True
        Left = 121
        Top = 97
        Width = 53
        Height = 28
        Align = alClient
        Caption = 'Keep'
        TabOrder = 3
        OnClick = btnKeepClick
        OnEnter = ctrlEnter
        ExplicitLeft = 123
        ExplicitWidth = 54
      end
      object btnBackgroundNameKeep: TButton
        Tag = 3
        AlignWithMargins = True
        Left = 121
        Top = 235
        Width = 53
        Height = 28
        Align = alClient
        Caption = 'Keep'
        TabOrder = 11
        OnClick = btnKeepClick
        OnEnter = ctrlEnter
        ExplicitLeft = 123
        ExplicitWidth = 54
      end
      object lblGap4: TLabel
        AlignWithMargins = True
        Left = 62
        Top = 97
        Width = 53
        Height = 28
        Align = alClient
        Alignment = taCenter
        Caption = 'lblGap'
        Layout = tlCenter
        Visible = False
        ExplicitLeft = 63
        ExplicitWidth = 44
        ExplicitHeight = 20
      end
      object lblGap5: TLabel
        AlignWithMargins = True
        Left = 62
        Top = 235
        Width = 53
        Height = 28
        Align = alClient
        Alignment = taCenter
        Caption = 'lblGap'
        Layout = tlCenter
        Visible = False
        ExplicitLeft = 63
        ExplicitWidth = 44
        ExplicitHeight = 20
      end
      object btnForegroundClear: TButton
        Tag = 1
        AlignWithMargins = True
        Left = 299
        Top = 97
        Width = 53
        Height = 28
        Align = alClient
        Caption = 'Clear'
        TabOrder = 6
        OnClick = btnClearClick
        OnEnter = ctrlEnter
        ExplicitLeft = 304
        ExplicitWidth = 54
      end
      object btnBackgroundClear: TButton
        Tag = 3
        AlignWithMargins = True
        Left = 299
        Top = 235
        Width = 53
        Height = 28
        Align = alClient
        Caption = 'Clear'
        TabOrder = 14
        OnClick = btnClearClick
        OnEnter = ctrlEnter
        ExplicitLeft = 304
        ExplicitWidth = 54
      end
    end
    object gpTop: TGridPanel
      Left = 1
      Top = 1
      Width = 493
      Height = 160
      Align = alTop
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
          ColumnSpan = 2
          Control = symMain
          Row = 0
          RowSpan = 2
        end>
      RowCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      TabOrder = 2
      ExplicitWidth = 497
      object symMain: TORSymbolLabel
        Left = 1
        Top = 1
        Width = 491
        Height = 158
        Align = alClient
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitWidth = 8
        ExplicitHeight = 27
      end
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 473
    Height = 544
    Align = alLeft
    TabOrder = 1
    object lv: TListView
      Tag = 9999
      Left = 1
      Top = 1
      Width = 471
      Height = 542
      Align = alClient
      Columns = <
        item
          Caption = 'Symbol'
          Width = -2
          WidthType = (
            -2)
        end
        item
          Caption = 'Value'
          Width = 60
        end
        item
          Caption = 'Name'
          Width = 320
        end>
      ColumnClick = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe MDL2 Assets'
      Font.Style = []
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      TabOrder = 0
      TabStop = False
      ViewStyle = vsReport
      OnDblClick = lvDblClick
      OnEnter = ctrlEnter
      ExplicitLeft = 3
      ExplicitWidth = 384
    end
  end
end
