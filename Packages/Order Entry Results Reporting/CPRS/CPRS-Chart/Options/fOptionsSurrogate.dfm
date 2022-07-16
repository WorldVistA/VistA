inherited frmOptionsSurrogate: TfrmOptionsSurrogate
  Left = 232
  Top = 107
  HelpContext = 9100
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Surrogate for Notifications'
  ClientHeight = 294
  ClientWidth = 589
  HelpFile = 'CPRSWT.HLP'
  KeyPreview = False
  ExplicitWidth = 595
  ExplicitHeight = 323
  PixelsPerInch = 96
  TextHeight = 13
  object clvSurrogates: TCaptionListView [0]
    Left = 0
    Top = 81
    Width = 589
    Height = 189
    Hint = 
      'Add, Edit, or Remove the Surrogate within the selected time rang' +
      'e'
    HelpContext = 9035
    Align = alClient
    Columns = <
      item
        Caption = '#'
        Width = 32
      end
      item
        Caption = 'Name'
        Width = 166
      end
      item
        Caption = 'Start Date'
        Width = 110
      end
      item
        Caption = 'Stop Date'
        Width = 110
      end
      item
        Caption = 'Comments'
        Width = 150
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    OnChange = clvSurrogatesChange
    OnCompare = clvSurrogatesCompare
    OnCustomDrawItem = clvSurrogatesCustomDrawItem
    OnDblClick = clvSurrogatesDblClick
    OnKeyDown = clvSurrogatesKeyDown
    OnMouseDown = clvSurrogatesMouseDown
    AutoSize = False
    Caption = 'You can add, remove, or modify the surrogate'
    HideTinyColumns = False
    Pieces = '1,2,3,4'
  end
  object pnlParams: TPanel [1]
    Left = 0
    Top = 0
    Width = 589
    Height = 49
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentColor = True
    ParentFont = False
    TabOrder = 0
    object lblDefaultPeriod: TLabel
      Left = 138
      Top = 28
      Width = 203
      Height = 13
      Caption = 'Default surrogate period (from 1 to 30 days)'
    end
    object cbUseDefaultDates: TCheckBox
      AlignWithMargins = True
      Left = 96
      Top = 3
      Width = 490
      Height = 16
      Hint = 
        'If checkmarked the "Start" and "Stop" fields of the surrogate re' +
        'cord are populated with dates'
      HelpContext = 9032
      Margins.Left = 96
      Align = alTop
      Caption = 
        '         Use default Start and Stop dates when entering a new su' +
        'rrogate'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbUseDefaultDatesClick
    end
    object edDefaultPeriod: TEdit
      Left = 96
      Top = 25
      Width = 27
      Height = 21
      TabOrder = 1
      Text = '7'
      OnChange = edDefaultPeriodChange
      OnExit = edDefaultPeriodExit
      OnKeyPress = edDefaultPeriodKeyPress
    end
    object txtDefaultPeriod: TVA508StaticText
      Name = 'txtDefaultPeriod'
      Left = 342
      Top = 28
      Width = 197
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Default surrogate period edit box disabled'
      TabOrder = 2
      TabStop = True
      ShowAccelChar = True
    end
  end
  object pnlSurrogateTools: TPanel [2]
    Left = 0
    Top = 49
    Width = 589
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object pnlUpdateIndicator: TPanel
      Left = 0
      Top = 0
      Width = 19
      Height = 32
      Align = alLeft
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object stxtChanged: TVA508StaticText
        Name = 'stxtChanged'
        Left = 8
        Top = 9
        Width = 7
        Height = 15
        Hint = 'Changes are not saved'
        Alignment = taLeftJustify
        Caption = '!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TabStop = True
        Visible = False
        ShowAccelChar = True
      end
    end
    object pnlInfo: TPanel
      AlignWithMargins = True
      Left = 22
      Top = 3
      Width = 380
      Height = 26
      Align = alLeft
      Alignment = taLeftJustify
      BevelOuter = bvNone
      TabOrder = 1
      object lblInfo: TLabel
        Left = 16
        Top = 6
        Width = 215
        Height = 13
        Caption = 'You can add, remove, or modify the surrogate'
      end
    end
    object pnlToolBar: TPanel
      Left = 400
      Top = 0
      Width = 189
      Height = 32
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      object txtRemove: TVA508StaticText
        Name = 'txtRemove'
        Left = 122
        Top = 6
        Width = 117
        Height = 15
        Alignment = taLeftJustify
        Caption = 'Remove button disabled'
        TabOrder = 3
        TabStop = True
        ShowAccelChar = True
      end
      object txtSurrEdit: TVA508StaticText
        Name = 'txtSurrEdit'
        Left = 8
        Top = 6
        Width = 145
        Height = 15
        Alignment = taLeftJustify
        Caption = 'Add Surrogate button disabled'
        TabOrder = 1
        TabStop = True
        ShowAccelChar = True
      end
      object btnRemove: TButton
        AlignWithMargins = True
        Left = 114
        Top = 3
        Width = 72
        Height = 26
        Hint = 'Remove selected surrogate'
        HelpContext = 9101
        Align = alRight
        Caption = '&Remove'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnRemoveClick
      end
      object btnSurrEdit: TButton
        AlignWithMargins = True
        Left = 6
        Top = 3
        Width = 102
        Height = 26
        Hint = 'Add/Edit Surrogate within the selected range'
        Align = alRight
        Caption = '&Add Surrogate'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnSurrEditClick
      end
    end
  end
  object pnlDebug: TPanel [3]
    Left = 0
    Top = 270
    Width = 589
    Height = 24
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentColor = True
    ParentFont = False
    TabOrder = 3
    Visible = False
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = clvSurrogates'
        'Status = stsDefault')
      (
        'Component = pnlParams'
        'Status = stsDefault')
      (
        'Component = cbUseDefaultDates'
        'Status = stsDefault')
      (
        'Component = edDefaultPeriod'
        
          'Text = Default surrogate period, enter a value between 1 and 30 ' +
          'days'
        'Status = stsOK')
      (
        'Component = txtDefaultPeriod'
        'Status = stsDefault')
      (
        'Component = pnlSurrogateTools'
        'Status = stsDefault')
      (
        'Component = pnlUpdateIndicator'
        'Status = stsDefault')
      (
        'Component = stxtChanged'
        'Text = Surrogates have changed'
        'Status = stsOK')
      (
        'Component = pnlInfo'
        'Status = stsDefault')
      (
        'Component = pnlToolBar'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = btnSurrEdit'
        'Status = stsDefault')
      (
        'Component = txtRemove'
        'Status = stsDefault')
      (
        'Component = txtSurrEdit'
        'Status = stsDefault')
      (
        'Component = pnlDebug'
        'Status = stsDefault')
      (
        'Component = frmOptionsSurrogate'
        'Status = stsDefault'))
  end
end
