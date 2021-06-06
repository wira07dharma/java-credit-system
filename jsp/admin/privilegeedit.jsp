 <%
/*
 * privilegeedit.jsp
 *
 * Created on April 04, 2002, 11:30 AM
 *
 * @author  ktanjana
 * @version 
 */
%>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<%@ page import = "com.dimata.aiso.entity.admin.*" %>
<%@ page import = "com.dimata.aiso.form.admin.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_PRIVILEGE); %>
<%@ include file = "../main/checkuser.jsp" %>
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

<!-- JSP Block -->
<%!
public static String strTitle[][] = {
	{"Nama","Keterangan","Grup 1","Grup 2","Modul","Hak Akses"},		
	{"Name","Description","Group 1","Group 2","Module","Authorization"}
};

public static final String systemTitle[] = {
	"Sistem > Manajemen User","System > User Management"	
};

public static final String userTitle[] = {
	"Privilege","Privilege"	
};

public static final String accessTitle[] = {
	"Hak Akses","Module Access"	
};

public String drawListPrivObj(int language, Vector objectClass){
	String temp = "";
	String regdatestr = "";

	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen"); 
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.addHeader(strTitle[language][2],"20%");
	ctrlist.addHeader(strTitle[language][3],"20%");
	ctrlist.addHeader(strTitle[language][4],"20%");
	ctrlist.addHeader(strTitle[language][5],"30%");

	ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");
	
	Vector lstData = ctrlist.getData();
	Vector lstLinkData 	= ctrlist.getLinkData();					
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	
	for (int i = 0; i < objectClass.size(); i++) {
		 AppPrivilegeObj appPrivObj = (AppPrivilegeObj) objectClass.get(i);

		 Vector rowx = new Vector();
                 rowx.add(AppObjInfo.getTitleGroup1((int)appPrivObj.getCode()));      
                 rowx.add(AppObjInfo.getTitleGroup2((int)appPrivObj.getCode()));  
                 rowx.add(AppObjInfo.getTitleObject((int)appPrivObj.getCode()));   
                 
                 Vector cmdInts = appPrivObj.getCommands();
                 String cmdStr = new String("");
                 for(int ic=0;ic< cmdInts.size() ; ic++){
                    cmdStr =cmdStr + AppObjInfo.getStrCommand(((Integer)cmdInts.get(ic)).intValue())+", ";
                 }
                 if(cmdStr.length()>0)
                    cmdStr = cmdStr.substring(0, cmdStr.length()-2);
                 
                 rowx.add(cmdStr);
		 
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(appPrivObj.getOID()));
	}						

	return ctrlist.draw();
}
%>

<% 
/* VARIABLE DECLARATION */
int recordToGet = 5;
String order = " " + PstAppPrivilegeObj.fieldNames[PstAppPrivilegeObj.FLD_CODE];

ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);

String currPageTitle = accessTitle[SESS_LANGUAGE];
String strAddAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackAcc = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strBackPriv = ctrLine.getCommand(SESS_LANGUAGE,userTitle[SESS_LANGUAGE],ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";


Vector listAppPrivObj = new Vector(1,1);

/* GET REQUEST FROM HIDDEN TEXT */
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
int listCommand = FRMQueryString.requestInt(request, "list_command");
if(listCommand==Command.NONE)
	listCommand = Command.FIRST;
long appPrivOID = FRMQueryString.requestLong(request,"appriv_oid");
long appPrivObjOID = FRMQueryString.requestLong(request,"apprivobj_oid");

CtrlAppPrivilegeObj ctrlAppPrivObj = new CtrlAppPrivilegeObj(request);
FrmAppPrivilegeObj frmAppPrivObj = ctrlAppPrivObj.getForm();

String cmdIdxString[] = request.getParameterValues("cmd_assigned");

  
/* GET OBJECT */ 
AppPriv appPriv = PstAppPriv.fetch(appPrivOID);

ctrlAppPrivObj.action(iCommand, appPrivObjOID);
AppPrivilegeObj appPrivObj= ctrlAppPrivObj.getAppPrivObj(); 

int vectSize = PstAppPrivilegeObj.getCountByPrivOID_GroupByObj(appPrivOID); 


/* GET Modules Access */
int appObjG1 = FRMQueryString.requestInt(request,FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G1_IDX]);
int appObjG2 = FRMQueryString.requestInt(request,FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G2_IDX]);
int appObjIdx = FRMQueryString.requestInt(request,FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_OBJ_IDX]);

if(iCommand == Command.EDIT){  
  appObjG1 =(AppObjInfo.getIdxGroup1((int)appPrivObj.getCode()));
  appObjG2 =(AppObjInfo.getIdxGroup2((int)appPrivObj.getCode()));
  appObjIdx =(AppObjInfo.getIdxObject((int)appPrivObj.getCode())); 
  appObjG1 = appObjG1<0 ? 0 : appObjG1;
  appObjG2 = appObjG2<0 ? 0 : appObjG2;
  appObjIdx = appObjIdx<0 ? 0 : appObjIdx;
}

start=ctrlAppPrivObj.actionList(listCommand,start,vectSize,recordToGet);

order=	PstAppPrivilegeObj.fieldNames[PstAppPrivilegeObj.FLD_CODE];	
listAppPrivObj = PstAppPrivilegeObj.listWithCmd_ByPrivOID_GroupByObj(start,recordToGet, appPrivOID , order);

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<% if(privAdd || privUpdate) {%>
function cmdAdd(){
	document.frmList.command.value="<%=Command.ADD%>"; 
	document.frmList.list_command.value="<%=Command.LIST%>";
	document.frmList.submit();	
}

function cmdEdit(oid){
	document.frmList.command.value="<%=Command.EDIT%>"; 
	document.frmList.apprivobj_oid.value=oid;
	document.frmList.list_command.value="<%=Command.LIST%>";
	document.frmList.submit();	
}

function cmdSave(){
	document.frmEdit.command.value="<%=Command.SAVE%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}

<%}%>

<% if(privDelete) {%>
function cmdCancelDel(){
	document.frmEdit.command.value="<%=Command.EDIT%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}

function cmdAskDelete(){
	document.frmEdit.command.value="<%=Command.ASK%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}

function cmdDelete(){
	document.frmEdit.command.value="<%=Command.DELETE%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}
<%}%>
function changeG1(){
	document.frmEdit.command.value="<%=iCommand%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}

function changeG2(){
	document.frmEdit.command.value="<%=iCommand%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}

function changeModule(){
	document.frmEdit.command.value="<%=iCommand%>"; 
	document.frmEdit.list_command.value="<%=Command.LIST%>";
	document.frmEdit.submit();	
}

function cmdList(){
	document.frmList.command.value="<%=Command.LIST%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}

function first(){
	document.frmList.list_command.value="<%=Command.FIRST%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}

function prev(){
	document.frmList.list_command.value="<%=Command.PREV%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}

function next(){
	document.frmList.list_command.value="<%=Command.NEXT%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}
function last(){
	document.frmList.list_command.value="<%=Command.LAST%>";
	document.frmList.action="privilegeedit.jsp";
	document.frmList.submit();
}

function goPrivilege(){
	document.frmList.command.value="<%=Command.BACK%>";
	document.frmList.action="privilegelist.jsp";
	document.frmList.submit();
}

function cmdBack(){
	document.frmEdit.command.value="<%=Command.BACK%>";
	document.frmEdit.action="privilegeedit.jsp";
	document.frmEdit.submit();
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
<link rel="stylesheet" href="../style/main.css" type="text/css">
<link rel="StyleSheet" href="../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=systemTitle[SESS_LANGUAGE]%> &gt; &nbsp;<%=userTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <table width="100%">
              <tr> 
                <td colspan="2"> 
                  &nbsp;
                </td>
              </tr>
              <tr> 
                <td colspan="2" valign="top" height="110"> 
                  <form name="frmList" method="get" action="privilegeedit.jsp">
                    <table width="100%" cellspacing="2" cellpadding="2">
                      <tr> 
                        <td width="82" nowrap>&nbsp;&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></td>
                        <td width="9" nowrap> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td width="878" nowrap>&nbsp;<%=appPriv.getPrivName()%> </td>
                      </tr>
                      <tr> 
                        <td width="82">&nbsp;&nbsp;<%=strTitle[SESS_LANGUAGE][1]%></td>
                        <td width="9" nowrap> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td width="878" nowrap>
						<%
						if(appPriv.getDescr()==""||appPriv.getDescr()==null){
							out.println("-");
						}else{
							out.println(appPriv.getDescr());
						}
						%>						
						</td>
                      </tr>
                      <tr>
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  <%if(SESS_LANGUAGE==langDefault){%>
                      <tr> 
                        <td colspan="3">&nbsp;&nbsp;<b>Daftar Hak Akses</b></td>
                      </tr>
					  <%}else{%>
                      <tr> 
                        <td colspan="3">&nbsp;&nbsp;<b>Access List</b></td>
                      </tr>
					  <%}%>					  
					  <% if(listAppPrivObj != null && listAppPrivObj.size()>0){%>
                      <tr> 
                        <td colspan="3"> <%=drawListPrivObj(SESS_LANGUAGE,listAppPrivObj)%> </td>
                      </tr>
					  <% } %>
                      <tr> 
                        <td colspan="3" class="command">                           
                          <%=ctrLine.drawMeListLimit(listCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> </td>
                      </tr>
					  <%if(iCommand==Command.LIST || iCommand==Command.SAVE || iCommand==Command.DELETE || iCommand==Command.BACK ||
						 iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST ){%>											  					  
                      <tr> 
                        <td colspan="3" class="command">                           
						  <table width="100%" border="0" cellspacing="1" cellpadding="2">
							<tr> 
                              <td width="100%"><a href="javascript:cmdAdd()" class="command"><%=strAddAcc%></a>
                               <%if(privAdd && privUpdate){%> 							  
							   | <a href="javascript:goPrivilege()" class="command"><%=strBackPriv%></a>
							   <%}%>
							   </td>
                            </tr>
							<tr> 								
                               <td width="100%"></td>
						    </tr>							
                          </table>						  						
                        </td>
                      </tr>
					  <%}%>					  
                      <tr> 
                        <td colspan="3" class="command">
						  <input type="hidden" name="appriv_oid" value="<%=appPrivOID%>"> 
                          <input type="hidden" name="apprivobj_oid" value="<%=appPrivObjOID%>">
                          <input type="hidden" name="command" value="<%=iCommand%>">
                          <input type="hidden" name="list_command" value="<%=listCommand%>">
                          <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G1_IDX]%>" value="<%=appObjG1%>">
                          <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G2_IDX]%>" value="<%=appObjG2%>">
                          <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_OBJ_IDX]%>" value="<%=appObjIdx%>">
                          <input type="hidden" name="start" value="<%=start%>">
                        </td>
                      </tr>
                    </table>
                  </form>
                </td>
              </tr>
              <% if ( (iCommand==Command.ADD) || (iCommand==Command.EDIT) || (iCommand==Command.ASK)) {%>
              <tr> 
                <td colspan="2" valign="top"> 
                  <form name="frmEdit" method="get" action="">
                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                      <tr> 
                        <td width="84">&nbsp;&nbsp;<%=strTitle[SESS_LANGUAGE][2]%> 
                          <input type="hidden" name="appriv_oid" value="<%=appPrivOID%>">
                          <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_PRIV_ID]%>" value="<%=appPrivOID%>">
                          <input type="hidden" name="apprivobj_oid" value="<%=appPrivObjOID%>">
                          <input type="hidden" name="command" value="<%=iCommand%>">
                          <input type="hidden" name="list_command" value="<%=listCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                        </td>
                        <td width="11" nowrap> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td width="880" nowrap>&nbsp; 
                          <% if (iCommand==Command.ADD) {%>
                          <select name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G1_IDX]%>" class="elemenForm" onChange="javascript:changeG1()">
                            <% for(int ig1=0;ig1< AppObjInfo.titleG1.length; ig1++){
                        String select = (appObjG1 == ig1) ? "selected" : "";
						  try{
                        %>
                            <option value="<%=ig1%>" <%=select%>><%=AppObjInfo.titleG1[ig1]%></option>
                            <% 
							  } catch(Exception exc){
							     System.out.println(" CREATE LIST ==> privilegeedit.jsp. G1 exc"+exc);
							  }
							
							}%>
                          </select>
                          <% } else { 
						   System.out.println("masuk");%>
                          <%=AppObjInfo.titleG1[appObjG1]%> 
                          <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G1_IDX]%>" value="<%=appObjG1%>">
                          <%}%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="84">&nbsp;&nbsp;<%=strTitle[SESS_LANGUAGE][3]%></td>
                        <td width="11" nowrap> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td width="880" nowrap>&nbsp; 
                          <% if (iCommand==Command.ADD || iCommand == Command.LIST) {%>
                          <select name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G2_IDX]%>" onChange="javascript:changeG2()">
                            <% for(int ig2=0;ig2< AppObjInfo.titleG2[appObjG1].length; ig2++){
                        String select = (appObjG2 == ig2) ? "selected" : "";
						  try{
                        %>
                            <option value="<%=ig2%>" <%=select%>><%=AppObjInfo.titleG2[appObjG1][ig2]%></option>
                            <% 
							  } catch(Exception exc){
							     System.out.println(" CREATE LIST ==> privilegeedit.jsp. G2 exc"+exc);
							  }
							
							}%>
                          </select>
                          <% } else { %>
                          <%=AppObjInfo.titleG2[appObjG1][appObjG2]%> 
                          <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_G2_IDX]%>" value="<%=appObjG2%>">
                          <%}%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="84">&nbsp;&nbsp;<%=strTitle[SESS_LANGUAGE][4]%></td>
                        <td width="11" nowrap> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td width="880" nowrap>&nbsp; 
                          <% if (iCommand==Command.ADD || iCommand == Command.LIST) {%>
                          <select name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_OBJ_IDX]%>" onChange="javascript:changeModule()">
                            <% for(int iobj=0;iobj< AppObjInfo.objectTitles[appObjG1][appObjG2].length; iobj++){
                        String select = (appObjIdx == iobj) ? "selected" : "";
						  try{
                        %>
                            <option value="<%=iobj%>" <%=select%>><%=AppObjInfo.objectTitles[appObjG1][appObjG2][iobj]%></option>
                            <%
							  } catch(Exception exc){
							     System.out.println(" CREATE LIST ==> privilegeedit.jsp. Object exc"+exc);
							  }
							 }%>
                          </select>
                          <% } else { %>
                          <%=AppObjInfo.objectTitles[appObjG1][appObjG2][appObjIdx]%> 
                          <input type="hidden" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_OBJ_IDX]%>" value="<%=appObjIdx%>">
                          <%}%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="84">&nbsp;&nbsp;<%=strTitle[SESS_LANGUAGE][5]%></td>
                        <td width="11" nowrap> 
                          <div align="center"><b>:</b></div>
                        </td>
                        <td width="880" nowrap> 
                          <% for(int id=0;id< AppObjInfo.objectCommands[appObjG1][appObjG2][appObjIdx].length; id++){
                            int iCmd= AppObjInfo.objectCommands[appObjG1][appObjG2][appObjIdx][id];
                            String checked = appPrivObj.existCommand(iCmd) ? "checked" : "";
                        %>
                          <input type="checkbox" name="<%=FrmAppPrivilegeObj.fieldNames[FrmAppPrivilegeObj.FRM_COMMANDS]%>" value="<%=iCmd%>" <%=checked%>>
                          <%=AppObjInfo.strCommand[iCmd]%> &nbsp;&nbsp;&nbsp;&nbsp; 
                          <% }%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="84">&nbsp;</td>
                        <td width="11" nowrap>&nbsp;</td>
                        <td width="880" nowrap>&nbsp;</td>
                      </tr>
                      <%if (iCommand==Command.ASK) {%>
                      <tr> 
                        <td colspan="3" class="msgquestion"><%=delConfirm%></td>
                      </tr>
                      <%}%>
                      <tr> 
                        <td class="command" width="84">&nbsp;</td>
                        <td class="command" width="11">&nbsp;</td>
                        <td class="command" width="880"> 
                          <%if(iCommand==Command.ASK) {%>
							  &nbsp;<a href="javascript:cmdDelete()"><%=strDeleteAcc%></a> 
							  | <a href="javascript:cmdCancelDel()"><%=strCancel%></a> 
                          <%}else{%>
							  <%if(privAdd || privUpdate){%>
							  &nbsp;<a href="javascript:cmdSave()"><%=strSaveAcc%></a> |
							  <%}%>
							  <%if(privDelete){%>
							  <a href="javascript:cmdAskDelete()"><%=strAskAcc%></a> |
							  <%}%>
	                          <a href="javascript:cmdBack()"><%=strBackAcc%></a>
                          <%}%>
                        </td>
                      </tr>
                      <tr> 
                        <td width="84">&nbsp;</td>
                        <td width="11">&nbsp;</td>
                        <td width="880">&nbsp;</td>
                      </tr>
                    </table>
                  </form>
                </td>
              </tr>
              <% } %>
            </table>
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
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>