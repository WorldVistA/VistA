inherited frmOptionsNotes: TfrmOptionsNotes
  Left = 360
  Top = 264
  HelpContext = 9210
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Notes'
  ClientHeight = 196
  ClientWidth = 314
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  OnShow = FormShow
  ExplicitHeight = 221
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 308
    Height = 158
    Align = alClient
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 200
    ExplicitTop = 96
    ExplicitWidth = 185
    ExplicitHeight = 41
    object lblAutoSave1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 302
      Height = 21
      Align = alTop
      Caption = 'Interval for autosave of notes (sec):'
      WordWrap = True
      ExplicitWidth = 387
    end
    object lblCosigner: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 109
      Width = 302
      Height = 16
      Align = alBottom
      Caption = 'Default cosigner:'
      ExplicitLeft = 9
      ExplicitTop = 75
      ExplicitWidth = 100
    end
    object cboCosigner: TORComboBox
      AlignWithMargins = True
      Left = 3
      Top = 131
      Width = 302
      Height = 24
      HelpContext = 9216
      Style = orcsDropDown
      Align = alBottom
      AutoSelect = True
      Caption = 'Default cosigner'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 16
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2,3'
      Sorted = True
      SynonymChars = '<>'
      TabOrder = 0
      Text = ''
      OnExit = cboCosignerExit
      OnNeedData = cboCosignerNeedData
      CharsNeedMatch = 1
      ExplicitTop = 337
      ExplicitWidth = 568
    end
    object chkVerifyNote: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 86
      Width = 302
      Height = 17
      HelpContext = 9214
      Align = alBottom
      Caption = 'Verify note title'
      TabOrder = 1
      ExplicitTop = 344
      ExplicitWidth = 568
    end
    object chkAskSubject: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 63
      Width = 302
      Height = 17
      HelpContext = 9215
      Align = alBottom
      Caption = 'Ask subject for progress notes'
      TabOrder = 2
      ExplicitTop = 376
      ExplicitWidth = 568
    end
    object Panel2: TPanel
      Left = 0
      Top = 27
      Width = 308
      Height = 30
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 3
      ExplicitWidth = 574
      object txtAutoSave: TCaptionEdit
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 42
        Height = 24
        HelpContext = 9213
        Align = alLeft
        TabOrder = 0
        Text = '5'
        OnChange = txtAutoSaveChange
        OnExit = txtAutoSaveExit
        OnKeyPress = txtAutoSaveKeyPress
        Caption = ''
      end
      object spnAutoSave: TUpDown
        Left = 45
        Top = 3
        Width = 15
        Height = 24
        HelpContext = 9213
        Associate = txtAutoSave
        Max = 10000
        Increment = 5
        Position = 5
        TabOrder = 1
        Thousands = False
        OnClick = spnAutoSaveClick
      end
    end
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 164
    Width = 314
    Height = 32
    HelpContext = 9210
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    ExplicitLeft = 1
    ExplicitTop = 340
    ExplicitWidth = 572
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 314
      Height = 2
      Align = alTop
      ExplicitWidth = 399
    end
    object btnOK: TButton
      AlignWithMargins = True
      Left = 155
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9996
      Align = alRight
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
      ExplicitLeft = 413
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 236
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9997
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 494
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 200
    Top = 88
    Data = (
      (
        'Component = txtAutoSave'
        'Status = stsDefault')
      (
        'Component = spnAutoSave'
        'Status = stsDefault')
      (
        'Component = chkVerifyNote'
        'Status = stsDefault')
      (
        'Component = chkAskSubject'
        'Status = stsDefault')
      (
        'Component = cboCosigner'
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
        'Component = frmOptionsNotes'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault'))
  end
end
