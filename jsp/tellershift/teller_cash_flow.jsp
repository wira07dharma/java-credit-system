<%-- 
    Document   : teller_cash_flow
    Created on : Jan 18, 2019, 9:15:28 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.kredit.AngsuranPayment"%>
<%@page import="com.dimata.common.entity.currency.CurrencyType"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmCashTellerBalance"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlCashTellerBalance"%>
<%@page import="com.dimata.common.entity.currency.PstCurrencyType"%>
<%@page import="com.dimata.common.entity.payment.PstPaymentSystem"%>
<%@page import="com.dimata.common.entity.payment.PaymentSystem"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTellerBalance"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTellerBalance"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlCashTeller"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="/main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "/main/checkuser.jsp" %>

<%//
    int iCommand   = FRMQueryString.requestCommand(request);
    long oidCahsTeller = FRMQueryString.requestLong(request, "teller_shift_id");
    int cashFlow = FRMQueryString.requestInt(request, "cash_flow");
    
    //teller shift
    CtrlCashTeller ctrlCashTeller = new CtrlCashTeller(request);
    int iErrCode = ctrlCashTeller.action(Command.EDIT, oidCahsTeller);
    String msg = ctrlCashTeller.getMessage();
    CashTeller cashTeller = ctrlCashTeller.getCashTeller();
    
    if (iCommand == Command.SAVE) {
        CtrlCashTellerBalance ctrlCashTellerBalance = new CtrlCashTellerBalance(request);
        iErrCode = ctrlCashTellerBalance.action(iCommand, 0);
        msg = ctrlCashTellerBalance.getMessage();
    }
    
    //user
    AppUser user = PstAppUser.fetch(cashTeller.getAppUserId());
    
    //teller balance
    String balanceType[] = {"Buka Teller","Tutup Teller","Penambahan Modal","Pengembalian Modal"};
    Vector<CashTellerBalance> listBalance = PstCashTellerBalance.list(0, 0, PstCashTellerBalance.fieldNames[PstCashTellerBalance.FLD_TELLER_SHIFT_ID] + " = " + oidCahsTeller, PstCashTellerBalance.fieldNames[PstCashTellerBalance.FLD_BALANCE_DATE]);
    
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>SEDANA</title>
        <%@ include file = "/style/lte_head.jsp" %>
        <style>
            table {font-size: 14px}
        </style>
        <script>
            jQuery(function () {
                
                $('.btn_aksi').click(function() {
                    $(this).attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu");
                    var oid = $(this).data('oid');
                    var type = $(this).data('type');
                    window.location = "teller_cash_flow.jsp?command=<%= Command.ADD %>&teller_shift_id="+oid+"&cash_flow="+type;
                });
                
                $('#btnSave').click(function() {
                    $(this).attr({"disabled":true}).html("<i class='fa fa-spinner fa-pulse'></i> Tunggu");
                    $('#formBalance').submit();
                });
                
            });
        </script>
    </head>
    <body style="background-color: #eaf3df;">
        <div class="main-page">
            <section class="content-header">
                <h1>Tambah / Kembalikan Modal<small></small></h1>
                <ol class="breadcrumb">
                    <li><a href=""><i class="fa fa-dashboard"></i> Home</a></li>
                    <li>Pergantian Teller</li>
                    <li class="active">Buka / Tutup Teller</li>
                </ol>
            </section>
            
            <section class="content">
                <div class="box box-success">
                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">
                            <span>Teller</span>&nbsp; : &nbsp;<span><%= PstAppUser.getOperatorName(cashTeller.getAppUserId()) %></span>
                        </h3>
                    </div>
                    <div class="box-body">
                        <label>Cash Flow :</label>
                        <table class="table table-bordered">
                            <tr class="label-success">
                                <th style="width: 1%">No.</th>
                                <th>Aktifitas</th>
                                <th>Nominal</th>
                                <th>Jenis</th>
                                <th>Tanggal</th>
                            </tr>

                            <% if (listBalance.isEmpty()) { %>
                            <tr><td colspan="5" class="label-default text-center">Tidak ada data</td></tr>
                            <% } %>

                            <%
                                int i=0;
                                for (CashTellerBalance balance : listBalance) {
                                    i++;
                                    String paymentType = "?";
                                    String currency = "?";
                                    try {
                                        if (PstCurrencyType.checkOID(balance.getCurrencyId())) {
                                            currency = PstCurrencyType.fetchExc(balance.getCurrencyId()).getCode();
                                        }
                                        if (PstPaymentSystem.checkOID(balance.getPaymentSystemId())) {
                                            paymentType = PstPaymentSystem.fetchExc(balance.getPaymentSystemId()).getPaymentSystem();
                                        }
                                    } catch (Exception e) {

                                    }
                            %>
                            <tr>
                                <td><%= i %>.</td>
                                <td><%= balanceType[balance.getType()] %></td>
                                <td><%= currency %> <span class="money"><%= balance.getBalanceValue() %></span></td>
                                <td><%= paymentType %></td>
                                <td><%= (balance.getBalanceDate() == null) ? "-" : Formater.formatDate(balance.getBalanceDate(), "yyyy-MM-dd HH:mm:ss") %></td>
                            </tr>
                            <% } %>
                        </table>
                        
                        <% if(!msg.isEmpty()) { %>
                        <br>
                        <div style="background-color: yellow" class="text-center"><%= msg %></div>
                        <% } %>
                    </div>
                    <div class="box-footer">
                        <button type="button" class="btn btn-sm btn-primary btn_aksi" data-oid="<%= oidCahsTeller %>" data-type="3"><i class="fa fa-upload"></i>&nbsp; Kembalikan Modal</button>
                        <button type="button" class="btn btn-sm btn-primary btn_aksi" data-oid="<%= oidCahsTeller %>" data-type="2"><i class="fa fa-download"></i>&nbsp; Tambah Modal</button>
                        <a href="<%=approot%>/tellershift/teller_shift_mgmt.jsp" class="btn btn-sm btn-default"><i class="fa fa-undo"></i>&nbsp; Kembali Ke Daftar Teller</a>
                    </div>
                </div>

                    <% if (iCommand == Command.ADD) { %>
                    
                <div class="box box-success">
                    <div class="box-header with-border" style="border-color: lightgray">
                        <h3 class="box-title">Form Input <%= balanceType[cashFlow] %></h3>
                    </div>
                    <div class="box-body">
                        <form id="formBalance" method="post" class="form-inline" action="?command=<%= Command.SAVE %>">
                            <input type="hidden" name="teller_shift_id" value="<%= oidCahsTeller %>">
                            <input type="hidden" name="<%= FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_BALANCEDATE] %>" value="<%= Formater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") %>">
                            <input type="hidden" name="<%= FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_TELLERSHIFTID] %>" value="<%= cashTeller.getOID() %>">
                            <input type="hidden" name="<%= FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_TYPE] %>" value="<%= cashFlow %>">
                            
                            <select class="form-control" name="<%= FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_PAYMENT_SYSTEM_ID] %>">
                                <%
                                    Vector<PaymentSystem> listPaymentSystem = PstPaymentSystem.list(0, 0, null, null);
                                    for (PaymentSystem ps : listPaymentSystem) {
                                %>
                                <option <%= (ps.getPaymentType() == AngsuranPayment.TIPE_PAYMENT_CASH ) %> value="<%= ps.getOID() %>"><%= ps.getPaymentSystem() %></option>
                                <%
                                    }
                                %>
                            </select>
                                
                            <select class="form-control" name="<%= FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_CURRENCYID] %>">
                                <%
                                    Vector<CurrencyType> listCurrency = PstCurrencyType.list(0, 0, null, null);
                                    for (CurrencyType c : listCurrency) {
                                %>
                                <option value="<%= c.getOID() %>"><%= c.getCode() %></option>
                                <%
                                    }
                                %>
                            </select>
                            <input type="text" class="form-control money" placeholder="Nominal uang" data-cast-class="val_nominal" value="">
                            <input type="hidden" class="form-control val_nominal" placeholder="Nominal uang" name="<%= FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_BALANCEVALUE] %>" value="">
                            &nbsp;
                            <button type="button" id="btnSave" class="btn btn-success" data-oid="<%= oidCahsTeller %>"><i class="fa fa-check"></i> Simpan</button>
                        </form>
                    </div>
                </div>
                            
                    <% } %>

            </section>
        </div>
    </body>
</html>
