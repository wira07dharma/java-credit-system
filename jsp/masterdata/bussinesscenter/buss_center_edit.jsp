
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@ page import = "com.dimata.aiso.entity.masterdata.BussinessCenter,
		  com.dimata.aiso.session.masterdata.SessBussCenter,
		  com.dimata.aiso.session.masterdata.SessBussGroup,
		  com.dimata.aiso.entity.masterdata.PstBussinessCenter,
		  com.dimata.aiso.entity.masterdata.BussinessGroup,
		  com.dimata.aiso.entity.masterdata.PstBussGroup,
		  com.dimata.aiso.form.masterdata.FrmBussinessCenter,
		  com.dimata.aiso.form.masterdata.CtrlBussinessCenter,
		  com.dimata.common.entity.contact.PstContactList,	
		  com.dimata.common.entity.contact.ContactList,
		  com.dimata.common.entity.contact.PstContactClass"%>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_COMPANY_CLASS); %>
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

<!-- Jsp Block -->
<%!
public static String strTitle[][] = {
	{"No","Nama","Kelompok Bisnis","Kontak","Keterangan"},	
	{"No","Name","Bussiness Group","Contact","Description"}
};

public static final String masterTitle[] = {
	"Daftar","List"	
};

public static final String classTitle[] = {
	"Pusat Bisnis","Bussiness Center"	
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

public String drawList(int language,int iCommand,FrmBussinessCenter frmBussCenter, Vector objectClass, long oidBussCenter, int iStart,Vector vBussGroup,String approot){
	
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");	
	ctrlist.dataFormat(strTitle[language][0],"3%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"22%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"30%","center","left");
	ctrlist.dataFormat(strTitle[language][4],"30%","center","left");

	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);
	ctrlist.reset();
	int index = -1;
	
	Vector vBussGroupVal = new Vector(1,1);
	Vector vBussGroupKey = new Vector(1,1);
	String sSelectedBussGroup = "";
	if(vBussGroup != null && vBussGroup.size() > 0){
		for(int c = 0; c < vBussGroup.size(); c++){
			BussinessGroup objBussGroup = (BussinessGroup)vBussGroup.get(c);
			vBussGroupVal.add(""+objBussGroup.getOID());
			vBussGroupKey.add(objBussGroup.getBussGroupName());
		}
	}

	
try{
	for(int i=0; i<objectClass.size(); i++) {
		 BussinessCenter objBussCenter = (BussinessCenter)objectClass.get(i);
		 sSelectedBussGroup = String.valueOf(objBussCenter.getBussGroupId());	
		 
		 long bussGroupId = objBussCenter.getBussGroupId();
		 BussinessGroup bussGroup = new BussinessGroup();
		 if(bussGroupId != 0)
		 {
		 	try
			{
				bussGroup = PstBussGroup.fetchExc(bussGroupId);
			}
			catch(Exception e){bussGroup = new BussinessGroup();}
		 }
		 
		 
		 long contactId = objBussCenter.getContactId();
		 ContactList objContact = new ContactList();
		 if(contactId != 0){
		 	try
			{
				objContact = PstContactList.fetchExc(contactId);
			}catch(Exception e){objContact = new ContactList();}
		 }	 
		
		//For check record to edit	
		 if(oidBussCenter == objBussCenter.getOID())
		 	index = i;
		 
		 rowx = new Vector(1,1);
		 if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
			rowx.add(""+(i+1));
			rowx.add("<input type=\"text\" name=\""+frmBussCenter.fieldNames[frmBussCenter.FRM_BUSS_CENTER_NAME] +"\" value=\""+objBussCenter.getBussCenterName()+"\" class=\"elemenForm\" size=\"25\">");
			rowx.add(""+ControlCombo.draw(frmBussCenter.fieldNames[frmBussCenter.FRM_BUSS_GROUP_ID], null, sSelectedBussGroup, vBussGroupVal, vBussGroupKey,"","")
					);
			rowx.add("<input type=\"text\" name=\""+frmBussCenter.fieldNames[frmBussCenter.FRM_CONTACT_ID] +"_TEXT\" value=\""+objContact.getCompName()+"\" class=\"elemenForm\" size=\"55\">"+
			"<a href=\"javascript:cmdopen()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>"+
			"<input type=\"hidden\" name=\""+frmBussCenter.fieldNames[frmBussCenter.FRM_CONTACT_ID] +"\" value=\""+contactId+"\" class=\"elemenForm\">");
			rowx.add("<input type=\"text\" name=\""+frmBussCenter.fieldNames[frmBussCenter.FRM_BUSS_CENTER_DESC] +"\" value=\""+objBussCenter.getBussCenterDesc()+"\" class=\"elemenForm\" size=\"55\">");
		}else{		
			rowx.add(""+(i+1));
			rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objBussCenter.getOID())+"')\">"+objBussCenter.getBussCenterName()+"</a>");
			rowx.add(bussGroup.getBussGroupName());
			rowx.add(objContact.getCompName());
			rowx.add(objBussCenter.getBussCenterDesc());			
		} 

		lstData.add(rowx);
	}

	rowx = new Vector();
	if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmBussCenter.errorSize()>0)){ 	
			rowx.add("");
			rowx.add("<input type=\"text\" name=\""+frmBussCenter.fieldNames[frmBussCenter.FRM_BUSS_CENTER_NAME] +"\" value=\"\" class=\"elemenForm\" size=\"25\">");
			rowx.add(""+ControlCombo.draw(frmBussCenter.fieldNames[frmBussCenter.FRM_BUSS_GROUP_ID], null, sSelectedBussGroup, vBussGroupVal, vBussGroupKey,"","")
					);
			rowx.add("<input type=\"text\" name=\""+frmBussCenter.fieldNames[frmBussCenter.FRM_CONTACT_ID] +"_TEXT\" value=\"\" class=\"elemenForm\" size=\"55\">"+
			"<a href=\"javascript:cmdopen()\" disable=\"true\"><img border=\"0\" src=\""+approot+"/dtree/img/folderopen.gif\"></a>"+
			"<input type=\"hidden\" name=\""+frmBussCenter.fieldNames[frmBussCenter.FRM_CONTACT_ID] +"\" value=\"\" class=\"elemenForm\">");
			rowx.add("<input type=\"text\" name=\""+frmBussCenter.fieldNames[frmBussCenter.FRM_BUSS_CENTER_DESC] +"\" value=\"\" class=\"elemenForm\" size=\"55\">");
	}
	
	lstData.add(rowx);
	
	}catch(Exception e){
		System.out.println("Exception on list ::::::: "+e.toString());
	}
	return ctrlist.drawMe(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidBussCenter = FRMQueryString.requestLong(request, "hidden_buss_center_id");

	
/*variable declaration*/
int recordToGet = 100;
String msgString = "";


/**
* Setup controlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = classTitle[SESS_LANGUAGE];
String strAddCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strBackCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strDeleteCls = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";

ctrLine.initDefault(SESS_LANGUAGE,currPageTitle);
ctrLine.setCancelCaption(strBackCls);
CtrlBussinessCenter ctrlBussCenter = new CtrlBussinessCenter(request);
int iErrCode = ctrlBussCenter.action(iCommand , oidBussCenter);
FrmBussinessCenter frmBussCenter = ctrlBussCenter.getForm();
BussinessCenter objBussCenter = ctrlBussCenter.getBussCenter();
msgString =  ctrlBussCenter.getMessage();

int vectSize = SessBussCenter.getCount();
Vector vBussGroup = PstBussGroup.list(0,0,"",PstBussGroup.fieldNames[PstBussGroup.FLD_BUSS_GROUP_NAME]);
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlBussCenter.actionList(iCommand, start, vectSize, recordToGet);
} 

Vector vDataBussCenter = PstBussinessCenter.list(start,recordToGet, "" , PstBussinessCenter.fieldNames[PstBussinessCenter.FLD_BUSS_CENTER_NAME]);

if (vDataBussCenter.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet){
			start = start - recordToGet; 
	 }else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 vDataBussCenter = PstBussinessCenter.list(start,recordToGet, "" , PstBussinessCenter.fieldNames[PstBussinessCenter.FLD_BUSS_CENTER_NAME]);
}

%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){	
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.hidden_buss_center_id.value="0";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.command.value="<%=Command.ADD%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.action="buss_center_edit.jsp";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.submit();
}

function cmdAsk(oidBussCenter){
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.hidden_buss_center_id.value=oidBussCenter;
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.command.value="<%=Command.ASK%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.action="buss_center_edit.jsp";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.submit();
}

function cmdConfirmDelete(oidBussCenter){
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.hidden_buss_center_id.value=oidBussCenter;
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.command.value="<%=Command.DELETE%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.action="buss_center_edit.jsp";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.submit();
}

function cmdSave(){
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.command.value="<%=Command.SAVE%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.action="buss_center_edit.jsp";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.submit();
}

function cmdEdit(oidBussCenter){
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.hidden_buss_center_id.value=oidBussCenter;
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.action="buss_center_edit.jsp";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.submit();
}

function cmdCancel(oidBussCenter){
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.hidden_buss_center_id.value=oidBussCenter;
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.prev_command.value="<%=prevCommand%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.action="buss_center_edit.jsp";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.submit();
}

function cmdBack(){
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.command.value="<%=Command.BACK%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.action="buss_center_edit.jsp";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.submit();
}

function first(){
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.command.value="<%=Command.FIRST%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.prev_command.value="<%=Command.FIRST%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.action="buss_center_edit.jsp";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.submit();
}

function prev(){
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.command.value="<%=Command.PREV%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.prev_command.value="<%=Command.PREV%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.action="buss_center_edit.jsp";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.submit();
}

function next(){
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.command.value="<%=Command.NEXT%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.prev_command.value="<%=Command.NEXT%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.action="buss_center_edit.jsp";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.submit();
}

function last(){
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.command.value="<%=Command.LAST%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.prev_command.value="<%=Command.LAST%>";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.action="buss_center_edit.jsp";
	document.<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>.submit();
}

function cmdopen(){
	var url = "srccontact_list.jsp";
    window.open(url,"search_company","height=500,width=800,status=yes,toolbars=no,menubar=no,location=no,scrollbars=yes");
}

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 

</SCRIPT>
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
           <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="<%=FrmBussinessCenter.FRM_BUSSINESS_CENTER%>" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_buss_center_id" value="<%=oidBussCenter%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr align="left" valign="top"> 
                        <td height="8" valign="middle" colspan="3">&nbsp; 
                          
                        </td>
                      </tr>
                      <%
							try{
							%>
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> 
						<%= drawList(SESS_LANGUAGE,iCommand,frmBussCenter, vDataBussCenter,oidBussCenter,start,vBussGroup,approot)%> </td>
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
								cmd = Command.LAST;
							  else 
								cmd =prevCommand; 
						   } 
						   ctrLine.initDefault();
						 %>
                         <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"first","prev","next","last","left")%></span> </td>
                      </tr>					  
                      <%//if(privAdd && (iErrCode==CtrlContactClass.RSLT_OK)&&(iCommand!=Command.ADD)&&(iCommand!=Command.ASK)&&(iCommand!=Command.EDIT)&&(frmContactClass.errorSize()==0)){ %>
					  					  
                      <!-- <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> 
						<a href="javascript:cmdAdd()" class="command"><%//=strAddCls%></a>
                        </td>
                      </tr> -->
                      <%//}%>					  
                    </table>
                  </td>
                </tr>
                <tr align="left" valign="top" > 
                  <td colspan="3" class="command"> 
                    <% 
					ctrLine.setLocationImg(approot+"/images");						  					
					ctrLine.initDefault();
					ctrLine.setTableWidth("80%");
					String scomDel = "javascript:cmdAsk('"+oidBussCenter+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidBussCenter+"')";
					String scancel = "javascript:cmdEdit('"+oidBussCenter+"')";
					ctrLine.setCommandStyle("command");
					ctrLine.setColCommStyle("command");
					ctrLine.setCancelCaption(strBackCls);
					ctrLine.setBackCaption("");
					ctrLine.setSaveCaption(strSaveCls);
					ctrLine.setDeleteCaption(strAskCls);
					ctrLine.setAddCaption(strAddCls);
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
					}%>
					<%=ctrLine.draw(iCommand, iErrCode, msgString)%> 
					<% if(iCommand==Command.ASK)
						ctrLine.setDeleteQuestion(delConfirm);%>				
					
                    
                  </td>
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
