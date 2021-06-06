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
import com.dimata.aiso.entity.masterdata.mastertabungan.PstJenisKredit;
import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.pos.entity.billing.BillMain;
import com.dimata.pos.entity.billing.PstBillMain;
import java.util.Vector;
import com.dimata.qdep.db.*;
import com.dimata.sedana.entity.assigncontacttabungan.PstAssignContactTabungan;
import com.dimata.sedana.entity.assigntabungan.PstAssignTabungan;
import com.dimata.sedana.entity.kredit.*;
import com.dimata.sedana.entity.masterdata.*;
import com.dimata.sedana.entity.tabungan.*;
import com.dimata.util.Formater;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.concurrent.TimeUnit;

/**
 *
 * @author Dimata 007
 */
public class SessKredit {

    public static Vector listTabunganBebas(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + PstJenisSimpanan.TBL_JENISSIMPANAN + " AS js "
                    + " INNER JOIN " + PstAssignTabungan.TBL_ASSIGNTABUNGAN + " AS asstab "
                    + " ON asstab." + PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_ID_JENIS_SIMPANAN] + " = js." + PstJenisSimpanan.fieldNames[PstJenisSimpanan.FLD_ID_JENIS_SIMPANAN]
                    + " INNER JOIN " + PstMasterTabungan.TBL_MASTERTABUNGAN + " AS mastab "
                    + " ON mastab." + PstMasterTabungan.fieldNames[PstMasterTabungan.FLD_MASTER_TABUNGAN_ID] + " = asstab." + PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN]
                    + " INNER JOIN " + PstAssignContactTabungan.TBL_ASSIGNCONTACTTABUNGAN + " AS asscontab "
                    + " ON `asscontab`." + PstAssignContactTabungan.fieldNames[PstAssignContactTabungan.FLD_MASTER_TABUNGAN_ID] + " = asstab." + PstAssignTabungan.fieldNames[PstAssignTabungan.FLD_MASTER_TABUNGAN]
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
                JenisSimpanan jenisSimpanan = new JenisSimpanan();
                PstJenisSimpanan.resultToObject(rs, jenisSimpanan);
                lists.add(jenisSimpanan);
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

    public static Vector checkJadwalTerlambat(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT jadwal.*, pinjaman.* "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS pinjaman "
                    + " ON pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]
                    + " AND pinjaman." + PstPinjaman.fieldNames[PstPinjaman.FLD_STATUS_PINJAMAN] + " = '" + Pinjaman.STATUS_DOC_CAIR + "'"
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
                Vector data = new Vector();
                JadwalAngsuran jadwalAngsuran = new JadwalAngsuran();
                PstJadwalAngsuran.resultToObject(rs, jadwalAngsuran);
                data.add(jadwalAngsuran);
                Pinjaman pinjaman = new Pinjaman();
                PstPinjaman.resultToObject(rs, pinjaman);
                data.add(pinjaman);
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

    public static Vector getJadwalSudahDibayar(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT angsuran.*"
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " ON angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID]
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
                Angsuran angsuran = new Angsuran();
                PstAngsuran.resultToObject(rs, angsuran);
                lists.add(angsuran);
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

    public static Vector getBiayaKredit(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT pd.* "
                    + " FROM " + PstBiayaTransaksi.TBL_BIAYA_TRANSAKSI + " AS pd "
                    + " INNER JOIN " + PstJenisTransaksi.TBL_JENISTRANSAKSI + " AS jt "
                    + " ON jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI_ID]
                    + " = pd." + PstBiayaTransaksi.fieldNames[PstBiayaTransaksi.FLD_ID_JENIS_TRANSAKSI]
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
                BiayaTransaksi biayaTransaksi = new BiayaTransaksi();
                PstBiayaTransaksi.resultToObject(rs, biayaTransaksi);
                lists.add(biayaTransaksi);
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

    public static double getTotalBayarSebelumTempo(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ")"
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " ON jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " INNER JOIN " + PstTransaksi.TBL_TRANSAKSI + " AS transaksi "
                    + " ON transaksi." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " = angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID]
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

    public static int getCountJadwalDenda(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(DISTINCT(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ")) FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
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

    public static int getCountListTransaksiKredit(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + ") "
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " ON p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstAnggota.TBL_ANGGOTA + " AS a "
                    + " ON a." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS bm "
                    + " ON bm." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " INNER JOIN " + PstLocation.TBL_P2_LOCATION + " AS loc "
                    + " ON loc." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " = bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID]
                    + " LEFT JOIN " + PstAppUser.TBL_APP_USER + " AS u "
                    + " ON u." + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_APP_USER_ID]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
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
    public static int getCountListReturn(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID] + ") "
                    + " FROM " + PstReturnKredit.TBL_RETURNKREDIT + " AS r "
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " ON p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS bm "
                    + " ON bm." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " INNER JOIN " + PstContactList.TBL_CONTACT_LIST + " AS con "
                    + " ON con." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
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
    
    public static int getCountListHapus(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_HAPUS_ID] + ") "
                    + " FROM " + PstHapusKredit.TBL_HAPUSKREDIT + " AS h "
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " ON p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS bm "
                    + " ON bm." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " INNER JOIN " + PstContactList.TBL_CONTACT_LIST + " AS con "
                    + " ON con." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
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

    public static Vector getListTransaksiKredit(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * "
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " ON p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstAnggota.TBL_ANGGOTA + " AS a "
                    + " ON a." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS bm "
                    + " ON bm." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " INNER JOIN " + PstLocation.TBL_P2_LOCATION + " AS loc "
                    + " ON loc." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " = bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID]
                    + " LEFT JOIN " + PstAppUser.TBL_APP_USER + " AS u "
                    + " ON u." + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_APP_USER_ID]
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
                Transaksi transaksi = new Transaksi();
                PstTransaksi.resultToObject(rs, transaksi);
                lists.add(transaksi);
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
    
    public static Vector getListReport(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + "t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]
                    + ",t." + PstTransaksi.fieldNames[PstTransaksi.FLD_KETERANGAN]
                    + ",t." + PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI]
                    + ",t." + PstTransaksi.fieldNames[PstTransaksi.FLD_APP_USER_ID]
                    + ",t." + PstTransaksi.fieldNames[PstTransaksi.FLD_STATUS]
                    + ",cl." + PstAnggota.fieldNames[PstAnggota.FLD_NAME]
                    + ",loc." + PstLocation.fieldNames[PstLocation.FLD_NAME]
                    + ",p." + PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]
                    + ",(SELECT SUM(JUMLAH) FROM `sedana_angsuran_payment` WHERE TRANSAKSI_ID = t.TRANSAKSI_ID) AS JUMLAH"
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " ON p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstAnggota.TBL_ANGGOTA + " AS a "
                    + " ON a." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS bm "
                    + " ON bm." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " INNER JOIN " + PstLocation.TBL_P2_LOCATION + " AS loc "
                    + " ON loc." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " = bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID]
                    + " INNER JOIN " + PstAnggota.TBL_ANGGOTA + " AS cl "
                    + " ON p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID] + " = cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + " LEFT JOIN " + PstAppUser.TBL_APP_USER + " AS u "
                    + " ON u." + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_APP_USER_ID]
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
                Vector temp = new Vector();
                Transaksi tr = new Transaksi();
                tr.setTanggalTransaksi(Formater.formatDate(rs.getString(PstTransaksi.fieldNames[PstTransaksi.FLD_TANGGAL_TRANSAKSI]), "yyyy-MM-dd HH:mm:ss"));
                tr.setKeterangan(rs.getString(PstTransaksi.fieldNames[PstTransaksi.FLD_KETERANGAN]));
                tr.setKodeBuktiTransaksi(rs.getString(PstTransaksi.fieldNames[PstTransaksi.FLD_KODE_BUKTI_TRANSAKSI]));
                tr.setAppUserId(rs.getLong(PstTransaksi.fieldNames[PstTransaksi.FLD_APP_USER_ID]));
                tr.setStatus(rs.getInt(PstTransaksi.fieldNames[PstTransaksi.FLD_STATUS]));
                temp.add(tr);
                
                Anggota ang = new Anggota();
                ang.setName(rs.getString(PstAnggota.fieldNames[PstAnggota.FLD_NAME]));
                temp.add(ang);
                
                Location loc = new Location();
                loc.setName(rs.getString(PstLocation.fieldNames[PstLocation.FLD_NAME]));
                temp.add(loc);
                
                Pinjaman p = new Pinjaman();
                p.setNoKredit(rs.getString(PstPinjaman.fieldNames[PstPinjaman.FLD_NO_KREDIT]));
                temp.add(p);
                
                AngsuranPayment ap = new AngsuranPayment();
                ap.setJumlah(rs.getDouble(PstAngsuranPayment.fieldNames[PstAngsuranPayment.FLD_JUMLAH]));
                temp.add(ap);
                
                lists.add(temp);
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
    
    public static double getSumTransaksi(String whereClause) {
        double total = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM("+PstAngsuranPayment.fieldNames[PstAngsuranPayment.FLD_JUMLAH]+") "
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " ON p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstAngsuranPayment.TBL_ANGSURANPAYMENT + " AS angs "
                    + " ON angs." + PstAngsuranPayment.fieldNames[PstAngsuranPayment.FLD_TRANSAKSI_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]
                    + " INNER JOIN " + PstAnggota.TBL_ANGGOTA + " AS a "
                    + " ON a." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS bm "
                    + " ON bm." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " INNER JOIN " + PstLocation.TBL_P2_LOCATION + " AS loc "
                    + " ON loc." + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " = bm." + PstBillMain.fieldNames[PstBillMain.FLD_LOCATION_ID]
                    + " LEFT JOIN " + PstAppUser.TBL_APP_USER + " AS u "
                    + " ON u." + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_APP_USER_ID]
                    + " WHERE "+whereClause;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total = rs.getDouble(1);
            }
            rs.close();
            return total;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return total;
    }
    
    public static Vector getListReturn(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + " r.`NOMOR_RETURN`, "
                    + " r.`TANGGAL_RETURN`, "
                    + " con.`PERSON_NAME`, "
                    + " r.`CATATAN`, "
                    + " r.`STATUS`, "
                    + " r.`PINJAMAN_ID`, "
                    + " r.`RETURN_ID` "
                    + " FROM " + PstReturnKredit.TBL_RETURNKREDIT + " AS r "
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " ON p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = r." + PstReturnKredit.fieldNames[PstReturnKredit.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS bm "
                    + " ON bm." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " INNER JOIN " + PstContactList.TBL_CONTACT_LIST + " AS con "
                    + " ON con." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
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
              Vector temp = new Vector();
                ReturnKredit ret = new ReturnKredit();
                ContactList con = new ContactList();
                
                ret.setNomorReturn(rs.getString(1));
                ret.setTanggalReturn(rs.getDate(2));
                ret.setCatatan(rs.getString(4));
                ret.setStatus(rs.getInt(5));
                ret.setPinjamanId(rs.getLong(6));
                ret.setOID(rs.getLong(7));
                temp.add(ret);
                
                con.setPersonName(rs.getString(3));
                temp.add(con);
                
                lists.add(temp);
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
    
    public static Vector getListHapus(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + " h.`NOMOR_HAPUS`, "
                    + " h.`TANGGAL_HAPUS`, "
                    + " con.`PERSON_NAME`, "
                    + " h.`CATATAN`, "
                    + " h.`STATUS`, "
                    + " h.`PINJAMAN_ID`, "
                    + " h.`HAPUS_ID` "
                    + " FROM " + PstHapusKredit.TBL_HAPUSKREDIT + " AS h "
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " ON p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = h." + PstHapusKredit.fieldNames[PstHapusKredit.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " AS bm "
                    + " ON bm." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " INNER JOIN " + PstContactList.TBL_CONTACT_LIST + " AS con "
                    + " ON con." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID] + " = p." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
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
              Vector temp = new Vector();
                HapusKredit hap = new HapusKredit();
                ContactList con = new ContactList();
                
                hap.setNomorHapus(rs.getString(1));
                hap.setTanggalHapus(rs.getDate(2));
                hap.setCatatan(rs.getString(4));
                hap.setStatus(rs.getInt(5));
                hap.setPinjamanId(rs.getLong(6));
                hap.setOID(rs.getLong(7));
                temp.add(hap);
                
                con.setPersonName(rs.getString(3));
                temp.add(con);
                
                lists.add(temp);
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

    public static Vector getTransaksiPencairanKredit(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * "
                    + " FROM " + PstDetailTransaksi.TBL_DETAILTRANSAKSI + " AS dt "
                    + " INNER JOIN " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " ON t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " = dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_TRANSAKSI_ID]
                    + " INNER JOIN " + PstJenisTransaksi.TBL_JENISTRANSAKSI + " AS jt "
                    + " ON jt." + PstJenisTransaksi.fieldNames[PstJenisTransaksi.FLD_JENIS_TRANSAKSI_ID] + " = dt." + PstDetailTransaksi.fieldNames[PstDetailTransaksi.FLD_JENIS_TRANSAKSI_ID]
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
                DetailTransaksi detailTransaksi = new DetailTransaksi();
                PstDetailTransaksi.resultToObject(rs, detailTransaksi);
                lists.add(detailTransaksi);
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

    public static Vector getListTransaksiAngsuran(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * "
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS t "
                    + " INNER JOIN " + PstPinjaman.TBL_PINJAMAN + " AS p "
                    + " ON p." + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID]
                    + " INNER JOIN " + PstAngsuran.TBL_ANGSURAN + " AS a "
                    + " ON a." + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID] + " = t." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID]
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS ja "
                    + " ON ja." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = a." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
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
                Transaksi transaksi = new Transaksi();
                PstTransaksi.resultToObject(rs, transaksi);
                lists.add(transaksi);
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

    public static Vector getListSisaJadwalBunga(long idPinjaman, int jenisAngsuran) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN
                    + " WHERE " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "'"
                    + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " NOT IN "
                    + " ("
                    + " SELECT lunas.id FROM ("
                    + " SELECT "
                    + " jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " AS id, "
                    + " jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + " AS jumlah, "
                    + " SUM(angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS bayar "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " INNER JOIN " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " ON angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + ""
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + jenisAngsuran + "'"
                    + " GROUP BY angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + ""
                    + " HAVING bayar >= jumlah ) AS lunas "
                    + ")"
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                JadwalAngsuran jadwalAngsuran = new JadwalAngsuran();
                PstJadwalAngsuran.resultToObject(rs, jadwalAngsuran);
                lists.add(jadwalAngsuran);
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

    public static Vector getListJadwalPrioritas(long idPinjaman, String year, String month) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * ,"
                    + " SUM(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS denda "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN
                    + " WHERE " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                    + " AND ("
                    + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = '" + JadwalAngsuran.TIPE_ANGSURAN_DENDA + "'"
                    + " OR ("
                    + " YEAR(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") = '" + year + "'"
                    + " AND MONTH(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ") = '" + month + "'"
                    + ")"
                    + ")"
                    + " GROUP BY " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + ", "
                    + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]
                    + " ORDER BY " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " DESC "
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                JadwalAngsuran jadwalAngsuran = new JadwalAngsuran();
                PstJadwalAngsuran.resultToObject(rs, jadwalAngsuran);
                lists.add(jadwalAngsuran);
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

    public static Vector getListDenda(String startDate, String endDate, int jenisAngsuran) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String start[] = startDate.split("-");
            String end[] = startDate.split("-");
            String sql = "SELECT "
                    + "" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]
                    + "," + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]
                    + ", SUM(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN]
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN
                    + " WHERE " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + " = " + jenisAngsuran
                    + " AND ("
                    + "(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_START_DATE] + " BETWEEN '" + startDate + "' AND '" + endDate + "')"
                    + " OR "
                    + "(" + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_END_DATE] + " BETWEEN '" + startDate + "' AND '" + endDate + "')"
                    + " OR "
                    + "('" + startDate + "') BETWEEN " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_START_DATE] + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_END_DATE]
                    + " OR "
                    + "('" + endDate + "') BETWEEN " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_START_DATE] + " AND " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_END_DATE]
                    + " OR ( "
                    + "      MONTH(TANGGAL_ANGSURAN) BETWEEN '" + start[1] + "' AND '" + end[1] + "'"
                    + "      AND YEAR(TANGGAL_ANGSURAN) BETWEEN '" + end[0] + "' AND '" + end[0] + "'"
                    + "      AND START_DATE IS NULL "
                    + "      AND END_DATE IS NULL "
                    + "    )"
                    + ")"
                    + " GROUP BY " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]
                    + "," + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]
                    + " ORDER BY " + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                JadwalAngsuran jadwalAngsuran = new JadwalAngsuran();
                jadwalAngsuran.setPinjamanId(rs.getLong(PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID]));
                jadwalAngsuran.setTanggalAngsuran(rs.getDate(PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]));
                jadwalAngsuran.setJumlahANgsuran(rs.getDouble(PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN]));
                lists.add(jadwalAngsuran);
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

    public static double getTotalAngsuran(long idPinjaman) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS total "
                    + " FROM " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' "
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

    public static double getTotalAngsuranDibayar(long idPinjaman) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS dibayar"
                    + " FROM " + PstAngsuran.TBL_ANGSURAN + " AS angsuran "
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " ON jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " WHERE jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
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

    public static Vector getListAngsuranByPinjaman(long idPinjaman) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + PstAngsuran.TBL_ANGSURAN + " AS ang "
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jad "
                    + " ON jad." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = ang." + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]
                    + " WHERE jad." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                    + "";
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                lists.add(null);
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

    public static String getRumusDenda(MappingDendaPinjaman mdp) {
        String tipePerhitungan[] = {"Sisa", "Full"};
        String akumulasi = true ? "Seluruh" : "";
        String perjadwal = true ? "" : JenisKredit.TIPE_VARIABEL_DENDA_TITLE[JenisKredit.TIPE_VARIABEL_DENDA_PER_JADWAL];

        String rumus = "" + mdp.getNilaiDenda() + "% dari";
        rumus += " " + tipePerhitungan[mdp.getTipePerhitunganDenda()];
        rumus += " " + akumulasi;
        rumus += " " + JenisKredit.VARIABEL_DENDA_TITLE[mdp.getVariabelDenda()];
        rumus += " " + perjadwal;

        return rumus;
    }

    public static int getAngsuranKe(long idPinjaman) {
        return getAngsuranKe(idPinjaman, 101);
    }
    public static int getAngsuranKe(long idPinjaman, int jenis) {
        DBResultSet dbrs = null;
        int count = 0;
        try {
            String sql = "SELECT COUNT(TR." + PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + ") AS ANGSURAN_KE "
                    + " FROM " + PstTransaksi.TBL_TRANSAKSI + " AS TR"
                    + " WHERE TR." + PstTransaksi.fieldNames[PstTransaksi.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "' AND "
                    + " TR."+PstTransaksi.fieldNames[PstTransaksi.FLD_USECASE_TYPE] + " = '" + jenis + "'"
                    + "";
            System.out.println("AngsuranKe - "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
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
    
    public static int listAngsuranKe(String whereClause, String param){
        int angsuranKe = 0;
        Vector<JadwalAngsuran> listJa = PstJadwalAngsuran.list(0, 0, whereClause, "");
        int index = 0;
        Date prevTglAngsuran = new Date();
        for(JadwalAngsuran ja : listJa) {
            if (ja.getTanggalAngsuran().compareTo(prevTglAngsuran) < 0 || ja.getTanggalAngsuran().compareTo(prevTglAngsuran) > 0) {
                index++;
                if (Formater.formatDate(ja.getTanggalAngsuran(), "yyyy-MM-dd").equals(param)) {
                    angsuranKe = index;
                }
                prevTglAngsuran = ja.getTanggalAngsuran();
            }
        }
        return angsuranKe;
    }
    
    public static int hapusIdSimpananWajib(long idPinjaman) throws DBException {
        int upd = 0;
        try {
            String sql = "UPDATE " + PstPinjaman.TBL_PINJAMAN
                    + " SET " + PstPinjaman.fieldNames[PstPinjaman.FLD_WAJIB_ID_JENIS_SIMPANAN] + " = NULL "
                    + " WHERE " + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                    + "";
            upd = DBHandler.execUpdate(sql);
            return upd;
        } catch (Exception e) {

        }
        return upd;
    }

    public static int hapusIdSimpananPencairan(long idPinjaman) throws DBException {
        int upd = 0;
        try {
            String sql = "UPDATE " + PstPinjaman.TBL_PINJAMAN
                    + " SET " + PstPinjaman.fieldNames[PstPinjaman.FLD_ASSIGN_TABUNGAN_ID] + " = NULL "
                    + ", " + PstPinjaman.fieldNames[PstPinjaman.FLD_ID_JENIS_SIMPANAN] + " = NULL "
                    + " WHERE " + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + " = '" + idPinjaman + "'"
                    + "";
            upd = DBHandler.execUpdate(sql);
            return upd;
        } catch (Exception e) {

        }
        return upd;
    }
    
    public void updateKolektibilitasKredit(long idPinjaman) {
        try {
            Pinjaman p = PstPinjaman.fetchExc(idPinjaman);
            if (p.getStatusPinjaman() == Pinjaman.STATUS_DOC_CAIR || p.getStatusPinjaman() == Pinjaman.STATUS_DOC_PENANGANAN_MACET) {
                //cari semua jadwal angsuran
                Vector<JadwalAngsuran> listJadwal = PstJadwalAngsuran.list(0, 0, PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_PINJAMAN_ID] + " = " + p.getOID(), PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]);
                for (JadwalAngsuran ja : listJadwal) {
                    try {
                        java.util.Date tglJatuhTempo = ja.getTanggalAngsuran();
                        java.util.Date tglAngsuranTerakhir = null;
                        //cari tgl angsuran terakhir
                        String where = PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " IN ("
                                + " SELECT " + PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID]
                                + " FROM " + PstAngsuran.TBL_ANGSURAN
                                + " WHERE " + PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = '" + ja.getOID() + "'"
                                + ")";
                        Vector<Transaksi> listTransaksi = PstTransaksi.list(0, 1, where, PstTransaksi.fieldNames[PstTransaksi.FLD_TRANSAKSI_ID] + " DESC ");
                        for (Transaksi t : listTransaksi) {
                            tglAngsuranTerakhir = t.getTanggalTransaksi();
                        }
                        
                        if (tglAngsuranTerakhir != null) {
                            if (tglAngsuranTerakhir.after(tglJatuhTempo)) {
                                //cek selisih hari bayar
                                
                            }
                        }
                        
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    public static Vector updateKolektibilitasKredit(Vector<Pinjaman> listPinjamanNunggak) {
        java.util.Date now = new java.util.Date();
        String dateCheck = Formater.formatDate(now, "yyy-MM-dd");
        return updateKolektibilitasKredit(listPinjamanNunggak, dateCheck, true);
    }
    
    public static Vector updateKolektibilitasKredit(Vector<Pinjaman> listPinjamanNunggak, String dateCheck, boolean update) {
        java.util.Date now = Formater.formatDate(dateCheck, "yyyy-MM-dd");
        //String dateCheck = Formater.formatDate(now, "yyy-MM-dd");
        Vector result = new Vector();
        for (int i = 0; i < listPinjamanNunggak.size(); i++) {
            try {
                Pinjaman p = (Pinjaman) listPinjamanNunggak.get(i);
                long hariTunggakanPokok = 0;
                long hariTunggakanBunga = 0;
                //jika status sudah lunas, default kolektibilitas jadi lancar
                if (listPinjamanNunggak.get(i).getStatusPinjaman() != Pinjaman.STATUS_DOC_LUNAS
                        && listPinjamanNunggak.get(i).getStatusPinjaman() != Pinjaman.STATUS_DOC_PELUNASAN_DINI
                        && listPinjamanNunggak.get(i).getStatusPinjaman() != Pinjaman.STATUS_DOC_PELUNASAN_MACET) {
                    //cari tanggal tunggakan
                    java.util.Date tglAwalTunggakanPokok = SessReportKredit.getTunggakanKredit(p.getOID(), dateCheck, JadwalAngsuran.TIPE_ANGSURAN_POKOK);
                    java.util.Date tglAwalTunggakanBunga = SessReportKredit.getTunggakanKredit(p.getOID(), dateCheck, JadwalAngsuran.TIPE_ANGSURAN_BUNGA);
                    if (tglAwalTunggakanPokok != null) {
                        java.util.Date jatuhTempoAwal = tglAwalTunggakanPokok;
                        long diff = now.getTime() - jatuhTempoAwal.getTime();
                        hariTunggakanPokok = TimeUnit.MILLISECONDS.toDays(diff);
                    }
                    if (tglAwalTunggakanBunga != null) {
                        java.util.Date jatuhTempoAwal = tglAwalTunggakanBunga;
                        long diff = now.getTime() - jatuhTempoAwal.getTime();
                        hariTunggakanBunga = TimeUnit.MILLISECONDS.toDays(diff);
                    }
                }

                //update kolektibilitas
                JenisKredit kredit = PstJenisKredit.fetch(p.getTipeKreditId());

                String whereKolektibilitas = PstKolektibilitasPembayaranDetails.fieldNames[PstKolektibilitasPembayaranDetails.FLD_TIPEKREIDT] + " = " + kredit.getTipeFrekuensiPokokLegacy();
                String order = PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_TINGKAT_KOLEKTIBILITAS] + " ASC ";
                Vector<KolektibilitasPembayaranDetails> cekKolektibilitas = PstKolektibilitasPembayaranDetails.getJoin(0, 0, whereKolektibilitas, order);
                for (int j = 0; j < cekKolektibilitas.size(); j++) {
                    try {
                        long idKolektibilitas = cekKolektibilitas.get(j).getKolektibilitasId();
                        int maxHariPokok = cekKolektibilitas.get(j).getMaxHariTunggakanPokok();
                        int maxHariBunga = cekKolektibilitas.get(j).getMaxHariJumlahTunggakanBunga();
                        if (hariTunggakanPokok <= maxHariPokok && hariTunggakanBunga <= maxHariBunga) {
                            p.setKodeKolektibilitas(idKolektibilitas);
                            if (update) {
                                PstPinjaman.updateExc(p);
                            }
                            break;
                        }
                        if (j == (cekKolektibilitas.size() - 1)) {
                            p.setKodeKolektibilitas(idKolektibilitas);
                            if (update) {
                                PstPinjaman.updateExc(p);
                            }
                        }
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                }
                result.add(p);
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
        return result;
    }

    public static Vector orderHistoryKolektibilitas(Vector<Pinjaman> listPinjamanNunggak, String order) {
        Vector orderedList = new Vector();
        DBResultSet dbrs = null;
        
        try {
            String sql = "";
            for (Pinjaman p : listPinjamanNunggak) {
                KolektibilitasPembayaran k = PstKolektibilitasPembayaran.fetchExc(p.getKodeKolektibilitas());
                sql += (sql.length() > 0) ? " UNION " : "";
                sql += "SELECT " + p.getOID() + " AS " + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]
                        + ", " + p.getKodeKolektibilitas() + " AS " + PstPinjaman.fieldNames[PstPinjaman.FLD_KODE_KOLEKTIBILITAS]
                        + ", " + p.getTipeKreditId()+ " AS " + PstPinjaman.fieldNames[PstPinjaman.FLD_TIPE_KREDIT_ID]
                        + ", " + k.getTingkatKolektibilitas() + " AS " + PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_TINGKAT_KOLEKTIBILITAS]
                        + "";
            }
            sql = "SELECT * FROM (" + sql + ") AS data_list"
                    + " JOIN aiso_pinjaman AS p "
                    + "    ON p.PINJAMAN_ID = data_list.PINJAMAN_ID "
                    + " JOIN sedana_kolektibilitas_pembayaran AS kp "
                    + "    ON kp.KOLEKTIBILITAS_ID = data_list.KODE_KOLEKTIBILITAS "
//                    + " JOIN sedana_pinjaman_sumber_dana sd "
//                    + "    ON sd.PINJAMAN_ID = p.PINJAMAN_ID"
                    + "";
            sql += " ORDER BY " + order;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Pinjaman p = new Pinjaman();
                p = PstPinjaman.fetchExc(rs.getLong(PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID]));
                p.setKodeKolektibilitas(rs.getLong(PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_KOLEKTIBILITAS_ID]));
//                p.setSumberDanaId(rs.getLong("SUMBER_DANA_ID"));
                orderedList.add(p);
            }
            rs.close();
            return orderedList;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return orderedList;
    }
    
    public static int getCountTransaksiBiayaKredit(long idPinjaman, long idJenisTransaksi) {
        int count = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + "  COUNT(t.TRANSAKSI_ID) "
                    + " FROM "
                    + "  sedana_transaksi t "
                    + "  INNER JOIN sedana_detail_transaksi dt "
                    + "    ON t.TRANSAKSI_ID = dt.TRANSAKSI_ID "
                    + " WHERE t.PINJAMAN_ID = " + idPinjaman
                    + "  AND dt.JENIS_TRANSAKSI_ID = " + idJenisTransaksi
                    + "";

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return count;
    }
    
    public static java.util.Date getTunggakanKredit(long idPinjaman, String tanggalCek, int jenisAngsuran) {
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
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
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
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
                    + " AND jadwal.`JENIS_ANGSURAN` = '" + jenisAngsuran + "' "
                    + " AND angsuran.id_angsuran IS NOT NULL "
                    + " GROUP BY jadwal.`JADWAL_ANGSURAN_ID`) AS tb "
                    + " WHERE balance != 0 "
                    + " ORDER BY tb.TANGGAL_ANGSURAN "
                    + "";
            System.out.println(" SQL getTunggakan :" +sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            java.util.Date tanggal = null;
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
    
    public static double getTunggakanPokok(long idPinjaman, String tanggalCek, int jenisAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT  SUM(tb.`JUMLAH_ANGSURAN`) AS JUMLAH "
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
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
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
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
                    + " AND jadwal.`JENIS_ANGSURAN` = '" + jenisAngsuran + "' "
                    + " AND angsuran.id_angsuran IS NOT NULL "
                    + " GROUP BY jadwal.`JADWAL_ANGSURAN_ID`) AS tb "
                    + " WHERE balance != 0 "
                    + " ORDER BY tb.TANGGAL_ANGSURAN "
                    + "";
            System.out.println(" SQL getTunggakan :" +sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double pokok = 0;
            while (rs.next()) {
                pokok = rs.getDouble(1);
            }
            rs.close();
            return pokok;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    public static double getTunggakanBunga(long idPinjaman, String tanggalCek, int jenisAngsuran) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT  SUM(tb.`JUMLAH_ANGSURAN`) AS JUMLAH "
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
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
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
                    + " AND DATE(jadwal.`TANGGAL_ANGSURAN`) <= DATE('" + tanggalCek + "') "
                    + " AND jadwal.`JENIS_ANGSURAN` = '" + jenisAngsuran + "' "
                    + " AND angsuran.id_angsuran IS NOT NULL "
                    + " GROUP BY jadwal.`JADWAL_ANGSURAN_ID`) AS tb "
                    + " WHERE balance != 0 "
                    + " ORDER BY tb.TANGGAL_ANGSURAN "
                    + "";
            System.out.println(" SQL getTunggakan :" +sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double pokok = 0;
            while (rs.next()) {
                pokok = rs.getDouble(1);
            }
            rs.close();
            return pokok;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    public static int getCountListKreditKolektabilitas(String whereClause) {
        int result = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstPinjaman.fieldNames[PstPinjaman.FLD_PINJAMAN_ID] + ") AS RESULT"
                    + " FROM " + PstPinjaman.TBL_PINJAMAN + " AP "
                    + " INNER JOIN " + PstAnggota.TBL_ANGGOTA + " CL "
                    + " ON AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + " = CL." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " BM "
                    + " ON AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " = BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID]
                    + " INNER JOIN " + PstKolektibilitasPembayaran.TBL_KOLEKTIBILITASPEMBAYARAN + " SKP "
                    + " ON AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_KODE_KOLEKTIBILITAS]
                    + " = SKP." + PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_KOLEKTIBILITAS_ID];
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt("RESULT");
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }
    
    public static Vector getListKreditKolektabilitas(int limitStart, int recordToGet, String whereClause, String order) {
        Vector listData = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + PstPinjaman.TBL_PINJAMAN + " AP "
                    + " INNER JOIN " + PstAnggota.TBL_ANGGOTA + " CL "
                    + " ON AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_ANGGOTA_ID]
                    + " = CL." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + " INNER JOIN " + PstBillMain.TBL_CASH_BILL_MAIN + " BM "
                    + " ON AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_CASH_BILL_MAIN_ID]
                    + " = BM." + PstBillMain.fieldNames[PstBillMain.FLD_BILL_MAIN_ID]
                    + " INNER JOIN " + PstKolektibilitasPembayaran.TBL_KOLEKTIBILITASPEMBAYARAN + " SKP "
                    + " ON AP." + PstPinjaman.fieldNames[PstPinjaman.FLD_KODE_KOLEKTIBILITAS]
                    + " = SKP." + PstKolektibilitasPembayaran.fieldNames[PstKolektibilitasPembayaran.FLD_KOLEKTIBILITAS_ID];
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
                Vector tempData = new Vector();
                Pinjaman p = new Pinjaman();
                BillMain bm = new BillMain();
                Anggota a = new Anggota();
                KolektibilitasPembayaran kp = new KolektibilitasPembayaran();
                
                PstPinjaman.resultToObject(rs, p);
                PstAnggota.resultToObject(rs, a);
                PstBillMain.resultToObject(rs, bm);
                PstKolektibilitasPembayaran.resultToObject(rs, kp);
                
                tempData.add(p);
                tempData.add(a);
                tempData.add(bm);
                tempData.add(kp);
                
                listData.add(tempData);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return listData;
    }

}
