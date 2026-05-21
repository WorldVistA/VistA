import React, { useEffect, useRef } from "react";
import { useTheme } from "@mui/material/styles";
import { TextField, Box } from "@mui/material";
import { withJsonFormsControlProps, withTranslateProps } from "@jsonforms/react";
import { rankWith, isStringControl, isMultiLineControl, RankedTester, and, schemaMatches } from "@jsonforms/core";

/**
 * Wrap text at spaces to ensure no line exceeds max length without breaking words.
 */
const wrapAtSetLengthOnSpace = (text: string, maxLength: number): string => {
    const lines = text.split('\n');
    const newLines = lines.map(line => {
        const words = line.split(' ');
        let newLine = '';
        let currentLine = '';

        for (let i = 0; i < words.length; i++) {
            const word = words[i];
            if ((currentLine + word).length > maxLength) {
                newLine += currentLine.trim() + '\n';
                currentLine = word + ' ';
            } else {
                currentLine += word + ' ';
            }
        }
        newLine += currentLine.trim();
        return newLine;
    });

    return newLines.join('\n');
};

const MultiLineRenderer = ({ data, handleChange, path, label, schema }: any) => {
    const theme = useTheme();
    const fontSize = theme.typography.fontSize; // Use theme's font size
    const fontFamily = theme.typography.fontFamily;
    const color = theme.typography.color || theme.palette.text.primary; // Adjust as needed for color

    // Obtain the custom line width from the schema, default to 80 if not provided
    const lineWidth = schema['x-lineWidth'] || 80;

    const canvasRef = useRef<HTMLCanvasElement | null>(null);

    useEffect(() => {
        if (!canvasRef.current) {
            canvasRef.current = document.createElement('canvas');
        }
    }, []);

    const estimateCharWidth = (text: string) => {
        if (!canvasRef.current) return 0;
        const context = canvasRef.current.getContext('2d');
        if (!context) return 0;
        
        // Set the font style to match the theme
        context.font = `${fontSize}px ${fontFamily}`;
        const metrics = context.measureText(text);
        return metrics.width / text.length;
    };

    // Estimate the width of a character
    const charWidth = estimateCharWidth('m'); // Often 'm' is used for width estimation

    const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
        if (e.key === ' ') {
            const target = e.target as HTMLInputElement;
            const wrapped = wrapAtSetLengthOnSpace(target.value, lineWidth);
            if (wrapped !== data) {
                handleChange(path, wrapped);
            }
        }
    };

    const handleChangeWithWrap = (e: React.ChangeEvent<HTMLInputElement>) => {
        handleChange(path, e.target.value);
    };

    return (
        <Box position="relative" sx={{ width: '100%' }}>
            <TextField
                label={label}
                value={data || ''}
                onChange={handleChangeWithWrap}
                onKeyDown={handleKeyDown}
                multiline
                minRows={4}
                InputProps={{
                    style: {
                        fontFamily,
                        // fontSize: `${fontSize}px`, // Ensure font size from theme
                        color,
                        whiteSpace: 'pre-wrap',
                    },
                }}
                inputProps={{
                    style: {
                        fontFamily,
                        // fontSize: `${fontSize}px`, // Ensure font size from theme
                        color,
                        whiteSpace: 'pre-wrap',
                    }
                }}
                sx={{
                    width: '100%',
                    // Apply theme overrides as needed
                    ...theme.components?.MuiTextField?.styleOverrides?.root,
                    '& .MuiOutlinedInput-root': {
                        ...theme.components?.MuiOutlinedInput?.styleOverrides?.root,
                    },
                    '& .MuiInputBase-root': {
                        ...theme.components?.MuiInputBase?.styleOverrides?.root,
                    },
                    '& .MuiInputBase-input': {
                        ...theme.components?.MuiInputBase?.styleOverrides?.input,
                    },
                }}
            />
            <Box
                sx={{
                    position: 'absolute',
                    top: 0,
                    left: `${charWidth * lineWidth}px`, // Where the line width limit should be
                    height: '100%',
                    width: '2px',
                    backgroundColor: theme.palette.divider,
                    pointerEvents: 'none'
                }}
            />
        </Box>
    );
};

const MultiLineControlTester: RankedTester = rankWith(
    10,
    and(
        isStringControl,
        isMultiLineControl,
        schemaMatches((schema) => {
            const customSchema = schema as any; 
            return (
                Number.isInteger(customSchema['x-lineWidth']) && customSchema['x-lineWidth'] > 0
            );
        })
    )
);

export default withJsonFormsControlProps(
    withTranslateProps(React.memo(MultiLineRenderer)),
    false
);

export { MultiLineControlTester };