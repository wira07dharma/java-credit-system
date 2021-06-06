<%-- 
    Document   : list_transaksi_tabungan
    Created on : Jan 9, 2019, 11:05:43 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.common.session.convert.ConvertAngkaToHuruf"%>
<%@page import="com.dimata.common.session.convert.Master"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.entity.kredit.AngsuranPayment"%>
<%@page import="com.dimata.common.entity.payment.PstPaymentSystem"%>
<%@page import="com.dimata.common.entity.payment.PaymentSystem"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksiPayment"%>
<%@page import="com.dimata.sedana.entity.tabungan.TransaksiPayment"%>
<%@page import="com.dimata.common.entity.contact.ContactClassAssign"%>
<%@page import="com.dimata.common.entity.contact.PstContactClassAssign"%>
<%@page import="com.dimata.sedana.ajax.tabungan.AjaxTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.session.SessReportTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>

<%!
    public int cekTipeAnggota(long idAnggota) {
        Vector<ContactClassAssign> listAssigns = PstContactClassAssign.list(0, 0, PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] + " = " + idAnggota, null);
        for (ContactClassAssign cca : listAssigns) {
            long idClassAssign = cca.getContactClassId();
            try {
                return PstContactClass.fetchExc(idClassAssign).getClassType();
            } catch (Exception e) {
                System.out.print(e.getMessage());
            }
        }
        return 0;
    }
%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    int showHistory = FRMQueryString.requestInt(request, "show_history");
    String tglAwal = FRMQueryString.requestString(request, "FRM_TGL_AWAL");
    String tglAkhir = FRMQueryString.requestString(request, "FRM_TGL_AKHIR");
    String useCaseType = FRMQueryString.requestString(request, "FRM_USE_CASE_TYPE");
    long idNasabah = FRMQueryString.requestLong(request, "FRM_NASABAH");
    long idSimpanan = FRMQueryString.requestLong(request, "FRM_SIMPANAN");
    int record = FRMQueryString.requestInt(request, "FRM_RECORD");
    String keyword = FRMQueryString.requestString(request, "FRM_KEYWORD");
    int aksi = FRMQueryString.requestInt(request, "FRM_AKSI");
    long idTransaksi = FRMQueryString.requestLong(request, "FRM_TRANSAKSI");
    
    List<String> listUseCaseType = new ArrayList();
    listUseCaseType.add(""+Transaksi.USECASE_TYPE_TABUNGAN_SETORAN);
    listUseCaseType.add(""+Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN);
    listUseCaseType.add(""+Transaksi.USECASE_TYPE_TABUNGAN_PENUTUPAN);
    listUseCaseType.add(""+Transaksi.USECASE_TYPE_TABUNGAN_BUNGA_PENCATATAN);
    listUseCaseType.add(""+Transaksi.USECASE_TYPE_TABUNGAN_POTONGAN_ADMIN_PENCATATAN);
                                    
    Vector<Transaksi> listTransaksi = new Vector();
    int listRecord = 0;
    int result = 0;
    if (iCommand == Command.NONE) {
        record = 10;
    }
    String message = "";
    if (true || iCommand == Command.LIST) {
        String where = "";
        if (useCaseType.equals("-") || useCaseType.isEmpty()) {
            String kodeUseCase = "";
            for (String useCase : listUseCaseType) {
                kodeUseCase += (kodeUseCase.length() > 0) ? "," + useCase : useCase;
            }
            where += PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN (" + kodeUseCase + ")";
        } else {
            where += (useCaseType.isEmpty()) ? "" : PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = '" + useCaseType + "'";
        }
        if (!tglAwal.equals("")) {
            where += " AND DATE(" + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") >= '" + tglAwal + "'";
        }
        if (!tglAkhir.equals("")) {
            where += " AND DATE(" + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") <= '" + tglAkhir + "'";
        }
        if (idNasabah != 0) {
            where += " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_ID_ANGGOTA] + " = '" + idNasabah + "'";
        }
        if (idSimpanan != 0) {
            String selectTransaksiId = "SELECT " + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID]
                    + " FROM " + PstDetailTransaksi.TBL_DETAILTRANSAKSI
                    + " WHERE " + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN] + " = " + idSimpanan;
            where += " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " IN (" + selectTransaksiId + ")";
        }
        if (!keyword.isEmpty()) {
            where += " AND ("
                    + "" + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI] + " LIKE '%" + keyword + "%'"
                    + " OR " + PstTransaksi.fieldNames[PstTransaksi.FLD_KETERANGAN] + " LIKE '%" + keyword + "%'"
                    + ")";
        }
        
        if (aksi == 0) {
            listTransaksi = PstTransaksi.list(0, record, where, PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC ");
            listRecord = PstTransaksi.list(0, 0, where, PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC ").size();
        } else if (aksi == Command.DETAIL) {
            listTransaksi = PstTransaksi.list(0, 0, PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " = " + idTransaksi, null);
            listRecord = PstTransaksi.list(0, 0, PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " = " + idTransaksi, null).size();
        } else if (aksi == Command.DELETE) {
            AjaxTabungan ajaxTabungan = new AjaxTabungan();
            message = ajaxTabungan.deleteTransaction(idTransaksi, userOID, userFullName);
            listTransaksi = PstTransaksi.list(0, record, where, PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC ");
            listRecord = PstTransaksi.list(0, 0, where, PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC ").size();
        }
        
        result = (listTransaksi.size() < record) ? listTransaksi.size() : record;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@ include file = "/style/style_kredit.jsp" %>
        <style>
            .table {font-size: 14px}
        </style>
        <script>
            function cari() {
                document.getElementById("btnSearch").innerHTML = "<i class='fa fa-spinner fa-pulse'></i>&nbsp; Cari";
                document.getElementById("btnSearch").disabled = true;
                document.form_cari.submit();
            }
            
            function detailTransaksi(idTransaksi) {
                document.form_cari.FRM_AKSI.value = "<%=Command.DETAIL %>";
                document.form_cari.FRM_TRANSAKSI.value = idTransaksi;
                document.form_cari.submit();
            }
            
            function deleteTransaction(idTransaksi) {
                if (confirm("Yakin akan menghapus transaksi ini ?")) {
                    document.form_cari.FRM_AKSI.value = "<%=Command.DELETE %>";
                    document.form_cari.FRM_TRANSAKSI.value = idTransaksi;
                    document.form_cari.submit();
                }
            }
            
            function printTransaction() {
                window.print();
            }
            
            $(document).ready(function () {
                $("#btnDelete").click(function(){
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...");
                });
            });
            
        </script>
        
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>Daftar Transaksi Tabungan<small></small></h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Transaksi</li>
                    <li class="active">Tabungan</li>
                </ol>
            </section>
            <section class="content">
                <div class="box box-success">
                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Pencarian</h3>
                    </div>
                    
                    <div class="box-body">
                        <form name="form_cari" class="form-inline" method="post" action="?command=<%=Command.LIST%>">
                            <input type="hidden" name="FRM_AKSI" value="">
                            <input type="hidden" name="FRM_TRANSAKSI" value="">
                            <input type="text" placeholder="Tanggal awal" autocomplete="off" class="form-control date-picker" name="FRM_TGL_AWAL" value="<%= tglAwal %>">
                            <input type="text" placeholder="Tanggal akhir" autocomplete="off" class="form-control date-picker" name="FRM_TGL_AKHIR" value="<%= tglAkhir %>">
                            <select class="form-control input-sm select2transaksi" name="FRM_USE_CASE_TYPE">
                                <option value="-">-- Semua Transaksi --</option>
                                <%
                                    for (String useCase : listUseCaseType) {
                                        String selected = (useCase.equals(useCaseType)) ? "selected" : "";
                                        out.print("<option "+selected+" value='"+useCase+"'>"+Transaksi.USECASE_TYPE_TITLE.get(Integer.valueOf(useCase))+"</option>");
                                    }
                                %>
                            </select>
                            <select class="form-control input-sm select2nasabah" name="FRM_NASABAH">
                                <option value="0">-- Semua Nasabah --</option>
                                <%
                                    Vector<Anggota> listNasabah = SessAnggota.listJoinContactClassAssign(0, 0, ""
                                            + " cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                                            + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "'"
                                            + "", "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]);
                                    for (Anggota a : listNasabah) {
                                        String selected = (a.getOID() == idNasabah) ? "selected" : "";
                                        out.print("<option "+selected+" value='"+a.getOID()+"'>"+a.getName()+"</option>");
                                    }
                                %>
                            </select>
                            <select class="form-control input-sm select2 select2tabungan" name="FRM_SIMPANAN">
                                <option value="0">-- Semua Tabungan --</option>
                                <%
                                    Vector<DataTabungan> listTabungan = PstDataTabungan.list(0, 0, null, null);
                                    for (DataTabungan dt : listTabungan) {
                                        String noTab = SessReportTabungan.getNomorTabungan("adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_SIMPANAN] + " = " + dt.getOID());
                                        String namaSimpanan = "?";
                                        try {
                                            namaSimpanan = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan()).getNamaSimpanan();
                                        } catch (Exception e) {
                                            
                                        }
                                        String selected = (dt.getOID() == idSimpanan) ? "selected" : "";
                                        out.print("<option "+selected+" value='"+dt.getOID()+"'>"+noTab+" ["+namaSimpanan+"]</option>");
                                    }
                                %>
                            </select>
                            
                            <div style="margin-top: 5px">
                                <input type="text" placeholder="No transaksi / keterangan" class="form-control" name="FRM_KEYWORD" value="<%= keyword %>">
                                <select class="form-control" name="FRM_RECORD">
                                    <option <%= (record == 10 ? "selected":"") %> value="10">10 data</option>
                                    <option <%= (record == 25 ? "selected":"") %> value="25">25 data</option>
                                    <option <%= (record == 50 ? "selected":"") %> value="50">50 data</option>
                                    <option <%= (record == 100 ? "selected":"") %> value="100">100 data</option>
                                    <option <%= (record == 0 ? "selected":"") %> value="0">Semua data</option>
                                </select>
                                <button type="button" onclick="javascript:cari()" id="btnSearch" class="btn btn-primary"><i class="fa fa-search"></i>&nbsp; Cari</button>
                            </div>
                        </form>
                            
                        <% if (listTransaksi.isEmpty()) { %>
                        <div>Tidak ada data transaksi ditemukan</div>
                        <% } else { %>

                        <table class="table table-bordered">
                            <tr>
                                <th style="width: 1%">No.</th>
                                <th>Tanggal Transaksi</th>
                                <th>Keterangan</th>
                                <th>Nomor Transaksi</th>
                                <th>Nilai Transaksi</th>
                                <th>Nama Nasabah</th>
                                <th>Nomor Tabungan</th>
                                <th>Status</th>
                            </tr>

                            <% int i=0; for (Transaksi t : listTransaksi) { i++;%>
                            <%
                                String noTab = "";
                                double nilaiTransaksi = 0;
                                Vector<DetailTransaksi> listDetail = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = " + t.getOID(), null);
                                for (DetailTransaksi dt : listDetail) {
                                    noTab = /*(t.getUsecaseType() == Transaksi.USECASE_TYPE_TABUNGAN_BUNGA_PENCATATAN) ? "-" :*/ SessReportTabungan.getNomorTabungan("adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_SIMPANAN] + " = " + dt.getIdSimpanan());
                                    nilaiTransaksi += dt.getKredit();
                                    nilaiTransaksi -= dt.getDebet();
                                }
                                nilaiTransaksi = (nilaiTransaksi < 0) ? nilaiTransaksi * -1 : nilaiTransaksi;
                                String nama = "";
                                AppUser user = new AppUser();
                                try {
                                    nama = /*(t.getUsecaseType() == Transaksi.USECASE_TYPE_TABUNGAN_BUNGA_PENCATATAN) ? "-" :*/ PstAnggota.fetchExc(t.getIdAnggota()).getName();
                                    user = PstAppUser.fetch(userOID);
                                } catch (Exception e) {

                                }
                                int tipeAnggota = cekTipeAnggota(t.getIdAnggota());
                                String link = "";
                                if (tipeAnggota == PstContactClass.CONTACT_TYPE_MEMBER) {
                                    link = "../../masterdata/anggota/anggota_tabungan.jsp?anggota_oid=" + t.getIdAnggota();
                                }
                                if (tipeAnggota == PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA) {
                                    link = "../../sedana/anggota/kelompok_tabungan.jsp?kelompok_id=" + t.getIdAnggota();
                                }

                                String status = Transaksi.STATUS_DOC_TRANSAKSI_TITLE[t.getStatus()].toUpperCase();
                                if (t.getStatus() == Transaksi.STATUS_DOC_TRANSAKSI_POSTED) {
                                    status = "<div style='color: red'>" + status + "</div>";
                                }
                            %>
                            <tr>
                                <td><%= i %>.</td>
                                <td><%= Formater.formatDate(t.getTanggalTransaksi(), "yyyy-MM-dd HH:mm:ss") %></td>
                                <td style="max-width: 200px"><%= t.getKeterangan() %></td>
                                <td><a href="javascript:detailTransaksi('<%= t.getOID() %>')"><%= t.getKodeBuktiTransaksi() %></a></td>
                                <td class="money text-right"><%= nilaiTransaksi %></td>
                                <td><a href="../../masterdata/anggota/anggota_edit.jsp?anggota_oid=<%= t.getIdAnggota() %>"><%= nama %></a></td>
                                <td><a href="<%= link %>"><%= noTab %></a></td>
                                <td class="text-center"><%= status %></td>
                            </tr>

                            <% if (aksi == Command.DETAIL) {%>
                            <tr>
                                <td></td>
                                <td colspan="7">
                                    <div class="table-responsive">
                                        <label>Detail :</label>
                                        <table class="table table-bordered" style="margin-bottom: 5px; width: 70%">
                                            <tr>
                                                <th style="width: 1%">No.</th>
                                                <th>Jenis Item</th>
                                                <th>Debet</th>
                                                <th>Kredit</th>
                                                <th>Informasi</th>
                                            </tr>
                                            <%
                                                Vector<DetailTransaksi> listDetailView = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = " + t.getOID(), null);
                                                if (listDetailView.isEmpty()) {
                                                    out.print("<tr>");
                                                    out.print("<td colspan='5' class='label-default text-center'>Tidak ada data</td>");
                                                    out.print("</tr>");
                                                }
                                                int j = 0;
                                                for (DetailTransaksi dt : listDetailView) {
                                                    j++;
                                                    String namaItem = PstJenisSimpanan.fetchExc(PstDataTabungan.fetchExc(dt.getIdSimpanan()).getIdJenisSimpanan()).getNamaSimpanan();
                                                    out.print("<tr>");
                                                    out.print("<td>" + j + ".</td>");
                                                    out.print("<td>" + namaItem + "</td>");
                                                    out.print("<td class='money text-right'>" + dt.getDebet() + "</td>");
                                                    out.print("<td class='money text-right'>" + dt.getKredit() + "</td>");
                                                    out.print("<td>" + dt.getDetailInfo() + "</td>");
                                                    out.print("</tr>");
                                                }
                                            %>
                                        </table>

                                        <label>Payment :</label>
                                        <table class="table table-bordered" style="width: 70%">
                                            <tr>
                                                <th style="width: 1%">No.</th>
                                                <th>Jenis Pembayaran</th>
                                                <th>Keterangan</th>
                                                <th>Nominal</th>
                                            </tr>
                                            <%
                                                Vector<TransaksiPayment> listPayment = PstTransaksiPayment.list(0, 0, PstTransaksiPayment.fieldNames[PstTransaksiPayment.FLD_TRANSAKSI_ID] + " = " + t.getOID(), null);
                                                if (listPayment.isEmpty()) {
                                                    out.print("<tr>");
                                                    out.print("<td colspan='4' class='label-default text-center'>Tidak ada data</td>");
                                                    out.print("</tr>");
                                                }
                                                int k = 0;
                                                for (TransaksiPayment tp : listPayment) {
                                                    k++;
                                                    String ket = "";
                                                    PaymentSystem p = new PaymentSystem();
                                                    try {
                                                        p = PstPaymentSystem.fetchExc(tp.getPaymentSystemId());
                                                        if (p.getPaymentType() == AngsuranPayment.TIPE_PAYMENT_SAVING) {
                                                            ket = "Nomor tabungan : ";
                                                        }
                                                    }catch(Exception e) {

                                                    }
                                                    out.print("<tr>");
                                                    out.print("<td>" + k + ".</td>");
                                                    out.print("<td>" + p.getPaymentSystem() + "</td>");
                                                    out.print("<td>" + ket + "</td>");
                                                    out.print("<td class='money text-right'>" + tp.getJumlah() + "</td>");
                                                    out.print("</tr>");
                                                }
                                            %>
                                        </table>
                                    </div>

                                    <% if (t.getStatus() == Transaksi.STATUS_DOC_TRANSAKSI_CLOSED && (user.getGroupUser() == AppUser.USER_GROUP_ADMIN || user.getGroupUser() == AppUser.USER_GROUP_HO_STAFF)) { %>
                                    <a class="btn btn-xs btn-default" id="btnDelete" onclick="deleteTransaction('<%= t.getOID() %>')">Hapus transaksi</a>
                                    <% } %>

                                    <% if (t.getUsecaseType() == Transaksi.USECASE_TYPE_TABUNGAN_SETORAN || t.getUsecaseType() == Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN || t.getUsecaseType() == Transaksi.USECASE_TYPE_TABUNGAN_PENUTUPAN) { %>
                                    <a class="btn btn-xs btn-default" style="cursor: pointer" onclick="printTransaction()">Cetak Transaksi</a>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>

                            <% } %>

                        </table>
                            <div style="margin-top: 5px">Menampilkan <%= Formater.formatNumber(result, "#,###") %> dari <%= Formater.formatNumber(listRecord, "#,###") %> data</div>

                        <div class="text-center" style="background-color: yellow"><%= message %></div>

                        <hr style="margin: 10px 0px; border-color: lightgray">
                        <label>Keterangan :</label>
                        <table style="font-size: 14px">
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_TABUNGAN_SETORAN %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi setoran tabungan</td>
                            </tr>
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_TABUNGAN_PENARIKAN %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi penarikan tabungan</td>
                            </tr>
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_TABUNGAN_PENCATATAN_BUNGA %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi pencatatan bunga tabungan</td>
                            </tr>
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_TABUNGAN_PENCATATAN_POTONGAN_ADMIN %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi pencatatan biaya admin bulanan</td>
                            </tr>
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_TABUNGAN_PENUTUPAN %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi penutupan tabungan</td>
                            </tr>
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_TABUNGAN_PENARIKAN_PENGENDAPAN_KREDIT %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi penarikan otomatis dana pengendapan dari tabungan wajib (saat penutupan kredit)</td>
                            </tr>
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_TABUNGAN_SETORAN_PENGENDAPAN_KREDIT %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi penambahan otomatis dana pengendapan ke tabungan sukarela (saat penutupan kredit)</td>
                            </tr>
                        </table>
                        <% } %>
                    </div>
                </div>
                
                <a href="list_transaksi_tabungan.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>
                <p></p>
                <% if (showHistory == 1) { %>
                <div class="box box-default">
                    <div class="box-header">
                        <h3 class="box-title">Riwayat Perubahan</h3>
                    </div>
                    <div class="box-body">
                        <%
                            JSONObject obj = new JSONObject();
                            JSONArray arr = new JSONArray();
                            arr.put(SessHistory.document[SessHistory.DOC_TRANSAKSI_TABUNGAN]);
                            obj.put("doc", arr);
                            obj.put("time", "");
                            request.setAttribute("obj", obj);
                        %>
                        <%@ include file = "/history_log/history_table.jsp" %>
                    </div>
                </div>
                <% } %>

            </section>
        </div>
        
    <print-area>
        <%
            Transaksi tt = new Transaksi();
            CashTeller ct = new CashTeller();
            AppUser au = new AppUser();
            Anggota aa = new Anggota();
            try {
                tt = PstTransaksi.fetchExc(idTransaksi);
                ct = PstCashTeller.fetchExc(tt.getTellerShiftId());
                au = PstAppUser.fetch(ct.getAppUserId());
                aa = PstAnggota.fetchExc(tt.getIdAnggota());
            } catch (Exception e) {
            }
        %>
        <% if (tt.getUsecaseType() == Transaksi.USECASE_TYPE_TABUNGAN_SETORAN || tt.getUsecaseType() == Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN || tt.getUsecaseType() == Transaksi.USECASE_TYPE_TABUNGAN_PENUTUPAN) { %>
        <div style="width: 100%">
            <div style="width: 70%; float: left;">
                <strong style="width: 100%; display: inline-block;"><%=compName%></strong>
                <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                <span style="width: 100%; display: inline-block;"><%=compPhone%></span>
                <span style="width: 100%; display: inline-block;">-</span>
            </div>
            <div style="width: 30%; float: right;">
                <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">TRANSAKSI TABUNGAN</span>
                <span style="width: 100%; display: inline-block; font-size: 12px;"><%=Master.date2String(tt.getTanggalTransaksi(), "dd/MM/yyyy HH:mm:ss")%></span>
                <span style="width: 100%; display: inline-block; font-size: 12px;">User: <%=au.getFullName()%></span>
                <span style="width: 100%; display: inline-block; font-size: 12px;">No Transaksi: <%=tt.getKodeBuktiTransaksi()%></span>
            </div>
        </div>
        <div class="clearfix"></div>
        <hr class="" style="border-color: gray">
        <strong style="width: 100%; display: inline-block; padding-top: 0px;">JENIS TRANSAKSI&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;<%= Transaksi.USECASE_TYPE_TITLE.get(tt.getUsecaseType()).toUpperCase() %></strong>
        <div style="width: 100%; padding-top:10px;">
            <div style="width: 50%;float: left;">
                <div>
                    <span style="width: 100px; float: left;">No Tabungan</span>
                    <span style="width: calc(100% - 100px); float: right;">:&nbsp;&nbsp; <%= SessReportTabungan.getNomorTabungan("t."+PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + "="+tt.getOID() ) %></span>
                </div>
                <div>
                    <span style="width: 100px; float: left;">Nama Nasabah</span>
                    <span style="width: calc(100% - 100px); float: right;">:&nbsp;&nbsp; <%= aa.getName()%></span>
                </div>
            </div>
            <div style="width: 50%;float: left;"></div>
        </div>
        <div class="clearfix"></div>
        <div style="width:100%;padding-top: 20px;">
            <div style="width: 50%;float: left;">
                <%
                    Vector<DetailTransaksi> listDetail = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = " + tt.getOID(), "");
                    double totalTransaksi = 0;
                %>
                <table>
                    <%
                        for (DetailTransaksi dt : listDetail) {
                            totalTransaksi += dt.getKredit();
                            totalTransaksi -= dt.getDebet();
                            String namaItem = "";
                            try {
                                DataTabungan simpanan = PstDataTabungan.fetchExc(dt.getIdSimpanan());
                                namaItem = PstJenisSimpanan.fetchExc(simpanan.getIdJenisSimpanan()).getNamaSimpanan();
                            } catch (Exception e) {
                                
                            }
                    %>
                    <tr>
                        <td><%= namaItem %></td>
                        <td>&nbsp;&nbsp;&nbsp; : &nbsp;&nbsp;&nbsp;</td>
                        <td class="money"><%= dt.getDebet() + dt.getKredit() %></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>
            <div style="width: 50%;float: right;">
                <%
                    long longTotal = (long) (totalTransaksi);
                    String output = "";
                    if (longTotal == 0) {
                        output = "Nol rupiah.";
                    } else if (longTotal < 0) {
                        longTotal *= -1;
                        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                        String con = convert.getText() + " rupiah.";
                        output = con.substring(0, 1).toUpperCase() + con.substring(1);
                    } else {
                        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                        String con = convert.getText() + " rupiah.";
                        output = con.substring(0, 1).toUpperCase() + con.substring(1);
                    }
                %>
                <table>
                    <tr>
                        <td style="width: 100px">Total</td>
                        <td style="width: 10px">:</td>
                        <td class="money"><%=String.format("%d", (long) longTotal)%></td>
                    </tr>
                    <tr>
                        <td style="vertical-align: text-top">Terbilang</td>
                        <td style="vertical-align: text-top">:</td>
                        <td style="vertical-align: text-top"><%=output%></td>
                    </tr>
                    <tr>
                        <td>Keterangan</td>
                        <td>:</td>
                        <td><%= tt.getKeterangan() %></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="clearfix"></div>
        <div style="width: 100%;padding-top: 40px;">
            <div style="width: 50%;float: left;text-align: center;">
                <span>Petugas</span>
                <br><br><br><br>
                <span>(&nbsp; . . . . . . . . . . . . . &nbsp;)</span>
            </div>
            <div style="width: 50%;float: right;text-align: center;">
                <span>Nasabah</span>
                <br><br><br><br>
                <span>(&nbsp; . . . . . . . . . . . . . &nbsp;)</span>
            </div>
        </div>
        <div class="clearfix"></div>
        <div style="width: 100%;padding-top: 30px;">User Cetak : <%= userFullName %></div>
        <% } %>
    </print-area>
        
    </body>
    <script>
        $(document).ready(function () {
            
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
                
            function selectMulti(id, placeholder) {
                $(id).select2({
                    placeholder: placeholder
                });
            }

            selectMulti('.select2nasabah', "Nama nasabah");
            selectMulti('.select2transaksi', "Jenis transaksi");
            selectMulti('.select2tabungan', "Nomor tabungan");

        });
    </script>
</html>
