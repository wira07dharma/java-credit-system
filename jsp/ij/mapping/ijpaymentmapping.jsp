<% 
/* 
 * Page Name  		:  ijpaymentmapping.jsp
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
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package common -->
<%@ page import = "com.dimata.common.entity.payment.*" %>
<%@ page import = "com.dimata.common.entity.location.*" %>
<!--package interfaces -->
<%@ page import = "com.dimata.interfaces.chartofaccount.I_ChartOfAccountGroup" %>
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
public String drawList(int iCommand, FrmIjPaymentMapping frmObject, IjPaymentMapping objEntity, Vector objectClass, long ijMapPaymentId, int boSystem)
{
	String strResult = "<div class=\"msginfo\">&nbsp;&nbsp;There is no payment mapping for " + I_IJGeneral.strBoSystem[boSystem] + " system</div>";				
	if( (objectClass!=null && objectClass.size()>0) || iCommand == Command.ADD)
	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");
		ctrlist.addHeader("Mapping Name","20%");	
		ctrlist.addHeader("Payment System","12%");
		ctrlist.addHeader("Location","17%");	
		ctrlist.addHeader("Currency","13%");
		ctrlist.addHeader("Chart Of Account","38%");
	
		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";
		
		// selected boPaymentSystem & boLocation
		Hashtable hastPs = new Hashtable();
		Vector paymentsystem_value = new Vector(1,1);
		Vector paymentsystem_key = new Vector(1,1);	
	
		Hashtable hastLoc = new Hashtable();	
		Vector location_value = new Vector(1,1);
		Vector location_key = new Vector(1,1);	
		try
		{
			PstIjConfiguration objPstIjConfiguration = new PstIjConfiguration(); 
			IjConfiguration objIjConfiguration = objPstIjConfiguration.getObjIJConfiguration(boSystem, 0, 0);
			String strIjImplBoClassName = objIjConfiguration.getSIjImplClass();        
			
			I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();                        
			
			Vector vectLocation = PstLocation.list(0,0,"","");		
			if(vectLocation!=null && vectLocation.size()>0) 
			{
				int maxLocation = vectLocation.size();
				for(int i=0; i<maxLocation; i++)
				{
					Location objLocation = (Location) vectLocation.get(i);
					
					location_value.add(""+objLocation.getOID());
					location_key.add(objLocation.getName());			
					hastLoc.put(String.valueOf(objLocation.getOID()), objLocation.getName());		
				}
			}		
			
			Vector listPaymentSystem = i_bosystem.getListPaymentSystem();								
			if(listPaymentSystem!=null && listPaymentSystem.size()>0) 
			{
				int maxPaymentSystem = listPaymentSystem.size();
				for(int i=0; i<maxPaymentSystem; i++)
				{
					PaymentSystem objPaymentSystem = (PaymentSystem) listPaymentSystem.get(i);
					paymentsystem_value.add(""+objPaymentSystem.getOID());
					paymentsystem_key.add(objPaymentSystem.getPaymentSystem());
					hastPs.put(String.valueOf(objPaymentSystem.getOID()),objPaymentSystem.getPaymentSystem());	
				}
			}
		}
		catch(Exception e)
		{
			System.out.println("Exc : " + e.toString());
		}		
	
		// selected aisoCurrency
		Hashtable hastCurr = new Hashtable();
		Vector currency_value = new Vector(1,1);
		Vector currency_key = new Vector(1,1);	
		PstCurrencyType objPstCurrencyType = new PstCurrencyType();
		String strOrder = objPstCurrencyType.fieldNames[objPstCurrencyType.FLD_TAB_INDEX];
		Vector vctCurrencyType = objPstCurrencyType.list(0, 0, "", strOrder);  
		if(vctCurrencyType!=null && vctCurrencyType.size()>0)
		{
			currency_value.add("0");
			currency_key.add("-- select --");		
			int maxCurrencyType = vctCurrencyType.size();
			for(int i=0; i<maxCurrencyType; i++)
			{
				CurrencyType objCurrencyType = (CurrencyType) vctCurrencyType.get(i);                 					
				currency_value.add(""+objCurrencyType.getOID());
				currency_key.add(objCurrencyType.getName()+"("+objCurrencyType.getCode()+")");						
				hastCurr.put(String.valueOf(objCurrencyType.getOID()), objCurrencyType.getName()+"("+objCurrencyType.getCode()+")");
			}
		}
		
	
		// selected Account
		Hashtable hastAcc = new Hashtable();	
		Vector account_value = new Vector(1,1);
		Vector account_key = new Vector(1,1);
		account_value.add("0");
		account_key.add("-- select --");
		try
		{
			I_Aiso i_aiso = (I_Aiso) Class.forName(I_Aiso.implClassName).newInstance();                        	
			
			Vector vectOfGroupAccount = new Vector(1,1);			
			vectOfGroupAccount.add(String.valueOf(I_ChartOfAccountGroup.ACC_GROUP_LIQUID_ASSETS));         			 												
			Vector vectAccChart = i_aiso.getListAccountChart(vectOfGroupAccount);			
			if(vectAccChart!=null && vectAccChart.size()>0) 
			{
				int maxAccChart = vectAccChart.size();
				for(int i=0; i<maxAccChart; i++)
				{
					IjAccountChart objAccountChart = (IjAccountChart) vectAccChart.get(i);
					String strPrefix = "";		
					switch(objAccountChart.getAccLevel())
					{
						case 2 : strPrefix = "&nbsp;&nbsp;"; 
								 break;
						case 3 : strPrefix = "&nbsp;&nbsp;&nbsp;&nbsp;";
								 break;
						case 4 : strPrefix = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								 break;
						case 5 : strPrefix = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								 break;
						case 6 : strPrefix = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								 break;
					}			
		
					account_value.add(""+objAccountChart.getAccOid());
					account_key.add(strPrefix+objAccountChart.getAccName());
					hastAcc.put(String.valueOf(objAccountChart.getAccOid()), objAccountChart.getAccName());
				}
			}	
		}
		catch(Exception e)
		{
			System.out.println("Exc : " + e.toString());
		}
	
		for (int i = 0; i < objectClass.size(); i++) 
		{
			IjPaymentMapping ijPaymentMapping = (IjPaymentMapping)objectClass.get(i);
			rowx = new Vector();
			if(ijMapPaymentId == ijPaymentMapping.getOID())
				 index = i; 
	
			if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK))
			{				
				rowx.add(".:: automatically generated ::.");
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjPaymentMapping.FRM_FIELD_PAYMENT_SYSTEM],null, ""+ijPaymentMapping.getPaymentSystem(), paymentsystem_value , paymentsystem_key, "formElemen", ""));
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjPaymentMapping.FRM_FIELD_LOCATION],null, ""+ijPaymentMapping.getLocation(), location_value , location_key, "formElemen", ""));
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjPaymentMapping.FRM_FIELD_CURRENCY],null, ""+ijPaymentMapping.getCurrency(), currency_value , currency_key, "formElemen", ""));
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjPaymentMapping.FRM_FIELD_ACCOUNT],null, ""+ijPaymentMapping.getAccount(), account_value , account_key, "formElemen", ""));
			}
			else
			{
				String strPaymentSystem = ""+hastPs.get(String.valueOf(ijPaymentMapping.getPaymentSystem()));
				String strLocation = ""+hastLoc.get(String.valueOf(ijPaymentMapping.getLocation()));			
				String strCurrency = ""+hastCurr.get(String.valueOf(ijPaymentMapping.getCurrency()));			
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(ijPaymentMapping.getOID())+"')\">"+strPaymentSystem+" - "+strCurrency+"</a>");
				rowx.add(strPaymentSystem);
				rowx.add(strLocation);			
				rowx.add(strCurrency);
				rowx.add(hastAcc.get(String.valueOf(ijPaymentMapping.getAccount())));
			} 
			lstData.add(rowx);
		}
		rowx = new Vector();
	
		if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0))
		{ 
			rowx.add(".:: automatically generated ::.");	
			rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjPaymentMapping.FRM_FIELD_PAYMENT_SYSTEM],null, ""+objEntity.getPaymentSystem(), paymentsystem_value , paymentsystem_key, "formElemen", ""));
			rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjPaymentMapping.FRM_FIELD_LOCATION],null, ""+objEntity.getLocation(), location_value , location_key, "formElemen", ""));		
			rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjPaymentMapping.FRM_FIELD_CURRENCY],null, ""+objEntity.getCurrency(), currency_value , currency_key, "formElemen", ""));
			rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjPaymentMapping.FRM_FIELD_ACCOUNT],null, ""+objEntity.getAccount(), account_value , account_key, "formElemen", ""));
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
long oidIjPaymentMapping = FRMQueryString.requestLong(request, "hidden_ij_map_payment_id");
int intBoSystem = FRMQueryString.requestInt(request, FrmIjPaymentMapping.fieldNames[FrmIjPaymentMapping.FRM_FIELD_BO_SYSTEM]);

String payMappingTitle = "Payment Mapping";
    if(iCommand == Command.NONE)
        intBoSystem = BO_SYSTEM;

// variable declaration
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = PstIjPaymentMapping.fieldNames[PstIjPaymentMapping.FLD_BO_SYSTEM] + "=" + intBoSystem;;
String orderBy = PstIjPaymentMapping.fieldNames[PstIjPaymentMapping.FLD_PAYMENT_SYSTEM];

CtrlIjPaymentMapping ctrlIjPaymentMapping = new CtrlIjPaymentMapping(request);
iErrCode = ctrlIjPaymentMapping.action(iCommand , oidIjPaymentMapping);
FrmIjPaymentMapping frmIjPaymentMapping = ctrlIjPaymentMapping.getForm();
IjPaymentMapping ijPaymentMapping = ctrlIjPaymentMapping.getIjPaymentMapping();
msgString =  ctrlIjPaymentMapping.getMessage();

int vectSize = PstIjPaymentMapping.getCount(whereClause);
if((iCommand == Command.FIRST || iCommand == Command.PREV )||(iCommand == Command.NEXT || iCommand == Command.LAST))
{
	start = ctrlIjPaymentMapping.actionList(iCommand, start, vectSize, recordToGet);
} 

Vector listIjPaymentMapping = PstIjPaymentMapping.list(start,recordToGet, whereClause, orderBy);
if (listIjPaymentMapping.size() < 1 && start > 0)
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
	 listIjPaymentMapping = PstIjPaymentMapping.list(start,recordToGet, whereClause , orderBy);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>AISO - Interactive Journal</title>
<script language="JavaScript">
function cmdChange(){
	document.frmijpaymentmapping.command.value="<%=Command.LIST%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
}

function cmdAdd(){
	document.frmijpaymentmapping.hidden_ij_map_payment_id.value="0";
	document.frmijpaymentmapping.command.value="<%=Command.ADD%>";
	document.frmijpaymentmapping.prev_command.value="<%=prevCommand%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
}

function cmdAsk(oidIjPaymentMapping){
	document.frmijpaymentmapping.hidden_ij_map_payment_id.value=oidIjPaymentMapping;
	document.frmijpaymentmapping.command.value="<%=Command.ASK%>";
	document.frmijpaymentmapping.prev_command.value="<%=prevCommand%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
}

function cmdConfirmDelete(oidIjPaymentMapping){
	document.frmijpaymentmapping.hidden_ij_map_payment_id.value=oidIjPaymentMapping;
	document.frmijpaymentmapping.command.value="<%=Command.DELETE%>";
	document.frmijpaymentmapping.prev_command.value="<%=prevCommand%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
}

function cmdSave(){
	document.frmijpaymentmapping.command.value="<%=Command.SAVE%>";
	document.frmijpaymentmapping.prev_command.value="<%=prevCommand%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
}

function cmdEdit(oidIjPaymentMapping){
	document.frmijpaymentmapping.hidden_ij_map_payment_id.value=oidIjPaymentMapping;
	document.frmijpaymentmapping.command.value="<%=Command.EDIT%>";
	document.frmijpaymentmapping.prev_command.value="<%=prevCommand%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
}

function cmdCancel(oidIjPaymentMapping){
	document.frmijpaymentmapping.hidden_ij_map_payment_id.value=oidIjPaymentMapping;
	document.frmijpaymentmapping.command.value="<%=Command.EDIT%>";
	document.frmijpaymentmapping.prev_command.value="<%=prevCommand%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
}

function cmdBack(){
	document.frmijpaymentmapping.command.value="<%=Command.BACK%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
}

function cmdListFirst(){
	document.frmijpaymentmapping.command.value="<%=Command.FIRST%>";
	document.frmijpaymentmapping.prev_command.value="<%=Command.FIRST%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
}

function cmdListPrev(){
	document.frmijpaymentmapping.command.value="<%=Command.PREV%>";
	document.frmijpaymentmapping.prev_command.value="<%=Command.PREV%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
}

function cmdListNext(){
	document.frmijpaymentmapping.command.value="<%=Command.NEXT%>";
	document.frmijpaymentmapping.prev_command.value="<%=Command.NEXT%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
}

function cmdListLast(){
	document.frmijpaymentmapping.command.value="<%=Command.LAST%>";
	document.frmijpaymentmapping.prev_command.value="<%=Command.LAST%>";
	document.frmijpaymentmapping.action="ijpaymentmapping.jsp";
	document.frmijpaymentmapping.submit();
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
            AISO > IJ Payment Mapping<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmijpaymentmapping" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_ij_map_payment_id" value="<%=oidIjPaymentMapping%>">
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
						out.println(ControlCombo.draw(FrmIjPaymentMapping.fieldNames[FrmIjPaymentMapping.FRM_FIELD_BO_SYSTEM], null, ""+intBoSystem, vectBOKey, vectBOVal, "onChange=\"javascript:cmdChange()\"", ""));						
						%>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand, frmIjPaymentMapping, ijPaymentMapping, listIjPaymentMapping, oidIjPaymentMapping, intBoSystem)%> </td>
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
                          <div class="command"> <a href="javascript:cmdAdd()" class="command"><%=ctrLine.getCommand(SESS_LANGUAGE,payMappingTitle,ctrLine.CMD_ADD,true)%></a> </div>
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
						
						String scomDel = "javascript:cmdAsk('"+oidIjPaymentMapping+"')";
						String sconDelCom = "javascript:cmdConfirmDelete('"+oidIjPaymentMapping+"')";
						String scancel = "javascript:cmdEdit('"+oidIjPaymentMapping+"')";
						
						// set command caption							
						ctrLine.setSaveCaption(ctrLine.getCommand(SESS_LANGUAGE,payMappingTitle,ctrLine.CMD_SAVE,true));
						ctrLine.setBackCaption(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT ? ctrLine.getCommand(SESS_LANGUAGE,payMappingTitle,ctrLine.CMD_BACK,true) : ctrLine.getCommand(SESS_LANGUAGE,payMappingTitle,ctrLine.CMD_BACK,true)+" List");							
						ctrLine.setDeleteCaption(ctrLine.getCommand(SESS_LANGUAGE,payMappingTitle,ctrLine.CMD_ASK,true));							
						ctrLine.setConfirmDelCaption(ctrLine.getCommand(SESS_LANGUAGE,payMappingTitle,ctrLine.CMD_DELETE,true));														
						ctrLine.setCancelCaption(ctrLine.getCommand(SESS_LANGUAGE,payMappingTitle,ctrLine.CMD_CANCEL,false));														
						ctrLine.setAddCaption(ctrLine.getCommand(SESS_LANGUAGE,payMappingTitle,ctrLine.CMD_ADD,true));							
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
