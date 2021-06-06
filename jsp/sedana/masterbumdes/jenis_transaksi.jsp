<%-- 
    Document   : jenis_transaksi
    Created on : Aug 15, 2017, 11:27:28 AM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksiMapping"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksiMapping"%>
<%@page import="com.dimata.sedana.form.tabungan.FrmJenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksi"%>
<%@ page import = "com.dimata.util.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%//
    int iCommand = FRMQueryString.requestCommand(request);
    long oid = FRMQueryString.requestLong(request, "oid");

    String errorMessage = "";
    JenisTransaksi jenisTransaksi = new JenisTransaksi();
    if (iCommand == Command.EDIT && oid != 0) {
        try {
            jenisTransaksi = PstJenisTransaksi.fetchExc(oid);
        } catch (Exception e) {
            System.out.println(e);
        }
    } else if (iCommand == Command.EDIT && oid == 0) {
        errorMessage = "Terjadi kesalahan !";
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
        <script src="../../style/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
        <script src="../../style/datatables/jquery.dataTables.js" type="text/javascript"></script>
        <script src="../../style/datatables/dataTables.bootstrap.js" type="text/javascript"></script>
        <script src="<%=approot%>/MaskMoney.js?sub=<%=userOID%>&cf=<%=Formater.formatDate(new Date(), "yyyyMMddHHmm")%>" type="text/javascript"></script>
        <style>
            th {text-align: center; font-weight: normal; vertical-align: middle !important}
            th {background-color: #00a65a; color: white; padding-right: 8px !important}
            th:after {display: none !important;}
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
                    var oid = "0";
                    var datafilter = "";
                    var privUpdate = "";
                    $(elementIdParent).find('table').addClass('table-bordered table-striped table-hover').attr({'id': elementId});
                    $("#" + elementId).dataTable({"bDestroy": true,
                        "iDisplayLength": 10,
                        "bProcessing": true,
                        "oLanguage": {
                            "sProcessing": "<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div>"
                        },
                        "bServerSide": true,
                        "sAjaxSource": "<%= approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>" + "&SEND_OID_RESERVATION=" + oid,
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

                function runDataTable() {
                    dataTablesOptions("#jenisTransaksiTableElement", "tableJenisTransaksiTableElement", "AjaxKredit", "listJenisTransaksi", null);
                }

                runDataTable();

                //action on enter
                function pressEnter(elementIdEnter, elementIdFocus) {
                    $(elementIdEnter).keypress(function (e) {
                        if (e.keyCode === 13) {
                            $(elementIdFocus).focus();
                            var atr = $(elementIdEnter).attr('required');
                            var val = $(elementIdEnter).val();
                            if (atr === "required") {
                                if (val === "") {
                                    alert("Data tidak boleh kosong !");
                                    $(elementIdEnter).focus();
                                } else {
                                    return false;
                                }
                            } else {
                                return false;
                            }
                        }
                    });
                }

                //$('#FRM_FIELD_JENIS_TRANSAKSI_ID').val();
                $('#FRM_FIELD_JENIS_TRANSAKSI').focus();
                //location.hash = '#btn_save';
                pressEnter('#FRM_FIELD_JENIS_TRANSAKSI', '#FRM_FIELD_PROSENTASE_PERHITUNGAN');
                pressEnter('#FRM_FIELD_PROSENTASE_PERHITUNGAN', '#FRM_FIELD_TIPE_ARUS_KAS');
                pressEnter('#FRM_FIELD_TIPE_ARUS_KAS', '#FRM_FIELD_TYPE_TRANSAKSI');
                pressEnter('#FRM_FIELD_TYPE_TRANSAKSI', '#FRM_FIELD_TYPE_PROSEDUR');
                pressEnter('#FRM_FIELD_TYPE_PROSEDUR', '#FRM_FIELD_PROSEDURE_UNTUK');
                pressEnter('#FRM_FIELD_PROSEDURE_UNTUK', '#FRM_FIELD_AFLIASI_ID');
                pressEnter('#FRM_FIELD_AFLIASI_ID', '#VALUE_STANDAR_TRANSAKSI');
                pressEnter('#VALUE_STANDAR_TRANSAKSI', '#btn_save');

                $('#form_jenis_transaksi').submit(function () {
                    var buttonName = $('#btn_save').html();

                    var oid = $('#FRM_FIELD_JENIS_TRANSAKSI_ID').val();
                    var command = "<%=Command.SAVE%>";
                    var dataFor = "saveJenisTransaksi";

                    //cek mapping
                    var map = [];
                    var isEmpty = true;
                    $('.map_simpanan').each(function () {
                        var check = $(this).is(':checked');
                        if (check === true) {
                            map.push({"id": $(this).val()});
                            isEmpty = false;
                        }
                    });
                    //if (isEmpty === true) {
                    //alert("Mapping tidak boleh kosong !");
                    //return false;
                    //} else {
                    $('#btn_save').attr({"disabled": "true"}).html("Tunggu...");
                    //}
                    //alert(JSON.stringify(map));
                    onDone = function (data) {
                        var error = data.RETURN_ERROR_CODE;
                        if (error === 0) {
                            alert(data.RETURN_MESSAGE);
                            window.location = "../masterbumdes/list_jenis_transaksi.jsp";
                        } else if (error === 1) {
                            alert(data.RETURN_MESSAGE);
                        }
                    };
                    onSuccess = function (data) {
                        $('#btn_save').removeAttr('disabled').html(buttonName);
                    };
                    var data = $(this).serialize();
                    var dataSend = "" + data + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command
                            + "&FRM_FIELD_OID=" + oid + "&SEND_MAP_SIMPANAN=" + JSON.stringify(map);
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxJenisTransaksi", null, false);
                    return false;
                });

                $('#btn_delete').click(function () {
                    if (confirm("Yakin ingin menghapus data ini ?")) {
                        deleteJenisTransaksi();
                    }
                });

                function deleteJenisTransaksi() {
                    var buttonName = $('#btn_delete').html();
                    $('#btn_delete').attr({"disabled": "true"}).html("Tunggu...");

                    var oid = $('#FRM_FIELD_JENIS_TRANSAKSI_ID').val();
                    var command = "<%=Command.DELETE%>";
                    var dataFor = "deleteJenisTransaksi";
                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command
                    };
                    onDone = function (data) {
                        var error = data.RETURN_ERROR_CODE;
                        if (error === 0) {
                            alert(data.RETURN_MESSAGE);
                            window.location = "../masterbumdes/jenis_transaksi.jsp";
                        } else if (error === 1) {
                            alert(data.RETURN_MESSAGE);
                        }
                    };
                    onSuccess = function (data) {
                        $('#btn_delete').removeAttr('disabled').html(buttonName);
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxJenisTransaksi", null, false);
                    return false;
                }

                $('.link_mapping').click(function () {
                    var oid = $(this).data('oid');
                    modalSetting("#modal-mapping", "static", false, false);
                    $('#modal-mapping').modal('show');

                    var command = "<%=Command.NONE%>";
                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": "getDataMapping",
                        "command": command
                    };
                    onDone = function (data) {

                    };
                    onSuccess = function (data) {

                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxJenisTransaksi", null, false);
                    return false;
                });

                $('#btn_cancel').click(function () {
                    $('#btn_cancel').attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../masterbumdes/list_jenis_transaksi.jsp";
                });

            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <section class="content-header">
            <h1>
                Jenis Transaksi
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Bumdesa</li>
                <li class="active">Master</li>
            </ol>
        </section>

        <section class="content">

            <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>

            <div class="box box-success">

                <div class="box-header with-border">
                    <h3 class="box-title">Form Input Data</h3>
                </div>

                <form id="form_jenis_transaksi" class="form-horizontal">

                    <div class="box-body">
                        <input type="hidden" value="<%=oid%>" id="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_JENIS_TRANSAKSI_ID]%>">
                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label col-sm-5">Nama Jenis Transaksi</label>
                                <div class="col-sm-6">
                                    <%
                                        String valJenisTransaksi = "";
                                        if (iCommand == Command.EDIT) {
                                            valJenisTransaksi = jenisTransaksi.getJenisTransaksi();
                                        }
                                    %>
                                    <input type="text" required="" class="form-control input-sm" value="<%=valJenisTransaksi%>" name="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_JENIS_TRANSAKSI]%>" id="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_JENIS_TRANSAKSI]%>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-5">Tujuan Prosedur</label>
                                <div class="col-sm-6">
                                    <select class="form-control input-sm" name="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_PROSEDURE_UNTUK]%>" id="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_PROSEDURE_UNTUK]%>">
                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getProsedureUntuk() == JenisTransaksi.TUJUAN_PROSEDUR_TABUNGAN) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TUJUAN_PROSEDUR_TABUNGAN%>"><%=JenisTransaksi.TUJUAN_PROSEDUR_TITLE[JenisTransaksi.TUJUAN_PROSEDUR_TABUNGAN]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TUJUAN_PROSEDUR_TABUNGAN%>"><%=JenisTransaksi.TUJUAN_PROSEDUR_TITLE[JenisTransaksi.TUJUAN_PROSEDUR_TABUNGAN]%></option>
                                        <%}%>

                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getProsedureUntuk() == JenisTransaksi.TUJUAN_PROSEDUR_KREDIT) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TUJUAN_PROSEDUR_KREDIT%>"><%=JenisTransaksi.TUJUAN_PROSEDUR_TITLE[JenisTransaksi.TUJUAN_PROSEDUR_KREDIT]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TUJUAN_PROSEDUR_KREDIT%>"><%=JenisTransaksi.TUJUAN_PROSEDUR_TITLE[JenisTransaksi.TUJUAN_PROSEDUR_KREDIT]%></option>
                                        <%}%>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-5">Tipe Arus Kas</label>
                                <div class="col-sm-6">
                                    <select class="form-control input-sm" name="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_TIPE_ARUS_KAS]%>" id="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_TIPE_ARUS_KAS]%>">
                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getTipeArusKas() == JenisTransaksi.TIPE_ARUS_KAS_BERTAMBAH) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TIPE_ARUS_KAS_BERTAMBAH%>"><%=JenisTransaksi.TIPE_ARUS_KAS_TITLE[JenisTransaksi.TIPE_ARUS_KAS_BERTAMBAH]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TIPE_ARUS_KAS_BERTAMBAH%>"><%=JenisTransaksi.TIPE_ARUS_KAS_TITLE[JenisTransaksi.TIPE_ARUS_KAS_BERTAMBAH]%></option>
                                        <%}%>

                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getTipeArusKas() == JenisTransaksi.TIPE_ARUS_KAS_BERKURANG) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TIPE_ARUS_KAS_BERKURANG%>"><%=JenisTransaksi.TIPE_ARUS_KAS_TITLE[JenisTransaksi.TIPE_ARUS_KAS_BERKURANG]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TIPE_ARUS_KAS_BERKURANG%>"><%=JenisTransaksi.TIPE_ARUS_KAS_TITLE[JenisTransaksi.TIPE_ARUS_KAS_BERKURANG]%></option>
                                        <%}%>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-5">Tipe Transaksi</label>
                                <div class="col-sm-6">
                                    <select class="form-control input-sm" name="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_TYPE_TRANSAKSI]%>" id="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_TYPE_TRANSAKSI]%>">
                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getTypeTransaksi() == JenisTransaksi.TIPE_TRANSAKSI_NORMAL) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TIPE_TRANSAKSI_NORMAL%>"><%=JenisTransaksi.TIPE_TRANSAKSI_TITLE[JenisTransaksi.TIPE_TRANSAKSI_NORMAL]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TIPE_TRANSAKSI_NORMAL%>"><%=JenisTransaksi.TIPE_TRANSAKSI_TITLE[JenisTransaksi.TIPE_TRANSAKSI_NORMAL]%></option>
                                        <%}%>

                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getTypeTransaksi() == JenisTransaksi.TIPE_TRANSAKSI_PENDAPATAN) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TIPE_TRANSAKSI_PENDAPATAN%>"><%=JenisTransaksi.TIPE_TRANSAKSI_TITLE[JenisTransaksi.TIPE_TRANSAKSI_PENDAPATAN]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TIPE_TRANSAKSI_PENDAPATAN%>"><%=JenisTransaksi.TIPE_TRANSAKSI_TITLE[JenisTransaksi.TIPE_TRANSAKSI_PENDAPATAN]%></option>
                                        <%}%>

                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getTypeTransaksi() == JenisTransaksi.TIPE_TRANSAKSI_PENGELUARAN) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TIPE_TRANSAKSI_PENGELUARAN%>"><%=JenisTransaksi.TIPE_TRANSAKSI_TITLE[JenisTransaksi.TIPE_TRANSAKSI_PENGELUARAN]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TIPE_TRANSAKSI_PENGELUARAN%>"><%=JenisTransaksi.TIPE_TRANSAKSI_TITLE[JenisTransaksi.TIPE_TRANSAKSI_PENGELUARAN]%></option>
                                        <%}%>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-5">Tipe Prosedur</label>
                                <div class="col-sm-6">
                                    <select class="form-control input-sm" name="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_TYPE_PROSEDUR]%>" id="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_TYPE_PROSEDUR]%>">
                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getTypeProsedur() == JenisTransaksi.TIPE_PROSEDUR_BY_SYSTEM) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TIPE_PROSEDUR_BY_SYSTEM%>"><%=JenisTransaksi.TIPE_PROSEDUR_TITLE[JenisTransaksi.TIPE_PROSEDUR_BY_SYSTEM]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TIPE_PROSEDUR_BY_SYSTEM%>"><%=JenisTransaksi.TIPE_PROSEDUR_TITLE[JenisTransaksi.TIPE_PROSEDUR_BY_SYSTEM]%></option>
                                        <%}%>

                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getTypeProsedur() == JenisTransaksi.TIPE_PROSEDUR_BY_TELLER) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TIPE_PROSEDUR_BY_TELLER%>"><%=JenisTransaksi.TIPE_PROSEDUR_TITLE[JenisTransaksi.TIPE_PROSEDUR_BY_TELLER]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TIPE_PROSEDUR_BY_TELLER%>"><%=JenisTransaksi.TIPE_PROSEDUR_TITLE[JenisTransaksi.TIPE_PROSEDUR_BY_TELLER]%></option>
                                        <%}%>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-5">Tipe Dokumen</label>
                                <div class="col-sm-6">
                                    <select class="form-control input-sm" name="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_TIPE_DOC]%>" id="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_TIPE_DOC]%>">
                                        <%
                                            for (int i = 0; i < JenisTransaksi.TIPE_DOC_TITLE.length; i++) {
                                                String selected = "";
                                                if (iCommand == Command.EDIT && jenisTransaksi.getTipeDoc() == i) {
                                                    selected = "selected";
                                                }
                                        %>
                                        <option <%=selected%> value="<%=i%>"><%=JenisTransaksi.TIPE_DOC_TITLE[i]%></option>
                                        <%}%>

                                        <%--if (iCommand == Command.EDIT && jenisTransaksi.getTypeProsedur() == JenisTransaksi.TIPE_DOC_TABUNGAN) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TIPE_DOC_TABUNGAN%>"><%=JenisTransaksi.TIPE_DOC_TITLE[JenisTransaksi.TIPE_DOC_TABUNGAN]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TIPE_DOC_TABUNGAN%>"><%=JenisTransaksi.TIPE_DOC_TITLE[JenisTransaksi.TIPE_DOC_TABUNGAN]%></option>
                                        <%}--%>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-5">Tipe Input</label>
                                <div class="col-sm-6">
                                    <select class="form-control input-sm" name="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_INPUT_OPTION]%>" id="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_INPUT_OPTION]%>">                                        
                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getInputOption() == JenisTransaksi.TIPE_DOC_INPUT_OPTIONAL) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TIPE_DOC_INPUT_OPTIONAL%>"><%=JenisTransaksi.TIPE_DOC_INPUT_TITLE[JenisTransaksi.TIPE_DOC_INPUT_OPTIONAL]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TIPE_DOC_INPUT_OPTIONAL%>"><%=JenisTransaksi.TIPE_DOC_INPUT_TITLE[JenisTransaksi.TIPE_DOC_INPUT_OPTIONAL]%></option>
                                        <%}%>

                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getInputOption() == JenisTransaksi.TIPE_DOC_INPUT_REQUIRED) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.TIPE_DOC_INPUT_REQUIRED%>"><%=JenisTransaksi.TIPE_DOC_INPUT_TITLE[JenisTransaksi.TIPE_DOC_INPUT_REQUIRED]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.TIPE_DOC_INPUT_REQUIRED%>"><%=JenisTransaksi.TIPE_DOC_INPUT_TITLE[JenisTransaksi.TIPE_DOC_INPUT_REQUIRED]%></option>
                                        <%}%>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-6">                                    
                            <div class="form-group">
                                <label class="control-label col-sm-5">Prosentase Perhitungan</label>
                                <div class="col-sm-6">
                                    <%
                                        String valProsentase = "";
                                        if (iCommand == Command.EDIT) {
                                            valProsentase = "" + jenisTransaksi.getProsentasePerhitungan();
                                        }
                                    %>
                                    <input type="number" max="100" required="" class="form-control input-sm" value="<%=valProsentase%>" name="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_PROSENTASE_PERHITUNGAN]%>" id="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_PROSENTASE_PERHITUNGAN]%>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-5">Standar Biaya</label>
                                <div class="col-sm-6">
                                    <%
                                        String valStandarTransaksi = "";
                                        if (iCommand == Command.EDIT) {
                                            valStandarTransaksi = "" + jenisTransaksi.getValueStandarTransaksi();
                                        }
                                    %>
                                    <input type="number" required="" class="form-control input-sm" value="<%=valStandarTransaksi%>" name="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_VALUE_STANDAR_TRANSAKSI]%>" id="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_VALUE_STANDAR_TRANSAKSI]%>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-5">Status Transaksi</label>
                                <div class="col-sm-6">                                    
                                    <select class="form-control input-sm" name="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_STATUS_AKTIF]%>" id="<%=FrmJenisTransaksi.fieldNames[FrmJenisTransaksi.FRM_FIELD_STATUS_AKTIF]%>">
                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getStatusAktif() == JenisTransaksi.STATUS_JENIS_TRANSAKSI_AKTIF) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.STATUS_JENIS_TRANSAKSI_AKTIF%>"><%=JenisTransaksi.STATUS_JENIS_TRANSAKSI_TITLE[JenisTransaksi.STATUS_JENIS_TRANSAKSI_AKTIF]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.STATUS_JENIS_TRANSAKSI_AKTIF%>"><%=JenisTransaksi.STATUS_JENIS_TRANSAKSI_TITLE[JenisTransaksi.STATUS_JENIS_TRANSAKSI_AKTIF]%></option>
                                        <%}%>

                                        <%if (iCommand == Command.EDIT && jenisTransaksi.getStatusAktif() == JenisTransaksi.STATUS_JENIS_TRANSAKSI_TIDAK_AKTIF) {%>
                                        <option style="padding: 5px" selected="" value="<%=JenisTransaksi.STATUS_JENIS_TRANSAKSI_TIDAK_AKTIF%>"><%=JenisTransaksi.STATUS_JENIS_TRANSAKSI_TITLE[JenisTransaksi.STATUS_JENIS_TRANSAKSI_TIDAK_AKTIF]%></option>
                                        <%} else {%>
                                        <option style="padding: 5px" value="<%=JenisTransaksi.STATUS_JENIS_TRANSAKSI_TIDAK_AKTIF%>"><%=JenisTransaksi.STATUS_JENIS_TRANSAKSI_TITLE[JenisTransaksi.STATUS_JENIS_TRANSAKSI_TIDAK_AKTIF]%></option>
                                        <%}%>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-5">Mapping (Hanya Untuk Tabungan)</label>
                                <div class="col-sm-6">
                                    <%
                                        Vector<JenisSimpanan> listSimpanan = PstJenisSimpanan.list(0, 0, "", "");
                                        Vector<JenisTransaksiMapping> listMap = PstJenisTransaksiMapping.list(0, 0, "" + PstJenisTransaksiMapping.fieldNames[PstJenisTransaksiMapping.FLD_JENIS_TRANSAKSI_ID] + " = '" + jenisTransaksi.getOID() + "'", "");
                                        for (int i = 0; i < listSimpanan.size(); i++) {
                                            String checked = "";
                                            long idJS = listSimpanan.get(i).getOID();
                                            for (int j = 0; j < listMap.size(); j++) {
                                                long idMapJS = listMap.get(j).getIdJenisSimpanan();
                                                if (idMapJS == idJS) {
                                                    checked = "checked";
                                                    break;
                                                }
                                            }
                                    %>
                                    <div class="checkbox">
                                        <label  id="<%=i%>"><input type="checkbox" <%=checked%> class="map_simpanan" value="<%=listSimpanan.get(i).getOID()%>"><%=listSimpanan.get(i).getNamaSimpanan()%></label>
                                    </div>
                                    <%
                                        }
                                    %>                                    
                                </div>
                            </div>
                        </div>                    
                    </div>

                    <div class="box-footer">                                               
                        <div class="col-sm-6"></div>
                        <div class="col-sm-6">
                            <div class="form-group" style="margin-bottom: 0px">
                                <div class="col-sm-offset-5 col-sm-6">
                                    <div class="pull-right">
                                        <button type="submit" id="btn_save" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                                        <button type="button" id="btn_cancel" class="btn btn-sm btn-default"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                                    </div>
                                    <%if (iCommand == Command.EDIT) {%>
                                    <!--button type="button" id="btn_delete" class="btn btn-sm btn-danger pull-right"><i class="fa fa-remove"></i>&nbsp;&nbsp;&nbsp;Hapus</button-->
                                    <%}%>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>

            </div>

            <%}%>

        </section>

        <!--------------------------------------------------------------------->

    </body>
</html>
