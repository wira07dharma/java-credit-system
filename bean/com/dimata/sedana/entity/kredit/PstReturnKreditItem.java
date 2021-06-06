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
public class PstReturnKreditItem extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_RETURNKREDITITEM = "sedana_return_kredit_item";
    public static final int FLD_RETURN_KREDIT_ITEM_ID = 0;
    public static final int FLD_RETURN_ID = 1;
    public static final int FLD_CASH_BILL_DETAIL_ID = 2;
    public static final int FLD_MATERIAL_ID = 3;
    public static final int FLD_NILAI_HPP = 4;
    public static final int FLD_NILAI_PERSEDIAAN = 5;
    public static final int FLD_QTY = 6;
    public static final int FLD_NEW_MATERIAL_NAME = 7;
    public static final int FLD_NEW_SKU = 8;
    public static final int FLD_NEW_MATERIAL_ID = 9;

    public static String[] fieldNames = {
        "RETURN_KREDIT_ITEM_ID",
        "RETURN_ID",
        "CASH_BILL_DETAIL_ID",
        "MATERIAL_ID",
        "NILAI_HPP",
        "NILAI_PERSEDIAAN",
        "QTY",
        "NEW_MATERIAL_NAME",
        "NEW_SKU",
        "NEW_MATERIAL_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG
    };

    public PstReturnKreditItem() {
    }

    public PstReturnKreditItem(int i) throws DBException {
        super(new PstReturnKreditItem());
    }

    public PstReturnKreditItem(String sOid) throws DBException {
        super(new PstReturnKreditItem(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstReturnKreditItem(long lOid) throws DBException {
        super(new PstReturnKreditItem(0));
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
        return TBL_RETURNKREDITITEM;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstReturnKreditItem().getClass().getName();
    }

    public static ReturnKreditItem fetchExc(long oid) throws DBException {
        try {
            ReturnKreditItem entReturnKreditItem = new ReturnKreditItem();
            PstReturnKreditItem pstReturnKreditItem = new PstReturnKreditItem(oid);
            entReturnKreditItem.setOID(oid);
            entReturnKreditItem.setReturnId(pstReturnKreditItem.getlong(FLD_RETURN_ID));
            entReturnKreditItem.setCashBillDetailId(pstReturnKreditItem.getlong(FLD_CASH_BILL_DETAIL_ID));
            entReturnKreditItem.setMaterialId(pstReturnKreditItem.getlong(FLD_MATERIAL_ID));
            entReturnKreditItem.setNilaiHpp(pstReturnKreditItem.getdouble(FLD_NILAI_HPP));
            entReturnKreditItem.setNilaiPersediaan(pstReturnKreditItem.getdouble(FLD_NILAI_PERSEDIAAN));
            entReturnKreditItem.setQty(pstReturnKreditItem.getInt(FLD_QTY));
            entReturnKreditItem.setNewMaterialName(pstReturnKreditItem.getString(FLD_NEW_MATERIAL_NAME));
            entReturnKreditItem.setNewSku(pstReturnKreditItem.getString(FLD_NEW_SKU));
            entReturnKreditItem.setNewMaterialId(pstReturnKreditItem.getlong(FLD_NEW_MATERIAL_ID));
            return entReturnKreditItem;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstReturnKreditItem(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        ReturnKreditItem entReturnKreditItem = fetchExc(entity.getOID());
        entity = (Entity) entReturnKreditItem;
        return entReturnKreditItem.getOID();
    }

    public static synchronized long updateExc(ReturnKreditItem entReturnKreditItem) throws DBException {
        try {
            if (entReturnKreditItem.getOID() != 0) {
                PstReturnKreditItem pstReturnKreditItem = new PstReturnKreditItem(entReturnKreditItem.getOID());
                pstReturnKreditItem.setLong(FLD_RETURN_ID, entReturnKreditItem.getReturnId());
                pstReturnKreditItem.setLong(FLD_CASH_BILL_DETAIL_ID, entReturnKreditItem.getCashBillDetailId());
                pstReturnKreditItem.setLong(FLD_MATERIAL_ID, entReturnKreditItem.getMaterialId());
                pstReturnKreditItem.setDouble(FLD_NILAI_HPP, entReturnKreditItem.getNilaiHpp());
                pstReturnKreditItem.setDouble(FLD_NILAI_PERSEDIAAN, entReturnKreditItem.getNilaiPersediaan());
                pstReturnKreditItem.setInt(FLD_QTY, entReturnKreditItem.getQty());
                pstReturnKreditItem.setString(FLD_NEW_MATERIAL_NAME, entReturnKreditItem.getNewMaterialName());
                pstReturnKreditItem.setString(FLD_NEW_SKU, entReturnKreditItem.getNewSku());
                pstReturnKreditItem.setLong(FLD_NEW_MATERIAL_ID, entReturnKreditItem.getNewMaterialId());
                pstReturnKreditItem.update();
                return entReturnKreditItem.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstReturnKreditItem(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((ReturnKreditItem) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstReturnKreditItem pstReturnKreditItem = new PstReturnKreditItem(oid);
            pstReturnKreditItem.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstReturnKreditItem(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(ReturnKreditItem entReturnKreditItem) throws DBException {
        try {
            PstReturnKreditItem pstReturnKreditItem = new PstReturnKreditItem(0);
            pstReturnKreditItem.setLong(FLD_RETURN_ID, entReturnKreditItem.getReturnId());
            pstReturnKreditItem.setLong(FLD_CASH_BILL_DETAIL_ID, entReturnKreditItem.getCashBillDetailId());
            pstReturnKreditItem.setLong(FLD_MATERIAL_ID, entReturnKreditItem.getMaterialId());
            pstReturnKreditItem.setDouble(FLD_NILAI_HPP, entReturnKreditItem.getNilaiHpp());
            pstReturnKreditItem.setDouble(FLD_NILAI_PERSEDIAAN, entReturnKreditItem.getNilaiPersediaan());
            pstReturnKreditItem.setInt(FLD_QTY, entReturnKreditItem.getQty());
            pstReturnKreditItem.setString(FLD_NEW_MATERIAL_NAME, entReturnKreditItem.getNewMaterialName());
            pstReturnKreditItem.setString(FLD_NEW_SKU, entReturnKreditItem.getNewSku());
            pstReturnKreditItem.setLong(FLD_NEW_MATERIAL_ID, entReturnKreditItem.getNewMaterialId());
            pstReturnKreditItem.insert();
            entReturnKreditItem.setOID(pstReturnKreditItem.getlong(FLD_RETURN_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstReturnKreditItem(0), DBException.UNKNOWN);
        }
        return entReturnKreditItem.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((ReturnKreditItem) entity);
    }

    public static void resultToObject(ResultSet rs, ReturnKreditItem entReturnKreditItem) {
        try {
            entReturnKreditItem.setOID(rs.getLong(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_RETURN_KREDIT_ITEM_ID]));
            entReturnKreditItem.setReturnId(rs.getLong(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_RETURN_ID]));
            entReturnKreditItem.setCashBillDetailId(rs.getLong(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_CASH_BILL_DETAIL_ID]));
            entReturnKreditItem.setMaterialId(rs.getLong(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_MATERIAL_ID]));
            entReturnKreditItem.setNilaiHpp(rs.getDouble(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NILAI_HPP]));
            entReturnKreditItem.setNilaiPersediaan(rs.getDouble(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NILAI_PERSEDIAAN]));
            entReturnKreditItem.setQty(rs.getInt(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_QTY]));
            entReturnKreditItem.setNewMaterialName(rs.getString(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NEW_MATERIAL_NAME]));
            entReturnKreditItem.setNewSku(rs.getString(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NEW_SKU]));
            entReturnKreditItem.setNewMaterialId(rs.getLong(PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_NEW_MATERIAL_ID]));
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
            String sql = "SELECT * FROM " + TBL_RETURNKREDITITEM;
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
                ReturnKreditItem entReturnKreditItem = new ReturnKreditItem();
                resultToObject(rs, entReturnKreditItem);
                lists.add(entReturnKreditItem);
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

    public static boolean checkOID(long entReturnKreditItemId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_RETURNKREDITITEM + " WHERE "
                    + PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_RETURN_ID] + " = " + entReturnKreditItemId;
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
            String sql = "SELECT COUNT(" + PstReturnKreditItem.fieldNames[PstReturnKreditItem.FLD_RETURN_ID] + ") FROM " + TBL_RETURNKREDITITEM;
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
                    ReturnKreditItem entReturnKreditItem = (ReturnKreditItem) list.get(ls);
                    if (oid == entReturnKreditItem.getOID()) {
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
