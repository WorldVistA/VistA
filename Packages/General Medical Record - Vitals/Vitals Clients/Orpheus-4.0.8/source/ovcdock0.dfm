object OvcfrmDock: TOvcfrmDock
  Left = 298
  Top = 175
  BorderStyle = bsSingle
  Caption = 'Dock component'
  ClientHeight = 218
  ClientWidth = 309
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TLabel
    Left = 4
    Top = 4
    Width = 118
    Height = 13
    Caption = '&Component to dock with:'
    FocusControl = lbComponentList
    IsControl = True
  end
  object lblClassName: TLabel
    Left = 66
    Top = 171
    Width = 57
    Height = 13
    Caption = 'Class name:'
  end
  object TLabel
    Left = 4
    Top = 171
    Width = 60
    Height = 13
    Caption = 'Class name: '
  end
  object lbComponentList: TListBox
    Left = 4
    Top = 20
    Width = 225
    Height = 149
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnClick = lbComponentListClick
    OnDblClick = lbComponentListDblClick
  end
  object btnOK: TButton
    Left = 150
    Top = 189
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 231
    Top = 189
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object rgPosition: TRadioGroup
    Left = 236
    Top = 14
    Width = 69
    Height = 155
    Caption = '&Position'
    ItemIndex = 1
    Items.Strings = (
      'Left'
      'Right'
      'Top'
      'Bottom')
    TabOrder = 1
  end
end
