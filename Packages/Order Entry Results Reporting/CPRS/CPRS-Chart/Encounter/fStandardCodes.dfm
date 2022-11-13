inherited frmStandardCodes: TfrmStandardCodes
  Caption = 'frmStandardCodes'
  ClientHeight = 439
  ClientWidth = 625
  ExplicitWidth = 641
  ExplicitHeight = 478
  PixelsPerInch = 96
  TextHeight = 13
  inherited lblSection: TLabel
    Top = 50
    Visible = False
    ExplicitTop = 50
  end
  inherited lblList: TLabel
    Left = 113
    Top = 40
    Visible = False
    ExplicitLeft = 113
    ExplicitTop = 40
  end
  inherited lblComment: TLabel
    Left = 8
    Top = 368
    Anchors = [akRight, akBottom]
    ExplicitLeft = 8
    ExplicitTop = 369
  end
  inherited bvlMain: TBevel
    Left = -1
    Top = 247
    Height = 164
    ExplicitLeft = -1
    ExplicitTop = 247
    ExplicitHeight = 164
  end
  object lblMag: TLabel [4]
    Left = 8
    Top = 322
    Width = 53
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Magnitude:'
  end
  object lblUCUM: TLabel [5]
    Left = 104
    Top = 323
    Width = 203
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Unified Code for Units of Measure  (UCUM)'
  end
  object lblUCUM2: TLabel [6]
    Left = 104
    Top = 342
    Width = 48
    Height = 13
    Caption = 'lblUCUM2'
    Visible = False
  end
  inherited btnOK: TBitBtn
    Left = 465
    Top = 412
    Height = 24
    TabOrder = 5
    ExplicitLeft = 465
    ExplicitTop = 412
    ExplicitHeight = 24
  end
  inherited btnCancel: TBitBtn
    Left = 545
    Top = 411
    Height = 25
    TabOrder = 6
    ExplicitLeft = 545
    ExplicitTop = 411
    ExplicitHeight = 25
  end
  inherited pnlGrid: TPanel
    Left = 0
    Top = 200
    Width = 625
    Height = 118
    Align = alTop
    TabOrder = 1
    ExplicitLeft = 0
    ExplicitTop = 200
    ExplicitWidth = 625
    ExplicitHeight = 118
    inherited lstCaptionList: TCaptionListView
      Width = 625
      Height = 118
      Columns = <
        item
          Caption = 'System'
          Width = 80
        end
        item
          Caption = 'Code'
          Width = 100
        end
        item
          Caption = 'Description'
          Width = 340
        end
        item
          Caption = 'Add to PL'
          Width = 70
        end>
      Pieces = '1,2,3,4'
      ExplicitWidth = 625
      ExplicitHeight = 118
    end
  end
  inherited edtComment: TCaptionEdit
    Left = 8
    Top = 383
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 4
    ExplicitLeft = 8
    ExplicitTop = 383
  end
  object edtMag: TCaptionEdit [11]
    Left = 8
    Top = 338
    Width = 90
    Height = 21
    Anchors = [akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnChange = edtMagChange
    OnEnter = edtMagEnter
    OnExit = edtMagExit
    OnKeyPress = edtMagKeyPress
    Caption = '0'
  end
  object ckbAdd2PL: TCheckBox [12]
    Left = 441
    Top = 334
    Width = 100
    Height = 32
    Anchors = [akRight, akBottom]
    Caption = 'Add to Problem List'
    TabOrder = 3
    WordWrap = True
    OnClick = ckbAdd2PLClick
  end
  inherited btnRemove: TButton
    Left = 545
    Top = 371
    Height = 27
    Anchors = [akRight, akBottom]
    TabOrder = 7
    ExplicitLeft = 545
    ExplicitTop = 371
    ExplicitHeight = 27
  end
  inherited btnSelectAll: TButton
    Left = 545
    Top = 322
    Height = 24
    Anchors = [akRight, akBottom]
    TabOrder = 8
    ExplicitLeft = 545
    ExplicitTop = 322
    ExplicitHeight = 24
  end
  inherited pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 625
    Height = 200
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 625
    ExplicitHeight = 200
    inherited splLeft: TSplitter
      Height = 200
      ExplicitHeight = 177
    end
    inherited pnlLeft: TPanel [1]
      Height = 200
      TabStop = True
      ExplicitHeight = 200
      inherited lbSection: TORListBox
        Left = 6
        Top = 22
        Width = 192
        Height = 138
        Align = alNone
        Anchors = [akLeft, akTop, akRight, akBottom]
        Visible = False
        Pieces = '2'
        OnChange = lbSectionChange
        ExplicitLeft = 6
        ExplicitTop = 22
        ExplicitWidth = 192
        ExplicitHeight = 138
      end
      inherited btnOther: TButton
        Tag = 4
        Left = 6
        Top = 166
        Width = 123
        Height = 28
        Anchors = [akLeft, akBottom]
        Caption = 'SNOMED Codes'
        Visible = False
        ExplicitLeft = 6
        ExplicitTop = 166
        ExplicitWidth = 123
        ExplicitHeight = 28
      end
      object lblTaxonomies: TORStaticText
        Left = 3
        Top = 2
        Width = 161
        Height = 16
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'Reminder Taxonomies'
        TabOrder = 3
        Visible = False
        Text = 'Reminder Taxonomies'#13#10
        Lines.Strings = (
          'Reminder Taxonomies')
      end
    end
    object pnlRight: TPanel [2]
      Left = 207
      Top = 0
      Width = 418
      Height = 200
      Align = alClient
      TabOrder = 1
      TabStop = True
      DesignSize = (
        418
        200)
      object lblCodes: TLabel
        Left = 7
        Top = 6
        Width = 79
        Height = 13
        Caption = 'Standard Codes:'
        Visible = False
      end
      object btnTaxonomy: TButton
        Left = 6
        Top = 166
        Width = 163
        Height = 28
        Anchors = [akLeft, akBottom]
        Caption = 'Reminder Taxonomies'
        TabOrder = 0
        OnClick = btnTaxonomyClick
      end
      object lbxCodes: TORListBox
        Left = 6
        Top = 22
        Width = 407
        Height = 138
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        MultiSelect = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Visible = False
        OnClick = clbListClick
        OnDblClick = lbxCodesDblClick
        OnExit = lbxSectionExit
        OnMouseDown = clbListMouseDown
        Caption = 'Standard Code'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '1,2,3'
        TabPosInPixels = True
        OnChange = lbxCodesChange
        CheckEntireLine = True
        OnClickCheck = lbxSectionClickCheck
      end
      object btnAdd: TButton
        Left = 336
        Top = 166
        Width = 75
        Height = 25
        Caption = 'Add'
        Enabled = False
        TabOrder = 2
        Visible = False
        OnClick = btnAddClick
      end
      object btnPL: TButton
        Left = 200
        Top = 166
        Width = 115
        Height = 28
        Caption = 'Problem List'
        TabOrder = 4
        OnClick = btnPLClick
      end
    end
    inherited lbxSection: TORListBox [3]
      Left = 94
      Top = 62
      Width = 96
      Height = 72
      TabStop = False
      Style = lbStandard
      Align = alNone
      Enabled = False
      ItemHeight = 13
      TabOrder = 3
      Visible = False
      Pieces = '1,2,3'
      TabPosInPixels = False
      CheckBoxes = False
      ExplicitLeft = 94
      ExplicitTop = 62
      ExplicitWidth = 96
      ExplicitHeight = 72
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = edtComment'
        'Label = lblComment'
        'Status = stsOK')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = btnSelectAll'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = lbxSection'
        'Label = lblList'
        'Status = stsOK')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = lbSection'
        'Label = lblSection'
        'Status = stsOK')
      (
        'Component = btnOther'
        'Status = stsDefault')
      (
        'Component = pnlGrid'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmStandardCodes'
        'Status = stsDefault')
      (
        'Component = edtMag'
        'Status = stsDefault')
      (
        'Component = btnTaxonomy'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = lbxCodes'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = ckbAdd2PL'
        'Status = stsDefault')
      (
        'Component = lblTaxonomies'
        'Status = stsDefault')
      (
        'Component = btnPL'
        'Status = stsDefault'))
  end
end
