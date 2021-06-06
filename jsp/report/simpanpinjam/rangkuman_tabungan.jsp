<%@page import="com.dimata.sedana.entity.reportsearch.PstRscReport"%>
<%@page import="com.dimata.sedana.entity.reportsearch.RscReport"%>
<%@page import="com.dimata.sedana.form.reportsearch.FrmRscReport"%>
<%
    RscReport rscReport = (RscReport) request.getAttribute("rscReport");
    PstRscReport pstRscReport = new PstRscReport();
    pstRscReport.getReportTabungan(rscReport);
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
          <td colspan="6"><center><h1>Rangkuman Transaksi Tabungan</h1></center></td>
        </tr>
        <tr>
          <td><b>Tanggal</b></td>
          <td>: 2 Juni 2017 s/d 14 Juni 2017</td>
          <td></td>
          <td></td>
          <td><b>Tabungan</b></td>
          <td>: Mahasiswa</td>
        </tr>
        <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>
      </table>
      <table border="1">
        <thead>
          <tr>
            <td width="20">No.</td>
            <td width="128">Tanggal / Jam</td>
            <td width="80">Debit</td>
            <td width="80">Kredit</td>
            <td width="105">Saldo</td>
            <td width="110">Keterangan</td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td width="20">1</td>
            <td width="128">2 Juni 2017 08:00</td>
            <td width="80"></td>
            <td width="80">5.000.000,0</td>
            <td width="105">5.000.000,0</td>
            <td width="110">Saldo per tgl 17 Juli 2017</td>
          </tr>
          <tr>
            <td width="20">2</td>
            <td width="128">2 Juni 2017 14:00</td>
            <td width="80"></td>
            <td width="80">200.000,00</td>
            <td width="105">5.200.000,00</td>
            <td width="110">Setor</td>
          </tr>
          <tr>
            <td width="20">3</td>
            <td width="128">14 Juni 2017 10:00</td>
            <td width="80">300.000,00</td>
            <td width="80"></td>
            <td width="105">4.900.000,00</td>
            <td width="110">Tarik</td>
          </tr>
          <tr>
            <td width="20"></td>
            <td width="128"><b>TOTAL</b></td>
            <td width="80">300.000,00</td>
            <td width="80">200.000,00</td>
            <td width="105">4.900.000,00</td>
            <td width="110"></td>
          </tr>
        </tbody>
      </table>
      <br><br><br>
      <span>tanggal cetak : 17 Juni 2017  user : madearta</span>
    </div>
  </body>
</html>
