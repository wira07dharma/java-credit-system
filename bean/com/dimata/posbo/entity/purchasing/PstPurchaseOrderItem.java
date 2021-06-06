package com.dimata.posbo.entity.purchasing;

/* package java */

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.util.*;
import com.dimata.posbo.db.*;
import com.dimata.qdep.entity.*;

/* package garment */
import com.dimata.posbo.entity.purchasing.*;
import com.dimata.posbo.entity.masterdata.*;

public class PstPurchaseOrderItem extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {
    
    public static final String TBL_PURCHASE_ORDER_ITEM = "pos_purchase_order_item";
    
    public static final int FLD_PURCHASE_ORDER_ITEM_ID = 0;
    public static final int FLD_PURCHASE_ORDER_ID = 1;
    public static final int FLD_MATERIAL_ID = 2;
    public static final int FLD_UNIT_ID = 3;
    public static final int FLD_PRICE = 4;
    public static final int FLD_CURRENCY_ID = 5;
    public static final int FLD_QUANTITY = 6;
    public static final int FLD_DISCOUNT = 7;
    public static final int FLD_TOTAL = 8;
    public static final int FLD_ORG_BUYING_PRICE = 9;
    public static final int FLD_DISCOUNT2 = 10;
    public static final int FLD_DISCOUNT_NOMINAL = 11;
    public static final int FLD_CURR_BUYING_PRICE = 12;
    public static final int FLD_DISCOUNT1 = 13;
    public static final int FLD_RESIDU_QTY = 14;
    
    public static final String[] fieldNames = {
        "PURCHASE_ORDER_ITEM_ID",
        "PURCHASE_ORDER_ID",
        "MATERIAL_ID",
        "UNIT_ID",
        "PRICE",
        "CURRENCY_ID",
        "QTY",
        "DISCOUNT",
        "TOTAL",
        "ORG_BUYING_PRICE",
        "DISCOUNT2",
        "DISCOUNT_NOMINAL",
        "CURR_BUYING_PRICE",
        "DISCOUNT1",
        "RESIDU_QTY"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT
    };
    
    
    public static final int DATASTATUS_CLEAN = 0;
    public static final int DATASTATUS_ADD = 1;
    public static final int DATASTATUS_UPDATE = 2;
    public static final int DATASTATUS_DELETE = 3;
    
    
    public PstPurchaseOrderItem() {
    }
    
    public PstPurchaseOrderItem(int i) throws DBException {
        super(new PstPurchaseOrderItem());
    }
    
    public PstPurchaseOrderItem(String sOid) throws DBException {
        super(new PstPurchaseOrderItem(0));
        if (!locate(sOid))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }
    
    public PstPurchaseOrderItem(long lOid) throws DBException {
        super(new PstPurchaseOrderItem(0));
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
        return TBL_PURCHASE_ORDER_ITEM;
    }
    
    public String[] getFieldNames() {
        return fieldNames;
    }
    
    public int[] getFieldTypes() {
        return fieldTypes;
    }
    
    public String getPersistentName() {
        return new PstPurchaseOrderItem().getClass().getName();
    }
    
    public long fetchExc(Entity ent) throws Exception {
        PurchaseOrderItem poitem = fetchExc(ent.getOID());
        ent = (Entity) poitem;
        return poitem.getOID();
    }
    
    public long insertExc(Entity ent) throws Exception {
        return insertExc((PurchaseOrderItem) ent);
    }
    
    public long updateExc(Entity ent) throws Exception {
        return updateExc((PurchaseOrderItem) ent);
    }
    
    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }
    
    public static PurchaseOrderItem fetchExc(long oid) throws DBException {
        try {
            PurchaseOrderItem poitem = new PurchaseOrderItem();
            PstPurchaseOrderItem pstPoItem = new PstPurchaseOrderItem(oid);
            poitem.setOID(oid);
            
            poitem.setPurchaseOrderId(pstPoItem.getlong(FLD_PURCHASE_ORDER_ID));
            poitem.setMaterialId(pstPoItem.getlong(FLD_MATERIAL_ID));
            poitem.setUnitId(pstPoItem.getlong(FLD_UNIT_ID));
            poitem.setPrice(pstPoItem.getdouble(FLD_PRICE));
            poitem.setCurrencyId(pstPoItem.getlong(FLD_CURRENCY_ID));
            poitem.setQuantity(pstPoItem.getdouble(FLD_QUANTITY));
            poitem.setDiscount(pstPoItem.getdouble(FLD_DISCOUNT));
            poitem.setTotal(pstPoItem.getdouble(FLD_TOTAL));
            poitem.setOrgBuyingPrice(pstPoItem.getdouble(FLD_ORG_BUYING_PRICE));
            poitem.setDiscount2(pstPoItem.getdouble(FLD_DISCOUNT2));
            poitem.setDiscNominal(pstPoItem.getdouble(FLD_DISCOUNT_NOMINAL));
            poitem.setCurBuyingPrice(pstPoItem.getdouble(FLD_CURR_BUYING_PRICE));
            poitem.setDiscount1(pstPoItem.getdouble(FLD_DISCOUNT1));
            poitem.setResiduQty(pstPoItem.getdouble(FLD_RESIDU_QTY));
            
            return poitem;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPurchaseOrderItem(0), DBException.UNKNOWN);
        }
    }
    
    public static long insertExc(PurchaseOrderItem poitem) throws DBException {
        try {
            PstPurchaseOrderItem pstPoItem = new PstPurchaseOrderItem(0);
            
            pstPoItem.setLong(FLD_PURCHASE_ORDER_ID, poitem.getPurchaseOrderId());
            pstPoItem.setLong(FLD_MATERIAL_ID, poitem.getMaterialId());
            pstPoItem.setLong(FLD_UNIT_ID, poitem.getUnitId());
            pstPoItem.setDouble(FLD_QUANTITY, poitem.getQuantity());
            pstPoItem.setDouble(FLD_PRICE, poitem.getPrice());
            pstPoItem.setLong(FLD_CURRENCY_ID, poitem.getCurrencyId());
            pstPoItem.setDouble(FLD_DISCOUNT, poitem.getDiscount());
            pstPoItem.setDouble(FLD_TOTAL, poitem.getTotal());
            pstPoItem.setDouble(FLD_ORG_BUYING_PRICE, poitem.getOrgBuyingPrice());
            pstPoItem.setDouble(FLD_DISCOUNT2, poitem.getDiscount2());
            pstPoItem.setDouble(FLD_DISCOUNT_NOMINAL, poitem.getDiscNominal());
            pstPoItem.setDouble(FLD_CURR_BUYING_PRICE, poitem.getCurBuyingPrice());
            pstPoItem.setDouble(FLD_DISCOUNT1, poitem.getDiscount1());
            pstPoItem.setDouble(FLD_RESIDU_QTY, poitem.getResiduQty());
            
            pstPoItem.insert();
            poitem.setOID(pstPoItem.getlong(FLD_PURCHASE_ORDER_ITEM_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPurchaseOrderItem(0), DBException.UNKNOWN);
        }
        return poitem.getOID();
    }
    
    public static long updateExc(PurchaseOrderItem poitem) throws DBException {
        try {
            if (poitem.getOID() != 0) {
                PstPurchaseOrderItem pstPoItem = new PstPurchaseOrderItem(poitem.getOID());
                
                pstPoItem.setLong(FLD_PURCHASE_ORDER_ID, poitem.getPurchaseOrderId());
                pstPoItem.setLong(FLD_MATERIAL_ID, poitem.getMaterialId());
                pstPoItem.setLong(FLD_UNIT_ID, poitem.getUnitId());
                pstPoItem.setDouble(FLD_PRICE, poitem.getPrice());
                pstPoItem.setLong(FLD_CURRENCY_ID, poitem.getCurrencyId());
                pstPoItem.setDouble(FLD_QUANTITY, poitem.getQuantity());
                pstPoItem.setDouble(FLD_DISCOUNT, poitem.getDiscount());
                pstPoItem.setDouble(FLD_TOTAL, poitem.getTotal());
                pstPoItem.setDouble(FLD_ORG_BUYING_PRICE, poitem.getOrgBuyingPrice());
                pstPoItem.setDouble(FLD_DISCOUNT2, poitem.getDiscount2());
                pstPoItem.setDouble(FLD_DISCOUNT_NOMINAL, poitem.getDiscNominal());
                pstPoItem.setDouble(FLD_CURR_BUYING_PRICE, poitem.getCurBuyingPrice());
                pstPoItem.setDouble(FLD_DISCOUNT1, poitem.getDiscount1());
                pstPoItem.setDouble(FLD_RESIDU_QTY, poitem.getResiduQty());
                
                pstPoItem.update();
                return poitem.getOID();
                
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPurchaseOrderItem(0), DBException.UNKNOWN);
        }
        return 0;
    }
    
    public static long deleteExc(long oid) throws DBException {
        try {
            PstPurchaseOrderItem pstPoItem = new PstPurchaseOrderItem(oid);
            pstPoItem.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPurchaseOrderItem(0), DBException.UNKNOWN);
        }
        return oid;
    }
    
    public static void deleteExc(String whereClause) throws DBException {
        DBResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + TBL_PURCHASE_ORDER_ITEM;
            if (whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            rs.close();
            
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            System.out.println("Err: delete item " + e.toString());
        }
    }
    
    public static void deleteByPurchaseOrder(long oidPurchaseOrder) {
        DBResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + PstPurchaseOrderItem.TBL_PURCHASE_ORDER_ITEM +
            " WHERE " + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ID] +
            " = " + oidPurchaseOrder;
            DBHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println("PstPurchaseOrderItem.deleteByPurchaseOrder() err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_PURCHASE_ORDER_ITEM;
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
                PurchaseOrderItem poitem = new PurchaseOrderItem();
                resultToObject(rs, poitem);
                lists.add(poitem);
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
    
    public static Vector list(int limitStart, int recordToGet, String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT POI." + fieldNames[FLD_PURCHASE_ORDER_ITEM_ID] +
            " ,MAT." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
            " ,MAT." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
            " ,UNT." + PstUnit.fieldNames[PstUnit.FLD_CODE] +
            " ,POI." + fieldNames[FLD_PRICE] +
            " ,POI." + fieldNames[FLD_QUANTITY] +
            " ,POI." + fieldNames[FLD_TOTAL] +
            " ,POI." + fieldNames[FLD_MATERIAL_ID] +
            " ,POI." + fieldNames[FLD_UNIT_ID] +
            " ,POI." + fieldNames[FLD_CURRENCY_ID] +
            " ,POI." + fieldNames[FLD_DISCOUNT] +
            " ,POI." + fieldNames[FLD_DISCOUNT1] +
            " ,POI." + fieldNames[FLD_DISCOUNT2] +
            " ,POI." + fieldNames[FLD_DISCOUNT_NOMINAL] +
            " ,POI." + fieldNames[FLD_ORG_BUYING_PRICE] +
            " ,POI." + fieldNames[FLD_CURR_BUYING_PRICE] +
            " ,VDR." + PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_ORG_BUYING_PRICE] +
            " ,VDR." + PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_LAST_DISCOUNT] +
            " ,VDR." + PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_CURR_BUYING_PRICE] +
            " ,VDR." + PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_LAST_VAT] +
            " ,VDR." + PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_BUYING_UNIT_ID] +
            " ,UNT." + PstUnit.fieldNames[PstUnit.FLD_QTY_PER_BASE_UNIT] +
            " ,POI." + fieldNames[FLD_RESIDU_QTY] +
            " FROM " + TBL_PURCHASE_ORDER_ITEM +
            " POI INNER JOIN " + PstMaterial.TBL_MATERIAL +
            " MAT ON POI." + fieldNames[FLD_MATERIAL_ID] +
            " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
            " LEFT JOIN " + PstMatVendorPrice.TBL_MATERIAL_VENDOR_PRICE + " VDR " +
            " ON MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
            " = VDR." + PstMatVendorPrice.fieldNames[PstMatVendorPrice.FLD_MATERIAL_ID] +
            " LEFT JOIN " + PstUnit.TBL_P2_UNIT +
            " UNT ON POI." + fieldNames[FLD_UNIT_ID] +
            " = UNT." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID];
            
            
            /*" INNER JOIN " + PstMatCurrency.TBL_CURRENCY +
            " CURR ON POI." + fieldNames[FLD_CURRENCY_ID] +
            " = CURR." + PstMatCurrency.fieldNames[PstMatCurrency.FLD_CURRENCY_ID]+*/
            
            if (whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            
            sql = sql + " GROUP BY MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID];
            
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
            
            //System.out.println("PstPurchaseOrderItem.list(startItem,recordToGetItem,whereClauseItem) >>>\n"+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector temp = new Vector();
                PurchaseOrderItem poitem = new PurchaseOrderItem();
                Material mat = new Material();
                Unit matUnit = new Unit();
                MatCurrency matCurr = new MatCurrency();
                MatVendorPrice matVendorPrice = new MatVendorPrice();
                
                poitem.setOID(rs.getLong(1));
                poitem.setPrice(rs.getDouble(5));
                poitem.setQuantity(rs.getDouble(6));
                poitem.setTotal(rs.getDouble(7));
                poitem.setMaterialId(rs.getLong(8));
                poitem.setUnitId(rs.getLong(9));
                poitem.setCurrencyId(rs.getLong(10));
                poitem.setDiscount(rs.getDouble(11));
                poitem.setDiscount1(rs.getDouble(12));
                poitem.setDiscount2(rs.getDouble(13));
                poitem.setDiscNominal(rs.getDouble(14));
                poitem.setOrgBuyingPrice(rs.getDouble(15));
                poitem.setCurBuyingPrice(rs.getDouble(16));
                poitem.setResiduQty(rs.getDouble(23));
                temp.add(poitem);
                
                mat.setSku(rs.getString(2));
                mat.setName(rs.getString(3));
                temp.add(mat);
                
                matUnit.setCode(rs.getString(4));
                matUnit.setQtyPerBaseUnit(rs.getDouble(22));
                temp.add(matUnit);
                
                //matCurr.setCode(rs.getString(6));
                temp.add(matCurr);
                
                matVendorPrice.setOrgBuyingPrice(rs.getDouble(17));
                matVendorPrice.setLastDiscount(rs.getDouble(18));
                matVendorPrice.setCurrBuyingPrice(rs.getDouble(19));
                matVendorPrice.setLastVat(rs.getDouble(20));
                matVendorPrice.setBuyingUnitId(rs.getLong(21));
                temp.add(matVendorPrice);
                
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
    
    public static void resultToObject(ResultSet rs, PurchaseOrderItem poitem) {
        try {
            poitem.setOID(rs.getLong(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ITEM_ID]));
            poitem.setPurchaseOrderId(rs.getLong(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ID]));
            poitem.setMaterialId(rs.getLong(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_MATERIAL_ID]));
            poitem.setUnitId(rs.getLong(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_UNIT_ID]));
            poitem.setPrice(rs.getDouble(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PRICE]));
            poitem.setCurrencyId(rs.getLong(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_CURRENCY_ID]));
            poitem.setQuantity(rs.getDouble(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_QUANTITY]));
            poitem.setDiscount(rs.getDouble(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_DISCOUNT]));
            poitem.setTotal(rs.getDouble(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_TOTAL]));
            poitem.setOrgBuyingPrice(rs.getDouble(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_ORG_BUYING_PRICE]));
            poitem.setDiscount2(rs.getDouble(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_DISCOUNT2]));
            poitem.setDiscNominal(rs.getDouble(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_DISCOUNT_NOMINAL]));
            poitem.setCurBuyingPrice(rs.getDouble(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_CURR_BUYING_PRICE]));
            poitem.setDiscount1(rs.getDouble(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_DISCOUNT1]));
            poitem.setResiduQty(rs.getDouble(PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_RESIDU_QTY]));
            
        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long poItemId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_PURCHASE_ORDER_ITEM +
            " WHERE " + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ITEM_ID] +
            " = " + poItemId;
            
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
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ITEM_ID] + ") FROM " + TBL_PURCHASE_ORDER_ITEM;
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
    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    PurchaseOrderItem poitem = (PurchaseOrderItem) list.get(ls);
                    if (oid == poitem.getOID())
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
                    //System.out.println("next.......................");
                } else {
                    start = start - recordToGet;
                    if (start > 0) {
                        cmd = Command.PREV;
                        //System.out.println("prev.......................");
                    }
                }
            }
        }
        return cmd;
    }
    
    /*
    fungsi ini di gunakan untuk mengecek item di satu PO/PR sudah ada atau tidak.
     */
    public static boolean cekExistItem(long oidItem, long oidMaterial, long oidPurchaseOrder) {
        DBResultSet dbrs = null;
        boolean bool = false;
        try {
            String sql = "SELECT " + fieldNames[FLD_MATERIAL_ID] +
            " FROM " + TBL_PURCHASE_ORDER_ITEM +
            " WHERE " + fieldNames[FLD_PURCHASE_ORDER_ID] + " = " + oidPurchaseOrder +
            " AND " + fieldNames[FLD_PURCHASE_ORDER_ITEM_ID] + " <> " + oidItem +
            " AND " + fieldNames[FLD_MATERIAL_ID] + " = " + oidMaterial;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                bool = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("Err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return bool;
    }
    
    /**
     * this method used to check if specify material already exist in current orderItem
     * return "true" ---> if material already exist in orderItem
     * return "false" ---> if material not available in orderItem
     */
    public static boolean materialExist(long oidMaterial, long oidPurchaseOrder) {
        DBResultSet dbrs = null;
        boolean bool = false;
        try {
            String sql = "SELECT ITM." + fieldNames[FLD_MATERIAL_ID] +
            " FROM " + TBL_PURCHASE_ORDER_ITEM + " AS ITM " +
            " INNER JOIN " + PstPurchaseOrder.TBL_PURCHASE_ORDER + " AS MAT " +
            " ON ITM." + fieldNames[FLD_PURCHASE_ORDER_ID] +
            " = MAT." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID] +
            " WHERE ITM." + fieldNames[FLD_PURCHASE_ORDER_ID] + "=" + oidPurchaseOrder +
            " AND ITM." + fieldNames[FLD_MATERIAL_ID] + "=" + oidMaterial;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                bool = true;
                break;
            }
        } catch (Exception e) {
            System.out.println("PstPurchaseOrderItem.materialExist.err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return bool;
    }
    
    public static PurchaseOrderItem getPurchaseOrderItem(PurchaseOrderItem PurchaseOrderItem, long oidMaterial, long oidPurchaseOrder) {
        try {
            String whereClause = "" + fieldNames[FLD_PURCHASE_ORDER_ID] +
            "= " + oidPurchaseOrder + " AND " + fieldNames[FLD_MATERIAL_ID] +
            "= " + oidMaterial;
            
            Vector vt = list(0, 0, whereClause, "");
            if (vt != null && vt.size() > 0) {
                PurchaseOrderItem = (PurchaseOrderItem) vt.get(0);
            }
        } catch (Exception e) {
            System.out.println("Err : " + e.toString());
        }
        return PurchaseOrderItem;
    }
    
    
    /**
     * untuk melihat qty sisa hasil terima
     * di pakai untuk minimum stock
     * @param oidMaterial
     * @param locationOid
     * @return
     */
    public static double getQtyResidue(long oidMaterial, long locationOid) {
        DBResultSet dbrs = null;
        double qty_sisa = 0;
        try {
            String sql = "SELECT sum(poi.qty) - sum(poi.residu_qty) as qty_sisa " +
            " FROM " + PstPurchaseOrderItem.TBL_PURCHASE_ORDER_ITEM + " as poi " +
            " inner join " + PstPurchaseOrder.TBL_PURCHASE_ORDER + " as po " +
            " on poi.purchase_order_id = po.purchase_order_id " +
            " where poi.material_id = " + oidMaterial + " and po.location_id = " + locationOid;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                qty_sisa = rs.getDouble("qty_sisa");
            }
            
        } catch (Exception e) {
            System.out.println("Err : " + e.toString());
        }
        return qty_sisa;
    }
    
    /**
     * gadnyana
     * @param oidMaterial
     * @param locationOid
     */
    public static Vector getPOPendingOrder(Vector list , long oidMaterial, long locationOid) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT sum(poi.qty) - sum(poi.residu_qty) as qty, "+
            " po." +PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE]+
            ", po." +PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID]+
            ", po." +PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_SUPPLIER_ID]+
            " FROM " + PstPurchaseOrderItem.TBL_PURCHASE_ORDER_ITEM + " as poi " +
            " inner join " + PstPurchaseOrder.TBL_PURCHASE_ORDER + " as po " +
            " on poi.purchase_order_id = po.purchase_order_id " +
            " where poi.material_id = " + oidMaterial + " and po.location_id = " + locationOid+
            " and qty > 0 "+
            " group by po."+PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE];
            
            ///System.out.println("sql : "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                PurchaseOrder puch = new PurchaseOrder();
                puch.setTermOfPayment(rs.getInt(1));
                puch.setPoCode(rs.getString(2));
                puch.setOID(rs.getLong(3));
                puch.setSupplierId(rs.getLong(4));
                list.add(puch);
            }
            
        } catch (Exception e) {
            System.out.println("Err : " + e.toString());
        }
        return list;
    }
    
    public static double getTotal(String whereClause) {
        DBResultSet dbrs = null;
        double amount = 0.00;
        try {
            String sql = "SELECT SUM(" + PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_TOTAL] +
            ") AS MNT FROM " + TBL_PURCHASE_ORDER_ITEM;
            if (whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                amount = rs.getDouble("MNT");
            }
            
            rs.close();
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
        return amount;
    }
    
    public static long deleteExcByParent(long oid) throws DBException {
        long hasil = 0;
        try {
            String sql = "DELETE FROM " + TBL_PURCHASE_ORDER_ITEM +
            " WHERE " + fieldNames[FLD_PURCHASE_ORDER_ID] +
            " = " + oid;
            int result = execUpdate(sql);
            hasil = oid;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPurchaseOrderItem(0), DBException.UNKNOWN);
        }
        return hasil;
    }
    
}
