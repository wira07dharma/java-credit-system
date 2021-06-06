<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.session.analysis.*" %>

<!--import qdep-->
<%@ page import="com.dimata.util.*" %>
<%@ page import="com.dimata.qdep.form.*" %> 
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_GNR_LEDGER, AppObjInfo.OBJ_REPORT_GNR_LEDGER_PRIV); %>
<%@ include file = "../main/checkuser.jsp" %>

<html>
<head>
<title>Equity Rentability Loading ...</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000"> 
<script language="JavaScript">
	window.focus();
</script>
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="98" height="8">
  <param name=movie value="../image/loader.swf">
  <param name=quality value=high>
  <embed src="../image/loader.swf" quality=high pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="98" height="8">
  </embed> 
</object>
</body>
</html>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));
boolean privPrint=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_PRINT));
%>

<!-- JSP Block -->
<%
 int iCommand = FRMQueryString.requestCommand(request);
 int iReportType = FRMQueryString.requestInt(request, "reportType");
 int iYear = FRMQueryString.requestInt(request, "annual");
 long lPeriodOid = FRMQueryString.requestLong(request, "period");
 int iBookType = FRMQueryString.requestInt(request, "bookType");
 long lCurrencyOid = FRMQueryString.requestLong(request, "currencyOid");
 String strPeriodName = FRMQueryString.requestString(request, "periodName");
 String strBookType = FRMQueryString.requestString(request, "strBookType");
 String strCurrency = FRMQueryString.requestString(request, "strCurrency");
 
 ReportAnalysis objProfit = new ReportAnalysis(); 
 Vector vectEquity = new Vector();
 String title = "";
 
 if (iCommand == Command.PRINT) {
     if (iReportType == 0) {        // report use periode
         objProfit = SessAnalysis.getProfitPeriod(lPeriodOid, iBookType, SESS_LANGUAGE);
         vectEquity = SessAnalysis.generateReportPeriod(PstAccountLink.TYPE_EQUITY, lPeriodOid, iBookType, lCurrencyOid, SESS_LANGUAGE);
         
     } else {                       // report use annual
         objProfit = SessAnalysis.getProfitYear(iYear, iBookType, SESS_LANGUAGE);         
         vectEquity = SessAnalysis.generateReportYear(PstAccountLink.TYPE_EQUITY, iYear, iBookType, lCurrencyOid, SESS_LANGUAGE);
            
     }    
     
 }   
 
 if (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN) {
     title = "Equity Rentability Analysis Report";
     if (iReportType == 0) {
         title += "\nPeriod : " + strPeriodName;
     } else {
         title += "\nPeriod : " + iYear;
     }
     title += "\nBook Type : " + strBookType + "\nTransaction In : " + strCurrency;
     
 } else {
     title = "Laporan Analisis Rentabilitas Modal";
     if (iReportType == 0) {
         title += "\nPeriode : " + strPeriodName;
     } else {
         title += "\nPeriode : " + iYear;
     }
     title += "\nTipe Pembukuan : " + strBookType + "\nTransaksi Dalam : " + strCurrency;
 }
   
 Vector vectEquityRent = new Vector();
     
 vectEquityRent.add(objProfit);
 vectEquityRent.add(vectEquity);
 vectEquityRent.add(title);
 vectEquityRent.add(String.valueOf(SESS_LANGUAGE));
 vectEquityRent.add(sUserDigitGroup);
 vectEquityRent.add(sUserDecimalSymbol);
 vectEquityRent.add(new Boolean(bPdfCompanyTitleUseImg));
 vectEquityRent.add(sPdfCompanyTitle);
 vectEquityRent.add(sPdfCompanyDetail);
 vectEquityRent.add(String.valueOf(iPdfHeaderFooterFlag));

 if (session.getValue("EQUITY_RENTABILITY") != null) {
    session.removeValue("EQUITY_RENTABILITY");
 }
 session.putValue("EQUITY_RENTABILITY", vectEquityRent);

%>

<script language="javascript">
 document.location = "<%=reportroot%>session.analysis.EquityRentabilityPdf?gettime=<%=System.currentTimeMillis()%>";
</script>


