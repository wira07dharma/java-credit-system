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
<!--import common-->
<%@ page import="com.dimata.common.entity.contact.*" %>
<%@ page import="com.dimata.common.session.contact.*" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_GNR_LEDGER, AppObjInfo.OBJ_REPORT_GNR_LEDGER_PRIV); %>
<%@ include file = "../main/checkuser.jsp" %>

<html>
<head>
<title>Receivable Loading ...</title>
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
String currText[] = {"(IDR)","(US$)"};
String formatDate  = "MMMM dd, yyyy";
String formatNumber = "#,###";

String strCategory = FRMQueryString.requestString(request,"CLS_CAT");
int reportType = FRMQueryString.requestInt(request,SessReceivable.recFieldNames[SessReceivable.FLD_TYPE]);
long classId = FRMQueryString.requestLong(request,SessReceivable.recFieldNames[SessReceivable.FLD_CONTACT_CLASS]);
long contactId = FRMQueryString.requestLong(request,SessReceivable.recFieldNames[SessReceivable.FLD_CONTACT_NAME]);
int currency = FRMQueryString.requestInt(request,SessReceivable.recFieldNames[SessReceivable.FLD_CURRENCY]);
int datetype = FRMQueryString.requestInt(request,SessReceivable.recFieldNames[SessReceivable.FLD_DATE_TYPE]);
int startYr = FRMQueryString.requestInt(request,SessReceivable.recFieldNames[SessReceivable.FLD_START_DATE] + "_yr");
int startMn = FRMQueryString.requestInt(request,SessReceivable.recFieldNames[SessReceivable.FLD_START_DATE] + "_mn");
int startDy = FRMQueryString.requestInt(request,SessReceivable.recFieldNames[SessReceivable.FLD_START_DATE] + "_dy");
int dueYr = FRMQueryString.requestInt(request,SessReceivable.recFieldNames[SessReceivable.FLD_END_DATE] + "_yr");
int dueMn = FRMQueryString.requestInt(request,SessReceivable.recFieldNames[SessReceivable.FLD_END_DATE] + "_mn");
int dueDy = FRMQueryString.requestInt(request,SessReceivable.recFieldNames[SessReceivable.FLD_END_DATE] + "_dy");
int ageingType = FRMQueryString.requestInt(request,SessReceivable.recFieldNames[SessReceivable.FLD_AGEING]);

long periodId = FRMQueryString.requestLong(request,SessReceivable.recFieldNames[SessReceivable.FLD_PERIODE]);
Date lastDatePeriode = new Date();
Periode currPeriode = new Periode();
String strPeriodeName = "";
try{
	currPeriode = PstPeriode.fetchExc(periodId);
	strPeriodeName = currPeriode.getNama().toUpperCase();
}catch(Exception e){
	System.out.println("Err fetch Periode");
}

Date startDate = null;
Date dueDate = null;

switch(datetype){
    case 0 : Vector currDate = SessPeriode.getCurrPeriod();
             if(currDate.size()==1){
               Periode per = (Periode) currDate.get(0);
               startDate = per.getTglAwal();
               dueDate = per.getTglAkhir();
             }    
			 break;
    case 2 : startDate = new Date(startYr-1900, startMn-1, startDy); 
             dueDate = new Date(dueYr-1900, dueMn-1, dueDy);
			 break;
}
String strDueDuration = "ALL DATE";
if(startDate!=null && dueDate!=null){
	strDueDuration = Formater.formatDate(startDate,SESS_LANGUAGE,"MMMM dd, yyyy").toUpperCase() + " TO " + Formater.formatDate(dueDate,SESS_LANGUAGE,"MMMM dd, yyyy").toUpperCase();
}
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	strDueDuration = "SEMUA TANGGAL";
	if(startDate!=null && dueDate!=null){
		strDueDuration = Formater.formatDate(startDate,SESS_LANGUAGE,"dd MMMM yyyy").toUpperCase() + " TO " + Formater.formatDate(dueDate,SESS_LANGUAGE,"dd MMMM yyyy").toUpperCase();
	}	
}

String currencyText = currText[currency];
String whereClause = PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID] + " = " + contactId; 
String contactName = "";
String strToDay = Formater.formatDate(new Date(),SESS_LANGUAGE,"MMMM dd, yyyy");
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	strToDay = Formater.formatDate(new Date(),SESS_LANGUAGE,"dd MMMM yyyy");
}

Vector listContact = PstContactList.list(0,0,whereClause,"");
if(listContact!=null && listContact.size()>0){
   ContactList cnt = (ContactList) listContact.get(0);
   if(cnt.getContactType()!=PstContactList.OWN_COMPANY && cnt.getContactType()==PstContactList.EXT_COMPANY){
	contactName = cnt.getCompName();   
   }else{    
	contactName = cnt.getPersonName()+" "+cnt.getPersonLastname();
   }
}

Vector vectReceivable = new Vector(1,1);
switch(reportType){
	case SessReceivable.BY_CONTACT : vectReceivable = SessReceivable.listRecCommon(classId,contactId,currency);
									 break;
	case SessReceivable.BY_DUEDATE : vectReceivable = SessReceivable.listRecCommon(classId,startDate,dueDate,currency);
									 break;
	case SessReceivable.BY_AGEING  : vectReceivable = SessReceivable.listRecCommon(classId,contactId,ageingType,SessReceivable.REPORT_TIMES,currency);
									 switch(ageingType){
									 	case SessReceivable.AGE_WEEKLY : strDueDuration = Formater.formatDate(new Date(),formatDate).toUpperCase(); break;
										case SessReceivable.AGE_MONTHLY : strDueDuration = Formater.formatDate(new Date(),"MMMM yyyy").toUpperCase(); break;
										case SessReceivable.AGE_YEARLY : strDueDuration = Formater.formatDate(new Date(),"yyyy").toUpperCase(); break;
									 }
									 break;
	case SessReceivable.BY_PERIOD  : vectReceivable = SessReceivable.listReceivablePeriod(classId,currPeriode,currency);
									 break;								 
}

/**
 * Declare variable uses in report depend on language selected
 */
String digitSeparator = ",";
String decimalSeparator = ".";
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	digitSeparator = ".";
	decimalSeparator = ",";
}

String reportTitleContact = "RECEIVABLE REPORT "+currencyText+"\nPER "+strToDay.toUpperCase()+"\nCATEGORY : "+strCategory;
String reportTitleDueDate = "RECEIVABLE REPORT "+currencyText+"\nPER "+strDueDuration+"\nCATEGORY : "+strCategory;
String reportTitleAgeing = (SessReceivable.ageingFieldNames[SESS_LANGUAGE][ageingType]).toUpperCase()+" AGEING RECEIVABLE"+currencyText+"\nPER "+strDueDuration+"\nCATEGORY : "+strCategory;
String reportTitlePeriod = "RECEIVABLE REPORT"+currencyText+"\nPER "+strPeriodeName+"\nCATEGORY : "+strCategory;
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){
	reportTitleContact = "LAPORAN PIUTANG "+currencyText+"\nPER "+strToDay.toUpperCase()+"\nKATEGORI : "+strCategory;
	reportTitleDueDate = "LAPORAN PIUTANG "+currencyText+"\nPER "+strDueDuration+"\nKATEGORI : "+strCategory;
	reportTitleAgeing = "LAPORAN UMUR PIUTANG "+(SessReceivable.ageingFieldNames[SESS_LANGUAGE][ageingType]).toUpperCase()+" "+currencyText+"\nPER "+strDueDuration+"\nKATEGORI : "+strCategory;
	reportTitlePeriod = "LAPORAN PIUTANG "+currencyText+"\nPER "+strPeriodeName+"\nKATEGORI : "+strCategory;
}
String strTitleContact[][] = {
	{"NO","NOMOR BILL","NAMA KONTAK","TANGGAL","SALDO","TRANS","AKHIR","PIU","BAYAR","PIU - BAYAR","SALDO",
	"TOTAL","Tidak ada hasil untuk kategori ini"},

	{"NO","BILL NUMBER","CONTACT NAME","DATE","BALANCE","TRANS.","DUE","REC","PAID","REC - PAID","BALANCE",
	"GRAND TOTAL","No Result for this category"}
};

String strTitleDueDate[][] = {
	{"NO","NOMOR BILL","NAMA KONTAK","TANGGAL TRANS","JATUH TEMPO","SALDO",
	"SUB TOTAL","SALDO AKHIR","TOTAL","Tidak ada hasil untuk tanggal jatuh tempo ini"},

	{"NO","BILL NUMBER","CONTACT NAME","TRANS DATE","DUE DATE","BALANCE",
	"SUB TOTAL","LAST TOTAL","GRAND TOTAL","No Result for this due date"}
};

String strTitleAgeing[][] = {
	{"NO","NAMA KONTAK","LEWAT","SEKARANG","SATU","DUA","TIGA","LEBIH","SALDO","SUB TOTAL","SALDO AKHIR",
	"SALDO","Tidak ada hasil untuk kategori ini"},

	{"NO","CONTACT NAME","LEWAT","CURRENT","ONE","TWO","THREE","OVERDUE","BALANCE","SUB TOTAL","LAST BALANCE",
	"GRAND TOTAL","No Result for this category"}
};

String strTitlePeriod[][] = {
	{"NO","NO BILL","NAMA KONTAK","SALDO AWAL","MUTASI","SALDO AKHIR","DEBET","KREDIT",
	"TOTAL SALDO","Tidak ada hasil untuk kategori ini"},

	{"NO","NO BILL","CONTACT NAME","PREV BALANCE","MUTATION","LAST BALANCE","DEBET","CREDIT",
	"GRAND TOTAL","No Result for this category"}
};

Vector listReceivable = new Vector();
listReceivable.add(vectReceivable);
listReceivable.add(new Integer(reportType)); 
listReceivable.add(new Integer(currency)); 
listReceivable.add(currencyText); 
listReceivable.add(contactName);
listReceivable.add(strToDay); 
listReceivable.add(strDueDuration); 
listReceivable.add(new Integer(ageingType)); 
listReceivable.add(new Integer(SESS_LANGUAGE)); 
listReceivable.add(strCategory.toUpperCase()); 
listReceivable.add(strPeriodeName);
listReceivable.add(strTitleContact);
listReceivable.add(strTitleDueDate);
listReceivable.add(strTitleAgeing);
listReceivable.add(strTitlePeriod);
listReceivable.add(reportTitleContact);
listReceivable.add(reportTitleDueDate);
listReceivable.add(reportTitleAgeing);
listReceivable.add(reportTitlePeriod);
listReceivable.add(digitSeparator);
listReceivable.add(decimalSeparator);
listReceivable.add(new Boolean(bPdfCompanyTitleUseImg));
listReceivable.add(sPdfCompanyTitle);
listReceivable.add(sPdfCompanyDetail);

if(session.getValue("REC_REPORT")!=null){
	session.removeValue("REC_REPORT");
}
session.putValue("REC_REPORT",listReceivable);
%>

<script language="JavaScript">
	document.location="<%=reportroot%>session.report.ReceivablePdf?gettime=<%=System.currentTimeMillis()%>";
</script>

