#---------------------------------------------------------------------------
# Copyright 2013 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------
import re
from datetime import datetime, date, time

def fmDtToPyDt(fileManDt):
  """ convert fileman time to Python datetime
      return None if format is not valid
  """
  """ check to see if datetime is valid or not"""
  validFmt = re.compile('^(?P<date>[0-9]{6,})(?P<time>\.[0-9]{0,6})?$')
  result = validFmt.search(fileManDt)
  if result:
    datePart = result.group('date')
    timePart = result.group('time')
    if not datePart: return None # must at least have a date part
    if len(datePart) < 7:
      datePart = datePart.ljust(7,'0')
    try:
      outDate = date(int(datePart[0:-4]) + 1700,
                     int(datePart[-4:-2]),
                     int(datePart[-2:]))
    except ValueError:
      return None
    outTime = time()
    if timePart and timePart[1:]: # has some time part here
      timePart = timePart[1:].ljust(6,'0')
      hour = timePart[0:2]
      if int(hour) == 24: # special handling for mid-night
        outTime = time(23,59,59)
      else:
        try:
          outTime = time(int(timePart[0:2]),
                         int(timePart[2:4]),
                         int(timePart[-2:]))
        except ValueError:
          return None
    return datetime.combine(outDate, outTime)
  return None

def testFmDtToPyDt():
  fileManDt = ("3121201.2308",
               "2970919.12",
               "2970919.24",
               "2970919.082701",
               "3091203.09072",
               )
  for fmDt in fileManDt:
    print fmDtToPyDt(fmDt)

if __name__ == '__main__':
  testFmDtToPyDt()
