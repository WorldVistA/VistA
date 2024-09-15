inherited frmVisitType: TfrmVisitType
  Left = 260
  Caption = 'Encounter VisitType'
  ClientHeight = 438
  ClientWidth = 595
  Constraints.MinHeight = 465
  Constraints.MinWidth = 600
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 607
  ExplicitHeight = 476
  TextHeight = 13
  inherited btnOK: TBitBtn
    Left = 432
    Top = 414
    Width = 60
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 3
    ExplicitLeft = 428
    ExplicitTop = 413
    ExplicitWidth = 60
    ExplicitHeight = 17
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 595
    Height = 105
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 591
    object splLeft: TSplitter
      Left = 145
      Top = 0
      Height = 105
    end
    object splRight: TSplitter
      Left = 361
      Top = 0
      Height = 105
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 145
      Height = 105
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblVTypeSection: TLabel
        Left = 0
        Top = 0
        Width = 145
        Height = 13
        Align = alTop
        Caption = 'Type of Visit'
        ExplicitWidth = 58
      end
      object lstVTypeSection: TORListBox
        Tag = 10
        Left = 0
        Top = 13
        Width = 145
        Height = 92
        Align = alClient
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = lstVTypeSectionClick
        Caption = 'Type of Visit'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '3'
        CheckEntireLine = True
      end
    end
    object pnlModifiers: TPanel
      Left = 364
      Top = 0
      Width = 231
      Height = 105
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitWidth = 227
      object lblMod: TLabel
        Left = 0
        Top = 0
        Width = 231
        Height = 13
        Hint = 'Modifiers'
        Align = alTop
        Caption = 'Modifiers'
        ParentShowHint = False
        ShowHint = True
        ExplicitWidth = 42
      end
      object lbMods: TORListBox
        Left = 0
        Top = 13
        Width = 231
        Height = 92
        Style = lbOwnerDrawFixed
        Align = alClient
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Caption = 'Modifiers'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPosInPixels = True
        CheckBoxes = True
        CheckEntireLine = True
        OnClickCheck = lbModsClickCheck
        ExplicitWidth = 227
      end
    end
    object pnlSection: TPanel
      Left = 148
      Top = 0
      Width = 213
      Height = 105
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'pnlSection'
      TabOrder = 1
      object lblVType: TLabel
        Left = 0
        Top = 0
        Width = 213
        Height = 13
        Align = alTop
        Caption = 'Section Name'
        ExplicitWidth = 67
      end
      object lbxVisits: TORListBox
        Tag = 10
        Left = 0
        Top = 13
        Width = 213
        Height = 92
        Style = lbOwnerDrawFixed
        Align = alClient
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = lbxVisitsClick
        Caption = 'Section Name'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '3,4,5'
        TabPosInPixels = True
        CheckBoxes = True
        CheckEntireLine = True
        OnClickCheck = lbxVisitsClickCheck
      end
    end
  end
  object pnlMiddle: TPanel [2]
    Left = 0
    Top = 105
    Width = 595
    Height = 164
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 591
    inline fraVisitRelated: TfraVisitRelated
      Left = 283
      Top = 0
      Width = 312
      Height = 164
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      TabOrder = 1
      TabStop = True
      ExplicitLeft = 279
      ExplicitWidth = 312
      ExplicitHeight = 164
      inherited ScrollBox1: TScrollBox
        Width = 312
        Height = 164
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ExplicitWidth = 312
        ExplicitHeight = 164
        inherited Panel1: TPanel
          Width = 295
          Height = 226
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ExplicitWidth = 295
          ExplicitHeight = 226
          inherited gbVisitRelatedTo: TGroupBox
            Width = 295
            Height = 226
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ExplicitWidth = 295
            ExplicitHeight = 226
            inherited chkSCYes: TCheckBox
              Width = 17
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 17
              ExplicitHeight = 22
            end
            inherited chkAOYes: TCheckBox
              Width = 17
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 17
              ExplicitHeight = 22
            end
            inherited chkIRYes: TCheckBox
              Width = 17
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 17
              ExplicitHeight = 22
            end
            inherited chkECYes: TCheckBox
              Width = 17
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 17
              ExplicitHeight = 22
            end
            inherited chkMSTYes: TCheckBox
              Width = 17
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 17
              ExplicitHeight = 21
            end
            inherited chkMSTNo: TCheckBox
              Width = 89
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'MST  '
              ExplicitWidth = 89
              ExplicitHeight = 21
            end
            inherited chkECNo: TCheckBox
              Width = 257
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Southwest Asia Conditions  '
              ExplicitWidth = 257
              ExplicitHeight = 22
            end
            inherited chkIRNo: TCheckBox
              Width = 257
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Ionizing Radiation Exposure  '
              ExplicitWidth = 257
              ExplicitHeight = 22
            end
            inherited chkAONo: TCheckBox
              Width = 257
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Agent Orange Exposure '
              ExplicitWidth = 257
              ExplicitHeight = 22
            end
            inherited chkSCNo: TCheckBox
              Width = 257
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Service Connected Condition '
              ExplicitWidth = 257
              ExplicitHeight = 22
            end
            inherited chkHNCYes: TCheckBox
              Width = 17
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 17
              ExplicitHeight = 21
            end
            inherited chkHNCNo: TCheckBox
              Width = 187
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 187
              ExplicitHeight = 22
            end
            inherited chkCVYes: TCheckBox
              Width = 17
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 17
              ExplicitHeight = 22
            end
            inherited chkCVNo: TCheckBox
              Width = 257
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Combat Vet (Combat Related)  '
              ExplicitWidth = 257
              ExplicitHeight = 22
            end
            inherited chkSHDYes: TCheckBox
              Width = 17
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 17
              ExplicitHeight = 21
            end
            inherited chkSHDNo: TCheckBox
              Width = 257
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 257
              ExplicitHeight = 21
            end
            inherited lblSCYes: TStaticText [16]
              Height = 17
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              AutoSize = True
              ExplicitHeight = 17
            end
            inherited chkCLYes: TCheckBox [17]
              Width = 180
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 180
              ExplicitHeight = 22
            end
            inherited chkCLNo: TCheckBox [18]
              Width = 237
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitWidth = 237
              ExplicitHeight = 22
            end
            inherited lblSCNo: TStaticText [19]
              Height = 17
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              AutoSize = True
              ExplicitHeight = 17
            end
          end
        end
      end
    end
    object pnlSC: TPanel
      Left = 0
      Top = 0
      Width = 283
      Height = 164
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 279
      object lblSCDisplay: TLabel
        Left = 0
        Top = 0
        Width = 283
        Height = 13
        Align = alTop
        Caption = 'Service Connection && Rated Disabilities'
        ExplicitWidth = 186
      end
      object memSCDisplay: TCaptionMemo
        Left = 0
        Top = 13
        Width = 283
        Height = 151
        Align = alClient
        Color = clBtnFace
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        OnEnter = memSCDisplayEnter
        Caption = 'Service Connection && Rated Disabilities'
        ExplicitWidth = 279
      end
    end
  end
  object pnlBottom: TPanel [3]
    Left = 0
    Top = 269
    Width = 595
    Height = 141
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 591
    object btnAdd: TButton
      Left = 260
      Top = 35
      Width = 75
      Height = 21
      Caption = 'Add'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 260
      Top = 72
      Width = 75
      Height = 21
      Caption = 'Remove'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnPrimary: TButton
      Left = 260
      Top = 112
      Width = 75
      Height = 21
      Caption = 'Primary'
      TabOrder = 3
      OnClick = btnPrimaryClick
    end
    object pnlBottomLeft: TPanel
      Left = 0
      Top = 0
      Width = 240
      Height = 141
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblProvider: TLabel
        Left = 0
        Top = 0
        Width = 240
        Height = 13
        Align = alTop
        Caption = 'Available providers'
        ExplicitWidth = 89
      end
      object cboPtProvider: TORComboBox
        Left = 0
        Top = 13
        Width = 240
        Height = 128
        Style = orcsSimple
        Align = alClient
        AutoSelect = True
        Caption = 'Available providers'
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
        Text = ''
        CheckEntireLine = True
        OnChange = cboPtProviderChange
        OnDblClick = cboPtProviderDblClick
        OnNeedData = cboPtProviderNeedData
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
    end
    object pnlBottomRight: TPanel
      Left = 355
      Top = 0
      Width = 240
      Height = 141
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 4
      ExplicitLeft = 351
      object lblCurrentProv: TLabel
        Left = 0
        Top = 0
        Width = 240
        Height = 13
        Align = alTop
        Caption = 'Current providers for this encounter'
        ExplicitWidth = 165
      end
      object lbProviders: TORListBox
        Left = 0
        Top = 13
        Width = 240
        Height = 128
        Align = alClient
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnDblClick = lbProvidersDblClick
        Caption = 'Current providers for this encounter'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        OnChange = lbProvidersChange
        CheckEntireLine = True
      end
    end
  end
  inherited btnCancel: TBitBtn
    Left = 513
    Top = 414
    Width = 60
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 4
    ExplicitLeft = 509
    ExplicitTop = 413
    ExplicitWidth = 60
    ExplicitHeight = 17
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 24
    Data = (
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmVisitType'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = lstVTypeSection'
        'Label = lblVTypeSection'
        'Status = stsOK')
      (
        'Component = pnlMiddle'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.gbVisitRelatedTo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSCYes'
        'Text = Service Connected Condition     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkSCNo'
        'Text = Service Connected Condition    No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkCVYes'
        'Text = Combat Vet (Combat Related)     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkCVNo'
        'Text = Combat Vet (Combat Related)    No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkAOYes'
        'Text = Agent Orange Exposure     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkAONo'
        'Text = Agent Orange Exposure    No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkIRYes'
        'Text = Ionizing Radiation Exposure     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkIRNo'
        'Text = Ionizing Radiation Exposure    No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkECYes'
        'Text = Southwest Asia Conditions     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkECNo'
        'Text = Southwest Asia Conditions     No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkSHDYes'
        'Text = Shipboard Hazard and Defense     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkSHDNo'
        'Text = Shipboard Hazard and Defense     No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkMSTYes'
        'Text = MST     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkMSTNo'
        'Text = MST     No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkHNCYes'
        'Text = Head and/or Neck Cancer    Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkHNCNo'
        'Text = Head and/or Neck Cancer     No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.lblSCNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.lblSCYes'
        'Status = stsDefault')
      (
        'Component = pnlSC'
        'Status = stsDefault')
      (
        'Component = memSCDisplay'
        'Label = lblSCDisplay'
        'Status = stsOK')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = btnDelete'
        'Status = stsDefault')
      (
        'Component = btnPrimary'
        'Status = stsDefault')
      (
        'Component = pnlBottomLeft'
        'Status = stsDefault')
      (
        'Component = cboPtProvider'
        'Label = lblProvider'
        'Status = stsOK')
      (
        'Component = pnlBottomRight'
        'Status = stsDefault')
      (
        'Component = lbProviders'
        'Label = lblCurrentProv'
        'Status = stsOK')
      (
        'Component = pnlModifiers'
        'Status = stsDefault')
      (
        'Component = lbMods'
        'Label = lblMod'
        'Status = stsOK')
      (
        'Component = pnlSection'
        'Status = stsDefault')
      (
        'Component = lbxVisits'
        'Label = lblVType'
        'Status = stsOK'))
  end
end
