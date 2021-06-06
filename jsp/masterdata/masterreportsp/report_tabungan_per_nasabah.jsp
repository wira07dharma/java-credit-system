<%-- 
    Document   : report_tabungan_per_nasabah
    Created on : Dec 7, 2017, 9:14:39 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import = "com.dimata.util.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>
<%//
    int iCommand = FRMQueryString.requestCommand(request);
    String tglAwal = FRMQueryString.requestString(request, "FRM_TGL_AWAL");
    String tglAkhir = FRMQueryString.requestString(request, "FRM_TGL_AKHIR");
    String arrayTabungan[] = request.getParameterValues("FRM_TABUNGAN");
    String arrayNasabah[] = request.getParameterValues("FRM_NASABAH");
    
    String addSql = "";
    String nasabah = "";
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
        }
        if (!idNasabah.equals("")) {
            addSql += " AND a." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " IN (" + idNasabah + ")";
        }
    } else {
        nasabah = "Semua " + namaNasabah;
    }
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@ include file = "/style/style_kredit.jsp" %>
        <script>
            $(document).ready(function () {

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

                function selectMulti(id, placeholder) {
                    $(id).select2({
                        placeholder: placeholder
                    });
                }

                selectMulti('.select2tabungan', "Semua Tabungan");
                selectMulti('.select2nasabah', "Semua <%=namaNasabah%>");

                $('#form_cari').submit(function () {
                    $('#btn_cari').attr({"disabled": "true"}).html("<i class='fa fa-spinner fa-pulse'></i> &nbsp; Tunggu...");
                });

                $('#btn-print').click(function () {
                    var buttonHtml = $(this).html();
                    $(this).attr({"disabled": "true"}).html("Tunggu...");
                    window.print();
                    $(this).removeAttr('disabled').html(buttonHtml);
                });

            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">

            <section class="content-header">
                <h1>
                    Laporan Tabungan Per <%=namaNasabah%>
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Laporan</li>
                    <li class="active">Tabungan</li>
                </ol>
            </section>

            <section class="content">                
                <div class="box box-success">

                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Pencarian</h3>                        
                    </div>

                    <div class="box-body">
                        <form id="form_cari" class="form-inline" method="post" action="?command=<%=Command.LIST%>">
                            
                            <input type="text" style="width: 150px" placeholder="Tanggal awal" id="tgl_awal" class="form-control input-sm date-picker" name="FRM_TGL_AWAL" value="<%=tglAwal%>">
                            &nbsp;s.d.&nbsp;
                            <input type="text" style="width: 150px" placeholder="Tanggal akhir" id="tgl_akhir" class="form-control input-sm date-picker" name="FRM_TGL_AKHIR" value="<%=tglAkhir%>">
                            &nbsp;&nbsp;
                            <select multiple="" style="width: 300px" id="id_tabungan" class="form-control input-sm select2tabungan" name="FRM_TABUNGAN">
                                <%
                                    Vector listTabungan = PstMasterTabungan.list(0, 0, "", "");                                    
                                    for (int i = 0; i < listTabungan.size(); i++) {
                                        MasterTabungan mt = (MasterTabungan) listTabungan.get(i);
                                        long id = mt.getOID();
                                        String selected = "";
                                        if (arrayTabungan != null) {
                                            for (int j = 0; j < arrayTabungan.length; j++) {
                                                long isi = Long.valueOf(arrayTabungan[j]);
                                                if (isi == id) {
                                                    selected = "selected";
                                                    break;
                                                }
                                            }
                                        }
                                %>
                                <option <%=selected%> value="<%=mt.getOID()%>"><%=mt.getNamaTabungan()%></option>
                                <%
                                    }
                                %>
                            </select>
                            &nbsp;&nbsp;
                            <select multiple="" style="width: 300px" id="id_nasabah" class="form-control input-sm select2nasabah" name="FRM_NASABAH">
                                <%
                                    Vector listNasabah = SessAnggota.listJoinContactClassAssign(0, 0, ""
                                            + " cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.CONTACT_TYPE_MEMBER + "'"
                                            + " OR cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_KELOMPOK_BADAN_USAHA + "'"
                                            + "", "cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]);
                                    for (int i = 0; i < listNasabah.size(); i++) {
                                        Anggota a = (Anggota) listNasabah.get(i);
                                        long id = a.getOID();
                                        String selected = "";
                                        if (arrayNasabah != null) {
                                            for (int j = 0; j < arrayNasabah.length; j++) {
                                                long isi = Long.valueOf(arrayNasabah[j]);
                                                if (isi == id) {
                                                    selected = "selected";
                                                    break;
                                                }
                                            }
                                        }
                                %>
                                <option <%=selected%> value="<%=a.getOID()%>"><%=a.getName()%></option>
                                <%
                                    }
                                %>
                            </select>    
                            &nbsp;&nbsp;
                            <button type="submit" id="btn_cari" class="btn btn-sm btn-primary"><i class="fa fa-search"> &nbsp; Cari</i></button>
                        </form>
                    </div>
                            
                </div>                
            </section>

        </div>
    </body>
</html>
