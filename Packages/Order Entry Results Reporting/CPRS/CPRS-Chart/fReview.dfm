inherited frmReview: TfrmReview
  Left = 141
  Top = 70
  BorderIcons = [biMaximize]
  Caption = 'Review / Sign Changes'
  ClientHeight = 529
  ClientWidth = 687
  Constraints.MinHeight = 450
  Constraints.MinWidth = 695
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 695
  ExplicitHeight = 563
  PixelsPerInch = 96
  TextHeight = 13
  object laDiagnosis: TLabel [0]
    Left = 256
    Top = 135
    Width = 46
    Height = 13
    Caption = 'Diagnosis'
    Visible = False
  end
  object gbxDxLookup: TGroupBox [1]
    Left = 557
    Top = 24
    Width = 101
    Height = 43
    Caption = 'Lookup Diagnosis'
    TabOrder = 0
    TabStop = True
    Visible = False
    object buDiagnosis: TButton
      Left = 10
      Top = 15
      Width = 83
      Height = 21
      Caption = '&Diagnosis'
      Enabled = False
      TabOrder = 0
      OnClick = buDiagnosisClick
    end
  end
  object pnlCombined: TORAutoPanel [2]
    Left = 0
    Top = 149
    Width = 687
    Height = 251
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitWidth = 707
    ExplicitHeight = 238
    object pnlReview: TPanel
      Left = 0
      Top = -2
      Width = 680
      Height = 128
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        680
        128)
      object lstReview: TCaptionCheckListBox
        Left = 4
        Top = 31
        Width = 677
        Height = 97
        OnClickCheck = lstReviewClickCheck
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 15
        ParentShowHint = False
        PopupMenu = poBACopyPaste
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 0
        OnClick = lstReviewClick
        OnDrawItem = lstReviewDrawItem
        OnKeyUp = lstReviewKeyUp
        OnMeasureItem = lstReviewMeasureItem
        OnMouseDown = lstReviewMouseDown
        OnMouseMove = lstReviewMouseMove
        Caption = 'Signature will be Applied to Checked Items'
        ExplicitHeight = 99
      end
      object lblSig: TStaticText
        Left = 8
        Top = 8
        Width = 223
        Height = 17
        Caption = 'All Orders Except Controlled Substance Orders'
        TabOrder = 2
        TabStop = True
      end
    end
    object pnlCSReview: TPanel
      Left = 1
      Top = 128
      Width = 680
      Height = 108
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        680
        108)
      object lblCSReview: TLabel
        Left = 5
        Top = 7
        Width = 135
        Height = 13
        Caption = 'Controlled Substance Orders'
      end
      object lstCSReview: TCaptionCheckListBox
        Left = 2
        Top = 26
        Width = 680
        Height = 82
        OnClickCheck = lstCSReviewClickCheck
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 0
        OnClick = lstCSReviewClick
        OnDrawItem = lstCSReviewDrawItem
        OnKeyUp = lstCSReviewKeyUp
        OnMeasureItem = lstCSReviewMeasureItem
        OnMouseDown = lstCSReviewMouseDown
        OnMouseMove = lstCSReviewMouseMove
      end
      object lblSmartCardNeeded: TStaticText
        Left = 146
        Top = 4
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
    end
  end
  object pnlBottom: TPanel [3]
    Left = 0
    Top = 440
    Width = 687
    Height = 89
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 427
    ExplicitWidth = 707
    DesignSize = (
      687
      89)
    object pnlSignature: TPanel
      Left = 8
      Top = 41
      Width = 152
      Height = 43
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      TabOrder = 0
      object lblESCode: TLabel
        Left = 0
        Top = 0
        Width = 123
        Height = 13
        Caption = 'Electronic Signature Code'
      end
      object txtESCode: TCaptionEdit
        Left = 0
        Top = 14
        Width = 137
        Height = 21
        PasswordChar = '*'
        TabOrder = 0
        OnChange = txtESCodeChange
        Caption = 'Electronic Signature Code'
      end
    end
    object pnlOrderAction: TPanel
      Left = 151
      Top = 21
      Width = 373
      Height = 65
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object Label1: TStaticText
        Left = 0
        Top = 0
        Width = 111
        Height = 17
        Caption = 'For orders, select from:'
        TabOrder = 4
      end
      object radSignChart: TRadioButton
        Left = 0
        Top = 16
        Width = 101
        Height = 17
        Caption = '&Signed on Chart'
        TabOrder = 0
        OnClick = radReleaseClick
      end
      object radHoldSign: TRadioButton
        Left = 0
        Top = 36
        Width = 101
        Height = 17
        Caption = '&Hold until Signed'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = radReleaseClick
      end
      object grpRelease: TGroupBox
        Left = 120
        Top = 16
        Width = 241
        Height = 42
        TabOrder = 3
        Visible = False
        object radVerbal: TRadioButton
          Left = 8
          Top = 19
          Width = 53
          Height = 17
          Caption = '&Verbal'
          Enabled = False
          TabOrder = 0
        end
        object radPhone: TRadioButton
          Left = 80
          Top = 19
          Width = 77
          Height = 17
          Caption = '&Telephone'
          Enabled = False
          TabOrder = 1
        end
        object radPolicy: TRadioButton
          Left = 168
          Top = 19
          Width = 49
          Height = 17
          Caption = '&Policy'
          Enabled = False
          TabOrder = 2
        end
      end
      object radRelease: TRadioButton
        Left = 128
        Top = 16
        Width = 113
        Height = 17
        Caption = '&Release to Service'
        TabOrder = 2
        Visible = False
        OnClick = radReleaseClick
      end
    end
    object cmdOK: TButton
      Left = 526
      Top = 55
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
      ExplicitLeft = 546
    end
    object cmdCancel: TButton
      Left = 604
      Top = 55
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
      ExplicitLeft = 624
    end
    object lblHoldSign: TStaticText
      Left = 179
      Top = 2
      Width = 268
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'These orders can only be signed by the prescribing provider.'
      TabOrder = 4
      Visible = False
      ExplicitWidth = 288
    end
  end
  object pnlDEAText: TPanel [4]
    Left = 0
    Top = 400
    Width = 687
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 387
    ExplicitWidth = 707
    object lblDEAText: TStaticText
      Left = 0
      Top = 0
      Width = 687
      Height = 40
      Align = alClient
      Anchors = [akLeft, akTop, akRight]
      Caption = 
        'By completing the two-factor authentication protocol at this tim' +
        'e, you are legally signing the prescription(s) and authorizing t' +
        'he transmission of the above informationto the pharmacy for disp' +
        'ensing.  The two-factor authentication protocol may only be comp' +
        'leted by the practitioner whose name and DEA registration number' +
        ' appear above. '
      TabOrder = 0
      ExplicitWidth = 707
    end
  end
  object pnlTop: TPanel [5]
    Left = 0
    Top = 0
    Width = 687
    Height = 149
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitWidth = 707
    DesignSize = (
      687
      149)
    inline fraCoPay: TfraCoPayDesc
      Left = 163
      Top = -1
      Width = 524
      Height = 152
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitLeft = 183
      ExplicitTop = -1
      ExplicitWidth = 524
      ExplicitHeight = 152
      inherited pnlRight: TPanel
        Left = 258
        Width = 266
        Height = 152
        AutoSize = True
        ExplicitLeft = 258
        ExplicitWidth = 266
        ExplicitHeight = 152
        inherited Spacer2: TLabel
          Width = 266
          ExplicitWidth = 266
        end
        inherited lblCaption: TStaticText
          Width = 266
          Caption = 'Patient Orders Related To:'
          ExplicitWidth = 266
        end
        inherited pnlMain: TPanel
          Left = 29
          Top = 11
          Width = 233
          Height = 131
          ExplicitLeft = 29
          ExplicitTop = 11
          ExplicitWidth = 233
          ExplicitHeight = 131
          inherited spacer1: TLabel
            Width = 229
            ExplicitWidth = 229
          end
          inherited pnlHNC: TPanel
            Width = 229
            ExplicitWidth = 229
            inherited lblHNC2: TVA508StaticText
              Width = 129
              ExplicitWidth = 129
            end
            inherited lblHNC: TVA508StaticText
              Width = 31
              ExplicitWidth = 31
            end
          end
          inherited pnlMST: TPanel
            Width = 229
            ExplicitWidth = 229
            inherited lblMST2: TVA508StaticText
              Width = 25
              ExplicitWidth = 25
            end
            inherited lblMST: TVA508StaticText
              Width = 31
              ExplicitWidth = 31
            end
          end
          inherited pnlSWAC: TPanel
            Width = 229
            ExplicitWidth = 229
            inherited lblSWAC2: TVA508StaticText
              Width = 127
              ExplicitWidth = 127
            end
            inherited lblSWAC: TVA508StaticText
              Width = 40
              ExplicitWidth = 40
            end
          end
          inherited pnlIR: TPanel
            Width = 229
            ExplicitWidth = 229
            inherited lblIR2: TVA508StaticText
              Width = 133
              ExplicitWidth = 133
            end
            inherited lblIR: TVA508StaticText
              Width = 19
              ExplicitWidth = 19
            end
          end
          inherited pnlAO: TPanel
            Width = 229
            ExplicitWidth = 229
            inherited lblAO2: TVA508StaticText
              Width = 115
              ExplicitWidth = 115
            end
            inherited lblAO: TVA508StaticText
              Width = 23
              ExplicitWidth = 23
            end
          end
          inherited pnlSC: TPanel
            Width = 229
            ExplicitWidth = 229
          end
          inherited pnlCV: TPanel
            Width = 229
            ExplicitWidth = 229
            inherited lblCV2: TVA508StaticText
              Width = 142
              ExplicitWidth = 142
            end
          end
          inherited pnlSHD: TPanel
            Width = 229
            ExplicitWidth = 229
            inherited lblSHAD: TVA508StaticText
              Width = 33
              ExplicitWidth = 33
            end
            inherited lblSHAD2: TVA508StaticText
              Width = 159
              ExplicitWidth = 159
            end
          end
        end
      end
      inherited pnlSCandRD: TPanel
        Left = -1
        Width = 282
        Height = 152
        Align = alNone
        Anchors = [akLeft, akTop, akRight]
        ExplicitLeft = -1
        ExplicitWidth = 282
        ExplicitHeight = 152
        inherited lblSCDisplay: TLabel
          Left = 48
          Top = -2
          Width = 240
          Height = 16
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 48
          ExplicitTop = -2
          ExplicitWidth = 240
          ExplicitHeight = 16
        end
        inherited memSCDisplay: TCaptionMemo
          Left = 48
          Top = 11
          Width = 234
          Height = 131
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 48
          ExplicitTop = 11
          ExplicitWidth = 234
          ExplicitHeight = 131
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = -1
      Width = 205
      Height = 152
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 225
      object lblProvInfo: TLabel
        Left = 8
        Top = 3
        Width = 50
        Height = 13
        Caption = 'lblProvInfo'
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 648
    Top = 80
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
        'Component = gbxDxLookup'
        'Status = stsDefault')
      (
        'Component = buDiagnosis'
        'Status = stsDefault')
      (
        'Component = frmReview'
        'Status = stsDefault')
      (
        'Component = pnlProvInfo'
        'Status = stsDefault')
      (
        'Component = pnlDEAText'
        'Status = stsDefault')
      (
        'Component = lblDEAText'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlSignature'
        'Status = stsDefault')
      (
        'Component = txtESCode'
        'Status = stsDefault')
      (
        'Component = pnlOrderAction'
        'Status = stsDefault')
      (
        'Component = Label1'
        'Status = stsDefault')
      (
        'Component = radSignChart'
        'Status = stsDefault')
      (
        'Component = radHoldSign'
        'Status = stsDefault')
      (
        'Component = grpRelease'
        'Status = stsDefault')
      (
        'Component = radVerbal'
        'Status = stsDefault')
      (
        'Component = radPhone'
        'Status = stsDefault')
      (
        'Component = radPolicy'
        'Status = stsDefault')
      (
        'Component = radRelease'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = lblHoldSign'
        'Status = stsDefault')
      (
        'Component = pnlCombined'
        'Status = stsDefault')
      (
        'Component = pnlReview'
        'Status = stsDefault')
      (
        'Component = lstReview'
        'Status = stsDefault')
      (
        'Component = lblSig'
        'Status = stsDefault')
      (
        'Component = pnlCSReview'
        'Status = stsDefault')
      (
        'Component = lstCSReview'
        'Status = stsDefault')
      (
        'Component = lblSmartCardNeeded'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault'))
  end
  object poBACopyPaste: TPopupMenu
    Left = 576
    Top = 80
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
      OnClick = buDiagnosisClick
    end
    object Exit1: TMenuItem
      Caption = '&Exit'
      ShortCut = 16453
      OnClick = Exit1Click
    end
  end
end
