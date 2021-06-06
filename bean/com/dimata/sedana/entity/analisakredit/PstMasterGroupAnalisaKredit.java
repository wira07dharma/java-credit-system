/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dimata.sedana.entity.analisakredit;

/**
 *
 * @author arise
 */
import java.sql.*;
import com.dimata.util.lang.I_Language;
import com.dimata.qdep.db.*;
import com.dimata.qdep.entity.*;
import com.dimata.util.Command;
import java.util.Vector;

public class PstMasterGroupAnalisaKredit extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	public static final String TBL_MASTERGROUPANALISAKREDIT = "sedana_master_group_analisa_kredit";
	public static final int FLD_MASTER_GROUP_ID = 0;
	public static final int FLD_GROUP_ID = 1;
	public static final int FLD_GROUP_DESCRIPTION = 2;
	public static final int FLD_GROUP_BOBOT = 3;
	public static final int FLD_GROUP_MIN = 4;
	public static final int FLD_GROUP_MAX = 5;
	public static final int FLD_CREATED_AT = 6;
	public static final int FLD_UPDATED_AT = 7;

	public static String[] fieldNames = {
		"MASTER_GROUP_ID",
		"GROUP_ID",
		"GROUP_DESCRIPTION",
		"GROUP_BOBOT",
		"GROUP_MIN",
		"GROUP_MAX",
		"CREATED_AT",
		"UPDATED_AT"
	};

	public static int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_INT,
		TYPE_INT,
		TYPE_DATE,
		TYPE_DATE
	};

	public PstMasterGroupAnalisaKredit() {
	}

	public PstMasterGroupAnalisaKredit(int i) throws DBException {
		super(new PstMasterGroupAnalisaKredit());
	}

	public PstMasterGroupAnalisaKredit(String sOid) throws DBException {
		super(new PstMasterGroupAnalisaKredit(0));
		if (!locate(sOid)) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		} else {
			return;
		}
	}

	public PstMasterGroupAnalisaKredit(long lOid) throws DBException {
		super(new PstMasterGroupAnalisaKredit(0));
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
		return TBL_MASTERGROUPANALISAKREDIT;
	}

	public String[] getFieldNames() {
		return fieldNames;
	}

	public int[] getFieldTypes() {
		return fieldTypes;
	}

	public String getPersistentName() {
		return new PstMasterGroupAnalisaKredit().getClass().getName();
	}

	public static MasterGroupAnalisaKredit fetchExc(long oid) throws DBException {
		try {
			MasterGroupAnalisaKredit entMasterGroupAnalisaKredit = new MasterGroupAnalisaKredit();
			PstMasterGroupAnalisaKredit pstMasterGroupAnalisaKredit = new PstMasterGroupAnalisaKredit(oid);
			entMasterGroupAnalisaKredit.setOID(oid);
			entMasterGroupAnalisaKredit.setGroupId(pstMasterGroupAnalisaKredit.getString(FLD_GROUP_ID));
			entMasterGroupAnalisaKredit.setGroupDesc(pstMasterGroupAnalisaKredit.getString(FLD_GROUP_DESCRIPTION));
			entMasterGroupAnalisaKredit.setGroupBobot(pstMasterGroupAnalisaKredit.getInt(FLD_GROUP_BOBOT));
			entMasterGroupAnalisaKredit.setGroupMin(pstMasterGroupAnalisaKredit.getInt(FLD_GROUP_MIN));
			entMasterGroupAnalisaKredit.setGroupMax(pstMasterGroupAnalisaKredit.getInt(FLD_GROUP_MAX));
			entMasterGroupAnalisaKredit.setCreatedAt(pstMasterGroupAnalisaKredit.getDate(FLD_CREATED_AT));
			entMasterGroupAnalisaKredit.setUpdatedAt(pstMasterGroupAnalisaKredit.getDate(FLD_UPDATED_AT));
			return entMasterGroupAnalisaKredit;
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterGroupAnalisaKredit(0), DBException.UNKNOWN);
		}
	}

	public long fetchExc(Entity entity) throws Exception {
		MasterGroupAnalisaKredit entMasterGroupAnalisaKredit = fetchExc(entity.getOID());
		entity = (Entity) entMasterGroupAnalisaKredit;
		return entMasterGroupAnalisaKredit.getOID();
	}

	public static synchronized long updateExc(MasterGroupAnalisaKredit entMasterGroupAnalisaKredit) throws DBException {
		try {
			if (entMasterGroupAnalisaKredit.getOID() != 0) {
				PstMasterGroupAnalisaKredit pstMasterGroupAnalisaKredit = new PstMasterGroupAnalisaKredit(entMasterGroupAnalisaKredit.getOID());
				pstMasterGroupAnalisaKredit.setString(FLD_GROUP_ID, entMasterGroupAnalisaKredit.getGroupId());
				pstMasterGroupAnalisaKredit.setString(FLD_GROUP_DESCRIPTION, entMasterGroupAnalisaKredit.getGroupDesc());
				pstMasterGroupAnalisaKredit.setInt(FLD_GROUP_BOBOT, entMasterGroupAnalisaKredit.getGroupBobot());
				pstMasterGroupAnalisaKredit.setInt(FLD_GROUP_MIN, entMasterGroupAnalisaKredit.getGroupMin());
				pstMasterGroupAnalisaKredit.setInt(FLD_GROUP_MAX, entMasterGroupAnalisaKredit.getGroupMax());
				//pstMasterGroupAnalisaKredit.setDate(FLD_CREATED_AT, entMasterGroupAnalisaKredit.getCreatedAt());
				pstMasterGroupAnalisaKredit.setDate(FLD_UPDATED_AT, entMasterGroupAnalisaKredit.getUpdatedAt());
				pstMasterGroupAnalisaKredit.update();
				return entMasterGroupAnalisaKredit.getOID();
			}
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterGroupAnalisaKredit(0), DBException.UNKNOWN);
		}
		return 0;
	}

	public long updateExc(Entity entity) throws Exception {
		return updateExc((MasterGroupAnalisaKredit) entity);
	}

	public static synchronized long deleteExc(long oid) throws DBException {
		try {
			PstMasterGroupAnalisaKredit pstMasterGroupAnalisaKredit = new PstMasterGroupAnalisaKredit(oid);
			pstMasterGroupAnalisaKredit.delete();
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterGroupAnalisaKredit(0), DBException.UNKNOWN);
		}
		return oid;
	}

	public long deleteExc(Entity entity) throws Exception {
		if (entity == null) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		}
		return deleteExc(entity.getOID());
	}

	public static synchronized long insertExc(MasterGroupAnalisaKredit entMasterGroupAnalisaKredit) throws DBException {
		try {
			PstMasterGroupAnalisaKredit pstMasterGroupAnalisaKredit = new PstMasterGroupAnalisaKredit(0);
			pstMasterGroupAnalisaKredit.setString(FLD_GROUP_ID, entMasterGroupAnalisaKredit.getGroupId());
			pstMasterGroupAnalisaKredit.setString(FLD_GROUP_DESCRIPTION, entMasterGroupAnalisaKredit.getGroupDesc());
			pstMasterGroupAnalisaKredit.setInt(FLD_GROUP_BOBOT, entMasterGroupAnalisaKredit.getGroupBobot());
			pstMasterGroupAnalisaKredit.setInt(FLD_GROUP_MIN, entMasterGroupAnalisaKredit.getGroupMin());
			pstMasterGroupAnalisaKredit.setInt(FLD_GROUP_MAX, entMasterGroupAnalisaKredit.getGroupMax());
			pstMasterGroupAnalisaKredit.setDate(FLD_CREATED_AT, entMasterGroupAnalisaKredit.getCreatedAt());
			pstMasterGroupAnalisaKredit.setDate(FLD_UPDATED_AT, entMasterGroupAnalisaKredit.getUpdatedAt());
			pstMasterGroupAnalisaKredit.insert();
			entMasterGroupAnalisaKredit.setOID(pstMasterGroupAnalisaKredit.getlong(FLD_MASTER_GROUP_ID));
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterGroupAnalisaKredit(0), DBException.UNKNOWN);
		}
		return entMasterGroupAnalisaKredit.getOID();
	}

	public long insertExc(Entity entity) throws Exception {
		return insertExc((MasterGroupAnalisaKredit) entity);
	}

	public static void resultToObject(ResultSet rs, MasterGroupAnalisaKredit entMasterGroupAnalisaKredit) {
		try {
			entMasterGroupAnalisaKredit.setOID(rs.getLong(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_MASTER_GROUP_ID]));
			entMasterGroupAnalisaKredit.setGroupId(rs.getString(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_ID]));
			entMasterGroupAnalisaKredit.setGroupDesc(rs.getString(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION]));
			entMasterGroupAnalisaKredit.setGroupBobot(rs.getInt(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_BOBOT]));
			entMasterGroupAnalisaKredit.setGroupMin(rs.getInt(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_MIN]));
			entMasterGroupAnalisaKredit.setGroupMax(rs.getInt(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_MAX]));
			entMasterGroupAnalisaKredit.setCreatedAt(rs.getDate(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_CREATED_AT]));
			entMasterGroupAnalisaKredit.setUpdatedAt(rs.getDate(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_UPDATED_AT]));
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
			String sql = "SELECT * FROM " + TBL_MASTERGROUPANALISAKREDIT;
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
				MasterGroupAnalisaKredit entMasterGroupAnalisaKredit = new MasterGroupAnalisaKredit();
				resultToObject(rs, entMasterGroupAnalisaKredit);
				lists.add(entMasterGroupAnalisaKredit);
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

	public static boolean checkOID(long entMasterGroupAnalisaKreditId) {
		DBResultSet dbrs = null;
		boolean result = false;
		try {
			String sql = "SELECT * FROM " + TBL_MASTERGROUPANALISAKREDIT + " WHERE "
					+ PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_MASTER_GROUP_ID] + " = " + entMasterGroupAnalisaKreditId;
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
			String sql = "SELECT COUNT(" + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_MASTER_GROUP_ID] + ") FROM " + TBL_MASTERGROUPANALISAKREDIT;
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
					MasterGroupAnalisaKredit entMasterGroupAnalisaKredit = (MasterGroupAnalisaKredit) list.get(ls);
					if (oid == entMasterGroupAnalisaKredit.getOID()) {
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
	
	public static boolean checkMasterId(String id){
		boolean result = false;
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT(" + fieldNames[FLD_GROUP_ID] + ") FROM " + TBL_MASTERGROUPANALISAKREDIT
					+ " WHERE " + fieldNames[FLD_GROUP_ID] + " IN ('" + id + "')";
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			int count = 0;
			while (rs.next()) {
				count = rs.getInt(1);
			}
			if(count > 0){
				result = true;
			}
			rs.close();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			DBResultSet.close(dbrs);
		}
		return result;
	}
	
	public static boolean checkMasterUsed(long oid){
		boolean result = false;
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT(" + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_GROUPID] + ")"
					+ " FROM " + PstMasterAnalisaKredit.TBL_MASTERANALISAKREDIT
					+ " WHERE " + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_GROUPID] + " IN (" + oid + ")";
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			int count = 0;
			while (rs.next()) {
				count = rs.getInt(1);
			}
			if(count > 0){
				result = true;
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
