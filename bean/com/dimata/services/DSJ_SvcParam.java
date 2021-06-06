/*
 * WP_SvcParam.java
 *
 * Created on January 26, 2002, 9:27 PM
 */

package com.dimata.services;
import java.util.*;
import java.sql.*;
import com.dimata.services.db.*;
import com.dimata.instant.util.*;

/**
 *
 * @author  ktanjana
 * @version
 */
public class DSJ_SvcParam {
    
    /** Creates new WP_SvcParam */
    public DSJ_SvcParam() {
    }
    
    
    
    /**
     * save service parameters with the name serviceName and parameter names-values in params
     * if existing will updated otherwise will be updated.
     */
    public static int saveParam(String serviceName, Hashtable params){
        if( (serviceName==null) || (serviceName.length()<1) || (params==null))
            return DSJ_ClassMsg.ERR_PROCESS_FAIL;
       
        Iterator  keys = params.keySet().iterator();
        Object key = null;
        Object value = null;
        try{
            //long oid=0;
            //Vector paramSQLs= new Vector();
            while(keys.hasNext()) {
                key=keys.next();
                value = (Object) params.get(key);
                if ( value!=null) {
                    //Thread.sleep(200);
                    saveOneParam(serviceName, key.toString(), value.toString() );
                    //paramSQLs.add(createSQLSaveOneParam(serviceName, key.toString(), value.toString() ));
                }
            }
            //DBHandler.execQuery(paramSQLs);
            return DSJ_ClassMsg.OK;
        }
        catch(Exception  exc){
            return DSJ_ClassMsg.ERR_PROCESS_FAIL;
        }
    }
    
    public static String createSQLSaveOneParam(String serviceName, String name , String value){
            if(value==null)
                 return null;
            /*
            return "REPLACE SERVICE_PARAM (SVC_NAME, PARAM_NAME, VALUE) VALUES('"+serviceName +"','"+
                   name +"','"+value +"')";
                   */

            return "UPDATE SERVICE_PARAM  SET SVC_NAME='"+serviceName +"', PARAM_NAME='"+name+
                    "', VALUE='"+value +"' WHERE SVC_NAME='"+serviceName +"' AND PARAM_NAME='"+name+"'";


    }

    public static int saveOneParam(String serviceName, String name , String value){
        try{
            /*
            String sql = "DELETE FROM SERVICE_PARAM WHERE SVC_NAME='"+serviceName+
                  "' AND PARAM_NAME='"+name+"'";
            
            DBHandler.deleteByQuery(sql);
            Thread.sleep(200);
             **/
            /*
            String sql2 = "REPLACE SERVICE_PARAM (SVC_NAME, PARAM_NAME, VALUE) VALUES('"+serviceName +"','"+
                   name +"','"+value +"')";
            */
            String sql2 = "UPDATE SERVICE_PARAM  SET SVC_NAME='"+serviceName +"', PARAM_NAME='"+name+
                    "', VALUE='"+value +"' WHERE SVC_NAME='"+serviceName +"' AND PARAM_NAME='"+name+"'";

            //DBHandler.execSqlInsert(sql2);
            DBHandler.execUpdate(sql2);
            return DSJ_ClassMsg.OK;
            
        }catch (Exception exc){
            return DSJ_ClassMsg.ERR_PROCESS_FAIL;
        }
        
    }
    
    
    public static Hashtable getParams(String svcName){
        try{            
            String sql = "SELECT PARAM_NAME, VALUE FROM SERVICE_PARAM WHERE SVC_NAME='"+svcName+"'";
            
            DBResultSet dbrs;
            try {
                dbrs = DBHandler.execQueryResult(sql);
            }
            catch (DBException dbe) {
                return null;
            }

            Vector row = new Vector();
            int count = 0;
            try {
                ResultSet rs = dbrs.getResultSet();
                while (rs.next()) {
                    count++;
                    row.add(new String(rs.getString("PARAM_NAME")));
                    row.add(new String(rs.getString("VALUE")));
                    //System.out.println(count);
                }
            }
            catch (SQLException sqle) {
            }
            DBResultSet.close(dbrs);
            //-------------------------------

            Vector fnm = new Vector(1,1);
            fnm.add("PARAM_NAME");
            fnm.add("VALUE");
            
            Vector ftype = new Vector(1,1);
            ftype.add(new Integer(I_DBType.TYPE_STRING));
            ftype.add(new Integer(I_DBType.TYPE_STRING));
            
            //Vector rsl = DBHandler.execQueryRows(sql, fnm, ftype);
            //if ( (rsl==null) || (rsl.size()<1))
            //    return new Hashtable();
            
            Hashtable htbl = new Hashtable();
            for(int i=0; i< row.size(); i++){
               try{ 
                //Vector row = (Vector) rsl.get(i);
                htbl.put(row.get(i), row.get(i+1));
                i++;
               } catch(Exception exc){
                   System.out.println(" Exc public put param "+i);
               }
            }                        
            return htbl;
            
        }catch (Exception exc){
            return null;
        }
        
    }

        public static String getOneParam(String svcName, String paramName){
        try{            
            String sql = "SELECT VALUE FROM SERVICE_PARAM WHERE SVC_NAME='"+svcName+"' AND PARAM_NAME='"+
                paramName+"'" ;
            
            DBResultSet dbrs;
            try {
                dbrs = DBHandler.execQueryResult(sql);
            }
            catch (DBException dbe) {
                return null;
            }

            String value ="";
            int count = 0;
            try {
                ResultSet rs = dbrs.getResultSet();
                while (rs.next()) {
                    count++;
                    value = new String(rs.getString("VALUE"));
                }
            }
            catch (SQLException sqle) {
            }
            DBResultSet.close(dbrs);
            //-------------------------------

            return value;
            
        }catch (Exception exc){
            return null;
        }
        
    }

}
