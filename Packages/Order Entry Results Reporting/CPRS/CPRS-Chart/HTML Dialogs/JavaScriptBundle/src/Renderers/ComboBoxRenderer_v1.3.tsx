import React, { useState, useEffect, useRef } from 'react';
import { FixedSizeList } from 'react-window';
import { Autocomplete, TextField, CircularProgress } from '@mui/material';
// import {
//     List as VirtualizedList,
//     ListRowProps,
//     InfiniteLoader,
//     IndexRange,
//     AutoSizer
// } from 'react-virtualized';
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
import './ComboBoxRenderer.css';

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
    dropDownCount?: number;
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

// ComboBoxControlRenderer component
const ComboBoxControlRenderer: React.FC<ControlProps & OwnPropsOfEnum &
    WithOptionLabel & TranslateProps> = (props) => {
        const { data, handleChange, path, schema, uischema, label, ...otherProps } = props;
        const customSchema = schema as ComboBoxSchema;
        const lastKeyRef = useRef('');
        const lastInputLength = useRef(0);
        const listRef = useRef<FixedSizeList>(null);
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
                style: (xParams.style || 'orcsSimple') as ComboBoxStyle,
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
        const [open, setOpen] = useState(false);
        const [loading, setLoading] = useState(false);

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
                if (newFilteredOptions.length === 0) {
                    setLoading(true);
                    requestDelphiData(
                        {
                            delphiMessage: {
                                type: 'ComboBoxNeedData',
                                data: inputValue,
                            },
                        },
                        (data: MessageSchema) => {
                            setComboBox(data as ComboBoxSchema);
                            setLoading(false);
                        },
                        (error: MessageSchema) => {
                            console.error(error.delphiMessage.errorMessage, error);
                            setLoading(false);
                        }
                    );

                }
                setFilteredOptions(newFilteredOptions);
                return newFilteredOptions;
            } else {
                setFilteredOptions(options);
                const temp: item[] = [];
                return temp;
            }
        }

        const updateLongListOptions = (input: item[]) => {
            if (alphaDistribution.length > 0) {
                const firstItemIndex = alphaDistribution.findIndex(item => item.localeCompare(input[0].external) >= 0);
                const lastItemIndex = alphaDistribution.findIndex(item => item.localeCompare(input[input.length - 1].external) <= 0);
                const beforeItems = alphaDistribution.slice(0, firstItemIndex).map(item => ({ internal: '-1', external: item }));
                const afterItems = alphaDistribution.slice(lastItemIndex).map(item => ({ internal: '-1', external: item }));;
                setOptions([...beforeItems, ...input, ...afterItems]);
            }
            else {
                setOptions(input);
            }
        }

        useEffect(() => {
            xParams = comboBox['x-params'] || {};
            let newOptions = xParams.items || [];
            if (xParams.sorted) {
                newOptions = newOptions.sort((a, b) => a.external.localeCompare(b.external));
            }
            if (xParams.longList && !alphaLoading) {
                updateLongListOptions(newOptions);
            } else {
                setOptions(newOptions);
            }
        }, [comboBox]);

        useEffect(() => {

            // if (comboBox['x-params'].longList) {
            //   const comboBoxCopy = { ...comboBox };
            //   comboBoxCopy['x-params'].waterMark = 0;
            // }
            requestDelphiData(
                {
                    ...comboBox,
                    delphiMessage: {
                        type: 'ComboBoxCreate',
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
            xParams = comboBox['x-params'] || {};
            let newOptions = xParams.items || [];
            if (newOptions.length > 0) {
                updateLongListOptions(newOptions);
            }
        }, [alphaDistribution.length > 0]);

        const renderDropdownList = () => {
            interface CustomFilterOptions {
                inputValue: string;
            }

            const customFilter = (options: item[], { inputValue }: CustomFilterOptions): item[] => {
                return options;
            };

            function handleOnChange(event: React.SyntheticEvent, newValue: item | string | null) {
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
                setSelectedValue(newValueObject);
                handleChange(path, newValueObject);
            }

            const Row: React.FC<{ index: number; style: React.CSSProperties }> = ({ index, style }) => {
                const option = filteredOptions[index];
                return (
                    <div key={index} className="list-item" tabIndex={-1} style={style as React.CSSProperties}>
                        {option.external}
                    </div>
                );
            };

            const itemHeight = 35;
            const dropDownCount = comboBox['x-params'].dropDownCount || 8;

            return (
                <Autocomplete
                    open={open}
                    onOpen={() => setOpen(true)}
                    onClose={() => setOpen(false)}
                    autoSelect={comboBox['x-params'].autoSelect &&
                        (!comboBox['x-params'].uniqueAutoComplete || filteredOptions.length === 1)}
                    freeSolo={!comboBox['x-params'].listItemsOnly}
                    filterOptions={customFilter}
                    loading={loading}
                    value={selectedValue}
                    onChange={(event, newValue, reason) => {
                        handleOnChange(event, newValue);
                    }}
                    onInputChange={(event, newInputValue, reason) => {
                        if (reason === 'input') {
                            updateFilteredOptions(newInputValue);
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
                                    setInputValue(newInputValue);
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
                            }} InputProps={{
                                ...params.InputProps,
                                endAdornment: (
                                    <React.Fragment>
                                        {loading ? <CircularProgress color="inherit" size={itemHeight - 2} /> : null}
                                        {params.InputProps.endAdornment}
                                    </React.Fragment>
                                ),
                            }}
                            onChange={(event) => {
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
                                }}
                            />
                        )}
                        PaperComponent={({ children, ...listboxProps }) => (
                        <FixedSizeList
                            ref={listRef}
                            height={itemHeight * dropDownCount}
                            itemCount={filteredOptions.length}
                            itemSize={itemHeight}
                            width="100%"
                            innerElementType="div" as any
                            {...listboxProps}
                        >
                            {Row}
                        </FixedSizeList>
                    )}
                />
            );
        };

        // Conditionally render the list based on the LongList and ListItemsOnly properties
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