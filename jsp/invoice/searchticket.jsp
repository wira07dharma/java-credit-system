
<%@page contentType="text/html"%>
<%@ page import="com.dimata.gui.jsp.ControlList,
		 com.dimata.aiso.entity.search.SrcTicket,
                 com.dimata.aiso.entity.masterdata.TicketRate,
                 com.dimata.aiso.entity.masterdata.PstTicketRate,
		 com.dimata.aiso.entity.masterdata.TicketMaster,
                 com.dimata.aiso.entity.masterdata.PstTicketMaster,
		 com.dimata.aiso.entity.masterdata.TicketList,
                 com.dimata.aiso.entity.masterdata.PstTicketList,
                 com.dimata.aiso.form.masterdata.CtrlTicketRate,
                 com.dimata.util.*,
                 com.dimata.aiso.session.masterdata.SessTicket,
                 com.dimata.gui.jsp.ControlCombo,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.aiso.form.invoice.FrmInvoiceDetail"%>
<%@ include file = "../main/javainit.jsp" %>
<%!
public static final int SORT_BY_CARRIER = 0;
public static final int SORT_BY_ROUTE = 1;
public static final int SORT_BY_CLASS = 2;

/* this constant used to list text of listHeader */
public static final String textListHeader[][] = { 
	{"No","Penyedia Jasa Penerbangan","Rute","Kelas","Harga Dasar"},
	{"No","Carrier","Route","Class","Basic Price"}
};

public static final String strSearchParameter[][] = {
	{"Penyedia Jasa Penerbangan","Rute","Kelas","Urut Berdasarkan"},
	{"Carrier","Route","Class","Short By"}
};

public static final String strShortBy[][] = {
	{"Penyedia Jasa Penerbangan","Rute","Kelas"},
	{"Carrier","Route","Class"}
};

private static String strErrorMassage[] = {
	"Data Tidak Ditemukan","System can't found data"
};

public static final String strSelectAll[] = {
	"Semua", "All"
};


public String drawList(int language, Vector objectClass, int start){
	String result = "";
	if(objectClass!=null && objectClass.size()>0){
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%"); 
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setCellStyleOdd("listgensellOdd");
		ctrlist.setHeaderStyle("listgentitle");
		
		ctrlist.dataFormat(textListHeader[language][0],"5%","center","center");
		ctrlist.dataFormat(textListHeader[language][1],"20%","center","left");
		ctrlist.dataFormat(textListHeader[language][2],"25%","center","left");
		ctrlist.dataFormat(textListHeader[language][3],"10%","center","left");
		ctrlist.dataFormat(textListHeader[language][4],"40%","center","right");
	
		ctrlist.setLinkRow(-1);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		TicketMaster objCarrier = new TicketMaster();
		TicketMaster objRoute = new TicketMaster();
		TicketMaster objClass = new TicketMaster();
		TicketList objTicket = new TicketList();

		Vector rowx = new Vector();
		Vector vTicket = new Vector(1,1);
		Vector vTicketVal = new Vector(1,1);
		Vector vTicketKey = new Vector(1,1);

		String selectedTicket = "";
		String whClause = "";

			
		for(int i=0; i<objectClass.size(); i++){
			TicketRate objTicketRate = (TicketRate)objectClass.get(i);
			 
			if(objTicketRate.getCarrierId() != 0){
				try{
					objCarrier = PstTicketMaster.fetchExc(objTicketRate.getCarrierId());		
				}catch(Exception e){}
			}

			if(objTicketRate.getRouteId() != 0){
				try{
					objRoute = PstTicketMaster.fetchExc(objTicketRate.getRouteId());		
				}catch(Exception e){}
			}

			if(objTicketRate.getClassId() != 0){
				try{
					objClass = PstTicketMaster.fetchExc(objTicketRate.getClassId());		
				}catch(Exception e){}
			}
			
			String description = objCarrier.getCode()+"/"+objClass.getCode()+"/"+objRoute.getCode();
			rowx = new Vector();
			rowx.add(""+(i+start+1));               
               		rowx.add("<a href=\"javascript:cmdEdit('"+description+"','"+objCarrier.getOID()+"','"+Formater.formatNumber(objTicketRate.getRate(), "###.##")+"', '"+objCarrier.getContactId()+"', '"+objCarrier.getAccCogsId()+"', '"+objCarrier.getAccApId()+"', '"+objTicketRate.getNetRateToAirLine()+"')\">"+objCarrier.getCode()+"</a>");           
              		rowx.add(objRoute.getCode());
            		rowx.add(objClass.getCode());
			rowx.add(Formater.formatNumber(objTicketRate.getRate(),"##,###.##"));			

			lstData.add(rowx);
		}
		result = ctrlist.drawMe(index);
	}else{
		result = "<div class=\"msginfo\">&nbsp;&nbsp;...</div>";
	}
	return result;	
}
%>

<!-- JSP Block -->
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request,"start");
int intSortBy = FRMQueryString.requestInt(request,"sort_by");
long carrierId = FRMQueryString.requestLong(request,"carrier_id");
long routeId = FRMQueryString.requestLong(request,"route_id");
long classId = FRMQueryString.requestLong(request,"class_id");
String strTitle[] = {"PENCARIAN PENYEDIA JASA PENERBANGAN","SEARCH CARRIER"};
String strSearch[] = {"Tampilkan","Search"};
String strReset[] = {"Kosongkan","Reset"};
String searchData = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "View Search Form" : "Cari Data";
String hideSearch = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Hide Search Form" : "Sembunyikan Form Cari Data";

int recordToGet = 100;
String pageHeader = "Search Ticket"; 
String pageTitle = "SEARCH TICKET";   

int vectSize = 0;

SrcTicket srcTicket = new SrcTicket();
srcTicket.setCarrierId(carrierId);
srcTicket.setRouteId(routeId);
srcTicket.setClassId(classId);
srcTicket.setOrderBy(intSortBy);

CtrlTicketRate ctrlTicketRate = new CtrlTicketRate(request);
if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
	vectSize = SessTicket.getCountTicket(srcTicket);
	start = ctrlTicketRate.actionList(iCommand,start,vectSize,recordToGet);
}else{
    vectSize = SessTicket.getCountTicket(srcTicket);
} 
 
Vector vect = SessTicket.listTicket(start,recordToGet,srcTicket);
%>
<!-- End of JSP Block -->

<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Untitled Document</title>  
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<script language="JavaScript">
window.focus();

function cmdEdit(description,oid,price,contactId,perkHPPId,perkHutangId,nrta){
	self.opener.document.forms.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_DESCRIPTION]%>.value = description;
	self.opener.document.forms.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.carrier_id.value = oid;
	self.opener.document.forms.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.<%=FrmInvoiceDetail.fieldNames[FrmInvoiceDetail.FRM_UNIT_PRICE]%>.value = price;
	self.opener.document.forms.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.supplier_id.value = contactId;
	self.opener.document.forms.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.acc_cogs_id.value = perkHPPId;
	self.opener.document.forms.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.acc_ap_id.value = perkHutangId;
	self.opener.document.forms.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.net_rate.value = nrta;
	self.close();
}

function first(){
	document.frmaccountsearch.command.value="<%=Command.FIRST%>";
	document.frmaccountsearch.action="searchticket.jsp";
	document.frmaccountsearch.submit();
}

function prev(){
	document.frmaccountsearch.command.value="<%=Command.PREV%>";
	document.frmaccountsearch.action="searchticket.jsp";
	document.frmaccountsearch.submit();
}

function next(){
	document.frmaccountsearch.command.value="<%=Command.NEXT%>";
	document.frmaccountsearch.action="searchticket.jsp";
	document.frmaccountsearch.submit();
}

function last(){
	document.frmaccountsearch.command.value="<%=Command.LAST%>";
	document.frmaccountsearch.action="searchticket.jsp";
	document.frmaccountsearch.submit();
}

function cmdSearch(){
	document.frmaccountsearch.command.value="<%=Command.LIST%>";
	document.frmaccountsearch.start.value="0";	
	document.frmaccountsearch.action="searchticket.jsp";
	document.frmaccountsearch.submit();
}	

function enterTrap(){
	if(event.keyCode==13){
		document.frmaccountsearch.btnSubmit.focus();
		cmdSearch();
	}
}

function cmdViewSearch(){
	document.frmaccountsearch.command.value="<%=Command.NONE%>";	
	document.frmaccountsearch.action="searchticket.jsp";
	document.frmaccountsearch.submit();
}

function cmdHideSearch(){
	document.frmaccountsearch.command.value="<%=Command.LIST%>";	
	document.frmaccountsearch.action="searchticket.jsp";
	document.frmaccountsearch.submit();
}
	
</script>

<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
<link rel="StyleSheet" href="../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
		  <SCRIPT language="javascript">
		  	window.focus();
		  </SCRIPT>
	<form name="frmaccountsearch" method="post" action="">
	  <input type="hidden" name="start" value="<%=start%>">
	  <input type="hidden" name="command" value="<%=iCommand%>">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="menuleft">
        <tr>

      <td height="20" class="title" align="center"><b><font size="3"><%=strTitle[SESS_LANGUAGE]%></font></b></td>
        </tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
        <tr id="parameter">
      <td>
        <table width="100%" border="0" cellpadding="1" cellspacing="1" class="listgenactivity">
			<tr>
				<td>
				<%
					int iCmd = 0;
					if(iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT
					|| iCommand == Command.LAST){
						iCmd = Command.LIST;
					}
				%>
				<%if(iCommand != Command.LIST){
					if(iCmd != Command.LIST){
				%>
					<table width="100%" class="listgenvalue">
          <tr><!-- Start Parameter -->
            <td width="17%" nowrap>&nbsp;<%=strSearchParameter[SESS_LANGUAGE][0]%></td>
            <td width="1%">:</td>
            <td width="82%">
			<%
				String whereClause = PstTicketMaster.fieldNames[PstTicketMaster.FLD_TYPE]+" = "+PstTicketMaster.MASTER_CARRIER;
				String orderBy = PstTicketMaster.fieldNames[PstTicketMaster.FLD_CODE];
				Vector vCarrier = PstTicketMaster.list(0,0,whereClause,orderBy);
				Vector vCarrierVal = new Vector(1,1);
				Vector vCarrierKey = new Vector(1,1);
				String selectedCarrier = ""+srcTicket.getCarrierId();
				vCarrierVal.add("0");
				vCarrierKey.add(strSelectAll[SESS_LANGUAGE]+" "+strSearchParameter[SESS_LANGUAGE][0]);
				if(vCarrier != null && vCarrier.size() > 0){
					for(int i = 0; i < vCarrier.size(); i++){
						TicketMaster objCarrier = (TicketMaster)vCarrier.get(i);
						vCarrierVal.add(""+objCarrier.getOID());
						vCarrierKey.add(objCarrier.getCode());
					}
				 }
				  out.println(ControlCombo.draw("carrier_id","",null,selectedCarrier,vCarrierVal,vCarrierKey,""));
				  %>
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;<%=strSearchParameter[SESS_LANGUAGE][1]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
             <%
				String whClause = PstTicketMaster.fieldNames[PstTicketMaster.FLD_TYPE]+" = "+PstTicketMaster.MASTER_ROUTE;
				String order = PstTicketMaster.fieldNames[PstTicketMaster.FLD_CODE];
				Vector vRoute = PstTicketMaster.list(0,0,whClause,order);
				Vector vRouteVal = new Vector(1,1);
				Vector vRouteKey = new Vector(1,1);
				String selectedRoute = ""+srcTicket.getRouteId();
				vRouteVal.add("0");
				vRouteKey.add(strSelectAll[SESS_LANGUAGE]+" "+strSearchParameter[SESS_LANGUAGE][1]);
				if(vRoute != null && vRoute.size() > 0){
					for(int j = 0; j < vRoute.size(); j++){
						TicketMaster objRoute = (TicketMaster)vRoute.get(j);
						vRouteVal.add(""+objRoute.getOID());
						vRouteKey.add(objRoute.getCode());
					}
				 }
				  out.println(ControlCombo.draw("route_id","",null,selectedRoute,vRouteVal,vRouteKey,""));
				  %>
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;<%=strSearchParameter[SESS_LANGUAGE][2]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
              <%
				String whereCls = PstTicketMaster.fieldNames[PstTicketMaster.FLD_TYPE]+" = "+PstTicketMaster.MASTER_CLASS;
				String ordBy = PstTicketMaster.fieldNames[PstTicketMaster.FLD_CODE];
				Vector vClass = PstTicketMaster.list(0,0,whereCls,ordBy);
				Vector vClassVal = new Vector(1,1);
				Vector vClassKey = new Vector(1,1);
				String selectedClass = ""+srcTicket.getClassId();
				vClassVal.add("0");
				vClassKey.add(strSelectAll[SESS_LANGUAGE]+" "+strSearchParameter[SESS_LANGUAGE][2]);
				if(vClass != null && vClass.size() > 0){
					for(int k = 0; k < vClass.size(); k++){
						TicketMaster objClass = (TicketMaster)vClass.get(k);
						vClassVal.add(""+objClass.getOID());
						vClassKey.add(objClass.getCode());
					}
				 }
				  out.println(ControlCombo.draw("class_id","",null,selectedClass,vClassVal,vClassKey,""));
				  %>
            </td>
          </tr>
          <tr> 
            <td width="17%" nowrap>&nbsp;<%=strSearchParameter[SESS_LANGUAGE][3]%></td>
            <td width="1%">:</td>
            <td width="82%"> 
            <%
			Vector vectSortVal = new Vector(1,1);
			Vector vectSortKey = new Vector(1,1);
			vectSortVal.add(strShortBy[SESS_LANGUAGE][0]);
			vectSortKey.add(""+SORT_BY_CARRIER);																	  				  						
			vectSortVal.add(strShortBy[SESS_LANGUAGE][1]);
			vectSortKey.add(""+SORT_BY_ROUTE);
			vectSortVal.add(strShortBy[SESS_LANGUAGE][2]);
			vectSortKey.add(""+SORT_BY_CLASS);			
		    out.println(ControlCombo.draw("sort_by","",null,""+intSortBy,vectSortKey,vectSortVal,""));						
			%>
            </td>
          </tr>
          <tr> 
            <td width="17%">&nbsp;</td>
            <td width="1%">&nbsp;</td>
            <td width="82%"> 
              <input type="button" name="btnSubmit" value="<%=strSearch[SESS_LANGUAGE]%>" onClick="javascript:cmdSearch()">
              <input type="button" name="btnReset" value="<%=strReset[SESS_LANGUAGE]%>" onClick="javascript:cmdClear()">
            </td>
          </tr><!-- End Parameter-->
		  </table>
		  <%}
		  }%>
		  </td>
		  </tr>
		  <tr id="commandsearch">
                  <td align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
				  <%if(iCommand == Command.LIST || iCmd == Command.LIST){%>
				  <a href="javascript:cmdViewSearch()"><%=searchData%></a>
				  <%}else{%>				  
				  <a href="javascript:cmdHideSearch()"><%=hideSearch%></a>
				  <%}%>
				  </font>
				  </td>
                </tr>
          <tr> 
            <td colspan="3">
					
				<%=drawList(SESS_LANGUAGE,vect,start)%>
				
			</td>
          </tr>
          <tr> 
            <td colspan="3"> <span class="command"> 
              <% 
			  ControlLine ctrlLine= new ControlLine();
			  ctrlLine.initDefault(SESS_LANGUAGE,"");
			  out.println(ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left"));
			  %>
              </span> </td>
          </tr>
        </table>
      </td>
        </tr>
      </table>
	  <script language="javascript">
	  	<%
			if(iCommand != Command.LIST){
				if(iCmd != Command.LIST){
		%>
	  		document.frmaccountsearch.account_group.focus();
		<%}
		}%>
	  </script>
   </form>	  




<link rel="stylesheet" href="../style/main.css" type="text/css">
<!-- #EndEditable --></td>
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
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
