<%-- 
    Document   : kelompok_tabungan
    Created on : Aug 28, 2017, 12:02:22 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.session.SessReportTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstAssignPenarikanTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.AssignPenarikanTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.common.session.convert.Master"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.PstAssignTabungan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.AssignTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan"%>
<%@page import="com.dimata.sedana.entity.anggota.PstAnggotaBadanUsaha"%>
<%@page import="com.dimata.sedana.entity.anggota.AnggotaBadanUsaha"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.util.Formater"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>

<%!
    public String getNamaTabunganAlokasiBunga(long idSimpanan) {
        String namaTabunganAlokasiBunga = "";
        try {
            DataTabungan dt = PstDataTabungan.fetchExc(idSimpanan);
            long idAlokasiBunga = (dt.getIdAlokasiBunga() == 0) ? dt.getOID() : dt.getIdAlokasiBunga();
            DataTabungan dtAlokasi = PstDataTabungan.fetchExc(idAlokasiBunga);
            String noTabunganAlokasi = PstAssignContactTabungan.fetchExc(dtAlokasi.getAssignTabunganId()).getNoTabungan();
            String namaSimpananAlokasi = PstJenisSimpanan.fetchExc(dtAlokasi.getIdJenisSimpanan()).getNamaSimpanan();
            namaTabunganAlokasiBunga = noTabunganAlokasi + " (" + namaSimpananAlokasi + ")";
        } catch (Exception e) {
            namaTabunganAlokasiBunga = e.getMessage();
        }
        return namaTabunganAlokasiBunga;
    }
%>

<% //
    long idKelompok = FRMQueryString.requestLong(request, "kelompok_id");
    long idAssignContactTabungan = FRMQueryString.requestLong(request, "assign_id");
    int iCommand = FRMQueryString.requestCommand(request);
    
    String enableTabungan = PstSystemProperty.getValueByName("SEDANA_ENABLE_TABUGAN");
    int jumlahSemuaSimpana = PstDataTabungan.getCount(PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA] + " = " + idKelompok);
    int jumlahSimpananTerdeteksi = 0;
    
    AnggotaBadanUsaha abu = new AnggotaBadanUsaha();
    try {
        abu = PstAnggotaBadanUsaha.fetchExc(idKelompok);
    } catch (Exception e) {
        System.out.println(e.getMessage());
    }
    
    AssignContactTabungan assign = new AssignContactTabungan();
    String namaSimpananEdit = "";
    int punyaPeriodePenarikan = 0;
    int bulanPeriodeDeposito = 0;
    if (idAssignContactTabungan != 0) {
        try {
            assign = PstAssignContactTabungan.fetchExc(idAssignContactTabungan);
            MasterTabungan mt = PstMasterTabungan.fetchExc(assign.getMasterTabunganId());
            Vector<AssignTabungan> assignTabungan = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN] + "=" + mt.getOID(), "");
            for (int in = 0; in < assignTabungan.size(); in++) {
                JenisSimpanan js = PstJenisSimpanan.fetchExc(assignTabungan.get(in).getIdJenisSimpanan());
                if (in == 0) {
                    namaSimpananEdit += js.getNamaSimpanan();
                } else {
                    namaSimpananEdit += ", " + js.getNamaSimpanan();
                }
            }
            //CARI PERIODE PENARIKAN
            punyaPeriodePenarikan = PstAssignPenarikanTabungan.list(0, 0, PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_MASTER_TABUNGAN_ID] + " = " + mt.getOID(), null).size();
            bulanPeriodeDeposito = SessReportTabungan.getPeriodeBulanDeposito(idAssignContactTabungan);
        } catch (Exception e) {
            
        }
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
            th {font-size: 14px; text-align: center; font-weight: normal}
            td {font-size: 14px; vertical-align: text-top}
            /*select option {padding: 5px;}*/
            .btn_edit:hover {cursor: pointer}
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

                $('.date-picker').datetimepicker({
                    weekStart: 1,
                    format: "yyyy-mm-dd",
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2 // No time
                            // showMeridian: 0
                });

                $('#btn_add').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../anggota/kelompok_tabungan.jsp?kelompok_id=<%=idKelompok%>&assign_id=0&command=<%=Command.ADD%>";
                });

                $('.btn_edit').click(function () {
                    var buttonName = $('.btn_edit').html();
                    //$(this).attr({"disabled": "true"}).html(buttonName+' <i class="fa fa-spinner fa-pulse"></i>');
                    var oid = $(this).data('oid');
                    window.location = "../anggota/kelompok_tabungan.jsp?kelompok_id=<%=idKelompok%>&assign_id=" + oid + "&command=<%=Command.EDIT%>";
                });

                $('#NAMA_TABUNGAN').change(function () {
                    var oid = $(this).val();
                    var command = "<%=Command.NONE%>";
                    var dataFor = "getJenisSimpananTabungan";

                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command
                    };
                    //alert(JSON.stringify(dataSend));
                    onDone = function (data) {
                        var error = data.RETURN_ERROR_CODE;
                        if (error === "1") {
                            alert(data.RETURN_MESSAGE);
                        } else {
                            $('#JENIS_SIMPANAN').val(data.RETURN_MESSAGE);
                            $('#NOMOR_TABUNGAN').val(data.KODE_TAB + "-" + "<%= abu.getNoAnggota()%>");
                        }
                    };
                    onSuccess = function (data) {

                    };
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                    return false;
                });

                $('#btn_save').click(function () {
                    var buttonName = $('#btn_save').html();
                    $('#btn_save').attr({"disabled": "true"}).html("Tunggu...");

                    var oid = $('#ID_ASSIGN').val();
                    var command = "<%=Command.SAVE%>";
                    var dataFor = "saveTabunganKelompok";

                    var allIdSimpanan = "";
                    $(".FRM_ID_SIMPANAN_ALL").each(function () {
                        allIdSimpanan += (allIdSimpanan.length > 0) ? "," + $(this).val() : $(this).val();
                    });

                    var idAlokasi = "";
                    $(".FRM_ID_SIMPANAN_ALOKASI").each(function () {
                        idAlokasi += (idAlokasi.length > 0) ? "," + $(this).val() : $(this).val();
                    });

                    var dataSend = {
                        "FRM_FIELD_OID": oid,
                        "FRM_FIELD_DATA_FOR": dataFor,
                        "command": command,
                        "SEND_NO_TABUNGAN": $('#NOMOR_TABUNGAN').val(),
                        "SEND_OID_MASTER_TABUNGAN": $('#NAMA_TABUNGAN').val(),
                        "SEND_OID_NASABAH": $('#ID_NASABAH').val(),
                        "FRM_ID_SIMPANAN_ALL": allIdSimpanan,
                        "FRM_ID_SIMPANAN_ALOKASI": idAlokasi
                    };

                    onDone = function (data) {
                        var error = data.RETURN_ERROR_CODE;
                        if (error === "1") {
                            alert(data.RETURN_MESSAGE);
                        } else {
                            alert(data.RETURN_MESSAGE);
                            window.location = "../anggota/kelompok_tabungan.jsp?kelompok_id=<%=idKelompok%>";
                        }
                    };

                    onSuccess = function (data) {
                        $('#btn_save').removeAttr('disabled').html(buttonName);
                    };

                    dataSend = $('#FORM_TABUNGAN').serialize();
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxAnggota", null, false);
                    return false;
                });

                $('#btn_delete').click(function () {
                    if (confirm("Yakin ingin menghapus data ini ?")) {
                        var buttonName = $('#btn_delete').html();
                        $('#btn_delete').attr({"disabled": "true"}).html("Tunggu...");

                        var oid = $('#ID_ASSIGN').val();
                        var command = "<%=Command.DELETE%>";
                        var dataFor = "deleteTabunganKelompok";
                        var dataSend = {
                            "FRM_FIELD_OID": oid,
                            "FRM_FIELD_DATA_FOR": dataFor,
                            "command": command
                        };
                        onDone = function (data) {
                            var error = data.RETURN_ERROR_CODE;
                            if (error === "0") {
                                alert(data.RETURN_MESSAGE);
                                window.location = "../anggota/kelompok_tabungan.jsp?kelompok_id=<%=idKelompok%>";
                            } else if (error === "1") {
                                alert(data.RETURN_MESSAGE);
                            }
                        };
                        onSuccess = function (data) {
                            $('#btn_delete').removeAttr('disabled').html(buttonName);
                        };
                        //alert(JSON.stringify(dataSend));
                        getDataFunction(onDone, onSuccess, dataSend, "AjaxAnggota", null, false);
                        return false;
                    }
                });

                $('#btn_cancel').click(function () {
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.location = "../anggota/kelompok_tabungan.jsp?kelompok_id=<%=idKelompok%>";
                });

            });
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
            <%if(enableTabungan.equals("1")){%> 
            <a class="btn btn-danger" href="../anggota/kelompok_tabungan.jsp?kelompok_id=<%=idKelompok%>">Data Tabungan</a>
            <%}%>
            <a style="background-color: white" class="btn btn-default" href="../anggota/kelompok_dokumen.jsp?kelompok_id=<%=idKelompok%>">Dokumen Bersangkutan</a>
            <a style="font-size: 14px" class="btn-box-tool" href="../anggota/list_anggota_kelompok.jsp">Kembali ke daftar <%=namaNasabah%></a>
        </section>
        <%}%>

        <section class="content">
            <div class="box box-success">

                <div class="box-header with-border" style="border-color: lightgrey">
                    <h3 class="box-title">Nama <%=namaNasabah%> &nbsp;:&nbsp; <a><%=abu.getName()%></a></h3>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <h3 class="box-title">Nomor <%=namaNasabah%> &nbsp;:&nbsp; <a><%=abu.getNoAnggota()%></a></h3>
                </div>

                <div class="box-body">
                    <label>Daftar Tabungan</label>
                    <div style="width: 100%">
                        <table class="table table-bordered">
                            <tr class="label-success">
                                <th style="width: 1%">No.</th>
                                <th>Nomor Tabungan</th>
                                <th>Nama Tabungan</th>
                                <th>Jenis Item</th>
                                <th>Alokasi Bunga</th>
                                <th>Tgl Buka Tabungan</th>
                                <th>Transaksi Terakhir</th>
                                <th>Tgl Tutup Tabungan</th>
                                <th>Status</th>
                            </tr>

                            <% Vector<AssignContactTabungan> listTabungan = PstAssignContactTabungan.list(0, 0, "" + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_CONTACT_ID] + " = '" + idKelompok + "'", ""); %>

                            <% if (listTabungan.isEmpty()) { %>

                            <tr><td class="text-center label-default" colspan="9">Tidak ada data tabungan</td></tr>

                            <% } %>

                            <%
                                for (int i = 0; i < listTabungan.size(); i++) {
                                    AssignContactTabungan act = (AssignContactTabungan) listTabungan.get(i);
                                    MasterTabungan mt = PstMasterTabungan.fetchExc(act.getMasterTabunganId());
                                    int jumlahPeriodePenarikan = PstAssignPenarikanTabungan.getCount(PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_MASTER_TABUNGAN_ID] + " = " + mt.getOID());
                                    String periodePenarikan = (jumlahPeriodePenarikan == 0) ? "" : "<br>(<a href='"+approot+"/masterdata/mastertabungan/master_tabungan.jsp?set_periode=1&hidden_masterTabungan_id="+mt.getOID()+"'>" + jumlahPeriodePenarikan + " periode penarikan</a>)";

                                    //GET DATA SIMPANAN (aiso_data_tabungan)
                                    Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + act.getOID(), PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL]);
                                    jumlahSimpananTerdeteksi += listSimpanan.size();
                                    JenisSimpanan js = new JenisSimpanan();
                                    String namaSimpanan = "-";
                                    String alokasiBunga = "-";
                                    String statusSimpanan = "Tidak terdaftar";
                                    String tglBukaTab = "-";
                                    String tglTutupTab = "-";
                                    //GET DATA SIMPANAN PERTAMA
                                    if (!listSimpanan.isEmpty()) {
                                        js = PstJenisSimpanan.fetchExc(listSimpanan.get(0).getIdJenisSimpanan());
                                        namaSimpanan = js.getNamaSimpanan();
                                        alokasiBunga = getNamaTabunganAlokasiBunga(listSimpanan.get(0).getOID());
                                        statusSimpanan = (listSimpanan.get(0).getStatus() == 1) ? "Aktif" : "Tidak Aktif";
                                        tglBukaTab = (listSimpanan.get(0).getTanggal() == null) ? "-" : "" + Formater.formatDate(listSimpanan.get(0).getTanggal(), "yyyy-MM-dd HH:mm:ss");
                                        tglTutupTab = (listSimpanan.get(0).getTanggalTutup() == null) ? "-" : "" + Formater.formatDate(listSimpanan.get(0).getTanggalTutup(), "yyyy-MM-dd HH:mm:ss");
                                    }
                            %>

                            <tr>
                                <td rowspan="<%= listSimpanan.size() %>"><%= (i + 1) %></td>
                                <td rowspan="<%= listSimpanan.size() %>"><a class="btn_edit" data-oid="<%=listTabungan.get(i).getOID()%>"><%=listTabungan.get(i).getNoTabungan()%></a></td>
                                <td rowspan="<%= listSimpanan.size() %>"><%= mt.getNamaTabungan() + periodePenarikan %></td>
                                <!--data simpanan pertama-->
                                <td><%= namaSimpanan %></td>
                                <td><%= alokasiBunga %></td>
                                <td><%= tglBukaTab %></td>
                                <td><%= PstTransaksi.getLastTransactionDate(idKelompok, act.getOID(), js.getOID()) %></td>
                                <td><%= tglTutupTab %></td>
                                <td><%= statusSimpanan %></td>
                            </tr>

                            <!-- GET SISA DATA SIMPANAN JIKA ADA -->
                            <%
                                for (int j = 1; j < listSimpanan.size(); j++) {
                                    namaSimpanan = "-";
                                    alokasiBunga = "-";
                                    statusSimpanan = "Tidak terdaftar";
                                    tglBukaTab = "-";
                                    tglTutupTab = "-";
                                    try {
                                        js = PstJenisSimpanan.fetchExc(listSimpanan.get(j).getIdJenisSimpanan());
                                        namaSimpanan = js.getNamaSimpanan();
                                        alokasiBunga = getNamaTabunganAlokasiBunga(listSimpanan.get(j).getOID());
                                        statusSimpanan = (listSimpanan.get(j).getStatus() == 1) ? "Aktif" : "Tidak Aktif";
                                        tglBukaTab = (listSimpanan.get(j).getTanggal() == null) ? "-" : "" + Formater.formatDate(listSimpanan.get(j).getTanggal(), "yyyy-MM-dd HH:mm:ss");
                                        tglTutupTab = (listSimpanan.get(j).getTanggalTutup() == null) ? "-" : "" + Formater.formatDate(listSimpanan.get(j).getTanggalTutup(), "yyyy-MM-dd HH:mm:ss");
                                    } catch (Exception e) {
                                        System.out.println(e.getMessage());
                                    }
                            %>
                            <tr>
                                <td><%= namaSimpanan %></td>
                                <td><%= alokasiBunga %></td>
                                <td><%= tglBukaTab %></td>
                                <td><%= PstTransaksi.getLastTransactionDate(idKelompok, act.getOID(), js.getOID()) %></td>
                                <td><%= tglTutupTab %></td>
                                <td><%= statusSimpanan %></td>
                            </tr>
                            <%
                                } //end for loop j
                            %>

                            <%
                                } //end for loop i
                            %>

                        </table>
                    </div>
                            
                    <%= (jumlahSemuaSimpana > jumlahSimpananTerdeteksi) ? "<i class='fa fa-exclamation-circle text-red'></i> <b>Terdapat " + jumlahSemuaSimpana + " data simpanan ditemukan !<b>":"" %>
                </div>

                <div class="box-footer" style="border-color: lightgrey">
                    <% if (idKelompok != 0) {%>
                    <button type="button" class="btn btn-sm btn-primary" id="btn_add"><i class="fa fa-plus"></i> &nbsp; Tambah Tabungan</button>
                    <% }%>
                </div>
            </div>

            <%if (iCommand == Command.ADD || iCommand == Command.EDIT) {%>

            <div class="box box-success">

                <div class="box-header with-border" style="border-color: lightgrey">
                    <h3 class="box-title">Form Input Tabungan</h3>
                </div>

                <p></p>

                <form id="FORM_TABUNGAN" class="form-horizontal" method="post">
                    <div class="box-body">

                        <input type="hidden" value="<%=idAssignContactTabungan%>" name="FRM_FIELD_OID" id="ID_ASSIGN">
                        <input type="hidden" value="saveTabunganKelompok" name="FRM_FIELD_DATA_FOR" id="">
                        <input type="hidden" value="<%= Command.SAVE%>" name="command" id="">
                        <input type="hidden" value="<%=idKelompok%>" name="SEND_OID_NASABAH" id="ID_NASABAH">

                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label col-sm-4">Nomor Tabungan</label>
                                <div class="col-sm-8">
                                    <%
                                        if (idAssignContactTabungan == 0) {
                                            String pref = "";
                                            String digit = "";
                                            boolean isUsed = false;
                                            int n = PstAssignContactTabungan.getCount(PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_NO_TABUNGAN] + " LIKE '" + pref + "%'");
                                            while (isUsed) {
                                                assign.setNoTabungan(Master.codeGenerator(pref, digit, String.valueOf(n)));
                                                isUsed = PstAssignContactTabungan.getCount(PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_NO_TABUNGAN] + "='" + assign.getNoTabungan() + "'") > 0;
                                                n++;
                                            }
                                        }
                                    %>
                                    <input type="text" class="form-control input-sm" name="SEND_NO_TABUNGAN" placeholder="Otomatis jika dikosongkan" value="<%= assign.getNoTabungan()%>" id="NOMOR_TABUNGAN">
                                    <input type="hidden" value="<%=assign.getNoTabungan()%>">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-4">Nama Tabungan</label>
                                <div class="col-sm-8">
                                    <select class="form-control input-sm" name="SEND_OID_MASTER_TABUNGAN" id="NAMA_TABUNGAN">
                                        <% Vector<MasterTabungan> listMasterTabungan = PstMasterTabungan.list(0, 0, "", "" + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN]);%>

                                        <% if (listMasterTabungan.isEmpty()) { %>
                                        <option>- Tidak ada data tabungan -</option>
                                        <% } else { %>

                                        <% if (iCommand == Command.ADD) {%>
                                        <option value="">- Pilih Tabungan -</option>
                                        <%}%>

                                        <% for (int i = 0; i < listMasterTabungan.size(); i++) {%>

                                        <%if (iCommand == Command.EDIT && assign.getMasterTabunganId() == listMasterTabungan.get(i).getOID()) {%>
                                        <option value="<%=listMasterTabungan.get(i).getOID()%>"><%=listMasterTabungan.get(i).getNamaTabungan()%></option>
                                        <%} else if (iCommand == Command.ADD) {%>
                                        <option value="<%=listMasterTabungan.get(i).getOID()%>"><%=listMasterTabungan.get(i).getNamaTabungan()%></option>
                                        <%}%>

                                        <% } %>

                                        <% }%>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-sm-4">Jenis Simpanan</label>
                                <div class="col-sm-8">
                                    <input readonly="" class="form-control input-sm" value="<%=namaSimpananEdit%>" name="" id="JENIS_SIMPANAN">
                                </div>
                            </div>

                        </div>

                        <% if (iCommand == Command.EDIT) { %>
                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label col-sm-4">Alokasi Bunga</label>
                                <div class="col-sm-8">
                                    <%
                                        //TAMPILKAN JENIS SIMPANAN DARI TABUNGAN
                                        Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + idAssignContactTabungan, null);
                                        for (DataTabungan dt : listSimpanan) {
                                            try {
                                                JenisSimpanan js = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
                                                long idAlokasiBunga = dt.getIdAlokasiBunga();
                                                String optionIdSimpanan = "";
                                                //GET SEMUA TABUNGAN YG DI MILIKI
                                                Vector<DataTabungan> listAllTab = PstDataTabungan.list(0, 0, PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA] + " = " + idKelompok, null);
                                                for (DataTabungan tab : listAllTab) {
                                                    String nomorTabungan = PstAssignContactTabungan.fetchExc(tab.getAssignTabunganId()).getNoTabungan();
                                                    String jenisSimpanan = PstJenisSimpanan.fetchExc(tab.getIdJenisSimpanan()).getNamaSimpanan();
                                                    String selected = (idAlokasiBunga == tab.getOID()) ? "selected" : "";
                                                    optionIdSimpanan += "<option " + selected + " value='" + tab.getOID() + "'>" + nomorTabungan + " (" + jenisSimpanan + ")</option>";
                                                }

                                    %>

                                    <div class="">
                                        <input type="hidden" value="<%= dt.getOID()%>" class="FRM_ID_SIMPANAN_ALL" name="FRM_ID_SIMPANAN_ALL">
                                        <div class="input-group">
                                            <span class="input-group-addon"><%= js.getNamaSimpanan()%></span>
                                            <select class="form-control input-sm FRM_ID_SIMPANAN_ALOKASI" name="FRM_ID_SIMPANAN_ALOKASI">
                                                <%= optionIdSimpanan%>
                                            </select>
                                        </div>
                                    </div>

                                    <%
                                            } catch (Exception e) {

                                            }
                                        }
                                    %>
                                </div>
                            </div>

                            <% if (bulanPeriodeDeposito > 0) { %>
                            <div class="form-group">
                                <label class="control-label col-sm-4">Tanggal Berakhir Deposito</label>
                                <div class="col-sm-8">
                                    <%
                                        for (DataTabungan dt : listSimpanan) {
                                            JenisSimpanan js = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
                                    %>
                                    <div class="input-group">
                                        <span class="input-group-addon"><%= js.getNamaSimpanan()%></span>
                                        <input type="text" placeholder="-" autocomplete="off" class="form-control input-sm date-picker" name="FRM_TANGGAL_TUTUP" value="<%= (dt.getTanggalTutup() == null) ? "" : Formater.formatDate(dt.getTanggalTutup(), "yyyy-MM-dd")%>">
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        <% } %>

                    </div>

                    <div class="box-footer" style="border-color: lightgrey">
                        <div class="form-group" style="margin-bottom: 0px">
                            <div class="col-sm-2"></div>
                            <div class="col-sm-10">
                                <div class="pull-right">
                                    <button type="button" id="btn_save" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Simpan</button>
                                    <button type="button" id="btn_cancel" class="btn btn-sm btn-default"><i class="fa fa-undo"></i> &nbsp; Kembali</button>
                                    <% if (iCommand == Command.EDIT) { %>
                                    <button type="button" id="btn_delete" class="btn btn-sm btn-danger"><i class="fa fa-remove"></i> &nbsp; Hapus</button>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>

            </div>

            <% }%>

        </section>

    </body>
</html>
