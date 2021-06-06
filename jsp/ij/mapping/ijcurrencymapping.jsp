<% 
/* 
 * Page Name  		:  ijcurrencymapping.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
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
<%@ page import = "com.dimata.qdep.entity.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package common -->
<%@ page import = "com.dimata.common.entity.payment.*" %>

<!--package ij -->
<%@ page import = "com.dimata.ij.iaiso.*" %>
<%@ page import = "com.dimata.ij.ibosys.*" %>
<%@ page import = "com.dimata.ij.entity.configuration.*" %>
<%@ page import = "com.dimata.ij.entity.mapping.*" %>
<%@ page import = "com.dimata.ij.form.mapping.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%!
public String drawList(int iCommand, FrmIjCurrencyMapping frmObject, IjCurrencyMapping objEntity, Vector objectClass, long ijMapCurrId, int boSystem) 
{
	String strResult = "<div class=\"msginfo\">&nbsp;&nbsp;There is no currency mapping for " + I_IJGeneral.strBoSystem[boSystem] + " system</div>";				
	if( (objectClass!=null && objectClass.size()>0) || iCommand == Command.ADD)
	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("50%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");
		ctrlist.addHeader(I_IJGeneral.strBoSystem[boSystem],"50%");
		ctrlist.addHeader("AISO","50%");
	
		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";
	
		// selected boCurrency
		Hashtable hastBo = new Hashtable();	
		Vector bocurrency_value = new Vector(1,1);
		Vector bocurrency_key = new Vector(1,1);	
		try
		{
			PstIjConfiguration objPstIjConfiguration = new PstIjConfiguration(); 
			IjConfiguration objIjConfiguration = objPstIjConfiguration.getObjIJConfiguration(boSystem, 0, 0);
			String strIjImplBoClassName = objIjConfiguration.getSIjImplClass();        
			
			I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();
			Vector listCurrencyBoSystem = i_bosystem.getListCurrencyType();		
			if(listCurrencyBoSystem!=null && listCurrencyBoSystem.size()>0)
			{
				int maxCurrencyBo = listCurrencyBoSystem.size();
				for(int i=0; i<maxCurrencyBo; i++)
				{
					CurrencyType objCurrencyType = (CurrencyType) listCurrencyBoSystem.get(i);
					bocurrency_value.add(""+objCurrencyType.getOID());
					bocurrency_key.add(objCurrencyType.getName()+"("+objCurrencyType.getCode()+")");		
					hastBo.put(String.valueOf(objCurrencyType.getOID()), objCurrencyType.getName()+"("+objCurrencyType.getCode()+")");		
				}
			}
		}
		catch(Exception e)
		{
			System.out.println("Exc : " + e.toString());
		}
	
		// selected aisoCurrency
		Hashtable hashCurrCommon = new Hashtable();
		Vector commoncurrency_value = new Vector(1,1);
		Vector commoncurrency_key = new Vector(1,1);	
		PstCurrencyType objPstCurrencyType = new PstCurrencyType();
		String strOrder = objPstCurrencyType.fieldNames[objPstCurrencyType.FLD_TAB_INDEX];
		Vector vctCurrencyType = objPstCurrencyType.list(0, 0, "", strOrder);  
		if(vctCurrencyType!=null && vctCurrencyType.size()>0)
		{
			int maxCurrencyType = vctCurrencyType.size();
			for(int i=0; i<maxCurrencyType; i++)
			{
				CurrencyType objCurrencyType = (CurrencyType) vctCurrencyType.get(i);                 					
				commoncurrency_value.add(""+objCurrencyType.getOID());
				commoncurrency_key.add(objCurrencyType.getName()+"("+objCurrencyType.getCode()+")");						
				hashCurrCommon.put(String.valueOf(objCurrencyType.getOID()), objCurrencyType.getName()+"("+objCurrencyType.getCode()+")");
			}
		}
		
		for (int i = 0; i < objectClass.size(); i++) 
		{
			IjCurrencyMapping ijCurrencyMapping = (IjCurrencyMapping)objectClass.get(i);
			rowx = new Vector();
			if(ijMapCurrId == ijCurrencyMapping.getOID())
				 index = i; 
	
			if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK))
			{				
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjCurrencyMapping.FRM_FIELD_BO_CURRENCY],null, ""+ijCurrencyMapping.getBoCurrency(), bocurrency_value , bocurrency_key, "formElemen", ""));			
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjCurrencyMapping.FRM_FIELD_AISO_CURRENCY],null, ""+ijCurrencyMapping.getAisoCurrency(), commoncurrency_value , commoncurrency_key, "formElemen", ""));
			}
			else
			{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(ijCurrencyMapping.getOID())+"')\">"+String.valueOf(hastBo.get(String.valueOf(ijCurrencyMapping.getBoCurrency())))+"</a>");
				rowx.add(String.valueOf(hashCurrCommon.get(String.valueOf(ijCurrencyMapping.getAisoCurrency()))));
			} 
			lstData.add(rowx);
		}
		rowx = new Vector();
	
		if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0))
		{ 
			rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjCurrencyMapping.FRM_FIELD_BO_CURRENCY],null, ""+objEntity.getBoCurrency(), bocurrency_value , bocurrency_key, "formElemen", ""));		
			rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjCurrencyMapping.FRM_FIELD_AISO_CURRENCY],null, ""+objEntity.getAisoCurrency(), commoncurrency_value , commoncurrency_key, "formElemen", ""));
		}
		lstData.add(rowx);
		strResult = ctrlist.draw();
	}
	return strResult;
}
%>


<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidIjCurrencyMapping = FRMQueryString.requestLong(request, "hidden_ij_map_curr_id");
int intBoSystem = FRMQueryString.requestInt(request, FrmIjCurrencyMapping.fieldNames[FrmIjCurrencyMapping.FRM_FIELD_BO_SYSTEM]);
String currMappingTitle = "Currency Mapping";

    if(iCommand == Command.NONE)
        intBoSystem = BO_SYSTEM;

// variable declaration
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = PstIjCurrencyMapping.fieldNames[PstIjCurrencyMapping.FLD_BO_SYSTEM] + "=" + intBoSystem;
String orderClause = "";

CtrlIjCurrencyMapping ctrlIjCurrencyMapping = new CtrlIjCurrencyMapping(request);
iErrCode = ctrlIjCurrencyMapping.action(iCommand, oidIjCurrencyMapping);
FrmIjCurrencyMapping frmIjCurrencyMapping = ctrlIjCurrencyMapping.getForm();
IjCurrencyMapping ijCurrencyMapping = ctrlIjCurrencyMapping.getIjCurrencyMapping();
msgString =  ctrlIjCurrencyMapping.getMessage();

int vectSize = PstIjCurrencyMapping.getCount(whereClause);
if(iCommand == Command.FIRST || iCommand == Command.PREV || iCommand == Command.NEXT || iCommand == Command.LAST)
{
	start = ctrlIjCurrencyMapping.actionList(iCommand, start, vectSize, recordToGet);
} 

Vector listIjCurrencyMapping = PstIjCurrencyMapping.list(start, recordToGet, whereClause , orderClause);
if (listIjCurrencyMapping.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
	 {
			start = start - recordToGet;   
	 }		
	 else
	 {
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 listIjCurrencyMapping = PstIjCurrencyMapping.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>AISO - Interactive Journal</title>
<script language="JavaScript">
function cmdChange(){
	document.frmijcurrencymapping.command.value="<%=Command.LIST%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}

function cmdAdd(){
	document.frmijcurrencymapping.hidden_ij_map_curr_id.value="0";
	document.frmijcurrencymapping.command.value="<%=Command.ADD%>";
	document.frmijcurrencymapping.prev_command.value="<%=prevCommand%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}

function cmdAsk(oidIjCurrencyMapping){
	document.frmijcurrencymapping.hidden_ij_map_curr_id.value=oidIjCurrencyMapping;
	document.frmijcurrencymapping.command.value="<%=Command.ASK%>";
	document.frmijcurrencymapping.prev_command.value="<%=prevCommand%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}

function cmdConfirmDelete(oidIjCurrencyMapping){
	document.frmijcurrencymapping.hidden_ij_map_curr_id.value=oidIjCurrencyMapping;
	document.frmijcurrencymapping.command.value="<%=Command.DELETE%>";
	document.frmijcurrencymapping.prev_command.value="<%=prevCommand%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}

function cmdSave(){
	document.frmijcurrencymapping.command.value="<%=Command.SAVE%>";
	document.frmijcurrencymapping.prev_command.value="<%=prevCommand%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}

function cmdEdit(oidIjCurrencyMapping){
	document.frmijcurrencymapping.hidden_ij_map_curr_id.value=oidIjCurrencyMapping;
	document.frmijcurrencymapping.command.value="<%=Command.EDIT%>";
	document.frmijcurrencymapping.prev_command.value="<%=prevCommand%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}

function cmdCancel(oidIjCurrencyMapping){
	document.frmijcurrencymapping.hidden_ij_map_curr_id.value=oidIjCurrencyMapping;
	document.frmijcurrencymapping.command.value="<%=Command.EDIT%>";
	document.frmijcurrencymapping.prev_command.value="<%=prevCommand%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}

function cmdBack(){
	document.frmijcurrencymapping.command.value="<%=Command.BACK%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}

function cmdListFirst(){
	document.frmijcurrencymapping.command.value="<%=Command.FIRST%>";
	document.frmijcurrencymapping.prev_command.value="<%=Command.FIRST%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}

function cmdListPrev(){
	document.frmijcurrencymapping.command.value="<%=Command.PREV%>";
	document.frmijcurrencymapping.prev_command.value="<%=Command.PREV%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}

function cmdListNext(){
	document.frmijcurrencymapping.command.value="<%=Command.NEXT%>";
	document.frmijcurrencymapping.prev_command.value="<%=Command.NEXT%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}

function cmdListLast(){
	document.frmijcurrencymapping.command.value="<%=Command.LAST%>";
	document.frmijcurrencymapping.prev_command.value="<%=Command.LAST%>";
	document.frmijcurrencymapping.action="ijcurrencymapping.jsp";
	document.frmijcurrencymapping.submit();
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
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
            AISO > IJ Currency Mapping<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmijcurrencymapping" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_ij_map_curr_id" value="<%=oidIjCurrencyMapping%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8" valign="middle" colspan="3"> 
                    <hr>
                  </td>
                </tr>
                <tr align="left" valign="top">
                  <td height="22" valign="middle" colspan="3">
                    <table class="listgen" width="100%" border="0">
                      <tr> 
                        <td width="14%"><b>Back Office System :</b></td>
                        <td> 
                        <%
						out.println(ControlCombo.draw(FrmIjCurrencyMapping.fieldNames[FrmIjCurrencyMapping.FRM_FIELD_BO_SYSTEM], null, ""+intBoSystem, vectBOKey, vectBOVal, "onChange=\"javascript:cmdChange()\"", ""));						
						%>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand, frmIjCurrencyMapping, ijCurrencyMapping, listIjCurrencyMapping, oidIjCurrencyMapping, intBoSystem)%> </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="8" align="left" colspan="3" class="command"> <span class="command"> 
                    <% 
					  int cmd = 0;
					  if( iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST)
					  {
							cmd =iCommand; 
					  }
						  else
						  {
							  if(iCommand == Command.NONE || prevCommand == Command.NONE)
							  {
								cmd = Command.FIRST;
							  }	
							  else 
							  { 
								cmd =prevCommand; 
							  }	
						  } 
						   
						  ControlLine ctrLine = new ControlLine();
						  ctrLine.setLanguage(SESS_LANGUAGE);						  
						  ctrLine.initDefault();						  						  
						  ctrLine.setLocationImg(approot+"/images/ctr_line");
		                  out.println(ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left"));               					  						  						  						  							
						%>
                    </span> </td>
                </tr>
                <%
					  if(iCommand==Command.NONE || iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST || iCommand==Command.BACK || iCommand==Command.DELETE)
					  {
					  %>
                <tr align="left" valign="top"> 
                  <td height="22" valign="middle" colspan="3"> 
                    <table width="100%">
                      <tr> 
                        <td> 
                          <div class="command"> <a href="javascript:cmdAdd()" class="command"><%=ctrLine.getCommand(SESS_LANGUAGE,currMappingTitle,ctrLine.CMD_ADD,true)%></a> </div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <%
					  }
					  %>
                <tr align="left" valign="top"> 
                  <td height="22" valign="middle" colspan="3"> 
                    <%
						ctrLine.setTableWidth("80%");
						
						String scomDel = "javascript:cmdAsk('"+oidIjCurrencyMapping+"')";
						String sconDelCom = "javascript:cmdConfirmDelete('"+oidIjCurrencyMapping+"')";
						String scancel = "javascript:cmdEdit('"+oidIjCurrencyMapping+"')";
						
						// set command caption							
						ctrLine.setSaveCaption(ctrLine.getCommand(SESS_LANGUAGE,currMappingTitle,ctrLine.CMD_SAVE,true));
						ctrLine.setBackCaption(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT ? ctrLine.getCommand(SESS_LANGUAGE,currMappingTitle,ctrLine.CMD_BACK,true) : ctrLine.getCommand(SESS_LANGUAGE,currMappingTitle,ctrLine.CMD_BACK,true)+" List");							
						ctrLine.setDeleteCaption(ctrLine.getCommand(SESS_LANGUAGE,currMappingTitle,ctrLine.CMD_ASK,true));							
						ctrLine.setConfirmDelCaption(ctrLine.getCommand(SESS_LANGUAGE,currMappingTitle,ctrLine.CMD_DELETE,true));														
						ctrLine.setCancelCaption(ctrLine.getCommand(SESS_LANGUAGE,currMappingTitle,ctrLine.CMD_CANCEL,false));														
						ctrLine.setAddCaption(ctrLine.getCommand(SESS_LANGUAGE,currMappingTitle,ctrLine.CMD_ADD,true));							
						ctrLine.setCommandStyle("command");						

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
						
						if(iCommand == Command.DELETE)
						{
							ctrLine.setBackCaption("");														
						}
						
						out.println(ctrLine.draw(iCommand, iErrCode, msgString));
						%>
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
      <%@ include file = "../../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
