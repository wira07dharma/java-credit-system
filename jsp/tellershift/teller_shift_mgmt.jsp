<%@page import="com.dimata.sedana.form.masterdata.CtrlCashTellerBalance"%>
<%@page import="com.dimata.sedana.form.masterdata.CtrlCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstSedanaShift"%>
<%@page import="com.dimata.common.entity.location.PstLocation"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterLoket"%>
<%@page import="com.dimata.sedana.entity.masterdata.SedanaShift"%>
<%@page import="com.dimata.common.entity.location.Location"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterLoket"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmCashTellerBalance"%>
<%@page import="com.dimata.sedana.form.masterdata.FrmCashTeller"%>
<%@page import="com.dimata.util.Command"%>
<%@page import="com.dimata.sedana.entity.masterdata.CashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.sedana.entity.masterdata.TellerShift"%>
<%@include file="/main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "/main/checkuser.jsp" %>
<%
  long oidCashTeller = FRMQueryString.requestLong(request, "oid");
  int iErrCode = 0;
  int iCommand   = FRMQueryString.requestCommand(request);
  CtrlCashTeller ctrlCashTeller = new CtrlCashTeller(request);
  iErrCode = ctrlCashTeller.action(iCommand, oidCashTeller);
  if(iErrCode == ctrlCashTeller.RSLT_OK) {
    CtrlCashTellerBalance ctrlCashTellerBalance = new CtrlCashTellerBalance(request);
    ctrlCashTellerBalance.action(iCommand, 0);
  }
%>
<!DOCTYPE html>
<html>
  <head>
    <title>JSP Page</title>
    <%@ include file = "/style/lte_head.jsp" %>
    <style>
        th {text-align: center; font-weight: normal; vertical-align: middle !important}
        th {background-color: #00a65a; color: white; padding-right: 8px !important}
        th:after {display: none !important;}
        th {border-left-width: 0px !important; border-bottom-width: 0px !important}
        td {border-left-width: 0px !important; border-bottom-width: 0px !important}
    </style>
  </head>
  <body style="background-color: rgb(234, 243, 223); height: auto;">
      <div class="main-page">
    <section class="content-header">
      <h1>
        Manajemen Teller
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="/sedana_v1/homexframe.jsp"><i class="fa fa-dashboard"></i> Home</a></li>
        <li>Pergantian Teller</li>
        <li class="active">Manajemen Teller</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
      <div class="row">
        <div class="col-xs-12">
          <!-- Horizontal Form -->
          <div class="box box-success">
            <div class="box-header with-border">
              <h3 class="box-title">Daftar Pergantian Teller</h3>
            </div>
            <div class="box-body">
              <style>
                .auto-datatable .numbering { width: 2px !important; margin: 0; padding: 7px; }
                .auto-datatable .date { width: 125px !important; }
                .auto-datatable .numbering:after { display: none !important; }
              </style>
              <div class="table-responsive">
                <table
                       class="table table-bordered table-striped auto-datatable"
                       data-action="ajax/datatable-teller-shift-mgmt.jsp"
                       data-for="<%=Command.LIST %>"
                       data-location="<%= userLocationId %>"
                       cellspacing="0"
                       data-invoke="shiftAction"
                       style="width: 100%; font-size: 14px"
                >
                  <thead>
                    <tr>
                      <th class="numbering">
                        <div align="">No.</div>
                      </th>
                      <th width="" class="date">
                        <div align="">Tanggal</div>
                      </th>
                      <th width="" class="">
                      <div align="">Nama&nbsp;Pengguna</div>
                      </th>
                      <th width="" class="">
                        <div align="">SPV&nbsp;Buka</div>
                      </th>
                      <th width="" class="">
                        <div align="">SPV&nbsp;Tutup</div>
                      </th>
                      <th width="" class="">
                        <div align="">Status</div>
                      </th>
                      <th width="" class="">
                        <div align="">Saldo&nbsp;Awal</div>
                      </th>
                      <th width="" class="">
                        <div align="">Debet&nbsp;(In)</div>
                      </th>
                      <th width="" class="">
                        <div align="">Kredit&nbsp;(Out)</div>
                      </th>
                      <th width="" class="">
                        <div align="">Mutasi</div>
                      </th>
                      <th width="" class="">
                        <div align="">Saldo&nbsp;Akhir&nbsp;Terhitung</div>
                      </th>
                      <th width="" class="">
                        <div align="">Saldo&nbsp;Akhir&nbsp;Input</div>
                      </th>
                      <th width="" class="">
                        <div align="">Selisih</div>
                      </th>
                      <th width="" class="">
                        <div align="">Aksi</div>
                      </th>
                    </tr>
                  </thead>
                  <tbody></tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <div id="shift-container"></div>
    </div>
    <print-area><div id="shift-print" class="print-area"></div></print-area>
  </body>
</html>
