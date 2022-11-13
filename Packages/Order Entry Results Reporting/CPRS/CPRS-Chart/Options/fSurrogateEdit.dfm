inherited frmSurrogateEdit: TfrmSurrogateEdit
  BorderStyle = bsDialog
  Caption = 'Surrogate Management'
  ClientHeight = 211
  ClientWidth = 311
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 317
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    AlignWithMargins = True
    Left = 3
    Top = 176
    Width = 305
    Height = 32
    HelpContext = 9100
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 305
      Height = 2
      Align = alTop
      ExplicitWidth = 366
    end
    object txtReset: TStaticText
      Left = 8
      Top = 8
      Width = 110
      Height = 17
      Caption = 'Reset Button Disabled'
      TabOrder = 1
      TabStop = True
    end
    object Panel1: TPanel
      Left = 134
      Top = 2
      Width = 171
      Height = 30
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      object txtCancel: TStaticText
        Left = 93
        Top = 6
        Width = 115
        Height = 17
        Caption = 'Cancel Button Disabled'
        TabOrder = 3
        TabStop = True
      end
      object txtOK: TStaticText
        Left = 12
        Top = 6
        Width = 97
        Height = 17
        Caption = 'OK Button Disabled'
        TabOrder = 2
        TabStop = True
      end
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
    object btnReset: TButton
      AlignWithMargins = True
      Left = 8
      Top = 5
      Width = 75
      Height = 24
      Margins.Left = 8
      Action = ActionReset
      Align = alLeft
      TabOrder = 0
    end
  end
  object pnlSurrogateTools: TPanel [1]
    Left = 0
    Top = 0
    Width = 311
    Height = 173
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      311
      173)
    object stxtAllowedRange: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 157
      Width = 305
      Height = 13
      Align = alBottom
      Caption = 'Start and stop times must be within this range...'
      ExplicitWidth = 221
    end
    object cboSurrogate: TORComboBox
      AlignWithMargins = True
      Left = 4
      Top = 21
      Width = 301
      Height = 21
      Hint = 'Surrogate Name'
      HelpContext = 9102
      Anchors = [akLeft, akTop, akRight]
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Surrogate Name'
      Color = clWindow
      DropDownCount = 7
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2,3'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      TabStop = True
      Text = ''
      OnChange = cboSurrogateChange
      OnNeedData = cboSurrogateNeedData
      CharsNeedMatch = 1
    end
    object ordtbStart: TORDateBox
      Left = 4
      Top = 65
      Width = 142
      Height = 21
      Hint = 'Surrogate Start Date and Time'
      TabOrder = 3
      DateOnly = False
      RequireTime = True
      Caption = ''
      OnDateDialogClosed = ordtbStartDateDialogClosed
    end
    object ordtbStop: TORDateBox
      Left = 152
      Top = 65
      Width = 153
      Height = 21
      Hint = 'Surrogate End Date and Time'
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
      DateOnly = False
      RequireTime = True
      Caption = ''
      OnDateDialogClosed = ordtbStopDateDialogClosed
    end
    object VA508StaticText1: TStaticText
      Left = 4
      Top = 48
      Width = 26
      Height = 17
      Caption = 'Start'
      TabOrder = 2
    end
    object VA508StaticText2: TStaticText
      Left = 152
      Top = 48
      Width = 26
      Height = 17
      Caption = 'Stop'
      TabOrder = 4
    end
    object VA508StaticTextName: TStaticText
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 32
      Height = 17
      Caption = 'Name'
      TabOrder = 0
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 384
    Top = 152
    Data = (
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
        'Component = txtOK'
        'Status = stsDefault')
      (
        'Component = txtCancel'
        'Status = stsDefault')
      (
        'Component = btnReset'
        'Status = stsDefault')
      (
        'Component = pnlSurrogateTools'
        'Status = stsDefault')
      (
        'Component = cboSurrogate'
        'Status = stsDefault')
      (
        'Component = ordtbStart'
        
          'Text = Surrogate Start Date and Time. Press the enter key to acc' +
          'ess.'
        'Status = stsOK')
      (
        'Component = ordtbStop'
        
          'Text = Surrogate Stop Date and Time. Press the enter key to acce' +
          'ss.'
        'Status = stsOK')
      (
        'Component = VA508StaticText1'
        'Status = stsDefault')
      (
        'Component = VA508StaticText2'
        'Status = stsDefault')
      (
        'Component = VA508StaticTextName'
        'Status = stsDefault')
      (
        'Component = frmSurrogateEdit'
        'Status = stsDefault')
      (
        'Component = txtReset'
        'Status = stsDefault'))
  end
  object ALMain: TActionList
    OnUpdate = ALMainUpdate
    Left = 72
    Top = 4
    object ActionReset: TAction
      Caption = 'Reset'
      ShortCut = 16466
      OnExecute = ActionResetExecute
    end
  end
end
