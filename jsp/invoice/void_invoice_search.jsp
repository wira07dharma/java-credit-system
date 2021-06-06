<%@ page language="java" %>

<!-- import java -->
<%@ page import="java.util.*,
                 com.dimata.aiso.session.invoice.*,
				 com.dimata.aiso.entity.search.SrcInvoice,
				 com.dimata.aiso.form.search.FrmSrcInvoice,
                 com.dimata.aiso.entity.invoice.*,
				 com.dimata.common.entity.contact.*,
                 com.dimata.aiso.form.periode.CtrlPeriode,
                 com.dimata.aiso.form.search.FrmSrcOrderAktiva" %>
<%@ page import="java.util.Date" %>

<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>

<!-- import aiso -->
<!-- import qdep -->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_LEDGER, AppObjInfo.G2_GNR_LEDGER, AppObjInfo.OBJ_GNR_LEDGER); %>
<%@ include file = "../main/checkuser.jsp" %>

<%!
public static final int ADD_TYPE_SEARCH = 0;
public static final int ADD_TYPE_LIST = 1;
%>

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
}else{
%>

<!-- JSP Block -->
<%!
public static String strTitle[][] =
{
	{
		"Nomor Invoice",
		"Pelanggan",
		"Tanggal",
        "Semua Tanggal",
		"Dari",
		"s / d",
		"Tipe Invoice",
		"Status Invoice"
	},
	{
		"Invoice Number",
		"Customer",
        "All Date",
        "Date",
        "From",
        "To",
		"Invoice Type",
		"Invoice Status"
	}
};

public static final String masterTitle[] =
{
	"Pencarian","Inquiries"
};

public static final String searchTitle[] =
{
	"Membatalkan Invoice","Voiding Invoice"
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

public String getJspTitle(String textJsp[][], int index, int language, String prefiks, boolean addBody)
{
	String result = "";
	if(addBody)
	{
		if(language==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT)
		{
			result = textJsp[language][index] + " " + prefiks;
		}
		else
		{
			result = prefiks + " " + textJsp[language][index];
		}
	}
	else
	{
		result = textJsp[language][index];
	}
	return result;
}
%>


<%
int iCommand = FRMQueryString.requestCommand(request);
String strNomorInvoice = FRMQueryString.requestString(request,"nomor_invoice");
String strContactName = FRMQueryString.requestString(request,"contact_name");
long lContactId = FRMQueryString.requestLong(request,"contact_id");
int iQueryType = FRMQueryString.requestInt(request, "query_type");

SrcInvoice srcInvoice = new SrcInvoice();
FrmSrcInvoice frmSrcInvoice = new FrmSrcInvoice();
frmSrcInvoice.requestEntityObject(srcInvoice);
if(session.getValue("WHERE_CLAUSE") != null){
	try{
		session.removeValue("WHERE_CLAUSE");
	}catch(Exception e){}
}

try{
	session.putValue("WHERE_CLAUSE",srcInvoice);
}catch(Exception e){}

ContactList cntList = new ContactList();
String contactName = "";
if(srcInvoice.getContactId() != 0){
	try{
		cntList = PstContactList.fetchExc(srcInvoice.getContactId());
		if(cntList != null){
			contactName = getContactName(cntList);
		}
	}catch(Exception e){cntList = new ContactList();}
}

// ControlLine and Commands caption
ControlLine ctrLine = new ControlLine();
String currPageTitle = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Invoice" : "Invoice";
String strAdd = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSearch = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SEARCH,true);

CtrlPeriode ctrlperiode = new CtrlPeriode(request);
int periodStatus = ctrlperiode.getStatusPeriod();
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdSearch(qType){
	document.<%=FrmSrcInvoice.FRM_INVOICE%>.query_type.value=qType;
	document.<%=FrmSrcInvoice.FRM_INVOICE%>.command.value="<%=Command.LIST%>";
	document.<%=FrmSrcInvoice.FRM_INVOICE%>.action="void_invoice_list.jsp";
	document.<%=FrmSrcInvoice.FRM_INVOICE%>.submit();
}

function cmdopen(){
	var url = "srccontact_list.jsp?cnt_type=3";
    window.open(url,"search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

function getThn(){
	var date1 = ""+document.<%=FrmSrcInvoice.FRM_INVOICE%>.<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_START_DATE]%>.value;
	var thn = date1.substring(6,10);
	var bln = date1.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}
	
	var hri = date1.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}
	
	document.<%=FrmSrcInvoice.FRM_INVOICE%>.<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_START_DATE]%>_mn.value=bln;
	document.<%=FrmSrcInvoice.FRM_INVOICE%>.<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_START_DATE]%>_dy.value=hri;
	document.<%=FrmSrcInvoice.FRM_INVOICE%>.<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_START_DATE]%>_yr.value=thn;
	
	var date2 = ""+document.<%=FrmSrcInvoice.FRM_INVOICE%>.<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_END_DATE]%>.value;
	var thn1 = date2.substring(6,10);
	var bln1 = date2.substring(3,5);	
	if(bln1.charAt(0)=="0"){
		bln1 = ""+bln1.charAt(1);
	}
	
	var hri1 = date2.substring(0,2);
	if(hri1.charAt(0)=="0"){
		hri1 = ""+hri1.charAt(1);
	}
	
	document.<%=FrmSrcInvoice.FRM_INVOICE%>.<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_END_DATE]%>_mn.value=bln1;
	document.<%=FrmSrcInvoice.FRM_INVOICE%>.<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_END_DATE]%>_dy.value=hri1;
	document.<%=FrmSrcInvoice.FRM_INVOICE%>.<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_END_DATE]%>_yr.value=thn1;		
}
function hideObjectForDate(){
}
	
function showObjectForDate(){
}	
</script>
<link rel="stylesheet" href="../style/calendar.css" type="text/css">
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
		  <%if(isUseDatePicker.equalsIgnoreCase("Y")){%> 
      		<table class="ds_box" cellpadding="0" cellspacing="0" id="ds_conclass" style="display: none;">
			<tr><td id="ds_calclass">
			</td></tr>
			</table>
			<script language=JavaScript src="<%=approot%>/main/calendar.js"></script>
			<%}%>	
		  <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=searchTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="<%=FrmSrcInvoice.FRM_INVOICE%>" method="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="add_type" value="">
			  <input type="hidden" name="query_type" value="<%=iQueryType%>">
              <table width="100%" border="0" cellspacing="3" cellpadding="2">
                <tr>
                  <td colspan="3">&nbsp;
                    
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_INV_NUMBER]%>" size="20" value="<%=srcInvoice.getInvoice_number() != null? srcInvoice.getInvoice_number() : ""%>">
                  </td>
                </tr>
                <tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
                    <input type="text" readOnly name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_CONTACT_ID]%>_TEXT" value="<%=contactName != null? contactName : ""%>">&nbsp;<a href="javascript:cmdopen()"><img alt="search contact" border="0" src="<%=approot%>/dtree/img/folderopen.gif"></a>
					<input type="hidden" name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_CONTACT_ID]%>" size="50" value="<%=srcInvoice.getContactId()%>">
                  </td>
                </tr>
				<tr>
                  <td width="16%" nowrap><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%">
				  <%
                   Vector type_value = new Vector(1,1);
				   Vector type_key = new Vector(1,1);
				   String sel_type = ""+srcInvoice.getInvoiceType();
				   String strAll = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "All Type" : "Semua Tipe";
				   String strTicket = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Ticket" : "Tiket";
				   String strPackage = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "Package" : "Paket";
					type_value.add(strAll);
					type_key.add("0");
					type_value.add(strTicket);
					type_key.add("1");
					type_value.add(strPackage);
					type_key.add("2");
						
				 %>    
				 <%= ControlCombo.draw(FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_INVOICE_TYPE],null, sel_type, type_key, type_value, "", "") %>  
                  </td>
                </tr>
                <tr>
                  <td height="80%" nowrap><%=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td><b>:</b></td>
                  <td>
				  	<%
                   Vector sts_value = new Vector(1,1);
				   Vector sts_key = new Vector(1,1);
				   String sel_sts = ""+srcInvoice.getInvoiceStatus();
				   String strAllStatus = SESS_LANGUAGE == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN? "All Status" : "Semua Status";
				   String strFinal = I_DocStatus.fieldDocumentStatus[I_DocStatus.DOCUMENT_STATUS_FINAL];
				   String strVoid = "Void";
					sts_value.add(strAllStatus);
					sts_key.add("0");
					sts_value.add(strFinal);
					sts_key.add(""+I_DocStatus.DOCUMENT_STATUS_FINAL);
					sts_value.add(strVoid);
					sts_key.add(""+I_DocStatus.DOCUMENT_STATUS_CANCELLED);
						
				 %>    
				 <%= ControlCombo.draw(FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_INVOICE_STATUS],null, sel_sts, sts_key, sts_value, "", "") %>
				  </td>
                </tr>
                <tr>
                  <td width="16%" height="80%"><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%"><b>:</b></td>
                  <td width="83%"><input name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_DATE_TYPE]%>" type="radio" value="<%=FrmSrcInvoice.ALL_DATE%>" <%if(srcInvoice.getDateType() == FrmSrcInvoice.ALL_DATE){%>checked<%}%>>
                    <%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%>
                  </td>
                </tr>
                <tr>
                  <td height="80%">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td><input name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_DATE_TYPE]%>" type="radio" value="<%=FrmSrcInvoice.SELECTED_DATE%>" <%if(srcInvoice.getDateType() == FrmSrcInvoice.SELECTED_DATE){%>checked<%}%>>
                    <%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%>
					<input onClick="ds_sh(this);" name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_START_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((srcInvoice.getStartDate() == null? new Date() : srcInvoice.getStartDate()), "dd-MM-yyyy")%>"/>
				    <input type="hidden" name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_START_DATE]%>_mn">
				    <input type="hidden" name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_START_DATE]%>_dy">
				    <input type="hidden" name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_START_DATE]%>_yr">
                    <%
                        /*Date dtTransactionDate = srcOrderAktiva.getTanggalAwal();
                        if(dtTransactionDate ==null)
                        {
                            dtTransactionDate = new Date();
                        }
                        out.println(ControlDate.drawDate(FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AWAL], dtTransactionDate, 0, 5));*/
                    %>
                    <%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%>
					<input onClick="ds_sh(this);" name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_END_DATE]%>" readonly="readonly" style="cursor: text" value="<%=Formater.formatDate((srcInvoice.getEndDate() == null? new Date() : srcInvoice.getEndDate()), "dd-MM-yyyy")%>"/>
				    <input type="hidden" name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_END_DATE]%>_mn">
				    <input type="hidden" name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_END_DATE]%>_dy">
				    <input type="hidden" name="<%=FrmSrcInvoice.fieldNames[FrmSrcInvoice.FRM_END_DATE]%>_yr">
					<script language="JavaScript" type="text/JavaScript">getThn();</script>
                    <%
                        /*dtTransactionDate = srcOrderAktiva.getTanggalakhir();
                        if(dtTransactionDate ==null)
                        {
                            dtTransactionDate = new Date();
                        }
                        out.println(ControlDate.drawDate(FrmSrcOrderAktiva.fieldNames[FrmSrcOrderAktiva.FRM_SEARCH_TANGGAL_AKHIR], dtTransactionDate, 0, 5));*/
                    %>

                    </td>
                </tr>
                <tr>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="16%" height="80%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="83%"><input type="submit" name="Search" value="<%=strSearch%>" onClick="javascript:cmdSearch('<%=iQueryType%>')"></td>
                </tr>
                <%if((privAdd)){%>
                <tr>
                  <td width="16%" height="16">&nbsp;</td>
                  <td width="1%" height="16" class="command">&nbsp;</td>
                  <td width="83%" height="16" class="command">&nbsp;</td>
                </tr>
                <%}%>
              </table>
            </form>
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