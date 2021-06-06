<%-- 
    Document   : setoran
    Created on : Jul 4, 2017, 8:27:02 PM
    Author     : Regen
--%>
<%@page import="com.dimata.sedana.common.I_Sedana"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.entity.kredit.AngsuranPayment"%>
<%@page import="com.dimata.sedana.ajax.transaksi.extensible.HTTPTabungan"%>
<%@page import="com.dimata.common.entity.payment.PstPaymentSystem"%>
<%@page import="com.dimata.common.entity.payment.PaymentSystem"%>
<%@page import="com.dimata.common.session.convert.Master"%>
<%@page import="com.dimata.common.session.convert.ConvertAngkaToHuruf"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstAssignContact"%>
<%@page import="com.dimata.sedana.entity.masterdata.AssignContact"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.PstAssignTabungan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.AssignTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.sedana.session.Tabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksi"%>
<%@page import="com.dimata.common.form.contact.FrmContactList"%>
<%@page import="com.dimata.sedana.ajax.transaksi.AjaxSetoran"%>
<%@page import="java.util.Vector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "/main/checkuser.jsp" %>

<%!
    public Date getLastSetoran(long idAssignContact, long idJenisSimpanan) {
        long idPenambahanCash = PstJenisTransaksi.getIdJenisTransaksiByNamaJenisTransaksi("Penambahan Cash");
        
        String where = PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + idAssignContact;
        where += " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + " = " + idJenisSimpanan;
        
        Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 0, where, null);
        
        for (DataTabungan dt : listSimpanan) {
            String whereTrs = PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " IN "
                    + "("
                    + " SELECT " + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID]
                    + " FROM " + PstDetailTransaksi.TBL_DETAILTRANSAKSI
                    + " WHERE " + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN] + " = " + dt.getOID()
                    + " AND " + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_JENIS_TRANSAKSI_ID] + " = " + idPenambahanCash
                    + ")";
            Vector<Transaksi> listTransaksi = PstTransaksi.list(0, 1, whereTrs, PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC");
            for (Transaksi t : listTransaksi) {
                return t.getTanggalTransaksi();
            }
        }
        return null;
    }
%>

<%
    int dataFor = (Integer) request.getAttribute("dataFor");
    String jenisTransaksi = (String) request.getAttribute("jenisTransaksi");
    Vector<JenisSimpanan> js = (Vector<JenisSimpanan>) request.getAttribute("js"); //sumber : com.dimata.sedana.ajax.transaksi (AjaxSetoran.java)
    Tabungan tabungan = (Tabungan) request.getAttribute("tabungan");
    String username = (String) request.getAttribute("username");
    
    int available = 0;
    double totalSetoranMin = 0;
%>
<!DOCTYPE html>
<html>
    <head>
        <title>SEDANA</title>
        <%@ include file = "/style/lte_head.jsp" %>
    </head>
    <body style="background-color: rgb(234, 243, 223); height: auto;">
        <div class="main-page">
            <!-- Content Header (Page header) -->
            <section class="content-header">
                <h1>
                    Penambahan Tabungan
                    <small></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="/sedana_v1/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Transaksi</li>
                    <li class="active">Tabungan</li>
                </ol>
            </section>

            <!-- Main content -->
            <section class="content">
                <div class="row">
                    <div class="col-xs-12">
                        <!-- Horizontal Form -->
                        <div class="box box-success">
                            <div class="box-header with-border">
                                <h3 class="box-title">Form Pencarian</h3>
                            </div>
                            <!-- /.box-header -->
                            <!-- form start -->
                            <form id="form_saldo" action="Setoran" class="form-horizontal" method="post">
                                <input type="hidden" value="<%=dataFor%>" class="hidden" name="command">
                                <div class="box-body">
                                    <div class="form-group">
                                        <div class="col-sm-3">
                                            <div class="input-group">
                                                <span class="input-group-addon">Tanggal</span>
                                                <input type="hidden" <%=(dataFor == AjaxSetoran.SAVE_TABUNGAN || dataFor == AjaxSetoran.VIEW_TABUNGAN) ? "readonly" : ""%> name="<%=AjaxSetoran.FRM_FIELD_TGL%>" value="<%=Master.date2String(tabungan.getTanggal(), "yyyy-MM-dd HH:mm:ss")%>" class="hidden">
                                                <input type="text" value="<%=Master.date2String(tabungan.getTanggal(), "dd / MM / yyyy")%>" required="" class="form-control" disabled="" data-date-format="yyyy-mm-dd" placeholder="yyyy-mm-dd">
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="input-group">
                                                <span class="input-group-addon">No. Tabungan</span>
                                                <input type="hidden" <%=(dataFor == AjaxSetoran.SAVE_TABUNGAN || dataFor == AjaxSetoran.VIEW_TABUNGAN) ? "readonly" : ""%> value="<%=tabungan.getAssignContactTabunganId()%>" name="<%=AjaxSetoran.FRM_FIELD_ASSIGN_CONTACT_TABUNGAN_ID%>" required="" class="hidden" id="search-assignContactID">
                                                <input type="hidden" <%=(dataFor == AjaxSetoran.SAVE_TABUNGAN || dataFor == AjaxSetoran.VIEW_TABUNGAN) ? "readonly" : ""%> value="<%=tabungan.getOID()%>" name="<%=AjaxSetoran.FRM_FIELD_MEMBER_ID%>" required="" class="hidden" id="search-memberOID">
                                                <input type="text" <%=(dataFor == AjaxSetoran.SAVE_TABUNGAN || dataFor == AjaxSetoran.VIEW_TABUNGAN) ? "readonly" : ""%> name="<%=AjaxSetoran.FRM_FIELD_NO_TABUNGAN%>" value="<%=tabungan.getNoTabungan()%>" required="" data-onselect="setTabungan" data-action="<%=approot + "/Setoran"%>" id="search-noRekening" data-for="<%=AjaxSetoran.SEARCH_NO_TABUNGAN%>" class="form-control autocomplete">
                                            </div>
                                            <% if (dataFor == AjaxSetoran.FORM_TABUNGAN) {%>
                                            <script>
                                                $(window).load(function () {
                                                    $("#search-noRekening").focus();
                                                });
                                            </script>
                                            <% } %>
                                        </div>
                                        <div class="col-sm-5">
                                            <div class="input-group">
                                                <span class="input-group-addon">Nama</span>
                                                <input type="text" <%=(dataFor == AjaxSetoran.SAVE_TABUNGAN || dataFor == AjaxSetoran.VIEW_TABUNGAN) ? "readonly" : ""%> name="<%=AjaxSetoran.FRM_FIELD_NAMA%>" value="<%=tabungan.getNama()%>" data-onselect="setMemberName" data-action="<%=approot + "/Setoran"%>" data-for="<%=AjaxSetoran.SEARCH_MEMBER_NAME%>" required="" class="form-control autocomplete" id="search-personName">
                                            </div>
                                        </div>
                                        <div class="col-sm-12" style="margin-top: 10px;">
                                            <div class="input-group">
                                                <span class="input-group-addon">Alamat</span>
                                                <input readonly="" name="<%=AjaxSetoran.FRM_FIELD_ALAMAT%>" value="<%=tabungan.getAlamat()%>" class="form-control" id="search-homeAddr">
                                            </div>
                                        </div>
                                    </div>
                                    <style>
                                        .n, .n tr, .n th, .n td {border-color: rgb(210, 214, 222) !important;}
                                    </style>
                                    <% if (dataFor == AjaxSetoran.SAVE_TABUNGAN) {%>
                                    <div class="bs-example" data-example-id="panel-without-body-with-table" style="border-radius: 0;">
                                        <table class="table table-bordered table-condensed table-hover table-form n">

                                            <input type="hidden" value="0" id="paymentRow">

                                            <thead>
                                                <tr>
                                                    <th>
                                                        <i class="fa fa-plus-circle" id="btn-payment-add" style="cursor: pointer;"></i>&nbsp;
                                                        <i class="fa fa-minus-circle" id="btn-payment-remove" style="cursor: pointer;"></i>&nbsp;&nbsp;&nbsp;
                                                        Payment System
                                                    </th>
                                                    <th>Detail Payment</th>
                                                    <th style="text-align: right;">Nominal (Rp)</th>
                                                </tr>
                                            </thead>
                                            <tbody id="payment-body">
                                                <tr>
                                                    <td>
                                                        <select required name="<%=HTTPTabungan.FRM_FIELD_PAYMENT_TYPE%>" class="form-control type-payment" id="type-payment0" data-row="0">
                                                            <% Vector<PaymentSystem> ps = PstPaymentSystem.list(0, 0, "", PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_SYSTEM]); %>
                                                            <% for (PaymentSystem p : ps) {%>
                                                            <option value="<%=p.getOID()%>"><%=p.getPaymentSystem()%></option>
                                                            <% }%>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <input type="text" readonly="" style="width: 100%" id="detail_payment0">
                                                        <!--payment saving-->
                                                        <input type="hidden" id="simpananId0" value="0" name="<%= HTTPTabungan.FRM_FIELD_ID_SIMPANAN_PAYMENT %>">
                                                        <!--payment debit/credit card-->
                                                        <input type="hidden" id="cardNumber0" name="<%= HTTPTabungan.FRM_FIELD_CARD_NUMBER %>">
                                                        <input type="hidden" id="bankName0" name="<%= HTTPTabungan.FRM_FIELD_BANK_NAME %>">
                                                        <input type="hidden" id="validateDate0" name="<%= HTTPTabungan.FRM_FIELD_VALIDATE_DATE %>">
                                                        <!--payment tambahan credit card-->
                                                        <input type="hidden" id="cardName0" name="<%= HTTPTabungan.FRM_FIELD_CARD_NAME %>">
                                                    </td>
                                                    <td style="text-align: right;">
                                                        <input <%=(dataFor == AjaxSetoran.VIEW_TABUNGAN) ? "readonly" : ""%> type="text" style="text-align: right; font-size: 15px;" value="0" class="form-control money input-payment" required data-cast-class="val-money" />
                                                        <input name="<%=HTTPTabungan.FRM_FIELD_PAYMENT_NOMINAL%>" type="hidden" value="" class="form-control hidden val-money" />
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr style="background-color: #fef5ff;">
                                                    <td style="text-align: right;"></td>
                                                    <td></td>
                                                    <td style="text-align: right;">
                                                        <strong>Total &nbsp; : &nbsp;</strong>
                                                        <strong id="payment-total" style="text-align: right;margin-right: 7px;">0</strong>
                                                        <input type="hidden" id="real-payment-total" value="">
                                                    </td>
                                                </tr>
                                            </tfoot>
                                        </table>
                                        <table class="table table-bordered table-condensed table-hover table-form n">
                                            <thead>
                                                <tr>
                                                    <th style="text-align: center; width: 1%">No</th>
                                                    <th>Jenis Item</th>
                                                    <th style="text-align: right;">Saldo Saat Ini</th>
                                                    <th>Jenis Transaksi</th>
                                                    <th style="text-align: right;">Minimal Setoran (Rp)</th>
                                                    <th style="text-align: right;">Jumlah Setoran (Rp)</th>
                                                </tr>
                                            </thead>
                                            <tbody id="saldo-body">
                                                <% if (js.isEmpty()) { %>
                                                <tr><td colspan="6" class="label-default text-center">Tidak ada item ditemukan</td></tr>
                                                <% } %>
                                                
                                                <%
                                                    int i = 0;
                                                    double totalSaldo = 0;
                                                    double setoranMinNonBebas = 0;
                                                    int jumlahSimpananBebas = 0;
                                                    boolean aktif = false;
                                                    String keterangan = "";
                                                    
                                                    for (JenisSimpanan j : js) {
                                                        i++;
                                                        aktif = false;
                                                        //cek apakah item masih aktif
                                                        String where = PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = " + tabungan.getAssignContactTabunganId()
                                                                + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + " = " + j.getOID();
                                                        Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 0, where, null);
                                                        for (DataTabungan dt : listSimpanan) {
                                                            aktif = (dt.getStatus() == I_Sedana.STATUS_AKTIF) ? true : false;
                                                        }
                                                        
                                                        if (aktif) {
                                                            //cek jinis frekuensi simpanan/setoran
                                                            if (j.getFrekuensiSimpanan() == JenisSimpanan.FREKUENSI_SIMPANAN_SEKALI) {
                                                                //cek apakah sudah pernah ada setoran
                                                                Date last = getLastSetoran(tabungan.getAssignContactTabunganId(), j.getOID());
                                                                keterangan = "Setoran terakhir tanggal " + Formater.formatDate(last, "dd MMM yyyy");
                                                                if (last == null) {
                                                                    //belum ada setoran
                                                                    aktif = true;
                                                                    available++;
                                                                    totalSetoranMin += j.getSetoranMin();
                                                                } else {
                                                                    aktif = false;
                                                                }
                                                            }

                                                            if (j.getFrekuensiSimpanan() == JenisSimpanan.FREKUENSI_SIMPANAN_BERULANG) {
                                                                //cek apakah sudah ada setoran di bulan ini
                                                                Date last = getLastSetoran(tabungan.getAssignContactTabunganId(), j.getOID());
                                                                keterangan = "Setoran terakhir tanggal " + Formater.formatDate(last, "dd MMM yyyy");
                                                                if (last == null) {
                                                                    //belum ada setoran
                                                                    aktif = true;
                                                                    available++;
                                                                    totalSetoranMin += j.getSetoranMin();
                                                                } else {
                                                                    //cek apakah tanggal setoran ada di bulan ini
                                                                    Calendar cLast = Calendar.getInstance();
                                                                    cLast.setTime(last);

                                                                    Calendar cNow = Calendar.getInstance();
                                                                    cNow.setTime(new Date());

                                                                    int monthOfLast = cLast.get(Calendar.MONTH);
                                                                    int monthNow = cNow.get(Calendar.MONTH);
                                                                    int yearOfLast = cLast.get(Calendar.YEAR);
                                                                    int yearNow = cNow.get(Calendar.YEAR);

                                                                    if (monthOfLast != monthNow || yearOfLast != yearNow) {
                                                                        aktif = true;
                                                                        available++;
                                                                        totalSetoranMin += j.getSetoranMin();
                                                                    } else {
                                                                        aktif = false;
                                                                    }
                                                                }
                                                            }

                                                            if (j.getFrekuensiSimpanan() == JenisSimpanan.FREKUENSI_SIMPANAN_BEBAS) {
                                                                jumlahSimpananBebas += 1;
                                                                available++;
                                                                totalSetoranMin += j.getSetoranMin();
                                                            } else {
                                                                setoranMinNonBebas += j.getSetoranMin();
                                                            }

                                                        } else {
                                                            keterangan = "Tidak aktif";
                                                        }
                                                %>
                                                
                                                <% if (!aktif) { %>
                                                <tr>
                                                    <td scope="row" class="text-center"><span><%=i%></span></td>
                                                    <td><span><%=j.getNamaSimpanan()%></span></td>
                                                    <td><span class="money"><%= PstDetailTransaksi.getSimpananSaldo(tabungan.getOID(), tabungan.getAssignContactTabunganId(), j.getOID()) %></span></td>
                                                    <td colspan="3"><span><%= keterangan %></span></td>
                                                </tr>
                                                <% } else { %>
                                                <tr>
                                                    <td scope="row" class="text-center"><span><%=i%></span></td>
                                                    <td>
                                                        <input type="hidden" name="<%=AjaxSetoran.FRM_FIELD_SIMPANAN_ID%>" value="<%=j.getOID()%>" class="hidden" />
                                                        <input type="hidden" name="<%=AjaxSetoran.FRM_FIELD_SIMPANAN_NAMA%>" value="<%=j.getNamaSimpanan()%>" class="hidden" />
                                                        <span><%=j.getNamaSimpanan()%></span>
                                                    </td>
                                                    <td>
                                                        <% double r = PstDetailTransaksi.getSimpananSaldo(tabungan.getOID(), tabungan.getAssignContactTabunganId(), j.getOID());%>
                                                        <span class="money"><%=r%></span>
                                                        <input type="hidden" name="<%=AjaxSetoran.FRM_FIELD_SALDO_AWAL%>" value="<%=r%>">
                                                    </td>
                                                    <td>
                                                        <select <%=(dataFor == AjaxSetoran.VIEW_TABUNGAN) ? "readonly" : ""%> name="<%=AjaxSetoran.FRM_FIELD_JENIS_TRANSAKSI%>" class="form-control">
                                                            <%=jenisTransaksi%>
                                                        </select>
                                                    </td>
                                                    <td><span class="money"><%= j.getSetoranMin() %></span></td>
                                                    <td>
                                                        <input <%=(dataFor == AjaxSetoran.VIEW_TABUNGAN) ? "readonly" : ""%> type="text" style="text-align: right; font-size: 15px;" data-min="<%= j.getSetoranMin() %>" value="<%=String.format("%d", j.getSetoranMin())%>" class="form-control money input-saldo" data-fsetor="<%=j.getFrekuensiSimpanan()%>" data-ftarik="<%=j.getFrekuensiPenarikan()%>" data-cast-class="val-money" />
                                                        <input name="<%=AjaxSetoran.FRM_FIELD_SALDO%>" type="hidden" data-min="<%= j.getSetoranMin() %>" value="<%=j.getSetoranMin()%>" class="form-control hidden val-money valsaldo" />
                                                        <% totalSaldo += j.getSetoranMin(); %>
                                                    </td>
                                                </tr>
                                                <% } %>
                                                
                                                <%
                                                    }
                                                %>
                                            </tbody>
                                            
                                            <% if (!js.isEmpty()) {%>
                                            <tfoot>
                                                <tr style="background-color: #fef5ff;">
                                                    <td colspan="5" class="text-right">                                
                                                        <strong>Total Minimal Setoran &nbsp; : &nbsp;</strong>
                                                        <strong class="money"><%=totalSetoranMin%></strong>
                                                        <input type="hidden" id="minsetoran-total" value="<%=totalSetoranMin%>">
                                                    </td>
                                                    <td style="text-align: right;">
                                                        <input type="hidden" id="totalSimpananBebas" value="<%=jumlahSimpananBebas%>">
                                                        <input type="hidden" id="totalSetoranNonBebas" value="<%=setoranMinNonBebas%>">
                                                        <strong>Total &nbsp; : &nbsp;</strong>
                                                        <strong class="money" id="saldo-total" style="text-align: right;margin-right: 7px;"><%=totalSaldo%></strong>
                                                        <input type="hidden" id="real-saldo-total" value="<%=totalSaldo%>">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="" colspan="3" style="text-align: right; vertical-align: middle"><strong>Keterangan :</strong></td>
                                                    <td class="" colspan="3">
                                                        <input type="text" style="width: 100%" autocomplete="off" placeholder="..." name="<%= AjaxSetoran.FRM_FIELD_KETERANGAN%>">
                                                    </td>
                                                </tr>
                                            </tfoot>
                                            <% } %>

                                        </table>
                                    </div>
                                    <% } else if (dataFor == AjaxSetoran.VIEW_TABUNGAN) { %>
                                    <div class="bs-example" data-example-id="panel-without-body-with-table" style="border-radius: 0;">
                                        <table class="table table-bordered table-condensed table-hover table-form n">
                                            <thead>
                                                <tr>
                                                    <th style="text-align: center; width: 1%">#</th>
                                                    <th>Tabungan</th>
                                                    <th>Jenis Item</th>
                                                    <th>Jenis Transaksi</th>
                                                    <th style="text-align:right;">Jumlah Setoran (Rp)</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    int i = 0;
                                                    for (Tabungan.List l : tabungan.getVSimpanan()) {
                                                        i++;%>
                                                <tr>
                                                    <td scope="row" class="text-center"><span><%=i%></span></td>
                                                    <td><span><%=l.getNamaTabungan()%></span></td>
                                                    <td><span><%=l.getNamaSimpanan()%></span></td>
                                                    <% JenisTransaksi jt = PstJenisTransaksi.fetchExc(l.getIdJenisTransaksi());%>
                                                    <td><span><%=jt.getJenisTransaksi()%></span></td>
                                                    <td style="text-align:right;"><span class="money"><%=l.getInputSaldo()%></span></td>
                                                </tr>
                                                <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                    <% } %>
                                </div>
                                <!-- /.box-body -->
                                <div class="box-footer">
                                    <% if (dataFor == AjaxSetoran.SAVE_TABUNGAN) { %>
                                    <% if (available > 0) { %>
                                    <button type="button" id="btn_simpan_tabungan" class="btn btn-success pull-right">Simpan</button>
                                    <% } %>
                                    <% } else if (dataFor == AjaxSetoran.FORM_TABUNGAN) {%>
                                    <button type="submit" id="submit" class="btn btn-success pull-right">Tambah Setoran</button>
                                    <% } else {%>
                                    <button type="button" class="btn-print btn btn-success pull-left">Cetak</button>
                                    <% } %>
                                </div>
                                <!-- /.box-footer -->
                            </form>
                        </div>
                    </div>
                    <!--/.col (right) -->
                </div>
                <!-- /.row -->
            </section>

            <!----------------------->

            <div id="modal-detailPayment" class="modal fade" role="dialog">
                <div class="modal-dialog">                
                    <div class="modal-content">

                        <div class="modal-header">
                            <div class="col-sm-12">
                                <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                                <h4 class="modal-title">Detail Payment</h4>
                            </div>
                        </div>

                        <form id="form_detail" class="form-horizontal">

                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="col-md-12">

                                            <input type="hidden" id="detail_row">

                                            <div id="form_body_detail">

                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <div class="col-md-12">
                                    <button type="submit" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Selesai</button>
                                    <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                                </div>
                            </div>

                        </form>

                    </div>
                </div>
            </div>
            
            <div id="modal-searchtabungan" class="modal fade" role="dialog">
                <div class="modal-dialog">                
                    <div class="modal-content">

                        <div class="modal-header">
                            <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">Daftar Tabungan</h4>
                        </div>

                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-12">

                                    <div id="tabunganTableElement">
                                        <table class="table table-bordered table-striped">
                                            <thead>
                                            <style>
                                                #tabunganTableElement th {font-weight: normal}
                                            </style>
                                                <tr class="label-success">
                                                    <th class="aksi">No.</th>
                                                    <th>Nomor Tabungan</th>
                                                    <th>Jenis Simpanan</th>
                                                    <th>Saldo Tabungan</th>
                                                    <th class="aksi">Aksi</th>
                                                </tr>
                                            </thead>
                                            <tbody id="dataTabelTabungan"></tbody>
                                        </table>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                        </div>

                    </div>
                </div>
            </div>


            <div id="modal-confirm" class="modal fade" role="dialog">
                <div class="modal-dialog">
                    <div class="modal-content">

                        <div class="modal-header">
                            <button type="button" class="close modal-title" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">Konfirmasi</h4>
                        </div>

                        <div class="modal-body">
                            <div id="appendBody"></div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" id="btnConfirm" class="btn btn-sm btn-success"><i class="fa fa-check"></i> &nbsp; Lanjutkan</button>
                            <button type="button" class="btn btn-sm btn-default" data-dismiss="modal"><i class="fa fa-close"></i> &nbsp; Batal</button>
                        </div>

                    </div>
                </div>
            </div>

        </div>

    <print-area>
        <% if (dataFor == AjaxSetoran.VIEW_TABUNGAN) {%>
        <div style="width: 100%">
            <div style="width: 70%; float: left;">
                <strong style="width: 100%; display: inline-block;"><%=compName%></strong>
                <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
                <span style="width: 100%; display: inline-block;"><%=compPhone%></span>
                <span style="width: 100%; display: inline-block;">-</span>
            </div>
            <div style="width: 30%; float: right;">
                <%
                    PstTransaksi pstTransaksi = new PstTransaksi();
                    long id = (Long) request.getAttribute("oid");
                    Transaksi tt = pstTransaksi.fetchExc(id);
                    PstCashTeller pstCashTeller = new PstCashTeller();
                    CashTeller ct = pstCashTeller.fetchExc(tt.getTellerShiftId());
                    PstAppUser pstAppUser = new PstAppUser();
                    AppUser au = pstAppUser.fetch(ct.getAppUserId());
                %>
                <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">TRANSAKSI TABUNGAN</span>
                <span style="width: 100%; display: inline-block; font-size: 12px;"><%=Master.date2String(tt.getTanggalTransaksi(), "dd/MM/yyyy HH:mm:ss")%></span>
                <span style="width: 100%; display: inline-block; font-size: 12px;">User: <%=au.getFullName()%></span>
                <span style="width: 100%; display: inline-block; font-size: 12px;">No Transaksi: <%=tt.getKodeBuktiTransaksi()%></span>
            </div>
        </div>
        <div class="clearfix"></div>
        <hr class="" style="border-color: gray">
        <strong style="width: 100%; display: inline-block; padding-top: 0px;">JENIS TRANSAKSI&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SETORAN</strong>
        <div style="width: 100%; padding-top:10px;">
            <div style="width: 50%;float: left;">
                <div>
                    <span style="width: 100px; float: left;">No Tabungan</span>
                    <span style="width: calc(100% - 100px); float: right;">:&nbsp;&nbsp; <%=tabungan.getNoTabungan()%></span>
                </div>
                <div>
                    <span style="width: 100px; float: left;">Nama Nasabah</span>
                    <span style="width: calc(100% - 100px); float: right;">:&nbsp;&nbsp; <%=tabungan.getNama()%></span>
                </div>
            </div>
            <div style="width: 50%;float: left;"></div>
        </div>
        <div class="clearfix"></div>
        <div style="width:100%;padding-top: 20px;">
            <div style="width: 50%;float: left;">
                <% int i = 0;
                    double saldo = 0; %>
                <% for (Tabungan.List l : tabungan.getVSimpanan()) {
                        i++;
                        if (true) {
                            saldo += l.getInputSaldo();%>
                <div>
                    <span style="width: 150px;"><%=l.getNamaSimpanan()%></span>
                    <div style="width: calc(100% - 150px); float: right; text-align: left;">:&nbsp;&nbsp; <span  class="money"><%=String.format("%d", (long) l.getInputSaldo())%></span></div>
                </div>
                <% }
                    } %>
            </div>
            <div style="width: 50%;float: left;">
                <%
                    long longTotal = (long) (saldo);
                    String output = "";
                    if (longTotal == 0) {
                        output = "Nol rupiah.";
                    } else if (longTotal < 0) {
                        longTotal *= -1;
                        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                        String con = "Minus " + convert.getText() + " rupiah.";
                        output = con.substring(0, 1).toUpperCase() + con.substring(1);
                    } else {
                        ConvertAngkaToHuruf convert = new ConvertAngkaToHuruf(longTotal);
                        String con = convert.getText() + " rupiah.";
                        output = con.substring(0, 1).toUpperCase() + con.substring(1);
                    }
                %>
                <div>
                    <span style="width: 150px;">Total</span>
                    <div style="width: calc(100% - 150px); float: right; text-align: left;">:&nbsp;&nbsp<span  class="money"><%=String.format("%d", (long) saldo)%></span></div>
                </div><div>
                    <span style="width: 150px;">Terbilang</span>
                    <div style="width: calc(100% - 150px); float: right; text-align: left;">:&nbsp;&nbsp<%=output%></div>
                </div>
                <div>
                    <span style="width: 150px;">Keterangan</span>
                    <div style="width: calc(100% - 150px); float: right; text-align: left;">:&nbsp;&nbsp</div>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>
        <div style="width: 100%;padding-top: 40px;">
            <div style="width: 50%;float: left;text-align: center;">
                <span>Petugas</span>
                <br><br><br><br>
                <span>(&nbsp; . . . . . . . . . . . . . &nbsp;)</span>
            </div>
            <div style="width: 50%;float: right;text-align: center;">
                <span>Nasabah</span>
                <br><br><br><br>
                <span>(&nbsp; . . . . . . . . . . . . . &nbsp;)</span>
            </div>
        </div>
        <div class="clearfix"></div>
        <div style="width: 100%;padding-top: 30px;">User Cetak : <%=au.getFullName()%></div>
        <% }%>
    </print-area>

    <script>
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

        var modalSetting = function (elementId, backdrop, keyboard, show) {
            $(elementId).modal({
                backdrop: backdrop,
                keyboard: keyboard,
                show: show
            });
        };

        function clearDetailPayment(row) {
            $('#detail_payment' + row).val("");
            $('#simpananId' + row).val("");
            $('#cardNumber' + row).val("");
            $('#bankName' + row).val("");
            $('#validateDate' + row).val("");
            $('#cardName' + row).val("");
        }

        function checkPaymentType(id, row) {
            var dataSend = {
                "FRM_FIELD_OID": id,
                "FRM_FIELD_DATA_FOR": "cekPaymentType",
                "command": "<%=Command.NONE%>"
            };
            onDone = function (data) {
                var payType = data.RETURN_PAYMENT_TYPE;

                if (payType === "<%=AngsuranPayment.TIPE_PAYMENT_SAVING%>") {
                    modalSetting("#modal-searchtabungan", "static", false, false);
                    $('#modal-searchtabungan').modal('show');
                    getListTabungan(row);
                } else if (payType === "<%=AngsuranPayment.TIPE_PAYMENT_CREDIT_CARD%>") {
                    $('#detail_row').val(row);
                    modalSetting("#modal-detailPayment", "static", false, false);
                    $('#modal-detailPayment').modal('show');
                    getListCard(payType);
                } else if (payType === "<%=AngsuranPayment.TIPE_PAYMENT_DEBIT_CARD%>") {
                    $('#detail_row').val(row);
                    modalSetting("#modal-detailPayment", "static", false, false);
                    $('#modal-detailPayment').modal('show');
                    getListCard(payType);
                }
            };
            onSuccess = function (data) {

            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
        }

        function getListTabungan(row) {
            var idNasabah = $('#search-memberOID').val();
            var dataSend = {
                "FRM_FIELD_OID": idNasabah,
                "FRM_FIELD_DATA_FOR": "getListTabungan",
                "command": "<%=Command.NONE%>"
            };
            onDone = function (data) {
                $('#dataTabelTabungan').html(data.FRM_FIELD_HTML);
                $('#dataTabelTabungan').find('.money').each(function () {
                    jMoney(this);
                });
                $('.btn-pilihtabungan').click(function () {
                    $('.btn-pilihtabungan').attr({"disabled": "true"});
                    var oid = $(this).data('idsimpanan');
                    var noTabungan = $(this).data('notab');
                    var saldoTabungan = parseFloat($(this).data('saldo'));
                    if (saldoTabungan <= 0) {
                        alert("Saldo tidak cukup !");
                        return false;
                    }
                    $('#detail_payment' + row).val("Nomor Tabungan : " + noTabungan + " " + " | " + " " + "Sisa Saldo : " + saldoTabungan);
                    $('#simpananId' + row).val(oid);
                    $('#modal-searchtabungan').modal('hide');
                });
            };
            onSuccess = function (data) {};
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
        }
        
        function getListCard(payType) {
            var loadBar = "<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Tunggu...</b></div></div>";
            $('#form_body_detail').html(loadBar);
            var dataSend = {
                "SEND_CARA_BAYAR": payType,
                "FRM_FIELD_DATA_FOR": "getListCard2",
                "command": "<%=Command.NONE%>"
            };
            onDone = function (data) {
                $('#form_body_detail').html(data.FRM_FIELD_HTML);
                $('.input_tgl').datetimepicker({
                    weekStart: 1,
                    format: "yyyy-mm-dd",
                    todayBtn: 1,
                    autoclose: 1,
                    todayHighlight: 1,
                    startView: 2,
                    forceParse: 0,
                    minView: 2
                });
            };
            onSuccess = function (data) {

            };
            //alert(JSON.stringify(dataSend));
            getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
        }

        function getConfirmation() {
            var dataSend = $('#form_saldo').serialize();
            dataSend += "&FRM_FIELD_DATA_FOR=getKonfirmasiSetoran";
            //alert(JSON.stringify(dataSend));
            onDone = function (data) {
                modalSetting("#modal-confirm", "static", false, false);
                $('#modal-confirm').modal('show');
                $('#appendBody').find(".money").each(function () {
                    jMoney(this);
                });
                $('#btn_simpan_tabungan').removeAttr("disabled");
                $('#btnConfirm').click(function () {
                    $('#btnConfirm').attr({"disabled": true}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...");
                    $('#btn_simpan_tabungan').attr({"disabled": true}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...");
                    $('#modal-confirm').modal('hide');
                    $('#form_saldo').submit();
                });
            };
            onSuccess = function (data) {
            };
            getDataFunction(onDone, onSuccess, dataSend, "AjaxTabungan", "#appendBody", false);
        }

        function autoInputSetoran() {
            var totalItemSimpanan = parseFloat(<%= available %>);
            var totalMinimalSetoran = parseFloat(<%= totalSetoranMin %>);
            var totalUang = $('#real-payment-total').val();
            if (totalItemSimpanan === 1) {
                /*
                if (totalUang >= totalMinimalSetoran) {
                    $('.input-saldo').val(totalUang);
                } else {
                    $('.input-saldo').val(totalMinimalSetoran);
                }
                */
                var minSetor = $('.input-saldo').data('min');
                if(totalUang < minSetor) {
                    $('.input-saldo').val(totalUang).css({color: "red"});
                } else {
                    $('.input-saldo').val(totalUang).css({color: "black"});
                }
                jMoney($('.input-saldo'));
            } else {
                var sisaUang = totalUang - totalMinimalSetoran;
                $('.input-saldo').each(function () {
                    var minSetor = +$('.input-saldo').data('min');
                    var totalSetor = (minSetor + sisaUang) > 0 ? minSetor + sisaUang : minSetor;
                    $(this).val(totalSetor);
                    jMoney(this);
                    return false;
                });
            }
        }
        
        function countTotalSetoran() {
            var saldo = 0;
            $(".input-saldo").each(function () {
                saldo += parseFloat($(this).siblings(".val-money").val());
            });
            $("#real-saldo-total").val(saldo);
            $("#saldo-total").text(saldo);
            jMoney($("#saldo-total"));
        }
        
        function compareTotalSetoran() {
            var totalUang = $('#real-payment-total').val();
            var totalSetoran = $('#real-saldo-total').val();
            if (totalUang !== totalSetoran) {
                $("#payment-total").css({color: "red"});
                $("#saldo-total").css({color: "red"});
            } else {
                $("#payment-total").css({color: "black"});
                $("#saldo-total").css({color: "black"});
            }
        }

        $(document).ready(function () {

            $('body').on("change", ".type-payment", function () {
                var id = $(this).val();
                var row = $(this).data('row');
                clearDetailPayment(row);
                checkPaymentType(id, row);
            });

            $('#form_detail').submit(function () {
                var cardName = $('#namaKartu').val();
                var cardNumber = $('#nomorKartu').val();
                var bankName = $('#namaBank').val();
                var validate = $('#tglValidate').val();
                var row = $('#detail_row').val();
                $('#cardName' + row).val(cardName);
                $('#cardNumber' + row).val(cardNumber);
                $('#bankName' + row).val(bankName);
                $('#validateDate' + row).val(validate);
                $('#modal-detailPayment').modal('hide');
                return false;
            });

            $('body').on("keyup", ".input-payment", function () {
                autoInputSetoran();
                countTotalSetoran();
                compareTotalSetoran();
            });
            
            $(".input-saldo").keyup(function () {
                countTotalSetoran();
                compareTotalSetoran();
            });

            $('#btn_simpan_tabungan').click(function () {
                var nilaiPayment = 0;
                var totalMinSetor = $('#minsetoran-total').val();
                $("body").find('#payment-body').find('.val-money').each(function () {
                    nilaiPayment = +nilaiPayment + +$(this).val();
                });
                var nilaiSaldo = 0;
                $("body").find('#saldo-body').find('.val-money').each(function () {
                    var nilai = $(this).val();
                    if (+nilai < 0) {
                        alert("Pastikan tidak ada nilai yang minus !");
                    }
                    nilaiSaldo = +nilaiSaldo + +$(this).val();
                });
                
                if (nilaiPayment < totalMinSetor) {
                    alert("Total nominal uang harus sama dengan total minimal setoran !\nTotal nominal : " + nilaiPayment + "\nTotal minimal setoran : " + totalMinSetor);
                } else if (+nilaiPayment != +nilaiSaldo) {
                    alert("Total nominal uang harus sama dengan total setoran !\nTotal nominal : " + $("#payment-total").html() + "\nTotal setoran : " + $("#saldo-total").html());
                } else {
                    if (window.location.href.indexOf("command") > -1) {
                        //$('#form_saldo').attr('action', baseUrl("") + "/Setoran");
                    }
                    //$('#form_saldo').submit();
                    getConfirmation();
                    $('#btn_simpan_tabungan').attr({"disabled": true});
                }
            });

            function theCallbackFunction() {
                // This is where the code to execute lives
                $('#type-payment0').trigger('click');
            }

            $('#type-payment0').on("click", theCallbackFunction);
            
        });
    </script>
</body> 
</html>
