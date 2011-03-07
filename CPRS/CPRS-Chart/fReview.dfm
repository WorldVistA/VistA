inherited frmReview: TfrmReview
  Left = 141
  Top = 70
  BorderIcons = [biMaximize]
  Caption = 'Review / Sign Changes'
  ClientHeight = 522
  ClientWidth = 705
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 713
  ExplicitHeight = 556
  DesignSize = (
    705
    522)
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
  object pnlSignature: TPanel [1]
    Left = 8
    Top = 452
    Width = 373
    Height = 65
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
  object pnlOrderAction: TPanel [2]
    Left = 2
    Top = 454
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
  object cmdOK: TButton [3]
    Left = 545
    Top = 496
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [4]
    Left = 625
    Top = 496
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cmdCancelClick
  end
  object lstReview: TCaptionCheckListBox [5]
    Left = 0
    Top = 177
    Width = 690
    Height = 275
    OnClickCheck = lstReviewClickCheck
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 15
    ParentShowHint = False
    PopupMenu = poBACopyPaste
    ShowHint = True
    Style = lbOwnerDrawVariable
    TabOrder = 6
    OnClick = lstReviewClick
    OnDrawItem = lstReviewDrawItem
    OnKeyUp = lstReviewKeyUp
    OnMeasureItem = lstReviewMeasureItem
    OnMouseDown = lstReviewMouseDown
    OnMouseMove = lstReviewMouseMove
    Caption = 'Signature will be Applied to Checked Items'
  end
  inline fraCoPay: TfraCoPayDesc [6]
    Left = 6
    Top = 1
    Width = 602
    Height = 152
    Anchors = [akLeft, akTop, akRight]
    AutoSize = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    TabStop = True
    Visible = False
    ExplicitLeft = 6
    ExplicitTop = 1
    ExplicitWidth = 602
    ExplicitHeight = 152
    inherited pnlRight: TPanel
      Left = 336
      Width = 266
      Height = 152
      AutoSize = True
      ExplicitLeft = 336
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
        Left = 24
        Top = 12
        Width = 233
        Height = 132
        ExplicitLeft = 24
        ExplicitTop = 12
        ExplicitWidth = 233
        ExplicitHeight = 132
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
      Width = 336
      Height = 152
      ExplicitWidth = 336
      ExplicitHeight = 152
      inherited lblSCDisplay: TLabel
        Width = 336
        ExplicitWidth = 336
      end
      inherited memSCDisplay: TCaptionMemo
        Width = 336
        Height = 135
        ExplicitWidth = 336
        ExplicitHeight = 135
      end
    end
  end
  object lblSig: TStaticText
    Left = 8
    Top = 160
    Width = 205
    Height = 17
    Caption = 'Signature will be Applied to Checked Items'
    TabOrder = 5
    TabStop = True
  end
  object gbxDxLookup: TGroupBox
    Left = 8
    Top = 156
    Width = 101
    Height = 43
    Caption = 'Lookup Diagnosis'
    TabOrder = 8
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
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
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
        'Component = lstReview'
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
        'Component = lblSig'
        'Status = stsDefault')
      (
        'Component = gbxDxLookup'
        'Status = stsDefault')
      (
        'Component = buDiagnosis'
        'Status = stsDefault')
      (
        'Component = frmReview'
        'Status = stsDefault'))
  end
  object poBACopyPaste: TPopupMenu
    Left = 384
    Top = 280
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
