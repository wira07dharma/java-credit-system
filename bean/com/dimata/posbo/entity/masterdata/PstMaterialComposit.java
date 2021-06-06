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

public class PstMaterialComposit extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {
    
    //public static final  String TBL_MATERIAL_COMPOSIT = "POS_MATERIAL_COMPOSIT";
    public static final  String TBL_MATERIAL_COMPOSIT = "pos_material_composit";
    
    public static final  int FLD_MATERIAL_COMPOSIT_ID   = 0;
    public static final  int FLD_MATERIAL_ID            = 1;
    public static final  int FLD_MATERIAL_COMPOSER_ID   = 2;
    public static final  int FLD_UNIT_ID                = 3;
    public static final  int FLD_QTY                    = 4;
    
    public static final  String[] fieldNames = {
        "MATERIAL_COMPOSIT_ID",
        "MATERIAL_ID",
        "MATERIAL_COMPOSER_ID",
        "UNIT_ID",
        "QTY"
    };
    
    public static final  int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT
    };
    
    
    public PstMaterialComposit(){
    }
    
    public PstMaterialComposit(int i) throws DBException {
        super(new PstMaterialComposit());
    }
    
    public PstMaterialComposit(String sOid) throws DBException {
        super(new PstMaterialComposit(0));
        if(!locate(sOid))
            throw new DBException(this,DBException.RECORD_NOT_FOUND);
        else
            return;
    }
    
    public PstMaterialComposit(long lOid) throws DBException {
        super(new PstMaterialComposit(0));
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
        return TBL_MATERIAL_COMPOSIT;
    }
    
    public String[] getFieldNames(){
        return fieldNames;
    }
    
    public int[] getFieldTypes(){
        return fieldTypes;
    }
    
    public String getPersistentName(){
        return new PstMaterialComposit().getClass().getName();
    }
    
    public long fetchExc(Entity ent) throws Exception{
        MaterialComposit materialComposit = fetchExc(ent.getOID());
        ent = (Entity)materialComposit;
        return materialComposit.getOID();
    }
    
    public long insertExc(Entity ent) throws Exception{
        return insertExc((MaterialComposit) ent);
    }
    
    public long updateExc(Entity ent) throws Exception{
        return updateExc((MaterialComposit) ent);
    }
    
    public long deleteExc(Entity ent) throws Exception{
        if(ent==null){
            throw new DBException(this,DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }
    
    public static MaterialComposit fetchExc(long oid) throws DBException {
        try {
            MaterialComposit materialComposit = new MaterialComposit();
            PstMaterialComposit pstMaterialComposit = new PstMaterialComposit(oid);
            materialComposit.setOID(oid);
            
            materialComposit.setMaterialId(pstMaterialComposit.getlong(FLD_MATERIAL_ID));
            materialComposit.setMaterialComposerId(pstMaterialComposit.getlong(FLD_MATERIAL_COMPOSER_ID));
            materialComposit.setUnitId(pstMaterialComposit.getlong(FLD_UNIT_ID));
            materialComposit.setQty(pstMaterialComposit.getdouble(FLD_QTY));
            
            return materialComposit;
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstMaterialComposit(0),DBException.UNKNOWN);
        }
    }
    
    public static long insertExc(MaterialComposit materialComposit) throws DBException {
        try {
            PstMaterialComposit pstMaterialComposit = new PstMaterialComposit(0);
            
            pstMaterialComposit.setLong(FLD_MATERIAL_ID, materialComposit.getMaterialId());
            pstMaterialComposit.setLong(FLD_MATERIAL_COMPOSER_ID, materialComposit.getMaterialComposerId());
            pstMaterialComposit.setLong(FLD_UNIT_ID, materialComposit.getUnitId());
            pstMaterialComposit.setDouble(FLD_QTY, materialComposit.getQty());
            
            pstMaterialComposit.insert();

            long oidDataSync=PstDataSyncSql.insertExc(pstMaterialComposit.getInsertSQL());
            PstDataSyncStatus.insertExc(oidDataSync);
            materialComposit.setOID(pstMaterialComposit.getlong(FLD_MATERIAL_COMPOSIT_ID));
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstMaterialComposit(0),DBException.UNKNOWN);
        }
        return materialComposit.getOID();
    }
    
    public static long updateExc(MaterialComposit materialComposit) throws DBException{
        try{
            if(materialComposit.getOID() != 0){
                PstMaterialComposit pstMaterialComposit = new PstMaterialComposit(materialComposit.getOID());
                
                pstMaterialComposit.setLong(FLD_MATERIAL_ID, materialComposit.getMaterialId());
                pstMaterialComposit.setLong(FLD_MATERIAL_COMPOSER_ID, materialComposit.getMaterialComposerId());
                pstMaterialComposit.setLong(FLD_UNIT_ID, materialComposit.getUnitId());
                pstMaterialComposit.setDouble(FLD_QTY, materialComposit.getQty());
                
                pstMaterialComposit.update();

                long oidDataSync=PstDataSyncSql.insertExc(pstMaterialComposit.getUpdateSQL());
                PstDataSyncStatus.insertExc(oidDataSync);
                return materialComposit.getOID();
            }
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstMaterialComposit(0),DBException.UNKNOWN);
        }
        return 0;
    }
    
    public static long deleteExc(long oid) throws DBException {
        try {
            PstMaterialComposit pstMaterialComposit = new PstMaterialComposit(oid);
            pstMaterialComposit.delete();

            long oidDataSync = PstDataSyncSql.insertExc(pstMaterialComposit.getDeleteSQL());
                PstDataSyncStatus.insertExc(oidDataSync);
        }
        catch(DBException dbe) {
            System.out.println("DBE Exception : " + dbe);
            throw dbe;
        }
        catch(Exception e) {
            System.out.println("Exception : " + e);
            throw new DBException(new PstMaterialComposit(0),DBException.UNKNOWN);
        }
        return oid;
    }
    
    public static void deleteByMaterial(long oidMaterial) {
        DBResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + PstMaterialComposit.TBL_MATERIAL_COMPOSIT +
            " WHERE " + PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_ID] +
            " = " + oidMaterial;
            DBHandler.execUpdate(sql);

            long oidDataSync = PstDataSyncSql.insertExc(sql);
            PstDataSyncStatus.insertExc(oidDataSync);
        }
        catch(Exception e) {
            System.out.println("PstMaterialComposit.deleteByMaterial() err : "+e.toString());
        }
        finally {
            DBResultSet.close(dbrs);
        }
    }
    
    public static Vector listAll() {
        return list(0, 500, "","");
    }
    
    public static Vector list(int limitStart,int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT MC." + fieldNames[FLD_MATERIAL_COMPOSIT_ID] +
            ", MC." + fieldNames[FLD_MATERIAL_ID] +
            ", MC." + fieldNames[FLD_MATERIAL_COMPOSER_ID] +
            ", MC." + fieldNames[FLD_UNIT_ID] +
            ", MC." + fieldNames[FLD_QTY] +
            ", UN." + PstUnit.fieldNames[PstUnit.FLD_CODE] +
            " FROM (" + TBL_MATERIAL_COMPOSIT +
            " MC INNER JOIN " + PstUnit.TBL_P2_UNIT +
            " UN ON MC." + PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_UNIT_ID] +
            " = UN." + PstUnit.fieldNames[PstUnit.FLD_UNIT_ID] +
            " ) INNER JOIN " + PstMaterial.TBL_MATERIAL +
            " MAT ON MC." + PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSER_ID] +
            " = MAT." + PstMaterial.fieldNames[PstMaterial.FLD_MATERIAL_ID];
            
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
                Vector temp = new Vector();
                MaterialComposit materialComposit = new MaterialComposit();
                Unit unit = new Unit();
                
                materialComposit.setOID(rs.getLong(1));
                materialComposit.setMaterialId(rs.getLong(2));
                materialComposit.setMaterialComposerId(rs.getLong(3));
                materialComposit.setUnitId(rs.getLong(4));
                materialComposit.setQty(rs.getDouble(5));
                temp.add(materialComposit);
                
                unit.setCode(rs.getString(6));
                temp.add(unit);
                
                lists.add(temp);
            }
            rs.close();
            return lists;
            
        }
        catch(Exception e) {
            System.out.println(e);
        }
        finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }
    
    public static void resultToObject(ResultSet rs, MaterialComposit materialComposit) {
        try {
            materialComposit.setOID(rs.getLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSIT_ID]));
            materialComposit.setMaterialId(rs.getLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_ID]));
            materialComposit.setMaterialComposerId(rs.getLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSER_ID]));
            materialComposit.setUnitId(rs.getLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_UNIT_ID]));
            materialComposit.setQty(rs.getDouble(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_QTY]));
            
        }catch(Exception e){ }
    }
    
    public static boolean checkOID(long materialCompositId){
        DBResultSet dbrs = null;
        boolean result = false;
        try{
            String sql = "SELECT * FROM " + TBL_MATERIAL_COMPOSIT + " WHERE " +
            fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSIT_ID] +
            " = " + materialCompositId;
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
            String sql = "SELECT COUNT(MC."+ fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSIT_ID] + ") FROM " +
            TBL_MATERIAL_COMPOSIT + " MC";
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
         MaterialComposit materialComposit = PstMaterialComposit.fetchExc(oid);
         object.put(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSIT_ID], materialComposit.getOID());
         object.put(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_ID], materialComposit.getMaterialId());
         object.put(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSER_ID], materialComposit.getMaterialComposerId());
         object.put(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_UNIT_ID], materialComposit.getUnitId());
         object.put(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_QTY], materialComposit.getQty());
      }catch(Exception exc){}
      return object;
   }


   public static long syncExc(JSONObject jSONObject){
      long oid = 0;
      if (jSONObject != null){
       oid = jSONObject.optLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSIT_ID],0);
         if (oid > 0){
          MaterialComposit materialComposit = new MaterialComposit();
          materialComposit.setOID(jSONObject.optLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSIT_ID],0));
          materialComposit.setMaterialId(jSONObject.optLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_ID],0));
          materialComposit.setMaterialComposerId(jSONObject.optLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_MATERIAL_COMPOSER_ID],0));
          materialComposit.setUnitId(jSONObject.optLong(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_UNIT_ID],0));
          materialComposit.setQty(jSONObject.optDouble(PstMaterialComposit.fieldNames[PstMaterialComposit.FLD_QTY],0));
         boolean checkOidMaterialComposit = PstMaterialComposit.checkOID(oid);
          try{
            if(checkOidMaterialComposit){
               PstMaterialComposit.updateExc(materialComposit);
            }else{
               PstMaterialComposit.insertByOid(materialComposit);
            }
         }catch(Exception exc){}
         }
      }
   return oid;
   }  

   public static long insertByOid(MaterialComposit materialComposit) throws DBException {
      try {
         PstMaterialComposit pstMaterialComposit = new PstMaterialComposit(0);
         pstMaterialComposit.setLong(FLD_MATERIAL_COMPOSIT_ID, materialComposit.getOID());
         pstMaterialComposit.setLong(FLD_MATERIAL_ID, materialComposit.getMaterialId());
         pstMaterialComposit.setLong(FLD_MATERIAL_COMPOSER_ID, materialComposit.getMaterialComposerId());
         pstMaterialComposit.setLong(FLD_UNIT_ID, materialComposit.getUnitId());
         pstMaterialComposit.setDouble(FLD_QTY, materialComposit.getQty());
         pstMaterialComposit.insertByOid(materialComposit.getOID());
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstMaterialComposit(0), DBException.UNKNOWN);
      }
      return materialComposit.getOID();
   }
}
