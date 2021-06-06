<%-- 
    Document   : print_closing
    Created on : Aug 22, 2017, 12:00:59 PM
    Author     : Regen
--%>

<%@include file="/main/javainit.jsp" %>
<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER);%>
<%@ include file = "/main/checkuser.jsp" %>
<!DOCTYPE html>
<html>
  <head>
    <title>SEDANA</title>
    <%@ include file = "/style/lte_head.jsp" %>
    <script>$(document).ready(function(){window.print();});</script>
  </head>
  <body>
      <div class="container">
        <div class="print-area">
          <div class="col-xs-6">
            <div class="col-xs-12">
              <div class="col-xs-4">Cashier</div>
              <div class="col-xs-8">: Administrator</div>
            </div>
            <div class="col-xs-12">
              <div class="col-xs-4">Date</div>
              <div class="col-xs-8">: 2017-08-22</div>
            </div>
            <div class="col-xs-12">
              <div class="col-xs-4">Start Time</div>
              <div class="col-xs-8">: 11:58:13</div>
            </div>
          </div>
          <div class="col-xs-6">
            <div class="col-xs-12">
              <div class="col-xs-4">Location</div>
              <div class="col-xs-8">: BUMDesa Dwi Amertha Sari</div>
            </div>
            <div class="col-xs-12">
              <div class="col-xs-4">Shift</div>
              <div class="col-xs-8">: Pagi</div>
            </div>
            <div class="col-xs-12">
              <div class="col-xs-4">Closing</div>
              <div class="col-xs-8">: 13:49:19</div>
            </div>
          </div>
          <div style="margin-top: 100px;"></div>
          <div class="col-xs-12"><div class="col-xs-12"><div class="col-xs-12">
            <strong>TOTAL : <span class="money">50000</span></strong>
            <div style="margin-top: 100px;"></div>
            <div>Administrator</div>
            <br>
            <br>
            <br>
            <div>................................</div>
          </div></div></div>
        </div>
      </div>
    </div>
  </body>
</html>
