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

<%!
public String drawBalanceSheetReport(Vector vectBalanceSheet){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat("Acc Name","40%","left","left");
	ctrlist.dataFormat("Last Debet","15%","right","right");	
	ctrlist.dataFormat("Last Credit","15%","right","right");
	ctrlist.dataFormat("Curr Debet","15%","right","right");
	ctrlist.dataFormat("Curr Credit","15%","right","right");	

	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.reset();	

	double lastDebet = 0;
	double lastCredit = 0;
	double currDebet = 0;
	double currCredit = 0;	
	String space = "";
    Vector rowx = new Vector(1,1);	
	for(int i=0; i<vectBalanceSheet.size(); i++) {
	   Vector currResult = (Vector)vectBalanceSheet.get(i);
	   Perkiraan currAcc = (Perkiraan)currResult.get(0);
	   BalanceSheet currSa = (BalanceSheet )currResult.get(1);
	   
	   if(currAcc.getLevel()==1){
		   lastDebet = lastDebet + currSa.getDebetBefore();
		   lastCredit = lastCredit + currSa.getCreditBefore();
		   currDebet = currDebet + currSa.getDebetSelected();
		   currCredit = currCredit + currSa.getCreditSelected();	   	   	   
	   }
	   
	   switch(currAcc.getLevel()){
		 case 1 : space = "&nbsp;"; break;
		 case 2 : space = "&nbsp;&nbsp;"; break;
		 case 3 : space = "&nbsp;&nbsp;&nbsp;"; break;
		 case 4 : space = "&nbsp;&nbsp;&nbsp;&nbsp;"; break;
		 case 5 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
		 case 6 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
	   }	   

	   rowx = new Vector(1,1);	
	   rowx.add(space+currAcc.getNama());
	   rowx.add(Formater.formatNumber(currSa.getDebetBefore(),"#,###.00"));			
	   rowx.add(Formater.formatNumber(currSa.getCreditBefore(),"#,###.00"));				   	   
	   rowx.add(Formater.formatNumber(currSa.getDebetSelected(),"#,###.00"));			
	   rowx.add(Formater.formatNumber(currSa.getCreditSelected(),"#,###.00"));				   	   
	   lstData.add(rowx);
	}
	
    rowx = new Vector(1,1);	
    rowx.add("Total Balance Sheet");
    rowx.add(Formater.formatNumber(lastDebet,"#,###.00"));			
    rowx.add(Formater.formatNumber(lastCredit,"#,###.00"));				   	   
    rowx.add(Formater.formatNumber(currDebet,"#,###.00"));			
    rowx.add(Formater.formatNumber(currCredit,"#,###.00"));				   	   
    lstData.add(rowx);	
	
	return ctrlist.drawMe();
}
%>

<html>
<head>
<title>Balance Sheet Loading ...</title>
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

String strCwId = PstAccountLink.getLinkAccountStr(CtrlAccountLink.TYPE_CW);
Vector listBalanceSheet = new Vector(1,1);
if(reportType==SessBS.REPORT_PERIODIC){
	listBalanceSheet = SessBalanceSheet.listBalanceSheetReport(null,null,null,null,lastPeriodId,periodId,currency,selectedLevel,rate);
	System.out.println("periodic");	
}else{
	listBalanceSheet = SessBalanceSheet.listBalanceSheetReport(lastStartDate,lastDueDate,startDate,dueDate,0,0,currency,selectedLevel,rate);
	System.out.println("Annuals");	
}

/**
 * Declare variable uses in report depend on language selected
 */
String strType = "Period";
String reportTitle[] = {
	"Laporan Neraca ","Balance Sheet Report " 
};
String digitSeparator = ".";
String decimalSeparator = ",";
int language = SESS_LANGUAGE;
boolean toUpperCase = true;
String strTitle[][] = {
	{"Nama Perkiraan","Saldo","Lalu","Sekarang","Halaman","Total","Total Aktiva","Total Hutang dan Modal",
	"Change Withdwaral","Total Change Withdrawal","Total Pasiva"},   
	{"Account Name","Balance","Last","Current","Halaman","Total","Total Activa","Total Liability and Equity",
	"Change Withdwaral","Total Change Withdrawal","Total Pasiva"}    
};
int accNameWidth = 60;
int previousWidth = 20;
int currentWidth = 20;

Vector vectBalanceSheet = new Vector(); 
vectBalanceSheet.add(listBalanceSheet);
vectBalanceSheet.add(new Integer(selectedLevel));
vectBalanceSheet.add(new Integer(currency));
vectBalanceSheet.add(strCwId);

vectBalanceSheet.add(reportTitle[language]+timeReport);
vectBalanceSheet.add(digitSeparator);
vectBalanceSheet.add(decimalSeparator);
vectBalanceSheet.add(new Integer(language)); 
vectBalanceSheet.add(new Boolean(toUpperCase));
vectBalanceSheet.add(strTitle);
vectBalanceSheet.add(new Integer(accNameWidth));
vectBalanceSheet.add(new Integer(previousWidth));
vectBalanceSheet.add(new Integer(currentWidth));
vectBalanceSheet.add(strType);
vectBalanceSheet.add(new Boolean(bPdfCompanyTitleUseImg));
vectBalanceSheet.add(sPdfCompanyTitle);
vectBalanceSheet.add(sPdfCompanyDetail);

if(session.getValue("BS_REPORT")!=null){
	session.removeValue("BS_REPORT");
}
session.putValue("BS_REPORT",vectBalanceSheet);
%>
<script language="JavaScript">
	document.location="<%=reportroot%>session.report.BalanceSheetPdf";
</script>
