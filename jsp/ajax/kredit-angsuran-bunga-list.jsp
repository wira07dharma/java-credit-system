<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.dimata.util.Formater"%>
<%@page import="com.dimata.sedana.session.json.JSONArray"%>
<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page import="com.dimata.sedana.entity.kredit.PstJadwalAngsuran"%>
<%@page import="com.dimata.sedana.entity.kredit.JadwalAngsuran"%>
<%
    String noKredit = FRMQueryString.requestString(request, "kredit");
    Vector<JadwalAngsuran> angsuran = PstJadwalAngsuran.getNoPaymentScheduleByNoKredit(noKredit, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + "=" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
    JSONObject obj = new JSONObject();
    JSONArray array = new JSONArray();
    double total = 0;
    double totalPokok = 0;
    for (JadwalAngsuran a : angsuran) {
        //format angka jadi 2 digit desimal
        DecimalFormat df = new DecimalFormat("#.##");
        double newJumlah = Double.valueOf(df.format(a.getJumlahANgsuran()));
        double remaining = PstJadwalAngsuran.getRemainingAngsuranByJadwalAngsuranId(a.getOID());
        double newRemaining = Double.valueOf(df.format(remaining));

        JSONObject o = new JSONObject();
        o.put("jenisAngsuran", a.getJenisAngsuran());
        o.put("jadwalAngsuranId", a.getOID());
        o.put("total", newJumlah);
        o.put("remaining", newRemaining);
        o.put("date", Formater.formatDate(a.getTanggalAngsuran(), "dd MMM yyyy"));
        array.put(o);
        total += newRemaining;
        totalPokok += (a.getJenisAngsuran() == 4) ? newRemaining : 0;
    }

    obj.put("total", total);
    obj.put("list", array);
%><%=obj.toString()%> 