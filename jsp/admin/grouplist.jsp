<%
/*
 * grouplist.jsp
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
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.aiso.entity.admin.*" %>
<%@ page import = "com.dimata.aiso.form.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_GROUP); %>
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
	{"Nama","Keterangan","Tanggal Pembuatan","Ubah","Tambah"},	
	{"Name","Description","Creation Date","Edit","Add"}
};

public static final String systemTitle[] = {
	"Operator","User"	
};

public static final String userTitle[] = {
	"Kelompok Wewenang","Group Pervilege"	
};

public String drawListAppGroup(int language, Vector objectClass){
	String temp = "";
	String regdatestr = "";
	
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.addHeader(strTitle[language][0],"30%");
	ctrlist.addHeader(strTitle[language][1],"40%");
	ctrlist.addHeader(strTitle[language][2],"30%");		

	ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
	
	Vector lstData = ctrlist.getData();

	Vector lstLinkData 	= ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
								
	for (int i = 0; i < objectClass.size(); i++) {
		 AppGroup appGroup = (AppGroup)objectClass.get(i);

		 Vector rowx = new Vector();
		 
		 rowx.add(String.valueOf(appGroup.getGroupName()));		 
		 rowx.add(String.valueOf(appGroup.getDescription()));
		 try{
			 Date regdate = appGroup.getRegDate();
			 regdatestr = Formater.formatDate(regdate, "dd MMMM yyyy");
		 }catch(Exception e){
			 regdatestr = "";
		 }
		 
		 rowx.add(regdatestr);
		 		 
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(appGroup.getOID()));
	}						

	return ctrlist.draw();
}

%>
<%

/* VARIABLE DECLARATION */
int recordToGet = 20;

String order = " " + PstAppGroup.fieldNames[PstAppGroup.FLD_GROUP_NAME];

Vector listAppGroup = new Vector(1,1);
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);

String currPageTitle = userTitle[SESS_LANGUAGE];
String strAddGroup = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);

/* GET REQUEST FROM HIDDEN TEXT */
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
long appGroupOID = FRMQueryString.requestLong(request,"group_oid");
int listCommand = FRMQueryString.requestInt(request, "list_command");
if(listCommand==Command.NONE)
 listCommand = Command.LIST;

CtrlAppGroup ctrlAppGroup = new CtrlAppGroup(request);
 
int vectSize = PstAppGroup.getCount(""); 

start = ctrlAppGroup.actionList(listCommand, start,vectSize,recordToGet);

listAppGroup = PstAppGroup.list(start,recordToGet, "" , order);

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<% if (privAdd){%>
function addNew(){
	document.frmAppGroup.group_oid.value="0";
	document.frmAppGroup.list_command.value="<%=listCommand%>";
	document.frmAppGroup.command.value="<%=Command.ADD%>";
	document.frmAppGroup.action="groupedit.jsp";
	document.frmAppGroup.submit();
}
 <%}%>
function cmdEdit(oid){
	document.frmAppGroup.group_oid.value=oid;
	document.frmAppGroup.list_command.value="<%=listCommand%>";
	document.frmAppGroup.command.value="<%=Command.EDIT%>";
	document.frmAppGroup.action="groupedit.jsp";
	document.frmAppGroup.submit();
}

function first(){
	document.frmAppGroup.command.value="<%=Command.FIRST%>";
	document.frmAppGroup.list_command.value="<%=Command.FIRST%>";
	document.frmAppGroup.action="grouplist.jsp";
	document.frmAppGroup.submit();
}
function prev(){
	document.frmAppGroup.command.value="<%=Command.PREV%>";
	document.frmAppGroup.list_command.value="<%=Command.PREV%>";
	document.frmAppGroup.action="grouplist.jsp";
	document.frmAppGroup.submit();
}

function next(){
	document.frmAppGroup.command.value="<%=Command.NEXT%>";
	document.frmAppGroup.list_command.value="<%=Command.NEXT%>";
	document.frmAppGroup.action="grouplist.jsp";
	document.frmAppGroup.submit();
}
function last(){
	document.frmAppGroup.command.value="<%=Command.LAST%>";
	document.frmAppGroup.list_command.value="<%=Command.LAST%>";
	document.frmAppGroup.action="grouplist.jsp";
	document.frmAppGroup.submit();
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->
		  <%=systemTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=userTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmAppGroup" method="get" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="group_oid" value="<%=appGroupOID%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="list_command" value="<%=listCommand%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2">&nbsp; 
                    
                  </td>
                </tr>
              </table>
              <% if ((listAppGroup!=null)&&(listAppGroup.size()>0)){ %>
              <%=drawListAppGroup(SESS_LANGUAGE,listAppGroup)%> 
              <%}%>
              <table width="100%">
                <tr> 
                  <td colspan="2"> <span class="command"> 
				  <%ctrLine.initDefault(SESS_LANGUAGE,"");%>
				  <%=ctrLine.drawMeListLimit(listCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> </span> </td>
                </tr>
                <% if (privAdd){%>
                <tr> 
                  <td colspan="2" class="command"><a href="javascript:addNew()"><%=strAddGroup%></a></td>
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
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
<%}%>