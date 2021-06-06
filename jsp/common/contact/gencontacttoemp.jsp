<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>
<%@ page language="java" %>
<!-- import java -->
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<!-- import dimata -->
<%@ page import="com.dimata.util.*" %>
<!-- import aiso -->
<%@ page import="com.dimata.aiso.entity.admin.*" %> 
<%@ page import="com.dimata.aiso.entity.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.masterdata.*" %>
<%@ page import="com.dimata.aiso.session.journal.*" %>
<%@ page import="com.dimata.harisma.session.employee.*" %>
<!-- import qdep -->
<%@ page import="com.dimata.qdep.form.*" %>
<%@ page import="com.dimata.gui.jsp.*" %>
<%@ include file = "../../main/javainit.jsp" %>
<!-- JSP Block -->
<%
int iCommand = FRMQueryString.requestCommand(request);
long oid = 0;
if(iCommand==Command.SUBMIT){
	oid = SessEmployee.genEmployeeFrmContact();
}
%>
<!-- End of JSP Block -->
<html>
<!-- #BeginTemplate "/Templates/main.dwt" --> 
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Generate Employee From Apropriate Contact</title>
<!-- #EndEditable --> <!-- #BeginEditable "headerscript" --> 
<script language="JavaScript">
	function cmdGenerateEmp(){
		document.frmgenerate.command.value="<%=Command.SUBMIT%>";
		document.frmgenerate.action="gencontacttoemp.jsp";
		document.frmgenerate.submit();
	}		
</script>
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
          <td height="20" class="contenttitle" ><!-- #BeginEditable "contenttitle" -->Contact 
            &gt; Generate Employee<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td><!-- #BeginEditable "content" -->
            <form name="frmgenerate" method="post" action="">
            <input type="hidden" name="command" value="<%=iCommand%>">					  
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
              <tr>
                <td>
                  <hr>
                </td>
              </tr>
			  <%if(iCommand!=Command.SUBMIT){%>
              <tr>
                <td><a href="javascript:cmdGenerateEmp()" class="command">Generate Employee</a>
                </td>
              </tr>
			  <%}else{
			    if(oid>0){
			  %>
              <tr>
                  <td class="fielderror"><i>generate employee successful ...</i></td>
              </tr>			  
			  <%
			  	}else{
			  %>
              <tr>
                  <td class="fielderror"><i>generate employee fail ...</i></td>
              </tr>			  			  
			  <%
			  	}	
			  }
			  %>
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
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
