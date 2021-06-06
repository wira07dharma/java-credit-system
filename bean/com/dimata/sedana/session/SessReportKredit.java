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
import com.dimata.common.entity.contact.PstContactClass;
import com.dimata.common.entity.contact.PstContactClassAssign;
import com.dimata.common.entity.custom.PstDataCustom;
import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.harisma.entity.employee.Employee;
import com.dimata.harisma.entity.employee.PstEmployee;
import com.dimata.pos.entity.billing.BillMain;
import com.dimata.pos.entity.billing.Billdetail;
import com.dimata.pos.entity.billing.PstBillMain;
import com.dimata.posbo.entity.masterdata.Material;
import com.dimata.posbo.entity.masterdata.PstMaterial;
import java.util.Vector;
import com.dimata.qdep.db.*;
import com.dimata.sedana.common.I_Sedana;
import com.dimata.sedana.entity.assignsumberdana.AssignSumberDana;
import com.dimata.sedana.entity.assignsumberdana.PstAssignSumberDana;
import com.dimata.sedana.entity.kredit.Angsuran;
import com.dimata.sedana.entity.kredit.HapusKredit;
import com.dimata.sedana.entity.kredit.JadwalAngsuran;
import com.dimata.sedana.entity.kredit.Pinjaman;
import com.dimata.sedana.entity.kredit.PstAngsuran;
import com.dimata.sedana.entity.kredit.PstHapusKredit;
import com.dimata.sedana.entity.kredit.PstJadwalAngsuran;
import com.dimata.sedana.entity.kredit.PstPinjaman;
import com.dimata.sedana.entity.kredit.PstPinjamanSumberDana;
import com.dimata.sedana.entity.kredit.PstReturnKredit;
import com.dimata.sedana.entity.kredit.PstReturnKreditItem;
import com.dimata.sedana.entity.kredit.PstTypeKredit;
import com.dimata.sedana.entity.kredit.ReturnKredit;
import com.dimata.sedana.entity.kredit.ReturnKreditItem;
import com.dimata.sedana.entity.masterdata.BiayaTransaksi;
import com.dimata.sedana.entity.masterdata.KolektibilitasPembayaran;
import com.dimata.sedana.entity.masterdata.PstBiayaTransaksi;
import com.dimata.sedana.entity.masterdata.PstCashTeller;
import com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaran;
import com.dimata.sedana.entity.masterdata.PstKolektibilitasPembayaranDetails;
import com.dimata.sedana.entity.masterdata.PstMasterLoket;
import com.dimata.sedana.entity.report.ReportKredit;
import com.dimata.sedana.entity.sumberdana.PstSumberDana;
import com.dimata.sedana.entity.tabungan.PstDetailTransaksi;
import com.dimata.sedana.entity.tabungan.PstJenisTransaksi;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.util.Formater;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

/**
 *
 * @author Dimata 007
 */
public class SessReportKredit {

    public static Vector listPerTahun(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT DISTINCT YEAR(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") AS tahun FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            int tahun = 0;
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                tahun = rs.getInt("tahun");
                lists.add(tahun);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listJoinPinjamanAngsuran(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID] + ", jadwal.* "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal"
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS pinjaman "
                    + " ON pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = jadwal." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstAnggota.TBL_ANGGOTA + " AS contact "
                    + " ON contact." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                JadwalAngsuran entJadwalAngsuran = new JadwalAngsuran();
                PstJadwalAngsuran.resultToObject(rs, entJadwalAngsuran);
                lists.add(entJadwalAngsuran);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static double getSumAngsuranHarusDibayar(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getSumAngsuranDibayar(long oidJadwalAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(" + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") "
                    + " FROM " + PstAngsuran.TBL_ANGSURAN
                    + " WHERE " + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + oidJadwalAngsuran + "'";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static Vector listJoinTunggakan(long oidPinjaman, int jenisAngsuran, String dateParameter) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT angsuran.*, "
                    + " SUM(angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS total_dibayar, "
                    + " jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " AS jadwal_angsuran"
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + oidPinjaman + "' "
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "' "
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " <= '" + dateParameter + "' "
                    + " GROUP BY jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Angsuran entAngsuran = new Angsuran();
                PstAngsuran.resultToObject(rs, entAngsuran);
                entAngsuran.setTotalDibayar(rs.getDouble("total_dibayar"));
                entAngsuran.setTunggakanBulanAwal(rs.getDate("jadwal_angsuran"));
                lists.add(entAngsuran);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listJoinJenisTransaksiBiayaKredit(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT pd.* "
                    + " FROM " + PstBiayaTransaksi.TBL_BIAYA_TRANSAKSI + " AS pd "
                    + " INNER JOIN " + PstJenisTransaksi.TBL_JENISTRANSAKSI + " AS jt "
                    + " ON jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI_ID] + " = pd." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_JENIS_TRANSAKSI]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                BiayaTransaksi entBiayaTransaksi = new BiayaTransaksi();
                PstBiayaTransaksi.resultToObject(rs, entBiayaTransaksi);
                lists.add(entBiayaTransaksi);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Date getTunggakanKredit(long idPinjaman, String tanggalCek, int jenisAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT MIN(tb.TANGGAL_ANGSURAN) "
                    + " FROM "
                    + " (SELECT "
                    + " jadwal.`TANGGAL_ANGSURAN`,"
                    + " jadwal.`JADWAL_ANGSURAN_ID`,"
                    + " jadwal.`PINJAMAN_ID`,"
                    + " jadwal.`JUMLAH_ANGSURAN`,"
                    + " angsuran.`JUMLAH_ANGSURAN` AS PEMBAYARAN,"
                    + " jadwal.`JUMLAH_ANGSURAN` AS BALANCE "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran.`JADWAL_ANGSURAN_ID` = jadwal.`JADWAL_ANGSURAN_ID` "
                    + " WHERE jadwal.`PINJAMAN_ID` = '" + idPinjaman + "' "
                    + " AND jadwal.`TANGGAL_ANGSURAN` <= '" + tanggalCek + "' "
                    + " AND jadwal.`JENIS_ANGSURAN` = '" + jenisAngsuran + "' "
                    + " AND angsuran.id_angsuran IS NULL "
                    + " UNION ALL"
                    + " SELECT"
                    + " jadwal.`TANGGAL_ANGSURAN`,"
                    + " jadwal.`JADWAL_ANGSURAN_ID`,"
                    + " jadwal.`PINJAMAN_ID`,"
                    + " jadwal.`JUMLAH_ANGSURAN`,"
                    + " SUM(angsuran.`JUMLAH_ANGSURAN`) AS PEMBAYARAN,"
                    + " ("
                    + " jadwal.`JUMLAH_ANGSURAN` - SUM(angsuran.`JUMLAH_ANGSURAN`)"
                    + " ) AS BALANCE "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " LEFT JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran.`JADWAL_ANGSURAN_ID` = jadwal.`JADWAL_ANGSURAN_ID`"
                    + " WHERE jadwal.`PINJAMAN_ID` = '" + idPinjaman + "' "
                    + " AND jadwal.`TANGGAL_ANGSURAN` <= '" + tanggalCek + "' "
                    + " AND jadwal.`JENIS_ANGSURAN` = '" + jenisAngsuran + "' "
                    + " AND angsuran.id_angsuran IS NOT NULL "
                    + " GROUP BY jadwal.`JADWAL_ANGSURAN_ID`) AS tb "
                    + " WHERE balance != 0 "
                    + " ORDER BY tb.TANGGAL_ANGSURAN "
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Date tanggal = null;
            while (rs.next()) {
                tanggal = rs.getDate(1);
            }
            rs.close();
            return tanggal;
        } catch (Exception e) {
            return null;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalAngsuranDibayarByTransaksi(long idTransaksi) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS dibayar"
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " ON jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " WHERE angsuran." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TRANSAKSI_ID] + " = '" + idTransaksi + "'"
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalAngsuranDibayar(long idPinjaman, int jenisAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS dibayar"
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " ON jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "'";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalAngsuranDenganBungaDibayar(long idPinjaman, Date batasHitung) {
        DBResultSet dbrs = null;
        double total = 0;
        try {
            String sql = "SELECT angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + " AS dibayar, "
                    + " transaksi.*"
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " INNER JOIN " + PstTransaksi.TBL_TRANSAKSI + " as transaksi "
                    + " ON angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID]
                    + " = transaksi."  + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " ON jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] 
                    + " = angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                    + " AND " + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + " < '" + batasHitung + "'"
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] 
                    + " IN (" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ", " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ", " + JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT + ") "; 
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet(); 
            while (rs.next()) {
                double dibayar = rs.getDouble("dibayar");
                total += dibayar;
            }
            rs.close();
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
        return total;
    }
    
    public static double getTotalAngsuran(long idPinjaman, int jenisAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS total "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' "
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "' "
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    public static double getTotalAngsuranDenganBunga(long idPinjaman){
     DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS total "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' "
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] 
                    + " IN (" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ", " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ", " + JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT +  ") "
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    public static double getSaldo(long idPinjaman) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS Total"
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' "
                    + "";
            System.out.println("getSaldo : "+sql); 
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalAngsuranPerTanggalCek(long idPinjaman, int jenisAngsuran, String tglCek) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS jumlah "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' "
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "' "
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " <= '" + tglCek + "' "
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalAngsuranPerBulanCek(long idPinjaman, int jenisAngsuran, String tglCek) {
        DBResultSet dbrs = null;
        try {
            String split[] = tglCek.split("-");
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            cal.set(Calendar.MONTH, Integer.valueOf(split[1]));
            cal.set(Calendar.YEAR, Integer.valueOf(split[0]));
            cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
            Date d = cal.getTime();
            tglCek = Formater.formatDate(d, "yyyy-MM-dd");

            String sql = "SELECT SUM(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS jumlah "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' "
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "' "
                    + " AND DATE(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") <= '" + tglCek + "'"
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static Date getTanggalAwalAngsuran(long idPinjaman) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT MIN(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' "
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Date tanggal = null;
            while (rs.next()) {
                tanggal = rs.getDate(1);
            }
            rs.close();
            return tanggal;
        } catch (Exception e) {
            return null;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static Vector listJoinJenisKreditBySumberDana(String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + " tk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_TYPE_KREDIT_ID]
                    + ", tk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_NAME_KREDIT]
                    + ", sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_SUMBER_DANA_ID]
                    + ", sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_JUDUL_SUMBER_DANA]
                    + ", ass." + PstAssignSumberDana.fieldNames[PstAssignSumberDana.FLD_ASSIGN_SUMBER_DANA_JENIS_KREDIT_ID]
                    + " FROM " + PstTypeKredit.TBL_TYPEKREDIT + " AS tk "
                    + " INNER JOIN " + PstAssignSumberDana.TBL_ASSIGNSUMBERDANA + " AS ass "
                    + " ON ass." + PstAssignSumberDana.fieldNames[PstAssignSumberDana.FLD_TYPE_KREDIT_ID] + " = tk." + PstTypeKredit.fieldNames[PstTypeKredit.FLD_TYPE_KREDIT_ID]
                    + " INNER JOIN " + PstSumberDana.TBL_SUMBERDANA + " AS sd "
                    + " ON sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_SUMBER_DANA_ID] + " = ass." + PstAssignSumberDana.fieldNames[PstAssignSumberDana.FLD_SUMBER_DANA_ID]
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
                AssignSumberDana asd = new AssignSumberDana();
                PstAssignSumberDana.resultToObject(rs, asd);
                lists.add(asd);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listJoinPinjamanKolektibilitas(String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * "
                    + " FROM " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " INNER JOIN " + PstKolektibilitasPembayaran.TBL_KOLEKTIBILITASPEMBAYARAN + " AS kp "
                    + " ON kp." + PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_KOLEKTIBILITAS_ID]
                    + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_KODE_KOLEKTIBILITAS]
//                    + " INNER JOIN " + PstPinjamanSumberDana.TBL_PINJAMANSUMBERDANA + " AS sd "
//                    + " ON sd." + PstPinjamanSumberDana.fieldNames[PstPinjamanSumberDana.FLD_PINJAMAN_ID]
//                    + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS ja "
                    + " ON ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]
                    + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
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
                Pinjaman p = new Pinjaman();
                PstPinjaman.resultToObject(rs, p);
//                p.setSumberDanaId(rs.getLong(PstPinjamanSumberDana.fieldNames[PstPinjamanSumberDana.FLD_SUMBER_DANA_ID]));
                lists.add(p);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listJoinPinjamanRangkumanKolektibilitas(String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT p.* "
                    + " FROM " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " INNER JOIN " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + " ON cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " AS cca "
                    + " ON cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] + " = cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " AS cc "
                    + " ON cc." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] + " = cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID]
                    + " INNER JOIN " + PstPinjamanSumberDana.TBL_PINJAMANSUMBERDANA + " AS psd "
                    + " ON psd." + PstPinjamanSumberDana.fieldNames[PstPinjamanSumberDana.FLD_PINJAMAN_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstSumberDana.TBL_SUMBERDANA + " AS sd "
                    + " ON sd." + PstSumberDana.fieldNames[PstSumberDana.FLD_SUMBER_DANA_ID] + " = psd." + PstPinjamanSumberDana.fieldNames[PstPinjamanSumberDana.FLD_SUMBER_DANA_ID]
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
                Pinjaman p = new Pinjaman();
                PstPinjaman.resultToObject(rs, p);
                lists.add(p);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listKreditPerShift(String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * "
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " ON p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstCashTeller.TBL_CASH_TELLER + " AS ct "
                    + " ON ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_TELLER_SHIFT_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TELLER_SHIFT_ID]
                    + " INNER JOIN " + PstMasterLoket.TBL_SEDANA_MASTER_LOKET + " AS ml "
                    + " ON ml." + PstMasterLoket.fieldNames[PstMasterLoket.FLD_MASTER_LOKET_ID] + " = ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_MASTER_LOKET_ID]
                    //                    + " INNER JOIN " + PstAppUser.TBL_APP_USER + " AS au "
                    //                    + " ON au." + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = ct." + PstCashTeller.fieldNames[PstCashTeller.FLD_APP_USER_ID]
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
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static double getTotalNilaiTransaksi(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + " SUM(dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_KREDIT] + ") AS kredit,"
                    + " SUM(dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_DEBET] + ") AS debet,"
                    + " SUM(dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_KREDIT] + ") "
                    + " - SUM(dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_DEBET] + ") AS nilai "
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " INNER JOIN " + PstDetailTransaksi.TBL_DETAILTRANSAKSI + " AS dt "
                    + " ON dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID]
                    + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getInt(3);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalAngsuranPerJadwal(long idPinjaman, int jenisAngsuran, String jadwalAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS total "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' "
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "' "
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + jadwalAngsuran + "' "
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalAngsuranDibayarPerJadwal(long idPinjaman, int jenisAngsuran, String jadwalAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS dibayar"
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " ON jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "'"
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + jadwalAngsuran + "'";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static int getCountAngsuranDibayarPerJadwal(long idPinjaman, int jenisAngsuran, String jadwalAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_ID_ANGSURAN] + ")"
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " ON jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "'"
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + jadwalAngsuran + "'";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalAngsuranDariJadwalPertama(long idPinjaman, int jenisAngsuran, String jadwalAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS total "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' "
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "' "
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " <= '" + jadwalAngsuran + "' "
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalAngsuranDibayarDariJadwalPertama(long idPinjaman, int jenisAngsuran, String jadwalAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS dibayar"
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " ON jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "'"
                    + " AND jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " <= '" + jadwalAngsuran + "'";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static Vector listSisaPinjaman(String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + "  p.*, "
                    + "  c.*, "
                    + "  bm.*, "
                    + "  loc.*, "
                    + "  angsuran.TOTAL_ANGSURAN - angsuran.TOTAL_DIBAYAR AS SISA_ANGSURAN "
                    + " FROM "
                    + "  aiso_pinjaman AS p "
                    + "  JOIN contact_list AS c "
                    + "  ON c.CONTACT_ID = p.ANGGOTA_ID"
                    + "  LEFT JOIN cash_bill_main AS bm "
                    + "  ON bm.CASH_BILL_MAIN_ID = p.CASH_BILL_MAIN_ID"
                    + "  LEFT JOIN location AS loc "
                    + "  ON loc.LOCATION_ID = bm.LOCATION_ID"
//                    + " JOIN contact_list AS cl "
//                    + "  ON cl.CONTACT_ID = p.COLLECTOR_ID "
                    + "  JOIN "
                    + "    (SELECT "
                    + "      j.PINJAMAN_ID, "
                    + "      j.JENIS_ANGSURAN, "
                    + "      SUM(j.JUMLAH_ANGSURAN) AS TOTAL_ANGSURAN, "
                    + "      COALESCE(SUM(a.JUMLAH_ANGSURAN), 0) AS TOTAL_DIBAYAR "
                    + "    FROM "
                    + "      sedana_jadwal_angsuran AS j "
                    + "      LEFT JOIN aiso_angsuran AS a "
                    + "        ON a.JADWAL_ANGSURAN_ID = j.JADWAL_ANGSURAN_ID "
                    + "    GROUP BY j.PINJAMAN_ID) AS angsuran "
                    + "    ON angsuran.PINJAMAN_ID = p.PINJAMAN_ID"
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
                Vector data = new Vector();
                Pinjaman p = new Pinjaman();
                PstPinjaman.resultToObject(rs, p);
                data.add(p);
                Anggota a = new Anggota();
                a.setName(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_NAME]));
                data.add(a);
                BillMain bm = new BillMain();
                data.add(bm);
                Location loc = new Location();
                data.add(loc);
                lists.add(data);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static int getCountAngsuranDibayarTerlambatPerJadwal(long idPinjaman, int jenisAngsuran, String jadwalAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + ")"
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " INNER JOIN " + PstAngsuran.TBL_ANGSURAN + " AS a "
                    + " ON a." + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS ja "
                    + " ON ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = a." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " WHERE ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                    + " AND ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "'"
                    + " AND ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " = '" + jadwalAngsuran + "'"
                    + " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") > '" + jadwalAngsuran + "'";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalAngsuranDibayarPerTanggalCek(long idPinjaman, int jenisAngsuran, String tglCek) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(a." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") "
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS a"
                    + " JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS ja "
                    + " ON ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = a." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " JOIN " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " ON t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " = a." + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID]
                    + " WHERE ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' "
                    + " AND ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "' "
                    + " AND DATE(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ") <= '" + tglCek + "' "
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static double getTotalAngsuranDibayarPerJadwalCek(long idPinjaman, int jenisAngsuran, String tglCek) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(a." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") "
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS a"
                    + " JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS ja "
                    + " ON ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = a." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " WHERE ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' "
                    + " AND ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "' "
                    + " AND DATE(ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") <= '" + tglCek + "' "
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static ArrayList listRiwayatAngsuranKredit(String nomorKredit) {
        DBResultSet dbrs = null;
        try {
            String sql = ""
                    + "SELECT "
                    + "  p.NO_KREDIT, "
                    + "  cl.PERSON_NAME, "
                    + "  p.JUMLAH_PINJAMAN, "
                    + "  cl.HOME_ADDRESS, "
                    + "  p.JATUH_TEMPO, "
                    + "  p.TGL_LUNAS, "
                    + "  p.SUKU_BUNGA, "
                    + "  p.JANGKA_WAKTU, "
                    + "  k.TIPE_FREKUENSI_POKOK, "
                    + "  t.KODE_BUKTI_TRANSAKSI, "
                    + "  t.TANGGAL_TRANSAKSI, "
                    + "  p.CASH_BILL_MAIN_ID, "
                    + "  p.PINJAMAN_ID, "
                    + "  ROUND( "
                    + "    SUM(all_angsuran.ANGSURAN_POKOK), "
                    + "    2 "
                    + "  ) AS ANGSURAN_POKOK, "
                    + "  ROUND( "
                    + "    SUM(all_angsuran.ANGSURAN_BUNGA), "
                    + "    2 "
                    + "  ) AS ANGSURAN_BUNGA, "
                    + "  ROUND( "
                    + "    SUM(all_angsuran.ANGSURAN_DP), "
                    + "    2 "
                    + "  ) AS ANGSURAN_DP, "
                    + "  ROUND( "
                    + "    SUM(all_angsuran.DISCOUNT), "
                    + "    2 "
                    + "  ) AS DISC_AMOUNT, "
                    + "  t.KETERANGAN "
                    + "FROM "
                    + "  (SELECT "
                    + "    t.TRANSAKSI_ID, "
                    + "    j.JENIS_ANGSURAN, "
                    + "    SUM(a.JUMLAH_ANGSURAN) AS ANGSURAN_POKOK, "
                    + "    0 AS ANGSURAN_BUNGA, "
                    + "    0 AS ANGSURAN_DP, "
                    + "    SUM(a.DISC_AMOUNT) AS DISCOUNT "
                    + "  FROM "
                    + "    sedana_transaksi t "
                    + "    JOIN aiso_angsuran a "
                    + "      ON a.TRANSAKSI_ID = t.TRANSAKSI_ID "
                    + "    JOIN sedana_jadwal_angsuran j "
                    + "      ON j.JADWAL_ANGSURAN_ID = a.JADWAL_ANGSURAN_ID "
                    + "    JOIN aiso_pinjaman p "
                    + "      ON p.PINJAMAN_ID = t.PINJAMAN_ID "
                    + "  WHERE t.USECASE_TYPE = '" + Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT + "' "
                    + "    AND j.JENIS_ANGSURAN = '" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + "'"
                    + "    AND p.NO_KREDIT = '" + nomorKredit + "' "
                    + "  GROUP BY t.TRANSAKSI_ID "
                    + "  UNION "
                    + "  SELECT "
                    + "    t.TRANSAKSI_ID, "
                    + "    j.JENIS_ANGSURAN, "
                    + "    0 AS ANGSURAN_POKOK, "
                    + "    0 AS ANGSURAN_BUNGA, "
                    + "    SUM(a.JUMLAH_ANGSURAN) AS ANGSURAN_DP, "
                    + "    SUM(a.DISC_AMOUNT) AS DISCOUNT "
                    + "  FROM "
                    + "    sedana_transaksi t "
                    + "    JOIN aiso_angsuran a "
                    + "      ON a.TRANSAKSI_ID = t.TRANSAKSI_ID "
                    + "    JOIN sedana_jadwal_angsuran j "
                    + "      ON j.JADWAL_ANGSURAN_ID = a.JADWAL_ANGSURAN_ID "
                    + "    JOIN aiso_pinjaman p "
                    + "      ON p.PINJAMAN_ID = t.PINJAMAN_ID "
                    + "  WHERE t.USECASE_TYPE = '" + Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT + "' "
                    + "    AND j.JENIS_ANGSURAN = '" + JadwalAngsuran.TIPE_ANGSURAN_DOWN_PAYMENT + "' "
                    + "    AND p.NO_KREDIT = '" + nomorKredit + "' "
                    + "  GROUP BY t.TRANSAKSI_ID"
                    + "  UNION "
                    + "  SELECT "
                    + "    t.TRANSAKSI_ID, "
                    + "    j.JENIS_ANGSURAN, "
                    + "    0 AS ANGSURAN_POKOK, "
                    + "    SUM(a.JUMLAH_ANGSURAN) AS ANGSURAN_BUNGA, "
                    + "    0 AS ANGSURAN_DP, "
                    + "    SUM(a.DISC_AMOUNT) AS DISCOUNT "
                    + "  FROM "
                    + "    sedana_transaksi t "
                    + "    JOIN aiso_angsuran a "
                    + "      ON a.TRANSAKSI_ID = t.TRANSAKSI_ID "
                    + "    JOIN sedana_jadwal_angsuran j "
                    + "      ON j.JADWAL_ANGSURAN_ID = a.JADWAL_ANGSURAN_ID "
                    + "    JOIN aiso_pinjaman p "
                    + "      ON p.PINJAMAN_ID = t.PINJAMAN_ID "
                    + "  WHERE t.USECASE_TYPE = '" + Transaksi.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT + "' "
                    + "    AND j.JENIS_ANGSURAN = '" + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + "' "
                    + "    AND p.NO_KREDIT = '" + nomorKredit + "' "
                    + "  GROUP BY t.TRANSAKSI_ID) AS all_angsuran "
                    + "  JOIN sedana_transaksi t "
                    + "    ON t.TRANSAKSI_ID = all_angsuran.TRANSAKSI_ID "
                    + "  JOIN aiso_pinjaman p "
                    + "    ON p.PINJAMAN_ID = t.PINJAMAN_ID "
                    + "  JOIN contact_list cl "
                    + "    ON cl.CONTACT_ID = p.ANGGOTA_ID "
                    + "  JOIN aiso_type_kredit k "
                    + "    ON k.TYPE_KREDIT_ID = p.TIPE_KREDIT_ID "
                    + "GROUP BY t.TRANSAKSI_ID "
                    + "ORDER BY t.TANGGAL_TRANSAKSI";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            ArrayList lists = new ArrayList();
            while (rs.next()) {
                ArrayList data = new ArrayList();
                Pinjaman p = new Pinjaman();
                p.setNoKredit(rs.getString("NO_KREDIT"));
                p.setJumlahPinjaman(rs.getDouble("JUMLAH_PINJAMAN"));
                p.setJatuhTempo(rs.getDate("JATUH_TEMPO"));
                p.setTglLunas(rs.getDate("TGL_LUNAS"));
                p.setSukuBunga(rs.getDouble("SUKU_BUNGA"));
                p.setJangkaWaktu(rs.getInt("JANGKA_WAKTU"));
                p.setJumlahAngsuran(rs.getDouble("ANGSURAN_POKOK"));
                p.setBillMainId(rs.getLong("CASH_BILL_MAIN_ID"));
                p.setOID(rs.getLong("PINJAMAN_ID"));
                data.add(p);

                Anggota a = new Anggota();
                a.setName(rs.getString("PERSON_NAME"));
                a.setAddressPermanent(rs.getString("HOME_ADDRESS"));
                data.add(a);

                Transaksi t = new Transaksi();
                t.setKodeBuktiTransaksi(rs.getString("KODE_BUKTI_TRANSAKSI"));
                t.setTanggalTransaksi(rs.getTimestamp("TANGGAL_TRANSAKSI"));
                t.setKeterangan(rs.getString("KETERANGAN"));
                data.add(t);
                
                Angsuran angsuran = new Angsuran();
                angsuran.setJumlahAngsuran(rs.getDouble("ANGSURAN_BUNGA"));
                angsuran.setDiscAmount(rs.getDouble("DISC_AMOUNT"));
                data.add(angsuran);
                
                JenisKredit k = new JenisKredit();
                k.setTipeFrekuensiPokok(rs.getInt("TIPE_FREKUENSI_POKOK"));
                data.add(k);
                
                Angsuran angsuranDp = new Angsuran();
                angsuranDp.setJumlahAngsuran(rs.getDouble("ANGSURAN_DP"));
                data.add(angsuranDp);
                
                lists.add(data);
            }
            rs.close();
            return lists;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return new ArrayList();
    }

	public static Vector listDaftarTagihan(String whereClause) {
		Vector listData = new Vector(1, 1);
		DBResultSet dbrs = null;
		try {

			String sql = "SELECT *"
					+ " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS SJA"
					+ " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS AP"
					+ " ON SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]
					+ " = AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
					+ " INNER JOIN " + PstAnggota.TBL_ANGGOTA + " AS ANG"
					+ " ON AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID] 
					+ " = ANG." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
					+ " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS CBM"
					+ " ON AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID] 
					+ " = CBM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID];

			if (whereClause != null && whereClause.length() > 0) {
				sql += " WHERE " + whereClause;
			}

			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while (rs.next()) {
				JadwalAngsuran ja = new JadwalAngsuran();
				Pinjaman p = new Pinjaman();
                                
				PstJadwalAngsuran.resultToObject(rs, ja);
				PstPinjaman.resultToObject(rs, p);

                                boolean status = PstPinjaman.checkBillMainStatus(p.getBillMainId(), PstBillMain.PETUGAS_DELIVERY_STATUS_DITERIMA);
                                if(status){
                                    Vector temp = new Vector(1, 1);
                                    temp.add(ja);
                                    temp.add(p);
                                    listData.add(temp);
                                } else {
                                    try {
                                        BillMain bill = PstBillMain.fetchExc(p.getBillMainId());
                                        if(bill.getStatus() == PstBillMain.PETUGAS_DELIVERY_STATUS_DITERIMA){
                                            Vector temp = new Vector(1, 1);
                                            temp.add(ja);
                                            temp.add(p);
                                            listData.add(temp);
                                        }
                                    } catch (Exception exc){
                                        
                                    }
                                }
			}

			rs.close();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			DBResultSet.close(dbrs);
		}
		return listData;
	}

    public static Vector listDaftarPencapaianEstimasi(String whereClause) {
        Vector listData = new Vector(1, 1);
        DBResultSet dbrs = null;
        try {

            String sql = "SELECT"
                    + " SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + " AS TGL_TRANSAKSI,"
                    + " COUNT(AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + ") AS JUMLAH_TERTAGIH,"
                    + " SUM(SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS JUMLAH"
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS SJA"
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS AP"
                    + " ON SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]
                    + " = AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS CBM"
                    + " ON AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " = CBM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID];

            if (whereClause != null && whereClause.length() > 0) {
                sql += " WHERE " + whereClause;
            }

            sql += " GROUP BY TO_DAYS(SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")";
            System.out.println("#======================= Pencapaian Estimasi\n" + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector temp = new Vector(1, 1);

                //long kolOid = rs.getLong("KOL_ID");
                String tglTrans = rs.getString("TGL_TRANSAKSI");
                int qty = rs.getInt("JUMLAH_TERTAGIH");
                double total = rs.getDouble("JUMLAH");
//				double totalReal = rs.getDouble("JUMLAH");

//				temp.add(kolOid);
                temp.add(tglTrans);//0
                temp.add(qty);//1
                temp.add(total);//2

                listData.add(temp);
            }

            rs.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return listData;
    }

    public static Vector listDaftarPencapaianRealisasi(long oid, Date date) {
        Vector listData = new Vector(1, 1);
        DBResultSet dbrs = null;
        try {

            String sql = "SELECT"
                    + " COUNT(AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + ") AS JUMLAH_TERTAGIH,"
                    + " SUM(AA." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS JUMLAH"
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS AA"
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS SJA"
                    + " ON AA." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " = SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS AP"
                    + " ON SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]
                    + " = AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstTransaksi.TBL_TRANSAKSI + " AS ST"
                    + " ON ST." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]
                    + " = AA." + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID];

            sql += " WHERE ST." + PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE]
                    + " = " + I_Sedana.USECASE_TYPE_KREDIT_ANGSURAN_PAYMENT
                    + " AND TO_DAYS(SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")"
                    + " = TO_DAYS('" + Formater.formatDate(date, "yyyy-MM-dd") + "')"
                    + " AND ( TO_DAYS(ST." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ")"
                    + " >= TO_DAYS('" + Formater.formatDate(date, "yyyy-MM-dd") + "')" 
                    + " OR TO_DAYS(ST." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ")"
                    + " <= TO_DAYS('" + Formater.formatDate(date, "yyyy-MM-dd") + "')"
                    + " ) AND SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] 
                    + " IN (" + JadwalAngsuran.TIPE_ANGSURAN_POKOK + ", " + JadwalAngsuran.TIPE_ANGSURAN_BUNGA + ")";

            if (oid != 0) {
                sql += " AND AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_COLLECTOR_ID] + " = " + oid;
            }

            //sql += " GROUP BY TO_DAYS(ST." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ")";
            dbrs = DBHandler.execQueryResult(sql);
            System.out.println("#============================= List Realisasi =====================================\n" + sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
//				Vector temp = new Vector(1, 1);

                //long kolOid = rs.getLong("KOL_ID");
                //Date tglTrans = Formater.formatDate(rs.getString("TGL_TRANSAKSI"), "yyyy-MM-dd");
                int qty = rs.getInt("JUMLAH_TERTAGIH");
                double total = rs.getDouble("JUMLAH");

//				temp.add(kolOid);
//				temp.add(tglTrans);
                listData.add(qty);
                listData.add(total);

//				listData.add(temp);
            }

            rs.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return listData;
    }
    
    public static Vector listReportPengembalianBarang(String startDate, String endDate, int jenisTransaksi, String location, long userId, long assignLocationId, String status) {
        Vector listData = new Vector(1, 1);
        DBResultSet dbrs = null;
        try {

            String sql = "SELECT"
                        + " loc."+PstLocation.fieldNames[PstLocation.FLD_NAME]
                        + ", item."+PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NEW_MATERIAL_NAME]
                        + ", item."+PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NEW_SKU]
                        + ", item."+PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NILAI_PERSEDIAAN]
                        + ", item."+PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NILAI_HPP]
                        + ", kr."+PstReturnKredit.fieldNames[PstReturnKredit.FLD_JENIS_RETURN]
                        + ", kr."+PstReturnKredit.fieldNames[PstReturnKredit.FLD_CATATAN]
                        + ", kr."+PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID]
                        + ", p."+PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]
                        + ", p."+PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                        + ", p."+PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN]
                        + ", p."+PstPinjaman.fieldNames[PstPinjaman.FLD_DOWN_PAYMENT]
                        + ", p."+PstPinjaman.fieldNames[PstPinjaman.FLD_JANGKA_WAKTU]
                        + ", c."+PstAnggota.fieldNames[PstAnggota.FLD_NAME]
                        + ", c."+PstAnggota.fieldNames[PstAnggota.FLD_ADDR_PERMANENT]
                        + ", pm."+PstMaterial.fieldNames[PstMaterial.FLD_NAME]+" AS MAT_NAME"
                        + ", emp."+PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]
                        + ", (SELECT SUM("+PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NILAI_HPP]+") FROM "+PstReturnKreditItem.TBL_RETURNKREDITITEM+" WHERE "+PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID]+" = kr."+PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID]+") AS HPP"
                        + ", (SELECT COUNT("+PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID]+") FROM "+PstReturnKreditItem.TBL_RETURNKREDITITEM+" WHERE "+PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID]+" = kr."+PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID]+") AS CNT"
                    + " FROM "
                        + PstReturnKreditItem.TBL_RETURNKREDITITEM + " item "
                        + " INNER JOIN "+PstReturnKredit.TBL_RETURNKREDIT+" kr "
                            + "ON item."+PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_RETURN_ID]+" = kr."+PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID]
                        + " INNER JOIN "+PstPinjaman.TBL_PINJAMAN+" p "
                            + " ON kr."+PstReturnKredit.fieldNames[PstReturnKredit.FLD_PINJAMAN_ID]+" = p."+PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                        + " INNER JOIN "+PstAnggota.TBL_ANGGOTA+" c "
                            + " ON p."+PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]+" = c."+PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                        + " INNER JOIN `pos_raditya`."+PstMaterial.TBL_MATERIAL+" pm "
                            + " ON item."+PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_MATERIAL_ID]+" = pm."+PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID]
                        + " INNER JOIN "+PstBillMain.TBL_CASH_BILL_MAIN+" cbm "
                            + " ON p."+PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]+" = cbm."+PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID]
                        + " INNER JOIN "+PstLocation.TBL_P2_LOCATION+" loc "
                            + " ON cbm."+PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID]+" = loc."+PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID]
                        + " INNER JOIN `hr_raditya`."+PstEmployee.TBL_HR_EMPLOYEE+" emp "
                            + " ON p."+PstPinjaman.fieldNames[PstPinjaman.FLD_ACCOUNT_OFFICER_ID]+" = emp."+PstEmployee.fieldNames[PstEmployee.FLD_EMPLOYEE_ID];

            if (startDate.length()>0 || endDate.length()>0 || location.length()>0 || jenisTransaksi>-1){
                
                if (location.length()>0){
                    sql += " WHERE cbm.LOCATION_ID IN ("+location+") ";
                } else {
                    String inLocation = ""+assignLocationId;
                    Vector<Location> listLocation = PstLocation.getListFromApiAll();
                    for(Location loc : listLocation){  
                        boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userId, ""+loc.getOID());
                        if (isExistDataCustom){
                            inLocation += ","+loc.getOID();
                        }
                    }
                    sql += " WHERE cbm.LOCATION_ID IN ("+inLocation+") ";
                }
                
                if (startDate.length()>0 && endDate.length()>0){
                    sql += " AND kr.`TANGGAL_RETURN` BETWEEN '"+startDate+" 00:00:00' AND '"+endDate+" 23:59:59'";
                } else if (startDate.length()>0){
                    sql += " AND kr.`TANGGAL_RETURN` >= '"+startDate+" 00:00:00'";
                } else if (endDate.length() > 0){
                    sql += " AND kr.`TANGGAL_RETURN` <= '"+endDate+" 23:59:59'";
                }
                
                if (jenisTransaksi>-1){
                    sql += " AND kr.JENIS_RETURN = "+jenisTransaksi;
                }
                
                if (status.length()>0){
                    sql += " AND kr.STATUS IN ("+status+")";
                }
                
                
                
            }
            //sql += " GROUP BY TO_DAYS(ST." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI] + ")";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                
                Vector temp = new Vector();
                ReturnKreditItem retItem = new ReturnKreditItem();
                retItem.setNewMaterialName(rs.getString(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NEW_MATERIAL_NAME]));
                retItem.setNewSku(rs.getString(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NEW_SKU]));
                retItem.setNilaiPersediaan(rs.getDouble(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NILAI_PERSEDIAAN]));
                retItem.setNilaiHpp(rs.getDouble(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NILAI_HPP]));
                temp.add(retItem);
                
                ReturnKredit retKredit = new ReturnKredit();
                retKredit.setCatatan(rs.getString(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CATATAN]));
                retKredit.setJenisReturn(rs.getInt(PstReturnKredit.fieldNames[PstReturnKredit.FLD_JENIS_RETURN]));
                retKredit.setOID(rs.getLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID]));
                temp.add(retKredit);
                
                Pinjaman p = new Pinjaman();
                p.setOID(rs.getLong(PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]));
                p.setNoKredit(rs.getString(PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]));
                p.setJumlahPinjaman(rs.getDouble(PstPinjaman.fieldNames[PstPinjaman.FLD_JUMLAH_PINJAMAN]));
                p.setDownPayment(rs.getDouble(PstPinjaman.fieldNames[PstPinjaman.FLD_DOWN_PAYMENT]));
                p.setJangkaWaktu(rs.getInt(PstPinjaman.fieldNames[PstPinjaman.FLD_JANGKA_WAKTU]));
                temp.add(p);
                
                Anggota ang = new Anggota();
                ang.setName(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_NAME]));
                ang.setAddressPermanent(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_ADDR_PERMANENT]));
                temp.add(ang);
                
                Material mat = new Material();
                mat.setName(rs.getString("MAT_NAME"));
                temp.add(mat);
                
                Employee emp = new Employee();
                emp.setFullName(rs.getString(PstEmployee.fieldNames[PstEmployee.FLD_FULL_NAME]));
                temp.add(emp);
                
                Location loc = new Location();
                loc.setName(rs.getString(PstLocation.fieldNames[PstLocation.FLD_NAME]));
                temp.add(loc);
                
                temp.add(rs.getInt("CNT"));
                temp.add(rs.getDouble("HPP"));
                
                listData.add(temp);
            }

            rs.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        return listData;
    }
    
    public static Vector listReportPenghapusanKredit(String startDate, String endDate, String location, long userId, long assignLocationId, String status) {
        Vector listData = new Vector();
        DBResultSet dbrs = null;
        
        try {
            String sql = "SELECT "
                        + "loc.`NAME` AS LOKASI, "
                        + "p.`NO_KREDIT`, "
                        + "cl.`PERSON_NAME`, "
                        + "cl.`HOME_ADDRESS`, "
                        + "cbd.`ITEM_NAME` AS NAMA_BARANG, "
                        + "COALESCE(dp.JUMLAH, 0) AS DP, "
                        + "COALESCE(pokok.JUMLAH, 0) AS POKOK, "
                        + "COALESCE(bunga.JUMLAH, 0) AS BUNGA, "
                        + "COALESCE(pokok.JUMLAH, 0) + COALESCE(bunga.JUMLAH, 0) AS TOTAL, "
                        + "COALESCE(dibayar.JUMLAH, 0) + COALESCE(dp.JUMLAH, 0) AS PEMBAYARAN, "
                        + "hk.SISA_POKOK, "
                        + "hk.SISA_BUNGA, "
                        + "hk.SISA_POKOK + hk.SISA_BUNGA AS SISA_KREDIT, "
                        + "hk.CATATAN, "
                        + " (SELECT COUNT(CASH_BILL_MAIN_ID) FROM cash_bill_detail WHERE CASH_BILL_MAIN_ID = cbm.CASH_BILL_MAIN_ID) AS CNT "
                    + "FROM "
                        + "`sedana_hapus_kredit` as hk "
                        + "inner join `aiso_pinjaman` as p "
                            + "on hk.`PINJAMAN_ID` = p.`PINJAMAN_ID` "
                        + "INNER JOIN cash_bill_main cbm "
                            + "ON p.`CASH_BILL_MAIN_ID` = cbm.`CASH_BILL_MAIN_ID` "
                        + "INNER JOIN `location` AS loc "
                            + "ON cbm.`LOCATION_ID` = loc.`LOCATION_ID` "
                        + "INNER JOIN `contact_list` AS cl "
                            + "on cl.`CONTACT_ID` = p.`ANGGOTA_ID` "
                        + "inner join `cash_bill_detail` cbd "
                            + "on cbd.`CASH_BILL_MAIN_ID` = cbm.`CASH_BILL_MAIN_ID` "
                        + "left join "
                            + "(select "
                                + "SUM(`JUMLAH_ANGSURAN`) as jumlah, "
                                + "pinjaman_id "
                            + "FROM "
                                + "`sedana_jadwal_angsuran` "
                            + "where `JENIS_ANGSURAN` = 18 "
                            + "GROUP BY `PINJAMAN_ID`) AS dp "
                            + "ON dp.PINJAMAN_ID = p.`PINJAMAN_ID` "
                        + "left join "
                            + "(select "
                                + "SUM(`JUMLAH_ANGSURAN`) as jumlah, "
                                + "pinjaman_id "
                            + "FROM "
                                + "`sedana_jadwal_angsuran` "
                            + "where `JENIS_ANGSURAN` = 4 "
                            + "GROUP BY `PINJAMAN_ID`) AS pokok "
                            + "ON pokok.PINJAMAN_ID = p.`PINJAMAN_ID` "
                        + "left join "
                            + "(select "
                                + "SUM(`JUMLAH_ANGSURAN`) as jumlah, "
                                + "pinjaman_id "
                            + "FROM "
                                + "`sedana_jadwal_angsuran` "
                            + "where `JENIS_ANGSURAN` = 5 "
                            + "GROUP BY `PINJAMAN_ID`) AS bunga "
                            + "ON bunga.PINJAMAN_ID = p.`PINJAMAN_ID` "
                        + "left join "
                            + "(select "
                                + "SUM(ags.`JUMLAH_ANGSURAN`) as jumlah, "
                                + "jd.pinjaman_id "
                            + "FROM "
                                + "`aiso_angsuran` ags "
                                + "INNER JOIN `sedana_jadwal_angsuran` jd "
                                    + "ON ags.JADWAL_ANGSURAN_ID = jd.JADWAL_ANGSURAN_ID "
                                    + "WHERE jd.JENIS_ANGSURAN IN (4,5) "
                            + "GROUP BY jd.`PINJAMAN_ID`) AS dibayar "
                            + "ON dibayar.PINJAMAN_ID = p.`PINJAMAN_ID` ";
                        //+ "ORDER BY hk.`TANGGAL_HAPUS`, hk.`HAPUS_ID` ";
                        
            if (startDate.length()>0 || endDate.length()>0 || location.length()>0){
                
                if (location.length()>0){
                    sql += " WHERE cbm.LOCATION_ID IN ("+location+") ";
                } else {
                    String inLocation = ""+assignLocationId;
                    Vector<Location> listLocation = PstLocation.getListFromApiAll();
                    for(Location loc : listLocation){  
                        boolean isExistDataCustom = PstDataCustom.checkOwnerAndValue(userId, ""+loc.getOID());
                        if (isExistDataCustom){
                            inLocation += ","+loc.getOID();
                        }
                    }
                    sql += " WHERE cbm.LOCATION_ID IN ("+inLocation+") ";
                }
                
                if (startDate.length()>0 && endDate.length()>0){
                    sql += " AND hk.`TANGGAL_HAPUS` BETWEEN '"+startDate+" 00:00:00' AND '"+endDate+" 23:59:59'";
                } else if (startDate.length()>0){
                    sql += " AND hk.`TANGGAL_HAPUS` >= '"+startDate+" 00:00:00'";
                } else if (endDate.length() > 0){
                    sql += " AND hk.`TANGGAL_HAPUS` <= '"+endDate+" 23:59:59'";
                }
                
                if (status.length()>0){
                    sql += " AND hk.STATUS IN ("+status+")";
                }
                
            }
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                
                ReportKredit reportKredit = new ReportKredit();
                reportKredit.setNoPk(rs.getString("NO_KREDIT"));
                reportKredit.setCabang(rs.getString("LOKASI"));
                reportKredit.setNamaKonsumen(rs.getString("PERSON_NAME"));
                reportKredit.setAddrKonsumen(rs.getString("HOME_ADDRESS"));
                reportKredit.setNamaItem(rs.getString("NAMA_BARANG"));
                reportKredit.setTotal(rs.getDouble("TOTAL"));
                reportKredit.setPembayaran(rs.getDouble("PEMBAYARAN"));
                reportKredit.setSisaPokok(rs.getDouble("SISA_POKOK"));
                reportKredit.setSisaBunga(rs.getDouble("SISA_BUNGA"));
                reportKredit.setJmlDp(rs.getDouble("DP"));
                reportKredit.setNotes(rs.getString("CATATAN"));
                reportKredit.setPokok(rs.getDouble("POKOK"));
                reportKredit.setBunga(rs.getDouble("BUNGA"));
                reportKredit.setCntKredit(rs.getInt("CNT"));
                
                listData.add(reportKredit);
            }

            rs.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
        
        return listData;
    }
    
    
    public static Vector getReportPenjualanKredit(String startDate, String endDate, String inLocation, int typeBayar, String inStatus){
        Vector listData = new Vector();
        DBResultSet dbrs = null;
        
        try {
            String sql = "SELECT "
                + " p.TGL_REALISASI "
                + " ,YEAR(p.TGL_REALISASI) AS TAHUN"
                + " ,MONTH(p.TGL_REALISASI) AS BULAN"
                + " ,DAY(p.TGL_REALISASI) AS HARI"
                + " ,p.`NO_KREDIT`"
                + " ,loc.`NAME` AS LOKASI"
                + " ,cl.`PERSON_NAME`"
                + " ,coalesce(cl.`HOME_ADDRESS`,'-') AS HOME_ADDRESS"
                + " ,coalesce(mar.`EMPLOYEE_NUM`,'-') AS EMPLOYEE_NUM"
                + " ,coalesce(mar.`FULL_NAME`,'-') AS FULL_NAME"
                + " ,coalesce(ana.`EMPLOYEE_NUM`,'-') AS NUM_ANAL"
                + " ,coalesce(ana.`FULL_NAME`,'-') AS NAMA_ANAL"
                + " ,coalesce(kol.`EMPLOYEE_NUM`,'-') AS NUM_KOL"
                + " ,coalesce(kol.`FULL_NAME`,'-') AS NAMA_KOL"
                + " ,coalesce(map.MASTER_CODE,'-') AS MASTER_CODE"
                + " ,coalesce(map.MASTER_NAME,'-') AS MASTER_NAME"
                + " ,m.`SKU`"
                + " ,m.`NAME` AS NAMA_BARANG"
                + " ,p.`JANGKA_WAKTU`"
                + " ,p.`JATUH_TEMPO`"
                + " ,angs.JUMLAH_ANGSURAN AS ANGSURAN"
                + " ,p.`JUMLAH_PINJAMAN` + p.`DOWN_PAYMENT` AS TOTAL"
                + " ,COALESCE(pemb.PEMBAYARAN,0) AS PEMBAYARAN"
                + " ,(cbd.COST * cbd.QTY) AS COST"
                + " ,cbd.QTY AS QTY"
            + " FROM "
                + " sedana_raditya.`aiso_pinjaman` p"
                + " INNER JOIN pos_raditya.cash_bill_main cbm"
                    + " ON p.`CASH_BILL_MAIN_ID` = cbm.`CASH_BILL_MAIN_ID`"
                + " INNER JOIN "
                + " `sedana_raditya`.`cash_bill_detail` AS cbd "
                    + " ON cbm.`CASH_BILL_MAIN_ID` = cbd.CASH_BILL_MAIN_ID"
                + " INNER JOIN `sedana_raditya`.`pos_material` m "
                    + " ON cbd.MATERIAL_ID = m.MATERIAL_ID "
                + " INNER JOIN  (SELECT map.`MATERIAL_TYPE_MAPPING_ID`, map.`MATERIAL_ID`, ty.MASTER_CODE, ty.MASTER_NAME "
                    + " FROM pos_raditya.pos_material_type_mapping map "
                    + " INNER JOIN pos_raditya.master_type ty "
                        + " ON map.`TYPE_ID` = ty.`MASTER_TYPE_ID` "
                    + " INNER JOIN pos_raditya.master_group gr "
                        + " ON ty.`TYPE_GROUP` = gr.`TYPE_GROUP` "
                    + " WHERE gr.`TYPE_GROUP` = 1) AS map "
                        + " ON map.MATERIAL_ID = m.MATERIAL_ID "
                + " LEFT JOIN (SELECT p.`PINJAMAN_ID`, SUM(jd.`JUMLAH_ANGSURAN`) AS JUMLAH_ANGSURAN "
                    + " FROM `sedana_jadwal_angsuran` jd "
                    + " INNER JOIN aiso_pinjaman p "
                    + " ON jd.`PINJAMAN_ID` = p.`PINJAMAN_ID` "
                    + " AND jd.`TANGGAL_ANGSURAN` = DATE_ADD(p.`TGL_REALISASI`,INTERVAL 1 MONTH) "
                    + " GROUP BY p.`PINJAMAN_ID`) AS angs "
                        + " ON angs.PINJAMAN_ID = p.PINJAMAN_ID "
                + " LEFT JOIN (SELECT tr.`PINJAMAN_ID`, SUM(ags.`JUMLAH_ANGSURAN`) AS PEMBAYARAN "
                    + " FROM `aiso_angsuran` ags "
                    + " INNER JOIN `sedana_transaksi` tr "
                    + " ON ags.`TRANSAKSI_ID` = tr.`TRANSAKSI_ID` "
                    + " GROUP BY tr.`PINJAMAN_ID`) pemb "
                        + " ON pemb.PINJAMAN_ID = p.PINJAMAN_ID "
                + " INNER JOIN `pos_raditya`.`location` loc "
                    + " ON cbm.`LOCATION_ID` = loc.`LOCATION_ID` "
                + " INNER JOIN sedana_raditya.`contact_list` cl "
                    + " ON p.`ANGGOTA_ID` = cl.`CONTACT_ID` "
                + " INNER JOIN `pos_raditya`.`pos_app_user` usr "
                    + " ON cbm.`APP_USER_SALES_ID` = usr.USER_ID "
                + " LEFT JOIN `hr_raditya`.`hr_employee` mar "
                    + " ON mar.`EMPLOYEE_ID` = usr.`EMPLOYEE_ID` "
                + " LEFT JOIN `hr_raditya`.`hr_employee` ana"
                    + " ON p.`ACCOUNT_OFFICER_ID` = ana.`EMPLOYEE_ID` "
                + " LEFT JOIN `hr_raditya`.`hr_employee` kol"
                    + " ON p.`COLLECTOR_ID` = kol.`EMPLOYEE_ID`"
                + " WHERE p.TGL_REALISASI BETWEEN '"+startDate+"' AND '"+endDate+"' ";
        
                if (typeBayar == 1){
                    sql += " AND ((p.STATUS_PINJAMAN = 5 AND pemb.PEMBAYARAN IS NOT NULL) ";
                } else if (typeBayar == 2){
                    sql += " AND ((p.STATUS_PINJAMAN = 5 AND pemb.PEMBAYARAN IS NULL) ";
                }
                
                if (typeBayar>0){
                    if (inStatus.length()>0){
                        sql += " OR p.STATUS_PINJAMAN IN ("+inStatus+"))";
                    } else {
                        sql += ")";
                    }
                } else {
                    sql += " AND p.STATUS_PINJAMAN IN ("+inStatus+")";
                }
                
                if (inLocation.length()>0){
                    sql += " AND cbm.LOCATION_ID IN ("+inLocation+") ";
                }
        
                sql += " ORDER BY p.TGL_REALISASI DESC, p.PINJAMAN_ID  ";
                
                dbrs = DBHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                while (rs.next()) {

                    ReportKredit reportKredit = new ReportKredit();
                    reportKredit.setTglRealisasi(rs.getDate("TGL_REALISASI"));
                    reportKredit.setYear(rs.getInt("TAHUN"));
                    reportKredit.setMonth(rs.getInt("BULAN"));
                    reportKredit.setDay(rs.getInt("HARI"));
                    reportKredit.setNoPk(rs.getString("NO_KREDIT"));
                    reportKredit.setCabang(rs.getString("LOKASI"));
                    reportKredit.setNamaKonsumen(rs.getString("PERSON_NAME"));
                    reportKredit.setAddrKonsumen(rs.getString("HOME_ADDRESS"));
                    reportKredit.setCodeSales(rs.getString("EMPLOYEE_NUM"));
                    reportKredit.setNamaSales(rs.getString("FULL_NAME"));
                    reportKredit.setCodeAnalis(rs.getString("NUM_ANAL"));
                    reportKredit.setNamaAnalis(rs.getString("NAMA_ANAL"));
                    reportKredit.setCodeKolektor(rs.getString("NUM_KOL"));
                    reportKredit.setNamaKolektor(rs.getString("NAMA_KOL"));
                    reportKredit.setCodeGroup(rs.getString("MASTER_CODE"));
                    reportKredit.setNamaGroup(rs.getString("MASTER_NAME"));
                    reportKredit.setSkuItem(rs.getString("SKU"));
                    reportKredit.setNamaItem(rs.getString("NAMA_BARANG"));
                    reportKredit.setJangkaWaktu(rs.getInt("JANGKA_WAKTU"));
                    reportKredit.setJatuhTempo(rs.getDate("JATUH_TEMPO"));
                    reportKredit.setAngsuran(rs.getDouble("ANGSURAN"));
                    reportKredit.setTotal(rs.getDouble("TOTAL"));
                    reportKredit.setPembayaran(rs.getDouble("PEMBAYARAN"));
                    reportKredit.setCost(rs.getDouble("COST"));
                    reportKredit.setQty(rs.getInt("QTY"));
                    listData.add(reportKredit);
                }

                rs.close();
                
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
                
        return listData;
    }
    

    public static Vector listSisaPinjamanV2(String whereClause, String orderBy, String tglPencarian){
        Vector listData = new Vector();
        DBResultSet dbrs = null;
        
        
        if (tglPencarian.length()==0){
            tglPencarian = Formater.formatDate(new Date(), "yyyy-MM-dd");
        }
        
        try {
            String sql = "SELECT "
                + " p.`NO_KREDIT` "
                + " ,cl.`PERSON_NAME`"
                + " ,p.`JUMLAH_PINJAMAN` AS JUMLAH_KREDIT"
                + " ,p.DOWN_PAYMENT AS DP"
                + " ,p.`JANGKA_WAKTU`"
                + " ,loc.`NAME` AS LOKASI"
                + " ,kol.`FULL_NAME` AS NAMA_KOL"
                + " ,p.TGL_REALISASI"
                + " ,p.`JATUH_TEMPO`"
                + " ,angs.JUMLAH_ANGSURAN AS ANGSURAN"
                + " ,COALESCE(pokok.JUMLAH_ANGSURAN,0) - COALESCE(pembpokok.PEMBAYARAN,0) AS SISA_POKOK"
                + " ,COALESCE(bunga.JUMLAH_ANGSURAN,0) - COALESCE(pembbunga.PEMBAYARAN,0) AS SISA_BUNGA"
            + " FROM "
                + " `aiso_pinjaman` p"
                + " INNER JOIN cash_bill_main cbm"
                    + " ON p.`CASH_BILL_MAIN_ID` = cbm.`CASH_BILL_MAIN_ID`"
                + " LEFT JOIN (SELECT p.`PINJAMAN_ID`, SUM(jd.`JUMLAH_ANGSURAN`) AS JUMLAH_ANGSURAN "
                    + " FROM `sedana_jadwal_angsuran` jd "
                    + " INNER JOIN aiso_pinjaman p "
                    + " ON jd.`PINJAMAN_ID` = p.`PINJAMAN_ID` "
                    + " AND jd.`TANGGAL_ANGSURAN` = DATE_ADD(p.`TGL_REALISASI`,INTERVAL 1 MONTH) "
                    + " GROUP BY p.`PINJAMAN_ID`) AS angs "
                        + " ON angs.PINJAMAN_ID = p.PINJAMAN_ID "
                + " LEFT JOIN (SELECT p.`PINJAMAN_ID`, SUM(jd.`JUMLAH_ANGSURAN`) AS JUMLAH_ANGSURAN "
                    + " FROM `sedana_jadwal_angsuran` jd "
                    + " INNER JOIN aiso_pinjaman p "
                    + " ON jd.`PINJAMAN_ID` = p.`PINJAMAN_ID` "
                    + " AND jd.`JENIS_ANGSURAN` = 4 "
                    + " GROUP BY p.`PINJAMAN_ID`) AS pokok "
                        + " ON pokok.PINJAMAN_ID = p.PINJAMAN_ID "
                + " LEFT JOIN (SELECT p.`PINJAMAN_ID`, SUM(jd.`JUMLAH_ANGSURAN`) AS JUMLAH_ANGSURAN "
                    + " FROM `sedana_jadwal_angsuran` jd "
                    + " INNER JOIN aiso_pinjaman p "
                    + " ON jd.`PINJAMAN_ID` = p.`PINJAMAN_ID` "
                    + " AND jd.`JENIS_ANGSURAN` = 5 "
                    + " GROUP BY p.`PINJAMAN_ID`) AS bunga "
                        + " ON bunga.PINJAMAN_ID = p.PINJAMAN_ID "
                + " INNER JOIN (SELECT tr.`PINJAMAN_ID`, SUM(ags.`JUMLAH_ANGSURAN`) AS PEMBAYARAN "
                    + " FROM `aiso_angsuran` ags "
                    + " INNER JOIN `sedana_transaksi` tr "
                    + " ON ags.`TRANSAKSI_ID` = tr.`TRANSAKSI_ID` "
                    + " WHERE tr.TANGGAL_TRANSAKSI < '"+tglPencarian+" 23:59:00'"
                    + " GROUP BY tr.`PINJAMAN_ID`) pemb "
                        + " ON pemb.PINJAMAN_ID = p.PINJAMAN_ID "
                + " LEFT JOIN (SELECT tr.`PINJAMAN_ID`, SUM(ags.`JUMLAH_ANGSURAN`) AS PEMBAYARAN "
                    + " FROM `aiso_angsuran` ags "
                    + " INNER JOIN `sedana_transaksi` tr "
                    + " ON ags.`TRANSAKSI_ID` = tr.`TRANSAKSI_ID` "
                    + " INNER JOIN `sedana_jadwal_angsuran` jd "
                    + " ON jd.`JADWAL_ANGSURAN_ID` = ags.`JADWAL_ANGSURAN_ID` AND jd.`JENIS_ANGSURAN` = 4"
                    + " WHERE tr.TANGGAL_TRANSAKSI < '"+tglPencarian+" 23:59:00'"
                    + " GROUP BY tr.`PINJAMAN_ID`) pembpokok "
                        + " ON pembpokok.PINJAMAN_ID = p.PINJAMAN_ID "
                + " LEFT JOIN (SELECT tr.`PINJAMAN_ID`, SUM(ags.`JUMLAH_ANGSURAN`) AS PEMBAYARAN "
                    + " FROM `aiso_angsuran` ags "
                    + " INNER JOIN `sedana_transaksi` tr "
                    + " ON ags.`TRANSAKSI_ID` = tr.`TRANSAKSI_ID` "
                    + " INNER JOIN `sedana_jadwal_angsuran` jd "
                    + " ON jd.`JADWAL_ANGSURAN_ID` = ags.`JADWAL_ANGSURAN_ID` AND jd.`JENIS_ANGSURAN` = 5"
                    + " WHERE tr.TANGGAL_TRANSAKSI < '"+tglPencarian+" 23:59:00'"
                    + " GROUP BY tr.`PINJAMAN_ID`) pembbunga "
                        + " ON pembbunga.PINJAMAN_ID = p.PINJAMAN_ID "
                + " INNER JOIN `pos_raditya`.`location` loc "
                    + " ON cbm.`LOCATION_ID` = loc.`LOCATION_ID` "
                + " INNER JOIN `contact_list` cl "
                    + " ON p.`ANGGOTA_ID` = cl.`CONTACT_ID` "
                + " LEFT JOIN `hr_raditya`.`hr_employee` kol"
                    + " ON p.`COLLECTOR_ID` = kol.`EMPLOYEE_ID`";
        
                if (whereClause.length()>0){
                    sql += " WHERE "+whereClause;
                }
        
                sql += " ORDER BY p.TGL_REALISASI";
                
                dbrs = DBHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                while (rs.next()) {

                    ReportKredit reportKredit = new ReportKredit();
                    reportKredit.setTglRealisasi(rs.getDate("TGL_REALISASI"));
                    reportKredit.setNoPk(rs.getString("NO_KREDIT"));
                    reportKredit.setCabang(rs.getString("LOKASI"));
                    reportKredit.setNamaKonsumen(rs.getString("PERSON_NAME"));
                    reportKredit.setNamaKolektor(rs.getString("NAMA_KOL"));
                    reportKredit.setJangkaWaktu(rs.getInt("JANGKA_WAKTU"));
                    reportKredit.setJatuhTempo(rs.getDate("JATUH_TEMPO"));
                    reportKredit.setAngsuran(rs.getDouble("ANGSURAN"));
                    reportKredit.setJmlKredit(rs.getDouble("JUMLAH_KREDIT"));
                    reportKredit.setJmlDp(rs.getDouble("DP"));
                    reportKredit.setSisaPokok(rs.getDouble("SISA_POKOK"));
                    reportKredit.setSisaBunga(rs.getDouble("SISA_BUNGA"));
                    listData.add(reportKredit);
                }

                rs.close();
                
        } catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            DBResultSet.close(dbrs);
        }
                
        return listData;
    }
    
    public static HashMap<String,Double> rangkumanKolekBulanan(int type, String startMonth, String endMonth, String inLocation, int showLunas){
        Vector listData = new Vector();
        DBResultSet dbrs = null;
        DateFormat formater = new SimpleDateFormat("MMMM yyyy");
        
        Calendar start = Calendar.getInstance();
        Calendar end = Calendar.getInstance();
        
        try {
            start.setTime(formater.parse(startMonth));
            end.setTime(formater.parse(endMonth));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        HashMap<String,Double> mapKolek = new HashMap<>();
        String select = "";
        String query = "";
        
        Vector list = PstKolektibilitasPembayaran.listJoin(0, 0, "", "det."+PstKolektibilitasPembayaranDetails.fieldNames[PstKolektibilitasPembayaranDetails.FLD_MAXHARITUNGGAKANPOKOK]);
        
        while (start.before(end) || start.equals(end)) {
            start.set(Calendar.DAY_OF_MONTH, start.getActualMaximum(Calendar.DAY_OF_MONTH));
            
            try {
                String status = "";
                for (int i = 0; i < list.size();i++){
                    KolektibilitasPembayaran kolek = (KolektibilitasPembayaran) list.get(i);
                    if (i == 0){
                        status += "IF(DATEDIFF(jd.`TANGGAL_ANGSURAN`,pemb.TANGGAL_ANGSURAN) = 0, '"+kolek.getJudulKolektibilitas()+"',";
                    }
                    if ((i+1) == list.size()){
                        status += "'"+kolek.getJudulKolektibilitas()+"'))) AS STATUS";
                    } else {
                    status += "IF(DATEDIFF('"+Formater.formatDate(start.getTime(), "yyyy-MM-dd")+"',"
                            + "IF(DATEDIFF(jd.`TANGGAL_ANGSURAN`,pemb.TANGGAL_ANGSURAN) > 0 , DATE_ADD(pemb.TANGGAL_ANGSURAN, INTERVAL 1 MONTH), jd.`TANGGAL_ANGSURAN`))"
                            + " <="+kolek.getMaxHariTunggakanPokok()+", '"+kolek.getJudulKolektibilitas()+"', ";
                    }

                }
                String sql = "SELECT "
                    + " dt.STATUS"
                    + ", COUNT(dt.NO_KREDIT) AS JUMLAH"
                    + ", SUM(dt.SISA) AS SISA"
                    + " FROM "
                    + "(SELECT "
                        + "p.`NO_KREDIT`,"
                        + "pemb.TANGGAL_ANGSURAN AS TGL_TERAKHIR_BAYAR"
                        + ", "+status
                        + ", IF(DATEDIFF(MAX(jd.`TANGGAL_ANGSURAN`),MAX(pemb.TANGGAL_ANGSURAN)) > 0 , DATE_ADD(MAX(pemb.TANGGAL_ANGSURAN), INTERVAL 1 MONTH), MAX(jd.`TANGGAL_ANGSURAN`)) AS JADWAL_BELUM_BAYAR"
                        + ", jml.JUMLAH - pemb.JML_DIBAYAR AS SISA"
                        + " FROM "
                            + " aiso_pinjaman p "
                            + " INNER JOIN cash_bill_main cbm "
                                + "ON cbm.CASH_BILL_MAIN_ID = p.CASH_BILL_MAIN_ID"
                            + " INNER JOIN (SELECT PINJAMAN_ID, MAX(TANGGAL_ANGSURAN) AS TANGGAL_ANGSURAN, SUM(`JUMLAH_ANGSURAN`) AS JUMLAH FROM sedana_jadwal_angsuran WHERE `TANGGAL_ANGSURAN` <= '"+Formater.formatDate(start.getTime(), "yyyy-MM-dd")+"' GROUP BY PINJAMAN_ID) AS jd "
                                + "ON p.`PINJAMAN_ID` = jd.`PINJAMAN_ID` "
                            + " INNER JOIN (SELECT PINJAMAN_ID, SUM(`JUMLAH_ANGSURAN`) AS JUMLAH FROM sedana_jadwal_angsuran GROUP BY PINJAMAN_ID) AS jml "
                                + "ON p.`PINJAMAN_ID` = jml.`PINJAMAN_ID` "
                            + "INNER JOIN "
                                + "(SELECT p.PINJAMAN_ID, MAX(listlunas.TANGGAL_ANGSURAN) AS TANGGAL_ANGSURAN, SUM(listlunas.JML_DIBAYAR) AS JML_DIBAYAR "
                                + "FROM `aiso_pinjaman` p "
                                + "INNER JOIN "
                                    + "(SELECT p.`PINJAMAN_ID`, jd.`TANGGAL_ANGSURAN`, SUM(jd.`JUMLAH_ANGSURAN`) AS JML_ANGSURAN, SUM(pemb.JML_DIBAYAR) AS JML_DIBAYAR "
                                    + "FROM `sedana_jadwal_angsuran` AS jd "
                                        + "INNER JOIN aiso_pinjaman p "
                                            + " ON jd.`PINJAMAN_ID` = p.`PINJAMAN_ID` "
                                        + "INNER JOIN "
                                            + "(SELECT ags.`JADWAL_ANGSURAN_ID`, SUM(ags.`JUMLAH_ANGSURAN`) AS JML_DIBAYAR "
                                            + " FROM aiso_angsuran ags "
                                            + " INNER JOIN `sedana_transaksi` tr "
                                                + " ON ags.`TRANSAKSI_ID` = tr.`TRANSAKSI_ID` AND tr.`TANGGAL_TRANSAKSI` <= '"+Formater.formatDate(start.getTime(), "yyyy-MM-dd")+" 23:59:00' "
                                            + "GROUP BY ags.`JADWAL_ANGSURAN_ID`) AS pemb "
                                            + "ON pemb.JADWAL_ANGSURAN_ID = jd.`JADWAL_ANGSURAN_ID` "
                                        + "GROUP BY jd.`TANGGAL_ANGSURAN`, p.`NO_KREDIT` "
                                    + " HAVING JML_ANGSURAN = JML_DIBAYAR) AS listlunas"
                                    + " ON listlunas.PINJAMAN_ID = p.`PINJAMAN_ID` GROUP BY p.PINJAMAN_ID) AS pemb "
                                    + "ON pemb.PINJAMAN_ID = p.`PINJAMAN_ID` "
                            + " WHERE p.STATUS_PINJAMAN = 5";
                            if (inLocation.length() > 0){
                                sql += " AND cbm.LOCATION_ID IN ("+inLocation+")";
                            }
                    sql += " GROUP BY p.`NO_KREDIT` ";
                            if (showLunas == 1){
                                sql += " HAVING SISA > 0 OR MONTH(TGL_TERAKHIR_BAYAR) = MONTH('"+Formater.formatDate(start.getTime(), "yyyy-MM-dd")+"')";
                            } else {
                                sql += " HAVING SISA > 0";
                            }
                            sql += ") as dt "
                    + " GROUP BY dt.STATUS ";
                    
                    dbrs = DBHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    while (rs.next()) {
                        String bulan = Formater.formatDate(start.getTime(), "MMMM");
                        
                        mapKolek.put(rs.getString("STATUS")+"_"+bulan+"_SISA", rs.getDouble("SISA"));
                        mapKolek.put(rs.getString("STATUS")+"_"+bulan+"_JUMLAH", rs.getDouble("JUMLAH"));
                    }

                    rs.close();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            } finally {
                DBResultSet.close(dbrs);
            }
            start.add(Calendar.MONTH, 1);
            start.set(Calendar.DAY_OF_MONTH, start.getActualMinimum(Calendar.DAY_OF_MONTH));
        }
        
        
        return mapKolek;
    }
    
    public static Vector listPencapaian(String startDate, String endDate, int group, String whereClause){
        Vector list = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                            + "SUM(QTY_ESTIMASI) AS QTY_ESTIMASI,"
                            + "SUM(AMOUNT_ESTIMASI) AS AMOUNT_ESTIMASI,"
                            + "SUM(QTY_REALISASI) AS QTY_REALISASI,"
                            + "SUM(AMOUNT_REALISASI) AS AMOUNT_REALISASI,"
                            + "TANGGAL_ANGSURAN,"
                            + "COLLECTOR_ID"
                        + " FROM "
                            + "(SELECT "
                                + "jd.`TANGGAL_ANGSURAN`,"
                                + "count(jd.`JADWAL_ANGSURAN_ID`) AS QTY_ESTIMASI,"
                                + "SUM(jd.`JUMLAH_ANGSURAN`) AS AMOUNT_ESTIMASI,"
                                + "0 as QTY_REALISASI,"
                                + "0 as AMOUNT_REALISASI,"
                                + "p.`COLLECTOR_ID`"
                            + " FROM "
                                + "`aiso_pinjaman` p "
                                + "INNER JOIN "
                                    + "(SELECT j.`PINJAMAN_ID`, j.`JADWAL_ANGSURAN_ID`, j.`TANGGAL_ANGSURAN`, SUM(j.`JUMLAH_ANGSURAN`) AS JUMLAH_ANGSURAN "
                                    + "FROM "
                                        + "`sedana_jadwal_angsuran` j "
                                    + "WHERE j.TANGGAL_ANGSURAN BETWEEN '"+startDate+"' AND '"+endDate+"' "
                                    + "GROUP BY pinjaman_id, `TANGGAL_ANGSURAN`) AS jd "
                                    + "ON jd.PINJAMAN_ID = p.`PINJAMAN_ID` "
                                + "inner join "
                                    + "(SELECT PINJAMAN_ID, MIN(TANGGAL_TRANSAKSI) AS TANGGAL_TRANSAKSI FROM sedana_transaksi GROUP BY PINJAMAN_ID) as tr "
                                    + "on p.`PINJAMAN_ID` = tr.PINJAMAN_ID "
                                + "inner join `cash_bill_main` cbm "
                                    + "on cbm.`CASH_BILL_MAIN_ID` = p.`CASH_BILL_MAIN_ID` "
                                + "inner join location loc "
                                    + "on loc.`LOCATION_ID` = cbm.`LOCATION_ID` "
                            + "WHERE "+whereClause
                            + " group by jd.`TANGGAL_ANGSURAN`, p.`COLLECTOR_ID` "
                            + "UNION "
                            + "select "
                                + "TANGGAL_ANGSURAN,"
                                + "0 as QTY_ESTIMASI,"
                                + "0 AS AMOUNT_ESTIMASI,"
                                + "COUNT(JADWAL_ANGSURAN_ID) AS QTY_REALISASI,"
                                + "0 AS AMOUNT_REALISASI,"
                                + "COLLECTOR_ID"
                            + " FROM "
                                + "(select "
                                    + "jd.`JADWAL_ANGSURAN_ID`, "
                                    + "jd.`TANGGAL_ANGSURAN`, "
                                    + "jd.`JUMLAH_ANGSURAN`,"
                                    + "jd.dibayar,"
                                    + "loc.`NAME`,"
                                    + "loc.`CODE`,"
                                    + "p.`COLLECTOR_ID`"
                                + " FROM "
                                    + "`aiso_pinjaman` p "
                                    + "INNER JOIN "
                                        + "(SELECT j.`PINJAMAN_ID`, j.`JADWAL_ANGSURAN_ID`, j.`TANGGAL_ANGSURAN`, SUM(j.`JUMLAH_ANGSURAN`) AS JUMLAH_ANGSURAN, SUM(ags.`JUMLAH_ANGSURAN`) AS dibayar "
                                        + "FROM "
                                            + "`sedana_jadwal_angsuran` j "
                                            + "INNER JOIN ("
                                                + "SELECT SUM(`JUMLAH_ANGSURAN`) AS JUMLAH_ANGSURAN, `JADWAL_ANGSURAN_ID` FROM "
                                            + "aiso_angsuran  GROUP BY JADWAL_ANGSURAN_ID) AS ags "
                                                + "ON j.`JADWAL_ANGSURAN_ID` = ags.`JADWAL_ANGSURAN_ID` "
                                        + "WHERE j.TANGGAL_ANGSURAN BETWEEN '"+startDate+"' AND '"+endDate+"' "
                                        + "GROUP BY pinjaman_id, `TANGGAL_ANGSURAN`) AS jd "
                                        + "ON jd.PINJAMAN_ID = p.`PINJAMAN_ID` "
                                    + "inner join `cash_bill_main` cbm "
                                        + "on cbm.`CASH_BILL_MAIN_ID` = p.`CASH_BILL_MAIN_ID` "
                                    + "inner join location loc "
                                        + "on loc.`LOCATION_ID` = cbm.`LOCATION_ID` "
                                + "WHERE "+whereClause
                                + " having (jd.`JUMLAH_ANGSURAN` - jd.`dibayar`) = 0) as data "
                            + "group BY TANGGAL_ANGSURAN,`COLLECTOR_ID` "
                            + "UNION "
                            + "select "
                                + "TANGGAL_ANGSURAN,"
                                + "0 AS QTY_ESTIMASI, "
                                + "0 AS AMOUNT_ESTIMASI, "
                                + "0 AS QTY_REALISASI, "
                                + "SUM(dibayar) AS AMOUNT_REALISASI, "
                                + "COLLECTOR_ID "
                            + "FROM "
                               + "(select "
                                    + "jd.`JADWAL_ANGSURAN_ID`, "
                                    + "jd.`TANGGAL_ANGSURAN`, "
                                    + "jd.`JUMLAH_ANGSURAN`,"
                                    + "jd.dibayar,"
                                    + "loc.`NAME`,"
                                    + "loc.`CODE`, "
                                    + "p.`COLLECTOR_ID`"
                                + " FROM "
                                    + "`aiso_pinjaman` p "
                                    + "INNER JOIN "
                                        + "(SELECT j.`PINJAMAN_ID`, j.`JADWAL_ANGSURAN_ID`, j.`TANGGAL_ANGSURAN`, j.`JUMLAH_ANGSURAN` AS JUMLAH_ANGSURAN, SUM(ags.`JUMLAH_ANGSURAN`) AS dibayar "
                                        + "FROM "
                                            + "`sedana_jadwal_angsuran` j "
                                            + "INNER JOIN ("
                                                + "SELECT SUM(`JUMLAH_ANGSURAN`) AS JUMLAH_ANGSURAN, `JADWAL_ANGSURAN_ID` FROM "
                                            + "aiso_angsuran  GROUP BY JADWAL_ANGSURAN_ID) AS ags "
                                                + "ON j.`JADWAL_ANGSURAN_ID` = ags.`JADWAL_ANGSURAN_ID` "
                                        + "WHERE j.TANGGAL_ANGSURAN BETWEEN '"+startDate+"' AND '"+endDate+"' "
                                        + "GROUP BY pinjaman_id, `TANGGAL_ANGSURAN`) AS jd "
                                        + "ON jd.PINJAMAN_ID = p.`PINJAMAN_ID` "
                                    + "inner join `cash_bill_main` cbm "
                                        + "on cbm.`CASH_BILL_MAIN_ID` = p.`CASH_BILL_MAIN_ID` "
                                    + "inner join location loc "
                                        + "on loc.`LOCATION_ID` = cbm.`LOCATION_ID` "
                                + "WHERE "+whereClause+" ) as data "
                            + " group BY TANGGAL_ANGSURAN, `COLLECTOR_ID`) as data "
                        + "group BY TANGGAL_ANGSURAN " + ( group == 0 ? ", `COLLECTOR_ID` " : "" ) + " ORDER BY "+ ( group == 0 ? "`COLLECTOR_ID`, " : "" ) +" TANGGAL_ANGSURAN ASC";
            System.out.println("SQL :"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ReportKredit reportKredit = new ReportKredit();
                reportKredit.setTglAngs(rs.getString("TANGGAL_ANGSURAN"));
                reportKredit.setQtyEst(rs.getInt("QTY_ESTIMASI"));
                reportKredit.setJumEst(rs.getDouble("AMOUNT_ESTIMASI"));
                reportKredit.setQtyReal(rs.getInt("QTY_REALISASI"));
                reportKredit.setJumReal(rs.getDouble("AMOUNT_REALISASI"));
                reportKredit.setOidCollector(rs.getLong("COLLECTOR_ID"));
                list.add(reportKredit);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }

        return list;
    }
    
}
