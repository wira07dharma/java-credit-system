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
import java.util.Vector;

/**
 *
 * @author GUSWIK
 */
public class PstDocType extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

   public static final String TBL_HR_DOC_TYPE = "hr_doc_type";
   public static final int FLD_DOC_TYPE_ID = 0;
   public static final int FLD_TYPE_NAME = 1;
   public static final int FLD_DESCRIPTION = 2;
   
    public static final String[] fieldNames = {
     "DOC_TYPE_ID",
      "TYPE_NAME",
      "DESCRIPTION"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };

   public PstDocType() {
   }

    public PstDocType(int i) throws DBException {
        super(new PstDocType());
    }

    public PstDocType(String sOid) throws DBException {
        super(new PstDocType(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstDocType(long lOid) throws DBException {
        super(new PstDocType(0));
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
        return TBL_HR_DOC_TYPE;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstDocType().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        DocType docType = fetchExc(ent.getOID());
        ent = (Entity) docType;
        return docType.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((DocType) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((DocType) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static DocType fetchExc(long oid) throws DBException {
        try {
            DocType docType = new DocType();
            PstDocType pstDocType = new PstDocType(oid);
            docType.setOID(oid);

            docType.setType_name(pstDocType.getString(FLD_TYPE_NAME));
            docType.setDescription(pstDocType.getString(FLD_DESCRIPTION));

            return docType;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocType(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(DocType docType) throws DBException {
        try {
            PstDocType pstDocType = new PstDocType(0);

            pstDocType.setString(FLD_TYPE_NAME, docType.getType_name());
            pstDocType.setString(FLD_DESCRIPTION, docType.getDescription());
          
            pstDocType.insert();
            docType.setOID(pstDocType.getlong(FLD_DOC_TYPE_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocType(0), DBException.UNKNOWN);
        }
        return docType.getOID();
    }

    public static long updateExc(DocType docType) throws DBException {
        try {
            if (docType.getOID() != 0) {
                PstDocType pstDocType = new PstDocType(docType.getOID());

                pstDocType.setString(FLD_TYPE_NAME, docType.getType_name());
                pstDocType.setString(FLD_DESCRIPTION, docType.getDescription());;

                pstDocType.update();
                return docType.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocType(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstDocType pstDocType = new PstDocType(oid);
            pstDocType.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocType(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_HR_DOC_TYPE;
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
                DocType docType = new DocType();
                resultToObject(rs, docType);
                lists.add(docType);
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
    
      public static void resultToObject(ResultSet rs, DocType docType) {
        try {
            docType.setOID(rs.getLong(PstDocType.fieldNames[PstDocType.FLD_DOC_TYPE_ID]));
            docType.setType_name(rs.getString(PstDocType.fieldNames[PstDocType.FLD_TYPE_NAME]));
            docType.setDescription(rs.getString(PstDocType.fieldNames[PstDocType.FLD_DESCRIPTION]));
            
        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long docTypeId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_DOC_TYPE + " WHERE "
                    + PstDocType.fieldNames[PstDocType.FLD_DOC_TYPE_ID] + " = " + docTypeId;

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
            String sql = "SELECT COUNT(" + PstDocType.fieldNames[PstDocType.FLD_DOC_TYPE_ID] + ") FROM " + TBL_HR_DOC_TYPE;
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
                    DocType docType = (DocType) list.get(ls);
                    if (oid == docType.getOID()) {
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

  
}
