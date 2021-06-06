<%-- 
    Document   : transaksi_retur
    Created on : Jan 30, 2020, 8:33:12 PM
    Author     : WiraDharma
--%>

<%@page import="com.dimata.sedana.entity.kredit.PstReturnKreditItem"%>
<%@page import="com.dimata.sedana.entity.kredit.ReturnKreditItem"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.Angsuran"%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.session.SessKredit"%>
<%@page import="com.dimata.services.WebServices"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstTypeKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.pos.entity.billing.PstBillMain"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.pos.entity.billing.BillMain"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.kredit.PstReturnKredit"%>
<%@page import="com.dimata.posbo.entity.masterdata.PstMaterial"%>
<%@page import="com.dimata.posbo.entity.masterdata.Material"%>
<%@page import="com.dimata.pos.entity.billing.Billdetail"%>
<%@page import="com.dimata.pos.entity.billing.PstBillDetail"%>
<%@page import="com.dimata.sedana.entity.kredit.ReturnKredit"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.sedana.entity.kredit.AngsuranPayment"%>
<%@page import="com.dimata.common.entity.payment.PstPaymentSystem"%>
<%@page import="com.dimata.common.entity.payment.PaymentSystem"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %><% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_TRANSACTION, AppObjInfo.OBJ_RETURN_KREDIT);%>
<%@ include file = "../../main/checkuser.jsp" %>
<%
    /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
    boolean privView = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
    boolean privAdd = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
    boolean privUpdate = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
    boolean privDelete = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
    if (!privView && !privAdd && !privUpdate && !privDelete) {
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
<%
    long tellerShiftId = 0;
    double nilaiHpp = 0;
    double nilaiInventori = 0;
    long oidPinjaman = FRMQueryString.requestLong(request, "PINJAMAN_ID");
    long oidBillMain = FRMQueryString.requestLong(request, "BILL_MAIN_ID");
    long oidReturn = FRMQueryString.requestLong(request, "RETURN_KREDIT_ID");
    int iCommand = FRMQueryString.requestCommand(request);
    String nomorKredit = FRMQueryString.requestString(request, "nomor_kredit");

    ReturnKredit rk = new ReturnKredit();
    Pinjaman p = new Pinjaman();
    BillMain bm = new BillMain();
    ContactList con = new ContactList();
    Location loc = new Location();
    JenisKredit tk = new JenisKredit();

    if (userOID != 0) {
        Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_STATUS] + " = 2 AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
        if (open.size() < 1) {
            String redirectUrl = approot + "/open_cashier.jsp?redir=" + approot + "/sedana/transaksikredit/return_kredit.jsp";
            response.sendRedirect(redirectUrl);
        } else {
            tellerShiftId = open.get(0).getOID();
        }
    }
    System.out.println("Teller Id : " + tellerShiftId);
    try {
        if (oidReturn != 0) {
            rk = PstReturnKredit.fetchExc(oidReturn);
            loc = PstLocation.fetchExc(rk.getLocationTransaksi());
        }
        if (oidPinjaman != 0) {
            p = PstPinjaman.fetchExc(oidPinjaman);
            bm = PstBillMain.fetchExc(p.getBillMainId());
            con = PstContactList.fetchExc(p.getAnggotaId());
            tk = PstTypeKredit.fetchExc(p.getTipeKreditId());
        }

    } catch (Exception e) {
    }

    String Analis = "";
    String kolektor = "";
    String hrApiUrl = PstSystemProperty.getValueByName("HARISMA_URL");
    JSONArray jA = new JSONArray();

    String url = hrApiUrl + "/employee/employee-fetch/" + p.getAccountOfficerId();
    JSONObject jo = WebServices.getAPI("", url);
    if (jo.length() > 0) {

        Analis = jo.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "-");

    }

    String url1 = hrApiUrl + "/employee/employee-fetch/" + p.getCollectorId();
    JSONObject joo = WebServices.getAPI("", url1);
    if (joo.length() > 0) {

        kolektor = joo.optString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME], "-");

    }

    Date dateNow = new Date();
    String dateCheck = Formater.formatDate(dateNow, "yyyy-MM-dd");
    Date tglAwalTunggakanPokok = SessKredit.getTunggakanKredit(p.getOID(), dateCheck, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
    long hariPokok = 0;
    long hariBunga = 0;
    long tunggakan = 0;
    long diff = 0;
    if (tglAwalTunggakanPokok != null) {
        Date jatuhTempoAwal = tglAwalTunggakanPokok;
        Date now = Formater.formatDate(dateCheck, "yyyy-MM-dd");
        diff = now.getTime() - jatuhTempoAwal.getTime();
    }

    tunggakan = TimeUnit.MILLISECONDS.toDays(diff);
    long cbmOid = p.getBillMainId();
    try {
        bm = PstBillMain.fetchExc(cbmOid);
        long locationId = bm.getLocationId();
        loc = PstLocation.fetchExc(locationId);

    } catch (Exception e) {
    }

    String whereClause = PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_RETURN_ID] + " = " + oidReturn;
    Vector<ReturnKreditItem> listItem = PstReturnKreditItem.list(0, 0, whereClause, "");
    for (ReturnKreditItem bd : listItem) {
        nilaiHpp += bd.getNilaiHpp();
    }
        
    

    double angsuranBelumDibayar = 0;
    double sisaTunggakan = 0;
    int angsDp = 0;
    double DP = 0;
    String whereDp = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'"
            + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT;
    Vector listJadwalDp = PstJadwalAngsuran.list(0, 0, whereDp, "");
    for (int xx = 0; xx < listJadwalDp.size();xx++){
        JadwalAngsuran jad = (JadwalAngsuran) listJadwalDp.get(xx);
        DP += jad.getJumlahANgsuran();
        double totalAngsuran = PstAngsuran.getSumAngsuranDibayar(" jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + jad.getOID() + "'");
        double sisa = jad.getJumlahANgsuran() - totalAngsuran;
        if (sisa>0){
            angsuranBelumDibayar += sisa / totalAngsuran;
            sisaTunggakan += sisa;
        }
        angsDp++;
    }

    String whereAdd = PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'"
            + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_POKOK;
    Vector listJadwalPokok = PstJadwalAngsuran.list(0, 0, whereAdd, "");
    double nilaiAngsuran = 0;
    for (int xx = 0; xx < listJadwalPokok.size();xx++){
        JadwalAngsuran jad = (JadwalAngsuran) listJadwalPokok.get(xx);
        double totalAngsuran = 0;
        double newTotal = 0;
        String tglAngsuran = Formater.formatDate(jad.getTanggalAngsuran(), "yyyy-MM-dd");
        Vector<JadwalAngsuran> listAngsuran = PstJadwalAngsuran.getAngsuranWithBunga(jad.getPinjamanId(), tglAngsuran);
        for (JadwalAngsuran jada : listAngsuran) {
            totalAngsuran = PstAngsuran.getSumAngsuranDibayar(" jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + jada.getOID() + "'");
            nilaiAngsuran+= jada.getJumlahANgsuran();
            newTotal += totalAngsuran;
        }
        double jumlahAngsuran = PstJadwalAngsuran.getJumlahAngsuranWithBunga(jad.getPinjamanId(), tglAngsuran);
        double sisa = jumlahAngsuran - newTotal;
        if (sisa>0){
            angsuranBelumDibayar += sisa / jumlahAngsuran;
            sisaTunggakan += sisa;
        }
    }

    String status = "";
    if (rk.getStatus() == ReturnKredit.STATUS_RETURN_DRAFT) {
        status = "Draft";
    } else if (rk.getStatus() == ReturnKredit.DOCUMENT_STATUS_POSTED) {
        status = "Posted";
    } else if (rk.getStatus() == ReturnKredit.DOCUMENT_STATUS_CANCELLED) {
        status = "Cancel";
    } else if (rk.getStatus() == ReturnKredit.STATUS_RETURN_RETURN) {
        status = "Closed";
    } 

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../../style/style_kredit.jsp" %>
        <script language="javascript">

            $(document).ready(function () {
                jMoney('#BUNGA');
                jMoney('#POKOK');
                jMoney('#TOTAL_TUNGGAKAN');
                jMoney('#NILAI_HPP');
                jMoney('#NILAI_INVENTORI');
                jMoney('#TOTAL_KREDIT');
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

                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                    var tglPengembalian = $("#TGL_RETURN").val();
                    var jenisReturn = $("#RETURN_KREDIT").val();
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({
                        "bDestroy": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "oLanguage": {
                            "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Tunggu...</b></div></div></div>"
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FOR=" + dataFor + "&SEND_USER_ID=<%=userOID%>&TGL_RETURN="+tglPengembalian+"&JENIS_RETURN="+jenisReturn,
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
                            $('#tablePinjamanTableElement').find(".money").each(function () {
                                jMoney(this);
                            });

                            if (<%=nomorKredit.length()%> > 0) {
                                $('#tablePinjamanTableElement').find("a.btn-actionkredit").each(function () {
                                    var no = $(this).html();
                                    if (no == "<%=nomorKredit%>") {
                                        $(this).trigger('click');
                                    }
                                });
                            }
                        },
                        "fnPageChange": function (oSettings) {

                        }
                    });
                    $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                    $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                    $("#" + elementId).css("width", "100%");
                }

                function dataTablesOptionsSchedule(elementIdParent, elementId, servletName, dataFor, callBackDataTables, oid, jenis, idScheduleMulti) {
                    var datafilter = "";
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        "ordering": false,
                        "iDisplayLength": 10,
                        "bProcessing": true, "oLanguage": {
                            "sProcessing": "<div class='col-sm-12'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Tunggu...</b></div></div></div>"
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>"
                                + "&FRM_FIELD_OID=" + oid + "&FRM_JENIS_ANGSURAN=" + jenis + "&SEND_OID_MULTI=" + idScheduleMulti,
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
                            $('#tableJadwalTableElement').find(".money").each(function () {
                                jMoney(this);
                            });
                        },
                        "fnPageChange": function (oSettings) {

                        }
                    });
                    $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                    $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                    $("#" + elementId).css("width", "100%");
                }

                function runDataTable() {
                    dataTablesOptions("#pinjamanTableElement", "tablePinjamanTableElement", "AjaxKredit", "listSearchReturn", null);
                }

                $('#btn-searchkredit').click(function () {
                    var nomor = $('#NOMOR_KREDIT').val();
                    modalSetting('#modal-searchkredit', 'static', false, false);
                    $('#modal-searchkredit').modal('show');
                    runDataTable();
                    $('#modal-searchkredit input[type="search"]').val(nomor).keyup();
                });
                $('#back-btn').click(function () {
                    window.location = "../transaksikredit/list_return.jsp";
                });

                $(document).on("keydown", function (event) {
                    if (event.which === 8 && !$(event.target).is("input, textarea")) {
                        event.preventDefault();
                    }
                });

                if (<%=nomorKredit.length()%> > 0) {
                    $('#btn-searchkredit').trigger('click');
                }

                $('.date-picker').datetimepicker({
                    format: "yyyy-mm-dd hh:ii:ss",
                    weekStart: 1,
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2 // No time
                            // showMeridian: 0
                });

                $('body').on('click', '.btn-actionkredit', function () {
                    $('.btn-actionkredit').attr({"disabled": "true"});
                    var oid = $(this).data('oid');
                    $('#oid-kredit').val(oid);
                    var dataFor = "getDataKreditForReturn";
                    var command = "<%=Command.NONE%>";
                    var jenisReturn = $("#RETURN_KREDIT").val();
                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command,
                        "JENIS_RETURN" : jenisReturn
                    };
                    onDone = function (data) {
                        $.map(data.RETURN_DATA_KREDIT, function (item) {
                            $('#NOMOR_KREDIT').val(item.nomor_kredit);
                            $('#JENIS_KREDIT').val(item.jenis_kredit);
                            $('#NOMOR_NASABAH').val(item.nomor_nasabah);
                            $('#NAMA_NASABAH').val(item.nama_nasabah);
                            $('#ANALIS').val(item.analis);
                            $('#KOLEKTOR').val(item.kolektor);
                            $('#JUMLAH_TUNGGAKAN').val(item.tunggakan);
                            $('#LOCATION').val(item.location);
                            $('#CONTACT_ID').val(item.id_nasabah);
                            $('#TOTAL_TUNGGAKAN').val(item.sisaTunggakan);
                            $('#BILL_MAIN_ID').val(item.cbmOid);
                            $('#PINJAMAN_ID').val(item.pinjaman);
                            $('#SISA_WAKTU').val(item.sisaWaktu);
                            $('#NILAI_INVENTORI').val(item.nilaiInventori);
                            $('#TOTAL_KREDIT').val(item.nilaiPinjaman);
                            $('#DP').val(item.DP);
                            $('#JANGKA_WAKTU').val(item.jangkaWaktu);
                            $('#LIST_ITEM').html(data.RETURN_HTML_BIAYA_KREDIT);
                            $('#LIST_ITEM').find('.money').each(function () {
                                jMoney(this);
                            });
                            jMoney('#BUNGA');
                            jMoney('#POKOK');
                            jMoney('#TOTAL_TUNGGAKAN');
                            jMoney('#NILAI_HPP');
                            jMoney('#TOTAL_KREDIT');
                            jMoney('#NILAI_INVENTORI');
                            jMoney('#DP');

                        });
                    };
                    onSuccess = function (data) {
                        $('#modal-searchkredit').modal('hide');
                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    return false;
                });

                $('#btn-savereturn').click(function () {
                    let oid = $('#PINJAMAN_ID').val();
                    let catatan = $('#CATATAN').val();

                    if (oid == 0) {
                        alert("Please choose data first!")
                        $('#btn-searchkredit').trigger('click');
                    } else if (catatan == "" || catatan == " " || catatan == "." || catatan == "-") {
                        alert("Mohon mengisi catatan sebelum return kredit!")
                        $('#CATATAN').trigger('click');
                    } else if (oid != 0) {
                        if (confirm("Are you sure want to return this loan?")) {
                            $('#form-return').submit();
                        }
                    }

                });

                $('#form-return').submit(function () {
                    var buttonName = $('#btn-savereturn').html();
                    $('#btn-savereturn').attr({"disabled": "true"}).html("Tunggu...");
                    let oid = "<%=oidPinjaman%>";
                    let approot = "<%=approot%>";
                    let command = "<%=Command.SAVE%>";
                    let dataFor = "saveKreditReturn";

                    onDone = function (data) {
                        if (data.RETURN_ERROR_CODE == "0") {
                            var pinjamanId = data.RESULT_PINJAMAN_ID;
                            var returnId = data.RESULT_RETURN_ID;
                            alert("Data return berhasil disimpan");
                            window.location = "../transaksikredit/return_kredit.jsp?command=<%= Command.EDIT %>&PINJAMAN_ID=" + pinjamanId + "&RETURN_KREDIT_ID=" + returnId;
                        } else {
                            alert(data.RETURN_MESSAGE);
                        }
                    };
                    onSuccess = function (data) {
                        $('#btn-savereturn').removeAttr('disabled').html(buttonName);
                    };
                    var data = $(this).serialize();
                    var dataSend = "" + data + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command + "&FRM_FIELD_OID=" + oid + "&SEND_OID_TELLER_SHIFT=" + "<%=tellerShiftId%>";
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    return false;
                });

                $('body').on('click', '.show-dokumen', function () {
                    var oid = $(this).data('oid');
                    var type = $(this).data('type');
                    window.open("<%=approot%>/masterdata/masterdokumen/dokumen_edit.jsp?oid_pinjaman=" + oid + "&type=" + type, '_blank', 'location=yes,height=650,width=1000,scrollbars=yes,status=yes');
                });
            });
        </script>
    </head>
    <body  style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
                Pengembalian Barang
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Return Transaksi</li>
                <li class="active">Kredit</li>
            </ol>
        </section>
        <section class="content">

            <div class="box box-success">
                <div class="box-header with-border border-gray">
                    <h3 class="box-title">Form Pengembalian Barang</h3>
                </div>
                <div class="box-body">
                    <form id="form-return" class="form-horizontal">
                        <input type="hidden" name="PINJAMAN_ID" id="PINJAMAN_ID" value="<%=oidPinjaman%>">
                        <input type="hidden" name="BILL_MAIN_ID" id="BILL_MAIN_ID" value="<%=oidBillMain%>">
                        <input type="hidden" name="USER_LOCATION_ID" id="USER_LOCATION_ID" value="<%= userLocationId %>">
                        <input type="hidden" name="RETURN_KREDIT_ID" id="RETURN_KREDIT_ID" value="<%=oidReturn%>">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="col-md-7">
                                    <div class="form-group">
                                        <label class="col-md-4">Nomor</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" placeholder="-- Otomatis Dibuat Apabila Kosong  --" name="DOKUMEN_NUMBER" id="DOKUMEN_NUMBER" value="<%=rk.getNomorReturn()%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Jenis Pengembalian</label>
                                        <div class="col-md-8">
                                            <% if (rk.getStatus() == ReturnKredit.STATUS_RETURN_DRAFT) {%>
                                            <select class="form-control input-sm select2"
                                                    name="RETURN_KREDIT" id="RETURN_KREDIT">
                                                <option value="<%= ReturnKredit.JENIS_RETURN_CABUTAN %>" <%= rk.getJenisReturn() == ReturnKredit.JENIS_RETURN_CABUTAN ? "selected" : "" %>>
                                                    <%= ReturnKredit.JENIS_RETURN_TITLE[ReturnKredit.JENIS_RETURN_CABUTAN] %>
                                                </option>
                                                <option value="<%= ReturnKredit.JENIS_RETURN_EXCHANGE %>" <%= rk.getJenisReturn() == ReturnKredit.JENIS_RETURN_EXCHANGE ? "selected" : "" %>>
                                                    <%= ReturnKredit.JENIS_RETURN_TITLE[ReturnKredit.JENIS_RETURN_EXCHANGE] %>
                                                </option>
                                            </select>
                                            <% } else { %>
                                            <input type="text" class="form-control" readonly=""
                                                   value="<%= ReturnKredit.JENIS_RETURN_TITLE[rk.getJenisReturn()] %>">
                                            <% } %>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Nomor Kredit</label>
                                        <div class="col-sm-8">
                                            <div class="input-group">
                                                <input type="text" autocomplete="off" required="" readonly="" class="form-control input-sm" name="NOMOR_KREDIT" id="NOMOR_KREDIT" value="<%=p.getNoKredit()%>">
                                                <span class="input-group-addon btn btn-primary" id="btn-searchkredit">
                                                    <i class="fa fa-search"></i>
                                                </span>
                                            </div>
                                            <input type="hidden" id="oid-kredit" value="" name="PINJAMAN_ID">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Nama <%=namaNasabah%></label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" name="NAMA_NASABAH" id="NAMA_NASABAH" value="<%=con.getPersonName()%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Tanggal</label>
                                        <div class="col-md-8">
                                            <%if (oidReturn != 0) {%>
                                            <input type="text" id="TGL_RETURN" style="font-weight: bold; color: red" class="form-control input-sm date-picker" value="<%=rk.getTanggalReturn()%>" name="TGL_RETURN">
                                            <%} else {%>
                                            <input type="text" id="TGL_RETURN" style="font-weight: bold; color: red" class="form-control input-sm date-picker" value="<%= Formater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss")%>" name="TGL_RETURN">
                                            <%}%>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Lokasi Transaksi</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" name="LOCATION" id="LOCATION" value="<%=loc.getName()%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Jenis Kredit</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" name="JENIS_KREDIT" id="JENIS_KREDIT"  value="<%=tk.getNameKredit()%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Status</label>
                                        <div class="col-md-8">
                                            <%if (rk.getOID()==0) {%>
                                            <select class="form-control input-sm select2" name="STATUS" id="STATUS">
                                                <option value="<%=ReturnKredit.STATUS_RETURN_DRAFT%>" ><%=ReturnKredit.returnStatusKey[0]%></option>
                                                %>
                                            </select>
                                            <%} else if (rk.getStatus() == ReturnKredit.STATUS_RETURN_DRAFT) {%>
                                            <select class="form-control input-sm select2" name="STATUS" id="STATUS">
                                                <%

                                                    for (int i = 0; i < ReturnKredit.returnStatusKey.length; i++) {
                                                        long oidStatus = Long.parseLong(ReturnKredit.returnStatusValue[i]);
                                                        String selected = "";
                                                        if (oidStatus == rk.getStatus()) {
                                                            selected = "selected";
                                                        }
                                                        if (ReturnKredit.returnStatusKey[i].equals("Posted")){
                                                            continue;
                                                        }
                                                %>
                                                <option value="<%=ReturnKredit.returnStatusValue[i]%>" <%=selected%>><%=ReturnKredit.returnStatusKey[i]%></option>
                                                <%}
                                                %>
                                            </select>
                                            <%} else {%>
                                            <input type="text" class="form-control" readonly="" name="STATUS"  value="<%=status%>">
                                            <%}%>
                                        </div>
                                    </div>
                                </div>    

                                <div class="col-md-5">
                                    <div class="form-group">
                                        <label class="col-md-4">Nama Analis</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="Analis" name="ANALIS" id="ANALIS" value="<%=Analis%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Nama Kolektor</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="Kolektor" name="KOLEKTOR" id="KOLEKTOR" value="<%=kolektor%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">DP</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="DP" id="DP" value="<%=DP%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Total Kredit</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="TOTAL_KREDIT" id="TOTAL_KREDIT" value="<%=nilaiAngsuran%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Jangka Waktu + DP</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="JANGKA_WAKTU" id="JANGKA_WAKTU" value="<%= p.getJangkaWaktu() %>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Sisa Saldo</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="TOTAL_TUNGGAKAN" id="TOTAL_TUNGGAKAN" value="<%=sisaTunggakan%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Sisa Jangka Waktu</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="SISA_WAKTU" id="SISA_WAKTU" value="<%= String.format("%,.2f", angsuranBelumDibayar) %>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Catatan</label>
                                        <div class="col-md-8">
                                            <textarea class="form-control" placeholder="..." name="CATATAN" id="CATATAN"><%=rk.getCatatan()%></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr class="border-gray">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="col-md-12">
                                    <div id="LIST_ITEM"></div>
                                    <%if (iCommand == Command.EDIT) {%>
                                    <h4>Daftar Barang</h4>
                                    <div id="returnItem">
                                        <table id="returnList" class="table table-bordered table-striped table-responsive">
                                            <thead>
                                                <tr>
                                                    <th style="width: 5%"> No </th>
                                                    <th style="width: 10%"> SKU </th>
                                                    <th style="width: 20%"> Nama Barang </th>
                                                    <th style="width: 10%"> Nilai HPP </th>
                                                    <th style="width: 10%"> Nilai Persediaan </th>
                                                    <th style="width: 10%"> Qty </th>
                                                    <% if (rk.getJenisReturn() == ReturnKredit.JENIS_RETURN_CABUTAN){ %>
                                                        <th style="width: 10%"> SKU Baru</th>
                                                        <th style="width: 30%"> Nama Barang Baru</th>
                                                    <% } %>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    if(!listItem.isEmpty()){
                                                    int start = 0;
                                                    for (ReturnKreditItem bd : listItem) {
                                                        String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
                                                        String urlMat = posApiUrl + "/material/material-credit/" + bd.getMaterialId();
                                                        JSONObject jos = WebServices.getAPI("", urlMat);
                                                        
                                                        Billdetail billDet = new Billdetail();
                                                        try {
                                                        billDet = PstBillDetail.fetchExc(bd.getCashBillDetailId());
                                                        } catch (Exception exc){}
                                                        start++;
                                                %>
                                                <tr>
                                                    <td class="text-center"><%=start%>
                                                        <input type='hidden' name='OID_<%=bd.getCashBillDetailId()%>' value='<%=bd.getOID()%>' class='form-control'>
                                                        <input type='hidden' name='OID_DETAIL' value='<%=bd.getCashBillDetailId()%>' class='form-control'>
                                                        <input type='hidden' name='MATERIAL_ID_<%=bd.getCashBillDetailId()%>' value='<%=bd.getMaterialId()%>' class='form-control'>
                                                        <input type='hidden' name='HPP_<%=bd.getCashBillDetailId()%>' value='<%=bd.getNilaiHpp()%>' class='form-control'>
                                                        <input type='hidden' name='QTY_<%=bd.getCashBillDetailId()%>' value='<%=bd.getQty()%>' class='form-control'>
                                                    </td>
                                                    <td class="text-center"><%=billDet.getSku()%></td>
                                                    <td class="text-center"><%=billDet.getItemName()%></td>
                                                    <td class="money text-center"><%=bd.getNilaiHpp()%></td>
                                                    <% if (rk.getJenisReturn() == ReturnKredit.JENIS_RETURN_CABUTAN){ %>
                                                        <td>
                                                            <input type='text'  value='<%=bd.getNilaiPersediaan()%>' class='form-control money' data-cast-class='persediaan<%=bd.getCashBillDetailId()%>' <%=rk.getStatus() == ReturnKredit.STATUS_RETURN_RETURN ? "readonly" : ""%>>
                                                            <input type='hidden' name='PERSEDIAAN_<%=bd.getCashBillDetailId()%>' value='<%=bd.getNilaiPersediaan()%>' class='persediaan<%=bd.getCashBillDetailId()%>'>
                                                        </td>
                                                    <% } else { %>
                                                    <td class="text-center"><a class='money'><%=bd.getNilaiPersediaan()%></a><input type='hidden' name='PERSEDIAAN_<%=bd.getCashBillDetailId()%>' value='<%=bd.getNilaiPersediaan()%>' class='form-control'></td>
                                                    <% } %>
                                                    <td class="text-center"><%=bd.getQty()%></td>
                                                    <% if (rk.getJenisReturn() == ReturnKredit.JENIS_RETURN_CABUTAN){ %>
                                                        <td><input type='text' name='NEW_SKU_<%=bd.getCashBillDetailId()%>' value='<%=bd.getNewSku()%>' class='form-control' <%=rk.getStatus() == ReturnKredit.STATUS_RETURN_RETURN ? "readonly" : ""%>></td>
                                                        <td><input type='text' name='NEW_NAME_<%=bd.getCashBillDetailId()%>' value='<%=bd.getNewMaterialName()%>' class='form-control' <%=rk.getStatus() == ReturnKredit.STATUS_RETURN_RETURN ? "readonly" : ""%>></td>
                                                    <% } %>
                                                </tr>
                                                <%  }
                                                  } else {
                                                    out.println("<td class='text-center' colspan='4'>Barang Tidak ada.</td>");
                                                  }
                                                %>
                                            </tbody>
                                        </table>
                                    </div>
                                    <%}%>
                                </div>
                                <div class="col-md-3">
                                    <%
                                        if (rk.getStatus() == ReturnKredit.STATUS_RETURN_RETURN && rk.getJenisReturn() == ReturnKredit.JENIS_RETURN_CABUTAN) {
                                    %>
                                    <h4>Dokumen</h4>
                                    <button type="button" id="dokumen-return"
                                            class="btn btn-primary btn-dokumen show-dokumen" data-oid="<%= p.getOID()%>"
                                            data-type="SRK" style="width: 195px;margin-bottom: 10px;">
                                        <i class="fa fa-file"> </i> Dokumen Return
                                    </button>
                                    <%}%>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="box-footer">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="pull-right">
                                <% if (rk.getStatus() == ReturnKredit.STATUS_RETURN_DRAFT) { %>
                                <button form="form-return" type="button" id="btn-savereturn" class="btn btn-success">
                                    <i class="fa fa-save"></i> Simpan
                                </button>
                                <% } %>
                                <button type="button" id="back-btn" class="btn btn-default">
                                    <i class="fa fa-refresh"></i> Kembali
                                </button>
                            </div>
                        </div>
                    </div>			
                </div>
            </div>
        </section>


        <!----------------------------MODAL---------------------------->

        <div id="modal-searchkredit" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Data Kredit</h4>
                    </div>

                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-12">
                                <div id="pinjamanTableElement">
                                    <table class="table" style="font-size: 14px">
                                        <thead>
                                            <tr>
                                                <th class="aksi">No.</th>
                                                <th>Nomor Kredit</th>
                                                <th>Nama <%=namaNasabah%></th>
                                                <th>Jenis Kredit</th>
                                                <th>Jumlah Pinjaman</th>
                                                <th>Lokasi</th>
                                                <th>Tanggal Pengajuan</th>
                                                <th>Tanggal Realisasi</th>
                                                <th class="aksi">Aksi</th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                    </div>

                </div>
            </div>
        </div>

    </body>
</html>



