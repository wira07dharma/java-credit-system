<%-- 
    Document   : sisa_pinjaman
    Created on : Aug 7, 2017, 2:20:37 PM
    Author     : Dimata 007
--%>

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
            addSql += " AND c." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " IN (" + idNasabah + ")";
        }
    }
    if (!ktp.equals("")) {
        addSql += " AND c." + PstAnggota.fieldNames[PstAnggota.FLD_ID_CARD] + " = '" + ktp + "'";
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
        String order = "p." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT];
        listSisaPinjaman = SessReportKredit.listSisaPinjaman(where + addSql + group, order);
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
                            <%--<div class="form-group">
                                <!--input type="text" class="form-control input-sm" placeholder="Bulan"-->
                                <select style="width: 100%" required="" class="form-control input-sm" name="month_value" id="month_value">
                                    <option style="padding: 5px" value="">- Bulan -</option>
                                    <option style="padding: 5px" value="1">Januari</option>
                                    <option style="padding: 5px" value="2">Februari</option>
                                    <option style="padding: 5px" value="3">Maret</option>
                                    <option style="padding: 5px" value="4">April</option>
                                    <option style="padding: 5px" value="5">Mei</option>
                                    <option style="padding: 5px" value="6">Juni</option>
                                    <option style="padding: 5px" value="7">Juli</option>
                                    <option style="padding: 5px" value="8">Agustus</option>
                                    <option style="padding: 5px" value="9">September</option>
                                    <option style="padding: 5px" value="10">Oktober</option>
                                    <option style="padding: 5px" value="11">November</option>
                                    <option style="padding: 5px" value="12">Desember</option>
                                </select>
                            </div>
                            &nbsp;
                            <div class="form-group">
                                <select style="width: 100%" required="" class="form-control input-sm" name="year_value" id="year_value">
                                    <option style="padding: 5px" value="">- Tahun -</option>
                                    <%
                                        Vector listTahun = SessReportKredit.listPerTahun(0, 0, "", "");
                                        for (int i = 0; i < listTahun.size(); i++) {
                                    %>
                                    <option style="padding: 5px" value="<%=(Integer) listTahun.get(i)%>"><%=(Integer) listTahun.get(i)%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            &nbsp;--%>
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

                            <% if (iCommand == Command.LIST && listSisaPinjaman.size() > 0) {%>
                            <div class="form-group pull-right">
                                <button type="button" class="btn btn-sm btn-primary" id="btn-print"><i class="fa fa-print"></i> &nbsp; Cetak</button>
                            </div>
                            <%}%>
                        </form>
                    </div>

                </div>

                <% if (iCommand == Command.LIST) {%>

                <div class="box box-success">
                    <div class="">
                        <h4 class="text-center"><strong>Informasi Sisa Kredit</strong></h4>                    
                    </div>
                    <div class="box-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped table-hover" style="font-size: 14px">
                                <%--
                                <tr>
                                    <th rowspan="3">No.</th>
                                    <th rowspan="3">Nomor Kredit</th>
                                    <th rowspan="3">Nama Nasabah</th>
                                    <th rowspan="3">Tanggal Jatuh Tempo</th>
                                    <th rowspan="3">Pokok Pinjaman</th>
                                    <th rowspan="3">Suku Bunga</th>
                                    <th rowspan="3">Jangka Waktu</th>
                                    <th colspan="7"><%=bulan[month]%>&nbsp;<%=year%></th>
                                </tr>
                                <tr>
                                    <th colspan="2">Angsuran</th>
                                    <th colspan="2">Sisa Pokok</th>
                                    <th colspan="3">Tunggakan</th>
                                </tr>
                                <tr>
                                    <th>Pokok</th>
                                    <th>Bunga</th>
                                    <th>Bulan Lalu</th>
                                    <th>Bulan Ini</th>
                                    <th>Pokok</th>
                                    <th>Bunga</th>
                                    <th>Sejak</th>
                                </tr>
                                <%
                                    double totJumlahPinjaman = 0;
                                    double totPokok = 0;
                                    double totBunga = 0;
                                    double totSisaPokokSebelum = 0;
                                    double totSisaPokok = 0;
                                    double totTunggakanPokok = 0;
                                    double totTunggakanBunga = 0;
                                    for (int i = 0; i < listPinjaman.size(); i++) {
                                        Anggota a = new Anggota();
                                        Pinjaman p = new Pinjaman();
                                        try {
                                            p = PstPinjaman.fetchExc(listPinjaman.get(i).getPinjamanId());
                                            a = PstAnggota.fetchExc(p.getAnggotaId());
                                        } catch (Exception exc) {
                                        }
                                        String gender[] = {"L", "P"};
                                        Date parameter = new Date();
                                        Calendar calParameter = Calendar.getInstance();
                                        calParameter.setTime(parameter);
                                        calParameter.set(Calendar.MONTH, month - 1);
                                        calParameter.set(Calendar.YEAR, year);
                                        String dateParameter = Formater.formatDate(calParameter.getTime(), "yyyy-MM-dd");
                                        calParameter.add(Calendar.MONTH, - 1);
                                        String dateParameterSebelum = Formater.formatDate(calParameter.getTime(), "yyyy-MM-dd");
                                        //==============================================================================================                                        
                                        long idPinjaman = p.getOID();
                                        //cari nilai pokok dan bunga sesuai tanggal input
                                        Vector<JadwalAngsuran> listAngsuran = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                                                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " <= '" + dateParameter + "'", "");
                                        //cari nilai pokok dan bunga bulan sebelum tanggal input
                                        Vector<JadwalAngsuran> listAngsuranSebelum = PstJadwalAngsuran.list(0, 0, "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                                                + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " <= '" + dateParameterSebelum + "'", "");
                                        //set nilai pokok dan bunga
                                        double pokok = 0;
                                        double pokokDibayar = 0;
                                        double bunga = 0;
                                        double bungaDibayar = 0;
                                        //cari total angsuran yg harus dibayar
                                        double totalPokok = SessReportKredit.getSumAngsuranHarusDibayar("jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                                                + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + "'");
                                        double totalBunga = SessReportKredit.getSumAngsuranHarusDibayar("jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                                                + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + "'");

                                        for (int j = 0; j < listAngsuran.size(); j++) {
                                            long idJadwalAngsuran = listAngsuran.get(j).getOID();
                                            if (listAngsuran.get(j).getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK) {
                                                pokok = listAngsuran.get(j).getJumlahANgsuran();
                                                //cari nilai pokok yg sudah dibayar
                                                pokokDibayar += SessReportKredit.getSumAngsuranDibayar(idJadwalAngsuran);
                                            } else if (listAngsuran.get(j).getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_BUNGA) {
                                                bunga = listAngsuran.get(j).getJumlahANgsuran();
                                                //cari nilai bunga yg sudah dibayar
                                                bungaDibayar += SessReportKredit.getSumAngsuranDibayar(idJadwalAngsuran);
                                            }
                                        }
                                        double pokokSebelum = 0;
                                        double pokokDibayarSebelum = 0;
                                        for (int j = 0; j < listAngsuranSebelum.size(); j++) {
                                            long idAngsuran = listAngsuranSebelum.get(j).getOID();
                                            if (listAngsuranSebelum.get(j).getJenisAngsuran() == 0) {
                                                pokokSebelum = listAngsuranSebelum.get(j).getJumlahANgsuran();
                                                //cari nilai pokok yg sudah dibayar
                                                pokokDibayarSebelum += SessReportKredit.getSumAngsuranDibayar(idAngsuran);
                                            }
                                        }
                                        //cari sisa angsuran
                                        double sisaPokok = totalPokok - pokokDibayar;
                                        double sisaBunga = totalBunga - bungaDibayar;
                                        double sisaPokokSebelum = 0;
                                        if (!listAngsuranSebelum.isEmpty()) {
                                            sisaPokokSebelum = totalPokok - pokokDibayarSebelum;
                                        }
                                        //==========================================================================                                        
                                        //cari tunggakan pokok                                        
                                        double tunggakanPokok = 0;
                                        Date tglAwalAngsuranPokok = null;
                                        Vector listTunggakanPokok = SessReportKredit.listJoinTunggakan(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK, dateParameter);
                                        for (int k = 0; k < listTunggakanPokok.size(); k++) {
                                            Angsuran angsuran = (Angsuran) listTunggakanPokok.get(k);
                                            if (angsuran.getOID() == 0) {
                                                tunggakanPokok += pokok;
                                                //get bulan awal tuggakan
                                                if (tglAwalAngsuranPokok == null) {
                                                    tglAwalAngsuranPokok = angsuran.getTunggakanBulanAwal();
                                                } else {
                                                    if (tglAwalAngsuranPokok.after(angsuran.getTunggakanBulanAwal())) {
                                                        tglAwalAngsuranPokok = angsuran.getTunggakanBulanAwal();
                                                    }
                                                }
                                            } else {
                                                if (angsuran.getJumlahAngsuran() < pokok) {
                                                    tunggakanPokok += (pokok - angsuran.getTotalDibayar());
                                                    //get bulan awal tuggakan
                                                    if (tglAwalAngsuranPokok == null) {
                                                        tglAwalAngsuranPokok = angsuran.getTunggakanBulanAwal();
                                                    } else {
                                                        if (tglAwalAngsuranPokok.after(angsuran.getTunggakanBulanAwal())) {
                                                            tglAwalAngsuranPokok = angsuran.getTunggakanBulanAwal();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        //cari tunggakan bunga
                                        double tunggakanBunga = 0;
                                        Date tglAwalAngsuranBunga = null;
                                        Vector listTunggakanBunga = SessReportKredit.listJoinTunggakan(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA, dateParameter);
                                        for (int k = 0; k < listTunggakanBunga.size(); k++) {
                                            Angsuran angsuran = (Angsuran) listTunggakanBunga.get(k);
                                            if (angsuran.getOID() == 0) {
                                                tunggakanBunga += bunga;
                                                //get bulan awal tuggakan
                                                if (tglAwalAngsuranBunga == null) {
                                                    tglAwalAngsuranBunga = angsuran.getTunggakanBulanAwal();
                                                } else {
                                                    if (tglAwalAngsuranBunga.after(angsuran.getTunggakanBulanAwal())) {
                                                        tglAwalAngsuranBunga = angsuran.getTunggakanBulanAwal();
                                                    }
                                                }
                                            } else {
                                                if (angsuran.getJumlahAngsuran() < bunga) {
                                                    tunggakanBunga += (bunga - angsuran.getTotalDibayar());
                                                    //get bulan awal tuggakan
                                                    if (tglAwalAngsuranBunga == null) {
                                                        tglAwalAngsuranBunga = angsuran.getTunggakanBulanAwal();
                                                    } else {
                                                        if (tglAwalAngsuranBunga.after(angsuran.getTunggakanBulanAwal())) {
                                                            tglAwalAngsuranBunga = angsuran.getTunggakanBulanAwal();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        //==========================================================================
                                        //cari bulan awal tunggakan
                                        int bulanAwal = 0;
                                        int tahunAwal = 0;
                                        int bulanPokok = 100;
                                        int tahunPokok = 0;
                                        int bulanBunga = 100;
                                        int tahunBunga = 0;
                                        if (tglAwalAngsuranPokok != null) {
                                            Calendar calPokok = Calendar.getInstance();
                                            calPokok.setTime(tglAwalAngsuranPokok);
                                            bulanPokok = calPokok.get(Calendar.MONTH) + 1;
                                            tahunPokok = calPokok.get(Calendar.YEAR);
                                        }
                                        if (tglAwalAngsuranBunga != null) {
                                            Calendar calBunga = Calendar.getInstance();
                                            calBunga.setTime(tglAwalAngsuranBunga);
                                            bulanBunga = calBunga.get(Calendar.MONTH) + 1;
                                            tahunBunga = calBunga.get(Calendar.YEAR);
                                        }
                                        String bulanTunggakan = "";
                                        if (bulanPokok == 100 && bulanBunga == 100) {
                                            bulanTunggakan = "-";
                                        } else if (bulanPokok < bulanBunga) {
                                            bulanAwal = bulanPokok;
                                            tahunAwal = tahunPokok;
                                            bulanTunggakan = "" + bulanPendek[bulanAwal] + "/" + tahunAwal;
                                        } else {
                                            bulanAwal = bulanBunga;
                                            tahunAwal = tahunBunga;
                                            bulanTunggakan = "" + bulanPendek[bulanAwal] + "/" + tahunAwal;
                                        }

                                        totJumlahPinjaman = totJumlahPinjaman + p.getJumlahPinjaman();
                                        totPokok = totPokok + pokok;
                                        totBunga = totBunga + bunga;
                                        totSisaPokokSebelum = totSisaPokokSebelum + sisaPokokSebelum;
                                        totSisaPokok = totSisaPokok + sisaPokok;
                                        totTunggakanPokok = totTunggakanPokok + tunggakanPokok;
                                        totTunggakanBunga = totTunggakanBunga + tunggakanBunga;
                                %>
                                <tr>
                                    <td><%=(i + 1)%></td>
                                    <td><%=p.getNoKredit()%></td>
                                    <td><%=a.getName()%></td>
                                    <td><%=p.getJatuhTempo()%></td>
                                    <td class="money text-right"><%=p.getJumlahPinjaman()%></td>
                                    <td class="text-right"><span class="money"><%=p.getSukuBunga()%></span>&nbsp;%</td>
                                    <td><%=p.getJangkaWaktu()%>&nbsp;Bulan</td>
                                    <td class="money text-right"><%=pokok%></td>
                                    <td class="money text-right"><%=bunga%></td>
                                    <td class="money text-right"><%=sisaPokokSebelum%></td>
                                    <td class="money text-right"><%=sisaPokok%></td>
                                    <td class="money text-right"><%=tunggakanPokok%></td>
                                    <td class="money text-right"><%=tunggakanBunga%></td>
                                    <td style="text-align: center"><%=bulanTunggakan%></td>
                                </tr>
                                <%
                                        listValue = new ArrayList<String>();
                                        listValue.add("" + (i + 1));//0
                                        listValue.add("" + p.getNoKredit());//1
                                        listValue.add("" + a.getName());//2
                                        listValue.add("" + p.getJatuhTempo());//3
                                        listValue.add("" + p.getJumlahPinjaman());//4
                                        listValue.add("" + p.getSukuBunga());//5
                                        listValue.add("" + p.getJangkaWaktu());//6
                                        listValue.add("" + pokok);//7
                                        listValue.add("" + bunga);//8
                                        listValue.add("" + sisaPokokSebelum);//9
                                        listValue.add("" + sisaPokok);//10
                                        listValue.add("" + tunggakanPokok);//11
                                        listValue.add("" + tunggakanBunga);//12
                                        listValue.add("" + bulanTunggakan);//13
                                        listRow.add(listValue);
                                    }
                                %>
                                <tr>
                                    <td colspan="4" style="text-align: right;"><strong>Total</strong></td>
                                    <td class="money text-right"><%=totJumlahPinjaman%></td>
                                    <td style="text-align: center">-</td>
                                    <td style="text-align: center">-</td>
                                    <td class="money text-right"><%=totPokok%></td>
                                    <td class="money text-right"><%=totBunga%></td>
                                    <td class="money text-right"><%=totSisaPokokSebelum%></td>
                                    <td class="money text-right"><%=totSisaPokok%></td>
                                    <td class="money text-right"><%=totTunggakanPokok%></td>
                                    <td class="money text-right"><%=totTunggakanBunga%></td>
                                    <td style="text-align: center">-</td>
                                </tr>
                                --%>

                                <tr>
                                    <th style="width: 1%">No.</th>
                                    <th>Nomor Kredit</th>
                                    <th>Nama <%=namaNasabah%></th>
                                    <th>Jumlah Kredit</th>
                                    <th>Jangka Waktu</th>
                                    <%
                                      if(useForRaditya.equals("1")){
                                      %>
                                    <th>Lokasi Transaksi</th>
                                    <th>Kolektor</th>
                                    <th>Tanggal Realisasi</th>
                                    <th>Jatuh Tempo</th>
                                    <%
                                      }
                                      %>
                                    <th>Angsuran</th>
                                    <th>Sisa Pokok</th>
                                    <th>Sisa Bunga</th>
                                </tr>

                                <%
                                    double totalPinjaman = 0;
                                    double totalSisaPokok = 0;
                                    double totalSisaBunga = 0;
                                    for (int i = 0; i < listSisaPinjaman.size(); i++) {
                                        Vector v = (Vector) listSisaPinjaman.get(i);
                                        Pinjaman p = (Pinjaman) v.get(0);
                                        Anggota a = (Anggota) v.get(1);
                                        //ContactList con = new ContactList();
                                        Employee kol = new Employee();
										BillMain bm = new BillMain();
                                        Location loc = new Location();
                                        try {
                                            kol = PstEmployee.fetchFromApi(p.getCollectorId());
                                            bm = PstBillMain.fetchExc(p.getBillMainId());
                                            loc = PstLocation.fetchExc(bm.getLocationId());
                                          } catch (Exception e) {
                                          }
                                        double totalPokok = SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                                        double pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                                        double sisaPokok = totalPokok - pokokDibayar;
                                        double totalBunga = SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                                        double bungaDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                                        double sisaBunga = totalBunga - bungaDibayar;
                                        totalPinjaman += p.getJumlahPinjaman();
                                        totalSisaPokok += sisaPokok;
                                        totalSisaBunga += sisaBunga;
                                        int roundValue = 500;
                                        double angsuran = (Math.floor((p.getJumlahPinjaman() / p.getJangkaWaktu() + (roundValue - 1)) / roundValue)) * roundValue;

                                %>

                                <tr>
                                    <td><%= (i+1) %>.</td>
                                    <td><%= p.getNoKredit() %></td>
                                    <td><%= a.getName() %></td>
                                    <td class="money text-right"><%= p.getJumlahPinjaman() %></td>
                                    <td class="text-center"><%= p.getJangkaWaktu()%></td>
                                    <%
                                      if(useForRaditya.equals("1")){
                                      %>
                                    <td class="text-center"><%= loc.getName()%></td>
                                    <td class="text-center"><%= kol.getFullName() %></td>
                                    <td class="text-center"><%= p.getTglRealisasi()%></td>
                                    <td class="text-center"><%= p.getJatuhTempo()%></td>
                                    <%
                                    }
                                    %>
                                
                                    <td class="money text-right"><%= p.getSukuBunga() %></td>
                                    <td class="money text-right"><%=angsuran  %></td>
                                    <td class="money text-right"><%= sisaPokok %></td>
                                    <td class="money text-right"><%= sisaBunga %></td>
                                </tr>

                                <% } %>

                                <tr>
                                    <td colspan="3" class="text-right text-bold">Total :</td>
                                    <td class="money text-right text-bold"><%= totalPinjaman %></td>
                                    <td colspan="7"></td>
                                    <td class="money text-right text-bold"><%= totalSisaPokok %></td>
                                    <td class="money text-right text-bold"><%= totalSisaBunga %></td>
                                </tr>

                            </table>
                        </div>
                    </div>
                </div>

                <%}%>
            </section>
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
            <label>Informasi Sisa Pinjaman</label>
            <table class="table table-bordered" style="font-size: 10px">
                <%--
                <thead>
                    <tr>
                        <th rowspan="3">No.</th>
                        <th rowspan="3">Nomor Kredit</th>
                        <th rowspan="3">Nama Nasabah</th>
                        <th rowspan="3">Tanggal Jatuh Tempo</th>
                        <th rowspan="3">Pokok Pinjaman</th>
                        <th rowspan="3">Suku Bunga</th>
                        <th rowspan="3">Jangka Waktu (Bulan)</th>
                        <th colspan="7"><%=bulan[month]%>&nbsp;<%=year%></th>
                    </tr>
                    <tr>
                        <th colspan="2">Angsuran</th>
                        <th colspan="2">Sisa Pokok</th>
                        <th colspan="3">Tunggakan</th>
                    </tr>
                    <tr>
                        <th>Pokok</th>
                        <th>Bunga</th>
                        <th>Bulan Lalu</th>
                        <th>Bulan Ini</th>
                        <th>Pokok</th>
                        <th>Bunga</th>
                        <th>Sejak</th>
                    </tr>
                </thead>
                <tbody>
                    <% double[] totalValue = new double[listValue.size()];
                        for (int row = 0; row < listRow.size(); row++) {
                            
                            
                    %>
                    <tr>
                        <% for (int value = 0; value < listValue.size(); value++) {
                                String print = listRow.get(row).get(value); %>

                        <%if (value == 4 || value == 5 || value == 7 || value == 8 || value == 9 || value == 10 || value == 11 || value == 12) {
                            try {
                                totalValue[value] = totalValue[value] + Double.valueOf(print);
                            } catch (Exception exc){}
                        %>
                        <td class="money"><%=print%></td>                        
                        <%} else if (value == 13) {%>
                        <td style="text-align: center"><%=print%></td>                        
                        <%} else {%>
                        <td><%=print%></td>
                        <%}%>

                        <%}%>
                    </tr>
                        <%}%>
                    
                    <tr>
                        <% for (int value = 0; value < listValue.size(); value++) { %>
                            <%if (value == 4 || value == 5 || value == 7 || value == 8 || value == 9 || value == 10 || value == 11 || value == 12) {%>
                            <td class="money"><%=totalValue[value]%></td>                        
                            <%} else if (value == 13) {%>
                            <td style="text-align: center"></td>                        
                            <%} else if (value == 0){%>
                            <td colspan="4" style="text-align: right;"><strong>Total</strong></td>
                            <%} else if (value == 1 ||value == 2 || value == 3){%>
                            <%} else {%>
                            <td style="text-align: center"></td>
                            <%}%>
                        <%}%>
                    </tr>
                </tbody>
                --%>
                
                <tr>
                    <th style="width: 1%">No.</th>
                    <th>Nomor Kredit</th>
                    <th>Nama <%=namaNasabah%></th>
                    <th>Jumlah Pinjaman</th>
                    <th>Jangka Waktu</th>
                    <%
                      if(useForRaditya.equals("1")){
                      %>
                    <th>Lokasi Transaksi</th>
                    <th>Kolektor</th>
                    <th>Tanggal Realisasi</th>
                    <th>Jatuh Tempo</th>
                    <%
                      }
                      %>
                    <th>Bunga / Thn</th>
                    <th>Angsuran Pokok</th>
                    <th>Sisa Pokok</th>
                    <th>Sisa Bunga</th>
                </tr>

                <%
                    double totalPinjaman = 0;
                    double totalSisaPokok = 0;
                    double totalSisaBunga = 0;
                    for (int i = 0; i < listSisaPinjaman.size(); i++) {
                        Vector v = (Vector) listSisaPinjaman.get(i);
                        Pinjaman p = (Pinjaman) v.get(0);
                        Anggota a = (Anggota) v.get(1);
                        ContactList con = new ContactList();
                        BillMain bm = new BillMain();
                        Location loc = new Location();
                        try {
                            con = PstContactList.fetchExc(p.getCollectorId());
                            bm = PstBillMain.fetchExc(p.getBillMainId());
                            loc = PstLocation.fetchExc(bm.getLocationId());
                          } catch (Exception e) {
                          }
                        double totalPokok = SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                        double pokokDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                        double sisaPokok = totalPokok - pokokDibayar;
                        double totalBunga = SessReportKredit.getTotalAngsuran(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                        double bungaDibayar = SessReportKredit.getTotalAngsuranDibayar(p.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                        double sisaBunga = totalBunga - bungaDibayar;
                        totalPinjaman += p.getJumlahPinjaman();
                        totalSisaPokok += sisaPokok;
                        totalSisaBunga += sisaBunga;
                %>
                
                <tr>
                    <td><%= (i+1) %>.</td>
                    <td><%= p.getNoKredit() %></td>
                    <td><%= a.getName() %></td>
                    <td class="money text-right"><%= p.getJumlahPinjaman() %></td>
                    <td class="text-center"><%= p.getJangkaWaktu()%></td>
                    <%
                      if(useForRaditya.equals("1")){
                      %>
                    <td class="text-center"><%= loc.getName()%></td>
                    <td class="text-center"><%= con.getPersonName() %></td>
                    <td class="text-center"><%= p.getTglRealisasi()%></td>
                    <td class="text-center"><%= p.getJatuhTempo()%></td>
                    <%
                    }
                    %>
                    <td class="money text-right"><%= p.getSukuBunga() %></td>
                    <td class="money text-right"><%= p.getJumlahPinjaman() / p.getJangkaWaktu() %></td>
                    <td class="money text-right"><%= sisaPokok %></td>
                    <td class="money text-right"><%= sisaBunga %></td>
                </tr>

                <% } %>

                <tr>
                    <td colspan="3" class="text-right text-bold">Total :</td>
                    <td class="money text-right text-bold"><%= totalPinjaman %></td>
                    <td colspan="7"></td>
                    <td class="money text-right text-bold"><%= totalSisaPokok %></td>
                    <td class="money text-right text-bold"><%= totalSisaBunga %></td>
                </tr>
            </table>
        </print-area>

    </body>
</html>
