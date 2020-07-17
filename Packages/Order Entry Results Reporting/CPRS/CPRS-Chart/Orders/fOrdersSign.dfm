inherited frmSignOrders: TfrmSignOrders
  Left = 337
  Top = 142
  Caption = 'Sign Orders'
  ClientHeight = 522
  ClientWidth = 692
  Constraints.MinHeight = 450
  Constraints.MinWidth = 700
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHelp = nil
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 708
  ExplicitHeight = 561
  PixelsPerInch = 96
  TextHeight = 13
  object laDiagnosis: TLabel [0]
    Left = 184
    Top = 185
    Width = 46
    Height = 13
    Caption = 'Diagnosis'
    Visible = False
  end
  object pnlDEAText: TPanel [1]
    AlignWithMargins = True
    Left = 3
    Top = 429
    Width = 686
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    object lblDEAText: TStaticText
      Left = 0
      Top = 0
      Width = 686
      Height = 43
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
  object pnlEsig: TPanel [2]
    Left = 0
    Top = 475
    Width = 692
    Height = 47
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    DesignSize = (
      692
      47)
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
      Width = 137
      Height = 21
      Anchors = [akLeft]
      PasswordChar = '*'
      TabOrder = 0
      Caption = 'Electronic Signature Code'
    end
    object cmdOK: TButton
      Left = 528
      Top = 19
      Width = 72
      Height = 21
      Anchors = [akRight]
      Caption = 'Sign'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 610
      Top = 19
      Width = 72
      Height = 21
      Anchors = [akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
  end
  object pnlCombined: TORAutoPanel [3]
    Left = 0
    Top = 170
    Width = 692
    Height = 256
    Align = alClient
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    object pnlCSOrderList: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 127
      Width = 686
      Height = 126
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblCSOrderList: TStaticText
        Left = 0
        Top = 0
        Width = 686
        Height = 17
        Align = alTop
        Caption = 'Controlled Substance EPCS Orders'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
      end
      object lblSmartCardNeeded: TStaticText
        Left = 184
        Top = -1
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
        Top = 17
        Width = 686
        Height = 109
        OnClickCheck = clstOrdersClickCheck
        Align = alClient
        DoubleBuffered = True
        ParentDoubleBuffered = False
        Style = lbOwnerDrawVariable
        TabOrder = 2
        OnDrawItem = clstOrdersDrawItem
        OnKeyUp = clstOrdersKeyUp
        OnMeasureItem = clstOrdersMeasureItem
        OnMouseMove = clstOrdersMouseMove
        Caption = 'The following orders will be signed -'
      end
    end
    object pnlOrderList: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 686
      Height = 118
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object lblOrderList: TStaticText
        Left = 0
        Top = 0
        Width = 686
        Height = 17
        Align = alTop
        Caption = 'All Orders Except Controlled Substance EPCS Orders'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
      end
      object clstOrders: TCaptionCheckListBox
        Left = 0
        Top = 17
        Width = 686
        Height = 101
        OnClickCheck = clstOrdersClickCheck
        Align = alClient
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 1
        OnDrawItem = clstOrdersDrawItem
        OnKeyUp = clstOrdersKeyUp
        OnMeasureItem = clstOrdersMeasureItem
        OnMouseMove = clstOrdersMouseMove
        Caption = 'The following orders will be signed -'
      end
    end
  end
  object pnlTop: TPanel [4]
    Left = 0
    Top = 0
    Width = 692
    Height = 170
    Align = alTop
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    DesignSize = (
      692
      170)
    inline fraCoPay: TfraCoPayDesc
      Left = 0
      Top = 0
      Width = 692
      Height = 157
      Align = alTop
      AutoSize = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitWidth = 692
      ExplicitHeight = 157
      inherited pnlRight: TPanel
        Left = 419
        Width = 273
        Height = 157
        ExplicitLeft = 419
        ExplicitWidth = 273
        ExplicitHeight = 157
        inherited Spacer2: TLabel
          Top = 0
          Width = 273
          ExplicitTop = 0
          ExplicitWidth = 273
        end
        inherited lblCaption: TStaticText
          Left = 16
          Width = 241
          Align = alNone
          ExplicitLeft = 16
          ExplicitWidth = 241
        end
        inherited ScrollBox1: TScrollBox
          Top = 3
          Width = 273
          Height = 154
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          ExplicitTop = 3
          ExplicitWidth = 273
          ExplicitHeight = 154
          inherited pnlMain: TPanel
            Width = 252
            Height = 168
            ExplicitWidth = 252
            ExplicitHeight = 168
            inherited spacer1: TLabel
              Top = 20
              Width = 252
              Height = 4
              ExplicitLeft = 0
              ExplicitTop = 20
              ExplicitWidth = 253
              ExplicitHeight = 4
            end
            inherited pnlHNC: TPanel
              Top = 150
              Width = 252
              Height = 18
              ExplicitTop = 150
              ExplicitWidth = 252
              ExplicitHeight = 18
              inherited lblHNC2: TVA508StaticText
                Left = 50
                Width = 129
                Height = 18
                ExplicitLeft = 50
                ExplicitWidth = 129
                ExplicitHeight = 18
              end
              inherited lblHNC: TVA508StaticText
                Left = 12
                Width = 31
                Height = 18
                ExplicitLeft = 12
                ExplicitWidth = 31
                ExplicitHeight = 18
              end
            end
            inherited pnlMST: TPanel
              Top = 114
              Width = 252
              Height = 18
              ExplicitTop = 114
              ExplicitWidth = 252
              ExplicitHeight = 18
              inherited lblMST2: TVA508StaticText
                Width = 25
                Height = 18
                ExplicitWidth = 25
                ExplicitHeight = 18
              end
              inherited lblMST: TVA508StaticText
                Width = 31
                Height = 18
                ExplicitWidth = 31
                ExplicitHeight = 18
              end
            end
            inherited pnlSWAC: TPanel
              Top = 78
              Width = 252
              Height = 18
              ExplicitTop = 78
              ExplicitWidth = 252
              ExplicitHeight = 18
              inherited lblSWAC2: TVA508StaticText
                Width = 127
                Height = 18
                ExplicitWidth = 127
                ExplicitHeight = 18
              end
              inherited lblSWAC: TVA508StaticText
                Width = 40
                Height = 18
                ExplicitWidth = 40
                ExplicitHeight = 18
              end
            end
            inherited pnlIR: TPanel
              Top = 60
              Width = 252
              Height = 18
              ExplicitTop = 60
              ExplicitWidth = 252
              ExplicitHeight = 18
              inherited lblIR2: TVA508StaticText
                Width = 133
                Height = 18
                ExplicitWidth = 133
                ExplicitHeight = 18
              end
              inherited lblIR: TVA508StaticText
                Width = 15
                Height = 18
                ExplicitWidth = 15
                ExplicitHeight = 18
              end
            end
            inherited pnlAO: TPanel
              Top = 42
              Width = 252
              Height = 18
              ExplicitTop = 42
              ExplicitWidth = 252
              ExplicitHeight = 18
              inherited lblAO2: TVA508StaticText
                Width = 115
                Height = 18
                ExplicitWidth = 115
                ExplicitHeight = 18
              end
              inherited lblAO: TVA508StaticText
                Width = 19
                Height = 18
                ExplicitWidth = 19
                ExplicitHeight = 18
              end
            end
            inherited pnlSC: TPanel
              Top = 0
              Width = 252
              Height = 20
              ExplicitTop = 0
              ExplicitWidth = 252
              ExplicitHeight = 20
              inherited lblSC2: TVA508StaticText
                Width = 175
                Height = 18
                ExplicitWidth = 175
                ExplicitHeight = 18
              end
              inherited lblSC: TVA508StaticText
                Width = 27
                Height = 18
                ExplicitWidth = 27
                ExplicitHeight = 18
              end
            end
            inherited pnlCV: TPanel
              Top = 24
              Width = 252
              Height = 18
              ExplicitTop = 24
              ExplicitWidth = 252
              ExplicitHeight = 18
              inherited lblCV2: TVA508StaticText
                Width = 116
                Height = 18
                ExplicitWidth = 116
                ExplicitHeight = 18
              end
              inherited lblCV: TVA508StaticText
                Width = 27
                Height = 18
                ExplicitWidth = 27
                ExplicitHeight = 18
              end
            end
            inherited pnlSHD: TPanel
              Top = 96
              Width = 252
              Height = 18
              ExplicitTop = 96
              ExplicitWidth = 252
              ExplicitHeight = 18
              inherited lblSHAD: TVA508StaticText
                Width = 33
                Height = 18
                ExplicitWidth = 33
                ExplicitHeight = 18
              end
              inherited lblSHAD2: TVA508StaticText
                Width = 159
                Height = 18
                ExplicitWidth = 159
                ExplicitHeight = 18
              end
            end
            inherited pnlCL: TPanel
              Top = 132
              Width = 252
              Height = 18
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              ExplicitTop = 132
              ExplicitWidth = 252
              ExplicitHeight = 18
              inherited lblCL: TVA508StaticText
                Left = 17
                Width = 17
                Height = 18
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                ExplicitLeft = 17
                ExplicitWidth = 17
                ExplicitHeight = 18
              end
              inherited lblCL2: TVA508StaticText
                Left = 41
                Width = 72
                Height = 18
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                ExplicitLeft = 41
                ExplicitWidth = 72
                ExplicitHeight = 18
              end
            end
          end
        end
      end
      inherited pnlSCandRD: TPanel
        Width = 419
        Height = 157
        ExplicitWidth = 419
        ExplicitHeight = 157
        inherited lblSCDisplay: TLabel
          Left = 180
          Top = -2
          Width = 406
          Height = 16
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 180
          ExplicitTop = -2
          ExplicitWidth = 406
          ExplicitHeight = 16
        end
        inherited memSCDisplay: TCaptionMemo
          Left = 184
          Width = 234
          Height = 140
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 184
          ExplicitWidth = 234
          ExplicitHeight = 140
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = 0
      Width = 173
      Height = 151
      Anchors = [akLeft, akTop, akRight]
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
end
