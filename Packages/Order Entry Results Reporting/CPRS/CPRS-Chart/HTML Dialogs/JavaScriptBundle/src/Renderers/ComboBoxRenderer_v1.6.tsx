import React, { useState, useEffect, useRef } from 'react';
import { withJsonFormsControlProps, TranslateProps, withTranslateProps } from '@jsonforms/react';
import { ControlProps, OwnPropsOfEnum, RankedTester, rankWith, isObjectControl, schemaMatches, and } from '@jsonforms/core';
import { WithOptionLabel } from '@jsonforms/material-renderers';
import { Autocomplete, TextField, CircularProgress } from '@mui/material';
import { Scrollbar } from 'react-scrollbars-custom';
//import { FixedSizeList } from 'react-window';
import { requestDelphiData, DataType, xFormatSchema, MessageSchema, SuccessCallback, ErrorCallback } from './../DataProvider';
//import './ComboBoxRenderer.css';
import { fontConfig } from './../theme';
import { last } from 'lodash';

interface item {
    internal: string;
    external: string;
}

const emptyItem: item = { internal: '', external: '' };

type updateType = 'Create' | 'KeyPress' | 'ScrollPosition' | 'InputChange';

interface ComboBoxUpdateMessage {
    type: updateType;
    keyPressed?: string;
    displayText?: string;
    scrollPosition?: number;
    items?: item[];
    selectedItem: item | null;
    selectionStart?: number;
    selectionEnd?: number;
}

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
        // const lastKeyRef = useRef('');
        const [comboBox, setComboBox] = useState<ComboBoxSchema>(
            {
                ...customSchema,
                delphiMessage: {
                    type: '',
                    path: path,
                    data: {} as ComboBoxUpdateMessage
                },
                'x-params': {
                    ...(customSchema['x-params'] || {} as ComboBoxParamsSchema),
                    autoSelect: (customSchema['x-params'].autoSelect || true) as boolean,
                    dropDownCount: (customSchema['x-params'].dropDownCount || 8) as number,
                    droppedDown: (customSchema['x-params'].droppedDown || false) as boolean,
                    items: (customSchema['x-params'].items || []) as item[],
                    // customSchema['x-params'].items === null || customSchema['x-params'].items.length === 0 ?
                    // [{ internal: "1", external: "testing"}] : customSchema['x-params'].items || []) as item[],
                    listItemsOnly: (customSchema['x-params'].listItemsOnly || false) as boolean,
                    longList: (customSchema['x-params'].longList || false) as boolean,
                    longListParams: (customSchema['x-params'].longListParams || {} as LongListParamsSchema),
                    sorted: (customSchema['x-params'].sorted || false) as boolean,
                    style: (customSchema['x-params'].style || 'orcsSimple') as ComboBoxStyle,
                    uniqueAutoComplete: (customSchema['x-params'].uniqueAutoComplete || false) as boolean,
                },
            }
        );
        const [comboBoxLoading, setComboBoxLoading] = useState(true);
        const [options, setOptions] = useState<item[]>(comboBox['x-params'].items || []);
        const [selectedValue, setSelectedValue] = useState<item | null>(data || null);
        const [inputValue, setInputValue] = useState<string>('');
        const [open, setOpen] = useState(false);
        const [loading, setLoading] = useState(false);
        const inputRef = useRef(null);
        const lastMessage = useRef({} as ComboBoxUpdateMessage)

        function handleOnChange(newValue: item | string | null) {
            console.log('handleOnChange', newValue);
            let newValueObject: item = { ...emptyItem };
            if (typeof newValue === 'string') {
                newValueObject = options.find((option) => option.external === newValue) ||
                    { internal: newValue, external: newValue };
            } else if (newValue && typeof newValue === 'object') {
                newValueObject = newValue;
            } else {
                newValueObject = { ...emptyItem };
            }
            //setInputValue(newValueObject.external);
            setSelectedValue(newValueObject);
            handleChange(path, newValueObject);
            // }
        }

        useEffect(() => {
            console.log('options changed', options);
            if (lastMessage.current && lastMessage != undefined) {
                handleOnChange(lastMessage.current.selectedItem);
            }
        }, [options]);

        useEffect(() => {
            console.log('comboBox changed', comboBox);
            let message = comboBox.delphiMessage.data as ComboBoxUpdateMessage;
            message.items = message.items || [];
            lastMessage.current = message;
            setOptions(message.items);
            if (inputRef.current) {
                const input = inputRef.current as HTMLInputElement;
                input.textContent = message.displayText || '';
                input.setSelectionRange(message.selectionStart || 0, message.selectionEnd || 0);
            }

            if (comboBoxLoading && comboBox.delphiMessage.data.type === 'Create') {
                setComboBoxLoading(false);
            }
        }, [comboBox]);

        const fetchData = (message: ComboBoxUpdateMessage, onSuccess?: SuccessCallback) => {
            setLoading(true);
            console.log('fetchData', message);
            requestDelphiData(
                {
                    ...comboBox,
                    delphiMessage: {
                        type: DataType.ComboBoxUpdate,
                        path: path,
                        data: {
                            ...message,
                            displayText: inputValue,
                            selectedItem: selectedValue
                        }
                    },
                },
                (data: MessageSchema) => {
                    setComboBox(data as ComboBoxSchema);
                    if (onSuccess) {
                        onSuccess(data);
                    }
                    setLoading(false);
                }, (error: MessageSchema) => {
                    console.error(error.delphiMessage.errorMessage, error);
                    setLoading(false);
                });
        }

        useEffect(() => {
            console.log('Create');
            fetchData({ type: 'Create' } as ComboBoxUpdateMessage);
        }, []);

        const renderDropdownList = () => {
            console.log('renderDropdownList', options);
            const itemHeight = fontConfig.height;
            const itemsPerPage = comboBox['x-params'].dropDownCount;
            const height = (itemHeight + 1) * itemsPerPage;

            return (
                <Autocomplete
                    key={options.length} // Add this line to force re-render when options change
                    freeSolo={!comboBox['x-params'].listItemsOnly}
                    options={options}
                    getOptionLabel={(option) => {
                        if (typeof option === 'object' && option !== null && 'external' in option) {
                            return option.external;
                        }
                        return option;
                    }}
                    value={selectedValue}
                    inputValue={inputValue}
                    onChange={(event, newValue) => {
                        handleOnChange(newValue);
                    }}

                    // onChange={(event, newValue, reason) => {
                    //     // console.log('Autocomplete onChange', newValue, 'reason', reason);
                    //     handleOnChange(event, newValue);
                    //     requestDelphiData(
                    //         {
                    //             delphiMessage: {
                    //                 type: 'ComboBoxInputChange',
                    //                 path: path,
                    //                 data: newValue
                    //             },
                    //         },
                    //         () => { },
                    //         (error: MessageSchema) => {
                    //             console.error(error.delphiMessage.errorMessage, error);
                    //         }
                    //     );
                    // }}
                    onInputChange={(event, newInputValue, reason) => {
                        console.log('onInputChange', newInputValue, reason);
                        if (reason === 'input') {
                            fetchData({
                                type: 'InputChange',
                                displayText: newInputValue,
                            } as ComboBoxUpdateMessage,
                                (data: MessageSchema) => {
                                    console.log('InputChange data:', data);
                                });
                        }
                    }}
                    // onInputChange={(event, newInputValue, reason) => {
                    //     if (reason === 'input') {
                    //         updateFilteredOptions(newInputValue);
                    //         // console.log('last input:', inputValue, 'new input:', newInputValue);
                    //         setInputValue(newInputValue);
                    //         if (comboBox['x-params'].autoSelect) {
                    //             const matchedOption = options.find(option => option.external.toLowerCase().startsWith(newInputValue.toLowerCase()));
                    //             if (matchedOption) {
                    //                 const remainingText = matchedOption.external.substring(newInputValue.length);
                    //                 setInputValue(matchedOption.external);
                    //                 setTimeout(() => {
                    //                     const input = event.target as HTMLInputElement;
                    //                     lastInputLength.current = newInputValue.length;
                    //                     input.setSelectionRange(newInputValue.length, matchedOption.external.length, "backward");
                    //                 }, 0);
                    //             } else {
                    //                 setInputValue(newInputValue); // Keep the user's input if no match is found
                    //             }
                    //         }
                    //     }
                    //     requestDelphiData(
                    //         {
                    //             delphiMessage: {
                    //                 type: 'ComboBoxInputChange',
                    //                 path: path,
                    //                 data: newInputValue
                    //             },
                    //         },
                    //         () => { },
                    //         (error: MessageSchema) => {
                    //             console.error(error.delphiMessage.errorMessage, error);
                    //         }
                    //     );
                    // }}
                    // onBlur={(event) => {
                    //     if (selectedValue && ((selectedValue.external === '') || (comboBox['x-params'].listItemsOnly &&
                    //         !options.some((option) => option.external === selectedValue.external)))) {
                    //         setSelectedValue(emptyItem);
                    //         handleChange(path, null);
                    //         setInputValue('');
                    //     }
                    // }} inputValue={inputValue}
                    renderInput={(params) => (
                        <TextField
                            {...params}
                            variant="outlined"
                            label={label}
                            inputRef={inputRef}
                            onBlur={(event) => {
                                console.log('onBlur', event.target.value);
                                handleOnChange(event.target.value);
                            }}
                            onKeyDown={(event) => {
                                console.log('TextField onKeyDown', event.key);
                                // lastKeyRef.current = event.key;
                                if (event.key === 'ArrowDown' || event.key === 'ArrowUp' || event.key === 'PageDown' || event.key === 'PageUp') {
                                    event.preventDefault();
                                    fetchData({
                                        type: 'KeyPress',
                                        keyPressed: event.key,
                                    } as ComboBoxUpdateMessage,
                                        (data: MessageSchema) => {
                                            console.log('KeyPress data:', data);
                                        });
                                }
                            }
                            }

                        // onChange={(event) => {
                        //     // console.log('TextField onChange', event.target.value);
                        //     if (event.target.value === '') {
                        //         handleOnChange(event, '');
                        //     } else {
                        //         let newValue = event.target.value;
                        //         if (lastKeyRef.current === 'Backspace' && lastInputLength.current === event.target.value.length) {
                        //             newValue = event.target.value.substring(0, lastInputLength.current - 1);
                        //         }
                        //         let newFilteredOptions = updateFilteredOptions(newValue);
                        //         if (comboBox['x-params'].autoSelect && ((comboBox['x-params'].uniqueAutoComplete &&
                        //             newFilteredOptions.length === 1) || (!comboBox['x-params'].uniqueAutoComplete &&
                        //                 newFilteredOptions.length > 0))) {
                        //             handleOnChange(event, newFilteredOptions[0]);
                        //         }
                        //         else {
                        //             handleOnChange(event, newValue);
                        //         }
                        //     }
                        // }}
                        />
                    )
                    }
                    renderOption={(props, option) => (
                        <li {...props} key={option.internal}>
                            {option.external}
                        </li>
                    )}
                    open={open}
                    onOpen={() => setOpen(true)}
                    onClose={() => setOpen(false)}
                    loading={loading}
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
                {comboBoxLoading || options.length === 0 ? (
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