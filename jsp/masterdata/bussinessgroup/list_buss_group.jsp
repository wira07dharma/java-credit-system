
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.aiso.entity.masterdata.BussinessGroup" %>
<%@ page import = "com.dimata.aiso.entity.search.SrcBussinessGroup" %>
<%@ page import = "com.dimata.aiso.form.masterdata.CtrlBussGroup" %>
<%@ page import = "com.dimata.aiso.form.search.FrmSrcBussGroup" %>
<%@ page import = "com.dimata.aiso.session.masterdata.SessBussGroup" %>


<%@ include file = "../../main/javainit.jsp" %>
<% int  appObjCode = 1;//AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_CONTACT, AppObjInfo.OBJ_MASTERDATA_CONTACT_COMPANY); %>
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
	{"No","Kode","Nama Kelompok Bisnis","Telepon","Fax","Alamat","Kota"},	
	{"No","Code","Bussiness Group Name","Phone","Fax","Address","City"}
};

public static final String masterTitle[] = {
	"Daftar","List"	
};

public static final String compTitle[] = {
	"Kelompok Bisnis","Bussiness Group"
};

public String drawList(int language, Vector objectClass, long oid, int start){
	ControlList ctrlist = new ControlList();
	ctrlist.setAreaWidth("100%");
	ctrlist.setListStyle("listgen");
	ctrlist.setTitleStyle("listgentitle");
	ctrlist.setCellStyle("listgensell");
	ctrlist.setCellStyleOdd("listgensellOdd");
	ctrlist.setHeaderStyle("listgentitle");
	ctrlist.dataFormat(strTitle[language][0],"2%","center","center");
	ctrlist.dataFormat(strTitle[language][1],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][2],"24%","center","left");
	ctrlist.dataFormat(strTitle[language][3],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][4],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][5],"24%","center","left");
	ctrlist.dataFormat(strTitle[language][6],"10%","center","left");

	ctrlist.setLinkRow(1);
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
		BussinessGroup objBussGroup = (BussinessGroup)objectClass.get(i);
		Vector rowx = new Vector();
		
	    if(oid==objBussGroup.getOID()){index =i;} 		
		
		start = start + 1;
		rowx.add(String.valueOf(start)); 
		rowx.add(cekNull(objBussGroup.getBussGroupCode())); 
		rowx.add(cekNull(objBussGroup.getBussGroupName()));
		rowx.add(cekNull(objBussGroup.getBussGroupPhone()));
		rowx.add(cekNull(objBussGroup.getBussGroupFax()));
		rowx.add(cekNull(objBussGroup.getBussGroupAddress()));
		rowx.add(cekNull(objBussGroup.getBussGroupCity()));
		
		lstData.add(rowx);
		lstLinkData.add(String.valueOf(objBussGroup.getOID()));
	}
	return ctrlist.drawMe(index);
}

public String cekNull(String val){
	if(val==null)
		val = "";
	return val;	
}
%>

<%
int iCommand = FRMQueryString.requestCommand(request);
long oidBussGroup = FRMQueryString.requestLong(request, "hidden_buss_group_id");
int start = FRMQueryString.requestInt(request, "start");

/**
* Setup controlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
ctrLine.setLanguage(SESS_LANGUAGE);
String currPageTitle = compTitle[SESS_LANGUAGE];
String strAddComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strBackComp = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_BACK_SEARCH,true);
String strNoCompany = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "No "+currPageTitle+" Available" : "Tidak Ada "+currPageTitle; 

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
CtrlBussGroup ctrlBussGroup = new CtrlBussGroup(request);
SrcBussinessGroup srcBussGroup = new SrcBussinessGroup();
SessBussGroup sessBussGroup = new SessBussGroup();
FrmSrcBussGroup frmSrcBussGroup = new FrmSrcBussGroup(request, srcBussGroup);
		
/**
* handle current search data session 
*/
if(iCommand==Command.BACK || iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
	 try{ 
		srcBussGroup = (SrcBussinessGroup)session.getValue(SessBussGroup.SESS_BUSS_GROUP); 
	 }catch(Exception e){ 
		srcBussGroup = new SrcBussinessGroup();
	 }
}else{
	 frmSrcBussGroup.requestEntityObject(srcBussGroup);
}

/**
* get vectSize, start and data to be display in this page
*/
vectSize = sessBussGroup.getCount(srcBussGroup);
if(iCommand!=Command.BACK){  
	start = ctrlBussGroup.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

Vector records = sessBussGroup.getDataCompany(srcBussGroup, start, recordToGet);


%>
<!-- End of Jsp Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--
function cmdAdd(){
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.command.value="<%=Command.ADD%>";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.action="edit_buss_group.jsp";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.submit();
}

function cmdEdit(oid){
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.hidden_buss_group_id.value = oid;
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.action="edit_buss_group.jsp";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.submit();
}

function first(){
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.command.value="<%=Command.FIRST%>";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.action="list_buss_group.jsp";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.submit();
}

function prev(){
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.command.value="<%=Command.PREV%>";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.action="list_buss_group.jsp";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.submit();
}

function next(){
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.command.value="<%=Command.NEXT%>";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.action="list_buss_group.jsp";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.submit();
}

function last(){
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.command.value="<%=Command.LAST%>";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.action="list_buss_group.jsp";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.submit();
}

function cmdBack(){
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.command.value="<%=Command.BACK%>";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.action="src_buss_group.jsp";
	document.<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>.submit();
}


//-------------- script control line -------------------
//-->
</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<SCRIPT language=JavaScript>
<!--

//-->
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
           <b><%=masterTitle[SESS_LANGUAGE]%> : <font color="#CC3300"><%=currPageTitle.toUpperCase()%></font></b><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
		  <script language="JavaScript">
		  	window.focus();
		  </SCRIPT>
            <form name="<%=FrmSrcBussGroup.FRM_SRC_BUSS_GROUP%>" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="hidden_buss_group_id" value="<%=oidBussGroup%>">
              <table border="0" width="100%">
                <tr> 
                  <td height="8">&nbsp; 
                    
                  </td>
                </tr>
              </table>                       
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
	            <%if((records!=null)&&(records.size()>0)){%>			  
                <tr> 
                  <td><%=drawList(SESS_LANGUAGE,records,oidBussGroup,start)%></td>
                </tr>			  
                <%}else{%>
                <tr> 
                  <td><span class="comment"><%=strNoCompany%></span></td>
                </tr>			  				
				<%}%>				
                <tr> 
                  <td>
				  <%=ctrLine.drawMeListLimit(iCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> 
                  </td>
                </tr>				
                <tr> 
                  <td width="46%" nowrap align="left" class="command">
				  <%if(privAdd){%><a href="javascript:cmdAdd()" class="command"><%=strAddComp%></a><%}%> | <a href="javascript:cmdBack()" class="command"><%=strBackComp%></a>
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