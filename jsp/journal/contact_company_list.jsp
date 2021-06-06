<% 
/* 
 * Page Name  		:  contactlist_list.jsp
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
<%@ page import = "java.util.*,
                   com.dimata.aiso.form.aktiva.FrmOrderAktiva,
                   com.dimata.aiso.form.jurnal.FrmJurnalUmum" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package prochain02 -->
<%@ page import = "com.dimata.common.entity.contact.*" %>
<%@ page import = "com.dimata.common.entity.search.*" %>
<%@ page import = "com.dimata.common.form.contact.*" %>
<%@ page import = "com.dimata.common.form.search.*" %>
<%@ page import = "com.dimata.common.session.contact.*" %>


<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1; // AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_COMPANY); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
public static String strTitle[][] = {
	{"No","Kode","Nama Kontak","Nama Kontak","Telepon","Alamat"},
	{"No","Code","Company Name","Contact Name","Phone","Address"}
};

public static final String masterTitle[] = {
	"Kontak","Contact"	
};

public static final String compTitle[] = {
	"Kontak","Contact"
};

public String drawList(int language, Vector objectClass, long oid, int start){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	//ctrlist.dataFormat(strTitle[language][0],"2%","left","left");
	ctrlist.dataFormat(strTitle[language][1],"11%","left","left");
	ctrlist.dataFormat(strTitle[language][2],"22%","left","left");
	//ctrlist.dataFormat(strTitle[language][3],"22%","left","left");
	//ctrlist.dataFormat(strTitle[language][4],"11%","left","left");
	ctrlist.dataFormat(strTitle[language][5],"33%","left","left");

	ctrlist.setLinkRow(0);
	ctrlist.setLinkSufix("");
	Vector lstData = ctrlist.getData();
	Vector lstLinkData = ctrlist.getLinkData();
	ctrlist.setLinkPrefix("javascript:cmdEdit('");
	ctrlist.setLinkSufix("')");
	ctrlist.reset();
	int index = -1;
	
	if(start<0)
		start =0;
		
	for (int i = 0; i < objectClass.size(); i++) {
		ContactList contactList = (ContactList)objectClass.get(i);
		Vector rowx = new Vector();
		
	    if(oid==contactList.getOID()){index =i;} 		
		
		start = start + 1;
		//rowx.add(String.valueOf(start));
		
		rowx.add(cekNull(contactList.getContactCode()));
		String compName = cekNull(contactList.getCompName());
        if(compName.length()==0)
            compName = cekNull(contactList.getPersonName());

        rowx.add(compName);
        String address = cekNull(contactList.getBussAddress());
        if(address.length()==0)
		    address = cekNull(contactList.getHomeAddr());

        rowx.add(address);
		
		lstData.add(rowx);
		lstLinkData.add(String.valueOf(contactList.getOID())+"','"+compName);
	}
	return ctrlist.drawMe(index);
}

public String cekNull(String val){
	if(val==null || val.length()==0)
		val = "";
	return val;	
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
long oidContactList = FRMQueryString.requestLong(request, "hidden_contact_id");
int start = FRMQueryString.requestInt(request, "start");
long type = FRMQueryString.requestLong(request, "contact_class");

/**
* Setup controlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = compTitle[SESS_LANGUAGE];
String strAddComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strBackComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK_SEARCH,true);
String strNoCompany = SESS_LANGUAGE==langForeign ? "No "+currPageTitle+" Available" : "Tidak Ada "+currPageTitle; 
String strMergeComp = SESS_LANGUAGE==langForeign ? currPageTitle + " Merge" : "Penggabungan " + currPageTitle;

int recordToGet = 20;
int vectSize = 0;
String whereClause = "";
int iErrCode = FRMMessage.ERR_NONE;
String msgStr = "";

//if using deduplicate contact, set this variable TRUE otherwise FALSE
boolean useDeduplicate = false; //true;


/**
* instantiate some object used in this page
*/
CtrlContactList ctrlContactList = new CtrlContactList(request);
SrcContactList srcContactList = new SrcContactList();
SessContactList sessContactList = new SessContactList();
FrmSrcContactList frmSrcContactList = new FrmSrcContactList(request, srcContactList);
		
/**
* handle current search data session 
*/
if(iCommand==Command.BACK || iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
	 try{ 
		srcContactList = (SrcContactList)session.getValue(SessContactList.SESS_SRC_CONTACT_LIST); 
	 }catch(Exception e){ 
		srcContactList = new SrcContactList();
	 }
}else{
	 frmSrcContactList.requestEntityObject(srcContactList);
	 Vector vectSt = new Vector(1,1);
	 String[] strStatus = request.getParameterValues(frmSrcContactList.fieldNames[frmSrcContactList.FRM_FIELD_TYPE]);
	 if(strStatus!=null && strStatus.length>0){
		 for(int i=0; i<strStatus.length; i++){        
			try{
				vectSt.add(strStatus[i]);
			}catch(Exception exc){
				System.out.println("err");
			}
		 }
	 }
	 srcContactList.setType(vectSt);
	 session.putValue(SessContactList.SESS_SRC_CONTACT_LIST, srcContactList);
}

/**
* get vectSize, start and data to be display in this page
*/
vectSize = sessContactList.countCompany(srcContactList);
if(iCommand!=Command.BACK){  
	start = ctrlContactList.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

Vector records = sessContactList.searchCompany(srcContactList, start, recordToGet);

if(useDeduplicate){
	if(session.getValue("DEDUPLICATE_COMPANY")!=null){
		session.removeValue("DEDUPLICATE_COMPANY");
	}
	session.putValue("DEDUPLICATE_COMPANY",records);
}
%>
<!-- End of Jsp Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--
function cmdAdd(){
	document.frm_contactlist.command.value="<%=Command.ADD%>";
	document.frm_contactlist.action="contact_company_edit.jsp";
	document.frm_contactlist.submit();
}

function cmdEdit(oid, name){
    self.opener.document.forms.frmjournal.<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_CONTACT_ID]%>.value = oid;
    self.opener.document.forms.frmjournal.<%=FrmJurnalUmum.fieldNames[FrmJurnalUmum.FRM_CONTACT_ID]%>_TEXT.value = name;
    self.close();
}

function first(){
	document.frm_contactlist.command.value="<%=Command.FIRST%>";
	document.frm_contactlist.action="contact_company_list.jsp";
	document.frm_contactlist.submit();
}

function prev(){
	document.frm_contactlist.command.value="<%=Command.PREV%>";
	document.frm_contactlist.action="contact_company_list.jsp";
	document.frm_contactlist.submit();
}

function next(){
	document.frm_contactlist.command.value="<%=Command.NEXT%>";
	document.frm_contactlist.action="contact_company_list.jsp";
	document.frm_contactlist.submit();
}

function last(){
	document.frm_contactlist.command.value="<%=Command.LAST%>";
	document.frm_contactlist.action="contact_company_list.jsp";
	document.frm_contactlist.submit();
}

function cmdBack(){
	document.frm_contactlist.command.value="<%=Command.BACK%>";
	document.frm_contactlist.action="srccontact_list.jsp";
	document.frm_contactlist.submit();
}

function cmdDeduplicate(){
	var strUrl = "deduplicate_company.jsp"; 
	window.open(strUrl,"personnel","height=600,width=800,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");	
}
//-------------- script control line -------------------
//-->
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
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
            <%=masterTitle[SESS_LANGUAGE]%> &gt; <%=currPageTitle%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
            <form name="frm_contactlist" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="hidden_contact_id" value="<%=oidContactList%>">
              <table border="0" width="100%">
                <tr> 
                  <td height="8">&nbsp; 
                  </td>
                </tr>
              </table>                       
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
	            <%if((records!=null)&&(records.size()>0)){%>			  
                <tr> 
                  <td><%=drawList(SESS_LANGUAGE,records,oidContactList,start)%></td>
                </tr>			  
                <%}else{%>
                <tr> 
                  <td><span class="comment"><%=strNoCompany%></span></td>
                </tr>			  				
				<%}%>				
                <tr> 
                  <td>
				  <% ctrLine.initDefault(SESS_LANGUAGE, "");%>
				  <%=ctrLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> 
                  </td>
                </tr>				
                <tr> 
                  <td width="46%" nowrap align="left" class="command">
				  <%if(privAdd){%><a href="javascript:cmdAdd()" class="command"><%=strAddComp%></a><%}%> | <a href="javascript:cmdBack()" class="command"><%=strBackComp%></a> <%if(records!=null && records.size()>0 && useDeduplicate){%>| <a href="javascript:cmdDeduplicate()"><%=strMergeComp%></a><%}%>
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
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
<!-- endif of "has access" condition -->
