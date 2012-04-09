inherited frmCopyOrders: TfrmCopyOrders
  Left = 319
  Top = 139
  Caption = 'Copy Orders'
  ClientHeight = 419
  ClientWidth = 441
  Constraints.MinHeight = 100
  Constraints.MinWidth = 330
  OldCreateOrder = True
  OnCreate = FormCreate
  ExplicitWidth = 449
  ExplicitHeight = 446
  PixelsPerInch = 96
  TextHeight = 13
  object pnlRadio: TPanel [0]
    Left = 0
    Top = 80
    Width = 441
    Height = 65
    Align = alTop
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 439
      Height = 63
      Align = alClient
      Constraints.MinHeight = 50
      DragMode = dmAutomatic
      TabOrder = 0
      object radRelease: TRadioButton
        Left = 12
        Top = 15
        Width = 318
        Height = 20
        Caption = '&Release copied orders immediately'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = radReleaseClick
      end
      object radEvtDelay: TRadioButton
        Left = 12
        Top = 37
        Width = 320
        Height = 20
        Caption = '&Delay release of copied orders'
        TabOrder = 1
        OnClick = radEvtDelayClick
      end
      object cmdOK: TButton
        Left = 345
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
        Left = 345
        Top = 38
        Width = 72
        Height = 18
        Cancel = True
        Caption = 'Cancel'
        Constraints.MaxWidth = 73
        TabOrder = 3
        OnClick = cmdCancelClick
      end
    end
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 441
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblPtInfo: TVA508StaticText
      Name = 'lblPtInfo'
      Left = 0
      Top = 5
      Width = 400
      Height = 35
      Alignment = taLeftJustify
      AutoSize = True
      Caption = ' '
      Constraints.MinHeight = 15
      TabOrder = 0
      ShowAccelChar = True
    end
    object pnlInfo: TPanel
      Left = 0
      Top = 46
      Width = 441
      Height = 34
      Align = alBottom
      TabOrder = 1
      object Image1: TImage
        Left = 1
        Top = 1
        Width = 24
        Height = 22
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
      object lblInstruction2: TVA508StaticText
        Name = 'lblInstruction2'
        Left = 31
        Top = 17
        Width = 363
        Height = 15
        Alignment = taLeftJustify
        Caption = 
          'Use Transfer: if inpatient will move from one ward or treating t' +
          'eam to another.'
        TabOrder = 1
        ShowAccelChar = True
      end
      object lblInstruction: TVA508StaticText
        Name = 'lblInstruction'
        Left = 31
        Top = 1
        Width = 329
        Height = 15
        Alignment = taLeftJustify
        Caption = 
          'Use Admit: if patient is newly admitted to the hospital or nursi' +
          'ng home.'
        TabOrder = 0
        ShowAccelChar = True
      end
    end
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 145
    Width = 441
    Height = 274
    Align = alClient
    TabOrder = 2
    ExplicitLeft = 8
    ExplicitTop = 165
    ExplicitWidth = 425
    ExplicitHeight = 236
    inline fraEvntDelayList: TfraEvntDelayList
      Left = 1
      Top = 1
      Width = 439
      Height = 272
      Align = alBottom
      AutoScroll = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitTop = 145
      ExplicitWidth = 441
      ExplicitHeight = 274
      inherited pnlDate: TPanel
        Left = 334
        Height = 272
        ExplicitLeft = 336
        ExplicitHeight = 274
        inherited lblEffective: TLabel
          Left = 451
          Width = 71
          ExplicitLeft = 451
          ExplicitWidth = 71
        end
        inherited orDateBox: TORDateBox
          Left = 451
          ExplicitLeft = 451
        end
      end
      inherited pnlList: TPanel
        Width = 334
        Height = 272
        ExplicitWidth = 336
        ExplicitHeight = 274
        inherited lblEvntDelayList: TLabel
          Width = 332
          ExplicitWidth = 80
        end
        inherited mlstEvents: TORListBox
          Width = 332
          Height = 236
          OnDblClick = cmdOKClick
          OnChange = fraEvntDelayListmlstEventsChange
          ExplicitWidth = 334
          ExplicitHeight = 238
        end
        inherited edtSearch: TCaptionEdit
          Width = 332
          ExplicitWidth = 334
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlInfo'
        'Status = stsDefault')
      (
        'Component = lblInstruction2'
        'Status = stsDefault')
      (
        'Component = lblInstruction'
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
        'Component = pnlRadio'
        'Status = stsDefault')
      (
        'Component = GroupBox1'
        'Status = stsDefault')
      (
        'Component = radRelease'
        'Status = stsDefault')
      (
        'Component = radEvtDelay'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = lblPtInfo'
        'Status = stsDefault')
      (
        'Component = frmCopyOrders'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault'))
  end
end
