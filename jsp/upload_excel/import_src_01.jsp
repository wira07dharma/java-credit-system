<%response.setHeader("Expires", "Mon, 06 Jan 1990 00:00:01 GMT");%>
<%response.setHeader("Pragma", "no-cache");%>
<%response.setHeader("Cache-Control", "nocache");%>
<%@ page language="java" %>
<%
	private static final String strDataUpload[][] = {
		{"Perkiraan","Aktiva Tetap","Kontak","Hutang","Piutang"},
		{"Chart of Account","Fixed Asset","Contact","Account Payable","Account Receivable"}
	};
%>
<% int  appObjCode = 1; //com.dimata.posbo.entity.admin.AppObjInfo.composeObjCode(AppObjInfo.G1_PESERTA, AppObjInfo.G2_PESERTA, AppObjInfo.OBJ_D_IMPORT_DATA_EXCEL); %>
<%@ include file = "../../main/checkuser1.jsp" %>
<!-- JSP Block -->
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/main-menu-left.dwt" --><!-- DW6 -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>SEDANA</title>

<!-- #EndEditable -->
<!-- #BeginEditable "headerscript" --> <!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
<link rel="StyleSheet" href="../dtree/dtree.css" type="text/css" />
	<script type="text/javascript" src="../dtree/dtree.js"></script>
</head> 

<body class="bodystyle" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">    
<table width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
  <tr> 
    <td class="leftbar" height="58" ID="TOPTITLE" rowspan="2" valign="top"> 
      <table width="100%" border="0" cellpadding="1" cellspacing="2">
        <tr> 
          <td><img src="../images/company120.jpg" width="120" height="140"></td>
        </tr>
        <tr> 
          <td bgcolor="#CCCC66" height="18"> 
            <table width="100%" border="0" bgcolor="#FFFFFF" height="100%">
              <tr> 
                <td> 
                  <%@ include file = "../main/menuleft.jsp" %>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
    <td class="headerstyle" height="5" ID="TOPTITLE" width="91%" >
    </td>
  </tr>
  <tr> 
    <td width="91%" valign="top" align="left" bgcolor="#99CCCC"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
        <tr> 
          <td height="20" class="contenttitle" >&nbsp;<!-- #BeginEditable "contenttitle" -->{contenttitle}<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td valign="top"><!-- #BeginEditable "content" -->
				<form name="frmimport" method="post" action="import_process.jsp" enctype="multipart/form-data">
				    <table width="100%" border="0">
                      <tr>
                        <td><i>Choose file (.xls) to export to SEDANA</i></td>
                      </tr>
                      <tr>
                        <td>
                          <input type="file" name="file" size="60" value="">
						  <select name="col_sheet">
						  	<%
								for(int i = 0; i < strDataUpload[SESS_LANGUAGE].length; i++){
							%>
						    	<option value="<%=i%>" selected><%=strDataUpload[SESS_LANGUAGE][i]%></option>
						    <%
								}
							%>
						</select>
                          <input type="button" name="Submit" value=" Submit ">
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
    <td colspan="3" height="20" class="footer"> 
      <%@ include file = "../main/footer.jsp" %>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
