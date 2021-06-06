<%-- 
    Document   : penarikan.jsp
    Created on : Jul 8, 2017, 10:52:15 AM
    Author     : Regen
--%>

<%@page import="com.dimata.sedana.entity.tabungan.PstJenisTransaksiMapping"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisTransaksiMapping"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstMasterTabunganPenarikan"%>
<%@page import="com.dimata.sedana.entity.tabungan.MasterTabunganPenarikan"%>
<%@page import="com.dimata.sedana.entity.tabungan.AssignPenarikanTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstAssignPenarikanTabungan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan"%>
<%@page import="com.dimata.sedana.entity.kredit.AngsuranPayment"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.common.session.convert.ConvertAngkaToHuruf"%>
<%@page import="com.dimata.common.entity.payment.PstPaymentSystem"%>
<%@page import="com.dimata.common.entity.payment.PaymentSystem"%>
<%@page import="com.dimata.sedana.ajax.transaksi.extensible.HTTPTabungan"%>
<%@page import="com.dimata.common.session.convert.Master"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.ajax.transaksi.AjaxPenarikan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.PstAssignTabungan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.AssignTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.AssignContact"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstAssignContact"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.aiso.entity.admin.AppObjInfo"%>
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
<%
  int dataFor = (Integer) request.getAttribute("dataFor");
  String jenisTransaksi = (String) request.getAttribute("jenisTransaksi");
  Vector<JenisSimpanan> js = (Vector<JenisSimpanan>) request.getAttribute("js"); //sumber : com.dimata.sedana.ajax.transaksi (AjaxPenarikan.java)
  Tabungan tabungan = (Tabungan) request.getAttribute("tabungan");
  String username = (String) request.getAttribute("username");
  String periodePenarikan = "";
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
          Penarikan Tabungan
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
            <div class="box box-warning">
              <div class="box-header with-border">
                <h3 class="box-title">Form Pencarian</h3>
              </div>
              <!-- /.box-header -->
              <!-- form start -->
              <form id="form_saldo" action="Penarikan" class="form-horizontal" method="post">
                <input type="hidden" value="<%=dataFor%>" class="hidden" name="command">
                <div class="box-body">
                  <div class="form-group">
                    <div class="col-sm-3">
                      <div class="input-group">
                        <span class="input-group-addon">Tanggal</span>
                        <input type="hidden" <%=(dataFor == AjaxSetoran.SAVE_TABUNGAN) ? "readonly" : ""%> name="<%=AjaxSetoran.FRM_FIELD_TGL%>" value="<%=Master.date2String(tabungan.getTanggal(), "yyyy-MM-dd HH:mm:ss")%>" class="hidden">
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
                        $(window).load(function() {
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
                    .n.table-form thead tr, .n.table-form thead tr th { background-color: orange !important; color: white !important; padding: 10px; }
                    .table-hover tr:hover td{background-color: #f1f1f1 !important;}
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
                          <th style="text-align: right;">Nominal (Rp)</th>
                        </tr>
                      </thead>
                      <tfoot>
                        <tr style="background-color: #fef5ff;">
                          <td style="text-align: right;"></td>
                          <td style="text-align: right;">
                            <strong>Total &nbsp; : &nbsp;</strong>
                            <strong id="payment-total" style="text-align: right;margin-right: 7px;">0</strong>
                            <input type="hidden" id="real-payment-total" value="">
                          </td>
                        </tr>
                      </tfoot>
                      <tbody id="payment-body">
                        <tr>
                          <td>
                            <select required name="<%=HTTPTabungan.FRM_FIELD_PAYMENT_TYPE%>" class="form-control type-payment" id="type-payment0" data-row="0">
                              <% Vector<PaymentSystem> ps = PstPaymentSystem.list(0, 0, "", PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_SYSTEM]); %>
                              <% for (PaymentSystem p : ps) {%>
                              <% if (p.getPaymentType() != AngsuranPayment.TIPE_PAYMENT_CASH) {continue;} %>
                              <option value="<%=p.getOID()%>"><%=p.getPaymentSystem()%></option>
                              <% }%>
                            </select>
                            <!--payment saving-->
                            <input type="hidden" id="assignTabunganId0" name="">
                            <!--payment debit/credit card-->
                            <input type="hidden" id="cardNumber0" name="FRM_FIELD_CARD_NUMBER">
                            <input type="hidden" id="bankName0" name="FRM_FIELD_BANK_NAME">
                            <input type="hidden" id="validateDate0" name="FRM_FIELD_VALIDATE_DATE">
                            <!--payment tambahan credit card-->
                            <input type="hidden" id="cardName0" name="FRM_FIELD_CARD_NAME">
                          </td>
                          <td style="text-align: right;">
                            <input <%=(dataFor == AjaxSetoran.VIEW_TABUNGAN) ? "readonly" : ""%> type="text" style="text-align: right; font-size: 15px;" value="0" class="form-control money input-payment" required data-cast-class="val-money" />
                            <input name="<%=HTTPTabungan.FRM_FIELD_PAYMENT_NOMINAL%>" type="hidden" value="0" class="form-control hidden val-money" />
                          </td>
                        </tr>
                      </tbody>
                    </table>                    
                    <table class="table table-bordered table-condensed table-hover table-form n">
                      <thead>
                        <tr>
                          <th style="text-align: center; width: 1%">No</th>
                          <th>Jenis Item</th>
                          <th style="text-align: right">Sisa Saldo</th>
                          <th style="text-align: right">Denda</th>
                          <th>Jenis Transaksi</th>
                          <th style="text-align: right">Jumlah Penarikan (Rp)</th>
                        </tr>
                      </thead>
                      <tbody id="saldo-body">
                        <%
                          int i = 0;
                          int jumlahSimpananBebas = 0;
                          Date now = new Date();
                        %>
                        <% if (js.isEmpty()) { %>
                        <tr><td colspan="6" class="label-default text-center">Tidak ada item ditemukan</td></tr>
                        <% } %>
                        <% for (JenisSimpanan j : js) {%>
                        <%
                          double denda = 0D;
                          i++;
                          DataTabungan datab = PstDataTabungan.fetchWhere(PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA] + "=" + tabungan.getOID() + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + "=" + j.getOID());
                          AssignContactTabungan contab = PstAssignContactTabungan.fetchExc(datab.getAssignTabunganId());
                          MasterTabungan mastab = PstMasterTabungan.fetchExc(contab.getMasterTabunganId());
                          AssignPenarikanTabungan pentab = PstAssignPenarikanTabungan.fetchWhere(PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_MASTER_TABUNGAN_ID] + "=" + mastab.getOID());
                          MasterTabunganPenarikan masterPenarikan = new MasterTabunganPenarikan();
                          if (pentab.getIdTabunganRangePenarikan() != 0) {
                            masterPenarikan = PstMasterTabunganPenarikan.fetchExc(pentab.getIdTabunganRangePenarikan());
                          }
                          Vector<JenisTransaksiMapping> vMapping = PstJenisTransaksiMapping.list(0, 0, PstJenisTransaksiMapping.fieldNames[PstJenisTransaksiMapping.FLD_ID_JENIS_SIMPANAN]+"="+datab.getIdJenisSimpanan(), "");
                          String m = "";
                          for(JenisTransaksiMapping tm: vMapping) {
                              m+=(!m.equals("")?",":"");m+=tm.getJenisTransaksiId();
                          }
                          String whereJenisTransaksi = (m.length() > 0) ? " AND " + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI_ID] + " IN(" + m + ")" : "";
                          JenisTransaksi jt = PstJenisTransaksi.fetchWhere("PROSEDURE_UNTUK=0 AND TIPE_ARUS_KAS=0 AND `TYPE_TRANSAKSI`=1 AND `STATUS_AKTIF`=1 AND TIPE_DOC=8 " + whereJenisTransaksi);
                          if (masterPenarikan.getStartDate() != null && masterPenarikan.getEndDate() != null && (now.before(masterPenarikan.getStartDate()) || now.after(masterPenarikan.getEndDate()))) {
                            if (jt.getValueStandarTransaksi()>0) {
                              denda = jt.getValueStandarTransaksi();
                            } else if(jt.getProsentasePerhitungan()>0) {
                              double saldo = PstDetailTransaksi.getSimpananSaldo(datab.getOID());
                              denda = saldo * jt.getProsentasePerhitungan() / 100;
                            }
                          }
                        %>
                        <tr data-denda="<%=denda%>" data-id="<%=mastab.getOID()%>">
                          <td scope="row" class="text-center" style="background-color:#f9f9f9;"><span><%=i%></span></td>
                          <td style="background-color:#f9f9f9;">
                            <input type="text" class="hidden" name="<%=AjaxSetoran.FRM_FIELD_JENIS_TRANSAKSI_DENDA%>" value="<%=jt.getOID()%>" class="hidden" />
                            <input type="text" class="hidden" name="<%=AjaxSetoran.FRM_FIELD_SIMPANAN_ID%>" value="<%=j.getOID()%>" class="hidden" />
                            <input type="text" class="hidden" name="<%=AjaxSetoran.FRM_FIELD_MASTER_TABUNGAN_ID%>" value="<%=mastab.getOID()%>" class="hidden" />
                            <input type="text" class="hidden" name="<%=AjaxSetoran.FRM_FIELD_SIMPANAN_NAMA%>" value="<%=j.getNamaSimpanan()%>" class="hidden" />
                            <span class="namanya"><%=j.getNamaSimpanan()%></span>
                          </td> 
                          <% double saldo = PstDetailTransaksi.getSimpananSaldo(tabungan.getOID(), tabungan.getAssignContactTabunganId(), j.getOID());%>
                          <td style="background-color:#f9f9f9;">
                            <input type="text" class="hidden saldonya" name="<%=AjaxSetoran.FRM_FIELD_SALDO_AWAL%>" value="<%=String.format("%.2f",saldo)%>">
                            <span data-saldo="<%=saldo%>" class="money saldo-nampil"><%=saldo%></span>
                          </td>
                          <td style="background-color:#f9f9f9;">
                            <input type="hidden" class="hidden dendanya-hidden" name="<%=AjaxSetoran.FRM_FIELD_DENDA%>" value="0">
                            <input type="hidden" class="hidden dendanya-state" name="<%=AjaxSetoran.FRM_FIELD_DENDA_STATE %>" name="" value="false">
                            <span style="float:right;" class="dendanya">0</span>
                          </td>
                          <td>
                            <select name="<%=AjaxSetoran.FRM_FIELD_JENIS_TRANSAKSI%>" class="form-control">
                              <%=jenisTransaksi%>
                            </select>
                          </td>
                          <td style="position:relative;">
                            <input style="position:absolute;bottom:1px;text-align: right;font-size: 15px;" type="text" data-max="<%=PstDetailTransaksi.getSimpananSaldo(tabungan.getOID(), tabungan.getAssignContactTabunganId(), j.getOID())%>" value="0" class="form-control money input-saldo" data-fsetor="<%=j.getFrekuensiSimpanan()%>" data-ftarik="<%=j.getFrekuensiPenarikan()%>" data-cast-class="val-money">
                            <input name="<%=AjaxSetoran.FRM_FIELD_SALDO%>" type="hidden" value="" class="form-control hidden val-money">
                          </td>
                        </tr>
                        <%
                          if (j.getFrekuensiSimpanan() != JenisSimpanan.FREKUENSI_SIMPANAN_BEBAS) {

                          } else {
                            jumlahSimpananBebas += 1;
                          }
                        %>
                        <% }%>
                      </tbody>
                      <style>tfoot.footer-c tr td.t{background-color: #fef5ff!important;}</style>
                      <% if (!js.isEmpty()) { %>
                      <tfoot class="footer-c">
                        <tr>
                          <td class="t" colspan="5" style="text-align: right;"><strong>Total</strong></td>
                          <td class="t" style="text-align: right;">
                            <input type="hidden" id="totalSimpananBebas" value="<%=jumlahSimpananBebas%>">
                            <strong class="money" id="saldo-total" style="text-align: right;"></strong>
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
                    <script>
                      var hitungTotal = function() {
                        var nilai = 0;
                        $('body #saldo-body .val-money').each(function() {
                          nilai = +nilai + +$(this).val();
                        });
                        $("body #saldo-total").html(nilai);
                        jMoney("body #saldo-total");
                      };
                      var hitungTrTabungan = function() {
                        $(this).closest("tr").find(".dendanya-state").val("false");
                        var saldoTampil = $(this).closest("tr").find(".saldo-nampil");
                        var dendaTampil = $(this).closest("tr").find(".dendanya");
                        var saldo = $(this).closest("tr").find(".saldonya").val();
                        var input = $(this).siblings(".val-money").val();
                        var denda = (input != 0) ? $(this).closest("tr").data("denda") : 0;

                        (input == 0) || $(this).closest("tr").find(".dendanya-state").val("true");
                        var calcSaldo = parseFloat(saldo) - parseFloat(input) - parseFloat(denda);
                        $(saldoTampil).html(calcSaldo);
                        $(saldoTampil).attr("data-saldo", calcSaldo);
                        jMoney(saldoTampil);
                        $(dendaTampil).html(denda);
                        $(this).closest("tr").find(".dendanya-hidden").val(denda);
                        jMoney(dendaTampil);
                        hitungTotal();
                      };
                      $(window).load(function() {
                        $('body .input-saldo').each(function() {
                          $(this).keyup(hitungTrTabungan);
                        });
                      });
                    </script>
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
                          <th style="text-align:right;">Jumlah Penarikan (Rp)</th>
                        </tr>
                      </thead>
                      <tbody>
                        <% int i = 0;
                          for (Tabungan.List l : tabungan.getVSimpanan()) {
                            i++;%>
                        <tr>
                          <td scope="row" class="text-center"><span><%=i%></span></td>
                          <td><span><%=l.getNamaTabungan()%></span></td>
                          <td><span><%=l.getNamaSimpanan()%></span></td>
                          <% JenisTransaksi jt = PstJenisTransaksi.fetchExc(l.getIdJenisTransaksi());%>
                          <td><span><%=jt.getJenisTransaksi()%></span></td>
                          <td style="text-align:right;"><span class="money"><%=String.format("%d", (long) l.getInputSaldo())%></span></td>
                        </tr>
                        <% } %>
                      </tbody>
                    </table>
                  </div>
                  <% } %>
                </div>
                <!-- /.box-body -->
                <%--<div class="box-footer">
                  <% if(dataFor != AjaxPenarikan.VIEW_TABUNGAN) { %>
                  <button type="submit" class="btn btn-success pull-right"><%=(dataFor == AjaxSetoran.SAVE_TABUNGAN) ? "Simpan" : "Catat Penarikan"%></button>
                  <% } else { %>
                  <button type="button" class="btn-print btn btn-success pull-left">Cetak</button>
                  <% } %>
                </div>--%>
                <div class="box-footer">
                  <% if (dataFor == AjaxSetoran.SAVE_TABUNGAN) { %>
                  <% if (!js.isEmpty()) { %>
                  <button type="button" id="btn_simpan_tabungan" class="btn btn-success pull-right">Simpan</button>
                  <% } %>
                  <script>
                    $(window).load(function() {
                      $('#btn_simpan_tabungan').click(function() {
                        var min = false;
                        $("body .saldo-nampil").each(function() {
                          $(this).attr('data-saldo') >= 0 || (min = true);
                        });
                        min || $("body .input-saldo").siblings(".val-money").each(function() {
                          $(this).val() >= 0 || (min = true);
                        });
                        var nilaiPayment = 0;
                        var totalMinSetor = $('#minsetoran-total').val();
                        $("body").find('#payment-body').find('.val-money').each(function() {
                          nilaiPayment = +nilaiPayment + +$(this).val();
                        });
                        var nilaiSaldo = 0;
                        min || $("body").find('#saldo-body').find('.val-money').each(function() {
                          var nilai = $(this).val();
                          if (+nilai < 0) {
                            min = true;
                          }
                          nilaiSaldo = +nilaiSaldo + +$(this).val();
                        });
                        
                        if (false && nilaiPayment <= 0) {
                          alert("Payment 0 tidak didukung");
                        } else if (nilaiPayment < totalMinSetor) {
                          alert("Nilai uang kurang dari total minimal setoran !");
                        } else if (min) {
                          alert("Pastikan tidak ada nilai yang minus !");
                        } else if (nilaiPayment != nilaiSaldo) {
                          alert("Total nominal uang harus sama dengan total penarikan !\nTotal nominal : " + $("#payment-total").html() + "\nTotal penarikan : " + $("#saldo-total").html());
                        } else {
                          var exec = true;
                          $("#saldo-body tr").each(function() {
                            var awal = $(this).find(".saldonya").val();
                            var nominal = $(this).find(".input-saldo").siblings(".val-money").val();
                            (+nominal <= +awal) || (exec = false);
                          });
                          if (!exec)
                            alert("Pastikan nominal penarikan tidak melebihi saldo awal");
                          else
                            //$('#form_saldo').submit();
                            getConfirmation();
                        }
                      });
                    });
                  </script>
                  <% } else if (dataFor == AjaxSetoran.FORM_TABUNGAN) { %>
                  <button type="submit" id="submit" class="btn btn-success pull-right">Tambah Penarikan</button>
                  <% } else { %>
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
    <strong style="width: 100%; display: inline-block; padding-top: 0px;">JENIS TRANSAKSI&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PENARIKAN</strong>
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
            //i++; if((l.getInputSaldo()*-1) > 0) { //last
            i++;
            if (true) {
              saldo += l.getInputSaldo();
              double nilai = l.getInputSaldo();
              if (nilai < 0) {
                nilai *= -1;
              }
        %>
        <div>
          <span style="width: 150px;"><%=l.getNamaSimpanan()%></span>
          <div style="width: calc(100% - 150px); float: right; text-align: left;">:&nbsp;&nbsp; <span  class="money"><%=String.format("%d", (long) nilai)%></span></div>
        </div>
        <%
            }
          }
        %>
      </div>
      <div style="width: 50%;float: left;">
        <%
          if (saldo < 0) {
            saldo *= -1;
          }
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
        </div>
        <div>
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
    var getDataFunction = function(onDone, onSuccess, dataSend, servletName, dataAppendTo, notification) {
      $(this).getData({
        onDone: function(data) {
          onDone(data);
        },
        onSuccess: function(data) {
          onSuccess(data);
        },
        approot: "<%=approot%>",
        dataSend: dataSend,
        servletName: servletName,
        dataAppendTo: dataAppendTo,
        notification: notification
      });
    };

    var modalSetting = function(elementId, backdrop, keyboard, show) {
      $(elementId).modal({
        backdrop: backdrop,
        keyboard: keyboard,
        show: show
      });
    };

    function clearDetailPayment(row) {
      $('#assignTabunganId' + row).val("");
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
      onDone = function(data) {
        var payType = data.RETURN_PAYMENT_TYPE;

        if (payType === "<%=AngsuranPayment.TIPE_PAYMENT_SAVING%>") {

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
      onSuccess = function(data) {

      };
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
      onDone = function(data) {
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
      onSuccess = function(data) {

      };
      //alert(JSON.stringify(dataSend));
      getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
    }

    function hitungInput() {
      var total = $('#real-payment-total').val();
      var simpananBebas = $('#totalSimpananBebas').val();
      //var setoranNonBebas = $('#totalSetoranNonBebas').val();
      var setoranBebas = +total / +simpananBebas;
      $('.input-saldo').each(function() {
        var fsetor = $(this).data('fsetor');
        var ftarik = $(this).data('ftarik');
        if (fsetor === <%=JenisSimpanan.FREKUENSI_SIMPANAN_BEBAS%>) {
          $(this).val(setoranBebas);
          jMoney(this);
        }
      });
    }
    
    function getConfirmation() {
        var dataSend = $('#form_saldo').serialize();
        dataSend += "&FRM_FIELD_DATA_FOR=getKonfirmasiPenarikan";
        //alert(JSON.stringify(dataSend));
        onDone = function(data) {
            modalSetting("#modal-confirm", "static", false, false);
            $('#modal-confirm').modal('show');
            $('#appendBody').find(".money").each(function () {
                jMoney(this);
            });
            $('#btn_simpan_tabungan').removeAttr("disabled");
            $('#btnConfirm').click(function() {
                $('#btnConfirm').attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...");
                $('#btn_simpan_tabungan').attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i>&nbsp; Tunggu...");
                $('#modal-confirm').modal('hide');
                $('#form_saldo').submit();
            });
        };
        onSuccess = function(data) {};
        getDataFunction(onDone, onSuccess, dataSend, "AjaxTabungan", "#appendBody", false);
    }

    $(window).load(function() {

      $('.type-payment').change(function() {
        var id = $(this).val();
        var row = $(this).data('row');
        clearDetailPayment(row);
        checkPaymentType(id, row);
      });

      $('#form_detail').submit(function() {
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

      $('.input-payment').keyup(function() {
        hitungInput();
        hitungTotal();
        $('body .input-saldo').each(hitungTrTabungan);
      });
    });
  </script>
</body>
</html>
