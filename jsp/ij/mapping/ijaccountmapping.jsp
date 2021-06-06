<% 
/* 
 * Page Name  		:  ijaccountmapping.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
 */

/*******************************************************************
 * Page Description : [project description ... ] 
 * Imput Parameters : [input parameter ...] 
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
public String drawList(int iCommand, FrmIjAccountMapping frmObject, IjAccountMapping objEntity, Vector objectClass, long ijMapAccountId, String[] strTransactionType, Vector vectAccChart, int boSystem)
{
	String strResult = "<div class=\"msginfo\">&nbsp;&nbsp;There is no account mapping for " + I_IJGeneral.strBoSystem[boSystem] + " system</div>";				
	if( (objectClass!=null && objectClass.size()>0) || iCommand == Command.ADD)
	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");
		ctrlist.addHeader("Mapping Name","20%");
		ctrlist.addHeader("Journal Type","18%");
		ctrlist.addHeader("Location","15%");	
		ctrlist.addHeader("Currency","12%");
		ctrlist.addHeader("Chart Of Account","35%");
	
		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";
	
		// selected JournalType
		Hashtable hastJType = new Hashtable();	
		Vector journaltype_value = new Vector(1,1);
		Vector journaltype_key = new Vector(1,1);
		if(strTransactionType!=null && strTransactionType.length>0)
		{
			int maxTransType = strTransactionType.length;
			for(int i=0; i<maxTransType; i++)
			{
				hastJType.put(String.valueOf(i),strTransactionType[i]);
			}
			
			journaltype_value.add(""+I_IJGeneral.TRANS_DP_ON_SALES_ORDER);
			journaltype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_DP_ON_SALES_ORDER]);
	
			journaltype_value.add(""+I_IJGeneral.TRANS_DP_ON_PURCHASE_ORDER);
			journaltype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_DP_ON_PURCHASE_ORDER]);
	
			journaltype_value.add(""+I_IJGeneral.TRANS_DP_ON_PRODUCTION_ORDER);
			journaltype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_DP_ON_PRODUCTION_ORDER]);
	
			journaltype_value.add(""+I_IJGeneral.TRANS_GOODS_RECEIVE);
			journaltype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_GOODS_RECEIVE]);
	
			journaltype_value.add(""+I_IJGeneral.TRANS_SALES);
			journaltype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_SALES]);
	
			journaltype_value.add(""+I_IJGeneral.TRANS_OTHER_COST_ON_INVOICING);
			journaltype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_OTHER_COST_ON_INVOICING]);
	
			journaltype_value.add(""+I_IJGeneral.TRANS_TAX_ON_BUYING);
			journaltype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_TAX_ON_BUYING]);
	
			journaltype_value.add(""+I_IJGeneral.TRANS_TAX_ON_SELLING);
			journaltype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_TAX_ON_SELLING]);
		}	
	
		// selected boLocation
		Hashtable hastLoc = new Hashtable();	
		Vector location_value = new Vector(1,1);
		Vector location_key = new Vector(1,1);	
		try
		{
			PstIjConfiguration objPstIjConfiguration = new PstIjConfiguration(); 
			IjConfiguration objIjConfiguration = objPstIjConfiguration.getObjIJConfiguration(boSystem, 0, 0);
			String strIjImplBoClassName = objIjConfiguration.getSIjImplClass();        
			
			I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();                        
			
			//Vector vectLocation = i_bosystem.getListLocation();		
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
		
	
		for (int i = 0; i < objectClass.size(); i++) 
		{
			IjAccountMapping ijAccountMapping = (IjAccountMapping)objectClass.get(i);
			rowx = new Vector();
			if(ijMapAccountId==ijAccountMapping.getOID())
				 index = i; 
	
			if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK))
			{		 				
				rowx.add(".:: automatically generated ::.");	
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjAccountMapping.FRM_FIELD_JOURNAL_TYPE],null, ""+ijAccountMapping.getJournalType(), journaltype_value , journaltype_key, "formElemen", ""));
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjAccountMapping.FRM_FIELD_LOCATION],null, ""+ijAccountMapping.getLocation(), location_value , location_key, "formElemen", ""));
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjAccountMapping.FRM_FIELD_CURRENCY],null, ""+ijAccountMapping.getCurrency(), currency_value , currency_key, "formElemen", ""));
				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjAccountMapping.FRM_FIELD_ACCOUNT],null, ""+ijAccountMapping.getAccount(), account_value , account_key, "formElemen", ""));
			}
			else
			{
				String strTransType = ""+hastJType.get(String.valueOf(ijAccountMapping.getJournalType()));
				String strLocation = ""+hastLoc.get(String.valueOf(ijAccountMapping.getLocation()));			
				String strCurrency = ""+hastCurr.get(String.valueOf(ijAccountMapping.getCurrency()));						
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(ijAccountMapping.getOID())+"')\">"+strTransType + " - " + strCurrency+"</a>");			
				rowx.add(hastJType.get(String.valueOf(ijAccountMapping.getJournalType())));
				rowx.add(strLocation);			
				rowx.add(strCurrency);
				rowx.add(""+hastAcc.get(String.valueOf(ijAccountMapping.getAccount())));
			} 
			lstData.add(rowx);
		}
		rowx = new Vector();
	
		if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0))
		{ 
			rowx.add(".:: automatically generated ::.");	
			rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjAccountMapping.FRM_FIELD_JOURNAL_TYPE],null, ""+objEntity.getJournalType(), journaltype_value , journaltype_key, "formElemen", ""));
			rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjAccountMapping.FRM_FIELD_LOCATION],null, ""+objEntity.getLocation(), location_value , location_key, "formElemen", ""));
			rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjAccountMapping.FRM_FIELD_CURRENCY],null, ""+objEntity.getCurrency(), currency_value , currency_key, "formElemen", ""));
			rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmIjAccountMapping.FRM_FIELD_ACCOUNT],null, ""+objEntity.getAccount(), account_value , account_key, "formElemen", ""));
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
long oidIjAccountMapping = FRMQueryString.requestLong(request, "hidden_ij_map_account_id");
int intBoSystem = FRMQueryString.requestInt(request, FrmIjCurrencyMapping.fieldNames[FrmIjCurrencyMapping.FRM_FIELD_BO_SYSTEM]);
String accMappingTitle = "Account Mapping";

    if(iCommand == Command.NONE)
        intBoSystem = BO_SYSTEM;

// variable declaration
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = PstIjAccountMapping.fieldNames[PstIjAccountMapping.FLD_BO_SYSTEM] + "=" + intBoSystem;
String orderBy = PstIjAccountMapping.fieldNames[PstIjAccountMapping.FLD_JOURNAL_TYPE];

CtrlIjAccountMapping ctrlIjAccountMapping = new CtrlIjAccountMapping(request);
iErrCode = ctrlIjAccountMapping.action(iCommand , oidIjAccountMapping);
FrmIjAccountMapping frmIjAccountMapping = ctrlIjAccountMapping.getForm();


int vectSize = PstIjAccountMapping.getCount(whereClause);
if( iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST)
{
	start = ctrlIjAccountMapping.actionList(iCommand, start, vectSize, recordToGet);
} 

IjAccountMapping ijAccountMapping = ctrlIjAccountMapping.getIjAccountMapping();
msgString =  ctrlIjAccountMapping.getMessage();

Vector listIjAccountMapping = PstIjAccountMapping.list(start, recordToGet, whereClause, orderBy);
if( listIjAccountMapping.size()<1 && start>0 )
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
	 listIjAccountMapping = PstIjAccountMapping.list(start,recordToGet, whereClause , orderBy);
}

String[] strTransactionType = I_IJGeneral.strTransactionType;
Vector listAccountChart = new Vector(1,1);
try
{
	I_Aiso i_aiso = (I_Aiso) Class.forName(I_Aiso.implClassName).newInstance();                        

	Vector vectOfGroupAccount = new Vector(1,1);
	vectOfGroupAccount.add(String.valueOf(I_ChartOfAccountGroup.ACC_GROUP_LIQUID_ASSETS));         
	vectOfGroupAccount.add(String.valueOf(I_ChartOfAccountGroup.ACC_GROUP_CURRENCT_LIABILITIES));         	
	listAccountChart = i_aiso.getListAccountChart(vectOfGroupAccount);	
}
catch(Exception e)
{
	System.out.println("Exc : " + e.toString());
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>AISO - Interactive Journal</title>
<script language="JavaScript">
function cmdChange(){
	document.frmijaccountmapping.command.value="<%=Command.LIST%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
}

function cmdAdd(){
	document.frmijaccountmapping.hidden_ij_map_account_id.value="0";
	document.frmijaccountmapping.command.value="<%=Command.ADD%>";
	document.frmijaccountmapping.prev_command.value="<%=prevCommand%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
}

function cmdAsk(oidIjAccountMapping){
	document.frmijaccountmapping.hidden_ij_map_account_id.value=oidIjAccountMapping;
	document.frmijaccountmapping.command.value="<%=Command.ASK%>";
	document.frmijaccountmapping.prev_command.value="<%=prevCommand%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
}

function cmdConfirmDelete(oidIjAccountMapping){
	document.frmijaccountmapping.hidden_ij_map_account_id.value=oidIjAccountMapping;
	document.frmijaccountmapping.command.value="<%=Command.DELETE%>";
	document.frmijaccountmapping.prev_command.value="<%=prevCommand%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
}

function cmdSave(){
	document.frmijaccountmapping.command.value="<%=Command.SAVE%>";
	document.frmijaccountmapping.prev_command.value="<%=prevCommand%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
}

function cmdEdit(oidIjAccountMapping){
	document.frmijaccountmapping.hidden_ij_map_account_id.value=oidIjAccountMapping;
	document.frmijaccountmapping.command.value="<%=Command.EDIT%>";
	document.frmijaccountmapping.prev_command.value="<%=prevCommand%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
}

function cmdCancel(oidIjAccountMapping){
	document.frmijaccountmapping.hidden_ij_map_account_id.value=oidIjAccountMapping;
	document.frmijaccountmapping.command.value="<%=Command.EDIT%>";
	document.frmijaccountmapping.prev_command.value="<%=prevCommand%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
}

function cmdBack(){
	document.frmijaccountmapping.command.value="<%=Command.BACK%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
}

function cmdListFirst(){
	document.frmijaccountmapping.command.value="<%=Command.FIRST%>";
	document.frmijaccountmapping.prev_command.value="<%=Command.FIRST%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
}

function cmdListPrev(){
	document.frmijaccountmapping.command.value="<%=Command.PREV%>";
	document.frmijaccountmapping.prev_command.value="<%=Command.PREV%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
}

function cmdListNext(){
	document.frmijaccountmapping.command.value="<%=Command.NEXT%>";
	document.frmijaccountmapping.prev_command.value="<%=Command.NEXT%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
}

function cmdListLast(){
	document.frmijaccountmapping.command.value="<%=Command.LAST%>";
	document.frmijaccountmapping.prev_command.value="<%=Command.LAST%>";
	document.frmijaccountmapping.action="ijaccountmapping.jsp";
	document.frmijaccountmapping.submit();
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
            AISO > IJ Account Mapping<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmijaccountmapping" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_ij_map_account_id" value="<%=oidIjAccountMapping%>">
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
						out.println(ControlCombo.draw(FrmIjAccountMapping.fieldNames[FrmIjAccountMapping.FRM_FIELD_BO_SYSTEM], null, ""+intBoSystem, vectBOKey, vectBOVal, "onChange=\"javascript:cmdChange()\"", ""));						
						%>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand, frmIjAccountMapping, ijAccountMapping, listIjAccountMapping, oidIjAccountMapping, strTransactionType, listAccountChart, intBoSystem)%> </td>
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
                          <div class="command"> <a href="javascript:cmdAdd()" class="command"><%=ctrLine.getCommand(SESS_LANGUAGE,accMappingTitle,ctrLine.CMD_ADD,true)%></a> </div>
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
						
						String scomDel = "javascript:cmdAsk('"+oidIjAccountMapping+"')";
						String sconDelCom = "javascript:cmdConfirmDelete('"+oidIjAccountMapping+"')";
						String scancel = "javascript:cmdEdit('"+oidIjAccountMapping+"')";
						
						// set command caption							
						ctrLine.setSaveCaption(ctrLine.getCommand(SESS_LANGUAGE,accMappingTitle,ctrLine.CMD_SAVE,true));
						ctrLine.setBackCaption(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT ? ctrLine.getCommand(SESS_LANGUAGE,accMappingTitle,ctrLine.CMD_BACK,true) : ctrLine.getCommand(SESS_LANGUAGE,accMappingTitle,ctrLine.CMD_BACK,true)+" List");							
						ctrLine.setDeleteCaption(ctrLine.getCommand(SESS_LANGUAGE,accMappingTitle,ctrLine.CMD_ASK,true));							
						ctrLine.setConfirmDelCaption(ctrLine.getCommand(SESS_LANGUAGE,accMappingTitle,ctrLine.CMD_DELETE,true));														
						ctrLine.setCancelCaption(ctrLine.getCommand(SESS_LANGUAGE,accMappingTitle,ctrLine.CMD_CANCEL,false));														
						ctrLine.setAddCaption(ctrLine.getCommand(SESS_LANGUAGE,accMappingTitle,ctrLine.CMD_ADD,true));							
						ctrLine.setCommandStyle("command");
	
						if(privDelete)
						{
							ctrLine.setConfirmDelCommand(sconDelCom);
							ctrLine.setDeleteCommand(scomDel);
							ctrLine.setEditCommand(scancel);
						}
						else
						{							 
							ctrLine.setConfirmDelCaption("");
							ctrLine.setDeleteCaption("");
							ctrLine.setEditCaption("");
						}
	
						if(privAdd == false  && privUpdate == false)
						{
							ctrLine.setSaveCaption("");
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
