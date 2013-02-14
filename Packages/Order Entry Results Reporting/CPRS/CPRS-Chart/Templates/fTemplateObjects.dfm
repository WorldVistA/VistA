inherited frmTemplateObjects: TfrmTemplateObjects
  Left = 215
  Top = 343
  ActiveControl = cboObjects
  Caption = 'Insert Patient Data (Object)'
  ClientHeight = 273
  ClientWidth = 239
  FormStyle = fsStayOnTop
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  ExplicitWidth = 247
  ExplicitHeight = 300
  PixelsPerInch = 96
  TextHeight = 13
  object cboObjects: TORComboBox [0]
    Left = 0
    Top = 0
    Width = 239
    Height = 246
    Style = orcsSimple
    Align = alClient
    AutoSelect = True
    Caption = 'Patient Data'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '1'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    OnDblClick = cboObjectsDblClick
    CharsNeedMatch = 1
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 246
    Width = 239
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      239
      27)
    object btnCancel: TButton
      Left = 162
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Done'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnInsert: TButton
      Left = 82
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Insert Object'
      Default = True
      ModalResult = 4
      TabOrder = 0
      OnClick = btnInsertClick
    end
    object btnRefresh: TButton
      Left = 2
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Refresh'
      Default = True
      ModalResult = 4
      TabOrder = 2
      OnClick = btnRefreshClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboObjects'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnInsert'
        'Status = stsDefault')
      (
        'Component = btnRefresh'
        'Status = stsDefault')
      (
        'Component = frmTemplateObjects'
        'Status = stsDefault'))
  end
end
