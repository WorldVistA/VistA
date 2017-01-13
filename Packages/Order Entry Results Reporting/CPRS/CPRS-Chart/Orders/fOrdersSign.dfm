inherited frmSignOrders: TfrmSignOrders
  Left = 337
  Top = 142
  Caption = 'Sign Orders'
  ClientHeight = 697
  ClientWidth = 1118
  Constraints.MinHeight = 554
  Constraints.MinWidth = 862
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHelp = nil
  OnMouseDown = clstOrdersMouseDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 1136
  ExplicitHeight = 742
  PixelsPerInch = 120
  TextHeight = 16
  object laDiagnosis: TLabel [0]
    Left = 226
    Top = 228
    Width = 61
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Diagnosis'
    Visible = False
  end
  object gbdxLookup: TGroupBox [1]
    Left = 66
    Top = 133
    Width = 122
    Height = 53
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Lookup Diagnosis'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TabStop = True
    Visible = False
    object buOrdersDiagnosis: TButton
      Left = 9
      Top = 20
      Width = 105
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&Diagnosis'
      Enabled = False
      TabOrder = 0
      OnClick = buOrdersDiagnosisClick
    end
  end
  object pnlDEAText: TPanel [2]
    AlignWithMargins = True
    Left = 4
    Top = 581
    Width = 1110
    Height = 53
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    object lblDEAText: TStaticText
      Left = 0
      Top = 0
      Width = 1110
      Height = 53
      Margins.Left = 7
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Caption = 
        'By completing the two-factor authentication protocol at this tim' +
        'e, you are legally signing the prescription(s) and authorizing t' +
        'he transmission of the above informationto the pharmacy for disp' +
        'ensing.  The two-factor authentication protocol may only be comp' +
        'leted by the practitioner whose name and DEA registration number' +
        ' appear above. '
      TabOrder = 0
    end
  end
  object pnlEsig: TPanel [3]
    Left = 0
    Top = 638
    Width = 1118
    Height = 59
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    DesignSize = (
      1118
      59)
    object lblESCode: TLabel
      Left = 9
      Top = -1
      Width = 155
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft]
      Caption = 'Electronic Signature Code'
    end
    object txtESCode: TCaptionEdit
      Left = 7
      Top = 22
      Width = 169
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft]
      PasswordChar = '*'
      TabOrder = 0
      Caption = 'Electronic Signature Code'
    end
    object cmdOK: TButton
      Left = 916
      Top = 23
      Width = 88
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight]
      Caption = 'Sign'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 1017
      Top = 23
      Width = 88
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
  end
  object pnlCombined: TORAutoPanel [4]
    Left = 0
    Top = 213
    Width = 1118
    Height = 364
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    object pnlOrderList: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 1110
      Height = 145
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        1110
        145)
      object lblOrderList: TStaticText
        Left = 0
        Top = 0
        Width = 1110
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'All Orders Except Controlled Substance EPCS Orders'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
      end
      object clstOrders: TCaptionCheckListBox
        Left = 0
        Top = 28
        Width = 1110
        Height = 117
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        OnClickCheck = clstOrdersClickCheck
        Anchors = [akLeft, akTop, akRight, akBottom]
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        PopupMenu = poBACopyPaste
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 1
        OnClick = clstOrdersClick
        OnDrawItem = clstOrdersDrawItem
        OnKeyUp = clstOrdersKeyUp
        OnMeasureItem = clstOrdersMeasureItem
        OnMouseDown = clstOrdersMouseDown
        OnMouseMove = clstOrdersMouseMove
        Caption = 'The following orders will be signed -'
      end
    end
    object pnlCSOrderList: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 157
      Width = 1110
      Height = 203
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        1110
        203)
      object lblCSOrderList: TStaticText
        Left = 0
        Top = 0
        Width = 1110
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Controlled Substance EPCS Orders'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
      end
      object lblSmartCardNeeded: TStaticText
        Left = 226
        Top = 0
        Width = 157
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'SMART card required'
        Color = clBtnFace
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentDoubleBuffered = False
        ParentFont = False
        TabOrder = 1
        Transparent = False
      end
      object clstCSOrders: TCaptionCheckListBox
        Left = 0
        Top = 20
        Width = 1110
        Height = 182
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        OnClickCheck = clstCSOrdersClickCheck
        Anchors = [akLeft, akTop, akRight, akBottom]
        DoubleBuffered = True
        ParentDoubleBuffered = False
        PopupMenu = poBACopyPaste
        Style = lbOwnerDrawVariable
        TabOrder = 2
        OnClick = clstCSOrdersClick
        OnDrawItem = clstCSOrdersDrawItem
        OnMeasureItem = clstCSOrdersMeasureItem
        Caption = 'The following orders will be signed -'
      end
    end
  end
  object pnlTop: TPanel [5]
    Left = 0
    Top = 0
    Width = 1118
    Height = 213
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 4
    inline fraCoPay: TfraCoPayDesc
      Left = 251
      Top = 0
      Width = 867
      Height = 213
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      AutoSize = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitLeft = 251
      ExplicitWidth = 867
      ExplicitHeight = 213
      inherited pnlRight: TPanel
        Left = 531
        Width = 336
        Height = 213
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = True
        ExplicitLeft = 531
        ExplicitWidth = 336
        ExplicitHeight = 213
        inherited Spacer2: TLabel
          Top = 20
          Width = 336
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ExplicitTop = 20
          ExplicitWidth = 336
        end
        inherited lblCaption: TStaticText
          Width = 336
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ExplicitWidth = 336
          ExplicitHeight = 20
        end
        inherited ScrollBox1: TScrollBox
          Top = 23
          Width = 336
          Height = 190
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          ExplicitTop = 23
          ExplicitWidth = 336
          ExplicitHeight = 190
          inherited pnlMain: TPanel
            Width = 311
            Height = 204
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ExplicitWidth = 311
            ExplicitHeight = 204
            inherited spacer1: TLabel
              Top = 25
              Width = 311
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 25
              ExplicitWidth = 315
            end
            inherited pnlHNC: TPanel
              Top = 160
              Width = 311
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 160
              ExplicitWidth = 311
              ExplicitHeight = 22
              inherited lblHNC2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblHNC: TVA508StaticText
                Left = 17
                Width = 38
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 17
                ExplicitWidth = 38
                ExplicitHeight = 22
              end
            end
            inherited pnlMST: TPanel
              Top = 138
              Width = 311
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 138
              ExplicitWidth = 311
              ExplicitHeight = 22
              inherited lblMST2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblMST: TVA508StaticText
                Left = 16
                Width = 38
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 16
                ExplicitWidth = 38
                ExplicitHeight = 22
              end
            end
            inherited pnlSWAC: TPanel
              Top = 94
              Width = 311
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 94
              ExplicitWidth = 311
              ExplicitHeight = 22
              inherited lblSWAC2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblSWAC: TVA508StaticText
                Left = 4
                Width = 49
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 4
                ExplicitWidth = 49
                ExplicitHeight = 22
              end
            end
            inherited pnlIR: TPanel
              Top = 72
              Width = 311
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 72
              ExplicitWidth = 311
              ExplicitHeight = 22
              inherited lblIR2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblIR: TVA508StaticText
                Left = 26
                Width = 22
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 26
                ExplicitWidth = 22
                ExplicitHeight = 22
              end
            end
            inherited pnlAO: TPanel
              Top = 50
              Width = 311
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 50
              ExplicitWidth = 311
              ExplicitHeight = 22
              inherited lblAO2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblAO: TVA508StaticText
                Left = 22
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 22
                ExplicitHeight = 22
              end
            end
            inherited pnlSC: TPanel
              Top = 0
              Width = 311
              Height = 25
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 0
              ExplicitWidth = 311
              ExplicitHeight = 25
              inherited lblSC2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblSC: TVA508StaticText
                Left = 25
                Width = 33
                Height = 23
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 25
                ExplicitWidth = 33
                ExplicitHeight = 23
              end
            end
            inherited pnlCV: TPanel
              Top = 28
              Width = 311
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 28
              ExplicitWidth = 311
              ExplicitHeight = 22
              inherited lblCV2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblCV: TVA508StaticText
                Left = 25
                Width = 33
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 25
                ExplicitWidth = 33
                ExplicitHeight = 22
              end
            end
            inherited pnlSHD: TPanel
              Top = 116
              Width = 311
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              AutoSize = False
              ExplicitTop = 116
              ExplicitWidth = 311
              ExplicitHeight = 22
              inherited lblSHAD: TVA508StaticText
                Left = 16
                Width = 41
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 16
                ExplicitWidth = 41
                ExplicitHeight = 22
              end
              inherited lblSHAD2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
            end
            inherited pnlCL: TPanel
              Top = 182
              Width = 311
              Height = 22
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              ExplicitLeft = 0
              ExplicitTop = 182
              ExplicitWidth = 311
              ExplicitHeight = 22
              inherited lblCL: TVA508StaticText
                Left = 26
                Width = 44
                Height = 22
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                ExplicitLeft = 26
                ExplicitWidth = 44
                ExplicitHeight = 22
              end
              inherited lblCL2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
            end
          end
        end
      end
      inherited pnlSCandRD: TPanel
        Width = 531
        Height = 213
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ExplicitWidth = 531
        ExplicitHeight = 213
        inherited lblSCDisplay: TLabel
          Width = 531
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ExplicitWidth = 530
          ExplicitHeight = 21
        end
        inherited memSCDisplay: TCaptionMemo
          Top = 21
          Width = 531
          Height = 192
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ExplicitTop = 21
          ExplicitWidth = 531
          ExplicitHeight = 192
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = 0
      Width = 251
      Height = 213
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelEdges = []
      BevelOuter = bvNone
      TabOrder = 1
      object lblProvInfo: TLabel
        Left = 10
        Top = 4
        Width = 51
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'prov info'
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 760
    Top = 88
    Data = (
      (
        'Component = gbdxLookup'
        'Status = stsDefault')
      (
        'Component = buOrdersDiagnosis'
        'Status = stsDefault')
      (
        'Component = fraCoPay'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlRight'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCaption'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlMain'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlHNC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblHNC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblHNC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlMST'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblMST2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblMST'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSWAC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSWAC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSWAC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlIR'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblIR2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblIR'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlAO'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblAO2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblAO'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlCV'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCV2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCV'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSHD'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSHAD'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSHAD2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSCandRD'
        'Status = stsDefault')
      (
        'Component = fraCoPay.memSCDisplay'
        'Status = stsDefault')
      (
        'Component = frmSignOrders'
        'Status = stsDefault')
      (
        'Component = pnlDEAText'
        'Status = stsDefault')
      (
        'Component = lblDEAText'
        'Status = stsDefault')
      (
        'Component = pnlProvInfo'
        'Status = stsDefault')
      (
        'Component = pnlOrderList'
        'Status = stsDefault')
      (
        'Component = lblOrderList'
        'Status = stsDefault')
      (
        'Component = clstOrders'
        'Status = stsDefault')
      (
        'Component = pnlCSOrderList'
        'Status = stsDefault')
      (
        'Component = lblCSOrderList'
        'Status = stsDefault')
      (
        'Component = lblSmartCardNeeded'
        'Status = stsDefault')
      (
        'Component = clstCSOrders'
        'Status = stsDefault')
      (
        'Component = pnlEsig'
        'Status = stsDefault')
      (
        'Component = txtESCode'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = pnlCombined'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault'))
  end
  object poBACopyPaste: TPopupMenu
    Left = 32
    Top = 16
    object Copy1: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = Copy1Click
    end
    object Paste1: TMenuItem
      Caption = '&Paste'
      Enabled = False
      ShortCut = 16470
      OnClick = Paste1Click
    end
    object Diagnosis1: TMenuItem
      Caption = '&Diagnosis...'
      ShortCut = 32836
      OnClick = buOrdersDiagnosisClick
    end
    object Exit1: TMenuItem
      Caption = '&Exit'
      ShortCut = 16453
      OnClick = Exit1Click
    end
  end
end
