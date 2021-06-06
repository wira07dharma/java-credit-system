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
public class PstFlowMappingDataList extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_FLOWMAPPINGDATALIST = "flow_mapping_data_list";
    public static final int FLD_FLOW_MAPPING_DATA_LIST_ID = 0;
    public static final int FLD_FLOW_MAPPING_ID = 1;
    public static final int FLD_DATA_VALUE = 2;
    public static final int FLD_DATA_CAPTION = 3;
    public static String[] fieldNames = {
        "FLOW_MAPPING_DATA_LIST_ID",
        "FLOW_MAPPING_ID",
        "DATA_VALUE",
        "DATA_CAPTION"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING
    };

    public PstFlowMappingDataList() {
    }

    public PstFlowMappingDataList(int i) throws DBException {
        super(new PstFlowMappingDataList());
    }

    public PstFlowMappingDataList(String sOid) throws DBException {
        super(new PstFlowMappingDataList(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstFlowMappingDataList(long lOid) throws DBException {
        super(new PstFlowMappingDataList(0));
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
        return TBL_FLOWMAPPINGDATALIST;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstFlowMappingDataList().getClass().getName();
    }

    public static FlowMappingDataList fetchExc(long oid) throws DBException {
        try {
            FlowMappingDataList entFlowMappingDataList = new FlowMappingDataList();
            PstFlowMappingDataList pstFlowMappingDataList = new PstFlowMappingDataList(oid);
            entFlowMappingDataList.setOID(oid);
            entFlowMappingDataList.setFlowMappingId(pstFlowMappingDataList.getLong(FLD_FLOW_MAPPING_ID));
            entFlowMappingDataList.setDataValue(pstFlowMappingDataList.getString(FLD_DATA_VALUE));
            entFlowMappingDataList.setDataCaption(pstFlowMappingDataList.getString(FLD_DATA_CAPTION));
            return entFlowMappingDataList;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowMappingDataList(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        FlowMappingDataList entFlowMappingDataList = fetchExc(entity.getOID());
        entity = (Entity) entFlowMappingDataList;
        return entFlowMappingDataList.getOID();
    }

    public static synchronized long updateExc(FlowMappingDataList entFlowMappingDataList) throws DBException {
        try {
            if (entFlowMappingDataList.getOID() != 0) {
                PstFlowMappingDataList pstFlowMappingDataList = new PstFlowMappingDataList(entFlowMappingDataList.getOID());
                pstFlowMappingDataList.setLong(FLD_FLOW_MAPPING_ID, entFlowMappingDataList.getFlowMappingId());
                pstFlowMappingDataList.setString(FLD_DATA_VALUE, entFlowMappingDataList.getDataValue());
                pstFlowMappingDataList.setString(FLD_DATA_CAPTION, entFlowMappingDataList.getDataCaption());
                pstFlowMappingDataList.update();
                return entFlowMappingDataList.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowMappingDataList(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((FlowMappingDataList) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstFlowMappingDataList pstFlowMappingDataList = new PstFlowMappingDataList(oid);
            pstFlowMappingDataList.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowMappingDataList(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(FlowMappingDataList entFlowMappingDataList) throws DBException {
        try {
            PstFlowMappingDataList pstFlowMappingDataList = new PstFlowMappingDataList(0);
            pstFlowMappingDataList.setLong(FLD_FLOW_MAPPING_ID, entFlowMappingDataList.getFlowMappingId());
            pstFlowMappingDataList.setString(FLD_DATA_VALUE, entFlowMappingDataList.getDataValue());
            pstFlowMappingDataList.setString(FLD_DATA_CAPTION, entFlowMappingDataList.getDataCaption());
            pstFlowMappingDataList.insert();
            entFlowMappingDataList.setOID(pstFlowMappingDataList.getlong(FLD_FLOW_MAPPING_DATA_LIST_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowMappingDataList(0), DBException.UNKNOWN);
        }
        return entFlowMappingDataList.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((FlowMappingDataList) entity);
    }

    public static void resultToObject(ResultSet rs, FlowMappingDataList entFlowMappingDataList) {
        try {
            entFlowMappingDataList.setOID(rs.getLong(PstFlowMappingDataList.fieldNames[PstFlowMappingDataList.FLD_FLOW_MAPPING_DATA_LIST_ID]));
            entFlowMappingDataList.setFlowMappingId(rs.getLong(PstFlowMappingDataList.fieldNames[PstFlowMappingDataList.FLD_FLOW_MAPPING_ID]));
            entFlowMappingDataList.setDataValue(rs.getString(PstFlowMappingDataList.fieldNames[PstFlowMappingDataList.FLD_DATA_VALUE]));
            entFlowMappingDataList.setDataCaption(rs.getString(PstFlowMappingDataList.fieldNames[PstFlowMappingDataList.FLD_DATA_CAPTION]));
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
            String sql = "SELECT * FROM " + TBL_FLOWMAPPINGDATALIST;
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
                FlowMappingDataList entFlowMappingDataList = new FlowMappingDataList();
                resultToObject(rs, entFlowMappingDataList);
                lists.add(entFlowMappingDataList);
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

    public static boolean checkOID(long entFlowMappingDataListId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_FLOWMAPPINGDATALIST + " WHERE "
                    + PstFlowMappingDataList.fieldNames[PstFlowMappingDataList.FLD_FLOW_MAPPING_DATA_LIST_ID] + " = " + entFlowMappingDataListId;
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
            String sql = "SELECT COUNT(" + PstFlowMappingDataList.fieldNames[PstFlowMappingDataList.FLD_FLOW_MAPPING_DATA_LIST_ID] + ") FROM " + TBL_FLOWMAPPINGDATALIST;
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
                    FlowMappingDataList entFlowMappingDataList = (FlowMappingDataList) list.get(ls);
                    if (oid == entFlowMappingDataList.getOID()) {
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
    
    public static String getCustomDataListValue(String caption, long oidFlowMap){
        
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT " + fieldNames[FLD_DATA_VALUE]
                    + " FROM " + TBL_FLOWMAPPINGDATALIST + " WHERE " 
                    + fieldNames[FLD_DATA_CAPTION]
                    + " = '"+caption+"' AND "
                    + fieldNames[FLD_FLOW_MAPPING_ID]
                    + " = "+oidFlowMap;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            String value = "";
            while (rs.next()) {
                value = rs.getString(1);
            }
            rs.close();
            return value;
        } catch (Exception e) {
            return "";
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
}