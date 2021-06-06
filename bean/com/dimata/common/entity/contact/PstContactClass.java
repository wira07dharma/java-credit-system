
/* Created on 	:  [date] [time] AM/PM
 *
 * @author  	: karya
 * @version  	: 01
 */
/**
 * *****************************************************************
 * Class Description : [project description ... ] Imput Parameters : [input
 * parameter ...] Output : [output ...]
 * *****************************************************************
 */
package com.dimata.common.entity.contact;

/* package java */
import com.dimata.aiso.entity.masterdata.anggota.PstAnggota;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.common.db.*;
import com.dimata.qdep.entity.*;

/* package prochain */
import com.dimata.common.entity.contact.*;
import com.dimata.util.Formater;

public class PstContactClass extends DBHandler implements I_DBInterface,
        I_DBType, I_PersintentExc, I_Language, I_PersistentExcSynch {

    public static final String TBL_CONTACT_CLASS = "contact_class";
    public static final int FLD_CONTACT_CLASS_ID = 0;
    public static final int FLD_CLASS_NAME = 1;
    public static final int FLD_CLASS_DESCRIPTION = 2;
    public static final int FLD_CLASS_TYPE = 3;
    public static final int FLD_SERIES_NUMBER = 4;

    public static String[] arrayPostgres = {
        "CONTACT_CLASS_ID",
        "CLASS_NAME",
        "CLASS_DESCRIPTION",
        "CLASS_TYPE",
        "SERIES_NUM"
    };

    public static String[] arrayMysql = {
        "CONTACT_CLASS_ID",
        "CLASS_NAME",
        "CLASS_DESCRIPTION",
        "CLASS_TYPE"
    };

    public static String[] arrayFieldNames() {
        String[] sArrayResult = null;
        if (DBSVR_TYPE == DBSVR_POSTGRESQL) {
            sArrayResult = arrayPostgres;
        } else {
            sArrayResult = arrayMysql;
        }
        return sArrayResult;
    }

    /*public static final  String[] fieldNames = {
     "CONTACT_CLASS_ID",
     "CLASS_NAME",
     "CLASS_DESCRIPTION",
     "CLASS_TYPE",		
     "SERIES_NUM"
     };*/
    public static final String[] fieldNames = arrayFieldNames();

    public static int[] arrFieldTypePostgres = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING
    };

    public static int[] arrFieldTypeMysql = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT
    };

    public static int[] arrFieldTypes() {
        int[] iArrResult = null;
        if (DBSVR_TYPE == DBSVR_POSTGRESQL) {
            iArrResult = arrFieldTypePostgres;
        } else {
            iArrResult = arrFieldTypeMysql;
        }
        return iArrResult;
    }

    /*public static final  int[] fieldTypes = {
     TYPE_LONG + TYPE_PK + TYPE_ID,
     TYPE_STRING,
     TYPE_STRING,
     TYPE_INT,
     TYPE_STRING
     };*/
    public static final int[] fieldTypes = arrFieldTypes();

    public static final int CONTACT_TYPE_TRAVEL_AGENT       = 0;
    public static final int CONTACT_TYPE_SUPPLIER           = 1;
    public static final int CONTACT_TYPE_GUIDE              = 2;
    public static final int CONTACT_TYPE_COMPANY            = 3;
    public static final int CONTACT_TYPE_EMPLOYEE           = 4;
    public static final int FLD_CLASS_SHIPPER               = 5;
    public static final int FLD_CLASS_CLIENT                = 6;
    public static final int CONTACT_TYPE_MEMBER             = 7;
    public static final int FLD_CLASS_VENDOR                = 8;
    public static final int FLD_CLASS_COLLECTOR             = 9;
    public static final int FLD_CLASS_DONOR                 = 10;
    public static final int FLD_CLASS_CASHIER               = 11;
    public static final int FLD_CLASS_GOVERNMENT            = 12;
    public static final int FLD_CLASS_INSTITUTION           = 13;
    public static final int FLD_CLASS_PARTNER               = 14;
    public static final int FLD_CLASS_SHAREHOLDER           = 15;
    public static final int FLD_CLASS_VISITOR               = 16;
    public static final int FLD_CLASS_CARRIER               = 17;
    public static final int FLD_CLASS_OTHERS                = 18;
    public static final int FLD_CLASS_KELOMPOK_BADAN_USAHA  = 19;
    public static final int FLD_CLASS_PENJAMIN              = 20;
    public static final int CONTACT_TYPE_ACCOUNT_OFFICER    = 21;
    public static final int CONTACT_TYPE_ACCOUNT_COLLECTOR	= 22;

    public static final String[] contactType = {
        "Travel Agent",
        "Supplier",
        "Guide",
        "Company",
        "Employee",
        "Shipper",
        "Client",
        "Member",
        "Vendor",
        "Collector",
        "Donor",
        "Cashier",
        "Government",
        "Institution",
        "Partner",
        "ShareHolder",
        "Visitor",
        "Carrier",
        "Others",
        "Kelompok Badan Usaha",
        "Penjamin",
		"Analyst ",
        "Kolektor"
    };

    public static final String[] fieldClassType = {
        "Travel Agent",
        "Supplier",
        "Guide",
        "Company",
        "Employee",
        "Shipper",
        "Client",
        "Member",
        "Vendor",
        "Collector",
        "Donor",
        "Cashier",
        "Government",
        "Institution",
        "Partner",
        "ShareHolder",
        "Visitor",
        "Carrier",
        "Others",
        "Kelompok Badan Usaha",
        "Penjamin",
		"Analyst",
        "Kolektor"
    };

    public PstContactClass() {
    }

    public PstContactClass(int i) throws DBException {
        super(new PstContactClass());
    }

    public PstContactClass(String sOid) throws DBException {
        super(new PstContactClass(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstContactClass(long lOid) throws DBException {
        super(new PstContactClass(0));
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
        return TBL_CONTACT_CLASS;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstContactClass().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ContactClass contactclass = fetchExc(ent.getOID());
        ent = (Entity) contactclass;
        return contactclass.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ContactClass) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ContactClass) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static ContactClass fetchExc(long oid) throws DBException {
        try {
            ContactClass contactclass = new ContactClass();
            PstContactClass pstContactClass = new PstContactClass(oid);
            contactclass.setOID(oid);
            contactclass.setClassName(pstContactClass.getString(FLD_CLASS_NAME));
            contactclass.setClassDescription(pstContactClass.getString(FLD_CLASS_DESCRIPTION));
            contactclass.setClassType(pstContactClass.getInt(FLD_CLASS_TYPE));
            if (DBSVR_TYPE == DBSVR_POSTGRESQL) {
                contactclass.setSeriesNumber(pstContactClass.getString(FLD_SERIES_NUMBER));
            }

            return contactclass;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstContactClass(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(ContactClass contactclass) throws DBException {
        try {
            PstContactClass pstContactClass = new PstContactClass(0);
            pstContactClass.setString(FLD_CLASS_NAME, contactclass.getClassName());
            pstContactClass.setString(FLD_CLASS_DESCRIPTION, contactclass.getClassDescription());
            pstContactClass.setInt(FLD_CLASS_TYPE, contactclass.getClassType());
            if (DBSVR_TYPE == DBSVR_POSTGRESQL) {
                pstContactClass.setString(FLD_SERIES_NUMBER, contactclass.getSeriesNumber());
            }

            pstContactClass.insert();
            contactclass.setOID(pstContactClass.getlong(FLD_CONTACT_CLASS_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstContactClass(0), DBException.UNKNOWN);
        }
        return contactclass.getOID();
    }

    /**
     * * 3 function for data synchronization **
     */
    public long insertExcSynch(Entity ent) throws Exception {
        return insertExcSynch((ContactClass) ent);
    }

    public static long insertExcSynch(ContactClass contactclass) throws DBException {
        long newOID = 0;
        long originalOID = contactclass.getOID();
        try {
            newOID = insertExc(contactclass);
            if (newOID != 0) {  // sukses insert ?
                updateSynchOID(newOID, originalOID);
                return originalOID;
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstContactClass(0), DBException.UNKNOWN);
        }
        return 0;
    }

    /**
     * update oid lama dengan oid baru
     *
     * @param newOID
     * @param originalOID
     * @throws DBException
     * @return
     */
    public static long updateSynchOID(long newOID, long originalOID) throws DBException {
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE " + TBL_CONTACT_CLASS
                    + " SET " + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]
                    + " = " + originalOID
                    + " WHERE " + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]
                    + " = " + newOID;

            DBHandler.execUpdate(sql);
            return originalOID;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static long updateExc(ContactClass contactclass) throws DBException {
        try {
            if (contactclass.getOID() != 0) {
                PstContactClass pstContactClass = new PstContactClass(contactclass.getOID());
                pstContactClass.setString(FLD_CLASS_NAME, contactclass.getClassName());
                pstContactClass.setString(FLD_CLASS_DESCRIPTION, contactclass.getClassDescription());
                pstContactClass.setInt(FLD_CLASS_TYPE, contactclass.getClassType());
                if (DBSVR_TYPE == DBSVR_POSTGRESQL) {
                    pstContactClass.setString(FLD_SERIES_NUMBER, contactclass.getSeriesNumber());
                }
                pstContactClass.update();
                return contactclass.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstContactClass(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstContactClass pstContactClass = new PstContactClass(oid);
            pstContactClass.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstContactClass(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static long getIdContactType(int iContactType) {
        DBResultSet dbrs = null;
        long lIdContType = 0;
        try {
            String sql = "";
            sql = "SELECT " + fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]
                    + " FROM " + TBL_CONTACT_CLASS
                    + " WHERE " + fieldNames[PstContactClass.FLD_CLASS_TYPE]
                    + " = " + iContactType;

            System.out.println("SQL getIdContactType ==> " + iContactType);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                lIdContType = rs.getLong(1);
            }
        } catch (Exception e) {
            System.out.println("Exception on get getIdContactType : " + e.toString());
        }
        return lIdContType;
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT  * FROM " + PstContactClass.TBL_CONTACT_CLASS;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            switch (DBHandler.DBSVR_TYPE) {
                case DBHandler.DBSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }

                    break;

                case DBHandler.DBSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }

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
                ContactClass contactclass = new ContactClass();
                resultToObject(rs, contactclass);
                lists.add(contactclass);
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

    private static void resultToObject(ResultSet rs, ContactClass contactclass) {
        try {
            contactclass.setOID(rs.getLong(PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]));
            contactclass.setClassName(rs.getString(PstContactClass.fieldNames[PstContactClass.FLD_CLASS_NAME]));
            contactclass.setClassDescription(rs.getString(PstContactClass.fieldNames[PstContactClass.FLD_CLASS_DESCRIPTION]));
            contactclass.setClassType(rs.getInt(PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE]));
            contactclass.setSeriesNumber(rs.getString(PstContactClass.fieldNames[PstContactClass.FLD_SERIES_NUMBER]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long contactClassId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_CONTACT_CLASS + " WHERE "
                    + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] + " = " + contactClassId;

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
            String sql = "SELECT COUNT(" + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] + ") FROM " + TBL_CONTACT_CLASS;
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
                    ContactClass contactclass = (ContactClass) list.get(ls);
                    if (oid == contactclass.getOID()) {
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

    public static int countClassAssign(int classType) {
        DBResultSet dbrs = null;
        try {
            String sql = ""
                    + " SELECT "
                    + "  COUNT(*) "
                    + " FROM "
                    + "  " + PstAnggota.TBL_ANGGOTA + " cl "
                    + "  JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " cca "
                    + "    ON cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID]
                    + "    = cl." + PstAnggota.fieldNames[PstAnggota.FLD_ID_ANGGOTA]
                    + "  JOIN " + PstContactClass.TBL_CONTACT_CLASS + " cc "
                    + "    ON cc." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]
                    + "    = cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID]
                    + " WHERE cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + classType + "' "
                    + "  AND DATE(cl.REG_DATE) = DATE(NOW())"
                    + "";

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
}
