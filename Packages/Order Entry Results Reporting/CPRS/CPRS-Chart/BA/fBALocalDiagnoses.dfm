inherited frmBALocalDiagnoses: TfrmBALocalDiagnoses
  Left = 272
  Top = 142
  Caption = 'Assign Diagnoses to Order(s)'
  ClientHeight = 517
  ClientWidth = 612
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 620
  ExplicitHeight = 544
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 612
    Height = 96
    Align = alTop
    Caption = 'pnlTop'
    TabOrder = 0
    DesignSize = (
      612
      96)
    object lbOrders: TListBox
      Left = 8
      Top = 25
      Width = 602
      Height = 69
      Anchors = [akLeft, akTop, akRight, akBottom]
      IntegralHeight = True
      ItemHeight = 13
      TabOrder = 1
      OnMouseMove = lbOrdersMouseMove
    end
    object lblPatientName: TStaticText
      Left = 8
      Top = 8
      Width = 76
      Height = 17
      Caption = 'PatientName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object pnlMain: TPanel [1]
    Left = 0
    Top = 96
    Width = 612
    Height = 259
    Align = alClient
    TabOrder = 1
    object lblDiagSect: TLabel
      Left = 9
      Top = 1
      Width = 241
      Height = 17
      AutoSize = False
      Caption = 'Diagnosis Section'
    end
    object lblDiagCodes: TLabel
      Left = 253
      Top = 1
      Width = 353
      Height = 17
      AutoSize = False
      Caption = 'Diagnosis Codes'
    end
    object lbSections: TORListBox
      Left = 9
      Top = 14
      Width = 238
      Height = 199
      IntegralHeight = True
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = lbSectionsClick
      OnDrawItem = lbSectionsDrawItem
      Caption = 'Diagnosis Section'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '3'
    end
    object btnOther: TButton
      Left = 155
      Top = 219
      Width = 92
      Height = 20
      Caption = 'Other &Diagnosis'
      TabOrder = 2
      OnClick = btnOtherClick
    end
    object lbDiagnosis: TORListBox
      Left = 253
      Top = 16
      Width = 353
      Height = 225
      IntegralHeight = True
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = lbDiagnosisClick
      Caption = 'Diagnosis Section'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '1,2,3'
    end
  end
  object pnlBottom: TORAutoPanel [2]
    Left = 0
    Top = 355
    Width = 612
    Height = 162
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      612
      162)
    object cbAddToPDList: TCheckBox
      Left = 459
      Top = 33
      Width = 129
      Height = 17
      Caption = 'Add to Personal Dx List'
      TabOrder = 2
      OnClick = cbAddToPDListClick
    end
    object cbAddToPL: TCheckBox
      Left = 459
      Top = 17
      Width = 149
      Height = 16
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Add To Problem List'
      TabOrder = 0
      OnClick = cbAddToPLClick
    end
    object btnPrimary: TButton
      Left = 480
      Top = 57
      Width = 72
      Height = 19
      Caption = '&Primary'
      TabOrder = 3
      OnClick = btnPrimaryClick
    end
    object btnRemove: TButton
      Left = 480
      Top = 81
      Width = 72
      Height = 19
      Caption = '&Remove'
      TabOrder = 4
      OnClick = btnRemoveClick
    end
    object btnSelectAll: TButton
      Left = 385
      Top = 108
      Width = 72
      Height = 18
      Caption = '&Select All'
      TabOrder = 5
      OnClick = btnSelectAllClick
    end
    object buOK: TButton
      Left = 384
      Top = 136
      Width = 72
      Height = 21
      Caption = '&OK'
      TabOrder = 6
      OnClick = buOKClick
    end
    object buCancel: TButton
      Left = 482
      Top = 136
      Width = 72
      Height = 21
      Caption = '&Cancel'
      TabOrder = 7
      OnClick = buCancelClick
    end
    object gbProvDiag: TGroupBox
      Left = 8
      Top = 0
      Width = 449
      Height = 105
      Caption = 'Provisional Diagnosis'
      TabOrder = 1
      object lvDxGrid: TListView
        Left = 2
        Top = 15
        Width = 445
        Height = 88
        Align = alClient
        Color = clInfoBk
        Columns = <
          item
            Caption = 'Add To PL/PD'
            Width = 85
          end
          item
            Caption = 'Primary'
            MinWidth = 65
            Width = 65
          end
          item
            Caption = 'Diagnosis for Selected Orders'
            MinWidth = 275
            Width = 290
          end>
        Ctl3D = False
        HideSelection = False
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = lvDxGridClick
        OnKeyDown = lvDxGridKeyDown
        OnKeyUp = lvDxGridKeyUp
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = lbOrders'
        'Status = stsDefault')
      (
        'Component = lblPatientName'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = lbSections'
        'Label = lblDiagSect'
        'Status = stsOK')
      (
        'Component = btnOther'
        'Status = stsDefault')
      (
        'Component = lbDiagnosis'
        'Label = lblDiagCodes'
        'Status = stsOK')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = cbAddToPDList'
        'Status = stsDefault')
      (
        'Component = cbAddToPL'
        'Status = stsDefault')
      (
        'Component = btnPrimary'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = btnSelectAll'
        'Status = stsDefault')
      (
        'Component = buOK'
        'Status = stsDefault')
      (
        'Component = buCancel'
        'Status = stsDefault')
      (
        'Component = gbProvDiag'
        'Status = stsDefault')
      (
        'Component = lvDxGrid'
        'Status = stsDefault')
      (
        'Component = frmBALocalDiagnoses'
        'Status = stsDefault'))
  end
end
