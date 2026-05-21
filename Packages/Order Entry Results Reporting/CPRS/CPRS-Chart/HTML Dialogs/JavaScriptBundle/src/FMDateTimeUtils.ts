// Function to convert FileMan date to DatePicker format (YYYY-MM-DDTHH:mm:ss)
export const fileManToDatePicker = (fileManDate: string, includeTime: boolean = false): string => {
  // Ensure fileManDate is treated as a string
  fileManDate = String(fileManDate);

  // Assuming FileMan date format is YYYMMDD.HHMMSS where YYY is added to 1700
  if (!fileManDate || fileManDate.length < 7) {
    return '';
  }
  const year = (parseInt(fileManDate.substring(0, 3), 10) + 1700).toString();
  const month = fileManDate.substring(3, 5);
  const day = fileManDate.substring(5, 7);
  let datePickerDate = `${year}-${month}-${day}`;

  if (includeTime && fileManDate.length > 7) {
    const time = fileManDate.substring(8);
    const hours = time.substring(0, 2);
    const minutes = time.substring(2, 4);
    const seconds = time.substring(4, 6);
    datePickerDate += `T${hours}:${minutes}:${seconds}`;
  }

  return datePickerDate;
};

// Function to convert DatePicker format (YYYY-MM-DDTHH:mm:ss) to FileMan date
export const datePickerToFileMan = (datePickerDate: string, includeTime: boolean = false): string => {
  // Ensure datePickerDate is treated as a string
  datePickerDate = String(datePickerDate);

  // Assuming DatePicker date format is YYYY-MM-DDTHH:mm:ss
  if (!datePickerDate || datePickerDate.length < 10) {
    return '';
  }
  const year = (parseInt(datePickerDate.substring(0, 4), 10) - 1700).toString().padStart(3, '0');
  const month = datePickerDate.substring(5, 7);
  const day = datePickerDate.substring(8, 10);
  let fileManDate = `${year}${month}${day}`;

  if (includeTime && datePickerDate.length > 10) {
    const time = datePickerDate.substring(11);
    const hours = time.substring(0, 2);
    const minutes = time.substring(3, 5);
    const seconds = time.substring(6, 8);
    fileManDate += `.${hours}${minutes}${seconds}`;
  }

  return fileManDate;
};