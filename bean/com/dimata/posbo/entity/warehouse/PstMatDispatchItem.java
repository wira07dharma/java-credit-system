package com.dimata.posbo.entity.warehouse;

import com.dimata.posbo.db.*;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.qdep.entity.Entity;
import com.dimata.util.lang.I_Language;
import com.dimata.util.Command;
import com.dimata.posbo.entity.masterdata.*;

import java.util.Vector;
import java.sql.ResultSet;

public class PstMatDispatchItem extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_MAT_DISPATCH_ITEM = "pos_dispatch_material_item";

    public static final int FLD_DISPATCH_MATERIAL_ITEM_ID = 0;
    public static final int FLD_DISPATCH_MATERIAL_ID = 1;
    public static final int FLD_MATERIAL_ID = 2;
    public static final int FLD_UNIT_ID = 3;
    public static final int FLD_QTY = 4;
    public static final int FLD_RESIDUE_QTY = 5;
    public static final int FLD_HPP = 6;
    public static final int FLD_HPP_TOTAL = 7;

    public static final String[] fieldNames = {
        "DISPATCH_MATERIAL_ITEM_ID",
        "DISPATCH_MATERIAL_ID",
        "MATERIAL_ID",
        "UNIT_ID",
        "QTY",
        "RESIDUE_QTY",
        "HPP",
        "HPP_TOTAL"
    };

    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT
    };

    public PstMatDispatchItem() {
    }

    public PstMatDispatchItem(int i) throws DBException {
        super(new PstMatDispatchItem());
    }

    public PstMatDispatchItem(String sOid) throws DBException {
        super(new PstMatDispatchItem(0));
        if (!locate(sOid))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }

    public PstMatDispatchItem(long lOid) throws DBException {
        super(new PstMatDispatchItem(0));
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
        return TBL_MAT_DISPATCH_ITEM;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstMatDispatchItem().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        MatDispatchItem matdispatchitem = fetchExc(ent.getOID());
        ent = (Entity) matdispatchitem;
        return matdispatchitem.getOID();
    }

    synchronized public long insertExc(Entity ent) throws Exception {
        return insertExc((MatDispatchItem) ent);
    }

    synchronized public long updateExc(Entity ent) throws Exception {
        return updateExc((MatDispatchItem) ent);
    }

    synchronized public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static MatDispatchItem fetchExc(long oid) throws DBException {
        try {
            MatDispatchItem matdispatchitem = new MatDispatchItem();
            PstMatDispatchItem pstMatDispatchItem = new PstMatDispatchItem(oid);
            matdispatchitem.setOID(oid);

            matdispatchitem.setDispatchMaterialId(pstMatDispatchItem.getlong(FLD_DISPATCH_MATERIAL_ID));
            matdispatchitem.setMaterialId(pstMatDispatchItem.getlong(FLD_MATERIAL_ID));
            matdispatchitem.setUnitId(pstMatDispatchItem.getlong(FLD_UNIT_ID));
            matdispatchitem.setQty(pstMatDispatchItem.getdouble(FLD_QTY));
            matdispatchitem.setResidueQty(pstMatDispatchItem.getdouble(FLD_RESIDUE_QTY));
            matdispatchitem.setHpp(pstMatDispatchItem.getdouble(FLD_HPP));
            matdispatchitem.setHppTotal(pstMatDispatchItem.getdouble(FLD_HPP_TOTAL));

            return matdispatchitem;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatDispatchItem(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(MatDispatchItem matdispatchitem) throws DBException {
        try {
            PstMatDispatchItem pstMatDispatchItem = new PstMatDispatchItem(0);

            pstMatDispatchItem.setLong(FLD_DISPATCH_MATERIAL_ID, matdispatchitem.getDispatchMaterialId());
            pstMatDispatchItem.setLong(FLD_MATERIAL_ID, matdispatchitem.getMaterialId());
            pstMatDispatchItem.setLong(FLD_UNIT_ID, matdispatchitem.getUnitId());
            pstMatDispatchItem.setDouble(FLD_QTY, matdispatchitem.getQty());
            pstMatDispatchItem.setDouble(FLD_RESIDUE_QTY, matdispatchitem.getResidueQty());
            pstMatDispatchItem.setDouble(FLD_HPP, matdispatchitem.getHpp());
            pstMatDispatchItem.setDouble(FLD_HPP_TOTAL, matdispatchitem.getHppTotal());

            pstMatDispatchItem.insert();
            matdispatchitem.setOID(pstMatDispatchItem.getlong(FLD_DISPATCH_MATERIAL_ITEM_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatDispatchItem(0), DBException.UNKNOWN);
        }
        return matdispatchitem.getOID();
    }

    public static long updateExc(MatDispatchItem matdispatchitem) throws DBException {
        long result = 0;
        try {
            if (matdispatchitem.getOID() != 0) {
                PstMatDispatchItem pstMatDispatchItem = new PstMatDispatchItem(matdispatchitem.getOID());

                pstMatDispatchItem.setLong(FLD_DISPATCH_MATERIAL_ID, matdispatchitem.getDispatchMaterialId());
                pstMatDispatchItem.setLong(FLD_MATERIAL_ID, matdispatchitem.getMaterialId());
                pstMatDispatchItem.setLong(FLD_UNIT_ID, matdispatchitem.getUnitId());
                pstMatDispatchItem.setDouble(FLD_QTY, matdispatchitem.getQty());
                pstMatDispatchItem.setDouble(FLD_RESIDUE_QTY, matdispatchitem.getResidueQty());
                pstMatDispatchItem.setDouble(FLD_HPP, matdispatchitem.getHpp());
                pstMatDispatchItem.setDouble(FLD_HPP_TOTAL, matdispatchitem.getHppTotal());

                pstMatDispatchItem.update();
                result = matdispatchitem.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatDispatchItem(0), DBException.UNKNOWN);
        }
        return result;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstMatDispatchItem pstMatDispatchItem = new PstMatDispatchItem(oid);
            pstMatDispatchItem.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatDispatchItem(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_MAT_DISPATCH_ITEM;
            if (whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            if (order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;

            switch (DBHandler.DBSVR_TYPE) {
                case DBHandler.DBSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    break;

                case DBHandler.DBSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    break;

                case DBHandler.DBSVR_SYBASE:
                    break;

                case DBHandler.DBSVR_ORACLE:
                    break;

                case DBHandler.DBSVR_MSSQL:
                    break;

                default:
                    ;
            }
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                MatDispatchItem matdispatchitem = new MatDispatchItem();
                resultToObject(rs, matdispatchitem);
                lists.add(matdispatchitem);
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

    public static double getTotalTransfer(long oidDispatch) {
        double total = 0.0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM("+fieldNames[FLD_HPP_TOTAL]+") FROM "+TBL_MAT_DISPATCH_ITEM+
                    " WHERE "+fieldNames[FLD_DISPATCH_MATERIAL_ID]+"="+oidDispatch+
                    " GROUP BY "+fieldNames[FLD_DISPATCH_MATERIAL_ID];
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total = rs.getDouble(1);
            }
        }catch(Exception e){}
        return total;
    }
    
    /*
     * For Summary HPP from source dispatch Unit
     * By Mirahu
     */
     public static double getTotalHppSourceTransfer(long oidDfRecGroup) {
        double total = 0.0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM("+fieldNames[FLD_HPP_TOTAL]+") FROM "+TBL_MAT_DISPATCH_ITEM+ " DFI" +
                    " INNER JOIN "+ PstMatDispatchReceiveItem.TBL_MAT_DISPATCH_RECEIVE_ITEM + " DFRI" +
                    " ON DFRI." + PstMatDispatchReceiveItem.fieldNames[PstMatDispatchReceiveItem.FLD_DISPATCH_MATERIAL_ITEM_ID] +
                    " = DFI." + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ITEM_ID] +
                    " WHERE DFRI."+PstMatDispatchReceiveItem.fieldNames[PstMatDispatchReceiveItem.FLD_DF_REC_GROUP_ID]+"="+oidDfRecGroup;
                    //" GROUP BY "+fieldNames[FLD_DISPATCH_MATERIAL_ID];
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total = rs.getDouble(1);
            }
        }catch(Exception e){}
        return total;
    }

    /*
     * End Of Summary HPP
     */


    //Untuk menampilkan komplit dengan material dan unit
    public static Vector list(int limitStart, int recordToGet, long oidMatDispatch) {
             return list(limitStart, recordToGet, oidMatDispatch,"");
    }

    //Untuk menampilkan komplit dengan material dan unit
    public static Vector list(int limitStart, int recordToGet, long oidMatDispatch, String order) {
       if(limitStart<0){
            limitStart=0;
       }
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT DFI." + fieldNames[FLD_DISPATCH_MATERIAL_ITEM_ID] +
                    " , DFI." + fieldNames[FLD_MATERIAL_ID] +
                    " , DFI." + fieldNames[FLD_UNIT_ID] +
                    " , DFI." + fieldNames[FLD_QTY] +
                    " , MAT." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    " , MAT." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    " , UNT." + PstUnit.fieldNames[PstUnit.FLD_CODE] +
                    " , MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST] +
                    " , MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST_CURRENCY_ID] +
                    " , MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_PRICE] +
                    " , MAT." + PstMaterial.fieldNames[PstMaterial.FLD_REQUIRED_SERIAL_NUMBER] +
                    " , DFI." + fieldNames[FLD_HPP] +
                    " , DFI." + fieldNames[FLD_HPP_TOTAL] +
                    " , MAT." + PstMaterial.fieldNames[PstMaterial.FLD_GONDOLA_CODE] +
                    " FROM (" + TBL_MAT_DISPATCH_ITEM + " DFI" +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " MAT" +
                    " ON DFI." + fieldNames[FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] + ")" +
                    " LEFT JOIN " + PstUnit.TBL_P2_UNIT + " UNT" +
                    " ON DFI." + fieldNames[FLD_UNIT_ID] +
                    " = UNT." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " WHERE DFI." + fieldNames[FLD_DISPATCH_MATERIAL_ID] +
                    " = " + oidMatDispatch +
                   ( (order!=null && order.trim().length()>0) ? (" ORDER BY " + order ) :
                        (" ORDER BY MAT." +  PstMaterial.fieldNames[PstMaterial.FLD_SKU]));


            switch (DBHandler.DBSVR_TYPE) {
                case DBHandler.DBSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    break;

                case DBHandler.DBSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    break;

                case DBHandler.DBSVR_SYBASE:
                    break;

                case DBHandler.DBSVR_ORACLE:
                    break;

                case DBHandler.DBSVR_MSSQL:
                    break;

                default:
                    ;
            }
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector temp = new Vector();
                MatDispatchItem dfItem = new MatDispatchItem();
                Material mat = new Material();
                Unit unit = new Unit();

                dfItem.setOID(rs.getLong(1));
                dfItem.setMaterialId(rs.getLong(2));
                dfItem.setUnitId(rs.getLong(3));
                dfItem.setQty(rs.getDouble(4));
                dfItem.setHpp(rs.getDouble(12));
                dfItem.setHppTotal(rs.getDouble(13));
                temp.add(dfItem);
                
                mat.setSku(rs.getString(5));
                mat.setName(rs.getString(6));
                mat.setDefaultCost(rs.getDouble(8));
                mat.setDefaultCostCurrencyId(rs.getLong(9));
                mat.setDefaultPrice(rs.getDouble(10));
                mat.setRequiredSerialNumber(rs.getInt(11));
                mat.setGondolaCode(rs.getString(14));
                temp.add(mat);

                unit.setCode(rs.getString(7));
                temp.add(unit);

                lists.add(temp);
            }
            rs.close();

        } catch (Exception e) {
            lists = new Vector();
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return lists;
    }

    //Untuk menampilkan komplit dengan material dan unit
    public static Vector list(String whereClause, String orderClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT DFI." + fieldNames[FLD_DISPATCH_MATERIAL_ITEM_ID] +
                    " , DFI." + fieldNames[FLD_MATERIAL_ID] +
                    " , DFI." + fieldNames[FLD_UNIT_ID] +
                    " , DFI." + fieldNames[FLD_QTY] +
                    " , MAT." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    " , MAT." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    " , UNT." + PstUnit.fieldNames[PstUnit.FLD_CODE] +
                    " , MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST] +
                    " , MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST_CURRENCY_ID] +
                    " , CURR." + PstMatCurrency.fieldNames[PstMatCurrency.FLD_CODE] +
                    " FROM ((" + TBL_MAT_DISPATCH_ITEM + " DFI" +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " MAT" +
                    " ON DFI." + fieldNames[FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " ) INNER JOIN " + PstUnit.TBL_P2_UNIT + " UNT" +
                    " ON DFI." + fieldNames[FLD_UNIT_ID] +
                    " = UNT." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " ) INNER JOIN " + PstMatCurrency.TBL_CURRENCY + " CURR" +
                    " ON MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_COST_CURRENCY_ID] +
                    " = CURR." + PstMatCurrency.fieldNames[PstMatCurrency.FLD_CURRENCY_ID];

            if (whereClause.length() > 0)
                sql += " WHERE " + whereClause;

            if (orderClause.length() > 0)
                sql += " ORDER BY " + whereClause;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector temp = new Vector();
                MatDispatchItem dfItem = new MatDispatchItem();
                Material mat = new Material();
                Unit unit = new Unit();
                MatCurrency curr = new MatCurrency();

                dfItem.setOID(rs.getLong(1));
                dfItem.setMaterialId(rs.getLong(2));
                dfItem.setUnitId(rs.getLong(3));
                dfItem.setQty(rs.getDouble(4));
                temp.add(dfItem);

                mat.setSku(rs.getString(5));
                mat.setName(rs.getString(6));
                mat.setDefaultCost(rs.getDouble(8));
                mat.setDefaultCostCurrencyId(rs.getLong(9));
                temp.add(mat);

                unit.setCode(rs.getString(7));
                temp.add(unit);

                curr.setCode(rs.getString(10));
                temp.add(curr);

                lists.add(temp);
            }
            rs.close();

        } catch (Exception e) {
            lists = new Vector();
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return lists;
    }

    public static void resultToObject(ResultSet rs, MatDispatchItem matdispatchitem) {
        try {
            matdispatchitem.setOID(rs.getLong(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ITEM_ID]));
            matdispatchitem.setDispatchMaterialId(rs.getLong(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ID]));
            matdispatchitem.setMaterialId(rs.getLong(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID]));
            matdispatchitem.setUnitId(rs.getLong(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_UNIT_ID]));
            matdispatchitem.setQty(rs.getDouble(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_QTY]));
            matdispatchitem.setResidueQty(rs.getDouble(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_RESIDUE_QTY]));
            matdispatchitem.setHppTotal(rs.getDouble(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_HPP_TOTAL]));
            matdispatchitem.setHpp(rs.getDouble(PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_HPP]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long materialDispatchItemId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_MAT_DISPATCH_ITEM +
                    " WHERE " + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ITEM_ID] +
                    " = " + materialDispatchItemId;

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
        }
        return result;
    }

    public static int getCount(String whereClause) {
        int count = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ITEM_ID] +
                    ") AS CNT FROM " + TBL_MAT_DISPATCH_ITEM;

            if (whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;

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


    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    MatDispatchItem matdispatchitem = (MatDispatchItem) list.get(ls);
                    if (oid == matdispatchitem.getOID())
                        found = true;
                }
            }
        }
        if ((start >= size) && (size > 0))
            start = start - recordToGet;

        return start;
    }

    /* This method used to find command where current data */
    public static int findLimitCommand(int start, int recordToGet, int vectSize) {
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + (recordToGet - mdl);
        if (start == 0)
            cmd = Command.FIRST;
        else {
            if (start == (vectSize - recordToGet))
                cmd = Command.LAST;
            else {
                start = start + recordToGet;
                if (start <= (vectSize - recordToGet)) {
                    cmd = Command.NEXT;
                } else {
                    start = start - recordToGet;
                    if (start > 0) {
                        cmd = Command.PREV;
                    }
                }
            }
        }

        return cmd;
    }

    public static long deleteExcByParent(long oid) throws DBException {
        long hasil = 0;
        try {
            String sql = "DELETE FROM " + TBL_MAT_DISPATCH_ITEM +
                    " WHERE " + fieldNames[FLD_DISPATCH_MATERIAL_ID] +
                    " = " + oid;
            int result = execUpdate(sql);
            hasil = oid;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatDispatchItem(0), DBException.UNKNOWN);
        }
        return hasil;
    }

    /** di gunakan untuk mencari object dispatch item
     */
    public static MatDispatchItem getObjectDispatchItem(long oidMaterial, long oidDispatch) {
        MatDispatchItem matDispatchItem = new MatDispatchItem();
        try {
            String whereClause = PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ID] + "=" + oidDispatch +
                    " AND " + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_MATERIAL_ID] + "=" + oidMaterial;
            Vector vect = PstMatDispatchItem.list(0, 0, whereClause, "");
            if (vect != null && vect.size() > 0) {
                matDispatchItem = (MatDispatchItem) vect.get(0);
            }

        } catch (Exception e) {
        }
        return matDispatchItem;
    }


}
