object frmGMV_HospitalSelector2: TfrmGMV_HospitalSelector2
  Left = 453
  Top = 236
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Hospital Location Selector'
  ClientHeight = 384
  ClientWidth = 578
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
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 343
    Width = 578
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      578
      41)
    object lblLeft: TLabel
      Left = 8
      Top = 16
      Width = 123
      Height = 13
      Caption = '                                         '
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Visible = False
    end
    object btnOK: TButton
      Left = 420
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Select'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 494
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pcMain: TPageControl
    Left = 0
    Top = 41
    Width = 578
    Height = 302
    ActivePage = tsByName
    Align = alClient
    TabIndex = 2
    TabOrder = 1
    OnChange = pcMainChange
    object tsByApointment: TTabSheet
      Caption = 'A&ppointments'
      ImageIndex = 1
      object lvAppt: TListView
        Left = 0
        Top = 89
        Width = 570
        Height = 185
        Align = alClient
        Color = clInfoBk
        Columns = <
          item
            Caption = 'Clinic (T-365 thru T)'
            Width = 250
          end
          item
            Width = 0
          end
          item
            Caption = 'Date/Time'
            Width = 150
          end>
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvHChange
        OnDblClick = lvHDblClick
        OnKeyDown = lvHKeyDown
      end
      object pnlApptTest: TPanel
        Left = 0
        Top = 0
        Width = 570
        Height = 89
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          570
          89)
        object sbFindAppt: TSpeedButton
          Left = 4
          Top = 0
          Width = 37
          Height = 22
          Caption = 'Find'
          OnClick = sbFindApptClick
        end
        object Label2: TLabel
          Left = 64
          Top = 0
          Width = 22
          Height = 13
          Caption = 'DFN'
        end
        object Label3: TLabel
          Left = 64
          Top = 24
          Width = 23
          Height = 13
          Caption = 'From'
        end
        object Label4: TLabel
          Left = 64
          Top = 40
          Width = 13
          Height = 13
          Caption = 'To'
        end
        object Label5: TLabel
          Left = 64
          Top = 59
          Width = 20
          Height = 13
          Caption = 'Flag'
        end
        object edDFN: TEdit
          Left = 112
          Top = 0
          Width = 449
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
        object edFrom: TEdit
          Left = 112
          Top = 20
          Width = 449
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
        end
        object edTo: TEdit
          Left = 112
          Top = 39
          Width = 449
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
        end
        object edFlag: TEdit
          Left = 112
          Top = 58
          Width = 449
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 3
        end
      end
    end
    object tsAdmissions: TTabSheet
      Caption = 'Ad&missions'
      ImageIndex = 2
      object pnlAdmitTest: TPanel
        Left = 0
        Top = 0
        Width = 570
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          570
          41)
        object sbFindAdmit: TSpeedButton
          Left = 4
          Top = 0
          Width = 37
          Height = 22
          Caption = 'Find'
          OnClick = sbFindAdmitClick
        end
        object Label6: TLabel
          Left = 64
          Top = 4
          Width = 22
          Height = 13
          Caption = 'DFN'
        end
        object edAdmitDFN: TEdit
          Left = 112
          Top = 0
          Width = 449
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
      end
      object lvAdmit: TListView
        Left = 0
        Top = 41
        Width = 570
        Height = 233
        Align = alClient
        Color = clInfoBk
        Columns = <
          item
            Caption = 'Hospital Admissions'
            Width = 250
          end
          item
            Width = 0
          end
          item
            Caption = 'Date/Time'
            Width = 125
          end
          item
            Caption = 'Type'
            Width = 100
          end>
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
        OnChange = lvHChange
        OnDblClick = lvHDblClick
        OnKeyDown = lvHKeyDown
      end
    end
    object tsByName: TTabSheet
      Caption = '&Name'
      ImageIndex = 2
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 570
        Height = 274
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lvH: TListView
          Left = 0
          Top = 49
          Width = 570
          Height = 225
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 275
            end
            item
              Caption = 'ID'
              Width = 0
            end>
          FlatScrollBars = True
          HideSelection = False
          ReadOnly = True
          ShowColumnHeaders = False
          TabOrder = 1
          ViewStyle = vsReport
          OnChange = lvHChange
          OnDblClick = lvHDblClick
          OnEnter = lvHEnter
          OnExit = lvHExit
          OnKeyDown = lvHKeyDown
        end
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 570
          Height = 49
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            570
            49)
          object Label1: TLabel
            Left = 4
            Top = 1
            Width = 113
            Height = 13
            Caption = 'Enter &Hospital Location:'
          end
          object cmbTarget: TComboBox
            Left = 0
            Top = 20
            Width = 569
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = clInfoBk
            ItemHeight = 13
            TabOrder = 0
            OnChange = cmbTargetChange
            OnEnter = cmbTargetEnter
            OnExit = cmbTargetExit
            OnKeyDown = cmbTargetKeyDown
          end
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 578
    Height = 41
    Align = alTop
    TabOrder = 2
    Visible = False
    DesignSize = (
      578
      41)
    object Label7: TLabel
      Left = 10
      Top = 13
      Width = 75
      Height = 13
      Caption = 'New Selection: '
    end
    object edSelected: TEdit
      Left = 144
      Top = 10
      Width = 424
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object tmSearch: TTimer
    Enabled = False
    OnTimer = tmSearchTimer
    Left = 16
    Top = 136
  end
end
