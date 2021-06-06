/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.kredit;

import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;

/**
 *
 * @author gndiw
 */
public class PstHapusKredit extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_HAPUSKREDIT = "sedana_hapus_kredit";
    public static final int FLD_HAPUS_ID = 0;
    public static final int FLD_NOMOR_HAPUS = 1;
    public static final int FLD_PINJAMAN_ID = 2;
    public static final int FLD_CASH_BILL_MAIN_ID = 3;
    public static final int FLD_TANGGAL_HAPUS = 4;
    public static final int FLD_LOCATION_TRANSAKSI = 5;
    public static final int FLD_SISA_POKOK = 6;
    public static final int FLD_SISA_BUNGA = 7;
    public static final int FLD_STATUS = 8;
    public static final int FLD_CATATAN = 9;

    public static String[] fieldNames = {
        "HAPUS_ID",
        "NOMOR_HAPUS",
        "PINJAMAN_ID",
        "CASH_BILL_MAIN_ID",
        "TANGGAL_HAPUS",
        "LOCATION_TRANSAKSI",
        "SISA_POKOK",
        "SISA_BUNGA",
        "STATUS",
        "CATATAN"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_STRING
    };

    public static final String hapusStatusKey[] = {"Draft", "Closed", "Posted"};
    public static final String hapusStatusValue[] = {"0", "5", "7"};
    
    public PstHapusKredit() {
    }

    public PstHapusKredit(int i) throws DBException {
        super(new PstHapusKredit());
    }

    public PstHapusKredit(String sOid) throws DBException {
        super(new PstHapusKredit(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstHapusKredit(long lOid) throws DBException {
        super(new PstHapusKredit(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public String getTableName() {
        return TBL_HAPUSKREDIT;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstHapusKredit().getClass().getName();
    }

    public static HapusKredit fetchExc(long oid) throws DBException {
        try {
            HapusKredit entHapuskredit = new HapusKredit();
            PstHapusKredit pstHapuskredit = new PstHapusKredit(oid);
            entHapuskredit.setOID(oid);
            entHapuskredit.setNomorHapus(pstHapuskredit.getString(FLD_NOMOR_HAPUS));
            entHapuskredit.setPinjamanId(pstHapuskredit.getlong(FLD_PINJAMAN_ID));
            entHapuskredit.setCashBillMainId(pstHapuskredit.getlong(FLD_CASH_BILL_MAIN_ID));
            entHapuskredit.setTanggalHapus(pstHapuskredit.getDate(FLD_TANGGAL_HAPUS));
            entHapuskredit.setLocationTransaksi(pstHapuskredit.getlong(FLD_LOCATION_TRANSAKSI));
            entHapuskredit.setSisaPokok(pstHapuskredit.getdouble(FLD_SISA_POKOK));
            entHapuskredit.setSisaBunga(pstHapuskredit.getdouble(FLD_SISA_BUNGA));
            entHapuskredit.setStatus(pstHapuskredit.getInt(FLD_STATUS));
            entHapuskredit.setCatatan(pstHapuskredit.getString(FLD_CATATAN));
            return entHapuskredit;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHapusKredit(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        HapusKredit entHapuskredit = fetchExc(entity.getOID());
        entity = (Entity) entHapuskredit;
        return entHapuskredit.getOID();
    }

    public static synchronized long updateExc(HapusKredit entHapuskredit) throws DBException {
        try {
            if (entHapuskredit.getOID() != 0) {
                PstHapusKredit pstHapuskredit = new PstHapusKredit(entHapuskredit.getOID());
                pstHapuskredit.setString(FLD_NOMOR_HAPUS, entHapuskredit.getNomorHapus());
                pstHapuskredit.setLong(FLD_PINJAMAN_ID, entHapuskredit.getPinjamanId());
                pstHapuskredit.setLong(FLD_CASH_BILL_MAIN_ID, entHapuskredit.getCashBillMainId());
                pstHapuskredit.setDate(FLD_TANGGAL_HAPUS, entHapuskredit.getTanggalHapus());
                pstHapuskredit.setLong(FLD_LOCATION_TRANSAKSI, entHapuskredit.getLocationTransaksi());
                pstHapuskredit.setDouble(FLD_SISA_POKOK, entHapuskredit.getSisaPokok());
                pstHapuskredit.setDouble(FLD_SISA_BUNGA, entHapuskredit.getSisaBunga());
                pstHapuskredit.setInt(FLD_STATUS, entHapuskredit.getStatus());
                pstHapuskredit.setString(FLD_CATATAN, entHapuskredit.getCatatan());
                pstHapuskredit.update();
                return entHapuskredit.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHapusKredit(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((HapusKredit) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstHapusKredit pstHapuskredit = new PstHapusKredit(oid);
            pstHapuskredit.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHapusKredit(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(HapusKredit entHapuskredit) throws DBException {
        try {
            PstHapusKredit pstHapuskredit = new PstHapusKredit(0);
            pstHapuskredit.setString(FLD_NOMOR_HAPUS, entHapuskredit.getNomorHapus());
            pstHapuskredit.setLong(FLD_PINJAMAN_ID, entHapuskredit.getPinjamanId());
            pstHapuskredit.setLong(FLD_CASH_BILL_MAIN_ID, entHapuskredit.getCashBillMainId());
            pstHapuskredit.setDate(FLD_TANGGAL_HAPUS, entHapuskredit.getTanggalHapus());
            pstHapuskredit.setLong(FLD_LOCATION_TRANSAKSI, entHapuskredit.getLocationTransaksi());
            pstHapuskredit.setDouble(FLD_SISA_POKOK, entHapuskredit.getSisaPokok());
            pstHapuskredit.setDouble(FLD_SISA_BUNGA, entHapuskredit.getSisaBunga());
            pstHapuskredit.setInt(FLD_STATUS, entHapuskredit.getStatus());
            pstHapuskredit.setString(FLD_CATATAN, entHapuskredit.getCatatan());
            pstHapuskredit.insert();
            entHapuskredit.setOID(pstHapuskredit.getlong(FLD_HAPUS_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHapusKredit(0), DBException.UNKNOWN);
        }
        return entHapuskredit.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((HapusKredit) entity);
    }

    public static void resultToObject(ResultSet rs, HapusKredit entHapuskredit) {
        try {
            entHapuskredit.setOID(rs.getLong(PstHapusKredit.fieldNames[PstHapusKredit.FLD_HAPUS_ID]));
            entHapuskredit.setNomorHapus(rs.getString(PstHapusKredit.fieldNames[PstHapusKredit.FLD_NOMOR_HAPUS]));
            entHapuskredit.setPinjamanId(rs.getLong(PstHapusKredit.fieldNames[PstHapusKredit.FLD_PINJAMAN_ID]));
            entHapuskredit.setCashBillMainId(rs.getLong(PstHapusKredit.fieldNames[PstHapusKredit.FLD_CASH_BILL_MAIN_ID]));
            entHapuskredit.setTanggalHapus(rs.getDate(PstHapusKredit.fieldNames[PstHapusKredit.FLD_TANGGAL_HAPUS]));
            entHapuskredit.setLocationTransaksi(rs.getLong(PstHapusKredit.fieldNames[PstHapusKredit.FLD_LOCATION_TRANSAKSI]));
            entHapuskredit.setSisaPokok(rs.getDouble(PstHapusKredit.fieldNames[PstHapusKredit.FLD_SISA_POKOK]));
            entHapuskredit.setSisaBunga(rs.getDouble(PstHapusKredit.fieldNames[PstHapusKredit.FLD_SISA_BUNGA]));
            entHapuskredit.setStatus(rs.getInt(PstHapusKredit.fieldNames[PstHapusKredit.FLD_STATUS]));
            entHapuskredit.setCatatan(rs.getString(PstHapusKredit.fieldNames[PstHapusKredit.FLD_CATATAN]));
        } catch (Exception e) {
        }
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HAPUSKREDIT;
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
                HapusKredit entHapuskredit = new HapusKredit();
                resultToObject(rs, entHapuskredit);
                lists.add(entHapuskredit);
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

    public static boolean checkOID(long entHapuskreditId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HAPUSKREDIT + " WHERE "
                    + PstHapusKredit.fieldNames[PstHapusKredit.FLD_NOMOR_HAPUS] + " = " + entHapuskreditId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstHapusKredit.fieldNames[PstHapusKredit.FLD_NOMOR_HAPUS] + ") FROM " + TBL_HAPUSKREDIT;
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

    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    HapusKredit entHapuskredit = (HapusKredit) list.get(ls);
                    if (oid == entHapuskredit.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }
        return start;
    }

    public static int findLimitCommand(int start, int recordToGet, int vectSize) {
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + (recordToGet - mdl);
        if (start == 0) {
            cmd = Command.FIRST;
        } else {
            if (start == (vectSize - recordToGet)) {
                cmd = Command.LAST;
            } else {
                start = start + recordToGet;
                if (start <= (vectSize - recordToGet)) {
                    cmd = Command.NEXT;
                    System.out.println("next.......................");
                } else {
                    start = start - recordToGet;
                    if (start > 0) {
                        cmd = Command.PREV;
                        System.out.println("prev.......................");
                    }
                }
            }
        }
        return cmd;
    }
}
