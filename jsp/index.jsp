<%@page import="com.dimata.common.entity.license.LicenseProduct"%>
<%@page import="com.dimata.aiso.entity.masterdata.PstCompany"%>
<%@ page language="java" %> 


<%@page contentType="text/html"%>
<html>
<head><title>Accounting Information System Online</title></head>
<body>
        <%
            String txtChiperText = "";
            try {
                txtChiperText = PstCompany.getLicenseKey();
            } catch (Exception e) {
            }
            boolean isValidKey = true;//LicenseProduct.btDekripActionPerformed(txtChiperText);
        %>
        <script language="javascript">
            <%if (isValidKey) {%>
                window.location = "login.jsp";
            <%} else {%>
                window.location = "license.jsp";
            <%}%>
        </script>
    </body>
</html>
