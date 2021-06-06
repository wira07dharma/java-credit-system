<%-- 
    Document   : agunan
    Created on : Jul 12, 2017, 2:17:06 PM
    Author     : Dimata 007
--%>
<%@page import="com.dimata.harisma.entity.masterdata.PstCustomFieldMaster"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAgunanMapping"%>
<%@page import="com.dimata.sedana.entity.kredit.AgunanMapping"%>
<%@page import="com.dimata.sedana.entity.kredit.Agunan"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAgunan"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.Regency"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.PstRegency"%>
<%@page import="com.dimata.sedana.form.kredit.FrmAgunan"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%  // GET OID FROM transaksi_kredit.jsp
    long oidPinjaman = FRMQueryString.requestLong(request, "pinjaman_id");        
    Pinjaman pinjaman = new Pinjaman();
    Anggota nasabah = new Anggota();
    try {        
        pinjaman = (Pinjaman) PstPinjaman.fetchExc(oidPinjaman);
        nasabah = PstAnggota.fetchExc(pinjaman.getAnggotaId());
    } catch (Exception exc) {

    }
    long oidAnggota = nasabah.getOID();
    long oidAgunan = FRMQueryString.requestLong(request, "agunan_id");
    long oidMapping = FRMQueryString.requestLong(request, "mapping_id");
    Agunan dataAgunan = new Agunan();
    AgunanMapping dataAgunanMapping = new AgunanMapping();
    if (oidAgunan != 0) {
        try {
            dataAgunan = PstAgunan.fetchExc(oidAgunan);
            dataAgunanMapping = PstAgunanMapping.fetchExc(oidMapping);
        } catch (Exception exc) {

        }
    }
    int iCommand = FRMQueryString.requestCommand(request);

    Vector listAgunan = PstAgunan.listJoinMapping(0, 0, "map." + PstAgunanMapping.fieldNames[PstAgunanMapping.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "'", "");

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
            table {font-size: 14px}
        </style>
        <script language="javascript">
            $(document).ready(function () {
                var approot = "<%= approot%>";
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
                        "sAjaxSource": "<%=approot%>/" + servletName + "?command=<%= Command.LIST%>&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=<%=approot%>" + "&SEND_OID_RESERVATION=" + oid,
                        aoColumnDefs: [
                            {
                                bSortable: false,
                                aTargets: []
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
                    dataTablesOptions("#nasabahTableElement", "tableNasabahTableElement", "AjaxAnggota", "listAnggota", null);
                }

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
                    format: "yyyy-mm-dd",
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2
                });

                //check required on enter
                function pressEnter(elementIdEnter, elementIdFocus) {
                    $(elementIdEnter).keypress(function (e) {
                        if (e.keyCode === 13) {
                            $(elementIdFocus).focus();
                            var atr = $(elementIdEnter).attr('required');
                            var val = $(elementIdEnter).val();
                            if (atr === "required") {
                                if (val === "") {
                                    alert("Data tidak boleh kosong !");
                                } else {
                                    return false;
                                }
                            } else {
                                return false;
                            }
                        }
                    });
                }

                //location.hash = "#btn-saveagunan";
                $('#FRM_FIELD_KODE_KAB_LOKASI_AGUNAN').focus();
                pressEnter('#FRM_FIELD_KODE_KAB_LOKASI_AGUNAN', '#FRM_FIELD_ALAMAT_AGUNAN');
                pressEnter('#FRM_FIELD_ALAMAT_AGUNAN', '#NILAI_NJOP');
                pressEnter('#NILAI_NJOP', '#FRM_FIELD_BUKTI_KEPEMILIKAN');
                pressEnter('#FRM_FIELD_BUKTI_KEPEMILIKAN', '#prosentase_pinjaman');
                pressEnter('#prosentase_pinjaman', '#btn-saveagunan');

                $('#btn-addagunan').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");                    
                    var command = "<%=Command.ADD%>";
                    window.location = "../agunan/agunan.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command;
                });

                $('.btn-editagunan').click(function () {
                    $(this).attr({"disabled": "true"}).html("...");
                    var idAgunan = $(this).data('oid');
                    var idMapping = $(this).data('mapping');
                    var command = "<%=Command.EDIT%>";
                    $('#command').val(command);
                    window.location = "../agunan/agunan.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command + "&agunan_id=" + idAgunan + "&mapping_id=" + idMapping;
                });

                $('#btn-cancel').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    var command = "<%=Command.NONE%>";
                    $('#command').val(command);
                    window.location = "../agunan/agunan.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command;
                });

                $('#btn-deleteagunan').click(function () {
                    var buttonName = $('#btn-deleteagunan').html();
                    $('#btn-deleteagunan').attr({"disabled": "true"}).html("Tunggu...");
                    var oid = $('#FRM_MAPPING_ID').val();
                    var command = "<%=Command.DELETE%>";                    
                    var dataFor = "deleteAgunan";
                    var idPinjaman = "<%=oidPinjaman%>";

                    if (confirm("Yakin ingin menghapus data ini ?")) {
                        var dataSend = {
                            "FRM_FIELD_OID": oid,
                            "SEND_OID_PINJAMAN": idPinjaman,
                            "FRM_FIELD_DATA_FOR": dataFor,
                            "command": command
                        };

                        onDone = function (data) {
                            if (data.SEND_ERROR_CODE === "0") {
                                alert("Data agunan berhasil dihapus");
                                command = "<%=Command.NONE%>";
                                window.location = "../agunan/agunan.jsp?pinjaman_id=<%=oidPinjaman%>&command=" + command;
                            } else {
                                alert(data.SEND_MESSAGE);                            
                            }                        
                        };

                        onSuccess = function (data) {

                        };
                        //alert(JSON.stringify(dataSend));
                        getDataFunction(onDone, onSuccess, "<%=approot%>", command, dataSend, "AjaxAgunan", null, false);
                    } else {
                        $('#btn-deleteagunan').removeAttr('disabled').html(buttonName);
                    }
                });

                $('#form-agunan').submit(function () {
                    var buttonName = $('#btn-saveagunan').html();
                    $('#btn-saveagunan').attr({"disabled": "true"}).html("Tunggu...");
                    var oid = $('#FRM_FIELD_AGUNAN_ID').val();
                    var command = "<%=Command.SAVE%>";
                    var dataFor = "saveAgunan";
                    var prosentase = $('.valProsentase').val();
                    var idPinjaman = "<%=oidPinjaman%>";
                    var idAnggota = "<%=oidAnggota%>";
                    
//                    $('.select-input3 > option:selected').each(function() {
//                        var oid = $(this).data('hidden3');
//                        var type = $(this).data('type3');
//                        $('.custom-input3').append("<input type=\"hidden\" name=\"hidden3\" value=\""+oid+"\" /><input type=\"hidden\" name=\"data_type3\" value=\""+type+"\" />");
//                    });

                    onDone = function (data) {
                        if (data.SEND_ERROR_CODE === "0") {
                            alert("Data agunan berhasil disimpan");
                            window.location = "../agunan/agunan.jsp?pinjaman_id=<%=oidPinjaman%>";
                        } else {
                            alert(data.SEND_MESSAGE);                            
                        }                        
                    };

                    onSuccess = function (data) {
                        $('#btn-saveagunan').removeAttr('disabled').html(buttonName);
                    };

                    var data = $(this).serialize();
                    var dataSend = "" + data + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command + "&FRM_FIELD_OID=" + oid
                            + "&SEND_OID_PINJAMAN=" + idPinjaman + "&SEND_OID_ANGGOTA=" + idAnggota + "&SEND_PROSENTASE_PINJAMAN=" + prosentase;
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, "<%=approot%>", command, dataSend, "AjaxAgunan", null, false);
                    return false;
                });
                
                $('#FRM_FIELD_TIPE_AGUNAN').change(function () {
                    //alert("shit");
                    getCustomFieldTipeAgunan();
                });
                
                function getCustomFieldTipeAgunan(){
                    var command = "<%=Command.LIST%>";
                    var modul = "<%=PstCustomFieldMaster.MODUL_AGUNAN%>";
                    var field = "<%=PstCustomFieldMaster.FIELD_TIPE_AGUNAN%>";
                    var value = $("#FRM_FIELD_TIPE_AGUNAN").val();
                    var oid = $("#FRM_FIELD_AGUNAN_ID").val();
                    var dataSend = {
                        "field": field,
                        "modul": modul,
                        "value": value,
                        "command": command,
                        "oid": oid
                    }
                    var onDone = function(data){
                        $("#tipeAgunanCustom").html(data.RETURN_HTML);
                        $('.select2').select2();
                    };
                    var onSuccess = function(data){

                    };
                    getDataFunction(onDone, onSuccess, approot, command, dataSend, "AjaxCustomField", null, false);
                }
                
                getCustomFieldTipeAgunan();
            });
        </script>

    </head>
    <body style="background-color: #eaf3df;">
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
            <a class="btn btn-danger" href="../agunan/agunan.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Agunan / Jaminan</a>
            <% if (pinjaman.getStatusPinjaman() >= Pinjaman.STATUS_DOC_APPROVED) {%>
            <a style="background-color: white" class="btn btn-default" href="../transaksikredit/biaya_kredit.jsp?pinjaman_id=<%=pinjaman.getOID()%>">Data Detail</a>
            <% } %>
            <a style="font-size: 14px" class="btn btn-box-tool" href="../transaksikredit/list_kredit.jsp">Kembali ke daftar kredit</a>            
        </section>
        <%} else {%>
        <div class="content-header" style="color: red"><i class="fa fa-warning"></i> &nbsp; Data kredit tidak ditemukan !</div>
        <%}%>

        <section class="content">
            <div class="box box-success">

                <div class="box-header with-border" style="border-color: lightgrey">
                    <h3 class="box-title">Nomor Kredit &nbsp;:&nbsp; <a><%=pinjaman.getNoKredit()%></a></h3>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <h3 class="box-title">Nama <%=namaNasabah%> &nbsp;:&nbsp; <a href="../../masterdata/anggota/anggota_edit.jsp?anggota_oid=<%= nasabah.getOID() %>"><%=nasabah.getName()%></a> &nbsp;(<%=nasabah.getNoAnggota()%>)</h3>
                    <h3 class="box-title pull-right">Status &nbsp;:&nbsp; <a><%=Pinjaman.getStatusDocTitle(pinjaman.getStatusPinjaman())%></a></h3>
                </div>

                <div class="box-body">
                    <label>Daftar Agunan</label>
                    <table class="table table-bordered table-striped">
                        <tr class="label-success">
                            <th>No.</th>
                            <th>Kode Agunan</th>
                            <th>Tipe Agunan</th>
                            <th>Kabupaten</th>
                            <th>Alamat Agunan</th>
                            <th>Nilai NJOP Agunan (Rp)</th>
                            <th>Nomor Akte Kepemilikan</th>
                            <th>Prosentase Pinjaman</th>
                            <th style="width: 1px">Aksi</th>
                        </tr>

                        <%if (listAgunan.isEmpty()) {%>

                        <tr><td colspan="9" class="text-center label-default">Tidak ada data agunan</td></tr>

                        <%} else {
                            for (int i = 0; i < listAgunan.size(); i++) {
                                Agunan agunan = (Agunan) listAgunan.get(i);
                                AgunanMapping agunanMapping = new AgunanMapping();
                                Regency r = new Regency();
                                try {
                                    agunanMapping = PstAgunanMapping.fetchExc(agunan.getAgunanMappingId());
                                    r = PstRegency.fetch(agunan.getKodeKabLokasiAgunan());
                                } catch (Exception exc) {

                                }
                        %>
                        <tr>
                            <td><%=(i + 1)%>.</td>
                            <td><%=agunan.getKodeJenisAgunan()%></td>
                            <td><%=Agunan.TIPE_AGUNAN.get(agunan.getTipeAgunan()).get("TITLE") %></td>
                            <td><%=r.getRegencyName()%></td>
                            <td><%=agunan.getAlamatAgunan()%></td>
                            <td class="money text-right"><%=agunan.getNilaiAgunanNjop()%></td>
                            <td><%=agunan.getBuktiKepemilikan()%></td>
                            <td class="text-right"><span class="money"><%=agunanMapping.getProsentasePinjaman()%></span> %</td>
                            <td class="text-center"><button type="button" class="btn btn-xs btn-warning btn-editagunan" data-oid="<%=agunan.getOID()%>" data-mapping="<%=agunan.getAgunanMappingId()%>"><i class="fa fa-pencil"></i></button></td>
                        </tr>
                        <%
                                }
                            }
                        %>

                    </table>
                </div>
                <%if (pinjaman.getOID() != 0 && (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_DRAFT) || pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_APPROVED) {%>
                <div class="box-footer" style="border-color: lightgray">
                    <button type="button" class="btn btn-sm btn-primary" id="btn-addagunan"><i class="fa fa-plus"></i> &nbsp; Tambah Agunan</button>
                </div>
                <%}%>

            </div>

            <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>

            <div class="box box-success">

                <div class="box-header with-border" style="border-color: lightgray">
                    <h3 class="box-title">Form Input Agunan</h3>
                </div>

                <p></p>

                <form id="form-agunan" class="form-horizontal">
                    <div class="box-body">

                        <input type="hidden" value="<%=dataAgunan.getOID()%>" id="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_AGUNAN_ID]%>">
                        <input type="hidden" value="<%=dataAgunanMapping.getOID()%>" id="FRM_MAPPING_ID">

                        <div class="form-group">
                            <label class="control-label col-sm-2">Kode Agunan</label>
                            <div class="col-sm-4">
                                <%
                                    String nomorAgunan = "";
                                    if (iCommand == Command.EDIT) {
                                        nomorAgunan = "" + dataAgunan.getKodeJenisAgunan();
                                    } else {
                                        nomorAgunan = "Auto-Number";
                                    }
                                %>
                                <input type="text" readonly="" required="" class="form-control input-sm" value="<%=nomorAgunan%>" name="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_KODE_JENIS_AGUNAN]%>" id="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_KODE_JENIS_AGUNAN]%>">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-sm-2">Tipe Agunan</label>
                            <div class="col-sm-4">
                              <script>
                                  $(window).load(function() {
                                    $("body .select-tipe").removeClass("hidden");
                                    $("body .select-tipe").change(function() {
                                      $("#txt-tipe-agunan").html($(this).children("option:selected").data("note-name"));
                                    });
                                  });
                              </script>
                                <select class="form-control input-sm select-tipe hidden" name="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_TIPE_AGUNAN]%>" id="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_TIPE_AGUNAN]%>">
                                    <% for (int i = 0; i < Agunan.TIPE_AGUNAN.size();) {
                                      HashMap<String, String> type = Agunan.TIPE_AGUNAN.get(++i);%>
                                    <option style="padding: 5px" <%=(dataAgunan.getTipeAgunan() == i) ? "selected" : ""%> data-note-name="<%=type.get("NOTE_NAME")%>" value="<%=i%>"><%=type.get("TITLE") %></option>                                            
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        
                        <div id="tipeAgunanCustom">
                            
                        </div>
                                
                        <div class="form-group">
                          <label id="txt-tipe-agunan" class="control-label col-sm-2"><%=Agunan.TIPE_AGUNAN.get((dataAgunan.getTipeAgunan() > 0) ? dataAgunan.getTipeAgunan() : 1).get("NOTE_NAME") %></label>
                            <div class="col-sm-4">
                                <input type="text" required="" class="form-control input-sm" value="<%=dataAgunan.getNoteTipeAgunan() %>" name="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_NOTE_TIPE_AGUNAN]%>" id="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_NOTE_TIPE_AGUNAN]%>">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-sm-2">Kabupaten</label>
                            <div class="col-sm-4">
                                <select class="form-control input-sm" name="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_KODE_KAB_LOKASI_AGUNAN]%>" id="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_KODE_KAB_LOKASI_AGUNAN]%>">
                                    <%
                                        Vector listKabupaten = PstRegency.list(0, 0, "", "");
                                        for (int i = 0; i < listKabupaten.size(); i++) {
                                            Regency r = (Regency) listKabupaten.get(i);
                                    %>
                                    <option style="padding: 5px" value="<%=r.getOID()%>"><%=r.getRegencyName()%></option>                                            
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-sm-2">Alamat Agunan</label>
                            <div class="col-sm-4">
                                <input type="text" required="" class="form-control input-sm" value="<%=dataAgunan.getAlamatAgunan()%>" name="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_ALAMAT_AGUNAN]%>" id="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_ALAMAT_AGUNAN]%>">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-sm-2">Nilai NJOP Agunan</label>
                            <div class="col-sm-4">
                                <div class="input-group">
                                    <span class="input-group-addon">Rp</span>
                                    <input type="text" autocomplete="off" required="" id="NILAI_NJOP" data-cast-class="val_njop" class="form-control input-sm money" value="<%=dataAgunan.getNilaiAgunanNjop()%>">
                                    <input type="hidden" class="val_njop" value="<%=dataAgunan.getNilaiAgunanNjop()%>" name="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_NILAI_AGUNAN_NJOP]%>" id="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_NILAI_AGUNAN_NJOP]%>">
                                </div>
                            </div>
                        </div>
                            
                        <div class="form-group">
                            <label class="control-label col-sm-2">Nilai Ekonomis</label>
                            <div class="col-sm-4">
                                <div class="input-group">
                                    <span class="input-group-addon">Rp</span>
                                    <input type="text" autocomplete="off" required="" id="NILAI_EKONOMIS" data-cast-class="val_n_ekonomis" class="form-control input-sm money" value="<%=dataAgunan.getNilaiEkonomis()%>">
                                    <input type="hidden" class="val_n_ekonomis" value="<%=dataAgunan.getNilaiEkonomis()%>" name="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_NILAI_EKONOMIS]%>" id="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_NILAI_EKONOMIS]%>">
                                </div>
                            </div>
                        </div>
                            
                        <div class="form-group">
                            <label class="control-label col-sm-2">Nilai Jaminan Agunan</label>
                            <div class="col-sm-4">
                                <div class="input-group">
                                    <span class="input-group-addon">Rp</span>
                                    <input type="text" autocomplete="off" required="" id="NILAI_JAMINAN_AGUNAN" data-cast-class="val_jaminan_agunan" class="form-control input-sm money" value="<%=dataAgunan.getNilaiJaminanAgunan()%>">
                                    <input type="hidden" class="val_jaminan_agunan" value="<%=dataAgunan.getNilaiJaminanAgunan()%>" name="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_NILAI_JAMINAN_AGUNAN]%>" id="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_NILAI_JAMINAN_AGUNAN]%>">
                                </div>
                            </div>
                        </div>    

                        <div class="form-group">
                            <label class="control-label col-sm-2">No. Akte Kepemilikan</label>
                            <div class="col-sm-4">
                                <input type="text" required="" class="form-control input-sm" value="<%=dataAgunan.getBuktiKepemilikan()%>" name="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_BUKTI_KEPEMILIKAN]%>" id="<%=FrmAgunan.fieldNames[FrmAgunan.FRM_FIELD_BUKTI_KEPEMILIKAN]%>">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="control-label col-sm-2">Prosentase Pinjaman</label>
                            <div class="col-sm-4">
                                <%
                                    String prosentase = "";
                                    if (dataAgunanMapping.getProsentasePinjaman() != 0) {
                                        prosentase = "" + dataAgunanMapping.getProsentasePinjaman();
                                    }
                                %>
                                <div class="input-group">
                                    <input type="text" autocomplete="off" required="" data-cast-class="valProsentase" class="form-control input-sm money" value="<%=prosentase%>" id="prosentase_pinjaman">
                                    <input type="hidden" class="valProsentase" value="<%=prosentase%>">
                                    <span class="input-group-addon">%</span>
                                </div>                                
                            </div>
                        </div>

                    </div>

                    <div class="box-footer" style="border-color: lightgray">
                        <div class="form-group" style="margin-bottom: 0px">
                            <div class="col-sm-2"></div>
                            <div class="col-sm-4">
                                <div class="pull-right">
                                    <%if (pinjaman.getOID() != 0 && pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_DRAFT || pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_APPROVED) {%>
                                    <button type="submit" id="btn-saveagunan" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                                    <%}%>
                                    <button type="button" id="btn-cancel" class="btn btn-sm btn-default"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                                    <%if (pinjaman.getOID() != 0 && iCommand == Command.EDIT && dataAgunanMapping.getOID() != 0 && (pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_DRAFT || pinjaman.getStatusPinjaman() == Pinjaman.STATUS_DOC_APPROVED)) {%>
                                    <button type="button" id="btn-deleteagunan" class="btn btn-sm btn-danger"><i class="fa fa-remove"></i> &nbsp; Hapus</button>
                                    <%}%>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>

            </div>

            <%}%>

        </section>

    </body>
</html>
