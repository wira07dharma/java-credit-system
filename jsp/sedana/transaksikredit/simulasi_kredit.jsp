<%-- 
    Document   : simulasi_kredit
    Created on : Nov 8, 2017, 9:24:12 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.pos.entity.billing.PstBillMain"%>
<%@page import="com.dimata.pos.entity.billing.BillMain"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.form.contact.FrmContactClass"%>
<%@page import="com.dimata.common.form.contact.FrmContactList"%>
<%@page import="com.dimata.posbo.entity.masterdata.Sales"%>
<%@page import="com.dimata.posbo.entity.masterdata.PstSales"%>
<%@page import="com.dimata.pos.form.billing.FrmBillMain"%>
<%@page import="com.dimata.sedana.form.kredit.FrmPinjaman"%>
<%@page import="com.dimata.sedana.entity.masterdata.JangkaWaktu"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstJangkaWaktu"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit"%>
<%@page import="com.dimata.sedana.session.kredit.SessKreditKalkulasi"%>
<%@page import="com.dimata.common.session.convert.ConvertAngkaToHuruf"%>
<%@page import="com.dimata.sedana.entity.masterdata.BiayaTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksi"%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.penjamin.PersentaseJaminan"%>
<%@page import="com.dimata.sedana.entity.penjamin.PstPersentaseJaminan"%>
<%@page import="com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.anggota.AnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.sumberdana.PstSumberDana"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.TypeKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.PstTypeKredit"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%!
    //hitung biaya asuransi
    public double countBiayaAsuransi(double jumlahPinjaman, double persentaseDijamin) {
        double biayaAsuransi = jumlahPinjaman * (persentaseDijamin / 100);
        return biayaAsuransi;
    }

    //hitung biaya lain
    public double countBiayaLain(String nilaiBiaya[], String tipeBiaya[], double jumlahPinjaman) {
        double biayaLain = 0;
        for (int i = 0; i < nilaiBiaya.length; i++) {
            double isiBiaya = Double.valueOf(nilaiBiaya[i]);
            int isiTipe = Integer.valueOf(tipeBiaya[i]);
            if (isiTipe == BiayaTransaksi.TIPE_BIAYA_UANG) {
                biayaLain += isiBiaya;
            } else if (isiTipe == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                double newNilaiBiaya = jumlahPinjaman * (isiBiaya / 100);
                biayaLain += newNilaiBiaya;
            }
        }
        return biayaLain;
    }

    //hitung uang yg diterima
    public double countUangDiterima(double jumlahPinjaman, double biayaAsuransi, double biayaLain) {
        double uangDiterima = jumlahPinjaman - (biayaAsuransi + biayaLain);
        return uangDiterima;
    }
%>

<% //
    SessKreditKalkulasi k = new SessKreditKalkulasi();
    int iCommand = FRMQueryString.requestCommand(request);
    long jenisKredit = FRMQueryString.requestLong(request, "FORM_JENIS_KREDIT");
    double jumlahPinjaman = FRMQueryString.requestDouble(request, "FORM_JUMLAH_PENGAJUAN");
    int jangkaWaktu = FRMQueryString.requestInt(request, "FORM_JANGKA_WAKTU");
    double sukuBunga = FRMQueryString.requestDouble(request, "FORM_SUKU_BUNGA");
    int tipeBunga = FRMQueryString.requestInt(request, "FORM_TIPE_BUNGA");
    long penjaminId = FRMQueryString.requestLong(request, "FORM_PENJAMIN");
    long persentaseId = FRMQueryString.requestLong(request, "FORM_COVERAGE");
    double persentaseDijamin = FRMQueryString.requestDouble(request, "FORM_PERSENTASE_DIJAMIN");
    String[] nilaiBiaya = request.getParameterValues("FORM_NILAI_BIAYA");
    String[] tipeBiaya = request.getParameterValues("FORM_TIPE_BIAYA");
    int viewNet = FRMQueryString.requestInt(request, "FORM_VIEW_DANA_NET");
    int submit = FRMQueryString.requestInt(request, "submit");
    int pembulatan = FRMQueryString.requestInt(request, "FORM_PEMBULATAN");
    String tglRealisasi = FRMQueryString.requestString(request, "FORM_TGL_REALISASI");
    int tipeJadwal = FRMQueryString.requestInt(request, "FORM_TIPE_JADWAL");
    long userCashierId = FRMQueryString.requestLong(request, "USER_ID");
    long cashCashierId = FRMQueryString.requestLong(request, "CASH_CASHIER_ID");
    long shiftCashierId = FRMQueryString.requestLong(request, "SHIFT_ID");
    long locId = FRMQueryString.requestLong(request, "LOCATION_ID");
    //
    String[] jenisPengajuan = {"Jumlah Pengajuan","Jumlah Diterima"};
    String textJumlahPinjaman = "";
    String textJangkaWaktu = "";
    String textSukuBunga = "";
    JenisKredit kredit = new JenisKredit();
    double biayaAsuransi = 0;
    double biayaLain = 0;
    boolean monthly = false;
    String tipeFrekuensi = "";
    tglRealisasi = (tglRealisasi.isEmpty()) ? Formater.formatDate(new Date(), "yyyy-MM-dd") : tglRealisasi;
    Date realisasiDate = Formater.formatDate(tglRealisasi, "yyyy-MM-dd");
    //
    int error = 0;
    String message = "";
    //
    if (iCommand == Command.LIST) {
        try {
            textJumlahPinjaman = "" + jumlahPinjaman;
            textJangkaWaktu = "" + Formater.formatNumber(jangkaWaktu, "#");
            textSukuBunga = "" + sukuBunga;
            kredit = PstJenisKredit.fetch(jenisKredit);
            monthly = kredit.getTipeFrekuensiPokokLegacy() == I_Sedana.TIPE_KREDIT_BULANAN || kredit.getTipeFrekuensiPokokLegacy() == I_Sedana.TIPE_KREDIT_MUSIMAN;
            String arrayTipeFrekuensi[] = I_Sedana.TIPE_KREDIT.get(kredit.getTipeFrekuensiPokokLegacy());
            tipeFrekuensi = arrayTipeFrekuensi[SESS_LANGUAGE];

            //hitung biaya asuransi
            biayaAsuransi = countBiayaAsuransi(jumlahPinjaman, persentaseDijamin);
            //hitung biaya lain
            if (tipeBiaya != null) {
                biayaLain = countBiayaLain(nilaiBiaya, tipeBiaya, jumlahPinjaman);
            }

            //cek validasi
            if (jumlahPinjaman < kredit.getMinKredit()) {
                error += 1;
                message += "<div><i class='fa fa-exclamation-circle text-red'></i> Jumlah pinjaman <b>lebih kecil</b> dari standar minimal Rp. <span class='money text-bold'>" + kredit.getMinKredit() + "</span></div>";
            }
            if (jumlahPinjaman > kredit.getMaxKredit()) {
                error += 1;
                message += "<div><i class='fa fa-exclamation-circle text-red'></i> Jumlah pinjaman <b>lebih besar</b> dari standar maksimal Rp. <span class='money text-bold'>" + kredit.getMaxKredit() + "</span></div>";
            }
            if (jumlahPinjaman <= 0) {
                error += 1;
                message += "<div><i class='fa fa-exclamation-circle text-red'></i> Pastikan jumlah pinjaman diisi dengan benar</div>";
            }
            if (jangkaWaktu < kredit.getJangkaWaktuMin()) {
                error += 1;
                message += "<div><i class='fa fa-exclamation-circle text-red'></i> Jangka waktu <b>lebih kecil</b> dari standar minimal <span class='text-bold'>" + String.format("%,.0f", kredit.getJangkaWaktuMin()) + "</span> (" + tipeFrekuensi + ")</div>";
            }
            if (jangkaWaktu > kredit.getJangkaWaktuMax()) {
                error += 1;
                message += "<div><i class='fa fa-exclamation-circle text-red'></i> Jangka waktu <b>lebih besar</b> dari standar maksimal <span class='text-bold'>" + String.format("%,.0f", kredit.getJangkaWaktuMax()) + "</span> (" + tipeFrekuensi + ")</div>";
            }
            if (sukuBunga < kredit.getBungaMin()) {
                error += 1;
                message += "<div><i class='fa fa-exclamation-circle text-red'></i> Jumlah suku bunga <b>lebih kecil</b> dari standar minimal <span class='money text-bold'>" + kredit.getBungaMin() + "</span> %</div>";
            }
            if (sukuBunga > kredit.getBungaMax()) {
                error += 1;
                message += "<div><i class='fa fa-exclamation-circle text-red'></i> Jumlah suku bunga <b>lebih besar</b> dari standar maksimal <span class='money text-bold'>" + kredit.getBungaMax() + "</span> %</div>";
            }
            if (tglRealisasi.isEmpty()) {
                error += 1;
                message += "<div><i class='fa fa-exclamation-circle text-red'></i> Pastikan tanggal realisasi diisi dengan benar</div>";
            }
            if (realisasiDate == null) {
                error += 1;
                message += "<div><i class='fa fa-exclamation-circle text-red'></i> Pastikan tanggal realisasi diisi dengan benar</div>";
            }
        } catch (Exception e) {
            error += 1;
            message += "<div><i class='fa fa-exclamation-circle text-red'></i> Terjadi kesalahan [" + e.getMessage() + "]</div>";
        }
    }

    if (error == 0 && iCommand == Command.LIST) {
        try {
            k.setKredit(kredit);
            k.setRealizationDate(realisasiDate);
            k.setJangkaWaktu(jangkaWaktu);
            k.setPengajuanTotal(jumlahPinjaman);
            k.setSukuBunga(sukuBunga);
            k.setJangkaWaktu(jangkaWaktu);
            k.setTipeBunga(tipeBunga);
            k.setWithMinimal(viewNet > 0);
            k.setBiayaTotal(biayaAsuransi + biayaLain);
            k.setTipeJadwal(tipeJadwal);
            k.generateDataKredit();
        } catch (Exception e) {
            error += 1;
            message += "<div><i class='fa fa-exclamation-circle text-red'></i> Terjadi kesalahan saat proses pembuatan jadwal [" + e.getMessage() + "]</div>";
        }
    }

    if (error == 0 && viewNet == 1 && k.getPengajuanFinal() > kredit.getMaxKredit()) {
        error += 1;
        message += "* Saran pengajuan kredit untuk memperoleh dana net sebesar <b>Rp</b> <b class='money'>" + jumlahPinjaman + "</b> tidak diperoleh."
                + "<br>* Hal ini dikarenakan jumlah saran pengajuan yang diperoleh dari simulasi melebihi batas maksimal pengajuan kredit untuk jenis kredit <b> '" + kredit.getNamaKredit() + "' </b>.";
        message += "<br>* Silakan pilih jenis kredit lain yang sesuai.";
    }
    String typeOfCredit = PstSystemProperty.getValueByName("TYPE_OF_CREDIT");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@ include file = "/style/style_kredit.jsp" %>
        <style>

            print-area { visibility: hidden; display: none; }
            print-area.preview { visibility: visible; display: block; }
            body > table.table.table-bordered.dataTable.no-footer.fixedHeader-locked { display: none; }

            @page {
                padding: 2cm;
                margin: 2.5cm;    
            }

            @media print
            {
                body .main-page * { visibility: hidden; display: none; } 
                body print-area * { visibility: visible; }
                body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
            }
            td {
                padding-top: 5px;
                padding-bottom: 5px;
                padding-right: 10px;
            }
            .fix-size-td {width: 140px}

            .td2 td {
                padding-top: 0px;
                padding-bottom: 0px;
                padding-right: 10px;
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

                $(':input').attr('autocomplete', 'off');

                $('.tipe_kredit').change(function () {
                    var oid = $(this).val();
                    var command = "<%=Command.NONE%>";
                    var dataFor = "getDataJenisKredit";

                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command,
                        "SESS_LANGUAGE": <%= SESS_LANGUAGE%>
                    };
                    //alert(dataSend);
                    onDone = function (data) {
                        $.map(data.RETURN_DATA_JENIS_KREDIT, function (item) {
                            //setting nilai minimal
                            $('#show_pengajuan').val(item.kredit_min);
                            jMoney('#show_pengajuan');
                            $('#jangkaWaktu').val(item.jangka_min);
                            $('#bungaPinjaman').val(item.bunga_min);
                            jMoney('#bungaPinjaman');
                            //
                            $('#min_pengajuan').html(item.kredit_min);
                            jMoney('#min_pengajuan');
                            $('#max_pengajuan').html(item.kredit_max);
                            jMoney('#max_pengajuan');
                            $('#min_bunga').html(item.bunga_min);
                            jMoney('#min_bunga');
                            $('#max_bunga').html(item.bunga_max);
                            jMoney('#max_bunga');
                            $('#min_waktu').html(item.jangka_min);
                            $('#max_waktu').html(item.jangka_max);
                            if (item.bunga_min == item.bunga_max) {
                                $('body #bungaPinjaman').val(item.bunga_max);
                                jMoney('body #bungaPinjaman');
                            }
                            if (item.jangka_min == item.jangka_max) {
                                $('#jangkaWaktu').val(item.jangka_max);
                            }
                            if (item.kredit_min == item.kredit_max) {
                                $("#show_pengajuan").val(item.kredit_max);
                                jMoney('#show_pengajuan');
                            }
                            $(".tipe_frekuensi_legacy").html(item.tipe_frekuensi);
                            $("body select[name=FORM_TIPE_BUNGA]").val(item.tipe_bunga);

                        });
                    };

                    onSuccess = function (data) {

                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, true);
                });

                $('.penjaminKredit').change(function () {
                    var oid = $(this).val();
                    if (oid === "") {
                        $('#coverage').html("<option value=''>Pilih penjamin terlebih dahulu</option>");
                        return false;
                    }
                    var command = "<%=Command.NONE%>";
                    var dataFor = "getDataCoverage";

                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command,
                        "SEND_JANGKA_WAKTU": $('#jangkaWaktu').val()
                    };
                    onDone = function (data) {
                        $('#coverage').html(data.FRM_FIELD_HTML);
                    };

                    onSuccess = function (data) {

                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxPenjamin", null, true);
                });
                  $('.penjaminKreditPersentase').change(function () {
                    var oid = $(this).val();
                    if (oid === "") {
                        $('#coverage').html("<option value=''>Pilih penjamin terlebih dahulu</option>");
                        return false;
                    }
                    var command = "<%=Command.NONE%>";
                    var dataFor = "getDataPersentasePenjamin";

                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command,
                        "SEND_JANGKA_WAKTU": $('#jangkaWaktu').val()
                    };
                    onDone = function (data) {
                        $('#coverage').html(data.FRM_FIELD_HTML);
                    };

                    onSuccess = function (data) {

                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxPenjamin", null, true);
                });

                $('#coverage').change(function () {
                    var persen = $('#coverage option:selected').data('persen');
                    $('#showPersen').val(persen);
                    $('.val_persen').val(persen);
                });

                $('#jangkaWaktu').change(function () {
                    $('.penjaminKredit').val("");
                    $('#coverage').html("<option value=''>Pilih penjamin terlebih dahulu</option>");
                });

                $('.checkUang').click(function () {
                    $(this).prop("checked", true);
                    var row = $(this).data('row');
                    $('#persen' + row).prop("checked", false);
                });

                $('.checkPersen').click(function () {
                    $(this).prop("checked", true);
                    var row = $(this).data('row');
                    $('#uang' + row).prop("checked", false);
                });

                $('#FORM_SIMULASI').submit(function () {
                    var jumlah = $('#jumlahBiaya').val();
                    var i = 0;
                    $('.cek').each(function () {
                        var check = $(this).is(':checked');
                        if (check === true) {
                            i += 1;
                        }
                    });
                    if (i != jumlah) {
                        alert("Pastikan jenis biaya sudah dipilih");
                        return false;
                    }
                    $('.btn_hitung').html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu").attr({"disabled": true});
                });

                $('#btn-print').click(function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu");
                    window.print();
                    $(this).removeAttr('disabled').html(buttonHtml);
                });
                
                 $('#btn-pengajuan-new').click(function () {
                    var shiftId = $("#FRM_FIELD_SHIFT_ID").val();
                    var cashCashierId = $("#FRM_FIELD_CASH_CASHIER_ID").val();
                    var userId = $("#FRM_FIELD_APP_USER_ID").val();
                    var locationId = $("#FRM_FIELD_LOCATION_ID").val();
                    var command = "<%=Command.SAVE%>";
                    var dataFor = "saveSimulasiPengajuan";
                    var status = $("#status_proses").val();
                    if (status === true){
                        var dataSend = {
                          "FRM_FIELD_DATA_FOR": dataFor,
                          "command": command,
                          "FRM_FIELD_SHIFT_ID" : shiftId,
                          "FRM_FIELD_CASH_CASHIER_ID" : cashCashierId,
                          "FRM_FIELD_APP_USER_ID" : userId,
                          "FRM_FIELD_LOCATION_ID" : locationId
                        };

                        onDone = function (data) {
                          var billId = data.RETURN_BILL_MAIN_ID;
    //                      alert(billId);
                          goPengajuan(billId);
                        };
                        onSuccess = function (data) {
                        };
                        getDataFunction1(onDone, onSuccess, approot, command, dataSend, "AjaxKredit", null, true);
                        return false;
                    } else {
                        alert("Tidak dapa melanjutkan ke pengajuan karena ada item dengan Qty 0!")
                    }
                    
                });

                  function goPengajuan(billId) {
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu");
                    var data = $('#FORM_SIMULASI').serialize();
                    var billMainId = billId;
                    var matId = $("#material_id").val();
                    var matName = $("#material_name").val();
                    var matPrice = $("#material_price").val();
                    var matQty = $("#matqty").val();
                    window.location = "transaksi_kredit.jsp?command=" + "<%=Command.ADD%>" + "&direct_simulasi=1&" + data +"&BILL_MAIN_ID=" + billMainId;
                };


                $('#btn-pengajuan').click(function () {
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu");
                    var data = $('#FORM_SIMULASI').serialize();
                    window.location = "transaksi_kredit.jsp?command=" + "<%=Command.ADD%>" + "&direct_simulasi=1&" + data;
                });

                $('.datetime-picker').datetimepicker({
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
                
                $('body').on("click", ".mat-sku", function () {
                    var oid = $(this).data('oid');
                    var matName = $(this).data('matname');
                    var price = $(this).data('matprice');
                    var qty = $(this).data('qty');
                    
                    $("#material_id").val(oid);
                    $("#material_name").val(matName);
                    $("#material_price").val(price);
                    $("#material_stock").val(qty);
                    $("#openadditem").modal("show");
                    $("#CONTENT_ITEM_TITLE").html(matName);
                    $("#matqty").val(1);
                    $('#openadditem #matqty').focus();
                });
                
                $('#btnsaveitem').click(function () {
                    var oid = $("#material_id").val();
                    var dp = parse($("#dp").val());
                    var price = $("#material_price").val();
                    var jangkaWaktuId = $("#FORM_JANGKA_WAKTU").val();
                    var matQty = $("#matqty").val();
                    var command = "<%=Command.NONE%>";
                    var dataFor = "getMaterial";
                    var total = +price * +matQty;
                    var pengajuan = parse($("#totalPrice").val());
                    var currPengajuan = parse($("#pengajuan").val());
                    
                    var qty = $("#material_stock").val();
                    if (qty < 1){
                        $("#status_proses").val("false");
                    }
                    $("#totalPrice").val(+total + +pengajuan);
                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command,
                        "QTY" : matQty,
                        "DP" : dp,
                        "JANGKA_WAKTU_ID" : jangkaWaktuId,
                        "TOTAL_PRICE" : pengajuan,
                        "CURRENT_PENGAJUAN" : currPengajuan
                    };
                    //alert(dataSend);
                    onDone = function (data) {
                        $("#item-list").css("display", "block");
                        $('#table-item tr:last').after(data.FRM_FIELD_HTML);
                        jMoney('#total_' + oid);
                        deleteItem()
                        getTotalPengajuan();
                        //getDataTabungan();
                    };

                    onSuccess = function (data) {
                        $("#openadditem").modal("hide");
                        $('#modal-searchitem').modal('hide');
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction1(onDone, onSuccess, approot, command, dataSend, "AjaxMaterial", null, true);
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

                $('.btn_hitung_kredit').click(function () {
                    var tglRealisasi = $("#FRM_TGL_REALISASI").val();
                    var jangkaWaktuId = $("#FORM_JANGKA_WAKTU").val();
                    var pengajuan = $("#FORM_JUMLAH_PINJAMAN").val();
                    var dp = parse($("#dp").val());
                    var penjamin = $("#FORM_PENJAMIN").val();
                    var coverage = $("#coverage").val();
                    var jenisKredit = $("#FORM_JENIS_KREDIT").val();
                    var persentaseDijamin = $("#FORM_PERSENTASE_DIJAMIN").val();
                    var command = "<%=Command.NONE%>";
                    var dataFor = "getSimulasiKredit";
                    var biayaList = "";
                    $(".FORM_NILAI_BIAYA").each(function(){
                      biayaList += biayaList.length == 0? "": ",";
                      biayaList += $(this).val();
                    });
                    var typeBiaya = "";
                    $(".FORM_TIPE_BIAYA").each(function(){
                      if($(this).is(":checked")){
                      typeBiaya += typeBiaya.length == 0? "": ",";
                      typeBiaya += $(this).val();
                    }
                    });
                    var dataSend = {
                        "FORM_TGL_REALISASI": tglRealisasi,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "FORM_JUMLAH_PINJAMAN": pengajuan,
                        "FORM_JANGKA_WAKTU" : jangkaWaktuId,
                        "DP" : dp,
                        "FORM_PENJAMIN" : penjamin,
                        "FORM_COVERAGE" : coverage,
                        "FORM_PERSENTASE_DIJAMIN" : persentaseDijamin,
                        "FORM_JENIS_KREDIT" : jenisKredit,
                        "FORM_NILAI_BIAYA" : biayaList,
                        "FORM_TIPE_BIAYA" : typeBiaya
                    };
                    //alert(dataSend);
                    onDone = function (data) {
                        $('#dvAngsuran').html(data.FRM_FIELD_HTML);
                        jMoney('.dp');
                        jMoney('.angsuran');
                        print(data.FRM_FIELD_HTML);
                        $('#btn-simulasi').css("display", "block");
                    };
                    onSuccess = function (data) {
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction1(onDone, onSuccess, approot, command, dataSend, "AjaxKredit", null, true);
                    return false;
                });
            function print(dataPrint){
                $('#btn-print-new').click(function () {
                  $('#printArea').html(dataPrint);
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu");
                    $("#printArea").css("display", "block");
                    window.print();
                    $("#printArea").css("display", "none");
                    $(this).removeAttr('disabled').html(buttonHtml);
                });
            }
                
                function deleteItem() {
                    $('.mat-delete').click(function () {
                        var oid = $(this).data('oid');
                        var total = $(this).data('total');
                        $('#table-item tr#' + oid).remove();
                        var totalPrice = parse($("#totalPrice").val());
                        $("#totalPrice").val(+totalPrice - +total);
                        if ($('#table-item tr').length === 1) {
                            $("#item-list").css("display", "none");
                        }
                        getTotalPengajuan();
                    });
                }

                $( "#FORM_JANGKA_WAKTU").click(function() {
                    getTotalPengajuan();
                });
                $( "#dp").keyup(function() {
                    getTotalPengajuan();
                });
                deleteItem();
                
//                function getTotalPengajuan() {
//                    var command = "<%=Command.NONE%>";
//                    var pengajuan = parse($("#totalPrice").val());
//                    var dp = parse($("#dp").val());
//                    var jangkaWaktuId = $("#FORM_JANGKA_WAKTU").val();
//                    var totalCash = 0;
//                    $('.cashTotal').each(function(){
//                        var value = $(this).val();
//                        totalCash = +totalCash + +value;   // Or this.innerHTML, this.innerText
//                    });
//                    var dataSend = $("#FORM_SIMULASI").serialize()+ "&FRM_FIELD_DATA_FOR=calculatePrice&TOTAL_PRICE="
//                            +pengajuan+"&DP="+dp+"&JANGKA_WAKTU_ID="+jangkaWaktuId+"&TOTAL_CASH="+ totalCash;
//                    onDone = function (data) {
//                        $('#pengajuan').val(data.FRM_TOTAL_PRICE);
//                        $('#BUNGA').val(data.FRM_JUMLAH_BUNGA);
//                        jMoney('#pengajuan');
//                        jMoney('#BUNGA');
//                    };
//                    onSuccess = function (data) {
//
//                    };
//                    //alert(JSON.stringify(dataSend));
//                    getDataFunction1(onDone, onSuccess, approot, command, dataSend, "AjaxMaterial", null, false);
//                }
                
                var getDataFunction1 = function (onDone, onSuccess, approot, command, dataSend, servletName, dataAppendTo, notification) {
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
                
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                    var oid = "0";
                    var datafilter = "";
                    var privUpdate = "";
                    var jenisKredit = $("#FORM_JENIS_KREDIT").val();
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "oLanguage": {
                            "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div></div>"
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor 
                                + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>" + "&SEND_OID_RESERVATION=" + oid+"&TIPE_KREDIT_ID="+jenisKredit+"&FRM_FIELD_LOCATION_ID=<%=userLocationId%>",
                        aoColumnDefs: [
                            {
                                bSortable: false,
                                aTargets: [-1]
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
                
                $('#btn-pilihbarang').click(function () {
                    var jenisKredit = $("#FORM_JENIS_KREDIT").val();
                    if (jenisKredit.length>0){
                        modalSetting("#modal-searchitem", "static", false, false);
                        $('#modal-searchitem').modal('show');
                        runDataTable("#materialTableElement", "tableMaterialTableElement", "AjaxMaterial", "listMaterial");
                    } else {
                        alert("Pilih Jenis Kredit!")
                    }
                });
                
                $('body').on('click', '#btn-tanpaDp', function(){
                    let oid = $(this).val();
                    $('#dp').val(oid);
                    $('#FORM_DOWN_PAYMENT').val(oid);
                    getTotalPengajuan();
                });
                
                $('body').on('click', '#btn-getDp', function(){
                    setDpKredit(0, this);
                });

                function getTotalPengajuan() {
                    var command = "<%=Command.NONE%>";
                    var pengajuan = parse($("#totalPrice").val());
//                    var dp = parse($(".valDP").val());
                    var dp = $('#FORM_DOWN_PAYMENT').val();
                    var jangkaWaktuId = $("#FORM_JANGKA_WAKTU").val();
                    var jenisKreditId = $("#FORM_JENIS_KREDIT").val();
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

                    var dataSend = $("#FORM_SIMULASI").serialize()+ "&FRM_FIELD_DATA_FOR=calculatePrice&TOTAL_PRICE="
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
                    getDataFunction1(onDone, onSuccess, approot, command, dataSend, "AjaxMaterial", null, false);
                }
                function setDpKredit(tipe, btn) {
                    var buttonHtml = $(btn).html();
                    $(btn).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                    var command = "<%=Command.NONE%>";
                    var pengajuan = parse($("#totalPrice").val());
                    //var dp = parse($(".valDP").val());
                    var jangkaWaktuId = $("#FORM_JANGKA_WAKTU").val();
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
                    var dataForm = $("#FORM_SIMULASI").serialize();
                    var dataAdd = "&FRM_FIELD_DATA_FOR=calculateDP&TOTAL_PRICE="
                            +pengajuan+"&JANGKA_WAKTU_ID="+jangkaWaktuId+"&TOTAL_CASH="+ totalCash+"&TIPE_DP="+tipe+"&TOTAL_HPP="+totalHpp;
                    
                    var dataSend = dataForm + dataAdd;
                    onDone = function (data) {
                        let total = data.FRM_TOTAL_PRICE;
                        $('#FRM_DOWN_PAYMENT').val(total);
                        $('#dp').val(total);
                        jMoney('#dp');
                        $('#btn-getDp').removeAttr('disabled').html(buttonHtml);
                        getTotalPengajuan();
                    };
                    onSuccess = function (data) {
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction1(onDone, onSuccess, approot, command, dataSend, "AjaxMaterial", null, false);
                }

                $('.datePicker').datetimepicker({
                    format: "yyyy-mm-dd",
                    todayBtn: true,
                    autoclose: true,
                    minView: 2
                });

            });
        </script>
        <style>.table-angsuran th { background-color: #ececec; color: #000000; } .table-angsuran, .table-angsuran th, .table-angsuran td, .table-angsuran tr { border: 1px solid #b5b5b5 !important; } .tabel_simulasi, .table-angsuran {font-size: 14px}</style>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>Simulasi Kredit<small></small></h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Transaksi</li>
                    <li class="active">Kredit</li>
                </ol>
            </section>

            <section class="content">
                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Data Simulasi</h3>
                    </div>

                    <p></p>

                    <form id="FORM_SIMULASI" class="form-horizontal" method="post" action="?command=<%=Command.LIST%>">
                        <input type="hidden" name="submit" value="1">
                        <input type="hidden" name="FORM_BIAYA_LAIN" value="<%= biayaLain%>">
                        <input type="hidden" id="status_proses" value="true">
                        <div class="box-body">
                            <% if (typeOfCredit.equals("0")) { %>
                            <div class="col-sm-6">
                                <label>Data Pengajuan :</label>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Jenis Kredit</label>
                                    <div class="col-sm-6">
                                        <%
                                            Vector listTypeKredit = PstTypeKredit.list(0, 0, "", "");
                                            Vector typeKreditKey = new Vector(1, 1);
                                            Vector typeKreditValue = new Vector(1, 1);
                                            for (int i = 0; i < listTypeKredit.size(); i++) {
                                                TypeKredit tk = (TypeKredit) listTypeKredit.get(i);
                                                typeKreditKey.add(tk.getNameKredit() + " [" + I_Sedana.TIPE_KREDIT.get(tk.getTipeFrekuensiPokokLegacy())[SESS_LANGUAGE] + "]");
                                                typeKreditValue.add("" + tk.getOID());
                                            }
                                        %>
                                        <%=ControlCombo.draw("FORM_JENIS_KREDIT", "form-control input-sm tipe_kredit", "- Pilih -", "" + jenisKredit, typeKreditValue, typeKreditKey, "required id='FORM_JENIS_KREDIT'")%> 
                                    </div>
                                </div>
                                    
                                <div class="form-group">
                                    <div class="col-sm-4">
                                        <select style="border-color: transparent; font-weight: bold; color: black" class="form-control input-sm" name="FORM_VIEW_DANA_NET">
                                            <option <%= (viewNet == 0) ? "selected" : ""%> value="0"><%= jenisPengajuan[0] %></option>
                                            <option <%= (viewNet == 1) ? "selected" : ""%> value="1"><%= jenisPengajuan[1] %></option>
                                        </select>
                                    </div>
                                    <!--label class="control-label col-sm-4">Jumlah Pinjaman</label-->
                                    <div class="col-sm-6">
                                        <div class="input-group">
                                            <span class="input-group-addon">Rp</span>
                                            <input type="text" id="show_pengajuan" required="" class="form-control input-sm money" data-cast-class="val_pengajuan" value="<%=textJumlahPinjaman%>">
                                            <input type="hidden" class="val_pengajuan" name="FORM_JUMLAH_PENGAJUAN" value="<%=textJumlahPinjaman%>">                                    
                                        </div>
                                        <small>
                                            Rp <a class="money text-black" id="min_pengajuan"><%=kredit.getMinKredit()%></a>
                                            &nbsp; - &nbsp;
                                            Rp <a class="money text-black" id="max_pengajuan"><%=kredit.getMaxKredit()%></a>
                                        </small>
                                    </div>
                                </div>
                                        
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Jangka Waktu</label>
                                    <div class="col-sm-6">
                                        <div class="input-group">
                                            <input type="number" min="1" required="" id="jangkaWaktu" class="form-control input-sm" name="FORM_JANGKA_WAKTU" value="<%=textJangkaWaktu%>">
                                            <span class="input-group-addon tipe_frekuensi_legacy"><%= tipeFrekuensi %></span>
                                        </div>
                                        <small>
                                            <a class="text-black" id="min_waktu"><%=Formater.formatNumber(kredit.getJangkaWaktuMin(), "#")%></a>
                                            &nbsp; - &nbsp;
                                            <a class="text-black" id="max_waktu"><%=Formater.formatNumber(kredit.getJangkaWaktuMax(), "#")%></a>
                                        </small>
                                    </div>
                                </div>
                                        
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Suku Bunga</label>
                                    <div class="col-sm-6">
                                        <div class="input-group">
                                            <input type="text" id="bungaPinjaman" required="" class="form-control input-sm money" data-cast-class="val_bunga" value="<%=textSukuBunga%>">
                                            <input type="hidden" class="val_bunga" name="FORM_SUKU_BUNGA" value="<%=textSukuBunga%>">
                                            <span class="input-group-addon">% / Tahun</span>
                                        </div>
                                        <small>
                                            <a class="money text-black" id="min_bunga"><%=kredit.getBungaMin()%></a> %
                                            &nbsp; - &nbsp;
                                            <a class="money text-black" id="max_bunga"><%=kredit.getBungaMax()%></a> %
                                        </small>
                                    </div>
                                </div>
                                        
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Tipe Bunga</label>
                                    <div class="col-sm-6">
                                        <%
                                            Vector tipe_bunga_key = new Vector();
                                            Vector tipe_bunga_val = new Vector();
                                            for (int i = 0; i < Pinjaman.TIPE_BUNGA_TITLE.length; i++) {
                                                tipe_bunga_key.add("" + i);
                                                tipe_bunga_val.add("" + Pinjaman.TIPE_BUNGA_TITLE[i]);
                                            }
                                        %>
                                        <%= ControlCombo.draw("FORM_TIPE_BUNGA", "- Pilih -", "" + tipeBunga, tipe_bunga_key, tipe_bunga_val, "", "form-control input-sm")%>
                                    </div>
                                </div>
                                    
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Tipe Jadwal</label>
                                    <div class="col-sm-6">          
                                        <select class="form-control input-sm" name="FORM_TIPE_JADWAL">
                                            <% for (int i = 0; i < Pinjaman.TIPE_JADWAL_TITLE.length; i++) {%>
                                            <option <%=(tipeJadwal == i) ? "selected" : ""%> value="<%=i%>"><%=Pinjaman.TIPE_JADWAL_TITLE[i]%></option>
                                            <% }%>                                           
                                        </select>
                                    </div>
                                </div>
                                        
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Tanggal Realisasi</label>
                                    <div class="col-sm-6">
                                        <input type="text" class="form-control input-sm datetime-picker" name="FORM_TGL_REALISASI" id="FORM_TGL_REALISASI" value="<%= tglRealisasi%>">
                                    </div>
                                </div>
                                    
                                <div class="form-group">
                                    <div class="col-sm-4"></div>
                                    <div class="col-sm-6">
                                        <div class="checkbox">
                                            <label><input type="checkbox" <%= (pembulatan == 1) ? "checked" : ""%> name="FORM_PEMBULATAN" value="1">Gunakan Pembulatan</label>
                                        </div>
                                    </div>
                                </div>
                                        
                                <div class="form-group" style="margin-bottom: 0px;">
                                    <%
                                        String visible = "style='visibility: hidden;'";
                                        if (submit == 1) {
                                            visible = "";
                                        }
                                    %>
                                    <div class="col-sm-10" id="hitung" <%=visible%>>
                                        <button type="submit" id="" class="btn btn-sm btn-success pull-right btn_hitung"><i class="fa fa-gear"></i> &nbsp; Hitung</button>
                                    </div>
                                    <div class="col-sm-10">
                                        <hr style="border-color: lightgray">
                                    </div>
                                </div>
                                        
                                <label>Biaya Transport :</label>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Penjamin</label>
                                    <div class="col-sm-6">                                    
                                        <%
                                            Vector penjamin_key = new Vector();
                                            Vector penjamin_val = new Vector();
                                            Vector<AnggotaBadanUsaha> listPenjaminKredit = PstAnggotaBadanUsaha.listJoinContactClassPenjamin(0, 0, "", "");
                                            for (int i = 0; i < listPenjaminKredit.size(); i++) {
                                                penjamin_key.add("" + listPenjaminKredit.get(i).getOID());
                                                penjamin_val.add("" + listPenjaminKredit.get(i).getName());
                                            }
                                        %>
                                        <%= ControlCombo.draw("FORM_PENJAMIN", "form-control input-sm penjaminKredit", "- Pilih -", "" + penjaminId, penjamin_key, penjamin_val, "")%>
                                    </div>
                                </div>
                                    
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Persentase Dijamin</label>
                                    <div class="col-sm-6">
                                        <select class="form-control input-sm" id="coverage" name="FORM_COVERAGE">                                        
                                            <% if (iCommand == Command.LIST) {
                                            %>
                                            <option value="">- Pilih -</option>
                                            <%
                                                Vector listCoverage = PstPersentaseJaminan.list(0, 0, ""
                                                        + "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_ID_PENJAMIN] + " = '" + penjaminId + "'"
                                                        + " AND " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " = '" + textJangkaWaktu + "'"
                                                        + "", "");
                                                for (int i = 0; i < listCoverage.size(); i++) {
                                                    PersentaseJaminan pj = (PersentaseJaminan) listCoverage.get(i);
                                                    String selected = "";
                                                    if (pj.getOID() == persentaseId) {
                                                        selected = "selected";
                                                    }
                                            %>
                                            <option <%=selected%> data-persen="<%=pj.getPersentaseDijamin()%>" value="<%=pj.getOID()%>"><%=pj.getPersentaseCoverage()%> %</option>
                                            <%
                                                }
                                            } else {
                                            %>
                                            <option>Pilih penjamin terlebih dahulu</option>
                                            <%
                                                }
                                            %>                                        
                                        </select>
                                    </div>
                                </div>
                                        
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Persentase Dibayar</label>
                                    <div class="col-sm-6">
                                        <div class="input-group">
                                            <input type="text" id="showPersen" readonly="" class="form-control input-sm" data-cast-class="val_persen" value="<%=persentaseDijamin%>">
                                            <input type="hidden" class="val_persen" name="FORM_PERSENTASE_DIJAMIN" value="<%=persentaseDijamin%>">
                                            <span class="input-group-addon">%</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group" style="margin-bottom: 0px;">
                                    <div class="col-sm-10" id="hitung" <%=visible%>>
                                        <button type="submit" id="" class="btn btn-sm btn-success pull-right btn_hitung"><i class="fa fa-gear"></i> &nbsp; Hitung</button>
                                    </div>
                                    <div class="col-sm-10">
                                        <hr style="border-color: lightgray">
                                    </div>
                                </div>
                                        
                                <%
                                    Vector listJenisTransaksi = PstJenisTransaksi.list(0, 0, ""
                                            + "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_UMUM + "'"
                                            //+ " OR " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_PERUSAHAAN + "'"
                                            + " GROUP BY " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC]
                                            + "", "");
                                    for (int i = 0; i < listJenisTransaksi.size(); i++) {
                                        JenisTransaksi jt = (JenisTransaksi) listJenisTransaksi.get(i);
                                %>
                                <label><%=JenisTransaksi.TIPE_DOC_TITLE[jt.getTipeDoc()]%> :</label>

                                <%
                                    Vector listChildJenisTransaksi = PstJenisTransaksi.list(0, 0, "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + jt.getTipeDoc() + "'", "");
                                    for (int j = 0; j < listChildJenisTransaksi.size(); j++) {
                                        JenisTransaksi jt2 = (JenisTransaksi) listChildJenisTransaksi.get(j);
                                        String lastValue = "";
                                        String lastCheck = "";
                                        String checked = "";
                                        if (iCommand == Command.LIST) {
                                            lastValue = nilaiBiaya[j];
                                            if (tipeBiaya != null) {
                                                lastCheck = tipeBiaya[j];
                                            }
                                        } else {
                                            if (jt2.getValueStandarTransaksi() != 0) {
                                                lastValue = "" + jt2.getValueStandarTransaksi();
                                            } else {
                                                lastValue = "" + jt2.getProsentasePerhitungan();
                                            }
                                        }
                                %>
                                <div class="form-group">
                                    <input type="hidden" id="jumlahBiaya" value="<%=listChildJenisTransaksi.size()%>">
                                    <label class="control-label col-sm-4"><%=jt2.getJenisTransaksi()%></label>
                                    <div class="col-sm-4">
                                        <input type="text" autocomplete="off" required="" id="showPersen" class="form-control input-sm money" data-cast-class="val_biaya" value="<%=lastValue%>">
                                        <input type="hidden" class="val_biaya" name="FORM_NILAI_BIAYA" value="<%=lastValue%>">                                                                            
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="checkbox">
                                            <%
                                                if (iCommand == Command.LIST && lastCheck.equals("" + BiayaTransaksi.TIPE_BIAYA_UANG)) {
                                                    checked = "checked";
                                                } else if (iCommand == Command.NONE) {
                                                    if (jt2.getValueStandarTransaksi() != 0) {
                                                        checked = "checked";
                                                    }
                                                    if (jt2.getValueStandarTransaksi() == 0 && jt2.getProsentasePerhitungan() == 0) {
                                                        checked = "checked";
                                                    }
                                                }
                                            %>
                                            <label><input type="checkbox" <%=checked%> name="FORM_TIPE_BIAYA" data-row="<%=j%>" class="cek checkUang" id="uang<%=j%>" value="<%=BiayaTransaksi.TIPE_BIAYA_UANG%>">Rp</label>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <%
                                                checked = "";
                                                if (iCommand == Command.LIST && lastCheck.equals("" + BiayaTransaksi.TIPE_BIAYA_PERSENTASE)) {
                                                    checked = "checked";
                                                } else if (iCommand == Command.NONE) {
                                                    if (jt2.getProsentasePerhitungan() != 0) {
                                                        checked = "checked";
                                                    }
                                                }
                                            %>
                                            <label data-toggle="tooltip" title="Persentase dari jumlah pinjaman"><input type="checkbox" <%=checked%> name="FORM_TIPE_BIAYA" data-row="<%=j%>" class="cek checkPersen" id="persen<%=j%>" value="<%=BiayaTransaksi.TIPE_BIAYA_PERSENTASE%>">%</label>
                                        </div>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                                <div class="form-group" style="margin-bottom: 0px;">
                                    <div class="col-sm-10">
                                        <button type="submit" id="" class="btn btn-sm btn-success pull-right btn_hitung"><i class="fa fa-gear"></i> &nbsp; Hitung</button>
                                    </div>
                                    <div class="col-sm-10">
                                        <hr style="border-color: lightgray">
                                    </div>
                                </div>
                                <%
                                    }
                                %> 
                            </div>
                            
                            <div class="col-sm-6">              
                                <%if (error > 0) {%>
                                <h5 class="text-bold">Terdapat <%=error%> kesalahan :</h5>
                                <div><%=message%></div>
                                <%}%>
                                <%if (iCommand == Command.LIST && error == 0) {%>
                                <table class="tabel_simulasi">
                                    <tr><font>* Simulasi kredit dengan <label><%= jenisPengajuan[viewNet].toLowerCase() %></label> sebesar Rp </font><label class="money"><%= jumlahPinjaman %></label></tr>
                                    <tr>                                
                                        <td>Jenis Kredit</td>
                                        <td>:</td>
                                        <td><%=kredit.getNameKredit()%></td>
                                    </tr>
                                    <tr>
                                        <td>Jumlah pengajuan</td>
                                        <td>:</td>
                                        <td>Rp <a class="money text-black"><%=k.getPengajuanFinal()%></a></td>
                                    </tr>
                                    <tr>
                                        <td>Jangka Waktu</td>
                                        <td>:</td>
                                        <td><a class="text-black"><%=Formater.formatNumber(jangkaWaktu, "#")%></a> Bulan</td>
                                    </tr>
                                    <tr>
                                        <td>Suku Bunga</td>
                                        <td>:</td>
                                        <td><a class="money text-black"><%=sukuBunga%></a> % / Tahun</td>
                                    </tr>
                                    <tr>
                                        <td>Biaya Asuransi</td>
                                        <td>:</td>
                                        <td>Rp <a class="money text-black"><%=biayaAsuransi%></a></td>
                                    </tr>
                                    <tr>
                                        <td>Biaya Lain</td>
                                        <td>:</td>
                                        <td>Rp <a class="money text-black"><%=biayaLain%></a></td>
                                    </tr>
                                    <tr>
                                        <td style="vertical-align: text-top">Perhitungan biaya</td>
                                        <td style="vertical-align: text-top">:</td>
                                        <td>Jumlah pengajuan &nbsp; - &nbsp; ( biaya asuransi &nbsp; + &nbsp; biaya lain )
                                            <br>= &nbsp; <font class="money"><%=k.getPengajuanFinal()%></font> &nbsp; - &nbsp; ( <font class="money"><%=biayaAsuransi%></font> &nbsp; + &nbsp; <font class="money"><%=biayaLain%></font> )
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="fix-size-td">Jumlah uang diterima</td>
                                        <td>:</td>
                                        <td>Rp <font class="money"><%=k.getPengajuanFinal() - (biayaAsuransi + biayaLain)%></font></td>
                                    </tr>
                                    <tr>
                                        <%
                                            long longTotal = (long) (k.getPengajuanFinal() - (biayaAsuransi + biayaLain));
                                            ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                                            String con = convert.getText() + " rupiah.";
                                            String output = con.substring(0, 1).toUpperCase() + con.substring(1);
                                        %>
                                        <td style="vertical-align: text-top">Terbilang</td>
                                        <td style="vertical-align: text-top">:</td>
                                        <td><%=output%></td>
                                    </tr>
                                    <tr>
                                      <!--td colspan="3"><strong>Perhitungan Bunga <%=PstSumberDana.tipeBunga[tipeBunga]%></strong></td-->
                                        <td colspan="3"><strong>Rincian Angsuran :</strong></td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <table class="table table-bordered table-angsuran">
                                                <thead>
                                                    <tr>
                                                        <th colspan="<%=(monthly ? 3 : 4)%>">Angsuran</th>
                                                        <th rowspan="2">Besar<br>Angsuran</th>
                                                        <th rowspan="2">Sisa<br>Pinjaman Pokok</th>
                                                    </tr>
                                                    <tr>
                                                        <th>Ke</th>
                                                            <% if (!monthly) {%>
                                                        <th>Tgl</th>
                                                            <%}%>
                                                        <th>Pokok</th>
                                                        <th>Bunga</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        double totalPokok = 0;
                                                        double sisaPokok = jumlahPinjaman;
                                                        DecimalFormat df = new DecimalFormat("#.##");
                                                    %>
                                                    <% for (int i = 0; i < k.getTSize(); i++) {%>
                                                    <%
                                                        double pokok = k.getTPokok(i);
                                                        double bunga = k.getTBunga(i);
                                                        double totalAngsuran = k.getTAngsuranBesar(i);
                                                        if (pembulatan == 1) {
                                                            int roundValue = 500;
                                                            pokok = (Math.floor((k.getTPokok(i) + (roundValue - 1)) / roundValue)) * roundValue;
                                                            bunga = (Math.floor((k.getTBunga(i) + (roundValue - 1)) / roundValue)) * roundValue;
                                                            if ((totalPokok + pokok) > jumlahPinjaman) {
                                                                pokok = jumlahPinjaman - totalPokok;
                                                            }
                                                            totalPokok += pokok;
                                                            totalAngsuran = pokok + bunga;
                                                            sisaPokok -= pokok;
                                                        } else {
                                                            pokok = Double.valueOf(df.format(k.getTPokok(i)));
                                                            bunga = Double.valueOf(df.format(k.getTBunga(i)));
                                                            sisaPokok = Double.valueOf(df.format(k.getTTotalSisa(i)));
                                                        }
                                                    %>
                                                    <tr>
                                                        <td style="text-align:center;"><%=k.getTIndex(i)%></td>
                                                        <% if (!monthly) {%>
                                                        <td><%=k.getTDayName(i)[SESS_LANGUAGE].substring(0, 3)%>, <%=Formater.formatDate(k.getTDate(i), "dd-MM-yyyy")%></td>
                                                        <%}%>
                                                        <td class="money"><%=pokok%></td>
                                                        <td class="money"><%=bunga%></td>
                                                        <td class="money"><%=totalAngsuran%></td>
                                                        <td class="money"><%=sisaPokok%></td>
                                                        <%--
                                                        <td class="money"><%=k.getTPokok(i)%></td>
                                                        <td class="money"><%=k.getTBunga(i)%></td>
                                                        <td class="money"><%=k.getTAngsuranBesar(i)%></td>
                                                        <td class="money"><%=k.getTTotalSisa(i)%></td>
                                                        --%>
                                                    </tr>
                                                    <% } %>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <button type="button" class="btn btn-sm btn-primary" id="btn-print"><i class="fa fa-print"></i> &nbsp; Cetak</button>                    
                                            <button type="button" class="btn btn-sm btn-primary" id="btn-pengajuan"><i class="fa fa-file-text"></i> &nbsp; Buat Pengajuan</button>
                                        </td>
                                    </tr>
                                </table>


                                <%}%>
                            </div>
                            <%} else {%>
                            <div class="col-sm-6">
                                <label>Data Pengajuan :</label>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Jenis Kredit</label>
                                    <div class="col-sm-6">
                                        <%
                                            Vector listTypeKredit = PstTypeKredit.list(0, 0, "", "");
                                            Vector typeKreditKey = new Vector(1, 1);
                                            Vector typeKreditValue = new Vector(1, 1);
                                            for (int i = 0; i < listTypeKredit.size(); i++) {
                                                TypeKredit tk = (TypeKredit) listTypeKredit.get(i);
                                                typeKreditKey.add(tk.getNameKredit() + " [" + I_Sedana.TIPE_KREDIT.get(tk.getTipeFrekuensiPokokLegacy())[SESS_LANGUAGE] + "]");
                                                typeKreditValue.add("" + tk.getOID());
                                            }
                                        %>
                                        <%=ControlCombo.draw("FORM_JENIS_KREDIT", "form-control input-sm tipe_kredit", "- Pilih -", "" + jenisKredit, typeKreditValue, typeKreditKey, "required id='FORM_JENIS_KREDIT'")%> 
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Jangka Waktu</label>
                                    <div class="col-sm-6">
                                        <select required="" class="form-control input-sm" name="FORM_JANGKA_WAKTU" id="FORM_JANGKA_WAKTU">
                                            <%
                                                Vector listJangkaWaktu = PstJangkaWaktu.list(0, 0, "", PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU]);
                                                if (listJangkaWaktu.isEmpty()) {
                                                    out.print("<option value=''>Tidak ada jangka waktu</option>");
                                                }
                                                for (int i = 0; i < listJangkaWaktu.size(); i++) {
                                                    JangkaWaktu jw = (JangkaWaktu) listJangkaWaktu.get(i);
                                                    out.print("<option value='" + jw.getOID() + "'>" + jw.getJangkaWaktu()+ "</option>");
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Deposit</label>
                                    <div class="col-sm-6">
                                        <div class="input-group">
                                            <span class="input-group-addon">Rp</span>
                                            <input type="text" autocomplete="off" required="" class="form-control input-sm money" data-cast-class="valDP" id="dp" value="0">
                                            <input type="hidden" class="valDP" name="FORM_DOWN_PAYMENT" id="FORM_DOWN_PAYMENT" value="0">
                                        </div>
                                        <div style="margin-top: 10px">
                                            <button type="button" id="btn-tanpaDp" class="btn btn-success" value="0">Tanpa DP</button>
                                            <button type="button" id="btn-getDp" class="btn btn-success">DP</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Pilih Barang</label>
                                    <div class="col-sm-6">    
                                        <button type="button" id="btn-pilihbarang" class="btn btn-sm btn-success"><i class="fa fa-search"></i> &nbsp; Pilih</button>
                                    </div>
                                </div>
                                <div id="item-list" style="display: none">
                                    <label class="control-label col-sm-4">&nbsp;</label>
                                    <input type="hidden" id="totalPrice" value="0">
                                    <div class="col-sm-6">
                                        <table class="table table-bordered" id="table-item">
                                            <tr>
                                                <th>Barang</th>
                                                <th>Qty</th>
                                                <th>Total (Rp.)</th>
                                                <th>Aksi</th>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Jumlah Pengajuan</label>
                                    <div class="col-sm-6">
                                        <div class="input-group">
                                            <span class="input-group-addon">Rp</span>
                                            <input type="text" autocomplete="off" required="" class="form-control input-sm money" data-cast-class="valPengajuan" id="pengajuan" value="0">
                                            <input type="hidden" class="valPengajuan" name="FORM_JUMLAH_PINJAMAN" id="FORM_JUMLAH_PINJAMAN" value="0">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" style="display: none;">
                                    <label class="control-label col-sm-4"> Bunga <i style='color:red'>(m*</i></label>
                                    <div class="col-sm-8">          
                                        <div class="input-group">
                                            <span class="input-group-addon">Rp</span>
                                            <input type="text" autocomplete="off" required="" data-cast-class="valBunga" class="form-control input-sm money" name="" id="BUNGA" value="0">
                                            <input type="hidden" class="valBunga" name="FORM_JUMLAH_BUNGA" id="FORM_JUMLAH_BUNGA" value="0">
                                        </div>
                                    </div> 
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Tanggal Realisasi</label>
                                    <div class="col-sm-6">
                                        <input type="text" required="" autocomplete="off" class="form-control input-sm date-picker datePicker" name="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TGL_REALISASI]%>" id="<%=FrmPinjaman.fieldNames[FrmPinjaman.FRM_TGL_REALISASI]%>" value="<%=tglRealisasi%>">
                                    </div>
                                </div>
                                    <div class="col-sm-12">
                                        <hr style="border-color: lightgray">
                                    </div>
                            <label>Biaya Transport :</label>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Penjamin</label>
                                    <div class="col-sm-6">                                    
                                        <%
                                            Vector penjamin_key = new Vector();
                                            Vector penjamin_val = new Vector();
                                            Vector<AnggotaBadanUsaha> listPenjaminKredit = PstAnggotaBadanUsaha.listJoinContactClassPenjamin(0, 0, "", "");
                                            for (int i = 0; i < listPenjaminKredit.size(); i++) {
                                                penjamin_key.add("" + listPenjaminKredit.get(i).getOID());
                                                penjamin_val.add("" + listPenjaminKredit.get(i).getName());
                                            }
                                        %>
                                        <%= ControlCombo.draw("FORM_PENJAMIN", "form-control input-sm penjaminKreditPersentase", "- Pilih -", "" + penjaminId, penjamin_key, penjamin_val, "id='FORM_PENJAMIN'")%>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Persentase Penjamin</label>
                                    <div class="col-sm-6">
                                        <select class="form-control input-sm" id="coverage" name="FORM_COVERAGE">                                        
                                            <% if (iCommand == Command.LIST) {
                                            %>
                                            <option value="">- Pilih -</option>
                                            <%
                                                Vector listCoverage = PstPersentaseJaminan.list(0, 0, ""
                                                        + "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_ID_PENJAMIN] + " = '" + penjaminId + "'"
                                                        + " AND " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " = '" + textJangkaWaktu + "'"
                                                        + "", "");
                                                for (int i = 0; i < listCoverage.size(); i++) {
                                                    PersentaseJaminan pj = (PersentaseJaminan) listCoverage.get(i);
                                                    String selected = "";
                                                    if (pj.getOID() == persentaseId) {
                                                        selected = "selected";
                                                    }
                                            %>
                                            <option <%=selected%> data-persen="<%=pj.getPersentaseDijamin()%>" value="<%=pj.getOID()%>"><%=pj.getPersentaseCoverage()%> %</option>
                                            <%
                                                }
                                            } else {
                                            %>
                                            <option>Pilih penjamin terlebih dahulu</option>
                                            <%
                                                }
                                            %>                                        
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Persentase Dibayar</label>
                                    <div class="col-sm-6">
                                        <div class="input-group">
                                            <input type="text" id="showPersen" readonly="" class="form-control input-sm" data-cast-class="val_persen" value="<%=persentaseDijamin%>">
                                            <input type="hidden" class="val_persen" name="FORM_PERSENTASE_DIJAMIN" id="FORM_PERSENTASE_DIJAMIN" value="<%=persentaseDijamin%>">
                                            <span class="input-group-addon">%</span>
                                        </div>
                                    </div>
                                </div>
                                    <div class="col-sm-12">
                                        <hr style="border-color: lightgray">
                                    </div>
                                <%
                                    Vector listJenisTransaksi = PstJenisTransaksi.list(0, 0, ""
                                            + "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_UMUM + "'"
                                            + " GROUP BY " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC]
                                            + "", "");
                                    for (int i = 0; i < listJenisTransaksi.size(); i++) {
                                        JenisTransaksi jt = (JenisTransaksi) listJenisTransaksi.get(i);
                                %>
                                <label><%=JenisTransaksi.TIPE_DOC_TITLE[jt.getTipeDoc()]%> :</label>

                                <%
                                    Vector listChildJenisTransaksi = PstJenisTransaksi.list(0, 0, "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + jt.getTipeDoc() + "'", "");
                                    for (int j = 0; j < listChildJenisTransaksi.size(); j++) {
                                        JenisTransaksi jt2 = (JenisTransaksi) listChildJenisTransaksi.get(j);
                                        String lastValue = "";
                                        String lastCheck = "";
                                        String checked = "";
                                        if (iCommand == Command.LIST) {
                                            lastValue = nilaiBiaya[j];
                                            if (tipeBiaya != null) {
                                                lastCheck = tipeBiaya[j];
                                            }
                                        } else {
                                            if (jt2.getValueStandarTransaksi() != 0) {
                                                lastValue = "" + jt2.getValueStandarTransaksi();
                                            } else {
                                                lastValue = "" + jt2.getProsentasePerhitungan();
                                            }
                                        }
                                        
                                %>
                                <div class="form-group">
                                    <input type="hidden" id="jumlahBiaya" value="<%=listChildJenisTransaksi.size()%>">
                                    <label class="control-label col-sm-4"><%=jt2.getJenisTransaksi()%></label>
                                    <div class="col-sm-4">
                                        <input type="text" autocomplete="off" required="" id="showPersen" class="form-control input-sm money" data-cast-class="val_biaya" value="<%=lastValue%>">
                                        <input type="hidden" class="val_biaya FORM_NILAI_BIAYA" name="FORM_NILAI_BIAYA" id="FORM_NILAI_BIAYA" value="<%=lastValue%>">                                                                            
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="checkbox">
                                            <%
                                                if (iCommand == Command.LIST && lastCheck.equals("" + BiayaTransaksi.TIPE_BIAYA_UANG)) {
                                                    checked = "checked";
                                                } else if (iCommand == Command.NONE) {
                                                    if (jt2.getValueStandarTransaksi() != 0) {
                                                        checked = "checked";
                                                    }
                                                    if (jt2.getValueStandarTransaksi() == 0 && jt2.getProsentasePerhitungan() == 0) {
                                                        checked = "checked";
                                                    }
                                                }
                                            %>
                                            <label><input type="checkbox" <%=checked%> name="FORM_TIPE_BIAYA" data-row="<%=j%>" class="cek checkUang FORM_TIPE_BIAYA" id="uang<%=j%>" value="<%=BiayaTransaksi.TIPE_BIAYA_UANG%>">Rp</label>
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <%
                                                checked = "";
                                                if (iCommand == Command.LIST && lastCheck.equals("" + BiayaTransaksi.TIPE_BIAYA_PERSENTASE)) {
                                                    checked = "checked";
                                                } else if (iCommand == Command.NONE) {
                                                    if (jt2.getProsentasePerhitungan() != 0) {
                                                        checked = "checked";
                                                    }
                                                }
                                            %>
                                            <label data-toggle="tooltip" title="Persentase dari jumlah pinjaman"><input type="checkbox" <%=checked%> name="FORM_TIPE_BIAYA" data-row="<%=j%>" class="cek checkPersen FORM_TIPE_BIAYA" id="persen<%=j%>" value="<%=BiayaTransaksi.TIPE_BIAYA_PERSENTASE%>">%</label>
                                        </div>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                                <div class="form-group" style="margin-bottom: 0px;">
                                    <div class="col-sm-10">
                                        <button type="submit" id="" class="btn btn-sm btn-success pull-right btn_hitung_kredit"><i class="fa fa-gear"></i> &nbsp; Hitung</button>
                                    </div>
                                    <div class="col-sm-10">
                                        <hr style="border-color: lightgray">
                                    </div>
                                </div>
                                <%
                                    }
                                %> 
                            </div>
                            <div class="col-sm-6">
                              <div  id="dvAngsuran">
                            </div>
                              <div class='pull-left' id="btn-simulasi" style="display: none">
                            <button type='button' class='btn btn-sm btn-primary' id='btn-print-new'><i class="fa fa-print"></i> &nbsp; Cetak</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="hidden" name="<%= FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_SHIFT_ID]%>" id="FRM_FIELD_SHIFT_ID" value="<%=shiftCashierId %>">
                            <input type="hidden" name="<%= FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_CASH_CASHIER_ID]%>" id="FRM_FIELD_CASH_CASHIER_ID" value="<%=cashCashierId %>">
                            <input type="hidden" name="<%= FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_APP_USER_ID]%>" id="FRM_FIELD_APP_USER_ID" value="<%=userCashierId %>">
                            <input type="hidden" name="<%= FrmBillMain.fieldNames[FrmBillMain.FRM_FIELD_LOCATION_ID]%>" id="FRM_FIELD_LOCATION_ID" value="<%=locId %>">
                            <button type='button' class='btn btn-sm btn-primary' id='btn-pengajuan-new'><i class="fa fa-file-text"></i> &nbsp; Buat Pengajuan</button>
                            </div>
                            <div class="billMainForm">

                            </div>
                            </div>
                            <%} %>
                        </div>
                        <!--
                      <div class="box-footer" style="border-color: lightgray">
                        <div class="col-sm-12">
                          <button type="submit" id="btn_hitung" class="btn btn-sm btn-success pull-right"><i class="fa fa-gear"></i> &nbsp; Hitung</button>
                        </div>                        
                      </div>
                        -->
                    </form>
                </div>
            </section>
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
                                                    <th>Stok</th>
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
                                            <input type="hidden" name="material_stock" id="material_stock">
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
        <!--------------------------------------------------------------------->                
        <div id="printArea"></div>
    <% if (typeOfCredit.equals("0")) { %>
    <print-area>
        <table class="" style="font-size: 12px">
            <tr><font>* Simulasi kredit dengan <label>dana pengajuan</label> sebesar Rp </font><label class="money"><%=k.getPengajuanFinal()%></label></tr>
            <tr>                                
                <td>Jenis Kredit</td>
                <td>:</td>
                <td><%=kredit.getNameKredit()%></td>
            </tr>
            <tr>
                <td>Jumlah pengajuan</td>
                <td>:</td>
                <td>Rp <a class="money text-black"><%=k.getPengajuanFinal()%></a></td>
            </tr>
            <tr>
                <td>Jangka Waktu</td>
                <td>:</td>
                <td><a class="text-black"><%=Formater.formatNumber(jangkaWaktu, "#")%></a></td>
            </tr>
            <tr>
                <td>Suku Bunga</td>
                <td>:</td>
                <td><a class="money text-black"><%=sukuBunga%></a> % / Tahun</td>
            </tr>
            <tr>
                <td>Biaya Asuransi</td>
                <td>:</td>
                <td>Rp <a class="money text-black"><%=biayaAsuransi%></a></td>
            </tr>
            <tr>
                <td>Biaya Lain</td>
                <td>:</td>
                <td>Rp <a class="money text-black"><%=biayaLain%></a></td>
            </tr>
            <tr>
                <td style="vertical-align: text-top">Perhitungan biaya</td>
                <td style="vertical-align: text-top">:</td>
                <td>Jumlah pengajuan &nbsp; - &nbsp; ( biaya asuransi &nbsp; + &nbsp; biaya lain )
                    <br>= &nbsp; <font class="money"><%=k.getPengajuanFinal()%></font> &nbsp; - &nbsp; ( <font class="money"><%=biayaAsuransi%></font> &nbsp; + &nbsp; <font class="money"><%=biayaLain%></font> )
                </td>
            </tr>
            <tr>
                <td class="fix-size-td">Jumlah uang diterima</td>
                <td>:</td>
                <td>Rp <font class="money"><%=k.getPengajuanFinal() - (biayaAsuransi + biayaLain)%></font></td>
            </tr>
            <tr>
                <%
                    long longTotal = (long) (k.getPengajuanFinal() - (biayaAsuransi + biayaLain));
                    ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                    String con = convert.getText() + " rupiah.";
                    String output = con.substring(0, 1).toUpperCase() + con.substring(1);
                %>
                <td style="vertical-align: text-top">Terbilang</td>
                <td style="vertical-align: text-top">:</td>
                <td><%=output%></td>
            </tr>
            <tr>
                <!--td colspan="3"><strong>Perhitungan Bunga <%=PstSumberDana.tipeBunga[tipeBunga]%></strong></td-->
                <td colspan="3"><strong>Rincian Angsuran :</strong></td>
            </tr>
            <tr>
                <td colspan="3">
                    <table class="table table-bordered table-angsuran">
                        <thead>
                            <tr>
                                <th colspan="<%=(monthly ? 3 : 4)%>">Angsuran</th>
                                <th rowspan="2">Besar<br>Angsuran</th>
                                <th rowspan="2">Sisa<br>Pinjaman Pokok</th>
                            </tr>
                            <tr>
                                <th>ke</th>
                                    <% if (!monthly) {%>
                                <th>Tgl</th>
                                    <%}%>
                                <th>Pokok</th>
                                <th>Bunga</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                double totalPokok = 0;
                                double sisaPokok = jumlahPinjaman;
                                DecimalFormat df = new DecimalFormat("#.##");
                            %>
                            <% for (int i = 0; i < k.getTSize(); i++) {%>
                            <%
                                double pokok = k.getTPokok(i);
                                double bunga = k.getTBunga(i);
                                double totalAngsuran = k.getTAngsuranBesar(i);
                                if (pembulatan == 1) {
                                    int roundValue = 500;
                                    pokok = (Math.floor((k.getTPokok(i) + (roundValue - 1)) / roundValue)) * roundValue;
                                    bunga = (Math.floor((k.getTBunga(i) + (roundValue - 1)) / roundValue)) * roundValue;
                                    if ((totalPokok + pokok) > jumlahPinjaman) {
                                        pokok = jumlahPinjaman - totalPokok;
                                    }
                                    totalPokok += pokok;
                                    totalAngsuran = pokok + bunga;
                                    sisaPokok -= pokok;
                                } else {
                                    pokok = Double.valueOf(df.format(k.getTPokok(i)));
                                    bunga = Double.valueOf(df.format(k.getTBunga(i)));
                                    sisaPokok = Double.valueOf(df.format(k.getTTotalSisa(i)));
                                }
                            %>
                            <tr>
                                <td style="text-align:center;"><%=k.getTIndex(i)%></td>
                                <% if (!monthly) {%>
                                <td><%=k.getTDayName(i)[SESS_LANGUAGE].substring(0, 3)%>, <%=Formater.formatDate(k.getTDate(i), "dd-MM-yyyy")%></td>
                                <%}%>
                                <td class="money"><%=pokok%></td>
                                <td class="money"><%=bunga%></td>
                                <td class="money"><%=totalAngsuran%></td>
                                <td class="money"><%=sisaPokok%></td>
                                <%--
                                <td class="money"><%=k.getTPokok(i)%></td>
                                <td class="money"><%=k.getTBunga(i)%></td>
                                <td class="money"><%=k.getTAngsuranBesar(i)%></td>
                                <td class="money"><%=k.getTTotalSisa(i)%></td>
                                --%>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </td>
            </tr>
        </table>
    </print-area>
    <%}%>
</body>
</html>
