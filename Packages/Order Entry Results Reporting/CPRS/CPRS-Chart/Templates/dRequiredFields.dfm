object dmRF: TdmRF
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object cdsControls: TClientDataSet
    PersistDataPacket.Data = {
      0E0100009619E0BD01000000180000000D0000000000030000000E0104416273
      59040001000000000004416273580400010000000000084354524C5F4F424A08
      000100000000000E4354524C5F464F43555341424C4502000300000000000C46
      4C445F5245515549524544020003000000000003546167040001000000000003
      546F700400010000000000044C656674040001000000000007464C445F4F424A
      040001000000000003464C44040001000000000006464C445F49440400010000
      00000008464C445F4E414D450100490000000100055749445448020002005000
      05436C617373010049000000010005574944544802000200780001000D444546
      41554C545F4F524445520200820000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'AbsY'
        DataType = ftInteger
      end
      item
        Name = 'AbsX'
        DataType = ftInteger
      end
      item
        Name = 'CTRL_OBJ'
        DataType = ftLargeint
      end
      item
        Name = 'CTRL_FOCUSABLE'
        DataType = ftBoolean
      end
      item
        Name = 'FLD_REQUIRED'
        DataType = ftBoolean
      end
      item
        Name = 'Tag'
        DataType = ftInteger
      end
      item
        Name = 'Top'
        DataType = ftInteger
      end
      item
        Name = 'Left'
        DataType = ftInteger
      end
      item
        Name = 'FLD_OBJ'
        DataType = ftInteger
      end
      item
        Name = 'FLD'
        DataType = ftInteger
      end
      item
        Name = 'FLD_ID'
        DataType = ftInteger
      end
      item
        Name = 'FLD_NAME'
        DataType = ftString
        Size = 80
      end
      item
        Name = 'Class'
        DataType = ftString
        Size = 120
      end>
    IndexDefs = <
      item
        Name = 'DEFAULT_ORDER'
      end
      item
        Name = 'CHANGEINDEX'
      end>
    IndexFieldNames = 'AbsY;AbsX'
    Params = <>
    StoreDefs = True
    Left = 32
    Top = 21
    object cdsControlsAbsY: TIntegerField
      FieldName = 'AbsY'
    end
    object cdsControlsAbsX: TIntegerField
      FieldName = 'AbsX'
    end
    object cdsControlsCTRL_OBJ: TLargeintField
      DisplayWidth = 10
      FieldName = 'CTRL_OBJ'
    end
    object cdsControlsCTRL_FOCUSABLE: TBooleanField
      FieldName = 'CTRL_FOCUSABLE'
    end
    object cdsControlsFLD_REQUIRED: TBooleanField
      FieldName = 'FLD_REQUIRED'
    end
    object cdsControlsTag: TIntegerField
      FieldName = 'Tag'
      Visible = False
    end
    object cdsControlsTop: TIntegerField
      FieldName = 'Top'
      Visible = False
    end
    object cdsControlsLeft: TIntegerField
      FieldName = 'Left'
      Visible = False
    end
    object cdsControlsFLD_OBJ: TIntegerField
      FieldName = 'FLD_OBJ'
    end
    object cdsControlsFLD: TIntegerField
      DisplayWidth = 5
      FieldName = 'FLD'
    end
    object cdsControlsFLD_ID: TIntegerField
      DisplayWidth = 5
      FieldName = 'FLD_ID'
    end
    object cdsControlsFLD_NAME: TStringField
      DisplayWidth = 20
      FieldName = 'FLD_NAME'
      Size = 80
    end
    object cdsControlsClass: TStringField
      DisplayWidth = 40
      FieldName = 'Class'
      Size = 120
    end
  end
  object dsControls: TDataSource
    DataSet = cdsControls
    Left = 32
    Top = 69
  end
end
