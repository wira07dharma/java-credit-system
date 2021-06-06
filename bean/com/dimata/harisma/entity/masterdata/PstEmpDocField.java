/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.harisma.entity.masterdata;

import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.Entity;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author GUSWIK
 */
public class PstEmpDocField extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

   public static final String TBL_HR_EMP_DOC_FIELD = "hr_emp_doc_field";
   public static final int FLD_EMP_DOC_FIELD_ID = 0;
   public static final int FLD_OBJECT_NAME = 1;
   public static final int FLD_OBJECT_TYPE = 2;
   public static final int FLD_VALUE = 3;
   public static final int FLD_EMP_DOC_ID = 4;
   public static final int FLD_CLASS_NAME= 5;
   
    public static final String[] fieldNames = {
      "EMP_DOC_FIELD_ID",
      "OBJECT_NAME",
      "OBJECT_TYPE",
      "VALUE",
      "EMP_DOC_ID",
      "CLASS_NAME"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING
    };

   public PstEmpDocField() {
   }

    public PstEmpDocField(int i) throws DBException {
        super(new PstEmpDocField());
    }

    public PstEmpDocField(String sOid) throws DBException {
        super(new PstEmpDocField(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstEmpDocField(long lOid) throws DBException {
        super(new PstEmpDocField(0));
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
        return TBL_HR_EMP_DOC_FIELD;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstEmpDocField().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        EmpDocField empDocList = fetchExc(ent.getOID());
        ent = (Entity) empDocList;
        return empDocList.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((EmpDocField) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((EmpDocField) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static EmpDocField fetchExc(long oid) throws DBException {
        try {
            EmpDocField empDocField = new EmpDocField();
            PstEmpDocField pstEmpDocField = new PstEmpDocField(oid);
            empDocField.setOID(oid);

            empDocField.setEmp_doc_id(pstEmpDocField.getLong(FLD_EMP_DOC_ID));
            empDocField.setObject_name(pstEmpDocField.getString(FLD_OBJECT_NAME));
            empDocField.setObject_type(pstEmpDocField.getInt(FLD_OBJECT_TYPE));
            empDocField.setValue(pstEmpDocField.getString(FLD_VALUE));
            empDocField.setClassName(pstEmpDocField.getString(FLD_CLASS_NAME));

            return empDocField;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocField(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(EmpDocField empDocList) throws DBException {
        try {
            PstEmpDocField pstEmpDocField = new PstEmpDocField(0);
            pstEmpDocField.setLong(FLD_EMP_DOC_ID, empDocList.getEmp_doc_id());
            pstEmpDocField.setInt(FLD_OBJECT_TYPE, empDocList.getObject_type());
            pstEmpDocField.setString(FLD_OBJECT_NAME, empDocList.getObject_name());
            pstEmpDocField.setString(FLD_VALUE, empDocList.getValue());
            pstEmpDocField.setString(FLD_CLASS_NAME, empDocList.getClassName());
          
            pstEmpDocField.insert();
            empDocList.setOID(pstEmpDocField.getlong(FLD_EMP_DOC_FIELD_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocField(0), DBException.UNKNOWN);
        }
        return empDocList.getOID();
    }

    public static long updateExc(EmpDocField empDocList) throws DBException {
        try {
            if (empDocList.getOID() != 0) {
                PstEmpDocField pstEmpDocField = new PstEmpDocField(empDocList.getOID());

                pstEmpDocField.setLong(FLD_EMP_DOC_ID, empDocList.getEmp_doc_id());
                pstEmpDocField.setInt(FLD_OBJECT_TYPE, empDocList.getObject_type());
                pstEmpDocField.setString(FLD_OBJECT_NAME, empDocList.getObject_name());
                pstEmpDocField.setString(FLD_VALUE, empDocList.getValue());
                pstEmpDocField.setString(FLD_CLASS_NAME, empDocList.getClassName());
          

                pstEmpDocField.update();
                return empDocList.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocField(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstEmpDocField pstEmpDocField = new PstEmpDocField(oid);
            pstEmpDocField.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstEmpDocField(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_HR_EMP_DOC_FIELD;
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
                EmpDocField empDocList = new EmpDocField();
                
            empDocList.setOID(rs.getLong(PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_FIELD_ID]));
            empDocList.setEmp_doc_id(rs.getLong(PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID]));
            empDocList.setObject_type(rs.getInt(PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_TYPE]));
            empDocList.setValue(rs.getString(PstEmpDocField.fieldNames[PstEmpDocField.FLD_VALUE]));
            empDocList.setObject_name(rs.getString(PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME]));
            empDocList.setClassName(rs.getString(PstEmpDocField.fieldNames[PstEmpDocField.FLD_CLASS_NAME]));
                //resultToObject(rs, empDocList);
                lists.add(empDocList);
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
    
    
    public static Hashtable Hlist(int limitStart, int recordToGet, String whereClause, String order) {
        Hashtable lists = new Hashtable();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_HR_EMP_DOC_FIELD;
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
                EmpDocField empDocField = new EmpDocField();
                
            empDocField.setOID(rs.getLong(PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_FIELD_ID]));
            empDocField.setEmp_doc_id(rs.getLong(PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID]));
            empDocField.setObject_type(rs.getInt(PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_TYPE]));
            empDocField.setValue((rs.getString(PstEmpDocField.fieldNames[PstEmpDocField.FLD_VALUE])).equals("") ? "-" : (rs.getString(PstEmpDocField.fieldNames[PstEmpDocField.FLD_VALUE])) );
            empDocField.setObject_name(rs.getString(PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME]));
            empDocField.setClassName(rs.getString(PstEmpDocField.fieldNames[PstEmpDocField.FLD_CLASS_NAME]));
                //resultToObject(rs, empDocList);
                lists.put(empDocField.getObject_name(),empDocField.getValue());
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Hashtable();
    }
    
      public static void resultToObject(ResultSet rs, EmpDocField empDocList) {
        try {
             empDocList.setOID(rs.getLong(PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_FIELD_ID]));
            empDocList.setEmp_doc_id(rs.getLong(PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID]));
            empDocList.setObject_type(rs.getInt(PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_TYPE]));
            empDocList.setValue(rs.getString(PstEmpDocField.fieldNames[PstEmpDocField.FLD_VALUE]));
            empDocList.setObject_name(rs.getString(PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME]));
            empDocList.setClassName(rs.getString(PstEmpDocField.fieldNames[PstEmpDocField.FLD_CLASS_NAME]));
            
        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long empDocListId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_EMP_DOC_FIELD + " WHERE "
                    + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_FIELD_ID] + " = " + empDocListId;

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
            String sql = "SELECT COUNT(" + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_FIELD_ID] + ") FROM " + TBL_HR_EMP_DOC_FIELD;
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

      public static String getvalueByObjectnameEmpDocId(String objectName, long empDocId) {
        DBResultSet dbrs = null;
        String result = "";
        try {
            String sql = "SELECT " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_VALUE] + " FROM " + TBL_HR_EMP_DOC_FIELD + " WHERE "
                    + PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = " + empDocId;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getString(1);
                
            }
            rs.close();
            
            return result;
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }
      
    public static String getClassNameByObjectnameEmpDocId(String objectName, long empDocId) {
        DBResultSet dbrs = null;
        String result = "";
        try {
            String sql = "SELECT " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_CLASS_NAME] + " FROM " + TBL_HR_EMP_DOC_FIELD + " WHERE "
                    + PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME] + " = \"" + objectName + "\" AND " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = " + empDocId;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = rs.getString(1);
                
            }
            rs.close();
            
            return result;
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            DBResultSet.close(dbrs);
            return result;
        }
    }  
    
public static long deletewhere( long empDocId, String objekName) {
        DBResultSet dbrs = null;
        long resulthasil =0;
        try {
            String sql = "DELETE  FROM " + TBL_HR_EMP_DOC_FIELD + " WHERE "
                    + PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = " + empDocId
                    + " AND "+ PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME] + " = \"" + objekName+"\"";
            
            DBHandler.execSqlInsert(sql);
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
            
        } finally {
            DBResultSet.close(dbrs);
            return resulthasil;
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
                    EmpDocField empDocList = (EmpDocField) list.get(ls);
                    if (oid == empDocList.getOID()) {
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
    
    public static String getObject(long oidEmpDoc, String objectName) {
        String value = "";
        String whereStatus = PstEmpDocField.fieldNames[PstEmpDocField.FLD_EMP_DOC_ID] + " = " + oidEmpDoc +
                             " AND " + PstEmpDocField.fieldNames[PstEmpDocField.FLD_OBJECT_NAME]+ " = '" + objectName + "'";
        Vector fieldList = PstEmpDocField.list(0, 0, whereStatus, "");
        String startDate = "";
        String endDate = "";
        if (fieldList != null & fieldList.size() > 0){
            for (int i = 0; i < fieldList.size(); i++){
                EmpDocField empDocField = (EmpDocField) fieldList.get(i);
                value = empDocField.getValue();
            }
        }
        
        return value;
    }

  
}
