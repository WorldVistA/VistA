inherited frmSignOrders: TfrmSignOrders
  Left = 337
  Top = 142
  Caption = 'Sign Orders'
  ClientHeight = 558
  ClientWidth = 894
  Constraints.MinHeight = 443
  Constraints.MinWidth = 690
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
  PixelsPerInch = 96
  TextHeight = 13
  object laDiagnosis: TLabel [0]
    Left = 181
    Top = 182
    Width = 46
    Height = 13
    Caption = 'Diagnosis'
    Visible = False
  end
  object gbdxLookup: TGroupBox [1]
    Left = 53
    Top = 106
    Width = 97
    Height = 43
    Caption = 'Lookup Diagnosis'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TabStop = True
    Visible = False
    object buOrdersDiagnosis: TButton
      Left = 7
      Top = 16
      Width = 84
      Height = 21
      Caption = '&Diagnosis'
      Enabled = False
      TabOrder = 0
      OnClick = buOrdersDiagnosisClick
    end
  end
  object pnlDEAText: TPanel [2]
    AlignWithMargins = True
    Left = 3
    Top = 465
    Width = 888
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    object lblDEAText: TStaticText
      Left = 0
      Top = 0
      Width = 1574
      Height = 17
      Margins.Left = 6
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
    Top = 510
    Width = 894
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    DesignSize = (
      894
      48)
    object lblESCode: TLabel
      Left = 7
      Top = -1
      Width = 123
      Height = 13
      Anchors = [akLeft]
      Caption = 'Electronic Signature Code'
    end
    object txtESCode: TCaptionEdit
      Left = 6
      Top = 18
      Width = 135
      Height = 24
      Anchors = [akLeft]
      PasswordChar = '*'
      TabOrder = 0
      Caption = 'Electronic Signature Code'
    end
    object cmdOK: TButton
      Left = 733
      Top = 18
      Width = 70
      Height = 21
      Anchors = [akRight]
      Caption = 'Sign'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 814
      Top = 18
      Width = 70
      Height = 21
      Anchors = [akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
  end
  object pnlCombined: TORAutoPanel [4]
    Left = 0
    Top = 170
    Width = 894
    Height = 292
    Align = alClient
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    object pnlOrderList: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 888
      Height = 116
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        888
        116)
      object lblOrderList: TStaticText
        Left = 0
        Top = 0
        Width = 888
        Height = 17
        Align = alTop
        Caption = 'All Orders Except Controlled Substance EPCS Orders'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        ExplicitWidth = 254
      end
      object clstOrders: TCaptionCheckListBox
        Left = 0
        Top = 22
        Width = 888
        Height = 94
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
      Left = 3
      Top = 125
      Width = 888
      Height = 164
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitTop = 126
      ExplicitHeight = 162
      DesignSize = (
        888
        164)
      object lblCSOrderList: TStaticText
        Left = 0
        Top = 0
        Width = 888
        Height = 17
        Align = alTop
        Caption = 'Controlled Substance EPCS Orders'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        ExplicitWidth = 170
      end
      object lblSmartCardNeeded: TStaticText
        Left = 181
        Top = 0
        Width = 135
        Height = 20
        Caption = 'SMART card required'
        Color = clBtnFace
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
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
        Top = 16
        Width = 888
        Height = 148
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
    Width = 894
    Height = 170
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 4
    inline fraCoPay: TfraCoPayDesc
      Left = 201
      Top = 0
      Width = 693
      Height = 170
      Align = alClient
      AutoSize = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitLeft = 201
      ExplicitWidth = 693
      inherited pnlRight: TPanel
        Left = 424
        Width = 269
        AutoSize = True
        ExplicitLeft = 425
        ExplicitWidth = 269
        inherited Spacer2: TLabel
          Width = 269
          Height = 2
          ExplicitWidth = 269
          ExplicitHeight = 2
        end
        inherited lblCaption: TStaticText
          Width = 269
          ExplicitWidth = 269
        end
        inherited ScrollBox1: TScrollBox
          Top = 18
          Width = 269
          Height = 152
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          ExplicitTop = 18
          ExplicitWidth = 269
          ExplicitHeight = 152
          inherited pnlMain: TPanel
            Width = 248
            Height = 163
            ExplicitWidth = 252
            ExplicitHeight = 163
            inherited spacer1: TLabel
              Top = 20
              Width = 249
              Height = 2
              ExplicitLeft = 0
              ExplicitTop = 20
              ExplicitWidth = 249
              ExplicitHeight = 2
            end
            inherited pnlHNC: TPanel
              Top = 128
              Width = 249
              Height = 18
              ExplicitTop = 128
              ExplicitWidth = 249
              ExplicitHeight = 18
              inherited lblHNC2: TVA508StaticText
                Left = 50
                Width = 188
                Height = 18
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 50
                ExplicitWidth = 188
                ExplicitHeight = 18
              end
              inherited lblHNC: TVA508StaticText
                Height = 18
                ExplicitHeight = 18
              end
            end
            inherited pnlMST: TPanel
              Top = 110
              Width = 249
              Height = 18
              ExplicitTop = 110
              ExplicitWidth = 249
              ExplicitHeight = 18
              inherited lblMST2: TVA508StaticText
                Width = 188
                Height = 18
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitWidth = 188
                ExplicitHeight = 18
              end
              inherited lblMST: TVA508StaticText
                Width = 30
                Height = 18
                ExplicitWidth = 30
                ExplicitHeight = 18
              end
            end
            inherited pnlSWAC: TPanel
              Top = 75
              Width = 249
              Height = 18
              ExplicitTop = 75
              ExplicitWidth = 249
              ExplicitHeight = 18
              inherited lblSWAC2: TVA508StaticText
                Width = 188
                Height = 18
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitWidth = 188
                ExplicitHeight = 18
              end
              inherited lblSWAC: TVA508StaticText
                Height = 18
                ExplicitHeight = 18
              end
            end
            inherited pnlIR: TPanel
              Top = 58
              Width = 249
              Height = 17
              ExplicitTop = 58
              ExplicitWidth = 249
              ExplicitHeight = 17
              inherited lblIR2: TVA508StaticText
                Width = 188
                Height = 18
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitWidth = 188
                ExplicitHeight = 18
              end
              inherited lblIR: TVA508StaticText
                Width = 17
                Height = 18
                ExplicitWidth = 17
                ExplicitHeight = 18
              end
            end
            inherited pnlAO: TPanel
              Top = 40
              Width = 249
              Height = 18
              ExplicitTop = 40
              ExplicitWidth = 249
              ExplicitHeight = 18
              inherited lblAO2: TVA508StaticText
                Width = 188
                Height = 18
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitWidth = 188
                ExplicitHeight = 18
              end
              inherited lblAO: TVA508StaticText
                Width = 18
                Height = 18
                ExplicitWidth = 18
                ExplicitHeight = 18
              end
            end
            inherited pnlSC: TPanel
              Top = 0
              Width = 249
              Height = 20
              ExplicitTop = 0
              ExplicitWidth = 249
              ExplicitHeight = 20
              inherited lblSC2: TVA508StaticText
                Width = 188
                Height = 18
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitWidth = 188
                ExplicitHeight = 18
              end
              inherited lblSC: TVA508StaticText
                Width = 26
                Height = 18
                ExplicitWidth = 26
                ExplicitHeight = 18
              end
            end
            inherited pnlCV: TPanel
              Top = 22
              Width = 249
              Height = 18
              ExplicitTop = 22
              ExplicitWidth = 249
              ExplicitHeight = 18
              inherited lblCV2: TVA508StaticText
                Width = 188
                Height = 18
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitWidth = 188
                ExplicitHeight = 18
              end
              inherited lblCV: TVA508StaticText
                Width = 26
                Height = 18
                ExplicitWidth = 26
                ExplicitHeight = 18
              end
            end
            inherited pnlSHD: TPanel
              Top = 93
              Width = 249
              Height = 17
              AutoSize = False
              ExplicitTop = 93
              ExplicitWidth = 249
              ExplicitHeight = 17
              inherited lblSHAD: TVA508StaticText
                Width = 33
                Height = 18
                ExplicitWidth = 33
                ExplicitHeight = 18
              end
              inherited lblSHAD2: TVA508StaticText
                Left = 50
                Width = 188
                Height = 18
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 50
                ExplicitWidth = 188
                ExplicitHeight = 18
              end
            end
            inherited pnlCL: TPanel
              Top = 146
              Width = 249
              Height = 17
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              ExplicitTop = 146
              ExplicitWidth = 249
              ExplicitHeight = 17
              inherited lblCL: TVA508StaticText
                Width = 35
                Height = 18
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                ExplicitWidth = 35
                ExplicitHeight = 18
              end
              inherited lblCL2: TVA508StaticText
                Left = 50
                Width = 188
                Height = 18
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 50
                ExplicitWidth = 188
                ExplicitHeight = 18
              end
            end
          end
        end
      end
      inherited pnlSCandRD: TPanel
        Width = 424
        ExplicitWidth = 424
        inherited lblSCDisplay: TLabel
          Width = 424
          ExplicitWidth = 425
        end
        inherited memSCDisplay: TCaptionMemo
          Width = 424
          ExplicitWidth = 424
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = 0
      Width = 201
      Height = 170
      Align = alLeft
      BevelEdges = []
      BevelOuter = bvNone
      TabOrder = 1
      object lblProvInfo: TLabel
        Left = 8
        Top = 3
        Width = 41
        Height = 13
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
