<%@page import="com.dimata.common.entity.system.PstSystemProperty"%>
<%@page import="com.dimata.sedana.entity.reportsearch.ReportKolektabilitas"%>
<%@page import="com.dimata.sedana.entity.reportsearch.PstRscReport"%>
<%@page import="com.dimata.sedana.entity.reportsearch.RscReport"%>
<%@page import="com.dimata.sedana.form.reportsearch.FrmRscReport"%>
<%
    RscReport rscReport = (RscReport) request.getAttribute("rscReport");
    PstRscReport pstRscReport = new PstRscReport();
    ReportKolektabilitas kv = pstRscReport.getReportKolektabilitas(rscReport);
    String namaNasabah = PstSystemProperty.getValueByName("SEDANA_NASABAH_NAME");
%>
<!DOCTYPE html>
<html>
  <head>
    <title>Html2Xls</title>
    <style>
      table {
        border-collapse: collapse;
      }

      table, td, th {
        border: 1px solid black;
      }
    </style>
    <%@page contentType="application/x-msexcel" pageEncoding="UTF-8" %>
  </head>
  <body style="font-family: Arial; font-size:12px;">
    <div style='position: absolute'>
      <table>
        <tr>
          <td colspan="12"><center><h1>Laporan Kolektibilitas Kredit Per <%=namaNasabah %></h1></center></td>
        </tr>
        <tr><td colspan="12"></td></tr>
        <tr>
          <td><b>Jenis Kredit</b></td>
          <td>: <%=kv.getJenisKredit() %></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td><b>Sumber Dana</b></td>
          <td>: <%=kv.getSumberDana() %></td>
        </tr>
        <tr>
          <td><b>Kelompok</b></td>
          <td>: <%=kv.getKelompok() %></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td><b>Tgl Laporan</b></td>
          <td>: <%=kv.getDateRange() %></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
          <td></td>
        </tr>
        <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
      </table>
      <table border="1">
        <thead>
          <tr>
            <th rowspan="2" width="20">No.</th>
            <th rowspan="2" width="128">Kolektibiltas</th>
            <th rowspan="2" width="80">No. Rekening</th>
            <th rowspan="2" width="80">Nama <%=namaNasabah %></th>
            <th rowspan="2" width="105">Jangka Waktu</th>
            <th colspan="2" width="110">Hari Tunggakan</th>
            <th colspan="2" width="110">Jumlah Sisa Kredit</th>
            <th colspan="3" width="110">Tunggakan</th>
          </tr>
          <tr>
            <th>Pokok</th>
            <th>Bunga</th>
            <th>Pokok</th>
            <th>Bunga</th>
            <th>Pokok</th>
            <th>Bunga</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          <% int i = 0; %>
          <% for(ReportKolektabilitas.ReportRow rr : kv.getReports()) { i++; %>
          <tr>
            <td><%=i%></td>
            <td><%=rr.getKolektibilitas() %></td>
            <td><%=rr.getNoRekening() %></td>
            <td><%=rr.getNamaNasabah() %></td>
            <td><%=rr.getJangkaWaktu() %></td>
            <td><%=rr.getHariTunggakanPokok() %></td>
            <td><%=rr.getHariTunggakanBunga() %></td>
            <td><%=rr.getKreditPokok() %></td>
            <td><%=rr.getKreditBunga() %></td>
            <td><%=rr.getTuggakanPokok() %></td>
            <td><%=rr.getTunggakanBunga() %></td>
            <td><%=rr.getTotal() %></td>
          </tr>
          <% } %>
          <tr>
            <td></td>
            <td><b><%=kv.getTotalText() %></b></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td><b><%=kv.getTotalKreditPokok() %></b></td>
            <td><b><%=kv.getTotalKreditBunga() %></b></td>
            <td><b><%=kv.getTotalTunggakanPokok() %></b></td>
            <td><b><%=kv.getTotalTunggakanBunga() %></b></td>
            <td><b><%=kv.getTotalTunggakanTotal() %></b></td>
          </tr>
        </tbody>
      </table>
      <table>
        <tr><td></td></tr>
        <tr><td></td></tr>
        <tr>
          <td>
            Keterangan : K1 = <i>Lancar</i> K2= <i>Dalam Perhatian Khusus ( < 90 hari )</i> K3 = <i>Kurang Lancar ( < 120 hari )</i><br>       Jangka waktu : <i>bulan</i>
          </td>
        </tr>
      </table>
    </div>
  </body>
</html>
