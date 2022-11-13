unit UBAMessages;

{$OPTIMIZATION OFF}
{.$define debug}

interface

const

  //CPRS User Messages
  BA_MAX_DX_ALLOWED             = 'Can Not Add Diagnosis' + #13 +
                                   'Reason: Maximum (4) diagnoses have already been applied to this order.' + #13 +
                                   'You may use the ''Diagnosis Editor'' to manage diagnoses for order(s).';
  BA_NO_ORDERS_SELECTED         = 'No orders have been selected.  Select one or more orders to be signed.';
  BA_CONFIRM_DX_OVERWRITE       = '''Lookup Diagnoses'' action will overwrite any existing diagnoses for selected orders.'+#13+'Do you wish to proceed?';
  BA_MAX_DX                     = 'A maximum of 4 diagnosis can be selected';
  BA_BILLING_DATA_SAVE_FAILED   = 'Error: Billing data was not saved';

  BA_NA_COPY_DISALLOWED         = 'Can''t copy ''N/A'' orders.  Select non-''N/A'' order(s), and retry the copy.';
  BA_NA_PASTE_DISALLOWED        = 'Selected Diagnoses will not be pasted to orders flagged with N/A.';

  BA_ONE_ORDER_ONLY             = 'Only 1 order at a time may be selected for copying';
  BA_PERSONAL_LIST_UPDATED      = 'Personal Diagnoses List Updated.';
  BA_NO_BILLABLE_ORDERS         = 'No billable orders have been selected.';

  BA_INACTIVE_CODE              = 'Inactive Code';
  BA_INACTIVE_ICD9_CODE_1       = 'The diagnosis code (';
  BA_INACTIVE_ICD9_CODE_2       = ') is not active as of today''s date,' + #13#10+
                                  'Please select another.';
  BA_DATA_NOT_REQD              = '9';
  BA_DUP_DX                     = 'Duplicate Diagnosis.';
  BA_DUP_DX_DISALLOWED_1        = 'Diagnosis (';
  BA_DUP_DX_DISALLOWED_2        = ') has already been selected.'; 



implementation

end.
