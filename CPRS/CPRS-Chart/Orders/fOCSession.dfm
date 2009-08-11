inherited frmOCSession: TfrmOCSession
  Left = 366
  Top = 222
  BorderIcons = []
  Caption = 'Order Checks'
  ClientWidth = 494
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 502
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object lstChecks: TCaptionListBox [0]
    Left = 0
    Top = 0
    Width = 494
    Height = 162
    Style = lbOwnerDrawVariable
    Align = alClient
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnDrawItem = lstChecksDrawItem
    OnMeasureItem = lstChecksMeasureItem
    HintOnItem = True
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 162
    Width = 494
    Height = 111
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      494
      111)
    object lblJustify: TLabel
      Left = 9
      Top = 34
      Width = 248
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Enter justification for overriding critical order checks -'
    end
    object txtJustify: TCaptionEdit
      Left = 8
      Top = 50
      Width = 478
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 80
      TabOrder = 0
      OnKeyDown = txtJustifyKeyDown
      Caption = 'Enter justification for overriding critical order checks -'
    end
    object cmdCancelOrder: TButton
      Left = 356
      Top = 5
      Width = 131
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Cancel Selected Order(s)'
      TabOrder = 3
      OnClick = cmdCancelOrderClick
    end
    object cmdContinue: TButton
      Left = 157
      Top = 82
      Width = 70
      Height = 21
      Caption = 'Continue'
      TabOrder = 4
      OnClick = cmdContinueClick
    end
    object btnReturn: TButton
      Left = 241
      Top = 82
      Width = 97
      Height = 21
      Cancel = True
      Caption = 'Return to Orders'
      TabOrder = 5
      OnClick = btnReturnClick
    end
    object memNote: TMemo
      Left = 8
      Top = 4
      Width = 329
      Height = 29
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'NOTE: The override justification is for tracking purposes and '
        'does not change or place new order(s).')
      ReadOnly = True
      TabOrder = 1
      OnEnter = memNoteEnter
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lstChecks'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = txtJustify'
        'Status = stsDefault')
      (
        'Component = cmdCancelOrder'
        'Status = stsDefault')
      (
        'Component = cmdContinue'
        'Status = stsDefault')
      (
        'Component = btnReturn'
        'Status = stsDefault')
      (
        'Component = memNote'
        'Status = stsDefault')
      (
        'Component = frmOCSession'
        'Status = stsDefault'))
  end
end
