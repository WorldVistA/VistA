inherited frmRemDlg: TfrmRemDlg
  Left = 310
  Top = 154
  Width = 545
  Height = 407
  HelpContext = 11100
  VertScrollBar.Range = 162
  BorderIcons = [biSystemMenu]
  Caption = 'Reminder Dialog'
  Constraints.MinHeight = 250
  Constraints.MinWidth = 250
  FormStyle = fsStayOnTop
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  ExplicitWidth = 545
  ExplicitHeight = 407
  PixelsPerInch = 96
  TextHeight = 13
  object splTxtData: TSplitter [0]
    Left = 0
    Top = 211
    Width = 537
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 218
  end
  object sb1: TScrollBox [1]
    Left = 0
    Top = 0
    Width = 537
    Height = 211
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnResize = sbResize
    ExplicitHeight = 218
  end
  object sb2: TScrollBox [2]
    Left = 0
    Top = 0
    Width = 537
    Height = 211
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnResize = sbResize
    ExplicitHeight = 218
  end
  object pnlFrmBottom: TPanel [3]
    Left = 0
    Top = 214
    Width = 537
    Height = 159
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 221
    object lblFootnotes: TLabel
      Left = 0
      Top = 144
      Width = 537
      Height = 15
      Align = alBottom
      AutoSize = False
      Caption = ' * Indicates a Required Field'
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 0
      Width = 537
      Height = 144
      Align = alClient
      TabOrder = 0
      object splText: TSplitter
        Left = 1
        Top = 94
        Width = 535
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object reData: TRichEdit
        Left = 1
        Top = 97
        Width = 535
        Height = 46
        Align = alBottom
        Color = clCream
        Constraints.MinHeight = 30
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
        WantReturns = False
      end
      object reText: TRichEdit
        Left = 1
        Top = 25
        Width = 535
        Height = 69
        Align = alClient
        Color = clCream
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 30
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        WantReturns = False
        WordWrap = False
      end
      object pnlButtons: TORAutoPanel
        Left = 1
        Top = 1
        Width = 535
        Height = 24
        Align = alTop
        BevelOuter = bvNone
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object btnClear: TButton
          Left = 2
          Top = 2
          Width = 66
          Height = 21
          Hint = 'Clear Reminder Resolutions for this Reminder'
          Caption = 'Clear'
          TabOrder = 0
          OnClick = btnClearClick
        end
        object btnBack: TButton
          Left = 263
          Top = 2
          Width = 66
          Height = 21
          Hint = 'Go back to the Previous Reminder Dialog'
          Caption = '<  Back'
          TabOrder = 3
          OnClick = btnBackClick
        end
        object btnCancel: TButton
          Left = 467
          Top = 2
          Width = 66
          Height = 21
          Hint = 'Cancel All Reminder Dialog Processing'
          Cancel = True
          Caption = 'Cancel'
          TabOrder = 6
          OnClick = btnCancelClick
        end
        object btnNext: TButton
          Left = 331
          Top = 2
          Width = 66
          Height = 21
          Hint = 'Go on to the Next Reminder Dialog'
          Caption = 'Next  >'
          TabOrder = 4
          OnClick = btnNextClick
        end
        object btnFinish: TButton
          Left = 399
          Top = 2
          Width = 66
          Height = 21
          Hint = 'Finish Processing'
          Caption = 'Finish'
          TabOrder = 5
          OnClick = btnFinishClick
        end
        object btnClinMaint: TButton
          Left = 70
          Top = 2
          Width = 105
          Height = 21
          Hint = 'View the Clinical Maintenance Component'
          Caption = 'Clinical &Maint'
          TabOrder = 1
          OnClick = btnClinMaintClick
        end
        object btnVisit: TButton
          Left = 177
          Top = 2
          Width = 84
          Height = 21
          Caption = '&Visit Info'
          TabOrder = 2
          OnClick = btnVisitClick
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = sb1'
        'Status = stsDefault')
      (
        'Component = sb2'
        'Status = stsDefault')
      (
        'Component = pnlFrmBottom'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = reData'
        'Status = stsDefault')
      (
        'Component = reText'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = btnClear'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = btnBack'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = btnCancel'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = btnNext'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = btnFinish'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = btnClinMaint'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = btnVisit'
        'Status = stsDefault')
      (
        'Component = frmRemDlg'
        'Status = stsDefault'))
  end
end
