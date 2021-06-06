<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!--package aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.*" %>

<!--package java-->
<%@ page import = "com.dimata.gui.jsp.*,
		   java.util.StringTokenizer,
		   com.dimata.util.NumberSpeller" %>
<%@ page import = "com.dimata.util.*" %>
<!--package qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>

<!-- JSP Block -->
<%! 
public Vector printTicketHtml(Vector vTitleDetail, Vector vDataDetail){
	Vector vResult = new Vector(1,1);	
	String sResult = "";
	int qty = 0;
	double dPrice = 0.0;
	Vector vRowx = new Vector(1,1);
	sResult = "<table width=\"100%\" bgcolor=\"black\" border=\"0\" cellpadding=\"2\" cellspacing=\"2\">";
	sResult += "<tr>";
	if(vTitleDetail != null && vTitleDetail.size() > 0){
		sResult += "<td align=\"center\" bgcolor=\"white\"><b>"+vTitleDetail.get(2).toString().toUpperCase()+"</b></td>";
		sResult += "<td align=\"center\" bgcolor=\"white\"><b>"+vTitleDetail.get(3).toString().toUpperCase()+"</b></td>";
		sResult += "<td align=\"center\" bgcolor=\"white\"><b>"+vTitleDetail.get(4).toString().toUpperCase()+"</b></td>";
		sResult += "<td align=\"center\" bgcolor=\"white\"><b>"+vTitleDetail.get(5).toString().toUpperCase()+"</b></td>";
		sResult += "<td align=\"center\" bgcolor=\"white\"><b>"+vTitleDetail.get(6).toString().toUpperCase()+"</b></td>";
		sResult += "<td align=\"center\" bgcolor=\"white\"><b>"+vTitleDetail.get(8).toString().toUpperCase()+"</b></td>";
	}
	sResult += "</tr><tr>";
	if(vDataDetail != null && vDataDetail.size() > 0){
		for(int i = 0; i < vDataDetail.size(); i++){
			vRowx = (Vector)vDataDetail.get(i);
			String price = vRowx.get(4).toString();
			String strToken = "";
			StringTokenizer objToken = new StringTokenizer(price,",");
			while(objToken.hasMoreTokens()){
				strToken += objToken.nextToken();
			}

			if(strToken != null && strToken.length() > 0){
				dPrice += Double.parseDouble(strToken);
			}
			
			if(vRowx.get(3).toString() != null && vRowx.get(3).toString().length() > 0){
				qty += Integer.parseInt(vRowx.get(3).toString());
			}
			sResult += "<td nowrap bgcolor=\"white\">"+vRowx.get(0).toString()+"</td>";
			sResult += "<td nowrap bgcolor=\"white\">"+vRowx.get(1).toString()+"</td>";
			sResult += "<td align=\"center\" nowrap bgcolor=\"white\">"+vRowx.get(2).toString()+"</td>";
			sResult += "<td align=\"right\" nowrap bgcolor=\"white\">"+vRowx.get(3).toString()+"</td>";
			sResult += "<td align=\"right\" nowrap bgcolor=\"white\">"+vRowx.get(4).toString()+"</td>";
			sResult += "<td align=\"right\" nowrap bgcolor=\"white\">"+vRowx.get(5).toString()+"</td>";
			if(i == 0 || i == (vDataDetail.size() - 1)){
				sResult += "</tr>";
			}else{
				sResult += "</tr><tr>";
			}			
		}
		sResult += "<tr>";
		sResult += "<td colspan=\"3\" align=\"center\" nowrap bgcolor=\"white\"><b>TOTAL</b></td>";
		sResult += "<td align=\"right\" nowrap bgcolor=\"white\"><b>"+qty+"</b></td>";
		sResult += "<td align=\"right\" nowrap bgcolor=\"white\">&nbsp</td>";
		sResult += "<td align=\"right\" nowrap bgcolor=\"white\"><b>"+Formater.formatNumber(dPrice,"##,###")+"</b></td>";
		sResult += "</tr>";
	}	
	sResult += "</table>";
	vResult.add(sResult);	
	vResult.add(""+dPrice);
	return vResult; 
}
%>

<%
int iAccountGroup = FRMQueryString.requestInt(request,"accountchart_group"); 
String strHeader = FRMQueryString.requestString(request,"str_header");  

NumberSpeller numberSpeller = new NumberSpeller();
Vector vPrintHtml = new Vector(1,1);
Vector vListTitleDetail = new Vector(1,1);
Vector vMain = new Vector(1,1);
Vector vTitleMain = new Vector(1,1);
Vector vDataPrint = new Vector(1,1);
Vector vListTicket = new Vector(1,1);
String sListTicket = "";
String strSpellTotal = "";
double dTotal = 0.0;
int iTop = 0;
try{
	vPrintHtml = (Vector)session.getValue("PRINT_HTML");
	if(vPrintHtml != null && vPrintHtml.size() > 0){
		vListTitleDetail = (Vector)vPrintHtml.get(0);
		vMain = (Vector)vPrintHtml.get(1);
		vTitleMain = (Vector)vPrintHtml.get(2);
		vDataPrint = (Vector)vPrintHtml.get(3);	
	}

	iTop = Integer.parseInt(vMain.get(25).toString());
	vListTicket = (Vector)printTicketHtml(vListTitleDetail,vDataPrint);
	if(vListTicket != null && vListTicket.size() > 0){
		sListTicket = vListTicket.get(0).toString();
		dTotal = Double.parseDouble(vListTicket.get(1).toString());
	}

        strSpellTotal = numberSpeller.spellNumberToEng(dTotal);
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
<link rel="stylesheet" href="../style/main.css" type="text/css">
<link rel="stylesheet" href="../style/default.css" type="text/css">
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="1" cellpadding="1">
	<tr><td colspan="5">&nbsp</td><td><b>INVOICE</b></td></tr>
	<tr>
		<td colspan="6"><%=vMain.get(0).toString()%></td>
	</tr>
	<tr><td colspan="6"><%=vMain.get(1).toString()%></td></tr>
	<tr><td colspan="6"><%=vMain.get(2).toString()%></td></tr>
	<tr><td colspan="6">&nbsp</td></tr>
	<tr>
		<td width="15%"><%=vMain.get(3).toString()%></td>
		<td width="1%">:</td>
		<td width="48%"><%=vMain.get(4).toString()%></td>
		<td width="15%"><%=vTitleMain.get(2).toString()%></td>
		<td width="1%">:</td>
		<td width="10%"><%=vMain.get(6).toString()%></td>
	</tr>
	<tr>
		<td width="15%"><%=vTitleMain.get(3).toString()%></td>
		<td width="1%">:</td>
		<td width="48%"><%=vMain.get(5).toString()%></td>
		<td width="15%">Phone</td>
		<td width="1%">:</td>
		<td width="10%"><%=vMain.get(15).toString()%></td>
	</tr>
	<tr>
		<td width="15%"><%=vMain.get(9).toString()%></td>
		<td width="1%">:</td>
		<%if(iTop > 0){%>
			<td width="48%"><%=vMain.get(10).toString()%>, <%=vMain.get(11).toString()%> : <%=vMain.get(7).toString()%></td>
		<%}else{%>
			<td width="48%">Cash</td>
		<%}%>
		<td width="15%"><%=vMain.get(12).toString()%></td>
		<td width="1%">,</td>
		<td width="10%"><%=vMain.get(8).toString()%></td>
	</tr>
        <tr> 
          <td colspan="6" nowrap> 
            <div align="center"><%=sListTicket%></div>
          </td>
        </tr>
	<tr><td colspan="6"><b>Spelled : </b><%=strSpellTotal%> Rupiah(s)</td></tr>
	<tr><td colspan="6">&nbsp</td></tr>
	<tr><td colspan="6">&nbsp</td></tr>
	<tr>
		<td colspan="6" align="right">
			<table>
				<tr>
					<td width="30%">Approved By :</td>
					<td width="5%">&nbsp</td>
					<td width="30%">Prepared By :</td>
					<td width="5%">&nbsp</td>
					<td width="30%">Order / Rec By :</td>
				</tr>
				<tr><td colspan="6">&nbsp</td></tr>
				<tr><td colspan="6">&nbsp</td></tr>
				<tr><td colspan="6">&nbsp</td></tr>
				<tr>
					<td width="30%">_______________</td>
					<td width="5%">&nbsp</td>
					<td width="30%">(<%=vMain.get(27).toString()%>)</td>
					<td width="5%">&nbsp</td>
					<td width="30%">________________</td>
				</tr>
			</table>
		</td>
	</tr>
      </table>
    </td>
  </tr>
</table>
</body>

