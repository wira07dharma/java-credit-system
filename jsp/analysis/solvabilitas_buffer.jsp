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
<title>Solvabilitas Loading ...</title>
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
 Vector vectFixAssets = new Vector();
 Vector vectCurrLblties = new Vector();
 Vector vectLongTermLblties = new Vector();
 String title = "";
 
 if (iCommand == Command.PRINT) {
     if (iReportType == 0) {        // report use periode
         vectLiqAssets = SessAnalysis.generateReportPeriod(PstAccountLink.TYPE_LIQUID_ASSETS, lPeriodOid, iBookType, lCurrencyOid, SESS_LANGUAGE);
         vectFixAssets = SessAnalysis.generateReportPeriod(PstAccountLink.TYPE_FIXED_ASSETS, lPeriodOid, iBookType, lCurrencyOid, SESS_LANGUAGE);
         vectCurrLblties = SessAnalysis.generateReportPeriod(PstAccountLink.TYPE_CURRENT_LIABILITIES, lPeriodOid, iBookType, lCurrencyOid, SESS_LANGUAGE);
         vectLongTermLblties = SessAnalysis.generateReportPeriod(PstAccountLink.TYPE_LONG_TERM_LIABILITIES, lPeriodOid, iBookType, lCurrencyOid, SESS_LANGUAGE);
         
     } else {                       // report use annual
         vectLiqAssets = SessAnalysis.generateReportYear(PstAccountLink.TYPE_LIQUID_ASSETS, iYear, iBookType, lCurrencyOid, SESS_LANGUAGE);
         vectFixAssets = SessAnalysis.generateReportYear(PstAccountLink.TYPE_FIXED_ASSETS, iYear, iBookType, lCurrencyOid, SESS_LANGUAGE);
         vectCurrLblties = SessAnalysis.generateReportYear(PstAccountLink.TYPE_CURRENT_LIABILITIES, iYear, iBookType, lCurrencyOid, SESS_LANGUAGE);
         vectLongTermLblties = SessAnalysis.generateReportYear(PstAccountLink.TYPE_LONG_TERM_LIABILITIES, iYear, iBookType, lCurrencyOid, SESS_LANGUAGE);
     }    
    
     
 }   
 
 if (SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN) {
     title = "Solvabilitas Analysis Report";
     if (iReportType == 0) {
         title += "\nPeriod : " + strPeriodName;
     } else {
         title += "\nPeriod : " + iYear;
     }
     title += "\nBook Type : " + strBookType + "\nTransaction In : " + strCurrency;
     
 } else {
     title = "Laporan Analisis Solvabilitas";
     if (iReportType == 0) {
         title += "\nPeriode : " + strPeriodName;
     } else {
         title += "\nPeriode : " + iYear;
     }
     title += "\nTipe Pembukuan : " + strBookType + "\nTransaksi Dalam : " + strCurrency;
 }
   
 
 Vector vectSolvabilitas = new Vector();
     
 vectSolvabilitas.add(vectLiqAssets);
 vectSolvabilitas.add(vectFixAssets);
 vectSolvabilitas.add(vectCurrLblties);
 vectSolvabilitas.add(vectLongTermLblties);
 vectSolvabilitas.add(title);
 vectSolvabilitas.add(String.valueOf(SESS_LANGUAGE));
 vectSolvabilitas.add(sUserDigitGroup);
 vectSolvabilitas.add(sUserDecimalSymbol);
 vectSolvabilitas.add(new Boolean(bPdfCompanyTitleUseImg));
 vectSolvabilitas.add(sPdfCompanyTitle);
 vectSolvabilitas.add(sPdfCompanyDetail);
 vectSolvabilitas.add(String.valueOf(iPdfHeaderFooterFlag));


 if (session.getValue("SOLVABILITAS") != null) {
    session.removeValue("SOLVABILITAS");
 }
 session.putValue("SOLVABILITAS", vectSolvabilitas);

%>

<script language="javascript">
 document.location = "<%=reportroot%>session.analysis.SolvabilitasPdf?gettime=<%=System.currentTimeMillis()%>";
</script>


