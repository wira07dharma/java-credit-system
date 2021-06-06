/* Generated by Together */
package com.dimata.aiso.entity.jurnal;

// import from java
import java.sql.*;
import java.util.*;

import com.dimata.aiso.db.*;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.interfaces.journal.I_JournalType;
import com.dimata.aiso.entity.periode.PstPeriode;
import com.dimata.aiso.session.specialJournal.SessSpecialJurnal;

public class PstJurnalUmum extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_JournalType {

    public static final String TBL_JURNAL_UMUM = "aiso_jurnal_umum";
    public static final int FLD_JURNALID = 0;
    public static final int FLD_USERID = 1;
    public static final int FLD_PERIODEID = 2;
    public static final int FLD_TGLENTRY = 3;
    public static final int FLD_TGLTRANSAKSI = 4;
    public static final int FLD_KETERANGAN = 5;
    public static final int FLD_VOUCHER = 6;
    public static final int FLD_COUNTER = 7;
    public static final int FLD_BOOK_TYPE = 8;
    public static final int FLD_CURRENCY_TYPE = 9;
    public static final int FLD_REFERENCE_DOCUMENT = 10;
    public static final int FLD_JOURNAL_TYPE = 11;
    public static final int FLD_JOURNAL_NUMBER = 12;
    public static final int FLD_SHARE_TRANSACTION = 13;
    public static final int FLD_CONTACT_ID = 14;
    public static final int FLD_DEPARTMENT_ID = 15;
    public static String[] fieldNames =
            {
        "JURNAL_ID",
        "USER_ID",
        "PERIODE_ID",
        "TGL_ENTRY",
        "TGL_TRANSAKSI",
        "KETERANGAN",
        "NO_VOUCHER",
        "VOUCHER_COUNTER",
        "BOOK_TYPE",
        "CURRENCY_ID",
        "REFERENCE_DOCUMENT",
        "JOURNAL_TYPE",
        "JOURNAL_NUMBER",
        "SHARE_TRANSACTION",
        "CONTACT_ID",
        "DEPARTMENT_ID"
    };
    public static int[] fieldTypes =
            {
        TYPE_PK + TYPE_LONG + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG
    };
    public static final int DATASTATUS_CLEAN = 0;
    public static final int DATASTATUS_ADD = 1;
    public static final int DATASTATUS_UPDATE = 2;
    public static final int DATASTATUS_DELETE = 3;
    public static final int JOURNAL_NOT_SHARE = 0;
    public static final int JOURNAL_SHARE = 1;

    // constructor
    public PstJurnalUmum() {
    }

    public PstJurnalUmum(int i) throws DBException {
        super(new PstJurnalUmum());
    }

    public PstJurnalUmum(String sOid) throws DBException {
        super(new PstJurnalUmum(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstJurnalUmum(long lOid) throws DBException {
        super(new PstJurnalUmum(0));
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
        return TBL_JURNAL_UMUM;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstJurnalUmum().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        JurnalUmum jurnalumum = PstJurnalUmum.fetchExc(ent.getOID());
        ent = (Entity) jurnalumum;
        return jurnalumum.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return PstJurnalUmum.insertExc((JurnalUmum) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((JurnalUmum) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        return deleteExc((JurnalUmum) ent);
    }

    public static JurnalUmum fetchExc(long oid) throws DBException {
        try {
            JurnalUmum jurnalumum = new JurnalUmum();
            PstJurnalUmum pJurnalUmum = new PstJurnalUmum(oid);
            jurnalumum.setOID(oid);

            jurnalumum.setUserId(pJurnalUmum.getlong(FLD_USERID));
            jurnalumum.setPeriodeId(pJurnalUmum.getlong(FLD_PERIODEID));
            jurnalumum.setTglEntry(pJurnalUmum.getDate(FLD_TGLENTRY));
            jurnalumum.setTglTransaksi(pJurnalUmum.getDate(FLD_TGLTRANSAKSI));
            jurnalumum.setKeterangan(pJurnalUmum.getString(FLD_KETERANGAN));
            jurnalumum.setVoucherNo(pJurnalUmum.getString(FLD_VOUCHER));
            jurnalumum.setVoucherCounter(pJurnalUmum.getInt(FLD_COUNTER));
            jurnalumum.setBookType(pJurnalUmum.getInt(FLD_BOOK_TYPE));
            jurnalumum.setCurrType(pJurnalUmum.getlong(FLD_CURRENCY_TYPE));
            jurnalumum.setReferenceDoc(pJurnalUmum.getString(FLD_REFERENCE_DOCUMENT));
            jurnalumum.setJurnalType(pJurnalUmum.getInt(FLD_JOURNAL_TYPE));
            jurnalumum.setSJurnalNumber(pJurnalUmum.getString(FLD_JOURNAL_NUMBER));
            jurnalumum.setIShareTransaction(pJurnalUmum.getInt(FLD_SHARE_TRANSACTION));
            jurnalumum.setContactOid(pJurnalUmum.getlong(FLD_CONTACT_ID));
            jurnalumum.setDepartmentOid(pJurnalUmum.getlong(FLD_DEPARTMENT_ID));

            return jurnalumum;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstJurnalUmum(0), DBException.UNKNOWN);
        }
    }

    /**
     * this method used to generate pr code
     */
    private synchronized static String generateVoucherNumber(long periodId, java.util.Date transactionDate) {
        if (periodId != 0) {
            String result = "";
            int lastCounter = 0;
            String strPrefiks = generatePrefiksVoucher(transactionDate);
            if (PstPeriode.getCurrPeriodId() == periodId) {
                lastCounter = getLastCounter(periodId);
                //System.out.println("lastCounter :::::::::::::::::::::::: "+lastCounter);
                result = strPrefiks + "-" + intToStr((lastCounter + 1), 4);
            } else {
                result = strPrefiks + "-0001";
            }
            return result;
        } else {
            return "";
        }
    }

    /**
     * this method used to get prefiks Voucher Number 
     */
    private static String generatePrefiksVoucher(java.util.Date transactionDate) {
        return intToStr(transactionDate.getYear(), 2) + intToStr(transactionDate.getMonth() + 1, 2);
    }

    /**
     * this method used to generate String comparison of input int
     */
    private static String intToStr(int intToString, int maxLength) {
        String result = String.valueOf(intToString);
        if (result.length() < maxLength) {
            String temp = "";
            for (int i = 0; i < (maxLength - result.length()); i++) {
                temp = temp + "0";
            }
            result = temp + result;
        }

        if (result.length() > maxLength) {
            result = result.substring(result.length() - maxLength);
        }
        return result;
    }

    /**
     * this method used to get last counter (integer) from db
     */
    private synchronized static int getLastCounter(long periodId) {
        DBResultSet dbrs = null;
        int result = 0;
        try {
            String sql = "SELECT MAX(" + PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_COUNTER] + ") " +
                    " FROM " + PstJurnalUmum.TBL_JURNAL_UMUM +
                    " WHERE " + PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_PERIODEID] +
                    " = " + periodId;

            //System.out.println("SQL SessJurnal.getLastCounter ::::::::::::::::: "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("SessJurnalUmum.getLastCounter() err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }

    private synchronized static long insertExc(JurnalUmum jurnalumum) throws DBException {
        return insertExc(jurnalumum, null);
    }

    public synchronized static long insertExcGenerateVoucher(JurnalUmum jurnalumum) throws DBException {
        String strVoucher = generateVoucherNumber(jurnalumum.getPeriodeId(), jurnalumum.getTglTransaksi());
        String stVoucher = SessSpecialJurnal.getLocationCode() + "-" + strVoucher;
        jurnalumum.setSJurnalNumber(stVoucher);
        jurnalumum.setVoucherNo(strVoucher.substring(0, 4));
        jurnalumum.setVoucherCounter(Integer.parseInt(strVoucher.substring(5)));

        return insertExc(jurnalumum, null);
    }

    public synchronized static long insertExcGenerateVoucher(JurnalUmum jurnalumum, Connection con) throws DBException {
        String strVoucher = generateVoucherNumber(jurnalumum.getPeriodeId(), jurnalumum.getTglTransaksi());
        String stVoucher = SessSpecialJurnal.getLocationCode() + "-" + strVoucher;
        jurnalumum.setSJurnalNumber(stVoucher);
        jurnalumum.setVoucherNo(strVoucher.substring(0, 4));
        jurnalumum.setVoucherCounter(Integer.parseInt(strVoucher.substring(5)));

        try {
            PstJurnalUmum pJurnalUmum = new PstJurnalUmum(0);

            pJurnalUmum.setLong(FLD_USERID, jurnalumum.getUserId());
            pJurnalUmum.setLong(FLD_PERIODEID, jurnalumum.getPeriodeId());
            pJurnalUmum.setDate(FLD_TGLENTRY, jurnalumum.getTglEntry());
            pJurnalUmum.setDate(FLD_TGLTRANSAKSI, jurnalumum.getTglTransaksi());
            pJurnalUmum.setString(FLD_KETERANGAN, jurnalumum.getKeterangan());
            pJurnalUmum.setString(FLD_VOUCHER, jurnalumum.getVoucherNo());
            pJurnalUmum.setInt(FLD_COUNTER, jurnalumum.getVoucherCounter());
            pJurnalUmum.setLong(FLD_BOOK_TYPE, jurnalumum.getBookType());
            pJurnalUmum.setLong(FLD_CURRENCY_TYPE, jurnalumum.getCurrType());
            pJurnalUmum.setString(FLD_REFERENCE_DOCUMENT, jurnalumum.getReferenceDoc());
            pJurnalUmum.setInt(FLD_JOURNAL_TYPE, jurnalumum.getJurnalType());
            pJurnalUmum.setString(FLD_JOURNAL_NUMBER, jurnalumum.getSJurnalNumber());
            pJurnalUmum.setInt(FLD_SHARE_TRANSACTION, jurnalumum.getIShareTransaction());
            pJurnalUmum.setLong(FLD_CONTACT_ID, jurnalumum.getContactOid());
            pJurnalUmum.setLong(FLD_DEPARTMENT_ID, jurnalumum.getDepartmentOid());

            if (con == null) {
                pJurnalUmum.insert();
            } else {
                pJurnalUmum.insertTran(con);
            }
            jurnalumum.setOID(pJurnalUmum.getlong(FLD_JURNALID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstJurnalUmum(0), DBException.UNKNOWN);
        }
        return jurnalumum.getOID();
    }
    
    private synchronized static long insertExc(JurnalUmum jurnalumum, Connection con) throws DBException {
        try {
            PstJurnalUmum pJurnalUmum = new PstJurnalUmum(0);

            pJurnalUmum.setLong(FLD_USERID, jurnalumum.getUserId());
            pJurnalUmum.setLong(FLD_PERIODEID, jurnalumum.getPeriodeId());
            pJurnalUmum.setDate(FLD_TGLENTRY, jurnalumum.getTglEntry());
            pJurnalUmum.setDate(FLD_TGLTRANSAKSI, jurnalumum.getTglTransaksi());
            pJurnalUmum.setString(FLD_KETERANGAN, jurnalumum.getKeterangan());
            pJurnalUmum.setString(FLD_VOUCHER, jurnalumum.getVoucherNo());
            pJurnalUmum.setInt(FLD_COUNTER, jurnalumum.getVoucherCounter());
            pJurnalUmum.setLong(FLD_BOOK_TYPE, jurnalumum.getBookType());
            pJurnalUmum.setLong(FLD_CURRENCY_TYPE, jurnalumum.getCurrType());
            pJurnalUmum.setString(FLD_REFERENCE_DOCUMENT, jurnalumum.getReferenceDoc());
            pJurnalUmum.setInt(FLD_JOURNAL_TYPE, jurnalumum.getJurnalType());
            pJurnalUmum.setString(FLD_JOURNAL_NUMBER, jurnalumum.getSJurnalNumber());
            pJurnalUmum.setInt(FLD_SHARE_TRANSACTION, jurnalumum.getIShareTransaction());
            pJurnalUmum.setLong(FLD_CONTACT_ID, jurnalumum.getContactOid());
            pJurnalUmum.setLong(FLD_DEPARTMENT_ID, jurnalumum.getDepartmentOid());

            if (con == null) {
                pJurnalUmum.insert();
            } else {
                pJurnalUmum.insertTran(con);
            }
            jurnalumum.setOID(pJurnalUmum.getlong(FLD_JURNALID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstJurnalUmum(0), DBException.UNKNOWN);
        }
        return jurnalumum.getOID();
    }

    public static long updateExc(JurnalUmum jurnalumum) throws DBException {
        return updateExc(jurnalumum, null);
    }

    public static long updateExc(JurnalUmum jurnalumum, Connection con) throws DBException {
        try {
            if (jurnalumum.getOID() != 0) {
                PstJurnalUmum pJurnalUmum = new PstJurnalUmum(jurnalumum.getOID());

                pJurnalUmum.setLong(FLD_USERID, jurnalumum.getUserId());
                pJurnalUmum.setLong(FLD_PERIODEID, jurnalumum.getPeriodeId());
                pJurnalUmum.setDate(FLD_TGLENTRY, jurnalumum.getTglEntry());
                pJurnalUmum.setDate(FLD_TGLTRANSAKSI, jurnalumum.getTglTransaksi());
                pJurnalUmum.setString(FLD_KETERANGAN, jurnalumum.getKeterangan());
                pJurnalUmum.setString(FLD_VOUCHER, jurnalumum.getVoucherNo());
                pJurnalUmum.setInt(FLD_COUNTER, jurnalumum.getVoucherCounter());
                pJurnalUmum.setLong(FLD_BOOK_TYPE, jurnalumum.getBookType());
                pJurnalUmum.setLong(FLD_CURRENCY_TYPE, jurnalumum.getCurrType());
                pJurnalUmum.setString(FLD_REFERENCE_DOCUMENT, jurnalumum.getReferenceDoc());
                pJurnalUmum.setInt(FLD_JOURNAL_TYPE, jurnalumum.getJurnalType());
                pJurnalUmum.setString(FLD_JOURNAL_NUMBER, jurnalumum.getSJurnalNumber());
                pJurnalUmum.setInt(FLD_SHARE_TRANSACTION, jurnalumum.getIShareTransaction());
                pJurnalUmum.setLong(FLD_CONTACT_ID, jurnalumum.getContactOid());
                pJurnalUmum.setLong(FLD_DEPARTMENT_ID, jurnalumum.getDepartmentOid());

                if (con == null) {
                    pJurnalUmum.update();
                } else {
                    pJurnalUmum.updateTran(con);
                }
                return jurnalumum.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstJurnalUmum(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        return deleteExc(oid, null);
    }

    public static long deleteExc(long oid, Connection objConnection) throws DBException {
        try {
            PstJurnalUmum pJurnalUmum = new PstJurnalUmum(oid);
            if (objConnection == null) {
                pJurnalUmum.delete();
            } else {
                pJurnalUmum.deleteTran(objConnection);
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstJurnalUmum(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        try {
            String sql = "SELECT * FROM " + TBL_JURNAL_UMUM + " ";

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
                    break;
            }

            ResultSet rs = execQuery(sql);

            while (rs.next()) {
                JurnalUmum jurnalumum = new JurnalUmum();
                resultToObject(rs, jurnalumum);
                lists.add(jurnalumum);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(new PstJurnalUmum().getClass().getName() + ".list() exc : " + e.toString());
        }
        return new Vector();
    }

    public static void resultToObject(ResultSet rs, JurnalUmum jurnalumum) {
        try {
            jurnalumum.setOID(rs.getLong(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_JURNALID]));
            jurnalumum.setUserId(rs.getLong(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_USERID]));
            jurnalumum.setPeriodeId(rs.getLong(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_PERIODEID]));
            jurnalumum.setTglEntry(rs.getDate(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_TGLENTRY]));
            jurnalumum.setTglTransaksi(rs.getDate(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_TGLTRANSAKSI]));
            jurnalumum.setKeterangan(rs.getString(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_KETERANGAN]));
            jurnalumum.setVoucherNo(rs.getString(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_VOUCHER]));
            jurnalumum.setVoucherCounter(rs.getInt(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_COUNTER]));
            jurnalumum.setBookType(rs.getLong(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_BOOK_TYPE]));
            jurnalumum.setCurrType(rs.getLong(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_CURRENCY_TYPE]));
            jurnalumum.setReferenceDoc(rs.getString(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_REFERENCE_DOCUMENT]));
            jurnalumum.setJurnalType(rs.getInt(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_JOURNAL_TYPE]));
            jurnalumum.setSJurnalNumber(rs.getString(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_JOURNAL_NUMBER]));
            jurnalumum.setIShareTransaction(rs.getInt(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_SHARE_TRANSACTION]));
            jurnalumum.setContactOid(rs.getLong(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_CONTACT_ID]));
            jurnalumum.setDepartmentOid(rs.getLong(PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_DEPARTMENT_ID]));
        } catch (Exception e) {
            System.out.println("resultToObject() " + e.toString());
        }
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_JURNALID] + ") " +
                    " FROM " + TBL_JURNAL_UMUM;
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
            System.out.println(e);
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    /**
     * get vector journalId
     */
    public static Vector getVectJournalId(long periodId) {
        DBResultSet dbrs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = "SELECT " + PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_JURNALID] +
                    " FROM " + PstJurnalUmum.TBL_JURNAL_UMUM +
                    " WHERE " + PstJurnalUmum.fieldNames[PstJurnalUmum.FLD_PERIODEID] +
                    " = " + periodId;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result.add(String.valueOf(rs.getLong(1)));
            }
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return result;
    }

    /**
     * temporary method used to delete journal periodic
     */
    public static void deleteJournalPeriod(long periodId) {
        Vector result = getVectJournalId(periodId);
        if (result != null && result.size() > 0) {
            for (int i = 0; i < result.size(); i++) {
                long oid = Long.parseLong(String.valueOf(result.get(i)));
                try {
                    PstJurnalDetail.deleteByJurnalIDExc(oid);
                    PstJurnalUmum.deleteExc(oid);
                } catch (Exception e) {
                    System.out.println("Err : " + e.toString());
                }
            }
        }
    }
}
