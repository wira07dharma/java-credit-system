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
public class PstDocMaster extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

   public static final String TBL_HR_DOC_MASTER = "hr_doc_master";
   public static final int FLD_DOC_MASTER_ID = 0;
   public static final int FLD_DOC_TYPE_ID = 1;
   public static final int FLD_DOC_TITLE = 2;
   public static final int FLD_DESCRIPTION = 3;
   public static final int FLD_DOC_NUMBER = 4;
   public static final int FLD_DOC_CODE = 5;
   
    public static final String[] fieldNames = {
      "DOC_MASTER_ID",
      "DOC_TYPE_ID",
      "DOC_TITLE",
      "DESCRIPTION",
      "DOC_NUMBER",
      "DOC_CODE"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };

   public PstDocMaster() {
   }

    public PstDocMaster(int i) throws DBException {
        super(new PstDocMaster());
    }

    public PstDocMaster(String sOid) throws DBException {
        super(new PstDocMaster(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstDocMaster(long lOid) throws DBException {
        super(new PstDocMaster(0));
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
        return TBL_HR_DOC_MASTER;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstDocMaster().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        DocMaster docMaster = fetchExc(ent.getOID());
        ent = (Entity) docMaster;
        return docMaster.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((DocMaster) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((DocMaster) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static DocMaster fetchExc(long oid) throws DBException {
        try {
            DocMaster docMaster = new DocMaster();
            PstDocMaster pstDocMaster = new PstDocMaster(oid);
            docMaster.setOID(oid);

            docMaster.setDoc_type_id(pstDocMaster.getlong(FLD_DOC_TYPE_ID));
            docMaster.setDoc_title(pstDocMaster.getString(FLD_DOC_TITLE));
            docMaster.setDescription(pstDocMaster.getString(FLD_DESCRIPTION));
            docMaster.setDoc_number(pstDocMaster.getString(FLD_DOC_NUMBER));
            docMaster.setDoc_code(pstDocMaster.getString(FLD_DOC_CODE));

            return docMaster;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMaster(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(DocMaster docMaster) throws DBException {
        try {
            PstDocMaster pstDocMaster = new PstDocMaster(0);

            pstDocMaster.setLong(FLD_DOC_TYPE_ID, docMaster.getDoc_type_id());
            pstDocMaster.setString(FLD_DOC_TITLE, docMaster.getDoc_title());
            pstDocMaster.setString(FLD_DESCRIPTION, docMaster.getDescription());
            pstDocMaster.setString(FLD_DOC_NUMBER, docMaster.getDoc_number());
            pstDocMaster.setString(FLD_DOC_CODE, docMaster.getDoc_code());
          
            pstDocMaster.insert();
            docMaster.setOID(pstDocMaster.getlong(FLD_DOC_MASTER_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMaster(0), DBException.UNKNOWN);
        }
        return docMaster.getOID();
    }

    public static long updateExc(DocMaster docMaster) throws DBException {
        try {
            if (docMaster.getOID() != 0) {
                PstDocMaster pstDocMaster = new PstDocMaster(docMaster.getOID());

                pstDocMaster.setLong(FLD_DOC_TYPE_ID, docMaster.getDoc_type_id());
                pstDocMaster.setString(FLD_DOC_TITLE, docMaster.getDoc_title());
                pstDocMaster.setString(FLD_DESCRIPTION, docMaster.getDescription());
                pstDocMaster.setString(FLD_DOC_NUMBER, docMaster.getDoc_number());
                pstDocMaster.setString(FLD_DOC_CODE, docMaster.getDoc_code());

                pstDocMaster.update();
                return docMaster.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMaster(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstDocMaster pstDocMaster = new PstDocMaster(oid);
            pstDocMaster.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstDocMaster(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_HR_DOC_MASTER;
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
                DocMaster docMaster = new DocMaster();
                resultToObject(rs, docMaster);
                lists.add(docMaster);
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
    
      public static void resultToObject(ResultSet rs, DocMaster docMaster) {
        try {
            docMaster.setOID(rs.getLong(PstDocMaster.fieldNames[PstDocMaster.FLD_DOC_MASTER_ID]));
            docMaster.setDoc_type_id(rs.getLong(PstDocMaster.fieldNames[PstDocMaster.FLD_DOC_TYPE_ID]));
            docMaster.setDoc_title(rs.getString(PstDocMaster.fieldNames[PstDocMaster.FLD_DOC_TITLE]));
            docMaster.setDescription(rs.getString(PstDocMaster.fieldNames[PstDocMaster.FLD_DESCRIPTION]));
            docMaster.setDoc_number(rs.getString(PstDocMaster.fieldNames[PstDocMaster.FLD_DOC_NUMBER]));
            docMaster.setDoc_code(rs.getString(PstDocMaster.fieldNames[PstDocMaster.FLD_DOC_CODE]));
            
        } catch (Exception e) {
        }
    }
    
    public static boolean checkOID(long docMasterId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_DOC_MASTER + " WHERE "
                    + PstDocMaster.fieldNames[PstDocMaster.FLD_DOC_MASTER_ID] + " = " + docMasterId;

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
            String sql = "SELECT COUNT(" + PstDocMaster.fieldNames[PstDocMaster.FLD_DOC_MASTER_ID] + ") FROM " + TBL_HR_DOC_MASTER;
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

    public static long getOidByCode(String docCode){
        long oid = 0;

        String whereClause = PstDocMaster.fieldNames[PstDocMaster.FLD_DOC_CODE] + " = '"+docCode+"'";
        Vector listDocMaster = PstDocMaster.list(0,0,whereClause,"");
        
        if (listDocMaster.size() > 0){
            DocMaster docMaster = (DocMaster) listDocMaster.get(0);
            oid = docMaster.getOID();
        }
        
        return oid;
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
                    DocMaster docMaster = (DocMaster) list.get(ls);
                    if (oid == docMaster.getOID()) {
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
