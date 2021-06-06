<%
/*
 * ref_ext_personell_lst.jsp
 *
 * Created on March 26, 2002, 15:00 AM
 *
 * @author  edarmasusila
 * @version 
 */
%>
<%@ page language="java" %>
<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.form.contact.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "java.util.*" %>

<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.entity.search.*" %>
<%@ page import = "com.dimata.common.form.contact.*" %>
<%@ page import = "com.dimata.common.form.search.*" %>
<%@ page import = "com.dimata.common.session.contact.*" %>

<%@ include file = "../../main/javainit.jsp" %>
<%//@ page import = "com.dimata.prochain.entity.admin.*" %>
<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_PERSONNEL); %>
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
	{"No","Kode","Nama","Alamat"},	
	{"No","Code","Name","Address"}
};

public static final String masterTitle[] = {
	"Kontak","Contact"	
};

public static final String personTitle[] = {
	"Perseorangan","Personnel"	
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

public String drawListPersonel(int language, Vector objectClass, int start, long oid){
	String temp = "";
	String regdatestr = "";
	String address = "";
	
	ControlList ctrlist = new ControlList();	
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strTitle[language][0],"2%","left","left");
	ctrlist.dataFormat(strTitle[language][1],"8%","left","left");
	ctrlist.dataFormat(strTitle[language][2],"40%","left","left");
	ctrlist.dataFormat(strTitle[language][3],"50%","left","left");		

	ctrlist.setLinkRow(1);
    ctrlist.setLinkSufix("");	
	Vector lstData = ctrlist.getData();
	Vector lstLinkData 	= ctrlist.getLinkData();						
	
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	
	if(start<0)
		start = 0;
								
	for (int i = 0; i < objectClass.size(); i++) {
		 ContactList contact = (ContactList)objectClass.get(i);

		 if(oid==contact.getOID()){
		 	index = i;
		 }
		 
		 Vector rowx = new Vector();
		 start = start + 1;
		 
		 rowx.add(String.valueOf(start));		 
		 rowx.add(String.valueOf(contact.getContactCode()));		 
         rowx.add(contact.getPersonName()+" "+contact.getPersonLastname());		 
         rowx.add(contact.getHomeAddr());
		 
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(contact.getOID()));
	}						

	return ctrlist.drawMe(index);
}
%>

<%
/* GET REQUEST FROM HIDDEN TEXT */
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start"); 
long contactPslOID = FRMQueryString.requestLong(request,"person_oid");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
int ifsave = FRMQueryString.requestInt(request, "ifsave");

/**
* Setup controlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = personTitle[SESS_LANGUAGE];
String strAddPerson = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strBackPerson = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK_SEARCH,true);
String strNoPerson = SESS_LANGUAGE==langForeign ? "No "+currPageTitle+" Available" : "Tidak Ada "+currPageTitle; 
String strMergeComp = SESS_LANGUAGE==langForeign ? currPageTitle + " Merge" : "Penggabungan " + currPageTitle;

int recordToGet = 20;
int vectSize = 0;
String whereClause = "";
int iErrCode = FRMMessage.ERR_NONE;
String msgStr = "";

//if using deduplicate contact, set this variable TRUE otherwise FALSE
boolean useDeduplicate = true;

/**
* instantiate some object used in this page
*/
CtrlContactPersonell ctrlContactPsl = new CtrlContactPersonell(request);
FrmContactPersonell frmContactPsl = ctrlContactPsl.getForm();

SessContactList sessContactList = new SessContactList();
SrcContactPerson srcContactPerson = new SrcContactPerson();
FrmSrcContactPerson frmSrcContactPerson = new FrmSrcContactPerson(request, srcContactPerson);
		
/**
* handle current search data session 
*/
if(iCommand==Command.BACK || iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
	 try{ 
		srcContactPerson = (SrcContactPerson)session.getValue(SessContactList.SESS_SRC_PERSONNEL); 
	 }catch(Exception e){ 
		srcContactPerson = new SrcContactPerson();
	 }
}else{
	 frmSrcContactPerson.requestEntityObject(srcContactPerson);
	 Vector vectSt = new Vector(1,1);
	 String[] strStatus = request.getParameterValues(frmSrcContactPerson.fieldNames[frmSrcContactPerson.FRM_FIELD_TYPE]);
	 if(strStatus!=null && strStatus.length>0){
		 for(int i=0; i<strStatus.length; i++){        
			try{
				vectSt.add(strStatus[i]);
			}catch(Exception exc){
				System.out.println("err");
			}
		 }
	 }
	 srcContactPerson.setType(vectSt);
	 session.putValue(SessContactList.SESS_SRC_PERSONNEL, srcContactPerson);
}

/**
* get vectSize, start and data to be display in this page
*/
vectSize = sessContactList.countPersonnel(srcContactPerson);
if(iCommand!=Command.BACK){  
	//start = ctrlContactPsl.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

Vector records = sessContactList.searchPersonnel(srcContactPerson, start, recordToGet);

if(useDeduplicate){
	if(session.getValue("DEDUPLICATE_PERSONNEL")!=null){
		session.removeValue("DEDUPLICATE_PERSONNEL");
	}
	session.putValue("DEDUPLICATE_PERSONNEL",records);
}
%>
<!-- End of JSP Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
function cmdAdd(){
	document.frmpersonel.person_oid.value="0";
	document.frmpersonel.prev_command.value="<%=prevCommand%>";
	document.frmpersonel.command.value="<%=Command.ADD%>";
	document.frmpersonel.action="contact_personell_edit.jsp";
	document.frmpersonel.submit();
}

function cmdEdit(oid){
	document.frmpersonel.person_oid.value=oid;
	document.frmpersonel.prev_command.value="<%=prevCommand%>";
	document.frmpersonel.command.value="<%=Command.EDIT%>";
	document.frmpersonel.action="contact_personell_edit.jsp";
	document.frmpersonel.submit();
}

function first(){
	document.frmpersonel.command.value="<%=Command.FIRST%>";
	document.frmpersonel.prev_command.value="<%=Command.FIRST%>";
	document.frmpersonel.action="contact_personell_list.jsp";
	document.frmpersonel.submit();
}

function prev(){
	document.frmpersonel.command.value="<%=Command.PREV%>";
	document.frmpersonel.prev_command.value="<%=Command.PREV%>";
	document.frmpersonel.action="contact_personell_list.jsp";
	document.frmpersonel.submit();
}

function next(){
	document.frmpersonel.command.value="<%=Command.NEXT%>";
	document.frmpersonel.prev_command.value="<%=Command.NEXT%>";
	document.frmpersonel.action="contact_personell_list.jsp";
	document.frmpersonel.submit();
}

function last(){
	document.frmpersonel.command.value="<%=Command.LAST%>";
	document.frmpersonel.prev_command.value="<%=Command.LAST%>";
	document.frmpersonel.action="contact_personell_list.jsp";
	document.frmpersonel.submit();
}

function cmdBack(){
	document.frmpersonel.command.value="<%=Command.BACK%>";
	document.frmpersonel.action="srcpersonnel_list.jsp";
	document.frmpersonel.submit();
}

function cmdDeduplicate(){
	var strUrl = "deduplicate_personnel.jsp"; 
	window.open(strUrl,"personnel","height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");	
}
</script>
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
<!--

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
//-->
</SCRIPT>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../style/main.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr> 
    <td bgcolor="#0000FF" height="50" ID="TOPTITLE"> 
      <%@ include file = "../../main/header.jsp" %>
    </td>
  </tr>
  <tr> 
    <td bgcolor="#000099" height="20" ID="MAINMENU" class="footer"> 
      <%@ include file = "../../main/menumain.jsp" %>
    </td>
  </tr>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" -->Masterdata 
            &gt; <%=masterTitle[SESS_LANGUAGE]%> &gt; <%=currPageTitle%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <form name="frmpersonel" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="person_oid" value="<%=contactPslOID%>">
              <input type="hidden" name="vectSize" value="<%=vectSize%>">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="prev_command" value="<%=prevCommand%>">
              <input type="hidden" name="ifsave" value="0">
              <table width="100%" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"> 
                    <hr>
                  </td>
                </tr>
              </table>
              <table width="100%">
	            <%if((records!=null)&&(records.size()>0)){%>			  
                <tr> 
                  <td><%=drawListPersonel(SESS_LANGUAGE,records,start,contactPslOID)%></td>
                </tr>			  
                <%}else{%>
                <tr> 
                  <td><span class="comment"><%=strNoPerson%></span></td>
                </tr>			  				
				<%}%>					  
                <tr> 
                  <td> 
                    <%=ctrLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%>
				  </td>
                </tr>
                <tr> 
                  <td width="46%" nowrap align="left" class="command">
				  <%if(privAdd){%><a href="javascript:cmdAdd()" class="command"><%=strAddPerson%></a><%}%>
                    | <a href="javascript:cmdBack()" class="command"><%=strBackPerson%></a> <%if(records!=null && records.size()>0 && useDeduplicate){%>
                    | <a href="javascript:cmdDeduplicate()"><%=strMergeComp%></a> 
                    <%}%></td>
                </tr>								
              </table>
            </form>
            <!-- #EndEditable --></td>
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
<!-- #EndTemplate -->
</html>
<!-- endif of "has access" condition -->
<%}%>