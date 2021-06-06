/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.kredit;

/**
 *
 * @author Regen
 */
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.sedana.entity.tabungan.PstTransaksi;
import com.dimata.sedana.entity.tabungan.Transaksi;
import com.dimata.util.Command;
import java.util.ArrayList;
import java.util.Vector;
import org.json.JSONObject;

public class PstAngsuran extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

    public static final String TBL_ANGSURAN = "aiso_angsuran";
    public static final int FLD_ID_ANGSURAN = 0;
    public static final int FLD_JUMLAH_ANGSURAN = 1;
    public static final int FLD_JADWAL_ANGSURAN_ID = 2;
    public static final int FLD_TRANSAKSI_ID = 3;
    public static final int FLD_DISC_PCT = 4;
    public static final int FLD_DISC_AMOUNT = 5;
    

    public static String[] fieldNames = {
        "ID_ANGSURAN",
        "JUMLAH_ANGSURAN",
        "JADWAL_ANGSURAN_ID",
        "TRANSAKSI_ID",
        "DISC_PCT",
        "DISC_AMOUNT"
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT
    };

    public PstAngsuran() {
    }

    public PstAngsuran(int i) throws DBException {
        super(new PstAngsuran());
    }

    public PstAngsuran(String sOid) throws DBException {
        super(new PstAngsuran(0));
        if (!locate(sOid)) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public PstAngsuran(long lOid) throws DBException {
        super(new PstAngsuran(0));
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
        return TBL_ANGSURAN;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new PstAngsuran().getClass().getName();
    }

    public static Angsuran fetchExc(long oid) throws DBException {
        try {
            Angsuran entAngsuran = new Angsuran();
            PstAngsuran pstAngsuran = new PstAngsuran(oid);
            entAngsuran.setOID(oid);
            entAngsuran.setJumlahAngsuran(pstAngsuran.getdouble(FLD_JUMLAH_ANGSURAN));
            entAngsuran.setJadwalAngsuranId(pstAngsuran.getlong(FLD_JADWAL_ANGSURAN_ID));
            entAngsuran.setTransaksiId(pstAngsuran.getlong(FLD_TRANSAKSI_ID));    
            entAngsuran.setDiscPct(pstAngsuran.getdouble(FLD_DISC_PCT));
            entAngsuran.setDiscAmount(pstAngsuran.getdouble(FLD_DISC_AMOUNT));
            return entAngsuran;
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAngsuran(0), DBException.UNKNOWN);
        }
    }

    public long fetchExc(Entity entity) throws Exception {
        Angsuran entAngsuran = fetchExc(entity.getOID());
        entity = (Entity) entAngsuran;
        return entAngsuran.getOID();
    }

    public static synchronized long updateExc(Angsuran entAngsuran) throws DBException {
        try {
            if (entAngsuran.getOID() != 0) {
                PstAngsuran pstAngsuran = new PstAngsuran(entAngsuran.getOID());
                pstAngsuran.setDouble(FLD_JUMLAH_ANGSURAN, entAngsuran.getJumlahAngsuran());
                pstAngsuran.setLong(FLD_JADWAL_ANGSURAN_ID, entAngsuran.getJadwalAngsuranId());
                pstAngsuran.setLong(FLD_TRANSAKSI_ID, entAngsuran.getTransaksiId());       
                pstAngsuran.setDouble(FLD_DISC_PCT, entAngsuran.getDiscPct());
                pstAngsuran.setDouble(FLD_DISC_AMOUNT, entAngsuran.getDiscAmount());
                pstAngsuran.update();
                return entAngsuran.getOID();
            }
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAngsuran(0), DBException.UNKNOWN);
        }
        return 0;
    }

    public long updateExc(Entity entity) throws Exception {
        return updateExc((Angsuran) entity);
    }

    public static synchronized long deleteExc(long oid) throws DBException {
        try {
            PstAngsuran pstAngsuran = new PstAngsuran(oid);
            pstAngsuran.delete();
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAngsuran(0), DBException.UNKNOWN);
        }
        return oid;
    }

    public long deleteExc(Entity entity) throws Exception {
        if (entity == null) {
            throw new DBException(this, DBException.RECORD_NOT_FOUND);
        }
        return deleteExc(entity.getOID());
    }

    public static synchronized long insertExc(Angsuran entAngsuran) throws DBException {
        try {
            PstAngsuran pstAngsuran = new PstAngsuran(0);
            pstAngsuran.setDouble(FLD_JUMLAH_ANGSURAN, entAngsuran.getJumlahAngsuran());
            pstAngsuran.setLong(FLD_JADWAL_ANGSURAN_ID, entAngsuran.getJadwalAngsuranId());
            pstAngsuran.setLong(FLD_TRANSAKSI_ID, entAngsuran.getTransaksiId());    
            pstAngsuran.setDouble(FLD_DISC_PCT, entAngsuran.getDiscPct());
            pstAngsuran.setDouble(FLD_DISC_AMOUNT, entAngsuran.getDiscAmount());
            pstAngsuran.insert();
            entAngsuran.setOID(pstAngsuran.getlong(FLD_ID_ANGSURAN));
        } catch (DBException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new DBException(new PstAngsuran(0), DBException.UNKNOWN);
        }
        return entAngsuran.getOID();
    }

    public long insertExc(Entity entity) throws Exception {
        return insertExc((Angsuran) entity);
    }

    public static void resultToObject(ResultSet rs, Angsuran entAngsuran) {
        try {
            entAngsuran.setOID(rs.getLong(PstAngsuran.fieldNames[PstAngsuran.FLD_ID_ANGSURAN]));
            entAngsuran.setJumlahAngsuran(rs.getDouble(PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN]));
            entAngsuran.setJadwalAngsuranId(rs.getLong(PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID]));
            entAngsuran.setTransaksiId(rs.getLong(PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID]));    
            entAngsuran.setDiscPct(rs.getDouble(PstAngsuran.fieldNames[PstAngsuran.FLD_DISC_PCT]));
            entAngsuran.setDiscAmount(rs.getDouble(PstAngsuran.fieldNames[PstAngsuran.FLD_DISC_AMOUNT]));
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
            String sql = "SELECT * FROM " + TBL_ANGSURAN;
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
                Angsuran entAngsuran = new Angsuran();
                resultToObject(rs, entAngsuran);
                lists.add(entAngsuran);
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
    
    public static ArrayList listAngsuranJoinJadwal(String whereClause, String group){
        ArrayList listData = new ArrayList();
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT "
                    + " SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN] + ","
                    + " SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN] + ","
                    + " SUM(SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JUMLAH_ANGSURAN] + ") AS JUMLAH_ANGSURAN ,"
                    + " SUM(AA." + fieldNames[FLD_JUMLAH_ANGSURAN] + ") AS JUMLAH_DIBAYAR, "
                    + " SUM(AA." + fieldNames[FLD_DISC_AMOUNT] + ") AS JUMLAH_DISKON, "
                    + " SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]
                    + " FROM " + TBL_ANGSURAN + " AS AA "
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS SJA "
                    + " ON AA." + fieldNames[FLD_JADWAL_ANGSURAN_ID]
                    + " = SJA." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID]; 
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if(group != null && group.length() > 0){
                sql += " GROUP BY " + group;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ArrayList<String> tempData = new ArrayList<>();
                
                tempData.add(rs.getString(PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]));
                tempData.add(rs.getString(PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JENIS_ANGSURAN]));
                tempData.add(rs.getString("JUMLAH_ANGSURAN"));
                tempData.add(rs.getString("JUMLAH_DIBAYAR"));
                tempData.add(rs.getString(PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_TANGGAL_ANGSURAN]));
                tempData.add(rs.getString("JUMLAH_DISKON"));
                
                listData.add(tempData);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            DBResultSet.close(dbrs);
        }
        return listData;
    }

    public static boolean checkOID(long entAngsuranId) {
        DBResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + TBL_ANGSURAN + " WHERE "
                    + PstAngsuran.fieldNames[PstAngsuran.FLD_ID_ANGSURAN] + " = " + entAngsuranId;
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
            String sql = "SELECT COUNT(" + PstAngsuran.fieldNames[PstAngsuran.FLD_ID_ANGSURAN] + ") FROM " + TBL_ANGSURAN;
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
                    Angsuran entAngsuran = (Angsuran) list.get(ls);
                    if (oid == entAngsuran.getOID()) {
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

    public static double getSumAngsuranDibayar(String whereClause) {
        DBResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(angsuran." + PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN] + ")"
                    + " FROM " + TBL_ANGSURAN + " AS angsuran "
                    + " INNER JOIN " + PstJadwalAngsuran.TBL_JADWALANGSURAN + " AS jadwal "
                    + " ON jadwal." + PstJadwalAngsuran.fieldNames[PstJadwalAngsuran.FLD_JADWAL_ANGSURAN_ID] + " = angsuran." + fieldNames[FLD_JADWAL_ANGSURAN_ID]
                    + "";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = DBHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }
            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            DBResultSet.close(dbrs);
        }
    }
    


   public static JSONObject fetchJSON(long oid){
      JSONObject object = new JSONObject();
      try {
         Angsuran angsuran = PstAngsuran.fetchExc(oid);
         object.put(PstAngsuran.fieldNames[PstAngsuran.FLD_ID_ANGSURAN], ""+angsuran.getOID());
         object.put(PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN], angsuran.getJumlahAngsuran());
         object.put(PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID], ""+angsuran.getJadwalAngsuranId());
         object.put(PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID], ""+angsuran.getTransaksiId());
         object.put(PstAngsuran.fieldNames[PstAngsuran.FLD_DISC_PCT], angsuran.getDiscPct());
         object.put(PstAngsuran.fieldNames[PstAngsuran.FLD_DISC_AMOUNT], angsuran.getDiscAmount());
      }catch(Exception exc){}
      return object;
   }
   
   
   public static long syncExc(JSONObject jSONObject){
      long oid = 0;
      if (jSONObject != null){
       oid = jSONObject.optLong(PstAngsuran.fieldNames[PstAngsuran.FLD_ID_ANGSURAN],0);
         if (oid > 0){
          Angsuran angsuran = new Angsuran();
          angsuran.setOID(jSONObject.optLong(PstAngsuran.fieldNames[PstAngsuran.FLD_ID_ANGSURAN],0));
          angsuran.setJumlahAngsuran(jSONObject.optDouble(PstAngsuran.fieldNames[PstAngsuran.FLD_JUMLAH_ANGSURAN],0));
          angsuran.setJadwalAngsuranId(jSONObject.optLong(PstAngsuran.fieldNames[PstAngsuran.FLD_JADWAL_ANGSURAN_ID],0));
          angsuran.setTransaksiId(jSONObject.optLong(PstAngsuran.fieldNames[PstAngsuran.FLD_TRANSAKSI_ID],0));
          angsuran.setDiscPct(jSONObject.optLong(PstAngsuran.fieldNames[PstAngsuran.FLD_DISC_PCT],0));
          angsuran.setDiscAmount(jSONObject.optLong(PstAngsuran.fieldNames[PstAngsuran.FLD_DISC_AMOUNT],0));
         boolean checkOidAngsuran = PstAngsuran.checkOID(oid);
          try{
            if(checkOidAngsuran){
               PstAngsuran.updateExc(angsuran);
            }else{
               PstAngsuran.insertByOid(angsuran);
            }
         }catch(Exception exc){}
         }
      }
   return oid;
   }



   public static long insertByOid(Angsuran angsuran) throws DBException {
      try {
         PstAngsuran pstAngsuran = new PstAngsuran(0);
         pstAngsuran.setLong(FLD_ID_ANGSURAN, angsuran.getOID());
         pstAngsuran.setDouble(FLD_JUMLAH_ANGSURAN, angsuran.getJumlahAngsuran());
         pstAngsuran.setLong(FLD_JADWAL_ANGSURAN_ID, angsuran.getJadwalAngsuranId());
         pstAngsuran.setLong(FLD_TRANSAKSI_ID, angsuran.getTransaksiId());
         pstAngsuran.insertByOid(angsuran.getOID());
      } catch (DBException dbe) {
         throw dbe;
      } catch (Exception e) {
         throw new DBException(new PstAngsuran(0), DBException.UNKNOWN);
      }
      return angsuran.getOID();
   }
   
   
}
