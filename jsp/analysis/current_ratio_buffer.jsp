<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.session.analysis.*" %>

<!--import java-->
<%//@ page import="java.util.Date" %>

<!--import qdep-->
<%@ page import="com.dimata.util.*" %>
<%@ page import="com.dimata.qdep.form.*" %> 
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_GNR_LEDGER, AppObjInfo.OBJ_REPORT_GNR_LEDGER_PRIV); %>
<%@ include file = "../main/checkuser.jsp" %>

<html>
<head>
<title>Current Ratio Loading ...</title>
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
 long lCurrencyOid = FRMQueryString.requestLong(request, "transactionIn");
 String strPeriodName = FRMQueryString.requestString(request, "periodName");
 String strBookType = FRMQueryString.requestString(request, "strBookType");
 String strCurrency = FRMQueryString.requestString(request, "strCurrency");
 
  
 Vector vectLiqAssets = new Vector();
 Vector vectCurrLblities = new Vector();
 String title = "";
 
 if (iCommand == Command.PRINT) {
     if (iReportType == 0) {        // report use periode
         vectLiqAssets = SessAnalysis.generateReportPeriod(PstAccountLink.TYPE_LIQUID_ASSETS, lPeriodOid, iBookType, lCurrencyOid, SESS_LANGUAGE);
         vectCurrLblities = SessAnalysis.generateReportPeriod(PstAccountLink.TYPE_CURRENT_LIABILITIES, lPeriodOid, iBookType, lCurrencyOid, SESS_LANGUAGE);
         
     } else {                       // report use annual
         vectLiqAssets = SessAnalysis.generateReportYear(PstAccountLink.TYPE_LIQUID_ASSETS, iYear, iBookType, lCurrencyOid, SESS_LANGUAGE);
         vectCurrLblities = SessAnalysis.generateReportYear(PstAccountLink.TYPE_CURRENT_LIABILITIES, iYear, iBookType, lCurrencyOid, SESS_LANGUAGE);
            
     }    
    
     
 }   
 
 if (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN) {
     title = "Current Ratio Analysis Report";
     if (iReportType == 0) {
         title += "\nPeriod : " + strPeriodName;
     } else {
         title += "\nPeriod : " + iYear;
     }
     title += "\nBook Type : " + strBookType + "\nTransaction In : " + strCurrency;
     
 } else {
     title = "Laporan Analisis Current Ratio";
     if (iReportType == 0) {
         title += "\nPeriode : " + strPeriodName;
     } else {
         title += "\nPeriode : " + iYear;
     }
     title += "\nTipe Pembukuan : " + strBookType + "\nTransaksi Dalam : " + strCurrency;
 }
   
 Vector vectCurrRatio = new Vector();
     
 vectCurrRatio.add(vectLiqAssets);
 vectCurrRatio.add(vectCurrLblities);
 vectCurrRatio.add(title);
 vectCurrRatio.add(String.valueOf(SESS_LANGUAGE));
 vectCurrRatio.add(sUserDigitGroup);
 vectCurrRatio.add(sUserDecimalSymbol);
 vectCurrRatio.add(new Boolean(bPdfCompanyTitleUseImg));
 vectCurrRatio.add(sPdfCompanyTitle);
 vectCurrRatio.add(sPdfCompanyDetail);
 vectCurrRatio.add(String.valueOf(iPdfHeaderFooterFlag));
 

 if (session.getValue("CR_REPORT") != null) {
    session.removeValue("CR_REPORT");
 }
 session.putValue("CR_REPORT", vectCurrRatio);

%>

<script language="javascript">
 document.location = "<%=reportroot%>session.analysis.CurrentRatioPdf?gettime=<%=System.currentTimeMillis()%>";
</script>


