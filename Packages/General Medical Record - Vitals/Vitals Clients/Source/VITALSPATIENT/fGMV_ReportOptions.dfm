object frmGMV_ReportOptions: TfrmGMV_ReportOptions
  Left = 584
  Top = 271
  HelpContext = 7
  BorderStyle = bsDialog
  Caption = ' Report Options'
  ClientHeight = 501
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
    77000770007700077000770007700000F7000F7000F7000F7000F7000F700000
    0000000000000000000000000000000000000000000000000000000000007708
    F8F8F8F8F8F8F8F8F8F8F8F8F8F8F70000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000770899F8F8F8F899F8F448F8F8F8F448F700
    99000000009900044F0000000440000000900000090090400400000040000000
    0009000090000400004000040000000000009009000040900004004000007708
    44F8F998F844F8F998F844F8F8F8F70044000990004400099000440000000000
    0040000004000000090000000000000000040000400000000090000000000000
    00004004000000000009000000007708F8F8F448F8F8F8F8F8F899F8F8F8F700
    0000044000000000000099000000000000000000000000000000009000000000
    0000000000000000000000090000000000000000000000000000000090007708
    F8F8F8F8F8F8F8F8F8F8F8F8F998F70000000000000000000000000009900000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000007708F8F8F8F8F8F8F8F8F8F8F8F8F8F8F700
    0000000000000000000000000000FFFFFFFFF39CE739F39CE739FFFFFFFFFFFF
    FFFF200000003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF2000000033FCE3F9FDFB
    5BF7FEF7BDEFFF6F5EDF20000000339CE73FFDFBFBFFFEF7FDFFFF6FFEFF2000
    00003F9FFF3FFFFFFFDFFFFFFFEFFFFFFFF7200000003FFFFFF9FFFFFFFFFFFF
    FFFFFFFFFFFF200000003FFFFFFF280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000007707707707707000F
    70F70F70F70F7700000000000000F70998F8F998F8F800099000099000047700
    090090090440F708F899F8F8944800000099000049007700000000440090F704
    48F8F844F8F900044000040000097700040040000000F708F844F8F8F8F80000
    0044000000007700000000000000F708F8F8F8F8F8F8E4920000E49200003FFF
    000020000000E79E00003B69000020000000FCF300003FCD000020000000E7BE
    00003B7F000020000000FCFF00003FFF000020000000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 460
    Width = 535
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      535
      41)
    object OKButton: TButton
      Left = 371
      Top = 9
      Width = 75
      Height = 25
      Action = acPrintReport
      Anchors = [akTop, akRight]
      Caption = '&Print'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 453
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 535
    Height = 460
    Align = alClient
    BorderWidth = 4
    TabOrder = 0
    object Panel4: TPanel
      Left = 5
      Top = 5
      Width = 525
      Height = 63
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object GroupBox2: TGroupBox
        Left = 8
        Top = 3
        Width = 513
        Height = 54
        Caption = ' Select &Report '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object ReportCombo: TComboBox
          Left = 11
          Top = 19
          Width = 489
          Height = 21
          Hint = 'Report to Print. '
          DropDownCount = 15
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = acReportChanged
        end
      end
    end
    object Panel1: TPanel
      Left = 5
      Top = 271
      Width = 525
      Height = 184
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 3
      DesignSize = (
        525
        184)
      object GroupBox5: TGroupBox
        Left = 6
        Top = 0
        Width = 513
        Height = 179
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' Select Output &Device: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        DesignSize = (
          513
          179)
        object Label3: TLabel
          Left = 15
          Top = 155
          Width = 45
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = 'Selected:'
          FocusControl = edDevice
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton2: TSpeedButton
          Left = 8
          Top = 36
          Width = 64
          Height = 22
          Caption = 'More'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
          OnClick = SpeedButton2Click
        end
        object SpeedButton1: TSpeedButton
          Left = 8
          Top = 58
          Width = 64
          Height = 22
          Action = acSearch
          Anchors = [akTop, akRight]
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object edTarget: TEdit
          Left = 83
          Top = 17
          Width = 421
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = edTargetChange
          OnKeyUp = edTargetKeyUp
        end
        object lvDevices: TListView
          Left = 83
          Top = 41
          Width = 421
          Height = 109
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              Caption = 'ID'
              Width = 30
            end
            item
              Caption = 'Name'
              Width = 150
            end
            item
              Caption = 'Location'
              Width = 120
            end
            item
              Caption = 'Width'
            end
            item
              Caption = 'Length'
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          TabOrder = 1
          ViewStyle = vsReport
          OnChange = lvDevicesChange
        end
        object edDevice: TEdit
          Left = 83
          Top = 152
          Width = 422
          Height = 19
          Anchors = [akLeft, akRight, akBottom]
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = True
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
        end
      end
    end
    object Panel2: TPanel
      Left = 5
      Top = 186
      Width = 525
      Height = 85
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        525
        85)
      object gbDateRange: TGroupBox
        Left = 6
        Top = 0
        Width = 187
        Height = 81
        Hint = 'GB Hint'
        Anchors = [akLeft, akTop, akBottom]
        Caption = ' Date Range &Start: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object lblStart: TLabel
          Left = 13
          Top = 27
          Width = 26
          Height = 13
          Caption = 'Date:'
          FocusControl = dtpFromDate
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblEnd: TLabel
          Left = 13
          Top = 50
          Width = 26
          Height = 13
          Caption = 'Time:'
          FocusControl = dtpToTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dtpFromDate: TDateTimePicker
          Left = 82
          Top = 24
          Width = 97
          Height = 21
          Hint = 'Start Date'
          Date = 37245.445040810200000000
          Time = 37245.445040810200000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = acStartDateChanged
        end
        object dtpFromTime: TDateTimePicker
          Left = 82
          Top = 48
          Width = 97
          Height = 21
          Hint = 'Start Time'
          Date = 37308.578132338000000000
          Time = 37308.578132338000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Kind = dtkTime
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnChange = acStartTimeChangedExecute
        end
      end
      object GroupBox3: TGroupBox
        Left = 352
        Top = 0
        Width = 167
        Height = 81
        Anchors = [akLeft, akTop, akBottom]
        Caption = ' &Queue To Run At: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object Label4: TLabel
          Left = 16
          Top = 27
          Width = 26
          Height = 13
          Caption = 'Date:'
          FocusControl = dtpPrintDate
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 16
          Top = 50
          Width = 26
          Height = 13
          Caption = 'Time:'
          FocusControl = dtpPrintTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dtpPrintDate: TDateTimePicker
          Left = 60
          Top = 25
          Width = 97
          Height = 21
          Hint = 'Run Date'
          Date = 37245.480350787000000000
          Time = 37245.480350787000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = acPrintDateChangedExecute
        end
        object dtpPrintTime: TDateTimePicker
          Left = 60
          Top = 49
          Width = 97
          Height = 21
          Hint = 'Run Time'
          Date = 37308.578132338000000000
          Time = 37308.578132338000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Kind = dtkTime
          ParentFont = False
          TabOrder = 1
          OnChange = acPrintDateChangedExecute
        end
      end
      object gbEnd: TGroupBox
        Left = 191
        Top = 0
        Width = 163
        Height = 81
        Anchors = [akLeft, akTop, akBottom]
        Caption = ' Date Range &End: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object lblEndTime: TLabel
          Left = 16
          Top = 50
          Width = 26
          Height = 13
          Caption = 'Time:'
          FocusControl = dtpToTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblEndDate: TLabel
          Left = 16
          Top = 27
          Width = 26
          Height = 13
          Caption = 'Date:'
          FocusControl = dtpToDate
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object dtpToDate: TDateTimePicker
          Left = 50
          Top = 23
          Width = 97
          Height = 21
          Hint = 'End Date'
          Date = 37245.445742604200000000
          Time = 37245.445742604200000000
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = acStopDateChangedExecute
        end
        object dtpToTime: TDateTimePicker
          Left = 49
          Top = 47
          Width = 97
          Height = 21
          Hint = 'End Time'
          Date = 37308.578132338000000000
          Time = 37308.578132338000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Kind = dtkTime
          ParentFont = False
          TabOrder = 1
          OnChange = acEndTimeChangedExecute
        end
      end
    end
    object Panel3: TPanel
      Left = 5
      Top = 68
      Width = 525
      Height = 118
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        525
        118)
      object GroupBox1: TGroupBox
        Left = 7
        Top = 0
        Width = 513
        Height = 118
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = ' &Include Patient(s): '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object WardLabel: TLabel
          Left = 40
          Top = 69
          Width = 29
          Height = 13
          Caption = '&Ward:'
          Enabled = False
          FocusControl = cmbWard
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object RoomLabel: TLabel
          Left = 40
          Top = 92
          Width = 31
          Height = 13
          Caption = 'R&oom:'
          Enabled = False
          FocusControl = edRoomList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object rbPatient: TRadioButton
          Left = 14
          Top = 22
          Width = 487
          Height = 17
          Caption = '&Patient'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = True
          OnClick = acScopeChangedExecute
        end
        object rbAllPatients: TRadioButton
          Left = 13
          Top = 50
          Width = 113
          Height = 17
          Caption = 'Patients &Located at: '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = acScopeChangedExecute
        end
        object cmbWard: TComboBox
          Left = 84
          Top = 64
          Width = 417
          Height = 21
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnChange = acWardChangedExecute
        end
        object edRoomList: TEdit
          Left = 84
          Top = 89
          Width = 337
          Height = 21
          Color = clBtnFace
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object btnSelect: TButton
          Left = 425
          Top = 89
          Width = 75
          Height = 21
          Caption = 'Se&lect...'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = btnSelectClick
        end
      end
    end
  end
  object ActionList1: TActionList
    Left = 24
    Top = 385
    object acReportCh: TAction
      Caption = 'acReportCh'
      OnExecute = acReportChanged
    end
    object acScopeChanged: TAction
      Caption = 'acScopeChanged'
      OnExecute = acScopeChangedExecute
    end
    object acWardChanged: TAction
      Caption = 'acWardChanged'
      OnExecute = acWardChangedExecute
    end
    object acPrintReport: TAction
      Caption = 'Print'
      Enabled = False
      OnExecute = acPrintReportExecute
    end
    object acStartDate: TAction
      Caption = 'acStartDate'
      OnExecute = acStartDateChanged
    end
    object acStopDateChanged: TAction
      Caption = 'acStopDateChanged'
      OnExecute = acStopDateChangedExecute
    end
    object acUPdateDTPColors: TAction
      Caption = 'acUPdateDTPColors'
      OnExecute = acUPdateDTPColorsExecute
    end
    object acStartTimeChanged: TAction
      Caption = 'acStartTimeChanged'
      OnExecute = acStartTimeChangedExecute
    end
    object acEndTimeChanged: TAction
      Caption = 'acEndTimeChanged'
      OnExecute = acEndTimeChangedExecute
    end
    object acPrinTimeChanged: TAction
      Caption = 'acPrinTimeChanged'
    end
    object acPrintDateChanged: TAction
      Caption = 'acPrintDateChanged'
      OnExecute = acPrintDateChangedExecute
    end
    object acSearch: TAction
      Caption = '&Search'
      OnExecute = acSearchExecute
    end
  end
  object tmDevice: TTimer
    Enabled = False
    OnTimer = tmDeviceTimer
    Left = 24
    Top = 357
  end
end
