<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstCashTeller"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%
  long jenisSimpanan = FRMQueryString.requestLong(request, "ID_JENIS_SIMPANAN");
  long assignTabungan = FRMQueryString.requestLong(request, "ASSIGN_TABUNGAN_ID");
  int n = PstDataTabungan.getCount("`ID_JENIS_SIMPANAN`="+jenisSimpanan+" AND `ASSIGN_TABUNGAN_ID`="+assignTabungan);
  JSONObject obj = new JSONObject();
  obj.put("registered", n>0);
%><%=obj.toString()%> 