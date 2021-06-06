<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.session.SessKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.AssignSumberDanaJenisKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAssignSumberDanaJenisKredit"%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaranDetails"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjamanSumberDana"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.entity.sumberdana.SumberDana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.PstSumberDana"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.reportsearch.ReportKolektabilitas"%>
<%@page import="com.dimata.sedana.entity.reportsearch.PstRscReport"%>
<%@page import="com.dimata.sedana.entity.reportsearch.RscReport"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisTabungan"%>
<%@page language="java" %>
<%@page import = "java.util.*" %>
<%@page import = "com.dimata.util.*" %>
<%@page import = "com.dimata.gui.jsp.*" %>
<%@page import = "com.dimata.qdep.form.*" %>
<%@page import="com.dimata.sedana.form.reportsearch.FrmRscReport"%>
<%@include file = "../../main/javainit.jsp" %>
<%//
    int iCommand = FRMQueryString.requestCommand(request);
    int print = FRMQueryString.requestInt(request, "print_kolektibilitas");
    long idKredit = FRMQueryString.requestLong(request, "kredit_id");
    String dateCheck = FRMQueryString.requestString(request, "dateCheck");
    String sumberDana[] = request.getParameterValues("sumber_dana");
    String jenisKredit[] = request.getParameterValues("jenis_kredit");
    String tipeNasabah[] = request.getParameterValues("tipe_nasabah");
    String nasabah[] = request.getParameterValues("id_nasabah");
    String tingkatKolektibilitas[] = request.getParameterValues("tingkat_kolektibilitas");
    int statusKredit = FRMQueryString.requestInt(request, "status_kredit");
    String urut = FRMQueryString.requestString(request, "urutan");
    int group = FRMQueryString.requestInt(request, "group");
    String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA");  
     String[] lokasi = request.getParameterValues("jenis_kredit");

    String filterSumberDana = "";
    String filterJenisKredit = "";
    String filterLokasi = "";
    String filterTipeNasabah = "";
    String filterNamaNasabah = "";
    String filterTingkatKolektibilitas = "";

    if (dateCheck.equals("")) {
        dateCheck = "" + Formater.formatDate(new Date(), "yyyy-MM-dd");
    }

    String selectAllSumberDana = "selected";
    String selectAllTipeNasabah = "selected";
    String selectedSumberDana = "";
    String selectedTipeNasabah = "";
    //----------------------------------------------------------------------------  

    if (idKredit > 0) {
        if (PstPinjaman.checkOID(idKredit)) {
            Pinjaman updateKredit = PstPinjaman.fetchExc(idKredit);
            if (updateKredit.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR) {
                updateKredit.setStatusPinjaman(Pinjaman.STATUS_DOC_PENANGANAN_MACET);
            } else if (updateKredit.getStatusPinjaman() == Pinjaman.STATUS_DOC_PENANGANAN_MACET) {
                updateKredit.setStatusPinjaman(Pinjaman.STATUS_DOC_CAIR);
            }
            try {
                PstPinjaman.updateExc(updateKredit);
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
    }

    //----------------------------------------------------------------------------  
    Vector<Pinjaman> listPinjamanNunggakUpdate = new Vector();
    Vector<Pinjaman> listPinjamanNunggakShow = new Vector();

    if (iCommand == Command.LIST) {
        
        //String whereSumberDana = "";
        if (sumberDana == null) {
            filterSumberDana = "Semua sumber dana";
            selectAllSumberDana = "selected";
        } else {
            //whereSumberDana += " sd." + PstPinjamanSumberDana.fieldNames[PstPinjamanSumberDana.FLD_SUMBER_DANA_ID] + " IN (";
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
                    //whereSumberDana += i > 0 ? ","+sd.getOID():""+sd.getOID();
                    selectedSumberDana += i > 0 ? "," + sd.getOID() : "" + sd.getOID();
                    filterSumberDana += i > 0 ? ", " + sd.getJudulSumberDana() : "" + sd.getJudulSumberDana();
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
            //whereSumberDana += ")";
        }

        //--------------------------------------------------------------------------
        
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
                whereJenisKredit += ")";
            }
        }

        //--------------------------------------------------------------------------
        
        String whereLokasi = "";
        if (lokasi == null) {
            filterLokasi = "Semua jenis kredit";
        } else {
            whereLokasi += " loc." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " IN (";
            for (int i = 0; i < lokasi.length; i++) {
                Location loc = new Location();
                try {
                    loc = PstLocation.fetchExc(Long.valueOf(lokasi[i]));
                    whereLokasi += i > 0 ? "," + loc.getOID() : "" + loc.getOID();
                    filterLokasi += i > 0 ? ", " + loc.getName(): "" + loc.getName();
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                whereLokasi += ")";
            }
        }

        //--------------------------------------------------------------------------
        
        if (tipeNasabah == null) {
            filterTipeNasabah = "Semua tipe "+namaNasabah+"";
            selectAllTipeNasabah = "selected";
        } else {
            for (int i = 0; i < tipeNasabah.length; i++) {
                if (tipeNasabah[i].equals("all")) {
                    filterTipeNasabah = "Semua tipe "+namaNasabah+"";
                    selectAllTipeNasabah = "selected";
                    break;
                }
                selectAllTipeNasabah = "";
                try {
                    filterTipeNasabah += i > 0 ? ", " + PstContactClass.contactType[Integer.valueOf(tipeNasabah[i])] : "" + PstContactClass.contactType[Integer.valueOf(tipeNasabah[i])];
                    selectedTipeNasabah += i > 0 ? " OR cc." + PstContactClass.contactType[Integer.valueOf(tipeNasabah[i])] : "" + PstContactClass.contactType[Integer.valueOf(tipeNasabah[i])];
                } catch (NumberFormatException e) {
                    System.out.println(e.getMessage());
                }
            }
        }

        //--------------------------------------------------------------------------
        
        String whereNasabah = "";
        if (nasabah == null) {
            filterNamaNasabah = "Semua "+namaNasabah+"";
        } else {
            whereNasabah += " p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID] + " IN (";
            for (int i = 0; i < nasabah.length; i++) {
                Anggota a = new Anggota();
                try {
                    a = PstAnggota.fetchExc(Long.valueOf(nasabah[i]));
                    whereNasabah += i > 0 ? "," + a.getOID() : "" + a.getOID();
                    filterNamaNasabah += i > 0 ? ", " + a.getName() : "" + a.getName();
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
            whereNasabah += ")";
        }

        //--------------------------------------------------------------------------
        
        String whereKolektibilitas = "";
        if (tingkatKolektibilitas == null) {
            filterTingkatKolektibilitas = "Semua kolektibilitas";
        } else {
            whereKolektibilitas += " p." + PstPinjaman.fieldNames[PstPinjaman.FLD_KODE_KOLEKTIBILITAS] + " IN (";
            for (int i = 0; i < tingkatKolektibilitas.length; i++) {
                KolektibilitasPembayaran kp = new KolektibilitasPembayaran();
                try {
                    kp = PstKolektibilitasPembayaran.fetchExc(Long.valueOf(tingkatKolektibilitas[i]));
                    whereKolektibilitas += i > 0 ? "," + kp.getOID() : "" + kp.getOID();
                    filterTingkatKolektibilitas += i > 0 ? ", " + kp.getJudulKolektibilitas() : "" + kp.getJudulKolektibilitas();
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
            whereKolektibilitas += ")";
        }

        //--------------------------------------------------------------------------
        
        String whereStatus = "";
        String whereStatusCheck = "";
        if (statusKredit != -1) {
            whereStatus += " p." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + statusKredit + "'";
            whereStatusCheck += " p." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + statusKredit + "'";
        } else {
            whereStatus += " p." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " IN ("
                    + Pinjaman.STATUS_DOC_CAIR + ","
                    + Pinjaman.STATUS_DOC_PENANGANAN_MACET + ","
                    + Pinjaman.STATUS_DOC_LUNAS + ","
                    + Pinjaman.STATUS_DOC_PELUNASAN_DINI + ","
                    + Pinjaman.STATUS_DOC_PELUNASAN_MACET + ")";

            whereStatusCheck = " p." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " IN ("
                    + Pinjaman.STATUS_DOC_CAIR + "," + Pinjaman.STATUS_DOC_PENANGANAN_MACET + ")";
        }

        //--------------------------------------------------------------------------
        
        if (!whereJenisKredit.equals("")) {
            whereJenisKredit += " AND ";
        }
        if (!whereNasabah.equals("")) {
            whereNasabah += " AND ";
        }
        if (!whereKolektibilitas.equals("")) {
            whereKolektibilitas += " AND ";
        }
        String whereAdd = " AND ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " <= '" + dateCheck + "'"
                //+ " AND p.NO_KREDIT = 'A-027'" //untuk cek debug per data kredit
                + "";
        String whereCheck = whereJenisKredit + whereNasabah + whereKolektibilitas + whereStatusCheck + whereAdd;
        String whereShow = whereJenisKredit + whereNasabah + whereKolektibilitas + whereStatus + whereAdd;
        String groupBy = " GROUP BY p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID];
        
        //--------------------------------------------------------------------------
        
        String sort = "";
        if (group == 0) {
            sort = " kp." + PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_TINGKAT_KOLEKTIBILITAS];
        } else if (group == 1) {
            sort = " sd." + PstPinjamanSumberDana.fieldNames[PstPinjamanSumberDana.FLD_SUMBER_DANA_ID];
        } else if (group == 2) {
            sort = " p." + PstPinjaman.fieldNames[PstPinjaman.FLD_TIPE_KREDIT_ID];
        }
        
        String order = sort;
                if (group == 0) {
                    order += " " + urut;
                } else {
                    order += ", kp." + PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_TINGKAT_KOLEKTIBILITAS] + " " + urut;
                }
                order += ", p." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT];

        if (dateCheck.equals(Formater.formatDate(new Date(), "yyyy-MM-dd"))) {
            //update status kolektibilitas
            listPinjamanNunggakUpdate = SessReportKredit.listJoinPinjamanKolektibilitas(whereCheck + groupBy, "");
            SessKredit.updateKolektibilitasKredit(listPinjamanNunggakUpdate, dateCheck, true);
            listPinjamanNunggakShow = SessReportKredit.listJoinPinjamanKolektibilitas(whereShow + groupBy, order);
        } else {
            listPinjamanNunggakUpdate = SessReportKredit.listJoinPinjamanKolektibilitas(whereCheck + groupBy, "");
            Vector v = SessKredit.updateKolektibilitasKredit(listPinjamanNunggakUpdate, dateCheck, false);
            listPinjamanNunggakShow = SessKredit.orderHistoryKolektibilitas(v, order);
        }
        
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>SEDANA</title>
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
        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding: 4px 6px !important}
            .tabel_data th, td {font-size: 14px !important}
            .tabel_print {font-size: 10px !important}
            .tabel_print th {border-color: black !important}
            .tabel_print td {border-color: black !important}
            .tabel_header td {padding-bottom: 5px; vertical-align: top; font-size: 14px !important}
            .label_group {background-color: #eaf3df}

            print-area { visibility: hidden; display: none; }
            print-area.preview { visibility: visible; display: block; }
            @media print
            {
                body .main-page * { visibility: hidden; display: none; } 
                body print-area * { visibility: visible; }
                body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
            }
            /*
            .print-area { visibility: hidden; display: none; }
            .print-area.print-preview { visibility: visible; display: block; }
            @media print
            {
                body * { visibility: hidden; }
                .print-area * { visibility: visible; }
                .print-area   { visibility: visible; display: block; position: fixed; top: 0; left: 0; }
            }
            */
        </style>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    Laporan Kolektibilitas Kredit
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

                            <div class="box-header with-border" style="border-color: lightgray">
                                <h3 class="box-title">Form Pencarian</h3>
                            </div>

                            <form class="form-horizontal" id="form_searchKolektibilitas" method="post">
                                <input type="hidden" name="command" value="<%=Command.LIST%>">
                                <input type="hidden" id="printKolektibilitas" name="print_kolektibilitas" value="0">
                                <div class="box-body">

                                    <div class="col-xs-6">
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Tanggal Cek</label>
                                            <div class="col-sm-8">
                                                <input type="text" required="" autocomplete="off" class="form-control input-sm datetime-picker" name="dateCheck" value="<%=dateCheck%>">
                                            </div>
                                        </div>
                                        <%if(1 == 3) {%>
                                            <div class="form-group">
                                            <label class="control-label col-sm-4">Sumber Dana</label>
                                            <div class="col-sm-8">
                                                <select id="sumberDana" style="width: 100%"  class="form-control input-sm select2" multiple="" name="sumber_dana">
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
                                                    %>
                                                    <option <%=selected%> value="<%=sd.getOID()%>"><%=sd.getKodeSumberDana()%> - <%=sd.getJudulSumberDana()%></option>
                                                    <%
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                          <%}%>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Jenis Kredit</label>
                                            <div class="col-sm-8">
                                                <select id="jenisKredit" style="width: 100%" class="form-control input-sm selectAll" multiple="" name="jenis_kredit">
                                                    <%
                                                            Vector<JenisKredit> listSelectedKredit = PstJenisKredit.list(0, 0, "", "");
//                                                            Vector<AssignSumberDanaJenisKredit> listSelectedKredit = PstAssignSumberDanaJenisKredit.list(0, 0, selectedSumberDana.equals("") ? "" : PstAssignSumberDanaJenisKredit.fieldNames[PstAssignSumberDanaJenisKredit.FLD_SUMBER_DANA_ID] + " IN (" + selectedSumberDana + ")", "");
                                                            for (JenisKredit asdjk : listSelectedKredit) {
                                                                try {
                                                                    JenisKredit jk = PstJenisKredit.fetch(asdjk.getOID());
                                                                    String selected = "";
                                                                    if (jenisKredit != null) {
                                                                        for (int j = 0; j < jenisKredit.length; j++) {
                                                                            if (jenisKredit[j].equals("" + jk.getOID())) {
                                                                                selected = "selected";
                                                                                break;
                                                                            }
                                                                        }
                                                                    }
                                                                    out.print("<option " + selected + " value='" + jk.getOID() + "'>" + jk.getNamaKredit() + "</option>");
                                                                } catch (Exception e) {
                                                                    System.out.println(e.getMessage());
                                                                }
                                                            }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                          <%if(1 == 3){%>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Lokasi Kredit</label>
                                            <div class="col-sm-8">
                                              <select id="jenisKredit" style="width: 100%" class="form-control input-sm selectAll" multiple="" name="jenis_kredit">
                                                   <% 
                                                    Vector<Location> listLocation = PstLocation.getListFromApiAll();
                                                    for(Location loc : listLocation){  
                                                    String choosen = "";
                                                    if(lokasi != null){
                                                     for(String oid : lokasi){
                                                      if(loc.getOID() == Long.parseLong(oid)){
                                                       choosen = "selected";
                                                      }
                                                     }
                                                    }
                                                   %>
                                                   <option value="<%= loc.getOID() %>" <%= choosen %>><%= loc.getName() %></option>
                                                   <% } %>
                                                  </select>
                                            </div>
                                        </div>
                                      <%}%>
                                    </div>

                                    <div class="col-xs-6">
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Status Kredit</label>
                                            <div class="col-sm-8">
                                                <select id="statusKredit" style="width: 100%" class="form-control input-sm" name="status_kredit">
                                                    <option <%=statusKredit == -1 ? "selected" : ""%> value="-1">Semua Status</option>
                                                    <option <%=statusKredit == Pinjaman.STATUS_DOC_CAIR ? "selected" : ""%> value="<%=Pinjaman.STATUS_DOC_CAIR%>"><%=Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_CAIR)%></option>
                                                    <option <%=statusKredit == Pinjaman.STATUS_DOC_PENANGANAN_MACET ? "selected" : ""%> value="<%=Pinjaman.STATUS_DOC_PENANGANAN_MACET%>"><%=Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_PENANGANAN_MACET)%></option>
                                                    <option <%=statusKredit == Pinjaman.STATUS_DOC_LUNAS ? "selected" : ""%> value="<%=Pinjaman.STATUS_DOC_LUNAS%>"><%=Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_LUNAS)%></option>
                                                    <option <%=statusKredit == Pinjaman.STATUS_DOC_PELUNASAN_DINI ? "selected" : ""%> value="<%=Pinjaman.STATUS_DOC_PELUNASAN_DINI%>"><%=Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_PELUNASAN_DINI)%></option>
                                                    <option <%=statusKredit == Pinjaman.STATUS_DOC_PELUNASAN_MACET ? "selected" : ""%> value="<%=Pinjaman.STATUS_DOC_PELUNASAN_MACET%>"><%=Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_PELUNASAN_MACET)%></option>
                                                </select>
                                            </div>
                                        </div>
                                           <%if(1 == 3){%>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Tipe <%=namaNasabah%></label>
                                            <div class="col-sm-8" >
                                                <select id="tipeNasabah" style="width: 100%"  class="form-control input-sm select2" multiple="" name="tipe_nasabah">
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
                                                                    if (tipeNasabah[j].equals("" + al.get(i))) {
                                                                        selected = "selected";
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                            out.print("<option " + selected + " value='" + al.get(i) + "'>" + PstContactClass.contactType[al.get(i)] + "</option>");
                                                        }
                                                    %>                          
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Nama <%=namaNasabah%></label>
                                            <div class="col-sm-8" >
                                                <select id="namaNasabah" style="width: 100%" class="form-control input-sm selectAll" multiple="" name="id_nasabah">                                            
                                                    <%
                                                        if (iCommand == Command.LIST) {
                                                            if (selectedTipeNasabah.equals("")) {
                                                                selectedTipeNasabah += "(cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                                                                        + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "')";
                                                            }
                                                            Vector<Anggota> listSelectedNasabah = SessAnggota.listJoinContactClassAssign(0, 0, selectedTipeNasabah, " cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]);
                                                            for (Anggota a : listSelectedNasabah) {
                                                                try {
                                                                    String selected = "";
                                                                    if (nasabah != null) {
                                                                        for (int j = 0; j < nasabah.length; j++) {
                                                                            if (nasabah[j].equals("" + a.getOID())) {
                                                                                selected = "selected";
                                                                                break;
                                                                            }
                                                                        }
                                                                    }
                                                                    out.print("<option " + selected + " value='" + a.getOID() + "'>" + a.getName() + "</option>");
                                                                } catch (Exception e) {
                                                                    System.out.println(e.getMessage());
                                                                }
                                                            }
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                        <%}%>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Tingkat Kolektibilitas</label>
                                            <div class="col-sm-8">
                                                <select id="" style="width: 100%" class="form-control input-sm selectAll" multiple="" name="tingkat_kolektibilitas">
                                                    <%
                                                        Vector listKolektibilitas = PstKolektibilitasPembayaran.list(0, 0, "", "");
                                                        for (int i = 0; i < listKolektibilitas.size(); i++) {
                                                            KolektibilitasPembayaran k = (KolektibilitasPembayaran) listKolektibilitas.get(i);
                                                            String selected = "";
                                                            if (tingkatKolektibilitas != null) {
                                                                for (int j = 0; j < tingkatKolektibilitas.length; j++) {
                                                                    if (tingkatKolektibilitas[j].equals("" + k.getOID())) {
                                                                        selected = "selected";
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                    %>
                                                    <option <%=selected%> value="<%=k.getOID()%>"><%=k.getKodeKolektibilitas()%> - <%=k.getJudulKolektibilitas()%></option>
                                                    <%
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>                                    
                                    </div>
                                </div>

                                <div class="box-footer" style="border-color: lightgrey">
                                    <div class="col-xs-6">
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Urutkan Berdasarkan</label>
                                            <div class="col-sm-8">
                                                <select class="form-control input-sm" name="urutan">
                                                    <option <%=urut.equals("ASC") ? "selected" : ""%> value="ASC">Kolektibilitas lancar</option>
                                                    <option <%=urut.equals("DESC") ? "selected" : ""%> value="DESC">Kolektibilitas tidak Lancar</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xs-6">
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Kelompok Berdasarkan</label>
                                            <div class="col-sm-8">
                                                <select class="form-control input-sm" name="group">
                                                    <option <%=group == 0 ? "selected" : ""%> value="0">Tingkat Kolektibilitas</option>
                                                    <option <%=group == 1 ? "selected" : ""%> value="1">Sumber Dana</option>
                                                    <option <%=group == 2 ? "selected" : ""%> value="2">Jenis Kredit</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="pull-right">
                                            <button type="submit" class="btn btn-sm btn-primary" id="btn-searchKolektibilitas"><i class="fa fa-search"></i> &nbsp; Cari</button>

                                            <% if (!listPinjamanNunggakShow.isEmpty()) {%>
                                            <button type="button" class="btn btn-sm btn-primary" id="btn-printKolektabilitas"><i class="fa fa-file"></i> &nbsp; Cetak</button>
                                            <%}%>

                                        </div>
                                    </div>
                                </div>
                            </form>

                        </div>

                        <% if (iCommand == Command.LIST && print == 0) {%>

                        <div class="box box-success">

                            <div class="box-body">   
                                <h4 class="text-center"><b>LAPORAN KOLEKTIBILITAS KREDIT</b></h4>
                                <div class="form-group">
                                    <table class="tabel_header">
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
                                    <table class="tabel_header">
                                      <%if(1 == 3){%>
                                        <tr>
                                            <td>Sumber Dana</td>
                                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                                            <td><%=filterSumberDana%></td>
                                        </tr>
                                        <%}%>
                                        <tr>
                                            <td style="width: 120px">Jenis Kredit</td>
                                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                                            <td><%=filterJenisKredit%></td>
                                        </tr>
                                        <tr>
                                            <td>Tipe <%=namaNasabah%></td>
                                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                                            <td><%=filterTipeNasabah%></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px">Nama <%=namaNasabah%></td>
                                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                                            <td><%=filterNamaNasabah%></td>
                                        </tr>
                                        <tr>
                                            <td>Kolektibilitas</td>
                                            <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                                            <td><%=filterTingkatKolektibilitas%></td>
                                        </tr>
                                    </table>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-bordered tabel_data">
                                        <tr>
                                            <th rowspan="2">No.</th>
                                            <!--th rowspan="2">Kolektibilitas</th-->
                                            <th rowspan="2">Nomor Kredit</th>
                                            <th rowspan="2">Nama <%=namaNasabah%></th>
                                            <th rowspan="2">Tanggal Realisasi</th>
                                            <th rowspan="2">Jangka Waktu</th>
                                            <th colspan="2">Jumlah Hari Tunggakkan</th>
                                            <th colspan="3">Tunggakan Tanggal <%= dateCheck%></th>
                                            <th colspan="2">Sisa Seluruh Angsuran</th>
                                            <th rowspan="2">Status</th>
                                            <th rowspan="2">Aksi</th>
                                        </tr>
                                        <tr>
                                            <th>Pokok</th>
                                            <th>Bunga</th>
                                            <th>Pokok</th>
                                            <th>Bunga</th>
                                            <th>Total</th>
                                            <th>Pokok</th>
                                            <th>Bunga</th>
                                        </tr>

                                        <%
                                            if (listPinjamanNunggakShow.isEmpty()) {
                                                out.print("<tr><td colspan='15' class='label-default text-center'>Tidak ada data kolektibilitas kredit</td></tr>");
                                            } else {
                                                long groupShow = 0;
                                                int no = 0;
                                                int urutanKolektibilitas = 0;
                                                for (int i = 0; i < listPinjamanNunggakShow.size(); i++) {
                                                    Pinjaman p = listPinjamanNunggakShow.get(i);
                                                    long idPinjaman = p.getOID();
                                                    Date tglAwalTunggakanPokok = SessReportKredit.getTunggakanKredit(idPinjaman, dateCheck, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                                                    Date tglAwalTunggakanBunga = SessReportKredit.getTunggakanKredit(idPinjaman, dateCheck, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                                                    long hariPokok = 0;
                                                    long hariBunga = 0;
                                                    if (tglAwalTunggakanPokok != null) {
                                                        Date jatuhTempoAwal = tglAwalTunggakanPokok;
                                                        Date now = Formater.formatDate(dateCheck, "yyyy-MM-dd");
                                                        long diff = now.getTime() - jatuhTempoAwal.getTime();
                                                        hariPokok = TimeUnit.MILLISECONDS.toDays(diff);
                                                    }
                                                    if (tglAwalTunggakanBunga != null) {
                                                        Date jatuhTempoAwal = tglAwalTunggakanBunga;
                                                        Date now = Formater.formatDate(dateCheck, "yyyy-MM-dd");
                                                        long diff = now.getTime() - jatuhTempoAwal.getTime();
                                                        hariBunga = TimeUnit.MILLISECONDS.toDays(diff);
                                                    }
                                                    //
                                                    double totalPokok = SessReportKredit.getTotalAngsuran(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                                                    double totalBunga = SessReportKredit.getTotalAngsuran(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                                                    double totalBayarPokok = SessReportKredit.getTotalAngsuranDibayar(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                                                    double totalBayarBunga = SessReportKredit.getTotalAngsuranDibayar(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                                                    double sisaPokok = totalPokok - totalBayarPokok;
                                                    double sisaBunga = totalBunga - totalBayarBunga;
                                                    double sisaPokokPerTgl = SessReportKredit.getTotalAngsuranPerTanggalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK, dateCheck);
                                                    double sisaBungaPerTgl = SessReportKredit.getTotalAngsuranPerTanggalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA, dateCheck);
                                                    double angsuranPokokDibayarPerTgl = SessReportKredit.getTotalAngsuranDibayarPerJadwalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK, dateCheck);
                                                    double angsuranBungaDibayarPerTgl = SessReportKredit.getTotalAngsuranDibayarPerJadwalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA, dateCheck);
                                                    double tunggakanPokok = sisaPokokPerTgl - angsuranPokokDibayarPerTgl;
                                                    double tunggakanBunga = sisaBungaPerTgl - angsuranBungaDibayarPerTgl;
                                                    //cari bulan berjalan
                                                    Date awalAngsuran = SessReportKredit.getTanggalAwalAngsuran(idPinjaman);
                                                    Calendar startCalendar = new GregorianCalendar();
                                                    if (awalAngsuran != null) {
                                                        startCalendar.setTime(awalAngsuran);
                                                    }
                                                    Calendar endCalendar = new GregorianCalendar();
                                                    endCalendar.setTime(Formater.formatDate(dateCheck, "yyyy-MM-dd"));
                                                    int diffYear = endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR);
                                                    int diffMonth = diffYear * 12 + endCalendar.get(Calendar.MONTH) - startCalendar.get(Calendar.MONTH);

                                                    Anggota a = new Anggota();
                                                    KolektibilitasPembayaran k = new KolektibilitasPembayaran();
                                                    SumberDana sd = new SumberDana();
                                                    JenisKredit jk = new JenisKredit();
                                                    try {
                                                        a = (p.getAnggotaId() == 0) ? new Anggota() : PstAnggota.fetchExc(p.getAnggotaId());
                                                        k = (p.getKodeKolektibilitas() == 0) ? new KolektibilitasPembayaran() : PstKolektibilitasPembayaran.fetchExc(p.getKodeKolektibilitas());
                                                        sd = (p.getSumberDanaId() == 0) ? new SumberDana() : PstSumberDana.fetchExc(p.getSumberDanaId());
                                                        jk = (p.getTipeKreditId() == 0) ? new JenisKredit() : PstJenisKredit.fetch(p.getTipeKreditId());
                                                    } catch (Exception e) {
                                                        System.out.println(e.getMessage());
                                                    }
                                                    String waktuBerjalan = "" + (diffMonth + 1) + "/" + p.getJangkaWaktu();
                                                    if (diffMonth < 0) {
                                                        waktuBerjalan = "Angsuran belum dimulai";
                                                    }

                                                    if (group == 0) {//kolektibilitas
                                                        if (groupShow != p.getKodeKolektibilitas()) {
                                                            groupShow = p.getKodeKolektibilitas();
                                                            urutanKolektibilitas += 1;
                                                            out.print("<tr class='label_group'><td colspan='15'><b>("+(urutanKolektibilitas)+") Kolektibilitas : " + k.getJudulKolektibilitas().toUpperCase() + "</b></td></tr>");
                                                            no = 1;
                                                        } else {
                                                            no++;
                                                        }
                                                    } else if (group == 1) {//sumber dana
                                                        if (groupShow != p.getSumberDanaId()) {
                                                            groupShow = p.getSumberDanaId();
                                                            out.print("<tr class='label_group'><td colspan='15'><b>Sumber Dana : " + sd.getJudulSumberDana() + "</b></td></tr>");
                                                            no = 1;
                                                        } else {
                                                            no++;
                                                        }
                                                    } else if (group == 2) {//jenis kredit
                                                        if (groupShow != p.getTipeKreditId()) {
                                                            groupShow = p.getTipeKreditId();
                                                            out.print("<tr class='label_group'><td colspan='15'><b>Jenis Kredit : " + jk.getNamaKredit() + "</b></td></tr>");
                                                            no = 1;
                                                        } else {
                                                            no++;
                                                        }
                                                    }
                                        %>
                                        <tr>
                                            <td class="text-center"><%=(no)%>.</td>
                                            <!--td class="text-center"><%=k.getKodeKolektibilitas()%></td-->
                                            <td class="text-center"><a class="text-wrap" href="<%= approot %>/sedana/transaksikredit/jadwal_angsuran.jsp?pinjaman_id=<%= p.getOID() %>"><%=p.getNoKredit()%></a></td>
                                            <td><%=a.getName()%></td>
                                            <td class="text-center"><%=p.getTglRealisasi()%></td>
                                            <td class="text-center"><%=waktuBerjalan%></td>
                                            <td class="text-center"><%=hariPokok%></td>
                                            <td class="text-center"><%=hariBunga%></td>
                                            <td class="money text-right"><%=tunggakanPokok%></td>
                                            <td class="money text-right"><%=tunggakanBunga%></td>
                                            <td class="money text-right"><%=(tunggakanPokok + tunggakanBunga)%></td>
                                            <td class="money text-right"><%=sisaPokok%></td>
                                            <td class="money text-right"><%=sisaBunga%></td>
                                            <td class="text-center"><%=Pinjaman.getStatusDocTitle(p.getStatusPinjaman())%></td>
                                            <%
                                                long kolekSp1 = 0;
                                                try {
                                                    kolekSp1 = Long.valueOf(PstSystemProperty.getValueByName("KOLEKTIBILITAS_SP1_OID"));
                                                } catch (Exception exc) {
                                                    System.out.println("please set KOLEKTIBILITAS_SP1_OID");
                                                }

                                                long kolekSp2 = 0;
                                                try {
                                                    kolekSp2 = Long.valueOf(PstSystemProperty.getValueByName("KOLEKTIBILITAS_SP2_OID"));
                                                } catch (Exception exc) {
                                                    System.out.println("please set KOLEKTIBILITAS_SP2_OID");
                                                }

                                                long kolekSp3 = 0;
                                                try {
                                                    kolekSp3 = Long.valueOf(PstSystemProperty.getValueByName("KOLEKTIBILITAS_SP3_OID"));
                                                } catch (Exception exc) {
                                                    System.out.println("please set KOLEKTIBILITAS_SP3_OID");
                                                }

                                                String type = "";
                                                if (k.getOID() == kolekSp1) {
                                                    type = "SP1";
                                                } else if (k.getOID() == kolekSp2) {
                                                    type = "SP2";
                                                } else if (k.getOID() == kolekSp3) {
                                                    type = "SP3";
                                                }
                                                String buttonPelunasan = "<div class='text-center'><button type='button' title='Pelunasan Dini/Pelunasan Macet' class='btn btn-xs btn-link btn-lunas' data-nomor='" + p.getNoKredit() + "'>Pelunasan</button></div>";
                                                String buttonDocument = "<div class='text-center'><button type='button' title='Dokumen " + type + "' class='btn btn-xs btn-link btn-dokumen' data-oid='" + idPinjaman + "' data-type='" + type + "'>Surat " + type + "</button></div>";
                                                String judulButton = p.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR ? "Pembinaan" : "Batal Pembinaan";
                                                String buttonStatus = "<div class='text-center'><button type='button' title='Penanganan Macet' class='btn btn-xs btn-link btn-macet' data-oid='" + idPinjaman + "'>" + judulButton + "</button></div>";

                                            %>
                                            <td>
                                                <%
                                                    if (p.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR || p.getStatusPinjaman() == Pinjaman.STATUS_DOC_PENANGANAN_MACET) {
                                                        out.print(buttonPelunasan);
                                                    }
                                                %>

                                                <%
                                                    if (k.getOID() == kolekSp1 || k.getOID() == kolekSp2 || k.getOID() == kolekSp3) {
                                                        out.print(buttonDocument);
                                                    }
                                                %>

                                                <%
                                                    if (k.getTingkatKolektibilitas() > 2) {
                                                        out.print(buttonStatus);
                                                    }
                                                %>                          
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            }
                                        %>

                                    </table>                    
                                </div>

                                <br><hr style="border-color: lightgrey">
                                <label>Keterangan :</label>
                                <div class="">
                                    <table class="table table-bordered" style="font-size: 14px">
                                        <tr>
                                            <th rowspan="3">Kode</th>
                                            <th rowspan="3">Keterangan</th>
                                        <%if(useForRaditya.equals("1")){%>
                                            <th colspan="<%=I_Sedana.TIPE_KREDIT.size() * 1%>">Maksimal Jumlah Hari Tunggakan dari Tanggal Jatuh Tempo Pembayaran</th>
                                        <%}else{%>
                                            <th colspan="<%=I_Sedana.TIPE_KREDIT.size() * 2%>">Maksimal Jumlah Hari Tunggakan dari Tanggal Jatuh Tempo Pembayaran</th>
                                        <%}%>
                                            <th rowspan="3">Tingkat Resiko Dana Cadangan Wajib (DCW)</th>
                                        </tr>
                                        <%if(useForRaditya.equals("1")){%>
                                        <tr>
                                            <% for (String[] tipe : I_Sedana.TIPE_KREDIT) {%>
                                            <th colspan="1"><%=tipe[SESS_LANGUAGE]%></th>
                                                <% } %>
                                        </tr>
                                        <%}else{%>
                                        <tr>
                                            <% for (String[] tipe : I_Sedana.TIPE_KREDIT) {%>
                                            <th colspan="2"><%=tipe[SESS_LANGUAGE]%></th>
                                                <% } %>
                                        </tr>
                                        <% } %>
                                        <%if(useForRaditya.equals("1")){%>
                                        <tr>
                                            <% for (int i = 0; i < I_Sedana.TIPE_KREDIT.size(); i++) { %>
                                            <th>Angsuran</th>
                                                <% } %>
                                        </tr>
                                        <%}else{%>
                                        <tr>
                                            <% for (int i = 0; i < I_Sedana.TIPE_KREDIT.size(); i++) { %>
                                            <th>Pokok</th>
                                            <th>Bunga</th>
                                                <% } %>
                                        </tr>
                                        <%}%>
                                        <% Vector<KolektibilitasPembayaran> ps = PstKolektibilitasPembayaran.list(0, 0, PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_KOLEKTIBILITAS_ID] + " IN(SELECT DISTINCT `KOLEKTIBILITAS_ID` FROM sedana_kolektibilitas_pembayaran_details) ", PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_KODE_KOLEKTIBILITAS] + " ASC "); %>
                                        <% for (KolektibilitasPembayaran p : ps) {%>
                                        <tr>
                                            <td class="text-center"><%=p.getKodeKolektibilitas()%></td>  
                                            <td><%=p.getJudulKolektibilitas()%></td>
                                          <%if(useForRaditya.equals("1")){%>
                                            <%
                                                for (int i = 0; i < I_Sedana.TIPE_KREDIT.size(); i++) {
                                                    PstKolektibilitasPembayaranDetails pstdetails = new PstKolektibilitasPembayaranDetails();
                                            %>
                                            <% Vector<KolektibilitasPembayaranDetails> detail = pstdetails.list(0, 0, pstdetails.fieldNames[pstdetails.FLD_TIPEKREIDT] + "=" + i + " AND " + pstdetails.fieldNames[pstdetails.FLD_KOLEKTIBILITASID] + "=" + p.getOID(), "");%>
                                            <% if (detail.size() > 0) {%>
                                            <td class="text-center"><%=(detail.get(0).getMaxHariTunggakanPokok())%></td>
                                            <%} else {%>
                                            <td></td>
                                            <%}%>
                                            <%}%>
                                            <%}else{%>
                                            <%
                                                for (int i = 0; i < I_Sedana.TIPE_KREDIT.size(); i++) {
                                                    PstKolektibilitasPembayaranDetails pstdetails = new PstKolektibilitasPembayaranDetails();
                                            %>
                                            <% Vector<KolektibilitasPembayaranDetails> detail = pstdetails.list(0, 0, pstdetails.fieldNames[pstdetails.FLD_TIPEKREIDT] + "=" + i + " AND " + pstdetails.fieldNames[pstdetails.FLD_KOLEKTIBILITASID] + "=" + p.getOID(), "");%>
                                            <% if (detail.size() > 0) {%>
                                            <td class="text-center"><%=(detail.get(0).getMaxHariTunggakanPokok())%></td>
                                            <%} else {%>
                                            <td></td>
                                            <td></td>
                                            <%}%>
                                            <%}%>
                                            <%}%>
                                            <td class="text-center"><%=p.getTingkatResiko()%></td>
                                        </tr>
                                        <%}%>
                                    </table>
                                </div>
                            </div>

                        </div>

                        <%}%>

                    </div>                    
                </div>
            </section>
        </div>

        <!--------------------------------------------------------------------->

    <print-area>
        <% if (print == 1) {%>
        <div style="size: A5;" class="">
            <div style="overflow: auto">
                <div style="width: 50%; float: left;">
                    <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
                    <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                    <span style="width: 100%; display: inline-block;"><%=compPhone%></span>                    
                </div>
                <div style="width: 50%; float: right; text-align: right">
                    <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">LAPORAN KOLEKTIBILITAS KREDIT</span>
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal &nbsp; : &nbsp; <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Admin &nbsp; : &nbsp; <%=userFullName%></span>                    
                </div>
            </div>
            <hr class="" style="border-color: gray">
            <table class="tabel_header">
                <tr>
                    <td>Sumber Dana</td>
                    <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                    <td><%=filterSumberDana%></td>
                </tr>
                <tr>
                    <td style="width: 120px">Jenis Kredit</td>
                    <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                    <td><%=filterJenisKredit%></td>
                </tr>
                <tr>
                    <td>Tipe <%=namaNasabah%></td>
                    <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                    <td><%=filterTipeNasabah%></td>
                </tr>
                <tr>
                    <td style="width: 100px">Nama <%=namaNasabah%></td>
                    <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                    <td><%=filterNamaNasabah%></td>
                </tr>
                <tr>
                    <td>Kolektibilitas</td>
                    <td>&nbsp;&nbsp;:&nbsp;&nbsp;</td>
                    <td><%=filterTingkatKolektibilitas%></td>
                </tr>
            </table>
            <br>
            <table class="table table-bordered tabel_print">
                <thead>
                    <tr>
                        <th rowspan="2">No.</th>
                        <!--th rowspan="2">Kolektibilitas</th-->
                        <th rowspan="2">Nomor Kredit</th>
                        <th rowspan="2">Nama <%=namaNasabah%></th>
                        <th rowspan="2">Tanggal Realisasi</th>
                        <th rowspan="2">Jangka Waktu</th>
                        <th colspan="2">Jumlah Hari Tunggakkan</th>
                        <th colspan="3">Tunggakan Tanggal <%= dateCheck%></th>
                        <th colspan="2">Sisa Seluruh Angsuran</th>
                        <th rowspan="2">Status</th>
                        <th rowspan="2">Aksi</th>
                    </tr>
                      <tr>
                        <th>Pokok</th>
                        <th>Bunga</th>
                        <th>Pokok</th>
                        <th>Bunga</th>
                        <th>Total</th>
                        <th>Pokok</th>
                        <th>Bunga</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        long groupShow = 0;
                        int no = 0;
                        int urutanKolektibilitas = 0;
                        for (int i = 0; i < listPinjamanNunggakShow.size(); i++) {
                            Pinjaman p = listPinjamanNunggakShow.get(i);
                            long idPinjaman = p.getOID();
                            Date tglAwalTunggakanPokok = SessReportKredit.getTunggakanKredit(idPinjaman, dateCheck, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                            Date tglAwalTunggakanBunga = SessReportKredit.getTunggakanKredit(idPinjaman, dateCheck, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                            long hariPokok = 0;
                            long hariBunga = 0;
                            if (tglAwalTunggakanPokok != null) {
                                Date jatuhTempoAwal = tglAwalTunggakanPokok;
                                Date now = Formater.formatDate(dateCheck, "yyyy-MM-dd");
                                long diff = now.getTime() - jatuhTempoAwal.getTime();
                                hariPokok = TimeUnit.MILLISECONDS.toDays(diff);
                            }
                            if (tglAwalTunggakanBunga != null) {
                                Date jatuhTempoAwal = tglAwalTunggakanBunga;
                                Date now = Formater.formatDate(dateCheck, "yyyy-MM-dd");
                                long diff = now.getTime() - jatuhTempoAwal.getTime();
                                hariBunga = TimeUnit.MILLISECONDS.toDays(diff);
                            }
                            //
                            double totalPokok = SessReportKredit.getTotalAngsuran(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                            double totalBunga = SessReportKredit.getTotalAngsuran(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                            double totalBayarPokok = SessReportKredit.getTotalAngsuranDibayar(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                            double totalBayarBunga = SessReportKredit.getTotalAngsuranDibayar(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                            double sisaPokok = totalPokok - totalBayarPokok;
                            double sisaBunga = totalBunga - totalBayarBunga;
                            double sisaPokokPerTgl = SessReportKredit.getTotalAngsuranPerTanggalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK, dateCheck);
                            double sisaBungaPerTgl = SessReportKredit.getTotalAngsuranPerTanggalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA, dateCheck);
                            double angsuranPokokDibayarPerTgl = SessReportKredit.getTotalAngsuranDibayarPerJadwalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_POKOK, dateCheck);
                            double angsuranBungaDibayarPerTgl = SessReportKredit.getTotalAngsuranDibayarPerJadwalCek(idPinjaman, JadwalAngsuran.TIPE_ANGSURAN_BUNGA, dateCheck);
                            double tunggakanPokok = sisaPokokPerTgl - angsuranPokokDibayarPerTgl;
                            double tunggakanBunga = sisaBungaPerTgl - angsuranBungaDibayarPerTgl;
                            //cari bulan berjalan
                            Date awalAngsuran = SessReportKredit.getTanggalAwalAngsuran(idPinjaman);
                            Calendar startCalendar = new GregorianCalendar();
                            if (awalAngsuran != null) {
                                startCalendar.setTime(awalAngsuran);
                            }
                            Calendar endCalendar = new GregorianCalendar();
                            endCalendar.setTime(Formater.formatDate(dateCheck, "yyyy-MM-dd"));
                            int diffYear = endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR);
                            int diffMonth = diffYear * 12 + endCalendar.get(Calendar.MONTH) - startCalendar.get(Calendar.MONTH);

                            Anggota a = new Anggota();
                            KolektibilitasPembayaran k = new KolektibilitasPembayaran();
                            SumberDana sd = new SumberDana();
                            JenisKredit jk = new JenisKredit();
                            try {
                                a = PstAnggota.fetchExc(p.getAnggotaId());
                                k = PstKolektibilitasPembayaran.fetchExc(p.getKodeKolektibilitas());
                                sd = PstSumberDana.fetchExc(p.getSumberDanaId());
                                jk = PstJenisKredit.fetch(p.getTipeKreditId());
                            } catch (Exception e) {
                                System.out.println(e.getMessage());
                            }
                            String waktuBerjalan = "" + (diffMonth + 1) + "/" + p.getJangkaWaktu();
                            if (diffMonth < 0) {
                                waktuBerjalan = "Angsuran belum dimulai";
                            }

                            if (group == 0) {//kolektibilitas
                                if (groupShow != p.getKodeKolektibilitas()) {
                                    groupShow = p.getKodeKolektibilitas();
                                    urutanKolektibilitas += 1;
                                    out.print("<tr class='label_group'><td colspan='15'><b>("+(urutanKolektibilitas)+") Kolektibilitas : " + k.getJudulKolektibilitas().toUpperCase() + "</b></td></tr>");
                                    no = 1;
                                } else {
                                    no++;
                                }
                            } else if (group == 1) {//sumber dana
                                if (groupShow != p.getSumberDanaId()) {
                                    groupShow = p.getSumberDanaId();
                                    out.print("<tr class='label_group'><td colspan='15'><b>Sumber Dana : " + sd.getJudulSumberDana() + "</b></td></tr>");
                                    no = 1;
                                } else {
                                    no++;
                                }
                            } else if (group == 2) {//jenis kredit
                                if (groupShow != p.getTipeKreditId()) {
                                    groupShow = p.getTipeKreditId();
                                    out.print("<tr class='label_group'><td colspan='15'><b>Jenis Kredit : " + jk.getNamaKredit() + "</b></td></tr>");
                                    no = 1;
                                } else {
                                    no++;
                                }
                            }
                    %>
                    <tr>
                        <td class="text-center"><%=(no)%>.</td>
                        <!--td class="text-center"><%=k.getJudulKolektibilitas()%></td-->
                        <td class=""><%=p.getNoKredit()%></td>
                        <td><%=a.getName()%></td>
                        <td class="text-center"><%=p.getTglRealisasi()%></td>
                        <td class="text-center"><%=waktuBerjalan%></td>
                        <td class="text-center"><%=hariPokok%></td>
                        <td class="text-center"><%=hariBunga%></td>
                        <td class="money text-right"><%=tunggakanPokok%></td>
                        <td class="money text-right"><%=tunggakanBunga%></td>
                        <td class="money text-right"><%=(tunggakanPokok + tunggakanBunga)%></td>
                        <td class="money text-right"><%=sisaPokok%></td>
                        <td class="money text-right"><%=sisaBunga%></td>
                        <td class="text-center"><%=Pinjaman.getStatusDocTitle(p.getStatusPinjaman())%></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
                
        <script>
            window.print();
        </script>
        <%}%>
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
    <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>
    <script src="../../style/dist/js/dimata-app.js" type="text/javascript"></script>
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
                $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                $('#printKolektibilitas').val(1);
                $('#form_searchKolektibilitas').submit();
                //window.print();
                //$(this).removeAttr('disabled').html(buttonHtml);
            });

            $(document).on("keydown", function (event) {
                if (event.which === 8 && !$(event.target).is("input, textarea")) {
                    event.preventDefault();
                }
            });

            $('#sumberDana').change(function () {
                var id = $(this).val();
                var dataSend = {
                    "SEND_ARRAY_ID_SUMBER_DANA": "" + id + "",
                    "FRM_FIELD_DATA_FOR": "getOptionJenisKredit",
                    "command": "<%=Command.NONE%>"
                };
                onDone = function (data) {
                    $('#jenisKredit').html(data.FRM_FIELD_HTML);
                };
                onSuccess = function (data) {

                };
                //alert(JSON.stringify(dataSend));
                getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                return false;
            });

            $('#tipeNasabah').change(function () {
                var id = $(this).val();
                var dataSend = {
                    "SEND_ARRAY_ID_NASABAH": "" + id + "",
                    "FRM_FIELD_DATA_FOR": "getOptionNasabah",
                    "command": "<%=Command.NONE%>"
                };
                onDone = function (data) {
                    $('#namaNasabah').html(data.FRM_FIELD_HTML);
                };
                onSuccess = function (data) {

                };
                //alert(JSON.stringify(dataSend));
                getDataFunction(onDone, onSuccess, dataSend, "AjaxAnggota", null, false);
                return false;
            });

            $('body').on("click", ".btn-dokumen", function () {
                var oid = $(this).data('oid');
                var type = $(this).data('type');
                window.open("<%=approot%>/masterdata/masterdokumen/dokumen_edit.jsp?oid_pinjaman=" + oid + "&type=" + type, '_blank', 'location=yes,height=720,width=890,scrollbars=yes,status=yes');
            });

            $('body').on("click", ".btn-macet", function () {
                var oid = $(this).data('oid');
                var data = $('#form_searchKolektibilitas').serialize();
                window.location = "report_kolektabilitas.jsp?" + data + "&kredit_id=" + oid;
            });

            $('body').on("click", ".btn-lunas", function () {
                var no = $(this).data('nomor');
                window.location = "../../sedana/transaksikredit/form_pembayaran_kredit.jsp?nomor_kredit=" + no;
            });

            if ("<%=iCommand%>" == 0) {
                $('#sumberDana').trigger('change');
                $('#tipeNasabah').trigger('change');
            }

        });
    </script>
    <%--@ include file = "/footerkoperasi.jsp" --%>
</body>
</html>
