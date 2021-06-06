/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author Dimata 007
 */
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.Command;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

public class PstCustomFieldDataList extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_CUSTOM_FIELD_DATA_LIST = "hr_data_list_custom_field";
    public static final int FLD_CUSTOM_FIELD_DATA_LIST_ID = 0;
    public static final int FLD_DATA_LIST_CAPTION = 1;
    public static final int FLD_DATA_LIST_VALUE = 2;
    public static final int FLD_CUSTOM_FIELD_ID = 3;

    public static String[] fieldNames = {
        "CUSTOM_FIELD_DATA_LIST_ID",
        "DATA_LIST_CAPTION",
        "DATA_LIST_VALUE",
        "CUSTOM_FIELD_ID"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG
    };

    public PstCustomFieldDataList() {
    }

    public PstCustomFieldDataList(int i) throws DBException {
        super(new PstCustomFieldDataList());
    }

    public PstCustomFieldDataList(String sOid) throws DBException {
        super(new PstCustomFieldDataList(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstCustomFieldDataList(long lOid) throws DBException {
        super(new PstCustomFieldDataList(0));
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
        return TBL_CUSTOM_FIELD_DATA_LIST;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCustomFieldDataList().getClass().getName();
    }

    public static CustomFieldDataList fetchExc(long oid) throws DBException {
        try {
            CustomFieldDataList entCustomFieldDataList = new CustomFieldDataList();
            PstCustomFieldDataList pstCustomFieldDataList = new PstCustomFieldDataList(oid);
            entCustomFieldDataList.setOID(oid);
            entCustomFieldDataList.setDataListCaption(pstCustomFieldDataList.getString(FLD_DATA_LIST_CAPTION));
            entCustomFieldDataList.setDataListValue(pstCustomFieldDataList.getString(FLD_DATA_LIST_VALUE));
            entCustomFieldDataList.setCustomFieldId(pstCustomFieldDataList.getLong(FLD_CUSTOM_FIELD_ID));
            return entCustomFieldDataList;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCustomFieldDataList(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        CustomFieldDataList entCustomFieldDataList = fetchExc(entity.getOID());
        entity = (Entity) entCustomFieldDataList;
        return entCustomFieldDataList.getOID();
    }

    public static synchronized long updateExc(CustomFieldDataList entCustomFieldDataList) throws DBException {
        try {
            if (entCustomFieldDataList.getOID() != 0) {
                PstCustomFieldDataList pstCustomFieldDataList = new PstCustomFieldDataList(entCustomFieldDataList.getOID());
                pstCustomFieldDataList.setString(FLD_DATA_LIST_CAPTION, entCustomFieldDataList.getDataListCaption());
                pstCustomFieldDataList.setString(FLD_DATA_LIST_VALUE, entCustomFieldDataList.getDataListValue());
                pstCustomFieldDataList.setLong(FLD_CUSTOM_FIELD_ID, entCustomFieldDataList.getCustomFieldId());
                pstCustomFieldDataList.update();
                return entCustomFieldDataList.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCustomFieldDataList(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((CustomFieldDataList) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstCustomFieldDataList pstCustomFieldDataList = new PstCustomFieldDataList(oid);
            pstCustomFieldDataList.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCustomFieldDataList(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(CustomFieldDataList entCustomFieldDataList) throws DBException {
        try {
            PstCustomFieldDataList pstCustomFieldDataList = new PstCustomFieldDataList(0);
            pstCustomFieldDataList.setString(FLD_DATA_LIST_CAPTION, entCustomFieldDataList.getDataListCaption());
            pstCustomFieldDataList.setString(FLD_DATA_LIST_VALUE, entCustomFieldDataList.getDataListValue());
            pstCustomFieldDataList.setLong(FLD_CUSTOM_FIELD_ID, entCustomFieldDataList.getCustomFieldId());
            pstCustomFieldDataList.insert();
            entCustomFieldDataList.setOID(pstCustomFieldDataList.getlong(FLD_CUSTOM_FIELD_DATA_LIST_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCustomFieldDataList(0), DBException.UNKNOWN);
        }
        return entCustomFieldDataList.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((CustomFieldDataList) entity);
    }

    public static void resultToObject(ResultSet rs, CustomFieldDataList entCustomFieldDataList) {
        try {
            entCustomFieldDataList.setOID(rs.getLong(PstCustomFieldDataList.fieldNames[PstCustomFieldDataList.FLD_CUSTOM_FIELD_DATA_LIST_ID]));
            entCustomFieldDataList.setDataListCaption(rs.getString(PstCustomFieldDataList.fieldNames[PstCustomFieldDataList.FLD_DATA_LIST_CAPTION]));
            entCustomFieldDataList.setDataListValue(rs.getString(PstCustomFieldDataList.fieldNames[PstCustomFieldDataList.FLD_DATA_LIST_VALUE]));
            entCustomFieldDataList.setCustomFieldId(rs.getLong(PstCustomFieldDataList.fieldNames[PstCustomFieldDataList.FLD_CUSTOM_FIELD_ID]));
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
            String sql = "SELECT * FROM " + TBL_CUSTOM_FIELD_DATA_LIST;
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
                CustomFieldDataList entCustomFieldDataList = new CustomFieldDataList();
                resultToObject(rs, entCustomFieldDataList);
                lists.add(entCustomFieldDataList);
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

    public static boolean checkOID(long entCustomFieldDataListId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_CUSTOM_FIELD_DATA_LIST + " WHERE "
                    + PstCustomFieldDataList.fieldNames[PstCustomFieldDataList.FLD_CUSTOM_FIELD_DATA_LIST_ID] + " = " + entCustomFieldDataListId;
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
            String sql = "SELECT COUNT(" + PstCustomFieldDataList.fieldNames[PstCustomFieldDataList.FLD_CUSTOM_FIELD_DATA_LIST_ID] + ") FROM " + TBL_CUSTOM_FIELD_DATA_LIST;
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
                    CustomFieldDataList entCustomFieldDataList = (CustomFieldDataList) list.get(ls);
                    if (oid == entCustomFieldDataList.getOID()) {
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
