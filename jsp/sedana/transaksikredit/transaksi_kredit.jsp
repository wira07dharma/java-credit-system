<%-- 
    Document   : transaksi_kredit
    Created on : Jul 4, 2017, 1:50:29 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.services.WebServices"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.dimata.posbo.entity.masterdata.PstMaterial"%>
<%@page import="com.dimata.posbo.entity.masterdata.Material"%>
<%@page import="com.dimata.pos.entity.billing.Billdetail"%>
<%@page import="com.dimata.pos.entity.billing.PstBillDetail"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterLoket"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterLoket"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.JangkaWaktu"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstJangkaWaktu"%>
<%@page import="com.dimata.harisma.entity.masterdata.Marital"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstMarital"%>
<%@page import="com.dimata.harisma.entity.masterdata.Position"%>
<%@page import="com.dimata.harisma.entity.masterdata.PstPosition"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Vocation"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstVocation"%>
<%@page import="com.dimata.aiso.form.masterdata.anggota.FrmAnggota"%>
<%@page import="com.dimata.common.form.contact.FrmContactList"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.posbo.entity.masterdata.PstSales"%>
<%@page import="com.dimata.pos.entity.billing.PstBillMain"%>
<%@page import="com.dimata.posbo.entity.masterdata.Sales"%>
<%@page import="com.dimata.pos.entity.billing.BillMain"%>
<%@page import="com.dimata.pos.form.billing.FrmBillMain"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmAssignContact"%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.sedana.entity.assignsumberdana.AssignSumberDana"%>
<%@page import="com.dimata.sedana.entity.assignsumberdana.PstAssignSumberDana"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="com.dimata.sedana.session.SessKredit"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjamanSumberDana"%>
<%@page import="com.dimata.sedana.entity.kredit.PinjamanSumberDana"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.form.kredit.FrmPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.entity.sumberdana.SumberDana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.PstSumberDana"%>
<%@page import="com.dimata.sedana.entity.kredit.TypeKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.PstTypeKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>

<%    // GET OID PINJAMAN
    long oidPinjaman = FRMQueryString.requestLong(request, "pinjaman_id");
    boolean exchangeStatus = FRMQueryString.requestBoolean(request, "exchange_status");
    long billId = FRMQueryString.requestLong(request, "billId");
    int tipePengajuan = FRMQueryString.requestInt(request, "TIPE_PENGAJUAN");
    long bil = FRMQueryString.requestLong(request, "BILL_MAIN_ID");
    int iCommand = FRMQueryString.requestCommand(request);
    String[] simulasiMatId = request.getParameterValues("OID_MATERIAL");
    String[] simulasiMatQty = request.getParameterValues("MATERIAL_QTY");
    String[] simulasiMatPrice = request.getParameterValues("MATERIAL_PRICE");
    long oidSimulasiMat = 0;
    int QtySimulasi = 0;
    double priceSimulasi = 0;
    Material mti = new Material();
    String typeOfCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
    String sedanaAppUrl = PstSystemProperty.getValueByName("SEDANA_APP_URL");
    String posAppUrl = PstSystemProperty.getValueByName("POS_APP_URL");

    String errorMessage = "";
    double deposit = 0;
    // DATA PINJAMAN
    String tglPengajuan = "";
    String tglRealisasi = "";
    String tglJatuhTempo = "";
    String tglLunas = "";
    double simulasiDeposit = 0;

    // DATA JENIS KREDIT
    String tipeFrekuensi = "";

    Pinjaman pinjaman = new Pinjaman();
    Anggota anggota = new Anggota();
    JenisKredit kredit = new JenisKredit();
    PinjamanSumberDana sumberDana = new PinjamanSumberDana();
    BillMain billMain = new BillMain();
//    Sales sales = new Sales();
    AppUser sales = new AppUser();
    Location location = new Location();
    boolean tidakAdaTransaksiPembayaran = false;
    String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
    double totalBunga = 0;
    double totalPokok = 0;
    double totalDp = 0;

    /* cek apakah bill sudah ada pinjaman */
    if (billId > 0 || bil > 0) {
        Vector listPinjamanByBill = PstPinjaman.list(0, 0,
                PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID] + "=" + billId, "");
        if (listPinjamanByBill.size() > 0) {
            Pinjaman entPinjaman = (Pinjaman) listPinjamanByBill.get(0);
            oidPinjaman = entPinjaman.getOID();
            iCommand = Command.EDIT;
        }
    }

    if (iCommand == Command.ADD) {
        tglPengajuan = Formater.formatDate(new Date(), "yyyy-MM-dd");
        tglLunas = "Otomatis saat disimpan";
        try {
            String url = posApiUrl + "/bill/billmain/" + billId;
            try {
                JSONObject jo = WebServices.getAPI("", url);
                JSONObject joSales = jo.optJSONObject("pos_app_user");
//                JSONObject joSales = jo.optJSONObject(PstSales.TBL_SALES);
                JSONObject joCustomer = jo.optJSONObject(PstContactList.TBL_CONTACT_LIST);

                long oidBillMain = PstBillMain.syncExc(jo);
                long oidSales = PstAppUser.syncExc(joSales);
//                long oidSales = PstSales.syncExc(joSales);
                long oidCustomer = PstContactList.syncExc(joCustomer);
                billMain = PstBillMain.fetchExc(oidBillMain);
                anggota = PstAnggota.fetchExc(oidCustomer);
                sales = PstAppUser.fetch(oidSales);
            } catch (Exception exc) {

            }
        } catch (Exception exc) {
        }
    }

    if (iCommand == Command.EDIT) {
        try {
            pinjaman = PstPinjaman.fetchExc(oidPinjaman);
            anggota = PstAnggota.fetchExc(pinjaman.getAnggotaId());
            kredit = PstTypeKredit.fetchExc(pinjaman.getTipeKreditId());
            if (pinjaman.getBillMainId() > 0) {
                billId = pinjaman.getBillMainId();
                billMain = PstBillMain.fetchExc(billId);
                sales = PstAppUser.fetch(billMain.getAppUserSalesId());
//                sales = PstSales.getObjectSales(billMain.getSalesCode());
            }
            tglPengajuan = (pinjaman.getTglPengajuan() == null) ? "" : Formater.formatDate(pinjaman.getTglPengajuan(), "yyyy-MM-dd");
            tglRealisasi = (pinjaman.getTglRealisasi() == null) ? "" : Formater.formatDate(pinjaman.getTglRealisasi(), "yyyy-MM-dd");
            tglJatuhTempo = (pinjaman.getJatuhTempo() == null) ? "" : Formater.formatDate(pinjaman.getJatuhTempo(), "yyyy-MM-dd");
            tglLunas = (pinjaman.getTglLunas() == null) ? "" : Formater.formatDate(pinjaman.getTglLunas(), "yyyy-MM-dd");
            String arrayTipeFrekuensi[] = I_Sedana.TIPE_KREDIT.get(kredit.getTipeFrekuensiPokokLegacy());
            tipeFrekuensi = arrayTipeFrekuensi[SESS_LANGUAGE];

            Vector dataSumberDana = PstPinjamanSumberDana.list(0, 0, "" + PstPinjamanSumberDana.fieldNames[PstPinjamanSumberDana.FLD_PINJAMAN_ID] + " = '" + pinjaman.getOID() + "'", "");
            if (!dataSumberDana.isEmpty()) {
                PinjamanSumberDana resultSumberDana = (PinjamanSumberDana) dataSumberDana.get(0);
                try {
                    sumberDana = PstPinjamanSumberDana.fetchExc(resultSumberDana.getOID());
                } catch (Exception e) {
                    errorMessage += e.getMessage();
                }
            }
            tidakAdaTransaksiPembayaran = SessKredit.getListAngsuranByPinjaman(pinjaman.getOID()).isEmpty();

            if (pinjaman.getStatusPinjaman() >= Pinjaman.STATUS_DOC_CAIR) {
                //update status kolektibilitas
                Vector<Pinjaman> listPinjaman = PstPinjaman.list(0, 0, PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = " + pinjaman.getOID(), null);
                SessKredit.updateKolektibilitasKredit(listPinjaman);
            }
            
            String whereClause = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + oidPinjaman;
            Vector<JadwalAngsuran> listAngsurangData = PstJadwalAngsuran.list(0, 0, whereClause, "");
            for(JadwalAngsuran ja : listAngsurangData){
                double jumlahAngsuran = ja.getJumlahANgsuran();
                if(ja.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT){
                    totalDp += jumlahAngsuran;
                } else if (ja.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_POKOK){
                    totalPokok += jumlahAngsuran;
                } else if (ja.getJenisAngsuran() == JadwalAngsuran.TIPE_ANGSURAN_BUNGA){
                    totalBunga += jumlahAngsuran;
                }
            }
            
            totalPokok = SessReportKredit.getTotalAngsuran(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_POKOK);
            totalBunga = SessReportKredit.getTotalAngsuran(pinjaman.getOID(), JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
            
        } catch (Exception exc) {
            errorMessage += exc.getMessage();
        }
    }

    //==========================================================================
    deposit = pinjaman.getDownPayment();
    if (typeOfCredit.equals("0")) {
        int simulasi = FRMQueryString.requestInt(request, "direct_simulasi");
        long simulasiJenisKreditId = FRMQueryString.requestLong(request, "FORM_JENIS_KREDIT");
        double simulasiJumlahPengajuan = FRMQueryString.requestDouble(request, "FORM_JUMLAH_PENGAJUAN");
        int simulasiJangkaWaktu = FRMQueryString.requestInt(request, "FORM_JANGKA_WAKTU");
        double simulasiSukuBunga = FRMQueryString.requestDouble(request, "FORM_SUKU_BUNGA");
        int simulasiTipeBunga = FRMQueryString.requestInt(request, "FORM_TIPE_BUNGA");
        int simulasiTipeJadwal = FRMQueryString.requestInt(request, "FORM_TIPE_JADWAL");
        int viewNet = FRMQueryString.requestInt(request, "FORM_VIEW_DANA_NET");
        double simulasiBiayaLain = FRMQueryString.requestDouble(request, "FORM_BIAYA_LAIN");
        double simulasiBunga = FRMQueryString.requestDouble(request, "FORM_JUMLAH_BUNGA");

        if (simulasi == 1) {
            // DATA KREDIT DIISI OTOMATIS DARI MENU SIMULASI KREDIT
            try {
                pinjaman.setTipeKreditId(simulasiJenisKreditId);
                pinjaman.setJumlahPinjaman((viewNet == 1) ? (simulasiJumlahPengajuan + simulasiBiayaLain) : simulasiJumlahPengajuan);
                pinjaman.setJangkaWaktu(simulasiJangkaWaktu);
                pinjaman.setSukuBunga(simulasiSukuBunga);
                pinjaman.setTipeBunga(simulasiTipeBunga);
                pinjaman.setTipeJadwal(simulasiTipeJadwal);
                pinjaman.setJumlahBunga(simulasiBunga);
                kredit = PstTypeKredit.fetchExc(simulasiJenisKreditId);
                String arrayTipeFrekuensi[] = I_Sedana.TIPE_KREDIT.get(kredit.getTipeFrekuensiPokokLegacy());
                tipeFrekuensi = arrayTipeFrekuensi[SESS_LANGUAGE];

            } catch (Exception e) {
                errorMessage += e.getMessage();
            }
        }

    } else if (bil != 0 || billId > 0) {
        int simulasi = FRMQueryString.requestInt(request, "direct_simulasi");
        long simulasiJenisKreditId = FRMQueryString.requestLong(request, "FORM_JENIS_KREDIT");
        double simulasiJumlahPengajuan = FRMQueryString.requestDouble(request, "FORM_JUMLAH_PINJAMAN");
        long simulasiJangkaWaktu = FRMQueryString.requestLong(request, "FORM_JANGKA_WAKTU");
        int simulasiTipeJadwal = FRMQueryString.requestInt(request, "FORM_TIPE_JADWAL");
        int viewNet = FRMQueryString.requestInt(request, "FORM_VIEW_DANA_NET");
        double simulasiBiayaLain = FRMQueryString.requestDouble(request, "FORM_BIAYA_LAIN");
        simulasiDeposit = FRMQueryString.requestDouble(request, "FORM_DOWN_PAYMENT");
        String tglJadi = FRMQueryString.requestString(request, "FRM_TGL_REALISASI");
        tglRealisasi = tglJadi.length() > 0 && !tglJadi.equals("") ? tglJadi : tglRealisasi;
        if(simulasiDeposit > 0 && deposit <= 0){
            deposit = simulasiDeposit;
        }
        
        if (!tglRealisasi.equals("")) {
            tglJatuhTempo = tglRealisasi;
        }
        if (simulasi == 1) {
            // DATA KREDIT DIISI OTOMATIS DARI MENU SIMULASI KREDIT
            try {
                pinjaman.setTipeKreditId(simulasiJenisKreditId);
                pinjaman.setJumlahPinjaman((viewNet == 1) ? (simulasiJumlahPengajuan + simulasiBiayaLain) : simulasiJumlahPengajuan);
                pinjaman.setJangkaWaktuId(simulasiJangkaWaktu);
                pinjaman.setTipeJadwal(simulasiTipeJadwal);
                pinjaman.setTglRealisasi(Formater.formatDate(tglRealisasi, "yyyy-MM-dd"));
                pinjaman.setJatuhTempo(Formater.formatDate(tglRealisasi, "yyyy-MM-dd"));
                String arrayTipeFrekuensi[] = I_Sedana.TIPE_KREDIT.get(kredit.getTipeFrekuensiPokokLegacy());
                tipeFrekuensi = arrayTipeFrekuensi[SESS_LANGUAGE];
                if (simulasiJenisKreditId != 0) {
                    kredit = PstTypeKredit.fetchExc(simulasiJenisKreditId);
                }
            } catch (Exception e) {
                errorMessage += e.getMessage();
            }
        }
    }
    
    if(billId != 0 && bil == 0){
        bil = billId;
    } else if(billId == 0 && bil != 0){
        billId = bil;
    }

    AppUser user = new AppUser();
    try {
        user = PstAppUser.fetch(userOID);
    } catch (Exception e) {
    }

    String style = "";
    if (typeOfCredit.equals("1")) {
        style = "style='display: none'";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <!-- Bootstrap 3.3.6 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/bootstrap/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/font-awesome-4.7.0/css/font-awesome.min.css">        
        <!-- Datetime Picker -->
        <link href="../../style/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css" rel="stylesheet">
        <!-- Select2 -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/plugins/select2/select2.min.css">
        <!-- Theme style -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/AdminLTE.min.css">
        <!-- AdminLTE Skins. Choose a skin from the css/skins
             folder instead of downloading all of them to reduce the load. -->
        <link rel="stylesheet" href="../../style/AdminLTE-2.3.11/dist/css/skins/_all-skins.min.css">
        <link href="../../style/datatables/dataTables.bootstrap.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../../style/bootstrap-notify/bootstrap-notify.css"/>
        <!-- jQuery 2.2.3 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/jQuery/jquery-2.2.3.min.js"></script>
        <!-- Bootstrap 3.3.6 -->
        <script src="../../style/AdminLTE-2.3.11/bootstrap/js/bootstrap.min.js"></script>
        <!-- FastClick -->
        <script src="../../style/AdminLTE-2.3.11/plugins/fastclick/fastclick.js"></script>

        <!-- AdminLTE for demo purposes -->
        <script src="../../style/AdminLTE-2.3.11/dist/js/demo.js"></script>
        <!-- AdminLTE App -->
        <script type="text/javascript" src="../../style/bootstrap-notify/bootstrap-notify.js"></script>
        <script src="../../style/AdminLTE-2.3.11/dist/js/app.min.js"></script>    
        <script src="../../style/dist/js/dimata-app.js" type="text/javascript"></script>
        <!-- Select2 -->
        <script src="../../style/AdminLTE-2.3.11/plugins/select2/select2.full.min.js"></script>
        <!-- Datetime Picker -->
        <script async defer src="https://maps.googleapis.com/maps/api/js?v=3&key=AIzaSyCVHaChwTJ1045ZRf57k4waY28m7M7mXjQ&callback=setContent&libraries=geometry"></script>
        <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
        <script src="../../style/datatables/jquery.dataTables.js" type="text/javascript"></script>
        <script src="../../style/datatables/dataTables.bootstrap.js" type="text/javascript"></script>
        <script src="<%=approot%>/style/lib.js" type="text/javascript"></script>
        <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>

        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            th:after {display: none !important;}
            .modal-header, .modal-footer {padding-bottom: 10px; padding-top: 10px !important}
            .aksi {width: 1% !important}

            .print-area { visibility: hidden; display: none; }
            .print-area.print-preview { visibility: visible; display: block; }
            @media print
            {
                body * { visibility: hidden; }
                .print-area * { visibility: visible; }
                .print-area   { visibility: visible; display: block; position: fixed; top: 0; left: 0; }
            }
        </style>
        <script language="javascript">
            $(document).ready(function () {
                var approot = "<%= approot%>";

                var map = null;
                var myMarker;
                var myLatlng;

                function initializeGMap() {
                    if (navigator.geolocation) {
                        navigator.geolocation.getCurrentPosition(function (position) {
                            var lat = position.coords.latitude;
                            var lng = position.coords.longitude;
                            document.getElementById("latitude").value = lat;
                            document.getElementById("longitude").value = lng;
                            myLatlng = new google.maps.LatLng(lat, lng);

                            var myOptions = {
                                zoom: 12,
                                zoomControl: true,
                                center: myLatlng,
                                mapTypeId: google.maps.MapTypeId.ROADMAP
                            };

                            map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

                            myMarker = new google.maps.Marker({
                                position: myLatlng,
                                draggable: true
                            });

                            google.maps.event.addListener(myMarker, 'dragend', function (marker) {
                                var latLng = marker.latLng;
                                var currentLatitude = latLng.lat();
                                var currentLongitude = latLng.lng();
                                document.getElementById("latitude").value = currentLatitude;
                                document.getElementById("longitude").value = currentLongitude;
                            });

                            myMarker.setMap(map);
                        });
                    }
                }

                var getDataFunction = function (onDone, onSuccess, approot, command, dataSend, servletName, dataAppendTo, notification) {
                    /*
                     * getDataFor	: # FOR PROCCESS FILTER
                     * onDone	: # ON DONE FUNCTION,
                     * onSuccess	: # ON ON SUCCESS FUNCTION,
                     * approot	: # APPLICATION ROOT,
                     * dataSend	: # DATA TO SEND TO THE SERVLET,
                     * servletName  : # SERVLET'S NAME
                     */
                    $(this).getData({
                        onDone: function (data) {
                            onDone(data);
                        },
                        onSuccess: function (data) {
                            onSuccess(data);
                        },
                        approot: approot,
                        dataSend: dataSend,
                        servletName: servletName,
                        dataAppendTo: dataAppendTo,
                        notification: notification
                    });
                };

                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                    var oid = "0";
                    var datafilter = "";
                    var privUpdate = "";
                    var jenisKredit = $("#FRM_TIPE_KREDIT_ID").val();
                    var location = $("#FRM_FIELD_LOCATION_ID").val();
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "oLanguage": {
                            "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div></div>"
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>" 
                                + "&SEND_OID_RESERVATION=" + oid + "&TIPE_KREDIT_ID=" + jenisKredit+"&FRM_FIELD_LOCATION_ID="+location,
                        aoColumnDefs: [
                            {
                                bSortable: false,
                                aTargets: [-1,-2]
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


                function runDataTable(tableElement, tableName, servletName, dataFor) {
                    dataTablesOptions(tableElement, tableName, servletName, dataFor, null);
                }

                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };

                function addNum(elementAppend) {
                    $(".addNum").click(function () {
                        var value = $(this).data("value");
                        if (value == -1) {
                            $(elementAppend).val("");
                        } else {
                            var lastVal = $(elementAppend).val();
                            if (value == 0 && lastVal.length == 0) {
                                $(elementAppend).val("");
                            } else {
                                var newVal = lastVal + "" + value + "";
                                $(elementAppend).val(newVal);
                            }
                        }
                        $(elementAppend).focus();
                    });
                }

                function showNumKeyboard(elementId, keyBoardId) {
                    if (keyBoardId === undefined || keyBoardId === "undefined") {
                        keyBoardId = "#hiddenKeyBoard";
                    }
                    $(elementId).focus(function () {
                        var width = $(window).width();
                        if (width >= 800) {
                            $(keyBoardId).fadeIn("fast");
                        }
                    });
                    $(elementId).focusout(function () {
                        $(keyBoardId).fadeOut("fast");
                    });
                }
                showNumKeyboard("#openadditem #matqty");
                addNum("#openadditem #matqty");
                function parse(number) {
                    if (number === 0) {
                        return number;
                    } else {
                        return Number(number.replace(/[^0-9]+/g, ""));
                    }
                }
                $('#FRM_TIPE_KREDIT_ID').change(function () {
                    var oid = $(this).val();
                    var command = "<%=Command.NONE%>";
                    var dataFor = "getDataJenisKredit";

                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command
                    };
                    //alert(dataSend);
                    onDone = function (data) {
                        $.map(data.RETURN_DATA_JENIS_KREDIT, function (item) {
                            $('#FRM_KREDIT_MIN').html(item.kredit_min);
                            jMoney('#FRM_KREDIT_MIN');
                            $('#FRM_KREDIT_MAX').html(item.kredit_max);
                            jMoney('#FRM_KREDIT_MAX');
                            $('#FRM_BUNGA_MIN').html(item.bunga_min);
                            jMoney('#FRM_BUNGA_MIN');
                            $('#FRM_BUNGA_MAX').html(item.bunga_max);
                            jMoney('#FRM_BUNGA_MAX');
                            //$('#FRM_TANGGAL_MULAI').val(item.berlaku_mulai);
                            //$('#FRM_TANGGAL_SELESAI').val(item.berlaku_sampai);
                            $('#FRM_JANGKA_MIN').html(item.jangka_min);
                            $('#FRM_JANGKA_MAX').html(item.jangka_max);
                            if (item.bunga_min == item.bunga_max) {
                                $("#SUKU_BUNGA").html(item.bunga_max);
                                jMoney('#SUKU_BUNGA');
                            }
                            if (item.jangka_min == item.jangka_max) {
                                $('#FRM_JANGKA_WAKTU').html(item.jangka_max);
                            }
                            if (item.kredit_min == item.kredit_max) {
                                $("#pengajuan").html(item.kredit_max);
                                jMoney('#pengajuan');
                            }
                            $("#FRM_TIPE_BUNGA").val(item.tipe_bunga);
                            $(".tipe_frekuensi_legacy").html(item.tipe_frekuensi);
                        });
                        $('#sumber-dana').html(data.FRM_FIELD_HTML);
                    };

                    onSuccess = function (data) {

                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxKredit", null, true);
                });

                $('#addCustomer').submit(function () {
                    var buttonName = $("#btnSaveCustomer").html();
                    $("#btnSaveCustomer").attr({"disabled": "true"}).html("Tunggu...");
                    var command = "<%=Command.SAVE%>";
                    var dataFor = "saveCustomer";

                    onDone = function (data) {
                        if (data.RETURN_ERROR_CODE == "0") {
                            alert("Customer berhasil disimpan");
                            $.map(data.RETURN_DATA_ANGGOTA, function (item) {
                                $('#nomor_nasabah').val(item.anggota_number);
                                $('#FRM_ANGGOTA_ID').val(item.anggota_id);
                                $('#nama_nasabah').val(item.anggota_name);
                                $('#alamat_nasabah').val(item.anggota_address);
                            });
                        } else {
                            alert(data.RETURN_MESSAGE);
                        }
                    };

                    onSuccess = function (data) {
                        $('#btnSaveCustomer').removeAttr('disabled').html(buttonName);
                        $('#modal-newcustomer').modal('hide');
                    };

                    var data = $(this).serialize();
                    var dataSend = "" + data + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command;
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxAnggota", null, false);
                    return false;
                });

                $('#btn-search').click(function () {
                    var nomor = $('#nomor_nasabah').val();
                    modalSetting("#modal-searchnasabah", "static", false, false);
                    $('#modal-searchnasabah').modal('show');
                    runDataTable("#nasabahTableElement", "tableNasabahTableElement", "AjaxAnggota", "listNasabah");
                    $('#modal-searchnasabah input[type="search"]').val(nomor).keyup();
                });

                $('#btn-search-sales').click(function () {
                    var nomor = $('#sales_person').val();
                    modalSetting("#modal-searchsales", "static", false, false);
                    $('#modal-searchsales').modal('show');
                    runDataTable("#salesTableElement", "tableSalesTableElement", "AjaxUser", "listSalesUser");
//                    runDataTable("#salesTableElement", "tableSalesTableElement", "AjaxSales", "listSales");
                    $('#modal-searchsales input[type="search"]').val(nomor).keyup();
                });

                $('#btn-pilihbarang').click(function () {
                    var jenisKredit = $("#FRM_TIPE_KREDIT_ID").val();
                    if (jenisKredit.length > 0) {
                        modalSetting("#modal-searchitem", "static", false, false);
                        $('#modal-searchitem').modal('show');
                        runDataTable("#materialTableElement", "tableMaterialTableElement", "AjaxMaterial", "listMaterial");
                    } else {
                        alert("Pilih Jenis Kredit!")
                    }
                });

                $('#btn-add-anggota').click(function () {
            <% if (typeOfCredit.equals("1")) { %>
                    initializeGMap();
                    $('#modal-newcustomer').modal('show');
            <% } else {%>
                    window.open("<%=approot%>/masterdata/anggota/anggota_edit.jsp?command=<%=Command.ADD%>");
            <% }%>
                            });

                            $('#btn-add-tabungan').click(function () {
                                modalSetting("#modal-addtabungan", "static", false, false);
                                $('#modal-addtabungan').modal('show');
                                var dataFor = "saveTabungan";

                                $("#form-tabungan #dataFor").val(dataFor);
                                $("#form-tabungan #oid").val($('#FRM_ANGGOTA_ID').val());
                            });

                            $('#btn-cancel').click(function () {
                                $('#btn-cancel').attr({"disabled": "true"}).html("Tunggu...");
                                var command = "<%=Command.NONE%>";
                                $('#command').val(command);
                                window.location = "../../sedana/transaksikredit/list_kredit.jsp?command=" + command;
                            });

                            $('body').on("click", ".no-anggota", function () {
                                var oid = $(this).data('oid');
                                var command = "<%=Command.NONE%>";
                                var dataFor = "getDataAnggota";

                                var dataSend = {
                                    "FRM_FIELD_OID": oid,
                                    "FRM_FIELD_DATA_FOR": dataFor,
                                    "command": command
                                };
                                //alert(dataSend);
                                onDone = function (data) {
                                    //alert(JSON.stringify(data.RETURN_DATA_ANGGOTA));
                                    $.map(data.RETURN_DATA_ANGGOTA, function (item) {
                                        $('#nomor_nasabah').val(item.anggota_number);
                                        $('#FRM_ANGGOTA_ID').val(item.anggota_id);
                                        $('#nama_nasabah').val(item.anggota_name);
                                        $('#alamat_nasabah').val(item.anggota_address);
                                    });
                                    $('#ASSIGN_TABUNGAN_ID').focus();
                                    //getDataTabungan();
                                };

                                onSuccess = function (data) {
                                    $('#modal-searchnasabah').modal('hide');
                                };
                                //alert(JSON.stringify(dataSend));
                                getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxAnggota", null, true);
                                return false;
                            });

                            $('body').on("click", ".no-sales", function () {
                                var oid = $(this).data('oid');
                                var command = "<%=Command.NONE%>";
                                var dataFor = "getDataSalesUser";
//                                var dataFor = "getDataSales";

                                var dataSend = {
                                    "FRM_FIELD_OID": oid,
                                    "FRM_FIELD_DATA_FOR": dataFor,
                                    "command": command
                                };
                                //alert(dataSend);
                                onDone = function (data) {
                                    var locName = "";
                                    $.map(data.RETURN_DATA_SALES_USER, function (item) {
                                        $('#sales_person').val(item.<%=PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME]%>);
                                        $('#<%=FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_APP_USER_SALES_ID]%>').val(item.<%=PstAppUser.fieldNames[PstAppUser.FLD_USER_ID]%>);

                                    });

                                    $('#assign_sales').val(data.RETURN_DATA_LOCATION);
                                    locName = data.RETURN_DATA_LOCATION;


                                    //getDataTabungan();
                                };

                                onSuccess = function (data) {
                                    $('#modal-searchsales').modal('hide');
                                };
                                //alert(JSON.stringify(dataSend));
                                getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxUser", null, true);
                                return false;
                            });

                            $('body').on("click", ".mat-sku", function () {
                                var oid = $(this).data('oid');
                                var matName = $(this).data('matname');
                                var price = $(this).data('matprice');
                                var qty = $(this).data('qty');
                                if (qty < 1){
                                    alert("Tidak dapat memilih item dengan Qty 0!");
                                } else {
                                    $("#material_id").val(oid);
                                    $("#material_name").val(matName);
                                    $("#material_price").val(price);
                                    $("#openadditem").modal("show");
                                    $("#CONTENT_ITEM_TITLE").html(matName);
                                    $("#matqty").val(1);
                                    $('#openadditem #matqty').focus();
                                }
                                
                            });

                            $('#btnsaveitem').click(function () {
                                var oid = $("#material_id").val();
                                var dp = parse($("#dp").val());
                                var price = $("#material_price").val();
                                var jangkaWaktuId = $("#FRM_JANGKA_WAKTU_ID").val();
                                var matQty = $("#matqty").val();
                                var command = "<%=Command.NONE%>";
                                var dataFor = "getMaterial";
                                var total = +price * +matQty;
                                var pengajuan = parse($("#totalPrice").val());
                                var currPengajuan = parse($("#pengajuan").val());
                                $("#totalPrice").val(+total + +pengajuan);
                                var dataSend = {
                                    "FRM_FIELD_OID": oid,
                                    "FRM_FIELD_DATA_FOR": dataFor,
                                    "command": command,
                                    "QTY": matQty,
                                    "DP": dp,
                                    "JANGKA_WAKTU_ID": jangkaWaktuId,
                                    "TOTAL_PRICE": pengajuan,
                                    "CURRENT_PENGAJUAN": currPengajuan
                                };
                                //alert(dataSend);
                                onDone = function (data) {
                                    $("#item-list").css("display", "block");
                                    $('.row_'+oid).html("");
                                    $('#table-item tr:last').after(data.FRM_FIELD_HTML);
                                    jMoney('#total_' + oid);
                                    deleteItem();
                                    getTotalPengajuan();
                                    //getDataTabungan();
                                };

                                onSuccess = function (data) {
                                    $("#openadditem").modal("hide");
                                    $('#modal-searchitem').modal('hide');
                                };
                                //alert(JSON.stringify(dataSend));
                                getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxMaterial", null, true);
                                return false;
//                                var total = +price * +matQty;
//                                $("#item-list").css("display", "block");
//                                $('#table-item tr:last').after("<tr id='" + oid + "'><td><input type='hidden' name='OID_MATERIAL' value='" + oid +
//                                        "'>" + matName + "</td><td><input type='hidden' name='MATERIAL_QTY' value='" + matQty +
//                                        "'>" + matQty + "</td><td><input type='hidden' name='MATERIAL_PRICE' value='" + price +
//                                        "'><span id='total_" + oid + "' class='money'>" + total +
//                                        "</span></td><td><button type='button' class='btn btn-xs btn-danger mat-delete' data-oid='" + oid + "' data-total='" + total + "'><i class='fa fa-trash'></i></button></td></tr>");
//                                jMoney('#total_' + oid);
//                                var pengajuan = parse($("#pengajuan").val());
//                                $("#pengajuan").val(+total + +pengajuan);
//                                jMoney('#pengajuan');
//                                $("#openadditem").modal("hide");
//                                $('#modal-searchitem').modal('hide');
//                                $('.mat-delete').click(function () {
//                                    var oid = $(this).data('oid');
//                                    var total = $(this).data('total');
//                                    $('#table-item tr#' + oid).remove();
//                                    var pengajuan = parse($("#pengajuan").val());
//                                    $("#pengajuan").val(+pengajuan - +total);
//                                    if ($('#table-item tr').length === 1) {
//                                        $("#item-list").css("display", "none");
//                                    }
//                                });
                            });

                            function deleteItem() {
                                $('.mat-delete').click(function () {
                                    var r = confirm("Hapus Data?");
                                    if (r == true) {
                                        var command = "<%=Command.DELETE%>";
                                        var oid = $(this).data('oid');
                                        var oiddetail = $(this).data('oiddetail');
                                        var dataSend = {
                                            "FRM_FIELD_OID": oiddetail,
                                            "FRM_FIELD_DATA_FOR": "deleteBillDetail",
                                            "command": command
                                        };
                                        //alert(dataSend);
                                        onDone = function (data) {
                                            var total = $(this).data('total');
                                            $('#table-item tr#' + oid).remove();
                                            var totalPrice = parse($("#totalPrice").val());
                                            $("#totalPrice").val(+totalPrice - +total);
                                            if ($('#table-item tr').length === 1) {
                                                $("#item-list").css("display", "none");
                                            }
                                            getTotalPengajuan();
                                        };

                                        onSuccess = function (data) {
                                        };
                                        getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxMaterial", null, true);
                                        
                                    }
                                });
                            }

                            $("#FRM_JANGKA_WAKTU_ID").click(function () {
                                getTotalPengajuan();
                            });
                            $(".valDP").keyup(function () {
                                getTotalPengajuan();
                            });
                            deleteItem();
                            function getTotalPengajuan() {
                                var command = "<%=Command.NONE%>";
                                var pengajuan = parse($("#totalPrice").val());
                                var dp = parse($(".valDP").val());
                                var jangkaWaktuId = $("#FRM_JANGKA_WAKTU_ID").val();
                                var jenisKreditId = $("#FRM_TIPE_KREDIT_ID").val();
                                var totalCash = 0;
                                var totalHpp = 0;
                                $('.cashTotal').each(function(){
                                    var value = $(this).val();
                                    totalCash = +totalCash + +value;   // Or this.innerHTML, this.innerText
                                });
                                $('.cost').each(function(){
                                    var value = $(this).val();
                                    totalHpp = +totalHpp + +value;   // Or this.innerHTML, this.innerText
                                });
                                
                                var dataSend = $("#form-kredit").serialize()+ "&FRM_FIELD_DATA_FOR=calculatePrice&TOTAL_PRICE="
                                        +pengajuan+"&DP="+dp+"&JANGKA_WAKTU_ID="+jangkaWaktuId+"&TOTAL_CASH="+ totalCash+"&TOTAL_HPP="+totalHpp+"&JENIS_KREDIT_ID="+jenisKreditId;
                                onDone = function (data) {
                                    $('#pengajuan').val(data.FRM_TOTAL_PRICE);
                                    $('#BUNGA').val(data.FRM_JUMLAH_BUNGA);
                                    $('#TOTAL_POKOK').val(data.FRM_TOTAL_POKOK);
                                    $('#TOTAL_BUNGA').val(data.FRM_TOTAL_BUNGA);
                                    $('#TOTAL_MIN_DP').val(data.FRM_MIN_DP);
                                    jMoney('#pengajuan');
                                    jMoney('#BUNGA');
                                };
                                onSuccess = function (data) {

                                };
                                //alert(JSON.stringify(dataSend));
                                getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxMaterial", null, false);
                            }
                            function setDpKredit(tipe) {
                                var command = "<%=Command.NONE%>";
                                var pengajuan = parse($("#totalPrice").val());
                                //var dp = parse($(".valDP").val());
                                var jangkaWaktuId = $("#FRM_JANGKA_WAKTU_ID").val();
                                var jenisKreditId = $("#FRM_TIPE_KREDIT_ID").val();
                                var totalCash = 0;
                                $('.cashTotal').each(function () {
                                    var value = $(this).val();
                                    totalCash = +totalCash + +value;   // Or this.innerHTML, this.innerText
                                });
                                var totalHpp = 0;
                                $('.cost').each(function(){
                                    var value = $(this).val();
                                    totalHpp = +totalHpp + +value;   // Or this.innerHTML, this.innerText
                                });
                                var dataSend = $("#form-kredit").serialize()+ "&FRM_FIELD_DATA_FOR=calculateDP&TOTAL_PRICE="
                                        +pengajuan+"&JANGKA_WAKTU_ID="+jangkaWaktuId+"&TOTAL_CASH="+ totalCash+"&TIPE_DP="+tipe+"&TOTAL_HPP="+totalHpp+"&JENIS_KREDIT_ID="+jenisKreditId;
                                onDone = function (data) {
                                    let total = data.FRM_TOTAL_PRICE;
                                    $('#FRM_DOWN_PAYMENT').val(total);
                                    $('#dp').val(total);
                                    jMoney('#dp');
                                    getTotalPengajuan();
                                };
                                onSuccess = function (data) {

                                };
                                //alert(JSON.stringify(dataSend));
                                getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxMaterial", null, false);
                            }

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

                            //check required on enter
                            function pressEnter(elementIdEnter, elementIdFocus) {
                                $(elementIdEnter).keypress(function (e) {
                                    if (e.keyCode === 13) {
                                        var atr = $(elementIdEnter).attr('required');
                                        var val = $(elementIdEnter).val();
                                        if (val === "") {
                                            if (atr === "required") {
                                                alert("Data tidak boleh kosong !");
                                                $(elementIdEnter).focus();
                                                return false;
                                            }
                                        }
                                        $(elementIdFocus).focus();
                                        return false;
                                    }
                                });
                            }

                            $('#nomor_nasabah').focus();

                            $('#nomor_nasabah').keypress(function (e) {
                                var nomor = $(this).val();
                                if (e.keyCode === 13) {
                                    if (nomor === "") {
                                        $('#btn-search').trigger('click');
                                        return false;
                                    } else {
                                        $('#ASSIGN_TABUNGAN_ID').focus();
                                    }
                                }
                            });

                            //pressEnter('#FRM_TIPE_KREDIT_ID', '#nomor_nasabah');
                            //pressEnter('#ASSIGN_TABUNGAN_ID', '#ID_JENIS_SIMPANAN');
                            //pressEnter('#ID_JENIS_SIMPANAN', '#pengajuan');
                            //pressEnter('#pengajuan', '#FRM_JANGKA_WAKTU');
                            //pressEnter('#FRM_JANGKA_WAKTU', '#FRM_TIPE_BUNGA');
                            //pressEnter('#FRM_TIPE_BUNGA', '#SUKU_BUNGA');
                            //pressEnter('#SUKU_BUNGA', '#sumber-dana');
                            //pressEnter('#sumber-dana', '#FRM_JATUH_TEMPO');
                            //pressEnter('#FRM_JATUH_TEMPO', '#FRM_TGL_LUNAS');
                            //pressEnter('#FRM_TGL_LUNAS', '#FRM_TGL_REALISASI');
                            //pressEnter('#FRM_TGL_REALISASI', '#FRM_KODE_KOLEKTIBILITAS');
                            //pressEnter('#FRM_KODE_KOLEKTIBILITAS', '#FRM_KETERANGAN');
                            //pressEnter('#FRM_KETERANGAN', '#btn-savepengajuan');

                            function getDataTabungan() {
                                var oid = $('#FRM_ANGGOTA_ID').val();
                                var command = "<%=Command.NONE%>";

                                var dataSend = {
                                    "FRM_FIELD_OID": oid,
                                    "FRM_FIELD_DATA_FOR": "getDataTabungan",
                                    "command": command
                                };
                                onDone = function (data) {
                                    $('#ASSIGN_TABUNGAN_ID').html(data.FRM_FIELD_HTML);
                                    $("#btn-add-tabungan").removeAttr("style");
                                    var error = data.RETURN_ERROR_CODE;
                                    if (error === "1") {
                                        $('#ID_JENIS_SIMPANAN').html("<option value=''>- Tidak ada simpanan bebas -</option>");
                                    }
                                };
                                onSuccess = function (data) {

                                };
                                //alert(JSON.stringify(dataSend));
                                getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxKredit", null, false);
                            }

                            $('#ASSIGN_TABUNGAN_ID').change(function () {
                                var oid = $(this).val();
                                var command = "<%=Command.NONE%>";

                                var dataSend = {
                                    "FRM_FIELD_OID": oid,
                                    "FRM_FIELD_DATA_FOR": "checkTabungan",
                                    "command": command
                                };
                                onDone = function (data) {
                                    $('#ID_JENIS_SIMPANAN').html(data.FRM_FIELD_HTML);
                                };
                                onSuccess = function (data) {

                                };
                                //alert(JSON.stringify(dataSend));
                                getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxKredit", null, false);
                            });

                            $('#form-kredit').submit(function () {
                                var buttonName = $('#btn-savepengajuan').html();
                                $('#btn-savepengajuan').attr({"disabled": "true"}).html("Tunggu...");
                                var oid = "<%=oidPinjaman%>";
                                var command = "<%=Command.SAVE%>";
                                if (<%=exchangeStatus%>) {
                                    var dataFor = "saveKreditExchange";
                                } else {
                                    var dataFor = "saveKredit";
                                }
                                onDone = function (data) {
                                    if (data.RETURN_ERROR_CODE == "0") {
                                        alert("Data kredit berhasil disimpan");
                                        if (<%=exchangeStatus%>) {
                                            window.location = "<%=posAppUrl%>/warehouse/material/production/detail_penjualan.jsp?oid_cbm=" + data.RETURN_DATA_OID_PINJAMAN;
                                        } else {
                                            window.location = "../transaksikredit/jadwal_angsuran.jsp?pinjaman_id=" + data.RETURN_DATA_OID_PINJAMAN;
                                        }
                                    } else {
                                        alert(data.RETURN_MESSAGE);
                                    }
                                };

                                onSuccess = function (data) {
                                    $('#btn-savepengajuan').removeAttr('disabled').html(buttonName);
                                };

                                var data = $(this).serialize();
                                var dataSend = "" + data + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command + "&FRM_FIELD_OID=" + oid;
                                //alert(JSON.stringify(dataSend));
                                getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxKredit", null, false);
                                return false;
                            });

                            function countAngsuran() {
                                var jmlPengajuan = $('#FRM_JUMLAH_PINJAMAN').val();
                                var jangka = $('#FRM_JANGKA_WAKTU').val();
                                //set jumlah angsuran
                                if (jmlPengajuan !== "" && jangka !== "") {
                                    var angsuran = Number(jmlPengajuan) / Number(jangka);

                                    $('#FRM_JUMLAH_ANGSURAN').val(angsuran);
                                    $('#countResult').val(angsuran);
                                    jMoney('#countResult');
                                }
                            }

                            function setLunas() {
                                //tanggal lunas di set otomatis saat di simpan
                                return false;
                                var tglTempo = $('#FRM_JATUH_TEMPO').val();
                                var jangka = $('#FRM_JANGKA_WAKTU').val();
                                //set tanggal lunas
                                if (tglTempo !== "" && jangka !== "") {
                                    var command = "<%=Command.NONE%>";
                                    var dataFor = "setTglLunas";
                                    var dataSend = {
                                        "SEND_TGL_TEMPO": tglTempo,
                                        "SEND_JANGKA_WAKTU": jangka,
                                        "FRM_FIELD_DATA_FOR": dataFor,
                                        "command": command
                                    };
                                    onDone = function (data) {
                                        $.map(data.RETURN_DATA_ARRAY, function (item) {
                                            $('#FRM_TGL_LUNAS').val(item.tgl_tempo);
                                        });
                                    };
                                    onSuccess = function (data) {

                                    };
                                    //alert(JSON.stringify(dataSend));
                                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxKredit", null, false);
                                }
                            }

                            $('body').on('click', '#btn-tanpadp', function () {
                                $('#FRM_DOWN_PAYMENT').val(0);
                                $('#dp').val(0);
                                jMoney('#dp');
                                getTotalPengajuan();
                            });
                            $('body').on('click', '#btn-mindp', function () {
                                setDpKredit(0);
                            });
                            $('body').on('click', '#btn-maxdp', function () {
                                setDpKredit(1);
                            });

                            $('#pengajuan').keyup(function () {
                                countAngsuran();
                            });
                            $('#FRM_JANGKA_WAKTU').keyup(function () {
                                countAngsuran();
                                setLunas();
                            });
                            $('#FRM_JATUH_TEMPO').change(function () {
                                setLunas();
                            });

                            $('#FRM_TGL_REALISASI').change(function () {
                                $("#FRM_JATUH_TEMPO").val($(this).val());
                            });

                            $('#FRM_JANGKA_WAKTU_ID').change(function () {
                                $("#FRM_JANGKA_WAKTU").val($("#FRM_JANGKA_WAKTU_ID option:selected").html());
                            });

                            $('#btn_printPengajuan').click(function () {
                                var oid = "<%=oidPinjaman%>";
                                var type = "SPMK";
                                window.open("<%=approot%>/masterdata/masterdokumen/dokumen_edit.jsp?oid_pinjaman=" + oid + "&type=" + type, '_blank', 'location=yes,height=650,width=900,status=yes');
                                //var buttonHtml = $(this).html();
                                //$(this).attr({"disabled": "true"}).html("Tunggu...");
                                //window.print();
                                //$(this).removeAttr('disabled').html(buttonHtml);
                            });

                            $('.mati').keypress(function (e) {
                                if (e.keyCode === 13) {
                                    return false;
                                }
                            });

                            $('#btnBackDraft').click(function () {
                                if (confirm("Seluruh data transaksi kredit ini akan dihapus. \nYakin akan mengembalikan status menjadi draft ?")) {
                                    var btn = $(this).html();
                                    $(this).html("<i class='fa fa-spinner fa-pulse'></i>");
                                    var command = "<%=Command.SAVE%>";
                                    var oid = "<%=oidPinjaman%>";
                                    var dataSend = {
                                        "FRM_FIELD_OID": oid,
                                        "FRM_FIELD_DATA_FOR": "backStatusKreditDraft",
                                        "command": command,
                                        "SEND_USER_ID": "<%=userOID%>",
                                        "SEND_USER_NAME": "<%=userName%>"
                                    };
                                    onDone = function (data) {
                                        var error = data.RETURN_ERROR_CODE;
                                        if (error === "0") {
                                            alert("Data kredit sudah kembali menjadi draft.");
                                        } else {
                                            alert(data.RETURN_MESSAGE);
                                        }
                                        window.location = "../transaksikredit/transaksi_kredit.jsp?pinjaman_id=" + oid + "&command=<%=Command.EDIT%>";
                                        $('#btnBackDraft').html(btn);
                                    };
                                    onSuccess = function (data) {
                                        $('#btnBackDraft').html(btn);
                                    };
                                    //alert(JSON.stringify(dataSend));
                                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxKredit", null, false);
                                }
                            });

                            $("form#form-tabungan").submit(function () {
                                var currentBtnHtml = $("#btn-simpan-tabungan").html();
                                $("#btn-simpan-tabungan").html("Menyimpan...").attr({"disabled": "true"});
                                var command = "<%=Command.SAVE%>";

                                onDone = function (data) {
                                    getDataTabungan();
                                };

                                if ($(this).find(".has-error").length == 0) {
                                    var onSuccess = function (data) {
                                        $("#btn-simpan-tabungan").removeAttr("disabled").html(currentBtnHtml);
                                        $("#modal-addtabungan").modal("hide");
                                    };

                                    var dataSend = $(this).serialize();
                                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxKredit", null, false);
                                } else {
                                    $("#btn-simpan-tabungan").removeAttr("disabled").html(currentBtnHtml);
                                }

                                return false;
                            });

                            $('#btn-regist-tabungan').click(function () {
                                var assignId = $("#ASSIGN_TABUNGAN_ID").val();
                                var command = "1";
                                var id = $("#FRM_ANGGOTA_ID").val();
                                var noTabungan = $("#ASSIGN_TABUNGAN_ID").find('option:selected').data("no");
                                var namaTabungan = $("#ASSIGN_TABUNGAN_ID").find('option:selected').data("nama");
                                var nama = $("#nama_nasabah").val() + " - " + namaTabungan;
                                var alamat = $("#alamat_nasabah").val();

                                var dt = new Date();
                                var day = dt.getDate();
                                var month = dt.getMonth() + 1;
                                var year = dt.getFullYear();
                                var tanggal = year + "-" + month + "-" + day;
                                window.open(baseUrl("") + "sp_index.jsp?redir='" + baseUrl("") + "Setoran?alamat='" + alamat + "'%26assign_contact_id='" + assignId + "'%26command=1%26id='" + id + "'%26nama='" + nama + "'%26no_tabungan='" + noTabungan + "'%26tanggal='" + tanggal + "''", '_blank');
                            });

                            $('#btnBackCair').click(function () {
                                if (confirm("Kembalikan status kredit menjadi cair ?")) {
                                    var btn = $(this).html();
                                    $(this).html("<i class='fa fa-spinner fa-pulse'></i>");
                                    var command = "<%=Command.SAVE%>";
                                    var oid = "<%=oidPinjaman%>";
                                    var dataSend = {
                                        "FRM_FIELD_OID": oid,
                                        "FRM_FIELD_DATA_FOR": "backStatusKreditCair",
                                        "command": command,
                                        "SEND_USER_ID": "<%=userOID%>",
                                        "SEND_USER_NAME": "<%=userName%>"
                                    };
                                    onDone = function (data) {
                                        var error = data.RETURN_ERROR_CODE;
                                        if (error === "0") {
                                            alert("Status kredit sudah kembali menjadi cair.");
                                        } else {
                                            alert(data.RETURN_MESSAGE);
                                        }
                                        window.location = "../transaksikredit/transaksi_kredit.jsp?pinjaman_id=" + oid + "&command=<%=Command.EDIT%>";
                                        $('#btnBackCair').html(btn);
                                    };
                                    onSuccess = function (data) {
                                        $('#btnBackCair').html(btn);
                                    };
                                    //alert(JSON.stringify(dataSend));
                                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxKredit", null, false);
                                }
                            });
            <%
                                if (simulasiMatId != null) {
            %>
                            if (confirm("You want to continue use simulation item?")) {
                                var oid = "";
                                $(".MATERIAL_SIMULASI_ID").each(function () {
                                    oid += oid.length == 0 ? "" : ",";
                                    oid += $(this).val();
                                });
                                var matQty = "";
                                $(".MATERIAL_SIMULASI_QTY").each(function () {
                                    matQty += matQty.length == 0 ? "" : ",";
                                    matQty += $(this).val();
                                });
                                var price = "";
                                $(".MATERIAL_SIMULASI_PRICE").each(function () {
                                    price += price.length == 0 ? "" : ",";
                                    price += $(this).val();
                                });

                                var dp = parse($("#dp").val());
                                var jangkaWaktuId = $("#FRM_JANGKA_WAKTU_ID").val();
                                var command = "<%=Command.NONE%>";
                                var dataFor = "getMatSimulasi";
                                var total = +price * +matQty;
                                var pengajuan = parse($("#totalPrice").val());
                                $("#totalPrice").val(+total + +pengajuan);
                                var dataSend = {
                                    "FRM_FIELD_OID": oid,
                                    "FRM_FIELD_DATA_FOR": dataFor,
                                    "command": command,
                                    "QTY": matQty,
                                    "DP": dp,
                                    "JANGKA_WAKTU_ID": jangkaWaktuId,
                                    "TOTAL_PRICE": pengajuan,
                                    "PRICE": price
                                };
                                //alert(dataSend);
                                onDone = function (data) {
                                    $("#item-list").css("display", "block");
                                    $('#table-item tr:last').after(data.FRM_FIELD_HTML);
                                    $('#pengajuan').val(data.FRM_TOTAL_PRICE);
                                    jMoney('#total_' + oid);
                                    jMoney('#pengajuan');
                                    deleteItem()
                                };

                                onSuccess = function (data) {
                                };
                                getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxMaterial", null, true);
                                return false;
                            }

            <% }%>

                        });
        </script>

    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
                Pengajuan Kredit
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Transaksi</li>
                <li class="active">Kredit</li>
            </ol>
        </section>

        <%if (pinjaman.getOID() != 0) {%>
        <section class="content-header">
            <a class="btn btn-danger" href="../transaksikredit/transaksi_kredit.jsp?pinjaman_id=<%=pinjaman.getOID()%>&command=<%=Command.EDIT%>">Data Pengajuan</a>
            <a style="background-color: white" class="btn btn-default" href="../transaksikredit/jadwal_angsuran.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Jadwal Angsuran</a>
            <a style="background-color: white" class="btn btn-default" href="../penjamin/penjamin.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Keluarga & Penjamin</a>
            <% if (typeOfCredit.equals("0")) {%><a style="background-color: white" class="btn btn-default" href="../agunan/agunan.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Agunan / Jaminan</a><% } %>
            <% if (pinjaman.getStatusPinjaman() >= Pinjaman.STATUS_DOC_APPROVED) {%>
            <a style="background-color: white" class="btn btn-default" href="../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Detail</a>
            <% } %>
            <a style="font-size: 14px" class="btn btn-box-tool" href="../transaksikredit/list_kredit.jsp">Kembali ke daftar kredit</a>
            <% if (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR && tidakAdaTransaksiPembayaran) {%>
            <a style="font-size: 14px" title="Kembalikan status kredit menjadi Draft" id="btnBackDraft" class="btn btn-box-tool pull-right"><i class="fa fa-undo"></i></a>
                <% } %>
        </section>
        <%}%>

        <% if (errorMessage.length() > 0) {%>
        <div class="content-header" style="color: red"><i class="fa fa-warning"></i> &nbsp; Terjadi kesalahan ! <%= errorMessage%></div>
        <%}%>

        <section class="content">
            <div class="box box-success">

                <div class="box-header with-border" style="border-color: lightgrey">
                    <% if (pinjaman.getOID() == 0) {%>
                    <h3 class="box-title">Form Input Pengajuan</h3>
                    <% } else {%>
                    <h3 class="box-title">Nomor Kredit &nbsp;:&nbsp; <a><%=pinjaman.getNoKredit()%></a></h3>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <h3 class="box-title">Nama <%=namaNasabah%> &nbsp;:&nbsp; <a href="../../masterdata/anggota/anggota_edit.jsp?anggota_oid=<%= anggota.getOID()%>"><%=anggota.getName()%></a> &nbsp;(<%=anggota.getNoAnggota()%>)</h3>
                    <h3 class="box-title pull-right">Status &nbsp;:&nbsp; <a><%=Pinjaman.getStatusDocTitle(pinjaman.getStatusPinjaman())%></a></h3>
                    <% }%>
                </div>

                <p></p>

                <form id="form-kredit" class="form-horizontal">
                    <div class="box-body">

                        <input type="hidden" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_PINJAMAN_ID]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_PINJAMAN_ID]%>" value="<%=pinjaman.getOID()%>">
                        <input type="hidden" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_CASH_BILL_MAIN_ID]%>" value="<%=billId%>">
                        <input type="hidden" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_CATEGORY_PINJAMAN]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_CATEGORY_PINJAMAN]%>" value="<%=tipePengajuan %>">
                        <input type="hidden" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_ACCOUNT_OFFICER_ID]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_ACCOUNT_OFFICER_ID]%>" value="<%= pinjaman.getAccountOfficerId() %>">

                        <div class="col-sm-12">

                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Status Dokumen</label>
                                    <div class="col-sm-8">
                                        <select class="form-control input-sm" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_STATUS_PINJAMAN]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_STATUS_PINJAMAN]%>">
                                            <% if (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_DRAFT) {%>
                                            <option selected="" value="<%=Pinjaman.STATUS_DOC_DRAFT%>"><%=Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_DRAFT)%></option>
                                            <option value="<%=Pinjaman.STATUS_DOC_BATAL%>"><%=Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_BATAL)%></option>
                                            <%} else if (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_BATAL) {%>
                                            <option selected="" value="<%=Pinjaman.STATUS_DOC_BATAL%>"><%=Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_BATAL)%></option>
                                            <option value="<%=Pinjaman.STATUS_DOC_DRAFT%>"><%=Pinjaman.getStatusDocTitle(Pinjaman.STATUS_DOC_DRAFT)%></option>
                                            <%} else {%>
                                            <option value="<%= pinjaman.getStatusPinjaman()%>"><%=Pinjaman.getStatusDocTitle(pinjaman.getStatusPinjaman())%></option>
                                            <%}%>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-sm-4">Tanggal Pengajuan</label>
                                    <div class="col-sm-8">
                                        <input type="text" required="" autocomplete="off" class="form-control date-picker input-sm mati" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TGL_PENGAJUAN]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TGL_PENGAJUAN]%>" value="<%=tglPengajuan%>">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-sm-4">Kode <%=namaNasabah%> <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">
                                        <div class="input-group">
                                            <input type="hidden" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_ANGGOTA_ID]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_ANGGOTA_ID]%>" value="<%=anggota.getOID()%>">
                                            <input type="text" required="" class="form-control input-sm" name="" id="nomor_nasabah" value="<%=anggota.getNoAnggota()%>">                                            
                                            <span class="input-group-addon btn btn-primary" id="btn-search">
                                                <i class="fa fa-search"></i>
                                            </span>
                                            <span class="input-group-addon btn btn-primary" id="btn-add-anggota">
                                                <i class="fa fa-plus"></i>
                                            </span>
                                        </div>                                        
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-sm-4">Nama</label>
                                    <div class="col-sm-8">          
                                        <input type="text" readonly="" class="form-control input-sm mati" name="" id="nama_nasabah" value="<%=anggota.getName()%>">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-sm-4">Alamat</label>
                                    <div class="col-sm-8">          
                                        <input type="text" readonly="" class="form-control input-sm mati" name="" id="alamat_nasabah" value="<%=anggota.getAddressPermanent()%>">
                                    </div>
                                </div>

                                <% if (typeOfCredit.equals("1")) {%>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Sales <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">
                                        <div class="input-group">
                                            <input type="hidden" name="<%=FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_APP_USER_SALES_ID]%>" id="<%=FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_APP_USER_SALES_ID]%>" value="<%=sales.getOID()%>">
                                            <input type="text" required="" class="form-control input-sm" name="<%=FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_SALES_CODE]%>" id="sales_person" value="<%= (sales.getOID() > 0 ? sales.getFullName() : "")%>">                                            
                                            <span class="input-group-addon btn btn-primary" id="btn-search-sales">
                                                <i class="fa fa-search"></i>
                                            </span>
                                            <span class="input-group-addon btn btn-primary" id="btn-add-sales">
                                                <i class="fa fa-plus"></i>
                                            </span>
                                        </div>                                        
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-sm-4">Lokasi Sales</label>
                                    <div class="col-sm-8">  
                                        <%
                                            Location locSales = new Location();
                                            long loca = 0;
                                            try {
                                                if(sales.getAssignLocationId() == 0){
                                                    loca = billMain.getLocationId();
                                                }else{
                                                    loca = sales.getAssignLocationId();
                                                }
                                                locSales = PstLocation.fetchExc(loca);
                                            } catch (Exception exc) {
                                            }
                                        %>
                                        <input type="text" readonly="" class="form-control input-sm mati" name="" id="assign_sales" value="<%=locSales.getName()%>">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-sm-4">Lokasi Transaksi</label>
                                    <div class="col-sm-8">
                                        <select required="" class="form-control input-sm" name="<%=FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_LOCATION_ID]%>" id="<%=FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_LOCATION_ID]%>">
                                            <option value="">- Pilih Lokasi Transaksi -</option>
                                            <%
                                                Vector listLocation = PstLocation.list(0, 0, "", "");
                                                if (listLocation.isEmpty()) {
                                                    out.print("<option value=''>Tidak ada lokasi transaksi</option>");
                                                }
                                                long locationId = 0;
                                                if (billMain.getLocationId() != 0) {
                                                    locationId = billMain.getLocationId();
                                                }
                                                for (int i = 0; i < listLocation.size(); i++) {
                                                    Location loc = (Location) listLocation.get(i);
                                                    out.print("<option " + (locationId == loc.getOID() ? "selected" : "") + " value='" + loc.getOID() + "'>" + loc.getName() + "</option>");

                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <% }%>

                                <div class="form-group">
                                    <label class="control-label col-sm-4" for="pwd">Nomor Kredit <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">
                                        <input type="text" autocomplete="off" placeholder="Otomatis jika kosong" class="form-control input-sm mati" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_NO_KREDIT]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_NO_KREDIT]%>" value="<%=pinjaman.getNoKredit()%>">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-sm-4">Jenis Kredit <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">
                                        <select required="" class="form-control input-sm" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TIPE_KREDIT_ID]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TIPE_KREDIT_ID]%>">
                                            <option value="">- Pilih Jenis Kredit -</option>
                                            <%
                                                Vector listTypeKredit = PstTypeKredit.list(0, 0, "", "");
                                                if (listTypeKredit.isEmpty()) {
                                                    out.print("<option value=''>Tidak ada jenis kredit</option>");
                                                }
                                                for (int i = 0; i < listTypeKredit.size(); i++) {
                                                    TypeKredit tk = (TypeKredit) listTypeKredit.get(i);
                                                    out.print("<option " + (pinjaman.getTipeKreditId() == tk.getOID() ? "selected" : "") + " value='" + tk.getOID() + "'>" + tk.getNameKredit() + " [" + I_Sedana.TIPE_KREDIT.get(tk.getTipeFrekuensiPokokLegacy())[SESS_LANGUAGE] + "]</option>");

                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <% if (typeOfCredit.equals("0")) {%>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Sumber Dana <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">          
                                        <select required="" id="sumber-dana" class="form-control input-sm" name="sumber-dana">
                                            <%
                                                if (pinjaman.getTipeKreditId() != 0) {
                                                    Vector listSumberDana = SessReportKredit.listJoinJenisKreditBySumberDana("tk." + PstAssignSumberDana.fieldNames[PstAssignSumberDana.FLD_TYPE_KREDIT_ID] + " = '" + pinjaman.getTipeKreditId() + "'", "");
                                                    for (int i = 0; i < listSumberDana.size(); i++) {
                                                        AssignSumberDana asd = (AssignSumberDana) listSumberDana.get(i);
                                                        SumberDana sd = new SumberDana();
                                                        try {
                                                            sd = PstSumberDana.fetchExc(asd.getSumberDanaId());
                                                            out.print("<option " + (sumberDana.getSumberDanaId() == asd.getSumberDanaId() ? "selected" : "") + " value='" + sd.getOID() + "'>" + sd.getJudulSumberDana() + "</option>");
                                                        } catch (Exception e) {
                                                            System.out.println(e.getMessage());
                                                        }
                                                    }
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-sm-4">Tipe Bunga</label>
                                    <div class="col-sm-8">          
                                        <select class="form-control input-sm" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TIPE_BUNGA]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TIPE_BUNGA]%>">
                                            <% for (int i = 0; i < PstSumberDana.tipeBunga.length; i++) {%>
                                            <option <%=(pinjaman.getTipeBunga() == i) ? "selected" : ""%> value="<%=i%>"><%=PstSumberDana.tipeBunga[i]%></option>
                                            <% }%>                                           
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Tipe Jadwal</label>
                                    <div class="col-sm-8">          
                                        <select class="form-control input-sm" id="tipe-jadwal" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TIPE_JADWAL]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TIPE_JADWAL]%>">
                                            <% for (int i = 0; i < Pinjaman.TIPE_JADWAL_TITLE.length; i++) {%>
                                            <option <%=(pinjaman.getTipeJadwal() == i) ? "selected" : ""%> value="<%=i%>"><%=Pinjaman.TIPE_JADWAL_TITLE[i]%></option>
                                            <% }%>                                           
                                        </select>
                                    </div>
                                </div>
                                <% } %>
                            </div>

                            <div class="col-sm-6">
                                <%
                                    int jangkaWaktu = 0;
                                %>
                                <% if (typeOfCredit.equals("1")) {%>
                                <div id="jangka-waktu" class="form-group">
                                    <label class="control-label col-sm-4">Jangka Waktu <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">    
                                        <select required="" class="form-control input-sm" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_JANGKA_WAKTU_ID]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_JANGKA_WAKTU_ID]%>">
                                            <%
                                                Vector listJangkaWaktu = PstJangkaWaktu.list(0, 0, "STATUS=0", PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU]);
                                                if (listJangkaWaktu.isEmpty()) {
                                                    out.print("<option value=''>Tidak ada jangka waktu</option>");
                                                }
                                                for (int i = 0; i < listJangkaWaktu.size(); i++) {
                                                    JangkaWaktu jw = (JangkaWaktu) listJangkaWaktu.get(i);
                                                    if (i == 0) {
                                                        jangkaWaktu = jw.getJangkaWaktu();
                                                    }
                                                    out.print("<option " + (pinjaman.getJangkaWaktuId() == jw.getOID() ? "selected" : "") + " value='" + jw.getOID() + "'>" + jw.getJangkaWaktu() + "</option>");
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Deposit</label>
                                    <div class="col-sm-8"> 
                                        <div class="input-group">
                                            <span class="input-group-addon">Rp</span>
                                            <input type="text" autocomplete="off" required="" class="form-control input-sm money valDP" data-cast-class="valDP" id="dp" value="<%=(deposit == 0 ? simulasiDeposit : deposit)%>">
                                            <input type="hidden" class="valDP" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_DOWN_PAYMENT]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_DOWN_PAYMENT]%>" value="<%=pinjaman.getDownPayment()%>">
                                            <input type="hidden" class="valDP" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_DOWN_PAYMENT]%>" value="<%=simulasiDeposit%>">
                                        </div>
                                        <button type="button" id="btn-tanpadp" class="btn btn-success">Tanpa DP</button>
                                        <button type="button" id="btn-mindp" class="btn btn-success">DP</button>
                                        <!--
                                        <button type="button" id="btn-maxdp" class="btn btn-primary">Max. DP</button>
                                        -->
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Pilih Barang <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">    
                                        <button type="button" id="btn-pilihbarang" class="btn btn-sm btn-success"><i class="fa fa-search"></i> &nbsp; Pilih</button>
                                    </div>
                                </div>
                                <%
                                    String styles = "style='display: none;'";
                                    Vector listDetail = PstBillDetail.list(0, 0, PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + billMain.getOID(), "");
//                                    ArrayList<Billdetail> listDetail = PstBillDetail.listFromApi(0, 0, PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + billMain.getOID(), ""); 
                                    if (listDetail.size() > 0) {
                                        styles = "style='display: block;'";
                                    }
                                %> 
                                <div id="item-list" <%=styles%>>
                                    <label class="control-label col-sm-4">&nbsp;</label>
                                    <input type="hidden" id="totalPrice" value="0">
                                    <div class="col-sm-8">
                                        <table class="table table-bordered" id="table-item">
                                            <tr>
                                                <th>Barang</th>
                                                <th>Qty</th>
                                                <th>Total (Rp.)</th>
                                                <th>Aksi</th>
                                            </tr>
                                            <%
                                                for (int i = 0; i < listDetail.size(); i++) {
                                                    Billdetail billdetail = (Billdetail) listDetail.get(i);
                                            %>
                                            <tr class="row_<%= billdetail.getMaterialId() %>" id="<%=billdetail.getMaterialId()%>">
                                                <td>
                                                    <input type="hidden" name="OID_MATERIAL" value="<%=billdetail.getMaterialId()%>"><%=billdetail.getItemName()%>
                                                </td>
                                                <td>
                                                    <input type="hidden" name="MATERIAL_QTY" value="<%=(int) billdetail.getQty()%>"><%=(int) billdetail.getQty()%>
                                                </td>
                                                <td>
                                                    <input type="hidden" name="MATERIAL_PRICE_TOTAL" value="<%=billdetail.getTotalPrice()%>">
                                                    <input type="hidden" class="cost" name="COST" value="<%= Double.toString(billdetail.getCost()) %>">
                                                    <input type='hidden' class='cashTotal' value="<%= Double.toString((billdetail.getQty() * billdetail.getItemPrice())) %>">
                                                    <input type="hidden" name="MATERIAL_PRICE" value="<%=billdetail.getItemPrice()%>">
                                                    <span id="total_<%=billdetail.getMaterialId()%>" class="money"><%=(billdetail.getItemPrice() * billdetail.getQty())%></span>
                                                </td>
                                                <td>
                                                    <button type="button" class="btn btn-xs btn-danger mat-delete" data-oid="<%=billdetail.getMaterialId()%>" data-oiddetail="<%=billdetail.getOID()%>" data-total="<%=billdetail.getItemPrice()%>">
                                                        <i class="fa fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </table>
                                    </div>
                                </div>
                                <% }%>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Jumlah Pengajuan <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">
                                        <div class="input-group">
                                            <span class="input-group-addon">Rp</span>
                                            <input type="text" autocomplete="off" required="" class="form-control input-sm money" data-cast-class="valPengajuan" id="pengajuan" value="<%=pinjaman.getJumlahPinjaman()%>">
                                            <input type="hidden" class="valPengajuan" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_JUMLAH_PINJAMAN]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_JUMLAH_PINJAMAN]%>" value="<%=pinjaman.getJumlahPinjaman()%>">
                                            <input type="hidden" name="TOTAL_POKOK" id="TOTAL_POKOK" value="<%= totalPokok %>">
                                            <input type="hidden" name="TOTAL_BUNGA" id="TOTAL_BUNGA" value="<%= totalBunga %>">
                                            <input type="hidden" id="TOTAL_MIN_DP" value="<%= totalDp %>">
                                        </div>
                                        <% if (typeOfCredit.equals("0")) {%>
                                        <small>
                                            <span>Min : Rp. </span><a id="FRM_KREDIT_MIN" class="money"><%= kredit.getMinKredit()%></a>
                                            <a>&nbsp;&nbsp;-&nbsp;&nbsp;</a>
                                            <span>Max : Rp. </span><a id="FRM_KREDIT_MAX" class="money"><%= kredit.getMaxKredit()%></a>
                                        </small>
                                        <% }%>
                                    </div>
                                </div>


                                <div id="jangka-waktu" class="form-group" <%=style%>>
                                    <label class="control-label col-sm-4">Jangka Waktu <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">    
                                        <div class="input-group">
                                            <input type="text" autocomplete="off" required="" class="form-control input-sm" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_JANGKA_WAKTU]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_JANGKA_WAKTU]%>" min="" value="<%=(pinjaman.getJangkaWaktu() > 0 ? pinjaman.getJangkaWaktu() : jangkaWaktu)%>">
                                            <span class="input-group-addon tipe_frekuensi_legacy"><%= tipeFrekuensi%></span>
                                        </div>
                                        <small>
                                            <span>Min : </span><a id="FRM_JANGKA_MIN"><%= Formater.formatNumber(kredit.getJangkaWaktuMin(), "#")%></a>
                                            <a>&nbsp;&nbsp;-&nbsp;&nbsp;</a>
                                            <span>Max : </span><a id="FRM_JANGKA_MAX"><%= Formater.formatNumber(kredit.getJangkaWaktuMax(), "#")%></a>
                                        </small>
                                    </div>
                                </div>

                                <% if (typeOfCredit.equals("0")) {%>
                                <div class="form-group">
                                    <label class="control-label col-sm-4"><i class='fa fa-question-circle' data-toggle='tooltip' data-placement='right' title='<%=FrmPinjaman.fieldQuestion[FrmPinjaman.FRM_SUKU_BUNGA]%>'></i> Suku Bunga <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">          
                                        <div class="input-group">
                                            <input type="text" autocomplete="off" required="" data-cast-class="valSukuBunga" class="form-control input-sm money" name="" id="SUKU_BUNGA" value="<%=pinjaman.getSukuBunga()%>">
                                            <input type="hidden" class="valSukuBunga" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_SUKU_BUNGA]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_SUKU_BUNGA]%>" value="<%=pinjaman.getSukuBunga()%>">
                                            <span class="input-group-addon">% / Tahun</span>
                                        </div>
                                        <small>
                                            <span>Min : </span><a id="FRM_BUNGA_MIN" class="money"><%= kredit.getBungaMin()%></a> %
                                            <a>&nbsp;&nbsp;-&nbsp;&nbsp;</a>
                                            <span>Max : </span><a id="FRM_BUNGA_MAX" class="money"><%= kredit.getBungaMax()%></a> %
                                        </small>
                                    </div>               
                                </div>
                                <% } else {%>
                                <div class="form-group" style="display: none;">
                                    <label class="control-label col-sm-4"> Bunga <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">          
                                        <div class="input-group">
                                            <span class="input-group-addon">Rp</span>
                                            <input type="text" autocomplete="off" required="" data-cast-class="valBunga" class="form-control input-sm money" name="" id="BUNGA" value="<%=pinjaman.getJumlahBunga()%>">
                                            <input type="hidden" class="valBunga" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_JUMLAH_BUNGA]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_JUMLAH_BUNGA]%>" value="<%=pinjaman.getJumlahBunga()%>">
                                        </div>
                                    </div> 
                                </div>
                                <% }%>
                            </div>

                            <div class="col-sm-6">

                                <div class="form-group">
                                    <label class="control-label col-sm-4">Tanggal Realisasi <i style='color:red'> (m*</i></label>
                                    <div class="col-sm-8">
                                        <input type="text" required="" autocomplete="off" class="form-control input-sm date-picker" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TGL_REALISASI]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TGL_REALISASI]%>" value="<%=tglRealisasi%>">
                                    </div>
                                </div>
                                <div class="form-group"  <%=style%>>
                                    <label class="control-label col-sm-4">Jatuh Tempo<i style='color:red'> (m*</i></label>
                                    <div class="col-sm-8">
                                        <input type="text" required="" autocomplete="off" class="form-control input-sm date-picker" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_JATUH_TEMPO]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_JATUH_TEMPO]%>" value="<%=tglJatuhTempo%>">
                                    </div>
                                </div>

                                <div id="tanggal-lunas" class="form-group">
                                    <label class="control-label col-sm-4">Tanggal Lunas</label>
                                    <div class="col-sm-8">
                                        <input type="text" readonly="" required="" autocomplete="off" class="form-control input-sm" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TGL_LUNAS]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TGL_LUNAS]%>" value="<%=tglLunas%>">
                                    </div>
                                </div>

                                <div class="form-group">                                    
                                    <label class="control-label col-sm-4">Kolektibilitas <i style='color:red'> (m*</i></label>
                                    <div class="col-sm-8">          
                                        <select required="" class="form-control input-sm" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_KODE_KOLEKTIBILITAS]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_KODE_KOLEKTIBILITAS]%>">
                                            <%
                                                Vector listKolektibilitas = PstKolektibilitasPembayaran.list(0, 0, "", "");
                                                if (listKolektibilitas.isEmpty()) {
                                                    out.print("<option value=''>Tidak ada kolektibilitas</option>");
                                                }
                                                for (int i = 0; i < listKolektibilitas.size(); i++) {
                                                    KolektibilitasPembayaran kp = (KolektibilitasPembayaran) listKolektibilitas.get(i);
                                                    out.print("<option " + (pinjaman.getKodeKolektibilitas() == kp.getOID() ? "selected" : "") + " value='" + kp.getOID() + "'>" + kp.getJudulKolektibilitas() + "</option>");
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <% if (typeOfCredit.equals("0")) {%>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Jenis Transaksi <i style='color:red'> (m*</i></label>
                                    <div class="col-sm-8">
                                        <select class="form-control input-sm" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_JENIS_TRANSAKSI_ID]%>" >
                                            <%
                                                Vector<JenisTransaksi> listJenisTransaksi = PstJenisTransaksi.list(0, 0, ""
                                                        + "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_POS_PIUTANG_POKOK + "'"
                                                        + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI] + " LIKE '%Pencairan Kredit%'"
                                                        + "", "");
                                                for (int i = 0; i < listJenisTransaksi.size(); i++) {
                                                    out.print("<option value='" + listJenisTransaksi.get(i).getOID() + "'>" + listJenisTransaksi.get(i).getJenisTransaksi() + "</option>");
                                                }
                                            %>                                            
                                        </select>
                                    </div>                                    
                                </div>
                                <% }%>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Keterangan</label>
                                    <div class="col-sm-8">
                                        <textarea class="form-control" style="width: 100%;resize: none" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_KETERANGAN]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_KETERANGAN]%>"><%=pinjaman.getKeterangan()%></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-12">
                            <b>Keterangan :</b>
                            <table style="font-size: 14px">
                                <tr>
                                    <td> &nbsp; <i class='fa fa-question-circle'></i></td>
                                    <td> &nbsp; : &nbsp; </td>
                                    <td> &nbsp; Jika mouse di arahkan ke simbol ini akan menampilkan keterangan nilai inputan.</td>
                                </tr>
                                <tr>
                                    <td> &nbsp; <i style='color:red'>(m*</i></td>
                                    <td> &nbsp; : &nbsp; </td>
                                    <td> &nbsp; Jika terdapat simbol ini berarti form harus diisi.</td>
                                </tr>
                            </table>
                        </div>

                    </div>
                    <div class="box-footer" style="border-color: lightgray">
                        <% if (pinjaman.getStatusPinjaman() >= Pinjaman.STATUS_DOC_LUNAS && (user.getGroupUser() == AppUser.USER_GROUP_ADMIN || user.getGroupUser() == AppUser.USER_GROUP_HO_STAFF)) {%>
                        <a style="font-size: 14px; color: lightgray; cursor: default" title="" id="btnBackCair" class="btn btn-box-tool"><i class="fa fa-reply"></i></a>
                            <% } %>
                        <div class="pull-right">
                            <div class="col-sm-12">
                                <div class="col-sm-12">
                                    <%if (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_DRAFT || pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_BATAL) {%>
                                    <button type="submit" id="btn-savepengajuan" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                                    <%}%>
                                    <button type="button" id="btn-cancel" class="btn btn-sm btn-default"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                                    <%if (pinjaman.getOID() != 0) {%>
                                    <button type="button" id="btn_printPengajuan" class="btn btn-sm btn-primary"><i class="fa fa-print"></i> &nbsp; Dokumen Permohonan</button>
                                    <%}%>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </section>

        <!--------------------------------------------------------------------->
        <%
            Vector<PinjamanSumberDana> psd = PstPinjamanSumberDana.list(0, 0, "" + PstPinjamanSumberDana.fieldNames[PstPinjamanSumberDana.FLD_PINJAMAN_ID] + " = '" + pinjaman.getOID() + "'", "");
            String sumber = "";
            long sumberDanaId = 0;
            if (!psd.isEmpty()) {
                sumberDanaId = psd.get(0).getSumberDanaId();
            }
            JenisKredit tk = new TypeKredit();
            AssignContactTabungan act = new AssignContactTabungan();
            JenisSimpanan js = new JenisSimpanan();
            SumberDana sd = new SumberDana();
            KolektibilitasPembayaran kp = new KolektibilitasPembayaran();
            try {
                tk = PstTypeKredit.fetchExc(pinjaman.getTipeKreditId());
                act = PstAssignContactTabungan.fetchExc(pinjaman.getAssignTabunganId());
                js = PstJenisSimpanan.fetchExc(pinjaman.getIdJenisSimpanan());
                sd = PstSumberDana.fetchExc(sumberDanaId);
                kp = PstKolektibilitasPembayaran.fetchExc(pinjaman.getKodeKolektibilitas());
            } catch (Exception e) {

            }

        %>
        <div class="print-area">
            <div style="size: A5" class="container">
                <div style="width: 50%; float: left;">
                    <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
                    <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                    <span style="width: 100%; display: inline-block;"><%=compPhone%></span>                    
                </div>
                <div style="width: 50%; float: right; text-align: right">                    
                    <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">DOKUMEN PENGAJUAN KREDIT</span>
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal : <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
                    <span style="width: 100%; display: inline-block; font-size: 12px;">Admin : <%=userFullName%></span>                    
                </div>
                <div class="clearfix"></div>
                <hr class="" style="border-color: gray">
                <div>
                    <span style="width: 150px; float: left;">Status Pengajuan</span>
                    <span style="width: calc(100% - 150px); float: right;">:&nbsp;&nbsp; <%=Pinjaman.getStatusDocTitle(pinjaman.getStatusPinjaman())%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Tanggal Pengajuan</span>
                    <span style="width: calc(100% - 150px); float: right;">:&nbsp;&nbsp; <%=pinjaman.getTglPengajuan()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Nomor Kredit</span>
                    <span style="width: calc(100% - 150px); float: right;">:&nbsp;&nbsp; <%=pinjaman.getNoKredit()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Jenis Kredit</span>
                    <span style="width: calc(100% - 150px); float: right;">:&nbsp;&nbsp; <%=tk.getNameKredit()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Nomor <%=namaNasabah%></span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=anggota.getNoAnggota()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Nama <%=namaNasabah%></span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=anggota.getName()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Alamat <%=namaNasabah%></span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=anggota.getAddressPermanent()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Nomor Tabungan</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=act.getNoTabungan()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Jenis Simpanan</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=js.getNamaSimpanan()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Jumlah Pengajuan</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; Rp <a style="color: black" class="money"><%=pinjaman.getJumlahPinjaman()%></a></span>
                </div>                
                <div>
                    <span style="width: 150px; float: left;">Jangka Waktu</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=pinjaman.getJangkaWaktu()%> Bulan</span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Tipe Bunga</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <a style="color: black"><%=Pinjaman.TIPE_BUNGA_TITLE[pinjaman.getTipeBunga()]%></a></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Suku Bunga</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <a style="color: black" class="money"><%=pinjaman.getSukuBunga()%></a> % / Bulan</span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Sumber Dana</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=sd.getJudulSumberDana()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Tanggal Jatuh Tempo Pembayaran</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=pinjaman.getJatuhTempo()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Tanggal Lunas</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=pinjaman.getTglLunas()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Tanggal Realisasi</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=pinjaman.getTglRealisasi()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Kolektibilitas</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=kp.getJudulKolektibilitas()%></span>
                </div>
                <div>
                    <span style="width: 150px; float: left;">Keterangan</span>
                    <span style="width: calc(100% - 150px); float: right;" >:&nbsp;&nbsp; <%=pinjaman.getKeterangan()%></span>
                </div>

                <div class="clearfix"></div>
                <br>
                <div style="width: 100%;padding-top: 40px;">
                    <div style="width: 25%;float: left;text-align: center;">
                        <span>Petugas</span>
                        <br><br><br><br>
                        <span>(&nbsp; . . . . . . . . . . . . . . . . . . . . &nbsp;)</span>
                    </div>
                    <div style="width: 25%;float: right;text-align: center;">
                        <span><%=namaNasabah%></span>
                        <br><br><br><br>
                        <span>(&nbsp; . . . . . . . . . . . . . . . . . . . . &nbsp;)</span>
                    </div>
                </div>
            </div>
        </div>

        <!--------------------------------------------------------------------->

        <div id="modal-searchnasabah" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">                
                <!-- Modal content-->
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Cari <%=namaNasabah%></h4>
                    </div>

                    <form >
                        <input type="hidden" name="FRM_FIELD_DATA_HISTORY" id="datafor">
                        <input type="hidden" name="command" value="<%= Command.SAVE%>">
                        <input type="hidden" name="FRM_FIELD_OID" id="oid">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12">

                                    <div id="nasabahTableElement">
                                        <table class="table table-striped table-bordered" style="font-size: 14px">
                                            <thead>
                                                <tr>
                                                    <th class="aksi">No.</th>
                                                    <th>Kode</th>
                                                    <th>Nama</th>
                                                    <th>Telepon</th>
                                                    <th>Handphone</th>
                                                    <th>Email</th>
                                                    <th>Alamat</th>
                                                    <th class="aksi">Aksi</th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </form>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                    </div>

                </div>

            </div>
        </div>

        <div id="modal-newcustomer" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">                
                <!-- Modal content-->
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Tambah <%=namaNasabah%></h4>
                    </div>

                    <form id="addCustomer">
                        <input type="hidden" name="command" value="<%= Command.SAVE%>">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <input type="hidden" class="form-control" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_ANGGOTA]%>" value="Auto-Number">
                                    <input type="hidden" class="form-control" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_BIRTH_PLACE]%>" value="-">
                                    <input type="hidden" class="form-control" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NO_NPWP]%>" value="-">
                                    <input type="hidden" name="FRM_FIELD_CLASS_TYPE" value="<%=PstContactClass.CONTACT_TYPE_MEMBER%>">
                                    <div class="form-group">
                                        <label>Nama</label>
                                        <input type="text" class="form-control" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_NAME_ANGGOTA]%>" placeholder="Input nama">
                                    </div>
                                    <div class="form-group">
                                        <label>No Hp</label>
                                        <input type="text" class="form-control" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_HANDPHONE]%>" placeholder="Input no hp">
                                    </div>
                                    <div class="form-group">
                                        <label>No KTP</label>
                                        <input type="text" class="form-control" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ID_CARD]%>" placeholder="Input no ktp">
                                    </div>
                                    <div class="form-group">
                                        <label>Alamat Rumah</label>
                                        <textarea name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_ADDR_PERMANENT]%>" class="form-control"></textarea>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Pekerjaan</label>
                                        <select name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_VOCATION_ID]%>" class="form-control">
                                            <%
                                                Vector vVocation = PstVocation.list(0, 0, "", PstVocation.fieldNames[PstVocation.FLD_VOCATION_NAME]);
                                                for (int i = 0; i < vVocation.size(); i++) {
                                                    Vocation vocation = (Vocation) vVocation.get(i);
                                            %><option value="<%=vocation.getOID()%>"><%=vocation.getVocationName()%></option><%
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Jabatan</label>
                                        <select name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_POSITION_ID]%>" class="form-control">
                                            <%
                                                Vector vPosition = PstPosition.list(0, 0, "", PstPosition.fieldNames[PstPosition.FLD_POSITION]);
                                                for (int i = 0; i < vPosition.size(); i++) {
                                                    Position position = (Position) vPosition.get(i);
                                            %><option value="<%=position.getOID()%>"><%=position.getPosition()%></option><%
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Status</label>
                                        <select name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_MARITAL_ID]%>" class="form-control">
                                            <%
                                                Vector vMarital = PstMarital.list(0, 0, "", PstMarital.fieldNames[PstMarital.FLD_MARITAL_STATUS]);
                                                for (int i = 0; i < vMarital.size(); i++) {
                                                    Marital marital = (Marital) vMarital.get(i);
                                            %><option value="<%=marital.getOID()%>"><%=marital.getMaritalStatus()%></option><%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Alamat Kantor</label>
                                        <textarea name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_OFFICE_ADDRESS]%>" class="form-control"></textarea>
                                    </div>
                                    <div class="form-group">
                                        <label>Lokasi</label>
                                        <input type="hidden" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_LATITUDE]%>" id="latitude">
                                        <input type="hidden" name="<%=FrmAnggota.fieldNames[FrmAnggota.FRM_LONGITUDE]%>" id="longitude">
                                        <div class="form-control" id="map_canvas" style="height: 200px"></div>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div class="modal-footer">
                            <button type="submit" class="btn btn-sm btn-success"><i class="fa fa-floppy-o"></i> &nbsp; Simpan</button>
                            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                        </div>
                    </form>
                </div>

            </div>
        </div>

        <div id="modal-searchsales" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">                
                <!-- Modal content-->
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Cari Sales</h4>
                    </div>

                    <form >
                        <input type="hidden" name="FRM_FIELD_DATA_HISTORY" id="datafor">
                        <input type="hidden" name="command" value="<%= Command.SAVE%>">
                        <input type="hidden" name="FRM_FIELD_OID" id="oid">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12">

                                    <div id="salesTableElement">
                                        <table class="table table-striped table-bordered" style="font-size: 14px">
                                            <thead>
                                                <tr>
                                                    <th class="aksi">No.</th>
                                                    <th>Kode</th>
                                                    <th>Nama</th>
                                                    <th>Lokasi</th>
                                                    <th class="aksi">Aksi</th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </form>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                    </div>

                </div>

            </div>
        </div>

        <div id="modal-searchitem" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">                
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Cari Barang</h4>
                    </div>
                    <form >
                        <input type="hidden" name="FRM_FIELD_DATA_HISTORY" id="datafor">
                        <input type="hidden" name="FRM_FIELD_OID" id="oid">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <div id="materialTableElement">
                                        <table class="table table-striped table-bordered" style="font-size: 14px">
                                            <thead>
                                                <tr>
                                                    <th class="aksi">No.</th>
                                                    <th>SKU</th>
                                                    <th>Barcode</th>
                                                    <th>Nama Barang</th>
                                                    <th>Category</th>
                                                    <th>Brand</th>
                                                    <th>Warna</th>
                                                    <th>Type</th>
                                                    <th>Harga (Rp.)</th>
                                                    <th>Qty</th>
                                                    <th class="aksi">Aksi</th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </form>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                    </div>
                </div>
            </div>
        </div>

        <div id="openadditem" class="modal nonprint">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title"><b>ADD ITEM</b> - <b id="CONTENT_ITEM_TITLE"></b></h4>
                    </div>
                    <form id="FRM_ADD_ITEM">
                        <div class="modal-body">
                            <div>
                                <div class="row">
                                    <div class="box-body">
                                        <div class='col-md-12'>
                                            <input type="hidden" name="material_id" id="material_id">
                                            <input type="hidden" name="material_name" id="material_name">
                                            <input type="hidden" name="material_price" id="material_price">
                                            <div class='input-group'> 
                                                <input type="number" class="form-control" name="qty" id="matqty" placeholder="Quantity" step="any" required="required">
                                            </div>
                                            <div class="input-group" id='hiddenKeyBoard' style='margin-top:5px; display:none;'>
                                                <button type="button" data-value='1' class="btn btn-default addNum">&nbsp;1&nbsp;</button>
                                                <button type="button" data-value='2' class="btn btn-default addNum">&nbsp;2&nbsp;</button>
                                                <button type="button" data-value='3' class="btn btn-default addNum">&nbsp;3&nbsp;</button>
                                                <button type="button" data-value='4' class="btn btn-default addNum">&nbsp;4&nbsp;</button>
                                                <button type="button" data-value='5' class="btn btn-default addNum">&nbsp;5&nbsp;</button>
                                                <button type="button" data-value='6' class="btn btn-default addNum">&nbsp;6&nbsp;</button>
                                                <button type="button" data-value='7' class="btn btn-default addNum">&nbsp;7&nbsp;</button>
                                                <button type="button" data-value='8' class="btn btn-default addNum">&nbsp;8&nbsp;</button>
                                                <button type="button" data-value='9' class="btn btn-default addNum">&nbsp;9&nbsp;</button>
                                                <button type="button" data-value='0' class="btn btn-default addNum">&nbsp;0&nbsp;</button>
                                                <button type="button" data-value='-1' class="btn btn-danger addNum">Clear</button>
                                            </div>
                                        </div>
                                        <div class='col-md-12'>
                                            &nbsp;
                                        </div>
                                        <div class='col-md-12' id="groupSerial" style="display: none">

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary form-control" id="btnsaveitem">
                                <i class="fa fa-plus"></i> Add Item
                            </button>
                        </div>
                    </form>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div>

        <div id="modal-addtabungan" class="modal fade" role="dialog">
            <div class="modal-dialog modal-sm">                
                <!-- Modal content-->
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Tambah Tabungan</h4>
                    </div>

                    <form id="form-tabungan" enctype="multipart/form-data">
                        <input type="hidden" name="FRM_FIELD_DATA_FOR" id="datafor">
                        <input type="hidden" name="command" value="<%= Command.SAVE%>">
                        <input type="hidden" name="FRM_FIELD_CONTACTID" id="oid">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <%
                                        Vector<MasterTabungan> mts = PstMasterTabungan.list(0, 0, "", PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN]);
                                    %>
                                    <div class="form-group">
                                        <label>Nama Tabungan</label>
                                        <select name="<%=FrmAssignContact.fieldNames[FrmAssignContact.FRM_FIELD_MASTERTABUNGANID]%>" class="form-control">
                                            <%
                                                for (MasterTabungan mt : mts) {
                                            %><option value="<%=mt.getOID()%>"><%=mt.getNamaTabungan()%></option><%
                                                }
                                            %>
                                        </select>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-sm btn-success" id="btn-simpan-tabungan"><i class="fa fa-save"></i> &nbsp; Simpan</button>
                        </div>
                    </form>
                </div>

            </div>
        </div>                                            
        <%
            if (simulasiMatId != null) {
                for (int i = 0; i < simulasiMatId.length; i++) {
                    oidSimulasiMat = Long.parseLong(simulasiMatId[i]);
                    try {
                        mti = PstMaterial.fetchExc(oidSimulasiMat);
                    } catch (Exception e) {
                }%>
        <input type="hidden" name="MATERIAL_SIMULASI_ID" class="MATERIAL_SIMULASI_ID" value="<%=oidSimulasiMat%>">
        <% }
            for (int i = 0; i < simulasiMatQty.length; i++) {
                QtySimulasi = Integer.parseInt(simulasiMatQty[i]);
        %>
        <input type="hidden" name="MATERIAL_SIMULASI_QTY" class="MATERIAL_SIMULASI_QTY" value="<%=QtySimulasi%>">
        <%}
        for (int i = 0; i < simulasiMatPrice.length; i++) {
            priceSimulasi = Double.valueOf(simulasiMatPrice[i]);%>
        <input type="hidden" name="MATERIAL_SIMULASI_PRICE" class="MATERIAL_SIMULASI_PRICE" value="<%=priceSimulasi%>">

        <%}
        }%>
    </body>
</html>
