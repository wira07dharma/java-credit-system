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
import com.dimata.qdep.form.FRMHandler;

/* package garment */
import com.dimata.posbo.entity.warehouse.*;
import com.dimata.posbo.entity.masterdata.*;
import com.dimata.posbo.session.warehouse.*;
import com.dimata.common.entity.location.PstLocation;

public class PstMatDispatch extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language, I_Document {

    public static final String TBL_DISPATCH = "pos_dispatch_material";

    public static final int FLD_DISPATCH_MATERIAL_ID = 0;
    public static final int FLD_LOCATION_ID = 1;
    public static final int FLD_DISPATCH_TO = 2;
    public static final int FLD_LOCATION_TYPE = 3;
    public static final int FLD_DISPATCH_DATE = 4;
    public static final int FLD_DISPATCH_CODE = 5;
    public static final int FLD_DISPATCH_CODE_COUNTER = 6;
    public static final int FLD_DISPATCH_STATUS = 7;
    public static final int FLD_REMARK = 8;
    public static final int FLD_INVOICE_SUPPLIER = 9;
    public static final int FLD_TRANSFER_STATUS = 10;
    public static final int FLD_LAST_UPDATE = 11;

    public static final String[] fieldNames = {
            "DISPATCH_MATERIAL_ID",
            "LOCATION_ID",
            "DISPATCH_TO",
            "LOCATION_TYPE",
            "DISPATCH_DATE",
            "DISPATCH_CODE",
            "DISPATCH_CODE_COUNTER",
            "DISPATCH_STATUS",
            "REMARK",
            "INVOICE_SUPPLIER",
            "TRANSFER_STATUS",
            "LAST_UPDATE"
    };

    public static final int[] fieldTypes = {
            TYPE_LONG + TYPE_PK + TYPE_ID,
            TYPE_LONG,
            TYPE_LONG,
            TYPE_INT,
            TYPE_DATE,
            TYPE_STRING,
            TYPE_INT,
            TYPE_INT,
            TYPE_STRING,
            TYPE_STRING,
            TYPE_INT,
            TYPE_DATE
    };

    public static final int FLD_TYPE_DISPATCH_LOCATION_STORE = 0;
    public static final int FLD_TYPE_DISPATCH_LOCATION_WAREHOUSE = 1;
    public static final int FLD_TYPE_TRANSFER_UNIT = 2;//Pemecahan/penggabungan barang dengan unit yang berbeda.

    public static final String[] fieldTypeDispatch = {
            "Store",
            "Warehouse",
            "Transfer Unit"

    };

    public PstMatDispatch() {
    }

    public PstMatDispatch(int i) throws DBException {
        super(new PstMatDispatch());
    }

    public PstMatDispatch(String sOid) throws DBException {
        super(new PstMatDispatch(0));
        if (!locate(sOid))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }

    public PstMatDispatch(long lOid) throws DBException {
        super(new PstMatDispatch(0));
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
        return TBL_DISPATCH;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstMatDispatch().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        MatDispatch matdispatch = fetchExc(ent.getOID());
        ent = (Entity) matdispatch;
        return matdispatch.getOID();
    }

    synchronized public long insertExc(Entity ent) throws Exception {
        return insertExc((MatDispatch) ent);
    }

    synchronized public long updateExc(Entity ent) throws Exception {
        return updateExc((MatDispatch) ent);
    }

    synchronized public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static MatDispatch fetchExc(long oid) throws DBException {
        try {
            MatDispatch matdispatch = new MatDispatch();
            PstMatDispatch pstMatDispatch = new PstMatDispatch(oid);
            matdispatch.setOID(oid);

            matdispatch.setLocationId(pstMatDispatch.getlong(FLD_LOCATION_ID));
            matdispatch.setDispatchTo(pstMatDispatch.getlong(FLD_DISPATCH_TO));
            matdispatch.setLocationType(pstMatDispatch.getInt(FLD_LOCATION_TYPE));
            matdispatch.setDispatchDate(pstMatDispatch.getDate(FLD_DISPATCH_DATE));
            matdispatch.setDispatchCode(pstMatDispatch.getString(FLD_DISPATCH_CODE));
            matdispatch.setDispatchCodeCounter(pstMatDispatch.getInt(FLD_DISPATCH_CODE_COUNTER));
            matdispatch.setDispatchStatus(pstMatDispatch.getInt(FLD_DISPATCH_STATUS));
            matdispatch.setRemark(pstMatDispatch.getString(FLD_REMARK));
            matdispatch.setInvoiceSupplier(pstMatDispatch.getString(FLD_INVOICE_SUPPLIER));
            matdispatch.setTransferStatus(pstMatDispatch.getInt(FLD_TRANSFER_STATUS));
            matdispatch.setLast_update(pstMatDispatch.getDate(FLD_LAST_UPDATE));

            return matdispatch;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatDispatch(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(MatDispatch matdispatch) throws DBException {
        try {
            PstMatDispatch pstMatDispatch = new PstMatDispatch(0);

            pstMatDispatch.setLong(FLD_LOCATION_ID, matdispatch.getLocationId());
            pstMatDispatch.setLong(FLD_DISPATCH_TO, matdispatch.getDispatchTo());
            pstMatDispatch.setInt(FLD_LOCATION_TYPE, matdispatch.getLocationType());
            pstMatDispatch.setDate(FLD_DISPATCH_DATE, matdispatch.getDispatchDate());
            pstMatDispatch.setString(FLD_DISPATCH_CODE, matdispatch.getDispatchCode());
            pstMatDispatch.setInt(FLD_DISPATCH_CODE_COUNTER, matdispatch.getDispatchCodeCounter());
            pstMatDispatch.setInt(FLD_DISPATCH_STATUS, matdispatch.getDispatchStatus());
            pstMatDispatch.setString(FLD_REMARK, matdispatch.getRemark());
            pstMatDispatch.setString(FLD_INVOICE_SUPPLIER, matdispatch.getInvoiceSupplier());
            pstMatDispatch.setInt(FLD_TRANSFER_STATUS, matdispatch.getTransferStatus());
            pstMatDispatch.setDate(FLD_LAST_UPDATE, matdispatch.getLast_update());

            pstMatDispatch.insert();
            matdispatch.setOID(pstMatDispatch.getlong(FLD_DISPATCH_MATERIAL_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatDispatch(0), DBException.UNKNOWN);
        }
        return matdispatch.getOID();
    }

    public static long updateExc(MatDispatch matdispatch) throws DBException {
        try {
            if (matdispatch.getOID() != 0) {
                PstMatDispatch pstMatDispatch = new PstMatDispatch(matdispatch.getOID());

                pstMatDispatch.setLong(FLD_LOCATION_ID, matdispatch.getLocationId());
                pstMatDispatch.setLong(FLD_DISPATCH_TO, matdispatch.getDispatchTo());
                pstMatDispatch.setInt(FLD_LOCATION_TYPE, matdispatch.getLocationType());
                pstMatDispatch.setDate(FLD_DISPATCH_DATE, matdispatch.getDispatchDate());
                pstMatDispatch.setString(FLD_DISPATCH_CODE, matdispatch.getDispatchCode());
                pstMatDispatch.setInt(FLD_DISPATCH_CODE_COUNTER, matdispatch.getDispatchCodeCounter());
                pstMatDispatch.setInt(FLD_DISPATCH_STATUS, matdispatch.getDispatchStatus());
                pstMatDispatch.setString(FLD_REMARK, matdispatch.getRemark());
                pstMatDispatch.setString(FLD_INVOICE_SUPPLIER, matdispatch.getInvoiceSupplier());
                pstMatDispatch.setInt(FLD_TRANSFER_STATUS, matdispatch.getTransferStatus());
                pstMatDispatch.setDate(FLD_LAST_UPDATE, matdispatch.getLast_update());

                pstMatDispatch.update();
                return matdispatch.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatDispatch(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstMatDispatch pstMatDispatch = new PstMatDispatch(oid);
            //Delete Item First
            PstMatDispatchItem pstDFItem = new PstMatDispatchItem();
            long result = pstDFItem.deleteExcByParent(oid);
            pstMatDispatch.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatDispatch(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_DISPATCH;
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

            //System.out.println("PstMatDispatch.list() sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                MatDispatch matdispatch = new MatDispatch();
                resultToObject(rs, matdispatch);
                lists.add(matdispatch);
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

    public static void resultToObject(ResultSet rs, MatDispatch matdispatch) {
        try {
            matdispatch.setOID(rs.getLong(PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_MATERIAL_ID]));
            matdispatch.setLocationId(rs.getLong(PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_ID]));
            matdispatch.setDispatchTo(rs.getLong(PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_TO]));
            matdispatch.setLocationType(rs.getInt(PstMatDispatch.fieldNames[PstMatDispatch.FLD_LOCATION_TYPE]));
            Date date = DBHandler.convertDate(rs.getDate(PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_DATE]), rs.getTime(PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_DATE]));
            matdispatch.setDispatchDate(date); //rs.getDate(PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_DATE]));
            matdispatch.setDispatchCode(rs.getString(PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_CODE]));
            matdispatch.setDispatchCodeCounter(rs.getInt(PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_CODE_COUNTER]));
            matdispatch.setDispatchStatus(rs.getInt(PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS]));
            matdispatch.setRemark(rs.getString(PstMatDispatch.fieldNames[PstMatDispatch.FLD_REMARK]));
            matdispatch.setInvoiceSupplier(rs.getString(PstMatDispatch.fieldNames[PstMatDispatch.FLD_INVOICE_SUPPLIER]));
            matdispatch.setTransferStatus(rs.getInt(PstMatDispatch.fieldNames[PstMatDispatch.FLD_TRANSFER_STATUS]));

            Date dates = DBHandler.convertDate(rs.getDate(PstMatDispatch.fieldNames[PstMatDispatch.FLD_LAST_UPDATE]), rs.getTime(PstMatDispatch.fieldNames[PstMatDispatch.FLD_LAST_UPDATE]));
            matdispatch.setLast_update(dates);

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long matDispatchId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_DISPATCH +
                    " WHERE " + fieldNames[FLD_DISPATCH_MATERIAL_ID] +
                    " = " + matDispatchId;

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
        int hasil = 0;
        try {
            String sql = "SELECT COUNT(" + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_MATERIAL_ID] + ") FROM " + TBL_DISPATCH;
            if (whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            hasil = count;
        } catch (Exception e) {
            hasil = 0;
        } finally {
            DBResultSet.close(dbrs);
        }
        return hasil;
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
                    MatDispatch matdispatch = (MatDispatch) list.get(ls);
                    if (oid == matdispatch.getOID())
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

    public static long AutoInsertDf(Vector listItem, long oidLocation, long oidDispatchTo, int locType) {
        long hasil = 0;
        SessMatDispatch sessDispatch = new SessMatDispatch();
        try {
            MatDispatch mydf = new MatDispatch();
            mydf.setDispatchStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);
            mydf.setDispatchDate(new Date());
            mydf.setLocationId(oidLocation);
            mydf.setDispatchTo(oidDispatchTo);
            mydf.setLocationType(locType);
            mydf.setRemark("");
            mydf.setDispatchCodeCounter(sessDispatch.getMaxDispatchCounter(new Date(), mydf) + 1);
            mydf.setDispatchCode(sessDispatch.generateDispatchCode(mydf));
            //Insert dispatch
            hasil = PstMatDispatch.insertExc(mydf);
            if (hasil != 0) {
                //Insert df item
                for (int i = 0; i < listItem.size(); i++) {
                    long oidDfItem = 0;
                    Vector temp = (Vector) listItem.get(i);
                    String sku = (String) temp.get(0);
                    if (sku.length() > 0) {
                        //Fetch material info
                        Material myMat = PstMaterial.fetchBySku(sku);
                        int quantity = Integer.parseInt((String) temp.get(1));
                        MatDispatchItem dfItem = new MatDispatchItem();
                        dfItem.setDispatchMaterialId(hasil);
                        dfItem.setMaterialId(myMat.getOID());
                        dfItem.setUnitId(myMat.getDefaultStockUnitId());
                        dfItem.setQty(quantity);
                        oidDfItem = PstMatDispatchItem.insertExc(dfItem);
                    } else {
                        oidDfItem = 1;
                    }
                    if (oidDfItem == 0) break;
                }
            }
        } catch (Exception ex) {
            System.out.println("AutoInsertDf : " + ex);
        }
        return hasil;
    }

    /**
     * <name>gadnyana</name>
     * proses pembuatan data object data mat dispatch
     */
    public static MatDispatch getObjectMatDispatch(long oidLocation) {
        MatDispatch mydf = new MatDispatch();
        try {
            SessMatDispatch sessDispatch = new SessMatDispatch();
            mydf.setDispatchStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);
            mydf.setDispatchDate(new Date());
            long oidWarehouse = PstLocation.getLocationByType(PstLocation.TYPE_LOCATION_WAREHOUSE);
            mydf.setLocationId(oidWarehouse);
            mydf.setDispatchTo(oidLocation);
            mydf.setLocationType(FLD_TYPE_DISPATCH_LOCATION_WAREHOUSE);
            mydf.setRemark("");
            mydf.setDispatchCodeCounter(sessDispatch.getMaxDispatchCounter(new Date(), mydf) + 1);
            mydf.setDispatchCode(sessDispatch.generateDispatchCode(mydf));
        } catch (Exception e) {
        }
        return mydf;
    }

    /**
     * gadnyana
     */
    public static MatDispatch cekObjectMatDispatch(long oidToLocation) {
        MatDispatch matDispatch = new MatDispatch();
        try {
            SessMatDispatch sessDispatch = new SessMatDispatch();
            String whereClause = PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_TO] + "=" + oidToLocation +
                    " and " + PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_STATUS] + "=" + I_DocStatus.DOCUMENT_STATUS_DRAFT;
            Vector list = list(0, 0, whereClause, PstMatDispatch.fieldNames[PstMatDispatch.FLD_DISPATCH_CODE]);
            if (list != null && list.size() > 0) {
                matDispatch = (MatDispatch) list.get(0);
            }
        } catch (Exception e) {
        }
        return matDispatch;
    }

    public static boolean AutoInsertTransferData(Vector listItem, int statusHpp) {
        boolean hasil = true;
        try {
            for (int i = 0; i < listItem.size(); i++) {
                Vector temp = (Vector) listItem.get(i);
                long oidMaterial = Long.parseLong((String)temp.get(0));
                int qtyDf = Integer.parseInt((String)temp.get(1));
                long oidLokasi = Long.parseLong((String)temp.get(2));
                MatDispatchItem matDispatchItem = new MatDispatchItem();
                matDispatchItem.setMaterialId(oidMaterial);
                matDispatchItem.setQty(qtyDf);
                matDispatchItem.setResidueQty(qtyDf);

                Material mat = PstMaterial.fetchExc(oidMaterial);
                matDispatchItem.setUnitId(mat.getDefaultStockUnitId());
                if(statusHpp==0){
                    matDispatchItem.setHpp(mat.getAveragePrice());
                    matDispatchItem.setHppTotal(matDispatchItem.getHpp() * matDispatchItem.getQty());
                }else{
                    double sellPrice = PstPriceTypeMapping.getSellPrice(mat.getOID(),PstPriceTypeMapping.getOidStandartRate(),PstPriceTypeMapping.getOidPriceType());
                    matDispatchItem.setHpp(sellPrice);
                    matDispatchItem.setHppTotal(matDispatchItem.getHpp() * matDispatchItem.getQty());
                }
                MatDispatch matDispatch = PstMatDispatch.cekObjectMatDispatch(oidLokasi);
                if(matDispatch.getOID()!=0){
                    matDispatchItem.setDispatchMaterialId(matDispatch.getOID());
                    MatDispatchItem objMatDispatchItem = PstMatDispatchItem.getObjectDispatchItem(oidMaterial,matDispatch.getOID());
                    if(objMatDispatchItem.getOID()!=0){
                        matDispatchItem.setOID(objMatDispatchItem.getOID());
                        PstMatDispatchItem.updateExc(matDispatchItem);
                    }else{
                        PstMatDispatchItem.insertExc(matDispatchItem);
                    }
                }else{
                    matDispatch = getObjectMatDispatch(oidLokasi);
                    long oid = PstMatDispatch.insertExc(matDispatch);
                    matDispatchItem.setDispatchMaterialId(oid);
                    PstMatDispatchItem.insertExc(matDispatchItem);
                }
            }
        } catch (Exception ex) {
            hasil = false;
            System.out.println("AutoInsertDf : " + ex);
        }
        return hasil;
    }

    /*-------------------- start implements I_Document -------------------------*/

    /**
     * this method used to get status of 'document'
     * return int of currentDocumentStatus
     */
    public int getDocumentStatus(long documentId) {
        DBResultSet dbrs = null;
        try {
            MatDispatch matDispatch = fetchExc(documentId);
            return matDispatch.getDispatchStatus();
        } catch (Exception e) {
            System.out.println("Err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return -1;
    }

    /**
     * this method used to set status of 'document'
     * return int of currentDocumentStatus
     */
    public int setDocumentStatus(long documentId, int indexStatus) {
        /*DBResultSet dbrs = null;
        try
        {
            String sql = "UPDATE " + TBL_DISPATCH +
                " SET " + fieldNames[FLD_DISPATCH_STATUS] + " = " + indexStatus +
                " WHERE " + fieldNames[FLD_DISPATCH_MATERIAL_ID] + " = " + documentId;
            dbrs = DBHandler.execQueryResult(sql);*/
        return indexStatus;
        /*}
        catch(Exception e)
        {
            System.out.println("Err : "+e.toString());
        }
        finally
        {
            DBResultSet.close(dbrs);
        }
        return -1;*/
    }
    /*-------------------- end implements I_Document --------------------------*/


    /**
     * digunakan untuk update status transfer data secara otomatis.
     * jika residue qty item semuanya 0 maka status transfer CLOSED.
     * jika residue qty masih ada yang lebih dari 0 maka status transfer DRAFT.
     *
     * @param oid
     */
    public static void processUpdate(long oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(" + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_RESIDUE_QTY] + ") " +
                    " AS SUM_" + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_RESIDUE_QTY] +
                    " FROM " + PstMatDispatchItem.TBL_MAT_DISPATCH_ITEM +
                    " WHERE " + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ID] + " = " + oid;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int sumqty = 0;
            while (rs.next()) {
                sumqty = rs.getInt("SUM_" + PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_RESIDUE_QTY]);
            }

            MatDispatch matDispatch = new MatDispatch();
            matDispatch = PstMatDispatch.fetchExc(oid);
            if (sumqty == 0) {
                matDispatch.setTransferStatus(I_DocStatus.DOCUMENT_STATUS_CLOSED);
            } else {
                matDispatch.setTransferStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);
            }
            // update transfer status
            PstMatDispatch.updateExc(matDispatch);

        } catch (Exception e) {
        }
    }
}
