<%@ page language="java" %>
<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.form.contact.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "java.util.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_PERSONNEL); %>
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
	"Kode","Nama Depan","Nama Belakang","Kelompok Kontak","Handphone",
	"Alamat","Kota","Propinsi","Negara","Telepon","Fax","Alamat Kirim","Email",
	"No Rekening","No Rekening 2","Catatan"
	},	
	
	{
	"Code","First Name","Last Name","Contact Class","Handphone",
	"Address","City","Province","Country","Phone","Fax","Directions","Email",
	"Bank Account", "Bank Account 2", "Notes"
	}
};

public static final String masterTitle[] = {
	"Input","Entry"	
};

public static final String personTitle[] = {
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
<!-- JSP Block -->
<%
/* GET REQUEST FROM HIDDEN TEXT */
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
long contactPslOID = FRMQueryString.requestLong(request,"person_oid");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");

/* VARIABLE DECLARATION */
boolean sameContactCode = false;
int recordToGet = 2;
String whereClause = " "+PstContactList.fieldNames[PstContactList.FLD_CONTACT_TYPE]+" = '"+PstContactList.EXT_PERSONEL+"' ";
String order = "";
int iErrCode = FRMMessage.ERR_NONE;
String errMsg = "";
Vector listContactCmp = new Vector(1,1);

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = personTitle[SESS_LANGUAGE];
String strAddPerson = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSavePerson = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskPerson = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeletePerson = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackPerson = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";

CtrlContactPersonell ctrlContactPsl = new CtrlContactPersonell(request);
FrmContactPersonell frmContactPsl = ctrlContactPsl.getForm();

Vector cntClass = PstContactClass.listAll();
Vector classAssign = new Vector(1,1);
for(int a=0;a<cntClass.size();a++){
	long oid = FRMQueryString.requestLong(request,"contact_"+a);
	if(oid!=0){
		ContactClassAssign cntAssign = 	new ContactClassAssign();
		cntAssign.setContactClassId(oid);
		cntAssign.setContactId(contactPslOID);
		classAssign.add(cntAssign);
	}
} 

ctrlContactPsl.action(iCommand,contactPslOID,1,1,1,classAssign,sameContactCode);
String whereAssign = " "+PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID]+" = "+contactPslOID;
if(iCommand==Command.EDIT){
	classAssign = PstContactClassAssign.list(0,0,whereAssign,"");
}	

ContactList contact = ctrlContactPsl.getContactPersonell();
contactPslOID = contact.getOID();

iErrCode = ctrlContactPsl.getErrCode();
errMsg = ctrlContactPsl.getMessage();

if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(frmContactPsl.errorSize()<1)){
%>
	<jsp:forward page="contact_personell_list.jsp"> 
	<jsp:param name="start" value="<%=start%>"/>
	<jsp:param name="command" value="<%=Command.BACK%>"/>
	<jsp:param name="person_oid" value="<%=contact.getOID()%>"/>	
	</jsp:forward>
<%	
}
%>
<!-- End of JSP Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<%if((iCommand==Command.SAVE)||(iCommand==Command.ASK)){%>
	window.location="#go";
<%}%>

function cmdCancel(){
	document.frmpersonell.prev_command.value="<%=prevCommand%>";
	document.frmpersonell.command.value="<%=Command.EDIT%>";
	document.frmpersonell.action="contact_personell_edit.jsp";
	document.frmpersonell.submit();
}

function cmdSave(){
	document.frmpersonell.command.value="<%=Command.SAVE%>";
	document.frmpersonell.prev_command.value="<%=prevCommand%>";
	document.frmpersonell.action="contact_personell_edit.jsp";
	document.frmpersonell.submit();
}

function cmdAsk(oid){
	document.frmpersonell.person_oid.value=oid;
	document.frmpersonell.prev_command.value="<%=prevCommand%>";
	document.frmpersonell.command.value="<%=Command.ASK%>";
	document.frmpersonell.action="contact_personell_edit.jsp";
	document.frmpersonell.submit();
}
function cmdDelete(oid){
	document.frmpersonell.person_oid.value=oid;
	document.frmpersonell.prev_command.value="<%=prevCommand%>";
	document.frmpersonell.command.value="<%=Command.DELETE%>";
	document.frmpersonell.action="contact_personell_edit.jsp";
	document.frmpersonell.submit();
}

function cmdConfirmDelete(oid){
	document.frmpersonell.command.value="<%=Command.DELETE%>";
	document.frmpersonell.action="contact_personell_edit.jsp"; 
	document.frmpersonell.submit();
}  

function cmdEdit(oid){
	document.frmpersonell.command.value="<%=Command.EDIT%>";
	document.frmpersonell.person_oid.value =oid;
	document.frmpersonell.action="contact_personell_edit.jsp";
	document.frmpersonell.submit();
}

function cmdBack(){
	document.frmpersonell.command.value="<%=Command.BACK%>";
	document.frmpersonell.action="contact_personell_list.jsp"; 
	document.frmpersonell.submit();
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
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr> 
    <td bgcolor="#0000FF" height="50" ID="TOPTITLE"> 
      <%@ include file = "../../main/header.jsp" %>
    </td>
  </tr>
  <tr> 
    <td bgcolor="#000099" height="20" ID="MAINMENU" class="footer"> 
      <%@ include file = "../../main/menumain.jsp" %>
    </td>
  </tr>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --> 
            <b><%=masterTitle[SESS_LANGUAGE]%> : <font color="#FF3300"><%=currPageTitle.toUpperCase()%></font></b><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmpersonell" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="person_oid" value="<%=contactPslOID%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="ifsave" value="0">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"> 
                    <hr>
                  </td>
                </tr>
              </table>			  
              <table width="100%" border="0" cellspacing="1" cellpadding="1">
                <!--<tr align="left"> 
                  <td width="2%" >&nbsp;</td>
                  <td width="12%" >Contact Type</td>
                  <td width="86%" valign="top"> 
                    <select name="<%//=frmContactPsl.fieldNames[FrmContactPersonell.FRM_CONTACT_TYPE]%>">
                      <option value="<%//=PstContactList.EXT_PERSONEL%>"><%//=PstContactList.fieldNamesContactType[PstContactList.EXT_PERSONEL]%></option>
                    </select>
                    * <%//= frmContactPsl.getErrorMsg(FrmContactPersonell.FRM_CONTACT_TYPE) %></td>
                </tr>
                <tr align="left"> 
                  <td width="2%" height="26" >&nbsp;</td>
                  <td width="12%" height="26" >Reg Date</td>
                  <%
				  /*	Date regDate = new Date();
					if(contact.getRegdate()!=null)
						regDate = contact.getRegdate();	*/				
				  %>
                  <td width="86%" height="26"><%//=Formater.formatDate(regDate,"MMM dd, yyyy")%></td>
                </tr>-->
                <tr align="left"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_CODE]%>" size="10" value="<%=contact.getContactCode()%>">
                    * <%= frmContactPsl.getErrorMsg(FrmContactPersonell.FRM_CODE) %> 
                    <input type="hidden" name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_CONTACT_TYPE]%>" value="<%=PstContactList.EXT_PERSONEL%>">
                  </td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_PERSON_NAME]%>" size="30" value="<%=contact.getPersonName()%>">
                    * <%= frmContactPsl.getErrorMsg(FrmContactPersonell.FRM_PERSON_NAME) %></td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,2,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_PERSON_LAST_NAME]%>" size="30" value="<%=contact.getPersonLastname()%>">
                  </td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,3,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top"> 
                    <%for(int i=0; i < cntClass.size(); i++){ 
									ContactClass contactClass = (ContactClass)cntClass.get(i);
								%>
                    <input type="checkbox" name="contact_<%=i%>" <%if(getStatus(contactClass.getOID(), classAssign)){%>checked<%}%> value="<%=contactClass.getOID()%>">
                    <%=contactClass.getClassName()%>&nbsp; 
                    <%}%>
                    <a name="go"></a>* </td>
                </tr>
                <!--
                <tr align="left"> 
                  <td width="13%"  ><%//=getJspTitle(strTitle,4,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%//=frmContactPsl.fieldNames[FrmContactPersonell.FRM_TELP_MOBILE]%>" size="20" value="<%//=contact.getTelpMobile()%>">
                  </td>
                </tr>
				-->
                <tr align="left" valign="top"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,5,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%">:</td>
                  <td width="86%">&nbsp; 
                    <textarea name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_HOME_ADDRESS]%>" cols="45"><%=contact.getHomeAddr()%></textarea>
                    * <%= frmContactPsl.getErrorMsg(FrmContactPersonell.FRM_HOME_ADDRESS) %></td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,6,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_HOME_TOWN]%>" size="30" value="<%=contact.getHomeTown()%>">
                  </td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,7,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_HOME_PROVINCE]%>" size="30" value="<%=contact.getHomeProvince()%>">
                  </td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,8,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_HOME_COUNTRY]%>" size="30" value="<%=contact.getHomeCountry()%>">
                  </td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,9,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_HOME_TELP]%>" size="15" value="<%=contact.getHomeTelp()%>">
                  </td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,10,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_HOME_FAX]%>" size="15" value="<%=contact.getHomeFax()%>">
                  </td>
                </tr>
                <!--
                <tr align="left"> 
                  <td width="13%"  ><%//=getJspTitle(strTitle,11,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td valign="top" width="1%">:</td>
                  <td valign="top" width="86%">&nbsp; 
                    <input type="text" name="<%//=frmContactPsl.fieldNames[FrmContactPersonell.FRM_DIRECTION]%>" size="30" value="<%//=contact.getDirections()%>">
                  </td>
                </tr>
				-->
                <tr align="left"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,12,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_EMAIL]%>" value="<%=contact.getEmail()%>">
                  </td>
                </tr>
                <tr align="left"> 
                  <td width="13%"  ><%=getJspTitle(strTitle,13,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_BANK_ACC1]%>" size="30" value="<%=contact.getBankAcc()%>">
                  </td>
                </tr>
                <!--
				<tr align="left"> 
                  <td width="13%"  ><%//=getJspTitle(strTitle,14,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <input type="text" name="<%//=frmContactPsl.fieldNames[FrmContactPersonell.FRM_BANK_ACC2]%>" size="30" value="<%//=contact.getBankAcc2()%>">
                  </td>
                </tr>
				-->
                <tr align="left"> 
                  <td width="13%" valign="top"  ><%=getJspTitle(strTitle,15,SESS_LANGUAGE,currPageTitle,false)%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="86%" valign="top">&nbsp; 
                    <textarea name="<%=frmContactPsl.fieldNames[FrmContactPersonell.FRM_NOTES]%>" cols="45"><%=contact.getNotes()%></textarea>
                  </td>
                </tr>
                <tr align="left"> 
                  <td width="13%" valign="top"  >&nbsp;</td>
                  <td width="1%" valign="top">&nbsp;</td>
                  <td width="86%" valign="top">&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td colspan="3" valign="top"  > 
                    <%
					ctrLine.setLocationImg(approot+"/images");						  					
					ctrLine.initDefault();
					ctrLine.setTableWidth("80%");
					String scomDel = "javascript:cmdAsk('"+contactPslOID+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+contactPslOID+"')";
					String scancel = "javascript:cmdEdit('"+contactPslOID+"')";
					ctrLine.setCommandStyle("command");
					ctrLine.setColCommStyle("command");
					ctrLine.setBackCaption(strBackPerson);
					ctrLine.setCancelCaption(strCancel);
					ctrLine.setSaveCaption(strSavePerson);
					ctrLine.setDeleteCaption(strAskPerson);
					ctrLine.setConfirmDelCaption(strDeletePerson);

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
                    <%= ctrLine.draw(iCommand, iErrCode, errMsg)%> </td>
                </tr>
              </table>
            </form>
            <!-- #EndEditable --></td>
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
<!-- #EndTemplate -->
</html>
<!-- endif of "has access" condition -->
<%}%>