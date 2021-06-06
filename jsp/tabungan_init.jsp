<%-- 
    Document   : tabungan_init
    Created on : Apr 6, 2018, 3:16:42 PM
    Author     : Regen
--%>

<%@page import="com.dimata.sedana.entity.tabungan.PstDataTabungan"%>
<%@page import="java.util.Date"%>
<%@page import="com.dimata.sedana.entity.tabungan.DataTabungan"%>
<%@page import="com.dimata.common.entity.contact.PstContactList"%>
<%@page import="com.dimata.common.entity.contact.ContactList"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstJenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.tabungan.JenisSimpanan"%>
<%@page import="com.dimata.sedana.entity.masterdata.PstMasterTabungan"%>
<%@page import="com.dimata.sedana.entity.masterdata.MasterTabungan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.PstAssignTabungan"%>
<%@page import="com.dimata.sedana.entity.assigntabungan.AssignTabungan"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan"%>
<%@page import="com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Tabungan Initializer</title>
    <style>* {font-family: monospace;}</style>
  </head>
  <body>
    <%
      Vector<AssignContactTabungan> act = PstAssignContactTabungan.list(0, 0, PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_ASSIGN_TABUNGAN_ID] + " NOT IN (SELECT `ASSIGN_TABUNGAN_ID` FROM `aiso_data_tabungan`)", "");
    %>
    <h1>Initializing Tabungan . . . (<%=act.size()%> data found).</h1>
    <% if (act.size()>0) { %>
    <table border="0">
      <thead>
        <tr>
          <th style="text-align: left; padding:5px; padding-right: 10px;">Nama</th>
          <th style="text-align: left; padding:5px; padding-right: 10px;">Jenis Simpanan</th>
          <th style="text-align: left; padding:5px; padding-right: 10px;">Status</th>
        </tr>
        <tr><th colspan="2"></th></tr>
      </thead>
      <tbody>
        <%
          for(AssignContactTabungan c: act) {
            MasterTabungan tab = PstMasterTabungan.fetchExc(c.getMasterTabunganId());
            if(tab.getOID()!=0) {
              Vector<AssignTabungan> at = PstAssignTabungan.list(0, 0, PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN]+"="+tab.getOID(), "");
              ContactList member = PstContactList.fetchExc(c.getContactId());
              for(AssignTabungan a: at) {
                JenisSimpanan simpanan = PstJenisSimpanan.fetchExc(a.getIdJenisSimpanan());
                DataTabungan dt = new DataTabungan();
                dt.setIdAnggota(c.getContactId());
                dt.setIdJenisSimpanan(a.getIdJenisSimpanan());
                dt.setTanggal(new Date());
                dt.setStatus(1);
                dt.setKodeTabungan("");
                dt.setAssignTabunganId(c.getOID());
                long oid = PstDataTabungan.insertExc(dt);
        %>
        <tr>
          <td style="padding:5px;"><%=member.getPersonName() %></td>
          <td style="padding:5px;"><%=simpanan.getNamaSimpanan() %></td>
          <td style="padding:5px;"><%=(oid>0)?"OK. id : "+oid:"NOT OK" %></td>
        </tr>
        <% }} else {%>
        <tr>
          <td colspan="3">Error occured: Master tabungan not found.</td>
        </tr>
        <%}}%>
      </tbody>
    </table>
    <% } %>
    <h5>End of process.</h5>
  </body>
</html>
