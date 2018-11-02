object frmViewEd: TfrmViewEd
  Left = 345
  Top = 221
  HelpContext = 12400
  BorderStyle = bsToolWindow
  Caption = 'frmViewEd'
  ClientHeight = 479
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StaticText1: TStaticText
    Left = 0
    Top = 31
    Width = 504
    Height = 17
    Align = alTop
    BorderStyle = sbsSunken
    Caption = ' Unused Fields:'
    TabOrder = 0
  end
  object Panel1: TScrollBox
    Left = 0
    Top = 48
    Width = 504
    Height = 50
    Hint = 'Fields not currently used in view'
    Align = alTop
    BorderStyle = bsNone
    Color = clWindow
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object Panel2: TScrollBox
    Left = 0
    Top = 115
    Width = 504
    Height = 50
    Hint = 
      'Drag one or more fields here to have the view grouped on the con' +
      'tents of the field(s).'
    Align = alTop
    BorderStyle = bsNone
    Color = clWindow
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object Panel3: TScrollBox
    Left = 0
    Top = 182
    Width = 504
    Height = 50
    Hint = 'The fields that make up the horizontal layout of the view.'
    Align = alTop
    BorderStyle = bsNone
    Color = clWindow
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object StaticText2: TStaticText
    Left = 0
    Top = 98
    Width = 504
    Height = 17
    Align = alTop
    BorderStyle = sbsSunken
    Caption = ' Grouping:'
    TabOrder = 4
  end
  object StaticText3: TStaticText
    Left = 0
    Top = 165
    Width = 504
    Height = 17
    Align = alTop
    BorderStyle = sbsSunken
    Caption = ' Columns:'
    TabOrder = 5
  end
  object Button1: TButton
    Left = 344
    Top = 453
    Width = 75
    Height = 24
    Caption = 'OK'
    Default = True
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 424
    Top = 453
    Width = 75
    Height = 24
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 504
    Height = 31
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 8
    object Label1: TLabel
      Left = 4
      Top = 9
      Width = 24
      Height = 13
      Caption = 'Title:'
    end
    object tEdit: TEdit
      Left = 32
      Top = 5
      Width = 280
      Height = 21
      TabOrder = 0
      OnChange = tEditChange
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 361
    Width = 504
    Height = 88
    Hint = 'What the actual view will look like.'
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    object Label3: TLabel
      Left = 3
      Top = 1
      Width = 74
      Height = 13
      Caption = 'Sample Layout:'
    end
    object Panel7: TPanel
      Left = 4
      Top = 16
      Width = 496
      Height = 64
      BevelOuter = bvNone
      TabOrder = 0
    end
  end
  object StaticText4: TStaticText
    Left = 0
    Top = 264
    Width = 504
    Height = 17
    Align = alTop
    BorderStyle = sbsSunken
    Caption = ' Filter expression:'
    TabOrder = 10
  end
  object Panel6: TPanel
    Left = 0
    Top = 281
    Width = 504
    Height = 80
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 11
    object Label2: TLabel
      Left = 4
      Top = 10
      Width = 28
      Height = 13
      Caption = 'Filter:'
    end
    object Label4: TLabel
      Left = 235
      Top = 13
      Width = 56
      Height = 13
      Caption = 'Insert field:'
    end
    object Label5: TLabel
      Left = 236
      Top = 36
      Width = 78
      Height = 13
      Caption = 'Insert operator:'
    end
    object Label6: TLabel
      Left = 424
      Top = 13
      Width = 47
      Height = 13
      Caption = 'at cursor.'
    end
    object Label7: TLabel
      Left = 424
      Top = 36
      Width = 47
      Height = 13
      Caption = 'at cursor.'
    end
    object Label8: TLabel
      Left = 236
      Top = 60
      Width = 75
      Height = 13
      Caption = 'Insert function:'
    end
    object Label9: TLabel
      Left = 425
      Top = 60
      Width = 47
      Height = 13
      Caption = 'at cursor.'
    end
    object fEdit: TEdit
      Left = 36
      Top = 6
      Width = 197
      Height = 21
      TabOrder = 0
    end
    object cbxField: TOvcComboBox
      Left = 312
      Top = 8
      Width = 97
      Height = 19
      Hint = 'Insert field at cursor location in filter expression'
      DropDownCount = 9
      DroppedWidth = 360
      ItemHeight = 13
      MRUListCount = 0
      ParentShowHint = False
      ShowHint = True
      Sorted = True
      Style = ocsDropDownList
      TabOrder = 1
      OnClick = cbxFieldClick
    end
    object cbxOp: TOvcComboBox
      Left = 312
      Top = 32
      Width = 97
      Height = 19
      Hint = 'Insert operator at cursor location in filter expression'
      DropDownCount = 9
      ItemHeight = 13
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
      TabOrder = 2
      OnClick = cbxOpClick
    end
    object cbxFunc: TOvcComboBox
      Left = 312
      Top = 56
      Width = 97
      Height = 19
      DroppedWidth = 200
      ItemHeight = 13
      Items.Strings = (
        'BETWEEN  AND'
        'CASE'
        'CHAR_LENGTH'
        'FORMATDATETIME'
        'FORMATNUMBER'
        'IN'
        'INTTOHEX'
        'LIKE'
        'LOWER'
        'POSITION'
        'SUBSTRING'
        'TRIM'
        'UPPER')
      MRUListCount = 0
      Sorted = True
      Style = ocsDropDownList
      TabOrder = 3
      OnClick = cbxFuncClick
    end
  end
  object Panel8: TPanel
    Left = 0
    Top = 232
    Width = 504
    Height = 32
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 12
    object tbHeader: TCheckBox
      Left = 8
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Show Header'
      TabOrder = 0
      OnClick = tbHeaderClick
    end
    object tbFooter: TCheckBox
      Left = 104
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Show Footer'
      TabOrder = 1
      OnClick = tbFooterClick
    end
    object tbGroupCounts: TCheckBox
      Left = 200
      Top = 8
      Width = 121
      Height = 17
      Caption = 'Show Group Counts'
      TabOrder = 2
      OnClick = tbGroupCountsClick
    end
    object tbGroupTotals: TCheckBox
      Left = 328
      Top = 8
      Width = 121
      Height = 17
      Caption = 'Show Group Totals'
      TabOrder = 3
      OnClick = tbGroupTotalsClick
    end
  end
  object btnAdditional: TButton
    Left = 0
    Top = 453
    Width = 121
    Height = 24
    Caption = '&Column Properties...'
    TabOrder = 13
    OnClick = btnAdditionalClick
  end
  object ViewFieldPopup: TPopupMenu
    OnPopup = ViewFieldPopupPopup
    Left = 32
    Top = 375
    object AllowResize1: TMenuItem
      Caption = '&Allow Resize'
      OnClick = AllowResize1Click
    end
    object ShowTotals1: TMenuItem
      Caption = '&Calc Totals'
      OnClick = ShowTotals1Click
    end
    object ShowHint1: TMenuItem
      Caption = '&Show Hints'
      OnClick = ShowHint1Click
    end
  end
end
