<%-- 
    Document   : report_tabungan_per_shift
    Created on : Nov 28, 2017, 8:29:19 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterLoket"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterLoket"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.session.SessReportTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstSedanaShift"%>
<%@page import="com.dimata.sedana.entity.masterdata.SedanaShift"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import = "com.dimata.util.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%//
    int iCommand = FRMQueryString.requestCommand(request);
    String tglAwal = FRMQueryString.requestString(request, "FRM_TGL_AWAL");
    String tglAkhir = FRMQueryString.requestString(request, "FRM_TGL_AKHIR");
    String arrayTransaksi[] = request.getParameterValues("FRM_TRANSAKSI");
    String arrayLoket[] = request.getParameterValues("FRM_LOKET");
    String arrayShift[] = request.getParameterValues("FRM_SHIFT");
    String arrayLocation[] = request.getParameterValues("FRM_LOCATION");

    String textTglAwal = "";
    String textTglAkhir = "";
	String whereClause = ""; 
	
    //isi data tanggall di form
    if (tglAwal.equals("")) {
        tglAwal = Formater.formatDate(new Date(), "yyyy-MM-dd");
    } else {
        Date d = Formater.formatDate(tglAwal, "yyyy-MM-dd");
        textTglAwal = Formater.formatDate(d, "dd MMM yyyy");
    }
    if (tglAkhir.equals("")) {
        tglAkhir = Formater.formatDate(new Date(), "yyyy-MM-dd");
    } else {
        Date d = Formater.formatDate(tglAkhir, "yyyy-MM-dd");
        textTglAkhir = Formater.formatDate(d, "dd MMM yyyy");
    }

    List<Integer> useCaseType = new ArrayList<Integer>();
    useCaseType.add(Transaksi.USECASE_TYPE_TABUNGAN_SETORAN);
    useCaseType.add(Transaksi.USECASE_TYPE_TABUNGAN_PENARIKAN);
    String allUseCase = "";
    for (int i = 0; i < useCaseType.size(); i++) {
        if (i > 0) {
            allUseCase += ",";
        }
        allUseCase += useCaseType.get(i);
    }

    //tambah query where transaksi jika ada
    String sqlTransaksi = "";
    String namaTransaksi = "";
    if (arrayTransaksi != null) {
        String kodeTransaksi = "";
        for (int i = 0; i < arrayTransaksi.length; i++) {
            if (i > 0) {
                kodeTransaksi += ",";
                namaTransaksi += ", ";
            }
            kodeTransaksi += "" + arrayTransaksi[i];
            namaTransaksi += "" + Transaksi.USECASE_TYPE_TITLE.get(Integer.valueOf(arrayTransaksi[i]));
        }
        if (!kodeTransaksi.equals("")) {
            sqlTransaksi = " AND t." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN (" + kodeTransaksi + ")";
        }
    } else {
        sqlTransaksi = " AND t." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN (" + allUseCase + ")";
        namaTransaksi = "Semua transaksi";
    }

    //tambah query where loket jika ada
    String sqlLoket = "";
    String namaLoket = "";
    if (arrayLoket != null) {
        String idLoket = "";
        for (int i = 0; i < arrayLoket.length; i++) {
            if (i > 0) {
                idLoket += ",";
                namaLoket += ", ";
            }
            idLoket += "" + arrayLoket[i];
            MasterLoket ml = PstMasterLoket.fetchExc(Long.valueOf(arrayLoket[i]));
            namaLoket += ml.getLoketNumber();
        }
        if (!idLoket.equals("")) {
            sqlLoket += " AND ct." + PstMasterLoket.fieldNames[PstMasterLoket.FLD_MASTER_LOKET_ID] + " IN (" + idLoket + ")";
        }
    } else {
        namaLoket = "Semua loket";
    }

    //tambah query where shift jika ada
    String sqlShift = "";
    String namaShift = "";
    if (arrayShift != null) {
        String idShift = "";
        for (int i = 0; i < arrayShift.length; i++) {
            if (i > 0) {
                idShift += ",";
                namaShift += ", ";
            }
            idShift += "" + arrayShift[i];
            SedanaShift ss = PstSedanaShift.fetchExc(Long.valueOf(arrayShift[i]));
            namaShift += ss.getName();
        }
        if (!idShift.equals("")) {
            sqlShift += " AND ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_SHIFT_ID] + " IN (" + idShift + ")";
        }
    } else {
        namaShift = "Semua shift";
    }
    
    //tambah query where lokasi jika ada
    String sqlLokasi = "";
    String namaLokasi = "";
    if (arrayLocation != null) {
        String idLokasi = "";
        for (int i = 0; i < arrayLocation.length; i++) {
            if (i > 0) {
                idLokasi += ",";
                namaLokasi += ", ";
            }
            idLokasi += "" + arrayLocation[i];
            Location l = PstLocation.fetchExc(Long.valueOf(arrayLocation[i]));
            namaLokasi += l.getName();
        }
        if (!idLokasi.equals("")) {
            sqlLokasi += " AND ml." + PstMasterLoket.fieldNames[PstMasterLoket.FLD_LOCATION_ID] + " IN (" + idLokasi + ")";
        }
    } else {
        namaLokasi = "Semua Lokasi";
    }

    String sql = sqlTransaksi + sqlLoket + sqlShift + sqlLokasi + " GROUP BY DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ")";

    Vector<Transaksi> listTabunganShift = SessReportTabungan.listTabunganPerShift(""
            + " DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") >= '" + tglAwal + "'"
            + " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") <= '" + tglAkhir + "'"
            + "" + sql, "");
	
	whereClause = PstLocation.fieldNames[PstLocation.FLD_TYPE] + " = " + PstLocation.TYPE_LOCATION_STORE;
	Vector<Location> listLocation = PstLocation.getListFromApi(0, 0, whereClause, "");


%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@ include file = "/style/style_kredit.jsp" %>
        <style>
            .judul-tebal th {font-weight: bold}
        </style>
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

                function selectMulti(id, placeholder) {
                    $(id).select2({
                        placeholder: placeholder
                    });
                }

                selectMulti('.select2loket', "Semua Loket");
                selectMulti('.select2shift', "Semua Shift");
                selectMulti('.select2transaksi', "Semua Transaksi");
                selectMulti('.select2loc', "Semua Lokasi");

                $('#form_cari').submit(function () {
                    $('#btn_cari').attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> &nbsp; Tunggu...");
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
                <h1>
                    Laporan Tabungan Per Shift
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Laporan</li>
                    <li class="active">Tabungan</li>
                </ol>
            </section>

            <section class="content">
                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Pencarian</h3>                        
                    </div>
                    
                    <p></p>

                    <form id="form_cari" class="form-horizontal" method="post" action="?command=<%=Command.LIST%>">
                        <div class="box-body">

                            <div class="form-group">
                                <label class="col-sm-1">Tanggal</label>
                                <div class="col-sm-2">
                                    <input type="text" required="" class="form-control input-sm date-picker" name="FRM_TGL_AWAL" value="<%=tglAwal%>">                                    
                                </div>
                                <label class="col-sm-1">sampai</label>
                                <div class="col-sm-2">
                                    <input type="text" required="" class="form-control input-sm date-picker" name="FRM_TGL_AKHIR" value="<%=tglAkhir%>">
                                </div>
                                <label class="col-sm-1">Loket</label>
                                <div class="col-sm-5">
                                    <select multiple="" style="width: 100%" class="form-control input-sm select2loket" name="FRM_LOKET">
                                        <%
                                            Vector listLoket = PstMasterLoket.list(0, 0, "", "");
                                            for (int i = 0; i < listLoket.size(); i++) {
                                                MasterLoket ml = (MasterLoket) listLoket.get(i);
                                                long id = ml.getOID();
                                                String selected = "";
                                                if (arrayLoket != null) {
                                                    for (int j = 0; j < arrayLoket.length; j++) {
                                                        long isi = Long.valueOf(arrayLoket[j]);
                                                        if (id == isi) {
                                                            selected = "selected";
                                                            break;
                                                        }
                                                    }
                                                }
                                        %>
                                        <option <%=selected%> value="<%=ml.getOID()%>"><%=ml.getLoketNumber()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col-sm-1">Transaksi</label>
                                <div class="col-sm-5">
                                    <select multiple="" style="width: 100%" class="form-control input-sm select2transaksi" name="FRM_TRANSAKSI">
                                        <%
                                            for (int i = 0; i < useCaseType.size(); i++) {
                                                String selected = "";
                                                int kode = useCaseType.get(i);
                                                if (arrayTransaksi != null) {
                                                    for (int j = 0; j < arrayTransaksi.length; j++) {
                                                        int isi = Integer.valueOf(arrayTransaksi[j]);
                                                        if (kode == isi) {
                                                            selected = "selected";
                                                            break;
                                                        }
                                                    }
                                                }
                                        %>
                                        <option <%=selected%> value="<%=useCaseType.get(i)%>"><%=Transaksi.USECASE_TYPE_TITLE.get(useCaseType.get(i))%></option>
                                        <%
                                            }
                                        %>                                         
                                    </select>
                                </div>
                                <label class="col-sm-1">Shift</label>
                                <div class="col-sm-5">
                                    <select multiple="" style="width: 100%" class="form-control input-sm select2shift" name="FRM_SHIFT">
                                        <%
                                            Vector<SedanaShift> listShift = PstSedanaShift.list(0, 0, "", "" + PstSedanaShift.fieldNames[PstSedanaShift.FLD_START_TIME] + " ASC ");
                                            for (int i = 0; i < listShift.size(); i++) {
                                                String selected = "";
                                                long id = listShift.get(i).getOID();
                                                if (arrayShift != null) {
                                                    for (int j = 0; j < arrayShift.length; j++) {
                                                        long isi = Long.valueOf(arrayShift[j]);
                                                        if (id == isi) {
                                                            selected = "selected";
                                                            break;
                                                        }
                                                    }
                                                }
                                        %>
                                        <option <%=selected%> value="<%=id%>"><%=listShift.get(i).getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                            </div>
                                    
                            <div class="form-group">
                                <label class="col-sm-1">Lokasi</label>
                                <div class="col-sm-5">
                                    <select multiple="" style="width: 100%" class="form-control input-sm select2loc" name="FRM_LOCATION">
                                        <%
                                            //Vector<Location> listLocation = PstLocation.list(0, 0, "", "");
                                            for (int i = 0; i < listLocation.size(); i++) {
                                                String selected = "";
                                                long id = listLocation.get(i).getOID();
                                                if (arrayLocation != null) {
                                                    for (int j = 0; j < arrayLocation.length; j++) {
                                                        long isi = Long.valueOf(arrayLocation[j]);
                                                        if (id == isi) {
                                                            selected = "selected";
                                                            break;
                                                        }
                                                    }
                                                }
                                        %>
                                        <option <%=selected%> value="<%=id%>"><%=listLocation.get(i).getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                            </div>

                        </div>

                        <div class="box-footer" style="border-color: lightgray">                            
                            <div class="pull-right">
                                <button type="submit" id="btn_cari" class="btn btn-sm btn-primary"><i class="fa fa-search"></i> &nbsp; Cari</button>
                                <% if (iCommand == Command.LIST && !listTabunganShift.isEmpty()) {%>
                                &nbsp;
                                <button type="button" id="btn-print" class="btn btn-sm btn-primary"><i class="fa fa-file"></i> &nbsp; Cetak</button>
                                <%}%>
                            </div>                            
                        </div>
                    </form>

                </div>

                <% if (iCommand == Command.LIST) {%>

                <%if (listTabunganShift.isEmpty()) {%>

                <div class="box box-success">
                    <div class="box-header text-bold">
                        Data transaksi tabungan tidak ditemukan.
                    </div>                    
                </div>

                <%}%>

                <%for (int i = 0; i < listTabunganShift.size(); i++) {%>

                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Tanggal Opening &nbsp;:&nbsp; <a><%=Formater.formatDate(listTabunganShift.get(i).getTanggalTransaksi(), "dd MMMM yyyy")%></a></h3>
                        <div class="box-tools pull-right">
                            <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
                        </div>
                    </div>                    

                    <div class="box-body">

                        <%
                            String textDate = Formater.formatDate(listTabunganShift.get(i).getTanggalTransaksi(), "yyyy-MM-dd");
                            String newSql = sqlTransaksi + sqlLoket + sqlShift;
                            String group = " GROUP BY ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_MASTER_LOKET_ID] + ","
                                    + " ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_SHIFT_ID];

                            Vector listLoketShift = SessReportTabungan.listTabunganPerShift(""
                                    + " DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") = '" + textDate + "'"
                                    + "" + newSql + group, "");

                            for (int j = 0; j < listLoketShift.size(); j++) {
                                Transaksi t = (Transaksi) listLoketShift.get(j);
                                CashTeller ct = PstCashTeller.fetchExc(t.getTellerShiftId());
                                MasterLoket ml = PstMasterLoket.fetchExc(ct.getMasterLoketId());
                                SedanaShift s = PstSedanaShift.fetchExc(ct.getShiftId());
                                Location l = PstLocation.fetchExc(ml.getLocationId());
                                AppUser user = PstAppUser.fetch(ct.getAppUserId());
                                Vector listTransaksi = SessReportTabungan.listTabunganPerShift(""
                                        + " DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") = '" + textDate + "'"
                                        + " AND ct." + PstMasterLoket.fieldNames[PstMasterLoket.FLD_MASTER_LOKET_ID] + " = '" + ml.getOID() + "'"
                                        + " AND ct." + PstSedanaShift.fieldNames[PstSedanaShift.FLD_SHIFT_ID] + " = '" + s.getOID() + "'"
                                        + "" + sqlTransaksi
                                        + "", "");

                        %>

                        <label>
                            Lokasi &nbsp;:&nbsp; <%=l.getName()%> &nbsp;&nbsp;|&nbsp;&nbsp;
                            Tanggal &nbsp;:&nbsp; <%=Formater.formatDate(t.getTanggalTransaksi(), "dd/MM/yyyy")%> &nbsp;&nbsp;|&nbsp;&nbsp;
                            Nama Teller &nbsp;:&nbsp; <%=user.getFullName()%> &nbsp;&nbsp;|&nbsp;&nbsp;
                            Loket &nbsp;:&nbsp; <%=ml.getLoketNumber()%> &nbsp;&nbsp;|&nbsp;&nbsp;
                            Shift &nbsp;:&nbsp; <%=s.getName()%>
                        </label>

                        <table class="table table-bordered">
                            <tr>
                                <th>No.</th>
                                <th>Nomor Tabungan</th>
                                <th>Transaksi</th>
                                <th>Nomor Transaksi</th>
                                <th>Nilai Transaksi</th>
                            </tr>

                            <%
                                double totalTransaksi = 0;
                                for (int k = 0; k < listTransaksi.size(); k++) {
                                    Transaksi t2 = (Transaksi) listTransaksi.get(k);
                                    String noTab = SessReportTabungan.getNomorTabungan(" t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " = '" + t2.getOID() + "'");
                                    double nilaiTransaksi = SessReportKredit.getTotalNilaiTransaksi(" t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " = '" + t2.getOID() + "'");
                                    totalTransaksi += nilaiTransaksi;
                                    //CashTeller ctl = PstCashTeller.fetchExc(t2.getTellerShiftId());
                                    
                            %>

                            <tr>
                                <td class="aksi"><%=(k + 1)%></td>
                                <td><%=noTab%></td>
                                <td><%=Transaksi.USECASE_TYPE_TITLE.get(t2.getUsecaseType())%></td>
                                <td><%=t2.getKodeBuktiTransaksi()%></td>
                                <td class="money text-right"><%=nilaiTransaksi%></td>                         
                            </tr>

                            <%
                                }
                            %>

                            <tr>
                                <td colspan="6" style="background-color: #eaf3df" class="text-right"><b>Total Transaksi &nbsp;:&nbsp; Rp <span class="money"><%=totalTransaksi%></span></b></td>
                            </tr>
                        </table>

                        <% if (j < listLoketShift.size() - 1) {%>
                        <br>
                        <%}%>

                        <%
                            }
                        %>

                    </div>

                </div>

                <%}%>

                <%}%>

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
                    <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">LAPORAN TABUNGAN PER SHIFT</span>
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal &nbsp; : &nbsp; <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Admin &nbsp; : &nbsp; <%=userFullName%></span>                    
                </div>
            </div>
            <hr class="" style="border-color: gray">
            <table>
                <tr>
                    <td>Tanggal</td>
                    <td style="padding: 0px 10px">&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                    <td><%=textTglAwal%> s.d. <%=textTglAkhir%></td>
                </tr>
                <tr>
                    <td>Transaksi</td>
                    <td style="padding: 0px 10px">&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                    <td><%=namaTransaksi%></td>
                </tr>
                <tr>
                    <td>Loket</td>
                    <td style="padding: 0px 10px">&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                    <td><%=namaLoket%></td>
                </tr>
                <tr>
                    <td>Shift</td>
                    <td style="padding: 0px 10px">&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                    <td><%=namaShift%></td>
                </tr>
                <tr>
                    <td>Lokasi</td>
                    <td style="padding: 0px 10px">&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                    <td><%=namaLokasi%></td>
                </tr>
            </table>
            <br>

            <%for (int i = 0; i < listTabunganShift.size(); i++) {%>

            <%
                String textDate = Formater.formatDate(listTabunganShift.get(i).getTanggalTransaksi(), "yyyy-MM-dd");
                String newSql = sqlTransaksi + sqlLoket + sqlShift;
                String group = " GROUP BY ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_MASTER_LOKET_ID] + ","
                        + " ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_SHIFT_ID];

                Vector listLoketShift = SessReportTabungan.listTabunganPerShift(""
                        + " DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") = '" + textDate + "'"
                        + "" + newSql + group, "");

                for (int j = 0; j < listLoketShift.size(); j++) {
                    Transaksi t = (Transaksi) listLoketShift.get(j);
                    CashTeller ct = new CashTeller();
                    MasterLoket ml = new MasterLoket();
                    SedanaShift s = new SedanaShift();
                    ct = PstCashTeller.fetchExc(t.getTellerShiftId());
                    ml = PstMasterLoket.fetchExc(ct.getMasterLoketId());
                    s = PstSedanaShift.fetchExc(ct.getShiftId());

                    Vector listTransaksi = SessReportTabungan.listTabunganPerShift(""
                            + " DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") = '" + textDate + "'"
                            + " AND ct." + PstMasterLoket.fieldNames[PstMasterLoket.FLD_MASTER_LOKET_ID] + " = '" + ml.getOID() + "'"
                            + " AND ct." + PstSedanaShift.fieldNames[PstSedanaShift.FLD_SHIFT_ID] + " = '" + s.getOID() + "'"
                            + "" + sqlTransaksi
                            + "", "");

            %>

            <label>                     
                Tanggal &nbsp;:&nbsp; <%=Formater.formatDate(t.getTanggalTransaksi(), "dd/MM/yyyy")%> &nbsp;&nbsp;|&nbsp;&nbsp;
                Loket &nbsp;:&nbsp; <%=ml.getLoketNumber()%> &nbsp;&nbsp;|&nbsp;&nbsp;
                Shift &nbsp;:&nbsp; <%=s.getName()%>
            </label>

            <table class="table table-bordered judul-tebal">
                <tr>
                    <th>No.</th>
                    <th>Nama Teller</th>
                    <th>Nomor Tabungan</th>
                    <th>Transaksi</th>
                    <th>Nomor Transaksi</th>
                    <th>Nilai Transaksi</th>
                </tr>

                <%
                    double totalTransaksi = 0;
                    for (int k = 0; k < listTransaksi.size(); k++) {
                        Transaksi t2 = (Transaksi) listTransaksi.get(k);
                        String noTab = SessReportTabungan.getNomorTabungan(" t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " = '" + t2.getOID() + "'");
                        double nilaiTransaksi = SessReportKredit.getTotalNilaiTransaksi(" t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " = '" + t2.getOID() + "'");
                        totalTransaksi += nilaiTransaksi;
                        CashTeller ctl = PstCashTeller.fetchExc(t2.getTellerShiftId());
                        AppUser user = PstAppUser.fetch(ctl.getAppUserId());
                %>

                <tr>
                    <td class="aksi"><%=(k + 1)%></td>
                    <td><%=user.getFullName()%></td>
                    <td><%=noTab%></td>
                    <td><%=Transaksi.USECASE_TYPE_TITLE.get(t2.getUsecaseType())%></td>
                    <td><%=t2.getKodeBuktiTransaksi()%></td>
                    <td class="money text-right"><%=nilaiTransaksi%></td>                         
                </tr>

                <%
                    }
                %>

                <tr>
                    <td colspan="6" style="background-color: #eaf3df" class="text-right"><b>Total Transaksi &nbsp;:&nbsp; Rp <span class="money"><%=totalTransaksi%></span></b></td>
                </tr>
            </table>

            <%}%>

            <%}%>

        </div>
    </print-area>

</body>
</html>
