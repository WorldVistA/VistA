inherited frmLabCollectTimes: TfrmLabCollectTimes
  Left = 332
  Top = 310
  BorderIcons = []
  Caption = 'Future Lab Collect Times'
  ClientHeight = 170
  ClientWidth = 439
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 455
  ExplicitHeight = 208
  PixelsPerInch = 96
  TextHeight = 13
  object lblFutureTimes: TMemo [0]
    Left = 211
    Top = 113
    Width = 129
    Height = 46
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Select a date and a routine '
      'lab collect time for that '
      'date.')
    ReadOnly = True
    TabOrder = 5
  end
  object calLabCollect: TORDateBox [1]
    Left = 241
    Top = 22
    Width = 158
    Height = 21
    TabOrder = 0
    Visible = False
    OnChange = calLabCollectChange
    DateOnly = True
    RequireTime = False
    Caption = ''
  end
  object lstLabCollTimes: TORListBox [2]
    Left = 210
    Top = 6
    Width = 218
    Height = 98
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Caption = ''
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
  end
  object cmdOK: TButton [3]
    Left = 353
    Top = 112
    Width = 75
    Height = 21
    Caption = 'OK'
    TabOrder = 2
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [4]
    Left = 353
    Top = 139
    Width = 75
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cmdCancelClick
  end
  object calMonth: TMonthCalendar [5]
    Left = 8
    Top = 5
    Width = 190
    Height = 153
    CalColors.TitleBackColor = clBtnFace
    CalColors.TitleTextColor = clBtnText
    CalColors.MonthBackColor = clWindow
    CalColors.TrailingTextColor = clGrayText
    Date = 36507.614243518520000000
    ShowTodayCircle = False
    TabOrder = 4
    TabStop = True
    OnClick = calMonthClick
    OnKeyDown = calMonthKeyDown
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblFutureTimes'
        'Status = stsDefault')
      (
        'Component = calLabCollect'
        'Text = Lab Collect Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = lstLabCollTimes'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = calMonth'
        'Status = stsDefault')
      (
        'Component = frmLabCollectTimes'
        'Status = stsDefault'))
  end
end
