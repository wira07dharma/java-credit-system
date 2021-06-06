/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.masterdata;

import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.ArrayList;
import java.util.Vector;
/**
 *
 * @author Dimata IT Solutions
 */
public class PstJangkaWaktuFormula extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

  public static final String TBL_JANGKA_WAKTU_FORMULA = "sedana_jangka_waktu_formula";
  public static final int FLD_JANGKA_WAKTU_FORMULA_ID = 0;
  public static final int FLD_JANGKA_WAKTU_ID = 1;
  public static final int FLD_TRANSACTION_TYPE = 2;
  public static final int FLD_FORMULA = 3;
  public static final int FLD_CODE = 4;
  public static final int FLD_COMP_NAME = 5;
  public static final int FLD_IDX = 6;
  public static final int FLD_JENIS_PEMBULATAN = 7;
  public static final int FLD_JENIS_KREDIT_ID = 8;
  public static final int FLD_STATUS = 9;

  public static String[] fieldNames = {
    "JANGKA_WAKTU_FORMULA_ID",
    "JANGKA_WAKTU_ID",
    "TRANSACTION_TYPE",
    "FORMULA",
    "CODE",
    "NAME",
    "IDX",
    "JENIS_PEMBULATAN",
    "JENIS_KREDIT_ID",
    "STATUS"
  };

  public static int[] fieldTypes = {
    TYPE_LONG + TYPE_PK + TYPE_ID,
    TYPE_LONG,
    TYPE_INT,
    TYPE_STRING,
    TYPE_STRING,
    TYPE_STRING,
    TYPE_INT,
    TYPE_INT,
    TYPE_LONG,
    TYPE_INT
  };
  
  public static final int TYPE_NONE = 0;
  public static final int TYPE_DP = 1;
  public static final int TYPE_NILAI_PENGAJUAN = 2;
  public static final int TYPE_BUNGA = 3;
  public static final int TYPE_POKOK = 4;
  
  public static final String[] strTypeComp = {
      "Rumus",
      "DP",
      "Nilai Pengajuan",
      "Bunga",
      "Pokok"
  };
  
  public static final int TANPA_PEMBULATAN = 0;
  public static final int PEMBULATAN_PULUHAN = 1;
  public static final int PEMBULATAN_RATUSAN = 2;
  public static final int PEMBULATAN_RIBUAN = 3;
  
  public static final String[] strTypePembulatan = {
      "Tanpa Pembulatan",
      "Puluhan",
      "Ratusan",
      "Ribuan"
  };

  public PstJangkaWaktuFormula() {
  }

  public PstJangkaWaktuFormula(int i) throws DBException {
    super(new PstJangkaWaktuFormula());
  }

  public PstJangkaWaktuFormula(String sOid) throws DBException {
    super(new PstJangkaWaktuFormula(0));
    if (!locate(sOid)) {
      throw new DBException(this, DBException.RECORD_NOT_FOUND);
    } else {
      return;
    }
  }

  public PstJangkaWaktuFormula(long lOid) throws DBException {
    super(new PstJangkaWaktuFormula(0));
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
    return TBL_JANGKA_WAKTU_FORMULA;
  }

  public String[] getFieldNames() {
    return fieldNames;
  }

  public int[] getFieldTypes() {
    return fieldTypes;
  }

  public String getPersistentName() {
    return new PstJangkaWaktuFormula().getClass().getName();
  }

  public static JangkaWaktuFormula fetchExc(long oid) throws DBException {
    try {
      JangkaWaktuFormula entJangkaWaktuFormula = new JangkaWaktuFormula();
      PstJangkaWaktuFormula pstJangkaWaktu = new PstJangkaWaktuFormula(oid);
      entJangkaWaktuFormula.setOID(oid);
      entJangkaWaktuFormula.setJangkaWaktuId(pstJangkaWaktu.getlong(FLD_JANGKA_WAKTU_ID));
      entJangkaWaktuFormula.setTransType(pstJangkaWaktu.getInt(FLD_TRANSACTION_TYPE));
      entJangkaWaktuFormula.setFormula(pstJangkaWaktu.getString(FLD_FORMULA));
      entJangkaWaktuFormula.setCode(pstJangkaWaktu.getString(FLD_CODE));
      entJangkaWaktuFormula.setCompName(pstJangkaWaktu.getString(FLD_COMP_NAME));
      entJangkaWaktuFormula.setIdx(pstJangkaWaktu.getInt(FLD_IDX));
      entJangkaWaktuFormula.setPembulatan(pstJangkaWaktu.getInt(FLD_JENIS_PEMBULATAN));
      entJangkaWaktuFormula.setJenisKreditId(pstJangkaWaktu.getlong(FLD_JENIS_KREDIT_ID));
      entJangkaWaktuFormula.setStatus(pstJangkaWaktu.getInt(FLD_STATUS));
      return entJangkaWaktuFormula;
    } catch (DBException dbe) {
      throw dbe;
    } catch (Exception e) {
      throw new DBException(new PstJangkaWaktuFormula(0), DBException.UNKNOWN);
    }
  }

  public long fetchExc(Entity entity) throws Exception {
    JangkaWaktuFormula entJangkaWaktuFormula = fetchExc(entity.getOID());
    entity = (Entity) entJangkaWaktuFormula;
    return entJangkaWaktuFormula.getOID();
  }

  public static synchronized long updateExc(JangkaWaktuFormula entJangkaWaktuFormula) throws DBException {
    try {
      if (entJangkaWaktuFormula.getOID() != 0) {
        PstJangkaWaktuFormula pstJangkaWaktu = new PstJangkaWaktuFormula(entJangkaWaktuFormula.getOID());
        pstJangkaWaktu.setLong(FLD_JANGKA_WAKTU_ID, entJangkaWaktuFormula.getJangkaWaktuId());
        pstJangkaWaktu.setInt(FLD_TRANSACTION_TYPE, entJangkaWaktuFormula.getTransType());
        pstJangkaWaktu.setString(FLD_FORMULA, entJangkaWaktuFormula.getFormula());
        pstJangkaWaktu.setString(FLD_CODE, entJangkaWaktuFormula.getCode());
        pstJangkaWaktu.setString(FLD_COMP_NAME, entJangkaWaktuFormula.getCompName());
        pstJangkaWaktu.setInt(FLD_IDX, entJangkaWaktuFormula.getIdx());
        pstJangkaWaktu.setInt(FLD_JENIS_PEMBULATAN, entJangkaWaktuFormula.getPembulatan());
        pstJangkaWaktu.setLong(FLD_JENIS_KREDIT_ID, entJangkaWaktuFormula.getJenisKreditId());
        pstJangkaWaktu.setInt(FLD_STATUS, entJangkaWaktuFormula.getStatus());
        pstJangkaWaktu.update();
        return entJangkaWaktuFormula.getOID();
      }
    } catch (DBException dbe) {
      throw dbe;
    } catch (Exception e) {
      throw new DBException(new PstJangkaWaktuFormula(0), DBException.UNKNOWN);
    }
    return 0;
  }

  public long updateExc(Entity entity) throws Exception {
    return updateExc((JangkaWaktuFormula) entity);
  }

  public static synchronized long deleteExc(long oid) throws DBException {
    try {
      PstJangkaWaktuFormula pstJangkaWaktu = new PstJangkaWaktuFormula(oid);
      pstJangkaWaktu.delete();
    } catch (DBException dbe) {
      throw dbe;
    } catch (Exception e) {
      throw new DBException(new PstJangkaWaktuFormula(0), DBException.UNKNOWN);
    }
    return oid;
  }

  public long deleteExc(Entity entity) throws Exception {
    if (entity == null) {
      throw new DBException(this, DBException.RECORD_NOT_FOUND);
    }
    return deleteExc(entity.getOID());
  }

  public static synchronized long insertExc(JangkaWaktuFormula entJangkaWaktuFormula) throws DBException {
    try {
      PstJangkaWaktuFormula pstJangkaWaktu = new PstJangkaWaktuFormula(0);
      pstJangkaWaktu.setLong(FLD_JANGKA_WAKTU_ID, entJangkaWaktuFormula.getJangkaWaktuId());
        pstJangkaWaktu.setInt(FLD_TRANSACTION_TYPE, entJangkaWaktuFormula.getTransType());
        pstJangkaWaktu.setString(FLD_FORMULA, entJangkaWaktuFormula.getFormula());
        pstJangkaWaktu.setString(FLD_CODE, entJangkaWaktuFormula.getCode());
        pstJangkaWaktu.setString(FLD_COMP_NAME, entJangkaWaktuFormula.getCompName());
        pstJangkaWaktu.setInt(FLD_IDX, entJangkaWaktuFormula.getIdx());
        pstJangkaWaktu.setInt(FLD_JENIS_PEMBULATAN, entJangkaWaktuFormula.getPembulatan());
        pstJangkaWaktu.setLong(FLD_JENIS_KREDIT_ID, entJangkaWaktuFormula.getJenisKreditId());
        pstJangkaWaktu.setInt(FLD_STATUS, entJangkaWaktuFormula.getStatus());
      pstJangkaWaktu.insert();
      entJangkaWaktuFormula.setOID(pstJangkaWaktu.getlong(FLD_JANGKA_WAKTU_FORMULA_ID));
    } catch (DBException dbe) {
      throw dbe;
    } catch (Exception e) {
      throw new DBException(new PstJangkaWaktuFormula(0), DBException.UNKNOWN);
    }
    return entJangkaWaktuFormula.getOID();
  }

  public long insertExc(Entity entity) throws Exception {
    return insertExc((JangkaWaktuFormula) entity);
  }

  public static void resultToObject(ResultSet rs, JangkaWaktuFormula entJangkaWaktuFormula) {
    try {
      entJangkaWaktuFormula.setJangkaWaktuId(rs.getLong(PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID]));
      entJangkaWaktuFormula.setTransType(rs.getInt(PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_TRANSACTION_TYPE]));
      entJangkaWaktuFormula.setFormula(rs.getString(PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_FORMULA]));
      entJangkaWaktuFormula.setCode(rs.getString(PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_CODE]));
      entJangkaWaktuFormula.setCompName(rs.getString(PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_COMP_NAME]));
      entJangkaWaktuFormula.setIdx(rs.getInt(PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_IDX]));
      entJangkaWaktuFormula.setPembulatan(rs.getInt(PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JENIS_PEMBULATAN]));
      entJangkaWaktuFormula.setJenisKreditId(rs.getLong(PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JENIS_KREDIT_ID]));
      entJangkaWaktuFormula.setStatus(rs.getInt(PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_STATUS]));
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
      String sql = "SELECT * FROM " + TBL_JANGKA_WAKTU_FORMULA;
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
        JangkaWaktuFormula entJangkaWaktuFormula = new JangkaWaktuFormula();
        resultToObject(rs, entJangkaWaktuFormula);
        lists.add(entJangkaWaktuFormula);
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

	/**
	 *
	 * @param limitStart
	 * @param recordToGet
	 * @param whereClause
	 * @param order
	 * @return a joined list between jangka waktu and jangka waktu formula
	 * 0 for jangka waktu id, 1 for jangka waktu formula id, 2 for jangka waktu
	 * 3 for transaction type, 4 for jangka waktu formula
	 */
	public static ArrayList listJoinFormula(int limitStart, int recordToGet, String whereClause, String order) {
		DBResultSet dbrs = null;
		ArrayList list = new ArrayList();
		try {
			String sql = "SELECT "
					+ " JW." + PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU_ID]
					+ " , JWF." + fieldNames[FLD_JANGKA_WAKTU_FORMULA_ID]
					+ " , JW." + PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU]
					+ " , JWF." + fieldNames[FLD_TRANSACTION_TYPE]
					+ " , JWF." + fieldNames[FLD_FORMULA]
                                        + " , JWF." + fieldNames[FLD_CODE]
                                        + " , JWF." + fieldNames[FLD_COMP_NAME]
                                        + " , JWF." + fieldNames[FLD_IDX]
                                        + " , JWF." + fieldNames[FLD_TRANSACTION_TYPE]
                                        + " , JWF." + fieldNames[FLD_JENIS_PEMBULATAN]
					+ " FROM " + TBL_JANGKA_WAKTU_FORMULA + " AS JWF"
					+ " INNER JOIN " + PstJangkaWaktu.TBL_JANGKA_WAKTU + " AS JW"
					+ " ON JWF." + fieldNames[FLD_JANGKA_WAKTU_ID]
					+ " = JW." + PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU_ID];
			if (whereClause.length() > 0 && whereClause != null) {
				sql += " WHERE " + whereClause;
			}
			if (order != null && order.length() > 0) {
				sql += " ORDER BY " + order;
			}
			if (limitStart == 0 && recordToGet == 0) {
				sql += "";
			} else {
				sql += " LIMIT " + limitStart + "," + recordToGet;
			}
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while (rs.next()) {
				ArrayList temp = new ArrayList();
				temp.add(rs.getLong(PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU_ID])); //0
				temp.add(rs.getLong(fieldNames[FLD_JANGKA_WAKTU_FORMULA_ID])); //1
				temp.add(rs.getInt(PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU])); //2
				temp.add(rs.getInt(fieldNames[FLD_TRANSACTION_TYPE])); //3
				temp.add(rs.getString(fieldNames[FLD_FORMULA])); //4
                                temp.add(rs.getString(fieldNames[FLD_CODE])); //5
                                temp.add(rs.getString(fieldNames[FLD_COMP_NAME])); //6
                                temp.add(rs.getInt(fieldNames[FLD_IDX])); //7
                                temp.add(rs.getInt(fieldNames[FLD_TRANSACTION_TYPE])); //8
                                temp.add(rs.getInt(fieldNames[FLD_JENIS_PEMBULATAN])); //9
				list.add(temp);
			}
			rs.close();
		} catch (Exception e) {
			System.out.println("Fetch list jangka waktu formula: " + e.getMessage());
		} finally {
			DBResultSet.close(dbrs);
		}
		return list;
	}
  
  public static boolean checkOID(long entJangkaWaktuId) {
    DBResultSet dbrs = null;
    boolean result = false;
    try {
      String sql = "SELECT * FROM " + TBL_JANGKA_WAKTU_FORMULA + " WHERE "
              + PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID] + " = " + entJangkaWaktuId;
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
      String sql = "SELECT COUNT(" + PstJangkaWaktuFormula.fieldNames[PstJangkaWaktuFormula.FLD_JANGKA_WAKTU_ID] + ") FROM " + TBL_JANGKA_WAKTU_FORMULA;
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
  
	/**
	 *
	 * @param whereClause
	 * @return count of joined list between jangka waktu and jangka waktu formula
	 */
	public static int getCountJoinFormula(String whereClause) {
		DBResultSet dbrs = null;
		int total = 0;
		try {
			String sql = "SELECT COUNT(*) AS COUNT FROM " + TBL_JANGKA_WAKTU_FORMULA + " AS JWF"
					+ " INNER JOIN " + PstJangkaWaktu.TBL_JANGKA_WAKTU + " AS JW"
					+ " ON JWF." + fieldNames[FLD_JANGKA_WAKTU_ID]
					+ " = JW." + PstJangkaWaktu.fieldNames[PstJangkaWaktu.FLD_JANGKA_WAKTU_ID];
			if (whereClause.length() > 0 && whereClause != null) {
				sql += " WHERE " + whereClause;
			}
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while (rs.next()) {
				total = rs.getInt("COUNT");
			}
			rs.close();
		} catch (Exception e) {
			return 0;
		} finally {
			DBResultSet.close(dbrs);
		}
		return total;
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
          JangkaWaktuFormula entJangkaWaktuFormula = (JangkaWaktuFormula) list.get(ls);
          if (oid == entJangkaWaktuFormula.getOID()) {
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
}
