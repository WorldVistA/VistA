inherited frmOrdersTS: TfrmOrdersTS
  Left = 84
  Top = 77
  Caption = 'Release Orders'
  ClientHeight = 330
  ClientWidth = 416
  Constraints.MinHeight = 365
  Constraints.MinWidth = 310
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = nil
  ExplicitWidth = 432
  ExplicitHeight = 365
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 416
    Height = 81
    Align = alTop
    AutoSize = True
    BorderStyle = bsSingle
    TabOrder = 0
    ExplicitWidth = 456
    object lblPtInfo: TVA508StaticText
      Name = 'lblPtInfo'
      Left = 1
      Top = 1
      Width = 410
      Height = 34
      Align = alTop
      Alignment = taLeftJustify
      Caption = ''
      Constraints.MinHeight = 34
      TabOrder = 0
      ShowAccelChar = True
      ExplicitWidth = 450
    end
    object pnldif: TPanel
      Left = 1
      Top = 35
      Width = 410
      Height = 41
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 450
      object Image1: TImage
        Left = 1
        Top = 1
        Width = 24
        Height = 39
        Align = alLeft
        AutoSize = True
        Enabled = False
        Picture.Data = {
          07544269746D61707E010000424D7E0100000000000076000000280000001800
          000016000000010004000000000008010000C40E0000C40E0000100000000000
          0000000000000000800000800000008080008000000080008000808000008080
          8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF008000000000000000000000080777777777777777777777700F7777777777
          7777777777700F88888888888888888887700F88888888888888888887700F88
          888808888888888887700F88888800888888888887700F8888880B0888888888
          87700F8888880BB00008888887700F888800BBCCBBB0088887700F8880BBBCCC
          CBBBB08887700F880BBBBBBBBBBBBB0887700F880BBBBBCCBBBBBB0887700F88
          0BBBBBCCBBBBBB0887700F880BBBBBCCBBBBBB0887700F8880BBBBCCBBBBB088
          87700F888800BBBBBBB0088887700F88888800000008888887700F8888888888
          8888888887700F88888888888888888887700FFFFFFFFFFFFFFFFFFFFF708000
          00000000000000000008}
        Transparent = True
        ExplicitHeight = 18
      end
      object lblUseAdmit: TVA508StaticText
        Name = 'lblUseAdmit'
        Left = 34
        Top = 4
        Width = 329
        Height = 15
        Alignment = taLeftJustify
        Caption = 
          'Use Admit: if patient is newly admitted to the hospital or nursi' +
          'ng home.'
        TabOrder = 0
        ShowAccelChar = True
      end
      object lblUseTransfer: TVA508StaticText
        Name = 'lblUseTransfer'
        Left = 34
        Top = 21
        Width = 363
        Height = 15
        Alignment = taLeftJustify
        Caption = 
          'Use Transfer: if inpatient will move from one ward or treating t' +
          'eam to another.'
        TabOrder = 1
        ShowAccelChar = True
      end
    end
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 81
    Width = 416
    Height = 249
    Align = alClient
    TabOrder = 1
    ExplicitTop = 138
    ExplicitWidth = 503
    ExplicitHeight = 465
    DesignSize = (
      416
      249)
    inline fraEvntDelayList: TfraEvntDelayList
      Left = 2
      Top = 66
      Width = 413
      Height = 183
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoScroll = True
      TabOrder = 1
      TabStop = True
      Visible = False
      ExplicitLeft = 2
      ExplicitTop = 66
      ExplicitWidth = 500
      ExplicitHeight = 455
      inherited pnlDate: TPanel
        Left = 308
        Height = 183
        ExplicitLeft = 349
        ExplicitHeight = 212
        inherited lblEffective: TLabel
          Left = 453
          Width = 71
          ExplicitLeft = 453
          ExplicitWidth = 71
        end
        inherited orDateBox: TORDateBox
          Left = 453
          ExplicitLeft = 453
        end
      end
      inherited pnlList: TPanel
        Width = 308
        Height = 183
        ExplicitWidth = 349
        ExplicitHeight = 212
        inherited lblEvntDelayList: TLabel
          Width = 306
          ExplicitWidth = 80
        end
        inherited mlstEvents: TORListBox
          Width = 306
          Height = 147
          OnDblClick = cmdOKClick
          OnChange = fraEvntDelayListmlstEventsChange
          ExplicitLeft = -4
          ExplicitTop = 41
          ExplicitWidth = 394
          ExplicitHeight = 427
        end
        inherited edtSearch: TCaptionEdit
          Width = 306
          ExplicitWidth = 347
        end
      end
    end
    object grpChoice: TGroupBox
      Left = 2
      Top = -2
      Width = 413
      Height = 67
      Anchors = [akLeft, akTop, akRight]
      Constraints.MinHeight = 45
      TabOrder = 0
      object radDelayed: TRadioButton
        Left = 20
        Top = 29
        Width = 245
        Height = 21
        Caption = '  &Delay release of new order(s) until'
        TabOrder = 1
        OnClick = radDelayedClick
      end
      object radReleaseNow: TRadioButton
        Left = 20
        Top = 13
        Width = 237
        Height = 17
        Caption = '  &Release new orders immediately'
        Enabled = False
        TabOrder = 0
        OnClick = radReleaseNowClick
      end
    end
    object cmdOK: TButton
      Left = 325
      Top = 8
      Width = 75
      Height = 20
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 325
      Top = 31
      Width = 75
      Height = 20
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnldif'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = fraEvntDelayList'
        'Status = stsDefault')
      (
        'Component = fraEvntDelayList.pnlDate'
        'Status = stsDefault')
      (
        'Component = fraEvntDelayList.orDateBox'
        'Status = stsDefault')
      (
        'Component = fraEvntDelayList.pnlList'
        'Status = stsDefault')
      (
        'Component = fraEvntDelayList.mlstEvents'
        'Status = stsDefault')
      (
        'Component = fraEvntDelayList.edtSearch'
        'Status = stsDefault')
      (
        'Component = frmOrdersTS'
        'Status = stsDefault')
      (
        'Component = lblUseTransfer'
        'Status = stsDefault')
      (
        'Component = lblPtInfo'
        'Status = stsDefault')
      (
        'Component = lblUseAdmit'
        'Status = stsDefault')
      (
        'Component = grpChoice'
        'Status = stsDefault')
      (
        'Component = radDelayed'
        'Status = stsDefault')
      (
        'Component = radReleaseNow'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault'))
  end
end
