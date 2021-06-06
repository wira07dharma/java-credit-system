/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.entity.excel;

import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;

/**
 *
 * @author Gunadi
 */
public class PstFlowModul extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_FLOW_MODUL = "flow_modul";
    public static final int FLD_FLOW_MODUL_ID = 0;
    public static final int FLD_FLOW_GROUP_ID = 1;
    public static final int FLD_FLOW_LEVEL = 2;
    public static final int FLD_FLOW_MODUL_NAME = 3;
    public static final int FLD_FLOW_MODUL_TABLE = 4;
    public static String[] fieldNames = {
        "FLOW_MODUL_ID",
        "FLOW_GROUP_ID",
        "FLOW_LEVEL",
        "FLOW_MODUL_NAME",
        "FLOW_MODUL_TABLE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING
    };

    public PstFlowModul() {
    }

    public PstFlowModul(int i) throws DBException {
        super(new PstFlowModul());
    }

    public PstFlowModul(String sOid) throws DBException {
        super(new PstFlowModul(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstFlowModul(long lOid) throws DBException {
        super(new PstFlowModul(0));
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
        return TBL_FLOW_MODUL;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstFlowModul().getClass().getName();
    }

    public static FlowModul fetchExc(long oid) throws DBException {
        try {
            FlowModul entFlowModul = new FlowModul();
            PstFlowModul pstFlowModul = new PstFlowModul(oid);
            entFlowModul.setOID(oid);
            entFlowModul.setFlowGroupId(pstFlowModul.getlong(FLD_FLOW_GROUP_ID));
            entFlowModul.setFlowLevel(pstFlowModul.getInt(FLD_FLOW_LEVEL));
            entFlowModul.setFlowModulName(pstFlowModul.getString(FLD_FLOW_MODUL_NAME));
            entFlowModul.setFlowModulTable(pstFlowModul.getString(FLD_FLOW_MODUL_TABLE));
            return entFlowModul;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowModul(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        FlowModul entFlowModul = fetchExc(entity.getOID());
        entity = (Entity) entFlowModul;
        return entFlowModul.getOID();
    }

    public static synchronized long updateExc(FlowModul entFlowModul) throws DBException {
        try {
            if (entFlowModul.getOID() != 0) {
                PstFlowModul pstFlowModul = new PstFlowModul(entFlowModul.getOID());
                pstFlowModul.setLong(FLD_FLOW_GROUP_ID, entFlowModul.getFlowGroupId());
                pstFlowModul.setInt(FLD_FLOW_LEVEL, entFlowModul.getFlowLevel());
                pstFlowModul.setString(FLD_FLOW_MODUL_NAME, entFlowModul.getFlowModulName());
                pstFlowModul.setString(FLD_FLOW_MODUL_TABLE, entFlowModul.getFlowModulTable());
                pstFlowModul.update();
                return entFlowModul.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowModul(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((FlowModul) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstFlowModul pstFlowModul = new PstFlowModul(oid);
            pstFlowModul.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowModul(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(FlowModul entFlowModul) throws DBException {
        try {
            PstFlowModul pstFlowModul = new PstFlowModul(0);
            pstFlowModul.setLong(FLD_FLOW_GROUP_ID, entFlowModul.getFlowGroupId());
            pstFlowModul.setInt(FLD_FLOW_LEVEL, entFlowModul.getFlowLevel());
            pstFlowModul.setString(FLD_FLOW_MODUL_NAME, entFlowModul.getFlowModulName());
            pstFlowModul.setString(FLD_FLOW_MODUL_TABLE, entFlowModul.getFlowModulTable());
            pstFlowModul.insert();
            entFlowModul.setOID(pstFlowModul.getlong(FLD_FLOW_MODUL_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowModul(0), DBException.UNKNOWN);
        }
        return entFlowModul.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((FlowModul) entity);
    }

    public static void resultToObject(ResultSet rs, FlowModul entFlowModul) {
        try {
            entFlowModul.setOID(rs.getLong(PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_ID]));
            entFlowModul.setFlowGroupId(rs.getLong(PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_GROUP_ID]));
            entFlowModul.setFlowLevel(rs.getInt(PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_LEVEL]));
            entFlowModul.setFlowModulName(rs.getString(PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_NAME]));
            entFlowModul.setFlowModulTable(rs.getString(PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_TABLE]));
        } catch (Exception e) {
        }
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_FLOW_MODUL;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                FlowModul entFlowModul = new FlowModul();
                resultToObject(rs, entFlowModul);
                lists.add(entFlowModul);
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
    
    public static Vector listJoinFlowGroup(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_FLOW_MODUL + " FL"
                    + " INNER JOIN "+PstFlowGroup.TBL_FLOW_GROUP+" FG"
                    + " ON FL."+fieldNames[FLD_FLOW_GROUP_ID]
                    + " = FG."+PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_GROUP_ID];
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                FlowModul entFlowModul = new FlowModul();
                resultToObject(rs, entFlowModul);
                lists.add(entFlowModul);
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

    public static boolean checkOID(long entFlowModulId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_FLOW_MODUL + " WHERE "
                    + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_ID] + " = " + entFlowModulId;
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
            String sql = "SELECT COUNT(" + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_ID] + ") FROM " + TBL_FLOW_MODUL
                    + " INNER JOIN "+PstFlowGroup.TBL_FLOW_GROUP+" FG"
                    + " ON FL."+fieldNames[FLD_FLOW_GROUP_ID]
                    + " = FG."+PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_GROUP_ID];
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
    
    public static int getCountJoinFlowGroup(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(FL." + PstFlowModul.fieldNames[PstFlowModul.FLD_FLOW_MODUL_ID] + ") FROM " + TBL_FLOW_MODUL+" FL";
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

    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    FlowModul entFlowModul = (FlowModul) list.get(ls);
                    if (oid == entFlowModul.getOID()) {
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

    public static int findLimitCommand(int start, int recordToGet, int vectSize) {
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + (recordToGet - mdl);
        if (start == 0) {
            cmd = Command.FIRST;
        } else {
            if (start == (vectSize - recordToGet)) {
                cmd = Command.LAST;
            } else {
                start = start + recordToGet;
                if (start <= (vectSize - recordToGet)) {
                    cmd = Command.NEXT;
                    System.out.println("next.......................");
                } else {
                    start = start - recordToGet;
                    if (start > 0) {
                        cmd = Command.PREV;
                        System.out.println("prev.......................");
                    }
                }
            }
        }
        return cmd;
    }
    
}

