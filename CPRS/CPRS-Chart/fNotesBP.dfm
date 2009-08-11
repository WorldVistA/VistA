inherited frmNotesBP: TfrmNotesBP
  Left = 230
  Top = 376
  BorderIcons = []
  Caption = 'Boilerplate Text'
  ClientHeight = 155
  ClientWidth = 310
  Position = poScreenCenter
  OnKeyUp = FormKeyUp
  ExplicitWidth = 318
  ExplicitHeight = 182
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TStaticText [0]
    Left = 0
    Top = 0
    Width = 310
    Height = 17
    Align = alTop
    AutoSize = False
    Caption = 'The selected title has associated boilerplate text.'
    TabOrder = 1
  end
  object radOptions: TRadioGroup [1]
    Left = 0
    Top = 17
    Width = 310
    Height = 110
    Align = alClient
    Caption = ' Choose from: '
    ItemIndex = 0
    Items.Strings = (
      '&Ignore the boilerplate text (text of note will not change).'
      '&Append the boilerplate text to the text in the note.'
      '&Replace the text in the note with the boilerplate text.')
    TabOrder = 0
    ExplicitHeight = 103
  end
  object btnPanel: TPanel [2]
    Left = 0
    Top = 127
    Width = 310
    Height = 28
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 120
    object cmdPreview: TButton
      Left = 6
      Top = 4
      Width = 79
      Height = 21
      Caption = 'Preview Text'
      TabOrder = 0
      OnClick = cmdPreviewClick
    end
    object cmdClose: TButton
      Left = 230
      Top = 4
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = cmdCloseClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Label1'
        'Status = stsDefault')
      (
        'Component = radOptions'
        'Status = stsDefault')
      (
        'Component = btnPanel'
        'Status = stsDefault')
      (
        'Component = cmdPreview'
        'Status = stsDefault')
      (
        'Component = cmdClose'
        'Status = stsDefault')
      (
        'Component = frmNotesBP'
        'Status = stsDefault'))
  end
end
