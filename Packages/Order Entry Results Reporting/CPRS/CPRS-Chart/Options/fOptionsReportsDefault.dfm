inherited frmOptionsReportsDefault: TfrmOptionsReportsDefault
  Left = 773
  Top = 334
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Default Settings For Available CPRS Reports'
  ClientHeight = 178
  ClientWidth = 314
  OnCreate = FormCreate
  ExplicitHeight = 206
  TextHeight = 16
  object Bevel2: TBevel [0]
    Left = 0
    Top = 135
    Width = 308
    Height = 2
    Align = alBottom
    ExplicitTop = 173
    ExplicitWidth = 384
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 137
    Width = 308
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object btnOK: TButton
      AlignWithMargins = True
      Left = 198
      Top = 3
      Width = 50
      Height = 26
      Hint = 'Click to save the new setting.'
      Align = alRight
      Caption = 'OK'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnReset: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 94
      Height = 26
      Hint = 'Click to keep original setting'
      Align = alLeft
      Caption = 'Use Defaults'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnResetClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 254
      Top = 3
      Width = 57
      Height = 26
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCancelClick
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 107
    Width = 308
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 3
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 107
      Height = 16
      Align = alLeft
      Caption = 'Max Occurrences:'
    end
    object edtDefaultMax: TCaptionEdit
      AlignWithMargins = True
      Left = 116
      Top = 3
      Width = 195
      Height = 24
      Align = alClient
      TabOrder = 0
      OnExit = edtDefaultMaxExit
      OnKeyPress = odcDfStartKeyPress
      Caption = 'Max Occurrences'
      ExplicitLeft = 37
    end
  end
  object lblDefaultText: TMemo [3]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 302
    Height = 41
    TabStop = False
    Align = alTop
    Alignment = taCenter
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Click dots in boxes to set start and end dates. '
      'You can also input values directly.')
    ReadOnly = True
    TabOrder = 2
  end
  object Panel3: TPanel [4]
    Left = 0
    Top = 77
    Width = 308
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object Label4: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 63
      Height = 16
      Align = alLeft
      Caption = 'Stop Date:'
    end
    object odcDfStop: TORDateBox
      AlignWithMargins = True
      Left = 72
      Top = 3
      Width = 239
      Height = 24
      Align = alClient
      TabOrder = 0
      OnEnter = odcDfStartEnter
      OnExit = odcDfStopExit
      OnKeyPress = odcDfStartKeyPress
      DateOnly = True
      RequireTime = False
      Caption = ''
    end
  end
  object Panel4: TPanel [5]
    Left = 0
    Top = 47
    Width = 308
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object Label3: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 62
      Height = 16
      Align = alLeft
      Caption = 'Start Date:'
    end
    object odcDfStart: TORDateBox
      AlignWithMargins = True
      Left = 71
      Top = 3
      Width = 240
      Height = 24
      Align = alClient
      TabOrder = 0
      OnEnter = odcDfStartEnter
      OnExit = odcDfStartExit
      OnKeyPress = odcDfStartKeyPress
      DateOnly = True
      RequireTime = False
      Caption = ''
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 8
    Data = (
      (
        'Component = lblDefaultText'
        'Status = stsDefault')
      (
        'Component = edtDefaultMax'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnReset'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = odcDfStart'
        'Text = Start Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = odcDfStop'
        'Text = Stop Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = frmOptionsReportsDefault'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault'))
  end
end
