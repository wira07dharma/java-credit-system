<%@ page language="java" %>
<%@ include file = "main/javainit.jsp" %>
<!-- JSP Block -->
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/aisbit.dwt" -->    
<head>   
<!-- #BeginEditable "doctitle" --> 
<title>Untitled Document</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="style/main.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="3" cellpadding="2" height="100%">
  <tr>  
    <td bgcolor="#0000FF" height="50" ID="TOPTITLE">  
      <%@ include file = "main/header.jsp" %>
    </td> 
  </tr>       
  <tr>     
    <td bgcolor="#000099" height="20" ID="MAINMENU"> 
      <%@ include file = "main/menumain.jsp" %>
    </td> 
  </tr>
  <tr>
    <td valign="top" align="left">  
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td  class="contenttitle" height="10"><!-- #BeginEditable "contenttitle" --> 
            <div align="center">Welcome to Aisbit</div>
            <!-- #EndEditable --></td>
        </tr>
        <tr>
          <td height="21"><!-- #BeginEditable "content" --> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td> 
                  <div align="center">Please select task from the main menu.</div>
                </td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td> 
                  <div align="center"><img src="image/prod_line.gif" width="185" height="151"></div>
                </td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
              </tr>
            </table>
            <!-- #EndEditable --></td>
        </tr>
      </table>
    </td>  
  </tr>  
  <tr> 
    <td bgcolor="#000099" height="29"> 
      <%@ include file = "main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
