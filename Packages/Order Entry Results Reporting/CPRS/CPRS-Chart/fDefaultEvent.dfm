inherited frmDefaultEvent: TfrmDefaultEvent
  Left = 311
  Top = 193
  BorderStyle = bsSingle
  Caption = 'Set/Change Default Release Event'
  ClientHeight = 317
  ClientWidth = 394
  OnCreate = FormCreate
  ExplicitWidth = 400
  ExplicitHeight = 342
  PixelsPerInch = 96
  TextHeight = 16
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 394
    Height = 41
    Align = alTop
    TabOrder = 0
    object lblCaption: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 386
      Height = 33
      Align = alClient
      Caption = 
        ' Select an event from the following list as your personal defaul' +
        't release event:'
      WordWrap = True
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 392
      ExplicitHeight = 24
    end
  end
  object cboEvents: TORComboBox [1]
    Left = 0
    Top = 41
    Width = 394
    Height = 245
    Style = orcsSimple
    Align = alClient
    AutoSelect = False
    Caption = 
      ' Select an event from the following list as your personal defaul' +
      't release event:'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 16
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
    Text = ''
    CheckEntireLine = True
    CharsNeedMatch = 1
    ExplicitTop = 25
    ExplicitHeight = 261
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 286
    Width = 394
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnOK: TButton
      AlignWithMargins = True
      Left = 235
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
      ExplicitLeft = 212
      ExplicitTop = 6
      ExplicitHeight = 20
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 316
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
      ExplicitLeft = 296
      ExplicitTop = 6
      ExplicitHeight = 20
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 48
    Top = 80
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
