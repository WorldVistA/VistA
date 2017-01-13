inherited frmNotesBP: TfrmNotesBP
  Left = 230
  Top = 376
  BorderIcons = []
  Caption = 'Boilerplate Text'
  ClientHeight = 155
  ClientWidth = 310
  Position = poScreenCenter
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  ExplicitWidth = 318
  ExplicitHeight = 189
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
  object btnPanel: TPanel [1]
    Left = 0
    Top = 127
    Width = 310
    Height = 28
    Align = alBottom
    TabOrder = 2
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
  object grpOptions: TGroupBox [2]
    Left = 0
    Top = 17
    Width = 310
    Height = 110
    Align = alClient
    Caption = 'Choose from: '
    TabOrder = 0
    TabStop = True
    OnEnter = grpOptionsEnter
    object radReplace: TRadioButton
      Left = 16
      Top = 71
      Width = 273
      Height = 17
      Caption = '&Replace the text in the note with the boilerplate text.'
      TabOrder = 2
      OnExit = radReplaceExit
    end
    object radAppend: TRadioButton
      Left = 16
      Top = 48
      Width = 257
      Height = 17
      Caption = '&Append the boilerplate text to the text in the note.'
      TabOrder = 1
      OnExit = radAppendExit
    end
    object radIgnore: TRadioButton
      Left = 16
      Top = 25
      Width = 286
      Height = 17
      Caption = '&Ignore the boilerplate text (text of note will not change).'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnExit = radIgnoreExit
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Label1'
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
        'Status = stsDefault')
      (
        'Component = grpOptions'
        'Status = stsDefault')
      (
        'Component = radReplace'
        'Status = stsDefault')
      (
        'Component = radAppend'
        'Status = stsDefault')
      (
        'Component = radIgnore'
        'Status = stsDefault'))
  end
end
