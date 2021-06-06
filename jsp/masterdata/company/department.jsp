 
<% 
/* 
 * Page Name  		:  department.jsp
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
<!--package HRIS -->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>
<%@ page import = "com.dimata.harisma.form.masterdata.*" %>

<%@ include file = "../../main/javainit.jsp" %>

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_HRD, AppObjInfo.OBJ_MASTERDATA_HRD_DEPARTMENT); %>
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
	{"Departemen","Keterangan"},	
	{"Department","Description"}
};

public static final String masterTitle[] = {
	"Perusahaan","Company"	
};

public static final String deptTitle[] = {
	"Departemen","Department"	
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

public String drawList(int language,Vector objectClass,long departmentId){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("80%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strTitle[language][0],"30%","left","left");
	ctrlist.dataFormat(strTitle[language][1],"50%","left","left");

	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;

	for (int i = 0; i < objectClass.size(); i++) {
		Department department = (Department)objectClass.get(i);
		Vector rowx = new Vector();
		if(departmentId == department.getOID())
			index = i;

		rowx.add(department.getDepartment());
		rowx.add(department.getDescription());

		lstData.add(rowx);
		lstLinkData.add(String.valueOf(department.getOID()));
	}
	return ctrlist.drawMe(index);
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidDepartment = FRMQueryString.requestLong(request, "hidden_department_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = deptTitle[SESS_LANGUAGE];
String strAddDept = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveDept = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskDept = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteDept = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackDept = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";


CtrlDepartment ctrlDepartment = new CtrlDepartment(request);
Vector listDepartment = new Vector(1,1);

/*switch statement */
iErrCode = ctrlDepartment.action(iCommand , oidDepartment);
/* end switch*/
FrmDepartment frmDepartment = ctrlDepartment.getForm();

/*count list All Department*/
int vectSize = PstDepartment.getCount(whereClause);

Department department = ctrlDepartment.getDepartment();
msgString =  ctrlDepartment.getMessage();

/*switch list Department*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstDepartment.findLimitStart(department.getOID(),recordToGet, whereClause,"");

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlDepartment.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listDepartment = PstDepartment.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listDepartment.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listDepartment = PstDepartment.list(start,recordToGet, whereClause , orderClause);
}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--



function cmdAdd(){
	document.frmdepartment.hidden_department_id.value="0";
	document.frmdepartment.command.value="<%=Command.ADD%>";
	document.frmdepartment.prev_command.value="<%=prevCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdAsk(oidDepartment){
	document.frmdepartment.hidden_department_id.value=oidDepartment;
	document.frmdepartment.command.value="<%=Command.ASK%>";
	document.frmdepartment.prev_command.value="<%=prevCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdConfirmDelete(oidDepartment){
	document.frmdepartment.hidden_department_id.value=oidDepartment;
	document.frmdepartment.command.value="<%=Command.DELETE%>";
	document.frmdepartment.prev_command.value="<%=prevCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}
function cmdSave(){
	document.frmdepartment.command.value="<%=Command.SAVE%>";
	document.frmdepartment.prev_command.value="<%=prevCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
	}

function cmdEdit(oidDepartment){
	document.frmdepartment.hidden_department_id.value=oidDepartment;
	document.frmdepartment.command.value="<%=Command.EDIT%>";
	document.frmdepartment.prev_command.value="<%=prevCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
	}

function cmdCancel(oidDepartment){
	document.frmdepartment.hidden_department_id.value=oidDepartment;
	document.frmdepartment.command.value="<%=Command.EDIT%>";
	document.frmdepartment.prev_command.value="<%=prevCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdBack(){
	document.frmdepartment.command.value="<%=Command.BACK%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
	}

function first(){
	document.frmdepartment.command.value="<%=Command.FIRST%>";
	document.frmdepartment.prev_command.value="<%=Command.FIRST%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function prev(){
	document.frmdepartment.command.value="<%=Command.PREV%>";
	document.frmdepartment.prev_command.value="<%=Command.PREV%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
	}

function next(){
	document.frmdepartment.command.value="<%=Command.NEXT%>";
	document.frmdepartment.prev_command.value="<%=Command.NEXT%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function last(){
	document.frmdepartment.command.value="<%=Command.LAST%>";
	document.frmdepartment.prev_command.value="<%=Command.LAST%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

//-------------- script control line -------------------
//-->
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
            <%=masterTitle[SESS_LANGUAGE]%> &gt; Master Data &gt; <%=currPageTitle%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmdepartment" method ="post" action="">
              <input type="hidden" name="command" value="<%=iCommand%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="hidden_department_id" value="<%=oidDepartment%>">
              <table border="0" width="100%">
                <tr> 
                  <td height="8"> 
                    &nbsp;
                  </td>
                </tr>
              </table>			  
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top"> 
                  <td height="8"  colspan="3"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <%
							try{
								if (listDepartment.size()>0){
							%>
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> <%= drawList(SESS_LANGUAGE,listDepartment,oidDepartment)%> </td>
                      </tr>
                      <%  } 
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
                          <%="&nbsp;"+ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"first","prev","next","last","left")%> </span> </td>
                      </tr>
                      <%if(privAdd && (iErrCode==CtrlDepartment.RSLT_OK)&&(iCommand!=Command.ADD)&&(iCommand!=Command.ASK)&&(iCommand!=Command.EDIT)&&(frmDepartment.errorSize()==0)){ %>
                      <tr align="left" valign="top"> 
                        <td> 
                          <table cellpadding="0" cellspacing="0" border="0">
                            <tr> 
                              <td height="22" valign="middle" colspan="3" width="951"> 
                                <a href="javascript:cmdAdd()" class="command"><%=strAddDept%></a> </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <%}%>
                    </table>
                  </td>
                </tr>
                <tr align="left" valign="top">
                  <td height="8" valign="middle" colspan="3">&nbsp;</td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="8" valign="middle" colspan="3"> 
                    <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(frmDepartment.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                      <tr> 
                        <td height="100%"> 
                          <table border="0" cellspacing="2" cellpadding="2" width="50%">
                            <tr align="left" valign="top"> 
                              <td valign="top" width="20%"><%=getJspTitle(strTitle,0,SESS_LANGUAGE,currPageTitle,false)%></td>
                              <td width="2%">:</td>
                              <td width="78%"> 
                                <input type="text" name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_DEPARTMENT] %>"  value="<%= department.getDepartment() %>" class="elemenForm" size="35">
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td valign="top" width="20%"><%=getJspTitle(strTitle,1,SESS_LANGUAGE,currPageTitle,false)%></td>
                              <td width="2%">:</td>
                              <td width="78%"> 
                                <textarea name="<%=frmDepartment.fieldNames[FrmDepartment.FRM_FIELD_DESCRIPTION] %>" class="elemenForm" cols="30" rows="3"><%= department.getDescription() %></textarea>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr align="left" valign="top" > 
                        <td class="command"> 
                          <%
							ctrLine.setLocationImg(approot+"/images");						  
							ctrLine.initDefault();
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidDepartment+"')";
							String sconDelCom = "javascript:cmdConfirmDelete('"+oidDepartment+"')";
							String scancel = "javascript:cmdEdit('"+oidDepartment+"')";
							ctrLine.setBackCaption("Back to List");
							ctrLine.setCommandStyle("command");
							ctrLine.setColCommStyle("command");
							ctrLine.setCancelCaption(strCancel);
							ctrLine.setBackCaption(strBackDept);
							ctrLine.setSaveCaption(strSaveDept);
							ctrLine.setConfirmDelCaption(strDeleteDept);
							ctrLine.setDeleteCaption(strAskDept);									

							if(privDelete){
								ctrLine.setConfirmDelCommand(sconDelCom);
								ctrLine.setDeleteCommand(scomDel);
								ctrLine.setEditCommand(scancel);
							}else{ 
								ctrLine.setConfirmDelCaption("");
								ctrLine.setDeleteCaption("");
								ctrLine.setEditCaption("");
							}

							if(!privAdd && !privUpdate){
								ctrLine.setSaveCaption("");
							}

							if(!privAdd){
								ctrLine.setAddCaption("");
							}
							
							if(iCommand==Command.ASK)
								ctrLine.setDeleteQuestion(delConfirm);								
						  %>
                          <%=ctrLine.draw(iCommand,iErrCode,msgString)%> 
						  </td>
                      </tr>
                    </table>
                    <%}%>
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
<!-- endif of "has access" condition -->
<%}%>