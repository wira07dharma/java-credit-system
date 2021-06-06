<%@page import="com.dimata.sedana.form.masterdata.FrmCashTellerBalance"%>
<%@page import="com.dimata.common.entity.currency.PstCurrencyType"%>
<%@page import="com.dimata.common.entity.currency.CurrencyType"%>
<%@page import="com.dimata.sedana.entity.kredit.AngsuranPayment"%>
<%@page import="com.dimata.common.entity.payment.PaymentSystem"%>
<%@page import="com.dimata.common.entity.payment.PstPaymentSystem"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTellerBalance"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTellerBalance"%>
<%@page import="com.dimata.aiso.entity.admin.AppUser"%>
<%@page import="com.dimata.aiso.form.admin.FrmAppUser"%>
<%@page import="com.dimata.sedana.entity.masterdata.TellerShift"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="java.lang.String"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlCashTeller"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterLoket"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterLoket"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstSedanaShift"%>
<%@page import="com.dimata.sedana.entity.masterdata.SedanaShift"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmCashTeller"%>
<%@page import="com.dimata.sedana.entity.reportsearch.ReportKolektabilitas"%>
<%@page import="com.dimata.sedana.entity.reportsearch.PstRscReport"%>
<%@page import="com.dimata.sedana.entity.reportsearch.RscReport"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.JenisTabungan"%>
<%@page import="com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisTabungan"%>
<%@page language="java" %>
<%@page import = "java.util.*" %>
<%@page import = "com.dimata.util.*" %>
<%@page import = "com.dimata.gui.jsp.*" %>
<%@page import = "com.dimata.qdep.form.*" %>
<%@page import="com.dimata.sedana.form.reportsearch.FrmRscReport"%>
<%@include file = "../main/javainit.jsp" %>
<%
    long oid = FRMQueryString.requestLong(request, "hidden_id");
    long currency = FRMQueryString.requestLong(request, "FRM_CURRENCY_ID");
    double openingValue = FRMQueryString.requestDouble(request, "FRM_OPENING_VALUE");
    int iErrCode = 0;
    int iCommand = FRMQueryString.requestCommand(request);
    CtrlCashTeller ctrlCashTeller = new CtrlCashTeller(request);
    iErrCode = ctrlCashTeller.action(iCommand, oid);
    CashTeller ct = ctrlCashTeller.getCashTeller();
    if (iCommand == Command.SAVE && iErrCode == 0) {
        Vector<PaymentSystem> listPayment = PstPaymentSystem.list(0, 0, PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_TYPE] + " = " + AngsuranPayment.TIPE_PAYMENT_CASH, null);

        CashTellerBalance tellerBalance = new CashTellerBalance();
        tellerBalance.setTellerShiftId(ct.getOID());
        tellerBalance.setCurrencyId(currency);
        tellerBalance.setType(FrmCashTellerBalance.STATUS_OPEN);
        tellerBalance.setBalanceDate(new Date());
        tellerBalance.setBalanceValue(openingValue);
        if (listPayment.size() > 0) {
            tellerBalance.setPaymentSystemId(listPayment.get(0).getOID());
        }
        PstCashTellerBalance.insertExc(tellerBalance);
    }
    Vector<CashTeller> open = PstCashTeller.list(0, 1, PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID] + " = " + userOID + " AND " + PstCashTeller.fieldNames[PstCashTeller.FLD_CLOSE_DATE] + " IS NULL ", "");
    String redirectUrl = FRMQueryString.requestString(request, "redir");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>SEDANA</title>
        <%@ include file = "/style/lte_head.jsp" %>
        <script>
            jQuery(function () {
                $('#submit').click(function () {

                });
            });
        </script>
        <script>
            <% if (open.size() > 0) {
                session.setAttribute("opening", true);%>
                var redir = '<%=((redirectUrl.equals("") || redirectUrl == null) ? "homexframe.jsp" : redirectUrl)%>&opening=1';
                var oldURL = window.top.location.href;
                var index = 0;
                var newURL = oldURL;
                index = oldURL.indexOf('?');
                if (index == -1) {
                    index = oldURL.indexOf('#');
                }
                if (index != -1) {
                    newURL = oldURL.substring(0, index);
                }
                newURL = newURL + "?redir=" + redir;
                window.top.location.href = newURL;
                <% } else { %>
                $(document).ready(function () {
                    $('body').show();
                });
            <% }%>
        </script>
    </head>
    <body style="background-color: #eaf3df; display: none;">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                Open Teller Shift
                <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="<%=approot%>/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
                <li>Pergantian Teller</li>
                <li class="active">Buka / Tutup Teller</li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="box box-success">
                <div class="box-header with-border">
                    <h3 class="box-title">Form Open Teller Shift</h3>
                </div>
                <div id="form-open-teller-shift">
                    <form class="form-horizontal form-validate-spv" data-action="" action="./../" id="<%=FrmCashTeller.FRM_NAME_CASHTELLER%>" method="post">
                        <input type="hidden" name="command" value="<%=Command.SAVE%>">
                        <input type="hidden" name="oid" value="<%=oid%>">
                        <input type="hidden" name="redir" value="<%=redirectUrl%>">
                        <input type="hidden" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_STATUS]%>" value="<%=TellerShift.STATUS_OPEN%>">
                        <div class="box-body">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Nama Teller</label>
                                    <div class="col-sm-8">
                                        <input class="hidden" type="hidden" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_APP_USER_ID]%>" value="<%=userOID%>">
                                        <% AppUser user = PstAppUser.fetch(userOID);%>
                                        <input class="form-control" disabled="" value="<%=user.getFullName()%>">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Lokasi</label>
                                    <div class="col-sm-8">
                                        <select required id="location" class="form-control">
                                            <option value="">- Pilih Lokasi -</option>
                                            <% Vector<Location> locations = PstLocation.list(0, 0, "", ""); %>
                                            <% for (Location l : locations) {%>
                                            <option value="<%=l.getOID()%>"><%=l.getName()%></option>
                                            <% }%>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Loket</label>
                                    <div class="col-sm-8">
                                        <script>var loketData = "<%--=jls.toString()--%>";</script>
                                        <select required id="loket" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_MASTER_LOKET_ID]%>" class="form-control">                                                        
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Shift</label>
                                    <div class="col-sm-8">
                                        <select required class="form-control" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_SHIFT_ID]%>">
                                            <option value="">- Pilih Shift -</option>
                                            <% Vector<SedanaShift> shifts = PstSedanaShift.list(0, 0, "", ""); %>
                                            <% for (SedanaShift s : shifts) {%>
                                            <option value="<%=s.getOID()%>"><%=s.getName()%></option>
                                            <% }%>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Saldo Awal</label>
                                    <div class="col-sm-4">
                                        <input required data-cast-class="val_opening" type="text" class="form-control money">
                                        <input type="hidden" class="val_opening" name="FRM_OPENING_VALUE">
                                    </div>
                                    <div class="col-sm-4">
                                        <select class="form-control" name="FRM_CURRENCY_ID">
                                            <%
                                                Vector<CurrencyType> listCurrency = PstCurrencyType.list(0, 0, null, null);
                                                for (CurrencyType c : listCurrency) {
                                            %>
                                            <option value="<%= c.getOID() %>"><%= c.getCode() %></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Supervisor</label>
                                    <div class="col-sm-8 user-form-group">
                                        <input type="hidden" class="spv-oid" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_SPV_OPEN_ID]%>" value="" />
                                        <input type="hidden" class="spv-name" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_SPV_OPEN_NAME]%>" value="" />
                                        <input type="hidden" class="spv-status include-check" name="<%=FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP]%>" value="<%=AppUser.USER_GROUP_HO_STAFF%>">
                                        <input type="text" required="" class="form-control spv-uname include-check" placeholder="Username" name="<%=FrmAppUser.fieldNames[FrmAppUser.FRM_LOGIN_ID]%>" style="margin-bottom:5px;" />
                                        <input type="password" required="" class="form-control spv-pass include-check" placeholder="Password" name="<%=FrmAppUser.fieldNames[FrmAppUser.FRM_PASSWORD]%>"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="box-footer">
                            <div class="col-sm-12">
                                <button type="submit" class="btn btn-success pull-right btn-submit">Lanjutkan</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </section>
        <%@ include file = "/footerkoperasi.jsp" %>
        <script>
            $(document).ready(function () {
                dataTableInvoker["validateSpv"]("#form-open-teller-shift");
            });
        </script>
        <script>
            $(document).ready(function () {
                dataTableInvoker["validateSpv"]("#form-open-teller-shift");

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
                $('#location').change(function () {
                    var id = $(this).val();
                    var dataSend = {
                        "FRM_FIELD_LOCATION_OID": id,
                    <%
                    if(useRaditya == 1){
                    %>
                        "FRM_FIELD_DATA_FOR": "getLoketRaditya",
                    <%}else{%>
                        "FRM_FIELD_DATA_FOR": "getLoket",
                    <%}%>
                        "FRM_FIELD_OID": "<%=userOID %>",
                        "command": "<%=Command.NONE%>"
                    };
                    onDone = function (data) {
                        if(data.RETURN_ERROR_CODE == 0){
                            $('#loket').html(data.FRM_FIELD_HTML);
                        }else{
                            alert("Loket pada lokasi tersebut tidak ditemukan!");
                            $('#loket').html(data.FRM_FIELD_HTML);
                        }
                    };
                    onSuccess = function (data) {

                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);
                });
            });
        </script>
    </body>
</html> 


<%--
            <!-- /.row -->
        </section>
        <%@ include file = "/footerkoperasi.jsp" %>
        <script>
            $(document).ready(function () {
                dataTableInvoker["validateSpv"]("#form-open-teller-shift"); 
                
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
                $('#location').change(function () {
                    var id = $(this).val();
                    var dataSend = {
                        "FRM_FIELD_OID": id,
                        "FRM_FIELD_DATA_FOR": "getLoket",
                        "command": "<%=Command.NONE%>"
                    };
                    onDone = function (data) {
                        $('#loket').html(data.FRM_FIELD_HTML);
                    };
                    onSuccess = function (data) {
                        
                    };
                    //alert(JSON.stringify(dataSend));
                    getDataFunction(onDone, onSuccess, dataSend, "AjaxKredit", null, false);                    
                });
            });
        </script>
    </body>
</html>
--%>