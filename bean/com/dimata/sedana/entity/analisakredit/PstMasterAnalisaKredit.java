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

/**
 *
 * @author arise
 */
public class PstMasterAnalisaKredit extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	public static final String TBL_MASTERANALISAKREDIT = "sedana_master_analisa_kredit";
	public static final int FLD_MASTER_ANALISA_KREDIT_ID = 0;
	public static final int FLD_GROUPID = 1;
	public static final int FLD_ANALISAID = 2;
	public static final int FLD_DESCRIPTION = 3;
	public static final int FLD_CREATEDAT = 4;
	public static final int FLD_UPDATEDAT = 5;

	public static String[] fieldNames = {
		"MASTER_ANALISA_KREDIT_ID",
		"MASTER_GROUP_ANALISA_KREDIT_ID",
		"ANALISA_KREDIT_ID",
		"ANALISA_KREDIT_DESCRIPTION",
		"CREATED_AT",
		"UPDATED_AT"
	};

	public static int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_DATE
	};

	public PstMasterAnalisaKredit() {
	}

	public PstMasterAnalisaKredit(int i) throws DBException {
		super(new PstMasterAnalisaKredit());
	}

	public PstMasterAnalisaKredit(String sOid) throws DBException {
		super(new PstMasterAnalisaKredit(0));
		if (!locate(sOid)) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		} else {
			return;
		}
	}

	public PstMasterAnalisaKredit(long lOid) throws DBException {
		super(new PstMasterAnalisaKredit(0));
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
		return TBL_MASTERANALISAKREDIT;
	}

	public String[] getFieldNames() {
		return fieldNames;
	}

	public int[] getFieldTypes() {
		return fieldTypes;
	}

	public String getPersistentName() {
		return new PstMasterAnalisaKredit().getClass().getName();
	}

	public static MasterAnalisaKredit fetchExc(long oid) throws DBException {
		try {
			MasterAnalisaKredit entMasterAnalisaKredit = new MasterAnalisaKredit();
			PstMasterAnalisaKredit pstMasterAnalisaKredit = new PstMasterAnalisaKredit(oid);
			entMasterAnalisaKredit.setOID(oid);
			entMasterAnalisaKredit.setGroupId(pstMasterAnalisaKredit.getlong(FLD_GROUPID));
			entMasterAnalisaKredit.setAnalisaId(pstMasterAnalisaKredit.getString(FLD_ANALISAID));
			entMasterAnalisaKredit.setDescription(pstMasterAnalisaKredit.getString(FLD_DESCRIPTION));
			entMasterAnalisaKredit.setCreatedAt(pstMasterAnalisaKredit.getDate(FLD_CREATEDAT));
			entMasterAnalisaKredit.setUpdatedAt(pstMasterAnalisaKredit.getDate(FLD_UPDATEDAT));
			return entMasterAnalisaKredit;
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterAnalisaKredit(0), DBException.UNKNOWN);
		}
	}

	public long fetchExc(Entity entity) throws Exception {
		MasterAnalisaKredit entMasterAnalisaKredit = fetchExc(entity.getOID());
		entity = (Entity) entMasterAnalisaKredit;
		return entMasterAnalisaKredit.getOID();
	}

	public static synchronized long updateExc(MasterAnalisaKredit entMasterAnalisaKredit) throws DBException {
		try {
			if (entMasterAnalisaKredit.getOID() != 0) {
				PstMasterAnalisaKredit pstMasterAnalisaKredit = new PstMasterAnalisaKredit(entMasterAnalisaKredit.getOID());
				pstMasterAnalisaKredit.setLong(FLD_GROUPID, entMasterAnalisaKredit.getGroupId());
				pstMasterAnalisaKredit.setString(FLD_ANALISAID, entMasterAnalisaKredit.getAnalisaId());
				pstMasterAnalisaKredit.setString(FLD_DESCRIPTION, entMasterAnalisaKredit.getDescription());
				//pstMasterAnalisaKredit.setDate(FLD_CREATEDAT, entMasterAnalisaKredit.getCreatedAt());
				pstMasterAnalisaKredit.setDate(FLD_UPDATEDAT, entMasterAnalisaKredit.getUpdatedAt());
				pstMasterAnalisaKredit.update();
				return entMasterAnalisaKredit.getOID();
			}
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterAnalisaKredit(0), DBException.UNKNOWN);
		}
		return 0;
	}

	public long updateExc(Entity entity) throws Exception {
		return updateExc((MasterAnalisaKredit) entity);
	}

	public static synchronized long deleteExc(long oid) throws DBException {
		try {
			PstMasterAnalisaKredit pstMasterAnalisaKredit = new PstMasterAnalisaKredit(oid);
			pstMasterAnalisaKredit.delete();
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterAnalisaKredit(0), DBException.UNKNOWN);
		}
		return oid;
	}

	public long deleteExc(Entity entity) throws Exception {
		if (entity == null) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		}
		return deleteExc(entity.getOID());
	}

	public static synchronized long insertExc(MasterAnalisaKredit entMasterAnalisaKredit) throws DBException {
		try {
			PstMasterAnalisaKredit pstMasterAnalisaKredit = new PstMasterAnalisaKredit(0);
			pstMasterAnalisaKredit.setLong(FLD_GROUPID, entMasterAnalisaKredit.getGroupId());
			pstMasterAnalisaKredit.setString(FLD_ANALISAID, entMasterAnalisaKredit.getAnalisaId());
			pstMasterAnalisaKredit.setString(FLD_DESCRIPTION, entMasterAnalisaKredit.getDescription());
			pstMasterAnalisaKredit.setDate(FLD_CREATEDAT, entMasterAnalisaKredit.getCreatedAt());
			pstMasterAnalisaKredit.setDate(FLD_UPDATEDAT, entMasterAnalisaKredit.getUpdatedAt());
			pstMasterAnalisaKredit.insert();
			entMasterAnalisaKredit.setOID(pstMasterAnalisaKredit.getlong(FLD_MASTER_ANALISA_KREDIT_ID));
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstMasterAnalisaKredit(0), DBException.UNKNOWN);
		}
		return entMasterAnalisaKredit.getOID();
	}

	public long insertExc(Entity entity) throws Exception {
		return insertExc((MasterAnalisaKredit) entity);
	}

	public static void resultToObject(ResultSet rs, MasterAnalisaKredit entMasterAnalisaKredit) {
		try {
			entMasterAnalisaKredit.setOID(rs.getLong(PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_MASTER_ANALISA_KREDIT_ID]));
			entMasterAnalisaKredit.setGroupId(rs.getLong(PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_GROUPID]));
			entMasterAnalisaKredit.setAnalisaId(rs.getString(PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_ANALISAID]));
			entMasterAnalisaKredit.setDescription(rs.getString(PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_DESCRIPTION]));
			entMasterAnalisaKredit.setCreatedAt(rs.getDate(PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_CREATEDAT]));
			entMasterAnalisaKredit.setUpdatedAt(rs.getDate(PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_UPDATEDAT]));
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
			String sql = "SELECT * FROM " + TBL_MASTERANALISAKREDIT;
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
				MasterAnalisaKredit entMasterAnalisaKredit = new MasterAnalisaKredit();
				resultToObject(rs, entMasterAnalisaKredit);
				lists.add(entMasterAnalisaKredit);
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
	
	public static Vector listJoinMasterGroup(int limitStart, int recordToGet, String whereClause, String order){
		Vector lists = new Vector();
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + TBL_MASTERANALISAKREDIT 
					+ " INNER JOIN " + PstMasterGroupAnalisaKredit.TBL_MASTERGROUPANALISAKREDIT 
					+ " ON " + TBL_MASTERANALISAKREDIT + "." + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_GROUPID] 
					+ " = " + PstMasterGroupAnalisaKredit.TBL_MASTERGROUPANALISAKREDIT + "." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_MASTER_GROUP_ID];
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
				Vector temp = new Vector(1,1);
				MasterAnalisaKredit entMasterAnalisaKredit = new MasterAnalisaKredit();
				MasterGroupAnalisaKredit mgak = new MasterGroupAnalisaKredit();
				resultToObject(rs, entMasterAnalisaKredit);
				PstMasterGroupAnalisaKredit.resultToObject(rs, mgak);
				temp.add(entMasterAnalisaKredit);
				temp.add(mgak);
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

	public static int getCountJoinMasterGroup(String whereClause){
		int count = 0;
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT(*) AS COUNT FROM " + TBL_MASTERANALISAKREDIT 
					+ " INNER JOIN " + PstMasterGroupAnalisaKredit.TBL_MASTERGROUPANALISAKREDIT
					+ " ON " + TBL_MASTERANALISAKREDIT + "." + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_GROUPID] 
					+ " = " + PstMasterGroupAnalisaKredit.TBL_MASTERGROUPANALISAKREDIT + "." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_MASTER_GROUP_ID];
			if (whereClause != null && whereClause.length() > 0) {
				sql = sql + " WHERE " + whereClause;
			}
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while (rs.next()) {
				count = rs.getInt("COUNT");
			}
			rs.close();
		} catch (Exception e) {
			System.out.println(e);
		} finally {
			DBResultSet.close(dbrs);
		}
		return count;
	}
	
	public static boolean checkOID(long entMasterAnalisaKreditId) {
		DBResultSet dbrs = null;
		boolean result = false;
		try {
			String sql = "SELECT * FROM " + TBL_MASTERANALISAKREDIT + " WHERE "
					+ PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_MASTER_ANALISA_KREDIT_ID] + " = " + entMasterAnalisaKreditId;
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
			String sql = "SELECT COUNT(" + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_MASTER_ANALISA_KREDIT_ID] + ") FROM " + TBL_MASTERANALISAKREDIT;
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
					MasterAnalisaKredit entMasterAnalisaKredit = (MasterAnalisaKredit) list.get(ls);
					if (oid == entMasterAnalisaKredit.getOID()) {
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
			String sql = "SELECT COUNT(" + fieldNames[FLD_ANALISAID] + ") FROM " + TBL_MASTERANALISAKREDIT
					+ " WHERE " + fieldNames[FLD_ANALISAID] + " IN ('" + id + "')";
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
			String sql = "SELECT COUNT(" + PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_MASTERANALISAKREDITID] + ")"
					+ " FROM " + PstAnalisaKreditDetail.TBL_ANALISAKREDITDETAIL
					+ " WHERE " + PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_MASTERANALISAKREDITID] + " IN (" + oid + ")";
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
