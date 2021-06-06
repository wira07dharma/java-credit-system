<%-- 
    Document   : list_anggota_kelompok
    Created on : Aug 29, 2017, 9:04:36 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.anggota.AnggotaBadanUsaha"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstVocation"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Vocation"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<!DOCTYPE html>
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
        <!-- AdminLTE Skins. Choose a skin from the css/skins folder instead of downloading all of them to reduce the load. -->
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
        <style>
            .table {font-size: 14px}
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            th:after {display: none !important;}
            .btn_detail:hover {cursor: pointer}
            
            print-area { visibility: hidden; display: none; }
            print-area.preview { visibility: visible; display: block; }
            @media print
            {
                body .main-page * { visibility: hidden; display: none; } 
                body print-area * { visibility: visible; }
                body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
            }
        </style>
        <script language="javascript">
            $(document).ready(function () {

                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
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
                                "sLast ":  "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                "sNext ":  "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                "sPrevious ":   "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                            }
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>",
                        aoColumnDefs: [
                            {
                                bSortable: false,
                                aTargets: [0, -1]
                            }
                        ],
                        "initComplete": function (settings, json) {
                            if (callBackDataTables !== null) {
                                callBackDataTables();
                            }
                        },
                        "fnDrawCallback": function (oSettings) {
                            if (callBackDataTables !== null) {
                                callBackDataTables();
                            }
                        },
                        "fnPageChange": function (oSettings) {

                        }
                    });
                    $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                    $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                    $("#" + elementId).css("width", "100%");
                }

                function runDataTable() {
                    dataTablesOptions("#kelompokTableElement", "tableKelompokTableElement", "AjaxAnggota", "listKelompok", null);
                }

                runDataTable();

                $('body').on("click", ".btn_detail", function () {
                    $(this).attr({"disabled": "true"});
                    var oid = $(this).data('oid');
                    var command = "<%=Command.EDIT%>";
                    window.location = "../anggota/anggota_kelompok_badan_usaha.jsp?kelompok_id=" + oid + "&command=" + command;
                });

                $('#btn_add').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    var command = "<%=Command.ADD%>";
                    window.location = "../anggota/anggota_kelompok_badan_usaha.jsp?command=" + command;
                });

                $('#btn_print').click(function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.print();
                    $(this).removeAttr('disabled').html(buttonHtml);
                });

            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    Kelompok / Badan Usaha
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Master Bumdesa</li>
                    <li class="active"><%=namaNasabah%></li>
                </ol>
            </section>

            <section class="content">
                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Daftar <%=namaNasabah%></h3>
                    </div>

                    <div class="box-body">
                        <div id="kelompokTableElement" class="">
                            <table class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th style="width: 1%">No.</th>                                    
                                        <th>Nomor Badan Usaha</th>
                                        <th>Nama Badan Usaha</th>
                                        <th>Nomor Telepon</th>
                                        <th>Email</th>
                                        <th>Alamat</th>
                                        <th style="width: 1%">Aksi</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>

                    <div class="box-footer" style="border-color: lightgray">
                        <button type="button" class="btn btn-sm btn-primary" id="btn_add"><i class="fa fa-plus"></i> &nbsp; Tambah <%=namaNasabah%></button>
                        <button type="button" id="btn_print" class="btn btn-primary btn-sm pull-right"><i class="fa fa-print"></i> &nbsp; Cetak Seluruh Data <%=namaNasabah%></button>
                    </div>

                </div>
            </section>
        </div>

        <!--------------------------------------------------------------------->

    <print-area>
        <div style="size: A4;" class="">
            <div style="width: 50%; float: left;">
                <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
                <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                <span style="width: 100%; display: inline-block;"><%=compPhone%></span>                    
            </div>
            <div style="width: 50%; float: right; text-align: right">
                <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">DATA SELURUH <%=namaNasabah.toUpperCase()%> KELOMPOK / BADAN USAHA</span>
                <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal &nbsp; : &nbsp; <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
                <span style="width: 100%; display: inline-block; font-size: 12px;">Admin &nbsp; : &nbsp; <%=userFullName%></span>                    
            </div>
            <div class="clearfix"></div>
            <hr class="" style="border-color: gray">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Nomor <%=namaNasabah%></th>
                        <th>Nama <%=namaNasabah%></th>
                        <th>Nomor Telepon</th>
                        <th>Alamat Email</th>
                        <th>Alamat Badan Usaha</th>
                    </tr>  
                </thead>
                <tbody>
                    <%
                        Vector listNasabahIndividu = SessAnggota.listJoinContactClassAssign(0, 0, " cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "'", " cl." + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA] + " ASC ");
                        for (int i = 0; i < listNasabahIndividu.size(); i++) {
                            Anggota a = (Anggota) listNasabahIndividu.get(i);
                    %>
                    <tr>
                        <td><%=(i + 1)%></td>
                        <td><%=a.getNoAnggota()%></td>
                        <td><%=a.getName()%></td>
                        <td><%=a.getTelepon()%></td>
                        <td><%=a.getEmail()%></td>
                        <td><%=a.getOfficeAddress()%></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </print-area>
    
</body>
</html>
