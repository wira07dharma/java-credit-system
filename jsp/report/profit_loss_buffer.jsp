<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.report.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.form.masterdata.*" %>
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
<title>Profit Loss Loading ...</title>
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
String formatDate  = "MMMM dd, yyyy";

int reportType = FRMQueryString.requestInt(request,SessPL.plFieldText[SessPL.PL_TYPE]);
long periodId = FRMQueryString.requestLong(request,SessPL.plFieldText[SessPL.PL_PERIOD]);
int selectedYear = FRMQueryString.requestInt(request,SessPL.plFieldText[SessPL.PL_ANNUALS]);
int currency = FRMQueryString.requestInt(request,SessPL.plFieldText[SessPL.PL_CURRENCY]);
double rate = FRMQueryString.requestFloat(request,SessPL.plFieldText[SessPL.PL_RATE]);
int selectedLevel = FRMQueryString.requestInt(request,SessPL.plFieldText[SessPL.PL_LEVEL]);
long lastPeriodId = SessPeriode.getPeriodIdJustBefore(periodId);

Date startDate = new Date(selectedYear-1900,0,1);
Date dueDate = new Date(selectedYear-1900,11,31);
Date lastStartDate = new Date(selectedYear-1901,0,1);
Date lastDueDate = new Date(selectedYear-1901,11,31);
String timeReport = "";
String titleReport  = "";
if(reportType==SessPL.REPORT_PERIODIC){
	String whereClause = PstPeriode.fieldNames[PstPeriode.FLD_IDPERIODE] + " = " + periodId;
	Vector listPeriode = PstPeriode.list(0,0,whereClause,"");
	if(listPeriode!=null && listPeriode.size()>0){
	  Periode per = (Periode)listPeriode.get(0);
	  timeReport = per.getNama();	  
	  titleReport = "PERIOD";
	}
}else{
	timeReport = String.valueOf(selectedYear);  
	titleReport = "YEAR";
}

Vector listProfitLoss = new Vector(1,1);
String taxesId = PstAccountLink.getLinkAccountStr(CtrlAccountLink.TYPE_TAXES);

if(reportType==SessPL.REPORT_PERIODIC){
	listProfitLoss = SessProfitLoss.listProfitLossReport(null,null,null,null,lastPeriodId,periodId,currency,selectedLevel,rate);
}else{
	listProfitLoss = SessProfitLoss.listProfitLossReport(lastStartDate,lastDueDate,startDate,dueDate,0,0,currency,selectedLevel,rate);
}

String strType = "Period";
String reportTitle[] = {
	"Laporan Laba(Rugi) ","Profit(Loss) Report "
};
String digitSeparator = ".";
String decimalSeparator = ",";
int language = SESS_LANGUAGE;
boolean toUpperCase = true;
String strTitle[][] = {
	{"Nama Perkiraan","Saldo","Lalu","Sekarang","Total","Halaman","Laba(Rugi) Sebelum Pajak","Laba(Rugi) Setelah Pajak","Pajak","Total Pajak"},   
	{"Account Name","Balance","Last","Current","Total","Page","Profit(Loss) Before Taxes","Profit(Loss) After Taxes","Taxes","Total Taxes"}
};
int accNameWidth = 70;
int previousWidth = 20;
int currentWidth = 20;

Vector vectProfitLoss = new Vector();
vectProfitLoss.add(listProfitLoss);
vectProfitLoss.add(new Integer(selectedLevel));
vectProfitLoss.add(new Integer(currency));
vectProfitLoss.add(strType);
vectProfitLoss.add(taxesId);
vectProfitLoss.add(reportTitle[language]+timeReport);
vectProfitLoss.add(digitSeparator);
vectProfitLoss.add(decimalSeparator);
vectProfitLoss.add(new Integer(language)); 
vectProfitLoss.add(new Boolean(toUpperCase));
vectProfitLoss.add(strTitle);
vectProfitLoss.add(new Integer(accNameWidth));
vectProfitLoss.add(new Integer(previousWidth));
vectProfitLoss.add(new Integer(currentWidth));
vectProfitLoss.add(new Boolean(bPdfCompanyTitleUseImg));
vectProfitLoss.add(sPdfCompanyTitle);
vectProfitLoss.add(sPdfCompanyDetail);

if(session.getValue("PL_REPORT")!=null){
	session.removeValue("PL_REPORT");
}
session.putValue("PL_REPORT",vectProfitLoss);

%>

<script language="JavaScript">
	document.location="<%=reportroot%>session.report.ProfitLossPdf?gettime=<%=System.currentTimeMillis()%>";
</script>


