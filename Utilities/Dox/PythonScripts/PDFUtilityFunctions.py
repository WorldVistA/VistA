#---------------------------------------------------------------------------
# Copyright 2018 The Open Source Electronic Health Record Agent
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


def generatePDFTableHeader(headerList, splitHeader=True):
    row = []
    for header in headerList:
        cell = []
        if splitHeader:
            # TODO: There is an extra line between words
            words = header.split(" ")
            for word in words:
                cell.append(Paragraph(word, styles['Heading4']))
        else:
            cell.append(Paragraph(header, styles['Heading4']))
        row.append(cell)
    return row
