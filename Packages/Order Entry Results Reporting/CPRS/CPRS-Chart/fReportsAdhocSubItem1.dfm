inherited frmReportsAdhocSubItem1: TfrmReportsAdhocSubItem1
  Left = 223
  Top = 170
  BorderIcons = [biSystemMenu]
  Caption = 'frmReportsAdhocSubItem1'
  ClientHeight = 386
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 341
  PixelsPerInch = 120
  TextHeight = 16
  object GroupBox1: TGroupBox [0]
    Left = 0
    Top = 0
    Width = 526
    Height = 386
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    TabOrder = 0
    object Splitter3: TSplitter
      Left = 247
      Top = 60
      Width = 7
      Height = 283
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ExplicitTop = 64
      ExplicitHeight = 279
    end
    object pnl7Button: TKeyClickPanel
      Left = 486
      Top = 100
      Width = 24
      Height = 29
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BevelOuter = bvNone
      TabOrder = 4
      TabStop = True
      OnClick = SpeedButton7Click
      OnEnter = pnl7ButtonEnter
      OnExit = pnl7ButtonExit
      object SpeedButton7: TSpeedButton
        Left = 1
        Top = 1
        Width = 21
        Height = 27
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
      Left = 486
      Top = 130
      Width = 24
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BevelOuter = bvNone
      TabOrder = 5
      TabStop = True
      OnClick = SpeedButton8Click
      OnEnter = pnl7ButtonEnter
      OnExit = pnl7ButtonExit
      object SpeedButton8: TSpeedButton
        Left = 1
        Top = 1
        Width = 21
        Height = 27
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
      Top = 60
      Width = 245
      Height = 283
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsSimple
      Align = alLeft
      AutoSelect = True
      Caption = 'File Selections'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 16
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
      Text = ''
      OnDblClick = btnAddSelClick
      OnKeyUp = ORComboBox2KeyUp
      OnNeedData = ORComboBox2NeedData
      CharsNeedMatch = 1
      ExplicitTop = 64
      ExplicitHeight = 279
    end
    object ORListBox1: TORListBox
      Left = 286
      Top = 59
      Width = 198
      Height = 159
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DragMode = dmAutomatic
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
      Top = 18
      Width = 522
      Height = 42
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitTop = 22
      ExplicitWidth = 521
      object Label4: TLabel
        Left = 0
        Top = 25
        Width = 91
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'File Selections:'
      end
      object Label5: TLabel
        Left = 286
        Top = 25
        Width = 126
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'File Entries Selected:'
      end
      object Label6: TStaticText
        Left = 286
        Top = 1
        Width = 123
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Selections allowed: '
        TabOrder = 0
      end
      object lblLimit: TStaticText
        Left = 404
        Top = 1
        Width = 52
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'No Limit'
        TabOrder = 1
      end
    end
    object Panel5: TPanel
      Left = 2
      Top = 343
      Width = 522
      Height = 41
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 6
      ExplicitWidth = 521
      DesignSize = (
        522
        41)
      object btnCancel: TButton
        Left = 420
        Top = 5
        Width = 92
        Height = 31
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = btnCancelClick
      end
      object btnOK: TButton
        Left = 309
        Top = 5
        Width = 92
        Height = 31
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akRight, akBottom]
        Caption = 'OK'
        TabOrder = 0
        OnClick = btnOKClick
      end
    end
    object Panel8: TPanel
      Left = 256
      Top = 69
      Width = 31
      Height = 169
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BevelOuter = bvNone
      TabOrder = 2
      object btnAddSel: TButton
        Left = 5
        Top = 6
        Width = 21
        Height = 27
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '>'
        TabOrder = 0
        OnClick = btnAddSelClick
      end
      object btnRemoveSel: TButton
        Left = 5
        Top = 37
        Width = 21
        Height = 27
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '<'
        TabOrder = 1
        OnClick = btnRemoveSelClick
      end
      object btnRemoveAllSel: TButton
        Left = 5
        Top = 68
        Width = 21
        Height = 27
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
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
    Enabled = False
    OnTimer = Timer2Timer
    Left = 392
    Top = 16
  end
end
