inherited frmEditCslt: TfrmEditCslt
  Tag = 110
  Left = 461
  Top = 191
  Width = 580
  Height = 500
  HorzScrollBar.Range = 561
  VertScrollBar.Range = 340
  Caption = 'Edit/Resubmit a Cancelled Consult'
  Constraints.MinHeight = 500
  Constraints.MinWidth = 580
  Position = poScreenCenter
  ExplicitWidth = 580
  ExplicitHeight = 500
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCombatVet: TPanel [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 558
    Height = 25
    Align = alTop
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
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 552
      Height = 19
      Align = alClient
      Alignment = taCenter
      BevelOuter = bvNone
      Caption = ''
      Enabled = False
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  object pnlMain: TPanel [1]
    AlignWithMargins = True
    Left = 3
    Top = 34
    Width = 558
    Height = 391
    Align = alClient
    TabOrder = 1
    object lblReason: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 277
      Width = 550
      Height = 13
      Align = alTop
      Caption = 'Reason for Request'
      ExplicitWidth = 95
    end
    object lblComment: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 211
      Width = 550
      Height = 13
      Align = alTop
      Caption = 'New Comments:'
      ExplicitWidth = 77
    end
    object memReason: TRichEdit
      AlignWithMargins = True
      Left = 4
      Top = 296
      Width = 550
      Height = 41
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      PopupMenu = popReason
      ScrollBars = ssVertical
      TabOrder = 2
      WantTabs = True
      Zoom = 100
      OnChange = ControlChange
      OnExit = memReasonExit
      OnKeyDown = memCommentKeyDown
      OnKeyPress = memCommentKeyPress
      OnKeyUp = memCommentKeyUp
    end
    object memComment: TRichEdit
      AlignWithMargins = True
      Left = 4
      Top = 230
      Width = 550
      Height = 41
      Align = alTop
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      PopupMenu = popReason
      TabOrder = 1
      WantTabs = True
      Zoom = 100
      OnChange = ControlChange
      OnExit = memCommentExit
      OnKeyDown = memCommentKeyDown
      OnKeyPress = memCommentKeyPress
      OnKeyUp = memCommentKeyUp
    end
    object pnlMessage: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 343
      Width = 550
      Height = 44
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'pnlMessage'
      TabOrder = 3
      Visible = False
      object imgMessage: TImage
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 32
        Height = 38
        Align = alLeft
        ExplicitLeft = 4
        ExplicitTop = 4
        ExplicitHeight = 32
      end
      object memMessage: TRichEdit
        Left = 38
        Top = 0
        Width = 512
        Height = 44
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Color = clInfoBk
        Font.Charset = ANSI_CHARSET
        Font.Color = clInfoText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        WantReturns = False
        Zoom = 100
      end
    end
    object GridPanel1: TGridPanel
      Left = 1
      Top = 1
      Width = 556
      Height = 207
      Align = alTop
      BevelOuter = bvNone
      Caption = 'GridPanel1'
      ColumnCollection = <
        item
          Value = 33.342861973827160000
        end
        item
          Value = 33.451125237980240000
        end
        item
          Value = 33.206012788192600000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = Panel1
          Row = 0
          RowSpan = 3
        end
        item
          Column = 0
          Control = Panel2
          Row = 3
        end
        item
          Column = 1
          Control = Panel3
          Row = 0
        end
        item
          Column = 1
          Control = Panel4
          Row = 1
        end
        item
          Column = 1
          Control = Panel5
          Row = 2
        end
        item
          Column = 1
          ColumnSpan = 2
          Control = Panel6
          Row = 3
        end
        item
          Column = 2
          Control = Panel8
          Row = 0
        end
        item
          Column = 2
          Control = Panel9
          Row = 1
        end
        item
          Column = 2
          Control = Panel10
          Row = 2
        end>
      Ctl3D = False
      ParentCtl3D = False
      RowCollection = <
        item
          Value = 25.101873336510030000
        end
        item
          Value = 24.994790006888740000
        end
        item
          Value = 24.811492231582010000
        end
        item
          Value = 25.091844425019210000
        end>
      ShowCaption = False
      TabOrder = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 185
        Height = 153
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 0
        object lblService: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 179
          Height = 13
          Align = alTop
          Caption = 'Consult to Service/Specialty'
          ExplicitWidth = 134
        end
        object cboService: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 22
          Width = 179
          Height = 128
          Style = orcsSimple
          Align = alClient
          AutoSelect = True
          Caption = 'Consult to Service/Specialty'
          Color = clWindow
          DropDownCount = 8
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          ParentFont = False
          Pieces = '2'
          Sorted = True
          SynonymChars = '<>'
          TabOrder = 0
          Text = ''
          CharsNeedMatch = 1
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 153
        Width = 185
        Height = 54
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel2'
        ShowCaption = False
        TabOrder = 7
        object lblComments: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 179
          Height = 13
          Align = alTop
          Caption = 'Display Comments:'
          ExplicitWidth = 89
        end
        object btnCmtOther: TButton
          AlignWithMargins = True
          Left = 107
          Top = 22
          Width = 75
          Height = 29
          Align = alRight
          Caption = 'Other'
          TabOrder = 1
          OnClick = btnCmtOtherClick
        end
        object btnCmtCancel: TButton
          AlignWithMargins = True
          Left = 3
          Top = 22
          Width = 98
          Height = 29
          Align = alClient
          Caption = 'Cancellation'
          TabOrder = 0
          OnClick = btnCmtCancelClick
        end
      end
      object Panel3: TPanel
        Left = 185
        Top = 0
        Width = 185
        Height = 51
        Align = alClient
        BevelOuter = bvNone
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
        object lblUrgency: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 179
          Height = 17
          Align = alTop
          Caption = 'Urgency'
          TabOrder = 0
        end
        object cboUrgency: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 179
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
      object Panel4: TPanel
        Left = 185
        Top = 51
        Width = 185
        Height = 51
        Align = alClient
        BevelOuter = bvNone
        ParentShowHint = False
        ShowHint = False
        TabOrder = 3
        object lblClinicallyIndicated: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 179
          Height = 17
          Align = alTop
          Caption = 'Clinically indicated date:'
          TabOrder = 0
        end
        object calClinicallyIndicated: TORDateBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 179
          Height = 22
          Align = alClient
          TabOrder = 1
          OnExit = calClinicallyIndicatedExit
          DateOnly = True
          RequireTime = False
          Caption = ''
          ExplicitHeight = 19
        end
      end
      object Panel5: TPanel
        Left = 185
        Top = 102
        Width = 185
        Height = 51
        Align = alClient
        BevelOuter = bvNone
        ParentShowHint = False
        ShowHint = False
        TabOrder = 5
        object lblInpOutp: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 179
          Height = 17
          Align = alTop
          Caption = 'Patient will be seen as an:'
          TabOrder = 0
        end
        object radInpatient: TRadioButton
          Left = 6
          Top = 29
          Width = 75
          Height = 17
          Caption = '&Inpatient'
          TabOrder = 1
          OnClick = radInpatientClick
        end
        object radOutpatient: TRadioButton
          Left = 81
          Top = 29
          Width = 97
          Height = 17
          Caption = '&Outpatient'
          TabOrder = 2
          OnClick = radOutpatientClick
        end
      end
      object Panel6: TPanel
        Left = 185
        Top = 153
        Width = 371
        Height = 54
        Align = alClient
        BevelOuter = bvNone
        ParentShowHint = False
        ShowHint = False
        TabOrder = 8
        object lblProvDiag: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 365
          Height = 17
          Align = alTop
          Caption = 'Provisional Diagnosis'
          TabOrder = 0
        end
        object Panel7: TPanel
          Left = 0
          Top = 23
          Width = 371
          Height = 31
          Align = alClient
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 1
          object cmdLexSearch: TButton
            AlignWithMargins = True
            Left = 299
            Top = 3
            Width = 69
            Height = 25
            Align = alRight
            Caption = 'Lexicon'
            TabOrder = 1
            OnClick = cmdLexSearchClick
          end
          object txtProvDiag: TCaptionEdit
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 290
            Height = 25
            Align = alClient
            MaxLength = 180
            ParentShowHint = False
            PopupMenu = mnuPopProvDx
            ShowHint = True
            TabOrder = 0
            OnChange = ControlChange
            Caption = 'Provisional Diagnosis'
            ExplicitHeight = 19
          end
        end
      end
      object Panel8: TPanel
        Left = 370
        Top = 0
        Width = 186
        Height = 51
        Align = alClient
        BevelOuter = bvNone
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
        object lblAttn: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 180
          Height = 17
          Align = alTop
          Caption = 'Attention'
          TabOrder = 0
        end
        object cboAttn: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 180
          Height = 21
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
          TabStop = True
          Text = ''
          OnChange = ControlChange
          OnNeedData = cboAttnNeedData
          CharsNeedMatch = 1
        end
      end
      object Panel9: TPanel
        Left = 370
        Top = 51
        Width = 186
        Height = 51
        Align = alClient
        BevelOuter = bvNone
        ParentShowHint = False
        ShowHint = False
        TabOrder = 4
        object lblLatest: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 180
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
          Width = 180
          Height = 22
          Align = alClient
          TabOrder = 1
          Visible = False
          OnExit = calLatestExit
          DateOnly = True
          RequireTime = False
          Caption = ''
          ExplicitHeight = 19
        end
      end
      object Panel10: TPanel
        Left = 370
        Top = 102
        Width = 186
        Height = 51
        Align = alClient
        BevelOuter = bvNone
        ParentShowHint = False
        ShowHint = False
        TabOrder = 6
        object lblPlace: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 180
          Height = 17
          Align = alTop
          Caption = 'Place of Consultation'
          TabOrder = 0
        end
        object cboCategory: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 180
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
          TabOrder = 1
          Text = ''
          Visible = False
          CharsNeedMatch = 1
        end
        object cboPlace: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 26
          Width = 180
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
          TabOrder = 2
          Text = ''
          OnChange = ControlChange
          CharsNeedMatch = 1
        end
      end
    end
  end
  object pnlButtons: TPanel [2]
    Left = 0
    Top = 428
    Width = 564
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    object stLaunchToolbox: TStaticText
      Left = 7
      Top = 7
      Width = 197
      Height = 17
      Caption = 'Launch Consult Toolbox Button Disabled'
      TabOrder = 1
      TabStop = True
      Visible = False
    end
    object cmdAccept: TButton
      AlignWithMargins = True
      Left = 410
      Top = 3
      Width = 73
      Height = 27
      Align = alRight
      Caption = 'Resubmit'
      TabOrder = 2
      OnClick = cmdAcceptClick
    end
    object cmdQuit: TButton
      AlignWithMargins = True
      Left = 489
      Top = 3
      Width = 72
      Height = 27
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdQuitClick
    end
    object btnLaunchToolbox: TButton
      Left = 7
      Top = 3
      Width = 162
      Height = 25
      Caption = 'Open Consult Toolbox'
      TabOrder = 0
      OnClick = btnLaunchToolboxClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 24
    Top = 96
    Data = (
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = frmEditCslt'
        'Status = stsDefault')
      (
        'Component = pnlMain'
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
        'Component = lblInpOutp'
        'Status = stsDefault')
      (
        'Component = memReason'
        'Status = stsDefault')
      (
        'Component = cboService'
        'Status = stsDefault')
      (
        'Component = cboUrgency'
        'Status = stsDefault')
      (
        'Component = radInpatient'
        'Status = stsDefault')
      (
        'Component = radOutpatient'
        'Status = stsDefault')
      (
        'Component = cboPlace'
        'Status = stsDefault')
      (
        'Component = txtProvDiag'
        'Status = stsDefault')
      (
        'Component = cboAttn'
        'Status = stsDefault')
      (
        'Component = cboCategory'
        'Status = stsDefault')
      (
        'Component = memComment'
        'Status = stsDefault')
      (
        'Component = cmdLexSearch'
        'Status = stsDefault')
      (
        'Component = lblClinicallyIndicated'
        'Status = stsDefault')
      (
        'Component = calClinicallyIndicated'
        'Text = Clinice. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = lblLatest'
        'Status = stsDefault')
      (
        'Component = calLatest'
        
          'Text = Latest appropriate Date/Time. Press the enter key to acce' +
          'ss.'
        'Status = stsOK')
      (
        'Component = pnlCombatVet'
        'Status = stsDefault')
      (
        'Component = txtCombatVet'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = GridPanel1'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = btnCmtOther'
        'Status = stsDefault')
      (
        'Component = btnCmtCancel'
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
        'Status = stsDefault')
      (
        'Component = btnLaunchToolbox'
        'Status = stsDefault')
      (
        'Component = stLaunchToolbox'
        'Status = stsDefault'))
  end
  object mnuPopProvDx: TPopupMenu
    Left = 137
    Top = 121
    object mnuPopProvDxDelete: TMenuItem
      Caption = 'Delete diagnosis'
      OnClick = mnuPopProvDxDeleteClick
    end
  end
  object popReason: TPopupMenu
    OnPopup = popReasonPopup
    Left = 83
    Top = 97
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
