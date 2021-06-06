<%-- 
    Document   : list_kredit
    Created on : Jul 17, 2017, 5:08:21 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%@page import="com.dimata.sedana.print.component.PrintUtility"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%!
    public static String textHeader[][] = {
        {"Dokumen Kredit", "Kredit"},
        {"Document Kredit", "Kredit"}
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
<%  //  
    long tellerShiftId = 0;
    String optLocation = "";
    String optAll = "<option value='0'>Semua</option>";
    int iCommand = FRMQueryString.requestCommand(request);
    Location loc = new Location();
    if(userLocationId != 0){
        loc = PstLocation.fetchFromApi(userLocationId);
    }
    
    Vector<Location> listLocation = PstLocation.getListFromApi(0, 0, "", "");
    int index = 0;
    for(Location l : listLocation){
        boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userSession.getAppUser().getOID(), ""+l.getOID());
//        if(index == 0){
//            optLocation += optAll;
//        } 
        if (l.getOID() == userSession.getAppUser().getAssignLocationId() || isExistDataCustom){
            optLocation += "<option value='" + l.getOID() + "'>" + l.getName() + "</option>";
        }
        index++;
    }
	
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@include file="../../style/style_kredit.jsp" %>
                
        <style>
            
            .btn-dokumen{
                width: 100%;
                margin-bottom: 5%;
            }
            .lds-dual-ring {
                display: inline-block;
            }
            .lds-dual-ring:after {
                content: " ";
                display: block;
                width: 80px;
                height: 80px;
                margin: 8px;
                border-radius: 50%;
                border: 10px solid #00a65a;
                border-color: #00a65a transparent #00a65a transparent;
                animation: lds-dual-ring 1.2s linear infinite;
            }
            @keyframes lds-dual-ring {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }
            
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            th:after {display: none !important;}
            .modal-header, .modal-footer {padding-bottom: 10px; padding-top: 10px !important}
            
            

            print-area { visibility: hidden; display: none; }
            print-area.preview { visibility: visible; display: block; }

            @media print
            {
                body .main-page *, body .modal * { visibility: hidden; display: none; } 
                body print-area * { visibility: visible; }
                body print-area   { visibility: visible; display: unset !important; position: static; top: 0; left: 0; }
                body #print-kartu-angsuran {
                    width: 214mm;
                    height: 190mm;
                }
                body #print-kartu-angsuran .print-area-margin {
                    margin: 20px;
                }
                #print-kartu-angsuran .print-content {
                    width: 100%;
                }
                #print-header {
                    width: 100%;
                }
                #print-kartu-angsuran .print-header tr{
                    vertical-align: top;
                }
                /* .print-area .print-content, .print-area .print-content tr, .print-area .print-content td {
                    border: 1pt solid black;
                } */
                #print-kartu-angsuran .print-content td{
                    text-align: center;
                    border: 1pt solid black;
                }
            }
            
        </style>
        <script>
            $(document).ready(function () {
                let paramForm = $('#dokumen-param-form');
                let modalDokumen = $('#dokumen-kredit-modal');
                let placeholderNasabah = JSON.parse('{ "id": "0", "text": "-- Semua <%= namaNasabah %> --"}');
                let loadingBar = "<div class='text-center'><div id='loading-spinner' class='lds-dual-ring'></div></div>";
                
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
                    var datafilter = "";
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
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
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor 
                                + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>" + "&SEND_USER_ID=<%=userOID%>" 
                                + "&" + paramForm.serialize(),
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
                        },
                        "fnPageChange": function (oSettings) {

                        }
                    });
                    $(elementIdParent).find("#" + elementId + "_filter").find("input").addClass("form-control");
                    $(elementIdParent).find("#" + elementId + "_length").find("select").addClass("form-control");
                    $("#" + elementId).css("width", "100%");
                }

                function runDataTable() {
                    dataTablesOptions("#pinjamanTableElement", "tablePinjamanTableElement", "AjaxKredit", "listDokumenKonsumen", null);
                }

                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };
                
                function showModalDokumen(oidPinjaman){
                    modalDokumen.modal('show'); 
                    modalDokumen.on('shown.bs.modal', function(){
                        var dataSend = {
                            "FRM_FIELD_OID"         : oidPinjaman,
                            "FRM_FIELD_DATA_FOR"    : "getDokumenKreditButton",
                            "command"               : "<%= Command.NONE %>"
                        };
                        onDone = function (data) {
                            modalDokumen.find('.modal-body #daftar-dokumen').html(data.FRM_FIELD_HTML);
                        };
                        onSuccess = function (data) {
                        };
                        //alert(JSON.stringify(dataSend));
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    });
                    
                }
                
                modalSetting('#dokumen-kredit-modal', 'static', false, false);
                
                $('#id_nasabah').select2({
                    placeholder:placeholderNasabah,
                    ajax: {
                        url : "<%= approot %>/AjaxAnggota?command=<%= Command.LIST %>&FRM_FIELD_DATA_FOR=select2Anggota",
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
                                    more: (ph.CURRENT_PAGE * ph.ITEM_PER_PAGE) < data.ANGGOTA_TOTAL
                                }
                            };
                        },
                        cache: true
                    }
                });
                
                $('body').on('change', '#id_nasabah, #id_lokasi', function(){
                    runDataTable();
                });
                $('body').on('keyup', '#no_kredit', function(){
                    runDataTable();
                });
                
                $('body').on('click', '.lihat-dokumen', function(){
                    let oid = $(this).data('pinjaman');
                    modalDokumen.find('.modal-header .judul').html("Pilih Dokumen");
                    modalDokumen.find('.modal-body #daftar-dokumen').html(loadingBar);
                    showModalDokumen(oid);
                });
                
                $('body').on('click', '.show-dokumen', function(){
                   let type = $(this).data('type');
                   let oid = $(this).data('oid');
                   
                   let url = "<%=approot%>/masterdata/masterdokumen/dokumen_edit.jsp?oid_pinjaman="+oid+"&type="+type;
                   let name = 'Dokumen Kredit';
                   let features = 'location=yes,height=650,width=1000,scrollbars=yes,status=yes';
                   
                   window.open(url, name, features);
                });
                
                $('body').on('click', '.kartu-angsuran', function(){
                    let oid = $(this).data('oid');
                   
                    let btnHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu...");
                    Swal.fire({
                        position: 'center',
                        icon: 'warning',
                        title: "Cetak Kartu Angsuran <%= namaNasabah %>",
                        html: "Yakin mencetakan Catatan Pembayaran?", //<br>Anda tidak dapat melakukan pencetakan<br><strong>yang sama lebih dari 1 kali.</strong>
                        text: "Yakin mencetakan Catatan Pembayaran?", //Anda tidak dapat melakukan pencetakan yang sama lebih dari 1 kali.
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Yakin',
                        cancelButtonText: 'Tidak',
                        customClass: swalClasses
                    }).then((result) => {
                        if (result.value) {
                            var dataSend = {
                                "FRM_FIELD_OID"         : oid,
                                "FRM_FIELD_DATA_FOR"    : "cetakKartuAngsuran",
                                "printDuplicate"        : "<%= JadwalAngsuran.CETAK_NORMAL%>",
                                "command"               : "<%= Command.NONE%>"
                            };
                            onDone = function (data) {
                                let html = data.FRM_FIELD_HTML;
                                let dataAngsuran = data.FRM_FIELD_HTML_DATA_ANGSURAN;
                                console.log(html);
                                console.log(dataAngsuran);
                                $('#print-kartu-angsuran #print-content').html(html);

                                $('#print-kartu-angsuran').show();

                                window.print();

                                $('.kartu-angsuran').removeAttr('disabled').html(btnHtml);
                            };
                            onSuccess = function (data) {
                            };
                            //alert(JSON.stringify(dataSend));
                            getDataFunction(onDone, onSuccess, dataSend, "AjaxJadwalAngsuran", null, false);
                        } else {
                            $('.kartu-angsuran').removeAttr('disabled').html(btnHtml);

                        }
                    });
                    
                });
                
                runDataTable();
            });
        </script>

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
                    <div class="box-header with-border" style="border-color: lightgray">
                        <form id="dokumen-param-form">
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="col-sm-3">
                                        <div class="form-group">
                                            <label class="control-label col-sm-4">Nomor Kredit</label>
                                            <div class="col-sm-8">
                                                <input type="text" class="form-control" id="no_kredit" name="NO_KREDIT">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-5">
                                        <div class="form-group">
                                            <label class="control-label col-sm-3"><%= PrintUtility.capitalizeWord(namaNasabah)%></label>
                                            <div class="col-sm-9">
                                                <select style="width: 100%; " id="id_nasabah" class="form-control" name="NASABAH_ID"></select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label class="control-label col-sm-2">Lokasi</label>
                                            <div class="col-sm-10">
                                                <select style="width: 100%;" class="form-control" id="id_lokasi" name="LOKASI_ID"><%= optLocation%></select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="box-body">
                        <div id="pinjamanTableElement">
                            <table class="table table-striped table-bordered table-responsive" style="font-size: 14px">
                                <thead>
                                    <tr>
                                        <th style="width: 5%;">No.</th>                                    
                                        <th style="width: 15%;">Nomor Kredit</th>
                                        <th style="width: 40%;">Nama <%=namaNasabah%></th>
                                        <th style="width: 20%;">Lokasi</th>
                                        <th style="width: 15%;">Dokumen</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>

                    </div>

                </div>
            </section>
        </div>                
        <!--------------------------------------------------------------------->
        
        <div id="dokumen-kredit-modal" class="modal fade" role="dialog">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    
                    <div class="modal-header">
                        <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title judul">Judul</h4>
                    </div>
                    
                    <div class="modal-body">
                        <div id="daftar-dokumen">
                            
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">Tutup</button>
                    </div>
                    
                </div>
            </div>
        </div>
        
        <!--------------------------------------------------------------------->
        
        <print-area>
            <div id="print-kartu-angsuran">
                <div id="print-content">

                </div>
            </div>
        </print-area>

    </body>
</html>
