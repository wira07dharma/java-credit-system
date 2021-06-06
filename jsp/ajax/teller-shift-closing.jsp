<%@page import="com.dimata.common.entity.currency.PstCurrencyType"%>
<%@page import="com.dimata.common.entity.currency.CurrencyType"%>
<%@page import="com.dimata.common.form.admin.FrmAppUser"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.common.entity.payment.PstPaymentSystem"%>
<%@page import="com.dimata.common.entity.payment.PaymentSystem"%>
<%@page import="com.dimata.aiso.entity.admin.AppUser"%>
<%@page import="com.dimata.aiso.entity.admin.PstAppUser"%>
<%@page import="com.dimata.sedana.entity.masterdata.TellerShift"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.SedanaShift"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstSedanaShift"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterLoket"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterLoket"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmCashTellerBalance"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmCashTeller"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%
  long tellerShiftId  = FRMQueryString.requestLong(request, "id");
  long user           = FRMQueryString.requestLong(request, "user");
  TellerShift t       = PstCashTeller.getTellerShiftById(tellerShiftId);
  long userOID        = (user == 0) ? t.getAppUserId() : user;
  CashTeller open     = PstCashTeller.fetchExc(t.getOID());
%>
<div id="modal-<%=t.getOID()%>" class="modal fade in" role="dialog" style="display: block;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <div type="button" class="fa fa-close pull-right close-dialog" style="margin-top: 3px; cursor: pointer;" data-dismiss="modal" aria-label="Close"></div>
        <h4 class="modal-title"><b>CLOSING BALANCE</b></h4> </div>
      <div class="modal-body" id="CONTENT_CLOSING" style="display: none;"> </div>
      <div <%=(user == 0) ? "id='form-close-teller-shift'" : "" %> >
        <form method="post" data-action="" action="./.." id="form-closing" style="">
          <% CashTeller ct = open;%>
          <input type="hidden" class="hidden" value="<%=Command.SAVE%>" name="command">
          <input type="hidden" class="hidden" value="<%=ct.getOID()%>" name="oid">
          <input type="hidden" class="hidden" value="<%=ct.getOID()%>" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_TELLER_SHIFT_ID]%>">
          <input type="hidden" class="hidden" value="<%=5 /*ct.getStatus()*/%>" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_STATUS]%>">
          <input type="hidden" class="hidden" value="<%=ct.getAppUserId()%>" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_APP_USER_ID]%>">
          <input type="hidden" class="hidden" value="<%=ct.getShiftId()%>" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_SHIFT_ID]%>">
          <input type="hidden" class="hidden" value="<%=ct.getMasterLoketId()%>" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_MASTER_LOKET_ID]%>">
          <input type="hidden" class="hidden" value="<%=ct.getSpvOpenId()%>" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_SPV_OPEN_ID]%>">
          <input type="hidden" class="hidden" value="<%=ct.getSpvOpenName()%>" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_SPV_OPEN_NAME]%>">
          <input type="hidden" class="hidden" value="<%=ct.getSpvOpenId()%>" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_SPV_CLOSE_ID]%>">
          <input type="hidden" class="hidden" value="<%=ct.getSpvOpenName()%>" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_SPV_CLOSE_NAME]%>">
          <input type="hidden" class="hidden" value="<%=Formater.formatDate(ct.getOpenDate(), "yyyy-MM-dd HH:mm:ss")%>" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_OPEN_DATE]%>">
          <input type="hidden" class="hidden closing-time" data-value="<%=Formater.formatDate(ct.getOpenDate(), "yyyy-MM-dd")%>" value="" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_CLOSE_DATE]%>">
          <% AppUser u = PstAppUser.fetch(userOID); %>
          <input type="hidden" class="spv-oid" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_SPV_CLOSE_ID]%>" value="<%=u.getOID()%>">
          <input type="hidden" class="spv-name" name="<%=FrmCashTeller.fieldNames[FrmCashTeller.FRM_FIELD_SPV_CLOSE_NAME]%>" value="<%=u.getFullName()%>">

          <input type="hidden" value="<%=ct.getOID()%>" name="<%=FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_TELLERSHIFTID]%>">
          <input type="hidden" value="" name="<%=FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_SHOULDVALUE]%>">
          <input type="hidden" value="<%=FrmCashTellerBalance.STATUS_CLOSE%>" name="<%=FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_TYPE]%>">
          <div class="modal-body">
            <div class="row">
              <div class="box-body">
                <%
                  AppUser au = PstAppUser.fetch(ct.getAppUserId());
                  MasterLoket ml = PstMasterLoket.fetchExc(ct.getMasterLoketId());
                  Location l = PstLocation.fetchExc(ml.getLocationId());
                  SedanaShift s = PstSedanaShift.fetchExc(ct.getShiftId());
                %>
                <div class="col-md-2"> <strong>Cashier</strong> </div>
                <div class="col-md-3"> : <%=au.getFullName() %> </div>
                <div class="col-md-2"> <b>Location</b> </div>
                <div class="col-md-5"> : <%=l.getName()%> </div>
              </div>
            </div>
            <div class="row">
              <div class="box-body">
                <div class="col-md-2"> <b>Date</b> </div>
                <div class="col-md-3"> : <%=Formater.formatDate(ct.getOpenDate(), "yyyy-MM-dd")%> </div>
                <div class="col-md-2"> <b>Shift</b> </div>
                <div class="col-md-5"> : <%=s.getName()%> </div>
              </div>
            </div>
            <div class="row">
              <div class="box-body">
                <div class="col-md-2"> <b>Start Time</b> </div>
                <div class="col-md-3"> : <%=Formater.formatDate(ct.getOpenDate(), "HH:mm:ss")%> </div>
                <div class="col-md-2"> <b>Closing</b> </div>
                <div class="col-md-5 closingBillTime"> : 17:00:00</div>
              </div>
            </div>
            <div class="row">
              <div class="col-md-12">
                <table id="example1" class="table table-bordered table-striped user-form-group">
                  <tbody>
                    <tr>
                      <th>PAYMENT TYPE</th>
                      <th>CURRENCY</th>
                      <th>NOMINAL VALUE</th>
                    </tr>
                    <tr>
                      <td>
                        <input class="form-control money" value="0.0" type="hidden">
                        <input class="form-control" value="1" type="hidden">
                      </td>
                    </tr>
                    <% Vector<PaymentSystem> ps = PstPaymentSystem.list(0, 0, "", PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_SYSTEM]); %>
                    <% for(PaymentSystem p: ps) { %>
                    <tr>
                      <td>
                          <%=p.getPaymentSystem()%>
                          <input type="hidden" value="<%= p.getOID() %>" name="<%=FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_PAYMENT_SYSTEM_ID]%>">
                      </td>
                      <td>
                        <select class="form-control" name="<%=FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_CURRENCYID]%>">
                            <%
                                Vector<CurrencyType> listCurrency = PstCurrencyType.list(0, 0, null, null);
                                for (CurrencyType c : listCurrency) {
                            %>
                            <option value="<%= c.getOID() %>"><%= c.getCode() %></option>
                            <%
                                }
                            %>
                        </select>
                      </td>
                      <td>
                        <input style="text-align:right;" class="form-control text_1 amountCloseClear textClose money" data-cast-class="val-money" id="closingText_1" data-index="1" type="text">
                        <input type="hidden" value="0" class="hidden val-money value-balance" name="<%=FrmCashTellerBalance.fieldNames[FrmCashTellerBalance.FRM_FIELD_BALANCEVALUE]%>">
                      </td>
                    </tr>
                    <% } %>
                    <tr>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                    </tr>
                    <tr>
                      <td><b>TOTAL CLOSING AMOUNT</b></td>
                      <td></td>
                      <td>
                        <input value="0" disabled style="text-align:right; font-weight:bold;" class="total-amount-display form-control totalClosingText_1 textCloseFor_1 totalCloseText amountCloseClear" data-index="1" type="text">
                        <input type="hidden" value="0" class="total-amount-val" name="">
                      </td>
                    </tr>
                    <% if(user == 0) {%>
                    <tr>
                      <td><b>SUPERVISOR</b></td>
                      <td></td>
                      <td>
                        <input class="spv-status include-check" type="hidden" name="<%=FrmAppUser.fieldNames[FrmAppUser.FRM_USER_GROUP] %>" value="3">
                        <input id="supervisorName" name="<%=FrmAppUser.fieldNames[FrmAppUser.FRM_LOGIN_ID] %>" class="form-control spv-uname include-check" placeholder="Supervisor Username" required="required" type="text">
                      </td>
                    </tr>
                    <tr>
                      <td><b>PASSWORD</b></td>
                      <td></td>
                      <td>
                        <input id="supervisorPassword" name="<%=FrmAppUser.fieldNames[FrmAppUser.FRM_PASSWORD] %>" autocomplete="off" class="form-control spv-pass include-check" placeholder="Supervisor Password" required="required" type="password">
                      </td>
                    </tr>
                    <% } %>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-success" id="closingButton"> <i class="fa fa-check"></i> Finish</button>
            <button type="button" class="btn btn-danger close-dialog" data-dismiss="modal"> <i class="fa fa-close"></i> Cancel</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>