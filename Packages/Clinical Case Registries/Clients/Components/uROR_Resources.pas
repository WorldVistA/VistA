unit uROR_Resources;

interface

uses
  Controls, Forms, Graphics, ImgList, SysUtils;

resourcestring

  rscAddHint         = 'Add|Add selected item(s) to the list';
  rscAddAllHint      = 'Add All|Add all items to the list';
  rscBreakLink       = 'Break the Clinical Link';
  rscRemoveHint      = 'Remove|Remove selected item(s) from the list';
  rscRemoveAllHint   = 'Remove All|Clear the list';
  rscUseAppData      = 'Rejoin and Use Application Data';
  rscUseGlobalData   = 'Rejoin and Use Global Data';

  RSC0001            = 'CCOW Contextor';
  RSC0002            = 'Update the clinical context with the application''s data?';
  RSC0003            = 'Contextor has not been run and the application has not joined a context.';
  RSC0004            = 'Contextor has been run and the application is participating in a context.';
  RSC0005            = 'Contextor has been run but the application is not participating in a context.';
  RSC0006            = 'Cannot determine the contextor state.';

  RSC0010            = 'Search pattern should contain at least %d character(s).';
  RSC0011            = 'Invalid search pattern.';
  RSC0012            = 'Start Search';
  RSC0013            = 'Cancel Search';

  RSC0020            = 'Field value cannot be converted to Date/Time.';
  RSC0021            = 'Value should not be longer than %d characters. Truncate?';

  RSC0030            = 'The "%s" item is already selected in the "%s".';

var
  bmAdd:          TBitmap    = nil;
  bmAddAll:       TBitmap    = nil;
  bmRemove:       TBitmap    = nil;
  bmRemoveAll:    TBitmap    = nil;
  bmSearchCancel: TBitmap    = nil;
  bmSearchStart:  TBitmap    = nil;

procedure LoadCCREditSearchResources;
procedure LoadCCRSelectorResources;

implementation
{$R *.res}

procedure LoadCCREditSearchResources;
begin
  if Assigned(bmSearchStart) then Exit;

  bmSearchCancel := TBitmap.Create;
  bmSearchStart  := TBitmap.Create;

  bmSearchCancel.LoadFromResourceName(HInstance, 'BTN_CANCEL');
  bmSearchStart.LoadFromResourceName(HInstance,  'BTN_SEARCH');
end;

procedure LoadCCRSelectorResources;
begin
  if Assigned(bmAdd) then Exit;

  bmAdd       := TBitmap.Create;
  bmAddAll    := TBitmap.Create;
  bmRemove    := TBitmap.Create;
  bmRemoveAll := TBitmap.Create;

  bmAdd.LoadFromResourceName(HInstance, 'BTN_ADD');
  bmAddAll.LoadFromResourceName(HInstance, 'BTN_ADDALL');
  bmRemove.LoadFromResourceName(HInstance, 'BTN_REMOVE');
  bmRemoveAll.LoadFromResourceName(HInstance, 'BTN_REMOVEALL');
end;

initialization
finalization
  FreeAndNil(bmAdd);
  FreeAndNil(bmAddAll);
  FreeAndNil(bmRemove);
  FreeAndNil(bmRemoveAll);

end.
