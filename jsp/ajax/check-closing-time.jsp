<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%
  long oid = FRMQueryString.requestLong(request, "id");
  boolean closing = PstCashTeller.isClosingTime(oid);
  JSONObject obj = new JSONObject();
  obj.put("isClosingTime", closing);
%><%=obj.toString()%> 
