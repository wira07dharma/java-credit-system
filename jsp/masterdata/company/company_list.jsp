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
<%@ page import = "java.util.*" %>
<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>
<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<!--package prochain02 -->
<%@ page import = "com.dimata.aiso.entity.masterdata.Company" %>
<%@ page import = "com.dimata.aiso.entity.search.SrcCompany" %>
<%@ page import = "com.dimata.aiso.form.masterdata.CtrlCompany" %>
<%@ page import = "com.dimata.aiso.form.search.FrmSrcCompany" %>
<%@ page import = "com.dimata.aiso.session.masterdata.SessCompany" %>


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
	{"No","Kode","Nama Perusahaan","Telepon","Alamat","Kota","Propinsi","Negara"},	
	{"No","Code","Company Name","Phone","Address","City","Province","Country"}
};

public static final String masterTitle[] = {
	"Daftar","List"	
};

public static final String compTitle[] = {
	"Perusahaan","Company"
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
	ctrlist.dataFormat(strTitle[language][4],"24%","center","left");
	ctrlist.dataFormat(strTitle[language][5],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][6],"10%","center","left");
	ctrlist.dataFormat(strTitle[language][7],"10%","center","left");

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
		Company objCompany = (Company)objectClass.get(i);
		Vector rowx = new Vector();
		
	    if(oid==objCompany.getOID()){index =i;} 		
		
		start = start + 1;
		rowx.add(String.valueOf(start)); 
		rowx.add(cekNull(objCompany.getCompanyCode())); 
		rowx.add(cekNull(objCompany.getCompanyName()));
		rowx.add(cekNull(objCompany.getPhoneNr()));
		rowx.add(cekNull(objCompany.getBussAddress()));
		rowx.add(cekNull(objCompany.getTown()));
		rowx.add(cekNull(objCompany.getProvince()));
		rowx.add(cekNull(objCompany.getCountry()));		
		
		lstData.add(rowx);
		lstLinkData.add(String.valueOf(objCompany.getOID()));
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
long oidCompanyList = FRMQueryString.requestLong(request, "hidden_company_id");
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
CtrlCompany ctrlCompany = new CtrlCompany(request);
SrcCompany srcCompany = new SrcCompany();
SessCompany sessCompany = new SessCompany();
FrmSrcCompany frmSrcCompany = new FrmSrcCompany(request, srcCompany);
		
/**
* handle current search data session 
*/
if(iCommand==Command.BACK || iCommand==Command.FIRST || iCommand==Command.PREV || iCommand==Command.NEXT || iCommand==Command.LAST){
	 try{ 
		srcCompany = (SrcCompany)session.getValue(SessCompany.SESS_COMPANY); 
	 }catch(Exception e){ 
		srcCompany = new SrcCompany();
	 }
}else{
	 frmSrcCompany.requestEntityObject(srcCompany);
}

/**
* get vectSize, start and data to be display in this page
*/
vectSize = sessCompany.getCount(srcCompany);
if(iCommand!=Command.BACK){  
	start = ctrlCompany.actionList(iCommand, start, vectSize, recordToGet);
}else{
	iCommand = Command.LIST;
}

Vector records = sessCompany.getDataCompany(srcCompany, start, recordToGet);


%>
<!-- End of Jsp Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="JavaScript">
<!--
function cmdAdd(){
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.command.value="<%=Command.ADD%>";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.action="company_edit.jsp";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.submit();
}

function cmdEdit(oid){
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.command.value="<%=Command.EDIT%>";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.hidden_company_id.value = oid;
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.action="company_edit.jsp";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.submit();
}

function first(){
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.command.value="<%=Command.FIRST%>";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.action="company_list.jsp";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.submit();
}

function prev(){
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.command.value="<%=Command.PREV%>";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.action="company_list.jsp";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.submit();
}

function next(){
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.command.value="<%=Command.NEXT%>";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.action="company_list.jsp";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.submit();
}

function last(){
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.command.value="<%=Command.LAST%>";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.action="company_list.jsp";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.submit();
}

function cmdBack(){
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.command.value="<%=Command.BACK%>";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.action="srccompany_list.jsp";
	document.<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>.submit();
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
            <form name="<%=FrmSrcCompany.FRM_SEARCH_COMPANY%>" method="post" action="">
              <input type="hidden" name="command" value="">
              <input type="hidden" name="start" value="<%=start%>">
              <input type="hidden" name="hidden_company_id" value="<%=oidCompanyList%>">
              <table border="0" width="100%">
                <tr> 
                  <td height="8">&nbsp; 
                    
                  </td>
                </tr>
              </table>                       
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
	            <%if((records!=null)&&(records.size()>0)){%>			  
                <tr> 
                  <td><%=drawList(SESS_LANGUAGE,records,oidCompanyList,start)%></td>
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