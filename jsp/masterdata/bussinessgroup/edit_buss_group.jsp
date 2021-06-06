
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.BussinessGroup" %>
<%@ page import = "com.dimata.aiso.form.masterdata.FrmBussGroup" %>
<%@ page import = "com.dimata.aiso.form.masterdata.CtrlBussGroup" %>
<%@ page import = "com.dimata.aiso.session.masterdata.SessBussGroup" %>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_COMPANY); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
if(!privView && !privAdd && !privUpdate && !privDelete){
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
}else{
%>

<%!
public static String strTitle[][] = {
	{
	"Kode","Nama Kelompok Bisnis","Alamat","Kota","Telepon","Fax"
	},	
	
	{
	"Code","Bussiness Group Name","Address","City","Phone","Fax",
	}
};

public static final String masterTitle[] = {
	"Input","Entry"	
};

public static final String compTitle[] = {
	"Kelompok Bisnis","Bussiness Group"
};

public String getJspTitle(String textJsp[][], int index, int language, String prefiks, boolean addBody){
	String result = "";
	if(addBody){
		if(language==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT){	
			result = textJsp[language][index] + " " + prefiks;
		}else{
			result = prefiks + " " + textJsp[language][index];		
		}
	}else{
		result = textJsp[language][index];
	} 
	return result;
}

%>
<!-- Jsp Block -->
<%
CtrlBussGroup ctrlBussGroup = new CtrlBussGroup(request);
long oidBussGroup = FRMQueryString.requestLong(request, "hidden_buss_group_id");

boolean sameContactCode = false;
int iErrCode = FRMMessage.ERR_NONE;
String errMsg = ""; 
String whereClause = "";
String orderClause = "";
int iCommand = FRMQueryString.requestCommand(request);
int pictCommand = FRMQueryString.requestInt(request,"pict_command");
int prevCommand = FRMQueryString.requestInt(request,"prev_command");
int start = FRMQueryString.requestInt(request,"start");

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = compTitle[SESS_LANGUAGE];
String strAddComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
String entryRequired = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Required" : "Wajib Diisi";


iErrCode = ctrlBussGroup.action(iCommand,oidBussGroup);

errMsg = ctrlBussGroup.getMessage();
FrmBussGroup frmBussGroup = ctrlBussGroup.getForm();
BussinessGroup objBussGroup = ctrlBussGroup.getBussGroup();
oidBussGroup = objBussGroup.getOID();


ctrLine.initDefault(SESS_LANGUAGE,currPageTitle);
ctrLine.setBackCaption(strBackComp);
ctrLine.setCancelCaption(strBackComp);
if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(iErrCode < 1)){
%>
	<jsp:forward page="list_buss_group.jsp"> 
	<jsp:param name="start" value="<%=start%>" />
	<jsp:param name="command" value="<%=Command.BACK%>" />	
	</jsp:forward>
<%	
}
%>
<!-- End of Jsp Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdCancel(){
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.command.value="<%=Command.ADD%>";
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.action="edit_buss_group.jsp";
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.submit();
} 

function cmdCancel(){
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.command.value="<%=Command.CANCEL%>";
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.action="edit_buss_group.jsp";
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.submit();
} 

function cmdEdit(oid){ 
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.action="edit_buss_group.jsp";
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.submit(); 
} 

function cmdSave(){
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.command.value="<%=Command.SAVE%>"; 
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.action="edit_buss_group.jsp";
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.submit();
}

function cmdAsk(oid){
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.command.value="<%=Command.ASK%>"; 
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.action="edit_buss_group.jsp";
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.submit();
} 

function cmdConfirmDelete(oid){
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.action="edit_buss_group.jsp"; 
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.submit();
}  

function cmdBack(){
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.command.value="<%=Command.BACK%>"; 
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.action="list_buss_group.jsp";
	document.<%=FrmBussGroup.FRM_BUSS_GROUP%>.submit();
}


</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --><!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
<link rel="StyleSheet" href="../../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
		  <b><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font></b><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmBussGroup.FRM_BUSS_GROUP%>" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="hidden_buss_group_id" value="<%=oidBussGroup%>">
              <table border="0" width="100%">
                <tr> 
                  <td height="8">&nbsp; 
                    
                  </td>
                </tr>
              </table>			  
              <table width="100%" cellspacing="1" cellpadding="1" >
                
                <tr align="left"> 
                  <td width="16%"  >&nbsp;<%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="83%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmBussGroup.fieldNames[FrmBussGroup.FRM_FIELD_CODE]%>" value="<%=objBussGroup.getBussGroupCode()%>" class="formElemen" size="10">
                  * <%=frmBussGroup.getErrorMsg(FrmBussGroup.FRM_FIELD_CODE)%></td>
                </tr>
                
                
                <tr align="left"> 
                  <td width="16%"  >&nbsp;<%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="83%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmBussGroup.fieldNames[FrmBussGroup.FRM_FIELD_NAME]%>" value="<%=objBussGroup.getBussGroupName()%>"  size="40">
                    *<%=frmBussGroup.getErrorMsg(FrmBussGroup.FRM_FIELD_NAME)%></td>
                </tr>
                <tr align="left"> 
                  <td width="16%"  valign="top">&nbsp;<%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="83%"  valign="top">&nbsp;
                    <textarea name="<%=FrmBussGroup.fieldNames[FrmBussGroup.FRM_FIELD_ADDRESS]%>" cols="45" rows="3"><%=objBussGroup.getBussGroupAddress()%></textarea>
                    *
                  <%=frmBussGroup.getErrorMsg(FrmBussGroup.FRM_FIELD_ADDRESS)%></td>
                </tr>
                <tr align="left"> 
                  <td width="16%" nowrap>&nbsp;<%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="83%"  valign="top"> &nbsp;
                    <input type="text" name="<%=FrmBussGroup.fieldNames[FrmBussGroup.FRM_FIELD_CITY]%>" value="<%=objBussGroup.getBussGroupCity()%>" size="30">
                  <%=frmBussGroup.getErrorMsg(FrmBussGroup.FRM_FIELD_CITY)%></td>
                </tr>
                <tr align="left"> 
                  <td width="16%"  valign="top"  >&nbsp;<%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="83%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmBussGroup.fieldNames[FrmBussGroup.FRM_FIELD_PHONE]%>" value="<%=objBussGroup.getBussGroupPhone()%>" size="30">                    
                  <%=frmBussGroup.getErrorMsg(FrmBussGroup.FRM_FIELD_PHONE)%></td>
                </tr>
                <tr align="left"> 
                  <td width="16%"  >&nbsp;<%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="83%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmBussGroup.fieldNames[FrmBussGroup.FRM_FIELD_FAX]%>" value="<%=objBussGroup.getBussGroupFax()%>" size="30">
                    <%=frmBussGroup.getErrorMsg(FrmBussGroup.FRM_FIELD_FAX)%></td>
                </tr>
                <tr align="left">
                  <td colspan="3"  valign="top"  ><div align="center"><em>* = <%=entryRequired%></em></div></td>
                </tr>
                <tr align="left">
                  <td colspan="3"  valign="top"  >&nbsp;</td>
                </tr>
				<%if(iCommand == Command.ASK){%>
				<tr align="left"> 
                  <td width="13%"  colspan="3" class="msgquestion" valign="top" ><%=delConfirm%></td>
                </tr>
				<tr align="left"> 
                  <td width="13%"  valign="top" >&nbsp;</td>
                  <td  width="1%"  valign="top">&nbsp;</td>
                  <td  width="86%"  valign="top">&nbsp;</td>
                </tr>
				<%}%>
                <tr align="left">
                  <td colspan="3"  valign="top"  ><table width="100%"><tr><td><div class="command">
				  <%if(iCommand == Command.ADD){%>
				  <a href="javascript:cmdSave()"><%=strSaveComp%></a>  | <a href="javascript:cmdBack()"><%=strBackComp%></a>
				  <%}else{%>
				  	<%if(iCommand == Command.ASK){%>
						<a href="javascript:cmdConfirmDelete('<%=oidBussGroup%>')"><%=strDeleteComp%></a> | <a href="javascript:cmdBack()"><%=strCancel%></a>
					<%}else{%>
				  	<a href="javascript:cmdSave()">Save Company</a> | <a href="javascript:cmdAsk('<%=oidBussGroup%>')"><%=strAskComp%></a> | <a href="javascript:cmdBack()"><%=strBackComp%></a>
					<%}%>
				  <%}%>
				  </div></td></tr></table>
				  </td>
                </tr>
                <tr align="left"> 
                  <td colspan="3">&nbsp;</td>
                </tr>
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
      <%@ include file = "/main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>