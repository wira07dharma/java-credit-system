<%@ page language = "java" %>
<%@ include file = "../main/javainit.jsp" %>

<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.lang.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.util.*" %>

<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.entity.periode.*" %>
<%@ page import = "com.dimata.aiso.session.masterdata.*" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_MASTERDATA, AppObjInfo.G2_MASTERDATA_ACCOUNT_CART, AppObjInfo.OBJ_MASTERDATA_ACCOUNT_CART); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));

//if of "hasn't access" condition 
if (!privView) {
%>
<script language="javascript">
	window.location="<%=approot%>/nopriv.html";
</script>
<!-- if of "has access" condition -->
<%
} else {
%>


<%!
String strPeriod[] = 
{
	"Periode", 
	"Period"
};

String strBudget[] = 
{
	"Jumlah", 
	"Amount"
};

public String drawList(int language, int iStart, Vector objBudgeting)
{
     ControlList ctrlist = new ControlList();
     ctrlist.setAreaWidth("70%");
     ctrlist.setListStyle("listgen");
     ctrlist.setTitleStyle("listgentitle");
     ctrlist.setCellStyle("listgensell");
     ctrlist.setHeaderStyle("listgentitle");
     
     ctrlist.dataFormat("<div align=\"center\">No.</div>", "5%", "", "");
     ctrlist.dataFormat("<div align=\"center\">" + strPeriod[language] + "</div>", "45%", "", "");
     ctrlist.dataFormat("<div align=\"center\">" + strBudget[language] + "</div>", "25%", "left", "left");
     
     Vector lstData = ctrlist.getData();
     Vector lstLinkData = ctrlist.getLinkData();
     
     int objBudgSize = objBudgeting.size();
     
     for (int item = 0; item < objBudgSize; item++) 
	 {
         Budgeting objBudg = (Budgeting) objBudgeting.get(item);
         
         String strPerdName = objBudg.getPeriodName();
         double dBudget = objBudg.getBudget();
         
         Vector rowx = new Vector();
         rowx.add("<div align=\"right\">" + String.valueOf(iStart + item) + "&nbsp;</div>");
         rowx.add("&nbsp;" + strPerdName);
         rowx.add("<div align=\"right\">" + FRMHandler.userFormatStringDecimal(dBudget) + "</div>");
         lstData.add(rowx);     
     }    
     
     return ctrlist.draw();   
}    
%>

<%
String strPageTitle = (SESS_LANGUAGE == I_Language.LANGUAGE_FOREIGN) ? "Budget List" : "Daftar Anggaran";
long lAccOid = FRMQueryString.requestLong(request, "accountchart_id");
if (lAccOid == 0)  lAccOid = FRMQueryString.requestLong(request, "accountOid");
int iStart = FRMQueryString.requestInt(request, "start");
int iListCommand = FRMQueryString.requestInt(request, "listCommand");
if (iListCommand == Command.NONE) iListCommand = Command.LIST;
 
 ControlLine ctrLine = new ControlLine();
 ctrLine.setLanguage(SESS_LANGUAGE);
 
 int iVectSize = SessAisoBudgeting.getBudgetingHistoryCount(lAccOid);
 int iRecToGet = 10;
  
 Control controlList = new Control();
 iStart = controlList.actionList(iListCommand, iStart, iVectSize, iRecToGet);
 String strBack[] = {"Kembali ke Editor Anggaran", "Back to Budget Editor"};
 
 Vector vectBudgeting = SessAisoBudgeting.getBudgetingHistory(lAccOid, iStart, iRecToGet);
 
%>
<script language="javascript">
	function cmdBack(){
		document.frmBudgetList.action = "edit_budget.jsp";
		document.frmBudgetList.submit();
	}
</script>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> 
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->Master Data : <font color="#CC3300"><%=strPageTitle.toUpperCase()%></font><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" --> 
          <form name="frmBudgetList" method="POST">		  
           <input type="hidden" name="accountchart_id" value="<%=lAccOid%>">
           <input type="hidden" name="accountOid" value="<%=lAccOid%>">		   
           <input type="hidden" name="start" value="<%=iStart%>">
           <input type="hidden" name="listCommand" value="<%=iListCommand%>">
           <table width="100%">
            <tr>
              <td>&nbsp;</td>
            </tr>
            <tr>
             <td>
              <%=drawList(SESS_LANGUAGE, iStart + 1, vectBudgeting)%>
             </td>
            </tr><tr>
             <td class="command"><%=ctrLine.drawMeListLimit(iListCommand, iVectSize, iStart, iRecToGet, "first", "prev", "next", "last", "left")%></td>
            </tr>
            <tr><td>&nbsp;<a href="javascript:cmdBack()"><b><%=strBack[SESS_LANGUAGE]%></b></a></td></tr>
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
<% 
} 
%>