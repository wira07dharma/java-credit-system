<%-- 
    Document   : report_kolektor
    Created on : Oct 23, 2019, 4:52:13 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.session.SessReportTabungan"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    String tglAwal = FRMQueryString.requestString(request, "TGL_AWAL");
    String tglAkhir = FRMQueryString.requestString(request, "TGL_AKHIR");
    long idKolektor = FRMQueryString.requestLong(request, "ID_KOLEKTOR");
    int jenisTransaksi = FRMQueryString.requestInt(request, "JENIS_TRANSAKSI");

    if (iCommand == Command.NONE) {
        tglAwal = tglAwal.isEmpty() ? Formater.formatDate(new java.util.Date(), "yyyy-MM-dd") : tglAwal;
        tglAkhir = tglAkhir.isEmpty() ? Formater.formatDate(new java.util.Date(), "yyyy-MM-dd") : tglAkhir;
    }

    String where = "";
    if (iCommand == Command.LIST) {
        if (!tglAwal.isEmpty()) {
            where += where.isEmpty() ? "" : " AND ";
            where += " st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " >= '" + tglAwal + " 00:00:00' ";
        }

        if (!tglAkhir.isEmpty()) {
            where += where.isEmpty() ? "" : " AND ";
            where += " st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " <= '" + tglAkhir + " 23:59:59' ";
        }

        if (idKolektor != 0) {
            where += where.isEmpty() ? "" : " AND ";
            where += " aau." + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = " + idKolektor;
        }
    }

    Vector<AppUser> listKolektor = PstAppUser.listFullObj(0, 0, "", PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME]);
    String optionKoletor = "<option value='0'>Semua Kolektor</option>";
    for (AppUser au : listKolektor) {
        optionKoletor += "<option " + (idKolektor == au.getOID() ? "selected" : "") + " value='" + au.getOID() + "'>" + au.getFullName() + "</option>";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Report Kolektor</title>
        <%@ include file = "/style/style_kredit.jsp" %>
        <link href="<%=approot%>/style/datatables/Buttons-1.6.1/css/buttons.dataTables.min.css" rel="stylesheet" type="text/css"/>
        <style>
            .box .box-header, .box-footer {border-color: lightgray}
            form {margin: 0px}
            table {font-size: 14px}
        </style>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>Laporan Kolektor</h1>
                <ol class="breadcrumb">
                    <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Laporan</li>
                    <li class="active">Tabungan</li>
                </ol>
            </section>
            <section class="content">
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">Form Pencarian</h3>
                    </div>
                    <div class="box-body">
                        <form id="formSearch" class="form-horizontal">
                            <input type="hidden" name="command" value="<%=Command.LIST%>">

                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="col-sm-2">Tanggal</label>
                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <input type="text" class="form-control input-sm date-picker" placeholder="Awal" name="TGL_AWAL" value="<%=tglAwal%>">
                                                <span class="input-group-addon">s/d</span>
                                                <input type="text" class="form-control input-sm date-picker" placeholder="Akhir" name="TGL_AKHIR" value="<%=tglAkhir%>">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-2">Kolektor</label>
                                        <div class="col-sm-8">
                                            <select class="form-control input-sm" name="ID_KOLEKTOR">
                                                <%=optionKoletor%>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label class="col-sm-2">Transaksi</label>
                                        <div class="col-sm-4">
                                            <select class="form-control input-sm" name="JENIS_TRANSAKSI">
                                                <!--option <%=(jenisTransaksi == 0 ? "selected" : "")%> value="0">Semua</option-->
                                                <option <%=(jenisTransaksi == 1 ? "selected" : "")%> value="1">Tabungan</option>
                                                <option <%=(jenisTransaksi == 2 ? "selected" : "")%> value="2">Kredit</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="box-footer">
                        <button type="submit" form="formSearch" id="btnSearch" class="btn btn-sm btn-primary"><i class="fa fa-search"></i>&nbsp; Cari</button>
                    </div>
                </div>

                <% if (iCommand == Command.LIST) { %>

                <% if (jenisTransaksi == 0 || jenisTransaksi == 1) { %>

                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">Transaksi Tabungan</h3>
                    </div>
                    <div class="box-body">
                        <table id="dataTabelTabungan" class="table table-bordered table-striped">
                            <thead>
                                <tr>
                                    <th style="width: 1%">No.</th>
                                    <th>Tanggal</th>
                                    <th>Kolektor</th>
                                    <th>Anggota</th>
                                    <th>No Tabungan</th>
                                    <th>Saldo Awal</th>
                                    <th>Setoran</th>
                                    <th>Penarikan</th>
                                    <th>Saldo Akhir</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    String whereTabungan = where.isEmpty() ? "" : " AND ";
                                    whereTabungan += " st." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN (" + Transaksi.USECASE_TYPE_TABUNGAN_SETORAN + "," + Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN + ")";
                                    ArrayList<HashMap> list = SessReportTabungan.listTransaksiTabunganKolektor(where + whereTabungan);

                                    int no = 0;
                                    for (HashMap map : list) {
                                        no++;
                                %>
                                <tr>
                                    <td><%=no%>.</td>
                                    <td><%=map.get("TANGGAL_TRANSAKSI")%></td>
                                    <td><%=map.get("NAMA_KOLEKTOR")%></td>
                                    <td><%=map.get("NAMA_ANGGOTA")%></td>
                                    <td><%=map.get("NO_TABUNGAN")%></td>
                                    <td class="money text-right"><%=map.get("SALDO_AWAL")%></td>
                                    <td class="money text-right"><%=map.get("SETORAN")%></td>
                                    <td class="money text-right"><%=map.get("PENARIKAN")%></td>
                                    <td class="money text-right"><%=map.get("SALDO_AKHIR")%></td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <% } %>

                <% if (jenisTransaksi == 0 || jenisTransaksi == 2) { %>

                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">Transaksi Kredit</h3>
                    </div>
                    <div class="box-body">
                        <table id="dataTabelKredit" class="table table-bordered table-striped">
                            <thead>
                                <tr>
                                    <th style="width: 1%">No.</th>
                                    <th>Tanggal</th>
                                    <th>Kolektor</th>
                                    <th>Anggota</th>
                                    <th>No Kredit</th>
                                    <th>Jumlah Pinjaman</th>
                                    <th>Jumlah Setoran</th>
                                    <th>Sisa Angsuran</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    String whereKredit = where.isEmpty() ? "" : " AND ";
                                    whereKredit += " st." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN (" + Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT + ")";
                                    ArrayList<HashMap> list = SessReportTabungan.listTransaksiKreditKolektor(where + whereKredit);

                                    int no = 0;
                                    for (HashMap map : list) {
                                        no++;
                                %>
                                <tr>
                                    <td><%=no%>.</td>
                                    <td><%=map.get("TANGGAL_TRANSAKSI")%></td>
                                    <td><%=map.get("NAMA_KOLEKTOR")%></td>
                                    <td><%=map.get("NAMA_ANGGOTA")%></td>
                                    <td><%=map.get("NO_KREDIT")%></td>
                                    <td class="money text-right"><%=map.get("JUMLAH_PINJAMAN")%></td>
                                    <td class="money text-right"><%=map.get("JUMLAH_ANGSURAN")%></td>
                                    <td class="money text-right"><%=map.get("SISA_ANGSURAN")%></td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <% } %>

                <%}%>
            </section>
        </div>
    </body>
    <script src="<%=approot%>/style/datatables/Buttons-1.6.1/js/dataTables.buttons.min.js"></script>
    <script src="<%=approot%>/style/datatables/Buttons-1.6.1/js/buttons.bootstrap.min.js"></script>
    <script src="<%=approot%>/style/datatables/Buttons-1.6.1/js/buttons.flash.min.js"></script>
    <script src="<%=approot%>/style/datatables/JSZip-2.5.0/jszip.min.js"></script>
    <script src="<%=approot%>/style/datatables/pdfmake-0.1.36/pdfmake.min.js"></script>
    <script src="<%=approot%>/style/datatables/pdfmake-0.1.36/vfs_fonts.js"></script>
    <script src="<%=approot%>/style/datatables/Buttons-1.6.1/js/buttons.html5.min.js"></script>
    <script src="<%=approot%>/style/datatables/Buttons-1.6.1/js/buttons.print.min.js"></script>

    <script>
        $(document).ready(function () {
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

            function setDataTables(elementId) {
                $(elementId).DataTable({
                    dom: 'Bfrtip',
                    buttons: [
                        'excel', 'pdf', 'print'
                    ]
                });
                $(elementId + '_wrapper').find('.dt-buttons').removeClass('btn-group');//.find('.btn').removeClass('btn-default').addClass('btn-primary');
                $(elementId + '_info').css({float: 'left'});
                $(elementId + '_paginate').css({float: 'right'});
                $(elementId).find('.dataTables_empty').css({'text-align': 'center', 'background-color': 'lightgray'});
            }

            setDataTables('#dataTabelTabungan');
            setDataTables('#dataTabelKredit');

            $('#formSearch').submit(function () {
                $('#btnSearch').attr({disabled: true}).html('<i class="fa fa-spinner fa-pulse"></i> Tunggu...');
            });
        });
    </script>
</html>

