/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.kredit;

/**
 *
 * @author WiraDharma
 */
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Hashtable;
import java.util.Vector;

public class PstDokumenPinjaman extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_DOKUMENPINJAMAN = "sedana_dokumen_pinjaman";
    public static final int FLD_DOKUMEN_ID = 0;
    public static final int FLD_PINJAMAN_ID = 1;
    public static final int FLD_NAMA_DOKUMEN = 2;
    public static final int FLD_NAMA_FILE = 3;
    public static final int FLD_DESKRIPSI = 4;

    public static String[] fieldNames = {
        "DOKUMEN_ID",
        "PINJAMAN_ID",
        "NAMA_DOKUMEN",
        "NAMA_FILE",
        "DESKRIPSI"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };

    public PstDokumenPinjaman() {
    }

    public PstDokumenPinjaman(int i) throws DBException {
        super(new PstDokumenPinjaman());
    }

    public PstDokumenPinjaman(String sOid) throws DBException {
        super(new PstDokumenPinjaman(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstDokumenPinjaman(long lOid) throws DBException {
        super(new PstDokumenPinjaman(0));
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
        return TBL_DOKUMENPINJAMAN;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstDokumenPinjaman().getClass().getName();
    }

    public static DokumenPinjaman fetchExc(long oid) throws DBException {
        try {
            DokumenPinjaman entDokumenPinjaman = new DokumenPinjaman();
            PstDokumenPinjaman pstDokumenPinjaman = new PstDokumenPinjaman(oid);
            entDokumenPinjaman.setOID(oid);
            entDokumenPinjaman.setPinjamanId(pstDokumenPinjaman.getlong(FLD_PINJAMAN_ID));
            entDokumenPinjaman.setNamaDokumen(pstDokumenPinjaman.getString(FLD_NAMA_DOKUMEN));
            entDokumenPinjaman.setNamaFile(pstDokumenPinjaman.getString(FLD_NAMA_FILE));
            entDokumenPinjaman.setDeskripsi(pstDokumenPinjaman.getString(FLD_DESKRIPSI));
            return entDokumenPinjaman;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDokumenPinjaman(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        DokumenPinjaman entDokumenPinjaman = fetchExc(entity.getOID());
        entity = (Entity) entDokumenPinjaman;
        return entDokumenPinjaman.getOID();
    }

    public static synchronized long updateExc(DokumenPinjaman entDokumenPinjaman) throws DBException {
        try {
            if (entDokumenPinjaman.getOID() != 0) {
                PstDokumenPinjaman pstDokumenPinjaman = new PstDokumenPinjaman(entDokumenPinjaman.getOID());
                pstDokumenPinjaman.setLong(FLD_PINJAMAN_ID, entDokumenPinjaman.getPinjamanId());
                pstDokumenPinjaman.setString(FLD_NAMA_DOKUMEN, entDokumenPinjaman.getNamaDokumen());
                pstDokumenPinjaman.setString(FLD_NAMA_FILE, entDokumenPinjaman.getNamaFile());
                pstDokumenPinjaman.setString(FLD_DESKRIPSI, entDokumenPinjaman.getDeskripsi());
                pstDokumenPinjaman.update();
                return entDokumenPinjaman.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDokumenPinjaman(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((DokumenPinjaman) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstDokumenPinjaman pstDokumenPinjaman = new PstDokumenPinjaman(oid);
            pstDokumenPinjaman.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDokumenPinjaman(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(DokumenPinjaman entDokumenPinjaman) throws DBException {
        try {
            PstDokumenPinjaman pstDokumenPinjaman = new PstDokumenPinjaman(0);
            pstDokumenPinjaman.setLong(FLD_PINJAMAN_ID, entDokumenPinjaman.getPinjamanId());
            pstDokumenPinjaman.setString(FLD_NAMA_DOKUMEN, entDokumenPinjaman.getNamaDokumen());
            pstDokumenPinjaman.setString(FLD_NAMA_FILE, entDokumenPinjaman.getNamaFile());
            pstDokumenPinjaman.setString(FLD_DESKRIPSI, entDokumenPinjaman.getDeskripsi());
            pstDokumenPinjaman.insert();
            entDokumenPinjaman.setOID(pstDokumenPinjaman.getlong(FLD_DOKUMEN_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDokumenPinjaman(0), DBException.UNKNOWN);
        }
        return entDokumenPinjaman.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((DokumenPinjaman) entity);
    }

    public static void resultToObject(ResultSet rs, DokumenPinjaman entDokumenPinjaman) {
        try {
            entDokumenPinjaman.setOID(rs.getLong(PstDokumenPinjaman.fieldNames[PstDokumenPinjaman.FLD_DOKUMEN_ID]));
            entDokumenPinjaman.setPinjamanId(rs.getLong(PstDokumenPinjaman.fieldNames[PstDokumenPinjaman.FLD_PINJAMAN_ID]));
            entDokumenPinjaman.setNamaDokumen(rs.getString(PstDokumenPinjaman.fieldNames[PstDokumenPinjaman.FLD_NAMA_DOKUMEN]));
            entDokumenPinjaman.setNamaFile(rs.getString(PstDokumenPinjaman.fieldNames[PstDokumenPinjaman.FLD_NAMA_FILE]));
            entDokumenPinjaman.setDeskripsi(rs.getString(PstDokumenPinjaman.fieldNames[PstDokumenPinjaman.FLD_DESKRIPSI]));
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
            String sql = "SELECT * FROM " + TBL_DOKUMENPINJAMAN;
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
                DokumenPinjaman entDokumenPinjaman = new DokumenPinjaman();
                resultToObject(rs, entDokumenPinjaman);
                lists.add(entDokumenPinjaman);
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

    public static boolean checkOID(long entDokumenPinjamanId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_DOKUMENPINJAMAN + " WHERE "
                    + PstDokumenPinjaman.fieldNames[PstDokumenPinjaman.FLD_DOKUMEN_ID] + " = " + entDokumenPinjamanId;
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
            String sql = "SELECT COUNT(" + PstDokumenPinjaman.fieldNames[PstDokumenPinjaman.FLD_DOKUMEN_ID] + ") FROM " + TBL_DOKUMENPINJAMAN;
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
                    DokumenPinjaman entDokumenPinjaman = (DokumenPinjaman) list.get(ls);
                    if (oid == entDokumenPinjaman.getOID()) {
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
      public static void updateFileName(String fileName, long idDokumen) {
    try {
      String sql = "UPDATE " + PstDokumenPinjaman.TBL_DOKUMENPINJAMAN
              + " SET " + PstDokumenPinjaman.fieldNames[FLD_NAMA_FILE] + " = '" + fileName + "'"
              + " WHERE " + PstDokumenPinjaman.fieldNames[PstDokumenPinjaman.FLD_DOKUMEN_ID]
              + " = " + idDokumen;
      System.out.println("sql PstDokumenPinjaman.updateFileName : " + sql);
      int result = DBHandler.execUpdate(sql);
    } catch (Exception e) {
      System.out.println("\tExc updateFileName : " + e.toString());
    } finally {
      //System.out.println("\tFinal updatePresenceStatus");
    }
  }
      
}
