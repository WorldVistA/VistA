object OvcfrmCalendarDlg: TOvcfrmCalendarDlg
  Left = 415
  Top = 258
  Width = 268
  Height = 202
  Caption = 'Calendar Dialog'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object TPanel
    Left = 0
    Top = 144
    Width = 260
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnHelp: TButton
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Help'
      TabOrder = 0
    end
    object TPanel
      Left = 95
      Top = 0
      Width = 165
      Height = 31
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object btnOK: TButton
        Left = 6
        Top = 4
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TButton
        Left = 88
        Top = 4
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 260
    Height = 144
    Align = alClient
    TabOrder = 0
    object OvcCalendar1: TOvcCalendar
      Left = 1
      Top = 1
      Width = 258
      Height = 142
      Align = alClient
      BorderStyle = bsNone
      Colors.ActiveDay = clRed
      Colors.ColorScheme = cscalCustom
      Colors.DayNames = clMaroon
      Colors.Days = clBlack
      Colors.InactiveDays = clGray
      Colors.MonthAndYear = clBlue
      Colors.Weekend = clRed
      DateFormat = dfLong
      DayNameWidth = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Default'
      Font.Style = [fsBold]
      Options = [cdoShortNames, cdoShowYear, cdoShowInactive, cdoShowRevert, cdoShowToday]
      ParentFont = False
      ReadOnly = False
      TabOrder = 0
      TabStop = True
      WantDblClicks = True
      WeekStarts = dtSunday
      OnDblClick = OvcCalendar1DblClick
    end
  end
end
