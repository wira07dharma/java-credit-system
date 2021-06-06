<%-- 
    Document   : pencairan_kredit
    Created on : Jul 18, 2017, 1:54:00 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
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
<%  //  
    long tellerShiftId = 0;
    int iCommand = FRMQueryString.requestCommand(request);
    Location loc = new Location();
    if (userLocationId != 0) {
        loc = PstLocation.fetchFromApi(userLocationId);
    }
    
    if (useRaditya == 0) {
        if (userOID != 0) {
            Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
            if (open.size() < 1) {
                String redirectUrl = approot + "/open_cashier.jsp?redir=" + approot + "/sedana/transaksikredit/pencairan_kredit.jsp";
                response.sendRedirect(redirectUrl);
            } else {
                tellerShiftId = open.get(0).getOID();
            }
        }
    }
    String kreditName = PstSystemProperty.getValueByName("SEDANA_PENCAIRAN_KREDIT_NAME");
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
        <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>

        <style>
            .print-area { visibility: hidden; display: none; }
            .print-area.print-preview { visibility: visible; display: block; }
            @media print
            {
                body * { visibility: hidden; }
                .print-area * { visibility: visible; }
                .print-area   { visibility: visible; display: block; position: fixed; top: 0; left: 0; }
            }

            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            th:after {display: none !important;}
            #printOut td {padding: 5px}
        </style>
        <script language="javascript">
            $(document).ready(function () {

                var getDataFunction = function (onDone, onSuccess, dataSend, servletName, dataAppendTo, notification) {
                    $(this).getData({
                        onDone: function (data) {
                            onDone(data);
                        },
                        onSuccess: function (data) {
                            onSuccess(data);
                        },
                        approot: "<%=approot%>",
                        dataSend: dataSend,
                        servletName: servletName,
                        dataAppendTo: dataAppendTo,
                        notification: notification
                    });
                };

                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                    var datafilter = "";
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        "ordering": false,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "oLanguage": {
                            "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div></div>",
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
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>&SEND_USER_ID=<%=userOID%>",
                        aoColumnDefs: [
                            {
                                bSortable: false,
                                aTargets: [-1]
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
                            $('#tablePinjamanTableElement').find(".money").each(function () {
                                jMoney(this);
                            });
                        },
                        "fnPageChange": function (oSettings) {

                        }
                    });
                    $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                    $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                    $("#" + elementId).css("width", "100%");
                }

                function runDataTable() {
                    dataTablesOptions("#pinjamanTableElement", "tablePinjamanTableElement", "AjaxKredit", "listPencairan", null);
                }

                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };

                runDataTable();

                $('body').on("click", ".btn-cair", function () {
                    if (confirm("Yakin akan mencairkan kredit ini ?")) {
                        var currentBtnHtml = $('.btn-cair').html();
                        $('.btn-cair').html("Tunggu...").attr({"disabled": "true"});

                        var oid = $(this).data('oid');
                        $('#idPinjaman').val(oid);
                        var dataFor = "cairkanKredit";
                        var command = "<%=Command.SAVE%>";
                        var dataSend = {
                            "FRM_FIELD_OID": oid,
                            "FRM_FIELD_DATA_FOR": dataFor,
                            "command": command,
                            "SEND_USER_ID": "<%=userOID%>",
                            "SEND_USER_NAME": "<%=userName%>",
                            "SEND_OID_TELLER_SHIFT": "<%=tellerShiftId%>"
                        };
                        onDone = function (data) {
                            var error = data.RETURN_ERROR_CODE;
                            if (error === "0") {
                                $('#printOut').html(data.FRM_FIELD_HTML);
                                $('#printOut').find(".money").each(function () {
                                    jMoney(this);
                                });
                                $('#compName').html("<%= (loc.getName().equals("") ? compName : loc.getName()) %>");
                                $('#compAddr').html("<%= (loc.getAddress().equals("") ? compAddr : loc.getAddress()) %>");
                                $('#compPhone').html("Telp: <%= (loc.getTelephone().equals("") ? compPhone : loc.getTelephone()) %>, Fax: <%= (loc.getFax().equals("") ? compPhone : loc.getFax()) %>");
                                $('#userFullName').html("<%=userFullName%>");
                                if (confirm("Cetak dokumen pencairan ?")) {
                                    window.print();
                                }
                            } else {
                                alert("<%= kreditName %> gagal !\n" + data.RETURN_MESSAGE);
                            }
                            runDataTable();
                        };
                        onSuccess = function (data) {
                            $('.btn-cair').removeAttr("disabled").html(currentBtnHtml);
                        };
                        //alert(JSON.stringify(dataSend));
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, true);
                    }
                });

                $('.btn-print').click(function () {
                    var currentBtnHtml = $('.btn-print').html();
                    $('.btn-print').html("Tunggu...").attr({"disabled": "true"});
                    window.print();
                    $('.btn-print').removeAttr("disabled").html(currentBtnHtml);
                });
                
                $('body').on("click", ".btn-dokumen", function () {
                    var oid = $(this).data('oid');
                    var type = $(this).data('type');
                    window.open("<%=approot%>/masterdata/masterdokumen/dokumen_edit.jsp?oid_pinjaman="+oid+"&type="+type, '_blank', 'location=yes,height=650,width=1000,scrollbars=yes,status=yes');
                });
                
                $('body').on("click", ".btn-pencairan", function () {
                    $(this).html("Tunggu...").attr({"disabled": "true"});
                    var oid = $(this).data('oid');
                    window.location = "../../sedana/transaksikredit/biaya_kredit.jsp?command=<%= Command.NONE %>&pinjaman_id=" + oid;
                });

            });
        </script>

    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
                <%= kreditName %>
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Transaksi</li>
                <li class="active">Kredit</li>
            </ol>
        </section>        

        <section class="content">
            <div class="box box-success">

                <div class="box-header with-border" style="border-color: lightgray">
                    <h3 class="box-title">Daftar Kredit</h3>
                </div>

                <div class="box-body">
                    <div id="pinjamanTableElement">
                        <table class="table table-striped table-bordered table-responsive" style="font-size: 14px">
                            <thead>
                                <tr>
                                    <th>No.</th>                                    
                                    <th>Nomor Kredit</th>                                    
                                    <th>Nama <%=namaNasabah%></th>
                                    <th>Jenis Kredit</th>
                                    <th>Jumlah Pinjaman</th>
                                    <th>Lokasi</th>
                                    <th>Tanggal Pengajuan</th>
                                    <th>Status</th>
                                    <!--th>Sumber Dana</th-->
                                    <!--th>Tanggal Realisasi</th-->
                                    <th style="width: 1%">Aksi</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </section>

        <!--------------------------------------------------------------------->                

        <div class="print-area">
            <div style="size: A5;" id="printOut" class="container">

            </div>
        </div>
        
    </body>
</html>
