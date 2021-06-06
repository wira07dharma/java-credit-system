<%-- 
    Document   : penilaian_kredit
    Created on : Jul 14, 2017, 10:02:00 AM
    Author     : Dimata 007
--%>

<%@page import="org.json.JSONArray"%>
<%@page import="com.dimata.harisma.entity.employee.Employee"%>
<%@page import="com.dimata.harisma.entity.employee.PstEmployee"%>
<%@page import="com.dimata.posbo.entity.masterdata.PstColor"%>
<%@page import="com.dimata.posbo.entity.masterdata.Color"%>
<%@page import="com.dimata.hanoman.entity.masterdata.MasterGroup"%>
<%@page import="com.dimata.hanoman.entity.masterdata.MasterType"%>
<%@page import="com.dimata.hanoman.entity.masterdata.PstMasterType"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.dimata.services.WebServices"%>
<%@page import="com.dimata.posbo.entity.masterdata.PstMaterialMappingType"%>
<%@page import="com.dimata.posbo.entity.masterdata.MaterialTypeMapping"%>
<%@page import="com.dimata.posbo.entity.masterdata.PstMerk"%>
<%@page import="com.dimata.posbo.entity.masterdata.Merk"%>
<%@page import="com.dimata.posbo.entity.masterdata.Category"%>
<%@page import="com.dimata.posbo.entity.masterdata.PstCategory"%>
<%@page import="com.dimata.posbo.entity.masterdata.Material"%>
<%@page import="com.dimata.posbo.entity.masterdata.PstMaterial"%>
<%@page import="com.dimata.pos.entity.billing.Billdetail"%>
<%@page import="com.dimata.pos.entity.billing.PstBillDetail"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.sedana.form.kredit.FrmPinjaman"%>
<%@page import="com.dimata.aiso.form.masterdata.anggota.FrmAnggota"%>
<%@page import="com.dimata.sedana.entity.kredit.AgunanMapping"%>
<%@page import="com.dimata.sedana.entity.kredit.Agunan"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAgunan"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAgunanMapping"%>
<%@page import="com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.anggota.AnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.kredit.Penjamin"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPenjamin"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstVocation"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Vocation"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit"%>
<%@page import="com.dimata.sedana.entity.sumberdana.PstSumberDana"%>
<%@page import="com.dimata.sedana.entity.sumberdana.SumberDana"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjamanSumberDana"%>
<%@page import="com.dimata.sedana.entity.kredit.PinjamanSumberDana"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAngsuran"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="java.util.Vector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<% 
    int appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SEDANA, AppObjInfo.G2_MASTER_APPROVAL, AppObjInfo.OBJ_APPROVAL_PENILAIAN_KREDIT); 
    
    boolean privAnalisa = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ANALISA));
    boolean privAccept = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ACCEPT));
    boolean privDecline = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DECLINE));
    boolean privDraft = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DRAFT));
    boolean privCancel = userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_CANCEL));
    
    String kadivOidStr = PstSystemProperty.getValueByName("SEDANA_KADIV_KREDIT_OID");
    String analisOidStr = PstSystemProperty.getValueByName("SEDANA_ANALIS_OID");
    String groupAdminOidStr = PstSystemProperty.getValueByName("GROUP_ADMIN_OID");

    long idEmployeeUser = appUserInit.getEmployeeId();
    Vector userGroupVect = SessAppUser.getUserGroup(userOID);
    long kadivOid = Long.parseLong(kadivOidStr);
    long analisOid = Long.parseLong(analisOidStr);
    long groupAdminOid = Long.parseLong(groupAdminOidStr);
    
    Employee emp = PstEmployee.fetchFromApi(idEmployeeUser);
    boolean privKadiv = emp.getPositionId() == kadivOid;
    boolean privAnalis = emp.getPositionId() == analisOid;
    boolean privAdmin = false;

    for(int i = 0; i < userGroupVect.size(); i++){
        AppGroup ag = (AppGroup) userGroupVect.get(i);
        if(ag.getOID() == groupAdminOid){
            privAdmin = true;
        }
    }

    //if of "hasn't access" condition 
    if(!privKadiv && !privAnalis && !privAdmin && !privAnalisa){
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

<%//
    long oidPinjaman = FRMQueryString.requestLong(request, "pinjaman_id");
    int iCommand = FRMQueryString.requestCommand(request);

    String hrApiUrl = PstSystemProperty.getValueByName("HARISMA_URL");
    String posApiUrl = PstSystemProperty.getValueByName("POS_API_URL");
    
    
    String whereClause = "";
    String msg = "";
    Pinjaman p = new Pinjaman();
    Anggota a = new Anggota();
    Vocation v = new Vocation();
    JenisKredit jk = new JenisKredit();
    String tipeFrekuensi = "";
    long aoId = 0;
    long kolId = 0;
    Location aoLoc = new Location();
    Location kolLoc = new Location();

    try {
        p = PstPinjaman.fetchExc(oidPinjaman);
        jk = PstJenisKredit.fetch(p.getTipeKreditId());
        String arrayTipeFrekuensi[] = JenisKredit.TIPE_KREDIT.get(jk.getTipeFrekuensiPokokLegacy());
        tipeFrekuensi = arrayTipeFrekuensi[SESS_LANGUAGE];
        if (p.getAnggotaId() != 0) {
            a = PstAnggota.fetchExc(p.getAnggotaId());
        }
        if (a.getVocationId() != 0) {
            v = PstVocation.fetchExc(a.getVocationId());
        }
        aoId = p.getAccountOfficerId();
        kolId = p.getCollectorId();
    } catch (Exception e) {
        msg = e.getMessage();
    }

    Employee analis = new Employee();
    Employee kolektor = new Employee();
    String optAll = "<option value='0'>Semua</option>";
    
    
    String optPosition = "";
    long analisPosId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_ANALIS_OID"));
    long sbkId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_SBK_OID"));
    long kolektorId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_KOLEKTOR_OID"));
    optPosition += "<option value='" + analisPosId + "'>Analis</option>";
    optPosition += "<option value='" + kolektorId + "'>Kolektor</option>";
    optPosition += "<option value='" + sbkId + "'>Staff Bantuan Kredit</option>";

    Vector listTemp = new Vector(1, 1);
    if (aoId != 0) {
        JSONArray jArray = PstEmployee.fetchEmpDivFromApi(aoId);
        if (jArray != null && jArray.length() > 0) {
            PstEmployee.convertJsonToObject(jArray.optJSONObject(0), analis);
            aoLoc = PstLocation.fetchFromApi(jArray.optJSONObject(1).optLong("LOCATION_ID", 0));
        }
    }
    if (kolId != 0) {
        JSONArray jArray = PstEmployee.fetchEmpDivFromApi(kolId);
        if (jArray != null && jArray.length() > 0) {
            PstEmployee.convertJsonToObject(jArray.optJSONObject(0), kolektor);
            kolLoc = PstLocation.fetchFromApi(jArray.optJSONObject(1).optLong("LOCATION_ID", 0));
        }
    }

    int enableTabungan = Integer.parseInt(PstSystemProperty.getValueByName("SEDANA_ENABLE_TABUGAN"));
    String penilaianKredit = PstSystemProperty.getValueByName("SEDANA_PENILAIAN_KREDIT_NAME");

    whereClause = PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_MAIN_ID] + "=" + p.getBillMainId();
    Vector listBarang = PstBillDetail.list(0, 0, whereClause, "");
    Billdetail bd = new Billdetail();

    whereClause = PstLocation.fieldNames[PstLocation.FLD_TYPE] + " = " + PstLocation.TYPE_LOCATION_STORE;
    Vector listLokasi = PstLocation.getListFromApi(0, 0, whereClause, "");
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
        <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
        <script src="../../style/datatables/jquery.dataTables.js" type="text/javascript"></script>
        <script src="../../style/datatables/dataTables.bootstrap.js" type="text/javascript"></script>
        <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>

        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            th:after {display: none !important;}

            .tabel_data td {font-size: 14px; padding-right: 10px; padding-bottom: 2px}

            .aksi {width: 1% !important}
            .modal-header, .modal-footer {padding-bottom: 10px; padding-top: 10px !important}
            .btn-dokumen{
                    width: 80%;
                    font-size: 90%;
                    margin: 1%;
            }
            .md-log{
              width: 915px;
            }
            .md-con{
              width: max-content;
            }
            .show-item{
              cursor: pointer;
            }
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

                // DATABLE SETTING
                function dataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables, order) {
                    var datafilter = "";
                    var privUpdate = "";
                    var formAssignOfficer = $('#form-assign-officer').serialize();
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
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter 
                        + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>&" + formAssignOfficer
                        + "&FRM_FIELD_LOCATION_OID=<%= userLocationId %>&FRM_EMPLOYEE_USER=<%= idEmployeeUser %>"
                        + "&PRIV_POS_KADIV=<%= privKadiv %>&PRIV_POS_ANALIS=<%= privAnalis %>&PRIV_POS_ADMIN=<%= privAdmin %>",
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
                // DATABLE SETTING
                function dataTablesOptionsHistory(elementIdParent, elementId, servletName, dataFor, callBackDataTables, idKredit) {
                    var datafilter = "";
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({
						"bDestroy": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "oLanguage": {
                            "sProcessing": "<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div>"
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>" + "&FRM_FIELD_OID=" + idKredit,
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
                        },
                        "fnPageChange": function (oSettings) {

                        }
                    });
                    $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                    $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                    $("#" + elementId).css("width", "100%");
                }

                function runDataTable() {
                    let order = [[5, "desc"]];
                    dataTablesOptions("#pinjamanTableElement", "tablePinjamanTableElement", "AjaxKredit", "listPenilaian", null, order);
                }
                function runDataTableHistory(idKredit) {
                    dataTablesOptionsHistory("#historyTableElement", "tableHistoryTableElement", "AjaxKredit", "listHistory", null, idKredit);
                }

                function loadDataTable(elementId, servlet, dataFor, callback, order){
                    dataTablesOptions(elementId, elementId, servlet, dataFor, callback,order);
                }

                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };
                $('body').on('click', '.btn-select-ao', function (){
                        var aoID = $(this).val();
                        var name = $(this).data('name');
                        alert("Terpilih " + name);
                        $('#account-officer-oid').val(aoID);
                        $('#aoid_').val(name);
                        $('#select-ao').modal('hide');
                });
                $('body').on('click', '.btn-select-kolektor', function (){
                        var aoID = $(this).val();
                        var name = $(this).data('name');
                        alert("Terpilih " + name);
                        $('#account-kolektor-oid').val(aoID);
                        $('#kolid_').val(name);
                        $('#select-kolektor').modal('hide');
                });
                $('.date-picker').datetimepicker({
                    weekStart: 1,
                    format: "yyyy-mm-dd",
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2
                });

                runDataTable();

                $('body').on("click", ".btn-actionkredit", function () {
                    var currentBtnHtml = $('.btn-actionkredit').html();
                    $('.btn-actionkredit').html("...").attr({"disabled": "true"});
                    var oid = $(this).data('oid');
                    window.location = "penilaian_kredit.jsp?command=<%= Command.EDIT %>&pinjaman_id=" + oid;
                });

                $('body').on("click", ".btn-showhistory", function () {
                    var currentBtnHtml = $('.btn-showhistory').html();
                    $('.btn-showhistory').html("Tunggu...").attr({"disabled": "true"});
                    var oid = $(this).data('oid');
                    modalSetting("#modal-showhistory", "static", false, false);
                    $('#modal-showhistory').modal('show');
                    $('.btn-showhistory').removeAttr("disabled").html(currentBtnHtml);
                    runDataTableHistory(oid);
                });
                
                $(".btnPenilaian").click(function() {
                    var btnHtml = $(this).html();
                    $(this).html("Tunggu...").attr({"disabled": "true"});
                    var dataSend = {
                        "FRM_FIELD_OID": "<%= oidPinjaman %>",
                        "FRM_FIELD_ACTION": $("#newStatus").val(),
                        "FRM_FIELD_DATA_FOR": "saveKreditAction",
                        "FRM_FIELD_HISTORY": $("#keteranganPenilaian").val(),
                        "SEND_USER_ID": "<%= userOID %>",
                        "SEND_USER_NAME": "<%= userFullName %>",
                        "<%= FrmPinjaman.fieldNames[FrmPinjaman.FRM_ACCOUNT_OFFICER_ID] %>": $('#account-officer-oid').val(),
                        "<%= FrmPinjaman.fieldNames[FrmPinjaman.FRM_COLLECTOR_ID] %>": $('#account-kolektor-oid').val(),
                        "<%= FrmPinjaman.fieldNames[FrmPinjaman.FRM_LOKASI_PENAGIHAN] %>": $('#<%= FrmPinjaman.fieldNames[FrmPinjaman.FRM_LOKASI_PENAGIHAN] %>').val(),
                        "command": "<%=Command.SAVE%>"
                    };
                    onDone = function (data) {
                        alert(data.RETURN_MESSAGE);
                        window.location = "penilaian_kredit.jsp";
                    };
                    onSuccess = function (data) {
                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                });
                
                $("#btnBack").click(function() {
                    $(this).html("Tunggu...").attr({"disabled": "true"});
                });


                $("#select-ao-btn").click(function (){
                        modalSetting('#select-ao', 'static', false, false);
                        $('#select-ao').modal('show');
                        $('#select-ao').one('shown.bs.modal', function (e){
                                var elementId = 'accountOfficerTable';
                                var servlet = 'AjaxAnggota';
                                var dataFor = 'listSelectAo';
								var order = [[1, "asc"]];
                                loadDataTable(elementId, servlet, dataFor,null, order);
                        });
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

                $('#change-ao-kol-btn').click(function(){
                        modalSetting('#change-ao-kol', 'static', false, false);
                        $('#change-ao-kol').modal('show');
                });

                $('body').on('click','.show-dokumen',function (){
                        var oid = $(this).data('oid');
                    var type = $(this).data('type');
                    window.open("<%=approot%>/masterdata/masterdokumen/dokumen_edit.jsp?oid_pinjaman="+oid+"&type="+type, '_blank', 'location=yes,height=650,width=1000,scrollbars=yes,status=yes');
                });
            });
        </script>

    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
                <%= penilaianKredit %>
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Transaksi</li>
                <li class="active">Kredit</li>
            </ol>
        </section>

        <section class="content">
            <% if (iCommand == Command.NONE) {%>
            <div class="box box-success">
                <div class="box-header with-border" style="border-color: lightgray">
                    <h3 class="box-title">Daftar Kredit</h3>
                </div>
                <div class="box-body">
                    <div id="pinjamanTableElement">
                        <table class="table table-striped table-bordered table-responsive" style="font-size: 14px">
                            <thead>
                                <tr class="">
                                    <th style="width: 1%">No.</th>                                    
                                    <th>Nomor Kredit</th>
                                    <th>Nama <%=namaNasabah%></th>
                                    <th>Jenis Kredit</th>
                                    <th>Jumlah Pengajuan</th>
                                    <th>Tanggal Pengajuan</th>
                                    <!--th>Sumber Dana</th-->
                                    <!--th>Tanggal Realisasi</th-->
                                    <th>Status</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
            <% }%>
            
            <% if (iCommand == Command.EDIT) {%>
            <div class="box box-success">
                <input type="hidden" id="account-officer-oid" value="<%= aoId%>">
                <input type="hidden" id="account-kolektor-oid" value="<%= kolId%>">
                <div class="box-header with-border" style="border-color: lightgray">
                    <h3 class="box-title">Data Pengajuan Kredit : <a><%= p.getNoKredit()%></a></h3>
                </div>
                <div class="box-body">
                    <div class="row">
                        <div class="col-sm-4">
                            <label>Data Pemohon :</label>
                            <table class="tabel_data">
                                <tr>
                                    <td>Nama Pemohon</td>
                                    <td>:</td>
                                    <td><%= a.getName()%></td>
                                </tr>
                                <tr>
                                    <td>Nomor KTP</td>
                                    <td>:</td>
                                    <td><%= a.getIdCard()%></td>
                                </tr>
                                <tr>
                                    <td>Alamat</td>
                                    <td>:</td>
                                    <td><%= a.getAddressPermanent()%></td>
                                </tr>
                                <tr>
                                    <td>Pekerjaan</td>
                                    <td>:</td>
                                    <td><%= v.getVocationName()%></td>
                                </tr>
                                <tr>
                                    <td>Nomor Telp./HP</td>
                                    <td>:</td>
                                    <td><%= a.getTelepon()%> / <%= a.getHandPhone()%></td>
                                </tr>
                            </table>
                            <br>
                        </div>

                        <div class="col-sm-4">
                            <label>Data Pengajuan :</label>
                            <table class="tabel_data">
                                <tr>
                                    <td>Tanggal Pengajuan</td>
                                    <td>:</td>
                                    <td><%= p.getTglPengajuan()%></td>
                                </tr>
                                <tr>
                                    <td>Jenis Kredit</td>
                                    <td>:</td>
                                    <td><%= jk.getNamaKredit()%></td>
                                </tr>
                                <tr>
                                    <td>Jumlah DP</td>
                                    <td>:</td>
                                    <td>Rp <span class="money"><%= p.getDownPayment()%></span></td>
                                </tr>
                                <tr>
                                    <td>Jumlah Pengajuan</td>
                                    <td>:</td>
                                    <td>Rp <span class="money"><%= p.getJumlahPinjaman()%></span></td>
                                </tr>
                                <% if (enableTabungan == 1) {%>
                                <tr>
                                    <td>Suku Bunga</td>
                                    <td>:</td>
                                    <td><span class="money"><%= p.getSukuBunga()%></span> % per tahun</td>
                                </tr>
                                <% }%>
                                <tr>
                                    <td>Tipe Bunga</td>
                                    <td>:</td>
                                    <td><%= Pinjaman.TIPE_BUNGA_TITLE[p.getTipeBunga()]%></td>
                                </tr>
                                <tr>
                                    <td>Jangka Waktu</td>
                                    <td>:</td>
                                    <td><%= p.getJangkaWaktu() + " (" + tipeFrekuensi + ")"%></td>
                                </tr>
                            </table>
                            <br>
                        </div>

                        <% if (aoId != 0) { %>
                        <div class="col-sm-4">
                            <label>Data Analis :</label>
                            <table class="tabel_data">
                                <tr>
                                    <td>Nama</td>
                                    <td>:</td>
                                    <td><%= analis.getFullName()%></td>
                                </tr>
                                <tr>
                                    <td>Lokasi Dinas</td>
                                    <td>:</td>
                                    <td><%= aoLoc.getName()%></td>
                                </tr>
                            </table>
                            <br>
                            <% if(kolId != 0){ %>
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
                            <br>
                            <% } %>
                            <label>Keterangan :</label>
                            <p>
                                <%= p.getKeterangan()%>
                            </p>
                            <br>			
                        </div>
                        <% } %>
                    </div>

                    <div class="row">
                        <div class="col-sm-4">
                            <% if (enableTabungan == 1) { %>
                            <label>Data Agunan :</label>
                            <%
                                Vector<Agunan> listAgunan = PstAgunan.listJoinMapping(0, 0, "map." + PstAgunanMapping.fieldNames[PstAgunanMapping.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'", "");
                                if (listAgunan.isEmpty()) {
                                    out.print("<div>Tidak ada agunan</div>");
                                } else {
                                    int i = 0;
                                    for (Agunan agunan : listAgunan) {
                                        Vector<AgunanMapping> listMapping = PstAgunanMapping.list(0, 0, PstAgunanMapping.fieldNames[PstAgunanMapping.FLD_AGUNAN_ID] + " = " + agunan.getOID(), "");
                                        AgunanMapping mapping = new AgunanMapping();
                                        if (!listMapping.isEmpty()) {
                                            mapping = listMapping.get(0);
                                        }
                                        i++;
                                        out.print("<div>" + i + ". &nbsp; " + Agunan.TIPE_AGUNAN.get(agunan.getTipeAgunan()).get("TITLE") + "</div>");

                                        out.print("<table class='tabel_data' style='margin-left: 20px'>");

                                        out.print("<tr>");
                                        out.print("<td>" + Agunan.TIPE_AGUNAN.get(agunan.getTipeAgunan()).get("NOTE_NAME") + "</td>");
                                        out.print("<td>:</td>");
                                        out.print("<td>" + agunan.getNoteTipeAgunan() + "</td>");
                                        out.print("</tr>");

                                        out.print("<tr>");
                                        out.print("<td>Alamat agunan</td>");
                                        out.print("<td>:</td>");
                                        out.print("<td>" + agunan.getAlamatAgunan() + "</td>");
                                        out.print("</tr>");

                                        out.print("<tr>");
                                        out.print("<td>Bukti Kepemilikan</td>");
                                        out.print("<td>:</td>");
                                        out.print("<td>" + agunan.getBuktiKepemilikan() + "</td>");
                                        out.print("</tr>");

                                        out.print("<tr>");
                                        out.print("<td>Nilai NJOP</td>");
                                        out.print("<td>:</td>");
                                        out.print("<td>Rp <span class='money'>" + agunan.getNilaiAgunanNjop() + "</span></td>");
                                        out.print("</tr>");

                                        out.print("<tr>");
                                        out.print("<td>Nilai Ekonomis</td>");
                                        out.print("<td>:</td>");
                                        out.print("<td>Rp <span class='money'>" + agunan.getNilaiEkonomis() + "</span></td>");
                                        out.print("</tr>");

                                        out.print("<tr>");
                                        out.print("<td>Nilai Jaminan</td>");
                                        out.print("<td>:</td>");
                                        out.print("<td>Rp <span class='money'>" + agunan.getNilaiJaminanAgunan() + "</span></td>");
                                        out.print("</tr>");

                                        out.print("<tr>");
                                        out.print("<td>Prosentase Pinjaman</td>");
                                        out.print("<td>:</td>");
                                        out.print("<td><span class='money'>" + mapping.getProsentasePinjaman() + "</span> %</td>");
                                        out.print("</tr>");

                                        out.print("</table>");
                                    }
                                }
                            %>
                            <br>
                            <% } %>
                            <label>List Barang: </label>
                            <table class="tabel_data table table-striped table-bordered" style="background-color: none !important;">
                                <tr>
                                    <th>No.</th>
                                    <th>Nama Barang</th>
                                    <th>Qty</th>
                                    <th>Harga</th>
                                </tr>
                                <%
                                    if (!listBarang.isEmpty()) {
                                        for (int i = 0; i < listBarang.size(); i++) {
                                            bd = (Billdetail) listBarang.get(i);
                                            out.println("<tr>");
                                            out.println("<td class='text-center'> " + (i + 1) + " </td>");
                                            out.println("<td><a class='show-item' data-oid='" + bd.getOID() + "'> " + bd.getItemName() + " </a></td>");
                                            out.println("<td class='text-center'> " + bd.getQty() + " </td>");
                                            out.println("<td class='money text-right'> " + bd.getItemPrice() + " </td>");
                                            out.println("</tr>");
                                        }
                                    } else {
                                        out.println("<tr>");
                                        out.println("<td class='text-center' colspan='4'> Data barang tidak ditemukan. </td>");
                                        out.println("</tr>");
                                    } %>
                            </table>
                            <br>
                        </div>

                        <div class="col-sm-4">
                            <label>Data Penjamin :</label>
                            <%
                                Vector<Penjamin> listPenjamin = PstPenjamin.list(0, 0, "" + PstPenjamin.fieldNames[PstPenjamin.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'", "");
                                if (listPenjamin.isEmpty()) {
                                    out.print("<div>Tidak ada penjamin</div>");
                                } else {
                                    out.print("<table class='tabel_data'>");
                                    int i = 0;
                                    for (Penjamin penjamin : listPenjamin) {
                                        i++;
                                        AnggotaBadanUsaha badanUsaha = PstAnggotaBadanUsaha.fetchExc(penjamin.getContactId());
                                        out.print("<tr>");
                                        out.print("<td>" + i + ".</td>");
                                        out.print("<td>" + badanUsaha.getName() + "</td>");
                                        out.print("<td>:</td>");
                                        out.print("<td>Dijamin sebesar <span class='money'>" + penjamin.getCoverage() + "</span> %</td>");
                                        out.print("</tr>");
                                    }
                                    out.print("</table>");
                                }
                            %>
                            <br>
                        </div>
                        <div class="col-sm-4">
                            <div class="row">
                                <div class="col-sm-6">
                                    <label>Lokasi Penagihan :</label>
                                    <select class="form-control input-sm" 
                                            name="<%= FrmPinjaman.fieldNames[FrmPinjaman.FRM_LOKASI_PENAGIHAN]%>" 
                                            id="<%= FrmPinjaman.fieldNames[FrmPinjaman.FRM_LOKASI_PENAGIHAN]%>">
                                        <%
                                            out.println("<option value='" + Pinjaman.LOKASI_PENAGIHAN_RUMAH + "' "
                                                    + ((p.getLokasiPenagihan() == Pinjaman.LOKASI_PENAGIHAN_RUMAH) ? "selected=''" : "") + ">"
                                                    + Pinjaman.LOKASI_PENAGIHAN[Pinjaman.LOKASI_PENAGIHAN_RUMAH] + "</option>");
                                            out.println("<option value='" + Pinjaman.LOKASI_PENAGIHAN_KANTOR + "' "
                                                    + ((p.getLokasiPenagihan() == Pinjaman.LOKASI_PENAGIHAN_KANTOR) ? "selected=''" : "") + ">"
                                                    + Pinjaman.LOKASI_PENAGIHAN[Pinjaman.LOKASI_PENAGIHAN_KANTOR] + "</option>");
                                        %>
                                    </select>
                                </div>
                            </div>
                            <br>
                            <div class="row">
                                <% int status = p.getStatusPinjaman();%>
                                <div class="col-md-6">
                                    <% if(privAnalisa || privAccept || privCancel || privDecline || privDraft){ %>
                                    <label>Status Pengajuan :</label>
                                    <select class="form-control input-sm" id="newStatus">
                                        <% if(privAnalisa){ %>
                                            <option <%= (status == Pinjaman.STATUS_DOC_TO_BE_APPROVE ? "selected" : "")%> value="<%= Pinjaman.STATUS_DOC_TO_BE_APPROVE%>"><%= Pinjaman.STATUS_DOC_TITLE[Pinjaman.STATUS_DOC_TO_BE_APPROVE]%></option>
                                        <% } %> 
                                        <% if(privAccept){ %>
                                            <option <%= (status == Pinjaman.STATUS_DOC_APPROVED ? "selected" : "")%> value="<%= Pinjaman.STATUS_DOC_APPROVED%>"><%= Pinjaman.STATUS_DOC_TITLE[Pinjaman.STATUS_DOC_APPROVED]%></option>
                                        <% } %> 
                                        <% if(privDraft){ %>
                                            <option <%= (status == Pinjaman.STATUS_DOC_DRAFT ? "selected" : "")%> value="<%= Pinjaman.STATUS_DOC_DRAFT%>"><%= Pinjaman.STATUS_DOC_TITLE[Pinjaman.STATUS_DOC_DRAFT]%></option>
                                        <% } %> 
                                        <% if(privDecline){ %>
                                            <option <%= (status == Pinjaman.STATUS_DOC_TIDAK_DISETUJUI ? "selected" : "")%> value="<%= Pinjaman.STATUS_DOC_TIDAK_DISETUJUI%>"><%= Pinjaman.STATUS_DOC_TITLE[Pinjaman.STATUS_DOC_TIDAK_DISETUJUI]%></option>
                                        <% } %> 
                                        <% if(privCancel){ %>
                                            <option <%= (status == Pinjaman.STATUS_DOC_BATAL ? "selected" : "")%> value="<%= Pinjaman.STATUS_DOC_BATAL%>"><%= Pinjaman.STATUS_DOC_TITLE[Pinjaman.STATUS_DOC_BATAL]%></option>
                                        <% } %> 
                                    </select>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr style="border-color: lightgray; margin-top: 0px">
                    <div class="form-horizontal row">
                        <div class="col-sm-12">
                            <div class="row">
                                <% if (aoId != 0) {%>
                                <div class="col-md-6">
                                    <div class="row">
                                        <div class="col-md-6 text-center">
                                                <!--<a href="form5c_edit.jsp?oidpinjaman=<%= oidPinjaman%>" class="btn btn-sm btn-primary btn-dokumen" data-oid="<%= p.getOID()%>" data-type="F5C">Form 5C</a>-->
                                            <button class="btn btn-sm btn-primary btn-dokumen show-dokumen" data-oid="<%= p.getOID()%>" data-type="SPKJ">Surat Perintah Kerja</button>
                                            <!--<button class="btn btn-sm btn-primary btn-dokumen" data-oid="<%= p.getOID()%>" data-type="FDP">Faktur DP</button>-->
                                            <!--<button class="btn btn-sm btn-primary btn-dokumen show-dokumen" data-oid="<%= p.getOID()%>" data-type="KAS">Kartu Angsuran</button>-->
                                            <button class="btn btn-sm btn-primary btn-dokumen show-dokumen" data-oid="<%= p.getOID()%>" data-type="BAP">Berita Acara Pemeriksaan</button>
                                        </div>
                                        <div class="col-md-6 text-center">
                                            <button id="change-ao-kol-btn" class="btn btn-sm btn-primary btn-dokumen">Ganti Data Analyst</button>
                                            <button class="btn btn-sm btn-primary btn-dokumen show-dokumen" data-oid="<%= p.getOID()%>" data-type="SPT">Surat Pernyataan</button>
                                            <!--<button class="btn btn-lg btn-primary btn-dokumen">Surat Perjanjian Kredit</button>-->
                                        </div>
                                        <!--										<div class="col-md-4">
                                                                                                                                <button class="btn btn-lg btn-primary btn-dokumen">Surat Mutasi Barang</button>
                                                                                                                        </div>-->
                                    </div>

                                </div>
                                <div class="col-md-1"></div>			
                                <div class="col-md-6">
                                </div>
                                <% } else { %>
                                <div class="col-sm-6">
                                    <div class="row" style="margin-left: 10px;">
                                        <div class="col-md-10">
                                            <label>Keterangan :</label>
                                            <textarea class="form-control" id="keteranganPenilaian" rows="8" style="resize: none"><%= p.getKeterangan()%></textarea>										
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <form id="form-assign-officer">
                                        <div class="col-md-5">
                                            <input type="hidden" id="newStatus" value="<%= p.getStatusPinjaman()%>">
                                            <div class="form-group">
                                                <label for="POSITION_ID">Position</label>
                                                <select class="form-control" name="POSITION_ID" id="POSITION_ID">
                                                    <%= optPosition %>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label>Lokasi Dinas</label>
                                                <select class="form-control" id="lokasi-dinas-analis" name="ASSIGN_LOCATION_AO">
                                                    <%
                                                        for (int i = 0; i < listLokasi.size(); i++) {
                                                            Location loc = (Location) listLokasi.get(i);
                                                            out.println("<option value=\"" + loc.getOID() + "\">" + loc.getName() + "</option>");
                                                        }
                                                    %>
                                                </select>

                                            </div>
                                            <div class="form-group">
                                                <label for="aoid_">Assign Analyst: </label>
                                                <div class="input-group">
                                                    <input class="form-control input-sm" id="aoid_" type="text" readonly="" value="<%= analis.getFullName()%>">
                                                    <a class="btn input-group-addon" id="select-ao-btn">
                                                        <i class="fa fa-search"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
<!--
                                        <div class="col-sm-2"></div>
                                        <div class="col-md-5">
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
-->
                                    </form>
                                </div>
                                <% }%>
                            </div>
                            <div class="row">
                                <div class="text-center">
                                    <div class="col-md-12">
                                        <label>&nbsp;</label>
                                        <div class="">
                                            <button type="button" class="btn btnPenilaian btn-sm btn-success"><i class="fa fa-check"></i>&nbsp; Selesai</button>
                                            <span>&nbsp;</span>
                                            <a href="<%= approot%>/sedana/transaksikredit/penilaian_kredit.jsp" id="btnBack" class="btn btn-sm btn-default"><i class="fa fa-undo"></i>&nbsp; Kembali</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-inline">

                    </div>
                </div>
            </div>  
            <% }%>
        </section>

        <!--------------------------------------------------------------------->

        <div id="modal-showhistory" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">                
                <!-- Modal content-->
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Riwayat Perubahan Penilaian Kredit</h4>
                    </div>

                    <form id="">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <div id="historyTableElement">
                                        <table class="table table-striped table-bordered" style="font-size: 14px">
                                            <thead>
                                                <tr>
                                                    <th class="aksi">No.</th>
                                                    <th style="white-space: nowrap">Tanggal Perubahan</th>
                                                    <th style="white-space: nowrap">Nama User</th>
                                                    <th>Aksi</th>
                                                    <th>Detail</th>
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

        <div class="example-modal">
            <div class="modal fade" id="change-ao-kol" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-lg" role="document" style="width: 50%;">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span></button>
                            <h3 class="modal-title text-bold">Ganti Analis</h3>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <form id="form-assign-officer">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <label for="POSITION_ID">Position</label>
                                            <select class="form-control" name="POSITION_ID" id="POSITION_ID">
                                                <%= optPosition %>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Lokasi Dinas</label>
                                            <select class="form-control" id="lokasi-dinas-analis" name="ASSIGN_LOCATION_AO">
                                                <%

                                                    for (int i = 0; i < listLokasi.size(); i++) {
                                                        Location loc = (Location) listLokasi.get(i);
                                                        String selected = "";
                                                        if (loc.getOID() == aoLoc.getOID()) {
                                                            selected = "selected='selected'";
                                                        }
                                                        out.println("<option value=\"" + loc.getOID() + "\" " + selected + ">" + loc.getName() + "</option>");
                                                    }
                                                %>
                                            </select>

                                        </div>
                                        <div class="form-group">
                                            <label for="aoid_">Nama</label>
                                            <div class="input-group">
                                                <input class="form-control input-sm" id="aoid_" type="text" readonly="" value="<%= analis.getFullName()%>">
                                                <a class="btn input-group-addon" id="select-ao-btn">
                                                    <i class="fa fa-search"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
<!--                                                        
                                    <div class="col-md-6">
                                        <div class="box box-success">
                                            <div class="box-header with-border">
                                                <div class="box-title">
                                                    <h4>Kolektor</h4>
                                                </div>
                                            </div>
                                            <div class="box-body">
                                                <div class="form-group">
                                                    <label>Lokasi Dinas</label>
                                                    <select class="form-control" id="lokasi-dinas-kolektor" name="ASSIGN_LOCATION_KOL">
                                                        <%
                                                            for (int i = 0; i < listLokasi.size(); i++) {
                                                                Location loc = (Location) listLokasi.get(i);
                                                                String selected = "";
                                                                if (loc.getOID() == kolLoc.getOID()) {
                                                                    selected = "selected='selected'";
                                                                }
                                                                out.println("<option value=\"" + loc.getOID() + "\" " + selected + ">" + loc.getName() + "</option>");
                                                            }
                                                        %>
                                                    </select>

                                                </div>
                                                <div class="form-group">
                                                    <label for="kolid_">Nama</label>
                                                    <div class="input-group">
                                                        <input class="form-control input-sm" id="kolid_" type="text" readonly="" value="<%= kolektor.getFullName()%>">
                                                        <a class="btn input-group-addon" id="select-kolektor-btn">
                                                            <i class="fa fa-search"></i>
                                                        </a>
                                                    </div>
                                                </div>											
                                            </div>
                                        </div>
                                    </div>
-->
                                </form>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btnPenilaian btn-success">Simpan</button>
                            <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
        </div>
        <!-- /.example-modal -->

        <div class="example-modal">
            <div class="modal fade" id="select-ao" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-lg" style="width: 99%" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span></button>
                            <h3 class="modal-title text-bold">Cari Analyst</h3>
                        </div>
                        <div class="modal-body">
                            <table id="accountOfficerTable" class="table table-bordered table-striped table-hover">
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

        <!-- Modal -->
        <div class="modal fade" id="modalItem" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog md-log" role="document">
                <div class="modal-content md-con">
                    <div class="modal-header">
                        <label class="modal-title" id="exampleModalLabel">Detail Item</label>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <table id="listItem" class="table table-striped table-bordered" style="width:100%">
                            <thead class="headerList">
                                <tr>
                                    <th>No</th>
                                    <th>SKU</th>
                                    <th>Name</th>
                                    <th>Barcode</th>
                                    <th>Category</th>
                                    <th>Brand</th>
                                    <th>Warna</th>
                                    <th>Type</th>
                                    <th>Qty</th>
                                    <th>Harga</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    Material mat = new Material();
                                    MaterialTypeMapping matType = new MaterialTypeMapping();
                                    Category cat = new Category();
                                    Merk mk = new Merk();
                                    MasterType masType = new MasterType();
                                    MasterGroup masGroup = new MasterGroup();
                                    Color col = new Color();
                                    String whereItem = PstBillDetail.fieldNames[PstBillDetail.FLD_BILL_DETAIL_ID] + "=" + bd.getOID();
                                    Vector listDetailBarang = PstBillDetail.list(0, 0, whereItem, "");
                                    for (int i = 0; i < listDetailBarang.size(); i++) {
                                        Billdetail bid = (Billdetail) listDetailBarang.get(i);
                                        try {
                                            String linkMaterial = posApiUrl + "/material/material-credit/" + bid.getMaterialId();
                                            JSONObject objMaterial = WebServices.getAPI("", linkMaterial);
                                            long oidMaterial = PstMaterial.syncExc(objMaterial);
                                            mat = PstMaterial.fetchExc(oidMaterial);

                                            String linkTypeMaterial = posApiUrl + "/material-type-id/" + oidMaterial;
                                            JSONObject objTypeMaterial = WebServices.getAPI("", linkTypeMaterial);
                                            long oidMaterialType = PstMaterialMappingType.syncExc(objTypeMaterial);
                                            matType = PstMaterialMappingType.fetchExc(oidMaterialType);

                                            //Untuk check data baru MasterType 
                                            String linkMasterType = posApiUrl + "/master-type/" + matType.getTypeId();
                                            JSONObject objMasterType = WebServices.getAPI("", linkMasterType);
                                            long oidMasterType = PstMasterType.syncExc(objMasterType);

                                            String linkMasterGroup = posApiUrl + "/master-group/" + oidMaterial;
                                            JSONObject objMasterGroup = WebServices.getAPI("", linkMasterGroup);
                                            long oidMasterGroup = PstMaterialMappingType.syncExc(objMasterGroup);

                                            String linkMasterMapping = posApiUrl + "/master-mapping/" + oidMaterial;
                                            JSONObject objMasterMapping = WebServices.getAPI("", linkMasterMapping);
                                            long oidMasterMapping = PstMaterialMappingType.syncExc(objMasterMapping);

                                            String linkColor = posApiUrl + "/color/" + mat.getColorId();
                                            JSONObject objColor = WebServices.getAPI("", linkColor);
                                            long oidColor = PstColor.syncExc(objColor);
                                            col = PstColor.fetchExc(oidColor);

                                            cat = PstCategory.fetchExc(mat.getCategoryId());
                                            mk = PstMerk.fetchExc(mat.getMerkId());
                                        } catch (Exception e) {
                                        }
                                        Vector listType = PstMasterType.list(0, 0, PstMasterType.fieldNames[PstMasterType.FLD_MASTER_TYPE_ID] + " = " + matType.getTypeId() + " AND " + PstMasterType.fieldNames[PstMasterType.FLD_TYPE_GROUP] + "= 2", "");
                                %>
                                <tr>
                                    <td><%=i + 1%></td>
                                    <td><%=bid.getSku()%></td>
                                    <td><%=bid.getItemName()%></td>
                                    <td><%=mat.getBarCode()%></td>
                                    <td><%=cat.getName()%></td>
                                    <td><%=mk.getName()%></td>
                                    <td><%=col.getColorName()%></td>
                                    <%
                                        if (listType.isEmpty()) {
                                    %>
                                    <td>-</td>
                                    <%} else {
                                        for (int x = 0; x < listType.size(); x++) {
                                            MasterType mt = (MasterType) listType.get(x);
                                    %>
                                    <td><%=mt.getMasterName()%></td>
                                    <%}
               }%>
                                    <td><%=bid.getQty()%></td>
                                    <td class="money"><%=bid.getItemPrice()%></td>
                                    <td><%=mat.getDescription()%></td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
       <script>
           $(document).ready(function () {
            $('#listItem').DataTable({
               "paging": false,
               "lengthChange": false,
               "searching": false,
               "ordering": false,
               "info": false,
               "autoWidth": true,
              });
            $('body').on('click','.show-item', function(){
               var oid = $(this).data('oid');
               console.log("OID: " + oid);
               $('#modalItem').modal('show');
              }); 
            });
       </script>
		
    </body>
</html>
