import React, { useState, useEffect, useRef } from 'react';
import { withJsonFormsControlProps, TranslateProps, withTranslateProps } from '@jsonforms/react';
import { ControlProps, OwnPropsOfEnum, RankedTester, rankWith, isObjectControl, schemaMatches, and } from '@jsonforms/core';
import { WithOptionLabel } from '@jsonforms/material-renderers';
import { Autocomplete, TextField, CircularProgress } from '@mui/material';
import { FixedSizeList } from 'react-window';
import { requestDelphiData, DataType, xFormatSchema, MessageSchema } from './../DataProvider';
import './ComboBoxRenderer.css';
import { fontConfig } from './../theme';

interface item {
    internal: string;
    external: string;
}

const emptyItem: item = { internal: '', external: '' };

interface LongListParamsSchema {
    init?: string;
    routine?: string;
}

type ComboBoxStyle = "orcsSimple" | "orcsDropDown";

interface ComboBoxParamsSchema {
    autoSelect: boolean;
    caseChanged?: boolean
    delimiter?: string & { length: 1 };
    dropDownCount: number;
    droppedDown: boolean;
    items: item[];
    listItemsOnly: boolean;
    longList: boolean;
    longListParams: LongListParamsSchema;
    lookupPiece?: number;
    maxLength?: number;
    pieces?: string;
    sorted: boolean;
    style: ComboBoxStyle;
    uniqueAutoComplete: boolean;
}

type ComboBoxSchema = MessageSchema & {
    "x-params": ComboBoxParamsSchema;
    "title": string;
}

const ComboBoxControlRenderer: React.FC<ControlProps & OwnPropsOfEnum &
    WithOptionLabel & TranslateProps> = (props) => {
        const { data, handleChange, path, schema, uischema, label, ...otherProps } = props;
        const customSchema = schema as ComboBoxSchema;        
        const lastKeyRef = useRef('');
        const lastInputLength = useRef(0);
        const listRef = useRef<FixedSizeList>(null);        
        const [comboBox, setComboBox] = useState<ComboBoxSchema>(
             {
                ...customSchema,
                delphiMessage: {
                    type: '',
                    path: path
                },
                'x-params': {
                    ...(customSchema['x-params'] || {} as ComboBoxParamsSchema),
                    autoSelect: (customSchema['x-params'].autoSelect || true) as boolean,
                    dropDownCount: (customSchema['x-params'].dropDownCount || 8) as number,
                    droppedDown: (customSchema['x-params'].droppedDown || false) as boolean,
                    items: (customSchema['x-params'].items || []) as item[],
                    listItemsOnly: (customSchema['x-params'].listItemsOnly || false) as boolean,
                    longList: (customSchema['x-params'].longList || false) as boolean,
                    longListParams: (customSchema['x-params'].longListParams || {} as LongListParamsSchema),
                    sorted: (customSchema['x-params'].sorted || false) as boolean,
                    style: (customSchema['x-params'].style || 'orcsSimple') as ComboBoxStyle,
                    uniqueAutoComplete: (customSchema['x-params'].uniqueAutoComplete || false) as boolean,
                },
            }
        );
        const [alphaLoading, setAlphaLoading] = useState<boolean>(comboBox['x-params'].longList || false);
        const [comboBoxLoading, setComboBoxLoading] = useState<boolean>(true);
        const [alphaDistribution, setAlphaDistribution] = useState<string[]>([]);
        const [options, setOptions] = useState<item[]>(comboBox['x-params'].items || []);
        const [selectedValue, setSelectedValue] = useState<item | null>(data || null);
        const [inputValue, setInputValue] = useState<string>('');
        const [filteredOptions, setFilteredOptions] = useState<item[]>(options);
        const [open, setOpen] = useState(false);
        const [loading, setLoading] = useState(false);
        const [itemIndex, setItemIndex] = useState<number>(-1); // Add state for itemIndex
        const [topIndex, setTopIndex] = useState<number>(0);
        const [topReached, setTopReached] = useState<boolean>(false);
        const [bottomReached, setBottomReached] = useState<boolean>(false);
        const [scrollPosition, setScrollPosition] = useState<number>(0); // Add state for scroll position

        function updateFilteredOptions(newValue: item | string | null): item[] {
            let inputValue = '';
            if (newValue && typeof newValue === 'object') {
                inputValue = newValue.external;
            } else if (typeof newValue === 'string') {
                inputValue = newValue;
            } else {
                inputValue = '';
            }
            if (inputValue) {
                const newFilteredOptions = options.filter((option) =>
                    option.external.toLowerCase().startsWith(inputValue.toLowerCase())
                );
                setFilteredOptions(newFilteredOptions);
                setItemIndex(-1); // Reset itemIndex when options are filtered
                return newFilteredOptions;
            } else {
                setFilteredOptions(options);
                setItemIndex(-1); // Reset itemIndex when options are filtered
                const temp: item[] = [];
                return temp;
            }
        }

        function searchAndSetItemIndex(inputValue: string) {
            const matchedIndex = options.findIndex(option => option.external.toLowerCase() === inputValue.toLowerCase());
            if (matchedIndex !== -1) {
                setItemIndex(matchedIndex);
                if (listRef.current) {
                    listRef.current.scrollTo(matchedIndex); // Scroll to keep item in view
                }
            } else {
                setItemIndex(-1); // Reset itemIndex if no match is found
            }
        }

        useEffect(() => {             
            let newOptions = comboBox['x-params'].items || [];
            if (comboBox['x-params'].sorted) {
                newOptions = newOptions.sort((a, b) => a.external.localeCompare(b.external));
            }
            setOptions(newOptions);
            searchAndSetItemIndex(inputValue);
        }, [comboBox]);

        useEffect(() => {
            if (comboBox['x-params'].longList) {
                setInputValue(comboBox['x-params'].longListParams.init || '');
            };
            requestDelphiData(
                {
                    ...comboBox,
                    delphiMessage: {
                        type: 'ComboBoxCreate',
                        path: path,
                    },
                },
                (data: MessageSchema) => {
                    setComboBox(data as ComboBoxSchema);
                    setComboBoxLoading(false);
                }, (error: MessageSchema) => {
                    console.error(error.delphiMessage.errorMessage, error);
                    setComboBoxLoading(false);
                });
        }, []);

        useEffect(() => {
            updateFilteredOptions(inputValue);
            searchAndSetItemIndex(inputValue); // Call the new routine           
        }, [inputValue, options]);

        useEffect(() => {
            if (comboBox['x-params'].longList && alphaDistribution.length === 0) {                
                requestDelphiData(
                    { delphiMessage: { type: DataType.AlphaDist } } as MessageSchema,
                    (data: MessageSchema) => {
                        setAlphaDistribution(data.delphiMessage.data);
                        setAlphaLoading(false);
                    },
                    (error: MessageSchema) => {
                        console.error(error.delphiMessage.errorMessage, error);
                        setAlphaLoading(false);
                    }
                );
            }
        }, [alphaDistribution.length === 0, comboBox['x-params'].longList]);

        useEffect(() => {
            requestDelphiData(
                {
                    delphiMessage: {
                        type: 'ComboBoxScrollPosition',
                        path: path,
                    },
                },
                (data: MessageSchema) => {
                    setScrollPosition(data.delphiMessage.data);
                },
                (error: MessageSchema) => {
                    console.error(error.delphiMessage.errorMessage, error);
                }
            );
        }, [scrollPosition]);

        const renderDropdownList = () => {
            interface CustomFilterOptions {
                inputValue: string;
            }

            const customFilter = (options: item[], { inputValue }: CustomFilterOptions): item[] => {
                return options;
            };

            function handleOnChange(event: React.SyntheticEvent, newValue: item | string | null) {
                // console.log('handleOnChange event:', event, 'value:', newValue);
                // let newFilteredOptions: item[] = updateFilteredOptions(inputValue);
                let newValueObject: item = { ...emptyItem };
                if (typeof newValue === 'string') {
                    newValueObject = options.find((option) => option.external === newValue) ||
                        { internal: newValue, external: newValue };
                } else if (newValue && typeof newValue === 'object') {
                    newValueObject = newValue;
                } else {
                    newValueObject = { ...emptyItem };
                }

                setInputValue(newValueObject.external);
                setItemIndex(options.findIndex(option => option.external === newValueObject.external)); // Update itemIndex
                // if (newValueObject.external === '' || (comboBox['x-params'].listItemsOnly &&
                //     !options.some((option) => option.external === newValueObject.external))) {
                //     setSelectedValue(null);
                //     handleChange(path, null);
                // } else {
                setSelectedValue(newValueObject);
                handleChange(path, newValueObject);
                // }
            }

            const itemHeight = fontConfig.height;
            const itemsPerPage = comboBox['x-params'].dropDownCount;
            const height = (itemHeight + 1) * itemsPerPage;

            const Row: React.FC<{
                index: number; style: React.CSSProperties; itemIndex: number;
                options: item[]; path: string; handleChange: (path: string, value: item) => void;
                setItemIndex: (index: number) => void; listRef: React.RefObject<FixedSizeList>
            }> = ({
                index, style, itemIndex, options, path, handleChange, setItemIndex, listRef }) => {
                    const isSelected = index === itemIndex;
                    const backgroundColor = isSelected ? '#bde4ff' : 'white';
                    const offset = itemIndex + index;
                    return (
                        <div
                            style={{
                                ...style,
                                whiteSpace: 'nowrap',
                                overflow: 'hidden',
                                textOverflow: 'ellipsis',
                                backgroundColor: backgroundColor // Highlight selected item
                            }}
                            onClick={() => {
                                handleChange(path, options[offset]);
                                setItemIndex(offset); // Update itemIndex on click
                                if (listRef.current) {
                                    listRef.current.scrollToItem(offset); // Scroll to keep item in view
                                }
                                requestDelphiData(
                                    {
                                        delphiMessage: {
                                            type: 'ComboBoxItemSelected',
                                            path: path,
                                            data: options[offset]
                                        },
                                    },
                                    () => { },
                                    (error: MessageSchema) => {
                                        console.error(error.delphiMessage.errorMessage, error);
                                    }
                                );
                            }}
                        >
                            {options[offset].external}
                        </div>
                    );
                };

            // const Row = ({ index, style }: { index: number; style: React.CSSProperties }) => (                
            //     <div
            //         style={{
            //             ...style,
            //             whiteSpace: 'nowrap',
            //             overflow: 'hidden',
            //             textOverflow: 'ellipsis',
            //             backgroundColor: index === itemIndex ? '#bde4ff' : 'white' // Highlight selected item
            //         }}
            //         onClick={() => {
            //             handleChange(path, options[index]);
            //             setItemIndex(index); // Update itemIndex on click
            //             if (listRef.current) {
            //                 listRef.current.scrollTo(index); // Scroll to keep item in view
            //             }
            //         }}
            //     >
            //         {options[index].external}
            //     </div>
            // );

            return (
                <Autocomplete
                    autoSelect={comboBox['x-params'].autoSelect &&
                        (!comboBox['x-params'].uniqueAutoComplete || filteredOptions.length === 1)}
                    freeSolo={!comboBox['x-params'].listItemsOnly}
                    filterOptions={customFilter}
                    options={options}
                    getOptionLabel={(option) => {
                        if (typeof option === 'object' && option !== null && 'external' in option) {
                            return option.external;
                        }
                        return option;
                    }}
                    value={selectedValue}
                    onKeyDown={(event) => {
                        lastKeyRef.current = event.key;
                        if (event.key === 'ArrowDown' || event.key === 'ArrowUp' || event.key === 'PageDown' || event.key === 'PageUp') {
                            event.preventDefault();
                            if (listRef.current) {
                                const itemCount = options.length;
                                let newIndex = itemIndex;

                                if (event.key === 'ArrowDown') {
                                    newIndex = (itemIndex + 1) % itemCount;
                                } else if (event.key === 'ArrowUp') {
                                    newIndex = (itemIndex - 1 + itemCount) % itemCount;
                                } else if (event.key === 'PageDown') {
                                    newIndex = Math.min(itemIndex + itemsPerPage, itemCount - 1);
                                } else if (event.key === 'PageUp') {
                                    newIndex = Math.max(itemIndex - itemsPerPage, 0);
                                }

                                const newOption = options[newIndex];
                                setInputValue(newOption.external);
                                setSelectedValue(newOption);
                                handleChange(path, newOption);
                                setItemIndex(newIndex); // Update itemIndex on key press
                                listRef.current.scrollTo(newIndex); // Scroll to keep item in view
                            }
                        }
                    }}
                    onChange={(event, newValue, reason) => {
                        // console.log('Autocomplete onChange', newValue, 'reason', reason);
                        handleOnChange(event, newValue);
                        requestDelphiData(
                            {
                                delphiMessage: {
                                    type: 'ComboBoxInputChange',
                                    path: path,
                                    data: newValue
                                },
                            },
                            () => { },
                            (error: MessageSchema) => {
                                console.error(error.delphiMessage.errorMessage, error);
                            }
                        );
                    }}
                    onInputChange={(event, newInputValue, reason) => {
                        if (reason === 'input') {
                            updateFilteredOptions(newInputValue);
                            // console.log('last input:', inputValue, 'new input:', newInputValue);
                            setInputValue(newInputValue);
                            if (comboBox['x-params'].autoSelect) {
                                const matchedOption = options.find(option => option.external.toLowerCase().startsWith(newInputValue.toLowerCase()));
                                if (matchedOption) {
                                    const remainingText = matchedOption.external.substring(newInputValue.length);
                                    setInputValue(matchedOption.external);
                                    setTimeout(() => {
                                        const input = event.target as HTMLInputElement;
                                        lastInputLength.current = newInputValue.length;
                                        input.setSelectionRange(newInputValue.length, matchedOption.external.length, "backward");
                                    }, 0);
                                } else {
                                    setInputValue(newInputValue); // Keep the user's input if no match is found
                                }
                            }
                        }
                        requestDelphiData(
                            {
                                delphiMessage: {
                                    type: 'ComboBoxInputChange',
                                    path: path,
                                    data: newInputValue
                                },
                            },
                            () => { },
                            (error: MessageSchema) => {
                                console.error(error.delphiMessage.errorMessage, error);
                            }
                        );
                    }}
                    onBlur={(event) => {
                        if (selectedValue && ((selectedValue.external === '') || (comboBox['x-params'].listItemsOnly &&
                            !options.some((option) => option.external === selectedValue.external)))) {
                            setSelectedValue(emptyItem);
                            handleChange(path, null);
                            setInputValue('');
                        }
                    }} inputValue={inputValue}
                    renderInput={(params) => (
                        <TextField
                            {...params}
                            variant="outlined"
                            label={label}
                            onBlur={(event) => {
                                handleOnChange(event, event.target.value);
                            }}
                            onChange={(event) => {
                                // console.log('TextField onChange', event.target.value);
                                if (event.target.value === '') {
                                    handleOnChange(event, '');
                                } else {
                                    let newValue = event.target.value;
                                    if (lastKeyRef.current === 'Backspace' && lastInputLength.current === event.target.value.length) {
                                        newValue = event.target.value.substring(0, lastInputLength.current - 1);
                                    }
                                    let newFilteredOptions = updateFilteredOptions(newValue);
                                    if (comboBox['x-params'].autoSelect && ((comboBox['x-params'].uniqueAutoComplete &&
                                        newFilteredOptions.length === 1) || (!comboBox['x-params'].uniqueAutoComplete &&
                                            newFilteredOptions.length > 0))) {
                                        handleOnChange(event, newFilteredOptions[0]);
                                    }
                                    else {
                                        handleOnChange(event, newValue);
                                    }
                                }
                            }}
                        />
                    )}
                    renderOption={(props, option) => (
                        <li {...props} key={option.internal}>
                            {option.external}
                        </li>
                    )}
                    open={open}
                    onOpen={() => setOpen(true)}
                    onClose={() => setOpen(false)}
                    loading={loading}
                    slotProps={{
                        paper: {
                            component: ({ children, ...listboxProps }) => (
                                <div className="cprsComboBoxRendererList">
                                    <FixedSizeList
                                        ref={listRef}
                                        height={height}
                                        itemCount={itemsPerPage}
                                        itemSize={itemHeight}
                                        initialScrollOffset={scrollPosition} // Set initial scroll position
                                        onScroll={({ scrollOffset }) => setScrollPosition(scrollOffset)} // Update scroll position
                                        {...listboxProps}
                                    >
                                        {Row}
                                    </FixedSizeList>
                                </div>
                            )
                        }
                    }}
                />
            );
        };
        const renderList = () => {
            return (
                <>
                    <div className="flex-container">
                        {renderDropdownList()}
                    </div>
                </>
            );
        };

        return (
            <div>
                {alphaLoading || comboBoxLoading ? (
                    <div>Loading...</div>
                ) : (
                    <>
                        {renderList()}
                    </>
                )}
            </div>
        );
    };

const ComboBoxControlTester: RankedTester = rankWith(
    10,
    and(
        isObjectControl,
        schemaMatches((schema) => {
            const customSchema = schema as xFormatSchema;
            return customSchema.type === 'object' && typeof customSchema["x-format"] === 'string' &&
                customSchema["x-format"] === 'comboBox';
        })
    )
);

export default withJsonFormsControlProps(
    withTranslateProps(React.memo(ComboBoxControlRenderer)),
    false
);

export { ComboBoxControlTester };