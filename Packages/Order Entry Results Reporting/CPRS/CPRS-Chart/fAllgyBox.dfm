inherited frmAllgyBox: TfrmAllgyBox
  Left = 487
  Top = 242
  Caption = 'frmAllgyBox'
  ClientWidth = 449
  Constraints.MinWidth = 457
  Position = poMainFormCenter
  ExplicitWidth = 465
  PixelsPerInch = 96
  TextHeight = 13
  inherited memReport: TRichEdit
    Width = 449
    ExplicitWidth = 449
  end
  inherited pnlButton: TPanel
    Width = 449
    ExplicitWidth = 449
    inherited cmdPrint: TButton
      Left = 293
      Anchors = [akTop, akRight]
      Caption = '&Print'
      TabOrder = 3
      ExplicitLeft = 293
    end
    inherited cmdClose: TButton
      Left = 373
      Anchors = [akTop, akRight]
      Caption = '&Close'
      TabOrder = 4
      ExplicitLeft = 373
    end
    object cmdEdit: TButton
      Left = 98
      Top = 0
      Width = 90
      Height = 21
      Caption = 'E&dit'
      TabOrder = 1
      Visible = False
      OnClick = cmdEditClick
    end
    object cmdAdd: TButton
      Left = 2
      Top = 0
      Width = 90
      Height = 21
      Caption = '&Add New'
      TabOrder = 0
      OnClick = cmdAddClick
    end
    object cmdInError: TButton
      Left = 195
      Top = 0
      Width = 90
      Height = 21
      Caption = '&Entered in Error'
      TabOrder = 2
      OnClick = cmdInErrorClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdEdit'
        'Status = stsDefault')
      (
        'Component = cmdAdd'
        'Status = stsDefault')
      (
        'Component = cmdInError'
        'Status = stsDefault')
      (
        'Component = memReport'
        'Status = stsDefault')
      (
        'Component = pnlButton'
        'Status = stsDefault')
      (
        'Component = cmdPrint'
        'Status = stsDefault')
      (
        'Component = cmdClose'
        'Status = stsDefault')
      (
        'Component = frmAllgyBox'
        'Status = stsDefault'))
  end
end
