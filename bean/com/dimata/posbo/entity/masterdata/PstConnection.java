/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.dimata.posbo.entity.masterdata;

import java.sql.*;
import java.util.*;
import com.dimata.util.lang.I_Language;
import com.dimata.common.db.*;
import com.dimata.posbo.form.masterdata.FrmConnection;
import com.dimata.qdep.entity.*;
import org.json.JSONObject;
/**
 *
 * @author user
 */
public class PstConnection extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {
//public static final  String TBL_P2_LOCATION = "LOCATION";
    public static final String TBL_P2_CONNECTION = "db_connection";
    public static final int FLD_ID_DBCONNECTION = 0;
    public static final int FLD_DBDRIVER = 1;
    public static final int FLD_DBURL = 2;
    public static final int FLD_DBUSER = 3;
    public static final int FLD_DBPASSWD = 4;
    public static final int FLD_DBMINCONN=5;
    public static final int FLD_DBMAXCONN=6;
    public static final int FLD_LOGCONN=7;
    public static final int FLD_LOGAPP=8;
    public static final int FLD_LOGSIZE=9;
    public static final int FLD_FORDATE=10;
    public static final int FLD_FORDECIMAL=11;
    public static final int FLD_FOR_CURRENCY=12;
    public static final int FLD_CASH_MASTER_ID=13;
    public static final int FLD_FROM_DATE=14;
    public static final int FLD_TO_DATE=15;
    public static final String[] fieldNames = {//harus sama dengan nama field di database
        "id_dbconnection",
        "dbdriver",
        "dburl",
        "dbuser",
        "dbpasswd",
        "dbminconn",
        "dbmaxconn",
        "logconn",
        "logapp",
        "logsize",
        "fordate",
        "fordecimal",
        "forcurrency",
        "cash_master_id"
        

    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID ,//generate internet_id otomatis
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG
        
    };

    public PstConnection() {
    }

    public PstConnection(int i) throws DBException {
        super(new PstConnection());
    }

    public PstConnection(String sOid) throws DBException {
        super(new PstConnection(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstConnection(long lOid) throws DBException {
        super(new PstConnection(0));
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
        return TBL_P2_CONNECTION;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstConnection().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        try {
            OutletConnection conn = (OutletConnection) ent;
            long oid = ent.getOID();
            PstConnection pstconn = new PstConnection(oid);
            conn.setOID(oid);//method setOID berada pada class Entity
            conn.setDbdriver(pstconn.getString(FLD_DBDRIVER));
            conn.setDburl(pstconn.getString(FLD_DBURL));
            conn.setDbuser(pstconn.getString(FLD_DBUSER));
            conn.setDbpasswd(pstconn.getString(FLD_DBPASSWD));
            conn.setDbminconn(pstconn.getString(FLD_DBMINCONN));
            conn.setDbmaxconn(pstconn.getString(FLD_DBMAXCONN));
            conn.setLogconn(pstconn.getString(FLD_LOGCONN));
            conn.setLogapp(pstconn.getString(FLD_LOGAPP));
            conn.setLogsize(pstconn.getString(FLD_LOGSIZE));
            conn.setFordate(pstconn.getString(FLD_FORDATE));
            conn.setFordecimal(pstconn.getString(FLD_FORDECIMAL));
            conn.setForcurrency(pstconn.getString(FLD_FOR_CURRENCY));
            conn.setCash_master_id(pstconn.getLong(FLD_CASH_MASTER_ID));

            return conn.getOID();

        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstConnection(0), DBException.UNKNOWN);
        }
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((OutletConnection) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((OutletConnection) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static OutletConnection fetchExc(long oid) throws DBException {
        try {
            OutletConnection conn = new OutletConnection();
            PstConnection pstconn = new PstConnection(oid);

            conn.setOID(oid);//method setOID berada pada class Entity
            conn.setDbdriver(pstconn.getString(FLD_DBDRIVER));
            conn.setDburl(pstconn.getString(FLD_DBURL));
            conn.setDbuser(pstconn.getString(FLD_DBUSER));
            conn.setDbpasswd(pstconn.getString(FLD_DBPASSWD));
            conn.setDbminconn(pstconn.getString(FLD_DBMINCONN));
            conn.setDbmaxconn(pstconn.getString(FLD_DBMAXCONN));
            conn.setLogconn(pstconn.getString(FLD_LOGCONN));
            conn.setLogapp(pstconn.getString(FLD_LOGAPP));
            conn.setLogsize(pstconn.getString(FLD_LOGSIZE));
            conn.setFordate(pstconn.getString(FLD_FORDATE));
            conn.setFordecimal(pstconn.getString(FLD_FORDECIMAL));
            conn.setForcurrency(pstconn.getString(FLD_FOR_CURRENCY));
            conn.setCash_master_id(pstconn.getlong(FLD_CASH_MASTER_ID));
            //conn.setDateFrom(pstconn.getlong(FrmConnection.fieldNames[FrmConnection.FRM_FIELD_FROM_DATE]));

            //conn.setDateTo(pstconn.getDate(FLD_TO_DATE));

            return conn;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstConnection(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(OutletConnection conn) throws DBException {
        try {
            PstConnection pstconn = new PstConnection(0);
            pstconn.setString(FLD_DBDRIVER, conn.getDbdriver());
            pstconn.setString(FLD_DBURL, conn.getDburl());
            pstconn.setString(FLD_DBUSER, conn.getDbuser());
            pstconn.setString(FLD_DBPASSWD, conn.getDbpasswd());
            pstconn.setString(FLD_DBMINCONN, conn.getDbminconn());
            pstconn.setString(FLD_DBMAXCONN, conn.getDbmaxconn());
            pstconn.setString(FLD_LOGCONN, conn.getLogconn());
            pstconn.setString(FLD_LOGAPP, conn.getLogapp());
            pstconn.setString(FLD_LOGSIZE, conn.getLogsize());
            pstconn.setString(FLD_FORDATE, conn.getFordate());
            pstconn.setString(FLD_FORDECIMAL, conn.getFordecimal());
            pstconn.setString(FLD_FOR_CURRENCY, conn.getForcurrency());
            pstconn.setLong(FLD_CASH_MASTER_ID, conn.getCash_master_id());

            pstconn.insert();
            conn.setOID(pstconn.getlong(FLD_ID_DBCONNECTION));

        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstConnection(0), DBException.UNKNOWN);
        }
        return conn.getOID();
    }

    public static long updateExc(OutletConnection conn) throws DBException {
        try {
            if (conn.getOID() != 0) {
                PstConnection pstconn = new PstConnection(conn.getOID());

                pstconn.setString(FLD_DBDRIVER, conn.getDbdriver());
                pstconn.setString(FLD_DBURL, conn.getDburl());
                pstconn.setString(FLD_DBUSER, conn.getDbuser());
                pstconn.setString(FLD_DBPASSWD, conn.getDbpasswd());
                pstconn.setString(FLD_DBMINCONN, conn.getDbminconn());
                pstconn.setString(FLD_DBMAXCONN, conn.getDbmaxconn());
                pstconn.setString(FLD_LOGCONN, conn.getLogconn());
                pstconn.setString(FLD_LOGAPP, conn.getLogapp());
                pstconn.setString(FLD_LOGSIZE, conn.getLogsize());
                pstconn.setString(FLD_FORDATE, conn.getFordate());
                pstconn.setString(FLD_FORDECIMAL, conn.getFordecimal());
                pstconn.setString(FLD_FOR_CURRENCY, conn.getForcurrency());
                pstconn.setLong(FLD_CASH_MASTER_ID, conn.getCash_master_id());

                pstconn.update();

                return conn.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstConnection(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstConnection pstconn = new PstConnection(oid);
            pstconn.delete();

        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstConnection(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_P2_CONNECTION;
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
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
            }
            System.out.println("List sql : " + sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                OutletConnection conn = new OutletConnection();
                resultToObject(rs, conn);

                lists.add(conn);
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

    private static void resultToObject(ResultSet rs, OutletConnection conn) {
        try {
            //Pstconnection pstconn = new Pstconnection();
            conn.setOID(rs.getLong(PstConnection.fieldNames[PstConnection.FLD_ID_DBCONNECTION]));
            conn.setDbdriver(rs.getString(PstConnection.fieldNames[PstConnection.FLD_DBDRIVER]));
            conn.setDburl(rs.getString(PstConnection.fieldNames[PstConnection.FLD_DBURL]));
            conn.setDbuser(rs.getString(PstConnection.fieldNames[PstConnection.FLD_DBUSER]));
            conn.setDbpasswd(rs.getString(PstConnection.fieldNames[PstConnection.FLD_DBPASSWD]));
            conn.setDbminconn(rs.getString(PstConnection.fieldNames[PstConnection.FLD_DBMINCONN]));
            conn.setDbmaxconn(rs.getString(PstConnection.fieldNames[PstConnection.FLD_DBMAXCONN]));
            conn.setLogconn(rs.getString(PstConnection.fieldNames[PstConnection.FLD_LOGCONN]));
            conn.setLogapp(rs.getString(PstConnection.fieldNames[PstConnection.FLD_LOGAPP]));
            conn.setLogsize(rs.getString(PstConnection.fieldNames[PstConnection.FLD_LOGSIZE]));
            conn.setFordate(rs.getString(PstConnection.fieldNames[PstConnection.FLD_FORDATE]));
            conn.setFordecimal(rs.getString(PstConnection.fieldNames[PstConnection.FLD_FORDECIMAL]));
            conn.setForcurrency(rs.getString(PstConnection.fieldNames[PstConnection.FLD_FOR_CURRENCY]));
            conn.setCash_master_id(rs.getLong(PstConnection.fieldNames[PstConnection.FLD_CASH_MASTER_ID]));

    } catch (Exception e) {
            System.out.println(e);
        }
    }

    public static boolean checkOID(long oidconn) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_P2_CONNECTION + " WHERE "
                    + PstConnection.fieldNames[PstConnection.FLD_ID_DBCONNECTION] + " = " + oidconn;

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
            String sql = "SELECT COUNT(" + PstConnection.fieldNames[PstConnection.FLD_ID_DBCONNECTION] + ") FROM " + TBL_P2_CONNECTION;
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
                    OutletConnection internet = (OutletConnection) list.get(ls);
                    if (oid == internet.getOID()) {
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
   public static JSONObject fetchJSON(long oid){
      JSONObject object = new JSONObject();
      try {
         OutletConnection outletConnection = PstConnection.fetchExc(oid);
         object.put(PstConnection.fieldNames[PstConnection.FLD_ID_DBCONNECTION], outletConnection.getOID());
         object.put(PstConnection.fieldNames[PstConnection.FLD_DBDRIVER], outletConnection.getDbdriver());
         object.put(PstConnection.fieldNames[PstConnection.FLD_DBURL], outletConnection.getDburl());
         object.put(PstConnection.fieldNames[PstConnection.FLD_DBUSER], outletConnection.getDbuser());
         object.put(PstConnection.fieldNames[PstConnection.FLD_DBPASSWD], outletConnection.getDbpasswd());
         object.put(PstConnection.fieldNames[PstConnection.FLD_DBMINCONN], outletConnection.getDbminconn());
         object.put(PstConnection.fieldNames[PstConnection.FLD_DBMAXCONN], outletConnection.getDbmaxconn());
         object.put(PstConnection.fieldNames[PstConnection.FLD_LOGCONN], outletConnection.getLogconn());
         object.put(PstConnection.fieldNames[PstConnection.FLD_LOGAPP], outletConnection.getLogapp());
         object.put(PstConnection.fieldNames[PstConnection.FLD_LOGSIZE], outletConnection.getLogsize());
         object.put(PstConnection.fieldNames[PstConnection.FLD_FORDATE], outletConnection.getFordate());
         object.put(PstConnection.fieldNames[PstConnection.FLD_FORDECIMAL], outletConnection.getFordecimal());
         object.put(PstConnection.fieldNames[PstConnection.FLD_FOR_CURRENCY], outletConnection.getForcurrency());
         object.put(PstConnection.fieldNames[PstConnection.FLD_CASH_MASTER_ID], outletConnection.getCash_master_id());
      }catch(Exception exc){}
      return object;
   }


   public static long syncExc(JSONObject jSONObject){
      long oid = 0;
      if (jSONObject != null){
       oid = jSONObject.optLong(PstConnection.fieldNames[PstConnection.FLD_ID_DBCONNECTION],0);
         if (oid > 0){
          OutletConnection outletConnection = new OutletConnection();
          outletConnection.setOID(jSONObject.optLong(PstConnection.fieldNames[PstConnection.FLD_ID_DBCONNECTION],0));
          outletConnection.setDbdriver(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_DBDRIVER], ""));
          outletConnection.setDburl(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_DBURL], ""));
          outletConnection.setDbuser(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_DBUSER], ""));
          outletConnection.setDbpasswd(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_DBPASSWD], ""));
          outletConnection.setDbminconn(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_DBMINCONN], ""));
          outletConnection.setDbmaxconn(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_DBMAXCONN], ""));
          outletConnection.setLogconn(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_LOGCONN], ""));
          outletConnection.setLogapp(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_LOGAPP], ""));
          outletConnection.setLogsize(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_LOGSIZE], ""));
          outletConnection.setFordate(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_FORDATE], ""));
          outletConnection.setFordecimal(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_FORDECIMAL], ""));
          outletConnection.setForcurrency(jSONObject.optString(PstConnection.fieldNames[PstConnection.FLD_FOR_CURRENCY], ""));
          outletConnection.setCash_master_id(jSONObject.optLong(PstConnection.fieldNames[PstConnection.FLD_CASH_MASTER_ID],0));
         boolean checkOidOutletConnection = PstConnection.checkOID(oid);
          try{
            if(checkOidOutletConnection){
               PstConnection.updateExc(outletConnection);
            }else{
               PstConnection.insertByOid(outletConnection);
            }
         }catch(Exception exc){}
         }
      }
   return oid;
   }
   public static long insertByOid(OutletConnection outletConnection) throws DBException {
      try {
         PstConnection pstConnection = new PstConnection(0);
         pstConnection.setLong(FLD_ID_DBCONNECTION, outletConnection.getOID());
         pstConnection.setString(FLD_DBDRIVER, outletConnection.getDbdriver());
         pstConnection.setString(FLD_DBURL, outletConnection.getDburl());
         pstConnection.setString(FLD_DBUSER, outletConnection.getDbuser());
         pstConnection.setString(FLD_DBPASSWD, outletConnection.getDbpasswd());
         pstConnection.setString(FLD_DBMINCONN, outletConnection.getDbminconn());
         pstConnection.setString(FLD_DBMAXCONN, outletConnection.getDbmaxconn());
         pstConnection.setString(FLD_LOGCONN, outletConnection.getLogconn());
         pstConnection.setString(FLD_LOGAPP, outletConnection.getLogapp());
         pstConnection.setString(FLD_LOGSIZE, outletConnection.getLogsize());
         pstConnection.setString(FLD_FORDATE, outletConnection.getFordate());
         pstConnection.setString(FLD_FORDECIMAL, outletConnection.getFordecimal());
         pstConnection.setString(FLD_FOR_CURRENCY, outletConnection.getForcurrency());
         pstConnection.setLong(FLD_CASH_MASTER_ID, outletConnection.getCash_master_id());
         pstConnection.insertByOid(outletConnection.getOID());
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstConnection(0), DBException.UNKNOWN);
      }
      return outletConnection.getOID();
   }
}
