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
public class PstHapusKreditItem extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_HAPUSKREDITITEM = "sedana_hapus_kredit_item";
    public static final int FLD_HAPUS_KREDIT_ITEM_ID = 0;
    public static final int FLD_HAPUS_ID = 1;
    public static final int FLD_CASH_BILL_DETAIL_ID = 2;
    public static final int FLD_MATERIAL_ID = 3;
    public static final int FLD_NILAI_HPP = 4;
    public static final int FLD_QTY = 5;

    public static String[] fieldNames = {
        "HAPUS_KREDIT_ITEM_ID",
        "HAPUS_ID",
        "CASH_BILL_DETAIL_ID",
        "MATERIAL_ID",
        "NILAI_HPP",
        "QTY"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_STRING
    };

    public PstHapusKreditItem() {
    }

    public PstHapusKreditItem(int i) throws DBException {
        super(new PstHapusKreditItem());
    }

    public PstHapusKreditItem(String sOid) throws DBException {
        super(new PstHapusKreditItem(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstHapusKreditItem(long lOid) throws DBException {
        super(new PstHapusKreditItem(0));
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
        return TBL_HAPUSKREDITITEM;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstHapusKreditItem().getClass().getName();
    }

    public static HapusKreditItem fetchExc(long oid) throws DBException {
        try {
            HapusKreditItem entHapusKreditItem = new HapusKreditItem();
            PstHapusKreditItem pstHapusKreditItem = new PstHapusKreditItem(oid);
            entHapusKreditItem.setOID(oid);
            entHapusKreditItem.setHapusId(pstHapusKreditItem.getlong(FLD_HAPUS_ID));
            entHapusKreditItem.setCashBillDetailId(pstHapusKreditItem.getlong(FLD_CASH_BILL_DETAIL_ID));
            entHapusKreditItem.setMaterialId(pstHapusKreditItem.getlong(FLD_MATERIAL_ID));
            entHapusKreditItem.setNilaiHpp(pstHapusKreditItem.getdouble(FLD_NILAI_HPP));
            entHapusKreditItem.setQty(pstHapusKreditItem.getString(FLD_QTY));
            return entHapusKreditItem;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHapusKreditItem(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        HapusKreditItem entHapusKreditItem = fetchExc(entity.getOID());
        entity = (Entity) entHapusKreditItem;
        return entHapusKreditItem.getOID();
    }

    public static synchronized long updateExc(HapusKreditItem entHapusKreditItem) throws DBException {
        try {
            if (entHapusKreditItem.getOID() != 0) {
                PstHapusKreditItem pstHapusKreditItem = new PstHapusKreditItem(entHapusKreditItem.getOID());
                pstHapusKreditItem.setLong(FLD_HAPUS_ID, entHapusKreditItem.getHapusId());
                pstHapusKreditItem.setLong(FLD_CASH_BILL_DETAIL_ID, entHapusKreditItem.getCashBillDetailId());
                pstHapusKreditItem.setLong(FLD_MATERIAL_ID, entHapusKreditItem.getMaterialId());
                pstHapusKreditItem.setDouble(FLD_NILAI_HPP, entHapusKreditItem.getNilaiHpp());
                pstHapusKreditItem.setString(FLD_QTY, entHapusKreditItem.getQty());
                pstHapusKreditItem.update();
                return entHapusKreditItem.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHapusKreditItem(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((HapusKreditItem) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstHapusKreditItem pstHapusKreditItem = new PstHapusKreditItem(oid);
            pstHapusKreditItem.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHapusKreditItem(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(HapusKreditItem entHapusKreditItem) throws DBException {
        try {
            PstHapusKreditItem pstHapusKreditItem = new PstHapusKreditItem(0);
            pstHapusKreditItem.setLong(FLD_HAPUS_ID, entHapusKreditItem.getHapusId());
            pstHapusKreditItem.setLong(FLD_CASH_BILL_DETAIL_ID, entHapusKreditItem.getCashBillDetailId());
            pstHapusKreditItem.setLong(FLD_MATERIAL_ID, entHapusKreditItem.getMaterialId());
            pstHapusKreditItem.setDouble(FLD_NILAI_HPP, entHapusKreditItem.getNilaiHpp());
            pstHapusKreditItem.setString(FLD_QTY, entHapusKreditItem.getQty());
            pstHapusKreditItem.insert();
            entHapusKreditItem.setOID(pstHapusKreditItem.getlong(FLD_HAPUS_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstHapusKreditItem(0), DBException.UNKNOWN);
        }
        return entHapusKreditItem.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((HapusKreditItem) entity);
    }

    public static void resultToObject(ResultSet rs, HapusKreditItem entHapusKreditItem) {
        try {
            entHapusKreditItem.setOID(rs.getLong(PstHapusKreditItem.fieldNames[PstHapusKreditItem.FLD_HAPUS_KREDIT_ITEM_ID]));
            entHapusKreditItem.setHapusId(rs.getLong(PstHapusKreditItem.fieldNames[PstHapusKreditItem.FLD_HAPUS_ID]));
            entHapusKreditItem.setCashBillDetailId(rs.getLong(PstHapusKreditItem.fieldNames[PstHapusKreditItem.FLD_CASH_BILL_DETAIL_ID]));
            entHapusKreditItem.setMaterialId(rs.getLong(PstHapusKreditItem.fieldNames[PstHapusKreditItem.FLD_MATERIAL_ID]));
            entHapusKreditItem.setNilaiHpp(rs.getDouble(PstHapusKreditItem.fieldNames[PstHapusKreditItem.FLD_NILAI_HPP]));
            entHapusKreditItem.setQty(rs.getString(PstHapusKreditItem.fieldNames[PstHapusKreditItem.FLD_QTY]));
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
            String sql = "SELECT * FROM " + TBL_HAPUSKREDITITEM;
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
                HapusKreditItem entHapusKreditItem = new HapusKreditItem();
                resultToObject(rs, entHapusKreditItem);
                lists.add(entHapusKreditItem);
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

    public static boolean checkOID(long entHapusKreditItemId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HAPUSKREDITITEM + " WHERE "
                    + PstHapusKreditItem.fieldNames[PstHapusKreditItem.FLD_HAPUS_ID] + " = " + entHapusKreditItemId;
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
            String sql = "SELECT COUNT(" + PstHapusKreditItem.fieldNames[PstHapusKreditItem.FLD_HAPUS_ID] + ") FROM " + TBL_HAPUSKREDITITEM;
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
                    HapusKreditItem entHapusKreditItem = (HapusKreditItem) list.get(ls);
                    if (oid == entHapusKreditItem.getOID()) {
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
