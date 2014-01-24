inherited frmSignOrders: TfrmSignOrders
  Left = 337
  Top = 142
  Caption = 'Sign Orders'
  ClientHeight = 499
  ClientWidth = 692
  Constraints.MinHeight = 450
  Constraints.MinWidth = 700
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = clstOrdersMouseDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 700
  ExplicitHeight = 533
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
  object gbdxLookup: TGroupBox [1]
    Left = 54
    Top = 108
    Width = 99
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
      Width = 86
      Height = 21
      Caption = '&Diagnosis'
      Enabled = False
      TabOrder = 0
      OnClick = buOrdersDiagnosisClick
    end
  end
  object pnlDEAText: TPanel [2]
    Left = 0
    Top = 408
    Width = 692
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 401
    ExplicitWidth = 723
    object lblDEAText: TStaticText
      Left = 0
      Top = 0
      Width = 692
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
      ExplicitWidth = 723
    end
  end
  object pnlEsig: TPanel [3]
    Left = 0
    Top = 451
    Width = 692
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 444
    ExplicitWidth = 723
    DesignSize = (
      692
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
      ExplicitLeft = 559
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
      ExplicitLeft = 641
    end
  end
  object pnlCombined: TORAutoPanel [4]
    Left = 0
    Top = 163
    Width = 692
    Height = 245
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitWidth = 723
    ExplicitHeight = 238
    DesignSize = (
      692
      245)
    object pnlCSOrderList: TPanel
      Left = 2
      Top = 112
      Width = 717
      Height = 219
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        717
        219)
      object lblCSOrderList: TStaticText
        Left = 9
        Top = 20
        Width = 139
        Height = 17
        Caption = 'Controlled Substance Orders'
        TabOrder = 0
      end
      object lblSmartCardNeeded: TStaticText
        Left = 154
        Top = 19
        Width = 135
        Height = 20
        Caption = 'SMART card required'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object clstCSOrders: TCaptionCheckListBox
        Left = 4
        Top = 38
        Width = 714
        Height = 179
        OnClickCheck = clstCSOrdersClickCheck
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 16
        PopupMenu = poBACopyPaste
        Style = lbOwnerDrawVariable
        TabOrder = 2
        OnClick = clstCSOrdersClick
        OnDrawItem = clstCSOrdersDrawItem
        OnMeasureItem = clstCSOrdersMeasureItem
        Caption = 'The following orders will be signed -'
      end
    end
    object pnlOrderList: TPanel
      Left = 1
      Top = 0
      Width = 688
      Height = 118
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 719
      DesignSize = (
        688
        118)
      object lblOrderList: TStaticText
        Left = 10
        Top = 6
        Width = 223
        Height = 17
        Caption = 'All Orders Except Controlled Susbtance Orders'
        TabOrder = 0
      end
      object clstOrders: TCaptionCheckListBox
        Left = 6
        Top = 23
        Width = 681
        Height = 91
        OnClickCheck = clstOrdersClickCheck
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 16
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
        ExplicitWidth = 712
      end
    end
  end
  object pnlTop: TPanel [5]
    Left = 0
    Top = 0
    Width = 692
    Height = 163
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitWidth = 723
    DesignSize = (
      692
      163)
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
      ExplicitWidth = 723
      inherited pnlRight: TPanel
        Left = 419
        Width = 273
        ExplicitLeft = 450
        ExplicitWidth = 273
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
        inherited pnlMain: TPanel
          Left = 6
          Top = 17
          ExplicitLeft = 6
          ExplicitTop = 17
          inherited spacer1: TLabel
            Top = 17
            ExplicitTop = 17
            ExplicitWidth = 262
          end
          inherited pnlHNC: TPanel
            inherited lblHNC2: TVA508StaticText
              Width = 129
              Height = 18
              ExplicitWidth = 129
              ExplicitHeight = 18
            end
            inherited lblHNC: TVA508StaticText
              Width = 31
              Height = 18
              ExplicitWidth = 31
              ExplicitHeight = 18
            end
          end
          inherited pnlMST: TPanel
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
            inherited lblIR2: TVA508StaticText
              Width = 133
              Height = 18
              ExplicitWidth = 133
              ExplicitHeight = 18
            end
            inherited lblIR: TVA508StaticText
              Width = 16
              Height = 18
              ExplicitWidth = 16
              ExplicitHeight = 18
            end
          end
          inherited pnlAO: TPanel
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
            Top = 2
            ExplicitTop = 2
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
        end
      end
      inherited pnlSCandRD: TPanel
        Width = 419
        ExplicitWidth = 450
        inherited lblSCDisplay: TLabel
          Left = 184
          Top = -2
          Width = 406
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 184
          ExplicitTop = -2
          ExplicitWidth = 406
        end
        inherited memSCDisplay: TCaptionMemo
          Left = 184
          Width = 234
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 215
          ExplicitWidth = 234
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
      ExplicitWidth = 204
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
    Left = 712
    Top = 88
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
