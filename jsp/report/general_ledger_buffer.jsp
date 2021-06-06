<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--import contact-->
<%@ page import="com.dimata.common.entity.contact.*" %>
<%@ page import="com.dimata.common.session.contact.*" %>

<!--import aiso-->
<%@ page import="com.dimata.aiso.entity.jurnal.*" %>
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.form.jurnal.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.report.*" %>
<%@ page import="com.dimata.aiso.session.system.*" %>

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
<title>General Ledger Loading ...</title>
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
/**
 * get client's request and atributte declaration 
 */
long accountId = FRMQueryString.requestLong(request,SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_ACCOUNT]);
long contactId = FRMQueryString.requestLong(request,"contactOid");
int currency = FRMQueryString.requestInt(request,SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_CURRENCY]);
Date startDate = null;
Date dueDate = null;
try{
	int startYr = FRMQueryString.requestInt(request, SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_START_DATE] + "_yr");
	int startMn = FRMQueryString.requestInt(request, SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_START_DATE] + "_mn");
	int startDy = FRMQueryString.requestInt(request, SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_START_DATE] + "_dy");

	int dueYr = FRMQueryString.requestInt(request, SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_DUE_DATE] + "_yr");
	int dueMn = FRMQueryString.requestInt(request, SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_DUE_DATE] + "_mn");
	int dueDy = FRMQueryString.requestInt(request, SessGeneralLedger.glFieldNames[SessGeneralLedger.FLD_GL_DUE_DATE] + "_dy");

	startDate = new Date(startYr-1900, startMn-1, startDy);
	dueDate = new Date(dueYr-1900, dueMn-1, dueDy);
	
}catch(Exception e) {}

String accountName = "";
boolean accountPosted = false;
int accountSign = 0;
Vector listAccount = SessGeneralLedger.listAccount(accountId);
if(listAccount!=null && listAccount.size()>0){
	for(int i=0; i<listAccount.size(); i++){
		Perkiraan acc = (Perkiraan) listAccount.get(i);
		accountName = acc.getNama();
		accountPosted = acc.getPostable();
		accountSign = acc.getTandaDebetKredit();
	}
}

String contactName = SessContactList.getContactName(contactId);

String strStartDate = Formater.formatDate(startDate,SESS_LANGUAGE,"MMMM dd, yyyy");
String strDueDate = Formater.formatDate(dueDate,SESS_LANGUAGE,"MMMM dd, yyyy");
String strNewDate = Formater.formatDate(new Date(),SESS_LANGUAGE,"MMMM dd, yyyy");
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	strStartDate = Formater.formatDate(startDate,SESS_LANGUAGE,"dd MMMM yyyy");
	strDueDate = Formater.formatDate(dueDate,SESS_LANGUAGE,"dd MMMM yyyy");
	strNewDate = Formater.formatDate(new Date(),SESS_LANGUAGE,"dd MMMM yyyy");
}

/**
 * get data from getGeneralLedger method 
 */
double opBalance = SessGeneralLedger.getOpBalance(accountId,currency);
double lastBalance = 0;

if(contactId!=0){
	lastBalance = SessGeneralLedger.listPrevGeneralLedger(accountId,contactId,startDate,currency);
}else{
	lastBalance = SessGeneralLedger.listPrevGeneralLedger(accountId,startDate,currency);
}

double lastGLBalance = opBalance+lastBalance;
String strPrevSaldo = FRMHandler.userFormatStringDecimal(lastGLBalance);
if(lastGLBalance<0){
	strPrevSaldo = "("+FRMHandler.userFormatStringDecimal(lastGLBalance).substring(1)+")";
}

double sumDebit = 0;
double sumCredit = 0;
Vector listGeneralLedger = new Vector(1,1);
if(contactId!=0){
	listGeneralLedger = SessGeneralLedger.listGeneralLedger(accountId,contactId,startDate,dueDate,currency);
}else{
	listGeneralLedger = SessGeneralLedger.listGeneralLedger(accountId,startDate,dueDate,currency);
}

if(listGeneralLedger!=null && listGeneralLedger.size()>0){
	for(int i=0; i<listGeneralLedger.size(); i++){
		Vector temp = (Vector)listGeneralLedger.get(i);
		JurnalDetail jd = (JurnalDetail)temp.get(1);
		Perkiraan acc = (Perkiraan)temp.get(2);

		if(jd.getDebet()>jd.getKredit()){ //debet sign
			sumDebit = sumDebit + jd.getDebet();
		}else{
			sumCredit = sumCredit + jd.getKredit();
		}
	}
}

double remainValue = 0;
if(accountSign==0){ //debet sign
	remainValue = sumDebit-sumCredit;
}else{
	remainValue = sumCredit-sumDebit; 
}

double tmpSaldoResult = lastGLBalance + remainValue;
String strCurrSaldo = FRMHandler.userFormatStringDecimal(tmpSaldoResult);
if(tmpSaldoResult<0){
	strCurrSaldo = "("+FRMHandler.userFormatStringDecimal(tmpSaldoResult).substring(1)+")";
}

/**
 * Declare variable uses in report depend on language selected
 */
String strSummary[][] = {
	{"Saldo Awal","Mutasi","Saldo Akhir","Debet","Kredit"}, 
	{"Previous Balance","Mutation","Current Balance","Debit","Credit"}  
};
	
String strTitle[][] = {
	{"No","Tanggal","Keterangan","Debet","Kredit","Total Mutasi","\n\nHalaman"}, 
	{"No","Date","Description","Debit","Credit","Total Mutation","\n\nPage"}
};

String strMsgErr[][] = {
	{"Tidak ada transaksi pada periode ini","Perkiraan ini tidak postable"},
	{"No transaction within selected period ...","This is non postable account ..."}
};

String reportTitleWithoutContact = "GENERAL LEDGER REPORT\nAccount Name : "+accountName+"\nPer "+strStartDate+" - "+strDueDate;
String reportTitleWithContact = "General Ledger "+accountName+"\nContact : "+contactName+"\nPer "+strStartDate+" - "+strDueDate;
String summaryTitle = "GENERAL LEDGER SUMMARY\nAccount Name : "+accountName+"\nPer "+strStartDate+" - "+strDueDate;
String digitSeparator = ".";
String decimalSeparator = ",";
int language = SESS_LANGUAGE;
boolean toUpperCase = true;
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	reportTitleWithoutContact = "LAPORAN BUKU BESAR\nPerkiraan : "+accountName+"\nPer "+strStartDate+" - "+strDueDate;
	reportTitleWithContact = "Buku Besar "+accountName+"\nKontak : "+contactName+"\nPer "+strStartDate+" - "+strDueDate;
	summaryTitle = "SUMMARY BUKU BESAR\nPerkiraan : "+accountName+"\nPer "+strStartDate+" - "+strDueDate;
}

Vector vectGeneralLedger = new Vector();
vectGeneralLedger.add(listGeneralLedger);
vectGeneralLedger.add(strStartDate);
vectGeneralLedger.add(strDueDate);
vectGeneralLedger.add(strNewDate);
vectGeneralLedger.add(new Double(sumDebit));
vectGeneralLedger.add(new Double(sumCredit));
vectGeneralLedger.add(strPrevSaldo);
vectGeneralLedger.add(strCurrSaldo);
vectGeneralLedger.add(accountName);
vectGeneralLedger.add(new Boolean(accountPosted));
vectGeneralLedger.add(reportTitleWithoutContact);
vectGeneralLedger.add(reportTitleWithContact);
vectGeneralLedger.add(digitSeparator);
vectGeneralLedger.add(decimalSeparator);
vectGeneralLedger.add(new Integer(language));
vectGeneralLedger.add(new Boolean(toUpperCase));
vectGeneralLedger.add(strSummary);
vectGeneralLedger.add(strTitle);
vectGeneralLedger.add(strMsgErr);
vectGeneralLedger.add(new Double(remainValue));
vectGeneralLedger.add(summaryTitle);
vectGeneralLedger.add(new Boolean(bPdfCompanyTitleUseImg));
vectGeneralLedger.add(sPdfCompanyTitle);
vectGeneralLedger.add(sPdfCompanyDetail);

if(contactId==0){
	if(session.getValue("GL_REPORT")!=null){
		session.removeValue("GL_REPORT");
	}
	session.putValue("GL_REPORT",vectGeneralLedger);
%>	
	<script language="JavaScript">
		document.location="<%=reportroot%>session.report.GeneralLedgerPdf?gettime=<%=System.currentTimeMillis()%>";
	</script>
<%
}else{
	if(session.getValue("GL_REPORT_CONTACT")!=null){
		session.removeValue("GL_REPORT_CONTACT");
	}
	session.putValue("GL_REPORT_CONTACT",vectGeneralLedger);
%>
	<script language="JavaScript">
		document.location="<%=reportroot%>session.report.GeneralLedgerContactPdf?gettime=<%=System.currentTimeMillis()%>";
	</script>
<%
}
%>