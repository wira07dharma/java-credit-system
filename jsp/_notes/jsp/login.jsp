<%@ page language="java" %> 
<%@ include file="main/javainit.jsp"%> 
<%@ page import="java.util.*" %>
<%@ page import="com.wihita.aisbit.session.admin.*" %>
<%@ page import="com.wihita.qdep.form.*" %>
 
<%!
 final static int CMD_NONE =0;
 final static int CMD_LOGIN=1;
 final static int MAX_SESSION_IDLE=100000;
%>
  
<%  
    int iCommand = FRMQueryString.requestCommand(request);
    int dologin = SessUserSession.DO_LOGIN_OK ; 
    if(iCommand==CMD_LOGIN){    
        String loginID = FRMQueryString.requestString(request,"login_id");
        String passwd  = FRMQueryString.requestString(request,"pass_wd");    
        String remoteIP = request.getRemoteAddr();
        SessUserSession userSess = new SessUserSession(remoteIP );

        dologin=userSess.doLogin(loginID, passwd);
        System.out.println(iCommand+" | "+loginID+" | "+passwd+" | "+userSess+" | dologin="+ (dologin==SessUserSession.DO_LOGIN_OK));
        if(dologin==SessUserSession.DO_LOGIN_OK){           
            session.setMaxInactiveInterval(MAX_SESSION_IDLE);
            session.putValue(SessUserSession.HTTP_SESSION_NAME, userSess);
            userSess = (SessUserSession) session.getValue(SessUserSession.HTTP_SESSION_NAME);
            if(userSess==null)
                    System.out.println("userSession after login ----------------->null");
                else
                    System.out.println("userSession after login ----------------->OK");
        }  
    }
  
%>


<html>
<head> 
<title>User Login</title> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="style/login.css" type="text/css">
 
 
<script language="javascript"> 


	function cmdLogin()
	{	
	  document.frmLogin.action = "login.jsp";
	  document.frmLogin.submit();
	}
</script>

</head>

<body bgcolor="#00CCFF" text="#000000" topmargin="35">
<table width="460" border="0" cellpadding="0" cellspacing="0" align="center">
	 <% 
	    if(  (iCommand==CMD_LOGIN) && (dologin == SessUserSession.DO_LOGIN_OK)) {
	%>
  <tr>
    <td height="112" valign="middle" width="578">
      <div align="center"><b>Login succeed , redirect to main page  </b><br>
        please <a href="masterdata/index.jsp">click here</a> is you are not redirected 
        automatically </div>
		<script language="JavaScript">
		 window.location = "homepage.jsp"
		</script>       
    </td>
  </tr>
  <tr> 
    <td height="112" valign="middle" width="578"> 
      <div align="center"> 
        <p><b><font size="4">Accounting Information System</font></b></p>
      </div><form  name="frmLogin" method="post" onsubmit="javascript:cmdLogin()">
              <input type="hidden" name="sel_top_mn" value="4">
              <input type="hidden" name="command" value="<%=CMD_LOGIN%>">
        <input type="hidden" name="login_id" class="input_text" value="">
        <input type="hidden" name="pass_wd" class="input_text">
      </form>  
    </td>
  </tr>
  
  <% } else {
  %>
  <tr> 
    <td height="112" valign="middle" width="578"> 
      <div align="center"> 
        <p><b><font size="4">Accounting Information System</font></b></p>
      </div>  
    </td>
  </tr>
  <tr> 
    <td height="225" valign="top"> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
        <tr> 
          <td height="225" width="578" valign="top" align="center"> 
            <form  name="frmLogin" method="post" onsubmit="javascript:cmdLogin()">
              <input type="hidden" name="sel_top_mn" value="4">
              <input type="hidden" name="command" value="<%=CMD_LOGIN%>">
              <table width="286" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="27" height="29" valign="top" align="left" bgcolor="#000099"> 
                    <img src="image/loginleftcn.jpg" width="12" height="10"></td>
                  <td valign="middle" colspan="2" bgcolor="#000099" align="left"> 
                    <div align="left"><font color="#FFFFFF" class="header">User 
                      Login</font></div>
                  </td>
                  <td width="23" valign="top" align="right" bgcolor="#000099"><img src="image/loginrightcn.jpg" width="12" height="10"></td>
                </tr>
                <tr bgcolor="#0099FF"> 
                  <td height="10" colspan="4" valign="top"><img src="image/spacer.gif" width="1" height="1"></td>
                </tr>
                <tr bgcolor="#0099FF"> 
                  <td height="76" colspan="4" valign="top"> 
                    <table width="100%" border="0" cellpadding="5" cellspacing="0">
                      <tr> 
                        <td width="82" height="38" valign="middle" align="right" class="text" nowrap>User 
                          name</td>
                        <td width="184" valign="middle" align="left"> 
                          <input type="text" name="login_id" class="input_text" value="">
                        </td>
                      </tr>
                      <tr> 
                        <td valign="middle" height="38" align="right" class="text">Password</td>
                        <td valign="middle" align="left"> 
                          <input type="password" name="pass_wd" class="input_text">
                        </td>
                      </tr>
						 <% 
							if(  (iCommand==CMD_LOGIN) && (dologin != SessUserSession.DO_LOGIN_OK)) {
						%>					  
                      <tr> 
                        <td valign="middle" height="38" align="right" class="text" colspan="2"> 
                          <div align="center"><font size="+1" color="#FF0000" ><%=SessUserSession.soLoginTxt[dologin]%> 
                            </font></div>
                        </td>
                      </tr>
					  <%}%>
                    </table>
                  </td>
                </tr>
                <tr bgcolor="#0099FF" align="center"> 
                  <td height="33" colspan="4" valign="top"> 
                    <input type="submit" name="Submit" value="Login" class="input_text">
                  </td>
                </tr>
                <tr bgcolor="#0099FF"> 
                  <td height="10" colspan="2" valign="bottom" align="left"> <img src="image/loginbtleft.jpg" width="12" height="10"></td>
                  <td valign="bottom" colspan="2" align="right"> <img src="image/loginbtright.jpg" width="12" height="10"></td>
                </tr>
                <tr> 
                  <td height="1"></td>
                  <td width="64"></td>
                  <td width="172"></td>
                  <td></td>
                </tr>
              </table>
              <br>
            </form>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <%}%>
  <tr> 
    <td height="20" valign="top" align="right" background="image/loginbgfooter.jpg"><img src="image/loginbitfooter.jpg" width="97" height="20" usemap="#Map" border="0"></td>
  </tr>
  <tr> 
    <td height="30" valign="top" class="footer" align="center">
      <div>Copyright &copy; 2001 Bali Information Technologies<br>
        Jl. Imam Bonjol 145, Denpasar, BALI.<br>
        Telp. +62-361-489515 ; Fax Telp. +62-361-489624<br>
        <a href="http://www.bali-it.com" class="footerLink">http://www.bali-it.com</a> 
      </div>
    </td>
  </tr>
</table>
<map name="Map"> 
  <area shape="rect" coords="53,3,96,18" href="http://www.bali-it.com" target="_blank" alt="www.bali-it.com" title="www.bali-it.com">
</map>
</body>
<% 
	    if(  (iCommand!=CMD_LOGIN) && (dologin != SessUserSession.DO_LOGIN_OK)) {
	%>
<script language="JavaScript">
 document.frmLogin.login_id.focus();
</script>
<%}%>
</html>
