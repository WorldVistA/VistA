import React, { useState, useEffect } from 'react';
import { withJsonFormsControlProps, TranslateProps, withTranslateProps } from '@jsonforms/react';
import { ControlProps, RankedTester, rankWith, isObjectControl, schemaMatches, and } from '@jsonforms/core';
import { TextField, CircularProgress, IconButton, Autocomplete, Paper } from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
import ClearIcon from '@mui/icons-material/Clear';
import { fetchLookupData, lookupDataStore } from './LookupDataHelper'; // Import the helper function

interface Item {
  const: string;
  title: string;
  display: string;
}

interface InputData {
  checked: boolean;
  displayText: string;
  items: Item[];
  selectedItem: Item | null;
  state: string;
  lookupType: string;
  buttonClick: boolean;
}

const ComboBoxControlRenderer: React.FC<ControlProps & TranslateProps> = (props) => {
  const { data, handleChange, path, schema, uischema, visible, required } = props;
  const customSchema = schema as any; // Cast to 'any' type since xFormatSchema key is custom
  const lookupType = customSchema['x-lookup'] as string || '';
  const singleCall = customSchema['x-singleCall'] as boolean || false;
  const uiSchemaOptions = uischema?.options || {};
  const readOnly = uiSchemaOptions.readOnly || false;

  const [input, setInput] = useState<InputData>({
    checked: false,
    displayText: '',
    items: [],
    selectedItem: null,
    state: 'None',
    lookupType,
    buttonClick: false,
  });
  const [inputValue, setInputValue] = useState<string>('');
  const [loading, setLoading] = useState<boolean>(false);
  const [isListboxOpen, setIsListboxOpen] = useState<boolean>(false);
  const [isFieldValid, setIsFieldValid] = useState<boolean>(!required || !!data);

  useEffect(() => {
    const existingItem = data
      ? {
          const: data.const.toString(),
          title: data.title,
          display: data.display || data.title,
        }
      : null;

    setInput((prev) => ({
      ...prev,
      selectedItem: existingItem,
      displayText: existingItem?.display || '',
      items: existingItem ? [existingItem] : [],
    }));
    setInputValue(existingItem?.display || '');
    setIsFieldValid(!required || !!existingItem);

    if (singleCall && lookupType && !input.items.length) {
      setLoading(true);
      fetchLookupData(lookupType, path)
        .then((items) => {
          setInput((prev) => ({ ...prev, items }));
          setLoading(false);
        })
        .catch(() => setLoading(false));
    }
  }, [data, lookupType, required, singleCall, path]);

  const handleInputChange = (event: any, value: string) => {
    setInputValue(value);
    const allItems = lookupType ? lookupDataStore[lookupType] || [] : [];

    if (allItems.length === 0 && !loading) {
      setLoading(true);
      fetchLookupData(lookupType, path)
        .then((items) => {
          const lowerCaseValue = value ? value.toLowerCase() : '';
          const filteredItems = items.filter((item) =>
            item.display.toLowerCase().startsWith(lowerCaseValue)
          );
          setInput((prev) => ({ ...prev, items: filteredItems }));
          setLoading(false);
        })
        .catch(() => setLoading(false));
    } else {
      const lowerCaseValue = value ? value.toLowerCase() : '';
      const filteredItems = allItems.filter((item) =>
        item.display.toLowerCase().startsWith(lowerCaseValue)
      );
      setInput((prev) => ({ ...prev, items: filteredItems }));
    }
    setIsFieldValid(!!required && value.length > 0);
  };

  const handleOptionChange = (event: any, newValue: Item | null) => {
    if (newValue) {
      setInput((prev) => ({
        ...prev,
        selectedItem: newValue,
        displayText: newValue.display,
        items: singleCall ? [newValue] : prev.items,
      }));
      handleChange(path, { const: newValue.const, title: newValue.title });
      setIsFieldValid(true);
    } else {
      setInput((prev) => ({ ...prev, selectedItem: null, displayText: '' }));
      handleChange(path, null);
      setIsFieldValid(false);
    }
    setIsListboxOpen(false); // Close the listbox when an item is selected
  };

  const handleClearClick = () => {
    setInputValue('');
    setInput((prev) => ({ ...prev, items: [], displayText: '', selectedItem: null }));
    handleChange(path, null);
    setIsFieldValid(false);
  };

  const handleInputFocus = () => {
    if (!inputValue) {
      setIsListboxOpen(true);
      setLoading(true);
      fetchLookupData(lookupType, path)
        .then((items) => {
          setInput((prev) => ({ ...prev, items }));
          setLoading(false);
        })
        .catch(() => {
          setLoading(false);
        });
    }
  };

  return (
    <div>
      <Autocomplete
        value={input.selectedItem}
        onChange={handleOptionChange}
        inputValue={inputValue}
        onInputChange={handleInputChange}
        options={input.items}
        disabled={readOnly}
        noOptionsText="No matching options. Please try different keywords."
        getOptionLabel={(option: Item) => option.display}
        open={isListboxOpen}
        onOpen={() => setIsListboxOpen(true)}
        onClose={() => setIsListboxOpen(false)}
        renderInput={(params) => (
          // Use params here to pass through MUI Autocomplete TextField props
          <TextField
            {...params}
            label={customSchema.title}
            variant="outlined"
            onFocus={handleInputFocus}
            disabled={readOnly}
            required={required}
            error={required && !isFieldValid} // Mark as error if required and invalid
            InputProps={{
              ...params.InputProps,
              classes: {
                root: required && !isFieldValid ? 'Mui-error' : '',
              },
              endAdornment: (
                <>
                  {loading ? <CircularProgress size={24} /> : null}
                  {!readOnly && (
                    <>
                      <IconButton onClick={handleClearClick}>
                        <ClearIcon />
                      </IconButton>
                      <IconButton>
                        <SearchIcon />
                      </IconButton>
                    </>
                  )}
                </>
              ),
            }}
            InputLabelProps={{
              classes: {
                root: `MuiFormLabel-root ${required && !isFieldValid ? 'Mui-error' : ''}`,
                shrink: `MuiFormLabel-root {...customLabelStyle.shrink}`, // Ensure to include customLabelStyle shrink here for positioning
              },
            }}
          />
        )}
        PaperComponent={({ children, ...rest }) => <Paper {...rest}>{children}</Paper>}
        renderOption={(props, option) => <li {...props}>{option.display}</li>}
      />
    </div>
  );
};

const ComboBoxControlTester: RankedTester = rankWith(
  10,
  and(
    isObjectControl,
    schemaMatches((schema) => {
      const customSchema = schema as any; // Cast to 'any' type since xFormatSchema key is custom
      return (
        customSchema.type === 'object' &&
        customSchema['x-format'] === 'simpleDropDown' &&
        customSchema['x-singleCall'] === true
      );
    })
  )
);

export default withJsonFormsControlProps(withTranslateProps(React.memo(ComboBoxControlRenderer)));
export { ComboBoxControlTester };