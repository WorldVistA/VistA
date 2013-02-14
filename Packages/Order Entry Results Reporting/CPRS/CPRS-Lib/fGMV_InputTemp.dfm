object frmGMV_InputTemp: TfrmGMV_InputTemp
  Left = 322
  Top = 254
  BorderStyle = bsNone
  Caption = 'frmGMV_InputTemp'
  ClientHeight = 447
  ClientWidth = 728
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlInputTemplate: TPanel
    Left = 0
    Top = 41
    Width = 728
    Height = 406
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlInputTemplate'
    TabOrder = 0
    object Bevel1: TBevel
      Left = 0
      Top = 50
      Width = 728
      Height = 2
      Align = alTop
      Shape = bsBottomLine
    end
    object pnlInputTemplateHeader: TPanel
      Left = 0
      Top = 0
      Width = 728
      Height = 24
      Align = alTop
      Alignment = taLeftJustify
      Caption = '  Input Template'
      TabOrder = 1
    end
    object hc: THeaderControl
      Left = 0
      Top = 52
      Width = 728
      Height = 17
      DragReorder = False
      Enabled = False
      Sections = <
        item
          Alignment = taCenter
          ImageIndex = -1
          Text = '#'
          Width = 29
        end
        item
          ImageIndex = -1
          Text = 'Unavailable'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'U...  R...'
          Width = 60
        end
        item
          ImageIndex = -1
          Text = 'Vital'
          Width = 111
        end
        item
          ImageIndex = -1
          Text = 'Value'
          Width = 90
        end
        item
          ImageIndex = -1
          Text = 'Units'
          Width = 75
        end
        item
          ImageIndex = -1
          Text = 'Qualifiers'
          Width = 50
        end>
      Style = hsFlat
    end
    object pnlScrollBox: TPanel
      Left = 0
      Top = 69
      Width = 728
      Height = 337
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 4
      TabOrder = 3
      object sbxMain: TScrollBox
        Left = 4
        Top = 4
        Width = 707
        Height = 261
        BorderStyle = bsNone
        TabOrder = 0
      end
    end
    object pnlOptions: TPanel
      Left = 0
      Top = 24
      Width = 728
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      Color = 12698049
      TabOrder = 0
      object bvU: TBevel
        Left = 8
        Top = 3
        Width = 20
        Height = 21
        Shape = bsFrame
        Visible = False
      end
      object bvUnavailable: TBevel
        Left = 135
        Top = 3
        Width = 21
        Height = 21
        Shape = bsFrame
        Visible = False
      end
      object lblUnavailable: TLabel
        Left = 160
        Top = 6
        Width = 56
        Height = 13
        Caption = 'Un&available'
        FocusControl = ckbUnavailable
        Visible = False
        WordWrap = True
      end
      object Label3: TLabel
        Left = 34
        Top = 6
        Width = 73
        Height = 13
        Caption = '&Patient on pass'
        FocusControl = ckbOnPass
      end
      object ckbOnPass: TCheckBox
        Left = 12
        Top = 5
        Width = 12
        Height = 17
        Hint = 'Mark all vitals in the template as "Patient On Pass"'
        Alignment = taLeftJustify
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = ckbOnPassClick
        OnEnter = ckbOnPassEnter
        OnExit = ckbOnPassExit
      end
      object pnlCPRSMetricStyle: TPanel
        Left = 584
        Top = 0
        Width = 144
        Height = 26
        Align = alRight
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object chkCPRSSTyle: TCheckBox
          Left = 1
          Top = 5
          Width = 136
          Height = 17
          Hint = 'Switch between dropdown and check box presentation of metric'
          TabStop = False
          Alignment = taLeftJustify
          Caption = '&Units as Drop Down List'
          TabOrder = 0
          OnClick = acMetricStyleChangedExecute
        end
      end
      object ckbUnavailable: TCheckBox
        Left = 140
        Top = 5
        Width = 11
        Height = 17
        Hint = 'Mark all vitals in the template as "Patient Unavailable" '
        Alignment = taLeftJustify
        Caption = 'Patient on Pass'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Visible = False
      end
    end
  end
  object pnlTools: TPanel
    Left = 0
    Top = 0
    Width = 728
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object pnlPatient: TPanel
      Left = 0
      Top = 0
      Width = 208
      Height = 41
      Align = alLeft
      Color = clInfoBk
      Constraints.MinWidth = 165
      TabOrder = 0
      object lblPatientName: TLabel
        Left = 7
        Top = 5
        Width = 73
        Height = 13
        Caption = 'PatientName'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblPatientInfo: TLabel
        Left = 7
        Top = 21
        Width = 85
        Height = 13
        Caption = 'PatientInformation'
      end
    end
    object pnlSettings: TPanel
      Left = 208
      Top = 0
      Width = 520
      Height = 41
      Align = alClient
      TabOrder = 1
      object lblHospital: TLabel
        Left = 115
        Top = 5
        Width = 3
        Height = 13
      end
      object lblDateTime: TLabel
        Left = 115
        Top = 21
        Width = 3
        Height = 13
      end
      object lblHospitalCap: TLabel
        Left = 7
        Top = 5
        Width = 100
        Height = 13
        Caption = 'Hospital Location'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 7
        Top = 21
        Width = 61
        Height = 13
        Caption = 'Date/Time'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Panel1: TPanel
        Left = 445
        Top = 1
        Width = 74
        Height = 39
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object SpeedButton1: TSpeedButton
          Left = 8
          Top = 8
          Width = 57
          Height = 25
          Flat = True
          OnClick = SpeedButton1Click
        end
      end
    end
  end
  object ActionList1: TActionList
    Left = 336
    Top = 8
    object acMetricStyleChanged: TAction
      Caption = 'acMetricStyleChanged'
      OnExecute = acMetricStyleChangedExecute
    end
    object acSaveInput: TAction
      Caption = 'acSaveInput'
      OnExecute = acSaveInputExecute
    end
    object acSetOnPass: TAction
      Caption = 'acSetOnPass'
      OnExecute = acSetOnPassExecute
    end
    object acUnavailableBoxStatus: TAction
      Caption = 'acUnavailableBoxStatus'
    end
  end
end
