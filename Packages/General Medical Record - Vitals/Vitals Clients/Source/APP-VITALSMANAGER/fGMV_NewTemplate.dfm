object frmGMV_NewTemplate: TfrmGMV_NewTemplate
  Left = 612
  Top = 224
  HelpContext = 2
  BorderStyle = bsDialog
  Caption = 'Create New Vitals Template'
  ClientHeight = 170
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblType: TLabel
    Left = 95
    Top = 8
    Width = 34
    Height = 13
    Caption = 'lblType'
  end
  object lblName: TLabel
    Left = 95
    Top = 53
    Width = 78
    Height = 13
    Caption = 'Template Name:'
  end
  object Label1: TLabel
    Left = 95
    Top = 96
    Width = 103
    Height = 13
    Caption = 'Template Description:'
  end
  object rgTemplateType: TRadioGroup
    Left = 8
    Top = 8
    Width = 79
    Height = 123
    Caption = 'Type:'
    Items.Strings = (
      'System'
      'Division'
      'Location'
      'User')
    TabOrder = 0
    OnClick = rgTemplateTypeClick
  end
  object edtTemplateName: TEdit
    Left = 95
    Top = 67
    Width = 194
    Height = 21
    TabOrder = 2
    Text = 'edtTemplateName'
  end
  object btnCancel: TButton
    Left = 214
    Top = 140
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object btnOK: TButton
    Left = 134
    Top = 140
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 4
    OnClick = btnOKClick
  end
  object edtTemplateDescription: TEdit
    Left = 95
    Top = 110
    Width = 194
    Height = 21
    TabOrder = 3
    Text = 'edtTemplateDescription'
  end
  inline fraEntityLookup: TfraGMV_Lookup
    Left = 96
    Top = 24
    Width = 193
    Height = 24
    TabOrder = 1
    ExplicitLeft = 96
    ExplicitTop = 24
    ExplicitWidth = 193
    ExplicitHeight = 24
    inherited cbxValues: TComboBox
      Width = 193
      ExplicitWidth = 193
    end
    inherited edtValue: TComboBox
      Width = 193
      ExplicitWidth = 193
    end
  end
end
