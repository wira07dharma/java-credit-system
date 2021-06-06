<%-- 
    Document   : kelompok_dokumen
    Created on : Dec 27, 2017, 9:05:52 PM
    Author     : dedy_blinda
--%>

<%@page import="com.dimata.gui.jsp.ControlCombo"%>
<%@page import="com.dimata.sedana.entity.masterdata.EmpRelevantDocGroup"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstEmpRelevantDocGroup"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstEmpRelevantDoc"%>
<%@page import="com.dimata.gui.jsp.ControlLine"%>
<%@page import="com.dimata.aiso.form.masterdata.anggota.CtrlEmpRelevantDoc"%>
<%@page import="com.dimata.gui.jsp.ControlList"%>
<%@page import="com.dimata.aiso.form.masterdata.anggota.FrmEmpRelevantDoc"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.EmpRelevantDoc"%>
<%@page import="com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.anggota.AnggotaBadanUsaha"%>
<%@page import="com.dimata.util.Command"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>

<% //
    long idKelompok = FRMQueryString.requestLong(request, "kelompok_id");
    long idRelevant = FRMQueryString.requestLong(request, "relevant_id");
    int iCommand = FRMQueryString.requestCommand(request);

    AnggotaBadanUsaha abu = new AnggotaBadanUsaha();
    EmpRelevantDoc erd = new EmpRelevantDoc();
    
    if (idKelompok != 0) {
        abu = PstAnggotaBadanUsaha.fetchExc(idKelompok);
    }
    
    if(idRelevant != 0){
        erd = PstEmpRelevantDoc.fetchExc(idRelevant);
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
        <style>
            .table {font-size: 14px}
            th {text-align: center; font-weight: normal}
            select option {padding: 5px;}
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

                $('#btn_add').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../anggota/kelompok_dokumen.jsp?kelompok_id=<%=idKelompok%>&pengurus_id=0&command=<%=Command.ADD%>";
                });
                $('#btn_add_2').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../anggota/kelompok_dokumen.jsp?kelompok_id=<%=idKelompok%>&pengurus_id=0&command=<%=Command.ADD%>";
                });

                $('.btn_edit').click(function () {
                    $(this).attr({"disabled": "true"}).html("....");
                    var oidRelevant = $(this).data('oid');
                    window.location = "../anggota/kelompok_dokumen.jsp?kelompok_id=<%=idKelompok%>&relevant_id=" + oidRelevant + "&command=<%=Command.EDIT%>";
                });

                $('#btn_cancel').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../anggota/kelompok_dokumen.jsp?kelompok_id=<%=idKelompok%>";
                });
                
                $('.btn_attach').click(function () {
                    var empId = <%=idKelompok%>;
                    var empdocId = $(this).data('oid');
                    
                    window.open("upload_pict.jsp?command="+<%=Command.EDIT%>+"&emp_relevant_doc_id=" + empdocId + "&emp_id=" + empId , null, "height=400,width=600,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");
                });

                $('#FORM_DOC').submit(function () {
                    var buttonName = $('#btn_save').html();
                    $('#btn_save').attr({"disabled": "true"}).html("Tunggu...");

                    var oid = $('#ID_RELEVANT').val();
                    var command = "<%=Command.SAVE%>";
                    var dataFor = "saveDoc";

                    onDone = function (data) {
                        var error = data.RETURN_ERROR_CODE;
                        if (error === "1") {
                            alert(data.RETURN_MESSAGE);
                        } else {
                            alert(data.RETURN_MESSAGE);
                            window.location = "../anggota/kelompok_dokumen.jsp?kelompok_id=<%=idKelompok%>";
                        }
                    };

                    onSuccess = function (data) {
                        $('#btn_save').removeAttr('disabled').html(buttonName);
                    };

                    var data = $(this).serialize();
                    var dataSend = "" + data + "&FRM_FIELD_OID=" + oid + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command + "&FRM_FIELD_OID_KELOMPOK=<%=idKelompok%>";
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxDokumen", null, false);
                    return false;
                });

                $('#btn_delete').click(function () {
                    if (confirm("Yakin ingin menghapus data ini ?")) {
                        var buttonName = $('#btn_delete').html();
                        $('#btn_delete').attr({"disabled": "true"}).html("Tunggu...");

                        var oid = $('#ID_RELEVANT').val();
                        var command = "<%=Command.DELETE%>";
                        var dataFor = "deleteDoc";
                        var dataSend = {
                            "FRM_FIELD_OID": oid,
                            "FRM_FIELD_DATA_FOR": dataFor,
                            "command": command
                        };
                        onDone = function (data) {
                            var error = data.RETURN_ERROR_CODE;
                            if (error === "0") {
                                alert(data.RETURN_MESSAGE);
                                window.location = "../anggota/kelompok_dokumen.jsp?kelompok_id=<%=idKelompok%>";
                            } else if (error === "1") {
                                alert(data.RETURN_MESSAGE);
                            }
                        };
                        onSuccess = function (data) {
                            $('#btn_delete').removeAttr('disabled').html(buttonName);
                        };
                        //alert(JSON.stringify(dataSend));
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxDokumen", null, false);
                        return false;
                    }
                });

            });
            
            function cmdOpen(fileName){
		window.open("<%=approot%>/imgdoc/"+fileName , null);
            }
        </script>
    </head>
    <body style="background-color: #eaf3df;">

        <section class="content-header">
            <h1>
                Kelompok / Badan Usaha
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Bumdesa</li>
                <li class="active"><%=namaNasabah%></li>
            </ol>
        </section>

        <%if (idKelompok != 0) {%>
        <section class="content-header">
            <a style="background-color: white" class="btn btn-default" href="../anggota/anggota_kelompok_badan_usaha.jsp?kelompok_id=<%=idKelompok%>&command=<%=Command.EDIT%>">Data Profil</a>
            <a style="background-color: white" class="btn btn-default" href="../anggota/pengurus_kelompok.jsp?kelompok_id=<%=idKelompok%>">Data Pengurus / Pemilik</a>
            <a style="background-color: white" class="btn btn-default" href="../anggota/kelompok_tabungan.jsp?kelompok_id=<%=idKelompok%>">Data Tabungan</a>
            <a class="btn btn-danger" href="../anggota/kelompok_dokumen.jsp?kelompok_id=<%=idKelompok%>">Dokumen Bersangkutan</a>
            <a style="font-size: 14px" class="btn-box-tool" href="../anggota/list_anggota_kelompok.jsp">Kembali ke daftar <%=namaNasabah%></a>
        </section>
        <%}%>

        <section class="content">
            <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>
                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgrey">
                        <h3 class="box-title">Form Input Dokumen Bersangkutan</h3>
                    </div>

                    <p></p>

                    <form id="FORM_DOC" class="form-horizontal" method="post">
                        <div class="box-body">

                            <input type="hidden" value="<%=idKelompok%>" name="<%=FrmEmpRelevantDoc.fieldNames[FrmEmpRelevantDoc.FRM_FIELD_ANGGOTA_ID]%>" id="ID_KELOMPOK">
                            <input type="hidden" value="<%=idRelevant%>" name="<%=FrmEmpRelevantDoc.fieldNames[FrmEmpRelevantDoc.FRM_FIELD_DOC_RELEVANT_ID]%>" id="ID_RELEVANT">

                            <div class="form-group">
                                <label class="control-label col-sm-2">Group Doc</label>
                                <div class="col-sm-4">
                                    <%
                                        Vector val_doc = new Vector(1, 1);
                                        Vector key_doc = new Vector(1, 1);
                                        Vector vdoc = PstEmpRelevantDocGroup.listAll();
                                        val_doc.add("0");
                                        key_doc.add("-- Pilih --");
                                        for (int k = 0; k < vdoc.size(); k++) {
                                            EmpRelevantDocGroup empRelevantDocGroup = (EmpRelevantDocGroup) vdoc.get(k);
                                            val_doc.add("" + empRelevantDocGroup.getOID());
                                            key_doc.add("" + empRelevantDocGroup.getDocGroup());
                                        }
                                    %>
                                    <%=ControlCombo.draw("" + FrmEmpRelevantDoc.fieldNames[FrmEmpRelevantDoc.FRM_FIELD_RELVT_DOC_GRP_ID], null, ""+ erd.getRelvtDocGrpId(), val_doc, key_doc, "id=\"FRM_FIELD_RELVT_DOC_GRP_ID\"", "formElemen")%>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-2">Title</label>
                                <div class="col-sm-4">
                                    <input type="text" required="" class="form-control input-sm" value="<%=erd.getDocTitle()%>" name="<%=FrmEmpRelevantDoc.fieldNames[FrmEmpRelevantDoc.FRM_FIELD_DOC_TITLE]%>" id="TITLE">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-2">Description</label>
                                <div class="col-sm-4">
                                    <textarea class="form-control input-sm" name="<%=FrmEmpRelevantDoc.fieldNames[FrmEmpRelevantDoc.FRM_FIELD_DOC_DESCRIPTION]%>" id="DESCRIPTION"><%=erd.getDocDescription()%></textarea>
                                </div>
                            </div>

                            <!--% if((iCommand !=Command.ADD)){%>
                            <div class="form-group">
                                <label class="control-label col-sm-2">Document</label>
                                <div class="col-sm-4">
                                    <!--% if(empRelevantDoc.getFileName().length() > 0){%>
                                    <input type="hidden" name="<!--%=FrmEmpRelevantDoc.fieldNames[FrmEmpRelevantDoc.FRM_FIELD_FILE_NAME] %>"  value="" class="formElemen"> 
                                    <a href="javascript:cmdOpen('<!--%=empRelevantDoc.getFileName()%>')"><!--%=empRelevantDoc.getFileName()%></a>
                                    </td>
                                    <!--% }else{%>
                                    <td valign="top" width="44%"><i><font  color="#FF0000"> no relevant document found...</font></i>
                                    </td>
                                    <!--%
                                    }
                                    %>
                                </div>
                            </div>
                            <!--%}%-->

                        </div>

                        <div class="box-footer" style="border-color: lightgray">
                            <div class="form-group" style="margin-bottom: 0px">
                                <div class="col-sm-2"></div>
                                <div class="col-sm-4">
                                    <div class="pull-right">
                                        <button type="submit" id="btn_save" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                                        <button type="button" id="btn_cancel" class="btn btn-sm btn-default"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                                        <% if (iCommand == Command.EDIT) {%>
                                        <button type="button" id="btn_delete" class="btn btn-sm btn-danger pull-right"><i class="fa fa-remove"></i> &nbsp; Hapus</button>
                                        <% }%>
                                    </div>
                                </div>
                            </div>                        
                        </div>
                    </form>

                </div>
            <%}%>
            
            <div class="box box-success">
                <div class="box-header with-border" style="border-color: lightgrey">
                    <h3 class="box-title">Nama <%=namaNasabah%> &nbsp;:&nbsp; <a><%=abu.getName()%></a></h3>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <h3 class="box-title">Nomor <%=namaNasabah%> &nbsp;:&nbsp; <a><%=abu.getNoAnggota()%></a></h3>
                </div>

                <div class="box-body">
                    <% if (idKelompok != 0) {%>
                    <button type="button" class="btn btn-sm btn-primary" id="btn_add"><i class="fa fa-plus"></i> &nbsp; Tambah Dokumen</button>
                    <% }%>
                    </br></br>
                    <label>Daftar Dokumen</label>
                    <div style="width: 100%">
                        <table class="table table-bordered table-striped">
                            <tr class="label-success">
                                <th style="width: 1%">No.</th>
                                <th>Title</th>
                                <th>Document</th>
                                <th>Description</th>
                                <th style="width: 1%">Aksi</th>
                            </tr>

                            <% Vector listRelevantDoc = PstEmpRelevantDoc.list(0, 0, "" + PstEmpRelevantDoc.fieldNames[PstEmpRelevantDoc.FLD_ANGGOTA_ID] + " = '" + idKelompok + "'", ""); %>

                            <% if (listRelevantDoc.isEmpty()) { %>

                            <tr><td class="text-center label-default" colspan="10">Tidak ada data dokumen</td></tr>

                            <% } else { %>

                            <%
                                for (int i = 0; i < listRelevantDoc.size(); i++) {
                                    EmpRelevantDoc pk = (EmpRelevantDoc) listRelevantDoc.get(i);
                            %>

                            <tr>
                                <td><%=(i + 1)%></td>
                                <td><%=pk.getDocTitle()%></td>
                                <td><button class="btn btn-xs btn-danger btn_attach" data-oid="<%=pk.getOID()%>">Attach File</button>
                                    &nbsp;&nbsp;&nbsp;
                                    <a href="javascript:cmdOpen('<%=pk.getFileName()%>')"><%=pk.getFileName()%></a>
                                </td>
                                <td><%=pk.getDocDescription()%></td>
                                <td class="text-center"><button class="btn btn-xs btn-warning btn_edit" data-oid="<%=pk.getOID()%>"><i class="fa fa-pencil"></i></button></td>
                            </tr>

                            <%
                                }
                            %>

                            <% }%>

                        </table>
                    </div>
                </div>

                <div class="box-footer" style="border-color: lightgrey">
                    <% if (idKelompok != 0) {%>
                    <button type="button" class="btn btn-sm btn-primary" id="btn_add_2"><i class="fa fa-plus"></i> &nbsp; Tambah Dokumen</button>
                    <% }%>
                </div>
            </div>
            
        </section>
    </body>
</html>
