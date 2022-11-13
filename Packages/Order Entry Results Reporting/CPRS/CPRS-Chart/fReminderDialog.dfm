inherited frmRemDlg: TfrmRemDlg
  Left = 310
  Top = 154
  Width = 250
  Height = 250
  HelpContext = 11100
  VertScrollBar.Range = 162
  BorderIcons = [biSystemMenu]
  Caption = 'Reminder Dialog'
  Constraints.MinHeight = 250
  Constraints.MinWidth = 250
  FormStyle = fsStayOnTop
  OnCloseQuery = FormCloseQuery
  OnMouseWheel = FormMouseWheel
  ExplicitWidth = 250
  ExplicitHeight = 250
  PixelsPerInch = 96
  TextHeight = 13
  object splTxtData: TSplitter [0]
    Left = 0
    Top = 49
    Width = 234
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 132
    ExplicitWidth = 428
  end
  object sb1: TScrollBox [1]
    Left = 0
    Top = 0
    Width = 234
    Height = 49
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnResize = sbResize
  end
  object sb2: TScrollBox [2]
    Left = 0
    Top = 0
    Width = 234
    Height = 49
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnResize = sbResize
  end
  object pnlFrmBottom: TPanel [3]
    Left = 0
    Top = 52
    Width = 234
    Height = 159
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblFootnotes: TLabel
      Left = 0
      Top = 144
      Width = 234
      Height = 15
      Align = alBottom
      AutoSize = False
      Caption = ' * Indicates a Required Field'
      ExplicitWidth = 428
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 0
      Width = 234
      Height = 144
      Align = alClient
      TabOrder = 0
      object splText: TSplitter
        Left = 1
        Top = 94
        Width = 232
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitWidth = 426
      end
      object reData: TRichEdit
        Left = 1
        Top = 97
        Width = 232
        Height = 46
        Align = alBottom
        Color = clCream
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Constraints.MinHeight = 30
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
        WantReturns = False
        Zoom = 100
      end
      object reText: TRichEdit
        Left = 1
        Top = 25
        Width = 232
        Height = 69
        Align = alClient
        Color = clCream
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 30
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        Zoom = 100
      end
      object gpButtons: TGridPanel
        Left = 1
        Top = 1
        Width = 232
        Height = 24
        Align = alTop
        ColumnCollection = <
          item
            Value = 12.436500077878570000
          end
          item
            Value = 20.663506919207240000
          end
          item
            Value = 12.719951270589920000
          end
          item
            Value = 13.031814909766010000
          end
          item
            Value = 13.361495388408290000
          end
          item
            Value = 13.709670310492780000
          end
          item
            Value = 14.077061123657190000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = btnClear
            Row = 0
          end
          item
            Column = 1
            Control = btnClinMaint
            Row = 0
          end
          item
            Column = 2
            Control = btnVisit
            Row = 0
          end
          item
            Column = 3
            Control = btnBack
            Row = 0
          end
          item
            Column = 4
            Control = btnNext
            Row = 0
          end
          item
            Column = 5
            Control = btnFinish
            Row = 0
          end
          item
            Column = 6
            Control = btnCancel
            Row = 0
          end>
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 2
        object btnClear: TButton
          Left = 1
          Top = 1
          Width = 28
          Height = 22
          Hint = 'Clear Reminder Resolutions for this Reminder'
          Align = alClient
          Caption = 'Clear'
          TabOrder = 0
          OnClick = btnClearClick
        end
        object btnClinMaint: TButton
          Left = 29
          Top = 1
          Width = 47
          Height = 22
          Hint = 'View the Clinical Maintenance Component'
          Align = alClient
          Caption = 'Clinical &Maint'
          TabOrder = 1
          OnClick = btnClinMaintClick
        end
        object btnVisit: TButton
          Left = 76
          Top = 1
          Width = 29
          Height = 22
          Align = alClient
          Caption = '&Visit Info'
          TabOrder = 2
          OnClick = btnVisitClick
        end
        object btnBack: TButton
          Left = 105
          Top = 1
          Width = 29
          Height = 22
          Hint = 'Go back to the Previous Reminder Dialog'
          Align = alClient
          Caption = '<  Back'
          TabOrder = 3
          OnClick = btnBackClick
        end
        object btnNext: TButton
          Left = 134
          Top = 1
          Width = 30
          Height = 22
          Hint = 'Go on to the Next Reminder Dialog'
          Align = alClient
          Caption = 'Next  >'
          TabOrder = 4
          OnClick = btnNextClick
        end
        object btnFinish: TButton
          Left = 164
          Top = 1
          Width = 31
          Height = 22
          Hint = 'Finish Processing'
          Align = alClient
          Caption = 'Finish'
          TabOrder = 5
          OnClick = btnFinishClick
        end
        object btnCancel: TButton
          Left = 195
          Top = 1
          Width = 36
          Height = 22
          Hint = 'Cancel All Reminder Dialog Processing'
          Align = alClient
          Cancel = True
          Caption = 'Cancel'
          TabOrder = 6
          OnClick = btnCancelClick
          OnMouseDown = btnCancelMouseDown
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
        'Component = frmRemDlg'
        'Status = stsDefault')
      (
        'Component = gpButtons'
        'Status = stsDefault')
      (
        'Component = btnClear'
        'Status = stsDefault')
      (
        'Component = btnClinMaint'
        'Status = stsDefault')
      (
        'Component = btnVisit'
        'Status = stsDefault')
      (
        'Component = btnBack'
        'Status = stsDefault')
      (
        'Component = btnNext'
        'Status = stsDefault')
      (
        'Component = btnFinish'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault'))
  end
end
