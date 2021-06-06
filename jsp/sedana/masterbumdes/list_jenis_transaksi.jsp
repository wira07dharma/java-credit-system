<%-- 
    Document   : list_jenis_transaksi
    Created on : Oct 8, 2017, 12:11:44 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksi"%>
<%@ page import = "com.dimata.util.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
  public static final String dataTableTitle[][] = {
    {"Tampilkan _MENU_ data per halaman",
      "Data Tidak Ditemukan",
      "Menampilkan halaman _PAGE_ dari _PAGES_",
      "Belum Ada Data",
      "(Disaring dari _MAX_ data)",
      "Pencarian :",
      "Awal",
      "Akhir",
      "Berikutnya",
      "Sebelumnya"},
    {"Display _MENU_ records per page",
      "Nothing found - sorry",
      "Showing page _PAGE_ of _PAGES_",
      "No records available",
      "(filtered from _MAX_ total records)",
      "Search :",
      "First",
      "Last",
      "Next",
      "Previous"}
  };
%>
<%//
  int iCommand = FRMQueryString.requestCommand(request);
  int showHistory = FRMQueryString.requestInt(request, "show_history");
  long oid = FRMQueryString.requestLong(request, "oid");

  String errorMessage = "";
  JenisTransaksi jenisTransaksi = new JenisTransaksi();
  if (iCommand == Command.EDIT && oid != 0) {
    try {
      jenisTransaksi = PstJenisTransaksi.fetchExc(oid);
    } catch (Exception e) {
      System.out.println(e);
    }
  } else if (iCommand == Command.EDIT && oid == 0) {
    errorMessage = "Terjadi kesalahan !";
  }
%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/font-awesome-4.7.0/css/font-awesome.min.css">        
    <!-- Datetime Picker -->
    <link href="../../style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
    <!-- Select2 -->
    <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. Choose a skin from the css/skins
         folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">
    <link href="../../style/datatables/dataTables.bootstrap.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../../style/bootstrap-notify/bootstrap-notify.css"/>
    <!-- jQuery 2.2.3 -->
    <script src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="../../style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
    <!-- FastClick -->
    <script src="../../style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>

    <!-- AdminLTE for demo purposes -->
    <script src="../../style/AdminLTE-2.3.11/dist/js/demo.js"></script>
    <!-- AdminLTE App -->
    <script type="text/javascript" src="../../style/bootstrap-notify/bootstrap-notify.js"></script>
    <script src="../../style/AdminLTE-2.3.11/dist/js/app.min.js"></script>    
    <script src="../../style/dist/js/dimata-app.js" type="text/javascript"></script>
    <!-- Select2 -->
    <script src="../../style/AdminLTE-2.3.11/plugins/select2/select2.full.min.js"></script>
    <!-- Datetime Picker -->
    <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script src="../../style/datatables/jquery.dataTables.js" type="text/javascript"></script>
    <script src="../../style/datatables/dataTables.bootstrap.js" type="text/javascript"></script>
    <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>
    <style>
      th {text-align: center; font-weight: normal; vertical-align: middle !important}
      th {background-color: #00a65a; color: white; padding-right: 8px !important}
      th:after {display: none !important;}
      table {font-size: 14px}
    </style>
    <script language="javascript">
      $(document).ready(function() {

        // DATABLE SETTING
        function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
          var oid = "0";
          var datafilter = "";
          var privUpdate = "";
          $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
          $("#" + elementId).dataTable({"bDestroy": true,
            "iDisplayLength": 10,
            "bProcessing": true,
            "oLanguage": {
              "sProcessing": "<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div>",
              "sLengthMenu": "<%=dataTableTitle[SESS_LANGUAGE][0]%>",
              "sZeroRecords": "<%=dataTableTitle[SESS_LANGUAGE][1]%>",
              "sInfo": "<%=dataTableTitle[SESS_LANGUAGE][2]%>",
              "sInfoEmpty": "<%=dataTableTitle[SESS_LANGUAGE][3]%>",
              "sInfoFiltered": "<%=dataTableTitle[SESS_LANGUAGE][4]%>",
              "sSearch": "<%=dataTableTitle[SESS_LANGUAGE][5]%>",
              "oPaginate": {
                "sFirst ": "<%=dataTableTitle[SESS_LANGUAGE][6]%>",
                "sLast ": "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                "sNext ": "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                "sPrevious ": "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
              }
            },
            "bServerSide": true,
            "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>" + "&SEND_OID_RESERVATION=" + oid,
            aoColumnDefs: [
              {
                bSortable: false,
                aTargets: [-1]
              }
            ],
            "initComplete": function(settings, json) {
              if (callBackDataTables !== null) {
                callBackDataTables();
              }
            },
            "fnDrawCallback": function(oSettings) {
              if (callBackDataTables !== null) {
                callBackDataTables();
              }
              $('#jenisTransaksiTableElement').find(".money").each(function() {
                jMoney(this);
              });
            },
            "fnPageChange": function(oSettings) {

            }
          });
          $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
          $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
          $("#" + elementId).css("width", "100%");
        }

        function runDataTable() {
          dataTablesOptions("#jenisTransaksiTableElement", "tableJenisTransaksiTableElement", "AjaxKredit", "listJenisTransaksi", null);
        }

        runDataTable();

        $('#btn_add').click(function() {
          $(this).attr({"disabled": "true"}).html("Tunggu...");
          window.location = "../masterbumdes/jenis_transaksi.jsp?command=<%=Command.ADD%>&oid=0";
        });

        $('body').on("click", ".btn_edit", function() {
          $(this).attr({"disabled": "true"}).html("....");
          var oid = $(this).data('oid');
          window.location = "../masterbumdes/jenis_transaksi.jsp?command=<%=Command.EDIT%>&oid=" + oid;
        });

      });
    </script>
  </head>
  <body style="background-color: #eaf3df;">
    <section class="content-header">
      <h1>
        Jenis Transaksi
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
        <li>Master Bumdesa</li>
        <li class="active">Master</li>
      </ol>
    </section>

    <section class="content">
      <div class="box box-success">

        <div class="box-header with-border">
          <% if (!errorMessage.equals("")) {%>
          <p style="color: red"><b><%=errorMessage%></b></p>
              <% }%>
          <h3 class="box-title">Daftar Jenis Transaksi</h3>
        </div>

        <div class="box-body">
          <div id="jenisTransaksiTableElement">
            <table class="table table-bordered table-responsive table-striped">
              <thead>
                <tr>
                  <th>No.</th>
                  <th>Jenis Transaksi</th>
                  <th>Tujuan Prosedur</th>
                  <th>Tipe Arus Kas</th>
                  <th>Tipe Transaksi</th>
                  <th>Tipe Prosedur</th>
                  <th>Tipe Dokumen</th>
                  <th>Tipe Input</th>
                  <th>Prosentase Perhitungan</th>
                  <th>Standar Transaksi</th>                                    
                  <th>Mapping</th>
                  <th>Status</th>
                  <th class="text-center">Aksi</th>
                </tr>
              </thead>
            </table>
          </div>
        </div>

        <div class="box-footer">
          <button type="button" id="btn_add" class="btn btn-sm btn-primary"><i class="fa fa-plus"></i> &nbsp; Tambah Jenis Transaksi</button>
        </div>

      </div>

        <% if (showHistory == 1) { %> 
        <div class="box box-danger">
          <div class="box-header">
            <h3 class="box-title">Riwayat Perubahan</h3>
          </div><!-- /.box-header -->
          <div class="box-body">
            <%
              JSONObject obj = new JSONObject();
              JSONArray arr = new JSONArray();
              arr.put(SessHistory.document[SessHistory.DOC_MASTER_JENIS_TRANSAKSI]);
              obj.put("doc", arr);
              obj.put("time", "");
              request.setAttribute("obj", obj);
            %>
            <%@ include file = "/history_log/history_table.jsp" %>
          </div><!-- /.box-body -->
        </div>
        <% } %>

        <a href="list_jenis_transaksi.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>

    </section>
  </body>
</html>
