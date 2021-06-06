<%@ page language="java" %>
<%@ include file = "../main/javainit.jsp" %>

<!-- import dimata-->
<%@ page import = "java.util.*" %>
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.util.*" %>

<!-- import qdep-->
<%@ page import = "com.dimata.qdep.form.*" %>
<%@ page import = "com.dimata.qdep.entity.*" %>

<!-- import aiso-->
<%@ page import = "com.dimata.aiso.entity.masterdata.*" %>
<%@ page import = "com.dimata.aiso.entity.periode.*" %>
<%@ page import = "com.dimata.aiso.entity.jurnal.*" %>
<%//@ page import = "com.dimata.aiso.form.periode.*" %>
<%@ page import = "com.dimata.aiso.session.periode.*" %>
<%@ page import = "com.dimata.aiso.session.jurnal.*" %>
<%//@ page import = "com.dimata.aiso.form.masterdata.*" %>

<!-- import harisma-->
<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>

<% int  appObjCode =  AppObjInfo.composeObjCode(AppObjInfo.G1_PERIOD, AppObjInfo.G2_PERIOD_CLOSE_BOOK, AppObjInfo.OBJ_PERIOD_CLOSE_BOOK); %>
<%@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));
boolean privSubmit=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_SUBMIT));

//if of "hasn't access" condition 
if(!privView && !privSubmit){
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
/* this constant used to list text of listHeader */
public static final String pageTitle[] = {
	"Import Data","Import Data"	
};

private static final String strDataUpload[][] = {
	{"Perkiraan","Aktiva Tetap","Kontak","Hutang","Piutang"},
	{"Chart of Account","Fixed Asset","Contact","Account Payable","Account Receivable"}
};
%>

<%
// ngambil data dari request form
int iCommand = FRMQueryString.requestCommand(request);

// setup controlLine and commands caption
String strCloseBook = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Close Book" : "Tutup Buku";
String strYesCloseBook = (SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Yes " : "Ya ") + strCloseBook;
String strCancel = SESS_LANGUAGE==com.dimata.util.lang.I_Language.LANGUAGE_FOREIGN ? "Cancel" : "Batal";


%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Accounting Information System Online</title>
<script language="javascript">	
	
</script>
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
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" --><%=pageTitle[SESS_LANGUAGE]%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
            <form name="frmimportdata" method="post" action="import_process.jsp" enctype="multipart/form-data">
			  <table width="100%" border="0">
                      <tr>
                        <td><i>Choose file (.xls) to export to SEDANA</i></td>
                      </tr>
                      <tr>
                        <td>
                          <input type="file" name="file" size="60" value="">
						  <select name="file_type">
						  	<%
								for(int i = 0; i < strDataUpload[SESS_LANGUAGE].length; i++){
							%>
						    	<option value="<%=i%>" selected><%=strDataUpload[SESS_LANGUAGE][i]%></option>
						    <%
								}
							%>
						</select>
                          <input type="submit" name="Submit" value=" Submit ">
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
<%}%>