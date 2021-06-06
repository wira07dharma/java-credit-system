<%@ page language="java" %> 

<%@ include file="main/javainit.jsp"%> 
<%@ page import="com.wihita.aisbit.session.admin.*" %>
<%@ page import="com.wihita.qdep.form.*" %>

<%

try{
        if(userSession.isLoggedIn()==true){
            System.out.println("doLogout"); 
            userSession.printAppUser();
            userSession.doLogout(); 
            session.removeValue(SessUserSession.HTTP_SESSION_NAME);
        }


   } catch (Exception exc){
      System.out.println(" ==> Exception during logout user");
    }

%>


<html>
<head>
<title>Log Out</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">
<!--


//-->
</script>

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#003399" >
<table  height="100%" align="center" bgcolor="#CC0000" cellspacing="0" cellpadding="0" width="60%" border="0">
  <tr><td>
      <table height="100%" align="center" bgcolor="#FFCC99" cellspacing="0" cellpadding="0" width="80%">
        <tr> 
          <td width="455" height="27" align="center"> 
            <h1><font face="Times New Roman, Times, serif">Thank You</font></h1>
          </td>
        </tr>
        <tr> 
          <td width="455" height="300" align="center" valign="top"><img src="image/prod_line.gif" width="185" height="151"></td>
        </tr>
        <tr> 
          <td height="2"  align="center"> </td>
        </tr>
        <tr> 
          <td   align="center"> 
            <table cellspacing="2" cellpadding="2" border="1">
              <tr> 
                <td bgcolor="#FFCC99" align="center" valign="middle">&nbsp;&nbsp;<a href="login.jsp"><font face="Arial, Helvetica, sans-serif"><b><font size="2">Log 
                  in</font></b></font></a>&nbsp;&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td  height="2"  align="center">&nbsp; </td>
        </tr>
        <tr> 
          <td width="455"  align="center"> <font face="Times New Roman, Times, serif" size="6"><b>for 
            using Aisbit</b></font></td>
        </tr>
      </table>
</td></tr></table>            
</body>
</html>
