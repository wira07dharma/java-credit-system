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
import com.dimata.posbo.entity.purchasing.*;
import com.dimata.posbo.session.warehouse.*;
import com.dimata.posbo.entity.masterdata.*;
import com.dimata.common.entity.contact.PstContactList;
import com.dimata.common.entity.contact.ContactList;
import com.dimata.common.entity.location.PstLocation;
import com.dimata.common.entity.location.Location;
import com.dimata.common.entity.payment.CurrencyType;
import com.dimata.common.entity.payment.PstCurrencyType;


public class PstMatReceive extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language, I_Document {

    public static final String TBL_MAT_RECEIVE = "pos_receive_material";

    public static final int FLD_RECEIVE_MATERIAL_ID = 0;
    public static final int FLD_LOCATION_ID = 1;
    public static final int FLD_RECEIVE_FROM = 2;
    public static final int FLD_LOCATION_TYPE = 3;
    public static final int FLD_RECEIVE_DATE = 4;
    public static final int FLD_REC_CODE = 5;
    public static final int FLD_REC_CODE_CNT = 6;
    public static final int FLD_RECEIVE_STATUS = 7;
    public static final int FLD_RECEIVE_SOURCE = 8;
    public static final int FLD_SUPPLIER_ID = 9;
    public static final int FLD_PURCHASE_ORDER_ID = 10;
    public static final int FLD_DISPATCH_MATERIAL_ID = 11;
    public static final int FLD_RETURN_MATERIAL_ID = 12;
    public static final int FLD_REMARK = 13;
    public static final int FLD_INVOICE_SUPPLIER = 14;
    public static final int FLD_TOTAL_PPN = 15;
    public static final int FLD_TRANSFER_STATUS = 16;
    public static final int FLD_REASON = 17;

    // NEW
    public static final int FLD_TERM_OF_PAYMENT = 18;
    public static final int FLD_CREDIT_TIME = 19;
    public static final int FLD_EXPIRED_DATE = 20;
    public static final int FLD_DISCOUNT = 21;
    public static final int FLD_LAST_UPDATE = 22;
    public static final int FLD_CURRENCY_ID = 23;
    public static final int FLD_TRANS_RATE = 24;

    public static final String[] fieldNames = {
        "RECEIVE_MATERIAL_ID",
        "LOCATION_ID",
        "RECEIVE_FROM",
        "LOCATION_TYPE",
        "RECEIVE_DATE",
        "REC_CODE",
        "REC_CODE_CNT",
        "RECEIVE_STATUS",
        "RECEIVE_SOURCE",
        "SUPPLIER_ID",
        "PURCHASE_ORDER_ID",
        "DISPATCH_MATERIAL_ID",
        "RETURN_MATERIAL_ID",
        "REMARK",
        "INVOICE_SUPPLIER",
        "TOTAL_PPN",
        "TRANSFER_STATUS",
        "REASON",
        "TERM_OF_PAYMENT",
        "CREDIT_TIME",
        "EXPIRED_DATE",
        "DISCOUNT",
        "LAST_UPDATE",
        "CURRENCY_ID",
        "TRANS_RATE"
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
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_FLOAT
    };

    public static final int SOURCE_FROM_SUPPLIER = 0;
    public static final int SOURCE_FROM_SUPPLIER_PO = 1;
    public static final int SOURCE_FROM_DISPATCH = 2;
    public static final int SOURCE_FROM_RETURN = 3;

    //Pengiriman Transfer Unit
    public static final int SOURCE_FROM_DISPATCH_UNIT = 4;

    public static String[][] strReceiveSourceList = {
        {"Supplier tanpa PO", "PO Supplier", "Pengiriman", "Pengembalian"},
        {"Supplier w/o PO", "Purchase Order", "Dispatch", "Return"}
    };

    public static Vector getReceiveSourceType(int language) {
        Vector result = new Vector(1, 1);
        for (int i = 0; i < strReceiveSourceList[0].length; i++) {
            result.add(strReceiveSourceList[language][i]);
        }
        return result;
    }

    // DI PAKAI UNTUK ALASAN RECEIVE
    public static final int REASON_BONUS = 0;
    public static final int REASON_TUKAR_GULING = 1;
    public static final int REASON_ORDERING = 2;

    /**gadnyana
     * array untuk ALASAN penerimaan barang
     */
    public static String[][] strReason = {
        {"BONUS", "TUKAR GULING", "BELI"},
        {"BONUS", "BARTER", "ORDER"}
    };

    /**gadnyana
     * untuk get semua alasan penerimaan
     * @param language
     * @return vector of reason
     */
    public static Vector getReceiveReason(int language) {
        Vector result = new Vector(1, 1);
        for (int i = 0; i < strReason[0].length; i++) {
            result.add(strReason[language][i]);
        }
        return result;
    }

    public PstMatReceive() {
    }

    public PstMatReceive(int i) throws DBException {
        super(new PstMatReceive());
    }

    public PstMatReceive(String sOid) throws DBException {
        super(new PstMatReceive(0));
        if (!locate(sOid))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }

    public PstMatReceive(long lOid) throws DBException {
        super(new PstMatReceive(0));
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
        return TBL_MAT_RECEIVE;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstMatReceive().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        MatReceive matreceive = fetchExc(ent.getOID());
        ent = (Entity) matreceive;
        return matreceive.getOID();
    }

    synchronized public long insertExc(Entity ent) throws Exception {
        return insertExc((MatReceive) ent);
    }

    synchronized public long updateExc(Entity ent) throws Exception {
        return updateExc((MatReceive) ent);
    }

    synchronized public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static MatReceive fetchExc(long oid) throws DBException {
        try {
            MatReceive matreceive = new MatReceive();
            PstMatReceive pstMatReceive = new PstMatReceive(oid);
            matreceive.setOID(oid);

            matreceive.setLocationId(pstMatReceive.getlong(FLD_LOCATION_ID));
            matreceive.setReceiveFrom(pstMatReceive.getlong(FLD_RECEIVE_FROM));
            matreceive.setLocationType(pstMatReceive.getInt(FLD_LOCATION_TYPE));
            matreceive.setReceiveDate(pstMatReceive.getDate(FLD_RECEIVE_DATE));
            matreceive.setRecCode(pstMatReceive.getString(FLD_REC_CODE));
            matreceive.setRecCodeCnt(pstMatReceive.getInt(FLD_REC_CODE_CNT));
            matreceive.setReceiveStatus(pstMatReceive.getInt(FLD_RECEIVE_STATUS));
            matreceive.setReceiveSource(pstMatReceive.getInt(FLD_RECEIVE_SOURCE));
            matreceive.setSupplierId(pstMatReceive.getlong(FLD_SUPPLIER_ID));
            matreceive.setPurchaseOrderId(pstMatReceive.getlong(FLD_PURCHASE_ORDER_ID));
            matreceive.setDispatchMaterialId(pstMatReceive.getlong(FLD_DISPATCH_MATERIAL_ID));
            matreceive.setReturnMaterialId(pstMatReceive.getlong(FLD_RETURN_MATERIAL_ID));
            matreceive.setRemark(pstMatReceive.getString(FLD_REMARK));
            matreceive.setInvoiceSupplier(pstMatReceive.getString(FLD_INVOICE_SUPPLIER));
            matreceive.setTotalPpn(pstMatReceive.getdouble(FLD_TOTAL_PPN));
            matreceive.setTransferStatus(pstMatReceive.getInt(FLD_TRANSFER_STATUS));

            // new
            matreceive.setReason(pstMatReceive.getInt(FLD_REASON));
            matreceive.setTermOfPayment(pstMatReceive.getInt(FLD_TERM_OF_PAYMENT));
            matreceive.setCreditTime(pstMatReceive.getInt(FLD_CREDIT_TIME));
            matreceive.setExpiredDate(pstMatReceive.getDate(FLD_EXPIRED_DATE));
            matreceive.setDiscount(pstMatReceive.getdouble(FLD_DISCOUNT));
            matreceive.setLastUpdate(pstMatReceive.getDate(FLD_LAST_UPDATE));
            matreceive.setCurrencyId(pstMatReceive.getlong(FLD_CURRENCY_ID));
            matreceive.setTransRate(pstMatReceive.getdouble(FLD_TRANS_RATE));

            return matreceive;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatReceive(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(MatReceive matreceive) throws DBException {
        try {
            PstMatReceive pstMatReceive = new PstMatReceive(0);

            pstMatReceive.setLong(FLD_LOCATION_ID, matreceive.getLocationId());
            pstMatReceive.setLong(FLD_RECEIVE_FROM, matreceive.getReceiveFrom());
            pstMatReceive.setInt(FLD_LOCATION_TYPE, matreceive.getLocationType());

            pstMatReceive.setDate(FLD_RECEIVE_DATE, matreceive.getReceiveDate());

            pstMatReceive.setString(FLD_REC_CODE, matreceive.getRecCode());
            pstMatReceive.setInt(FLD_REC_CODE_CNT, matreceive.getRecCodeCnt());
            pstMatReceive.setInt(FLD_RECEIVE_STATUS, matreceive.getReceiveStatus());
            pstMatReceive.setInt(FLD_RECEIVE_SOURCE, matreceive.getReceiveSource());
            pstMatReceive.setLong(FLD_SUPPLIER_ID, matreceive.getSupplierId());
            pstMatReceive.setLong(FLD_PURCHASE_ORDER_ID, matreceive.getPurchaseOrderId());
            pstMatReceive.setLong(FLD_DISPATCH_MATERIAL_ID, matreceive.getDispatchMaterialId());
            pstMatReceive.setLong(FLD_RETURN_MATERIAL_ID, matreceive.getReturnMaterialId());
            pstMatReceive.setString(FLD_REMARK, matreceive.getRemark());
            pstMatReceive.setString(FLD_INVOICE_SUPPLIER, matreceive.getInvoiceSupplier());
            pstMatReceive.setDouble(FLD_TOTAL_PPN, matreceive.getTotalPpn());
            pstMatReceive.setInt(FLD_TRANSFER_STATUS, matreceive.getTransferStatus());
            // new
            pstMatReceive.setInt(FLD_REASON, matreceive.getReason());
            pstMatReceive.setInt(FLD_CREDIT_TIME, matreceive.getCreditTime());
            pstMatReceive.setDate(FLD_EXPIRED_DATE, matreceive.getExpiredDate());
            pstMatReceive.setInt(FLD_TERM_OF_PAYMENT, matreceive.getTermOfPayment());
            pstMatReceive.setDouble(FLD_DISCOUNT, matreceive.getDiscount());
            pstMatReceive.setDate(FLD_LAST_UPDATE, matreceive.getLastUpdate());
            pstMatReceive.setLong(FLD_CURRENCY_ID, matreceive.getCurrencyId());
            pstMatReceive.setDouble(FLD_TRANS_RATE, matreceive.getTransRate());

            pstMatReceive.insert();
            matreceive.setOID(pstMatReceive.getlong(FLD_RECEIVE_MATERIAL_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatReceive(0), DBException.UNKNOWN);
        }
        return matreceive.getOID();
    }

    public static long updateExc(MatReceive matreceive) throws DBException {
        try {
            if (matreceive.getOID() != 0) {
                PstMatReceive pstMatReceive = new PstMatReceive(matreceive.getOID());

                pstMatReceive.setLong(FLD_LOCATION_ID, matreceive.getLocationId());
                pstMatReceive.setLong(FLD_RECEIVE_FROM, matreceive.getReceiveFrom());
                pstMatReceive.setInt(FLD_LOCATION_TYPE, matreceive.getLocationType());
                pstMatReceive.setDate(FLD_RECEIVE_DATE, matreceive.getReceiveDate());
                pstMatReceive.setString(FLD_REC_CODE, matreceive.getRecCode());
                pstMatReceive.setInt(FLD_REC_CODE_CNT, matreceive.getRecCodeCnt());
                pstMatReceive.setInt(FLD_RECEIVE_STATUS, matreceive.getReceiveStatus());
                pstMatReceive.setInt(FLD_RECEIVE_SOURCE, matreceive.getReceiveSource());
                pstMatReceive.setLong(FLD_SUPPLIER_ID, matreceive.getSupplierId());
                pstMatReceive.setLong(FLD_PURCHASE_ORDER_ID, matreceive.getPurchaseOrderId());
                pstMatReceive.setLong(FLD_DISPATCH_MATERIAL_ID, matreceive.getDispatchMaterialId());
                pstMatReceive.setLong(FLD_RETURN_MATERIAL_ID, matreceive.getReturnMaterialId());
                pstMatReceive.setString(FLD_REMARK, matreceive.getRemark());
                pstMatReceive.setString(FLD_INVOICE_SUPPLIER, matreceive.getInvoiceSupplier());
                pstMatReceive.setDouble(FLD_TOTAL_PPN, matreceive.getTotalPpn());
                pstMatReceive.setInt(FLD_TRANSFER_STATUS, matreceive.getTransferStatus());

                // new
                pstMatReceive.setInt(FLD_REASON, matreceive.getReason());
                pstMatReceive.setInt(FLD_CREDIT_TIME, matreceive.getCreditTime());
                pstMatReceive.setDate(FLD_EXPIRED_DATE, matreceive.getExpiredDate());
                pstMatReceive.setInt(FLD_TERM_OF_PAYMENT, matreceive.getTermOfPayment());
                pstMatReceive.setDouble(FLD_DISCOUNT, matreceive.getDiscount());
                pstMatReceive.setDate(FLD_LAST_UPDATE, matreceive.getLastUpdate());
                pstMatReceive.setLong(FLD_CURRENCY_ID, matreceive.getCurrencyId());
                pstMatReceive.setDouble(FLD_TRANS_RATE, matreceive.getTransRate());

                pstMatReceive.update();
                return matreceive.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatReceive(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstMatReceive pstMatReceive = new PstMatReceive(oid);
            //Delete Item First
            PstMatReceiveItem pstRecItem = new PstMatReceiveItem();
            long result = pstRecItem.deleteExcByParent(oid);
            pstMatReceive.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstMatReceive(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_MAT_RECEIVE;
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
                MatReceive matreceive = new MatReceive();
                resultToObject(rs, matreceive);
                lists.add(matreceive);
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

    //getListBySupplier
    public static Vector listBySupplier(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT REC." + fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] +
		    " ,REC." + fieldNames[PstMatReceive.FLD_REC_CODE] +
		    " ,REC." + fieldNames[PstMatReceive.FLD_RECEIVE_DATE] +
		    " ,CNT." + PstContactList.fieldNames[PstContactList.FLD_COMP_NAME] +
		    " ,REC." + fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] +
		    " ,REC." + fieldNames[PstMatReceive.FLD_REMARK] +
		    " ,REC." + fieldNames[PstMatReceive.FLD_RECEIVE_SOURCE] +
		    " ,REC." + fieldNames[PstMatReceive.FLD_REASON] +
		    " ,REC." + fieldNames[PstMatReceive.FLD_CURRENCY_ID] +
		    " ,CT." + PstCurrencyType.fieldNames[PstCurrencyType.FLD_CODE] +
		    " ,PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID] +
		    " ,PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE] +
		    " FROM " + PstMatReceive.TBL_MAT_RECEIVE + " REC" +
		    " INNER JOIN " + PstContactList.TBL_CONTACT_LIST + " CNT" +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_SUPPLIER_ID] +
		    " = CNT." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID] +
		    " LEFT JOIN " + PstCurrencyType.TBL_POS_CURRENCY_TYPE + " CT" +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_CURRENCY_ID] +
		    " = CT." + PstCurrencyType.fieldNames[PstCurrencyType.FLD_CURRENCY_TYPE_ID] +
		    " LEFT JOIN " + PstPurchaseOrder.TBL_PURCHASE_ORDER + " PO " +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_PURCHASE_ORDER_ID] +
		    " = PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID];

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
               Vector vect = new Vector(1, 1);
		MatReceive matreceive = new MatReceive();
		ContactList contactList = new ContactList();
		CurrencyType currencyType = new CurrencyType();
		PurchaseOrder purchaseOrder = new PurchaseOrder();

		matreceive.setOID(rs.getLong(1));
		matreceive.setRecCode(rs.getString(2));
		matreceive.setReceiveDate(rs.getDate(3));
		matreceive.setReceiveStatus(rs.getInt(5));
		matreceive.setRemark(rs.getString(6));
		matreceive.setReceiveSource(rs.getInt(7));
		matreceive.setReason(rs.getInt(8));
		matreceive.setCurrencyId(rs.getLong(9));
		vect.add(matreceive);

		contactList.setCompName(rs.getString(4));
		vect.add(contactList);

		currencyType.setCode(rs.getString("CT." + PstCurrencyType.fieldNames[PstCurrencyType.FLD_CODE]));
		vect.add(currencyType);

		purchaseOrder.setOID(rs.getLong("PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PURCHASE_ORDER_ID]));
		purchaseOrder.setPoCode(rs.getString("PO." + PstPurchaseOrder.fieldNames[PstPurchaseOrder.FLD_PO_CODE]));
		vect.add(purchaseOrder);

		lists.add(vect);
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

    public static void resultToObject(ResultSet rs, MatReceive matreceive) {
        try {
            matreceive.setOID(rs.getLong(PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID]));
            matreceive.setLocationId(rs.getLong(PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_ID]));
            matreceive.setReceiveFrom(rs.getLong(PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_FROM]));
            matreceive.setLocationType(rs.getInt(PstMatReceive.fieldNames[PstMatReceive.FLD_LOCATION_TYPE]));
            matreceive.setReceiveDate(rs.getDate(PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_DATE]));
            matreceive.setRecCode(rs.getString(PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE]));
            matreceive.setRecCodeCnt(rs.getInt(PstMatReceive.fieldNames[PstMatReceive.FLD_REC_CODE_CNT]));
            matreceive.setReceiveStatus(rs.getInt(PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS]));
            matreceive.setReceiveSource(rs.getInt(PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_SOURCE]));
            matreceive.setSupplierId(rs.getLong(PstMatReceive.fieldNames[PstMatReceive.FLD_SUPPLIER_ID]));
            matreceive.setPurchaseOrderId(rs.getLong(PstMatReceive.fieldNames[PstMatReceive.FLD_PURCHASE_ORDER_ID]));
            matreceive.setDispatchMaterialId(rs.getLong(PstMatReceive.fieldNames[PstMatReceive.FLD_DISPATCH_MATERIAL_ID]));
            matreceive.setReturnMaterialId(rs.getLong(PstMatReceive.fieldNames[PstMatReceive.FLD_RETURN_MATERIAL_ID]));
            matreceive.setRemark(rs.getString(PstMatReceive.fieldNames[PstMatReceive.FLD_REMARK]));
            matreceive.setInvoiceSupplier(rs.getString(PstMatReceive.fieldNames[PstMatReceive.FLD_INVOICE_SUPPLIER]));
            matreceive.setTotalPpn(rs.getDouble(PstMatReceive.fieldNames[PstMatReceive.FLD_TOTAL_PPN]));
            matreceive.setTransferStatus(rs.getInt(PstMatReceive.fieldNames[PstMatReceive.FLD_TRANSFER_STATUS]));
            // new
            matreceive.setReason(rs.getInt(PstMatReceive.fieldNames[PstMatReceive.FLD_REASON]));
            matreceive.setCreditTime(rs.getInt(PstMatReceive.fieldNames[PstMatReceive.FLD_CREDIT_TIME]));
            matreceive.setDiscount(rs.getDouble(PstMatReceive.fieldNames[PstMatReceive.FLD_DISCOUNT]));
            matreceive.setExpiredDate(rs.getDate(PstMatReceive.fieldNames[PstMatReceive.FLD_EXPIRED_DATE]));
            matreceive.setTermOfPayment(rs.getInt(PstMatReceive.fieldNames[PstMatReceive.FLD_TERM_OF_PAYMENT]));
            matreceive.setCurrencyId(rs.getLong(PstMatReceive.fieldNames[PstMatReceive.FLD_CURRENCY_ID]));
            matreceive.setTransRate(rs.getDouble(PstMatReceive.fieldNames[PstMatReceive.FLD_TRANS_RATE]));

            Date dates = DBHandler.convertDate(rs.getDate(PstMatReceive.fieldNames[PstMatDispatch.FLD_LAST_UPDATE]), rs.getTime(PstMatReceive.fieldNames[PstMatDispatch.FLD_LAST_UPDATE]));
            matreceive.setLastUpdate(dates);

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long matReceiveId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_MAT_RECEIVE + " WHERE " +
                    PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] + " = " + matReceiveId;

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
            String sql = "SELECT COUNT(" + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] + ") FROM " + TBL_MAT_RECEIVE;
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

    //getCountListBySupplier
    public static int getCountListBySupplier(String whereClause) {
	DBResultSet dbrs = null;
	int count = 0;
	try {
	    String sql = "SELECT COUNT(REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] + ") AS CNT" +
		    " FROM " + PstMatReceive.TBL_MAT_RECEIVE + " REC" +
		    " INNER JOIN " + PstContactList.TBL_CONTACT_LIST + " CNT" +
		    " ON REC." + PstMatReceive.fieldNames[PstMatReceive.FLD_SUPPLIER_ID] +
		    " = CNT." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID];

        if (whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count2 = 0;
            while (rs.next()) {
                count2 = rs.getInt(1);
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
                    MatReceive matreceive = (MatReceive) list.get(ls);
                    if (oid == matreceive.getOID())
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

    /*-------------------- start implements I_Document -------------------------*/
    /**
     * this method used to get number/code of 'document'
     * return String of number/document code
     */
    /*public String getDocumentNumber(long documentId){
        DBResultSet dbrs = null;
                try{
            MatReceive matReceive = fetchExc(documentId);
            return matReceive.getRecCode();
        }catch(Exception e){
                System.out.println("Err : "+e.toString());
        }finally{
                DBResultSet.close(dbrs);
        }
        return "";
    }*/

    /**
     * this method used to get status of 'document'
     * return int of currentDocumentStatus
     */
    public int getDocumentStatus(long documentId) {
        DBResultSet dbrs = null;
        try {
            MatReceive matReceive = fetchExc(documentId);
            return matReceive.getReceiveStatus();
        } catch (Exception e) {
            System.out.println("Err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return -1;
    }
    
    
     /**
     * this method used to get oid Receive Material
     * return long of currentDocumentStatus
     */
    public static long getOidReceiveMaterial(long oidMatDispatch) {
        DBResultSet dbrs = null;
        long hasil = 0;
        try {
            String sql = "SELECT " + fieldNames[FLD_RECEIVE_MATERIAL_ID] + 
                         " FROM " + TBL_MAT_RECEIVE +
                         " WHERE " + fieldNames[FLD_DISPATCH_MATERIAL_ID] + "=" +oidMatDispatch;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            long oid = 0;
            while (rs.next()) {
                oid = rs.getLong(1);
            }

            rs.close();
            hasil = oid;
        } catch (Exception e) {
            hasil = 0;
        } finally {
            DBResultSet.close(dbrs);
        }
        return hasil;
    }


    /**
     * this method used to set status of 'document'
     * return int of currentDocumentStatus
     */
    public int setDocumentStatus(long documentId, int indexStatus) {
        /*DBResultSet dbrs = null;
        try
        {
            String sql = "UPDATE " + PstMatReceive.TBL_MAT_RECEIVE +
                " SET " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_STATUS] + " = " + indexStatus +
                " WHERE " + PstMatReceive.fieldNames[PstMatReceive.FLD_RECEIVE_MATERIAL_ID] + " = " + documentId;
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

    public static long AutoInsertReceive(Vector listItem, long oidLocation, long oidSupplier,
                                         int locType, long receiveFrom, int receiveSource) {
        long hasil = 0;
        try {
            MatReceive myrec = new MatReceive();
            myrec.setLocationId(oidLocation);
            myrec.setLocationType(locType);
            myrec.setReceiveFrom(receiveFrom);
            myrec.setSupplierId(oidSupplier);
            myrec.setReceiveDate(new Date());
            myrec.setReceiveStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);
            myrec.setReceiveSource(receiveSource);
            myrec.setRemark("");
            myrec.setRecCodeCnt(SessMatReceive.getIntCode(myrec, new Date(), 0, 1));
            myrec.setRecCode(SessMatReceive.getCodeReceive(myrec));
            //Insert return
            hasil = PstMatReceive.insertExc(myrec);
            if (hasil != 0) {
                //Insert return item
                for (int i = 0; i < listItem.size(); i++) {
                    long oidRECItem = 0;
                    Vector temp = (Vector) listItem.get(i);
                    String sku = (String) temp.get(0);
                    if (sku.length() > 0) {
                        //Fetch material info
                        Material myMat = PstMaterial.fetchBySku(sku);
                        boolean masuk = false;
                        //Cek supplier utk material tsb (toSupplier), jika tidak sama lewati saja
                        if (myMat.getSupplierId() == oidSupplier) masuk = true;
                        //Cek apakah return to Warehouse
                        if ((oidSupplier == 0) && (receiveFrom != 0)) masuk = true;
                        if (masuk == true) {
                            int quantity = Integer.parseInt((String) temp.get(1));
                            MatReceiveItem recItem = new MatReceiveItem();
                            recItem.setReceiveMaterialId(hasil);
                            recItem.setMaterialId(myMat.getOID());
                            recItem.setUnitId(myMat.getDefaultStockUnitId());
                            recItem.setQty(quantity);
                            recItem.setCost(myMat.getDefaultCost());
                            recItem.setCurrencyId(myMat.getDefaultCostCurrencyId());
                            recItem.setTotal(quantity * myMat.getDefaultCost());
                            oidRECItem = PstMatReceiveItem.insertExc(recItem);
                        } else {
                            oidRECItem = 1;
                        }
                    } else {
                        oidRECItem = 1;
                    }
                    if (oidRECItem == 0) break;
                }
            }
        } catch (Exception ex) {
            System.out.println("AutoInsertReceive : " + ex);
        }
        return hasil;
    }

    public static long AutoInsertReceivePO(long oidPurchaseOrder, int receiveSource, int locType) {
        long hasil = 0;
        Vector listItem = new Vector();
        try {
            PurchaseOrder po = PstPurchaseOrder.fetchExc(oidPurchaseOrder);
            MatReceive myrec = new MatReceive();
            myrec.setLocationId(po.getLocationId());
            myrec.setLocationType(locType);
            myrec.setReceiveFrom(0);
            myrec.setSupplierId(po.getSupplierId());
            myrec.setReceiveDate(new Date());
            myrec.setPurchaseOrderId(oidPurchaseOrder);
            myrec.setReceiveStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);
            myrec.setReceiveSource(receiveSource);
            myrec.setRemark("");
            myrec.setRecCodeCnt(SessMatReceive.getIntCode(myrec, new Date(), 0, 1));
            myrec.setRecCode(SessMatReceive.getCodeReceive(myrec));
            //Insert return
            hasil = PstMatReceive.insertExc(myrec);
            if (hasil != 0) {
                String whereClause = PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ID] +
                        " = " + oidPurchaseOrder;
                String orderClause = PstPurchaseOrderItem.fieldNames[PstPurchaseOrderItem.FLD_PURCHASE_ORDER_ITEM_ID];
                listItem = PstPurchaseOrderItem.list(0, 0, whereClause, orderClause);
                //Insert return item
                for (int i = 0; i < listItem.size(); i++) {
                    long oidRECItem = 0;
                    //Fetch material info
                    PurchaseOrderItem poi = (PurchaseOrderItem) listItem.get(i);

                    MatReceiveItem recItem = new MatReceiveItem();
                    recItem.setReceiveMaterialId(hasil);
                    recItem.setMaterialId(poi.getMaterialId());
                    recItem.setUnitId(poi.getUnitId());
                    recItem.setQty(poi.getQuantity());
                    recItem.setExpiredDate(new Date());
                    recItem.setCost(poi.getPrice());
                    recItem.setCurrencyId(poi.getCurrencyId());
                    recItem.setTotal(poi.getQuantity() * poi.getPrice());
                    oidRECItem = PstMatReceiveItem.insertExc(recItem);
                    if (oidRECItem == 0) break;
                }
            }
        } catch (Exception ex) {
            System.out.println("AutoInsertReceivePO : " + ex);
        }
        return hasil;
    }

    public static long AutoInsertReceiveDF(long oidDispatchMaterial, int receiveSource, int locType) {
        long hasil = 0;
        Vector listItem = new Vector();
        try {
            MatDispatch df = PstMatDispatch.fetchExc(oidDispatchMaterial);
            MatReceive myrec = new MatReceive();
            myrec.setLocationId(df.getDispatchTo());
            myrec.setLocationType(locType);
            myrec.setReceiveFrom(df.getLocationId());
            myrec.setSupplierId(0);
            myrec.setReceiveDate(new Date());
            myrec.setDispatchMaterialId(oidDispatchMaterial);
            myrec.setReceiveStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);
            myrec.setReceiveSource(receiveSource);
            myrec.setRemark("");
            myrec.setRecCodeCnt(SessMatReceive.getIntCode(myrec, new Date(), 0, 1));
            myrec.setRecCode(SessMatReceive.getCodeReceive(myrec));
            //Insert receive
            hasil = PstMatReceive.insertExc(myrec);
            if (hasil != 0) {
                String whereClause = PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ID] +
                        " = " + oidDispatchMaterial;
                String orderClause = PstMatDispatchItem.fieldNames[PstMatDispatchItem.FLD_DISPATCH_MATERIAL_ITEM_ID];
                listItem = PstMatDispatchItem.list(whereClause, orderClause);
                //Insert receive item
                for (int i = 0; i < listItem.size(); i++) {
                    long oidRECItem = 0;
                    //Fetch material info
                    Vector temp = (Vector) listItem.get(i);
                    MatDispatchItem dfi = (MatDispatchItem) temp.get(0);
                    Material mat = (Material) temp.get(1);

                    MatReceiveItem recItem = new MatReceiveItem();
                    recItem.setReceiveMaterialId(hasil);
                    recItem.setMaterialId(dfi.getMaterialId());
                    recItem.setUnitId(dfi.getUnitId());
                    recItem.setQty(dfi.getQty());
                    recItem.setExpiredDate(new Date());
                    recItem.setCost(mat.getDefaultCost());
                    recItem.setCurrencyId(mat.getDefaultCostCurrencyId());
                    recItem.setTotal(dfi.getQty() * mat.getDefaultCost());
                    oidRECItem = PstMatReceiveItem.insertExc(recItem);
                    if (oidRECItem == 0) break;
                }
            }
        } catch (Exception ex) {
            System.out.println("AutoInsertReceivePO : " + ex);
        }
        return hasil;
    }

    public static long AutoInsertReceiveRET(long oidReturnMaterial, int receiveSource, int locType) {
        long hasil = 0;
        Vector listItem = new Vector();
        try {
            MatReturn ret = PstMatReturn.fetchExc(oidReturnMaterial);
            MatReceive myrec = new MatReceive();
            myrec.setLocationId(ret.getReturnTo());
            myrec.setLocationType(locType);
            myrec.setReceiveFrom(ret.getLocationId());
            myrec.setSupplierId(0);
            myrec.setReceiveDate(new Date());
            myrec.setReturnMaterialId(oidReturnMaterial);
            myrec.setReceiveStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);
            myrec.setReceiveSource(receiveSource);
            myrec.setRemark("");
            myrec.setRecCodeCnt(SessMatReceive.getIntCode(myrec, new Date(), 0, 1));
            myrec.setRecCode(SessMatReceive.getCodeReceive(myrec));
            //Insert return
            hasil = PstMatReceive.insertExc(myrec);
            if (hasil != 0) {
                String whereClause = PstMatReturnItem.fieldNames[PstMatReturnItem.FLD_RETURN_MATERIAL_ID] +
                        " = " + oidReturnMaterial;
                listItem = PstMatReturnItem.list(0, 0, whereClause, "");
                //Insert return item
                for (int i = 0; i < listItem.size(); i++) {
                    long oidRECItem = 0;
                    //Fetch material info
                    MatReturnItem roi = (MatReturnItem) listItem.get(i);

                    MatReceiveItem recItem = new MatReceiveItem();
                    recItem.setReceiveMaterialId(hasil);
                    recItem.setMaterialId(roi.getMaterialId());
                    recItem.setUnitId(roi.getUnitId());
                    recItem.setQty(roi.getQty());
                    recItem.setExpiredDate(new Date());
                    recItem.setCost(roi.getCost());
                    recItem.setCurrencyId(roi.getCurrencyId());
                    recItem.setTotal(roi.getTotal());
                    oidRECItem = PstMatReceiveItem.insertExc(recItem);
                    if (oidRECItem == 0) break;
                }
            }
        } catch (Exception ex) {
            System.out.println("AutoInsertReceiveRET : " + ex);
        }
        return hasil;
    }

    /*-------------------- end implements I_Document --------------------------*/

    /** digunakan untuk update status transfer data secara otomatis.
     *  jika residue qty item semuanya 0 maka status transfer CLOSED.
     *  jika residue qty masih ada yang lebih dari 0 maka status transfer DRAFT.
     * @param oid
     */
    public static void processUpdate(long oid) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(" + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RESIDUE_QTY] + ") " +
                    " AS SUM_" + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RESIDUE_QTY] +
                    " FROM " + PstMatReceiveItem.TBL_MAT_RECEIVE_ITEM +
                    " WHERE " + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RECEIVE_MATERIAL_ID] + " = " + oid;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int sumqty = 0;
            while (rs.next()) {
                sumqty = rs.getInt("SUM_" + PstMatReceiveItem.fieldNames[PstMatReceiveItem.FLD_RESIDUE_QTY]);
            }

            MatReceive matReceive = new MatReceive();
            matReceive = PstMatReceive.fetchExc(oid);
            if (sumqty == 0) {
                matReceive.setTransferStatus(I_DocStatus.DOCUMENT_STATUS_CLOSED);
            } else {
                matReceive.setTransferStatus(I_DocStatus.DOCUMENT_STATUS_DRAFT);
            }
            // update transfer status
            PstMatReceive.updateExc(matReceive);

        } catch (Exception e) {
        }
    }
}
