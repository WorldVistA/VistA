object frmGMV_EnteredInError: TfrmGMV_EnteredInError
  Left = 649
  Top = 217
  HelpContext = 3
  BorderIcons = [biSystemMenu]
  BorderWidth = 4
  Caption = 'Entered In Error'
  ClientHeight = 350
  ClientWidth = 473
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 473
    Height = 49
    Align = alTop
    Caption = 'Select &Date:'
    TabOrder = 0
    DesignSize = (
      473
      49)
    object dtpDate: TDateTimePicker
      Left = 8
      Top = 16
      Width = 463
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Date = 37300.571333194400000000
      Time = 37300.571333194400000000
      TabOrder = 0
      OnChange = DateChange
    end
  end
  object rgReason: TRadioGroup
    Left = 0
    Top = 252
    Width = 473
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
    TabOrder = 3
    TabStop = True
    OnClick = OkToProceed
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 317
    Width = 473
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      473
      33)
    object btnCancel: TButton
      Left = 395
      Top = 8
      Width = 76
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 247
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
    Width = 473
    Height = 164
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
        Width = 150
      end
      item
        Caption = 'Source'
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
    OnCustomDrawItem = lvVitalsCustomDrawItem
  end
  object Panel1: TPanel
    Left = 0
    Top = 213
    Width = 473
    Height = 39
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 32
      Height = 13
      Caption = 'Note:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 48
      Top = 12
      Width = 342
      Height = 13
      Caption = 
        'To mark CliO records as "Entered in Error" use the Flowsheet app' +
        'lication'
    end
  end
end
