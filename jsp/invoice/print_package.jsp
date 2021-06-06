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
	double dPrice = 0.0;
	Vector vRowx = new Vector(1,1);
	sResult = "<table width=\"100%\" class=\"report\">";
	sResult += "<tr>";
	if(vTitleDetail != null && vTitleDetail.size() > 0){
		sResult += "<td align=\"center\"><b>"+vTitleDetail.get(3).toString().toUpperCase()+"</b></td>";
		sResult += "<td align=\"center\"><b>"+vTitleDetail.get(8).toString().toUpperCase()+"</b></td>";
	}
	sResult += "</tr><tr>";
	if(vDataDetail != null && vDataDetail.size() > 0){
		for(int i = 0; i < vDataDetail.size(); i++){
			vRowx = (Vector)vDataDetail.get(i);
			String price = vRowx.get(1).toString();
			String strToken = "";
			StringTokenizer objToken = new StringTokenizer(price,",");
			while(objToken.hasMoreTokens()){
				strToken += objToken.nextToken();
			}

			if(strToken != null && strToken.length() > 0){
				dPrice += Double.parseDouble(strToken);
			}
			
			sResult += "<td width=\"80%\">"+vRowx.get(0).toString()+"</td>";
			sResult += "<td width=\"20%\" align=\"right\" nowrap>"+vRowx.get(1).toString()+"</td>";
			if(i == 0 || i == (vDataDetail.size() - 1)){
				sResult += "</tr>";
			}else{
				sResult += "</tr><tr>";
			}			
		}
		sResult += "<tr>";
		sResult += "<td width=\"80%\" align=\"center\" nowrap><b>TOTAL</b></td>";
		sResult += "<td width=\"20%\" align=\"right\" nowrap><b>"+Formater.formatNumber(dPrice,"##,###")+"</b></td>";
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
double dDeposit = 0.0;
double dBalance = 0.0;
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
	
	dDeposit = Double.parseDouble(vMain.get(26).toString());
	dBalance = dTotal - dDeposit;
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
	<tr><td colspan="7" align="center"><%=vMain.get(0).toString()%></td></tr>
	<tr><td colspan="7" align="center"><%=vMain.get(1).toString()%></td></tr>
	<tr><td colspan="7" align="center"><%=vMain.get(2).toString()%></td></tr>
	<tr><td colspan="7" >========================================================================================================</td></tr>
	
	<tr><td colspan="7">&nbsp</td></tr>
	<tr>
		<td width="10%" colspan="3" nowrap><%=vTitleMain.get(2).toString()%> <%=vMain.get(6).toString()%></td>
		<td width="20%">&nbsp</td>
		<td width="15%">&nbsp</td>
		<td width="1%">&nbsp</td>
		<td width="10%"><b>INVOICE</b></td>
	</tr>
	<tr>
		<td width="10%"><b><%=vTitleMain.get(3).toString()%></b></td>
		<td width="1%">&nbsp</td>
		<td width="33%">&nbsp</td>
		<td width="20%">&nbsp</td>
		<td width="15%">&nbsp</td>
		<td width="1%">&nbsp</td>
		<td width="10%">&nbsp</td>
	</tr>
	<tr>
		<td width="10%"><%=vTitleMain.get(4).toString()%></td>
		<td width="1%">:</td>
		<td width="33%"><%=vMain.get(5).toString()%></td>
		<td width="20%">&nbsp</td>
		<td width="15%"><%=vTitleMain.get(11).toString()%></td>
		<td width="1%">:</td>
		<td width="10%"><%=vMain.get(8).toString()%></td>
	</tr>
	<tr>
		<td width="10%"><%=vTitleMain.get(5).toString()%></td>
		<td width="1%">:</td>
		<td width="33%"><%=vMain.get(13).toString()%></td>
		<td width="20%">&nbsp</td>
		<td width="15%"><%=vTitleMain.get(12).toString()%></td>
		<td width="1%">:</td>
		<td width="10%"><%=vMain.get(14).toString()%></td>
	</tr>
	<tr>
		<td width="10%"><%=vTitleMain.get(6).toString()%></td>
		<td width="1%">:</td>
		<td width="33%"><%=vMain.get(15).toString()%> <%if(vMain.get(16).toString() != null && vMain.get(16).toString().length() > 1){%><%=vTitleMain.get(24).toString()%> : <%=vMain.get(16).toString()%><%}%></td>
		<td width="20%">&nbsp</td>
		<td width="15%"><%=vTitleMain.get(13).toString()%></td>
		<td width="1%">:</td>
		<td width="10%"><%=vMain.get(17).toString()%></td>
	</tr>
	<tr><td colspan="7">&nbsp</td></tr>
	<tr>
		<td width="10%" nowrap><%=vTitleMain.get(8).toString()%></td>
		<td width="1%">:</td>
		<td width="33%"><%=vMain.get(18).toString()%></td>
		<td width="20%">&nbsp</td>
		<td width="15%"><%=vTitleMain.get(15).toString()%></td>
		<td width="1%">:</td>
		<td width="10%"><%=vMain.get(19).toString()%></td>
	</tr>
	<tr>
		<td width="10%"><%=vTitleMain.get(9).toString()%></td>
		<td width="1%">:</td>
		<td width="33%"><%=vMain.get(20).toString()%></td>
		<td width="20%">&nbsp</td>
		<td width="15%"><%=vTitleMain.get(16).toString()%></td>
		<td width="1%">:</td>
		<td width="10%"><%=vMain.get(21).toString()%></td>
	</tr>
        <tr> 
          <td colspan="7" nowrap> 
            <div align="center"><%=sListTicket%></div>
          </td>
        </tr>
	<tr>
		<td width="10%"><%=vTitleMain.get(29).toString()%></td>
		<td width="1%">:</td>
		<td width="33%"><%=vMain.get(22).toString()%></td>
		<td width="20%">&nbsp</td>
		<td width="15%" align="right"><b>Deposit</b></td>
		<td width="1%">&nbsp</td>
		<td width="10%" align="right"><%=Formater.formatNumber(dDeposit,"##,###")%></td>
	</tr>
	<tr>
		<td width="10%"><%=vTitleMain.get(27).toString()%></td>
		<td width="1%">:</td>
		<td width="33%"><%=vMain.get(23).toString()%></td>
		<td width="20%">&nbsp</td>
		<td width="15%" align="right"><b>Balance</b></td>
		<td width="1%">&nbsp</td>
		<td width="10%" align="right"><%=Formater.formatNumber(dBalance,"##,###")%></td>
	</tr>
	<tr>
		<td width="10%"><%=vTitleMain.get(28).toString()%></td>
		<td width="1%">:</td>
		<td width="33%" clospan="5" nowrap><%=vMain.get(24).toString()%></td>
	</tr>
	<tr><td colspan="7">&nbsp</td></tr>
	<tr>
		<td width="10%" colspan="3" nowrap>Approved By :</td>
		<td width="20%">&nbsp</td>
		<td width="15%">Accounting :</td>
		<td width="1%">&nbsp</td>
		<td width="10%">&nbsp</td>
	</tr>
	<tr><td colspan="7">&nbsp</td></tr>
	<tr><td colspan="7">&nbsp</td></tr>
	<tr>
		<td width="10%" colspan="3" nowrap>____________________</td>
		<td width="20%">&nbsp</td>
		<td width="15%">__________________</td>
		<td width="1%">&nbsp</td>
		<td width="10%">&nbsp</td>
	</tr>
      </table>
    </td>
  </tr>
</table>
</body>

