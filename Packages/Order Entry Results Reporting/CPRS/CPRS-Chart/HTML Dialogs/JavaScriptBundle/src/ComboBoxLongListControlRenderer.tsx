import React, { useState, useRef, useEffect, KeyboardEvent, SyntheticEvent } from 'react';
import { withJsonFormsControlProps, TranslateProps, withTranslateProps } from '@jsonforms/react';
import { ControlProps, RankedTester, rankWith, isObjectControl, schemaMatches, and } from '@jsonforms/core';
import { TextField, CircularProgress, IconButton, Button, Autocomplete, Paper } from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
import ClearIcon from '@mui/icons-material/Clear';
import { requestDelphiData, xFormatSchema } from './DataProvider';

interface Item {
    const: string;
    title: string;
    display?: string;
    index: number;
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

interface LookupData {
    data: Item[];
    hasMore: boolean;
    hasPrevious: boolean;
}

const ComboBoxLongListControlRenderer: React.FC<ControlProps & TranslateProps> = (props) => {
    const { data, handleChange, path, required, schema } = props;
    const customSchema = schema as xFormatSchema;

    const lookupType = customSchema["x-lookup"] || "activeUser";
    const title = customSchema.title || '';
    const showButton = customSchema["x-button"] || false;
    const buttonLabel = customSchema["x-buttonLabel"] || "Button";

    const [input, setInput] = useState<InputData>({
        checked: false,
        displayText: '',
        items: [],
        selectedItem: null,
        state: 'None',
        lookupType: lookupType,
        buttonClick: false,
    });

    const [inputValue, setInputValue] = useState<string>(''); // For tracking input text
    const [loading, setLoading] = useState<boolean>(false);
    const [hasMore, setHasMore] = useState<boolean>(false);
    const [hasPrevious, setHasPrevious] = useState<boolean>(false);
    const [isListboxOpen, setIsListboxOpen] = useState<boolean>(false);
    const [highlightedIndex, setHighlightedIndex] = useState<number | null>(null);
    const listBoxRef = useRef<HTMLUListElement | null>(null);

    const [isFieldValid, setIsFieldValid] = useState<boolean>(!required || !!data);

    const pendingInput = useRef<InputData>(input);

    const fetchData = (searchText: string, direction?: 'up' | 'down', searchConst?: string) => {
        setLoading(true);

        const message: InputData = {
            ...pendingInput.current,
            displayText: searchText,
            state: 'InputChange',
        };

        const requestData = {
            delphiMessage: {
                type: 'ComboBox' + message.state,
                path,
                data: direction ? { ...message, direction, const: searchConst } : message,
            },
        };

        requestDelphiData(
            requestData,
            (data) => {
                handleReceivedData(data.delphiMessage.data as LookupData, direction);
            },
            (error) => {
                setLoading(false);
            }
        );
    };

    const handleReceivedData = (lookupData: LookupData, direction?: 'up' | 'down') => {
        if (lookupData && Array.isArray(lookupData.data)) {
            const items = lookupData.data.map((item, index) => ({
                const: item.const.toString(),
                title: item.title,
                display: item.display || item.title,
                index,
            }));
            doSetInput({
                ...pendingInput.current,
                items,
                state: 'InputChange',
            });
            setHasMore(lookupData.hasMore);
            setHasPrevious(lookupData.hasPrevious);

            if (direction === 'up') {
                setHighlightedIndex(items.length - 1); // Set to the last record
            } else {
                setHighlightedIndex(0); // Default behavior
            }
            
            if (listBoxRef.current) {
                listBoxRef.current.focus(); // Focus on the list to manage key events
            }
        } else {
            doSetInput({ ...pendingInput.current, items: [] });
        }
        setIsListboxOpen(true);
        setLoading(false);
    };

    const doSetInput = (data: Partial<InputData>) => {
        const updatedInput = { ...pendingInput.current, ...data, checked: data.checked ?? pendingInput.current.checked };
        pendingInput.current = updatedInput;
        setInput(updatedInput);
    };

    useEffect(() => {
        const handleScroll = () => {
            if (listBoxRef.current) {
                const { scrollTop, scrollHeight, clientHeight } = listBoxRef.current;
                if (scrollTop === 0 && hasPrevious) {
                    handlePreviousClick();
                }

                if (scrollTop + clientHeight >= scrollHeight && hasMore) {
                    handleNextClick();
                }
            }
        };

        const listBoxElement = listBoxRef.current;
        if (listBoxElement) {
            listBoxElement.addEventListener('scroll', handleScroll);
        }

        return () => {
            if (listBoxElement) {
                listBoxElement.removeEventListener('scroll', handleScroll);
            }
        };
    }, [hasMore, hasPrevious]);

    const handleInputFocus = () => {
        setIsListboxOpen(true);
        setHighlightedIndex(0);
    };

    const handleInputChange = (event: any, value: string) => {
        const eventType = event?.type;
        if (eventType === 'change') {
            setInputValue(value || '');
            const lowerCaseValue = value ? value.toLowerCase() : '';
            if (!value) {
                setHighlightedIndex(null);
                doSetInput({ displayText: '', state: 'None', items: [] });
                setIsListboxOpen(false);
            } else {
                setHighlightedIndex(0);
                doSetInput({ displayText: value, state: 'InputChange' });
                fetchData(lowerCaseValue);
            }
        }
        setIsFieldValid(!!required && value.length > 0);
    };

    const handleClearClick = () => {
        setInputValue('');
        doSetInput({ displayText: '', state: 'None', items: [], selectedItem: null });
        setIsListboxOpen(false);
        setHighlightedIndex(null);
        setIsFieldValid(false);
    };

    const handleButtonClick = () => {
        setInput((prevState) => {
            const updatedState = { ...prevState, buttonClick: !prevState.buttonClick };
            pendingInput.current = updatedState;
            return updatedState;
        });
    };

    const handleSearchClick = () => {
        const selectedItem = input.items.find(item => item.display === input.displayText);
        const searchConst = selectedItem ? selectedItem.const : undefined;
        fetchData(input.displayText.toLowerCase(), "down", searchConst);
    };

    const handleOptionChange = (event: any, newValue: Item | null) => {
        if (newValue) {
            const displayText = newValue.display || newValue.title;
            doSetInput({ selectedItem: newValue, displayText, state: 'ItemSelect' });
            handleChange(path, { const: newValue.const, title: newValue.title });
            setInputValue(displayText);
            setHighlightedIndex(newValue.index);
            setIsFieldValid(true);
        } else {
            doSetInput({ selectedItem: null, displayText: '', state: 'None' });
            setInputValue('');
            setHighlightedIndex(null);
            setIsFieldValid(false);
        }
    };

    const handleInputKeyDown = (event: KeyboardEvent<HTMLInputElement>) => {
        const { key } = event;
        if (key === 'Enter' || key === 'Return') {
            if (highlightedIndex !== null) {
                const selectedItem = input.items[highlightedIndex];
                handleOptionChange(event, selectedItem);
            }
            event.preventDefault();
        } else if (key === 'ArrowUp' || key === 'ArrowDown') {
            handleListboxKeyDown(event as unknown as KeyboardEvent<HTMLUListElement>);
        }
    };

    const handleListboxKeyDown = (event: KeyboardEvent<HTMLUListElement>) => {
        const { key } = event;
        if (key === 'ArrowUp') {
            if (highlightedIndex === 0 && hasPrevious) {
                handlePreviousClick();
            } else if (highlightedIndex !== null && highlightedIndex > 0) {
                setHighlightedIndex((prevIndex) => {
                    const newIndex = Math.max(prevIndex! - 1, 0);
                    const newItem = input.items[newIndex];
                    doSetInput({ selectedItem: newItem, displayText: newItem.display || newItem.title });
                    return newIndex;
                });
            }
        } else if (key === 'ArrowDown') {
            if (highlightedIndex === input.items.length - 1 && hasMore) {
                handleNextClick();
            } else if (highlightedIndex !== null && highlightedIndex < input.items.length - 1) {
                setHighlightedIndex((prevIndex) => {
                    const newIndex = Math.min(prevIndex! + 1, input.items.length - 1);
                    const newItem = input.items[newIndex];
                    doSetInput({ selectedItem: newItem, displayText: newItem.display || newItem.title });
                    return newIndex;
                });
            }
        }
        event.stopPropagation();
    };

    const handlePreviousClick = () => {
        if (input.items.length > 0) {
            const firstItemText = input.items[0].title;
            const firstItemId = input.items[0].const;
            fetchData(firstItemText, 'up', firstItemId);
        }
    };

    const handleNextClick = () => {
        if (input.items.length > 0) {
            const lastItemText = input.items[input.items.length - 1].title;
            const lastItemId = input.items[input.items.length - 1].const;
            fetchData(lastItemText, 'down', lastItemId);
        }
    };

    useEffect(() => {
        if (data) {
            doSetInput({
                selectedItem: {
                    const: data.const,
                    title: data.title,
                    display: data.display,
                    index: -1,
                },
                displayText: data.display,
            });
            setInputValue(data.display);
            setIsFieldValid(!required || !!data);
        }
    }, [data, required]);

    return (
        <div>
            <Autocomplete
                value={input.selectedItem}
                onChange={handleOptionChange}
                inputValue={inputValue}
                onInputChange={handleInputChange}
                options={input.items.filter(item =>
                    (item.display || item.title || item.const).toLowerCase().startsWith(inputValue ? inputValue.toLowerCase() : '')
                )}
                noOptionsText="No matching options. Please try different keywords."
                getOptionLabel={(option) => option.display || option.title || option.const || 'No Label'}
                open={isListboxOpen}
                onClose={() => setIsListboxOpen(false)}
                ListboxProps={{
                    onKeyDown: handleListboxKeyDown,
                    ref: listBoxRef,
                    tabIndex: 0,
                }}
                onHighlightChange={(event: SyntheticEvent, option) => {
                    setHighlightedIndex(option ? option.index : null);
                }}
                renderInput={(params) => (
                    <TextField
                        {...params}
                        label={title}
                        onKeyDown={handleInputKeyDown}
                        onFocus={handleInputFocus}
                        required={required}
                        error={required && !isFieldValid}
                        variant="outlined"
                        InputProps={{
                            ...params.InputProps,
                            classes: {
                                root: required && !isFieldValid ? 'Mui-error' : '',
                            },
                            endAdornment: (
                                <>
                                    {loading ? <CircularProgress size={24} /> : null}
                                    <div style={{ display: 'inline-flex', alignItems: 'center' }}>
                                        <IconButton onClick={handleClearClick}>
                                            <ClearIcon />
                                        </IconButton>
                                        {showButton && (
                                            <Button
                                                variant="contained"
                                                onClick={handleButtonClick}
                                                style={{ marginLeft: '8px', backgroundColor: input.buttonClick ? 'blue' : 'grey' }}
                                            >
                                                {buttonLabel}
                                            </Button>
                                        )}
                                        <IconButton onClick={handleSearchClick}>
                                            <SearchIcon />
                                        </IconButton>
                                    </div>
                                </>
                            ),
                        }}
                        InputLabelProps={{
                            classes: {
                                root: `MuiFormLabel-root ${required && !isFieldValid ? 'Mui-error' : ''}`,
                                shrink: 'MuiFormLabel-root MuiInputLabel-formControl MuiInputLabel-animated MuiInputLabel-regular MuiInputLabel-outlined',
                            },
                        }}
                    />
                )}
                renderOption={(props, option) => {
                    const isVisible = inputValue
                        ? (option.display || option.title || option.const).toLowerCase().startsWith(inputValue.toLowerCase())
                        : true;
                    return isVisible ? (
                        <li {...props}>
                            {option.display || option.title || option.const || 'No Label'}
                        </li>
                    ) : null;
                }}
                PaperComponent={({ children, ...rest }) => (
                    <Paper {...rest}>
                        {children}
                    </Paper>
                )}
            />
        </div>
    );
};

const ComboBoxLongListControlTester: RankedTester = rankWith(10, and(isObjectControl, schemaMatches((schema) => {
    const customSchema = schema as xFormatSchema;
    return customSchema.type === 'object' && customSchema['x-format'] === 'simpleDropDown' && customSchema['x-singleCall'] === false;
})));

export default withJsonFormsControlProps(withTranslateProps(React.memo(ComboBoxLongListControlRenderer)));
export { ComboBoxLongListControlTester };