<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisTabungan"%>
<%@page language="java" %>
<%@page import = "java.util.*" %>
<%@page import = "com.dimata.util.*" %>
<%@page import = "com.dimata.gui.jsp.*" %>
<%@page import = "com.dimata.qdep.form.*" %>
<%@page import="com.dimata.sedana.form.reportsearch.FrmRscReport"%>
<%@include file = "../../main/javainit.jsp" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>SEDANA</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="StyleSheet" href="../../style/font-awesome/4.6.1/css/font-awesome.css" type="text/css" >
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Datetime Picker -->
    <link href="../../style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
    <!-- Select2 -->
    <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. Choose a skin from the css/skins
         folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body style="background-color: #eaf3df;">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Report Tabungan Jaminan untuk Peminjam (Debitur)
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
        <li>Laporan</li>
        <li class="active">Tabungan</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
      <div class="row">
        <div class="col-xs-12">
          <!-- Horizontal Form -->
          <div class="box box-success">
            <div class="box-header with-border">
              <h3 class="box-title">Form Pencarian</h3>
            </div>
            <!-- /.box-header -->
            <!-- form start -->
            <form class="form-horizontal" action="<%=approot%>/report-tabungan.xls" method="post">
              <input type="hidden" class="hidden" name="reportType" value="<%=FrmRscReport.REPORT_TABUNGAN%>" />
              <div class="box-body">
                <div class="form-group">
                  <label class="col-sm-2 control-label">Tanggal</label>
                  <div class="col-sm-5">
                    <input type="text" name="<%=FrmRscReport.fieldNames[FrmRscReport.FRM_START_DATE]%>" required class="form-control datetime-picker" data-date-format="yyyy-mm-dd" placeholder="<%=FrmRscReport.shortFieldNames[SESS_LANGUAGE][0]%>"> <!-- hh:ii -->
                  </div>
                  <div class="col-sm-5">
                    <input type="text" name="<%=FrmRscReport.fieldNames[FrmRscReport.FRM_END_DATE]%>" required class="form-control datetime-picker" data-date-format="yyyy-mm-dd" placeholder="<%=FrmRscReport.shortFieldNames[SESS_LANGUAGE][1]%>">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-sm-2 control-label"><%=FrmRscReport.shortFieldNames[SESS_LANGUAGE][7]%></label>
                  <div class="col-sm-10">
                    <% Vector<JenisSimpanan> jts = PstJenisSimpanan.list(0, 0, "", PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN]);%>
                    <select required class="form-control select2" name="<%=FrmRscReport.fieldNames[FrmRscReport.FRM_TABUNGAN]%>" multiple data-placeholder="Select a State" style="width: 100%;">
                      <% for (JenisSimpanan jt : jts) {%>
                      <option value="<%=jt.getOID()%>"><%=jt.getNamaSimpanan() %></option>
                      <% }%>
                    </select>
                  </div>
                </div>
              </div>
              <!-- /.box-body -->
              <div class="box-footer">
                <button type="submit" class="btn btn-success pull-right">Cari</button>
              </div>
              <!-- /.box-footer -->
            </form>
          </div>
        </div>
        <!--/.col (right) -->
      </div>
      <!-- /.row -->
    </section>

    <!-- jQuery 2.2.3 -->
    <script src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="../../style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
    <!-- FastClick -->
    <script src="../../style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>
    <!-- AdminLTE App -->
    <script src="../../style/AdminLTE-2.3.11/dist/js/app.min.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="../../style/AdminLTE-2.3.11/dist/js/demo.js"></script>
    <!-- Select2 -->
    <script src="../../style/AdminLTE-2.3.11/plugins/select2/select2.full.min.js"></script>
    <!-- Datetime Picker -->
    <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <!-- Declaration -->
    <script>
      jQuery(function() {
        $('.select2').select2();
        $('.datetime-picker').datetimepicker({
          weekStart: 1,
          todayBtn: 1,
          autoclose: 1,
          todayHighlight: 1,
          startView: 2,
          forceParse: 0,
          minView: 2, // No time
          // showMeridian: 0
        });
      });
    </script>
    <%@ include file = "/footerkoperasi.jsp" %>
  </body>
</html>
