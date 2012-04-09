inherited frmVisitType: TfrmVisitType
  Left = 260
  Caption = 'Encounter VisitType'
  ClientHeight = 438
  ClientWidth = 592
  Constraints.MinHeight = 465
  Constraints.MinWidth = 600
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 600
  ExplicitHeight = 465
  PixelsPerInch = 96
  TextHeight = 13
  inherited btnOK: TBitBtn
    Left = 436
    Top = 414
    TabOrder = 3
    ExplicitLeft = 474
    ExplicitTop = 459
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 592
    Height = 105
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 630
    object splLeft: TSplitter
      Left = 145
      Top = 0
      Height = 105
      ExplicitLeft = 154
      ExplicitTop = 7
      ExplicitHeight = 145
    end
    object splRight: TSplitter
      Left = 361
      Top = 0
      Height = 105
      ExplicitLeft = 634
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 145
      Height = 105
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitHeight = 145
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
      Width = 228
      Height = 105
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitLeft = 431
      ExplicitWidth = 199
      ExplicitHeight = 145
      object lblMod: TLabel
        Left = 0
        Top = 0
        Width = 228
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
        Width = 228
        Height = 92
        Style = lbOwnerDrawFixed
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 14
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
        ExplicitWidth = 199
        ExplicitHeight = 132
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
        ItemHeight = 16
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
        ExplicitLeft = -3
        ExplicitTop = 7
        ExplicitWidth = 281
      end
    end
  end
  object pnlMiddle: TPanel [2]
    Left = 0
    Top = 105
    Width = 592
    Height = 164
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 145
    ExplicitWidth = 630
    inline fraVisitRelated: TfraVisitRelated
      Left = 384
      Top = 0
      Width = 208
      Height = 164
      Align = alRight
      TabOrder = 1
      ExplicitLeft = 422
      ExplicitWidth = 208
      ExplicitHeight = 164
      inherited gbVisitRelatedTo: TGroupBox
        Width = 208
        Height = 164
        ExplicitWidth = 208
        ExplicitHeight = 164
        inherited chkMSTYes: TCheckBox
          Top = 127
          ExplicitTop = 127
        end
        inherited chkMSTNo: TCheckBox
          Top = 127
          ExplicitTop = 127
        end
        inherited chkHNCYes: TCheckBox
          Top = 143
          ExplicitTop = 143
        end
        inherited chkHNCNo: TCheckBox
          Top = 142
          Width = 150
          Height = 18
          Caption = 'Head and/or Neck Cancer     No'
          ExplicitTop = 142
          ExplicitWidth = 150
          ExplicitHeight = 18
        end
      end
    end
    object pnlSC: TPanel
      Left = 0
      Top = 0
      Width = 384
      Height = 164
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 422
      object lblSCDisplay: TLabel
        Left = 0
        Top = 0
        Width = 384
        Height = 13
        Align = alTop
        Caption = 'Service Connection && Rated Disabilities'
        ExplicitWidth = 186
      end
      object memSCDisplay: TCaptionMemo
        Left = 0
        Top = 13
        Width = 384
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
        ExplicitWidth = 422
      end
    end
  end
  object pnlBottom: TPanel [3]
    Left = 0
    Top = 269
    Width = 592
    Height = 141
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 309
    ExplicitWidth = 630
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
        ListItemsOnly = True
        LongList = True
        LookupPiece = 2
        MaxLength = 0
        Pieces = '2,3'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        CheckEntireLine = True
        OnChange = cboPtProviderChange
        OnDblClick = cboPtProviderDblClick
        OnNeedData = cboPtProviderNeedData
        CharsNeedMatch = 1
        ExplicitWidth = 260
      end
    end
    object pnlBottomRight: TPanel
      Left = 352
      Top = 0
      Width = 240
      Height = 141
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 4
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
        ExplicitTop = 11
        ExplicitWidth = 220
      end
    end
  end
  inherited btnCancel: TBitBtn
    Left = 517
    Top = 414
    TabOrder = 4
    ExplicitLeft = 555
    ExplicitTop = 459
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
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkAOYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkIRYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkECYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkMSTYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkMSTNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkECNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkIRNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkAONo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSCNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkHNCYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkHNCNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkCVYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkCVNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSHDYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSHDNo'
        'Status = stsDefault')
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
