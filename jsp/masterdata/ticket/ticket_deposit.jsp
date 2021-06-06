
<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<%@ page import = "com.dimata.aiso.entity.masterdata.TicketMaster,
		  com.dimata.aiso.entity.masterdata.PstTicketMaster,
		  com.dimata.aiso.entity.masterdata.TicketList,
		  com.dimata.aiso.entity.masterdata.PstTicketList,
		  com.dimata.aiso.entity.masterdata.TicketDeposit,
		  com.dimata.aiso.entity.masterdata.PstTicketDeposit,
		  com.dimata.aiso.form.masterdata.FrmTicketDeposit,
		  com.dimata.aiso.form.masterdata.CtrlTicketDeposit"%>

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
	{"No","Penyedia Jasa Penerbangan","Tanggal","Uang Muka","Keterangan"},	
	{"No","Carrier","Date","Deposit","Description"}
};

public static final String masterTitle[] = {
	"Master Tiket","Ticket Master"	
};

public static final String classTitle[] = {
	"Daftar Uang Muka Tiket","Deposit Ticket List"	
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

public String drawList(int language,int iCommand,FrmTicketDeposit frmTicketDeposit, Vector objectClass, long oidTicketDeposit, int iStart, Vector vCarrier){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("80%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");	
	ctrlist.dataFormat(strTitle[language][0],"5%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"15%","center","center");
	ctrlist.dataFormat(strTitle[language][3],"25%","center","right");
	ctrlist.dataFormat(strTitle[language][4],"45%","center","left");

	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);
	ctrlist.reset();
	int index = -1;

	TicketMaster objCarrier = new TicketMaster();
	TicketDeposit objTicketDeposit = new TicketDeposit();
	Vector vCarrierVal = new Vector(1,1);
	Vector vCarrierKey = new Vector(1,1);
	String selectedVal = "";
	String statusTicket = "";	

	if(vCarrier != null && vCarrier.size() > 0){
		vCarrierVal = (Vector)vCarrier.get(0);
		vCarrierKey = (Vector)vCarrier.get(1);
	}
	
	
	for(int i=0; i<objectClass.size(); i++) {
		 objTicketDeposit = (TicketDeposit)objectClass.get(i);

		  if(objTicketDeposit.getCarrierId() != 0){
			selectedVal = String.valueOf(objTicketDeposit.getCarrierId()); 
			try{
				objCarrier = PstTicketMaster.fetchExc(objTicketDeposit.getCarrierId());
			}catch(Exception e){}
		 }
				 
		 rowx = new Vector();
		
		 if(oidTicketDeposit == objTicketDeposit.getOID())
		 	index = i;
		 
		 if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
			rowx.add(""+(i+1+iStart));
			rowx.add(""+ControlCombo.draw(frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_CARRIER_ID], null, selectedVal, vCarrierVal, vCarrierKey,"","")+"");
			rowx.add("<input type=\"text\" size=\"15\" onClick=\"ds_sh(this);\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DEPOSIT_DATE] +"\" readonly=\"readonly\" style=\"cursor: text\" value=\""+Formater.formatDate((objTicketDeposit.getDepositDate() == null) ? new Date() : objTicketDeposit.getDepositDate(), "dd-MM-yyyy")+"\" class=\"formElemenR\">"+
					"<input type=\"hidden\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DEPOSIT_DATE] +"_mn\">"+
					"<input type=\"hidden\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DEPOSIT_DATE] +"_dy\">"+
					"<input type=\"hidden\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DEPOSIT_DATE] +"_yr\">"+
					"<script language=\"JavaScript\" type=\"text/JavaScript\">getThn();</script>");
			rowx.add("<input type=\"text\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DEPOSIT_AMOUNT] +"\"  class=\"elemenForm\" value=\""+Formater.formatNumber(objTicketDeposit.getDepositAmount(),"###")+"\" size=\"20\">");
			rowx.add("<input type=\"text\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DESCRIPTION] +"\"  class=\"elemenForm\" value=\""+objTicketDeposit.getDescription()+"\" size=\"20\">");
		}else{
			rowx.add(""+(i+1+iStart));
			rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objTicketDeposit.getOID())+"')\">"+objCarrier.getCode()+"</a>");
			rowx.add(Formater.formatDate((objTicketDeposit.getDepositDate() == null) ? new Date() : objTicketDeposit.getDepositDate(), "dd-MM-yyyy"));
			rowx.add(Formater.formatNumber(objTicketDeposit.getDepositAmount(),"##,###.##"));
			rowx.add(objTicketDeposit.getDescription());
			
		} 

		lstData.add(rowx);
	}

	rowx = new Vector();
	if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmTicketDeposit.errorSize()>0)){ 
	
			rowx.add("");
			rowx.add(""+ControlCombo.draw(frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_CARRIER_ID], null, selectedVal, vCarrierVal, vCarrierKey,"","")+"");
			rowx.add("<input type=\"text\" size=\"15\" onClick=\"ds_sh(this);\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DEPOSIT_DATE] +"\" readonly=\"readonly\" style=\"cursor: text\" value=\""+Formater.formatDate((objTicketDeposit.getDepositDate() == null) ? new Date() : objTicketDeposit.getDepositDate(), "dd-MM-yyyy")+"\" class=\"formElemenR\">"+
					"<input type=\"hidden\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DEPOSIT_DATE] +"_mn\">"+
					"<input type=\"hidden\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DEPOSIT_DATE] +"_dy\">"+
					"<input type=\"hidden\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DEPOSIT_DATE] +"_yr\">"+
					"<script language=\"JavaScript\" type=\"text/JavaScript\">getThn();</script>");
			rowx.add("<input type=\"text\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DEPOSIT_AMOUNT] +"\"  class=\"elemenForm\" value=\"\" size=\"30\">");
			rowx.add("<input type=\"text\" name=\""+frmTicketDeposit.fieldNames[frmTicketDeposit.FRM_DESCRIPTION] +"\"  class=\"elemenForm\" value=\"\" size=\"40\">");
	}
	lstData.add(rowx);
	return ctrlist.drawMe(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidTicketDeposit = FRMQueryString.requestLong(request, "hidden_ticket_deposit_id");

	
/*variable declaration*/
int recordToGet = 100;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = PstTicketDeposit.fieldNames[PstTicketDeposit.FLD_CARRIER_ID]+", "+PstTicketDeposit.fieldNames[PstTicketDeposit.FLD_DEPOSIT_DATE]+", "+PstTicketDeposit.fieldNames[PstTicketDeposit.FLD_DEPOSIT_AMOUNT];
String whClause = PstTicketMaster.fieldNames[PstTicketMaster.FLD_TYPE]+" = "+PstTicketMaster.MASTER_CARRIER;
String odClause = PstTicketMaster.fieldNames[PstTicketMaster.FLD_CODE];

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

CtrlTicketDeposit ctrlTicketDeposit = new CtrlTicketDeposit(request);
ctrlTicketDeposit.setLanguage(SESS_LANGUAGE);

Vector ticketDeposit = new Vector(1,1);
Vector listTicketMaster = PstTicketMaster.list(start,recordToGet, whClause , odClause);
Vector vCarrier = new Vector(1,1);
Vector vCarrierVal = new Vector(1,1);
Vector vCarrierKey = new Vector(1,1);

if(listTicketMaster != null && listTicketMaster.size() > 0){
	for(int i = 0; i < listTicketMaster.size(); i++){
		TicketMaster objCarrier = (TicketMaster)listTicketMaster.get(i);
		vCarrierVal.add(""+objCarrier.getOID());
		vCarrierKey.add(objCarrier.getCode());	
	}
	vCarrier.add(vCarrierVal);
	vCarrier.add(vCarrierKey);
}

iErrCode = ctrlTicketDeposit.action(iCommand , oidTicketDeposit);
FrmTicketDeposit frmTicketDeposit = ctrlTicketDeposit.getForm();

int vectSize = PstTicketDeposit.getCount(whereClause); 

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlTicketDeposit.actionList(iCommand, start, vectSize, recordToGet);
} 

TicketDeposit objTicketDeposit = ctrlTicketDeposit.getTicketDeposit();

msgString =  ctrlTicketDeposit.getMessage();
ticketDeposit = PstTicketDeposit.list(start,recordToGet, whereClause , orderClause);

if (ticketDeposit.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet){
			start = start - recordToGet; 
	 }else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 ticketDeposit = PstTicketDeposit.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function getThn()
{
	
	var date = ""+document.frmcontactclass.<%=FrmTicketDeposit.fieldNames[FrmTicketDeposit.FRM_DEPOSIT_DATE]%>.value;
	
	var thn = date.substring(6,10);
	var bln = date.substring(3,5);	
	if(bln.charAt(0)=="0"){
		bln = ""+bln.charAt(1);
	}

	var hri = date.substring(0,2);
	if(hri.charAt(0)=="0"){
		hri = ""+hri.charAt(1);
	}

	document.frmcontactclass.<%=FrmTicketDeposit.fieldNames[FrmTicketDeposit.FRM_DEPOSIT_DATE]%>_mn.value=bln;
	document.frmcontactclass.<%=FrmTicketDeposit.fieldNames[FrmTicketDeposit.FRM_DEPOSIT_DATE]%>_dy.value=hri;
	document.frmcontactclass.<%=FrmTicketDeposit.fieldNames[FrmTicketDeposit.FRM_DEPOSIT_DATE]%>_yr.value=thn;
	
}

function cmdAdd(){
	document.frmcontactclass.hidden_ticket_deposit_id.value="0";
	document.frmcontactclass.command.value="<%=Command.ADD%>";
	document.frmcontactclass.action="ticket_deposit.jsp";
	document.frmcontactclass.submit();
}

function cmdAsk(oidTicketDeposit){
	document.frmcontactclass.hidden_ticket_deposit_id.value=oidTicketDeposit;
	document.frmcontactclass.command.value="<%=Command.ASK%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_deposit.jsp";
	document.frmcontactclass.submit();
}

function cmdConfirmDelete(oidTicketDeposit){
	document.frmcontactclass.hidden_ticket_deposit_id.value=oidTicketDeposit;
	document.frmcontactclass.command.value="<%=Command.DELETE%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_deposit.jsp";
	document.frmcontactclass.submit();
}

function cmdSave(){
	document.frmcontactclass.command.value="<%=Command.SAVE%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_deposit.jsp";
	document.frmcontactclass.submit();
}

function cmdEdit(oidTicketDeposit){
	document.frmcontactclass.hidden_ticket_deposit_id.value=oidTicketDeposit;
	document.frmcontactclass.command.value="<%=Command.EDIT%>";
	document.frmcontactclass.action="ticket_deposit.jsp";
	document.frmcontactclass.submit();
}

function cmdCancel(oidTicketDeposit){
	document.frmcontactclass.hidden_ticket_deposit_id.value=oidTicketDeposit;
	document.frmcontactclass.command.value="<%=Command.EDIT%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_deposit.jsp";
	document.frmcontactclass.submit();
}

function cmdBack(){
	document.frmcontactclass.command.value="<%=Command.BACK%>";
	document.frmcontactclass.action="ticket_deposit.jsp";
	document.frmcontactclass.submit();
}

function first(){
	document.frmcontactclass.command.value="<%=Command.FIRST%>";
	document.frmcontactclass.prev_command.value="<%=Command.FIRST%>";
	document.frmcontactclass.action="ticket_deposit.jsp";
	document.frmcontactclass.submit();
}

function prev(){
	document.frmcontactclass.command.value="<%=Command.PREV%>";
	document.frmcontactclass.prev_command.value="<%=Command.PREV%>";
	document.frmcontactclass.action="ticket_deposit.jsp";
	document.frmcontactclass.submit();
}

function next(){
	document.frmcontactclass.command.value="<%=Command.NEXT%>";
	document.frmcontactclass.prev_command.value="<%=Command.NEXT%>";
	document.frmcontactclass.action="ticket_deposit.jsp";
	document.frmcontactclass.submit();
}

function last(){
	document.frmcontactclass.command.value="<%=Command.LAST%>";
	document.frmcontactclass.prev_command.value="<%=Command.LAST%>";
	document.frmcontactclass.action="ticket_deposit.jsp";
	document.frmcontactclass.submit();
}

function hideObjectForDate(){
  }
	
  function showObjectForDate(){
  }

</script>
<link rel="stylesheet" href="../../style/calendar.css" type="text/css">
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
		<%if(isUseDatePicker.equalsIgnoreCase("Y")){%> 
      		<table class="ds_box" cellpadding="0" cellspacing="0" id="ds_conclass" style="display: none;">
			<tr><td id="ds_calclass">
			</td></tr>
			</table>
			<script language=JavaScript src="<%=approot%>/main/calendar.js"></script>
			<%}%>	
           <%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmcontactclass" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_ticket_deposit_id" value="<%=oidTicketDeposit%>">
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
                        <td height="22" valign="middle" colspan="3"> <%= drawList(SESS_LANGUAGE,iCommand,frmTicketDeposit, ticketDeposit,oidTicketDeposit,start,vCarrier)%> </td>
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
					String scomDel = "javascript:cmdAsk('"+oidTicketDeposit+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidTicketDeposit+"')";
					String scancel = "javascript:cmdEdit('"+oidTicketDeposit+"')";
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
