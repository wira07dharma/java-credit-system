<%-- 
    Document   : upload_payment_proccess
    Created on : Apr 30, 2020, 11:13:41 AM
    Author     : gndiw
--%>

<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.dimata.sedana.session.SessUploadPayment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String approot = request.getContextPath();
    int type = 0;
    JspWriter output = pageContext.getOut();
    SessUploadPayment importDetail = new SessUploadPayment();
    if (!importDetail.isRunning() && importDetail.getTable().equals("")) {
        importDetail.startUpload(config, request, response, output, type);
    }

    double percentage = 0;
    if (importDetail.getTotalData() != 0 && importDetail.getCurrentProgress() != 0) {
        percentage = importDetail.getCurrentProgress() / importDetail.getTotalData() * 100;
        BigDecimal bd = new BigDecimal(percentage);
        bd = bd.setScale(2, RoundingMode.HALF_UP);
        percentage = bd.doubleValue();
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="<%=approot%>/style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
<!-- Font Awesome -->
    <link rel="stylesheet" href="<%=approot%>/style/AdminLTE-2.3.11/plugins/font-awesome-4.7.0/css/font-awesome.min.css">        
    <!-- Datetime Picker -->
    <link rel="stylesheet" href="<%=approot%>/style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="<%=approot%>/style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
    <!--iCheck-->
    <link rel="stylesheet" href="<%=approot%>/style/AdminLTE-2.3.11/plugins/iCheck/all.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="<%=approot%>/style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. Choose a skin from the css/skins folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="<%=approot%>/style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">
    <!-- Data Table -->
    <link rel="stylesheet" href="<%=approot%>/style/datatables/dataTables.bootstrap.css" type="text/css" />
    <!-- Notify -->
    <link rel="stylesheet" href="<%=approot%>/style/bootstrap-notify/bootstrap-notify.css" type="text/css"/>
    <!--Sweet Alert 2-->
    <link rel="stylesheet" href="<%=approot%>/style/SweetAlert2/sweetalert2.min.css" type="text/css"/>
    <!-- Boostrap Toogle -->
    <link rel="stylesheet" href="<%=approot%>/style/bootstrap-toggle-master/css/bootstrap2-toggle.min.css" type="text/css"/>
    <script src="<%=approot%>/style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="<%=approot%>/style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
<!-- FastClick -->
<script src="<%=approot%>/style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="<%=approot%>/style/AdminLTE-2.3.11/dist/js/demo.js"></script>
<!-- AdminLTE App -->
<script src="<%=approot%>/style/bootstrap-notify/bootstrap-notify.js" type="text/javascript"></script>
<script src="<%=approot%>/style/AdminLTE-2.3.11/dist/js/app.min.js"></script>
<!-- Dimata -->
<script src="<%=approot%>/style/dist/js/dimata-app.js" type="text/javascript"></script>
<!-- Select2 -->
<script src="<%=approot%>/style/AdminLTE-2.3.11/plugins/select2/select2.full.min.js"></script>
<!--iCheck-->
<script src="<%=approot%>/style/AdminLTE-2.3.11/plugins/iCheck/icheck.min.js"></script>
<!-- Datetime Picker -->
<script src="<%=approot%>/style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<!-- Data Table -->
<script src="<%=approot%>/style/datatables/jquery.dataTables.js" type="text/javascript"></script>
<script src="<%=approot%>/style/datatables/dataTables.bootstrap.js" type="text/javascript"></script>
<!--Sweet Alert 2-->
<script src="<%=approot%>/style/SweetAlert2/sweetalert2.all.min.js" type="text/javascript"></script>
<!-- Boostrap Toogle -->
<script src="<%=approot%>/style/bootstrap-toggle-master/js/bootstrap2-toggle.min.js" type="text/javascript"></script>
    </head>
    <body>
        <div class="col-md-12">
            <center><h2>Process Import Excel</h2></center>
            <div class="progress">
                <center>
                    <div class="progress-bar" role="progressbar" aria-valuenow="<%=percentage%>" aria-valuemin="0" aria-valuemax="100" style="width:<%=(percentage < 3 ? 3 : percentage)%>%">
                        <%=percentage%>%
                    </div>
                </center>
            </div>

            <% if (!importDetail.getTable().equals("")) {%>
            <center><h4>Import Result</h4></center>
            <%=importDetail.getTable()%>
            <br>
            <% } else { %>
            <div class="text-center">Tunggu...</div>
            <% } %>

        </div>
    </body>
    <script>
        jQuery(function () {
        <% if (importDetail.getTable().equals("")) {  %>
            setTimeout(function () {
                window.location.href = window.location.href;
            }, 5 * 1000);
        <% } %>
        });
        

        <%
            if (!importDetail.isRunning()) {
                SessUploadPayment.countTotalData = 0;
                SessUploadPayment.currentProgress = 0;
                SessUploadPayment.table = "";
                SessUploadPayment.running = false;
            }
        %>
    </script>
</html>
