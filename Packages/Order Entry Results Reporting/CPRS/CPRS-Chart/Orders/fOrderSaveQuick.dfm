inherited frmSaveQuickOrder: TfrmSaveQuickOrder
  Left = 308
  Top = 171
  Caption = 'Add to Common List (Meds, Inpatient)'
  ClientHeight = 335
  ClientWidth = 355
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 371
  ExplicitHeight = 373
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 355
    Height = 113
    Align = alTop
    TabOrder = 0
    object lblDisplayName: TLabel
      Left = 8
      Top = 70
      Width = 261
      Height = 13
      Caption = 'Enter the name that should be used for this quick order.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object memOrder: TMemo
      Left = 8
      Top = 8
      Width = 340
      Height = 46
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
    end
    object txtDisplayName: TCaptionEdit
      Left = 8
      Top = 84
      Width = 340
      Height = 21
      TabOrder = 1
      OnChange = txtDisplayNameChange
      Caption = 'Enter the name that should be used for this quick order.'
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 113
    Width = 355
    Height = 181
    Align = alClient
    TabOrder = 1
    object lblQuickList: TLabel
      Left = 8
      Top = 8
      Width = 136
      Height = 13
      Caption = 'Meds, Inpatient Common List'
    end
    object lstQuickList: TORListBox
      Left = 8
      Top = 30
      Width = 270
      Height = 141
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'Meds, Inpatient Common List'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object pnlUpButton: TKeyClickPanel
      Left = 292
      Top = 42
      Width = 30
      Height = 27
      BevelOuter = bvNone
      Caption = 'Display selected medication earlier'
      TabOrder = 2
      TabStop = True
      OnEnter = pnlUpButtonEnter
      OnExit = pnlUpButtonExit
      OnMouseDown = pnlUpButtonMouseDown
      OnMouseUp = pnlUpButtonMouseUp
      DesignSize = (
        30
        27)
      object cmdUp: TSpeedButton
        Left = 0
        Top = 0
        Width = 30
        Height = 24
        Anchors = [akLeft, akTop, akRight, akBottom]
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33333333333333333333333333333333333333333CCCCC33333333333CCCCC33
          333333333CCCCC33333333333CCCCC33333333333CCCCC33333333333CCCCC33
          3333333CCCCCCCCC33333333CCCCCCC3333333333CCCCC333333333333CCC333
          33333333333C3333333333333333333333333333333333333333}
        OnMouseDown = cmdUpMouseDown
        OnMouseUp = cmdUpMouseUp
      end
    end
    object pnlDownButton: TKeyClickPanel
      Left = 292
      Top = 76
      Width = 31
      Height = 26
      BevelOuter = bvNone
      Caption = 'Display selected medication  later'
      TabOrder = 3
      TabStop = True
      OnEnter = pnlUpButtonEnter
      OnExit = pnlUpButtonExit
      OnMouseDown = pnlDownButtonMouseDown
      OnMouseUp = pnlDownButtonMouseUp
      DesignSize = (
        31
        26)
      object cmdDown: TSpeedButton
        Left = 0
        Top = -1
        Width = 31
        Height = 22
        Anchors = [akLeft, akTop, akRight, akBottom]
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333333333333333333333333C33333333333333CCC333
          333333333CCCCC3333333333CCCCCCC33333333CCCCCCCCC333333333CCCCC33
          333333333CCCCC33333333333CCCCC33333333333CCCCC33333333333CCCCC33
          333333333CCCCC33333333333333333333333333333333333333}
        OnMouseDown = cmdDownMouseDown
        OnMouseUp = cmdDownMouseUp
      end
    end
    object cmdRename: TButton
      Left = 286
      Top = 128
      Width = 62
      Height = 21
      Caption = 'Rename'
      TabOrder = 4
      OnClick = cmdRenameClick
    end
    object cmdDelete: TButton
      Left = 286
      Top = 153
      Width = 62
      Height = 21
      Caption = 'Delete'
      TabOrder = 5
      OnClick = cmdDeleteClick
    end
  end
  object Panel3: TPanel [2]
    Left = 0
    Top = 294
    Width = 355
    Height = 41
    Align = alBottom
    TabOrder = 2
    object cmdOK: TButton
      Left = 98
      Top = 11
      Width = 72
      Height = 21
      Caption = 'OK'
      TabOrder = 0
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 186
      Top = 11
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = txtDisplayName'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = lstQuickList'
        'Status = stsDefault')
      (
        'Component = pnlUpButton'
        'Status = stsDefault')
      (
        'Component = pnlDownButton'
        'Status = stsDefault')
      (
        'Component = cmdRename'
        'Status = stsDefault')
      (
        'Component = cmdDelete'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmSaveQuickOrder'
        'Status = stsDefault'))
  end
end
