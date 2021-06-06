<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.report.*" %>
<%@ page import="com.dimata.aiso.session.system.*" %>
<%@ page import="com.dimata.aiso.entity.search.*" %>
<%@ page import="com.dimata.aiso.entity.periode.*" %>

<!--import java-->
<%@ page import="java.util.Date" %>

<!--import qdep-->
<%@ page import="com.dimata.util.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %> 
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_GNR_LEDGER, AppObjInfo.OBJ_REPORT_GNR_LEDGER_PRIV); %>
<%@ include file = "../main/checkuser.jsp" %>

<html>
<head>
<title>Gross Profit of Goods Sold Loading ...</title>
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
//formatDate
String formatDate  = "MMMM dd, yyyy";

long accountId = FRMQueryString.requestLong(request,SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_ACCOUNT_SALES]);
long periodeId = FRMQueryString.requestLong(request,SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_PERIOD]);
int currency = FRMQueryString.requestInt(request,SessGrossProfit.grossFieldNames[SessGrossProfit.FLD_CURRENCY]);
String whereClause = PstPeriode.fieldNames[PstPeriode.FLD_IDPERIODE] + " = " + periodeId;
String perName = "";
Vector listPeriode = PstPeriode.list(0,0,whereClause,"");
if(listPeriode!=null && listPeriode.size()>0){
   Periode per = (Periode)listPeriode.get(0);
   perName = per.getNama();
}

/**
 * Declare variable uses in report depend on language selected
 */
String reportTitle = "GROSS PROFIT OF GOODS SOLD REPORT ";
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	reportTitle = "LAPORAN LABA KOTOR PENJUALAN ";
}
String digitSeparator = ".";
String decimalSeparator = ",";
int language = SESS_LANGUAGE;
boolean toUpperCase = true;
boolean useHeader = true;
boolean useTotal = true;
String strTitle[][] = {
	{"Laba Kotor ","Sub Total Laba Kotor ","Total Laba Kotor Penjualan"},
	{"Gross Profit ","Sub Total Gross Profit ","Total Gross Profit of Goods Sold"}
};

Vector listGrossProfit = new Vector();
Vector vectGrossProfit = SessGrossProfit.listGrossProfit(periodeId,accountId,currency);
listGrossProfit.add(vectGrossProfit);
listGrossProfit.add(new Long(accountId)); 
listGrossProfit.add(new Long(periodeId)); 
listGrossProfit.add(new Integer(currency));
listGrossProfit.add(perName);
listGrossProfit.add(reportTitle);
listGrossProfit.add(digitSeparator);
listGrossProfit.add(decimalSeparator);
listGrossProfit.add(new Integer(language));
listGrossProfit.add(new Boolean(toUpperCase));
listGrossProfit.add(strTitle);
listGrossProfit.add(new Boolean(useHeader));
listGrossProfit.add(new Boolean(useTotal));
listGrossProfit.add(new Boolean(bPdfCompanyTitleUseImg));
listGrossProfit.add(sPdfCompanyTitle);
listGrossProfit.add(sPdfCompanyDetail);

if(session.getValue("GP_REPORT")!=null){
	session.removeValue("GP_REPORT");
}
session.putValue("GP_REPORT",listGrossProfit);

%>


<script language="JavaScript">
	document.location="<%=reportroot%>session.report.GrossProfitPdf?gettime=<%=System.currentTimeMillis()%>";
</script>

