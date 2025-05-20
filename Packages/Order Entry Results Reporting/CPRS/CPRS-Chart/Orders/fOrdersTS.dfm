inherited frmOrdersTS: TfrmOrdersTS
  Left = 84
  Top = 77
  Caption = 'Release Orders'
  ClientHeight = 351
  ClientWidth = 456
  Constraints.MinHeight = 365
  Constraints.MinWidth = 310
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = nil
  ExplicitWidth = 472
  ExplicitHeight = 389
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMiddle: TPanel [0]
    Left = 0
    Top = 81
    Width = 456
    Height = 56
    Align = alTop
    Constraints.MinHeight = 45
    TabOrder = 1
    object pnlButtons: TPanel
      Left = 376
      Top = 1
      Width = 79
      Height = 54
      Align = alRight
      BevelEdges = [beRight]
      BevelOuter = bvNone
      Constraints.MinHeight = 45
      TabOrder = 1
      ExplicitLeft = 372
      object cmdCancel: TButton
        AlignWithMargins = True
        Left = 3
        Top = 29
        Width = 73
        Height = 20
        Align = alTop
        Cancel = True
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = cmdCancelClick
      end
      object cmdOK: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 73
        Height = 20
        Align = alTop
        Caption = 'OK'
        Default = True
        TabOrder = 0
        OnClick = cmdOKClick
      end
    end
    object sbxReleaseEvent: TScrollBox
      Left = 1
      Top = 1
      Width = 375
      Height = 54
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Constraints.MinHeight = 45
      TabOrder = 0
      object radDelayed: TRadioButton
        Left = 12
        Top = 23
        Width = 197
        Height = 21
        Caption = '  &Delay release of new order(s) until'
        TabOrder = 1
        OnClick = radDelayedClick
      end
      object radReleaseNow: TRadioButton
        Left = 12
        Top = 7
        Width = 197
        Height = 17
        Caption = '  &Release new orders immediately'
        Enabled = False
        TabOrder = 0
        OnClick = radReleaseNowClick
      end
    end
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 456
    Height = 81
    Align = alTop
    AutoSize = True
    BorderStyle = bsSingle
    TabOrder = 0
    object lblPtInfo: TVA508StaticText
      Name = 'lblPtInfo'
      Left = 1
      Top = 1
      Width = 450
      Height = 34
      Align = alTop
      Alignment = taLeftJustify
      Caption = ''
      Constraints.MinHeight = 34
      TabOrder = 0
      ShowAccelChar = True
    end
    object pnldif: TPanel
      Left = 1
      Top = 35
      Width = 450
      Height = 41
      Align = alClient
      TabOrder = 1
      object Image1: TImage
        Left = 1
        Top = 1
        Width = 24
        Height = 22
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
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 137
    Width = 456
    Height = 214
    Align = alClient
    TabOrder = 2
    inline fraEvntDelayList: TfraEvntDelayList
      Left = 1
      Top = 1
      Width = 454
      Height = 212
      Align = alClient
      AutoScroll = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 454
      ExplicitHeight = 212
      inherited pnlDate: TPanel
        Left = 349
        Height = 212
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
        Width = 349
        Height = 212
        ExplicitWidth = 349
        ExplicitHeight = 212
        inherited lblEvntDelayList: TLabel
          Width = 347
          ExplicitWidth = 80
        end
        inherited mlstEvents: TORListBox
          Width = 347
          Height = 176
          OnDblClick = cmdOKClick
          OnChange = fraEvntDelayListmlstEventsChange
          ExplicitWidth = 347
          ExplicitHeight = 176
        end
        inherited edtSearch: TCaptionEdit
          Width = 347
          ExplicitWidth = 347
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlMiddle'
        'Status = stsDefault')
      (
        'Component = radReleaseNow'
        'Status = stsDefault')
      (
        'Component = radDelayed'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
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
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = sbReleaseEvent'
        'Status = stsDefault'))
  end
end
