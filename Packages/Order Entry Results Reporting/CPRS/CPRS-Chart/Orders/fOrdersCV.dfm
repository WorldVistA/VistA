inherited frmChgEvent: TfrmChgEvent
  Left = 256
  Top = 148
  Caption = 'Change Release Event'
  ClientHeight = 401
  ClientWidth = 554
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 562
  ExplicitHeight = 428
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 554
    Height = 38
    Align = alTop
    AutoSize = True
    TabOrder = 0
    object lblPtInfo: TLabel
      Left = 1
      Top = 1
      Width = 3
      Height = 36
      Align = alTop
      Color = clBtnFace
      Constraints.MinHeight = 36
      ParentColor = False
      Layout = tlCenter
    end
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 38
    Width = 554
    Height = 363
    Align = alClient
    TabOrder = 1
    ExplicitHeight = 362
    DesignSize = (
      554
      363)
    object cboSpecialty: TORComboBox
      Left = 12
      Top = 8
      Width = 443
      Height = 344
      Anchors = [akLeft, akTop, akRight, akBottom]
      Style = orcsSimple
      AutoSelect = True
      Caption = ''
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '9'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      Text = ''
      OnChange = cboSpecialtyChange
      OnDblClick = cboSpecialtyDblClick
      CharsNeedMatch = 1
    end
    object btnCancel: TButton
      Left = 466
      Top = 331
      Width = 75
      Height = 20
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnAction: TButton
      Left = 466
      Top = 303
      Width = 75
      Height = 20
      Anchors = [akRight, akBottom]
      TabOrder = 2
      Visible = False
      OnClick = btnActionClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = cboSpecialty'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnAction'
        'Status = stsDefault')
      (
        'Component = frmChgEvent'
        'Status = stsDefault'))
  end
end
