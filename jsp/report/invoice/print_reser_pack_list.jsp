<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!--package aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.*" %>

<!--package java-->
<%@ page import = "com.dimata.gui.jsp.*,
		   com.dimata.aiso.entity.report.ReservationPackageList,
		   com.dimata.aiso.session.invoice.SessInvoice,	
		   com.dimata.aiso.entity.search.SrcReservationPackageList,
		   com.dimata.util.NumberSpeller" %>
<%@ page import = "com.dimata.util.*" %>
<!--package qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>

<!-- JSP Block -->
<%! 
private static String[][] listHeader = {
	{"Periode","Nama","Keterangan","Batas Waktu UM","Uang Muka","Status Dokumen"},
	{"Period","Guest Name","Description","DP Time Limit","Down Payment","Doc Status"}
};

public String printListReservPack(String strList, int language){	
	String sResult = "";
	double dPrice = 0.0;
	Vector vRowx = new Vector(1,1);
	sResult = "<table width=\"100%\" class=\"report\" cellpadding=\"0\" cellspacing=\"1\">";
	sResult += "<tr>";
	sResult += "<td width=\"20%\" align=\"center\"><b>"+listHeader[language][0].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" align=\"center\"><b>"+listHeader[language][1].toUpperCase()+"</b></td>";
	sResult += "<td width=\"40%\" align=\"center\"><b>"+listHeader[language][2].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" align=\"center\"><b>"+listHeader[language][3].toUpperCase()+"</b></td>";
	sResult += "<td width=\"5%\" align=\"center\"><b>"+listHeader[language][4].toUpperCase()+"</b></td>";
	sResult += "<td width=\"5%\" align=\"center\"><b>"+listHeader[language][5].toUpperCase()+"</b></td>";
	
	sResult += "</tr>";
	if(strList != null && strList.length() > 0){
		sResult += strList;
	}	
	sResult += "</table>";
	return sResult; 
}
%>

<%
int iAccountGroup = FRMQueryString.requestInt(request,"accountchart_group"); 
String strHeader = FRMQueryString.requestString(request,"str_header");  

String[] strReportName = {"Daftar Reservasi Paket","Reservation Package List"};
String[] strPrintBy = {"Dicetak Oleh","Print By"};
String[] strPrintDate = {"   Dicetak Tanggal","   Print Date"};
SrcReservationPackageList srcResPackList = new SrcReservationPackageList();
String sListResPackage = "";
String sReport = "";
try{
	srcResPackList = (SrcReservationPackageList)session.getValue("PRINT_RPL");
	sListResPackage = (String)SessInvoice.listReservationPackage(0,0,srcResPackList,"","");
	sReport = printListReservPack(sListResPackage,SESS_LANGUAGE);
}catch(Exception e){}
%>
<!-- End of JSP Block -->
<html>
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Untitled Document</title>  
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="stylesheet" href="../../style/default.css" type="text/css">
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="1" cellpadding="1">
	<tr><td colspan="6" align="center"><b><%=strReportName[SESS_LANGUAGE].toUpperCase()%></b></td></tr>
	<tr><td colspan="6"><%=compName%></td></tr>
	<tr><td colspan="6"><%=compAddr%></td></tr>
	<tr><td colspan="6"><%=compPhone%></td></tr>
        <tr> 
          <td colspan="6" nowrap> 
            <div align="center"><%=sReport%></div>
          </td>
        </tr>
	<tr><td colspan="6"><%=strPrintBy[SESS_LANGUAGE]%> : <%=userFullName.toUpperCase()%>, <%=strPrintDate[SESS_LANGUAGE]%> : <%=Formater.formatDate(new Date(),"dd-MM-yyyy")%></td></tr>
      </table>
    </td>
  </tr>
</table>
</body>

