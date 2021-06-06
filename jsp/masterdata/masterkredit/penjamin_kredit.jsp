<%-- 
    Document   : penjamin_kredit
    Created on : Sep 4, 2017, 10:41:37 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.session.SessHistory"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.penjamin.PersentaseJaminan"%>
<%@page import="com.dimata.sedana.entity.penjamin.PstPersentaseJaminan"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.PstCity"%>
<%@page import="com.dimata.aiso.entity.masterdata.region.City"%>
<%@page import="com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.anggota.AnggotaBadanUsaha"%>
<%@page import="com.dimata.aiso.form.masterdata.anggota.FrmAnggotaBadanUsaha"%>
<%@page import="com.dimata.util.*"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% //
    long oidPenjamin = FRMQueryString.requestLong(request, "penjamin_id");
    long oidPersentase = FRMQueryString.requestLong(request, "persentase_id");
    int iCommand = FRMQueryString.requestCommand(request);
    int showHistory = FRMQueryString.requestInt(request, "show_history");

    double coverage = FRMQueryString.requestInt(request, "coverage");
    int jangka = FRMQueryString.requestInt(request, "jangka");
    double persen = FRMQueryString.requestInt(request, "persen");

    AnggotaBadanUsaha penjamin = new AnggotaBadanUsaha();
    if (iCommand == Command.EDIT || iCommand == Command.ASK && oidPenjamin != 0) {
        penjamin = PstAnggotaBadanUsaha.fetchExc(oidPenjamin);
    }
    // data penjamin
    Vector listPenjamin = PstAnggotaBadanUsaha.listJoinContactClassPenjamin(0, 0, "", "");

    // data persentase jaminan
    Vector<PersentaseJaminan> listJangkaWaktu = PstPersentaseJaminan.list(0, 0, "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_ID_PENJAMIN] + " = '" + oidPenjamin + "'"
            + " GROUP BY " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " ASC ", "");
    Vector<PersentaseJaminan> listCoverage = PstPersentaseJaminan.list(0, 0, "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_ID_PENJAMIN] + " = '" + oidPenjamin + "'"
            + " GROUP BY " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_PERSENTASE_COVERAGE] + " ASC ", "");
%>
<!DOCTYPE html>
<html>
    <head>
        <%@ include file = "/style/lte_head.jsp" %>
        <style>
            input#keyword{display:inline-block;}
            .listtitle{padding-bottom:5px;}
            .listgenactivity{margin-top:20px !important;}
            .listgenactivity td{padding-left:5px !important;padding-right:5px !important;}
        </style>
        <style>
            .box-success th {text-align: center; font-weight: normal; vertical-align: middle !important}
            .nilai_persen:hover {background-color: lightblue;}
            table {font-size: 14px}
        </style>
        <script language="javascript">
            $(document).ready(function () {

                //var oid = 0;

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

                //check required on enter
                function pressEnter(elementIdEnter, elementIdFocus) {
                    $(elementIdEnter).keypress(function (e) {
                        if (e.keyCode === 13) {
                            var atr = $(elementIdEnter).attr('required');
                            var val = $(elementIdEnter).val();
                            if (val === "") {
                                if (atr === "required") {
                                    alert("Data tidak boleh kosong !");
                                    $(elementIdEnter).focus();
                                    return false;
                                }
                            }
                            $(elementIdFocus).focus();
                            return false;
                        }
                    });
                }

                $('#NAME').focus();
                pressEnter('#NAME', '#TLP');
                pressEnter('#TLP', '#EMAIL');
                pressEnter('#EMAIL', '#OFFICE_ADDRESS');
                pressEnter('#OFFICE_ADDRESS', '#ADDR_OFFICE_CITY');
                pressEnter('#ADDR_OFFICE_CITY', '#ID_CARD');
                pressEnter('#ID_CARD', '#NO_NPWP');
                pressEnter('#NO_NPWP', '#ID_TRANSAKSI');
                pressEnter('#ID_TRANSAKSI', '#btn_save');

                $('#btn_add').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../masterkredit/penjamin_kredit.jsp?penjamin_id=0&command=<%=Command.ADD%>";
                });

                $('.btn_edit').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu....");
                    var oid = $(this).data('oid');
                    window.location = "../masterkredit/penjamin_kredit.jsp?penjamin_id=" + oid + "&command=<%=Command.EDIT%>";
                });

                $('.btn_view').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu....");
                    var oid = $(this).data('oid');
                    window.location = "../masterkredit/penjamin_kredit.jsp?penjamin_id=" + oid + "&command=<%=Command.ASK%>";
                });

                $('#btnNew').click(function () {
                    $('#ID_PERSENTASE_JAMINAN').val(0);
                    $('#PERSEN_COVERAGE').val("");
                    $('#JANGKA_WAKTU').val("");
                    $('#JANGKA_WAKTU_TAHUN').val("");
                    $('#PERSEN_DIJAMIN').val("");
                });

                $('.btn_cancel').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../masterkredit/penjamin_kredit.jsp";
                });

                $('#form_penjaminkredit').submit(function () {
                    var buttonName = $('#btn_save').html();
                    $('#btn_save').attr({"disabled": "true"}).html("Tunggu...");

                    var oid = $('#ID_ANGGOTA').val();
                    var command = "<%=Command.SAVE%>";
                    var dataFor = "savePenjaminKredit";

                    onDone = function (data) {
                        var error = data.RETURN_ERROR_CODE;
                        var idPenjamin = data.RETURN_OID_PENJAMIN;
                        if (error === "0") {
                            alert("Data penjamin berhasil disimpan");
                            window.location = "../masterkredit/penjamin_kredit.jsp";
                        } else {
                            alert(data.RETURN_MESSAGE);
                        }
                    };

                    onSuccess = function (data) {
                        $('#btn_save').removeAttr('disabled').html(buttonName);
                    };

                    var data = $(this).serialize();
                    var dataSend = "" + data + "&FRM_FIELD_OID=" + oid + "&FRM_FIELD_DATA_FOR=" + dataFor + "&command=" + command;
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxAnggota", null, false);
                    return false;
                });

                $('#form_persentase_jaminan').submit(function () {
                    var buttonName = $('#btn_save_persentase').html();
                    $('#btn_save_persentase').attr({"disabled": "true"}).html("Tunggu...");

                    var coverage = $('#VAL_PERSEN_COVERAGE').val();
                    var jangka = $('#JANGKA_WAKTU').val();
                    var persen = $('#VAL_PERSEN_DIJAMIN').val();
                    var dataSend = {
                        "FRM_FIELD_OID": $('#ID_PERSENTASE_JAMINAN').val(),
                        "SEND_OID_PENJAMIN": $('#ID_PENJAMIN_KREDIT').val(),
                        "FRM_FIELD_DATA_FOR": "savePersentaseJaminan",
                        "command": "<%=Command.SAVE%>",
                        "SEND_JANGKA_WAKTU": jangka,
                        "SEND_PROSENTASE_COVERAGE": coverage,
                        "SEND_PROSENTASE_DIJAMIN": persen
                    };
                    //alert(JSON.stringify(dataSend));
                    onDone = function (data) {
                        var error = data.SEND_ERROR_CODE;
                        if (error === "0") {
                            //alert(data.SEND_MESSAGE);
                            window.location = "../masterkredit/penjamin_kredit.jsp?penjamin_id=<%=oidPenjamin%>&command=<%=Command.ASK%>";
                        } else {
                            alert(data.SEND_MESSAGE);
                        }
                    };
                    onSuccess = function (data) {
                        $('#btn_save_persentase').removeAttr('disabled').html(buttonName);
                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxPenjamin", null, false);
                    return false;
                });

                $('#JANGKA_WAKTU_TAHUN').keyup(function () {
                    var tahun = $(this).val();
                    var bulan = (tahun * 12);
                    $('#JANGKA_WAKTU').val(bulan);
                });

                $('#JANGKA_WAKTU_TAHUN').focusout(function () {
                    $('#JANGKA_WAKTU_TAHUN').val("");
                });

                $('#JANGKA_WAKTU').keyup(function () {
                    $('#JANGKA_WAKTU_TAHUN').val("");
                });

                $('.val_persen').click(function () {
                    var oid = $(this).data('oid');
                    var coverage = $(this).data('coverage');
                    var jangka = $(this).data('jangka');
                    var persen = $(this).data('persentase');
                    $('#ID_PERSENTASE_JAMINAN').val(oid);
                    $('#PERSEN_COVERAGE').val(coverage);
                    jMoney('#PERSEN_COVERAGE');
                    $('#VAL_PERSEN_COVERAGE').val(coverage);
                    $('#JANGKA_WAKTU').val(jangka);
                    $('#PERSEN_DIJAMIN').val(persen);
                    jMoney('#PERSEN_DIJAMIN');
                    $('#VAL_PERSEN_DIJAMIN').val(persen);
                });

                $('.val_persen').dblclick(function () {
                    if (confirm("Yakin ingin menghapus data ini ?")) {
                        var oid = $(this).data('oid');
                        var dataSend = {
                            "FRM_FIELD_OID": oid,
                            "FRM_FIELD_DATA_FOR": "deletePersentaseJaminan",
                            "command": "<%=Command.DELETE%>"
                        };
                        onDone = function (data) {
                            var error = data.SEND_ERROR_CODE;
                            if (error === "0") {
                                alert(data.SEND_MESSAGE);
                                window.location = "../masterkredit/penjamin_kredit.jsp?penjamin_id=<%=oidPenjamin%>&command=<%=Command.ASK%>";
                            } else {
                                alert(data.SEND_MESSAGE);
                            }
                        };
                        onSuccess = function (data) {

                        };
                        //alert(JSON.stringify(dataSend));
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxPenjamin", null, false);
                        return false;
                    }
                });
                
            });
        </script>

    </head>
    <body style="background-color: #eaf3df;">

        <section class="content-header">
            <h1>
                Penjamin Kredit
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Master Kredit</li>
                <li class="active"><a href="../masterkredit/penjamin_kredit.jsp?penjamin_id=0&command=<%=Command.ADD%>">Penjamin Kredit</a></li>
            </ol>
        </section>

        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border" style="border-color: lightgray">
                    <h3 class="box-title">Daftar Penjamin Kredit</h3>
                </div>
                <div class="box-body">
                    <table class="table table-bordered table-striped">
                        <tr class="label-success">
                            <th style="width: 1%">No.</th>
                            <th>Nomor Penjamin</th>
                            <th>Nama Penjamin</th>
                            <th>Telepon</th>
                            <th>Email</th>
                            <th>Alamat</th>
                            <th>Nomor Akte Pendirian</th>
                            <th>NPWP</th>
                            <th style="width: 1%">Aksi</th>
                        </tr>

                        <%if (listPenjamin.isEmpty()) {%>

                        <tr><td colspan="9" class="text-center label-default">Tidak ada data penjamin</td></tr>

                        <%} else {
                            for (int i = 0; i < listPenjamin.size(); i++) {
                                AnggotaBadanUsaha dataPenjamin = (AnggotaBadanUsaha) listPenjamin.get(i);
                        %>
                        <tr>
                            <td><%=(i + 1)%></td>
                            <td><%=dataPenjamin.getNoAnggota()%></td>
                            <td><%=dataPenjamin.getName()%></td>
                            <td><%=dataPenjamin.getTelepon()%></td>
                            <td><%=dataPenjamin.getEmail()%></td>
                            <td><%=dataPenjamin.getOfficeAddress()%></td>
                            <td><%=dataPenjamin.getIdCard()%></td>
                            <td><%=dataPenjamin.getNoNpwp()%></td>
                            <td class="text-center" style="white-space: nowrap">
                                <button type="button" class="btn btn-xs btn-warning btn_edit" data-oid="<%=dataPenjamin.getOID()%>">Ubah</button>
                                <button type="button" class="btn btn-xs btn-info btn_view" data-oid="<%=dataPenjamin.getOID()%>">Persentase Jaminan</button>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>

                    </table>
                </div>
                <div class="box-footer" style="border-color: lightgray">
                    <button type="button" class="btn btn-sm btn-primary" id="btn_add"><i class="fa fa-plus"></i> &nbsp; Tambah Penjamin</button>
                </div>
            </div>

            <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>

            <div class="box box-success">

                <div class="box-header with-border" style="border-color: lightgrey">                    
                    <h3 class="box-title">Form Input Penjamin Kredit</h3>
                </div>

                <p></p>

                <form id="form_penjaminkredit" class="form-horizontal">

                    <div class="box-body">
                        <input type="hidden" value="<%=oidPenjamin%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ID_ANGGOTA]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ID_ANGGOTA]%>">

                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label col-sm-4">Nomor Penjamin</label>
                                <div class="col-sm-8">
                                    <input type="text" placeholder="Otomatis jika kosong" class="form-control input-sm" value="<%=penjamin.getNoAnggota()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NO_ANGGOTA]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NO_ANGGOTA]%>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-4">Nama Penjamin</label>
                                <div class="col-sm-8">
                                    <input type="text" required="" class="form-control input-sm" value="<%=penjamin.getName()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NAME_ANGGOTA]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NAME_ANGGOTA]%>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-4">Nomor Telepon</label>
                                <div class="col-sm-8">
                                    <input type="text" required="" class="form-control input-sm" value="<%=penjamin.getTelepon()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_TLP]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_TLP]%>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-4">Alamat Email</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control input-sm" value="<%=penjamin.getEmail()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_EMAIL]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_EMAIL]%>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-4">Alamat Badan Usaha</label>
                                <div class="col-sm-8">
                                    <input type="text" required="" class="form-control input-sm" value="<%=penjamin.getOfficeAddress()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_OFFICE_ADDRESS]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_OFFICE_ADDRESS]%>">
                                </div>
                            </div>
                                
                        </div>

                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label col-sm-4">Kota Lokasi Alamat</label>
                                <div class="col-sm-8">
                                    <select class="form-control input-sm" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ADDR_OFFICE_CITY]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ADDR_OFFICE_CITY]%>">
                                        <%
                                            Vector<City> listCity = PstCity.list(0, 0, "", "");
                                            for (int i = 0; i < listCity.size(); i++) {
                                        %>

                                        <%if (iCommand == Command.EDIT && penjamin.getAddressOfficeCity() == listCity.get(i).getOID()) {%>
                                        <option selected="" value="<%=listCity.get(i).getOID()%>"><%=listCity.get(i).getCityName()%></option>
                                        <%} else {%>
                                        <option value="<%=listCity.get(i).getOID()%>"><%=listCity.get(i).getCityName()%></option>
                                        <%}%>

                                        <%
                                            }
                                        %>
                                    </select>                                
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-4">Nomor Akte Pendirian</label>
                                <div class="col-sm-8">
                                    <input type="text" required="" class="form-control input-sm" value="<%=penjamin.getIdCard()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ID_CARD]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_ID_CARD]%>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-4">Nomor NPWP</label>
                                <div class="col-sm-8">
                                    <input type="text" required="" class="form-control input-sm" value="<%=penjamin.getNoNpwp()%>" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NO_NPWP]%>" id="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_NO_NPWP]%>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-4">Jenis Transaksi</label>
                                <div class="col-sm-8">
                                    <select required="" class="form-control input-sm" id="ID_TRANSAKSI" name="<%=FrmAnggotaBadanUsaha.fieldNames[FrmAnggotaBadanUsaha.FRM_JENIS_TRANSAKSI_ID]%>">
                                        <option value="">- Pilih Transaksi -</option>
                                        <%
                                            Vector<JenisTransaksi> listJenisTransaksi = PstJenisTransaksi.list(0, 0, "" + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_DOC] + " = '" + JenisTransaksi.TIPE_DOC_KREDIT_NASABAH_BIAYA_ASURANSI + "'", "");
                                            for (int i = 0; i < listJenisTransaksi.size(); i++) {
                                                String selected = "";
                                                if (listJenisTransaksi.get(i).getOID() == penjamin.getIdJenisTransaksi()) {
                                                    selected = "selected";
                                                }
                                        %>
                                        <option <%=selected%> value="<%=listJenisTransaksi.get(i).getOID()%>"><%=listJenisTransaksi.get(i).getJenisTransaksi()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="box-footer" style="border-color: lightgrey">
                        <div class="pull-right">
                            <button type="submit" id="btn_save" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                            <button type="button" id="" class="btn btn-sm btn-default btn_cancel"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                        </div>
                    </div>

                </form>
            </div>  

            <%}%>

            <%if (iCommand == Command.ASK && oidPenjamin > 0) {%>

            <div class="box box-success">

                <div class="box-header with-border" style="border-color: lightgrey">                    
                    <h3 class="box-title">Persentase Jaminan <a><%=penjamin.getName()%></a></h3>
                </div>

                <p></p>

                <form id="form_persentase_jaminan" class="form-horizontal">

                    <div class="box-body">

                        <input type="hidden" id="ID_PERSENTASE_JAMINAN" value="<%=oidPersentase%>">
                        <input type="hidden" id="ID_PENJAMIN_KREDIT" value="<%=oidPenjamin%>">

                        <label>Rincian Persentase Jaminan Per Jangka Waktu Kredit :</label>
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <tr class="label-success">
                                    <th rowspan="2" style="width: 40px">No.</th>
                                    <th rowspan="2" style="width: 1%">Coverage</th>
                                    <th colspan="<%=listJangkaWaktu.size()%>">Jangka Waktu Kredit ( Bulan )</th>                                    
                                </tr>
                                <tr>
                                    <%for (int i = 0; i < listJangkaWaktu.size(); i++) {%>
                                    <th class="label-default"><%=listJangkaWaktu.get(i).getJangkaWaktu()%></th>
                                        <%}%>
                                </tr>

                                <% if (listJangkaWaktu.isEmpty()) { %>
                                <tr><td colspan="3" class="text-center label-default">Tidak ada data persentase</td></tr>
                                <% } else {%>

                                <% for (int i = 0; i < listCoverage.size(); i++) {%>                                    
                                <tr>
                                    <td><%=(i + 1)%>.</td>
                                    <td class="label-default text-center"><%=listCoverage.get(i).getPersentaseCoverage()%> %</td>
                                    <%
                                        for (int j = 0; j < listJangkaWaktu.size(); j++) {
                                            Vector<PersentaseJaminan> listPersentase = PstPersentaseJaminan.list(0, 0, "" + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_ID_PENJAMIN] + " = '" + oidPenjamin + "'"
                                                    + " AND " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_PERSENTASE_COVERAGE] + " = '" + listCoverage.get(i).getPersentaseCoverage() + "'"
                                                    + " AND " + PstPersentaseJaminan.fieldNames[PstPersentaseJaminan.FLD_JANGKA_WAKTU] + " = '" + listJangkaWaktu.get(j).getJangkaWaktu() + "'", "");
                                    %>

                                    <% if (listPersentase.isEmpty()) { %>

                                    <td></td>

                                    <% } else { %>

                                    <td class="text-center nilai_persen">

                                        <% for (PersentaseJaminan pj : listPersentase) {%>
                                        <a style="color: black" class="val_persen btn btn-xs" data-oid="<%=pj.getOID()%>" data-coverage="<%=pj.getPersentaseCoverage()%>" data-jangka="<%=pj.getJangkaWaktu()%>" data-persentase="<%=pj.getPersentaseDijamin()%>">
                                            <%=pj.getPersentaseDijamin()%> %
                                        </a>
                                        <% } %>

                                    </td>
                                    <% } %>

                                    <% } %>
                                </tr>
                                <% } %>

                                <% } %>

                            </table>
                        </div>
                        <label>Petunjuk :</label>
                        <ul style="padding-left: 20px;">
                            <li>Untuk menambah nilai persentase dapat dilakukan dengan mengisi form di bawah. (Tekan tombol "Coverage Baru")</li>
                            <li>Form input "Kalkulator" digunakan untuk membantu menghitung nilai bulan untuk jangka waktu dalam satuan tahun.
                                <br>
                                Jika nilai bulan diisi maka nilai tahun tidak perlu diisi dan sebaliknya.
                            </li>
                            <li>Untuk mengubah nilai persentase dapat dilakukan dengan meng-<i>click</i> nilai persentase yang ingin diubah.</li>
                            <li>Untuk menghapus nilai persentase dapat dilakukan dengan men-<i>double-click</i> nilai persentase yang ingin dihapus.</li>                            
                        </ul>
                        <!--/div-->

                        <hr style="border-color: lightgray">

                        <!--div class="box-body"-->

                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="control-label col-sm-6">Persentase Coverage</label>
                                <div class="col-sm-6">
                                    <div class="input-group">
                                        <input type="text" autocomplete="off" required="" data-cast-class="coverage" class="form-control input-sm money" value="" id="PERSEN_COVERAGE">
                                        <input type="hidden" class="coverage" value="" id="VAL_PERSEN_COVERAGE">
                                        <span class="input-group-addon">%</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="control-label col-sm-5">Jangka Waktu</label>                                
                                <div class="col-sm-7">
                                    <div class="input-group">
                                        <input type="text" autocomplete="off" required="" class="form-control input-sm" value="" name="" id="JANGKA_WAKTU">
                                        <span class="input-group-addon">Bulan</span>
                                    </div>                                                                      
                                </div>
                                <font class="control-label col-sm-5">Kalkulator</font>
                                <div class="col-sm-7">
                                    <div class="input-group">
                                        <input type="text" autocomplete="off" class="form-control input-sm" value="" name="" id="JANGKA_WAKTU_TAHUN">
                                        <span class="input-group-addon">Tahun</span>
                                    </div>  
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="control-label col-sm-6">Persentase Dibayar</label>
                                <div class="col-sm-6">
                                    <div class="input-group">
                                        <input type="text" autocomplete="off" required="" data-cast-class="jaminan" class="form-control input-sm money" value="" id="PERSEN_DIJAMIN">
                                        <input type="hidden" class="jaminan" value="" id="VAL_PERSEN_DIJAMIN">
                                        <span class="input-group-addon">%</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="box-footer" style="border-color: lightgray">
                        <div class="col-sm-12">
                            <button type="button" id="btnNew" class="btn btn-sm btn-primary"><i class="fa fa-plus"></i> &nbsp; Coverage Baru</button>
                            <div class="pull-right">
                                <button type="submit" id="btn_save_persentase" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                                <button type="button" id="" class="btn btn-sm btn-default btn_cancel"><i class="fa fa-undo"></i> &nbsp; Selesai</button>
                            </div>                            
                        </div>
                    </div>

                </form>

            </div>

            <%}%>

            <a href="penjamin_kredit.jsp?show_history=<%= (showHistory == 0) ? "1" : "0"%>"><%= (showHistory == 0) ? "Lihat Riwayat Perubahan" : "Sembunyikan Riwayat Perubahan"%></a>
            <p>
            <% if (showHistory == 1) { %>  
            <div class="box box-default">
                <div class="box-header">
                    <h3 class="box-title">Riwayat Perubahan</h3>
                </div>
                <div class="box-body">
                    <%
                        JSONObject obj = new JSONObject();
                        JSONArray arr = new JSONArray();
                        arr.put(SessHistory.document[SessHistory.DOC_MASTER_KOLEKTIBILITAS_PEMBAYARAN]);
                        obj.put("doc", arr);
                        obj.put("time", "");
                        request.setAttribute("obj", obj);
                    %>
                    <%@ include file = "/history_log/history_table.jsp" %>
                </div>
            </div>
            <% }%>

        </section>
    </body>
</html>
