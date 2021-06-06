/*
 * PstAppUser.java
 *
 * Created on April 3, 2002, 9:29 AM
 */
package com.dimata.aiso.entity.admin;

/**
 *
 * @author ktanjana
 * @version
 */
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.dimata.aiso.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Formater;
import org.json.JSONObject;

public class PstAppUser extends DBHandler implements I_DBInterface, I_DBType, I_Persintent {

    public static final String TBL_APP_USER = "aiso_app_user";
    public static final int FLD_USER_ID = 0;
    public static final int FLD_LOGIN_ID = 1;
    public static final int FLD_PASSWORD = 2;
    public static final int FLD_FULL_NAME = 3;
    public static final int FLD_EMAIL = 4;
    public static final int FLD_DESCRIPTION = 5;
    public static final int FLD_REG_DATE = 6;
    public static final int FLD_UPDATE_DATE = 7;
    public static final int FLD_USER_STATUS = 8;
    public static final int FLD_LAST_LOGIN_DATE = 9;
    public static final int FLD_LAST_LOGIN_IP = 10;
    public static final int FLD_USER_GROUP = 11;
    public static final int FLD_ASSIGN_LOCATION_ID = 12;
    public static final int FLD_EMPLOYEE_ID = 13;

    public static final String[] fieldNames = {
        "USER_ID", // 0
        "LOGIN_ID", // 1
        "PASSWORD", // 2
        "FULL_NAME", // 3
        "EMAIL", // 4
        "DESCRIPTION", // 5
        "REG_DATE", // 6
        "UPDATE_DATE", // 7
        "USER_STATUS", // 8
        "LAST_LOGIN_DATE", // 9
        "LAST_LOGIN_IP", // 10
        "USER_GROUP", // 11
        "ASSIGN_LOCATION_ID", // 12
        "EMPLOYEE_ID" // 13
    };

    public static int[] fieldTypes = {
        TYPE_PK + TYPE_LONG + TYPE_ID, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING,
        TYPE_DATE, TYPE_DATE, TYPE_INT, TYPE_DATE, TYPE_STRING, TYPE_LONG, TYPE_LONG, TYPE_LONG
    };

    /**
     * Creates new PstAppUser
     */
    public PstAppUser() {
    }

    public PstAppUser(int i) throws DBException {
        super(new PstAppUser());
    }

    public PstAppUser(String sOid) throws DBException {
        super(new PstAppUser(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstAppUser(long lOid) throws DBException {
        super(new PstAppUser(0));
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
        return TBL_APP_USER;
    }

    public String getPersistentName() {
        return new PstAppUser().getClass().getName();
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public long delete(Entity ent) {
        return delete((AppUser) ent);
    }

    public long insert(Entity ent) {
        try {
            return PstAppUser.insert((AppUser) ent);
        } catch (Exception e) {
            System.out.println(" EXC " + e);
            return 0;
        }
    }

    public long update(Entity ent) {
        return update((AppUser) ent);
    }

    public long fetch(Entity ent) {
        AppUser entObj = PstAppUser.fetch(ent.getOID());
        ent = (Entity) entObj;
        return ent.getOID();
    }

    public static AppUser fetch(long oid) {
        AppUser entObj = new AppUser();
        try {
            PstAppUser pstObj = new PstAppUser(oid);
            entObj.setOID(oid);
            entObj.setLoginId(pstObj.getString(FLD_LOGIN_ID));
            entObj.setPassword(pstObj.getString(FLD_PASSWORD));
            entObj.setFullName(pstObj.getString(FLD_FULL_NAME));
            entObj.setEmail(pstObj.getString(FLD_EMAIL));
            entObj.setDescription(pstObj.getString(FLD_DESCRIPTION));
            entObj.setRegDate(pstObj.getDate(FLD_REG_DATE));
            entObj.setUpdateDate(pstObj.getDate(FLD_UPDATE_DATE));
            entObj.setUserStatus(pstObj.getInt(FLD_USER_STATUS));
            entObj.setLastLoginDate(pstObj.getDate(FLD_LAST_LOGIN_DATE));
            entObj.setLastLoginIp(pstObj.getString(FLD_LAST_LOGIN_IP));
            entObj.setGroupUser(pstObj.getInt(FLD_USER_GROUP));
            entObj.setAssignLocationId(pstObj.getlong(FLD_ASSIGN_LOCATION_ID));
            entObj.setEmployeeId(pstObj.getlong(FLD_EMPLOYEE_ID));
        } catch (DBException e) {
            System.out.println(e);
        }
        return entObj;
    }

    public static long insert(AppUser entObj) throws DBException {
        try {
            PstAppUser pstObj = new PstAppUser(0);

            pstObj.setString(FLD_LOGIN_ID, entObj.getLoginId());
            pstObj.setString(FLD_PASSWORD, entObj.getPassword());
            pstObj.setString(FLD_FULL_NAME, entObj.getFullName());
            pstObj.setString(FLD_EMAIL, entObj.getEmail());
            pstObj.setString(FLD_DESCRIPTION, entObj.getDescription());
            pstObj.setDate(FLD_REG_DATE, new Date());//entObj.getRegDate());
            pstObj.setDate(FLD_UPDATE_DATE, new Date());//entObj.getUpdateDate());
            pstObj.setInt(FLD_USER_STATUS, entObj.getUserStatus());
            pstObj.setInt(FLD_USER_GROUP, entObj.getGroupUser());
            pstObj.setDate(FLD_LAST_LOGIN_DATE, entObj.getLastLoginDate());
            pstObj.setString(FLD_LAST_LOGIN_IP, entObj.getLastLoginIp());
            pstObj.setLong(FLD_ASSIGN_LOCATION_ID, entObj.getAssignLocationId());
            pstObj.setLong(FLD_EMPLOYEE_ID, entObj.getEmployeeId());

            pstObj.insert();
            entObj.setOID(pstObj.getlong(FLD_USER_ID));
            return entObj.getOID();
        } catch (DBException e) {
            System.out.println(e);
        }
        return 0;

    }

    public static long update(AppUser entObj) {

        // edited by Edhy
        if (entObj != null
                && entObj.getOID() != 0
                && entObj.getLoginId() != null
                && entObj.getLoginId().length() > 0
                && entObj.getPassword() != null
                && entObj.getPassword().length() > 0) {
            try {
                PstAppUser pstObj = new PstAppUser(entObj.getOID());

                pstObj.setString(FLD_LOGIN_ID, entObj.getLoginId());
                pstObj.setString(FLD_PASSWORD, entObj.getPassword());
                pstObj.setString(FLD_FULL_NAME, entObj.getFullName());
                pstObj.setString(FLD_EMAIL, entObj.getEmail());
                pstObj.setString(FLD_DESCRIPTION, entObj.getDescription());
                //pstObj.setDate(FLD_REG_DATE, entObj.getRegDate());
                pstObj.setDate(FLD_UPDATE_DATE, new Date());
                pstObj.setInt(FLD_USER_STATUS, entObj.getUserStatus());
                pstObj.setDate(FLD_LAST_LOGIN_DATE, new Date());
                pstObj.setString(FLD_LAST_LOGIN_IP, entObj.getLastLoginIp());
                pstObj.setInt(FLD_USER_GROUP, entObj.getGroupUser());
                //pstObj.setLong(FLD_EMPLOYEE_ID, entObj.getEmployeeId());
                pstObj.setLong(FLD_ASSIGN_LOCATION_ID, entObj.getAssignLocationId());
                pstObj.setLong(FLD_EMPLOYEE_ID, entObj.getEmployeeId());

                pstObj.update();

                return entObj.getOID();

            } catch (Exception e) {
                System.out.println("Exception on update user ===> " + e.toString());
            }
        }
        return 0;
    }

    public static long delete(long oid) {
        try {
            PstAppUser pstObj = new PstAppUser(oid);
            pstObj.delete();
            return oid;
        } catch (Exception e) {
            System.out.println(e);
        }
        return 0;
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            int count = 0;
            String sql = " SELECT COUNT(" + fieldNames[FLD_USER_ID] + ") AS NRCOUNT"
                    + " FROM " + TBL_APP_USER;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

//            System.out.println(sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }
            return count;
        } catch (Exception exc) {
            System.out.println("getCount " + exc);
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }

    }

    public static Vector listPartObj(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT " + fieldNames[FLD_USER_ID]
                    + ", " + fieldNames[FLD_LOGIN_ID]
                    + ", " + fieldNames[FLD_FULL_NAME]
                    + ", " + fieldNames[FLD_EMAIL]
                    + ", " + fieldNames[FLD_USER_STATUS]
                    + ", " + fieldNames[FLD_USER_GROUP]
                    + " FROM " + TBL_APP_USER;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            switch (DBHandler.DBSVR_TYPE) {
                case DBHandler.DBSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
                    break;

                case DBHandler.DBSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }

                    break;

                case DBHandler.DBSVR_SYBASE:
                    break;

                case DBHandler.DBSVR_ORACLE:
                    break;

                case DBHandler.DBSVR_MSSQL:
                    break;

                default:
                    break;
            }

//            System.out.println("SQL : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                AppUser appUser = new AppUser();
                resultToObject(rs, appUser);
                lists.add(appUser);
            }
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static void resultToObject(ResultSet rs, AppUser entObj) {
        try {
//            System.out.println("... IN resultToObject ...");
            entObj.setOID(rs.getLong(fieldNames[FLD_USER_ID]));
            entObj.setLoginId(rs.getString(fieldNames[FLD_LOGIN_ID]));
            entObj.setFullName(rs.getString(fieldNames[FLD_FULL_NAME]));
            entObj.setEmail(rs.getString(fieldNames[FLD_EMAIL]));
            entObj.setUserStatus(rs.getInt(fieldNames[FLD_USER_STATUS]));
            entObj.setGroupUser(rs.getInt(fieldNames[FLD_USER_GROUP]));
            entObj.setAssignLocationId(rs.getLong(fieldNames[FLD_ASSIGN_LOCATION_ID]));
            entObj.setEmployeeId(rs.getLong(fieldNames[FLD_EMPLOYEE_ID]));
        } catch (Exception e) {
            System.out.println("resultToObject() " + e.toString());
        }
    }

    public static Vector listAll() {
        return listFullObj(0, 0, "", "");
    }

    public static Vector listFullObj(int start, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT " + fieldNames[FLD_USER_ID]
                    + " FROM " + TBL_APP_USER;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            if ((start == 0) && (recordToGet == 0)) {
                sql = sql + "";  //nothing to do
            } else {
                sql = sql + " LIMIT " + start + "," + recordToGet;
            }

            //System.out.println(sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                AppUser appUser = new AppUser();
                appUser = PstAppUser.fetch(rs.getLong(fieldNames[FLD_USER_ID]));
                lists.add(appUser);
            }
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector getUserPrivObj(long userOID) {
        if (userOID == 0) {
            return new Vector(1, 1);
        }
        DBResultSet dbrs = null;
        try {
            String sql
                    = "SELECT DISTINCT(PO." + PstAppPrivilegeObj.fieldNames[PstAppPrivilegeObj.FLD_CODE] + ") AS CODE FROM " + PstAppPrivilegeObj.TBL_APP_PRIVILEGE_OBJ + " AS PO "
                    + " INNER JOIN " + PstGroupPriv.TBL_GROUP_PRIV + " AS GP ON GP." + PstGroupPriv.fieldNames[PstGroupPriv.FLD_PRIV_ID] + "=PO." + PstAppPrivilegeObj.fieldNames[PstAppPrivilegeObj.FLD_PRIV_ID]
                    + " INNER JOIN " + PstUserGroup.TBL_USER_GROUP + " AS UG ON UG." + PstUserGroup.fieldNames[PstUserGroup.FLD_GROUP_ID] + "=GP." + PstGroupPriv.fieldNames[PstGroupPriv.FLD_GROUP_ID]
                    + " WHERE UG." + PstUserGroup.fieldNames[PstUserGroup.FLD_USER_ID] + "='" + userOID + "'";

//            System.out.println(sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector privObjs = new Vector(10, 2);
            while (rs.next()) {
                privObjs.add(new Integer(rs.getInt("CODE")));
            }
            return privObjs;

        } catch (Exception e) {
            System.out.println("getUserPrivObj " + e);
        } finally {
            DBResultSet.close(dbrs);
        }

        return new Vector(1, 1);
    }

    public static long updateUserStatus(long userOID, int status) {
        if (userOID == 0) {
            return 0;
        }
        //
        try {
            AppUser appUser = PstAppUser.fetch(userOID);
            appUser.setUserStatus(status);

            PstAppUser.update(appUser);
            return userOID;
        } catch (Exception e) {
            System.out.println("Exception e :" + e.toString());
        }

        return userOID;

        /*  DBResultSet dbrs=null;
        try{
            String sql = "UPDATE "+ TBL_APP_USER + " SET "+fieldNames[FLD_USER_STATUS]+"='"+status+"'"
            + " WHERE "+fieldNames[FLD_USER_ID]+"='"+userOID+"'";
            
            dbrs=DBHandler.execQueryResult(sql);            
            return userOID;
            
        } catch(Exception e) {
            System.out.println("updateUserStatus " +e);
            return 0;
        }
        finally{
            DBResultSet.close(dbrs);
        }*/
    }

    public static AppUser getByLoginIDAndPassword(String loginID, String password) {
        if ((loginID == null) || (loginID.length() < 1) || (password == null) || (password.length() < 1)) {
            return null;
        }

        try {

            String whereClause = " " + fieldNames[FLD_LOGIN_ID] + "='" + loginID.trim() + "' AND "
                    + fieldNames[FLD_PASSWORD] + "='" + password.trim() + "'";

            Vector appUsers = listFullObj(0, 0, whereClause, "");

            if ((appUsers == null) || (appUsers.size() != 1)) {
                return new AppUser();
            }

            return (AppUser) appUsers.get(0);

        } catch (Exception e) {
            System.out.println("getByLoginIDAndPassword " + e);
            return null;
        }
    }

    public static String getOperatorName(long userOID) {
        try {
            if (userOID != 0) {
                AppUser appUser = PstAppUser.fetch(userOID);
                return appUser.getFullName();
            }
            return "";

        } catch (Exception e) {
        }
        return "";
    }

    public static boolean checkOID(long appUserId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_APP_USER + " WHERE "
                    + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = " + appUserId;
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

    /**
     * @param entObj
     * @return
     * @created by Edhy
     */
    public static long updateUserByLoggedIn(AppUser entObj) {
        String strLoginId = entObj.getLoginId();
        String strPassword = entObj.getPassword();
        if (entObj != null
                && entObj.getOID() != 0
                && strLoginId != null && strLoginId.length() > 0 && !strLoginId.equalsIgnoreCase("NULL")
                && strPassword != null && strPassword.length() > 0 && !strPassword.equalsIgnoreCase("NULL")) {
            try {
                PstAppUser pstObj = new PstAppUser(entObj.getOID());

                pstObj.setString(FLD_FULL_NAME, entObj.getFullName());
                pstObj.setString(FLD_EMAIL, entObj.getEmail());
                pstObj.setString(FLD_DESCRIPTION, entObj.getDescription());
                pstObj.setDate(FLD_UPDATE_DATE, new Date());
                pstObj.setInt(FLD_USER_STATUS, entObj.getUserStatus());
                pstObj.setDate(FLD_LAST_LOGIN_DATE, entObj.getLastLoginDate());
                pstObj.setString(FLD_LAST_LOGIN_IP, entObj.getLastLoginIp());
                pstObj.setInt(FLD_USER_GROUP, entObj.getGroupUser());

                pstObj.update();
                return entObj.getOID();
            } catch (Exception e) {
                System.out.println(e);
            }
        }
        return 0;
    }

    public static JSONObject fetchJSON(long oid) {
        JSONObject object = new JSONObject();
        try {
            AppUser appUser = PstAppUser.fetch(oid);
            object.put(PstAppUser.fieldNames[PstAppUser.FLD_USER_ID], appUser.getOID());
            object.put(PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME], appUser.getFullName());
            object.put(PstAppUser.fieldNames[PstAppUser.FLD_EMAIL], appUser.getEmail());
            object.put(PstAppUser.fieldNames[PstAppUser.FLD_DESCRIPTION], appUser.getDescription());
            object.put(PstAppUser.fieldNames[PstAppUser.FLD_UPDATE_DATE], appUser.getUpdateDate());
            object.put(PstAppUser.fieldNames[PstAppUser.FLD_USER_STATUS], appUser.getUserStatus());
            object.put(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_DATE], appUser.getLastLoginDate());
            object.put(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_IP], appUser.getLastLoginIp());
            object.put(PstAppUser.fieldNames[PstAppUser.FLD_USER_GROUP], appUser.getUserStatus());
        } catch (Exception exc) {
        }
        return object;
    }

//  public static boolean checkOID(long appUserId) {
//    DBResultSet dbrs = null;
//    boolean result = false;
//    try {
//      String sql = "SELECT * FROM " + TBL_APP_USER + " WHERE "
//              + PstAppUser.fieldNames[PstAppUser.FLD_USER_ID] + " = " + appUserId;
//      dbrs = DBHandler.execQueryResult(sql);
//      ResultSet rs = dbrs.getResultSet();
//      while (rs.next()) {
//        AppUser ap = new AppUser();
//        resultToObject(rs, ap);
//        if(ap.getOID() != 0){
//        result = true;
//      }
//      }
//      rs.close();
//    } catch (Exception e) {
//      System.out.println("err : " + e.toString());
//    } finally {
//      DBResultSet.close(dbrs);
//      return result;
//    }
//  }
//    
//    /**
//     * @param entObj
//     * @return
//     * @created by Edhy
//     */    
//    public static long updateUserByLoggedIn(AppUser entObj) 
//    {
//        String strLoginId = entObj.getLoginId();
//        String strPassword = entObj.getPassword();
//        if( entObj!=null && 
//            entObj.getOID()!=0 &&
//            strLoginId!=null && strLoginId.length()>0 && !strLoginId.equalsIgnoreCase("NULL") &&
//            strPassword!=null && strPassword.length()>0 && !strPassword.equalsIgnoreCase("NULL")
//          ) 
//        {
//            try  
//            {
//                PstAppUser pstObj = new PstAppUser(entObj.getOID());
//                
//                pstObj.setString(FLD_FULL_NAME, entObj.getFullName());
//                pstObj.setString(FLD_EMAIL, entObj.getEmail());
//                pstObj.setString(FLD_DESCRIPTION, entObj.getDescription());                
//                pstObj.setDate(FLD_UPDATE_DATE, new Date()); 
//                pstObj.setInt(FLD_USER_STATUS, entObj.getUserStatus());
//                pstObj.setDate(FLD_LAST_LOGIN_DATE, entObj.getLastLoginDate());
//                pstObj.setString(FLD_LAST_LOGIN_IP, entObj.getLastLoginIp());                
//                pstObj.setInt(FLD_USER_GROUP, entObj.getGroupUser());
//                
//                pstObj.update();
//                return entObj.getOID();   
//            }
//            catch(Exception e) 
//            {
//                System.out.println(e);   
//            }
//        }
//        return 0;
//    }
    public static long syncExc(JSONObject jSONObject) {
        long oid = 0;
        if (jSONObject != null) {
            oid = jSONObject.optLong(PstAppUser.fieldNames[PstAppUser.FLD_USER_ID], 0);
            if (oid > 0) {
                AppUser appUser = new AppUser();

                appUser.setOID(jSONObject.optLong(PstAppUser.fieldNames[PstAppUser.FLD_USER_ID], 0));
				appUser.setPassword(jSONObject.optString(PstAppUser.fieldNames[PstAppUser.FLD_PASSWORD], ""));
				appUser.setLoginId(jSONObject.optString(PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID], ""));
                appUser.setFullName(jSONObject.optString(PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME], ""));
                appUser.setEmail(jSONObject.optString(PstAppUser.fieldNames[PstAppUser.FLD_EMAIL], ""));
                appUser.setDescription(jSONObject.optString(PstAppUser.fieldNames[PstAppUser.FLD_DESCRIPTION], ""));
                appUser.setUpdateDate(Formater.formatDate(jSONObject.optString(PstAppUser.fieldNames[PstAppUser.FLD_UPDATE_DATE], "0000-00-00"), "yyyy-MM-dd"));
                appUser.setUserStatus(jSONObject.optInt(PstAppUser.fieldNames[PstAppUser.FLD_USER_STATUS], 0));
                appUser.setLastLoginDate(Formater.formatDate(jSONObject.optString(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_DATE], "0000-00-00"), "yyyy-MM-dd"));
                appUser.setAssignLocationId(jSONObject.optLong(PstAppUser.fieldNames[PstAppUser.FLD_ASSIGN_LOCATION_ID], 0));
                appUser.setLastLoginIp(jSONObject.optString(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_IP], ""));
                appUser.setGroupUser(jSONObject.optInt(PstAppUser.fieldNames[PstAppUser.FLD_USER_GROUP], 0));

                boolean chekOidMaterial = PstAppUser.checkOID(oid);
                try {
                    if (chekOidMaterial) {
                        PstAppUser.update(appUser);
                    } else {
                        PstAppUser.insertUser(appUser);
                    }
                } catch (Exception exc) {
                }
            }
        }
        return oid;
    }

    public static long insertUser(AppUser appUser) throws DBException {
        try {
            PstAppUser pstAppUser = new PstAppUser(0);
            //pstAppUser.setLong(FLD_USER_ID, appUser.getOID());
            pstAppUser.setString(FLD_LOGIN_ID, appUser.getLoginId());
            pstAppUser.setString(FLD_PASSWORD, appUser.getPassword());
            pstAppUser.setString(FLD_FULL_NAME, appUser.getFullName());
            pstAppUser.setString(FLD_EMAIL, appUser.getEmail());
            pstAppUser.setString(FLD_DESCRIPTION, appUser.getDescription());
            pstAppUser.setDate(FLD_REG_DATE, new Date());//entObj.getRegDate());
            pstAppUser.setDate(FLD_UPDATE_DATE, new Date());//entObj.getUpdateDate());
            pstAppUser.setInt(FLD_USER_STATUS, appUser.getUserStatus());
//            pstAppUser.setInt(FLD_USER_GROUP, appUser.getGroupUser()); 
//            pstAppUser.setDate(FLD_LAST_LOGIN_DATE, appUser.getLastLoginDate());
//            pstAppUser.setString(FLD_LAST_LOGIN_IP, appUser.getLastLoginIp());
            pstAppUser.setLong(FLD_ASSIGN_LOCATION_ID, appUser.getAssignLocationId());
            pstAppUser.setLong(FLD_EMPLOYEE_ID, appUser.getEmployeeId());

            pstAppUser.insertByOid(appUser.getOID());
//            appUser.setOID(pstAppUser.getlong(FLD_USER_ID));

        } catch (DBException dbe) {
            throw dbe;

        } catch (Exception e) {
            throw new DBException(new PstAppUser(0), DBException.UNKNOWN);
        }
        return appUser.getOID();
    }

    public static void convertJsonToObject(JSONObject obj, AppUser entAppUser) {
        try {
            entAppUser.setOID(obj.optLong(PstAppUser.fieldNames[PstAppUser.FLD_USER_ID]));
            entAppUser.setLoginId(obj.optString(PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID]));
            entAppUser.setPassword(obj.optString(PstAppUser.fieldNames[PstAppUser.FLD_PASSWORD]));
            entAppUser.setFullName(obj.optString(PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME]));
            entAppUser.setEmail(obj.optString(PstAppUser.fieldNames[PstAppUser.FLD_EMAIL]));
            entAppUser.setDescription(obj.optString(PstAppUser.fieldNames[PstAppUser.FLD_DESCRIPTION]));
            entAppUser.setRegDate(Formater.formatDate(obj.optString(PstAppUser.fieldNames[PstAppUser.FLD_REG_DATE]), "yyyy-MM-dd")); //date
            entAppUser.setUpdateDate(Formater.formatDate(obj.optString(PstAppUser.fieldNames[PstAppUser.FLD_UPDATE_DATE]), "yyyy-MM-dd")); //date
            entAppUser.setUserStatus(obj.optInt(PstAppUser.fieldNames[PstAppUser.FLD_USER_STATUS]));
            entAppUser.setLastLoginDate(Formater.formatDate(obj.optString(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_DATE]), "yyyy-MM-dd")); //date
            entAppUser.setLastLoginIp(obj.optString(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_IP]));
            entAppUser.setUserStatus(obj.optInt(PstAppUser.fieldNames[PstAppUser.FLD_USER_GROUP]));
            entAppUser.setEmployeeId(obj.optLong(PstAppUser.fieldNames[PstAppUser.FLD_EMPLOYEE_ID], 0)); 
            entAppUser.setAssignLocationId(obj.optLong(PstAppUser.fieldNames[PstAppUser.FLD_ASSIGN_LOCATION_ID]));
        } catch (Exception e) {
        }
    }

    public static void resultToObjectJson(ResultSet rs, JSONObject obj) {
        try {
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_USER_ID], rs.getLong(PstAppUser.fieldNames[PstAppUser.FLD_USER_ID]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID], rs.getString(PstAppUser.fieldNames[PstAppUser.FLD_LOGIN_ID]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_PASSWORD], rs.getString(PstAppUser.fieldNames[PstAppUser.FLD_PASSWORD]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME], rs.getString(PstAppUser.fieldNames[PstAppUser.FLD_FULL_NAME]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_EMAIL], rs.getString(PstAppUser.fieldNames[PstAppUser.FLD_EMAIL]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_DESCRIPTION], rs.getString(PstAppUser.fieldNames[PstAppUser.FLD_DESCRIPTION]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_REG_DATE], rs.getDate(PstAppUser.fieldNames[PstAppUser.FLD_REG_DATE]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_UPDATE_DATE], rs.getDate(PstAppUser.fieldNames[PstAppUser.FLD_UPDATE_DATE]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_USER_STATUS], rs.getInt(PstAppUser.fieldNames[PstAppUser.FLD_USER_STATUS]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_DATE], rs.getDate(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_DATE]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_IP], rs.getString(PstAppUser.fieldNames[PstAppUser.FLD_LAST_LOGIN_IP]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_USER_GROUP], rs.getInt(PstAppUser.fieldNames[PstAppUser.FLD_USER_GROUP]));
            obj.put(PstAppUser.fieldNames[PstAppUser.FLD_ASSIGN_LOCATION_ID], rs.getLong(PstAppUser.fieldNames[PstAppUser.FLD_ASSIGN_LOCATION_ID]));
        } catch (Exception e) {
        }
    }
}
