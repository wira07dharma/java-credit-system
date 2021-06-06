/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.kredit;

import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;
import org.json.JSONObject;

/**
 *
 * @author Dimata 007
 */
public class PstPenjamin extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_PENJAMIN = "sedana_penjamin";
    public static final int FLD_PENJAMIN_ID = 0;
    public static final int FLD_CONTACT_ID = 1;
    public static final int FLD_PINJAMAN_ID = 2;
    public static final int FLD_PROSENTASE_DIJAMIN = 3;
    public static final int FLD_JENIS_TRANSAKSI_ID = 4;
    public static final int FLD_COVERAGE = 5;

    public static String[] fieldNames = {
        "PENJAMIN_ID",
        "CONTACT_ID",
        "PINJAMAN_ID",
        "PROSENTASE_DIJAMIN",
        "JENIS_TRANSAKSI_ID",
        "COVERAGE"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT
    };

    public PstPenjamin() {
    }

    public PstPenjamin(int i) throws DBException {
        super(new PstPenjamin());
    }

    public PstPenjamin(String sOid) throws DBException {
        super(new PstPenjamin(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstPenjamin(long lOid) throws DBException {
        super(new PstPenjamin(0));
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
        return TBL_PENJAMIN;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstPenjamin().getClass().getName();
    }

    public static Penjamin fetchExc(long oid) throws DBException {
        try {
            Penjamin entPenjamin = new Penjamin();
            PstPenjamin pstPenjamin = new PstPenjamin(oid);
            entPenjamin.setOID(oid);
            entPenjamin.setContactId(pstPenjamin.getlong(FLD_CONTACT_ID));
            entPenjamin.setPinjamanId(pstPenjamin.getlong(FLD_PINJAMAN_ID));
            entPenjamin.setProsentasePenjamin(pstPenjamin.getdouble(FLD_PROSENTASE_DIJAMIN));
            entPenjamin.setJenisTransaksiId(pstPenjamin.getlong(FLD_JENIS_TRANSAKSI_ID));
            entPenjamin.setCoverage(pstPenjamin.getdouble(FLD_COVERAGE));
            return entPenjamin;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPenjamin(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        Penjamin entPenjamin = fetchExc(entity.getOID());
        entity = (Entity) entPenjamin;
        return entPenjamin.getOID();
    }

    public static synchronized long updateExc(Penjamin entPenjamin) throws DBException {
        try {
            if (entPenjamin.getOID() != 0) {
                PstPenjamin pstPenjamin = new PstPenjamin(entPenjamin.getOID());
                pstPenjamin.setLong(FLD_CONTACT_ID, entPenjamin.getContactId());
                pstPenjamin.setLong(FLD_PINJAMAN_ID, entPenjamin.getPinjamanId());
                pstPenjamin.setDouble(FLD_PROSENTASE_DIJAMIN, entPenjamin.getProsentasePenjamin());
                pstPenjamin.setLong(FLD_JENIS_TRANSAKSI_ID, entPenjamin.getJenisTransaksiId());
                pstPenjamin.setDouble(FLD_COVERAGE, entPenjamin.getCoverage());
                pstPenjamin.update();
                return entPenjamin.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPenjamin(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((Penjamin) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstPenjamin pstPenjamin = new PstPenjamin(oid);
            pstPenjamin.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPenjamin(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(Penjamin entPenjamin) throws DBException {
        try {
            PstPenjamin pstPenjamin = new PstPenjamin(0);
            pstPenjamin.setLong(FLD_CONTACT_ID, entPenjamin.getContactId());
            pstPenjamin.setLong(FLD_PINJAMAN_ID, entPenjamin.getPinjamanId());
            pstPenjamin.setDouble(FLD_PROSENTASE_DIJAMIN, entPenjamin.getProsentasePenjamin());
            pstPenjamin.setLong(FLD_JENIS_TRANSAKSI_ID, entPenjamin.getJenisTransaksiId());
            pstPenjamin.setDouble(FLD_COVERAGE, entPenjamin.getCoverage());
            pstPenjamin.insert();
            entPenjamin.setOID(pstPenjamin.getlong(FLD_PENJAMIN_ID));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstPenjamin(0), DBException.UNKNOWN);
        }
        return entPenjamin.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((Penjamin) entity);
    }

    public static void resultToObject(ResultSet rs, Penjamin entPenjamin) {
        try {
            entPenjamin.setOID(rs.getLong(PstPenjamin.fieldNames[PstPenjamin.FLD_PENJAMIN_ID]));
            entPenjamin.setContactId(rs.getLong(PstPenjamin.fieldNames[PstPenjamin.FLD_CONTACT_ID]));
            entPenjamin.setPinjamanId(rs.getLong(PstPenjamin.fieldNames[PstPenjamin.FLD_PINJAMAN_ID]));
            entPenjamin.setProsentasePenjamin(rs.getDouble(PstPenjamin.fieldNames[PstPenjamin.FLD_PROSENTASE_DIJAMIN]));
            entPenjamin.setJenisTransaksiId(rs.getLong(PstPenjamin.fieldNames[PstPenjamin.FLD_JENIS_TRANSAKSI_ID]));
            entPenjamin.setCoverage(rs.getDouble(PstPenjamin.fieldNames[PstPenjamin.FLD_COVERAGE]));
        } catch (Exception e) {
        }
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + TBL_PENJAMIN;
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
                Penjamin entPenjamin = new Penjamin();
                resultToObject(rs, entPenjamin);
                lists.add(entPenjamin);
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

    public static boolean checkOID(long entPenjaminId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_PENJAMIN + " WHERE "
                    + PstPenjamin.fieldNames[PstPenjamin.FLD_PENJAMIN_ID] + " = " + entPenjaminId;
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
            String sql = "SELECT COUNT(" + PstPenjamin.fieldNames[PstPenjamin.FLD_PENJAMIN_ID] + ") FROM " + TBL_PENJAMIN;
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

    public static int findLimitStart(long oid, int recordToGet, String whereClause, String orderClause) {
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, orderClause);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    Penjamin entPenjamin = (Penjamin) list.get(ls);
                    if (oid == entPenjamin.getOID()) {
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

    public static int findLimitCommand(int start, int recordToGet, int vectSize) {
        int cmd = Command.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + (recordToGet - mdl);
        if (start == 0) {
            cmd = Command.FIRST;
        } else {
            if (start == (vectSize - recordToGet)) {
                cmd = Command.LAST;
            } else {
                start = start + recordToGet;
                if (start <= (vectSize - recordToGet)) {
                    cmd = Command.NEXT;
                    System.out.println("next.......................");
                } else {
                    start = start - recordToGet;
                    if (start > 0) {
                        cmd = Command.PREV;
                        System.out.println("prev.......................");
                    }
                }
            }
        }
        return cmd;
    }
   public static JSONObject fetchJSON(long oid){
      JSONObject object = new JSONObject();
      try {
         Penjamin penjamin = PstPenjamin.fetchExc(oid);
         object.put(PstPenjamin.fieldNames[PstPenjamin.FLD_PENJAMIN_ID], penjamin.getOID());
         object.put(PstPenjamin.fieldNames[PstPenjamin.FLD_CONTACT_ID], penjamin.getContactId());
         object.put(PstPenjamin.fieldNames[PstPenjamin.FLD_PINJAMAN_ID], penjamin.getPinjamanId());
         object.put(PstPenjamin.fieldNames[PstPenjamin.FLD_PROSENTASE_DIJAMIN], penjamin.getProsentasePenjamin());
         object.put(PstPenjamin.fieldNames[PstPenjamin.FLD_JENIS_TRANSAKSI_ID], penjamin.getJenisTransaksiId());
         object.put(PstPenjamin.fieldNames[PstPenjamin.FLD_COVERAGE], penjamin.getCoverage());
      }catch(Exception exc){}
      return object;
   }
   
    public static long syncExc(JSONObject jSONObject){
      long oid = 0;
      if (jSONObject != null){
       oid = jSONObject.optLong(PstPenjamin.fieldNames[PstPenjamin.FLD_PENJAMIN_ID],0);
         if (oid > 0){
          Penjamin penjamin = new Penjamin();
          penjamin.setOID(jSONObject.optLong(PstPenjamin.fieldNames[PstPenjamin.FLD_PENJAMIN_ID],0));
          penjamin.setContactId(jSONObject.optLong(PstPenjamin.fieldNames[PstPenjamin.FLD_CONTACT_ID],0));
          penjamin.setPinjamanId(jSONObject.optLong(PstPenjamin.fieldNames[PstPenjamin.FLD_PINJAMAN_ID],0));
          penjamin.setProsentasePenjamin(jSONObject.optDouble(PstPenjamin.fieldNames[PstPenjamin.FLD_PROSENTASE_DIJAMIN],0));
          penjamin.setJenisTransaksiId(jSONObject.optLong(PstPenjamin.fieldNames[PstPenjamin.FLD_JENIS_TRANSAKSI_ID],0));
          penjamin.setCoverage(jSONObject.optDouble(PstPenjamin.fieldNames[PstPenjamin.FLD_COVERAGE],0));
         boolean checkOidPenjamin = PstPenjamin.checkOID(oid);
          try{
            if(checkOidPenjamin){
               PstPenjamin.updateExc(penjamin);
            }else{
               PstPenjamin.insertByOid(penjamin);
            }
         }catch(Exception exc){}
         }
      }
   return oid;
   }



   public static long insertByOid(Penjamin penjamin) throws DBException {
      try {
         PstPenjamin pstPenjamin = new PstPenjamin(0);
         pstPenjamin.setLong(FLD_PENJAMIN_ID, penjamin.getOID());
         pstPenjamin.setLong(FLD_CONTACT_ID, penjamin.getContactId());
         pstPenjamin.setLong(FLD_PINJAMAN_ID, penjamin.getPinjamanId());
         pstPenjamin.setDouble(FLD_PROSENTASE_DIJAMIN, penjamin.getProsentasePenjamin());
         pstPenjamin.setLong(FLD_JENIS_TRANSAKSI_ID, penjamin.getJenisTransaksiId());
         pstPenjamin.setDouble(FLD_COVERAGE, penjamin.getCoverage());
         pstPenjamin.insertByOid(penjamin.getOID());
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstPenjamin(0), DBException.UNKNOWN);
      }
      return penjamin.getOID();
   }
}
