<%@page import="java.util.Vector"%>
<%@page import="com.dimata.sedana.entity.reportsearch.ReportTabunganValue"%>
<%@page import="com.dimata.sedana.entity.reportsearch.PstRscReport"%>
<%@page import="com.dimata.sedana.entity.reportsearch.RscReport"%>
<%@page import="com.dimata.sedana.form.reportsearch.FrmRscReport"%>
<%
    RscReport rscReport = (RscReport) request.getAttribute("rscReport");
    PstRscReport pstRscReport = new PstRscReport();
    Vector data = pstRscReport.getReportTabungan(rscReport);
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
                    <td colspan="6"><center><h1>Laporan Transaksi Tabungan</h1></center></td>
                </tr>
                <tr>
                    <td><b>Nama Anggota</b></td>
                    <td>: Komang Yanti</td>
                    <td></td>
                    <td></td>
                    <td><b>Tabungan</b></td>
                    <td>: Mahasiswa</td>
                </tr>
                <tr>
                    <td><b>No Anggota</b></td>
                    <td>: 1681921801</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td><b>Alamat</b></td>
                    <td>: Jl. Kibarak Panji, Desa Panji, Singaraja</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
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
                    <% for (int i = 0; i < data.size(); i++) {%>
                    <% ReportTabunganValue reportTabunganValue = (ReportTabunganValue) data.get(i);%>
                    <tr>
                        <td width="20"><%=(i+1)%></td>
                        <td width="128"><%=reportTabunganValue.getDate()%></td>
                        <td width="80"><%=reportTabunganValue.getDebit()%></td>
                        <td width="80"><%=reportTabunganValue.getKredit()%></td>
                        <td width="105"><%=reportTabunganValue.getSaldo()%></td>
                        <td width="110"><%=reportTabunganValue.getKeterangan()%></td>
                    </tr>                    
                    <%}%>

                </tbody>
            </table>
            <br><br><br>
            <span>tanggal cetak : 17 Juni 2017  user : madearta</span>
        </div>
    </body>
</html>
