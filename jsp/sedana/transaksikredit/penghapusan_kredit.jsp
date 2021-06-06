<%-- 
    Document   : penghapusan_kredit
    Created on : 03 Sep 20, 10:08:55
    Author     : gndiw
--%>

<%@page import="com.dimata.pos.entity.billing.PstBillDetail"%>
<%@page import="com.dimata.pos.entity.billing.Billdetail"%>
<%@page import="com.dimata.sedana.entity.kredit.PstHapusKreditItem"%>
<%@page import="com.dimata.sedana.entity.kredit.HapusKreditItem"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.services.WebServices"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.dimata.sedana.entity.kredit.PstTypeKredit"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.pos.entity.billing.PstBillMain"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.sedana.entity.kredit.PstHapusKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.pos.entity.billing.BillMain"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.HapusKredit"%>
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
    long oidPinjaman = FRMQueryString.requestLong(request, "PINJAMAN_ID");
    long oidBillMain = FRMQueryString.requestLong(request, "BILL_MAIN_ID");
    long oidHapus = FRMQueryString.requestLong(request, "HAPUS_KREDIT_ID");
    int iCommand = FRMQueryString.requestCommand(request);
    String nomorKredit = FRMQueryString.requestString(request, "nomor_kredit");
    
    HapusKredit hk = new HapusKredit();
    Pinjaman p = new Pinjaman();
    BillMain bm = new BillMain();
    ContactList con = new ContactList();
    Location loc = new Location();
    JenisKredit tk = new JenisKredit();
    
    try {
        if (oidHapus != 0) {
            hk = PstHapusKredit.fetchExc(oidHapus);
            loc = PstLocation.fetchExc(hk.getLocationTransaksi());
        }
        if (oidPinjaman != 0) {
            p = PstPinjaman.fetchExc(oidPinjaman);
            bm = PstBillMain.fetchExc(p.getBillMainId());
            con = PstContactList.fetchExc(p.getAnggotaId());
            tk = PstTypeKredit.fetchExc(p.getTipeKreditId());
        }

    } catch (Exception e) {
    }

    String whereClause = PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + " = " + bm.getOID();
    Vector<Billdetail> listItem = PstBillDetail.list(0, 0, whereClause, "");
    
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

    double jumlahDP = PstJadwalAngsuran.sumJadwalAngsuran(oidPinjaman, ""+JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT);
    double jumlahPokok = PstJadwalAngsuran.sumJadwalAngsuran(oidPinjaman, ""+JadwalAngsuran.TIPE_ANGSURAN_POKOK);
    double jumlahPokokDibayar = PstJadwalAngsuran.sumJadwalAngsuranDibayar(oidPinjaman, ""+JadwalAngsuran.TIPE_ANGSURAN_POKOK);
    double jumlahBunga = PstJadwalAngsuran.sumJadwalAngsuran(oidPinjaman, ""+JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
    double jumlahBungaDibayar = PstJadwalAngsuran.sumJadwalAngsuranDibayar(oidPinjaman, ""+JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
    int jangkaWaktuDibayar = PstJadwalAngsuran.countAngsuranDibayar(oidPinjaman);
    int addDp = 0;
    if (jumlahDP >0){
        addDp = 1;
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../../style/style_kredit.jsp" %>
        <script language="javascript">
            $(document).ready(function () {
                
                jMoney('#TOTAL_POKOK');
                jMoney('#TOTAL_BUNGA');
                jMoney('#TOTAL_KREDIT');
                jMoney('#TOTAL_DIBAYAR');
                jMoney('#SISA_SALDO');
                jMoney('#DP');
                
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
                
                $('#btn-searchkredit').click(function () {
                    var nomor = $('#NOMOR_KREDIT').val();
                    modalSetting('#modal-searchkredit', 'static', false, false);
                    $('#modal-searchkredit').modal('show');
                    runDataTable();
                    $('#modal-searchkredit input[type="search"]').val(nomor).keyup();
                });
                
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
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FOR=" + dataFor + "&SEND_USER_ID=<%=userOID%>&TGL_RETURN="+tglPengembalian+"&SEARCH_HAPUS=true",
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
                
                function runDataTable() {
                    dataTablesOptions("#pinjamanTableElement", "tablePinjamanTableElement", "AjaxKredit", "listSearchKredit", null);
                }
                
                $('body').on('click', '.btn-actionkredit', function () {
                    $('.btn-actionkredit').attr({"disabled": "true"});
                    var oid = $(this).data('oid');
                    $('#oid-kredit').val(oid);
                    var dataFor = "getDataKreditForHapus";
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
                            $('#LOCATION').val(item.location);
                            $('#CONTACT_ID').val(item.id_nasabah);
                            $('#BILL_MAIN_ID').val(item.cbmOid);
                            $('#PINJAMAN_ID').val(item.pinjaman);
                            $('#DP').val(item.DP);
                            $('#TOTAL_POKOK').val(item.pokok);
                            $('#TOTAL_BUNGA').val(item.bunga);
                            $('#TOTAL_KREDIT').val(item.nilaiAngsuran);
                            $('#JANGKA_WAKTU').val(item.jangkaWaktu);
                            $('#TOTAL_DIBAYAR').val(item.dibayar);
                            $('#SISA_WAKTU').val(item.sisaWaktu);
                            $('#SISA_SALDO').val(item.saldo);
                            $('#SISA_POKOK').val(item.sisaPokok);
                            $('#SISA_BUNGA').val(item.sisaBunga);
                            $('#LIST_ITEM').html(data.RETURN_HTML_BIAYA_KREDIT);
                            $('#LIST_ITEM').find('.money').each(function () {
                                jMoney(this);
                            });
                            jMoney('#TOTAL_POKOK');
                            jMoney('#TOTAL_BUNGA');
                            jMoney('#TOTAL_KREDIT');
                            jMoney('#TOTAL_DIBAYAR');
                            jMoney('#SISA_SALDO');
                            jMoney('#DP');

                        });
                    };
                    onSuccess = function (data) {
                        $('#modal-searchkredit').modal('hide');
                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    return false;
                });
                
                $('#back-btn').click(function () {
                    window.location = "../transaksikredit/list_penghapusan_kredit.jsp";

                });
                
                $('#btn-save').click(function () {
                    let oid = $('#PINJAMAN_ID').val();
                    let catatan = $('#CATATAN').val();
                    let status = $('#STATUS').val();
                    
                    if (status == <%=I_DocStatus.DOCUMENT_STATUS_CLOSED%>){
                        if (confirm("Close Dokumen?")) {
                            $('#form-hapus').submit();
                        }
                    } else {

                        if (oid == 0) {
                            alert("Please choose data first!")
                            $('#btn-searchkredit').trigger('click');
                        } else if (catatan == "" || catatan == " " || catatan == "." || catatan == "-") {
                            alert("Mohon mengisi catatan!")
                            $('#CATATAN').trigger('click');
                        } else if (oid != 0) {
                            if (confirm("Simpan?")) {
                                $('#form-hapus').submit();
                            }
                        }
                    }

                });
                
                $('#btn-delete').click(function () {
                    if (confirm("Hapus Dokumen?")) {
                        let oid = $('#HAPUS_KREDIT_ID').val();
                        $('#btn-delete').attr({"disabled": "true"}).html("Menghapus...");
                        let command = "<%=Command.DELETE%>";
                        let dataFor = "deleteKreditHapus";
                        onDone = function (data) {
                            if (data.RETURN_ERROR_CODE == "0") {
                                alert("Dokumen telah dihapus");
                                window.location = "../transaksikredit/list_penghapusan_kredit.jsp";
                            } else {
                                alert(data.RETURN_MESSAGE);
                            }
                        };
                        onSuccess = function (data) {
                            //$('#btn-save').removeAttr('disabled').html(buttonName);
                        };
                        var data = $(this).serialize();
                        var dataSend = "" + data + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command + "&FRM_FIELD_OID=" + oid;
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    }
                });
                
                $('#form-hapus').submit(function () {
                    var buttonName = $('#btn-save').html();
                    $('#btn-save').attr({"disabled": "true"}).html("Tunggu...");
                    let oid = "<%=oidPinjaman%>";
                    let approot = "<%=approot%>";
                    let command = "<%=Command.SAVE%>";
                    let dataFor = "saveKreditHapus";

                    onDone = function (data) {
                        if (data.RETURN_ERROR_CODE == "0") {
                            var pinjamanId = data.RESULT_PINJAMAN_ID;
                            var hapusId = data.RESULT_HAPUS_ID;
                            alert("Data berhasil disimpan");
                            window.location = "../transaksikredit/penghapusan_kredit.jsp?command=<%= Command.EDIT %>&PINJAMAN_ID=" + pinjamanId + "&HAPUS_KREDIT_ID=" + hapusId;
                        } else {
                            alert(data.RETURN_MESSAGE);
                        }
                    };
                    onSuccess = function (data) {
                        $('#btn-save').removeAttr('disabled').html(buttonName);
                    };
                    var data = $(this).serialize();
                    var dataSend = "" + data + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command + "&FRM_FIELD_OID=" + oid;
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    return false;
                });
                
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
                
            });
            
        </script>
    </head>
    <body  style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
                Penghapusan Kredit
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Transaksi</li>
                <li class="active">Penghapusan Kredit</li>
            </ol>
        </section>
        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border border-gray">
                    <h3 class="box-title">Form Penghapusan Kredit</h3>
                </div>
                <div class="box-body">
                    <form id="form-hapus" class="form-horizontal">
                        <input type="hidden" name="PINJAMAN_ID" id="PINJAMAN_ID" value="<%=oidPinjaman%>">
                        <input type="hidden" name="BILL_MAIN_ID" id="BILL_MAIN_ID" value="<%=bm.getOID()%>">
                        <input type="hidden" name="USER_LOCATION_ID" id="USER_LOCATION_ID" value="<%= userLocationId %>">
                        <input type="hidden" name="HAPUS_KREDIT_ID" id="HAPUS_KREDIT_ID" value="<%=oidHapus%>">
                        <input type="hidden" name="SISA_POKOK" id="SISA_POKOK" value="<%=(jumlahPokok-jumlahPokokDibayar)%>">
                        <input type="hidden" name="SISA_BUNGA" id="SISA_BUNGA" value="<%=(jumlahBunga-jumlahBungaDibayar)%>">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="col-md-4">Nomor</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" placeholder="-- Otomatis Dibuat Apabila Kosong  --" name="DOKUMEN_NUMBER" id="DOKUMEN_NUMBER" value="<%=hk.getNomorHapus()%>">
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
                                            <%if (oidHapus != 0) {%>
                                            <input type="text" id="TGL_HAPUS" style="font-weight: bold; color: red" class="form-control input-sm date-picker" value="<%=hk.getTanggalHapus()%>" name="TGL_HAPUS">
                                            <%} else {%>
                                            <input type="text" id="TGL_HAPUS" style="font-weight: bold; color: red" class="form-control input-sm date-picker" value="<%= Formater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss")%>" name="TGL_HAPUS">
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
                                            <%if (hk.getOID()==0) {%>
                                            <select class="form-control input-sm select2" name="STATUS" id="STATUS">
                                                <option value="<%=I_DocStatus.DOCUMENT_STATUS_DRAFT%>" ><%=I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_DRAFT]%></option>
                                                %>
                                            </select>
                                            <%} else if (hk.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT) {%>
                                            <select class="form-control input-sm select2" name="STATUS" id="STATUS">
                                                <option value="<%=I_DocStatus.DOCUMENT_STATUS_DRAFT%>"><%=I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_DRAFT]%></option>
                                                <option value="<%=I_DocStatus.DOCUMENT_STATUS_CLOSED%>"><%=I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_CLOSED]%></option>
                                            </select>
                                            <%} else {%>
                                            <input type="hidden" name="STATUS" value="<%=hk.getStatus()%>">
                                            <input type="text" class="form-control" readonly=""  value="<%=I_DocStatus.fieldDocumentStatus[hk.getStatus()]%>">
                                            <%}%>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Catatan</label>
                                        <div class="col-md-8">
                                            <textarea class="form-control" placeholder="..." name="CATATAN" id="CATATAN"><%=hk.getCatatan()%></textarea>
                                        </div>
                                    </div>
                                </div>
                                        
                                <div class="col-md-6">
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
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="DP" id="DP" value="<%=jumlahDP%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Total Pokok</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="TOTAL_POKOK" id="TOTAL_POKOK" value="<%=jumlahPokok%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Total Bunga</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="TOTAL_BUNGA" id="TOTAL_BUNGA" value="<%=jumlahBunga%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Total Kredit</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="TOTAL_KREDIT" id="TOTAL_KREDIT" value="<%=jumlahPokok+jumlahBunga%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Jangka Waktu + DP</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="JANGKA_WAKTU" id="JANGKA_WAKTU" value="<%= p.getJangkaWaktu()+ addDp %>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Total Dibayar</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="TOTAL_DIBAYAR" id="TOTAL_DIBAYAR" value="<%=jumlahPokokDibayar+jumlahBungaDibayar+jumlahDP%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Sisa Saldo</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="SISA_SALDO" id="SISA_SALDO" value="<%=((jumlahBunga+jumlahPokok) - (jumlahBungaDibayar+jumlahPokokDibayar))%>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4">Sisa Jangka Waktu</label>
                                        <div class="col-md-8">
                                            <input type="text" class="form-control" readonly="" placeholder="0" name="SISA_WAKTU" id="SISA_WAKTU" value="<%= (p.getJangkaWaktu() + addDp - jangkaWaktuDibayar) %>">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr class="border-gray">
                        <div class="row">
                            <div class="col-md-12">
                                <div id="LIST_ITEM"></div>
                                <%if (iCommand == Command.EDIT) {%>
                                    <div id="item">
                                        <table id="itemList" class="table table-bordered table-striped table-responsive">
                                            <thead>
                                                <tr>
                                                    <th style="width: 5%"> No </th>
                                                    <th style="width: 10%"> SKU </th>
                                                    <th style="width: 20%"> Nama Barang </th>
                                                    <th style="width: 10%"> Qty </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    if(!listItem.isEmpty()){
                                                    int start = 0;
                                                    for (Billdetail billDet : listItem) {
                                                        String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
                                                        String urlMat = posApiUrl + "/material/material-credit/" + billDet.getMaterialId();
                                                        JSONObject jos = WebServices.getAPI("", urlMat);
                                                        
                                                        start++;
                                                %>
                                                <tr>
                                                    <td class="text-center"><%=start%></td>
                                                    <td class="text-center"><%=billDet.getSku()%></td>
                                                    <td class="text-center"><%=billDet.getItemName()%></td>
                                                    <td class="text-center"><%=billDet.getQty()%></td>
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
                        </div>
                    </form>
                </div>
                <div class="box-footer">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="pull-right">
                                <% if (hk.getStatus() == I_DocStatus.DOCUMENT_STATUS_DRAFT) { %>
                                <button form="form-return" type="button" id="btn-save" class="btn btn-success">
                                    <i class="fa fa-save"></i> Simpan
                                </button>
                                <% if (hk.getOID() > 0) { %>
                                <button form="form-return" type="button" id="btn-delete" class="btn btn-danger">
                                    <i class="fa fa-save"></i> Hapus
                                </button>
                                <% }
                                } %>
                                <button type="button" id="back-btn" class="btn btn-default">
                                    <i class="fa fa-refresh"></i> Kembali
                                </button>
                            </div>
                        </div>
                    </div>			
                </div>
            </div>
        </section>
                                
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
