<%
/*
 * privilegelist.jsp
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
	{"Nama","Keterangan","Tanggal Pembuatan","Ubah","Tambah","Ubah Modul Akses"},	
	{"Name","Description","Creation Date","Edit","Add","Edit Access Module"}
};

public static final String systemTitle[] = {
	"Operator","User"	
};

public static final String userTitle[] = {
	"Wewenang","Privilege"	
};

public String drawListAppPriv(int language, Vector objectClass,long oid){
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
								
	for (int i = 0; i < objectClass.size(); i++) {
		 AppPriv appPriv = (AppPriv)objectClass.get(i);

		 if(oid==appPriv.getOID()){
		 	index=i;
		 }
		 
		 Vector rowx = new Vector();
		 
		 rowx.add(String.valueOf(appPriv.getPrivName()));		 
		 rowx.add(String.valueOf(appPriv.getDescr()));
		 try{
			 Date regdate = appPriv.getRegDate();
			 regdatestr = Formater.formatDate(regdate, "MMM dd, yyyy");
		 }catch(Exception e){
			 regdatestr = "";
		 }		 
		 rowx.add(regdatestr);
		 		 
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(appPriv.getOID()));
	}						
	return ctrlist.drawMe(index);
}
%>

<%
/* VARIABLE DECLARATION */
int recordToGet = 10;
String order = " " + PstAppPriv.fieldNames[PstAppPriv.FLD_PRIV_NAME];

Vector listAppPriv = new Vector(1,1);
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);

String strMassage = "";
String currPageTitle = userTitle[SESS_LANGUAGE];
String strAddPriv = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSavePriv = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskPriv = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeletePriv = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strBackPriv = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK,true)+(SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? " List" : "");
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";

/* GET REQUEST FROM HIDDEN TEXT */
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
long appPrivOID = FRMQueryString.requestLong(request,"appriv_oid");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
int prevSaveCommand = FRMQueryString.requestInt(request, "prev_save_command");

CtrlAppPriv ctrlAppPriv = new CtrlAppPriv(request);

FrmAppPriv frmAppPriv = ctrlAppPriv.getForm();
 
int vectSize = PstAppPriv.getCount(""); 

ctrlAppPriv.action(iCommand,appPrivOID,start,vectSize,recordToGet);
vectSize = PstAppPriv.getCount(""); 
strMassage = ctrlAppPriv.getMessage();
AppPriv appPriv = ctrlAppPriv.getAppPriv();


if ((iCommand == Command.FIRST || iCommand == Command.PREV )||
	(iCommand == Command.NEXT || iCommand == Command.LAST) ||
	((iCommand == Command.SAVE)&&(frmAppPriv.errorSize()<1)))
		start = ctrlAppPriv.getStart();

order= PstAppPriv.fieldNames[PstAppPriv.FLD_PRIV_NAME] ;		
listAppPriv = PstAppPriv.list(start,recordToGet, "" , order);

/* TO HANDLE CONDITION AFTER DELETE LAST, IF START LIMIT IS BIGGER THAN VECT SIZE, GET LIST FIRST */
if(((listAppPriv==null)||(listAppPriv.size()<1))){		
	start=0;
	listAppPriv = PstAppPriv.list(start,recordToGet, "" , order);
}

/* TO VIEW THE LATES RECORD AFTER SAVE ACTION */
if((iCommand==Command.SAVE)&&(frmAppPriv.errorSize()<1)){
	prevCommand = Command.LAST;
}

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<% if (privAdd){%>
function addNew(){
	document.frmAppPriv.prev_save_command.value="<%=Command.ADD%>";
	document.frmAppPriv.appriv_oid.value="0";
	document.frmAppPriv.prev_command.value="<%=prevCommand%>";
	document.frmAppPriv.command.value="<%=Command.ADD%>";
	document.frmAppPriv.action="privilegelist.jsp";
	document.frmAppPriv.submit();
}
<%}%>

function cmdEdit(oid){
    <% if(privUpdate) {%>
	document.frmAppPriv.prev_save_command.value="<%=Command.EDIT%>";
	document.frmAppPriv.appriv_oid.value=oid;
	document.frmAppPriv.prev_command.value="<%=prevCommand%>";
	document.frmAppPriv.command.value="<%=Command.EDIT%>";
	document.frmAppPriv.action="privilegelist.jsp";
	document.frmAppPriv.submit();
       <%}%>
}

<% if(privAdd || privUpdate) {%>

function cmdSave(){
	document.frmAppPriv.command.value="<%=Command.SAVE%>";
	document.frmAppPriv.prev_command.value="<%=prevCommand%>";
	document.frmAppPriv.action="privilegelist.jsp";
	document.frmAppPriv.submit();
}
<%}%>

function cmdEditObj(oid){
    <% if(privUpdate) {%>
	document.frmAppPriv.appriv_oid.value=oid;
	document.frmAppPriv.prev_command.value="<%=prevCommand%>";
	document.frmAppPriv.command.value="<%=Command.LIST%>";
	document.frmAppPriv.action="privilegeedit.jsp";
	document.frmAppPriv.submit();
    <%}%>
}



<% if(privDelete) {%>
function cmdAsk(oid){
	document.frmAppPriv.appriv_oid.value=oid;
	document.frmAppPriv.prev_command.value="<%=prevCommand%>";
	document.frmAppPriv.command.value="<%=Command.ASK%>";
	document.frmAppPriv.action="privilegelist.jsp";
	document.frmAppPriv.submit();
}
function cmdDelete(oid){
	document.frmAppPriv.appriv_oid.value=oid;
	document.frmAppPriv.prev_command.value="<%=prevCommand%>";
	document.frmAppPriv.command.value="<%=Command.DELETE%>";
	document.frmAppPriv.action="privilegelist.jsp";
	document.frmAppPriv.submit();
}

function cmdCancel(){
	//document.frmAppPriv.appriv_oid.value=oid;
	document.frmAppPriv.prev_command.value="<%=prevCommand%>";
	document.frmAppPriv.command.value="<%=Command.EDIT%>";
	document.frmAppPriv.action="privilegelist.jsp";
	document.frmAppPriv.submit();
}
<%}%>

function cmdList(){
	document.frmAppPriv.command.value="<%=Command.LIST%>";
	document.frmAppPriv.action="privilegelist.jsp";
	document.frmAppPriv.submit();
}
function first(){
	document.frmAppPriv.command.value="<%=Command.FIRST%>";
	document.frmAppPriv.prev_command.value="<%=Command.FIRST%>";
	document.frmAppPriv.action="privilegelist.jsp";
	document.frmAppPriv.submit();
}
function prev(){
	document.frmAppPriv.command.value="<%=Command.PREV%>";
	document.frmAppPriv.prev_command.value="<%=Command.PREV%>";
	document.frmAppPriv.action="privilegelist.jsp";
	document.frmAppPriv.submit();
}

function next(){
	document.frmAppPriv.command.value="<%=Command.NEXT%>";
	document.frmAppPriv.prev_command.value="<%=Command.NEXT%>";
	document.frmAppPriv.action="privilegelist.jsp";
	document.frmAppPriv.submit();
}
function last(){
	document.frmAppPriv.command.value="<%=Command.LAST%>";
	document.frmAppPriv.prev_command.value="<%=Command.LAST%>";
	document.frmAppPriv.action="privilegelist.jsp";
	document.frmAppPriv.submit();
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
            <form name="frmAppPriv" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="appriv_oid" value="<%=appPrivOID%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="prev_save_command" value="<%=prevSaveCommand%>">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2">&nbsp; 
                    
                  </td>
                </tr>
              </table>
              <% if ((listAppPriv!=null)&&(listAppPriv.size()>0)){ %>
              <%=drawListAppPriv(SESS_LANGUAGE,listAppPriv,appPrivOID)%> 
              <%}%>
              <table width="100%">
                <tr> 
                  <td colspan="3"> <span class="command"> 
                    <% 
					   int cmd = 0;					  
					   if ((iCommand == Command.FIRST || iCommand == Command.PREV )||
							(iCommand == Command.NEXT || iCommand == Command.LAST))
								cmd =iCommand;								   
					   else{					   
						  if(iCommand == Command.NONE || prevCommand == Command.NONE)						  
							cmd=Command.FIRST;							
						  else{
						  	if((prevSaveCommand==Command.ADD)&&(iCommand==Command.SAVE)&&(frmAppPriv.errorSize()<1)){
								cmd = Command.LAST;
							}						
							else{  
						  		cmd =prevCommand;						   
							}
							
						  }
					   }						   					   
				    %>
					<%ctrLine.initDefault(SESS_LANGUAGE,"");%>
                    <%=ctrLine.drawMeListLimit(cmd,vectSize,start,recordToGet,"first","prev","next","last","left")%> </span> </td>
                </tr>
                <%if(privAdd  && (iCommand!=Command.ADD)&&(iCommand!=Command.ASK)&&(iCommand!=Command.EDIT)&&(frmAppPriv.errorSize()<1)){%>
                <tr> 
                  <td colspan="3" class="command">&nbsp;<a href="javascript:addNew()"><%=strAddPriv%></a></td>
                </tr>
                <%}%>
                <tr> 
                  <td width="12%">&nbsp;</td>
                  <td width="1%">&nbsp;</td>
                  <td width="87%">&nbsp;</td>
                </tr>
                <%if(((iCommand==Command.SAVE)&&(frmAppPriv.errorSize()>0))||(iCommand==Command.ADD)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
                <tr> 
                  <td width="12%">&nbsp;<%=strTitle[SESS_LANGUAGE][0]%></td>
                  <td width="1%">:</td>
                  <td width="87%"> 
                    <input type="text" name="<%=frmAppPriv.fieldNames[frmAppPriv.FRM_PRIV_NAME] %>" value="<%=appPriv.getPrivName()%>" size="40">
                    * &nbsp;<%= frmAppPriv.getErrorMsg(frmAppPriv.FRM_PRIV_NAME) %></td>
                </tr>
                <tr> 
                  <td width="12%" valign="top">&nbsp;<%=strTitle[SESS_LANGUAGE][1]%></td>
                  <td width="1%" valign="top">:</td>
                  <td width="87%"> 
                    <textarea name="<%=frmAppPriv.fieldNames[frmAppPriv.FRM_DESCRIPTION] %>" cols="45"><%=appPriv.getDescr()%></textarea>
                  </td>
                </tr>
                <tr> 
                  <td width="12%" valign="top" height="14">&nbsp;<%=strTitle[SESS_LANGUAGE][2]%></td>
                  <td width="1%" height="14">:</td>
                  <td width="87%" height="14"><%=ControlDate.drawDate(frmAppPriv.fieldNames[FrmAppPriv.FRM_REG_DATE], appPriv.getRegDate(), 0, -30)%> </td>
                </tr>
                <tr> 
                  <td width="12%" class="command">&nbsp;</td>
                  <td width="1%" class="command">&nbsp;</td>
                  <td width="87%" class="command">&nbsp;</td>
                </tr>
                <%if(iCommand == Command.ASK){%>
                <tr> 
                  <td colspan="3" class="msgquestion"><%=delConfirm%></td>
                </tr>
                <%}%>
				<%if(strMassage != null && strMassage.length() > 0){%>
				<tr> 
                  <td colspan="3" class="msgerror"><%=strMassage%></td>
                </tr>
				<%}%>
                <tr> 
                  <td width="12%" class="command">&nbsp;</td>
                  <td width="1%" class="command">&nbsp;</td>
                  <td width="87%" class="command"> 
                    <%if(iCommand!=Command.ASK){%>
                    <% if(privAdd || privUpdate) {%>
                    <a href="javascript:cmdSave()"><%=strSavePriv%></a> | 
                    <%}%>
                    <%if((iCommand!=Command.ADD)&&(!((iCommand==Command.SAVE)&&(appPrivOID<1)))){%>
                    <%if(privDelete ){%>
                    <a href="javascript:cmdAsk('<%=appPrivOID%>')"><%=strAskPriv%></a> | 
                    <%}%>
                    <% if(privAdd || privUpdate) {%>
                    <a href="javascript:cmdEditObj('<%=appPrivOID%>')"><%=strTitle[SESS_LANGUAGE][5]%></a> | 
                    <%}%>
                    <%}%>
                    <a href="javascript:cmdList()"><%=strBackPriv%></a> 
                    <%}else{%>
                    <%if(privDelete){%>
                    <a href="javascript:cmdDelete('<%=appPrivOID%>')"><%=strDeletePriv%></a> | <a href="javascript:cmdCancel()"><%=strCancel%></a> 
                    <%}%>
                    <%}%>
                  </td>
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