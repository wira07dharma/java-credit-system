<%
/*
 * userlist.jsp
 *
 * Created on April 04, 2002, 11:30 AM
 *
 * @author  ktanjana
 * @version 
 */
%>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.aiso.form.admin.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<%@ page import = "com.dimata.aiso.entity.admin.*" %> 
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_USER); %>
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

<!-- JSP Block -->
<%!
public static String strTitle[][] = {
	{"Login ID","Nama","Status"},	
	{"Login ID","Name","Status"}
};

public static final String systemTitle[] = {
	"Operator","User"	
};

public static final String userTitle[] = {
	"Daftar","List"	
};

public String drawListAppUser(int language, Vector objectClass, long oid){
	String temp = ""; 
	String regdatestr = "";
	
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strTitle[language][0],"30%","left","left");
	ctrlist.dataFormat(strTitle[language][1],"40%","left","left");
	ctrlist.dataFormat(strTitle[language][2],"30%","left","left");		

	ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");	
	Vector lstData = ctrlist.getData();
	Vector lstLinkData 	= ctrlist.getLinkData();							
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
								
	for(int i=0; i<objectClass.size(); i++){
		 AppUser appUser = (AppUser)objectClass.get(i);
		 if(oid==appUser.getOID()){
		 	index = i;
		 }
		 
		 Vector rowx = new Vector();		 
		 rowx.add(String.valueOf(appUser.getLoginId()));		 
		 rowx.add(String.valueOf(appUser.getFullName()));
		 rowx.add(String.valueOf(AppUser.getStatusTxt(appUser.getUserStatus())));		 
		 		 
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(appUser.getOID()));
	}					
	return ctrlist.drawMe(index);
}

%>
<%
/* GET REQUEST FROM HIDDEN TEXT */
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
long appUserOID = FRMQueryString.requestLong(request,"user_oid");
int listCommand = FRMQueryString.requestInt(request, "list_command");
if(listCommand==Command.NONE)
 listCommand = Command.LIST;

/* VARIABLE DECLARATION */
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);

String currPageTitle = userTitle[SESS_LANGUAGE];
String strAddUser = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);

int recordToGet = 20;
String order = " " + PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID];

CtrlAppUser ctrlAppUser = new CtrlAppUser(request); 
int vectSize = PstAppUser.getCount(""); 

if(iCommand!=Command.BACK){  
	start = ctrlAppUser.actionList(iCommand, start,vectSize,recordToGet);
}else{
	iCommand = Command.LIST;
}
Vector listAppUser = PstAppUser.listPartObj(start,recordToGet, "" , order);
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<%if(privAdd){%>
function addNew(){
	document.frmAppUser.user_oid.value="0";
	document.frmAppUser.list_command.value="<%=listCommand%>";
	document.frmAppUser.command.value="<%=Command.ADD%>";
	document.frmAppUser.action="useredit.jsp";
	document.frmAppUser.submit();
}
<%}%>
 
function cmdEdit(oid){
	<%if(privUpdate){%>
	document.frmAppUser.user_oid.value=oid;
	document.frmAppUser.list_command.value="<%=listCommand%>";
	document.frmAppUser.command.value="<%=Command.EDIT%>";
	document.frmAppUser.action="useredit.jsp";
	document.frmAppUser.submit();
	<%}%>
}

function first(){
	document.frmAppUser.command.value="<%=Command.FIRST%>";
	document.frmAppUser.list_command.value="<%=Command.FIRST%>";
	document.frmAppUser.action="userlist.jsp";
	document.frmAppUser.submit();
}
function prev(){
	document.frmAppUser.command.value="<%=Command.PREV%>";
	document.frmAppUser.list_command.value="<%=Command.PREV%>";
	document.frmAppUser.action="userlist.jsp";
	document.frmAppUser.submit();
}

function next(){
	document.frmAppUser.command.value="<%=Command.NEXT%>";
	document.frmAppUser.list_command.value="<%=Command.NEXT%>";
	document.frmAppUser.action="userlist.jsp";
	document.frmAppUser.submit();
}
function last(){
	document.frmAppUser.command.value="<%=Command.LAST%>";
	document.frmAppUser.list_command.value="<%=Command.LAST%>";
	document.frmAppUser.action="userlist.jsp";
	document.frmAppUser.submit();
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
	<script type="text/javascript" src="../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" > 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
		  <b><%=systemTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=userTitle[SESS_LANGUAGE].toUpperCase()%></font></b><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmAppUser" method="get" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="user_oid" value="<%=appUserOID%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="list_command" value="<%=listCommand%>">
              <table width="100%" cellspacing="0" cellpadding="0">
               
              </table>
              <% if ((listAppUser!=null)&&(listAppUser.size()>0)){ %>
              <%=drawListAppUser(SESS_LANGUAGE,listAppUser,appUserOID)%> 
              <%}%>
              <table width="100%">
                <tr> 
                  <td colspan="2"> <span class="command"> <%=ctrLine.drawMeListLimit(listCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> </span> </td>
                </tr>
                <% if (privAdd){%>				
                <tr valign="middle"> 
                  <td colspan="2" class="command">&nbsp;<a href="javascript:addNew()"><%=strAddUser%></a> </td>
                </tr>
                <%}%>
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