<%@ page language="java" %>
<%@ include file = "../../main/javainit.jsp" %>

<!--package aiso-->
<%@ page import = "java.util.StringTokenizer,
		   com.dimata.aiso.entity.report.ReservationPackageList,
		   com.dimata.aiso.session.invoice.SessInvoice,	
		   com.dimata.gui.jsp.ControlCombo,
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

private static String[][] srcParameter = {
	{"Periode","C-In","C-Out","s.d","Nama","Urut Berdasarkan","Semua Tanggal"},
	{"Period","C-In","C-Out","to","Guest Name","Short By","All Date"}	
};

private static String[][] pageTitle = {
	{"Laporan Kegiatan Usaha","Daftar Reservasi Paket"},
	{"Bisnis Report","Reservation Package List"}
};
 
public String listReservationPackage(String strList, int language){	
	String sResult = "";
	double dPrice = 0.0;
	Vector vRowx = new Vector(1,1);
	sResult = "<table width=\"100%\" class=\"listgen\" cellpadding=\"0\" cellspacing=\"1\">";
	sResult += "<tr>";
	sResult += "<td width=\"20%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][0].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][1].toUpperCase()+"</b></td>";
	sResult += "<td width=\"40%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][2].toUpperCase()+"</b></td>";
	sResult += "<td width=\"15%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][3].toUpperCase()+"</b></td>";
	sResult += "<td width=\"5%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][4].toUpperCase()+"</b></td>";
	sResult += "<td width=\"5%\" class=\"listgentitle\" align=\"center\"><b>"+listHeader[language][5].toUpperCase()+"</b></td>";
	
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
int start = FRMQueryString.requestInt(request, "start");
int cinDateFr = FRMQueryString.requestInt(request, "cin_date_fr_dy");
int cinMonthFr = FRMQueryString.requestInt(request, "cin_date_fr_mn");
int cinYearFr = FRMQueryString.requestInt(request, "cin_date_fr_yr");
int cinDateTo = FRMQueryString.requestInt(request, "cin_date_to_dy");
int cinMonthTo = FRMQueryString.requestInt(request, "cin_date_to_mn");
int cinYearTo = FRMQueryString.requestInt(request, "cin_date_to_yr");
int coutDateFr = FRMQueryString.requestInt(request, "cout_date_fr_dy");
int coutMonthFr = FRMQueryString.requestInt(request, "cout_date_fr_mn");
int coutYearFr = FRMQueryString.requestInt(request, "cout_date_fr_yr");
int coutDateTo = FRMQueryString.requestInt(request, "cout_date_to_dy");
int coutMonthTo = FRMQueryString.requestInt(request, "cout_date_to_mn");
int coutYearTo = FRMQueryString.requestInt(request, "cout_date_to_yr");
int cin = FRMQueryString.requestInt(request, "cin_date");
int iOrderBy = FRMQueryString.requestInt(request, "order_by");
String sGuestName = FRMQueryString.requestString(request, "guest_name");
Date objCinDateFr = new Date();
Date objCinDateTo = new Date();
Date objCoutDateFr = new Date();
Date objCoutDateTo = new Date();
switch(cin){
case 0:
	objCinDateFr.setDate(cinDateFr);
	objCinDateFr.setMonth(cinMonthFr - 1);
	objCinDateFr.setYear(cinYearFr - 1900);

	objCinDateTo.setDate(cinDateTo);
	objCinDateTo.setMonth(cinMonthTo - 1);
	objCinDateTo.setYear(cinYearTo - 1900);

	objCoutDateFr = null;
	objCoutDateTo = null;
break;
case 1:
	objCoutDateFr.setDate(coutDateFr);
	objCoutDateFr.setMonth(coutMonthFr - 1);
	objCoutDateFr.setYear(coutYearFr - 1900);

	objCoutDateTo.setDate(coutDateTo);
	objCoutDateTo.setMonth(coutMonthTo - 1);
	objCoutDateTo.setYear(coutYearTo - 1900);

	objCinDateFr = null;
	objCinDateTo = null;
break;
case 2:
	objCinDateFr = null;
	objCinDateTo = null;
	objCoutDateFr = null;
	objCoutDateTo = null;
break;
}
String[] srcList = {"Form Pencarian","Search List"};
String[] strSearch = {"Tampilkan","Search"};
String[] strViewSearch = {"Tampilkan Pencarian","View Search"};
String[] strPrintReport = {"Cetak Laporan","Print Report"};
int recordToGet = 0;
String sListResPackage = "";
String sReport = "";
SrcReservationPackageList srcResPackList = new SrcReservationPackageList();
if(iCommand == Command.LIST){
	srcResPackList.setCInDateFr(objCinDateFr);
	srcResPackList.setCInDateTo(objCinDateTo);
	srcResPackList.setCOutDateFr(objCoutDateFr);
	srcResPackList.setCOutDateTo(objCoutDateTo);
	srcResPackList.setGuestName(sGuestName);
	srcResPackList.setOrderBy(iOrderBy);
	
	if(session.getValue("PRINT_RPL") != null){
		session.removeValue("PRINT_RPL");
	}
	
	session.putValue("PRINT_RPL",srcResPackList);
}
try{
	sListResPackage = (String)SessInvoice.listReservationPackage(start,recordToGet,srcResPackList,"listgensell","listgensellOdd");
	
	sReport = listReservationPackage(sListResPackage,SESS_LANGUAGE);	
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
	var cInDateFr = ""+document.list_reservation_package.cin_date_fr.value;
	var thn = cInDateFr.substring(6,10);
	var bln = cInDateFr.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = cInDateFr.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.list_reservation_package.cin_date_fr_mn.value=bln;
	document.list_reservation_package.cin_date_fr_dy.value=hri;
	document.list_reservation_package.cin_date_fr_yr.value=thn;
	
	var cInDateTo = ""+document.list_reservation_package.cin_date_to.value;
	var thn1 = cInDateTo.substring(6,10);
	var bln1 = cInDateTo.substring(3,5);	
	if(bln1.charAt(0)=="0"){
		bln1 = ""+bln1.charAt(1);
	}
	
	var hri1 = cInDateTo.substring(0,2);
	if(hri1.charAt(0)=="0"){
		hri1 = ""+hri1.charAt(1);
	}
	
	document.list_reservation_package.cin_date_to_mn.value=bln1;
	document.list_reservation_package.cin_date_to_dy.value=hri1;
	document.list_reservation_package.cin_date_to_yr.value=thn1;	
	
	
	var cOutDateFr = ""+document.list_reservation_package.cout_date_fr.value;
	var thn2 = cOutDateFr.substring(6,10);
	var bln2 = cOutDateFr.substring(3,5);	
	if(bln2.charAt(0)=="0"){
		bln2 = ""+bln2.charAt(1);
	}
	
	var hri2 = cOutDateFr.substring(0,2);
	if(hri2.charAt(0)=="0"){
		hri2 = ""+hri2.charAt(1);
	}
	
	document.list_reservation_package.cout_date_fr_mn.value=bln2;
	document.list_reservation_package.cout_date_fr_dy.value=hri2;
	document.list_reservation_package.cout_date_fr_yr.value=thn2;	

	var cOutDateTo = ""+document.list_reservation_package.cout_date_to.value;
	var thn3 = cOutDateTo.substring(6,10);
	var bln3 = cOutDateTo.substring(3,5);	
	if(bln3.charAt(0)=="0"){
		bln3 = ""+bln3.charAt(1);
	}
	
	var hri3 = cOutDateTo.substring(0,2);
	if(hri3.charAt(0)=="0"){
		hri3 = ""+hri3.charAt(1);
	}
	
	document.list_reservation_package.cout_date_to_mn.value=bln3;
	document.list_reservation_package.cout_date_to_dy.value=hri3;
	document.list_reservation_package.cout_date_to_yr.value=thn3;			
			
}

function cmdSearch(){
	document.list_reservation_package.command.value="<%=Command.LIST%>";
	document.list_reservation_package.action="reservation_pack_list.jsp";
	document.list_reservation_package.submit();
}

function cmdEdit(oid){
	document.list_reservation_package.invoice_main_id.value=oid;
	document.list_reservation_package.command.value="<%=Command.EDIT%>";
	document.list_reservation_package.action="<%=approot%>/invoice/invoice_edit.jsp";
	document.list_reservation_package.submit();
}

function hideSearch(){
	document.getElementById("search_param").style.display = "none";
	document.getElementById("checkbox_search").style.display = "";
}

function viewSearch(){
	document.getElementById("search_param").style.display = "";
	document.getElementById("checkbox_search").style.display = "none";
}

function cmdPrintRPL()
{
		window.open("print_reser_pack_list.jsp","print_reser_pack_list","left=300,top=150,status=yes,toolbar=no,menubar=yes,location=no,scrollbars=yes");
	
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
            <form name="list_reservation_package" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
		<input type="hidden" name="invoice_main_id" value="<%=invoiceMainId%>">	
              <input type="hidden" name="start" value="<%=start%>">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td valign="top" height="372">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td colspan="7">
					<table id="search_param" width="100%" cellspacing="1" cellpadding="1" class="search01">
					<tr>
					<td>
					<table width="100%" class="search00">
						<tr><td colspan="7"><b><%=srcList[SESS_LANGUAGE]%></b></td></tr>
						<tr>
							<td width="15%"><%=srcParameter[SESS_LANGUAGE][0]%></td>
							<td width="5%"><%=srcParameter[SESS_LANGUAGE][1]%></td>
							<td width="1%">:</td>
							<td width="5%"><input type="radio" name="cin_date" value="0" <%if(cin == 0){%>checked<%}%>></td>
							<td>
								<input onClick="ds_sh(this);" readonly="readonly" style="cursor: text" name="cin_date_fr" value="<%=Formater.formatDate((srcResPackList.getCInDateFr() == null) ? new Date() : srcResPackList.getCInDateFr(), "dd-MM-yyyy")%>">
								<input type="hidden" name="cin_date_fr_mn">
								<input type="hidden" name="cin_date_fr_dy">
								<input type="hidden" name="cin_date_fr_yr">
							</td>
							<td width="5%"><%=srcParameter[SESS_LANGUAGE][3]%></td>
							<td width="69%">
								<input onClick="ds_sh(this);" readonly="readonly" style="cursor: text" name="cin_date_to" value="<%=Formater.formatDate((srcResPackList.getCInDateTo() == null) ? new Date() : srcResPackList.getCInDateTo(), "dd-MM-yyyy")%>">
								<input type="hidden" name="cin_date_to_mn">
								<input type="hidden" name="cin_date_to_dy">
								<input type="hidden" name="cin_date_to_yr">
							</td>
						</tr>
						<tr>
							<td width="15%">&nbsp</td>
							<td width="5%"><%=srcParameter[SESS_LANGUAGE][2]%></td>
							<td width="1%">:</td>
							<td width="5%"><input type="radio" name="cin_date" value="1" <%if(cin == 1){%>checked<%}%>></td>
							<td>
								<input onClick="ds_sh(this);" readonly="readonly" style="cursor: text" name="cout_date_fr" value="<%=Formater.formatDate((srcResPackList.getCOutDateFr() == null) ? new Date() : srcResPackList.getCOutDateFr(), "dd-MM-yyyy")%>">
								<input type="hidden" name="cout_date_fr_mn">
								<input type="hidden" name="cout_date_fr_dy">
								<input type="hidden" name="cout_date_fr_yr">
							</td>
							<td width="5%"><%=srcParameter[SESS_LANGUAGE][3]%></td>
							<td width="69%">
								<input onClick="ds_sh(this);" readonly="readonly" style="cursor: text" name="cout_date_to" value="<%=Formater.formatDate((srcResPackList.getCOutDateTo() == null) ? new Date() : srcResPackList.getCOutDateTo(), "dd-MM-yyyy")%>">
								<input type="hidden" name="cout_date_to_mn">
								<input type="hidden" name="cout_date_to_dy">
								<input type="hidden" name="cout_date_to_yr">
								<script language="JavaScript" type="text/JavaScript">getThn();</script>
							</td>
						</tr>
						<tr>
							<td width="15%">&nbsp</td>
							<td width="5%">&nbsp</td>
							<td width="1%">:</td>
							<td width="5%"><input type="radio" name="cin_date" value="2" <%if(cin == 2){%>checked<%}%>></td>
							<td><%=srcParameter[SESS_LANGUAGE][6]%></td>
							<td width="5%">&nbsp</td>
							<td width="69%">&nbsp</td>
						</tr>
						<tr>
							<td colspan="2"><%=srcParameter[SESS_LANGUAGE][4]%></td>
							<td>:</td>
							<td>&nbsp</td>
							<td><input type="text" name="guest_name" value="<%=srcResPackList.getGuestName()%>"></td>
							<td colspan="2">&nbsp</td>
						</tr>
						<tr>
							<td colspan="2"><%=srcParameter[SESS_LANGUAGE][5]%></td>
							<td>:</td>
							<td>&nbsp</td>
							<td>
								<%
									Vector vOrderVal = new Vector(1,1);
									Vector vOrderKey = new Vector(1,1);
									String selected = ""+srcResPackList.getOrderBy();
									
									vOrderVal.add("0");
									vOrderKey.add("Check In");

									vOrderVal.add("1");
									vOrderKey.add("Check Out");

									vOrderVal.add("2");
									vOrderKey.add("Guest Name");

									vOrderVal.add("3");
									vOrderKey.add("Time Limit");		
								%>
								<%= ControlCombo.draw("order_by",null, selected, vOrderVal, vOrderKey,  "", "") %> 
							</td>
							<td colspan="2">&nbsp</td>
						</tr>
						<tr>
							<td>&nbsp</td>	
							<td>&nbsp</td>	
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
	<tr><td colspan="7" align="center"><%if(sListResPackage.length() > 4){%><%=sReport%><%}%></td></tr>
	<tr><td colspan="7">&nbsp</td></tr>
	<tr><td colspan="7" class="command"><%if(sListResPackage.length() > 4){%>
		<input type="button" name="print_list" value="<%=strPrintReport[SESS_LANGUAGE]%>" onClick="javascript:cmdPrintRPL()"><%}%>
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

