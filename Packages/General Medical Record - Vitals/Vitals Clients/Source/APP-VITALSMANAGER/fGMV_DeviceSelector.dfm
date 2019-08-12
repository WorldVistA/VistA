object frmGMV_DeviceSelector: TfrmGMV_DeviceSelector
  Left = 655
  Top = 185
  BorderStyle = bsDialog
  Caption = 'Device Selection'
  ClientHeight = 394
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 353
    Width = 549
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    object btnOK: TButton
      Left = 368
      Top = 8
      Width = 75
      Height = 25
      Caption = '&OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 453
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 549
    Height = 353
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 6
    TabOrder = 1
    object Panel1: TPanel
      Left = 6
      Top = 6
      Width = 537
      Height = 44
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object gbQueue: TGroupBox
        Left = 0
        Top = 0
        Width = 537
        Height = 44
        Align = alClient
        Caption = '  &Queue To Run at:'
        TabOrder = 0
        OnEnter = gbQueueEnter
        OnExit = gbQueueExit
        object dtpTime: TDateTimePicker
          Left = 208
          Top = 16
          Width = 96
          Height = 21
          CalAlignment = dtaLeft
          Date = 37391.3523091088
          Time = 37391.3523091088
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkTime
          ParseInput = False
          TabOrder = 1
          OnChange = dtpTimeChange
        end
        object dtpDate: TDateTimePicker
          Left = 96
          Top = 16
          Width = 105
          Height = 21
          CalAlignment = dtaLeft
          Date = 37391.3520092708
          Time = 37391.3520092708
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkDate
          ParseInput = False
          TabOrder = 0
          OnChange = dtpDateChange
        end
      end
    end
    inline fraPrinterSelector: TfrGMV_PrinterSelector
      Left = 6
      Top = 50
      Width = 537
      Height = 248
      Align = alClient
      TabOrder = 1
      inherited gbDevice: TGroupBox
        Width = 537
        Height = 248
        inherited Panel1: TPanel
          Width = 533
          Height = 203
          inherited lvDevices: TListView
            Width = 430
            Height = 199
          end
        end
        inherited edTarget: TEdit
          Width = 430
        end
      end
      inherited tmDevice: TTimer
        Left = 40
        Top = 24
      end
    end
    object Panel3: TPanel
      Left = 6
      Top = 298
      Width = 537
      Height = 49
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object gbSelected: TGroupBox
        Left = 0
        Top = 0
        Width = 537
        Height = 49
        Align = alClient
        Caption = 'Selected Device and Time'
        TabOrder = 0
        OnEnter = gbSelectedEnter
        OnExit = gbSelectedExit
        object edDevice: TEdit
          Left = 96
          Top = 16
          Width = 265
          Height = 19
          Ctl3D = False
          ParentColor = True
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 0
          Text = 'edDevice'
        end
        object edTime: TEdit
          Left = 368
          Top = 16
          Width = 161
          Height = 19
          Ctl3D = False
          ParentColor = True
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
          Text = 'leDevice'
        end
      end
    end
  end
end
