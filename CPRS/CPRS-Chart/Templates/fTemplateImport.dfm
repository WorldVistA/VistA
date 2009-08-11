inherited frmTemplateImport: TfrmTemplateImport
  Left = 273
  Top = 195
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Importing Word Document'
  ClientHeight = 132
  ClientWidth = 288
  FormStyle = fsStayOnTop
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object gaugeImport: TGauge [0]
    Left = 8
    Top = 82
    Width = 272
    Height = 21
    BackColor = clHighlightText
    ForeColor = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCaptionText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Progress = 0
  end
  object lblImporting: TStaticText [1]
    Left = 8
    Top = 4
    Width = 272
    Height = 13
    AutoSize = False
    Caption = 'Importing '
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object animImport: TAnimate [2]
    Left = 8
    Top = 20
    Width = 272
    Height = 60
    Active = True
    CommonAVI = aviCopyFile
    StopFrame = 20
  end
  object btnCancel: TButton [3]
    Left = 106
    Top = 106
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    Default = True
    TabOrder = 1
    OnClick = btnCancelClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblImporting'
        'Status = stsDefault')
      (
        'Component = animImport'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmTemplateImport'
        'Status = stsDefault'))
  end
end
