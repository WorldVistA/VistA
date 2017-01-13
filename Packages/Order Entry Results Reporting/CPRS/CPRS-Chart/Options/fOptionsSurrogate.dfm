inherited frmOptionsSurrogate: TfrmOptionsSurrogate
  Left = 232
  Top = 107
  HelpContext = 9100
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Surrogate for Notifications'
  ClientHeight = 136
  ClientWidth = 313
  HelpFile = 'CPRSWT.HLP'
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblSurrogate: TLabel [0]
    Left = 7
    Top = 51
    Width = 49
    Height = 13
    Caption = 'Surrogate:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblSurrogateText: TStaticText [1]
    Left = 157
    Top = 4
    Width = 81
    Height = 17
    Caption = 'lblSurrogateText'
    TabOrder = 4
  end
  object lblStart: TStaticText [2]
    Left = 157
    Top = 24
    Width = 36
    Height = 17
    Caption = 'lblStart'
    TabOrder = 5
  end
  object lblStop: TStaticText [3]
    Left = 157
    Top = 44
    Width = 36
    Height = 17
    Caption = 'lblStop'
    TabOrder = 6
  end
  object cboSurrogate: TORComboBox [4]
    Left = 7
    Top = 66
    Width = 145
    Height = 21
    HelpContext = 9102
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Surrogate'
    Color = clWindow
    DropDownCount = 8
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
    TabOrder = 0
    Text = ''
    OnChange = cboSurrogateChange
    OnExit = cboSurrogateChange
    OnKeyDown = cboSurrogateKeyDown
    OnNeedData = cboSurrogateNeedData
    CharsNeedMatch = 1
  end
  object btnSurrogateDateRange: TButton [5]
    Left = 157
    Top = 66
    Width = 145
    Height = 22
    HelpContext = 9103
    Caption = 'Surrogate Date Range...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnSurrogateDateRangeClick
  end
  object btnRemove: TButton [6]
    Left = 7
    Top = 20
    Width = 145
    Height = 22
    HelpContext = 9101
    Caption = 'Remove Surrogate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnRemoveClick
  end
  object pnlBottom: TPanel [7]
    Left = 0
    Top = 103
    Width = 313
    Height = 33
    HelpContext = 9100
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    DesignSize = (
      313
      33)
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 313
      Height = 2
      Align = alTop
    end
    object btnCancel: TButton
      Left = 229
      Top = 8
      Width = 75
      Height = 22
      HelpContext = 9997
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 149
      Top = 8
      Width = 75
      Height = 22
      HelpContext = 9996
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblSurrogateText'
        'Status = stsDefault')
      (
        'Component = lblStart'
        'Status = stsDefault')
      (
        'Component = lblStop'
        'Status = stsDefault')
      (
        'Component = cboSurrogate'
        'Status = stsDefault')
      (
        'Component = btnSurrogateDateRange'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = frmOptionsSurrogate'
        'Status = stsDefault'))
  end
  object dlgSurrogateDateRange: TORDateRangeDlg
    DateOnly = False
    Instruction = 
      'Enter a date range to begin and end when this will be in effect.' +
      ' Otherwise it will always be in effect.'
    LabelStart = 'Start Date'
    LabelStop = 'Stop Date'
    RequireTime = False
    Format = 'mmm d,yy@hh:nn'
    TextOfStop = 'Jun 6,99@12:45'
    Left = 265
    Top = 4
  end
end
