
/* Created on 	:  [date] [time] AM/PM
 *
 * @author  	: karya
 * @version  	: 01
 */

/*******************************************************************
 * Class Description 	: [project description ... ]
 * Imput Parameters 	: [input parameter ...]
 * Output 		: [output ...]
 *******************************************************************/

package com.dimata.common.entity.location;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.common.db.*;
import com.dimata.qdep.entity.*;

/* package prochain */

import com.dimata.common.entity.location.*;
import com.dimata.common.entity.contact.*;

//integrasi cashier vs hanoman
//import com.dimata.ObjLink.BOPos.OutletLink;
//import com.dimata.interfaces.BOPos.I_Outlet;
//import com.dimata.common.entity.custom.*;

public class PstRack extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {
    
    //public static final  String TBL_P2_Rack = "Rack";
    public static final  String TBL_FNT_RACK = "fnt_rack";
    
    public static final  int FLD_RACK_ID = 0;
    public static final  int FLD_RACK_CODE = 1;
    public static final  int FLD_RACK_NAME = 2;
    public static final  int FLD_RACK_DESCRIPTION = 3;
    public static final  int FLD_LOCATION_ID = 4;
    
    
    
    public static final  String[] fieldNames = {
        "RACK_ID",
        "RACK_CODE",
        "RACK_NAME",
        "RACK_DESCRIPTION",
        "LOCATION_ID"
    };
    
    public static final  int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG + TYPE_FK
    };
    
    
    
    public PstRack(){
    }
    
    public PstRack(int i) throws DBException {
        super(new PstRack());
    }
    
    public PstRack(String sOid) throws DBException {
        super(new PstRack(0));
        if(!locate(sOid))
            throw new DBException(this,DBException.RECORD_NOT_FOUND);
        else
            return;
    }
    
    public PstRack(long lOid) throws DBException {
        super(new PstRack(0));
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
        return TBL_FNT_RACK;
    }
    
    public String[] getFieldNames(){
        return fieldNames;
    }
    
    public int[] getFieldTypes(){
        return fieldTypes;
    }
    
    public String getPersistentName(){
        return new PstRack().getClass().getName();
    }
    
    public long fetchExc(Entity ent) throws Exception{
        try{
            Rack rack = (Rack)ent;
            long oid = ent.getOID();
            PstRack pstRack = new PstRack(oid);
            rack.setOID(oid);
            
            rack.setRackCode(pstRack.getString(FLD_RACK_CODE));
            rack.setRackName(pstRack.getString(FLD_RACK_NAME));
            rack.setRackDescription(pstRack.getString(FLD_RACK_DESCRIPTION));
            rack.setLocationId(pstRack.getLong(FLD_LOCATION_ID).longValue());
                       
            return rack.getOID();
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstRack(0),DBException.UNKNOWN);
        }
    }
    
    public long insertExc(Entity ent) throws Exception{
        return insertExc((Rack) ent);
    }
    
    public long updateExc(Entity ent) throws Exception{
        return updateExc((Rack) ent);
    }
    
    public long deleteExc(Entity ent) throws Exception{
        if(ent==null){
            throw new DBException(this,DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }
    
    public static Rack fetchExc(long oid) throws DBException{
        System.out.println("fetch start");
        try{
            Rack rack = new Rack();
            PstRack pstRack = new PstRack(oid);
            rack.setOID(oid);
            
            rack.setRackCode(pstRack.getString(FLD_RACK_CODE));
            rack.setRackName(pstRack.getString(FLD_RACK_NAME));
            rack.setRackDescription(pstRack.getString(FLD_RACK_DESCRIPTION));
            rack.setLocationId(pstRack.getlong(FLD_LOCATION_ID));
            System.out.println("fetch finish");            
            return rack;
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstRack(0),DBException.UNKNOWN);
        }
        
    }
    
    public static long insertExc(Rack rack) throws DBException{
        try{
            PstRack pstRack = new PstRack(0);
            
            pstRack.setString(FLD_RACK_CODE, rack.getRackCode());
            pstRack.setString(FLD_RACK_NAME, rack.getRackName());
            pstRack.setString(FLD_RACK_DESCRIPTION, rack.getRackDescription());
            pstRack.setLong(FLD_LOCATION_ID, rack.getLocationId());
                        
            pstRack.insert();
            rack.setOID(pstRack.getlong(FLD_RACK_ID));
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstRack(0),DBException.UNKNOWN);
        }
        return rack.getOID();
    }
    
    public static long updateExc(Rack rack) throws DBException{
        try{
            if(rack.getOID() != 0){
                PstRack pstRack = new PstRack(rack.getOID());
                
                pstRack.setString(FLD_RACK_CODE, rack.getRackCode());
                pstRack.setString(FLD_RACK_NAME, rack.getRackName());
                pstRack.setString(FLD_RACK_DESCRIPTION, rack.getRackDescription());
                pstRack.setLong(FLD_LOCATION_ID, rack.getLocationId());
                                
                pstRack.update();
                return rack.getOID();                
            }
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstRack(0),DBException.UNKNOWN);
        }
        return 0;
    }
    
    public static long deleteExc(long oid) throws DBException{
        try{
            PstRack pstRack = new PstRack(oid);
            pstRack.delete();
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstRack(0),DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_FNT_RACK;
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
                    if(limitStart == 0 && recordToGet == 0)
                        sql = sql + "";
                    else
                        sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
            }
            
            System.out.println("List sql : "+sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
                Rack rack = new Rack();
                resultToObject(rs, rack);
                lists.add(rack);
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
    
    public static void resultToObject(ResultSet rs, Rack rack){
        try{
            rack.setOID(rs.getLong(PstRack.fieldNames[PstRack.FLD_RACK_ID]));
            rack.setRackCode(rs.getString(PstRack.fieldNames[PstRack.FLD_RACK_CODE]));
            rack.setRackName(rs.getString(PstRack.fieldNames[PstRack.FLD_RACK_NAME]));
            rack.setRackDescription(rs.getString(PstRack.fieldNames[PstRack.FLD_RACK_DESCRIPTION]));
            rack.setLocationId(rs.getLong(PstRack.fieldNames[PstRack.FLD_LOCATION_ID]));
            
        }catch(Exception e){ }
    }
    
    public static boolean checkOID(long RackId){
        DBResultSet dbrs = null;
        boolean result = false;
        try{
            String sql = "SELECT * FROM " + TBL_FNT_RACK + " WHERE " +
            PstRack.fieldNames[PstRack.FLD_RACK_ID] + " = " + RackId;
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) { result = true; }
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
            String sql = "SELECT COUNT("+ PstRack.fieldNames[PstRack.FLD_RACK_ID] + ") FROM " + TBL_FNT_RACK;
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
    
    
    /* This method used to find current data */
    public static int findLimitStart( long oid, int recordToGet, String whereClause){
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found =false;
        for(int i=0; (i < size) && !found ; i=i+recordToGet){
            Vector list =  list(i,recordToGet, whereClause, order);
            start = i;
            if(list.size()>0){
                for(int ls=0;ls<list.size();ls++){
                    Rack rack = (Rack)list.get(ls);
                    if(oid == rack.getOID())
                        found=true;
                }
            }
        }
        if((start >= size) && (size > 0))
            start = start - recordToGet;
        
        return start;
    }
    
    public static void main (String[] args){
        try{
            Rack rack = PstRack.fetchExc(504404304545818519L);
        }catch(Exception e){e.printStackTrace();}
    }}