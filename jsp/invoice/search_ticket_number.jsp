
<%@page contentType="text/html"%>
<%@ page import="com.dimata.gui.jsp.ControlList,
		 com.dimata.aiso.entity.search.SrcTicket,
                 com.dimata.aiso.entity.masterdata.TicketRate,
                 com.dimata.aiso.entity.masterdata.PstTicketRate,
		 com.dimata.aiso.entity.masterdata.TicketMaster,
                 com.dimata.aiso.entity.masterdata.PstTicketMaster,
		 com.dimata.aiso.entity.masterdata.TicketList,
                 com.dimata.aiso.entity.masterdata.PstTicketList,
		 com.dimata.aiso.entity.masterdata.TicketDeposit,
                 com.dimata.aiso.entity.masterdata.PstTicketDeposit,
                 com.dimata.aiso.form.masterdata.CtrlTicketList,
                 com.dimata.util.*,
                 com.dimata.aiso.session.masterdata.SessTicket,
                 com.dimata.gui.jsp.ControlCombo,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.aiso.form.invoice.FrmInvoiceDetail"%>
<%@ include file = "../main/javainit.jsp" %>
<%!

/* this constant used to list text of listHeader */
public static final String textListHeader[][] = { 
	{"No","Nomor Ticket","Penyedia Jasa Penerbangan","Tanggal Deposit"},
	{"No","Ticket Number","Carrier","Deposit Date"}
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
		ctrlist.dataFormat(textListHeader[language][1],"60%","center","left");
		ctrlist.dataFormat(textListHeader[language][2],"10%","center","left");
		ctrlist.dataFormat(textListHeader[language][3],"25%","center","center");
		
		ctrlist.setLinkRow(-1);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;
		
		TicketMaster objCarrier = new TicketMaster();
		TicketDeposit objDeposit = new TicketDeposit();
		Vector rowx = new Vector();
		

		for(int i=0; i<objectClass.size(); i++){
			TicketList objTicketList = (TicketList)objectClass.get(i);
			
			if(objTicketList.getCarrierId() != 0){
				try{
					objCarrier = PstTicketMaster.fetchExc(objTicketList.getCarrierId());
				}catch(Exception e){}
			}
			
			if(objTicketList.getTicketDepositId() != 0){
				try{
					objDeposit = PstTicketDeposit.fetchExc(objTicketList.getTicketDepositId());
				}catch(Exception e){}
			}
			
			rowx = new Vector();
			rowx.add(""+(i+start+1));               
               		rowx.add("<a href=\"javascript:cmdEdit('"+objTicketList.getOID()+"','"+objTicketList.getTicketNumber().trim()+"')\">"+objTicketList.getTicketNumber()+"</a>");           
              		rowx.add(objCarrier.getCode());
            		rowx.add(Formater.formatDate(objDeposit.getDepositDate(), "dd-MM-yyyy"));

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
long carrierId = FRMQueryString.requestLong(request,"carrier_id");
String strTitle[] = {"DAFTAR TIKET","TICKET LIST"};
String strNoData[] = {"Ticket tidak tersedia. Silahkan entry di master data tiket atau silahkan ganti dengan pesawat lain","Ticket is not ready. Please entry on master data ticket or please select another carrier"};


int recordToGet = 100;
int vectSize = 0;

TicketMaster objCarrier = new TicketMaster();
if(carrierId != 0){
	try{
		objCarrier = PstTicketMaster.fetchExc(carrierId);
	}catch(Exception e){}
}

String whClause = PstTicketList.fieldNames[PstTicketList.FLD_CARRIER_ID]+" = "+carrierId+
		  " AND "+PstTicketList.fieldNames[PstTicketList.FLD_INVOICE_DETAIL_ID]+" = 0";
CtrlTicketList ctrlTicketList = new CtrlTicketList(request);
if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
	vectSize = PstTicketList.getCount("");
	start = ctrlTicketList.actionList(iCommand,start,vectSize,recordToGet);
}else{
    vectSize = PstTicketList.getCount(whClause);
} 
 
Vector vect = PstTicketList.list(start,recordToGet,whClause,"");
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

function cmdEdit(oid,number){
	self.opener.document.forms.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.ticket_id.value = oid;
	self.opener.document.forms.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.ticket_number.value = number;
	self.opener.document.forms.<%=FrmInvoiceDetail.FRM_INVOICE_DETAIL%>.ticket_number.focus();
	self.close();
}

function first(){
	document.frmaccountsearch.command.value="<%=Command.FIRST%>";
	document.frmaccountsearch.action="search_ticket_number.jsp";
	document.frmaccountsearch.submit();
}

function prev(){
	document.frmaccountsearch.command.value="<%=Command.PREV%>";
	document.frmaccountsearch.action="search_ticket_number.jsp";
	document.frmaccountsearch.submit();
}

function next(){
	document.frmaccountsearch.command.value="<%=Command.NEXT%>";
	document.frmaccountsearch.action="search_ticket_number.jsp";
	document.frmaccountsearch.submit();
}

function last(){
	document.frmaccountsearch.command.value="<%=Command.LAST%>";
	document.frmaccountsearch.action="search_ticket_number.jsp";
	document.frmaccountsearch.submit();
}

function cmdSearch(){
	document.frmaccountsearch.command.value="<%=Command.LIST%>";
	document.frmaccountsearch.start.value="0";	
	document.frmaccountsearch.action="search_ticket_number.jsp";
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
	  <input type="hidden" name="carrier_id" value="">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="menuleft">
        <tr>

      <td height="20" class="title" align="center"><b><font size="3"><%=objCarrier.getDescription().toUpperCase()+" "+strTitle[SESS_LANGUAGE]%></font></b></td>
        </tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
        <tr>
      <td>
        <table width="100%" border="0" cellpadding="1" cellspacing="1" class="listgenactivity">
		
          <tr> 
		<%if(vect != null && vect.size() > 0){%>
            <td colspan="3">
					
				<%=drawList(SESS_LANGUAGE,vect,start)%>
				
			</td>
		<%}else{%>
			 <td colspan="3" align="center" class="msginfo">
				<%=strNoData[SESS_LANGUAGE]%>
			</td>
			<%}%>
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
