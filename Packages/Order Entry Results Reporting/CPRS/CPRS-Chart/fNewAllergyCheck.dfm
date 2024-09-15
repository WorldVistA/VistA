inherited frmNewAllergyCheck: TfrmNewAllergyCheck
  Left = 545
  Top = 470
  BorderIcons = []
  Caption = 'Existing Medication Allergy'
  ClientHeight = 425
  ClientWidth = 573
  Constraints.MinHeight = 433
  Constraints.MinWidth = 589
  Font.Charset = ANSI_CHARSET
  OldCreateOrder = False
  Position = poMainFormCenter
  ExplicitWidth = 589
  ExplicitHeight = 464
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCheck: TPanel [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 567
    Height = 113
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object Check: TMemo
      Left = 0
      Top = 0
      Width = 567
      Height = 113
      TabStop = False
      Align = alClient
      Color = clBtnFace
      Constraints.MinHeight = 70
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object pnlOptRecipients: TPanel [1]
    AlignWithMargins = True
    Left = 3
    Top = 209
    Width = 567
    Height = 173
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblRecipients: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 3
      Width = 564
      Height = 13
      Margins.Left = 0
      Align = alTop
      Caption = ' Optional Recipients'
      WordWrap = True
      ExplicitWidth = 95
    end
    object pnlOptRecipientsSub: TPanel
      Left = 0
      Top = 19
      Width = 567
      Height = 154
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object OptRecip: TORComboBox
        Left = 0
        Top = 0
        Width = 241
        Height = 154
        Style = orcsSimple
        Align = alLeft
        AutoSelect = True
        Caption = 'Encounter Provider'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = True
        LookupPiece = 2
        MaxLength = 0
        Pieces = '2,3'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        TabStop = True
        Text = ''
        OnChange = OptRecipChange
        OnDblClick = OptRecipDblClick
        OnEnter = OptRecipEnter
        OnKeyDown = OptRecipKeyDown
        OnNeedData = OptRecipNeedData
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object pnlOptRecipientsButtons: TPanel
        Left = 241
        Top = 0
        Width = 84
        Height = 154
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object btnRemove: TButton
          AlignWithMargins = True
          Left = 3
          Top = 34
          Width = 78
          Height = 25
          Action = actRemove
          Align = alTop
          TabOrder = 1
        end
        object btnAdd: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 78
          Height = 25
          Action = actAdd
          Align = alTop
          TabOrder = 0
        end
        object btnRemoveAll: TButton
          AlignWithMargins = True
          Left = 3
          Top = 65
          Width = 78
          Height = 25
          Action = actRemoveAll
          Align = alTop
          TabOrder = 2
        end
      end
      object SelRecip: TORListBox
        AlignWithMargins = True
        Left = 328
        Top = 3
        Width = 231
        Height = 148
        Margins.Right = 8
        Align = alClient
        ItemHeight = 13
        MultiSelect = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = SelRecipClick
        OnDblClick = SelRecipDblClick
        OnEnter = SelRecipEnter
        OnKeyPress = SelRecipKeyPress
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
    end
  end
  object pnlButton: TPanel [2]
    AlignWithMargins = True
    Left = 3
    Top = 388
    Width = 567
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object btnSendAlertBtn: TButton
      AlignWithMargins = True
      Left = 492
      Top = 3
      Width = 72
      Height = 28
      Action = actOK
      Align = alRight
      Cancel = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object pnlRecipients: TPanel [3]
    AlignWithMargins = True
    Left = 3
    Top = 122
    Width = 567
    Height = 81
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblSent: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 561
      Height = 13
      Margins.Bottom = 0
      Align = alTop
      Caption = 'An alert will be sent to:'
      ExplicitWidth = 106
    end
    object Recipients: TORListBox
      AlignWithMargins = True
      Left = 3
      Top = 19
      Width = 561
      Height = 59
      Align = alClient
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = ''
      ItemTipColor = clWindow
      LongList = False
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Data = (
      (
        'Component = pnlCheck'
        'Status = stsDefault')
      (
        'Component = Check'
        'Status = stsDefault')
      (
        'Component = pnlOptRecipients'
        'Status = stsDefault')
      (
        'Component = Recipients'
        'Label = lblSent'
        'Status = stsOK')
      (
        'Component = pnlButton'
        'Status = stsDefault')
      (
        'Component = frmNewAllergyCheck'
        'Status = stsDefault')
      (
        'Component = btnSendAlertBtn'
        'Status = stsDefault')
      (
        'Component = pnlOptRecipientsSub'
        'Status = stsDefault')
      (
        'Component = OptRecip'
        'Label = lblRecipients'
        'Status = stsOK')
      (
        'Component = pnlOptRecipientsButtons'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = btnRemoveAll'
        'Status = stsDefault')
      (
        'Component = pnlRecipients'
        'Status = stsDefault')
      (
        'Component = SelRecip'
        'Status = stsDefault'))
  end
  object ActionList1: TActionList
    Left = 67
    Top = 3
    object actAdd: TAction
      Caption = '&Add'
      OnExecute = actAddExecute
    end
    object actRemove: TAction
      Caption = '&Remove'
      OnExecute = actRemoveExecute
    end
    object actRemoveAll: TAction
      Caption = 'Remove &All'
      OnExecute = actRemoveAllExecute
    end
    object actOK: TAction
      Caption = '&OK'
      OnExecute = actOKExecute
    end
  end
end
