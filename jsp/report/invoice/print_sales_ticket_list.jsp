<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!--package aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.*" %>

<!--package java-->
<%@ page import = "com.dimata.gui.jsp.*,
		   com.dimata.aiso.entity.report.ReservationPackageList,
		   com.dimata.aiso.session.invoice.SessInvoice,	
		   com.dimata.aiso.entity.search.SrcSalesTicketList,
		   com.dimata.util.NumberSpeller" %>
<%@ page import = "com.dimata.util.*" %>
<!--package qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>

<!-- JSP Block -->
<%! 
private static String[][] listHeader = {
	{"Tanggal","Keterangan","Tiket","Penumpang","Debet","Kredit","Saldo"},
	{"Date","Description","Ticket Info","Passanger Name","Debit","Credit","Balance"}
};

public String printTicketList(String strList, int language){	
	String sResult = "";
	double dPrice = 0.0;
	Vector vRowx = new Vector(1,1);
	sResult = "<table width=\"100%\" class=\"report\" cellpadding=\"1\" cellspacing=\"1\">";
	sResult += "<tr>";
	sResult += "<td width=\"10%\" align=\"center\"><b>"+listHeader[language][0].toUpperCase()+"</b></td>";
	sResult += "<td width=\"20%\" align=\"center\"><b>"+listHeader[language][1].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" align=\"center\"><b>"+listHeader[language][2].toUpperCase()+"</b></td>";
	sResult += "<td width=\"10%\" align=\"center\"><b>"+listHeader[language][3].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" align=\"center\"><b>"+listHeader[language][4].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" align=\"center\"><b>"+listHeader[language][5].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" align=\"center\"><b>"+listHeader[language][6].toUpperCase()+"</b></td>";
	
	sResult += "</tr>";
	if(strList != null && strList.length() > 0){
		sResult += strList;
	}	
	sResult += "</table>";
	//System.out.println("Exception 1 ");
	return sResult; 
}
%>

<%
int iAccountGroup = FRMQueryString.requestInt(request,"accountchart_group"); 
String strHeader = FRMQueryString.requestString(request,"str_header");  

String[] strReportName = {"Daftar Penjualan Ticket","Ticket Sales List"};
String[] strPrintBy = {"Dicetak Oleh","Print By"};
String[] strPrintDate = {"   Dicetak Tanggal","   Print Date"};
SrcSalesTicketList srcSalesTicketList = new SrcSalesTicketList();
Vector vTicketList = new Vector();
String sTicketSalesList = "";
String sReport = "";
try{
	srcSalesTicketList = (SrcSalesTicketList)session.getValue("PRINT_STL");
	vTicketList = (Vector)SessInvoice.listTicketSales(0,0,srcSalesTicketList,"","");
	sTicketSalesList = vTicketList.get(0).toString();
	sReport = printTicketList(sTicketSalesList,SESS_LANGUAGE);
}catch(Exception e){System.out.println("Exception on generate list ::: "+e.toString());}
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

