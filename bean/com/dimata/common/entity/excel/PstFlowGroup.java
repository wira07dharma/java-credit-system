/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.common.entity.excel;

import com.dimata.common.entity.excel.FlowGroup;
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
public class PstFlowGroup extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_FLOW_GROUP = "flow_group";
    public static final int FLD_FLOW_GROUP_ID = 0;
    public static final int FLD_FLOW_GROUP_NAME = 1;
    public static final int FLD_FLOW_GROUP_DESCRIPTION = 2;
    public static String[] fieldNames = {
        "FLOW_GROUP_ID",
        "FLOW_GROUP_NAME",
        "FLOW_GROUP_DESCRIPTION"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };

    public PstFlowGroup() {
    }

    public PstFlowGroup(int i) throws DBException {
        super(new PstFlowGroup());
    }

    public PstFlowGroup(String sOid) throws DBException {
        super(new PstFlowGroup(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstFlowGroup(long lOid) throws DBException {
        super(new PstFlowGroup(0));
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
        return TBL_FLOW_GROUP;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstFlowGroup().getClass().getName();
    }

    public static FlowGroup fetchExc(long oid) throws DBException {
        try {
            FlowGroup entFlowGroup = new FlowGroup();
            PstFlowGroup pstFlowGroup = new PstFlowGroup(oid);
            entFlowGroup.setOID(oid);
            entFlowGroup.setFlowGroupName(pstFlowGroup.getString(FLD_FLOW_GROUP_NAME));
            entFlowGroup.setFlowGroupDescription(pstFlowGroup.getString(FLD_FLOW_GROUP_DESCRIPTION));
            return entFlowGroup;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowGroup(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        FlowGroup entFlowGroup = fetchExc(entity.getOID());
        entity = (Entity) entFlowGroup;
        return entFlowGroup.getOID();
    }

    public static synchronized long updateExc(FlowGroup entFlowGroup) throws DBException {
        try {
            if (entFlowGroup.getOID() != 0) {
                PstFlowGroup pstFlowGroup = new PstFlowGroup(entFlowGroup.getOID());
                pstFlowGroup.setString(FLD_FLOW_GROUP_NAME, entFlowGroup.getFlowGroupName());
                pstFlowGroup.setString(FLD_FLOW_GROUP_DESCRIPTION, entFlowGroup.getFlowGroupDescription());
                pstFlowGroup.update();
                return entFlowGroup.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowGroup(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((FlowGroup) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstFlowGroup pstFlowGroup = new PstFlowGroup(oid);
            pstFlowGroup.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowGroup(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(FlowGroup entFlowGroup) throws DBException {
        try {
            PstFlowGroup pstFlowGroup = new PstFlowGroup(0);
            pstFlowGroup.setString(FLD_FLOW_GROUP_NAME, entFlowGroup.getFlowGroupName());
            pstFlowGroup.setString(FLD_FLOW_GROUP_DESCRIPTION, entFlowGroup.getFlowGroupDescription());
            pstFlowGroup.insert();
            entFlowGroup.setOID(pstFlowGroup.getlong(FLD_FLOW_GROUP_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowGroup(0), DBException.UNKNOWN);
        }
        return entFlowGroup.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((FlowGroup) entity);
    }

    public static void resultToObject(ResultSet rs, FlowGroup entFlowGroup) {
        try {
            entFlowGroup.setOID(rs.getLong(PstFlowGroup.fieldNames[PstFlowGroup.FLD_FLOW_GROUP_ID]));
            entFlowGroup.setFlowGroupName(rs.getString(PstFlowGroup.fieldNames[PstFlowGroup.FLD_FLOW_GROUP_NAME]));
            entFlowGroup.setFlowGroupDescription(rs.getString(PstFlowGroup.fieldNames[PstFlowGroup.FLD_FLOW_GROUP_DESCRIPTION]));
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
            String sql = "SELECT * FROM " + TBL_FLOW_GROUP;
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
                FlowGroup entFlowGroup = new FlowGroup();
                resultToObject(rs, entFlowGroup);
                lists.add(entFlowGroup);
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

    public static boolean checkOID(long entFlowGroupId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_FLOW_GROUP + " WHERE "
                    + PstFlowGroup.fieldNames[PstFlowGroup.FLD_FLOW_GROUP_ID] + " = " + entFlowGroupId;
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
            String sql = "SELECT COUNT(" + PstFlowGroup.fieldNames[PstFlowGroup.FLD_FLOW_GROUP_ID] + ") FROM " + TBL_FLOW_GROUP;
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
                    FlowGroup entFlowGroup = (FlowGroup) list.get(ls);
                    if (oid == entFlowGroup.getOID()) {
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
