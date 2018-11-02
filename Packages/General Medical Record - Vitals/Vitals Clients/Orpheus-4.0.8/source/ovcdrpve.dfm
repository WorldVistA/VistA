object OvcfrmRvDataItemEditor: TOvcfrmRvDataItemEditor
  Left = 287
  Top = 211
  Caption = 'OvcfrmRvDataItemEditor'
  ClientHeight = 243
  ClientWidth = 364
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
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 364
    Height = 215
    Align = alClient
    DefaultRowHeight = 18
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 0
    OnSelectCell = StringGrid1SelectCell
    OnSetEditText = StringGrid1SetEditText
    ExplicitWidth = 356
    ExplicitHeight = 211
  end
  object Panel1: TPanel
    Left = 0
    Top = 215
    Width = 364
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 211
    ExplicitWidth = 356
    object btnAdd: TButton
      Left = 2
      Top = 2
      Width = 75
      Height = 25
      Caption = '&Add'
      TabOrder = 0
      OnClick = bntAddClick
    end
    object btnDelete: TButton
      Left = 84
      Top = 2
      Width = 75
      Height = 25
      Caption = '&Delete'
      Enabled = False
      TabOrder = 1
      OnClick = btnDeleteClick
    end
    object btnOk: TButton
      Left = 287
      Top = 2
      Width = 75
      Height = 25
      Caption = '&Close'
      ModalResult = 1
      TabOrder = 2
    end
  end
end
