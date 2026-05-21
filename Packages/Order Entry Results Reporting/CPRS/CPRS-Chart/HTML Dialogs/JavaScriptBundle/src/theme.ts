import { createTheme, PaletteMode } from '@mui/material/styles';
import { blue, grey, orange, yellow, indigo } from '@mui/material/colors';

function Addpx(value: number): string {
    return `${Math.round(value)}px`;
}

interface FontConfig {
    size: number;
    height: number;
    family: string;
    color: string;
    paddingLeftRight: string;
    paddingTopBottom: string;
}

interface ScrollbarConfig {
    scrollbarWidth: number;
    scrollbarColor: string;
    scrollbarThumbHeight: number;
    scrollbarThumbWidth: number;
    scrollbarThumbColor: string;
}

const fontSize = window.initialJSONFontSize || 12;

export const fontConfig: FontConfig = {
    size: fontSize,
    height: window.initialJSONFontHeight || 20,
    family: window.initialJSONFontFamily || 'Roboto, Arial, sans-serif',
    color: window.initialJSONFontColor || '#333',
    paddingLeftRight: Addpx(fontSize / 2),
    paddingTopBottom: Addpx(fontSize / 6),
};

export const scrollbarConfig: ScrollbarConfig = {
    scrollbarColor: window.initialJSONScrollBarColor || 'lightgray',
    scrollbarWidth: window.initialJSONScrollBarWidth || 8,
    scrollbarThumbHeight: window.initialJSONThumbHeight || 16,
    scrollbarThumbWidth: window.initialJSONThumbWidth || 6,
    scrollbarThumbColor: window.initialJSONThumbColor || 'gray',
};

export const createCustomTheme = (mode: PaletteMode = 'light') => {
    const isDarkMode = mode === 'dark';

    const customStyle = {
        styleOverrides: {
            root: {
                color: isDarkMode ? '#ffffff' : fontConfig.color,
                marginBottom: '10px',
                backgroundColor: isDarkMode ? '#121212' : '#ffffff',
            },
            input: {
                backgroundColor: isDarkMode ? '#333' : '#ffffff',
                color: isDarkMode ? '#ffffff' : fontConfig.color,
                // fontSize: `${fontConfig.size}px`, // Ensure font size consistency
                fontSize: `0.75rem`, // Ensure font size consistency
                height: '44px',
                '&$focused': {
                    fontWeight: 'bold',
                },
            },
        },
    };

    const customOutlineStyle = {
        ...customStyle,
        styleOverrides: {
            ...customStyle.styleOverrides,
            input: {
                ...customStyle.styleOverrides.input,
                paddingLeft: fontConfig.paddingLeftRight,
                paddingTop: fontConfig.paddingTopBottom,
                paddingBottom: fontConfig.paddingTopBottom,
                '&.Mui-error': {
                    borderColor: blue[700],
                },
            },
            notchedOutline: {
                '& legend': {
                    width: 0,
                },
                borderColor: isDarkMode ? '#ffffff' : '#000000',
                '&.Mui-error': {
                    borderColor: blue[700],
                },
                '&.Mui-focused': {
                    fontWeight: 'bold',
                },
            },
            root: {
                ...customStyle.styleOverrides.root,
                backgroundColor: undefined,
                '&.MuiOutlinedInput-root': {
                    marginTop: Addpx(fontConfig.height),
                    backgroundColor: isDarkMode ? '#333' : '#ffffff',
                    '&.Mui-error .MuiOutlinedInput-notchedOutline': {
                        borderColor: blue[700],
                    },
                    '&.Mui-error .MuiInputBase-input': {
                        color: blue[700],
                    },
                    '&.Mui-focused': {
                        borderColor: blue[700],
                    },
                },
            },
            shrink: {
                // fontSize: `0.75rem`,
                fontFamily: fontConfig.family,
                color: isDarkMode ? '#ffffff' : fontConfig.color,
                transform: 'translate(0px, -1px) scale(1.1)',
            },
        },
    };

    const customNoOutlineStyle = {
        ...customStyle,
        styleOverrides: {
            ...customStyle.styleOverrides,
            root: {
                ...customStyle.styleOverrides.root,
                backgroundColor: undefined,
                '&.MuiOutlinedInput-root': {
                    marginTop: '-' + fontConfig.size,
                    backgroundColor: isDarkMode ? '#333' : '#ffffff',
                },
            },
        },
    };

    const customComboBoxStyle = {
        ...customOutlineStyle,
        styleOverrides: {
            ...customOutlineStyle.styleOverrides,
            input: {
                ...customOutlineStyle.styleOverrides.input,
                height: '20px', 
                padding: '8px 14px', 
            },
        },
    };

    const theme = createTheme({
        palette: {
            mode,
            background: {
                default: isDarkMode ? '#121212' : '#ffffff',
                paper: isDarkMode ? '#1d1d1d' : '#ffffff',
            },
            primary: {
                main: isDarkMode ? '#ffffff' : '#121212',
                contrastText: '#ffffff',
            },
            secondary: {
                main: orange[500],
                contrastText: '#ffffff',
            },
            error: {
                main: blue[500],
                contrastText: '#ffffff',
            },
            warning: {
                main: yellow[700],
            },
            info: {
                main: indigo[300],
            },
            success: {
                main: grey[800],
            },
        },
        typography: {
            fontSize: fontConfig.size,
            fontFamily: fontConfig.family,
        },
        components: {
            MuiTextField: customOutlineStyle,
            MuiSelect: customOutlineStyle,
            MuiOutlinedInput: {
                styleOverrides: {
                    root: {
                        marginTop: Addpx(fontConfig.height),
                        backgroundColor: isDarkMode ? '#333' : '#ffffff',
                        '&.Mui-error .MuiOutlinedInput-notchedOutline': {
                            borderColor: blue[700],
                        },
                        '&.Mui-error .MuiInputBase-input': {
                            color: blue[700],
                        },
                        '&.Mui-focused': {
                            borderColor: blue[700],
                        },
                        '&.MuiOutlinedInput-multiline': {
                            padding: '14px 14px', 
                            height: 'auto', 
                            display: 'flex',
                            flexDirection: 'column',
                            overflow: 'hidden',
                        },
                    },
                    input: {
                        paddingLeft: fontConfig.paddingLeftRight,
                        paddingTop: fontConfig.paddingTopBottom,
                        paddingBottom: fontConfig.paddingTopBottom,
                        '&.Mui-error': {
                            borderColor: blue[700],
                        },
                        backgroundColor: isDarkMode ? '#333' : '#ffffff',
                        color: isDarkMode ? '#ffffff' : fontConfig.color,
                        fontSize: `1rem`,
                        // fontSize: `${fontConfig.size}px`,
                        padding: `${Addpx(fontConfig.size / 4)} ${fontConfig.paddingLeftRight}`,
                        '&$focused': {
                            fontWeight: 'bold',
                        },
                    },
                    notchedOutline: {
                        '& legend': {
                            width: 0,
                        },
                        borderColor: isDarkMode ? '#ffffff' : '#000000',
                        '&.Mui-error': {
                            borderColor: blue[700],
                        },
                        '&.Mui-focused': {
                            fontWeight: 'bold',
                        },
                    },
                    multiline: {
                        padding: '14px 14px',
                        height: 'auto', 
                        overflow: 'hidden', 
                        resize: 'none', 
                        display: 'flex',
                        flexDirection: 'column',
                    },
                },
            },
            MuiCheckbox: customNoOutlineStyle,
            MuiRadio: customNoOutlineStyle,
            MuiSwitch: {
                styleOverrides: {
                    switchBase: {
                        color: grey[300],
                        '&.Mui-checked': {
                            color: blue[700],
                            '& + .MuiSwitch-track': {
                                backgroundColor: blue[700],
                            },
                        },
                    },
                    root: {
                        ...customNoOutlineStyle.styleOverrides.root,
                    },
                },
            },
            MuiSlider: customNoOutlineStyle,
            MuiButton: {
                styleOverrides: {
                    root: {
                        '&.button-clicked': {
                            backgroundColor: blue[100],
                            color: 'white',
                            fontWeight: 'bold',
                        },
                        '&.button-unclicked': {
                            backgroundColor: grey[300],
                            color: 'white',
                            fontWeight: 'normal',
                        },
                    },
                },
            },
            MuiAutocomplete: customComboBoxStyle,
            MuiFormControl: customOutlineStyle,
            MuiInput: customOutlineStyle,
            MuiInputBase: {
                ...customOutlineStyle,
                styleOverrides: {
                    ...customOutlineStyle.styleOverrides,
                    input: {
                        height: '44px',
                    },
                },
            },
            MuiFormControlLabel: customOutlineStyle,
            MuiFormGroup: customOutlineStyle,
            MuiFormLabel: customOutlineStyle,
            MuiFormHelperText: customOutlineStyle,
            MuiInputLabel: {
                defaultProps: {
                    shrink: true,
                },
                ...customOutlineStyle,
                styleOverrides: {
                    root: {
                        color: isDarkMode ? '#ffffff' : fontConfig.color,
                        fontSize: '1rem',
                        fontWeight: 'bold',
                        lineHeight: '1.5',
                    },
                },
            },
            MuiTypography: {
                styleOverrides: {
                    root: {
                        fontSize: `1rem`,
                        // fontSize: fontConfig.size,
                        fontFamily: fontConfig.family,
                    },
                    body1: {
                        lineHeight: '1.5',
                    },
                },
            },
            MuiMenu: customNoOutlineStyle,
            MuiMenuItem: customNoOutlineStyle,
            MuiAvatar: {
                styleOverrides: {
                    root: {
                        backgroundColor: blue[300],
                        color: 'white',
                    },
                },
            },
        },
    });

    return theme;
};