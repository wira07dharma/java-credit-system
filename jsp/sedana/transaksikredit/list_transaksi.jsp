<%-- 
    Document   : list_transaksi
    Created on : Oct 13, 2017, 3:57:34 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="com.dimata.sedana.entity.kredit.Angsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAngsuran"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.session.SessKredit"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<% 
    int appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_APPROVAL, AppObjInfo.OBJ_APPROVAL_DAFTAR_TRANSAKSI); 
    boolean privApprove = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_CLOSED));
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
    int print = FRMQueryString.requestInt(request, "print_list_transaksi");
    int showHistory = FRMQueryString.requestInt(request, "show_history");
    String tglAwal = FRMQueryString.requestString(request, "FRM_TGL_AWAL");
    String tglAkhir = FRMQueryString.requestString(request, "FRM_TGL_AKHIR");
    String arrayNasabah[] = request.getParameterValues("FRM_NASABAH");
    String arrayTransaksi[] = request.getParameterValues("FRM_TRANSAKSI");
    long kolektorId = FRMQueryString.requestLong(request, "FRM_KOLEKTOR");
    long userId = FRMQueryString.requestLong(request, "FRM_USER");
    int status = FRMQueryString.requestInt(request, "FRM_STATUS");
    int statusApprove = (privApprove) ? 1 : 0;
    String addSql = "";
    if (!tglAwal.equals("") && !tglAkhir.equals("")) {
        addSql += " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") >= '" + tglAwal + "'"
                + " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") <= '" + tglAkhir + "'";
    }
    
    long empId = 0;
    int appObjCodePenilaian = AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_APPROVAL, AppObjInfo.OBJ_APPROVAL_PENILAIAN_KREDIT);
    boolean privAccept = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCodePenilaian, AppObjInfo.COMMAND_ACCEPT));
    String userGroupAdmin = PstSystemProperty.getValueByName("GROUP_ADMIN_OID");
    String whereUserGroup = PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] + "=" + userGroupAdmin
            + " AND " + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] + "=" + userSession.getAppUser().getOID();
    Vector listUserGroup = PstUserGroup.list(0, 0, whereUserGroup, "");
    if (!privAccept && listUserGroup.isEmpty()) {
        empId = userSession.getAppUser().getEmployeeId();
        if (kolektorId == 0){
            kolektorId = empId;
        }
        if (userId == 0){
            userId = empId;
        }
    }
    
    String nasabah = "";
    JSONObject temp = new JSONObject();
    if (arrayNasabah != null) {
        String idNasabah = "";
        for (int i = 0; i < arrayNasabah.length; i++) {
            if (i > 0) {
                idNasabah += ",";
                nasabah += ", ";
            }
            idNasabah += "" + arrayNasabah[i];
            Anggota a = PstAnggota.fetchExc(Long.valueOf(arrayNasabah[i]));
            nasabah += "" + a.getName();
            try {
                temp.put("id", arrayNasabah[i]);
                temp.put("text", a.getName());                
            } catch (Exception e) {
            }
        }
        if (!idNasabah.equals("")) {
            addSql += " AND a." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " IN (" + idNasabah + ")";
        }
    } else {
        nasabah = "Semua " + namaNasabah;
    }
    
    JSONObject kolektor = new JSONObject();
    if (kolektorId != 0) {
        Employee emp = PstEmployee.fetchFromApi(kolektorId);
        try {
            kolektor.put("id", emp.getOID());
            kolektor.put("text", emp.getFullName());
        } catch (Exception e) {
        }

    }
    
    JSONObject user = new JSONObject();
    if (userId != 0) {
        Employee emp = PstEmployee.fetchFromApi(userId);
        try {
            user.put("id", emp.getOID());
            user.put("text", emp.getFullName());
        } catch (Exception e) {
        }

    }
    
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
            addSql += " AND t." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN (" + kodeTransaksi + ")";
        }
    } else {
        namaTransaksi = "Semua transaksi";
    }
    
//    Vector listTransaksi = SessKredit.getListTransaksiKredit(0, 0, ""
//            + " (t." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " IN ("
//              + Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN
//              + "," + Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT
//              + "," + Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN
//              + "," + Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN
//              + ")"
//              + ")"
//            + addSql
//            + " GROUP BY " + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID], PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC ");

//    String textTglAwal = "";
//    String textTglAkhir = "";
//    Date now = new Date();    
//    textTglAwal = Formater.formatDate(now, "dd MMM yyyy");    
//    textTglAkhir = Formater.formatDate(now, "dd MMM yyyy");
//    if (!tglAwal.equals("") && !tglAkhir.equals("")) {
//        Date dAwal = Formater.formatDate(tglAwal, "yyyy-MM-dd");    
//        textTglAwal = Formater.formatDate(dAwal, "dd MMM yyyy");   
//        Date dAkhir = Formater.formatDate(tglAkhir, "yyyy-MM-dd");
//        textTglAkhir = Formater.formatDate(dAkhir, "dd MMM yyyy");
//    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <%@ include file = "/style/style_kredit.jsp" %>
        
        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            .modal-header, .modal-footer {padding-bottom: 10px; padding-top: 10px !important}
            th:after {display: none !important;}
            .aksi {width: 1% !important}
            .btn_detail:hover {cursor: pointer}
            
            .tabel_data_print {font-size: 10px}

            print-area { visibility: hidden; display: none; }
            print-area.preview { visibility: visible; display: block; }
            @media print
            {
                body .main-page * { visibility: hidden; display: none; } 
                body print-area * { visibility: visible; }
                body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
            }
        </style>
        
        <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>
        
        <script language="javascript">
            $(document).ready(function () {
                let selectedTransaksi = 0;
                let modalApproval = $('#modal-approval');
                let nasabahJarr = JSON.parse('<%= temp.toString() %>');
                let kolektorJarr = JSON.parse('<%= kolektor.toString() %>');
                let userJarr = JSON.parse('<%= user.toString() %>');
                let placeholderNasabah = JSON.parse('{ "id": "0", "text": "-- Semua <%= namaNasabah %> --"}');
                let placeholderKolektor = JSON.parse('{ "id": "0", "text": "-- Semua Kolektor --"}');
                let placeholderUser = JSON.parse('{ "id": "0", "text": "-- Semua User --"}');
                
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

                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                    //parameter tambahan
                    var tglAwal = $('#tgl_awal').val();
                    var tglAkhir = $('#tgl_akhir').val();
                    var nasabah = $('#id_nasabah').val();
                    var transaksi = $('#kode_transaksi').val();
                    let kolektor = $('#id_kolektor').val();
                    let user = $('#id_user').val();
                    let status = $('#status_transaksi').val();

                    var datafilter = "";
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        buttons: [
                            'copy', 'csv', 'excel', 'pdf', 'print'
                        ],
                        "searching": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
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
                                "sLast ":  "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                "sNext ":  "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                "sPrevious ":   "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                            }
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>"
                                + "&SEND_TGL_AWAL=" + tglAwal + "&SEND_TGL_AKHIR=" + tglAkhir + "&SEND_ID_NASABAH=" + nasabah + "&SEND_KODE_TRANSAKSI=" + transaksi + "&SEND_USER_ID=<%=userOID%>" + "&privApprove=<%= privApprove %>"
                                + "&SEND_ID_KOLEKTOR=" + kolektor+"&FRM_STATUS="+status+"&SEND_ID_USER="+user,
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
                            $('input[type="checkbox"].flat-green').iCheck({
                              checkboxClass: 'icheckbox_square-green'
                            });
                            selectedTransaksi = 0;
                            let openTransaction = json.RETURN_DATA_OPEN_TRANSACTION;
                        },
                        "fnDrawCallback": function (oSettings) {
                            if (callBackDataTables !== null) {
                                callBackDataTables();
                            }
                            $(elementIdParent).find(".money").each(function () {
                                jMoney(this);
                                //$(this).addClass("text-right");
                            });
                            $('input[type="checkbox"].flat-green').iCheck({
                              checkboxClass: 'icheckbox_square-green'
                            });
                            selectedTransaksi = 0;
                        },
                        "fnPageChange": function (oSettings) {
                            
                        }
                    });
                    $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                    $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                    $("#" + elementId).css("width", "100%");
                }

                function runDataTable() {
                    dataTablesOptions("#transaksiTableElement", "tableTransaksiTableElement", "AjaxKredit", "listTransaksiKredit", null);
                }
                
                function select2Option(elementId, placeholder, url){
                    $('#' + elementId).select2({
                        placeholder: placeholder,
                        ajax: {
                            url : url,
                            type : "POST",
                            dataType: 'json',
                            delay: 250,
                            data: function(params){
                                return {
                                    searchTerm: params.term,
                                    limitStart: params.limitStart || 0,
                                    recordToGet: 7
                                };
                            },
                            processResults: function(data, params){
                                var ph = data.PAGINATION_HEADER;

                                params.limitStart = ph.CURRENT_PAGE || 0;
                                return {
                                    results: data.ANGGOTA_DATA,
                                    pagination: {
                                        more: ph.CURRENT_PAGE < data.ANGGOTA_TOTAL
                                    }
                                };
                            },
                            cache: true
                        }
                    });
                }
                
                function setSelect2Value(elementId, selectedVal, defaultVal){
                    let newOption;
                    if(!jQuery.isEmptyObject(selectedVal)){
                        newOption = new Option(selectedVal.text, selectedVal.id, true, true);
                    } else {
                        newOption = new Option(defaultVal.text, defaultVal.id, true, true);
                    }
                    $('#' + elementId).append(newOption).trigger('change');
                }

                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };

                function selectMulti(id, placeholder) {
                    $(id).select2({
                        placeholder: placeholder
                    });
                }

//                function setNasabahValue(){
//                    let newOption;
//                    if(!jQuery.isEmptyObject(nasabahJarr)){
//                        newOption = new Option(nasabahJarr.text, nasabahJarr.id, true, true);
//                    } else {
//                        newOption = new Option(placeholderNasabah.text, placeholderNasabah.id, true, true);
//                    }
//                    $('#id_nasabah').append(newOption).trigger('change');
//                }
//
//                function setKolektorValue(){
//                    let newOption;
//                    if(!jQuery.isEmptyObject(kolektorJarr)){
//                        newOption = new Option(kolektorJarr.text, kolektorJarr.id, true, true);
//                    } else {
//                        newOption = new Option(placeholderKolektor.text, placeholderKolektor.id, true, true);
//                    }
//                    $('#id_kolektor').append(newOption).trigger('change');
//                }

                selectMulti('.select2nasabah', "Semua " + "<%=namaNasabah%>");
                selectMulti('.select2transaksi', "Semua Transaksi");
//                setNasabahValue();
//                setKolektorValue();

                setSelect2Value('id_nasabah', nasabahJarr, placeholderNasabah);
                setSelect2Value('id_kolektor', kolektorJarr, placeholderKolektor);
                setSelect2Value('id_user', userJarr, placeholderUser);

                $('.date-picker').datetimepicker({
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

                runDataTable();

                $('body').on("click", ".btn_detail", function () {
                    var currentBtnHtml = $(this).html();
                    $(this).attr({"disabled": "true"});
                    var oid = $(this).data('oid');
                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "SEND_USER_ID": "<%=userOID%>",
                        "FRM_FIELD_DATA_FOR": "getDetailTransaksi",
                        "command": "<%=Command.NONE%>"
                    };
                    onDone = function (data) {
                        var error = data.RETURN_ERROR_CODE;
                        if (error === "0") {
                            modalSetting("#modal-detailTransaksi", "static", false, false);
                            $('#modal-detailTransaksi').modal('show');
                            $('#modal-detailTransaksi').find(".money").each(function () {
                                jMoney(this);
                            });
                        } else {
                            alert(data.RETURN_MESSAGE);
                        }
                    };
                    onSuccess = function (data) {
                        $('.btn_detail').removeAttr("disabled");
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", "#body_detail", false);
                });

                $('#btn_print').click(function () {
                    let alertText = "Yakin cetak daftar transaksi?\nJika tidak ada filter tanggal, secara otomatis menggunakan tanggal hari ini dan 30 hari kebelakang.";
                    if(confirm(alertText)){
                        var buttonHtml = $(this).html();
                        $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                        let formSearch = $('#form_cari').serialize();
                        var dataSend = formSearch
                                + "&FRM_FIELD_DATA_FOR=printDaftarTransaksi" 
                                + "&command=<%=Command.NONE%>&FRM_FIELD_LOCATION_OID=<%= userLocationId %>"
                                + "&SEND_USER_NAME=<%= appUserInit.getFullName() %>";
                        onDone = function (data) {
                            $('#printOut').html(data.FRM_FIELD_HTML);
                            $('#printOut').find(".money").each(function () {
                                jMoney(this);
                            });
                            window.print();
                        };
                        onSuccess = function (data) {
                            $('#btn_print').removeAttr('disabled').html(buttonHtml);
                        };
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", "null", false);
    //                    window.location = "list_transaksi.jsp?print_list_transaksi=1";
                        //window.print();
                        //$(this).removeAttr('disabled').html(buttonHtml);
                    }
                });
                
                $('#btn_export').click(function () {
                    let alertText = "Export daftar transaksi?\nJika tidak ada filter tanggal, secara otomatis menggunakan tanggal hari ini dan 30 hari kebelakang.";
                    if(confirm(alertText)){
                        var buttonHtml = $(this).html();
                        $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                        let formSearch = $('#form_cari').serialize();
                        var dataSend = formSearch
                                + "&FRM_FIELD_DATA_FOR=reportTransaksi" 
                                + "&command=<%=Command.NONE%>&FRM_FIELD_LOCATION_OID=<%= userLocationId %>"
                                + "&SEND_USER_ID=<%=userOID%>&SEND_USER_NAME<%=userFullName%>";
                        onDone = function (data) {
                            $('#tableExport').html(data.FRM_FIELD_HTML);
                            $('#tableExport').find(".money").each(function () {
                                jMoney(this);
                            });
                            tableToExcel('report', 'Daftar Transaksi')
                        };
                        onSuccess = function (data) {
                            $('#btn_export').removeAttr('disabled').html(buttonHtml);
                            
                        };
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxReport", "null", false);
    //                    window.location = "list_transaksi.jsp?print_list_transaksi=1";
                        //window.print();
                        //$(this).removeAttr('disabled').html(buttonHtml);
                    }
                });

                var tableToExcel = (function() {
                    var uri = 'data:application/vnd.ms-excel;base64,', 
                    template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>',
                    base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) },
                    format = function(s, c) { 
                        return s.replace(/{(\w+)}/g, function(m, p) { return c[p]; }) 
                    }
                    return function(table, name) {
                        if (!table.nodeType) table = document.getElementById(table)
                            var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
                            //window.location.href = uri + base64(format(template, ctx))
                            var blob = new Blob([format(template, ctx)]);
                            var blobURL = window.URL.createObjectURL(blob);
                            $("a#printXLS").attr('download', "daftar_transaksi.xls")
                            $("a#printXLS").attr('href', blobURL);
                            document.getElementById("printXLS").click();
                    }
                })()

                $('body').on("click", ".btn_printTransaksi", function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    var oid = $(this).data('oid');
                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": "getPrintOutNotaTransaksi",
                        "FRM_FIELD_LOCATION_OID" : "<%= userLocationId %>",
                        "command": "<%=Command.NONE%>"
                    };
                    onDone = function (data) {
                        $('#printOut').html(data.FRM_FIELD_HTML);
                        $('#printOut').find(".money").each(function () {
                            jMoney(this);
                        });
                        $('#compName').html("<%=compName%>");
                        $('#compAddr').html("<%=compAddr%>");
                        $('#compPhone').html("<%=compPhone%>");
                        $('#adminCetak').html("<%=userFullName%>");
                        window.print();
                    };
                    onSuccess = function (data) {
                        $('.btn_printTransaksi').removeAttr('disabled').html(buttonHtml);
                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", "null", false);
                });

                $('#btn_cari').click(function () {
                    var awal = $('#tgl_awal').val();
                    var akhir = $('#tgl_akhir').val();
                    if (awal !== "" || akhir !== "") {
                        if (awal === "" || akhir === "") {
                            alert("Pastikan tanggal awal dan akhir diisi dengan benar");
                            return false;
                        }
                    }
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> &nbsp; Tunggu");
                    $('#form_cari').submit();
                });
                
                $('body').on('click', '#btn_refresh_table', function(){
                    runDataTable();
                });
                
                $('#hapus_cari').click(function () {
                    $('#tgl_awal').val("");
                    $('#tgl_akhir').val("");
                    $('.select2nasabah').select2('');
                    $('.select2transaksi').select2('data',null);
                });
                
                $('body').on("click", ".btn_delete_trans", function () {
                    if (confirm("Yakin akan menghapus data ini ?")) {
                        hapusTransaksi(".btn_delete_trans");
                    }
                });
                
                $('body').on('click', '.btn_delete_open_trans', function(){
                    if (confirm("Yakin akan menghapus data ini ?")) {
                        hapusTransaksi(".btn_delete_open_trans");
                    }
                });
                $('body').on('click', '.btn_delete_close_trans', function(){
                    modalApproval.modal('show');
                    let oid = $(this).data('oid');
                    modalApproval.find('.modal-footer #btn_approve').val(oid);
                });
                
                $('body').on('ifChecked', '#pilih_semua_transaksi', function(){
                    $('.tutup-transaksi').iCheck('check');
                });
                $('body').on('ifUnchecked', '#pilih_semua_transaksi', function(){
                    $('.tutup-transaksi').iCheck('uncheck');
                });
                $('body').on('ifChecked', '.tutup-transaksi', function(){
                    selectedTransaksi++;
                });
                $('body').on('ifUnchecked', '.tutup-transaksi', function(){
                    selectedTransaksi--;
                });
                $('body').on('click', '#btn_tutup_transaksi', function(){
                    if(selectedTransaksi == 0){
                        alert("Tidak ada data yang di pilih");
                    } else {
                        if(confirm("Tutup transaksi terpilih? ")){
                            tutupTransaksi(this);
                       } 
                    }
                });
                
                $('body').on('click', '#btn_approve', function(){
                    let formData = $('#form_approval');
                    let btnHtml = $(this).html();
                    let oid = $(this).val();
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    let dataSend = "command=<%= Command.NONE %>&FRM_FIELD_DATA_FOR=hapusTransaksiApproval&SEND_USER_ID=<%=userOID%>&SEND_USER_NAME<%=userFullName%>" 
                            + "&privApprove=<%= privApprove %>&oidTransaksi=" + oid + "&" + formData.serialize();
                    onDone = function (data) {
                        if(data.RETURN_ERROR_CODE == 0 && data.RETURN_APPROVAL){
//                            hapusTransaksi(this);
                            modalApproval.modal('hide');
                            $('#modal-detailTransaksi').modal('hide');
                            runDataTable();
                        }
                        alert(data.RETURN_MESSAGE);                            
                        $('#btn_approve').removeAttr('disabled').html(btnHtml);
                    };
                    onSuccess = function (data) {
                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", "null", false);
                });
                
                function tutupTransaksi(btn){
                    let formData = $('#form_list_transaksi');
                    var buttonHtml = $(btn).html();
                    $(btn).attr({"disabled": "true"}).html("Tunggu...");
                    var oid = $(btn).data('oid');
                    var dataSend = "command=<%= Command.SAVE %>&FRM_FIELD_DATA_FOR=tutupTransaksiKredit&SEND_USER_ID=<%=userOID%>&SEND_USER_NAME<%=userFullName%>" 
                            + "&privApprove=<%= privApprove %>&" + formData.serialize();
//                    alert(JSON.stringify(dataSend));
                    onDone = function (data) {
                        alert(data.RETURN_MESSAGE);
                        runDataTable();
                        $(btn).removeAttr('disabled').html(buttonHtml);
                    };
                    onSuccess = function (data) {
                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", "null", false);
                    
                }
                
                function hapusTransaksi(btn) {
                    var buttonHtml = $(btn).html();
                    $(btn).attr({"disabled": "true"}).html("Tunggu...");
                    var oid = $(btn).data('oid');
                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "SEND_USER_ID": "<%= userOID %>",
                        "SEND_USER_NAME": "<%= userFullName %>",
                        "FRM_FIELD_DATA_FOR": "deleteTransaction",
                        "command": "<%=Command.DELETE%>"
                    };
                    //alert(JSON.stringify(dataSend));
                    onDone = function (data) {
                        alert(data.RETURN_MESSAGE);
                        $('#modal-detailTransaksi').modal('hide');
                        runDataTable();
                    };
                    onSuccess = function (data) {
                        $(btn).removeAttr('disabled').html(buttonHtml);
                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", "null", false);
                }
                
                select2Option('id_nasabah', placeholderNasabah, "<%= approot %>/AjaxAnggota?command=<%= Command.LIST %>&FRM_FIELD_DATA_FOR=select2Anggota");
                select2Option('id_kolektor', placeholderKolektor, "<%= approot %>/AjaxAnggota?command=<%= Command.LIST %>"
                        +"&FRM_FIELD_DATA_FOR=select2Employee&SUB_FRM_FIELD_DATA_FOR=kolektor&FRM_USER_LOCATION_ID=<%= userLocationId %>&EMP_AO_ID=<%=empId%>");
                select2Option('id_user', placeholderUser, "<%= approot %>/AjaxAnggota?command=<%= Command.LIST %>"
                        +"&FRM_FIELD_DATA_FOR=select2Employee&SUB_FRM_FIELD_DATA_FOR=user&FRM_USER_LOCATION_ID=<%= userLocationId %>&EMP_AO_ID=<%=empId%>");

                
//                $('#id_nasabah').select2({
//                    placeholder:placeholderNasabah,
//                    ajax: {
//                        url : "<%= approot %>/AjaxAnggota?command=<%= Command.LIST %>&FRM_FIELD_DATA_FOR=select2Anggota",
//                        type : "POST",
//                        dataType: 'json',
//                        delay: 250,
//                        data: function(params){
//                            return {
//                                searchTerm: params.term,
//                                limitStart: params.limitStart || 0,
//                                recordToGet: 7
//                            };
//                        },
//                        processResults: function(data, params){
//                            var ph = data.PAGINATION_HEADER;
//                            
//                            params.limitStart = ph.CURRENT_PAGE || 0;
//                            return {
//                                results: data.ANGGOTA_DATA,
//                                pagination: {
//                                    more: ph.CURRENT_PAGE < data.ANGGOTA_TOTAL
//                                }
//                            };
//                        },
//                        cache: true
//                    }
//                });
                
//                $('#id_kolektor').select2({
//                    placeholder: placeholderKolektor,
//                    ajax: {
//                        url : "<%= approot %>/AjaxAnggota?command=<%= Command.LIST %>&FRM_FIELD_DATA_FOR=select2Employee&SUB_FRM_FIELD_DATA_FOR=kolektor",
//                        type : "POST",
//                        dataType: 'json',
//                        delay: 250,
//                        data: function(params){
//                            return {
//                                searchTerm: params.term,
//                                limitStart: params.limitStart || 0,
//                                recordToGet: 7
//                            };
//                        },
//                        processResults: function(data, params){
//                            var ph = data.PAGINATION_HEADER;
//                            
//                            params.limitStart = ph.CURRENT_PAGE || 0;
//                            return {
//                                results: data.ANGGOTA_DATA,
//                                pagination: {
//                                    more: ph.CURRENT_PAGE < data.ANGGOTA_TOTAL
//                                }
//                            };
//                        },
//                        cache: true
//                    }
//                });

                
            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>
                    Daftar Transaksi Kredit
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Transaksi</li>
                    <li class="active">Kredit</li>
                </ol>
            </section>

            <section class="content">
                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Pencarian</h3>
                        <% if(privApprove){ %>
                        <div class="pull-right">
                            <button type="button" id="btn_tutup_transaksi" class="btn btn-sm btn-warning">Tutup Transaksi</button>
                        </div>
                        <% } %>
                    </div>

                    <div class="box-body">
                        <form id="form_cari" class="form-inline" method="post" action="?command=<%=Command.LIST%>">
                            <input type="text" autocomplete="off" style="width: 100px" placeholder="Tgl. awal" id="tgl_awal" class="form-control date-picker" name="FRM_TGL_AWAL" value="<%=tglAwal%>">
                            <input type="text" autocomplete="off" style="width: 100px" placeholder="Tgl. akhir" id="tgl_akhir" class="form-control date-picker" name="FRM_TGL_AKHIR" value="<%=tglAkhir%>">

                            <select style="width: 200px" id="kode_transaksi" class="form-control input-sm select2transaksi" name="FRM_TRANSAKSI">
                                <option value="0">-- Semua Transaksi --</option>
                                <%
                                    List<Integer> useCaseType = new ArrayList<Integer>();
                                    if(useRaditya == 0){
                                    useCaseType.add(Transaksi.USECASE_TYPE_KREDIT_PENCAIRAN);
                                    }
                                    useCaseType.add(Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT);
                                    useCaseType.add(Transaksi.USECASE_TYPE_KREDIT_BUNGA_TAMBAHAN_PENCATATAN);
                                    useCaseType.add(Transaksi.USECASE_TYPE_KREDIT_DENDA_PENCATATAN);

                                    for (int i = 0; i < useCaseType.size(); i++) {
                                        int usecase = useCaseType.get(i);
                                        String selected = "";
                                        if (arrayTransaksi != null) {
                                            for (int j = 0; j < arrayTransaksi.length; j++) {
                                                int isi = Integer.valueOf(arrayTransaksi[j]);
                                                if (isi == usecase) {
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
                            <select style="width: 100px" id="status_transaksi" class="form-control input-sm select2transaksi" name="FRM_STATUS">
                                <option value="0">-- Semua Status --</option>
                                <option value="<%=Transaksi.STATUS_DOC_TRANSAKSI_OPEN%>" <%=(status == Transaksi.STATUS_DOC_TRANSAKSI_OPEN ? "selected" : "")%>><%=Transaksi.STATUS_DOC_TRANSAKSI_TITLE[Transaksi.STATUS_DOC_TRANSAKSI_OPEN]%></option>
                                <option value="<%=Transaksi.STATUS_DOC_TRANSAKSI_CLOSED%>" <%=(status == Transaksi.STATUS_DOC_TRANSAKSI_CLOSED ? "selected" : "")%>><%=Transaksi.STATUS_DOC_TRANSAKSI_TITLE[Transaksi.STATUS_DOC_TRANSAKSI_CLOSED]%></option>
                                <option value="<%=Transaksi.STATUS_DOC_TRANSAKSI_POSTED%>" <%=(status == Transaksi.STATUS_DOC_TRANSAKSI_POSTED ? "selected" : "")%>><%=Transaksi.STATUS_DOC_TRANSAKSI_TITLE[Transaksi.STATUS_DOC_TRANSAKSI_POSTED]%></option>
                            </select>
                            <select style="width: 200px" id="id_nasabah" class="form-control input-sm" name="FRM_NASABAH"></select>
                            <select style="width: 200px" id="id_kolektor" class="form-control input-sm" name="FRM_KOLEKTOR"></select>
                            <select style="width: 200px" id="id_user" class="form-control input-sm" name="FRM_USER"></select>
                            <button type="button" id="btn_cari" class="btn btn-primary"><i class="fa fa-search"></i> &nbsp; Cari</button>
                            <span id="btn_refresh_table" class="pull-right" style="cursor: pointer;"
                                  data-toggle="tooltip" data-placement="top" data-html="true"
                                  title="Muat ulang<br>tabel transaksi.<br>Jika ingin filter data gunakan fungsi cari!">
                                <i class="fa fa-refresh"></i>
                            </span>
                        </form>

                        <div id="transaksiTableElement">
                            <form id="form_list_transaksi">
                            <table class="table table-striped table-bordered table-responsive" style="font-size: 14px">
                                <thead>
                                    <tr>
                                        <th style="width: 1%">No.</th>
                                        <th style="width: 10%">Tanggal Transaksi</th>
                                        <th style="width: 15%">Keterangan</th>
                                        <th style="width: 10%">Nomor Transaksi</th>
                                        <th style="width: 15%">Nama <%=namaNasabah%></th>
                                        <th style="width: 5%">Lokasi</th>
                                        <th style="width: 10%">Nomor Kredit</th>
                                        <th style="width: 5%">Nilai Transaksi</th>
                                        <th style="width: 10%">User</th>
                                        <th style="width: 3%">Status</th>
                                        <th style="width: 1%" class="text-center">
                                            Aksi
                                            <% if(privApprove){ %>
                                            <br><input type="checkbox" id="pilih_semua_transaksi" class="flat-green">
                                            <% } %>
                                        </th>
                                    </tr>
                                </thead>
                            </table>
                            </form>
                        </div>
                                        
                        <hr style="margin: 10px 0px; border-color: lightgray">
                        <label>Keterangan :</label>
                        <table style="font-size: 14px">
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_KREDIT_PENCAIRAN %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi pencairan kredit</td>
                            </tr>
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_KREDIT_PEMBAYARAN_ANGSURAN %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi pembayaran angsuran kredit</td>
                            </tr>
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_BUNGA_TAMBAHAN %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi pencatatan bunga kredit tambahan</td>
                            </tr>
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_DENDA %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi pencatatan denda</td>
                            </tr>
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_PENALTI_MACET %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi pencatatan penalty pelunasan kredit macet</td>
                            </tr>
                            <tr>
                                <td><%= Transaksi.KODE_TRANSAKSI_KREDIT_PENCATATAN_PENALTI_LUNAS_DINI %></td>
                                <td>&nbsp;&nbsp; : &nbsp;&nbsp;</td>
                                <td>Transaksi pencatatan penalty pelunasan dini</td>
                            </tr>
                        </table>
                    </div>

                    <%//if (!listTransaksi.isEmpty()) {%>
                    <div class="box-footer" style="border-color: lightgray">
                        <div class="pull-right">
                            <a id="printXLS" style="display: none">&nbsp;</a>
                            <button id="btn_export" class="btn btn-sm btn-primary"><i class="fa fa-file-excel-o"></i> &nbsp; Export Excel</button>
                            <button id="btn_print" class="btn btn-sm btn-primary"><i class="fa fa-print"></i> &nbsp; Cetak Transaksi</button>
                        </div>
                    </div>
                    <%//}%>

                </div>
                    
                <a href="list_transaksi.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>
                <p></p>
                <% if (showHistory == 1) { %>
                <div class="box box-default">
                    <div class="box-header">
                        <h3 class="box-title">Riwayat Perubahan</h3>
                    </div>
                    <div class="box-body">
                        <%
                            JSONObject obj = new JSONObject();
                            JSONArray arr = new JSONArray();
                            arr.put(SessHistory.document[SessHistory.DOC_TRANSAKSI_KREDIT]);
                            obj.put("doc", arr);
                            obj.put("time", "");
                            request.setAttribute("obj", obj);
                        %>
                        <%@ include file = "/history_log/history_table.jsp" %>
                    </div>
                </div>
                <% } %>

            </section>
        </div>

        <!--------------------------------------------------------------------->

        <div id="modal-detailTransaksi" class="modal fade no-print" role="dialog">
            <div class="modal-dialog">                
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Detail Transaksi</h4>
                    </div>

                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-12">

                                <div id="body_detail">

                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" id="btn_close" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Keluar</button>
                    </div>

                </div>
            </div>
        </div>

        <div id="modal-approval" class="modal fade no-print" role="dialog">
            <div class="modal-dialog">                
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Approval</h4>
                    </div>
                    
                    <form id="form_approval">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-12">
                                
                                <div class="form-group">
                                    <label for="username_">Username</label>
                                    <input type="text" class="form-control" name="username" id="username_" required="">
                                </div>
                                
                                <div class="form-group">
                                    <label for="password_">Password</label>
                                    <input type="password" class="form-control" name="password" id="password_" required="">
                                </div>

                            </div>
                        </div>
                    </div>
                    </form>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-danger" data-dismiss="modal">Keluar</button>
                        <button type="button" id="btn_approve" class="btn btn-sm btn-success">Approve</button>
                    </div>
                </div>
            </div>
        </div>

        <div id="tableExport" style="display:  none">
            
        </div>    
        
        <!--------------------------------------------------------------------->

    <print-area> 
        <div style="size: A4" id="printOut" class="">
            
            
        </div>
    </print-area>

</body>
</html>
