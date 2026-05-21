import React, { useState, useEffect } from 'react';
import {
    TranslateProps,
    withJsonFormsControlProps,
    withTranslateProps
} from '@jsonforms/react';
import {
    ControlProps,
    isObjectControl,
    RankedTester,
    rankWith,
    schemaMatches,
    and
} from '@jsonforms/core';
import TextField from '@mui/material/TextField';
import InputAdornment from '@mui/material/InputAdornment';
import IconButton from '@mui/material/IconButton';
import CalendarTodayIcon from '@mui/icons-material/CalendarToday';
import Popover from '@mui/material/Popover';
import { DateTimePicker, LocalizationProvider, StaticDatePicker } from '@mui/x-date-pickers';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import dayjs, { Dayjs } from 'dayjs';
import { fileManToDatePicker, datePickerToFileMan } from './FMDateTimeUtils';
import { requestDelphiData, MessageSchema, xFormatSchema } from "./DataProvider";

interface fmDate {
    internal?: string;
    external?: string;
}
const FMDateControlRenderer = (props: ControlProps & TranslateProps) => {
    const { schema, handleChange, path, data, label, errors, visible, required, description, id, ...otherProps } = props;
    const customSchema = schema as MessageSchema<fmDate>;

    const includeTime = customSchema["x-format"] === 'FMDateTime';

    const [internalValue, setInternalValue] = useState('');
    const [externalValue, setExternalValue] = useState('');
    const [anchorEl, setAnchorEl] = useState<HTMLElement | null>(null);
    const [selectedDate, setSelectedDate] = useState<Dayjs | null>(null);

    useEffect(() => {
        if (data) {
            setExternalValue(data.external || '');
            setInternalValue(data.internal || '');
        }
    }, [data]);

    const handleCustomChange = (path: string, value: any) => {
        let Message: MessageSchema<fmDate> = {
            delphiMessage: {
                path: path,
                type: '',
                data: {
                    internal: '',
                    external: value
                }
            }
        };
        if (includeTime) {
            Message.delphiMessage.type = 'FormatFMDateTime';
        } else {
            Message.delphiMessage.type = 'FormatFMDate';
        }
        requestDelphiData<fmDate>(Message, (data: MessageSchema<fmDate>) => {
            if (data.delphiMessage.data && (data.delphiMessage.data.internal === '-1' ||
                data.delphiMessage.data.internal === '')) {
                handleChange(`${data.delphiMessage.path}`, undefined);
                setInternalValue('');
                setExternalValue('');
            } else if (data.delphiMessage.data) {
                handleChange(`${data.delphiMessage.path}.internal`, data.delphiMessage.data.internal);
                handleChange(`${data.delphiMessage.path}.external`, data.delphiMessage.data.external);
                setExternalValue(data.delphiMessage.data.external || '');
            }
        }, (error: MessageSchema<fmDate>) => {
            console.error(error.delphiMessage.errorMessage, error);
        });
    };

    const handleDateChange = (event: React.FocusEvent<HTMLInputElement | HTMLTextAreaElement> |
        React.KeyboardEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        const { value } = (event.target as HTMLInputElement | HTMLTextAreaElement);
        handleCustomChange(path, value);
    };

    const handleInputChange = (event: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        const { value } = event.target;
        setExternalValue(value);
    };

    useEffect(() => {
    }, [externalValue]);

    const handleCalendarIconClick = (event: React.MouseEvent<HTMLElement>) => {
        // Open the DatePicker with the current internal FileMan date
        setAnchorEl(event.currentTarget);
        setSelectedDate(internalValue ? dayjs(fileManToDatePicker(internalValue)) : null);
    };

    const handleDatePicked = (newDate: Dayjs | null) => {
        setSelectedDate(newDate);
        if (newDate && includeTime) {
            // Convert the selected date to the FileMan format
            const newInternalValue = datePickerToFileMan(newDate.format('YYYY-MM-DDTHH:mm:ss'), true);
            // Call the custom change handler to notify Delphi
            handleCustomChange(path, newInternalValue);
            // Update the internal and external values
            setInternalValue(newInternalValue);
            setExternalValue(newDate.format('YYYY-MM-DDTHH:mm:ss'));
        }
    };

    const handleOkClick = () => {
        if (selectedDate) {
            // Convert the selected date to the FileMan format
            const newInternalValue = datePickerToFileMan(selectedDate.format(includeTime ? 'YYYY-MM-DDTHH:mm:ss' : 'YYYY-MM-DD'), includeTime);
            // Call the custom change handler to notify Delphi
            handleCustomChange(path, newInternalValue);
            // Update the internal and external values
            setInternalValue(newInternalValue);
            setExternalValue(selectedDate.format(includeTime ? 'YYYY-MM-DDTHH:mm:ss' : 'YYYY-MM-DD'));
            // Update the JSON object with separate internal and external values
            handleChange(path, { internal: newInternalValue, external: selectedDate.format(includeTime ? 'YYYY-MM-DDTHH:mm:ss' : 'YYYY-MM-DD') });
            // Close the DatePicker
            setAnchorEl(null);
        }
    };

    const handleClose = () => {
        setAnchorEl(null);
    };

    return (
        <>
            <TextField
                {...otherProps}
                label={label}
                value={externalValue}
                onChange={handleInputChange}
                onBlur={(event) => {
                    handleDateChange(event as React.FocusEvent<HTMLInputElement | HTMLTextAreaElement>);
                }}
                onKeyDown={(e) => {
                    if (e.key === 'Enter') {
                        handleDateChange(e as React.KeyboardEvent<HTMLInputElement | HTMLTextAreaElement>);
                    }
                }}
                error={!!errors}
                helperText={errors}
                required={required}
                fullWidth
                InputProps={{
                    endAdornment: (
                        <InputAdornment position="end" sx={{ marginRight: '-15px' }}>
                            <IconButton onClick={handleCalendarIconClick}>
                                <CalendarTodayIcon />
                            </IconButton>
                        </InputAdornment>
                    ),
                }}
            />
            <Popover
                open={Boolean(anchorEl)}
                anchorEl={anchorEl}
                onClose={handleClose}
                anchorOrigin={{
                    vertical: 'bottom',
                    horizontal: 'center',
                }}
                transformOrigin={{
                    vertical: 'top',
                    horizontal: 'center',
                }}
            >
                <LocalizationProvider dateAdapter={AdapterDayjs}>
                    {includeTime ? (
                        <div>
                            <DateTimePicker
                                value={internalValue ? dayjs(fileManToDatePicker(internalValue, true)) : null}
                                onChange={handleDatePicked}
                                ampm={false}
                                open
                                onClose={handleClose}
                                sx={{
                                    '& .MuiInputBase-root': {
                                        display: 'none',
                                    },
                                }}
                            />
                        </div>
                    ) : (
                        <div>
                            <StaticDatePicker
                                displayStaticWrapperAs="desktop"
                                value={selectedDate}
                                onChange={handleDatePicked}
                                views={['year', 'month', 'day']}
                            />
                            <div style={{ display: 'flex', justifyContent: 'flex-end', padding: '8px' }}>
                                <button onClick={handleOkClick}>OK</button>
                            </div>
                        </div>
                    )}
                </LocalizationProvider>
            </Popover>
        </>
    );
};

const FMDateControlTester: RankedTester = rankWith(
    10, // Adjust the rank as needed
    and(
        isObjectControl,
        schemaMatches((schema) => {
            const customSchema = schema as xFormatSchema;
            return typeof customSchema["x-format"] === 'string' && (customSchema["x-format"] === 'FMDate' || customSchema["x-format"] === 'FMDateTime');
        })
    )
);

export default withJsonFormsControlProps(
    withTranslateProps(React.memo(FMDateControlRenderer)),
    false
);

export { FMDateControlTester };