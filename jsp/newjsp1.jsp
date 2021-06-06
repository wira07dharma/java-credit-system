<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.session.SessAutoCode"%>
<%

  SessAutoCode s = new SessAutoCode();
  s.setDbFieldToCheck(PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]);
  s.setDb(PstPinjaman.TBL_PINJAMAN);
  s.setSysProp("CODE_CREDIT");
  out.print(s.generate());

%>
