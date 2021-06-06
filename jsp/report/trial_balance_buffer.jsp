<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
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
<title>Trial Balance Loading ...</title>
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

int currency = FRMQueryString.requestInt(request,SessTrialBalance.fieldNamesText[SessTrialBalance.FLD_CURRENCY]);
Date dueDate = null;
try{
	int dueYr = FRMQueryString.requestInt(request,SessTrialBalance.fieldNamesText[SessTrialBalance.FLD_DUE_DATE] + "_yr");
	int dueMn = FRMQueryString.requestInt(request,SessTrialBalance.fieldNamesText[SessTrialBalance.FLD_DUE_DATE] + "_mn");
	int dueDy = FRMQueryString.requestInt(request,SessTrialBalance.fieldNamesText[SessTrialBalance.FLD_DUE_DATE] + "_dy");
	dueDate = new Date(dueYr-1900, dueMn-1, dueDy);
}catch(Exception e) {}
String strDueDate = Formater.formatDate(dueDate,SESS_LANGUAGE,"MMMM dd, yyyy");
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	strDueDate = Formater.formatDate(dueDate,SESS_LANGUAGE,"dd MMMM yyyy");
}

Vector vectSelPeriod = SessPeriode.listPeriode(SessPeriode.getPeriodeIdBetween(dueDate));
Periode selPeriode = new Periode();
if(vectSelPeriod!=null && vectSelPeriod.size()>0){
	selPeriode = (Periode)vectSelPeriod.get(0);
}
long selPeriodId = selPeriode.getOID();
long beforeSelPeriodId = 0;
if(selPeriodId==0){ 
	Periode lastPeriode = new Periode();
	Vector vectLastPeriode = SessPeriode.getLastPeriod();
	if(vectLastPeriode!=null && vectLastPeriode.size()>0){
		lastPeriode = (Periode)vectLastPeriode.get(0);
	}
	if(dueDate.after(lastPeriode.getTglAwal())){
		beforeSelPeriodId = SessPeriode.getCurrPeriodId();
	}
}else{
	beforeSelPeriodId = SessPeriode.getPeriodIdJustBefore(selPeriodId);
}

String digitSeparator = ".";
String decimalSeparator = ",";
Vector vectEarn = new Vector(1,1);

double debetBalance = 0;
double kreditBalance = 0;
vectEarn = SessPLPeriodic.getPeriodCurrentEarning(beforeSelPeriodId, currency, 0);
if(vectEarn!=null && vectEarn.size()>0){
	Vector tempResult = (Vector)vectEarn.get(0);
	SaldoAkhirPeriode sa = (SaldoAkhirPeriode)tempResult.get(1);
	debetBalance = sa.getDebet();
	kreditBalance = sa.getKredit();
}

Vector vectTrialBalance = SessTrialBalance.listTrialBalance(dueDate,currency);
long currEarnId = PstAccountLink.getLinkAccountId(CtrlAccountLink.TYPE_CURRENT_EARNING_YR);

/**
 * Declare variable uses in report depend on language selected
 */
String reportTitle =  "TRIAL BALANCE REPORT \nPer " + strDueDate;
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	reportTitle = "LAPORAN NERACA PERCOBAAN \nPer " + strDueDate;
}
int language = SESS_LANGUAGE;
boolean toUpperCase = true;
String strTitle[][] = {
	{"Nomor","Nama","Saldo Awal","Mutasi","Saldo Akhir","Debet","Kredit"},
	{"Number","Name","Prev Balance","Mutation","Last Balance","Debet","Credit"}
};

Vector listTrialBalance = new Vector();
listTrialBalance.add(vectTrialBalance);
listTrialBalance.add(new Integer(currency));
listTrialBalance.add(strDueDate);
listTrialBalance.add(new Long(currEarnId));
listTrialBalance.add(new Double(debetBalance));
listTrialBalance.add(new Double(kreditBalance));
listTrialBalance.add(digitSeparator);
listTrialBalance.add(decimalSeparator);
listTrialBalance.add(strTitle);
listTrialBalance.add(new Integer(language));
listTrialBalance.add(new Boolean(toUpperCase));
listTrialBalance.add(reportTitle);
listTrialBalance.add(new Boolean(bPdfCompanyTitleUseImg));
listTrialBalance.add(sPdfCompanyTitle);
listTrialBalance.add(sPdfCompanyDetail);

if(session.getValue("TB_REPORT")!=null){
	session.removeValue("TB_REPORT");
}
session.putValue("TB_REPORT",listTrialBalance);

%>

<script language="JavaScript">
	document.location="<%=reportroot%>session.report.TrialBalancePdf?gettime=<%=System.currentTimeMillis()%>";
</script>


