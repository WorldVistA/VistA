inherited frmReportsAdhocSubItem1: TfrmReportsAdhocSubItem1
  Left = 223
  Top = 170
  BorderIcons = [biSystemMenu]
  Caption = 'frmReportsAdhocSubItem1'
  ClientHeight = 314
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 341
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox [0]
    Left = 0
    Top = 0
    Width = 427
    Height = 314
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    object Splitter3: TSplitter
      Left = 201
      Top = 49
      Width = 5
      Height = 230
    end
    object pnl7Button: TKeyClickPanel
      Left = 395
      Top = 81
      Width = 19
      Height = 24
      BevelOuter = bvNone
      TabOrder = 4
      TabStop = True
      OnClick = SpeedButton7Click
      OnEnter = pnl7ButtonEnter
      OnExit = pnl7ButtonExit
      object SpeedButton7: TSpeedButton
        Left = 1
        Top = 1
        Width = 17
        Height = 22
        Enabled = False
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
          3333333333777F3333333333330F033333333333337F7F3333333333330F0333
          33333333337F7F3333333333330F033333333333337F7F3333333333330F0333
          33333333337F7F3333333333330F033333333333FF7F7FFFF3333330000F0000
          3333333777737777F3333330FFFFFFF0333333373F333337333333330FFFFF03
          333333337F33337F333333330FFFFF033333333373F333733333333330FFF033
          3333333337F337F33333333330FFF03333333333373F373333333333330F0333
          33333333337F7F3333333333330F033333333333337373333333333333303333
          333333333337F333333333333330333333333333333733333333}
        NumGlyphs = 2
        OnClick = SpeedButton7Click
      end
    end
    object pnl8Button: TKeyClickPanel
      Left = 395
      Top = 106
      Width = 19
      Height = 24
      BevelOuter = bvNone
      TabOrder = 5
      TabStop = True
      OnClick = SpeedButton8Click
      OnEnter = pnl7ButtonEnter
      OnExit = pnl7ButtonExit
      object SpeedButton8: TSpeedButton
        Left = 1
        Top = 1
        Width = 17
        Height = 22
        Enabled = False
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
          333333333337F33333333333333033333333333333373F3333333333330F0333
          33333333337F7F3333333333330F033333333333337373F33333333330FFF033
          3333333337F337F33333333330FFF033333333333733373F333333330FFFFF03
          333333337F33337F333333330FFFFF033333333373333373F3333330FFFFFFF0
          33333337FFFF3FF7F3333330000F000033333337777F777733333333330F0333
          33333333337F7F3333333333330F033333333333337F7F3333333333330F0333
          33333333337F7F3333333333330F033333333333337F7F3333333333330F0333
          33333333337F7F33333333333300033333333333337773333333}
        NumGlyphs = 2
        OnClick = SpeedButton8Click
      end
    end
    object ORComboBox2: TORComboBox
      Left = 2
      Top = 49
      Width = 199
      Height = 230
      Style = orcsSimple
      Align = alLeft
      AutoSelect = True
      Caption = 'File Selections'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      OnDblClick = btnAddSelClick
      OnKeyUp = ORComboBox2KeyUp
      OnNeedData = ORComboBox2NeedData
      CharsNeedMatch = 1
    end
    object ORListBox1: TORListBox
      Left = 232
      Top = 48
      Width = 161
      Height = 129
      DragMode = dmAutomatic
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnDragDrop = ORListBox1DragDrop
      OnDragOver = ORListBox1DragOver
      OnEndDrag = ORListBox1EndDrag
      Caption = 'File Entries Selected'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object Panel4: TPanel
      Left = 2
      Top = 15
      Width = 423
      Height = 34
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label4: TLabel
        Left = 0
        Top = 20
        Width = 71
        Height = 13
        Caption = 'File Selections:'
      end
      object Label5: TLabel
        Left = 232
        Top = 20
        Width = 99
        Height = 13
        Caption = 'File Entries Selected:'
      end
      object Label6: TStaticText
        Left = 232
        Top = 1
        Width = 98
        Height = 17
        Caption = 'Selections allowed: '
        TabOrder = 0
      end
      object lblLimit: TStaticText
        Left = 328
        Top = 1
        Width = 42
        Height = 17
        Caption = 'No Limit'
        TabOrder = 1
      end
    end
    object Panel5: TPanel
      Left = 2
      Top = 279
      Width = 423
      Height = 33
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 6
      DesignSize = (
        423
        33)
      object btnCancel: TButton
        Left = 341
        Top = 4
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = btnCancelClick
      end
      object btnOK: TButton
        Left = 251
        Top = 4
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'OK'
        TabOrder = 0
        OnClick = btnOKClick
      end
    end
    object Panel8: TPanel
      Left = 208
      Top = 56
      Width = 25
      Height = 137
      BevelOuter = bvNone
      TabOrder = 2
      object btnAddSel: TButton
        Left = 4
        Top = 5
        Width = 17
        Height = 22
        Caption = '>'
        TabOrder = 0
        OnClick = btnAddSelClick
      end
      object btnRemoveSel: TButton
        Left = 4
        Top = 30
        Width = 17
        Height = 22
        Caption = '<'
        TabOrder = 1
        OnClick = btnRemoveSelClick
      end
      object btnRemoveAllSel: TButton
        Left = 4
        Top = 55
        Width = 17
        Height = 22
        Caption = '<<'
        TabOrder = 2
        OnClick = btnRemoveAllSelClick
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = GroupBox1'
        'Status = stsDefault')
      (
        'Component = pnl7Button'
        'Status = stsDefault')
      (
        'Component = pnl8Button'
        'Status = stsDefault')
      (
        'Component = ORComboBox2'
        'Status = stsDefault')
      (
        'Component = ORListBox1'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = Label6'
        'Status = stsDefault')
      (
        'Component = lblLimit'
        'Status = stsDefault')
      (
        'Component = Panel5'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = Panel8'
        'Status = stsDefault')
      (
        'Component = btnAddSel'
        'Status = stsDefault')
      (
        'Component = btnRemoveSel'
        'Status = stsDefault')
      (
        'Component = btnRemoveAllSel'
        'Status = stsDefault')
      (
        'Component = frmReportsAdhocSubItem1'
        'Status = stsDefault'))
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 392
    Top = 16
  end
end
