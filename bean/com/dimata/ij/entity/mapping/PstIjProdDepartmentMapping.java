/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.ij.entity.mapping;

// package java

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

// package qdep
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.entity.*;

// package ij
import com.dimata.ij.db.*;
import com.dimata.ij.entity.mapping.*;

/**
 *
 * @author Mirahu
 */


public class PstIjProdDepartmentMapping extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_IJ_MAP_PROD_DEPARTMENT = "ij_map_prod_department";

    public static final int FLD_IJ_MAP_PROD_DEPARTMENT_ID = 0;
    public static final int FLD_IJ_MAP_LOCATION_ID = 1;
    public static final int FLD_PROD_DEPARTMENT_ID = 2;
   

    public static final String[] fieldNames = {
        "IJ_MAP_PROD_DEPARTMENT_ID",
        "IJ_MAP_LOCATION_ID",
        "PROD_DEPARTMENT_ID"
    };

    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG
    };

    public PstIjProdDepartmentMapping() {
    }

    public PstIjProdDepartmentMapping(int i) throws DBException {
        super(new PstIjProdDepartmentMapping());
    }

    public PstIjProdDepartmentMapping(String sOid) throws DBException {
        super(new PstIjProdDepartmentMapping(0));
        if (!locate(sOid))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }

    public PstIjProdDepartmentMapping(long lOid) throws DBException {
        super(new PstIjProdDepartmentMapping(0));
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
        return TBL_IJ_MAP_PROD_DEPARTMENT;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstIjProdDepartmentMapping().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        IjProdDepartmentMapping ijProdDepartmentMapping = fetchExc(ent.getOID());
        ent = (Entity) ijProdDepartmentMapping;
        return ijProdDepartmentMapping.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((IjProdDepartmentMapping) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((IjProdDepartmentMapping) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static IjProdDepartmentMapping fetchExc(long oid) throws DBException {
        try {
            IjProdDepartmentMapping ijProdDepartmentMapping = new IjProdDepartmentMapping();
            PstIjProdDepartmentMapping pstIjProdDepartmentMapping = new PstIjProdDepartmentMapping(oid);
            ijProdDepartmentMapping.setOID(oid);

            ijProdDepartmentMapping.setIjMapLocationId(pstIjProdDepartmentMapping.getlong(FLD_IJ_MAP_LOCATION_ID));
            ijProdDepartmentMapping.setProdDepartmentId(pstIjProdDepartmentMapping.getlong(FLD_PROD_DEPARTMENT_ID));
          

            return ijProdDepartmentMapping;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstIjProdDepartmentMapping(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(IjProdDepartmentMapping ijProdDepartmentMapping) throws DBException {
        try {
            PstIjProdDepartmentMapping pstIjProdDepartmentMapping = new PstIjProdDepartmentMapping(0);

            pstIjProdDepartmentMapping.setLong(FLD_IJ_MAP_LOCATION_ID, ijProdDepartmentMapping.getIjMapLocationId());
            pstIjProdDepartmentMapping.setLong(FLD_PROD_DEPARTMENT_ID, ijProdDepartmentMapping.getProdDepartmentId());

            pstIjProdDepartmentMapping.insert();
            ijProdDepartmentMapping.setOID(pstIjProdDepartmentMapping.getlong(FLD_IJ_MAP_PROD_DEPARTMENT_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstIjProdDepartmentMapping(0), DBException.UNKNOWN);
        }
        return ijProdDepartmentMapping.getOID();
    }

    public static long updateExc(IjProdDepartmentMapping ijProdDepartmentMapping) throws DBException {
        try {
            if (ijProdDepartmentMapping.getOID() != 0) {
                PstIjProdDepartmentMapping pstIjProdDepartmentMapping = new PstIjProdDepartmentMapping(ijProdDepartmentMapping.getOID());

                pstIjProdDepartmentMapping.setLong(FLD_IJ_MAP_LOCATION_ID, ijProdDepartmentMapping.getIjMapLocationId());
                pstIjProdDepartmentMapping.setLong(FLD_PROD_DEPARTMENT_ID, ijProdDepartmentMapping.getProdDepartmentId());

                pstIjProdDepartmentMapping.update();
                return ijProdDepartmentMapping.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstIjProdDepartmentMapping(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstIjProdDepartmentMapping pstIjProdDepartmentMapping = new PstIjProdDepartmentMapping(oid);
            pstIjProdDepartmentMapping.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstIjProdDepartmentMapping(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_IJ_MAP_PROD_DEPARTMENT;
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
                    break;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                IjProdDepartmentMapping ijProdDepartmentMapping = new IjProdDepartmentMapping();
                resultToObject(rs, ijProdDepartmentMapping);
                lists.add(ijProdDepartmentMapping);
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

    private static void resultToObject(ResultSet rs, IjProdDepartmentMapping ijProdDepartmentMapping) {
        try {
            ijProdDepartmentMapping.setOID(rs.getLong(PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_IJ_MAP_PROD_DEPARTMENT_ID]));
            ijProdDepartmentMapping.setIjMapLocationId(rs.getLong(PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_IJ_MAP_LOCATION_ID]));
            ijProdDepartmentMapping.setProdDepartmentId(rs.getLong(PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_PROD_DEPARTMENT_ID]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long ijMapProdDepartmentId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_IJ_MAP_PROD_DEPARTMENT + " WHERE " +
                    PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_IJ_MAP_PROD_DEPARTMENT_ID] + " = " + ijMapProdDepartmentId;

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
            String sql = "SELECT COUNT(" + PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_IJ_MAP_PROD_DEPARTMENT_ID] + ") FROM " + TBL_IJ_MAP_PROD_DEPARTMENT;
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
                    IjProdDepartmentMapping ijProdDepartmentMapping = (IjProdDepartmentMapping) list.get(ls);
                    if (oid == ijProdDepartmentMapping.getOID())
                        found = true;
                }
            }
        }
        if ((start >= size) && (size > 0))
            start = start - recordToGet;

        return start;
    }


    /**
     * @param transactionType
     * @param transactionCurrency
     * @return
     * @created by Edhy
     */
    public static IjProdDepartmentMapping getObjIjProdDepartmentMapping(long transProdDept) {
        DBResultSet dbrs = null;
        IjProdDepartmentMapping objIjProdDepartmentMapping = new IjProdDepartmentMapping();
        try {
            String sql = "SELECT " + PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_IJ_MAP_PROD_DEPARTMENT_ID] +
                    ", " + PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_IJ_MAP_LOCATION_ID] +
                    ", " + PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_PROD_DEPARTMENT_ID] +
                    " FROM " + TBL_IJ_MAP_PROD_DEPARTMENT +
                    " WHERE " + PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_PROD_DEPARTMENT_ID] +
                    " = " + transProdDept;


            // System.out.println("-----------------------------> sql getObjIjProdDepartmentMapping : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                objIjProdDepartmentMapping.setOID(rs.getLong(PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_IJ_MAP_PROD_DEPARTMENT_ID]));
                objIjProdDepartmentMapping.setIjMapLocationId(rs.getLong(PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_IJ_MAP_LOCATION_ID]));
                objIjProdDepartmentMapping.setProdDepartmentId(rs.getLong(PstIjProdDepartmentMapping.fieldNames[PstIjProdDepartmentMapping.FLD_PROD_DEPARTMENT_ID]));
               
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
        }
        return objIjProdDepartmentMapping;

    }

}
