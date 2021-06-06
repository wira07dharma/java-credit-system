<%-- 
    Document   : multiple_penambahan_tabungan
    Created on : Jan 11, 2019, 1:49:06 PM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.common.entity.contact.PstContactClass"%>
<%@page import="com.dimata.aiso.session.masterdata.SessAnggota"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksi"%>
<%@page import="com.dimata.sedana.ajax.kredit.AjaxKredit"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.kredit.AngsuranPayment"%>
<%@page import="com.dimata.common.entity.payment.PstPaymentSystem"%>
<%@page import="com.dimata.common.entity.payment.PaymentSystem"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksiPayment"%>
<%@page import="com.dimata.sedana.entity.tabungan.TransaksiPayment"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.DetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.anggota.Anggota"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.sedana.session.SessReportTabungan"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../../main/checkuser.jsp" %>

<%//
    long tellerShiftId = 0;
    if (userOID != 0) {
        Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
        if (open.size() < 1) {
            String redirectUrl = approot + "/open_cashier.jsp?redir=" + approot + "/sedana/tabungan/multiple_penambahan_tabungan.jsp";
            response.sendRedirect(redirectUrl);
        } else {
            tellerShiftId = open.get(0).getOID();
        }
    }
%>

<%//
    int iCommand = FRMQueryString.requestCommand(request);
    int urut = FRMQueryString.requestInt(request, "ORDER_BY");
    String oidSimpanan[] = FRMQueryString.requestStringValues(request, "FORM_ID_SIMPANAN");
    String tgl[] = FRMQueryString.requestStringValues(request, "FORM_TGL_TRANSAKSI");
    String jumlahSetoran[] = FRMQueryString.requestStringValues(request, "FORM_JUMLAH_SETORAN");
    String oidAnggota[] = FRMQueryString.requestStringValues(request, "FORM_ID_ANGGOTA");
    String selectedNasabah[] = FRMQueryString.requestStringValues(request, "FRM_NASABAH");
    String selectedNoTab[] = FRMQueryString.requestStringValues(request, "FRM_SIMPANAN");
    
    String where = "";
    String order = "";
    Vector<Vector> listTabungan = new Vector();
    
    if (iCommand == Command.LIST) {
        if (selectedNasabah != null) {
            String id = "";
            for (String s : selectedNasabah) {
                id += id.isEmpty() ? s : "," + s;
            }
            where += " cl.CONTACT_ID IN ("+ id +")";
        }
        if (selectedNoTab != null) {
            String id = "";
            for (String s : selectedNoTab) {
                id += id.isEmpty() ? s : "," + s;
            }
            where += where.isEmpty() ? "":" OR ";
            where += " adt.ID_SIMPANAN IN ("+ id +")";
        }
        if (urut == 0) {
            order = "cl.PERSON_NAME";
        } else if (urut == 1) {
            order = "act.NO_TABUNGAN";
        }
        listTabungan = SessReportTabungan.getListSimpananSukarela(where, order);
    }
    
    String msg = "";
    if (iCommand == Command.SAVE) {
        msg = SessReportTabungan.saveMultipleSetoran(oidSimpanan, jumlahSetoran, tgl, oidAnggota, tellerShiftId);
        msg = (msg.isEmpty()) ? "Semua setoran berhasil disimpan" : msg;
    }
    
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@ include file = "/style/style_kredit.jsp" %>
        <title>SEDANA</title>
        <style>
            .table th {text-align: left}
            .table {font-size: 14px}
        </style>
        <script>
            function simpanSetoran() {
                if (confirm("Yakin akan menyimpan setoran ?")) {
                    $('#btnSave').attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu");
                    $('#form_setoran').submit();
                }
            }
            
            $(document).ready(function () {
                $('.datetime-picker').datetimepicker({
                    format: "yyyy-mm-dd hh:ii:ss",
                    weekStart: 1,
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

                selectMulti('.select2tabungan', "Semua nomor tabungan");
                
                $('#btnSearch').click(function(){
                    var tabunganSelected = $('.select2tabungan').val();
                    var msg = "Yakin ingin menampilkan seluruh data tabungan ?";
                    if (tabunganSelected === null) {
                        if (confirm(msg)) {
                            $(this).attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu");
                            $('#formSearch').submit();
                        }
                    } else {
                        $(this).attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu");
                        $('#formSearch').submit();
                    }
                });
                
            });
                
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>Multiple Setoran<small></small></h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Transaksi</li>
                    <li class="active">Tabungan</li>
                </ol>
            </section>
            <section class="content">
                <div class="box box-success">
                    
                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Pencarian</h3>
                    </div>
                    
                    <div class="box-body">
                        
                        <form id="formSearch" class="form-horizontal" method="post" action="?command=<%= Command.LIST %>">
                            <div class="form-group">
                                <div class="col-sm-12">
                                    <label>Nomor tabungan :</label>
                                    <select multiple="" class="form-control select2tabungan" name="FRM_SIMPANAN">
                                        <%
                                            Vector<Vector> listNomorTabungan = SessReportTabungan.getListSimpananSukarela("", "act.NO_TABUNGAN");
                                            for (Vector v : listNomorTabungan) {
                                                DataTabungan dt = (DataTabungan) v.get(0);
                                                AssignContactTabungan act = (AssignContactTabungan) v.get(1);
                                                JenisSimpanan js = (JenisSimpanan) v.get(2);
                                                Anggota a = (Anggota) v.get(3);

                                                String selected = "";
                                                if (selectedNoTab != null) {
                                                    for (String s : selectedNoTab) {
                                                        if (s.equals(""+dt.getOID())) {
                                                            selected = "selected";
                                                            break;
                                                        }
                                                    }
                                                }
                                                out.print("<option " + selected + " value='" + dt.getOID() + "'>" + act.getNoTabungan() + " [" + js.getNamaSimpanan() + "] - " + a.getName() + "</option>");
                                            }
                                        %>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-inline">
                                <div class="input-group">
                                    <span class="input-group-addon">Urutkan berdasarkan :</span>
                                    <select class="form-control input-sm" name="ORDER_BY">
                                        <option <%= (urut == 0) ? "selected":"" %> value="0">Nama Nasabah</option>
                                        <option <%= (urut == 1) ? "selected":"" %> value="1">Nomor Tabungan</option>
                                    </select>
                                </div>
                                <button type="button" id="btnSearch" class="btn btn-sm btn-primary"><i class="fa fa-search"></i>&nbsp; Cari</button>
                            </div>
                        </form>

                            <div><%= msg %></div>
                            
                        <% if (iCommand == Command.LIST) { %>
                        
                        <% if (listTabungan.isEmpty()) {%>
                        <div><i class="fa fa-exclamation-circle text-red"></i> Data tabungan tidak ditemukan</div>
                        <% } else { %>
                        
                        <form id="form_setoran" method="post" action="?command=<%= Command.SAVE %>">
                            <table class="table table-bordered table-hover">
                                <tr>
                                    <th style="width: 1%">No.</th>
                                    <th>Nama Nasabah</th>
                                    <th>Nomor Tabungan</th>
                                    <th>Jenis Item</th>
                                    <th style="text-align: right">Saldo terakhir</th>
                                    <th>Tanggal Transaksi</th>
                                    <th>Jumlah Setoran</th>
                                </tr>
                                <%
                                    int i = 0;
                                    for (Vector v : listTabungan) {
                                        i++;
                                        DataTabungan dt = (DataTabungan) v.get(0);
                                        AssignContactTabungan act = (AssignContactTabungan) v.get(1);
                                        JenisSimpanan js = (JenisSimpanan) v.get(2);
                                        Anggota a = (Anggota) v.get(3);
                                %>
                                <tr>
                                    <td><%= i %>.</td>
                                    <td>[<%= a.getNoAnggota() %>] &nbsp;&nbsp; <%= a.getName() %></td>
                                    <td><%= act.getNoTabungan() %></td>
                                    <td><%= js.getNamaSimpanan()%></td>
                                    <td class="text-right money"><%= js.getSetoranMin()%></td>
                                    <td>
                                        <input type="text" required="" class="form-control input-sm datetime-picker" name="FORM_TGL_TRANSAKSI" value="<%= Formater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") %>">
                                    </td>
                                    <td>
                                        <input type="text" required="" class="form-control input-sm money" data-cast-class="val_setoran" value="0">
                                        <input type="hidden" name="FORM_JUMLAH_SETORAN" value="" class="val_setoran">
                                        <input type="hidden" name="FORM_ID_SIMPANAN" value="<%= dt.getOID() %>">
                                        <input type="hidden" name="FORM_ID_ANGGOTA" value="<%= a.getOID() %>">
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                            <button type="button" id="btnSave" class="btn btn-sm btn-success pull-right" onclick="javascript:simpanSetoran()"><i class="fa fa-check"></i>&nbsp; Simpan</button>
                        </form>
                        
                        <% } %>
                        
                        <% } %>

                    </div>
                </div>
            </section>
        </div>
    </body>
</html>
