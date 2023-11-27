inherited frmMedCopy: TfrmMedCopy
  Left = 157
  Top = 62
  Caption = 'Copy Medication Orders'
  ClientHeight = 401
  ClientWidth = 485
  Constraints.MinHeight = 150
  Constraints.MinWidth = 240
  OldCreateOrder = True
  OnCreate = FormCreate
  ExplicitWidth = 493
  ExplicitHeight = 428
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 485
    Height = 80
    Align = alTop
    AutoSize = True
    TabOrder = 0
    object lblPtInfo: TVA508StaticText
      Name = 'lblPtInfo'
      Left = 1
      Top = 1
      Width = 464
      Height = 40
      Alignment = taLeftJustify
      AutoSize = True
      Caption = ''
      Constraints.MinHeight = 40
      TabOrder = 1
      ShowAccelChar = True
    end
    object pnlInpatient: TPanel
      Left = 1
      Top = 46
      Width = 483
      Height = 33
      Align = alBottom
      AutoSize = True
      TabOrder = 0
      object Image1: TImage
        Left = 1
        Top = 1
        Width = 24
        Height = 31
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
      end
      object lblInstruction: TStaticText
        Left = 30
        Top = 1
        Width = 337
        Height = 17
        Caption = 
          '  Use Admit: if patient is newly admitted to the hospital or nur' +
          'sing home.'
        TabOrder = 0
      end
      object lblInstruction2: TStaticText
        Left = 30
        Top = 15
        Width = 371
        Height = 17
        Caption = 
          '  Use Transfer: if inpatient will move from one ward or treating' +
          ' team to another.'
        TabOrder = 1
      end
    end
  end
  object pnlMiddle: TPanel [1]
    Left = 0
    Top = 80
    Width = 485
    Height = 65
    Align = alTop
    TabOrder = 1
    object gboxMain: TGroupBox
      Left = 1
      Top = 1
      Width = 483
      Height = 63
      Align = alClient
      TabOrder = 0
      object radDelayed: TRadioButton
        Left = 20
        Top = 37
        Width = 321
        Height = 17
        Caption = '&Delay release of copied orders until'
        TabOrder = 1
        OnClick = radDelayedClick
      end
      object radRelease: TRadioButton
        Left = 20
        Top = 16
        Width = 319
        Height = 17
        Caption = '&Release copied orders immediately'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = radReleaseClick
      end
      object cmdOK: TButton
        Left = 365
        Top = 14
        Width = 72
        Height = 19
        Caption = 'OK'
        Constraints.MaxWidth = 73
        Default = True
        TabOrder = 2
        OnClick = cmdOKClick
      end
      object cmdCancel: TButton
        Left = 365
        Top = 38
        Width = 72
        Height = 19
        Cancel = True
        Caption = 'Cancel'
        Constraints.MaxWidth = 73
        TabOrder = 3
        OnClick = cmdCancelClick
      end
    end
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 145
    Width = 485
    Height = 256
    Align = alClient
    TabOrder = 2
    inline fraEvntDelayList: TfraEvntDelayList
      Left = 1
      Top = 1
      Width = 483
      Height = 254
      Align = alBottom
      AutoScroll = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 483
      ExplicitHeight = 254
      inherited pnlDate: TPanel
        Left = 378
        Height = 254
        ExplicitLeft = 378
        ExplicitHeight = 254
        inherited lblEffective: TLabel
          Left = 446
          Width = 71
          ExplicitLeft = 446
          ExplicitWidth = 71
        end
        inherited orDateBox: TORDateBox
          Left = 446
          ExplicitLeft = 446
        end
      end
      inherited pnlList: TPanel
        Width = 378
        Height = 254
        ExplicitWidth = 378
        ExplicitHeight = 254
        inherited lblEvntDelayList: TLabel
          Width = 376
          ExplicitWidth = 80
        end
        inherited mlstEvents: TORListBox
          Width = 376
          Height = 218
          OnDblClick = cmdOKClick
          ExplicitWidth = 376
          ExplicitHeight = 218
        end
        inherited edtSearch: TCaptionEdit
          Width = 376
          ExplicitWidth = 376
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlInpatient'
        'Status = stsDefault')
      (
        'Component = lblInstruction'
        'Status = stsDefault')
      (
        'Component = lblInstruction2'
        'Status = stsDefault')
      (
        'Component = pnlMiddle'
        'Status = stsDefault')
      (
        'Component = gboxMain'
        'Status = stsDefault')
      (
        'Component = radDelayed'
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
        'Component = frmMedCopy'
        'Status = stsDefault'))
  end
end
