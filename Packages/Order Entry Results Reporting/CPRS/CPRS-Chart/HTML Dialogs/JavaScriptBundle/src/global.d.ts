export { };

declare global {
  interface Window {
    chrome: {
      webview: {
        postMessage: (message: string) => void;
      };
    };
    getFormData?: (type: string) => void;
    updateData?: { [callId: string]: (dataObject: string) => void };
    initialJSONFontSize: number;
    initialJSONFontHeight: number;
    initialJSONFontFamily: string;
    initialJSONFontColor: string;
    initialJSONScrollBarWidth: number;
    initialJSONScrollBarColor: string;
    initialJSONThumbHeight: number;
    initialJSONThumbWidth: number;
    initialJSONThumbColor: string;
    
  }
}