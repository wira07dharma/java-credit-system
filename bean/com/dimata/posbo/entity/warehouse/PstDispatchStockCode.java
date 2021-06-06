/**
 * Created by IntelliJ IDEA.
 * User: gadnyana
 * Date: Dec 9, 2004
 * Time: 11:29:15 AM
 * To change this template use Options | File Templates.
 */
package com.dimata.posbo.entity.warehouse;

import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.qdep.entity.Entity;
import com.dimata.util.lang.I_Language;
import com.dimata.posbo.db.*;

import java.util.Vector;
import java.sql.ResultSet;

public class PstDispatchStockCode extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_POS_DISPATCH_MATERIAL_CODE = "pos_df_material_item_code";

    public static final int FLD_DISPATCH_MATERIAL_CODE_ID = 0;
    public static final int FLD_DISPATCH_MATERIAL_ITEM_ID = 1;
    public static final int FLD_STOCK_CODE = 2;

    public static final String[] fieldNames = {
        "DISPATCH_MATERIAL_ITEM_CODE_ID",
        "DISPATCH_MATERIAL_ITEM_ID",
        "STOCK_CODE"
    };

    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING
    };

    public PstDispatchStockCode() {
    }

    public PstDispatchStockCode(int i) throws DBException {
        super(new PstDispatchStockCode());
    }

    public PstDispatchStockCode(String sOid) throws DBException {
        super(new PstDispatchStockCode(0));
        if (!locate(sOid))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }

    public PstDispatchStockCode(long lOid) throws DBException {
        super(new PstDispatchStockCode(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public String getTableName() {
        return TBL_POS_DISPATCH_MATERIAL_CODE;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstDispatchStockCode().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        DispatchStockCode stockCode = fetchExc(ent.getOID());
        ent = (Entity) stockCode;
        return stockCode.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((DispatchStockCode) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((DispatchStockCode) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static DispatchStockCode fetchExc(long oid) throws DBException {
        try {
            DispatchStockCode dispatchStockCode = new DispatchStockCode();
            PstDispatchStockCode pstDispatchStockCode = new PstDispatchStockCode(oid);
            dispatchStockCode.setOID(oid);

            dispatchStockCode.setDispatchMaterialItemId(pstDispatchStockCode.getlong(FLD_DISPATCH_MATERIAL_ITEM_ID));
            dispatchStockCode.setStockCode(pstDispatchStockCode.getString(FLD_STOCK_CODE));

            return dispatchStockCode;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDispatchStockCode(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(DispatchStockCode materialStockCode) throws DBException {
        try {
            PstDispatchStockCode pstDispatchStockCode = new PstDispatchStockCode(0);

            pstDispatchStockCode.setLong(FLD_DISPATCH_MATERIAL_ITEM_ID, materialStockCode.getDispatchMaterialItemId());
            pstDispatchStockCode.setString(FLD_STOCK_CODE, materialStockCode.getStockCode());

            pstDispatchStockCode.insert();
            materialStockCode.setOID(pstDispatchStockCode.getlong(FLD_DISPATCH_MATERIAL_CODE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDispatchStockCode(0), DBException.UNKNOWN);
        }
        return materialStockCode.getOID();
    }

    public static long updateExc(DispatchStockCode materialStockCode) throws DBException {
        try {
            if (materialStockCode.getOID() != 0) {
                PstDispatchStockCode pstDispatchStockCode = new PstDispatchStockCode(materialStockCode.getOID());

                pstDispatchStockCode.setLong(FLD_DISPATCH_MATERIAL_ITEM_ID, materialStockCode.getDispatchMaterialItemId());
                pstDispatchStockCode.setString(FLD_STOCK_CODE, materialStockCode.getStockCode());

                pstDispatchStockCode.update();
                return materialStockCode.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDispatchStockCode(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstDispatchStockCode pstDispatchStockCode = new PstDispatchStockCode(oid);
            pstDispatchStockCode.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDispatchStockCode(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_POS_DISPATCH_MATERIAL_CODE;
            if (whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            if (order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;
            if (limitStart == 0 && recordToGet == 0)
                sql = sql + "";
            else
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                DispatchStockCode materialStockCode = new DispatchStockCode();
                resultToObject(rs, materialStockCode);
                lists.add(materialStockCode);
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

    private static void resultToObject(ResultSet rs, DispatchStockCode materialStockCode) {
        try {
            materialStockCode.setOID(rs.getLong(PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_DISPATCH_MATERIAL_CODE_ID]));
            materialStockCode.setDispatchMaterialItemId(rs.getLong(PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_DISPATCH_MATERIAL_ITEM_ID]));
            materialStockCode.setStockCode(rs.getString(PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_STOCK_CODE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long oid) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_POS_DISPATCH_MATERIAL_CODE + " WHERE " +
                    PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_DISPATCH_MATERIAL_CODE_ID] + " = " + oid;

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
            String sql = "SELECT COUNT(" + PstDispatchStockCode.fieldNames[PstDispatchStockCode.FLD_DISPATCH_MATERIAL_CODE_ID] + ") FROM " + TBL_POS_DISPATCH_MATERIAL_CODE;
            if (whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;

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


    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    DispatchStockCode materialStockCode = (DispatchStockCode) list.get(ls);
                    if (oid == materialStockCode.getOID())
                        found = true;
                }
            }
        }
        if ((start >= size) && (size > 0))
            start = start - recordToGet;

        return start;
    }

    /** gadnyana
     * untuk mencari dat seial code yang di cari
     * berdasarkan oid material dan item dispatch
     * @param oidMat
     * @param oidDf
     * @return
     */
    public static Vector getSerialCodeDispatchBy(long oidMat, long oidDf) {
        Vector list = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT DCODE.* FROM " + TBL_POS_DISPATCH_MATERIAL_CODE + " AS DCODE " +
                    " INNER JOIN " + PstMatDispatchItem.TBL_MAT_DISPATCH_ITEM + " AS IT " +
                    " ON IT.DISPATCH_MATERIAL_ITEM_ID = DCODE.DISPATCH_MATERIAL_ITEM_ID " +
                    " WHERE IT.DISPATCH_MATERIAL_ID = " + oidDf +
                    " AND IT.MATERIAL_ID = " + oidMat;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                DispatchStockCode materialStockCode = new DispatchStockCode();
                resultToObject(rs, materialStockCode);
                list.add(materialStockCode);
            }

        } catch (Exception e) {
            System.out.println("");
        }
        return list;
    }

}
