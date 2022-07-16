unit iResizableFormIntf;
{------------------------------------------------------------------------------
Update History
    2016-05-17: NSR#20110719 (Order Flag Recommendations)
-------------------------------------------------------------------------------}
interface

uses
  System.Classes;

type
  IResizableForm = Interface(IInterface)
    ['{ABCA5D00-0446-41C6-B952-71C6D428E84A}']
    procedure ResizeToFont(aSize:Integer);
  end;

implementation

end.

