           <%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.Angsuran"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstJangkaWaktu"%>
<%@page import="com.dimata.sedana.entity.masterdata.JangkaWaktu"%>
<%-- 
    Document   : jadwal_angsuran
    Created on : Sep 11, 2017, 5:22:48 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.session.SessKredit"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.util.*"%>
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

<% //
    long tellerShiftId = 0;
	if(useRaditya == 0){
    if (userOID != 0) {
        Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
        if (open.size() < 1) {
            String redirectUrl = approot + "/open_cashier.jsp?redir=" + approot + "/sedana/transaksikredit/list_kredit.jsp";
            response.sendRedirect(redirectUrl);
        } else {
            tellerShiftId = open.get(0).getOID();
        }
    }
    }
    
	int enableTabungan = Integer.parseInt(PstSystemProperty.getValueByName("SEDANA_ENABLE_TABUGAN"));
    String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA"); 
	
    long oidPinjaman = FRMQueryString.requestLong(request, "pinjaman_id");
    int iCommand = FRMQueryString.requestCommand(request);
    int statusDenda = 0;
    String dendaStatus = "";
    Pinjaman pinjaman = new Pinjaman();
    Anggota nasabah = new Anggota();
    Location userLocation = new Location();
    try {
        pinjaman = (Pinjaman) PstPinjaman.fetchExc(oidPinjaman);
        nasabah = PstAnggota.fetchExc(pinjaman.getAnggotaId());
        userLocation = PstLocation.fetchFromApi(userLocationId);
        
        statusDenda = pinjaman.getStatusDenda() == Pinjaman.STATUS_DENDA_AKTIF ? Pinjaman.STATUS_DENDA_NONAKTIF : Pinjaman.STATUS_DENDA_AKTIF;
        dendaStatus = (pinjaman.getStatusDenda() == Pinjaman.STATUS_DENDA_AKTIF ? "Non Aktifkan" : "Aktifkan") + " Denda"; 
    } catch (Exception exc) {

    }
    
    boolean tidakAdaTransaksiPembayaran = SessKredit.getListAngsuranByPinjaman(pinjaman.getOID()).isEmpty();
    
    DecimalFormat df = new DecimalFormat("#.##");
    String typeOfCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
    int jangkaWaktu = 0;
    JangkaWaktu jk = new JangkaWaktu();
    try {
        jk = PstJangkaWaktu.fetchExc(pinjaman.getJangkaWaktuId());
      } catch (Exception e) {
      }
    jangkaWaktu = jk.getJangkaWaktu();
    
    

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!--         Bootstrap 3.3.6 
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
         Font Awesome 
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/font-awesome-4.7.0/css/font-awesome.min.css">        
         Datetime Picker 
        <link href="../../style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
         Select2 
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
         Theme style 
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
         AdminLTE Skins. Choose a skin from the css/skins
             folder instead of downloading all of them to reduce the load. 
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">
        <link href="../../style/datatables/dataTables.bootstrap.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../../style/bootstrap-notify/bootstrap-notify.css"/>
         jQuery 2.2.3 
        <script src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
         Bootstrap 3.3.6 
        <script src="../../style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
         FastClick 
        <script src="../../style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>

         AdminLTE for demo purposes 
        <script src="../../style/AdminLTE-2.3.11/dist/js/demo.js"></script>
         AdminLTE App 
        <script type="text/javascript" src="../../style/bootstrap-notify/bootstrap-notify.js"></script>
        <script src="../../style/AdminLTE-2.3.11/dist/js/app.min.js"></script>    
        <script src="../../style/dist/js/dimata-app.js" type="text/javascript"></script>
         Select2 
        <script src="../../style/AdminLTE-2.3.11/plugins/select2/select2.full.min.js"></script>
         Datetime Picker 
        <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
        <script src="../../style/datatables/jquery.dataTables.js" type="text/javascript"></script>
        <script src="../../style/datatables/dataTables.bootstrap.js" type="text/javascript"></script>
        <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>-->

        <%@include file="../../style/style_kredit.jsp" %>
        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            .modal-header, .modal-footer {padding-bottom: 10px; padding-top: 10px !important}
            th:after {display: none !important;}
            .no_transaksi:hover {cursor: pointer}

            print-area { visibility: hidden; display: none; }
            print-area.preview { visibility: visible; display: block; }

            @media print
            {
                body .main-page * { visibility: hidden; display: none; } 
                body print-area * { visibility: visible; }
                body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
                body #print-kartu-angsuran {
                    width: 214mm;
                    height: 190mm;
                }
                body #print-kartu-angsuran .print-area-margin {
                    margin: 20px;
                }
                #print-kartu-angsuran .print-content {
                    width: 100%;
                }
                #print-header {
                    width: 100%;
                }
                #print-kartu-angsuran .print-header tr{
                    vertical-align: top;
                }
                /* .print-area .print-content, .print-area .print-content tr, .print-area .print-content td {
                    border: 1pt solid black;
                } */
                #print-kartu-angsuran .print-content td{
                    text-align: center;
                    border: 1pt solid black;
                }
            }

        </style>
        <script language="javascript">
            $(document).ready(function () {
                //Sweet Alert
                let swalClasses = {
                        container: 'container-class',
                        popup: 'popup-class',
                        header: 'header-class',
                        title: 'title-class',
                        closeButton: 'close-button-class',
                        icon: 'icon-class',
                        image: 'image-class',
                        content: 'content-class',
                        input: 'input-class',
                        actions: 'actions-class',
                        confirmButton: 'confirm-button-class',
                        cancelButton: 'cancel-button-class',
                        footer: 'footer-class'
                };
                
                $('#btn_printExcelJadwal').click(function () {
                        window.open("print_jadwal_angsuran.jsp?FRM_PINJAMAN_ID=<%=oidPinjaman %>");
                });

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

                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
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
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FOR=" + dataFor + "&FRM_FIELD_OID=" + "<%=oidPinjaman%>",
                        aoColumnDefs: [
                            {
                                bSortable: false,
                                aTargets: [0,-1]
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
                            $('#tableJadwalTableElement').find(".money").each(function () {
                                jMoney(this);
                                //$(this).addClass('pull-right');
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
                    dataTablesOptions("#jadwalTableElement", "tableJadwalTableElement", "AjaxJadwalAngsuran", "listJadwalAngsuran", null);
                }

                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };
                
                $('.date-picker').datetimepicker({
                    weekStart: 1,
                    format: "yyyy-mm-dd",
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2 // No time
                            // showMeridian: 0
                });
                
                $('[data-toggle="tooltip"]').tooltip();

                runDataTable();               

                $('body').on("click", ".no_transaksi", function () {
                    var oid = $(this).data('oid');
                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": "getDetailTransaksiJadwal",
                        "command": "<%=Command.NONE%>"
                    };
                    onDone = function (data) {
                        var error = data.RETURN_ERROR_CODE;
                        if (error === "0") {
                            modalSetting("#modal-detailTransaksi", "static", false, false);
                            $('#modal-detailTransaksi').modal('show');
                            $('#modal-detailTransaksi').find(".money").each(function () {
                                jMoney(this);
                            });
                        } else {
                            alert(data.RETURN_MESSAGE);
                        }
                    };
                    onSuccess = function (data) {
                        
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", "#body_detail", false);
                });
                
                $('#btn_printJadwal').click(function () {
                    var buttonHtml = $(this).html();
                    $('#print-kartu-angsuran').hide();
                    $('#print-jadwal-angsuran').show();
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                    window.print();
                    $(this).removeAttr('disabled').html(buttonHtml);
                });
					
                
                $('body').on('click', '#btn_printKartuAngsuran', function(){
                    let btnHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                    Swal.fire({
                        position: 'center',
                        icon: 'warning',
                        title: "Cetak Kartu Angsuran <%= namaNasabah %>",
                        html: "Yakin mencetakan Catatan Pembayaran?", //<br>Anda tidak dapat melakukan pencetakan<br><strong>yang sama lebih dari 1 kali.</strong>
                        text: "Yakin mencetakan Catatan Pembayaran?", //Anda tidak dapat melakukan pencetakan yang sama lebih dari 1 kali.
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Yakin',
                        cancelButtonText: 'Tidak',
                        customClass: swalClasses
                    }).then((result) => {
                        if (result.value) {
                            var dataSend = {
                                "FRM_FIELD_OID"         : "<%= oidPinjaman %>",
                                "FRM_FIELD_DATA_FOR"    : "cetakKartuAngsuran",
                                "printDuplicate"        : "<%= JadwalAngsuran.CETAK_NORMAL %>",
                                "command"               : "<%= Command.NONE %>"
                            };
                            onDone = function (data) {
                                let html = data.FRM_FIELD_HTML;
                                let dataAngsuran = data.FRM_FIELD_HTML_DATA_ANGSURAN;
                                console.log(html);
                                console.log(dataAngsuran);
                                $('#print-kartu-angsuran #print-content').html(html);
                                $('body #data_angsuran').html(dataAngsuran);

                                $('#print-kartu-angsuran').show();
                                $('#print-jadwal-angsuran').hide();

                                window.print();

                                $('#btn_printKartuAngsuran').removeAttr('disabled').html(btnHtml);
                            };
                            onSuccess = function (data) {
                            };
                            //alert(JSON.stringify(dataSend));
                            getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
                        } else {
                            $('#btn_printKartuAngsuran').removeAttr('disabled').html(btnHtml);
                        }
                    });
                    
                });
                
                function updateStatusJadwal(){
                    var dataAngsuran = $('#data_jadwal_angsuran').serialize();
                    var dataSend = dataAngsuran + "&FRM_FIELD_DATA_FOR=updateStatusCetak&command=<%= Command.SAVE %>";
                    onDone = function (data) {
                    };
                    onSuccess = function (data) {
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
                }
                
                $('#btnCekBungaTambahan').click(function(){
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                    var dataSend = {
                        "FRM_FIELD_OID"         : "<%= oidPinjaman %>",
                        "FRM_FIELD_DATA_FOR"    : "generateBungaTambahan",
                        "command"               : "<%= Command.NONE %>",
                        "SEND_OID_TELLER_SHIFT" : "<%=tellerShiftId%>"
                    };
                    onDone = function (data) {
                        alert(data.RETURN_MESSAGE);
                        window.location = "jadwal_angsuran.jsp?pinjaman_id=<%= oidPinjaman %>";
                    };
                    onSuccess = function (data) {
                        $(this).removeAttr('disabled').html(buttonHtml);
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                });

                $('#btnCekDenda').click(function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                    var dataSend = {
                        "FRM_FIELD_OID"         : "<%= oidPinjaman %>",
                        "FRM_FIELD_USER_OID"    : "<%= userOID %>",
                        "FRM_FIELD_DATA_FOR"    : "generateDendaPerKredit",
                        "command"               : "<%= Command.SAVE %>",
                        "SEND_OID_TELLER_SHIFT" : "<%=tellerShiftId%>"
                    };
                    onDone = function (data) {
                        var msg = data.RETURN_MESSAGE;
                        var string = new RegExp("<br><i class='fa fa-exclamation-circle text-red'></i> ", 'g');
                        msg = msg.replace(string, '\n- ');
                        
                        string = new RegExp("<br>", 'g');
                        msg = msg.replace(string, '');
                        alert(msg);
                        window.location = "jadwal_angsuran.jsp?pinjaman_id=<%= oidPinjaman %>";
                    };
                    onSuccess = function (data) {
                        $(this).removeAttr('disabled').html(buttonHtml);
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
                });
                
                $('.btn_rounding').click(function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                    var dataSend = {
                        "FRM_FIELD_OID"         : "<%= oidPinjaman %>",
                        "FRM_FIELD_DATA_FOR"    : "setRounding",
                        "command"               : "<%= Command.SAVE %>",
                        "SEND_OID_TELLER_SHIFT" : "<%=tellerShiftId%>",
                        "ROUND_SETTING"         : $(this).data('rounding'),
                        "ROUND_VALUE"           : $('#roundValue').val()
                    };
                    onDone = function (data) {
                        alert(data.RETURN_MESSAGE);
                        window.location = "jadwal_angsuran.jsp?pinjaman_id=<%= oidPinjaman %>";
                    };
                    onSuccess = function (data) {
                        $(this).removeAttr('disabled').html(buttonHtml);
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
                });
                
                $('#btnNewSchedule').click(function() {
                    modalSetting("#modal-generateSchedule", "static", false, false);
                    $('#modal-generateSchedule').modal('show');
                });
                
                $('#btnSaveSchedule').click(function() {
                    var btn = $(this).html();
                    $(this).attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                    var dataSend = $('#formNewSchedule').serialize();
                    onDone = function (data) {
                        alert(data.RETURN_MESSAGE);
                        $('#modal-generateSchedule').modal('hide');
                        window.location = "jadwal_angsuran.jsp?pinjaman_id=<%= oidPinjaman %>";
                    };
                    onSuccess = function (data) {
                        $('#btnSaveSchedule').removeAttr('disabled').html(btn);
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                });
                
                $("#btnReSchedule").click(function() {
                    $("#formReschedule").find("input:text").val("");
                    modalSetting("#modal-reSchedule", "static", false, false);
                    $("#modal-reSchedule").modal("show");
                });
                
                $("#btnSaveReSchedule").click(function() {
                    if ($("#tglRealisasi").val() === "") {
                        alert("Isi tanggal realisasi terlebih dahulu !");
                        return false;
                    }
                    
                    var msg = "Ubah Seluruh Jadwal Sesuai Realisasi ?";
                    if (confirm(msg)) {
                        var btn = $(this).html();
                        $(this).attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                        var dataSend = $('#formReschedule').serialize();
                        onDone = function (data) {
                            alert(data.RETURN_MESSAGE);
                            $('#modal-reSchedule').modal('hide');
                            window.location = "jadwal_angsuran.jsp?pinjaman_id=<%= oidPinjaman %>";
                        };
                        onSuccess = function (data) {
                            $('#btnSaveReSchedule').removeAttr('disabled').html(btn);
                        };
                        //alert(JSON.stringify(dataSend));
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    }
                });
                
                $('body').on('click', '#btnToggleStatusDenda', function(){
                    let oid = $(this).val();
                    if(confirm("<%= dendaStatus %>? ")){
                        var buttonHtml = $('#btnToggleStatusDenda').html();
                        $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                        var dataSend = {
                            "FRM_FIELD_OID"         : "<%= oidPinjaman %>",
                            "FRM_FIELD_DATA_FOR"    : "toggleStatusDenda",
                            "command"               : "<%= Command.SAVE %>",
                            "FRM_FIELD_STATUS_DENDA": "<%= statusDenda %>"
                        };
                        onDone = function (data) {
                            alert(data.RETURN_MESSAGE);
                            window.location = "jadwal_angsuran.jsp?pinjaman_id=<%= oidPinjaman %>";
                        };
                        onSuccess = function (data) {
                            $('#btnToggleStatusDenda').removeAttr('disabled').html(buttonHtml);
                        };
                        //alert(JSON.stringify(dataSend));
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    }
                });
                
                window.onafterprint = function(event){
                    console.log("PRINTED");
                    updateStatusJadwal();
                };
                
            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    Pengajuan Kredit
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Transaksi</li>
                    <li class="active">Pengajuan Kredit</li>
                </ol>
            </section>

            <%if (pinjaman.getOID() != 0) {%>
            <section class="content-header">
                <a style="background-color: white" class="btn btn-default" href="../transaksikredit/transaksi_kredit.jsp?pinjaman_id=<%=pinjaman.getOID()%>&command=<%=Command.EDIT%>">Data Pengajuan</a>            
                <a class="btn btn-danger" href="../transaksikredit/jadwal_angsuran.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Jadwal Angsuran</a>
                <a style="background-color: white" class="btn btn-default" href="../penjamin/penjamin.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Keluarga & Penjamin</a>
                <% if (typeOfCredit.equals("0")) { %><a style="background-color: white" class="btn btn-default" href="../agunan/agunan.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Agunan / Jaminan</a><% } %>
                <% if (pinjaman.getStatusPinjaman() >= Pinjaman.STATUS_DOC_APPROVED) {%>
                <a style="background-color: white" class="btn btn-default" href="../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Detail</a>
                <% } %>
                <a style="font-size: 14px" class="btn btn-box-tool" href="../transaksikredit/list_kredit.jsp">Kembali ke daftar kredit</a>
            </section>
            <%} else {%>
            <div class="content-header" style="color: red"><i class="fa fa-warning"></i> &nbsp; Data kredit tidak ditemukan !</div>
            <%}%>

            <section class="content">
                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgrey">
                        <h3 class="box-title">Nomor Kredit &nbsp;:&nbsp; <a><%=pinjaman.getNoKredit()%></a></h3>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <h3 class="box-title">Nama <%=namaNasabah%> &nbsp;:&nbsp; <a href="../../masterdata/anggota/anggota_edit.jsp?anggota_oid=<%= nasabah.getOID() %>"><%=nasabah.getName()%></a> &nbsp;(<%=nasabah.getNoAnggota()%>)</h3>
                        <h3 class="box-title pull-right">Status &nbsp;:&nbsp; <a><%=Pinjaman.getStatusDocTitle(pinjaman.getStatusPinjaman())%></a></h3>
                    </div>

                    <div class="box-body">
                        <h4 class="text-center"><b>JADWAL ANGSURAN</b></h4>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="col-sm-4">Total Pokok</div>
                                <div class="col-sm-1">:</div>
                                <div class="col-sm-6">
                                    <span class="money">
                                        <%= SessReportKredit.getTotalAngsuran(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK)%>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="col-sm-4">Total Bunga</div>
                                <div class="col-sm-1">:</div>
                                <div class="col-sm-6">
                                    <span class="money">
                                        <%= SessReportKredit.getTotalAngsuran(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA)%>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="row">            
                            <div class="col-sm-6">
                                <div class="col-sm-4">Total Down Payment</div>
                                <div class="col-sm-1">:</div>
                                <div class="col-sm-6">
                                    <span class="money">
                                        <%= SessReportKredit.getTotalAngsuran(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT)%>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="col-sm-4">Total Denda</div>
                                <div class="col-sm-1">:</div>
                                <div class="col-sm-6">
                                    <span class="money">
                                        <%= SessReportKredit.getTotalAngsuran(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_DENDA)%>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <br>
                        
                        <div id="jadwalTableElement">
                            <table class="table table-striped table-bordered table-responsive" style="font-size: 14px">
                                <thead>
                                    <tr>
                                        <th style="width: 1%">No.</th>                                    
                                        <th>Jatuh Tempo</th>
                                        <th>Angsuran</th>
                                        <% //if(enableTabungan == 1){ %>
                                            <th>Angsuran Bunga</th>
                                        <% //} %>
                                        <th>Nilai Denda</th>
                                        <th>Nilai Penalty</th>
                                        <th>No. Kwitansi</th>
                                        <th style="max-width: 30%">Kode Pembayaran</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>

                        <form id="data_jadwal_angsuran">
                            <div id="data_angsuran">

                            </div>
                        </form>
                                        
                                        
                    </div>

                    <div class="box-footer" style="border-color: lightgray">
                        <% if (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_DRAFT) { %>
                        <button type="button" class="btn btn-sm btn-default btn_rounding" data-rounding="1">Gunakan Pembulatan</button>
                        <button type="button" class="btn btn-sm btn-default btn_rounding" data-rounding="2">Hilangkan Pembulatan</button>
                        <input type="hidden" id="roundValue" value="500">
                        <% } %>
                        
                        <% if (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR) { %>
                        <button type="button" class="btn btn-sm btn-default" id="btnCekBungaTambahan">Hitung Bunga Tambahan</button>
                        <button type="button" class="btn btn-sm btn-default" id="btnCekDenda">Hitung Denda</button>
                        <button type="button" class="btn btn-sm btn-default" id="btnNewSchedule">Jadwal Baru</button>
                        <button type="button" class="btn btn-sm btn-default" id="btnReSchedule">Jadwal Ulang</button>
                        <% } %>
                        <button type="button" class="btn btn-sm btn-default" id="btnToggleStatusDenda" value="<%= statusDenda %>"><%= dendaStatus %></button>
                        
                        <div class="pull-right">
                        <button type="button" class="btn btn-sm btn-success " id="btn_printExcelJadwal"><i class="fa fa-print"></i> &nbsp; Export Excel</button> 
                        <button type="button" class="btn btn-sm btn-warning " id="btn_printKartuAngsuran"><i class="fa fa-print"></i> &nbsp; Cetak Kartu Angsuran</button> 
                        <button type="button" class="btn btn-sm btn-primary " id="btn_printJadwal"><i class="fa fa-print"></i> &nbsp; Cetak Jadwal</button>
                    </div>
                    </div>

                </div>
            </section>
        </div>

        <!--------------------------------------------------------------------->
        
        <div id="modal-detailTransaksi" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Detail Transaksi</h4>
                    </div>

                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-12">

                                <div id="body_detail">

                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" id="btn_close" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Keluar</button>
                    </div>

                </div>
            </div>
        </div>
        
        <div id="modal-generateSchedule" class="modal fade" role="dialog">
            <div class="modal-dialog">                
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Jadwal Baru</h4>
                    </div>

                    <div class="modal-body">
                        <style>
                            #formNewSchedule .control-label {text-align: left}
                        </style>
                        <form id="formNewSchedule" class="form-horizontal">
                            <input type="hidden" name="SEND_OID_PINJAMAN" value="<%= oidPinjaman %>">
                            <input type="hidden" name="SEND_OID_TELLER_SHIFT" value="<%= tellerShiftId %>">
                            <input type="hidden" name="FRM_FIELD_DATA_FOR" value="saveNewSchedule">
                            <input type="hidden" name="command" value="<%= Command.SAVE %>">
                            
                            <div class="form-group">
                                <div class="col-sm-12">
                                    <label class="col-sm-4 control-label">Jenis Angsuran</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" name="FRM_JENIS_ANGSURAN">
                                            <option value="<%= JadwalAngsuran.TIPE_ANGSURAN_DENDA %>"><%= JadwalAngsuran.getTipeAngsuranTitle(JadwalAngsuran.TIPE_ANGSURAN_DENDA) %></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                                    
                            <div class="form-group">
                                <div class="col-sm-12">
                                    <label class="col-sm-4 control-label">Denda Untuk</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" name="FRM_ID_PARENT_JADWAL_ANGSURAN">
                                            <option value="">- Pilih Jadwal -</option>
                                            <% Vector<JadwalAngsuran> listJadwalAngsuran = PstJadwalAngsuran.list(0, 0, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + pinjaman.getOID(), PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + "," + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]); %>
                                            <% for (JadwalAngsuran ja : listJadwalAngsuran) {%>
                                            <option value="<%= ja.getOID() %>"><%= JadwalAngsuran.getTipeAngsuranTitle(ja.getJenisAngsuran()) %> - <%= ja.getTanggalAngsuran() %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                            </div>
                                   
                            <div class="form-group">
                                <div class="col-sm-12">
                                    <label class="col-sm-4 control-label">Nilai Angsuran</label>
                                    <div class="col-sm-8">
                                        <div class="input-group">
                                            <span class="input-group-addon">Rp</span>
                                            <input type="text" class="form-control" name="FRM_JUMLAH_ANGSURAN">
                                        </div>
                                    </div>
                                </div>
                            </div>
                                   
                            <div class="form-group">
                                <div class="col-sm-12">
                                    <label class="col-sm-4 control-label">Tanggal Tempo</label>
                                    <div class="col-sm-8">
                                        <div class="input-group">
                                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                            <input type="text" class="form-control date-picker" name="SEND_TGL_TEMPO">
                                        </div>
                                    </div>
                                </div>
                            </div>
                                    
                        </form>
                    </div>

                    <div class="modal-footer">
                        <div class="col-sm-12">
                            <button type="button" id="btnSaveSchedule" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                            <button type="button" id="btn_close" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                        </div>
                    </div>

                </div>
            </div>
        </div>
                                    
        <div id="modal-reSchedule" class="modal fade" role="dialog">
            <div class="modal-dialog modal-sm">                
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Jadwal Ulang</h4>
                    </div>

                    <div class="modal-body">
                        <form id="formReschedule" class="form-horizontal">
                            <input type="hidden" name="command" value="<%= Command.SAVE %>">
                            <input type="hidden" name="FRM_FIELD_OID" value="<%= oidPinjaman %>">
                            <input type="hidden" name="FRM_FIELD_DATA_FOR" value="reScheduleJadwalAngsuran">
                            
                            <label class="">Masukkan tanggal realisasi :</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                <input type="text" id="tglRealisasi" name="FRM_TGL_REALISASI" autocomplete="off" class="form-control date-picker">
                            </div>
                        </form>
                    </div>

                    <div class="modal-footer">
                        <button type="button" id="btnSaveReSchedule" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Lanjutkan</button>
                        <button type="button" id="btn_close" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                    </div>

                </div>
            </div>
        </div>

        <!--------------------------------------------------------------------->
        <%
        if(useForRaditya.equals("1")){
        %>
        <print-area>
            <div id="print-kartu-angsuran">
                <div id="print-content">

                </div>
            </div>
            <div id="print-jadwal-angsuran">
                <div style="size: A4" >
                    <div style="width: 60%; float: left;">
                    <strong style="width: 100%; display: inline-block; font-size: 20px;"><%= userLocation.getName() %></strong>
                    <span style="width: 100%; display: inline-block;"><%= userLocation.getAddress() %></span>
                    <span style="width: 100%; display: inline-block;">Telp. <%= userLocation.getTelephone() %>, Fax. <%= userLocation.getFax() %></span>                     
                    </div>
                    <div style="width: 40%; float: right; text-align: right">                    
                        <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">JADWAL ANGSURAN KREDIT</span>
                        <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal : <%=Formater.formatDate(new Date(), "dd MMM yyyy / HH:mm:ss")%></span>                    
                        <span style="width: 100%; display: inline-block; font-size: 12px;">Admin : <%=userFullName%></span>                    
                    </div>
                    <div class="clearfix"></div>
                    <hr class="" style="border-color: gray">
                    <div>
                        <span style="width: 120px; float: left;">Nomor Kredit</span>
                        <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=pinjaman.getNoKredit()%></span>
                    </div>
                    <div>
                        <span style="width: 120px; float: left;">Nama <%=namaNasabah%></span>
                        <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=nasabah.getName()%></span>
                    </div>
                    <div>
                        <span style="width: 120px; float: left;">Jumlah Pinjaman</span>
                        <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; Rp <a style="color: black" class="money"><%=pinjaman.getJumlahPinjaman()%></a></span>
                    </div>
                    <div>
                        <span style="width: 120px; float: left;">Jangka Waktu</span>
                        <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=jangkaWaktu%> kali angsuran</span>
                    </div>
                    <div class="clearfix"></div>
                    <div>
                        <h4 style="text-align: center"><b>Jadwal Angsuran</b></h4>
                    </div>
                    <div>
                        <table class="table table-bordered" style="font-size: 12px">
                            <thead>
                                <tr>
                                    <th rowspan="2" style="width: 1%">No.</th>
                                    <th rowspan="2">Jatuh Tempo</th>
                                    <th colspan="2">Angsuran</th>
                                    <th colspan="2">Denda</th>
                                    <th rowspan="2">No. Kwitansi</th>
                                    <th rowspan="2">Tanggal Bayar</th>
                                    <th rowspan="2">Keterangan</th>
                                </tr>
                                <tr>
                                    <th>Jumlah</th>
                                    <th>Dibayar</th>
                                    <th>Jumlah</th>
                                    <th>Dibayar</th>
                                </tr>
                            </thead>
                            <tbody>

                                <%
                                    Vector listJadwal = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'"
                                            + " GROUP BY " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN], PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);

                                    double totalPokok = 0;
                                    double totalPokokDibayar = 0;
                                    double totalDenda = 0;
                                    double totalDendaDibayar = 0;

                                    for (int i = 0; i < listJadwal.size(); i++) {
                                        JadwalAngsuran ja = (JadwalAngsuran) listJadwal.get(i);
                                        Vector listAngsuran = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'"
                                                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + ja.getTanggalAngsuran() + "'", "");
                                        double pokok = 0;
                                        double pokokDibayar = 0;
                                        double tempPokok = 0;
                                        double tempPokokDibayar = 0;
                                        double denda = 0;
                                        double dendaDibayar = 0;
                                        String status = "";
                                        int belumLunas = 0;
                                        String tglBayar = "";
                                        for (int la = 0; la < listAngsuran.size(); la++) {
                                            String tempTglBayar = "";
                                            JadwalAngsuran angsuran = (JadwalAngsuran) listAngsuran.get(la);
                                            if (angsuran.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK 
                                                    || angsuran.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_BUNGA
                                                    || angsuran.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT) {
                                                tempPokok = angsuran.getJumlahANgsuran();
                                                totalPokok += tempPokok;
                                                tempPokokDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(angsuran.getPinjamanId(),
                                                        (angsuran.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK ? JadwalAngsuran.TIPE_ANGSURAN_POKOK :
                                                                (angsuran.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_BUNGA ? JadwalAngsuran.TIPE_ANGSURAN_BUNGA :
                                                                        JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT)),
                                                        angsuran.getTanggalAngsuran().toString());
                                                pokok += tempPokok;
                                                pokokDibayar += tempPokokDibayar;
                                                totalPokokDibayar += tempPokokDibayar;
                                                double newPokok = Double.valueOf(df.format(tempPokok));
                                                double newPokokDibayar = Double.valueOf(df.format(tempPokokDibayar));
                                                belumLunas += (newPokokDibayar >= newPokok) ? 0 : 1;
                                            } else if (angsuran.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_DENDA) {
                                                denda = angsuran.getJumlahANgsuran();
                                                totalDenda += denda;
                                                dendaDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(angsuran.getPinjamanId(), JadwalAngsuran.TIPE_ANGSURAN_DENDA, angsuran.getTanggalAngsuran().toString());
                                                totalDendaDibayar += dendaDibayar;
                                                double newDenda = Double.valueOf(df.format(denda));
                                                double newDendaDibayar = Double.valueOf(df.format(dendaDibayar));
                                                belumLunas += (newDendaDibayar >= newDenda) ? 0 : 1;
                                            }
                                            
                                            Vector<Angsuran> listAngsuranTerbayar = PstAngsuran.list(0, 0, PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = " + angsuran.getOID(), "");
                                            int index = 0;
                                            for(Angsuran a : listAngsuranTerbayar){
                                                Transaksi t = new Transaksi();
                                                try {
                                                    t = PstTransaksi.fetchExc(a.getTransaksiId());
                                                } catch (Exception e) {
                                                    
                                                }
                                                if(index != 0){
                                                    tempTglBayar += " <br> ";
                                                }
                                                tempTglBayar += Formater.formatDate(t.getTanggalTransaksi(), "dd MMM yyyy");
                                                index++;
                                            }
                                            tglBayar = tempTglBayar;
                                        }
                                        status = (belumLunas > 0) ? "Belum lunas" : "Lunas";
                                %>

                                <tr>
                                    <td class="text-center"><%=(i + 1)%></td>
                                    <td class="text-center"><%=Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy")%></td>
                                    <td class="money text-right"><%=pokok%></td>
                                    <td class="money text-right"><%=pokokDibayar%></td>
                                    <td class="money text-right"><%=denda%></td>
                                    <td class="money text-right"><%=dendaDibayar%></td>
                                    <td class="text-center"><%=ja.getNoKwitansi() %></td>
                                    <td class="text-center"><%= (tglBayar.length() > 0 ? tglBayar : " - ") %></td>
                                    <td class="text-center"><%=status%></td>
                                </tr>

                                <%
                                    pokok = 0;
                                    pokokDibayar = 0;
                                    }
                                %>

                                <tr>
                                    <th colspan="2" class="text-right">TOTAL</th>
                                    <th class="money text-right"><%= totalPokok %></th>
                                    <th class="money text-right"><%= totalPokokDibayar %></th>
                                    <th class="money text-right"><%= totalDenda %></th>
                                    <th class="money text-right"><%= totalDendaDibayar %></th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>

                            </tbody>
                        </table>
                    </div>

                    <div class="clearfix"></div>

                    <div style="width: 100%;padding-top: 40px;">
                        <div style="width: 50%;float: left;text-align: center;">
                            <span>Petugas</span>
                            <br><br><br><br>
                            <span>(&nbsp; . . . . . . . . . . . . . . . . . . . . &nbsp;)</span>
                        </div>
                    </div>
                </div>
            </div>
        </print-area>
        <%}else{%>
        <print-area>
            <div style="size: A4" class="">
                <div style="width: 50%; float: left;">
                    <strong style="width: 100%; display: inline-block; font-size: 20px;"><%= userLocation.getName() %></strong>
                    <span style="width: 100%; display: inline-block;"><%= userLocation.getAddress() %></span>
                    <span style="width: 100%; display: inline-block;">Telp. <%= userLocation.getTelephone() %>, Fax. <%= userLocation.getFax() %></span>                    
                </div>
                <div style="width: 50%; float: right; text-align: right">                    
                    <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">JADWAL ANGSURAN KREDIT</span>
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal : <%=Formater.formatDate(new Date(), "dd MMM yyyy / HH:mm:ss")%></span>                    
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Admin : <%=userFullName%></span>                    
                </div>
                <div class="clearfix"></div>
                <hr class="" style="border-color: gray">
                <div>
                    <span style="width: 120px; float: left;">Nomor Kredit</span>
                    <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=pinjaman.getNoKredit()%></span>
                </div>
                <div>
                    <span style="width: 120px; float: left;">Nama <%=namaNasabah%></span>
                    <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=nasabah.getName()%></span>
                </div>
                <div>
                    <span style="width: 120px; float: left;">Jumlah Pinjaman</span>
                    <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; Rp <a style="color: black" class="money"><%=pinjaman.getJumlahPinjaman()%></a></span>
                </div>
                <div>
                    <span style="width: 120px; float: left;">Jangka Waktu</span>
                    <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=jangkaWaktu%> kali angsuran</span>
                </div>
                <div>
                    <span style="width: 120px; float: left;">Suku Bunga</span>
                    <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=pinjaman.getSukuBunga()%>% / Tahun</span>
                </div>
                <div>
                    <span style="width: 120px; float: left;">Tipe Bunga</span>
                    <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=Pinjaman.TIPE_BUNGA_TITLE[pinjaman.getTipeBunga()] %></span>
                </div>
                <div class="clearfix"></div>
                <div>
                    <h4 style="text-align: center"><b>Jadwal Angsuran</b></h4>
                </div>
                <div>
                    <table class="table table-bordered" style="font-size: 12px">
                        <thead>
                            <tr>
                                <th rowspan="2" style="width: 1%">No.</th>
                                <th rowspan="2">Jatuh Tempo</th>
                                <th colspan="2">Pokok</th>
                                <th colspan="2">Bunga</th>
                                <th colspan="2">Denda</th>
                                <th rowspan="2">Keterangan</th>
                            </tr>
                            <tr>
                                <th>Jumlah</th>
                                <th>Dibayar</th>
                                <th>Jumlah</th>
                                <th>Dibayar</th>
                                <th>Jumlah</th>
                                <th>Dibayar</th>
                            </tr>
                        </thead>
                        <tbody>

                            <%
                                Vector listJadwal = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'"
                                        + " GROUP BY " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN], PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
                                
                                double totalPokok = 0;
                                double totalPokokDibayar = 0;
                                double totalBunga = 0;
                                double totalBungaDibayar = 0;
                                double totalDenda = 0;
                                double totalDendaDibayar = 0;
                                
                                for (int i = 0; i < listJadwal.size(); i++) {
                                    JadwalAngsuran ja = (JadwalAngsuran) listJadwal.get(i);
                                    Vector listAngsuran = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'"
                                            + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + ja.getTanggalAngsuran() + "'", "");
                                    double pokok = 0;
                                    double pokokDibayar = 0;
                                    double bunga = 0;
                                    double bungaDibayar = 0;
                                    double denda = 0;
                                    double dendaDibayar = 0;
                                    String status = "";
                                    int belumLunas = 0;
                                    for (int la = 0; la < listAngsuran.size(); la++) {
                                        JadwalAngsuran angsuran = (JadwalAngsuran) listAngsuran.get(la);
                                        if (angsuran.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK) {
                                            pokok = angsuran.getJumlahANgsuran();
                                            totalPokok += pokok;
                                            pokokDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(angsuran.getPinjamanId(), JadwalAngsuran.TIPE_ANGSURAN_POKOK, angsuran.getTanggalAngsuran().toString());
                                            totalPokokDibayar += pokokDibayar;
                                            double newPokok = Double.valueOf(df.format(pokok));
                                            double newPokokDibayar = Double.valueOf(df.format(pokokDibayar));
                                            belumLunas += (newPokokDibayar >= newPokok) ? 0 : 1;
                                        } else if (angsuran.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_BUNGA) {
                                            bunga = angsuran.getJumlahANgsuran();
                                            totalBunga += bunga;
                                            bungaDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(angsuran.getPinjamanId(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA, angsuran.getTanggalAngsuran().toString());
                                            totalBungaDibayar += bungaDibayar;
                                            double newBunga = Double.valueOf(df.format(bunga));
                                            double newBungaDibayar = Double.valueOf(df.format(bungaDibayar));
                                            belumLunas += (newBungaDibayar >= newBunga) ? 0 : 1;
                                        } else if (angsuran.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_DENDA) {
                                            denda = angsuran.getJumlahANgsuran();
                                            totalDenda += denda;
                                            dendaDibayar = SessReportKredit.getTotalAngsuranDibayarPerJadwal(angsuran.getPinjamanId(), JadwalAngsuran.TIPE_ANGSURAN_DENDA, angsuran.getTanggalAngsuran().toString());
                                            totalDendaDibayar += dendaDibayar;
                                            double newDenda = Double.valueOf(df.format(denda));
                                            double newDendaDibayar = Double.valueOf(df.format(dendaDibayar));
                                            belumLunas += (newDendaDibayar >= newDenda) ? 0 : 1;
                                        }
                                    }
                                    status = (belumLunas > 0) ? "Belum lunas" : "Lunas";
                            %>

                            <tr>
                                <td><%=(i + 1)%></td>
                                <td><%=Formater.formatDate(ja.getTanggalAngsuran(), "dd MMM yyyy")%></td>
                                <td class="money text-right"><%=pokok%></td>
                                <td class="money text-right"><%=pokokDibayar%></td>
                                <td class="money text-right"><%=bunga%></td>
                                <td class="money text-right"><%=bungaDibayar%></td>
                                <td class="money text-right"><%=denda%></td>
                                <td class="money text-right"><%=dendaDibayar%></td>
                                <td class=""><%=status%></td>
                            </tr>

                            <%
                                }
                            %>
                            
                            <tr>
                                <th colspan="2" class="text-right">TOTAL</th>
                                <th class="money text-right"><%= totalPokok %></th>
                                <th class="money text-right"><%= totalPokokDibayar %></th>
                                <th class="money text-right"><%= totalBunga %></th>
                                <th class="money text-right"><%= totalBungaDibayar %></th>
                                <th class="money text-right"><%= totalDenda %></th>
                                <th class="money text-right"><%= totalDendaDibayar %></th>
                                <th></th>
                            </tr>
                            
                        </tbody>
                    </table>
                </div>

                <div class="clearfix"></div>
                
                
                
                <div style="width: 100%;padding-top: 40px;">
                    <div style="width: 50%;float: left;text-align: center;">
                        <span>Petugas</span>
                        <br><br><br><br>
                        <span>(&nbsp; . . . . . . . . . . . . . . . . . . . . &nbsp;)</span>
                    </div>
                </div>
            </div>
        </print-area>
        <%}%>

    </body>
</html>
