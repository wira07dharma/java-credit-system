/* Created on 	:  [date] [time] AM/PM
 *
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ]
 * Imput Parameters 	: [input parameter ...]
 * Output 		: [output ...]
 *******************************************************************/

package com.dimata.posbo.entity.masterdata;

/* package java */

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.util.*;
import com.dimata.posbo.db.*;
import com.dimata.qdep.entity.*;

/* package garment */

import com.dimata.posbo.entity.masterdata.*;

//integrasi HANOMAN
import com.dimata.ObjLink.BOPos.CategoryLink;
import com.dimata.interfaces.BOPos.I_Category;
import org.json.JSONObject;

public class PstCategory extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language, I_Category {

    //public static final String TBL_CATEGORY = "POS_CATEGORY";
    public static final String TBL_CATEGORY = "pos_category";

    public static final int FLD_CATEGORY_ID = 0;
    public static final int FLD_CODE = 1;
    public static final int FLD_NAME = 2;
    public static final int FLD_POINT_PRICE = 3;
    public static final int FLD_DESCRIPTION = 4;

    public static final String[] fieldNames =
            {
                "CATEGORY_ID",
                "CODE",
                "NAME",
                "POINT_PRICE",
                "DESCRIPTION"
            };

    public static final int[] fieldTypes =
            {
                TYPE_LONG + TYPE_PK + TYPE_ID,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_FLOAT,
                TYPE_STRING
            };

    public PstCategory() {
    }

    public PstCategory(int i) throws DBException {
        super(new PstCategory());
    }

    public PstCategory(String sOid) throws DBException {
        super(new PstCategory(0));
        if (!locate(sOid))
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        else
            return;
    }

    public PstCategory(long lOid) throws DBException {
        super(new PstCategory(0));
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
        return TBL_CATEGORY;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstCategory().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Category category = fetchExc(ent.getOID());
        ent = (Entity) category;
        return category.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Category) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Category) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Category fetchExc(long oid) throws DBException {
        try {
            Category category = new Category();
            PstCategory pstCategory = new PstCategory(oid);
            category.setOID(oid);

            category.setCode(pstCategory.getString(FLD_CODE));
            category.setName(pstCategory.getString(FLD_NAME));
            category.setPointPrice(pstCategory.getdouble(FLD_POINT_PRICE));
            category.setDescription(pstCategory.getString(FLD_DESCRIPTION));
            return category;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCategory(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(Category category) throws DBException {
        try {
            PstCategory pstCategory = new PstCategory(0);

            pstCategory.setString(FLD_CODE, category.getCode());
            pstCategory.setString(FLD_NAME, category.getName());
            pstCategory.setDouble(FLD_POINT_PRICE, category.getPointPrice());
            pstCategory.setString(FLD_DESCRIPTION, category.getDescription());
            pstCategory.insert();

            long oidDataSync=PstDataSyncSql.insertExc(pstCategory.getInsertSQL());
            PstDataSyncStatus.insertExc(oidDataSync);

            category.setOID(pstCategory.getlong(FLD_CATEGORY_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCategory(0), DBException.UNKNOWN);
        }
        return category.getOID();
    }

    public static long updateExc(Category category) throws DBException {
        try {
            if (category.getOID() != 0) {
                PstCategory pstCategory = new PstCategory(category.getOID());

                pstCategory.setString(FLD_CODE, category.getCode());
                pstCategory.setString(FLD_NAME, category.getName());
                pstCategory.setDouble(FLD_POINT_PRICE, category.getPointPrice());
                pstCategory.setString(FLD_DESCRIPTION, category.getDescription());
                pstCategory.update();

                long oidDataSync=PstDataSyncSql.insertExc(pstCategory.getUpdateSQL());
                PstDataSyncStatus.insertExc(oidDataSync);

                return category.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCategory(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstCategory pstCategory = new PstCategory(oid);
            pstCategory.delete();
            long oidDataSync = PstDataSyncSql.insertExc(pstCategory.getDeleteSQL());
                PstDataSyncStatus.insertExc(oidDataSync);
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstCategory(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_CATEGORY;
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
                    ;
            }

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Category category = new Category();
                resultToObject(rs, category);
                lists.add(category);
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


    /**
     * list daftar category hastable
     * @return
     */
    public static Hashtable getListCategoryHastable() {
        Hashtable lists = new Hashtable();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_CATEGORY;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Category category = new Category();
                resultToObject(rs, category);
                lists.put(category.getCode().toUpperCase(), category);
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


    public static void resultToObject(ResultSet rs, Category category) {
        try {
            category.setOID(rs.getLong(PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID]));
            category.setCode(rs.getString(PstCategory.fieldNames[PstCategory.FLD_CODE]));
            category.setName(rs.getString(PstCategory.fieldNames[PstCategory.FLD_NAME]));
            category.setPointPrice(rs.getDouble(PstCategory.fieldNames[PstCategory.FLD_POINT_PRICE]));
            category.setDescription(rs.getString(PstCategory.fieldNames[PstCategory.FLD_DESCRIPTION]));
        } catch (Exception e) {
            System.out.println("error : " + e.toString());
        }
    }

    public static boolean checkOID(long categoryId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_CATEGORY + " WHERE " +
                    PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID] + " = " + categoryId;

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
            String sql = "SELECT COUNT(" + PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID] + ") FROM " + TBL_CATEGORY;
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
    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    Category category = (Category) list.get(ls);
                    if (oid == category.getOID())
                        found = true;
                }
            }
        }
        if ((start >= size) && (size > 0))
            start = start - recordToGet;

        return start;
    }

    /* This method used to find command where current data */
    public static int findLimitCommand(int start, int recordToGet, int vectSize) {
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + (recordToGet - mdl);
        if (start == 0)
            cmd = Command.FIRST;
        else {
            if (start == (vectSize - recordToGet))
                cmd = Command.LAST;
            else {
                start = start + recordToGet;
                if (start <= (vectSize - recordToGet)) {
                    cmd = Command.NEXT;
                    //System.out.println("next.......................");
                } else {
                    start = start - recordToGet;
                    if (start > 0) {
                        cmd = Command.PREV;
                        //System.out.println("prev.......................");
                    }
                }
            }
        }

        return cmd;
    }


    /**
     * this method uses in list in jsp
     */
    /*public static Vector getNestedCategory(long idDepartment, Vector result){
        try {
            String whereClause = PstCategory.fieldNames[PstCategory.FLD_DEPARTMENT_ID]+"="+idDepartment;
            Vector departments = PstCategory.list(0,0,whereClause,"");
            if((departments==null) || (departments.size()<1)) {
                return new Vector(1,1);
            }else{
                for(int pd=0; pd<departments.size(); pd++){
                    Category matDepartment = (Category)departments.get(pd);
                    idDepartment = matDepartment.getOID();
                    long parent = matDepartment.getParentId();
                    int indent = ifExist(result,parent);
                    matDepartment.setCode(indent +"/"+ matDepartment.getCode());
                    departments.setElementAt(matDepartment,0);
                    result.add(departments);
                    getNestedCategory(idDepartment,result);
                }
            }
            return result;
        }catch (Exception exc){
            return null;
        }
    }*/


    private static int ifExist(Vector result, long parent) {
        int indent = 0;
        for (int i = 0; i < result.size(); i++) {
            Vector temp = (Vector) result.get(i);
            Category category = (Category) temp.get(0);
            long oid = category.getOID();
            if (parent == oid) {
                String locCode = category.getCode();
                int idn = locCode.indexOf("/");
                int existIdn = 0;
                if (idn > 0)
                    existIdn = Integer.parseInt(locCode.substring(0, idn));
                indent = existIdn + 1;
            }
        }
        return indent;
    }


    //INTEGRASI HANOMAN
    //----------------------

    public long insertCategory(CategoryLink catLink) {
        Category ct = new Category();
        ct.setName(catLink.getName());
        ct.setCode(catLink.getName());

        try {
            long oid = PstCategory.insertExc(ct);
            return synchronizeOID(oid, catLink.getCategoryId());
        } catch (Exception e) {
        }

        return 0;
    }

    public long updateCategory(CategoryLink catLink) {
        Category ct = new Category();

        try {
            ct = PstCategory.fetchExc(catLink.getCategoryId());
            ct.setName(catLink.getName());

            return PstCategory.updateExc(ct);
        } catch (Exception e) {
        }

        return 0;
    }

    public long deleteCategory(CategoryLink catLink) {
        String where = PstMaterial.fieldNames[PstMaterial.FLD_CATEGORY_ID] + "=" + catLink.getCategoryId();
        Vector vct = PstMaterial.list(0, 0, where, null);
        if (vct != null && vct.size() > 0) {
            return 0;
        } else {
            try {
                PstCategory.deleteExc(catLink.getCategoryId());
            } catch (Exception e) {
            }
        }
        return catLink.getCategoryId();
    }

    public long synchronizeOID(long oldOID, long newOID) {
        String sql = "UPDATE " + TBL_CATEGORY +
                " SET " + fieldNames[FLD_CATEGORY_ID] + "=" + newOID +
                " WHERE " + fieldNames[FLD_CATEGORY_ID] + "=" + oldOID;
        try {
            DBHandler.execUpdate(sql);
        } catch (Exception e) {

        }

        return newOID;
    }

//    --- end
    public static long syncExc(JSONObject jSONObject){
            long oid = 0;
            if (jSONObject != null){
              oid = jSONObject.optLong(PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID],0);
              if (oid > 0){
                  Category category = new Category();
                  category.setOID(jSONObject.optLong(PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID],0));
                  category.setCode(jSONObject.optString(PstCategory.fieldNames[PstCategory.FLD_CODE],""));
                  category.setName(jSONObject.optString(PstCategory.fieldNames[PstCategory.FLD_NAME],""));
                  category.setDescription(jSONObject.optString(PstCategory.fieldNames[PstCategory.FLD_DESCRIPTION],""));
                  category.setPointPrice(jSONObject.optDouble(PstCategory.fieldNames[PstCategory.FLD_POINT_PRICE],0));
                  
                  boolean checkOidCategory = PstCategory.checkOID(oid);
                  try{
                      if(checkOidCategory){
                          PstCategory.updateExc(category);
                      }else{
                         PstCategory.insertByOid(category);
                      }
                  
                  }catch(Exception exc){}  
              }
            }
    return oid;
    }
    
       public static JSONObject fetchJSON(long oid){
      JSONObject object = new JSONObject();
      try {
         Category category = PstCategory.fetchExc(oid);
         object.put(PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID], category.getOID());
         object.put(PstCategory.fieldNames[PstCategory.FLD_CODE], category.getCode());
         object.put(PstCategory.fieldNames[PstCategory.FLD_NAME], category.getName());
         object.put(PstCategory.fieldNames[PstCategory.FLD_POINT_PRICE], category.getPointPrice());
         object.put(PstCategory.fieldNames[PstCategory.FLD_DESCRIPTION], category.getDescription());
      }catch(Exception exc){}
      return object;
   }

       
   public static long insertByOid(Category category) throws DBException {
      try {
         PstCategory pstCategory = new PstCategory(0);
         pstCategory.setLong(FLD_CATEGORY_ID, category.getOID());
         pstCategory.setString(FLD_CODE, category.getCode());
         pstCategory.setString(FLD_NAME, category.getName());
         pstCategory.setDouble(FLD_POINT_PRICE, category.getPointPrice());
         pstCategory.setString(FLD_DESCRIPTION, category.getDescription());
         pstCategory.insertByOid(category.getOID());
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstCategory(0), DBException.UNKNOWN);
      }
      return category.getOID();
   }


}
