inherited frmOrderFlagRecipients: TfrmOrderFlagRecipients
  Caption = 'Order Flag Notification Recipients'
  ClientHeight = 282
  ClientWidth = 464
  ExplicitWidth = 480
  ExplicitHeight = 321
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 251
    Width = 464
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    object pnlButtons: TPanel
      Left = 307
      Top = 0
      Width = 157
      Height = 31
      Align = alRight
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object cmdCancel: TButton
        AlignWithMargins = True
        Left = 82
        Top = 3
        Width = 72
        Height = 25
        Align = alRight
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
      object cmdOK: TButton
        AlignWithMargins = True
        Left = 4
        Top = 3
        Width = 72
        Height = 25
        Align = alRight
        Caption = 'OK'
        ModalResult = 1
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 464
    Height = 251
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    object grbRecipients: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 456
      Height = 243
      Align = alClient
      Caption = 'Flag &Notification Recipients'
      TabOrder = 0
      object Splitter1: TSplitter
        Left = 187
        Top = 15
        Height = 226
        ExplicitLeft = 216
        ExplicitTop = 64
        ExplicitHeight = 100
      end
      object pnlRecipientsList: TPanel
        Left = 274
        Top = 15
        Width = 180
        Height = 226
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object orSelectedRecipients: TORListBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 169
          Height = 220
          Margins.Right = 8
          Align = alClient
          ItemHeight = 13
          MultiSelect = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = orSelectedRecipientsClick
          OnDblClick = orSelectedRecipientsDblClick
          OnEnter = orSelectedRecipientsEnter
          Caption = ''
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
        end
      end
      object pnlListButtons: TPanel
        Left = 190
        Top = 15
        Width = 84
        Height = 226
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object btnAddRecipient: TButton
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 81
          Height = 26
          Margins.Left = 0
          Action = acAdd
          Align = alTop
          TabOrder = 0
        end
        object btnRemoveAllRecipients: TButton
          AlignWithMargins = True
          Left = 0
          Top = 67
          Width = 81
          Height = 26
          Margins.Left = 0
          Action = acDeleteAll
          Align = alTop
          TabOrder = 2
        end
        object btnRemoveRecipients: TButton
          AlignWithMargins = True
          Left = 0
          Top = 35
          Width = 81
          Height = 26
          Margins.Left = 0
          Action = acDelete
          Align = alTop
          TabOrder = 1
        end
      end
      object pnlRecipientsSource: TPanel
        Left = 2
        Top = 15
        Width = 185
        Height = 226
        Align = alLeft
        BevelOuter = bvNone
        Constraints.MinWidth = 185
        TabOrder = 0
        object cboAlertRecipient: TORComboBox
          AlignWithMargins = True
          Left = 8
          Top = 3
          Width = 174
          Height = 220
          Margins.Left = 8
          Style = orcsSimple
          Align = alClient
          AutoSelect = True
          Caption = ''
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = False
          LongList = True
          LookupPiece = 2
          MaxLength = 0
          ParentShowHint = False
          Pieces = '2'
          ShowHint = True
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 0
          TabStop = True
          Text = ''
          OnChange = cboAlertRecipientChange
          OnDblClick = cboAlertRecipientDblClick
          OnEnter = cboAlertRecipientEnter
          OnKeyDown = cboAlertRecipientKeyDown
          OnNeedData = cboAlertRecipientNeedData
          CharsNeedMatch = 1
          UniqueAutoComplete = True
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 40
    Top = 112
    Data = (
      (
        'Component = frmOrderFlagRecipients'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = grbRecipients'
        'Status = stsDefault')
      (
        'Component = pnlRecipientsList'
        'Status = stsDefault')
      (
        'Component = orSelectedRecipients'
        'Text = Flag Order Recipients'
        'Status = stsOK')
      (
        'Component = pnlListButtons'
        'Status = stsDefault')
      (
        'Component = btnAddRecipient'
        'Status = stsDefault')
      (
        'Component = btnRemoveAllRecipients'
        'Status = stsDefault')
      (
        'Component = btnRemoveRecipients'
        'Status = stsDefault')
      (
        'Component = pnlRecipientsSource'
        'Status = stsDefault')
      (
        'Component = cboAlertRecipient'
        'Text = List of potential flag order recipients'
        'Status = stsOK'))
  end
  object alRecipients: TActionList
    Left = 336
    Top = 104
    object acAdd: TAction
      Caption = '&Add'
      OnExecute = acAddExecute
    end
    object acDelete: TAction
      Caption = 'Re&move'
      OnExecute = acDeleteExecute
    end
    object acDeleteAll: TAction
      Caption = 'Remove A&ll'
      OnExecute = acDeleteAllExecute
    end
  end
end
