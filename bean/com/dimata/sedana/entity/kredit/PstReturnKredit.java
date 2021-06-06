/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.kredit;

/**
 *
 * @author Regen
 */
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import com.dimata.util.Formater;
import java.util.Vector;
import org.json.JSONObject;

public class PstReturnKredit extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_RETURNKREDIT = "sedana_return_kredit";
    public static final int FLD_RETURN_ID = 0;
    public static final int FLD_NOMOR_RETURN = 1;
    public static final int FLD_PINJAMAN_ID = 2;
    public static final int FLD_TRANSAKSI_ID = 3;
    public static final int FLD_CASH_BILL_MAIN_ID = 4;
    public static final int FLD_TANGGAL_RETURN = 5;
    public static final int FLD_LOCATION_TRANSAKSI = 6;
    public static final int FLD_STATUS = 7;
    public static final int FLD_CATATAN = 8;
    public static final int FLD_JENIS_RETURN = 9;

    public static String[] fieldNames = {
        "RETURN_ID",
        "NOMOR_RETURN",
        "PINJAMAN_ID",
        "TRANSAKSI_ID",
        "CASH_BILL_MAIN_ID",
        "TANGGAL_RETURN",
        "LOCATION_TRANSAKSI",
        "STATUS",
        "CATATAN",
        "JENIS_RETURN"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT
    };

    public PstReturnKredit() {
    }

    public PstReturnKredit(int i) throws DBException {
        super(new PstReturnKredit());
    }

    public PstReturnKredit(String sOid) throws DBException {
        super(new PstReturnKredit(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstReturnKredit(long lOid) throws DBException {
        super(new PstReturnKredit(0));
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
        return TBL_RETURNKREDIT;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstReturnKredit().getClass().getName();
    }

    public static ReturnKredit fetchExc(long oid) throws DBException {
        try {
            ReturnKredit entReturnKredit = new ReturnKredit();
            PstReturnKredit pstReturnKredit = new PstReturnKredit(oid);
            entReturnKredit.setOID(oid);
            entReturnKredit.setNomorReturn(pstReturnKredit.getString(FLD_NOMOR_RETURN));
            entReturnKredit.setPinjamanId(pstReturnKredit.getlong(FLD_PINJAMAN_ID));
            entReturnKredit.setTransaksiId(pstReturnKredit.getlong(FLD_TRANSAKSI_ID));
            entReturnKredit.setCashBillMainId(pstReturnKredit.getlong(FLD_CASH_BILL_MAIN_ID));
            entReturnKredit.setTanggalReturn(pstReturnKredit.getDate(FLD_TANGGAL_RETURN));
            entReturnKredit.setLocationTransaksi(pstReturnKredit.getlong(FLD_LOCATION_TRANSAKSI));
            entReturnKredit.setStatus(pstReturnKredit.getInt(FLD_STATUS));
            entReturnKredit.setCatatan(pstReturnKredit.getString(FLD_CATATAN));
            entReturnKredit.setJenisReturn(pstReturnKredit.getInt(FLD_JENIS_RETURN));
            return entReturnKredit;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstReturnKredit(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        ReturnKredit entReturnKredit = fetchExc(entity.getOID());
        entity = (Entity) entReturnKredit;
        return entReturnKredit.getOID();
    }

    public static synchronized long updateExc(ReturnKredit entReturnKredit) throws DBException {
        try {
            if (entReturnKredit.getOID() != 0) {
                PstReturnKredit pstReturnKredit = new PstReturnKredit(entReturnKredit.getOID());
                pstReturnKredit.setString(FLD_NOMOR_RETURN, entReturnKredit.getNomorReturn());
                pstReturnKredit.setLong(FLD_PINJAMAN_ID, entReturnKredit.getPinjamanId());
                pstReturnKredit.setLong(FLD_TRANSAKSI_ID, entReturnKredit.getTransaksiId());
                pstReturnKredit.setLong(FLD_CASH_BILL_MAIN_ID, entReturnKredit.getCashBillMainId());
                pstReturnKredit.setDate(FLD_TANGGAL_RETURN, entReturnKredit.getTanggalReturn());
                pstReturnKredit.setLong(FLD_LOCATION_TRANSAKSI, entReturnKredit.getLocationTransaksi());
                pstReturnKredit.setInt(FLD_STATUS, entReturnKredit.getStatus());
                pstReturnKredit.setString(FLD_CATATAN, entReturnKredit.getCatatan());
                pstReturnKredit.setInt(FLD_JENIS_RETURN, entReturnKredit.getJenisReturn());
                pstReturnKredit.update();
                return entReturnKredit.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstReturnKredit(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((ReturnKredit) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstReturnKredit pstReturnKredit = new PstReturnKredit(oid);
            pstReturnKredit.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstReturnKredit(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(ReturnKredit entReturnKredit) throws DBException {
        try {
            PstReturnKredit pstReturnKredit = new PstReturnKredit(0);
            pstReturnKredit.setString(FLD_NOMOR_RETURN, entReturnKredit.getNomorReturn());
            pstReturnKredit.setLong(FLD_PINJAMAN_ID, entReturnKredit.getPinjamanId());
            pstReturnKredit.setLong(FLD_TRANSAKSI_ID, entReturnKredit.getTransaksiId());
            pstReturnKredit.setLong(FLD_CASH_BILL_MAIN_ID, entReturnKredit.getCashBillMainId());
            pstReturnKredit.setDate(FLD_TANGGAL_RETURN, entReturnKredit.getTanggalReturn());
            pstReturnKredit.setLong(FLD_LOCATION_TRANSAKSI, entReturnKredit.getLocationTransaksi());
            pstReturnKredit.setInt(FLD_STATUS, entReturnKredit.getStatus());
            pstReturnKredit.setString(FLD_CATATAN, entReturnKredit.getCatatan());
            pstReturnKredit.setInt(FLD_JENIS_RETURN, entReturnKredit.getJenisReturn());
            pstReturnKredit.insert();
            entReturnKredit.setOID(pstReturnKredit.getlong(FLD_RETURN_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstReturnKredit(0), DBException.UNKNOWN);
        }
        return entReturnKredit.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((ReturnKredit) entity);
    }

    public static void resultToObject(ResultSet rs, ReturnKredit entReturnKredit) {
        try {
            entReturnKredit.setOID(rs.getLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID]));
            entReturnKredit.setNomorReturn(rs.getString(PstReturnKredit.fieldNames[PstReturnKredit.FLD_NOMOR_RETURN]));
            entReturnKredit.setPinjamanId(rs.getLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_PINJAMAN_ID]));
            entReturnKredit.setTransaksiId(rs.getLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TRANSAKSI_ID]));
            entReturnKredit.setCashBillMainId(rs.getLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CASH_BILL_MAIN_ID]));
            entReturnKredit.setTanggalReturn(rs.getDate(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN]));
            entReturnKredit.setLocationTransaksi(rs.getLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_LOCATION_TRANSAKSI]));
            entReturnKredit.setStatus(rs.getInt(PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS]));
            entReturnKredit.setCatatan(rs.getString(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CATATAN]));
            entReturnKredit.setJenisReturn(rs.getInt(PstReturnKredit.fieldNames[PstReturnKredit.FLD_JENIS_RETURN]));
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
            String sql = "SELECT * FROM " + TBL_RETURNKREDIT;
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
                ReturnKredit entReturnKredit = new ReturnKredit();
                resultToObject(rs, entReturnKredit);
                lists.add(entReturnKredit);
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

    public static boolean checkOID(long entReturnKreditId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_RETURNKREDIT + " WHERE "
                    + PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID] + " = " + entReturnKreditId;
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
            String sql = "SELECT COUNT(" + PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID] + ") FROM " + TBL_RETURNKREDIT;
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
                    ReturnKredit entReturnKredit = (ReturnKredit) list.get(ls);
                    if (oid == entReturnKredit.getOID()) {
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

    public static JSONObject fetchJSON(long oid) {
        JSONObject object = new JSONObject();
        try {
            ReturnKredit returnKredit = PstReturnKredit.fetchExc(oid);
            object.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID], returnKredit.getOID());
            object.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_NOMOR_RETURN], returnKredit.getNomorReturn());
            object.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_PINJAMAN_ID], returnKredit.getPinjamanId());
            object.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TRANSAKSI_ID], returnKredit.getTransaksiId());
            object.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CASH_BILL_MAIN_ID], returnKredit.getCashBillMainId());
            object.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN], returnKredit.getTanggalReturn());
            object.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_LOCATION_TRANSAKSI], returnKredit.getLocationTransaksi());
            object.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS], returnKredit.getStatus());
            object.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CATATAN], returnKredit.getCatatan());
            object.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_JENIS_RETURN], returnKredit.getJenisReturn());
        } catch (Exception exc) {
        }
        return object;
    }

    public static long syncExc(JSONObject jSONObject) {
        long oid = 0;
        if (jSONObject != null) {
            oid = jSONObject.optLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID], 0);
            if (oid > 0) {
                ReturnKredit returnKredit = new ReturnKredit();
                returnKredit.setOID(jSONObject.optLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID], 0));
                returnKredit.setNomorReturn(jSONObject.optString(PstReturnKredit.fieldNames[PstReturnKredit.FLD_NOMOR_RETURN], ""));
                returnKredit.setPinjamanId(jSONObject.optLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_PINJAMAN_ID], 0));
                returnKredit.setTransaksiId(jSONObject.optLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TRANSAKSI_ID], 0));
                returnKredit.setCashBillMainId(jSONObject.optLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CASH_BILL_MAIN_ID], 0));
                returnKredit.setTanggalReturn(Formater.formatDate(jSONObject.optString(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN], ""), "yyyy-MM-dd"));
                returnKredit.setLocationTransaksi(jSONObject.optLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_LOCATION_TRANSAKSI], 0));
                returnKredit.setStatus(jSONObject.optInt(PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS], 0));
                returnKredit.setCatatan(jSONObject.optString(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CATATAN], ""));
                returnKredit.setJenisReturn(jSONObject.optInt(PstReturnKredit.fieldNames[PstReturnKredit.FLD_JENIS_RETURN], 0));
                boolean checkOidReturnKredit = PstReturnKredit.checkOID(oid);
                try {
                    if (checkOidReturnKredit) {
                        PstReturnKredit.updateExc(returnKredit);
                    } else {
                        PstReturnKredit.insertByOid(returnKredit);
                    }
                } catch (Exception exc) {
                }
            }
        }
        return oid;
    }

    public static long insertByOid(ReturnKredit returnKredit) throws DBException {
        try {
            PstReturnKredit pstReturnKredit = new PstReturnKredit(0);
            pstReturnKredit.setLong(FLD_RETURN_ID, returnKredit.getOID());
            pstReturnKredit.setString(FLD_NOMOR_RETURN, returnKredit.getNomorReturn());
            pstReturnKredit.setLong(FLD_PINJAMAN_ID, returnKredit.getPinjamanId());
            pstReturnKredit.setLong(FLD_TRANSAKSI_ID, returnKredit.getTransaksiId());
            pstReturnKredit.setLong(FLD_CASH_BILL_MAIN_ID, returnKredit.getCashBillMainId());
            pstReturnKredit.setDate(FLD_TANGGAL_RETURN, returnKredit.getTanggalReturn());
            pstReturnKredit.setLong(FLD_LOCATION_TRANSAKSI, returnKredit.getLocationTransaksi());
            pstReturnKredit.setInt(FLD_STATUS, returnKredit.getStatus());
            pstReturnKredit.setString(FLD_CATATAN, returnKredit.getCatatan());
            pstReturnKredit.setInt(FLD_JENIS_RETURN, returnKredit.getJenisReturn());
            pstReturnKredit.insertByOid(returnKredit.getOID());
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstReturnKredit(0), DBException.UNKNOWN);
        }
        return returnKredit.getOID();
    }

    public static void resultToObjectJson(ResultSet rs, JSONObject obj) {
        try {
            obj.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID], rs.getLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID]));
            obj.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_NOMOR_RETURN], rs.getString(PstReturnKredit.fieldNames[PstReturnKredit.FLD_NOMOR_RETURN]));
            obj.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_PINJAMAN_ID], rs.getLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_PINJAMAN_ID]));
            obj.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TRANSAKSI_ID], rs.getLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TRANSAKSI_ID]));
            obj.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CASH_BILL_MAIN_ID], rs.getLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CASH_BILL_MAIN_ID]));
            obj.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN], rs.getDate(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN]));
            obj.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_LOCATION_TRANSAKSI], rs.getLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_LOCATION_TRANSAKSI]));
            obj.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS], rs.getInt(PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS]));
            obj.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CATATAN], rs.getString(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CATATAN]));
            obj.put(PstReturnKredit.fieldNames[PstReturnKredit.FLD_JENIS_RETURN], rs.getInt(PstReturnKredit.fieldNames[PstReturnKredit.FLD_JENIS_RETURN]));
        } catch (Exception e) {
        }
    }

    public static void convertJsonToObject(JSONObject obj, ReturnKredit entReturnKredit) {
        try {
            entReturnKredit.setOID(obj.optLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_RETURN_ID]));
            entReturnKredit.setNomorReturn(obj.optString(PstReturnKredit.fieldNames[PstReturnKredit.FLD_NOMOR_RETURN]));
            entReturnKredit.setPinjamanId(obj.optLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_PINJAMAN_ID]));
            entReturnKredit.setTransaksiId(obj.optLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TRANSAKSI_ID]));
            entReturnKredit.setCashBillMainId(obj.optLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CASH_BILL_MAIN_ID]));
            entReturnKredit.setTanggalReturn(Formater.formatDate(obj.optString(PstReturnKredit.fieldNames[PstReturnKredit.FLD_TANGGAL_RETURN]), "yyyy-MM-dd"));
            entReturnKredit.setLocationTransaksi(obj.optLong(PstReturnKredit.fieldNames[PstReturnKredit.FLD_LOCATION_TRANSAKSI]));
            entReturnKredit.setStatus(obj.optInt(PstReturnKredit.fieldNames[PstReturnKredit.FLD_STATUS]));
            entReturnKredit.setCatatan(obj.optString(PstReturnKredit.fieldNames[PstReturnKredit.FLD_CATATAN]));
            entReturnKredit.setJenisReturn(obj.optInt(PstReturnKredit.fieldNames[PstReturnKredit.FLD_JENIS_RETURN]));
        } catch (Exception e) {
        }
    }

}
