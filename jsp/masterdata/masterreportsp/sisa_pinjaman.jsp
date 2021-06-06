<%-- 
    Document   : sisa_pinjaman
    Created on : Aug 7, 2017, 2:20:37 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.report.ReportKredit"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.pos.entity.billing.PstBillMain"%>
<%@page import="com.dimata.pos.entity.billing.BillMain"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="com.dimata.sedana.entity.kredit.Angsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.AngsuranPayment"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import = "com.dimata.util.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    int month = FRMQueryString.requestInt(request, "month_value");
    int year = FRMQueryString.requestInt(request, "year_value");
    String nama = FRMQueryString.requestString(request, "FORM_NAMA");
    String ktp = FRMQueryString.requestString(request, "FORM_KTP");
    String kolektor = FRMQueryString.requestString(request, "FORM_KOLEKTOR");
//    String lokasi = FRMQueryString.requestString(request, "FORM_LOKASI");
	String[] lokasi = request.getParameterValues("FORM_LOKASI");
    String noKredit = FRMQueryString.requestString(request, "FORM_NO_KREDIT");
    String arrayNasabah[] = request.getParameterValues("FRM_NASABAH");
    String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA"); 
    String date = FRMQueryString.requestString(request, "FRM_TGL");
    String addSql = "";


    
    if (arrayNasabah != null) {
        String idNasabah = "";
        for (int i = 0; i < arrayNasabah.length; i++) {
            if (i > 0) {
                idNasabah += ",";
            }
            idNasabah += "" + arrayNasabah[i];
        }
        if (!idNasabah.equals("")) {
            addSql += " AND cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " IN (" + idNasabah + ")";
        }
    }
    if (!ktp.equals("")) {
        addSql += " AND cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_CARD] + " = '" + ktp + "'";
    }
    if (!kolektor.equals("")) {
        addSql += " AND cl." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME] + " LIKE '%" + kolektor + "%'";
    }
    if (lokasi != null) {
		String cvtLoc = "";
		int count = 0;
		for(String loc : lokasi){
			if(count > 0){
				cvtLoc += ",";
			}
			cvtLoc += loc;
			count++;
		}
		addSql += " AND loc." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " IN (" + cvtLoc + ")";
    }
    if (!noKredit.equals("")) {
        addSql += " AND p." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT] + " = '" + noKredit + "'";
    }
    String bulan[] = {"", "Januari", "Februari", "Maret", "April", "Mei", "Juni",
        "Juli", "Agustus", "September", "Oktober", "November", "Desember"};
    String bulanPendek[] = {"", "Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"};

    Vector<JadwalAngsuran> listPinjaman = new Vector();
    List<List<String>> listRow = new ArrayList<List<String>>();
    List<String> listValue = new ArrayList<String>();
    /*
    listPinjaman = SessReportKredit.listJoinPinjamanAngsuran(0, 0, " MONTH(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") = '" + month + "'"
            + " AND YEAR(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") = '" + year + "'"
            + " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'"
            + "" + addSql
            + " GROUP BY jadwal." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID], "pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]);
    */
    Vector<Location> listLocation = PstLocation.getListFromApiAll();
	Vector listSisaPinjaman = new Vector();
    if (iCommand == Command.LIST) {
        String where = "p." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = " + Pinjaman.STATUS_DOC_CAIR;
        String group = " GROUP BY p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID];
        String order = "p." + PstPinjaman.fieldNames[PstPinjaman.FLD_TGL_REALISASI];
        listSisaPinjaman = SessReportKredit.listSisaPinjamanV2(where + addSql, order, date);
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
        <!-- Datatables -->
        <script src="../../style/datatables/jquery.dataTables.js" type="text/javascript"></script>
        <script src="../../style/datatables/dataTables.bootstrap.js" type="text/javascript"></script>
        <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>
        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white;}
            /*
            .print-area { visibility: hidden; display: none; }
            .print-area.print-preview { visibility: visible; display: block; }
            @media print
            {
                body * { visibility: hidden; }
                .print-area * { visibility: visible; }
                .print-area   { visibility: visible; display: block; position: fixed; top: 0; left: 0; }
            }
            */
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
        <script language="javascript">
            $(document).ready(function () {
                            $('.select2').select2();
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

                $('.input_tgl').datetimepicker({
                    weekStart: 1,
                    format: "yyyy-mm-dd",
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2
                });

                $('#btn-searchKolektibilitas').click(function () {
                    var dataSend = {
                        "FRM_FIELD_DATA_FOR": "cekKolektibilitas",
                        "SEND_DATE_CHECK": $('#dateCheck').val(),
                        "command": "<%=Command.NONE%>"
                    };
                    onDone = function (data) {
                    };
                    onSuccess = function (data) {
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    return false;
                });

                $('#month_value').val("<%=month%>");
                $('#year_value').val("<%=year%>");

                if ("<%=month%>" === "0") {
                    $('#month_value').val("");
                }
                if ("<%=year%>" === "0") {
                    $('#year_value').val("");
                }

                $('#form_search').submit(function () {
                    $('#btn-searchpinjaman').attr({"disabled": "true"}).html("Tunggu...");
                });

                $('#btn-print').click(function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.print();
                    $(this).removeAttr('disabled').html(buttonHtml);
                });
                
                function selectMulti(id, placeholder) {
                    $(id).select2({
                        placeholder: placeholder
                    }).on('select2:open',function(){

                        $('.select2-dropdown--above').attr('id','fix');
                        $('#fix').removeClass('select2-dropdown--above');
                        $('#fix').addClass('select2-dropdown--below');

                    });
                }
                
                
                $('#btn_export').click(function () {
                    let alertText = "Export Data?";
                    if(confirm(alertText)){
                        var buttonHtml = $(this).html();
                        $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                        let formSearch = $('#form_search').serialize();
                        var dataSend = formSearch
                                + "&FRM_FIELD_DATA_FOR=reportSisaPinjaman" 
                                + "&command=<%=Command.NONE%>&FORM_LOKASI=<%= userLocationId %>"
                                + "&SEND_USER_ID=<%=userOID%>&SEND_USER_NAME<%=userFullName%>";
                        onDone = function (data) {
                            $('#tableExport').html(data.FRM_FIELD_HTML);
                            $('#tableExport').find(".money").each(function () {
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
                            $("a#printXLS").attr('download', "report_sisa_kredit.xls")
                            $("a#printXLS").attr('href', blobURL);
                            document.getElementById("printXLS").click();
                    }
                })()

                selectMulti('.select2nasabah', "Semua " + "<%=namaNasabah%>");

            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    Laporan Sisa Kredit
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Laporan</li>
                    <li class="active">Kredit</li>
                </ol>
            </section>

            <section class="content">
                <div class="box box-success">

                    <div class="box-header with-border">
                        <h3 class="box-title">Form Pencarian</h3>
                    </div>

                    <div class="box-body">
                        <form class="form-inline" id="form_search" method="post" action="?command=<%=Command.LIST%>">
                            
                            <%  if(1 == 3){%>
                            <div class="form-group">
                                <select style="width: 300px" multiple="" id="id_nasabah" class="select2nasabah" name="FRM_NASABAH">
                                    <%
                                        Vector listNasabah = SessAnggota.listJoinContactClassAssign(0, 0, ""
                                                + " cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                                                + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "'"
                                                + "", "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]);
                                        for (int i = 0; i < listNasabah.size(); i++) {
                                            Anggota a = (Anggota) listNasabah.get(i);
                                            long id = a.getOID();
                                            String selected = "";
                                            if (arrayNasabah != null) {
                                                for (int j = 0; j < arrayNasabah.length; j++) {
                                                    long isi = Long.valueOf(arrayNasabah[j]);
                                                    if (isi == id) {
                                                        selected = "selected";
                                                        break;
                                                    }
                                                }
                                            }
                                    %>
                                    <option <%=selected%> value="<%=a.getOID()%>"><%=a.getName()%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                                <%}%>
                            &nbsp;
                            <div class="form-group">
                                <input type="text" placeholder="Nomor Kredit" class="form-control" name="FORM_NO_KREDIT" value="<%=noKredit%>">
                            </div>
                            <div class="form-group">
                                <input type="text" autocomplete="off" style="width: 150px" placeholder="Tgl. Pencarian" id="tgl_akhir" class="form-control input_tgl" name="FRM_TGL" value="<%=date%>">
                            </div>
<!--                            &nbsp;
                            <div class="form-group">
                                <input type="text" placeholder="Nomor KTP" class="form-control input-sm" name="FORM_KTP" value="<%=ktp%>">
                            </div>-->
                            &nbsp;
                            <%if(1 == 2){%>
                            <div class="form-group">
                                <input type="text" placeholder="Nama Kolektor" class="form-control" name="FORM_KOLEKTOR" value="<%=kolektor%>">
                            </div>
                            <%}%>
                            &nbsp;
                            <div class="form-group">
                            <select class="form-control select2" multiple="multiple" name="FORM_LOKASI">
                                    <% 
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
                                <!--<input type="text" placeholder="Lokasi" class="form-control input-sm" name="FORM_LOKASI" value="<%=lokasi%>">-->
                            </div>
                            &nbsp;
                            <div class="form-group">
                                <button type="submit" class="btn btn-sm btn-primary" id="btn-searchpinjaman"><i class="fa fa-search"></i> &nbsp; Cari</button>
                            </div>                        

                            
                        </form>
                        <% if (iCommand == Command.LIST && listSisaPinjaman.size() > 0) {%>
                        <div class="form-group pull-right">
                            <a id="printXLS" style="display: none">&nbsp;</a>
                            <button id="btn_export" class="btn btn-sm btn-primary"><i class="fa fa-file-excel-o"></i> &nbsp; Export Excel</button>
                            <button type="button" class="btn btn-sm btn-primary" id="btn-print"><i class="fa fa-print"></i> &nbsp; Cetak</button>
                        </div>
                        <%}%>
                    </div>

                </div>

                <% if (iCommand == Command.LIST) {%>

                <div class="box box-success">
                    <div class="">
                        <h4 class="text-center"><strong>Informasi Sisa Kredit</strong></h4>                    
                    </div>
                    <div class="box-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped table-hover table-head-fixed" style="font-size: 14px">
                                <thead>
                                    <tr>
                                        <th style="min-width: 50px; max-width: 50px;">No.</th>
                                        <th style="min-width: 100px; max-width: 100px;">Nomor Kredit</th>
                                        <th style="min-width: 250px; max-width: 250px;">Nama <%=namaNasabah%></th>
                                        <th style="min-width: 100px; max-width: 100px;">Jumlah Kredit</th>
                                        <th style="min-width: 100px; max-width: 100px;">DP</th>
                                        <th style="min-width: 50px; max-width: 50px;">Jangka Waktu</th>
                                        <%
                                          if(useForRaditya.equals("1")){
                                          %>
                                        <th style="min-width: 100px; max-width: 100px;">Lokasi Transaksi</th>
                                        <th style="min-width: 100px; max-width: 100px;">Kolektor</th>
                                        <th style="min-width: 100px; max-width: 100px;">Tanggal Realisasi</th>
                                        <th style="min-width: 100px; max-width: 100px;">Jatuh Tempo</th>
                                        <%
                                          }
                                          %>
                                        <th style="min-width: 100px; max-width: 100px;">Angsuran</th>
                                        <th style="min-width: 100px; max-width: 100px;">Sisa Pokok</th>
                                        <th style="min-width: 100px; max-width: 100px;">Sisa Bunga</th>
                                        <th style="min-width: 100px; max-width: 100px;">Sisa Saldo</th>
                                        <th style="min-width: 10px; max-width: 10px;">&nbsp;</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    double totalPinjaman = 0;
                                    double totalDP = 0;
                                    double totalAngsuran = 0;
                                    double totalSisaPokok = 0;
                                    double totalSisaBunga = 0;
                                    for (int i = 0; i < listSisaPinjaman.size(); i++) {
                                        ReportKredit reportKredit = (ReportKredit) listSisaPinjaman.get(i);
                                        totalPinjaman += reportKredit.getJmlKredit();
                                        totalDP += reportKredit.getJmlDp();
                                        totalAngsuran += reportKredit.getAngsuran();
                                        totalSisaBunga += reportKredit.getSisaBunga();
                                        totalSisaPokok += reportKredit.getSisaPokok();
                                %>

                                <tr>
                                    <td style="min-width: 50px; max-width: 50px;"><%= (i+1) %>.</td>
                                    <td style="min-width: 100px; max-width: 100px;"><%= reportKredit.getNoPk() %></td>
                                    <td style="min-width: 250px; max-width: 250px;"><%= reportKredit.getNamaKonsumen()%></td>
                                    <td style="min-width: 100px; max-width: 100px;" class="money text-right"><%= reportKredit.getJmlKredit() %></td>
                                    <td style="min-width: 100px; max-width: 100px;" class="money text-right"><%= reportKredit.getJmlDp()%></td>
                                    <td style="min-width: 50px; max-width: 50px;" class="text-center"><%= reportKredit.getJangkaWaktu()%></td>
                                    <%
                                      if(useForRaditya.equals("1")){
                                      %>
                                    <td style="min-width: 100px; max-width: 100px;" class="text-center"><%= reportKredit.getCabang()%></td>
                                    <td style="min-width: 100px; max-width: 100px;" class="text-center"><%= reportKredit.getNamaKolektor()%></td>
                                    <td style="min-width: 100px; max-width: 100px;" class="text-center"><%= reportKredit.getTglRealisasi()%></td>
                                    <td style="min-width: 100px; max-width: 100px;" class="text-center"><%= reportKredit.getJatuhTempo()%></td>
                                    <%
                                    }
                                    %>
                                
                                    <td style="min-width: 100px; max-width: 100px;" class="money text-right"><%=reportKredit.getAngsuran()  %></td>
                                    <td style="min-width: 100px; max-width: 100px;" class="money text-right"><%= reportKredit.getSisaPokok() %></td>
                                    <td style="min-width: 100px; max-width: 100px;" class="money text-right"><%= reportKredit.getSisaBunga() %></td>
                                    <td style="min-width: 100px; max-width: 100px;" class="money text-right"><%= (reportKredit.getSisaBunga()+reportKredit.getSisaPokok()) %></td>
                                    <td style="min-width: 10px; max-width: 10px;">&nbsp;</td>
                                </tr>

                                <% } %>

                                <tr>
                                    <td colspan="3" class="text-right text-bold">Total :</td>
                                    <td class="money text-right text-bold"><%= totalPinjaman %></td>
                                    <td class="money text-right text-bold"><%= totalDP %></td>
                                    <td colspan="5"></td>
                                    <td class="money text-right text-bold"><%= totalAngsuran %></td>
                                    <td class="money text-right text-bold"><%= totalSisaPokok %></td>
                                    <td class="money text-right text-bold"><%= totalSisaBunga %></td>
                                    <td class="money text-right text-bold"><%= (totalSisaBunga + totalSisaPokok) %></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <%}%>
            </section>
        </div>
        
        <div id="tableExport" style="display:  none">
            
        </div>        
            
        <print-area style="size: A5">
            <div style="width: 50%; float: left;">
                <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
                <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                <span style="width: 100%; display: inline-block;"><%=compPhone%></span>                    
            </div>
            <div style="width: 50%; float: right; text-align: right">                    
                <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">DAFTAR SISA / TUNGGAKAN ANGSURAN</span>
                <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal : <%=Formater.formatDate(new Date(), "dd MMM yyyy / HH:mm:ss")%></span>                    
                <span style="width: 100%; display: inline-block; font-size: 12px;">Admin : <%=userName%></span>                    
            </div>
            <div class="clearfix"></div>
            <hr class="" style="border-color: gray">  
            <label>Informasi Sisa Kredit</label>
            
        </print-area>

    </body>
</html>
