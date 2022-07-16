unit VA508AccessibilityConst;

interface

uses
  Windows, SysUtils;
  
// When a component receives focus, the screen reader needs to request data about the
// component.  The Call Back proc is called, and the VA app then supplies the info by
// returning the requested values

const
  JAWS_REQUIRED_VERSION     = '7.10.500';
  JAWS_APPLICATION_FILENAME = 'jfw.exe';
  
// flags sent to and from the screen reader
// if data is not sent from the app, then the screen reader should use it's default mechanism to
// read the data.
  DATA_ALL_BITS                  = $FFFFFF;

  DATA_NONE                      = $000000; // No flags set

  DATA_CAPTION                   = $000001; // Sent both ways indicating data requested / sent
  DATA_VALUE                     = $000002; // Sent both ways indicating data requested / sent
  DATA_CONTROL_TYPE              = $000004; // Sent both ways indicating data requested / sent
  DATA_STATE                     = $000008; // Sent both ways indicating data requested / sent
  DATA_INSTRUCTIONS              = $000010; // Sent both ways indicating data requested / sent
  DATA_ITEM_INSTRUCTIONS         = $000020; // Sent both ways indicating data requested / sent
  DATA_DATA                      = $000040; // Sent both ways indicating data requested / sent
  DATA_MASK_DATA                 = DATA_ALL_BITS - DATA_DATA;

  DATA_CHANGE_EVENT              = $001000; // Sent by app indicating am item or state change event
  DATA_MASK_CHANGE_EVENT         = DATA_ALL_BITS - DATA_CHANGE_EVENT;

  DATA_ITEM_CHANGED              = $002000; // in a change event, indicates a child item has changed

  DATA_CUSTOM_KEY_COMMAND        = $100000; // custom key command
  DATA_CUSTOM_KEY_COMMAND_MASK   = DATA_ALL_BITS - $100000; 

  DATA_ERROR                     = $800000; // component not found

const
  BEHAVIOR_ADD_DICTIONARY_CHANGE            = $0001; // pronounce a word differently
  BEHAVIOR_ADD_COMPONENT_CLASS              = $0002; // add assignment to treat a custom component class as a standard component class
  BEHAVIOR_REMOVE_COMPONENT_CLASS           = $0003; // remove assignment treat a custom component class as a standard component class
  BEHAVIOR_ADD_COMPONENT_MSAA               = $0004; // add assignment to use MSAA for class information
  BEHAVIOR_REMOVE_COMPONENT_MSAA            = $0005; // remove assignment to use MSAA for class information
  BEHAVIOR_ADD_CUSTOM_KEY_MAPPING           = $0006; // assign a custom key mapping
  BEHAVIOR_ADD_CUSTOM_KEY_DESCRIPTION       = $0007; // assign a custom key mapping Description
  BEHAVIOR_PURGE_UNREGISTERED_KEY_MAPPINGS  = $0008; // purge custom key mappings that were not assigned using BEHAVIOR_ADD_CUSTOM_KEY_MAPPING

const
  CLASS_BEHAVIOR_BUTTON       = 'Button';
  CLASS_BEHAVIOR_CHECK_BOX    = 'CheckBox';
  CLASS_BEHAVIOR_COMBO_BOX    = 'ComboBox';
  CLASS_BEHAVIOR_DIALOG       = 'Dialog';
  CLASS_BEHAVIOR_EDIT         = 'Edit';
  CLASS_BEHAVIOR_EDIT_COMBO   = 'EditCombo';
  CLASS_BEHAVIOR_GROUP_BOX    = 'GroupBox';
  CLASS_BEHAVIOR_LIST_VIEW    = 'ListView';
  CLASS_BEHAVIOR_LIST_BOX     = 'ListBox';
  CLASS_BEHAVIOR_TREE_VIEW    = 'TreeView';
  CLASS_BEHAVIOR_STATIC_TEXT  = 'StaticText';

const
  CRLF = #13#10;
  ERROR_INTRO =
    'In an effort to more fully comply with Section 508 of the Rehabilitation' + CRLF +
    'Act, the software development team has created a special Accessibility' + CRLF +
    'Framework that directly communicates with screen reader applications.' + CRLF + CRLF;

type
  TConfigReloadProc = procedure of object;
  TComponentDataRequestProc = procedure(WindowHandle: HWND; DataRequest: LongInt); stdcall;
  TVA508QueryProc = procedure(Sender: TObject; var Text: string);
  TVA508ListQueryProc = procedure(Sender: TObject; ItemIndex: integer; var Text: string);
  TVA508Exception = Exception;

implementation

end.
