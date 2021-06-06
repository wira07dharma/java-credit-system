<%-- 
    Document   : report_nasabah_tidak_aktif
    Created on : Nov 23, 2017, 9:30:15 AM
    Author     : Dimata 007
--%>

<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.masterdata.AssignContact"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstAssignContact"%>
<%@page import="com.dimata.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<% //
    String tglAwal = FRMQueryString.requestString(request, "FRM_TGL_AWAL");
    String tglAkhir = FRMQueryString.requestString(request, "FRM_TGL_AKHIR");
    int iCommand = FRMQueryString.requestCommand(request);

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@ include file = "/style/style_kredit.jsp" %>
        
        <style>
            th {white-space: nowrap}
        </style>

        <script language="javascript">

            $(document).ready(function () {

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

                $('#form_cari').submit(function () {
                    $("#btnCari").attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...");
                });

                $('#btn-print').click(function () {
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
                <h1>Laporan <%=namaNasabah%> Tidak Aktif<small></small></h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Laporan</li>
                    <li class="active">Tabungan</li>
                </ol>
            </section>

            <section class="content">

                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Pencarian</h3>
                    </div>

                    <form id="form_cari" class="form-inline" method="post" action="?command=<%=Command.LIST%>">
                        <div class="box-body">

                            <div class="form-group">
                                <%--
                                <input type="text" required="" placeholder="Tanggal Awal Pencarian" class="form-control input-sm input_tgl" name="FRM_TGL_AWAL" value="<%=tglAwal%>">
                                &nbsp;
                                <input type="text" required="" placeholder="Tanggal Akhir Pencarian" class="form-control input-sm input_tgl" name="FRM_TGL_AKHIR" value="<%=tglAkhir%>">
                                &nbsp;
                                --%>
                                <button type="submit" id="btnCari" class="btn btn-sm btn-primary"><i class="fa fa-search"></i> &nbsp; Cari</button>
                            </div>

                        </div>
                    </form>

                </div>


                <% if (iCommand == Command.LIST) {%>

                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Data <%=namaNasabah %> tidak aktif menabung lebih dari 3 bulan</h3>
                    </div>

                    <div class="box-body">

                        <div class="table-responsive">
                            <table class="table table-bordered table-striped table-hover" style="font-size: 14px">
                                <tr>
                                    <th class="aksi">No.</th>
                                    <th>Nama <%=namaNasabah%></th>
                                    <th>Nomor Tabungan</th>
                                    <th>Nama Tabungan</th>
                                    <th>Saldo Terakhir</th>
                                    <th>Terakhir Menabung</th>
                                    <th>Tidak Aktif Selama</th>
                                </tr>

                                <%
                                    Calendar c = Calendar.getInstance();
                                    c.setTime(new Date());
                                    c.add(Calendar.MONTH, -3);
                                    Date lastMonth = c.getTime();
                                    String checkDate = Formater.formatDate(lastMonth, "yyyy-MM-dd");
                                    String addSql = "("
                                            + " SELECT " + PstTransaksi.fieldNames[PstTransaksi.FLD_ID_ANGGOTA]
                                            + " FROM " + PstTransaksi.TBL_TRANSAKSI
                                            + " WHERE " + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = '" + Transaksi.USECASE_TYPE_TABUNGAN_SETORAN + "'"
                                            + " AND DATE(" + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") >= '" + checkDate + "'"
                                            + " GROUP BY " + PstTransaksi.fieldNames[PstTransaksi.FLD_ID_ANGGOTA]
                                            + ")";

                                    Vector listNasabahTidakAktif = PstAssignContact.list(0, 0, "" + PstAssignContact.fieldNames[PstAssignContact.FLD_CONTACT_ID] + " NOT IN " + addSql, "");
                                    for (int i = 0; i < listNasabahTidakAktif.size(); i++) {
                                        AssignContact ac = (AssignContact) listNasabahTidakAktif.get(i);
                                        Anggota a = new Anggota();
                                        MasterTabungan mt = new MasterTabungan();
                                        try {
                                            a = PstAnggota.fetchExc(ac.getContactId());
                                            mt = PstMasterTabungan.fetchExc(ac.getMasterTabunganId());
                                        } catch (Exception exc) {

                                        }
                                        //cari saldo
                                        double saldo = PstDetailTransaksi.getCountDebetKredit(" contab." + PstAssignContact.fieldNames[PstAssignContact.FLD_ASSIGN_TABUNGAN_ID] + " = '" + ac.getOID() + "'"
                                                + " AND jenis." + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_FREKUENSI_SIMPANAN] + " = '" + JenisSimpanan.FREKUENSI_SIMPANAN_BEBAS + "'");
                                        //cek terakhir nabung
                                        String lastNabung = "-";
                                        String periode = "-";
                                        Vector<Transaksi> listTransaksi = PstTransaksi.list(0, 1, ""
                                                + "" + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = '" + Transaksi.USECASE_TYPE_TABUNGAN_SETORAN + "'"
                                                + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_ID_ANGGOTA] + " = '" + ac.getContactId() + "'"
                                                + "", "" + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC ");
                                        if (!listTransaksi.isEmpty()) {
                                            lastNabung = "" + Formater.formatDate(listTransaksi.get(0).getTanggalTransaksi(), "yyyy-MM-dd");
                                            //cari berapa lama tdk nabung
                                            Calendar cNow = new GregorianCalendar();
                                            cNow.setTime(new Date());
                                            Calendar cLast = new GregorianCalendar();
                                            cLast.setTime(listTransaksi.get(0).getTanggalTransaksi());
                                            int diffYear = cNow.get(Calendar.YEAR) - cLast.get(Calendar.YEAR);
                                            int diffMonth = diffYear * 12 + cNow.get(Calendar.MONTH) - cLast.get(Calendar.MONTH);
                                            periode = "" + diffMonth + " Bulan";
                                        }

                                %>
                                <tr>
                                    <td><%=(i + 1)%>.</td>
                                    <td><%=a.getName()%></td>
                                    <td><%=ac.getNoTabungan()%></td>
                                    <td><%=mt.getNamaTabungan()%></td>
                                    <td class="money text-right"><%=saldo%></td>
                                    <td><%=lastNabung%></td>
                                    <td><%=periode%></td>
                                </tr>
                                <%
                                    }
                                %>

                                <% if (listNasabahTidakAktif.isEmpty()) {%>
                                <tr><td colspan="7" class="label-default text-center">Tidak ada data yang ditemukan</td></tr>
                                <%} else {%>
                                <button type="button" class="btn btn-sm btn-primary" id="btn-print"><i class="fa fa-print"></i> &nbsp; Cetak</button>
                                <p></p>
                                <%}%>
                            </table>
                        </div>

                    </div>

                </div>

                <% }%>

            </section>
        </div>
    </body>

    <% if (iCommand == Command.LIST) {%>
    <print-area>
        <div style="size: A5;" class="container">
            <div style="overflow: auto">
                <div style="width: 50%; float: left;">
                    <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
                    <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                    <span style="width: 100%; display: inline-block;"><%=compPhone%></span>                    
                </div>
                <div style="width: 50%; float: right; text-align: right">
                    <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">LAPORAN <%=namaNasabah.toUpperCase()%> TIDAK AKTIF</span>
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal &nbsp; : &nbsp; <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Admin &nbsp; : &nbsp; <%=userFullName%></span>                    
                </div>
            </div>
            <hr class="" style="border-color: gray">                        
            <table class="table table-bordered" style="font-size: 10px">
                <thead>
                    <tr>
                        <th class="aksi">No.</th>
                        <th>Nama <%=namaNasabah%></th>
                        <th>Nomor Tabungan</th>
                        <th>Nama Tabungan</th>
                        <th>Saldo Terakhir</th>
                        <th>Terakhir Menabung</th>
                        <th>Tidak Aktif Selama</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Calendar c = Calendar.getInstance();
                        c.setTime(new Date());
                        c.add(Calendar.MONTH, -3);
                        Date lastMonth = c.getTime();
                        String checkDate = Formater.formatDate(lastMonth, "yyyy-MM-dd");
                        String addSql = "("
                                + " SELECT " + PstTransaksi.fieldNames[PstTransaksi.FLD_ID_ANGGOTA]
                                + " FROM " + PstTransaksi.TBL_TRANSAKSI
                                + " WHERE " + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = '" + Transaksi.USECASE_TYPE_TABUNGAN_SETORAN + "'"
                                + " AND DATE(" + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") >= '" + checkDate + "'"
                                + " GROUP BY " + PstTransaksi.fieldNames[PstTransaksi.FLD_ID_ANGGOTA]
                                + ")";

                        Vector listNasabahTidakAktif = PstAssignContact.list(0, 0, "" + PstAssignContact.fieldNames[PstAssignContact.FLD_CONTACT_ID] + " NOT IN " + addSql, "");
                        for (int i = 0; i < listNasabahTidakAktif.size(); i++) {
                            AssignContact ac = (AssignContact) listNasabahTidakAktif.get(i);
                            Anggota a = new Anggota();
                            MasterTabungan mt = new MasterTabungan();
                            try {
                                a = PstAnggota.fetchExc(ac.getContactId());
                                mt = PstMasterTabungan.fetchExc(ac.getMasterTabunganId());
                            } catch (Exception exc) {

                            }
                            //cari saldo
                            double saldo = PstDetailTransaksi.getCountDebetKredit(" contab." + PstAssignContact.fieldNames[PstAssignContact.FLD_ASSIGN_TABUNGAN_ID] + " = '" + ac.getOID() + "'"
                                    + " AND jenis." + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_FREKUENSI_SIMPANAN] + " = '" + JenisSimpanan.FREKUENSI_SIMPANAN_BEBAS + "'");
                            //cek terakhir nabung
                            String lastNabung = "-";
                            String periode = "-";
                            Vector<Transaksi> listTransaksi = PstTransaksi.list(0, 1, ""
                                    + "" + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = '" + Transaksi.USECASE_TYPE_TABUNGAN_SETORAN + "'"
                                    + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_ID_ANGGOTA] + " = '" + ac.getContactId() + "'"
                                    + "", "" + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC ");
                            if (!listTransaksi.isEmpty()) {
                                lastNabung = "" + Formater.formatDate(listTransaksi.get(0).getTanggalTransaksi(), "yyyy-MM-dd");
                                //cari berapa lama tdk nabung
                                Calendar cNow = new GregorianCalendar();
                                cNow.setTime(new Date());
                                Calendar cLast = new GregorianCalendar();
                                cLast.setTime(listTransaksi.get(0).getTanggalTransaksi());
                                int diffYear = cNow.get(Calendar.YEAR) - cLast.get(Calendar.YEAR);
                                int diffMonth = diffYear * 12 + cNow.get(Calendar.MONTH) - cLast.get(Calendar.MONTH);
                                periode = "" + diffMonth + " Bulan";
                            }

                    %>
                    <tr>
                        <td><%=(i + 1)%>.</td>
                        <td><%=a.getName()%></td>
                        <td><%=ac.getNoTabungan()%></td>
                        <td><%=mt.getNamaTabungan()%></td>
                        <td class="money text-right"><%=saldo%></td>
                        <td><%=lastNabung%></td>
                        <td><%=periode%></td>
                    </tr>
                    <%
                        }
                    %>
                    <% if (listNasabahTidakAktif.isEmpty()) {%>
                    <tr><td colspan="8" class="label-default text-center">Data transaksi tidak ditemukan</td></tr>
                    <% } else {%>
                    <%}%>          
                </tbody>
            </table>
        </div>
    </print-area>
    <% }%>
</html>
