inherited frmEditProc: TfrmEditProc
  Tag = 112
  Left = 408
  Top = 210
  Width = 580
  Height = 480
  HorzScrollBar.Range = 561
  VertScrollBar.Range = 308
  Caption = 'Edit and resubmit a cancelled procedure'
  Constraints.MinHeight = 480
  Constraints.MinWidth = 580
  Position = poScreenCenter
  ExplicitWidth = 580
  ExplicitHeight = 480
  PixelsPerInch = 96
  TextHeight = 16
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
      Left = 0
      Top = 0
      Width = 558
      Height = 25
      Align = alClient
      Alignment = taCenter
      BevelOuter = bvNone
      Caption = ''
      Enabled = False
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  object pnlMessage: TPanel [1]
    AlignWithMargins = True
    Left = 3
    Top = 362
    Width = 558
    Height = 44
    Align = alBottom
    BevelInner = bvRaised
    BorderStyle = bsSingle
    TabOrder = 2
    Visible = False
    object imgMessage: TImage
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 32
      Height = 30
      Align = alLeft
      ExplicitLeft = 4
      ExplicitTop = 4
      ExplicitHeight = 32
    end
    object memMessage: TRichEdit
      AlignWithMargins = True
      Left = 43
      Top = 5
      Width = 506
      Height = 30
      Align = alClient
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
  object pnlMain: TPanel [2]
    AlignWithMargins = True
    Left = 3
    Top = 34
    Width = 558
    Height = 322
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblReason: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 270
      Width = 552
      Height = 16
      Align = alTop
      Caption = 'Reason for Request'
      ExplicitWidth = 120
    end
    object lblComment: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 204
      Width = 552
      Height = 16
      Align = alTop
      Caption = 'New Comments'
      ExplicitWidth = 94
    end
    object memReason: TRichEdit
      AlignWithMargins = True
      Left = 3
      Top = 292
      Width = 552
      Height = 27
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      PopupMenu = popReason
      ScrollBars = ssVertical
      TabOrder = 1
      WantTabs = True
      Zoom = 100
      OnChange = ControlChange
      OnExit = memReasonExit
      OnKeyDown = memReasonKeyDown
      OnKeyPress = memReasonKeyPress
      OnKeyUp = memCommentKeyUp
    end
    object memComment: TRichEdit
      AlignWithMargins = True
      Left = 3
      Top = 226
      Width = 552
      Height = 38
      Align = alTop
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      PopupMenu = popReason
      TabOrder = 0
      WantTabs = True
      Zoom = 100
      OnChange = ControlChange
      OnExit = memCommentExit
      OnKeyUp = memCommentKeyUp
    end
    object GridPanel1: TGridPanel
      Left = 0
      Top = 0
      Width = 558
      Height = 201
      Align = alTop
      Caption = 'GridPanel1'
      ColumnCollection = <
        item
          Value = 33.305800784590270000
        end
        item
          Value = 34.045338929341340000
        end
        item
          Value = 32.648860286068380000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = Panel1
          Row = 0
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
          Column = 0
          Control = Panel5
          Row = 1
        end
        item
          Column = 1
          Control = Panel6
          Row = 1
        end
        item
          Column = 2
          Control = Panel7
          Row = 1
        end
        item
          Column = 1
          Control = Panel9
          Row = 2
        end
        item
          Column = 2
          Control = Panel10
          Row = 2
        end
        item
          Column = 0
          Control = Panel11
          Row = 3
        end
        item
          Column = 1
          ColumnSpan = 2
          Control = Panel12
          Row = 3
        end>
      RowCollection = <
        item
          Value = 25.008005101709600000
        end
        item
          Value = 24.989503157089210000
        end
        item
          Value = 24.998331248786980000
        end
        item
          Value = 25.004160492414210000
        end>
      ShowCaption = False
      TabOrder = 2
      object Panel1: TPanel
        Left = 1
        Top = 1
        Width = 185
        Height = 49
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 0
        object lblProc: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 179
          Height = 16
          Align = alTop
          Caption = 'Procedure'
          ExplicitWidth = 63
        end
        object cboProc: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 179
          Height = 24
          Style = orcsDropDown
          Align = alClient
          AutoSelect = True
          Caption = 'Procedure'
          Color = clWindow
          DropDownCount = 8
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 16
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = True
          LookupPiece = 0
          MaxLength = 0
          ParentFont = False
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
        Left = 186
        Top = 1
        Width = 189
        Height = 49
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 1
        object lblUrgency: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 183
          Height = 20
          Align = alTop
          Caption = 'Urgency'
          TabOrder = 0
        end
        object cboUrgency: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 29
          Width = 183
          Height = 24
          Style = orcsDropDown
          Align = alClient
          AutoSelect = True
          Caption = 'Urgency'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 16
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
        Left = 375
        Top = 1
        Width = 182
        Height = 49
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 2
        object lblAttn: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 176
          Height = 20
          Align = alTop
          Caption = 'Attention'
          TabOrder = 0
        end
        object txtAttn: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 29
          Width = 176
          Height = 24
          Style = orcsDropDown
          Align = alClient
          AutoSelect = True
          Caption = 'Attention'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 16
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
          OnChange = ControlChange
          OnNeedData = txtAttnNeedData
          CharsNeedMatch = 1
        end
      end
      object Panel5: TPanel
        Left = 1
        Top = 50
        Width = 185
        Height = 49
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 3
        object lblService: TOROffsetLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 179
          Height = 16
          Align = alTop
          Caption = 'Service to perform this procedure'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
          ExplicitWidth = 192
        end
        object cboService: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 179
          Height = 24
          Style = orcsDropDown
          Align = alClient
          AutoSelect = True
          Caption = 'Service to perform this procedure'
          Color = clWindow
          DropDownCount = 8
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 16
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = False
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          ParentFont = False
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 0
          Text = ''
          OnChange = ControlChange
          CharsNeedMatch = 1
        end
      end
      object Panel6: TPanel
        Left = 186
        Top = 50
        Width = 189
        Height = 49
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 4
        object calClinicallyIndicated: TORDateBox
          AlignWithMargins = True
          Left = 3
          Top = 29
          Width = 183
          Height = 17
          Align = alClient
          TabOrder = 0
          OnExit = calClinicallyIndicatedExit
          DateOnly = True
          RequireTime = False
          Caption = ''
          ExplicitHeight = 24
        end
        object lblClinicallyIndicated: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 183
          Height = 20
          Align = alTop
          Caption = 'Clinically indicated date:'
          TabOrder = 1
        end
      end
      object Panel7: TPanel
        Left = 375
        Top = 50
        Width = 182
        Height = 49
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 5
        object lblLatest: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 176
          Height = 20
          Align = alTop
          Caption = 'Latest appropriate date:'
          TabOrder = 0
          Visible = False
        end
        object calLatest: TORDateBox
          AlignWithMargins = True
          Left = 3
          Top = 29
          Width = 176
          Height = 17
          Align = alClient
          TabOrder = 1
          Visible = False
          OnExit = calLatestExit
          DateOnly = True
          RequireTime = False
          Caption = ''
          ExplicitHeight = 24
        end
      end
      object Panel9: TPanel
        Left = 186
        Top = 99
        Width = 189
        Height = 49
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 6
        object lblInpOutp: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 183
          Height = 20
          Align = alTop
          Caption = 'Patient will be seen as an:'
          TabOrder = 0
        end
        object radInpatient: TRadioButton
          Left = 6
          Top = 25
          Width = 77
          Height = 17
          Caption = '&Inpatient'
          TabOrder = 1
          OnClick = radInpatientClick
        end
        object radOutpatient: TRadioButton
          Left = 89
          Top = 25
          Width = 96
          Height = 17
          Caption = '&Outpatient'
          TabOrder = 2
          OnClick = radOutpatientClick
        end
      end
      object Panel10: TPanel
        Left = 375
        Top = 99
        Width = 182
        Height = 49
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 7
        object lblPlace: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 176
          Height = 20
          Align = alTop
          Caption = 'Place of Consultation'
          TabOrder = 0
        end
        object cboPlace: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 29
          Width = 176
          Height = 24
          Style = orcsDropDown
          Align = alClient
          AutoSelect = True
          Caption = 'Place of Consultation'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 16
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
          Top = 29
          Width = 176
          Height = 24
          Style = orcsDropDown
          Align = alClient
          AutoSelect = True
          Caption = ''
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 16
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
      object Panel11: TPanel
        Left = 1
        Top = 148
        Width = 185
        Height = 52
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 8
        object Panel13: TPanel
          Left = 0
          Top = 0
          Width = 185
          Height = 52
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 0
          object lblComments: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 179
            Height = 16
            Align = alTop
            Caption = 'Display Comments:'
            ExplicitWidth = 116
          end
          object btnCmtCancel: TButton
            AlignWithMargins = True
            Left = 3
            Top = 25
            Width = 106
            Height = 24
            Align = alClient
            Caption = 'Cancellation'
            TabOrder = 0
            OnClick = btnCmtCancelClick
          end
          object btnCmtOther: TButton
            AlignWithMargins = True
            Left = 115
            Top = 25
            Width = 67
            Height = 24
            Align = alRight
            Caption = 'Other'
            TabOrder = 1
            OnClick = btnCmtOtherClick
          end
        end
      end
      object Panel12: TPanel
        Left = 186
        Top = 148
        Width = 371
        Height = 52
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 9
        object lblProvDiag: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 365
          Height = 20
          Align = alTop
          Caption = 'Provisional Diagnosis'
          TabOrder = 0
        end
        object Panel8: TPanel
          Left = 0
          Top = 26
          Width = 371
          Height = 26
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 1
          object cmdLexSearch: TButton
            AlignWithMargins = True
            Left = 311
            Top = 3
            Width = 57
            Height = 20
            Align = alRight
            Caption = 'Lexicon'
            TabOrder = 1
            OnClick = cmdLexSearchClick
          end
          object txtProvDiag: TCaptionEdit
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 302
            Height = 20
            Align = alClient
            MaxLength = 180
            ParentShowHint = False
            PopupMenu = mnuPopProvDx
            ShowHint = True
            TabOrder = 0
            OnChange = ControlChange
            Caption = 'Provisional Diagnosis'
            ExplicitHeight = 24
          end
        end
      end
    end
  end
  object pnlButtons: TPanel [3]
    Left = 0
    Top = 409
    Width = 564
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 3
    object cmdAccept: TButton
      AlignWithMargins = True
      Left = 411
      Top = 3
      Width = 72
      Height = 27
      Align = alRight
      Caption = 'Resubmit'
      TabOrder = 0
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
      TabOrder = 1
      OnClick = cmdQuitClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 96
    Top = 8
    Data = (
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
        'Component = frmEditProc'
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
        'Component = txtAttn'
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
        'Component = memComment'
        'Status = stsDefault')
      (
        'Component = btnCmtCancel'
        'Status = stsDefault')
      (
        'Component = btnCmtOther'
        'Status = stsDefault')
      (
        'Component = cmdLexSearch'
        'Status = stsDefault')
      (
        'Component = lblClinicallyIndicated'
        'Status = stsDefault')
      (
        'Component = lblLatest'
        'Status = stsDefault')
      (
        'Component = calClinicallyIndicated'
        
          'Text = Earliest appropriate Date/Time. Press the enter key to ac' +
          'cess.'
        'Status = stsOK')
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
        'Component = Panel3'
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
        'Component = Panel11'
        'Status = stsDefault')
      (
        'Component = Panel12'
        'Status = stsDefault')
      (
        'Component = Panel13'
        'Status = stsDefault'))
  end
  object mnuPopProvDx: TPopupMenu
    Left = 351
    Top = 12
    object mnuPopProvDxDelete: TMenuItem
      Caption = 'Delete diagnosis'
      OnClick = mnuPopProvDxDeleteClick
    end
  end
  object popReason: TPopupMenu
    OnPopup = popReasonPopup
    Left = 523
    Top = 9
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
