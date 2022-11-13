inherited frmAlertRangeEdit: TfrmAlertRangeEdit
  BorderStyle = bsDialog
  Caption = 'Range Selector'
  ClientHeight = 158
  ClientWidth = 415
  ExplicitWidth = 421
  ExplicitHeight = 187
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 126
    Width = 415
    Height = 32
    HelpContext = 9100
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 415
      Height = 2
      Align = alTop
      ExplicitWidth = 313
    end
    object Panel1: TPanel
      Left = 244
      Top = 2
      Width = 171
      Height = 30
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnOK: TButton
        AlignWithMargins = True
        Left = 12
        Top = 3
        Width = 75
        Height = 24
        HelpContext = 9996
        Align = alRight
        Caption = 'OK'
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TButton
        AlignWithMargins = True
        Left = 93
        Top = 3
        Width = 75
        Height = 24
        HelpContext = 9997
        Align = alRight
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
    object btnRestore: TButton
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 75
      Height = 24
      Align = alLeft
      Caption = 'Reset'
      Enabled = False
      TabOrder = 0
      OnClick = btnRestoreClick
    end
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 415
    Height = 126
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object ordtbStart: TORDateBox
      Left = 8
      Top = 75
      Width = 193
      Height = 21
      TabOrder = 0
      DateOnly = False
      RequireTime = True
      Caption = ''
      OnDateDialogClosed = ordtbStartDateDialogClosed
    end
    object ordtbStop: TORDateBox
      Left = 224
      Top = 75
      Width = 187
      Height = 21
      TabOrder = 1
      DateOnly = False
      RequireTime = True
      Caption = ''
      OnDateDialogClosed = ordtbStartDateDialogClosed
    end
    object stxtRange: TVA508StaticText
      Name = 'stxtRange'
      Left = 8
      Top = 27
      Width = 27
      Height = 15
      Alignment = taLeftJustify
      Caption = ''
      TabOrder = 2
      ShowAccelChar = True
    end
    object stxtRangeInfo: TVA508StaticText
      Name = 'stxtRangeInfo'
      Left = 8
      Top = 6
      Width = 232
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Select Start and Stop Dates within the Range of:'
      TabOrder = 3
      ShowAccelChar = True
    end
    object stxtStart: TVA508StaticText
      Name = 'stxtStart'
      Left = 8
      Top = 54
      Width = 27
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Start '
      TabOrder = 4
      ShowAccelChar = True
    end
    object stxtStop: TVA508StaticText
      Name = 'stxtStop'
      Left = 224
      Top = 53
      Width = 50
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Stop Date'
      TabOrder = 5
      ShowAccelChar = True
    end
    object stxtChanged: TStaticText
      Left = 312
      Top = 5
      Width = 45
      Height = 17
      Alignment = taRightJustify
      Caption = 'Updated'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Visible = False
    end
    object stxtRangeHint: TVA508StaticText
      Name = 'stxtRangeHint'
      AlignWithMargins = True
      Left = 3
      Top = 108
      Width = 409
      Height = 15
      Align = alBottom
      Alignment = taLeftJustify
      Caption = 
        'Please note that range can'#39't exceed XXX days limit set for this ' +
        'site'
      TabOrder = 7
      ShowAccelChar = True
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 320
    Top = 16
    Data = (
      (
        'Component = frmAlertRangeEdit'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = ordtbStart'
        'Status = stsDefault')
      (
        'Component = ordtbStop'
        'Status = stsDefault')
      (
        'Component = stxtStart'
        'Status = stsDefault')
      (
        'Component = stxtStop'
        'Status = stsDefault')
      (
        'Component = stxtChanged'
        'Status = stsDefault')
      (
        'Component = btnRestore'
        'Status = stsDefault')
      (
        'Component = stxtRangeInfo'
        'Status = stsDefault')
      (
        'Component = stxtRange'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = stxtRangeHint'
        'Status = stsDefault'))
  end
end
