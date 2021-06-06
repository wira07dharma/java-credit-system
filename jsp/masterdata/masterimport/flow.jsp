<%-- 
    Document   : flow
    Created on : 15-Mar-2018, 15:25:33
    Author     : Gunadi
--%>

<%@page import="com.dimata.common.entity.excel.FlowModul"%>
<%@page import="com.dimata.common.form.excel.CtrlFlowModul"%>
<%@page import="com.dimata.common.form.excel.FrmFlowModulMapping"%>
<%@page import="com.dimata.tools.db.MetaData"%>
<%@page import="com.dimata.tools.db.MetaDataBuilder"%>
<%@page import="com.dimata.common.entity.excel.PstFlowModul"%>
<%@page import="com.dimata.common.form.excel.FrmFlowModul"%>
<%@page import="com.dimata.common.entity.excel.PstFlowGroup"%>
<%@page import="com.dimata.common.entity.excel.FlowGroup"%>
<%@page import="com.dimata.util.Command"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
    long oidFlow = FRMQueryString.requestLong(request, "flow_id");
    int iCommand = FRMQueryString.requestCommand(request);
    
    CtrlFlowModul ctrlFlowModul = new CtrlFlowModul(request);
    FlowModul flowModul = new FlowModul();
    int iErrCode = FRMMessage.NONE;
    
    iErrCode = ctrlFlowModul.action(iCommand, oidFlow);
    flowModul = ctrlFlowModul.getFlow();
%>
<html>
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style>
            th {
              text-align: center;
              font-weight: normal;
              vertical-align: middle !important;
              background-color: #00a65a;
              color: white;
              padding-right: 8px !important;
            }
            th:after {display: none !important;}
            .aksi {width: 1% !important}
          </style>
        <script type="text/javascript">
            function getCmd(){
                document.form_flow.action = "flow.jsp";
                document.form_flow.submit();
            }
            function cmdSave() {
                document.form_flow.command.value = "<%=Command.SAVE%>";
                getCmd();
            }
        </script>
        <script language="javascript">
            $(document).ready(function() {
                var approot="<%=approot%>";
                
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
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "oLanguage": {
                            "oPaginate": {
                                "sFirst ": "<%=dataTableTitle[SESS_LANGUAGE][6]%>",
                                "sLast ":  "<%=dataTableTitle[SESS_LANGUAGE][7]%>",
                                "sNext ":  "<%=dataTableTitle[SESS_LANGUAGE][8]%>",
                                "sPrevious ":   "<%=dataTableTitle[SESS_LANGUAGE][9]%>"
                            },
                            "sProcessing": "<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div>",
                            "sLengthMenu": "<%=dataTableTitle[SESS_LANGUAGE][0]%>",
                            "sZeroRecords": "<%=dataTableTitle[SESS_LANGUAGE][1]%>",
                            "sInfo": "<%=dataTableTitle[SESS_LANGUAGE][2]%>",
                            "sInfoEmpty": "<%=dataTableTitle[SESS_LANGUAGE][3]%>",
                            "sInfoFiltered": "<%=dataTableTitle[SESS_LANGUAGE][4]%>",
                            "sSearch": "<%=dataTableTitle[SESS_LANGUAGE][5]%>"
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>",
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
                }
                
                callBackDataTables = function(){
                    $('.btn_edit').click(function() {
                        $(this).attr({"disabled": "true"}).html("....");
                        var oid = $(this).data('oid');
                        window.location = "../masterimport/flow.jsp?flow_id="+oid+"&command=<%=Command.EDIT%>";
                      });

                      $('.btn_delete').unbind('click').click(function() {
                        var currentHtml = $(this).html();
                        $(this).attr({"disabled": "true"}).html("...");
                        var confirmTextSingle = "Hapus Data?";
                         if (confirm(confirmTextSingle)) {
                             var oid = ($(this).data('oid'));
                            window.location = "../masterimport/flow.jsp?flow_id="+oid+"&command=<%=Command.DELETE%>";
                        } else {
                            $(this).removeAttr("disabled").html(currentHtml);
                        }
                      });
                      <%
                        if (iCommand == Command.EDIT){
                      %>
                            loadTable();
                      <%
                        }
                      %>
                }

                function runDataTable() {
                    dataTablesOptions("#flowTableElement", "tableFlowTableElement", "AjaxFlowModul", "listFlow", callBackDataTables);
                }
                
                //MODAL SETTING
                var modalSetting = function (elementId, backdrop, keyboard, show) {
                    $(elementId).modal({
                        backdrop: backdrop,
                        keyboard: keyboard,
                        show: show
                    });
                };

                runDataTable();
                
                
                $('#btn_add_new').click(function() {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../masterimport/flow.jsp?flow_id=0&command=<%=Command.ADD%>";
                  });
                  
                  
                  
                  var appendTable = function(elementId){
                        $(elementId).click(function(){
                            var jumlah = $('#jumlah_col').val();
                            var tabel = $('#nmTabel').val();
                            jumlah = Number(jumlah) + 1;
                            var command = "<%=Command.NONE%>";
                            var dataFor = "appendTable";
                            
                            $('#LIST_FIELD').append("<td class='tdProgress' colspan='6'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div></td>")

                            var dataSend = {
                                "jumlah": jumlah,
                                "table": tabel,
                                "FRM_FIELD_DATA_FOR":dataFor
                            }
                            var onDone = function(data){
                                $(".tdProgress").remove();
                                $('#jumlah_col').val(jumlah);
                                $('#LIST_FIELD').append(data.RETURN_HTML);
                                $('.select2').select2();
                                $('#selectCol').change(function () {
                                    if ($(this).closest('table').find('option[value=' + $(this).val() + ']:selected').length > 1)
                                    {
                                        alert('Field Sudah Ada');
                                        $(this).val($(this).find("option:first").val());
                                        $(this).val("-1").trigger("change");;
                                    }
                                });

                                $('body').unbind('click').on('click', '.btn_remove_col', function () {
                                    var nilaiJumlah = $(this).data('row');
                                    var oid = $(this).data('oid');
                                    if (oid === 0){
                                        alert("oh no");
                                        $('#field' + nilaiJumlah).remove();
                                    } else {
                                        alert("else");
                                        deleteMapping(oid);
                                    }
                                    
                                });
                                $('body').on('change', '#selectCol', function () {
                                    var nilaiJumlah = $(this).data('row');
                                    var dataType = $('option:selected', this).attr('data-type');
                                    $('#dataType' + nilaiJumlah).val(dataType);
                                });
                                $('body').on('change', '#selectType', function () {
                                    var value = $(this).val();
                                    var nilaiJumlah = $(this).data('row');
                                    var oid = 0;
                                    if (value==="2"){
                                       getTabelMeta(nilaiJumlah);
                                    } else if (value=="1"){
                                       $('#tdDataList'+nilaiJumlah).html("<strong>*) Simpan terlebih dahulu untuk menambah data</strong>");
                                       $('#tdDataList'+nilaiJumlah).append("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TABLE]%>'>");
                                       $('#tdDataList'+nilaiJumlah).append("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_COLUMN]%>'>");
                                       $('#tdDataList'+nilaiJumlah).append("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_VALUE]%>'>");
                                    } else {
                                       $('#tdDataList'+nilaiJumlah).html("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TABLE]%>'>");
                                       $('#tdDataList'+nilaiJumlah).append("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_COLUMN]%>'>");
                                       $('#tdDataList'+nilaiJumlah).append("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_VALUE]%>'>");
                                    }
                                });
                                
                                
                                
                            };
                            var onSuccess = function(data){

                            };
                            getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxFlowModul", null, false);
                      });
                  };
                  
                var loadTable = function(){     
                    $('.divtable').html("<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div>")
                        var tabel = $('#selTabel').find(":selected").val();
                        var oid = $('#flow_id').val();
                        $('#nmTabel').val(tabel);
                        var command = "<%=Command.NONE%>";
                        var dataFor = "showTable";

                        var dataSend = {
                            "table": tabel,
                            "FRM_FIELD_DATA_FOR":dataFor,
                            "flow_id":oid
                        }

                        var onDone = function(data){
                            $('.divTable').html(data.RETURN_HTML);
                            appendTable("#btn_add_column");
                            $('.select2').select2();
                            $('#btn_save').removeAttr("disabled");
                            $('body').unbind('click').on('click', '.btn_remove_col', function () {
                                    var nilaiJumlah = $(this).data('row');
                                    var oid = $(this).data('oid');
                                    if (oid === 0){
                                        alert("oh no");
                                        $('#field' + nilaiJumlah).remove();
                                    } else {
                                        alert("else");
                                        deleteMapping(oid);
                                    }
                                    
                                });
                            $('body').on('change', '#selectType', function () {
                                var value = $(this).val();
                                var nilaiJumlah = $(this).data('row');
                                var oid = $(this).data('oid');
                                
                                if (value==="2"){
                                   getTabelMeta(nilaiJumlah);
                                } else if (value=="1"){
                                    $('#tdDataList'+nilaiJumlah).html("<button type=\"button\" data-row=\""+nilaiJumlah+"\" data-oid=\""+oid+"\" class=\"btn btn-sm btn-success btn_add\"><i class=\"fa fa-plus\"></i> Tambah Data List</button>");
                                    $('#tdDataList'+nilaiJumlah).append("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TABLE]%>'>");
                                    $('#tdDataList'+nilaiJumlah).append("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_COLUMN]%>'>");
                                    $('#tdDataList'+nilaiJumlah).append("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_VALUE]%>'>");
                                    showModalData('.btn_add');
                                } else {
                                    $('#tdDataList'+nilaiJumlah).html("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_TABLE]%>'>");
                                    $('#tdDataList'+nilaiJumlah).append("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_COLUMN]%>'>");
                                    $('#tdDataList'+nilaiJumlah).append("<input type='hidden' class='form-control' name='<%=FrmFlowModulMapping.fieldNames[FrmFlowModulMapping.FRM_FIELD_DATA_VALUE]%>'>");
                                }
                            });
                            $('body').on('change', '#selectTable', function () {
                                var value = $(this).val();
                                var nilaiJumlah = $(this).data('row');
                                getColumnMeta(value,nilaiJumlah);
                            });
                            showModalData('.btn_add');
                        };

                        var onSuccess = function(data){

                        };
                        getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxFlowModul", null, false);
                }
                
                    var getTabelMeta = function(nilaiJumlah){     
                        $('#tdDataList'+nilaiJumlah).html("<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div>")
                            var command = "<%=Command.NONE%>";
                            var dataFor = "getTabelMeta";
                            
                            var dataSend = {
                                 "FRM_FIELD_DATA_FOR":dataFor,
                                 "jumlah":nilaiJumlah
                            }

                            var onDone = function(data){
                                $('#tdDataList'+nilaiJumlah).html(data.RETURN_HTML);
                                $('.select2').select2();
                                $('body').on('change', '#selectTable', function () {
                                    var value = $(this).val();
                                    var nilaiJumlah = $(this).data('row');
                                    getColumnMeta(value,nilaiJumlah);
                                });
                            };

                            var onSuccess = function(data){

                            };
                            getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxFlowModul", null, false);
                    }
                    var getColumnMeta = function(tabel,nilaiJumlah){     
                        $('#colContainer'+nilaiJumlah).html("<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div>");
                            var command = "<%=Command.NONE%>";
                            var dataFor = "getColumnMeta";
                            var dataSend = {
                                 "FRM_FIELD_DATA_FOR":dataFor,
                                 "jumlah":nilaiJumlah,
                                 "table":tabel
                            }

                            var onDone = function(data){
                                $('#colContainer'+nilaiJumlah).html(data.RETURN_HTML);
                                $('.select2').select2();
                            };

                            var onSuccess = function(data){

                            };
                            getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxFlowModul", null, false);
                    }
                  
                  $( "#selTabel" ).change(function() {
                        loadTable();
                  });
                  
                   $('.select2').select2();
                   
                   //FORM SUBMIT
                $("form#form_flow").submit(function(){
                    var currentBtnHtml = $("#btn_save").html();
                    var command = "<%=Command.SAVE%>";
                    $("#btn_save").html("Saving...").attr({"disabled":"true"});

                    var onDone = function(data){
                        $("#btn_save").removeAttr("disabled").html(currentBtnHtml);
                         window.location.href = "../masterimport/flow.jsp";
                    };


                    if($(this).find(".has-error").length == 0){
                        var onSuccess = function(data){

                        };

                        var dataSend = $(this).serialize();
                        getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxFlowModul", null, false);
                    }else{
                        $("#btngeneralform").removeAttr("disabled").html(currentBtnHtml);
                    }

                    return false;
                });
                
                var showModalData = function(elementId){
                    $('body').on('click', elementId, function () {
                        modalSetting("#modal-addDataList", "static", false, false);
                        $('#modal-addDataList').modal('show');
                        var dataFor = "getDataList";
                        var oid = $(this).data("oid");
                        var command = <%=Command.NONE%>;

                        $("#form-data #oid").val(oid);

                        var dataSend = {
                            "flow_id": oid,
                            "FRM_FIELD_DATA_FOR" : dataFor
                        }
                        var onDone = function(data){
                            $('.data-body').html(data.RETURN_HTML);
                            appendDataList("#btn_add_data");
                            $('body').unbind('click').on('click', '.btn_remove_datalist', function () {
                                var nilaiJumlah = $(this).data('row');
                                var oid = $(this).data('oid');
                                    if (oid === 0){
                                        alert("oh no");
                                        $('#data' + nilaiJumlah).remove();
                                    } else {
                                        alert("else");
                                        deleteDataList(oid,nilaiJumlah);
                                    }
                            });
                        };
                        var onSuccess = function(data){

                        };
                        getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxFlowModul", ".data-body", false);
                  });
              };
              
              var appendDataList = function(elementId){
                    $(elementId).click(function(){
                        var jumlah = $('#jumlah_data').val();
                        jumlah = Number(jumlah) + 1;
                        var command = "<%=Command.NONE%>";
                        var dataFor = "appendData";

                        $('#DATA_LIST').append("<td class='tdProgress' colspan='6'><div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div></td>")

                        var dataSend = {
                            "jumlah": jumlah,
                            "FRM_FIELD_DATA_FOR":dataFor
                        }
                        var onDone = function(data){
                            $(".tdProgress").remove();
                            $('#jumlah_data').val(jumlah);
                            $('#DATA_LIST').append(data.RETURN_HTML);
                            

                            $('body').unbind('click').on('click', '.btn_remove_datalist', function () {
                                var nilaiJumlah = $(this).data('row');
                                var oid = $(this).data('oid');
                                    if (oid === 0){
                                        alert("oh no");
                                        $('#data' + nilaiJumlah).remove();
                                    } else {
                                        alert("else");
                                        deleteDataList(oid,nilaiJumlah);
                                    }
                            });

                        };
                        var onSuccess = function(data){

                        };
                        getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxFlowModul", null, false);
                  });
              };
              
              $("form#form-data").submit(function(){
                    var currentBtnHtml = $("#btn-simpan-data").html();
                    $("#btn-simpan-data").html("Menyimpan...").attr({"disabled":"true"});
                    var command = "<%=Command.SAVE%>";
                    
                    var onDone = function(data){
			
		    };
                    
                    if($(this).find(".has-error").length == 0){
                        var onSuccess = function(data){
                            $("#btn-simpan-data").removeAttr("disabled").html(currentBtnHtml);
                            $("#modal-addDataList").modal("hide");
                        };

                        var dataSend = $(this).serialize();
                        getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxFlowModul", null, false);
                    }else{
                        $("#btn-simpan-data").removeAttr("disabled").html(currentBtnHtml);
                    }

                    return false;
                });
                
                var deleteMapping = function(oid){     
                    var command = "<%=Command.DELETE%>";
                    var dataFor = "deleteMapping";
                    var dataSend = {
                         "FRM_FIELD_DATA_FOR":dataFor,
                         "flow_id":oid,
                         "command":command
                    }

                    var onDone = function(data){
                        loadTable();
                    };

                    var onSuccess = function(data){

                    };
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxFlowModul", null, false);
                }
                
                var deleteDataList = function(oid,nilaiJumlah){     
                    var command = "<%=Command.DELETE%>";
                    var dataFor = "deleteDataList";
                    var dataSend = {
                         "FRM_FIELD_DATA_FOR":dataFor,
                         "flow_id":oid,
                         "command":command
                    }

                    var onDone = function(data){
                        $('#data' + nilaiJumlah).remove();
                    };

                    var onSuccess = function(data){

                    };
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxFlowModul", null, false);
                }
                    
                    
            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
              Flow
              <small></small>
            </h1>
            <ol class="breadcrumb">
              <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
              <li>Master Bumdesa</li>
              <li class="active">Flow Group</li>
            </ol>
        </section>
        
        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border" style="border-color: lightgray">
                    <h3 class="box-title">Daftar Flow</h3>
                </div>

                <p></p>
                <div class="box-body">
                    <div id="flowTableElement" class="">
                            <table class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th style="width: 1%">No.</th>                                    
                                        <th>Flow Group</th>
                                        <th>Nama Modul</th>
                                        <th>Tabel</th>
                                        <th>Level</th>
                                        <th style="width: 10%">Aksi</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                </div>
                <div class="box-footer" style="border-color: lightgray">
                    <button type="button" class="btn btn-sm btn-primary" id="btn_add_new"><i class="fa fa-plus"></i> &nbsp; Tambah Data</button>
                </div>
            </div>
            
            <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>
            <div class="box box-success">
                <div class="box-header with-border" style="border-color: lightgrey">                    
                    <h3 class="box-title">Form Input Flow</h3>
                </div>
                <p></p>
                
                <form id="form_flow" name="form_flow" class="form-horizontal" method="POST" action="">
                    <input type="hidden" value="<%=oidFlow%>" name="flow_id" id="flow_id">
                    <input type="hidden" name="command"  value="<%=Command.SAVE%>" />
                    <div class="box-body">
                        <div class="col-sm-12">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Flow Group</label>
                                    <div class="col-sm-8">
                                        <select name="<%=FrmFlowModul.fieldNames[FrmFlowModul.FRM_FIELD_FLOW_GROUP_ID]%>" class="form-control">
                                            <%
                                                Vector listFlowGroup = PstFlowGroup.listAll();
                                                if (listFlowGroup.size()>0){
                                                    for (int i=0;i<listFlowGroup.size();i++){
                                                        FlowGroup flowGroup = (FlowGroup) listFlowGroup.get(i);
                                                        String selected = "";
                                                        if (flowModul.getFlowGroupId() == flowGroup.getOID()){
                                                            selected = "selected";
                                                        }
                                                        %>
                                                            <option value="<%=flowGroup.getOID()%>" <%=selected%>><%=flowGroup.getFlowGroupName()%></option>
                                                        <%
                                                    }
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Nama Modul</label>
                                    <div class="col-sm-8">
                                        <input type="text" name="<%=FrmFlowModul.fieldNames[FrmFlowModul.FRM_FIELD_FLOW_MODUL_NAME]%>" class="form-control" value="<%=flowModul.getFlowModulName()%>"/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Tabel</label>
                                    <div class="col-sm-8">
                                        <select class="select2" id="selTabel" name="<%=FrmFlowModul.fieldNames[FrmFlowModul.FRM_FIELD_FLOW_MODUL_TABLE]%>" class="form-control">
                                            <%
                                                Vector listTable = MetaDataBuilder.getAllTables();
                                                session.putValue("listTable", listTable);
                                                if (listTable.size()>0){
                                                    for (int i=0; i < listTable.size(); i++){
                                                        String tblName = (String) listTable.get(i);
                                                        String selected = "";
                                                        if (flowModul.getFlowModulTable().equals(tblName)){
                                                            selected = "selected";
                                                        }
                                                        %>
                                                            <option value="<%=tblName%>" <%=selected%>><%=tblName%></option>
                                                        <%
                                                    }
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>     
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Level</label>
                                    <div class="col-sm-8">
                                        <select name="<%=FrmFlowModul.fieldNames[FrmFlowModul.FRM_FIELD_FLOW_LEVEL]%>" class="form-control">
                                            <%
                                                for (int i=0; i<10;i++){
                                                    int lvl = i+1;
                                                    String selected = "";
                                                    if (flowModul.getFlowLevel() == lvl){
                                                        selected = "selected";
                                                    }
                                                    %>
                                                        <option value="<%=lvl%>" <%=selected%>><%=lvl%></option>
                                                    <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>    
                            </div>
                            
                            <div class="col-md-12 divTable">
                                
                            </div>
                        </div>
                    </div>
                    <div class="box-footer" style="border-color: lightgrey">
                        <div class="form-group" style="margin-bottom: 0px">
                          <div class="col-sm-2"></div>
                          <div class="col-sm-4">
                            <div class="pull-right">
                              <button disabled id="btn_save" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                              <button type="button" id="" class="btn btn-sm btn-default btn_cancel"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                            </div>
                          </div>
                        </div>
                    </div>
                </form>
            </div>
        <% } %>
        </section>
        
        <div id="modal-addDataList" class="modal fade" role="dialog">
            <div class="modal-dialog modal-lg">                
                <!-- Modal content-->
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Tambah Data List</h4>
                    </div>

                    <form id="form-data" enctype="multipart/form-data">
                        <input type="hidden" name="FRM_FIELD_DATA_FOR" id="datafor" value='saveDataList'>
                        <input type="hidden" name="command" value="<%= Command.SAVE%>">
                        <input type="hidden" name="FRM_FIELD_OID" id="oid">
                        <div class="modal-body">
                            <div class="box-body data-body">
                                    
                            </div>
                        </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-sm btn-success" id="btn-simpan-data"><i class="fa fa-save"></i> &nbsp; Simpan</button>
                    </div>
                </form>
                </div>

            </div>
        </div>   
    </body>
</html>
