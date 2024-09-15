inherited frmBAOptionsDiagnoses: TfrmBAOptionsDiagnoses
  Left = 231
  Top = 183
  Caption = 'Personal Diagnoses List'
  ClientHeight = 530
  ClientWidth = 739
  Constraints.MinHeight = 100
  Constraints.MinWidth = 200
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 747
  ExplicitHeight = 557
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 739
    Height = 530
    Align = alClient
    Constraints.MinHeight = 344
    Constraints.MinWidth = 576
    TabOrder = 0
    object Panel2: TPanel
      Left = 16
      Top = 10
      Width = 713
      Height = 519
      Caption = 'Panel1'
      TabOrder = 0
      object Splitter1: TSplitter
        Left = 458
        Top = 26
        Width = -3
        Height = 463
      end
      object Splitter2: TSplitter
        Left = 169
        Top = 26
        Width = 7
        Height = 463
      end
      object Splitter3: TSplitter
        Left = 457
        Top = 26
        Width = 1
        Height = 463
      end
      object Splitter5: TSplitter
        Left = 455
        Top = 26
        Width = 2
        Height = 463
      end
      object pnlBottom: TPanel
        Left = 1
        Top = 489
        Width = 711
        Height = 29
        Align = alBottom
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 0
        DesignSize = (
          711
          29)
        object btnOther: TButton
          Left = 13
          Top = 3
          Width = 129
          Height = 23
          Anchors = [akLeft, akBottom]
          Caption = 'Other &Diagnoses'
          Constraints.MinHeight = 23
          Constraints.MinWidth = 115
          TabOrder = 0
          OnClick = btnOtherClick
        end
        object btnOK: TButton
          Left = 523
          Top = 3
          Width = 75
          Height = 23
          Anchors = [akRight, akBottom]
          Caption = '&OK'
          TabOrder = 1
          OnClick = btnOKClick
        end
        object Button1: TButton
          Left = 632
          Top = 4
          Width = 75
          Height = 21
          Anchors = [akRight, akBottom]
          Caption = '&Cancel'
          TabOrder = 2
          OnClick = Button1Click
        end
      end
      object Panel3: TPanel
        Left = 1
        Top = 26
        Width = 168
        Height = 463
        Align = alLeft
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object lbSections: TORListBox
          Left = 0
          Top = 17
          Width = 161
          Height = 446
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = lbSectionsClick
          OnEnter = lbSectionsEnter
          ItemTipColor = clWindow
          LongList = False
          Pieces = '3'
        end
        object hdrCntlDxSections: THeaderControl
          Left = 0
          Top = 0
          Width = 168
          Height = 17
          Sections = <
            item
              Alignment = taCenter
              ImageIndex = -1
              Text = 'Diagnoses Sections'
              Width = 50
            end>
        end
      end
      object Panel4: TPanel
        Left = 176
        Top = 26
        Width = 201
        Height = 463
        Align = alLeft
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object lbDiagnosis: TORListBox
          Left = 0
          Top = 17
          Width = 201
          Height = 446
          Align = alClient
          ItemHeight = 13
          MultiSelect = True
          ParentShowHint = False
          ShowHint = True
          Sorted = True
          TabOrder = 0
          OnClick = lbDiagnosisChange
          OnEnter = lbDiagnosisEnter
          ItemTipColor = clWindow
          LongList = False
          Pieces = '1,2,3'
          OnChange = lbDiagnosisChange
        end
        object hdrCntlDxAdd: THeaderControl
          Left = 0
          Top = 0
          Width = 201
          Height = 17
          Sections = <
            item
              Alignment = taCenter
              ImageIndex = -1
              Text = 'Diagnoses to add'
              Width = 50
            end>
        end
      end
      object Panel5: TPanel
        Left = 455
        Top = 26
        Width = 257
        Height = 463
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel5'
        TabOrder = 3
        object lbPersonalDx: TORListBox
          Left = 0
          Top = 17
          Width = 257
          Height = 446
          Align = alClient
          Anchors = [akRight]
          Color = clInfoBk
          ItemHeight = 13
          MultiSelect = True
          ParentShowHint = False
          ShowHint = True
          Sorted = True
          TabOrder = 0
          OnClick = lbPersonalDxClick
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2,1,3'
        end
        object hdrCntlDx: THeaderControl
          Left = 0
          Top = 0
          Width = 257
          Height = 17
          Sections = <
            item
              Alignment = taCenter
              ImageIndex = -1
              MinWidth = 150
              Text = 'Diagnoses Codes'
              Width = 150
            end>
          OnSectionClick = hdrCntlDxSectionClick
        end
      end
      object pnlTop: TPanel
        Left = 1
        Top = 1
        Width = 711
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 4
        object StaticText3: TStaticText
          Left = 472
          Top = 8
          Width = 140
          Height = 17
          Caption = 'Personal Diagnoses List'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          TabStop = True
        end
      end
      object Panel7: TPanel
        Left = 377
        Top = 26
        Width = 78
        Height = 463
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 5
        DesignSize = (
          78
          463)
        object btnAdd: TBitBtn
          Left = 1
          Top = 88
          Width = 75
          Height = 25
          Anchors = [akLeft, akTop, akRight]
          Caption = '&Add'
          Constraints.MinHeight = 25
          Constraints.MinWidth = 70
          Enabled = False
          TabOrder = 0
          OnClick = btnAddClick
          NumGlyphs = 2
        end
        object btnDelete: TBitBtn
          Left = 2
          Top = 136
          Width = 75
          Height = 25
          Caption = '&Remove'
          Constraints.MinHeight = 25
          Constraints.MinWidth = 70
          Enabled = False
          TabOrder = 1
          OnClick = btnDeleteClick
          NumGlyphs = 2
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOther'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = Button1'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = lbSections'
        'Status = stsDefault')
      (
        'Component = hdrCntlDxSections'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = lbDiagnosis'
        'Status = stsDefault')
      (
        'Component = hdrCntlDxAdd'
        'Status = stsDefault')
      (
        'Component = Panel5'
        'Status = stsDefault')
      (
        'Component = lbPersonalDx'
        'Status = stsDefault')
      (
        'Component = hdrCntlDx'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = StaticText3'
        'Status = stsDefault')
      (
        'Component = Panel7'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = btnDelete'
        'Status = stsDefault')
      (
        'Component = frmBAOptionsDiagnoses'
        'Status = stsDefault'))
  end
end
