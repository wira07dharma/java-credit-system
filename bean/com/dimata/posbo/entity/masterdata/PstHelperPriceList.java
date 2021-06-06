/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.posbo.entity.masterdata;

import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author gndiw
 */
public class PstHelperPriceList extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_HELPERPRICELIST = "helper_price_list_kredit";
    public static final int FLD_PRICE_LIST_ID = 0;
    public static final int FLD_MATERIAL_ID = 1;
    public static final int FLD_SKU = 2;
    public static final int FLD_NAME = 3;
    public static final int FLD_MERK = 4;
    public static final int FLD_JANGKA_WAKTU_ID = 5;
    public static final int FLD_JML_ANGSURAN = 6;
    public static final int FLD_CATEGORY_ID = 7;

    public static String[] fieldNames = {
        "PRICE_LIST_ID",
        "MATERIAL_ID",
        "SKU",
        "NAME",
        "MERK",
        "JANGKA_WAKTU_ID",
        "JML_ANGSURAN",
        "CATEGORY_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG
    };

    public PstHelperPriceList() {
    }

    public PstHelperPriceList(int i) throws DBException {
        super(new PstHelperPriceList());
    }

    public PstHelperPriceList(String sOid) throws DBException {
        super(new PstHelperPriceList(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstHelperPriceList(long lOid) throws DBException {
        super(new PstHelperPriceList(0));
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
        return TBL_HELPERPRICELIST;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstHelperPriceList().getClass().getName();
    }

    public static HelperPriceList fetchExc(long oid) throws DBException {
        try {
            HelperPriceList entHelperPriceList = new HelperPriceList();
            PstHelperPriceList pstHelperPriceList = new PstHelperPriceList(oid);
            entHelperPriceList.setOID(oid);
            entHelperPriceList.setMaterialId(pstHelperPriceList.getlong(FLD_MATERIAL_ID));
            entHelperPriceList.setSku(pstHelperPriceList.getString(FLD_SKU));
            entHelperPriceList.setName(pstHelperPriceList.getString(FLD_NAME));
            entHelperPriceList.setMerk(pstHelperPriceList.getString(FLD_MERK));
            entHelperPriceList.setJangkaWaktuId(pstHelperPriceList.getlong(FLD_JANGKA_WAKTU_ID));
            entHelperPriceList.setJmlAngsuran(pstHelperPriceList.getdouble(FLD_JML_ANGSURAN));
            entHelperPriceList.setCategoryId(pstHelperPriceList.getlong(FLD_CATEGORY_ID));
            return entHelperPriceList;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHelperPriceList(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        HelperPriceList entHelperPriceList = fetchExc(entity.getOID());
        entity = (Entity) entHelperPriceList;
        return entHelperPriceList.getOID();
    }

    public static synchronized long updateExc(HelperPriceList entHelperPriceList) throws DBException {
        try {
            if (entHelperPriceList.getOID() != 0) {
                PstHelperPriceList pstHelperPriceList = new PstHelperPriceList(entHelperPriceList.getOID());
                pstHelperPriceList.setLong(FLD_MATERIAL_ID, entHelperPriceList.getMaterialId());
                pstHelperPriceList.setString(FLD_SKU, entHelperPriceList.getSku());
                pstHelperPriceList.setString(FLD_NAME, entHelperPriceList.getName());
                pstHelperPriceList.setString(FLD_MERK, entHelperPriceList.getMerk());
                pstHelperPriceList.setLong(FLD_JANGKA_WAKTU_ID, entHelperPriceList.getJangkaWaktuId());
                pstHelperPriceList.setDouble(FLD_JML_ANGSURAN, entHelperPriceList.getJmlAngsuran());
                pstHelperPriceList.setLong(FLD_CATEGORY_ID, entHelperPriceList.getCategoryId());
                pstHelperPriceList.update();
                return entHelperPriceList.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHelperPriceList(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((HelperPriceList) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstHelperPriceList pstHelperPriceList = new PstHelperPriceList(oid);
            pstHelperPriceList.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHelperPriceList(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(HelperPriceList entHelperPriceList) throws DBException {
        try {
            PstHelperPriceList pstHelperPriceList = new PstHelperPriceList(0);
            pstHelperPriceList.setLong(FLD_MATERIAL_ID, entHelperPriceList.getMaterialId());
            pstHelperPriceList.setString(FLD_SKU, entHelperPriceList.getSku());
            pstHelperPriceList.setString(FLD_NAME, entHelperPriceList.getName());
            pstHelperPriceList.setString(FLD_MERK, entHelperPriceList.getMerk());
            pstHelperPriceList.setLong(FLD_JANGKA_WAKTU_ID, entHelperPriceList.getJangkaWaktuId());
            pstHelperPriceList.setDouble(FLD_JML_ANGSURAN, entHelperPriceList.getJmlAngsuran());
            pstHelperPriceList.setLong(FLD_CATEGORY_ID, entHelperPriceList.getCategoryId());
            pstHelperPriceList.insert();
            entHelperPriceList.setOID(pstHelperPriceList.getlong(FLD_MATERIAL_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHelperPriceList(0), DBException.UNKNOWN);
        }
        return entHelperPriceList.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((HelperPriceList) entity);
    }

    public static void resultToObject(ResultSet rs, HelperPriceList entHelperPriceList) {
        try {
            entHelperPriceList.setOID(rs.getLong(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_PRICE_LIST_ID]));
            entHelperPriceList.setMaterialId(rs.getLong(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_MATERIAL_ID]));
            entHelperPriceList.setSku(rs.getString(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_SKU]));
            entHelperPriceList.setName(rs.getString(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_NAME]));
            entHelperPriceList.setMerk(rs.getString(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_MERK]));
            entHelperPriceList.setJangkaWaktuId(rs.getLong(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_JANGKA_WAKTU_ID]));
            entHelperPriceList.setJmlAngsuran(rs.getDouble(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_JML_ANGSURAN]));
            entHelperPriceList.setCategoryId(rs.getLong(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_CATEGORY_ID]));
        } catch (Exception e) {
        }
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Hashtable<String, Double> listHash(String whereClause){
        Hashtable<String, Double> hashList = new Hashtable<>();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HELPERPRICELIST;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                HelperPriceList entHelperPriceList = new HelperPriceList();
                entHelperPriceList.setMaterialId(rs.getLong(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_MATERIAL_ID]));
                entHelperPriceList.setJangkaWaktuId(rs.getLong(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_JANGKA_WAKTU_ID]));
                entHelperPriceList.setJmlAngsuran(rs.getDouble(PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_JML_ANGSURAN]));
                hashList.put(entHelperPriceList.getMaterialId()+"_"+entHelperPriceList.getJangkaWaktuId(), entHelperPriceList.getJmlAngsuran());
            }
            rs.close();
            return hashList;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return hashList;
    }
    
    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HELPERPRICELIST;
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
                HelperPriceList entHelperPriceList = new HelperPriceList();
                resultToObject(rs, entHelperPriceList);
                lists.add(entHelperPriceList);
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

    public static boolean checkOID(long entHelperPriceListId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HELPERPRICELIST + " WHERE "
                    + PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_MATERIAL_ID] + " = " + entHelperPriceListId;
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
            String sql = "SELECT COUNT(" + PstHelperPriceList.fieldNames[PstHelperPriceList.FLD_MATERIAL_ID] + ") FROM " + TBL_HELPERPRICELIST;
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
                    HelperPriceList entHelperPriceList = (HelperPriceList) list.get(ls);
                    if (oid == entHelperPriceList.getOID()) {
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
