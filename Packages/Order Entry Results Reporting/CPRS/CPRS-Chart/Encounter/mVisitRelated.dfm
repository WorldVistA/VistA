object fraVisitRelated: TfraVisitRelated
  Left = 0
  Top = 0
  Width = 248
  Height = 188
  TabOrder = 0
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 248
    Height = 188
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 248
      Height = 181
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object gbVisitRelatedTo: TGroupBox
        Left = 0
        Top = 0
        Width = 248
        Height = 181
        Align = alClient
        Caption = 'Visit Related To'
        TabOrder = 0
        object chkSCYes: TCheckBox
          Tag = 1
          Left = 7
          Top = 33
          Width = 14
          Height = 17
          TabOrder = 0
          OnClick = chkClick
        end
        object chkAOYes: TCheckBox
          Tag = 2
          Left = 7
          Top = 65
          Width = 14
          Height = 17
          TabOrder = 4
          OnClick = chkClick
        end
        object chkIRYes: TCheckBox
          Tag = 3
          Left = 7
          Top = 81
          Width = 14
          Height = 17
          TabOrder = 6
          OnClick = chkClick
        end
        object chkECYes: TCheckBox
          Tag = 4
          Left = 7
          Top = 97
          Width = 14
          Height = 17
          TabOrder = 8
          OnClick = chkClick
        end
        object chkMSTYes: TCheckBox
          Tag = 5
          Left = 7
          Top = 129
          Width = 14
          Height = 17
          TabOrder = 12
          OnClick = chkClick
        end
        object chkMSTNo: TCheckBox
          Tag = 15
          Left = 27
          Top = 129
          Width = 71
          Height = 17
          Caption = 'MST    '
          TabOrder = 13
          OnClick = chkClick
        end
        object chkECNo: TCheckBox
          Tag = 14
          Left = 27
          Top = 97
          Width = 206
          Height = 17
          Caption = 'Southwest Asia Conditions     '
          TabOrder = 9
          OnClick = chkClick
        end
        object chkIRNo: TCheckBox
          Tag = 13
          Left = 27
          Top = 81
          Width = 206
          Height = 17
          Caption = 'Ionizing Radiation Exposure    '
          TabOrder = 7
          OnClick = chkClick
        end
        object chkAONo: TCheckBox
          Tag = 12
          Left = 27
          Top = 65
          Width = 206
          Height = 17
          Caption = 'Agent Orange Exposure   '
          TabOrder = 5
          OnClick = chkClick
        end
        object chkSCNo: TCheckBox
          Tag = 11
          Left = 27
          Top = 33
          Width = 206
          Height = 17
          Caption = 'Service Connected Condition   '
          TabOrder = 1
          OnClick = chkClick
        end
        object chkHNCYes: TCheckBox
          Tag = 6
          Left = 7
          Top = 145
          Width = 14
          Height = 17
          TabOrder = 14
          OnClick = chkClick
        end
        object chkHNCNo: TCheckBox
          Tag = 16
          Left = 27
          Top = 145
          Width = 206
          Height = 17
          Caption = 'Head and/or Neck Cancer   '
          TabOrder = 15
          OnClick = chkClick
        end
        object chkCVYes: TCheckBox
          Tag = 7
          Left = 7
          Top = 49
          Width = 14
          Height = 17
          TabOrder = 2
          OnClick = chkClick
        end
        object chkCVNo: TCheckBox
          Tag = 17
          Left = 27
          Top = 49
          Width = 206
          Height = 17
          Caption = 'Combat Vet (Combat Related)    '
          TabOrder = 3
          OnClick = chkClick
        end
        object chkSHDYes: TCheckBox
          Tag = 8
          Left = 7
          Top = 112
          Width = 14
          Height = 17
          TabOrder = 10
          OnClick = chkClick
        end
        object chkSHDNo: TCheckBox
          Tag = 18
          Left = 27
          Top = 112
          Width = 206
          Height = 17
          Caption = 'Shipboard Hazard and Defense   '
          TabOrder = 11
          OnClick = chkClick
        end
        object lblSCNo: TStaticText
          Left = 27
          Top = 16
          Width = 18
          Height = 13
          AutoSize = False
          Caption = 'No'
          TabOrder = 19
        end
        object lblSCYes: TStaticText
          Left = 4
          Top = 16
          Width = 22
          Height = 13
          AutoSize = False
          Caption = 'Yes'
          TabOrder = 18
        end
        object chkCLYes: TCheckBox
          Tag = 19
          Left = 7
          Top = 161
          Width = 144
          Height = 17
          TabOrder = 16
          Visible = False
          OnClick = chkClick
        end
        object chkCLNo: TCheckBox
          Tag = 20
          Left = 27
          Top = 161
          Width = 190
          Height = 17
          Caption = 'Camp Lejeune'
          TabOrder = 17
          Visible = False
          OnClick = chkClick
        end
      end
    end
  end
end
