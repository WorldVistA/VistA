import { requestDelphiData } from './DataProvider';

interface Item {
  const: string;
  title: string;
  display: string;
}

interface LookupDataItem {
  const: string;
  title: string;
  display: string;
}

interface LookupData {
  data: LookupDataItem[];
}

const lookupDataStore: { [key: string]: Item[] } = {}; // Global store for lookup data
const fetchDataPromises: { [key: string]: Promise<Item[]> | null } = {}; // Track ongoing fetch promises

export const fetchLookupData = (lookupType: string, path: string): Promise<Item[]> => {
  if (lookupDataStore[lookupType]) {
    // Return cached data if already fetched
    return Promise.resolve(lookupDataStore[lookupType]);
  }

  if (!fetchDataPromises[lookupType]) {
    // Create a new fetch promise and store it
    const requestData = {
      delphiMessage: {
        type: 'ComboBoxInputChange',
        path,
        data: { displayText: '', state: 'InputChange', lookupType },
      },
    };

    fetchDataPromises[lookupType] = new Promise((resolve, reject) => {
      requestDelphiData(
        requestData,
        (data) => {
          const lookupData = data.delphiMessage.data as LookupData; // Type cast here
          const items = lookupData.data.map((item, index) => ({
            const: item.const.toString(),
            title: item.title,
            display: item.display || item.title,
            index, // Adding index for potential future use
          }));
          lookupDataStore[lookupType] = items; // Store data globally
          resolve(items);
        },
        (error) => {
          console.error('Fetch error:', error);
          fetchDataPromises[lookupType] = null; // Reset the promise in case of error
          reject(error);
        }
      );
    });
  }

  return fetchDataPromises[lookupType] as Promise<Item[]>;
};

export { lookupDataStore };