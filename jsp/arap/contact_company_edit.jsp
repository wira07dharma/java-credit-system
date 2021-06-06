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
<!--package prochain02 -->
<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.form.contact.*" %>
<%@ page import = "com.dimata.common.session.contact.*" %>
<%//@ page import = "com.dimata.prochain02.entity.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_COMPANY); %>
<%@ include file = "../main/checkuser.jsp" %>
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
	"Kode","Induk","Kelompok Kontak","Nama Perusahaan","Nama Depan Kontak","Nama Belakang Kontak",
	"Alamat","Kota","Propinsi","Negara","Telepon","Handphone","Fax"
	},	
	
	{
	"Code","Reference","Contact Class","Company Name","Person Name","Person Last Name",
	"Address","City","Province","Country","Phone","Handphone","Fax"
	}
};

public static final String masterTitle[] = {
	"Input","Entry"
};

public static final String compTitle[] = {
	"Kontak","Contact"
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

public boolean getStatus(long index, Vector vct){
	if(vct!=null && vct.size()>0){
		for(int i=0; i<vct.size(); i++){
			ContactClassAssign cntAs = (ContactClassAssign)vct.get(i);
			if(index == cntAs.getContactClassId()){
				return true;
			}
		}
	}
	return false;
}
%>
<!-- Jsp Block -->
<%
CtrlContactList ctrlContactList = new CtrlContactList(request);
long oidContactList = FRMQueryString.requestLong(request, "hidden_contact_id");

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
	

Vector cntClass = PstContactClass.listAll();
Vector classAssign = new Vector(1,1);
for(int a=0;a<cntClass.size();a++){
	long oid = FRMQueryString.requestLong(request,"contact_"+a);
	if(oid!=0){
		ContactClassAssign cntAssign = 	new ContactClassAssign();
		cntAssign.setContactClassId(oid);
		cntAssign.setContactId(oidContactList);
		classAssign.add(cntAssign);
	}
}
	
iErrCode = ctrlContactList.action(iCommand , oidContactList,classAssign,sameContactCode);

String whereAssign = " "+PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID]+" = "+oidContactList;
if(iCommand==Command.EDIT){
	classAssign = PstContactClassAssign.list(0,0,whereAssign,"");
}	

errMsg = ctrlContactList.getMessage();
FrmContactList frmContactList = ctrlContactList.getForm();
ContactList contactList = ctrlContactList.getContactList();
oidContactList = contactList.getOID();

whereClause = ""+PstContactList.fieldNames[PstContactList.FLD_CONTACT_TYPE]+" = "+PstContactList.EXT_COMPANY+
			  " OR "+PstContactList.fieldNames[PstContactList.FLD_CONTACT_TYPE]+" = "+PstContactList.OWN_COMPANY;
Vector vectContact = PstContactList.list(0,0,whereClause,"");	
whereClause = "";


if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(frmContactList.errorSize()<1)){
%>
	<jsp:forward page="contact_company_list.jsp"> 
	<jsp:param name="start" value="<%=start%>" />
	<jsp:param name="command" value="<%=Command.BACK%>" />	
	<jsp:param name="hidden_contact_id" value="<%=contactList.getOID()%>" />
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
	document.frm_contactlist.command.value="<%=Command.ADD%>";
	document.frm_contactlist.action="contact_company_edit.jsp";
	document.frm_contactlist.submit();
} 

function cmdCancel(){
	document.frm_contactlist.command.value="<%=Command.CANCEL%>";
	document.frm_contactlist.action="contact_company_edit.jsp";
	document.frm_contactlist.submit();
} 

function cmdEdit(oid){ 
	document.frm_contactlist.command.value="<%=Command.EDIT%>";
	document.frm_contactlist.action="contact_company_edit.jsp";
	document.frm_contactlist.submit(); 
} 

function cmdSave(){
	document.frm_contactlist.command.value="<%=Command.SAVE%>"; 
	document.frm_contactlist.action="contact_company_edit.jsp";
	document.frm_contactlist.submit();
}

function cmdAsk(oid){
	document.frm_contactlist.command.value="<%=Command.ASK%>"; 
	document.frm_contactlist.action="contact_company_edit.jsp";
	document.frm_contactlist.submit();
} 

function cmdConfirmDelete(oid){
	document.frm_contactlist.command.value="<%=Command.DELETE%>";
	document.frm_contactlist.action="contact_company_edit.jsp"; 
	document.frm_contactlist.submit();
}  

function cmdBack(){
	document.frm_contactlist.command.value="<%=Command.BACK%>"; 
	document.frm_contactlist.action="contact_company_list.jsp";
	document.frm_contactlist.submit();
}

function hideObjectForMenuJournal(){
}
	
function hideObjectForMenuReport(){	 
}
	
function hideObjectForMenuPeriod(){
}
	 
function hideObjectForMenuMasterData(){
}

function hideObjectForMenuSystem(){
}

function showObjectForMenu(){ 	
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
		  <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frm_contactlist" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="hidden_contact_id" value="<%=oidContactList%>">
              <table border="0" width="100%">
                <tr> 
                  <td height="8">&nbsp; 
                  </td>
                </tr>
              </table>			  
              <table width="100%" cellspacing="1" cellpadding="1" >
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_CONTACT_CODE]%>" value="<%=contactList.getContactCode()%>" class="formElemen" size="10">
                    * <%=frmContactList.getErrorMsg(FrmContactList.FRM_FIELD_CONTACT_CODE)%> 
                    <input type="hidden" name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_CONTACT_TYPE]%>" value="<%=PstContactList.EXT_COMPANY%>">
                  </td>
                </tr>
                
                <tr align="left"> 
                  <td width="13%" valign="top" nowrap>&nbsp;<%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">
						  <table width="100%">
						  <%
							int iCount = 0;						
							int iMaxColumn = 4;
							int iMaxRow = cntClass.size() / iMaxColumn;
							if(cntClass.size() % iMaxColumn > 0)
							iMaxRow += 1;					   
							for(int r = 0; r < iMaxRow; r++){		
						  %> 
								<tr>
								<%
									for(int i=0; i < iMaxColumn; i++){ 
										ContactClass contactClass = (ContactClass)cntClass.get(iCount);
								%>
								<td>			
									<input type="checkbox" name="contact_<%=i%>" <%if(getStatus(contactClass.getOID(), classAssign)){%>checked<%}%> value="<%=contactClass.getOID()%>">
									<%=contactClass.getClassName()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><%iCount++;%> 
								<%
									if(iCount >= cntClass.size())
										break;
								%>	 
								<%
									}
								%>
								</tr>
						  <%}%>
						  </table>
                    * </td>
                </tr>
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_COMP_NAME]%>" value="<%=contactList.getCompName()%>" class="formElemen" size="40">
                    *<%=frmContactList.getErrorMsg(FrmContactList.FRM_FIELD_COMP_NAME)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_PERSON_NAME]%>" value="<%=contactList.getPersonName()%>" class="formElemen" size="30">
                    <%=frmContactList.getErrorMsg(FrmContactList.FRM_FIELD_PERSON_NAME)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top"> &nbsp; 
                    <input type="text" name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_PERSON_LASTNAME]%>" value="<%=contactList.getPersonLastname()%>" class="formElemen" size="30">
                    <%=frmContactList.getErrorMsg(FrmContactList.FRM_FIELD_PERSON_LASTNAME)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%" valign="top" nowrap>&nbsp;<%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <textarea name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_BUSS_ADDRESS]%>" cols="45" class="formElemen" rows="3"><%=contactList.getBussAddress()%></textarea>
                    * <%=frmContactList.getErrorMsg(FrmContactList.FRM_FIELD_BUSS_ADDRESS)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_TOWN]%>" value="<%=contactList.getTown()%>" class="formElemen" size="30">
                    <%=frmContactList.getErrorMsg(FrmContactList.FRM_FIELD_TOWN)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,8,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_PROVINCE]%>" value="<%=contactList.getProvince()%>" class="formElemen" size="30">
                    <%=frmContactList.getErrorMsg(FrmContactList.FRM_FIELD_PROVINCE)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,9,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_COUNTRY]%>" value="<%=contactList.getCountry()%>" class="formElemen" size="30">
                    <%=frmContactList.getErrorMsg(FrmContactList.FRM_FIELD_COUNTRY)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,10,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_TELP_NR]%>" value="<%=contactList.getTelpNr()%>" class="formElemen" size="15">
                    <%=frmContactList.getErrorMsg(FrmContactList.FRM_FIELD_TELP_NR)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,11,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_TELP_MOBILE]%>" value="<%=contactList.getTelpMobile()%>" class="formElemen" size="20">
                    <%=frmContactList.getErrorMsg(FrmContactList.FRM_FIELD_TELP_MOBILE)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%" nowrap>&nbsp;<%=getJspTitle(strTitle,12,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td  width="1%"  valign="top">:</td>
                  <td  width="86%"  valign="top">&nbsp; 
                    <input type="text" name="<%=FrmContactList.fieldNames[FrmContactList.FRM_FIELD_FAX]%>" value="<%=contactList.getFax()%>" class="formElemen" size="15">
                    <%=frmContactList.getErrorMsg(FrmContactList.FRM_FIELD_FAX)%></td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  valign="top" >&nbsp;</td>
                  <td  width="1%"  valign="top">&nbsp;</td>
                  <td  width="86%"  valign="top">&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td colspan="3"  valign="top"  > 
                    <%
							ctrLine.setLocationImg(approot+"/images");						  					
							ctrLine.initDefault();
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidContactList+"')";
							String sconDelCom = "javascript:cmdConfirmDelete('"+oidContactList+"')";
							String scancel = "javascript:cmdEdit('"+oidContactList+"')";
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setBackCaption(strBackComp);
							ctrLine.setCancelCaption(strCancel);
							ctrLine.setSaveCaption(strSaveComp);
							ctrLine.setDeleteCaption(strAskComp);
							ctrLine.setConfirmDelCaption(strDeleteComp);

							if (privDelete){
								ctrLine.setConfirmDelCommand(sconDelCom);
								ctrLine.setDeleteCommand(scomDel);
								ctrLine.setEditCommand(scancel);
							}else{ 
								ctrLine.setConfirmDelCaption("");
								ctrLine.setDeleteCaption("");
								ctrLine.setEditCaption("");
							}

							if(privAdd == false  && privUpdate == false){
								ctrLine.setSaveCaption("");
							}

							if (privAdd == false){
								ctrLine.setAddCaption("");
							}
							
							if(iCommand==Command.ASK)
								ctrLine.setDeleteQuestion(delConfirm);								
							
							%>
                    <%= ctrLine.draw(iCommand, iErrCode, errMsg)%></td>
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
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>