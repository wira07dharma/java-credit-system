/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.session;

import com.dimata.aiso.entity.admin.PstAppUser;
import com.dimata.aiso.entity.masterdata.anggota.Anggota;
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import com.dimata.aiso.entity.masterdata.mastertabungan.JenisKredit;
import com.dimata.aiso.entity.masterdata.mastertabungan.JenisSimpanan;
import com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit;
import com.dimata.common.entity.payment.PaymentSystem;
import com.dimata.common.entity.payment.PstPaymentSystem;
import java.util.Vector;
import com.dimata.qdep.db.*;
import com.dimata.sedana.ajax.kredit.AjaxKredit;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.entity.assigncontacttabungan.AssignContactTabungan;
import com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan;
import com.dimata.sedana.entity.kredit.Angsuran;
import com.dimata.sedana.entity.kredit.AngsuranPayment;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstAngsuran;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.entity.masterdata.MasterTabungan;
import com.dimata.sedana.entity.masterdata.PstCashTeller;
import com.dimata.sedana.entity.masterdata.PstMasterLoket;
import com.dimata.sedana.entity.masterdata.PstMasterTabungan;
import com.dimata.sedana.entity.tabungan.DataTabungan;
import com.dimata.sedana.entity.tabungan.DetailTransaksi;
import com.dimata.sedana.entity.tabungan.MasterTabunganPenarikan;
import com.dimata.sedana.entity.tabungan.PstAssignPenarikanTabungan;
import com.dimata.sedana.entity.tabungan.PstDataTabungan;
import com.dimata.sedana.entity.tabungan.PstDetailTransaksi;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstMasterTabunganPenarikan;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.PstTransaksiPayment;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.sedana.entity.tabungan.TransaksiPayment;
import com.dimata.util.Formater;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author Dimata 007
 */
public class SessReportTabungan {

    public static Vector listTabunganPerShift(String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * "
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    //                    + " INNER JOIN " + PstDetailTransaksi.TBL_DETAILTRANSAKSI + " AS dt "
                    //                    + " ON dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]
                    + " INNER JOIN " + PstCashTeller.TBL_CASH_TELLER + " AS ct "
                    + " ON ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_TELLER_SHIFT_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TELLER_SHIFT_ID]
                    + " INNER JOIN " + PstMasterLoket.TBL_SEDANA_MASTER_LOKET + " AS ml "
                    + " ON ml." + PstMasterLoket.fieldNames[PstMasterLoket.FLD_MASTER_LOKET_ID] + " = ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_MASTER_LOKET_ID]
                    //                    + " INNER JOIN " + PstAppUser.TBL_APP_USER + " AS au "
                    //                    + " ON au." + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID]
                    //                    + " INNER JOIN " + PstDataTabungan.TBL_DATA_TABUNGAN + " AS adt "
                    //                    + " ON adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_SIMPANAN] + " = dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN]
                    //                    + " INNER JOIN " + PstAssignContactTabungan.TBL_ASSIGNCONTACTTABUNGAN + " AS act "
                    //                    + " ON act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID]
                    //                    + " INNER JOIN " + PstMasterTabungan.TBL_MASTERTABUNGAN + " AS mt "
                    //                    + " ON mt." + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_MASTER_TABUNGAN_ID] + " = act." + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_MASTER_TABUNGAN_ID]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Transaksi t = new Transaksi();
                PstTransaksi.resultToObject(rs, t);
                lists.add(t);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listTabunganPerNasabah(String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * "
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " INNER JOIN " + PstDetailTransaksi.TBL_DETAILTRANSAKSI + " AS dt "
                    + " ON dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]
                    + " INNER JOIN " + PstCashTeller.TBL_CASH_TELLER + " AS ct "
                    + " ON ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_TELLER_SHIFT_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TELLER_SHIFT_ID]
                    //                    + " INNER JOIN " + PstAppUser.TBL_APP_USER + " AS au "
                    //                    + " ON au." + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID]
                    + " INNER JOIN " + PstDataTabungan.TBL_DATA_TABUNGAN + " AS adt "
                    + " ON adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_SIMPANAN] + " = dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN]
                    + " INNER JOIN " + PstAssignContactTabungan.TBL_ASSIGNCONTACTTABUNGAN + " AS act "
                    + " ON act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID]
                    + " INNER JOIN " + PstMasterTabungan.TBL_MASTERTABUNGAN + " AS mt "
                    + " ON mt." + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_MASTER_TABUNGAN_ID] + " = act." + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_MASTER_TABUNGAN_ID]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Transaksi t = new Transaksi();
                PstTransaksi.resultToObject(rs, t);
                lists.add(t);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static String getNomorTabungan(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT act.`NO_TABUNGAN` "
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " INNER JOIN " + PstDetailTransaksi.TBL_DETAILTRANSAKSI + " AS dt "
                    + " ON dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]
                    + " INNER JOIN " + PstDataTabungan.TBL_DATA_TABUNGAN + " AS adt "
                    + " ON adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_SIMPANAN] + " = dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN]
                    + " INNER JOIN " + PstAssignContactTabungan.TBL_ASSIGNCONTACTTABUNGAN + " AS act "
                    + " ON act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            String nomor = "";
            while (rs.next()) {
                nomor = rs.getString(1);
            }
            rs.close();
            return nomor;
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
            return "Nomor tabungan tidak ditemukan";
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static HashMap<String, Double> getDataSetoranPenarikan(long idSimpanan, Date dateStart, Date dateEnd) {
        DBResultSet dbrs = null;
        HashMap<String, Double> saldo = new HashMap<String, Double>();
        try {
            String sql = "SELECT "
                    + " SUM(dt.KREDIT) AS SETORAN "
                    + " ,SUM(dt.DEBET) AS PENARIKAN "
                    + " FROM sedana_detail_transaksi AS dt "
                    + " JOIN sedana_transaksi AS t USING (TRANSAKSI_ID) "
                    + " WHERE dt.ID_SIMPANAN = '" + idSimpanan + "'"
                    + " AND DATE(t.TANGGAL_TRANSAKSI) BETWEEN '" + Formater.formatDate(dateStart, "yyyy-MM-dd") + "'"
                    + " AND '" + Formater.formatDate(dateEnd, "yyyy-MM-dd") + "'"
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                saldo.put("SETORAN", rs.getDouble("SETORAN"));
                saldo.put("PENARIKAN", rs.getDouble("PENARIKAN"));
            }
            rs.close();
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return saldo;
    }

    public static Vector getListTabunganDepositoYangAkanBerakhir() {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            Date dateNow = new Date();
            String bulanIni = Formater.formatDate(dateNow, "MM");
            String tahunIni = Formater.formatDate(dateNow, "yyyy");
            Calendar cal = Calendar.getInstance();
            cal.setTime(dateNow);
            cal.add(Calendar.MONTH, 1);
            Date dateNext = cal.getTime();
            String bulanDepan = Formater.formatDate(dateNext, "MM");
            String tahunDepan = Formater.formatDate(dateNext, "yyyy");

            String sql = "SELECT "
                    + " cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]
                    + ", cl." + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA]
                    + ", cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + ", act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_NO_TABUNGAN]
                    + ", act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_ASSIGN_TABUNGAN_ID]
                    + ", mt." + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN]
                    + ", mt." + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_MASTER_TABUNGAN_ID]
                    + ", dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL]
                    + ", dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP]
                    + ", dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_SIMPANAN]
                    + ", mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_PERIODE_BULAN]
                    + ", mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_START_DATE]
                    + ", mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_END_DATE]
                    + ", mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_ID_TABUNGAN_RANGE_PENARIKAN]
                    //
                    + " FROM " + PstAssignPenarikanTabungan.TBL_ASSIGN_PENARIKAN_TABUNGAN + " AS apt "
                    //
                    + " JOIN " + PstMasterTabunganPenarikan.TBL_MASTER_TABUNGAN_PENARIKAN + " AS mtp "
                    + "     ON mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_ID_TABUNGAN_RANGE_PENARIKAN]
                    + "     = apt." + PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_ID_TABUNGAN_RANGE_PENARIKAN]
                    //
                    + " JOIN " + PstMasterTabungan.TBL_MASTERTABUNGAN + " AS mt "
                    + "     ON mt." + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_MASTER_TABUNGAN_ID]
                    + "     = apt." + PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_MASTER_TABUNGAN_ID]
                    //
                    + " JOIN " + PstAssignContactTabungan.TBL_ASSIGNCONTACTTABUNGAN + " AS act "
                    + "     ON act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_MASTER_TABUNGAN_ID]
                    + "     = mt." + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_MASTER_TABUNGAN_ID]
                    //
                    + " JOIN " + PstDataTabungan.TBL_DATA_TABUNGAN + " AS dt "
                    + "     ON dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID]
                    + "     = act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_ASSIGN_TABUNGAN_ID]
                    //
                    + " JOIN " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + "     ON cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + "     = dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA]
                    //
                    + " WHERE dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_STATUS] + " = " + I_Sedana.STATUS_AKTIF
                    + " AND mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_TIPE_RANGE] + " = " + I_Sedana.TIPE_PENARIKAN_TABUNGAN_BULAN
                    + " AND ("
                    + "    ("
                    + "      MONTH(dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP] + ") = '" + bulanIni + "'"
                    + "      AND YEAR(dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP] + ") = '" + tahunIni + "'"
                    + "    )"
                    + "    OR ("
                    + "      MONTH(dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP] + ") = '" + bulanDepan + "'"
                    + "      AND YEAR(dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP] + ") = '" + tahunDepan + "'"
                    + "    )"
                    + "  )"
                    + " ORDER BY dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP]
                    + ", cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]
                    + "";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector data = new Vector();

                Anggota a = new Anggota();
                a.setOID(rs.getLong("cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]));
                a.setName(rs.getString("cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]));
                a.setNoAnggota(rs.getString("cl." + PstAnggota.fieldNames[PstAnggota.FLD_NO_ANGGOTA]));
                data.add(a);

                AssignContactTabungan act = new AssignContactTabungan();
                act.setOID(rs.getLong("act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_ASSIGN_TABUNGAN_ID]));
                act.setNoTabungan(rs.getString("act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_NO_TABUNGAN]));
                data.add(act);

                MasterTabungan mt = new MasterTabungan();
                mt.setOID(rs.getLong("mt." + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_MASTER_TABUNGAN_ID]));
                mt.setNamaTabungan(rs.getString("mt." + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_NAMA_TABUNGAN]));
                data.add(mt);

                DataTabungan dt = new DataTabungan();
                dt.setOID(rs.getLong("dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_SIMPANAN]));
                dt.setTanggal(rs.getTimestamp("dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL]));
                dt.setTanggalTutup(rs.getTimestamp("dt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP]));
                data.add(dt);

                MasterTabunganPenarikan mtp = new MasterTabunganPenarikan();
                mtp.setOID(rs.getLong("mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_ID_TABUNGAN_RANGE_PENARIKAN]));
                mtp.setPeriodeBulan(rs.getInt("mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_PERIODE_BULAN]));
                mtp.setStartDate(rs.getTimestamp("mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_START_DATE]));
                mtp.setEndDate(rs.getTimestamp("mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_END_DATE]));
                data.add(mtp);

                lists.add(data);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector getListJadwalAngsuranKreditYangAkanJatuhTempo() {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            Date dateNow = new Date();
            String bulanIni = Formater.formatDate(dateNow, "MM");
            String tahunIni = Formater.formatDate(dateNow, "yyyy");

            String sql = "SELECT "
                    + " tk." + PstJenisKredit.fieldNames[PstJenisKredit.FLD_NAME_KREDIT]
                    + ", cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]
                    + ", jadwal.* "
                    + "FROM " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    //
                    + "  JOIN " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + "    ON cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    //
                    + "  JOIN " + PstJenisKredit.TBL_KREDIT + " AS tk "
                    + "    ON tk." + PstJenisKredit.fieldNames[PstJenisKredit.FLD_TYPE_KREDIT_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_TIPE_KREDIT_ID]
                    //
                    + "  JOIN "
                    + "    (SELECT "
                    + "      ja. " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]
                    + "      ,ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + "      ,a." + PstAngsuran.fieldNames[PstAngsuran.FLD_ID_ANGSURAN]
                    + "      ,a." + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID]
                    + "      ,ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]
                    + "      ,ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]
                    + "      ,ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + " AS ANGSURAN "
                    + "      ,SUM(a." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS DIBAYAR "
                    + "      ,ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + " - SUM(a." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS SISA "
                    + "    FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS ja "
                    + "      LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS a "
                    + "        ON a." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + "    WHERE ( "
                    + "        MONTH(ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") = '" + bulanIni + "' "
                    + "        AND YEAR(ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") = '" + tahunIni + "' "
                    + "      ) "
                    + "    GROUP BY ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + ") AS jadwal "
                    + "    ON jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                    //
                    + " WHERE p." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " IN (" + Pinjaman.STATUS_DOC_CAIR + "," + Pinjaman.STATUS_DOC_PENANGANAN_MACET + ")"
                    + " AND (jadwal.SISA > 0 OR jadwal.SISA IS NULL) "
                    + " GROUP BY jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]
                    + " ORDER BY jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]
                    + ", cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]
                    + "";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector data = new Vector();

                JenisKredit jk = new JenisKredit();
                jk.setNamaKredit(rs.getString("tk." + PstJenisKredit.fieldNames[PstJenisKredit.FLD_NAME_KREDIT]));
                data.add(jk);

                Anggota a = new Anggota();
                a.setName(rs.getString("cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]));
                data.add(a);

                JadwalAngsuran ja = new JadwalAngsuran();
                ja.setOID(rs.getLong("jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID]));
                ja.setPinjamanId(rs.getLong("jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]));
                ja.setTanggalAngsuran(rs.getTimestamp("jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]));
                ja.setJenisAngsuran(rs.getInt("jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]));
                ja.setJumlahANgsuran(rs.getDouble("jadwal.ANGSURAN"));
                data.add(ja);

                Angsuran ang = new Angsuran();
                ang.setOID(rs.getLong("jadwal." + PstAngsuran.fieldNames[PstAngsuran.FLD_ID_ANGSURAN]));
                ang.setJumlahAngsuran(rs.getDouble("jadwal.DIBAYAR"));
                ang.setTransaksiId(rs.getLong("jadwal." + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID]));
                data.add(ang);

                lists.add(data);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static int getPeriodeBulanDeposito(long idAssignContactTabungan) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + " mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_PERIODE_BULAN]
                    + " FROM " + PstMasterTabunganPenarikan.TBL_MASTER_TABUNGAN_PENARIKAN + " AS mtp "
                    + " INNER JOIN " + PstAssignPenarikanTabungan.TBL_ASSIGN_PENARIKAN_TABUNGAN + " AS apt "
                    + " ON apt." + PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_ID_TABUNGAN_RANGE_PENARIKAN] + " = mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_ID_TABUNGAN_RANGE_PENARIKAN]
                    + " INNER JOIN " + PstAssignContactTabungan.TBL_ASSIGNCONTACTTABUNGAN + " AS act "
                    + " ON act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_MASTER_TABUNGAN_ID] + " = apt." + PstAssignPenarikanTabungan.fieldNames[PstAssignPenarikanTabungan.FLD_MASTER_TABUNGAN_ID]
                    + " WHERE mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_TIPE_RANGE] + " = " + I_Sedana.TIPE_PENARIKAN_TABUNGAN_BULAN
                    + " AND act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = '" + idAssignContactTabungan + "' "
                    + "";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int bulan = 0;
            while (rs.next()) {
                bulan = rs.getInt(1);
            }
            rs.close();
            return bulan;
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static Vector getListSimpananSukarela(String where, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + "  adt.ID_SIMPANAN "
                    + " , act.NO_TABUNGAN "
                    + " , js.NAMA_SIMPANAN "
                    + " , cl.PERSON_NAME "
                    + " , cl.CONTACT_CODE "
                    + " , cl.CONTACT_ID "
                    + " , SUM(dt.KREDIT - dt.DEBET) AS SALDO "
                    + " FROM "
                    + "  aiso_data_tabungan AS adt "
                    + "  JOIN sedana_assign_contact_tabungan AS act "
                    + "    ON act.ASSIGN_TABUNGAN_ID = adt.ASSIGN_TABUNGAN_ID "
                    + "  JOIN aiso_jenis_simpanan AS js "
                    + "    ON js.ID_JENIS_SIMPANAN = adt.ID_JENIS_SIMPANAN "
                    + "  JOIN contact_list AS cl "
                    + "    ON cl.CONTACT_ID = act.CONTACT_ID "
                    + "  LEFT JOIN sedana_detail_transaksi AS dt "
                    + "    ON dt.ID_SIMPANAN = adt.ID_SIMPANAN "
                    + " WHERE adt.STATUS = 1 "
                    + "  AND js.FREKUENSI_SIMPANAN = 0 "
                    + "";

            if (!where.isEmpty()) {
                sql += " AND " + where;
            }

            sql += " GROUP BY adt.ID_SIMPANAN ";

            if (!order.isEmpty()) {
                sql += " ORDER BY " + order;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector data = new Vector();

                DataTabungan dt = new DataTabungan();
                dt.setOID(rs.getLong("adt.ID_SIMPANAN"));
                data.add(dt);

                AssignContactTabungan act = new AssignContactTabungan();
                act.setNoTabungan(rs.getString("act.NO_TABUNGAN"));
                data.add(act);

                JenisSimpanan js = new JenisSimpanan();
                js.setNamaSimpanan(rs.getString("js.NAMA_SIMPANAN"));
                js.setSetoranMin(rs.getDouble("SALDO"));
                data.add(js);

                Anggota a = new Anggota();
                a.setOID(rs.getLong("cl.CONTACT_ID"));
                a.setName(rs.getString("cl.PERSON_NAME"));
                a.setNoAnggota(rs.getString("cl.CONTACT_CODE"));
                data.add(a);

                lists.add(data);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            printErrorMessage(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public synchronized static String saveMultipleSetoran(String oidSimpanan[], String jumlahSetoran[], String tgl[], String oidAnggota[], long tellerShiftId) {
        String msg = "";
        if (oidSimpanan != null) {
            int i = 0;
            long idPaymentSystem = 0;
            long jenisTransaksiId = PstJenisTransaksi.getIdJenisTransaksiByNamaJenisTransaksi("Penambahan Cash");
            Vector<PaymentSystem> listPaymentSystem = PstPaymentSystem.list(0, 1, PstPaymentSystem.fieldNames[PstPaymentSystem.FLD_PAYMENT_TYPE] + " = " + AngsuranPayment.TIPE_PAYMENT_CASH, null);
            if (!listPaymentSystem.isEmpty()) {
                idPaymentSystem = listPaymentSystem.get(0).getOID();
            }
            for (String s : oidSimpanan) {
                try {
                    Long idSimpanan = Long.valueOf(s);
                    double setoran = Double.valueOf(jumlahSetoran[i]);

                    if (PstDataTabungan.checkOID(idSimpanan) && setoran > 0) {
                        Date tglTransaksi = Formater.formatDate(tgl[i], "yyyy-MM-dd HH:mm:ss");
                        long idAnggota = Long.valueOf(oidAnggota[i]);
                        String nomorTransaksi = PstTransaksi.generateKodeTransaksi(Transaksi.KODE_TRANSAKSI_TABUNGAN_SETORAN, Transaksi.USECASE_TYPE_TABUNGAN_SETORAN, tglTransaksi);

                        Transaksi t = new Transaksi();
                        t.setTanggalTransaksi(tglTransaksi);
                        t.setIdAnggota(idAnggota);
                        t.setTellerShiftId(tellerShiftId);
                        t.setKeterangan("Multiple " + Transaksi.USECASE_TYPE_TITLE.get(Transaksi.USECASE_TYPE_TABUNGAN_SETORAN));
                        t.setStatus(Transaksi.STATUS_DOC_TRANSAKSI_CLOSED);
                        t.setTipeArusKas(Transaksi.TIPE_ARUS_KAS_BERTAMBAH);
                        t.setUsecaseType(Transaksi.USECASE_TYPE_TABUNGAN_SETORAN);
                        t.setKodeBuktiTransaksi(nomorTransaksi);
                        long transaksiId = PstTransaksi.insertExc(t);

                        //simpan detail transaksi
                        DetailTransaksi dt = new DetailTransaksi();
                        dt.setTransaksiId(transaksiId);
                        dt.setIdSimpanan(idSimpanan);
                        dt.setKredit(setoran);
                        dt.setJenisTransaksiId(jenisTransaksiId);
                        dt.setDetailInfo("Multiple setoran tanggal " + Formater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
                        long oidDetail = PstDetailTransaksi.insertExc(dt);

                        //simpan payment transaksi
                        TransaksiPayment tp = new TransaksiPayment();
                        tp.setPaymentSystemId(idPaymentSystem);
                        tp.setJumlah(setoran);
                        tp.setTransaksiId(transaksiId);
                        long oidPayment = PstTransaksiPayment.insertExc(tp);
                    }
                } catch (Exception e) {
                    printErrorMessage(e.getMessage());
                    msg += e.getMessage();
                    if (idPaymentSystem == 0) {
                        break;
                    }
                }
                i++;
            }
        }
        return msg;
    }

    public static double getSaldoAwal(long idAnggota, String nomorTabungan, Vector<Long> idJenisSimpanan, Date dateLimit) {
        double saldoAwal = 0;
        Calendar c = Calendar.getInstance();
        c.setTime(dateLimit);
        c.add(Calendar.DATE, -1);

        //CARI ID ASSIGN CONTACT TABUNGAN
        String whereTabungan = PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_CONTACT_ID] + " = '" + idAnggota + "'"
                + " AND " + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_NO_TABUNGAN] + " = '" + nomorTabungan + "'";
        Vector<AssignContactTabungan> listTabungan = PstAssignContactTabungan.list(0, 0, whereTabungan, "");
        for (AssignContactTabungan act : listTabungan) {
            for (long idJS : idJenisSimpanan) {
                //CARI ID SIMPANAN
                String whereSimpanan = PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = '" + act.getOID() +"'"
                        + " AND " + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_JENIS_SIMPANAN] + " = '" + idJS + "'";
                Vector<DataTabungan> listSimpanan = PstDataTabungan.list(0, 0, whereSimpanan, "");
                for (DataTabungan dt : listSimpanan) {
                    saldoAwal += PstDetailTransaksi.getSaldoByDate(dt.getOID(), c.get(Calendar.DAY_OF_MONTH), c.get(Calendar.MONTH) + 1, c.get(Calendar.YEAR));
                }
            }
        }
        return saldoAwal;
    }
    
    public static ArrayList getTabunganDepositoPerTanggalTutup(Date tglTutup, String nomorTabungan) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + "  adt.* "
                    + " FROM "
                    + "  " + PstDataTabungan.TBL_DATA_TABUNGAN + " adt "
                    + "  JOIN " + PstAssignContactTabungan.TBL_ASSIGNCONTACTTABUNGAN + " act "
                    + "    ON act.ASSIGN_TABUNGAN_ID = adt.ASSIGN_TABUNGAN_ID "
                    + "  JOIN " + PstMasterTabungan.TBL_MASTERTABUNGAN + " mt "
                    + "    ON mt.MASTER_TABUNGAN_ID = act.MASTER_TABUNGAN_ID "
                    + "  JOIN " + PstAssignPenarikanTabungan.TBL_ASSIGN_PENARIKAN_TABUNGAN + " apt "
                    + "    ON apt.MASTER_TABUNGAN_ID = mt.MASTER_TABUNGAN_ID "
                    + "  JOIN " + PstMasterTabunganPenarikan.TBL_MASTER_TABUNGAN_PENARIKAN + " mtp "
                    + "    ON mtp.ID_TABUNGAN_RANGE_PENARIKAN = apt.ID_TABUNGAN_RANGE_PENARIKAN "
                    + " WHERE adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_STATUS] + " = '" + I_Sedana.STATUS_AKTIF + "' "
                    + "  AND YEAR(adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP] + ") = '" + Formater.formatDate(tglTutup, "yyyy") + "' "
                    + "  AND MONTH(adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_TANGGAL_TUTUP] + ") = '" + Formater.formatDate(tglTutup, "MM") + "' "
                    + "  AND mtp." + PstMasterTabunganPenarikan.fieldNames[PstMasterTabunganPenarikan.FLD_TIPE_RANGE] + " = '" + Transaksi.TIPE_PENARIKAN_TABUNGAN_BULAN + "'";
            
            if (!nomorTabungan.isEmpty()) {
                sql += " AND act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_NO_TABUNGAN] + " = '" + nomorTabungan + "'";
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            ArrayList list = new ArrayList();
            while (rs.next()) {
                DataTabungan dt = new DataTabungan();
                PstDataTabungan.resultToObject(rs, dt);
                list.add(dt);
            }
            rs.close();
            return list;

        } catch (DBException | SQLException e) {
            printErrorMessage(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return new ArrayList();
    }
    
    public static double getSaldoAwalPerTanggal(long idSimpanan, String tglPencarian) {
        double saldoAwal = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + "  SUM(dt.KREDIT - dt.DEBET) "
                    + " FROM "
                    + "  sedana_detail_transaksi dt "
                    + "  INNER JOIN sedana_transaksi t "
                    + "    ON t.TRANSAKSI_ID = dt.TRANSAKSI_ID "
                    + " WHERE dt.ID_SIMPANAN = " + idSimpanan
                    + "  AND t.TANGGAL_TRANSAKSI < '" + tglPencarian + "'"
                    + "";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                saldoAwal = rs.getInt(1);
            }
            rs.close();

        } catch (DBException | SQLException e) {
            printErrorMessage(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return saldoAwal;
    }
    
    public static ArrayList listTransaksiTabunganKolektor(String where) {
        ArrayList arrayList = new ArrayList();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + "  st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]
                    + "  ,st." + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI]
                    + "  ,aau." + PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME]
                    + "  ,cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]
                    + "  ,act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_NO_TABUNGAN]
                    + "  ,sjt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI]
                    + "  ,SUM(sdt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_DEBET] + ") AS " + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_DEBET]
                    + "  ,SUM(sdt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_KREDIT] + ") AS " + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_KREDIT]
                    + "  ,st." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE]
                    + "  ,sdt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN]
                    + "  ,st." + PstTransaksi.fieldNames[PstTransaksi.FLD_KETERANGAN]
                    + " FROM "
                    + "  " + PstTransaksi.TBL_TRANSAKSI + " AS st "
                    + "  INNER JOIN " + PstCashTeller.TBL_CASH_TELLER + " AS ct "
                    + "    ON ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_TELLER_SHIFT_ID] + " = st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TELLER_SHIFT_ID]
                    + " INNER JOIN " + PstMasterLoket.TBL_SEDANA_MASTER_LOKET + " AS sml "
                    + "    ON sml." + PstMasterLoket.fieldNames[PstMasterLoket.FLD_MASTER_LOKET_ID] + " = ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_MASTER_LOKET_ID]
                    + "  INNER JOIN " + PstAppUser.TBL_APP_USER + " aau "
                    + "    ON aau." + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID]
                    + "  INNER JOIN " + PstDetailTransaksi.TBL_DETAILTRANSAKSI + " AS sdt "
                    + "    ON sdt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID] + " = st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]
                    + "  INNER JOIN " + PstJenisTransaksi.TBL_JENISTRANSAKSI + " AS sjt "
                    + "    ON sjt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI_ID] + " = sdt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_JENIS_TRANSAKSI_ID]
                    + "  INNER JOIN " + PstDataTabungan.TBL_DATA_TABUNGAN + " AS adt "
                    + "    ON adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_SIMPANAN] + " = sdt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN]
                    + "  INNER JOIN " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + "    ON cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ID_ANGGOTA]
                    + "  INNER JOIN " + PstAssignContactTabungan.TBL_ASSIGNCONTACTTABUNGAN + " AS act "
                    + "    ON act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_ASSIGN_TABUNGAN_ID] + " = adt." + PstDataTabungan.fieldNames[PstDataTabungan.FLD_ASSIGN_TABUNGAN_ID]
                    + " WHERE sml." + PstMasterLoket.fieldNames[PstMasterLoket.FLD_LOKET_TYPE] + " = " + PstMasterLoket.LOKET_TYPE_FIELD
                    + "";
            
            //WHERE
            sql += where.isEmpty() ? "" : " AND " + where;
            
            //GROUP
            sql += " GROUP BY st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID];
            
            //ORDER
            sql += " ORDER BY st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC "
                    + "  ,aau." + PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME]
                    + "  ,cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]
                    + "  ,act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_NO_TABUNGAN]
                    + "";
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                long idSimpanan = rs.getLong("sdt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_ID_SIMPANAN]);
                String tglTransaksi = rs.getString("st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]);
                double kredit = rs.getDouble(PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_KREDIT]);
                double debet = rs.getDouble(PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_DEBET]);
                
                double saldoAwal = getSaldoAwalPerTanggal(idSimpanan, tglTransaksi);
                double saldoAkhir = saldoAwal + kredit - debet;
                
                HashMap<String, Object> data = new HashMap<>();
                data.put("TANGGAL_TRANSAKSI", tglTransaksi);
                data.put("NAMA_KOLEKTOR", rs.getString("aau." + PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME]));
                data.put("NAMA_ANGGOTA", rs.getString("cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]));
                data.put("NO_TABUNGAN", rs.getString("act." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_NO_TABUNGAN]));
                data.put("SALDO_AWAL", saldoAwal);
                data.put("SETORAN", kredit);
                data.put("PENARIKAN", debet);
                data.put("SALDO_AKHIR", saldoAkhir);
                arrayList.add(data);
            }
            rs.close();

        } catch (DBException | SQLException e) {
            printErrorMessage(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return arrayList;
    }
    
    public static ArrayList listTransaksiKreditKolektor(String where) {
        ArrayList arrayList = new ArrayList();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + "  st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]
                    + "  ,st." + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI]
                    + "  ,aau." + PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME]
                    + "  ,cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]
                    + "  ,ap." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]
                    + "  ,ap." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN]
                    + "  ,SUM(aa." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS " + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN]
                    + "  ,ap." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                    + "  ,st." + PstTransaksi.fieldNames[PstTransaksi.FLD_KETERANGAN]
                    + " FROM "
                    + "  " + PstTransaksi.TBL_TRANSAKSI + " AS st "
                    + "  INNER JOIN " + PstCashTeller.TBL_CASH_TELLER + " AS ct "
                    + "    ON ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_TELLER_SHIFT_ID] + " = st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TELLER_SHIFT_ID]
                    + "  INNER JOIN " + PstMasterLoket.TBL_SEDANA_MASTER_LOKET + " AS sml "
                    + "    ON sml." + PstMasterLoket.fieldNames[PstMasterLoket.FLD_MASTER_LOKET_ID] + " = ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_MASTER_LOKET_ID]
                    + "  INNER JOIN " + PstAppUser.TBL_APP_USER + " AS aau "
                    + "    ON aau." + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID]
                    + "  INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS ap "
                    + "    ON ap." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = st." + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID]
                    + "  INNER JOIN " + PstAngsuran.TBL_ANGSURAN + " AS aa "
                    + "    ON aa." + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]
                    + "  INNER JOIN " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + "    ON cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = ap." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + " WHERE sml." + PstMasterLoket.fieldNames[PstMasterLoket.FLD_LOKET_TYPE] + " = " + PstMasterLoket.LOKET_TYPE_OFFICE
                    + "";

            //WHERE
            sql += where.isEmpty() ? "" : " AND " + where;
            
            //GROUP
            sql += " GROUP BY st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID];
            
            //ORDER
            sql += " ORDER BY st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " DESC "
                    + "  ,aau." + PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME]
                    + "  ,cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]
                    + "  ,ap." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]
                    + "";
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                long idPinjaman = rs.getLong("ap." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]);
                
                double totalAngsuran = SessKredit.getTotalAngsuran(idPinjaman);
                double totalAngsuranDibayar = SessKredit.getTotalAngsuranDibayar(idPinjaman);
                double sisaAngsuran = totalAngsuran - totalAngsuranDibayar;
                
                HashMap<String, Object> data = new HashMap<>();
                data.put("TANGGAL_TRANSAKSI", rs.getString("st." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]));
                data.put("NAMA_KOLEKTOR", rs.getString("aau." + PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME]));
                data.put("NAMA_ANGGOTA", rs.getString("cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]));
                data.put("NO_KREDIT", rs.getString("ap." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]));
                data.put("JUMLAH_PINJAMAN", rs.getDouble("ap." + PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN]));
                data.put("JUMLAH_ANGSURAN", rs.getDouble(PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN]));
                data.put("SISA_ANGSURAN", sisaAngsuran);
                arrayList.add(data);
            }
            rs.close();

        } catch (DBException | SQLException e) {
            printErrorMessage(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return arrayList;
    }
    
    public static void printErrorMessage(String message) {
        System.out.println("========== * ========== ERROR ========== * ==========");
        System.out.println("");
        System.out.println(message);
        System.out.println("");
        System.out.println("========== * ========== ***** ========== * ==========");
    }
}
