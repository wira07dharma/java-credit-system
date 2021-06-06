/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

/**
 *
 * @author Hendra McHen
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

public class PstCustomFieldMaster extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_CUSTOM_FIELD_MASTER = "hr_custom_field_master";
    public static final int FLD_CUSTOM_FIELD_ID = 0;
    public static final int FLD_FIELD_NAME = 1;
    public static final int FLD_FIELD_TYPE = 2;
    public static final int FLD_REQUIRED = 3;
    public static final int FLD_DATA_LIST = 4;
    public static final int FLD_INPUT_TYPE = 5;
    public static final int FLD_SHOW_FIELD = 6;
    public static final int FLD_NOTE = 7;
    public static final int FLD_FULL_ACCESS = 8;
    public static final int FLD_MODUL = 9;
    public static final int FLD_MODUL_FIELD = 10;
    public static final int FLD_MODUL_FIELD_VALUE = 11;

    public static String[] fieldNames = {
        "CUSTOM_FIELD_ID",
        "FIELD_NAME",
        "FIELD_TYPE",
        "REQUIRED",
        "DATA_LIST",
        "INPUT_TYPE",
        "SHOW_FIELD",
        "NOTE",
        "FULL_ACCESS",
        "MODUL",
        "MODUL_FIELD",
        "MODUL_FIELD_VALUE"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING
    };
    
    public static final int MODUL_AGUNAN  = 0;
        public static final int FIELD_NONE = 0;
        public static final int FIELD_TIPE_AGUNAN  = 1;
        
    public static final String[] modulName = {
        "Agunan"
    };
    
    public static final String[][] namaField = {
        {"-","Tipe Agunan"}
    };

    public PstCustomFieldMaster() {
    }

    public PstCustomFieldMaster(int i) throws DBException {
        super(new PstCustomFieldMaster());
    }

    public PstCustomFieldMaster(String sOid) throws DBException {
        super(new PstCustomFieldMaster(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstCustomFieldMaster(long lOid) throws DBException {
        super(new PstCustomFieldMaster(0));
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
        return TBL_CUSTOM_FIELD_MASTER;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCustomFieldMaster().getClass().getName();
    }

    public static CustomFieldMaster fetchExc(long oid) throws DBException {
        try {
            CustomFieldMaster entCustomFieldMaster = new CustomFieldMaster();
            PstCustomFieldMaster pstCustomFieldMaster = new PstCustomFieldMaster(oid);
            entCustomFieldMaster.setOID(oid);
            entCustomFieldMaster.setFieldName(pstCustomFieldMaster.getString(FLD_FIELD_NAME));
            entCustomFieldMaster.setFieldType(pstCustomFieldMaster.getInt(FLD_FIELD_TYPE));
            entCustomFieldMaster.setRequired(pstCustomFieldMaster.getInt(FLD_REQUIRED));
            entCustomFieldMaster.setDataList(pstCustomFieldMaster.getString(FLD_DATA_LIST));
            entCustomFieldMaster.setInputType(pstCustomFieldMaster.getInt(FLD_INPUT_TYPE));
            entCustomFieldMaster.setShowField(pstCustomFieldMaster.getString(FLD_SHOW_FIELD));
            entCustomFieldMaster.setNote(pstCustomFieldMaster.getString(FLD_NOTE));
            entCustomFieldMaster.setFullAccess(pstCustomFieldMaster.getInt(FLD_FULL_ACCESS));
            entCustomFieldMaster.setModul(pstCustomFieldMaster.getInt(FLD_MODUL));
            entCustomFieldMaster.setModulField(pstCustomFieldMaster.getInt(FLD_MODUL_FIELD));
            entCustomFieldMaster.setModulFieldValue(pstCustomFieldMaster.getString(FLD_MODUL_FIELD_VALUE));
            return entCustomFieldMaster;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCustomFieldMaster(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        CustomFieldMaster entCustomFieldMaster = fetchExc(entity.getOID());
        entity = (Entity) entCustomFieldMaster;
        return entCustomFieldMaster.getOID();
    }

    public static synchronized long updateExc(CustomFieldMaster entCustomFieldMaster) throws DBException {
        try {
            if (entCustomFieldMaster.getOID() != 0) {
                PstCustomFieldMaster pstCustomFieldMaster = new PstCustomFieldMaster(entCustomFieldMaster.getOID());
                pstCustomFieldMaster.setString(FLD_FIELD_NAME, entCustomFieldMaster.getFieldName());
                pstCustomFieldMaster.setInt(FLD_FIELD_TYPE, entCustomFieldMaster.getFieldType());
                pstCustomFieldMaster.setInt(FLD_REQUIRED, entCustomFieldMaster.getRequired());
                pstCustomFieldMaster.setString(FLD_DATA_LIST, entCustomFieldMaster.getDataList());
                pstCustomFieldMaster.setInt(FLD_INPUT_TYPE, entCustomFieldMaster.getInputType());
                pstCustomFieldMaster.setString(FLD_SHOW_FIELD, entCustomFieldMaster.getShowField());
                pstCustomFieldMaster.setString(FLD_NOTE, entCustomFieldMaster.getNote());
                pstCustomFieldMaster.setInt(FLD_FULL_ACCESS, entCustomFieldMaster.getFullAccess());
                pstCustomFieldMaster.setInt(FLD_MODUL, entCustomFieldMaster.getModul());
                pstCustomFieldMaster.setInt(FLD_MODUL_FIELD, entCustomFieldMaster.getModulField());
                pstCustomFieldMaster.setString(FLD_MODUL_FIELD_VALUE, entCustomFieldMaster.getModulFieldValue());
                pstCustomFieldMaster.update();
                return entCustomFieldMaster.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCustomFieldMaster(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((CustomFieldMaster) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstCustomFieldMaster pstCustomFieldMaster = new PstCustomFieldMaster(oid);
            pstCustomFieldMaster.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCustomFieldMaster(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(CustomFieldMaster entCustomFieldMaster) throws DBException {
        try {
            PstCustomFieldMaster pstCustomFieldMaster = new PstCustomFieldMaster(0);
            pstCustomFieldMaster.setString(FLD_FIELD_NAME, entCustomFieldMaster.getFieldName());
            pstCustomFieldMaster.setInt(FLD_FIELD_TYPE, entCustomFieldMaster.getFieldType());
            pstCustomFieldMaster.setInt(FLD_REQUIRED, entCustomFieldMaster.getRequired());
            pstCustomFieldMaster.setString(FLD_DATA_LIST, entCustomFieldMaster.getDataList());
            pstCustomFieldMaster.setInt(FLD_INPUT_TYPE, entCustomFieldMaster.getInputType());
            pstCustomFieldMaster.setString(FLD_SHOW_FIELD, entCustomFieldMaster.getShowField());
            pstCustomFieldMaster.setString(FLD_NOTE, entCustomFieldMaster.getNote());
            pstCustomFieldMaster.setInt(FLD_FULL_ACCESS, entCustomFieldMaster.getFullAccess());
            pstCustomFieldMaster.setInt(FLD_MODUL, entCustomFieldMaster.getModul());
            pstCustomFieldMaster.setInt(FLD_MODUL_FIELD, entCustomFieldMaster.getModulField());
            pstCustomFieldMaster.setString(FLD_MODUL_FIELD_VALUE, entCustomFieldMaster.getModulFieldValue());
            pstCustomFieldMaster.insert();
            entCustomFieldMaster.setOID(pstCustomFieldMaster.getLong(FLD_CUSTOM_FIELD_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCustomFieldMaster(0), DBException.UNKNOWN);
        }
        return entCustomFieldMaster.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((CustomFieldMaster) entity);
    }

    public static void resultToObject(ResultSet rs, CustomFieldMaster entCustomFieldMaster) {
        try {
            entCustomFieldMaster.setOID(rs.getLong(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_CUSTOM_FIELD_ID]));
            entCustomFieldMaster.setFieldName(rs.getString(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_FIELD_NAME]));
            entCustomFieldMaster.setFieldType(rs.getInt(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_FIELD_TYPE]));
            entCustomFieldMaster.setRequired(rs.getInt(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_REQUIRED]));
            entCustomFieldMaster.setDataList(rs.getString(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_DATA_LIST]));
            entCustomFieldMaster.setInputType(rs.getInt(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_INPUT_TYPE]));
            entCustomFieldMaster.setShowField(rs.getString(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_SHOW_FIELD]));
            entCustomFieldMaster.setNote(rs.getString(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_NOTE]));
            entCustomFieldMaster.setFullAccess(rs.getInt(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_FULL_ACCESS]));
            entCustomFieldMaster.setModul(rs.getInt(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_MODUL]));
            entCustomFieldMaster.setModulField(rs.getInt(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_MODUL_FIELD]));
            entCustomFieldMaster.setModulFieldValue(rs.getString(PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_MODUL_FIELD_VALUE]));
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
            String sql = "SELECT * FROM " + TBL_CUSTOM_FIELD_MASTER;
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
                CustomFieldMaster entCustomFieldMaster = new CustomFieldMaster();
                resultToObject(rs, entCustomFieldMaster);
                lists.add(entCustomFieldMaster);
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

    public static boolean checkOID(long entCustomFieldMasterId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_CUSTOM_FIELD_MASTER + " WHERE "
                    + PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_CUSTOM_FIELD_ID] + " = " + entCustomFieldMasterId;
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
            String sql = "SELECT COUNT(" + PstCustomFieldMaster.fieldNames[PstCustomFieldMaster.FLD_CUSTOM_FIELD_ID] + ") FROM " + TBL_CUSTOM_FIELD_MASTER;
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
                    CustomFieldMaster entCustomFieldMaster = (CustomFieldMaster) list.get(ls);
                    if (oid == entCustomFieldMaster.getOID()) {
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
