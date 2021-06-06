<%-- 
    Document   : report_rangkuman_kolektabilitas
    Created on : Oct 3, 2017, 8:29:53 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.session.SessKredit"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAssignSumberDanaJenisKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.AssignSumberDanaJenisKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.sumberdana.SumberDana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.PstSumberDana"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.util.*" %>
<%@page import = "com.dimata.util.*" %>
<%@page import = "com.dimata.gui.jsp.*" %>
<%@page import = "com.dimata.qdep.form.*" %>
<%@include file = "../../main/javainit.jsp" %>
<%//
    int iCommand = FRMQueryString.requestCommand(request);
    String dateCheck = FRMQueryString.requestString(request, "dateCheck");
    String tipeNasabah[] = request.getParameterValues("tipe_nasabah");
    String sumberDana[] = request.getParameterValues("sumber_dana");
    String jenisKredit[] = request.getParameterValues("jenis_kredit");    
    String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA");  
    
    if (dateCheck.equals("")) {
        dateCheck = "" + Formater.formatDate(new Date(), "yyyy-MM-dd");
    }
    String filterJenisKredit = "";
    String filterSumberDana = "";
    String filterTipeNasabah = "";
    
    String whereAll = "";
    String urut = FRMQueryString.requestString(request, "urutan");
    String order = " p." + PstPinjaman.fieldNames[PstPinjaman.FLD_KODE_KOLEKTIBILITAS] + " " + urut;
    
    String selectAllSumberDana = "selected";
    String selectAllTipeNasabah = "";
    String selectedSumberDana = "";
    String selectedTipeNasabah = "";
        
    Vector<KolektibilitasPembayaran> allKolektibilitas = new Vector();
    Vector count = new Vector();
    JSONObject o = new JSONObject();
    JSONArray a = new JSONArray();
    //==========================================================================
    
    if (iCommand == Command.LIST) {
        
        //if (dateCheck.equals(Formater.formatDate(new Date(), "yyyy-MM-dd"))) {
            //update status kolektibilitas
            String whereStatusPinjaman = "p." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " IN ("
                    + Pinjaman.STATUS_DOC_CAIR + "," + Pinjaman.STATUS_DOC_PENANGANAN_MACET + ")";
            String groupBy = " GROUP BY p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID];
            Vector<Pinjaman> listPinjaman = SessReportKredit.listJoinPinjamanKolektibilitas(whereStatusPinjaman + groupBy, "");
            SessKredit.updateKolektibilitasKredit(listPinjaman);
        //}
            
        String whereSumberDana = "";
        if (sumberDana == null) {
            filterSumberDana = "Semua sumber dana";
            selectAllSumberDana = "selected";
        } else {
            for (int i = 0; i < sumberDana.length; i++) {
                if (sumberDana[i].equals("all")) {
                    filterSumberDana = "Semua sumber dana";
                    selectAllSumberDana = "selected";
                    break;
                }
                selectAllSumberDana = "";
                SumberDana sd = new SumberDana();
                try {
                    sd = PstSumberDana.fetchExc(Long.valueOf(sumberDana[i]));
                    selectedSumberDana += i > 0 ? "," + sd.getOID() : "" + sd.getOID();
                    filterSumberDana += i > 0 ? ", " + sd.getJudulSumberDana() : "" + sd.getJudulSumberDana();
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
        }
        
        //----------------------------------------------------------------------
        
        String whereJenisKredit = "";
        if (jenisKredit == null) {
            filterJenisKredit = "Semua jenis kredit";
        } else {
            whereJenisKredit += " p." + PstPinjaman.fieldNames[PstPinjaman.FLD_TIPE_KREDIT_ID] + " IN (";
            for (int i = 0; i < jenisKredit.length; i++) {
                JenisKredit jk = new JenisKredit();
                try {
                    jk = PstJenisKredit.fetch(Long.valueOf(jenisKredit[i]));
                    whereJenisKredit += i > 0 ? "," + jk.getOID() : "" + jk.getOID();
                    filterJenisKredit += i > 0 ? ", " + jk.getNamaKredit() : "" + jk.getNamaKredit();
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }                
            }
            whereJenisKredit += ")";
        }
        
        //----------------------------------------------------------------------
        
        String whereNasabah = "";
        if (tipeNasabah == null) {
            filterTipeNasabah = "Semua tipe nasabah";
            selectAllTipeNasabah = "selected";
        } else {            
            for (int i = 0; i < tipeNasabah.length; i++) {
                if (tipeNasabah[i].equals("all")) {
                    filterTipeNasabah = "Semua tipe nasabah";
                    selectAllTipeNasabah = "selected";
                    break;
                }
                selectAllTipeNasabah = "";
                try {
                    filterTipeNasabah += i > 0 ? ", " + PstContactClass.contactType[Integer.valueOf(tipeNasabah[i])] : "" + PstContactClass.contactType[Integer.valueOf(tipeNasabah[i])];
                    selectedTipeNasabah += i > 0 ? "," + tipeNasabah[i] : "" + tipeNasabah[i];
                } catch (NumberFormatException e) {
                    System.out.println(e.getMessage());
                }
            }
            if (selectedTipeNasabah.length() > 0) {
                whereNasabah += " cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " IN (" + selectedTipeNasabah +")";
            }            
        }
        
        //----------------------------------------------------------------------
        
        if (!whereSumberDana.equals("")) {
            whereSumberDana += " AND ";
        }
        if (!whereJenisKredit.equals("")) {
            whereJenisKredit += " AND ";
        }
        if (!whereNasabah.equals("")) {
            whereNasabah += " AND ";
        }
        
        String whereStatus = " p." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " IN ("
                + Pinjaman.STATUS_DOC_CAIR 
                + "," + Pinjaman.STATUS_DOC_PENANGANAN_MACET
                + ")";
        
        whereAll = whereSumberDana + whereJenisKredit + whereNasabah + whereStatus;
        count = SessReportKredit.listJoinPinjamanRangkumanKolektibilitas(whereAll, "");
        allKolektibilitas = PstKolektibilitasPembayaran.list(0, 0, "", "");        
        
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Tell the browser to be responsive to screen width -->
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <!-- Bootstrap 3.3.6 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="StyleSheet" href="../../style/font-awesome/4.6.1/css/font-awesome.css" type="text/css" >
        <!-- Ionicons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
        <!-- Datetime Picker -->
        <link href="../../style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
        <!-- Select2 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
        <!-- Theme style -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
        <!-- AdminLTE Skins. Choose a skin from the css/skins
             folder instead of downloading all of them to reduce the load. -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">
        <link rel="stylesheet" media="screen" href="../../style/Highcharts-6.0.7/highcharts.css"/>
        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding: 4px 6px !important}

            print-area { visibility: hidden; display: none; }
            print-area.preview { visibility: visible; display: block; }
            @media print
            {
                body .main-page * { visibility: hidden; display: none; } 
                body print-area * { visibility: visible; }
                body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
            }
        </style>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    Laporan Rangkuman Kolektibilitas
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Laporan</li>
                    <li class="active">Kredit</li>
                </ol>
            </section>

            <section class="content">
                <div class="row">
                    <div class="col-xs-12">

                        <div class="box box-success">

                            <div class="box-header with-border">
                                <h3 class="box-title">Form Pencarian</h3>
                            </div>

                            <form class="form-horizontal" id="form_searchKolektibilitas" method="post" action="?command=<%=Command.LIST%>">
                                <div class="box-body">

                                    <div class="col-xs-6">
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Tanggal Pencarian</label>
                                            <div class="col-sm-8">
                                                <input type="text" required="" class="form-control input-sm datetime-picker" name="dateCheck" value="<%=dateCheck%>">
                                            </div>
                                        </div>
                                        <%if(useForRaditya.equals("1")){%>
                                        <%}else{%>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Tipe <%=namaNasabah%></label>
                                            <div class="col-sm-8" >
                                                <select id="tipeNasabah" style="width: 100%" class="form-control input-sm select2" multiple="" name="tipe_nasabah">
                                                    <option <%=selectAllTipeNasabah%> value="all">Semua</option>
                                                    <%
                                                        ArrayList<Integer> al = new ArrayList();
                                                        al.add(PstContactClass.CONTACT_TYPE_MEMBER);
                                                        al.add(PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA);
                                                        for (int i = 0; i < al.size(); i++) {
                                                            String selected = "";
                                                            if (tipeNasabah != null) {
                                                                for (int j = 0; j < tipeNasabah.length; j++) {
                                                                    if (tipeNasabah[j].equals("all")) {
                                                                        continue;                                      
                                                                    }
                                                                    if (tipeNasabah[j].equals(""+al.get(i))) {
                                                                        selected = "selected";
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                            out.print("<option "+selected+" value='"+al.get(i)+"'>"+PstContactClass.contactType[al.get(i)]+"</option>");
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                        <%}%>
                                    </div>

                                    <div class="col-xs-6">
                                        <%if(useForRaditya.equals("1")){%>
                                        <%}else{%>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Sumber Dana</label>
                                            <div class="col-sm-8">
                                                <select id="sumberDana" style="width: 100%" class="form-control input-sm select2" multiple="" name="sumber_dana">
                                                    <option <%=selectAllSumberDana%> value="all">Semua</option>
                                                    <%
                                                        Vector listSumberDana = PstSumberDana.list(0, 0, "", "" + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA] + " ASC");
                                                        for (int i = 0; i < listSumberDana.size(); i++) {
                                                            SumberDana sd = (SumberDana) listSumberDana.get(i);
                                                            String selected = "";
                                                            if (sumberDana != null) {
                                                                for (int j = 0; j < sumberDana.length; j++) {
                                                                    if (sumberDana[j].equals("all")) {
                                                                        continue;
                                                                    }
                                                                    if (sumberDana[j].equals("" + sd.getOID())) {
                                                                        selected = "selected";
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                            out.print("<option "+selected+" value="+sd.getOID()+">"+sd.getKodeSumberDana()+" - "+sd.getJudulSumberDana()+"</option>");                                                
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                       <%} if(useForRaditya.equals("0")){%>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Jenis Kredit</label>
                                            <div class="col-sm-8">
                                                <select style="width: 100%" class="form-control input-sm selectAll jenisKredit" multiple="" name="jenis_kredit">
                                                    <%          
                                                        if (iCommand == Command.LIST) {
                                                            Vector<AssignSumberDanaJenisKredit> listSelectedKredit = PstAssignSumberDanaJenisKredit.list(0, 0, selectedSumberDana.equals("") ? "" : PstAssignSumberDanaJenisKredit.fieldNames[PstAssignSumberDanaJenisKredit.FLD_SUMBER_DANA_ID] + " IN (" + selectedSumberDana + ")", "");
                                                            for (AssignSumberDanaJenisKredit asdjk : listSelectedKredit) {
                                                                try {
                                                                    JenisKredit jk = PstJenisKredit.fetch(asdjk.getTypeKreditId());
                                                                    String selected = "";
                                                                    if (jenisKredit != null) {
                                                                        for (int j=0; j < jenisKredit.length; j++) {
                                                                            if (jenisKredit[j].equals(""+jk.getOID())) {
                                                                                selected = "selected";
                                                                                break;
                                                                            }
                                                                        }
                                                                    }
                                                                    out.print("<option "+selected+" value='"+jk.getOID()+"'>"+jk.getNamaKredit()+"</option>");
                                                                } catch (Exception e) {
                                                                    System.out.println(e.getMessage());
                                                                }
                                                            }
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                        <%}else{%>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Jenis Kredit</label>
                                            <div class="col-sm-8">
                                                <select style="width: 100%" class="form-control input-sm selectAll jenisKredit" multiple="" name="jenis_kredit">
                                                    <%          
                                                            Vector<JenisKredit> listSelectedKredit = PstJenisKredit.list(0, 0, "", "");
                                                            for (JenisKredit asdjk : listSelectedKredit) {
                                                                try {
                                                                    String selected = "";
                                                                    if (jenisKredit != null) {
                                                                        for (int j=0; j < jenisKredit.length; j++) {
                                                                            if (jenisKredit[j].equals(""+asdjk.getOID())) {
                                                                                selected = "selected";
                                                                                break;
                                                                            }
                                                                        }
                                                                    }
                                                                    out.print("<option "+selected+" value='"+asdjk.getOID()+"'>"+asdjk.getNamaKredit()+"</option>");
                                                                } catch (Exception e) {
                                                                    System.out.println(e.getMessage());
                                                                }
                                                            }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <%}%>
                                    </div>

                                </div>

                                <div class="box-footer">
                                    <div class="col-xs-12">
                                        <div class="form-inline pull-right">
                                            <!--label class="control-label">Urutkan Berdasarkan</label>
                                            &nbsp;
                                            <select class="form-control" name="urutan">
                                                <option value="ASC">Kolektibilitas lancar</option>
                                                <option value="DESC">Kolektibilitas tidak Lancar</option>
                                            </select-->
                                            &nbsp;
                                            <button type="submit" class="btn btn-sm btn-primary" id="btn-searchKolektibilitas"><i class="fa fa-search"></i> &nbsp; Cari</button>
                                            <% if (iCommand == Command.LIST) {%>
                                            <button type="button" class="btn btn-sm btn-primary" id="btn-printKolektabilitas"><i class="fa fa-file"></i> &nbsp; Cetak</button>
                                            <% } %>
                                        </div>  
                                    </div>                                                              
                                </div>
                            </form>

                        </div>

                        <% if (iCommand == Command.LIST) {%>

                        <div class="box box-success">

                            <div class="box-body">
                                <h4 class="text-center"><b>LAPORAN RANGKUMAN KOLEKTIBILITAS KREDIT</b></h4>
                                <div class="form-group">
                                    <table style="font-size: 14px">
                                        <tr>
                                            <td>Tanggal</td>
                                            <td> &nbsp; : &nbsp; </td>
                                            <td><%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></td>
                                        </tr>
                                        <tr>
                                            <td>Admin</td>
                                            <td> &nbsp; : &nbsp; </td>
                                            <td><%=userFullName%></td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="form-group">
                                    <table style="font-size: 14px">
                                        <tr>
                                            <td>Jenis Kredit</td>
                                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                                            <td><%=filterJenisKredit%></td>
                                        </tr>
                                        <tr>
                                            <td>Sumber Dana</td>
                                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                                            <td><%=filterSumberDana%></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px">Tipe <%=namaNasabah%></td>
                                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                                            <td><%=filterTipeNasabah%></td>
                                        </tr>
                                    </table>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-bordered table-striped" style="font-size: 14px">
                                        <tr>
                                            <th colspan="2">Kolektibilitas</th>
                                            <th colspan="2">Jumlah</th>
                                            <th colspan="2">Sisa Kredit</th>
                                            <th colspan="3">Tunggakan</th>
                                        </tr>
                                        <tr>
                                            <th>Kode</th>
                                            <th>Persentase</th>
                                            <th><%=namaNasabah%></th>
                                            <th>Nilai Kredit</th>
                                            <th>Pokok</th>
                                            <th>Bunga</th>
                                            <th>Pokok</th>
                                            <th>Bunga</th>
                                            <th>Total</th>
                                        </tr>
                                        <%
                                            int grandTotalNasabah = 0;
                                            double grandTotalNilaiKredit = 0;
                                            double grandTotalSisaPokok = 0;
                                            double grandTotalSisaBunga = 0;
                                            double grandTotalTunggakanPokok = 0;
                                            double grandTotalTunggakanBunga = 0;
                                            double grandTotalTunggakan = 0;

                                            for (KolektibilitasPembayaran kp : allKolektibilitas) {
                                                long idKolektibilitas = kp.getOID();
                                                String whereKol = " AND p." + PstPinjaman.fieldNames[PstPinjaman.FLD_KODE_KOLEKTIBILITAS] + " = " + idKolektibilitas;                                            
                                                Vector<Pinjaman> matchPinjaman = SessReportKredit.listJoinPinjamanRangkumanKolektibilitas(whereAll + whereKol, "");

                                                double totalPokok = 0;
                                                double totalBunga = 0;
                                                double totalBayarPokok = 0;
                                                double totalBayarBunga = 0;
                                                double sisaPokok = 0;
                                                double sisaBunga = 0;

                                                double totalPokokPerTgl = 0;
                                                double totalBungaPerTgl = 0;
                                                double totalPokokDibayarPerTgl = 0;
                                                double totalBungaDibayarPerTgl = 0;
                                                double tunggakanPokok = 0;
                                                double tunggakanBunga = 0;

                                                double nilaiKredit = 0;
                                                double persentase = 0;

                                                for (int j = 0; j < matchPinjaman.size(); j++) {
                                                    long idPinjaman = matchPinjaman.get(j).getOID();
                                                    nilaiKredit += matchPinjaman.get(j).getJumlahPinjaman();
                                                    //cari sisa angsuran
                                                    totalPokok += SessReportKredit.getTotalAngsuran(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                                                    totalBunga += SessReportKredit.getTotalAngsuran(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                                                    totalBayarPokok += SessReportKredit.getTotalAngsuranDibayar(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                                                    totalBayarBunga += SessReportKredit.getTotalAngsuranDibayar(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                                                    //cari tunggakan
                                                    totalPokokPerTgl += SessReportKredit.getTotalAngsuranPerTanggalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK, dateCheck);
                                                    totalBungaPerTgl += SessReportKredit.getTotalAngsuranPerTanggalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA, dateCheck);
                                                    totalPokokDibayarPerTgl += SessReportKredit.getTotalAngsuranDibayarPerJadwalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK, dateCheck);
                                                    totalBungaDibayarPerTgl += SessReportKredit.getTotalAngsuranDibayarPerJadwalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA, dateCheck);
                                                }

                                                sisaPokok = totalPokok - totalBayarPokok;
                                                sisaBunga = totalBunga - totalBayarBunga;

                                                tunggakanPokok = totalPokokPerTgl - totalPokokDibayarPerTgl;
                                                tunggakanBunga = totalBungaPerTgl - totalBungaDibayarPerTgl;

                                                //persentase
                                                double total = count.size();
                                                persentase = (matchPinjaman.size() / total) * 100;

                                                //diagram data
                                                o = new JSONObject();
                                                o.put("name", ""+kp.getJudulKolektibilitas());
                                                o.put("y", persentase);
                                                a.put(o);

                                                grandTotalNasabah += matchPinjaman.size();
                                                grandTotalNilaiKredit += nilaiKredit;
                                                grandTotalSisaPokok += sisaPokok;
                                                grandTotalSisaBunga += sisaBunga;
                                                grandTotalTunggakanPokok += tunggakanPokok;
                                                grandTotalTunggakanBunga += tunggakanBunga;
                                                grandTotalTunggakan += tunggakanPokok + tunggakanBunga;
                                        %>

                                        <tr>
                                            <td class="text-center"><%=kp.getKodeKolektibilitas()%></td>
                                            <td class="text-center"><font class="money"><%=persentase%></font> %</td>
                                            <td class="text-center"><%=matchPinjaman.size()%></td>
                                            <td class="money text-right"><%=nilaiKredit%></td>
                                            <td class="money text-right"><%=sisaPokok%></td>
                                            <td class="money text-right"><%=sisaBunga%></td>
                                            <td class="money text-right"><%=tunggakanPokok%></td>
                                            <td class="money text-right"><%=tunggakanBunga%></td>
                                            <td class="money text-right"><%=(tunggakanPokok + tunggakanBunga)%></td>
                                        </tr>

                                        <%
                                            }
                                        %>

                                        <tr style="background-color: #eaf3df; font-weight: bold">
                                            <td class="text-right" colspan="2">GRAND TOTAL :</td>
                                            <td class="text-center"><%=grandTotalNasabah%></td>
                                            <td class="money text-right"><%=grandTotalNilaiKredit%></td>
                                            <td class="money text-right"><%=grandTotalSisaPokok%></td>
                                            <td class="money text-right"><%=grandTotalSisaBunga%></td>
                                            <td class="money text-right"><%=grandTotalTunggakanPokok%></td>
                                            <td class="money text-right"><%=grandTotalTunggakanBunga%></td>
                                            <td class="money text-right"><%=grandTotalTunggakan%></td>
                                        </tr>

                                    </table>                                                             
                                </div>

                                <label>Keterangan :</label>
                                <div>
                                    <ul>
                                    <%
                                        for (KolektibilitasPembayaran kp : allKolektibilitas) {
                                            out.print("<li>" + kp.getKodeKolektibilitas() + " : " + kp.getJudulKolektibilitas() + "</li>");
                                        }
                                    %>
                                    </ul>
                                </div>

                                <div id="container"></div>

                            </div>

                        </div>

                        <%}%>

                    </div>
                </div>

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
                        <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">LAPORAN RANGKUMAN KOLEKTIBILITAS KREDIT</span>
                        <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal &nbsp; : &nbsp; <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
                        <span style="width: 100%; display: inline-block; font-size: 12px;">Admin &nbsp; : &nbsp; <%=userFullName%></span>                    
                    </div>
                </div>
                <hr class="" style="border-color: gray">
                <table style="font-size: 12px">
                    <tr>
                        <td>Jenis Kredit</td>
                        <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                        <td><%=filterJenisKredit%></td>
                    </tr>
                    <tr>
                        <td>Sumber Dana</td>
                        <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                        <td><%=filterSumberDana%></td>
                    </tr>
                    <tr>
                        <td style="width: 100px">Tipe <%=namaNasabah%></td>
                        <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                        <td><%=filterTipeNasabah%></td>
                    </tr>
                </table>
                <br>
                <table class="table table-bordered table-striped" style="font-size: 12px">
                    <thead>
                        <tr>
                            <th colspan="2">Kolektibilitas</th>
                            <th colspan="2">Jumlah</th>
                            <th colspan="2">Jumlah Sisa Kredit</th>
                            <th colspan="3">Tunggakan</th>
                        </tr>
                        <tr>
                            <th>Kode</th>
                            <th>Persentase</th>
                            <th><%=namaNasabah%></th>
                            <th>Kredit</th>
                            <th>Pokok</th>
                            <th>Bunga</th>
                            <th>Pokok</th>
                            <th>Bunga</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%          
                            int grandTotalNasabah = 0;
                            double grandTotalNilaiKredit = 0;
                            double grandTotalSisaPokok = 0;
                            double grandTotalSisaBunga = 0;
                            double grandTotalTunggakanPokok = 0;
                            double grandTotalTunggakanBunga = 0;
                            double grandTotalTunggakan = 0;

                            for (int i = 0; i < allKolektibilitas.size(); i++) {
                                long idKolektibilitas = allKolektibilitas.get(i).getOID();
                                String whereKol = " AND p." + PstPinjaman.fieldNames[PstPinjaman.FLD_KODE_KOLEKTIBILITAS] + " = " + idKolektibilitas;                                            
                                Vector<Pinjaman> matchPinjaman = SessReportKredit.listJoinPinjamanRangkumanKolektibilitas(whereAll + whereKol, "");

                                double totalPokok = 0;
                                double totalBunga = 0;
                                double totalBayarPokok = 0;
                                double totalBayarBunga = 0;
                                double sisaPokok = 0;
                                double sisaBunga = 0;

                                double totalPokokPerTgl = 0;
                                double totalBungaPerTgl = 0;
                                double totalPokokDibayarPerTgl = 0;
                                double totalBungaDibayarPerTgl = 0;
                                double tunggakanPokok = 0;
                                double tunggakanBunga = 0;

                                double nilaiKredit = 0;
                                double persentase = 0;

                                for (int j = 0; j < matchPinjaman.size(); j++) {
                                    long idPinjaman = matchPinjaman.get(j).getOID();
                                    nilaiKredit += matchPinjaman.get(j).getJumlahPinjaman();
                                    //cari sisa angsuran
                                    totalPokok += SessReportKredit.getTotalAngsuran(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                                    totalBunga += SessReportKredit.getTotalAngsuran(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                                    totalBayarPokok += SessReportKredit.getTotalAngsuranDibayar(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                                    totalBayarBunga += SessReportKredit.getTotalAngsuranDibayar(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                                    //cari tunggakan
                                    totalPokokPerTgl += SessReportKredit.getTotalAngsuranPerTanggalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK, dateCheck);
                                    totalBungaPerTgl += SessReportKredit.getTotalAngsuranPerTanggalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA, dateCheck);
                                    totalPokokDibayarPerTgl += SessReportKredit.getTotalAngsuranDibayarPerJadwalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK, dateCheck);
                                    totalBungaDibayarPerTgl += SessReportKredit.getTotalAngsuranDibayarPerJadwalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA, dateCheck);
                                }

                                sisaPokok = totalPokok - totalBayarPokok;
                                sisaBunga = totalBunga - totalBayarBunga;

                                tunggakanPokok = totalPokokPerTgl - totalPokokDibayarPerTgl;
                                tunggakanBunga = totalBungaPerTgl - totalBungaDibayarPerTgl;

                                //persentase
                                double total = count.size();
                                persentase = (matchPinjaman.size() / total) * 100;

                                grandTotalNasabah += matchPinjaman.size();
                                grandTotalNilaiKredit += nilaiKredit;
                                grandTotalSisaPokok += sisaPokok;
                                grandTotalSisaBunga += sisaBunga;
                                grandTotalTunggakanPokok += tunggakanPokok;
                                grandTotalTunggakanBunga += tunggakanBunga;
                                grandTotalTunggakan += tunggakanPokok + tunggakanBunga;
                        %>
                        <tr>
                            <td class="text-center"><%=allKolektibilitas.get(i).getKodeKolektibilitas()%></td>
                            <td class="text-center"><font class="money"><%=persentase%></font> %</td>
                            <td class="text-center"><%=matchPinjaman.size()%></td>
                            <td class="money text-right"><%=nilaiKredit%></td>
                            <td class="money text-right"><%=sisaPokok%></td>
                            <td class="money text-right"><%=sisaBunga%></td>
                            <td class="money text-right"><%=tunggakanPokok%></td>
                            <td class="money text-right"><%=tunggakanBunga%></td>
                            <td class="money text-right"><%=(tunggakanPokok + tunggakanBunga)%></td>
                        </tr>                                    
                        <%
                            }
                        %>    

                        <tr style="font-weight: bold">
                            <td class="text-right" colspan="2">GRAND TOTAL :</td>
                            <td class="text-center"><%=grandTotalNasabah%></td>
                            <td class="money text-right"><%=grandTotalNilaiKredit%></td>
                            <td class="money text-right"><%=grandTotalSisaPokok%></td>
                            <td class="money text-right"><%=grandTotalSisaBunga%></td>
                            <td class="money text-right"><%=grandTotalTunggakanPokok%></td>
                            <td class="money text-right"><%=grandTotalTunggakanBunga%></td>
                            <td class="money text-right"><%=grandTotalTunggakan%></td>
                        </tr>

                    </tbody>
                </table>                    
                <label>Keterangan :</label>
                <div>
                    <ul>
                    <%
                        for (KolektibilitasPembayaran kp : allKolektibilitas) {
                            out.print("<li>" + kp.getKodeKolektibilitas() + " : " + kp.getJudulKolektibilitas() + "</li>");
                        }
                    %>
                    </ul>
                </div>
                <div id="container2"></div>
            </div>                    
        </print-area>

        <!--------------------------------------------------------------------->

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
        <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>
        <script src="../../style/dist/js/dimata-app.js" type="text/javascript"></script>
        <script type="text/javascript" src="../../style/Highcharts-6.0.7/highcharts.js"></script>
        <script>
            jQuery(function () {

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
                
                $('.select2').select2({placeholder: "Semua"});
                $('.selectAll').select2({placeholder: "Semua"});
                
                $('.datetime-picker').datetimepicker({
                    weekStart: 1,
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2, // No time
                    // showMeridian: 0
                    format: "yyyy-mm-dd"
                });

                $('#form_searchKolektibilitas').submit(function () {
                    $('#btn-searchKolektibilitas').attr({"disabled": "true"}).html("Tunggu...");
                });

                $('#btn-printKolektabilitas').click(function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.print();
                    $(this).removeAttr('disabled').html(buttonHtml);
                });

                $('#sumberDana').change(function () {
                    var id = $(this).val();
                    var dataSend = {
                        "SEND_ARRAY_ID_SUMBER_DANA": "" + id + "",
                        "FRM_FIELD_DATA_FOR": "getOptionJenisKredit",
                        "command": "<%=Command.NONE%>"
                    };
                    onDone = function (data) {
                        $('.jenisKredit').html(data.FRM_FIELD_HTML);
                    };
                    onSuccess = function (data) {

                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    return false;
                });
                
                if ("<%=iCommand%>" == 0) {
                    $('#sumberDana').trigger('change');
                }

            });
        </script>

        <script>
            jQuery(function () {
                
                function loadChart(id){
                    Highcharts.chart(id, {
                        chart: {
                            plotBackgroundColor: null,
                            plotBorderWidth: null,
                            plotShadow: false,
                            type: 'pie'
                        },
                        title: {
                            text: 'Diagram Kolektibilitas Kredit'
                        },
                        tooltip: {
                            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                        },
                        plotOptions: {
                            pie: {
                                allowPointSelect: true,
                                cursor: 'pointer',
                                dataLabels: {
                                    enabled: true,
                                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                                    style: {
                                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                                    }
                                }
                            }
                        },
                        series: [{
                            name: 'Persentase',
                            colorByPoint: true,
                            data: <%=a%>
                        }]
                    });          
                };
                
                if ("<%=iCommand%>" == 1) {                    
                    loadChart("container");
                    loadChart("container2");
                }
                
            });
        </script>

        <%--@ include file = "/footerkoperasi.jsp" --%>
    </body>
</html>
