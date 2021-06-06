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

public class PstCostingStockCode extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_POS_COSTING_MATERIAL_CODE = "pos_costing_material_item_code";

    public static final int FLD_COSTING_MATERIAL_CODE_ID = 0;
    public static final int FLD_COSTING_MATERIAL_ITEM_ID = 1;
    public static final int FLD_STOCK_CODE = 2;

    public static final String[] fieldNames = {
        "COSTING_MATERIAL_ITEM_CODE_ID",
        "COSTING_MATERIAL_ITEM_ID",
        "STOCK_CODE"
    };

    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING
    };

    public PstCostingStockCode() {
    }

    public PstCostingStockCode(int i) throws DBException {
        super(new PstCostingStockCode());
    }

    public PstCostingStockCode(String sOid) throws DBException {
        super(new PstCostingStockCode(0));
        if (!locate(sOid))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }

    public PstCostingStockCode(long lOid) throws DBException {
        super(new PstCostingStockCode(0));
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
        return TBL_POS_COSTING_MATERIAL_CODE;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCostingStockCode().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        CostingStockCode stockCode = fetchExc(ent.getOID());
        ent = (Entity) stockCode;
        return stockCode.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((CostingStockCode) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((CostingStockCode) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static CostingStockCode fetchExc(long oid) throws DBException {
        try {
            CostingStockCode dispatchStockCode = new CostingStockCode();
            PstCostingStockCode pstCostingStockCode = new PstCostingStockCode(oid);
            dispatchStockCode.setOID(oid);

            dispatchStockCode.setCostingMaterialItemId(pstCostingStockCode.getlong(FLD_COSTING_MATERIAL_ITEM_ID));
            dispatchStockCode.setStockCode(pstCostingStockCode.getString(FLD_STOCK_CODE));

            return dispatchStockCode;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCostingStockCode(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(CostingStockCode materialStockCode) throws DBException {
        try {
            PstCostingStockCode pstCostingStockCode = new PstCostingStockCode(0);

            pstCostingStockCode.setLong(FLD_COSTING_MATERIAL_ITEM_ID, materialStockCode.getCostingMaterialItemId());
            pstCostingStockCode.setString(FLD_STOCK_CODE, materialStockCode.getStockCode());

            pstCostingStockCode.insert();
            materialStockCode.setOID(pstCostingStockCode.getlong(FLD_COSTING_MATERIAL_CODE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCostingStockCode(0), DBException.UNKNOWN);
        }
        return materialStockCode.getOID();
    }

    public static long updateExc(CostingStockCode materialStockCode) throws DBException {
        try {
            if (materialStockCode.getOID() != 0) {
                PstCostingStockCode pstCostingStockCode = new PstCostingStockCode(materialStockCode.getOID());

                pstCostingStockCode.setLong(FLD_COSTING_MATERIAL_ITEM_ID, materialStockCode.getCostingMaterialItemId());
                pstCostingStockCode.setString(FLD_STOCK_CODE, materialStockCode.getStockCode());

                pstCostingStockCode.update();
                return materialStockCode.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCostingStockCode(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstCostingStockCode pstCostingStockCode = new PstCostingStockCode(oid);
            pstCostingStockCode.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCostingStockCode(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_POS_COSTING_MATERIAL_CODE;
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
                CostingStockCode materialStockCode = new CostingStockCode();
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

    private static void resultToObject(ResultSet rs, CostingStockCode materialStockCode) {
        try {
            materialStockCode.setOID(rs.getLong(PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_COSTING_MATERIAL_CODE_ID]));
            materialStockCode.setCostingMaterialItemId(rs.getLong(PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_COSTING_MATERIAL_ITEM_ID]));
            materialStockCode.setStockCode(rs.getString(PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_STOCK_CODE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long oid) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_POS_COSTING_MATERIAL_CODE + " WHERE " +
                    PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_COSTING_MATERIAL_CODE_ID] + " = " + oid;

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
            String sql = "SELECT COUNT(" + PstCostingStockCode.fieldNames[PstCostingStockCode.FLD_COSTING_MATERIAL_CODE_ID] + ") FROM " + TBL_POS_COSTING_MATERIAL_CODE;
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
                    CostingStockCode materialStockCode = (CostingStockCode) list.get(ls);
                    if (oid == materialStockCode.getOID())
                        found = true;
                }
            }
        }
        if ((start >= size) && (size > 0))
            start = start - recordToGet;

        return start;
    }

}
