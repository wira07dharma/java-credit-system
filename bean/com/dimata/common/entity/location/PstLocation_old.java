
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

import java.sql.*;
import java.util.*;
import com.dimata.util.lang.I_Language;
import com.dimata.common.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.common.entity.location.*;
import com.dimata.common.entity.contact.*;

//integrasi cashier vs hanoman
//import com.dimata.ObjLink.BOPos.OutletLink;
import com.dimata.interfaces.BOPos.I_Outlet;
import com.dimata.common.entity.custom.*;

public class PstLocation_old extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language, I_PersistentExcSynch{
    
    //public static final  String TBL_P2_LOCATION = "LOCATION";
    public static final  String TBL_P2_LOCATION = "location";
    
    public static final  int FLD_LOCATION_ID = 0;
    public static final  int FLD_NAME = 1;
    public static final  int FLD_CONTACT_ID = 2;
    public static final  int FLD_DESCRIPTION = 3;
    public static final  int FLD_CODE = 4;
    public static final  int FLD_ADDRESS = 5;
    public static final  int FLD_TELEPHONE = 6;
    public static final  int FLD_FAX = 7;
    public static final  int FLD_PERSON = 8;
    public static final  int FLD_EMAIL = 9;
    public static final  int FLD_TYPE = 10;
    public static final  int FLD_PARENT_LOCATION_ID = 11;
    public static final  int FLD_WEBSITE = 12;
    
    public static final  String[] fieldNames = {
        "LOCATION_ID",
        "NAME",
        "CONTACT_ID",
        "DESCRIPTION",
        "CODE",
        "ADDRESS",
        "TELEPHONE",
        "FAX",
        "PERSON",
        "EMAIL",
        "TYPE",
        "PARENT_ID",
        "WEBSITE"
    };
    
    public static final  int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_LONG + TYPE_FK,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG + TYPE_FK,
        TYPE_STRING
    };
    
    public static final int TYPE_LOCATION_WAREHOUSE = 0;
    public static final int TYPE_LOCATION_STORE 	= 1;
    public static final int TYPE_LOCATION_CARGO 	= 2;
    public static final int TYPE_LOCATION_VENDOR 	= 3;
    public static final int TYPE_LOCATION_TRANSFER 	= 4;
    public static final int TYPE_GALLERY_CUSTOMER 	= 5;
    public static final int TYPE_GALLERY_CONSIGNOR 	= 6;
    public static final int TYPE_LOCATION_DEPARTMENT 	= 7;    
    public static final int TYPE_LOCATION_PROJECT 	= 8;
    
    public static final  String[] fieldLocationType = {
        "Warehouse",
        "Store",
        "Cargo",
        "Vendor",
        "Transfer",
        "Gallery Customer",
        "Gallery Consignor",
        "Department",
        "Project"
    };
    
    
    public PstLocation_old(){
    }
    
    public PstLocation_old(int i) throws DBException {
        super(new PstLocation_old());
    }
    
    public PstLocation_old(String sOid) throws DBException {
        super(new PstLocation_old(0));
        if(!locate(sOid))
            throw new DBException(this,DBException.RECORD_NOT_FOUND);
        else
            return;
    }
    
    public PstLocation_old(long lOid) throws DBException {
        super(new PstLocation_old(0));
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
        return TBL_P2_LOCATION;
    }
    
    public String[] getFieldNames(){
        return fieldNames;
    }
    
    public int[] getFieldTypes(){
        return fieldTypes;
    }
    
    public String getPersistentName(){
        return new PstLocation_old().getClass().getName();
    }
    
    public long fetchExc(Entity ent) throws Exception{
        try{
            Location_old location = (Location_old)ent;
            long oid = ent.getOID();
            PstLocation_old pstLocation = new PstLocation_old(oid);
            location.setOID(oid);
            
            location.setName(pstLocation.getString(FLD_NAME));
            location.setContactId(pstLocation.getlong(FLD_CONTACT_ID));
            location.setDescription(pstLocation.getString(FLD_DESCRIPTION));
            location.setCode(pstLocation.getString(FLD_CODE));
            location.setAddress(pstLocation.getString(FLD_ADDRESS));
            location.setTelephone(pstLocation.getString(FLD_TELEPHONE));
            location.setFax(pstLocation.getString(FLD_FAX));
            location.setPerson(pstLocation.getString(FLD_PERSON));
            location.setEmail(pstLocation.getString(FLD_EMAIL));
            location.setType(pstLocation.getInt(FLD_TYPE));
            location.setParentLocationId(pstLocation.getlong(FLD_PARENT_LOCATION_ID));
            location.setWebsite(pstLocation.getString(FLD_WEBSITE));
            
            return location.getOID();
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstLocation_old(0),DBException.UNKNOWN);
        }
    }
    
    public long insertExc(Entity ent) throws Exception{
        return insertExc((Location_old) ent);
    }
    
    public long updateExc(Entity ent) throws Exception{
        return updateExc((Location_old) ent);
    }
    
    public long deleteExc(Entity ent) throws Exception{
        if(ent==null){
            throw new DBException(this,DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }
    
    public static Location_old fetchExc(long oid) throws DBException{
        try{
            Location_old location = new Location_old();
            PstLocation_old pstLocation = new PstLocation_old(oid);
            location.setOID(oid);
            
            location.setName(pstLocation.getString(FLD_NAME));
            location.setContactId(pstLocation.getlong(FLD_CONTACT_ID));
            location.setDescription(pstLocation.getString(FLD_DESCRIPTION));
            location.setCode(pstLocation.getString(FLD_CODE));
            location.setAddress(pstLocation.getString(FLD_ADDRESS));
            location.setTelephone(pstLocation.getString(FLD_TELEPHONE));
            location.setFax(pstLocation.getString(FLD_FAX));
            location.setPerson(pstLocation.getString(FLD_PERSON));
            location.setEmail(pstLocation.getString(FLD_EMAIL));
            location.setType(pstLocation.getInt(FLD_TYPE));
            location.setParentLocationId(pstLocation.getlong(FLD_PARENT_LOCATION_ID));
            location.setWebsite(pstLocation.getString(FLD_WEBSITE));
            
            return location;
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstLocation_old(0),DBException.UNKNOWN);
        }
    }
    
    public static long insertExc(Location_old location) throws DBException{
        try{
            PstLocation_old pstLocation = new PstLocation_old(0);
            
            pstLocation.setString(FLD_NAME, location.getName());
            pstLocation.setLong(FLD_CONTACT_ID, location.getContactId());
            pstLocation.setString(FLD_DESCRIPTION, location.getDescription());
            pstLocation.setString(FLD_CODE, location.getCode());
            pstLocation.setString(FLD_ADDRESS, location.getAddress());
            pstLocation.setString(FLD_TELEPHONE, location.getTelephone());
            pstLocation.setString(FLD_FAX, location.getFax());
            pstLocation.setString(FLD_PERSON, location.getPerson());
            pstLocation.setString(FLD_EMAIL, location.getEmail());
            pstLocation.setInt(FLD_TYPE, location.getType());
            pstLocation.setLong(FLD_PARENT_LOCATION_ID, location.getParentLocationId());
            pstLocation.setString(FLD_WEBSITE, location.getWebsite());
            
            pstLocation.insert();
            location.setOID(pstLocation.getlong(FLD_LOCATION_ID));
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstLocation_old(0),DBException.UNKNOWN);
        }
        return location.getOID();
    }
    
    public static long updateExc(Location_old location) throws DBException{
        try{
            if(location.getOID() != 0){
                PstLocation_old pstLocation = new PstLocation_old(location.getOID());
                
                pstLocation.setString(FLD_NAME, location.getName());
                pstLocation.setLong(FLD_CONTACT_ID, location.getContactId());
                pstLocation.setString(FLD_DESCRIPTION, location.getDescription());
                pstLocation.setString(FLD_CODE, location.getCode());
                pstLocation.setString(FLD_ADDRESS, location.getAddress());
                pstLocation.setString(FLD_TELEPHONE, location.getTelephone());
                pstLocation.setString(FLD_FAX, location.getFax());
                pstLocation.setString(FLD_PERSON, location.getPerson());
                pstLocation.setString(FLD_EMAIL, location.getEmail());
                pstLocation.setInt(FLD_TYPE, location.getType());
                pstLocation.setLong(FLD_PARENT_LOCATION_ID, location.getParentLocationId());
                pstLocation.setString(FLD_WEBSITE, location.getWebsite());
                
                pstLocation.update();
                return location.getOID();
                
            }
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstLocation_old(0),DBException.UNKNOWN);
        }
        return 0;
    }
    
    public static long deleteExc(long oid) throws DBException{
        try{
            PstLocation_old pstLocation = new PstLocation_old(oid);
            pstLocation.delete();
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstLocation_old(0),DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_P2_LOCATION;
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
                Location_old location = new Location_old();
                resultToObject(rs, location);
                lists.add(location);
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
    
    private static void resultToObject(ResultSet rs, Location_old location){
        try{
            location.setOID(rs.getLong(PstLocation_old.fieldNames[PstLocation_old.FLD_LOCATION_ID]));
            location.setName(rs.getString(PstLocation_old.fieldNames[PstLocation_old.FLD_NAME]));
            location.setContactId(rs.getLong(PstLocation_old.fieldNames[PstLocation_old.FLD_CONTACT_ID]));
            location.setDescription(rs.getString(PstLocation_old.fieldNames[PstLocation_old.FLD_DESCRIPTION]));
            location.setCode(rs.getString(PstLocation_old.fieldNames[PstLocation_old.FLD_CODE]));
            location.setAddress(rs.getString(PstLocation_old.fieldNames[PstLocation_old.FLD_ADDRESS]));
            location.setTelephone(rs.getString(PstLocation_old.fieldNames[PstLocation_old.FLD_TELEPHONE]));
            location.setFax(rs.getString(PstLocation_old.fieldNames[PstLocation_old.FLD_FAX]));
            location.setPerson(rs.getString(PstLocation_old.fieldNames[PstLocation_old.FLD_PERSON]));
            location.setEmail(rs.getString(PstLocation_old.fieldNames[PstLocation_old.FLD_EMAIL]));
            location.setType(rs.getInt(PstLocation_old.fieldNames[PstLocation_old.FLD_TYPE]));
            location.setParentLocationId(rs.getLong(PstLocation_old.fieldNames[PstLocation_old.FLD_PARENT_LOCATION_ID]));
            location.setWebsite(rs.getString(PstLocation_old.fieldNames[PstLocation_old.FLD_WEBSITE]));
        }catch(Exception e){ }
    }
    
    public static boolean checkOID(long locationId){
        DBResultSet dbrs = null;
        boolean result = false;
        try{
            String sql = "SELECT * FROM " + TBL_P2_LOCATION + " WHERE " +
            PstLocation_old.fieldNames[PstLocation_old.FLD_LOCATION_ID] + " = " + locationId;
            
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
            String sql = "SELECT COUNT("+ PstLocation_old.fieldNames[PstLocation_old.FLD_LOCATION_ID] + ") FROM " + TBL_P2_LOCATION;
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
                    Location_old location = (Location_old)list.get(ls);
                    if(oid == location.getOID())
                        found=true;
                }
            }
        }
        if((start >= size) && (size > 0))
            start = start - recordToGet;
        
        return start;
    }
    
    private static Vector list(long oidLocation){
        
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT LOC.* "+
            ", CONT."+PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME]+
            ", CONT."+PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME]+
            " FROM " + TBL_P2_LOCATION+ " LOC "+
            " LEFT JOIN "+PstContactList.TBL_CONTACT_LIST + " CONT "+
            " ON LOC."+PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID]+
            " = CONT."+PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID]+
            " WHERE LOC."+fieldNames[FLD_PARENT_LOCATION_ID]+(oidLocation == 0?" IS NULL":(" = "+oidLocation));
            
            
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
                Vector temp = new Vector(1,1);
                Location_old location = new Location_old();
                ContactList contact = new ContactList();
                resultToObject(rs, location);
                temp.add(location);
                
                contact.setPersonName(rs.getString(PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME]));
                contact.setPersonLastname(rs.getString(PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME]));
                temp.add(contact);
                
                lists.add(temp);
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
    
    public static Vector getNestedLocation(long oid,Vector result) {
        try {
            Vector locations = PstLocation_old.list(oid);
            
            if ((locations.size() < 1) || (locations == null)) {
                return new Vector(1, 1);
            } else {
                for (int pd = 0; pd < locations.size(); pd++) {
                    Vector temp = (Vector)locations.get(pd);
                    Location_old location = (Location_old)temp.get(0);
                    oid = location.getOID();
                    long parent = location.getParentLocationId();
                    int indent = ifExist(result,parent);
                    location.setCode(indent +"/"+ location.getCode());
                    temp.setElementAt(location,0);
                    result.add(temp);
                    getNestedLocation(oid, result);
                }
            }
            return result;
        } catch (Exception exc) {
            return null;
        }
    }
    
    
    private static int ifExist(Vector result,long parent) {
        int indent = 0;
        for(int i=0;i<result.size();i++){
            Vector temp = (Vector)result.get(i);
            Location_old location = (Location_old)temp.get(0);
            long oid = location.getOID();
            if(parent == oid){
                String locCode = location.getCode();
                int idn = locCode.indexOf("/");
                int existIdn = 0;
                if(idn > 0)
                    existIdn = Integer.parseInt(locCode.substring(0,idn));
                indent = existIdn + 1;
            }
        }
        return indent;
    }
    
    /***  function for data synchronization ***/
    public long insertExcSynch(Entity ent) throws Exception{
        return insertExcSynch((Location_old) ent);
    }

    public static long insertExcSynch(Location_old location) throws DBException{
        long newOID = 0;
        long originalOID = location.getOID();
        try{
            newOID= insertExc(location);
            if(newOID!=0){  // sukses insert ?
                updateSynchOID(newOID, originalOID);
                return originalOID;
            }
        }catch(DBException dbe){
            throw dbe;
        }catch(Exception e){
            throw new DBException(new PstLocation_old(0),DBException.UNKNOWN);
        }
        return 0;
    }

    public static long updateSynchOID(long newOID, long originalOID) throws DBException {
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE " + PstLocation_old.TBL_P2_LOCATION + " SET " +
            PstLocation_old.fieldNames[PstLocation_old.FLD_LOCATION_ID] + " = " + originalOID +
            " WHERE " + PstLocation_old.fieldNames[PstLocation_old.FLD_LOCATION_ID] +
            " = " + newOID;
                        
            int Result = DBHandler.execUpdate(sql);
           

            return originalOID;
        }catch(Exception e) {
            return 0;
        }finally {
            DBResultSet.close(dbrs);
        }
        }
    
    //===============================================================
    //INTEGRASI HANOMAN VS POS  
    
/*    public long deleteOutlet(OutletLink outletLink) {        
        try{
            //long oid = deleteByLocationId(outletLink.getOutletId());
            PstLocation_old.deleteExc(outletLink.getOutletId());
        }
        catch(Exception e){
            System.out.println("exception e :: "+e.toString());
        }
        return outletLink.getOutletId();
    }*/
    
    /*public long insertOutlet(OutletLink outletLink) {
        
        System.out.println("in pos -- inserting new location");
        
        Location_old location = new Location_old();
        location.setName(outletLink.getName());
        location.setCode(outletLink.getCode());
        location.setDescription(outletLink.getDescription());
        location.setType(PstLocation_old.TYPE_LOCATION_STORE);
        location.setAddress("-");
        
        long oid = 0;
        try{
            oid = PstLocation_old.insertExc(location);
            oid = synchronizeOID(oid, outletLink.getOutletId());
        }
        catch(Exception e){
            System.out.println("in pos -- exception inserting new location : "+e.toString());
        }
        
        System.out.println("in pos -- success inserting new location : "+oid);
        
        return oid;
    }
    
    public long synchronizeOID(long oldOID, long newOID) {
        String sql = "UPDATE "+TBL_P2_LOCATION+
            " SET "+fieldNames[FLD_LOCATION_ID]+"="+newOID+
            " WHERE "+fieldNames[FLD_LOCATION_ID]+"="+oldOID;
        
        try{
            DBHandler.execUpdate(sql);
        }
        catch(Exception e){
            return 0;
        }
        
        return newOID;
    }
    
    public long updateOutlet(OutletLink outletLink) {
        
        System.out.println("in - MATERIAL -update outlet || location");
        System.out.println("outletLink.getOutletId() : "+outletLink.getOutletId());
        
        Location_old location = new Location_old();
        long oid = 0;
        
        try{
            
            location = PstLocation_old.fetchExc(outletLink.getOutletId());
        
            location.setName(outletLink.getName());
            location.setCode(outletLink.getCode());
            location.setDescription(outletLink.getDescription());
            //location.setType(PstLocation_old.TYPE_LOCATION_STORE);

            oid = PstLocation_old.updateExc(location);
            
        }
        catch(Exception e){
            System.out.println("Exception e : "+e.toString());
        }
        
        return oid;
        
    }*/
    //end END INTEGRASI
    /*** -------------------------- ***/    
    
 
    public static long getLocationByType(int type){        
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT "+PstLocation_old.fieldNames[PstLocation_old.FLD_LOCATION_ID]+
                         " FROM " + TBL_P2_LOCATION+
                         " WHERE "+PstLocation_old.fieldNames[PstLocation_old.FLD_TYPE]+
                         " = "+type;
          
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            long oid = 0;
            while(rs.next()) {
                oid = rs.getLong(1);
            }
            rs.close();
            return oid;
            
        }catch(Exception e) {
            System.out.println(e);
        }finally {
            DBResultSet.close(dbrs);
        }
        return 0;        



    }
    
    public static Vector listLocationAssign(long userId, String whereClause)
    {
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT LOC.* "+ 
                         " FROM " + TBL_P2_LOCATION+" LOC "+
                         " INNER JOIN "+PstDataCustom.TBL_DATA_CUSTOM+" DC "+
                         " ON DC."+PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_VALUE]+
                         " = "+fieldNames[PstLocation_old.FLD_LOCATION_ID]+
                         " WHERE "+PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID]+
                         " = "+userId;
            
            if(whereClause != null && whereClause.length()>0){
                sql += " AND LOC."+whereClause;
            }









            
            sql = sql + " ORDER BY LOC."+fieldNames[PstLocation_old.FLD_NAME] ;
          
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();
            while(rs.next()) {
                Location_old location = new Location_old();
                PstLocation_old.resultToObject(rs, location);
                result.add(location);
            }
            rs.close();
            return result;
            
        }catch(Exception e) {
            System.out.println(e);
        }finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();        


    }
    
}
