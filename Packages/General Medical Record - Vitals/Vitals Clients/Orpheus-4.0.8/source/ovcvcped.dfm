object frmViewCEd: TfrmViewCEd
  Left = 422
  Top = 334
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Column Properties'
  ClientHeight = 255
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 3
    Top = 1
    Width = 40
    Height = 13
    Caption = 'Co&lumns'
    FocusControl = ListBox1
  end
  object TLabel
    Left = 141
    Top = 149
    Width = 32
    Height = 13
    Caption = 'Width:'
  end
  object Label2: TLabel
    Left = 141
    Top = 177
    Width = 57
    Height = 13
    Caption = 'Print Width:'
  end
  object Label3: TLabel
    Left = 141
    Top = 3
    Width = 49
    Height = 13
    Caption = 'Properties'
  end
  object Bevel1: TBevel
    Left = 0
    Top = 221
    Width = 408
    Height = 4
    Shape = bsTopLine
  end
  object Label4: TLabel
    Left = 152
    Top = 202
    Width = 8
    Height = 13
    Caption = 'in'
  end
  object Bevel2: TBevel
    Left = 144
    Top = 170
    Width = 263
    Height = 2
    Shape = bsTopLine
  end
  object Label5: TLabel
    Left = 141
    Top = 56
    Width = 110
    Height = 13
    Caption = 'Aggregate expression:'
  end
  object Label6: TLabel
    Left = 260
    Top = 101
    Width = 56
    Height = 13
    Caption = 'Insert field:'
  end
  object Label7: TLabel
    Left = 260
    Top = 124
    Width = 78
    Height = 13
    Caption = 'Insert operator:'
  end
  object Label8: TLabel
    Left = 260
    Top = 148
    Width = 75
    Height = 13
    Caption = 'Insert function:'
  end
  object Bevel3: TBevel
    Left = 255
    Top = 96
    Width = 3
    Height = 70
    Shape = bsLeftLine
  end
  object btnOk: TBitBtn
    Left = 4
    Top = 226
    Width = 75
    Height = 25
    Caption = '&OK'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 9
    OnClick = btnOkClick
  end
  object btnCancel: TBitBtn
    Left = 84
    Top = 226
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    DoubleBuffered = True
    ModalResult = 2
    ParentDoubleBuffered = False
    TabOrder = 10
  end
  object ListBox1: TListBox
    Left = 2
    Top = 17
    Width = 133
    Height = 192
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object chkTotals: TCheckBox
    Left = 141
    Top = 37
    Width = 97
    Height = 17
    Caption = 'Calc &Totals'
    TabOrder = 2
    OnClick = chkTotalsClick
  end
  object chkGroupBy: TCheckBox
    Left = 141
    Top = 17
    Width = 97
    Height = 17
    Caption = 'Group By'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Default'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object chkShowHint: TCheckBox
    Left = 141
    Top = 98
    Width = 97
    Height = 17
    Caption = 'Show h&int'
    TabOrder = 4
    OnClick = chkShowHintClick
  end
  object chkAllowResize: TCheckBox
    Left = 141
    Top = 117
    Width = 97
    Height = 17
    Caption = 'Allow Resize'
    TabOrder = 5
    OnClick = chkAllowResizeClick
  end
  object edtWidth: TEdit
    Left = 200
    Top = 142
    Width = 49
    Height = 21
    TabOrder = 6
    OnChange = edtWidthChange
  end
  object edtPrintWidth: TEdit
    Left = 200
    Top = 174
    Width = 49
    Height = 21
    TabOrder = 7
    OnChange = edtPrintWidthChange
  end
  object cbxMeasure: TComboBox
    Left = 168
    Top = 198
    Width = 81
    Height = 21
    Style = csDropDownList
    TabOrder = 8
    OnChange = cbxMeasureChange
    Items.Strings = (
      'TWIPS'
      'Inches'
      'CMs'
      'Points')
  end
  object edtAgg: TEdit
    Left = 152
    Top = 72
    Width = 257
    Height = 21
    TabOrder = 3
    OnChange = edtAggChange
  end
  object cbxField: TOvcComboBox
    Left = 332
    Top = 96
    Width = 77
    Height = 18
    Hint = 'Insert field at cursor location in filter expression'
    DropDownCount = 9
    DroppedWidth = 360
    ItemHeight = 12
    MRUListCount = 0
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    Style = ocsDropDownList
    TabOrder = 11
    OnClick = cbxFieldClick
  end
  object cbxOp: TOvcComboBox
    Left = 332
    Top = 120
    Width = 77
    Height = 18
    Hint = 'Insert operator at cursor location in filter expression'
    DropDownCount = 9
    ItemHeight = 12
    Items.Strings = (
      ' - '
      ' ( ) '
      ' * '
      ' / '
      ' + '
      ' < '
      ' <= '
      ' <> '
      ' = '
      ' > '
      ' >= '
      ' AND '
      ' OR ')
    MRUListCount = 0
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    Style = ocsDropDownList
    TabOrder = 12
    OnClick = cbxOpClick
  end
  object cbxFunc: TOvcComboBox
    Left = 332
    Top = 144
    Width = 77
    Height = 18
    DroppedWidth = 200
    ItemHeight = 12
    Items.Strings = (
      'AVG()'
      'BETWEEN  AND'
      'CASE'
      'CHAR_LENGTH'
      'COUNT(*)'
      'FORMATDATETIME'
      'FORMATNUMBER'
      'IN'
      'INTTOHEX'
      'LIKE'
      'LOWER'
      'MAX()'
      'MIN()'
      'POSITION'
      'SUBSTRING'
      'SUM()'
      'TRIM'
      'UPPER')
    MRUListCount = 0
    Sorted = True
    Style = ocsDropDownList
    TabOrder = 13
    OnClick = cbxFuncClick
  end
end
