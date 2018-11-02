object frmOvcRvFldEd: TfrmOvcRvFldEd
  Left = 435
  Top = 279
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Editing Calculated Fields'
  ClientHeight = 420
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 313
    Height = 116
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 128
    Width = 313
    Height = 289
    Caption = ' Field Properties '
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 25
      Width = 31
      Height = 13
      Caption = '&Name:'
      FocusControl = edtName
    end
    object Label3: TLabel
      Left = 8
      Top = 52
      Width = 39
      Height = 13
      Caption = '&Caption:'
      FocusControl = edtCaption
    end
    object Label10: TLabel
      Left = 8
      Top = 76
      Width = 22
      Height = 13
      Caption = '&Hint:'
      FocusControl = edtHint
    end
    object Label11: TLabel
      Left = 8
      Top = 100
      Width = 49
      Height = 13
      Caption = '&Alignment:'
    end
    object Label12: TLabel
      Left = 8
      Top = 124
      Width = 31
      Height = 13
      Caption = '&Width:'
      FocusControl = edtWidth
    end
    object Label13: TLabel
      Left = 8
      Top = 148
      Width = 55
      Height = 13
      Caption = '&Print Width:'
      FocusControl = edtPrintWidth
    end
    object Label14: TLabel
      Left = 144
      Top = 124
      Width = 32
      Height = 13
      Caption = '(pixels)'
    end
    object Label15: TLabel
      Left = 144
      Top = 148
      Width = 30
      Height = 13
      Caption = '(twips)'
    end
    object Panel6: TPanel
      Left = 8
      Top = 168
      Width = 297
      Height = 113
      BevelOuter = bvLowered
      TabOrder = 6
      object Label2: TLabel
        Left = 4
        Top = 10
        Width = 54
        Height = 13
        Caption = '&Expression:'
        FocusControl = edtExpression
      end
      object Label4: TLabel
        Left = 12
        Top = 37
        Width = 51
        Height = 13
        Caption = 'Insert field:'
      end
      object Label5: TLabel
        Left = 12
        Top = 60
        Width = 71
        Height = 13
        Caption = 'Insert operator:'
      end
      object Label6: TLabel
        Left = 200
        Top = 37
        Width = 44
        Height = 13
        Caption = 'at cursor.'
      end
      object Label7: TLabel
        Left = 200
        Top = 60
        Width = 44
        Height = 13
        Caption = 'at cursor.'
      end
      object Label8: TLabel
        Left = 12
        Top = 84
        Width = 70
        Height = 13
        Caption = 'Insert function:'
      end
      object Label9: TLabel
        Left = 200
        Top = 84
        Width = 44
        Height = 13
        Caption = 'at cursor.'
      end
      object edtExpression: TEdit
        Left = 64
        Top = 6
        Width = 201
        Height = 21
        TabOrder = 0
      end
      object cbxField: TOvcComboBox
        Left = 88
        Top = 32
        Width = 97
        Height = 22
        Hint = 'Insert field at cursor location in filter expression'
        DropDownCount = 9
        DroppedWidth = 360
        ItemHeight = 12
        MRUListCount = 0
        ParentShowHint = False
        ShowHint = True
        Sorted = True
        Style = ocsDropDownList
        TabOrder = 1
        OnClick = cbxFieldClick
      end
      object cbxOp: TOvcComboBox
        Left = 88
        Top = 56
        Width = 97
        Height = 22
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
          ' NOT '
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
        Left = 88
        Top = 80
        Width = 97
        Height = 22
        DroppedWidth = 200
        ItemHeight = 12
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
    object edtName: TEdit
      Left = 72
      Top = 21
      Width = 121
      Height = 21
      TabOrder = 0
      OnExit = edtNameExit
    end
    object edtCaption: TEdit
      Left = 72
      Top = 48
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object edtHint: TEdit
      Left = 72
      Top = 72
      Width = 233
      Height = 21
      TabOrder = 2
    end
    object ComboBox1: TOvcComboBox
      Left = 72
      Top = 96
      Width = 65
      Height = 22
      AutoSearch = False
      DropDownCount = 3
      ItemHeight = 12
      Items.Strings = (
        'Left'
        'Right'
        'Center')
      MRUListCount = 0
      Style = ocsDropDownList
      TabOrder = 3
    end
    object edtWidth: TEdit
      Left = 72
      Top = 120
      Width = 65
      Height = 21
      TabOrder = 4
    end
    object edtPrintWidth: TEdit
      Left = 72
      Top = 144
      Width = 65
      Height = 21
      TabOrder = 5
    end
  end
  object btnOK: TButton
    Left = 328
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 328
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object btnNewField: TButton
    Left = 328
    Top = 68
    Width = 75
    Height = 25
    Caption = 'New &Field'
    TabOrder = 4
    OnClick = btnNewFieldClick
  end
  object btnDelete: TButton
    Left = 328
    Top = 98
    Width = 75
    Height = 25
    Caption = '&Delete'
    Enabled = False
    TabOrder = 5
    OnClick = btnDeleteClick
  end
end
