inherited frmPtSelDemog: TfrmPtSelDemog
  Left = 100
  BorderStyle = bsNone
  Caption = 'frmPtSelDemog'
  ClientHeight = 193
  ClientWidth = 169
  DefaultMonitor = dmDesktop
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 169
  ExplicitHeight = 193
  PixelsPerInch = 96
  TextHeight = 13
  object orapnlMain: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 169
    Height = 193
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Memo: TCaptionMemo
      Left = 0
      Top = 0
      Width = 169
      Height = 193
      Align = alClient
      HideSelection = False
      Lines.Strings = (
        'Memo')
      ReadOnly = True
      TabOrder = 12
      Visible = False
      WantReturns = False
      OnEnter = MemoEnter
      OnKeyDown = MemoKeyDown
      Caption = ''
    end
    object lblPtName: TStaticText
      Tag = 2
      Left = 1
      Top = 3
      Width = 166
      Height = 17
      Caption = 'Winchester,Charles Emerson'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
    end
    object lblSSN: TStaticText
      Tag = 1
      Left = 1
      Top = 17
      Width = 29
      Height = 17
      Caption = 'SSN:'
      TabOrder = 0
    end
    object lblPtSSN: TStaticText
      Tag = 2
      Left = 31
      Top = 17
      Width = 64
      Height = 17
      Caption = '123-45-1234'
      TabOrder = 1
    end
    object lblDOB: TStaticText
      Tag = 1
      Left = 1
      Top = 33
      Width = 30
      Height = 17
      Caption = 'DOB:'
      TabOrder = 2
    end
    object lblPtDOB: TStaticText
      Tag = 2
      Left = 31
      Top = 32
      Width = 63
      Height = 17
      Caption = 'Jun 26,1957'
      TabOrder = 3
    end
    object lblPtSex: TStaticText
      Tag = 2
      Left = 1
      Top = 47
      Width = 66
      Height = 17
      Caption = 'Male, age 39'
      TabOrder = 4
    end
    object lblPtVet: TStaticText
      Tag = 2
      Left = 1
      Top = 62
      Width = 41
      Height = 17
      Caption = 'Veteran'
      TabOrder = 5
    end
    object lblPtSC: TStaticText
      Tag = 2
      Left = 1
      Top = 75
      Width = 118
      Height = 17
      Caption = 'Service Connected 50%'
      TabOrder = 6
    end
    object lblLocation: TStaticText
      Tag = 1
      Left = 1
      Top = 90
      Width = 48
      Height = 17
      Caption = 'Location:'
      TabOrder = 7
    end
    object lblPtRoomBed: TStaticText
      Tag = 2
      Left = 64
      Top = 107
      Width = 32
      Height = 17
      Caption = '257-B'
      ShowAccelChar = False
      TabOrder = 8
    end
    object lblPtLocation: TStaticText
      Tag = 2
      Left = 61
      Top = 90
      Width = 41
      Height = 17
      Caption = '2 EAST'
      ShowAccelChar = False
      TabOrder = 9
    end
    object lblRoomBed: TStaticText
      Tag = 1
      Left = 1
      Top = 104
      Width = 57
      Height = 17
      Caption = 'Room-Bed:'
      TabOrder = 10
    end
    object lblCombatVet: TStaticText
      Tag = 2
      Left = 1
      Top = 127
      Width = 66
      Height = 17
      Caption = 'lblCombatVet'
      TabOrder = 13
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = orapnlMain'
        'Status = stsDefault')
      (
        'Component = Memo'
        'Status = stsDefault')
      (
        'Component = lblPtName'
        'Status = stsDefault')
      (
        'Component = lblSSN'
        'Status = stsDefault')
      (
        'Component = lblPtSSN'
        'Status = stsDefault')
      (
        'Component = lblDOB'
        'Status = stsDefault')
      (
        'Component = lblPtDOB'
        'Status = stsDefault')
      (
        'Component = lblPtSex'
        'Status = stsDefault')
      (
        'Component = lblPtVet'
        'Status = stsDefault')
      (
        'Component = lblPtSC'
        'Status = stsDefault')
      (
        'Component = lblLocation'
        'Status = stsDefault')
      (
        'Component = lblPtRoomBed'
        'Status = stsDefault')
      (
        'Component = lblPtLocation'
        'Status = stsDefault')
      (
        'Component = lblRoomBed'
        'Status = stsDefault')
      (
        'Component = frmPtSelDemog'
        'Status = stsDefault')
      (
        'Component = lblCombatVet'
        'Status = stsDefault'))
  end
end
