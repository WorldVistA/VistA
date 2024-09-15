inherited frmDeferDialog: TfrmDeferDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Defer Item'
  ClientHeight = 314
  ClientWidth = 516
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 282
    Width = 516
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    ExplicitTop = 233
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 357
      Top = 3
      Width = 75
      Height = 26
      Align = alRight
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object cmdDefer: TButton
      AlignWithMargins = True
      Left = 438
      Top = 3
      Width = 75
      Height = 26
      Action = acDefer
      Align = alRight
      TabOrder = 1
    end
  end
  object gbxDeferBy: TGroupBox
    AlignWithMargins = True
    Left = 312
    Top = 3
    Width = 201
    Height = 276
    Align = alRight
    Caption = ' Defer Until '
    TabOrder = 1
    ExplicitHeight = 240
    object Bevel2: TBevel
      AlignWithMargins = True
      Left = 5
      Top = 213
      Width = 191
      Height = 4
      Align = alBottom
      Shape = bsTopLine
      ExplicitLeft = 10
      ExplicitTop = 136
      ExplicitWidth = 163
    end
    object lblCustom: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 194
      Width = 191
      Height = 13
      Align = alBottom
      Caption = 'Custom'
      Transparent = False
      ExplicitLeft = 3
      ExplicitTop = 164
    end
    object cbxDeferBy: TComboBox
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 191
      Height = 21
      Align = alTop
      Style = csDropDownList
      TabOrder = 0
      OnChange = acNewDeferalClickedExecute
    end
    object stxtDeferUntilDate: TStaticText
      AlignWithMargins = True
      Left = 5
      Top = 45
      Width = 191
      Height = 17
      Align = alTop
      Caption = 'stxtDeferUntilDate'
      TabOrder = 1
      ExplicitTop = 52
      ExplicitWidth = 90
    end
    object stxtDeferUntilTime: TStaticText
      AlignWithMargins = True
      Left = 5
      Top = 68
      Width = 191
      Height = 17
      Align = alTop
      Caption = 'stxtDeferUntilTime'
      TabOrder = 2
      ExplicitWidth = 90
    end
    object gp: TGridPanel
      Left = 2
      Top = 220
      Width = 197
      Height = 54
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'gp'
      ColumnCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 72.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = lblDate
          Row = 0
        end
        item
          Column = 1
          Control = dtpDate
          Row = 0
        end
        item
          Column = 0
          Control = lblTime
          Row = 1
        end
        item
          Column = 1
          Control = dtpTime
          Row = 1
        end>
      ParentColor = True
      RowCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ShowCaption = False
      TabOrder = 3
      ExplicitTop = 184
      ExplicitWidth = 180
      object lblDate: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 66
        Height = 21
        Align = alClient
        Caption = 'Date:'
        ExplicitWidth = 26
        ExplicitHeight = 13
      end
      object dtpDate: TDateTimePicker
        AlignWithMargins = True
        Left = 75
        Top = 3
        Width = 119
        Height = 21
        Align = alClient
        Date = 41835.000000000000000000
        Time = 0.573142557870596600
        TabOrder = 0
        ExplicitHeight = 28
      end
      object lblTime: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 30
        Width = 66
        Height = 21
        Align = alClient
        Caption = 'Time:'
        ExplicitWidth = 26
        ExplicitHeight = 13
      end
      object dtpTime: TDateTimePicker
        AlignWithMargins = True
        Left = 75
        Top = 30
        Width = 119
        Height = 21
        Align = alClient
        Date = 41835.000000000000000000
        Format = 'h:mm tt'
        Time = 0.573435787038761200
        Kind = dtkTime
        TabOrder = 1
        ExplicitHeight = 28
      end
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 309
    Height = 282
    Align = alClient
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    ExplicitWidth = 326
    ExplicitHeight = 233
    object stxtDescription: TStaticText
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 289
      Height = 262
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      Caption = 'stxtDescription'
      TabOrder = 0
      ExplicitWidth = 73
      ExplicitHeight = 17
    end
  end
  object acList: TActionList
    Left = 40
    Top = 56
    object acNewDeferalClicked: TAction
      Caption = 'acNewDeferalClicked'
      OnExecute = acNewDeferalClickedExecute
    end
    object acDefer: TAction
      Caption = 'Defer'
      OnExecute = acDeferExecute
    end
  end
end
