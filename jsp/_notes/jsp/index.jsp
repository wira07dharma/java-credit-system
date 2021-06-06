<%@ page language="java" %> 
<%@ include file="main/javainit.jsp"%> 

<%@page contentType="text/html"%>
<html>
<head><title>JSP Page</title></head>
<body>

<%-- <jsp:useBean id="beanInstanceName" scope="session" class="package.class" /> --%>
<%-- <jsp:getProperty name="beanInstanceName"  property="propertyName" /> --%>

<script language="javascript">
   window.location="<%=approot%>/login.jsp";
</script>

</body>
</html>
