inherited frmTemplateDialog: TfrmTemplateDialog
  Left = 268
  Top = 155
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Text Dialog'
  ClientHeight = 413
  ClientWidth = 632
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  OnPaint = FormPaint
  OnShow = FormShow
  ExplicitWidth = 648
  ExplicitHeight = 451
  PixelsPerInch = 96
  TextHeight = 13
  object sbMain: TScrollBox [0]
    Left = 0
    Top = 0
    Width = 632
    Height = 375
    VertScrollBar.Tracking = True
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object pnlBottom: TScrollBox [1]
    Left = 0
    Top = 375
    Width = 632
    Height = 38
    Align = alBottom
    TabOrder = 1
    object lblFootnote: TStaticText
      Left = 196
      Top = 7
      Width = 134
      Height = 17
      Alignment = taCenter
      Caption = '* Indicates a Required Field'
      TabOrder = 5
    end
    object btnCancel: TButton
      Left = 551
      Top = 3
      Width = 75
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 4
    end
    object btnOK: TButton
      Left = 472
      Top = 3
      Width = 75
      Height = 21
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 3
      OnClick = btnOKClick
    end
    object btnAll: TButton
      Left = 6
      Top = 3
      Width = 75
      Height = 21
      Caption = 'All'
      TabOrder = 0
      OnClick = btnAllClick
    end
    object btnNone: TButton
      Left = 86
      Top = 3
      Width = 75
      Height = 21
      Caption = 'None'
      TabOrder = 1
      OnClick = btnNoneClick
    end
    object btnPreview: TButton
      Left = 360
      Top = 3
      Width = 75
      Height = 21
      Caption = 'Preview'
      TabOrder = 2
      OnClick = btnPreviewClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = sbMain'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = lblFootnote'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnAll'
        'Status = stsDefault')
      (
        'Component = btnNone'
        'Status = stsDefault')
      (
        'Component = btnPreview'
        'Status = stsDefault')
      (
        'Component = frmTemplateDialog'
        'Status = stsDefault'))
  end
end
