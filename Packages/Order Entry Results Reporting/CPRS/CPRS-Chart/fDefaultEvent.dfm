inherited frmDefaultEvent: TfrmDefaultEvent
  Left = 311
  Top = 193
  BorderStyle = bsSingle
  Caption = 'Set/Change Default Release Event'
  ClientHeight = 317
  ClientWidth = 394
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 394
    Height = 25
    Align = alTop
    TabOrder = 0
    object lblCaption: TLabel
      Left = 1
      Top = 1
      Width = 363
      Height = 13
      Align = alClient
      Caption = 
        ' Select an event from the following list as your personal defaul' +
        't release event:'
      WordWrap = True
    end
  end
  object cboEvents: TORComboBox [1]
    Left = 0
    Top = 25
    Width = 394
    Height = 261
    Style = orcsSimple
    Align = alClient
    AutoSelect = False
    Caption = 
      ' Select an event from the following list as your personal defaul' +
      't release event:'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    ParentShowHint = False
    Pieces = '9'
    ShowHint = True
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 1
    CheckEntireLine = True
    CharsNeedMatch = 1
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 286
    Width = 394
    Height = 31
    Align = alBottom
    TabOrder = 2
    object btnOK: TButton
      Left = 212
      Top = 6
      Width = 75
      Height = 20
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 296
      Top = 6
      Width = 75
      Height = 20
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = cboEvents'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmDefaultEvent'
        'Status = stsDefault'))
  end
end
