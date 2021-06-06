
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
		  com.dimata.aiso.form.masterdata.FrmTicketMaster,
		  com.dimata.common.entity.contact.PstContactList,
		  com.dimata.aiso.entity.masterdata.PstAccountLink,
		  com.dimata.aiso.entity.masterdata.AccountLink,
		  com.dimata.aiso.entity.masterdata.PstPerkiraan,
		  com.dimata.aiso.entity.masterdata.Perkiraan,
		  com.dimata.interfaces.chartofaccount.I_ChartOfAccountGroup,	
		  com.dimata.common.entity.contact.ContactList,
		  com.dimata.common.entity.contact.PstContactClass,		
		  com.dimata.aiso.form.masterdata.CtrlTicketMaster"%>

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
	{"No","Kode","Airline","Perk. HPP","Perk. Hutang"},	
	{"No","Code","Airline","CoGs Account","A/P Account"}
};

public static final String masterTitle[] = {
	"Master Tiket","Ticket Master"	
};

public static final String classTitle[] = {
	"Penyedia Jasa Penerbangan","Carrier"	
};

public String getAccountName(int language, Perkiraan objPerkiraan){
	if(language == com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN)
		return objPerkiraan.getAccountNameEnglish();
	else
		return objPerkiraan.getNama();
}

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

public String drawList(int language,int iCommand,FrmTicketMaster frmTicketMaster, Vector objectClass, long oidTicketMaster, int iStart,Vector vContact,Vector vAccCogs, Vector vAccAP){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");	
	ctrlist.dataFormat(strTitle[language][0],"5%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"30%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"25%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"20%","center","left");
	ctrlist.dataFormat(strTitle[language][4],"20%","center","left");

	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);
	ctrlist.reset();
	int index = -1;
	
	Vector vContactVal = new Vector(1,1);
	Vector vContactKey = new Vector(1,1);
	String sSelectedContact = "";
	if(vContact != null && vContact.size() > 0){
		for(int c = 0; c < vContact.size(); c++){
			ContactList objContact = (ContactList)vContact.get(c);
			vContactVal.add(""+objContact.getOID());
			vContactKey.add(objContact.getCompName());
		}
	}

	Vector vCogsVal = new Vector(1,1);
	Vector vCogsKey = new Vector(1,1);
	String sSelectedCogs = "";
	if(vAccCogs != null && vAccCogs.size() > 0){
		for(int g = 0; g < vAccCogs.size(); g++){
			AccountLink objLinkCogs = (AccountLink)vAccCogs.get(g);
			Perkiraan objAccCogs = new Perkiraan();
			sSelectedCogs = ""+objLinkCogs.getFirstId();
			if(objLinkCogs.getFirstId() != 0){
				try{
					objAccCogs = PstPerkiraan.fetchExc(objLinkCogs.getFirstId());
				}catch(Exception e){}
			}
			vCogsVal.add(""+objLinkCogs.getFirstId());
			vCogsKey.add(getAccountName(language,objAccCogs));
		}
	}
	
	Vector vAPVal = new Vector(1,1);
	Vector vAPKey = new Vector(1,1);
	String sSelectedAP = "";
	if(vAccAP != null && vAccAP.size() > 0){
		for(int a = 0; a < vAccAP.size(); a++){
			AccountLink objLinkAP = (AccountLink)vAccAP.get(a);
			Perkiraan objAccAP = new Perkiraan();
			sSelectedAP = ""+objLinkAP.getFirstId();
			if(objLinkAP.getFirstId() != 0){
				try{
					objAccAP = PstPerkiraan.fetchExc(objLinkAP.getFirstId());
				}catch(Exception e){}
			}
			vAPVal.add(""+objLinkAP.getFirstId());
			vAPKey.add(getAccountName(language,objAccAP));
		}
	}

	for(int i=0; i<objectClass.size(); i++) {
		 TicketMaster objTicketMaster = (TicketMaster)objectClass.get(i);
		 sSelectedContact = String.valueOf(objTicketMaster.getContactId());		 
		
		 Perkiraan perkHPP = new Perkiraan();	
		 Perkiraan perkHutang = new Perkiraan();	
		 ContactList contact = new ContactList();
		 rowx = new Vector();
		 if(objTicketMaster.getContactId() != 0){
			try{
			    contact = PstContactList.fetchExc(objTicketMaster.getContactId());	
			}catch(Exception e){}
		 }
		 
		 if(objTicketMaster.getAccCogsId() > 0){
			try{
				perkHPP = PstPerkiraan.fetchExc(objTicketMaster.getAccCogsId());
			}catch(Exception e){}
		 }
		
		 if(objTicketMaster.getAccApId() > 0){
			try{
				perkHutang = PstPerkiraan.fetchExc(objTicketMaster.getAccApId());
			}catch(Exception e){}
		 }

		 if(oidTicketMaster == objTicketMaster.getOID())
		 	index = i;
		 
		 if(index==i && (iCommand==Command.EDIT || iCommand==Command.ASK)){
			rowx.add(""+(i+1));
			rowx.add("<input type=\"text\" name=\""+frmTicketMaster.fieldNames[frmTicketMaster.FRM_CODE] +"\" value=\""+objTicketMaster.getCode()+"\" class=\"elemenForm\">");
			rowx.add(""+ControlCombo.draw(frmTicketMaster.fieldNames[frmTicketMaster.FRM_CONTACT_ID], null, sSelectedContact, vContactVal, vContactKey,"","")+
					 "<input type=\"hidden\" name=\""+frmTicketMaster.fieldNames[frmTicketMaster.FRM_TYPE] +"\"  value=\""+PstTicketMaster.MASTER_CARRIER+"\">"
					);
			rowx.add(""+ControlCombo.draw(frmTicketMaster.fieldNames[frmTicketMaster.FRM_ACC_COGS_ID], null, sSelectedCogs, vCogsVal, vCogsKey,"",""));
			rowx.add(""+ControlCombo.draw(frmTicketMaster.fieldNames[frmTicketMaster.FRM_ACC_AP_ID], null, sSelectedAP, vAPVal, vAPKey,"",""));
		}else{
			rowx.add(""+(i+1));
			rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objTicketMaster.getOID())+"')\">"+objTicketMaster.getCode()+"</a>");
			rowx.add(contact.getCompName());
			rowx.add(getAccountName(language,perkHPP));
			rowx.add(getAccountName(language,perkHutang));
			
		} 

		lstData.add(rowx);
	}

	rowx = new Vector();
	if(iCommand==Command.ADD || (iCommand==Command.SAVE && frmTicketMaster.errorSize()>0)){ 
	
			rowx.add("");
			rowx.add("<input type=\"text\" name=\""+frmTicketMaster.fieldNames[frmTicketMaster.FRM_CODE] +"\" value=\"\" class=\"elemenForm\">");
			rowx.add(""+ControlCombo.draw(frmTicketMaster.fieldNames[frmTicketMaster.FRM_CONTACT_ID], null, sSelectedContact, vContactVal, vContactKey,"","")+
					 "<input type=\"hidden\" name=\""+frmTicketMaster.fieldNames[frmTicketMaster.FRM_TYPE] +"\"  value=\""+PstTicketMaster.MASTER_CARRIER+"\">"
					);
			rowx.add(""+ControlCombo.draw(frmTicketMaster.fieldNames[frmTicketMaster.FRM_ACC_COGS_ID], null, sSelectedCogs, vCogsVal, vCogsKey,"",""));
			rowx.add(""+ControlCombo.draw(frmTicketMaster.fieldNames[frmTicketMaster.FRM_ACC_AP_ID], null, sSelectedAP, vAPVal, vAPKey,"",""));
	}
	lstData.add(rowx);
	return ctrlist.drawMe(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidTicketMaster = FRMQueryString.requestLong(request, "hidden_ticket_master_id");

	
/*variable declaration*/
int recordToGet = 100;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = PstTicketMaster.fieldNames[PstTicketMaster.FLD_TYPE]+" = "+PstTicketMaster.MASTER_CARRIER;
String orderClause = PstTicketMaster.fieldNames[PstTicketMaster.FLD_DESCRIPTION];

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

CtrlTicketMaster ctrlTicketMaster = new CtrlTicketMaster(request);
ctrlTicketMaster.setLanguage(SESS_LANGUAGE);

Vector listTicketMaster = new Vector(1,1);
String whClsContact = PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE]+" = "+PstContactClass.FLD_CLASS_CARRIER;
String ordContact = PstContactList.fieldNames[PstContactList.FLD_COMP_NAME];
Vector vContact = PstContactList.listContactByClassType(0, 0, whClsContact, ordContact);
Vector vAccCogs = PstAccountLink.getVectObjAccountLink(0,I_ChartOfAccountGroup.ACC_GROUP_COST_OF_SALES);
Vector vAccAP = PstAccountLink.getVectObjAccountLink(0,I_ChartOfAccountGroup.ACC_GROUP_CURRENCT_LIABILITIES);

iErrCode = ctrlTicketMaster.action(iCommand , oidTicketMaster);
FrmTicketMaster frmTicketMaster = ctrlTicketMaster.getForm();

int vectSize = PstTicketMaster.getCount(whereClause); 

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlTicketMaster.actionList(iCommand, start, vectSize, recordToGet);
} 

TicketMaster objTicketMaster = ctrlTicketMaster.getTicketMaster();

msgString =  ctrlTicketMaster.getMessage();
listTicketMaster = PstTicketMaster.list(start,recordToGet, whereClause , orderClause);

if (listTicketMaster.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet){
			start = start - recordToGet; 
	 }else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; 
	 }
	 listTicketMaster = PstTicketMaster.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
	
	document.frmcontactclass.hidden_ticket_master_id.value="0";
	document.frmcontactclass.command.value="<%=Command.ADD%>";
	document.frmcontactclass.action="ticket_master_carrier.jsp";
	document.frmcontactclass.submit();
}

function cmdAsk(oidTicketMaster){
	document.frmcontactclass.hidden_ticket_master_id.value=oidTicketMaster;
	document.frmcontactclass.command.value="<%=Command.ASK%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_master_carrier.jsp";
	document.frmcontactclass.submit();
}

function cmdConfirmDelete(oidTicketMaster){
	document.frmcontactclass.hidden_ticket_master_id.value=oidTicketMaster;
	document.frmcontactclass.command.value="<%=Command.DELETE%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_master_carrier.jsp";
	document.frmcontactclass.submit();
}

function cmdSave(){
	document.frmcontactclass.command.value="<%=Command.SAVE%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_master_carrier.jsp";
	document.frmcontactclass.submit();
}

function cmdEdit(oidTicketMaster){
	document.frmcontactclass.hidden_ticket_master_id.value=oidTicketMaster;
	document.frmcontactclass.command.value="<%=Command.EDIT%>";
	document.frmcontactclass.action="ticket_master_carrier.jsp";
	document.frmcontactclass.submit();
}

function cmdCancel(oidTicketMaster){
	document.frmcontactclass.hidden_ticket_master_id.value=oidTicketMaster;
	document.frmcontactclass.command.value="<%=Command.EDIT%>";
	document.frmcontactclass.prev_command.value="<%=prevCommand%>";
	document.frmcontactclass.action="ticket_master_carrier.jsp";
	document.frmcontactclass.submit();
}

function cmdBack(){
	document.frmcontactclass.command.value="<%=Command.BACK%>";
	document.frmcontactclass.action="ticket_master_carrier.jsp";
	document.frmcontactclass.submit();
}

function first(){
	document.frmcontactclass.command.value="<%=Command.FIRST%>";
	document.frmcontactclass.prev_command.value="<%=Command.FIRST%>";
	document.frmcontactclass.action="ticket_master_carrier.jsp";
	document.frmcontactclass.submit();
}

function prev(){
	document.frmcontactclass.command.value="<%=Command.PREV%>";
	document.frmcontactclass.prev_command.value="<%=Command.PREV%>";
	document.frmcontactclass.action="ticket_master_carrier.jsp";
	document.frmcontactclass.submit();
}

function next(){
	document.frmcontactclass.command.value="<%=Command.NEXT%>";
	document.frmcontactclass.prev_command.value="<%=Command.NEXT%>";
	document.frmcontactclass.action="ticket_master_carrier.jsp";
	document.frmcontactclass.submit();
}

function last(){
	document.frmcontactclass.command.value="<%=Command.LAST%>";
	document.frmcontactclass.prev_command.value="<%=Command.LAST%>";
	document.frmcontactclass.action="ticket_master_carrier.jsp";
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
              <input type="hidden" name="hidden_ticket_master_id" value="<%=oidTicketMaster%>">
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
                        <td height="22" valign="middle" colspan="3"> <%= drawList(SESS_LANGUAGE,iCommand,frmTicketMaster, listTicketMaster,oidTicketMaster,start,vContact,vAccCogs,vAccAP)%> </td>
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
					String scomDel = "javascript:cmdAsk('"+oidTicketMaster+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidTicketMaster+"')";
					String scancel = "javascript:cmdEdit('"+oidTicketMaster+"')";
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
