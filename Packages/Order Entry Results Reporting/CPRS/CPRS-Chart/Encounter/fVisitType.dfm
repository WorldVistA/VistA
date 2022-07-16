inherited frmVisitType: TfrmVisitType
  Left = 260
  Caption = 'Encounter VisitType'
  ClientHeight = 548
  ClientWidth = 740
  Constraints.MinHeight = 581
  Constraints.MinWidth = 750
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 758
  ExplicitHeight = 593
  PixelsPerInch = 120
  TextHeight = 16
  inherited btnOK: TBitBtn
    Left = 545
    Top = 518
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 3
    ExplicitLeft = 545
    ExplicitTop = 518
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 740
    Height = 131
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object splLeft: TSplitter
      Left = 181
      Top = 0
      Width = 4
      Height = 131
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object splRight: TSplitter
      Left = 451
      Top = 0
      Width = 4
      Height = 131
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 181
      Height = 131
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblVTypeSection: TLabel
        Left = 0
        Top = 0
        Width = 181
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Type of Visit'
        ExplicitWidth = 74
      end
      object lstVTypeSection: TORListBox
        Tag = 10
        Left = 0
        Top = 16
        Width = 181
        Height = 115
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
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
      Left = 455
      Top = 0
      Width = 285
      Height = 131
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object lblMod: TLabel
        Left = 0
        Top = 0
        Width = 285
        Height = 16
        Hint = 'Modifiers'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Modifiers'
        ParentShowHint = False
        ShowHint = True
        ExplicitWidth = 55
      end
      object lbMods: TORListBox
        Left = 0
        Top = 16
        Width = 285
        Height = 115
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = lbOwnerDrawFixed
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
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
      end
    end
    object pnlSection: TPanel
      Left = 185
      Top = 0
      Width = 266
      Height = 131
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'pnlSection'
      TabOrder = 1
      object lblVType: TLabel
        Left = 0
        Top = 0
        Width = 266
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Section Name'
        ExplicitWidth = 85
      end
      object lbxVisits: TORListBox
        Tag = 10
        Left = 0
        Top = 16
        Width = 266
        Height = 115
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = lbOwnerDrawFixed
        Align = alClient
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
    Top = 131
    Width = 740
    Height = 205
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    inline fraVisitRelated: TfraVisitRelated
      Left = 428
      Top = 0
      Width = 312
      Height = 205
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      TabOrder = 1
      TabStop = True
      ExplicitLeft = 428
      ExplicitWidth = 312
      ExplicitHeight = 205
      inherited ScrollBox1: TScrollBox
        Width = 312
        Height = 205
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ExplicitWidth = 312
        ExplicitHeight = 205
        inherited Panel1: TPanel
          Width = 291
          Height = 226
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ExplicitWidth = 291
          ExplicitHeight = 226
          inherited gbVisitRelatedTo: TGroupBox
            Width = 291
            Height = 226
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ExplicitWidth = 291
            ExplicitHeight = 226
            inherited chkSCYes: TCheckBox
              Left = 9
              Top = 41
              Width = 17
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 9
              ExplicitTop = 41
              ExplicitWidth = 17
              ExplicitHeight = 22
            end
            inherited chkAOYes: TCheckBox
              Left = 9
              Top = 81
              Width = 17
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 9
              ExplicitTop = 81
              ExplicitWidth = 17
              ExplicitHeight = 22
            end
            inherited chkIRYes: TCheckBox
              Left = 9
              Top = 101
              Width = 17
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 9
              ExplicitTop = 101
              ExplicitWidth = 17
              ExplicitHeight = 22
            end
            inherited chkECYes: TCheckBox
              Left = 9
              Top = 121
              Width = 17
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 9
              ExplicitTop = 121
              ExplicitWidth = 17
              ExplicitHeight = 22
            end
            inherited chkMSTYes: TCheckBox
              Left = 9
              Top = 159
              Width = 17
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 9
              ExplicitTop = 159
              ExplicitWidth = 17
              ExplicitHeight = 21
            end
            inherited chkMSTNo: TCheckBox
              Left = 34
              Top = 159
              Width = 89
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'MST  '
              ExplicitLeft = 34
              ExplicitTop = 159
              ExplicitWidth = 89
              ExplicitHeight = 21
            end
            inherited chkECNo: TCheckBox
              Left = 34
              Top = 121
              Width = 257
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Southwest Asia Conditions  '
              ExplicitLeft = 34
              ExplicitTop = 121
              ExplicitWidth = 257
              ExplicitHeight = 22
            end
            inherited chkIRNo: TCheckBox
              Left = 34
              Top = 101
              Width = 257
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Ionizing Radiation Exposure  '
              ExplicitLeft = 34
              ExplicitTop = 101
              ExplicitWidth = 257
              ExplicitHeight = 22
            end
            inherited chkAONo: TCheckBox
              Left = 34
              Top = 81
              Width = 257
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Agent Orange Exposure '
              ExplicitLeft = 34
              ExplicitTop = 81
              ExplicitWidth = 257
              ExplicitHeight = 22
            end
            inherited chkSCNo: TCheckBox
              Left = 34
              Top = 41
              Width = 257
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Service Connected Condition '
              ExplicitLeft = 34
              ExplicitTop = 41
              ExplicitWidth = 257
              ExplicitHeight = 22
            end
            inherited chkHNCYes: TCheckBox
              Left = 9
              Top = 179
              Width = 17
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 9
              ExplicitTop = 179
              ExplicitWidth = 17
              ExplicitHeight = 21
            end
            inherited chkHNCNo: TCheckBox
              Left = 34
              Top = 178
              Width = 187
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 34
              ExplicitTop = 178
              ExplicitWidth = 187
              ExplicitHeight = 22
            end
            inherited chkCVYes: TCheckBox
              Left = 9
              Top = 61
              Width = 17
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 9
              ExplicitTop = 61
              ExplicitWidth = 17
              ExplicitHeight = 22
            end
            inherited chkCVNo: TCheckBox
              Left = 34
              Top = 61
              Width = 257
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Caption = 'Combat Vet (Combat Related)  '
              ExplicitLeft = 34
              ExplicitTop = 61
              ExplicitWidth = 257
              ExplicitHeight = 22
            end
            inherited chkSHDYes: TCheckBox
              Left = 9
              Top = 140
              Width = 17
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 9
              ExplicitTop = 140
              ExplicitWidth = 17
              ExplicitHeight = 21
            end
            inherited chkSHDNo: TCheckBox
              Left = 34
              Top = 140
              Width = 257
              Height = 21
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 34
              ExplicitTop = 140
              ExplicitWidth = 257
              ExplicitHeight = 21
            end
            inherited lblSCNo: TStaticText
              Left = 34
              Top = 20
              Width = 22
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 34
              ExplicitTop = 20
              ExplicitWidth = 22
              ExplicitHeight = 16
            end
            inherited lblSCYes: TStaticText
              Left = 5
              Top = 20
              Width = 28
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 5
              ExplicitTop = 20
              ExplicitWidth = 28
              ExplicitHeight = 16
            end
            inherited chkCLYes: TCheckBox
              Left = 9
              Top = 201
              Width = 180
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 9
              ExplicitTop = 201
              ExplicitWidth = 180
              ExplicitHeight = 22
            end
            inherited chkCLNo: TCheckBox
              Left = 34
              Top = 201
              Width = 237
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 34
              ExplicitTop = 201
              ExplicitWidth = 237
              ExplicitHeight = 22
            end
          end
        end
      end
    end
    object pnlSC: TPanel
      Left = 0
      Top = 0
      Width = 428
      Height = 205
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblSCDisplay: TLabel
        Left = 0
        Top = 0
        Width = 428
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Service Connection && Rated Disabilities'
        ExplicitWidth = 237
      end
      object memSCDisplay: TCaptionMemo
        Left = 0
        Top = 16
        Width = 428
        Height = 189
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Color = clBtnFace
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        OnEnter = memSCDisplayEnter
        Caption = 'Service Connection && Rated Disabilities'
      end
    end
  end
  object pnlBottom: TPanel [3]
    Left = 0
    Top = 336
    Width = 740
    Height = 177
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object btnAdd: TButton
      Left = 325
      Top = 44
      Width = 94
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Add'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 325
      Top = 90
      Width = 94
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Remove'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnPrimary: TButton
      Left = 325
      Top = 140
      Width = 94
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Primary'
      TabOrder = 3
      OnClick = btnPrimaryClick
    end
    object pnlBottomLeft: TPanel
      Left = 0
      Top = 0
      Width = 300
      Height = 177
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblProvider: TLabel
        Left = 0
        Top = 0
        Width = 300
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Available providers'
        ExplicitWidth = 117
      end
      object cboPtProvider: TORComboBox
        Left = 0
        Top = 16
        Width = 300
        Height = 161
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = orcsSimple
        Align = alClient
        AutoSelect = True
        Caption = 'Available providers'
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
      Left = 440
      Top = 0
      Width = 300
      Height = 177
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 4
      object lblCurrentProv: TLabel
        Left = 0
        Top = 0
        Width = 300
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Current providers for this encounter'
        ExplicitWidth = 205
      end
      object lbProviders: TORListBox
        Left = 0
        Top = 16
        Width = 300
        Height = 161
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
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
    Left = 646
    Top = 518
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 4
    ExplicitLeft = 646
    ExplicitTop = 518
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
