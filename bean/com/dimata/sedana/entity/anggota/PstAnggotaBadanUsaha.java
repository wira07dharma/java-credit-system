/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.anggota;

import com.dimata.common.entity.contact.PstContactClass;
import com.dimata.common.entity.contact.PstContactClassAssign;
import com.dimata.qdep.db.DBException;
import com.dimata.qdep.db.DBHandler;
import com.dimata.qdep.db.DBResultSet;
import com.dimata.qdep.db.I_DBInterface;
import com.dimata.qdep.db.I_DBType;
import com.dimata.qdep.entity.*;
import com.dimata.qdep.entity.I_PersintentExc;
import com.dimata.util.Formater;
import com.dimata.util.lang.I_Language;
import com.mysql.jdbc.ResultSet;
import java.util.Vector;
import org.json.JSONObject;

/**
 *
 * @author HaddyPuutraa (PKL) Created Kamis, 21 Pebruari 2013
 */
public class PstAnggotaBadanUsaha extends DBHandler implements I_Language, I_DBType, I_DBInterface, I_PersintentExc {

    public static final String TBL_ANGGOTA = "contact_list";

    public static final int FLD_ID_ANGGOTA = 0;
    public static final int FLD_NO_ANGGOTA = 1;
    public static final int FLD_NAME = 2;
    public static final int FLD_SEX = 3;
    public static final int FLD_OFFICE_ADDRESS = 4;
    public static final int FLD_ADDR_OFFICE_CITY = 5;
    public static final int FLD_ID_CARD = 6;
    public static final int FLD_TLP = 7;
    public static final int FLD_EMAIL = 8;
    public static final int FLD_NO_NPWP = 9;
    public static final int FLD_REG_DATE = 10;
    public static final int FLD_JENIS_TRANSAKSI_ID = 11;

    public static String[] fieldNames = {
        "CONTACT_ID",//0
        "CONTACT_CODE",//1
        "PERSON_NAME",//2
        "MEMBER_SEX",//3
        "HOME_ADDRESS",//4
        "MEMBER_COMP_CITY", //5
        "KTP_NO",//6
        "TELP_NR",//7
        "EMAIL",//8
        "NO_NPWP",//9
        "REG_DATE",//10
        "JENIS_TRANSAKSI_ID"//11
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_ID + TYPE_PK,//0
        TYPE_STRING,//1
        TYPE_STRING,//2
        TYPE_INT,//3
        TYPE_STRING,//4
        TYPE_LONG, //5
        TYPE_STRING,//6
        TYPE_STRING,//7
        TYPE_STRING,//8
        TYPE_STRING,//9
        TYPE_DATE,//10
        TYPE_LONG
    };

    public static final int MALE = 0;
    public static final int FEMALE = 1;

    public static final String[][] sexKey = {{"Laki-Laki", "Perempuan"}, {"Male", "Female"}};
    public static final int[] sexValue = {0, 1};

    //Tambahan tanggal 26 Pebruari 2013
    public static final int DRAFT = 0;
    public static final int ACTIVE = 1;
    public static final int MUTASI = 2;

    public static final String[] statusKey = {"Draft", "Active", "Mutasi"};
    public static final int[] statusValue = {0, 1, 2};

    public static Vector getStatusKey() {
        Vector result = new Vector(1, 1);
        for (int i = 0; i < statusKey.length; i++) {
            result.add(statusKey[i]);
        }
        return result;
    }

    public static Vector getStatusValue() {
        Vector value = new Vector(1, 1);
        for (int i = 0; i < statusValue.length; i++) {
            value.add(Integer.toString(i));
        }
        return value;
    }

    public int index;

    public int getIndex() {
        return this.index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public String getTableName() {
        return TBL_ANGGOTA;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstAnggotaBadanUsaha().getClass().getName();
    }

    public PstAnggotaBadanUsaha() {
    }

    public PstAnggotaBadanUsaha(int i) throws DBException {
        super(new PstAnggotaBadanUsaha());
    }

    public PstAnggotaBadanUsaha(String sOid) throws DBException {
        super(new PstAnggotaBadanUsaha(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstAnggotaBadanUsaha(long lOid) throws DBException {
        super(new PstAnggotaBadanUsaha(0));
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

    public static AnggotaBadanUsaha fetchExc(long oid) throws DBException {
        AnggotaBadanUsaha anggota = new AnggotaBadanUsaha();
        try {
            PstAnggotaBadanUsaha pstAnggota = new PstAnggotaBadanUsaha(oid);
            anggota.setOID(oid);
            anggota.setNoAnggota(pstAnggota.getString(FLD_NO_ANGGOTA));
            anggota.setName(pstAnggota.getString(FLD_NAME));
            anggota.setSex(pstAnggota.getInt(FLD_SEX));
            anggota.setOfficeAddress(pstAnggota.getString(FLD_OFFICE_ADDRESS));
            anggota.setAddressOfficeCity(pstAnggota.getlong(FLD_ADDR_OFFICE_CITY));
            anggota.setIdCard(pstAnggota.getString(FLD_ID_CARD));
            anggota.setTelepon(pstAnggota.getString(FLD_TLP));
            anggota.setEmail(pstAnggota.getString(FLD_EMAIL));
            anggota.setNoNpwp(pstAnggota.getString(FLD_NO_NPWP));
            anggota.setIdJenisTransaksi(pstAnggota.getlong(FLD_JENIS_TRANSAKSI_ID));
            return anggota;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAnggotaBadanUsaha(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity ent) throws Exception {
        AnggotaBadanUsaha anggota = fetchExc(ent.getOID());
        ent = (Entity) anggota;
        return anggota.getOID();
    }

    public static long insertExc(AnggotaBadanUsaha anggota) throws DBException {
        try {
            PstAnggotaBadanUsaha pstAnggota = new PstAnggotaBadanUsaha(0);
            pstAnggota.setString(FLD_NO_ANGGOTA, anggota.getNoAnggota());
            pstAnggota.setString(FLD_NAME, anggota.getName());
            pstAnggota.setInt(FLD_SEX, anggota.getSex());
            pstAnggota.setString(FLD_OFFICE_ADDRESS, anggota.getOfficeAddress());
            pstAnggota.setLong(FLD_ADDR_OFFICE_CITY, anggota.getAddressOfficeCity());
            pstAnggota.setString(FLD_ID_CARD, anggota.getIdCard());
            pstAnggota.setString(FLD_TLP, anggota.getTelepon());
            pstAnggota.setString(FLD_EMAIL, anggota.getEmail());
            pstAnggota.setString(FLD_NO_NPWP, anggota.getNoNpwp());
            pstAnggota.setDate(FLD_REG_DATE, anggota.getRegDate());
//            pstAnggota.setLong(FLD_JENIS_TRANSAKSI_ID, anggota.getIdJenisTransaksi());
            pstAnggota.insert();
            anggota.setOID(pstAnggota.getlong(FLD_ID_ANGGOTA));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAnggotaBadanUsaha(0), DBException.UNKNOWN);
        }
        return anggota.getOID();
    }
    
    public static long insertExcPenjamin(AnggotaBadanUsaha anggota) throws DBException {
        try {
            PstAnggotaBadanUsaha pstAnggota = new PstAnggotaBadanUsaha(0);
            pstAnggota.setString(FLD_NO_ANGGOTA, anggota.getNoAnggota());
            pstAnggota.setString(FLD_NAME, anggota.getName());
            pstAnggota.setInt(FLD_SEX, anggota.getSex());
            pstAnggota.setString(FLD_OFFICE_ADDRESS, anggota.getOfficeAddress());
            pstAnggota.setLong(FLD_ADDR_OFFICE_CITY, anggota.getAddressOfficeCity());
            pstAnggota.setString(FLD_ID_CARD, anggota.getIdCard());
            pstAnggota.setString(FLD_TLP, anggota.getTelepon());
            pstAnggota.setString(FLD_EMAIL, anggota.getEmail());
            pstAnggota.setString(FLD_NO_NPWP, anggota.getNoNpwp());
            pstAnggota.setDate(FLD_REG_DATE, anggota.getRegDate());
            pstAnggota.setLong(FLD_JENIS_TRANSAKSI_ID, anggota.getIdJenisTransaksi());
            pstAnggota.insert();
            anggota.setOID(pstAnggota.getlong(FLD_ID_ANGGOTA));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAnggotaBadanUsaha(0), DBException.UNKNOWN);
        }
        return anggota.getOID();
    }
    
    public long insertExc(Entity ent) throws Exception {
        return insertExc((AnggotaBadanUsaha) ent);
    }

    public static long updateExc(AnggotaBadanUsaha anggota) throws DBException {
        try {
            if (anggota.getOID() != 0) {
                PstAnggotaBadanUsaha pstAnggota = new PstAnggotaBadanUsaha(anggota.getOID());
                pstAnggota.setString(FLD_NO_ANGGOTA, anggota.getNoAnggota());
                pstAnggota.setString(FLD_NAME, anggota.getName());
                pstAnggota.setInt(FLD_SEX, anggota.getSex());
                pstAnggota.setString(FLD_OFFICE_ADDRESS, anggota.getOfficeAddress());
                pstAnggota.setLong(FLD_ADDR_OFFICE_CITY, anggota.getAddressOfficeCity());
                pstAnggota.setString(FLD_ID_CARD, anggota.getIdCard());
                pstAnggota.setString(FLD_TLP, anggota.getTelepon());
                pstAnggota.setString(FLD_EMAIL, anggota.getEmail());
                pstAnggota.setString(FLD_NO_NPWP, anggota.getNoNpwp());
//                pstAnggota.setLong(FLD_JENIS_TRANSAKSI_ID, anggota.getIdJenisTransaksi());
                pstAnggota.update();
                return anggota.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAnggotaBadanUsaha(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public static long updateExcPenjamin(AnggotaBadanUsaha anggota) throws DBException {
        try {
            if (anggota.getOID() != 0) {
                PstAnggotaBadanUsaha pstAnggota = new PstAnggotaBadanUsaha(anggota.getOID());
                pstAnggota.setString(FLD_NO_ANGGOTA, anggota.getNoAnggota());
                pstAnggota.setString(FLD_NAME, anggota.getName());
                pstAnggota.setInt(FLD_SEX, anggota.getSex());
                pstAnggota.setString(FLD_OFFICE_ADDRESS, anggota.getOfficeAddress());
                pstAnggota.setLong(FLD_ADDR_OFFICE_CITY, anggota.getAddressOfficeCity());
                pstAnggota.setString(FLD_ID_CARD, anggota.getIdCard());
                pstAnggota.setString(FLD_TLP, anggota.getTelepon());
                pstAnggota.setString(FLD_EMAIL, anggota.getEmail());
                pstAnggota.setString(FLD_NO_NPWP, anggota.getNoNpwp());
                pstAnggota.setLong(FLD_JENIS_TRANSAKSI_ID, anggota.getIdJenisTransaksi());
                pstAnggota.update();
                return anggota.getOID();

            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAnggotaBadanUsaha(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((AnggotaBadanUsaha) ent);
    }

    public static long deleteExc(long oid) throws DBException {
        try {
            PstAnggotaBadanUsaha pstAnggota = new PstAnggotaBadanUsaha(oid);
            pstAnggota.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAnggotaBadanUsaha(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static int getCount(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ID_ANGGOTA] + ") " + " FROM " + TBL_ANGGOTA;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            //System.out.println(sql);
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();
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

    public static int getCountJoin(String whereClause) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        int count = 0;
        try {
            String sql = "SELECT COUNT(cl." + PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ID_ANGGOTA] + ") FROM " + TBL_ANGGOTA + " cl "
                    + " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " cca ON cl." + fieldNames[FLD_ID_ANGGOTA] + "=cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] + " "
                    + " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " cc ON cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] + " =cc." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]
                    + " WHERE cc.CLASS_TYPE='" + PstContactClass.CONTACT_TYPE_MEMBER + "'";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }
            return count;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return count;
    }

    public static Vector listAll() {
        return list(0, 0, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_ANGGOTA;

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
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                AnggotaBadanUsaha anggota = new AnggotaBadanUsaha();
                resultToObject(rs, anggota);
                lists.add(anggota);
            }
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listJoin(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT cl.* FROM " + TBL_ANGGOTA + " cl "
                    + " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " cca ON cl." + fieldNames[FLD_ID_ANGGOTA] + "=cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] + " "
                    + " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " cc ON cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID] + " =cc." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID]
                    + " WHERE cc.CLASS_TYPE='" + PstContactClass.CONTACT_TYPE_MEMBER + "'";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
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
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                AnggotaBadanUsaha anggota = new AnggotaBadanUsaha();
                resultToObject(rs, anggota);
                lists.add(anggota);
            }
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }
    
    public static Vector listJoinContactClassPenjamin(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + PstAnggotaBadanUsaha.TBL_ANGGOTA + " AS cl"
                    + " INNER JOIN " + PstContactClassAssign.TBL_CNT_CLS_ASSIGN + " AS cca "
                    + " ON cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CONTACT_ID] + " = cl." + PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ID_ANGGOTA]
                    + " INNER JOIN " + PstContactClass.TBL_CONTACT_CLASS + " AS cc "
                    + " ON cc." + PstContactClass.fieldNames[PstContactClass.FLD_CONTACT_CLASS_ID] + " = cca." + PstContactClassAssign.fieldNames[PstContactClassAssign.FLD_CNT_CLS_ID]
                    + " AND cc." + PstContactClass.fieldNames[PstContactClass.FLD_CLASS_TYPE] + " = '" + PstContactClass.FLD_CLASS_PENJAMIN + "' "
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " AND " + whereClause;
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
            ResultSet rs = (ResultSet) dbrs.getResultSet();
            while (rs.next()) {
                AnggotaBadanUsaha anggota = new AnggotaBadanUsaha();
                resultToObject(rs, anggota);
                lists.add(anggota);
            }
            return lists;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, AnggotaBadanUsaha anggota) {
        try {
            anggota.setOID(rs.getLong(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ID_ANGGOTA]));
            anggota.setNoAnggota(rs.getString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_NO_ANGGOTA]));
            anggota.setName(rs.getString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_NAME]));
            anggota.setSex(rs.getInt(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_SEX]));
            anggota.setOfficeAddress(rs.getString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_OFFICE_ADDRESS]));
            anggota.setAddressOfficeCity(rs.getLong(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ADDR_OFFICE_CITY])); //update tanggal 26 Pebruari 2013 oleh Hadi
            anggota.setIdCard(rs.getString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ID_CARD]));
            anggota.setTelepon(rs.getString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_TLP]));
            anggota.setEmail(rs.getString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_EMAIL]));
            anggota.setNoNpwp(rs.getString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_NO_NPWP]));
            anggota.setRegDate(rs.getDate(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_REG_DATE]));
            anggota.setIdJenisTransaksi(rs.getLong(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_JENIS_TRANSAKSI_ID]));
        } catch (Exception e) {
        }
    }
   public static JSONObject fetchJSON(long oid){
      JSONObject object = new JSONObject();
      try {
         AnggotaBadanUsaha anggotaBadanUsaha = PstAnggotaBadanUsaha.fetchExc(oid);
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ID_ANGGOTA], anggotaBadanUsaha.getOID());
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_NO_ANGGOTA], anggotaBadanUsaha.getNoAnggota());
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_NAME], anggotaBadanUsaha.getName());
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_SEX], anggotaBadanUsaha.getSex());
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_OFFICE_ADDRESS], anggotaBadanUsaha.getTelepon());
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ADDR_OFFICE_CITY], anggotaBadanUsaha.getEmail());
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ID_CARD], anggotaBadanUsaha.getOfficeAddress());
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_TLP], anggotaBadanUsaha.getAddressOfficeCity());
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_EMAIL], anggotaBadanUsaha.getIdCard());
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_NO_NPWP], anggotaBadanUsaha.getNoNpwp());
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_REG_DATE], anggotaBadanUsaha.getRegDate());
         object.put(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_JENIS_TRANSAKSI_ID], anggotaBadanUsaha.getIdJenisTransaksi());
      }catch(Exception exc){}
      return object;
   }
   
   public static long syncExc(JSONObject jSONObject){
      long oid = 0;
      if (jSONObject != null){
       oid = jSONObject.optLong(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ID_ANGGOTA],0);
         if (oid > 0){
          AnggotaBadanUsaha anggotaBadanUsaha = new AnggotaBadanUsaha();
          anggotaBadanUsaha.setOID(jSONObject.optLong(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ID_ANGGOTA],0));
          anggotaBadanUsaha.setNoAnggota(jSONObject.optString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_NO_ANGGOTA], ""));
          anggotaBadanUsaha.setName(jSONObject.optString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_NAME], ""));
          anggotaBadanUsaha.setSex(jSONObject.optInt(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_SEX],0));
          anggotaBadanUsaha.setOfficeAddress(jSONObject.optString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_OFFICE_ADDRESS], ""));
          anggotaBadanUsaha.setAddressOfficeCity(jSONObject.optLong(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ADDR_OFFICE_CITY],0));
          anggotaBadanUsaha.setIdCard(jSONObject.optString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ID_CARD], ""));
          anggotaBadanUsaha.setTelepon(jSONObject.optString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_TLP], ""));
          anggotaBadanUsaha.setEmail(jSONObject.optString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_EMAIL], ""));
          anggotaBadanUsaha.setNoNpwp(jSONObject.optString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_NO_NPWP], ""));
          anggotaBadanUsaha.setRegDate(Formater.formatDate(jSONObject.optString(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_REG_DATE],"0000-00-00"),"yyyy-MM-dd"));
          anggotaBadanUsaha.setIdJenisTransaksi(jSONObject.optLong(PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_JENIS_TRANSAKSI_ID],0));
         boolean checkOidAnggotaBadanUsaha = PstAnggotaBadanUsaha.checkOID(oid);
          try{
            if(checkOidAnggotaBadanUsaha){
               PstAnggotaBadanUsaha.updateExc(anggotaBadanUsaha);
            }else{
               PstAnggotaBadanUsaha.insertByOid(anggotaBadanUsaha);
            }
         }catch(Exception exc){}
         }
      }
   return oid;
   }



   public static long insertByOid(AnggotaBadanUsaha anggotaBadanUsaha) throws DBException {
      try {
         PstAnggotaBadanUsaha pstAnggotaBadanUsaha = new PstAnggotaBadanUsaha(0);
         pstAnggotaBadanUsaha.setLong(FLD_ID_ANGGOTA, anggotaBadanUsaha.getOID());
         pstAnggotaBadanUsaha.setString(FLD_NO_ANGGOTA, anggotaBadanUsaha.getNoAnggota());
         pstAnggotaBadanUsaha.setString(FLD_NAME, anggotaBadanUsaha.getName());
         pstAnggotaBadanUsaha.setInt(FLD_SEX, anggotaBadanUsaha.getSex());
         pstAnggotaBadanUsaha.setString(FLD_OFFICE_ADDRESS, anggotaBadanUsaha.getOfficeAddress());
         pstAnggotaBadanUsaha.setLong(FLD_ADDR_OFFICE_CITY, anggotaBadanUsaha.getAddressOfficeCity());
         pstAnggotaBadanUsaha.setString(FLD_ID_CARD, anggotaBadanUsaha.getIdCard());
         pstAnggotaBadanUsaha.setString(FLD_TLP, anggotaBadanUsaha.getTelepon());
         pstAnggotaBadanUsaha.setString(FLD_EMAIL, anggotaBadanUsaha.getEmail());
         pstAnggotaBadanUsaha.setString(FLD_NO_NPWP, anggotaBadanUsaha.getNoNpwp());
         pstAnggotaBadanUsaha.setDate(FLD_REG_DATE, anggotaBadanUsaha.getRegDate());
         pstAnggotaBadanUsaha.setLong(FLD_JENIS_TRANSAKSI_ID, anggotaBadanUsaha.getIdJenisTransaksi());
         pstAnggotaBadanUsaha.insertByOid(anggotaBadanUsaha.getOID());
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstAnggotaBadanUsaha(0), DBException.UNKNOWN);
      }
      return anggotaBadanUsaha.getOID();
   }
   
       public static boolean checkOID(long anggotaId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_ANGGOTA + " WHERE " +
                    PstAnggotaBadanUsaha.fieldNames[PstAnggotaBadanUsaha.FLD_ID_ANGGOTA] + " = " + anggotaId +" " ;

            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = (ResultSet) dbrs.getResultSet();

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
}
