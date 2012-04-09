inherited frmSignOrders: TfrmSignOrders
  Left = 337
  Top = 142
  Caption = 'Sign Orders'
  ClientHeight = 487
  ClientWidth = 833
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = clstOrdersMouseDown
  OnMouseMove = FormMouseMove
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 841
  ExplicitHeight = 521
  DesignSize = (
    833
    487)
  PixelsPerInch = 96
  TextHeight = 13
  object lblESCode: TLabel [0]
    Left = 8
    Top = 449
    Width = 123
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Electronic Signature Code'
    ExplicitTop = 446
  end
  object laDiagnosis: TLabel [1]
    Left = 184
    Top = 185
    Width = 46
    Height = 13
    Caption = 'Diagnosis'
    Visible = False
  end
  object lblOrderList: TStaticText [2]
    Left = 8
    Top = 163
    Width = 205
    Height = 17
    Caption = 'Signature will be Applied to Checked Items'
    TabOrder = 3
    TabStop = True
  end
  object cmdOK: TButton [3]
    Left = 673
    Top = 458
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [4]
    Left = 753
    Top = 458
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  object txtESCode: TCaptionEdit [5]
    Left = 8
    Top = 463
    Width = 137
    Height = 21
    Anchors = [akLeft, akBottom]
    PasswordChar = '*'
    TabOrder = 0
    Caption = 'Electronic Signature Code'
  end
  object clstOrders: TCaptionCheckListBox [6]
    Left = 8
    Top = 181
    Width = 820
    Height = 262
    OnClickCheck = clstOrdersClickCheck
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    ParentShowHint = False
    PopupMenu = poBACopyPaste
    ShowHint = True
    Style = lbOwnerDrawVariable
    TabOrder = 4
    OnClick = clstOrdersClick
    OnDrawItem = clstOrdersDrawItem
    OnKeyUp = clstOrdersKeyUp
    OnMeasureItem = clstOrdersMeasureItem
    OnMouseDown = clstOrdersMouseDown
    OnMouseMove = clstOrdersMouseMove
    Caption = 'The following orders will be signed -'
  end
  object gbdxLookup: TGroupBox [7]
    Left = 7
    Top = 157
    Width = 99
    Height = 43
    Caption = 'Lookup Diagnosis'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
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
  inline fraCoPay: TfraCoPayDesc [8]
    Left = 0
    Top = 0
    Width = 833
    Height = 157
    Align = alTop
    AutoSize = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    TabStop = True
    Visible = False
    ExplicitWidth = 833
    inherited pnlRight: TPanel
      Left = 545
      ExplicitLeft = 545
      inherited pnlMain: TPanel
        inherited pnlHNC: TPanel
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
          inherited lblAO2: TVA508StaticText
            Width = 115
            ExplicitWidth = 115
          end
          inherited lblAO: TVA508StaticText
            Width = 23
            ExplicitWidth = 23
          end
        end
        inherited pnlCV: TPanel
          inherited lblCV2: TVA508StaticText
            Width = 142
            ExplicitWidth = 142
          end
        end
        inherited pnlSHD: TPanel
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
      Width = 545
      ExplicitWidth = 545
      inherited lblSCDisplay: TLabel
        Width = 545
        ExplicitWidth = 311
      end
      inherited memSCDisplay: TCaptionMemo
        Width = 545
        ExplicitWidth = 545
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblOrderList'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = txtESCode'
        'Status = stsDefault')
      (
        'Component = clstOrders'
        'Status = stsDefault')
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
        'Status = stsDefault'))
  end
  object poBACopyPaste: TPopupMenu
    Left = 344
    Top = 296
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
