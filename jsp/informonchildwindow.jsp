 
<%@ page language="java" %>
<%@ include file = "main/javainit.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dimata.qdep.system.*" %>
<%@ page import="com.dimata.aiso.session.admin.*" %>
<%@ page import="com.dimata.aiso.entity.admin.*" %>

<%

    
    if(isLoggedIn==false){
        %>
                <script language="javascript">
                        //window.location="index.jsp";
                </script>			
        <%			

    }
%>
<%
	String sic = "";
	int infCode = 0;
	String msgAccess = "";
	try{
	    sic=(request.getParameter("ic")==null) ? "0" : request.getParameter("ic");
		infCode = Integer.parseInt(sic);
	}catch(Exception e){ 
		infCode = 0;
	}
%>
<html><!-- #BeginTemplate "/Templates/main-menu-left-frames.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" --> 
<title>Status Window</title>  
<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" -->
<SCRIPT language=JavaScript>
function closeThisWindow(){
    window.close();
}
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
<link rel="stylesheet" href="style/main.css" type="text/css">
<link rel="StyleSheet" href="dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->User Attention !<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->


<link rel="stylesheet" href="style/main.css" type="text/css">

<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%" bgcolor="#FFFFFF">
  <tr> 
    <td width="88%" valign="top" align="left">
	<table width="100%" border="0" cellpadding="1" cellspacing="0" bgcolor="#99CCCC">
		<tr>
		<td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td> 
            <table width="100%" border="0" cellspacing="0" class="list"  >
              <tr> 
                <td width="595" height="148"  valign="top" > 
                  <table width="100%">
                    <tr> 
                      <td>&nbsp; 
                        <% 				
						switch(infCode) {
							case I_SystemInfo.HAVE_NOPRIV : 
								msgAccess  = "You have no privilege to access the modul or data";//I_SystemInfo.textInfo[infCode];
								break;

							case I_SystemInfo.NOT_LOGIN : 
								msgAccess  = "Your user session has been expired.<br>"+
                                             "&nbsp;&nbsp;Please click on menu \"Log Out\" and then click button \"Login\"";//I_SystemInfo.textInfo[infCode];
								break;
								
							default:
								%>
                        <script language="javascript">
										//window.location="<%= approot %>/index.jsp"
									</script>
                        <%																
						}
						
					%>
                      </td>
                    </tr>
                    <tr class="msgaccess"> 
                      <td>&nbsp; <%= msgAccess %> </td>
                    </tr>
                    <tr class="msgaccess"> 
                        <td>&nbsp;<a href="javascript:closeThisWindow()">Close this window</a></td> 
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
	  </table>
    </td>
  </tr>
</table>
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
      <%@ include file = "main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
