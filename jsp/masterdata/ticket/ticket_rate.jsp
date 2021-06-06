
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@ page import = "com.dimata.aiso.entity.masterdata.TicketRate,
		  com.dimata.aiso.entity.masterdata.PstTicketRate,
		  com.dimata.aiso.entity.masterdata.TicketMaster,
		  com.dimata.aiso.entity.masterdata.PstTicketMaster,	
		  com.dimata.aiso.form.masterdata.FrmTicketRate,
		  com.dimata.aiso.form.masterdata.CtrlTicketRate"%>

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
	{"No","Penyedia Jasa Penerbangan","Rute","Kelas","Harga Jual","HPP"},	
	{"No","Carrier","Route","Class","Selling Price","Net Price To Airline"}
};

public static final String masterTitle[] = {
	"Master Tiket","Ticket Master"	
};

public static final String classTitle[] = {
	"Harga","Price"	
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

public String drawList(int language,int iCommand,FrmTicketRate frmTicketRate, Vector objectClass, long oidTicketRate, int iStart, Vector vCarrier, Vector vRoute, Vector vClass){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("60%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");	
	ctrlist.dataFormat(strTitle[language][0],"5%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"15%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"35%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"10%","center","center");
	ctrlist.dataFormat(strTitle[language][4],"20%","center","right");
	ctrlist.dataFormat(strTitle[language][5],"15%","center","right");

	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);
	ctrlist.reset();
	int index = -1;
	
	TicketMaster objCarrier = new TicketMaster();
	TicketMaster objRoute = new TicketMaster();
	TicketMaster objClass = new TicketMaster();
	Vector vCarrierVal = new Vector(1,1);
	Vector vCarrierKey = new Vector(1,1);
	Vector vRouteVal = new Vector(1,1);
	Vector vRouteKey = new Vector(1,1);
	Vector vClassVal = new Vector(1,1);
	Vector vClassKey = new Vector(1,1);
	String sSelectedCarrier = "";
	String sSelectedRoute = "";
	String sSelectedClass = "";
	TicketRate objTicketRate = new TicketRate();

	if(vCarrier != null && vCarrier.size() > 0){
		vCarrierVal = (Vector)vCarrier.get(0);
		vCarrierKey = (Vector)vCarrier.get(1);
	}

	if(vRoute != null && vRoute.size() > 0){
		vRouteVal = (Vector)vRoute.get(0);
		vRouteKey = (Vector)vRoute.get(1);
	}

	if(vClass != null && vClass.size() > 0){
		vClassVal = (Vector)vClass.get(0);
		vClassKey = (Vector)vClass.get(1);
	}

	
	for(int i=0; i<objectClass.size(); i++) {
		 objTicketRate = (TicketRate)objectClass.get(i);

		 sSelectedCarrier = String.valueOf(objTicketRate.getCarrierId());
		 sSelectedRoute = String.valueOf(objTicketRate.getRouteId()); 
		 sSelectedClass = String.valueOf(objTicketRate.getClassId()); 

		 if(objTicketRate.getCarrierId() != 0){
			try{
				objCarrier = PstTicketMaster.fetchExc(objTicketRate.getCarrierId());
			}catch(Exception e){}
		 }

		 if(objTicketRate.getRouteId() != 0){
			try{
				objRoute = PstTicketMaster.fetchExc(objTicketRate.getRouteId());
			}catch(Exception e){}
		 }
		
		 
		 if(objTicketRate.getClassId() != 0){
			try{
				objClass = PstTicketMaster.fetchExc(objTicketRate.getClassId());
				
			}catch(Exception e){}
		 }

		 rowx = new Vector();
		
		 if(oidTicketRate == objTicketRate.getOID())
		 	index = i;
		 
		 if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
			rowx.add(""+(i+1+iStart));
			rowx.add(""+ControlCombo.draw(frmTicketRate.fieldNames[frmTicketRate.FRM_CARRIER_ID], null, sSelectedCarrier, vCarrierVal, vCarrierKey,"","")+"");
			rowx.add(""+ControlCombo.draw(frmTicketRate.fieldNames[frmTicketRate.FRM_ROUTE_ID], null, sSelectedRoute, vRouteVal, vRouteKey,"","")+"");
			rowx.add(""+ControlCombo.draw(frmTicketRate.fieldNames[frmTicketRate.FRM_CLASS_ID], null, sSelectedClass, vClassVal, vClassKey,"","")+"");
			rowx.add("<input type=\"text\" name=\""+frmTicketRate.fieldNames[frmTicketRate.FRM_RATE] +"\" value=\""+objTicketRate.getRate()+"\" class=\"elemenForm\">");
			rowx.add("<input type=\"text\" name=\""+frmTicketRate.fieldNames[frmTicketRate.FRM_NET_RATE_TO_AIRLINE] +"\" value=\""+objTicketRate.getNetRateToAirLine()+"\" class=\"elemenForm\">");
		}else{
			rowx.add(""+(i+1+iStart));
			rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objTicketRate.getOID())+"')\">"+objCarrier.getCode()+"</a>");
			rowx.add(objRoute.getCode());
			rowx.add(objClass.getCode());
			rowx.add(Formater.formatNumber(objTicketRate.getRate(), "##,###.##"));
			rowx.add(Formater.formatNumber(objTicketRate.getNetRateToAirLine(), "##,###.##"));
		} 

		lstData.add(rowx);
	}

	rowx = new Vector();
	if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmTicketRate.errorSize()>0)){ 
			rowx.add("");
			rowx.add(""+ControlCombo.draw(frmTicketRate.fieldNames[frmTicketRate.FRM_CARRIER_ID], null, sSelectedCarrier, vCarrierVal, vCarrierKey,"","")+"");
			rowx.add(""+ControlCombo.draw(frmTicketRate.fieldNames[frmTicketRate.FRM_ROUTE_ID], null, sSelectedRoute, vRouteVal, vRouteKey,"","")+"");
			rowx.add(""+ControlCombo.draw(frmTicketRate.fieldNames[frmTicketRate.FRM_CLASS_ID], null, sSelectedClass, vClassVal, vClassKey,"","")+"");
			rowx.add("<input type=\"text\" name=\""+frmTicketRate.fieldNames[frmTicketRate.FRM_RATE] +"\" value=\""+Formater.formatNumber(objTicketRate.getRate(), "###")+"\" class=\"elemenForm\">");
			rowx.add("<input type=\"text\" name=\""+frmTicketRate.fieldNames[frmTicketRate.FRM_NET_RATE_TO_AIRLINE] +"\" value=\""+Formater.formatNumber(objTicketRate.getNetRateToAirLine(), "###")+"\" class=\"elemenForm\">");
	}
	lstData.add(rowx);
	return ctrlist.drawMe(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidTicketRate = FRMQueryString.requestLong(request, "hidden_ticket_rate_id");

	
/*variable declaration*/
int recordToGet = 100;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String whClauseCarrier = PstTicketMaster.fieldNames[PstTicketMaster.FLD_TYPE]+" = "+PstTicketMaster.MASTER_CARRIER;
String whClauseRoute = PstTicketMaster.fieldNames[PstTicketMaster.FLD_TYPE]+" = "+PstTicketMaster.MASTER_ROUTE;
String whClauseClass = PstTicketMaster.fieldNames[PstTicketMaster.FLD_TYPE]+" = "+PstTicketMaster.MASTER_CLASS;
String orderClause = PstTicketRate.fieldNames[PstTicketRate.FLD_TICKET_PRICE_ID]+", "+PstTicketRate.fieldNames[PstTicketRate.FLD_CARRIER_ID]+", "+PstTicketRate.fieldNames[PstTicketRate.FLD_ROUTE_ID]+", "+PstTicketRate.fieldNames[PstTicketRate.FLD_CLASS_ID]+", "+PstTicketRate.fieldNames[PstTicketRate.FLD_RATE];

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

CtrlTicketRate ctrlTicketRate = new CtrlTicketRate(request);
ctrlTicketRate.setLanguage(SESS_LANGUAGE);

Vector listTicketRate = new Vector(1,1);
Vector vCarrier = new Vector(1,1);
Vector vRoute = new Vector(1,1);
Vector vClass = new Vector(1,1);

Vector vCarrierVal = new Vector(1,1);
Vector vCarrierKey = new Vector(1,1);

Vector vRouteVal = new Vector(1,1);
Vector vRouteKey = new Vector(1,1);

Vector vClassVal = new Vector(1,1);
Vector vClassKey = new Vector(1,1);

Vector vListCarrier = PstTicketMaster.list(0,0, whClauseCarrier , "");
Vector vListRoute = PstTicketMaster.list(0,0, whClauseRoute , PstTicketMaster.fieldNames[PstTicketMaster.FLD_CODE]);
Vector vListClass = PstTicketMaster.list(0,0, whClauseClass , "");
if(vListCarrier != null && vListCarrier.size() > 0){
	for(int i = 0; i < vListCarrier.size(); i++){
		TicketMaster objCarrier = (TicketMaster)vListCarrier.get(i);
		vCarrierVal.add(""+objCarrier.getOID());
		vCarrierKey.add(objCarrier.getCode());
	}
	vCarrier.add(vCarrierVal);
	vCarrier.add(vCarrierKey);
}

if(vListRoute != null && vListRoute.size() > 0){
	for(int j = 0; j < vListRoute.size(); j++){
		TicketMaster objRoute = (TicketMaster)vListRoute.get(j);
		vRouteVal.add(""+objRoute.getOID());
		vRouteKey.add(objRoute.getCode());
	}
	vRoute.add(vRouteVal);
	vRoute.add(vRouteKey);
}

if(vListClass != null && vListClass.size() > 0){
	for(int k = 0; k < vListClass.size(); k++){
		TicketMaster objClass = (TicketMaster)vListClass.get(k);
		vClassVal.add(""+objClass.getOID());
		vClassKey.add(objClass.getCode());
	}
	vClass.add(vClassVal);
	vClass.add(vClassKey);
}

iErrCode = ctrlTicketRate.action(iCommand , oidTicketRate);
FrmTicketRate frmTicketRate = ctrlTicketRate.getForm();

int vectSize = PstTicketRate.getCount(whereClause); 

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlTicketRate.actionList(iCommand, start, vectSize, recordToGet);
} 

TicketRate objTicketRate = ctrlTicketRate.getTicketRate();

msgString =  ctrlTicketRate.getMessage();
listTicketRate = PstTicketRate.list(start,recordToGet, whereClause , orderClause);

if (listTicketRate.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet){
			start = start - recordToGet; 
	 }else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 listTicketRate = PstTicketRate.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
	
	document.frmcontactclass.hidden_ticket_rate_id.value="0";
	document.frmcontactclass.command.value="<%=Command.ADD%>";
	document.frmcontactclass.action="ticket_rate.jsp";
	document.frmcontactclass.submit();
}

function cmdAsk(oidTicketRate){
	document.frmcontactclass.hidden_ticket_rate_id.value=oidTicketRate;
	document.frmcontactclass.command.value="<%=Command.ASK%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_rate.jsp";
	document.frmcontactclass.submit();
}

function cmdConfirmDelete(oidTicketRate){
	document.frmcontactclass.hidden_ticket_rate_id.value=oidTicketRate;
	document.frmcontactclass.command.value="<%=Command.DELETE%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_rate.jsp";
	document.frmcontactclass.submit();
}

function cmdSave(){
	document.frmcontactclass.command.value="<%=Command.SAVE%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_rate.jsp";
	document.frmcontactclass.submit();
}

function cmdEdit(oidTicketRate){
	document.frmcontactclass.hidden_ticket_rate_id.value=oidTicketRate;
	document.frmcontactclass.command.value="<%=Command.EDIT%>";
	document.frmcontactclass.action="ticket_rate.jsp";
	document.frmcontactclass.submit();
}

function cmdCancel(oidTicketRate){
	document.frmcontactclass.hidden_ticket_rate_id.value=oidTicketRate;
	document.frmcontactclass.command.value="<%=Command.EDIT%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_rate.jsp";
	document.frmcontactclass.submit();
}

function cmdBack(){
	document.frmcontactclass.command.value="<%=Command.BACK%>";
	document.frmcontactclass.action="ticket_rate.jsp";
	document.frmcontactclass.submit();
}

function first(){
	document.frmcontactclass.command.value="<%=Command.FIRST%>";
	document.frmcontactclass.prev_command.value="<%=Command.FIRST%>";
	document.frmcontactclass.action="ticket_rate.jsp";
	document.frmcontactclass.submit();
}

function prev(){
	document.frmcontactclass.command.value="<%=Command.PREV%>";
	document.frmcontactclass.prev_command.value="<%=Command.PREV%>";
	document.frmcontactclass.action="ticket_rate.jsp";
	document.frmcontactclass.submit();
}

function next(){
	document.frmcontactclass.command.value="<%=Command.NEXT%>";
	document.frmcontactclass.prev_command.value="<%=Command.NEXT%>";
	document.frmcontactclass.action="ticket_rate.jsp";
	document.frmcontactclass.submit();
}

function last(){
	document.frmcontactclass.command.value="<%=Command.LAST%>";
	document.frmcontactclass.prev_command.value="<%=Command.LAST%>";
	document.frmcontactclass.action="ticket_rate.jsp";
	document.frmcontactclass.submit();
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
            <form name="frmcontactclass" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_ticket_rate_id" value="<%=oidTicketRate%>">
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
                        <td height="22" valign="middle" colspan="3"> <%= drawList(SESS_LANGUAGE,iCommand,frmTicketRate, listTicketRate,oidTicketRate,start,vCarrier,vRoute,vClass)%> </td>
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
					String scomDel = "javascript:cmdAsk('"+oidTicketRate+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidTicketRate+"')";
					String scancel = "javascript:cmdEdit('"+oidTicketRate+"')";
					ctrLine.setCommandStyle("command");
					ctrLine.setColCommStyle("command");
					ctrLine.setCancelCaption(strCancel);
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
