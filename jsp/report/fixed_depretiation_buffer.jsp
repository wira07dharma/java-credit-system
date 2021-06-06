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
<%// page import="com.dimata.aiso.entity.system.*" %>

<!--import java-->
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>

<!--import qdep-->
<%@ page import="com.dimata.util.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ page import="com.dimata.qdep.form.*" %> 
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_REPORT, AppObjInfo.G2_REPORT_GNR_LEDGER, AppObjInfo.OBJ_REPORT_GNR_LEDGER_PRIV); %>
<%@ include file = "../main/checkuser.jsp" %>

<html>
<head>
<title>Depresiation Loading ...</title>
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
String formatMonth  = "MMMM yyyy";
String formatDate  = "MMMM dd, yyyy";

//int perInterval = Integer.parseInt(PstSystemProperty.getValueByName("PERIOD_INTERVAL"));
String reportText = FRMQueryString.requestString(request,"DEP_TEXT"); 
String groupText = FRMQueryString.requestString(request,"GROUP_TEXT"); 
int reportType = FRMQueryString.requestInt(request,SessFixedAsset.deFieldNames[SessFixedAsset.FLD_TYPE]);
int depType = FRMQueryString.requestInt(request,SessFixedAsset.deFieldNames[SessFixedAsset.FLD_DEP_TYPE]);
long accountId = FRMQueryString.requestLong(request,SessFixedAsset.deFieldNames[SessFixedAsset.FLD_ACC_NAME]);
long assetGroup = FRMQueryString.requestLong(request,SessFixedAsset.deFieldNames[SessFixedAsset.FLD_ASSET_GROUP]);
long assetId = FRMQueryString.requestLong(request,SessFixedAsset.deFieldNames[SessFixedAsset.FLD_ASSET_NO]);
long periodId = FRMQueryString.requestLong(request,SessFixedAsset.deFieldNames[SessFixedAsset.FLD_PERIODE]);
int perInterval = SessPeriode.getPeriodInterval(periodId);

String strType = "";
Date selectedDate = null;
if(reportType==SessFixedAsset.REPORT_MONTLY)
{
	try
	{
		int selectedYr = FRMQueryString.requestInt(request,SessFixedAsset.deFieldNames[SessFixedAsset.FLD_MONTH] + "_yr");
		int selectedMn = FRMQueryString.requestInt(request,SessFixedAsset.deFieldNames[SessFixedAsset.FLD_MONTH] + "_mn");

		Date newDate = new Date(selectedYr,selectedMn-1,1);
		Calendar newCalendar = Calendar.getInstance();
		newCalendar.setTime(newDate);
		selectedDate = new Date(selectedYr-1900, selectedMn-1, newCalendar.getActualMaximum(newCalendar.DAY_OF_MONTH));
	}
	catch(Exception e) 
	{
		System.out.println("Exc when process REPORT MONTHLY : " + e.toString());
	}
	strType = Formater.formatDate(selectedDate,formatMonth);
}

if(reportType==SessFixedAsset.REPORT_PERIODIC)
{
	String whereClause = PstPeriode.fieldNames[PstPeriode.FLD_IDPERIODE] + " = " + periodId;
	Vector listPeriode = PstPeriode.list(0,0,whereClause,"");
	if(listPeriode!=null && listPeriode.size()>0)
	{
	  Periode per = (Periode)listPeriode.get(0);
	  strType = per.getNama(); 
	}
}

Vector vectDepretiation = SessFixedAsset.listDepretiation(SESS_LANGUAGE,accountId,assetGroup,assetId,depType);

/**
 * Declare variable uses in report depend on language selected
 */
String digitSeparator = ",";
String decimalSeparator = ".";
if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT)
{
	digitSeparator = ".";
	decimalSeparator = ",";
}

String deprecType[][] = 
{
	{"BULANAN","PERIODIC"},
	{"MONTHLY","PERIODIC"}
};

String reportTitle = deprecType[SESS_LANGUAGE][reportType]+" "+reportText.toUpperCase()+" REPORT\n" + strType;
if(groupText!="" && groupText.length()>0)
{
   reportTitle = reportTitle + "\nFIXED ASSET GROUP : "+groupText;
}

if(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT)
{
	reportTitle = "LAPORAN "+reportText.toUpperCase()+" "+deprecType[SESS_LANGUAGE][reportType]+"\n" + strType;
	if(groupText!="" && groupText.length()>0)
	{
	   reportTitle = reportTitle + "\nKELOMPOK AKTIVCA TETAP : "+groupText;
	}
}

String strTitle[][] = 
{
	{
	"NO","NAMA ASSET","NOMOR ASSET","TANGGAL PEROLEHAN","NILAI PEROLEHAN","MASA(TAHUN)","NILAI RESIDU",
	"NILAI BUKU","SEBELUMNYA","SEKARANG","TOTAL","SUB TOTAL","LAST SUB TOTAL","GRAND TOTAL","Tidak penyusutan untuk perkiraan ini"
	},

	{
	"NO","ASSET NAME","ASSET NUMBER","DATE OF OWNERSHIP","COST OF OWNERSHIP","USABLE(YEAR)","RESIDUE VALUE",
	"BOOK VALUE","LAST","NOW","TOTAL","SUB TOTAL","LAST SUB TOTAL","GRAND TOTAL","No Depreciation for this account"
	}
};


Vector listDepresiation = new Vector();
listDepresiation.add(vectDepretiation);
listDepresiation.add(new Integer(perInterval));
listDepresiation.add(new Integer(reportType));
listDepresiation.add(new Long(accountId)); 
listDepresiation.add(new Long(periodId)); 
listDepresiation.add("PER "+strType.toUpperCase());
listDepresiation.add(selectedDate);
listDepresiation.add(reportText);
listDepresiation.add(groupText.toUpperCase());
listDepresiation.add(strTitle);
listDepresiation.add(reportTitle);
listDepresiation.add(digitSeparator);
listDepresiation.add(decimalSeparator);
listDepresiation.add(new Integer(SESS_LANGUAGE));
listDepresiation.add(new Boolean(bPdfCompanyTitleUseImg));
listDepresiation.add(sPdfCompanyTitle);
listDepresiation.add(sPdfCompanyDetail);    

if(session.getValue("FIXED_REPORT")!=null)
{
	session.removeValue("FIXED_REPORT");
}
session.putValue("FIXED_REPORT",listDepresiation);
%>

<script language="JavaScript">
	document.location="<%=reportroot%>session.report.FixedAssetPdf?gettime=<%=System.currentTimeMillis()%>"; 
</script>

