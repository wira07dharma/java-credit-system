/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.ajax.transaksi;

import com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan;
import com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisSimpanan;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.form.FRMQueryString;
import com.dimata.sedana.ajax.tabungan.AjaxTabungan;
import com.dimata.sedana.ajax.transaksi.extensible.HTTPTabungan;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan;
import com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan;
import com.dimata.sedana.entity.masterdata.PstTingkatanBunga;
import com.dimata.sedana.entity.tabungan.DataTabungan;
import com.dimata.sedana.entity.tabungan.DetailTransaksi;
import com.dimata.sedana.entity.tabungan.JenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstDataTabungan;
import com.dimata.sedana.entity.tabungan.PstDetailTransaksi;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.util.Formater;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Regen
 */
public class CountBunga extends HTTPTabungan {

    private static double ANNUAL = 365;
    private static final String uri = "/masterdata/";

    @Override
    protected String[] page() {
        String[] r = {
            uri + "services.jsp"
        };

        return r;
    }

    @Override
    protected void executeMethod() {
        switch (this.dataFor) {
            default:
                this.proceed();
        }
    }

    // -- --
    protected void proceed() {
        int year = FRMQueryString.requestInt(req, "year");
        int month = FRMQueryString.requestInt(req, "month");
        boolean saveZero = FRMQueryString.requestBoolean(req, "include");

        //SET TANGGAL PENGECEKAN BUNGA TABUNGAN
        Date tglPencatatanBunga = Formater.formatDate(year + "-" + month + "-" + "01", "yyyy-MM-dd");

        String msg = "";
        int errorBunga = 0;

        //CARI DATA SIMPANAN YG AKAN DIHITUNG BUNGA
        String whereSimpanan = PstDataTabungan.fieldNames[PstDataTabungan.FLD_STATUS] + " = '" + I_Sedana.STATUS_AKTIF + "'"
                + " AND DATE(" + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL] + ") < '" + Formater.formatDate(tglPencatatanBunga, "yyyy-MM-01") + "'"
                + " AND (" + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP] + " IS NULL "
                + " OR DATE(" + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP] + ") >= '" + Formater.formatDate(tglPencatatanBunga, "yyyy-MM-dd") + "'"
                + ")";
        
        Vector<DataTabungan> listTabungan = PstDataTabungan.list(0, 0, whereSimpanan, PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL] + " DESC");
        if (listTabungan.isEmpty()) {
            msg += "Tidak ada data tabungan yang ditemukan. ";
            printErrorMessage("Tidak ada data tabungan yang ditemukan.");
            errorBunga += 1;
        }

        //CARI JENIS TRANSAKSI PENAMBAHAN BUNGA TABUNGAN
        long oidJenisTransaksi = 0;
        if (errorBunga == 0) {
            String where = PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TIPE_ARUS_KAS] + " = " + Transaksi.TIPE_ARUS_KAS_BERKURANG + " AND "
                    + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_PROSEDUR] + " = " + Transaksi.TIPE_PROSEDUR_BY_SYSTEM + " AND "
                    + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_PROSEDURE_UNTUK] + " = " + Transaksi.TUJUAN_PROSEDUR_TABUNGAN + " AND "
                    + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_STATUS_AKTIF] + " = " + Transaksi.STATUS_JENIS_TRANSAKSI_AKTIF + " AND "
                    + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_TYPE_TRANSAKSI] + " = " + Transaksi.TIPE_TRANSAKSI_PENGELUARAN;
            Vector<JenisTransaksi> jenisTransaksi = PstJenisTransaksi.list(0, 0, where, "");
            if (jenisTransaksi.isEmpty()) {
                msg += "Jenis transaksi penambahan bunga tabungan tidak ditemukan. ";
                printErrorMessage("Jenis transaksi penambahan bunga tabungan tidak ditemukan.");
                errorBunga += 1;
            } else {
                oidJenisTransaksi = jenisTransaksi.get(0).getOID();
            }
        }
        
        //CEK APAKAH ADA TRANSAKSI BUNGA TABUNGAN SEBELUMNYA YG SUDAH DI POSTED
        int posted = PstTransaksi.countTransaksiBungaTabunganPosted(tglPencatatanBunga);
        if (posted > 0) {
            msg += "Transaksi bunga tabungan di periode " + Formater.formatDate(tglPencatatanBunga, "MMMM yyyy") + " sudah di posted. ";
            errorBunga += 1;
        }

        //HAPUS TRANSAKSI BUNGA TABUNGAN SEBELUMNYA JIKA BELUM DI POSTED
        if (errorBunga == 0) {
            ArrayList<Transaksi> listBunga = PstTransaksi.getTransaksiBungaTabunganClosed(tglPencatatanBunga);
            for (Transaksi t : listBunga) {
                AjaxTabungan at = new AjaxTabungan();
                at.clearMessage();
                at.deleteTransaction(t.getOID(), userOID, username);
                if (at.getError() > 0) {
                    errorBunga++;
                    printErrorMessage(at.getMessage());
                    break;
                }
            }
        }

        Transaksi trx = new Transaksi();
        int generated = 0;
        if (errorBunga == 0) {
            String pembulatanBunga = PstSystemProperty.getValueByName("GUNAKAN_PEMBULATAN_BUNGA_TABUNGAN");
            for (DataTabungan dt : listTabungan) {
                if (dt.getOID() == 576462296714083344L) {
                    System.out.println("");//buat ngecek pas debug
                }
                try {
                    AssignContactTabungan assign = PstAssignContactTabungan.fetchExc(dt.getAssignTabunganId());

                    JenisSimpanan j = PstJenisSimpanan.fetchExc(dt.getIdJenisSimpanan());
                    boolean isGenerate = isGenerateBungaSaldoTerakhir(dt.getOID(), oidJenisTransaksi, tglPencatatanBunga);
                    if (j.getJenisBunga() == I_Sedana.BUNGA_SALDO_TERAKHIR && !isGenerate) {
                        continue;
                    }
                    double calculatedBunga = 0;
                    ANNUAL = j.getBasisHariBunga();

                    //TGL PENCARIAN SALDO MUNDUR 1 BULAN SEBELUM TGL PENCATATAN BUNGA
                    Calendar calPencarianSaldo = Calendar.getInstance();
                    calPencarianSaldo.setTime(tglPencatatanBunga);
                    calPencarianSaldo.add(Calendar.MONTH, -1);
                    Date tglPencarianSaldo = calPencarianSaldo.getTime();

                    switch (j.getJenisBunga()) {
                        case I_Sedana.BUNGA_SALDO_HARIAN:
                            calculatedBunga = getBungaMetodeHarian(dt.getOID(), tglPencarianSaldo);
                            break;
                        case I_Sedana.BUNGA_SALDO_RERATA_HARIAN:
                            calculatedBunga = getBungaMetodeRerata(dt.getOID(), tglPencarianSaldo);
                            break;
                        case I_Sedana.BUNGA_SALDO_TERENDAH:
                            calculatedBunga = getBungaMetodeSaldoTerendah(dt.getOID(), tglPencarianSaldo);
                            break;
                        case I_Sedana.BUNGA_SALDO_DEPOSITO:
                            calculatedBunga = getBungaDeposito(dt.getOID());
                            break;
                        case I_Sedana.BUNGA_SALDO_BUNGA_BERBUNGA:
                            calculatedBunga = getBungaBerbunga(dt.getOID(), oidJenisTransaksi, tglPencarianSaldo);
                            break;
                        case I_Sedana.BUNGA_SALDO_TERAKHIR:
                            calculatedBunga = getBungaSaldoTerakhir(dt.getOID(), tglPencarianSaldo);
                            break;
                        case I_Sedana.BUNGA_SALDO_PERTAMA:
                            calculatedBunga = getBungaSaldoPertama(dt.getOID(), tglPencarianSaldo);
                            break;
                    }

                    if (pembulatanBunga.equals("1")) {
                        calculatedBunga = Math.round(calculatedBunga);
                    }

                    if (calculatedBunga <= 0 && !saveZero) {
                        printErrorMessage("Bunga untuk nomor tabungan " + assign.getNoTabungan() + " = " + calculatedBunga);
                        continue;
                    }

                    int useCaseType = I_Sedana.USECASE_TYPE_TABUNGAN_BUNGA_PENCATATAN;
                    String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_TABUNGAN_PENCATATAN_BUNGA, useCaseType, tglPencatatanBunga);
                    
                    trx.setIdAnggota(dt.getIdAnggota());
                    trx.setTanggalTransaksi(tglPencatatanBunga);
                    trx.setTellerShiftId(this.TelerId);
                    trx.setUsecaseType(useCaseType);
                    trx.setKeterangan(I_Sedana.USECASE_TYPE_TITLE.get(useCaseType) + ". Periode : " + Formater.formatDate(tglPencatatanBunga, "MMMM yyyy") + ". Bunga untuk nomor tabungan : " + assign.getNoTabungan());
                    trx.setKodeBuktiTransaksi(nomorTransaksi);
                    trx.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                    PstTransaksi.insertExc(trx);

                    DetailTransaksi dtrx = new DetailTransaksi();
                    //>>added by dewok 20181102 for alokasi bunga tabungan
                    long idAlokasiBunga = (dt.getIdAlokasiBunga() == 0) ? dt.getOID() : dt.getIdAlokasiBunga();
                    //<<
                    dtrx.setIdSimpanan(idAlokasiBunga);
                    dtrx.setJenisTransaksiId(oidJenisTransaksi);
                    dtrx.setTransaksiId(trx.getOID());
                    dtrx.setDetailInfo("Bunga untuk nomor tabungan : " + assign.getNoTabungan());
                    dtrx.setKredit(calculatedBunga);
                    PstDetailTransaksi.insertExc(dtrx);
                    
                    generated++;
                    System.out.println(generated + " : " + trx.getOID() + " | " + trx.getKodeBuktiTransaksi() + " | " + assign.getNoTabungan());

                } catch (DBException ex) {
                    printErrorMessage(ex.getMessage());
                    msg += "Error: " + ex.getMessage() + " ";
                }
            }
        }
        
        if (errorBunga == 0) {
            String success = (generated == listTabungan.size()) ? "" + generated : "" + generated + " dari " + listTabungan.size();
            msg += generated > 0 ? "" + success + " tabungan berhasil mendapatkan bunga." : "Tidak ada tabungan yang mendapatkan bunga.";
        }
        
        this.req.setAttribute("message", msg.isEmpty() ? "Perhitungan bunga selesai." : msg);
        this.req.setAttribute("trx", trx);
    }

    public void printErrorMessage(String errorMessage) {
        System.out.println("");
        System.out.println("========================================>>> WARNING <<<========================================");
        System.out.println("");
        System.out.println("MESSAGE : " + errorMessage);
        System.out.println("");
        System.out.println("========================================<<< * * * * >>>========================================");
        System.out.println("");
    }

    // -- Perhitungan bunga --
    private double getBungaMetodeHarian(long idSimpanan, Date upto) {
        double interestRate = 0;
        double bunga = 0;
        Calendar c = Calendar.getInstance();
        c.setTime(upto);
        int month = 1 + c.get(Calendar.MONTH);
        int year = c.get(Calendar.YEAR);

        HashMap<Integer, Double> allSaldo = PstDetailTransaksi.getSaldoSummaryPerDayOfTheMonth(idSimpanan, month, year);
        double dailyBalance = 0;
        if (allSaldo.isEmpty()) {
            return 0;
        }
        for (int i = 1; i <= c.getActualMaximum(Calendar.DAY_OF_MONTH); i++) {
            if (allSaldo.get(i) == null) {
                continue;
            }
            Double iBalance = allSaldo.get(i);
            interestRate = PstTingkatanBunga.getBungaBySaldo(iBalance, idSimpanan);
            dailyBalance = (iBalance != null) ? dailyBalance + iBalance : dailyBalance;
            bunga += (dailyBalance * (interestRate / 100) / ANNUAL);
        }
        return (bunga > 0 ? bunga : 0);
    }

    private double getBungaMetodeRerata(long idSimpanan, Date upto) {
        double interestRate = 0;
        double bunga = 0;

        Calendar c = Calendar.getInstance();
        c.setTime(upto);
        int maxDate = c.getActualMaximum(Calendar.DAY_OF_MONTH);
        int month = 1 + c.get(Calendar.MONTH);
        int year = c.get(Calendar.YEAR);

        Calendar now = Calendar.getInstance();
        now.setTime(upto);

        HashMap<Integer, Double> allSaldo = PstDetailTransaksi.getSaldoSummaryPerDayOfTheMonth(idSimpanan, month, year);
        double dailyBalance = 0;
        double sumBalance = 0;

        for (int i = 1; i <= maxDate; i++) {
            Double iBalance = allSaldo.get(i);
            dailyBalance = (iBalance != null) ? iBalance : dailyBalance;
            sumBalance += dailyBalance;
        }

        interestRate = PstTingkatanBunga.getBungaBySaldo(sumBalance, idSimpanan);
        bunga = (sumBalance / maxDate) * interestRate / 100 * maxDate / ANNUAL;
        return (bunga > 0 ? bunga : 0);
    }

    private double getBungaMetodeSaldoTerendah(long idSimpanan, Date upto) {
        double bunga = 0;
        Calendar c = Calendar.getInstance();
        c.setTime(upto);
        int maxDate = c.getActualMaximum(Calendar.DAY_OF_MONTH);
        int month = 1 + c.get(Calendar.MONTH);
        int year = c.get(Calendar.YEAR);

        /* UPDATED BY DEWOK 20190220, PENCARIAN SALDO TERENDAH MENGGUNAKAN PER TRANSAKSI, BUKAN PER TANGGAL
         HashMap<Integer, Double> allSaldo = PstDetailTransaksi.getSaldoSummaryPerDayOfTheMonth(idSimpanan, month, year);
         double dailyBalance = PstDetailTransaksi.getSaldoByDate(idSimpanan, now.get(Calendar.DAY_OF_MONTH), now.get(Calendar.MONTH) + 1, now.get(Calendar.YEAR));
         double minBalance = 0;
         int counter = 0;

         Double iBalance = 0D;
         for (int i = 1; i <= maxDate; i++) {
         iBalance = allSaldo.get(i);
         if (iBalance != null) {
         dailyBalance = dailyBalance + iBalance;
         counter++;
         } else {
         iBalance = 0D;
         }

         if (i == 1 || minBalance > dailyBalance || (minBalance == 0 && dailyBalance > 0)) {
         minBalance = (dailyBalance != 0 ? dailyBalance : 0);
         }
         if (allSaldo.size() <= counter) {
         break;
         }
         }
         */
        List<Double> allMutasi = PstDetailTransaksi.getListMutasiPerPeriode(idSimpanan, month, year);
        //cari saldo awal
        Calendar calSaldoAwal = Calendar.getInstance();
        calSaldoAwal.setTime(upto);
        calSaldoAwal.add(Calendar.MONTH, -1);
        double saldoAwal = PstDetailTransaksi.getLastSaldoOfTheMonth(idSimpanan, calSaldoAwal.get(Calendar.MONTH) + 1, calSaldoAwal.get(Calendar.YEAR));
        double balanceCompare = saldoAwal;
        double saldoTerendah = 0;
        //cari saldo terendah
        if (!allMutasi.isEmpty()) {
            for (int i = 0; i < allMutasi.size(); i++) {
                balanceCompare += allMutasi.get(i);
                if (saldoTerendah > balanceCompare || (saldoTerendah == 0 && balanceCompare > 0)) {
                    saldoTerendah = balanceCompare;
                }
            }
        } else {
            saldoTerendah = balanceCompare;
        }

        Calendar now = Calendar.getInstance();
        now.setTime(upto);
        Double iBalance = PstDetailTransaksi.getLastSaldoOfTheMonth(idSimpanan, now.get(Calendar.MONTH) + 1, now.get(Calendar.YEAR));
        double interestRate = PstTingkatanBunga.getBungaBySaldo(iBalance, idSimpanan);
        bunga = saldoTerendah * interestRate / 100 / 12;
        return (bunga > 0 ? bunga : 0);
    }

    private double getBungaDeposito(long idSimpanan) {
        double bunga = 0;
        Calendar currentMonth = Calendar.getInstance();
        int maxDate = 30;//lastMonth.getActualMaximum(Calendar.DAY_OF_MONTH);

        double saldo = PstDetailTransaksi.getLastSaldoOfTheMonth(idSimpanan, currentMonth.get(Calendar.MONTH) + 1, currentMonth.get(Calendar.YEAR));

        double interestRate = PstTingkatanBunga.getBungaBySaldo(saldo, idSimpanan);
        bunga = saldo * interestRate / 100 * maxDate / ANNUAL;
        return (bunga > 0 ? bunga : 0);
    }

    private double getBungaBerbunga(long idSimpanan, long oidJenisTransaksi, Date tglPencarianSaldo) {
        double bunga = 0;
        Calendar currentMonth = Calendar.getInstance();
        currentMonth.setTime(tglPencarianSaldo);
        int month = 1 + currentMonth.get(Calendar.MONTH);
        int year = currentMonth.get(Calendar.YEAR);

        double saldo = PstDetailTransaksi.getSaldoOfTheMonth(idSimpanan, month, year);
        double prevInterest = PstDetailTransaksi.getPreviousBunga(idSimpanan, oidJenisTransaksi, month, year);

        double iBalance = PstDetailTransaksi.getLastSaldoOfTheMonth(idSimpanan, month, year);
        double interestRate = PstTingkatanBunga.getBungaBySaldo(iBalance, idSimpanan);
        bunga = (iBalance + prevInterest) * interestRate / 100 / 12;
        return (bunga > 0 ? bunga : 0);
    }

    private boolean isGenerateBungaSaldoTerakhir(long idSimpanan, long oidJenisTransaksi, Date dtGenerate) {
        boolean generate = false;

        Calendar cal = Calendar.getInstance();
        cal.setTime(dtGenerate);
        int year = cal.get(Calendar.YEAR);
        int month = 1 + cal.get(Calendar.MONTH);

        Date dtLastGenerate = PstDetailTransaksi.getLastCalculationDateByTransaksiAndSimpanan(oidJenisTransaksi, year, month, idSimpanan);
        if (dtLastGenerate != null) {
            cal.setTime(dtLastGenerate);
            cal.add(Calendar.DATE, 30);
            Date dt = cal.getTime();

            if (dt.before(dtGenerate) || dt.equals(dtGenerate)) {
                generate = true;
            }
        } else {
            generate = true;
        }

        return generate;
    }

    private double getBungaSaldoTerakhir(long idSimpanan, Date dtGenerate) {
        double bunga = 0;

        Calendar cal = Calendar.getInstance();
        cal.setTime(dtGenerate);
        int month = 1 + cal.get(Calendar.MONTH);
        int year = cal.get(Calendar.YEAR);

        double saldo = PstDetailTransaksi.getLastSaldoOfTheMonth(idSimpanan, month, year);
        double interestRate = PstTingkatanBunga.getBungaBySaldo(saldo, idSimpanan);
        bunga = saldo * interestRate / 100 / 12;
        return (bunga > 0 ? bunga : 0);
    }

    private double getBungaSaldoPertama(long idSimpanan, Date dtGenerate) {
        double bunga = 0;
        double saldoPertama = PstDetailTransaksi.getFirstSaldo(idSimpanan);
        double interestRate = PstTingkatanBunga.getBungaBySaldo(saldoPertama, idSimpanan);
        bunga = saldoPertama * interestRate / 100 / 12;
        return (bunga > 0 ? bunga : 0);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
