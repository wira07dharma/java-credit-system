<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.session.invoice.*,
				 com.dimata.aiso.entity.invoice.*,
				 com.dimata.aiso.entity.search.SrcInvoice,
				 com.dimata.aiso.form.search.FrmSrcInvoice,
				 com.dimata.common.entity.system.PstSystemProperty,
				 com.dimata.harisma.entity.masterdata.*,
				 com.dimata.aiso.entity.periode.*,
				 com.dimata.aiso.form.invoice.*,
                 com.dimata.common.entity.contact.*,
                 com.dimata.gui.jsp.ControlList,
                 com.dimata.gui.jsp.ControlLine,
                 com.dimata.util.Command,
				 com.dimata.qdep.entity.I_DocStatus,
                 com.dimata.util.Formater" %>

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privSubmit){
%>

<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>

<!-- if of "has access" condition -->
<%
}
else
{
%>

<!-- JSP Block -->
<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;

public static String strTitle[][] = 
{
	{
		"No.",
		"Nomor Invoice",
		"Tanggal Invoice",
		"Pelanggan",
        "Nilai Invoice",
		"Status",
		"Invoice Tipe",
		"System tidak menemukan data yg dicari. Silahkan ulangi kembali"
	},
	{
		"No.",
		"Invoice Number",
		"Invoice Issued Date",
		"Customer",
        "Invoice Amount",
		"Status",
		"Invoice Type",
		"System can not found data. Please try again"
	}
};

public static final String masterTitle[] = 
{
	"Daftar",
	"List"
};

public static final String listTitle[] = 
{
	"Invoice Yang Akan Diubah Statusnya",
	"Invoice To Update Status"
};

public String getContactName(ContactList objContactList){
	if(objContactList != null){
		try{
			if(objContactList.getCompName() != null){
				return objContactList.getCompName();
			}else{
				return objContactList.getPersonName();
			}
		}catch(Exception e){}
	}
	return "";
}

public String getInvoiceType(InvoiceMain objInvoiceMain, int iLanguage){
	if(objInvoiceMain != null){
		try{
			if(objInvoiceMain.getType() == 0){
				String strTicket = iLanguage == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Ticket" : "Tiket";
				return strTicket;
			}else{
				String strPackage = iLanguage == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Package" : "Paket";
				return strPackage;
			}
		}catch(Exception e){}
	}
	return "";
}

public boolean getTruedFalse(Vector vectInvoiceMainId, long lInvoiceId){
	for(int i=0;i<vectInvoiceMainId.size();i++){
		long lInvoiceIdSelect = Long.parseLong((String)vectInvoiceMainId.get(i));
		if(lInvoiceIdSelect == lInvoiceId)
			return true;
	}
	return false;
}

public String drawListInvoice(Vector objectClass, int language, int start, Vector vInvoiceId){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");

	ctrlist.dataFormat(strTitle[language][0],"3%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"10%","center","center");
	ctrlist.dataFormat(strTitle[language][3],"30%","center","left");
	ctrlist.dataFormat(strTitle[language][4],"10%","center","right");
	ctrlist.dataFormat(strTitle[language][6],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][5],"10%","center","left");

	ctrlist.setLinkRow(1);
    ctrlist.setLinkSufix("");

	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	InvoiceMain objInvoiceMain = new InvoiceMain();
	ContactList contactList  = new ContactList();
	String strContactName = "";
	String strInvoiceType = "";
	double dAmount = 0.0;
	try{
		for (int i = 0; i < objectClass.size(); i++){
			Vector vTemp = (Vector)objectClass.get(i);
			objInvoiceMain = (InvoiceMain)vTemp.get(0);
			dAmount = Double.parseDouble(vTemp.get(1).toString());
			
			if(objInvoiceMain.getFirstContactId() != 0){
				try{
					contactList = PstContactList.fetchExc(objInvoiceMain.getFirstContactId());
				}catch(Exception e){}	
			}
			
			String status = "";
			if(objInvoiceMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_CANCELLED){
				status = "Void";
			}else{
				status = I_DocStatus.fieldDocumentStatus[objInvoiceMain.getStatus()];
			}
			
			String chk = "";
			 if(getTruedFalse(vInvoiceId,objInvoiceMain.getOID())){
			 	chk = "checked";	
			 }
			 
			strContactName = getContactName(contactList);
			strInvoiceType = getInvoiceType(objInvoiceMain,language);
			Vector rowx = new Vector();
			
			rowx.add("<input type=\"checkbox\" "+chk+" name=\"cb_"+i+"\" value=\""+objInvoiceMain.getOID()+"\">");
			
			rowx.add(objInvoiceMain.getInvoiceNumber());
			rowx.add(Formater.formatDate(objInvoiceMain.getIssuedDate(),"dd-MM-yyyy"));
			rowx.add(strContactName);
			rowx.add("<div align=\"right\">"+FRMHandler.userFormatStringDecimal(dAmount)+"</div>");
			rowx.add(strInvoiceType);
			rowx.add(status);

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(objInvoiceMain.getOID()));
		}
     }catch(Exception e){
	 	System.out.println("EXc : "+e.toString());
	 }		 							
	 return ctrlist.drawMe();
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
long invoiceMainId = FRMQueryString.requestLong(request, "invoice_main_id");
int iQueryType = FRMQueryString.requestInt(request, "query_type");
int recordToGet = 20;
int vectSize = 0;

// ControlLine and Commands caption
ControlLine ctrlLine = new ControlLine();
ctrlLine.initDefault(SESS_LANGUAGE,"");
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Invoice" : "Invoice";
String strAdd = ctrlLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrlLine.CMD_ADD,true);
String strBack = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Back To Invoice Search" : "Kembali Ke Pencarian Invoice";
String strCmdPosted = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Update Status" : "Ubah Status"; 
String strPosted1 = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "System will change document status to Draft" : "Sistem akan merubah status dokumen menjadi Draft";
String strPosted2 = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are you sure to change status to draft?" : "Apakah anda yakin untuk ubah status ke draft?";
String strPosted3 = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "can not be edit after posting process." : "tidak bisa diubah setelah proses posting.";

SrcInvoice srcInvoice = new SrcInvoice();
FrmSrcInvoice frmSrcInvoice = new FrmSrcInvoice(request);

if((iCommand == Command.BACK) && (session.getValue("WHERE_CLAUSE")!=null)){
	srcInvoice = (SrcInvoice)session.getValue("WHERE_CLAUSE");
}else{
	frmSrcInvoice.requestEntityObject(srcInvoice);
}

/*try{
	session.removeValue("WHERE_CLAUSE");
}catch(Exception e){
	System.out.println("--- Remove session error ---");
}*/

if((iCommand==Command.NEXT)||(iCommand==Command.FIRST)||(iCommand==Command.PREV)
        ||(iCommand==Command.LAST)||(iCommand==Command.NONE))
{
	try	{
		srcInvoice = (SrcInvoice)session.getValue("WHERE_CLAUSE");
	}catch(Exception e){
	srcInvoice = new SrcInvoice();
		
	}
}



if(srcInvoice == null){
	srcInvoice = new SrcInvoice();
}

session.putValue("WHERE_CLAUSE", srcInvoice);

SessInvoice sessInvoice = new SessInvoice();
try{
	vectSize = sessInvoice.totalInvoice(srcInvoice,I_DocStatus.DOCUMENT_STATUS_TO_BE_APPROVED);
}catch(Exception e){}


if(iCommand!=Command.BACK){
	/*if((iCommand==Command.NONE)||(iCommand==Command.LIST))
	{
		iCommand = Command.LAST;	
	}*/
	CtrlInvoiceMain ctrlInvoiceMain = new CtrlInvoiceMain(request);
	start = ctrlInvoiceMain.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

    //System.out.println("--- Remove session error ---");
String strOrderBy = " ORDER BY "+PstInvoiceMain.fieldNames[PstInvoiceMain.FLD_INV_MAIN_ID];	
Vector vListInvoice = new Vector(1,1);

    try{	
	System.out.println("srcInvoice.getInvoiceStatus() ::::::::: "+srcInvoice.getInvoiceStatus());
	vListInvoice = sessInvoice.listInvoice(start,recordToGet,srcInvoice,strOrderBy,I_DocStatus.DOCUMENT_STATUS_REVISED);
    }catch(Exception e){}  


Vector vInvoiceId = new Vector(1,1);
long bookType = 0;
long periodeOID = 0;
long lCurrType = 0;
long lDepartmentId = 0;
Vector vDept = new Vector(1,1);
try{
	bookType = Long.parseLong(PstSystemProperty.getValueByName("BOOK_TYPE"));
}catch(Exception e){}
if(bookType != 0){
	lCurrType = bookType;
}

try{
	periodeOID = PstPeriode.getCurrPeriodId();
}catch(Exception e){}

try{
	vDept = PstDepartment.list(0, 0, "", "");
}catch(Exception e){ vDept = new Vector();}

InvoiceMain objInvoiceMain = new InvoiceMain();
if(vDept != null && vDept.size() > 0){
	for(int i = 0; i < vDept.size(); i++){
		Department objDepartment = new Department();
		objDepartment = (Department)vDept.get(i);
		if(objDepartment != null){
			lDepartmentId = objDepartment.getOID();
		}
	}
}

int iStatus = 0;
if(vListInvoice != null && vListInvoice.size() > 0){
	for(int l = 0; l < vListInvoice.size(); l++){
		Vector vTemp = (Vector)vListInvoice.get(l);
		InvoiceMain objInvMain = (InvoiceMain)vTemp.get(0);
		if(objInvMain != null){
			if(objInvMain.getStatus() == I_DocStatus.DOCUMENT_STATUS_FINAL){
				iStatus = objInvMain.getStatus();
			}
		}
	}
}

if(iCommand == Command.POST){
	for(int i = 0; i < vListInvoice.size(); i++){
		String strInvoiceId = request.getParameter("cb_"+i);
		if(strInvoiceId != null && strInvoiceId.length() > 0){
			vInvoiceId.add(strInvoiceId);
		}
	}
	
	if(vInvoiceId != null && vInvoiceId.size() > 0){
		for(int p = 0; p < vInvoiceId.size(); p++){
			long lInvoiceMainId = Long.parseLong(vInvoiceId.get(p).toString());
			if(lInvoiceMainId != 0){
				try{
					SessInvoice.updateStatusInvoice(lInvoiceMainId);
				}catch(Exception e){}
			}
		}
	}
} 
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">
<%if(privAdd){%>
function cmdAdd(){
	document.frmsrcorderaktiva.order_aktiva_id.value="0";
	document.frmsrcorderaktiva.command.value="<%=Command.ADD%>";
	document.frmsrcorderaktiva.action="order_aktiva_edit.jsp";
	document.frmsrcorderaktiva.submit();
}
<%}%>

function cmdEdit(oid){
	document.frmsrcorderaktiva.invoice_main_id.value=oid;
	document.frmsrcorderaktiva.query_type.value="<%=iQueryType%>";
	document.frmsrcorderaktiva.command.value="<%=Command.EDIT%>";
	document.frmsrcorderaktiva.action="invoice_edit.jsp";
	document.frmsrcorderaktiva.submit();
}

function cmdPosted(){
	document.frmsrcorderaktiva.command.value="<%=Command.POST%>";
	document.frmsrcorderaktiva.action="update_invoice_list.jsp";
	if(confirm("<%=strPosted1%>\n<%=strPosted2%>")){
	document.frmsrcorderaktiva.submit();
	}
}

function list(){
	document.frmsrcorderaktiva.command.value="<%=Command.LIST%>";
	document.frmsrcorderaktiva.action="update_invoice_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function first(){
	document.frmsrcorderaktiva.command.value="<%=Command.FIRST%>";
	document.frmsrcorderaktiva.action="update_invoice_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function prev(){
	document.frmsrcorderaktiva.command.value="<%=Command.PREV%>";
	document.frmsrcorderaktiva.action="update_invoice_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function next(){
	document.frmsrcorderaktiva.command.value="<%=Command.NEXT%>";
	document.frmsrcorderaktiva.action="update_invoice_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function last(){
	document.frmsrcorderaktiva.command.value="<%=Command.LAST%>";
	document.frmsrcorderaktiva.action="update_invoice_list.jsp";
	document.frmsrcorderaktiva.submit();
}

function cmdBack(){
	document.frmsrcorderaktiva.command.value="<%=Command.BACK%>";
	document.frmsrcorderaktiva.action="update_invoice_search.jsp";
	document.frmsrcorderaktiva.submit();
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=listTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmsrcorderaktiva" method="post" action="">
              <input type="hidden" name="order_aktiva_id" value="0">
			  <input type="hidden" name="invoice_main_id" value="<%=invoiceMainId%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="add_type" value="">			
			  <input type="hidden" name="query_type" value="<%=iQueryType%>">  			  			  
              <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.NONE%>">
			  <table width="100%">
			  	<tr>
				<td>			
                <%if((vListInvoice!=null)&&(vListInvoice.size()>0)){ %>
                  <%
				  FRMHandler objFRMHandler = new FRMHandler();
				  objFRMHandler.setDigitSeparator(sUserDigitGroup);
				  objFRMHandler.setDecimalSeparator(sUserDecimalSymbol);				  
				  out.println(drawListInvoice(vListInvoice, SESS_LANGUAGE, start, vInvoiceId));
				  %>
				</td>
				</tr>
				<tr>
				<td>
                  <%=ctrlLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%>               
                <%} else {%>
				</td>
				</tr>
				<tr>
				<td>
				<table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
				<tr>
				<td>
					<table width="100%" class="listgensellOdd">		
					<tr><td>&nbsp;</td></tr>		
					<tr> 
					  <td><div align="center"><span class="errfont"><%=strTitle[SESS_LANGUAGE][7]%></span></div></td>
					</tr>
					<tr><td>&nbsp;</td></tr>					
				  </table>
				 </td>
				 </tr>
				 </table> 
                <%  }	%>
				</td>
				</tr>
				<tr>
				<td>
              <table width="100%" border="0" cellspacing="2" cellpadding="0">
					<tr>
					  <td height="16" class="command">
					  <%if(iStatus == I_DocStatus.DOCUMENT_STATUS_FINAL){%>
					  		<a href="javascript:cmdPosted()"><%=strCmdPosted%></a> | <a href="javascript:cmdBack()"><%=strBack%></a>
					  <%}else{%>
					  		<a href="javascript:cmdBack()"><%=strBack%></a>
					  <%}%>
					  </td>
					</tr>
              </table>
			  </td>
			  </tr>
			  </table>
            </form>
			<script language="javascript">
				<%if(iCommand == Command.POST){%>
					list();
				<%}%>
			</script>
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
<!-- endif of "has access" condition -->
<%}%>