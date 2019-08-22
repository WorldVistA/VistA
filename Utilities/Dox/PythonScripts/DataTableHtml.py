#---------------------------------------------------------------------------
# Copyright 2018 The Open Source Electronic Health Record Alliance
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

""" This is a python module to convert VA FileMan Like Data to HTML DataTable
"""

from builtins import str
from string import Template
"""
  html header using JQuery Table Sorter Plugin
  http://tablesorter.com/docs/
"""

table_sorter_header="""
<script type="text/javascript" src="https://code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="https://tablesorter.com/__jquery.tablesorter.js"></script>
<script type="text/javascript" id="js">
  $(document).ready(function() {
  // call the tablesorter plugin
  $("#rpctable").tablesorter({
    // sort on the first column and third column, order asc
    sortList: [[0,0],[2,0]]
  });
}); </script>
"""

"""
  html header using JQuery DataTable Plugin
  https://datatables.net/
"""
data_table_reference = """
<link rel="stylesheet" type="text/css" href="../../css/vivian.css"/>
<link rel="stylesheet" type="text/css" href="../../datatable/css/jquery.dataTables.css"/>
<link rel="stylesheet" type="text/css" href="../../datatable/css/buttons.dataTables.css"/>
<link rel="stylesheet" type="text/css" href="../../datatable/css/dataTables.searchHighlight.css"/>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../../datatable/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="../../datatable/js/buttons.colVis.min.js"></script>
<script type="text/javascript" src="../../datatable/js/jquery.highlight.js"></script>
<script type="text/javascript" src="../../datatable/js/dataTables.searchHighlight.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.1/js/buttons.html5.min.js"></script>

<!-- Google Analytics -->
<script>
 (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
 (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
 m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
 })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

 ga('create', 'UA-43872538-6', 'osehra.org');
 ga('send', 'pageview');
</script>
"""

downloadButtons = """
          {
              extend: 'csv',
              title: '${downloadTitle}',
              orientation: 'landscape',
              pageSize: 'LEGAL',
              exportOptions: {
                  columns: ':visible',
                  format: {
                     body: function(html, indx, node) {
                        if (Array.isArray(html)) {
                          html = html.join(" ")
                        }
                        html = html.replace(/<br>/g, " ");
                        var entryList = html.split("</li>");
                        return $$("<div/>").html(entryList.join("|")).text();
                     }
                  }
              }
          },
          {
              extend: 'pdf',
              title: '${downloadTitle}',
              orientation: 'landscape',
              pageSize: 'LEGAL',
              exportOptions: {
                  columns: ':visible',
                  format: {
                     body: function(html, indx, node) {
                        if (Array.isArray(html)) {
                          html = html.join(" ")
                        }
                        var entryList = html.split("</li>");
                        var parsedList = []
                        entryList.forEach(function(d) {
                            if (d.indexOf("<li>") != -1) {
                              parsedList.push("* " + d)
                            } else {
                              d = d.replace(/<br>/g, " ");
                              parsedList.push(d)
                            }
                        });
                        return $$("<div/>").html(parsedList.join("  ")).text();
                     }
                  }
              },
              customize: function (doc) {
                  // Taken from https://stackoverflow.com/questions/35642802/datatables-export-pdf-with-100-width
                  var colCount = new Array();
                  var length = $$('#${tableName} tbody tr:first-child td').length;
                  console.log('length / number of td in report one record = '+length);
                  $$('#${tableName}').find('tbody tr:first-child td').each(function(){
                      colCount.push(parseFloat(100 / length)+'%');
                  });
                  doc.content[1].table.widths = colCount;
              }
          }
"""

data_table_list_init_setup = Template("""
<script type="text/javascript" id="js">
  $$(document).ready(function() {
      $$("#${tableName}").DataTable({
        bInfo: true,
        iDisplayLength: 25,
        pagingType: "full_numbers",
        bStateSave: true,
        bAutoWidth: false,
        buttons: [
""" + downloadButtons + """
        ]
      });
}); </script>
""")

data_table_list_with_columns_init_setup = Template("""
<script type="text/javascript" id="js">
  $(document).ready(function() {
    var table = $("#${tableName}").DataTable({
        bInfo: true,
        dom: '<Bfr<t>ilp>',
        iDisplayLength: 25,
        pagingType: "full_numbers",
        bStateSave: true,
        bAutoWidth: false,
        searchHighlight: true,
        columns: [${columnNames}],
        buttons: [
          {
            text: 'Toggle Columns',
            extend: 'colvis',
          },
          {
            text: 'Reset Columns',
            extend: 'colvisRestore',
          },
          {
            text: 'Clear Search',
            action: function ( e, dt, node, conf ) {
              clearFilters();
            }
          },""" + downloadButtons + """
        ]
    });

    var columns = table.settings().init().columns;
    table.columns().every(function(index) {
      var column = this;
      var name = columns[index].name;
      if (${hideColumns}) {
        column.visible(false);
      }
      if (${searchColumns}) {
        var select = $('<input type="text" name="' + name + '" placeholder="Search ' + name + '" />')
          .appendTo( $(column.footer()).empty() )
          .on('keyup change', function() {
            if (column.search() !== this.value) {
              column
                .search(this.value)
                .draw();
            }
          });
      } else {
        var select = $('<select name="' + name + '"><option value=""></option></select>')
          .appendTo($(column.footer()).empty())
          .on('change', function() {
            var val = $.fn.dataTable.util.escapeRegex($(this).val());
            column
              .search(val ? '^'+val+'$' : '', true, false)
              .draw();
          });

        column.data().unique().sort().each(function(d, j) {
          if ($.trim( d ) != '') {
            select.append( '<option value="'+d+'">'+d+'</option>' )
          }
        });
      }
    });


    table
     .search('')
     .columns().search('')
     .draw();

    $('.dataTables_filter input').attr('title', 'Search includes ALL columns. Use `Toggle Columns` to display hidden columns.');
}); </script>
""")


data_table_large_list_init_setup = Template("""
<script type="text/javascript" id="js">
  $$(document).ready(function() {
      $$("#${tableName}").DataTable({
        bProcessing: true,
        bStateSave: true,
        iDisplayLength: 10,
        pagingType: "full_numbers",
        bDeferRender: true,
        sAjaxSource: "${ajaxSrc}",
        buttons: [
""" + downloadButtons + """
        ]
      });
}); </script>
""")

data_table_large_list_with_columns_init_setup = Template("""
<script type="text/javascript" id="js">
  $$(document).ready(function() {
      var table = $("#${tableName}").DataTable({
        bProcessing: true,
        bStateSave: true,
        dom: '<Bfr<t>ilp>',
        iDisplayLength: 10,
        pagingType: "full_numbers",
        bDeferRender: true,
        sAjaxSource: "${ajaxSrc}",
        searchHighlight: true,
        columns: [${columnNames}],
        buttons: [
          {
            text: 'Toggle Columns',
            extend: 'colvis',
          },
          {
            text: 'Reset Columns',
            extend: 'colvisRestore',
          },
          {
            text: 'Clear Search',
            action: function ( e, dt, node, conf ) {
              clearFilters();
            }
          },
""" + downloadButtons + """
        ],
        fnInitComplete: function(oSettings, json) {
          var table = $("#${tableName}").DataTable();
          var columns = table.settings().init().columns;
          table.columns().every( function (index) {
            var column = this;
            var name = columns[index].name;
            if (${hideColumns}) {
              column.visible(false);
            }
            if (${searchColumns}) {
              var select = $('<input type="text" name="' + name + '" placeholder="Search '+name+'" />')
                .appendTo( $(column.footer()).empty() )
                .on('keyup change', function () {
                  if (column.search() !== this.value) {
                    column
                      .search( this.value )
                      .draw();
                  }
              });
            } else {
              var select = $('<select name="' + name + '"><option value=""></option></select>')
                .appendTo($(column.footer()).empty())
                .on('change', function() {
                  var val = $.fn.dataTable.util.escapeRegex($(this).val());
                  column
                    .search( val ? '^'+val+'$' : '', true, false )
                    .draw();
                });
              column.data().unique().sort().each(function(d, j) {
                if ($.trim( d ) != '') {
                  select.append('<option value="'+d+'">'+d+'</option>')
                }
              });
            }
          });
        }
      });

    table
      .search( '' )
      .columns().search( '' )
      .draw();

    $('.dataTables_filter input').attr('title', 'Search includes ALL columns. Use `Toggle Columns` to display hidden columns.');
}); </script>
""")

data_table_clear_filters = Template("""
<script type="text/javascript" id="js">
  function clearFilters() {
    var table = $('#${tableName}').DataTable();
    table
      .search( '' )
      .columns().search( '' )
      .draw();
    $("select").prop('selectedIndex', 0);
    $('#${tableName} tfoot input').val('');
  }
</script>
""")

def data_table_record_init_setup(tableName):
  return """
<script type="text/javascript" id="js">
  $(document).ready(function() {
      $("#%s").dataTable({
        "bPaginate": false,
        "bLengthChange": false,
        "bInfo": false,
        "bStateSave": true,
        "bSort": false,
        "bFilter": false
      });
}); </script>
""" % tableName

""" Some Utilitity functions for some TablelizedData
"""
def outputDataListTableHeader(output, tName, columns=None,
                              searchColumnNames=None, hideColumnNames=None):
  output.write("%s\n" % data_table_reference)
  if columns is None:
    initSet = data_table_list_init_setup.substitute(tableName=tName, downloadTitle=tName)
  else:
    columnNames = []
    for col in columns:
      columnNames.append("{ name : '" + col + "'}")
    searchColumns = []
    if searchColumnNames:
      for name in searchColumnNames:
        searchColumns.append("name == '" + name +"'")
    hideColumns = []
    if hideColumnNames:
      for name in hideColumnNames:
        hideColumns.append("name == '" + name +"'")
      hideColumnsStr = "||".join(hideColumns)
    else:
      hideColumnsStr = "false"
    initSet = data_table_list_with_columns_init_setup.safe_substitute(tableName=tName.replace(" ", ""),
                                                                      columnNames=",".join(columnNames),
                                                                      searchColumns="||".join(searchColumns),
                                                                      hideColumns=hideColumnsStr
                                                                      ,downloadTitle=tName)
  output.write("%s\n" % initSet)
  clear_filters = data_table_clear_filters.safe_substitute(tableName=tName.replace(" ", ""))
  output.write("%s\n" % clear_filters)

def outputLargeDataListTableHeader(output, src, tName, columns=None,
                                   searchColumnNames=None, hideColumnNames=None):
  output.write("%s\n" % data_table_reference)
  if columns is None and searchColumnNames is None and hideColumnNames is None:
    initSet = data_table_large_list_init_setup.substitute(ajaxSrc=src,
                                                          tableName=tName,
                                                          downloadTitle=tName)
  else:
    columnNames = []
    for col in columns:
      columnNames.append("{ name : '" + col + "'}")
    searchColumns = []
    for name in searchColumnNames:
      searchColumns.append("name == '" + name +"'")
    hideColumns = []
    for name in hideColumnNames:
      hideColumns.append("name == '" + name +"'")
    initSet = data_table_large_list_with_columns_init_setup.safe_substitute(ajaxSrc=src,
                                                                            tableName=tName.replace(" ", ""),
                                                                            columnNames=",".join(columnNames),
                                                                            searchColumns="||".join(searchColumns),
                                                                            hideColumns="||".join(hideColumns)
                                                                            ,downloadTitle=tName)
  output.write("%s\n" % initSet)

  clear_filters = data_table_clear_filters.safe_substitute(tableName=tName.replace(" ", ""))
  output.write("%s\n" % clear_filters)

def outputDataRecordTableHeader(output, tName):
  output.write("%s\n" % data_table_reference)
  initSet = data_table_record_init_setup(tName)
  output.write("%s\n" % initSet)

def outputDataTableHeader(output, name_list, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName.replace(" ", ""))
  output.write("<thead>\n")
  output.write("<tr>\n")
  for name in name_list:
    output.write("<th>%s</th>\n" % name)
  output.write("</tr>\n")
  output.write("</thead>\n")

def outputDataTableFooter(output, name_list, tName):
  output.write("<tfoot>\n")
  output.write("<tr>\n")
  for name in name_list:
    output.write("<th>%s</th>\n" % name)
  output.write("</tr>\n")
  output.write("</tfoot>\n")

# TODO: __writePackageComponentSourceSection__() in WebPageGenerator.py
# Assumes that these lines will be written with no indentation...
def outputFileEntryTableList(output, tName):
  output.write("""
<div id="demo">
<table id="%s" class="display">
<thead>
<tr>
<th>Name</th>
<th>Value</th>
</tr>
</thead>
""" % tName.replace(" ", ""))

# This function expects a list of header names
def outputCustomDataTableHeader(output, name_list, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName.replace(" ", ""))
  output.write("<thead>\n")
  for name in name_list:
    output.write("<th>\n")
    output.write("%s\n" % name)
    output.write("</th>\n")
  output.write("</thead>\n")

# This function expects a list of header rows
def outputCustomDataTableHeaderRows(output, rows, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName.replace(" ", ""))
  output.write("<thead>\n")
  for row in rows:
    output.write("<tr>\n")
    output.write("%s\n" % row)
    output.write("</tr>\n")
  output.write("</thead>\n")

def writeTableListInfo(output, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName.replace(" ", ""))
  output.write("<thead>\n")
  output.write("<tr>\n")
  for name in ("Name", "IEN"):
    output.write("<th>%s</th>\n" % name)
  output.write("</tr>\n")
  output.write("</thead>\n")

def safeFileName(name):
  """ convert to base64 encoding """
  import base64
  # b64Encode requires a bytes object but would prefer strings
  return str(base64.urlsafe_b64encode(name.encode('utf-8')))

def safeElementId(name):
  import base64
  """
  it turns out that '=' is not a valid html element id
  remove the padding
  """
  # b64Encode requires a bytes object but would prefer strings
  name = name.encode('utf-8')
  extraChr = str('__').encode('utf-8')
  returnStr = str(base64.b64encode(name, extraChr))
  return returnStr.replace('=','').replace('.','')
