inherited frmBALocalDiagnoses: TfrmBALocalDiagnoses
  Left = 272
  Top = 142
  Caption = 'Assign Diagnoses to Order(s)'
  ClientHeight = 636
  ClientWidth = 753
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  ExplicitWidth = 769
  ExplicitHeight = 675
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 753
    Height = 118
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 0
    DesignSize = (
      753
      118)
    object lbOrders: TListBox
      Left = 10
      Top = 31
      Width = 741
      Height = 82
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight, akBottom]
      IntegralHeight = True
      ItemHeight = 13
      TabOrder = 1
      OnMouseMove = lbOrdersMouseMove
    end
    object lblPatientName: TStaticText
      Left = 10
      Top = 10
      Width = 93
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'PatientName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object pnlMain: TPanel [1]
    Left = 0
    Top = 118
    Width = 753
    Height = 319
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 1
    object lblDiagSect: TLabel
      Left = 11
      Top = 1
      Width = 297
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Diagnosis Section'
    end
    object lblDiagCodes: TLabel
      Left = 311
      Top = 1
      Width = 435
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Diagnosis Codes'
    end
    object lbSections: TORListBox
      Left = 11
      Top = 17
      Width = 293
      Height = 225
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
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
      Left = 191
      Top = 270
      Width = 113
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Other &Diagnosis'
      TabOrder = 2
      OnClick = btnOtherClick
    end
    object lbDiagnosis: TORListBox
      Left = 311
      Top = 20
      Width = 435
      Height = 251
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
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
    Top = 437
    Width = 753
    Height = 199
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      753
      199)
    object cbAddToPDList: TCheckBox
      Left = 565
      Top = 41
      Width = 159
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Add to Personal Dx List'
      TabOrder = 2
      OnClick = cbAddToPDListClick
    end
    object cbAddToPL: TCheckBox
      Left = 565
      Top = 21
      Width = 183
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Add To Problem List'
      TabOrder = 0
      OnClick = cbAddToPLClick
    end
    object btnPrimary: TButton
      Left = 591
      Top = 70
      Width = 88
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&Primary'
      TabOrder = 3
      OnClick = btnPrimaryClick
    end
    object btnRemove: TButton
      Left = 591
      Top = 100
      Width = 88
      Height = 23
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&Remove'
      TabOrder = 4
      OnClick = btnRemoveClick
    end
    object btnSelectAll: TButton
      Left = 474
      Top = 133
      Width = 88
      Height = 22
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&Select All'
      TabOrder = 5
      OnClick = btnSelectAllClick
    end
    object buOK: TButton
      Left = 473
      Top = 167
      Width = 88
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&OK'
      TabOrder = 6
      OnClick = buOKClick
    end
    object buCancel: TButton
      Left = 593
      Top = 167
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&Cancel'
      TabOrder = 7
      OnClick = buCancelClick
    end
    object gbProvDiag: TGroupBox
      Left = 10
      Top = 0
      Width = 552
      Height = 129
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Provisional Diagnosis'
      TabOrder = 1
      object lvDxGrid: TListView
        Left = 2
        Top = 18
        Width = 548
        Height = 109
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Color = clInfoBk
        Columns = <
          item
            Caption = 'Add To PL/PD'
            Width = 105
          end
          item
            Caption = 'Primary'
            MinWidth = 65
            Width = 80
          end
          item
            Caption = 'Diagnosis for Selected Orders'
            MinWidth = 275
            Width = 357
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
