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

package com.dimata.common.entity.custom;

/* package java */
import java.io.*
;
import java.sql.*
;import java.util.*
;import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.util.*;
import com.dimata.common.db.*;
import com.dimata.qdep.entity.*;
import org.json.JSONObject;



public class PstDataCustom extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language, I_PersistentExcSynch {
    
    public static final  String TBL_DATA_CUSTOM = "data_custom";
    
    public static final  int FLD_DATA_CUSTOM_ID = 0;
    public static final  int FLD_OWNER_ID = 1;
    public static final  int FLD_DATA_NAME = 2;
    public static final  int FLD_LINK = 3;
    public static final  int FLD_DATA_VALUE = 4;
    
    public static final  String[] fieldNames = {
        "DATA_CUSTOM_ID",
        "OWNER_ID",
        "DATA_NAME",
        "LINK",
        "DATA_VALUE"
    };
    
    public static final  int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };
    
    public PstDataCustom(){
    }
    
    public PstDataCustom(int i) throws DBException {
        super(new PstDataCustom());
    }
    
    public PstDataCustom(String sOid) throws DBException {
        super(new PstDataCustom(0));
        if(!locate(sOid))
            throw new DBException(this,DBException.RECORD_NOT_FOUND);
        else
            return;
    }
    
    public PstDataCustom(long lOid) throws DBException {
        super(new PstDataCustom(0));
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
        return TBL_DATA_CUSTOM;
    }
    
    public String[] getFieldNames(){
        return fieldNames;
    }
    
    public int[] getFieldTypes(){
        return fieldTypes;
    }
    
    public String getPersistentName(){
        return new PstDataCustom().getClass().getName();
    }
    
    public long fetchExc(Entity ent) throws Exception{
        DataCustom datacustom = fetchExc(ent.getOID());
        ent = (Entity)datacustom;
        return datacustom.getOID();
    }
    
    public long insertExc(Entity ent) throws Exception{
        return insertExc((DataCustom) ent);
    }
    
    public long updateExc(Entity ent) throws Exception{
        return updateExc((DataCustom) ent);
    }
    
    public long deleteExc(Entity ent) throws Exception{
        if(ent==null){
            throw new DBException(this,DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }
    
    public static DataCustom fetchExc(long oid) throws DBException{
        try{
            DataCustom datacustom = new DataCustom();
            PstDataCustom pstDataCustom = new PstDataCustom(oid);
            datacustom.setOID(oid);
            
            datacustom.setOwnerId(pstDataCustom.getlong(FLD_OWNER_ID));
            datacustom.setDataName(pstDataCustom.getString(FLD_DATA_NAME));
            datacustom.setLink(pstDataCustom.getString(FLD_LINK));
            datacustom.setDataValue(pstDataCustom.getString(FLD_DATA_VALUE));
            
            return datacustom;
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstDataCustom(0),DBException.UNKNOWN);
        }
    }
    
    public static long insertExc(DataCustom datacustom) throws DBException{
        try{
            PstDataCustom pstDataCustom = new PstDataCustom(0);
            
            pstDataCustom.setLong(FLD_OWNER_ID, datacustom.getOwnerId());
            pstDataCustom.setString(FLD_DATA_NAME, datacustom.getDataName());
            pstDataCustom.setString(FLD_LINK, datacustom.getLink());
            pstDataCustom.setString(FLD_DATA_VALUE, datacustom.getDataValue());
            
            pstDataCustom.insert();
            datacustom.setOID(pstDataCustom.getlong(FLD_DATA_CUSTOM_ID));
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstDataCustom(0),DBException.UNKNOWN);
        }
        return datacustom.getOID();
    }
    
    public static long updateExc(DataCustom datacustom) throws DBException{
        try{
            if(datacustom.getOID() != 0){
                PstDataCustom pstDataCustom = new PstDataCustom(datacustom.getOID());
                
                pstDataCustom.setLong(FLD_OWNER_ID, datacustom.getOwnerId());
                pstDataCustom.setString(FLD_DATA_NAME, datacustom.getDataName());
                pstDataCustom.setString(FLD_LINK, datacustom.getLink());
                pstDataCustom.setString(FLD_DATA_VALUE, datacustom.getDataValue());
                
                pstDataCustom.update();
                return datacustom.getOID();
                
            }
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstDataCustom(0),DBException.UNKNOWN);
        }
        return 0;
    }
    
    public static long deleteExc(long oid) throws DBException{
        try{
            PstDataCustom pstDataCustom = new PstDataCustom(oid);
            pstDataCustom.delete();
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstDataCustom(0),DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_DATA_CUSTOM;
            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            if(order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;
            if(limitStart == 0 && recordToGet == 0)
                sql = sql + "";
            else
                sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
                DataCustom datacustom = new DataCustom();
                resultToObject(rs, datacustom);
                lists.add(datacustom);
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
    
    public static void resultToObject(ResultSet rs, DataCustom datacustom){
        try{
            datacustom.setOID(rs.getLong(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_CUSTOM_ID]));
            datacustom.setOwnerId(rs.getLong(PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID]));
            datacustom.setDataName(rs.getString(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_NAME]));
            datacustom.setLink(rs.getString(PstDataCustom.fieldNames[PstDataCustom.FLD_LINK]));
            datacustom.setDataValue(rs.getString(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_VALUE]));
            
        }catch(Exception e){ }
    }
    
    public static boolean checkOID(long dataCustomId){
        DBResultSet dbrs = null;
        boolean result = false;
        try{
            String sql = "SELECT * FROM " + TBL_DATA_CUSTOM + " WHERE " +
            PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_CUSTOM_ID] + " = " + dataCustomId;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) { result = true; }
            rs.close();
        }catch(Exception e){
            System.out.println("err : "+e.toString());
        }finally{
            DBResultSet.close(dbrs);
            return result;
        }
    }
    
    public static int getCount(String whereClause){
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT("+ PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_CUSTOM_ID] + ") FROM " + TBL_DATA_CUSTOM;
            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            int count = 0;
            while(rs.next()) { count = rs.getInt(1); }
            
            rs.close();
            return count;
        }catch(Exception e) {
            return 0;
        }finally {
            DBResultSet.close(dbrs);
        }
    }
    
    public static int deleteCustomDataExc(String whereClause){
        DBResultSet dbrs = null;
        try {
            String sql = "DELETE FROM "+TBL_DATA_CUSTOM;
            
            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
            
            System.out.println("delete custom data : "+sql);
            
            int result = DBHandler.execUpdate(sql);
            
            
        }catch(Exception e) {
            return 1;
        }finally {
            DBResultSet.close(dbrs);
            return 0;
        }
    }
    
    public static long insertDataCustom(long oidOwner, Vector vtCustom){
        try{
            if(vtCustom != null && vtCustom.size()>0){
                String where = PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID]+" = '"+oidOwner+"' AND "+
                PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_NAME]+" != 'LOCATION'";
                int result = PstDataCustom.deleteCustomDataExc(where);
                if(result == 0){
                    if(vtCustom!=null && vtCustom.size()>0){
                        for(int i=0;i<vtCustom.size();i++){
                            DataCustom dtCustom = (DataCustom)vtCustom.get(i);
                            dtCustom.setOwnerId(oidOwner);
                            insertExc(dtCustom);
                        }
                    }
                }
            }
        }catch(Exception e){
            System.out.println("error insert data custom : "+e.toString());
            return 0;
        }
        return oidOwner;
    }
    
    
    public static long insertDataCustomLocation(long oidOwner, Vector vtCustom){
        try{
            if(vtCustom != null && vtCustom.size()>0){
                String where = PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID]+" = '"+oidOwner+"' AND "+
                PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_NAME]+" = 'LOCATION'";
                int result = PstDataCustom.deleteCustomDataExc(where);
                if(result == 0){
                    if(vtCustom!=null && vtCustom.size()>0){
                        for(int i=0;i<vtCustom.size();i++){
                            DataCustom dtCustom = (DataCustom)vtCustom.get(i);
                            dtCustom.setOwnerId(oidOwner);
                            insertExc(dtCustom);
                        }
                    }
                }
            }
        }catch(Exception e){
            System.out.println("error insert data custom : "+e.toString());
            return 0;
        }
        return oidOwner;
    }
    
    public static Vector getDataCustom(long oidContact){
        DBResultSet dbrs = null;
        Vector vt = new Vector(1,1);
        try {
            String sql = "SELECT * FROM "+TBL_DATA_CUSTOM+
            " WHERE "+ PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID]+
            " = "+oidContact+ " ORDER BY "+fieldNames[FLD_DATA_NAME];
            
            System.out.println("sql : "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                DataCustom dataCustom = new DataCustom();
                resultToObject(rs,dataCustom);
                vt.add(dataCustom);
            }
            
            rs.close();
        }catch(Exception e) {
            System.out.println("Err get pass edit : "+e.toString());
            return new Vector(1,1);
        }finally {
            DBResultSet.close(dbrs);
            return vt;
        }
    }
    
    /**
     * @param oidOwner
     * @param sDataName
     * @return
     */    
    public static Vector getDataCustom(long oidOwner, String sDataName)
    {
        DBResultSet dbrs = null;
        Vector vt = new Vector(1,1);
        try 
        {
            String sql = "SELECT * FROM " + TBL_DATA_CUSTOM +
                         " WHERE " + PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID] + " = " + oidOwner + 
                         " AND " + PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_NAME] + " = '" + sDataName + "'" +                         
                         " ORDER BY " + PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_NAME];            

            System.out.println("PstDataCustom.getDataCustom() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();            
            while(rs.next()) 
            {
                DataCustom dataCustom = new DataCustom();
                resultToObject(rs,dataCustom);
                vt.add(dataCustom);
            }            
            rs.close();
        }
        catch(Exception e) 
        {
            System.out.println("Err get pass edit : "+e.toString());
            return new Vector(1,1);
        }
        finally 
        {
            DBResultSet.close(dbrs);
            return vt;
        }
    }
    
    public static boolean checkOwnerAndValue(long oidOwner, String sValue)
    {
        DBResultSet dbrs = null;
        boolean isExist = false;
        try 
        {
            String sql = "SELECT * FROM " + TBL_DATA_CUSTOM +
                         " WHERE " + PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID] + " = " + oidOwner + 
                         " AND " + PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_VALUE] + " = '" + sValue + "'";

            System.out.println("PstDataCustom.getDataCustom() : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();            
            while(rs.next()) 
            {
                isExist = true;
            }            
            rs.close();
        }
        catch(Exception e) 
        {
            System.out.println("Err get pass edit : "+e.toString());
            return isExist;
        }
        finally 
        {
            DBResultSet.close(dbrs);
            return isExist;
        }
    }

    public static DataCustom getDataCustomNew(long oidContact, String dataName){
        DBResultSet dbrs = null;
        Vector vt = new Vector(1,1);
        DataCustom dataCustom = new DataCustom();
        try {
            String sql = "SELECT * FROM "+TBL_DATA_CUSTOM+
                " WHERE "+ PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID]+
                " = "+oidContact+
                " AND "+PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_NAME]+"='"+dataName+"'"+
                " ORDER BY "+fieldNames[FLD_DATA_NAME];

            System.out.println("sql : "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while(rs.next()) {
                resultToObject(rs,dataCustom);
            }

            rs.close();
        }catch(Exception e) {
            System.out.println("Err get pass edit : "+e.toString());
            return new DataCustom();
        }finally {
            DBResultSet.close(dbrs);
            return dataCustom;
        }
    }


     public static DataCustom getDataCustom(long oidContact, String dataLink, String dataName){
        DBResultSet dbrs = null;
        Vector vt = new Vector(1,1);
        DataCustom dataCustom = new DataCustom();
        try {
            String sql = "SELECT * FROM "+TBL_DATA_CUSTOM+
                " WHERE "+ PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID]+
                " = "+oidContact+
                " AND "+PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_NAME]+"='"+dataName+"'"+
                    " AND "+PstDataCustom.fieldNames[PstDataCustom.FLD_LINK]+"='"+dataLink+"'"+
                " ORDER BY "+fieldNames[FLD_DATA_NAME];

            System.out.println("sql : "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while(rs.next()) {
                resultToObject(rs,dataCustom);
            }

            rs.close();
        }catch(Exception e) {
            System.out.println("Err get pass edit : "+e.toString());
            return new DataCustom();
        }finally {
            DBResultSet.close(dbrs);
            return dataCustom;
        }
    }

    /* This method used to find current data */
    public static int findLimitStart( long oid, int recordToGet, String whereClause, String orderClause){
        int size = getCount(whereClause);
        int start = 0;
        boolean found =false;
        for(int i=0; (i < size) && !found ; i=i+recordToGet){
            Vector list =  list(i,recordToGet, whereClause, orderClause);
            start = i;
            if(list.size()>0){
                for(int ls=0;ls<list.size();ls++){
                    DataCustom datacustom = (DataCustom)list.get(ls);
                    if(oid == datacustom.getOID())
                        found=true;
                }
            }
        }
        if((start >= size) && (size > 0))
            start = start - recordToGet;
        
        return start;
    }
    /* This method used to find command where current data */
    public static int findLimitCommand(int start, int recordToGet, int vectSize){
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + (recordToGet - mdl);
        if(start == 0)
            cmd =  Command.FIRST;
        else{
            if(start == (vectSize-recordToGet))
                cmd = Command.LAST;
            else{
                start = start + recordToGet;
                if(start <= (vectSize - recordToGet)){
                    cmd = Command.NEXT;
                    System.out.println("next.......................");
                }else{
                    start = start - recordToGet;
                    if(start > 0){
                        cmd = Command.PREV;
                        System.out.println("prev.......................");
                    }
                }
            }
        }
        
        return cmd;
    }
    
    /***  function for data synchronization ***/
    public long insertExcSynch(Entity ent) throws Exception{
        return insertExcSynch((DataCustom) ent);
    }
    public static long insertExcSynch(DataCustom dataCustom) throws DBException{
        long newOID = 0;
        long originalOID = dataCustom.getOID();
        try{
            newOID= insertExc(dataCustom);
            if(newOID!=0){  // sukses insert ?
                updateSynchOID(newOID, originalOID);
                return originalOID;
            }
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstDataCustom(0),DBException.UNKNOWN);
        }
        return 0;
    }
    
    public static long updateSynchOID(long newOID, long originalOID) throws DBException {
        DBResultSet dbrs = null;
        try { 
            String sql = "UPDATE " + TBL_DATA_CUSTOM + " SET " +
            PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_CUSTOM_ID] + " = " + originalOID +
            " WHERE " + PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_CUSTOM_ID] +
            " = " + newOID;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            rs.close();
            
            return originalOID;
        }catch(Exception e) {
            return 0;
        }finally {
            DBResultSet.close(dbrs);
        }
    }
    

  public static void resultToObjectJson(ResultSet rs, JSONObject obj) {
    try {
      obj.put(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_CUSTOM_ID], rs.getLong(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_CUSTOM_ID]));
      obj.put(PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID], rs.getLong(PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID]));
      obj.put(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_NAME], rs.getString(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_NAME]));
      obj.put(PstDataCustom.fieldNames[PstDataCustom.FLD_LINK], rs.getString(PstDataCustom.fieldNames[PstDataCustom.FLD_LINK]));
      obj.put(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_VALUE], rs.getString(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_VALUE]));
    } catch (Exception e) {
    }
  }

  public static void convertJsonToObject(JSONObject obj, DataCustom entDataCustom) {
    try {
      entDataCustom.setOID(obj.optLong(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_CUSTOM_ID]));
      entDataCustom.setOwnerId(obj.optLong(PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID]));
      entDataCustom.setDataName(obj.optString(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_NAME]));
      entDataCustom.setLink(obj.optString(PstDataCustom.fieldNames[PstDataCustom.FLD_LINK]));
      entDataCustom.setDataValue(obj.optString(PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_VALUE]));
    } catch (Exception e) {
    }
  }
    /*** -------------------------- ***/
    
}

