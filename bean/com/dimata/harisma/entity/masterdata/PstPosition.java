
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	:  [authorName] 
 * @version  	:  [version] 
 */
/** *****************************************************************
 * Class Description 	: [project description ... ]
 * Imput Parameters 	: [input parameter ...]
 * Output 		: [output ...]
 ****************************************************************** */
package com.dimata.harisma.entity.masterdata;

/* package java */
import com.dimata.common.entity.system.PstSystemProperty;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;

/* package  harisma */
//import com.dimata.harisma.db.DBHandler;
//import com.dimata.harisma.db.DBException;
//import com.dimata.harisma.db.DBLogger;
import com.dimata.harisma.entity.masterdata.*;
import com.dimata.harisma.entity.employee.*;
import com.dimata.services.WebServices;
import org.json.JSONArray;
import org.json.JSONObject;

public class PstPosition extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_HR_POSITION = "hr_position";

    public static final int FLD_POSITION_ID = 0;
    public static final int FLD_POSITION = 1;
    public static final int FLD_DESCRIPTION = 2;

    public static final String[] fieldNames = {
        "POSITION_ID",
        "POSITION",
        "DESCRIPTION"
    };

    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };

    public PstPosition() {
    }

    public PstPosition(int i) throws DBException {
        super(new PstPosition());
    }

    public PstPosition(String sOid) throws DBException {
        super(new PstPosition(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstPosition(long lOid) throws DBException {
        super(new PstPosition(0));
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
        return TBL_HR_POSITION;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstPosition().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Position position = fetchExc(ent.getOID());
        ent = (Entity) position;
        return position.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Position) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Position) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Position fetchExc(long oid) throws DBException {
        try {
            Position position = new Position();
            PstPosition pstPosition = new PstPosition(oid);
            position.setOID(oid);

            position.setPosition(pstPosition.getString(FLD_POSITION));
            position.setDescription(pstPosition.getString(FLD_DESCRIPTION));

            return position;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPosition(0), DBException.UNKNOWN);
        }
    }

    public static long insertExc(Position position) throws DBException {
        try {
            PstPosition pstPosition = new PstPosition(0);

            pstPosition.setString(FLD_POSITION, position.getPosition());
            pstPosition.setString(FLD_DESCRIPTION, position.getDescription());

            pstPosition.insert();
            position.setOID(pstPosition.getlong(FLD_POSITION_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPosition(0), DBException.UNKNOWN);
        }
        return position.getOID();
    }

    public static long updateExc(Position position) throws DBException {
        try {
            if (position.getOID() != 0) {
                PstPosition pstPosition = new PstPosition(position.getOID());

                pstPosition.setString(FLD_POSITION, position.getPosition());
                pstPosition.setString(FLD_DESCRIPTION, position.getDescription());

                pstPosition.update();
                return position.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPosition(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstPosition pstPosition = new PstPosition(oid);
            pstPosition.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPosition(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_HR_POSITION;
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
                Position position = new Position();
                resultToObject(rs, position);
                lists.add(position);
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

    public static void resultToObject(ResultSet rs, Position position) {
        try {
            position.setOID(rs.getLong(PstPosition.fieldNames[PstPosition.FLD_POSITION_ID]));
            position.setPosition(rs.getString(PstPosition.fieldNames[PstPosition.FLD_POSITION]));
            position.setDescription(rs.getString(PstPosition.fieldNames[PstPosition.FLD_DESCRIPTION]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long positionId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_HR_POSITION + " WHERE "
                    + PstPosition.fieldNames[PstPosition.FLD_POSITION_ID] + " = " + positionId;

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
            String sql = "SELECT COUNT(" + PstPosition.fieldNames[PstPosition.FLD_POSITION_ID] + ") FROM " + TBL_HR_POSITION;
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
                    Position position = (Position) list.get(ls);
                    if (oid == position.getOID()) {
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

    public static boolean checkMaster(long oid) {
        if (PstEmployee.checkPosition(oid)) {
            return true;
        } else {
            if (PstCareerPath.checkPosition(oid)) {
                return true;
            } else {
                return false;
            }

        }
    }

    public static Vector getListFromApiAll() {
        return getListFromApi(0, 0, "", "");
    }
    
    public static Vector getListFromApi(int limitStart, int recordToGet, String whereClause, String order){
        JSONArray lists = new JSONArray();
        String hrUrl = PstSystemProperty.getValueByName("HARISMA_URL");
        String param = "limitStart=" + WebServices.encodeUrl("" + limitStart) + "&recordToGet=" + WebServices.encodeUrl("" + recordToGet)
                + "&whereClause=" + WebServices.encodeUrl(whereClause) + "&order=" + WebServices.encodeUrl("");
        JSONObject jo = WebServices.getAPIWithParam("", hrUrl + "/employee/position-list", param);
        Vector listData = new Vector(1, 1);
        try {
            lists = jo.getJSONArray("DATA");
            for (int i = 0; i < lists.length(); i++) {
                JSONObject tempObj = lists.getJSONObject(i);
                Position position =  new Position();
                convertJsonToObject(tempObj, position);
                listData.add(position);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return listData;
    }
    
    public static void convertJsonToObject(JSONObject obj, Position position) {
        try {
            position.setOID(obj.optLong(PstPosition.fieldNames[PstPosition.FLD_POSITION_ID], 0));
            position.setPosition(obj.optString(PstPosition.fieldNames[PstPosition.FLD_POSITION], ""));
            position.setDescription(obj.optString(PstPosition.fieldNames[PstPosition.FLD_DESCRIPTION], ""));
        } catch (Exception e) {
        }
    }
}
