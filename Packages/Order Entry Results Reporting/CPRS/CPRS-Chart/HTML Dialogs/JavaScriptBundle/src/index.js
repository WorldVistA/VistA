import React, { useState, useEffect, useRef, useCallback } from 'react';
import { createRoot } from 'react-dom/client';
import { JsonForms } from '@jsonforms/react';
import { materialRenderers, materialCells } from '@jsonforms/material-renderers';
import Ajv from 'ajv';
import addErrors from 'ajv-errors';
import addFormats from 'ajv-formats';
import { ThemeProvider } from '@mui/material/styles';
import useMediaQuery from '@mui/material/useMediaQuery';
import CssBaseline from '@mui/material/CssBaseline';
import { createCustomTheme } from './theme';
import FMDateControlRenderer, { FMDateControlTester } from './FMDateRenderer';
import ComboBoxLongListControlRenderer, { ComboBoxLongListControlTester } from './ComboBoxLongListControlRenderer';
import ComboBoxControlRenderer, { ComboBoxControlTester } from './ComboBoxControlRenderer';
import MultiLineRenderer, { MultiLineControlTester } from './MultiLineRenderer';
import ErrorBoundary from './ErrorBoundary'; // Import the ErrorBoundary component

const jfSchema = window.initialJSONSchema || {};
const jfUISchema = window.initialJSONUISchema || {};
const jfData = window.initialJSONData || {};

const renderers = [
  ...materialRenderers,
  { tester: FMDateControlTester, renderer: FMDateControlRenderer },
  { tester: ComboBoxLongListControlTester, renderer: ComboBoxLongListControlRenderer },
  { tester: ComboBoxControlTester, renderer: ComboBoxControlRenderer },
  { tester: MultiLineControlTester, renderer: MultiLineRenderer }
];

const ajvErrorsOptions = {
  keepErrors: false,
  singleError: true
};

const ajv = new Ajv({ allErrors: true, strict: false });
addFormats(ajv);
addErrors(ajv);

function hasValidationErrors(validateFn, data, schema) {
  const valid = validateFn(data);
  if (!valid) {
    return validateFn.errors || [];
  }
  return [];
}

function App() {
  const prefersDarkMode = useMediaQuery('(prefers-color-scheme: dark)');
  const theme = createCustomTheme(prefersDarkMode ? 'dark' : 'light');

  const [data, setData] = useState(jfData);
  const [errors, setErrors] = useState([]);
  const [validate, setValidate] = useState(null);
  const validateRef = useRef(null);

  useEffect(() => {
    const compileSchema = async () => {
      try {
        const validateFunction = ajv.compile(jfSchema);
        setValidate(() => validateFunction);
        validateRef.current = validateFunction;
        const validationErrors = hasValidationErrors(validateFunction, jfData, jfSchema);
        // console.log('In Compiled Schema after errors', validationErrors);
        setErrors(validationErrors);
      } catch (error) {
        console.error('Error compiling schema:', error);
      }
    };

    compileSchema();
  }, [jfSchema]);

  window.getFormData = type => {
    const formData = { ...data, delphiMessage: { type: type } };
    const validationErrors = hasValidationErrors(validateRef.current, data, jfSchema);

    if (type === 'JSONFormSaving') {
      if (validationErrors.length === 0) {
        window.chrome.webview.postMessage(JSON.stringify(formData));
      } else {
        const formattedErrors = validationErrors.map(error => `${error.message}`);
        alert('Please correct the following errors:\n\n' + formattedErrors.join('\n'));
      }
    } else {
      window.chrome.webview.postMessage(JSON.stringify(formData));
    }
  };

  const onChange = useCallback(({ data }) => {
    if (validateRef.current) {
      const validationErrors = hasValidationErrors(validateRef.current, data, jfSchema);
      // console.log('In on change after errors', validationErrors);
      setErrors(validationErrors);
      setData(data);
    }
  }, []);

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <JsonForms
        schema={jfSchema}
        uischema={jfUISchema}
        data={data}
        renderers={renderers}
        cells={materialCells}
        onChange={onChange}
        validationMode="ValidateAndShow"
        // additionalErrors={errors}
      />
    </ThemeProvider>
  );
}

const container = document.getElementById('root');
const root = createRoot(container);
root.render(
  <ErrorBoundary>
    <App />
  </ErrorBoundary>
);