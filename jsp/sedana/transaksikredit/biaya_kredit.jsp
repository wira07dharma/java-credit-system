<%-- 
    Document   : biaya_kredit
    Created on : Sep 2, 2017, 12:08:02 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstAisoBudgeting"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmAssignContact"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.form.kredit.FrmPinjaman"%>
<%@page import="com.dimata.sedana.session.SessKredit"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.MappingDendaPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.PstMappingDendaPinjaman"%>
<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.aiso.form.masterdata.mastertabungan.FrmJenisKredit"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.common.session.convert.ConvertAngkaToHuruf"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.Penjamin"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPenjamin"%>
<%@page import="com.dimata.sedana.session.SessReportKredit"%>
<%@page import="com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.anggota.AnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.masterdata.BiayaTransaksi"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstBiayaTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksi"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.util.Formater"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

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

<% //
    long oidPinjaman = FRMQueryString.requestLong(request, "pinjaman_id");
    int askPenarikanDana = FRMQueryString.requestInt(request, "ask_pencairan");
    int iCommand = FRMQueryString.requestCommand(request);
    int useTabungan = Integer.parseInt(PstSystemProperty.getValueByName("SEDANA_ENABLE_TABUGAN")); 
    String oidTeller = PstSystemProperty.getValueByName("TELLER_SHIFT_ID"); 
    String whereClause = "";
	long kolId = 0;
    Pinjaman pinjaman = new Pinjaman();
    Anggota nasabah = new Anggota();
    
    try {
        pinjaman = (Pinjaman) PstPinjaman.fetchExc(oidPinjaman);
        nasabah = PstAnggota.fetchExc(pinjaman.getAnggotaId());
        kolId = pinjaman.getCollectorId();
    } catch (Exception e) {
        System.out.println(e.getMessage());
    }
    long tellerShiftId = 0;
	if(useRaditya == 0){
    if (userOID != 0) {
        Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
        if (open.size() < 1) {
            String redirectUrl = approot + "/open_cashier.jsp?redir=" + approot + "/sedana/transaksikredit/pencairan_kredit.jsp";
            response.sendRedirect(redirectUrl);
        } else {
            tellerShiftId = open.get(0).getOID();
        }
    }
    }
 
    if(tellerShiftId == 0){
      tellerShiftId = Long.parseLong(oidTeller);
    }
 
    Employee kolektor = new Employee();
    Location kolLoc = new Location();
    
    try {
        if(kolId != 0){
            JSONArray analisArr = PstEmployee.fetchEmpDivFromApi(kolId);
            PstEmployee.convertJsonToObject(analisArr.optJSONObject(0), kolektor);
            kolLoc = PstLocation.fetchFromApi(analisArr.optJSONObject(1).optLong("LOCATION_ID", 0));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    int syaratCair = 3;
    int syaratTerpenuhi = 0;
    String showSignKetua = PstSystemProperty.getValueByName("SHOW_SIGN_KETUA_BUMDES");
    syaratCair = 3;
    int enableTabungan = Integer.parseInt(PstSystemProperty.getValueByName("SEDANA_ENABLE_TABUGAN"));
    
    whereClause = PstLocation.fieldNames[PstLocation.FLD_TYPE] + " = " + PstLocation.TYPE_LOCATION_STORE;
    Vector listLokasi = PstLocation.getListFromApi(0, 0, whereClause, "");
    
    
    String optPosition = "";
    long analisPosId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_ANALIS_OID"));
    long sbkId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_SBK_OID"));
    long kolektorId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_KOLEKTOR_OID"));
    optPosition += "<option value='" + kolektorId + "'>Kolektor</option>";
    optPosition += "<option value='" + analisPosId + "'>Analis</option>";
    optPosition += "<option value='" + sbkId + "'>Staff Bantuan Kredit</option>";

	
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../../style/style_kredit.jsp" %>
        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            td {padding: 5px; font-size: 14px}
            th:after {display: none !important;}
            .tabel_map_denda td {font-size: 14px; vertical-align: text-top}
            
            print-area { visibility: hidden; display: none; }
            print-area.preview { visibility: visible; display: block; }
            @media print
            {
              body .main-page * { visibility: hidden; display: none; } 
              body print-area * { visibility: visible; }
              body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
            }
            
            table td {vertical-align: text-top}
            .tabel_print td {font-size: 14px !important}
        </style>
        <script language="javascript">
            $(document).ready(function () {

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

                $('#btn_edit').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    var command = "<%=Command.EDIT%>";
                    window.location = "../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command;
                });

                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };
                
                $('.date-picker').datetimepicker({
                    weekStart: 1,
                    format: "yyyy-mm-dd hh:ii:ss",
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2 // No time
                            // showMeridian: 0
                });

                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables, order) {
                    var datafilter = "";
                    var privUpdate = "";
                    var formAssignOfficer = $('#form_biaya').serialize();
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({
						"bDestroy": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
						"order":order,
                        "oLanguage": {
                            "sProcessing": "<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div>",
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
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>&"+formAssignOfficer,
                        aoColumnDefs: [
                            {
                                bSortable: false,
                                aTargets: [0,-1]
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
                        },
                        "fnPageChange": function (oSettings) {

                        }
                    });
                    $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                    $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                    $("#" + elementId).css("width", "100%");
                }

                function loadDataTable(elementId, servlet, dataFor, callback, order){
                    dataTablesOptions(elementId, elementId, servlet, dataFor, callback,order);
                }

                //--------------------------------------------------------------

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

                $('#form_biaya').submit(function () {
                    var idWajib = $('#idSimpananWajib').val();
                    if (idWajib != 0) {
                        var nilaiWajib = 0;
                        nilaiWajib += parseFloat($('.valPersenWajib').val());
                        nilaiWajib += parseFloat($('.valNominalWajib').val());
                        if (nilaiWajib <= 0) {
                            alert("Nilai pengendapan belum diisi !");
                            return false;
                        }
                    }
                    
                    var jumlahCheck = 0;
                    var jumlahChecked = 0;
                    $('.cek').each(function () {
                        jumlahCheck += 1;
                        if ($(this).is(":checked")) {
                            jumlahChecked += 1;
                        }
                    });
                    if (jumlahChecked !== +jumlahCheck / 2) {
                        alert("Pastikan masing-masing tipe biaya sudah dipilih !");
                        return false;
                    } else {
                        $('#btn_save_biaya').attr({"disabled": "true"}).html("Tunggu...");
                    }

                    var dataSend = ""
                            + "SEND_OID_PINJAMAN=" + "<%=oidPinjaman%>"
                            + "&FRM_FIELD_DATA_FOR=" + "saveBiayaDinamis"
                            + "&command=" + "<%=Command.SAVE%>";
                    onDone = function (data) {
                        var error = data.RETURN_ERROR_CODE;
                        if (error === "0") {
                            alert("Data detail berhasil disimpan");
                            window.location = "../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=oidPinjaman%>";
                        } else {
                            alert(data.RETURN_MESSAGE);
                        }
                    };
                    onSuccess = function (data) {

                    };
                    var data = $(this).serialize();
                    dataSend += "&" + data;
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    return false;
                });

                $('#btn_printPencairan').click(function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.print();
                    $(this).removeAttr('disabled').html(buttonHtml);
                });

                $('#btn_cancel').click(function () {
                    $('#btn_cancel').attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=oidPinjaman%>";
                });

                $("form#form-tabungan").submit(function () {
                    var currentBtnHtml = $("#btn-simpan-tabungan").html();
                    $("#btn-simpan-tabungan").html("Menyimpan...").attr({"disabled": "true"});
                    onDone = function (data) {
                        var err = data.RETURN_ERROR_CODE;
                        if (err === "0") {
                            alert("Tabungan berhasil disimpan");
                        } else {
                            alert("Gagal menyimpan tabungan !");
                        }
                        window.location = "../transaksikredit/biaya_kredit.jsp?command=<%= Command.EDIT%>&pinjaman_id=<%=oidPinjaman%>";
                    };
                    var onSuccess = function (data) {
                        $("#btn-simpan-tabungan").removeAttr("disabled").html(currentBtnHtml);
                        $("#modal-addtabungan").modal("hide");
                    };
                    var dataSend = $(this).serialize();
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, true);
                    return false;
                });

                $('#btn-add-tabungan').click(function () {
                    modalSetting("#modal-addtabungan", "static", false, false);
                    $('#modal-addtabungan').modal('show');
                    var dataFor = "saveTabungan";

                    $("#form-tabungan #dataFor").val(dataFor);
                    $("#form-tabungan #oid").val("<%= pinjaman.getAnggotaId()%>");
                });


                $('#btnCair').click(function () {
                    if (confirm("Yakin melanjutkan order ke produksi ini ?")) {
                        var currentBtnHtml = $('#btnCair').html();
                        $('#btnCair').html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...").attr({"disabled": "true"});

                        var oid = "<%= pinjaman.getOID()%>";
                        var dataFor = "cairkanKredit";
                        var command = "<%=Command.SAVE%>";
                        var dataSend = {
                            "FRM_FIELD_OID": oid,
                            "FRM_FIELD_DATA_FOR": dataFor,
                            "command": command,
                            "SEND_USER_ID": "<%=userOID%>",
                            "SEND_USER_NAME": "<%=userName%>",
                            "SEND_OID_TELLER_SHIFT": "<%=tellerShiftId%>",
                            "SEND_TANGGAL_CAIR": $("#tglCair").val()
                        };
                        onDone = function (data) {
                            var error = data.RETURN_ERROR_CODE;
                            if (error === "0") {
                                if (confirm("Order berhasil produksi.\nCetak transaksi order ?")) {
                                    window.print();
                                }
                                window.location = "../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=oidPinjaman%>&ask_pencairan=<%= enableTabungan %>";
                            } else {
                                alert("Order ke produksi gagal !\n" + data.RETURN_MESSAGE);
                                window.location = "../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=oidPinjaman%>";
                            }
                        };
                        onSuccess = function (data) {
                            $('#btnCair').removeAttr("disabled").html(currentBtnHtml);
                        };
                        //alert(JSON.stringify(dataSend));
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, true);
                    }
                });


                $('#btnProduction').click(function () {
                    if (confirm("Yakin melanjutkan order ke produksi ini ?")) {
                        var currentBtnHtml = $('#btnProduction').html();
                        $('#btnProduction').html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...").attr({"disabled": "true"});

                        var oid = "<%= pinjaman.getOID()%>";
                        var dataFor = "toProduction";
                        var command = "<%=Command.SAVE%>";
                        var dataSend = {
                            "FRM_FIELD_OID": oid,
                            "FRM_FIELD_DATA_FOR": dataFor,
                            "command": command,
                            "SEND_USER_ID": "<%=userOID%>",
                            "SEND_USER_NAME": "<%=userName%>",
                            "SEND_OID_TELLER_SHIFT": "<%=tellerShiftId%>",
                            "SEND_TANGGAL_CAIR": $("#tglCair").val()
                        };
                        onDone = function (data) {
                            var error = data.RETURN_ERROR_CODE;
                            if (error === "0") {
//                                if (confirm("Order berhasil produksi.\nCetak transaksi order ?")) {
//                                    window.print();
//                                }
                                alert('Order ke Produksi Berhasil!');
                                window.location = "../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=oidPinjaman%>&ask_pencairan=<%= enableTabungan %>";
                            } else {
                                alert("Order ke produksi gagal !\n" + data.RETURN_MESSAGE);
                                window.location = "../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=oidPinjaman%>";
                            }
                        };
                        onSuccess = function (data) {
                            $('#btnProduction').removeAttr("disabled").html(currentBtnHtml);
                        };
                        //alert(JSON.stringify(dataSend));
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, true);
                    }
                });

                $('#btnTarikPencairan').click(function () {
                    if (confirm("Yakin akan membuat transaksi penarikan untuk pencairan kredit ini ?")) {
                        tarikDanaPencairan();
                    }
                });
                
                $('#select-kolektor-btn').click(function(){
                        modalSetting('#select-kolektor', 'static', false, false);
                        $('#select-kolektor').modal('show');
                        $('#select-kolektor').one('shown.bs.modal', function (e){
                            var elementId = 'kolektorTable';
                            var servlet = 'AjaxAnggota';
                            var dataFor = 'listSelectKol';
                            var order = [[1, "asc"]];
                            loadDataTable(elementId, servlet, dataFor,null, order);
                        });
                });
                $('body').on('click', '.btn-select-kolektor', function (){
                        var aoID = $(this).val();
                        var name = $(this).data('name');
                        alert("Terpilih " + name);
                        $('#account-kolektor-oid').val(aoID);
                        $('#kolid_').val(name);
                        $('#select-kolektor').modal('hide');
                });
                
                if ("<%= askPenarikanDana %>" === "1") {
                    if (confirm("Apakah anda ingin membuat transaksi penarikan dana pencairan ?")) {
                        tarikDanaPencairan();
                    }
                }
                
                $('.toggle-swtich').bootstrapToggle({
                    size: "normal",
                    width: 80,
                    height: 30,
                    style: "android",
                    offstyle: "default",
                    onstyle: "success"
                });
                
                function tarikDanaPencairan() {
                    var currentBtnHtml = $('#btnTarikPencairan').html();
                    $('#btnTarikPencairan').html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...").attr({"disabled": "true"});

                    var oid = "<%= pinjaman.getOID()%>";
                    var dataFor = "penarikanDanaPencairan";
                    var command = "<%=Command.SAVE%>";
                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command,
                        "SEND_USER_ID": "<%=userOID%>",
                        "SEND_USER_NAME": "<%=userName%>",
                        "SEND_OID_TELLER_SHIFT": "<%=tellerShiftId%>"
                    };
                    onDone = function (data) {
                        alert(data.RETURN_MESSAGE);
                        //window.location = "../transaksikredit/pencairan_kredit.jsp";
                        //window.location = "../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=oidPinjaman%>";
                    };
                    onSuccess = function (data) {
                        $('#btnTarikPencairan').removeAttr("disabled").html(currentBtnHtml);
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, true);
                }

            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    Pengajuan Kredit
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Transaksi</li>
                    <li class="active">Pengajuan Kredit</li>
                </ol>
            </section>

            <%if (pinjaman.getOID() != 0) {%>
            <section class="content-header">
                <a style="background-color: white" class="btn btn-default" href="../transaksikredit/transaksi_kredit.jsp?pinjaman_id=<%=pinjaman.getOID()%>&command=<%=Command.EDIT%>">Data Pengajuan</a>            
                <a style="background-color: white" class="btn btn-default" href="../transaksikredit/jadwal_angsuran.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Jadwal Angsuran</a>
                <a style="background-color: white" class="btn btn-default" href="../penjamin/penjamin.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Keluarga & Penjamin</a>
				<% if(enableTabungan == 1){ %>
                <a style="background-color: white" class="btn btn-default" href="../agunan/agunan.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Agunan / Jaminan</a>
				<% } %>
                <% if (pinjaman.getStatusPinjaman() != Pinjaman.STATUS_DOC_DRAFT) {%>
                <a class="btn btn-danger" href="../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Detail</a>
                <% } %>
                <a style="font-size: 14px" class="btn btn-box-tool" href="../transaksikredit/list_kredit.jsp">Kembali ke daftar kredit</a>
            </section>
            <%} else {%>
            <div class="content-header" style="color: red"><i class="fa fa-warning"></i> &nbsp; Data kredit tidak ditemukan !</div>
            <%}%>

            <section class="content">
                <%if (iCommand == Command.NONE) {%>

                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgrey">
                        <h3 class="box-title">Nomor Kredit &nbsp;:&nbsp; <a><%=pinjaman.getNoKredit()%></a></h3>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <h3 class="box-title">Nama <%=namaNasabah%> &nbsp;:&nbsp; <a href="../../masterdata/anggota/anggota_edit.jsp?anggota_oid=<%= nasabah.getOID()%>"><%=nasabah.getName()%></a> &nbsp;(<%=nasabah.getNoAnggota()%>)</h3>
                        <h3 class="box-title pull-right">Status &nbsp;:&nbsp; <a><%=Pinjaman.getStatusDocTitle(pinjaman.getStatusPinjaman())%></a></h3>
                    </div>

                    <div class="box-body">
                        <div class="form-inline pull-right">
                            <input type="text" placeholder="Tanggal cair" id="tglCair" class="form-control input-sm no-border text-right date-picker" value="<%= Formater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") %>">
                        </div>
                        
                        <label>Penjamin :</label>
                        <table class="" style="font-size: 14px">
                            <%
                                Vector listPenjamin = PstPenjamin.list(0, 0, "" + PstPenjamin.fieldNames[PstPenjamin.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'", "");
                                for (int i = 0; i < listPenjamin.size(); i++) {
                                    Penjamin penjamin = (Penjamin) listPenjamin.get(i);
                                    AnggotaBadanUsaha abu = new AnggotaBadanUsaha();
                                    try {
                                        abu = PstAnggotaBadanUsaha.fetchExc(penjamin.getContactId());
                                    } catch (Exception e) {
                                        System.out.println(e.getMessage());
                                    }
                                    double nilai = (pinjaman.getJumlahPinjaman() * (penjamin.getProsentasePenjamin() / 100));
                            %>
                            <tr>
                                <td><%=(i + 1)%>.</td>
                                <td><%=abu.getName()%></td>
                                <td>&nbsp; : &nbsp;</td>
                                <td>Rp <span class="money"><%=nilai%></span> &nbsp; (<span class="money"><%=penjamin.getProsentasePenjamin()%></span> %)</td>
                            </tr>
                            <%
                                }
                            %>
                            <% if (listPenjamin.isEmpty()) {%>
                            <tr><td>Tidak ada penjamin</td></tr>
                            <%}%>
                        </table>
                        
                        <hr style="border-color: lightgray">
                        
                        <%
                            Vector listTipeBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                                    + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oidPinjaman + "'"
                                    + " GROUP BY jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC], "");

                            if (listTipeBiaya.isEmpty()) {
                                out.println("<div>Tidak ada data detail &nbsp;<i class='fa fa-exclamation-circle text-red'></i></div>");
                            } else {
                                syaratTerpenuhi += 1;
                                for (int b = 0; b < listTipeBiaya.size(); b++) {
                                    BiayaTransaksi bt = (BiayaTransaksi) listTipeBiaya.get(b);
                                    int jumlahData = JenisTransaksi.TIPE_DOC_JUMLAH_DATA[bt.getTipeDoc()];

                                    if (jumlahData == JenisTransaksi.TIPE_DOC_JUMLAH_SINGLE) {

                                        Vector listAllBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                                                + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oidPinjaman + "'"
                                                + " AND jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + bt.getTipeDoc() + "'", "");
                                        for (int a = 0; a < listAllBiaya.size(); a++) {
                                            BiayaTransaksi biaya = (BiayaTransaksi) listAllBiaya.get(a);
                                            JenisTransaksi transaksi = new JenisTransaksi();
                                            try {
                                                transaksi = PstJenisTransaksi.fetchExc(biaya.getIdJenisTransaksi());
                                            } catch (Exception e) {
                                                System.out.println(e.getMessage());
                                            }
                        %>

                        <div class="form-group">
                            <div class="form-inline">
                                <label class="control-label"><%=JenisTransaksi.TIPE_DOC_TITLE[biaya.getTipeDoc()]%> &nbsp; : &nbsp;</label>                            
                                <span><%=transaksi.getJenisTransaksi()%></span>
                                <input type="hidden" value="<%=biaya.getOID()%>">                            
                            </div>                                  
                        </div>

                        <%
                            }
                        %>

                        <%
                        } else if (jumlahData == JenisTransaksi.TIPE_DOC_JUMLAH_MULTIPLE) {
                        %>

                        <div>
                            <label class="control-label"><%=JenisTransaksi.TIPE_DOC_TITLE[bt.getTipeDoc()]%></label>
                        </div>
                        <div style="width: 50%">
                            <table class="table table-bordered table-striped">
                                <tr class="label-success">
                                    <th style="width: 40px">No.</th>
                                    <th style="width: 60%">Jenis Biaya</th>
                                    <th style="width: 40%;">Nilai Biaya</th>
                                </tr>
                                <%
                                    Vector listAllBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                                            + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oidPinjaman + "'"
                                            + " AND jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + bt.getTipeDoc() + "'", "");
                                    for (int a = 0; a < listAllBiaya.size(); a++) {
                                        BiayaTransaksi biaya = (BiayaTransaksi) listAllBiaya.get(a);
                                        JenisTransaksi transaksi = new JenisTransaksi();
                                        try {
                                            transaksi = PstJenisTransaksi.fetchExc(biaya.getIdJenisTransaksi());
                                        } catch (Exception exc) {
                                            System.out.println(exc.getMessage());
                                        }
                                        String persen = "";
                                        String uang = "";
                                        if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                                            persen = " %";
                                        } else if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                                            uang = "Rp ";
                                        }

                                %>
                                <tr>
                                    <td><%=(a + 1)%>.</td>
                                    <td><%=transaksi.getJenisTransaksi()%></td>
                                    <td><%=uang%><span class="money"><%=biaya.getValueBiaya()%></span><%=persen%></td>
                                </tr>
                                <%}%>

                                <% if (listAllBiaya.isEmpty()) {%>
                                <tr><td colspan="3" class="text-center label-default">Tidak ada data biaya</td></tr>
                                <%}%>
                            </table>
                        </div>
                        <%
                                }
                            }
                        %>

                        <%}%>

                        <%
                            Vector<DataTabungan> alokasiPencairan = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + pinjaman.getAssignTabunganId() + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + " = " + pinjaman.getIdJenisSimpanan(), null);
                            String tabungan = "<i class='fa fa-exclamation-circle text-red'></i>";
                            if (!alokasiPencairan.isEmpty()) {
                                syaratTerpenuhi += 1;
                                try {
                                    tabungan = PstAssignContactTabungan.fetchExc(alokasiPencairan.get(0).getAssignTabunganId()).getNoTabungan() + "&nbsp; [ " + PstJenisSimpanan.fetchExc(alokasiPencairan.get(0).getIdJenisSimpanan()).getNamaSimpanan() + " ]";
                                } catch (Exception e) {
                                    System.out.println(e.getMessage());
                                }
                            }
                        %>
						<% if (enableTabungan == 1) {%>
                        <div class="form-group">
                            <hr style="border-color: lightgray">
                            <div class="form-inline">
                                <label class="control-label">Simpanan Bebas Alokasi Pencairan &nbsp; : &nbsp;</label>
                                <span><%= tabungan%></span>
                            </div>

                            <%
								String wajib = null;
								if (pinjaman.getWajibIdJenisSimpanan() != 0) {
									try {
										DataTabungan dataTabungan = PstDataTabungan.fetchExc(pinjaman.getWajibIdJenisSimpanan());
										if (dataTabungan.getOID() != 0) {
											wajib = PstAssignContactTabungan.fetchExc(dataTabungan.getAssignTabunganId()).getNoTabungan() + "&nbsp; [ " + PstJenisSimpanan.fetchExc(PstDataTabungan.fetchExc(pinjaman.getWajibIdJenisSimpanan()).getIdJenisSimpanan()).getNamaSimpanan() + " ]";
										}
									} catch (Exception e) {
										System.out.println(e.getMessage());
									}
								}
                            %>

                            <div class="form-inline">
                                <label class="control-label">Simpanan Wajib Alokasi Pengendapan &nbsp; : &nbsp;</label>                            
                                <span><%=(wajib == null ? "-" : wajib)%></span>                       
                            </div>      
                            <% if (wajib != null) {%>
                            <%
								syaratCair += 1;
								if (pinjaman.getWajibValue() > 0) {
									syaratTerpenuhi += 1;
								}
                            %>
                            <div class="form-inline">
                                <label class="control-label">Nilai Simpanan Wajib &nbsp; : &nbsp;</label>                            
                                <%=(pinjaman.getWajibValueType() == Pinjaman.WAJIB_VALUE_TYPE_NOMINAL ? "Rp. " : "")%><span class="money"><%=(pinjaman.getWajibValue())%></span><%=(pinjaman.getWajibValueType() == Pinjaman.WAJIB_VALUE_TYPE_PERSEN ? " %" : "")%>
                                <%= (pinjaman.getWajibValue() == 0) ? "&nbsp;<i class='fa fa-exclamation-circle text-red'></i>" : ""%>
                            </div>
                            <%}%>
                        </div>

						<% } %>
                        <hr style="border-color: lightgray">
                        <% if(kolId != 0){ 
                            syaratTerpenuhi += 1;
                        %>
                            <label>Data Kolektor :</label>
                            <table class="tabel_data">
                                <tr>
                                    <td>Nama</td>
                                    <td>:</td>
                                    <td><%= kolektor.getFullName()%></td>
                                </tr>
                                <tr>
                                    <td>Lokasi Dinas</td>
                                    <td>:</td>
                                    <td><%= kolLoc.getName()%></td>
                                </tr>
                            </table>
                        <% } else {%>
                        <div class="row">
                            <div class="col-sm-12">
                                <p class="text-left">Kolektor belum di assign &nbsp;<i class='fa fa-exclamation-circle text-red'></i></p>
                            </div>
                        </div>                       
                        <%} %>
                        <hr style="border-color: lightgray">
                        <div class="row">
                            <div class="col-sm-6">
                                <%
                                    Vector<MappingDendaPinjaman> listMappingDenda = PstMappingDendaPinjaman.list(0, 0, PstMappingDendaPinjaman.fieldNames[PstMappingDendaPinjaman.FLD_PINJAMAN_ID] + " = " + pinjaman.getOID() + " AND " + PstMappingDendaPinjaman.fieldNames[PstMappingDendaPinjaman.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_DENDA, "");
                                %>
                                <%=listMappingDenda.isEmpty() ? "<p>Tidak ada data ketentuan denda &nbsp;<i class='fa fa-exclamation-circle text-red'></i></p>" : "<p><b>Ketentuan Pengenaan Denda :</b></p>"%>
                                <%if (!listMappingDenda.isEmpty()) {%>
                                <% syaratTerpenuhi += 1;%>
                                <div>
                                    <table class="tabel_map_denda">
                                        <tr>
                                            <td>Status Denda</td>
                                            <td>:</td>
                                            <td><%= Pinjaman.STATUS_DENDA_TITLE[pinjaman.getStatusDenda()] %></td>
                                        </tr>
                                        <tr>
                                            <td>Toleransi Denda</td>
                                            <td>:</td>
                                            <td>
                                                <%=listMappingDenda.get(0).getDendaToleransi() == -1 ? "Tak terbatas" : ""%>
                                                <%=listMappingDenda.get(0).getDendaToleransi() == -2 ? "Akhir bulan" : ""%>
                                                <%=listMappingDenda.get(0).getDendaToleransi() > -1 ? "Jeda " + listMappingDenda.get(0).getDendaToleransi() + " hari" : ""%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Syarat Denda</td>
                                            <td>:</td>
                                            <td><%=JenisKredit.TIPE_DENDA_BERLAKU_TITLE[listMappingDenda.get(0).getTipeDendaBerlaku()]%></td>
                                        </tr>
                                        <tr>
                                            <td>Persentase Denda</td>
                                            <td>:</td>
                                            <td><span><%=listMappingDenda.get(0).getNilaiDenda()%></span> %</td>
                                        </tr>
                                        <tr>
                                            <td>Variabel Denda</td>
                                            <td>:</td>
                                            <td><%=JenisKredit.TIPE_PERHITUNGAN_DENDA_TITLE[listMappingDenda.get(0).getTipePerhitunganDenda()]%> <%=JenisKredit.VARIABEL_DENDA_TITLE[listMappingDenda.get(0).getVariabelDenda()]%> (<%= JenisKredit.TIPE_VARIABEL_DENDA_TITLE[listMappingDenda.get(0).getTipeVariabelDenda()]%>)</td>
                                        </tr>
                                        <tr>
                                            <td>Denda Setiap</td>
                                            <td>:</td>
                                            <td><%=listMappingDenda.get(0).getFrekuensiDenda()%> <%=JenisKredit.SATUAN_FREKUENSI_DENDA_TITLE[listMappingDenda.get(0).getSatuanFrekuensiDenda()]%> (<%= JenisKredit.TIPE_FREKUENSI_DENDA_TITLE[listMappingDenda.get(0).getTipeFrekuensiDenda()]%>)</td>
                                        </tr>
                                    </table>
                                </div>
                                <%}%>
                            </div>
                            <%--if(false){%>
                            <div class="col-sm-4">
                          <%
                            Vector<MappingDendaPinjaman> listMappingBunga = PstMappingDendaPinjaman.list(0, 0, PstMappingDendaPinjaman.fieldNames[PstMappingDendaPinjaman.FLD_PINJAMAN_ID] + " = " + pinjaman.getOID() + " AND " + PstMappingDendaPinjaman.fieldNames[PstMappingDendaPinjaman.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA_TAMBAHAN, "");
                          %>
                          <%=listMappingBunga.isEmpty() ? "<p>Tidak ada data ketentuan bunga tambahan</p>" : "<p><b>Ketentuan Pengenaan Bunga Tambahan :</b></p>"%>
                          <%if (!listMappingBunga.isEmpty()) {%>
                          <div>
                            <table class="tabel_map_denda">
                              <tr>
                                <td>Toleransi Bunga</td>
                                <td>:</td>
                                <td>
                                  <%=listMappingBunga.get(0).getDendaToleransi() == -1 ? "Tak terbatas" : ""%>
                                  <%=listMappingBunga.get(0).getDendaToleransi() == -2 ? "Akhir bulan" : ""%>
                                  <%=listMappingBunga.get(0).getDendaToleransi() > -1 ? "Jeda " + listMappingBunga.get(0).getDendaToleransi() + " hari" : ""%>
                                </td>
                              </tr>
                              <tr>
                                <td>Syarat Bunga</td>
                                <td>:</td>
                                <td><%=JenisKredit.TIPE_DENDA_BERLAKU_TITLE[listMappingBunga.get(0).getTipeDendaBerlaku()]%></td>
                              </tr>
                              <tr>
                                <td>Bunga Setiap</td>
                                <td>:</td>
                                <td><%=listMappingBunga.get(0).getFrekuensiDenda()%> <%=JenisKredit.SATUAN_FREKUENSI_DENDA_TITLE[listMappingBunga.get(0).getSatuanFrekuensiDenda()]%></td>
                              </tr>
                              <tr>
                                <td>Variabel Bunga</td>
                                <td>:</td>
                                <td><%=JenisKredit.VARIABEL_DENDA_TITLE[listMappingBunga.get(0).getVariabelDenda()]%> (<%= JenisKredit.TIPE_VARIABEL_DENDA_TITLE[JenisKredit.TIPE_VARIABEL_DENDA_AKUMULASI] %>)</td>
                              </tr>
                              <tr>
                                <td>Persentase Bunga</td>
                                <td>:</td>
                                <td><%=listMappingBunga.get(0).getNilaiDenda()%>% (<%=JenisKredit.TIPE_PERHITUNGAN_DENDA_TITLE[listMappingBunga.get(0).getTipePerhitunganDenda()]%>)</td>
                              </tr>
                              <tr>
                                <td>Rumus Bunga</td>
                                <td>:</td>
                                <td><%= SessKredit.getRumusDenda(listMappingBunga.get(0)) %></td>
                              </tr>
                            </table>
                          </div>
                          <%}%>
                            </div>
                            <%}--%>
                        </div>

                    </div>

                    <div class="box-footer" style="border-color: lightgray">
                        <% if (pinjaman.getOID() != 0 && pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_APPROVED) {%>
                        <button type="button" class="btn btn-sm btn-primary" id="btn_edit"><i class="fa fa-pencil"></i> &nbsp; Atur Detail</button>
                        
                        <% if (syaratTerpenuhi >= syaratCair) {%>
						<a href="<%= approot %>/sedana/transaksikredit/pencairan_kredit.jsp" class="btn btn-sm btn-default"><i class="fa fa-undo"></i> Kembali</a>
                        <div class="pull-right form-inline">
							<!--<div class="pull-right">Syarat pencairan terpenuhi <i class="fa fa-check-circle text-green"></i></div>-->
       <%if(useRaditya == 1){%>
                            <button type="button" class="btn btn-sm btn-success" id="btnProduction"><i class="fa fa-share"></i>&nbsp; To Production</button>
       <%}else{ %>
                            <button type="button" class="btn btn-sm btn-success" id="btnCair"><i class="fa fa-share"></i>&nbsp; Cair</button>
       <%}%>
                        </div>
                        <%} else {%>
                        <div class="pull-right">Syarat pencairan terpenuhi &nbsp;:&nbsp; <b><%= syaratTerpenuhi%>/<%=syaratCair%></b></div>
                        <% } %>

                        <% } %>

                        <% if ((pinjaman.getOID() != 0 && pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR) && enableTabungan == 1) {%>
                        <button type="button" class="btn btn-sm btn-success pull-right" id="btnTarikPencairan"><i class="fa fa-dollar"></i>&nbsp; Tarik dana pencairan</button>
                        <% } %>
                        
                        <% if ((pinjaman.getOID() != 0 && pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR) && enableTabungan == 1) {%>
                        <button type="button" id="btn_printPencairan" class="btn btn-sm btn-primary"><i class="fa fa-file-text"></i> &nbsp; Cetak dokumen pencairan</button>
                        <% } %>
                    </div>

                </div>

                <%}%>

                <%if (iCommand == Command.EDIT) {%>

                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Nomor Kredit &nbsp;:&nbsp; <a><%=pinjaman.getNoKredit()%></a></h3>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <h3 class="box-title">Nama <%=namaNasabah%> &nbsp;:&nbsp; <a href="../../masterdata/anggota/anggota_edit.jsp?anggota_oid=<%= nasabah.getOID()%>"><%=nasabah.getName()%></a> &nbsp;(<%=nasabah.getNoAnggota()%>)</h3>
                        <h3 class="box-title pull-right">Status &nbsp;:&nbsp; <a><%=Pinjaman.getStatusDocTitle(pinjaman.getStatusPinjaman())%></a></h3>
                    </div>
                    
                    <form id="form_biaya" class="form-horizontal">
                        <input type="hidden" id="account-kolektor-oid" name="KOLEKTOR_ID" value="<%= kolId%>">
                        <div class="box-body">
                            <% if(useTabungan != 0) {%>
                            <div class="col-sm-7">
                                <div class="form-group">
                                    <label class="col-sm-4" style="margin-top: 5px;">Alokasi Dana Pencairan :</label>

                                    <div class="col-sm-6">
                                        <div class="input-group">
                                            <select required="" class="form-control" name="FORM_ALOKASI_TABUNGAN_PENCAIRAN">
                                                <option value="0">- Pilih Tabungan Sukarela -</option>
                                                <%
                                                    Vector<DataTabungan> tabunganBebas = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA] + "=" + pinjaman.getAnggotaId() + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + " IN (SELECT `ID_JENIS_SIMPANAN` FROM `aiso_jenis_simpanan` WHERE `FREKUENSI_SIMPANAN`=0 AND `FREKUENSI_PENARIKAN`=0)", "");
                                                    long idSimpanan = PstDataTabungan.getIdSimpananByAssignSimpanan(pinjaman.getAssignTabunganId(), pinjaman.getIdJenisSimpanan());
                                                    String option = "";
                                                    for (DataTabungan d : tabunganBebas) {
                                                        String nomorTabungan = "";
                                                        String namaSimpanan = "";
                                                        String selected = (idSimpanan == d.getOID()) ? "selected" : "";
                                                        try {
                                                            nomorTabungan = PstAssignContactTabungan.fetchExc(d.getAssignTabunganId()).getNoTabungan();
                                                            namaSimpanan = PstJenisSimpanan.fetchExc(d.getIdJenisSimpanan()).getNamaSimpanan();
                                                        } catch (Exception e) {

                                                        }
                                                        option += "<option " + selected + " value='" + d.getOID() + "'>" + nomorTabungan + " - " + namaSimpanan + "</option>";
                                                    }
                                                %>

                                                <% if (tabunganBebas.isEmpty()) { %>
                                                <!--option>Tidak ada tabungan frekuensi bebas</option-->
                                                <% } else {%>
                                                <%= option%>
                                                <% } %>
                                            </select>
                                            <span id="btn-add-tabungan" class="input-group-addon btn btn-primary"><i class="fa fa-plus"></i></span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-sm-7">
                                <div class="form-group">
                                    <div class="col-sm-12" style="margin-bottom:10px;">
                                        <label class="control-label">Alokasi Tabungan Wajib :</label>
                                    </div>
                                    <div class="col-sm-12">
                                        <%
                                            boolean persentaseWajib = pinjaman.getWajibValueType() == Pinjaman.WAJIB_VALUE_TYPE_PERSEN;
                                            PstDataTabungan pstTab = new PstDataTabungan();
                                            Vector<DataTabungan> dt = PstDataTabungan.list(0, 0, pstTab.fieldNames[pstTab.FLD_ID_ANGGOTA] + "=" + pinjaman.getAnggotaId() + " AND " + pstTab.fieldNames[pstTab.FLD_ID_JENIS_SIMPANAN] + " IN (SELECT `ID_JENIS_SIMPANAN` FROM `aiso_jenis_simpanan` WHERE `FREKUENSI_SIMPANAN`=2 AND `FREKUENSI_PENARIKAN`=1)", "");
                                            if (dt.size() > 0) {
                                        %>
                                        <div class="row">
                                            <div class="col-sm-4">
                                                <select class="form-control" id="idSimpananWajib" name="FORM_WAJIB_TABUNGAN">
                                                    <option value="0">- Pilih Tabungan Wajib -</option>
                                                    <% for (DataTabungan d : dt) {%>

                                                    <% try {%>
                                                    <option <%=(pinjaman.getWajibIdJenisSimpanan() == d.getOID() ? "selected" : "")%> value="<%=d.getOID()%>"><%=PstAssignContactTabungan.fetchExc(d.getAssignTabunganId()).getNoTabungan()%> - <%=PstJenisSimpanan.fetchExc(d.getIdJenisSimpanan()).getNamaSimpanan()%></option>
                                                    <% } catch (Exception e) {
                                                            System.out.println(e.getMessage());
                                                        }
                                                    %>

                                                    <% }%>
                                                </select>
                                            </div>
                                            <div class="col-sm-3">
                                                <div class="input-group">
                                                    <span class="input-group-addon">Rp.</span>
                                                    <input <%=(persentaseWajib && pinjaman.getWajibValue() != 0 ? "readonly" : "")%> type="text" data-min="0" required="" class="form-control money valWajib" id="wajib2" data-cast-class="valNominalWajib" value="<%=(!persentaseWajib ? pinjaman.getWajibValue() : 0)%>">
                                                    <input type="hidden" class="valNominalWajib" name="NOMINAL_WAJIB" value="0.00">
                                                </div>
                                            </div>
                                            <div class="col-sm-3">
                                                <div class="input-group">
                                                    <input <%=(persentaseWajib || pinjaman.getWajibValue() == 0 ? "" : "readonly")%> type="text" data-min="0" required="" class="form-control money valWajib" id="wajib1" data-cast-class="valPersenWajib" value="<%=(persentaseWajib ? pinjaman.getWajibValue() : 0)%>">
                                                    <input type="hidden" class="valPersenWajib" name="PERSEN_WAJIB" value="0.00">
                                                    <span class="input-group-addon">%</span>
                                                </div>
                                            </div>
                                            <script>
                                                $(window).load(function () {
                                                    var toggleWajib = function () {
                                                        var id = $(this).attr("id");
                                                        var otherId = (id == "wajib1") ? $("#wajib2") : $("#wajib1");
                                                        if ($(this).val() && $(this).val() != "0" && $(this).val() != "0.0") {
                                                            $(otherId).attr("readonly", "readonly");
                                                        } else {
                                                            $(otherId).removeAttr("readonly");
                                                        }
                                                    };
                                                    $(".valWajib").on("keyup click", toggleWajib);
                                                });
                                            </script>
                                        </div>
                                        <%} else {%>
                                        Tidak ada tabungan wajib.
                                        <script>
                                            $(window).load(function () {
                                                $("body input, body select, body textarea, body button.btn.btn-success").attr("disable", "disable");
                                            });
                                        </script>
                                        <%}%>
                                    </div>
                                </div>
                            </div>
                            <% } %>		

                            <%
                                Vector listBiayaKreditEdit = PstJenisTransaksi.list(0, 0, "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " = '" + JenisTransaksi.TUJUAN_PROSEDUR_KREDIT + "'"
                                        + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " <> '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_ASURANSI + "'"
                                        + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF] + " = '" + JenisTransaksi.STATUS_JENIS_TRANSAKSI_AKTIF + "'"
                                        + " GROUP BY " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC], "");
                                if(useRaditya == 0){
                                for (int i = 0; i < listBiayaKreditEdit.size(); i++) {
                                    JenisTransaksi jt = (JenisTransaksi) listBiayaKreditEdit.get(i);
                                    int jumlahTransaksi = JenisTransaksi.TIPE_DOC_JUMLAH_DATA[jt.getTipeDoc()];

                                    if (jumlahTransaksi == JenisTransaksi.TIPE_DOC_JUMLAH_SINGLE) {
                            %>

                            <div class="col-sm-7">
                                <div class="form-group">
                                    <div class="col-sm-4">                            
                                        <label class=""><%=JenisTransaksi.TIPE_DOC_TITLE[jt.getTipeDoc()]%> &nbsp; :</label>
                                    </div>
                                    <div class="col-sm-5">           
                                        <select class="form-control input-sm" name="FORM_SELECTION_TRANSAKSI">
                                            <%
                                                Vector<JenisTransaksi> listTransaksi = PstJenisTransaksi.list(0, 0, "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + jt.getTipeDoc() + "'", "");
                                                for (int j = 0; j < listTransaksi.size(); j++) {
                                                    String selected = "";
                                                    Vector listCekBiaya = PstBiayaTransaksi.list(0, 0, "" + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oidPinjaman + "'"
                                                            + " AND " + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_JENIS_TRANSAKSI] + " = '" + listTransaksi.get(j).getOID() + "'", "");
                                                    if (!listCekBiaya.isEmpty()) {
                                                        selected = "selected";
                                                    }
                                            %>
                                            <option <%=selected%> value="<%=listTransaksi.get(j).getOID()%>"><%=listTransaksi.get(j).getJenisTransaksi()%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <%
                            } else if (jumlahTransaksi == JenisTransaksi.TIPE_DOC_JUMLAH_MULTIPLE) {
                            %>

                            <div class="col-sm-7">
                                <div>
                                    <label class="control-label"><%=JenisTransaksi.TIPE_DOC_TITLE[jt.getTipeDoc()]%> &nbsp; :</label>
                                </div>
                                <br>

                                <%
                                    Vector listTransaksi = PstJenisTransaksi.list(0, 0, "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " = '" + JenisTransaksi.TUJUAN_PROSEDUR_KREDIT + "'"
                                            + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF] + " = '" + JenisTransaksi.STATUS_JENIS_TRANSAKSI_AKTIF + "'"
                                            + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + jt.getTipeDoc() + "'", "");

                                    for (int j = 0; j < listTransaksi.size(); j++) {
                                        JenisTransaksi jenisTransaksi = (JenisTransaksi) listTransaksi.get(j);
                                        double nilai = 0;
                                        String checkUang = "";
                                        String checkPersen = "";
                                        Vector<BiayaTransaksi> listCekBiaya = PstBiayaTransaksi.list(0, 0, "" + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oidPinjaman + "'"
                                                + " AND " + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_JENIS_TRANSAKSI] + " = '" + jenisTransaksi.getOID() + "'", "");
                                        if (!listCekBiaya.isEmpty()) {
                                            nilai = listCekBiaya.get(0).getValueBiaya();
                                            if (listCekBiaya.get(0).getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                                                checkUang = "checked";
                                            } else if (listCekBiaya.get(0).getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                                                checkPersen = "checked";
                                            }
                                        }
                                        String required = "";
                                        int input = jenisTransaksi.getInputOption();
                                        if (input == JenisTransaksi.TIPE_DOC_INPUT_REQUIRED) {
                                            required = "required";
                                        }
                                        if (nilai == 0 && checkUang.equals("") && checkPersen.equals("")) {
                                            if (jenisTransaksi.getValueStandarTransaksi() != 0) {
                                                nilai = jenisTransaksi.getValueStandarTransaksi();
                                                checkUang = "checked";
                                            } else if (jenisTransaksi.getProsentasePerhitungan() != 0) {
                                                nilai = jenisTransaksi.getProsentasePerhitungan();
                                                checkPersen = "checked";
                                            } else {
                                                checkUang = "checked";
                                            }
                                        }
                                %>

                                <div class="form-group">
                                    <label class="control-label col-sm-3"><%=jenisTransaksi.getJenisTransaksi()%></label>
                                    <div class="col-sm-3">
                                        <input type="text" <%=required%> class="form-control input-sm money" data-cast-class="<%=jenisTransaksi.getOID()%>" value="<%=nilai%>">
                                        <input type="hidden" class="<%=jenisTransaksi.getOID()%> biayaKredit" value="" data-oid="<%=jenisTransaksi.getOID()%>"  name="FORM_NILAI_BIAYA">
                                        <input type="hidden" value="<%=jenisTransaksi.getOID()%>" name="FORM_ID_JENIS_TRANSAKSI">
                                    </div>
                                    <div class="col-sm-5">
                                        <div class="checkbox">
                                            <label><input type="checkbox" <%=checkUang%> data-row="<%=j%>" id="uang<%=j%>" class="checkUang cek" value="<%=BiayaTransaksi.TIPE_BIAYA_UANG%>" name="FORM_TIPE_BIAYA">Rp</label>
                                            &nbsp;&nbsp;&nbsp;
                                            <label><input type="checkbox" <%=checkPersen%> data-row="<%=j%>" id="persen<%=j%>" class="checkPersen cek" value="<%=BiayaTransaksi.TIPE_BIAYA_PERSENTASE%>" name="FORM_TIPE_BIAYA">%</label>
                                            <label class="">(<%=JenisTransaksi.TIPE_DOC_INPUT_TITLE[jenisTransaksi.getInputOption()]%>)</label>
                                        </div>                                
                                    </div>
                                </div>

                                <%
                                    }
                                %>

                            </div>

                            <div class="col-sm-5">
                                <div>
                                    <label class="control-label">Standar biaya :</label>
                                </div>

                                <table class="table table-striped">
                                    <tr class="label-success">
                                        <th class="text-left">No.</th>
                                        <th class="text-left">Jenis Transaksi</th>
                                        <th class="text-right">Biaya Rp</th>
                                        <th class="text-right">Biaya %</th>
                                    </tr>
                                    <%
                                        Vector<JenisTransaksi> listStandarBiaya = PstJenisTransaksi.list(0, 0, "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + jt.getTipeDoc() + "'"
                                                + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF] + " = '1'", "");

                                        for (int in = 0; in < listStandarBiaya.size(); in++) {
                                    %>

                                    <tr>
                                        <td><%=(in + 1)%></td>
                                        <td><%=listStandarBiaya.get(in).getJenisTransaksi()%></td>
                                        <td class="money text-right"><%=listStandarBiaya.get(in).getValueStandarTransaksi()%></td>
                                        <td class="money text-right"><%=listStandarBiaya.get(in).getProsentasePerhitungan()%></td>
                                    </tr>

                                    <%}%>

                                </table>

                            </div>

                            <%
                                    }
                                }
                            } else if(useRaditya == 1){
                        for (int i = 0; i < listBiayaKreditEdit.size(); i++) {
                                    JenisTransaksi jt = (JenisTransaksi) listBiayaKreditEdit.get(i);
                                    int jumlahTransaksi = JenisTransaksi.TIPE_DOC_JUMLAH_DATA[jt.getTipeDoc()];
                                    if(jt.getTipeDoc() == 2){
                                     if (jumlahTransaksi == JenisTransaksi.TIPE_DOC_JUMLAH_MULTIPLE) {
                            %>

                            <div class="col-sm-7">
                                <div>
                                    <label class="control-label"><%=JenisTransaksi.TIPE_DOC_TITLE[jt.getTipeDoc()]%> &nbsp; :</label>
                                </div>
                                <br>

                                <%
                                    Vector listTransaksi = PstJenisTransaksi.list(0, 0, "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " = '" + JenisTransaksi.TUJUAN_PROSEDUR_KREDIT + "'"
                                            + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF] + " = '" + JenisTransaksi.STATUS_JENIS_TRANSAKSI_AKTIF + "'"
                                            + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + jt.getTipeDoc() + "'", "");

                                    for (int j = 0; j < listTransaksi.size(); j++) {
                                        JenisTransaksi jenisTransaksi = (JenisTransaksi) listTransaksi.get(j);
                                        double nilai = 0;
                                        String checkUang = "";
                                        String checkPersen = "";
                                        Vector<BiayaTransaksi> listCekBiaya = PstBiayaTransaksi.list(0, 0, "" + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oidPinjaman + "'"
                                                + " AND " + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_JENIS_TRANSAKSI] + " = '" + jenisTransaksi.getOID() + "'", "");
                                        if (!listCekBiaya.isEmpty()) {
                                            nilai = listCekBiaya.get(0).getValueBiaya();
                                            if (listCekBiaya.get(0).getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                                                checkUang = "checked";
                                            } else if (listCekBiaya.get(0).getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                                                checkPersen = "checked";
                                            }
                                        }
                                        String required = "";
                                        int input = jenisTransaksi.getInputOption();
                                        if (input == JenisTransaksi.TIPE_DOC_INPUT_REQUIRED) {
                                            required = "required";
                                        }
                                        if (nilai == 0 && checkUang.equals("") && checkPersen.equals("")) {
                                            if (jenisTransaksi.getValueStandarTransaksi() != 0) {
                                                nilai = jenisTransaksi.getValueStandarTransaksi();
                                                checkUang = "checked";
                                            } else if (jenisTransaksi.getProsentasePerhitungan() != 0) {
                                                nilai = jenisTransaksi.getProsentasePerhitungan();
                                                checkPersen = "checked";
                                            } else {
                                                checkUang = "checked";
                                            }
                                        }
                                %>

                                <div class="form-group">
                                    <label class="control-label col-sm-3"><%=jenisTransaksi.getJenisTransaksi()%></label>
                                    <div class="col-sm-3">
                                        <input type="text" <%=required%> class="form-control input-sm money" data-cast-class="<%=jenisTransaksi.getOID()%>" value="<%=nilai%>">
                                        <input type="hidden" class="<%=jenisTransaksi.getOID()%> biayaKredit" value="" data-oid="<%=jenisTransaksi.getOID()%>"  name="FORM_NILAI_BIAYA">
                                        <input type="hidden" value="<%=jenisTransaksi.getOID()%>" name="FORM_ID_JENIS_TRANSAKSI">
                                    </div>
                                    <div class="col-sm-5">
                                        <div class="checkbox">
                                            <label><input type="checkbox" <%=checkUang%> data-row="<%=j%>" id="uang<%=j%>" class="checkUang cek" value="<%=BiayaTransaksi.TIPE_BIAYA_UANG%>" name="FORM_TIPE_BIAYA">Rp</label>
                                            &nbsp;&nbsp;&nbsp;
                                            <label><input type="checkbox" <%=checkPersen%> data-row="<%=j%>" id="persen<%=j%>" class="checkPersen cek" value="<%=BiayaTransaksi.TIPE_BIAYA_PERSENTASE%>" name="FORM_TIPE_BIAYA">%</label>
                                            <label class="">(<%=JenisTransaksi.TIPE_DOC_INPUT_TITLE[jenisTransaksi.getInputOption()]%>)</label>
                                        </div>                                
                                    </div>
                                </div>

                                <%
                                    }
                                %>

                            </div>

                            <div class="col-sm-5">
                                <div>
                                    <label class="control-label">Standar biaya :</label>
                                </div>

                                <table class="table table-striped">
                                    <tr class="label-success">
                                        <th class="text-left">No.</th>
                                        <th class="text-left">Jenis Transaksi</th>
                                        <th class="text-right">Biaya Rp</th>
                                        <th class="text-right">Biaya %</th>
                                    </tr>
                                    <%
                                        Vector<JenisTransaksi> listStandarBiaya = PstJenisTransaksi.list(0, 0, "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + jt.getTipeDoc() + "'"
                                                + " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF] + " = '1'", "");

                                        for (int in = 0; in < listStandarBiaya.size(); in++) {
                                    %>

                                    <tr>
                                        <td><%=(in + 1)%></td>
                                        <td><%=listStandarBiaya.get(in).getJenisTransaksi()%></td>
                                        <td class="money text-right"><%=listStandarBiaya.get(in).getValueStandarTransaksi()%></td>
                                        <td class="money text-right"><%=listStandarBiaya.get(in).getProsentasePerhitungan()%></td>
                                    </tr>

                                    <%}%>

                                </table>

                            </div>

                            <%
                                    }
                                }
                            }
                      }%>
                            <!--=============================================================-->
                            
                            <div class="col-sm-12">
                                <hr>
                                <div class="form-group">
                                    <div class="col-sm-12">
                                        <label class="control-label">Assign Kolektor :</label>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="POSITION_ID">Position</label>
                                        <select class="form-control" name="POSITION_ID" id="POSITION_ID">
                                            <%= optPosition %>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Lokasi Dinas</label>
                                        <select class="form-control" id="lokasi-dinas-kolektor" name="ASSIGN_LOCATION_KOL">
                                            <%
                                                for (int i = 0; i < listLokasi.size(); i++) {
                                                    Location loc = (Location) listLokasi.get(i);
                                                    out.println("<option value=\"" + loc.getOID() + "\">" + loc.getName() + "</option>");
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="kolid_">Assign Kolektor: </label>
                                        <div class="input-group">
                                            <input class="form-control input-sm" id="kolid_" type="text" readonly="" value="<%= kolektor.getFullName()%>">										
                                            <a class="btn input-group-addon" id="select-kolektor-btn">
                                                <i class="fa fa-search"></i>
                                            </a>
                                        </div>
                                    </div>										
                                </div>
                            </div>
                            
                            <!--=============================================================-->


                            <% JenisKredit jenisKredit = PstJenisKredit.fetch(pinjaman.getTipeKreditId()); %>
                            <%
                                Vector<MappingDendaPinjaman> listMappingDenda = PstMappingDendaPinjaman.list(0, 0, PstMappingDendaPinjaman.fieldNames[PstMappingDendaPinjaman.FLD_PINJAMAN_ID] + " = " + pinjaman.getOID() + " AND " + PstMappingDendaPinjaman.fieldNames[PstMappingDendaPinjaman.FLD_JENIS_ANGSURAN] + " = " + JadwalAngsuran.TIPE_ANGSURAN_DENDA, "");
                            %>
                            <div class="col-sm-12">
                                <hr>
                                <div class="form-group">
                                    <div class="col-sm-12">
                                        <label class="control-label">* Ketentuan Pengenaan Denda :</label>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="customSwitch1">Status Denda</label>
                                    <div class="col-sm-2">
                                        <div class="checkbox">
                                            <input type="checkbox" class="toggle-swtich"
                                                   name="<%= FrmPinjaman.fieldNames[FrmPinjaman.FRM_STATUS_DENDA] %>"
                                                   id="<%= FrmPinjaman.fieldNames[FrmPinjaman.FRM_STATUS_DENDA] %>"
                                                   style="width: 100%; height: 100%" 
                                                   <%= pinjaman.getStatusDenda() == 0 ? "checked" : "" %>>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Toleransi Denda</label>
                                    <div class="col-sm-2">
                                        <% int toleransiDenda = listMappingDenda.isEmpty() ? jenisKredit.getDendaToleransi() : listMappingDenda.get(0).getDendaToleransi();%>
                                        <select class="form-control input-sm" id="toleransiDenda">
                                            <option <%=(toleransiDenda == -1 ? "selected" : "")%> value="-1">Tak Terbatas</option>
                                            <option <%=(toleransiDenda == -2 ? "selected" : "")%> value="-2">Akhir bulan</option>
                                            <option <%=(toleransiDenda > -1 ? "selected" : "")%> value="-3">Jeda Hari</option>
                                        </select>                      
                                        <script>
                                            $(window).load(function () {
                                                $("#tinputDenda").val() < 0 || $("#tinputDenda").show();
                                                $("#toleransiDenda").change(function () {
                                                    var v = $(this).val();
                                                    if (v == "-3") {
                                                        $("#tinputDenda").val(0);
                                                        $("#tinputDenda").show();
                                                    } else {
                                                        $("#tinputDenda").hide();
                                                        $("#tinputDenda").val(v);
                                                    }
                                                });
                                            });
                                        </script>
                                    </div>
                                    <div class="col-sm-2">
                                        <input style="display: none;" id="tinputDenda" type="number" min="-2" class="form-control input-sm" name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_DENDA_TOLERANSI]%>" value="<%= toleransiDenda%>">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Syarat Denda</label>                                    
                                    <div class="col-sm-4">
                                        <%
                                            Vector tipe_berlaku_denda_key = new Vector();
                                            Vector tipe_berlaku_denda_val = new Vector();
                                            for (int i = 0; i < JenisKredit.TIPE_DENDA_BERLAKU_TITLE.length; i++) {
                                                tipe_berlaku_denda_key.add("" + i);
                                                tipe_berlaku_denda_val.add("" + JenisKredit.TIPE_DENDA_BERLAKU_TITLE[i]);
                                            }
                                        %>
                                        <%= ControlCombo.draw(FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_TIPE_DENDA_BERLAKU], null, listMappingDenda.isEmpty() ? "" + jenisKredit.getTipeDendaBerlaku() : "" + listMappingDenda.get(0).getTipeDendaBerlaku(), tipe_berlaku_denda_key, tipe_berlaku_denda_val, "", "form-control input-sm")%>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Persentase Denda</label>                                    
                                    <div class="col-sm-2">
                                        <div class="input-group">
                                            <input type="text" required class="form-control input-sm" name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_DENDA]%>" value="<%= listMappingDenda.isEmpty() ? jenisKredit.getDenda() : "" + listMappingDenda.get(0).getNilaiDenda()%>">
                                            <span class="input-group-addon">%</span>
                                        </div>
                                    </div>
                                </div>  

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Variabel Denda</label>
                                    <div class="col-sm-2">
                                        <%
                                            Vector tipe_perhitungan_denda_key = new Vector();
                                            Vector tipe_perhitungan_denda_val = new Vector();
                                            for (int i = 0; i < JenisKredit.TIPE_PERHITUNGAN_DENDA_TITLE.length; i++) {
                                                tipe_perhitungan_denda_key.add("" + i);
                                                tipe_perhitungan_denda_val.add("" + JenisKredit.TIPE_PERHITUNGAN_DENDA_TITLE[i]);
                                            }
                                        %>
                                        <%= ControlCombo.draw(FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_TIPE_PERHITUNGAN_DENDA], null, listMappingDenda.isEmpty() ? "" + jenisKredit.getTipePerhitunganDenda() : "" + listMappingDenda.get(0).getTipePerhitunganDenda(), tipe_perhitungan_denda_key, tipe_perhitungan_denda_val, "", "form-control input-sm")%>
                                    </div>
                                    <div class="col-sm-2">
                                        <%
                                            Vector variabel_denda_key = new Vector();
                                            Vector variabel_denda_val = new Vector();
                                            for (int i = 0; i < JenisKredit.VARIABEL_DENDA_TITLE.length; i++) {
                                                variabel_denda_key.add("" + i);
                                                variabel_denda_val.add("" + JenisKredit.VARIABEL_DENDA_TITLE[i]);
                                            }
                                        %>
                                        <%= ControlCombo.draw(FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_VARIABEL_DENDA], null, listMappingDenda.isEmpty() ? "" + jenisKredit.getVariabelDenda() : "" + listMappingDenda.get(0).getVariabelDenda(), variabel_denda_key, variabel_denda_val, "", "form-control input-sm")%>
                                    </div>
                                    <div class="col-sm-2">
                                        <%
                                            Vector tipe_variabel_denda_key = new Vector();
                                            Vector tipe_variabel_denda_val = new Vector();
                                            for (int i = 0; i < JenisKredit.TIPE_VARIABEL_DENDA_TITLE.length; i++) {
                                                tipe_variabel_denda_key.add("" + i);
                                                tipe_variabel_denda_val.add("" + JenisKredit.TIPE_VARIABEL_DENDA_TITLE[i]);
                                            }
                                        %>
                                        <%= ControlCombo.draw(FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_TIPE_VARIABEL_DENDA], null, listMappingDenda.isEmpty() ? "" + jenisKredit.getTipeVariabelDenda() : "" + listMappingDenda.get(0).getTipeVariabelDenda(), tipe_variabel_denda_key, tipe_variabel_denda_val, "", "form-control input-sm")%>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Denda Setiap</label>
                                    <div class="col-sm-2">
                                        <input type="number" placeholder="Frekuensi denda" required class="form-control input-sm" name="<%=FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_FREKUENSI_DENDA]%>" value="<%= listMappingDenda.isEmpty() ? jenisKredit.getFrekuensiDenda() : listMappingDenda.get(0).getFrekuensiDenda()%>">
                                    </div>
                                    <div class="col-sm-2">
                                        <%
                                            Vector tipe_satuan_denda_key = new Vector();
                                            Vector tipe_satuan_denda_val = new Vector();
                                            for (int i = 0; i < JenisKredit.SATUAN_FREKUENSI_DENDA_TITLE.length; i++) {
                                                tipe_satuan_denda_key.add("" + i);
                                                tipe_satuan_denda_val.add("" + JenisKredit.SATUAN_FREKUENSI_DENDA_TITLE[i]);
                                            }
                                        %>
                                        <%= ControlCombo.draw(FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_SATUAN_FREKUANSI_DENDA], null, listMappingDenda.isEmpty() ? "" + jenisKredit.getSatuanFrekuensiDenda() : "" + listMappingDenda.get(0).getSatuanFrekuensiDenda(), tipe_satuan_denda_key, tipe_satuan_denda_val, "", "form-control input-sm")%>
                                    </div>
                                    <div class="col-sm-2">
                                        <%
                                            Vector tipe_frekuensi_denda_key = new Vector();
                                            Vector tipe_frekuensi_denda_val = new Vector();
                                            for (int i = 0; i < JenisKredit.TIPE_FREKUENSI_DENDA_TITLE.length; i++) {
                                                tipe_frekuensi_denda_key.add("" + i);
                                                tipe_frekuensi_denda_val.add("" + JenisKredit.TIPE_FREKUENSI_DENDA_TITLE[i]);
                                            }
                                        %>
                                        <%= ControlCombo.draw(FrmJenisKredit.fieldNames[FrmJenisKredit.FRM_TIPE_FREKUENSI_DENDA], null, listMappingDenda.isEmpty() ? "" + jenisKredit.getTipeFrekuensiDenda() : "" + listMappingDenda.get(0).getTipeFrekuensiDenda(), tipe_frekuensi_denda_key, tipe_frekuensi_denda_val, "", "form-control input-sm")%>
                                    </div>
                                </div>  

                            </div>
                            <%--if(false){%>
                        <div class="col-sm-6">
                          <div class="form-group">
                            <div class="col-sm-12">
                              <label class="control-label">* Ketentuan Pengenaan Bunga Tambahan :</label>
                            </div>
                          </div>

                          <div class="form-group">
                            <label class="col-sm-4 control-label">Toleransi Bunga</label>
                            <div class="col-sm-4">
                              <% int toleransiBunga = listMappingBunga.isEmpty() ? jenisKredit.getDendaToleransi() : listMappingBunga.get(0).getDendaToleransi();%>
                              <select class="form-control input-sm" id="toleransiBunga">
                                <option <%=(toleransiBunga == -1 ? "selected" : "")%> value="-1">Tak Terbatas</option>
                                <option <%=(toleransiBunga == -2 ? "selected" : "")%> value="-2">Akhir bulan</option>
                                <option <%=(toleransiBunga > -1 ? "selected" : "")%> value="-3">Jeda Hari</option>
                              </select>                      
                              <script>
                                $(window).load(function () {
                                  $("#tinputBunga").val() < 0 || $("#tinputBunga").show();
                                  $("#toleransiBunga").change(function () {
                                    var v = $(this).val();
                                    if (v == "-3") {
                                      $("#tinputBunga").val(0);
                                      $("#tinputBunga").show();
                                    } else {
                                      $("#tinputBunga").hide();
                                      $("#tinputBunga").val(v);
                                    }
                                  });
                                });
                              </script>
                            </div>
                            <div class="col-sm-4">
                              <input style="display: none;" id="tinputBunga" type="number" min="-2" class="form-control input-sm" name="TOLERANSI_BUNGA" value="<%= toleransiBunga %>">
                            </div>
                          </div>

                  <div class="form-group">
                    <label class="col-sm-4 control-label">Syarat Bunga</label>
                    <div class="col-sm-8">
                      <%
                        Vector tipe_berlaku_bunga_key = new Vector();
                        Vector tipe_berlaku_bunga_val = new Vector();
                        for (int i = 0; i < JenisKredit.TIPE_DENDA_BERLAKU_TITLE.length; i++) {
                          tipe_berlaku_bunga_key.add("" + i);
                          tipe_berlaku_bunga_val.add("" + JenisKredit.TIPE_DENDA_BERLAKU_TITLE[i]);
                        }
                      %>
                      <%= ControlCombo.draw("FRM_TIPE_BUNGA_BERLAKU", null, listMappingBunga.isEmpty() ? "" + jenisKredit.getTipeDendaBerlaku() : "" + listMappingBunga.get(0).getTipeDendaBerlaku(), tipe_berlaku_bunga_key, tipe_berlaku_bunga_val, "", "form-control input-sm")%>
                    </div>
                  </div>

                  <div class="form-group">
                    <label class="col-sm-4 control-label">Bunga Setiap</label>
                    <div class="col-sm-4">
                      <input type="number" placeholder="Frekuensi bunga" required class="form-control input-sm" name="FRM_FREKUENSI_BUNGA" value="<%= listMappingBunga.isEmpty() ? jenisKredit.getFrekuensiDenda() : listMappingBunga.get(0).getFrekuensiDenda()%>">
                    </div>
                    <div class="col-sm-4">
                      <%
                        Vector tipe_satuan_bunga_key = new Vector();
                        Vector tipe_satuan_bunga_val = new Vector();
                        for (int i = 0; i < JenisKredit.SATUAN_FREKUENSI_DENDA_TITLE.length; i++) {
                          tipe_satuan_bunga_key.add("" + i);
                          tipe_satuan_bunga_val.add("" + JenisKredit.SATUAN_FREKUENSI_DENDA_TITLE[i]);
                        }
                      %>
                      <%= ControlCombo.draw("FRM_SATUAN_FREKUANSI_BUNGA", null, listMappingBunga.isEmpty() ? "" + jenisKredit.getSatuanFrekuensiDenda() : "" + listMappingBunga.get(0).getSatuanFrekuensiDenda(), tipe_satuan_bunga_key, tipe_satuan_bunga_val, "", "form-control input-sm")%>
                    </div>
                  </div>  

                  <div class="form-group">
                    <label class="col-sm-4 control-label">Variabel Bunga</label>                                    
                    <div class="col-sm-8">
                      <%
                        Vector variabel_bunga_key = new Vector();
                        Vector variabel_bunga_val = new Vector();
                        for (int i = 0; i < JenisKredit.VARIABEL_DENDA_TITLE.length; i++) {
                          variabel_bunga_key.add("" + i);
                          variabel_bunga_val.add("" + JenisKredit.VARIABEL_DENDA_TITLE[i]);
                        }
                      %>
                      <%= ControlCombo.draw("FRM_VARIABEL_BUNGA", null, listMappingBunga.isEmpty() ? "" + jenisKredit.getVariabelDenda() : "" + listMappingBunga.get(0).getVariabelDenda(), variabel_bunga_key, variabel_bunga_val, "", "form-control input-sm")%>
                    </div>
                  </div>

                  <div class="form-group">
                    <label class="col-sm-4 control-label">Persentase Bunga</label>                                    
                    <div class="col-sm-4">
                      <div class="input-group">            
                        <input type="text" required class="form-control input-sm money" name="FRM_BUNGA" value="<%= listMappingBunga.isEmpty() ? jenisKredit.getDenda() : "" + listMappingBunga.get(0).getNilaiDenda()%>">
                        <span class="input-group-addon">%</span>
                      </div>
                    </div>
                    <div class="col-sm-4">
                      <%
                        Vector tipe_perhitungan_bunga_key = new Vector();
                        Vector tipe_perhitungan_bunga_val = new Vector();
                        for (int i = 0; i < JenisKredit.TIPE_PERHITUNGAN_DENDA_TITLE.length; i++) {
                          tipe_perhitungan_bunga_key.add("" + i);
                          tipe_perhitungan_bunga_val.add("" + JenisKredit.TIPE_PERHITUNGAN_DENDA_TITLE[i]);
                        }
                      %>
                      <%= ControlCombo.draw("FRM_TIPE_PERHITUNGAN_BUNGA", null, listMappingBunga.isEmpty() ? "" + jenisKredit.getTipePerhitunganDenda() : "" + listMappingBunga.get(0).getTipePerhitunganDenda(), tipe_perhitungan_bunga_key, tipe_perhitungan_bunga_val, "", "form-control input-sm")%>
                    </div>    
                  </div>  

                </div>
                    <%}--%>
                        </div>
                        <div class="box-footer" style="border-color: lightgray">
                            <div class="col-sm-12">
                                <div class="pull-right">
                                    <%if (pinjaman.getOID() != 0 && pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_APPROVED) {%>
                                    <button type="submit" id="btn_save_biaya" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                                    <%}%>
                                    <button type="button" id="btn_cancel" class="btn btn-sm btn-default"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                                </div>
                            </div>                        
                        </div>
                    </form>
                </div>

                <%}%>

            </section>
        </div>
                
        <!--------------------------------------------------------------------->

    <print-area>
        <div style="size: A5;" class="container">
            <div style="width: 50%; float: left;">
                <strong style="width: 100%; display: inline-block; font-size: 20px;"><%=compName%></strong>
                <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                <span style="width: 100%; display: inline-block;"><%=compPhone%></span>                    
            </div>
            <div style="width: 50%; float: right; text-align: right">                    
                <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">TRANSAKSI PENCAIRAN KREDIT</span>
                <span style="width: 100%; display: inline-block; font-size: 12px;">Tanggal &nbsp; : &nbsp; <%=Formater.formatDate(new Date(), "dd MMMM yyyy")%></span>                    
                <span style="width: 100%; display: inline-block; font-size: 12px;">Admin &nbsp; : &nbsp; <%=userFullName%></span>                    
            </div>
            <div class="clearfix"></div>
            <hr class="" style="border-color: gray">                
            <div>
                <span style="width: 120px; float: left;">Nomor Kredit</span>
                <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=pinjaman.getNoKredit()%></span>
            </div>
            <div>
                <span style="width: 120px; float: left;">Nama <%=namaNasabah%></span>
                <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=nasabah.getName()%></span>
            </div>
            <div>
                <span style="width: 120px; float: left;">Jumlah Pinjaman</span>
                <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; Rp <a style="color: black" class="money"><%=pinjaman.getJumlahPinjaman()%></a></span>
            </div>
            <div>
                <span style="width: 120px; float: left;">Suku Bunga</span>
                <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <a style="color: black" class="money"><%=pinjaman.getSukuBunga()%></a> % / Tahun</span>
            </div>
            <div>
                <span style="width: 120px; float: left;">Jangka Waktu</span>
                <span style="width: calc(100% - 120px); float: right;">:&nbsp;&nbsp; <%=pinjaman.getJangkaWaktu()%> Bulan</span>
            </div>
            <div class="clearfix"></div>
            <br>

            <div>
                <%
                    double totalBiaya = 0;
                    Vector listJenisBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                            + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oidPinjaman + "'"
                            + " AND jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " = '" + JenisTransaksi.TUJUAN_PROSEDUR_KREDIT + "'"
                            + " GROUP BY jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC], "");
                    for (int i = 0; i < listJenisBiaya.size(); i++) {
                        BiayaTransaksi bt = (BiayaTransaksi) listJenisBiaya.get(i);
                        int jumlahTransaksi = JenisTransaksi.TIPE_DOC_JUMLAH_DATA[bt.getTipeDoc()];
                %>

                <% if (jumlahTransaksi == JenisTransaksi.TIPE_DOC_JUMLAH_MULTIPLE) {%>
                <div>
                    <label class="control-label"><%=JenisTransaksi.TIPE_DOC_TITLE[bt.getTipeDoc()]%> &nbsp; : &nbsp;</label>
                </div>

                <!--BIAYA DITANGGUNG NASABAH-->
                <table class="tabel_print">

                    <%
                        Vector listDetailBiaya = PstBiayaTransaksi.listJoinJenisTransaksi(0, 0, ""
                                + " bt." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_PINJAMAN] + " = '" + oidPinjaman + "'"
                                + " AND jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + bt.getTipeDoc() + "'", "");
                        for (int j = 0; j < listDetailBiaya.size(); j++) {
                            BiayaTransaksi biaya = (BiayaTransaksi) listDetailBiaya.get(j);
                            JenisTransaksi transaksi = new JenisTransaksi();
                            try {
                                transaksi = PstJenisTransaksi.fetchExc(biaya.getIdJenisTransaksi());
                            } catch (Exception e) {
                                System.out.println(e.getMessage());
                            }
                            double nilai = 0;
                            String tampil = "";
                            if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_UANG) {
                                tampil = "Rp <span class='money'>" + biaya.getValueBiaya() + "</span>";
                                totalBiaya += biaya.getValueBiaya();
                            } else if (biaya.getTipeBiaya() == BiayaTransaksi.TIPE_BIAYA_PERSENTASE) {
                                nilai = (pinjaman.getJumlahPinjaman() * (biaya.getValueBiaya() / 100));
                                totalBiaya += nilai;
                                tampil = "Rp <span class='money'>" + nilai + "</span>"
                                        + "&nbsp; (<span class='money'>" + biaya.getValueBiaya() + "</span> %)";
                            }

                    %>

                    <tr>
                        <td><%=transaksi.getJenisTransaksi()%></td>
                        <td>&nbsp; : &nbsp;</td>
                        <td><%=tampil%></td>
                    </tr>

                    <%
                        }
                    %>
                    <% if (listDetailBiaya.isEmpty()) {%>
                    <tr><td>Tidak ada data biaya.</td></tr>
                    <%}%>
                </table>

                <% } %>

                <%
                    }
                %>

                <!--BIAYA ASURANSI-->
                <br>
                <div>
                    <label class="control-label"><%=JenisTransaksi.TIPE_DOC_TITLE[JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_ASURANSI]%> &nbsp; : &nbsp;</label>
                </div>
                <table class="tabel_print">

                    <%
                        double totalAsuransi = 0;
                        Vector listPenjamin = PstPenjamin.list(0, 0, "" + PstPenjamin.fieldNames[PstPenjamin.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'", "");
                        for (int i = 0; i < listPenjamin.size(); i++) {
                            Penjamin penjamin = (Penjamin) listPenjamin.get(i);
                            AnggotaBadanUsaha abu = new AnggotaBadanUsaha();
                            try {
                                abu = PstAnggotaBadanUsaha.fetchExc(penjamin.getContactId());
                            } catch (Exception e) {
                                System.out.println(e.getMessage());
                            }
                            double nilai = (pinjaman.getJumlahPinjaman() * (penjamin.getProsentasePenjamin() / 100));
                            totalAsuransi += nilai;
                    %>
                    <tr>
                        <td><%=(i + 1)%>.</td>
                        <td><%=abu.getName()%></td>
                        <td>&nbsp; : &nbsp;</td>
                        <td>Rp <span class="money"><%=nilai%></span> &nbsp; (<span class="money"><%=penjamin.getProsentasePenjamin()%></span> %)</td>
                    </tr>
                    <%
                        }
                    %>
                    <% if (listPenjamin.isEmpty()) {%>
                    <tr><td>Tidak ada penjamin.</td></tr>
                    <%}%>
                </table>

                <!--NILAI PENGENDAPAN-->
                <br>
                <div>
                    <label class="control-label">Pengendapan &nbsp; : &nbsp;</label>
                </div>
                <%
                    String wajib = null;
                    if (pinjaman.getWajibIdJenisSimpanan() != 0) {
                        try {
                            DataTabungan dataTabungan = PstDataTabungan.fetchExc(pinjaman.getWajibIdJenisSimpanan());
                            if (dataTabungan.getOID() != 0) {
                                wajib = PstAssignContactTabungan.fetchExc(dataTabungan.getAssignTabunganId()).getNoTabungan();
                            }
                        } catch (Exception e) {
                            System.out.println(e.getMessage());
                        }
                    }
                    double keWajib = (pinjaman.getWajibValueType() == pinjaman.WAJIB_VALUE_TYPE_NOMINAL) ? pinjaman.getWajibValue() : (pinjaman.getJumlahPinjaman() * pinjaman.getWajibValue() / 100);
                %>

                <!--PERHITUNGAN TOTAL-->
                <table class="tabel_print">
                    <tr>
                        <td>Nomor Tabungan</td>
                        <td>&nbsp; : &nbsp;</td>
                        <td><%=(wajib == null ? "-" : wajib)%></td>
                    </tr>
                    <tr>
                        <td>Nilai Pengendapan</td>
                        <td>&nbsp; : &nbsp;</td>
                        <td>
                            Rp <span class="money"><%=(keWajib)%></span>
                            <%=(pinjaman.getWajibValueType() == Pinjaman.WAJIB_VALUE_TYPE_PERSEN ? " (" + pinjaman.getWajibValue() + " %)" : "")%>
                        </td>
                    </tr>
                </table>

                <!--hr style="border-color: grey"-->

                <br>
                <div>
                    <label class="control-label">Perhitungan &nbsp; : &nbsp;</label>
                </div>

                <%
                    double total = Math.ceil(pinjaman.getJumlahPinjaman() - (totalBiaya + totalAsuransi) - keWajib);
                    long longTotal = (long) (total);
                    ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                    String con = convert.getText() + " rupiah.";
                    String output = con.substring(0, 1).toUpperCase() + con.substring(1);
                %>

                <table class="tabel_print">  
                    <tr>
                        <td>Jumlah pinjaman &nbsp;-&nbsp; Total biaya &nbsp;-&nbsp; Pengendapan</td>
                        <td>&nbsp; = &nbsp;</td>
                        <td>
                            <span class="money"><%=pinjaman.getJumlahPinjaman()%></span>
                            <span>&nbsp;-&nbsp;</span>
                            <span class="money"><%=(totalBiaya + totalAsuransi)%></span>
                            <span>&nbsp;-&nbsp;</span>
                            <span class="money"><%=(keWajib)%></span>
                        </td>
                    </tr>
                    <tr>
                        <td>Total uang diterima</td>
                        <td>&nbsp; : &nbsp;</td>
                        <td>Rp <span class="money"><%=(total)%></span></td>
                    </tr>
                    <tr>
                        <td>Terbilang (Nilai dibulatkan)<t/td>
                        <td>&nbsp; : &nbsp;</td>
                        <td><%=output%></td>
                        </tr>
                </table>

                <div style='width: 100%;padding-top: 40px;'>
                    <div style='width: 25%;float: left;text-align: center;'>
                        <span>Petugas BUMDesa</span>
                        <br><br><br><br>
                        <span>(&nbsp; . . . . . . . . . . . . . . . . . . . . &nbsp;)</span>
                    </div>
                    <div style='width: 25%;float: right;text-align: center;'>
                        <span>Nasabah</span>
                        <br><br><br><br>
                        <span>(&nbsp; . . . . . . . . . . . . . . . . . . . . &nbsp;)</span>
                    </div>
                </div>
                <% if (showSignKetua.equals("1")) { %>
                <div style='width: 100%;padding-top: 140px;'>
                    <div style='width: 100%;text-align: center;'>
                        <div>Mengetahui</div>
                        <div>Ketua Bumdes</div>
                        <br><br><br><br>
                        <span>(&nbsp; . . . . . . . . . . . . . . . . . . . . &nbsp;)</span>
                    </div>
                </div>
                <% } %>
            </div>

        </div>
    </print-area>

    <div class="example-modal">
            <div class="modal fade" id="select-kolektor" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-lg" style="width: 99%" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span></button>
                            <h3 class="modal-title text-bold">Cari Kolektor</h3>
                        </div>
                        <div class="modal-body">
                            <table id="kolektorTable" class="table table-bordered table-striped table-hover">
                                <thead>
                                <th>No.</th>
                                <th>Kode</th>
                                <th>Nama</th>
                                <th>Handphone</th>
                                <th>Phone</th>
                                <th>Alamat</th>
                                <th>Aksi</th>
                                </thead>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
        </div>
        <!-- /.example-modal -->
    
        <div id="modal-addtabungan" class="modal fade" role="dialog">
            <div class="modal-dialog modal-sm">                
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Tambah Tabungan</h4>
                    </div>

                    <form id="form-tabungan" method="post" enctype="">
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
                                            <% for (MasterTabungan mt : mts) { %>
                                            <option value="<%=mt.getOID()%>"><%=mt.getNamaTabungan()%></option>
                                            <% } %>
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

    </body>
</html>
