inherited frmReview: TfrmReview
  Left = 141
  Top = 70
  BorderIcons = [biMaximize]
  Caption = 'Review / Sign Changes'
  ClientHeight = 521
  ClientWidth = 793
  Constraints.MinHeight = 443
  Constraints.MinWidth = 684
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHelp = nil
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 1009
  ExplicitHeight = 696
  PixelsPerInch = 96
  TextHeight = 13
  object laDiagnosis: TLabel [0]
    Left = 252
    Top = 133
    Width = 46
    Height = 13
    Caption = 'Diagnosis'
    Visible = False
  end
  object gbxDxLookup: TGroupBox [1]
    Left = 549
    Top = 24
    Width = 99
    Height = 42
    Caption = 'Lookup Diagnosis'
    TabOrder = 0
    TabStop = True
    Visible = False
    object buDiagnosis: TButton
      Left = 10
      Top = 14
      Width = 81
      Height = 21
      Caption = '&Diagnosis'
      Enabled = False
      TabOrder = 0
      OnClick = buDiagnosisClick
    end
  end
  object pnlCombined: TORAutoPanel [2]
    Left = 0
    Top = 190
    Width = 793
    Height = 204
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object pnlReview: TPanel
      Left = 0
      Top = 0
      Width = 793
      Height = 126
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        793
        126)
      object lstReview: TCaptionCheckListBox
        Left = 4
        Top = 30
        Width = 790
        Height = 96
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
      end
      object lblSig: TStaticText
        Left = 8
        Top = 8
        Width = 254
        Height = 17
        Caption = 'All Orders Except Controlled Substance EPCS Orders'
        TabOrder = 2
        TabStop = True
      end
    end
    object pnlCSReview: TPanel
      Left = 0
      Top = 126
      Width = 793
      Height = 78
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitHeight = 77
      DesignSize = (
        793
        78)
      object lblCSReview: TLabel
        Left = 5
        Top = 7
        Width = 166
        Height = 13
        Caption = 'Controlled Substance EPCS Orders'
      end
      object lstCSReview: TCaptionCheckListBox
        Left = 2
        Top = 26
        Width = 792
        Height = 52
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
        Caption = ''
      end
      object lblSmartCardNeeded: TStaticText
        Left = 180
        Top = 5
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
        Transparent = False
      end
    end
  end
  object pnlBottom: TPanel [3]
    Left = 0
    Top = 434
    Width = 793
    Height = 87
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      793
      87)
    object pnlSignature: TPanel
      Left = 8
      Top = 40
      Width = 150
      Height = 42
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
        Width = 135
        Height = 24
        PasswordChar = '*'
        TabOrder = 0
        OnChange = txtESCodeChange
        Caption = 'Electronic Signature Code'
      end
    end
    object pnlOrderAction: TPanel
      Left = 149
      Top = 21
      Width = 367
      Height = 64
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
        Width = 99
        Height = 17
        Caption = '&Signed on Chart'
        TabOrder = 0
        OnClick = radReleaseClick
      end
      object radHoldSign: TRadioButton
        Left = 0
        Top = 35
        Width = 99
        Height = 17
        Caption = '&Hold until Signed'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = radReleaseClick
      end
      object grpRelease: TGroupBox
        Left = 118
        Top = 16
        Width = 237
        Height = 41
        TabOrder = 3
        Visible = False
        object radVerbal: TRadioButton
          Left = 8
          Top = 18
          Width = 52
          Height = 17
          Caption = '&Verbal'
          Enabled = False
          TabOrder = 0
        end
        object radPhone: TRadioButton
          Left = 78
          Top = 18
          Width = 76
          Height = 17
          Caption = '&Telephone'
          Enabled = False
          TabOrder = 1
        end
        object radPolicy: TRadioButton
          Left = 166
          Top = 18
          Width = 48
          Height = 17
          Caption = '&Policy'
          Enabled = False
          TabOrder = 2
        end
      end
      object radRelease: TRadioButton
        Left = 126
        Top = 16
        Width = 112
        Height = 17
        Caption = '&Release to Service'
        TabOrder = 2
        Visible = False
        OnClick = radReleaseClick
      end
    end
    object cmdOK: TButton
      Left = 634
      Top = 54
      Width = 71
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 711
      Top = 54
      Width = 71
      Height = 21
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
    object lblHoldSign: TStaticText
      Left = 176
      Top = 2
      Width = 288
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'These orders can only be signed by the prescribing provider.'
      TabOrder = 4
      Visible = False
    end
  end
  object pnlDEAText: TPanel [4]
    Left = 0
    Top = 394
    Width = 793
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblDEAText: TStaticText
      Left = 0
      Top = 0
      Width = 1574
      Height = 17
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
    end
  end
  object pnlTop: TPanel [5]
    Left = 0
    Top = 0
    Width = 793
    Height = 190
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    inline fraCoPay: TfraCoPayDesc
      Left = 318
      Top = 0
      Width = 475
      Height = 190
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitLeft = 318
      ExplicitWidth = 475
      ExplicitHeight = 190
      inherited pnlRight: TPanel
        Left = 213
        Width = 262
        Height = 190
        AutoSize = True
        ExplicitLeft = 213
        ExplicitWidth = 262
        ExplicitHeight = 190
        inherited Spacer2: TLabel
          Width = 262
          Height = 2
          ExplicitWidth = 262
          ExplicitHeight = 2
        end
        inherited lblCaption: TStaticText
          Width = 262
          Caption = 'Patient Orders Related To:'
          ExplicitWidth = 262
        end
        inherited ScrollBox1: TScrollBox
          Top = 18
          Width = 262
          Height = 172
          AutoSize = True
          ExplicitTop = 18
          ExplicitWidth = 262
          ExplicitHeight = 172
          inherited pnlMain: TPanel
            Width = 258
            Height = 164
            ExplicitWidth = 258
            ExplicitHeight = 164
            inherited spacer1: TLabel
              Top = 18
              Width = 258
              ExplicitLeft = 0
              ExplicitTop = 18
              ExplicitWidth = 258
            end
            inherited pnlHNC: TPanel
              Top = 111
              Width = 258
              Height = 18
              ExplicitTop = 111
              ExplicitWidth = 258
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
              Top = 94
              Width = 258
              Height = 17
              ExplicitTop = 94
              ExplicitWidth = 258
              ExplicitHeight = 17
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
              Top = 76
              Width = 258
              Height = 18
              ExplicitTop = 76
              ExplicitWidth = 258
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
              Width = 258
              Height = 18
              ExplicitTop = 58
              ExplicitWidth = 258
              ExplicitHeight = 18
              inherited lblIR2: TVA508StaticText
                Width = 188
                Height = 18
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitWidth = 188
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
              Width = 258
              Height = 18
              ExplicitWidth = 258
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
              Top = 21
              Width = 258
              Height = 20
              ExplicitTop = 21
              ExplicitWidth = 258
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
              Top = 41
              Width = 258
              Height = 17
              ExplicitTop = 41
              ExplicitWidth = 258
              ExplicitHeight = 17
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
              Top = 129
              Width = 258
              Height = 17
              ExplicitTop = 129
              ExplicitWidth = 258
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
              Width = 258
              Height = 18
              ExplicitTop = 146
              ExplicitWidth = 258
              ExplicitHeight = 18
              inherited lblCL: TVA508StaticText
                Width = 25
                Height = 18
                ExplicitWidth = 25
                ExplicitHeight = 18
              end
              inherited lblCL2: TVA508StaticText
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
          end
        end
      end
      inherited pnlSCandRD: TPanel
        Width = 213
        Height = 190
        ExplicitWidth = 213
        ExplicitHeight = 190
        inherited lblSCDisplay: TLabel
          Width = 213
          Height = 16
          ExplicitWidth = 213
          ExplicitHeight = 16
        end
        inherited memSCDisplay: TCaptionMemo
          Top = 16
          Width = 213
          Height = 174
          ExplicitTop = 16
          ExplicitWidth = 213
          ExplicitHeight = 174
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = 0
      Width = 318
      Height = 190
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
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
