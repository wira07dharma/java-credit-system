<%-- 
    Document   : style_kredit
    Created on : Nov 8, 2017, 9:33:59 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.util.Formater"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- css -->
<!-- Bootstrap 3.3.6 -->
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

<style>
    th {
        background-color: #00a65a;
        color: white;
        text-align: center;
        vertical-align: middle !important;
        font-weight: normal;
        font-size: 14px;
        padding-right: 8px !important
    } 
    th:after {display: none !important;}

	.swal2-timer-progress-bar {
		background-color: #00A65A !important;
	}

    .modal-header, .modal-footer {padding-bottom: 10px; padding-top: 10px !important}
    .aksi {width: 1% !important}

    print-area { visibility: hidden; display: none; }
    print-area.preview { visibility: visible; display: block; }
    @media print
    {
        body .main-page * { visibility: hidden; display: none; } 
        body print-area * { visibility: visible; }
        body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
    }
</style>
<!-- js -->
<!-- jQuery 2.2.3 -->
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
<!-- Mask Money -->
<script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>
<!--Sweet Alert 2-->
<script src="<%=approot%>/style/SweetAlert2/sweetalert2.all.min.js" type="text/javascript"></script>
<!-- Boostrap Toogle -->
<script src="<%=approot%>/style/bootstrap-toggle-master/js/bootstrap2-toggle.min.js" type="text/javascript"></script>

