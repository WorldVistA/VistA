object OvcfrmRptVwPrintDlg: TOvcfrmRptVwPrintDlg
  Left = 360
  Top = 222
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Report View Print Dialog'
  ClientHeight = 308
  ClientWidth = 299
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object OvcPrinterComboBox1Label1: TOvcAttachedLabel
    Left = 8
    Top = 5
    Width = 139
    Height = 13
    AutoSize = False
    Caption = 'Printer:'
    FocusControl = OvcPrinterComboBox1
    Transparent = False
    Control = OvcPrinterComboBox1
  end
  object OvcViewComboBox1Label1: TOvcAttachedLabel
    Left = 8
    Top = 48
    Width = 132
    Height = 13
    AutoSize = False
    Caption = 'View to print:'
    FocusControl = OvcViewComboBox1
    Transparent = False
    Control = OvcViewComboBox1
  end
  object lblPageText: TLabel
    Left = 8
    Top = 288
    Width = 65
    Height = 13
    Caption = 'Printing page '
    Visible = False
  end
  object lblPageNumber: TLabel
    Left = 80
    Top = 288
    Width = 3
    Height = 13
  end
  object Bevel1: TBevel
    Left = 8
    Top = 282
    Width = 284
    Height = 4
    Shape = bsTopLine
  end
  object OvcViewComboBox1: TOvcViewComboBox
    Left = 8
    Top = 65
    Width = 200
    Height = 22
    ItemHeight = 12
    LabelInfo.OffsetX = 0
    LabelInfo.OffsetY = -4
    LabelInfo.Visible = True
    TabOrder = 1
    OnChange = OvcViewComboBox1Change
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 151
    Width = 200
    Height = 105
    Caption = ' Group control '
    ItemIndex = 0
    Items.Strings = (
      'Expand All Groups'
      'Collapse All Groups'
      'Use Current')
    TabOrder = 2
  end
  object OvcPrinterComboBox1: TOvcPrinterComboBox
    Left = 8
    Top = 23
    Width = 200
    Height = 22
    ItemHeight = 12
    LabelInfo.OffsetX = 0
    LabelInfo.OffsetY = -5
    LabelInfo.Visible = True
    TabOrder = 0
    Text = 'OvcPrinterComboBox1'
  end
  object btnOk: TButton
    Left = 216
    Top = 199
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 7
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 216
    Top = 231
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object btnAbort: TButton
    Left = 216
    Top = 23
    Width = 75
    Height = 25
    Caption = 'Abort'
    Enabled = False
    TabOrder = 4
    OnClick = btnAbortClick
  end
  object chkSelected: TCheckBox
    Left = 8
    Top = 260
    Width = 201
    Height = 17
    Caption = 'Print only selected items'
    TabOrder = 3
  end
  object btnHelp: TButton
    Left = 216
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Help'
    Enabled = False
    TabOrder = 5
    OnClick = btnHelpClick
  end
  object RadioGroup2: TRadioGroup
    Left = 8
    Top = 92
    Width = 200
    Height = 57
    Caption = ' Paper Orientation '
    ItemIndex = 0
    Items.Strings = (
      'Portrait'
      'Landscape')
    TabOrder = 9
  end
  object btnPreview: TButton
    Left = 216
    Top = 168
    Width = 75
    Height = 25
    Caption = '&Preview...'
    TabOrder = 6
    OnClick = btnPreviewClick
  end
end
