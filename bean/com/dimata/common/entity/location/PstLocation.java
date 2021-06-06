
/* Created on 	:  [date] [time] AM/PM
 *
 * @author  	: karya
 * @version  	: 01
 */
/**
 * *****************************************************************
 * Class Description : [project description ... ] Imput Parameters : [input
 * parameter ...] Output : [output ...]
 ******************************************************************
 */
package com.dimata.common.entity.location;

import java.sql.*;
import java.util.*;
import com.dimata.util.lang.I_Language;
import com.dimata.common.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.common.entity.contact.*;

//integrasi cashier vs hanoman
import com.dimata.ObjLink.BOPos.OutletLink;
import com.dimata.interfaces.BOPos.I_Outlet;
import com.dimata.common.entity.custom.*;
import com.dimata.common.entity.system.PstSystemProperty;
import com.dimata.posbo.entity.masterdata.*;
import com.dimata.services.WebServices;
import org.json.JSONArray;
import org.json.JSONObject;

public class PstLocation extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language, I_PersistentExcSynch, I_Outlet {

    //public static final  String TBL_P2_LOCATION = "LOCATION";
    public static final String TBL_P2_LOCATION = "location";
    public static final int FLD_LOCATION_ID = 0;
    public static final int FLD_NAME = 1;
    public static final int FLD_CONTACT_ID = 2;
    public static final int FLD_DESCRIPTION = 3;
    public static final int FLD_CODE = 4;
    public static final int FLD_ADDRESS = 5;
    public static final int FLD_TELEPHONE = 6;
    public static final int FLD_FAX = 7;
    public static final int FLD_PERSON = 8;
    public static final int FLD_EMAIL = 9;
    public static final int FLD_TYPE = 10;
    public static final int FLD_PARENT_LOCATION_ID = 11;
    public static final int FLD_WEBSITE = 12;
    // tambahan untuk proses di hanoman
    public static final int FLD_SERVICE_PERCENT = 13;
    public static final int FLD_TAX_PERCENT = 14;
    public static final int FLD_DEPARTMENT_ID = 15;
    public static final int FLD_USED_VAL = 16;
    public static final int FLD_SERVICE_VAL = 17;
    public static final int FLD_TAX_VALUE = 18;
    public static final int FLD_SERVICE_VAL_USD = 19;
    public static final int FLD_TAX_VALUE_USD = 20;
    public static final int FLD_REPORT_GROUP = 21;
    public static final int FLD_LOC_INDEX = 22;
    public static final int FLD_REGENCY_OID = 23;
    public static final int FLD_TAX_SVC_DEFAULT = 24;
    public static final String[] fieldNames = {
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
        "WEBSITE",
        "SERVICE_PERCENTAGE",
        "TAX_PERCENTAGE",
        "DEPARTMENT_ID",
        "USED_VALUE",
        "SERVICE_VALUE",
        "TAX_VALUE",
        "SERVICE_VALUE_USD",
        "TAX_VALUE_USD",
        "REPORT_GROUP",
        "LOC_INDEX",
        "REGENCY_ID",
        "TAX_SVC_DEFAULT"
    };
    public static final int[] fieldTypes = {
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
        TYPE_STRING,
        // INI DI GUNAKAN OLEH HANOMAN
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT
    };
    public static final int TYPE_LOCATION_WAREHOUSE = 0;
    public static final int TYPE_LOCATION_STORE = 1;
    public static final int TYPE_LOCATION_CARGO = 2;
    public static final int TYPE_LOCATION_VENDOR = 3;
    public static final int TYPE_LOCATION_TRANSFER = 4;
    public static final int TYPE_GALLERY_CUSTOMER = 5;
    public static final int TYPE_GALLERY_CONSIGNOR = 6;
    public static final int TYPE_LOCATION_DEPARTMENT = 7;
    public static final int TYPE_LOCATION_PROJECT = 8;
    public static final String[] fieldLocationType = {
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

    public PstLocation() {
    }

    public PstLocation(int i) throws DBException {
        super(new PstLocation());
    }

    public PstLocation(String sOid) throws DBException {
        super(new PstLocation(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstLocation(long lOid) throws DBException {
        super(new PstLocation(0));
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
        return TBL_P2_LOCATION;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstLocation().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        try {
            Location location = (Location) ent;
            long oid = ent.getOID();
            PstLocation pstLocation = new PstLocation(oid);
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
            location.setLocIndex(pstLocation.getInt(FLD_LOC_INDEX));

            // ini untuk hanoman
            location.setServicePersen(pstLocation.getdouble(FLD_SERVICE_PERCENT));
            location.setTaxPersen(pstLocation.getdouble(FLD_TAX_PERCENT));
            location.setDepartmentId(pstLocation.getlong(FLD_DEPARTMENT_ID));
            location.setTypeBase(pstLocation.getInt(FLD_USED_VAL));
            location.setServiceValue(pstLocation.getdouble(FLD_SERVICE_VAL));
            location.setTaxValue(pstLocation.getdouble(FLD_TAX_VALUE));
            location.setServiceValueUsd(pstLocation.getdouble(FLD_SERVICE_VAL_USD));
            location.setTaxValueUsd(pstLocation.getInt(FLD_TAX_VALUE_USD));
            location.setReportGroup(pstLocation.getInt(FLD_REPORT_GROUP));

            location.setRegencyId(pstLocation.getlong(FLD_REGENCY_OID));
            location.setTaxSvcDefault(pstLocation.getInt(FLD_TAX_SVC_DEFAULT));

            return location.getOID();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLocation(0), DBException.UNKNOWN);
        }
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Location) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Location) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Location fetchExc(long oid) {

        Location location = new Location();
        try {

            PstLocation pstLocation = new PstLocation(oid);
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
            location.setLocIndex(pstLocation.getInt(FLD_LOC_INDEX));

            // ini untuk hanoman
            location.setServicePersen(pstLocation.getdouble(FLD_SERVICE_PERCENT));
            location.setTaxPersen(pstLocation.getdouble(FLD_TAX_PERCENT));
            location.setDepartmentId(pstLocation.getlong(FLD_DEPARTMENT_ID));
            location.setTypeBase(pstLocation.getInt(FLD_USED_VAL));
            location.setServiceValue(pstLocation.getdouble(FLD_SERVICE_VAL));
            location.setTaxValue(pstLocation.getdouble(FLD_TAX_VALUE));
            location.setServiceValueUsd(pstLocation.getdouble(FLD_SERVICE_VAL_USD));
            location.setTaxValueUsd(pstLocation.getdouble(FLD_TAX_VALUE_USD));
            location.setReportGroup(pstLocation.getInt(FLD_REPORT_GROUP));

            location.setRegencyId(pstLocation.getlong(FLD_REGENCY_OID));
            location.setTaxSvcDefault(pstLocation.getInt(FLD_TAX_SVC_DEFAULT));

            String s = location.getName();
            return location;
        } catch (DBException dbe) {
            System.err.println(dbe);
        } catch (Exception e) {
            System.err.println(e);
        }
        return location;
    }

    public static void convertObjectToHashTableExc(Hashtable hashes, Location location) {
        try {
            hashes.put(fieldNames[FLD_NAME], location.getName());
            hashes.put(fieldNames[FLD_DESCRIPTION], location.getDescription());
            hashes.put(fieldNames[FLD_CODE], location.getCode());
            hashes.put(fieldNames[FLD_ADDRESS], location.getAddress());
            hashes.put(fieldNames[FLD_TELEPHONE], location.getTelephone());
            hashes.put(fieldNames[FLD_FAX], location.getFax());
            hashes.put(fieldNames[FLD_PERSON], location.getPerson());
            hashes.put(fieldNames[FLD_EMAIL], location.getEmail());
            hashes.put(fieldNames[FLD_TYPE], location.getType());
            hashes.put(fieldNames[FLD_PARENT_LOCATION_ID], location.getParentLocationId());
            hashes.put(fieldNames[FLD_WEBSITE], location.getWebsite());
            hashes.put(fieldNames[FLD_LOC_INDEX], location.getLocIndex());
            hashes.put(fieldNames[FLD_REGENCY_OID], location.getRegencyId());
        } catch (Exception e) {
            System.err.println(e);
        }
    }

    public static long insertExc(Location location) throws DBException {
        try {
            PstLocation pstLocation = new PstLocation(0);

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
            pstLocation.setInt(FLD_LOC_INDEX, location.getLocIndex());

            // ini hanya untuk di gunakan oleh hsnoman
            pstLocation.setDouble(FLD_SERVICE_PERCENT, location.getServicePersen());
            pstLocation.setDouble(FLD_TAX_PERCENT, location.getTaxPersen());
            pstLocation.setLong(FLD_DEPARTMENT_ID, location.getDepartmentId());
            pstLocation.setInt(FLD_USED_VAL, location.getTypeBase());
            pstLocation.setDouble(FLD_SERVICE_VAL, location.getServiceValue());
            pstLocation.setDouble(FLD_TAX_VALUE, location.getTaxValue());
            pstLocation.setDouble(FLD_SERVICE_VAL_USD, location.getServiceValueUsd());
            pstLocation.setDouble(FLD_TAX_VALUE_USD, location.getTaxValueUsd());
            pstLocation.setInt(FLD_REPORT_GROUP, location.getReportGroup());
            pstLocation.setInt(FLD_TAX_SVC_DEFAULT, location.getTaxSvcDefault());

            pstLocation.setLong(FLD_REGENCY_OID, location.getRegencyId());

            pstLocation.insert();

            long oidDataSync = PstDataSyncSql.insertExc(pstLocation.getInsertSQL());
            PstDataSyncStatus.insertExc(oidDataSync);
            location.setOID(pstLocation.getlong(FLD_LOCATION_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLocation(0), DBException.UNKNOWN);
        }
        return location.getOID();
    }

    public static long insertByOid(Location location) throws DBException {
        try {
            PstLocation pstLocation = new PstLocation(0);

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
            pstLocation.setInt(FLD_LOC_INDEX, location.getLocIndex());

            // ini hanya untuk di gunakan oleh hsnoman
            pstLocation.setDouble(FLD_SERVICE_PERCENT, location.getServicePersen());
            pstLocation.setDouble(FLD_TAX_PERCENT, location.getTaxPersen());
            pstLocation.setLong(FLD_DEPARTMENT_ID, location.getDepartmentId());
            pstLocation.setInt(FLD_USED_VAL, location.getTypeBase());
            pstLocation.setDouble(FLD_SERVICE_VAL, location.getServiceValue());
            pstLocation.setDouble(FLD_TAX_VALUE, location.getTaxValue());
            pstLocation.setDouble(FLD_SERVICE_VAL_USD, location.getServiceValueUsd());
            pstLocation.setDouble(FLD_TAX_VALUE_USD, location.getTaxValueUsd());
            pstLocation.setInt(FLD_REPORT_GROUP, location.getReportGroup());
            pstLocation.setInt(FLD_TAX_SVC_DEFAULT, location.getTaxSvcDefault());

            pstLocation.setLong(FLD_REGENCY_OID, location.getRegencyId());

            pstLocation.insertByOid(location.getOID());

        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLocation(0), DBException.UNKNOWN);
        }
        return location.getOID();
    }

    public static long updateExc(Location location) throws DBException {
        try {
            if (location.getOID() != 0) {
                PstLocation pstLocation = new PstLocation(location.getOID());

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
                pstLocation.setInt(FLD_LOC_INDEX, location.getLocIndex());

                // ini hanya untuk di gunakan oleh hsnoman
                pstLocation.setDouble(FLD_SERVICE_PERCENT, location.getServicePersen());
                pstLocation.setDouble(FLD_TAX_PERCENT, location.getTaxPersen());
                pstLocation.setLong(FLD_DEPARTMENT_ID, location.getDepartmentId());
                pstLocation.setInt(FLD_USED_VAL, location.getTypeBase());
                pstLocation.setDouble(FLD_SERVICE_VAL, location.getServiceValue());
                pstLocation.setDouble(FLD_TAX_VALUE, location.getTaxValue());
                pstLocation.setDouble(FLD_SERVICE_VAL_USD, location.getServiceValueUsd());
                pstLocation.setDouble(FLD_TAX_VALUE_USD, location.getTaxValueUsd());
                pstLocation.setInt(FLD_REPORT_GROUP, location.getReportGroup());
                pstLocation.setInt(FLD_TAX_SVC_DEFAULT, location.getTaxSvcDefault());

                pstLocation.setLong(FLD_REGENCY_OID, location.getRegencyId());

                pstLocation.update();

                long oidDataSync = PstDataSyncSql.insertExc(pstLocation.getUpdateSQL());
                PstDataSyncStatus.insertExc(oidDataSync);
                return location.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLocation(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstLocation pstLocation = new PstLocation(oid);
            pstLocation.delete();

            long oidDataSync = PstDataSyncSql.insertExc(pstLocation.getDeleteSQL());
            PstDataSyncStatus.insertExc(oidDataSync);

        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLocation(0), DBException.UNKNOWN);
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
            String sql = "SELECT * FROM " + TBL_P2_LOCATION;
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
                Location location = new Location();
                resultToObject(rs, location);
                lists.add(location);
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

    public static Vector getListFromApiAll() {
        return getListFromApi(0, 0, "", "");
    }

    public static Vector getListFromApi(int limitStart, int recordToGet, String whereClause, String order) {
        JSONArray lists = new JSONArray();
        String apiUrl = PstSystemProperty.getValueByName("POS_API_URL");
        String param = "limitStart=" + WebServices.encodeUrl("" + limitStart) + "&recordToGet=" + WebServices.encodeUrl("" + recordToGet)
                + "&whereClause=" + WebServices.encodeUrl(whereClause) + "&order=" + WebServices.encodeUrl("");
        JSONObject jo = WebServices.getAPIWithParam("", apiUrl + "/master/location-list", param);
        Vector listData = new Vector(1, 1);
        try {
            lists = jo.getJSONArray("DATA");
            for (int i = 0; i < lists.length(); i++) {
                JSONObject tempObj = lists.getJSONObject(i);
                Location loc = new Location();
                convertJsonToObject(tempObj, loc);
                listData.add(loc);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return listData;
    }

    public static int getCountFromApi(int limitStart, int recordToGet, String whereClause, String order) {
        String apiUrl = PstSystemProperty.getValueByName("POS_API_URL");
        String param = "limitStart=" + WebServices.encodeUrl("" + limitStart) + "&recordToGet=" + WebServices.encodeUrl("" + recordToGet)
                + "&whereClause=" + WebServices.encodeUrl(whereClause) + "&order=" + WebServices.encodeUrl("");
        JSONObject jo = WebServices.getAPIWithParam("", apiUrl + "/master/location-list", param);
        int count = 0;
        try {
            count = jo.getInt("COUNT");
        } catch (Exception e) {
            System.out.println(e);
        }
        return count;
    }

    public static Location fetchFromApi(long oid) {
        Location loc = new Location();
        String whereClause = PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + "=" + oid;
        Vector getList = getListFromApi(0, 0, whereClause, "");
        try {
            if (!getList.isEmpty()) {
                loc = (Location) getList.get(0);
                if (checkOID(loc.getOID())) {
                    updateExc(loc);
                } else {
                    insertByOid(loc);
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return loc;
    }

    private static void resultToObject(ResultSet rs, Location location) {
        try {
            location.setOID(rs.getLong(PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID]));
            location.setName(rs.getString(PstLocation.fieldNames[PstLocation.FLD_NAME]));
            location.setContactId(rs.getLong(PstLocation.fieldNames[PstLocation.FLD_CONTACT_ID]));
            location.setDescription(rs.getString(PstLocation.fieldNames[PstLocation.FLD_DESCRIPTION]));
            location.setCode(rs.getString(PstLocation.fieldNames[PstLocation.FLD_CODE]));
            location.setAddress(rs.getString(PstLocation.fieldNames[PstLocation.FLD_ADDRESS]));
            location.setTelephone(rs.getString(PstLocation.fieldNames[PstLocation.FLD_TELEPHONE]));
            location.setFax(rs.getString(PstLocation.fieldNames[PstLocation.FLD_FAX]));
            location.setPerson(rs.getString(PstLocation.fieldNames[PstLocation.FLD_PERSON]));
            location.setEmail(rs.getString(PstLocation.fieldNames[PstLocation.FLD_EMAIL]));
            location.setType(rs.getInt(PstLocation.fieldNames[PstLocation.FLD_TYPE]));
            location.setParentLocationId(rs.getLong(PstLocation.fieldNames[PstLocation.FLD_PARENT_LOCATION_ID]));
            location.setWebsite(rs.getString(PstLocation.fieldNames[PstLocation.FLD_WEBSITE]));
            location.setLocIndex(rs.getInt(PstLocation.fieldNames[PstLocation.FLD_LOC_INDEX]));
            // ini digunakan oleh hanoman
            location.setServicePersen(rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_SERVICE_PERCENT]));
            location.setTaxPersen(rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_TAX_PERCENT]));
            location.setDepartmentId(rs.getLong(PstLocation.fieldNames[PstLocation.FLD_DEPARTMENT_ID]));
            location.setTypeBase(rs.getInt(PstLocation.fieldNames[PstLocation.FLD_USED_VAL]));
            location.setServiceValue(rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_SERVICE_VAL]));
            location.setTaxValue(rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_TAX_VALUE]));
            location.setServiceValueUsd(rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_SERVICE_VAL_USD]));
            location.setTaxValueUsd(rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_TAX_VALUE_USD]));
            location.setReportGroup(rs.getInt(PstLocation.fieldNames[PstLocation.FLD_REPORT_GROUP]));
            location.setTaxSvcDefault(rs.getInt(PstLocation.fieldNames[PstLocation.FLD_TAX_SVC_DEFAULT]));

        } catch (Exception e) {
        }
    }

    public static void convertJsonToObject(JSONObject obj, Location entLocation) {
        try {
            entLocation.setOID(obj.optLong(PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID], 0));
            entLocation.setName(obj.optString(PstLocation.fieldNames[PstLocation.FLD_NAME], ""));
            entLocation.setContactId(obj.optLong(PstLocation.fieldNames[PstLocation.FLD_CONTACT_ID], 7));
            entLocation.setDescription(obj.optString(PstLocation.fieldNames[PstLocation.FLD_DESCRIPTION], ""));
            entLocation.setCode(obj.optString(PstLocation.fieldNames[PstLocation.FLD_CODE], ""));
            entLocation.setAddress(obj.optString(PstLocation.fieldNames[PstLocation.FLD_ADDRESS], ""));
            entLocation.setTelephone(obj.optString(PstLocation.fieldNames[PstLocation.FLD_TELEPHONE], ""));
            entLocation.setFax(obj.optString(PstLocation.fieldNames[PstLocation.FLD_FAX], ""));
            entLocation.setPerson(obj.optString(PstLocation.fieldNames[PstLocation.FLD_PERSON], ""));
            entLocation.setEmail(obj.optString(PstLocation.fieldNames[PstLocation.FLD_EMAIL], ""));
            entLocation.setType(obj.optInt(PstLocation.fieldNames[PstLocation.FLD_TYPE], 0));
            entLocation.setParentLocationId(obj.optInt(PstLocation.fieldNames[PstLocation.FLD_PARENT_LOCATION_ID], 0));
            entLocation.setWebsite(obj.optString(PstLocation.fieldNames[PstLocation.FLD_WEBSITE], ""));
            entLocation.setLocIndex(obj.optInt(PstLocation.fieldNames[PstLocation.FLD_LOC_INDEX], 0));
            entLocation.setTaxSvcDefault(obj.optInt(PstLocation.fieldNames[PstLocation.FLD_TAX_SVC_DEFAULT], 0));
            entLocation.setTaxPersen(obj.optInt(PstLocation.fieldNames[PstLocation.FLD_TAX_PERCENT], 0));
            entLocation.setDepartmentId(obj.optLong(PstLocation.fieldNames[PstLocation.FLD_DEPARTMENT_ID], 0));
            entLocation.setRegencyId(obj.optLong(PstLocation.fieldNames[PstLocation.FLD_REGENCY_OID], 0));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long locationId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_P2_LOCATION + " WHERE "
                    + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " = " + locationId;

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
            String sql = "SELECT COUNT(" + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + ") FROM " + TBL_P2_LOCATION;
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
                    Location location = (Location) list.get(ls);
                    if (oid == location.getOID()) {
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

    private static Vector list(long oidLocation) {

        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT LOC.* "
                    + ", CONT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_NAME]
                    + ", CONT." + PstContactList.fieldNames[PstContactList.FLD_PERSON_LASTNAME]
                    + " FROM " + TBL_P2_LOCATION + " LOC "
                    + " LEFT JOIN " + PstContactList.TBL_CONTACT_LIST + " CONT "
                    + " ON LOC." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID]
                    + " = CONT." + PstContactList.fieldNames[PstContactList.FLD_CONTACT_ID]
                    + " WHERE LOC." + fieldNames[FLD_PARENT_LOCATION_ID] + (oidLocation == 0 ? " IS NULL" : (" = " + oidLocation));

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector temp = new Vector(1, 1);
                Location location = new Location();
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

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector getNestedLocation(long oid, Vector result) {
        try {
            Vector locations = PstLocation.list(oid);

            if ((locations.size() < 1) || (locations == null)) {
                return new Vector(1, 1);
            } else {
                for (int pd = 0; pd < locations.size(); pd++) {
                    Vector temp = (Vector) locations.get(pd);
                    Location location = (Location) temp.get(0);
                    oid = location.getOID();
                    long parent = location.getParentLocationId();
                    int indent = ifExist(result, parent);
                    location.setCode(indent + "/" + location.getCode());
                    temp.setElementAt(location, 0);
                    result.add(temp);
                    getNestedLocation(oid, result);
                }
            }
            return result;
        } catch (Exception exc) {
            return null;
        }
    }

    private static int ifExist(Vector result, long parent) {
        int indent = 0;
        for (int i = 0; i < result.size(); i++) {
            Vector temp = (Vector) result.get(i);
            Location location = (Location) temp.get(0);
            long oid = location.getOID();
            if (parent == oid) {
                String locCode = location.getCode();
                int idn = locCode.indexOf("/");
                int existIdn = 0;
                if (idn > 0) {
                    existIdn = Integer.parseInt(locCode.substring(0, idn));
                }
                indent = existIdn + 1;
            }
        }
        return indent;
    }

    /**
     * * function for data synchronization **
     */
    public long insertExcSynch(Entity ent) throws Exception {
        return insertExcSynch((Location) ent);
    }

    public static long insertExcSynch(Location location) throws DBException {
        long newOID = 0;
        long originalOID = location.getOID();
        try {
            newOID = insertExc(location);
            if (newOID != 0) {  // sukses insert ?
                updateSynchOID(newOID, originalOID);
                return originalOID;
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstLocation(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long updateSynchOID(long newOID, long originalOID) throws DBException {
        DBResultSet dbrs = null;
        try {
            String sql = "UPDATE " + PstLocation.TBL_P2_LOCATION + " SET "
                    + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID] + " = " + originalOID
                    + " WHERE " + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID]
                    + " = " + newOID;

            int Result = DBHandler.execUpdate(sql);

            return originalOID;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }

    public static Location fetchByCode(String code) {
        com.dimata.posbo.db.DBResultSet dbrs = null;
        Location loc = new Location();
        try {
            String sql = "SELECT * FROM " + TBL_P2_LOCATION
                    + " WHERE " + fieldNames[FLD_CODE]
                    + " = '" + code + "'";
            dbrs = com.dimata.posbo.db.DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                resultToObject(rs, loc);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            com.dimata.posbo.db.DBResultSet.close(dbrs);
        }
        return loc;
    }

    //Id Mesin
    public static Location fetchByIdMachine(String codeMachine) {
        com.dimata.posbo.db.DBResultSet dbrs = null;
        Location loc = new Location();
        try {
            String sql = "SELECT * FROM " + TBL_P2_LOCATION
                    + " WHERE LEFT(" + fieldNames[FLD_DESCRIPTION] + ", 3)"
                    + " = '" + codeMachine + "'";
            dbrs = com.dimata.posbo.db.DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                resultToObject(rs, loc);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            com.dimata.posbo.db.DBResultSet.close(dbrs);
        }
        return loc;
    }

    //===============================================================
    //INTEGRASI HANOMAN VS POS
    public long deleteOutlet(OutletLink outletLink) {
        try {
            //long oid = deleteByLocationId(outletLink.getOutletId());
            PstLocation.deleteExc(outletLink.getOutletId());
        } catch (Exception e) {
            System.out.println("exception e :: " + e.toString());
        }
        return outletLink.getOutletId();
    }

    public long insertOutlet(OutletLink outletLink) {
        Location location = new Location();
        location.setName(outletLink.getName());
        location.setCode(outletLink.getCode());
        location.setDescription(outletLink.getDescription());
        location.setType(PstLocation.TYPE_LOCATION_STORE);
        location.setAddress("-");

        long oid = 0;
        try {
            oid = PstLocation.insertExc(location);
            oid = synchronizeOID(oid, outletLink.getOutletId());
        } catch (Exception e) {
        }

        return oid;
    }

    public long synchronizeOID(long oldOID, long newOID) {
        String sql = "UPDATE " + TBL_P2_LOCATION
                + " SET " + fieldNames[FLD_LOCATION_ID] + "=" + newOID
                + " WHERE " + fieldNames[FLD_LOCATION_ID] + "=" + oldOID;

        try {
            DBHandler.execUpdate(sql);
        } catch (Exception e) {
            return 0;
        }

        return newOID;
    }

    public long updateOutlet(OutletLink outletLink) {

        System.out.println("in - MATERIAL -update outlet || location");
        System.out.println("outletLink.getOutletId() : " + outletLink.getOutletId());

        Location location = new Location();
        long oid = 0;

        try {

            location = PstLocation.fetchExc(outletLink.getOutletId());

            location.setName(outletLink.getName());
            location.setCode(outletLink.getCode());
            location.setDescription(outletLink.getDescription());
            location.setType(PstLocation.TYPE_LOCATION_STORE);

            oid = PstLocation.updateExc(location);

        } catch (Exception e) {
            System.out.println("Exception e : " + e.toString());
        }

        return oid;

    }
    //end END INTEGRASI

    /**
     * * -------------------------- **
     */
    public static long getLocationByType(int type) {
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT " + PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID]
                    + " FROM " + TBL_P2_LOCATION
                    + " WHERE " + PstLocation.fieldNames[PstLocation.FLD_TYPE]
                    + " = " + type;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            long oid = 0;
            while (rs.next()) {
                oid = rs.getLong(1);
            }
            rs.close();
            return oid;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return 0;

    }

    public static Vector listLocationAssign(long userId, String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = " SELECT LOC.* "
                    + " FROM " + TBL_P2_LOCATION + " LOC "
                    + " INNER JOIN " + PstDataCustom.TBL_DATA_CUSTOM + " DC "
                    + " ON DC." + PstDataCustom.fieldNames[PstDataCustom.FLD_DATA_VALUE]
                    + " = " + fieldNames[PstLocation.FLD_LOCATION_ID]
                    + " WHERE " + PstDataCustom.fieldNames[PstDataCustom.FLD_OWNER_ID]
                    + " = " + userId;

            if (whereClause != null && whereClause.length() > 0) {
                sql += " AND LOC." + whereClause;
            }

            sql = sql + " ORDER BY LOC." + fieldNames[PstLocation.FLD_NAME];

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();
            while (rs.next()) {
                Location location = new Location();
                PstLocation.resultToObject(rs, location);
                result.add(location);
            }
            rs.close();
            return result;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();

    }

    /**
     * fungsi ini digunakan untuk mendapatkan list location dalam bentuk
     * hashtable create by: gwawan@dimata 26 Sep 2007
     *
     * @param
     * @return Hashtable
     */
    public static Hashtable getHashListLocation() {
        Hashtable hash = new Hashtable();
        try {
            Vector vctLocation = PstLocation.list(0, 0, "", "");
            for (int i = 0; i < vctLocation.size(); i++) {
                Location location = (Location) vctLocation.get(i);
                hash.put(String.valueOf(location.getOID()), location.getName());
            }
        } catch (Exception e) {
            System.out.println("Exc. in hashListLocation: " + e.toString());
        }
        return hash;
    }

    public static long syncExc(JSONObject jSONObject) {
        long oid = 0;
        if (jSONObject != null) {
            oid = jSONObject.optLong(PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID], 0);
            if (oid > 0) {
                Location location = new Location();
                location.setOID(jSONObject.optLong(PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID], 0));
                location.setName(jSONObject.optString(PstLocation.fieldNames[PstLocation.FLD_NAME], ""));
                location.setContactId(jSONObject.optLong(PstLocation.fieldNames[PstLocation.FLD_CONTACT_ID], 0));
                location.setDescription(jSONObject.optString(PstLocation.fieldNames[PstLocation.FLD_DESCRIPTION], ""));
                location.setCode(jSONObject.optString(PstLocation.fieldNames[PstLocation.FLD_CODE], ""));
                location.setAddress(jSONObject.optString(PstLocation.fieldNames[PstLocation.FLD_ADDRESS], ""));
                location.setTelephone(jSONObject.optString(PstLocation.fieldNames[PstLocation.FLD_TELEPHONE], ""));
                location.setFax(jSONObject.optString(PstLocation.fieldNames[PstLocation.FLD_FAX], ""));
                location.setPerson(jSONObject.optString(PstLocation.fieldNames[PstLocation.FLD_PERSON], ""));
                location.setEmail(jSONObject.optString(PstLocation.fieldNames[PstLocation.FLD_EMAIL], ""));
                location.setType(jSONObject.optInt(PstLocation.fieldNames[PstLocation.FLD_TYPE], 0));
                location.setParentLocationId(jSONObject.optLong(PstLocation.fieldNames[PstLocation.FLD_PARENT_LOCATION_ID], 0));
                location.setWebsite(jSONObject.optString(PstLocation.fieldNames[PstLocation.FLD_WEBSITE], ""));
                location.setServicePersen(jSONObject.optDouble(PstLocation.fieldNames[PstLocation.FLD_SERVICE_PERCENT], 0));
                location.setTaxPersen(jSONObject.optDouble(PstLocation.fieldNames[PstLocation.FLD_TAX_PERCENT], 0));
                location.setDepartmentId(jSONObject.optLong(PstLocation.fieldNames[PstLocation.FLD_DEPARTMENT_ID], 0));
                location.setTypeBase(jSONObject.optInt(PstLocation.fieldNames[PstLocation.FLD_USED_VAL], 0));
                location.setServiceValue(jSONObject.optDouble(PstLocation.fieldNames[PstLocation.FLD_SERVICE_VAL], 0));
                location.setTaxValue(jSONObject.optDouble(PstLocation.fieldNames[PstLocation.FLD_TAX_VALUE], 0));
                location.setServiceValueUsd(jSONObject.optDouble(PstLocation.fieldNames[PstLocation.FLD_SERVICE_VAL_USD], 0));
                location.setTaxValueUsd(jSONObject.optDouble(PstLocation.fieldNames[PstLocation.FLD_TAX_VALUE_USD], 0));
                location.setReportGroup(jSONObject.optInt(PstLocation.fieldNames[PstLocation.FLD_REPORT_GROUP], 0));
                location.setLocIndex(jSONObject.optInt(PstLocation.fieldNames[PstLocation.FLD_LOC_INDEX], 0));
                location.setTaxSvcDefault(jSONObject.optInt(PstLocation.fieldNames[PstLocation.FLD_TAX_SVC_DEFAULT], 0));

                boolean checkOid = PstLocation.checkOID(oid);
                try {
                    if (checkOid) {
                        PstLocation.updateExc(location);
                    } else {
                        PstLocation.insertByOid(location);
                    }
                } catch (Exception exc) {
                }
            }
        }
        return oid;
    }

    public static void resultToObjectJson(ResultSet rs, JSONObject obj) {
        try {
            obj.put(PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID], rs.getLong(PstLocation.fieldNames[PstLocation.FLD_LOCATION_ID]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_NAME], rs.getString(PstLocation.fieldNames[PstLocation.FLD_NAME]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_CONTACT_ID], rs.getLong(PstLocation.fieldNames[PstLocation.FLD_CONTACT_ID]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_DESCRIPTION], rs.getString(PstLocation.fieldNames[PstLocation.FLD_DESCRIPTION]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_CODE], rs.getString(PstLocation.fieldNames[PstLocation.FLD_CODE]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_ADDRESS], rs.getString(PstLocation.fieldNames[PstLocation.FLD_ADDRESS]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_TELEPHONE], rs.getString(PstLocation.fieldNames[PstLocation.FLD_TELEPHONE]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_FAX], rs.getString(PstLocation.fieldNames[PstLocation.FLD_FAX]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_PERSON], rs.getString(PstLocation.fieldNames[PstLocation.FLD_PERSON]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_EMAIL], rs.getString(PstLocation.fieldNames[PstLocation.FLD_EMAIL]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_TYPE], rs.getInt(PstLocation.fieldNames[PstLocation.FLD_TYPE]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_PARENT_LOCATION_ID], rs.getLong(PstLocation.fieldNames[PstLocation.FLD_PARENT_LOCATION_ID]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_WEBSITE], rs.getString(PstLocation.fieldNames[PstLocation.FLD_WEBSITE]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_SERVICE_PERCENT], rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_SERVICE_PERCENT]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_TAX_PERCENT], rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_TAX_PERCENT]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_DEPARTMENT_ID], rs.getLong(PstLocation.fieldNames[PstLocation.FLD_DEPARTMENT_ID]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_USED_VAL], rs.getInt(PstLocation.fieldNames[PstLocation.FLD_USED_VAL]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_SERVICE_VAL], rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_SERVICE_VAL]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_TAX_VALUE], rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_TAX_VALUE]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_SERVICE_VAL_USD], rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_SERVICE_VAL_USD]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_TAX_VALUE_USD], rs.getDouble(PstLocation.fieldNames[PstLocation.FLD_TAX_VALUE_USD]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_REPORT_GROUP], rs.getLong(PstLocation.fieldNames[PstLocation.FLD_REPORT_GROUP]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_LOC_INDEX], rs.getInt(PstLocation.fieldNames[PstLocation.FLD_LOC_INDEX]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_REGENCY_OID], rs.getLong(PstLocation.fieldNames[PstLocation.FLD_REGENCY_OID]));
            obj.put(PstLocation.fieldNames[PstLocation.FLD_TAX_SVC_DEFAULT], rs.getInt(PstLocation.fieldNames[PstLocation.FLD_TAX_SVC_DEFAULT]));
        } catch (Exception e) {
        }
    }

}
