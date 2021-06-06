<% 
/* 
 * Page Name  		:  contactlist_edit.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		: karya 
 * @version  		: 01 
 */

/*******************************************************************
 * Page Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 			: [output ...] 
 *******************************************************************/
%>
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package aiso -->
<%@ page import = "com.dimata.aiso.entity.masterdata.Company" %>
<%@ page import = "com.dimata.aiso.form.masterdata.FrmCompany" %>
<%@ page import = "com.dimata.aiso.form.masterdata.CtrlCompany" %>
<%@ page import = "com.dimata.aiso.session.masterdata.SessCompany" %>
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
	"Kode","Nama Perusahaan","Nama Depan Kontak","Nama Belakang Kontak",
	"Alamat","Kota","Propinsi","Negara","Telepon","Handphone","Fax","Email","Kode POS"
	},	
	
	{
	"Code","Company Name","Person Name","Person Last Name",
	"Address","City","Province","Country","Phone","Handphone","Fax","Email","Postal Code"
	}
};

public static final String masterTitle[] = {
	"Input","Entry"	
};

public static final String compTitle[] = {
	"Perusahaan","Company"
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
CtrlCompany ctrlCompany = new CtrlCompany(request);
long oidCompany = FRMQueryString.requestLong(request, "hidden_company_id");

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

System.out.println("iCommand ::: "+iCommand);
iErrCode = ctrlCompany.action(iCommand,oidCompany);

errMsg = ctrlCompany.getMessage();
FrmCompany frmCompany = ctrlCompany.getForm();
Company objCompany = ctrlCompany.getCompany();
oidCompany = objCompany.getOID();


ctrLine.initDefault(SESS_LANGUAGE,currPageTitle);
ctrLine.setBackCaption(strBackComp);
if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(iErrCode < 1)){
%>
	<jsp:forward page="company_list.jsp"> 
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
	document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.ADD%>";
	document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
	document.<%=FrmCompany.FRM_COMPANY%>.submit();
} 

function cmdCancel(){
	document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.CANCEL%>";
	document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
	document.<%=FrmCompany.FRM_COMPANY%>.submit();
} 

function cmdEdit(oid){ 
	document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
	document.<%=FrmCompany.FRM_COMPANY%>.submit(); 
} 

function cmdSave(){
	document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.SAVE%>"; 
	document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
	document.<%=FrmCompany.FRM_COMPANY%>.submit();
}

function cmdDelete(oid){
	document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.ASK%>"; 
	document.<%=FrmCompany.FRM_COMPANY%>.hidden_company_id.value=oid; 
	document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
	document.<%=FrmCompany.FRM_COMPANY%>.submit();
} 

function cmdConfirmDelete(oid){
	document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmCompany.FRM_COMPANY%>.hidden_company_id.value=oid; 
	document.<%=FrmCompany.FRM_COMPANY%>.action="company_edit.jsp";
	document.<%=FrmCompany.FRM_COMPANY%>.submit();
}  

function cmdBack(){
	document.<%=FrmCompany.FRM_COMPANY%>.command.value="<%=Command.BACK%>"; 
	document.<%=FrmCompany.FRM_COMPANY%>.action="company_list.jsp";
	document.<%=FrmCompany.FRM_COMPANY%>.submit();
}


</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<!-- #EndEditable -->
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
            <form name="<%=FrmCompany.FRM_COMPANY%>" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="hidden_company_id" value="<%=oidCompany%>">
              <table border="0" width="100%">
                <tr> 
                  <td height="8">&nbsp; 
                    
                  </td>
                </tr>
              </table>			  
              <table width="100%" cellspacing="1" cellpadding="1" >
                <tr align="left"> 
                  <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_COMPANY_CODE]%>" value="<%=objCompany.getCompanyCode()%>" class="formElemen" size="10">
                  * <%=frmCompany.getErrorMsg(FrmCompany.FRM_COMPANY_CODE)%></td>
                </tr>
                
                
                <tr align="left"> 
                  <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_COMPANY_NAME]%>" value="<%=objCompany.getCompanyName()%>"  size="40">
                    *<%=frmCompany.getErrorMsg(FrmCompany.FRM_COMPANY_NAME)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_PERSON_NAME]%>" value="<%=objCompany.getPersonName()%>" size="30">
                    <%=frmCompany.getErrorMsg(FrmCompany.FRM_PERSON_NAME)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top"> &nbsp; 
                    <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_PERSON_LAST_NAME]%>" value="<%=objCompany.getPersonLastName()%>" size="30">
                    <%=frmCompany.getErrorMsg(FrmCompany.FRM_PERSON_LAST_NAME)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  valign="top"  >&nbsp;<%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <textarea name="<%=FrmCompany.fieldNames[FrmCompany.FRM_BUSS_ADDRESS]%>" cols="45" rows="3"><%=objCompany.getBussAddress()%></textarea>                    
                    * <%=frmCompany.getErrorMsg(FrmCompany.FRM_BUSS_ADDRESS)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_TOWN]%>" value="<%=objCompany.getTown()%>" size="30">
                    <%=frmCompany.getErrorMsg(FrmCompany.FRM_TOWN)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_PROVINCE]%>" value="<%=objCompany.getProvince()%>" size="30">
                    <%=frmCompany.getErrorMsg(FrmCompany.FRM_PROVINCE)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_COUNTRY]%>" value="<%=objCompany.getCountry()%>" size="30">
                    <%=frmCompany.getErrorMsg(FrmCompany.FRM_COUNTRY)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,8,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_TELP_NR]%>" value="<%=objCompany.getPhoneNr()%>" size="15">
                    <%=frmCompany.getErrorMsg(FrmCompany.FRM_TELP_NR)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,9,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_TELP_MOBILE]%>" value="<%=objCompany.getMobilePh()%>" size="20">
                    <%=frmCompany.getErrorMsg(FrmCompany.FRM_TELP_MOBILE)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  >&nbsp;<%=getJspTitle(strTitle,10,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_FAX]%>" value="<%=objCompany.getFax()%>" size="15">
                    <%=frmCompany.getErrorMsg(FrmCompany.FRM_FAX)%></td>
                </tr>
                <tr align="left">
                  <td  >&nbsp;<%=getJspTitle(strTitle,11,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  valign="top">:</td>
                  <td  valign="top">&nbsp;
                      <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_EMAIL_COMPANY]%>" value="<%=objCompany.getCompEmail()%>" size="30">
                      <%=frmCompany.getErrorMsg(FrmCompany.FRM_EMAIL_COMPANY)%></td>
                </tr>
                <tr align="left">
                  <td  >&nbsp;<%=getJspTitle(strTitle,12,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  valign="top">:</td>
                  <td  valign="top">&nbsp;
                    <input type="text" name="<%=FrmCompany.fieldNames[FrmCompany.FRM_POSTAL_CODE]%>" value="<%=objCompany.getPostalCode()%>" size="15">
                    <%=frmCompany.getErrorMsg(FrmCompany.FRM_POSTAL_CODE)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  valign="top" >&nbsp;</td>
                  <td  width="1%"  valign="top">&nbsp;</td>
                  <td  width="86%"  valign="top">&nbsp;</td>
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
                  <td colspan="3"  valign="top"  >
				  <table width="100%"><tr><td><div class="command">
				  <%if(iCommand == Command.ADD){%>
				  <a href="javascript:cmdSave()"><%=strSaveComp%></a>  | <a href="javascript:cmdBack()"><%=strBackComp%></a>
				  <%}else{%>
				  	<%if(iCommand == Command.ASK){%>
						<a href="javascript:cmdConfirmDelete('<%=oidCompany%>')"><%=strDeleteComp%></a> | <a href="javascript:cmdBack()"><%=strCancel%></a>
					<%}else{%>
				  	<a href="javascript:cmdSave()">Save Company</a> | <a href="javascript:cmdDelete('<%=oidCompany%>')"><%=strAskComp%></a> | <a href="javascript:cmdBack()"><%=strBackComp%></a>
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