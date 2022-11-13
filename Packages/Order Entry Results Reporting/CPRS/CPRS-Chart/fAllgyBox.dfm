inherited frmAllgyBox: TfrmAllgyBox
  Left = 487
  Top = 242
  Caption = 'frmAllgyBox'
  ClientWidth = 449
  Constraints.MinWidth = 457
  Position = poMainFormCenter
  ExplicitWidth = 457
  PixelsPerInch = 96
  TextHeight = 16
  inherited memReport: TRichEdit
    Width = 449
    ExplicitWidth = 449
  end
  inherited pnlButton: TPanel
    Width = 449
    ExplicitWidth = 449
    inherited cmdPrint: TButton
      Left = 290
      Anchors = [akTop, akRight]
      Caption = '&Print'
      TabOrder = 3
      ExplicitLeft = 290
      ExplicitTop = 3
      ExplicitHeight = 26
    end
    inherited cmdClose: TButton
      Left = 371
      Anchors = [akTop, akRight]
      Caption = '&Close'
      TabOrder = 4
      ExplicitLeft = 371
      ExplicitTop = 3
      ExplicitHeight = 26
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
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 90
      Height = 26
      Align = alLeft
      Caption = '&Add New'
      TabOrder = 0
      OnClick = cmdAddClick
      ExplicitLeft = 2
      ExplicitTop = 0
      ExplicitHeight = 21
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
