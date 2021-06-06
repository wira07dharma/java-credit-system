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
<title>Cash Flow Loading ...</title>
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

int reportType = FRMQueryString.requestInt(request,SessCashFlow.cashFieldNames[SessCashFlow.FLD_TYPE]);
long periodeId = FRMQueryString.requestLong(request,SessCashFlow.cashFieldNames[SessCashFlow.FLD_PERIOD]);
int currency = FRMQueryString.requestInt(request,SessCashFlow.cashFieldNames[SessCashFlow.FLD_CURRENCY]);    
int startYr = FRMQueryString.requestInt(request,SessCashFlow.cashFieldNames[SessCashFlow.FLD_STARTDATE] + "_yr");
int startMn = FRMQueryString.requestInt(request,SessCashFlow.cashFieldNames[SessCashFlow.FLD_STARTDATE] + "_mn");
int startDy = FRMQueryString.requestInt(request,SessCashFlow.cashFieldNames[SessCashFlow.FLD_STARTDATE] + "_dy");
int dueYr = FRMQueryString.requestInt(request,SessCashFlow.cashFieldNames[SessCashFlow.FLD_DUEDATE] + "_yr");
int dueMn = FRMQueryString.requestInt(request,SessCashFlow.cashFieldNames[SessCashFlow.FLD_DUEDATE] + "_mn");
int dueDy = FRMQueryString.requestInt(request,SessCashFlow.cashFieldNames[SessCashFlow.FLD_DUEDATE] + "_dy");

Date startDate = new Date(startYr-1900, startMn-1, startDy);
Date dueDate = new Date(dueYr-1900, dueMn-1, dueDy);
    
String perName = "";
if(reportType==SessCashFlow.REPORT_PERIODIC){
    String whereClause = PstPeriode.fieldNames[PstPeriode.FLD_IDPERIODE] + " = " + periodeId;
    Vector listPeriode = PstPeriode.list(0,0,whereClause,"");
    if(listPeriode!=null && listPeriode.size()>0){
       Periode per = (Periode)listPeriode.get(0);
       perName = "PERIOD "+per.getNama();
    }
}else{
    perName = Formater.formatDate(startDate,SESS_LANGUAGE,"MMMM dd, yyyy") + " - " + Formater.formatDate(dueDate,SESS_LANGUAGE,"MMMM dd, yyyy");
	if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
		perName = Formater.formatDate(startDate,SESS_LANGUAGE,"dd MMMM yyyy") + " - " + Formater.formatDate(dueDate,SESS_LANGUAGE,"dd MMMM yyyy");
	}	
}
double prevBalance = SessCashFlow.getPrevSaldo(reportType, startDate, periodeId,currency);
Vector vectCashIn = SessCashFlow.listCashFlowIn(reportType, startDate, dueDate, periodeId,currency);
Vector vectCashOut = SessCashFlow.listCashFlowOut(reportType, startDate, dueDate, periodeId,currency);

/**
 * Declare variable uses in report depend on language selected
 */
String reportTitle = "CASH FLOW REPORT\nPer "+perName;
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	reportTitle = "LAPORAN ALIRAN KAS\nPer "+perName;
}
String digitSeparator = ".";
String decimalSeparator = ",";
int language = SESS_LANGUAGE;
boolean toUpperCase = true;
boolean useTotal = false;
boolean useHeader = false;
String[][] strTitle = {
	{"Saldo Awal","Kas Masuk","Total Kas Masuk","Kas Keluar","Total Kas Keluar", "Total Aliran Kas","Saldo Akhir"},
	{"Prev Balance","Cash In","Total Cash In","Cash Out","Total Cash Out","Total Cash Flow","Last Balance"}
};

Vector listCashFlow = new Vector();
listCashFlow.add(new Double(prevBalance)); 
listCashFlow.add(vectCashIn);
listCashFlow.add(vectCashOut);
listCashFlow.add(new Integer(currency));
listCashFlow.add(perName);
listCashFlow.add(digitSeparator);
listCashFlow.add(decimalSeparator);
listCashFlow.add(strTitle);
listCashFlow.add(new Integer(language));
listCashFlow.add(new Boolean(toUpperCase));
listCashFlow.add(reportTitle);
listCashFlow.add(new Boolean(useHeader));
listCashFlow.add(new Boolean(bPdfCompanyTitleUseImg));
listCashFlow.add(sPdfCompanyTitle);
listCashFlow.add(sPdfCompanyDetail);

if(session.getValue("CF_REPORT")!=null){
        session.removeValue("CF_REPORT");
}
session.putValue("CF_REPORT",listCashFlow);
%>

<script language="JavaScript">
	document.location="<%=reportroot%>session.report.CashFlowPdf?gettime=<%=System.currentTimeMillis()%>";
</script>

