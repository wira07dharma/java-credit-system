<%@page import="com.dimata.util.Formater"%>
<%@page import="java.util.Date"%>
<%
  request.setAttribute("version", "2.1.4.3");
  request.setAttribute("build", "2018.04.07.01");
  request.setAttribute("year", Formater.formatDate(new Date(), "yyyy"));
%>