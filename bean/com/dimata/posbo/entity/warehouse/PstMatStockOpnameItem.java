package com.dimata.posbo.entity.warehouse;

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
import com.dimata.posbo.entity.warehouse.*;
import com.dimata.posbo.entity.masterdata.*;
import com.dimata.common.entity.periode.PstPeriode;

public class PstMatStockOpnameItem extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_STOCK_OPNAME_ITEM = "pos_stock_opname_item";

    public static final int FLD_STOCK_OPNAME_ITEM_ID = 0;
    public static final int FLD_STOCK_OPNAME_ID = 1;
    public static final int FLD_MATERIAL_ID = 2;
    public static final int FLD_UNIT_ID = 3;
    public static final int FLD_QTY_OPNAME = 4;
    public static final int FLD_QTY_SOLD = 5;
    public static final int FLD_QTY_SYSTEM = 6;
    public static final int FLD_COST = 7;
    public static final int FLD_PRICE = 8;

    //+colum counter
    public static final int FLD_STOCK_OPNAME_COUNTER = 9;

    public static final String[] fieldNames = {
        "STOCK_OPNAME_ITEM_ID",
        "STOCK_OPNAME_ID",
        "MATERIAL_ID",
        "UNIT_ID",
        "QTY_OPNAME",
        "QTY_SOLD",
        "QTY_SYSTEM",
        "COST",
        "PRICE",
        //+column
        "STOCK_OPNAME_COUNTER"
    };

    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        //+ counter
        TYPE_INT
    };

    public PstMatStockOpnameItem() {
    }

    public PstMatStockOpnameItem(int i) throws DBException {
        super(new PstMatStockOpnameItem());
    }

    public PstMatStockOpnameItem(String sOid) throws DBException {
        super(new PstMatStockOpnameItem(0));
        if (!locate(sOid))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }

    public PstMatStockOpnameItem(long lOid) throws DBException {
        super(new PstMatStockOpnameItem(0));
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
        return TBL_STOCK_OPNAME_ITEM;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstMatStockOpnameItem().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        MatStockOpnameItem matstockopnameitem = fetchExc(ent.getOID());
        ent = (Entity) matstockopnameitem;
        return matstockopnameitem.getOID();
    }

    synchronized public long insertExc(Entity ent) throws Exception {
        return insertExc((MatStockOpnameItem) ent);
    }

    synchronized public long updateExc(Entity ent) throws Exception {
        return updateExc((MatStockOpnameItem) ent);
    }

    synchronized public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static MatStockOpnameItem fetchExc(long oid) throws DBException {
        try {
            MatStockOpnameItem matstockopnameitem = new MatStockOpnameItem();
            PstMatStockOpnameItem pstMatStockOpnameItem = new PstMatStockOpnameItem(oid);
            matstockopnameitem.setOID(oid);

            matstockopnameitem.setStockOpnameId(pstMatStockOpnameItem.getlong(FLD_STOCK_OPNAME_ID));
            matstockopnameitem.setMaterialId(pstMatStockOpnameItem.getlong(FLD_MATERIAL_ID));
            matstockopnameitem.setUnitId(pstMatStockOpnameItem.getlong(FLD_UNIT_ID));
            matstockopnameitem.setQtyOpname(pstMatStockOpnameItem.getdouble(FLD_QTY_OPNAME));
            matstockopnameitem.setQtySold(pstMatStockOpnameItem.getdouble(FLD_QTY_SOLD));
            matstockopnameitem.setQtySystem(pstMatStockOpnameItem.getdouble(FLD_QTY_SYSTEM));
            matstockopnameitem.setCost(pstMatStockOpnameItem.getdouble(FLD_COST));
            matstockopnameitem.setPrice(pstMatStockOpnameItem.getdouble(FLD_PRICE));
            //counter
            matstockopnameitem.setStockOpnameCounter(pstMatStockOpnameItem.getInt(FLD_STOCK_OPNAME_COUNTER));

            return matstockopnameitem;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatStockOpnameItem(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(MatStockOpnameItem matstockopnameitem) throws DBException {
        try {
            //Fetch stock opname info !!!
            MatStockOpname so = PstMatStockOpname.fetchExc(matstockopnameitem.getStockOpnameId());

            PstMatStockOpnameItem pstMatStockOpnameItem = new PstMatStockOpnameItem(0);

            pstMatStockOpnameItem.setLong(FLD_STOCK_OPNAME_ID, matstockopnameitem.getStockOpnameId());
            pstMatStockOpnameItem.setLong(FLD_MATERIAL_ID, matstockopnameitem.getMaterialId());
            pstMatStockOpnameItem.setLong(FLD_UNIT_ID, matstockopnameitem.getUnitId());
            pstMatStockOpnameItem.setDouble(FLD_QTY_OPNAME, matstockopnameitem.getQtyOpname());
            pstMatStockOpnameItem.setDouble(FLD_QTY_SOLD, matstockopnameitem.getQtySold());
            //pstMatStockOpnameItem.setDouble(FLD_QTY_SOLD, fetchSoldQty(matstockopnameitem.getMaterialId(), so));
            pstMatStockOpnameItem.setDouble(FLD_QTY_SYSTEM, fetchSystemQty(matstockopnameitem.getMaterialId(), so.getLocationId(), matstockopnameitem.getQtyOpname()));
            pstMatStockOpnameItem.setDouble(FLD_COST, matstockopnameitem.getCost());
            pstMatStockOpnameItem.setDouble(FLD_PRICE, matstockopnameitem.getPrice());
            //counter
            pstMatStockOpnameItem.setInt(FLD_STOCK_OPNAME_COUNTER, matstockopnameitem.getStockOpnameCounter());

            pstMatStockOpnameItem.insert();
            matstockopnameitem.setOID(pstMatStockOpnameItem.getlong(FLD_STOCK_OPNAME_ITEM_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatStockOpnameItem(0), DBException.UNKNOWN);
        }
        return matstockopnameitem.getOID();
    }

    public static long updateExc(MatStockOpnameItem matstockopnameitem) throws DBException {
        try {
            if (matstockopnameitem.getOID() != 0) {
                PstMatStockOpnameItem pstMatStockOpnameItem = new PstMatStockOpnameItem(matstockopnameitem.getOID());

                pstMatStockOpnameItem.setLong(FLD_STOCK_OPNAME_ID, matstockopnameitem.getStockOpnameId());
                pstMatStockOpnameItem.setLong(FLD_MATERIAL_ID, matstockopnameitem.getMaterialId());
                pstMatStockOpnameItem.setLong(FLD_UNIT_ID, matstockopnameitem.getUnitId());
                pstMatStockOpnameItem.setDouble(FLD_QTY_OPNAME, matstockopnameitem.getQtyOpname());
                pstMatStockOpnameItem.setDouble(FLD_QTY_SOLD, matstockopnameitem.getQtySold());
                pstMatStockOpnameItem.setDouble(FLD_QTY_SYSTEM, matstockopnameitem.getQtySystem());
                pstMatStockOpnameItem.setDouble(FLD_COST, matstockopnameitem.getCost());
                pstMatStockOpnameItem.setDouble(FLD_PRICE, matstockopnameitem.getPrice());

                pstMatStockOpnameItem.update();
                return matstockopnameitem.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatStockOpnameItem(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstMatStockOpnameItem pstMatStockOpnameItem = new PstMatStockOpnameItem(oid);
            pstMatStockOpnameItem.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatStockOpnameItem(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_STOCK_OPNAME_ITEM;
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
                MatStockOpnameItem matstockopnameitem = new MatStockOpnameItem();
                resultToObject(rs, matstockopnameitem);
                lists.add(matstockopnameitem);
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

    //Overloaded version of this function
    /**
     * @param limitStart
     * @param recordToGet
     * @param oidStockOpname
     * @return
     * @ update Edhy
     */
    public static Vector list(int limitStart, int recordToGet, long oidStockOpname) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ITEM_ID] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_SKU] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_NAME] +
                    ", UNT." + PstUnit.fieldNames[PstUnit.FLD_CODE] +
                    ", CAT." + PstCategory.fieldNames[PstCategory.FLD_NAME] + // ", SCAT." + PstSubCategory.fieldNames[PstSubCategory.FLD_NAME] +
                    ", SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_QTY_OPNAME] +
                    ", SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_QTY_SOLD] +
                    ", SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_QTY_SYSTEM] +
                    ", SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_COST] +
                    ", SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_MATERIAL_ID] +
                    ", SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_UNIT_ID] +
                    ", SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_PRICE] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_DEFAULT_PRICE] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_REQUIRED_SERIAL_NUMBER] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_AVERAGE_PRICE] +
                    //for counter material
                    ", SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_COUNTER] +
                    " FROM (((" + PstMatStockOpnameItem.TBL_STOCK_OPNAME_ITEM + " SOI" +
                    " INNER JOIN " + PstMaterial.TBL_MATERIAL + " MAT" +
                    " ON SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_MATERIAL_ID] +
                    " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID] +
                    " ) INNER JOIN " + PstUnit.TBL_P2_UNIT + " UNT" +
                    " ON SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_UNIT_ID] +
                    " = UNT." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
                    " ) LEFT JOIN " + PstCategory.TBL_CATEGORY + " CAT" +
                    " ON MAT." + PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] +
                    " = CAT." + PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID] +
                    " )" + /* LEFT JOIN " + PstSubCategory.TBL_SUB_CATEGORY + " SCAT" +
            " ON MAT." + PstMaterial.fieldNames[PstMaterial.FLD_SUB_CATEGORY_ID] +
            " = SCAT." + PstSubCategory.fieldNames[PstSubCategory.FLD_SUB_CATEGORY_ID] +*/
                    " WHERE SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ID] +
                    " = " + oidStockOpname +
                    " ORDER BY SOI." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_COUNTER] +
                    ", CAT." + PstCategory.fieldNames[PstCategory.FLD_CODE] +
                    ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_SKU];
                    //" ORDER BY CAT." + PstCategory.fieldNames[PstCategory.FLD_CODE] +
                   // ", MAT." + PstMaterial.fieldNames[PstMaterial.FLD_SKU];

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
                MatStockOpnameItem soi = new MatStockOpnameItem();
                Material mat = new Material();
                Unit unt = new Unit();
                Category cat = new Category();
                SubCategory scat = new SubCategory();

                soi.setOID(rs.getLong(1));
                soi.setQtyOpname(rs.getDouble(6));
                soi.setQtySold(rs.getDouble(7));
                soi.setQtySystem(rs.getDouble(8));
                soi.setCost(rs.getDouble(9));
                soi.setMaterialId(rs.getLong(10));
                soi.setUnitId(rs.getLong(11));
                soi.setPrice(rs.getDouble(12));
                soi.setStockOpnameCounter(rs.getInt(16));
                temp.add(soi);

                mat.setSku(rs.getString(2));
                mat.setName(rs.getString(3));
                mat.setDefaultPrice(rs.getDouble(13));
                mat.setRequiredSerialNumber(rs.getInt(14));
                mat.setAveragePrice(rs.getDouble(15));
                temp.add(mat);

                unt.setCode(rs.getString(4));
                temp.add(unt);

                cat.setName(rs.getString(5));
                temp.add(cat);

                //scat.setName(rs.getString(6));
                temp.add(scat);

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

    public static void deleteExc(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + TBL_STOCK_OPNAME_ITEM;
            if (whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static void resultToObject(ResultSet rs, MatStockOpnameItem matstockopnameitem) {
        try {
            matstockopnameitem.setOID(rs.getLong(PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ITEM_ID]));
            matstockopnameitem.setStockOpnameId(rs.getLong(PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ID]));
            matstockopnameitem.setMaterialId(rs.getLong(PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_MATERIAL_ID]));
            matstockopnameitem.setUnitId(rs.getLong(PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_UNIT_ID]));
            matstockopnameitem.setQtyOpname(rs.getDouble(PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_QTY_OPNAME]));
            matstockopnameitem.setQtySold(rs.getDouble(PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_QTY_SOLD]));
            matstockopnameitem.setQtySystem(rs.getDouble(PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_QTY_SYSTEM]));
            matstockopnameitem.setCost(rs.getDouble(PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_COST]));
            matstockopnameitem.setPrice(rs.getDouble(PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_PRICE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long matStockOpnameItemId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_STOCK_OPNAME_ITEM + " WHERE " +
                    PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ITEM_ID] + " = " + matStockOpnameItemId;

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
            String sql = "SELECT COUNT(" + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ITEM_ID] + ") FROM " + TBL_STOCK_OPNAME_ITEM;
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
                    MatStockOpnameItem matstockopnameitem = (MatStockOpnameItem) list.get(ls);
                    if (oid == matstockopnameitem.getOID())
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


    public static long insertDefaultOpnameItem(MatStockOpname opname) {
        long oid = 0;
        /*if(opname.getOID()!=0){
            String where = PstMatStock.fieldNames[PstMatStock.FLD_LOCATION_ID]+"="+opname.getLocationId();
            Vector vct = PstMatStock.list(0,0,where, null);
            if(vct!=null && vct.size()>0){
                for(int i=0; i<vct.size(); i++){
                    MatStock st = (MatStock)vct.get(i);

                    MatStockOpnameItem detail = new MatStockOpnameItem();
                    detail.setMaterialId(st.getMaterialId());
                    detail.setStockOpnameId(opname.getOID());
                    detail.setQtyOpname(st.getCurrentQuantity());

                    try{
                            oid = PstMatStockOpnameItem.insertExc(detail);
                    }
                    catch(Exception e){
                        System.out.println("Exception e insertDefaultOpnameItem : "+e.toString());
                    }
                }
            }
        }*/

        return oid;
    }

    //Ambil qty barang yang terjual sampai saat itu !!!
    private static int fetchSoldQty(long oidMaterial, MatStockOpname so) {
        int hasil = 0;
        DBResultSet dbrs = null;
        try {
            //Fetch Stock Opname Entity
            //int OpnHour = Integer.parseInt((so.getStockOpnameTime()).substring(0, 2));
            //int OpnMnt = Integer.parseInt((so.getStockOpnameTime()).substring(3, 5));
            String sql = "SELECT cash_bill_main.BILL_NUMBER" +
                    ", cash_bill_detail.QTY" +
                    " FROM cash_bill_detail" +
                    " INNER JOIN cash_bill_main" +
                    " ON cash_bill_detail.CASH_BILL_MAIN_ID" +
                    " = cash_bill_main.CASH_BILL_MAIN_ID" +
                    " WHERE cash_bill_main.BILL_DATE" +
                    " < '" + Formater.formatTimeLocale(so.getStockOpnameDate(), "yyyy-MM-dd kk:mm:00") + "' AND cash_bill_detail.MATERIAL_ID" +
                    " = " + oidMaterial +
                    " AND cash_bill_main.LOCATION_ID" +
                    " = " + so.getLocationId() +
                    " ORDER BY cash_bill_main.BILL_NUMBER";
            //System.out.println("ASU : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                hasil += rs.getDouble(2);
                //If before time, then sum qty sold
                /*String ambil = rs.getString(1);
                int SldHour = Integer.parseInt((ambil).substring(8, 10));
                int SldMnt = Integer.parseInt((ambil).substring(10, 12));
                //System.out.println("Masuk : " + SldHour + " : " + OpnHour);
                if (SldHour < OpnHour) {
                    hasil += rs.getInt(2);
                } else {
                    if (SldHour == OpnHour) {
                        if (SldMnt < OpnMnt) hasil += rs.getInt(2);
                    }
                }*/
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return hasil;
    }

    //Ambil qty barang yang terjual sampai saat itu !!!
    private static double fetchSystemQty(long oidMaterial, long oidLocation) {
        double hasil = 0.00;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT MS.QTY" +
                    " FROM periode PRD" +
                    " INNER JOIN material_stock MS" +
                    " ON PRD.PERIODE_ID" +
                    " = MS.PERIODE_ID" +
                    " WHERE PRD.STATUS" +
                    " = " + PstPeriode.FLD_STATUS_RUNNING +
                    " AND MS.MATERIAL_UNIT_ID" +
                    " = " + oidMaterial +
                    " AND MS.LOCATION_ID" +
                    " = " + oidLocation;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                hasil = rs.getDouble(1);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return hasil;
    }


    /**
     * Get stock quantity (system) from Material Stock
     * @param oidMaterial
     * @param oidLocation
     * @param qtyOpname
     * @return
     */
    private static double fetchSystemQty(long oidMaterial, long oidLocation, double qtyOpname) {
        double hasil = 0;
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_QTY] +
                    " FROM " + PstPeriode.TBL_STOCK_PERIODE + " PRD" +
                    " INNER JOIN " + PstMaterialStock.TBL_MATERIAL_STOCK + " MS" +
                    " ON PRD." + PstPeriode.fieldNames[PstPeriode.FLD_STOCK_PERIODE_ID] +
                    " = MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_PERIODE_ID] +
                    " WHERE PRD." + PstPeriode.fieldNames[PstPeriode.FLD_STATUS] +
                    " = " + PstPeriode.FLD_STATUS_RUNNING +
                    " AND MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_MATERIAL_UNIT_ID] +
                    " = " + oidMaterial +
                    " AND MS." + PstMaterialStock.fieldNames[PstMaterialStock.FLD_LOCATION_ID] +
                    " = " + oidLocation;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            boolean matExistOnStock = false;

            while (rs.next()) {
                hasil = rs.getDouble(1);
                matExistOnStock = true;
            }

            if (!matExistOnStock) {
                hasil = qtyOpname;
            }

            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return hasil;
    }


    public static long deleteExcByParent(long oid) throws DBException {
        long hasil = 0;
        try {
            String sql = "DELETE FROM " + TBL_STOCK_OPNAME_ITEM +
                    " WHERE " + fieldNames[FLD_STOCK_OPNAME_ID] +
                    " = " + oid;
            int result = execUpdate(sql);
            hasil = oid;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatStockOpnameItem(0), DBException.UNKNOWN);
        }
        return hasil;
    }

    /**
     * Get lost value
     * @param oidStockOpname
     * @return
     */
    public static double getLostQty(long oidStockOpname) {
        double hasil = 0.00;
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT SUM((" +
                    PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_QTY_SYSTEM] +
                    "-(" + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_QTY_SOLD] +
                    "+" + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_QTY_OPNAME] +
                    "))* " + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_COST] +
                    ") AS LOST" +
                    " FROM " + PstMatStockOpnameItem.TBL_STOCK_OPNAME_ITEM +
                    " WHERE " + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ID] +
                    " = " + oidStockOpname;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                hasil = rs.getDouble(1);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return hasil;
    }


    /**
     * this method used to check if specify material already exist in current opnameItem
     * return "true" ---> if material already exist in opnameItem
     * return "false" ---> if material not available in opnameItem
     */
    public static boolean materialExist(long oidMaterial, long oidStockOpname) {
        DBResultSet dbrs = null;
        boolean bool = false;
        try {
            String sql = "SELECT ITM." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_MATERIAL_ID] +
                    " FROM " + PstMatStockOpnameItem.TBL_STOCK_OPNAME_ITEM + " AS ITM " +
                    " INNER JOIN " + PstMatStockOpname.TBL_MAT_STOCK_OPNAME + " AS MAT " +
                    " ON ITM." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ID] +
                    " = MAT." + PstMatStockOpname.fieldNames[PstMatStockOpname.FLD_STOCK_OPNAME_ID] +
                    " WHERE ITM." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ID] + "=" + oidStockOpname +
                    " AND ITM." + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_MATERIAL_ID] + "=" + oidMaterial;
            //System.out.println("PstMatStockOpnameItem.materialExist.sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                bool = true;
                break;
            }
        } catch (Exception e) {
            System.out.println("PstMatStockOpnameItem.materialExist.err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return bool;
        }
    }

    public static void main(String[] ars){
        try{
            Date dt = new Date();
            Date dtjt = new Date();
            System.out.println("dt.compareTo(dtjt) : "+dt.compareTo(dtjt));
        }catch(Exception e){}
    }

    /**gadnyana
     * ini di gunakan untuk menyimpan data, update,delete data secara otomatis.
     * @param item
     */
    public static void insertUpdateDeleteAutomatic(Vector item, long oid) {
        if (item != null && item.size() > 0) {
            Vector vtInsert = (Vector) item.get(0);
            Vector vtUpdate = (Vector) item.get(1);
            Vector vtDelete = (Vector) item.get(2);
            String where = "";

            // cek and insert item
            if (vtInsert != null && vtInsert.size() > 0) {
                for (int k = 0; k < vtInsert.size(); k++) {
                    Vector vt = (Vector) vtInsert.get(k);
                    Material mat = (Material) vt.get(0);
                    where = PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ID] + "=" + oid +
                            " AND " + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_MATERIAL_ID] + "=" + mat.getOID();
                    Vector vtitem = PstMatStockOpnameItem.list(0, 0, where, "");
                    MatStockOpnameItem matStockOpnameItem = new MatStockOpnameItem();
                    if (vtitem != null && vtitem.size() > 0) {
                        matStockOpnameItem = (MatStockOpnameItem) vtitem.get(0);
                        matStockOpnameItem.setQtyOpname(Double.parseDouble((String) vt.get(1)));
                        try {
                            PstMatStockOpnameItem.updateExc(matStockOpnameItem);
                        } catch (Exception e) {
                        }
                    } else {
                        matStockOpnameItem.setQtyOpname(Double.parseDouble((String) vt.get(1)));
                        matStockOpnameItem.setMaterialId(mat.getOID());
                        matStockOpnameItem.setPrice(mat.getDefaultPrice());
                        matStockOpnameItem.setUnitId(mat.getDefaultStockUnitId());
                        matStockOpnameItem.setStockOpnameId(oid);
                        try {
                            PstMatStockOpnameItem.insertExc(matStockOpnameItem);
                        } catch (Exception e) {
                        }
                    }
                }
            }

            // cek and update item
            if (vtUpdate != null && vtUpdate.size() > 0) {
                for (int k = 0; k < vtUpdate.size(); k++) {
                    Vector vt = (Vector) vtUpdate.get(k);
                    Material mat = (Material) vt.get(0);
                    where = PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ID] + "=" + oid +
                            " AND " + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_MATERIAL_ID] + "=" + mat.getOID();
                    Vector vtitem = PstMatStockOpnameItem.list(0, 0, where, "");
                    MatStockOpnameItem matStockOpnameItem = new MatStockOpnameItem();
                    if (vtitem != null && vtitem.size() > 0) {
                        matStockOpnameItem = (MatStockOpnameItem) vtitem.get(0);
                        matStockOpnameItem.setQtyOpname(Double.parseDouble((String) vt.get(1)));
                        try {
                            PstMatStockOpnameItem.updateExc(matStockOpnameItem);
                        } catch (Exception e) {
                        }
                    }
                }
            }

            // cek and delete item
            if (vtDelete != null && vtDelete.size() > 0) {
                for (int k = 0; k < vtDelete.size(); k++) {
                    Vector vt = (Vector) vtDelete.get(k);
                    Material mat = (Material) vt.get(0);
                    where = PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_STOCK_OPNAME_ID] + "=" + oid +
                            " AND " + PstMatStockOpnameItem.fieldNames[PstMatStockOpnameItem.FLD_MATERIAL_ID] + "=" + mat.getOID();
                    Vector vtitem = PstMatStockOpnameItem.list(0, 0, where, "");
                    MatStockOpnameItem matStockOpnameItem = new MatStockOpnameItem();
                    if (vtitem != null && vtitem.size() > 0) {
                        matStockOpnameItem = (MatStockOpnameItem) vtitem.get(0);
                        try {
                            PstMatStockOpnameItem.deleteExc(matStockOpnameItem.getOID());
                        } catch (Exception e) {
                        }
                    }
                }
            }
        }
    }

}
