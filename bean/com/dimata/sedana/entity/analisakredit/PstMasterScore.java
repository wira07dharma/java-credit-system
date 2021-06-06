/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.analisakredit;

import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;

public class PstMasterScore extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	public static final String TBL_MASTERSCORE = "sedana_master_group_score";
	public static final int FLD_MASTER_SCORE_OID = 0;
	public static final int FLD_GROUP_ID = 1;
	public static final int FLD_SCORE_MIN = 2;
	public static final int FLD_SCORE_MAX = 3;
	public static final int FLD_DESCRIPTION = 4;

	public static String[] fieldNames = {
		"MASTER_SCORE_OID",
		"GROUP_OID",
		"SCORE_MIN",
		"SCORE_MAX",
		"DESCRIPTION"
	};

	public static int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_STRING
	};

	public PstMasterScore() {
	}

	public PstMasterScore(int i) throws DBException {
		super(new PstMasterScore());
	}

	public PstMasterScore(String sOid) throws DBException {
		super(new PstMasterScore(0));
		if (!locate(sOid)) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		} else {
			return;
		}
	}

	public PstMasterScore(long lOid) throws DBException {
		super(new PstMasterScore(0));
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
		return TBL_MASTERSCORE;
	}

	public String[] getFieldNames() {
		return fieldNames;
	}

	public int[] getFieldTypes() {
		return fieldTypes;
	}

	public String getPersistentName() {
		return new PstMasterScore().getClass().getName();
	}

	public static MasterScore fetchExc(long oid) throws DBException {
		try {
			MasterScore entMasterScore = new MasterScore();
			PstMasterScore pstMasterScore = new PstMasterScore(oid);
			entMasterScore.setOID(oid);
			entMasterScore.setScoreMin(pstMasterScore.getdouble(FLD_SCORE_MIN)); 
			entMasterScore.setScoreMax(pstMasterScore.getdouble(FLD_SCORE_MAX)); 
			entMasterScore.setDescription(pstMasterScore.getString(FLD_DESCRIPTION));
			entMasterScore.setGroupId(pstMasterScore.getlong(FLD_GROUP_ID));
			return entMasterScore;
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterScore(0), DBException.UNKNOWN);
		}
	}

	public long fetchExc(Entity entity) throws Exception {
		MasterScore entMasterScore = fetchExc(entity.getOID());
		entity = (Entity) entMasterScore;
		return entMasterScore.getOID();
	}

	public static synchronized long updateExc(MasterScore entMasterScore) throws DBException {
		try {
			if (entMasterScore.getOID() != 0) {
				PstMasterScore pstMasterScore = new PstMasterScore(entMasterScore.getOID());
				pstMasterScore.setDouble(FLD_SCORE_MIN, entMasterScore.getScoreMin());
				pstMasterScore.setDouble(FLD_SCORE_MAX, entMasterScore.getScoreMax());
				pstMasterScore.setString(FLD_DESCRIPTION, entMasterScore.getDescription());
				pstMasterScore.setLong(FLD_GROUP_ID, entMasterScore.getGroupId());
				pstMasterScore.update();
				return entMasterScore.getOID();
			}
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterScore(0), DBException.UNKNOWN);
		}
		return 0;
	}

	public long updateExc(Entity entity) throws Exception {
		return updateExc((MasterScore) entity);
	}

	public static synchronized long deleteExc(long oid) throws DBException {
		try {
			PstMasterScore pstMasterScore = new PstMasterScore(oid);
			pstMasterScore.delete();
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterScore(0), DBException.UNKNOWN);
		}
		return oid;
	}

	public long deleteExc(Entity entity) throws Exception {
		if (entity == null) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		}
		return deleteExc(entity.getOID());
	}

	public static synchronized long insertExc(MasterScore entMasterScore) throws DBException {
		try {
			PstMasterScore pstMasterScore = new PstMasterScore(0);
			pstMasterScore.setDouble(FLD_SCORE_MIN, entMasterScore.getScoreMin());
			pstMasterScore.setDouble(FLD_SCORE_MAX, entMasterScore.getScoreMax());
			pstMasterScore.setString(FLD_DESCRIPTION, entMasterScore.getDescription());
			pstMasterScore.setLong(FLD_GROUP_ID, entMasterScore.getGroupId());
			pstMasterScore.insert();
			entMasterScore.setOID(pstMasterScore.getlong(FLD_MASTER_SCORE_OID));
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterScore(0), DBException.UNKNOWN);
		}
		return entMasterScore.getOID();
	}

	public long insertExc(Entity entity) throws Exception {
		return insertExc((MasterScore) entity);
	}

	public static void resultToObject(ResultSet rs, MasterScore entMasterScore) {
		try {
			entMasterScore.setOID(rs.getLong(PstMasterScore.fieldNames[PstMasterScore.FLD_MASTER_SCORE_OID]));
			entMasterScore.setScoreMin(rs.getDouble(PstMasterScore.fieldNames[PstMasterScore.FLD_SCORE_MIN])); 
			entMasterScore.setScoreMax(rs.getDouble(PstMasterScore.fieldNames[PstMasterScore.FLD_SCORE_MAX])); 
			entMasterScore.setDescription(rs.getString(PstMasterScore.fieldNames[PstMasterScore.FLD_DESCRIPTION]));
			entMasterScore.setGroupId(rs.getLong(PstMasterScore.fieldNames[PstMasterScore.FLD_GROUP_ID]));
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
			String sql = "SELECT * FROM " + TBL_MASTERSCORE;
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
				MasterScore entMasterScore = new MasterScore();
				resultToObject(rs, entMasterScore);
				lists.add(entMasterScore);
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

	public static boolean checkOID(long entMasterScoreId) {
		DBResultSet dbrs = null;
		boolean result = false;
		try {
			String sql = "SELECT * FROM " + TBL_MASTERSCORE + " WHERE "
					+ PstMasterScore.fieldNames[PstMasterScore.FLD_MASTER_SCORE_OID] + " = " + entMasterScoreId;
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
			String sql = "SELECT COUNT(" + PstMasterScore.fieldNames[PstMasterScore.FLD_MASTER_SCORE_OID] + ") FROM " + TBL_MASTERSCORE;
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
					MasterScore entMasterScore = (MasterScore) list.get(ls);
					if (oid == entMasterScore.getOID()) {
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
	
	public static String calculateScore(long groupOid, double score){
		String result = "";
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT " + fieldNames[FLD_DESCRIPTION] + " FROM " + TBL_MASTERSCORE
					+ " WHERE " + fieldNames[FLD_GROUP_ID] + " = " + groupOid 
					+ " AND (" + score + " BETWEEN " + fieldNames[FLD_SCORE_MIN] + " AND " + fieldNames[FLD_SCORE_MAX] + ")";
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while (rs.next()) {
				result = rs.getString(fieldNames[FLD_DESCRIPTION]);
			}
			rs.close();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			DBResultSet.close(dbrs);
		}
		return result;
	}
	
}
