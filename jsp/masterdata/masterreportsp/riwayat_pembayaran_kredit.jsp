<%-- 
    Document   : riwayat_pembayaran_kredit
    Created on : Apr 30, 2019, 8:59:26 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstJangkaWaktu"%>
<%@page import="com.dimata.sedana.entity.masterdata.JangkaWaktu"%>
<%@page import="com.dimata.pos.entity.billing.PstBillDetail"%>
<%@page import="com.dimata.pos.entity.billing.Billdetail"%>
<%@page import="com.dimata.pos.entity.billing.PstBillMain"%>
<%@page import="com.dimata.pos.entity.billing.BillMain"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.Angsuran"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="com.dimata.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_REPORT, AppObjInfo.OBJ_RIWAYAT_PEMBAYARAN_KREDIT); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privUpdate && !privDelete){
	response.sendRedirect(approot + "/nopriv.html"); 
}
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
%>
<%//
    int iCommand = FRMQueryString.requestCommand(request);
    String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA");
    long idPinjaman = FRMQueryString.requestLong(request, "KREDIT_ID");

    ArrayList<ArrayList> listPembayaran = new ArrayList();
    Pinjaman pinjaman = new Pinjaman();
    Anggota anggota = new Anggota();
    if (iCommand == Command.LIST) {
        try {
            pinjaman = PstPinjaman.fetchExc(idPinjaman);
            anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
            String nomorKredit = pinjaman.getNoKredit();
            listPembayaran = SessReportKredit.listRiwayatAngsuranKredit(nomorKredit);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    Vector listLocation = PstLocation.getListFromApiAll();
    String optLocation = "";
    for (int i = 0; i < listLocation.size(); i++) {
        Location loc = (Location) listLocation.get(i);
        boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+loc.getOID());
        if (loc.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
            optLocation += "<option value='" + loc.getOID() + "'>" + loc.getName() + "</option>";
        }
    }

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@ include file = "/style/style_kredit.jsp" %>
        <style>
            table {font-size: 14px}
            .tabel_header td {
                padding-right: 10px;
                padding-bottom: 3px;
                vertical-align: text-top;
            }
        </style>
        <script>
            $(document).ready(function () {
                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };
                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables, param) {
                    var datafilter = "";
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({
                        "bDestroy": true,
                        "searching": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "order": [[0, 'asc']],
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
                                        "sLast ": "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                        "sNext ": "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                        "sPrevious ": "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                            }
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&" + param,
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
                        },
                        "fnDrawCallback": function (oSettings) {
                            if (callBackDataTables !== null) {
                                callBackDataTables();
                            }
                        },
                        "fnPageChange": function (oSettings) {

                        }
                    });
                    $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                    $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                    $("#" + elementId).css("width", "100%");
                }
                
                function runDataTable() {
                    dataTablesOptions("#table-konsumen-parent", "table-konsumen", "AjaxKredit", "listRiwayatKonsumen", null, $('#FORM_PARAM_CARI_KONSUMEN').serialize());
                }
                
                let modalKonsumen = $('#modal-cari-konsumen');
                modalSetting('#modal-cari-konsumen', 'static', false, false);
                
                
                $(".select2").select2();
                $('#btnPrint').click(function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.print();
                    $(this).removeAttr('disabled').html(buttonHtml);
                });
                
                $('#form_cari').submit(function () {
                    $('.btn-search').attr({"disabled": "true"}).html("Tunggu...");
                });
                
                $('body').on('click', '#cari-riwayat', function(){
                    let idKonsumen = $('#idKonsumen').val();
                    if(idKonsumen == 0){
                        alert('<%= namaNasabah %> tidak ada.');
                    } else {
                        $('#form_cari').submit(); 
                    }
                });
                
                $('body').on('click', '#cari-konsumen-btn', function(){
                    modalKonsumen.find('.modal-header .judul').html('Daftar <%= namaNasabah %>');
                    modalKonsumen.modal('show');
                });
                
                $('body').on('change', '#select-lokasi-konsumen', function(){
                   runDataTable(); 
                });
                
                modalKonsumen.on('shown.bs.modal', function(){
                    runDataTable();
                });
                
                $('body').on('click', '.pilih-konsumen', function(){
                    let idKredit = $(this).data('pinjaman');
                    let namaKredit = $(this).data('konsumen');
                    
                    $('#idKonsumen').val(idKredit);
                    $('#KREDIT_NAME').val(namaKredit);
                    
                    modalKonsumen.modal('hide');
                });
            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    Laporan Mutasi Angsuran Kredit
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Laporan</li>
                    <li class="active">Kredit</li>
                </ol>
            </section>

            <section class="content">
                <div class="box box-success">
                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Pencarian</h3>
                    </div>
                    <div class="box-body">
                        <form id="form_cari" method="post" action="?command=<%=Command.LIST%>">
                            <input type="hidden" id="idKonsumen" name="KREDIT_ID" value="<%= pinjaman.getOID() %>">
                            <div class="row">
                                <!--Sisi Kiri-->
                                <div class="col-sm-4">
                                    <div class="form-group">
                                        <label class="control-label col-sm-3"><%= namaNasabah%></label>
                                        <div class="col-sm-9">
                                            <div class="input-group input-group-sm">
                                                <input type="text" required="" placeholder="Pilih Konsumen"
                                                       class="input-sm form-control" id="KREDIT_NAME" value="<%= anggota.getName() %>" readonly="">
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-success btn-flat" id="cari-konsumen-btn"><i class="fa fa-search"></i></button>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!--Sisi tengah-->    
                                <div class="col-sm-4"></div>
                                <!--Sisi kanan-->
                                <div class="col-sm-4"></div>
                            </div>
                        </form>
                    </div>
                    <div class="box-footer">
                        <button type="button" id="cari-riwayat" class="btn btn-sm btn-primary btn-search"><i class="fa fa-search"></i>&nbsp; Cari</button>
                    </div>
                </div>

                <% if (iCommand == Command.LIST) {%>

                <%
                    String noKredit = "";
                    String nama = "";
                    double jumlahPinjaman = 0;
                    String alamat = "";
                    String jatuhTempo = "";
                    String tglLunas = "";
                    double sukuBunga = 0;
                    int jangkaWaktu = 0;
                    String tipeFrekuensi = "";
                    String namaBarang = "";
                    BillMain bm = new BillMain();
                    Billdetail bd = new Billdetail();
                    JangkaWaktu jk = new JangkaWaktu();
                    double dp=0;
                    double jmlAngsuran=0;
                    
                    String isLunas = "Belum Lunas";
                    double jumlahDibayar = 0;
                    for (ArrayList al : listPembayaran) {
                        Pinjaman p = (Pinjaman) al.get(0);
                        Transaksi t = (Transaksi) al.get(2);
                        Angsuran c = (Angsuran) al.get(3);
                        Angsuran angsuranDp = (Angsuran) al.get(5);
                        jumlahDibayar += p.getJumlahAngsuran() + angsuranDp.getJumlahAngsuran() + c.getJumlahAngsuran();
                    }
                    
                    Vector listJa = PstJadwalAngsuran.list(0, 0, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]+"="+idPinjaman, "");
                    for (int i=0; i < listJa.size(); i++){
                        JadwalAngsuran jadwalAngsuran = (JadwalAngsuran) listJa.get(i);
                        jumlahPinjaman += jadwalAngsuran.getJumlahANgsuran();
                    }
                    
                    for (ArrayList al : listPembayaran) {
                        Pinjaman p = (Pinjaman) al.get(0);
                        Anggota a = (Anggota) al.get(1);
                        JenisKredit k = (JenisKredit) al.get(4);
                        try {
                            bm = PstBillMain.fetchExc(p.getBillMainId());
                            jk = PstJangkaWaktu.fetchExc(p.getJangkaWaktuId());
                          } catch (Exception e) {
                          }
                        noKredit = p.getNoKredit();
                        nama = a.getName();
                        //jumlahPinjaman = p.getJumlahPinjaman();
                        alamat = a.getAddressPermanent();
                        jatuhTempo = Formater.formatDate(p.getJatuhTempo(), "dd MMMM yyyy");
                        tglLunas = p.getTglLunas() != null ? Formater.formatDate(p.getTglLunas(), "dd MMMM yyyy") : isLunas;
                        sukuBunga = p.getSukuBunga();
                        jangkaWaktu = p.getJangkaWaktu();
                        namaBarang = bm.getItemName();
                        String arrayTipeFrekuensi[] = Transaksi.TIPE_KREDIT.get(k.getTipeFrekuensiPokokLegacy());
                        tipeFrekuensi = arrayTipeFrekuensi[SESS_LANGUAGE];
                        
                        String whereDp = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]+"="+p.getOID() + " AND "+PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]+"="+JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT;
                        String wherePokok = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]+"="+p.getOID() + " AND "+PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]+"="+JadwalAngsuran.TIPE_ANGSURAN_POKOK;
                        String whereBunga = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]+"="+p.getOID() + " AND "+PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]+"="+JadwalAngsuran.TIPE_ANGSURAN_BUNGA;
                        Vector listDp = PstJadwalAngsuran.list(0, 1, whereDp, "");
                        if (listDp.size()>0){
                            JadwalAngsuran ja = (JadwalAngsuran) listDp.get(0);
                            dp = ja.getJumlahANgsuran();
                        }
                        Vector listPokok = PstJadwalAngsuran.list(0, 1, wherePokok, "");
                        if (listPokok.size()>0){
                            JadwalAngsuran ja = (JadwalAngsuran) listPokok.get(0);
                            jmlAngsuran += ja.getJumlahANgsuran();
                        }
                        Vector listBunga = PstJadwalAngsuran.list(0, 1, whereBunga, "");
                        if (listBunga.size()>0){
                            JadwalAngsuran ja = (JadwalAngsuran) listBunga.get(0);
                            jmlAngsuran += ja.getJumlahANgsuran();;
                        }
                        
                        break;
                        
                    }
                %>

                <div class="box box-success">
                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Laporan Mutasi Angsuran Kredit</h3>
                    </div>
                    <div class="box-body">
                        <div class="row">
                            <div class="col-sm-6">
                                <table class="tabel_header">
                                    <tr>
                                        <td>Nomor Kredit</td>
                                        <td>:</td>
                                        <td><%= noKredit%></td>
                                    </tr>
                                    <tr>
                                        <td>Nama</td>
                                        <td>:</td>
                                        <td><%= nama%></td>
                                    </tr>
                                    <tr>
                                        <td>Alamat</td>
                                        <td>:</td>
                                        <td><%= alamat%></td>
                                    </tr>
                                    <%if(useForRaditya.equals("1")){%>
                                    <tr>
                                        <td>Nama Barang</td>
                                        <td>:</td>
                                        <%
                                            Vector listItem = PstBillDetail.list(0, 0, PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + bm.getOID(), "");
                                            for (int i = 0; i < listItem.size(); i++) {
                                                bd = (Billdetail) listItem.get(i);
                                        %>
                                        <% if (listItem.size() > 1) {%>
                                        <td><%= bd.getItemName()%>,</td>
                                        <%} else {%>
                                        <td><%= bd.getItemName()%></td>
                                        <%}
                                            }%>
                                    </tr>
                                  <%}else{%>
                                    <tr>
                                        <td>Suku Bunga</td>
                                        <td>:</td>
                                        <td><%= sukuBunga%> % / Tahun</td>
                                    </tr>
                                  <%}%>
                                    <tr>
                                        <td>Jangka Waktu</td>
                                        <td>:</td>
                                        <td><%= jangkaWaktu%> <%= tipeFrekuensi%></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-sm-6">
                                <table class="tabel_header">
                                    <tr>
                                        <td>Total Kredit/Angsuran</td>
                                        <td>:</td>
                                        <td><span class="money"><%= jumlahPinjaman%></span></td>
                                    </tr>
                                    <tr>
                                        <td>DP</td>
                                        <td>:</td>
                                        <td><span class="money"><%= dp%></span></td>
                                    </tr>
                                    <tr>
                                        <td>Angsuran</td>
                                        <td>:</td>
                                        <td><span class="money"><%= jmlAngsuran%></span></td>
                                    </tr>
                                    <tr>
                                        <td>Saldo Kredit/Angsuran</td>
                                        <td>:</td>
                                        <td><span class="money"><%= jumlahPinjaman - jumlahDibayar%></span></td>
                                    </tr>
                                    <tr>
                                        <td>Jatuh Tempo</td>
                                        <td>:</td>
                                        <td><%= jatuhTempo%></td>
                                    </tr>
                                    <tr>
                                        <td>Tanggal Lunas</td>
                                        <td>:</td>
                                        <td><%= tglLunas%></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <p></p>
                        <div class="table-responsive">
                          <%if(useForRaditya.equals("1")){%>
                            <table class="table table-bordered table-hover">
                                <tr>
                                    <th>No.</th>
                                    <th>Nomor Transaksi</th>
                                    <th>Tanggal Bayar</th>
                                    <th>Angsuran Dibayar</th>
                                    <th>Total Bayar</th>
                                    <th>Diskon</th>
                                    <th>Sisa Angsuran</th>
                                    <th>Keterangan</th>
                                </tr>

                                <% if (listPembayaran.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center label-default">Tidak ada data pembayaran</td>
                                </tr>
                                <% } %>

                                <%
                                    double totalPokokDibayar = 0;
                                    double totalBungaDiBayar = 0;
                                    double totalDpDibayar = 0;
                                    int no = 0;
                                    for (ArrayList al : listPembayaran) {
                                        Pinjaman p = (Pinjaman) al.get(0);
                                        Transaksi t = (Transaksi) al.get(2);
                                        Angsuran angsuran = (Angsuran) al.get(3);
                                        Angsuran angsuranDp = (Angsuran) al.get(5);

                                        no++;
                                        String tglBayar = Formater.formatDate(t.getTanggalTransaksi(), "yyyy-MM-dd HH:mm:ss");
                                        double pokokDibayar = p.getJumlahAngsuran();
                                        double dpDibayar = angsuranDp.getJumlahAngsuran();
                                        double bungaDibayar = angsuran.getJumlahAngsuran();
                                        double disc = angsuran.getDiscAmount();
                                        double totalBayar = pokokDibayar + bungaDibayar + dpDibayar;
                                        totalPokokDibayar += pokokDibayar;
                                        totalBungaDiBayar += bungaDibayar;
                                        totalDpDibayar += dpDibayar;
                                        double sisaPokok = jumlahPinjaman - totalPokokDibayar - totalBungaDiBayar - totalDpDibayar;
                                        if (dpDibayar > 0){
                                            t.setKeterangan("Pembayaran DP");
                                        }
                                %>

                                <tr>
                                    <td style="width: 1%"><%= no%>.</td>
                                    <td><%= t.getKodeBuktiTransaksi()%></td>
                                    <td><%= tglBayar%></td>
                                    <td class="money text-right"><%= pokokDibayar + bungaDibayar + dpDibayar %></td>
                                    <td class="money text-right"><%= totalBayar - disc%></td>
                                    <td class="money text-right"><%= disc%></td>
                                    <td class="money text-right"><%= sisaPokok%></td>
                                    <td><%= t.getKeterangan()%></td>
                                </tr>

                                <%
                                    }
                                %>

                            </table>
                          <%}else{%>
                          <table class="table table-bordered table-hover">
                                <tr>
                                    <th>No.</th>
                                    <th>Nomor Transaksi</th>
                                    <th>Tanggal Bayar</th>
                                    <th>Pokok Dibayar</th>
                                    <th>Bunga Dibayar</th>
                                    <th>Total Bayar</th>
                                    <th>Sisa Pokok</th>
                                    <th>Keterangan</th>
                                </tr>

                                <% if (listPembayaran.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center label-default">Tidak ada data pembayaran</td>
                                </tr>
                                <% } %>

                                <%
                                    double totalPokokDibayar = 0;
                                    double totalBungaDiBayar = 0;
                                    int no = 0;
                                    for (ArrayList al : listPembayaran) {
                                        Pinjaman p = (Pinjaman) al.get(0);
                                        Transaksi t = (Transaksi) al.get(2);
                                        Angsuran angsuran = (Angsuran) al.get(3);
                                        Angsuran angsuranDp = (Angsuran) al.get(5);

                                        no++;
                                        String tglBayar = Formater.formatDate(t.getTanggalTransaksi(), "yyyy-MM-dd HH:mm:ss");
                                        double pokokDibayar = p.getJumlahAngsuran();
                                        double dpDibayar = angsuranDp.getJumlahAngsuran();
                                        double bungaDibayar = angsuran.getJumlahAngsuran();
                                        double totalBayar = pokokDibayar + bungaDibayar + dpDibayar;
                                        totalPokokDibayar += pokokDibayar;
                                        totalBungaDiBayar += bungaDibayar;
                                        double sisaPokok = p.getJumlahPinjaman() - totalPokokDibayar - totalBungaDiBayar - dpDibayar;
                                %>

                                <tr>
                                    <td style="width: 1%"><%= no%>.</td>
                                    <td><%= t.getKodeBuktiTransaksi()%></td>
                                    <td><%= tglBayar%></td>
                                    <td class="money text-right"><%= pokokDibayar%></td>
                                    <td class="money text-right"><%= bungaDibayar%></td>
                                    <td class="money text-right"><%= totalBayar%></td>
                                    <td class="money text-right"><%= sisaPokok%></td>
                                    <td><%= t.getKeterangan()%></td>
                                </tr>

                                <%
                                    }
                                %>

                            </table>
                          <%}%>

                        </div>
                                
                        <% if (!listPembayaran.isEmpty()) { %>
                        <button type="button" id="btnPrint" class="btn btn-sm btn-primary"><i class="fa fa-file-text"></i>&nbsp; Cetak</button>
                        <% } %>
                    </div>
                </div>

                <% }%>
            </section>
        </div>

        <div class="example-modal">
            <div class="modal fade" id="modal-cari-konsumen" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header" style="background-color: #00A65A; color: white;">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span></button>
                            <h3 class="modal-title judul">Judul</h3>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <form id="FORM_PARAM_CARI_KONSUMEN">
                                    <div class="col-sm-12">
                                        <div class="col-sm-4"></div>
                                        <div class="col-sm-4">
                                            <div class="center">
                                                <select class="form-control input-sm select2" id="select-lokasi-konsumen" name="FRM_FIELD_LOCATION_OID" style="width: 100%">
                                                    <%= optLocation%>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-sm-4"></div>
                                    </div>
                                </form>
                            </div>
                            <br>
                            <div class="row">
                                <div class="col-sm-12">
                                    <div id="table-konsumen-parent">
                                        <table id="table-konsumen" class="table table-striped table-bordered table-responsive">
                                            <thead>
                                                <tr>
                                                    <td class="text-center"  style="width: 10%">No.</td>
                                                    <td class="text-center" style="width: 15%">Nomor Kredit</td>
                                                    <td class="text-center" style="width: 20%">Nama <%= namaNasabah %></td>
                                                    <td class="text-center"  style="width: 15%">Jenis Kredit</td>
                                                    <td class="text-center"  style="width: 15%">Pinjaman</td>
                                                    <td class="text-center"  style="width: 10%">Status<br>Pinjaman</td>
                                                    <td class="text-center"  style="width: 10%">Status<br>Pengiriman</td>
                                                    <td class="text-center"  style="width: 10%">Aksi</td>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
            
            
            
            
            
            
    </body>
    <% if (iCommand == Command.LIST) {%>
    
    <%
        String noKredit = "";
        String nama = "";
        double jumlahPinjaman = 0;
        String alamat = "";
        String jatuhTempo = "";
        String tglLunas = "";
        double sukuBunga = 0;
        int jangkaWaktu = 0;
        String tipeFrekuensi = "";
        String namaBarang = "";
        Billdetail bd = new Billdetail();
        BillMain bm = new BillMain();
        JangkaWaktu jk = new JangkaWaktu();
        double dp=0;
        double jmlAngsuran=0;
        
        String isLunas = "Belum Lunas";
        double jumlahDibayar = 0;
        for (ArrayList al : listPembayaran) {
            Pinjaman p = (Pinjaman) al.get(0);
            Transaksi t = (Transaksi) al.get(2);
            Angsuran angsuran = (Angsuran) al.get(3);
            Angsuran angsuranDp = (Angsuran) al.get(5);
            jumlahDibayar += p.getJumlahAngsuran() + angsuranDp.getJumlahAngsuran();

            if (p.getJumlahPinjaman() == jumlahDibayar){
                isLunas = Formater.formatDate(t.getTanggalTransaksi(), "dd MMMM yyyy");
            }

        }
        
        for (ArrayList al : listPembayaran) {
            Pinjaman p = (Pinjaman) al.get(0);
            Anggota a = (Anggota) al.get(1);
            JenisKredit k = (JenisKredit) al.get(4);
            try {
                bm = PstBillMain.fetchExc(p.getBillMainId());
                jk = PstJangkaWaktu.fetchExc(p.getJangkaWaktuId());
              } catch (Exception e) {
              }
            noKredit = p.getNoKredit();
            nama = a.getName();
            jumlahPinjaman = p.getJumlahPinjaman();
            alamat = a.getAddressPermanent();
            jatuhTempo = Formater.formatDate(p.getJatuhTempo(), "dd MMMM yyyy");
            tglLunas = p.getTglLunas() != null ? Formater.formatDate(p.getTglLunas(), "dd MMMM yyyy") : isLunas;
            sukuBunga = p.getSukuBunga();
            jangkaWaktu = p.getJangkaWaktu();
            namaBarang = bm.getItemName();
            String arrayTipeFrekuensi[] = Transaksi.TIPE_KREDIT.get(k.getTipeFrekuensiPokokLegacy());
            tipeFrekuensi = arrayTipeFrekuensi[SESS_LANGUAGE];
            
            String whereDp = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]+"="+p.getOID() + " AND "+PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]+"="+JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT;
            String wherePokok = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]+"="+p.getOID() + " AND "+PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]+"="+JadwalAngsuran.TIPE_ANGSURAN_POKOK;
            String whereBunga = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]+"="+p.getOID() + " AND "+PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]+"="+JadwalAngsuran.TIPE_ANGSURAN_BUNGA;
            Vector listDp = PstJadwalAngsuran.list(0, 1, whereDp, "");
            if (listDp.size()>0){
                JadwalAngsuran ja = (JadwalAngsuran) listDp.get(0);
                dp = ja.getJumlahANgsuran();
            }
            Vector listPokok = PstJadwalAngsuran.list(0, 1, wherePokok, "");
            if (listPokok.size()>0){
                JadwalAngsuran ja = (JadwalAngsuran) listPokok.get(0);
                jmlAngsuran += ja.getJumlahANgsuran();
            }
            Vector listBunga = PstJadwalAngsuran.list(0, 1, whereBunga, "");
            if (listBunga.size()>0){
                JadwalAngsuran ja = (JadwalAngsuran) listBunga.get(0);
                jmlAngsuran += ja.getJumlahANgsuran();;
            }
            break;
        }
    %>
    
    <print-area style="size: A5">
        <div style="width: 50%; float: left;">
            <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
            <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
            <span style="width: 100%; display: inline-block;"><%=compPhone%></span>                    
        </div>
        <div style="width: 50%; float: right; text-align: right">
            <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">LAPORAN MUTASI ANGSURAN KREDIT</span>
            <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal : <%=Formater.formatDate(new Date(), "dd MMM yyyy / HH:mm:ss")%></span>                    
            <span style="width: 100%; display: inline-block; font-size: 12px;">Admin : <%=userName%></span>                    
        </div>
        <div class="clearfix"></div>
        <hr class="" style="border-color: gray">  
        <div style="width: 50%; float: left;">
            <table class="tabel_header" style="font-size: 10px">
                <tr>
                    <td>Nomor Kredit</td>
                    <td>:</td>
                    <td><%= noKredit%></td>
                </tr>
                <tr>
                    <td>Nama</td>
                    <td>:</td>
                    <td><%= nama%></td>
                </tr>
                <tr>
                    <td>Alamat</td>
                    <td>:</td>
                    <td><%= alamat%></td>
                </tr>
                <%if(useForRaditya.equals("1")){%>
                <tr>
                    <td>Nama Barang</td>
                    <td>:</td>
                    <%
                        Vector listItem = PstBillDetail.list(0, 0, PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + bm.getOID(), "");
                        for (int i = 0; i < listItem.size(); i++) {
                            bd = (Billdetail) listItem.get(i);
                    %>
                    <% if (listItem.size() > 1) {%>
                    <td><%= bd.getItemName()%>,</td>
                    <%} else {%>
                    <td><%= bd.getItemName()%></td>
                    <%}
                        }%>
                </tr>
              <%}else{%>
                <tr>
                    <td>Suku Bunga</td>
                    <td>:</td>
                    <td><%= sukuBunga%> % / Tahun</td>
                </tr>
              <%}%>
                <tr>
                    <td>Jangka Waktu</td>
                    <td>:</td>
                    <td><%= jangkaWaktu%> <%= tipeFrekuensi%></td>
                </tr>
            </table>
            </div>
            <div class="col-sm-6">
                <table class="tabel_header" style="font-size: 10px">
                    <tr>
                        <td>Total Kredit/Angsuran</td>
                        <td>:</td>
                        <td><span class="money"><%= jumlahPinjaman%></span></td>
                    </tr>
                    <tr>
                        <td>DP</td>
                        <td>:</td>
                        <td><span class="money"><%= dp%></span></td>
                    </tr>
                    <tr>
                        <td>Angsuran</td>
                        <td>:</td>
                        <td><span class="money"><%= jmlAngsuran%></span></td>
                    </tr>
                    <tr>
                        <td>Saldo Kredit/Angsuran</td>
                        <td>:</td>
                        <td><span class="money"><%= jumlahPinjaman + dp - jumlahDibayar%></span></td>
                    </tr>
                    <tr>
                        <td>Jatuh Tempo</td>
                        <td>:</td>
                        <td><%= jatuhTempo%></td>
                    </tr>
                    <tr>
                        <td>Tanggal Lunas</td>
                        <td>:</td>
                        <td><%= tglLunas%></td>
                    </tr>
                </table>
            </table>
        </div>
        <div class="clearfix"></div>
        <br>
        <style>
            .tabel_print {width: 100%}
            
            .tabel_print th {
                padding: 5px !important;
                border-style: solid;
                border-width: thin;
                border-color: lightgray;
                border-right: none;
                border-left: none;
                white-space: nowrap;
            }
            
            .tabel_print td {
                padding: 5px;
                border-style: solid;
                border-width: thin;
                border-color: lightgray;
                border-right: none;
                border-left: none;
                vertical-align: text-top
            }
            
        </style>
        <label style="font-size: 10px">Transaksi pembayaran :</label>
        <%if(useForRaditya.equals("1")){%>
        <table class="tabel_print" style="font-size: 10px">
            <tr>
                <th class="text-left">No.</th>
                <th class="text-left">Nomor Transaksi</th>
                <th class="text-left">Tanggal Bayar</th>
                <th class="text-right">Angsuran Dibayar</th>
                <th class="text-right">Total Bayar</th>
                <th class="text-right">Sisa Angsuran</th>
                <th class="text-left">Keterangan</th>
            </tr>

            <% if (listPembayaran.isEmpty()) { %>
            <tr>
                <td colspan="8" class="text-center label-default">Tidak ada data pembayaran</td>
            </tr>
            <% } %>

            <%
                double totalPokokDibayar = 0;
                double totalDpDibayar = 0;
                double totalBungaDibayar = 0;
                int no = 0;
                for (ArrayList al : listPembayaran) {
                    Pinjaman p = (Pinjaman) al.get(0);
                    Transaksi t = (Transaksi) al.get(2);
                    Angsuran angsuran = (Angsuran) al.get(3);
                    Angsuran angsuranDp = (Angsuran) al.get(5);

                    no++;
                    String tglBayar = Formater.formatDate(t.getTanggalTransaksi(), "yyyy-MM-dd HH:mm:ss");
                    double pokokDibayar = p.getJumlahAngsuran();
                    double dpDibayar = angsuranDp.getJumlahAngsuran();
                    double bungaDibayar = angsuran.getJumlahAngsuran();
                    double totalBayar = pokokDibayar + bungaDibayar + dpDibayar;
                    totalPokokDibayar += pokokDibayar;
                    totalDpDibayar += dpDibayar;
                    totalBungaDibayar += bungaDibayar;
                    double sisaPokok = p.getJumlahPinjaman() - totalPokokDibayar - totalBungaDibayar - totalDpDibayar;
            %>

            <tr>
                <td style="width: 1%"><%= no%>.</td>
                <td style="white-space: nowrap"><%= t.getKodeBuktiTransaksi()%></td>
                <td style="white-space: nowrap"><%= tglBayar%></td>
                <td class="money text-right"><%= pokokDibayar + bungaDibayar + dpDibayar %></td>
                <td class="money text-right"><%= totalBayar%></td>
                <td class="money text-right"><%= sisaPokok%></td>
                <td><%= t.getKeterangan()%></td>
            </tr>

            <%
                }
            %>

        </table>
        <%}else{%>
        <table class="tabel_print" style="font-size: 10px">
            <tr>
                <th class="text-left">No.</th>
                <th class="text-left">Nomor Transaksi</th>
                <th class="text-left">Tanggal Bayar</th>
                <th class="text-right">Pokok Dibayar</th>
                <th class="text-right">Bunga Dibayar</th>
                <th class="text-right">Total Bayar</th>
                <th class="text-right">Sisa Pokok</th>
                <th class="text-left">Keterangan</th>
            </tr>

            <% if (listPembayaran.isEmpty()) { %>
            <tr>
                <td colspan="8" class="text-center label-default">Tidak ada data pembayaran</td>
            </tr>
            <% } %>

            <%
                double totalPokokDibayar = 0;
                double totalDpDibayar = 0;
                double totalBungaDibayar = 0;
                int no = 0;
                for (ArrayList al : listPembayaran) {
                    Pinjaman p = (Pinjaman) al.get(0);
                    Transaksi t = (Transaksi) al.get(2);
                    Angsuran angsuran = (Angsuran) al.get(3);
                    Angsuran angsuranDp = (Angsuran) al.get(5);

                    no++;
                    String tglBayar = Formater.formatDate(t.getTanggalTransaksi(), "yyyy-MM-dd HH:mm:ss");
                    double pokokDibayar = p.getJumlahAngsuran();
                    double dpDibayar = angsuranDp.getJumlahAngsuran();
                    double bungaDibayar = angsuran.getJumlahAngsuran();
                    double totalBayar = pokokDibayar + bungaDibayar + dpDibayar;
                    totalPokokDibayar += pokokDibayar;
                    totalDpDibayar += dpDibayar;
                    totalBungaDibayar += bungaDibayar;
                    double sisaPokok = p.getJumlahPinjaman() - totalPokokDibayar - totalBungaDibayar - totalDpDibayar;
            %>

            <tr>
                <td style="width: 1%"><%= no%>.</td>
                <td style="white-space: nowrap"><%= t.getKodeBuktiTransaksi()%></td>
                <td style="white-space: nowrap"><%= tglBayar%></td>
                <td class="money text-right"><%= pokokDibayar + bungaDibayar + dpDibayar %></td>
                <td class="money text-right"><%= totalBayar%></td>
                <td class="money text-right"><%= sisaPokok%></td>
                <td><%= t.getKeterangan()%></td>
            </tr>

            <%
                }
            %>

        </table>
        <%}%>

    </print-area>
        
    <% } %>
</html>
