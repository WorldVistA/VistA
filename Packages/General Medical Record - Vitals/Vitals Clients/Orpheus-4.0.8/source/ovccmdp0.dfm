object OvcfrmCmdTable: TOvcfrmCmdTable
  Left = 314
  Top = 228
  ActiveControl = lbKeys
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Command Table Editor'
  ClientHeight = 359
  ClientWidth = 441
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  Menu = mnuCmdMenu
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TBevel
    Left = 8
    Top = 8
    Width = 297
    Height = 233
  end
  object TBevel
    Left = 312
    Top = 9
    Width = 121
    Height = 233
  end
  object TBevel
    Left = 8
    Top = 249
    Width = 425
    Height = 73
  end
  object lblWordStar: TLabel
    Left = 312
    Top = 291
    Width = 76
    Height = 13
    Caption = '2-Key command'
  end
  object tabTable: TTabSet
    Left = 0
    Top = 332
    Width = 441
    Height = 27
    Align = alBottom
    DitherBackground = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Default'
    Font.Style = []
    OnChange = TableTabChange
  end
  object ckActive: TCheckBox
    Left = 336
    Top = 16
    Width = 89
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Acti&ve'
    TabOrder = 9
    OnClick = ckActiveClick
  end
  object lbKeys: TListBox
    Left = 14
    Top = 49
    Width = 137
    Height = 184
    ItemHeight = 13
    TabOrder = 1
    OnClick = lbKeysClick
  end
  object TPanel
    Left = 159
    Top = 16
    Width = 137
    Height = 25
    Caption = 'Commands'
    TabOrder = 2
  end
  object TPanel
    Left = 16
    Top = 16
    Width = 137
    Height = 25
    Caption = 'Assigned keys'
    TabOrder = 0
  end
  object btnClose: TBitBtn
    Left = 336
    Top = 204
    Width = 75
    Height = 25
    Caption = '&Close'
    TabOrder = 13
    OnClick = btnCloseClick
    NumGlyphs = 2
  end
  object btnAssign: TBitBtn
    Left = 336
    Top = 49
    Width = 75
    Height = 25
    Caption = '&Assign'
    TabOrder = 10
    OnClick = btnAssignClick
  end
  object edFirst: TEdit
    Left = 16
    Top = 288
    Width = 137
    Height = 21
    MaxLength = 25
    TabOrder = 5
    Visible = False
    OnChange = EditChange
    OnEnter = EditEnter
  end
  object edSecond: TEdit
    Left = 160
    Top = 288
    Width = 137
    Height = 21
    MaxLength = 25
    TabOrder = 7
    Visible = False
    OnChange = EditChange
    OnEnter = EditEnter
  end
  object ckWordstar: TCheckBox
    Left = 320
    Top = 272
    Width = 97
    Height = 17
    Alignment = taLeftJustify
    Caption = '&WordStar'
    TabOrder = 8
    OnClick = ckWordstarClick
  end
  object btnNewCmd: TBitBtn
    Left = 336
    Top = 120
    Width = 75
    Height = 25
    Caption = '&User Cmd'
    TabOrder = 12
    OnClick = btnUserCmdClick
  end
  object TPanel
    Left = 16
    Top = 256
    Width = 137
    Height = 25
    Caption = 'First key'
    TabOrder = 4
  end
  object TPanel
    Left = 160
    Top = 256
    Width = 137
    Height = 25
    Caption = 'Second key'
    TabOrder = 6
  end
  object lbCommands: TListBox
    Left = 159
    Top = 48
    Width = 137
    Height = 185
    ItemHeight = 13
    TabOrder = 3
  end
  object btnClear: TBitBtn
    Left = 336
    Top = 85
    Width = 75
    Height = 25
    Caption = 'C&lear'
    TabOrder = 11
    OnClick = btnClearClick
  end
  object dlgSaveDialog: TSaveDialog
    DefaultExt = 'CMD'
    Filter = 'Command files (*.CMD)|*.CMD|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist]
    Title = 'Save Command Table'
    Left = 215
    Top = 193
  end
  object dlgOpenDialog: TOpenDialog
    DefaultExt = 'CMD'
    Filter = 'Command files (*.CMD)|*.CMD|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist]
    Title = 'Load Command Table'
    Left = 256
    Top = 192
  end
  object mnuCmdMenu: TMainMenu
    Left = 175
    Top = 193
    object miTable: TMenuItem
      Caption = '&Table'
      object miNew: TMenuItem
        Caption = '&New'
        OnClick = miNewClick
      end
      object miDelete: TMenuItem
        Caption = '&Delete'
        OnClick = miDeleteClick
      end
      object miDuplicate: TMenuItem
        Caption = 'D&uplicate'
        OnClick = miDuplicateClick
      end
      object miLoad: TMenuItem
        Caption = '&Load'
        OnClick = miLoadClick
      end
      object miSave: TMenuItem
        Caption = '&Save'
        OnClick = miSaveClick
      end
      object miOrder: TMenuItem
        Caption = '&Order'
        OnClick = miOrderClick
      end
      object miRename: TMenuItem
        Caption = '&Rename'
        OnClick = miRenameClick
      end
    end
  end
end
