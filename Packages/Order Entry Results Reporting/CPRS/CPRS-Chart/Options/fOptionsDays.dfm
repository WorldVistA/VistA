inherited frmOptionsDays: TfrmOptionsDays
  Left = 516
  Top = 90
  HelpContext = 9010
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Date Range Defaults on Cover Sheet'
  ClientHeight = 349
  ClientWidth = 288
  HelpFile = 'CPRSWT.HLP'
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 294
  ExplicitHeight = 377
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 317
    Width = 288
    Height = 32
    HelpContext = 9010
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    ExplicitTop = 275
    ExplicitWidth = 314
    object btnOK: TButton
      AlignWithMargins = True
      Left = 132
      Top = 3
      Width = 73
      Height = 26
      HelpContext = 9996
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
      ExplicitLeft = 158
      ExplicitTop = 5
      ExplicitHeight = 24
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 211
      Top = 3
      Width = 74
      Height = 26
      HelpContext = 9997
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 237
      ExplicitTop = 5
      ExplicitHeight = 24
    end
  end
  object Panel11: TPanel [1]
    Left = 0
    Top = 0
    Width = 288
    Height = 317
    Align = alClient
    ShowCaption = False
    TabOrder = 1
    ExplicitLeft = 72
    ExplicitTop = 144
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 286
      Height = 155
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 0
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 286
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 0
        ExplicitWidth = 314
        object bvlTop: TBevel
          AlignWithMargins = True
          Left = 78
          Top = 12
          Width = 205
          Height = 15
          Margins.Top = 12
          Align = alClient
          Shape = bsTopLine
          ExplicitLeft = 11
          ExplicitTop = 9
          ExplicitWidth = 305
          ExplicitHeight = 2
        end
        object lblLab: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 69
          Height = 24
          Align = alLeft
          Caption = 'Lab results'
          TabOrder = 0
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 30
        Width = 129
        Height = 93
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel5'
        ShowCaption = False
        TabOrder = 1
        ExplicitHeight = 107
        object lblLabInpatient: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 123
          Height = 16
          Align = alTop
          Caption = 'Inpatient days:'
          ExplicitWidth = 86
        end
        object lblLabOutpatient: TLabel
          Left = 0
          Top = 49
          Width = 129
          Height = 16
          Align = alTop
          Caption = 'Outpatient days:'
          ExplicitWidth = 96
        end
        object Panel7: TPanel
          Left = 0
          Top = 22
          Width = 129
          Height = 27
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel7'
          ShowCaption = False
          TabOrder = 0
          DesignSize = (
            129
            27)
          object txtLabInpatient: TCaptionEdit
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 78
            Height = 21
            HelpContext = 9013
            Align = alLeft
            TabOrder = 0
            Text = '1'
            OnChange = txtLabInpatientChange
            OnExit = txtLabInpatientExit
            OnKeyPress = txtLabInpatientKeyPress
            Caption = 'Inpatient days'
          end
          object spnLabInpatient: TUpDown
            Left = 81
            Top = 3
            Width = 16
            Height = 21
            HelpContext = 9013
            Anchors = [akTop, akRight]
            Associate = txtLabInpatient
            Max = 999
            Position = 1
            TabOrder = 1
            Thousands = False
            OnClick = spnLabInpatientClick
          end
        end
        object Panel8: TPanel
          Left = 0
          Top = 65
          Width = 129
          Height = 27
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel8'
          ShowCaption = False
          TabOrder = 1
          DesignSize = (
            129
            27)
          object txtLabOutpatient: TCaptionEdit
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 78
            Height = 21
            HelpContext = 9014
            Align = alLeft
            TabOrder = 0
            Text = '1'
            OnChange = txtLabOutpatientChange
            OnExit = txtLabOutpatientExit
            OnKeyPress = txtLabInpatientKeyPress
            Caption = 'Outpatient days'
          end
          object spnLabOutpatient: TUpDown
            Left = 81
            Top = 3
            Width = 16
            Height = 21
            HelpContext = 9014
            Anchors = [akTop, akRight]
            Associate = txtLabOutpatient
            Max = 999
            Position = 1
            TabOrder = 1
            Thousands = False
            OnClick = spnLabOutpatientClick
          end
        end
      end
      object Panel12: TPanel
        Left = 0
        Top = 123
        Width = 286
        Height = 32
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel12'
        ShowCaption = False
        TabOrder = 2
        object btnLabDefaults: TButton
          AlignWithMargins = True
          Left = 132
          Top = 3
          Width = 151
          Height = 26
          HelpContext = 9011
          Margins.Left = 132
          Align = alBottom
          Caption = 'Use Defaults'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btnLabDefaultsClick
          ExplicitLeft = 3
          ExplicitTop = 72
          ExplicitWidth = 123
        end
      end
      object lblLabValue: TMemo
        AlignWithMargins = True
        Left = 132
        Top = 33
        Width = 151
        Height = 87
        TabStop = False
        Align = alClient
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          'lblLabValue')
        ReadOnly = True
        TabOrder = 3
        ExplicitTop = 36
        ExplicitHeight = 89
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 156
      Width = 286
      Height = 160
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 314
      ExplicitHeight = 135
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 286
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 0
        ExplicitWidth = 314
        object bvlMiddle: TBevel
          AlignWithMargins = True
          Left = 154
          Top = 12
          Width = 129
          Height = 15
          Margins.Top = 12
          Align = alClient
          Shape = bsTopLine
          ExplicitLeft = 11
          ExplicitTop = 29
          ExplicitWidth = 305
          ExplicitHeight = 1
        end
        object lblVisit: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 145
          Height = 24
          Align = alLeft
          Caption = 'Appointments and visits'
          TabOrder = 0
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 30
        Width = 129
        Height = 98
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel5'
        ShowCaption = False
        TabOrder = 1
        ExplicitHeight = 105
        object lblVisitStart: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 123
          Height = 16
          Align = alTop
          Caption = 'Start:'
          ExplicitWidth = 30
        end
        object lblVisitStop: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 52
          Width = 123
          Height = 16
          Align = alTop
          Caption = 'Stop:'
          ExplicitWidth = 31
        end
        object Panel9: TPanel
          Left = 0
          Top = 22
          Width = 129
          Height = 27
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel7'
          ShowCaption = False
          TabOrder = 0
          DesignSize = (
            129
            27)
          object txtVisitStart: TCaptionEdit
            Tag = -180
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 79
            Height = 21
            HelpContext = 9015
            Align = alLeft
            MaxLength = 12
            TabOrder = 0
            Text = '0'
            OnExit = txtVisitStartExit
            OnKeyPress = txtVisitStartKeyPress
            OnKeyUp = txtVisitStartKeyUp
            Caption = 'Start'
          end
          object spnVisitStart: TUpDown
            Tag = -180
            Left = 82
            Top = 3
            Width = 16
            Height = 21
            HelpContext = 9015
            Anchors = [akTop, akRight]
            Associate = txtVisitStart
            Min = -999
            Max = 999
            TabOrder = 1
            Thousands = False
            OnClick = spnVisitStartClick
          end
        end
        object Panel10: TPanel
          Left = 0
          Top = 71
          Width = 129
          Height = 27
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel8'
          ShowCaption = False
          TabOrder = 1
          object txtVisitStop: TCaptionEdit
            Tag = 30
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 79
            Height = 21
            HelpContext = 9015
            Align = alLeft
            MaxLength = 12
            TabOrder = 0
            Text = '0'
            OnExit = txtVisitStopExit
            OnKeyPress = txtVisitStopKeyPress
            OnKeyUp = txtVisitStopKeyUp
            Caption = 'Stop'
          end
          object spnVisitStop: TUpDown
            Tag = 30
            Left = 82
            Top = 3
            Width = 16
            Height = 21
            HelpContext = 9015
            Associate = txtVisitStop
            Min = -999
            Max = 999
            TabOrder = 1
            Thousands = False
            OnClick = spnVisitStopClick
          end
        end
      end
      object Panel13: TPanel
        Left = 0
        Top = 128
        Width = 286
        Height = 32
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel13'
        ShowCaption = False
        TabOrder = 2
        ExplicitTop = 86
        object btnVisitDefaults: TButton
          AlignWithMargins = True
          Left = 132
          Top = 3
          Width = 151
          Height = 26
          HelpContext = 9012
          Margins.Left = 132
          Align = alBottom
          Caption = 'Use Defaults'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btnVisitDefaultsClick
          ExplicitLeft = 3
          ExplicitTop = 80
        end
      end
      object lblVisitValue: TMemo
        AlignWithMargins = True
        Left = 132
        Top = 33
        Width = 151
        Height = 92
        TabStop = False
        Align = alClient
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          'lblVisitValue')
        ReadOnly = True
        TabOrder = 3
        ExplicitLeft = 3
        ExplicitTop = 3
        ExplicitHeight = 50
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 664
    Data = (
      (
        'Component = lblVisitValue'
        'Status = stsDefault')
      (
        'Component = lblLabValue'
        'Status = stsDefault')
      (
        'Component = lblVisit'
        'Status = stsDefault')
      (
        'Component = lblLab'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = txtLabInpatient'
        'Status = stsDefault')
      (
        'Component = spnLabInpatient'
        'Status = stsDefault')
      (
        'Component = txtLabOutpatient'
        'Status = stsDefault')
      (
        'Component = spnLabOutpatient'
        'Status = stsDefault')
      (
        'Component = txtVisitStart'
        'Status = stsDefault')
      (
        'Component = spnVisitStart'
        'Status = stsDefault')
      (
        'Component = txtVisitStop'
        'Status = stsDefault')
      (
        'Component = spnVisitStop'
        'Status = stsDefault')
      (
        'Component = btnLabDefaults'
        'Status = stsDefault')
      (
        'Component = btnVisitDefaults'
        'Status = stsDefault')
      (
        'Component = frmOptionsDays'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = Panel5'
        'Status = stsDefault')
      (
        'Component = Panel6'
        'Status = stsDefault')
      (
        'Component = Panel7'
        'Status = stsDefault')
      (
        'Component = Panel8'
        'Status = stsDefault')
      (
        'Component = Panel9'
        'Status = stsDefault')
      (
        'Component = Panel10'
        'Status = stsDefault')
      (
        'Component = Panel11'
        'Status = stsDefault')
      (
        'Component = Panel12'
        'Status = stsDefault')
      (
        'Component = Panel13'
        'Status = stsDefault'))
  end
end
