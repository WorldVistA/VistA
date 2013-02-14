inherited frmAlertForward: TfrmAlertForward
  Left = 297
  Top = 206
  BorderStyle = bsDialog
  Caption = 'Forward Alert'
  ClientHeight = 381
  ClientWidth = 387
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 393
  ExplicitHeight = 406
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 387
    Height = 381
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object SrcLabel: TLabel
      Left = 12
      Top = 120
      Width = 144
      Height = 30
      AutoSize = False
      Caption = 'Select one or more names to receive forwarded alert'
      WordWrap = True
    end
    object DstLabel: TLabel
      Left = 231
      Top = 133
      Width = 145
      Height = 16
      AutoSize = False
      Caption = 'Currently selected recipients'
    end
    object Label1: TLabel
      Left = 12
      Top = 47
      Width = 44
      Height = 13
      Caption = 'Comment'
    end
    object cmdOK: TButton
      Left = 105
      Top = 349
      Width = 75
      Height = 25
      Caption = '&OK'
      TabOrder = 7
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 193
      Top = 349
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 8
      OnClick = cmdCancelClick
    end
    object cboSrcList: TORComboBox
      Left = 12
      Top = 156
      Width = 144
      Height = 185
      Style = orcsSimple
      AutoSelect = True
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2,3'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 2
      OnChange = cboSrcListChange
      OnKeyDown = cboSrcListKeyDown
      OnMouseClick = cboSrcListMouseClick
      OnNeedData = cboSrcListNeedData
      CharsNeedMatch = 1
    end
    object DstList: TORListBox
      Left = 231
      Top = 155
      Width = 144
      Height = 185
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = DstListChange
      Caption = 'Currently selected recipients'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
      OnChange = DstListChange
    end
    object memAlert: TMemo
      Left = 12
      Top = 8
      Width = 363
      Height = 33
      TabStop = False
      Color = clBtnFace
      Lines.Strings = (
        'memAlert')
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
    end
    object memComment: TMemo
      Left = 12
      Top = 64
      Width = 363
      Height = 49
      MaxLength = 180
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object btnAddAlert: TButton
      Left = 162
      Top = 200
      Width = 63
      Height = 25
      Caption = '&Add'
      TabOrder = 3
      OnClick = btnAddAlertClick
    end
    object btnRemoveAlertFwrd: TButton
      Left = 162
      Top = 231
      Width = 63
      Height = 25
      Caption = '&Remove'
      Enabled = False
      TabOrder = 5
      OnClick = btnRemoveAlertFwrdClick
    end
    object btnRemoveAllAlertFwrd: TButton
      Left = 162
      Top = 262
      Width = 63
      Height = 25
      Caption = 'R&emove All'
      Enabled = False
      TabOrder = 6
      OnClick = btnRemoveAllAlertFwrdClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 56
    Top = 72
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cboSrcList'
        'Label = SrcLabel'
        'Status = stsOK')
      (
        'Component = DstList'
        'Status = stsDefault')
      (
        'Component = memAlert'
        'Status = stsDefault')
      (
        'Component = memComment'
        'Status = stsDefault')
      (
        'Component = btnAddAlert'
        'Status = stsDefault')
      (
        'Component = btnRemoveAlertFwrd'
        'Status = stsDefault')
      (
        'Component = frmAlertForward'
        'Status = stsDefault')
      (
        'Component = btnRemoveAllAlertFwrd'
        'Status = stsDefault'))
  end
end
