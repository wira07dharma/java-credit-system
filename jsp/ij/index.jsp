<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>
<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>
<!-- JSP Block -->
<!-- End of JSP Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>AISO - Interactive Journal</title>
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
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
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr> 
    <td bgcolor="#0000FF" height="50" ID="TOPTITLE"> 
      <%@ include file = "../main/header.jsp" %>
    </td>
  </tr>
  <tr> 
    <td bgcolor="#000099" height="20" ID="MAINMENU" class="footer"> 
      <%@ include file = "../main/menumain.jsp" %>
    </td>
  </tr>
  <tr> 
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" --><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" --> 
            <table width="100%" border="0" align="center">
              <tr> 
                <td align="center"><b><font size="2"><u>MAIN MENU</u></font></b> 
                </td>
              </tr>
              <tr> 
                <td align="center">&nbsp;</td>
              </tr>
              <tr> 
                <td align="center"><a href="<%=ijroot%>/configuration/ijconfiguration.jsp">IJ 
                  - Configuration</a></td>
              </tr>
              <tr> 
                <td align="center">&nbsp;</td>
              </tr>
              <tr> 
                <td align="center"><a href="<%=ijroot%>/mapping/ijcurrencymapping.jsp">IJ 
                  - Currency Mapping</a></td>
              </tr>
              <tr> 
                <td align="center"><a href="<%=ijroot%>/mapping/ijpaymentmapping.jsp">IJ 
                  - Payment Mapping</a></td>
              </tr>
              <tr> 
                <td align="center"><a href="<%=ijroot%>/mapping/ijaccountmapping.jsp">IJ 
                  - Account Mapping</a></td>
              </tr>
              <tr> 
                <td align="center"><a href="<%=ijroot%>/mapping/ijlocationmapping.jsp">IJ 
                  - Location Mapping</a></td>
              </tr>
              <tr> 
                <td align="center">&nbsp;</td>
              </tr>
              <tr> 
                <td align="center"><a href="<%=ijroot%>/engine/ij_journal_process.jsp">IJ 
                  - Journal Process</a></td>
              </tr>
              <tr> 
                <td align="center"><a href="<%=ijroot%>/engine/src_ij_journal.jsp">IJ 
                  - List Journal</a></td>
              </tr>
              <tr> 
                <td align="center">&nbsp;</td>
              </tr>
              <tr> 
                <td align="center">&nbsp;</td>
              </tr>
            </table>
            <!-- #EndEditable --></td>
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
<!-- #EndTemplate -->
</html>
