<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!--package aiso-->
<%@ page import = "java.util.StringTokenizer,
		   com.dimata.aiso.entity.report.ReservationPackageList,
		   com.dimata.aiso.session.invoice.SessInvoice,	
		   com.dimata.aiso.entity.masterdata.TicketMaster,
		   com.dimata.aiso.entity.masterdata.PstTicketMaster,
		   com.dimata.gui.jsp.ControlCombo,
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

private static String[][] srcParameter = {
	{"Tanggal","Nama Penumpang","s.d","Air Line"},
	{"Date","Passanger Name","to","Carrier"}	
};

private static String[][] pageTitle = {
	{"Laporan Kegiatan Usaha","Daftar Penjualan Ticket"},
	{"Bisnis Report","Ticket Sales List"}
};
 
public String listTicketSales(String strList, int language){	
	String sResult = "";
	double dPrice = 0.0;
	Vector vRowx = new Vector(1,1);
	sResult = "<table width=\"100%\" class=\"listgen\" cellpadding=\"0\" cellspacing=\"1\">";
	sResult += "<tr>";
	sResult += "<td width=\"10%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][0].toUpperCase()+"</b></td>";
	sResult += "<td width=\"20%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][1].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][2].toUpperCase()+"</b></td>";
	sResult += "<td width=\"10%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][3].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][4].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][5].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][6].toUpperCase()+"</b></td>";
	
	sResult += "</tr>";
	if(strList != null && strList.length() > 0){
		sResult += strList;
	}	
	sResult += "</table>";
	return sResult; 
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
long invoiceMainId = FRMQueryString.requestLong(request, "invoice_main_id");
long carrierId = FRMQueryString.requestLong(request, "carrier_id");
int start = FRMQueryString.requestInt(request, "start");
int dateFr = FRMQueryString.requestInt(request, "date_fr_dy");
int monthFr = FRMQueryString.requestInt(request, "date_fr_mn");
int yearFr = FRMQueryString.requestInt(request, "date_fr_yr");
int dateTo = FRMQueryString.requestInt(request, "date_to_dy");
int monthTo = FRMQueryString.requestInt(request, "date_to_mn");
int yearTo = FRMQueryString.requestInt(request, "date_to_yr");
String sPassName = FRMQueryString.requestString(request, "pass_name");
Date objDateFr = new Date();
Date objDateTo = new Date();

objDateFr.setDate(dateFr);
objDateFr.setMonth(monthFr - 1);
objDateFr.setYear(yearFr - 1900);

objDateTo.setDate(dateTo);
objDateTo.setMonth(monthTo - 1);
objDateTo.setYear(yearTo - 1900);

	
String[] srcList = {"Form Pencarian","Search List"};
String[] strSearch = {"Tampilkan","Search"};
String[] strViewSearch = {"Tampilkan Pencarian","View Search"};
String[] strPrintReport = {"Cetak Laporan","Print Report"};
int recordToGet = 0;
Vector vListTicketSales = new Vector(1,1);
String sListTicketSales = "";
String sReport = "";
String whClauseCarrier = PstTicketMaster.fieldNames[PstTicketMaster.FLD_TYPE]+" = "+PstTicketMaster.MASTER_CARRIER;
Vector vListCarrier = PstTicketMaster.list(0,0, whClauseCarrier , "");
SrcSalesTicketList srcSalesTicketList = new SrcSalesTicketList();
if(iCommand == Command.LIST){
	srcSalesTicketList.setTransDateFr(objDateFr);
	srcSalesTicketList.setTransDateTo(objDateTo);
	srcSalesTicketList.setPassName(sPassName);
	srcSalesTicketList.setCarrierId(carrierId);
	
	if(session.getValue("PRINT_STL") != null){
		session.removeValue("PRINT_STL");
	}
	
	session.putValue("PRINT_STL",srcSalesTicketList);
}
try{
	vListTicketSales = (Vector)SessInvoice.listTicketSales(start,recordToGet,srcSalesTicketList,"listgensell","listgensellOdd");
	sListTicketSales = vListTicketSales.get(0).toString();
	sReport = listTicketSales(sListTicketSales,SESS_LANGUAGE);	
}catch(Exception e){}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Untitled Document</title>
<script language="javascript">
function getThn()
{
	var dateFr = ""+document.sales_ticket_list.date_fr.value;
	var thn = dateFr.substring(6,10);
	var bln = dateFr.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = dateFr.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.sales_ticket_list.date_fr_mn.value=bln;
	document.sales_ticket_list.date_fr_dy.value=hri;
	document.sales_ticket_list.date_fr_yr.value=thn;
	
	var dateTo = ""+document.sales_ticket_list.date_to.value;
	var thn1 = dateTo.substring(6,10);
	var bln1 = dateTo.substring(3,5);	
	if(bln1.charAt(0)=="0"){
		bln1 = ""+bln1.charAt(1);
	}
	
	var hri1 = dateTo.substring(0,2);
	if(hri1.charAt(0)=="0"){
		hri1 = ""+hri1.charAt(1);
	}
	
	document.sales_ticket_list.date_to_mn.value=bln1;
	document.sales_ticket_list.date_to_dy.value=hri1;
	document.sales_ticket_list.date_to_yr.value=thn1;
}

function cmdSearch(){
	document.sales_ticket_list.command.value="<%=Command.LIST%>";
	document.sales_ticket_list.action="sales_ticket_list.jsp";
	document.sales_ticket_list.submit();
}

function hideSearch(){
	document.getElementById("search_param").style.display = "none";
	document.getElementById("checkbox_search").style.display = "";
}

function viewSearch(){
	document.getElementById("search_param").style.display = "";
	document.getElementById("checkbox_search").style.display = "none";
}

function cmdPrintSTL()
{
		window.open("print_sales_ticket_list.jsp","print_sales_ticket_list","left=300,top=150,status=yes,toolbar=no,menubar=yes,location=no,scrollbars=yes");
	
}

function hideObjectForDate(){
  }
	
  function showObjectForDate(){
  }	
</script>  
<link rel="stylesheet" href="../../style/calendar.css" type="text/css">
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="stylesheet" href="../../style/default.css" type="text/css">
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
		<table class="ds_box" cellpadding="0" cellspacing="0" id="ds_conclass" style="display: none;">
			<tr><td id="ds_calclass">
			</td></tr>
			</table>
			<script language=JavaScript src="<%=approot%>/main/calendar.js"></script>
		  <%=pageTitle[SESS_LANGUAGE][0]%> : <font color="#CC3300"><%=pageTitle[SESS_LANGUAGE][1].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="sales_ticket_list" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
		<input type="hidden" name="invoice_main_id" value="<%=invoiceMainId%>">	
              <input type="hidden" name="start" value="<%=start%>">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" height="372">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td colspan="5">
					<table id="search_param" width="100%" cellspacing="1" cellpadding="1" class="search01">
					<tr>
					<td>
					<table width="100%" class="search00">
						<tr><td colspan="5"><b><%=srcList[SESS_LANGUAGE]%></b></td></tr>
						<tr>
							<td width="15%"><%=srcParameter[SESS_LANGUAGE][0]%></td>
							<td width="1%">:</td>
							<td>
								<input onClick="ds_sh(this);" readonly="readonly" style="cursor: text" name="date_fr" value="<%=Formater.formatDate((srcSalesTicketList.getTransDateFr() == null) ? new Date() : srcSalesTicketList.getTransDateFr(), "dd-MM-yyyy")%>">
								<input type="hidden" name="date_fr_mn">
								<input type="hidden" name="date_fr_dy">
								<input type="hidden" name="date_fr_yr">
							</td>
							<td width="5%"><%=srcParameter[SESS_LANGUAGE][2]%></td>
							<td width="69%">
								<input onClick="ds_sh(this);" readonly="readonly" style="cursor: text" name="date_to" value="<%=Formater.formatDate((srcSalesTicketList.getTransDateTo() == null) ? new Date() : srcSalesTicketList.getTransDateTo(), "dd-MM-yyyy")%>">
								<input type="hidden" name="date_to_mn">
								<input type="hidden" name="date_to_dy">
								<input type="hidden" name="date_to_yr">
								<script language="JavaScript" type="text/JavaScript">getThn();</script>
							</td>
						</tr>
						<tr>
							<td><%=srcParameter[SESS_LANGUAGE][1]%></td>
							<td>:</td>
							<td><input type="text" name="pass_name" value="<%=srcSalesTicketList.getPassName()%>"></td>
							<td colspan="2">&nbsp</td>
						</tr>
						<tr>
							<td><%=srcParameter[SESS_LANGUAGE][3]%></td>
							<td>:</td>
							<td>
							<%
								Vector vCarrierVal = new Vector(1,1);
								Vector vCarrierKey = new Vector(1,1);
								String sSelectedCarrier = ""+srcSalesTicketList.getCarrierId();
								if(vListCarrier != null && vListCarrier.size() > 0){
									for(int i = 0; i < vListCarrier.size(); i++){
										TicketMaster objCarrier = (TicketMaster)vListCarrier.get(i);
										vCarrierVal.add(""+objCarrier.getOID());
										vCarrierKey.add(objCarrier.getCode());
									}
								}
								out.println(ControlCombo.draw("carrier_id", null, sSelectedCarrier, vCarrierVal, vCarrierKey,"",""));
							%>
							</td>
							<td colspan="2">&nbsp</td>
						</tr>
						<tr>
							<td>&nbsp</td>
							<td>&nbsp</td>	
							<td>
								<input type="submit" name="Search" value="<%=strSearch[SESS_LANGUAGE]%>" onClick="javascript:cmdSearch()">
							</td>
							<td colspan="2">&nbsp</td>		
						</tr>
						</table>
						</td>
						</tr>
					</table>
				</td>
			</tr>
	<tr id="checkbox_search">
		<td>
			<input type="checkbox" name="view_search" value="" onClick="javascript:viewSearch()"><%=strViewSearch[SESS_LANGUAGE]%>
		</td>
	</tr>
	<tr><td colspan="5" align="center"><%if(sListTicketSales.length() > 4){%><%=sReport%><%}%></td></tr>
	<tr><td colspan="5">&nbsp</td></tr>
	<tr><td colspan="5" class="command"><%if(sListTicketSales.length() > 4){%>
		<input type="button" name="print_list" value="<%=strPrintReport[SESS_LANGUAGE]%>" onClick="javascript:cmdPrintSTL()"><%}%>
	</table>
	</td>
  </tr>
</table>
<script language="javascript">
	<%if(iCommand == Command.LIST){%>
		hideSearch();
	<%}else{%>
		viewSearch();
	<%}%>		
</script>
</form>
</tr>
<tr> 
          <td height="100%"> 
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" height="20" class="footer"> 
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->

