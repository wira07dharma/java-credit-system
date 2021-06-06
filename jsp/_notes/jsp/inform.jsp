 
<%@ page language="java" %>
<%@ include file = "main/javainit.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="com.wihita.qdep.system.*" %>
<%@ page import="com.wihita.aisbit.session.admin.*" %>
<%@ page import="com.wihita.aisbit.entity.admin.*" %>

<%

    
    if(isLoggedIn==false){
        %>
                <script language="javascript">
                        window.location="index.html";
                </script>			
        <%			

    }
%>
<%
	String sic = (request.getParameter("ic")==null) ? "0" : request.getParameter("ic");
	int infCode = 0;
	String msgAccess = "";
	try{
		infCode = Integer.parseInt(sic);
	}catch(Exception e){ 
		infCode = 0;
	}
%>
<html>
<head>
<title>Prochain - System Information</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="style/main.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr> 
    <td colspan="2" height="50" class="toptitle"> 
      <div align="center">ProChain - Production Chain Management System</div>
    </td>
  </tr>
  <tr> 
    <td colspan="2" class="topmenu" height="20"> 
      <%@ include file = "main/menumain.jsp" %>
    </td>
  </tr>
  <tr> 
    <td width="200" valign="top" align="left" >&nbsp;  </td>
    <td width="88%" valign="top" align="left"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="20" class="contenttitle" >System Information</td>
        </tr>
        <tr> 
          <td> 
            <table width="100%" border="0" cellspacing="0"  >
              <tr> 
                <td width="595" height="148"  valign="top" > 
                  <table width="100%">
                    <tr> 
                      <td>&nbsp; 
                        <% 				
						switch(infCode) {
							case I_SystemInfo.DATA_LOCKED : 
								msgAccess  = I_SystemInfo.textInfo[infCode];
								break;

							case I_SystemInfo.HAVE_NOPRIV : 
								msgAccess  = I_SystemInfo.textInfo[infCode];
								break;

							case I_SystemInfo.NOT_LOGIN : 
								msgAccess  = I_SystemInfo.textInfo[infCode];
								break;
								
							default:
								%>
                        <script language="javascript">
										window.location="<%= approot %>/index.html"
									</script>
                        <%																
						}
						
					%>
                      </td>
                    </tr>
                    <tr class="msgaccess"> 
                      <td>&nbsp; <%= msgAccess %> </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
            </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2" height="20" class="footer"> 
      <div align="center"> copyright Bali Information Technologies 2002</div>
    </td>
  </tr>
</table>
</body>
</html>
