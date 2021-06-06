<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.report.tabungan.TabunganHarian"%>
<%@page import="com.dimata.sedana.entity.report.tabungan.PstTabunganHarian"%>
<%@page import="com.dimata.common.session.convert.Master"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisTabungan"%>
<%@page language="java" %>
<%@page import = "java.util.*" %>
<%@page import = "com.dimata.util.*" %>
<%@page import = "com.dimata.gui.jsp.*" %>
<%@page import = "com.dimata.qdep.form.*" %>
<%@page import="com.dimata.sedana.form.reportsearch.FrmRscReport"%>
<%@include file = "../../main/javainit.jsp" %>
<%    String q = FRMQueryString.requestString(request, "report");
    Date start = null;
    Date end = null;
    String[] r = {};
    int sort = 0;
    if (q.equals(String.valueOf(FrmRscReport.REPORT_TABUNGAN_PER_PINJAMAN))) {
        start = Formater.formatDate(FRMQueryString.requestString(request, FrmRscReport.fieldNames[FrmRscReport.FRM_START_DATE]), "yyyy-MM-dd");
        end = Formater.formatDate(FRMQueryString.requestString(request, FrmRscReport.fieldNames[FrmRscReport.FRM_END_DATE]), "yyyy-MM-dd");
        r = request.getParameterValues(FrmRscReport.fieldNames[FrmRscReport.FRM_TABUNGAN]);
        sort = FRMQueryString.requestInt(request, "sort");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>SEDANA</title>
        <%@ include file = "/style/lte_head.jsp" %>
        <style>
            #tabelDataPrint {font-size: 12px}
            #tabelDataPrint thead tr th {border-color: black}
            #tabelDataPrint tbody tr td {border-color: black}
        </style>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
        <!-- Content Header (Page header) -->
            <section class="content-header">
                <h1>
                    Laporan Saldo Tabungan Berdasarkan Jenis Item
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Laporan</li>
                    <li class="active">Tabungan</li>
                </ol>
            </section>

            <!-- Main content -->
            <section class="content" style="margin-bottom: 20px;">
                <div class="">
                    <!-- Horizontal Form -->
                    <div class="box box-success">
                        <div class="box-header with-border">
                            <h3 class="box-title">Form Pencarian</h3>
                        </div>
                        <!-- /.box-header -->
                        <!-- form start -->
                        <form class="form-horizontal" method="post">
                            <input type="hidden" class="hidden" name="report" value="<%=FrmRscReport.REPORT_TABUNGAN_PER_PINJAMAN%>" />
                            <div class="box-body">
                                <div class="form-group">
                                  <div class="col-sm-4">
                                    <div class="form-group">
                                      <label class="col-sm-12">Tanggal</label>
                                      <div class="col-sm-6">
                                        <input type="text" autocomplete="off" name="<%=FrmRscReport.fieldNames[FrmRscReport.FRM_START_DATE]%>" class="form-control datetime-picker" data-date-format="yyyy-mm-dd" placeholder="<%=FrmRscReport.shortFieldNames[SESS_LANGUAGE][0]%>" value="<%=(start == null) ? "" : Formater.formatDate(start, "yyyy-MM-dd")%>"> <!-- hh:ii -->
                                      </div>
                                      <div class="col-sm-6">
                                          <input type="text" autocomplete="off" name="<%=FrmRscReport.fieldNames[FrmRscReport.FRM_END_DATE]%>" class="form-control datetime-picker" data-date-format="yyyy-mm-dd" placeholder="<%=FrmRscReport.shortFieldNames[SESS_LANGUAGE][1]%>" value="<%=(start == null) ? "" : Formater.formatDate(end, "yyyy-MM-dd")%>">
                                      </div>
                                    </div>
                                  </div>
                                  <div class="col-sm-4">
                                    <div class="form-group">
                                      <label class="col-sm-12">Jenis Item</label>
                                      <div class="col-sm-12">
                                          <% Vector<JenisSimpanan> jts = PstJenisSimpanan.list(0, 0, "", PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN]);%>
                                          <select required class="form-control select2" name="<%=FrmRscReport.fieldNames[FrmRscReport.FRM_TABUNGAN]%>" multiple data-placeholder="Select a State" style="width: 100%;">
                                              <% for (JenisSimpanan jt : jts) {%>
                                              <option <%=(Master.inArray(r, String.valueOf(jt.getOID())) ? "selected" : "")%> value="<%=jt.getOID()%>"><%=jt.getNamaSimpanan()%></option>
                                              <% } %>
                                          </select>
                                      </div>
                                    </div>
                                  </div>
                                  <div class="col-sm-4">
                                    <div class="form-group">
                                      <label class="col-sm-12">Urutkan</label>
                                      <div class="col-sm-12">
                                        <select class="form-control" name="sort">
                                          <option value="0">Nomor Tabungan</option>
                                          <option value="1">Nama <%=namaNasabah %></option>
                                        </select>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                            </div>
                            <!-- /.box-body -->
                            <div class="box-footer">
                                <button type="submit" class="btn btn-success pull-right">Cari</button>
                            </div>
                            <!-- /.box-footer -->
                        </form>
                    </div>
                    <% if (q.equals(String.valueOf(FrmRscReport.REPORT_TABUNGAN_PER_PINJAMAN))) { %>
                    <% Vector<TabunganHarian> th = PstTabunganHarian.getTabunganHarianPerTgl(start, end, r, sort); %>

                    <%if (!th.isEmpty()) {%>
                        <button type="button" id="btn-print" class="btn btn-sm btn-primary"><i class="fa fa-file"></i> &nbsp; Cetak</button>
                        <p></p>
                    <% } %>

                    <% for (TabunganHarian t : th) {%>
                    <div class="row">
                        <div class="col-xs-12">
                            <!-- Horizontal Form -->
                            <div class="box box-success">
                                <div class="box-header with-border">
                                    <h3 class="box-title"><%=t.getNamaSimpanan()%></h3>
                                    <div class="box-tools pull-right">
                                        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
                                    </div>
                                </div>
                                <div class="box-body">
                                    <table class="table table-condensed table-hover">
                                        <thead>
                                            <tr>
                                                <th>No</th>
                                                <th>No. Tabungan</th>
                                                <th>Nama</th>
                                                <th colspan="2" class="text-center">Saldo Periode</th>
                                                <th>Saldo Akhir</th>
                                                <th>Bunga</th>
                                                <th>Pembulatan</th>
                                                <th>Keterangan</th>
                                            </tr>
                                            <tr>
                                                <th></th>
                                                <th></th>
                                                <th></th>
                                                <th>Debet</th>
                                                <th>Kredit</th>
                                                <th></th>
                                                <th></th>
                                                <th></th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% Vector<TabunganHarian.DataTabungan> datas = t.getDataTabunganVector();
                                            int i = 0; 
                                                double totalSaldo = 0;
                                                double totalBunga = 0;
                                                double totalPembulatan = 0;
                                                //ADDED BY DEWOK 20180825 TO GET LAST SALDO
                                                double totalDebet = 0;
                                                double totalKredit = 0;
                                                double totalSaldoAkhir = 0;

                                            %>
                                            <% for (TabunganHarian.DataTabungan d : datas) { i++;
                                                totalSaldo = totalSaldo + d.getSaldo();
                                                totalBunga = totalBunga + d.getBunga();
                                                totalPembulatan = totalPembulatan + d.getPembulatan();
                                                //ADDED BY DEWOK 20180825 TO GET LAST SALDO
                                                double debet = 0;
                                                double kredit = 0;
                                                if (d.getSaldo() > 0) {
                                                    debet = d.getSaldo();
                                                    totalDebet += d.getSaldo();
                                                } else {
                                                    kredit = d.getSaldo();
                                                    totalKredit += d.getSaldo();
                                                }
                                                Calendar cal = Calendar.getInstance();
                                                cal.setTime(new Date());
                                                int month = cal.get(Calendar.MONTH);
                                                int year = cal.get(Calendar.YEAR);
                                                double saldoAkhir = PstDetailTransaksi.getLastSaldoOfTheMonth(d.getIdSimpanan(), month+1, year);
                                                totalSaldoAkhir += saldoAkhir;
                                                //===
                                            %>
                                            <tr>
                                                <td><%=i%></td>
                                                <td><%=d.getNoTabungan()%></td>
                                                <td><%=d.getNama()%></td>
                                                <td class="money text-right"><%=debet%></td>
                                                <td class="money text-right"><%=Math.abs(kredit)%></td>
                                                <td class="money text-right"><%=saldoAkhir%></td>
                                                <td class="money text-right"><%=d.getBunga()%></td>
                                                <td class="money text-right"><%=d.getPembulatan()%></td>
                                                <td><%=d.getKet()%></td>
                                            </tr>
                                            <% } %>
                                            <tr>
                                                <td colspan="3" style="text-align: right;"><strong>Total</strong></td>
                                                <td class="money text-right"><%=totalDebet%></td>
                                                <td class="money text-right"><%=Math.abs(totalKredit)%></td>
                                                <td class="money text-right"><%=totalSaldoAkhir%></td>
                                                <td class="money text-right"><%=totalBunga%></td>
                                                <td class="money text-right"><%=totalPembulatan%></td>
                                                <td></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% }
                }%>
                </div>
                <!-- /.row -->
                <div class="clearfix"></div>
            </section>

            <%@ include file = "/footerkoperasi.jsp" %>
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
                    <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">LAPORAN SALDO TABUNGAN PER JENIS ITEM</span>
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal &nbsp; : &nbsp; <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Admin &nbsp; : &nbsp; <%=userFullName%></span>                    
                </div>
            </div>
            <hr class="" style="border-color: gray">
            
            <% if (q.equals(String.valueOf(FrmRscReport.REPORT_TABUNGAN_PER_PINJAMAN))) { %>
            
            <% Vector<TabunganHarian> th = PstTabunganHarian.getTabunganHarianPerTgl(start, end, r, sort); %>
            <% for (TabunganHarian t : th) {%>

            <table class="table table-condensed" id="tabelDataPrint">
                <thead>
                    <tr>
                        <th>No</th>
                        <th><nobr>No. Tabungan</nobr></th>
                        <th>Nama</th>
                        <th class="text-right">Debet</th>
                        <th class="text-right">Kredit</th>
                        <th class="text-right"><nobr>Saldo Akhir</nobr></th>
                        <th class="text-right">Bunga</th>
                        <th class="text-right">Pembulatan</th>
                        <th>Keterangan</th>
                    </tr>
                </thead>
                <tbody>
                    <% Vector<TabunganHarian.DataTabungan> datas = t.getDataTabunganVector();int i = 0; 
                        double totalSaldo = 0;
                        double totalBunga = 0;
                        double totalPembulatan = 0;
                        //ADDED BY DEWOK 20180825 TO GET LAST SALDO
                        double totalDebet = 0;
                        double totalKredit = 0;
                        double totalSaldoAkhir = 0;

                    %>
                    <% for (TabunganHarian.DataTabungan d : datas) { i++;
                        totalSaldo = totalSaldo + d.getSaldo();
                        totalBunga = totalBunga + d.getBunga();
                        totalPembulatan = totalPembulatan + d.getPembulatan();
                        //ADDED BY DEWOK 20180825 TO GET LAST SALDO
                        double debet = 0;
                        double kredit = 0;
                        if (d.getSaldo() > 0) {
                            debet = d.getSaldo();
                            totalDebet += d.getSaldo();
                        } else {
                            kredit = d.getSaldo();
                            totalKredit += d.getSaldo();
                        }
                        Calendar cal = Calendar.getInstance();
                        cal.setTime(new Date());
                        int month = cal.get(Calendar.MONTH);
                        int year = cal.get(Calendar.YEAR);
                        double saldoAkhir = PstDetailTransaksi.getLastSaldoOfTheMonth(d.getIdSimpanan(), month+1, year);
                        totalSaldoAkhir += saldoAkhir;
                        //===
                    %>
                    <tr>
                        <td><%=i%></td>
                        <td><%=d.getNoTabungan()%></td>
                        <td><%=d.getNama()%></td>
                        <td class="text-right"><div class="money"><%=debet%></div></td>
                        <td class="text-right"><div class="money"><%=Math.abs(kredit)%></div></td>
                        <td class="text-right"><div class="money"><%=saldoAkhir%></div></td>
                        <td class="text-right"><div class="money"><%=d.getBunga()%></div></td>
                        <td class="text-right"><div class="money"><%=d.getPembulatan()%></div></td>
                        <td><%=d.getKet()%></td>
                    </tr>
                    <% } %>
                    <tr>
                        <td colspan="3" style="text-align: right;"><strong>Total :</strong></td>
                        <td class="text-right"><div class="money"><%=totalDebet%></div></td>
                        <td class="text-right"><div class="money"><%=Math.abs(totalKredit)%></div></td>
                        <td class="text-right"><div class="money"><%=totalSaldoAkhir%></div></td>
                        <td class="text-right"><div class="money"><%=totalBunga%></div></td>
                        <td class="text-right"><div class="money"><%=totalPembulatan%></div></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>

            <% } %>
            
            <% } %>
            
        </div>
    </print-area>


        <!-- jQuery 2.2.3 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <!-- Bootstrap 3.3.6 -->
        <script src="../../style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
        <!-- FastClick -->
        <script src="../../style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>
        <!-- AdminLTE App -->
        <script src="../../style/AdminLTE-2.3.11/dist/js/app.min.js"></script>
        <!-- AdminLTE for demo purposes -->
        <script src="../../style/AdminLTE-2.3.11/dist/js/demo.js"></script>
        <!-- Select2 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/select2/select2.full.min.js"></script>
        <!-- Datetime Picker -->
        <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
        <!-- Declaration -->
        <script>
            jQuery(function () {
                $('.select2').select2();
                $('.datetime-picker').datetimepicker({
                    weekStart: 1,
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2 // No time
                    // showMeridian: 0
                });
                
                $('#btn-print').click(function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.print();
                    $(this).removeAttr('disabled').html(buttonHtml);
                });
            });
        </script>
        
    </body>
</html>
