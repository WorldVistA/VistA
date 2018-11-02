object frGMV_PrinterSelector: TfrGMV_PrinterSelector
  Left = 0
  Top = 0
  Width = 543
  Height = 210
  TabOrder = 0
  object gbDevice: TGroupBox
    Left = 0
    Top = 0
    Width = 543
    Height = 210
    Align = alClient
    Caption = 'Device'
    TabOrder = 0
    OnEnter = gbDeviceEnter
    OnExit = gbDeviceExit
    DesignSize = (
      543
      210)
    object Panel1: TPanel
      Left = 2
      Top = 40
      Width = 539
      Height = 168
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        539
        168)
      object lvDevices: TListView
        Left = 96
        Top = 0
        Width = 437
        Height = 162
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clCream
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
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvDevicesChange
      end
    end
    object edTarget: TEdit
      Left = 98
      Top = 16
      Width = 436
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      OnChange = edTargetChange
      OnKeyUp = edTargetKeyUp
    end
  end
  object tmDevice: TTimer
    Enabled = False
    OnTimer = tmDeviceTimer
    Left = 56
    Top = 16
  end
end
