<%-- 
    Document   : report_tabungan_saldo_akhir
    Created on : Oct 5, 2018, 9:41:17 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.session.SessReportTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.report.tabungan.PstTabunganHarian"%>
<%@page import="com.dimata.sedana.entity.report.tabungan.TabunganHarian"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.common.session.convert.Master"%>
<%@page import="com.dimata.sedana.form.reportsearch.FrmRscReport"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file = "../../main/javainit.jsp" %>
<%//
    int iCommand = FRMQueryString.requestCommand(request);
    Date start = null;
    Date end = null;
    String[] r = {};
    int sort = 0;
    if (iCommand == Command.LIST) {
        start = Formater.formatDate(FRMQueryString.requestString(request, FrmRscReport.fieldNames[FrmRscReport.FRM_START_DATE]), "yyyy-MM-dd");
        end = Formater.formatDate(FRMQueryString.requestString(request, FrmRscReport.fieldNames[FrmRscReport.FRM_END_DATE]), "yyyy-MM-dd");
        r = request.getParameterValues(FrmRscReport.fieldNames[FrmRscReport.FRM_TABUNGAN]);
        sort = FRMQueryString.requestInt(request, "sort");
    } else {
        start = new Date();
        end = new Date();
    }
    String dateStart = (start == null) ? "" : Formater.formatDate(start, "yyyy-MM-dd");
    String dateEnd = (end == null) ? "" : Formater.formatDate(end, "yyyy-MM-dd");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SEDANA</title>
        <%@ include file = "/style/lte_head.jsp" %>
        <style>
            .box .box-header, .box-footer {border-color: lightgray}
            .tabel_data th {text-align: center; font-size: 14px; font-weight: normal}
            .tabel_data td {font-size: 14px}
            #tabel_print th {text-align: center; font-weight: normal}
            #tabel_print {font-size: 12px}
            #tabel_print thead tr th {border-color: black}
            #tabel_print tbody tr td {border-color: black}
        </style>
        <script>
            jQuery(function () {
                $('#formSearch').submit(function () {
                    $('#btnSearch').attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
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
                <h1>Laporan Saldo Tabungan<small></small></h1>
                <ol class="breadcrumb">
                    <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Laporan</li>
                    <li class="active">Tabungan</li>
                </ol>
            </section>
            <section class="content" style="margin-bottom: 20px;">

                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">Form Pencarian</h3>
                    </div>
                    <form id="formSearch" class="form-horizontal" method="post">
                        <input type="hidden" name="command" value="<%= Command.LIST%>">
                        <div class="box-body">
                            <div class="form-group">

                                <div class="col-sm-4">
                                    <label class="col-sm-12">Tanggal</label>
                                    <div class="col-sm-6">
                                        <input type="text" autocomplete="off" placeholder="Tanggal Awal" name="<%=FrmRscReport.fieldNames[FrmRscReport.FRM_START_DATE]%>" class="form-control datetime-picker" data-date-format="yyyy-mm-dd" value="<%= dateStart %>">
                                    </div>
                                    <div class="col-sm-6">
                                        <input type="text" autocomplete="off" placeholder="Tanggal Akhir" name="<%=FrmRscReport.fieldNames[FrmRscReport.FRM_END_DATE]%>" class="form-control datetime-picker" data-date-format="yyyy-mm-dd" value="<%= dateEnd %>">
                                    </div>
                                </div>

                                <div class="col-sm-4">
                                    <label class="col-sm-12">Jenis Item</label>
                                    <div class="col-sm-12">
                                        <% Vector<JenisSimpanan> jts = PstJenisSimpanan.list(0, 0, "", PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN]);%>
                                        <select class="form-control select2" required="" name="<%=FrmRscReport.fieldNames[FrmRscReport.FRM_TABUNGAN]%>" multiple data-placeholder="Pilih jenis item" style="width: 100%;">
                                            <% for (JenisSimpanan jt : jts) {%>
                                            <option <%=(Master.inArray(r, String.valueOf(jt.getOID())) ? "selected" : "")%> value="<%=jt.getOID()%>"><%=jt.getNamaSimpanan()%></option>
                                            <% }%>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-sm-4">
                                    <label class="col-sm-12">Urutkan berdasarkan</label>
                                    <div class="col-sm-12">
                                        <select class="form-control" name="sort">
                                            <option <%= (sort == 0) ? "selected" : ""%> value="0">Nomor Tabungan</option>
                                            <option <%= (sort == 1) ? "selected" : ""%> value="1">Nama Nasabah</option>
                                        </select>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class="box-footer">
                            <div class="col-sm-12">
                                <button type="submit" id="btnSearch" class="btn btn-sm btn-success pull-right"><i class="fa fa-search"></i> Cari</button>
                            </div>
                        </div>

                    </form>
                </div>

                <% if (iCommand == Command.LIST) { %>
                <% Vector<TabunganHarian> th = PstTabunganHarian.getTabunganHarianPerTgl(start, end, r, sort); %>

                <%if (!th.isEmpty()) {%>
                <button type="button" id="btn-print" class="btn btn-sm btn-primary"><i class="fa fa-file"></i> &nbsp; Cetak</button>
                <p></p>
                <% } %>

                <% for (TabunganHarian t : th) {%>

                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title"><%=t.getNamaSimpanan()%></h3>
                    </div>
                    <div class="box-body">
                        <table class="table table-bordered table-hover tabel_data">
                            <thead>
                                <tr class="label-success">
                                    <th style="width: 1%">No.</th>
                                    <th>Nama</th>
                                    <th>Alamat</th>
                                    <th>No. Rek.</th>
                                    <th>Saldo Awal</th>
                                    <th>Setoran</th>
                                    <th>Bunga Dep</th>
                                    <th>Bunga</th>
                                    <th>Penarikan</th>
                                    <th>Jumlah</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% Vector<TabunganHarian.DataTabungan> datas = t.getDataTabunganVector();
                                    int i = 0;
                                    double totalSaldoAwal = 0;
                                    double totalSaldoAkhir = 0;
                                    double totalSetoran = 0;
                                    double totalBunga = 0;
                                    double totalBungaDep = 0;
                                    double totalPenarikan = 0;
                                    double totalJumlah = 0;
                                %>
                                
                                <% for (TabunganHarian.DataTabungan d : datas) {
                                        i++;
                                        totalBunga += d.getBunga();
                                        
                                        Calendar cal = Calendar.getInstance();
                                        cal.setTime(new Date());
                                        int month = cal.get(Calendar.MONTH);
                                        int year = cal.get(Calendar.YEAR);
                                        double saldoAkhir = PstDetailTransaksi.getLastSaldoOfTheMonth(d.getIdSimpanan(), month + 1, year);
                                        totalSaldoAkhir += saldoAkhir;
                                        
                                        String alamat = "-";
                                        long idAnggota = 0;
                                        if (PstDataTabungan.checkOID(d.getIdSimpanan())) {
                                            DataTabungan dt = PstDataTabungan.fetchExc(d.getIdSimpanan());
                                            Anggota a = PstAnggota.fetchExc(dt.getIdAnggota());
                                            alamat = a.getAddressPermanent();
                                            idAnggota = a.getOID();
                                        }
                                        
                                        Vector<Long> idJenisSimpanan = new Vector<Long>();
                                        for (String s : r) {
                                            idJenisSimpanan.add(Long.valueOf(s));
                                        }
                                        double saldoAwal = (start == null) ? 0 : SessReportTabungan.getSaldoAwal(idAnggota, d.getNoTabungan(), idJenisSimpanan, start);
                                        totalSaldoAwal += saldoAwal;
                                        
                                        HashMap<String, Double> dataSetoranPenarikan = (start == null || end == null) ? new HashMap<String, Double>() : SessReportTabungan.getDataSetoranPenarikan(d.getIdSimpanan(), start, end);
                                        double setoran = 0;
                                        double penarikan = 0;
                                        if (!dataSetoranPenarikan.isEmpty()) {
                                            setoran = dataSetoranPenarikan.get("SETORAN");
                                            totalSetoran += setoran;
                                            penarikan = dataSetoranPenarikan.get("PENARIKAN");
                                            totalPenarikan += penarikan;
                                        }
                                        double bungaDep = 0;
                                        totalBungaDep += bungaDep;
                                        double jumlah = saldoAwal + setoran + d.getBunga() + bungaDep - penarikan;
                                        totalJumlah += jumlah;
                                %>
                                <tr>
                                    <td><%=i%>.</td>
                                    <td><%=d.getNama()%></td>
                                    <td><%=alamat%></td>
                                    <td><%=d.getNoTabungan()%></td>
                                    <td class="money text-right"><%=saldoAwal%></td>
                                    <td class="money text-right"><%=setoran%></td>
                                    <td class="money text-right"><%=bungaDep%></td>
                                    <td class="money text-right"><%=d.getBunga()%></td>
                                    <td class="money text-right"><%=penarikan%></td>
                                    <td class="money text-right"><%=jumlah%></td>
                                </tr>
                                <% }%>
                                <tr class="label-default">
                                    <td colspan="4" style="text-align: right;"><strong>TOTAL</strong></td>
                                    <td class="money text-right text-bold"><%=totalSaldoAwal%></td>
                                    <td class="money text-right text-bold"><%=totalSetoran%></td>
                                    <td class="money text-right text-bold"><%=totalBungaDep%></td>
                                    <td class="money text-right text-bold"><%=totalBunga%></td>
                                    <td class="money text-right text-bold"><%=totalPenarikan%></td>
                                    <td class="money text-right text-bold"><%=totalJumlah%></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <% } %>
                <% }%>

            </section>
        </div>

        <print-area>
            <div style="size: A5;" class="container">
                <div style="overflow: auto">
                    <div style="width: 50%; float: left;">
                        <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
                        <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                        <span style="width: 100%; display: inline-block;"><%=compPhone%></span>                    
                    </div>
                    <div style="width: 50%; float: right; text-align: right">
                        <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">LAPORAN SALDO TABUNGAN</span>
                        <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal &nbsp; : &nbsp; <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
                        <span style="width: 100%; display: inline-block; font-size: 12px;">Admin &nbsp; : &nbsp; <%=userFullName%></span>                    
                    </div>
                </div>
                <hr class="" style="border-color: gray">

                <% Vector<TabunganHarian> th = PstTabunganHarian.getTabunganHarianPerTgl(start, end, r, sort); %>
                
                <% for (TabunganHarian t : th) {%>

                    <label class=""><%=t.getNamaSimpanan()%></label>
                    <div>
                        <table class="table " id="tabel_print">
                            <thead>
                                <tr class="">
                                    <th style="width: 1%">No.</th>
                                    <th>Nama</th>
                                    <th>Alamat</th>
                                    <th>No. Rek.</th>
                                    <th>Saldo Awal</th>
                                    <th>Setoran</th>
                                    <th>Bunga Dep</th>
                                    <th>Bunga</th>
                                    <th>Penarikan</th>
                                    <th>Jumlah</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% Vector<TabunganHarian.DataTabungan> datas = t.getDataTabunganVector();
                                    int i = 0;
                                    double totalSaldoAwal = 0;
                                    double totalSaldoAkhir = 0;
                                    double totalSetoran = 0;
                                    double totalBunga = 0;
                                    double totalBungaDep = 0;
                                    double totalPenarikan = 0;
                                    double totalJumlah = 0;
                                %>
                                
                                <% for (TabunganHarian.DataTabungan d : datas) {
                                        i++;
                                        totalBunga += d.getBunga();
                                        
                                        Calendar cal = Calendar.getInstance();
                                        cal.setTime(new Date());
                                        int month = cal.get(Calendar.MONTH);
                                        int year = cal.get(Calendar.YEAR);
                                        double saldoAkhir = PstDetailTransaksi.getLastSaldoOfTheMonth(d.getIdSimpanan(), month + 1, year);
                                        totalSaldoAkhir += saldoAkhir;
                                        
                                        String alamat = "-";
                                        long idAnggota = 0;
                                        if (PstDataTabungan.checkOID(d.getIdSimpanan())) {
                                            DataTabungan dt = PstDataTabungan.fetchExc(d.getIdSimpanan());
                                            Anggota a = PstAnggota.fetchExc(dt.getIdAnggota());
                                            alamat = a.getAddressPermanent();
                                            idAnggota = a.getOID();
                                        }
                                        
                                        Vector<Long> idJenisSimpanan = new Vector<Long>();
                                        for (String s : r) {
                                            idJenisSimpanan.add(Long.valueOf(s));
                                        }
                                        double saldoAwal = SessReportTabungan.getSaldoAwal(idAnggota, d.getNoTabungan(), idJenisSimpanan, start);
                                        totalSaldoAwal += saldoAwal;
                                        
                                        HashMap<String, Double> dataSetoranPenarikan = SessReportTabungan.getDataSetoranPenarikan(d.getIdSimpanan(), start, end);
                                        double setoran = 0;
                                        double penarikan = 0;
                                        if (!dataSetoranPenarikan.isEmpty()) {
                                            setoran = dataSetoranPenarikan.get("SETORAN");
                                            totalSetoran += setoran;
                                            penarikan = dataSetoranPenarikan.get("PENARIKAN");
                                            totalPenarikan += penarikan;
                                        }
                                        double bungaDep = 0;
                                        totalBungaDep += bungaDep;
                                        double jumlah = saldoAwal + setoran + d.getBunga() + bungaDep - penarikan;
                                        totalJumlah += jumlah;
                                %>
                                <tr>
                                    <td><%=i%>.</td>
                                    <td><%=d.getNama()%></td>
                                    <td><%=alamat%></td>
                                    <td><%=d.getNoTabungan()%></td>
                                    <td class="money text-right"><%=saldoAwal%></td>
                                    <td class="money text-right"><%=setoran%></td>
                                    <td class="money text-right"><%=bungaDep%></td>
                                    <td class="money text-right"><%=d.getBunga()%></td>
                                    <td class="money text-right"><%=penarikan%></td>
                                    <td class="money text-right"><%=jumlah%></td>
                                </tr>
                                <% }%>
                                <tr class="">
                                    <td colspan="4" style="text-align: right;"><strong>TOTAL</strong></td>
                                    <td class="money text-right text-bold"><%=totalSaldoAwal%></td>
                                    <td class="money text-right text-bold"><%=totalSetoran%></td>
                                    <td class="money text-right text-bold"><%=totalBungaDep%></td>
                                    <td class="money text-right text-bold"><%=totalBunga%></td>
                                    <td class="money text-right text-bold"><%=totalPenarikan%></td>
                                    <td class="money text-right text-bold"><%=totalJumlah%></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                <% } %>
                
                
            </div>
        </print-area>
    
    </body>
</html>
