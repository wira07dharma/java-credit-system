<%@page import="java.util.Date"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%
  boolean pelunasanMacet = (FRMQueryString.requestInt(request, "macet")>0);
  String noKredit = FRMQueryString.requestString(request, "kredit");
  Vector<JadwalAngsuran> angsuran = PstJadwalAngsuran.getNoPaymentScheduleByNoKredit(noKredit);
  JSONObject obj = new JSONObject();
  JSONArray array = new JSONArray();
  double total = 0;
  double totalPokok=0;
  for(JadwalAngsuran a: angsuran) {
    double remaining = PstJadwalAngsuran.getRemainingAngsuranByJadwalAngsuranId(a.getOID());
    JSONObject o = new JSONObject();
    o.put("jenisAngsuran", a.getJenisAngsuran());
    o.put("jadwalAngsuranId", a.getOID());
    o.put("total", a.getJumlahANgsuran());
    o.put("remaining", remaining);
    o.put("date", Formater.formatDate(a.getTanggalAngsuran(), "dd MMM yyyy"));
    array.put(o);
    total+=remaining;
    totalPokok+=(a.getJenisAngsuran() == 4) ? remaining : 0;
  }
  float percentage = PstJadwalAngsuran.getPaymentPercentageByNoKredit(noKredit);
  double amountPenalty = 0;//(percentage < 50) ? totalPokok*1/100 :0;
  JSONObject penalty = new JSONObject();
  penalty.put("jenisAngsuran", pelunasanMacet ? JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_MACET : JadwalAngsuran.TIPE_ANGSURAN_PENALTI_PELUNASAN_DINI);
  penalty.put("jadwalAngsuranId", -1);
  penalty.put("total", "0");
  penalty.put("remaining", "0");
  penalty.put("date", Formater.formatDate(new Date(), "dd MMM yyyy"));
  penalty.put("penalty","true");
  penalty.put("macet", (pelunasanMacet?"true":"false"));
  array.put(penalty);
  
  obj.put("total", total+amountPenalty);
  obj.put("list", array);
%><%=obj.toString()%>