/*!/usr/bin/env python
* A set of Javascript functions which will allow the DOX page to be downloaded
* as a PDF file
#---------------------------------------------------------------------------
* Copyright 2017 The Open Source Electronic Health Record Agent
#
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
#
*     http://www.apache.org/licenses/LICENSE-2.0
#
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// For explanation of units, see:
// https://github.com/bpampuch/pdfmake/issues/359
var margin = 36;  // 0.5 inches
var pageWidth = 792 - (2 * margin); // 11 inches
// Capture the DOX images as DataURL to be shown in the PDF
function toDataUrl(file,callback) {
  var xhr = new XMLHttpRequest();
  xhr.onload = function() {
    var reader = new FileReader();
    reader.onload = function() {
    };
    reader.onloadend = function() {
      var image = new Image();
      image.onload = function() {
        callback(reader.result, image.width, image.height);
      };
      image.src = reader.result;
    }
    reader.readAsDataURL(xhr.response);
  }
  if (typeof file != "undefined") {
    xhr.open('GET', file);
    xhr.responseType = 'blob';
    xhr.send();
  } else {
    callback("data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAABAAEDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9/KKKKAP/2Q==")
  }
}

// Get the data that should only be shown as text
function getText(pdfObj,titleIndex) {
  returnText = $("."+pdfObj.tag).text()
  if("needsSplit" in pdfObj) {
    returnText = $("."+pdfObj.tag).first().text()
    if (titleIndex =="2") {
    returnText = $("."+pdfObj.tag).last().text()
    }
  }
  return {text:returnText};
}

// Get table with header
function getTableListWithHeader(pdfObj,titleIndex) {
  var returnObj = [];
  var tableRows = $("tr." + pdfObj.tag);
  if (tableRows.length == 0) {
    return "";
  }
  for (var row = 0; row < tableRows.length; row++) {
    var rowObj = [];
    var tableObj = $(tableRows[row]).children();
    tableObj.each(function(child){
      rowObj[child % pdfObj.numCols] = $(tableObj[child]).text()
    });
    returnObj.push(rowObj);
  }
  if (returnObj.length == 0) {
    returnObj.push("");
  }

  // Add style to headers
  var headers = [];
  for (var col = 0; col < pdfObj.numCols; col++) {
    var headerText = returnObj[0][col];
    var header = { text: headerText, style: "tableheader"}
    headers.push(header);
  }
  returnObj[0] = headers;

  var docDefinitionAddition = {
    table: {
      headerRows: 1,
      widths:getColumnSizes(pdfObj),
      body: returnObj
    },
    layout: {
      fillColor: function (i, node) { return (i % 2 === 0) ?  '#CCCCCC' : null;
    }
  }};
  return docDefinitionAddition;
}

// Get table with no headers
function getTableList(pdfObj,titleIndex) {
  var rowObj = [];
  var returnObj = [];
  var fullVals = [];
  if("needsSplit" in pdfObj) {
    targetAccord = $(".accordion")[titleIndex-1]
    fullVals = $(targetAccord).find("."+pdfObj.tag).text().split(pdfObj.sep);
  } else {
    fullVals = $("."+pdfObj.tag).text().split(pdfObj.sep);
  }
  if (fullVals.length == 1) {
    // Empty table
    return "";
  }
  var i,j;
  for (i=0,j=fullVals.length; i<j; i++) {
    if (i % pdfObj.numCols == 0 && i !=0) {
      // Add row to table
      returnObj.push(rowObj);
      rowObj = [];
    }
    // Add column to row
    rowObj[i % pdfObj.numCols] = (fullVals[i]);
  }

  if (rowObj.length > 1) {
    // Make sure all cells are populated
    for (var col = rowObj.length; col < pdfObj.numCols; col++) {
      rowObj.push("");
    }
    returnObj.push(rowObj);
  }

  var docDefinitionAddition = {
    table: {
      widths: getColumnSizes(pdfObj),
      body: returnObj
    },
    layout: {
      fillColor: function (i, node) { return (i % 2 === 0) ?  '#CCCCCC' : null;
    }
  }};
  return docDefinitionAddition;
}

function getColumnSizes(pdfObj)
{
  var sizeArray = [];
  if (pdfObj.stretchColumn) {
    for (i = 0; i < pdfObj.numCols; i++) {
      if (i === pdfObj.stretchColumn) { sizeArray.push('*'); }
      else { sizeArray.push('auto'); }
    }
  } else if (pdfObj.columnSizes) {
    for (i = 0; i < pdfObj.numCols; i++) {
      var columnSize = pdfObj.columnSizes[i];
      if (columnSize > 0) { sizeArray.push(columnSize * pageWidth); }
      else { sizeArray.push('auto'); }
    }
  } else {
    // TODO: Can just use 'auto'? Or not specify width at all?
    var colSize = pageWidth / pdfObj.numCols;
    for (i = 0; i < pdfObj.numCols; i++) {
      sizeArray.push(colSize);
    }
  }
  return sizeArray;
}

var titleDic  =  {
  // Package
  // TODO: "Additional Global Namespace" should be on its own line
  "Namespace": {"tag": "packageNamespace","sep": /\s{3}/,"generator": getText,"numCols":0},
  // TODO: Display link to documentation?
  //"Doc": {"tag": "null","sep": /\s{3}/,"generator": getText,"numCols":0, "header": "Documentation"},
  "Dependency Graph": {"tag": "_dependency","sep": /\s{3}/,"numCols":6},
  "Dependent Graph":{"tag": "_dependent","sep": /\s{3}/,"numCols":6},
  "All ICR Entries":{"tag": "icrVals","sep": /\s{4}/,"generator":getTableList, "numCols":8},
  // TODO: Need to find a package to test 'FileMan Files' section
  "FileMan Files":{"tag": "fmFiles","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Non-FileMan Globals":{"tag": "nonfmFiles","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "All Routines":{"tag": "rtns","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  
  //Package Components
  "Component Source":{"tag": "source","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":2},
  "Remote Procedure":{"tag": "Option_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Sort Template":{"tag": "Function_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "List Manager Templates":{"tag": "List_Manager_Templates_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Function":{"tag": "Function_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Input Template":{"tag": "Input_Template_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Protocol":{"tag": "Protocol_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Option":{"tag": "Option_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Print Template":{"tag": "Print_Template_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Key":{"tag": "Key_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Remote Procedure":{"tag": "Remote_Procedure_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Help Frame":{"tag": "Help_Frame_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Form":{"tag": "Form_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "Sort Template":{"tag": "Sort_Template_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},
  "HL7 APPLICATION PARAMETER":{"tag": "HL7_APPLICATION_PARAMETER_data","sep": /\s{4}/,"generator":getTableList,"numCols":8},

  // Subfield
  "SubfieldInfo":{"tag": "information","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":4, "header": "Information"},
  "Details":{"tag": "fmFields","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":5,"stretchColumn":4},

  // Global
  "GlobalInfo":{"tag": "information","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":3, "header": "Information"},
  "Desc":{"tag": "description","sep": /\s{4}/,"generator": getText,"header":"Description"},
  "Directly Accessed By Routines":{"tag": "directCall","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":3, "columnSizes":[0,0,.60]},
  "Accessed By FileMan Db Calls":{"tag": "gblRtnDep","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":3},
  //
  "Pointed To By FileMan Files":{"tag": "gblPointedTo","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":3},
  "Pointer To FileMan Files":{"tag": "gblPointerTo","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":3},
  "Fields":{"tag": "fmFields","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":5,"stretchColumn":4},
  // TODO: "Fields Referenced" need to be split into different lines
  "ICR Entries":{"tag": "icrVals","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":4,"stretchColumn":3},

  // Routine
  "RoutineInfo":{"tag": "information","sep": /\s{4}/,"generator": getText, "header": "Information"},
  "Source":{"tag": "sourcefile","sep": /\s{4}/,"generator": getText,"numCols":0, "header": "Source Code"},
  "Call Graph":{"tag": "callG","sep": /\s{2}/,"numCols":3,"stretchColumn":2},
  "Caller Graph":{"tag": "callerG","sep": /\s{2}/,"numCols":3,"stretchColumn":2},
  "Entry Points":{"tag": "entrypoint","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":3,"stretchColumn":1},
  "Used in HL7 Interface":{"tag": "hl7","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":2},
  "External References":{"tag": "external","sep": /\s{1}/,"generator":getTableListWithHeader,"numCols":2,"stretchColumn":1},
  "Global Variables Directly Accessed":{"tag": "directAccess","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":2,"stretchColumn":1},
  "Label References":{"tag": "label","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":2,"stretchColumn":1},
  "Naked Globals":{"tag": "naked","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":2,"stretchColumn":1},
  // TODO: Legend for Local Variables
  "Local Variables":{"tag": "local","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":2,"stretchColumn":1},
  "Interaction Calls":{"tag": "interactioncalls","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":2,"stretchColumn":1},
  "Marked Items":{"tag": "marked","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":2,"stretchColumn":1},
  // TODO: Need an example that uses this section. Not tested
  "FileMan Files Accessed Via FileMan Db Call":{"tag": "dbcall","sep": /\s{4}/,"generator":getTableListWithHeader,"numCols":2},

  // Summary Pages

  "Summary":{"tag": "summary","sep": /\s{4}/,"generator":getText,"numCols":8,"needsSplit":true,"header" : "Summary"},
  "Caller Routines":{"tag": "callerRoutines","sep": /\s{4}/,"generator":getTableList,"numCols":8,"needsSplit":true},
  "Called Routines":{"tag": "calledRoutines","sep": /\s{4}/,"generator":getTableList,"numCols":8,"needsSplit":true},
  "Referred Routines":{"tag": "referredRoutines","sep": /\s{4}/,"generator":getTableList,"numCols":8,"needsSplit":true},
  "Referenced Globals":{"tag": "referredGlobals","sep": /\s{4}/,"generator":getTableList,"numCols":8,"needsSplit":true},
  "Referred FileMan Files":{"tag": "referredFileManFiles","sep": /\s{4}/,"generator":getTableList,"numCols":8,"needsSplit":true},
  "Referenced FileMan Files":{"tag": "referencedFileManFiles","sep": /\s{4}/,"generator":getTableList,"numCols":8,"needsSplit":true},
  "FileMan Db Call Routines":{"tag": "dbCallRoutines","sep": /\s{4}/,"generator":getTableList,"numCols":8,"needsSplit":true},
  "FileMan Db Call Accessed FileMan Files":{"tag": "dbCallFileManFiles","sep": /\s{4}/,"generator":getTableList,"numCols":8,"needsSplit":true},
  //multiple pages
  "Legend Graph":{"tag": "colorLegend","sep": /\s{2}/,"numCols":2,"stretchColumn":2}
  }
function startWritePDF(event){
  $("#pdfSelection").dialog({
      modal: true,
      buttons: {
        Generate:function() {
            titleList=[]
            $(".headerVal:checked").toArray().forEach(function(title) {
              titleList.push($(title).attr("val"))
            })
            writePDF(event);
            $( this ).dialog( "close" )
        }
      }
  })
}
function writePDF(event) {
  // Capture images first
  toDataUrl($("#img_called").attr("src"), function(callGraph, callGraphWidth, callGraphHeight) {
    toDataUrl($("#img_caller").attr("src"), function(callerGraph, callerGraphWidth, callerGraphHeight) {
      toDataUrl($("#package_dependencyGraph").attr("src"), function(dependencyVal, dependencyValWidth, dependencyValHeight) {
        toDataUrl($("#package_dependentGraph").attr("src"), function(dependentVal, dependentValWidth, dependentValHeight) {
          toDataUrl($("#colorLegendImg").attr("src"), function (colorLegendImg, colorLegendWidth, colorLegendHeight) {
            var title = $("#pageTitle").html();
            var today = new Date();
            var footerText = "Generated from " + window.location.href;
            footerText +=  " on " + today.getFullYear() + '-' + (today.getMonth()+1) + '-' + today.getDate();

            // And then text and tables
            var docDefinition = {
              pageOrientation: 'landscape',
              // Note: [left, top, right, bottom] or [horizontal, vertical]
              //       or just a number for equal margins
              pageMargins: margin,
              images : {},
              styles: {
                header: {
                  fontSize: 18,
                  bold: true
                },
                subheader: {
                  fontSize: 15,
                  bold: true
                },
                tableheader: {
                  fontSize: 13,
                  bold: true
                },
                quote: {
                  italics: true
                },
                small: {
                  fontSize: 8
                }
              },
              content:[{text:title, style: "header"}, "\n\n"],
              footer: { text: footerText, alignment: "center"},
            };

            titleList.forEach(function(test) {
              if(test.indexOf("_")) {
                arrayVal = test.split("_");
                test = arrayVal[0]
                index = arrayVal[1]
              }
              if (test === "Info" ) {
                // Figure out which Info we are parsing
                if (title.indexOf("Sub-Field") !== -1) { test = "SubfieldInfo"; }
                else if (title.indexOf("Global") !== -1) { test = "GlobalInfo"; }
                else if (title.indexOf("Routine") !== -1) { test = "RoutineInfo"; }
              }

              if (test === "Doc") {
                // pass
              } else if (test.indexOf("Graph") !== -1) {
                // Get the data that contains an image (CallerGraphs and accompanying tables)
                var pdfObj = titleDic[test];

                var header = {text: test, style: "subheader"};
                docDefinition.content.push(header);
                var imageWidth;
                if (test === "Caller Graph ") { imageWidth = callerGraphWidth; }
                else if (test === "Call Graph") { imageWidth = callGraphWidth; }
                else if (test === "Dependency Graph") { imageWidth = dependencyValWidth; }
                else if (test === "Dependent Graph") { imageWidth = dependentValWidth; }
                else if (test === "Legend Graph") { imageWidth = colorLegendWidth; }
                // else { ERROR! }

                if (imageWidth > pageWidth) {
                 docDefinition.content.push({image: pdfObj.tag, width: pageWidth});
                } else {
                 docDefinition.content.push({image: pdfObj.tag});
                }
                docDefinition.content.push("\n\n");

                if (test.indexOf("Call") !== -1) {
                  tableVal = getTableListWithHeader(pdfObj);
                } else {
                  tableVal = getTableList(pdfObj);
                }
                docDefinition.content = docDefinition.content.concat(tableVal);
                docDefinition.content.push("\n\n");
              } else {
                var header = {};
                header.style = "subheader";
                if ("header" in titleDic[test]) {
                  header.text = titleDic[test]["header"];
                } else {
                  header.text = test;
                }
                docDefinition.content.push(header);
                docDefinition.content.push(titleDic[test]["generator"](titleDic[test],index));
                docDefinition.content.push("\n\n");
              }
            });
            docDefinition.images._dependent = dependentVal;
            docDefinition.images._dependency = dependencyVal;
            docDefinition.images.callG = callGraph;
            docDefinition.images.callerG = callerGraph;
            docDefinition.images.colorLegend = colorLegendImg;

            // Create PDF
            pdfMake.createPdf(docDefinition).download(title + ".pdf")
          })
        })
      })
    })
  })
}

function startDownloadPDFBundle(filename) {
  window.open(filename, '_blank');
}
