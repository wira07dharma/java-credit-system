
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.ajax.transaksi.extensible.HTTPTabungan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.form.tabungan.FrmDataTabungan"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
<%@page import="com.dimata.sedana.entity.masterdata.AssignContact"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstAssignContact"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DetailTransaksi"%>
<%@page import="com.dimata.sedana.ajax.transaksi.AjaxSetoran"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.searchtabungan.SearchTabungan"%>
<%@page import="com.dimata.sedana.form.searchtabungan.FrmSearchTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="java.io.Console"%>
<%@page language="java" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package aiso -->
<%@page import="com.dimata.aiso.entity.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.form.masterdata.anggota.*" %>
<%@page import="com.dimata.aiso.entity.masterdata.transaksi.*" %>
<%@page import="com.dimata.aiso.form.masterdata.transaksi.*"%>

<%@include file="../main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "../main/checkuser.jsp" %>

<%!
    public static final String textListHeader[][]
            = {
                {"No.", "Nama Jasa", "Aksi", "Periode"},
                {"Number", "Service", "Action", "Period"}
            };

%>
<%  Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
    if (open.size() < 1) {%>
<script> window.location.replace("<%=approot + "/tellershift/open_teller_shift.jsp?redir=" + approot + "/masterdata/services.jsp"%>");</script>
<%}%>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
    boolean privPrint = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));

    long tellerShiftId = 0;
    int iCommand = FRMQueryString.requestCommand(request);
    if (userOID != 0) {
        if (open.size() < 1) {%>
<script> window.location.replace("<%=approot + "/tellershift/open_teller_shift.jsp?redir=" + approot + "/masterdata/services.jsp"%>");</script>
<%} else {
            tellerShiftId = open.get(0).getOID();
        }
    }
    String now = Formater.formatDate(new Date(), "yyyy-MM-dd");
    long idTransaksi = FRMQueryString.requestLong(request, "id_transaksi");
    String tglTransaksi = FRMQueryString.requestString(request, "tgl");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>SEDANA</title>
        <%@ include file = "/style/lte_head.jsp" %>
        <script>
            var msg = "<%=(request.getAttribute("message") != null ? request.getAttribute("message") : "")%>";
            (!msg) || alert(msg);
        </script>
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

                $('.btn-generate').click(function () {
                    var buttonName = $(this).html();
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...");
                    var tipe = $(this).data("tipeangsuran");
                    var generate = 0;
                    if (tipe == <%= JadwalAngsuran.TIPE_ANGSURAN_DENDA%>) {
                        if ($('#generateNewDenda').is(":checked")) {
                            generate = 1;
                        }
                    } else if (tipe == <%= JadwalAngsuran.TIPE_ANGSURAN_BUNGA_TAMBAHAN%>) {
                        if ($('#generateNewBunga').is(":checked")) {
                            generate = 1;
                        }
                    }
                    var dataSend = {
                        "FRM_FIELD_DATA_FOR": "cekDendaKredit",
                        "SEND_OID_TELLER_SHIFT": "<%=tellerShiftId%>",
                        "command": "<%=Command.SAVE%>",
                        "SEND_RANGE_AWAL": $('#tglawal').val(),
                        "SEND_RANGE_AKHIR": $('#tglakhir').val(),
                        "GENERATE_NEW_DENDA": generate,
                        "TIPE_ANGSURAN": tipe
                    };
                    onDone = function (data) {
                        var msg = data.RETURN_MESSAGE;
                        $("body #hrow").show();
                        $('#infokredit').html(msg);
                        $('#datakredit').html(data.FRM_FIELD_HTML);
                        $('#datakredit').find('.money').each(function () {
                            jMoney(this);
                        });
                        $('#namaNasabah').append("<%=namaNasabah%>");
                    };
                    onSuccess = function (data) {
                        $('.btn-generate').removeAttr('disabled').html(buttonName);
                        $("body .proses").html("Kalkulasi");
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
                    return false;
                });

                $('.btn_print').click(function () {
                    $(this).attr({"disabled": true}).html('<i class="fa fa-spinner fa-pulse"></i>&nbsp; Tunggu...');
                });

                $('#btnGenerateBungaKredit').click(function () {
                    var buttonName = $(this).html();
                    var dataSend = {
                        "FRM_FIELD_DATA_FOR": "generateBungaKreditUntilNow",
                        "SEND_OID_TELLER_SHIFT": "<%=tellerShiftId%>",
                        "command": "<%=Command.SAVE%>"
                    };
                    onDone = function (data) {
                        alert(data.RETURN_MESSAGE);
                    };
                    onSuccess = function (data) {
                        $('#btnGenerateBungaKredit').removeAttr('disabled').html(buttonName);
                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    return false;
                });

                $('#btnDepositoTerakhir').click(function () {
                    var buttonName = $(this).html();
                    var period = $('#periodeDeposito').find('option:selected').text();
                    var tab = $('#nomorTabungan').val();
                    var msg = "Yakin akan menambahkan bunga untuk";
                    if (tab === "") {
                        msg += " SEMUA TABUNGAN DEPOSITO";
                    } else {
                        msg += " nomor tabungan '" + tab + "'";
                    }
                    msg += " yang berakhir pada periode " + period + " ?";
                    
                    if (confirm(msg)) {
                        $(this).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...").attr({"disabled": true});
                        var dataSend = {
                            "FRM_FIELD_DATA_FOR": "hitungBungaDepositoTerakhir",
                            "SEND_OID_TELLER_SHIFT": "<%=tellerShiftId%>",
                            "SEND_DATE": $('#periodeDeposito').val(),
                            "SEND_NO_TABUNGAN": $('#nomorTabungan').val(),
                            "SEND_USER_ID": "<%= userOID%>",
                            "SEND_USER_NAME": "<%= userFullName%>",
                            "command": "<%=Command.SAVE%>"
                        };
                        onDone = function (data) {
                            alert(data.RETURN_MESSAGE);
                            location.reload();
                        };
                        onSuccess = function (data) {
                            $('#btnDepositoTerakhir').removeAttr('disabled').html(buttonName);
                        };
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxTabungan", null, false);
                        return false;
                    }
                });

                $('#btnHitungBiayaAdmin').click(function () {
                    var buttonName = $(this).html();
                    var dataSend = {
                        "FRM_FIELD_DATA_FOR": "hitungBiayaAdmin",
                        "SEND_OID_TELLER_SHIFT": "<%=tellerShiftId%>",
                        "SEND_DATE": $('#periodeBiayaAdmin').val(),
                        "SEND_USER_ID": "<%= userOID%>",
                        "SEND_USER_NAME": "<%= userFullName%>",
                        "command": "<%=Command.SAVE%>"
                    };
                    onDone = function (data) {
                        alert(data.RETURN_MESSAGE);
                    };
                    onSuccess = function (data) {
                        $('#btnHitungBiayaAdmin').removeAttr('disabled').html(buttonName);
                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxTabungan", null, false);
                    return false;
                });

                function getDataBunga(date, id) {
                    var dataSend = {
                        "FRM_FIELD_DATA_FOR": "getDataBunga",
                        "SEND_DATE": date,
                        "command": "<%=Command.NONE%>"
                    };
                    onDone = function (data) {
                        $("#" + id).html(data.FRM_FIELD_HTML);
                        $("#" + id).find(".money").each(function () {
                            jMoney(this);
                        });
                    };
                    onSuccess = function (data) {
                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxTabungan", null, false);
                    return date;
                }

                $("a.itam").click(function () {
                    var hidden = $(this).find("table.n").attr("data-hidden");
                    $("body .itam table.n").hide();
                    $("body .itam table.n").attr("data-hidden", "true");
                    if (hidden === "true") {
                        $(this).find("table.n").show();
                        $(this).find("table.n").attr("data-hidden", "false");

                        //updated by dewok 2019-05-07
                        var date = $(this).data('date');
                        var id = $(this).data('id');
                        $(this).find("table.n tbody").html("<tr><td colspan='6'><div class='progress'><div class='progress-bar progress-bar-striped active' style='width:100%'>Tunggu...</div></div></td></tr>");
                        getDataBunga(date, id);
                    }
                });
                
                $("body .proses").click(function () {
                    $(this).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...").attr({"disabled": true});
                });
                
            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <!-- Content Header (Page header) -->
            <section class="content-header">
                <h1>
                    <%=(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Services " : "Jasa ")%>
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Master Bumdesa</li>
                    <li class="active"><%=(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Services " : "Jasa ")%></li>
                </ol>
            </section>

            <!-- Main content -->
            <section class="content">
                <div class="row">
                    <div class="col-xs-12">
                        <!-- Horizontal Form -->
                        <div class="box box-success">
                            <div class="box-header with-border">
                                <h3 class="box-title"><%=(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "List of Service " : "Daftar Jasa ")%></h3>
                            </div>
                            <div class="box-body">
                                <style>thead.thead-light{ background-color: #f5f5f5; }</style>
                                <div id="form_generate">
                                    <style>
                                        .tabel_jasa tbody tr td {vertical-align: middle}
                                    </style>
                                    <table class="table table-bordered tabel_jasa" style="margin-bottom: 0px">
                                        <thead class="thead-light">
                                            <tr>
                                                <th><%=textListHeader[SESS_LANGUAGE][1]%></th>
                                                <th><%=textListHeader[SESS_LANGUAGE][3]%></th>
                                                <th><%=textListHeader[SESS_LANGUAGE][2]%></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% if(useRaditya == 0){ %>
                                            <tr>
                                                <td>Bunga Tabungan</td>
                                                <td>
                                                    <select id="select-period" class="form-control">
                                                        <% Calendar c = Calendar.getInstance(); %>
                                                        <% for (int i = 0; i < 12; i++) {%>
                                                        <option <%=(i == 0 ? "selected" : "")%> data-month="<%=Formater.formatDate(c.getTime(), "M")%>" data-year="<%=Formater.formatDate(c.getTime(), "YYYY")%>"><%=Formater.formatDate(c.getTime(), "MMM YYYY")%></option>
                                                        <% c.add(Calendar.MONTH, -1); %>
                                                        <% }%>
                                                    </select>
                                                    <script>
                                                        var url = "<%=approot%>/count_bunga.jsp";
                                                        $(window).load(function () {
                                                            $("#kkk").attr("href", url);

                                                            function createUrl() {
                                                                var month = $("#select-period").find("option:selected").data("month");
                                                                var year = $("#select-period").find("option:selected").data("year");
                                                                var check = $("#includeZero").is(':checked');
                                                                $("#kkk").attr("href", url + "?month=" + month + "&year=" + year + "&include=" + check);
                                                            }

                                                            $("#select-period").change(function () {
                                                                createUrl();
                                                            });

                                                            $("#includeZero").click(function () {
                                                                createUrl();
                                                            });

                                                            $("#kkk").click(function () {
                                                                createUrl();
                                                            });
                                                        });
                                                    </script>
                                                </td>
                                                <td>
                                                    <a id="kkk" class="proses btn btn-success">Kalkulasi</a>
                                                    <%--
                                                    &nbsp;
                                                    <div class="checkbox" style="display: inline">
                                                        <label><input type="checkbox" value="1" id="includeZero" style="margin-top: 5px"> Simpan Bunga Rp 0</label>
                                                    </div>
                                                    --%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Bunga Tabungan Terakhir Deposito</td>
                                                <td>
                                                    <div class="input-group">
                                                        <span class="input-group-addon">Periode tutup :</span>
                                                        <select id="periodeDeposito" class="form-control" style="width: 50%">
                                                            <% Calendar calDeposito = Calendar.getInstance(); %>
                                                            <% for (int i = 0; i < 12; i++) {%>
                                                            <option <%=(i == 0 ? "selected" : "")%> value="<%= Formater.formatDate(calDeposito.getTime(), "yyyy-MM-01") %>"><%=Formater.formatDate(calDeposito.getTime(), "MMM YYYY")%></option>
                                                            <% calDeposito.add(Calendar.MONTH, -1); %>
                                                            <% }%>
                                                        </select>
                                                        <input type="text" id="nomorTabungan" autocomplete="off" style="width: 50%; border-left-width: 0px" class="form-control inline" placeholder="Nomor tabungan">
                                                    </div>
                                                </td>
                                                <td>
                                                    <button type="button" id="btnDepositoTerakhir" class="btn btn-success">Kalkulasi</button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Potongan Admin Bulanan</td>
                                                <td>
                                                    <select id="periodeBiayaAdmin" class="form-control">
                                                        <% Calendar cal = Calendar.getInstance(); %>
                                                        <% for (int i = 0; i < 12; i++) {%>
                                                        <option <%=(i == 0 ? "selected" : "")%> value="<%= Formater.formatDate(cal.getTime(), "yyyy-MM-01") %>"><%=Formater.formatDate(cal.getTime(), "MMM YYYY")%></option>
                                                        <% cal.add(Calendar.MONTH, -1); %>
                                                        <% }%>
                                                    </select>
                                                </td>
                                                <td>
                                                    <div class="form-inline">
                                                        <button type="button" id="btnHitungBiayaAdmin" class="proses btn btn-success">Kalkulasi</button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Bunga Kredit Tambahan</td>
                                                <td>Sampai bulan ini</td>
                                                <td>
                                                    <div class="form-inline">
                                                        <button type="button" id="btnGenerateBungaKredit" class="proses btn btn-success" data-tipeangsuran="<%= JadwalAngsuran.TIPE_ANGSURAN_BUNGA_TAMBAHAN%>">Kalkulasi</button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <% } %>
                                            <tr>
                                                <td>Denda Kredit</td>
                                                <td>
                                                    <div class="form-group">
                                                        <input type="text" style="display: inline-block;width:calc(50% - 10px)" onload="" required="" placeholder="Range tanggal awal" id="tglawal" class="form-control date-picker" value="<%=now%>"><span style="display: inline-block;width:18px;text-align: center;">-</span><input type="text" style="display: inline-block;width:calc(50% - 10px)" required="" placeholder="Range tanggal akhir" id="tglakhir" class="form-control date-picker" value="<%=now%>">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="form-inline">
                                                        <button type="button" class="proses btn btn-success btn-generate" data-tipeangsuran="<%= JadwalAngsuran.TIPE_ANGSURAN_DENDA%>">Kalkulasi</button>
                                                        &nbsp;
                                                        <div class="checkbox" title="Centang untuk hitung denda baru">
                                                            <label><input type="checkbox" value="1" id="generateNewDenda" style="display: inline-block"> Denda Baru</label>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-xs-12">
                        <!-- Horizontal Form -->
                        <div class="box box-success">
                            <div class="box-header with-border">
                                <h3 class="box-title"><%=(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Interest History " : "Riwayat Bunga ")%></h3>
                            </div>
                            <div class="box-body">
                                <style>
                                    .list-group-item{cursor: pointer;}
                                    a.list-group-item:hover{background-color:#fbfbfb;}
                                    a.list-group-item:hover > table.n{box-shadow: 0 1px 10px 1px #0000001f;}
                                </style>
                                <%
                                    String whereTS = PstTransaksi.fieldNames[PstTransaksi.FLD_KETERANGAN] + " NOT LIKE '%excel%' AND `USECASE_TYPE` = " + I_Sedana.USECASE_TYPE_TABUNGAN_BUNGA_PENCATATAN;
                                    whereTS += " GROUP BY " + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI];
                                    Vector<Transaksi> ts = PstTransaksi.list(0, 0, whereTS, PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC ");

                                    ArrayList<Transaksi> listBunga = PstTransaksi.getBungaTabunganPerTanggal();
                                    int idData = 0;
                                %>
                                <div class="list-group" style="margin-bottom: 0px">
                                    <% for (Transaksi t : listBunga) {%>
                                    <% idData++;%>
                                    <a class="list-group-item itam" data-id="<%= idData%>" data-date="<%= Formater.formatDate(t.getTanggalTransaksi(), "yyyy-MM-dd HH:mm:ss")%>">
                                        <div class="row" style="margin-bottom: -10px;">
                                            <div class="col-xs-4">
                                                <div><strong>Tanggal</strong></div>
                                                <span style="margin-bottom:10px;display: inline-block;"><%=Formater.formatDate(t.getTanggalTransaksi())%> <%--=Formater.formatDate(t.getTanggalTransaksi(), "HH:mm:ss")--%></span>
                                            </div>
                                            <div class="col-xs-4">
                                                <div><strong>Pemroses</strong></div>
                                                <%
                                                    CashTeller ctel = PstCashTeller.fetchExc(t.getTellerShiftId());
                                                    AppUser u = PstAppUser.fetch(ctel.getAppUserId());
                                                %>
                                                <span style="margin-bottom:10px;display: inline-block;"><%=u.getFullName()%></span>
                                            </div>
                                            <div class="col-xs-4">
                                                <div><strong>Jumlah</strong></div>
                                                <%--<span style="margin-bottom:10px;display: inline-block;"><%=PstDetailTransaksi.getCount(PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = " + t.getOID())%> transaksi</span>--%>
                                                <span style="margin-bottom:10px;display: inline-block;"><%= t.getStatus()%> data</span>
                                            </div>
                                        </div>
                                        <table data-hidden="true" class="table table-hover n" style="background:white !important;display: none;">
                                            <thead class="thead-light">
                                                <tr>
                                                    <th style="width: 1%">No.</th>
                                                    <th>No Tabungan</th>
                                                    <th>Nama</th>
                                                    <th>Jenis Bunga</th>
                                                    <th class="text-right">Bunga</th>
                                                    <th>Info</th>
                                                </tr>
                                            </thead>
                                            <tbody id="<%= idData%>" style="font-size: 14px">
                                                <%--
                                                <%
                                                    Vector<DetailTransaksi> vdt = new Vector();
                                                    try {
                                                        Transaksi transaksi = t;
                                                        vdt = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + "=" + transaksi.getOID(), "");
                                                    } catch (Exception e) {
                                                        System.err.println(e);
                                                    }
                                                    int i = 0;
                                                    double totalBunga = 0;
                                                    for (DetailTransaksi dt : vdt) {
                                                        i++;
                                                        DataTabungan tab = PstDataTabungan.fetchExc(dt.getIdSimpanan());
                                                        ContactList cl = PstContactList.fetchExc(tab.getIdAnggota());
                                                        JenisSimpanan js = PstJenisSimpanan.fetchExc(tab.getIdJenisSimpanan());
                                                        AssignContactTabungan ct = PstAssignContactTabungan.fetchExc(tab.getAssignTabunganId());
                                                        totalBunga += dt.getKredit();
                                                %>
                                                <tr>
                                                    <td><%=i%>.</td>
                                                    <td><%=ct.getNoTabungan()%></td>
                                                    <td><%=cl.getPersonName()%></td>
                                                    <td><%=I_Sedana.BUNGA.get(js.getJenisBunga())[SESS_LANGUAGE]%></td>
                                                    <td class="text-right"><span class="money"><%=dt.getKredit()%></span></td>
                                                    <td><%= dt.getDetailInfo()%></td>
                                                </tr>
                                                <% }%>
                                                <tr>
                                                    <td class="text-right text-bold" colspan="5">TOTAL :</td>
                                                    <td class="text-right text-bold money"><%= totalBunga%></td>
                                                </tr>
                                                --%>
                                            </tbody>
                                        </table>
                                    </a>
                                    <div class="list-group-item text-right" style="cursor: default; background-color: #f1f1f1">
                                        <a href="<%= approot%>/masterdata/services.jsp?id_transaksi=<%= t.getOID()%>&tgl=<%= Formater.formatDate(t.getTanggalTransaksi(), "yyyy-MM-dd HH:mm:ss")%>" class="btn_print"><i class="fa fa-file-text-o"></i>&nbsp; Cetak Bunga Periode <%= Formater.formatDate(t.getTanggalTransaksi(), "MMM yyyy")%></a>
                                    </div>
                                    <% }%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <section id="hrow" style="display:none;margin-top: -100px;" class="content">
                <div class="row">
                    <div class="col-xs-12">
                        <!-- Horizontal Form -->
                        <div class="box box-success">
                            <div class="box-header with-border">
                                <h3 class="box-title"><%=(SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Information " : "Informasi Denda")%></h3>
                            </div>
                            <div class="box-body">
                                <div id="infokredit"></div>
                                <div id="datakredit"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
                            
        <% if (tglTransaksi.length() > 0) {%>

    <print-area>
        <div style="width: 100%">
            <div style="width: 60%; float: left;">
                <strong style="width: 100%; display: inline-block;"><%=compName%></strong>
                <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                <span style="width: 100%; display: inline-block;"><%=compPhone%></span>
                <span style="width: 100%; display: inline-block;">-</span>
            </div>
            <div style="width: 40%; float: right;">
                <%

                %>
                <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 18px;">TRANSAKSI PENAMBAHAN BUNGA</span>
                <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal : <%= tglTransaksi%></span>
            </div>
        </div>
        <div class="clearfix"></div>
        <hr class="" style="border-color: gray">
        <table class="table" style="font-size: 10px">
            <thead class="thead-light">
                <tr>
                    <th style="width: 1%">No.</th>
                    <th>No Tabungan</th>
                    <th>Nama</th>
                    <th>Jenis Bunga</th>
                    <th class="text-right">Bunga</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ArrayList<ArrayList> list = PstTransaksi.getDetaiBungaTabunganPerTanggal(tglTransaksi);
                    int no = 0;
                    double totalBunga = 0;
                    for (ArrayList al : list) {
                        DataTabungan tab = (DataTabungan) al.get(0);
                        DetailTransaksi dt = (DetailTransaksi) al.get(1);
                        no++;
                        totalBunga += dt.getKredit();
                %>
                <tr>
                    <td><%= no%>.</td>
                    <td><%= tab.getKodeTabungan()%></td>
                    <td><%= tab.getCatatan()%></td>
                    <td><%= I_Sedana.BUNGA.get(tab.getStatus())[0]%></td>
                    <td class="text-right"><span class="money"><%=dt.getKredit()%></span></td>
                </tr>
                <% }%>
                <tr>
                    <td class="text-right text-bold" colspan="4">TOTAL :</td>
                    <td class="text-right text-bold money"><%= totalBunga%></td>
                </tr>
            </tbody>
        </table>
        <div class="clearfix"></div>
        <div style="width: 100%;padding-top: 40px;">
            <div style="width: 50%;float: right;text-align: center;">
                <span>Petugas</span>
                <br><br><br><br>
                <span>(&nbsp; . . . . . . . . . . . . . &nbsp;)</span>
            </div>
        </div>
        <div class="clearfix"></div>
        <div style="width: 100%;padding-top: 30px;">User Cetak : <%=userFullName%></div>
    </print-area>
    <script>window.print();</script>
    <% }%>
</body>
</html>