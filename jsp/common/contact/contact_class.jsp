<% 
/* 
 * Page Name  		:  contactclass.jsp
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
<%//@ page import = "com.dimata.prochain02.entity.admin.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_COMPANY_CLASS); %>
<%@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

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

<!-- Jsp Block -->
<%!
public static String strTitle[][] = {
	{"Nama","Tipe","Keterangan"},	
	{"Name","Type","Description"}
};

public static final String masterTitle[] = {
	"Kontak","Contact"	
};

public static final String classTitle[] = {
	"Kelompok Kontak","Contact Class"	
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

public String drawList(int language, int iCommand, FrmContactClass frmObject, ContactClass objEntity, Vector objectClass, long contactClassId)
{
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("60%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");	
	ctrlist.dataFormat(strTitle[language][0],"20%","left","left");
	ctrlist.dataFormat(strTitle[language][1],"20%","left","left");
	ctrlist.dataFormat(strTitle[language][2],"60%","left","left");

	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);
	ctrlist.reset();
	int index = -1;

	/*
    public static final int CONTACT_TYPE_TRAVEL_AGENT       = 0;
    public static final int CONTACT_TYPE_SUPPLIER           = 1;
    public static final int CONTACT_TYPE_GUIDE              = 2;
    public static final int CONTACT_TYPE_COMPANY            = 3;
    public static final int CONTACT_TYPE_EMPLOYEE	    	= 4;        
    public static final int FLD_CLASS_SHIPPER               = 5;
    public static final int FLD_CLASS_CLIENT                = 6;
    public static final int CONTACT_TYPE_MEMBER             = 7;    
    public static final int FLD_CLASS_VENDOR                = 8;
    public static final int FLD_CLASS_OTHERS                = 9;    

	*/
	
	Vector val_typeid = new Vector(1,1); 
	Vector key_typeid = new Vector(1,1); 

	//val_typeid.add(""+PstContactClass.CONTACT_TYPE_TRAVEL_AGENT);
	//key_typeid.add(PstContactClass.fieldClassType[PstContactClass.CONTACT_TYPE_TRAVEL_AGENT]);

	val_typeid.add(""+PstContactClass.CONTACT_TYPE_SUPPLIER);
	key_typeid.add(PstContactClass.fieldClassType[PstContactClass.CONTACT_TYPE_SUPPLIER]);

	//val_typeid.add(""+PstContactClass.CONTACT_TYPE_GUIDE);
	//key_typeid.add(PstContactClass.fieldClassType[PstContactClass.CONTACT_TYPE_GUIDE]);

	//val_typeid.add(""+PstContactClass.CONTACT_TYPE_COMPANY);
	//key_typeid.add(PstContactClass.fieldClassType[PstContactClass.CONTACT_TYPE_COMPANY]);

	val_typeid.add(""+PstContactClass.CONTACT_TYPE_EMPLOYEE);
	key_typeid.add(PstContactClass.fieldClassType[PstContactClass.CONTACT_TYPE_EMPLOYEE]);

	//val_typeid.add(""+PstContactClass.FLD_CLASS_SHIPPER);
	//key_typeid.add(PstContactClass.fieldClassType[PstContactClass.FLD_CLASS_SHIPPER]);

	//val_typeid.add(""+PstContactClass.FLD_CLASS_VENDOR);
	//key_typeid.add(PstContactClass.fieldClassType[PstContactClass.FLD_CLASS_VENDOR]);

	val_typeid.add(""+PstContactClass.CONTACT_TYPE_MEMBER);
	key_typeid.add(PstContactClass.fieldClassType[PstContactClass.CONTACT_TYPE_MEMBER]);

	//val_typeid.add(""+PstContactClass.FLD_CLASS_CLIENT);
	//key_typeid.add(PstContactClass.fieldClassType[PstContactClass.FLD_CLASS_CLIENT]);

	val_typeid.add(""+PstContactClass.FLD_CLASS_OTHERS);
	key_typeid.add(PstContactClass.fieldClassType[PstContactClass.FLD_CLASS_OTHERS]);


	String select_typeid = ""+objEntity.getClassType();	
	for(int i=0; i<objectClass.size(); i++) 
	{
		 ContactClass contactClass = (ContactClass)objectClass.get(i);
		 rowx = new Vector();
		 if(contactClassId == contactClass.getOID())
			 index = i; 
			 
		 select_typeid = ""+contactClass.getClassType();
		 if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK))
		 {
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmContactClass.FRM_FIELD_CLASS_NAME] +"\" value=\""+contactClass.getClassName()+"\" class=\"elemenForm\">");
			rowx.add(""+ControlCombo.draw(frmObject.fieldNames[frmObject.FRM_FIELD_CLASS_TYPE], null, select_typeid, val_typeid, key_typeid)+"");
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmContactClass.FRM_FIELD_CLASS_DESCRIPTION] +"\"  class=\"elemenForm\" value=\""+contactClass.getClassDescription()+"\" size=\"70\">");
		 }
		 else
		 {
			rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(contactClass.getOID())+"')\">"+contactClass.getClassName()+"</a>");
			rowx.add(PstContactClass.fieldClassType[contactClass.getClassType()]);
			rowx.add(contactClass.getClassDescription());
		 } 

		 lstData.add(rowx);
	}

	rowx = new Vector();
	if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmObject.errorSize()>0))
	{ 
		rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmContactClass.FRM_FIELD_CLASS_NAME] +"\" value=\""+objEntity.getClassName()+"\" class=\"elemenForm\">");
		rowx.add(""+ControlCombo.draw(frmObject.fieldNames[frmObject.FRM_FIELD_CLASS_TYPE], null, select_typeid, val_typeid, key_typeid)+"");				
		rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmContactClass.FRM_FIELD_CLASS_DESCRIPTION] +"\"  class=\"elemenForm\" value=\""+objEntity.getClassDescription()+"\" size=\"70\">");
	}
	lstData.add(rowx);
	return ctrlist.drawMe(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidContactClass = FRMQueryString.requestLong(request, "hidden_contact_class_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

/**
* Setup controlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = classTitle[SESS_LANGUAGE];
String strAddCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strBackCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strDeleteCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";

CtrlContactClass ctrlContactClass = new CtrlContactClass(request);
Vector listContactClass = new Vector(1,1);

iErrCode = ctrlContactClass.action(iCommand , oidContactClass);
FrmContactClass frmContactClass = ctrlContactClass.getForm();

int vectSize = PstContactClass.getCount(whereClause); 

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlContactClass.actionList(iCommand, start, vectSize, recordToGet);
} 

ContactClass contactClass = ctrlContactClass.getContactClass();
msgString =  ctrlContactClass.getMessage();

listContactClass = PstContactClass.list(start,recordToGet, whereClause , orderClause);

if (listContactClass.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet; 
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 listContactClass = PstContactClass.list(start,recordToGet, whereClause , orderClause);
}
%>
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--

function cmdAdd(){
	document.frmcontactclass.hidden_contact_class_id.value="0";
	document.frmcontactclass.command.value="<%=Command.ADD%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="contact_class.jsp";
	document.frmcontactclass.submit();
}

function cmdAsk(oidContactClass){
	document.frmcontactclass.hidden_contact_class_id.value=oidContactClass;
	document.frmcontactclass.command.value="<%=Command.ASK%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="contact_class.jsp";
	document.frmcontactclass.submit();
}

function cmdConfirmDelete(oidContactClass){
	document.frmcontactclass.hidden_contact_class_id.value=oidContactClass;
	document.frmcontactclass.command.value="<%=Command.DELETE%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="contact_class.jsp";
	document.frmcontactclass.submit();
}

function cmdSave(){
	document.frmcontactclass.command.value="<%=Command.SAVE%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="contact_class.jsp";
	document.frmcontactclass.submit();
}

function cmdEdit(oidContactClass){
	document.frmcontactclass.hidden_contact_class_id.value=oidContactClass;
	document.frmcontactclass.command.value="<%=Command.EDIT%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="contact_class.jsp";
	document.frmcontactclass.submit();
}

function cmdCancel(oidContactClass){
	document.frmcontactclass.hidden_contact_class_id.value=oidContactClass;
	document.frmcontactclass.command.value="<%=Command.EDIT%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="contact_class.jsp";
	document.frmcontactclass.submit();
}

function cmdBack(){
	document.frmcontactclass.command.value="<%=Command.BACK%>";
	document.frmcontactclass.action="contact_class.jsp";
	document.frmcontactclass.submit();
}

function first(){
	document.frmcontactclass.command.value="<%=Command.FIRST%>";
	document.frmcontactclass.prev_command.value="<%=Command.FIRST%>";
	document.frmcontactclass.action="contact_class.jsp";
	document.frmcontactclass.submit();
}

function prev(){
	document.frmcontactclass.command.value="<%=Command.PREV%>";
	document.frmcontactclass.prev_command.value="<%=Command.PREV%>";
	document.frmcontactclass.action="contact_class.jsp";
	document.frmcontactclass.submit();
}

function next(){
	document.frmcontactclass.command.value="<%=Command.NEXT%>";
	document.frmcontactclass.prev_command.value="<%=Command.NEXT%>";
	document.frmcontactclass.action="contact_class.jsp";
	document.frmcontactclass.submit();
}

function last(){
	document.frmcontactclass.command.value="<%=Command.LAST%>";
	document.frmcontactclass.prev_command.value="<%=Command.LAST%>";
	document.frmcontactclass.action="contact_class.jsp";
	document.frmcontactclass.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidContactClass){
	document.frmimage.hidden_contact_class_id.value=oidContactClass;
	document.frmimage.command.value="<%=Command.POST%>";
	document.frmimage.action="contact_class.jsp";
	document.frmimage.submit();
}

//-------------- script control line -------------------
//-->
</script>
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
/*function hideObjectForMarketing(){    
} 
	 
function hideObjectForWarehouse(){ 
}
	
function hideObjectForProduction(){
}
	
function hideObjectForPurchasing(){
}

function hideObjectForAccounting(){
}

function hideObjectForHRD(){
}

function hideObjectForGallery(){
}

function hideObjectForMasterData(){
}*/

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

</SCRIPT>
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
            Masterdata &gt; <%=masterTitle[SESS_LANGUAGE]%> &gt; <%=currPageTitle%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmcontactclass" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_contact_class_id" value="<%=oidContactClass%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr align="left" valign="top"> 
                        <td height="8" valign="middle" colspan="3"> 
                          <hr>
                        </td>
                      </tr>
                      <%
							try{
							%>
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> <%= drawList(SESS_LANGUAGE,iCommand,frmContactClass, contactClass,listContactClass,oidContactClass)%> </td>
                      </tr>
                      <% 
						  }catch(Exception exc){ 
						  }%>
                      <tr align="left" valign="top"> 
                        <td height="8" align="left" colspan="3" class="command"> 
                          <span class="command"> 
                          <% 
						   int cmd = 0;
							   if ((iCommand == Command.FIRST || iCommand == Command.PREV )|| 
								(iCommand == Command.NEXT || iCommand == Command.LAST))
									cmd =iCommand; 
						   else{
							  if(iCommand == Command.NONE || prevCommand == Command.NONE)
								cmd = Command.FIRST;
							  else 
								cmd =prevCommand; 
						   } 
						 %>
                         <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"first","prev","next","last","left")%></span> </td>
                      </tr>
                      <%if(privAdd && (iErrCode==CtrlContactClass.RSLT_OK)&&(iCommand!=Command.ADD)&&(iCommand!=Command.ASK)&&(iCommand!=Command.EDIT)&&(frmContactClass.errorSize()==0)){ %>
					  					  
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> 
						<a href="javascript:cmdAdd()" class="command"><%=strAddCls%></a>
                        </td>
                      </tr>
                      <%}%>					  
                    </table>
                  </td>
                </tr>
                <tr align="left" valign="top" > 
                  <td colspan="3" class="command"> 
                    <% 
					ctrLine.setLocationImg(approot+"/images");						  					
					ctrLine.initDefault();
					ctrLine.setTableWidth("80%");
					String scomDel = "javascript:cmdAsk('"+oidContactClass+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidContactClass+"')";
					String scancel = "javascript:cmdEdit('"+oidContactClass+"')";
					ctrLine.setCommandStyle("command");
					ctrLine.setColCommStyle("command");
					ctrLine.setCancelCaption(strCancel);
					ctrLine.setBackCaption(strBackCls);
					ctrLine.setSaveCaption(strSaveCls);
					ctrLine.setDeleteCaption(strAskCls);
					ctrLine.setConfirmDelCaption(strDeleteCls);

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
					
					if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmContactClass.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                    <%=ctrLine.draw(iCommand, iErrCode, msgString)%> 
                    <%}%>
                  </td>
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