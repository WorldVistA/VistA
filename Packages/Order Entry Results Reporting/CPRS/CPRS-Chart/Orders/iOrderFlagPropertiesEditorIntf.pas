unit iOrderFlagPropertiesEditorIntf;
{ Order Properties editor interface }
{------------------------------------------------------------------------------
Update History
    2016-05-17: NSR#20110719 (Order Flag Recommendations)
-------------------------------------------------------------------------------}
interface

uses
  System.Classes;

type
  IOrderFlagPropertiesEditor = Interface(IInterface)
   ['{21D66B04-9176-4E2E-A6D5-18269EFE6949}']
    function IsValidArray(anArray: Array of Integer):Boolean;
    procedure setGUIByObject(anObject:TObject);
    procedure setGUIByMultipleObjects(aList:TObject);

    procedure setDebugView(aValue:Boolean);
  end;

implementation

end.
