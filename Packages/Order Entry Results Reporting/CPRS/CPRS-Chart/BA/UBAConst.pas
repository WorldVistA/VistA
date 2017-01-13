unit UBAConst;
 
{$OPTIMIZATION OFF}

interface
 
const

  BUFFER_ORDER_ID = '9999999999';
 
  CARET = '^';
  NOT_APPLICABLE          = 'N/A';
  
  ENCOUNTER_TODAYS_DX     = '^Diagnoses from Today''s Orders'; //BAPHII 1.3.10
  ENCOUNTER_PERSONAL_DX   = '^Personal Diagnoses List Items';
  DX_PROBLEM_LIST_TXT     = 'Problem List Items';
  DX_PERSONAL_LIST_TXT    = 'Personal Diagnoses List Items';
  DX_ENCOUNTER_LIST_TXT   = 'Encounter Form Diagnoses';
  DX_TODAYS_DX_LIST_TXT   = 'Diagnoses from Today''s Orders';

  MIN_SC_CONDITION = 0;
  MAX_SC_CONDITION = 0;
  BILLABLE_ORDER = '1';
  SERVICE_CONNECTED       = 'SC';
  NOT_SERVICE_CONNECTED   = 'NSC';
  AGENT_ORANGE            = 'AO';
  IONIZING_RADIATION      = 'IR';
  ENVIRONMENTAL_CONTAM    = 'EC';
  HEAD_NECK_CANCER        = 'HNC';
  MILITARY_SEXUAL_TRAUMA  = 'MST';
  COMBAT_VETERAN          = 'CV';
  SHIPBOARD_HAZARD_DEFENSE= 'SHD';
  CAMP_LEJEUNE            = 'CL';

  MAX_DX = 4;
  DXREC_INIT_FIELD_VAL        = '';
  UNSIGNED_REC_INIT_FIELD_VAL = '';
 
  PRIMARY_DX = 'Primary';
  SECONDARY_DX = 'Secondary';

  //Form identifiers
  F_ORDERS_SIGN  = 1;
  F_REVIEW       = 2;
  F_CONSULTS     = 3;
  // Order Status

  BAOK2SIGN = 1;
  DISCONTINUED = 5;
  MIN_RECT = 0;
  MAX_RECT = 199;

  ADD_TO_PROBLEM_LIST     = 'PL';
  ADD_TO_PERSONAL_DX_LIST = 'PD';
  BA_INACTIVE_CODE =  '#';


 
implementation
 
end.
 
  
