inherited fraVimmEditGrid: TfraVimmEditGrid
  Width = 672
  Height = 411
  ExplicitWidth = 672
  ExplicitHeight = 411
  inherited ScrollBox1: TScrollBox
    Width = 672
    Height = 411
    ExplicitWidth = 672
    ExplicitHeight = 411
    inherited pnlForm: TPanel
      Width = 668
      Height = 407
      Align = alTop
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 668
      ExplicitHeight = 407
      inherited grdEditPanel: TGridPanel
        Width = 668
        Height = 358
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 668
        ExplicitHeight = 358
      end
      inherited pnlButtons: TPanel
        Top = 358
        Width = 668
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 358
        ExplicitWidth = 668
        inherited btnSave: TButton
          Enabled = False
          Visible = False
        end
        inherited btnCancel: TButton
          Enabled = False
          Visible = False
        end
      end
    end
  end
end
