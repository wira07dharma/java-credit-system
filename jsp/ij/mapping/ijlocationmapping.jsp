 <% 
/* 
 * Page Name  		:  ijlocationmapping.jsp
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
public String drawList(int iCommand, FrmIjLocationMapping frmObject, IjLocationMapping objEntity, Vector objectClass,  long ijMapLocationId, String[] strTransactionType, Vector vectSaleType, Vector vectPriceType, Vector vectLocation, Vector vectProdDept, Vector vctCurrencyType, Vector vectAccChart, int boSystem)
{
	String strResult = "<div class=\"msginfo\">&nbsp;&nbsp;There is no location mapping for " + I_IJGeneral.strBoSystem[boSystem] + " system</div>";				
	if( (objectClass!=null && objectClass.size()>0) || iCommand == Command.ADD)
	{
		ControlList ctrlist = new ControlList();   
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("listgentitle");
		ctrlist.setCellStyle("listgensell");
		ctrlist.setHeaderStyle("listgentitle");
		ctrlist.addHeader("Transaction Type","15%");
		ctrlist.addHeader("Sales Type","10%");
		ctrlist.addHeader("Price Type","10%");	
		ctrlist.addHeader("Currency","15%");
		ctrlist.addHeader("Location","15%");
		ctrlist.addHeader("Prod Department","15%");
		ctrlist.addHeader("Account","30%");
	
		ctrlist.setLinkRow(0);
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");	
		ctrlist.reset();
	
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();		
		Vector rowx = new Vector(1,1);
		int index = -1;
		
		// selected SalesType
		Hashtable hastSaleType = new Hashtable();	
		if(vectSaleType!=null && vectSaleType.size()>0) 
		{
			int maxSaleType = vectSaleType.size();
			for(int i=0; i<maxSaleType; i++)
			{
				IjSaleTypeData objSaleTypeData = (IjSaleTypeData) vectSaleType.get(i);
				hastSaleType.put(String.valueOf(objSaleTypeData.getStIdx()), objSaleTypeData.getStName());
			}
		}
		
		// selected PriceType
		Hashtable hastPriceType = new Hashtable();	
		if(vectPriceType!=null && vectPriceType.size()>0) 
		{
			int maxSaleType = vectPriceType.size();
			for(int i=0; i<maxSaleType; i++)
			{
				PriceType objPriceType = (PriceType) vectPriceType.get(i);
				hastPriceType.put(String.valueOf(objPriceType.getOID()), objPriceType.getName());
			}
		}
	
		// selected Currency
		Hashtable hastCurr = new Hashtable();
		if(vctCurrencyType!=null && vctCurrencyType.size()>0)
		{
			int maxCurrencyAiso = vctCurrencyType.size();
			for(int i=0; i<maxCurrencyAiso; i++)
			{
				CurrencyType objCurrencyType = (CurrencyType) vctCurrencyType.get(i);
				hastCurr.put(String.valueOf(objCurrencyType.getOID()), objCurrencyType.getName()+"("+objCurrencyType.getCode()+")");		
			}
		}	
	
		// selected Location
		Hashtable hastLoc = new Hashtable();
		if(vectLocation!=null && vectLocation.size()>0) 
		{
			int maxLocation = vectLocation.size();
			for(int i=0; i<maxLocation; i++)
			{
				Location objLocation = (Location) vectLocation.get(i);
				hastLoc.put(String.valueOf(objLocation.getOID()), objLocation.getName());		
			}
		}			
	
		// selected ProdDepartment
		Hashtable hastPd = new Hashtable();	
		if(vectProdDept!=null && vectProdDept.size()>0) 
		{
			int maxPd = vectProdDept.size();
			for(int i=0; i<maxPd; i++)
			{
				IjProdDeptData objProdDeptData = (IjProdDeptData) vectProdDept.get(i);
				hastPd.put(String.valueOf(objProdDeptData.getPdId()), objProdDeptData.getPdName());		
			}
		}
		
	
		// selected Account
		Hashtable hastAcc = new Hashtable();	
		if(vectAccChart!=null && vectAccChart.size()>0) 
		{
			int maxAccChart = vectAccChart.size();
			for(int i=0; i<maxAccChart; i++)
			{
				IjAccountChart objAccountChart = (IjAccountChart) vectAccChart.get(i);
				hastAcc.put(String.valueOf(objAccountChart.getAccOid()), objAccountChart.getAccName());
			}
		}	
	
		for (int i=0; i<objectClass.size(); i++) 
		{
			IjLocationMapping ijLocationMapping = (IjLocationMapping)objectClass.get(i);
	
			if(ijMapLocationId == ijLocationMapping.getOID())
			{
				 index = i; 
			}
	
			rowx = new Vector();
			rowx.add(""+strTransactionType[ijLocationMapping.getTransactionType()]);
			rowx.add(ijLocationMapping.getSalesType()==-1 ? "-" : ""+hastSaleType.get(String.valueOf(ijLocationMapping.getSalesType())));
			rowx.add(ijLocationMapping.getPriceType()==-1 ? "-" : ""+hastPriceType.get(String.valueOf(ijLocationMapping.getPriceType())));		
			rowx.add(ijLocationMapping.getCurrency()==0 ? "-" : ""+hastCurr.get(String.valueOf(ijLocationMapping.getCurrency())));
			rowx.add(""+hastLoc.get(String.valueOf(ijLocationMapping.getLocation())));
			rowx.add(ijLocationMapping.getProdDepartment()==0 ? "-" : ""+hastPd.get(String.valueOf(ijLocationMapping.getProdDepartment())));
			rowx.add(""+hastAcc.get(String.valueOf(ijLocationMapping.getAccount())));
			
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(ijLocationMapping.getOID()));		
		}
		strResult = ctrlist.draw();
	}
	return strResult;	
}
%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidIjLocationMapping = FRMQueryString.requestLong(request, "hidden_ij_map_location_id");
int intBoSystem = FRMQueryString.requestInt(request, FrmIjLocationMapping.fieldNames[FrmIjLocationMapping.FRM_FIELD_BO_SYSTEM]);
String locMappingTitle = "Location Mapping";

    if(iCommand == Command.NONE)
        intBoSystem = BO_SYSTEM;

// variable declaration
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = PstIjLocationMapping.fieldNames[PstIjLocationMapping.FLD_BO_SYSTEM] + "=" + intBoSystem;
String orderClause = "";

CtrlIjLocationMapping ctrlIjLocationMapping = new CtrlIjLocationMapping(request);
iErrCode = ctrlIjLocationMapping.action(iCommand , oidIjLocationMapping);
FrmIjLocationMapping frmIjLocationMapping = ctrlIjLocationMapping.getForm();
IjLocationMapping ijLocationMapping = ctrlIjLocationMapping.getIjLocationMapping();
msgString =  ctrlIjLocationMapping.getMessage();

//save IjProDDepartementId
CtrlIjProdDepartmentMapping ctrlIjProdDepartmentMapping = new CtrlIjProdDepartmentMapping(request);
//iErrCode = ctrlIjProdDepartmentMapping.action(iCommand, oidIjLocationMapping)

int vectSize = PstIjLocationMapping.getCount(whereClause);
if((iCommand == Command.FIRST || iCommand == Command.PREV )||(iCommand == Command.NEXT || iCommand == Command.LAST))
{
	start = ctrlIjLocationMapping.actionList(iCommand, start, vectSize, recordToGet);
} 

Vector listIjLocationMapping = PstIjLocationMapping.list(start, recordToGet, whereClause , orderClause);
if (listIjLocationMapping.size() < 1 && start > 0)
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
	 listIjLocationMapping = PstIjLocationMapping.list(start,recordToGet, whereClause , orderClause);
}



Vector vectLocation = new Vector(1,1);
Vector vectProdDept = new Vector(1,1);
Vector vectSaleType = new Vector(1,1);
Vector vectPriceType = new Vector(1,1);
try
{
	PstIjConfiguration objPstIjConfiguration = new PstIjConfiguration(); 
	IjConfiguration objIjConfiguration = objPstIjConfiguration.getObjIJConfiguration(intBoSystem, 0, 0);
	String strIjImplBoClassName = objIjConfiguration.getSIjImplClass();        

	I_BOSystem i_bosystem = (I_BOSystem) Class.forName(strIjImplBoClassName).newInstance();                        
	//vectLocation = i_bosystem.getListLocation();
	vectLocation = i_bosystem.getListLocation(); //PstLocation.list(0,0,"","");
    vectSaleType = i_bosystem.getListSaleType();

	vectPriceType = i_bosystem.getListPriceType();
    System.out.println("vectSaleType " +vectSaleType.size() );
    vectProdDept = i_bosystem.getListProductDepartment();



}catch(Exception e){
	System.out.println("Exc : " + e.toString());
}

String[] strTransactionType = I_IJGeneral.strTransactionType;


Vector vectAccChart = new Vector(1,1);
try
{
	I_Aiso i_aiso = (I_Aiso) Class.forName(I_Aiso.implClassName).newInstance();                        
	
	Vector vectOfGroupAccount = new Vector(1,1);
	
	vectOfGroupAccount.add(String.valueOf(I_ChartOfAccountGroup.ACC_GROUP_LIQUID_ASSETS));         			 														
	vectOfGroupAccount.add(String.valueOf(I_ChartOfAccountGroup.ACC_GROUP_REVENUE));         			 														
	vectOfGroupAccount.add(String.valueOf(I_ChartOfAccountGroup.ACC_GROUP_COST_OF_SALES));         			 																
	vectAccChart = i_aiso.getListAccountChart(vectOfGroupAccount);		
}
catch(Exception e)
{
	System.out.println("Exc : " + e.toString());
}

// selected Currency
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


%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>AISO - Interactive Journal</title>
<script language="JavaScript">
function cmdChange(){
	document.frmijlocationmapping.command.value="<%=Command.LIST%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
}

function cmdAdd(){
	document.frmijlocationmapping.hidden_ij_map_location_id.value="0";
	document.frmijlocationmapping.command.value="<%=Command.ADD%>";
	document.frmijlocationmapping.prev_command.value="<%=prevCommand%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
}

function cmdAsk(oidIjLocationMapping){
	document.frmijlocationmapping.hidden_ij_map_location_id.value=oidIjLocationMapping;
	document.frmijlocationmapping.command.value="<%=Command.ASK%>";
	document.frmijlocationmapping.prev_command.value="<%=prevCommand%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
}

function cmdConfirmDelete(oidIjLocationMapping){
	document.frmijlocationmapping.hidden_ij_map_location_id.value=oidIjLocationMapping;
	document.frmijlocationmapping.command.value="<%=Command.DELETE%>";
	document.frmijlocationmapping.prev_command.value="<%=prevCommand%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
}

function cmdSave(){
	document.frmijlocationmapping.command.value="<%=Command.SAVE%>";
	document.frmijlocationmapping.prev_command.value="<%=prevCommand%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
}

function cmdEdit(oidIjLocationMapping){
	document.frmijlocationmapping.hidden_ij_map_location_id.value=oidIjLocationMapping;
	document.frmijlocationmapping.command.value="<%=Command.EDIT%>";
	document.frmijlocationmapping.prev_command.value="<%=prevCommand%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
}

function cmdCancel(oidIjLocationMapping){
	document.frmijlocationmapping.hidden_ij_map_location_id.value=oidIjLocationMapping;
	document.frmijlocationmapping.command.value="<%=Command.EDIT%>";
	document.frmijlocationmapping.prev_command.value="<%=prevCommand%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
}

function cmdBack(){
	document.frmijlocationmapping.command.value="<%=Command.BACK%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
}

function cmdListFirst(){
	document.frmijlocationmapping.command.value="<%=Command.FIRST%>";
	document.frmijlocationmapping.prev_command.value="<%=Command.FIRST%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
}

function cmdListPrev(){
	document.frmijlocationmapping.command.value="<%=Command.PREV%>";
	document.frmijlocationmapping.prev_command.value="<%=Command.PREV%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
}

function cmdListNext(){
	document.frmijlocationmapping.command.value="<%=Command.NEXT%>";
	document.frmijlocationmapping.prev_command.value="<%=Command.NEXT%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
}

function cmdListLast(){
	document.frmijlocationmapping.command.value="<%=Command.LAST%>";
	document.frmijlocationmapping.prev_command.value="<%=Command.LAST%>";
	document.frmijlocationmapping.action="ijlocationmapping.jsp";
	document.frmijlocationmapping.submit();
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
            AISO > IJ Location Mapping<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmijlocationmapping" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_ij_map_location_id" value="<%=oidIjLocationMapping%>">
              <table width="100%" border="0" cellspacing="1" cellpadding="1">
                <tr align="left" valign="top"> 
                  <td height="8" valign="middle"> 
                    <hr>
                  </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="22" valign="middle"> 
                    <table class="listgen" width="100%" border="0">
                      <tr> 
                        <td width="14%"><b>Back Office System :</b></td>
                        <td> 
                        <%
						out.println(ControlCombo.draw(FrmIjLocationMapping.fieldNames[FrmIjLocationMapping.FRM_FIELD_BO_SYSTEM], null, ""+intBoSystem, vectBOKey, vectBOVal, "onChange=\"javascript:cmdChange()\"", ""));						
						%>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="22" valign="middle"> <%= drawList(iCommand,frmIjLocationMapping,ijLocationMapping,listIjLocationMapping,oidIjLocationMapping,strTransactionType,vectSaleType,vectPriceType,vectLocation,vectProdDept,vctCurrencyType,vectAccChart,intBoSystem)%> </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="8" align="left" class="command" valign="top"> <span class="command"> 
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
				if( (iCommand==Command.SAVE && frmIjLocationMapping.errorSize()>0) || (iCommand==Command.ADD) || (iCommand==Command.EDIT) || (iCommand==Command.ASK) )
				{ 
				%>
                <tr align="left" valign="top"> 
                  <td height="8" valign="top"> 
                    <table width="100%" border="0" cellpadding="1" cellspacing="1">
                      <tr> 
                        <td width="13%">&nbsp;</td>
                        <td width="1%">&nbsp;</td>
                        <td width="86%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="13%">&nbsp;Transaction Type</td>
                        <td width="1%">:</td>
                        <td width="86%"> 
                          <%
						// selected TransactionType	
						Vector transactiontype_value = new Vector(1,1);
						Vector transactiontype_key = new Vector(1,1);
						
						transactiontype_value.add(""+I_IJGeneral.TRANS_DP_ON_SALES_ORDER);
						transactiontype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_DP_ON_SALES_ORDER]);
				
						transactiontype_value.add(""+I_IJGeneral.TRANS_SALES);
						transactiontype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_SALES]);
				
						transactiontype_value.add(""+I_IJGeneral.TRANS_SALES_DISCOUNT);
						transactiontype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_SALES_DISCOUNT]);
				
						transactiontype_value.add(""+I_IJGeneral.TRANS_COGS);
						transactiontype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_COGS]);
				
						transactiontype_value.add(""+I_IJGeneral.TRANS_INVENTORY_LOCATION);
						transactiontype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_INVENTORY_LOCATION]);				
				
						transactiontype_value.add(""+I_IJGeneral.TRANS_WIP);
						transactiontype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_WIP]);
						
						transactiontype_value.add(""+I_IJGeneral.TRANS_PURCHASE_DISCOUNT);
						transactiontype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_PURCHASE_DISCOUNT]);

						transactiontype_value.add(""+I_IJGeneral.TRANS_PROD_COST_DISCOUNT);
						transactiontype_key.add(I_IJGeneral.strTransactionType[I_IJGeneral.TRANS_PROD_COST_DISCOUNT]);
						
						String selectedTransType = ""+ijLocationMapping.getTransactionType();
						out.println(ControlCombo.draw(FrmIjLocationMapping.fieldNames[FrmIjLocationMapping.FRM_FIELD_TRANSACTION_TYPE],null, selectedTransType, transactiontype_value , transactiontype_key, "formElemen", ""));
						%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="13%">&nbsp;Sale Type</td>
                        <td width="1%">:</td>
                        <td width="86%"> 
                          <%
						// selected SalesType
						Vector salestype_value = new Vector(1,1);
						Vector salestype_key = new Vector(1,1);
						
						salestype_value.add("-1");
						salestype_key.add("-- select --");

						if(vectSaleType!=null && vectSaleType.size()>0) 
						{
                            int maxSaleType = vectSaleType.size();
							for(int i=0; i<maxSaleType; i++)
							{
								IjSaleTypeData objSaleTypeData = (IjSaleTypeData) vectSaleType.get(i);
								salestype_value.add(String.valueOf(objSaleTypeData.getStIdx()));
								salestype_key.add(objSaleTypeData.getStName());
							}
						}
						
						out.println(ControlCombo.draw(FrmIjLocationMapping.fieldNames[FrmIjLocationMapping.FRM_FIELD_SALES_TYPE], null, ""+ijLocationMapping.getSalesType(), salestype_value , salestype_key, "formElemen", ""));												
						%>
                        </td>
                      </tr>
                      <tr>
                        <td width="13%">&nbsp;Price Type</td>
                        <td width="1%">:</td>
                        <td width="86%">
                        <%
						// selected PriceType
						Vector pricetype_value = new Vector(1,1);
						Vector pricetype_key = new Vector(1,1);
						
						pricetype_value.add("-1");
						pricetype_key.add("-- select --");

						if(vectPriceType!=null && vectPriceType.size()>0) 
						{
							int maxPriceType = vectPriceType.size();
							for(int i=0; i<maxPriceType; i++)
							{
								PriceType objPriceType = (PriceType) vectPriceType.get(i);
								pricetype_value.add(String.valueOf(objPriceType.getOID()));
								pricetype_key.add(objPriceType.getName());
							}
						}
						
						out.println(ControlCombo.draw(FrmIjLocationMapping.fieldNames[FrmIjLocationMapping.FRM_FIELD_PRICE_TYPE], null, ""+ijLocationMapping.getPriceType(), pricetype_value , pricetype_key, "formElemen", ""));												
						%>						
						</td>
                      </tr>
                      <tr> 
                        <td width="13%">&nbsp;Currency</td>
                        <td width="1%">:</td>
                        <td width="86%"> 
                          <%
						// selected Currency
						String selectedCurrency = ""+ijLocationMapping.getCurrency();
						out.println(ControlCombo.draw(FrmIjLocationMapping.fieldNames[FrmIjLocationMapping.FRM_FIELD_CURRENCY],null, selectedCurrency, currency_value , currency_key, "formElemen", ""));
						%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="13%">&nbsp;Location</td>
                        <td width="1%">:</td>
                        <td width="86%"> 
                          <%
						// selected Location
						Hashtable hastLoc = new Hashtable();
						Vector location_value = new Vector(1,1);
						Vector location_key = new Vector(1,1);	
						location_value.add("0");
						location_key.add("-- select --");	
						String selectedLocation = ""+ijLocationMapping.getLocation();
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
						out.println(ControlCombo.draw(FrmIjLocationMapping.fieldNames[FrmIjLocationMapping.FRM_FIELD_LOCATION],null, selectedLocation, location_value , location_key, "formElemen", ""));
						%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="13%" valign="top" height="14" nowrap>&nbsp;Product Department</td>
                        <td width="1%" valign="top" height="14" nowrap>:</td>
                        <td width="86%"> 
                          <%
						// selected ProdDepartment
						Hashtable hastPd = new Hashtable();	
						Vector proddepartment_value = new Vector(1,1);
						Vector proddepartment_key = new Vector(1,1);
						//proddepartment_value.add("0");
						//proddepartment_key.add("-- select --");
						String selectedPd = ""+ijLocationMapping.getProdDepartment();
						if(vectProdDept!=null && vectProdDept.size()>0) 
						{
							int maxPd = vectProdDept.size();
							for(int i=0; i<maxPd; i++)
							{
								IjProdDeptData objProdDeptData = (IjProdDeptData) vectProdDept.get(i);
								proddepartment_value.add(""+objProdDeptData.getPdId());
								proddepartment_key.add(objProdDeptData.getPdName());			
								hastPd.put(String.valueOf(objProdDeptData.getPdId()), objProdDeptData.getPdName());		
							}
						}
                                                ControlCheckBox controlCheckBox = new ControlCheckBox();
                                                controlCheckBox.setWidth(5);


                                                //out.println(controlCheckBox.draw(FrmIjProdDepartmentMapping.fieldNames[FrmIjProdDepartmentMapping.FRM_FIELD_IJ_MAP_PROD_DEPARTMENT_ID], proddepartment_value , proddepartment_key, new Vector()));
                                                
						out.println(ControlCombo.draw(FrmIjLocationMapping.fieldNames[FrmIjLocationMapping.FRM_FIELD_PROD_DEPARTMENT],null, selectedPd, proddepartment_value , proddepartment_key, "formElemen", ""));
						%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="13%">&nbsp;Account Chart</td>
                        <td width="1%">:</td>
                        <td width="86%"> 
                          <%
						// selected Account
						Hashtable hastAcc = new Hashtable();	
						Vector account_value = new Vector(1,1);
						Vector account_key = new Vector(1,1);
						account_value.add("0");
						account_key.add("-- select --");
						String selectedAccChart = ""+ijLocationMapping.getAccount();
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
						out.println(ControlCombo.draw(FrmIjLocationMapping.fieldNames[FrmIjLocationMapping.FRM_FIELD_ACCOUNT],null, selectedAccChart, account_value , account_key, "formElemen", ""));																																																								
						%>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <%
				}
				%>
                <%
				  if(iCommand==Command.NONE || iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST || iCommand==Command.BACK || iCommand==Command.DELETE)
				  {
				  %>
                <tr align="left" valign="top"> 
                  <td height="22" valign="middle"> 
                    <table width="100%">
                      <tr> 
                        <td> 
                          <div class="command"> <a href="javascript:cmdAdd()" class="command"><%=ctrLine.getCommand(SESS_LANGUAGE,locMappingTitle,ctrLine.CMD_ADD,true)%></a> </div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <%
					  }
					  %>
                <tr align="left" valign="top"> 
                  <td height="22" valign="middle"> 
                    <%
						ctrLine.setTableWidth("80%");
						
						String scomDel = "javascript:cmdAsk('"+oidIjLocationMapping+"')";
						String sconDelCom = "javascript:cmdConfirmDelete('"+oidIjLocationMapping+"')";
						String scancel = "javascript:cmdEdit('"+oidIjLocationMapping+"')";
						
						// set command caption							
						ctrLine.setSaveCaption(ctrLine.getCommand(SESS_LANGUAGE,locMappingTitle,ctrLine.CMD_SAVE,true));
						ctrLine.setBackCaption(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT ? ctrLine.getCommand(SESS_LANGUAGE,locMappingTitle,ctrLine.CMD_BACK,true) : ctrLine.getCommand(SESS_LANGUAGE,locMappingTitle,ctrLine.CMD_BACK,true)+" List");							
						ctrLine.setDeleteCaption(ctrLine.getCommand(SESS_LANGUAGE,locMappingTitle,ctrLine.CMD_ASK,true));							
						ctrLine.setConfirmDelCaption(ctrLine.getCommand(SESS_LANGUAGE,locMappingTitle,ctrLine.CMD_DELETE,true));														
						ctrLine.setCancelCaption(ctrLine.getCommand(SESS_LANGUAGE,locMappingTitle,ctrLine.CMD_CANCEL,false));														
						ctrLine.setAddCaption(ctrLine.getCommand(SESS_LANGUAGE,locMappingTitle,ctrLine.CMD_ADD,true));							
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
