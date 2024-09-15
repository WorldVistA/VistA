inherited frm513Print: Tfrm513Print
  Left = 116
  Top = 375
  Caption = 'Print SF 513'
  ClientHeight = 337
  ClientWidth = 433
  Position = poScreenCenter
  ExplicitWidth = 449
  ExplicitHeight = 375
  PixelsPerInch = 96
  TextHeight = 16
  object lblPrintTo: TLabel [0]
    Left = 7
    Top = 265
    Width = 3
    Height = 16
  end
  object pnlBUttons: TPanel [1]
    Left = 0
    Top = 304
    Width = 433
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 280
      Top = 3
      Width = 72
      Height = 27
      Align = alRight
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 358
      Top = 3
      Width = 72
      Height = 27
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = cmdCancelClick
    end
    object chkDefault: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 197
      Height = 27
      Align = alLeft
      Caption = 'Save as user'#39's default printer'
      TabOrder = 0
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 0
    Width = 433
    Height = 304
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 431
      Height = 80
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 0
      object lblConsultTitle: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 305
        Height = 74
        Align = alClient
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          'Consult Title, Date/Time of Consult, Location')
        ReadOnly = True
        TabOrder = 0
      end
      object grpChooseCopy: TGroupBox
        AlignWithMargins = True
        Left = 314
        Top = 3
        Width = 114
        Height = 74
        Align = alRight
        Caption = 'Print'
        TabOrder = 1
        object radChartCopy: TRadioButton
          AlignWithMargins = True
          Left = 5
          Top = 21
          Width = 104
          Height = 17
          Align = alTop
          Caption = '&Chart Copy'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = radChartCopyClick
        end
        object radWorkCopy: TRadioButton
          AlignWithMargins = True
          Left = 5
          Top = 44
          Width = 104
          Height = 17
          Align = alTop
          Caption = '&Work Copy'
          TabOrder = 1
          OnClick = radWorkCopyClick
        end
      end
    end
    object grpDevice: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 84
      Width = 425
      Height = 216
      Align = alClient
      Caption = 'Device'
      TabOrder = 1
      object cboDevice: TORComboBox
        AlignWithMargins = True
        Left = 5
        Top = 21
        Width = 415
        Height = 161
        Style = orcsSimple
        Align = alClient
        AutoSelect = True
        Caption = 'Device'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 16
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = True
        LookupPiece = 0
        MaxLength = 0
        ParentShowHint = False
        Pieces = '2,4'
        ShowHint = True
        Sorted = False
        SynonymChars = '<>'
        TabPositions = '30'
        TabOrder = 0
        Text = ''
        OnChange = cboDeviceChange
        OnNeedData = cboDeviceNeedData
        CharsNeedMatch = 1
      end
      object Panel3: TPanel
        Left = 2
        Top = 185
        Width = 421
        Height = 29
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel3'
        ShowCaption = False
        TabOrder = 1
        object lblMargin: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 75
          Height = 23
          Align = alLeft
          Caption = 'Right Margin'
          ExplicitHeight = 16
        end
        object lblLength: TLabel
          AlignWithMargins = True
          Left = 122
          Top = 3
          Width = 76
          Height = 23
          Align = alLeft
          Caption = 'Page Length'
          ExplicitHeight = 16
        end
        object txtRightMargin: TMaskEdit
          AlignWithMargins = True
          Left = 84
          Top = 3
          Width = 32
          Height = 23
          Align = alLeft
          AutoSize = False
          EditMask = '99999;0; '
          MaxLength = 5
          TabOrder = 0
          Text = ''
        end
        object txtPageLength: TMaskEdit
          AlignWithMargins = True
          Left = 204
          Top = 3
          Width = 34
          Height = 23
          Align = alLeft
          AutoSize = False
          EditMask = '99999;0; '
          MaxLength = 5
          TabOrder = 1
          Text = ''
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 272
    Top = 144
    Data = (
      (
        'Component = lblConsultTitle'
        'Status = stsDefault')
      (
        'Component = grpChooseCopy'
        'Status = stsDefault')
      (
        'Component = radChartCopy'
        'Status = stsDefault')
      (
        'Component = radWorkCopy'
        'Status = stsDefault')
      (
        'Component = grpDevice'
        'Status = stsDefault')
      (
        'Component = txtRightMargin'
        'Status = stsDefault')
      (
        'Component = txtPageLength'
        'Status = stsDefault')
      (
        'Component = cboDevice'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = chkDefault'
        'Status = stsDefault')
      (
        'Component = frm513Print'
        'Status = stsDefault')
      (
        'Component = pnlBUttons'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault'))
  end
  object dlgWinPrinter: TPrintDialog
    Left = 332
    Top = 138
  end
end
