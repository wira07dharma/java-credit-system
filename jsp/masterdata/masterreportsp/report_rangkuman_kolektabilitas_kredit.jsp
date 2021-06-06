<%-- 
    Document   : report_rangkuman_kolektabilitas_kredit
    Created on : 01 Agu 20, 11:19:38
    Author     : gndiw
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.ParseException"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
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
    String startMonth = FRMQueryString.requestString(request, "start_month");
    String endMonth = FRMQueryString.requestString(request, "end_month");
    String tipeNasabah[] = request.getParameterValues("tipe_nasabah");
    String sumberDana[] = request.getParameterValues("sumber_dana");
    String jenisKredit[] = request.getParameterValues("jenis_kredit");    
    String useForRaditya = PstSystemProperty.getValueByName("USE_FOR_RADITYA");  
    int lunas = FRMQueryString.requestInt(request, "lunas");
    String[] lokasi = request.getParameterValues("FORM_LOKASI");
    int jenisLaporan = FRMQueryString.requestInt(request, "form_jenis_laporan");
    if (dateCheck.equals("")) {
        dateCheck = "" + Formater.formatDate(new Date(), "yyyy-MM-dd");
    }
    if (startMonth.equals("")){
        startMonth = ""+Formater.formatDate(new Date(), "MMMM yyyy");
    }
    if (endMonth.equals("")){
        endMonth = ""+Formater.formatDate(new Date(), "MMMM yyyy");
    }
    
    String inLokasi = "";
    if (lokasi != null) {
        int count = 0;
        for(String loc : lokasi){
                if(count > 0){
                        inLokasi += ",";
                }
                inLokasi += loc;
                count++;
        }
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
    Vector<Location> listLocation = PstLocation.getListFromApiAll();
    HashMap<String,Double> listData = new HashMap<String, Double>();
    HashMap<String,Double> listDataNPL = new HashMap<String, Double>();
            
    if (iCommand == Command.LIST) {
        listData = SessReportKredit.rangkumanKolekBulanan(0, startMonth, endMonth, inLokasi, lunas);
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
        <script language="javascript">
            $(document).ready(function () {

                var approot = "<%= approot%>";
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

                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };


                //Select2
                $('.select2').select2({placeholder: "Semua"});
                $('.selectAll').select2({placeholder: "Semua"});

                //        Date Picker
                

                


                $('input[type="checkbox"].flat-blue').iCheck({
                    checkboxClass: 'icheckbox_square-blue'
                });

            });
        </script>
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
                                            <label class="control-label col-sm-4">Jenis Pencarian</label>
                                            <div class="col-sm-8">
                                                <select class="form-control input-sm select2" id="form_jenis_laporan" name="form_jenis_laporan">
                                                    <option value="0">Bulanan</option>
                                                    <option value="1">Per Tanggal</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Tanggal</label>
                                            <div class="col-sm-8">
                                                <input type="text" autocomplete="off" style="float: left;width: 45%;" class="date-bulanan form-control date-picker" aria-describedby="basic-addon2"  id="startDate" name="start_month" value="<%=startMonth%>" placeholder="semua tanggal">
                                                <span class="input-group-addon date-bulanan" id="basic-addon2" style="float: left;height: 34px;text-align: center;width: 10%;padding: 8px 0px 0px 0px;display: inline-block;">s/d</span>
                                                <input type="text" autocomplete="off" style="float: left;width: 45%;" class="date-bulanan form-control date-picker" aria-describedby="basic-addon2" id="endDate" name="end_month" value="<%=endMonth%>" placeholder="semua tanggal">

                                                <input type="text" autocomplete="off" style="float: left;width: 45%;" class="date-harian form-control datePicker" aria-describedby="basic-addon2" id="startDate1" name="dateCheck" value="<%=dateCheck%>" placeholder="semua tanggal">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Lokasi</label>
                                            <div class="col-sm-8">
                                                <select class="form-control select2" multiple="multiple" name="FORM_LOKASI">
                                                    <% 
                                                            for(Location loc : listLocation){  
                                                            String choosen = "";
                                                            boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+loc.getOID());
                                                            if (loc.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
                                                                if(lokasi != null){
                                                                        for(String oid : lokasi){
                                                                                if(loc.getOID() == Long.parseLong(oid)){
                                                                                        choosen = "selected";
                                                                                }
                                                                        }
                                                                } else if (loc.getOID() == userSession.getAppUser().getAssignLocationId()) {
                                                                    choosen = "selected";
                                                                }
                                                                %><option value="<%= loc.getOID() %>" <%= choosen %>><%= loc.getName() %></option><%
                                                            }
                                                    %>
                                                    <% } %>
                                            </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Tampilkan PK Lunas</label>
                                            <div class="col-sm-8">
                                                <label class="radio-inline">
                                                    <input type="radio" name="lunas" value="0" <%=lunas == 0 ? "checked" : ""%>> Tidak
                                                </label>
                                                <label class="radio-inline">
                                                    <input type="radio" name="lunas" value="1" <%=lunas == 1 ? "checked" : ""%>> Ya
                                                </label>
                                            </div>
                                        </div>
                                    </div>

                                    
                                            
                                    <div class="col-xs-6">
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
                                        <% if (jenisLaporan == 1) {%>
                                        <tr>
                                            <td><b>Per Tanggal</b></td>
                                            <td><b> &nbsp; : &nbsp;</b> </td>
                                            <td><b><%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></b></td>
                                        </tr>
                                        <% } else { %>
                                        <tr>
                                            <td><b>Periode</b></td>
                                            <td> <b>&nbsp; : &nbsp; </b></td>
                                            <td><b><%=startMonth%> sampai <%=endMonth%></b></td>
                                        </tr>
                                        <% } %>
                                    </table>
                                </div>

                                <div class="table-responsive">
                                    <%
                                    if (listData.size()>0){
                                        Calendar start = Calendar.getInstance();
                                        Calendar end = Calendar.getInstance();
                                        DateFormat formater = new SimpleDateFormat("MMMM yyyy");
                                        try {
                                            start.setTime(formater.parse(startMonth));
                                            end.setTime(formater.parse(endMonth));
                                        } catch (ParseException e) {
                                            e.printStackTrace();
                                        }
                                        %>
                                    <table class="table table-bordered table-striped" style="font-size: 14px">
                                        <tr>
                                                <th>Kriteria</th>
                                                <%
                                                    while (start.before(end) || start.equals(end)) {
                                                        %>
                                                            <th><%=Formater.formatDate(start.getTime(), "MMMM")%></th>
                                                            <th><%=Formater.formatDate(start.getTime(), "MMMM")%></th>
                                                        <%
                                                        start.add(Calendar.MONTH, 1);
                                                    }
                                                %>
                                             </tr>

                                         <%
                                         Vector list = PstKolektibilitasPembayaran.listJoin(0, 0, "", "det."+PstKolektibilitasPembayaranDetails.fieldNames[PstKolektibilitasPembayaranDetails.FLD_MAXHARITUNGGAKANPOKOK]);
                                         for (int x = 0; x < list.size(); x++){
                                             KolektibilitasPembayaran kolek = (KolektibilitasPembayaran) list.get(x);
                                             try {
                                                start.setTime(formater.parse(startMonth));
                                                end.setTime(formater.parse(endMonth));
                                            } catch (ParseException e) {
                                                e.printStackTrace();
                                            }
                                             %>
                                             <tr>
                                                 <td><%=kolek.getJudulKolektibilitas()%></td>
                                                 <%
                                                     
                                                    while (start.before(end) || start.equals(end)) {
                                                        String bulan = Formater.formatDate(start.getTime(), "MMMM");
                                                        %>
                                                            <td><%=String.format("%,.0f", listData.get(kolek.getJudulKolektibilitas()+"_"+bulan+"_JUMLAH"))%></td>
                                                            <td><%=String.format("%,.2f", listData.get(kolek.getJudulKolektibilitas()+"_"+bulan+"_SISA"))%></td>
                                                        <%
                                                        if (listDataNPL.containsKey("TOTAL_JUMLAH_"+bulan)){
                                                            listDataNPL.put("TOTAL_JUMLAH_"+bulan, (listDataNPL.get("TOTAL_JUMLAH_"+bulan) +  listData.get(kolek.getJudulKolektibilitas()+"_"+bulan+"_JUMLAH")));
                                                        } else {
                                                            listDataNPL.put("TOTAL_JUMLAH_"+bulan, listData.get(kolek.getJudulKolektibilitas()+"_"+bulan+"_JUMLAH"));
                                                        }
                                                        if (listDataNPL.containsKey("TOTAL_SISA_"+bulan)){
                                                            listDataNPL.put("TOTAL_SISA_"+bulan, (listDataNPL.get("TOTAL_SISA_"+bulan) +  listData.get(kolek.getJudulKolektibilitas()+"_"+bulan+"_SISA")));
                                                        } else {
                                                            listDataNPL.put("TOTAL_SISA_"+bulan, listData.get(kolek.getJudulKolektibilitas()+"_"+bulan+"_SISA"));
                                                        }
                                                        start.add(Calendar.MONTH, 1);
                                                    }
                                                %>
                                             </tr>
                                             <%
                                         }
                                         %>
                                             <tr>
                                                 <td>&nbsp;</td>
                                                 <%
                                                     try {
                                                        start.setTime(formater.parse(startMonth));
                                                        end.setTime(formater.parse(endMonth));
                                                    } catch (ParseException e) {
                                                        e.printStackTrace();
                                                    }
                                                    while (start.before(end) || start.equals(end)) {
                                                        String bulan = Formater.formatDate(start.getTime(), "MMMM");
                                                        %>
                                                        <td><b><%=String.format("%,.0f", listDataNPL.get("TOTAL_JUMLAH_"+bulan))%></b></td>
                                                        <td><b><%=String.format("%,.2f", listDataNPL.get("TOTAL_SISA_"+bulan))%></b></td>
                                                        <%
                                                        start.add(Calendar.MONTH, 1);
                                                    }
                                                %>
                                             </tr>
                                    </table>
                                    <table style="border-collapse: collapse; width: 50%; margin-left: 25%; padding: 10px">
                                        <%
                                            try {
                                                start.setTime(formater.parse(startMonth));
                                                end.setTime(formater.parse(endMonth));
                                            } catch (ParseException e) {
                                                e.printStackTrace();
                                            }
                                            while (start.before(end) || start.equals(end)) {
                                                String bulan = Formater.formatDate(start.getTime(), "MMMM");
                                                %>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                    <td rowspan="2" style="vertical-align: middle; text-align: right; padding: 10px"><b>NPL <%=Formater.formatDate(start.getTime(), "MMMM yyyy")%></b></td>
                                                    <td style="border-bottom: solid;vertical-align: middle; width: 20%; text-align: center; padding: 10px"><%=String.format("%,.0f", listDataNPL.get("TOTAL_SISA_"+bulan) - listData.get("Lancar"+"_"+bulan+"_SISA"))%></td>
                                                    <td rowspan="2" style="vertical-align: middle; width: 10%;text-align: right; padding: 10px">x 100%</td>
                                                    <td rowspan="2" style="vertical-align: middle; border: solid; text-align: center; padding: 10px"><%=String.format("%,.0f", ((listDataNPL.get("TOTAL_SISA_"+bulan) - listData.get("Lancar"+"_"+bulan+"_SISA")) / listDataNPL.get("TOTAL_JUMLAH_"+bulan)) * 100 )%> %</td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                    <td style="vertical-align: middle; width: 20%; text-align: center; padding: 10px"><%=String.format("%,.2f", listDataNPL.get("TOTAL_SISA_"+bulan))%></td>
                                                </tr>
                                                <tr>
                                                    <td colspan="5">&nbsp;</td>
                                                </tr>
                                                <%
                                                start.add(Calendar.MONTH, 1);
                                            }
                                        %>
                                    </table>
                                         <%
                                     }
                                    %>                                                          
                                </div>

                                

                            </div>

                        </div>

                        <%}%>

                    </div>
                </div>

            </section>
        </div>
                        
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

                $('.datePicker').datetimepicker({
                    format: "yyyy-mm-dd",
                    todayBtn: true,
                    autoclose: true,
                    minView: 2
                });

                $('.date-picker').datetimepicker({
                    format: "MM yyyy",
                    autoclose: true,
                    minView: 3,
                    startView : 3
                });

                $(window).load(function () {
                    <% if (jenisLaporan == 1) { %>
                        $('.date-harian').css("display", "block");
                        $('.date-bulanan').css("display", "none");    
                    <% } else { %>
                        $('.date-harian').css("display", "none");
                        $('.date-bulanan').css("display", "block");
                    <% } %>
                });

                $('#form_jenis_laporan').change(function () {
                    var transaski = $('#form_type_transaksi').val();
                    var laporan = $('#form_jenis_laporan').val();
                    if (laporan == 1) {
                        $('#tampilan').css("display", "none");
                        $('.date-harian').css("display", "none");
                        $('.date-bulanan').css("display", "block");
                    } else if (laporan == 2) {
                        $('#tampilan').css("display", "block");
                        if (transaski == 0) {
                            $('#tampilan').css("display", "block");
                            $('#tampilan-invoice').css("display", "block");
                            $('#tampilan-kredit').css("display", "none");
                            ;
                            $("input[type='checkbox']#check-kredit").iCheck('uncheck');
                        } else if (transaski == 4) {
                            $('#tampilan').css("display", "block");
                            $('#tampilan-kredit').css("display", "block");
                            $('#tampilan-invoice').css("display", "none");
                            $("input[type='checkbox']#check-invoice").iCheck('uncheck');
                        } else if (transaski == 6) {
                            $('#tampilan').css("display", "none");
                            $('#tampilan-invoice').css("display", "none");
                            $('#tampilan-kredit').css("display", "none");
                            $("input[type='checkbox']#check-invoice").iCheck('uncheck');
                            $("input[type='checkbox']#check-kredit").iCheck('uncheck');
                        }
                        $('.date-bulanan').css("display", "none");
                        $('.date-harian').css("display", "block");
                    }
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

        <%--@ include file = "/footerkoperasi.jsp" --%>
    </body>
</html>
