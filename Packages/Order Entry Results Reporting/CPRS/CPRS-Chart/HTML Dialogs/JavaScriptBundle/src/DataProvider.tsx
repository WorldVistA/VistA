import { JsonSchema } from '@jsonforms/core';

export interface xFormatSchema extends JsonSchema {
    [key: `x-${string}`]: any;
    title?: string;
    type?: string;
}

export type DelphiMessageSchema<T> = {
    callId?: string;
    data?: T;
    error?: any;
    errorMessage?: string;
    path?: string;
    type: string;
};

export type MessageSchema<T> = xFormatSchema & {
    delphiMessage: DelphiMessageSchema<T>;
};

export type SuccessCallback<T> = (data: MessageSchema<T>) => void;
export type ErrorCallback<T> = (error: MessageSchema<T>) => void;

const DelphiTimeout = 5 * 60 * 1000; // 5 minutes

// type DelphiRequest<T> = (message: MessageSchema<T>, onSuccess: SuccessCallback<T>, onError: ErrorCallback<T>) => void;

let DataProviderCallIndex: number = 0;
let DataProviderTimeouts: { [key: string]: NodeJS.Timeout } = {};

// Generate a unique callId
const getNewCallID = (): string => {
    DataProviderCallIndex++;
    if (DataProviderCallIndex === Number.MAX_SAFE_INTEGER) {
        DataProviderCallIndex = 0;
    }
    return DataProviderCallIndex.toString() + ';' + Date.now().toString();
};

function BuildErrorMessage<T>(delphiMessage: DelphiMessageSchema<T>, error: any) {
    let temp: string = 'Error ';
    if (delphiMessage.type) {
        temp += ' Message Type:' + delphiMessage.type;
    }
    if (delphiMessage.path) {
        temp += ' Path:' + delphiMessage.path;
    }
    if (delphiMessage.callId) {
        temp += ' CallId:' + delphiMessage.callId;
    }
    delphiMessage.errorMessage = temp;
    delphiMessage.error = error;
    console.error('BuildError:', temp, error);
}

export function requestDelphiData<T>(message: MessageSchema<T>, onSuccess: SuccessCallback<T>, onError: ErrorCallback<T>): void {
    let result = message;

    function CallAsync(): Promise<MessageSchema<T>> {
        return new Promise((resolve, reject) => {
            let callId = getNewCallID();
            result.delphiMessage.callId = callId;
            delete result.delphiMessage.error;
            DataProviderTimeouts[callId] = setTimeout(() => {
                if (window.updateData) {
                    delete window.updateData[callId];
                }
                delete DataProviderTimeouts[callId];
                BuildErrorMessage<T>(result.delphiMessage, new Error('Timeout: ' + 
                    message.delphiMessage.type + ' data retrieval took too long'));
                reject(result);
            }, DelphiTimeout);

            window.updateData = window.updateData || {};
            window.updateData[callId] = (dataObject: string) => {
                try {
                    clearTimeout(DataProviderTimeouts[callId]);
                    delete DataProviderTimeouts[callId];
                    result = JSON.parse(dataObject) as MessageSchema<T>;
                    // console.log('DataProvider: ' + result.delphiMessage.type + ' data received', result);
                    resolve(result);
                } catch (error) {
                    BuildErrorMessage<T>(result.delphiMessage, error);
                    reject(result);
                } finally {
                    if (window.updateData) {
                        delete window.updateData[callId];
                    }
                }
            }
            // console.log('Sending message via webview:', result);
            window.chrome.webview.postMessage(JSON.stringify(result));
        });
    }

    CallAsync().then((data) => {
        onSuccess(data);
    }).catch((error) => {
        onError(error);
    });
}