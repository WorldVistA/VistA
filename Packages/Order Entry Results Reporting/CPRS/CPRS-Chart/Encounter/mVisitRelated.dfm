object fraVisitRelated: TfraVisitRelated
  Left = 0
  Top = 0
  Width = 206
  Height = 172
  TabOrder = 0
  object gbVisitRelatedTo: TGroupBox
    Left = 0
    Top = 0
    Width = 206
    Height = 172
    Align = alClient
    Caption = 'Visit Related To'
    TabOrder = 0
    object chkSCYes: TCheckBox
      Tag = 1
      Left = 7
      Top = 33
      Width = 14
      Height = 17
      Caption = 'Service Connected Condition     Yes'
      TabOrder = 0
      OnClick = chkClick
    end
    object chkAOYes: TCheckBox
      Tag = 2
      Left = 7
      Top = 65
      Width = 14
      Height = 17
      Caption = 'Agent Orange Exposure     Yes'
      TabOrder = 4
      OnClick = chkClick
    end
    object chkIRYes: TCheckBox
      Tag = 3
      Left = 7
      Top = 81
      Width = 14
      Height = 17
      Caption = 'Ionizing Radiation Exposure     Yes'
      TabOrder = 6
      OnClick = chkClick
    end
    object chkECYes: TCheckBox
      Tag = 4
      Left = 7
      Top = 97
      Width = 14
      Height = 17
      Caption = 'Southwest Asia Conditions     Yes'
      TabOrder = 8
      OnClick = chkClick
    end
    object chkMSTYes: TCheckBox
      Tag = 5
      Left = 7
      Top = 129
      Width = 14
      Height = 17
      Caption = 'MST     Yes'
      TabOrder = 12
      OnClick = chkClick
    end
    object chkMSTNo: TCheckBox
      Tag = 15
      Left = 27
      Top = 129
      Width = 40
      Height = 17
      Caption = 'MST     No'
      TabOrder = 13
      OnClick = chkClick
    end
    object chkECNo: TCheckBox
      Tag = 14
      Left = 27
      Top = 97
      Width = 148
      Height = 17
      Caption = 'Southwest Asia Conditions     No'
      TabOrder = 9
      OnClick = chkClick
    end
    object chkIRNo: TCheckBox
      Tag = 13
      Left = 27
      Top = 81
      Width = 154
      Height = 17
      Caption = 'Ionizing Radiation Exposure    No'
      TabOrder = 7
      OnClick = chkClick
    end
    object chkAONo: TCheckBox
      Tag = 12
      Left = 27
      Top = 65
      Width = 136
      Height = 17
      Caption = 'Agent Orange Exposure    No'
      TabOrder = 5
      OnClick = chkClick
    end
    object chkSCNo: TCheckBox
      Tag = 11
      Left = 27
      Top = 33
      Width = 158
      Height = 17
      Caption = 'Service Connected Condition    No'
      TabOrder = 1
      OnClick = chkClick
    end
    object chkHNCYes: TCheckBox
      Tag = 6
      Left = 7
      Top = 145
      Width = 14
      Height = 17
      Caption = 'Head and/or Neck Cancer    Yes'
      TabOrder = 14
      OnClick = chkClick
    end
    object chkHNCNo: TCheckBox
      Tag = 16
      Left = 27
      Top = 145
      Width = 144
      Height = 17
      Caption = 'Head and/or Neck Cancer    No'
      TabOrder = 15
      OnClick = chkClick
    end
    object chkCVYes: TCheckBox
      Tag = 7
      Left = 7
      Top = 49
      Width = 14
      Height = 17
      Caption = 'Combat Vet (Combat Related)     Yes'
      TabOrder = 2
      OnClick = chkClick
    end
    object chkCVNo: TCheckBox
      Tag = 17
      Left = 27
      Top = 49
      Width = 165
      Height = 17
      Caption = 'Combat Vet (Combat Related)    No'
      TabOrder = 3
      OnClick = chkClick
    end
    object chkSHDYes: TCheckBox
      Tag = 8
      Left = 7
      Top = 112
      Width = 14
      Height = 17
      Caption = 'Shipboard Hazard and Defense     Yes'
      TabOrder = 10
      OnClick = chkClick
    end
    object chkSHDNo: TCheckBox
      Tag = 18
      Left = 27
      Top = 112
      Width = 168
      Height = 17
      Caption = 'Shipboard Hazard and Defense     No'
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
      TabOrder = 17
    end
    object lblSCYes: TStaticText
      Left = 4
      Top = 16
      Width = 22
      Height = 13
      AutoSize = False
      Caption = 'Yes'
      TabOrder = 16
    end
  end
end
