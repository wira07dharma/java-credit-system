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
import java.util.ArrayList;
import java.util.Vector;

public class PstAnalisaKreditDetail extends DBHandler implements I_DBInterface, I_DBType, I_PersintentExc, I_Language {

	public static final String TBL_ANALISAKREDITDETAIL = "sedana_analisa_kredit_detail";
	public static final int FLD_ANALISAKREDITDETAILID = 0;
	public static final int FLD_ANALISAKREDITMAINID = 1;
	public static final int FLD_MASTERANALISAKREDITID = 2;
	public static final int FLD_NILAI = 3;
	public static final int FLD_NOTES = 4;

	public static String[] fieldNames = {
		"ANALISA_KREDIT_DETAIL_ID",
		"ANALISA_KREDIT_MAIN_ID",
		"MASTER_ANALISA_KREDIT_ID",
		"NILAI",
		"NOTES"
	};

	public static int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_STRING
	};

	public PstAnalisaKreditDetail() {
	}

	public PstAnalisaKreditDetail(int i) throws DBException {
		super(new PstAnalisaKreditDetail());
	}

	public PstAnalisaKreditDetail(String sOid) throws DBException {
		super(new PstAnalisaKreditDetail(0));
		if (!locate(sOid)) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		} else {
			return;
		}
	}

	public PstAnalisaKreditDetail(long lOid) throws DBException {
		super(new PstAnalisaKreditDetail(0));
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
		return TBL_ANALISAKREDITDETAIL;
	}

	public String[] getFieldNames() {
		return fieldNames;
	}

	public int[] getFieldTypes() {
		return fieldTypes;
	}

	public String getPersistentName() {
		return new PstAnalisaKreditDetail().getClass().getName();
	}

	public static AnalisaKreditDetail fetchExc(long oid) throws DBException {
		try {
			AnalisaKreditDetail entAnalisaKreditDetail = new AnalisaKreditDetail();
			PstAnalisaKreditDetail pstAnalisaKreditDetail = new PstAnalisaKreditDetail(oid);
			entAnalisaKreditDetail.setOID(oid);
			entAnalisaKreditDetail.setAnalisaKreditMainId(pstAnalisaKreditDetail.getlong(FLD_ANALISAKREDITMAINID));
			entAnalisaKreditDetail.setMasterAnalisaKreditId(pstAnalisaKreditDetail.getlong(FLD_MASTERANALISAKREDITID));
			entAnalisaKreditDetail.setNilai(pstAnalisaKreditDetail.getdouble(FLD_NILAI));
			entAnalisaKreditDetail.setNotes(pstAnalisaKreditDetail.getString(FLD_NOTES));
			return entAnalisaKreditDetail;
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstAnalisaKreditDetail(0), DBException.UNKNOWN);
		}
	}

	public long fetchExc(Entity entity) throws Exception {
		AnalisaKreditDetail entAnalisaKreditDetail = fetchExc(entity.getOID());
		entity = (Entity) entAnalisaKreditDetail;
		return entAnalisaKreditDetail.getOID();
	}

	public static synchronized long updateExc(AnalisaKreditDetail entAnalisaKreditDetail) throws DBException {
		try {
			if (entAnalisaKreditDetail.getOID() != 0) {
				PstAnalisaKreditDetail pstAnalisaKreditDetail = new PstAnalisaKreditDetail(entAnalisaKreditDetail.getOID());
				pstAnalisaKreditDetail.setLong(FLD_ANALISAKREDITMAINID, entAnalisaKreditDetail.getAnalisaKreditMainId());
				pstAnalisaKreditDetail.setLong(FLD_MASTERANALISAKREDITID, entAnalisaKreditDetail.getMasterAnalisaKreditId());
				pstAnalisaKreditDetail.setDouble(FLD_NILAI, entAnalisaKreditDetail.getNilai());
				pstAnalisaKreditDetail.setString(FLD_NOTES, entAnalisaKreditDetail.getNotes());
				pstAnalisaKreditDetail.update();
				return entAnalisaKreditDetail.getOID();
			}
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstAnalisaKreditDetail(0), DBException.UNKNOWN);
		}
		return 0;
	}

	public long updateExc(Entity entity) throws Exception {
		return updateExc((AnalisaKreditDetail) entity);
	}

	public static synchronized long deleteExc(long oid) throws DBException {
		try {
			PstAnalisaKreditDetail pstAnalisaKreditDetail = new PstAnalisaKreditDetail(oid);
			pstAnalisaKreditDetail.delete();
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstAnalisaKreditDetail(0), DBException.UNKNOWN);
		}
		return oid;
	}

	public long deleteExc(Entity entity) throws Exception {
		if (entity == null) {
			throw new DBException(this, DBException.RECORD_NOT_FOUND);
		}
		return deleteExc(entity.getOID());
	}

	public static synchronized long insertExc(AnalisaKreditDetail entAnalisaKreditDetail) throws DBException {
		try {
			PstAnalisaKreditDetail pstAnalisaKreditDetail = new PstAnalisaKreditDetail(0);
			pstAnalisaKreditDetail.setLong(FLD_ANALISAKREDITMAINID, entAnalisaKreditDetail.getAnalisaKreditMainId());
			pstAnalisaKreditDetail.setLong(FLD_MASTERANALISAKREDITID, entAnalisaKreditDetail.getMasterAnalisaKreditId());
			pstAnalisaKreditDetail.setDouble(FLD_NILAI, entAnalisaKreditDetail.getNilai());
			pstAnalisaKreditDetail.setString(FLD_NOTES, entAnalisaKreditDetail.getNotes());
			pstAnalisaKreditDetail.insert();
			entAnalisaKreditDetail.setOID(pstAnalisaKreditDetail.getlong(FLD_ANALISAKREDITDETAILID));
		} catch (DBException dbe) {
			throw dbe;
		} catch (Exception e) {
			throw new DBException(new PstAnalisaKreditDetail(0), DBException.UNKNOWN);
		}
		return entAnalisaKreditDetail.getOID();
	}

	public long insertExc(Entity entity) throws Exception {
		return insertExc((AnalisaKreditDetail) entity);
	}

	public static void resultToObject(ResultSet rs, AnalisaKreditDetail entAnalisaKreditDetail) {
		try {
			entAnalisaKreditDetail.setOID(rs.getLong(PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_ANALISAKREDITDETAILID]));
			entAnalisaKreditDetail.setAnalisaKreditMainId(rs.getLong(PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_ANALISAKREDITMAINID]));
			entAnalisaKreditDetail.setMasterAnalisaKreditId(rs.getLong(PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_MASTERANALISAKREDITID]));
			entAnalisaKreditDetail.setNilai(rs.getDouble(PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_NILAI]));
			entAnalisaKreditDetail.setNotes(rs.getString(PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_NOTES]));
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
			String sql = "SELECT * FROM " + TBL_ANALISAKREDITDETAIL;
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
				AnalisaKreditDetail entAnalisaKreditDetail = new AnalisaKreditDetail();
				resultToObject(rs, entAnalisaKreditDetail);
				lists.add(entAnalisaKreditDetail);
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

	public static Vector listDetailJoinMaster(int limitStart, int recordToGet, String whereClause, String order) {
		Vector lists = new Vector();
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + TBL_ANALISAKREDITDETAIL 
					+ " INNER JOIN " + PstMasterAnalisaKredit.TBL_MASTERANALISAKREDIT
					+ " ON " + TBL_ANALISAKREDITDETAIL + "." + PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_MASTERANALISAKREDITID] 
					+ " = " + PstMasterAnalisaKredit.TBL_MASTERANALISAKREDIT + "." + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_MASTER_ANALISA_KREDIT_ID];
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
				AnalisaKreditDetail entAnalisaKreditDetail = new AnalisaKreditDetail();
				MasterAnalisaKredit mak = new MasterAnalisaKredit();
				resultToObject(rs, entAnalisaKreditDetail);
				PstMasterAnalisaKredit.resultToObject(rs, mak);
				
				temp.add(entAnalisaKreditDetail);
				temp.add(mak);
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
	
	public static Vector listNilaiForm(long oid){
		Vector res = new Vector();
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT AKD."+ fieldNames[FLD_ANALISAKREDITDETAILID]
					+ " ,MGAK." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION] 
					+ " ,MAK." + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_DESCRIPTION]
					+ " ,AKD." + fieldNames[FLD_NILAI]
					+ " ,MGAK." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_BOBOT]
					+ " ,AKD."+ fieldNames[FLD_NILAI] +"*MGAK." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_BOBOT] + "/100 AS SCORE"
					+ " ,AKD." + fieldNames[FLD_NOTES]
					+ " ,AKM." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISA_STATUS]
					+ " FROM " + TBL_ANALISAKREDITDETAIL + " AS AKD"
					+ " INNER JOIN " + PstMasterAnalisaKredit.TBL_MASTERANALISAKREDIT + " AS MAK"
					+ " ON AKD." + fieldNames[FLD_MASTERANALISAKREDITID]
					+ " = MAK." + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_MASTER_ANALISA_KREDIT_ID] 
					+ " INNER JOIN " + PstMasterGroupAnalisaKredit.TBL_MASTERGROUPANALISAKREDIT + " AS MGAK"
					+ " ON MAK." + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_GROUPID] 
					+ " = MGAK." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_MASTER_GROUP_ID]
					+ " INNER JOIN " + PstAnalisaKreditMain.TBL_ANALISAKREDITMAIN + " AS AKM"
					+ " ON AKM." + PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISAKREDITMAINID]
					+ " = AKD." + fieldNames[FLD_ANALISAKREDITMAINID]
					+ " WHERE AKD." + fieldNames[FLD_ANALISAKREDITMAINID] + " = " + oid
					+ " ORDER BY MGAK." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_ID];
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()){
				Vector temp = new Vector();
				temp.add(rs.getString(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION])); // 0
				temp.add(rs.getString(PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_DESCRIPTION])); // 1
				temp.add(rs.getInt(fieldNames[FLD_NILAI])); // 2
				temp.add(rs.getInt(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_BOBOT])); // 3
				temp.add(rs.getDouble("SCORE")); // 4
				temp.add(rs.getString(fieldNames[FLD_NOTES])); // 5
				temp.add(rs.getLong(fieldNames[FLD_ANALISAKREDITDETAILID])); // 6
				temp.add(rs.getInt(PstAnalisaKreditMain.fieldNames[PstAnalisaKreditMain.FLD_ANALISA_STATUS]));//7
				res.add(temp);
			}
			rs.close();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return res;
	}
	
	public static boolean checkOID(long entAnalisaKreditDetailId) {
		DBResultSet dbrs = null;
		boolean result = false;
		try {
			String sql = "SELECT * FROM " + TBL_ANALISAKREDITDETAIL + " WHERE "
					+ PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_ANALISAKREDITDETAILID] + " = " + entAnalisaKreditDetailId;
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
			String sql = "SELECT COUNT(" + PstAnalisaKreditDetail.fieldNames[PstAnalisaKreditDetail.FLD_ANALISAKREDITDETAILID] + ") FROM " + TBL_ANALISAKREDITDETAIL;
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
					AnalisaKreditDetail entAnalisaKreditDetail = (AnalisaKreditDetail) list.get(ls);
					if (oid == entAnalisaKreditDetail.getOID()) {
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
	
	public static ArrayList calculateAnalystResult(long oid){
		ArrayList res = new ArrayList();
		DBResultSet dbrs = null;
		try {
			String sql = "SELECT MGAK."+ PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_MASTER_GROUP_ID]
					+ " ,MGAK." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION] 
					+ " ,SUM(AKD." + fieldNames[FLD_NILAI] + ") AS TOTAL_NILAI"
					+ " ,MGAK." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_BOBOT]
					+ " ,SUM(AKD."+ fieldNames[FLD_NILAI] +")*MGAK." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_BOBOT] + "/100 AS SCORE"
					+ " FROM " + TBL_ANALISAKREDITDETAIL + " AS AKD"
					+ " INNER JOIN " + PstMasterAnalisaKredit.TBL_MASTERANALISAKREDIT + " MAK"
					+ " ON AKD." + fieldNames[FLD_MASTERANALISAKREDITID]
					+ " = MAK." + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_MASTER_ANALISA_KREDIT_ID] 
					+ " INNER JOIN " + PstMasterGroupAnalisaKredit.TBL_MASTERGROUPANALISAKREDIT + " MGAK"
					+ " ON MAK." + PstMasterAnalisaKredit.fieldNames[PstMasterAnalisaKredit.FLD_GROUPID] 
					+ " = MGAK." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_MASTER_GROUP_ID]
					+ " WHERE AKD." + fieldNames[FLD_ANALISAKREDITMAINID] + " = " + oid
					+ " GROUP BY MGAK." + PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_ID];
			dbrs = DBHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()){
				ArrayList temp = new ArrayList();
				temp.add(rs.getString(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_DESCRIPTION]));
				temp.add(rs.getDouble("TOTAL_NILAI"));
				temp.add(rs.getInt(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_GROUP_BOBOT]));
				temp.add(rs.getDouble("SCORE"));
				temp.add(rs.getLong(PstMasterGroupAnalisaKredit.fieldNames[PstMasterGroupAnalisaKredit.FLD_MASTER_GROUP_ID]));
				res.add(temp);
			}
			rs.close();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return res;
	}
}
