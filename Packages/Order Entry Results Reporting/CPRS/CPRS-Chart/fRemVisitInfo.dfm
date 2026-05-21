inherited frmRemVisitInfo: TfrmRemVisitInfo
  Left = 192
  Top = 195
  BorderIcons = [biSystemMenu]
  Caption = 'Other Visit Information'
  ClientHeight = 170
  ClientWidth = 316
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 332
  ExplicitHeight = 209
  DesignSize = (
    316
    170)
  TextHeight = 13
  object lblVital: TLabel [0]
    Left = 3
    Top = 6
    Width = 111
    Height = 13
    Caption = 'Vital Entry Date && Time:'
  end
  inline fraVisitRelated: TfraVisitRelated [1]
    Left = 0
    Top = 0
    Width = 316
    Height = 136
    Align = alClient
    Anchors = [akTop, akRight]
    TabOrder = 2
    TabStop = True
    ExplicitWidth = 316
    ExplicitHeight = 136
    inherited sbMain: TScrollBox
      Width = 316
      Height = 136
      inherited pnlMain: TPanel
        Width = 316
        StyleElements = [seFont, seClient, seBorder]
        inherited gbVisitRelatedTo: TGroupBox
          Width = 310
          inherited gpMain: TGridPanel
            Top = 15
            Width = 300
            Height = 75
            ControlCollection = <
              item
                Column = 0
                Control = fraVisitRelated.lblYes
                Row = 0
              end
              item
                Column = 1
                Control = fraVisitRelated.lblNo
                Row = 0
              end>
            StyleElements = [seFont, seClient, seBorder]
            inherited lblYes: TLabel
              Top = 2
              Height = 13
              StyleElements = [seFont, seClient, seBorder]
              ExplicitWidth = 23
              ExplicitHeight = 13
            end
            inherited lblNo: TLabel
              Top = 2
              Width = 277
              Height = 13
              StyleElements = [seFont, seClient, seBorder]
              ExplicitWidth = 277
              ExplicitHeight = 13
            end
          end
        end
      end
    end
  end
  object dteVitals: TORDateBox
    Tag = 11
    Left = 119
    Top = 2
    Width = 133
    Height = 21
    TabOrder = 0
    DateOnly = False
    RequireTime = True
    Caption = 'Vital Entry Date && Time:'
  end
  object btnNow: TButton
    Left = 264
    Top = 2
    Width = 43
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'NOW'
    TabOrder = 1
    OnClick = btnNowClick
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 136
    Width = 316
    Height = 34
    Align = alBottom
    Caption = 'pnlBottom'
    ShowCaption = False
    TabOrder = 4
    object btnOK: TButton
      AlignWithMargins = True
      Left = 156
      Top = 4
      Width = 75
      Height = 26
      Align = alRight
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 237
      Top = 4
      Width = 75
      Height = 26
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 24
    Top = 88
    Data = (
      (
        'Component = fraVisitRelated'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.gbVisitRelatedTo'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = dteVitals'
        'Text = Vital entry Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = btnNow'
        'Status = stsDefault')
      (
        'Component = frmRemVisitInfo'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault'))
  end
end
