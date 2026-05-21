inherited frmODProc: TfrmODProc
  Tag = 112
  Left = 430
  Top = 203
  Width = 640
  Height = 521
  HorzScrollBar.Range = 523
  VertScrollBar.Range = 295
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'Order a Procedure'
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Position = poDesigned
  ExplicitWidth = 640
  ExplicitHeight = 521
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCombatVet: TPanel [0]
    Left = 0
    Top = 0
    Width = 624
    Height = 25
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object txtCombatVet: TVA508StaticText
      Name = 'txtCombatVet'
      Left = 0
      Top = 0
      Width = 624
      Height = 25
      Align = alClient
      Alignment = taCenter
      AutoSize = True
      BevelOuter = bvNone
      Caption = ''
      Enabled = False
      TabOrder = 0
      ShowAccelChar = True
      WordWrap = False
      LabelAlignment = taCenter
      LabelLayout = tlTop
    end
  end
  inherited memOrder: TCaptionMemo
    AlignWithMargins = True
    Left = 6
    Top = 373
    Width = 488
    Height = 50
    Margins.Left = 6
    Margins.Right = 130
    Align = alBottom
    Constraints.MinHeight = 50
    Lines.Strings = (
      'The order text...'
      
        '----------------------------------------------------------------' +
        '--------------'
      'An order message may be displayed here.')
    ParentFont = False
    TabOrder = 2
    ExplicitLeft = 6
    ExplicitTop = 373
    ExplicitWidth = 488
    ExplicitHeight = 50
  end
  object pnlMain: TPanel [2]
    Left = 0
    Top = 25
    Width = 624
    Height = 345
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnlReason: TPanel
      Left = 0
      Top = 241
      Width = 624
      Height = 104
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblReason: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 618
        Height = 13
        Align = alTop
        Caption = 'Reason for Request'
        ExplicitWidth = 95
      end
      object memReason: TCaptionRichEdit
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 618
        Height = 79
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 73
        ParentFont = False
        PopupMenu = popReason
        ScrollBars = ssVertical
        TabOrder = 0
        WantTabs = True
        Zoom = 100
        OnChange = ControlChange
        OnKeyDown = memReasonKeyDown
        OnKeyPress = memReasonKeyPress
        OnKeyUp = memReasonKeyUp
        Caption = 'Reason for Request'
      end
    end
    object gpMain: TGridPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 618
      Height = 235
      Align = alTop
      BevelOuter = bvNone
      Caption = 'gpMain'
      ColumnCollection = <
        item
          Value = 33.527518069967260000
        end
        item
          Value = 33.303817253371960000
        end
        item
          Value = 33.168664676660790000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = Panel1
          Row = 0
          RowSpan = 3
        end
        item
          Column = 1
          Control = Panel2
          Row = 0
        end
        item
          Column = 2
          Control = Panel3
          Row = 0
        end
        item
          Column = 1
          Control = Panel4
          Row = 1
        end
        item
          Column = 2
          Control = Panel5
          Row = 1
        end
        item
          Column = 1
          Control = Panel6
          Row = 2
        end
        item
          Column = 2
          Control = Panel7
          Row = 2
        end
        item
          Column = 0
          Control = Panel8
          Row = 3
        end
        item
          Column = 1
          ColumnSpan = 2
          Control = Panel9
          Row = 3
        end>
      RowCollection = <
        item
          Value = 34.386840558438980000
        end
        item
          Value = 20.869443595494270000
        end
        item
          Value = 22.348548241656040000
        end
        item
          Value = 22.395167604410720000
        end>
      ShowCaption = False
      TabOrder = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 207
        Height = 182
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 0
        object lblProc: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 201
          Height = 13
          Align = alTop
          Caption = 'Procedure'
          ExplicitWidth = 49
        end
        object cboProc: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 22
          Width = 201
          Height = 157
          Style = orcsSimple
          Align = alClient
          AutoSelect = True
          Caption = 'Procedure'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = True
          LookupPiece = 0
          MaxLength = 0
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 0
          Text = ''
          OnChange = cboProcSelect
          OnNeedData = cboProcNeedData
          CharsNeedMatch = 1
        end
      end
      object Panel2: TPanel
        Left = 207
        Top = 0
        Width = 206
        Height = 81
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 1
        object lblUrgency: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 200
          Height = 17
          Align = alTop
          Caption = 'Urgency'
          TabOrder = 0
        end
        object cboUrgency: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 200
          Height = 21
          Style = orcsDropDown
          Align = alClient
          AutoSelect = True
          Caption = 'Urgency'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 1
          Text = ''
          OnChange = ControlChange
          CharsNeedMatch = 1
        end
      end
      object Panel3: TPanel
        Left = 413
        Top = 0
        Width = 205
        Height = 81
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 2
        object lblAttn: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 199
          Height = 17
          Align = alTop
          Caption = 'Attention'
          TabOrder = 0
        end
        object cboAttn: TORCheckComboBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 199
          Height = 52
          Style = orcsDropDown
          Align = alClient
          AutoSelect = True
          Caption = 'Attention'
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
          TabOrder = 1
          Text = ''
          OnChange = cboAttnChange
          OnNeedData = cboAttnNeedData
          CharsNeedMatch = 1
          MainCheckBoxCaption = ' Include Non-VA Providers'
          MainCheckBoxVisible = True
          MainCheckBoxAlignment = calBottom
          OnMainCheckboxClick = cboAttnMainCheckboxClick
        end
      end
      object Panel4: TPanel
        Left = 207
        Top = 81
        Width = 206
        Height = 49
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 3
        object lblClinicallyIndicated: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 200
          Height = 17
          Align = alTop
          Caption = 'Clinically indicated date:'
          TabOrder = 0
        end
        object calClinicallyIndicated: TORDateBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 200
          Height = 20
          Align = alClient
          TabOrder = 1
          OnChange = ControlChange
          DateOnly = True
          RequireTime = False
          Caption = ''
          ExplicitHeight = 21
        end
      end
      object Panel5: TPanel
        Left = 413
        Top = 81
        Width = 205
        Height = 49
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 4
        object lblLatest: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 199
          Height = 17
          Align = alTop
          Caption = 'Latest appropriate date:'
          TabOrder = 0
          Visible = False
        end
        object calLatest: TORDateBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 199
          Height = 20
          Align = alClient
          TabOrder = 1
          Visible = False
          OnChange = ControlChange
          DateOnly = True
          RequireTime = False
          Caption = ''
          ExplicitHeight = 21
        end
      end
      object Panel6: TPanel
        Left = 207
        Top = 130
        Width = 206
        Height = 52
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 5
        object gbInptOpt: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 200
          Height = 46
          Align = alClient
          Caption = 'Patient will be seen as an:'
          TabOrder = 0
          object radInpatient: TRadioButton
            Left = 11
            Top = 23
            Width = 74
            Height = 17
            Caption = '&Inpatient'
            TabOrder = 1
            OnClick = radInpatientClick
          end
          object radOutpatient: TRadioButton
            Left = 91
            Top = 23
            Width = 89
            Height = 17
            Caption = '&Outpatient'
            TabOrder = 0
            OnClick = radOutpatientClick
          end
        end
      end
      object Panel7: TPanel
        Left = 413
        Top = 130
        Width = 205
        Height = 52
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 6
        object lblPlace: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 199
          Height = 17
          Align = alTop
          Caption = 'Place of Consultation'
          TabOrder = 0
        end
        object cboPlace: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 199
          Height = 21
          Style = orcsDropDown
          Align = alClient
          AutoSelect = True
          Caption = 'Place of Consultation'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 1
          Text = ''
          OnChange = ControlChange
          CharsNeedMatch = 1
        end
        object cboCategory: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 199
          Height = 21
          Style = orcsDropDown
          Align = alClient
          AutoSelect = True
          Caption = ''
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = False
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 2
          Text = ''
          Visible = False
          OnChange = ControlChange
          CharsNeedMatch = 1
        end
      end
      object Panel8: TPanel
        Left = 0
        Top = 182
        Width = 207
        Height = 53
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 7
        object lblService: TOROffsetLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 201
          Height = 15
          Align = alTop
          Caption = 'Service to perform this procedure'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
          ExplicitLeft = -7
          ExplicitTop = 37
          ExplicitWidth = 205
        end
        object servicelbl508: TVA508StaticText
          Name = 'servicelbl508'
          Left = 0
          Top = 21
          Width = 207
          Height = 37
          Align = alClient
          Alignment = taLeftJustify
          Caption = 'service (for screen R.)'
          Enabled = False
          TabOrder = 1
          Visible = False
          ShowAccelChar = True
          WordWrap = False
          LabelAlignment = taLeftJustify
          LabelLayout = tlTop
          ExplicitHeight = 32
        end
        object cboService: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 24
          Width = 201
          Height = 21
          Style = orcsDropDown
          Align = alClient
          AutoSelect = True
          Caption = 'Service to perform this procedure'
          Color = clWindow
          DropDownCount = 8
          Enabled = False
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = False
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 0
          Text = ''
          OnChange = cboServiceChange
          CharsNeedMatch = 1
        end
      end
      object Panel9: TPanel
        Left = 207
        Top = 182
        Width = 411
        Height = 53
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 8
        object lblProvDiag: TStaticText
          Left = 0
          Top = 0
          Width = 411
          Height = 17
          Align = alTop
          Caption = 'Provisional Diagnosis'
          TabOrder = 0
        end
        object Panel10: TPanel
          Left = 0
          Top = 17
          Width = 411
          Height = 36
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 1
          object cmdLexSearch: TButton
            AlignWithMargins = True
            Left = 352
            Top = 3
            Width = 56
            Height = 30
            Align = alRight
            Caption = 'Lexicon'
            TabOrder = 0
            OnClick = cmdLexSearchClick
          end
          object txtProvDiag: TCaptionEdit
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 343
            Height = 30
            Align = alClient
            MaxLength = 180
            ParentShowHint = False
            PopupMenu = mnuPopProvDx
            ShowHint = True
            TabOrder = 1
            OnChange = txtProvDiagChange
            Caption = 'Provisional Diagnosis'
            ExplicitHeight = 21
          end
        end
      end
    end
  end
  inherited cmdAccept: TButton
    Left = 505
    Top = 433
    Width = 113
    Height = 24
    Anchors = [akRight, akBottom]
    TabOrder = 4
    ExplicitLeft = 505
    ExplicitTop = 433
    ExplicitWidth = 113
    ExplicitHeight = 24
  end
  inherited cmdQuit: TButton
    Left = 505
    Top = 456
    Width = 113
    Height = 24
    Anchors = [akRight, akBottom]
    TabOrder = 5
    ExplicitLeft = 505
    ExplicitTop = 456
    ExplicitWidth = 113
    ExplicitHeight = 24
  end
  inherited pnlMessage: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 429
    Width = 491
    Height = 50
    Margins.Right = 130
    Align = alBottom
    ExplicitLeft = 3
    ExplicitTop = 429
    ExplicitWidth = 491
    ExplicitHeight = 50
    inherited imgMessage: TImage
      Left = 2
      Top = 2
      Height = 42
      Align = alLeft
      ExplicitLeft = 2
      ExplicitTop = 2
      ExplicitHeight = 42
    end
    inherited memMessage: TRichEdit
      Left = 34
      Top = 2
      Width = 451
      Height = 42
      Align = alClient
      ExplicitLeft = 34
      ExplicitTop = 2
      ExplicitWidth = 451
      ExplicitHeight = 42
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 32
    Top = 272
    Data = (
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = frmODProc'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = pnlCombatVet'
        'Status = stsDefault')
      (
        'Component = lblUrgency'
        'Status = stsDefault')
      (
        'Component = lblPlace'
        'Status = stsDefault')
      (
        'Component = lblAttn'
        'Status = stsDefault')
      (
        'Component = lblProvDiag'
        'Status = stsDefault')
      (
        'Component = pnlReason'
        'Status = stsDefault')
      (
        'Component = memReason'
        'Status = stsDefault')
      (
        'Component = cboUrgency'
        'Status = stsDefault')
      (
        'Component = cboPlace'
        'Status = stsDefault')
      (
        'Component = cboAttn'
        'Status = stsDefault')
      (
        'Component = cboProc'
        'Status = stsDefault')
      (
        'Component = cboCategory'
        'Status = stsDefault')
      (
        'Component = cboService'
        'Status = stsDefault')
      (
        'Component = cmdLexSearch'
        'Status = stsDefault')
      (
        'Component = gbInptOpt'
        'Status = stsDefault')
      (
        'Component = radInpatient'
        'Status = stsDefault')
      (
        'Component = radOutpatient'
        'Status = stsDefault')
      (
        'Component = txtProvDiag'
        'Status = stsDefault')
      (
        'Component = lblLatest'
        
          'Text = Latest appropriate Date/Time. Press the enter key to acce' +
          'ss.'
        'Status = stsOK')
      (
        'Component = calLatest'
        
          'Text = Latest appropriate Date/Time. Press the enter key to acce' +
          'ss.'
        'Status = stsOK')
      (
        'Component = txtCombatVet'
        'Status = stsDefault')
      (
        'Component = servicelbl508'
        'Status = stsDefault')
      (
        'Component = gpMain'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = Panel5'
        'Status = stsDefault')
      (
        'Component = Panel6'
        'Status = stsDefault')
      (
        'Component = Panel7'
        'Status = stsDefault')
      (
        'Component = Panel8'
        'Status = stsDefault')
      (
        'Component = Panel9'
        'Status = stsDefault')
      (
        'Component = Panel10'
        'Status = stsDefault'))
  end
  object mnuPopProvDx: TPopupMenu
    Left = 177
    Top = 277
    object mnuPopProvDxDelete: TMenuItem
      Caption = 'Delete diagnosis'
      OnClick = mnuPopProvDxDeleteClick
    end
  end
  object popReason: TPopupMenu
    OnPopup = popReasonPopup
    Left = 99
    Top = 273
    object popReasonCut: TMenuItem
      Caption = 'Cu&t'
      ShortCut = 16472
      OnClick = popReasonCutClick
    end
    object popReasonCopy: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = popReasonCopyClick
    end
    object popReasonPaste: TMenuItem
      Caption = '&Paste'
      ShortCut = 16470
      OnClick = popReasonPasteClick
    end
    object popReasonPaste2: TMenuItem
      Caption = 'Paste2'
      ShortCut = 8237
      Visible = False
      OnClick = popReasonPasteClick
    end
    object popReasonReformat: TMenuItem
      Caption = 'Reformat Paragraph'
      ShortCut = 16466
      OnClick = popReasonReformatClick
    end
  end
end
