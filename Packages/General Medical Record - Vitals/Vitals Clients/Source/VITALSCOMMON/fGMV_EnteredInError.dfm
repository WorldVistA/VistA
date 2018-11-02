object frmGMV_EnteredInError: TfrmGMV_EnteredInError
  Left = 379
  Top = 241
  Width = 505
  Height = 359
  HelpContext = 3
  BorderIcons = [biSystemMenu]
  BorderWidth = 4
  Caption = 'Entered In Error'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 489
    Height = 49
    Align = alTop
    Caption = 'Select &Date:'
    TabOrder = 0
    object dtpDate: TDateTimePicker
      Left = 8
      Top = 16
      Width = 469
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      CalAlignment = dtaLeft
      Date = 37300.5713331944
      Time = 37300.5713331944
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 0
      OnChange = DateChange
    end
  end
  object rgReason: TRadioGroup
    Left = 0
    Top = 225
    Width = 489
    Height = 65
    Align = alBottom
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Reason:'
    Columns = 2
    Items.Strings = (
      'Incorrect Date/&Time'
      'Incorrect &Reading'
      'Incorrect &Patient'
      'Invalid R&ecord')
    TabOrder = 2
    TabStop = True
    OnClick = OkToProceed
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 290
    Width = 489
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object btnCancel: TButton
      Left = 413
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 277
      Top = 8
      Width = 131
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Mark as Entered in Error'
      Enabled = False
      TabOrder = 0
      OnClick = OkButtonClick
    end
  end
  object lvVitals: TListView
    Left = 0
    Top = 49
    Width = 489
    Height = 176
    Hint = 
      'Select measurements to mark in error.  Use the ctrl and shift ke' +
      'ys to select multiple items'
    Align = alClient
    Columns = <
      item
        Caption = 'Date/Time'
        Width = 100
      end
      item
        Caption = 'Vital'
        Width = -1
        WidthType = (
          -1)
      end
      item
        Caption = 'Entered By'
        Width = 100
      end>
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    ViewStyle = vsReport
    OnChange = lvVitalsChange
    OnClick = OkToProceed
  end
end
