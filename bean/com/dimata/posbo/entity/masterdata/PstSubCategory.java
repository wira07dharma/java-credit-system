package com.dimata.posbo.entity.masterdata;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.posbo.db.*;
import com.dimata.qdep.entity.*;
import org.json.JSONObject;

public class PstSubCategory extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language
{

	//public static final  String TBL_SUB_CATEGORY = "POS_SUB_CATEGORY";
        public static final  String TBL_SUB_CATEGORY = "pos_sub_category";

	public static final  int FLD_SUB_CATEGORY_ID    = 0;
	public static final  int FLD_CATEGORY_ID        = 1;
	public static final  int FLD_CODE               = 2;
	public static final  int FLD_NAME               = 3;

	public static final  String[] fieldNames =
        {
            "SUB_CATEGORY_ID",
            "CATEGORY_ID",
            "CODE",
            "NAME"
	 };

	public static final  int[] fieldTypes =
        {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING
	 };


	public PstSubCategory(){
	}

	public PstSubCategory(int i) throws DBException {
		super(new PstSubCategory());
	}

	public PstSubCategory(String sOid) throws DBException {
		super(new PstSubCategory(0));
		if(!locate(sOid))
			throw new DBException(this,DBException.RECORD_NOT_FOUND);
		else
			return;
	}

	public PstSubCategory(long lOid) throws DBException {
		super(new PstSubCategory(0));
		String sOid = "0";
		try {
			sOid = String.valueOf(lOid);
		}catch(Exception e) {
			throw new DBException(this,DBException.RECORD_NOT_FOUND);
		}
		if(!locate(sOid))
			throw new DBException(this,DBException.RECORD_NOT_FOUND);
		else
			return;
	}

	public int getFieldSize(){
		return fieldNames.length;
	}

	public String getTableName(){
		return TBL_SUB_CATEGORY;
	}

	public String[] getFieldNames(){
		return fieldNames;
	}

	public int[] getFieldTypes(){
		return fieldTypes;
	}

	public String getPersistentName(){
		return new PstSubCategory().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception{
		SubCategory subCategory = fetchExc(ent.getOID());
		ent = (Entity)subCategory;
		return subCategory.getOID();
	}

	public long insertExc(Entity ent) throws Exception{
		return insertExc((SubCategory) ent);
	}

	public long updateExc(Entity ent) throws Exception{
		return updateExc((SubCategory) ent);
	}

	public long deleteExc(Entity ent) throws Exception{
		if(ent==null){
			throw new DBException(this,DBException.RECORD_NOT_FOUND);
		}
		return deleteExc(ent.getOID());
	}

	public static SubCategory fetchExc(long oid) throws DBException{
		try{
			SubCategory subCategory = new SubCategory();
			PstSubCategory pstSubCategory = new PstSubCategory(oid);
			subCategory.setOID(oid);

			subCategory.setCategoryId(pstSubCategory.getlong(FLD_CATEGORY_ID));
			subCategory.setCode(pstSubCategory.getString(FLD_CODE));
			subCategory.setName(pstSubCategory.getString(FLD_NAME));

			return subCategory;
		}catch(DBException dbe){
			throw dbe;
		}catch(Exception e){
			throw new DBException(new PstSubCategory(0),DBException.UNKNOWN);
		}
	}

	public static long insertExc(SubCategory subCategory) throws DBException{
		try{
			PstSubCategory pstSubCategory = new PstSubCategory(0);

			pstSubCategory.setLong(FLD_CATEGORY_ID, subCategory.getCategoryId());
			pstSubCategory.setString(FLD_CODE, subCategory.getCode());
			pstSubCategory.setString(FLD_NAME, subCategory.getName());

			pstSubCategory.insert();
                        long oidDataSync=PstDataSyncSql.insertExc(pstSubCategory.getInsertSQL());
                        PstDataSyncStatus.insertExc(oidDataSync);
			subCategory.setOID(pstSubCategory.getlong(FLD_SUB_CATEGORY_ID));
		}catch(DBException dbe){
			throw dbe;
		}catch(Exception e){
			throw new DBException(new PstSubCategory(0),DBException.UNKNOWN);
		}
		return subCategory.getOID();
	}

	public static long updateExc(SubCategory subCategory) throws DBException{
		try{
			if(subCategory.getOID() != 0){
				PstSubCategory pstSubCategory = new PstSubCategory(subCategory.getOID());

				pstSubCategory.setLong(FLD_CATEGORY_ID, subCategory.getCategoryId());
				pstSubCategory.setString(FLD_CODE, subCategory.getCode());
				pstSubCategory.setString(FLD_NAME, subCategory.getName());

				pstSubCategory.update();

                                long oidDataSync=PstDataSyncSql.insertExc(pstSubCategory.getUpdateSQL());
                                PstDataSyncStatus.insertExc(oidDataSync);
				return subCategory.getOID();
			}
		}catch(DBException dbe){
			throw dbe;
		}catch(Exception e){
			throw new DBException(new PstSubCategory(0),DBException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws DBException{
		try{
			PstSubCategory pstSubCategory = new PstSubCategory(oid);
			pstSubCategory.delete();

                        long oidDataSync = PstDataSyncSql.insertExc(pstSubCategory.getDeleteSQL());
                        PstDataSyncStatus.insertExc(oidDataSync);
		}catch(DBException dbe){
			throw dbe;
		}catch(Exception e){
			throw new DBException(new PstSubCategory(0),DBException.UNKNOWN);
		}
		return oid;
	}

	public static Vector listAll(){
		return list(0, 500, "","");
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector();
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + TBL_SUB_CATEGORY;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
            switch (DBHandler.DBSVR_TYPE) {
                case DBHandler.DBSVR_MYSQL :
						if(limitStart == 0 && recordToGet == 0)
							sql = sql + "";
						else
							sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;

                        break;

                 case DBHandler.DBSVR_POSTGRESQL :
						if(limitStart == 0 && recordToGet == 0)
							sql = sql + "";
						else
							sql = sql + " LIMIT " +recordToGet + " OFFSET "+ limitStart ;

                        break;

                 case DBHandler.DBSVR_SYBASE :
                    	break;

                 case DBHandler.DBSVR_ORACLE :
                    	break;

                 case DBHandler.DBSVR_MSSQL :
                    	break;

                default:
                    ;
            }
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				SubCategory subCategory = new SubCategory();
				resultToObject(rs, subCategory);
				lists.add(subCategory);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			DBResultSet.close(dbrs);
		}
			return new Vector();
	}

	//Overload function to make it work
        public static Vector list(int limitStart,int recordToGet)
        {
		Vector lists = new Vector();
		DBResultSet dbrs = null;
		try
                {
			String sql = "SELECT SC." + fieldNames[FLD_SUB_CATEGORY_ID] +
                            ", SC." + fieldNames[FLD_CODE] +
                            ", SC." + fieldNames[FLD_NAME] +
                            ", SC." + fieldNames[FLD_CATEGORY_ID] +
                            ", CAT." + PstCategory.fieldNames[PstCategory.FLD_NAME] +
                            " FROM " + PstCategory.TBL_CATEGORY +
                            " CAT INNER JOIN " + TBL_SUB_CATEGORY +
                            " SC ON CAT." + PstCategory.fieldNames[PstCategory.FLD_CATEGORY_ID] +
                            " = SC." + fieldNames[FLD_CATEGORY_ID];

                        sql += " ORDER BY CAT." + PstCategory.fieldNames[PstCategory.FLD_CODE] +
                               ", SC." + fieldNames[FLD_CODE];

                        switch (DBHandler.DBSVR_TYPE)
                        {
                            case DBHandler.DBSVR_MYSQL :
				if(limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
				else
                                    sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;

                                break;

                             case DBHandler.DBSVR_POSTGRESQL :
                                if(limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
                                else
                                    sql = sql + " LIMIT " +recordToGet + " OFFSET "+ limitStart ;
                                break;

                             case DBHandler.DBSVR_SYBASE :
                                break;

                             case DBHandler.DBSVR_ORACLE :
                                break;

                             case DBHandler.DBSVR_MSSQL :
                                break;

                            default:
                                ;
                        }
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next())
                        {
                            Vector temp = new Vector();
                            SubCategory subCategory = new SubCategory();
                            Category category = new Category();

                            subCategory.setOID(rs.getLong(1));
                            subCategory.setCode(rs.getString(2));
                            subCategory.setName(rs.getString(3));
                            subCategory.setCategoryId(rs.getLong(4));
                            temp.add(subCategory);

                            category.setName(rs.getString(5));
                            temp.add(category);

                            lists.add(temp);
			}
			rs.close();
			return lists;

		}
                catch(Exception e)
                {
			System.out.println(e);
		}
                finally
                {
			DBResultSet.close(dbrs);
		}
            return new Vector();
	}

	public static void resultToObject(ResultSet rs, SubCategory subCategory)
        {
		try
                {
                    subCategory.setOID(rs.getLong(PstSubCategory.fieldNames[PstSubCategory.FLD_SUB_CATEGORY_ID]));
                    subCategory.setCategoryId(rs.getLong(PstSubCategory.fieldNames[PstSubCategory.FLD_CATEGORY_ID]));
                    subCategory.setCode(rs.getString(PstSubCategory.fieldNames[PstSubCategory.FLD_CODE]));
                    subCategory.setName(rs.getString(PstSubCategory.fieldNames[PstSubCategory.FLD_NAME]));

		}
                catch(Exception e)
                { }
	}

	public static boolean checkOID(long subCategoryId){
		DBResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + TBL_SUB_CATEGORY + " WHERE " +
						 PstSubCategory.fieldNames[PstSubCategory.FLD_SUB_CATEGORY_ID] +
                         " = " + subCategoryId;
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			while(rs.next()) {
                result = true;
            }
			rs.close();
		}catch(Exception e){
			System.out.println("err : "+e.toString());
		}finally{
			DBResultSet.close(dbrs);
		}
		return result;
	}

	public static int getCount(String whereClause){
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ PstSubCategory.fieldNames[PstSubCategory.FLD_SUB_CATEGORY_ID] + ") FROM " +
                		 TBL_SUB_CATEGORY;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) {
                count = rs.getInt(1);
            }
			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			DBResultSet.close(dbrs);
		}
	}
        


   public static JSONObject fetchJSON(long oid){
      JSONObject object = new JSONObject();
      try {
         SubCategory subCategory = PstSubCategory.fetchExc(oid);
         object.put(PstSubCategory.fieldNames[PstSubCategory.FLD_SUB_CATEGORY_ID], subCategory.getOID());
         object.put(PstSubCategory.fieldNames[PstSubCategory.FLD_CATEGORY_ID], subCategory.getCategoryId());
         object.put(PstSubCategory.fieldNames[PstSubCategory.FLD_CODE], subCategory.getCode());
         object.put(PstSubCategory.fieldNames[PstSubCategory.FLD_NAME], subCategory.getName());
      }catch(Exception exc){}
      return object;
   }


   public static long syncExc(JSONObject jSONObject){
      long oid = 0;
      if (jSONObject != null){
       oid = jSONObject.optLong(PstSubCategory.fieldNames[PstSubCategory.FLD_SUB_CATEGORY_ID],0);
         if (oid > 0){
          SubCategory subCategory = new SubCategory();
          subCategory.setOID(jSONObject.optLong(PstSubCategory.fieldNames[PstSubCategory.FLD_SUB_CATEGORY_ID],0));
          subCategory.setCategoryId(jSONObject.optLong(PstSubCategory.fieldNames[PstSubCategory.FLD_CATEGORY_ID],0));
          subCategory.setCode(jSONObject.optString(PstSubCategory.fieldNames[PstSubCategory.FLD_CODE], ""));
          subCategory.setName(jSONObject.optString(PstSubCategory.fieldNames[PstSubCategory.FLD_NAME], ""));
          
          boolean checkOidSubCategory = PstSubCategory.checkOID(oid);
          try{
              if(checkOidSubCategory){
                  PstSubCategory.updateExc(subCategory);
              }else{
                  PstSubCategory.insertByOid(subCategory);
              }
          }catch(Exception exc){}
         }
      }
   return oid;
   }

   public static long insertByOid(SubCategory subCategory) throws DBException {
      try {
         PstSubCategory pstSubCategory = new PstSubCategory(0);
         pstSubCategory.setLong(FLD_SUB_CATEGORY_ID, subCategory.getOID());
         pstSubCategory.setLong(FLD_CATEGORY_ID, subCategory.getCategoryId());
         pstSubCategory.setString(FLD_CODE, subCategory.getCode());
         pstSubCategory.setString(FLD_NAME, subCategory.getName());
         pstSubCategory.insertByOid(subCategory.getOID());
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstSubCategory(0), DBException.UNKNOWN);
      }
      return subCategory.getOID();
   }
}
