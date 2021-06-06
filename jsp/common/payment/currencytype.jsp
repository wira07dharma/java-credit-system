<% 
/* 
 * Page Name  		:  currencytype.jsp
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

<!--package posbo -->
<%@ page import = "com.dimata.common.entity.currency.*" %>
<%@ page import = "com.dimata.common.form.currency.*" %>

<!--package ij -->
<%@ page import = "com.dimata.ij.iaiso.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% //int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--);
   int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_PAYMENT, AppObjInfo.OBJ_MASTERDATA_PAYMENT_CURRENCY_TYPE); %>
<%@ include file = "../../main/checkuser.jsp" %>

<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<!-- Jsp Block -->
<%!	
public static final String textListTitle[][] =
{
	{"Jenis Mata Uang"},
	{"Currency Type"}
};

public static final String textListHeader[][] =
{
	{"Kode","Nama","Keterangan","Urutan","Dipakai"},
	{"Code","Name","Description","Order by","Include"}
};

public String drawList(int iCommand, FrmCurrencyType frmObject, CurrencyType objEntity, Vector objectClass,  long currencyTypeId, int languange)
{
 	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("80%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.addHeader(textListHeader[languange][0],"10%");
	ctrlist.addHeader(textListHeader[languange][1],"30%");
	ctrlist.addHeader(textListHeader[languange][2],"40%");
	ctrlist.addHeader(textListHeader[languange][3],"10%");
	ctrlist.addHeader(textListHeader[languange][4],"10%");

	//ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	//Vector lstLinkData = ctrlist.getLinkData();
	Vector rowx = new Vector(1,1);                
	ctrlist.reset();
	int index = -1;

	for (int i = 0; i < objectClass.size(); i++) {
		 CurrencyType currencyType = (CurrencyType)objectClass.get(i);
		 rowx = new Vector();
		 if(currencyTypeId == currencyType.getOID())
			 index = i; 

		 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
				
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmCurrencyType.FRM_FIELD_CODE] +"\" size=\"10\" value=\""+currencyType.getCode()+"\" class=\"formElemen\">");
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmCurrencyType.FRM_FIELD_NAME] +"\" value=\""+currencyType.getName()+"\" class=\"formElemen\">");
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmCurrencyType.FRM_FIELD_DESCRIPTION] +"\" value=\""+currencyType.getDescription()+"\" class=\"formElemen\">");
							rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmCurrencyType.FRM_FIELD_TAB_INDEX] +"\" value=\""+currencyType.getTabIndex()+"\" size=\"5\" class=\"formElemen\">");
							String checkBox = "<input type=\"checkbox\" name=\""+frmObject.fieldNames[FrmCurrencyType.FRM_FIELD_INCLUDE_IN_PROCESS] +"\" value=\""+PstCurrencyType.INCLUDE+"\" class=\"formElemen\"";
							if(currencyType.getIncludeInProcess()==PstCurrencyType.INCLUDE){
							  checkBox = checkBox +" checked >";
							}else{
							  checkBox = checkBox +" >"; 
							}
							rowx.add(checkBox);                                                              
		}else{
			rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(currencyType.getOID())+"')\">"+currencyType.getCode()+"</a>");
			rowx.add(currencyType.getName());
			rowx.add(currencyType.getDescription());
							rowx.add(""+currencyType.getTabIndex());
							rowx.add(PstCurrencyType.includeName[languange][currencyType.getIncludeInProcess()]);
							  
		}                         
					lstData.add(rowx); 
		
	}

	 rowx = new Vector();

	if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmCurrencyType.FRM_FIELD_CODE] +"\" size=\"10\" value=\""+objEntity.getCode()+"\" class=\"formElemen\">");
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmCurrencyType.FRM_FIELD_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\">");
			rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmCurrencyType.FRM_FIELD_DESCRIPTION] +"\" value=\""+objEntity.getDescription()+"\" class=\"formElemen\">");
							rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmCurrencyType.FRM_FIELD_TAB_INDEX] +"\" value=\""+objEntity.getTabIndex()+"\" size=\"5\" class=\"formElemen\">");
							rowx.add("<input type=\"checkbox\" name=\""+frmObject.fieldNames[FrmCurrencyType.FRM_FIELD_INCLUDE_IN_PROCESS] +"\" value=\""+PstCurrencyType.INCLUDE+"\" class=\"formElemen\" checked >");
			}  
	lstData.add(rowx);

	return ctrlist.draw(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidCurrencyType = FRMQueryString.requestLong(request, "hidden_currency_type_id");

// variable declaration
boolean privManageData = true; 
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = ""+PstCurrencyType.fieldNames[PstCurrencyType.FLD_TAB_INDEX];

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = textListTitle[SESS_LANGUAGE][0];
String strAddMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackMar = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";


CtrlCurrencyType ctrlCurrencyType = new CtrlCurrencyType(request);
iErrCode = ctrlCurrencyType.action(iCommand, oidCurrencyType);
FrmCurrencyType frmCurrencyType = ctrlCurrencyType.getForm();
CurrencyType currencyType = ctrlCurrencyType.getCurrencyType();
msgString =  ctrlCurrencyType.getMessage();

Vector listCurrencyType = new Vector(1,1);
int vectSize = PstCurrencyType.getCount(whereClause);
if( iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST)
{
	start = ctrlCurrencyType.actionList(iCommand, start, vectSize, recordToGet);
} 

listCurrencyType = PstCurrencyType.list(start,recordToGet, whereClause , orderClause);
if (listCurrencyType.size() < 1 && start > 0)
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
	 listCurrencyType = PstCurrencyType.list(start, recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
	document.frmcurrencytype.hidden_currency_type_id.value="0";
	document.frmcurrencytype.command.value="<%=Command.ADD%>";
	document.frmcurrencytype.prev_command.value="<%=prevCommand%>";
	document.frmcurrencytype.action="currencytype.jsp";
	document.frmcurrencytype.submit();
}

function cmdAsk(oidCurrencyType){
	document.frmcurrencytype.hidden_currency_type_id.value=oidCurrencyType;
	document.frmcurrencytype.command.value="<%=Command.ASK%>";
	document.frmcurrencytype.prev_command.value="<%=prevCommand%>";
	document.frmcurrencytype.action="currencytype.jsp";
	document.frmcurrencytype.submit();
}

function cmdConfirmDelete(oidCurrencyType){
	document.frmcurrencytype.hidden_currency_type_id.value=oidCurrencyType;
	document.frmcurrencytype.command.value="<%=Command.DELETE%>";
	document.frmcurrencytype.prev_command.value="<%=prevCommand%>";
	document.frmcurrencytype.action="currencytype.jsp";
	document.frmcurrencytype.submit();
}

function cmdSave(){
	document.frmcurrencytype.command.value="<%=Command.SAVE%>";
	document.frmcurrencytype.prev_command.value="<%=prevCommand%>";
	document.frmcurrencytype.action="currencytype.jsp";
	document.frmcurrencytype.submit();
}

function cmdEdit(oidCurrencyType){
	document.frmcurrencytype.hidden_currency_type_id.value=oidCurrencyType;
	document.frmcurrencytype.command.value="<%=Command.EDIT%>";
	document.frmcurrencytype.prev_command.value="<%=prevCommand%>";
	document.frmcurrencytype.action="currencytype.jsp";
	document.frmcurrencytype.submit();
}

function cmdCancel(oidCurrencyType){
	document.frmcurrencytype.hidden_currency_type_id.value=oidCurrencyType;
	document.frmcurrencytype.command.value="<%=Command.EDIT%>";
	document.frmcurrencytype.prev_command.value="<%=prevCommand%>";
	document.frmcurrencytype.action="currencytype.jsp";
	document.frmcurrencytype.submit();
}

function cmdBack(){
	document.frmcurrencytype.command.value="<%=Command.BACK%>";
	document.frmcurrencytype.action="currencytype.jsp";
	document.frmcurrencytype.submit();
}

function cmdListFirst(){
	document.frmcurrencytype.command.value="<%=Command.FIRST%>";
	document.frmcurrencytype.prev_command.value="<%=Command.FIRST%>";
	document.frmcurrencytype.action="currencytype.jsp";
	document.frmcurrencytype.submit();
}

function cmdListPrev(){
	document.frmcurrencytype.command.value="<%=Command.PREV%>";
	document.frmcurrencytype.prev_command.value="<%=Command.PREV%>";
	document.frmcurrencytype.action="currencytype.jsp";
	document.frmcurrencytype.submit();
}

function cmdListNext(){
	document.frmcurrencytype.command.value="<%=Command.NEXT%>";
	document.frmcurrencytype.prev_command.value="<%=Command.NEXT%>";
	document.frmcurrencytype.action="currencytype.jsp";
	document.frmcurrencytype.submit();
}

function cmdListLast(){
	document.frmcurrencytype.command.value="<%=Command.LAST%>";
	document.frmcurrencytype.prev_command.value="<%=Command.LAST%>";
	document.frmcurrencytype.action="currencytype.jsp";
	document.frmcurrencytype.submit();
}
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->Master 
            Data &gt; <%=textListTitle[SESS_LANGUAGE][0]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmcurrencytype" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_currency_type_id" value="<%=oidCurrencyType%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="listgenactivity">
                      <tr align="left" valign="top"> 
                        <td height="8" valign="middle" colspan="3">&nbsp; 
                        </td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,frmCurrencyType, currencyType,listCurrencyType,oidCurrencyType,SESS_LANGUAGE)%> </td>
                      </tr>
                      <tr align="left" valign="top">
                        <td height="8" align="left" colspan="3" class="command"><% 
						  int cmd = 0;
						  if(iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST)
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
						  %>
                        <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"cmdListFirst","cmdListPrev","cmdListNext","cmdListLast","left")%> </td>
                      </tr>
                      <tr align="left" valign="top">
                        <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td height="8" align="left" colspan="3" class="command"> 
                          <span class="command">
                          <%
					ctrLine.setLocationImg(approot+"/images");						  
					ctrLine.initDefault();
					ctrLine.setTableWidth("80%");
					String scomDel = "javascript:cmdAsk('"+oidCurrencyType+"')";
					String sconDelCom = "javascript:cmdConfirmDelete('"+oidCurrencyType+"')";
					String scancel = "javascript:cmdEdit('"+oidCurrencyType+"')";
					ctrLine.setCommandStyle("command");
					ctrLine.setColCommStyle("command");
					ctrLine.setAddCaption(strAddMar);
					//ctrLine.setBackCaption("");
					ctrLine.setCancelCaption(strCancel);														
					ctrLine.setBackCaption("");														
					ctrLine.setSaveCaption(strSaveMar);
					ctrLine.setDeleteCaption(strAskMar);
					ctrLine.setConfirmDelCaption(strDeleteMar);

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
					
					if(iCommand == Command.ASK)
					{
						ctrLine.setDeleteQuestion(delConfirm); 
					}					
					out.println(ctrLine.draw(iCommand, iErrCode, msgString));
					%>
					</span> </td>
                      </tr>
                      <%
					  if(privAdd && (iErrCode==ctrlCurrencyType.RSLT_OK) && (iCommand!=Command.ADD) && (iCommand!=Command.ASK) && (iCommand!=Command.EDIT) && (frmCurrencyType.errorSize()==0) )
					  { 
					  %>					  
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> 
                          <table width="20%" border="0" cellspacing="0" cellpadding="0">
                            <tr>&nbsp;<a href="javascript:cmdAdd()" class="command"><%//=strAddMar%></a></tr>
                          </table>
                        </td>
                      </tr>
					  <%					  
					  }
					  %>
                    </table>
                  </td>
                </tr>
				
				<%
				if( (iCommand ==Command.ADD) || (iCommand==Command.SAVE) && (frmCurrencyType.errorSize()>0) || (iCommand==Command.EDIT) || (iCommand==Command.ASK) )
				{
				%>				
                <tr align="left" valign="top" > 
                  <td colspan="3" class="command">&nbsp; 
				    </td>
                </tr>
				<%
				}
				%>
              </table>
            </form>
            <%
			if(iCommand==Command.ADD || iCommand==Command.EDIT)
			{
			%>
            <script language="javascript">
				document.frmcurrencytype.<%=FrmCurrencyType.fieldNames[FrmCurrencyType.FRM_FIELD_CODE]%>.focus();
			</script>
            <%
			}
			%>
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

