unit uGraphs;

interface

uses
  SysUtils, Classes, Graphics, ORFn;

type
  TGraphSetting = class
  public
    ClearBackground: boolean;
    DateRangeInpatient: string;
    DateRangeOutpatient: string;
    Dates: boolean;
    FixedDateRange: boolean;
    FMStartDate: double;
    FMStopDate: double;
    Gradient: boolean;
    HighTime: TDateTime;
    Hints: boolean;
    HorizontalZoom: boolean;
    ItemsDisplayed: TStrings;
    ItemsForDisplay: TStrings;
    Legend: boolean;
    Lines: boolean;
    LowTime: TDateTime;
    MaxGraphs: integer;
    MaxSelect: integer;
    MaxSelectMin: integer;
    MaxSelectMax: integer;
    MergeLabs: boolean;
    MinGraphHeight: integer;
    OptionSettings: string;              // only used for storage
    Points: boolean;
    SortByType: boolean;
    SortColumn: integer;
    Sources: TStrings;
    StayOnTop: boolean;
    Turbo: boolean;
    Values: boolean;
    VerticalZoom: boolean;
    View3D: boolean;
  end;

  TGraphActivity = class
  public
    CurrentSetting: string;
    OldDFN: string;
    PublicSetting: string;
    PersonalSetting: string;
    PublicEditor: boolean;
    Status: string;
    TurboOn: boolean;
    Cache: boolean;
  end;

const
  BIG_NUMBER = 9999999;
  BIG_SPACES = '                                                                ';
  FM_START_DATE = 2500101;
  FM_STOP_DATE = 3500101;
  MAX_ITEM_DISCLAIMER = 10;
  NUM_COLORS = 16;
  PROB_HEIGHT = 2;
  RX_HEIGHT_IN = 12;
  RX_HEIGHT_NVA = 9;
  RX_HEIGHT_OUT = 15;
  ZOOM_PERCENT = 95;
  GRAPH_FLOAT = 'F';
  GRAPH_REPORT = 'R';
  POINT_PADDING = 0.03;              // assume a point height of 3%
  LLS_FRONT  = '^____[';
  LLS_BACK  = ']___________________________________________________________________________________________________________';


    // settings use single character
  SETTING_3D = 'A';
  SETTING_CLEAR = 'B';
  SETTING_DATES = 'C';
  SETTING_GRADIENT = 'D';
  SETTING_HINTS = 'E';
  SETTING_LEGEND = 'F';
  SETTING_LINES = 'G';
  SETTING_SORT = 'H';
  SETTING_TOP = 'I';
  SETTING_VALUES = 'J';
  SETTING_HZOOM = 'K';
  SETTING_VZOOM = 'L';
  SETTING_FIXED = 'M';
  SETTING_TURBO = 'N';
  SETTING_MERGELABS = 'O';

  // keypress flags
  KEYPRESS_ON = 'YES';
  KEYPRESS_OFF = 'NO';

  // format date/time axis
  DFORMAT_MDY = 'm/d/yyyy';
  DFORMAT_MYY = 'm/yy';
  DFORMAT_YY = 'yy';
  DWIDTH_MDY = 66;
  DWIDTH_MYY = 30;
  DWIDTH_YY = 18;

  // text messages
  TXT_COMMENTS = '** comments';
  TXT_COPY_DISCLAIMER = 'Note: Graphs display limited data, view details for more information.';
  TXT_DISCLAIMER = 'Due to number of items and size restrictions on your display, '
    + 'all items may not be visible.';
  TXT_INFO = 'Select multiple items using Ctrl-click or Shift-click.';
  TXT_NONNUMERICS = 'free-text values:';
  TXT_NOGRAPHING = 'CPRS is not configured for graphing.';
  TXT_PRINTING = 'Graphs are being printed';
  TXT_REPORT_DISCLAIMER = 'Note: Listing displays limited data, view details for more information.';
  TXT_VIEW_DEFINITION = 'View Definition';
  TXT_WARNING = 'Warning: You are using graph settings with a Special Function.';
  TXT_WARNING_CHECK_RESULTS = '** Please check results for this item by viewing Details. **';
  TXT_WARNING_MERGED_LABS = 'Warning: *Lab test results may have different reference ranges.';
  TXT_WARNING_SAME_TIME = 'Warning: Items have multiple occurrences at the same time.';
  TXT_ZOOMED = 'Zoomed Date Range: ';

  // views
  VIEW_CURRENT = '-999';
  VIEW_LABS = '-3';
  VIEW_PERSONAL = '-1';
  VIEW_PUBLIC = '-2';
  VIEW_TEMPORARY = '-888';

  COLOR_INFO = clCream;
  COLOR_PRINTING = clMoneyGreen;    //$CCFFFF; $CCCCFF; $CCFFCC; $FFCCCC; $FFCCFF; $FFFFCC;
  COLOR_WARNING = clCream;  //clFuchsia;
  COLOR_ZOOM = clCream;  //clSkyBlue;

  // hint messages for view definition
  HINT_PAT_SOURCE     = 'Only items where the patient has data are displayed.'
                + #13 + 'Use this for selecting items to display on the graph.';
  HINT_ALL_SOURCE     = 'All possible items are displayed.'
                + #13 + 'Use this for defining items to be displayed/saved as Views.'
                + #13 + 'Note: For easy use, select Views for graphing.';
  HINT_SELECTION_INFO = 'This form is primarily used for defining views.'
                + #13 + 'Usually selection is done by selecting Views or Items to graph.'
                + #13 + 'This form defines views.'
                + #13 + 'The Settings form defines items that are always selectable for graphing.';
  HINT_SOURCE         = 'These are the different types of data.'
                + #13 + 'Types are followed by a section showing your Personal Views, then Public Views.'
                + #13 + 'Click a type and then select individual items'
                + #13 + 'Double-click a type to select all items of this type  - <any>';
  HINT_OTHER_SOURCE   = 'These are Views and Lab Groups of other users.'
                + #13 + 'Use these for defining items to be displayed/saved as Views.'
                + #13 + 'Note: Select a Person to display their views and lab groups.';
  HINT_OTHERS         = 'Select other users to see their views or lab groups.'
                + #13 + 'Use these for defining items to be displayed/saved as Views.';
  HINT_BTN_DEFINITION = 'Click to display the definitions of all selections.'
                + #13 + 'Definitions show the items that make up a view or lab group.'
                + #13 + 'This includes views and lab groups of another user you have selected.';
  HINT_SELECTION      = 'Select specific items and move them to the right.'
                + #13 + 'Use the arrow buttons or double click.'
                + #13 + 'Selecting a type <any> will use all patients for that type.';
  HINT_DISPLAY        = 'This is the list of items, types, and/or views that compose the View that will be graphed.'
                + #13 + 'You can save this as a personal view by clicking the Save Personal button.';
  HINT_BTN_ADDALL     = 'Click to add all items for display.';
  HINT_BTN_ADD1       = 'Click to add this item for display (or double-click item).';
  HINT_BTN_REMOVE1    = 'Click to remove this item from display (or double-click item).';
  HINT_BTN_REMOVEALL  = 'Click to remove all items from display.';
  HINT_BTN_CLEAR      = 'Click to clear the Items and Items for Graphing lists.';
  HINT_BTN_DELETE     = 'Click to delete the selected view.';
  HINT_BTN_RENAME     = 'Click to rename the selected view.';
  HINT_BTN_SAVE       = 'Click to save your view.'
                + #13 + 'You will give this view a name that can be selected from the graph.';
  HINT_BTN_SAVE_PUB   = 'Click to save a public view (available to editors only).'
                + #13 + 'Public views can be selected by all users.';
  HINT_APPLY          = 'Select the section where you want to display the graph.';
  HINT_BTN_CLOSE      = 'Click to display items for graphing.'
                + #13 + 'Note: If you are using this from the Options menu, '
                + #13 + 'items are not displayed (multiple graphs may be in use).'
                + #13 + 'You should save any view definitions before closing this form.';

  // hint messages for settings
  SHINT_SOURCES     = 'This is a list of all the types of data that can be graphed.'
              + #13 + 'Check the types you wish to be selectable on the graph.'
              + #13 + 'It is best to only check the types that you frequently use.'
              + #13 + 'If you select a view on the graph that has types defined that are not checked,'
              + #13 + 'that type of data will become automatically checked.'
              + #13 + 'Note: Data is only selectable if the patient has that type of data';
  SHINT_OPTIONS     = 'Check options to change the appearance and behavior of the graph.'
              + #13 + 'Common options are also available on the graph''s right-click menu';
  SHINT_MAX =         'Enter the maximum number of graphs to appear on the screen.'
              + #13 + 'This is used when individual graphs are displayed and'
              + #13 + 'applies to both the top and bottom sections.'
              + #13 + 'When the number of graphs exceeds this limited, the graphs are available by scrolling.';
  SHINT_MIN         = 'Enter the minimum height of a graph (this is in pixels).'
              + #13 + 'This will depend on the size of your display.'
              + #13 + 'This setting assures that at least this amount of height will appear on the graph.'
              + #13 + 'Use in combination with Max Graphs in Display.';
  SHINT_MAX_ITEMS   = 'Enter the maximum number of items that can be graphed at one time.'
              + #13 + 'This setting prevents you from mistakenly selecting a large number of items.';
  SHINT_OUTPT       = 'Select the default date range when initially opening graphs.'
              + #13 + 'This setting is used if the patient is currently an outpatient.';
  SHINT_INPT        = 'Select the default date range when initially opening graphs.'
              + #13 + 'This setting is used if the patient is currently an inpatient.';
  SHINT_FUNCTIONS   = 'These functions are restricted to editors for evaluation.';
  SHINT_BTN_SHOW    = 'Click these buttons to display default settings.';
  SHINT_BTN_PER     = 'Click to display your personal settings.';
  SHINT_BTN_PUB     = 'Click to display the default settings.'
              + #13 + 'These settings are used when you have not saved a personal setting.';
  SHINT_BTN_SAVE    = 'Click these buttons to save default settings.';
  SHINT_BTN_PERSAVE = 'Click to save your personal defaults';
  SHINT_BTN_PUBSAVE = 'Click to save the public default (available to editors only).';
  SHINT_BTN_ALL     = 'Click to check all sources.';
  SHINT_BTN_CLEAR   = 'Click to uncheck all sources.';
  SHINT_BTN_CLOSE   = 'Click to display these settings for graphing.'
              + #13 + 'To cancel any unsaved changes you''ve made, click the upper-right x box.'
              + #13 + 'Note: If you are using this from the Options menu, '
              + #13 + 'settings will not change your display (multiple graphs may be in use).'
              + #13 + 'You should save any settings before closing this form.';

function GraphSettingsInit(settings: string): TGraphSetting;

implementation

function GraphSettingsInit(settings: string): TGraphSetting;
var
  FGraphSetting: TGraphSetting;
begin
  FGraphSetting := TGraphSetting.Create;
  with FGraphSetting do
  begin
    OptionSettings := Piece(settings, '|', 2);
    SortColumn := strtointdef(Piece(settings, '|', 3), 0);
    MaxGraphs := strtointdef(Piece(settings, '|', 4), 5);
    MinGraphHeight := strtointdef(Piece(settings, '|', 5), 90);
    MaxSelect := strtointdef(Piece(settings, '|', 7), 100);
    MaxSelectMin := 1;
    MaxSelectMax := strtointdef(Piece(settings, '|', 8), 1000);
    Values := Pos(SETTING_VALUES, OptionSettings) > 0;
    VerticalZoom := Pos(SETTING_VZOOM, OptionSettings) > 0;
    HorizontalZoom := Pos(SETTING_HZOOM, OptionSettings) > 0;
    View3D := Pos(SETTING_3D, OptionSettings) > 0;
    Legend := Pos(SETTING_LEGEND, OptionSettings) > 0;
    Dates := Pos(SETTING_DATES, OptionSettings) > 0;
    Lines := Pos(SETTING_LINES, OptionSettings) > 0;
    StayOnTop := Pos(SETTING_TOP, OptionSettings) > 0;
    SortByType := Pos(SETTING_SORT, OptionSettings) > 0;
    ClearBackground := Pos(SETTING_CLEAR, OptionSettings) > 0;
    Gradient := Pos(SETTING_GRADIENT, OptionSettings) > 0;
    Hints := Pos(SETTING_HINTS, OptionSettings) > 0;
    FixedDateRange := Pos(SETTING_FIXED, OptionSettings) > 0;
    HighTime := 0;
    LowTime := BIG_NUMBER;
    FMStartDate := FM_START_DATE;
    FMStopDate := FM_STOP_DATE;
    if SortByType then SortColumn := 1 else SortColumn := 0;
    DateRangeOutpatient := Piece(settings, '|', 9);
    if DateRangeOutpatient = '' then DateRangeOutpatient := '8';
    DateRangeInpatient := Piece(settings, '|', 10);
    if DateRangeInpatient = '' then DateRangeInpatient := '8';
    Turbo := Pos(SETTING_TURBO, OptionSettings) > 0;
    if Piece(settings, '|', 6) = '0' then Turbo := false;  // a 0 in 6th piece shuts down turbo for everyone    
    MergeLabs := Pos(SETTING_MERGELABS, OptionSettings) > 0;
  end;
  Result := FGraphSetting;
end;

end.
