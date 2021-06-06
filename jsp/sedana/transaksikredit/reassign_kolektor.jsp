<%-- 
    Document   : reassign_kolektor
    Created on : Feb 26, 2020, 9:32:51 AM
    Author     : arisena
--%>

<%@page import="com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran"%>
<%@page import="com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%! 
    public static String textHeader[][] = {
        {"Ganti Kolektor", "Kredit", "Data Kredit", "Form Pencarian"},
        {"Change Collector", "Loan", "Loan Data", "Search Form"}
    };

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

    String optAll = "<option value='0'>Semua</option>";
    String optLocation = "";
    String optPosition = "";
    String optKolektabilitas = "";

//    ArrayList<Long> listPosition = new ArrayList<Long>();
    long analisPosId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_ANALIS_OID"));
    long kolektorPosId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_KOLEKTOR_OID"));
    long sbkId = Long.parseLong(PstSystemProperty.getValueByName("SEDANA_SBK_OID"));
//    listPosition.add(analisPosId);
//    listPosition.add(kolektorPosId);
    optPosition += "<option value='" + kolektorPosId + "'>Kolektor</option>";
    optPosition += "<option value='" + sbkId + "'>Staff Bantuan Kredit</option>";
    optPosition += "<option value='" + analisPosId + "'>Analis</option>";
    
    Vector<Location> listLocation = PstLocation.getListFromApi(0, 0, "", "");
    int index = 0;
    for(Location l : listLocation){
//        if(index == 0){
//            optLocation += optAll;
//        }
        boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+l.getOID());
        if (l.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
            optLocation += "<option value='" + l.getOID() + "'>" + l.getName() + "</option>";
        }
        index++;
    }
    
    Vector<KolektibilitasPembayaran> listKolektabilitas = PstKolektibilitasPembayaran.listAll();
    index = 0;
    for(KolektibilitasPembayaran kp : listKolektabilitas){
        if(index == 0){
            optKolektabilitas += optAll;
        } 
        optKolektabilitas += "<option value='" + kp.getOID() + "'>" + kp.getJudulKolektibilitas() + "</option>";
        index++;
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../../style/style_kredit.jsp" %>
        
        <style>
            .box-inner-scroll{
                overflow-y: auto;
                position: inherit;
                max-height: 377px;
            }
        </style>
        
        <script>
            $(document).ready(function(){
                let approot = "<%= approot%>";
                let modalKolektor = $('#modal-assign-kolektor');
                
                //Sweet Alert
                let swalClasses = {
                    container: 'container-class',
                    popup: 'popup-class',
                    header: 'header-class',
                    title: 'title-class',
                    closeButton: 'close-button-class',
                    icon: 'icon-class',
                    image: 'image-class',
                    content: 'content-class',
                    input: 'input-class',
                    actions: 'actions-class',
                    confirmButton: 'confirm-button-class',
                    cancelButton: 'cancel-button-class',
                    footer: 'footer-class'
                };
                function fireSwal(position, type, message){
                    Swal.fire({
                        position: position,
                        icon: type,
                        title: message,
                        customClass: swalClasses
                    });
                };
                //get data function
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
                    var datafilter = "";
                    var privUpdate = "";
                    var searchForm = $('#SEARCH_FORM');
                    var url = "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FOR=" + dataFor + "&" + searchForm.serialize();
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({
                        "bDestroy": true,
                        "searching": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "order": [[1]],
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
                                        "sLast ": "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                        "sNext ": "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                        "sPrevious ": "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                            }
                        },
                        "bServerSide": true,
                        "sAjaxSource": url,
                        aoColumnDefs: [
                            {
                                bSortable: false,
                                aTargets: [0, 4, 5, 6, 7, -1]
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
                };
                function kolektorDataTablesOptions(elementIdParent, elementId, servletName, dataFor, callBackDataTables) {
                    var datafilter = "";
                    var privUpdate = "";
                    var searchForm = $('#KOLEKTOR_SEARCH_PARAM');
                    var url = "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FOR=" + dataFor + "&" + searchForm.serialize();
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({
                        "bDestroy": true,
                        "searching": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "order": [[1]],
                        "pagingType":"simple",
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
                                        "sLast ": "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                        "sNext ": "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                        "sPrevious ": "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                            }
                        },
                        "bServerSide": true,
                        "sAjaxSource": url,
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
                };
                
                function runDataTable() {
                    dataTablesOptions("#data-kredit-table-parent", "data-kredit-table", "AjaxKredit", "listKreditKolektabilitas", null);
                };               
                function runKolektorDataTable() {
                    kolektorDataTablesOptions("#data-kolektor-table-parent", "data-kolektor-table", "AjaxAnggota", "listAssignKolektor", null);
                };
                
                runDataTable();
                
                $('body').on('click', '.assign-kolektor', function(){
                    let kolektor = $(this).data('kolektor');
                    let pinjaman = $(this).data('pinjaman');
                    let namaKonsumen = $(this).data('konsumen');
                    let noKredit = $(this).data('no-kredit');
                    let noAnggota = $(this).data('no-konsumen');
                    modalKolektor.modal('show');
                    modalKolektor.on('shown.bs.modal', function(){
                        modalKolektor.find(".modal-body #PREV_KOLEKTOR").val(kolektor);
                        modalKolektor.find(".modal-footer #PINJAMAN_ID").val(pinjaman);
                        modalKolektor.find(".modal-header #nama-konsumen").html(namaKonsumen);
                        modalKolektor.find(".modal-header #no-kredit").html(noKredit);
                        modalKolektor.find(".modal-header #no-konsumen").html(noAnggota);
                        runKolektorDataTable();
                    });
                });
                                
                $('body').on('change', '#POSITION_ID', function(){
                    runKolektorDataTable();
                });
                $('body').on('change', '#LOKASI_KOLEKTOR', function(){
                    runKolektorDataTable();
                });
                $('body').on('keyup', '#NO_KREDIT', function(){
                    runDataTable();
                });
                $('body').on('change', '#KOLEKTABILITAS_ID', function(){
                    runDataTable();
                });
                
                $('body').on('click', '.pilih-kolektor', function(){
                    let name = $(this).data('name');
                    let oid = $(this).val();
                    
                    modalKolektor.find(".modal-body #NEW_KOLEKTOR").val(name);
                    modalKolektor.find(".modal-footer #NEW_KOLEKTOR_ID").val(oid);
                    
                });
                $('body').on('click', '#simpan-kolektor-baru', function(){
                    let btnHtml = $(this).html();
                    $(this).html("Tunggu...").attr({"disabled": "true"});
                    let command = "<%= Command.SAVE %>";
                    let pinjaman = $('#PINJAMAN_ID').val();
                    let kolektor = $('#NEW_KOLEKTOR_ID').val();
                    
                    let dataSend = {
                        "command": command,
                        "FRM_FIELD_DATA_FOR": "updateKolektorBaru",
                        "PINJAMAN_ID": pinjaman,
                        "NEW_KOLEKTOR_ID": kolektor
                    };
                    
                    onDone = function(data){
                        let code = data.RETURN_ERROR_CODE;
                        let type = "";
                        if(code == 0){
                            type = "success";
                        } else {
                            type = "error";
                        }
                        fireSwal('center', type, data.RETURN_MESSAGE);
                        runDataTable();
                        $('#simpan-kolektor-baru').removeAttr('disabled').html(btnHtml);
                        modalKolektor.modal('hide');
                    };
                    onSuccess = function (data) {};
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxAnggota", null, false);
                    
                });
                
            });
        </script>
        
        <title>JSP Page</title>
    </head>
    <body style="background-color: #eaf3df;">
        
        <div class="main-page">
            <section class="content-header">
                <h1>
                    <%= textHeader[SESS_LANGUAGE][0]%>
                </h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li><%= textHeader[SESS_LANGUAGE][1]%></li>
                    <li class="active"><%= textHeader[SESS_LANGUAGE][0]%></li>
                </ol>
                
            </section>
            
            <section class="content">
                <div class="box box-success">
                    <div class="box-header with-border border-gray">
                        <h3 class="box-title"><%= textHeader[SESS_LANGUAGE][2]%></h3>
                    </div>
                    <div class="box-body">
                        <form id="SEARCH_FORM">
                            <input type="hidden" name="LOKASI_ID" value="<%= userLocationId %>">
                            <div class="row">
                                <div class="col-sm-4">
                                    <div class="form-group">
                                        <label class="control-label col-sm-4">No. Kredit</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="NO_KREDIT" name="NO_KREDIT">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="form-group">
                                        <label class="control-label col-sm-4">Kolektabilitas</label>
                                        <div class="col-sm-8">
                                            <select class="form-control" id="KOLEKTABILITAS_ID" name="KOLEKTABILITAS_ID">
                                                <%= optKolektabilitas %>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-4">
<!--                                    
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Lokasi</label>
                                    <div class="col-sm-8">
                                        <select class="form-control" id="LOKASI_ID" name="LOKASI_ID">
                                            <option value="0">Semua</option>
                                        </select>
                                    </div>
                                </div>
-->
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="box-footer">
                        <div id="data-kredit-table-parent">
                            <table id="data-kredit-table" class="table table-bordered table-hover table-striped table-angsuran">
                                <thead>
                                    <tr>
                                        <th style="width: 3%;">No</th>
                                        <th style="width: 10%;">No. Kredit</th>
                                        <th style="width: 15%;">Nama <%= namaNasabah %></th>
                                        <th style="width: 10%;">Jumlah Pinjaman</th>
                                        <th style="width: 13%;">Lokasi</th>
                                        <th style="width: 10%;">Kolektor</th>
                                        <th style="width: 5%;">Kolektabilitas</th>
                                        <th style="width: 5%;">Aksi</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        
        <div id="modal-assign-kolektor" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">                
                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">
                            <span class="text-bold">Assign Kolektor</span> | 
                            No Kredit : <span id="no-kredit"></span> &nbsp;&nbsp;&nbsp;
                            Nama <%= namaNasabah %> : <span id="nama-konsumen"></span> &nbsp;(<span id="no-konsumen"></span>)
                        </h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-sm-4">
                                <div class="row">
                                    <form id="KOLEKTOR_SEARCH_PARAM">
                                        <div class="col-sm-12">
                                            <div class="box box-success">
                                                <div class="box-header">
                                                    <h4 class="box-title">Form Pencarian</h4>
                                                </div>
                                                <div class="box-body">
                                                    <div class="form-group">
                                                        <label for="POSITION_ID">Position</label>
                                                        <select class="form-control" name="POSITION_ID" id="POSITION_ID">
                                                            <%= optPosition %>
                                                        </select>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="LOKASI_KOLEKTOR">Lokasi</label>
                                                        <select class="form-control" name="LOKASI_KOLEKTOR" id="LOKASI_KOLEKTOR">
                                                            <%= optLocation %>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="box box-success">
                                            <div class="box-header">
                                                <h4 class="box-title">Ringkasan</h4>
                                            </div>
                                            <div class="box-body">
                                                <div class="form-group">  
                                                    <label>Kolektor Sebelumnya</label>
                                                    <input type="text" class="form-control" id="PREV_KOLEKTOR" readonly="">
                                                </div> 
                                                <div class="form-group">
                                                    <label>Kolektor Baru</label>
                                                    <input type="text" class="form-control" id="NEW_KOLEKTOR" readonly="">
                                                </div> 
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                            </div>
                            <div class="col-sm-8">
                                <div class="box box-success">
                                    <div class="box-header">
                                        <h4 class="box-title">Data Table</h4>
                                    </div>
                                    <div class="box-body">
                                        <div class="box-inner-scroll">
                                            <div class="data-kolektor-table-parent" style="width:97%;">
                                                <table id="data-kolektor-table"
                                                       class="table table-bordered table-hover table-striped table-angsuran">
                                                    <thead>
                                                        <tr>
                                                            <th style="width: 1%">No.</th>
                                                            <th style="width: 30%">Nomor Pegawai</th>
                                                            <th style="width: 55%">Nama</th>
                                                            <th style="width: 9%">Aksi</th>
                                                        </tr>
                                                    </thead>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="hidden" id="NEW_KOLEKTOR_ID" value="">
                        <input type="hidden" id="PINJAMAN_ID" value="">
                        <button type="button" class="btn btn-sm btn-danger" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Tutup</button>
                        <button type="button" id="simpan-kolektor-baru" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                    </div>
                </div>

            </div>
        </div> 
                                        
    </body>
</html>
