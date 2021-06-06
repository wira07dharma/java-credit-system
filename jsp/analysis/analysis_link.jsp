<%@ page language = "java" %>

<%@ include file = "../main/javainit.jsp" %>

<!--import aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.form.masterdata.*" %>
<%@ page import = "com.dimata.aiso.session.masterdata.*" %>

<!--import java-->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<!--import qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>

<% int appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_ACCOUNT_LINK, AppObjInfo.OBJ_MASTERDATA_ACCOUNT_LINK); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

//if of "hasn't access" condition 
if (!privView && !privAdd && !privUpdate && !privDelete) {
%>
<script language="javascript">
    window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
} else {
%>

<!-- JSP Block -->

<%!
public static final String pageTitle[] = {
    "Analisis", "Analysis"	
};

public static final String linkTitle[] = {
    "Link Analisis", "Analysis Link"	
};

public static String strLinkAccount[][] = {
    {"", "", "", "", "", "", "", "", "Kas", "Bank", "Aktiva Lancar", "Hutang Jangka Pendek", "Aktiva", "Hutang Jangka Panjang", "Modal"},	
    {"", "", "", "", "", "", "", "", "Cash", "Bank", "Liquid Assets", "Current Liabilites", "Assets", "Long Term Liabilites", "Equity"}
};

// for list and editor single account link
public String drawListSingleAccount(int language,
                                    String strAccIndex,
                                    int iCommand,
                                    FrmAccountLink frmAccountLink,
                                    Vector objectClass,
                                    long accLinkId,
                                    Vector listAccount)
{	
    
    ControlList ctrlist = new ControlList();
    ctrlist.setAreaWidth("50%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("listgentitle");
    ctrlist.setCellStyle("listgensell");
    ctrlist.setHeaderStyle("listgentitle");
    String strHeader = strAccIndex;
    if (language == com.dimata.util.lang.I_Language.LANGUAGE_DEFAULT) {
        strHeader = pageTitle[language] + " " + strHeader; 
    } else {
        strHeader = strHeader + " " + pageTitle[language]; 
    }
    ctrlist.dataFormat(strHeader, "100%", "left", "left");
    
    ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");
    Vector lstData = ctrlist.getData();
    Vector lstLinkData = ctrlist.getLinkData();
    ctrlist.setLinkPrefix("javascript:cmdClickLink('");
    ctrlist.setLinkSufix("')");
    ctrlist.reset();
    Vector rowx = new Vector(1, 1);	
    int index = -1;
	
    Vector vectVal = new Vector(1, 1);	 
    Vector vectKey = new Vector(1, 1);	 
    String space = "";
    
    if (listAccount != null && listAccount.size() > 0) {
        for (int j = 0; j < listAccount.size(); j++) {
            Perkiraan per = (Perkiraan) listAccount.get(j); 
            switch (per.getLevel()) {
            case 1 : space = "&nbsp;"; break; 
            case 2 : space = "&nbsp;&nbsp;&nbsp;"; break;
            case 3 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
            case 4 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
            case 5 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break;
            case 6 : space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"; break; 															    															   															   															   															   
            }			
            vectKey.add("" + per.getOID());
            vectVal.add(space + per.getNoPerkiraan() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + per.getNama());						
        }
    }
	
    String namaAccount = "";
    String strSelected = "";		
    String attrFirst = "onChange=\"javascript:cmdChangeFirst()\"";	
    for (int i = 0; i < objectClass.size(); i++) {
        AccountLink acc = (AccountLink) objectClass.get(i);
	strSelected = String.valueOf(acc.getFirstId());			 
	rowx = new Vector();
	if (accLinkId == acc.getOID())
            index = i; 

	if (index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)) {
            rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID], "", strSelected, vectKey, vectVal, attrFirst));
	} else { 			
            Vector listAccountFirst = SessPerkiraan.findFieldPerkiraan(acc.getFirstId());		 
            if (listAccountFirst != null && listAccountFirst.size() > 0) {
                Perkiraan account = (Perkiraan) listAccountFirst.get(0);
		namaAccount = account.getNama(); 
            }													 		 		 
            rowx.add(namaAccount);
	} 
	lstData.add(rowx);
	lstLinkData.add(String.valueOf(acc.getOID()));	 		 		 
    }
    
    rowx = new Vector();
    if (iCommand == Command.ADD || (iCommand == Command.SAVE && frmAccountLink.errorSize() > 0)) { 
        rowx.add(ControlCombo.draw(frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID], "Choose an postable account", "", vectKey, vectVal, attrFirst));
    }		
    lstData.add(rowx);

    return ctrlist.drawMe(index);
}

%>

<%
int iCommand = FRMQueryString.requestCommand(request);
long accLinkId = FRMQueryString.requestLong(request, "accLinkId");
int postableFirst = FRMQueryString.requestInt(request,"postableFirst");
int postableSecond = FRMQueryString.requestInt(request,"postableSecond");
int linkType = FRMQueryString.requestInt(request,"account_link_type");

if (linkType < PstAccountLink.START_TYPE_INDEX)
    linkType = PstAccountLink.START_TYPE_INDEX;

/**
* ControlLine and Commands caption
*/
ControlLine ctrLine = new ControlLine();
String currPageTitle = linkTitle[SESS_LANGUAGE];
String strAddLink = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ADD,true);
String strSaveLink = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_SAVE,true);
String strAskLink = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_ASK,true);
String strDeleteLink = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_DELETE,true);
String strCancel = ctrLine.getCommand(SESS_LANGUAGE,currPageTitle,ctrLine.CMD_CANCEL,false);
String delConfirm = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Are You Sure to Delete " : "Anda Yakin Menghapus ")+currPageTitle+" ?";
String strNoLink = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "No "+currPageTitle+" Available" : "Tidak Ada "+currPageTitle; 

CtrlAccountLink ctrlAccountLink = new CtrlAccountLink(request);
ctrlAccountLink.setLanguage(SESS_LANGUAGE);
FrmAccountLink frmAccountLink = ctrlAccountLink.getForm(); 

/** Action method */
int ctrlErr = ctrlAccountLink.action(iCommand, accLinkId);
AccountLink accountLink = ctrlAccountLink.getAccountLink();

String order = PstPerkiraan.fieldNames[PstPerkiraan.FLD_NOPERKIRAAN];
String whereLink = PstAccountLink.fieldNames[PstAccountLink.FLD_LINKTYPE] + " = " + linkType;
String ordLink = PstAccountLink.fieldNames[PstAccountLink.FLD_LINKTYPE];
Vector listCode = AppValue.getAppValueVector(AppValue.ACCOUNT_CHART);
Vector listAccountLink = PstAccountLink.list(0, 0, whereLink, ordLink);


Vector linkTypeKey = new Vector(1,1);
Vector linkTypeValue = new Vector(1,1);		

%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>

<script language="javascript">

function cmdSearchLink() {
 document.frmaccountlink.command.value = "<%=Command.NONE%>";
 document.frmaccountlink.accLinkId.value = 0;
 document.frmaccountlink.action = "analysis_link.jsp"; 
 document.frmaccountlink.submit();
}

<% if ((privAdd) && (privUpdate) && (privDelete)) { %>
function addNew() {
 document.frmaccountlink.command.value = "<%=Command.ADD%>";
 document.frmaccountlink.accLinkId.value = 0;
 document.frmaccountlink.action = "analysis_link.jsp";
 document.frmaccountlink.submit();
}


function cmdSave() {
  var postFirstValue = document.frmaccountlink.postableFirst.value;
  var postSecondValue = 1; //document.frmaccountlink.postableSecond.value;	
  if (postFirstValue == 1 && postSecondValue == 1) {
   
   document.frmaccountlink.command.value = "<%=Command.SAVE%>";
   document.frmaccountlink.action = "analysis_link.jsp";
   document.frmaccountlink.submit();
  } else {
   if (postFirstValue == 0 && postSecondValue == 0) {
    msgPostable.innerHTML = "<i>&nbsp;Please choose an account ...</i>";					
   } else {
    msgPostable.innerHTML = "<i>&nbsp;Cannot process, non postable account ...</i>";			
   }
  }	
 	
}

function cmdAsk(oidFirst) {
 document.frmaccountlink.command.value = "<%=Command.ASK%>";
 document.frmaccountlink.accLinkId.value = oidFirst;	
 document.frmaccountlink.action = "analysis_link.jsp";
 document.frmaccountlink.submit();
}
 
function cmdDelete(oidFirst) {
 document.frmaccountlink.command.value = "<%=Command.DELETE%>";
 document.frmaccountlink.accLinkId.value = oidFirst;	
 document.frmaccountlink.action = "analysis_link.jsp";
 document.frmaccountlink.submit();
}
<% } %>

function cmdCancel() {
 document.frmaccountlink.command.value = "<%=Command.NONE%>";
 document.frmaccountlink.accLinkId.value = 0;
 document.frmaccountlink.postableFirst.value = "0";
 document.frmaccountlink.postableSecond.value = "0";	
 document.frmaccountlink.action = "analysis_link.jsp";
 document.frmaccountlink.submit();
}

function cmdClickLink(idLink) {
 document.frmaccountlink.postableFirst.value = "1";
 document.frmaccountlink.postableSecond.value = "1";	
 document.frmaccountlink.accLinkId.value = idLink; 
 document.frmaccountlink.command.value = "<%=Command.EDIT%>";
 document.frmaccountlink.action = "analysis_link.jsp";
 document.frmaccountlink.submit();  
}

<% if (iCommand != Command.NONE || iCommand != Command.SUBMIT) { %>
 function cmdChangeFirst() {
  var selVal = Math.abs(document.frmaccountlink.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID]%>.value);
  switch (selVal) {  
  <% for (int i = 0; i < listCode.size(); i++) {
      Perkiraan p = (Perkiraan) listCode.get(i);
      long oid = p.getOID(); %>
      case <%=oid%> : <% if (p.getPostable()) { %>
       document.frmaccountlink.postableFirst.value = "1";
       msgPostable.innerHTML = "";			
      <% } else { %>
       document.frmaccountlink.postableFirst.value = "-1";       
      <% } %>  				  
       break;
      <% } %>
      default :	break;
  }	 
}

function cmdChangeSecond() {
 var selVal = Math.abs(document.frmaccountlink.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_SECOND_ID]%>.value);
 switch (selVal) {  
 <% for (int i = 0; i < listCode.size(); i++) {
     Perkiraan p = (Perkiraan) listCode.get(i);
     long oid = p.getOID(); %>
     case <%=oid%> : <% if (p.getPostable()) { %>
      document.frmaccountlink.postableSecond.value = "1";
      msgPostable.innerHTML = "";			
     <% } else { %>
      document.frmaccountlink.postableSecond.value = "-1";					 
      msgPostable.innerHTML = "<i>Cannot process, non postable account ...</i>";			
     <% } %>  				  
      break;
     <%}%>
     default :	break;
 }	 
}
<%}%>

function cmdTypeChange() {
 var typeValue = document.frmaccountlink.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_TYPE]%>.value;
}

function cmdSmallerFirst() {
 document.all.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID]%>.style.width = "483";
 document.all.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_SECOND_ID]%>.style.width = "500";	
}

function cmdSmallerSecond() {
 document.all.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_FIRST_ID]%>.style.width = "500";
 document.all.<%=frmAccountLink.fieldNames[frmAccountLink.FRM_SECOND_ID]%>.style.width = "483";	
}

</script>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
<script language="javascript">
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
</script>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head> 

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
 <table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr><td bgcolor="#0000FF" height="50" ID="TOPTITLE"> 
   <%@ include file = "../main/header.jsp" %> 
  </td></tr>
  <tr><td bgcolor="#000099" height="20" ID="MAINMENU" class="footer"> 
   <%@ include file = "../main/menumain.jsp" %>
  </td></tr>
  <tr><td width="88%" valign="top" align="left"> 
   <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr><td height="20" class="contenttitle"><!-- #BeginEditable "contenttitle" --><%=pageTitle[SESS_LANGUAGE]%> &gt; <%=currPageTitle%><!-- #EndEditable --></td></tr>
    <tr><td><!-- #BeginEditable "content" --> 
     <form name="frmaccountlink" method="post" action="">
      <input type="hidden" name="command" value="<%=iCommand==Command.ADD ? Command.ADD : Command.LIST%>">
      <input type="hidden" name="accLinkId" value="<%=accLinkId%>">
      <input type="hidden" name="postableFirst" value="<%=postableFirst%>">
      <input type="hidden" name="postableSecond" value="<%=postableSecond%>">
      <input type="hidden" name="<%=frmAccountLink.fieldNames[frmAccountLink.FRM_TYPE]%>" value="<%=linkType%>">			  			  
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr><td valign="top" height="372"> 
       <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <tr><td width="100%"><hr></td></tr>
        <tr><td width="100%">
         <table width="100%" cellspacing="1" cellpadding="0">
          <tr><td width="25%"> 
           <%
           linkTypeKey.add(String.valueOf(PstAccountLink.TYPE_CASH));
           linkTypeValue.add(PstAccountLink.typeNames[SESS_LANGUAGE][PstAccountLink.TYPE_CASH]); 

           linkTypeKey.add(String.valueOf(PstAccountLink.TYPE_BANK));
           linkTypeValue.add(PstAccountLink.typeNames[SESS_LANGUAGE][PstAccountLink.TYPE_BANK]); 

           linkTypeKey.add(String.valueOf(PstAccountLink.TYPE_LIQUID_ASSETS));
           linkTypeValue.add(PstAccountLink.typeNames[SESS_LANGUAGE][PstAccountLink.TYPE_LIQUID_ASSETS]); 

           linkTypeKey.add(String.valueOf(PstAccountLink.TYPE_CURRENT_LIABILITIES));
           linkTypeValue.add(PstAccountLink.typeNames[SESS_LANGUAGE][PstAccountLink.TYPE_CURRENT_LIABILITIES]); 

           //linkTypeKey.add(String.valueOf(PstAccountLink.TYPE_ASSETS));
           //linkTypeValue.add(PstAccountLink.typeNames[SESS_LANGUAGE][PstAccountLink.TYPE_ASSETS]); 

           linkTypeKey.add(String.valueOf(PstAccountLink.TYPE_LONG_TERM_LIABILITIES));
           linkTypeValue.add(PstAccountLink.typeNames[SESS_LANGUAGE][PstAccountLink.TYPE_LONG_TERM_LIABILITIES]); 

           linkTypeKey.add(String.valueOf(PstAccountLink.TYPE_EQUITY));
           linkTypeValue.add(PstAccountLink.typeNames[SESS_LANGUAGE][PstAccountLink.TYPE_EQUITY]); 

		   String strSelType = String.valueOf(linkType);
		   String attrType = "onChange=\"javascript:cmdSearchLink()\"";
		   %>
           <%="&nbsp;" + ControlCombo.draw("account_link_type", null, strSelType, linkTypeKey, linkTypeValue, attrType)%></td>
          </tr>
          <!-- No journal detail available -->
          <% if (listAccountLink.size() == 0 && (iCommand == Command.NONE || iCommand == Command.DELETE)) { %>
          <tr><td colspan="2" height="8"><div align="left"><span class="comment"><%=strNoLink%></span></div></td></tr>
	  <% if (privAdd) { %>
	  <tr><td colspan="2" class="command"><div align="left"><a href="javascript:addNew()"><%=strAddLink%></a></div></td></tr>
          <%}%>
          <%}else{%>
	  <tr><td width="25%">
          <%=drawListSingleAccount(SESS_LANGUAGE, strLinkAccount[SESS_LANGUAGE][linkType], iCommand, frmAccountLink, listAccountLink, accLinkId, listCode)%>
	  </td></tr>
	  <% if (iCommand == Command.ASK) { %>
	  <tr><td colspan="2" class="msgquestion"><div align="center"><%=delConfirm%></div></td></tr>
	  <% } %>
          <tr><td class="msgbalance" ID=msgPostable width="25%"><i><%="&nbsp;" + ctrlAccountLink.getMessage()%></i></td></tr>
	  <tr><td width="25%">&nbsp;
          <% if ((privAdd) && (privUpdate) && (privDelete)){ %>
          <% if (iCommand != Command.ASK) { %>
	  <% if (iCommand == Command.NONE || iCommand == Command.DELETE) { %>
	   <span class="command"><a href="javascript:addNew()"><%=strAddLink%></a></span> 
	  <% } %>
	  <% if (iCommand == Command.ADD) { %>
	   <span class="command"><a href="javascript:cmdSave()"><%=strSaveLink%></a></span> | <span class="command"><a href="javascript:cmdCancel()"><%=strCancel%></a></span> 
	  <% } %>
	  <% if (iCommand == Command.SAVE) { %>
	   <span class="command"><a href="javascript:addNew()"><%=strAddLink%></a></span> 
	  <% } %>
	  <% if (iCommand == Command.EDIT || iCommand == Command.LIST) { %>
	   <span class="command"><a href="javascript:cmdSave()"><%=strSaveLink%></a></span> | <span class="command"><a href="javascript:cmdAsk('<%=accLinkId%>')"><%=strAskLink%></a></span> | <span class="command"><a href="javascript:cmdCancel()"><%=strCancel%></a></span> 
	  <% } %>
	  <% } else { %>
	   <span class="command"><a href="javascript:cmdDelete('<%=accLinkId%>')"><%=strDeleteLink%></a></span> | <span class="command"><a href="javascript:cmdCancel()"><%=strCancel%></a></span>	
	  <% } %>
	  <% } %>
	  </td></tr>
	  <% } %>
         </table>
        </td></tr>
        </table>
       </td></tr>
      </table>
     </form><!-- #EndEditable -->
    </td></tr>
   </table>
  </td></tr>
  <tr><td colspan="2" height="20" class="footer"> 
   <%@ include file = "../main/footer.jsp" %>
  </td></tr>
 </table>
</body>
<!-- #EndTemplate -->
</html>
<!-- endif of "has access" condition -->
<% } %>