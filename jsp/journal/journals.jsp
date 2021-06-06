<%@ page language="java" %>
<%@ page import="com.dimata.qdep.form.*" %>
<%
    int iEditJournal = FRMQueryString.requestInt(request, "edit_journal");
%>
<html>
<head>
<title>Accounting Information System Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<frameset rows="1,*" frameborder="NO" border="0" framespacing="0"> 
  <frame name="topFrame" scrolling="NO" noresize src="jaccount.jsp" width="100%">
  <frame name="mainFrame" scrolling="YES" noresize src="jsearch.jsp?edit_journal=<%=iEditJournal%>" width="100%">
</frameset>
<noframes> 
<body bgcolor="#FFFFFF" text="#000000">
</body>
</noframes> 
</html>
