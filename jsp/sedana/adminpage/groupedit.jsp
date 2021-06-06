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
<%@ page import = "com.dimata.aiso.session.admin.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_SYSTEM, AppObjInfo.G2_SYSTEM_USER_MAN, AppObjInfo.OBJ_SYSTEM_USER_MAN_GROUP); %>
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
	{"Nama","Keterangan","Dimasukkan ke Privilege","Tanggal Pembuatan","Ubah","Tambah"},		
	{"Full Name","Description","Privilege Assigned","Creation Date","Edit","Add"}
};

public static final String systemTitle[] = {
	"Operator","User"	
};

public static final String userTitle[] = {
	"Kelompok Wewenang","Group Previlege"	
};

public String ctrCheckBox(long groupID){ 
	ControlCheckBox chkBx=new ControlCheckBox();
	chkBx.setCellSpace("0");		
	chkBx.setCellStyle("");
	chkBx.setWidth(4);
	chkBx.setTableAlign("left");
	chkBx.setCellWidth("10%");
	
        try{
            Vector checkValues = new Vector(1,1);
            Vector checkCaptions = new Vector(1,1);	  
			String orderBy =  PstAppPriv.fieldNames[PstAppPriv.FLD_PRIV_NAME];     
            Vector allPrivs = PstAppPriv.list(0, 0, "", orderBy);

            if(allPrivs!=null){
                int maxV = allPrivs.size(); 
                for(int i=0; i< maxV; i++){
                    AppPriv appPriv = (AppPriv) allPrivs.get(i);
                    checkValues.add(Long.toString(appPriv.getOID()));
                    checkCaptions.add(appPriv.getPrivName());
                }
            }

            Vector checkeds = new Vector(1,1);

            PstGroupPriv pstGp = new PstGroupPriv(0);
            Vector privs = SessAppGroup.getGroupPriv(groupID);

            if(privs!=null){
                int maxV = privs.size(); 
                for(int i=0; i< maxV; i++){
                    AppPriv appPriv = (AppPriv) privs.get(i);
                    checkeds.add(Long.toString(appPriv.getOID()));
                }
            }

            chkBx.setTableWidth("100%");

            String fldName = FrmAppGroup.fieldNames[FrmAppGroup.FRM_GROUP_PRIV];
            return chkBx.draw(fldName,checkValues,checkCaptions,checkeds);

        } catch (Exception exc){
            return "No privilege";
        }
        
}

%>

<%
/* VARIABLE DECLARATION */ 
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);

String currPageTitle = userTitle[SESS_LANGUAGE];
String strAddGroup = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveGroup = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskGroup = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteGroup = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackGroup = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";

/* GET REQUEST FROM HIDDEN TEXT */
String strMassage = "";
int iCommand = FRMQueryString.requestCommand(request);
long appGroupOID = FRMQueryString.requestLong(request,"group_oid");
int start = FRMQueryString.requestInt(request, "start"); 

CtrlAppGroup ctrlAppGroup = new CtrlAppGroup(request);

FrmAppGroup frmAppGroup = ctrlAppGroup.getForm();
 
ctrlAppGroup.action(iCommand,appGroupOID);
strMassage = ctrlAppGroup.getMessage();
AppGroup appGroup = ctrlAppGroup.getAppGroup();
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">

function cmdCancel(){
	//document.frmAppGroup.group_oid.value=oid;
	document.frmAppGroup.command.value="<%=Command.EDIT%>";
	document.frmAppGroup.action="groupedit.jsp";
	document.frmAppGroup.submit();
}

<% if(privAdd || privUpdate) {%>
function cmdSave(){
	document.frmAppGroup.command.value="<%=Command.SAVE%>";
	document.frmAppGroup.action="groupedit.jsp";
	document.frmAppGroup.submit();
}

<%}%>

<% if(privDelete) {%>
function cmdAsk(oid){
	document.frmAppGroup.group_oid.value=oid;
	document.frmAppGroup.command.value="<%=Command.ASK%>";
	document.frmAppGroup.action="groupedit.jsp";
	document.frmAppGroup.submit();
}
function cmdDelete(oid){
	document.frmAppGroup.group_oid.value=oid;
	document.frmAppGroup.command.value="<%=Command.DELETE%>";
	document.frmAppGroup.action="groupedit.jsp";
	document.frmAppGroup.submit();
}
<%}%>
function cmdBack(oid){
	document.frmAppGroup.group_oid.value=oid;
	document.frmAppGroup.command.value="<%=Command.LIST%>";
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
		  <%=systemTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=appGroupOID!=0 ? strTitle[SESS_LANGUAGE][4].toUpperCase() : strTitle[SESS_LANGUAGE][5].toUpperCase()%>&nbsp;<%=userTitle[SESS_LANGUAGE].toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frmAppGroup" method="get" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="group_oid" value="<%=appGroupOID%>">
              <input type="hidden" name="start" value="<%=start%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2">&nbsp; 
                    
                  </td>
                </tr>
              </table>			  
              <table width="100%">
                <%if(((iCommand==Command.SAVE)&&(frmAppGroup.errorSize()>0))
                    ||(iCommand==Command.ADD)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                <tr> 
                  <td colspan="3" class="txtheading1"></td>
                </tr>
                <tr> 
                  <td width="12%"><%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td width="1%">:</td>
                  <td width="87%">&nbsp; 
                    <input type="text" name="<%=frmAppGroup.fieldNames[frmAppGroup.FRM_GROUP_NAME] %>" value="<%=appGroup.getGroupName()%>" size="40">
                    * &nbsp;<%= frmAppGroup.getErrorMsg(frmAppGroup.FRM_GROUP_NAME) %></td>
                </tr>
                <tr> 
                  <td width="12%" valign="top"><%=strTitle[SESS_LANGUAGE][1]%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="87%">&nbsp; 
                    <textarea name="<%=frmAppGroup.fieldNames[frmAppGroup.FRM_DESCRIPTION] %>" cols="45"><%=appGroup.getDescription()%></textarea>
                  </td>
                </tr>
                <tr> 
                  <td width="12%" valign="top" height="14" nowrap><%=strTitle[SESS_LANGUAGE][2]%></td>
                  <td width="1%" height="14" valign="top">:</td>
                  <td width="87%" height="14"> <%=ctrCheckBox(appGroupOID)%> </td>
                <tr> 
                  <td width="12%" valign="top" height="14" nowrap><%=strTitle[SESS_LANGUAGE][3]%></td>
                  <td width="1%" height="14">:</td>
                  <td width="87%" height="14">&nbsp;<%=ControlDate.drawDate(frmAppGroup.fieldNames[FrmAppGroup.FRM_REG_DATE], appGroup.getRegDate(), 0, -30)%> </td>
                <tr> 
                  <td width="12%" valign="top" height="14" nowrap>&nbsp;</td>
                  <td width="1%" height="14">&nbsp;</td>
                  <td width="87%" height="14">&nbsp;</td>
                  <%if(iCommand == Command.ASK ){%>
                <tr> 
                  <td colspan="3" class="msgquestion"><%=delConfirm%> 
                  </td>
                </tr>
                <%}%>
				<%if(strMassage != null && strMassage.length() > 0){%>
				<tr> 
                  <td colspan="3" class="msgerror"><%=strMassage%> 
                  </td>
                </tr>
				<%}%>
                <tr> 
                  <td colspan="3" class="command"> 
                    <%if(iCommand!=Command.ASK){%>
                    <%if(iCommand!=Command.ADD){%>
                    <%}%>
                    <% if(privAdd || privUpdate) {%>
                    <a href="javascript:cmdSave()"><%=strSaveGroup%></a> | 
                    <%}%>
                    <a href="javascript:cmdBack()"><%=strBackGroup%></a> 
                    <%if(privDelete && (iCommand!=Command.ADD) ) { //&&(!( (iCommand==Command.SAVE) && (appGroupOID != 0) ) ) ){%>
                    | <a href="javascript:cmdAsk('<%=appGroupOID%>')"><%=strAskGroup%></a> 
                    <%}%>
                    <%}else{%>
                    <% if(privDelete) {%>
                    <a href="javascript:cmdCancel()"><%=strCancel%></a> | <a href="javascript:cmdDelete('<%=appGroupOID%>')"><%=strDeleteGroup%></a> 
                    <%}%>
                    <%}%>
                  </td>
                </tr>
                <%} else {%>
				<%if(SESS_LANGUAGE==langDefault){%>
                <tr> 
                  <td colspan="3">&nbsp; Prosess OK .. kembali ke daftar, <a href="javascript:cmdBack()">klik di sini</a></td>
                    <script language="JavaScript">
					cmdBack();
					</script>
                </tr>
				<%}else{%>
                <tr> 
                  <td colspan="3">&nbsp; Processing OK .. back to list, <a href="javascript:cmdBack()">click here</a></td>
                    <script language="JavaScript">
					cmdBack();
					</script>				  
                </tr>
				<%}%>				
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