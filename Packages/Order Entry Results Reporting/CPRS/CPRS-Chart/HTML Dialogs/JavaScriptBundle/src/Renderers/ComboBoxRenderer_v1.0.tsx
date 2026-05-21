import _ from 'lodash';
import React, { useState, useEffect, useRef } from 'react';
import { Autocomplete, TextField } from '@mui/material';
import {
    ControlProps,
    OwnPropsOfEnum,
    RankedTester,
    rankWith,
    isObjectControl,
    schemaMatches,
    and
} from '@jsonforms/core';
import {
    withJsonFormsControlProps,
    TranslateProps,
    withTranslateProps
} from '@jsonforms/react';
import { WithOptionLabel } from '@jsonforms/material-renderers';
import { requestDelphiData, DataType, xFormatSchema, MessageSchema } from './../DataProvider';

interface item {
    internal: string;
    external: string;
}

const emptyItem: item = { internal: '', external: '' };

interface LongListParamsSchema {
    init?: string;
    routine?: string;
}

interface ComboBoxParamsSchema {
    autoSelect: boolean;
    caseChanged?: boolean
    delimiter?: string & { length: 1 };
    items: item[];
    listItemsOnly: boolean;
    longList: boolean;
    longListParams: LongListParamsSchema;
    lookupPiece?: number;
    maxLength?: number;
    pieces?: string;
    sorted: boolean;
    uniqueAutoComplete: boolean;
}

type ComboBoxSchema = MessageSchema & {
    "x-params": ComboBoxParamsSchema;
    "title": string;
}

// ComboBoxControlRenderer component
const ComboBoxControlRenderer: React.FC<ControlProps & OwnPropsOfEnum &
    WithOptionLabel & TranslateProps> = (props) => {
        const { data, handleChange, path, schema, uischema, label, ...otherProps } = props;
        const customSchema = schema as ComboBoxSchema;
        const lastKeyRef = useRef('');
        const lastInputLength = useRef(0);
        let xParams = customSchema['x-params'] || {} as ComboBoxParamsSchema;
        const initialComboBoxState: ComboBoxSchema = {
            ...customSchema,
            delphiMessage: {
                type: '',
                path: path
            },
            'x-params': {
                ...(customSchema['x-params'] || {} as ComboBoxParamsSchema),
                autoSelect: (xParams.autoSelect || true) as boolean,
                items: (xParams.items || []) as item[],
                listItemsOnly: (xParams.listItemsOnly || false) as boolean,
                longList: (xParams.longList || false) as boolean,
                longListParams: (xParams.longListParams || {} as LongListParamsSchema),
                sorted: (xParams.sorted || false) as boolean,
                uniqueAutoComplete: (xParams.uniqueAutoComplete || false) as boolean,
            },
        };
        const [comboBox, setComboBox] = useState<ComboBoxSchema>(initialComboBoxState);
        const [alphaLoading, setAlphaLoading] = useState<boolean>(comboBox['x-params'].longList || false);
        const [comboBoxLoading, setComboBoxLoading] = useState<boolean>(true);
        const [alphaDistribution, setAlphaDistribution] = useState<string[]>([]);
        const [options, setOptions] = useState<item[]>(comboBox['x-params'].items || []);
        const [selectedValue, setSelectedValue] = useState<item | null>(data || null);
        const [inputValue, setInputValue] = useState<string>('');
        const [filteredOptions, setFilteredOptions] = useState<item[]>(options);

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
                return newFilteredOptions;
            } else {
                setFilteredOptions(options);
                const temp: item[] = [];
                return temp;
            }
        }

        useEffect(() => {
            xParams = comboBox['x-params'] || {};
            let newOptions = xParams.items || [];
            if (xParams.sorted) {
                newOptions = newOptions.sort((a, b) => a.external.localeCompare(b.external));
            }
            setOptions(newOptions);
        }, [comboBox]);

        useEffect(() => {
            // Request options from Delphi

            if (comboBox['x-params'].longList) {
                //   const comboBoxCopy = { ...comboBox };
                //   comboBoxCopy['x-params'].waterMark = 0;
            }
            comboBox.delphiMessage.type = 'ComboBoxCreate';
            requestDelphiData(comboBox, (data: MessageSchema) => {
                setComboBox(data as ComboBoxSchema);
                setComboBoxLoading(false);
            }, (error: MessageSchema) => {
                console.error(error.delphiMessage.errorMessage, error);
                setComboBoxLoading(false);
            });
        }, []);

        useEffect(() => {
            updateFilteredOptions(inputValue);
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
                // if (newValueObject.external === '' || (comboBox['x-params'].listItemsOnly &&
                //     !options.some((option) => option.external === newValueObject.external))) {
                //     setSelectedValue(null);
                //     handleChange(path, null);
                // } else {
                setSelectedValue(newValueObject);
                handleChange(path, newValueObject);
                // }
            }

            return (
                <Autocomplete
                    autoSelect={comboBox['x-params'].autoSelect &&
                        (!comboBox['x-params'].uniqueAutoComplete || filteredOptions.length === 1)}
                    freeSolo={!comboBox['x-params'].listItemsOnly}
                    filterOptions={customFilter}
                    value={selectedValue}
                    onKeyDown={(event) => {
                        lastKeyRef.current = event.key;
                    }}
                    onChange={(event, newValue, reason) => {
                        // console.log('Autocomplete onChange', newValue, 'reason', reason);
                        handleOnChange(event, newValue);
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
                    }}
                    onBlur={(event) => {
                        if (selectedValue && ((selectedValue.external === '') || (comboBox['x-params'].listItemsOnly &&
                            !options.some((option) => option.external === selectedValue.external)))) {
                            setSelectedValue(emptyItem);
                            handleChange(path, null);
                            setInputValue('');
                        }
                    }}
                    inputValue={inputValue}
                    options={options}
                    getOptionLabel={(option) => {
                        if (typeof option === 'object' && option !== null && 'external' in option) {
                            return option.external;
                        }
                        return option;
                    }}
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
                />
            );
        };

        // const renderORScrollbar = () => {
        //     // Define the min and max values for your scrollbar
        //     const min = 0;
        //     const max = 100;

        //     // This function will be called when the scrollbar is moved
        //     const handleScroll = (scrollValues: any) => {
        //         // Calculate the value based on the scroll position
        //         const value = Math.round((scrollValues.scrollTop /
        //             (scrollValues.scrollHeight - scrollValues.clientHeight)) * (max - min)) + min;
        //     };

        //     return (
        //         <Scrollbar
        //             onScroll={(scrollValues: any) => handleScroll(scrollValues)}
        //             style={{ height: 300 }} // Set the height of the scrollbar
        //         >
        //             {/* Content that needs to be scrolled */}
        //         </Scrollbar>
        //     );
        // };

        // Conditionally render the list based on the LongList and ListItemsOnly properties
        const renderList = () => {
            return (
                <>
                    {/* <div className="flex-container">
                        <div className="flex-item"> */}
                    {renderDropdownList()}
                    {/* </div>
                        {xParams.longList && (
                            <div className="flex-item-auto">
                                {renderORScrollbar()}
                            </div>
                        )}
                    </div> */}
                </>
            );
        };

        return (
            <div>
                {alphaLoading || comboBoxLoading ? (
                    <div>Loading...</div> // Render a loading indicator or similar placeholder
                ) : (
                    // Render the actual content only when the alpha distribution is loaded
                    <>
                        {renderList()}
                    </>
                )}
            </div>
        );
    };

// Tester for the ComboBoxControlRenderer
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

// Also export the tester so it can be registered with JSON Forms
export { ComboBoxControlTester };