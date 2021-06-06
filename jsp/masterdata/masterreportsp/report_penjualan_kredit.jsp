<%-- 
    Document   : report_penjualan_kredit
    Created on : 30 Jul 20, 9:45:25
    Author     : gndiw
--%>

<%@page import="com.dimata.sedana.entity.report.ReportKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.PstReturnKreditItem"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="com.dimata.sedana.ajax.kredit.AjaxKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.PstReturnKredit"%>
<%@page import="com.dimata.posbo.entity.masterdata.Material"%>
<%@page import="com.dimata.sedana.entity.kredit.ReturnKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.ReturnKreditItem"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="com.dimata.sedana.entity.kredit.Angsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAngsuran"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.session.SessKredit"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<% 
    int appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_APPROVAL, AppObjInfo.OBJ_APPROVAL_DAFTAR_TRANSAKSI); 
    boolean privApprove = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_CLOSED));
%>
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

    public static final String[] statusKey = {
        "Done (dibayar)","Done (belum dibayar)","Draft","Analisa","Accept","Tidak Accept","Batal","Lunas"
    };

    public static final String[] statusValue = {
        "-1","-2","0","1","2","3","4","7"
    };

%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    String tglAwal = FRMQueryString.requestString(request, "FRM_TGL_AWAL");
    String tglAkhir = FRMQueryString.requestString(request, "FRM_TGL_AKHIR");
    int jenisTransaksi = FRMQueryString.requestInt(request, "FRM_TRANSAKSI");
    String[] lokasi = request.getParameterValues("FORM_LOKASI");
    String[] status = request.getParameterValues("FORM_STATUS");
    String addSql = "";
    if (!tglAwal.equals("") && !tglAkhir.equals("")) {
        addSql += " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") >= '" + tglAwal + "'"
                + " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") <= '" + tglAkhir + "'";
    } else {
        addSql += " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") >= '" + Formater.formatDate(new Date(), "yyyy-MM-dd") + "'"
                + " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") <= '" + Formater.formatDate(new Date(), "yyyy-MM-dd") + "'";
    }
    String inLokasi = "";
    if (lokasi != null){
        for (int i = 0; i < lokasi.length; i++){
            if (inLokasi.length()>0){
                inLokasi += ","+lokasi[i];
            } else {
                inLokasi += lokasi[i];
            }
        }
    }
    
    String inStatus = "";
    int type = 0;
    if (status != null){
        boolean isStatusBayar = false;
        boolean isStatusBelumBayar = false;
        for (int i=0; i < status.length; i++){
            if (status[i].equals("-1")){
                isStatusBayar = true;
            } else if (status[i].equals("-2")){
                isStatusBelumBayar = true;
            } else {
                if (inStatus.length()>0){
                    inStatus += ","+status[i];
                } else {
                    inStatus += status[i];
                }
            }
        }
        if (!isStatusBayar && !isStatusBelumBayar){
            type = 0;
        } else if (isStatusBayar){
            type = 1;
        } else if (isStatusBelumBayar){
            type = 2;
        }
    }
    
    Vector records = new Vector();
    if (iCommand == Command.LIST){
        records =  SessReportKredit.getReportPenjualanKredit(tglAwal, tglAkhir, inLokasi, type, inStatus);
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <%@ include file = "/style/style_kredit.jsp" %>
        
        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            .modal-header, .modal-footer {padding-bottom: 10px; padding-top: 10px !important}
            th:after {display: none !important;}
            .aksi {width: 1% !important}
            .btn_detail:hover {cursor: pointer}
            
            .tabel_data_print {font-size: 10px}

            print-area { visibility: hidden; display: none; }
            print-area.preview { visibility: visible; display: block; }
            @media print
            {
                body .main-page * { visibility: hidden; display: none; } 
                body print-area * { visibility: visible; }
                body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
            }
            
            .table-head-fixed thead tr{
                display:block;
            }

            .table-head-fixed th,.table-head-fixed td{
                max-width:100px;
                min-width:100px;
            }


            .table-head-fixed tbody{
              display:block;
              max-height:400px;
              overflow-x: hidden;
              overflow-y:auto;
            }
        </style>
        
        <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>
        
        <script language="javascript">
            $(document).ready(function () {
                
                $(".uang").each(function () {
                    jMoney(this);
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
                $("#btn_cari").click(function() {
                    $('#form_cari').submit();
                });
                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                    //parameter tambahan
                    var tglAwal = $('#tgl_awal').val();
                    var tglAkhir = $('#tgl_akhir').val();
                    var nasabah = $('#id_nasabah').val();
                    var transaksi = $('#kode_transaksi').val();
                    let kolektor = $('#id_kolektor').val();
                    let status = $('#status_transaksi').val();

                    var datafilter = "";
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        buttons: [
                            'copy', 'csv', 'excel', 'pdf', 'print'
                        ],
                        "searching": true,
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
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>"
                                + "&SEND_TGL_AWAL=" + tglAwal + "&SEND_TGL_AKHIR=" + tglAkhir + "&SEND_ID_NASABAH=" + nasabah + "&SEND_KODE_TRANSAKSI=" + transaksi + "&SEND_USER_ID=<%=userOID%>" + "&privApprove=<%= privApprove %>"
                                + "&SEND_ID_KOLEKTOR=" + kolektor+"&FRM_STATUS="+status,
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
                            $('input[type="checkbox"].flat-green').iCheck({
                              checkboxClass: 'icheckbox_square-green'
                            });
                            selectedTransaksi = 0;
                            let openTransaction = json.RETURN_DATA_OPEN_TRANSACTION;
                        },
                        "fnDrawCallback": function (oSettings) {
                            if (callBackDataTables !== null) {
                                callBackDataTables();
                            }
                            $(elementIdParent).find(".money").each(function () {
                                jMoney(this);
                                //$(this).addClass("text-right");
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
                    dataTablesOptions("#transaksiTableElement", "tableTransaksiTableElement", "AjaxKredit", "listTransaksiKredit", null);
                }
                
                function select2Option(elementId, placeholder, url){
                    $('#' + elementId).select2({
                        placeholder: placeholder,
                        ajax: {
                            url : url,
                            type : "POST",
                            dataType: 'json',
                            delay: 250,
                            data: function(params){
                                return {
                                    searchTerm: params.term,
                                    limitStart: params.limitStart || 0,
                                    recordToGet: 7
                                };
                            },
                            processResults: function(data, params){
                                var ph = data.PAGINATION_HEADER;

                                params.limitStart = ph.CURRENT_PAGE || 0;
                                return {
                                    results: data.ANGGOTA_DATA,
                                    pagination: {
                                        more: ph.CURRENT_PAGE < data.ANGGOTA_TOTAL
                                    }
                                };
                            },
                            cache: true
                        }
                    });
                }
                
                function setSelect2Value(elementId, selectedVal, defaultVal){
                    let newOption;
                    if(!jQuery.isEmptyObject(selectedVal)){
                        newOption = new Option(selectedVal.text, selectedVal.id, true, true);
                    } else {
                        newOption = new Option(defaultVal.text, defaultVal.id, true, true);
                    }
                    $('#' + elementId).append(newOption).trigger('change');
                }

                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };

                function selectMulti(id, placeholder) {
                    $(id).select2({
                        placeholder: placeholder
                    });
                }

//                function setNasabahValue(){
//                    let newOption;
//                    if(!jQuery.isEmptyObject(nasabahJarr)){
//                        newOption = new Option(nasabahJarr.text, nasabahJarr.id, true, true);
//                    } else {
//                        newOption = new Option(placeholderNasabah.text, placeholderNasabah.id, true, true);
//                    }
//                    $('#id_nasabah').append(newOption).trigger('change');
//                }
//
//                function setKolektorValue(){
//                    let newOption;
//                    if(!jQuery.isEmptyObject(kolektorJarr)){
//                        newOption = new Option(kolektorJarr.text, kolektorJarr.id, true, true);
//                    } else {
//                        newOption = new Option(placeholderKolektor.text, placeholderKolektor.id, true, true);
//                    }
//                    $('#id_kolektor').append(newOption).trigger('change');
//                }

                $('.date-picker').datetimepicker({
                    format: "yyyy-mm-dd",
                    weekStart: 1,
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2 // No time
                            // showMeridian: 0
                });
                

                $('.select2transaksi').select2();
                $('.select2').select2();
                
                $('#btn_export').click(function () {
                    let alertText = "Export Data?";
                    if(confirm(alertText)){
                        var buttonHtml = $(this).html();
                        $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                        let formSearch = $('#form_cari').serialize();
                        var dataSend = formSearch
                                + "&FRM_FIELD_DATA_FOR=reportPenjualanKredit" 
                                + "&command=<%=Command.NONE%>&FORM_LOKASI=<%= userLocationId %>"
                                + "&SEND_USER_ID=<%=userOID%>&SEND_USER_NAME<%=userFullName%>";
                        onDone = function (data) {
                            $('#tableExport').html(data.FRM_FIELD_HTML);
                            $('#tableExport').find(".uang").each(function () {
                                jMoney(this);
                            });
                            tableToExcel('report', 'Report Penjualan Kredit')
                        };
                        onSuccess = function (data) {
                            $('#btn_export').removeAttr('disabled').html(buttonHtml);
                            
                        };
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxReport", "null", false);
    //                    window.location = "list_transaksi.jsp?print_list_transaksi=1";
                        //window.print();
                        //$(this).removeAttr('disabled').html(buttonHtml);
                    }
                });

                var tableToExcel = (function() {
                    var uri = 'data:application/vnd.ms-excel;base64,', 
                    template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
                    base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) },
                    format = function(s, c) { 
                        return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) 
                    }
                    return function(table, name) {
                        if (!table.nodeType) table = document.getElementById(table)
                            var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
                            //window.location.href = uri + base64(format(template, ctx))
                            var blob = new Blob([format(template, ctx)]);
                            var blobURL = window.URL.createObjectURL(blob);
                            $("a#printXLS").attr('download', "report_penjualan_kredit.xls")
                            $("a#printXLS").attr('href', blobURL);
                            document.getElementById("printXLS").click();
                    }
                })()
                
            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    Data Penjualan Kredit
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Laporan</li>
                    <li class="active">Penjualan Kredit</li>
                </ol>
            </section>

            <section class="content">
                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Pencarian</h3>
                    </div>

                    <div class="box-body">
                        <form id="form_cari" class="form-inline" method="post" action="?command=<%=Command.LIST%>">
                            <input type="hidden" name="command" value="<%=Command.LIST%>">
                            <input type="text" autocomplete="off" style="width: 150px" placeholder="Tgl. awal" id="tgl_awal" class="form-control date-picker" name="FRM_TGL_AWAL" value="<%=tglAwal%>">
                            <input type="text" autocomplete="off" style="width: 150px" placeholder="Tgl. akhir" id="tgl_akhir" class="form-control date-picker" name="FRM_TGL_AKHIR" value="<%=tglAkhir%>">

                            <select class="form-control select2" multiple="multiple" name="FORM_LOKASI" data-placeholder="Pilih Lokasi">
                                    <% 
                                            Vector<Location> listLocation = PstLocation.getListFromApiAll();
                                            for(Location loc : listLocation){  
                                            String choosen = "";
                                            boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+loc.getOID());
                                            if (loc.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
                                                if(lokasi != null){
                                                        for(String oid : lokasi){
                                                                if(loc.getOID() == Long.parseLong(oid)){
                                                                        choosen = "selected";
                                                                }
                                                        }
                                                } else if (loc.getOID() == userSession.getAppUser().getAssignLocationId()) {
                                                    choosen = "selected";
                                                }
                                                %><option value="<%= loc.getOID() %>" <%= choosen %>><%= loc.getName() %></option><%
                                            }
                                    %>
                                    <% } %>
                            </select>
                            <select class="form-control select2" multiple="multiple" name="FORM_STATUS" data-placeholder="Status">
                                <%
                                    for (int x=0; x < statusKey.length; x++ ){
                                        if (status == null){
                                            if (x == 0){
                                                %> <option value="<%=statusValue[x]%>" selected="true"><%=statusKey[x]%></option> <%
                                            } else {
                                                %> <option value="<%=statusValue[x]%>"><%=statusKey[x]%></option> <%
                                            }
                                        } else {
                                            for (int i=0; i < status.length; i++){
                                                if (status[i].equals(statusValue[x])){
                                                    %> <option value="<%=statusValue[x]%>" selected="true"><%=statusKey[x]%></option> <%
                                                } else {
                                                    %> <option value="<%=statusValue[x]%>"><%=statusKey[x]%></option> <%
                                                }
                                            }
                                        }
                                        
                                    }
                                %>
                            </select>
                            <button type="button" id="btn_cari" class="btn btn-primary"><i class="fa fa-search"></i> &nbsp; Cari</button>
                        </form>

                        <hr style="margin: 10px 0px; border-color: lightgray">
                        
                        <% if (iCommand == Command.LIST){ %>
                        <div id="tableData" style="overflow-x:auto;">
                            <table class="table table-striped table-bordered table-responsive table-head-fixed" style="font-size: 14px;" border="1">
                                <thead>
                                    <tr>
                                        <th style="min-width: 100px; max-width: 100px;">Tanggal Transaksi</th>
                                        <th style="min-width: 50px; max-width: 50px;">Tahun</th>
                                        <th style="min-width: 50px; max-width: 50px;">Bulan</th>
                                        <th style="min-width: 50px; max-width: 50px;">Tanggal</th>
                                        <th style="min-width: 100px; max-width: 100px;">No PK</th>
                                        <th style="min-width: 100px; max-width: 100px;">Cabang</th>
                                        <th style="min-width: 100px; max-width: 100px;">Nama Pelanggan</th>
                                        <th style="min-width: 200px; max-width: 200px;">Alamat Pelanggan</th>
                                        <th style="min-width: 100px; max-width: 100px;">Kode Marketing</th>
                                        <th style="min-width: 100px; max-width: 100px;">Nama Marketing</th>
                                        <th style="min-width: 100px; max-width: 100px;">Kode Analis</th>
                                        <th style="min-width: 100px; max-width: 100px;">Nama Analis</th>
                                        <th style="min-width: 100px; max-width: 100px;">Kode Kolektor</th>
                                        <th style="min-width: 100px; max-width: 100px;">Nama Kolektor</th>
                                        <th style="min-width: 100px; max-width: 100px;">Kode Kelompok</th>
                                        <th style="min-width: 100px; max-width: 100px;">Nama Kelompok</th>
                                        <th style="min-width: 100px; max-width: 100px;">SKU</th>
                                        <th style="min-width: 100px; max-width: 100px;">Nama Barang</th>
                                        <th style="min-width: 100px; max-width: 100px;">Qty Barang</th>
                                        <th style="min-width: 100px; max-width: 100px;">Lama Kredit</th>
                                        <th style="min-width: 100px; max-width: 100px;">Tgl Jatuh Tempo</th>
                                        <th style="min-width: 100px; max-width: 100px;">Angsuran</th>
                                        <th style="min-width: 100px; max-width: 100px;">Total Penjualan</th>
                                        <th style="min-width: 100px; max-width: 100px;">Pembayaran</th>
                                        <th style="min-width: 100px; max-width: 100px;">Saldo</th>
                                        <th style="min-width: 150px; max-width: 150px;">Hpp</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        
                                        double grandAngsuran = 0;
                                        double grandSudahDibayar = 0;
                                        double grandSaldo = 0;
                                        double grandTotal = 0;
                                        double grandHpp = 0;
                                        if (records.size()>0){ 
                                        long currP = 0;
                                        int no = 0;
                                        String lastPk = "";
                                        for (int x=0; x<records.size();x++){
                                            ReportKredit reportKredit = (ReportKredit) records.get(x);
                                            if (!reportKredit.getNoPk().equals(lastPk)){
                                                grandAngsuran += reportKredit.getAngsuran();
                                                grandTotal += reportKredit.getTotal();
                                                grandSudahDibayar += reportKredit.getPembayaran();
                                                grandSaldo += reportKredit.getTotal() - reportKredit.getPembayaran();
                                            }
                                            grandHpp += reportKredit.getCost();
                                            %>
                                            <tr>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=Formater.formatDate(reportKredit.getTglRealisasi(), "dd MMM yyyy")%></td>
                                                <td style="text-align: left; min-width: 50px; max-width: 50px;"><%=reportKredit.getYear()%></td>
                                                <td style="text-align: left; min-width: 50px; max-width: 50px;"><%=reportKredit.getMonth()%></td>
                                                <td style="text-align: left; min-width: 50px; max-width: 50px;"><%=reportKredit.getDay()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getNoPk()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getCabang()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getNamaKonsumen()%></td>
                                                <td style="text-align: left; min-width: 200px; max-width: 200px;"><%=reportKredit.getAddrKonsumen()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getCodeSales()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getNamaSales()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getCodeAnalis()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getNamaAnalis()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getCodeKolektor()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getNamaKolektor()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getCodeGroup()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getNamaGroup()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getSkuItem()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getNamaItem()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getQty()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=reportKredit.getJangkaWaktu()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"><%=Formater.formatDate(reportKredit.getJatuhTempo(), "dd MMM yyyy")%></td>
                                                <% if (!reportKredit.getNoPk().equals(lastPk)){ %>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;" class="uang"><%=reportKredit.getAngsuran()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;" class="uang"><%=reportKredit.getTotal()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;" class="uang"><%=reportKredit.getPembayaran()%></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;" class="uang"><%=reportKredit.getTotal()-reportKredit.getPembayaran()%></td>
                                                <% lastPk = reportKredit.getNoPk(); } else { %>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"></td>
                                                <td style="text-align: left; min-width: 100px; max-width: 100px;"></td>
                                                <% } %>
                                                <td style="text-align: left; min-width: 150px; max-width: 150px;" class="uang"><%=reportKredit.getCost()%></td>
                                            </tr>
                                            <%                                            
                                            
                                        }
                                    
                                    %>
                                    <tr>
                                        <td colspan="21" style="text-align: right"><b>TOTAL</b></td>
                                        <td style="vertical-align: middle; font-weight: bold" class="uang"><%=grandAngsuran%></td>
                                        <td style="vertical-align: middle; font-weight: bold" class="uang"><%=grandTotal%></b></td>
                                        <td style="vertical-align: middle; font-weight: bold" class="uang"><%=grandSudahDibayar%></td>
                                        <td style="vertical-align: middle; font-weight: bold" class="uang"><%=grandSaldo%></td>
                                        <td style="vertical-align: middle; font-weight: bold" class="uang"><%=grandHpp%></td>
                                    </tr>
                                    
                                    <% } else { %>
                                    
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                        
                    </div>
                        <div class="box-footer" style="border-color: lightgray">
                            <div class="pull-right">
                                <a id="printXLS" style="display: none">&nbsp;</a>
                                <button id="btn_export" class="btn btn-sm btn-primary"><i class="fa fa-file-excel-o"></i> &nbsp; Export Excel</button>
                            </div>
                        </div>

                </div>
            </section>
        </div>

        <!--------------------------------------------------------------------->
        
        <div id="tableExport" style="display:  none">
            
        </div>    
        
        <!--------------------------------------------------------------------->

    <print-area> 
        <div style="size: A4" id="printOut" class="">
            
            
        </div>
    </print-area>

</body>
</html>