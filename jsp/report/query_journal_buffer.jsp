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
<title>Query Journal Loading ...</title>
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
String formatNumber = "#,###";

int dateType = FRMQueryString.requestInt(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_DATE_TYPE]);
Date startDate = null;
Date dueDate = null;
if(dateType==2){
	int startYr = FRMQueryString.requestInt(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_START_DATE] + "_yr");
	int startMn = FRMQueryString.requestInt(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_START_DATE] + "_mn");
	int startDy = FRMQueryString.requestInt(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_START_DATE] + "_dy");
	int dueYr = FRMQueryString.requestInt(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_END_DATE] + "_yr");
	int dueMn = FRMQueryString.requestInt(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_END_DATE] + "_mn");
	int dueDy = FRMQueryString.requestInt(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_END_DATE] + "_dy");
	startDate = new Date(startYr-1900, startMn-1, startDy);
	dueDate = new Date(dueYr-1900, dueMn-1, dueDy);
}
String invoiceNo = FRMQueryString.requestString(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_INVOICE_NO]);
String voucherNo = FRMQueryString.requestString(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_VOUCHER]);
String contactName = FRMQueryString.requestString(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_CONTACT]);
long operatorId = FRMQueryString.requestLong(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_OPERATOR_ID]);
int currency = FRMQueryString.requestInt(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_CURRENCY]);
int orderBy = FRMQueryString.requestInt(request,SessQueryJournal.fieldNames[SessQueryJournal.QUERY_ORDER_BY]);

// create srcJurnalUmum object
SrcJurnalUmum srcJurnalUmum = new SrcJurnalUmum();

srcJurnalUmum.setDateStatus(dateType);
String strStartDate = "";
String strDueDate = "";
if(dateType==0){
	Date currStartDate = null;
	Date currDueDate = null;
	Vector currDate = SessPeriode.getCurrPeriod();
	if(currDate!=null && currDate.size()>0){
	   Periode per = (Periode)currDate.get(0);
	   currStartDate = per.getTglAwal();
	   currDueDate = per.getTglAkhir();
	   
	   strStartDate = Formater.formatDate(currStartDate,SESS_LANGUAGE,"MMMM dd, yyyy");
	   strDueDate = Formater.formatDate(currDueDate,SESS_LANGUAGE,"MMMM dd, yyyy");	   
	   if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
		   strStartDate = Formater.formatDate(currStartDate,SESS_LANGUAGE,"dd MMMM yyyy");
		   strDueDate = Formater.formatDate(currDueDate,SESS_LANGUAGE,"dd MMMM yyyy");	   
	   }	   
	}
}
if(dateType==2){
	srcJurnalUmum.setStartDate(startDate);
	srcJurnalUmum.setEndDate(dueDate);

    strStartDate = Formater.formatDate(startDate,SESS_LANGUAGE,"MMMM dd, yyyy");
    strDueDate = Formater.formatDate(dueDate,SESS_LANGUAGE,"MMMM dd, yyyy");	   
    if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	   strStartDate = Formater.formatDate(startDate,SESS_LANGUAGE,"dd MMMM yyyy");
	   strDueDate = Formater.formatDate(dueDate,SESS_LANGUAGE,"dd MMMM yyyy");	   
    }	   	
}
srcJurnalUmum.setInvoice(invoiceNo);
srcJurnalUmum.setVoucher(voucherNo);
srcJurnalUmum.setContact(contactName);
srcJurnalUmum.setOperatorId(operatorId);
srcJurnalUmum.setCurrency(currency);
srcJurnalUmum.setOrderBy(orderBy);


/**
 * Declare variable uses in report depend on language selected
 */
String reportTitle = "JOURNAL LIST Per "+strStartDate+" to "+strDueDate;
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	reportTitle = "DAFTAR JURNAL Per "+strStartDate+" to "+strDueDate;
}

int language = SESS_LANGUAGE;
boolean toUpperCase = true;
boolean useTotal = true;
boolean useHeader = false;
String digitSeparator = ".";
String decimalSeparator = ",";
String[][] titleTexts = {
	{"Voucher","Kontak","Transaksi","Operator","Keterangan", "Nomor","Nama Perkiraan","Debet","Kredit","Sub Total","Total"},
	{"Voucher","Contact","Transaction","Operator","Description","Number","Account Name","Debet","Credit","Sub Total","Total"}
};


Vector vectJurnalAmount = SessQueryJournal.listJurnalUmum(srcJurnalUmum);

Vector vectQueryJournal = new Vector();
vectQueryJournal.add(vectJurnalAmount);
vectQueryJournal.add(strStartDate);
vectQueryJournal.add(strDueDate);
vectQueryJournal.add(digitSeparator);
vectQueryJournal.add(decimalSeparator);
vectQueryJournal.add(titleTexts);
vectQueryJournal.add(new Integer(language));
vectQueryJournal.add(new Boolean(toUpperCase));
vectQueryJournal.add(new Boolean(useTotal));
vectQueryJournal.add(reportTitle);
vectQueryJournal.add(new Boolean(useHeader));
vectQueryJournal.add(new Boolean(bPdfCompanyTitleUseImg));
vectQueryJournal.add(sPdfCompanyTitle);
vectQueryJournal.add(sPdfCompanyDetail);

if(session.getValue("QJ_REPORT")!=null){
	session.removeValue("QJ_REPORT");
}
session.putValue("QJ_REPORT",vectQueryJournal);
%>

<script language="JavaScript">
	document.location="<%=reportroot%>session.report.QueryJournalPdf?gettime=<%=System.currentTimeMillis()%>";
</script>

