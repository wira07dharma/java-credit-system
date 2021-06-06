<%-- 
    Document   : generate_payment_transfer_pengendapan
    Created on : Mar 20, 2019, 11:02:19 AM
    Author     : Dimata 007
--%>

<%@page import="com.dimata.sedana.entity.kredit.Pinjaman"%>
<%@page import="com.dimata.sedana.entity.kredit.PstPinjaman"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstDetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.DetailTransaksi"%>
<%@page import="com.dimata.sedana.entity.kredit.AngsuranPayment"%>
<%@page import="com.dimata.common.entity.payment.PstPaymentSystem"%>
<%@page import="com.dimata.common.entity.payment.PaymentSystem"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksiPayment"%>
<%@page import="com.dimata.sedana.entity.tabungan.TransaksiPayment"%>
<%@page import="java.util.Vector"%>
<%@page import="com.dimata.sedana.entity.tabungan.PstTransaksi"%>
<%@page import="com.dimata.sedana.entity.tabungan.Transaksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>

        <%//
            long idPaymentSystem = 0;
            Vector<PaymentSystem> listPS = PstPaymentSystem.list(0, 1, PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_TYPE] + " = " + AngsuranPayment.TIPE_PAYMENT_CASH, null);
            if (listPS.isEmpty()) {
                out.print("OID payment system cash tidak ditemukan!");
            } else {
                idPaymentSystem = listPS.get(0).getOID();
            }
            if (idPaymentSystem > 0) {
                //CARI DATA TRANSAKSI PENARIKAN/SETORAN PENGENDAPAN
                String where = PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI] + " LIKE '" + Transaksi.KODE_TRANSAKSI_TABUNGAN_SETORAN_PENGENDAPAN_KREDIT + "%'"
                        + " OR " + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI] + " LIKE '" + Transaksi.KODE_TRANSAKSI_TABUNGAN_PENARIKAN_PENGENDAPAN_KREDIT + "%'"
                        + "";
                Vector<Transaksi> listTransaksi = PstTransaksi.list(0, 0, where, PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]);
        %>
        <table style="border-color: gray; border-style: solid; border-width: thin">
            <tr>
                <th>No.</th>
                <th>No. Kredit</th>
                <th>Status Kredit</th>
                <th>No. Transaksi</th>
                <th>Nilai Pengendapan</th>
                <th>Pesan</th>
            </tr>

            <%//
                int i = 0;
                for (Transaksi t : listTransaksi) {
                    //CEK APAKAH SUDAH ADA DATA PAYMENT
                    Vector<TransaksiPayment> listPayment = PstTransaksiPayment.list(0, 0, PstTransaksiPayment.fieldNames[PstTransaksiPayment.FLD_TRANSAKSI_ID] + " = " + t.getOID(), "");
                    if (listPayment.isEmpty()) {
                        String msg = "";
                        i++;
                        Pinjaman p = new Pinjaman();
                        String nomorKredit = "-";
                        String statusKredit = "-";
                        try {
                            p = PstPinjaman.fetchExc(t.getPinjamanId());
                            nomorKredit = p.getNoKredit();
                            statusKredit = Pinjaman.getStatusDocTitle(p.getStatusPinjaman());
                        } catch (Exception e) {
                            msg += e.getMessage();
                        }
                        //HITUNG NILAI TRANSAKSI
                        Vector<DetailTransaksi> listDetail = PstDetailTransaksi.list(0, 0, PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = " + t.getOID(), "");
                        double pengendapan = 0;
                        for (DetailTransaksi dt : listDetail) {
                            pengendapan += dt.getDebet() + dt.getKredit();
                        }
                        //GENERATE DATA PAYMENT
                        try {
                            TransaksiPayment tp = new TransaksiPayment();
                            tp.setPaymentSystemId(idPaymentSystem);
                            tp.setJumlah(pengendapan);
                            tp.setTransaksiId(t.getOID());
                            PstTransaksiPayment.insertExc(tp);
                        } catch (Exception e) {
                            msg += (msg.isEmpty() ? "" : "</br>") + e.getMessage();
                        }
            %>
            <tr>
                <td><%= i%>.</td>
                <td><%= nomorKredit%></td>
                <td><%= statusKredit%></td>
                <td><%= t.getKodeBuktiTransaksi()%></td>
                <td <%= (pengendapan <= 0) ? "style='color:red'" : ""%> ><%= String.format("%,.2f", pengendapan)%></td>
                <td><%= msg%></td>
            </tr>
            <%
                    }
                }
                if (i == 0) {
                    out.print("<tr><td colspan='6' style='text-align: center'>Tidak ada penambahan data payment</td></tr>");
                }
            %>
        </table>
        <%
            }
        %>
    </body>
</html>
