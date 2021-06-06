<%@page import="com.dimata.common.entity.system.PstSystemProperty"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterLoket"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterLoket"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.aiso.entity.admin.PstAppUser"%>
<%@page import="com.dimata.aiso.entity.admin.AppUser"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmCashTellerBalance"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTellerBalance"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTellerBalance"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%
  String compName = "";
  String compAddr = "";
  String compPhone = "";
  compName = PstSystemProperty.getValueByName("COMPANY_NAME");
  compAddr = PstSystemProperty.getValueByName("COMPANY_ADDRESS");
  compPhone = PstSystemProperty.getValueByName("COMPANY_PHONE");
%>
<%
  long userOID = FRMQueryString.requestLong(request, "user");
  long tellerShiftId = FRMQueryString.requestLong(request, "id");
  double computed = FRMQueryString.requestDouble(request, "computed");
  CashTeller ct = PstCashTeller.fetchExc(tellerShiftId);
  Vector<CashTellerBalance> vOpening = PstCashTellerBalance.list(0, 1, PstCashTellerBalance.fieldNames[PstCashTellerBalance.FLD_TELLER_SHIFT_ID] + "=" + tellerShiftId + " AND " + PstCashTellerBalance.fieldNames[PstCashTellerBalance.FLD_TYPE] + "=" + FrmCashTellerBalance.STATUS_OPEN, "");
  Vector<CashTellerBalance> vClosing = PstCashTellerBalance.list(0, 0, PstCashTellerBalance.fieldNames[PstCashTellerBalance.FLD_TELLER_SHIFT_ID] + "=" + tellerShiftId + " AND " + PstCashTellerBalance.fieldNames[PstCashTellerBalance.FLD_TYPE] + "=" + FrmCashTellerBalance.STATUS_CLOSE, "");
  CashTellerBalance opening = (vOpening.size() > 0) ? (CashTellerBalance) vOpening.get(0) : new CashTellerBalance();
  CashTellerBalance closing = (vClosing.size() > 0) ? (CashTellerBalance) vClosing.get(0) : new CashTellerBalance();
  double closingValue = 0;
  for (CashTellerBalance balanceClose : vClosing) {
      closingValue += balanceClose.getBalanceValue();
  }
  AppUser teller = PstAppUser.fetch(ct.getAppUserId());
  AppUser open = PstAppUser.fetch(ct.getSpvOpenId());
  AppUser close = PstAppUser.fetch(ct.getSpvCloseId());
  MasterLoket ml = PstMasterLoket.fetchExc(ct.getMasterLoketId());
  Location location = PstLocation.fetchExc(ml.getLocationId());
%>
<style>
  .print-area .head * { font-size: 15pt;}
  .print-area .body * { font-size: 13pt; }
  .print-area td { padding: 3px; }
  .print-area .space td { padding: 8px; }
</style>
<div class="col-xs-12 head" style="padding-bottom: 30pt">
  <div class="col-xs-9">
    <strong style="width: 100%; display: inline-block;"><%=compName%></strong>
    <span style="width: 100%; display: inline-block;"><%=compAddr%></span>
    <span style="width: 100%; display: inline-block;"><%=compPhone%></span>
    <span style="width: 100%; display: inline-block;">-</span>
  </div>
  <div class="col-xs-3">
    <span style="width: 100%; display: inline-block; font-weight: 400; font-size: 20px;">CLOSING TELLER</span>
    <span style="width: 100%; display: inline-block; font-size: 12px;"></span>
  </div>
</div>
<div class="col-xs-12">
  <div class="col-xs-6">
    <table border="0" colspacing="0" cellpadding="0" style="width: 100%;">
      <tbody>
        <tr>
          <td>Teller</td>
          <td>&nbsp;:</td>
          <td><%=teller.getFullName()%></td>
        </tr>
        <tr>
          <td>SPV Open</td>
          <td>&nbsp;:</td>
          <td><%=open.getFullName()%></td>
        </tr>
        <tr>
          <td>SPV Closing</td>
          <td>&nbsp;:</td>
          <td><%=close.getFullName()%></td>
        </tr>
        <tr class="space"><td colspan="3"></td></tr>
        <tr>
          <td>Opening Time</td>
          <td>&nbsp;:</td>
          <td><%=Formater.formatDate(ct.getOpenDate(), "yyyy-MM-dd HH:mm:ss")%></td>
        </tr>
        <tr>
          <td>Closing Time</td>
          <td>&nbsp;:</td>
          <td><%=((ct.getCloseDate() != null) ? Formater.formatDate(ct.getCloseDate(), "yyyy-MM-dd HH:mm:ss") : "-")%></td>
        </tr>
        <tr class="space"><td colspan="3"></td></tr>
        <tr>
          <td>Location</td>
          <td>&nbsp;:</td>
          <td><%=location.getName()%></td>
        </tr>
        <tr>
          <td>Loket</td>
          <td>&nbsp;:</td>
          <td><%=ml.getLoketNumber()%></td>
        </tr>
      </tbody>
    </table>
  </div>
  <div class="col-xs-6">
    <table border="0" colspacing="0" cellpadding="0" style="width: 100%;">
      <tbody>
        <tr>
          <td>Open Teller Balance</td>
          <td>&nbsp;:</td>
          <td class="money"><%=opening.getBalanceValue()%></td>
        </tr>
        <tr>
          <td>Computed Balance</td>
          <td>&nbsp;:</td>
          <td class="money"><%=computed%></td>
        </tr>
        <tr>
          <td>Close Teller Balance</td>
          <td>&nbsp;:</td>
          <td class="money"><%=closingValue%></td>
        </tr>
        <tr>
          <td>Selisih</td>
          <td>&nbsp;:</td>
          <td class="money"><%=Math.abs((computed - closingValue))%></td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
<div style="margin-top: 100px;"></div>
<div class="col-xs-10 col-xs-offset-1">
  <div style="margin-top: 100px;width: 100%;"></div>
  <div style="width: 50%; float: left;">
    <div style="width: 100%; text-align: center;">Supervisor</div>
    <br>
    <br>
    <br>
    <div style="width: 100%; text-align: center;margin-bottom: -10px;">&nbsp;</div>
    <div style="width: 100%; text-align: center;">.............................................</div>
  </div>
  <div style="width: 50%; float: right;">
    <div style="width: 100%; text-align: center;">Teller</div>
    <br>
    <br>
    <br>
    <div style="width: 100%; text-align: center;margin-bottom: -10px;"><%=teller.getFullName()%></div>
    <div style="width: 100%; text-align: center;">.............................................</div>
  </div>
</div>