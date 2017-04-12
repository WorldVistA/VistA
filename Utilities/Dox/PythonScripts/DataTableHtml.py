""" This is a python module to convert VA FileMan Like Data to HTML DataTable
"""

from string import Template
"""
  html header using JQuery Table Sorter Plugin
  http://tablesorter.com/docs/
"""

table_sorter_header="""
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="http://tablesorter.com/__jquery.tablesorter.js"></script>
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
<link rel="stylesheet" type="text/css" href="../../datatable/css/jquery.dataTables.css"/>
<link rel="stylesheet" type="text/css" href="../../datatable/css/buttons.dataTables.css"/>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../../datatable/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="../../datatable/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="../../datatable/js/buttons.colVis.min.js"></script>

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

data_table_list_init_setup = Template("""
<script type="text/javascript" id="js">
  $$(document).ready(function() {
      $$("#${tableName}").DataTable({
        bInfo: true,
        iDisplayLength: 25,
        pagingType: "full_numbers",
        bStateSave: true,
        bAutoWidth: true
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
        bAutoWidth: true,
        columns: [${columnNames}],
        buttons: [
          {
            text: 'Toggle Columns',
            extend: 'colvis',
          },
          {
            text: 'Clear Search',
            action: function ( e, dt, node, conf ) {
              clearFilters();
            }
          }
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
        sAjaxSource: "${ajaxSrc}"
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
        columns: [${columnNames}],
        buttons: [
          {
            text: 'Toggle Columns',
            extend: 'colvis',
          },
          {
            text: 'Clear Search',
            action: function ( e, dt, node, conf ) {
              clearFilters();
            }
          }
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

data_table_record_init_setup = Template("""
<script type="text/javascript" id="js">
  $$(document).ready(function() {
      $$("#${tableName}").dataTable({
        "bPaginate": false,
        "bLengthChange": false,
        "bInfo": false,
        "bStateSave": true,
        "bSort": false,
        "bFilter": false
      });
}); </script>
""")

""" Some Utilitity functions for some TablelizedData
"""
def outputDataListTableHeader(output, tName, columns=None,
                              searchColumnNames=None, hideColumnNames=None):
  output.write("%s\n" % data_table_reference)
  if columns is None:
    initSet = data_table_list_init_setup.substitute(tableName=tName)
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
    initSet = data_table_list_with_columns_init_setup.safe_substitute(tableName=tName,
                                                                      columnNames=",".join(columnNames),
                                                                      searchColumns="||".join(searchColumns),
                                                                      hideColumns=hideColumnsStr)
  output.write("%s\n" % initSet)

  clear_filters = data_table_clear_filters.safe_substitute(tableName=tName)
  output.write("%s\n" % clear_filters)

def outputLargeDataListTableHeader(output, src, tName, columns=None,
                                   searchColumnNames=None, hideColumnNames=None):
  output.write("%s\n" % data_table_reference)
  if columns is None and searchColumnNames is None and hideColumnNames is None:
    initSet = data_table_large_list_init_setup.substitute(ajaxSrc=src,
                                                          tableName=tName)
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
                                                                            tableName=tName,
                                                                            columnNames=",".join(columnNames),
                                                                            searchColumns="||".join(searchColumns),
                                                                            hideColumns="||".join(hideColumns))
  output.write("%s\n" % initSet)

  clear_filters = data_table_clear_filters.safe_substitute(tableName=tName)
  output.write("%s\n" % clear_filters)

def outputDataRecordTableHeader(output, tName):
  output.write("%s\n" % data_table_reference)
  initSet = data_table_record_init_setup.substitute(tableName=tName)
  output.write("%s\n" % initSet)

def outputDataTableHeader(output, name_list, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName)
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

def outputFileEntryTableList(output, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName)
  output.write("<thead>\n")
  output.write("<tr>\n")
  for name in ("Name", "Value"):
    output.write("<th>%s</th>\n" % name)
  output.write("</tr>\n")
  output.write("</thead>\n")

def outputCustomDataTableHeader(output, name_list, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName)
  output.write("<thead>\n")
  for name in name_list:
    output.write("<tr>\n")
    output.write("%s\n" % name)
    output.write("</tr>\n")
  output.write("</thead>\n")

def writeTableListInfo(output, tName):
  output.write("<div id=\"demo\">")
  output.write("<table id=\"%s\" class=\"display\">\n" % tName)
  output.write("<thead>\n")
  output.write("<tr>\n")
  for name in ("Name", "IEN"):
    output.write("<th>%s</th>\n" % name)
  output.write("</tr>\n")
  output.write("</thead>\n")

def safeFileName(name):
  """ convert to base64 encoding """
  import base64
  return base64.urlsafe_b64encode(name)

def safeElementId(name):
  import base64
  """
  it turns out that '=' is not a valid html element id
  remove the padding
  """
  return base64.b64encode(name, "__").replace('=','')
