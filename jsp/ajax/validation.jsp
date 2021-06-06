<%@page import="com.dimata.aiso.entity.masterdata.anggota.PstAnggota"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.PstAssignSumberDanaJenisKredit"%>
<%@page import="com.dimata.sedana.session.json.JSONObject"%>
<%@page import="com.sun.org.apache.regexp.internal.StreamCharacterIterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.dimata.qdep.form.FRMQueryString"%>
<%@page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
  boolean validDelJenisKredit(long id){
    int assign = PstAssignSumberDanaJenisKredit.getCount(PstAssignSumberDanaJenisKredit.fieldNames[PstAssignSumberDanaJenisKredit.FLD_TYPE_KREDIT_ID]+"="+id);
    int pinjaman = PstPinjaman.getCount(PstPinjaman.fieldNames[PstPinjaman.FLD_TIPE_KREDIT_ID]+"="+id);
    return assign<=0&&pinjaman<=0;
  };
  boolean validDelJenisSimpanan(long id){
    int dataTabungan = PstDataTabungan.getCount(PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN]+"="+id);
    return dataTabungan<=0;
  };
  boolean validUniqueKTP(String idCard, long oidObject){
    int contactList = PstAnggota.getCount(PstAnggota.fieldNames[PstAnggota.FLD_ID_CARD]+"="+idCard+" AND "+PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]+"<>"+oidObject);
    return contactList<=0;
  };
%>
<%
  
  JSONObject o = new JSONObject();
  long oid = FRMQueryString.requestLong(request, "id");
  long oidAnggota = FRMQueryString.requestLong(request, "oid_anggota");
  HashMap<String, Integer> data = new HashMap<String, Integer>();
  String dataFor = FRMQueryString.requestString(request, "dataFor");
  o.put("dataFor", dataFor);
  
  data.put("validateDelJenisKredit", 0);
  data.put("validateDelJenisSimpanan", 1);
  data.put("validateUniqueKTP", 2);
  
  if(dataFor != null && !dataFor.equals("")) {
    switch(data.get(dataFor)){
      case 0:
        o.put("status", validDelJenisKredit(oid));
        break;
      case 1:
        o.put("status", validDelJenisSimpanan(oid));
        break;
      case 2:
        String ktp = FRMQueryString.requestString(request, "id");
        o.put("status", validUniqueKTP(ktp, oidAnggota));
        break;
    }
  } else {
    o.put("status", false);
  }


%><%=o.toString()%>