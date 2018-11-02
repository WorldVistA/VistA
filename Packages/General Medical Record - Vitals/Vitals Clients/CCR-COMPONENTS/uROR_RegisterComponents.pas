unit uROR_RegisterComponents;
{$I Components.inc}

interface

procedure Register;

implementation

uses
  Classes, uROR_CustomControls, uROR_Selector, uROR_VistAStore, uROR_State,
  uROR_Contextor, uROR_ParamsPanel, uROR_ListView, uROR_GridView,
  uROR_SelectorTree, uROR_AdvColGrid, uROR_SearchEdit, uROR_TreeGrid,
  uROR_DrugSelector, uROR_SelectorGrid;

procedure Register;
begin
  RegisterComponents('CCR',
  [
    //--- CCR custom components
    {$IFNDEF NOTMSPACK}
    TCCRAdvColGrid,
    TCCRSelectorGrid,
    {$ENDIF}
    TCCRCBGroup,
    TCCRComponentState,
    TCCRContextor,
    TCCRContextorIndicator,
    TCCRFormState,
    TCCRGridView,
    TCCRListView,
    TCCRParamsPanel,
    TCCRSearchEdit,
    TCCRSelector,
    {$IFNDEF NOVTREE}
    TCCRSelectorTree,
    TCCRTreeGrid,
    TCCRDrugSelector,
    {$ENDIF}
    TCCRToolBar,
    TCCRVistASearchEdit,
    TCCRVistAStore

    //--- Third-party freeware components
  ]);
end;

end.
