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
public class PstFlowModulMapping extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_FLOWMODULMAPPING = "flow_modul_mapping";
    public static final int FLD_FLOW_MODUL_MAPPING_ID = 0;
    public static final int FLD_FLOW_MODUL_ID = 1;
    public static final int FLD_FIELD_NAME = 2;
    public static final int FLD_DATA_TYPE = 3;
    public static final int FLD_COLUMN_NAME = 4;
    public static final int FLD_DATA_EXAMPLE = 5;
    public static final int FLD_COLUMN_LEVEL = 6;
    public static final int FLD_TYPE = 7;
    public static final int FLD_INPUT_TYPE = 8;
    public static final int FLD_DATA_TABLE = 9;
    public static final int FLD_DATA_COLUMN = 10;
    public static final int FLD_DATA_VALUE = 11;

    public static String[] fieldNames = {
        "FLOW_MODUL_MAPPING_ID",
        "FLOW_MODUL_ID",
        "FIELD_NAME",
        "DATA_TYPE",
        "COLUMN_NAME",
        "DATA_EXAMPLE",
        "COLUMN_LEVEL",
        "TYPE",
        "INPUT_TYPE",
        "DATA_TABLE",
        "DATA_COLUMN",
        "DATA_VALUE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };
    
    public static final int TYPE_REGULAR = 0;
    public static final int TYPE_PRIMARY = 1;
    public static final int TYPE_FOREIGN = 2;
    
    public static String[] typeName = {
        "Regular",
        "Primary",
        "Foreign"
    };
    
    public static final int INPUT_TYPE_TEXT = 0;
    public static final int INPUT_TYPE_DATALIST_SELECTION = 1;
    public static final int INPUT_TYPE_TABLECOLUMN_SELECTION = 2;
    
    public static String[] inputTypeName = {
      "Text",
      "Select Custom Data",
      "Select From Another Table"
    };

    public PstFlowModulMapping() {
    }

    public PstFlowModulMapping(int i) throws DBException {
        super(new PstFlowModulMapping());
    }

    public PstFlowModulMapping(String sOid) throws DBException {
        super(new PstFlowModulMapping(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstFlowModulMapping(long lOid) throws DBException {
        super(new PstFlowModulMapping(0));
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
        return TBL_FLOWMODULMAPPING;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstFlowModulMapping().getClass().getName();
    }

    public static FlowModulMapping fetchExc(long oid) throws DBException {
        try {
            FlowModulMapping entFlowModulMapping = new FlowModulMapping();
            PstFlowModulMapping pstFlowModulMapping = new PstFlowModulMapping(oid);
            entFlowModulMapping.setOID(oid);
            entFlowModulMapping.setFlowModulId(pstFlowModulMapping.getLong(FLD_FLOW_MODUL_ID));
            entFlowModulMapping.setFieldName(pstFlowModulMapping.getString(FLD_FIELD_NAME));
            entFlowModulMapping.setDataType(pstFlowModulMapping.getInt(FLD_DATA_TYPE));
            entFlowModulMapping.setColumnName(pstFlowModulMapping.getString(FLD_COLUMN_NAME));
            entFlowModulMapping.setDataExample(pstFlowModulMapping.getString(FLD_DATA_EXAMPLE));
            entFlowModulMapping.setColumnLevel(pstFlowModulMapping.getInt(FLD_COLUMN_LEVEL));
            entFlowModulMapping.setType(pstFlowModulMapping.getInt(FLD_TYPE));
            entFlowModulMapping.setInputType(pstFlowModulMapping.getInt(FLD_INPUT_TYPE));
            entFlowModulMapping.setDataTable(pstFlowModulMapping.getString(FLD_DATA_TABLE));
            entFlowModulMapping.setDataColumn(pstFlowModulMapping.getString(FLD_DATA_COLUMN));
            entFlowModulMapping.setDataValue(pstFlowModulMapping.getString(FLD_DATA_VALUE));
            return entFlowModulMapping;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowModulMapping(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        FlowModulMapping entFlowModulMapping = fetchExc(entity.getOID());
        entity = (Entity) entFlowModulMapping;
        return entFlowModulMapping.getOID();
    }

    public static synchronized long updateExc(FlowModulMapping entFlowModulMapping) throws DBException {
        try {
            if (entFlowModulMapping.getOID() != 0) {
                PstFlowModulMapping pstFlowModulMapping = new PstFlowModulMapping(entFlowModulMapping.getOID());
                pstFlowModulMapping.setLong(FLD_FLOW_MODUL_ID, entFlowModulMapping.getFlowModulId());
                pstFlowModulMapping.setString(FLD_FIELD_NAME, entFlowModulMapping.getFieldName());
                pstFlowModulMapping.setInt(FLD_DATA_TYPE, entFlowModulMapping.getDataType());
                pstFlowModulMapping.setString(FLD_COLUMN_NAME, entFlowModulMapping.getColumnName());
                pstFlowModulMapping.setString(FLD_DATA_EXAMPLE, entFlowModulMapping.getDataExample());
                pstFlowModulMapping.setInt(FLD_COLUMN_LEVEL, entFlowModulMapping.getColumnLevel());
                pstFlowModulMapping.setInt(FLD_TYPE, entFlowModulMapping.getType());
                pstFlowModulMapping.setInt(FLD_INPUT_TYPE, entFlowModulMapping.getInputType());
                pstFlowModulMapping.setString(FLD_DATA_TABLE, entFlowModulMapping.getDataTable());
                pstFlowModulMapping.setString(FLD_DATA_COLUMN, entFlowModulMapping.getDataColumn());
                pstFlowModulMapping.setString(FLD_DATA_VALUE, entFlowModulMapping.getDataValue());
                pstFlowModulMapping.update();
                return entFlowModulMapping.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowModulMapping(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((FlowModulMapping) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstFlowModulMapping pstFlowModulMapping = new PstFlowModulMapping(oid);
            pstFlowModulMapping.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowModulMapping(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(FlowModulMapping entFlowModulMapping) throws DBException {
        try {
            PstFlowModulMapping pstFlowModulMapping = new PstFlowModulMapping(0);
            pstFlowModulMapping.setLong(FLD_FLOW_MODUL_ID, entFlowModulMapping.getFlowModulId());
            pstFlowModulMapping.setString(FLD_FIELD_NAME, entFlowModulMapping.getFieldName());
            pstFlowModulMapping.setInt(FLD_DATA_TYPE, entFlowModulMapping.getDataType());
            pstFlowModulMapping.setString(FLD_COLUMN_NAME, entFlowModulMapping.getColumnName());
            pstFlowModulMapping.setString(FLD_DATA_EXAMPLE, entFlowModulMapping.getDataExample());
            pstFlowModulMapping.setInt(FLD_COLUMN_LEVEL, entFlowModulMapping.getColumnLevel());
            pstFlowModulMapping.setInt(FLD_TYPE, entFlowModulMapping.getType());
            pstFlowModulMapping.setInt(FLD_INPUT_TYPE, entFlowModulMapping.getInputType());
            pstFlowModulMapping.setString(FLD_DATA_COLUMN, entFlowModulMapping.getDataColumn());
            pstFlowModulMapping.setString(FLD_DATA_TABLE, entFlowModulMapping.getDataTable());
            pstFlowModulMapping.setString(FLD_DATA_VALUE, entFlowModulMapping.getDataValue());
            pstFlowModulMapping.insert();
            entFlowModulMapping.setOID(pstFlowModulMapping.getlong(FLD_FLOW_MODUL_MAPPING_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstFlowModulMapping(0), DBException.UNKNOWN);
        }
        return entFlowModulMapping.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((FlowModulMapping) entity);
    }

    public static void resultToObject(ResultSet rs, FlowModulMapping entFlowModulMapping) {
        try {
            entFlowModulMapping.setOID(rs.getLong(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FLOW_MODUL_MAPPING_ID]));
            entFlowModulMapping.setFlowModulId(rs.getLong(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FLOW_MODUL_ID]));
            entFlowModulMapping.setFieldName(rs.getString(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FIELD_NAME]));
            entFlowModulMapping.setDataType(rs.getInt(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_DATA_TYPE]));
            entFlowModulMapping.setColumnName(rs.getString(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_COLUMN_NAME]));
            entFlowModulMapping.setDataExample(rs.getString(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_DATA_EXAMPLE]));
            entFlowModulMapping.setColumnLevel(rs.getInt(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_COLUMN_LEVEL]));
            entFlowModulMapping.setType(rs.getInt(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_TYPE]));
            entFlowModulMapping.setInputType(rs.getInt(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_INPUT_TYPE]));
            entFlowModulMapping.setDataTable(rs.getString(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_DATA_TABLE]));
            entFlowModulMapping.setDataColumn(rs.getString(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_DATA_COLUMN]));
            entFlowModulMapping.setDataValue(rs.getString(PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_DATA_VALUE]));
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
            String sql = "SELECT * FROM " + TBL_FLOWMODULMAPPING;
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
                FlowModulMapping entFlowModulMapping = new FlowModulMapping();
                resultToObject(rs, entFlowModulMapping);
                lists.add(entFlowModulMapping);
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

    public static boolean checkOID(long entFlowModulMappingId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_FLOWMODULMAPPING + " WHERE "
                    + PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FLOW_MODUL_MAPPING_ID] + " = " + entFlowModulMappingId;
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
            String sql = "SELECT COUNT(" + PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FLOW_MODUL_MAPPING_ID] + ") FROM " + TBL_FLOWMODULMAPPING;
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
                    FlowModulMapping entFlowModulMapping = (FlowModulMapping) list.get(ls);
                    if (oid == entFlowModulMapping.getOID()) {
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
    
    public static long getOidByFieldName(String fieldName, long oidFlow){
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT " + PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FLOW_MODUL_MAPPING_ID] + ""
                    + " FROM " + TBL_FLOWMODULMAPPING + " WHERE " 
                    + PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FIELD_NAME]
                    + " = '"+fieldName+"'"
                    + PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_FLOW_MODUL_ID]
                    + " = "+oidFlow;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            long oid = 0;
            while (rs.next()) {
                oid = rs.getLong(1);
            }
            rs.close();
            return oid;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
    public static FlowModulMapping getByNamaKolom(String namaKolom) {
        DBResultSet dbrs = null;
        //long empOid = 0;
        FlowModulMapping flowModulMapping = null;
        try {
            String sql = "SELECT * "
                    + " FROM " + TBL_FLOWMODULMAPPING
                    + " WHERE " + PstFlowModulMapping.fieldNames[PstFlowModulMapping.FLD_COLUMN_NAME] + " = '" + namaKolom + "'";

            //System.out.println("sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                flowModulMapping = new FlowModulMapping();
                resultToObject(rs, flowModulMapping);
            }

            rs.close();
            //return empOid;
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return flowModulMapping;
        }
    }
    
    public static String getDataListValue(String table, String column, String value, String caption){
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT " + value + ""
                    + " FROM " + table + " WHERE " 
                    + column
                    + " = '"+caption+"'";
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            String nilai = "";
            while (rs.next()) {
                nilai = rs.getString(1);
            }
            rs.close();
            return nilai;
        } catch (Exception e) {
            return "";
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    
}
