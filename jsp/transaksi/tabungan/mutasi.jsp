<%-- 
    Document   : setoran
    Created on : Jul 4, 2017, 8:27:02 PM
    Author     : Regen
--%>
<%@page import="com.dimata.sedana.entity.masterdata.AssignContact"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.session.SessReportTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksi"%>
<%@page import="com.dimata.common.session.convert.Master"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstAssignContact"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.DetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.MutasiParam"%>
<%@page import="com.dimata.sedana.form.tabungan.FrmMutasi"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.session.Tabungan"%>
<%@page import="com.dimata.common.form.contact.FrmContactList"%>
<%@page import="com.dimata.sedana.ajax.transaksi.AjaxSetoran"%>
<%@page import="java.util.Vector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "/main/checkuser.jsp" %>
<%
  int dataFor = (Integer) request.getAttribute("dataFor");
  MutasiParam mp = (MutasiParam) request.getAttribute("mutasi");
%>
<!DOCTYPE html>
<html>
  <head>
    <title>SEDANA</title>
    <%@ include file = "/style/lte_head.jsp" %>
  </head>
  <body style="background-color: rgb(234, 243, 223); height: auto;">
    <div class="main-page">
      <!-- Content Header (Page header) -->
      <section class="content-header">
        <h1>
          Mutasi Tabungan
          <small></small>
        </h1>
        <ol class="breadcrumb">
          <li><a href="/sedana_v1/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
          <li>Laporan</li>
          <li class="active">Mutasi</li>
        </ol>
      </section>

      <!-- Main content -->
      <section class="content">
        <div class="row">
          <div class="col-xs-12">
            <!-- Horizontal Form -->
            <div class="box box-success">
              <div class="box-header with-border">
                <h3 class="box-title">Form Pencarian</h3>
              </div>
              <!-- /.box-header -->
              <!-- form start -->
              <form class="form-horizontal" method="post">
                <input type="hidden" value="<%=dataFor%>" class="hidden" name="cmd">
                <div class="">
                  <div class="box-body">
                    <div class="col-sm-12">
                      <div class="row">
                        <div class="col-sm-12">
                          <strong style="margin-bottom: 5px; display: inline-block;">Nasabah</strong>
                        </div>
                        <div style="margin-bottom: 10px;" class="col-sm-12">
                          <input type="text" required="" id="search-memberOID" value="<%=mp.getIdMember()%>" class="hidden" name="<%=FrmMutasi.FRM_FIELD_ID_MEMBER%>" placeholder="">
                          <input type="text" data-onselect="setTabungan" value="<%=mp.getMemberRekening()%>" name="<%=FrmMutasi.FRM_FIELD_MEMBER_REKENING%>" data-action="<%=approot + "/Setoran"%>" data-for="<%=AjaxSetoran.SEARCH_NO_TABUNGAN%>" required="" class="form-control autocomplete" id="search-personRekening" placeholder="No. Tabungan" style="margin-bottom: 5px; float: left; width: 30%;">
                          <input type="text" data-onselect="setMemberName" value="<%=mp.getMemberNama()%>" name="<%=FrmMutasi.FRM_FIELD_MEMBER_NAMA%>" data-action="<%=approot + "/Setoran"%>" data-for="<%=AjaxSetoran.SEARCH_MEMBER_NAME%>" required="" class="form-control autocomplete" id="search-personName" placeholder="Nama" style="float: left; width: 70%;">
                        </div>
                      </div>
                    </div>
                    <div class="col-sm-12">
                      <div class="row">
                        <div style="margin-bottom: 10px;" class="col-sm-4">
                          <strong style="margin-bottom: 5px; display: inline-block;">Jenis Item</strong><br>
                          <select name="<%=FrmMutasi.FRM_FIELD_ID_JENIS_TRANSAKSI%>" required="" placeholder="Pilih Jenis Item" class="form-control select2" multiple="">
                            <% Vector<JenisSimpanan> jts = PstJenisSimpanan.list(0, 0, "", PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_NAMA_SIMPANAN]); %>
                            <% for (JenisSimpanan jt : jts) {%>
                            <option <%=(mp.isIdJenisSimpanan(jt.getOID())) ? "selected" : ""%> value="<%=jt.getOID()%>"><%=jt.getNamaSimpanan() %></option>
                            <% }%>
                          </select>
                        </div>
                        <div style="margin-bottom: 10px;" class="col-sm-4"><strong style="margin-bottom: 5px; display: inline-block;">Tanggal Awal</strong><br><input type="text" data-date-format="yyyy-mm-dd" class="form-control datetime-picker" name="<%=FrmMutasi.FRM_FIELD_TANGGAL_AWAL%>" value="<%=Master.date2String(mp.getTanggalAwal(), "yyyy-MM-dd")%>" placeholder="" autocomplete="off"></div>
                        <div style="margin-bottom: 10px;" class="col-sm-4"><strong style="margin-bottom: 5px; display: inline-block;">Tanggal Akhir</strong><br><input type="text" data-date-format="yyyy-mm-dd" name="<%=FrmMutasi.FRM_FIELD_TANGGAL_AKHIR%>" value="<%=Master.date2String(mp.getTanggalAkhir(), "yyyy-MM-dd")%>" class="form-control datetime-picker" placeholder="" autocomplete="off"></div>
                      </div>
                    </div>
                  </div>
                  <!-- /.box-footer -->
                </div>
                <!-- /.box-body -->
                <div class="box-footer">
                  <div class="col-sm-6"></div>
                  <div class="col-sm-6">
                    <button type="submit" class="btn btn-sm btn-success pull-right">Cari</button>
                  </div>
                </div>
                <!-- /.box-footer -->
              </form>
            </div>
          </div>
          <!--/.col (right) -->
        </div>

        <% if((mp.getIdMember() != 0)) { %>
        <div class="row">
          <div class="col-xs-12">
            <!-- Horizontal Form -->
            <div class="box box-success">
              <div class="box-header with-border">
                <h3 class="box-title">Hasil Pencarian</h3>
              </div> 
              <!-- /.box-header -->
              <!-- form start -->
              <%
                //double saldo = PstTransaksi.getSaldoBeforeDate(mp.getIdMember(), mp.getIdJenisSimpanan(), mp.getTanggalAwal());
                double saldo = SessReportTabungan.getSaldoAwal(mp.getIdMember(), mp.getMemberRekening(), mp.getIdJenisSimpanan(), mp.getTanggalAwal());
                
                Date end = (Date) mp.getTanggalAkhir().clone();
                end.setDate(end.getDate()+1);
                String whereClause = PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]+" IN ("+PstAssignContact.queryTransaksiId(mp.getMemberRekening())+")";
                if(mp.getIdJenisSimpanan().size() > 0) {
                  whereClause += " AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]+" IN ("+PstDetailTransaksi.queryGetTransaksiByJenisSimpanan(mp.getIdJenisSimpanan())+")";
                }
                if(mp.getTanggalAwal() != null) {
                  //whereClause += " AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+" >= '"+Master.date2String(mp.getTanggalAwal())+"'";
                  whereClause += " AND DATE("+PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+") >= '"+Formater.formatDate(mp.getTanggalAwal(), "yyyy-MM-dd")+"'";
                }

                if(mp.getTanggalAkhir() != null) {
                  Date e = (Date) mp.getTanggalAkhir().clone();
                  e.setDate(e.getDate()+1);
                  //whereClause += " AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+" <= '"+Master.date2String(mp.getTanggalAkhir())+"'";
                  whereClause += " AND DATE("+PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+") <= '"+Formater.formatDate(mp.getTanggalAkhir(), "yyyy-MM-dd")+"'";
                }
                Vector<Transaksi> trxs = PstTransaksi.list(0, 0, whereClause, PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]);
              %>
              <div class="box-body">
                <table class="table table-condensed">
                  <thead>
                    <tr>
                      <th>Tanggal</th>
                      <th>Kode Transaksi</th>
                      <th>Uraian Transaksi</th>
                      <th>Jenis Transaksi</th>
                      <th style="text-align: right;">Debet</th>
                      <th style="text-align: right;">Kredit</th>
                      <th style="text-align: right;">Saldo</th>
                    </tr>
                  </thead>
                  <tbody>
                    <% if (true) { %>
                    <tr>
                        <%
                            Date tglSaldoAwal = (Date) mp.getTanggalAwal().clone();
                            tglSaldoAwal.setDate(tglSaldoAwal.getDate() - 1);
                        %>
                      <td><%= Master.date2String(tglSaldoAwal, "dd MMM yyyy") %></td>
                      <td>-</td>
                      <td>Saldo Awal</td>
                      <td>-</td>
                      <td style="text-align: right">-</td>
                      <td style="text-align: right">-</td>
                      <td style="text-align: right" class="money"><%=saldo %></td>
                    </tr>
                    <% } %>
                    <% for(Transaksi trx: trxs) {%>
                      <% String detailWhere = (mp.getIdJenisSimpanan().size() < 1) ? "" : " AND "+PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN]+" IN("+PstDataTabungan.queryGetSimpananByJenisSimpanan(mp.getIdJenisSimpanan())+") "; %>
                      <% Vector<DetailTransaksi> dtrxs = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID]+"="+trx.getOID()+" AND "+PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN]+" IN(SELECT ID_SIMPANAN FROM sedana_assign_contact_tabungan JOIN aiso_data_tabungan USING (ASSIGN_TABUNGAN_ID) WHERE NO_TABUNGAN = '"+ mp.getMemberRekening() +"') "+" "+detailWhere, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_DETAIL_ID]);%>
                      <% for(DetailTransaksi dtrx: dtrxs) { %>
                        <%
                          double cSaldo = dtrx.getKredit()-dtrx.getDebet();
                          double debet = (cSaldo < 1) ? Math.abs(cSaldo) : 0;
                          double kredit = (cSaldo > -1) ? Math.abs(cSaldo) : 0;
                          saldo+=cSaldo;
                        %>
                        <% if(/*debet != 0 || kredit != 0*/true) { %>
                          <%
                            ContactList cl = PstContactList.fetchExc(trx.getIdAnggota());
                            Vector<JenisTransaksi> jtss = PstJenisTransaksi.list(0, 0, PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI_ID]+"="+dtrx.getJenisTransaksiId(), "");
                            JenisTransaksi jt = jtss.get(0);
                            DataTabungan dt = PstDataTabungan.fetchExc(dtrx.getIdSimpanan());
                            JenisSimpanan js = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
                          %>
                          <tr>
                            <td><%=Master.date2String(trx.getTanggalTransaksi(), "dd MMM yyyy HH:mm:ss") %></td>
                            <td><%= trx.getKodeBuktiTransaksi() %></td>
                            <td><%=js.getNamaSimpanan() %></td>
                            <td><%=jt.getJenisTransaksi() %></td>
                            <td style="text-align: right;"><div class="money"><%=debet%></div></td>
                            <td style="text-align: right;"><div class="money"><%=kredit%></div></td>
                            <td style="text-align: right;"><div class="money"><%=saldo%></div></td>
                          </tr>
                        <% } %>
                      <% } %>
                    <% } %>
                  </tbody>
                </table>
              </div>
              <div class="box-footer">
                <button type="button" class="btn-print btn btn-success pull-left">Cetak</button>
              </div>
            </div>
          </div>
        </div>
        <% } %>
        <!-- /.row -->
      </section>
    </div>
    <print-area>
      <% if((mp.getIdMember() != 0)) { %>
      <%
        double saldo = 0;
        Date end = (Date) mp.getTanggalAkhir().clone();
        end.setDate(end.getDate()+1);
        String whereClause = PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]+" IN ("+PstAssignContact.queryTransaksiId(mp.getMemberRekening())+")";
        if(mp.getIdJenisSimpanan().size() > 0) {
          whereClause += " AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]+" IN ("+PstDetailTransaksi.queryGetTransaksiByJenisSimpanan(mp.getIdJenisSimpanan())+")";
        }
        if(mp.getTanggalAwal() != null) {
          whereClause += " AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+" >= '"+Master.date2String(mp.getTanggalAwal())+"'";
        }

        if(mp.getTanggalAkhir() != null) {
          Date e = (Date) mp.getTanggalAkhir().clone();
          e.setDate(e.getDate()+1);
          whereClause += " AND "+PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]+" <= '"+Master.date2String(mp.getTanggalAkhir())+"'";
        }
        Vector<Transaksi> trxs = PstTransaksi.list(0, 0, whereClause, PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]);
        //String noTab = SessReportTabungan.getNomorTabungan(" t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " = '" + trxs.get(0).getOID() + "'");
        String noTab = mp.getMemberRekening();
        String nama = "";
        long assignTabId = 0;
        if (noTab.length() > 0) {
            String whereAc = PstAssignContact.fieldNames[PstAssignContact.FLD_NO_TABUNGAN] + " LIKE '" + noTab + "'";
            Vector<AssignContact> ac = PstAssignContact.list(0, 0, whereAc, null);
            for (AssignContact ass : ac) {
                assignTabId = ass.getOID();
                Anggota a = PstAnggota.fetchExc(ass.getContactId());
                nama = a.getName();
            }
        }
      %>
      <div style="width: 100%">
        <div style="width: 70%; float: left;">
          <strong style="width: 100%; display: inline-block;"><%=compName%></strong>
          <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
          <span style="width: 100%; display: inline-block;"><%=compPhone%></span>
          <span style="width: 100%; display: inline-block;">-</span>
        </div>
        <div style="width: 30%; float: right;">
          <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">MUTASI TABUNGAN</span>
          <span style="width: 100%; display: inline-block; font-size: 12px;"></span>
          <span style="width: 100%; display: inline-block; font-size: 12px;">User Cetak: <%=userFullName%></span>
          <span style="width: 100%; display: inline-block; font-size: 12px;">Tgl Cetak: <%=Formater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") %></span>
        </div>
      </div>
      <div class="clearfix"></div>
      <div style="width: 100%; padding-top:10px;">
        <div style="width: 50%;float: left;">
          <div>
            <span style="width: 100px; float: left;">No Tabungan</span>
            <span style="width: calc(100% - 100px); float: right;">:&nbsp;&nbsp; <%=noTab%></span>
          </div>
          <div>
            <span style="width: 100px; float: left;">Nama Nasabah</span>
            <span style="width: calc(100% - 100px); float: right;">:&nbsp;&nbsp; <%=nama%></span>
          </div>
          <div>
            <span style="width: 100px; float: left;">Periode</span>
            <span style="width: calc(100% - 100px); float: right;">:&nbsp;&nbsp; <%=Formater.formatDate(mp.getTanggalAwal(), "dd MMM yyyy")%> - <%=Formater.formatDate(mp.getTanggalAkhir(), "dd MMM yyyy")%></span>
          </div>
        </div>
        <div style="width: 50%;float: left;"></div>
      </div>
      <div class="clearfix"></div>
      <table class="table table-responsive" style="margin-top: 40px; border-bottom: 1px solid #eee;">
        <thead>
          <tr>
            <th style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: 1px solid #eee;">Tanggal</th>
            <th style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: 1px solid #eee;">Uraian Transaksi</th>
            <th style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: 1px solid #eee;">Jenis Transaksi</th>
            <th style="text-align: right; border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: 1px solid #eee;">Debet</th>
            <th style="text-align: right; border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: 1px solid #eee;">Kredit</th>
            <th style="text-align: right; border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: 1px solid #eee;">Saldo</th>
          </tr>
        </thead>
        <tbody>
          <% saldo = PstTransaksi.getSaldoBeforeDate(mp.getIdMember(), mp.getIdJenisSimpanan(), mp.getTanggalAwal()); %>
          <tr>
            <td style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;"></td>
            <td style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;">Saldo Awal</td>
            <td style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;"></td>
            <td style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;"></td>
            <td style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;"></td>
            <td class="money" style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;"><%=saldo %></td>
          </tr>
          <% for(Transaksi trx: trxs) {%>
            <% Vector<DetailTransaksi> dtrxs = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID]+"="+trx.getOID(), PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID]);%>
            <% for(DetailTransaksi dtrx: dtrxs) { %>
              <%
                ContactList cl = PstContactList.fetchExc(trx.getIdAnggota());
                Vector<JenisTransaksi> jtss = PstJenisTransaksi.list(0, 0, PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI_ID]+"="+dtrx.getJenisTransaksiId(), "");
                JenisTransaksi jt = jtss.get(0);
                DataTabungan dt = PstDataTabungan.fetchExc(dtrx.getIdSimpanan());
                if (dt.getAssignTabunganId() != assignTabId) {continue;}
                JenisSimpanan js = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
                PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_DEBET] = PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_DEBET];
              %>
              <tr>
                <td style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;"><%=Master.date2String(trx.getTanggalTransaksi(), "MMM, dd yyyy HH:mm:ss") %></td>
                <td style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;"><%=js.getNamaSimpanan() %></td>
                <td style="border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;"><%=jt.getJenisTransaksi() %></td>
                <%
                  double cSaldo = dtrx.getKredit()-dtrx.getDebet();
                  double debet = (cSaldo < 1) ? Math.abs(cSaldo) : 0;
                  double kredit = (cSaldo > -1) ? Math.abs(cSaldo) : 0;
                  saldo+=cSaldo;
                %>
                <td class="money" style="text-align: right;border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;"><%=debet%></td>
                <td class="money" style="text-align: right;border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;"><%=kredit%></td>
                <td class="money" style="text-align: right;border-left: 1px solid #eee; border-right: 1px solid #eee; border-top: none; border-bottom: none;"><%=saldo%></td>
              </tr>
            <% } %>
          <% } %>
        </tbody>
      </table>
      <% } %>
    </print-area>
  </body>
</html>
