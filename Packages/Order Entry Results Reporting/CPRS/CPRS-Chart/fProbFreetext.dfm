inherited frmProbFreetext: TfrmProbFreetext
  Anchors = []
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Unresolved Entry'
  ClientHeight = 218
  ClientWidth = 419
  OnCreate = FormCreate
  ExplicitWidth = 425
  ExplicitHeight = 246
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButton: TPanel [0]
    Left = 0
    Top = 183
    Width = 419
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object bbYes: TBitBtn
      Left = 139
      Top = 6
      Width = 70
      Height = 25
      Caption = '&Yes'
      ModalResult = 6
      TabOrder = 0
      OnClick = bbYesClick
    end
    object bbNo: TBitBtn
      Left = 225
      Top = 6
      Width = 70
      Height = 25
      Caption = '&No'
      Default = True
      ModalResult = 7
      TabOrder = 1
    end
  end
  object pnlLeft: TPanel [1]
    Left = 0
    Top = 0
    Width = 52
    Height = 183
    Align = alLeft
    AutoSize = True
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 2
    object imgIcon: TImage
      Left = 10
      Top = 10
      Width = 32
      Height = 32
    end
  end
  object pnlDialog: TPanel [2]
    Left = 52
    Top = 0
    Width = 367
    Height = 183
    Align = alClient
    AutoSize = True
    BevelOuter = bvNone
    TabOrder = 0
    object pnlMessage: TPanel
      Left = 0
      Top = 0
      Width = 367
      Height = 108
      Align = alClient
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object memMessage: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 10
        Width = 361
        Height = 52
        Margins.Top = 10
        TabStop = False
        Align = alTop
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          
            'A suitable term was not found based on user input and current de' +
            'faults.'
          
            'If you proceed with this nonspecific term, an ICD code of "799.9' +
            ' - OTHER '
          'UNKNOWN AND UNSPECIFIED CAUSE OF MORBIDITY OR '
          'MORTALITY" will be filed.')
        ReadOnly = True
        TabOrder = 0
      end
      object lblUse: TStaticText
        AlignWithMargins = True
        Left = 3
        Top = 68
        Width = 361
        Height = 37
        Align = alClient
        Caption = 'Use '
        TabOrder = 1
        ExplicitHeight = 42
      end
    end
    object pnlNTRT: TPanel
      Left = 0
      Top = 108
      Width = 367
      Height = 75
      Align = alBottom
      AutoSize = True
      BevelOuter = bvNone
      Padding.Top = 5
      Padding.Bottom = 5
      TabOrder = 1
      DesignSize = (
        367
        75)
      object edtComment: TLabeledEdit
        AlignWithMargins = True
        Left = 4
        Top = 46
        Width = 349
        Height = 21
        Hint = 'Enter descriptive information to help evaluate your request.'
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        EditLabel.Width = 243
        EditLabel.Height = 13
        EditLabel.Caption = 'New Term Request Comment (up to 80 characters):'
        MaxLength = 80
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Visible = False
        OnChange = edtCommentChange
      end
      object ckbNTRT: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 8
        Width = 115
        Height = 17
        Caption = '&Request New Term'
        TabOrder = 0
        OnClick = ckbNTRTClick
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 176
    Data = (
      (
        'Component = frmProbFreetext'
        'Status = stsDefault')
      (
        'Component = pnlButton'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlDialog'
        'Status = stsDefault')
      (
        'Component = bbYes'
        'Status = stsDefault')
      (
        'Component = bbNo'
        'Status = stsDefault')
      (
        'Component = edtComment'
        'Status = stsDefault')
      (
        'Component = ckbNTRT'
        'Status = stsDefault')
      (
        'Component = pnlNTRT'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = lblUse'
        'Status = stsDefault'))
  end
end
